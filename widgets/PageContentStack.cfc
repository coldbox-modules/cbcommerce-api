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
		setCategory( "Content" );

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

		var contentResults = pageService.findPublishedPages( max=arguments.max, category=arguments.category, sortOrder="order" );
		var rString		= "";
		var sfields		= {};
		var inlineStyle = {};
		var flexClass = "";

		sfields.bgColor = "bgColor";
		sfields.alignement = "alignment";
		sfields.vcenter = "vcenter";

		inlineStyle.bgColor = "";


		if( contentResults.count ){

			// iteration cap
			if( contentResults.count lt arguments.max){
				arguments.max = contentResults.count;
			}
			// generate
			saveContent variable="rString"{
				// iterate and create
				for( var x=1; x lte arguments.max; x++ ){
					if( contentResults.pages[ x ].getCustomField( sfields.bgColor, inlineStyle.bgColor ) != "" ){
						inlineStyle.bgColor = contentResults.pages[ x ].getCustomField( sfields.bgColor, inlineStyle.bgColor );
					}

					if( contentResults.pages[ x ].getCustomField( sfields.vcenter, "no" ) ==  "yes" ){
						flexClass = "container-flex";
					} else {
						flexClass = "";
					}


					var textAlignment = contentResults.pages[ x ].getCustomField( sfields.alignement, "left" );

					if( textAlignment == "center" ){
						include "pagecontentstack-templates/alignCenter.cfm";
					} else if( textAlignment == "right" ) {
						include "pagecontentstack-templates/alignRight.cfm";
					} else {
						include "pagecontentstack-templates/alignLeft.cfm";
					}

					inlineStyle.bgColor = "fff";
				}
			}
		}
		return rString;
	}
}
