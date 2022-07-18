component extends="BaseQuickEntityService" singleton{
    //provider for the entity - this provider must exist to use the search() method
    function newEntity() provider="DeliveryMethod@cbCommerce"{}

	function ensureDeliveryMethods( required array methods ){
		arguments.methods.each( function( m, index ){
			if( !newBuilder( { "label" : m.label } ).count() ){
				param m.sortOrder = index;
				newEntity().fill( m ).save();
			}
		} );

		var activeMethods = methods.map( function( m ){ return m.label; } );

		return newBuilder({ "isActive" : 1 } )
				.select( [ "id", "label", "description", "sortOrder", "isFlatRate", "flatRateFee" ])
				.orderBy( "sortOrder" ).get()
				.map( function( m ){
					m.isFlatRate = javacast( "boolean", m.isFlatRate );
					return m;
				} );
	}

}