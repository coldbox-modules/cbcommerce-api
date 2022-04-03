<!--- View Arguments --->
<cfparam name="args.print" 		default="false">
<cfparam name="args.sidebar" 	default="false">
<cfparam name="args.bodyHeader" default="false">
<cfparam name="args.bodyMainClass" 	default="body-main-page">

<cfoutput>
<!DOCTYPE html>
	<html lang="en">
	<head>
		<!--- Page Includes --->
		#renderView( module="cbCommerce", view="layout/_pageIncludes" )#
		<!--- ContentBoxEvent --->
		#announce( "cbui_beforeHeadEnd" )#
	</head>
	<body class="contentbox-module">
		<!--- ContentBoxEvent --->
		#announce( "cbui_afterBodyStart" )#

		<div id="app">
			<!--- Header --->
			#renderView( module="cbCommerce", view='layout/_header' )#
			<!--- ContentBoxEvent --->
			#announce( "cbui_beforeContent" )#
			<!--- Main View --->
			<section id="body-main" class="body-main-page">
				<!--- Blank breadcrumbs, for now, so our page layout remains intact --->
				<div id="body-breadcrumbs" class="col-sm-12"></div>
				<!--- Determine span length due to sidebar or homepage --->
				<cfif ( prc.isContentBoxContext && cb.isHomePage() ) OR !args.sidebar>
					<cfset args.span = 12>
				<cfelse>
					<cfset args.span = 9>
				</cfif>
				<div class="col-sm-">
					<cfif prc.isContentBoxContext>
						#cb.mainView( args=args )#
					<cfelse>
						#renderView( args=args )#
					</cfif>
				</div>
			</section>
			<!--- ContentBoxEvent --->
			#announce( "cbui_afterContent" )#

			<!--- Footer --->
			<cfif prc.isContentBoxContext>
				#renderView( module="cbCommerce", view='layout/_contentbox_footer' )#
			<cfelse>
				#renderView( module="cbCommerce", view='layout/_footer' )#
			</cfif>
		</div>

		<!--- ContentBoxEvent --->
		#announce( "cbui_beforeBodyEnd" )#

		<!--- before body end includes --->
		#renderView( module="cbCommerce", view='layout/_beforeBodyEndIncludes' )#

	</body>
</html>

</cfoutput>



