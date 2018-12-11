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
        }
    });

    mix.sass( "app.scss" )
        .vue("app.js")
    	.sass(
            [
                "resources/assets/sass/vendor.scss"
            ],
            {
                name: "vendor",
                entryDirectory: ""
            }
        );
};
