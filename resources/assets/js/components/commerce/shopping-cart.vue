<template>

    <div class="box-border">

        <table class="cart-table table wow fadeInLeft animated">

            <thead>
                <tr>
                    <td class="card_product_image">Image</td>
                    <td class="card_product_name">Product Name</td>
                    <td class="card_product_quantity">Quantity</td>
                    <td class="card_product_price">Unit Price</td>
                    <td class="card_product_total">Total</td>
                </tr>
            </thead>

            <tbody>
                
                <tr
                    v-if="cartProducts"
                    v-for="(item, index) in cartProducts"
                    :key="index">

                    <td class="card_product_image" data-th="Image">
                        <a :href="`/store/product/${item.product.id}`">
                            <img 
                                :title="item.product.name" 
                                :alt="item.product.name" 
                                :src="item.sku.image ? item.sku.image.href : item.product.image.href" />
                        </a>
                    </td>
                    <td class="card_product_name" data-th="Product Name">
                        <a :href="`/store/product/${item.product.id}`">{{ item.product.name }}</a>
                    </td>
                    <td class="card_product_quantity" data-th="Quantity">

                        <input 
                            disabled="disabled" 
                            type="number" :value="item.quantity" class="styler" />

                    </td>
                    <td class="card_product_price" data-th="Unit Price">
                        {{ item.sku.basePrice | currency }}
                    </td>
                    
                    <td class="card_product_total" data-th="Total">
                        {{ item.quantity * item.sku.basePrice | currency }}
                    </td>

                </tr>

            </tbody>

        </table>

    </div>

</template>

<script>
import { mapGetters, mapActions } from "vuex";
import imagesLoaded from 'vue-images-loaded';
export default {
    directives: {
        imagesLoaded
    },
    data() {
        return {
            isLoading: false,
            products : null
        }
    },

    created() {
        this.isLoading = true;
    },

    mounted() {
        // this.product = this.cartProducts;
        this.isLoading = false;
    },

    destroyed() {},

    computed: {
        ...mapGetters([
            "currentProduct",
            "productsListArray",
            "productsList",
            "cartProducts",
            "wishlistProducts",
            "comparisonProducts"
        ])
    },

    methods: {

        ...mapActions([
            "setCurrentProduct",
            "clearCurrentProduct",
            "getListOfProducts",
            "addItemToCart",
            "addProductToWishlist",
            "addProductToComparisonList"
        ]),

        availabilityText( inStock ){
            return ( inStock ) ? 'In Stock' : 'Out Of Stock';
        }

    }

}

</script>