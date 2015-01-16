(function() {
  angular.module('ngBaas', []).provider('baas', function($compileProvider, $provide) {
    return {
      $get: function() {
        return null;
      },
      collection: function(name) {
        var plur, plur_cap, sing, sing_cap;
        sing = inflection.singularize(name);
        sing_cap = inflection.capitalize(sing);
        plur = inflection.pluralize(name);
        plur_cap = inflection.capitalize(plur);
        $compileProvider.directive(name, function($http) {
          return {
            restrict: "A",
            link: function(scope, elem, attrs) {
              var _id;
              _id = attrs[name];
              return $http.get("/api/" + plur + "/" + _id).success(function(data) {
                return angular.forEach(data, function(val, key) {
                  return scope[key] = val;
                });
              });
            }
          };
        });
        return $provide.factory(plur_cap, function($http, $rootScope) {
          return {
            find: function(query) {
              var es, query_str, result;
              query_str = dump(query);
              es = new EventSource("/api/" + plur + query_str);
              result = Set([], es);
              es.addEventListener("message", function(event) {
                return $rootScope.$apply(function() {
                  var doc, _row;
                  _row = JSON.parse(event.data);
                  doc = Doc(plur, _row);
                  return result.add(doc);
                });
              });
              return result;
            },
            findOne: function(_id, cb) {
              var doc;
              doc = Doc(plur);
              $.get("/api/" + plur + "/" + _id, function(data) {
                doc._set(data);
                if (typeof cb !== "undefined") {
                  return cb(doc);
                }
              });
              return doc;
            },
            insert: function(data, cb) {
              var doc;
              doc = Doc(plur);
              $.post("/api/" + plur, data, function(_data) {
                doc._set(_data);
                if (typeof cb !== "undefined") {
                  return cb(doc);
                }
              });
              return doc;
            }
          };
        });
      }
    };
  });

}).call(this);

(function() {
  var Doc, Set, dump;

  Doc = function(resource, val) {
    var doc;
    doc = val || {};
    doc._set = function(_data) {
      return angular.forEach(_data, function(val, key) {
        return doc[key] = val;
      });
    };
    doc.save = function() {
      return $.put("/api/" + resource + "/" + this._id);
    };
    return doc;
  };

  Set = function(array, es) {
    var result;
    result = array || [];
    result.close = function() {
      es.close();
      return "close";
    };
    result.add = function(value) {
      angular.forEach(result, function(val, key) {
        if (val._id === value._id) {
          return result.pop(key);
        }
      });
      return result.push(value);
    };
    return result;
  };

  dump = function(obj) {
    var key, str;
    if (!obj) {
      return "";
    }
    str = "?";
    for (key in obj) {
      if (str !== "") {
        str += "&";
      }
      str += key + "=" + obj[key];
    }
    return str;
  };

  $.extend({
    put: function(_url, _data, _success) {
      return $.ajax({
        type: 'PUT',
        url: _url,
        dataType: 'json',
        data: _data,
        success: _success
      });
    },
    "delete": function(_url, _data, _success) {
      return $.ajax({
        type: 'DELETE',
        url: _url,
        dataType: 'json',
        data: _data,
        success: _success
      });
    }
  });

}).call(this);
