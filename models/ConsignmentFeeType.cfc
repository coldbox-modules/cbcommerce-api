/**
* cboxCommerce Consignment Batch Fee Model
*/
component table="cbc_consignmentFeeTypes"  
        extends="BaseCBCommerceEntity"
        accessors="true"
        quick
{
    property name="name" type="string" default="";
    property name="description" type="string" default="";
    property name="displayOrder" type="numeric" default=0;

}