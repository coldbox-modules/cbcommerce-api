<template>
    <div>
        <a :href="accountHref" class="secondary-menu-title">
            <i class="fa fa-user"></i>
            <span class="hidden-xs">&nbsp; My Account</span>
            <span class="fa fa-caret-down"></span>
        </a>
        <ul class="list-unstyled account-menu-item" v-if="!authUser">
            <li><a href="/store/account/login"><i class="fa fa-lock"></i>&nbsp; Log In</a></li>
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
	}
}
</script>