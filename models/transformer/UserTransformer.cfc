component extends="BaseModelTransformer"{
    
    function init(){
        arrayAppend( 
            variables.defaultIncludes,
            [ "fullName" ],
            true
        );
        arrayAppend( 
            variables.availableIncludes,
            [
                "roles",
                "explicitPermissions",
                "shippingAddresses",
                "billingAddresses",
                "carts",
                "orders",
                "password"
            ],
            true
        );

        return this;
    }

    function includeFullName( activeEntity ){
        return item(
            activeEntity,
            function( user ){
                return user.getFirstName() & " " & user.getLastName();
            }
        );
    }

    // we never expose any aspect of the password
    function includePassword( activeEntity ){
        return item(
            activeEntity,
            function( user ){ return ""; }
        );
    }

    function includeRoles( activeEntity ){
        return collection(
            activeEntity.getRoles(),
            wirebox.getInstance( "BaseModelTransformer@cbCommerce" ),
            wirebox.getInstance( collectionSerializer )
        )
    }


    function includeExplicitPermissions( activeEntity ){
        return collection(
            activeEntity.getExplicitPermissions(),
            wirebox.getInstance( "BaseModelTransformer@cbCommerce" ),
            wirebox.getInstance( collectionSerializer )
        )
    }

    function includeShippingAddresses( activeEntity ){
        return collection(
            activeEntity.addresses()
                .where( 'designation', 'shipping' )
                .orderBy( 'isPrimary', 'DESC' )
                .retreive()
                .getCollection(),
            wirebox.getInstance( "BaseModelTransformer@cbCommerce" ),
            wirebox.getInstance( collectionSerializer )
        )
    }

     function includeBillingAddresses( activeEntity ){
        return collection(
            activeEntity.addresses()
                .where( 'designation', 'billing' )
                .orderBy( 'isPrimary', 'DESC' )
                .orderBy( 'createdTime', 'ASC' )
                .retreive()
                .getCollection(),
            wirebox.getInstance( "BaseModelTransformer@cbCommerce" ),
            wirebox.getInstance( collectionSerializer )
        )
    }

    function includeCarts( activeEntity ){
        return collection(
            activeEntity.carts()
                    .orderBy( "modifiedTime", "DESC" )
                    .orderBy( "createdTime", "DESC" )
                    .get()
                    .getCollection(),
            wirebox.getInstance( "BaseModelTransformer@cbCommerce" ),
            wirebox.getInstance( collectionSerializer )
        );
    }

    function includeOrders( activeEntity ){
        return collection(
            activeEntity.orders()
                    .orderBy( "createdTime", "DESC" )
                    .get()
                    .getCollection(),
            wirebox.getInstance( "BaseModelTransformer@cbCommerce" ),
            wirebox.getInstance( collectionSerializer )
        );
    }
}