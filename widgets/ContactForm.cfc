/**
* ContentBox - A Modular Content Platform
* Copyright since 2012 by Ortus Solutions, Corp
* www.ortussolutions.com/products/contentbox
* ---
* A widget that renders the content of pages from one category, which is displayed stacked rows.
*/
component extends="contentbox.models.ui.BaseWidget" singleton{

	ContactForm function init(){
		// Widget Properties
		setName( "Contact Form Vue Component" );
		setVersion( "1.1" );
		setDescription( "A widget to display the contact form as a Vue component." );
		setAuthor( "Ortus Solutions" );
		setAuthorURL( "http://www.ortussolutions.com" );
		setIcon( "hdd-o" );
		setCategory( "cbCommerce" );

		return this;
	}

	/**
	* Renders a published Content Form object, if no default value is used, this throws an exception
	*/
	any function renderIt(){
		return renderView( view="widgets/contactform-display", module="cbCommerce" );
	}
}
