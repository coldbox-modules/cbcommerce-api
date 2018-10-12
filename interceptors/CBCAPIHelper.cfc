/**
* @displayname CBC API Helper Interceptor
* @package     cbCommerce.interceptors
* @description This ensures that the maxrows, page, and offset variables exist
*              and provides default values if they do not.
* @author      Jon Clausen <jclausen@ortussolutions.com>
**/
component{
    property name="auth" inject="authenticationService@cbauth";

    void function preProcess( event, interceptData, buffer, rc, prc ) eventPattern="cbCommerce:API." {
        event.paramValue( "includes", "" );
        event.paramValue( "maxrows", 25 );
        if ( ! isNumeric( rc.maxrows ) ) { rc.maxrows = 25; }
        event.paramValue( "page", 1 );
        if ( ! isNumeric( rc.page ) ) { rc.page = 1; }
        event.paramvalue( "offset", ( rc.page - 1 ) * rc.maxrows );
        if ( ! isNumeric( rc.offset ) ) { rc.offset = ( rc.page - 1 ) * rc.maxrows; }
        event.paramValue( "sortOrder", "createdTime DESC" );
 
        // By default the active values should be returned
        event.paramValue( "isActive", 1 );

        if( auth.isLoggedIn() ){
            prc["authenticatedUser"] = auth.getUser();
        }
    }
    
}