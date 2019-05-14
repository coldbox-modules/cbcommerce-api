<template>
    <span>
        <v-popover  v-if="inComparison" class="text-center">
            
            <a 
                v-tooltip="{ content: $t('compare_this_item') }"
                :title="$t('compare_this_item')"
                class="addToCart has-tooltip product-compare in-comparison">
                <i :class="$t('compare_icon')"></i>
                {{ $t('compare_this_item') }}
            </a> 

            <template slot="popover" class="text-center">
                <p class="text-center">
                    This item is already in your comparisons
                </p>
                <a class="btn btn-success btn-small" href="/store/product/comparison"><i :class="$t('compare_icon')"></i> View Comparisons</a>
                <a class="btn btn-small btn-link text-ultra-muted" v-close-popover><br><i class="fa fa-times"></i> Close</a>
            </template>

        </v-popover>
        <a
            v-else 
            @click="addItemToComparisonList( skuId )"
            v-tooltip="{ content: $t('compare_this_item') }"
            :title="$t('compare_this_item')"
            class="addToCart has-tooltip product-compare">
            <i :class="$t('compare_icon')"></i>
            {{ $t('compare_this_item') }}
        </a>
    </span>
</template>
<script>
    import { mapGetters, mapActions } from "vuex";

    export default {
        props: {
            skuId : {
                type : String,
                required : true
            }
        },
        computed :{
            ...mapGetters([
                "comparisonItems"
            ]),
            inComparison(){
                return !!this.comparisonItems.filter( item => item.id === this.skuId ).length;
            }
        },
        methods : {
            ...mapActions([
                "addItemToComparisonList"
            ])
        }
    }
</script>