module.exports = {
  entry: "./js/app.js",
  output: {
    path: "../priv/static/js",
    filename: "app.js"
  },
  module: {
    loaders: [{
      test: /\.(js|jsx)$/,
      exclude: /node_modules/,
      loader: "babel",
      include: __dirname,
      query: {
        presets: ["es2015", "stage-0"]
      }
    }]
  },
};