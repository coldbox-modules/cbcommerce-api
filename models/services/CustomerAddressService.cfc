component extends="BaseQuickEntityService" singleton{
    //provider for the entity - this provider must exist to use the search() method
    function newEntity() provider="CustomerAddress@cbCommerce"{}

}