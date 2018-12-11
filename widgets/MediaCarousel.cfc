/**
* ContentBox - A Modular Content Platform
* Copyright since 2012 by Ortus Solutions, Corp
* www.ortussolutions.com/products/contentbox
* ---
* A widget that renders a carousel of the images in the Media Libray.
*/
component extends="contentbox.models.ui.BaseWidget" singleton{

	MediaCarousel function init(){
		// Widget Properties
		setName( "Media Carousel" );
		setVersion( "1.1" );
		setDescription( "A widget that renders a carousel of the images in the Media Libray." );
		setAuthor( "Ortus Solutions" );
		setAuthorURL( "http://www.ortussolutions.com" );
		setIcon( "hdd-o" );
		setCategory( "cbCommerce" );

		return this;
	}

	/**
	* Renders a carousel of the images in the Media Libray
	* @folder.hint The directory in the Media Libray whose images will be in the carousel.
	* @sort.hint Sort images by:
	* @order.hint The order in which the images will display ( asc | desc ).
	* @carouselClass.hint The carousel class.
	* @carouselId.hint The carousel id.
	* @showNav.hint Show the carousel's previous and next buttons ( true | false ).
	* @autoPlay.hint Autoplay the carousel ( true | false ).
	* @itemsOnStage.hint The number of items you want to see on the screen.
	* @navContainer.hint Set your own container for nav, class or id.
	* @margin.hint The margin-right(px) on item.
	* @loop.hint Loop carousel ( true | false ).
	*
	*/
	any function renderIt(
		string folder = "",
		string sort = "",
		string order = "asc",
		string carouselClass = "",
		required string carouselId="",
		boolean showNav = false,
		boolean autoPlay = false,
		numeric itemsOnStage = 4,
		string navContainer = "",
		numeric margin = 0,
		boolean loop = false
	){
		var cbSettings = getRequestContext().getValue( name="cbSettings",private=true );
		// Media path
		var mediaPath = cbSettings.cb_media_directoryRoot & "/" & arguments.folder;
		var mediaPathExpanded = expandPath( mediaPath );
		//  Directory list with file info as json object
		arguments[ "listing" ] = SerializeJSON( directoryList( path=mediaPathExpanded, recurse=false, listInfo="query", filter="*.jpg|*.png", sort='#arguments.sort# #arguments.order#' ), 'struct' );
		// File with additional data for each image in directory
		var moreInfoFile = directoryList( path=mediaPathExpanded, recurse=false, listInfo="name", filter="directory-list.json");

		// if directory-list.json exists in dir load content
		if( ArrayLen( moreInfoFile ) > 0 ){
			arguments[ "moreInfo" ] =  fileRead( mediaPathExpanded & "/directory-list.json" );
		}else{
			arguments[ "moreInfo" ] = SerializeJSON( {} );
		}

		return renderView( view="widgets/media-carousel/mediaOwlCarousel", module="cbCommerce", args=arguments );
	}
}
