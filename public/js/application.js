$(document).ready(function () {
  var ws = new WebSocket('ws://' + window.location.host + window.location.pathname);

  editPhrase();
  closeAlert();

  $('body').on('click','.update-phrase', function(ev){
    ev.preventDefault();

    debugger;

    var word = $(this).siblings('div').children().eq(1).val()
    var id = $(this).siblings('div').children().eq(0).val()
    ws.send(JSON.stringify({ method: 'update', id: id, phrase: word }))
  });

  $('body').on('click', '.create-phrase', function(ev){
    ev.preventDefault();

    var newPhrase = $(this).siblings('div').children('#name-phrase').val();
    ws.send(JSON.stringify({ method: 'create', phrase: newPhrase}));
  });

  ws.onmessage = function(res){
    res = JSON.parse(res.data)
    if (res.method == 'create'){
      createPhrase(res);
    } else if (res.method == 'update'){
      debugger;
      updatePhrase(res)
    }
  }
});

function createPhrase(data){
  var newPhrase = '<tr><td><div class="phrase" data-id="'+data.id+'">'+data.phrase+'</div><br>'+
    '<div class="edit-phrase" id="edit-phrase-id-'+data.id+'">'+
    '<form role="form" class="form-inline">'+
    '<div class="form-group">' + '<input type="hidden" name="phrase[id]" value="'+data.id+'">'+
    '<input type="text" name="phrase[name]" class="form-control" id="phrase-name-'+data.id+'" placeholder="Continue phrase" />'+
    '</div> <input class="btn btn-default update-phrase" type="submit" data-id="'+data.id+'" value="Add" />'+
    '</form></div></td><td><a href="/edit_phrase/'+data.id+'"><span class="glyphicon glyphicon-th-list"></span></a></td></tr>';
  $('#name-phrase').val('');
  $('.phrase').off("click");
  $('.phrases').append(newPhrase);
  editPhrase();
  showAlert('The phrase was successfull added!', 'info');
  closeAlert();
}

function updatePhrase(data){
  $('div[data-id='+ data.id +']').text(data.phrase)
  $('#phrase-name-'+data.id).val('');
  showAlert('The phrase was successfull updated!', 'info');
  closeAlert();
}

function editPhrase(){
  $('.phrase').on('click', function(){
    var id = $(this).attr('data-id');
    $('#edit-phrase-id-'+id).toggle('display');
  });
}

function closeAlert(){
  if($('#flash').length){
    setTimeout("$('#flash').toggle('hide')", 2000);
  }
}

function showAlert(msg, type){
  $('#flash-notice').html('<div class<div id="flash"><div class="flash '+type+'">'+msg+'</div></div>');
}
