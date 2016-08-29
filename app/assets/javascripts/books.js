/* global $ */
var loadFunction = function() {
  $(".caption").hover(function(){
    $(this).find(".caption-text").fadeIn(400);
  }, function(){
    $(this).find(".caption-text").fadeOut(400);
  });
  
	$("article").readmore({
	  collapsedHeight: 200
	});
	$('.see-more').readmore({
    collapsedHeight: 40,
    moreLink: '<a href="#" class="btn btn-primary">Show More Book Details</a>',
    lessLink: '<a href="#" class="btn btn-primary">Close</a>'
  });
  
  /*Source: http://www.bootply.com/peFUdnwOpZ
  $('.closeall').click(function(){
	  $('.panel-collapse.in')
	    .collapse('hide');
	});
	$('.openall').click(function(){
	  $('.panel-collapse:not(".in")')
	    .collapse('show');
	});*/
};
$(document).ready(loadFunction);
$(document).on('turbolinks:load', loadFunction);


