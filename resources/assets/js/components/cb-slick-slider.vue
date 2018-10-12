<template>
	<div :style="{ height: slidesHeight + 'px' }">
		<slick ref="my-slider" :options="slickOptions">
			<div
				v-for="( i, itemIdx ) in items"
				class="slide"
				:style="{ 'background-image': slideBackground( i.IMAGEURL ) }"
				:key="'slide-' + itemIdx">

				<div class="caption">
					<div class="slick-slide-title">
						{{ i.TITLE }}
					</div>
					<div class="slick-slide-content" v-html="i.CONTENT"></div>
					<div class="slick-slide-buttons" v-if="i.BUTTON1TEXT != '' && i.BUTTON1URL != ''">
						<a :href="i.BUTTON1URL" class="btn btn-lg btn-secondary">
							{{ i.BUTTON1TEXT }}
						</a>

						<a :href="i.BUTTON2URL" class="btn btn-lg btn-secondary" v-if="i.BUTTON2TEXT != '' && i.BUTTON2URL != ''">
							{{ i.BUTTON2TEXT }}
						</a>
					</div>
				</div>
			</div>
		</slick>

	</div>
</template>
<script>
	import Slick from 'vue-slick';

	export default{
		props:{
			slides: {
				type: Array
			}
		},
		components: {
			Slick
		},
		mounted() {
			let that = this;
	        this.$nextTick( function(){
	        	this.initializeSlick();
	        	window.addEventListener('resize', function( e ) {
			        that.windowHeight = window.innerHeight;
			     });
	        } );
	    },
		data () {
	      return {
	      	slidesHeight: window.innerHeight - 150,
	      	slickOptions: {
                slidesToShow: 1,
                autoplay: true,
                autoplaySpeed: 4000,
                fade: true,
                arrows: true
            },
	        items: this.slides
	      }
	    },
	    methods: {
	    	slideBackground: function( imageUrl ){
	    		if( imageUrl != "" ){
	    			return 'url(' + imageUrl + ')';
	    		}
	    	},
	    	initializeSlick: function(){
	    		$('.my-slider').slick({

				});
		    }
	    }
	}
</script>
<style>


</style>
