Vue.component('navigation-bar', {
  template: "#navigation-bar",
  props: ['username'],
  data: function(){
    return {
      phrase: {
        beginningPhrase: ''
      }
    }
  },
  methods: {
    createPhrase: function(){
      axios({
        url: '/create_phrase',
        method: 'post',
        params:{
          beginning_phrase: this.phrase.beginningPhrase
        }
      })
      .then(function(response){
        // debugger;
      }).catch(function(response){
        debugger;
      });
    }
  }
});

var app = new Vue({
  el: "#app",
  data: {
    user: {
      id: '',
      username: '',
      phrases: {}
    }
  }
});