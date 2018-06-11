Vue.component('navigation-bar', {
  template: "#navigation-bar",
  props: ['username'],
  data: function(){
    return {
      phrase: {
        beginingPhrase: ''
      }
    }
  },
  methods: {
    createPhrase: function(){
    }
  }
});

var app = new Vue({
  el: "#app"
});