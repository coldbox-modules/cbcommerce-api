<cfoutput >
	<a name="#args.contentResults.pages[ x ].getSlug()#"></a>
	<cfif args.inlineStyle.bgColor is not "">
		<div id="page-#args.contentResults.pages[ x ].getSlug()#" class="content content-left" style="background-color:###args.inlineStyle.bgColor#">
	<cfelse>
		<div id="page-#args.contentResults.pages[ x ].getSlug()#" class="content content-left">
	</cfif>
		<div class="container-fluid #args.flexClass#">
			<cfif contentResults.pages[ x ].getFeaturedImageURL() is not "" >
				<div class="col-md-5">
					#args.contentResults.pages[ x ].renderContent()#
				</div>
				<div class="col-md-7">
					<img src="#args.contentResults.pages[ x ].getFeaturedImageURL()#" class="img-featured img-responsive"/>
				</div>
			<cfelse>
				#args.contentResults.pages[ x ].renderContent()#
			</cfif>
		</div>
	</div>
</cfoutput>