<template>

    <tr>
        <td>
            <router-link 
                :to="{ name: 'categoryForm', params: { id: id } }">
                {{categoryName}}
            </router-link>
        </td>
        <td>{{active}}</td>
        <td>
            <router-link 
                :to="{ name: 'categoryForm', params: { id: id } }" 
                class="btn btn-success float-right">
                <i class="fa fa-pencil"></i>
            </router-link>
        </td>
    </tr>

</template>
<script>
export default {

    props: [
        'category'
    ],

    data() {
        return {
            id          : null,
            categoryName: null,
            active      : null
        }
    },

    created() {
        this.parseContent();
    },

    mounted() {},

    methods: {

        parseContent: function(){
            var self          = this;
            var parsedContent = self.category;
            self.id           = parsedContent.id;
            self.categoryName = parsedContent.categoryName;
            self.active       = parsedContent.active;
        }

    }

}
</script>