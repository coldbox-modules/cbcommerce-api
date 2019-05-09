component {
    
    function up( schema, query ) {
        schema.alter( "cbc_SKUs", function( table ){
            table.addColumn(
                table.boolean( "pickUpInStore").default( 0 )
            );
        } );

        sql = "UPDATE `cbc_SKUs` SET `pickUpInStore` = 1 where `FK_condition` in (SELECT id from `cbc_productConditions` where `name` ='New')";
        q = new query( sql=sql );
        q.execute();

        sql2 = "UPDATE `cbc_SKUs` SET `pickUpInStore` = 0 where `pickUpInStore` is null";
        q2 = new query( sql=sql2 );
        q2.execute();
    }

    function down( schema, query ) {
        
    }

}
