# Install
```bash
git clone https://github.com/endotakashi1992/angular-baas
cd angular-baas
bower install && npm i
npm start
# http://localhost:8000
```

# Usage
```coffeescript
angular.module 'myApp',['ngBaas']
.config (baasProvider)->
	baasProvider.controller 'users'
.controller ($scope,Users)->
	$scope.users = Users.find()
	# $scope.users => []
	Users.insert {_id:1,name:"Takashi"}
	# $scope.users => [{_id:1,name:"Takashi"}]
	#This is reactive change
```

#Test
```bash
npm test
```