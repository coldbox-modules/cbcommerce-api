/**
* ContentBox - A Modular Content Platform
* Copyright since 2012 by Ortus Solutions, Corp
* www.ortussolutions.com/products/contentbox
* ---
* A widget that renders the content of pages from one category, which is displayed stacked rows.
*/
component extends="contentbox.models.ui.BaseWidget" singleton{

	FinanceCalculator function init(){
		// Widget Properties
		setName( "Finance Calculator Vue Component" );
		setVersion( "1.1" );
		setDescription( "A widget to display the Finace Calculator as a Vue component." );
		setAuthor( "Ortus Solutions" );
		setAuthorURL( "http://www.ortussolutions.com" );
		setIcon( "hdd-o" );
		setCategory( "Content" );

		return this;
	}

	/**
	* Renders a published Page Content object, if no default value is used, this throws an exception
	*/
	any function renderIt(){
		// generate
		return '<bsr-finance-calculator></bsr-financecalculator>';
	}
}
