<template>

	<div>

		<div v-if="!isLoading">

			<page-header :headerTitle="$t( 'order_details' )"></page-header>

			<b-row>

				<b-col cols="12">

					<b-table
			            striped
			            caption-top
			            :items="orderItems"
			            :fields="orderItemsFields">
			            <template slot="table-caption">{{ $t( 'orders_items_order' ) }}</template>
			            <template slot="product.name" slot-scope="data">
							<router-link 
								@click.stop
								:to="{ name: 'productForm', params: { id: data.item.id } }">
								{{ data.item.product.name }}
							</router-link>
			            </template>
						<template slot="originalCost" slot-scope="data">
							{{ data.item.originalCost | currency }}
						</template>
						<template slot="originalPrice" slot-scope="data">
							{{ data.item.originalPrice | currency }}
						</template>
			        </b-table>

				</b-col>

			</b-row>

			<b-row>

				<b-col cols="6">

					<b-table 
						stacked 
						caption-top
						:items="paymentBreakdownData">
						<template slot="table-caption">{{ $t( 'order_payment_breakdown' ) }}</template>
						<template slot="subtotal" slot-scope="data">
							{{ data.item.subtotal | currency }}
						</template>
						<template slot="discount" slot-scope="data">
							{{ data.item.discount | currency }}
						</template>
						<template slot="shipping" slot-scope="data">
							{{ data.item.shipping | currency }}
						</template>
						<template slot="tax" slot-scope="data">
							{{ data.item.tax | currency }}
						</template>
						<template slot="fees" slot-scope="data">
							{{ data.item.fees | currency }}
						</template>
						<template slot="total" slot-scope="data">
							{{ data.item.total | currency }}
						</template>
					</b-table>

				</b-col>

				<b-col cols="6">

					<b-table 
						stacked 
						caption-top
						:items="payments"
						:fields="paymentFields">
						<template slot="table-caption">{{ $t( 'order_payment_details' ) }}</template>
						<template slot="amount" slot-scope="data">
							{{ data.item.amount | currency }}
						</template>
						<template slot="createdTime" slot-scope="data">
							{{ data.item.createdTime | dateToText }}
						</template>
					</b-table> 

				</b-col>

			</b-row>

			<b-row>

				<b-col cols="12">

					<b-table 
						caption-top
						striped
						:items="shipments"
						:fields="shipmentFields">
						<template slot="table-caption">{{ $t( 'order_shipment_details' ) }}</template>
						<template slot="createdTime" slot-scope="data">
							{{ data.item.createdTime | dateToText }}
						</template>
						<template slot="modifiedTime" slot-scope="data">
							{{ data.item.modifiedTime | dateToText }}
						</template>
					</b-table> 

				</b-col>

				<b-col cols="6">

					<address-details-card
						type="Billing"
						title="Billing Address"
						:customerName="fullName"
						:address="form.billingAddress">
					</address-details-card>

				</b-col>

				<b-col cols="6">

					<address-details-card
						type="Shipping"
						title="Shipping Address"
						:customerName="fullName"
						:address="form.shippingAddress">
					</address-details-card>					

				</b-col>

			</b-row>

			<hr />

			<back-button link="/orders" :text="$t( 'orders_back' )"></back-button>

		</div>

	</div>

</template>

<script>
import moment from "moment";
import { vueSlideoutPanelService } from 'vue2-slideout-panel';
import { mapGetters, mapActions } from "vuex";
import { Form } from '@cbCommerce/admin/classes/form';
import addressDetailsCard from '@cbCommerce/admin/components/address/address-details-card';
import addressSidebar from '@cbCommerce/admin/components/address/address-sidebar';
export default {
	name: "OrderView",

	components: {
		addressDetailsCard
	},

	data() {
		return {
			isLoading           : false,
			form                : new Form(),
			moment              : moment,
			errors              : [],
			isSending           : false,
			isSent              : false,
			orderItems          : null,
			orderItemsFields    : {
				product: {
					key  : 'product.name',
					label: this.$t( 'product' )
				},
				quantityOrdered: {
					label: this.$t( 'quantity' )
				},
				originalCost: {
					label: this.$t( 'cost' )
				},
				originalPrice: {
					label: this.$t( 'price' )
				}
			},
			shipments           : null,
			shipmentFields      : [],
			payments            : null,
			paymentFields       : [],
			paymentBreakdownData: []
		}
	},

	computed: {

		...mapGetters([
			"currentOrder",
			"currentOrderID",
			"ordersList"
		]),

		fullName(){
			return this.form.customer.firstName + " " + this.form.customer.lastName;
		}

	},

	created() {

		if( !this.currentOrderID ){
			this.isLoading = true;
			return Promise.all([
				this.getListOfOrders().then(() => {
					this.setCurrentOrder( this.$route.params.id );
					Object.assign( this.form, this.currentOrder || {} );
					this.fetchOrderData();
					this.isLoading = false;
				})
			]);
		} else {
			if( !this.isLoading ){
				Object.assign( this.form, this.currentOrder || {} );
				this.fetchOrderData();

			}
		}

	},

	methods: {

		...mapActions([
			"setCurrentOrder",
			"getListOfOrders"
		]),

		fetchOrderData(){
			this.generatePaymentBreakdownData();
			this.fetchOrderItems();
			this.fetchShipments();
			this.fetchPayments();
		},

		generatePaymentBreakdownData() {
			var self      = this;
			var pbObject  = {};
			const keyList = [ 'subtotal', 'discount', 'shipping', 'fees', 'tax', 'total' ];
			keyList.forEach( ( key ) => {
				pbObject[ key ] = self.form[ key ]
			} )
			this.paymentBreakdownData.push( pbObject );
		},

		fetchOrderItems() {
			var orderItems = this.$options.filters.denormalize( this.form.items );
			if( orderItems.length ){
				this.orderItems = orderItems;
			}
		},

		fetchShipments() {
			var shipments = this.$options.filters.denormalize( this.form.shipments );
			if( shipments.length ){
				this.shipments      = shipments;
				this.shipmentFields = [
					'quantity',
					'carrierReferenceNumber',
					'createdTime',
					'modifiedTime'
				];
			}
		},

		fetchPayments() {
			var payments = this.$options.filters.denormalize( this.form.payments );
			if( payments.length ){
				this.payments      = payments;
				this.paymentFields = [
					'amount',
					'paymentMethod',
					'lastFour',
					'externalTransactionId',
					'createdTime',
					'comment'
				];
			}
		},

		showAddressFormPanel( payload ) {
			var thisAddress     = payload.address;
			var thisAddressType = payload.type;
			vueSlideoutPanelService.show( {
				component: addressSidebar,
				width    : '1020px',
				cssClass : 'slideout-panel-overall',
				props    : {
					data: {
						address: thisAddress,
						method : 'add',
						type   : thisAddressType
					},
				}
			} );
	    },

	}

}
</script>
<style>
a.addressFormBtn {
	cursor: pointer;
}
a.addressFormBtn i.fa {
	color: #fff;
}
</style>