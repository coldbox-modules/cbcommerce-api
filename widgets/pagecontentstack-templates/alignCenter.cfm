<cfoutput >
	<a name="#contentResults.pages[ x ].getSlug()#"></a>
	<div id="page-#contentResults.pages[ x ].getSlug()#" class="content content-center" style="background-color:###inlineStyle.bgColor#">
		<div class="container text-center">
			<div class="col-md-12">
				#contentResults.pages[ x ].renderContent()#
			</div>
			<cfif contentResults.pages[ x ].getFeaturedImageURL() is not "" >
				<div class="col-md-12">
					<img src="#contentResults.pages[ x ].getFeaturedImageURL()#" class="img-featured img-responsive"/>
				</div>
			</cfif>
		</div>
	</div>
</cfoutput>