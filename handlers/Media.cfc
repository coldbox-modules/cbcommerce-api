component{

    variables.imageFormats = ['jpg','jpeg','png','gif'];

    // /store/media/:path
    function deliver( event, rc, prc ){
        event.noLayout();

    	rc.id = listFirst( rc.path, "." );

    	//allow for file name-based scaling
    	if( listLen( rc.id, "_" ) > 1 ){
    		rc.dimensions = listLast( rc.id, "_" );
    		rc.id = listFirst( rc.id, "_" );
    	}

        prc.mediaItem = getInstance( "Media@cbCommerce" ).find( rc.id );

        if( isNull( prc.mediaItem ) || !fileExists( expandPath( prc.mediaItem.getFileLocation() ) ) ){
            rc.format="json";
        	return runEvent( event="cbCommerce:api.v1.BaseAPIHandler.routeNotFound", eventArgs=arguments, prePostExempt=true );
        }
        
        event.paramValue( "format", listLast( rc.path, "." ) );

    	var imageArgs = {};
        //handle our pixel argument (e.g. - 100x100)
        if( event.valueExists( 'dimensions' ) && findNoCase( "x", rc.dimensions ) ){

            imageArgs[ "width" ]  = listFirst( rc.dimensions,'x' );
            imageArgs[ "height" ] = listLast( rc.dimensions, 'x' );

        } else if( event.valueExists( 'dimensions' ) ){

            imageArgs[ "width" ] = rc.dimensions;
            imageArgs[ "height" ] = rc.dimensions;

        }

        //Image scaling and cropping to fit a specific height/width ( e.g. square )
        // alias for x=center&y=center
        if( event.valueExists( "fit" ) ){
            imageArgs[ "x" ] = "center";
            imageArgs[ "y" ] = "center";
        } else {
            imageArgs[ "x" ] = event.valueExists( "x" ) ? rc.x : javacast( "null", 0 );
            imageArgs[ "y" ] = event.valueExists( "y" ) ? rc.y : javacast( "null", 0 );
        }


        //we can use Coldbox's format detection to change the mimetype (e.g. - jpg to png)
        if( arrayContains( imageFormats , lcase( rc.format ) ) ){
            imageArgs[ 'mimeType' ] = 'image/' & lcase( rc.format );
        }

        //set our expiration to 30 days
        imageArgs[ 'expiration' ] = dateAdd('d',30,now());

        writeToBrowser( arguments, imageArgs );

    }

    function writeToBrowser( eventArgs, imageArgs ) {
    	
    	eventArgs.event.noRender();
        
        var media = eventArgs.prc.mediaItem;

        if( structKeyExists( imageArgs, "mimeType" ) && listFirst( imageArgs.mimeType, "/" ) == 'image' && structKeyExists( imageArgs, "width" ) ){

        	var mediaPath = media.getVariation( argumentCollection=imageArgs );
        
        } else {
        
        	var mediaPath = expandPath( media.getFileLocation() );
        
        }

        eventArgs.event.setHTTPHeader( name="cache-control", value="max-age=86400" );

        eventArgs.event.sendFile( 
        	file=mediaPath, 
        	disposition=( media.isImage() || media.isPDF() ) ? 'inline' : 'attachment' 
        );
	        
    }
}