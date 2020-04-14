let monthNames = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];
let today = new Date();
let d;
let month;
let yellow = "#FFCC00";
let red = "#D40511";
let green = "#7DCB51";
let tripStatus = ["#00FF00","#EE3E32"];
let otpDelay = ["#00FF00","#EE3E32"];
let otdDelay = ["#00FF00","#EE3E32"];
let trendColors = ["#ffc107","#312551","#42300e","#513967","#124e53","#141246" , "#B10DC9", "#FFDC00", "#001f3f", "#39CCCC", "#01FF70", "#85144b", "#F012BE", "#3D9970", "#111111", "#AAAAAA"];
let donutColors = ["#C0CA33","#3B00ED","#9C27B0","#D81B60","#FF9800"];
let delayBracketsColors =  ["#00FF00","#66FF66FF","#FFFF00FF","#FBB021","#F68838","#EE3E32"];
let topPosTitle = 8;
let innerRadius = 0.7;
let plot,plot1,plot2,plot3,plot4,plot5;
let donutId = 0;
let plots = [];
let donutMonths = [];
let custLength = 0;
let routeLength = 0;
let errorList ="";
let customerAllSelected = false;
let routeAllSelected = false;
let newRouteLength = 0;


$(".datepicker-input").click(function() {
    $(".datepicker-days .day").click(function() {
        $('.datepicker').hide();
    });
});

function formatDate(date) {
    var d = new Date(date),
        month = '' + (d.getMonth() + 1),
        day = '' + d.getDate(),
        year = d.getFullYear();

    if (month.length < 2) month = '0' + month;
    if (day.length < 2) day = '0' + day;

    return [year, month, day].join('-');
}


$(document).ready(function() { 
	$("#loading-div").show();
   $("#endDate").val(formatDate(today));
   $("#startDate").val(formatDate(new Date(today.getFullYear(), today.getMonth() - 5, 1)));
   //AJAX to get all customers... Change URL
   $.ajax({	
     url: url+"tripcustomer"+"/"+formatDate($("#startDate").val())+" 00:00:00/"+formatDate($("#endDate").val())+" 23:59:59"
   }).done(function(customers) {
	   customers = customers.responseBody;
	    
	   customers.forEach(function (item) {
		   $('#customerName').append("<option value='"+item.tripCustomerId+"'>"+item.customer+"</option>");
	   });
	   $('#customerName').multiselect({
		 buttonWidth: '186px',
		 enableFiltering: true,
		  allSelectedText: 'All',
		  enableCaseInsensitiveFiltering: true,
		  includeSelectAllOption: true,
		  onSelectAll: function () {
		   customerAllSelected= true;
          }
		  }).multiselect('selectAll', false)
			.multiselect('updateButtonText');
	     custLength = $("#customerName").val().length;
       
	    $.ajax({	
		 url: url+"triproute"+"/"+formatDate($("#startDate").val())+" 00:00:00/"+formatDate($("#endDate").val())+" 23:59:59/0"
	   }).done(function(route) {
		   route = route.responseBody;
		   
		   route.forEach(function (item) {
				$('#routeName').append("<option value='"+item.routeKey+"'>"+item.routeKey+"</option>");
		   });
		   $('#routeName').multiselect({
			 buttonWidth: '186px',
			 enableFiltering: true,
			 enableCaseInsensitiveFiltering: true,
			  allSelectedText: 'All',
			  includeSelectAllOption: true
		  }).multiselect('selectAll', false)
			.multiselect('updateButtonText');
			 routeLength = $("#routeName").val().length;
		   showAnalysis();
	   });  
   });
});

$('#customerName').on("change", function(){
	
	if(customerAllSelected)
	{
		
	}
	
	$('#routeName').multiselect("destroy");	
	$('#routeName').html("");
	
	
	 $.ajax({	
		 url: url+"triproute"+"/"+formatDate($("#startDate").val())+" 00:00:00/"+formatDate($("#endDate").val())+" 23:59:59/"+ $("#customerName").val()
	   }).done(function(route) {
		   route = route.responseBody;
		   routeLength = route.length;
		  
		   route.forEach(function (item) {
				$('#routeName').append("<option value='"+item.routeKey+"'>"+item.routeKey+"</option>");
		   });
		   $('#routeName').multiselect({
			 buttonWidth: '186px',
			 enableFiltering: true,
			 enableCaseInsensitiveFiltering: true,
			  allSelectedText: 'All',
			  includeSelectAllOption: true
		 	}).multiselect('selectAll', false)
			.multiselect('updateButtonText');	
		   routeLength = $('#routeName').val().length;
					
	   });
})


$(document).on('input',"#custNameCol .multiselect-search",function (e) {
	
       if($('#customerName').val().length == custLength){
        $('#customerName').multiselect('deselectAll', false).multiselect('refresh');}   
      
})

$(document).on('input',"#routeNameCol .multiselect-search",function (e) {
	
       if($('#routeName').val().length == routeLength){
        $('#routeName').multiselect('deselectAll', false).multiselect('refresh');}   
      
})


/*$(document).on("mouseover", "div.hoverFloat" , function() {
         var offset_pop = $(this).offset();
         $(".multiFloat").css({'left':'30%', 'top': offset_pop.top,  'position': 'absolute'});
         $(".multiFloat").show();
 });

 $(document).on("mouseleave", "div.hoverFloat" , function(){
            $(".multiFloat").hide();
 });
 
 $(document).on("mouseover", "div.hoverFloatAgg" , function() {
         var offset_pop = $(this).offset();
         $(".multiFloatAgg").css({'left':'30%', 'top': offset_pop.top,  'position': 'absolute'});
         $(".multiFloatAgg").show();
 });

 $(document).on("mouseleave", "div.hoverFloatAgg" , function(){
            $(".multiFloatAgg").hide();
 });*/
