

$(document).ready(function(){
$('.btn-toggle').click(function() {
$(this).find('.btn').toggleClass('active');  

if ($(this).find('.btn-primary').size()>0) {
    $(this).find('.btn').toggleClass('btn-primary');
}


$(this).find('.btn').toggleClass('btn-default');
   
});

$('.pop-up-hide').click(function() {
    $("#week-filter").hide();

});

$('.pop-up-show').click(function() {
    $("#week-filter").show();

});
$(".switch-content").hide(); 
$("#truck").show(); 

 
});

function viewContent(val) {
$(".switch-content").hide(); 
 $("#"+val).show(); 
}
