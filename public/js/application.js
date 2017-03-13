$(document).ready(function () {
  var ws = new WebSocket('ws://' + window.location.host + window.location.pathname);

  editPhrase();
  closeAlert();

  $('body').on('click','.update-phrase', function(ev){
    ev.preventDefault();

    var word = $(this).siblings('div').children().eq(1).val()
    var id = $(this).siblings('div').children().eq(0).val()
    ws.send(JSON.stringify({ method: 'update', id: id, phrase: word }))
  });

  $('body').on('click', '.create-phrase', function(ev){
    ev.preventDefault();

    var newPhrase = $(this).siblings('div').children('#name-phrase').val();
    ws.send(JSON.stringify({ method: 'create', phrase: newPhrase}));
  });

  $('body').on('click', '.show-history', function(ev){
    ev.preventDefault();

    var id = $(this).parent().siblings().children('div.phrase').data('id');
    ws.send(JSON.stringify({ method: 'show-history', id: id }));
  });

  ws.onmessage = function(res){
    res = JSON.parse(res.data)
    if (res.method == 'create'){
      createPhrase(res);
    } else if (res.method == 'update'){
      updatePhrase(res);
    } else if (res.method == 'show-history'){
      showHistory(res);
    }
  }
});

function createPhrase(data){
  if (data.status == 404){
    return blinkAlert(data.message, 'warning');
  }
  var newPhrase = '<tr><td><div class="phrase" data-id="'+data.id+'">'+data.phrase+'</div><br>'+
    '<div class="edit-phrase" id="edit-phrase-id-'+data.id+'">'+
    '<form role="form" class="form-inline">'+
    '<div class="form-group">' + '<input type="hidden" name="phrase[id]" value="'+data.id+'">'+
    '<input type="text" name="phrase[name]" class="form-control" id="phrase-name-'+data.id+'" placeholder="Continue phrase" />'+
    '</div> <input class="btn btn-default update-phrase" type="submit" data-id="'+data.id+'" value="Add" />'+
    '</form></div></td><td><a href="#" class="show-history"><span class="glyphicon glyphicon-th-list"></span></a></td></tr>';
  $('#name-phrase').val('');
  $('.phrase').off("click");
  $('.phrases').prepend(newPhrase);
  editPhrase();
  blinkAlert('The phrase was successfull added!', 'info');
}

function updatePhrase(data){
  if (data.status == 404){
    return blinkAlert(data.message, 'warning');
  }
  $('div[data-id='+ data.id +']').text(data.phrase)
  $('#phrase-name-'+data.id).val('');
  blinkAlert('The phrase was successfull updated!', 'info');
}

function showHistory(data){
  $('#history').css('display', 'block');
  $('#history').html('<div class="well well-lg">'+data.phrases.name+'</div>'+historiesTags(data.histories)); 
}

function historiesTags(histories){
  var tags = '';
  debugger;
  $.each(histories, function(index, history){
    debugger;
    tags += '<div class="panel panel-defaul">'+
      '<div class="panel-heading"><h3 class="panel-title">'+
      history.created_at+'</h3></div><div class="panel-body">'+
      history.part_phrase+'</div></div>'
  });
  return tags;
}

function editPhrase(){
  $('.phrase').on('click', function(){
    var id = $(this).attr('data-id');
    $('#edit-phrase-id-'+id).toggle('display');
  });
}

function blinkAlert(msg, type){
  $('#flash-notice').html('<div class<div id="flash"><div class="flash '+type+'">'+msg+'</div></div>');
  closeAlert();
}

function closeAlert(){
  if($('#flash').length){
    setTimeout("$('#flash').toggle('hide')", 2000);
  }
}
