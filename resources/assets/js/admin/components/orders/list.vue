<template>

	<div>

        <page-header
            :headerTitle="$t( 'orders_name' )"
            :displayToolBarButton="true"
            routeName="newOrder"
            buttonIconClass="fa fa-plus">    
        </page-header>

        <b-row>

            <b-col md="6" offset-md="6" class="my-1">
                <b-form-group horizontal class="mb-0">
                    <b-input-group>
                        <b-form-input v-model="filter" :placeholder="$t( 'type_search' )" />
                        <b-input-group-append>
                            <b-btn :disabled="!filter" @click="filter = ''">{{ $t( 'clear' ) }}</b-btn>
                        </b-input-group-append>
                    </b-input-group>
                </b-form-group>
            </b-col>

        </b-row>

        <b-table
            striped
            :filter="filter"
            :items="ordersListArray"
            :fields="ordersFields"
            :current-page="currentPage"
            :per-page="perPage">
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
        </b-table>

        <b-row>
            <b-col xs="12">
              <generic-loader v-if="isLoading" :message="$t( 'orders_loading' )"></generic-loader>
            </b-col>
        </b-row>

        <table-pagination
            :totalRows="totalRows"
            :perPage="perPage"
            :currentPage="currentPage">
        </table-pagination>

	</div>

</template>
<script>
import { mapGetters, mapActions } from "vuex";
export default {

    data() {
    	return {
            isLoading   : true,
            currentPage : 1,
            perPage     : 5,
            totalRows   : 0,
            filter      : null,
            ordersFields: [
                {
                    key     : 'firstName',
                    label   : 'First Name',
                    sortable: true
                },
                {
                    key     : 'lastName',
                    label   : 'Last Name',
                    sortable: true
                },
                {
                    key     : 'total',
                    sortable: true
                },
                {
                    key: 'paidInFull',
                    sortanle: true
                },
                {
                    key: 'createdTime',
                    label   : 'Created',
                    sortable: true
                },
                {
                    key: 'fulfilledTime',
                    label   : 'Fulfilled',
                    sortable: true
                },
                {
                    key: 'actions',
                    sortable: false
                }
            ]
    	}
    },

    created() {
    	this.fetchOrders();
    },

    mounted() {},

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
                self.totalRows = this.ordersListArray.length;
    		})
    		.catch(err => console.error(err));
    	}

    },

}
</script>