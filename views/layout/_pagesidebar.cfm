<cfoutput>
	<!--- ContentBoxEvent --->
	#announce("cbui_BeforeSideBar")#

	<div class="sidebar-nav">
		<ul>
			#cb.subPageMenu( page=cb.getCurrentPage(), type="li" )#
		</ul>
	</div>

	<!--- ContentBoxEvent --->
	#announce("cbui_afterSideBar")#
</cfoutput>