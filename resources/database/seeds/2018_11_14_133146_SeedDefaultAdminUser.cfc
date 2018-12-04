component {
    
    function up( SchemaBuilder schema, QueryBuilder query ) {

        var userService = application.wirebox.getInstance( "UserService@cbCommerce" );
        var adminUser = userService.newEntity();
        var adminRoles = application.wirebox.getInstance( "UserRole@cbCommerce" ).where( "name", "Administrator" ).get();
        if( !arrayLen( adminRoles ) ){
            throw( "No admin roles were found to assign" );
        } else {
            var adminRole = adminRoles[ 1 ];
        }

        adminUser.fill(
            {
                "firstName" : "Admin",
                "lastName" : "User",
                "email" : "adminuser@cbcommerce.com",
                "password" : "cbComm3rce4dmin"
            }
        );

        adminUser.save();

        adminUser.roles().attach( adminRole );


    }

    function down(  SchemaBuilder schema, QueryBuilder query ) {

        var userService = application.wirebox.getInstance( "UserService@cbCommerce" );
        var adminUsers = userService.newEntity().where( "email", "adminuser@cbcommerce.com" ).get();

        adminUsers.each( 
            function( adminUser ){
                adminUser.delete();
            }
        );

    }

}
