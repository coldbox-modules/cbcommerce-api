<cfoutput >
	<a name="#args.contentResults.pages[ x ].getSlug()#"></a>
	<div id="page-#args.contentResults.pages[ x ].getSlug()#" class="content content-center" style="background-color:###args.inlineStyle.bgColor#">
		<div class="container text-center">
			<div class="col-md-12">
				#args.contentResults.pages[ x ].renderContent()#
			</div>
			<cfif contentResults.pages[ x ].getFeaturedImageURL() is not "" >
				<div class="col-md-12">
					<img src="#args.contentResults.pages[ x ].getFeaturedImageURL()#" class="img-featured img-responsive"/>
				</div>
			</cfif>
		</div>
	</div>
</cfoutput>