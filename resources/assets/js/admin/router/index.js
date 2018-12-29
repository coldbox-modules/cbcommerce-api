import Index from "@cbCommerce/admin/components/index";
import Dashboard from "@cbCommerce/admin/components/dashboard";
import Orders from "@cbCommerce/admin/components/orders/list";
import OrderView from "@cbCommerce/admin/components/orders/view";
import OrderForm from "@cbCommerce/admin/components/orders/form";
import Categories from "@cbCommerce/admin/components/categories/list";
import CategoryForm from "@cbCommerce/admin/components/categories/form";
import Products from "@cbCommerce/admin/components/products/list";
import ProductForm from "@cbCommerce/admin/components/products/form";
import Customers from "@cbCommerce/admin/components/customers/list";
import CustomerForm from "@cbCommerce/admin/components/customers/form";
import LoginForm from "@cbCommerce/admin/components/auth/login-form";

import StripeConfig from "@cbCommerce/admin/components/settings/stripe-config";

export const createRouter = ( Vue, Router ) => {
	Vue.use( Router );
	return new Router({
		mode: "history",
		base: "store/admin/app",
		routes: [
			{
				path: "/",
				component: Index,
				children: [
					{
						path : "/login",
						name : "login",
						component : LoginForm
					},
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