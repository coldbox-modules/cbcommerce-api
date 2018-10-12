<template>

    <div>

        <div v-if="isLoading"
            v-for="(fake, index) in fakes"
            :key="index">

            <product-list-item-loading></product-list-item-loading>

        </div>

        <div v-if="!isLoading"
            v-for="(product, index) in products"
            :key="index">
            <product-list-item :product="product"></product-list-item>

        </div>

    </div>

</template>

<script>
import ProductListItem from './product-list-item';
import ProductListItemLoading from './product-list-item-loading';
export default {
    components: {
        ProductListItemLoading,
        ProductListItem
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

    methods: {}

}
</script>