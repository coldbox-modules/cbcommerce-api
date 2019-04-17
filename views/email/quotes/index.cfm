<cfoutput>
    #renderView( view="email/inc/open", module="cbCommerce" )#
    <p>A request for a custom quotation has been received at <a href="#cb.linkHome()#">#cb.linkHome()#</a></p>
    <h5>Name</h5>
    <p>#rc.name#</p>
    <h5>Email</h5>
    <p><a href="mailto:#rc.email#">#rc.email#</a></p>
    <h5>Phone</h5>
    <p>
        <cfif len( rc.phone )>
            <a href="tel:#encodeForHTMLAttribute( rc.phone )#">#rc.phone#</a>
        <cfelse>
            Not Provided
        </cfif>
    </p>
    <h5>Items Requested</h5>
    <table class="columns">
        <thead>
            <tr>
                <th>Product Name</th>
                <th>Model Number</th>
                <th>Identifier ( Tag )</th>
                <th>Displayed Price</th>
            </tr>
        </thead>
        <tbody>
            <tr>
                <td>#prc.sku.getProduct().getName()#</td>
                <td>#prc.sku.getModelNumber()#</td>
                <td>#( len( prc.sku.getExternalId() ) ? prc.sku.getExternalId() : 'N/A' )#</td>
                <td>#( prc.sku.getShowPricing() ? LSCurrencyFormat( prc.sku.getBasePrice() ) : 'Disabled' )#</td>
            </tr>
        </tbody>
    </table>

    <h5>Message/Additional Requests</h5>
    <blockquote>
        <pre>#encodeForHTML( rc.message )#</pre>
    </blockquote>
    #renderView( view="email/inc/close", module="cbCommerce" )#
</cfoutput>