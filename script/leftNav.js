$( document ).ready(function() {
	if ($(this).scrollTop() == 0){
    $('#topSpacer').hide();
	} else {
		$('.breadcrumb').css({"top":20});
	}
});


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

$( document ).ready(function() {
	if ($(this).scrollTop() == 0){
    $('.breadcrumb').css({"top":127});
	}
});

$(function(){
  $(window).scroll(function(){
	  if ($(this).scrollTop() < 117){
		 $('.breadcrumb').css({"top":127-$(this).scrollTop()});
		 $('#topSpacer').hide();
	  } else {
		  if ($(window).width() >= 766) {
			  $('.breadcrumb').css({"top":20});
			  $('#topSpacer').show();
		  }
	  }
  });
});

$(document).ready(function(){    
	$('.collapse').on('shown.bs.collapse', function () {
		$(this).prev().find("span.glyphicon").removeClass("glyphicon-triangle-bottom").addClass("glyphicon-triangle-top");
	});


	$('.collapse').on('hidden.bs.collapse', function () {
		$(this).prev().find("span.glyphicon").removeClass("glyphicon-triangle-top").addClass("glyphicon-triangle-bottom");
	});
});

$( document ).ready(function() {
	if ($(this).scrollTop() == 0){
    $('#menuPanel').css({"display": "none"});
	}
});

$(function(){
  $(window).scroll(function(){
	  if ($(this).scrollTop() < 117){
		 $('#menuPanel').css({"display": "none"});
	  } else {
		  $('#menuPanel').css({"display": "block"});
	  }
  });
});

$(function() { 
	$('#searchForm').submit(function() {
		$("input[type=radio]").attr('disabled', true);
	});
});

$(function() { 
	$('#searchForm2').submit(function() {
		$("input[type=radio]").attr('disabled', true);
	});
});

$(function() { 
	if(window.location.href.indexOf("?query=") > -1) {
		$("#searchForm").attr("action", "view");
		$("#searchAll").prop('disabled', true);
		$("#searchAll").css("display", "none");
		$("#srch-term").css("display", "block");
		$("#srch-term").prop('disabled', false);
		$("#srch-termValue").prop('disabled', false);
		$("#searchForm2").attr("action", "view");
		$("#searchAll2").prop('disabled', true);
		$("#searchAll2").css("display", "none");
		$("#srch-term2").css("display", "block");
		$("#srch-term2").prop('disabled', false);
		$("#srch-termValue2").prop('disabled', false);
		var value = 2;
		$("input[type=radio][value=" + value + "]").attr('checked', 'checked');
    }
});

$(function() { 
	$("input[type='radio']").change(function(){
		if ($(this).val() === '1') {
			$("#searchForm").attr("action", "search");
			$("#searchAll").css("display", "block");
			$("#srch-term").css("display", "none");
			$("#searchAll").prop('disabled', false);
			$("#srch-term").prop('disabled', true);
			$("#srch-termValue").prop('disabled', true);
			$("#searchForm2").attr("action", "search");
			$("#searchAll2").css("display", "block");
			$("#srch-term2").css("display", "none");
			$("#searchAll2").prop('disabled', false);
			$("#srch-term2").prop('disabled', true);
			$("#srch-termValue2").prop('disabled', true);
		} else if ($(this).val() === '2') {
			$("#searchForm").attr("action", "view");
			$("#searchAll").prop('disabled', true);
			$("#searchAll").css("display", "none");
			$("#srch-term").css("display", "block");
			$("#srch-term").prop('disabled', false);
			$("#srch-termValue").prop('disabled', false);
			$("#searchForm2").attr("action", "view");
			$("#searchAll2").prop('disabled', true);
			$("#searchAll2").css("display", "none");
			$("#srch-term2").css("display", "block");
			$("#srch-term2").prop('disabled', false);
			$("#srch-termValue2").prop('disabled', false);
		} 
	});
});

$(function(){
	$(".dropdown-menu > li > a.trigger").on("click",function(e){
		var current=$(this).next();
		var grandparent=$(this).parent().parent();
		if($(this).hasClass('left-caret')||$(this).hasClass('right-caret'))
			$(this).toggleClass('right-caret left-caret');
		grandparent.find('.left-caret').not(this).toggleClass('right-caret left-caret');
		grandparent.find(".sub-menu:visible").not(current).hide();
		current.toggle();
		e.stopPropagation();
	});
	$(".dropdown-menu > li > a:not(.trigger)").on("click",function(){
		var root=$(this).closest('.dropdown');
		root.find('.left-caret').toggleClass('right-caret left-caret');
		root.find('.sub-menu:visible').hide();
	});
});