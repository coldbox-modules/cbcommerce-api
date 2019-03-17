component {
    
    function up( schema ) {
        schema.create( "cbc_tenantSettings", function( table ) {
		    table.uuid( "id" ).primaryKey();
		    table.timestamp( "createdTime" ).default( 'CURRENT_TIMESTAMP' );
		    table.timestamp( "modifiedTime" ).default( 'CURRENT_TIMESTAMP' );
            table.string( 'key' );
            table.text( 'value' );
		} );
    }

    function down( schema ) {
        schema.dropIfExists( "cbc_tenantSettings" );
    }

}
