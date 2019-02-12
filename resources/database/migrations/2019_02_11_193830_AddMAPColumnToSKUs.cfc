component {
    
    function up( schema ) {
        
        schema.alter( "cbc_SKUs", function( table ){
            table.addColumn(
                table.decimal( "MAP", 8, 2  ).nullable()
            );
        } );
    }

    function down( schema ) {
        schema.alter( "cbc_SKUs", function( table ){
            table.dropColumn( "MAP" );
        } );
    }

}
