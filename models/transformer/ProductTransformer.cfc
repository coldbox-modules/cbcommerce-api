component extends="BaseModelTransformer"{

    function init(){
    	arrayAppend( 
            variables.defaultIncludes,
            [
                "media",
                "createdTime",
                "isActive",
                "startingPrice",
                "reviewSummary"
            ],
            true
        );

        arrayAppend( 
            variables.availableIncludes,
            [
                "skus",
                "categories",
                "reviews"
            ],
            true
        );

        return this;
    }

    function transform( activeEntity ){
        var memento = super.transform( argumentCollection=arguments );
        memento.requiredOptions = len( memento.requiredOptions) ? deserializeJSON( memento.requiredOptions ) : {};
        return memento;
    }

    function includeSkus( activeEntity ){
        return collection(
            activeEntity.getSkus(),
            wirebox.getInstance( "ProductSKUTransformer@cbCommerce" ),
            wirebox.getInstance( collectionSerializer )
        );
    }

    function includeStartingPrice( activeEntity ){
        return item(
            activeEntity,
            function( product ){
                var sql = "SELECT id, basePrice, showPricing, MSRP from cbc_SKUs WHERE FK_Product = '" & activeEntity.keyValue() & "' ORDER BY isFeatured DESC, basePrice ASC LIMIT 1"; 
                var q = new query( sql=sql ).execute().getResult();
                if( !q.showPricing ){
                    return {
                        "SKU" : q.id
                    };
                } else {
                    return {
                        "SKU" : q.id,
                        "basePrice" : q.basePrice,
                        "MSRP" : q.MSRP
                    };
                }
            }
        );
    }

    function includeCategories( activeEntity ){
        return collection(
            activeEntity.getCategories(),
            wirebox.getInstance( "ProductCategoryTransformer@cbCommerce" ),
            wirebox.getInstance( collectionSerializer )
        );
    }

    function includeMedia( activeEntity ){

        var filteredMedia = activeEntity.media().where( 'isActive', 1 )
                .orderBy( 'isPrimary', 'DESC')
                .orderBy( 'displayOrder', 'ASC')
                .orderBy( 'createdTime', 'ASC' );

        return collection(
            filteredMedia.getResults(),
            wirebox.getInstance( "MediaTransformer@cbCommerce" ),
            wirebox.getInstance( collectionSerializer )
        );
    }

    function includeReviewSummary( activeEntity ){

        return item(
            activeEntity,
            function( activeEntity ){
                var sql = "SELECT avg( rating ) as avgRating, count( * ) as reviewCount from cbc_productReviews WHERE FK_product = :productId AND isActive = 1 AND isPublished = 1"
                var q = new query ( sql = sql );
                q.addParam( name="productId", value=activeEntity.keyValue() );
                var result = q.execute().getResult();
                return {
                    "averageRating" : isNumeric( result.avgRating ) ? result.avgRating : 0,
                    "reviewCount" : result.reviewCount
                };
            }
        );
        
    }

    function includeReviews( activeEntity ){

        var filteredReviews = activeEntity.reviews().where( 'isActive', 1 ).where( 'isPublished', 1 )
                                .orderBy( 'relevancyScore', 'DESC' )
                                .orderBy( 'createdTime', 'DESC' );

        return collection(
            filteredReviews.getResults(),
            wirebox.getInstance( "ProductReviewTransformer@cbCommerce" ),
            wirebox.getInstance( collectionSerializer )
        );
    }

}