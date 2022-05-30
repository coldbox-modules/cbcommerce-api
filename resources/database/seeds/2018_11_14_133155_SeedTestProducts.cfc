component {

    function up( SchemaBuilder schema, QueryBuilder query ) {
        var wirebox = application.wirebox;
        var mockCategories = wirebox.getInstance( "MockData@MockDataCFC" )
                            .mock(argumentCollection={
                                $num=5,
                                "name"="words",
                                "description" = "sentence"
							}
                            );
		var resourcesDirectory = replace( getDirectoryFromPath( getCurrentTemplatePath() ), "/seeds", "" );
        createdCategories = [];
        mockCategories.each( function( cat ){
            var created = wirebox.getInstance( "ProductCategory@cbCommerce" );
            created.fill( cat ).save().refresh();
			var mediaItem = wirebox.getInstance( "Media@cbCommerce" );
			var mediaFile = resourcesDirectory & '/migration-data/SeedTestProducts-Images/' & randRange( 1, 9 ) & '.jpg';
		    mediaItem.loadFile(
				filePath=mediaFile,
				pathExtension="categories/#created.getId()#"
			).fill(
				{
					"title" : listLast( mediaFile, "/" ),
					"caption" : "category image for #created.getName()#",
					"designation" : "category"
				}
			).save().refresh();

			var categoryMedia = wirebox.getInstance( "ProductCategoryMedia@cbCommerce" ).fill( { "isPrimary" : 1, "FK_category" : created.getId(), "FK_media" : mediaItem.getId() } );
			categoryMedia.save();
            arrayAppend( createdCategories, created );
        } );

		var mockInventoryLocation = wirebox.getInstance( "InventoryLocation@cbCommerce" );
		mockInventoryLocation.fill( {
			"name"  : "Primary Warehouse",
			"description"  : "The primary warehouse location",
			"address1" : "123 Anywhere Lane",
			"city" : "Grand Rapids",
			"province" : "MI",
			"postalCode" : "49546",
			"country" : "USA"
		} ).save();


        var mockProducts = wirebox.getInstance( "MockData@MockDataCFC" )
                            .mock(argumentCollection={
                                $num=30,
                                "name" = "words:2",
                                "shortDescription" = "sentence:3",
                                "description" = "sentence:4"
                            });

        mockProducts.each( function( prod ){
            var createdProduct = wirebox.getInstance( "Product@cbCommerce" );
            createdProduct.fill( prod ).save().refresh();
			createdProduct.categories().sync( [ createdCategories[ randRange( 1, 5 ) ] ] );
            var cost = arrayLen( wirebox.getInstance( "MockData@MockDataCFC" ).mock( $num = "rnd:50:2000" ) );
            var basePrice = arrayLen( wirebox.getInstance( "MockData@MockDataCFC" ).mock( $num = "rnd:#cost*1.1#:#cost*1.3#" ) );
            var minimumPrice = arrayLen( wirebox.getInstance( "MockData@MockDataCFC" ).mock( $num = "rnd:#cost#:#basePrice#" ) );

			var mediaItem = wirebox.getInstance( "Media@cbCommerce" );
			var mediaFile = resourcesDirectory & '/migration-data/SeedTestProducts-Images/' & randRange( 1, 9 ) & '.jpg';
		    mediaItem.loadFile(
				filePath=mediaFile,
				pathExtension="products/#createdProduct.getId()#"
			).fill(
				{
					"title" : listLast( mediaFile, "/" ),
					"caption" : "Product image for #createdProduct.getName()#",
					"designation" : "product"
				}
			).save().refresh();

			var productMedia = wirebox.getInstance( "ProductMedia@cbCommerce" ).fill( { "isPrimary" : 1, "FK_product" : createdProduct.getId(), "FK_media" : mediaItem.getId() } );
			productMedia.save();


            var mockSkus = wirebox.getInstance( "MockData@MockDataCFC" )
                                    .mock( argumentCollection={
                                        $num = "rnd:1:5",
                                        "cost" = "num:#cost#:#cost#",
										"summary" = "sentence",
										"description" = "sentence:4",
                                        "basePrice" = "num:#basePrice#:#basePrice#",
                                        "minimumPrice" = "num:#minimumPrice#:#minimumPrice#",
                                        "packagedWeight" = "num:1:20",
                                        "packagingX" = "num:1:20",
                                        "packagingY" = "num:1:20"
                                    });

            mockSkus.each( function( sku ){
				sku[ "FK_product" ] = createdProduct.getId();
				sku[ "modelNumber" ] = listLast( createUUID, "-" );
                var createdSku = wirebox.getInstance( "ProductSKU@cbcommerce" );
                createdSku.fill( sku );
                createdSku.save().refresh();
				var stock = wirebox.getInstance( "InventoryLocationStock@cbCommerce" );
				stock.fill(
					{
						"available" : 100,
						"allowBackorder" : 1,
						"FK_sku" : createdSKU.getId(),
						"FK_inventoryLocation" : mockInventoryLocation.getId()
					}
				).save();

				var mediaItem = wirebox.getInstance( "Media@cbCommerce" );
				var mediaFile = resourcesDirectory & '/migration-data/SeedTestProducts-Images/' & randRange( 1, 9 ) & '.jpg';
				mediaItem.loadFile(
					filePath=mediaFile,
					pathExtension="products/#createdProduct.getId()#/skus/#createdSKU.getId()#"
				).fill(
					{
						"title" : listLast( mediaFile, "/" ),
						"caption" : "Product sku image for #createdProduct.getName()# sku #createdSku.getId()#",
						"designation" : "sku"
					}
				).save().refresh();

				var productSkuMedia = wirebox.getInstance( "ProductSKUMedia@cbCommerce" ).fill( { "isPrimary" : 1, "FK_sku" : createdSku.getId(), "FK_media" : mediaItem.getId() } );
				productSkuMedia.save();
            } );
        } );


    }

    function down( SchemaBuilder schema, QueryBuilder query ) {

    }

}
