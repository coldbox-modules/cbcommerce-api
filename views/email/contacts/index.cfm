<cfoutput>
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
    <p>
        #encodeForHTML( rc.message )#
    </p>
</cfoutput>