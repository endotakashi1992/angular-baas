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
      expect(u._id).toEqual(inserted._id)
      done()
    ,1000
  it "shuld be .save()",->
    expect(inserted.save).toBeDefined()
  it "shuld be .save() and PUT",(done)->
    inserted.text = String new Date()
    inserted.save()
    setTimeout ->
      Users.findOne inserted._id,(_finded)->
        expect(_finded.text).toEqual(inserted.text)
        done()
    ,1000