component {
    
    function up( schema ) {

    	schema.create( "cbc_customers", function( table ){
    		table.uuid( "id" ).primaryKey();
		    table.timestamp( "createdTime" );
		    table.timestamp( "modifiedTime" );
		    table.boolean( "isActive" ).default( true );
		    
    	} );

    	schema.create( "cbc_customerAddresses", function( table ){
    		table.uuid( "id" ).primaryKey();
		    table.timestamp( "createdTime" );
		    table.timestamp( "modifiedTime" );
		    table.boolean( "isActive" ).default( true );
			table.text( "designation" );
			
			table.string( 'address1', 255 );
			table.string( 'address2', 255 );
			table.string( 'city', 255 );
			table.string( 'province', 3 );
			table.string( 'postal_code', 15);
			table.string( 'country', 3 ).default( 'USA' );
			table.boolean( 'isPrimary' ).default( false );

		    table.uuid( "FK_customer" )
		    		.references( "id" )
		    		.onTable( "cbc_customers" )
					.onUpdate( "CASCADE" )
					.onDelete( "CASCADE" );
		    
    	} );


        schema.create( "cbc_products", function( table ) {
		    table.uuid( "id" ).primaryKey();
		    table.timestamp( "createdTime" );
		    table.timestamp( "modifiedTime" );
			table.boolean( "isActive" ).default( true );
			
			table.string( "name", 300 );
			table.string( "shortDescription", 1000 );
			table.text( "description" );
			table.boolean( "hasOptions");
			table.json( "requiredOptions" );

		    
		} );


        schema.create( "cbc_productCategories", function( table ) {
		    table.uuid( "id" ).primaryKey();
		    table.timestamp( "createdTime" );
		    table.timestamp( "modifiedTime" );
			table.boolean( "isActive" ).default( true );

			table.string( "name" );
			table.string( "description");

			table.uuid( "FK_parent" )
		    		.references( "id" )
		    		.onTable( "cbc_productCategories" );

		});

		schema.create( "cbc_lookups_products_categories", function( table ){

			table.increment( "increments" );

			table.uuid( "FK_product" )
		    		.references( "id" )
					.onTable( "cbc_products" );
					
			table.uuid( "FK_category" )
		    		.references( "id" )
					.onTable( "cbc_productCategories" );

					
		});


        schema.create( "cbc_SKUs", function( table ) {
		    table.uuid( "id" ).primaryKey();
		    table.timestamp( "createdTime" );
		    table.timestamp( "modifiedTime" );
			table.boolean( "isActive" ).default( true );
			table.boolean( "isVirtual" ).default( false );
			table.decimal( "cost" );
			table.decimal( "basePrice" );
			table.decimal( "minimumPrice" ).nullable();
			table.decimal( "MSRP" ).nullable();
			table.timestamp( "discontinueOn" ).nullable();
			table.decimal( "packagedWeight" ).default( 0 );
			table.decimal( "packagingX" ).default( 0 );
			table.decimal( "packagingY" ).default( 0 );
			table.decimal( "packagingZ" ).default( 0 );
			table.json( "options" );

			table.uuid( "FK_product" )
		    		.references( "id" )
					.onTable( "cbc_products" );
					
		} );

		schema.create( "cbc_virtualSKU", function( table ){
		    table.uuid( "id" ).primaryKey();
		    table.timestamp( "createdTime" );
		    table.timestamp( "modifiedTime" );
			table.boolean( "isActive" ).default( true );

			table.string( "location", 255 );

			table.uuid( "FK_sku" )
		    		.references( "id" )
		    		.onTable( "cbc_skus" );
		} );

		schema.create( "cbc_inventoryLocations", function( table ) {
		    table.uuid( "id" ).primaryKey();
		    table.timestamp( "createdTime" );
		    table.timestamp( "modifiedTime" );
			table.boolean( "isActive" ).default( true );

			table.string( "name", 255 );
			table.string( "description" );

			table.string( 'address1', 255 );
			table.string( 'address2', 255 );
			table.string( 'city', 255 );
			table.string( 'province', 3 );
			table.string( 'postal_code', 15);
			table.string( 'country', 3 ).default( 'USA' );
		    
		} );

		schema.create( "cbc_inventoryLocationStock", function( table ) {
		    table.uuid( "id" ).primaryKey();
		    table.timestamp( "createdTime" );
		    table.timestamp( "modifiedTime" );
			table.boolean( "isActive" ).default( true );

			table.integer( "available" ).default( 0 );
			table.integer( "unaccounted" ).default( 0 );
			table.boolean( "countRequired" ).default( false );
			table.boolean( "allowBackorder" ).default( false );

			table.uuid( "FK_sku" )
		    		.references( "id" )
		    		.onTable( "cbc_skus" );

			table.uuid( "FK_inventoryLocation" )
		    		.references( "id" )
		    		.onTable( "cbc_inventoryLocations" );

		});

		

		schema.create( "cbc_orders", function( table ){
    		table.uuid( "id" ).primaryKey();
		    table.timestamp( "createdTime" );
		    table.timestamp( "modifiedTime" );
		    table.boolean( "isActive" ).default( true );
		    table.timestamp( "approvalTime" );
		    table.timestamp( "fulfilledTime" );
		    table.decimal( "subtotal" );
		    table.decimal( "shipping" );
		    table.decimal( "fees" );
		    table.decimal( "tax" );
		    table.decimal( "discount" );
		    table.decimal( "total" );
		    table.timestamp( "paidInFull" );
		    
		    table.uuid( "FK_customer" )
		    		.references( "id" )
		    		.onTable( "cbc_customers" )
					.onUpdate( "CASCADE" )
					.onDelete( "CASCADE" );

			table.uuid( "FK_shippingAddress" )
		    		.references( "id" )
		    		.onTable( "cbc_customerAddresses" );


			table.uuid( "FK_billingAddress" )
		    		.references( "id" )
		    		.onTable( "cbc_customerAddresses" );

    	} );

    	schema.create( "cbc_orderItems", function( table ){
    		table.uuid( "id" ).primaryKey();
		    table.timestamp( "createdTime" );
		    table.timestamp( "modifiedTime" );
			table.boolean( "isActive" ).default( true );
			table.boolean( "isVirtual" ).default( false );

			table.integer( "quantityOrdered" ).default( 1 );
			table.integer( "quantityCancelled" ).default( 0 );
			table.integer( "quantityRefunded" ).default( 0 );
			table.integer( "quantityDownloaded" ).nullable( 0 );

			table.decimal( "originalPrice" );
			table.decimal( "originalCost" );

			table.json( "productSnapshot" ).default('{}');

		    table.uuid( "FK_order" )
					.references( "id" )
					.onTable( "cbc_orders" )
					.onUpdate( "CASCADE" )
					.onDelete( "CASCADE" );   
		} );
		
		schema.create( "cbc_orderShipments", function( table ){
    		table.uuid( "id" ).primaryKey();
		    table.timestamp( "createdTime" );
		    table.timestamp( "modifiedTime" );
			table.boolean( "isActive" ).default( true );

			table.integer( "quantity" );

			table.uuid( "FK_order" )
					.references( "id" )
					.onTable( "cbc_orderItems" );
			
			table.uuid( "FK_inventoryLocation" )
					.references( "id" )
					.onTable( "cbc_inventoryLocations" );

		});

    	schema.create( "cbc_payments", function( table ){
    		table.uuid( "id" ).primaryKey();
		    table.timestamp( "createdTime" );
		    table.timestamp( "modifiedTime" );
		    table.boolean( "isActive" ).default( true );
		    table.string( "externalTransactionID" );
		    table.index( [ "externalTransactionID" ], "IDX_externalTransactionID" );
		    table.decimal( "amount" );
		    table.text( "comment" );
		    table.integer( "lastFour" );
		    table.string( "paymentMethod" );

			table.uuid( "FK_order" )
					.references( "id" )
					.onTable( "cbc_orders" )
					.onUpdate( "CASCADE" )
					.onDelete( "CASCADE" ); 
    	} );


        schema.create( "cbc_carts", function( table ) {
		    table.uuid( "id" ).primaryKey();
		    table.timestamp( "createdTime" );
		    table.timestamp( "modifiedTime" );
		    table.boolean( "isActive" ).default( true );
		    table.json( "contents" );
		    table.json( "audit" );

		    table.uuid( "FK_customer" )
		    		.references( "id" )
		    		.onTable( "cbc_customers" )
					.onUpdate( "CASCADE" )
					.onDelete( "CASCADE" );

		    table.uuid( "FK_order" ).references( "id" ).onTable( "cbc_orders" );

		} );


        schema.create( "cbc_wishlists", function( table ) {
		    table.uuid( "id" ).primaryKey();
		    table.timestamp( "createdTime" );
		    table.timestamp( "modifiedTime" );
			table.boolean( "isActive" ).default( true );
			
			table.string( "name", 255 );
			
			table.uuid( "FK_customer" )
		    		.references( "id" )
		    		.onTable( "cbc_customers" )
					.onUpdate( "CASCADE" )
					.onDelete( "CASCADE" );
		    

		    
		} );

		schema.create( "cbc_wishlistItems", function( ){
		    table.uuid( "id" ).primaryKey();
		    table.timestamp( "createdTime" );
		    table.timestamp( "modifiedTime" );
			table.boolean( "isActive" ).default( true );

			table.uuid( "FK_product" )
		    		.references( "id" )
		    		.onTable( "cbc_products" )
					.onDelete( "CASCADE" );

		} );


        schema.create( "cbc_media", function( table ) {
		    table.uuid( "id" ).primaryKey();
		    table.timestamp( "createdTime" );
		    table.timestamp( "modifiedTime" );
			table.boolean( "isActive" ).default( true );
			table.string( "designation" ).default( 'product' );
			table.string( "title", 255 ).nullable();
			table.string( "caption", 750 ).nullable();
		    table.string( 'originalFileName', 255 );
            table.string( 'fileLocation', 255 );
            table.integer( 'fileSizeBytes' ).default( 0 );
		} );

		// create media lookups table
		schema.create( "cbc_productMedia", function( table ) {
		    table.uuid( "id" ).primaryKey();
		    table.timestamp( "createdTime" );
		    table.timestamp( "modifiedTime" );
		    table.boolean( "isActive" ).default( true );
			table.boolean( "isPrimary" ).default( false );
			table.integer( "displayOrder" ).default( 0 );

			table.uuid( "FK_media" )
		    		.references( "id" )
		    		.onTable( "cbc_media" )
					.onUpdate( "CASCADE" );

			table.uuid( "FK_product" )
		    		.references( "id" )
		    		.onTable( "cbc_products" )
					.onDelete( "CASCADE" );

		} );

		// create sku-specific media lookups table
		schema.create( "cbc_productSKUMedia", function( table ) {
		    table.uuid( "id" ).primaryKey();
		    table.timestamp( "createdTime" );
		    table.timestamp( "modifiedTime" );
		    table.boolean( "isActive" ).default( true );
			table.boolean( "isPrimary" ).default( false );
			table.integer( "displayOrder" ).default( 0 );

			table.uuid( "FK_media" )
		    		.references( "id" )
		    		.onTable( "cbc_media" )
					.onUpdate( "CASCADE" );

			table.uuid( "FK_sku" )
		    		.references( "id" )
		    		.onTable( "cbc_skus" )
					.onDelete( "CASCADE" );

		} );

    }

    function down( schema ) {
        schema.dropIfExists( "cbc_orderShipments" );
        schema.dropIfExists( "cbc_orderItems" );
        schema.dropIfExists( "cbc_payments" );
		schema.dropIfExists( "cbc_orders" );
		schema.dropIfExists( "cbc_inventoryLocationStock");
		schema.dropIfExists( "cbc_inventoryLocations");
		schema.dropIfExists( "cbc_lookups_products_categories" );
		schema.dropIfExists( "cbc_productCategories" );
		schema.dropIfExists( "cbc_productSKUMedia" );
		schema.dropIfExists( "cbc_productMedia" );
		schema.dropIfExists( "cbc_media" );
		schema.dropIfExists( "cbc_wishlists" );
		schema.dropIfExists( "cbc_wishlistItems" );
        schema.dropIfExists( "cbc_carts" );
		schema.dropIfExists( "cbc_virtualSKUs" );
		schema.dropIfExists( "cbc_SKUs" );
		schema.dropIfExists( "cbc_products" );
        schema.dropIfExists( "cbc_customerAddresses" );
        schema.dropIfExists( "cbc_customers" );
    }

}
