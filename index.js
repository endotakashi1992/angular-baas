require('coffee-script/register')
path = require('path')

module.exports = require('./api/restful.coffee')()
delete(require.cache[path.resolve('./api/restful.coffee')])