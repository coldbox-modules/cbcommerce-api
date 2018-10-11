/**
 *
 * @displayname Encryption Service for cbCommerce
 * @package cbCommerce.models.services
 * @description This is a encryption Service Model
 * @author Jon Clausen <jclausen@ortussolutions.com>
 *
 **/
component singleton
{
	property name="bCrypt" inject="BCrypt@BCrypt";
	property name="encryptAlgorithm";
    property name="encryptEncode";

	/**
	 * Constructor
	 */
	EncryptionService function init(){
		variables.encryptAlgorithm = "BLOWFISH";
		variables.encryptEncode = "HEX";
		return this;
	}
	
	/**
    * bCrypt
    * @value the value to encrypt
	*/
    function bCrypt( string value ){
    
        return variables.bCrypt.hashPassword( arguments.value );
    
    }

	/**
    * bCryptMatches
    * @provided the provided raw string
    * @stored the stored encrypted value
	*/
    function bCryptMatches( string provided,string stored ){
    	try{
	    	//Note: BCrypt needs to stay a transient or strange things happen
	        return variables.bCrypt.checkPassword( provided,stored );
    	} catch( "java.lang.IllegalArgumentException" e ){
    		return false;
    	}
    }


    /**
    * Creates a generic token
    * @encryptionKey 	string 		If provided, the token will be encrypted before being returned
    **/
    function createGenericToken( string encryptionKey ){
    	//create a simple token from a UUID
    	var tokenBase = lcase( replace( createUUID(), "-", "", "ALL" ) );

    	if( !isNull( encryptionKey ) ){
    	
    		return encrypt( tokenBase, arguments.encryptionKey , variables.encryptAlgorithm, variables.encryptEncode );
    	
    	} else {

    		return tokenBase;
    	
    	}
    }

    /**
    * Encrypts a string using the default agorithm
    * 
    * @value  string          The value to encrypt
    * @key    string          The encryption key
    * 
    **/
    function encryptValue(
        required string value, 
        required string key
    ){
        return encrypt( arguments.value, arguments.key, variables.encryptAlgorithm, variables.encryptEncode );
    }


    /**
    * Decrypts an encrypted string, when provided the string and key
    * 
    * @encryptedString 	string 			The previously encrypted value
    * @encryptionKey 	string 			The key used to decrypt
    * @throwOnError 	boolean=false 	Whether to throw on a decryption error
    * 
    **/
    function getDecryptedValue( 
    	required string encryptedString, 
    	required string encryptionKey,
    	required boolean throwOnError=false 
    ){
    	try{
    	
    		return decrypt( arguments.encryptedString, arguments.encryptionKey , variables.encryptAlgorithm, variables.encryptEncode );
    	
    	} catch( any e ){
    		
    		if( arguments.throwOnError ){
    		
    			rethrow;
    		
    		} else{

    			return arguments.encryptedString;
    		
    		}

    		return arguments.encryptedString;
    	}
    }


}