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
let productLength = 0;
let errorList ="";
let customerAllSelected = false;
let routeAllSelected = false;
let newRouteLength = 0;

let delayAnalysisColors = ["#ffa600","#003f5c"];
let donutDryTCL = []; 
let dryTCLNames = ["DRY1","TCL1"];
let dryTCLname;

let dayLength = 0;
let dayAllSelected = false;

let productAllSelected = false;
var routeNameLength = 0;
var prodLength = 0;

var regionNameLength = 0;
var hubNameLength = 0;
var custNewLength = 0;

$("#startDate").datepicker().on('show', function (ev) {
	$('#startDate').datepicker('update', (new Date(today.getFullYear(), today.getMonth() - 5, 1)));
});

//$(".datepicker-input").click(function() {
//    $(".datepicker-days .day").click(function() {
//        $('.datepicker').hide();
//    }); 
//});

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
	   $('#dayName').multiselect({
		 maxHeight: 200,
		 buttonWidth: '186px',
		 enableFiltering: true,
		 allSelectedText: 'All',
		 enableCaseInsensitiveFiltering: true,
		 includeSelectAllOption: true,
		 onSelectAll: function () {
		 //   dayAllSelected= true;
		  }
		}).multiselect('selectAll', false)
		.multiselect('updateButtonText');
		//dayLength = $("#dayName").val().length;
	
   $("#loading-div").show();
   $("#endDate").val(formatDate(today));
   $("#startDate").val(formatDate(new Date(today.getFullYear(), today.getMonth() - 5, 1)));
   //AJAX to get all customers... Change URL
 /*  $('#regionName').multiselect({
		 maxHeight: 200,
		 buttonWidth: '186px',
		 enableFiltering: true,
		 allSelectedText: 'All',
		 enableCaseInsensitiveFiltering: true,
		 includeSelectAllOption: true,
		 onSelectAll: function () {
		  }
		}).multiselect('selectAll', false)
		.multiselect('updateButtonText');  
   
   $('#hubName').multiselect({
		 maxHeight: 200,
		 buttonWidth: '186px',
		 enableFiltering: true,
		 allSelectedText: 'All',
		 enableCaseInsensitiveFiltering: true,
		 includeSelectAllOption: true,
		 onSelectAll: function () {
		  }
		}).multiselect('selectAll', false)
		.multiselect('updateButtonText');
*/
   
   $.ajax({
		url: url + '/getDelayRegions',
		type: "POST",
		contentType: "application/json",
		data: JSON.stringify({
		    startDate: formatDate($("#startDate").val()).toString(),
		    endDate: formatDate($("#endDate").val()).toString()
	  }),  
	   success: function (regions) {	      
	   regions = regions.responseBody;
	    //console.log("regions ::  " + JSON.stringify(regions)); 
	   regionNameLength = regions.length;
	   regions.forEach(function (item) {
		   $('#regionName').append($("<option></option>").attr("value", "'" + item.regionName + "'").text(item.regionName));
	   });
	   $('#regionName').multiselect({
		 maxHeight: 200,  
		 buttonWidth: '186px',
		 enableFiltering: true,
		  allSelectedText: 'All',
		  enableCaseInsensitiveFiltering: true,
		  includeSelectAllOption: true,
		  onSelectAll: function () {
		   regionAllSelected= true;
          }
		  }).multiselect('selectAll', false)
			.multiselect('updateButtonText');
	 
	$.ajax({
		url: url + '/getDelayRoutes',
		type: "POST",
		contentType: "application/json",
		data: JSON.stringify({
		    startDate: formatDate($("#startDate").val()).toString(),
		    endDate: formatDate($("#endDate").val()).toString(),
		    regionName: $("#regionName").val().length === regionNameLength || $("#regionName").val() == '' ? 'all' : $("#regionName").val().toString()//newly added
	  }),  
	   success: function (routes) {	      
	   routes = routes.responseBody;
	   //console.log("routes " + JSON.stringify(routes)); 
	   routeNameLength = routes.length;
	   routes.forEach(function (item) {
		   $('#routeName').append($("<option></option>").attr("value", "'" + item.routeKey + "'").text(item.routeKey));
	   });
	   $('#routeName').multiselect({
		 maxHeight: 200,  
		 buttonWidth: '186px',
		 enableFiltering: true,
		 allSelectedText: 'All',
		 enableCaseInsensitiveFiltering: true,
		 includeSelectAllOption: true,
		 onSelectAll: function () {
		   routeAllSelected= true;
         }
		 }).multiselect('selectAll', false)
		   .multiselect('updateButtonText');
	       routeLength = $("#routeName").val().length;
 
	  $.ajax({
		url: url + '/getDelayHubs',
		type: "POST",
		contentType: "application/json",
		data: JSON.stringify({
		    startDate: formatDate($("#startDate").val()).toString(),
		    endDate: formatDate($("#endDate").val()).toString(),
		    regionName: $("#regionName").val().length === regionNameLength || $("#regionName").val() == '' ? 'all' : $("#regionName").val().toString(),//newly added
			routeKey: $("#routeName").val().length === routeNameLength || $("#routeName").val() == '' ? 'all' : $("#routeName").val().toString()
	  }),  
	   success: function (hubs) {	      
	   hubs = hubs.responseBody;
	   //console.log("hubs " + JSON.stringify(hubs)); 
	   hubNameLength = hubs.length;
	   hubs.forEach(function (item) {
		   $('#hubName').append($("<option></option>").attr("value", "'" + item.hubId + "'").text(item.hubName));
	   });
	   $('#hubName').multiselect({
		maxHeight: 200,  
		buttonWidth: '186px',
		enableFiltering: true,
		allSelectedText: 'All',
		enableCaseInsensitiveFiltering: true,
		includeSelectAllOption: true,
		onSelectAll: function () {
		  hubAllSelected= true;
        }
	   }).multiselect('selectAll', false)
		 .multiselect('updateButtonText');
 
		   $.ajax({
				url: url + '/getDelayCustomer',
				type: "POST",
				contentType: "application/json",
				data:  JSON.stringify({  
					startDate: formatDate($("#startDate").val()).toString(),
					endDate: formatDate($("#endDate").val()).toString(),
					regionName: $("#regionName").val().length === regionNameLength || $("#regionName").val() == '' ? 'all' : $("#regionName").val().toString(),//newly added
					routeKey: $("#routeName").val().length === routeNameLength || $("#routeName").val() == '' ? 'all' : $("#routeName").val().toString(),//$("#routeName").val().toString(),
					hubName:  $("#hubName").val().toString()
		    }),	
		    success: function (customers) {
			customers = customers.responseBody;
			//console.log("customers " + JSON.stringify(customers)); 
			custLength = customers.length;
			custNewLength = $("#customerName").val().length;
			//console.log("custLength in ready fun " + custLength);
			customers.forEach(function (item) { 
			  $('#customerName').append($("<option></option>").attr("value", "'" + item.tripCustomerId + "'").text(item.customer));
		   });
		  $('#customerName').multiselect({
		 maxHeight: 200,  	 
		 buttonWidth: '186px',
		 enableFiltering: true,
		 allSelectedText: 'ALL',
		 enableCaseInsensitiveFiltering: true,
		 includeSelectAllOption: true,
		 onSelectAll: function () {
			 customerAllSelected= true;
		 }
		 }).multiselect('selectAll', false)
		 .multiselect('updateButtonText');
	     $.ajax({
		   url: url + '/getDelayProduct',
		   type: "POST",
		   contentType: "application/json",
		   data: JSON.stringify({
			 startDate: formatDate($("#startDate").val()).toString(),
			 endDate: formatDate($("#endDate").val()).toString(),
			 //routeKey: $("#routeName").val().toString()
			 regionName: $("#regionName").val().length === regionNameLength || $("#regionName").val() == '' ? 'all' : $("#regionName").val().toString(),//newly added
			 routeKey: $("#routeName").val().length === routeNameLength || $("#routeName").val() == '' ? 'all' : $("#routeName").val().toString(),//"all"
			 hubName: $("#hubName").val().toString(),
			 tripCustomerId:  $("#customerName").val().toString()//$("#customerName").val().length === custLength || $("#customerName").val() == '' ? 'all' : $("#customerName").val().toString()
		}), 
	    success: function (product) {			      
		   product = product.responseBody;
		   //console.log("product " + JSON.stringify(product));
		   prodLength = product.length;
		   product.forEach(function (item) {
			    $('#productName').append($("<option></option>").attr("value", "'" + item.product + "'").text(item.product));
		   });
		  $('#productName').multiselect({
			 maxHeight: 200,    
			 buttonWidth: '186px',
			 enableFiltering: true,
			 enableCaseInsensitiveFiltering: true,
			  allSelectedText: 'All',
			  includeSelectAllOption: true,
			  onSelectAll: function () {
		        productAllSelected= true;
              }
		  }).multiselect('selectAll', false)
			.multiselect('updateButtonText');
		   productLength = $("#productName").val().length;
		 //custLength = $("#customerName").val().length;
		 showAnalysis();
	  }
		});	 
 }
	
	   });  
 }
   });
   
}
});   
   
}
});
   
});


