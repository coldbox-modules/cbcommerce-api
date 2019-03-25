<template>
    <div>
        <div class="header-for-light">
            <h1 class="wow fadeInRight animated animated" data-wow-duration="1s" v-html="$t( 'wishlists_title' )"></h1>
        </div>
        <div v-if="!wishlists" class="overlay">
            <generic-loader message="Loading wishlists. Please wait..."></generic-loader>
        </div>
        <div 
            v-else
            v-for="wishlistId in wishlists.results" 
            :key="wishlistId"
            class="wishlists-grid-item col-md-4 col-sm-6 col-xs-12"
            >
                <wishlists-grid-item :wishlist="wishlists.resultsMap[ wishlistId ]"></wishlists-grid-item>
        </div>
        <div class="wishlists-grid-item col-md-4 col-sm-6 col-xs-12">
            <article id="new-wishlist" class="wishlist light">
                <figure class="figure-hover-overlay text-center">
                    <v-popover 
                        :disabled="disablePopover"
                        placement="right"
                    >
                        <button class="tooltip-target btn btn-primary btn-lg">
                            <i class="fa fa-plus"></i> {{$t( 'add_new_wishlist' )}}
                        </button>
                        <template slot="popover">
                            <wishlist-form v-on:wishlist-saved="onWishlistSaved">
                                <template slot="exit">
                                    <a id="new-wishlist-close" class="text-muted pull-left" v-close-popover><i class="fa fa-undo"></i> Cancel</a>
                                </template>
                            </wishlist-form>
                        </template>
                    </v-popover>
                </figure>
            </article>
        </div>
    </div>
</template>

<script>
import { mapState, mapGetters, mapMutations } from "vuex";
let wishlistsMixin = require( '@cbCommerce/mixins/wishlists-mixin.js' ).default;

export default {
    data(){
        return {
            disablePopover : false
        }
    },
    mixins :[ wishlistsMixin ],
    computed: {
        ...mapState( {
            wishlists : state => state.wishlists.wishlists
        }),
        ...mapGetters([ "authUser" ] )
    },
    methods : {
        ...mapMutations( [ "appendWishlist" ] ),
        onWishlistSaved( wishlist ){
            var self = this;
            this.appendWishlist( wishlist );
            Vue.set( this, "disablePopover", true );
            // reset the popover availability
            setTimeout( function( ){
                Vue.set( self, "disablePopover", false );
            }, 300 )
            
        }
    },
    mounted(){
        if( !this.authUser ){
            window.location.assign( '/store/account/login' );
        }
    }

}
</script>
