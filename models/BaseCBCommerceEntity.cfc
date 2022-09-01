component extends="quick.models.BaseEntity"{

    // Persistent column properties
    property name="id" type="string";
    property name="isActive" type="boolean" default=1 casts="BooleanCast@quick";
    property name="createdTime" type="date";
	property name="modifiedTime" type="date";

	variables.id = "";

	this.memento = {
		"iso8601Format" = true
	};

	function init(){
		variables.createdTime = now();
		variables.modifiedTime = now();
		return super.init();
	}

	function preSave(){
		if( !len( variables.id ) ){
			variables.id = lcase( createUUID() );
		}
	}


	// UUID key type overload
    function keyType() {
        return variables._wirebox.getInstance( "UUIDKeyType@quick" );
	}

	function fill( attributes ) {
		var data = {};

		retrieveAttributeNames().each( function( attr ){
			if( structKeyExists( attributes, attr ) ){
				data[ attr ] = attributes[ attr ];
			}
		});

		ensureBits( data );

		return super.fill( data );
	}

	function ensureBits( attributes ){
		for( var key in attributes ){
			if( isBoolean( attributes[ key ] ) && !isNumeric( attributes[ key ] ) ){
				attributes[ key ] = attributes[ key ] ? 1 : 0;
			}
		}
	}

    /**
	* Retrieves an entity by its primary key.
	* If the entity doesn't exist, it throws an exception.
	*
	* @throws EntityNotFoundException
	*
	* @id The primary key for the entity.
	*
	* @return A loaded entity.
	*/
	any function getOrFail( required any id ) {

		if ( isNull( id ) || ! len( id ) ) {
			throw(
				type = "EntityNotFoundException",
				message = "Could not find a #getMetaData( this ).name# entity. The identifier provied was empty."
			);
		}

		var entityInstance = this.find( id );

		if ( isNull( entityInstance ) ) {
			throw(
				type = "EntityNotFoundException",
				message = "Could not find a #getMetaData( this ).name# entity with id [#id#]."
			);
		}

		return entityInstance;

	}

}