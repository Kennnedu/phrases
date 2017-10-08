function editPhrase(){
  return {
    restrict: 'E',
    replace: true,
    scope: {
      phrase: "="
    },
    templateUrl: 'templates/edit-phrase.html'
    // link: function(scope){
    // }
  }
}

angular.module('Phrases').directive('editPhrase', editPhrase);
