/**
* cboxCommerce Setting Entity
*/
component   table="cbc_deliveryMethods"
			extends="BaseCBCommerceEntity"
			accessors="true"
			quick
{
   property name="label" type="string";
   property name="description" type="string";

   property name="sortOrder" type="numeric" default=0;

   property name="isFlatRate" type="boolean" default=0 casts="BooleanCast@quick";
   property name="flatRateFee" type="numeric";

   property name="calculatorModel" type="string";

   this.memento = {
	   "defaultExcludes" : [ "calculatorModel" ]
   };

   function orders(){
	   return hasMany( "Order@cbCommerce", "FK_deliveryMethod" );
   }

   function shipments(){
	   return hasMany( "OrderShipment@cbCommerce", "FK_deliveryMethod" );
   }


   function calculateRate(
	   numeric weight,
	   numeric width,
	   numeric length,
	   numeric depth,
	   weightUnit="lbs",
	   measuringUnit="in"
	){
	   if( getIsFlatRate() ){
		  return getFlatRateFee();
	   } else if( !isNull( getCalculatorModel() ) ) {
		  raturn wirebox.getInstance( getCalculatorModel() ).calculate( argumentCollection=arguments );
	   } else {
		   throw( "There is no shipping rate calculation available for #getTitle()#" );
	   }
   }


}