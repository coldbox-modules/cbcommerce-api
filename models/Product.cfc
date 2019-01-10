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
		return hasMany( "ProductMedia@cbCommerce", "FK_product" );
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

	function scopeWhereWithinCategory( query, string categoryId ){
		var categoryIds = listToArray( categoryId );
		var categories = categories().whereIn( 'id', categoryIds ).getResults();
		categories.each( function( category ){
			arrayAppend( categoryIds, category.keyValue() );
			arrayAppend( categoryIds, getChildCategoryIdentifiers( category ), true );
		} );
		return query.whereExists( 
			function( subQuery ){
				return subQuery.from( 'cbc_lookups_products_categories' )
						.whereColumn( 'cbc_products.id', 'cbc_lookups_products_categories.FK_product'  )
						.whereIn( 'cbc_lookups_products_categories.FK_category', categoryIds );
			}
		);
	}

	private function getChildCategoryIdentifiers( category ){
		var childIdentifiers = [];
		category.getChildren().each( function( child ){
			arrayAppend( childIdentifiers, child.keyValue() );
			arrayAppend( childIdentifiers, getChildCategoryIdentifiers( child ), true );
		} );
		return childIdentifiers;
	}
	
	function filterSearch(
		required struct searchCollection, 
		required QueryBuilder builder
	 ){

		if( structKeyExists( searchCollection, "category" ) ){
            if( searchCollection.category == 'used' ){
                this.hasUsedSKU();
            } else {
                this.whereWithinCategory( searchCollection.category );
            }
        }

		if( structKeyExists( searchCollection, "search" ) && len( searchCollection.search ) ){
			var searchTerm = '%' & searchCollection.search & '%';
            arguments.builder
                .where( 'name', 'like', searchTerm )
                .orWhere( 'shortDescription', 'like', searchTerm )
                .orWhere( 'description', 'like', searchTerm )
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