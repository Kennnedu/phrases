Vue.component('history-entry', {
  template: "#history-entry",
  props: ['historyEntry'],
  computed: {
    createdDate: function(){
      return new Date(this.historyEntry.created_at).toLocaleString();
    }
  }
});

Vue.component('phrase-entry', {
  template: "#phrase-entry",
  props: ['phrase', 'activePhraseId'],
  data: function(){
    return {
      newWord: ""
    }
  },
  computed: {
    isOpenedPhrase: function(){
      return this.activePhraseId == this.phrase.id
    }
  },
  methods: {
    addNewWord: function(){
      phraseEntry = this
      axios({
        url: '/word',
        method: 'post',
        params: {
          word: phraseEntry.newWord,
          phrase_id: phraseEntry.phrase.id
        }
      })
      .then(function(response){
        phraseEntry.newWord = ""
        phraseEntry.phrase.current_state = response.data.phrase.current_state
        phraseEntry.phrase.updated_at = response.data.phrase.updated_at
        phraseEntry.$emit('notify', 'You successfully add new word!', 'success')
      })
      .catch(function(response){
        console.log(response.response);
        phraseEntry.newWord = ""
        phraseEntry.displayEditing = false
        phraseEntry.$emit('notify', response.response.data.message, 'danger')
      });
    },
    loadPhraseInfo: function(){
      phraseEntry = this
      phraseEntry.displayEditing = !phraseEntry.displayEditing
      if(!phraseEntry.displayEditing) {
        return phraseEntry.$emit('save-history', [], 0);
      } 
      axios('/history/' + phraseEntry.phrase.id).then(function(response){
        phraseEntry.$emit('save-history', response.data.words, phraseEntry.phrase.id);
      });
    }
  }
});

Vue.component('navigation-bar', {  template: "#navigation-bar",
  props: ['username', 'phrases'],
  data: function(){
    return {
      beginningPhrase: ''
    }
  },
  methods: {
    createPhrase: function(){
      navigationComponent = this
      axios({
        url: '/phrase',
        method: 'post',
        params:{
          beginning_phrase: this.beginningPhrase
        }
      })
      .then(function(response){
        navigationComponent.beginning_phrase = ''
        navigationComponent.phrases.push(response.data.phrase)
        navigationComponent.$emit('notify', 'You successfully add new phrase!', 'success')
      }).catch(function(response){
        console.log(response.response);
        navigationComponent.beginning_phrase = ''
        navigationComponent.$emit('notify', response.response.data.message, 'danger')
      });
    }
  }
});

var app = new Vue({
  el: "#app",
  data: {
    currentUser: {},
    phrases: [],
    notification: {
      message: '',
      type: ''
    },
    history: [],
    activePhraseId: 0
  },
  created: function(){
    app = this;
    axios('/phrases').then(function(response){
      app.phrases = response.data.phrases
      app.currentUser = response.data.user
    })
  },
  computed: {
    sortedPhrases: function(){
      return this.phrases.sort(function(a, b){
        var dateA = new Date(a.updated_at)
        var dateB = new Date(b.updated_at)
        return dateB - dateA
      })
    }
  },
  watch: {
    notification: { 
      handler: function(){
        if(this.notification.message.length) {
          app = this
          setTimeout(function(){
            app.notification.message = ''
            app.notification.type = ''
          }, 10000);
        }
      },
      deep: true
    }
  },
  methods: {
    changeNotification: function(message, type){
      this.notification.message = message
      this.notification.type = type
    },
    saveHistory: function(history, activePhraseId){
      this.activePhraseId = activePhraseId
      this.history = history.reverse()
    }
  }
});