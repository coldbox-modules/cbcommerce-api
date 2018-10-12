<template>

	<div>

        <page-header
            headerTitle="Customers"
            :displayToolBarButton="true"
            routeName="newCustomer"
            buttonIconClass="fa fa-plus">    
        </page-header>

        <b-row>

            <b-col md="6" offset-md="6" class="my-1">
                <b-form-group horizontal class="mb-0">
                    <b-input-group>
                        <b-form-input v-model="filter" placeholder="Type to Search" />
                        <b-input-group-append>
                            <b-btn :disabled="!filter" @click="filter = ''">Clear</b-btn>
                        </b-input-group-append>
                    </b-input-group>
                </b-form-group>
            </b-col>

        </b-row>

        <b-table
            striped
            :filter="filter"
            :items="customerListArray"
            :fields="customerFields"
            :current-page="currentPage"
            :per-page="perPage">
            <template slot="createdTime" slot-scope="data">
                {{ data.item.createdTime | dateToText }}
            </template>
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
            :totalRows="totalRows"
            :perPage="perPage"
            :currentPage="currentPage">
        </table-pagination>

	</div>

</template>

<script>
import { mapGetters, mapActions } from "vuex";
import moment from "moment";
import TableRow from "./table-row";
export default {

	components: {
		TableRow
	},

    data() {
    	return {
            isLoading     : true,
            currentPage   : 1,
            perPage       : 5,
            totalRows     : 0,
            filter        : null,
            customerFields: {
                firstName: {
                    sortable: true
                },
                lastName: {
                    sortable: true
                },
                emailName: {},
                primaryPhone: {},
                createdTime: {
                    sortable: true
                },
                actions: {
                    sortable: false
                }
            }
    	}
    },

    created() {
    	this.fetchCustomers();
    },

    computed: {

    	...mapGetters([
    		"customerList",
    		"customerListArray",
    		"currentCustomerID"
    	])

    },

    methods: {
    	
    	...mapActions([
    		"getListOfCustomers",
    		"setCurrentCustomer",
    		"clearCurrentCustomer"
    	]),

    	fetchCustomers(){
    		const self = this;
    		Promise.resolve(this.getListOfCustomers())
    		.then(() => {
    			self.isLoading = false;
    		})
    		.catch(err => console.error(err));
    	}

    },

}
</script>