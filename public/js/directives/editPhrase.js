function editPhrase(){
  return {
    restrict: 'E',
    replace: true,
    scope: {
      phrase: "="
    },
    templateUrl: 'templates/edit-phrase.html',
    link: function(scope){
      debugger;
    }
  }
}

angular.module('Phrases').directive('editPhrase', editPhrase);
