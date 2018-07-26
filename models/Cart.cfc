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

   function customer(){
   		return belongsTo( "User", "FK_user" );
   }

   function order(){
   		return belongsTo( "Order", "FK_order" );
   }
	
}

