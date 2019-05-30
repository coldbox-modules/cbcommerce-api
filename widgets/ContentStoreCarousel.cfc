/**
* ContentBox - A Modular Content Platform
* Copyright since 2012 by Ortus Solutions, Corp
* www.ortussolutions.com/products/contentbox
* ---
* A widget that renders a carousel of the images in the Media Libray.
*/
component extends="contentbox.models.ui.BaseWidget" singleton{

	ContentStoreCarousel function init(){
		// Widget Properties
		setName( "Content Store Carousel" );
		setVersion( "1.1" );
		setDescription( "A widget that renders a Revolution Slider." );
		setAuthor( "Ortus Solutions" );
		setAuthorURL( "http://www.ortussolutions.com" );
		setIcon( "hdd-o" );
		setCategory( "cbCommerce" );

		return this;
	}

	/**
	* Renders a carousel of the images in the Media Libray
	* @max.hint The maximum number of records to paginate
	* @category.hint The category to filter the content on
	*/
	any function renderIt(
		numeric max=3,
		string category="",
		string sortOrder="order ASC"
	){
		var contentResults = contentStoreService.findPublishedContent( max=arguments.max, category=arguments.category, sortOrder=arguments.sortOrder );
		var slides = [];
		var rString			= "";

		if( contentResults.count ){
			// iteration cap
			if( contentResults.count lt arguments.max){
				arguments.max = contentResults.count;
			}

			// prep struct to pass to component
			for( var x=1; x lte arguments.max; x++ ){
				var slide = {};

				slide.imageURL = contentResults.content[ x ].getCustomField( "imageURL", "" );
				slide.button1Text = contentResults.content[ x ].getCustomField( "button1Text", "" );
				slide.button1URL = contentResults.content[ x ].getCustomField( "button1URL", "" );
				slide.button2Text = contentResults.content[ x ].getCustomField( "button2Text", "" );
				slide.button2URL = contentResults.content[ x ].getCustomField( "button2URL", "" );

				slide.title = encodeForHTMLAttribute( REReplace( contentResults.content[ x ].getTitle(), '"', '\"', "all" ) );
				slide.content = encodeForHTMLAttribute( REReplace( contentResults.content[ x ].getContent(), '"', '\"', "all" ) );

				arrayAppend( slides, slide );
			}
			// writeDump(slides);
			slides = SerializeJSON( slides );
			// writeDump(slides);abort;

		}
		// generate
		return renderView( view="widgets/contentstorecarousel-display", module="cbCommerce", args={ "slides" : slides } );
	}
}