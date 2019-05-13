<template>
	<div>
		<div v-if="isLoading"></div>
		<div v-else>
			<div class="col-sm-6">
				<h3>Order Number: {{ orderNumber }}</h3>
				<p>Order will be shipped to:</p>
				<div class="well">
					{{ order.shippingAddress.fullName }}<br/>
					{{ order.shippingAddress.address1 }}<br/>
					<span v-if="order.shippingAddress.address2 != ''">{{ order.shippingAddress.address2 }}<br/></span>
					{{ order.shippingAddress.city }}, {{ order.shippingAddress.province }} &nbsp;&nbsp;{{ order.shippingAddress.postalCode }}<br/>
				</div>
			</div>
			<div class="col-sm-12">
				<table class="table">
					<thead>
						<tr>
							<th>Item</th>
							<th>Quantity</th>
							<th>Line Total</th>
						</tr>
					</thead>
					<tbody>
						<tr v-for="( item, itemIdx ) in order.items" :key="'item-' + item.id">
							<td>
								{{ item.productSnapshot.product.name | removeHTML }}<br/>
								Model: {{ item.productSnapshot.sku.modelNumber}}
							</td>
							<td>{{ item.quantityOrdered }}</td>
							<td>{{ item.productSnapshot.sku.basePrice | currency }}</td>
						</tr>
					</tbody>
				</table>
				<hr>
				<h4>Purchase Summary</h4>
				<table class="table no-borders">
					<tbody>
						<tr>
							<td></td>
							<td>Subtotal</td>
							<td>{{ order.subtotal | currency}}</td>
						</tr>
						<tr>
							<td></td>
							<td>tax</td>
							<td>{{ order.tax | currency}}</td>
						</tr>
						<tr>
							<td></td>
							<td>shipping</td>
							<td>{{ order.shipping | currency}}</td>
						</tr>
						<tr>
							<td></td>
							<td><strong>Total</strong></td>
							<td><strong>{{ order.subtotal | currency}}</strong></td>
						</tr>
						<tr>
							<td>Payment Method: {{ payment.paymentMethod }}</td>
							<td>Amount Paid</td>
							<td class="text-danger">- {{ payment.amount | currency}}</td>
						</tr>
					</tbody>
				</table>
			</div>
		</div>
	</div>
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
		data() {
			return {
				isLoading: false,
				order: {},
				payment: {}
			}
		},
		created() {
			this.getPayment();
		},
		computed:{
			orderNumber: function(){
				var orderId = this.order.id;
				var orderNumber = orderId.split( '-' ).pop();
				return  orderNumber;
			}
		},
		methods: {
			getPayment(){
				var self = this;
				self.isLoading = true;
				new Promise( ( resolve, reject ) => {
  					api().get.checkout.payment( this.purchaseId )
					.then( XHR => {
						self.payment = Object.assign({}, XHR.data );
						self.getOrder( XHR.data.FK_order );
						resolve( XHR.data );
					})
					.catch( err => {
						console.error( err );
						self.isLoading = false;
						reject( "Error" );
					});
  				});
			},
			getOrder( id ){
				var self = this;
				new Promise( ( resolve, reject ) => {
					api().get.orders.detail( id )
					.then( XHR => {
						self.order = Object.assign({}, XHR.data );
						self.isLoading = false;
						resolve( XHR.data );
					})
					.catch( err => {
						console.error( err );
						self.isLoading = false;
						reject( "Error" );
					});
				});
			}
		},
	}
</script>