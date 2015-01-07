describe "ngBaas",->
  beforeEach ->
    angular.module 'testNgBaas',['ngBaas']
    .config (baasProvider)->
      baasProvider.collection 'user'
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