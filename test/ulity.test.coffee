describe "ulity",->
  it "shuld be put",->
  	expect($.put).toBeDefined()
  it "shuld be delete",->
  	expect($.delete).toBeDefined()
  it "shuld be return responce",(done)->
    data = {_id:1,name:"gyo"}
    old_data = {_id:1,name:"gyoooooooooo"}
    $.post "/api/users",old_data,(_data)->
      _id = String(_data._id)
      data = {_id:_id,name:"gyo"}
      $.put "/api/users/#{_id}",data,(_data)->
        expect(_data.name).toEqual("gyo")
        done() 