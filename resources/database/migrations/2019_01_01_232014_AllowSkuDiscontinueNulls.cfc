component {
    
    function up( schema ) {
        var sql = "ALTER TABLE `cbc_SKUs` CHANGE `discontinueOn` `discontinueOn` TIMESTAMP NULL DEFAULT NULL";
        var q = new query( sql=sql );
        q.execute();
        // now clear out our column values 
        sql = "UPDATE `cbc_SKUs` SET `discontinueOn` = NULL";
        q = new query( sql=sql );
        q.execute();
    }

    function down( schema ) {
    }

}
