component {

    this.name           = "cbCommerce";
    this.title          = "cbCommerce";
    this.description    = "cbCommerce is the eCommerce Platform for the ContentBox Modular CMS";
    this.version        = "1.0.0-alpha1";
    this.author         = "Jon Clausen <jclausen@ortussolutions.com>";
    this.webUrl         = "https://github.com/jclausen/cbCommerce";
    this.cfmapping      = "cbCommerce";
    this.modelNamespace	= "cbCommerce";
    this.entryPoint     = "store";
    this.viewParentLookup = true;
    this.layoutParentLookup = true;
    this.dependencies   = [
        "cbauth",
        "quick",
        "cfmigrations",
        "cbsecurity",
        "BCrypt",
        "cbi18n"
    ];

	/**
	 * Configure Module
	 */
    function configure() {
		if( len( getSystemSetting( "CBCOMMERCE_ENTRYPOINT", "" ) ) ){
			this.entryPoint = getSystemSetting( "CBCOMMERCE_ENTRYPOINT" );
		}

        settings = {
            "cbauth" : {
                "userServiceClass" : "UserService@cbCommerce"
            },
            "products" : {
                // Allows for the configuration of an external products model, to interface with existing databases
                "externalModel"        : false,
                "externalModelBinding" : "",
                "externalModelMapping" : {},
                "defaultCurrency"      : "USD"
            },
            "media" : {
                //local or s3 storage currently supported
                "driver" : getSystemSetting( 'CBC_MEDIA_DRIVER', 'local' ),
                // for local drivers, this would be the path from the root of the site
                "storageLocation" : "/includes/shared/store",
                "tempStorageLocation" : "/includes/tmp",
                "placeholderImage" : "/" & this.entrypoint & "/includes/static/default-placeholder.png",
                // Only used for s3 driver
                "s3" : {
                    "key"    :   getSystemSetting( 'AWS_ACCESS_KEY_ID',     ''),
                    "secret" :   getSystemSetting( 'AWS_SECRET_ACCESS_KEY', ''),
                    "region" :   getSystemSetting( 'AWS_DEFAULT_REGION',    ''),
                    "bucket" :   getSystemSetting( 'AWS_BUCKET',            ''),
                    // the AWS base URL for serving assets ( e.g. cloudflare )
                    "url"    :   getSystemSetting( 'AWS_URL',               '')
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
                "onOrderItemsShipped"
			]
		};

        // Custom Declared Interceptors
		interceptors = [
			{
					class="cbCommerce.interceptors.CBCQuickEntity",
					name="CBCQuickEntityInterceptor"
            },
			{
					class="cbCommerce.interceptors.CBCAPIHelper",
					name="CBCAPIHelperInterceptor"
			},
			{
					class="cbCommerce.interceptors.GlobalData",
					name="GlobalDataInterceptor"
			}
        ];

    }

    function onLoad() {
		var isContentBoxContext = controller.getModuleService().isModuleRegistered( "contentbox" );
		if( !isContentBoxContext ){
			structAppend(
				settings,
				{
					"cbsecurity" : {
						"userService" : "UserService@cbCommerce"
					}
				}
			);

		} else {
			interceptors.append(
				[
					{
						class="cbCommerce.interceptors.ContentboxSSO",
						name="CBCContentboxSSOInterceptor"
					},
					{
						class="cbCommerce.interceptors.CBCMenuHelper",
						name="CBCMenuHelperInterceptor"
					}
				],
				true
			);
			// Add our menu item
			var menuService = controller.getWireBox().getInstance( "AdminMenuService@cb" );

			menuService.addSubMenu(
				topMenu=menuService.MODULES,
				name="cbCommerce",
				label="Store Admin",
				href=menuService.buildModuleLink( 'store', 'admin' )
			);
		}
        /**
        * Overload for ContentBox default Sitemap Routing
        */
        appRouter.prepend()
                    .route( "sitemap" )
                    .to( "cbCommerce:Sitemap.index" );
        // load JavaXT jars
        wirebox.getInstance( "Loader@cbjavaloader" ).appendPaths( variables.modulePath & "/lib");

		moduleSettings = {
			"cbi18n" : {
				// Extra resource bundles to load
				resourceBundles = {
					"cbCommerce" : "/cbCommerce/includes/i18n/cbCommerce",
					"cbCommerceAdmin" : "/cbCommerce/includes/i18n/cbCommerceAdmin",
					"cbCommerceOrders" : "/cbCommerce/includes/i18n/cbCommerceOrders"
				}
			}
		};

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
				encryptionSeed 	= getSystemSetting( "CBCOMMERCE_ENCRYPT_SEED", "jxPp16lyN9M4bNFL2NR5ow==" ), // `generateSecretKey( "AES" )`
		        encryptionAlgorithm = getSystemSetting( "CBCOMMERCE_ENCRYPT_ALGORITHM", "AES/CBC/PKCS5Padding" ),
		        encryptionEncoding = getSystemSetting( "CBCOMMERCE_ENCRYPT_ENCODING", "HEX" )
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


        // Run any outstanding migrations on module load ( or reinit )
        var migrationService = new cfmigrations.models.MigrationService();
        wirebox.autoWire( migrationService );
        migrationService.getManager().setDatasource( !isNull( settings.datasource ) ? settings.datasource : getApplicationMetadata().datasource );
        migrationService.setMigrationsDirectory( '/cbCommerce/resources/database/migrations' );
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

		// routes = [
		// 	"config/Router.cfc"
		// ];

	}

}