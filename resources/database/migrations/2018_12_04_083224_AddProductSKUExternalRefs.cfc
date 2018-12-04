component {
    
     function up( schema ) {

        schema.alter( "cbc_products", function( table ){
            table.addColumn(
                table.string( "externalId" ).nullable()
            );
        } );

        schema.alter( "cbc_SKUs", function( table ){
            table.addColumn(
                table.string( "externalId" ).nullable()
            );
        } );

    }

    function down( schema ) {

        schema.alter( "cbc_products", function( table ){
            table.dropColumn( "externalId");
        } );

        schema.alter( "cbc_SKUs", function( table ){
            table.dropColumn( "externalId");
        } );
        
    }

}
