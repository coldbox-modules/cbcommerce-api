export const process = api => ( payload ) => api.post( '/payment', JSON.stringify( payload ) );

export const checkout = api => ({
	post: {
		checkout: {
			process: process( api )
		}
	}
});

export default checkout;