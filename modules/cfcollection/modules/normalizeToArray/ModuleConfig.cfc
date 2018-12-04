component {
    
    this.name = "normalizeToArray";
    this.author = "Eric Peterson";
    this.webUrl = "https://github.com/elpete/normalizeToArray";
    this.autoMapModels = false;

    function configure() {
        include "#moduleMapping#/functions/normalizeToArray.cfm";
        binder.map( "normalizeToArray" ).toValue( normalizeToArray );
    }

}