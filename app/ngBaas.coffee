angular.module 'ngBaas',[]
.provider 'baas',($compileProvider,$provide)->
  $get:->
    null
  collection:(name)->
    sing = inflection.singularize name
    sing_cap = inflection.capitalize sing
    plur = inflection.pluralize name
    plur_cap = inflection.capitalize plur
    $compileProvider.directive name,($http)->
      restrict: "A"
      link:(scope,elem,attrs)->
        _id = attrs[name]
        $http.get("/api/#{plur}/#{_id}").
        success (data)->
          angular.forEach data,(val,key)->
            scope[key] = val
    $provide.factory plur_cap,($http,$rootScope)->
      find:(query)->
        query_str = dump query
        es = new EventSource("/api/#{plur}#{query_str}")
        result = Set([],es)
        es.addEventListener "message", (event) ->
          $rootScope.$apply ->
            _row = JSON.parse(event.data)
            doc = Doc(plur,_row)
            result.add doc
        result
      findOne:(_id,cb)->
        doc = Doc(plur)
        $.get "/api/#{plur}/#{_id}", (data)->
          doc._set(data)
          cb doc if typeof cb isnt "undefined"
        doc
      insert:(data,cb)->
        doc = Doc(plur)
        $.post "/api/#{plur}",data,(_data)->
          doc._set(_data)
          cb(doc) if typeof cb isnt "undefined"
        doc
