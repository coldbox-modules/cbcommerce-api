/**
* A collection of date formatting helper methods
* @author Jon Clausen <jclausen@ortussolutions.com>
**/
component singleton{
	
	function toISO8601( required date dateInput ){

		var formattedDate = dateFormat( arguments.dateInput, "yyyy-mm-dd" ) & "T" & timeFormat( arguments.dateInput, "HH:mm:ssXXX" );

		// Dates coming out of the database are automatically at UTC and contain no timzeone info.  We need to reset it to the `0` value
		if( right( formattedDate, 2 ) == "+Z" ){
			formattedDate = replaceNoCase( formattedDate, "+Z", "+00:00" );
		} else if( right( formattedDate, 1 ) == 'Z' ){
			formattedDate = replaceNoCase( formattedDate, "Z", "+00:00" );
		// If timezone information was not found in the formatted date ( Lucee doesn't handled "XXX" ), assume local time zone offset			
		} else if( right( formattedDate, 3 ) == "XXX" ){
			
			var utcOffset = getTimeZoneInfo().UTCTotalOffset;

			formattedDate = left( formattedDate, len( formattedDate ) - 3 ) 
							& 
							timeFormat( 
								utcOffset,  
								( UTCOffset < 0 ? "-" : "+" ) & "HH:mm" 
							);
		}

		return formattedDate;
	}

	function stripTimezoneOffset( required string ISODate ){
		if( right( ISODate, 1 ) == 'Z' ){
			return left( ISODate, len(ISODate)-1 );
		}
		var dateParts = listToArray( ISODate, "+" );
		if( arraylen( dateParts ) == 1 ){
			var dateParts = listToArray( ISODate, "-" );
		}

		//if our date parts array is longer than two items, something is wonk and we return the original string 
		if( arrayLen( dateParts ) == 2 ){
			return dateParts[ 1 ];
		} else {
			return arguments.ISODate;
		}


	}

}