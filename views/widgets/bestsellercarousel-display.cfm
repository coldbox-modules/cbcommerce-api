<cfoutput>

	<section id="bestSellerCarousel">

		<div class="block color-scheme-2">

			<div class="container">

				<div class="header-for-light">
		            <h1 class="wow fadeInRight animated animated" data-wow-duration="1s">
		            	OUR  <span>Bestsellers</span>
		            </h1>

		            <div class="toolbar-for-light" id="nav-bestseller"></div>
		        </div>
				<product-carousel :list-params='{ condition : "New", sortOrder : "hitCount DESC" }'></product-carousel>

			</div>

		</div>

	</section>

</cfoutput>