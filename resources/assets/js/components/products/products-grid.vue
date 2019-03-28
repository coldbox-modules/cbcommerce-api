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
                <product-item :product="product" v-on:quote-sku="showSkuQuoteForm"></product-item>

            </div>
        </div>

        <sku-quote-modal v-if="quotedSKUId && showQuoteModal" v-on:quote-modal-close="toggleModal" :skuId="quotedSKUId"></sku-quote-modal>

    </div>

</template>

<script>
import ProductItem from './product-item';
import ProductItemLoading from './product-item-loading';
import SkuQuoteMixin from '@cbCommerce/mixins/sku-quote-mixin';

export default {
    mixins : [ SkuQuoteMixin ],
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