$('#regionName').on("change", function(){
	
	if($('#regionName').val() != "") {
	    getRoutes();
	}else {
		$('#routeName').multiselect('deselectAll', false).multiselect('refresh');
		$('#hubName').multiselect('deselectAll', false).multiselect('refresh');
		$('#customerName').multiselect('deselectAll', false).multiselect('refresh');
		$('#productName').multiselect('deselectAll', false).multiselect('refresh');
	}
})

$('#routeName').on("change", function(){
//	if(routeAllSelected)
//	{
//		
//	}
	if($('#routeName').val() != "") {
	  //getCustomers();
	  getHubs();
	}else {
		$('#hubName').multiselect('deselectAll', false).multiselect('refresh');
		$('#customerName').multiselect('deselectAll', false).multiselect('refresh');
		$('#productName').multiselect('deselectAll', false).multiselect('refresh');
	}
})

$('#hubName').on("change", function(){
	
	if($('#hubName').val() != "") {
	    getCustomers();
	}else {
		$('#customerName').multiselect('deselectAll', false).multiselect('refresh');
		$('#productName').multiselect('deselectAll', false).multiselect('refresh');
	}
})

//$('#productName').on("change", function(){
$('#customerName').on("change", function(){	

//	if(productAllSelected)
//	{
//		
//	}
	
	if($('#customerName').val() != "") {
	  //getCustomers();
	  getProducts();
	}else {
		//$('#customerName').multiselect('deselectAll', false).multiselect('refresh');
		$('#productName').multiselect('deselectAll', false).multiselect('refresh');
	}
})


