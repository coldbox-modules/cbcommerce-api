/**
* A cool Customer entity
*/
component quick table="cbc_customerAddresses"extends="BaseCBCommerceEntity" accessors="true"{

    property name="address1" default="";
    property name="address2" default="";
    property name="city" default="";
    property name="province" default="";
    property name="postalCode" default="";
    property name="country" default="";

    function customer(){
        return belongsTo( "User@cbc", "FK_user" );
    }
   
}

