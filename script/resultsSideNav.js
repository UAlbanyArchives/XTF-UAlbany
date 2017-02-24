$(document).ready(function(){    
	$("#menu-toggle").click(function(e) {
        e.preventDefault();
        $("#wrapper").toggleClass("toggled");
        $(this).toggleClass("slideRight");
    });
});

//mobile nav close when link is clicked
$(function(){
	$("#browseNav .list-group-item").on('click', function(){
		$("#wrapper").removeClass("toggled");
		$("#menu-toggle").removeClass("slideRight");
	});	
});	

$(function(){
  $(window).scroll(function(){
	  if ($(this).scrollTop() < 57){
		 $('.navbar-top').removeClass("fixHalf");
		 $('#page-content-wrapper').removeClass("content-spacer");
		 $('.logo').removeClass("logoHide");
		 $('.ualbany').removeClass("logoHide");
		 $('.smallLogo').removeClass("logoShow");
		 $('.side-nav').css({"top":47-$(this).scrollTop()});
	  } else {
		 $('.navbar-top').addClass("fixHalf");
		 $('#page-content-wrapper').addClass("content-spacer");
		 $('.logo').addClass("logoHide");
		 $('.ualbany').addClass("logoHide");
		 $('.smallLogo').addClass("logoShow");
		 $('.side-nav').css({"top": "-10px"});
	  }
  });
});