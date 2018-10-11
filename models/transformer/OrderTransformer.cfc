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
            wirebox.getInstance( "UserTransformer@cbc" )
        );
    }

    function includeItems( activeEntity ){
        return collection(
            activeEntity.getItems(),
            wirebox.getInstance( "OrderItemTransformer@cbc" )

        )
    }

    function includeBillingAddress( activeEntity ){
        return item(
            activeEntity.getBillingAddress(),
            wirebox.getInstance( "BaseModelTransformer@cbc" )
        );
    }

    function includeShippingAddress( activeEntity ){
        return item(
            activeEntity.getShippingAddress(),
            wirebox.getInstance( "BaseModelTransformer@cbc" )
        );
    }

}