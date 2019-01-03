<template>

    <div>

        <div class="review-header">
            <h5>{{ review.summary }}</h5>
            <div class="product-rating">
                <div class="stars">

                    <star-rating 
                        :show-rating="false"
                        :item-size="10" 
                        :read-only="true"
                        :rating="review.rating"
                    ></star-rating>

                </div>
            </div>
            <small class="text-muted">{{ review.createdTime }}</small>
        </div>
        <div class="review-body">
            
            {{ review.comment }}

        </div>
        <hr>

    </div>

</template>

<script>
import { StarRating } from 'vue-rate-it';
export default {
    components: {
        StarRating
    },
    props: [
        'review'
    ],
    data() {
        return {
            maxRating: 5
        }
    },
    methods: {

        markReviewRating: function(index, userRating, maxRating){
            return ( userRating >= index ) ? true : false;
        }

    }
}
</script>