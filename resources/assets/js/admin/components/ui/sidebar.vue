<template>

	<nav class="col-md-2 d-none d-md-block bg-light sidebar">

  		<div class="sidebar-sticky">

    		<ul class="nav flex-column">

				<li class="nav-item">
					<router-link 
						class="nav-link" 
						to="/"><i class="fa fa-dashboard"></i> {{ $t( 'setting_dashboard' ) }}</router-link>
				</li>

				<li class="nav-item">
					<router-link 
						class="nav-link" 
						to="/orders"><i class="fa fa-file"></i> {{ $t( 'orders_name' ) }}</router-link>
				</li>

				<li class="nav-item">
					<router-link 
						class="nav-link" 
						to="/categories"><i class="fa fa-sitemap"></i> {{ $t( 'categories' ) }}</router-link>
				</li>

				<li class="nav-item">
					<router-link 
						class="nav-link" 
						to="/products"><i class="fa fa-shopping-cart"></i> {{ $t( 'products' ) }}</router-link>
				</li>

				<li class="nav-item">
					<router-link 
						class="nav-link" 
						to="/customers"><i class="fa fa-users"></i> {{ $t( 'customers' )}}</router-link>
				</li>

    		</ul>

			<h6 
				class="sidebar-heading d-flex justify-content-between align-items-center px-3 mt-4 mb-1 text-muted">
				<span>{{ $t( 'settings' ) }}</span>
			</h6>


			<ul class="nav flex-column">

				<li class="nav-item">
					<router-link
						class="nav-link"
						to="/settings/stripe"><i class="fa fa-money"></i> {{ $t( 'setting_stripe' ) }}</router-link>
				</li>

			</ul>

    	</div>
    	
    </nav>

</template>
<script>
export default {
	name    : "Sidebar"
};
</script>