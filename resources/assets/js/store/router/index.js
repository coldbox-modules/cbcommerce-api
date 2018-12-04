import get from "lodash/get";

import CategoryGrid from "@/components/categories/category-grid";
import ProductFilterPage from "@/components/products/product-filter-page";
import ProductDetail from "@/components/products/product-detail";
import ContactForm from "@/components/contact-form";
import ProductComparison from "@/components/products/product-comparison";
import ProductWishlist from "@/components/products/product-wishlist";
import ShoppingCart from "@/components/commerce/shopping-cart";
import Storefront from "@/components/storefront";

export const createRouter = (Vue, Router) => {
	Vue.use(Router);
	return new Router({
		mode: "history",
		base: "/store",
		routes: [
			{
				path: "/",
				component: Storefront,
				children: [
					{
						path: "",
						component: Storefront,
						name: "storefront"
					},
					{
						path: "/product/:id",
						component: ProductDetail,
						name: "product"
					},
					{
						path: "/cart",
						component: ShoppingCart,
						name: "cart"
					},
					{
						path: "/compare",
						component: ProductComparison,
						name: "comparison"
					},
					{
						path: "/search",
						component: ProductFilterPage,
						name: "search"
					},
					{
						path: "/wishlist",
						component: ProductWishlist,
						name: "wishlist"
					},
					{
						path: "/categories/:id",
						component: CategoryGrid,
						name: "category"
					},
					{
						path: "/support/contact",
						component : ContactForm,
						name : "contact"
					},
					{
						path: "*",
						redirect: { name: "storefront" }
					}
				]
			}
		]
	});
};

export default createRouter;