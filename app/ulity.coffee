Set = (array)->
  result = array || []
  result.add = (value)->
    angular.forEach result,(val,key)->
      if val._id == value._id
        result.pop(key)
    result.push value
  return result
dump = (obj)->
  if !obj
    return ""
  str = "?"
  for key of obj
    str += "&"  unless str is ""
    str += key + "=" + obj[key]
  return str
$.extend 
  put:(_url,_data,_success)->
    $.ajax
      type: 'PUT'
      url:_url
      dataType:'json'
      data:_data
      success:_success

  delete:(_url,_data,_success)->
    $.ajax
      type: 'DELETE'
      url:_url
      dataType:'json'
      data:_data
      success:_success