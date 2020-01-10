<template>

    <div class="row">
        <div 
            v-if="isLoading" 
            v-for="fake in fakes" 
            v-bind:key="fake.id"
        >
            <category-grid-item-loading></category-grid-item-loading>
        </div>

        <div v-if="!isLoading">
            <category-grid-item
                v-for="category in categories"
                :key="category.id"
                :category="category"
            ></category-grid-item>
        </div>

    </div>

</template>

<script>
import CategoryGridItem from './category-grid-item';
import CategoryGridItemLoading from './category-grid-item-loading';
import { mapGetters } from 'vuex';

export default {
    components: {
        CategoryGridItemLoading,
        CategoryGridItem
    },
    data(){
        return {
            fakes     : [{"id":1},{"id":2},{"id":3}],
            isLoading : false,
            filters : {}
        }
    },
    created: function(){
        var self = this;
        this.isLoading = true;
        // Fetch the categories
        this.fetchCategories().then( () => self.isloading=false )

    },
    computed: {
        ...mapGetters({ 
            categories: 'categoriesListArray'
        })
    },
    mounted() {

    },

    destroyed() {},

    methods: {

        fetchCategories: function(){
            return this.$store.dispatch( 'getCategories' );        
        }

    }
}
</script>