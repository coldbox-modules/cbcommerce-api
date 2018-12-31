import defaultAPI from "./create";
import authentication from "./authentication";
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
		cart( apiInstance ).get,
		authentication( apiInstance ).get
	),
	post: Object.assign(
		products( apiInstance ).post,
		categories( apiInstance ).post,
		customers( apiInstance ).post,
		wishlists( apiInstance ).post,
		authentication( apiInstance ).post
	),
	put: Object.assign(
		products( apiInstance ).put,
		wishlists( apiInstance ).put,
		cart( apiInstance ).put,
		categories( apiInstance ).put
	),
	delete: Object.assign(
		products( apiInstance ).delete,
		wishlists( apiInstance ).delete,
		cart( apiInstance ).delete,
		authentication( apiInstance ).delete,
		categories( apiInstance ).delete
	)
});

export default finalAPI;