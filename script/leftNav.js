

/*
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
*/

$.fn.clicktoggle = function(a, b) {
    return this.each(function() {
        var clicked = false;
        $(this).click(function() {
            if (clicked) {
                clicked = false;
                return b.apply(this, arguments);
            }
            clicked = true;
            return a.apply(this, arguments);
        });
    });
};

$(document).ready(function(){    
	$("#menu-toggle").click(function(e) {
        e.preventDefault();
        $("#wrapper").toggleClass("toggled");
        $(this).toggleClass("slideRight");
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

$(document).ready(function(){    
	$('.moreBtn').on('click', function(){
		$(this).toggleClass("glyphicon-triangle-bottom glyphicon-triangle-top");
	});
});

$(function () {
  $('[data-toggle="popover"]').popover()
})

function copyToClipboard(element) {
  var $temp = $("<input>");
  $("body").append($temp);
  $temp.val($(element).text()).select();
  document.execCommand("copy");
  $temp.remove();
}
	
$( document ).ready(function() {
	if ($(this).scrollTop() == 0){
    $('#menuPanel').css({"display": "none"});
	}
});

//opens accordion panels by anchor link
$( document ).ready(function() {
	$("a.list-group-item").click(function(e) {
		$('.panel-collapse').removeClass("in");
		$(".glyphicon-minus").addClass("glyphicon-plus").removeClass("glyphicon-minus");
		$('a[name="' + $(this).attr("href").substring(1) + '"]').next().find(".glyphicon").removeClass("glyphicon-plus").addClass("glyphicon-minus");
		$('a[name="' + $(this).attr("href").substring(1) + '"]').next().children('.panel-collapse').addClass('in');
		$('a[name="' + $(this).attr("href").substring(1) + '"]').next().children('.panel-collapse').css({"height": "100%"});
	});
});

$( document ).ready(function() {
	if(window.location.hash) {
	  var hash=window.location.hash.substring(1);
	  $target = $('[name=' + hash + ']');
      $target.parents('.collapse').addClass('in').css({height: ''});
	}
});

$(function(){
  $(document).on('click', 'a[href^="#"]', function(ev){
	  var targetId = $(ev.target).parent("a").attr('href').substring(1),
      $target = $('[name=' + targetId + ']');
      $target.parents('.collapse').addClass('in').css({height: ''});
  });
})

$( document ).ready(function() {
	$('.panel-collapse').on('show.bs.collapse', function(){
		$(this).prev().find(".glyphicon").removeClass("glyphicon-plus").addClass("glyphicon-minus");
	});  
	$('.panel-collapse').on('hide.bs.collapse', function(){
		$(this).prev().find(".glyphicon").removeClass("glyphicon-minus").addClass("glyphicon-plus");
	});     
});


//when request modal is clicked get ids from checked boxed and append to href as params
$(function(){
	$( "#request" ).on('shown.bs.modal', function(){
		var checkedValues = $('input.styled:checked').map(function() {
			return this.value;
		}).get();
		var link = $("a#scheduleVisit").attr("href");
		$("a#scheduleVisit").attr("href", link + 'id=');
		var remote = $("a#remoteRequest").attr("href");
		$("a#remoteRequest").attr("href", remote + 'id=');
		$.each(checkedValues, function(n, val) {
			var link = $("a#scheduleVisit").attr("href");
			$("a#scheduleVisit").attr("href", link + "%0A" + val);
			var remoteLink = $("a#remoteRequest").attr("href");
			$("a#remoteRequest").attr("href", remoteLink + "%0A" + val);
		});
	});
});

/*
//Checks or unchecks all children when series is checked or unchecked, passes too many params
$(function(){
	$('input.cmpntCheck').click (function(){
	  if ( $(this).is(':checked') ) {
		$(this).closest("div.section").find('input.fileCheck').prop('checked', true);
	  } else {
		  $(this).closest("div.section").find('input.fileCheck').prop('checked', false);
	  }
	});
});
*/

$(function(){
  $(window).scroll(function(){
	  if ($(this).scrollTop() < 57){
		 $('.navbar-top').removeClass("fixHalf");
		 $('#page-content-wrapper').removeClass("content-spacer");
		 $('.logo').removeClass("logoHide");
		 $('.ualbany').removeClass("logoHide");
		 $('.smallLogo').removeClass("logoShow");
		 $('.side-nav').css({"top":52-$(this).scrollTop()});
	  } else {
		 $('.navbar-top').addClass("fixHalf");
		 $('#page-content-wrapper').addClass("content-spacer");
		 $('.logo').addClass("logoHide");
		 $('.ualbany').addClass("logoHide");
		 $('.smallLogo').addClass("logoShow");
		 $('.side-nav').css({"top": "-5px"});
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

$(function(){
	var $items = $('#seeAlsoList').find('ul').children();
	if ( $items.length > 5 ) {
		$items.hide().slice(0, 4).show();
		$('.viewAll').show();
		$('.viewAll').click(function () {
			$items.show(); // or .fadeIn()
			$(this).remove();
		});
	} else {
		$('.viewAll').remove();
	}
});