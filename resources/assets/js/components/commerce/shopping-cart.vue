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
                    v-for="(product, index) in products"
                    :key="index">

                    <td class="card_product_image" data-th="Image">
                        <img 
                            :title="product.productName" 
                            :alt="product.productName" 
                            :src="product.image" />
                    </td>
                    <td class="card_product_name" data-th="Product Name">
                        {{ product.productName }}
                    </td>
                    <td class="card_product_quantity" data-th="Quantity">

                        <input 
                            disabled="disabled" 
                            type="number" value="1" class="styler" />

                    </td>
                    <td class="card_product_price" data-th="Unit Price">
                        {{ product.userPrice }}
                    </td>
                    
                    <td class="card_product_total" data-th="Total">
                        {{ product.userPrice }}
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
        // TODO: this can be removed at at later time when the API and persistence is working
        this.fetchProducts();
        //
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
        },

        // TODO: this can be removed once the API and persistence is in place
        fetchProducts() {
            const self = this;
            Promise.resolve(this.getListOfProducts())
            .then(() => {
                self.isLoading = false;
                // Mocking a limited result set here by slicing
                self.products = this.productsListArray.slice( 1, 4 );
            })
            .catch(err => console.error(err));
        }

    }

}

</script>