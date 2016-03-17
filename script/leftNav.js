
$( document ).ready(function() {
	if ($(this).scrollTop() == 0){
    $('.side-nav').css({"top":52});
	}
});

$(function(){
  $(window).scroll(function(){
	  if ($(this).scrollTop() < 117){
		 $('.side-nav').css({"top":52-$(this).scrollTop()});
	  } else {
		  $('.side-nav').css({"top":-55});
	  }
  });
});

$(document).ready(function(){    
	$('.collapse').on('shown.bs.collapse', function () {
		$(this).prev().find(".glyphicon").removeClass("glyphicon-triangle-bottom").addClass("glyphicon-triangle-top");
	});


	$('.collapse').on('hidden.bs.collapse', function () {
		$(this).prev().find(".glyphicon").removeClass("glyphicon-triangle-top").addClass("glyphicon-triangle-bottom");
	});
});
