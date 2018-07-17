component {
    
    this.name = "cbox-commerce";
    this.author = "Jon Clausen <jclausen@ortussolutions.com>";
    this.webUrl = "https://github.com/jclausen/cbox-commerce";
    this.dependencies = [ "quick", "cfmigrations" ];
    this.cfmapping = "cbc";
    this.entryPoint = "cbox-commerce";


    private function getEnv( required string name, any defaultValue ){

    }

    function configure() {
        settings = {
            "products" : {
                // Allows for the configuration of an external products model, to interface with existing databases 
                "externalModel" : false,
                "externalModelMapping" : "",
                "externalSKU" : false,
                "externalSKUMapping": "",
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
                }

            }
            "payments" : {
                "processor" : {
                    "default" : "StripeProcessor@cbc",
                    "credentials" : {
                        //credentials will vary, depending on the implmented processor
                    }
                }
            }
        };

    }

    function onLoad() {
        //change our binder mapping 
        if( settings.products.externalModel ){
            binder
                .map( 
                    alias = "Product@cbc", 
                    force = true 
                ).to( settings.products.externalModelMapping );
        }
        if( settings.products.externalSKU ){
            binder
                .map( 
                    alias = "ProductSKU@cbc", 
                    force = true 
                ).to( settings.products.externalSKUMapping );
        }
    }
}