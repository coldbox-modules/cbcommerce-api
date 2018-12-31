<template>

	<div>

        <page-header
            headerTitle="Categories"
            :displayToolBarButton="true"
            routeName="newCategory"
            buttonIconClass="fa fa-plus">    
        </page-header>

		<table class="table table-sm table-striped">
            <thead>
                <tr>
                    <th>Name</th>
                    <th>Active</th>
                    <th>&nbsp;</th>
                </tr>
            </thead>
            <tbody>
                <table-row
                    v-for="(category, index) in this.categoriesListArray"
                    :key="index"
                    :category="category"
                ></table-row>
            </tbody>
		</table>

	</div>

</template>

<script>
import { mapGetters, mapActions } from "vuex";
import moment from "moment";
import TableRow from "./table-row";
export default {

	components: {
		TableRow
	},

    data() {
    	return {
			isLoading: true,
			filterParams : {
				isActive : 1,
				sortOrder : 'displayOrder ASC'
			}
    	}
    },

    created() {
    	this.fetchCategories();
    },

    mounted() {},

    computed: {
    	...mapGetters([
    		"categoriesList",
    		"categoriesListArray",
    		"currentCategoryID"
    	])
    },

    methods: {
    	
    	...mapActions([
    		"getCategories"
    	]),

    	fetchCategories(){
    		const self = this;
    		Promise.resolve( this.getCategories( this.filterParams ) )
    		.then(() => {
    			self.isLoading = false;
    		})
    		.catch(err => console.error(err));
    	}

    },

}
</script>