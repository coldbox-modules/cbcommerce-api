/**
* 
* CBox Commerce Cart Model
* @author Jon Clausen <jclausen@ortussolutions.com>
**/
component quick table="cboxCommerce_carts"{
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

   variables.up = "


   ";
   customer_id bigint,
   order_id bigint,
   storage_key character varying (200),
   contents text,
   audit text,
   active smallint NOT NULL DEFAULT 1,

	
}

