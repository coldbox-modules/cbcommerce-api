<cfoutput>
    <section>

        <div class="container-fluid">
            <div class="col-md-4 col-md-offset-2 col-sm-6">
                <!--- TODO: Use setting to get the app name --->
                <h2>Sign In to your Account</h2>
                <login-form></login-form>
            </div>
            <div class="col-md-3 col-md-offset-1 col-sm-6">
                <!--- TODO: Use setting to get the app name --->
                <h2>No Account yet?</h2>
                <a href="/store/account/create" class="btn btn-primary btn-lg">Create an Account</a>
            </div>
        </div>

    </section>
</cfoutput>