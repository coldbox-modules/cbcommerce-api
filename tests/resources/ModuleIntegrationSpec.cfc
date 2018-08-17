component extends="coldbox.system.testing.BaseTestCase" {

    this.loadColdbox = true;
    this.unloadColdbox = true;

    function beforeAll() {
        super.beforeAll();
        
        getController().getModuleService()
            .registerAndActivateModule( "cbox-commerce", "testingModuleRoot" );
    }

    function afterAll(){
        super.afterAll();
    }

    /**
    * @beforeEach
    */
    function setupIntegrationTest() {
        setup();
    }

}
