component {
    
    function up( SchemaBuilder schema, QueryBuilder query ) {
        schema.alter( "cbc_SKUs", function( table ){
            table.renameColumn( 
                "FK_consignee", 
                table.uuid( "FK_consignor" )
                    .nullable()
            );
            table.addConstraint(
                table.uuid( "FK_consignor" )
					.references( "id" )
                    .onTable( "cbc_users" )
            );
        } );


        query.from( "cbc_userRoles" )
            .where( 'name', 'Consignee' )
            .update(  { 'name' : 'Consignor' } );

    }

    function down( SchemaBuilder schema, QueryBuilder query ) {
        
    }

}
