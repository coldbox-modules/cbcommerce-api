<template>

	<div>

        <page-header
            :headerTitle="$t( 'customers' )"
            :displayToolBarButton="true"
            routeName="newCustomer"
            buttonIconClass="fa fa-plus">    
        </page-header>

        <b-row>

            <b-col md="6" offset-md="6" class="my-1">
                <b-form-group horizontal class="mb-0">
                    <b-input-group>
                        <b-form-input v-model="searchParams.search" @change="refreshList" :placeholder="$t( 'type_search' )" />
                        <b-input-group-append>
                            <b-btn :disabled="!searchParams.search" @click="searchParams.search = null;refreshList( $event )">{{ $t( 'clear' ) }}</b-btn>
                        </b-input-group-append>
                    </b-input-group>
                </b-form-group>
            </b-col>

        </b-row>

        <b-table
            striped
            ref="usersTable"
            :items="fetchCustomers"
            :busy.sync="isLoading"
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

        <b-row>
            <b-col xs="12">
              <generic-loader v-if="isLoading" :message="$t( 'customers_loading' )"></generic-loader>
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
import moment from "moment";
import TableRow from "./table-row";
export default {

	components: {
		TableRow
	},

    data() {
    	return {
            isLoading     : false,
            currentPage   : 1,
            perPage       : 25,
            totalRows     : 0,
            searchParams  : {},
            customerFields: [
                {
                    key: 'firstName',
                    sortable: true
                },
                {
                    key: 'lastName',
                    sortable: true
                },
                {
                    key: 'email',
                },
                {
                    key: 'primaryPhone'
                },
                {
                    key: 'createdTime',
                    sortable: true
                },
                {
                    key: 'actions',
                    sortable: false
                }
            ]
    	}
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
        refreshList( e ){
            this.$refs.usersTable.refresh();
        },
    	fetchCustomers( ctx ){
    		const self = this;
            Vue.set( self, "isLoading", true );
            self.searchParams[ "page" ] = self.currentPage;
            self.searchParams[ "maxRows" ] = self.perPage;
            let promise = this.getListOfCustomers( self.searchParams );
            return promise.then( ( results ) => {
                self.isLoading = false;
                self.currentPage = parseInt( results.meta.pagination.page );
                self.perPage = parseInt( results.meta.pagination.maxrows );
                self.totalRows = parseInt( results.meta.pagination.total );
                const customersArray = self.$options.filters.denormalize( results );
                return( customersArray );
            })
            .catch( error => {
                return [];
            })
    	}

    },

}
</script>