<cfoutput >
	<a name="#args.contentResults.pages[ args.x ].getSlug()#"></a>
	<div id="page-#args.contentResults.pages[ args.x ].getSlug()#" class="content content-right" style="background-color:###args.inlineStyle.bgColor#">
		<div class="container-fluid #args.flexClass#">
			<cfif args.contentResults.pages[ args.x ].getFeaturedImageURL() is not "" >
				<div class="col-md-7">
					<img src="#args.contentResults.pages[ args.x ].getFeaturedImageURL()#" class="img-featured img-responsive"/>
				</div>
				<div class="col-md-5">
					#args.contentResults.pages[ args.x ].renderContent()#
				</div>
			<cfelse>
				#args.contentResults.pages[ args.x ].renderContent()#
			</cfif>
		</div>
	</div>
</cfoutput>