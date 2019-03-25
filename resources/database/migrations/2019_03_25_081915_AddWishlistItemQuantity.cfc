component {
    
    function up( schema ) {
        
        schema.alter( "cbc_wishlistItems", function( table ){

            table.addColumn(
                table.integer( "quantity" ).default( 1 )
            );

        } );
    }

    function down( schema ) {
        schema.alter( "cbc_wishlistItems", function( table ){
            table.dropColumn( "quanity" );
        } );
    }

}