function getRoutes() {

	$('#routeName').multiselect("destroy");	
	$('#routeName').html("");
	
	  $.ajax({
		url: url + '/getDelayRoutes',
		type: "POST",
		contentType: "application/json",
		data: JSON.stringify({
			startDate: formatDate($("#startDate").val()).toString(),
			endDate: formatDate($("#endDate").val()).toString(),
			regionName: $("#regionName").val().length === regionNameLength || $("#regionName").val() == '' ? 'all' : $("#regionName").val().toString()//newly added
		}),  
	    success: function (routes) {	
	    routes = routes.responseBody;
	    //console.log("routes " + JSON.stringify(routes)); 
	    routes.forEach(function (item) {
		   $('#routeName').append($("<option></option>").attr("value", "'" + item.routeKey + "'").text(item.routeKey));
	    }); 
	    $('#routeName').multiselect({
          maxHeight: 200,   
		  buttonWidth: '186px',
		  enableFiltering: true,
		  allSelectedText: 'All',
		  enableCaseInsensitiveFiltering: true,
		  includeSelectAllOption: true,
		  onSelectAll: function () {
		   routeAllSelected= true;
          }
		  }).multiselect('selectAll', false)
		    .multiselect('updateButtonText');
	     getHubs();
	   }
	 });	
}


function getHubs() {
	$('#hubName').multiselect("destroy");	
	$('#hubName').html("");
	$.ajax({
		url: url + '/getDelayHubs',
		type: "POST",
		contentType: "application/json",
		data: JSON.stringify({
			startDate: formatDate($("#startDate").val()).toString(),
			endDate: formatDate($("#endDate").val()).toString(),
			regionName: $("#regionName").val().length === regionNameLength || $("#regionName").val() == '' ? 'all' : $("#regionName").val().toString(),//newly added
			routeKey: $("#routeName").val().length === routeNameLength || $("#routeName").val() == '' ? 'all' : $("#routeName").val().toString()
		}),  
		success: function (hubs) {	      
		  hubs = hubs.responseBody;
		  //console.log("hubs " + JSON.stringify(hubs)); 
		  hubNameLength = hubs.length;
		  hubs.forEach(function (item) {
			$('#hubName').append($("<option></option>").attr("value", "'" + item.hubId + "'").text(item.hubName));
		  });
	      $('#hubName').multiselect({
	      maxHeight: 200,  
	      buttonWidth: '186px',
	      enableFiltering: true,
	      allSelectedText: 'All',
	      enableCaseInsensitiveFiltering: true,
	      includeSelectAllOption: true,
	      onSelectAll: function () {
	    	  hubAllSelected= true;
	      }
	      }).multiselect('selectAll', false)
	      .multiselect('updateButtonText'); 
	      getCustomers();
	   }
	});
}

