<template>
    <article class="wishlist light">
        <div v-if="wishlist.isDefault" class="btn btn-secondary light-header-callout">
            <span class="text-upper pull-left">Active</span>
            <span class="pull-right">
                <strong>Updated:</strong> {{ lastUpdateDisplay }}
            </span>
        </div>
        
        <div v-else class="btn light-header-callout">
            <span class="pull-right">
                <strong>Updated:</strong> {{ lastUpdateDisplay }}
            </span>
        </div>

        <figure class="figure-hover-overlay">
            <a :href="`/store/wishlist/${wishlist.id}`">
                <div class="wishlist-item-image" v-if="primaryImage" :style="`background-image:url(${primaryImage})`"></div>
            </a>
        </figure>

        <div class="wishlist-caption">
            <div class="block-name">
                <a :href="`/store/wishlist/${wishlist.id}`" class="wishlist-name">{{ wishlist.name }}</a>
            </div>
        </div>

        <p class="wishlist-caption"><strong>Products:</strong> {{wishlist.items.length}}</p>

    </article>
</template>
<script>
import moment from "moment";
import { mapState } from "vuex";
export default{
    props : {
        wishlist : {
            type : Object,
            required : true
        }
    },
    computed : {
        ...mapState({
            primaryImage( state ){
                return this.wishlist.items.length ? this.wishlist.items[ 0 ].image : state.globalData.placeholderImage;
            }
        }),
        lastUpdateDisplay(){
            let today = moment( new Date() );
            let lastModified = moment( new Date( this.wishlist.modifiedTime ) );
            
            let diff = parseInt( moment.duration( today.diff( lastModified ) ).asDays() );
            console.log( diff );
            if( diff > 0 ){ 
                return diff + ( diff > 1  ? " days" : "day" ) + " ago";
            } else {
                return "Today";
            }
        }
    }
}
</script>