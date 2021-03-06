module.exports = ->
  EventEmitter = require('events').EventEmitter
  _ev = new EventEmitter()
  express = require("express")
  app = express()
  bodyParser = require("body-parser")
  app.use bodyParser.urlencoded(extended: false)
  app.use bodyParser.json()
  app.use(express.static(__dirname + '/public'))
  port = process.env.PORT || 3000
  Datastore = require('nedb')
  collections = {}
  createDB = (name)->
    return collections[name] || collections[name] = new Datastore()

  EventEmitter = require('events').EventEmitter
  ev = new EventEmitter

  app.get "/api/:resource", (req, res) ->
    res.writeHead 200,
      "Content-Type": "text/event-stream"
      "Cache-Control": "no-cache"
      Connection: "keep-alive"
    res.write "\n"
    resource = req.params.resource
    db = createDB(resource)
    query = req.query || {}
    db.find query,(e,docs)->
      docs.forEach (doc)->
        res.write('data: ' + JSON.stringify(doc) + ' \n\n')
    ev.on "#{resource}:create",(data)->
      query._id = data._id
      db.findOne query,(e,doc)->
        res.write('data: ' + JSON.stringify(doc) + ' \n\n')

  app.get "/api/:resource/:_id", (req, res) ->
    _id = Number(req.params._id)
    resource = req.params.resource
    db = createDB(resource)
    db.findOne {_id:_id},(e,doc)->
      res.send doc

  app.post "/api/:resource", (req, res)->
    resource = req.params.resource
    db = createDB(resource)
    db.count {},(e,count)->
      newDoc = req.body
      newDoc._id = count + 1
      db.insert newDoc,(e,doc)->
        ev.emit "#{resource}:create",(doc)
        res.send doc
        
  app.put "/api/:resource/:_id",(req,res) ->
    resource = req.params.resource
    db = createDB(resource)
    _id = Number(req.params._id)
    db.remove req.body,(e,d)->
      db.insert req.body,(e,doc)->
        res.send doc

  app.delete "/api/:resource/:_id",(req,res) ->
    _id = Number(req.params._id)
    resource = req.params.resource
    db = createDB(resource)
    db.remove {_id:_id},(e,d)->
      res.send d
  server = app.listen 3000,->
    _ev.emit 'start'
    _ev.on 'stop',->
      server.close()
  return _ev
