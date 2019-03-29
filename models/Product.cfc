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
    property name="isFeatured" type="boolean" default=0;
	// need to scope this as a bit until quick fixes the boolean handling
	property name="hasOptions" type="numeric" default=0;
	property name="requiredOptions" type="string" default="{}";
	property name="displayOrder" type="numeric" default=0;
	property name="hitCount" type="numeric" default=0;
	// an external reference id used for syncing data between systems
	property name="externalId" type="string";

	this.constraints = {
		name = { required : true },
		hasOptions = { required : true, type : "numeric" }
	};

	// Relationships
	function skus(){
		return hasMany( "ProductSKU@cbCommerce", "FK_product" );
	}

	function categories(){
		return belongsToMany( "ProductCategory@cbCommerce", "cbc_lookups_products_categories",  "FK_product", "FK_category" );
	}

	function media(){
		return hasMany( "ProductMedia@cbCommerce", "FK_product" )
				.orderBy( 'isPrimary', 'DESC')
				.orderBy( 'displayOrder', 'ASC')
				.orderBy( 'createdTime', 'ASC' );
	}

	function reviews(){
		return hasMany( "ProductReview@cbCommerce", "FK_product");
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
					subQuery.where( 'cbc_productConditions.name', '=', condition );
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
		var categories = categories().whereIn( 'id', categoryIds ).getResults();
		categories.each( function( category ){
			arrayAppend( categoryIds, category.keyValue() );
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

	private void function appendChildCategoryIdentifiers( required array idArray, required ProductCategory category ){
		category.getChildren().each( function( child ){
			arrayAppend( idArray, child.keyValue() );
			appendChildCategoryIdentifiers( idArray, child );
		} );
	}
	
	function filterSearch(
		required struct searchCollection, 
		required QueryBuilder builder
	 ){

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

		if( structKeyExists( searchCollection, "search" ) && len( searchCollection.search ) ){
			var searchTerm = '%' & searchCollection.search & '%';
            arguments.builder
                .where( 'name', 'like', searchTerm )
                .orWhere( 'shortDescription', 'like', searchTerm )
                .orWhere( 'description', 'like', searchTerm );
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
							.where( 'FK_product', keyValue() )
							.where( 'isActive', 1 )
							.limit( 1 )
							.orderBy( 'isPrimary', 'DESC' )
							.orderBy( 'displayOrder', 'ASC' );
		
		var results = productMedia.getResults();

		if( arrayLen( results ) ){
			return results[ 1 ].getMediaItem().url();
		} else {
			return "";
		}
	}

	function getRequiredOptions(){
		if( isSimpleValue( variables.requiredOptions ) ){
			assignAttribute( retrieveAliasForColumn( 'requiredOptions' ), deserializeJSON( variables.requiredOptions ) );
		}
		return variables.requiredOptions;
	}

	function setRequiredOptions( any options ){

		if( !isSimpleValue( arguments.options ) ){
			arguments.options = serializeJSON( arguments.options );
		}

		assignAttribute( retrieveAliasForColumn( 'requiredOptions' ), arguments.options );
	}

}