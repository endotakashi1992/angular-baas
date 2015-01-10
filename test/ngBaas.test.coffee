describe "ngBaas",->
  inserted = undefined
  beforeEach (done)->
    angular.module 'testNgBaas',['ngBaas']
    .config (baasProvider)->
      baasProvider.collection 'users'
    module 'ngBaas','testNgBaas'
    inserted = undefined
    inject (Users)->
      sample = 
        text:String(new Date())
      window.Users = Users
      _inserted = Users.insert sample,(_inserted)->
        inserted = _inserted
        done()
  it "shuld be .insert",->
    expect(inserted).toBeDefined()
  it "shuld be findOne",(done)->
    Users.findOne inserted._id,(_finded)->
      expect(_finded.text).toEqual(inserted.text)
      done()
  it "not callback,but succsess!",(done)->
    u = Users.findOne inserted._id
    setTimeout ->
      expect(u).toEqual(inserted)
      done()
    ,1000
  # it "shuld be find()",(done)->
  #   users = Users.find()
  #   setTimeout ->
  #     users.
  #     done()
  #   ,3000
    # users = Users.find ->
    #   users.
  # it "shuld exist User",->
  #   expect(Users).toBeDefined()
  # it "shuld be insert",(done)->
  #   str = String(Date())
  #   row = {text:str}
  #   Users.insert row,(_row)->
  #     expect(_row.text).toEqual(str)
  #     done()
  # it "_id is shuld be inclement",(done)->
  #   Users.insert {name:"first"},(first)->
  #     Users.insert {name:"second"},(second)->
  #       expect(second._id).toEqual(++first._id)
  #       done()
  # it "reactive collection",(done)->
  #   Users.insert {name:"tdd"},(data)->
  #     setTimeout ->
  #       expect(coll).toContain data
  #       done()
  #     ,500
  # it "Model shuld have findOne",(done)->
  #   Users.insert {name:"tdd"},(data)->
  #     _id = data._id
  #     Users.findOne _id,(row)->
  #       expect(row._id).toEqual(_id)
  #       done()