export const process = api => ( payload ) => api.post( '/payment', JSON.stringify( payload ) );
export const getPayment = api  => ( id ) => api.get( '/payments/' + id );

export const checkout = api => ({
	get: {
		checkout: {
			payment: getPayment( api )
		}
	},
	post: {
		checkout: {
			process: process( api )
		}
	}
});

export default checkout;