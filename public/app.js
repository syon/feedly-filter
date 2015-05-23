var myApp = angular.module('myApp', []);

myApp.controller('appCtrl', function ($scope, $http) {

  $scope.click = function() {
    $scope.ajaxstate = "processing...";
    $http.post('/').success(function(data) {
      $scope.articles = data;
      $scope.ajaxstate = "";
    });
  };

});
