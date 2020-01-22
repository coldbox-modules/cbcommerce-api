<template>

	<div v-if="!this.isLoading">

		<page-header :headerTitle="$t( 'order_new_entry' )"></page-header>

		<dismissable-alert v-if="isSent && !isSending"
			:alertText="$t( 'order_saved' )"
			alertType="success">
		</dismissable-alert>

		<form @submit.prevent>

			<b-row>

		        <b-col cols="8">

		        	<b-form-group
						:label="$t( 'customer' )"
						label-for="categories">
						<list-select 
							:list="this.customerListArray"
							option-value="id"
							option-text="firstName"
							:custom-text="customerDisplayText"
							:selected-item="this.currentCustomer"
							@select="onCustomerSelect">
						</list-select>
					</b-form-group>			

			    </b-col>

			    <b-col cols="4">
					<span 
						class="pull-right mt-4">
						<a 
							class="btn btn-success accountInfoFormBtn"			    				
							@click="showNewCustomerForm()">
							<i class="fa fa-plus"></i> {{ $t ( 'customer_add' )}}
						</a>
					</span>
				</b-col>


				<b-col cols="12 pb-5">

					<div v-if="this.currentCustomer">

						<b-card-header header-tags="header" class="p-1" role="tab">
			    			<b-btn block href="#" v-b-toggle.shippingAddress>{{ $t( 'shipping_address' ) }}</b-btn>
			    		</b-card-header>
			    		<b-collapse 
			    			id="shippingAddress"
			    			accordion="shippingAddress-accordion" 
			    			role="tabpanel">

			    			<b-card-body>

							    <b-row>
							        <b-col cols="12">

										<address-form-fields
											:address1="shippingAddress.address1"
											:address2="shippingAddress.address2"
											:city="shippingAddress.city"
											:province="shippingAddress.province"
											:postalCode="shippingAddress.postalCode"
											:country="shippingAddress.country"
										></address-form-fields>	

							        </b-col>
							    </b-row>

			    			</b-card-body>

			    		</b-collapse>

			    	</div>	

				</b-col>

			    <b-col cols="6">

		        	<b-form-group
						:label="$t( 'products' )"
						label-for="products">
						<list-select 
							:list="this.productsListArray"
							option-value="id"
							option-text="name"
							:custom-text="productDisplayText"
							:selected-item="this.currentProduct"
							@select="onProductSelect">
						</list-select>
					</b-form-group>
			         
			    </b-col>

			    <b-col cols="6" v-if="this.productSKUs">

		        	<b-form-group
						:label="$t( 'product_variants' )"
						label-for="productSKUs">
						<list-select 
							:list="this.productSKUs"
							option-value="id"
							:custom-text="productSKUDisplayText"
							@select="onProductSKUSelect">
						</list-select>
					</b-form-group>
			         
			    </b-col>			    

			</b-row>

			<b-row>

				<b-table
		            striped
		            :items="orderProductListArray"
		            :fields="orderProductListFields">
					<template slot="name" slot-scope="data" class="inline-cart-products">
					    {{ data.item.product.name }}
					</template>
					<template slot="variant" slot-scope="data" class="inline-cart-products">
					    {{ data.item.productSKU.condition }}
					</template>
					<template slot="quantity" slot-scope="data" class="inline-cart-products">
						<quantity-control 
							:showLabel="false"
							:quantity="data.item.quantity"
							:sku="data.item"
							v-on:quantityChange="quantityChangeProcess">
						</quantity-control>
					</template>
					<template slot="basePrice" slot-scope="data" class="inline-cart-products">

						<editable-number-field 
							:fieldValue="parseInt( data.item.productSKU.basePrice )"
							:parentId="data.item.id"
							v-on:valueChange="updateProductQuantity">
						</editable-number-field>

					</template>
					<template slot="productTotal" slot-scope="data">
						{{ data.value | currency }}
					</template>
		        </b-table>


		        <b-col cols="6"></b-col>

		        <b-col cols="6">

			        <table class="table table-striped">
			        	<tr>
			        		<td><strong>{{ $t( 'subtotal' ) }}:</strong></td>
			        		<td>{{ subTotal | currency }}</td>
			        	</tr>
			        	<tr>
			        		<td><strong>{{ $t( 'discount' ) }}:</strong></td>
			        		<td>
			        			<editable-number-field 
									:fieldValue="parseInt( discount )"
									v-on:valueChange="applyDiscount">
								</editable-number-field>
			        		</td>
			        	</tr>
			        	<tr>
			        		<td><strong>{{ $t( 'order_shipping' ) }}:</strong></td>
			        		<td>
			        			<editable-number-field
									:fieldValue="parseInt( shippingCosts )"
									v-on:valueChange="applyShipping">
								</editable-number-field>
			        		</td>
			        	</tr>
			        	<tr>
			        		<td><strong>{{ $t( 'order_fees' ) }}:</strong></td>
			        		<td>
			        			<editable-number-field
									:fieldValue="parseInt( fees )"
									v-on:valueChange="applyFees">
								</editable-number-field>
			        		</td>
			        	</tr>
			        	<tr>
			        		<td><strong>{{ $t( 'order_tax' ) }}:</strong></td>
			        		<td>
			        			<editable-number-field
									:fieldValue="parseInt( tax )"
									v-on:valueChange="applyTax">
								</editable-number-field>
			        		</td>
			        	</tr>
			        	<tr>
			        		<td><strong>{{ $t( 'order_total' ) }}:</strong></td>
			        		<td>{{ total | currency }}</td>
			        	</tr>
			        </table>

			    </b-col>

			</b-row>

			<b-row>

				<b-col>

					<b-form-select 
						v-model="selectedShippingOption" 
						:options="shippingOptions" 
						class="mb-3" />

				</b-col>

			</b-row>

		    <button type="submit" class="btn btn-secondary btn-lg">{{ $t( 'save' ) }}</button>

		    <back-button link="/orders" :text="$t( 'orders_back' )"></back-button>

		</form>

	</div>

