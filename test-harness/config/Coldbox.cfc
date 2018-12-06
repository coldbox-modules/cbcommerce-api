component{

	// Configure ColdBox Application
	function configure(){

		// coldbox directives
		coldbox = {
			//Application Setup
			appName 				= "Module Tester",

			//Development Settings
			reinitPassword			= "",
			handlersIndexAutoReload = true,
			modulesExternalLocation = [],

			//Implicit Events
			defaultEvent			= "",
			requestStartHandler		= "",
			requestEndHandler		= "",
			applicationStartHandler = "",
			applicationEndHandler	= "",
			sessionStartHandler 	= "",
			sessionEndHandler		= "",
			missingTemplateHandler	= "",

			//Error/Exception Handling
			exceptionHandler		= "",
			onInvalidEvent			= "",
			customErrorTemplate 	= "/coldbox/system/includes/BugReport.cfm",

			//Application Aspects
			handlerCaching 			= false,
			eventCaching			= false
		};

		// environment settings, create a detectEnvironment() method to detect it yourself.
		// create a function with the name of the environment so it can be executed if that environment is detected
		// the value of the environment is a list of regex patterns to match the cgi.http_host.
		environments = {
			development = "localhost,127\.0\.0\.1"
		};

		// Module Directives
		modules = {
			// An array of modules names to load, empty means all of them
			include = [],
			// An array of modules names to NOT load, empty means none
			exclude = []
		};

		//Register interceptors as an array, we need order
		interceptors = [
			 //SES
			 { class="coldbox.system.interceptors.SES" }
		];

		//LogBox DSL
		logBox = {
			// Define Appenders
			appenders = {
				files={class="coldbox.system.logging.appenders.RollingFileAppender",
					properties = {
						filename = "tester", filePath="/#appMapping#/logs"
					}
				}
			},
			// Root Logger
			root = { levelmax="INFO", appenders="*" },
			// Implicit Level Categories
			info = [ "coldbox.system" ]
		};

		moduleSettings = {
			"quick" : {
				"defaultGrammar" : "MySQLGrammar"
			},
			"cbauth" : {
				"userServiceClass" : "UserService@cbCommerce"
			},
			"cbguard" : {
                "authenticationOverrideEvent"     = "cbCommerce:api.v1.BaseAPIHandler.onAuthenticationFailure",
                "authenticationAjaxOverrideEvent" = "cbCommerce:api.v1.BaseAPIHandler.onAuthenticationFailure",
                "authorizationOverrideEvent"      = "cbCommerce:api.v1.BaseAPIHandler.onAuthorizationFailure",
                "authorizationAjaxOverrideEvent"  = "cbCommerce:api.v1.BaseAPIHandler.onAuthorizationFailure"
			},
			"stripecfml" : {
				"apiKey" : getSystemSetting( "STRIPE_API_KEY", "" ),
				"publishableKey" : getSystemSetting( "STRIPE_PUBLISHABLE_KEY", "" )
			}
		};

	}

	/**
	 * Load the Module you are testing
	 */
	function afterAspectsLoad( event, interceptData, rc, prc ){
		controller.getModuleService()
			.registerAndActivateModule(
				moduleName 		= request.MODULE_NAME,
				invocationPath 	= "moduleroot"
			);
	}

}