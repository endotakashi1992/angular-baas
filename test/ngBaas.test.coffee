describe "ngBaas",->
  beforeEach ->
    angular.module 'testNgBaas',['ngBaas']
    .config (baasProvider)->
      baasProvider.collection 'users'
    module 'ngBaas','testNgBaas'
  it "shuld exist User",->
    inject (Users)->
      expect(Users).toBeDefined()
  it "shuld be insert",(done)->
    inject (Users)->
      str = String(Date())
      row = {text:str}
      Users.insert row,(_row)->
        expect(_row.text).toEqual(str)
        done()
  it "_id is shuld be inclement",(done)->
    inject (Users)->
      Users.insert {name:"first"},(first)->
        Users.insert {name:"second"},(second)->
          expect(second._id).toEqual(++first._id)
          done()