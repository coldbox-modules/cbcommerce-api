const elixir = require("coldbox-elixir");
const webpack = require("webpack");
const path = require("path");

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
    ],
    resolve: {
        alias: {
            ["@cbCommerce"]: `${path.dirname(__filename)}/resources/assets/js`
        }
    },
    module : {
        rules : [
            {
                test: /\.(woff2?|eot|ttf|otf)(\?.*)?$/,
                loader: "url-loader",
                options: {
                    limit: 100000,
                    name: global.elixir.versioning
                        ? "includes/fonts/[name].[hash:7].[ext]"
                        : "includes/fonts/[name].[ext]"
                }
            },
            {
                test: /\.(png|jpe?g|gif|svg)(\?.*)?$/,
                loader: "url-loader",
                options: {
                    limit: 100000,
                    name: global.elixir.versioning
                        ? "includes/images/[name].[hash:7].[ext]"
                        : "includes/images/[name].[ext]"
                }
            }
        ]
    }
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
            "/node_modules/bootstrap-vue/dist/bootstrap-vue.css"

        ],
        {
            name: "vendor-admin",
            entryDirectory: ""
        }
    );

    mix.vue("app.js");
    mix.vue("admin.js");
});
