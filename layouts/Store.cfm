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
		#cb.event( "cbui_beforeHeadEnd" )#
	</head>
	<body class="contentbox-module">
		<!--- ContentBoxEvent --->
		#cb.event( "cbui_afterBodyStart" )#

		<div id="app">		
			<!--- Header --->
			#renderView( module="cbCommerce", view='layout/_header' )#
			<!--- ContentBoxEvent --->
			#cb.event( "cbui_beforeContent" )#
			<!--- Main View --->
			<section id="body-main" class="body-main-page">
				<!--- Blank breadcrumbs, for now, so our page layout remains intact --->
				<div id="body-breadcrumbs" class="col-sm-12"></div>
				<!--- Determine span length due to sidebar or homepage --->
				<cfif cb.isHomePage() OR !args.sidebar>
					<cfset args.span = 12>
				<cfelse>
					<cfset args.span = 9>
				</cfif>
				<div class="col-sm-#args.span#">
					#cb.mainView( args=args )#
				</div>
			</section>
			<!--- ContentBoxEvent --->
			#cb.event( "cbui_afterContent" )#

			<!--- Footer --->
			#renderView( module="cbCommerce", view='layout/_footer' )#
		</div>

		<!--- ContentBoxEvent --->
		#cb.event( "cbui_beforeBodyEnd" )#

		<!--- before body end includes --->
		#renderView( module="cbCommerce", view='layout/_beforeBodyEndIncludes' )#

	</body>
</html>

</cfoutput>



