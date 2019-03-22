component {
    
    function up( schema ) {
        
        schema.alter( "cbc_wishlistItems", function( table ){

            table.addColumn(
                table.decimal( "discountPrice" ).default( 0 )
            );

        } );
    }

    function down( schema ) {
        schema.alter( "cbc_wishlistItems", function( table ){
            table.dropColumn( "discountPrice" );
        } );
    }

}
