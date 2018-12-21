component {
    
    function up( schema ) {
        schema.create( "cbc_productCategoryMedia", function( table ) {
		    table.uuid( "id" ).primaryKey();
		    table.timestamp( "createdTime" ).default( 'CURRENT_TIMESTAMP' );
		    table.timestamp( "modifiedTime" ).default( 'CURRENT_TIMESTAMP' );
		    table.boolean( "isActive" ).default( 1 );
			table.boolean( "isPrimary" ).default( 0 );
			table.integer( "displayOrder" ).default( 0 );

			table.uuid( "FK_media" )
		    		.references( "id" )
		    		.onTable( "cbc_media" )
					.onUpdate( "CASCADE" );

			table.uuid( "FK_category" )
		    		.references( "id" )
		    		.onTable( "cbc_productCategories" )
					.onDelete( "CASCADE" );

		} );
    }

    function down( schema ) {
        schema.dropIfExists( "cbc_productCategoryMedia" );
    }

}
