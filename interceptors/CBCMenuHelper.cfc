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
    property name="fractal" inject="Manager@cffractal";
	property name="HTMLHelper" inject="HTMLHelper@coldbox";
    property name="ORMService" inject="entityservice";

    void function preProcess( event, interceptData, buffer, rc, prc ) {
        // templateCache.clear( "cbCommerce_categoriesMenuTree" );
        prc.globalData.categoriesMap = templateCache.getOrSet( "cbCommerce_categoriesMenuTree", function(){
            var topLevelCategories = categoryService.newEntity()
                                                    .where( "isActive", 1 )
                                                    .whereNull( 'FK_parent' )
                                                    .orderBy( "displayOrder", "ASC" )
                                                    .orderBy( "name", "ASC" )
                                                    .get();

            return fractal.builder()
				.collection( topLevelCategories )
				.withIncludes( "children.children.children" )
                .withTransformer( "ProductCategoryTransformer@cbCommerce" )
				.convert()
        } );

        // onEnsureContentboxCategoryMenus( argumentCollection=arguments );

    }

    function onEnsureContentboxCategoryMenus( event, interceptData, buffer, rc, prc ){

        prc.globalData.categoriesMap.results.each( function( categoryId ){
            var category = prc.globalData.categoriesMap.resultsMap[ categoryId ];
            var categorySlug = HTMLHelper.slugify( category.name ) & "-category";
            //ensure the menu placeholder exists
            var tlcMenu = menuService.findBySlug( categorySlug );
            if( isNull( tlcMenu ) || !tlcMenu.isLoaded() ){
                var tlcMenu = menuService.new( properties = {
                    title = "cbCommerce Category Menu: " & category.name,
                    slug = categorySlug,
                    menuClass="dropdown-menu",
                    listClass="dropdown-menu cbcommerce-dropdown-nav"
                } );
                menuService.save( tlcMenu );
                category.children.each( function( childCategory ){
                    var menuItemService = menuService.getMenuItemService();
                    var provider = menuItemService.getProvider( "URL" );
                    var entity   = ORMService.get( entityName=provider.getEntityName(), id=0 );
                    var newItem  = menuService.populate( 
                        target=entity, 
                        memento={
                            "title" : childCategory.name,
                            "label" : childCategory.name,
                            "url"   : '/store/category/' & childCategory.id,
                            "urlClass" : "cbcommerce-nav-link",
                            "data"  : 'categoryId=' & childCategory.id,
                            "target" : "_self"
                        }
                    );
                    childCategory.children.each( function( subCategory ){
                        var entity   = ORMService.get( entityName=provider.getEntityName(), id=0 );
                        var subItem  = menuService.populate(
                            target=entity, 
                            memento={
                                "title" : subCategory.name,
                                "label" : subCategory.name,
                                "url"   : '/store/category/' & subCategory.id,
                                "urlClass" : "cbcommerce-nav-link",
                                "data"  : 'categoryId=' & subCategory.id,
                                "target" : "_self"
                            }
                        );
                        subItem.setParent( newItem );
                        subItem.setMenu( tlcMenu );
                        subItem.setActive( true );
                        newItem.addChild( subItem );
                        subCategory.children.each( function( subSubCategory ){
                            var entity   = ORMService.get( entityName=provider.getEntityName(), id=0 );
                            var subSubItem  = menuService.populate(
                                target=entity, 
                                memento={
                                    "title" : subSubCategory.name,
                                    "label" : subSubCategory.name,
                                    "url"   : '/store/category/' & subSubCategory.id,
                                    "urlClass" : "cbcommerce-nav-link",
                                    "data"  : 'categoryId=' & subSubCategory.id,
                                    "target" : "_self"
                                }
                            );
                            subSubItem.setParent( subItem );
                            subSubItem.setMenu( tlcMenu );
                            subSubItem.setActive( true );
                            subItem.addChild( subSubItem );
                        } );
                    } );
                    newItem.setMenu( tlcMenu );
                    newItem.setActive( true );
                    menuItemService.save( newItem );
                } )
            }
        });
    }

}