component {
    
    function up( schema ) {
        schema.alter( "cbc_users", function( table ){
            table.modifyColumn(
                "resetToken",
                table.string( "resetToken", 255 ).nullable()
            );

        } );
    }

    function down( schema ) {
        // no down method for this migration
    }

}
