var app = angular.module('myApp', ['ngMaterial']);

app.controller('AppCtrl', ['$scope', '$mdSidenav', '$http', function($scope, $mdSidenav, $http){

  $scope.ing = false;
  $scope.err = null;

  $scope.toggleSidenav = function(menuId) {
    $mdSidenav(menuId).toggle();
  };

  $scope.click = function() {
    $scope.ing = true;
    $http.post('/')
      .success(function(data) {
        $scope.ing = false;
        console.log(data);
        $scope.articles = data;
      })
      .error(function(data, status, headers, config) {
        $scope.ing = false;
        $scope.err = "Error! -- data:" + data + "  status:" + status
        console.error("data: ", data);
        console.error("status: ", status);
        console.error("headers: ", headers);
        console.error("config: ", config);
      })
    ;
  };

}]);
