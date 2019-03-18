/**
* Customer Carts Handler - API v1
* @package cbCommerce.handlers
* @author Jon Clausen <jclausen@ortussolutions.com>
*/
component extends="BaseAPIHandler"{

    // (POST) /api/v1/contact-forms
    function send( event, rc, prc ){
        var mailService = getInstance( "mailService@cbmailservices" );

        event.paramValue( "subject", "Contact Form Submission" );

        var mailmailService.newMail(
            to=,
            from=rc.email,
            subject=rc.subject
        );

    }

}