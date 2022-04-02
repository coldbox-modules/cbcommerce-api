/**
* @displayname CBC Menu Helper Interceptor
* @package     cbCommerce.interceptors
* @description This creates the available product category menus
* @author      Jon Clausen <jclausen@ortussolutions.com>
**/
component{
    property name="menuService" inject="MenuService@cb";
    property name="templateCache" inject="cachebox:template";
    property name="categoryService" inject="ProductCategoryService@cbCommerce";
	property name="HTMLHelper" inject="HTMLHelper@coldbox";
    property name="ORMService" inject="entityservice";
    property name="resultsMapper" inject="ResultsMapper@mementifier";

    void function preProcess( event, interceptData, buffer, rc, prc ) {

        prc.globalData["categoriesMap"] = templateCache.getOrSet( "cbCommerce_categoriesMenuTree", function(){
            var transformer = getInstance( "ProductCategoryTransformer@cbCommerce" );
            transformer.setNewChildrenOnly( true );

            var topLevelCategories = categoryService.newEntity()
                                                        .where( "isActive", 1 )
                                                        .whereNull( 'FK_parent' )
                                                        .orderBy( "displayOrder", "ASC" )
                                                        .orderBy( "name", "ASC" )
                                                        .get();
			return resultsMapper.process(
				collection=topLevelCategories,
				includes="children.children.children"
			)
        } );

    }

}