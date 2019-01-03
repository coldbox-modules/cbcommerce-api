component extends="BaseAPIHandler"{

    // (POST) /statistics/products/:id
    function productView( event, rc, prc ){
        lock type="exclusive" name="productHitCountUpdate_#rc.id#" timeout=30 {
            var product = getInstance( "Product@cbCommerce" ).getOrFail( rc.id );
            product.update( { hitCount : product.getHitCount()+1 } );
            prc.response.setStatusCode( STATUS.ACCEPTED ).setData( { "count" : product.getHitCount() } );
        }
    }

    // (POST) /statistics/categories/:id
    function categoryView( event, rc, prc ){
        lock type="exclusive" name="categoryHitCountUpdate_#rc.id#" timeout=30 {
            var category = getInstance( "ProductCategory@cbCommerce" ).getOrFail( rc.id );
            category.update( { hitCount : category.getHitCount()+1 } );
            prc.response.setStatusCode( STATUS.ACCEPTED ).setData( { "count" : category.getHitCount() } );
        }

    }


}