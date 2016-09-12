

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

/*
$(document).ready(function () {

    $('.collapse').on('shown hidden', function () {
        $('body').scrollspy('refresh');
    });

});*/


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
	$("#collectionMenu").on("activate.bs.scrollspy", function(){
		if ($(".active").parent(".sub-menu").length) {
			$(".active").parent(".sub-menu").prev(".list-group-item").addClass("active");
			$(".active").parent(".sub-menu").parent(".collapse").prev(".list-group-item").addClass("active");
		} else {
			$(".active").parent(".collapse").prev(".list-group-item").addClass("active");
		}
    })
});

$(document).ready(function(){    
	$("#menu-toggle").click(function(e) {
        e.preventDefault();
        $("#wrapper").toggleClass("toggled");
        $(this).toggleClass("slideRight");
    });
});

$(document).ready(function(){    
	$('.collapse').on('shown.bs.collapse', function () {
		$(this).prev().find("span.glyphicon-triangle-bottom").removeClass("glyphicon-triangle-bottom").addClass("glyphicon-triangle-top");
	});


	$('.collapse').on('hidden.bs.collapse', function () {
		$(this).prev().find("span.glyphicon-triangle-top").removeClass("glyphicon-triangle-top").addClass("glyphicon-triangle-bottom");
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
		$('a[name="' + $(this).attr("href").substring(1) + '"]').next().find(".glyphicon glyphicon-plus").removeClass("glyphicon-plus").addClass("glyphicon-minus");
		$('a[name="' + $(this).attr("href").substring(1) + '"]').next().children('.panel-collapse').addClass('in');
		$('a[name="' + $(this).attr("href").substring(1) + '"]').next().children('.panel-collapse').css({"height": "100%"});
	});
});


// when page is opened with hash to collapsed panel, open panel
$( document ).ready(function() {
	if(window.location.hash) {
	  var hash=window.location.hash.substring(1);
	  $target = $('[name=' + hash + ']');
      $target.parents('.collapse').addClass('in').css({height: ''});
	}
});

// when link to collapsed panel is clicked, open panel
$(function(){
	 $("#collectionMenu .list-group-item a").click(function(){
		var targetId = $(this).attr('href').substring(1);
		$target = $('[id=' + targetId + ']');
		if ($target.attr("class") == "anchor") {
			$target.next("div.panel").find('.collapse').addClass('in').css({height: ''});
		}
	 })
});

/*
$(function(){
  $(document).on('click', 'a[href^="#"]', function(ev){
	  var targetId = $(ev.target).parent("a").attr('href').substring(1),
      $target = $('[name=' + targetId + ']');
      $target.parents('.collapse').addClass('in').css({height: ''});
  });
})*/

$( document ).ready(function() {
	$('.panel-collapse').on('show.bs.collapse', function(){
		$(this).prev().find(".glyphicon").removeClass("glyphicon-plus").addClass("glyphicon-minus");
	});  
	$('.panel-collapse').on('hide.bs.collapse', function(){
		$(this).prev().find(".glyphicon").removeClass("glyphicon-minus").addClass("glyphicon-plus");
	});     
});

$(function(){
	$('span.badge').parent().closest('a#tocItem').css('background-color', '#eaaa00').css('color', '#ffffff');
});

$(function(){
	$('.checkbox-primary').one('click', function(e) {
		$(".requestModel").fadeIn(100).fadeOut(100).fadeIn(100).fadeOut(100).fadeIn(100);
		$('.checkbox-primary').unbind('click');
	});
});


//when request modal is clicked get ids from checked boxed and append to href as params
$(function(){
	$( "#request" ).on('shown.bs.modal', function(){
		var checkedValues = $('input.styled:checked').map(function() {
			return this.value;
		}).get();
		var checkedString = $('input.styled:checked').map(function() {
			return this.value;
		}).get().toString();
		if (checkedString.indexOf('RESTRICT') >= 0 ) {
			$("div.alert-danger").css("display", "block");
		} else {
			$("div.alert-danger").css("display", "none");
		}
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

/*$(function() { 
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
});*/

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

//mobile nav close when link is clicked
$(function(){
	$("#sidebar-wrapper .list-group-item").on('click', function(){
		$("#wrapper").removeClass("toggled");
		$("#menu-toggle").removeClass("slideRight");
	});	
	$("#fa-brand a").on('click', function(){
		$("#wrapper").removeClass("toggled");
		$("#menu-toggle").removeClass("slideRight");
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

//search term plus and minus
$(function(){
	$('.searchPlus').on('click', function(){
		if(window.location.hash) {
			var $max = $(this).attr("title");
			var $current = window.location.hash.substr(1);
			if(parseInt($current) >= parseInt($max)) {
				$(this).attr("href", "#1");
			} else {
				var $next = parseInt($current) + 1;
				$(this).attr("href", "#" +$next.toString());
			}
		} 
	});
	$('.searchMinus').on('click', function(){
		if(window.location.hash) {
			var $current = window.location.hash.substr(1);
			if(parseInt($current) <= 1 ) {
				var $max = $(this).attr("title");
				$(this).attr("href", "#" + $max.toString());
			} else {
				var $prev = parseInt($current) - 1;
				$(this).attr("href", "#" +$prev.toString());
			}
		} 
	});
});