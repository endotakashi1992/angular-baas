describe "ngBaas",->
  window.Users = undefined
  beforeEach ->
    angular.module 'testNgBaas',['ngBaas']
    .config (baasProvider)->
      baasProvider.collection 'users'
    module 'ngBaas','testNgBaas'
    inject (Users)->
      window.Users = Users
      window.coll = Users.find()
  it "shuld exist User",->
    expect(Users).toBeDefined()
  it "shuld be insert",(done)->
    str = String(Date())
    row = {text:str}
    Users.insert row,(_row)->
      expect(_row.text).toEqual(str)
      done()
  it "_id is shuld be inclement",(done)->
    Users.insert {name:"first"},(first)->
      Users.insert {name:"second"},(second)->
        expect(second._id).toEqual(++first._id)
        done()
  it "reactive collection",(done)->
    Users.insert {name:"tdd"},(data)->
      setTimeout ->
        expect(coll).toContain data
        done()
      ,500
  it "Model shuld have findOne",(done)->
    Users.insert {name:"tdd"},(data)->
      _id = data._id
      Users.findOne _id,(row)->
        expect(row._id).toEqual(_id)
        done()
