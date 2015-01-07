gulp = require('gulp')
karma = require('karma').server
server = require('gulp-express')
nodemon = require 'nodemon'
gulp.task 'server',->
  server.stop()
  server.run
    file:'index.js'
gulp.task 'test', ['server'], ->
  karma.start
    configFile: __dirname + '/karma.conf.coffee'
    singleRun: true
  , server.stop
gulp.task 'tdd',->
  gulp.run 'test'
  gulp.watch '**/*.coffee',['test']