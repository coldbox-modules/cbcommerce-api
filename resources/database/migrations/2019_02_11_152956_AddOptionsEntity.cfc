component {
    
    function up( schema ) {
        
        schema.create( "cbc_productSKUOptions", function( table ) {
		    table.uuid( "id" ).primaryKey();
		    table.timestamp( "createdTime" ).default( 'CURRENT_TIMESTAMP' );
		    table.timestamp( "modifiedTime" ).default( 'CURRENT_TIMESTAMP' );
            table.boolean( "isActive" ).default( 1 );
            table.integer( "displayOrder" ).default( 0 )
			
			table.string( "name", 100 );
			table.string( "value", 255 );

            table.uuid( "FK_sku" )
                    .references( "id" )
                    .onTable( "cbc_SKUs" );
        } );
        schema.alter( "cbc_SKUs", function( table ){
            table.dropColumn( "options" );
        } );
    }

    function down( schema ) {

        schema.dropIfExists( "cbc_productSKUOptions" );

        schema.alter( "cbc_SKUs", function( table ){
            table.addColumn(
                table.json( "options" )
            );
        } );
        
    }

}
