component {
    
    function up( schema ) {
        schema.alter( "cbc_SKUs", function( table ){
            table.addColumn(
                table.string( "modelNumber" ).nullable()
            );
        } );
    }

    function down( schema ) {
        schema.alter( "cbc_SKUs", function( table ){
            table.dropColumn( "modelNumber");
        } );
    }

}
