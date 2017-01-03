$(document).ready(function () {
  $('#add-phrase').on('click', function(){
    $('#new-phrase').toggle('display');
    $(this).attr('style', 'display: none');
    $('#hide-new-phrase').show();
  });

  $('#hide-new-phrase').on('click', function(){
    $('#new-phrase').toggle('hide');
    $(this).attr('style', 'display: none');
    $('#add-phrase').attr('style', 'display: block');
  });

  editPhrase();

  $('.update-phrase').submit(function(ev){
    var phrase_tag = $(this).parent().siblings();
    ev.preventDefault();

    $.post('/update_phrase', $(this).serialize()).done(function(data){
      data = $.parseJSON(data);
      phrase_tag.text(data.phrase);
      $('#phrase-name-'+data.id).val('');
      $('#edit-phrase-id-'+data.id).toggle('hide');
    });
  });

  $('.create-phrase').submit(function(ev){

    ev.preventDefault();

    $.post('/create_phrase', $(this).serialize()).done(function(data){
      data = $.parseJSON(data);
      console.log(data);
      $('#name-phrase').val('')
      $('.phrase').off("click");
      $('.phrases').append('<tr><td><div class="phrase" data-id="'+data.id+'">'+data.phrase+'</div>'+
        '<div class="edit-phrase" id="edit-phrase-id-'+data.id+'">'+
          '<form action="/update_phrase" method="post" role="form" class="form-inline update-phrase">'+
            '<div class="form-group">'+
              '<input type="hidden" name="phrase[id]" value="'+data.id+'">'+
              '<input type="text" name="phrase[name]" class="form-control" id="phrase-name-'+data.id+'" placeholder="Continue phrase" />'+
            '</div> <input class="btn btn-primary" type="submit" data-id="'+data.id+'" value="Add" />'+
              '</form></div></td></tr>');
      editPhrase();
    })
    .fail(function(data){

    });
  });

  function editPhrase(){
    $('.phrase').on('click', function(){
      var id = $(this).attr('data-id');
      $('#edit-phrase-id-'+id).toggle('display');
    });
  }
});