function getCustomers(){
	$('#customerName').multiselect("destroy");	
	$('#customerName').html("");
	$.ajax({
      url: url + '/getDelayCustomer',
      type: "POST",
      contentType: "application/json",
      data: JSON.stringify({
    	  startDate: formatDate($("#startDate").val()).toString(),
		  endDate: formatDate($("#endDate").val()).toString(),
		  regionName: $("#regionName").val().length === regionNameLength || $("#regionName").val() == '' ? 'all' : $("#regionName").val().toString(),//newly added
		  routeKey: $("#routeName").val().length === routeNameLength || $("#routeName").val() == '' ? 'all' : $("#routeName").val().toString(),//$("#routeName").val().toString(),
		  hubName:  $("#hubName").val().toString()
      }),
	  success: function (customers) {
		customers = customers.responseBody;
		//console.log("customers " + JSON.stringify(customers)); 
		custLength = customers.length;
		customers.forEach(function (item) {
			$('#customerName').append($("<option></option>").attr("value", "'" + item.tripCustomerId + "'").text(item.customer));
		 });
		 $('#customerName').multiselect({
		 maxHeight: 200,  	 	 
		 buttonWidth: '186px',
		 enableFiltering: true,
		 allSelectedText: 'All',
		 enableCaseInsensitiveFiltering: true,
		 includeSelectAllOption: true,
		 onSelectAll: function () {
			 //customerAllSelected= true;
		 }
		 }).multiselect('selectAll', false)
		 .multiselect('updateButtonText');
		 //custLength = $("#customerName").val().length;
		 custNewLength = $("#customerName").val().length;
		 getProducts();
	  }
	});	 
}


function getProducts() {

	$('#productName').multiselect("destroy");	
	$('#productName').html("");
	
	  $.ajax({
	      url: url + '/getDelayProduct',
	      type: "POST",
	      contentType: "application/json",
	      data: JSON.stringify({
	         startDate: formatDate($("#startDate").val()).toString(),
			 endDate: formatDate($("#endDate").val()).toString(),
			 //routeKey: $("#routeName").val().toString()
			 regionName: $("#regionName").val().length === regionNameLength || $("#regionName").val() == '' ? 'all' : $("#regionName").val().toString(),//newly added
			 routeKey: $("#routeName").val().length === routeNameLength || $("#routeName").val() == '' ? 'all' : $("#routeName").val().toString(),//"all"
			 hubName: $("#hubName").val().toString(),
			 tripCustomerId:  $("#customerName").val().toString()//$("#customerName").val().length === custLength || $("#customerName").val() == '' ? 'all' : $("#customerName").val().toString()
	      }),   
	      success: function (product) {
		   product = product.responseBody;
		   //console.log("product " + JSON.stringify(product));
		   product.forEach(function (item) {
				$('#productName').append($("<option></option>").attr("value", "'" + item.product + "'").text(item.product));
		   });
		   $('#productName').multiselect({
			 maxHeight: 200,  	   
			 buttonWidth: '186px',
			 enableFiltering: true,
			 enableCaseInsensitiveFiltering: true,
			  allSelectedText: 'All',
			  includeSelectAllOption: true
		  }).multiselect('selectAll', false)
			.multiselect('updateButtonText');
			 productLength = $("#productName").val().length;
			//getCustomers();
	   }
	 });	
}

$(document).on('input',"#custNameCol .multiselect-search",function (e) {
       if($('#customerName').val().length == custLength){
        $('#customerName').multiselect('deselectAll', false).multiselect('refresh');}   
      
})

$(document).on('input',"#routeNameCol .multiselect-search",function (e) {
       if($('#routeName').val().length == routeLength){
        $('#routeName').multiselect('deselectAll', false).multiselect('refresh');}   
      
})

$(document).on('input',"#productNameCol .multiselect-search",function (e) {
       if($('#productName').val().length == routeLength){
        $('#productName').multiselect('deselectAll', false).multiselect('refresh');}   
      
})

$(document).on('input',"#dayNameCol .multiselect-search",function (e) {
       if($('#dayName').val().length == dayLength){
        $('#dayName').multiselect('deselectAll', false).multiselect('refresh');}   
})

$(document).on('input',"#hubNameCol .multiselect-search",function (e) {
       if($('#hubName').val().length == hubNameLength){
        $('#hubName').multiselect('deselectAll', false).multiselect('refresh');}   
})
