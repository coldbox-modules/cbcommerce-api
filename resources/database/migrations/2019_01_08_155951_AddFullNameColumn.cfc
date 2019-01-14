component {

    function up( schema ) {

        schema.alter( "cbc_customerAddresses", function( table ){
            table.addColumn(
                table.string( "fullName", 255 ).nullable()
            );
        } );

    }

    function down( schema ) {

        schema.alter( "cbc_customerAddresse", function( table ){
            table.dropColumn( "fullName");
        } );

    }

}