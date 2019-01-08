<template>
	<div>
		<div :id="galleryId" :class="galleryClass">
			<button class="btn btn-border" :class="{ active: showAllTags }" @click="resetImages()">All</button>
			<button class="btn btn-border" v-for="( tag, index ) in allTags" :key="`${index}-${tag.name}`" :class="{ active: tag.show }" @click="setFilters( tag )">{{ tag.name }}</button>
			<viewer :images="images" class="viewer" :options="options">
				<transition-group name="list-complete">
					<div class="item" v-for="item in galleryFileData" v-if="getValue( item.name, 'show' )" :key="getMediaPath( item.name )">
		      			<img :data-source="getMediaPath( item.name )" :src="getThumbnailPath( item.name )" :alt="getValue( item.name, 'alt' )"/>
		      		</div>
		      	</transition-group>
	    	</viewer>
		</div>
	</div>
</template>

<script>
	import Viewer from 'v-viewer';
	Vue.use( Viewer );

	export default {
		props: {
            galleryId: { 				// unique gallery Id
                type: String,
                required: true
            },
            galleryClass: {				// gallery class
            	type: String
            },
            mediaFolder: {				// media folder with images
            	type: String,
            	default: ""
            },
            fileList: {					// file list ( array of structs with each file's info)
            	type: Array
            },
            imageInfo: {				// images' info ( alt, name )
            	type: Object
            }
        },
        created(){
        	this.initiateImages();
        	this.initiateViewer();
        },
		data() {
	        return {
	            galleryFileData: this.fileList,
	            galleryImageData: this.imageInfo,
	            images: [],
	            allTags: {},
	            showAllTags: true,
	            options: {
	            	movable : false,
	            	rotatable: false,
	            	scalable: false,
	            	url: 'data-source'
	            }
	        }
	    },
		methods: {
			initiateViewer (viewer) {
		        this.$viewer = viewer
		    },
		    // shows all images and activates 'all' button
		    initiateImages(){
				for( var i in this.galleryFileData ){
					var fileName =  this.galleryFileData[ i ].name;

					if( !this.galleryImageData.hasOwnProperty( fileName ) ){
						this.$set( this.galleryImageData, fileName, {} );
					}
					// set image to show
					this.$set( this.galleryImageData[ fileName ], 'show', true );
					// add file path to images ( prop for  Viewer )
					this.images.push( this.getMediaPath( fileName ) );

					var imageTags = this.getValue( fileName, 'tags' )
					for( var tag in imageTags ){

						// create slug/key for tag
						var tagSlug = imageTags[ tag ].replace( /\s+/g, '-' ).toLowerCase();
						// check if tag exists in allTags
            			if( !this.allTags.hasOwnProperty( tagSlug )){
            				this.$set( this.allTags, tagSlug, { 'name': imageTags[ tag ], 'show' : false } );
						}
					}
				}
			},
			// resets view to all
			resetImages(){
				this.showAllTags = true;
				for( var i in this.allTags ){
					this.allTags[ i ].show = false;
				}
				this.filterImages();
			},
			setFilters( tag ){
				// toggle show property of tags, which then toggles active button
				tag.show = !tag.show;
				// if active tag deactivate 'all'
				if( tag.show ){
					this.showAllTags = false;
				}
				// filter images
				this.filterImages();
			},
			filterImages(){
				for( var i in this.galleryFileData ){
					var fileName = this.galleryFileData[ i ].name;
					var showImage = false;

					if( this.showAllTags ){
						showImage = true;
					} else {
						var imageTags = this.galleryImageData[ fileName ].tags;
						// check if tags are set to show
						for( var imageTag in imageTags ){
							var tagSlug = imageTags[ imageTag ].replace(/\s+/g, '-').toLowerCase();
							if( this.allTags[ tagSlug ].show ){
								showImage = true;
								break;
							}
						}
					}
					this.galleryImageData[ fileName ].show = showImage;
					// rebuild images array with images set to show
					this.images = [];
					if( showImage ){
						this.images.push( this.getMediaPath( fileName ) );
					}
				}
			},
			// gets values from galleryImageData, which stores additional properites of the file/image
			getValue: function( fileName, key ){
				if( Object.keys( this.galleryImageData ).length === 0 && this.galleryImageData.constructor === Object ){
					return "";
				} else{
					if( this.galleryImageData.hasOwnProperty( fileName ) && this.galleryImageData[ fileName ].hasOwnProperty( key ) ){
						return this.galleryImageData[ fileName ][ key ];
					} else {
						return "";
					}
				}
			},
			getThumbnailPath: function( fileName ){
				if( this.mediaFolder != "" ){
					return '/__media/' + this.mediaFolder + '/thumbnails/' + fileName;
				} else {
					return '/thumbnails/' + fileName;
				}

			},
			getMediaPath: function( fileName ){
				if( this.mediaFolder != "" ){
					return '/__media/' + this.mediaFolder + '/' + fileName;
				} else {
					return '/__media/' + fileName;
				}

			}
		}
	}
</script>