<template>

    <b-table
        striped
        caption-top
        :items="ordersListArray"
        :fields="ordersFields"
        :current-page="1"
        :per-page="4">
        <template slot="paidInFull" slot-scope="data">
            <i v-if="data.item.paidInFull" class="fa fa-check"></i>
        </template>
        <template slot="createdTime" slot-scope="data">
            {{ data.item.createdTime | dateToText }}
        </template>
        <template slot="fulfilledTime" slot-scope="data">
            {{ data.item.fulfilledTime | dateToText }}
        </template>
        <template slot="actions" slot-scope="data">
            <router-link 
                @click.stop
                :to="{ name: 'orderView', params: { id: data.item.id } }" 
                class="btn btn-success float-right">
                <i class="fa fa-eye"></i>
            </router-link>
        </template>
        <template slot="table-caption">
            Latest Orders
        </template>
    </b-table>

</template>

<script>
import { mapGetters, mapActions } from "vuex";
export default {

    data() {
    	return {
            isLoading   : true,
            orders      : null,
            ordersFields: {
                firstName: {
                    key     : 'customer.firstName',
                    label   : 'First Name',
                    sortable: true
                },
                lastName: {
                    key     : 'customer.lastName',
                    label   : 'Last Name',
                    sortable: true
                },
                total: {
                    sortable: true
                },
                paidInFull: {
                    sortanle: true
                },
                createdTime: {
                    label   : 'Created',
                    sortable: true
                },
                fulfilledTime: {
                    label   : 'Fulfilled',
                    sortable: true
                },
                actions: {
                    sortable: false
                }
            }
    	}
    },

    created() {
    	this.fetchOrders();
    },

    computed: {

    	...mapGetters([
    		"ordersList",
    		"ordersListArray",
    		"currentOrderID"
    	])
        
    },

    methods: {
    	
    	...mapActions([
    		"getListOfOrders",
    		"setCurrentOrder",
    		"clearCurrentOrder"
    	]),

    	fetchOrders(){
    		const self = this;
    		Promise.resolve(this.getListOfOrders())
    		.then(() => {
    			self.isLoading = false;
    		})
    		.catch(err => console.error(err));
    	}

    },

}
</script>