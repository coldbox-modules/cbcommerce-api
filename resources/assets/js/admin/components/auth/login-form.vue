<template>
    <div class="col-xs-12">
        <div class="col-md-6 col-md-offset-3">
            <page-header 
                :header-title="$t( 'log_in' )">		
            </page-header>

            <login-form></login-form>
        </div>
        <div class="clearfix"></div>
    </div>
</template>
<script>
import LoginForm from '@cbCommerce/components/login-form';
export default {
    components : {
        LoginForm
    }
}
</script>