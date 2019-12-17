<cfoutput>
	<!--- ContentBoxEvent --->
	<script type="application/javascript">
	window.cbcGlobalData=<cfoutput>#serializeJSON( prc.globalData )#</cfoutput>;
	</script>

	<script type="text/javascript" src="#event.getModuleRoot()#/includes/js/runtime.js"></script>
	<script type="text/javascript" src="#event.getModuleRoot()#/includes/js/app.js"></script>
</cfoutput>