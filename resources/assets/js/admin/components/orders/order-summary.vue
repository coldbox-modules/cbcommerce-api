<template>

    <b-table
        striped
        caption-top
        :items="ordersListArray"
        :fields="orderFields"
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
            {{ $t( 'orders_latest' ) }}
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
            orderFields : [
                {
                    key     : 'customer.firstName',
                    label   : this.$t( 'first_name' ),
                    sortable: true
                },
                {
                    key     : 'customer.lastName',
                    label   : this.$t( 'last_name' ),
                    sortable: true
                },
                {
                    key     : 'total',
                    sortable: true
                },
                {
                    key     : 'paidInFull',
                    sortable: true
                },
                {
                    key     : 'createdTime',
                    label   : this.$t( 'created' ),
                    sortable: true
                },
                {
                    key     : 'fulfilledTime',
                    label   : this.$t( 'fulfilled' ),
                    sortable: true
                },
                {
                    key     : 'actions',
                    label   : this.$t( 'actions' ),
                    sortable: false
                }

            ]
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