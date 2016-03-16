var app = angular.module('vt-poker-app', ['ui.bootstrap', 'ui.router', 'oc.lazyLoad']);
app.config(function($stateProvider, $urlRouterProvider) {
	$urlRouterProvider.otherwise("/login");
	$stateProvider
	.state('login', {
		url: '/login',
		templateUrl: '/templates/login.html',
		controller: 'LoginController'
	})
	.state('register', {
		url: '/register',
		templateUrl: '/templates/register.html',
		controller: 'RegisterController'
	})
	.state('createNewRoom', {
		url: '/createNewRoom',
		templateUrl: '/templates/createNewRoom.html',
		controller: 'CreateNewRoomController'
	})
	.state('joinRoom', {
		url: '/joinRoom',
		templateUrl: '/templates/joinRoom.html',
		controller: 'JoinRoomController'
	})
	.state('game', {
		url: '/game',
		templateUrl: '/templates/game.html',
		controller: 'GameController',
		resolve: {
			loadGameJs: ['$ocLazyLoad', function($ocLazyLoad) {
				return $ocLazyLoad.load('js/frontend/game/bundle.js');
			}]
		}
	});
});
app.controller('BaseController', ['$scope', '$rootScope', function($scope, $rootScope) {
	$rootScope.$on('userLoggedIn', function(event, args) {
		$scope.userId = args.userId;
		$scope.username = args.username;
		$scope.loginToken = args.loginToken;
	});
	$rootScope.$on('enteredRoom', function(event, args) {
		$scope.roomName = args.roomName;
	});
}]);
app.controller('LoginController', ['$scope', '$http', '$state', '$rootScope', function($scope, $http, $state, $rootScope) {
	$scope.data = {};
	var csrfToken = document.getElementsByName('csrf-token')[0].content;
	$scope.submitPlayerLogin = function(event) {
		event.preventDefault();
		var csrfToken = document.getElementsByName('csrf-token')[0].content;
		$http.post('/submit_login',{
			'username': $scope.data.username,
			'password': $scope.data.password,
			'_csrf': csrfToken
		}).success(function(response, status, headers, config) {
			$rootScope.$emit('userLoggedIn', {
				userId: response.id,
				username: response.username,
				loginToken: response.loginToken
			});
			$state.go('createNewRoom');
		}).error(function(response, status, headers, config) {
			$scope.data.loginErrorMessage = response;
		});
	};
}]);
app.controller('RegisterController', ['$scope', '$http', '$state', '$rootScope', function($scope, $http, $state, $rootScope) {
	$scope.data = {};
	$scope.submitPlayerRegister = function(event) {
		event.preventDefault();
		var csrfToken = document.getElementsByName('csrf-token')[0].content;
		$http.post('/submit_register', {
			'username': $scope.data.username,
			'password': $scope.data.password,
			'email': $scope.data.email,
			'_csrf': csrfToken
		}).success(function(response, status, headers, config) {
			$rootScope.$emit('userLoggedIn', {
				userId: response.id,
				username: response.username,
				loginToken: response.loginToken
			});
			$state.go('createNewRoom');
		}).error(function(response, status, headers, config) {
			$scope.data.registerErrorMessage = response;
		});
	};
}]);
app.controller('CreateNewRoomController', ['$scope', '$http', '$state', '$rootScope', function($scope, $http, $state, $rootScope) {
	$scope.data = {};
	$scope.submitNewRoom = function(event) {
		event.preventDefault();
		var csrfToken = document.getElementsByName('csrf-token')[0].content;
		var userId = document.getElementById('userId').innerText;
		var loginToken = document.getElementById('loginToken').innerText;
		io.socket.post('/create_new_room', {
			'roomName': $scope.data.roomName,
			'password': $scope.data.password,
			'_csrf': csrfToken,
			'userId': userId,
			'loginToken': loginToken
		}, function (resData, jwres) {
			if (jwres.statusCode == 200) {
				$rootScope.$emit('enteredRoom', {
					roomName: resData.roomName
				});
				$state.go('game');
			} else {
				alert(resData);
			}
		});
	};
}]);
app.controller('JoinRoomController', ['$scope', '$http', '$state', '$rootScope', function($scope, $http, $state, $rootScope) {
	$scope.data = {};
	$scope.submitJoinRoom = function(event) {
		event.preventDefault();
		var csrfToken = document.getElementsByName('csrf-token')[0].content;
		var userId = document.getElementById('userId').innerText;
		var loginToken = document.getElementById('loginToken').innerText;
		io.socket.post('/join_room', {
			'roomName': $scope.data.roomName,
			'password': $scope.data.password,
			'_csrf': csrfToken,
			'userId': userId,
			'loginToken': loginToken
		}, function (resData, jwres) {
			if (jwres.statusCode == 200) {
				$rootScope.$emit('enteredRoom', {
					roomName: resData.roomName
				});
				$state.go('game');
			} else {
				alert(resData);
			}
		});
	};
}]);
app.controller('GameController', ['$scope', '$http', function($scope, $http) {
}]);