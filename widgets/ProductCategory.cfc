/**
* ContentBox - A Modular Content Platform
* Copyright since 2012 by Ortus Solutions, Corp
* www.ortussolutions.com/products/contentbox
* ---
* A widget that renders the content of pages from one category, which is displayed stacked rows.
*/
component extends="contentbox.models.ui.BaseWidget" singleton{

	ProductCategory function init(){
		// Widget Properties
		setName( "Category Grid" );
		setVersion( "1.1" );
		setDescription( "A widget to display best product categories as a Vue grid." );
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
	any function renderIt(){
		// generate
		return renderView( view="widgets/productcategory-display", module="cbCommerce" );
	}
}
