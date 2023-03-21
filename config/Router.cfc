component{
	function configure(){
		// Forward Media
        route( "media/:path" )
                .withAction(
                    {
                        "get" : "deliver"
                    }
                )
                .toHandler( "Media" );

        // Contact Forms
        route( "api/v1/contact-forms" )
                .withAction(
                    {
                        "post" : "send"
                    }
                )
                .toHandler( "api.v1.ContactForms" );

        route( "api/v1/quote-request/wishlist/:wishlistId" )
                .withAction(
                    {
                        "post" : "wishlistQuote"
                    }
                )
                .toHandler( "api.v1.ContactForms" );

        route( "api/v1/quote-request/cart" )
                .withAction(
                    {
                        "post" : "cartQuote"
                    }
                )
                .toHandler( "api.v1.ContactForms" );

        route( "api/v1/quote-request/sku/:skuId" )
                .withAction(
                    {
                        "post" : "skuQuote"
                    }
                )
                .toHandler( "api.v1.ContactForms" );

        // API Routing
        route( "api/v1/authentication/token" )
                .withAction({
                    HEAD : "token",
                    GET  : "token"
                })
                .toHandler( "api.v1.Authentication" );

        route( "api/v1/authentication/password-reset" )
                .withAction({
                    POST : "passwordReset"
                })
                .toHandler( "api.v1.Authentication" );

        route( "api/v1/authentication" )
                .withAction( {
					HEAD : "check",
                    GET : "get",
                    POST : "create",
                    DELETE : "delete"
                } )
                .toHandler( "api.v1.Authentication" );

        route( "api/v1/cart/:itemId" )
                .withAction(
                    {
                        "POST" : "addItem",
                        "PUT" : "updateItem",
                        "PATCH" : "updateItem",
                        "DELETE" : "deleteItem"
                    }
                )
                .toHandler( "api.v1.Cart" );

        route( "api/v1/cart" )
                .withAction({
                    "GET" : "get"
                })
                .toHandler( "api.v1.Cart" );

        //statistical routes
        route( "api/v1/statistics/products/:id" ).withAction({ "POST" : "productView" } ).toHandler( "api.v1.Statistics");
        route( "api/v1/statistics/categories/:id" ).withAction({ "POST" : "categoryView" } ).toHandler( "api.v1.Statistics");

        route( "api/v1/products/count" )
                .withAction({
                    "GET" : "count"
                })
                .toHandler( "api.v1.Products" );

        // Resource Routes ( auto-magic method conventions )
        	resources(
                resource   = "api/v1/products/:productId/reviews",
                handler    = "api.v1.ProductReviews"
            );
            resources(
                resource = "api/v1/products/:productId/media",
                handler = "api.v1.ProductMedia"
            );
            resources(
                resource   = "api/v1/products",
                handler    = "api.v1.Products"
            );
            resources(
                resource = "api/v1/skus/:skuId/media",
                handler = "api.v1.ProductSKUMedia"
            );
			resources(
                resource = "api/v1/skus",
                handler  = "api.v1.ProductSKUs"
            );
			resources(
                resource = "api/v1/consignment-batches",
                handler  = "api.v1.ConsignmentBatches"
            );
			resources(
                resource = "api/v1/product-categories/:categoryId/media",
                handler = "api.v1.ProductCategoryMedia"
            );
			resources(
                resource   = "api/v1/product-categories",
                handler    = "api.v1.ProductCategories"
            );
			resources(
                resource   = "api/v1/product-inventory",
                handler    = "api.v1.ProductInventory"
            );
			resources(
                resource   = "api/v1/orders",
                handler    = "api.v1.Orders"
            );


			route( 'api/v1/customers/:customerId/addresses/:id' )
                    .withAction(
                        {
                            "PUT"  : "updateAddress"
                        }
                    )
                    .toHandler( "api.v1.Customers" );

			route( 'api/v1/customers/:customerId/addresses' )
                    .withAction(
                        {
                            "POST"  : "createAddress"
                        }
                    )
                    .toHandler( "api.v1.Customers" );

			resources(
                resource   = "api/v1/customers",
                handler    = "api.v1.Customers"
            );


			resources(
                resource   = "api/v1/payments",
                handler    = "api.v1.Payments"
            );

			route( 'api/v1/settings' )
                    .withAction(
                        {
                            "GET"  : "index"
                        }
                    )
                    .toHandler( "api.v1.Settings" );

			route( 'api/v1/product-conditions' )
                    .withAction(
                        {
                            "GET"  : "index"
                        }
                    )
                    .toHandler( "api.v1.ProductConditions" );

            // Wishlist Item Routes
            route( 'api/v1/wishlists/:wishlistId/items/:id' )
                    .withAction(
                        {
                            "GET"    : "show",
                            "PUT"    : "update",
                            "PATCH"  : "update",
                            "DELETE" : "delete"
                        }
                    )
                    .toHandler( "api.v1.WishlistItems" );

            route( 'api/v1/wishlists/:wishlistId/items' )
                    .withAction(
                        {
                            "GET"  : "index",
                            "POST" : "create"
                        }
                    )
                    .toHandler( "api.v1.WishlistItems" );

            // Core wishlist resource routes
            resources(
                resource   = "api/v1/wishlists",
                handler    = "api.v1.Wishlists"
            );

			route( 'api/v1' )
					.withAction(
						{
							"GET" : "index"
						}
					)
					.toHandler( "api.v1.Documentation" );

            route( "/" )
                .toHandler( "Main" );
	}
}