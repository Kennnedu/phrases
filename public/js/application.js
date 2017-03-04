$(document).ready(function () {
  var ws = new WebSocket('ws://' + window.location.host + window.location.pathname);

  editPhrase();

  $('body').on('click','.update-phrase', function(ev){

    ev.preventDefault();

    var word = $(this).children('div').children().eq(1).val()
    var id = $(this).children('div').children().eq(0).val()
    ws.send(JSON.stringify({ method: 'update', id: id, phrase: word }))
  });

  // $('.dash-phrase').hover(function(){
  //   $(this).css('background-color', '#265A88')
  //   $(this).css('border-radius', '3px')
  //   $(this).css('color', '#ffffff')
  // });

  // $('.dash-phrase').

  $('body').on('click', '.create-phrase', function(ev){
    ev.preventDefault();

    var newPhrase = $(this).children('div').children('#name-phrase').val();
    ws.send(JSON.stringify({ method: 'create', phrase: newPhrase}));
  });

  ws.onmessage = function(res){
    res = JSON.parse(res.data)
    if (res.method == 'create'){
      createPhrase(res);
    } else if (res.method == 'update'){
      updatePhrase(res)
    }
  }

  function createPhrase(data){
    var newPhrase = '<tr><td><div class="phrase" data-id="'+data.id+'">'+data.phrase+'</div><br>'+
      '<div class="edit-phrase" id="edit-phrase-id-'+data.id+'">'+
      '<form role="form" class="form-inline update-phrase">'+
      '<div class="form-group">' + '<input type="hidden" name="phrase[id]" value="'+data.id+'">'+
      '<input type="text" name="phrase[name]" class="form-control" id="phrase-name-'+data.id+'" placeholder="Continue phrase" />'+
      '</div> <input class="btn btn-default" type="submit" data-id="'+data.id+'" value="Add" />'+
      '</form></div></td><td><a href="/edit_phrase/'+data.id+'"><span class="glyphicon glyphicon-th-list"></span></a></td></tr>';
    $('#name-phrase').val('');
    $('.phrase').off("click");
    $('.phrases').append(newPhrase);
    editPhrase();
  }

  function updatePhrase(data){
    $('div[data-id='+ data.id +']').text(data.phrase)
    $('#phrase-name-'+data.id).val('');
  }

  function editPhrase(){
    $('.phrase').on('click', function(){
      var id = $(this).attr('data-id');
      $('#edit-phrase-id-'+id).toggle('display');
    });
  }
});
