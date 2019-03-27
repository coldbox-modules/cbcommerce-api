/**
* cbCommerce Unique User Validator
*/
component accessors="true" implements="cbvalidation.models.validators.IValidator" singleton{

   property name="userService" inject="UserService@cbCommerce";
   property name="auth" inject="AuthenticationService@cbAuth";
   
    UniqueUserValidator function init(){
        variables.name  = "UniqueUserValidator";
        return this;
    }

    /**
    * Will check if an incoming value validates
    * @validationResult.hint The result object of the validation
    * @target.hint The target object to validate on
    * @field.hint The field on the target object to validate on
    * @targetValue.hint The target value to validate
    * @validationData.hint The validation data the validator was created with
    */
    boolean function validate( required cbvalidation.models.result.IValidationResult validationResult, required any target, required string field, any targetValue, any validationData){

        var recordCount = userService.newEntity()
                                        .where( 'email', target.getEmail() )
                                        .where( 'id', '!=', target.keyValue() )
                                        .count();
        
        if( recordCount ){
            var errorArgs = {
				message 		= "A user with the email '#arguments.targetValue#' already exists in the database.",
				field 			= arguments.field,
				validationType 	= 'Unique',
				validationData	= arguments.validationData
			};
            validationResult.addError( validationResult.newError( argumentCollection=errorArgs ) );
            return false;
        } else {
            return true;
        }
    }
    
    /**
    * Get the name of the validator
    */
    string function getName() {
        return variables.name;
    }
}