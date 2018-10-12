import get from "lodash/get";

import Index from "@/components/admin/index";
import Dashboard from "@/components/admin/dashboard";
import Orders from "@/components/admin/orders/list";
import OrderView from "@/components/admin/orders/view";
import OrderForm from "@/components/admin/orders/form";
import Categories from "@/components/admin/categories/list";
import CategoryForm from "@/components/admin/categories/form";
import Products from "@/components/admin/products/list";
import ProductForm from "@/components/admin/products/form";
import Customers from "@/components/admin/customers/list";
import CustomerForm from "@/components/admin/customers/form";

import StripeConfig from "@/components/admin/settings/stripe-config";

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