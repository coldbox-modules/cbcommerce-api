<template>

	<div>
        
        <page-header
            headerTitle="Products"
            :displayToolBarButton="true"
            routeName="newProduct"
            buttonIconClass="fa fa-plus">    
        </page-header>

        <b-row>

            <b-col md="6" offset-md="6" class="my-1">
                <b-form-group horizontal class="mb-0">
                    <b-input-group>
                        <b-form-input v-model="searchParams.search" @change="refreshList" placeholder="Type to Search" />
                        <b-input-group-append>
                            <b-btn :disabled="!searchParams.search" @click="searchParams.search = null;refreshList( $event )">Clear</b-btn>
                        </b-input-group-append>
                    </b-input-group>
                </b-form-group>
            </b-col>

        </b-row>
        
        <b-table
            striped
            ref="productsTable"
            :items="fetchProducts"
            :busy.sync="isLoading"
            :fields="productsFields"
            :current-page="currentPage"
            :per-page="perPage">
            <template slot="thumbnail" slot-scope="data">
                <router-link 
                    @click.stop
                    :to="{ name: 'productForm', params: { id: data.item.id } }">
                    <b-img v-if="data.value"
                        thumbnail 
                        :src="data.value" 
                        fluid 
                        :alt="data.item.name" 
                        :title="data.item.name" 
                        width="80" 
                        height="80" />
                </router-link>
            </template>
            <template slot="name" slot-scope="data">
                <router-link 
                    @click.stop
                    :to="{ name: 'productForm', params: { id: data.item.id } }">
                    {{ data.item.name }}
                </router-link>
            </template>
            <template slot="createdTime" slot-scope="data">
                {{ data.item.createdTime | dateToText }}
            </template>
            <template slot="fulfilledTime" slot-scope="data">
                {{ data.item.fulfilledTime | dateToText }}
            </template>
            <template slot="isActive" slot-scope="data">
                {{ data.item.isActive | itemStatusToText }}
            </template>
            <template slot="actions" slot-scope="data">
                <router-link 
                    @click.stop
                    :to="{ name: 'productForm', params: { id: data.item.id } }" 
                    class="btn btn-success float-right">
                    <i class="fa fa-eye"></i>
                </router-link>
            </template>
        </b-table>

        <b-row>
            <b-col xs="12">
              <generic-loader v-if="isLoading" message="Loading products. Please wait..."></generic-loader>
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
export default {

    data() {
    	return {
            isLoading     : false,
            currentPage   : 1,
            perPage       : 25,
            totalRows     : 0,
            searchParams  : {
                page : 1,
                maxrows : 25
            },
            productsFields: {
                thumbnail: {
                    formatter: ( value, key, item ) => {
                        const primaryMedia = this.$options.filters.denormalize( item.media ).filter( mediaItem => mediaItem.isPrimary );
                        return ( primaryMedia.length ) ? primaryMedia[ 0 ].src : '';
                    }
                },
                name: {
                    sortable: true
                },
                createdTime: {
                    label   : 'Created',
                    sortable: true
                },
                modifiedTime: {
                    label   : 'Modified',
                    sortable: true
                },
                isActive: {
                    label     : 'Status',
                    sortable: true
                },
                actions: {
                    sortable: false
                }
            }
    	}
    },

    created() {},

    mounted() {},

    computed: {

    	...mapGetters([
    		"productsList",
    		"productsListArray",
    		"activeCategoryId"
    	])

    },

    methods: {
    	
    	...mapActions([
    		"getListOfProducts",
    		"setCurrentProduct",
    		"clearCurrentProduct"
        ]),
        
        refreshList( e ){
            this.$refs.productsTable.refresh();
        },

    	fetchProducts( ctx ){
    		const self = this;
            Vue.set( self, "isLoading", true );
            self.searchParams[ "page" ] = self.currentPage;
            self.searchParams[ "maxRows" ] = self.perPage;
            let promise = this.getListOfProducts( self.searchParams );
            return promise.then( ( results ) => {
                self.isLoading = false;
                self.currentPage = parseInt( results.meta.pagination.page );
                self.perPage = parseInt( results.meta.pagination.maxrows );
                self.totalRows = parseInt( results.meta.pagination.total );
                const productsArray = self.$options.filters.denormalize( results );
                return( productsArray );
            })
            .catch( error => {
                return [];
            })
    	}

    },

}
</script>