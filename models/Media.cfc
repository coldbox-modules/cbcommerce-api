/**
* cboxCommerce Media Entity
*/
component   table="cbc_media" 
			extends="quick.models.BaseEntity" 
			accessors="true"
			quick
{ 
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
	
}