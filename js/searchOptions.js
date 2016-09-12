$(function(){
	
	$("#searchThis").click(function () {
		var $form = $("form.navbar-form");
		
		$form.find("span.glyphicon-ok").addClass("glyphicon-none").removeClass("glyphicon-ok");
		$(this).find(".glyphicon-none").removeClass('glyphicon-none');
		$(this).find('span:first').addClass('glyphicon-ok');
		
		$form.find(":hidden").each(function () {
			if ($(this).attr('disabled', 'disabled')) {
			}
			else {
				$(this).remove();
			}
		});
		
		$form.find("#searchInput").prop('disabled', true);
		$form.find("#searchInput").css('display', "none");
		$form.find("#scopedSearchInput").css('display', "inline");
		$form.find("#scopedSearchInput").prop('disabled', false);
		$form.find("#scopedSearchHidden").prop('disabled', false);
		
		$form.attr("action", "http://meg.library.albany.edu:8080/archive/view");
		$form.find("#scopedSearchInput").attr("placeholder", "Search this Collection");
		$form.find("#scopedSearchInput").attr("name", "query");
		$form.find("#scopedSearchHidden").attr('name', 'docId');				
		
	});
	
	$("#searchCollections").click(function () {
		var $form = $("form.navbar-form");
		
		$form.find("span.glyphicon-ok").addClass("glyphicon-none").removeClass("glyphicon-ok");
		$(this).find(".glyphicon-none").removeClass('glyphicon-none');
		$(this).find('span:first').addClass('glyphicon-ok');
		
		$form.find(":hidden").each(function () {
			if ($(this).attr('disabled', 'disabled')) {
			}
			else {
				$(this).remove();
			}
		});
		
		$form.find("#searchInput").prop('disabled', false);
		$form.find("#searchInput").css('display', "inline");
		$form.find("#scopedSearchInput").css('display', "none");
		$form.find("#scopedSearchInput").prop('disabled', true);
		$form.find("#scopedSearchHidden").prop('disabled', true);
		
		$form.attr("action", "http://meg.library.albany.edu:8080/archive/search");
		$form.find("#searchInput").attr("placeholder", "Collections");
		$form.find("#searchInput").attr("name", "keyword");
		
			
	});
	
	$("#searchBooks").click(function () {
		var $form = $("form.navbar-form");
		
		$form.find("span.glyphicon-ok").addClass("glyphicon-none").removeClass("glyphicon-ok");
		$(this).find(".glyphicon-none").removeClass('glyphicon-none');
		$(this).find('span:first').addClass('glyphicon-ok');
		
		$form.find(":hidden").each(function () {
			if ($(this).attr('disabled', 'disabled')) {
			}
			else {
				$(this).remove();
			}
		});
		
		$form.find("#searchInput").prop('disabled', false);
		$form.find("#searchInput").css('display', "inline");
		$form.find("#scopedSearchInput").css('display', "none");
		$form.find("#scopedSearchInput").prop('disabled', true);
		$form.find("#scopedSearchHidden").prop('disabled', true);
		
		$form.attr("action", "http://p8991-libms1.albany.edu.libproxy.albany.edu/F/");
		$form.find("input").attr("placeholder", "Rare Books");
		$form.find("input").attr("name", "request");
		
		$form.prepend("<input type='hidden' name='find_code' value='WTS'>");
		$form.prepend("<input type='hidden' name='filter_request_5' value='ALBU'>");
		$form.prepend("<input type='hidden' name='filter_code_5' value='WSL'>");
		$form.prepend("<input type='hidden' name='filter_request_4' value=''>");
		$form.prepend("<input type='hidden' name='filter_code_4' value='WCL'>");
		$form.prepend("<input type='hidden' name='filter_request_3' value=''>");
		$form.prepend("<input type='hidden' name='filter_code_3' value='WYR'>");
		$form.prepend("<input type='hidden' name='filter_request_2' value=''>");
		$form.prepend("<input type='hidden' name='filter_code_2' value='WYR'>");
		$form.prepend("<input type='hidden' name='filter_request_1' value=''>");
		$form.prepend("<input type='hidden' name='filter_code_1' value='WLN'>");
		$form.prepend("<input type='hidden' name='func' value='find-a'>");
			
	});
	
	$("#searchMathes").click(function () {
		var $form = $("form.navbar-form");
		
		$form.find("span.glyphicon-ok").addClass("glyphicon-none").removeClass("glyphicon-ok");
		$(this).find(".glyphicon-none").removeClass('glyphicon-none');
		$(this).find('span:first').addClass('glyphicon-ok');
		
		$form.find(":hidden").each(function () {
			if ($(this).attr('disabled', 'disabled')) {
			}
			else {
				$(this).remove();
			}
		});
		
		$form.find("#searchInput").prop('disabled', false);
		$form.find("#searchInput").css('display', "inline");
		$form.find("#scopedSearchInput").css('display', "none");
		$form.find("#scopedSearchInput").prop('disabled', true);
		$form.find("#scopedSearchHidden").prop('disabled', true);
		
		$form.attr("action", "http://p8991-libms1.albany.edu.libproxy.albany.edu/F/");
		$form.find("input").attr("placeholder", "Mathes Children's Literature");
		$form.find("input").attr("name", "request");
		
		$form.prepend("<input type='hidden' name='y' value='0'>");
		$form.prepend("<input type='hidden' name='x' value='0'>");
		$form.prepend("<input type='hidden' name='adjacent' value='N'>");
		$form.prepend("<input type='hidden' name='request' value=''>");
		$form.prepend("<input type='hidden' name='find_code' value='WTS'>");
		$form.prepend("<input type='hidden' name='request_op' value='AND'>");
		$form.prepend("<input type='hidden' name='request' value=''>");
		$form.prepend("<input type='hidden' name='find_code' value='WTS'>");
		$form.prepend("<input type='hidden' name='request_op' value='AND'>");
		$form.prepend("<input type='hidden' name='find_code' value='WTS'>");
		$form.prepend("<input type='hidden' name='filter_request_5' value='ALBU'>");
		$form.prepend("<input type='hidden' name='filter_code_5' value='WSL'>");
		$form.prepend("<input type='hidden' name='filter_request_4' value='jc*'>");
		$form.prepend("<input type='hidden' name='filter_code_4' value='WCL'>");
		$form.prepend("<input type='hidden' name='filter_request_3' value=''>");
		$form.prepend("<input type='hidden' name='filter_code_3' value='WYR'>");
		$form.prepend("<input type='hidden' name='filter_request_2' value=''>");
		$form.prepend("<input type='hidden' name='filter_request_2' value=''>");
		$form.prepend("<input type='hidden' name='filter_request_2' value=''>");
		$form.prepend("<input type='hidden' name='filter_code_2' value='WYR'>");
		$form.prepend("<input type='hidden' name='filter_request_1' value=''>");
		$form.prepend("<input type='hidden' name='filter_code_1' value='WLN'>");
		$form.prepend("<input type='hidden' name='func' value='find-a'>");
			
	});
	
	$("#searchPhotos").click(function () {
		var $form = $("form.navbar-form");
		
		$form.find("span.glyphicon-ok").addClass("glyphicon-none").removeClass("glyphicon-ok");
		$(this).find(".glyphicon-none").removeClass('glyphicon-none');
		$(this).find('span:first').addClass('glyphicon-ok');
		
		$form.find(":hidden").each(function () {
			if ($(this).attr('disabled', 'disabled')) {
			}
			else {
				$(this).remove();
			}
		});
		
		$form.find("#searchInput").prop('disabled', false);
		$form.find("#searchInput").css('display', "inline");
		$form.find("#scopedSearchInput").css('display', "none");
		$form.find("#scopedSearchInput").prop('disabled', true);
		$form.find("#scopedSearchHidden").prop('disabled', true);
		
		$form.attr("action", "http://luna.albany.edu/luna/servlet/view/search");
		$form.find("input").attr("placeholder", "Digital Selections");
		$form.find("input").attr("name", "q");
			
	});
	
	$("#searchAsp").click(function () {
		var $form = $("form.navbar-form");
		
		$form.find("span.glyphicon-ok").addClass("glyphicon-none").removeClass("glyphicon-ok");
		$(this).find(".glyphicon-none").removeClass('glyphicon-none');
		$(this).find('span:first').addClass('glyphicon-ok');
		
		$form.find(":hidden").each(function () {
			if ($(this).attr('disabled', 'disabled')) {
			}
			else {
				$(this).remove();
			}
		});
		
		$form.find("#searchInput").prop('disabled', false);
		$form.find("#searchInput").css('display', "inline");
		$form.find("#scopedSearchInput").css('display', "none");
		$form.find("#scopedSearchInput").prop('disabled', true);
		$form.find("#scopedSearchHidden").prop('disabled', true);
		
		$form.attr("action", "http://libsearch.albany.edu/search");
		$form.find("input").attr("placeholder", "Student Newspaper");
		$form.find("input").attr("name", "q");
		
		$form.append("<input type='hidden' name='site' value='asp_collection'>");
		$form.append("<input type='hidden' name='client' value='asp_frontend'>");
		$form.append("<input type='hidden' name='output' value='xml_no_dtd'>");
		$form.append("<input type='hidden' name='proxystylesheet' value='asp_frontend'>");
		$form.append("<input type='hidden'  name='proxyreload' value='1'>");
		$form.append("<input type='hidden'  name='numgm' value='5'>");
		$form.append("<input type='hidden' name='filter' value='0'>");
			
	});
	
});