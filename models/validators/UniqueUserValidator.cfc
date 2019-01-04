/**
* cbCommerce Unique User Validator
*/
component accessors="true" implements="cbvalidation.models.validators.IValidator" singleton{

   property name="userService" inject="UserService@cbCommerce";
   
    UniqueUserValidator function init(){
        variables.name        = "UniqueUserValidator";
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
    boolean function validate(required cbvalidation.models.result.IValidationResult validationResult, required any target, required string field, any targetValue, any validationData){

        var recordCount = userService.newEntity().where( 'email', target.getEmail() ).count();
        
        if( recordCount ){
            validationResult.addError( validationResult.newError(argumentCollection=arguments) );
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