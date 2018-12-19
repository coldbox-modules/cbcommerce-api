component {
    
    function up( schema ) {

        schema.alter( "cbc_wishlists", function( table ){
            table.addColumn(
                table.boolean( "isDefault" ).default( 0 )
            );
            table.addColumn(
                table.boolean( "isPublic" ).default( 0 )
            );
        } );

    }

    function down( schema ) {

        schema.alter( "cbc_wishlists", function( table ){
            table.dropColumn( "isDefault" );
            table.dropColumn( "isPublic" );
        } );
        
    }

}
