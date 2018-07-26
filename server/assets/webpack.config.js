const ExtractTextPlugin = require('extract-text-webpack-plugin');

module.exports = {
  entry: "./js/app.js",
  output: {
    path: "../priv/static",
    filename: "/js/app.js"
  },
  module: {
    loaders: [
      {
        test: /\.js$/,
        exclude: /node_modules/,
        loader: "babel",
        include: __dirname,
        query: {
          presets: ["es2015", "stage-0"]
        }
      },
      {
        test: /\.(s)css$/,
        loader: ExtractTextPlugin.extract(
          "css-loader!sass-loader",
        )
      },
    ],
  },
  plugins: [
    new ExtractTextPlugin('/css/app.css')
    //if you want to pass in options, you can do so:
    //new ExtractTextPlugin({
    //  filename: 'style.css'
    //})
  ]
};