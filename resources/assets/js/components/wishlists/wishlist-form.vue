<template>
    <div class="wishlist-form form-block">
        <div class="form-group">
            <label class="col-xs-12 text-left text-muted">{{ $t( 'wishlist_name' ) }}</label>
            <input class="form-control" v-model="wishlist.name"/>            
        </div>
        <div class="form-group">
            <label class="col-xs-12 text-left text-muted">{{ $t( 'Description' ) }}</label>
            <textarea id="new-wishlist-description" class="form-control" rows="5" :v-model="wishlist.description"></textarea>            
        </div>
        <div class="form-group">
            <slot name="exit"></slot>
            <button class="btn btn-primary" @click="onSaveWishlist"><i class="fa fa-save"></i> {{$t( 'save_wishlist' )}}</button>
        </div>
    </div>
</template>
<script>
import { mapGetters, mapActions } from "vuex";
export default{
    props : {
        wishlistData : {
            type: Object,
            required : false
        }
    },
    data(){
        return {
            wishlist : {
                "name" : "",
                "description" : "",
                "isDefault" : false
            }
        };
    },
    methods : {
        ...mapActions( [ "saveWishlist" ] ),
        onSaveWishlist( e ){
            var self = this;
            var $btn = $( e.currentTarget );
            $( 'i', $btn ).removeClass( 'fa-save' ).addClass( 'fa-spin fa-spinner' );
            this.saveWishlist( this.wishlist )
                    .then( ( { data } ) => {
                        // reset form
                        Vue.set( self.wishlist, "name", "" );
                        Vue.set( self.wishlist, "description", "" );
                        Vue.set( self.wishlist, "isDefault", false );
                        $( "#new-wishlist-description" ).val( '' );
                        $( 'i', $btn ).removeClass( 'fa-spin fa-spinner' ).addClass( 'fa-save' );

                        // Annunciate
                        self.$emit( "wishlist-saved", data );
                    })
                    .catch( err => {
                        console.error( err );
                    } )
        }
    },
    mounted(){
        if( this.wishlistData ){
            Object.assign( this.wishlist, this.wishlistData )
        } 
    }


}
</script>