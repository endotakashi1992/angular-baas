describe "ngBaas",->
  inserted = undefined
  users = undefined
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
      users = Users.find()
      inserted = Users.insert sample,(_inserted)->
        done()
  afterEach ->
    users.close()
  it "shuld be .insert",->
    expect(inserted).toBeDefined()
  it "shuld be findOne",(done)->
    Users.findOne inserted._id,(_finded)->
      expect(_finded.text).toEqual(inserted.text)
      done()
  it "not callback,but succsess!",(done)->
    u = Users.findOne inserted._id
    setTimeout ->
      expect(u._id).toEqual(inserted._id)
      done()
    ,500
  it "shuld be .save()",->
    expect(inserted.save).toBeDefined()
  it "shuld be .save() and PUT",(done)->
    inserted.text = String new Date()
    inserted.save()
    setTimeout ->
      Users.findOne inserted._id,(_finded)->
        expect(_finded.text).toEqual(inserted.text)
        done()
    ,500
  it "shuld be find(),close()",(done)->
    setTimeout ->
      expect(users.close).toBeDefined()
      done()
    ,500
  it "shuld be users[0]",(done)->
    setTimeout ->
      expect(users[0]).toBeDefined()
      done()
    ,500
  it "shuld be save()",(done)->
    setTimeout ->
      expect(users[0].save).toBeDefined()
      done()
    ,500