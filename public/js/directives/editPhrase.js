angular.module('Phrases').directive('editPhrase', function editPhrase($http){
  return {
    restrict: 'E',
    replace: true,
    scope: {
      phrase: "="
    },
    templateUrl: 'templates/edit-phrase.html',
    link: function($scope, element){

      $scope.removePhrase = function(){
        $http({
          method: 'DELETE',
          url: '/phrase/' + $scope.phrase.id,
        }).then( function successCallback(response){
          console.log(response);
          $scope.phrase = {};
          element.empty();
        }, function errorCallback(response){
          console.log(response);
        });
      }

      // $scope.editPhrase = function(){
      // }
    }
  }
});
