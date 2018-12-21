component {
    
    function up( schema ) {

        schema.alter( "cbc_SKUs", function( table ){
            table.renameColumn( "sortOrder", table.integer( "displayOrder" ).default( 0 ) );
        } );

        schema.alter( "cbc_products", function( table ){
            table.renameColumn( "sortOrder", table.integer( "displayOrder" ).default( 0 ) );
        } );

        schema.alter( "cbc_productCategories", function( table ){
            table.renameColumn( "sortOrder", table.integer( "displayOrder" ).default( 0 ) );
        } );

    }

    function down( schema ) {

        
        schema.alter( "cbc_SKUs", function( table ){
            table.renameColumn( "displayOrder", table.integer( "sortOrder" ).default( 0 ) );
        } );

        schema.alter( "cbc_products", function( table ){
            table.renameColumn(  "displayOrder", table.integer( "sortOrder" ).default( 0 ) );
        } );

        schema.alter( "cbc_productCategories", function( table ){
            table.renameColumn(  "displayOrder", table.integer( "sortOrder" ).default( 0 ) );
        } );
        
    }

}
