component {
    
    function up( SchemaBuilder schema, QueryBuilder query ) {
        var wirebox = application.wirebox;
        var mockCategories = wirebox.getInstance( "MockData@MockDataCFC" )
                            .mock(
                                $num=5,
                                "name" = "words",
                                "description" = "sentence"
                            );
        createdCategories = [];
        mockCategories.each( function( cat ){
            var created = wirebox.getInstance( "ProductCategory@cbCommerce" );
            created.fill( cat ).save();
            arrayAppend( createdCategories, created );
        } );


        var mockProducts = wirebox.getInstance( "MockData@MockDataCFC" )
                            .mock(
                                $num=100,
                                "name" = "words",
                                "shortDescription" = "sentence",
                                "description" = "sentence"
                            );
        
        mockProducts.each( function( prod ){
            var createdProduct = wirebox.getInstance( "Product@cbCommerce" );
            createdProduct.fill( prod ).save();
            var cost = arrayLen( wirebox.getInstance( "MockData@MockDataCFC" ).mock( $num = "rnd:50:2000" ) );
            var basePrice = arrayLen( wirebox.getInstance( "MockData@MockDataCFC" ).mock( $num = "rnd:#cost*1.1#:#cost*1.3#" ) );
            var minimumPrice = arrayLen( wirebox.getInstance( "MockData@MockDataCFC" ).mock( $num = "rnd:#cost#:#basePrice#" ) );

            var mockSkus = wirebox.getInstance( "MockData@MockDataCFC" )
                                    .mock(
                                        $num = "rnd:1:5",
                                        "cost" = "num:#cost#:#cost#",
                                        "basePrice" = "num:#basePrice#:#basePrice#",
                                        "minimumPrice" = "num:#minimumPrice#:#minimumPrice#",
                                        "packagedWeight" = "num:1:20",
                                        "packagingX" = "num:1:20",
                                        "packagingY" = "num:1:20"
                                    );

            mockSkus.each( function( sku ){
                var createdSku = wirebox.getInstance( "ProductSKU@cbcommerce" );
                createdSku.fill( sku );
                createdSku.product().associate( createdProduct );
                createdSku.save();
            } );

            var mockMedia = wirebox.getInstance( "MockData@MockDataCFC" )
                                        .mock(
                                            $num = "rnd:1:8",
                                            "title" = "words",
                                            "caption" = "sentence"
                                        );

            for( var i = 1; i <= arrayLen( mockMedia ); i++ ){
                var mediaItem = wirebox.getInstance( "Media@cbCommerce")
                var mediaFile = expandPath( '/resources/database/migration-data/SeedTestProducts-Images/' & i & '.jpg' );

            }

        } );


    }

    function down( SchemaBuilder schema, QueryBuilder query ) {
        
    }

}
