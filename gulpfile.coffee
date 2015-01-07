gulp = require('gulp')
karma = require('karma').server
nodemon = require 'nodemon'
gulp.task 'server',(done)->
  nodemon
    script:'index.js'
  .on 'start',->
    done()
gulp.task 'test', ['server'], ->
  karma.start
    configFile: __dirname + '/karma.conf.coffee'
    singleRun: true
  , process.exit
gulp.task 'tdd',['server'],->
  karma.start
    configFile: __dirname + '/karma.conf.coffee'