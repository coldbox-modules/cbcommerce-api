<template>

	<div id="app">

		<slideout-panel></slideout-panel>

		<top-search></top-search>

		<b-container fluid style="margin-top:40px">

			<b-row>

				<sidebar v-if="authUser"></sidebar>

				<main role="main" class="col-md-9 ml-sm-auto col-lg-10 px-4">

					<router-view></router-view>

				</main>

			</b-row>

		</b-container>

	</div>

</template>

<script>
import TopSearch from "@cbCommerce/admin/components/ui/top-search";
import Sidebar from "@cbCommerce/admin/components/ui/sidebar";
import { mapGetters } from "vuex";
export default {
	name    : "app",
	components: {
		TopSearch,
		Sidebar
	},
	computed: {
		...mapGetters([
			"authUser"
		])
	},
	methods : {},
	watch   : {}
};
</script>