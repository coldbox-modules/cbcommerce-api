<cfoutput>
    <section>

        <div class="container-fluid">
            <div class="header-for-light">
                <h1>Secure <span>Checkout</span></h1>
            </div>
            <div class="col-sm-6">
                <!--- TODO: Use setting to get the app name --->
                <h2>Sign In to your Online Account</h2>
                <login-form success-url="/store/checkout"></login-form>
            </div>
            <div class="col-sm-6">
                <!--- TODO: Use setting to get the app name --->
                <h2>No Online Account?</h2>
                <a href="/store/checkout" class="btn btn-secondary btn-lg">Checkout as a guest</a>
                <a href="/store/account/create" class="btn btn-primary btn-lg">Create an Account</a>
            </div>
        </div>

    </section>
</cfoutput>