/**
* cboxCommerce Media Entity
*/
component   table="cbc_media" 
			extends="BaseCBCommerceEntity" 
			accessors="true"
			quick
{ 
	property name="mediaSettings" inject="coldbox:setting:media@cbCommerce" persistent="false";
	property name="mediaUtil" inject="MediaUtil@cbCommerce" persistent="false";
	property name="jLoader" inject="loader@cbjavaloader" persistent="false";
    // Persistent column properties
	property name="designation" type="string" default="product";
	property name="title" type="string" default="";
	property name="caption" type="string" default="";
	property name="originalFileName" type="string";
	property name="fileLocation" type="string";
	property name="fileSizeBytes" type="string";

	function url(){
		var extension = listLast( getFileLocation(), "." );
		return "/store/media/" & keyValue() & "." & extension;
	}

		/**
	* Set our file from a path
	* @fileInput string 			The name of an input field to load the file from
	* @filePath string 				An existing physical path to a file
	* @pathExtension string 		An exension to append to the shared storage directory
	* @chainable
	**/
	public Media function loadFile(
		string fileInput,
		string filePath,
		string pathExtension = "products",
		string mimeAccept = "*"
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

		setOriginalFileName( listLast( tmpFile.clientFile, "/" ) );

		var fileExtension = tmpFile.clientFileExt;

		var identifier = variables.id;

		var fileName = identifier & "." & lcase( fileExtension );

		var fileDestination = filesDirectory & "/" & fileName;

		//move the file to its new home
		if( !isNull( arguments.fileInput ) ){
			fileMove( tmpFile.serverDirectory & "/" & tmpfile.clientFile , fileDestination );
		} else {
			fileCopy( tmpFile.serverDirectory & "/" & tmpfile.clientFile , fileDestination );
		}

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

	// Media delivery and manipulation functions
	public function isImage(){
		if( fileExists( expandPath( getFileLocation() ) ) ) {
			return MediaUtil.isImage( getOriginalFileName() );
		}
		else {
			log.error(
					"Media Location Not Found: #expandPath( getFileLocation() )#"
			);
			return false;
		}
	}

	public function isPDF(){
		if( fileExists( expandPath( getFileLocation() ) )) {
			return findNoCase( "pdf", fileGetMimeType( expandPath( getFileLocation() ) ) );
		}
		else {
			log.error(
					"Media Location Not Found: #expandPath( getFileLocation() )#"
			);
			return false;
		}
	}



	/**
	* Returns the Java file output stream for the file object, which may be used for advanced operations
	**/
	public function getFileInputStream(){

		var mediaPath = expandPath( getFileLocation() );


		var fileInputStream = createObject(
								"java",
								"java.io.FileInputStream"
								).init(
									javacast( "string", mediaPath )
								);

		return fileInputStream;
		
	}

	/**
	* Image-manipulation functions
	* @param numeric width 			The maximum width of the image
	* @param numeric height 		The maximum height of the image
	* @param any x				    The x offset from the upper left corner to crop the image or "center"
	* @param any y				    The y offset from the upper left corner to crop the image or "center"
	* @param string mimeType 		The mimetype to serve the image - will convert the original mime type to the destination (e.g. - jpg to png)
	**/

	public string function getVariation( numeric width, numeric height, any x=0, any y=0, mimeType ){

		if ( ! this.isImage( getFileLocation() ) ){
			return expandPath( getFileLocation() );
		}

		if( isNull( arguments.mimeType ) ){
			arguments.mimeType = fileGetMimeType( expandPath( getFileLocation() ) );
		}

		var ext = listLast( arguments.mimeType, "/" );

		var filePath = expandPath( getFileLocation() );
		var variationName = keyValue() & "_" & width & "x" & height & '_x' & x & '_y' & y  & "." & ext;
		var filesDirectory = getDirectoryFromPath( filePath );
		var variationsDirectory = filesDirectory & "variations";
		var variationPath = variationsDirectory & "/" & variationName;

		if( !fileExists( variationPath ) ){

			if( !directoryExists( variationsDirectory ) ) {
				try {
					directoryCreate( variationsDirectory );
				} catch ( any ex ){
					// Another thread may have already created it, otherwise rethrow.
					if( !directoryExists( variationsDirectory ) ){
						rethrow;
					}
				}
			}

			var ImageIO = getImageObject( argumentCollection=arguments );

			ImageIO.saveAs( variationPath );

		}

		return variationPath;

	}

	
	/**
	* Returns a native CFML Image (e.g. "<cfimage>" ) from the file
	*
	* @param numeric width 		The maximum width of the image
	* @param numeric height 	The maximum height of the image
	* @param any x			The x offset from the upper left corner to crop the image or "center"
	* @param any y			The y offset from the upper left corner to crop the image or "center"
	**/
	public any function getCFImage(numeric width, numeric height, any x=0, any y=0) {
		return imageNew( getBufferedImage( argumentCollection=arguments ) );
	}

	/**
	* Returns a javaxt.io.Image object from the file
	* Documentation http://www.javaxt.com/documentation/?jar=javaxt-core&package=javaxt.io&class=Image
	*
	* @param numeric width 		The maximum width of the image
	* @param numeric height 	The maximum height of the image
	* @param any x			The x offset from the upper left corner of the original image for the crop or "center" (will be recalulated to the new scale)
	* @param any y			The y offset from the upper left corner of the original image for the crop or "center" (will be recalulated to the new scale)
	**/
	public any function getImageObject(numeric width, numeric height, any x=0, any y=0){
		var ImageIO = jLoader.create( "javaxt.io.Image" ).init( getFileInputStream() );
		ImageIO.setOutputQuality( javacast( "double", 1 ) );
		var originalHeight = ImageIO.getHeight();
		var originalWidth = ImageIO.getWidth();

		if(arguments.x != 0 && arguments.y !=0){
			scaleAndCropToFit( ImageIO, arguments );
		} else if( !isNull( width ) && !isNull( height ) && arguments.height == arguments.width ) {
			
			if( originalHeight > originalWidth ){
				ImageIO.setHeight( arguments.height );
			} else {
				ImageIO.setWidth( arguments.width );
			}

		} else {
			if( !isNull( arguments.height ) ) ImageIO.setHeight( arguments.height );
			if( !isNull( arguments.width ) ) ImageIO.setWidth( arguments.width );
		}

		return ImageIO;
	}

	/**
	* Returns the buffered image object for accessing the raw pixels of an image
	*
	* @param numeric width 		The maximum width of the image
	* @param numeric height 	The maximum height of the image
	* @param any x			    The x offset from the upper left corner to crop the image or "center"
	* @param any y			    The y offset from the upper left corner to crop the image or "center"
	* @rebuffer 			    [ true ] Whether or not to rebuffer if on OpenJDK
	**/
	public function getBufferedImage( numeric width, numeric height, any x=0, any y=0, rebuffer=true ){
		var imageObj = getImageObject( argumentCollection=arguments );
		var system = createObject( "java", "java.lang.System" );
		var bufferedImage = imageObj.getBufferedImage();

		if( !arguments.rebuffer || !findNoCase( "openjdk", system.getProperty( "java.runtime.name" ) ) ) {
			return bufferedImage;
		} else {
			//we need to run this conversion for OpenJDK instances and JPG writing
			var reBufferedImage = createObject( "java", "java.awt.image.BufferedImage" ).init( imageObj.getWidth(), imageObj.getHeight(), bufferedImage.TYPE_3BYTE_BGR );
			reBufferedImage.getGraphics().drawImage( bufferedImage, javacast( "int", 0 ), javacast( "int", 0 ), javacast( "null", 0 ) );
			reBufferedImage.getGraphics().dispose();
			return reBufferedImage;
		}

	}

	/**
	* Returns the Buffered Image 2DGraphics object
	*
	* @param numeric width 		The maximum width of the image
	* @param numeric height 	The maximum height of the image
	* @param any x			The x offset from the upper left corner to crop the image or "center"
	* @param any y			The y offset from the upper left corner to crop the image or "center"
	**/
	public function getImageGraphics( numeric width, numeric height, any x=0, any y=0 ){
		return getBufferedImage( argumentCollection=arguments ).getGraphics();
	}

	/**
	* Scale an image and crop to fit dimensions
	* @param javaxt.io.Image Img 	The Image object to be manipulated
	* @param string imageArgs 		The standard sizing and image options (e.g. - {width:100,height:100,x:100,y:100}) see getImageObject() for additional information
	**/
	public any function scaleAndCropToFit(required Img,required struct imageArgs){
		var originalWidth = Img.getWidth();
		var originalHeight = Img.getHeight();
		var destWidth = imageArgs.width;
		var destHeight = imageArgs.height;

		//Scale down our image proportionally to the largest size necessary
		if(destHeight > destWidth){
			Img.setWidth(destHeight);
		} else if (destWidth > destHeight) {
			Img.setHeight(destWidth);
		} else if(originalHeight > originalWidth){
			Img.setWidth(destHeight);
		} else {
			Img.setHeight(destWidth);
		}

		//calculate our differentials
		var diffWidth = Img.getWidth()/originalWidth;
		var diffHeight = Img.getHeight()/originalHeight;

		//recalculate all of our crop boundaries
		if(isNumeric(imageArgs.x) && isNumeric(imageArgs.y) ){
			imageArgs.x = diffWidth*imageArgs.x;
			imageArgs.y = diffHeight*imageArgs.y;
		}

		//check for our "center" x/y args
		if(imageArgs.x == 'center'){
			imageArgs.x = (Img.getWidth()/2)-(destWidth/2);
		}
		if(imageArgs.y == 'center'){
			imageArgs.y = (Img.getHeight()/2)-(destHeight/2);
		}

		return Img.crop(imageArgs.x,imageArgs.y,destWidth,destHeight);
	}
	
}