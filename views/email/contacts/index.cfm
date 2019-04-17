<cfoutput>
    #renderView( view="email/inc/open", module="cbCommerce" )#
    <p>A contact form has been submitted at <a href="#cb.linkHome()#">#cb.linkHome()#</a></p>
    <h5>Name</h5>
    <p>#rc.name#</p>
    <h5>Email</h5>
    <p><a href="mailto:#rc.email#">#rc.email#</a></p>
    <h5>Phone</h5>
    <p>
        <cfif len( rc.phone )>
            <a href="tel:#rc.phone#">#rc.phone#</a>
        <cfelse>
            Not Provided
        </cfif>
    </p>
    <h5>Message</h5>
    <blockquote>
        #encodeForHTML( rc.message )#
    </blockquote>
    #renderView( view="email/inc/close", module="cbCommerce" )#
</cfoutput>