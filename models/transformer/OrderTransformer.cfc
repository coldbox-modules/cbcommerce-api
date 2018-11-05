component extends="BaseModelTransformer"{
    
    function init(){

        arrayAppend( 
            variables.defaultIncludes,
            [
                "customer",
                "items",
                "shippingAddress",
                "billingAddress"
            ],
            true
        );

        return this;
    }

    function includeCustomer( activeEntity ){
        return item(
            activeEntity.getCustomer(),
            wirebox.getInstance( "UserTransformer@cbCommerce" )
        );
    }

    function includeItems( activeEntity ){
        return collection(
            activeEntity.getItems(),
            wirebox.getInstance( "OrderItemTransformer@cbCommerce" )

        )
    }

    function includeBillingAddress( activeEntity ){
        return item(
            activeEntity.getBillingAddress(),
            wirebox.getInstance( "BaseModelTransformer@cbCommerce" )
        );
    }

    function includeShippingAddress( activeEntity ){
        return item(
            activeEntity.getShippingAddress(),
            wirebox.getInstance( "BaseModelTransformer@cbCommerce" )
        );
    }

}