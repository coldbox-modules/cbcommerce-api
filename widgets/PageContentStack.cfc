/**
* ContentBox - A Modular Content Platform
* Copyright since 2012 by Ortus Solutions, Corp
* www.ortussolutions.com/products/contentbox
* ---
* A widget that renders the content of pages from one category, which is displayed stacked rows.
*/
component extends="contentbox.models.ui.BaseWidget" singleton{

	PageContentStack function init(){
		// Widget Properties
		setName( "PageContentStack" );
		setVersion( "1.1" );
		setDescription( "A widget that renders the content of pages from one category, which is displayed in stacked rows." );
		setAuthor( "Ortus Solutions" );
		setAuthorURL( "http://www.ortussolutions.com" );
		setIcon( "hdd-o" );
		setCategory( "cbCommerce" );

		return this;
	}

	/**
	* Renders a published Page Content object, if no default value is used, this throws an exception
	* @max.hint The maximum number of records to paginate
	* @titleLevel.hint The H{level} to use, by default we use H2
	* @category.hint The category to filter the content on
	*/
	any function renderIt(
		numeric max=3,
		string titleLevel="2",
		string category=""
	){

		arguments[ "contentResults" ]  = pageService.findPublishedPages( max=arguments.max, category=arguments.category, sortOrder="order" );
		arguments[ "inlineStyle"]      = {};
		arguments[ "flexClass" ]       = "";
		arguments[ "sfields" ]		   = {};
		
		arguments.sfields.bgColor    = "bgColor";
		arguments.sfields.alignement = "alignment";
		arguments.sfields.vcenter    = "vcenter";

		arguments.inlineStyle.bgColor = "";


		if( arguments.contentResults.count ){
			widgetContent = "";

			// iteration cap
			if( arguments.contentResults.count lt arguments.max){
				arguments.max = arguments.contentResults.count;
			}
			// iterate and create
			for( var x=1; x lte arguments.max; x++ ){
				arguments[ "x" ] = x;
				if( arguments.contentResults.pages[ x ].getCustomField( arguments.sfields.bgColor, arguments.inlineStyle.bgColor ) != "" ){
					arguments.inlineStyle.bgColor = arguments.contentResults.pages[ x ].getCustomField( arguments.sfields.bgColor, arguments.inlineStyle.bgColor );
				}

				if( arguments.contentResults.pages[ x ].getCustomField( arguments.sfields.vcenter, "no" ) ==  "yes" ){
					arguments.flexClass = "container-flex";
				} else {
					arguments.flexClass = "";
				}


				var textAlignment = arguments.contentResults.pages[ x ].getCustomField( arguments.sfields.alignement, "left" );

				if( textAlignment == "center" ){
					widgetContent &= renderView( view="widgets/page-content-stack/alignCenter", module="cbCommerce", args=arguments );
				} else if( textAlignment == "right" ) {
					widgetContent &= renderView( view="widgets/page-content-stack/alignRight", module="cbCommerce", args=arguments );
				} else {
					widgetContent &= renderView( view="widgets/page-content-stack/alignLeft", module="cbCommerce", args=arguments );
				}

				arguments.inlineStyle.bgColor = "fff";
			}
			return widgetContent;
		} else {
			return "";
		}
	}
}
