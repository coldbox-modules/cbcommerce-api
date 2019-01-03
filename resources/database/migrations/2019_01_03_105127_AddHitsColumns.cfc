component {
    
    
    function up( schema ) {

        schema.alter( "cbc_products", function( table ){
            table.addColumn(
                table.integer( "hitCount" ).default( 0 )
            );
        } );

        schema.alter( "cbc_productCategories", function( table ){
            table.addColumn(
                table.integer( "hitCount" ).default( 0 )
            );
        } );

    }

    function down( schema ) {

        schema.alter( "cbc_products", function( table ){
            table.dropColumn( "hitCount" );
        } );

        schema.alter( "cbc_productCategories", function( table ){
            table.dropColumn( "hitCount" );
        } );
        
    }

}
