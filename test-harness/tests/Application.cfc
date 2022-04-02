/**
********************************************************************************
Copyright 2005-2007 ColdBox Framework by Luis Majano and Ortus Solutions, Corp
www.ortussolutions.com
********************************************************************************
*/
component{

	// APPLICATION CFC PROPERTIES
	this.name 				= "CbCommerce-TestingSuite" & hash(getCurrentTemplatePath());
	this.sessionManagement 	= true;
	this.sessionTimeout 	= createTimeSpan( 0, 0, 15, 0 );
	this.applicationTimeout = createTimeSpan( 0, 0, 15, 0 );
	this.setClientCookies 	= true;

	// Add Environment Access
	system = createObject( "java", "java.lang.System" );
	systemEnv = system.getenv();


	// Create testing mapping
	this.mappings[ "/tests" ] = getDirectoryFromPath( getCurrentTemplatePath() );

	// The application root
	rootPath = REReplaceNoCase( this.mappings[ "/tests" ], "tests(\\|/)", "" );
	this.mappings[ "/root" ]   = rootPath;

	this.mappings[ '/config' ]           = rootPath & "config";
	this.mappings[ "/coldbox" ]          = rootPath & "lib/frameworks/coldbox";
	this.mappings[ "/testbox" ]          = rootPath & "lib/frameworks/testbox";
	this.mappings[ "/contentbox-deps" ]  = rootPath & "modules/contentbox/modules/contentbox-deps";
	this.mappings[ "/cborm" ] 	 		 = this.mappings[ "/contentbox-deps" ] & "/modules/cborm";

	// UPDATE THE NAME OF THE MODULE IN TESTING BELOW
	request.MODULE_NAME = "cbCommerce";
	this.datasource = "contentbox";
	// ORM SETTINGS
	this.ormEnabled = true;
	this.ormSettings = {
		// ENTITY LOCATIONS, ADD MORE LOCATIONS AS YOU SEE FIT
		cfclocation=[ "models", "modules", "modules_app" ],
		// DO NOT REMOVE THE FOLLOWING LINE OR AUTO-UPDATES MIGHT FAIL.
		dbcreate = "update",
		// GET SECONDARY CACHE FROM ENV VARIABLE
		secondarycacheenabled = structKeyExists( systemEnv, "ORM_SECONDARY_CACHE" ) ? systemEnv[ "ORM_SECONDARY_CACHE" ] : false,
		cacheprovider		= "EhCache",
		// ORM SESSION MANAGEMENT SETTINGS, DO NOT CHANGE
		logSQL 				= false,
		flushAtRequestEnd 	= false,
		autoManageSession	= false,
		// ORM EVENTS MUST BE TURNED ON FOR CONTENTBOX TO WORK
		eventHandling 		= true,
		eventHandler		= "cborm.models.EventHandler",
		// THIS IS ADDED SO OTHER CFML ENGINES CAN WORK WITH CONTENTBOX
		skipCFCWithError	= true
	};

	// Dialect Overrides via environment
	if( structKeyExists( systemEnv, "ORM_DIALECT" ) ){
		this.ormSettings[ "dialect" ] = systemEnv[ "ORM_DIALECT" ];
	}


	this.mappings[ "/coldbox" ]    = rootPath & "coldbox";
    this.mappings[ "/quick" ]      = rootPath & "modules/quick";
    this.mappings[ "/bcrypt" ]     = rootPath & "modules/BCrypt";
    this.mappings[ "/qb" ]         = rootPath & "modules/quick/modules/qb";

	// The module root path
	moduleRootPath = REReplaceNoCase( this.mappings[ "/root" ], "#request.module_name#(\\|/)test-harness(\\|/)", "" );
	this.mappings[ "/moduleroot" ] = moduleRootPath;
	this.mappings[ "/#request.MODULE_NAME#" ] = moduleRootPath & "#request.MODULE_NAME#";

	// request start
	public boolean function onRequestStart( String targetPage ){
		pagePoolClear();
		if( url.keyExists( "fwreinit" ) ){
			ormReload();
		}
		return true;
	}

    public void function onRequestEnd() {
    	// Cleanup Frameworks in each request.
        structdelete( application, "cbController" );
        structdelete( application, "wirebox" );
        return;
	}

}