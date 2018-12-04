component extends="quick.models.BaseEntity"{
    
    // Persistent column properties
    property name="id" type="string";
    property name="isActive" type="boolean" default=1;
    property name="createdTime" type="date" default="#now()#";
	property name="modifiedTime" type="date" default="#now()#";

	variables.id = lcase( createGUID() );



	// UUID key type overload
    function keyType() {
        return variables._wirebox.getInstance( "UUID@quick" );
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