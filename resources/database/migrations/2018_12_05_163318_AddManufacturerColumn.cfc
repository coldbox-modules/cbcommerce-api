component {
    
     function up( schema ) {

        schema.alter( "cbc_products", function( table ){
            table.addColumn(
                table.string( "manufacturer" ).nullable()
            );
        } );

    }

    function down( schema ) {

        schema.alter( "cbc_products", function( table ){
            table.dropColumn( "manufacturer");
        } );
        
    }

}
