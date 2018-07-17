/**
* 
* CBox Commerce Cart Model
* @author Jon Clausen <jclausen@ortussolutions.com>
**/
component quick table="cbc_carts" extends="quick.models.BaseEntity" accessors="true"{
    property name="keyType" inject="UUID@quick" persistent="false";
    
    // Persistent column properties

   property name="isActive";
   property name="createdTime";
   property name="modifiedTime";
   property name="contents";
   property name="audit";

   function customer(){
   		return belongsTo( "Customer", "FK_customer" );
   }

   function order(){
   		return belongsTo( "Order", "FK_order" );
   }
	
}

