component {
    
    function up( schema ) {
        
        schema.alter( "cbc_SKUs", function( table ){

            table.addColumn(
                table.boolean( "showPricing" ).default( 1 )
            );

        } );
    }

    function down( schema ) {
        schema.alter( "cbc_SKUs", function( table ){
            table.dropColumn( "showPricing" );
        } );
    }

}
