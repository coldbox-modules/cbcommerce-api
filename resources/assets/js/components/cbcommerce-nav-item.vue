<template>
    <li :class="navItem.itemClass">
        <a
            v-if="navItem.js"
            href="javascript:;"
            @click="navItem.js"
            :class="navItem.urlClass"
            v-html="navItem.label"></a>
        <a
            v-else-if="navItem.url"
            :href="navItem.url"
            :class="navItem.urlClass"
            :data-toggle="navItem.urlClass.indexOf( 'dropdown' ) > -1 ? 'dropdown' : ''"
            v-html="navItem.label"></a>
        <a
            v-else-if="navItem.contentSlug"
            :href="baseHref+navItem.contentSlug"
            :class="navItem.urlClass"
            :data-toggle="navItem.urlClass.indexOf( 'dropdown' ) > -1 ? 'dropdown' : ''"
            v-html="navItem.label"></a>
        <span v-else v-html="navItem.label"></span>

        <ul v-if="navItem.children && navItem.children.length" :class="rootMenu.listClass">
            <sub-nav-item
                v-for="( subItem, index ) in navItem.children"
                :key="`sub_nav_item_${index}`"
                :navItem="subItem"></sub-nav-item>
        </ul>
    </li>
</template>
<script>
import { mapState, mapGetters } from 'vuex';
export default{
    props: {
        navItem : {
            required: true
        }
    },
    beforeCreate: function () {
        this.$options.components.SubNavItem = require( '@cbCommerce/components/cbcommerce-nav-item' ).default
    },
    computed : {
        ...mapGetters([
            'baseHref'
        ]),
        ...mapState({
            rootMenu : state => state.globalData.rootMenu
        })
    }
}
</script>