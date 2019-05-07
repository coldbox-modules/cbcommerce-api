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

            <div v-if="activeCategory" class="widget-title">
                <i class="fa fa-arrow-circle-down"></i> Sub-Categories
            </div>
            <div v-if="activeCategory" class="widget-block">
                <div class="overlay" v-if="isLoading">
                    <generic-loader message="Please wait..."></generic-loader>
                </div>

                <div class="row">
                    <div class="col-xs-12">
                        <ul class="subcategory-links list-unstyled">
                            <li
                                v-for="category in activeCategory.children"
                                :key="`subcat_${category.id}`">
                                <label>
                                <input 
                                    type="checkbox"
                                    :name="`category_${category.id}`"
                                    :value="category.id"
                                    @change="categoriesFilterChange"> {{category.name}}</label>

                                <ul class="subcategory-links list-unstyled">
                                    <li
                                        v-for="categoryc in activeCategory.children"
                                        :key="`subcat_${categoryc.id}`">
                                        <label>
                                        <input v-if="categoryc.id==category.FK_parent"
                                            type="checkbox"
                                            :name="`category_${categoryc.id}`"
                                            :value="categoryc.id"
                                            @change="categoriesFilterChange"> {{activeCategory.children.FK_parent}}</label>
                            </li>

                        </ul>

                            </li>

                        </ul>
                    </div>
                </div> 
            </div>
            <div v-if="searchParams.condition && categoriesListArray.length" class="widget-title">
                <i class="fa fa-arrow-circle-down"></i> {{searchParams.condition}} Categories
            </div>
            <div v-if="searchParams.condition && categoriesListArray.length" class="widget-block">
                <generic-loader v-if="categoriesLoading" message="Loading categories..."></generic-loader>
                <div v-else class="row">
                    <div class="col-xs-12">
                        <ul class="subcategory-links list-unstyled">
                            <li
                                v-for="category in categoriesListArray"
                                :key="`subcat_${category.id}`">
                                <label>
                                <input 
                                    type="checkbox"
                                    :name="`category_${category.id}`"
                                    :value="category.id"
                                    @change="categoriesFilterChange">{{category.name}}</label>
                            </li>

                        </ul>
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

            <div v-if="isLoading">
                <div class="col-md-4" v-for="(n, index) in 25" :key="`loading-${index}`">
                    <product-item-loading></product-item-loading>
                </div>
            </div>

            <div v-else-if="!this.productsListArray.length">
                <div class="text-center alert alert-info">
                    <h5 class="text-center">There are no products matching the requested criteria</h5>
                </div>

            </div>

            <div v-else>
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

            <div class="block-pagination" v-if="!isLoading">

                <paginate
                    :initial-page="currentPage-1"
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
import { mapGetters, mapActions, mapState, mapMutations } from "vuex";
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
            categoriesLoading: false,
            isGrid   : true,
            isList   : false,
            sortBy   : 'price:asc',
            perPage  : 15,
            currentPage : 1,
            minPrice : 0,
            maxPrice : 1000,
            pageCount: 10,
            searchParams : {
                condition : "New"
            },
            filterCategories : []
        }
    },

    created() {
        var self = this;
        if( this.initialParams ){
            Object.assign( this.searchParams, this.initialParams );
        }
        this.fetchProducts();

        if( self.searchParams.condition && self.searchParams.condition !== "New"  ){
            Vue.set( self, "categoriesLoading", true );
            this.getCategories( { "productCondition" : self.searchParams.condition } )
                    .then( 
                        categoriesMap => {  
                            Vue.set( self, "categoriesLoading", false );
                        }
                    );
        }
    },

    computed: {
        ...mapGetters([
            "productsListArray",
            "productsList",
            "currentProductID",
            "activeCategory",
            "categoriesListArray"
        ])
    },

    methods: {

        ...mapActions([
            "getListOfProducts",
            "setCurrentProduct",
            "clearCurrentProduct",
            "addItemToCart",
            "getCategories"
        ]),

        fetchProducts(){
            var self = this;
            Vue.set( self, "isLoading", true );
            self.searchParams.maxrows = parseInt( self.perPage );
            self.searchParams.page = self.currentPage;
            self.getListOfProducts( self.searchParams ).then( productsMap => {
                self.setPagination( productsMap.meta.pagination );
                Vue.set( self, "isLoading", false );
            } );
        },

        paginationCallback( pageNum ){
            Vue.set( this, "currentPage", pageNum );
            this.fetchProducts();
        },

        setPagination( pagination ){
            var self = this;
            Vue.set( self, "currentPage" , pagination.page );
            Vue.set( self, "perPage", pagination.maxrows );
            Vue.set( self, "pageCount", Math.ceil( pagination.total / pagination.maxrows ) );
        },

        categoriesFilterChange( e ){
            console.log( e.target.value );
            let categoryId = e.target.value;
            if( this.filterCategories.indexOf( categoryId ) > -1 ){
                this.filterCategories.splice( this.filterCategories.indexOf( categoryId ), 1 );
            } else {
                this.filterCategories.push( categoryId );
            }
            if( this.filterCategories.length ){
                this.searchParams.category = this.filterCategories.join(',');
            } else {
                this.searchParams.category = this.initialParams.category;
            }
            this.fetchProducts();
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