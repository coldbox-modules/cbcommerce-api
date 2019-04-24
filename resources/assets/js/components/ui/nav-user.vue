<template>
    <div>
        <a :href="'#'" class="secondary-menu-title">
            <i class="fa fa-user"></i>
            <span class="hidden-xs">&nbsp; {{$t( "my_account" )}}</span>
            <span class="fa fa-caret-down"></span>
        </a>
        <ul class="list-unstyled account-menu-item" >
        	<li v-if="authUser"><a href="/store/wishlists"><i :class="$t('wishlist_icon')"></i>&nbsp; {{$t("Wishlists")}}</a></li>
        	<li v-if="!authUser"><a href="/store/account/login"><i class="fa fa-lock"></i>&nbsp; {{$t( "log_in")}}</a></li>
            <li v-else><a href="#" @click.prevent="logout()"><i class="fa fa-lock"></i>&nbsp; {{ $t( "log_out" ) }}</a></li>
            <li><a href="/store/product/comparison"><i class="fa fa-random"></i>&nbsp; Comparisons</a></li>
            <li v-if="!authUser"><a href="/store/account/create"><i class="fa fa-user-circle"></i>&nbsp; {{ $t( "account_create" ) }}</a></li>
        </ul>
    </div>
</template>
<script>
import { mapGetters, mapActions } from "vuex";
export default {
	computed: {
		...mapGetters([
			"authUser"
        ]),
        accountHref(){
            return this.authUser ? '/store/account' : '/store/account/login'
        }
	},
	 methods: {
        ...mapActions([
            "logout"
        ])
    }
}
</script>