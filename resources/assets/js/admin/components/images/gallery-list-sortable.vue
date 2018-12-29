
<template>

	<div class="imageGridHolder">

		<grid
			:center="false"
			:draggable="true"
			:sortable="true"
			:items="images"
			:cellHeight="200"
			:cellWidth="200"
			:height="200"
			:width="200"
			@change="change"
			@remove="remove"
			@sort="sort">
	      <template slot="cell" slot-scope="props">
	        <gallery-item-sortable 
	        	:image="props.item"
              	:index="props.index"
              	:with-button="true"
              	@remove="props.remove()" />
	      </template>
	    </grid>

	</div>

</template>
<script>
import GalleryItemSortable from './gallery-item-sortable.vue';
export default {

	props: ['images'],

	components: {
		GalleryItemSortable
	},

	data() {
	    return {};
	},

	methods: {

	    change( event ){
	      console.log( 'change', event );
	    },

	    remove( event ){
	      console.log( 'remove', event );
	    },

	    sort( event ){
	      console.log( 'sort', event );
	    }

 	}

}
</script>