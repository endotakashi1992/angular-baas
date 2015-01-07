module.exports = (config) ->
  config.set
    basePath: ""
    proxies:
      "/api": "http://localhost:3000/api"
    frameworks: ["jasmine"]
    files: [
      "bower_components/inflection/inflection.min.js"
      "bower_components/jquery/dist/jquery.js"
      "bower_components/angular/angular.js"
      "bower_components/angular-mocks/angular-mocks.js"
      "app/*.coffee"
      "test/*.coffee"
    ]
    exclude: []
    preprocessors:
      "**/*.coffee": ["coffee"]
    reporters: ["progress"]
    port: 9876
    colors: true
    logLevel: config.LOG_INFO
    autoWatch: true
    browsers: ["PhantomJS"]
    singleRun: false