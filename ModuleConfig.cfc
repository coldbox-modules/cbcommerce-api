component {
	this.packageInfo = deserializeJSON( fileRead( getDirectoryFromPath( getCurrentTemplatePath() ) & "/box.json" ) );
    this.name           = "cbCommerce";
    this.title          = "cbCommerce";
    this.description    = "cbCommerce is the eCommerce Platform for the ContentBox Modular CMS";
    this.version        = this.packageInfo.version;
    this.author         = "Jon Clausen <jclausen@ortussolutions.com>";
    this.webUrl         = "https://github.com/coldbox-modules/cbCommerce";
    this.cfmapping      = "cbCommerce";
    this.modelNamespace	= "cbCommerce";
    this.entryPoint     = "cbc";
    this.viewParentLookup = false;
    this.layoutParentLookup = false;
    this.dependencies   = [
		"cors",
        "cbauth",
        "quick",
        "cfmigrations",
        "cbmailservices",
        "cbvalidation",
		"mockdatacfc",
        "cbsecurity",
        "BCrypt"
    ];

	/**
	 * Configure Module
	 */
    function configure() {

        settings = {
			"info" : {
				"name" : this.title,
				"description" : this.title,
				"documentation" : this.packageInfo.documentation,
				"description" : this.packageInfo.shortDescription,
				"version" : this.version
			},
			"cbsecurity" : {
				"authentication" : {
					"userService" : "UserService@cbCommerce"
				},
				"firewall" : {
					"autoLoadFirewall"              : true,
					"handlerAnnotationSecurity"     : true,
					"invalidAuthenticationEvent"    : "cbCommerce:api.v1.BaseAPIHandler.onAuthenticationFailure",
					"invalidAuthorizationEvent"     : "cbCommerce:api.v1.BaseAPIHandler.onAuthorizationFailure",
					"defaultAuthorizationAction"    : "override",
					"defaultAuthenticationAction"   : "override"
				},
				"csrf" : {
					// By default we load up an interceptor that verifies all non-GET incoming requests against the token validations
					"enableAutoVerifier"     : false,
					// By default, all csrf tokens have a life-span of 30 minutes. After 30 minutes, they expire and we aut-generate new ones.
					"rotationTimeout"        : 30,
					// The WireBox mapping to use for the CacheStorage
					"cacheStorage"           : "CacheStorage@cbstorages",
					// Enable/Disable the cbAuth login/logout listener in order to rotate keys
					"enableAuthTokenRotator" : true
				}
			},
			"cbswagger" : {
				// A convention route, relative to your app root, where request/response samples are stored ( e.g. resources/apidocs/responses/[module].[handler].[action].[HTTP Status Code].json )
				"samplesPath" : "cbcommerce/resources/apidocs",
				// Information about your API
				"info"		:{
					"title" 			: "cbCommerce Application Programming Interface",
					"description" 		: "cbCommerce is the eCommerce Platform for the ContentBox Modular CMS",
					"termsOfService"	: "",
					"contact" 		:{
						"name": "Ortus Solutions",
						"url": "https://ortussolutions.com",
						"email": "Jon Clausen<jclausen@ortussolutions.com>"
					},
					"license": {
						"name": "Apache 2.0",
						"url": "http://www.apache.org/licenses/LICENSE-2.0.html"
					},
					"version":"1.0.0",
					"externalDocs" : {
						"description": "cbCommerce Documentation",
						"url": "https://cbcommerce.ortusbooks.com/"
					}
				},
				"tags" : [],
				// https://swagger.io/specification/#serverObject
				"servers" : [
					{
						"url" 			: "https://api.cbcommerce.dev/api/v1/settings",
						"description" 	: "Development testing"
					}
				],
				// An element to hold various schemas for the specification.
				// https://github.com/OAI/OpenAPI-Specification/blob/master/versions/3.0.0.md#componentsObject
				"components" : {
					// Define your security schemes here
					// https://github.com/OAI/OpenAPI-Specification/blob/master/versions/3.0.0.md#securitySchemeObject
					"securitySchemes" : {
						"JsonWebToken" : {
							"type" 			: "apiKey",
							"description" 	: "A valid JWT issued by the Authentication API endpoint, presented as an authorization Bearer token",
							"name" 			: "Authorization",
							"in" 			: "header",
							"bearerFormat"  : "JWT"
						},
						"CSRFToken" : {
							"type" 			: "apiKey",
							"description" 	: "A server-issued CSRF token. Required for all methods except GET, HEAD, OPTIONS",
							"name" 			: "x-csrf-token",
							"in" 			: "header"
						}
					}
				},

				// A default declaration of Security Requirement Objects to be used across the API.
				// https://github.com/OAI/OpenAPI-Specification/blob/master/versions/3.0.0.md#securityRequirementObject
				// Only one of these requirements needs to be satisfied to authorize a request.
				// Individual operations may set their own requirements with `@security`
				"security" : [
					{ "JsonWebToken" : [], "CSRFToken" : [] }
				]
			},
            "products" : {
                // Allows for the configuration of an external products model, to interface with existing databases
                "externalModel"        : false,
                "externalModelBinding" : "",
                "externalModelMapping" : {},
                "defaultCurrency"      : "USD"
            },
			"features" : {
				"consignment" : getSystemSetting( "CBCOMMERCE_ENABLE_CONSIGNMENT", true ),
				"used" : getSystemSetting( "CBCOMMERCE_ENABLE_USED_PRODUCTS", true ),
				"subscriptions" : getSystemSetting( "CBCOMMERCE_ENABLE_SUBSCRIPTIONS", true ),
				"virtualProducts" : getSystemSetting( "CBCOMMERCE_ENABLE_VIRTUAL", true )
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
				"processors" : [
					{
						"name" : "Stripe",
						"processor" : "StripeProcessor@cbCommerce",
						"expose" : {
							"stripeKey" : getSystemSetting( "STRIPE_PUBLISHABLE_KEY", "" )
						}
					}
				]
            },
			"deliveryMethods" : [
				{
					"label" : "In Store Pickup",
					"description"  : "Local pickup in store",
					"isFlatRate" : true,
					"isDefault" : false,
					"flatRateFee" : 0
				},
				{
					"label" : "USPS Ground",
					"description"  : "United States Postal Service Ground",
					"isFlatRate" : false,
					"isDefault" : true,
					"calculatorModel" : "USPSGroundCalculator@cbcommerce"
				},
				{
					"label" : "USPS Priority Mail - 3 day",
					"description"  : "United States Postal Service Priority Mail",
					"isFlatRate" : false,
					"isDefault" : false,
					"calculatorModel" : "USPSPriorityCalculator@cbcommerce"
				},
				{
					"label" : "USPS Express Mail - 2 day",
					"description"  : "United States Postal Service Priority Mail",
					"isFlatRate" : false,
					"isDefault" : false,
					"calculatorModel" : "USPSExpressCalculator@cbcommerce"
				},
				{
					"label" : "FedEx Overnight Service",
					"description"  : "Federal Express Overnight",
					"isFlatRate" : false,
					"isDefault" : false,
					"calculatorModel" : "FedExOvernightCalculator@cbcommerce"
				}
			]
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
			}
        ];

    }

    function onLoad() {

		var isContentBoxContext = controller.getModuleService().isModuleRegistered( "contentbox" );
		if( !isContentBoxContext ){
			settings.cbSecurity[ "userService" ] = "UserService@cbCommerce";
		} else {
			interceptors.append(
				[
					{
						class="cbCommerce.interceptors.ContentboxSSO",
						name="CBCContentboxSSOInterceptor"
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
				secure = true,
				httpOnly = false,
				domain = CGI.SERVER_NAME,
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

		// expand delivery method setting to include identifiers
		settings.deliveryMethods = wirebox.getInstance( "DeliveryMethodService@cbCommerce" ).ensureDeliveryMethods( settings.deliveryMethods );

		// Perform any settings overrides after all migrations are run
		wirebox.getInstance( "SettingService@cbcommerce" ).newBuilder({}).get().each( function( setting ){
			switch( setting.getName() ){
				case "s3":{
					variables.settings.media.s3 = setting.getValue();
				}
				default : {
					if( listLen( setting.getName(), "." ) > 1 ){
						var path = listToArray( setting.getName(), "." );
						var key = arrayLast( nesting );
						var nesting = path.slice( 1, path.len()-1 );
						var nested = evaluate( "variables.settings.#nesting#" );
						nested[ key ] = setting.getValue();
					} else {
						variables.settings[ setting.getName() ] = setting.getValue();
					}
				}
			}
		} );

        // Run any outstanding seeders if requested
		if( controller.getSetting( "environment", "production" ) != "production" ){
			setting requesttimeout=500;
			if( structKeyExists( url, "seed" ) && url.seed ){
				migrationService.setMigrationsDirectory( '/cbCommerce/resources/database/seeds' );
				migrationService.runAllMigrations( "up" );
			} else if( structKeyExists( url, "seed" ) && !url.seed ) {
				migrationService.setMigrationsDirectory( '/cbCommerce/resources/database/seeds' );
				migrationService.runAllMigrations( "down" );
			}
		}

		var allModuleSettings = controller.getSetting( "moduleSettings" );
		param allModuleSettings.cbauth = {};
		if( allModuleSettings.cbauth.keyExists( "userServiceClass" ) ){
			allModuleSettings.cbauth[ "userServiceClass" ] = "UserService@cbcommerce";
		}

	}

}