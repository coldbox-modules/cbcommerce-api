component {
    
    this.name = "cbCommerce";
    this.author = "Jon Clausen <jclausen@ortussolutions.com>";
    this.webUrl = "https://github.com/jclausen/cbCommerce";
    this.dependencies = [ "quick", "cfmigrations", "cffractal", "cbstorages", "BCrypt", "cbsecurity" ];
    this.cfmapping = "cbc";
    this.modelNamespace	= "cbc";
    this.entryPoint = "store";
    this.dependencies = [
        "cbauth",
        "cbguard",
        "quick",
        "cfmigrations",
        "cffractal",
        "cbstorages",
        "cbsecurity",
        "BCrypt"
    ];

    function configure() {
        settings = {
            "products" : {
                // Allows for the configuration of an external products model, to interface with existing databases 
                "externalModel"        : false,
                "externalModelBinding" : "",
                "externalModelMapping" : {},
                "defaultCurrency"      : "USD"
            },
            "media" : {
                //local or s3 storage currently supported
                "driver" : getEnv( 'CBC_MEDIA_DRIVER', 'local' ),
                // for local drivers, this would be the path from the root of the site
                "storageLocation" : "/includes/shared/cbc",
                // Only used for s3 driver
                "s3" : {
                    "key"    :   getEnv('AWS_ACCESS_KEY_ID',     ''),
                    "secret" :   getEnv('AWS_SECRET_ACCESS_KEY', ''),
                    "region" :   getEnv('AWS_DEFAULT_REGION',    ''),
                    "bucket" :   getEnv('AWS_BUCKET',            ''),
                    // the AWS base URL for serving assets ( e.g. cloudflare )
                    "url"    :   getEnv('AWS_URL',               ''),
                },
                //the security service - may be changed to use a different wirebox mapping ( e.g. - ContentBox )
                "securityService" : "SecurityService@cbc"
            },
            "payments" : {
                "processor" : {
                    "default" : "StripeProcessor@cbc",
                    "credentials" : {
                        //credentials will vary, depending on the implmented processor
                    }
                }
            }
            // An optional "storage" key may be provided which specifies custom cb storage and matches the settings structure of that module
        };

        // Custom Declared Interceptors
		interceptors = [
			{  
					class="cbc.interceptors.CBCQuickEntity",
					name="CBCQuickEntityInterceptor"
            },
			{  
					class="cbc.interceptors.CBCAPIHelper",
					name="CBCAPIHelperInterceptor"
			}
        ];
        
        // API Routing
        // Custom routes
        router.route( "api/v1/authentication" )
                .withAction( {
                    GET : "get",
                    POST : "create",
                    DELETE : "delete"
                } )
                .toHandler( "API.v1.Authentication" );
        
        router.route( "api/v1/cart" )
                .withAction("get")
                .toHandler( "API.v1.Cart" );

        router.route( "api/v1/cart/:itemId" )
                .withAction(
                    {
                        "PUT" : "addItem",
                        "PATCH" : "addItem"
                    }
                )
                .toHandler( "API.v1.Cart" );

        // Resource Routes ( auto-magic method conventions )
        router
            .resources( 
                resource   = "api/v1/products",
                handler    = "API.v1.Products"
            )
            .resources(
                resource = "api/v1/skus",
                handler  = "API.v1.ProductSKUs"
            )
            .resources( 
                resource   = "api/v1/product-categories",
                handler    = "API.v1.ProductCategories"
            )
            .resources( 
                resource   = "api/v1/product-inventory",
                handler    = "API.v1.ProductInventory"
            )
            .resources(
                resource   = "api/v1/orders",
                handler    = "API.v1.Orders"
            )
            .resources(
                resource   = "api/v1/customers",
                handler    = "API.v1.Customers"
            )
            .resources(
                resource   = "api/v1/payments",
                handler    = "API.v1.Payments"
            );

            /**
             * Display routing
             */
            router.route( "/:action?" )
                .toHandler( "Main" );
    }

    function onLoad() {
        //change our binder mapping 
        if( settings.products.externalModel ){
            binder
                .map( 
                    alias = "ExternalProduct@cbc", 
                    force = true 
                ).to( settings.products.externalModelMapping );
        }

        var storageSettings = {
            // Cache Storage Settings
		    cacheStorage = {
                // we know the template cache will always exist so that is our default
                cachename   = !isNull( settings.storage.cacheStorage.cachename ) ? settings.storage.cacheStorage.cachename : 'template',
                // default timeout for cache storage is 7 days
		        timeout     = !isNull( settings.storage.cacheStorage.timeout ) ? settings.storage.cacheStorage.timeout : 10080 
		    },
			// Cookie Storage settings
			cookieStorage = {
				useEncryption 	= true,
				encryptionSeed 	= "cbc_CookieStorage",
		        encryptionAlgorithm = "AES/CBC/PKCS5Padding",
		        encryptionEncoding = "HEX"
			}
        };

        /**
         * Custom storage settings exclusive to this model
         */
        binder.map(
            alias = "SessionStorage@cbc"
        ).to( "cbstorages.models.CacheStorage" )
        .initWith(
           settings = storageSettings,
           cachebox = cachebox
        );

        binder.map(
            alias = "CookieStorage@cbc"
        ).to( "cbstorages.models.CookieStorage" )
        .initWith(
           settings = storageSettings
        );

        // Run any outstanding migrations on module load
        try{
            var migrationService = new cfmigrations.models.MigrationService();
            migrationService.setDatasource( !isNull( settings.datasource ) ? settings.datasource : getApplicationMetadata().datasource );
            migrationService.setMigrationsDirectory( getCurrentTemplatePath() & '/resources/database/migrations' );
            wirebox.autoWire( migrationService );
            migrationService.runAllMigrations( "up" );
        } catch( any e ){
            throw( 
                type="cbCommerceMigrationsException",
                message="The cfmigrations module is not installed or has not been registered.  Module registration failed."
            );
        }
 
    }
}