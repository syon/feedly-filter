var app = angular.module('myApp', ['ngMaterial']);

app.controller('AppCtrl', ['$scope', '$mdSidenav', '$http', function($scope, $mdSidenav, $http){

  $scope.ing = false;

  $scope.toggleSidenav = function(menuId) {
    $mdSidenav(menuId).toggle();
  };

  $scope.click = function() {
    $scope.ing = true;
    $http.post('/').success(function(data) {
      console.log(data);
      $scope.articles = data;
      $scope.ing = false;
    });
  };

}]);
