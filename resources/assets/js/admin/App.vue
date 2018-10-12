<template>

	<div id="app">

		<slideout-panel></slideout-panel>

		<top-search></top-search>

		<b-container fluid>

			<b-row>

				<sidebar></sidebar>

				<main role="main" class="col-md-9 ml-sm-auto col-lg-10 px-4">

					<router-view></router-view>

				</main>

			</b-row>

		</b-container>

	</div>

</template>

<script>
import TopSearch from "@/components/admin/ui/top-search";
import Sidebar from "@/components/admin/ui/sidebar";
export default {
	name    : "app",
	components: {
		TopSearch,
		Sidebar
	},
	computed: {},
	methods : {},
	watch   : {}
};
</script>