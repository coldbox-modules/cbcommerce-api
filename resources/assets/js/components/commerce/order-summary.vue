<template>
	<div>your summary</div>
</template>
<script type="text/javascript">
	import api from "@cbCommerce/api/index";

	export default{
		props: {
			purchaseId :{
				type: String,
				required: true
			}
		},
		created() {
			this.getPayment();
		},
		methods: {
			getPayment(){
				var self = this;
				new Promise( ( resolve, reject ) => {
  					api().get.checkout.payment( this.purchaseId )
					.then( XHR => {
						self.getOrder( XHR.data.FK_order );
						resolve( XHR.data );
					})
					.catch( err => {
						console.error( err );
						reject( "Error" );
					});
  				});
			},
			getOrder( id ){
				new Promise( ( resolve, reject ) => {
					api().get.orders.detail( id )
					.then( XHR => {
						console.log( XHR.data );
						resolve( XHR.data );
					})
					.catch( err => {
						console.error( err );
						reject( "Error" );
					});
				});
			}
		},
	}
</script>