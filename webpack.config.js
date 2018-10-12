const elixir = require("coldbox-elixir");
const webpack = require("webpack");

elixir.config.mergeConfig({
    plugins: [
    	new webpack.ProvidePlugin({
			$              : "jquery",
			jQuery         : "jquery",
			"window.jQuery": "jquery",
			"window.$"     : "jquery",
			"Vue"          : ["vue/dist/vue.esm.js", "default"],
            "window.Vue"   : ["vue/dist/vue.esm.js", "default"]
        })
    ]
});

module.exports = elixir(function(mix) {
	mix
    .sass("app.scss")
    .sass("admin/app.scss")
	.sass(
            [
                "resources/assets/sass/vendor.scss",
                "node_modules/viewerjs/dist/viewer.css"

            ],
            {
                name: "vendor",
                entryDirectory: ""
            }
        )
    .sass(
        [
            "resources/assets/sass/admin/vendor.scss",
            "/node_modules/bootstrap/dist/css/bootstrap.css",
            "/node_modules/bootstrap-vue/dist/bootstrap-vue.css",
            "node_modules/@voerro/vue-tagsinput/dist/style.css"

        ],
        {
            name: "vendor-admin",
            entryDirectory: ""
        }
    );

    mix.vue("app.js");
    mix.vue("admin.js");
});
