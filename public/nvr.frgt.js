var keypressessincelastsave = 0;
$(document).ready(function(){
  
 // set defaults in form
  if($('#title').attr('value')==''){
    $('#title').attr('value', 'title');
    $('#title').addClass('default');
  }
  if($('#tags').attr('value')==''){
    $('#tags').attr('value', 'tags(space-separated)');
    $('#tags').addClass('default');
  }
  if($('#slug').attr('value')==''){
    $('#slug').attr('value', 'slug');
    $('#slug').addClass('default');
  }

  // The title
  $("#title").focus(function(event){
    if($(this).attr('value')=='title'){
      $(this).attr('value','').removeClass('default')
    }
  })
  .blur(function(event){
    if($(this).attr('value')==''){
      $(this).attr('value','title')
      $(this).addClass('default')
    }
  });

  //tags
  $("#tags").focus(function(event){
    if($(this).attr('value')=='tags(space-separated)'){
      $(this).attr('value','').removeClass('default')
    }
  })
  .blur(function(event){
    if($(this).attr('value')==''){
      $(this).attr('value','tags(space-separated)')
      $(this).addClass('default')
    }
  });
  
  //slug
  $("#slug").focus(function(event){
    if($(this).attr('value')=='slug'){
      $(this).attr('value','').removeClass('default')
    }
  })
  .blur(function(event){
    if($(this).attr('value')==''){
      $(this).attr('value','slug')
      $(this).addClass('default')
    }
  });

  $("#body_field").change(function(){update_post($('#id').attr('value'), $(this).attr('value'))})
  .keypress(function(key){
    if(key.which == 13){
      update_post($('#id').attr('value'), $(this).attr('value'));
    } else {
      if(keypressessincelastsave++ > 25){
        update_post($('#id').attr('value'), $(this).attr('value'));
      }
    }
  });
  
  $("form").submit(function(){
    if($('input#title').attr('value') == 'title'){ $('input#title').attr('value','');}
    if($('input#slug').attr('value') == 'slug'){ $('input#slug').attr('value','');}
    if($('input#tags').attr('value') == 'tags(space-separated)'){ $('input#tags').attr('value','')}
    return true;
  });
  
  //attach our loading picture.
  $("#loading").ajaxStart(function(){
    $(this).show();
  })
  .ajaxStop(function(){
    $(this).hide();
  });
  
  function update_post(post_id, save_body) {
    $.post('/posts/'+post_id+'.ajax', {_method:'put', body:save_body}, function(updated){
      $('#updated').html('last updated '+updated);
    });
    keypressessincelastsave = 0;
  }

});