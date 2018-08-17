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
   		return belongsTo( "User@cbc", "FK_user" );
   }

   function order(){
   		return belongsTo( "Order@cbc", "FK_order" );
   }
	
}

