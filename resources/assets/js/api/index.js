import defaultAPI from "./create";
import products from "./products";

export const finalAPI = (apiInstance = defaultAPI) => ({
	get: Object.assign(
		{},
		products(apiInstance).get,
	)
});

export default finalAPI;