app = angular.module 'ngBaas',[]
.provider 'baas',($compileProvider,$provide)->
  {
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
        {
          find:(query)->
            result = Set()
            query_str = dump query
            es = new EventSource("/api/#{plur}#{query_str}")
            es.addEventListener "message", (event) ->
              $rootScope.$apply ->
                result.add JSON.parse(event.data)
            return result
          findOne:(_id,cb)->
            result = {}
            $.get "/api/#{plur}/#{_id}", (data)->
              angular.forEach data,(val,key)->
                result[key] = val
              cb data if typeof cb isnt "undefined"
            return result
          insert:(data,cb)->
            result = {}
            $.post "/api/#{plur}",data,(_data)->
              angular.forEach _data,(val,key)->
                result[key] = val
              cb(_data) if typeof cb isnt "undefined"
            return result
        }
  }