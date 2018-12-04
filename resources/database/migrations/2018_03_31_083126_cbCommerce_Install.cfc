component {

    function up( SchemaBuilder schema, QueryBuilder query) {

		// @TODO - unable to use this until QB-10 is resolved
		// var uuidLib = createobject("java", "java.util.UUID");

		schema.create( "cbc_users", function( table ){
    		table.uuid( "id" ).primaryKey();
		    table.timestamp( "createdTime" ).default( 'CURRENT_TIMESTAMP' );
		    table.timestamp( "modifiedTime" ).default( 'CURRENT_TIMESTAMP' );
			table.boolean( "isActive" ).default( 1 );
			table.string('firstName', 255).nullable();
            table.string('lastName', 255).nullable();
            table.string('email', 255).unique();
            table.string('password');
            table.char( 'primaryPhone', 25 ).nullable();
            table.char( 'secondaryPhone', 25 ).nullable();
		} );

		schema.create( "cbc_userPermissions", function( table ){
			table.uuid( 'id' ).primaryKey();
            table.timestamp( "createdTime" ).default( 'CURRENT_TIMESTAMP' );
		    table.timestamp( "modifiedTime" ).default( 'CURRENT_TIMESTAMP' );
            table.string( 'prefix', 75 );
            table.string( 'suffix', 75 );
		} );

		var prefixes  = [ "Product", "Order", "Return" , "System" ];
		var suffixes = [ "Configure", "Manage" , "Edit", "Approve", "Delete" ];

		for( var prefix in prefixes ){
			for( var suffix in suffixes ){
				query.from( "cbc_userPermissions" ).insert( 
					values = {
							"id" : createUUID(),
							"prefix" : prefix,
							"suffix" : suffix	
						}
				);
			}
		}
		

		schema.create( "cbc_userRoles", function( table ){
			table.uuid( 'id' ).primaryKey();
            table.timestamp( "createdTime" ).default( 'CURRENT_TIMESTAMP' );
		    table.timestamp( "modifiedTime" ).default( 'CURRENT_TIMESTAMP' );
			table.boolean( "isActive" ).default( 1 );
            table.string( 'name', 75 );
		});

		// Insert our intial roles
		query.from( "cbc_userRoles" ).insert(
			values = [
				{
					"id" : createUUID(),
					"name" : "User"
				},
				{
					"id" : createUUID(),
					"name" : "Marketer"
				},
				{
					"id" : createUUID(),
					"name" : "Editor"
				},
				{
					"id" : createUUID(),
					"name" : "Manager"
				},
				{
					"id" : createUUID(),
					"name" : "Administrator"
				}
			]
		);

		schema.create('cbc_lookups_users_roles', function ( table ) {
            table.increments('id');
			
			table.uuid( 'FK_user')
		    		.references( "id" )
		    		.onTable( "cbc_users" )
					.onUpdate( "CASCADE" )
					.onDelete( "CASCADE" );

			table.uuid( 'FK_user_role')
					.references('id')
					.onTable('cbc_userRoles')
					.onUpdate( "CASCADE" )
					.onDelete( "CASCADE" );
		});

		
		schema.create('cbc_lookups_roles_permissions', function ( table ) {
			table.increments('id');
			
			table.uuid( 'FK_permission')
					.references('id')
					.onTable('cbc_userPermissions')
					.onUpdate( "CASCADE" )
					.onDelete( "CASCADE" );

			table.uuid( 'FK_user_role')
					.references('id')
					.onTable('cbc_userRoles')
					.onUpdate( "CASCADE" )
					.onDelete( "CASCADE" );
		});
		
		schema.create('cbc_lookups_users_explicitPermissions', function ( table ) {
            table.increments('id');
			
			table.uuid( 'FK_permission')
					.references('id')
					.onTable('cbc_userPermissions')
					.onUpdate( "CASCADE" )
					.onDelete( "CASCADE" );
			
			table.uuid( 'FK_user')
					.references('id')
					.onTable( 'cbc_users' )
					.onUpdate( "CASCADE" )
					.onDelete( "CASCADE" );
        });
		

    	schema.create( "cbc_customerAddresses", function( table ){
    		table.uuid( "id" ).primaryKey();
		    table.timestamp( "createdTime" ).default( 'CURRENT_TIMESTAMP' );
		    table.timestamp( "modifiedTime" ).default( 'CURRENT_TIMESTAMP' );
		    table.boolean( "isActive" ).default( 1 );
			table.string( "designation", 25 );
			
			table.string( 'address1', 255 );
			table.string( 'address2', 255 );
			table.string( 'city', 255 );
			table.string( 'province', 3 );
			table.string( 'postalCode', 15);
			table.string( 'country', 3 ).default( "USA" );
			table.boolean( 'isPrimary' ).default( 0 );

		    table.uuid( "FK_user" )
		    		.references( "id" )
		    		.onTable( "cbc_users" )
					.onUpdate( "CASCADE" )
					.onDelete( "CASCADE" );
		    
    	} );


        schema.create( "cbc_products", function( table ) {
		    table.uuid( "id" ).primaryKey();
		    table.timestamp( "createdTime" ).default( 'CURRENT_TIMESTAMP' );
		    table.timestamp( "modifiedTime" ).default( 'CURRENT_TIMESTAMP' );
			table.boolean( "isActive" ).default( 1 );
			
			table.string( "name", 300 );
			table.string( "shortDescription", 1000 );
			table.text( "description" );
			table.boolean( "hasOptions");
			table.json( "requiredOptions" );

		    
		} );


        schema.create( "cbc_productCategories", function( table ) {
		    table.uuid( "id" ).primaryKey();
		    table.timestamp( "createdTime" ).default( 'CURRENT_TIMESTAMP' );
		    table.timestamp( "modifiedTime" ).default( 'CURRENT_TIMESTAMP' );
			table.boolean( "isActive" ).default( 1 );

			table.string( "name" );
			table.string( "description");

			table.uuid( "FK_parent" )
					.nullable()
		    		.references( "id" )
		    		.onTable( "cbc_productCategories" );

		});

		schema.create( "cbc_lookups_products_categories", function( table ){

			table.increments( "increments" );

			table.uuid( "FK_product" )
		    		.references( "id" )
					.onTable( "cbc_products" );
					
			table.uuid( "FK_category" )
		    		.references( "id" )
					.onTable( "cbc_productCategories" );

					
		});

		schema.create( "cbc_productConditions", function( table ){
			table.uuid( "id" ).primaryKey();
		    table.timestamp( "createdTime" ).default( 'CURRENT_TIMESTAMP' );
		    table.timestamp( "modifiedTime" ).default( 'CURRENT_TIMESTAMP' );
			table.boolean( "isActive" ).default( 1 );

			table.string( "name", 25 );
			
			table.uuid( "FK_parent" )
					.nullable()
		    		.references( "id" )
					.onTable( "cbc_productConditions" );
		
		} );

		var topLevelConditions = [
			{
				"id" : createUUID(),
				"name" : "New"
			},
			{
				"id" : createUUID(),
				"name" : "Used"
			}
		];

		var subConditions = [
			{
				"id" : createUUID(),
				"name" : "Unopened",
				"FK_parent" : topLevelConditions[ 1 ].id
			},
			{
				"id" : createUUID(),
				"name" : "Like New",
				"FK_parent" : topLevelConditions[ 2 ].id
			},
			{
				"id" : createUUID(),
				"name" : "Excellent",
				"FK_parent" : topLevelConditions[ 2 ].id
			},
			{
				"id" : createUUID(),
				"name" : "Good",
				"FK_parent" : topLevelConditions[ 2 ].id
			},
			{
				"id" : createUUID(),
				"name" : "Fair",
				"FK_parent" : topLevelConditions[ 2 ].id
			},
			{
				"id" : createUUID(),
				"name" : "Poor",
				"FK_parent" : topLevelConditions[ 2 ].id
			}

		];

		query.from( "cbc_productConditions" ).insert(
			values = topLevelConditions
		);

		query.from( "cbc_productConditions" ).insert(
			values = subConditions
		);


        schema.create( "cbc_SKUs", function( table ) {
		    table.uuid( "id" ).primaryKey();
		    table.timestamp( "createdTime" ).default( 'CURRENT_TIMESTAMP' );
		    table.timestamp( "modifiedTime" ).default( 'CURRENT_TIMESTAMP' );
			table.boolean( "isActive" ).default( 1 );
			table.boolean( "isVirtual" ).default( 0 );
			table.boolean( "isConsigned").default( 0 );
			table.decimal( "cost", 8, 2 );
			table.decimal( "basePrice",  8, 2  );
			table.text( "conditionDescription" ).nullable();
			table.decimal( "minimumPrice", 8, 2  ).nullable();
			table.decimal( "MSRP", 8, 2  ).nullable();
			table.timestamp( "discontinueOn" ).nullable();
			table.decimal( "packagedWeight", 8, 2  ).default( 0 );
			table.decimal( "packagingX", 8, 2  ).default( 0 );
			table.decimal( "packagingY", 8, 2  ).default( 0 );
			table.decimal( "packagingZ", 8, 2  ).default( 0 );
			table.json( "options" );

			table.uuid( "FK_product" )
		    		.references( "id" )
					.onTable( "cbc_products" );

			table.uuid( "FK_consignee" )
					.nullable()
		    		.references( "id" )
					.onTable( "cbc_users" );

			table.uuid( "FK_condition" )
					.default( "'#topLevelConditions[ 1 ].id#'" )
					.references( "id" )
					.onTable( "cbc_productConditions" );

			table.uuid( "FK_subCondition" )
					.nullable()
					.references( "id" )
					.onTable( "cbc_productConditions" );
					
		} );

		schema.create( "cbc_virtualSKUs", function( table ){
		    table.uuid( "id" ).primaryKey();
		    table.timestamp( "createdTime" ).default( 'CURRENT_TIMESTAMP' );
		    table.timestamp( "modifiedTime" ).default( 'CURRENT_TIMESTAMP' );
			table.boolean( "isActive" ).default( 1 );

			table.string( "location", 255 );

			table.uuid( "FK_sku" )
		    		.references( "id" )
		    		.onTable( "cbc_SKUs" );
		} );

		schema.create( "cbc_inventoryLocations", function( table ) {
		    table.uuid( "id" ).primaryKey();
		    table.timestamp( "createdTime" ).default( 'CURRENT_TIMESTAMP' );
		    table.timestamp( "modifiedTime" ).default( 'CURRENT_TIMESTAMP' );
			table.boolean( "isActive" ).default( 1 );

			table.string( "name", 255 );
			table.string( "description" ).nullable();

			table.string( 'address1', 255 );
			table.string( 'address2', 255 );
			table.string( 'city', 255 );
			table.string( 'province', 3 );
			table.string( 'postalCode', 15);
			table.string( 'country', 3 ).default( "USA" );
		    
		} );

		schema.create( "cbc_inventoryLocationStock", function( table ) {
		    table.uuid( "id" ).primaryKey();
		    table.timestamp( "createdTime" ).default( 'CURRENT_TIMESTAMP' );
		    table.timestamp( "modifiedTime" ).default( 'CURRENT_TIMESTAMP' );
			table.boolean( "isActive" ).default( 1 );

			table.integer( "available" ).default( 0 );
			table.integer( "unaccounted" ).default( 0 );
			table.boolean( "countRequired" ).default( 0 );
			table.boolean( "allowBackorder" ).default( 0 );

			table.uuid( "FK_sku" )
		    		.references( "id" )
		    		.onTable( "cbc_skus" );

			table.uuid( "FK_inventoryLocation" )
		    		.references( "id" )
		    		.onTable( "cbc_inventoryLocations" );

		});

		

		schema.create( "cbc_orders", function( table ){
    		table.uuid( "id" ).primaryKey();
		    table.timestamp( "createdTime" ).default( 'CURRENT_TIMESTAMP' );
		    table.timestamp( "modifiedTime" ).default( 'CURRENT_TIMESTAMP' );
		    table.boolean( "isActive" ).default( 1 );
		    table.timestamp( "approvalTime" );
		    table.timestamp( "fulfilledTime" );
		    table.decimal( "subtotal", 8, 2  );
		    table.decimal( "shipping", 8, 2  );
		    table.decimal( "fees", 8, 2  );
		    table.decimal( "tax", 8, 2  );
		    table.decimal( "discount", 8, 2  );
		    table.decimal( "total", 8, 2  );
		    table.timestamp( "paidInFull" );
		    
		    table.uuid( "FK_user" )
		    		.references( "id" )
		    		.onTable( "cbc_users" )
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
		    table.timestamp( "createdTime" ).default( 'CURRENT_TIMESTAMP' );
		    table.timestamp( "modifiedTime" ).default( 'CURRENT_TIMESTAMP' );
			table.boolean( "isActive" ).default( 1 );
			table.boolean( "isVirtual" ).default( 0 );

			table.integer( "quantityOrdered" ).default( 1 );
			table.integer( "quantityCancelled" ).default( 0 );
			table.integer( "quantityRefunded" ).default( 0 );
			table.integer( "quantityDownloaded" ).nullable( 0 );

			table.decimal( "originalPrice", 8, 2  );
			table.decimal( "originalCost", 8, 2  );

			table.json( "productSnapshot" ).nullable();

		    table.uuid( "FK_order" )
					.references( "id" )
					.onTable( "cbc_orders" )
					.onUpdate( "CASCADE" )
					.onDelete( "CASCADE" );   
		} );
		
		schema.create( "cbc_orderShipments", function( table ){
    		table.uuid( "id" ).primaryKey();
		    table.timestamp( "createdTime" ).default( 'CURRENT_TIMESTAMP' );
		    table.timestamp( "modifiedTime" ).default( 'CURRENT_TIMESTAMP' );
			table.boolean( "isActive" ).default( 1 );

			table.integer( "quantity" );
			table.string( "carrierReferenceNumber", 125 );

			table.uuid( "FK_order" )
					.references( "id" )
					.onTable( "cbc_orderItems" );
			
			table.uuid( "FK_inventoryLocation" )
					.references( "id" )
					.onTable( "cbc_inventoryLocations" );

		});

    	schema.create( "cbc_payments", function( table ){
    		table.uuid( "id" ).primaryKey();
		    table.timestamp( "createdTime" ).default( 'CURRENT_TIMESTAMP' );
		    table.timestamp( "modifiedTime" ).default( 'CURRENT_TIMESTAMP' );
		    table.boolean( "isActive" ).default( 1 );
		    table.string( "externalTransactionID" );
		    table.index( [ "externalTransactionID" ], "IDX_externalTransactionID" );
		    table.decimal( "amount", 8, 2  );
		    table.text( "comment" ).nullable();
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
		    table.timestamp( "createdTime" ).default( 'CURRENT_TIMESTAMP' );
		    table.timestamp( "modifiedTime" ).default( 'CURRENT_TIMESTAMP' );
		    table.boolean( "isActive" ).default( 1 );
		    table.json( "contents" );
		    table.json( "audit" ).nullable();

		    table.uuid( "FK_user" )
					.nullable()
		    		.references( "id" )
		    		.onTable( "cbc_users" )
					.onUpdate( "CASCADE" )
					.onDelete( "CASCADE" );

			table.uuid( "FK_order" )
					.nullable()
					.references( "id" )
					.onTable( "cbc_orders" );

		} );


        schema.create( "cbc_wishlists", function( table ) {
		    table.uuid( "id" ).primaryKey();
		    table.timestamp( "createdTime" ).default( 'CURRENT_TIMESTAMP' );
		    table.timestamp( "modifiedTime" ).default( 'CURRENT_TIMESTAMP' );
			table.boolean( "isActive" ).default( 1 );
			
			table.string( "name", 255 );
			
			table.uuid( "FK_user" )
		    		.references( "id" )
		    		.onTable( "cbc_users" )
					.onUpdate( "CASCADE" )
					.onDelete( "CASCADE" );
		    

		    
		} );

		schema.create( "cbc_wishlistItems", function( table ){
		    table.uuid( "id" ).primaryKey();
		    table.timestamp( "createdTime" ).default( 'CURRENT_TIMESTAMP' );
		    table.timestamp( "modifiedTime" ).default( 'CURRENT_TIMESTAMP' );
			table.boolean( "isActive" ).default( 1 );

			table.decimal( "baselinePrice" );

			table.uuid( "FK_sku" )
		    		.references( "id" )
		    		.onTable( "cbc_skus" )
					.onDelete( "CASCADE" );

			table.uuid( "FK_wishlist" )
					.references( "id" )
					.onTable( "cbc_wishlists" )
					.onUpdate( "CASCADE" )
					.onDelete( "CASCADE" );

		} );


        schema.create( "cbc_media", function( table ) {
		    table.uuid( "id" ).primaryKey();
		    table.timestamp( "createdTime" ).default( 'CURRENT_TIMESTAMP' );
		    table.timestamp( "modifiedTime" ).default( 'CURRENT_TIMESTAMP' );
			table.boolean( "isActive" ).default( 1 );
			table.string( "designation" ).default( "image" );
			table.string( "title", 255 ).nullable();
			table.string( "caption", 750 ).nullable();
		    table.string( 'originalFileName', 255 );
            table.string( 'fileLocation', 255 );
            table.integer( 'fileSizeBytes' ).default( 0 );
		} );

		// create media lookups table
		schema.create( "cbc_productMedia", function( table ) {
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

			table.uuid( "FK_product" )
		    		.references( "id" )
		    		.onTable( "cbc_products" )
					.onDelete( "CASCADE" );

		} );

		// create sku-specific media lookups table
		schema.create( "cbc_productSKUMedia", function( table ) {
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

			table.uuid( "FK_sku" )
		    		.references( "id" )
		    		.onTable( "cbc_skus" )
					.onDelete( "CASCADE" );

		} );

    }

    function down(  SchemaBuilder schema, QueryBuilder query ) {
        schema.dropIfExists( "cbc_orderShipments" );
        schema.dropIfExists( "cbc_orderItems" );
        schema.dropIfExists( "cbc_payments" );
		schema.dropIfExists( "cbc_inventoryLocationStock");
		schema.dropIfExists( "cbc_inventoryLocations");
		schema.dropIfExists( "cbc_lookups_products_categories" );
		schema.dropIfExists( "cbc_productCategories" );
		schema.dropIfExists( "cbc_productSKUMedia" );
		schema.dropIfExists( "cbc_productMedia" );
		schema.dropIfExists( "cbc_media" );
		schema.dropIfExists( "cbc_wishlistItems" );
		schema.dropIfExists( "cbc_wishlists" );
        schema.dropIfExists( "cbc_carts" );
		schema.dropIfExists( "cbc_virtualSKUs" );
		schema.dropIfExists( "cbc_SKUs" );
		schema.dropIfExists( "cbc_productConditions" );
		schema.dropIfExists( "cbc_orders" );
		schema.dropIfExists( "cbc_products" );
		schema.dropIfExists( "cbc_customerAddresses" );
        schema.dropIfExists( "cbc_lookups_users_roles" );
        schema.dropIfExists( "cbc_lookups_roles_permissions" );
        schema.dropIfExists( "cbc_lookups_users_explicitPermissions" );
        schema.dropIfExists( "cbc_userPermissions" );
        schema.dropIfExists( "cbc_userRoles" );
        schema.dropIfExists( "cbc_users" );
    }

}
