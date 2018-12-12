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
                :isList="isList"></filter-bar>

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
    data() {
        return {
            fakes    : 3,
            products : null,
            isLoading: false,
            isGrid   : true,
            isList   : false,
            sortBy   : 'price:asc',
            perPage  : 5,
            minPrice : 0,
            maxPrice : 1000,
            pageCount: 10
        }
    },

    created() {
        this.isLoading = true;
    },

    mounted() {
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
            const self = this;
            Promise.resolve(this.getListOfProducts())
            .then(() => {
                self.isLoading = false;
                self.setPagination();
            })
            .catch(err => console.error(err));
        },

        paginationCallback( pageNum ){
            console.log( pageNum );
        },

        setPagination(){
            this.pageCount = this.productsListArray.length / this.perPage;
        },

        minPriceRangeChange(){
            if( isNaN( this.minPrice ) ){ 
                this.minPrice = 0;
            }
            if( this.minPrice >= this.maxPrice ){
                this.minPrice = this.maxPrice - 1;
            }
            this.fetchProducts();
        },

        maxPriceRangeChange(){
            if( isNaN( this.maxPrice ) || this.maxPrice == 0 ){ 
                this.maxPrice = 1000;
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
            this.sortBy = sortBy;
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