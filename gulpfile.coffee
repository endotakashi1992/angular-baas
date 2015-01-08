gulp = require('gulp')
karma = require('karma')
server = require('gulp-express')
nodemon = require 'nodemon'
logCapture = require('gulp-log-capture')
exec = require('gulp-exec')
run = require("gulp-run")
spawn = require('child_process').spawn;
child = undefined

gulp.task 'express:start', (done)->
  child = spawn "node", ["index.js"]
  child.stdout.on "data", done

gulp.task 'express:restart',(done)->
  child.kill "SIGUP"
  child.stdout.on "data", done

gulp.task 'karma:start',(done)->
  karma.server.start
    configFile: __dirname + '/karma.conf.coffee'
    singleRun: true
    autoWatch:false
  ,done
gulp.task 'karma:run',['karma:start'],->
  karma.runner.run()

gulp.task 'test',['node:start','karma:start'],->
  process.exit()
gulp.task 'tdd',['express:start','karma:start'],->
  gulp.watch "api/*.coffee",['express:restart','karma:run']