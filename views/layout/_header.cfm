<cfoutput>
	<cfif prc.isContentBoxContext>
		<cfset prc.headerMainNav = cb.themeSetting( 'headerMainNav', true )>
		<cfset prc.globalData[ "rootMenu" ] = cb.menu( slug="main-nav", type="data" )/>
	</cfif>

	<header id="header">
		<!--- header-top-row --->
		<div class="header-top-row">
			<div class="container-fluid">
				<div class="row">
					<div class="col-md-6 hidden-xs hidden-sm">
                        <div class="top-welcome">
							<cfif prc.isContentBoxContext>
								#cb.themeSetting( 'headerText', 'Welcome to our Store' )#
							<cfelse>
								#getModuleSettings( "cbCommerce", "headerText", "" )#
							</cfif>
                        </div>
                    </div>
                    <div class="col-md-6">
						<div class="top-welcome pull-left hidden-md hidden-lg">
                        </div>
                        <ul class="pull-right secondary-nav">
                        	<!--- header-cart menu --->
                        	<li id="cart-menu" class="secondary-nav-item pull-right">
                        		<a href="/store/shopping-cart" class="secondary-menu-title">
                        			<nav-cart></nav-cart>
                        		</a>
                        	</li>
                        	<!--- header-account menu --->
                            <li id="account-menu" class="secondary-nav-item pull-right">
                                <nav-user></nav-user>
                            </li>
                        </ul>
                    </div>
				</div>
			</div>
		</div>
		<!--- /header-top-row --->
		<div class="header-bg">
			 <div class="header-main" id="header-main-fixed">
                <div class="header-main-block1">
                    <div class="container-fluid">
                        <div id="container-fixed">
                        	<div class="row flex-center">
                        		<!--- logo --->
                                <div class="col-md-3">
                                    <cfif prc.isContentBoxContext && cb.themeSetting( 'headerLogo' ) is "">
										<a href="#cb.linkHome()#" class="navbar-brand" title="#cb.siteTagLine()#" data-toggle="tooltip">
											<strong>#cb.siteName()#</strong>
										</a>
									<cfelseif prc.isContentBoxContext>
										<a href="#cb.linkHome()#" class="header-logo brand-img" title="#cb.siteTagLine()#" data-toggle="tooltip">
											<img id="logo-default" src="#cb.themeSetting( 'headerLogo' )#" alt="#cb.siteName()#" class="hidden-xs hidden-sm img-responsive">
											<!--- to display on viewports less than 992px --->
											<img id="logo-alt" src="#cb.themeSetting( 'alternateLogo' )#" alt="#cb.siteName()#" class="hidden-md hidden-lg img-responsive">
										</a>
									</cfif>
                                </div>
                                <div class="col-md-5">
									<div class="top-search-form">
										<form id="search-form" name="searchForm" method="get" action="/store/category">
											<div class="input-group">
												<input type="text" class="form-control" placeholder="Search" name="search" id="searchInput" value="#event.getValue( "search", "" )#">
												<span class="input-group-btn">
													<button type="submit" class="btn btn-default"><i class="glyphicon glyphicon-search"></i></button>
												</span>
											</div>
										</form>
									</div>
                                </div>
                                <div class="col-md-4 hidden-xs hidden-sm"></div>
                            </div>
                        </div>
                        <cbcommerce-nav :prepend-categories="true"></cbcommerce-nav>
                    </div>
                </div>
             </div>
		</div>
	</header>
</cfoutput>