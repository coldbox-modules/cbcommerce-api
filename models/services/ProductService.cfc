component extends="BaseQuickEntityService" singleton{
    //provider for the entity - this provider must exist to use the search() method
    function newEntity() provider="Product@cbCommerce"{}

    public function getActiveUsedProducts(){
        return newEntity()
                .where( 'isActive', 1 )
                .hasUsedSKU()
                .orderBy( 'displayOrder', 'ASC' )
                .orderBy( 'name', 'ASC' )
                .get();
    }
}