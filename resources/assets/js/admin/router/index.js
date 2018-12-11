import get from "lodash/get";

import Index from "@cbCommerce/components/admin/index";
import Dashboard from "@cbCommerce/components/admin/dashboard";
import Orders from "@cbCommerce/components/admin/orders/list";
import OrderView from "@cbCommerce/components/admin/orders/view";
import OrderForm from "@cbCommerce/components/admin/orders/form";
import Categories from "@cbCommerce/components/admin/categories/list";
import CategoryForm from "@cbCommerce/components/admin/categories/form";
import Products from "@cbCommerce/components/admin/products/list";
import ProductForm from "@cbCommerce/components/admin/products/form";
import Customers from "@cbCommerce/components/admin/customers/list";
import CustomerForm from "@cbCommerce/components/admin/customers/form";

import StripeConfig from "@cbCommerce/components/admin/settings/stripe-config";

export const createRouter = (Vue, Router) => {
	Vue.use(Router);
	return new Router({
		mode: "history",
		base: "/store/admin",
		routes: [
			{
				path: "/",
				component: Index,
				children: [
					{
						path: "",
						name: "dashboard",
						component: Dashboard
					},
					{
						path: "/orders",
						name: "orders",
						component: Orders
					},
					{
						path: "/orders/:id",
						component: OrderView,
						name: "orderView"
					},
					{
						path: "/orders/new",
						component: OrderForm,
						name: "newOrder"
					},
					{
						path: "/categories",
						name: "categories",
						component: Categories
					},
					{
						path: "/categories/:id",
						component: CategoryForm,
						name: "categoryForm"
					},
					{
						path: "/categories/new",
						component: CategoryForm,
						name: "newCategory"
					},
					{
						path: "/products",
						name: "products",
						component: Products
					},
					{
						path: "/products/:id",
						component: ProductForm,
						name: "productForm"
					},
					{
						path: "/products/new",
						component: ProductForm,
						name: "newProduct"
					},
					{
						path: "/customers",
						name: "customers",
						component: Customers
					},
					{
						path: "/customers/:id",
						component: CustomerForm,
						name: "customerForm"
					},
					{
						path: "/customers/new",
						component: CustomerForm,
						name: "newCustomer"
					},
					{
						path: "/settings/stripe",
						component: StripeConfig,
						name: "stripeConfig"
					},
					{
			            path: "*",
			            redirect: { name: "dashboard" }
			        }
				]
			}
		]
	});
};

export default createRouter;