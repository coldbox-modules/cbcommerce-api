component {

    this.name = "ColdBoxTestingSuite" & hash(getCurrentTemplatePath());
    this.sessionManagement  = true;
    this.setClientCookies   = true;
    this.sessionTimeout     = createTimeSpan( 0, 0, 15, 0 );
    this.applicationTimeout = createTimeSpan( 0, 0, 15, 0 );

    testsPath = getDirectoryFromPath( getCurrentTemplatePath() );
    this.mappings[ "/tests" ] = testsPath;
    rootPath = REReplaceNoCase( this.mappings[ "/tests" ], "tests(\\|/)", "" );
    this.mappings[ "/root" ] = rootPath;
    this.mappings[ "/testingModuleRoot" ] = listDeleteAt( rootPath, listLen( rootPath, '\/' ), "\/" );
    this.mappings[ "/app" ] = testsPath & "resources/app";
    this.mappings[ "/coldbox" ] = testsPath & "resources/app/coldbox";
    this.mappings[ "/quick" ] = rootPath & "modules/quick";
    this.mappings[ "/bcrypt" ] = rootPath & "modules/BCrypt";
    this.mappings[ "/qb" ] = rootPath & "modules/quick/modules/qb";
    this.mappings[ "/cfcollection" ] = rootPath & "modules/quick/modules/cfcollection";
    this.mappings[ "/cffractal" ] = rootPath & "modules/cffractal";
    this.mappings[ "/cbc" ] = rootPath;
    this.mappings[ "/testbox" ] = rootPath & "/testbox";

    this.datasource = "cbc_testing";

    function onRequestStart(){

    // applicationStop();
    // abort;
    }
}
