<cfoutput>
    #renderView( view="email/inc/open", module="cbCommerce" )#
    <p>A request for a custom shopping cart quotation has been received at <a href="#cb.linkHome()#">#cb.linkHome()#</a></p>
    <h5>Name</h5>
    <p>#rc.name#</p>
    <h5>Email</h5>
    <p><a href="mailto:#rc.email#">#rc.email#</a></p>
    <h5>Phone</h5>

    <p>
        <cfif len(rc.phone)>
            <a href="tel:#encodeForHTMLAttribute( rc.phone )#">#rc.phone#</a>
        <cfelse>
            Not Provided
        </cfif>
    </p>
    <h5>Items</h5>
    <table class="columns">
        <thead>
            <tr>
                <th>Product Name</th>
                <th>Model Number</th>
                <th>Identifier ( Tag )</th>
                <th>Quantity</th>
                <th>Displayed Price</th>
            </tr>
        </thead>
        <tbody>
            <cfloop array="#prc.cart.getContents().items#" index="item">
                <tr>
                    <td>#item.product.name#</td>
                    <td>#item.sku.modelNumber#</td>
                    <td>#( len( item.sku.externalId ) ? item.sku.externalId : 'N/A' )#</td>
                    <td>#item.quantity#</td>
                    <td>#( item.sku.showPricing ? LSCurrencyFormat( item.sku.basePrice ) : 'Disabled' )#</td>
                </tr>
            </cfloop>
        </tbody>
    </table>

    <h5>Message/Additional Requests</h5>
    <blockquote>
        <pre>#encodeForHTML( rc.message )#</pre>
    </blockquote>
    #renderView( view="email/inc/close", module="cbCommerce" )#
</cfoutput>