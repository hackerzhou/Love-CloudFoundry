var clientWidth = $(window).width();
var clientHeight = $(window).height();
$(window).resize(function() {
  setCopyrightPos();
  var newWidth = $(window).width();
  var newHeight = $(window).height();
  if (newWidth != clientWidth && newHeight != clientHeight) {
    location.replace(location);
  }
});

$(document).ready(function(){
  setCopyrightPos();
});

function setCopyrightPos(){
  var content = $("#content");
  var contentBottomY = content.offset().top + content.height();
  if ($(document).height() - contentBottomY > 10) {
    $("#copyright").css("padding-top", $(document).height() - $("#copyright").height() + "px");
  } else {
    $("#copyright").css("padding-top", $(document).height() + "px");
  }
  $("#copyright").css("display", "block");
}