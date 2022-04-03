<cfoutput>
<cfif prc.isContentBoxContext>
	<title>#cb.getContentTitle()#</title>
</cfif>
<!--- ********************************************************************************* --->
<!--- 					META TAGS														--->
<!--- ********************************************************************************* --->
<meta charset="utf-8" />
<meta name="generator" 	 	content="ContentBox powered by ColdBox" />
<meta name="robots" 	 	content="index,follow" />
<meta name="viewport" 		content="width=device-width, initial-scale=1">
<cfif prc.isContentBoxContext>
	<meta name="description" 	content="#cb.getContentDescription()#" />
	<meta name="keywords" 	 	content="#cb.getContentKeywords()#" />
	#cb.getOpenGraphMeta()#
</cfif>

<!--- Base HREF for SES enabled URLs --->
<!--- <base href="#cb.siteBaseURL()#" /> --->

<!--- ********************************************************************************* --->
<!--- 					RSS DISCOVERY													--->
<!--- ********************************************************************************* --->
<cfif prc.isContentBoxContext && cb.themeSetting( "rssDiscovery", true )>
	<link rel="alternate" type="application/rss+xml" title="Recent Page Updates" href="#cb.linkPageRSS()#" />
	<link rel="alternate" type="application/rss+xml" title="Recent Page Comment Updates" href="#cb.linkPageRSS(comments=true)#" />
	<link rel="alternate" type="application/rss+xml" title="Recent Content Updates" href="#cb.linkSiteRSS()#" />
	<link rel="alternate" type="application/rss+xml" title="Recent Content Comment Updates" href="#cb.linkSiteRSS(comments=true)#" />
	<!--- RSS Discovery If In View Mode --->
	<cfif prc.isContentBoxContext && cb.isPageView() and cb.getCurrentPage().getAllowComments()>
		<link rel="alternate" type="application/rss+xml" title="Pages's Recent Comments" href="#cb.linkPageRSS( comments=true, page=cb.getCurrentPage() )#" />
	</cfif>
</cfif>

<!--- ********************************************************************************* --->
<!--- 					CSS 															--->
<!--- ********************************************************************************* --->
<link rel="stylesheet" href="#event.getModuleRoot()#/includes/css/vendor.css">
<link rel="stylesheet" href="#event.getModuleRoot()#/includes/css/app.css">

<!-- injector:css -->
<!--- <link rel="stylesheet" href="#cb.themeRoot()#/includes/css/218c7e65.theme.min.css"> --->
<!-- endinjector -->

<cfif prc.isContentBoxContext && len( cb.themeSetting( 'cssStyleOverrides' ) )>
<style>
	#cb.themeSetting( 'cssStyleOverrides' )#
</style>
</cfif>

<!--- ********************************************************************************* --->
<!--- 					JAVASCRIPT														--->
<!--- ********************************************************************************* --->
<!-- injector:js -->
<!--- <script src="#cb.themeRoot()#/includes/js/ae19f5c3.theme.min.js"></script> --->
<!-- endinjector -->
</cfoutput>