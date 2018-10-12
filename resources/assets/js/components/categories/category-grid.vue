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
export default {
    components: {
        CategoryGridItemLoading,
        CategoryGridItem
    },
    data(){
        return {
            fakes     : [{"id":1},{"id":2},{"id":3}],
            categories: null,
            isLoading : false,
        }
    },
    created: function(){
        this.isLoading = true;
        // Fetch the categories
        this.fetchCategories();
    },
    mounted() {

    },

    destroyed() {},

    methods: {

        fetchCategories: function(){
            var self       = this;
            fetch( 'mockData/categories.json' )
                .then(r => r.json())
                .then(categories => {
                    self.categories = categories;
                    self.isLoading = false;
                })
        }

    }
}
</script>

<style>
</style>