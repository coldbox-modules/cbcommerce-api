component {
    
     function up( schema ) {

        schema.alter( "cbc_products", function( table ){
            table.addColumn(
                table.integer( "sortOrder" ).default( 0 )
            );
        } );

        schema.alter( "cbc_SKUs", function( table ){
            table.addColumn(
                table.integer( "sortOrder" ).default( 0 )
            );
        } );

    }

    function down( schema ) {

        schema.alter( "cbc_products", function( table ){
            table.dropColumn( "sortOrder");
        } );

        schema.alter( "cbc_SKUs", function( table ){
            table.dropColumn( "sortOrder");
        } );
        
    }

}
