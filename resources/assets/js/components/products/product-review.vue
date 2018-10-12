<template>

    <div>

        {{ isLoading }}
        
        <div class="review-header">
            <h5>{{ this.name }}</h5>
            <div class="product-rating">
                <div class="stars">

                    <star-rating 
                        :show-rating="false"
                        :item-size="10" 
                        :read-only="true"
                        :rating="rating"
                    ></star-rating>

                </div>
            </div>
            <small class="text-muted">{{ this.date }}</small>
        </div>
        <div class="review-body">
            
            {{ this.comment }}

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
        'review',
        'isLoading'
    ],
    data() {
        return {
            maxRating: 5,
            name     : null,
            comment  : null,
            date     : null,
            rating   : 0
        }
    },

    created: function(){},

    mounted() {
        this.parseContent();
    },

    destroyed() {},

    computed: {

        

    },

    methods: {

        markReviewRating: function(index, userRating, maxRating){
            return ( userRating >= index ) ? true : false;
        },

        parseContent: function(){
            var self          = this;
            var parsedContent = self.review;
            self.name         = parsedContent.name;
            self.comment      = parsedContent.comment;
            self.date         = parsedContent.date;
            self.rating       = parsedContent.rating;
        }

    }
}
</script>