﻿/**
********************************************************************************
Copyright 2005-2007 ColdBox Framework by Luis Majano and Ortus Solutions, Corp
www.ortussolutions.com
********************************************************************************
*/
component{

	// APPLICATION CFC PROPERTIES
	this.name 				= "ColdBoxTestingSuite" & hash(getCurrentTemplatePath());
	this.sessionManagement 	= true;
	this.sessionTimeout 	= createTimeSpan( 0, 0, 15, 0 );
	this.applicationTimeout = createTimeSpan( 0, 0, 15, 0 );
	this.setClientCookies 	= true;

	// Create testing mapping
	this.mappings[ "/tests" ] = getDirectoryFromPath( getCurrentTemplatePath() );

	// The application root
	rootPath = REReplaceNoCase( this.mappings[ "/tests" ], "tests(\\|/)", "" );
	this.mappings[ "/root" ]   = rootPath;

	// UPDATE THE NAME OF THE MODULE IN TESTING BELOW
	request.MODULE_NAME = "cbCommerce";
	this.datasource = "cbc_testing";

	this.mappings[ "/coldbox" ]    = rootPath & "coldbox";
    this.mappings[ "/quick" ]      = rootPath & "modules/quick";
    this.mappings[ "/bcrypt" ]     = rootPath & "modules/BCrypt";
    this.mappings[ "/qb" ]         = rootPath & "modules/quick/modules/qb";
    this.mappings[ "/cffractal" ]  = rootPath & "modules/cffractal";

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