/**
* cboxCommerce default Product Object
*/
component   table="cbc_SKUs"
			extends="BaseCBCommerceEntity"
			accessors="true"
			quick
{
	// Persistent column properties
	property name="isVirtual" type="boolean" default=0 casts="BooleanCast@quick";
	property name="isConsigned" type="boolean" default=0 casts="BooleanCast@quick";
	property name="allowBackorder" type="boolean" default=0 casts="BooleanCast@quick";
    property name="isFeatured" type="boolean" default=0 casts="BooleanCast@quick";
	property name="showPricing" type="boolean" default=0 casts="BooleanCast@quick";
	property name="pickUpInStore" type="boolean" default=0 casts="BooleanCast@quick";
	property name="summary" type="string" default="";
	property name="description" type="string" default="";
	property name="cost" type="numeric";
	property name="basePrice" type="numeric";
	property name="minimumPrice" type="numeric";
	property name="MAP" type="numeric";
	property name="MSRP" type="numeric";
	property name="discontinueOn" type="date";
	property name="packagedWeight" type="numeric";
	property name="packagingX" type="numeric";
	property name="packagingY" type="numeric";
	property name="packagingZ" type="numeric";
	property name="conditionDescription" type="string";
	property name="displayOrder" type="numeric" default=0;
	// an external reference id used for syncing data between systems
	property name="modelNumber" type="string" sqltype="varchar";
	property name="externalId" type="string";

	//Foreign Keys
	property name="FK_product" default="";
	property name="FK_consignor" default="";
	property name="FK_condition" default="";
	property name="FK_subCondition" default="";
	property name="FK_consignmentBatch" default="";

	this.memento = {
		"defaultIncludes" : [
			"id",
			"modelNumber",
			"pickUpInStore",
			"displayOrder",
			"isConsigned",
			"displayPrice",
			"salePrice",
			"summary",
			"description",
			"allowBackorder",
			"isVirtual",
			"isFeatured",
			"isActive",
			"conditionDescription",
			"modifiedTime",
			"packagedWeight",
			"createdTime",
			"showPricing",
			"externalId",
			"media",
			"onHand",
			"options",
			"condition",
			"subCondition"
		],
		"defaultExcludes" : [
			"product.media",
			"product.hitCount"
		],
		"profiles"     : {
			"admin" : {
				"defaultIncludes" : [
					"id",
					"modelNumber",
					"pickUpInStore",
					"displayOrder",
					"isConsigned",
					"summary",
					"description",
					"basePrice",
					"minimumPrice",
					"MSRP",
					"MAP",
					"cost",
					"consignor",
					"allowBackorder",
					"isVirtual",
					"isFeatured",
					"isActive",
					"conditionDescription",
					"modifiedTime",
					"packagedWeight",
					"createdTime",
					"showPricing",
					"externalId",
					"media",
					"onHand",
					"options",
					"condition",
					"subCondition"
				]
			}
		},
		"mappers" : {
			"MSRP" : function( item, memento ){ return item.len() ? item : javacast( "null", 0 ); },
			"MAP" : function( item, memento ){ return item.len() ? item : javacast( "null", 0 ); },
			"minimumPrice" : function( item, memento ){ return item.len() ? item : javacast( "null", 0 ); },
			"cost" : function( item, memento ){ return item.len() ? item : javacast( "null", 0 ); },
			"basePrice" : function( item, memento ){ return item.len() ? item : javacast( "null", 0 ); }
		}
	};

	function instanceReady(){
		arrayAppend(
			this.memento.defaultExcludes,
			[
				"cost",
				"FK_product",
				"FK_consignor",
				"FK_subCondition",
				"FK_condition"
			],
			true
		);
		this.memento.mappers[ "onHand" ] = function( item, memento ){ return len( memento.onHand ) ? memento.onHand : 0; };
		scopeWithOnHand();
	}

	function product(){
		return belongsTo( "Product@cbCommerce", "FK_product" )
			   .withLowestStartingPrice()
		       .withLowestPricedSKU()
			   .withStartingPriceMSRP()
		       .withAverageRating()
		       .withRatingCount();
	}

	function media(){
		return hasMany( "ProductSkuMedia@cbCommerce", "FK_sku" )
					.orderBy( 'isPrimary', 'DESC')
					.orderBy( 'displayOrder', 'ASC')
					.orderBy( 'createdTime', 'ASC' );
	}

	function virtualSKUs(){
		return hasMany( "VirtualSKU@cbCommerce", "FK_sku" );
	}

	function consignor(){
		return belongsTo( "User@cbCommerce", "FK_consignor" );
	}

	function consignmentBatch(){
		return belongsTo( "ConsignmentBatch@cbCommerce", "FK_consignmentBatch" );
	}

	function condition(){
		return belongsTo( "ProductCondition@cbCommerce", "FK_condition" );
	}

	function subCondition(){
		return belongsTo( "ProductCondition@cbCommerce", "FK_subCondition" );
	}

	function inventory(){
		return hasMany( "InventoryLocationStock@cbCommerce", "FK_sku" );
	}

	function reviews(){
		return hasMany( "ProductSKU@cbCommere", "FK_sku");
	}

	function options(){
		return hasMany( "ProductSKUOption@cbCommerce", "FK_sku" ).orderBy( "displayOrder", "ASC" );
	}

	function delete(){
		options().delete();
		reviews().delete();
		inventory().delete();
		virtualSKUs().delete();
		getMedia().each( function( mediaItem ){
			mediaItem.delete();
		} );
		return super.delete( argumentCollection=arguments );
	}


	function scopeWhereUsed( query ){
		return query.join( 'cbc_productConditions', 'cbc_SKUs.FK_condition', '=', 'cbc_productConditions.id' )
            		.where( 'cbc_productConditions.name', '!=', 'New' );
	}

	function scopeWhereInStock( query ){
        return query.where( function( subquery ){
			return subquery.whereExists(
				function( subSubQuery ){
					return subSubQuery.from( 'cbc_inventoryLocationStock' )
									.whereColumn( 'cbc_inventoryLocationStock.FK_sku', '=', 'cbc_SKUs.id' )
									.where( 'cbc_inventoryLocationStock.isActive', 1 )
									.where( 'cbc_inventoryLocationStock.available', '>=', 1 );
				}
			);

		} );
	}

	function scopeWhereAvailable( query ){
        return query.where( function( subquery ){
			return subquery
			.where( "cbc_SKUs.isActive", 1 )
			.whereExists(
				function( subSubQuery ){
					return subSubQuery.from( 'cbc_inventoryLocationStock' )
									.whereColumn( 'cbc_inventoryLocationStock.FK_sku', '=', 'cbc_SKUs.id' )
									.where( 'cbc_inventoryLocationStock.isActive', 1 )
									.where( 'cbc_inventoryLocationStock.available', '>=', 1 );
				}
			)
			.orWhere( 'cbc_SKUs.allowBackorder', 1 );

		} );
	}

	function scopeWithOnHand(){
		appendVirtualAttribute( "onHand" );
		return addSubselect(
			"onHand",
			newEntity( "InventoryLocationStock@cbcommerce" )
				.whereColumn( "cbc_inventoryLocationStock.FK_sku", "=", "cbc_SKUs.id" )
				.reselectRaw( "sum(available) as onHand" )
		);
	}

	function getDisplayPrice(){
		var displayPrice = variables.basePrice;
		if( variables.MAP > displayPrice ){
			displayPrice = variable.MAP;
		}
		return displayPrice;
	}

	function getSalePrice(){
		var salePrice = variables.basePrice;
		return salePrice;
	}
}