// Common JavaScript code across your application goes here.

function show_comment_link(n)
{
  $('#comment_link_'+n).show();
}

function hide_comment_link(n)
{
  $('#comment_link_'+n).hide();
}

function toggle_preview()
{
  $('#node_content').toggle();
  $('#node_preview').toggle();
  if ($('#node_content').val != '')
  {
    $.ajax({
      type: "POST",
      url: "/admin/nodes/preview",
      data: "content=" + escape($("#node_content").val()),
      success: function(response){
        $('#node_preview').attr('innerHTML', response);
      }
    });
    
  }
}

function post_comment()
{
  var email = $("#comment_email").val();
  var name = $("#comment_name").val();
  var url = $("#comment_url").val();
  var comment = $("#comment_comment").val();
  var node_id = $("#comment_node_id").val();
  $.ajax({
    type: "POST",
    url: "/comments/new",
    data: "email=" + email + "&name=" + name + "&url=" + url + "&comment=" + comment + "&node_id=" + node_id,
    error: function(response){
      $("#comment_message").attr('innerHTML', response.responseText);
    },
    success: function(response){
      if ($('#no-comment'))
      {
        $('#no-comment').remove();
      }
      $('#comment_message').attr('innerHTML', '<span class="success-message">Thank you for your comment!</span>');
      $('ol#comment_list').append(response);
      $('ol#comment_list').children(':last-child').effect("highlight", {}, 2500);
    }
  });
}