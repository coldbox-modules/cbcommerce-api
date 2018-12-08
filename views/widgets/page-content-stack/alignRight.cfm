<cfoutput >
	<a name="#args.contentResults.pages[ x ].getSlug()#"></a>
	<div id="page-#args.contentResults.pages[ x ].getSlug()#" class="content content-right" style="background-color:###args.inlineStyle.bgColor#">
		<div class="container-fluid #args.flexClass#">
			<cfif args.contentResults.pages[ x ].getFeaturedImageURL() is not "" >
				<div class="col-md-7">
					<img src="#args.contentResults.pages[ x ].getFeaturedImageURL()#" class="img-featured img-responsive"/>
				</div>
				<div class="col-md-5">
					#args.contentResults.pages[ x ].renderContent()#
				</div>
			<cfelse>
				#args.contentResults.pages[ x ].renderContent()#
			</cfif>
		</div>
	</div>
</cfoutput>