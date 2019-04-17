<cfoutput>
    #renderView( view="email/inc/open", module="cbCommerce" )#
    <p>A request for a custom quotation has been received at <a href="#cb.linkHome()#">#cb.linkHome()#</a></p>
    <h5>Name</h5>
    <p>#prc.wishlist.getUser().getFullName()#</p>
    <h5>Email</h5>
    <p><a href="mailto:#prc.wishlist.getUser().getEmail()#">#prc.wishlist.getUser().getEmail()#</a></p>
    <h5>Phone</h5>

    <p>
        <cfif len( prc.wishlist.getUser().getPrimaryPhone() )>
            <a href="tel:#encodeForHTMLAttribute( prc.wishlist.getUser().getPrimaryPhone() )#">#prc.wishlist.getUser().getPrimaryPhone()#</a>
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
            <cfloop array="#prc.wishlist.getItems()#" index="item">
                <tr>
                    <td>#item.getSKU().getProduct().getName()#</td>
                    <td>#item.getSKU().getModelNumber()#</td>
                    <td>#( len( item.getSKU().getExternalId() ) ? item.getSKU().getExternalId() : 'N/A' )#</td>
                    <td>#item.getQuantity()#</td>
                    <td>#( item.getSKU().getShowPricing() ? LSCurrencyFormat( item.getSKU().getBasePrice() ) : 'Disabled' )#</td>
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