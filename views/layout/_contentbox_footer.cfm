<cfoutput>
<cfset prc.footerNav1 = cb.themeSetting( 'footerNav1', '' )>
<cfset prc.footerNav2 = cb.themeSetting( 'footerNav2', '' )>

<footer id="footer">
	<div class="footer-social">
		<div class="container">
			<div class="row">
				<div class="col-md-4">
					<div class="social">
						<cfif cb.themeSetting( 'socialFB', '' ) is not "">
							<span class="fa-stack fa-1x">
								<a href="#cb.themeSetting( 'socialFB' )#" target="_blank" >
									<span class="sr-only">Visit our Facebook page</span>
									<span class="fa fa-facebook-square fa-stack-2x"></span>
								</a>
							</span>
						</cfif>
						<cfif cb.themeSetting( 'socialT', '' ) is not "">
							<span class="fa-stack fa-1x">
								<a href="#cb.themeSetting( 'socialT' )#" target="_blank" >
									<span class="sr-only">Twitter</span>
									<span class="fa fa-twitter fa-stack-2x"></span>
								</a>
							</span>
						</cfif>
						<cfif cb.themeSetting( 'socialGP', '' ) is not "" >
							<span class="fa-stack fa-1x">
								<a href="#cb.themeSetting( 'socialGP' )#" target="_blank" >
									<span class="sr-only">Google+</span>
									<span class="fa fa-google-plus fa-stack-2x"></span>
								</a>
							</span>
						</cfif>
						<cfif cb.themeSetting( 'socialIG', '' ) is not "">
							<span class="fa-stack fa-1x">
								<a href="#cb.themeSetting( 'socialIG' )#" target="_blank" >
									<span class="sr-only">Instagram</span>
									<span class="fa fa-instagram fa-stack-2x"></span>
								</a>
							</span>
						</cfif>
						<cfif cb.themeSetting( 'socialYT', '' ) is not "">
							<span class="fa-stack fa-1x">
								<a href="#cb.themeSetting( 'socialYT' )#" target="_blank" >
									<span class="sr-only">YouTube</span>
									<span class="fa fa-youtube fa-stack-2x"></span>
								</a>
							</span>
						</cfif>
						<cfif cb.themeSetting( 'socialSL', '' ) is not "">
							<span class="fa-stack fa-1x">
								<a href="#cb.themeSetting( 'socialSL' )#" target="_blank" >
									<span class="sr-only">Slack</span>
									<span class="fa fa-slack fa-stack-2x"></span>
								</a>
							</span>
						</cfif>
						<cfif cb.themeSetting( 'socialGH', '' ) is not "">
							<span class="fa-stack fa-1x">
								<a href="#cb.themeSetting( 'socialGH' )#" target="_blank" >
									<span class="sr-only">GitHub</span>
									<span class="fa fa-github fa-stack-2x"></span>
								</a>
							</span>
						</cfif>
					</div>
				</div>
				<div class="col-md-8">
				</div>
			</div>
		</div>
	</div>
	<div class="footer-information">
    	<div class="container">
    		<div class="row">
	    		<div class="col-md-6">
	    			<div class="col-md-12 footerInfoBox">
	    				#cb.themeSetting( 'footerInfoBox', '' )#
	    			</div>
	    			<div class="col-md-6">
	    				#cb.menu( prc.footerNav1 )#
	    			</div>
	    			<div class="col-md-6">
	    				#cb.menu( prc.footerNav2 )#
	    			</div>
	    		</div>
	    		<div class="col-md-6">

	    			<div
						class="block-form box-border wow fadeInLeft animated"
						data-wow-duration="1s">

						<h3>Send Us A <span class="heading-highlight">Message</span></h3>

		    			<!--- contact form --->
		    			<contact-form message-rows="10"></contact-form>

		    		</div>

	    		</div>
	    	</div>
        </div>
    </div>

	<div class="footer-copy">
		<div class="container">
			<div class="col-md-4">
				#cb.themeSetting( 'footerBox', '' )#
			</div>
			<div class="col-md-4 text-center">
				#cb.themeSetting( 'footerBox2', '' )#
			</div>
			<div class="col-md-4 text-right">
				<p class="text-muted">Copyright &copy; #cb.siteName()#.  All rights reserved.</p>
				<p class="text-muted">Powered by ContentBox v#cb.getContentBoxVersion()#</p>
			</div>
			<!--- contentboxEvent --->
			#announce( "cbui_footer" )#
		</div>
	</div>
</footer>
</cfoutput>