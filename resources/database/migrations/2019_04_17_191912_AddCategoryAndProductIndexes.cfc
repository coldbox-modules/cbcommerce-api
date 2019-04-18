component {
    
    function up( schema ) {
        schema.alter( "cbc_products", function( table ){
            table.addConstraint( table.index( "name", "idx_cbc_products_name" ) );
        } );
        transaction action="flush";
        schema.alter( "cbc_productCategories", function( table ){
            table.addConstraint( table.index( "name", "idx_cbc_productCategories_name" ) );
        } );
        transaction action="flush";
        schema.alter( "cbc_productCategoryMedia", function( table ){
            table.addConstraint( table.index( "isPrimary", "idx_productCategoryMedia_isPrimary" ) );
            table.addConstraint( table.index( [ "displayOrder", "createdTime" ], "idx_productCategoryMedia_sort" ) );
        } );
        transaction action="flush";
        schema.alter( "cbc_productMedia", function( table ){
            table.addConstraint( table.index( "isPrimary", "idx_productMedia_isPrimary" ) );
            table.addConstraint( table.index( [ "displayOrder", "createdTime" ], "idx_productMedia_sort" ) );
        } );
        transaction action="flush";
    }

    function down( schema ) {
        schema.alter( "cbc_products", function( table ){
            table.dropConstraint( "idx_cbc_products_name" );
        } );
        schema.alter( "cbc_productCategories", function( table ){
            table.dropConstraint( "idx_cbc_productCategories_name" );
        } );
        schema.alter( "cbc_productCategoryMedia", function( table ){
            table.dropConstraint( "idx_productCategoryMedia_sort" );
        } );
        schema.alter( "cbc_productMedia", function( table ){
            table.dropConstraint( "idx_productMedia_sort" );
        } );
    }

}
