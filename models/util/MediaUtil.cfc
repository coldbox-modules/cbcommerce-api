/**
 *
 * @displayname Media Utility
 * @package cbCommerce.models.util
 * @description This is a collection of static helpers for manipulating, inspecting and grouping media
 * @author Jon Clausen <jclausen@ortussolutions.com>
 *
 **/
component accessors="true" singleton{

    property name="identifier";
    property name="source";
    property name="mimeList";
    property name="mimeGroups";
    property name="mimeExts";
    property name="knownExts";
    property name="imageMimeTypes";

    function init( identifier = "id", source = "uploadFileName" ) {
        variables.identifier = arguments.identifier;
        variables.source = arguments.source;
        variables[ "mimeList" ] = [
            { group: 'images',      extensions: "jpeg jpg", contentType: "image/jpeg" },
            { group: 'images',      extensions: "png",      contentType: "image/png" },
            { group: 'images',      extensions: "bmp",      contentType: "image/x-ms-bmp" },
            { group: 'images',      extensions: "bmp",      contentType: "image/bmp" },
            { group: 'images',      extensions: "tiff tif", contentType: "image/tiff" },
            { group: 'images',      extensions: "gif",      contentType: "image/gif" },
            { group: 'documents',   extensions: "doc",      contentType: "application/msword" },
            { group: 'documents',   extensions: "docx",     contentType: "application/vnd.openxmlformats-officedocument.wordprocessingml.document" },
            { group: 'documents',   extensions: "xls",      contentType: "application/vnd.ms-excel" },
            { group: 'documents',   extensions: "xlsx",     contentType: "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet" },
            { group: 'documents',   extensions: "ppt",      contentType: "application/vnd.ms-powerpoint" },
            { group: 'documents',   extensions: "pptx",     contentType: "application/vnd.openxmlformats-officedocument.presenationml.presentation" },
            { group: 'documents',   extensions: "txt",      contentType: "text/plain" },
            { group: 'documents',   extensions: "pdf",      contentType: "application/pdf" },
            { group: 'documents',   extensions: "html htm", contentType: "text/html" },
            { group: 'documents',   extensions: "clog",     contentType: "application/clog" },
            { group: 'documents',   extensions: "pbb",      contentType: "application/octet-stream" },
            { group: 'documents',   extensions: "sms",      contentType: "application/octet-stream" },
            { group: 'documents',   extensions: "cal",      contentType: "application/cal" },
            { group: 'documents',   extensions: "xml",      contentType: "application/xml" },
            { group: 'documents',   extensions: "zip",      contentType: "application/zip" },
            { group: 'documents',   extensions: "amv",      contentType: "multipart/form-data" },
            { group: 'audio',       extensions: "mid",      contentType: "audio/midi" },
            { group: 'audio',       extensions: "mp3",      contentType: "audio/mpeg" },
            { group: 'audio',       extensions: "amr",      contentType: "audio/amr" },
            { group: 'audio',       extensions: "qcp",      contentType: "audio/x-sd2" },
            { group: 'audio',       extensions: "wav",      contentType: "audio/x-wav" },
            { group: 'audio',       extensions: "wma",      contentType: "audio/x-ms-wm" },
            { group: 'audio',       extensions: "m4a",      contentType: "audio/m4a" },
            { group: 'audio',       extensions: "m4b",      contentType: "audio/m4b" },
            { group: 'audio',       extensions: "m4p",      contentType: "audio/m4p" },
            { group: 'video',       extensions: "mp4",      contentType: "video/mp4" },
            { group: 'video',       extensions: "3g2",      contentType: "video/3gpp2" },
            { group: 'video',       extensions: "mpeg",     contentType: "video/mpeg" },
            { group: 'video',       extensions: "wmv",      contentType: "video/x-ms-wmv" },
            { group: 'video',       extensions: "3gp",      contentType: "video/3gpp" },
            { group: 'video',       extensions: "avi",      contentType: "video/x-msvideo" },
            { group: 'other',       extensions: javacast( "null", 0),       contentType: "" }
        ];

        variables[ "mimeGroups" ] = arrayReduce( variables.mimeList, function( acc, cur ){
            if ( arrayFind( acc, function( group ) { return compareNoCase(group, cur.group) == 0; }  ) < 1 ){
                arrayAppend( acc, cur.group );
            }
            return acc;
        }, [] );

        variables["mimesExts"] = arrayReduce( variables.mimeGroups, function(oacc, ocur, index, array ){
            oacc[ ocur ] = mimesExtsItemReduce( ocur );
            return oacc;
        }, {} );

        variables["knownExts"] = arrayReduce( variables.mimeList, function( acc, cur ){
                if ( structKeyExists( cur, "extensions" ) ){
                    for( elem in listToArray( cur.extensions, " ")){
                        if ( len( trim( elem ) ) > 0 ){
                            arrayAppend( acc, lcase(trim( elem ) ) );
                        }
                    }
                }
                arraySort( acc, "text");
                return acc;
            }, [] );

        variables[ "imageMimeTypes" ] = arrayReduce( 
            variables.mimeList, 
            function( list, definition ){
                if ( definition.group == 'images' ){
                    arrayAppend( list, definition.contentType );
                }
                return list;
            }, 
            [] 
        );

        return this;
    }

    /**
    *
    * @dataSet  The array to reduce
    *
    * @returns  The processed resource ids and associated map.
    */
    function buildMediaGroup( dataSet ) {

        if ( ! isArray( dataSet ) ) {
            return dataSet;
        }

        var ids = [];
        var map = {};
        for ( var item in dataSet ) {

            if( isStruct( item ) && structKeyExists( item, identifier ) ){
                var id = item[ identifier ];
            } else {
                var id = invoke(item, "get" & identifier);
            }
            arrayAppend( ids, id );
            map[ id ] = item;
        }

        return arrayReduce( variables.mimeGroups, function( acc, cur ){
            var groupMatches = mimeType( dataSet, cur );
            if ( arrayLen( groupMatches ) > 0 ){
                acc[ cur ] = {
                    name: cur,
                    items: groupMatches
                };
                arrayAppend( acc.groups, cur );
            }
            return acc;
        }, {
            groups: [],
            resultset: {
                "results" = ids,
                "resultsMap" = map
            }
        });
    }

    public function mimesExtsItemReduce( ocur ){
        return arrayReduce( variables.mimeList, function(acc, cur, iindex, iarray){
            if ( structKeyExists( cur, "extensions" ) && compareNoCase( cur.group, ocur ) == 0 ){
                for( elem in listToArray( cur.extensions, " " ) ){
                   if ( len( trim( elem ) ) > 0 ){
                        arrayAppend( acc, lcase(trim( elem ) ) );
                    }
                }
            }
            arraySort( acc, "text");
            return acc;
        }, []  );
    }

    public function mimeType( data, group ) {

        if ( isNull(group) ||
             arrayFind( variables.mimeGroups, function( cur ) { return compareNoCase(group, cur) == 0; }  ) < 1 ||
             ! structKeyExists( variables.mimesExts, group) ){
            return [];
        }
        var gres = arrayReduce( data, function(acc, cur){
            var exts = mimesExts[ group ];
            if( isStruct( cur ) && structKeyExists( cur, source ) ){
                var ext = lcase( listLast( cur[ source ], "." ) );
            } else {
                var ext = lcase( listLast( invoke( cur, "get" & source ), '.' ) );
            }
            if ( arrayLen( exts ) > 0 ) {
                if( arrayFind( exts, function( iext ) { return compareNoCase(iext, ext) == 0; }  ) > 0 ){
                    arrayAppend( acc, cur );
                }
            } else {
                if ( arrayFind( knownExts, function( iext ) { return compareNoCase(iext, ext) == 0; }  ) < 1 ){
                    arrayAppend( acc, cur );
                }
            }
            return acc;
        }, [] );
        return gres;
    }

    public function mimeTypeFromResultsMap( resultsSet, group ) {
        if ( isNull( resultsSet ) ||
            ! structKeyExists( resultsSet, "results" ) ||
            ! structKeyExists( resultsSet, "resultsMap" ) ){
            return [];
        }
        if ( isNull(group) ||
             arrayFind( variables.mimeGroups, function( cur ) { return compareNoCase(group, cur) == 0; }  ) < 1 ||
             ! structKeyExists( variables.mimesExts, group) ){
            return [];
        }
        var gres = arrayReduce( resultsSet.results, function(acc, id){
            var cur = resultsSet.resultsMap[ id ];
            var exts = mimesExts[ group ];
            var ext = lcase( listLast( cur.src, '.' ) );
            if ( arrayLen( exts ) > 0 ) {
                if( arrayFind( exts, function( iext ) { return compareNoCase(iext, ext) == 0; }  ) > 0 ){
                    arrayAppend( acc, cur[ variables.identifier ] );
                }
            } else {
                if ( arrayFind( knownExts, function( iext ) { return compareNoCase(iext, ext) == 0; }  ) < 1 ){
                    arrayAppend( acc, cur[ variables.identifier ] );
                }
            }
            return acc;
        }, [] );
        arraySort( gres, function( idA, idB ){
            var doA = structKeyExists( resultsSet.resultsMap[ idA ], "displayOrder" ) && resultsSet.resultsMap[ idA ].displayOrder > 0 ? resultsSet.resultsMap[ idA ].displayOrder : 50000;
            var doB = structKeyExists( resultsSet.resultsMap[ idB ], "displayOrder" ) && resultsSet.resultsMap[ idA ].displayOrder > 0 ? resultsSet.resultsMap[ idB ].displayOrder : 50000;
            return doA - doB;
        } );
        return gres;
    }

	public function isImage( fileName ){
        var ext = lcase( listLast( fileName, "." ) );

        matchedImageTypes = arrayFilter( 
            variables.mimeList, 
            function( definition ){
                return definition.group == 'images' && listContains( definition.extensions, ext, ' ' );
            } 
        );

        return javacast( "boolean", arrayLen( matchedImageTypes ) );
	}

}