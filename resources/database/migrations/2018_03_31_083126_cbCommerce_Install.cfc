component {
    
    function up( schema ) {

    	schema.create( "cboxCommerce_customers", function( table ){
    		table.increments( "id" );
		    table.timestamp( "createdTime" );
		    table.timestamp( "modifiedTime" );
		    table.bit( "isActive" );
		    
    	} );

    	schema.create( "cboxCommerce_customerAddresses", function( table ){
    		table.increments( "id" );
		    table.timestamp( "createdTime" );
		    table.timestamp( "modifiedTime" );
		    table.bit( "isActive" );
		    table.text( "designation" );

		    table.unsignedInteger( "FK_customer" )
		    		.references( "id" )
		    		.onTable( "cboxCommerce_customers" )
					.onUpdate( "CASCADE" )
					.onDelete( "CASCADE" );
		    
    	} );

    	schema.create( "cboxCommerce_orders", function( table ){
    		table.increments( "id" );
		    table.timestamp( "createdTime" );
		    table.timestamp( "modifiedTime" );
		    table.bit( "isActive" );
		    table.timestamp( "approvalTime" );
		    table.timestamp( "fulfilledTime" );
		    table.decimal( "subtotal" );
		    table.decimal( "shipping" );
		    table.decimal( "fees" );
		    table.decimal( "tax" );
		    table.decimal( "discount" );
		    table.decimal( "total" );
		    table.timestamp( "paidInFull" );
		    
		    table.unsignedInteger( "FK_customer" )
		    		.references( "id" )
		    		.onTable( "cboxCommerce_customers" )
					.onUpdate( "CASCADE" )
					.onDelete( "CASCADE" );

			table.unsignedInteger( "FK_shippingAddress" )
		    		.references( "id" )
		    		.onTable( "cboxCommerce_customerAddresses" );


			table.unsignedInteger( "FK_billingAddress" )
		    		.references( "id" )
		    		.onTable( "cboxCommerce_customerAddresses" );

    	} );

    	schema.create( "cboxCommerce_orderItems", function( table ){
    		table.increments( "id" );
		    table.timestamp( "createdTime" );
		    table.timestamp( "modifiedTime" );
		    table.bit( "isActive" );

		    table.unsignedInteger( "FK_order" )
					.references( "id" )
					.onTable( "cboxCommerce_orders" )
					.onUpdate( "CASCADE" )
					.onDelete( "CASCADE" );   
    	} );

    	schema.create( "cboxCommerce_payments", function( table ){
    		table.increments( "id" );
		    table.timestamp( "createdTime" );
		    table.timestamp( "modifiedTime" );
		    table.bit( "isActive" );
		    table.string( "externalTransactionID" );
		    table.index( [ "externalTransactionID" ], "IDX_externalTransactionID" );
		    table.decimal( "amount" );
		    table.text( "comment" );
		    table.integer( "lastFour" );
		    table.string( "paymentMethod" );

			table.unsignedInteger( "FK_order" )
					.references( "id" )
					.onTable( "cboxCommerce_orders" )
					.onUpdate( "CASCADE" )
					.onDelete( "CASCADE" ); 
    	} );


        schema.create( "cboxCommerce_carts", function( table ) {
		    table.increments( "id" );
		    table.timestamp( "createdTime" );
		    table.timestamp( "modifiedTime" );
		    table.bit( "isActive" );
		    table.json( "contents" );
		    table.json( "audit" );

		    table.unsignedInteger( "FK_customer" )
		    		.references( "id" )
		    		.onTable( "cboxCommerce_customers" )
					.onUpdate( "CASCADE" )
					.onDelete( "CASCADE" );

		    table.unsignedInteger( "FK_order" ).references( "id" ).onTable( "cboxCommerce_orders" );

		} );

    }

    function down( schema ) {
        schema.dropIfExists( "cboxCommerce_carts" );
        schema.dropIfExists( "cboxCommerce_payments" );
        schema.dropIfExists( "cboxCommerce_orderItems" );
        schema.dropIfExists( "cboxCommerce_orders" );
        schema.dropIfExists( "cboxCommerce_customerAddresses" );
        schema.dropIfExists( "cboxCommerce_customers" );
    }

}
