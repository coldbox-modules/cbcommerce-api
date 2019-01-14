/**
* A cool Customer entity
*/
component quick table="cbc_customerAddresses"extends="BaseCBCommerceEntity" accessors="true"{

	property name="address1" default="" type="string";
    property name="address2" default="" type="string";
    property name="city" default="" type="string";
    property name="province" default="" type="string";
    property name="postalCode" default="" type="string";
    property name="country" default="USA" type="string";
    property name="designation" default="" type="string";
    property name="fullName" default="" type="string";
    property name="FK_user" type="string";

    function customer(){
        return belongsTo( "User@cbCommerce", "FK_user" );
    }

}