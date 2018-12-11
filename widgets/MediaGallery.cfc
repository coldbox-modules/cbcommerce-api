/**
* ContentBox - A Modular Content Platform
* Copyright since 2012 by Ortus Solutions, Corp
* www.ortussolutions.com/products/contentbox
* ---
* A widget that renders a carousel of the images in the Media Libray.
*/
component extends="contentbox.models.ui.BaseWidget" singleton{

	MediaGallery function init(){
		// Widget Properties
		setName( "Media Gallery" );
		setVersion( "1.1" );
		setDescription( "A widget that renders a gallery of the images in the Media Libray." );
		setAuthor( "Ortus Solutions" );
		setAuthorURL( "http://www.ortussolutions.com" );
		setIcon( "hdd-o" );
		setCategory( "cbCommerce" );

		return this;
	}

	/**
	* Renders a gallery of the images in the Media Libray
	* @folder.hint The directory in the Media Libray whose images will be in the gallery.
	* @sort.hint Sort images by:
	* @order.hint The order in which the images will display ( asc | desc ).
	* @galleryClass.hint The carousel class.
	* @galleryId.hint The carousel id.
	*
	*/
	any function renderIt(
		string folder = "",
		string sort = "",
		string order = "asc",
		string galleryClass = "",
		required string gallerylId=""
	){
		var cbSettings = getRequestContext().getValue( name="cbSettings",private=true );
		// Media path
		var mediaPath = cbSettings.cb_media_directoryRoot & "/" & arguments.folder;
		var mediaPathExpanded = expandPath( mediaPath );
		//  Directory list with file info as json object
		arguments.listing = SerializeJSON( directoryList( path=mediaPathExpanded, recurse=false, listInfo="query", filter="*.jpg|*.png", sort='#arguments.sort# #arguments.order#' ), 'struct' );
		// File with additional data for each image in directory
		var moreInfoFile = directoryList( path=mediaPathExpanded, recurse=false, listInfo="name", filter="directory-list.json");

		// if directory-list.json exists in dir load content
		if( ArrayLen( moreInfoFile ) > 0 ){
			arguments.moreInfo =  fileRead( mediaPathExpanded & "/directory-list.json" );
		}else{
			arguments.moreInfo = SerializeJSON( {} );
		}

		return renderView( view="widgets/media-gallery-display", module="cbCommerce", args=arguments );

	}
}
