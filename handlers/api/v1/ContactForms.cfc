/**
* Customer Carts Handler - API v1
* @package cbCommerce.handlers
* @author Jon Clausen <jclausen@ortussolutions.com>
*/
component extends="BaseAPIHandler"{
    property name="mailService" inject="MailService@cbmailservices";

    // (POST) /api/v1/contact-forms
    function send( event, rc, prc ){
        paramRequest( argumentCollection = arguments );
        if( prc.response.getError() ) return;
        var mailService = getInstance( "mailService@cbmailservices" );

        event.paramValue( "subject", "Contact Form Submission" );

        var contactMail = mailService.newMail(
            to=event.getValue( "recipient", getSetting( "mailSettings" ).to ),
            from=rc.email,
            subject=rc.subject
        );
        // Prepare our contentbox
        getInstance( "CBHelper@cb" ).prepareUIRequest( "modules" );
        // reset our layout to none
        event.noLayout();

        contactMail.setBody( renderView( view="email/contacts/index", module="cbCommerce" ) );
        mailService.send( contactMail );

        prc.response.setStatusCode( status.CREATED ).setData( { "message" : "Your form submission was successfully sent"} );

    }

    //( POST ) /api/v1/quote-request/wishlist/:wishlistId
    function wishlistQuote( event, rc, prc ) secured{
        paramRequest( argumentCollection = arguments );
        if( prc.response.getError() ) return;
        
        prc.wishlist = getInstance( "Wishlist@CBCommerce" ).getOrFail( rc.wishlistId );

        if( !len( prc.authenticatedUser.getPrimaryPhone() ) ){
            prc.authenticatedUser.setPrimaryPhone( rc.phone ).save();
        }

        var quoteMail = mailService.newMail(
            to=event.getValue( "recipient", getSetting( "mailSettings" ).to ),
            from=prc.authenticatedUser.getEmail(),
            subject="Custom Quote Request from " & prc.authenticatedUser.getFullName()
        );
        // Prepare our contentbox
        getInstance( "CBHelper@cb" ).prepareUIRequest( "modules" );
        // reset our layout to none
        event.noLayout();

        quoteMail.setBody( renderView( view="email/quotes/wishlist", module="cbCommerce" ) );
        mailService.send( quoteMail );

        prc.response.setStatusCode( status.CREATED ).setData( { "message" : "Your quotation request was successfully sent"} );

    }

    //( POST ) /api/v1/quote-request/cart
    function cartQuote( event, rc, prc ){
        paramRequest( argumentCollection = arguments );
        if( prc.response.getError() ) return;
        
        prc.cart = getInstance( "CartService@cbCommerce" ).getActiveCart();

        var subject = !isNull( prc.cart.getCustomer() ) 
                        ? "Custom Quote Request from " & prc.cart.getCustomer().getFullName()
                        : "Custom Quote Request";

        var quoteMail = mailService.newMail(
            to=event.getValue( "recipient", getSetting( "mailSettings" ).to ),
            from=structKeyExists( prc, "authenticatedUser" ) ? prc.authenticatedUser.getEmail() : rc.email,
            subject=subject
        );
        // Prepare our contentbox
        getInstance( "CBHelper@cb" ).prepareUIRequest( "modules" );
        // reset our layout to none
        event.noLayout();

        if(!isNull( prc.cart.getCustomer() ) ){
            quoteMail.setBody( renderView( view="email/quotes/cart", module="cbCommerce" ) );
        }else{
            quoteMail.setBody( renderView( view="email/quotes/cart_anonymous", module="cbCommerce" ) );
        }
        
        mailService.send( quoteMail );

        prc.response.setStatusCode( status.CREATED ).setData( { "message" : "Your quotation request was successfully sent"} );

    }

    //( POST ) /api/v1/quote-request/sku/:skuId
    function skuQuote( event, rc, prc ){
        paramRequest( argumentCollection = arguments );
        if( prc.response.getError() ) return;
        event.paramValue( "subject", "Custom Quote Request" );

        prc.sku = getInstance( "ProductSKU@CBCommerce" ).getOrFail( rc.skuId );

        var subject = structKeyExists( prc, "authenticatedUser" ) 
                        ? "Custom Quote Request from " & prc.authenticatedUser.getFullName()
                        : "Custom Quote Request";
        
        var quoteMail = mailService.newMail(
            to=event.getValue( "recipient", getSetting( "mailSettings" ).to ),
            from=structKeyExists( prc, "authenticatedUser" ) ? prc.authenticatedUser.getEmail() : rc.email,
            subject=subject
        );
        // Prepare our contentbox
        getInstance( "CBHelper@cb" ).prepareUIRequest( "modules" );
        // reset our layout to none
        event.noLayout();

        quoteMail.setBody( renderView( view="email/quotes/index", module="cbCommerce" ) );
        mailService.send( quoteMail );

        prc.response.setStatusCode( status.CREATED ).setData( { "message" : "Your quotation request was successfully sent"} );

    }

    private function paramRequest( event, rc, prc ){
        event.paramValue( "name", "" );
        event.paramValue( "email", "" );
        event.paramValue( "phone", "" );
        event.paramValue( "message", "" );
        // deny if the SPAM honeypot has been filled in
        if( len( event.getValue( "hpInfo", "" ) ) ){
            prc.response.setStatusCode( status.BAD_REQUEST )
                        .setError( true )
                        .addMessage( "An unknown error occurred while attempting to send your request" );
            return;
        }
    }

}