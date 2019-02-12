component {
    
    function up( schema ) {
        
        schema.alter( "cbc_SKUs", function( table ){

            table.addColumn(
                table.string( "summary", 1000 ).nullable()
            );
            table.addColumn(
                table.text( "description" ).nullable()
            );

        } );
    }

    function down( schema ) {
        schema.alter( "cbc_SKUs", function( table ){
            table.dropColumn( "summary" );
            table.dropColumn( "description" );
        } );
    }

}
