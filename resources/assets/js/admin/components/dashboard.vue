<template>

	<div>

        <page-header headerTitle="Dashboard"></page-header>

		<b-row>

			<b-col cols="4">
				<b-card>
					<doughnut-chart
						:data="chartData.doughnutData"
						:options="chartData.doughnutOptions"></doughnut-chart>
				</b-card>
			</b-col>

			<b-col cols="4">
				<b-card>
					<bar-chart
						:data="chartData.barData"
						:options="chartData.barOptions"></bar-chart>
				</b-card>
			</b-col>

			<b-col cols="4">
				<b-card>
					<pie-chart
						:data="chartData.pieData"
						:options="chartData.pieOptions"></pie-chart>
				</b-card>
			</b-col>

		</b-row>

		<b-row>

			<b-col cols="12">
				<order-summary></order-summary>
			</b-col>

		</b-row>


		<b-row>

			<b-col cols="12">

				<b-row>

				    <b-col md="6" offset-md="6" class="my-1">
				        <b-form-group horizontal class="mb-0">
				            <b-input-group>
				                <b-form-input 
				                	v-model="customersFilter" 
				                	placeholder="Type to filter customers" />
				                <b-input-group-append>
				                    <b-btn 
				                    	:disabled="!customersFilter" 
				                    	@click="customersFilter = ''">Clear</b-btn>
				                </b-input-group-append>
				            </b-input-group>
				        </b-form-group>
				    </b-col>

				</b-row>

				<b-table
				    striped
				    caption-top
				    :filter="customersFilter"
				    :items="customerListArray"
				    :fields="customerFields"
				    :current-page="customersCurrentPage"
				    :per-page="customersPerPage">
				    <template slot="table-caption">Customers</template>
				    <template slot="actions" slot-scope="data">
				        <router-link 
				            @click.stop
				            :to="{ name: 'customerForm', params: { id: data.item.id } }" 
				            class="btn btn-success float-right">
				            <i class="fa fa-pencil"></i>
				        </router-link>
				    </template>
				</b-table>

				<table-pagination
				    :totalRows="customersTotalRows"
				    :perPage="customersPerPage"
				    :currentPage="customersCurrentPage">
				</table-pagination>

			</b-col>

		</b-row>


	</div>

</template>

<script>
import { mapGetters, mapActions } from "vuex";
import BarChart from "@cbCommerce/admin/components/charts/bar-chart";
import DoughnutChart from "@cbCommerce/admin/components/charts/doughnut-chart";
import PieChart from "@cbCommerce/admin/components/charts/pie-chart";
import OrderSummary from "./orders/order-summary";
export default {

	name    : "Index",

	components: {
		BarChart,
		DoughnutChart,
		PieChart,
		OrderSummary
	},

	data() {
		return {
			customersCurrentPage : 1,
			customersPerPage     : 5,
			customersTotalRows   : 0,
			customersFilter      : null,
			searchTerms          : [],
			popularProductsFields: [ 'name' ],
			customerFields: [
				{
					key : 'firstName'
				},
				{
					key : 'lastName'
				},
				{
					key : 'email',
					label : 'Email'
				}
			],
			chartData: {
				barData: {
					labels: [
						'January',
						'February',
						'March',
						'April',
						'May',
						'June',
						'July',
						'August',
						'September',
						'October',
						'November',
						'December'
					],
					datasets: [
						{
							label          : 'Sales by Month',
							backgroundColor: '#f87979',
							data           : [ 40, 20, 12, 39, 10, 40, 39, 80, 40, 20, 12, 11 ]
						}
					]
				},
				barOptions: {
					legend: {
						display: false
					}
				},
				doughnutData: {
					labels: [
						'One',
						'Two',
						'Three'
					],
					datasets: [
						{
							backgroundColor: [ '#f87979', '#b4d455', '#ffff00' ],
							data           : [ 40, 20, 12 ]
						}
					]
				},
				doughnutOptions: {
					legend: {
						position: 'bottom',
						labels: {
							pointStyle   : 'circle',
							usePointStyle: true,
						}
					},
					responsive         : true,
					maintainAspectRatio: true
				},
				pieData: {
					labels: [
						'One',
						'Two',
						'Three'
					],
					datasets: [
						{
							backgroundColor: [ '#f87979', '#b4d455', '#ffff00' ],
							data           : [ 33, 56, 11 ]
						}
					]
				},
				pieOptions: {
					legend: {
						position: 'bottom',
						labels: {
							pointStyle   : 'circle',
							usePointStyle: true,
						}
					},
					responsive         : true,
					maintainAspectRatio: true
				},				
			}
		}
	},

	created() {
		this.fetchCustomers();
		this.fetchPopularProducts();
		this.fetchSearchTerms();
	},

	computed: {

		...mapGetters([
			"productsList",
    		"productsListArray",
    		"customerList",
    		"customerListArray"
		])

	},

	methods : {

		...mapActions([
			"getListOfProducts",
			"getListOfCustomers"
		]),

    	fetchPopularProducts(){
    		const self = this;
    		Promise.resolve(this.getListOfProducts())
    		.then(() => {
    			self.isLoading = false;
    		})
    		.catch(err => console.error(err));
    	},

		fetchCustomers(){
			const self = this;
			Promise.resolve(this.getListOfCustomers())
			.then(() => {
			self.isLoading = false;
			})
			.catch(err => console.error(err));
		},

		fetchSearchTerms() {
			var searchTermData = [
				{
					"term"   : "Blenders",
					"results": [
						"4D8F68DF-E526-4A4F-BC3B7CE52B1B98E2",
						"4D8F68DF-E526-4A4F-BC3B7CE52B1B98E3"
					]
				},
				{
					"term"   : "2042",
					"results": []
				},
				{
					"term"   : "Waring",
					"results": []
				}
			];
			var terms = this.$options.filters.denormalize( searchTermData );
			if( terms.length ){
				terms.forEach( ( termData ) => {
					this.searchTerms.push( {
						term : termData.term,
						count: termData.results.length
					} );
				});
			}
		}

	}
};
</script>