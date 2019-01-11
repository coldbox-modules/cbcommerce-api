<template>

    <div>

        <div class="col-md-3">

            <div class="widget-title first-widget">
                <i class="fa fa-money"></i> Price range
            </div>
            <div class="widget-block">
                <div class="row">
                    <div class="col-md-6">
                        <div class="input-group">
                            <span class="input-group-addon">&dollar;</span>
                            <input 
                                @keyup.tab="minPriceRangeChange()"
                                @keyup.enter="minPriceRangeChange()"
                                @change="minPriceRangeChange()"
                                type="text" 
                                id="price-from" 
                                class="form-control" 
                                v-model.number="minPrice" />
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="input-group">
                            <span class="input-group-addon">&dollar;</span>
                            <input 
                                @keyup.tab="maxPriceRangeChange()"
                                @keyup.enter="maxPriceRangeChange()"
                                @change="maxPriceRangeChange()"
                                type="text" 
                                id="price-to" 
                                class="form-control" 
                                v-model.number="maxPrice" />
                        </div>
                    </div>
                </div> 
            </div>

        </div>

        <div class="col-md-9">

            <filter-bar 
                v-on:productLayoutChange="productLayoutChangeReaction"
                v-on:perPageChange="perPageChangeReaction"
                v-on:sortTypeChange="sortTypeChangeReaction"
                :isGrid="isGrid"
                :isList="isList"
                :perPage="perPage"></filter-bar>

            <div v-if="!isLoading">
                <products-grid 
                    v-if="this.isGrid" 
                    :products="this.productsListArray"
                    :isLoading="isLoading"
                    :fakes="fakes"
                ></products-grid>

                <products-list 
                    v-if="this.isList" 
                    :products="this.productsListArray"
                    :isLoading="isLoading"
                    :fakes="fakes"
                ></products-list>
            </div>

            <div v-else>
                <div class="col-md-4" v-for="(n, index) in 25" :key="`loading-${index}`">
                    <product-item-loading></product-item-loading>
                </div>
            </div>

            <div class="block-pagination" v-if="!isLoading">

                <paginate
                    :pageCount="pageCount"
                    :prevText="'Prev'"
                    :nextText="'Next'"
                    :containerClass="'pagination'"
                    :click-handler="paginationCallback"
                    :hide-prev-next="true"
                ></paginate>

            </div>

        </div>

    </div>

</template>

<script>
import { mapGetters, mapActions } from "vuex";
import Paginate from 'vuejs-paginate'
import FilterBar from "./filter-bar";
import ProductsGrid from './products-grid';
import ProductsList from './products-list';
import ProductItemLoading from './product-item-loading';
export default {
    components: {
        Paginate,
        FilterBar,
        ProductsGrid,
        ProductsList,
        ProductItemLoading
    },
    props: {
        initialParams : {
            type : Object,
            required : false
        }
    },
    data() {
        return {
            fakes    : 3,
            products : null,
            isLoading: true,
            isGrid   : true,
            isList   : false,
            sortBy   : 'price:asc',
            perPage  : 15,
            currentPage : 1,
            minPrice : 0,
            maxPrice : 1000,
            pageCount: 10,
            searchParams : {}
        }
    },

    created() {
        if( this.initialParams ){
            Vue.set( this, "searchParams", this.initialParams );
        }
        this.fetchProducts();
    },

    computed: {
        ...mapGetters([
            "productsListArray",
            "productsList",
            "currentProductID"
        ])
    },

    methods: {

        ...mapActions([
            "getListOfProducts",
            "setCurrentProduct",
            "clearCurrentProduct",
            "addItemToCart"
        ]),

        fetchProducts(){
            var self = this;
            Vue.set( self, "isLoading", true );
            Object.assign( self.searchParams, { maxrows : self.perPage, page : self.currentPage });
            self.getListOfProducts( self.searchParams ).then( productsMap => {
                Vue.set( self, "isLoading", false );
                self.setPagination( productsMap.meta.pagination );
            } );
        },

        paginationCallback( pageNum ){
            Vue.set( self, "currentPage", pageNum );
            this.fetchProducts();
        },

        setPagination( pagination ){
            var self = this;
            Vue.set( self, "currentPage" , pagination.page );
            Vue.set( self, "perPage", pagination.maxrows );
            Vue.set( self, "pageCount", pagination.total / pagination.maxrows );
        },

        minPriceRangeChange(){
            if( isNaN( this.minPrice ) ){ 
                delete this.searchParams.minimumPrice;
            } else {
                this.searchParam.minimumPrice=this.minPrice;
            }
            if( this.minPrice >= this.maxPrice ){
                this.minPrice = this.maxPrice - 1;
            }
            this.fetchProducts();
        },

        maxPriceRangeChange(){
            if( isNaN( this.maxPrice ) || this.maxPrice == 0 ){ 
                delete this.searchParams.maximumPrice
            } else {
                this.searchParams.maximumPrice=this.maxPrice;
            }
            if( this.maxPrice <= this.minPrice ){
                this.maxPrice = this.minPrice + 1;
            }
            this.fetchProducts();
        },

        perPageChangeReaction(perPage){
            this.perPage = perPage;
            this.fetchProducts();
        },

        sortTypeChangeReaction(sortBy){
            if( !sortBy ){
                delete this.searchParms.sortBy;
            } else {
                this.searchParams.sortBy = sortBy;
            }
            this.fetchProducts();
        },

        productLayoutChangeReaction(type){
            switch( type ){
                case 'grid':
                    this.isGrid = true;
                    this.isList = false;
                    break;
                case 'list':
                    this.isGrid = false;
                    this.isList = true;
                    break;
            }
        }

    }
}
</script>