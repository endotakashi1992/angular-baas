gulp = require('gulp')
karma = require('karma')
path = require 'path'
express = undefined

gulp.task 'express:start', (done)->
  express = require path.resolve('index.js')
  delete require.cache[path.resolve('index.js')]
  express.on 'start',done

gulp.task 'express:stop',(done)->
  express.emit 'stop'
  express.on 'close',done

gulp.task 'express:restart',['express:stop','express:start']

gulp.task 'karma:run',(done)->
  karma.server.start
    configFile: __dirname + '/karma.conf.coffee'
    singleRun: true
  ,->
    done()

gulp.task 'test',['express:start','karma:run'],->
  process.exit()

gulp.task 'tdd',['express:start','karma:run'],->
  gulp.watch "api/*.coffee",['express:restart','karma:run']
  gulp.watch ["app/*.coffee","test/*.coffee"],['karma:run']