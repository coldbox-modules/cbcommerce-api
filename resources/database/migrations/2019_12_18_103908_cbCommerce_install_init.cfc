component {

    function up( schema, query ) {

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
            table.string( "resetToken", 255 ).nullable();
        } );

        schema.create( "cbc_userPermissions", function( table ){
            table.uuid( 'id' ).primaryKey();
            table.timestamp( "createdTime" ).default( 'CURRENT_TIMESTAMP' );
            table.timestamp( "modifiedTime" ).default( 'CURRENT_TIMESTAMP' );
            table.string( 'prefix', 75 );
            table.string( 'suffix', 75 );
        } );

        var prefixes  = [ "cbcProduct", "cbcOrder", "cbcReturn" , "cbcSystem" ];
        var suffixes = [ "Configure", "Manage" , "Edit", "Approve", "Delete" ];

        for( var prefix in prefixes ){
            for( var suffix in suffixes ){
                query.newQuery().from( "cbc_userPermissions" ).insert(
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
        query.newQuery().from( "cbc_userRoles" ).insert(
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
                },
                {
                    "id" : createUUID(),
                    "name" : "Consignor"
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
            table.string( 'address2', 255 ).nullable();
            table.string( 'city', 255 );
            table.string( 'province', 3 );
            table.string( 'postalCode', 15);
            table.string( 'country', 3 ).default( "USA" );
            table.boolean( 'isPrimary' ).default( 0 );
            table.string( 'fullName', 255 ).nullable();
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
            table.integer( "displayOrder" ).default( 0 );
            table.string( "externalId" ).nullable();
            table.string( "manufacturer" ).nullable();
            table.boolean( "isFeatured" ).default( 0 );
            table.integer( "hitCount" ).default( 0 );
        } );


        schema.create( "cbc_productCategories", function( table ) {
            table.uuid( "id" ).primaryKey();
            table.timestamp( "createdTime" ).default( 'CURRENT_TIMESTAMP' );
            table.timestamp( "modifiedTime" ).default( 'CURRENT_TIMESTAMP' );
            table.boolean( "isActive" ).default( 1 );

            table.string( "name" );
            table.string( "description");
            table.integer( "displayOrder" ).default( 0 );

            table.uuid( "FK_parent" )
                    .nullable()
                    .references( "id" )
                    .onTable( "cbc_productCategories" );
            table.boolean( "isFeatured" ).default( 0 );
            table.integer( "hitCount" ).default( 0 );

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

        query.newQuery().from( "cbc_productConditions" ).insert(
            values = topLevelConditions
        );

        query.newQuery().from( "cbc_productConditions" ).insert(
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

            table.uuid( "FK_product" )
                    .references( "id" )
                    .onTable( "cbc_products" );

            table.uuid( "FK_consignor" )
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

            table.integer( "displayOrder" ).default( 0 );
            table.string( "externalId" ).nullable();
            table.string( "modelNumber" ).nullable();
            table.boolean( "allowBackorder" ).default( 1 );
            table.boolean( "isFeatured" ).default( 0 );
            table.decimal( "MAP", 8, 2  ).nullable();
            table.string( "summary", 1000 ).nullable();
            table.text( "description" ).nullable();
            table.uuid( "FK_consignmentBatch" ).nullable();
            table.boolean( "showPricing" ).default( 1 );
            table.boolean( "pickUpInStore").default( 0 );
        } );

		schema.alter( "cbc_SKUs", function( table ){
			table.uuid( "FK_consignmentBatch" ).references( "id" ).onTable( "cbc_consignmentBatches" );
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

            table.string( 'address1', 255 ).nullable();
            table.string( 'address2', 255 ).nullable();
            table.string( 'city', 255 ).nullable();
            table.string( 'province', 3 ).nullable();
            table.string( 'postalCode', 15).nullable();
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
                    .onTable( "cbc_SKUs" );

            table.uuid( "FK_inventoryLocation" )
                    .references( "id" )
                    .onTable( "cbc_inventoryLocations" );

        });



        schema.create( "cbc_orders", function( table ){
            table.uuid( "id" ).primaryKey();
            table.timestamp( "createdTime" ).default( 'CURRENT_TIMESTAMP' );
            table.timestamp( "modifiedTime" ).default( 'CURRENT_TIMESTAMP' );
            table.boolean( "isActive" ).default( 1 );
            table.timestamp( "approvalTime" ).nullable();
            table.timestamp( "fulfilledTime" ).nullable();
            table.decimal( "subtotal", 8, 2  );
            table.decimal( "shipping", 8, 2  );
            table.decimal( "fees", 8, 2  );
            table.decimal( "tax", 8, 2  );
            table.decimal( "discount", 8, 2  );
            table.decimal( "total", 8, 2  );
            table.timestamp( "paidInFull" ).nullable();
			table.uuid( "FK_invoice" ).nullable();
        } );

		schema.alter( "cbc_orders", function( table ){
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

			table.uuid( "FK_invoice" )
					.references( "id" )
					.onTable( "cbc_orderInvoices" );


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
            table.boolean( "isDefault" ).default( 0 );
            table.boolean( "isPublic" ).default( 0 );
            table.string( "description", 750 ).nullable();

        } );

        schema.create( "cbc_wishlistItems", function( table ){
            table.uuid( "id" ).primaryKey();
            table.timestamp( "createdTime" ).default( 'CURRENT_TIMESTAMP' );
            table.timestamp( "modifiedTime" ).default( 'CURRENT_TIMESTAMP' );
            table.boolean( "isActive" ).default( 1 );

            table.decimal( "baselinePrice" );

            table.uuid( "FK_sku" )
                    .references( "id" )
                    .onTable( "cbc_SKUs" )
                    .onDelete( "CASCADE" );

            table.uuid( "FK_wishlist" )
                    .references( "id" )
                    .onTable( "cbc_wishlists" )
                    .onUpdate( "CASCADE" )
                    .onDelete( "CASCADE" );
            table.decimal( "discountPrice" ).default( 0 );
            table.integer( "quantity" ).default( 1 );

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
                    .onTable( "cbc_SKUs" )
                    .onDelete( "CASCADE" );

        } );

        //======

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

        //======

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


        //======

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



        query.newQuery().from( "cbc_userRoles" ).insert(
            values = [
                {
                    "id" : createUUID(),
                    "name" : "Consignor"
                }
            ]
        );

        //======

        schema.create( "cbc_productSKUOptions", function( table ) {
            table.uuid( "id" ).primaryKey();
            table.timestamp( "createdTime" ).default( 'CURRENT_TIMESTAMP' );
            table.timestamp( "modifiedTime" ).default( 'CURRENT_TIMESTAMP' );
            table.boolean( "isActive" ).default( 1 );
            table.integer( "displayOrder" ).default( 0 );

            table.string( "name", 100 );
            table.string( "value", 255 );

            table.uuid( "FK_sku" )
                    .references( "id" )
                    .onTable( "cbc_SKUs" );
        } );

        //======
        schema.create( "cbc_consignmentBatches", function( table ) {
            table.uuid( "id" ).primaryKey();
            table.timestamp( "createdTime" ).default( 'CURRENT_TIMESTAMP' );
            table.timestamp( "modifiedTime" ).default( 'CURRENT_TIMESTAMP' );
            table.boolean( "isActive" ).default( 1 );
            table.string( "externalId", 75 ).nullable();
            table.string( "summary", 400 );
            table.text( "description" ).nullable();
            table.decimal( "consignorPercent", 8, 2 ).default( 0 );
            table.decimal( "cleaningHourlyRate", 8, 2 ).default( 0 );
            table.decimal( "repairHourlyRate", 8, 2 ).default( 0 );


            table.uuid( "FK_consignor" )
                .references( "id" )
                .onTable( "cbc_users" );

        } );



        schema.create( "cbc_consignmentFeeTypes", function( table ) {
            table.uuid( "id" ).primaryKey();
            table.string( "name", 300 );
            table.string( "description", 750 );
            table.integer( "displayOrder" ).default( 0 );
        });

        var feeTypes = [
            {
                "id" : createUUID(),
                "name" : "Storage",
                "description" : "Fees for storage or warehousing of consigment items",
                "displayOrder" : 1
            },
            {
                "id" : createUUID(),
                "name" : "Cleaning",
                "description" : "Fees for cleaning or prepping consigment items",
                "displayOrder" : 2
            },
            {
                "id" : createUUID(),
                "name" : "Repair",
                "description" : "Fees for repair and maintenance of consigment items",
                "displayOrder" : 3
            },
            {
                "id" : createUUID(),
                "name" : "Disposal",
                "description" : "Fees for disposal of consignment items",
                "displayOrder" : 4
            },
            {
                "id" : createUUID(),
                "name" : "Shipping",
                "description" : "Fees for shipping or return shipping of consignment items",
                "displayOrder" : 5
            },
            {
                "id" : createUUID(),
                "name" : "Other",
                "description" : "Other fees, not listed",
                "displayOrder" : 6
            }
        ];

        query.newQuery().from( "cbc_consignmentFeeTypes" ).insert(
            values = feeTypes
        );

        schema.create( "cbc_consignmentBatchFees", function( table ){
            table.uuid( "id" ).primaryKey();
            table.timestamp( "createdTime" ).default( 'CURRENT_TIMESTAMP' );
            table.timestamp( "modifiedTime" ).default( 'CURRENT_TIMESTAMP' );
            table.boolean( "isActive" ).default( 1 );
            table.decimal( "amount", 8, 2 ).default( 0 );
            table.text( "notes" ).nullable();
            table.boolean( "isPaid" ).default( 0 );

            table.uuid( "FK_batch" )
                .references( "id" )
                .onTable( "cbc_consignmentBatches" );

            table.uuid( "FK_feeType" )
                .references( "id" )
                .onTable( "cbc_consignmentFeeTypes" );

            table.uuid( "FK_createdBy" )
                .references( "id" )
                .onTable( "cbc_users" );

        } );

        //======

        schema.create( "cbc_tenantSettings", function( table ) {
            table.uuid( "id" ).primaryKey();
            table.timestamp( "createdTime" ).default( 'CURRENT_TIMESTAMP' );
            table.timestamp( "modifiedTime" ).default( 'CURRENT_TIMESTAMP' );
            table.string( 'key' );
            table.text( 'value' );
        } );


        schema.alter( "cbc_products", function( table ){
            table.addConstraint( table.index( "name", "idx_cbc_products_name" ) );
        } );

        schema.alter( "cbc_productCategoryMedia", function( table ){
            table.addConstraint( table.index( "isPrimary", "idx_productCategoryMedia_isPrimary" ) );
            table.addConstraint( table.index( [ "displayOrder", "createdTime" ], "idx_productCategoryMedia_sort" ) );
        } );

        schema.alter( "cbc_productMedia", function( table ){
            table.addConstraint( table.index( "isPrimary", "idx_productMedia_isPrimary" ) );
            table.addConstraint( table.index( [ "displayOrder", "createdTime" ], "idx_productMedia_sort" ) );
        } );
    }

}
