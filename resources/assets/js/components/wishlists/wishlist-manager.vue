<template>
     <div>
     	<div v-if="!wishlists" class="overlay">
     		<generic-loader message="Loading wishlists. Please wait..."></generic-loader>
     	</div>
        <div v-else>
		    <div 
				v-for="wishlistId in wishlists.results" 
				:key="wishlistId"
				class="col-md-4 col-sm-6 col-xs-12"
				:wishlist="wishlists.resultsMap[ wishlistId ]"
			>
		     	<article class="category light">

					<figure class="figure-hover-overlay">

						<img 
							:src="primaryImage( wishlist )"
							:alt="wishlist.name"
							class="img-responsive" 
						/>

					</figure>

					<div class="category-caption">
						<div class="block-name">
							<a :href="`/store/category/${wishlist.id}`" class="category-name">{{ wishlist.name }}</a>
						</div>
					</div>

					<p class="description">
						{{ wishlist.description }}
					</p>

					<sub-category-links 
						v-for="(subCat, index) in wishlist.children"
						:key="index"
						:subCat="subCat"></sub-category-links>

				</article>
			</div>
		</div>
    </div>

</template>

<script>
import { mapState, mapGetters, mapActions } from "vuex";
let wishlistsMixin = require( '@cbCommerce/mixins/wishlists-mixin.js' ).default;


export default {
	mixins :[ wishlistsMixin ],
    computed: {
        ...mapState( {
    		globalData   : 'globalData'
    	})
    },

    methods: {
    }

}

</script>