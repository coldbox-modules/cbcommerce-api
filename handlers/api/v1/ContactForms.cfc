/**
* Customer Carts Handler - API v1
* @package cbCommerce.handlers
* @author Jon Clausen <jclausen@ortussolutions.com>
*/
component extends="BaseAPIHandler"{

    // (POST) /api/v1/contact-forms
    function send( event, rc, prc ){
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

}