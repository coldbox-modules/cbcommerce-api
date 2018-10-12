<cfoutput >
	<a name="#contentResults.pages[ x ].getSlug()#"></a>
	<cfif inlineStyle.bgColor is not "">
		<div id="page-#contentResults.pages[ x ].getSlug()#" class="content content-left" style="background-color:###inlineStyle.bgColor#">
	<cfelse>
		<div id="page-#contentResults.pages[ x ].getSlug()#" class="content content-left">
	</cfif>
		<div class="container-fluid #flexClass#">
			<cfif contentResults.pages[ x ].getFeaturedImageURL() is not "" >
				<div class="col-md-5">
					#contentResults.pages[ x ].renderContent()#
				</div>
				<div class="col-md-7">
					<img src="#contentResults.pages[ x ].getFeaturedImageURL()#" class="img-featured img-responsive"/>
				</div>
			<cfelse>
				#contentResults.pages[ x ].renderContent()#
			</cfif>
		</div>
	</div>
</cfoutput>