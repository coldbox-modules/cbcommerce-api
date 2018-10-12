import defaultAPI from "./create";
import products from "./products";
import orders from "./orders";
import categories from "./categories";
import customers from "./customers";

export const finalAPI = (apiInstance = defaultAPI) => ({
	get: Object.assign(
		{},
		products(apiInstance).get,
		orders(apiInstance).get,
		categories(apiInstance).get,
		customers(apiInstance).get,
	)
});

export default finalAPI;