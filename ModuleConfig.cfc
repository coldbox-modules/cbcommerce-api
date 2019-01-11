component {

    this.name           = "cbCommerce";
    this.title          = "cbCommerce "
    this.description    = "cbCommerce is the eCommerce Platform for the ContentBox Modular CMS"
    this.version        = "1.0.0-alpha1"
    this.author         = "Jon Clausen <jclausen@ortussolutions.com>";
    this.webUrl         = "https://github.com/jclausen/cbCommerce";
    this.cfmapping      = "cbCommerce";
    this.modelNamespace	= "cbCommerce";
    this.entryPoint     = "store";
    this.viewParentLookup = true;
    this.layoutParentLookup = true;
    this.dependencies   = [
        "cbauth",
        "cbguard",
        "cfcollection",
        "quick",
        "cfmigrations",
        "cffractal",
        "cbstorages",
        "cbsecurity",
        "BCrypt"
    ];

	/**
	 * Configure Module
	 */
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
                "storageLocation" : "/includes/shared/store",
                "tempStorageLocation" : "/includes/tmp",
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
                "securityService" : "SecurityService@cbCommerce"
            },
            "payments" : {
                "processor" : {
                    "default" : "StripeProcessor@cbCommerce",
                    "credentials" : {
						//credentials will vary, depending on the implmented processor
                    }
                }
            }
            // An optional "storage" key may be provided which specifies custom cb storage and matches the settings structure of that module
        };

        interceptorSettings = {
			customInterceptionPoints = [
				"onOrderCompleted",
				"onConsignmentOrderReceived",
				"onOrderItemReturned",
                "onOrderItemsShipped",
                "onEnsureContentboxCategoryMenus"
			]
		};

        // Custom Declared Interceptors
		interceptors = [
			{
					class="cbCommerce.interceptors.CBCQuickEntity",
					name="CBCQuickEntityInterceptor"
            },
            {
					class="cbCommerce.interceptors.ContentboxSSO",
					name="CBCContentboxSSOInterceptor"
            },
			{
					class="cbCommerce.interceptors.CBCAPIHelper",
					name="CBCAPIHelperInterceptor"
			},
			{
					class="cbCommerce.interceptors.GlobalData",
					name="GlobalDataInterceptor"
			},
			{
					class="cbCommerce.interceptors.CBCMenuHelper",
					name="CBCMenuHelperInterceptor"
			}
        ];
        // Forward Media
        router.route( "media/:path" )
                .withAction(
                    {
                        "get" : "deliver"
                    }
                )
                .toHandler( "Media" );

        // API Routing
        router.route( "api/v1/payment" )
                .withAction( {
                    POST : "create"
                } )
                .toHandler( "API.v1.Payments" );

        router.route( "api/v1/authentication" )
                .withAction( {
                    GET : "get",
                    POST : "create",
                    DELETE : "delete"
                } )
                .toHandler( "API.v1.Authentication" );

        router.route( "api/v1/cart/:itemId" )
                .withAction(
                    {
                        "POST" : "addItem",
                        "PUT" : "updateItem",
                        "PATCH" : "updateItem",
                        "DELETE" : "deleteItem"
                    }
                )
                .toHandler( "API.v1.Cart" );

        router.route( "api/v1/cart" )
                .withAction({
                    "GET" : "get"
                })
                .toHandler( "API.v1.Cart" );

        //statistical routes
        router.route( "api/v1/statistics/products/:id" ).withAction({ "POST" : "productView" } ).toHandler( "API.v1.Statistics");
        router.route( "api/v1/statistics/categories/:id" ).withAction({ "POST" : "categoryView" } ).toHandler( "API.v1.Statistics");

        // Resource Routes ( auto-magic method conventions )
        router
            .resources(
                resource   = "api/v1/products/:productId/reviews",
                handler    = "API.v1.ProductReviews"
            )
            .resources(
                resource = "api/v1/products/:productId/media",
                handler = "API.v1.ProductMedia"
            )
            .resources(
                resource   = "api/v1/products",
                handler    = "API.v1.Products"
            )
            .resources(
                resource = "api/v1/skus/:skuId/media",
                handler = "API.v1.ProductSKUMedia"
            )
            .resources(
                resource = "api/v1/skus",
                handler  = "API.v1.ProductSKUs"
            )
            .resources(
                resource = "api/v1/product-categories/:categoryId/media",
                handler = "API.v1.ProductCategoryMedia"
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
            )
            .resources(
                resource   = "api/v1/wishlists",
                handler    = "API.v1.Wishlists"
            );

            // Wishlist Item Routes
            router.route( 'api/v1/wishlists/:wishlistId/items/:id' )
                    .withAction(
                        {
                            "GET"    : "show",
                            "PUT"    : "update",
                            "PATCH"  : "update",
                            "DELETE" : "delete"
                        }
                    )
                    .toHandler( "API.v1.WishlistItems" );

            router.route( 'api/v1/wishlists/:wishlistId/items' )
                    .withAction(
                        {
                            "GET"  : "index",
                            "POST" : "create"
                        }
                    )
                    .toHandler( "API.v1.WishlistItems" );

            router.route( "category/:id" ).to( "Category.detail" );
            router.route( "category" ).to( "Category.index" );
            router.route( "product/comparison" ).to( "Product.comparison" );
            router.route( "product/:id" ).to( "Product.detail" );
            router.route( "product" ).to( "Product.index" );
            router.route( "checkout/login" ).to( "Checkout.login" );
            router.route( "checkout/thankyou/:id" ).to( "Checkout.thankyou" );
            router.route( "checkout" ).to( "Checkout.index" );
            router.route( "account/create" ).to( "Account.create" );
            router.route( "account/login" ).to( "Account.login" );
            router.route( "account" ).to( "Account.index" );

            /**
             * Display routing
             */
            router.route( "admin/app" ).to( "Admin.app" );

            router.route( "admin" ).toHandler( "Admin" );

            router.route( ":action?" )
                .toHandler( "Main" );
    }

    function onLoad() {
        // load JavaXT jars
        wirebox.getInstance( "Loader@cbjavaloader" ).appendPaths( variables.modulePath & "/lib");

        //change our binder mapping
        if( settings.products.externalModel ){
            binder
                .map(
                    alias = "ExternalProduct@cbCommerce",
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
				encryptionSeed 	= "jxPp16lyN9M4bNFL2NR5ow==", // `generateSecretKey( "AES" )`
		        encryptionAlgorithm = "AES/CBC/PKCS5Padding",
		        encryptionEncoding = "HEX"
			}
        };

        /**
         * Custom storage settings exclusive to this model
         */
        binder.map(
            alias = "SessionStorage@cbCommerce"
        ).to( "cbstorages.models.CacheStorage" )
        .initWith(
           settings = storageSettings,
           cachebox = cachebox
        );

        binder.map(
            alias = "CookieStorage@cbCommerce"
        ).to( "cbstorages.models.CookieStorage" )
        .initWith(
           settings = storageSettings
        );

        // Add our menu item
        var menuService = controller.getWireBox().getInstance( "AdminMenuService@cb" );
        menuService.addSubMenu(
            topMenu=menuService.MODULES,
            name="cbCommerce",
            label="Store Admin",
            href=menuService.buildModuleLink( 'store', 'admin' )
        );

        // Run any outstanding migrations on module load ( or reinit )
        var migrationService = new cfmigrations.models.MigrationService();
        migrationService.setDatasource( !isNull( settings.datasource ) ? settings.datasource : getApplicationMetadata().datasource );
        migrationService.setMigrationsDirectory( '/cbCommerce/resources/database/migrations' );
        wirebox.autoWire( migrationService );
        migrationService.runAllMigrations( "up" );

        // TODO: Only run seeds in development mode, investigate if we want this in production
		if( controller.getSetting( "environment" ) neq "development" ){
			return;
		}

        // Run any outstanding seeders if requested
        if( structKeyExists( url, "seed" ) && url.seed ){
            migrationService.setMigrationsDirectory( '/cbCommerce/resources/database/seeds' );
            migrationService.runAllMigrations( "up" );
        } else if( structKeyExists( url, "seed" ) && !url.seed ) {
            migrationService.setMigrationsDirectory( '/cbCommerce/resources/database/seeds' );
            migrationService.runAllMigrations( "down" );
        }

	}

}