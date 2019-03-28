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
            <product-list-item :product="product" v-on:quote-sku="showSkuQuoteForm"></product-list-item>

        </div>

        <sku-quote-modal v-if="quotedSKUId && showQuoteModal" v-on:quote-modal-close="toggleModal" :skuId="quotedSKUId"></sku-quote-modal>

    </div>

</template>

<script>
import ProductListItem from './product-list-item';
import ProductListItemLoading from './product-list-item-loading';
import SkuQuoteMixin from '@cbCommerce/mixins/sku-quote-mixin';
export default {
    mixins : [ SkuQuoteMixin ],
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