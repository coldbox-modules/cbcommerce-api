<template>
    <div>
        <div v-for="(n,index) in itemsOnStage" :key="`grid-loading-${index}`" class="col-md-3">
            <product-item-loading></product-item-loading>
        </div>
    </div>
</template>
<script>
    import ProductItemLoading from "@cbCommerce/components/products/product-item-loading";
    export default{
        props: {
            itemsOnStage: {
                type   : Number,
                default: 4
            }
        },
        components: {
            ProductItemLoading
        }
    }
</script>