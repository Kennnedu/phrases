$(document).ready(function () {
  $('#new-phrase').on('click', function(){
    $('#create-phrase').toggle('display');
    $(this).attr('style', 'display: none');
    $('#hide-new-phrase').show();
  });

  $('#hide-new-phrase').on('click', function(){
    $('#create-phrase').toggle('hide');
    $(this).attr('style', 'display: none');
    $('#new-phrase').attr('style', 'display: block');
  });

  $('.phrase').on('click', function(){
    var id = $(this).attr('data-id');
    $('#edit-phrase-id-'+id).toggle('display');
  });

  $('.update-phrase').submit(function(ev){

    // debugger;
    ev.preventDefault();
    // var id = $(this).data().id;
    // var name = $('#phrase-name-'+id).val();
    $.ajax({
      url: '/update_phrase',
      type: 'POST',
      data: $(this).serialize(),
      contentType: 'json',
      success: function(){
        alert('hello');
      },
      error: function(){
        alert('asdjk');
      }
    });
  });
});