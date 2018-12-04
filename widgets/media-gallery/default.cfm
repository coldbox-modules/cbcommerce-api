<cfoutput >
	<cb-media-gallery
		gallery-class='#arguments.galleryClass#'
		gallery-id='#arguments.gallerylId#'
		:file-list = '#listing#'
		:image-info = '#moreInfo#'
		media-folder= '#arguments.folder#'
	></cb-media-gallery>
</cfoutput>