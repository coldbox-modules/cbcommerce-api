component {
    
    function up( schema ) {

        schema.alter( "cbc_productCategories", function( table ){
            table.addColumn(
                table.boolean( "isFeatured" ).default( 0 )
            );
        } );

        schema.alter( "cbc_products", function( table ){
            table.addColumn(
                table.boolean( "isFeatured" ).default( 0 )
            );
        } );

        schema.alter( "cbc_SKUs", function( table ){
            table.addColumn(
                table.boolean( "isFeatured" ).default( 0 )
            );
        } );

    }

    function down( schema ) {

        schema.alter( "cbc_productCategories", function( table ){
            table.dropColumn( "isFeatured" );
        } );

        schema.alter( "cbc_products", function( table ){
            table.dropColumn( "isFeatured" );
        } );

        schema.alter( "cbc_SKUs", function( table ){
            table.dropColumn( "isFeatured" );
        } );
        
    }

}
