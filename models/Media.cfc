/**
* cboxCommerce Media Entity
*/
component   table="cbc_media" 
			extends="quick.models.BaseEntity" 
			accessors="true"
			quick
{ 
    property name="mediaSettings" inject="coldbox:setting:media@cbCommerce" persistent="false";
    // Persistent column properties
	property name="designation" type="string" default="product";
	property name="title" type="string" default="";
	property name="caption" type="string" default="";
	property name="originalFileName" type="string";
	property name="fileLocation" type="string";
	property name="fileSizeBytes" type="string";

	function url(){
		return "";
	}

		/**
	* Set our file from a path
	* @model any 					The entity to associate the media object with
	* @fileInput string 			The name of an input field to load the file from
	* @filePath string 				An existing physical path to a file
	* @pathExtension string 		An exension to append to the shared storage directory
	* @chainable
	**/
	public Media function loadFile(
		required any model,
		string fileInput,
		string filePath,
		string pathExtension = "products"
	){
		//the filesPath used for this model - may be overriden by model properties - defaults to the WEATCore setting + model name + identifier
		var filesPath = mediaSettings.storageLocation & "/" & pathExtension;

		//the expanded target directory
		var filesDirectory = expandPath( filesPath );

		if( !directoryExists( filesDirectory ) ) {
			try {
				directoryCreate( filesDirectory );
			} catch ( any ex ){
				// Another thread may have already created it, otherwise rethrow.
				if( !directoryExists( filesDirectory ) ){
					rethrow;
				}
			}
		}

		//Process our field upload and return the tmp clientFile
		if( !isNull( arguments.fileInput ) ){

			var tmpFile = uploadToTemp( arguments.fileInput, mimeAccept );
		
		} else if( !isNull( arguments.filePath ) ) {
			var inputFile = arguments.filePath;

			if( !fileExists( arguments.filePath ) ){
				inputFile = expandPath( arguments.filePath );
			}

			/** Throw if we are unable to proceed **/
			if( !fileExists( inputFile ) ) throw( "The requested file #arguments.filePath# does not exist in either an absolute or an expanded path" )

			var fileInfo = getFileInfo( inputFile );

			var tmpFile = {
				"clientFile"		: fileInfo.name,
				"serverDirectory"	: fileInfo.parent,
				"fileSize"			: fileInfo.size,
				"clientFileExt"		: listLast( fileInfo.name, "." )
			};

		}

		//set our size so we don't have to read the file later to get size data
		setFileSizeBytes( tmpFile.fileSize );

		//if we don't have an existing name, use the file name
		if( !len( getTitle() ) ){
			setTitle( tmpFile.clientFile );
		}

		setUploadFileName( listLast( tmpFile.clientFile, "/" ) );

		var fileExtension = tmpFile.clientFileExt;

		var fileName = getId() & "." & lcase( fileExtension );

		var fileDestination = filesDirectory & "/" & fileName;

		//move the file to its new home
		fileMove( tmpFile.serverDirectory & "/" & tmpfile.clientFile , fileDestination );

		this.setFileLocation( filesPath & "/" & fileName );

		return this;
	}

	/**
	* Uploads a file from a form input and returns the cffile struct
	* @input string 		The name of the input field
	* @mimeAccept string	The allowed mime formats for upload  - defaults to * ( all )
	**/
	public struct function uploadToTemp(
		required string input,
		required string mimeAccept="*"
	){
        var uploaded = "";
        var expandedStorageLocation = expandPath( mediaSettings.tempStorageLocation );

		if( !directoryExists( expandedStorageLocation ) ) {
			try {
				directoryCreate( expandedStorageLocation );
			} catch ( any ex ){
				// Another thread may have already created it, otherwise rethrow.
				if( !directoryExists( expandedStorageLocation ) ){
					rethrow;
				}
			}
		}

		try{
			if ( right( expandedStorageLocation, 1 ) != '/' ){
				expandedStorageLocation &= '/';
			}

			uploaded = fileUpload( expandedStorageLocation, arguments.input, arguments.mimeAccept , "makeunique" );

			//Return the full cffile object
			return uploaded;

		} catch( any e ){

			throw( "File upload to #expandedStorageLocation# failed.  There may be a problem with the permissions on the directory or the file input provided did contain a valid file type.<br/> The Message provided was:<br/>"&e.message );

		}
	}
	
}