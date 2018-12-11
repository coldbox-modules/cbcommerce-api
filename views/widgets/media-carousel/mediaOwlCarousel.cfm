<cfoutput >
	<media-owl-carousel
		carousel-class='#args.carouselClass#'
		carousel-id='#args.carouselId#'
		:file-list = '#args.listing#'
		:image-info = '#args.moreInfo#'
		media-folder= '#args.folder#'
		:show-nav = '#args.showNav#'
		:auto-play = '#args.autoPlay#'
		:items-on-stage = '#args.itemsOnStage#'
		nav-container= '#args.navContainer#'
		:margin = '#args.margin#'
		:loop = '#args.loop#'
	></media-owl-carousel>
</cfoutput>