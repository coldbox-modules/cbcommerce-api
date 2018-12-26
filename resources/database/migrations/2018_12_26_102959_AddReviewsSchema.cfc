component {
    
    function up( schema ) {
        schema.create( "cbc_productReviews", function( table ) {
		    table.uuid( "id" ).primaryKey();
		    table.timestamp( "createdTime" ).default( 'CURRENT_TIMESTAMP' );
		    table.timestamp( "modifiedTime" ).default( 'CURRENT_TIMESTAMP' );
			table.boolean( "isActive" ).default( 1 );
			table.boolean( "isPublished" ).default( 0 );
            table.decimal( "rating", 8, 2 );
            table.decimal( "relevancyScore", 8, 2 ).default( 0 );
		    table.string( "summary", 255 ).nullable();
		    table.text( "comment" ).nullable();
            
            table.uuid( "FK_product" )
		    		.references( "id" )
					.onTable( "cbc_products" );

            table.uuid( "FK_sku" )
                    .nullable()
		    		.references( "id" )
					.onTable( "cbc_SKUs" );

			table.uuid( "FK_user" )
		    		.references( "id" )
					.onTable( "cbc_users" );
					
		} );
    }

    function down( schema ) {
		schema.dropIfExists( "cbc_productReviews" );
    }

}
