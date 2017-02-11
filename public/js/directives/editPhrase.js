angular.module('Phrases').directive('editPhrase', function editPhrase($http){
  return {
    restrict: 'E',
    replace: true,
    scope: {
      phrase: "="
    },
    templateUrl: '../templates/edit-phrase.html',
    link: function($scope, element){
      $scope.visibleEdit = true;
      $scope.removePhrase = function(){
        $http({
          method: 'DELETE',
          url: '/phrase/' + $scope.phrase.id,
        }).then( function successCallback(response){
          console.log(response);
          $scope.phrase = {};
          element.parent().parent().empty();
        }, function errorCallback(response){
          console.log(response);
        });
      }

      $scope.updatePhrase = function(){
        $http({
          method: 'PUT',
          url: '/phrase/'+ $scope.phrase.id,
          data: { phrase: $scope.phrase.name + ' ' + $scope.newWord }
        }).then(function successCallback(response){
          console.log(response)
          $scope.phrase.name = response.data.phrase
          $scope.newWord = "";
          $scope.toggleEdit();
        }, function errorCallback(response){
          console.log(response);
        });
      }

      $scope.toggleEdit = function(){
        $scope.visibleEdit = !$scope.visibleEdit;
      }
    }
  }
});
