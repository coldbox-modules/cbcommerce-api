import { mapGetters, mapActions } from "vuex";
export default {
    computed : {
        ...mapGetters([
            "defaultWishList",
            "wishlistItems"
        ])
    },
    methods : {
        ...mapActions([
            "addItemToWishlist"
        ]),
        onAddWishlistItem( e ){
            let $e = $( e.currentTarget );
            let sku = $e.data( 'sku' );
            this.addWishlistItem( { sku : sku } );
        }
    }
}