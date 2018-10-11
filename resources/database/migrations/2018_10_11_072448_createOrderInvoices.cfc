component {
    
    function up( schema ) {
        schema.create( "cbc_orderInvoices", function( table ){
    		table.uuid( "id" ).primaryKey();
		    table.timestamp( "createdTime" ).default( 'CURRENT_TIMESTAMP' );
		    table.timestamp( "modifiedTime" ).default( 'CURRENT_TIMESTAMP' );
            table.boolean( "isActive" ).default( 1 );
            
            table.string( "internalId" );
            table.string( "externalId").nullable();
            table.text( "terms" ).nullable();
            table.text( "note" ).nullable();

            table.uuid( "FK_wishlist" )
                    .nullable()
                    .references( "id" )
                    .onTable( "cbc_wishlists" );

        });

        schema.alter( "cbc_orders", function( table ){
            table.addColumn(
                table.uuid( "FK_invoice" )
                    .nullable()
            );
            table.addConstraint(
                table.uuid( "FK_invoice" )
					.references( "id" )
                    .onTable( "cbc_orderInvoices" )
            );
        } );
    }

    function down( schema ) {
        schema.dropIfExists( "cbc_orderInvoices" );
    }

}
