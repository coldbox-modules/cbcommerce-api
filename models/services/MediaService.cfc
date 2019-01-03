component singleton{
    
    property name="mediaSettings" inject="coldbox:setting:media@cbCommerce";
    

	/**
	* Provides a consistent format template for all service layer responses
	* @return ServiceResponse A new service response object
	**/
    public any function newResponse() provider="ServiceResponse@cbCommerce"{}


    /**
	* Creates a media item
	* @model any		 		The model to associate this media item with
	* @memento struct 			The memento containing the keys used to populate the new media items
	* @fileInput string 		An input field to use for processing the media object
	* @filePath string 			A file path of an existing media object to load
	**/
	public ServiceResponse function createMedia(
		required any model,
		required struct memento,
		string fileInput,
		string filePath,
		boolean persist = false
	){
		var startTime = getTickCount();
		var response = newResponse();

		//If a filePath already exists in the collection, we use that
		if( structKeyExists( arguments.memento, "mediaFile" ) ){

			arguments[ "filePath" ] = arguments.memento.mediaFile;

		// Upload handling
		} else if( isNull( arguments.filePath ) ) {

			arguments[ "fileInput" ] = "fileUpload";

		}

		var mediaItem = model.fill( arguments.memento );

		//Test for both of our file type arguments. If neither is provided, validation will handle the error
		if( !isNull( arguments.fileInput ) ){
			mediaItem.loadFile( model=arguments.model, fileInput=arguments.fileInput );
		} else if( !isNull( arguments.filePath ) ){
			mediaItem.loadFile( model=arguments.model, filePath=arguments.filePath );
		}

		if( persist && mediaItem.isValid() ){
			mediaItem.save();
			response.setResult( mediaItem );
		} else if( persist ) {

			response.setError( true );
			response.setMessages( mediaItem.getValidationResults().getAllErrors() );

		} else {
			response.setResult( mediaItem );
		}

		var endTime = getTickCount();

		response.setResponseTime(  endTime - startTime  );

		return response;

    }



	/**
	* Updates a media
	* @param AbstractMedia mediaItem 		The loaded media entity
	* @param struct memento 			The context memento used to update the media item
	**/
	public ServiceResponse function updateMedia(
		required any mediaItem,
		required struct memento,
		boolean persist = true
	){

		var response = newResponse();

		arguments.mediaItem.populate( memento=arguments.memento );

		/**
		* Workaround for our population not firing the correct method
		**/
		if( len( mediaItem.getMGRS() ) ){
			mediaItem.setLoc( spatialUtil.createGeometry( spatialUtil.mgrsToLatLon( mediaItem.getMGRS() ) ) );
		}

		//Test for both of our file type arguments. If neither is provided, validation will handle the error
		var uploaded = false;
		if( !isNull( arguments.fileInput ) ){
			loadFile( model=arguments.model, fileInput=arguments.fileInput );
			uploaded = true;
		} else if( !isNull( arguments.filePath ) ){
			loadFile( model=arguments.model, filePath=arguments.filePath );
			uploaded = true;
		}
		if ( uploaded ){
			/**
			 * Remove all variations of this file, if any, to force regeneration
			 */
			deleteMediaVariations( mediaItem );
		}

		if( arguments.mediaItem.isValid()){
			if( persist ){
				arguments.mediaItem.save();
			}
			response.setResult( arguments.mediaItem );
		} else {
			response.setError( true );
			response.setMessages( arguments.mediaItem.getValidationResults().getAllErrors() );
		}

		return response;
	}

	/**
	* Deletes a media
	* @param AbstractMedia mediaItem 		The media entity to delete
	**/
	public ServiceResponse function deleteMedia(
		any mediaItem
	){
		var response = newResponse();

		var mediaFile = expandPath( mediaItem.getFileLocation() );

		if( !isNull( mediaItem.getCase() ) ){
			mediaItem.getCase().removeMediaItem( mediaItem );
		}

		/**
		* Apparently we need to remove the geometry and save before we try to delete it ¯\(ツ)/¯
		**/
		transaction{
			try{
				mediaItem.removeGeometry();
				mediaItem.save( transactional=false );
				mediaItem.delete( transactional=false );
				transaction action="commit";
			} catch( any e ){
				transaction action="rollback";
				rethrow;
			}
		}

		/**
		 * Once our transaction is successful we can delete the file
		 **/
		if( fileExists( mediaFile ) ) fileDelete( mediaFile );

		/**
		 * Remove also all variations of this file, if any
		 */
		deleteMediaVariations( mediaItem );

		response.setResult( {
			"deleted":true
		} );

		response.addMessage( "Media item successfully deleted" );


		return response;
	}

	/**
	 * Deletes the assoctiated alternate media files from variations
	 */
	private void function deleteMediaVariations(
		any mediaItem
	){
		var mediaFile = expandPath( mediaItem.getFileLocation() );
		var index = listLen( getFileFromPath( mediaFile ), ".");

		var directoryList = directoryList(
			( getDirectoryFromPath( mediaFile ) & 'variations' ),
			false,
			"path",
			( index > 1 ? listDeleteAt( getFileFromPath( mediaFile ), index, "." ) : getFileFromPath( mediaFile ) ) & "_*.*", "file"
		);
		for ( path in directoryList ){
			if (fileExists( path )) {
				fileDelete( path );
			}
		}
    }

}