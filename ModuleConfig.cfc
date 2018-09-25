component {
    
    this.name = "cbox-commerce";
    this.author = "Jon Clausen <jclausen@ortussolutions.com>";
    this.webUrl = "https://github.com/jclausen/cbox-commerce";
    this.dependencies = [ "quick", "cfmigrations", "cffractal", "cbstorages", "BCrypt", "cbsecurity" ];
    this.cfmapping = "cbc";
    this.modelNamespace	= "cbc";
    this.entryPoint = "cbox-commerce";

    function configure() {
        settings = {
            "products" : {
                // Allows for the configuration of an external products model, to interface with existing databases 
                "externalModel" : false,
                "externalModelBinding" : "",
                "externalModelMapping" : {},
                "defaultCurrency" : "USD"
            },
            "media" : {
                //local or s3 storage currently supported
                "driver" : getEnv( 'CBC_MEDIA_DRIVER', 'local' ),
                // for local drivers, this would be the path from the root of the site
                "storageLocation" : "/includes/shared/cbc",
                // Only used for s3 driver
                "s3" : {
                    "key" : getEnv('AWS_ACCESS_KEY_ID', ''),
                    "secret" : getEnv('AWS_SECRET_ACCESS_KEY', ''),
                    "region" : getEnv('AWS_DEFAULT_REGION', ''),
                    "bucket" : getEnv('AWS_BUCKET', ''),
                    // the AWS base URL for serving assets ( e.g. cloudflare )
                    "url" : getEnv('AWS_URL', ''),
                },
                //the security service - may be changed to use a different wirebox mapping ( e.g. - ContentBox )
                "securityService" : "SecurityService@cbc"
            },
            "payments" : {
                "processor" : {
                    "default" : "StripeProcessor@cbc",
                    "credentials" : {
                        //credentials will vary, depending on the implmented processor
                    }
                }
            }
        };

        // Custom Declared Interceptors
		interceptors = [
			{  
					class="cbc.interceptors.CBCQuickEntity",
					name="CBCQuickEntityInterceptor"
			}
        ];
        
        // API Routing
        router
            .resources( 
                route   = "api/v1/products",
                handler = "API.v1.Photos"
            )
            .resources(
                route   = "api/v1/cart",
                handler = "API.v1.Cart"   
            )
            .resources(
                route   = "api/v1/orders",
                handler = "API.v1.Cart"
            )
            .resources(
                route   = "api/v1/customers",
                handler = "API.v1.Customers"
            )
            .resources(
                route   = "api/v1/payments",
                handler = "API.v1.Payments"
            )
            .resources(
                route = "api/v1/skus",
                handler = "API.v1.ProductSKUs"
            );
    }

    function onLoad() {
        //change our binder mapping 
        if( settings.products.externalModel ){
            binder
                .map( 
                    alias = "ExternalProduct@cbc", 
                    force = true 
                ).to( settings.products.externalModelMapping );
        }
    }
}