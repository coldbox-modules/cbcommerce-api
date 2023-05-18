/**
* A cool Customer entity
*/
component quick table="cbc_users" extends="BaseCBCommerceEntity" accessors="true"{
    property name="encryptionService" inject="EncryptionService@cbCommerce" persistent="false";

    // Persistent column properties
    property name="firstName";
    property name="lastName";
    property name="email";
    property name="password";
    property name="primaryPhone";
    property name="secondaryPhone";
    property name="resetToken";

    property name="_normalizedPermissions" persistent="false";

	function instanceReady(){
		arrayAppend(
			this.memento.defaultIncludes,
			[
				"fullName"
			],
			true
		);

		this.memento.neverInclude=["password"];
		this.memento.defaults = {
			"id" : "",
			"firstName" : "",
			"lastName" : "",
			"primaryPhone" : "",
			"secondaryPhone" : "",
			"email" : ""
		};
	}

    function addresses(){
        return hasMany( "CustomerAddress@cbCommerce", "FK_user" );
    }

    function roles(){
        return belongsToMany( "UserRole@cbCommerce" , "cbc_lookups_users_roles", "FK_user", "FK_user_role" );
    }

    function explicitPermissions(){
        return belongsToMany( "UserPermission@cbCommerce" , "cbc_lookups_users_explicitPermissions", "FK_user", "FK_permission" );
    }

    function carts(){
        return hasMany( "Cart@cbCommerce", "FK_user" );
    }

    function orders(){
        return hasMany( "Order@cbCommerce", "FK_user" );
    }

    function setPassword( value ) {
        return assignAttribute( "password", encryptionService.bCrypt( value ) );
    }

    function getFullName(){
        return this.getFirstName() & " " & this.getLastName();
    }

    this.constraints = {
		firstName : { required : true },
        password : { required : true },
        email : { required : true, validator : "cbCommerce.models.validators.UniqueUserValidator" }
	};

	function delete(){
		this.getCarts().each( function( cart ){ cart.delete() } );
		this.getAddresses().each( function( addr ){ addr.delete() } );
		this.roles().sync( [] );
		this.explicitPermissions().sync( [] );
		return super.delete();
	}

    function hasPermission( permission ){
      if( !isLoaded() ) return false;
      if( this.isInRole( "Administrator" ) ) return true;
      var hasPermission = false;
      this.getNormalizedPermissions().each( function( perm ){
        if( perm == permission ) hasPermission = true;
      } );
      return hasPermission;
    }

    function isInRole( role ){
        if( !isLoaded() ) return false;
        var inRole = false;
        this.getRoles().each( function( userRole ){
            if( userRole.getName() == role ){
                inRole = true;
            }
        } );
        return inRole;
    }

    function getNormalizedPermissions(){
        if( isNull( variables._normalizedPermissions ) ){
            var permissions = [];
			if( isInRole( "Administrator" ) ){
				permissions = variables._wirebox.getInstance( "UserPermission@cbCommerce" )
										.newQuery()
										.select( [ "prefix", "suffix" ] )
										.get()
										.map( function( perm ){
											if( isInstanceOf( perm, "UserPermission" ) ){
												perm = perm.getMemento();
											}
											var item = [ perm[ "prefix" ], perm[ "suffix" ] ];
											return item.toList( ":" );
										} );
			} else {
				this.getRoles().each( function( role ){
					role.getPermissions().each( function( permission ){
						arrayAppend( permissions, permission.getPrefix() & ":" & permission.getSuffix() );
					} );
				} );

				this.getExplicitPermissions().each( function (permission ){
					arrayAppend( permissions, permission.getPrefix() & ":" & permission.getSuffix() );
				} );
			}

            variables._normalizedPermissions = [];
            variables._normalizedPermissions.addAll(
                createObject("java", "java.util.HashSet").init( permissions )
            );
        }

        return variables._normalizedPermissions;
    }

    function filterSearch(
		required struct searchCollection,
        required QueryBuilder builder
    ){

        if( structKeyExists( searchCollection, "search" ) && len( searchCollection.search ) ){
            builder.where(
                        "firstName",
                        "like",
                        searchCollection.search
                    ).orWhere(
                        "lastName",
                        "like",
                        searchCollection.search
                    );
        }

        if( structKeyExists( searchCollection, "role" ) && searchCollection.role != "all" ){
            builder.join( "cbc_lookups_users_roles", "FK_user", "=", "cbc_users.id" )
                    .join( "cbc_userRoles", "cbc_userRoles.id", "=", "cbc_lookups_users_roles.FK_user_role" )
                    .where( "cbc_userRoles.name", searchCollection.role );
        }

    }

	function getJwtCustomClaims(){
		return getMemento(
			includes=this.isLoaded() ? [ "roles" ] : []
		);
	}

	function getJwtScopes(){
		return this.isLoaded() ? getNormalizedPermissions() : [];
	}

}

