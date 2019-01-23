<template>

    <div class="block-products-modes color-scheme-2">
        <div class="row">
            <div class="col-xs-12 col-sm-4 col-md-4 col-lg-4">
                <div class="product-view-mode">
                    <a 
                        v-tooltip="{ content: 'View products as a grid' }"
                        class="productGridBtn"
                        v-bind:class="{ active: isGrid }" 
                        @click="productLayoutChange('grid')"><i class="fa fa-th-large"></i></a>
                    <a 
                        v-tooltip="{ content: 'View products as a list' }"
                        class="productListBtn"
                        v-bind:class="{ active: isList }" 
                        @click="productLayoutChange('list')"><i class="fa fa-th-list"></i></a>
                </div>
            </div>
            <div class="col-xs-12 col-sm-8 col-md-8 col-lg-8">
                <div class="row">
                    <div class="col-md-3 col-md-offset-1">
                        <label class="pull-right">Sort by</label>
                    </div>
                    <div class="col-md-5">
                        <select 
                            name="sort-type" 
                            class="form-control" 
                            @change="$emit('sortTypeChange', $event.target.value)">
                            <option value="position:asc">--</option>
                            <option value="price:asc" selected="selected">Price: Lowest first</option>
                            <option value="price:desc">Price: Highest first</option>
                            <option value="name:asc">Product Name: A to Z</option>
                            <option value="name:desc">Product Name: Z to A</option>
                            <option value="quantity:desc">In stock</option>
                        </select>
                    </div>
                    <div class="col-md-3">
                        <select 
                            name="products-per-page" 
                            class="form-control"
                            :value="perPage"
                            @change="$emit('perPageChange', $event.target.value)">
                            <option v-for="(n, index) in [ 15, 30, 50, 75, 100 ]" :key="`option-${index}`" v-bind:value="n">{{n}}</option>
                        </select>
                    </div>
                </div>
            </div>
        </div>
    </div>

</template>

<script>
export default {
    components: {},
    props: [
        'isGrid',
        'isList',
        'perPage'
    ],
    data() {
        return {}
    },

    created: function(){
    },
    mounted() {

    },

    destroyed() {},

    methods: {
        productLayoutChange(type){
            this.$emit('productLayoutChange', type);
        }

    }
}
</script>