const path = require("path");
const webpack = require("webpack");

module.exports = function (mix) {
    elixir.config.mergeConfig({
        plugins: [
            // globally scoped items which need to be available in all templates
            new webpack.ProvidePlugin( {
                $: "jquery",
                jQuery: "jquery",
                "window.jQuery": "jquery",
                "window.$": "jquery",
                "Vue": ["vue/dist/vue.esm.js", "default"],
                "window.Vue": ["vue/dist/vue.esm.js", "default"]
            } )
        ],
        resolve: {
            alias: {
                ["@cbCommerce"]: `${path.dirname(__filename)}/resources/assets/js`
            }
        },
        module: {
            rules: [
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

    mix
        .vue("app.js")
        .vue("admin.js")
        .sass("app.scss")
        .sass("email.scss")
        .sass("admin/app.scss")
        .sass(
            [
                "resources/assets/sass/vendor.scss"
            ],
            {
                name: "vendor",
                entryDirectory: ""
            }
        )
        .sass(
            [
                "resources/assets/sass/admin/vendor.scss"

            ],
            {
                name: "vendor-admin",
                entryDirectory: ""
            }
        );
};
