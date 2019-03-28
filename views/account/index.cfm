<cfif auth().isLoggedIn()>

    <cfoutput>#renderView( view="wishlist/index" )#</cfoutput>

<cfelse>

    <cfoutput>#renderView( view="account/login" )#</cfoutput>

</cfif>