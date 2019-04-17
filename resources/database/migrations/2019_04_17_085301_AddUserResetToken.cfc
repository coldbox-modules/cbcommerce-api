component {
    
    function up( schema ) {
        
        schema.alter( "cbc_users", function( table ){

            table.addColumn(
                table.string( "resetToken", 75 ).nullable()
            );

        } );
        
    }

    function down( schema ) {
        schema.alter( "cbc_users", function( table ){
            table.dropColumn( "resetToken" );
        } );
    }

}
