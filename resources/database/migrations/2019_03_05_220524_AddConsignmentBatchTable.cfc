component {
    
    function up( SchemaBuilder schema, QueryBuilder query ) {
        schema.create( "cbc_consignmentBatches", function( table ) {
            table.uuid( "id" ).primaryKey();
		    table.timestamp( "createdTime" ).default( 'CURRENT_TIMESTAMP' );
		    table.timestamp( "modifiedTime" ).default( 'CURRENT_TIMESTAMP' );
            table.boolean( "isActive" ).default( 1 );
            table.string( "externalId", 75 ).nullable();
            table.string( "summary", 400 );
            table.text( "description" ).nullable();
            table.decimal( "consignorPercent", 8, 2 ).default( 0 );
            table.decimal( "cleaningHourlyRate", 8, 2 ).default( 0 );
            table.decimal( "repairHourlyRate", 8, 2 ).default( 0 );

            
			table.uuid( "FK_consignor" )
                .references( "id" )
                .onTable( "cbc_users" );

        } );

        schema.alter( "cbc_SKUs", function( table ){
            table.addColumn(
                table.uuid( "FK_consignmentBatch" )
                    .nullable()
            );
            table.addConstraint(
                table.uuid( "FK_consignmentBatch" )
					.references( "id" )
                    .onTable( "cbc_consignmentBatches" )
            );
        } );

        schema.create( "cbc_consignmentFeeTypes", function( table ) {
            table.uuid( "id" ).primaryKey();
            table.string( "name", 300 );
            table.string( "description", 750 );
			table.integer( "displayOrder" ).default( 0 );
        });

        var feeTypes = [
            {
                "id" : createUUID(),
                "name" : "Storage",
                "description" : "Fees for storage or warehousing of consigment items",
                "displayOrder" : 1
            },
            {
                "id" : createUUID(),
                "name" : "Cleaning",
                "description" : "Fees for cleaning or prepping consigment items",
                "displayOrder" : 2
            },
            {
                "id" : createUUID(),
                "name" : "Repair",
                "description" : "Fees for repair and maintenance of consigment items",
                "displayOrder" : 3
            },
            {
                "id" : createUUID(),
                "name" : "Disposal",
                "description" : "Fees for disposal of consignment items",
                "displayOrder" : 4
            },
            {
                "id" : createUUID(),
                "name" : "Shipping",
                "description" : "Fees for shipping or return shipping of consignment items",
                "displayOrder" : 5
            },
            {
                "id" : createUUID(),
                "name" : "Other",
                "description" : "Other fees, not listed",
                "displayOrder" : 6
            }
        ];

        query.from( "cbc_consignmentFeeTypes" ).insert(
			values = feeTypes
		);
        
        schema.create( "cbc_consignmentBatchFees", function( table ){
            table.uuid( "id" ).primaryKey();
		    table.timestamp( "createdTime" ).default( 'CURRENT_TIMESTAMP' );
            table.timestamp( "modifiedTime" ).default( 'CURRENT_TIMESTAMP' );
            table.boolean( "isActive" ).default( 1 );
            table.decimal( "amount", 8, 2 ).default( 0 );
            table.text( "notes" ).nullable();
            table.boolean( "isPaid" ).default( 0 );

            table.uuid( "FK_batch" )
                .references( "id" )
                .onTable( "cbc_consignmentBatches" );

            table.uuid( "FK_feeType" )
                .references( "id" )
                .onTable( "cbc_consignmentFeeTypes" );

            table.uuid( "FK_createdBy" )
                .references( "id" )
                .onTable( "cbc_users" );

        } );
    }

    function down( SchemaBuilder schema, QueryBuilder query ) {
        schema.dropIfExists( "cbc_consignmentBatchFees" );
        schema.dropIfExists( "cbc_consignmentFeeTypes" );
        schema.dropIfExists( "cbc_lookups_consignmentBatch_skus" );
        schema.dropIfExists( "cbc_consignmentBatches" );
        
    }

}
