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
                .toHandler( "API.v1.ContactForms" );

        route( "api/v1/quote-request/wishlist/:wishlistId" )
                .withAction(
                    {
                        "post" : "wishlistQuote"
                    }
                )
                .toHandler( "API.v1.ContactForms" );

        route( "api/v1/quote-request/cart" )
                .withAction(
                    {
                        "post" : "cartQuote"
                    }
                )
                .toHandler( "API.v1.ContactForms" );

        route( "api/v1/quote-request/sku/:skuId" )
                .withAction(
                    {
                        "post" : "skuQuote"
                    }
                )
                .toHandler( "API.v1.ContactForms" );

        // API Routing

        route( "api/v1/authentication/password-reset" )
                .withAction({
                    POST : "passwordReset"
                })
                .toHandler( "API.v1.Authentication" );

        route( "api/v1/authentication" )
                .withAction( {
                    GET : "get",
                    POST : "create",
                    DELETE : "delete"
                } )
                .toHandler( "API.v1.Authentication" );

        route( "api/v1/cart/:itemId" )
                .withAction(
                    {
                        "POST" : "addItem",
                        "PUT" : "updateItem",
                        "PATCH" : "updateItem",
                        "DELETE" : "deleteItem"
                    }
                )
                .toHandler( "API.v1.Cart" );

        route( "api/v1/cart" )
                .withAction({
                    "GET" : "get"
                })
                .toHandler( "API.v1.Cart" );

        //statistical routes
        route( "api/v1/statistics/products/:id" ).withAction({ "POST" : "productView" } ).toHandler( "API.v1.Statistics");
        route( "api/v1/statistics/categories/:id" ).withAction({ "POST" : "categoryView" } ).toHandler( "API.v1.Statistics");

        route( "api/v1/products/count" )
                .withAction({
                    "GET" : "count"
                })
                .toHandler( "API.v1.Products" );

        // Resource Routes ( auto-magic method conventions )
        	resources(
                resource   = "api/v1/products/:productId/reviews",
                handler    = "API.v1.ProductReviews"
            );
            resources(
                resource = "api/v1/products/:productId/media",
                handler = "API.v1.ProductMedia"
            );
            resources(
                resource   = "api/v1/products",
                handler    = "API.v1.Products"
            );
            resources(
                resource = "api/v1/skus/:skuId/media",
                handler = "API.v1.ProductSKUMedia"
            );
			resources(
                resource = "api/v1/skus",
                handler  = "API.v1.ProductSKUs"
            );
			resources(
                resource = "api/v1/consignment-batches",
                handler  = "API.v1.ConsignmentBatches"
            );
			resources(
                resource = "api/v1/product-categories/:categoryId/media",
                handler = "API.v1.ProductCategoryMedia"
            );
			resources(
                resource   = "api/v1/product-categories",
                handler    = "API.v1.ProductCategories"
            );
			resources(
                resource   = "api/v1/product-inventory",
                handler    = "API.v1.ProductInventory"
            );
			resources(
                resource   = "api/v1/orders",
                handler    = "API.v1.Orders"
            );
			resources(
                resource   = "api/v1/customers",
                handler    = "API.v1.Customers"
            );
			resources(
                resource   = "api/v1/payments",
                handler    = "API.v1.Payments"
            );

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
                    .toHandler( "API.v1.WishlistItems" );

            route( 'api/v1/wishlists/:wishlistId/items' )
                    .withAction(
                        {
                            "GET"  : "index",
                            "POST" : "create"
                        }
                    )
                    .toHandler( "API.v1.WishlistItems" );

            // Core wishlist resource routes
            resources(
                resource   = "api/v1/wishlists",
                handler    = "API.v1.Wishlists"
            );

            route( "/" )
                .toHandler( "Main" );
	}
}