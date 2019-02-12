<template>

    <div class="row">

        <div v-if="isLoading">
            <div
                class="col-xs-12 col-sm-6 col-md-4 text-center mb-25"
                v-for="(fake, index) in fakes"
                :key="index">

                <product-item-loading></product-item-loading>

            </div>
        </div>

        <div v-if="!isLoading">
            <div
                class="col-xs-12 col-sm-6 col-md-4 text-center mb-25"
                v-for="(product, index) in products"
                :key="index">
                <product-item :product="product"></product-item>

            </div>
        </div>

    </div>

</template>

<script>
import ProductItem from './product-item';
import ProductItemLoading from './product-item-loading';
export default {
    components: {
        ProductItemLoading,
        ProductItem
    },
    props: [
        'products',
        'isLoading',
        'fakes'
    ],
    data() {
        return {}
    },

    created: function(){},

    mounted() {},

    destroyed() {},

    methods: {

    }
}
</script>