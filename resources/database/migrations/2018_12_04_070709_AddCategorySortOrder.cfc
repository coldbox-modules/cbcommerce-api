component {
    
    function up( schema ) {
        schema.alter( "cbc_productCategories", function( table ){
            table.addColumn(
                table.integer( "sortOrder" ).default( 0 )
            );
        } );
    }

    function down( schema ) {
        schema.alter( "cbc_productCategories", function( table ){
            table.dropColumn( "sortOrder");
        } );
    }

}