</template>
<script>
import { mapGetters, mapActions } from "vuex";
import { vueSlideoutPanelService } from 'vue2-slideout-panel';
import moment from "moment";
import { ListSelect } from 'vue-search-select'
import QuantityControl from '@cbCommerce/admin/components/ui/quantity-control';
import EditableNumberField from '@cbCommerce/admin/components/ui/editable-number-field';
import { Form } from '@cbCommerce/admin/classes/form';
import NewCustomerSidebar from './new-customer-sidebar';
import addressFormFields from '@cbCommerce/admin/components/address/address-form-fields';
export default {

	name: "OrderForm",

	components: {
		ListSelect,
		QuantityControl,
		EditableNumberField,
		NewCustomerSidebar,
		addressFormFields
	},

    data() {
        return {
			isLoading             : false,
			form                  : new Form(),
			url                   : '', /* The URL to post the submission to */
			moment                : moment,
			errors                : [],
			isSending             : false,
			isSent                : false,
			productSKUs           : null,
			orderProductListFields: {
				name: {
					key  : 'product.name',
					label: this.$t( 'name' )
				},
				variant: {
					label: this.$t( 'product_sku' ),
					key  : 'productSKU.condition'
				},
				quantity : {},
				basePrice: {
					label: this.$t( 'product_unit_price' )
				},
				productTotal: {
					label: this.$t( 'order_total' ),
					formatter: ( value, key, item ) => {
						return item.productSKU.basePrice * item.quantity;
					}
				}
			},
			discount     : 0,
			shippingCosts: 0,
			fees         : 0,
			tax          : 0,
			shippingAddress: {
				address1  : null,
				address2  : null,
				city      : null,
				province  : null,
				postalCode: null,
				country   : null
			},
			selectedShippingOption: null,
			shippingOptions: [
				{ value: null, text: this.$t( 'order_shipping_option' ) },
				{ value: 1, text: this.$t( 'order_couriers' ) },
				{ value: 2, text: this.$t( 'order_ortus_delivery' ) },
				{ value: 3, text: this.$t( 'order_we_try' ) }
			]
        }
    },

	computed: {

		...mapGetters([
			"currentOrder",
			"currentOrderID",
			"productsList",
			"productsListArray",
			"customerList",
			"customerListArray",
			"currentCustomer",
			"orderProductListArray",
			"currentProduct",
			"currentProductID"
		]),

		subTotal() {
			return this.orderProductListArray.reduce( ( subTotal, p ) => {
				return subTotal + p.productSKU.basePrice * p.quantity
			}, 0 );
		},

		total() {
			return parseInt( this.subTotal - this.discount ) + parseInt( this.shippingCosts ) + parseInt( this.fees ) + parseInt( this.tax );
		}

	},

	created() {
		return Promise.all([
			this.getListOfCustomers().then(() => {}),
			this.getListOfProducts().then(() => {})
		])
		.then(() => this.isLoading = false );	
	},

	methods: {

		...mapActions([
			"setCurrentOrder",
			"getListOfProducts",
			"getListOfCustomers",
			"setCurrentCustomer",
			"addProductToOrder",
			"defineProductQuantity",
			"setCurrentProduct",
			"clearCurrentProduct",
			"updateSKUBasePrice"
		]),

		showNewCustomerForm() {
			vueSlideoutPanelService.show( {
				component: NewCustomerSidebar,
				width    : '1020px',
				cssClass : 'slideout-panel-overall',
				props    : {
					data: {},
				}
			} );
	    },

		customerDisplayText( item ){
			return `${item.firstName} ${item.lastName}`;
		},

		onCustomerSelect( item ){
			this.setCurrentCustomer( item.id );
			this.fetchShippingAddress();
		},

		productDisplayText( item ){
			return `${item.name}`;
		},

		productSKUDisplayText( item ){
			return `${item.condition}`;
		},

		onProductSelect( item ){
			this.setCurrentProduct( item.id );
			this.fetchProductSKUs();
		},

		onProductSKUSelect( item ){
			this.addProductToOrder( { product: this.currentProduct, productSKU: item, quantity: 1 } );
		},

		fetchProductSKUs() {
			if( this.currentProduct ){
				var skus = this.$options.filters.denormalize( this.currentProduct.skus );
				if( skus.length ){
					this.productSKUs = skus;
				}
			}
		},

		fetchShippingAddress() {
			if( this.currentCustomer ){
				var shippingAddress = this.$options.filters.denormalize( this.currentCustomer.shippingAddresses );
				if( shippingAddress.length ){
					this.shippingAddress = shippingAddress[ 0 ];
				}
			}
		},

		quantityChangeProcess( payload ) {
			this.defineProductQuantity( { 
				product : payload.product.product,
				quantity: payload.quantity
			} );
		},

		updateProductQuantity( payload ){
			this.updateSKUBasePrice( {
				parentId: payload.parentId,
				newPrice: payload.fieldValue
			} );
		},

		applyDiscount( payload ){
			this.discount = payload.fieldValue;
		},

		applyShipping( payload ){
			this.shippingCosts = payload.fieldValue;
		},

		applyFees( payload ){
			this.fees = payload.fieldValue;
		},

		applyTax( payload ){
			this.tax = payload.fieldValue;
		},

		handleSubmit: function(){
			this.isSending = true;
			this.submitContent();
    	},

    	submitContent: function(){

    		var self = this;

			Object.assign( self.form, {
				'products': this.orderProductListArray,
				'customer': this.currentCustomer
			} );

    		// Mocking sending the form data
    		// Axios below will handle it in real life
	        window.setTimeout(
	            function(){
					self.isSent    = true;
					self.isSending = false;
	            },
	            500
	        );

	        /*
			axios.post( this.url , this.form )
				.then( ( response ) => {
					console.log( response );
				} )
				.catch( ( error ) => {
					this.errors = error.response.data.message;
				} );
			*/

    	}

	}
}
</script>
<style>
.quantityControl {
	padding: 10px 0;
	margin: 0;
}
a.qtyControl {
	cursor: pointer;
	display: inline-block;
	width: 40px;
	height: 40px;
	text-align: center;
	line-height: 38px;
	color: #790000;
	border: 1px solid #28a745;
}
a.qtyControl:hover {
	background-color: #28a745;
}
a.qtyControl:hover i.fa {
	color: #fff;
}
.qty {
	width: 80px;
	height: 40px;
	text-align: center;
	pointer-events: none;
}
a.accountInfoFormBtn {
	color: #ffffff !important;
}
.inline-cart-products {
	padding-top: 25px;
}
</style>