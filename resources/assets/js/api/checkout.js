export const process = api => ( payload ) => api.post( '/checkout', JSON.stringify( payload ) );

export const checkout = api => ({
	post: {
		checkout: {
			charge: process( api )
		}
	}
});

export default checkout;