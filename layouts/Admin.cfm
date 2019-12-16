<cfoutput>

<!DOCTYPE html>
<html lang="en">
	<head>
		<meta charset="utf-8">
    	<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
		<title>CBCommerce Admin</title>
		<link rel="stylesheet" href="#event.getModuleRoot()#/includes/css/vendor-admin.css">
		<link rel="stylesheet" href="#event.getModuleRoot()#/includes/css/admin/app.css">
	</head>
	<body>

		<div id="app"><app></app></div>
    
		<!--- ContentBoxEvent --->
		<script type="application/javascript">
		window.cbcGlobalData=<cfoutput>#serializeJSON( prc.globalData )#</cfoutput>;
		</script>
        <script type="text/javascript" src="#event.getModuleRoot()#/includes/js/runtime.js"></script>
        <script type="text/javascript" src="#event.getModuleRoot()#/includes/js/admin.js"></script>
		<script src="https://cdnjs.cloudflare.com/ajax/libs/iframe-resizer/3.6.3/iframeResizer.contentWindow.min.js"></script>
	</body>
</html>

</cfoutput>



