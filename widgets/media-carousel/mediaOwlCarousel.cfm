<cfoutput >
	<media-owl-carousel
		carousel-class='#arguments.carouselClass#'
		carousel-id='#arguments.carouselId#'
		:file-list = '#listing#'
		:image-info = '#moreInfo#'
		media-folder= '#arguments.folder#'
		:show-nav = '#arguments.showNav#'
		:auto-play = '#arguments.autoPlay#'
		:items-on-stage = '#arguments.itemsOnStage#'
		nav-container= '#arguments.navContainer#'
		:margin = '#arguments.margin#'
		:loop = '#arguments.loop#'
	></media-owl-carousel>
</cfoutput>