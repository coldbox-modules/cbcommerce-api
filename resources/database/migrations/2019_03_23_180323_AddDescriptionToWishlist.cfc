component {
    
    function up( schema ) {
        
        schema.alter( "cbc_wishlists", function( table ){

            table.addColumn(
                table.string( "description", 750 ).nullable()
            );

        } );
    }

    function down( schema ) {
        schema.alter( "cbc_wishlists", function( table ){
            table.dropColumn( "description" );
        } );
    }

}
