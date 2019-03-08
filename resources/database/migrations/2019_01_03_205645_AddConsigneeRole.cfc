component {
    
    function up( SchemaBuilder schema, QueryBuilder query) {

        query.from( "cbc_userRoles" ).insert(
            values = [
				{
					"id" : createUUID(),
					"name" : "Consignor"
                }
            ]
        );

    }

    function down( SchemaBuilder schema, QueryBuilder query) {
        var sql = "DELETE from `cbc_userRoles` WHERE name = 'Consignee'";
        var q =  new query( sql = sql );
        q.execute();
    }

}
