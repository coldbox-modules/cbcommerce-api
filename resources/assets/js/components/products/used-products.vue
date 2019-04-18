<template>
    <div class="category-detail">
        <div class="col-md-12 productDetailHeader">
            <h1 class="wow fadeInRight animated animated" data-wow-duration="1s">Used Products</h1>
        </div>
        <div class="col-xs-12 category-products">
            <product-filter-page :initialParams="searchParams"></product-filter-page>
        </div>
    </div>
</template>
<script>
import ProductFilterPage from '@cbCommerce/components/products/product-filter-page';

export default{
    components: {
        ProductFilterPage
    },
    title(){
        return 'Used Products | ' + document.title;
    },
    data(){
        return {
            searchParams : {
                condition : "Used"
            }
        }
    },
    created(){
        var self = this;
        let queryParams = new URLSearchParams( window.location.search );
        queryParams.forEach( ( value, key ) => {
            this.searchParams[ key ] = value;
        }  );
    }
}
</script>