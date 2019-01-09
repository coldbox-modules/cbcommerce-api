component {

    function up( schema ) {
        var sql = "ALTER TABLE `cbc_customerAddresses` CHANGE `address2` `address2` VARCHAR(255) NULL DEFAULT NULL";
        var q = new query( sql=sql );
        q.execute();

        sql = "ALTER TABLE `cbc_orders`
        		MODIFY `fulfilledTime` timestamp NULL DEFAULT NULL,
        		MODIFY `paidInFull` timestamp NULL DEFAULT NULL,
        		MODIFY `approvalTime` timestamp NULL DEFAULT NULL";
        q = new query( sql=sql );
        q.execute();
    }

    function down( schema ) {

    }

}