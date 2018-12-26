<template>

	<form @submit.prevent="handleSubmit">
	    <div class="row">
	        <div class="col-md-6">
	            <div class="form-group">
	                <label 
	                	for="inputFirstName" 
	                	class="control-label">Summary:<span class="text-error">*</span>
	                </label>
	                <div>
	                    <input 
	                    	type="text" 
	                    	class="form-control" 
	                    	id="inputFirstName"
	                    	v-model="review.summary" />
	                </div>
	            </div>
	        </div>
	        <div class="col-md-6">
	            <div class="form-group">
	                <label 
	                	for="inputCompany" 
	                	class="control-label">Company:
	                </label>
	                <div>
	                    <input 
	                    	type="text" 
	                    	class="form-control" 
	                    	id="inputCompany"
	                    	v-model="review.company" />
	                </div>
	            </div>
	        </div>
	        <div class="col-md-12">
	            <div class="form-group">
	                <textarea 
	                	class="form-control"
	                	v-model="review.comment"></textarea>
	            </div>
	        </div>
	        <div class="col-md-12">
	            <div class="form-group">
	                <label class="control-label">Your Rating:</label>
	                <div class="product-rating">
	                    <star-rating 
	                    	v-model="review.rating"
	                        :show-rating="false"
	                        :item-size="10"
	                    ></star-rating>
	                </div>
	            </div>
	        </div>
	    </div>
	    <input
	    	type="submit"
	    	id="submitReviewBtn"
	    	class="btn-default-1"
	    	value="Add Review" />
	</form>

</template>

<script>
import moment from "moment";
import { StarRating } from 'vue-rate-it';
export default {
	components: {
		StarRating
    },
    data() {
        return {
        	moment: moment,
        	review: {
				name   : '',
				company: '',
				comment: '',
				rating : 0
        	}
        }
    },

    created: function(){},

    mounted() {},

    destroyed() {},

    methods: {

    	handleSubmit: function(){
			const currDateTime      = moment( new Date() );
			const reviewData        = this.review;
			reviewData.fullDateTime = currDateTime;
			reviewData.date         = moment( currDateTime ).format( 'DD/MM/YYYY' );
    		this.$emit( 'reviewSubmission', reviewData );
    		// this.clearValues();
    	},

    	clearValues: function(){
			this.review.name    = '';
			this.review.company = '';
			this.review.comment = '';
			this.review.rating  = 0;
    	}

    }

}
</script>