import defaultAPI from "./create";
import products from "./products";
import orders from "./orders";
import categories from "./categories";
import customers from "./customers";
import wishlists from "./wishlists";
import cart from "./cart";

export const finalAPI = (apiInstance = defaultAPI) => ({
	get: Object.assign(
		{},
		products( apiInstance ).get,
		orders( apiInstance ).get,
		categories( apiInstance ).get,
		customers( apiInstance ).get,
		wishlists( apiInstance ).get,
		cart( apiInstance ).get
	),
	post: Object.assign(
		products( apiInstance ).post,
		categories( apiInstance ).post,
		customers( apiInstance ).post,
		wishlists( apiInstance ).post,
	),
	put: Object.assign(
		wishlists( apiInstance ).put,
		cart( apiInstance ).put
	),
	delete: Object.assign(
		wishlists( apiInstance ).delete,
		cart( apiInstance ).delete
	)
});

export default finalAPI;