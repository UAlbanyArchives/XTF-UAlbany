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

