/**
* 
* CBox Commerce Cart Model
* @author Jon Clausen <jclausen@ortussolutions.com>
**/
component table="cbc_carts"
            extends="BaseCBCommerceEntity" 
            accessors="true"
            quick 
{
   property name="contents";
   property name="audit";
  
   function init(){
       super.init();
       variables.contents = serializeJSON(
           {
               "items" : [],
           }
       );
       variables.audit = serializeJSON( [] );
   }

   function customer(){
   		return belongsTo( "User@cbc", "FK_user" );
   }

   function order(){
   		return belongsTo( "Order@cbc", "FK_order" );
   }

   /**
    * Overloads to property accessors to serialize and deserialize the JSON values
    */
   public struct function getContents(){
        return deserializeJSON( variables.contents );
   }

   public Cart function setContents( required struct newContents ){
       variables.contents = serializeJSON( newContents );
       return this;
   }

   public array function getAudit(){
        return deserializeJSON( variables.audit );
   }

   public Cart function setAudit( required array newAudit ){
       variables.audit = serializeJSON( newAudit );
       return this;
   }


	
}

