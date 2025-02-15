/**
* cboxCommerce Product Object
*/
component   table="cbc_products"
			extends="BaseCBCommerceEntity"
			accessors="true"
			quick
{
    // Column Properties
	property name="name" type="string" default="";
	property name="shortDescription" type="string" default="";
	property name="description" type="string" default="";
	property name="manufacturer" type="string" default="";
    property name="isFeatured" type="boolean" default=0 casts="BooleanCast@quick";
	// need to scope this as a bit until quick fixes the boolean handling
	property name="hasOptions" type="numeric" default=0 casts="BooleanCast@quick";
	property name="requiredOptions" type="string" default="{}";
	property name="displayOrder" type="numeric" default=0;
	property name="hitCount" type="numeric" default=0;
	// an external reference id used for syncing data between systems
	property name="externalId" type="string" default="";

	this.constraints = {
		name = { required : true },
		hasOptions = { required : true, type : "numeric" }
	};

	function instanceReady(){
		arrayAppend(
            this.memento.defaultIncludes,
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
            this.memento.defaultExcludes,
            [
                "requiredOptions"
            ],
            true
        );
		this.withLowestStartingPrice();
		this.withLowestPricedSKU();
		this.withStartingPriceMSRP();
		this.withAverageRating();
		this.withRatingCount();
	}

	// Relationships
	function skus(){
		return hasMany( "ProductSKU@cbCommerce", "FK_product" ).withOnHand();
	}

	function activeSkus(){
		return hasMany( "ProductSKU@cbCommerce", "FK_product" ).withOnHand().with( 'media' ).whereAvailable();
	}

	function categories(){
		return belongsToMany( "ProductCategory@cbCommerce", "cbc_lookups_products_categories",  "FK_product", "FK_category" );
	}

	function media(){
		return hasMany( "ProductMedia@cbCommerce", "FK_product" )
				.with( 'mediaItem' )
				.orderBy( 'isPrimary', 'DESC')
				.orderBy( 'displayOrder', 'ASC')
				.orderBy( 'createdTime', 'ASC' );
	}

	function reviews(){
		return hasMany( "ProductReview@cbCommerce", "FK_product");
	}

	function getReviewSummary(){
		return {
			"count" : variables.ratingCount,
			"average" : len( variables.averageRating ) ? variables.averageRating : javacast( "null", 0 )
		};
	}

	function getStartingPrice(){
		return {
			"basePrice" : variables.lowestStartingPrice,
			"MSRP" : len( variables.startingPriceMSRP ) ? variables.startingPriceMSRP : 0,
			"SKU" : variables.lowestPricedSKU
		};
	}

	// delete overload
	function delete(){
		this.getMedia().each( function( productMedia ){
			var mediaAttachment = productMedia.getMediaItem();
			productMedia.delete();
			mediaAttachment.delete();
		 });
		this.getSkus().each( function( skuEntity ){
			skuEntity.delete();
		} );
		this.categories().sync([]);
		return super.delete();
	}

	function scopeWithLowestStartingPrice( qb ){
		qb.addSubselect(
			"lowestStartingPrice",
			newEntity( "ProductSKU@cbcommerce" )
				.whereColumn( "cbc_SKUs.FK_product", "=", "cbc_products.id" )
				.whereAvailable()
				.reselectRaw( "min( basePrice ) as lowestStartingPrice" )

		);
		appendVirtualAttribute( "lowestStartingPrice" );
	}

	function scopeWithLowestPricedSKU( qb ){
		qb.addSubselect(
			"lowestPricedSKU",
			newEntity( "ProductSKU@cbcommerce" )
				.whereColumn( "cbc_SKUs.FK_product", "=", "cbc_products.id" )
				.reselectRaw( "cbc_SKUs.id as lowestPricedSKU" )
				.whereAvailable()
				.orderBy( "cbc_SKUs.basePrice", "asc" )
				.limit( 1 )
		);
		appendVirtualAttribute( "lowestPricedSKU" );
	}

	function scopeWithStartingPriceMSRP( qb ){
		qb.addSubselect(
			"startingPriceMSRP",
			newEntity( "ProductSKU@cbcommerce" )
				.whereColumn( "cbc_SKUs.FK_product", "=", "cbc_products.id" )
				.reselectRaw( "cbc_SKUs.MSRP as startingPriceMSRP" )
				.whereAvailable()
				.orderBy( "cbc_SKUs.basePrice", "asc" )
				.limit( 1 )
		);
		appendVirtualAttribute( "startingPriceMSRP" );
	}

	function scopeWithAverageRating( qb ){
		qb.addSubselect(
			"averageRating",
			newEntity( "ProductReview@cbcommerce" )
				.whereColumn( "cbc_productReviews.FK_product", "=", "cbc_products.id" )
				.reSelectRaw( "avg(rating) as avgRating" )
        );
		appendVirtualAttribute( "averageRating" );
	}

	function scopeWithRatingCount( qb ){
		qb.addSubselect(
			"ratingCount",
			newEntity( "ProductReview@cbcommerce" )
				.whereColumn( "cbc_productReviews.FK_product", "=", "cbc_products.id" )
				.reSelectRaw( "count(*) as ratingCount" )
        );
		appendVirtualAttribute( "ratingCount" );
	}

    function scopeHasUsedSKU( query ){
        return query.whereExists(
            function( subQuery ){
				return subQuery.from( 'cbc_SKUs' )
						.whereColumn( 'cbc_SKUs.FK_product', '=', 'cbc_products.id' )
                        .join( 'cbc_productConditions', 'cbc_SKUs.FK_condition', '=', 'cbc_productConditions.id' )
                        .where( 'cbc_productConditions.name', '!=', 'New' );
            }
        );
	}

	function scopeWhereMissingMedia( query ){
		return query.whereNotExists(
            function( subQuery ){
				subQuery.from( 'cbc_productMedia' )
						.whereColumn( 'cbc_productMedia.FK_product', '=', 'cbc_products.id' );
				return subQuery;
            }
        );
	}

	function scopeWhereCondition( query, condition ){
		return query.whereExists(
            function( subQuery ){
				subQuery.from( 'cbc_SKUs' )
						.whereColumn( 'cbc_SKUs.FK_product', '=', 'cbc_products.id' )
						.join( 'cbc_productConditions', 'cbc_SKUs.FK_condition', '=', 'cbc_productConditions.id' );
				if( isValid( 'guid', condition ) ){
					subQuery.where( 'cbc_productConditions.id', condition );
				} else {
					subQuery.whereIn( 'cbc_productConditions.name', listToArray( condition ) );
				}

				return subQuery;
            }
        );
	}

	function scopeWhereSubCondition( query, array subConditions ){
		return query.whereExists(
            function( subQuery ){
				subQuery.from( 'cbc_SKUs' )
						.whereColumn( 'cbc_SKUs.FK_product', '=', 'cbc_products.id' )
						.join( 'cbc_productConditions', 'cbc_SKUs.FK_subCondition', '=', 'cbc_productConditions.id' );
				if( isValid( 'guid', subConditions[ 1 ] ) ){
					subQuery.whereIn( 'cbc_productConditions.id', subConditions );
				} else {
					subQuery.whereIn( 'cbc_productConditions.name', subConditions );
				}

				return subQuery;
            }
        );
	}

    function scopeWhereInStock( query ){
        return query.whereExists(
            function( subQuery ){
				return subQuery.from( 'cbc_SKUs' )
						.whereColumn( 'cbc_SKUs.FK_product', '=', 'cbc_products.id' )
						.whereExists(
							function( subSubQuery ){
								return subSubQuery.from( 'cbc_inventoryLocationStock' )
												.whereColumn( 'cbc_inventoryLocationStock.FK_sku', '=', 'cbc_SKUs.id' )
												.where( 'cbc_inventoryLocationStock.isActive', 1 )
												.where( 'cbc_inventoryLocationStock.available', '>=', 1 );
							}
						)
						.orWhere( 'cbc_SKUs.allowBackorder', 1 );
            }
        );
	}

	function scopeWhereWithinCategory( query, string categoryId ){
		var categoryIds = listToArray( categoryId );
		var categories = variables._wirebox.getInstance( "ProductCategory@cbCommerce" ).whereIn( 'id', categoryIds ).get();
		categories.each( function( category ){
			arrayAppend( categoryIds, category.keyValues(), true );
			appendChildCategoryIdentifiers( categoryIds, category );
		} );
		return query.whereExists(
			function( subQuery ){
				return subQuery.from( 'cbc_lookups_products_categories' )
						.whereColumn( 'cbc_products.id', 'cbc_lookups_products_categories.FK_product'  )
						.whereIn( 'cbc_lookups_products_categories.FK_category', categoryIds );
			}
		);
	}

	function scopeWherePriceAbove( query, numeric price ){
		return query.whereExists(
			function( subQuery ){
				return subQuery.from( 'cbc_SKUs highPriceSKU' )
						.whereColumn( 'cbc_products.id', 'highPriceSKU.FK_product'  )
						.where( 'highPriceSKU.basePrice' , '>=', price );
			}
		);
	}

	function scopeWherePriceBelow( query, numeric price ){
		return query.whereExists(
			function( subQuery ){
				return subQuery.from( 'cbc_SKUs highPriceSKU' )
						.whereColumn( 'cbc_products.id', 'highPriceSKU.FK_product'  )
						.where( 'highPriceSKU.basePrice' , '<=', price );
			}
		);
	}

	function scopeWhereModelNumber( query, string modelNumber ){
		return query.whereExists(
			function( subQuery ){
				return subQuery.from( 'cbc_SKUs SKUs' )
						.whereColumn( 'cbc_products.id', 'SKUs.FK_product'  )
						.where( 'SKUs.modelNumber' , modelNumber );
			}
		);
	}

	private void function appendChildCategoryIdentifiers( required array idArray, required ProductCategory category ){
		category.getChildren().each( function( child ){
			arrayAppend( idArray, child.keyValues()[1] );
			appendChildCategoryIdentifiers( idArray, child );
		} );
	}

	function filterSearch(
		required struct searchCollection,
		required QueryBuilder builder
	 ){

		this.with( 'media.mediaItem' );

		if( ! structKeyExists( searchCollection, "activeSkusOnly" ) || searchCollection.activeSkusOnly ){
			this.with( 'activeSkus' );
		} else {
			this.with( 'skus' );
		}

		if( structKeyExists( searchCollection, "category" ) ){
            if( searchCollection.category == 'used' ){
                this.scopeHasUsedSKU( arguments.builder );
            } else {
                this.whereWithinCategory( searchCollection.category );
            }
		}

		if( structKeyExists( searchCollection, "condition" ) ){
			this.scopeWhereCondition( arguments.builder, searchCollection.condition );
		}

		if( structKeyExists( searchCollection, "subCondition" ) ){
			if( isSimpleValue( searchCollection.subCondition ) ){
				searchCollection.subCondition = listToArray( searchCollection.subCondition );
			}
			this.scopeWhereSubCondition( arguments.builder, searchCollection.subCondition );
		}

		if( structKeyExists( searchCollection, "minimumPrice" ) && isNumeric( searchCollection.minimumPrice ) ){
			this.scopeWherePriceAbove( arguments.builder, searchCollection.minimumPrice );
		}

		if( structKeyExists( searchCollection, "maximumPrice" ) && isNumeric( searchCollection.maximumPrice ) ){
			this.scopeWherePriceBelow( arguments.builder, searchCollection.maximumPrice );
		}

		if( structKeyExists( searchCollection, "search" ) && len( searchCollection.search ) ){
			var searchTerm = '%' & searchCollection.search & '%';
			arguments.builder
                .where( 'name', 'like', searchTerm )
                .orWhere( 'shortDescription', 'like', searchTerm )
				.orWhere( 'description', 'like', searchTerm )
				.orwhereExists(
					function( subQuery ){
						return subQuery.from( 'cbc_SKUs SKUs' )
						.whereColumn( 'cbc_products.id', 'SKUs.FK_product'  )
						.where( 'SKUs.modelNumber' , searchCollection.search )
						.orWhere( 'SKUs.externalId' ,'like', searchCollection.search );
				}
			);
		}

		if( structKeyExists( searchCollection, "modelNumber" ) ){
			this.scopeWhereModelNumber( arguments.builder, searchCollection.modelNumber );
		}

		if( structKeyExists( searchCollection, "externalIdSearch" ) && len( searchCollection.externalIdSearch ) ){
			var searchTerm = '%' & searchCollection.externalIdSearch & '%';
            arguments.builder
                .where( 'externalId', 'like', searchTerm );
		}

		if( structKeyExists( searchCollection, "sortBy") ){
			switch( listFirst( searchCollection.sortBy, ":") ){
				case "position":{
					searchCollection.sortOrder = "displayOrder ASC";
					break;
				}
				case "price":{
					searchCollection.sortOrder = "displayOrder " & ucase( listLast( searchCollection.sortBy, ":" ) );
					break;
				}
				case "name" :{
					searchCollection.sortOrder = "cbc_products.name " & ucase( listLast( searchCollection.sortBy, ":" ) );
					break;
				}
				case "quantity":
				case "inStock":{
					scopeWhereInStock( builder );
					break;
				}
				default:{
					searchCollection.sortOrder = listFirst( searchCollection.sortBy, ":" ) & " " & ucase( listLast( searchCollection.sortBy, ":" ) );
				}
			}
		}
	 }

	 function getPrimaryImageURL(){
		var productMedia = media()
							.with( 'mediaItem' )
							.where( 'FK_product', keyValues()[1] )
							.where( 'isActive', 1 )
							.limit( 1 )
							.orderBy( 'isPrimary', 'DESC' )
							.orderBy( 'displayOrder', 'ASC' )
							.orderBy( 'createdTime', 'ASC' );

		var results = productMedia.getResults();

		if( arrayLen( results ) ){
			return results[ 1 ].getMediaItem().url();
		} else {
			return "";
		}
	}

	function getRequiredOptions(){
		return deserializeJSON( variables.requiredOptions );
	}

	function setRequiredOptions( any options ){
		variables.options = !isSimpleValue( arguments.options ) ? serializeJSON( arguments.options ) : arguments.options;
	}

}