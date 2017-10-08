angular.module('Phrases', []).controller('indexCtrl', function($scope, $http){

  $http({
    method: 'GET',
    url: '/phrases'
  }).then(function successCallback(response){
    $scope.phrases = response.data.phrases;
    console.log($scope.phrases);
  }, function errorCallback(response){
    console.log(response);
  });

  $scope.createPhrase = function(){
    console.log($scope.newPhrase);
    $http({
      method: 'POST',
      url: '/phrase',
      data: { phrase: $scope.newPhrase }
    }).then(function successCallback(response){
      console.log(response.data);
      $scope.phrases.push(response.data.phrase)
      $scope.newPhrase = {}
    }, function errorCallback(response){
      console.log(response);
    });
  }
});
