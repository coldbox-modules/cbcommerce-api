component{
    property name="userService" inject="UserService@cbCommerce";

    void function preProcess( event, interceptData, buffer, rc, prc ) eventPattern="cbCommerce:" {
        if( !auth().isLoggedIn() ){
            var cbSecurityService = getInstance( "securityService@cb" );
            var sessionUser = cbSecurityService.getAuthorSession();
            if( sessionUser.isLoggedIn() && sessionUser.checkPermission( 'MODULES_ADMIN' ) ){
                // check for an existing cbCommerce user with the same email address
                var cbCommerceUser = userService.newEntity()
                                                .where( 'isActive', 1 )
                                                .where( 'email', sessionUser.getEmail() )
                                                .first();

                if( !isNull( cbCommerceUser ) ){
                    auth().login( cbCommerceUser );
                } else {
                    var adminRole = getInstance( "UserRole@cbCommerce" ).where( "name", "Administrator" ).first();

                    if( isNull( adminRole ) ){
                        throw(
                            type = "cbCommerce.MissingRoleException",
                            message = "An administrator role could not be found in the cbCommerce database"
                        );
                    }

                    var cbCommerceUser = userService.newEntity();
                    cbCommerceUser.fill(
                        {
                         "firstName" : sessionUser.getFirstName(),
                         "lastName" : sessionUser.getLastName(),
                         "email" : sessionUser.getEmail(),
                         "password" : sessionUser.getPassword()
                        }
                    );
                    cbCommerceUser.save();
                    cbCommerceUser.roles().attach( adminRole );

                    auth().login( cbCommerceUser );

                }
            }
        }
    }
}