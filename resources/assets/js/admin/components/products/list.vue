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
                        <b-form-input v-model="searchParams.search" placeholder="Type to Search" />
                        <b-input-group-append>
                            <b-btn :disabled="!searchParams.search" @click="searchParams.search = null">Clear</b-btn>
                        </b-input-group-append>
                    </b-input-group>
                </b-form-group>
            </b-col>

        </b-row>

        <b-table
            striped
            :filter="searchParams.search"
            :items="productsListArray"
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
            isLoading     : true,
            currentPage   : 1,
            perPage       : 25,
            totalRows     : 0,
            searchParams  : {},
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

    created() {
    	this.fetchProducts();
    },

    mounted() {},

    computed: {

    	...mapGetters([
    		"productsList",
    		"productsListArray",
    		"currentCategoryID"
    	])

    },

    methods: {
    	
    	...mapActions([
    		"getListOfProducts",
    		"setCurrentProduct",
    		"clearCurrentProduct"
    	]),

    	fetchProducts(){
    		const self = this;
            Vue.set( self, "isLoading", true );
    		Promise.resolve( this.getListOfProducts( self.searchParams ) )
    		.then(() => {
                Vue.set( self, "isLoading", false );
    		})
    		.catch(err => console.error(err));
    	}

    },

}
</script>