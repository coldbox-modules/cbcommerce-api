component {
    
    function up( schema ) {
        var statements = [ 
            "ALTER TABLE `cbc_productSKUMedia` DROP FOREIGN KEY fk_cbc_productSKUMedia_FK_sku",
            "ALTER TABLE `cbc_productSKUMedia` ADD CONSTRAINT fk_cbc_productSKUMedia_FK_sku FOREIGN KEY (FK_sku) REFERENCES cbc_SKUs(id)" 
        ];
        statements.each( function( sql ){
            var q = new query( sql=sql );
            q.execute();
        });
        
    }

    function down( schema ) {
    }

}
