<template>

	<div>
        
        <page-header
            :headerTitle="$t( 'products' )"
            :displayToolBarButton="true"
            routeName="newProduct"
            buttonIconClass="fa fa-plus">    
        </page-header>

        <b-row>

            <b-col md="3">
                <b-row>
                    <b-input-group class="col col-12">
                        <b-form-input v-model="searchParams.search" @change="refreshList" :placeholder="$t( 'type_search')" />
                        <b-input-group-append>
                            <b-btn :disabled="!searchParams.search" @click="searchParams.search = null;refreshList( $event )">{{ $t( 'clear' ) }}</b-btn>
                        </b-input-group-append>
                    </b-input-group>
                </b-row>
                <b-row>
                    <b-form-group class="col col-12">
                        <legend>{{ $t( 'condition' ) }}</legend>
                        <b-form-radio-group
                            v-model="searchParams.condition"
                            :options="conditionOptions"
                            name="productCondition"
                            @input="refreshList"
                            stacked
                        ></b-form-radio-group>
                    </b-form-group>
                </b-row>
                <b-row>
                    <b-form-group class="col col-12">
                        <legend>{{ $t( 'product_tag_search' ) }}</legend>
                        <b-form-input v-model="searchParams.externalIdSearch" @change="refreshList" :placeholder="$t( 'products_tag_search' )" />
                    </b-form-group>
                </b-row>
                <b-row>
                    <b-form-group class="col col-12">
                        <legend>{{ $t( 'product_model_search' ) }}</legend>
                        <b-form-input v-model="searchParams.modelNumber" @change="refreshList" :placeholder="$t( 'products_model_search' )" />
                    </b-form-group>
                </b-row>
            </b-col>

            <b-col md="9">

                <b-row>
                    <b-col xs="12">
                    <generic-loader v-if="isLoading" :message="$t( 'products_loading' )"></generic-loader>
                    </b-col>
                </b-row>

                <b-table
                    v-show="!isLoading"
                    striped
                    ref="productsTable"
                    :items="fetchProducts"
                    :busy.sync="isLoading"
                    :fields="productsFields"
                    :current-page="currentPage"
                    :per-page="perPage">
                    <template v-slot:cell(thumbnail)="data">
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
                    <template v-slot:cell(name)="data">
                        <router-link 
                            @click.stop
                            :to="{ name: 'productForm', params: { id: data.item.id } }">
                            {{ data.item.name }}
                        </router-link>
                    </template>
                    <template v-slot:cell(externalId)="data">
                        {{ data.item.externalId }}
                    </template>
                    <template v-slot:cell(isActive)="data">
                        {{ data.item.isActive | itemStatusToText }}
                    </template>
                    <template v-slot:cell(actions)="data">
                        <router-link 
                            @click.stop
                            :to="{ name: 'productForm', params: { id: data.item.id } }" 
                            class="btn btn-success float-right">
                            <i class="fa fa-eye"></i>
                        </router-link>
                    </template>
                </b-table>

                <table-pagination
                    v-if="!isLoading && productsListArray.length"
                    :totalRows="totalRows"
                    :perPage="perPage"
                    :currentPage="currentPage">
                </table-pagination>
            </b-col>

        </b-row>

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
                maxrows : 25,
                condition: 'New',
                activeSKUsOnly : false
            },
            conditionOptions : [ { text : this.$t( 'new' ), value : "New" }, {text : this.$t( 'used' ), value : "Used" } ],
            productsFields: [
                {   
                    key: 'thumbnail',
                    formatter: ( value, key, item ) => {
                        const primaryMedia = this.$options.filters.denormalize( item.media ).filter( mediaItem => mediaItem.isPrimary );
                        return ( primaryMedia.length ) ? primaryMedia[ 0 ].src : '';
                    }
                },
                {
                    key: 'name',
                    sortable: true
                },
                {
                    key: 'externalId',
                    label   : 'Reference Number',
                    sortable: true
                },
                {
                    key: 'isActive',
                    label     : 'Status',
                    sortable: true
                },
                {
                    key: 'actions',
                    sortable: false
                }
            ]
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
            self.isLoading=true;
            self.searchParams[ "page" ] = self.currentPage;
            self.searchParams[ "maxRows" ] = self.perPage;
            let promise = this.getListOfProducts( self.searchParams );
            return promise.then( ( results ) => {
                self.currentPage = parseInt( results.meta.pagination.page );
                self.perPage = parseInt( results.meta.pagination.maxrows );
                self.totalRows = parseInt( results.meta.pagination.total );
                const productsArray = self.$options.filters.denormalize( results );
                return( productsArray );
                self.isLoading=false;
            })
            .catch( error => {
                return [];
            })
    	}

    },

}
</script>