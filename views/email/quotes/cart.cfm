<cfoutput>
    <p>A request for a custom quotation has been received at <a href="#cb.linkHome()#">#cb.linkHome()#</a></p>
    <h5>Name</h5>
    <p>#prc.cart.getUser().getFullName()#</p>
    <h5>Email</h5>
    <p><a href="mailto:#prc.cart.getUser().getEmail()#">#prc.cart.getUser().getEmail()#</a></p>
    <h5>Phone</h5>

    <p>
        <cfif len( prc.cart.getUser().getPrimaryPhone() )>
            <a href="tel:#encodeForHTMLAttribute( prc.cart.getUser().getPrimaryPhone() )#">#prc.cart.getUser().getPrimaryPhone()#</a>
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
            <cfloop array="#prc.cart.getItems()#" index="item">
                <tr>
                    <td>#item.getSKU().getProduct().getName()#</td>
                    <td>#item.getSKU().getModelNumber()#</td>
                    <td>#( len( item.getSKU().getExternalId() ) ? item.getSKU().getExternalId() : 'N/A' )#</td>
                    <td>#item.getQuantity()#</td>
                    <td>#( item.getSKU().getDisplayPricing() ? LSCurrencyFormat( item.getSKU().getBasePrice() ) : 'Disabled' )#</td>
                </tr>
            </cfloop>
        </tbody>
    </table>

    <h5>Message/Additional Requests</h5>
    <blockquote>
        <pre>#encodeForHTML( rc.message )#</pre>
    </blockquote>
</cfoutput>