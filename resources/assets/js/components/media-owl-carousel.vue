<template>
	<div>

		<div  class="owl-carousel" :class="carouselClass" v-if="isLoading">
			<div class="pic">
				Images loading...
			</div>
		</div>
		<template v-else>
			<carousel
				class="owl-carousel"
				:class="carouselClass"
				:loop="loop"
				:autoplay="autoPlay"
				:nav="showNav"
				:dots="showDots"
				:margin="margin"
				:items="itemsOnStage"
				:responsive="{
					0:{
						items:1
					},
					600:{
						items:this.itemsOnStage - 1
					},
					1000:{
						items:this.itemsOnStage
					}
				}"
			>
				<template slot="default">
					<div class="item" v-for="item in carouselData" :key="item.id">
						<div class="pic" v-if="getValue( item.name, 'href' ) != ''">
							<a :href="getValue( item.name, 'href' )">
								<img class="img-responsive" :src="getMediaPath( item.name )" :alt="getValue( item.name, 'alt' )" />
							</a>
						</div>
						<div class="pic" v-else>
							<img class="img-responsive" :src="getMediaPath( item.name )" :alt="getValue( item.name, 'alt' )" />
						</div>
					</div>
				</template>
				<template slot="prev"><a class="prev"><i class="fa fa-angle-left"></i></a></template>
				<template slot="next"><a class="next"><i class="fa fa-angle-right"></i></a></template>
			</carousel>
		</template>
	</div>
</template>
<script type="application/javascript">
	import carousel from 'vue-owl-carousel';
	export default {
		components:{
			carousel
		},
		props: {
            carouselId: { 				// unique carousel Id
                type: String,
                required: true
            },
            carouselClass: {			// carousel class
            	type: String
            },
            mediaFolder: {				// media folder with images
            	type: String,
            	default: ""
            },
            fileList: {					// file list ( array of structs with each file's info)
            	type: Array
            },
            imageInfo: {				// images' info ( alt, href, name )
            	type: Object
            },
            itemsOnStage: {				// items on screen
            	type: Number,
            	default: 4
            },
            loop: {
            	type: Boolean,
            	default: false
            },
            margin: {					// right marging of each item
            	type: Number,
            	default: 4
            },
            showNav: {					// show nav's prev and next buttons
            	type: Boolean,
            	default: false
            },
            autoPlay: {
            	type: Boolean,
            	default: false
            },
            navContainer: {				// media folder with images
            	type: String,
            	default: ""
            },

        },
		data() {
	        return {
	            isLoading: false,
	            carouselData: this.fileList
	        }
	    },
		mounted() {
	        this.$nextTick( function(){
	        	this.installOwlCarousel();
	        } );
	    },
		methods: {
			getValue: function( fileName, key ){
				if( Object.keys( this.imageInfo ).length === 0 && this.imageInfo.constructor === Object ){
					return "";
				} else{
					if( this.imageInfo.hasOwnProperty( fileName ) && this.imageInfo[ fileName ].hasOwnProperty( key ) ){
						return this.imageInfo[ fileName ][ key ];
					} else {
						return "";
					}
				}
			},
			getMediaPath: function( fileName ){
				if( this.mediaFolder != "" ){
					return '/__media/' + this.mediaFolder + '/' + fileName;
				} else {
					return '/__media/' + fileName;
				}

			},
	        installOwlCarousel: function(){
	        	$( '#' + this.carouselId ).owlCarousel(
	                {
	                    loop: this.loop,
	                    items: this.itemsOnStage,
	                    margin: this.margin,
	                    responsive:{
					        0:{
					            items:1
					        },
					        600:{
					            items:this.itemsOnStage - 1
					        },
					        1000:{
					            items:this.itemsOnStage
					        }
					    },
				        responsiveRefreshRate: 200,
				        autoplay: this.autoPlay,
				        autoplayHoverPause: false,
				        nav: this.showNav,
				        navContainer: this.navContainer
	                }
	            );
	        }
	    }

	}
</script>