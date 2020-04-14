<%@ page language="java"
	import="java.util.*,t4u.functions.CommonFunctions,t4u.beans.*,t4u.common.*"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://packtag.sf.net" prefix="pack"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
	
	CommonFunctions cf = new CommonFunctions();
	LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
	if(loginInfo != null){}else{response.sendRedirect(request.getContextPath()+ "/Jsps/Common/SessionDestroy.html");}
	String routeId="0";
	String tripCustId= "0";
	boolean tripPageCheck = false;
	boolean tripPageCheckMod = false;
	if(request.getParameter("routeId")!=null){
	   routeId = request.getParameter("routeId");
	}
	if(request.getParameter("tripCustId")!=null){
       tripCustId = request.getParameter("tripCustId");
    }
	if(request.getParameter("createRouteFromTrip")!=null && request.getParameter("createRouteFromTrip").equals("createRouteFromTrip")){
       tripPageCheck = true;
    }
    if(request.getParameter("createRouteFromTrip")!=null && request.getParameter("createRouteFromTrip").equals("modify")){
       tripPageCheckMod = true;
    }
 	Properties properties = ApplicationListener.prop;
 	String GoogleApiKey = properties.getProperty("GoogleMapApiKeyen").trim();
    
%>
<!--<!doctype html>-->
	<!--<html lang="en">-->
	<!--   <head>-->
	<!--      <title> Route Master</title>-->
	<!--      <meta charset="utf-8">-->
	<!--      <meta name="viewport" content="width=device-width, initial-scale=1">-->
	 <jsp:include page="../Common/header.jsp" />
	      <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
      <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-multiselect/0.9.13/css/bootstrap-multiselect.css">
      <link rel="stylesheet" href="../../Main/sweetAlert/sweetalert.css">
      <link href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" rel="stylesheet">
      <link href="https://cdn.datatables.net/1.10.16/css/dataTables.bootstrap.min.css" rel="stylesheet">
      <link href="https://cdn.datatables.net/fixedcolumns/3.2.3/css/fixedColumns.dataTables.min.css" rel="stylesheet">
      <link href="https://cdn.datatables.net/select/1.2.3/css/select.dataTables.min.css" rel="stylesheet"/>
      <link href="https://cdn.datatables.net/buttons/1.5.0/css/buttons.bootstrap.min.css" rel="stylesheet"/>
      <link rel="stylesheet" href="https://www.jqwidgets.com/public/jqwidgets/styles/jqx.base.css">
      <link rel="stylesheet" href="https://www.jqwidgets.com/public/jqwidgets/styles/jqx.energyblue.css">
      <link rel="stylesheet" href="https://www.jqwidgets.com/public/jqwidgets/styles/jqx.arctic.css">
      
      <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
      <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
      <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-multiselect/0.9.13/js/bootstrap-multiselect.min.js"></script>
      <script src="../../Main/sweetAlert/sweetalert.min.js"></script>
      <script src="https://cdn.datatables.net/1.10.16/js/jquery.dataTables.min.js"></script>
      <script src="https://cdn.datatables.net/1.10.16/js/dataTables.bootstrap4.min.js"></script>
      <script src="https://cdn.datatables.net/buttons/1.4.2/js/dataTables.buttons.min.js"></script>
      <script src="https://cdnjs.cloudflare.com/ajax/libs/jszip/3.1.3/jszip.min.js"></script>
      <script src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.32/pdfmake.min.js"></script>
      <script src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.32/vfs_fonts.js"></script>
      <script src="https://cdn.datatables.net/buttons/1.4.2/js/buttons.html5.min.js"></script>
      <script src = "https://cdn.datatables.net/select/1.2.3/js/dataTables.select.min.js"></script>
      <script src="https://cdn.datatables.net/fixedcolumns/3.2.3/js/dataTables.fixedColumns.min.js"></script>
      
      <script type="text/javascript" src="https://cdn.datatables.net/buttons/1.4.2/js/buttons.bootstrap.min.js"></script>
      <script type="text/javascript" src="//cdn.datatables.net/buttons/1.4.2/js/buttons.colVis.min.js"></script>
      <script src="https://cdn.datatables.net/buttons/1.4.2/js/buttons.flash.min.js"></script>
      <script src="https://www.jqwidgets.com/public/jqwidgets/jqx-all.js"></script>
       <link href="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.6-rc.0/css/select2.min.css" rel="stylesheet" />
	  <script src="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.6-rc.0/js/select2.min.js"></script>
      
      <pack:script src="../../Main/adapter/ext/ext-base.js"></pack:script>
	  <pack:script src="../../Main/Js/ext-all-debug.js"></pack:script>
	  <pack:script src="../../Main/Js/Common.js"></pack:script>
      <pack:script src="../../Main/Js/MsgBox.js"></pack:script>
      <pack:script src="../../Main/Js/examples1.js"></pack:script>

      <style>
         .custom{
         padding-left: 15px;
         padding-right: 15px;
         margin-left: auto;
         margin-right: auto;
         padding-top: 3px;
         }
         .align{
         text-align:center
         }
         .panel {
         margin-bottom: 17px;
         background-color: #fff;
         border: 1px dotted #333 !important;
         border-radius: 4px;
         -webkit-box-shadow: 0 1px 1px rgba(0,0,0,.05);
         box-shadow: 0 1px 1px rgba(0,0,0,.05);
         }
         .percentageWell {
         float: right;
         background-color: green;
         color: #fff;
         padding: 9px;
         border-radius: 4px;
         /* border: 1px solid #333; */
         border-bottom: 1px solid #333;
         border-left: 1px solid #333;
         text-align: center;
         width: 55px;
         }
         #description{
         padding-right:13%;
         }
         #panelBox{
         height: 77px;
    	 margin-top: 10px;
         }
         #panelBox1 {
         height: 45px;
         }
         #panelBox2 {
         height: 164px;
         margin-top: 14px;
         }
         #example_wrapper {
         margin-top: -1%;
         border: solid 1px rgba(0, 0, 0, .25);
         padding: 1%;
         box-shadow: 0 1px 1px rgba(0, 0, 0, .25);
         width: 104%;
    	 margin-left: -19px;
         }
         #mainTable_wrapper {
         margin-top: 1%;
         border: solid 1px rgba(0, 0, 0, .25);
         padding: 1%;
         box-shadow: 0 1px 1px rgba(0, 0, 0, .25);
         width: 98.7%;
         }
         #summaryTable_wrapper {
         margin-top: 1%;
         border: solid 1px rgba(0, 0, 0, .25);
         padding: 1%;
         box-shadow: 0 1px 1px rgba(0, 0, 0, .25);
         width: 98.7%;
         }
         #example_filter{
         display:none;
         }
         #example_length{
         display:none;
         }
         .dataTables_scroll
         {
         	overflow:auto;
         }
         #example_paginate{
         display:none;
         }
         #example_info{
         display:none;
         }
         .nav-tabs>li.active>a, .nav-tabs>li.active>a:focus, .nav-tabs>li.active>a:hover {
         color: black;
         cursor: default;
         font-weight: 700;
         }
         .nav-tabs>li>a {
         font-weight: 700;
         }
         .col-md-5 {
		    width: 20.666667%;
		}
		.label {
		    display: inline;
		    padding: .2em .6em .3em;
		    font-size: 99%;
		    font-weight: 700;
		    line-height: 3;
		    color: #fff;
		    text-align: center;
		    white-space: nowrap;
		    vertical-align: baseline;
		    border-radius: .25em;
		}
		.head{
			height: 28px;
		}
		
		.headTitle{
			font-size: 13px;
			text-align: center;
			font-weight: bold;
		}
		.btn-success {
		    color: #fff;
		    background-color: #5cb85c;
		    border-color: #4cae4c;
		    margin-left: 10px;
		    height: 28px;
		    line-height: 0.428571;
		}
		#mainTable_filter{
		    margin-top: -38px;
		}
		<!--	#summaryTable_filter{  -->
		<!--		margin-top: -35px;  -->
		<!--	} -->
		.dataTables_filter {
			text-align: right;
			margin-right: 19%;
			margin-top: -3%;
			margin-bottom: 1%;
			}
		.form-control {
		    display: block;
		    width: 90%;
		    height: 28px;
		    padding: 6px 12px;
		    font-size: 14px;
		    line-height: 1.42857143;
		    color: #555;
		    background-color: #fff;
		    background-image: none;
		    border: 1px solid #aaa;
		    border-radius: 4px;
		    -webkit-box-shadow: inset 0 1px 1px rgba(0,0,0,.075);
		    box-shadow: inset 0 1px 1px rgba(0,0,0,.075);
		    -webkit-transition: border-color ease-in-out .15s,-webkit-box-shadow ease-in-out .15s;
		    -o-transition: border-color ease-in-out .15s,box-shadow ease-in-out .15s;
		    transition: border-color ease-in-out .15s,box-shadow ease-in-out .15s;
		}
		.container .checkmark:after {
		    left: 9px;
		    top: 5px;
		    width: 5px;
		    height: 10px;
		    border: solid white;
		    border-width: 0 3px 3px 0;
		    -webkit-transform: rotate(45deg);
		    -ms-transform: rotate(45deg);
		    transform: rotate(45deg);
		}
		.container {
		    display: block;
		    position: relative;
		    padding-left: 35px;
		    margin-bottom: 12px;
		    cursor: pointer;
		    font-size: 15px;
		    -webkit-user-select: none;
		    -moz-user-select: none;
		    -ms-user-select: none;
		    user-select: none;
		}
		
		/* Hide the browser's default checkbox */
		.container input {
		    position: absolute;
		   // opacity: 0;
		    cursor: pointer;
			
		}
		.checkmark {
		    position: absolute;
		    top: 0;
		    left: 0;
		    height: 25px;
		    width: 25px;
		    background-color: #eee;
		    border: 1px solid black;
		}
		.container:hover input ~ .checkmark {
		    background-color: #ccc;
		}
		.container input:checked ~ .checkmark {
		    background-color: #2196F3;
		}
		.checkmark:after {
		    content: "";
		    position: absolute;
		    display: none;
		}
		.container input:checked ~ .checkmark:after {
		    display: block;
		}
		.select2-container{
			width: 200px !important;
		}
		.sweet-alert button.cancel {
          background-color: #d9534f !important;
        }
        .sweet-alert button {
          background-color: #5cb85c !important;
        }
		#checkPoint{
			display: none;
			}

			#smartHub{
			display: none;
			}
	td.details-control {
	   background: url('../../Main/images/details_open.png') no-repeat center center;
	   cursor: pointer;
	   width:50px;
	}
	tr.shown td.details-control {
	   background: url('../../Main/images/details_close.png') no-repeat center center;
	   width:50px;
	}
	.container input {
		position:relative !important;
				width:100px;
	}
      </style>
 <!--      </head>-->
	<!--<body onload="getCustomerName();">-->
      <div class="custom">
         <div class="col-md-12">
            <div class="panel panel-primary">
               <div class="panel-heading">
                  <h3 class="panel-title" >
                     Route Template Creation
                  </h3>
               </div>
               <div class="panel-body" style="padding-top: 0px;">
               	<div class="col-lg-12 row" style="margin-top: 10px;">    
						<label for="staticEmail2" class="col-lg-1 col-md-1 col-sm-12" style="margin-left: 10px;">Customer:</label>
					    <div class="col-lg-3 ">
							<select id="cust_names" class="form-control js-example-basic-single select2" onchange="loadRouteAndMaterialData()">
							 </select>
					     </div>
							   <div class="col-xs-12 col-md-1 col-sm-12">
								   <div>
		                              <button id="viewBtn" type="button" class="btn btn-primary" onclick="loadAllTemplates()">View</button>
		                           </div>
		                       </div>
		                       <div class="col-xs-12 col-md-1 col-sm-12">
								   <div>
		                              <button id="addId" type="button" class="btn btn-primary" onclick="addRouteTemplate()">Add</button>
		                           </div>
		                       </div>
		                        <div>
		                        	<h5 id="dialogBoxId" style="color:red;"></h5>
		                        </div>
					</div>
					
					
                     <div class="tabs-container">
                        <ul class="nav nav-tabs" style="display: table-cell;">
                           <li><a href="#summaryId" data-toggle="tab"  onclick="$('#summaryId').addClass('show');" active>Route Template Details</a></li>
                     	<!-- <li class="disabled"><a href="#mapViewId">Route Creation</a></li> -->   
                     	   <li><a href="#mapViewId" data-toggle="tab1" onclick="changeTab1('mapViewId')">Route Template Creation</a></li>
                        </ul>
                     </div>
                     <div class="tab-content" id="tabs">
                        <div class="tab-pane" id="summaryId">
                           <table id="templateTable" class="table table-striped table-bordered" cellspacing="0" width="100%" style="margin-top:1%">
                              <thead>
                                 <tr>
                                    <th>Sl No</th>
				    				<th>Template ID</th>
                                    <th>Template Name</th>
								    <th>Route Id</th>
                                    <th>Route Name</th>
                                    <th>Materials</th>
                                    <th>View</th>
                                    <th>Modify</th>
                                 </tr>
                              </thead>
                           </table>
                        </div>
                        <div class="tab-pane" id="mapViewId">
                 		<div class="col-md-4 ">
                            <form class="form" role="form" autocomplete="off" style="margin-top: 13px;">
                                <div class="form-group row">
                                    <label class="col-lg-4 col-md-4 col-form-label form-control-label">Template Name</label>
                                    <div class="col-lg-8 col-md-8">
                                        <input class="form-control" type="text" style="width:200px" value="" id="templateName" >
                                    </div>
                                </div>
                                <div class="form-group row">
                                    <label class="col-lg-4 col-md-4 col-form-label form-control-label">Route</label>
                                    <div class="col-lg-8 col-md-8">
                                       	<select id="routeId" class="form-control js-example-basic-single select2">
										</select>
                                    </div>
                                </div>
                                <div class="form-group row">
                                    <label class="col-lg-4 col-md-4 col-form-label form-control-label">Material</label>
                                    <div class="col-lg-8 col-md-8">
                                       	<select id="materialId" class="form-control" style="width:200px"> <option value="0">Select Material</option>
										</select>
                                    </div>
                                </div>
				<div class="form-group row">
                                 <label class="col-lg-12 col-md-12 col-form-label form-control-label">
				    					Note: Please click on the map to enter TAT, RunTime and Detention
				    			</label>
                                </div>
                                <div class="form-group row">
                                    <label class="col-lg-4 col-md-4 col-form-label form-control-label"></label>
                                    <div class="col-lg-8 col-md-8">
		                                 <input style="height: 35px;margin-left: 0%;" id="saveBtn" type="button" class="btn btn-success" value="Save All" onclick="createTemplate()">
						 <input style="margin-top: 1px;"type="button" class="btn btn-primary" value="Go Back" onclick="goBack();">
                                    </div>
                                </div>
                            </form>
                    </div>
		     <div class="col-md-8">
	                     <table id="templateSummaryTable" class="table table-striped table-bordered display" cellspacing="0" width="100%" style="margin-top:3%">
	                     	<thead>
	                           <tr>
				      <th ></th>
				      <th>Material Id</th>
	                              <th>Material Name</th>
				      <th>Route Name</th>
				      <th>Leg TAT Details</th>
				      <th>Total TAT</th>
				      <th>Total RunTime</th>
				      <th>Total Detention</th>
				      <th>Action</th>
	                           </tr>
	                        </thead>
			     </table>  
                     </div>
                	<div class="col-md-12">
                      	    <div id="dvMap" style="width: 100%; height: 417px; border: 1px solid gray;"></div>
                        </div>
		     </div>
                   </div>
                </div>
             </div>
          </div>
       </div>
       
    <script src='<%=GoogleApiKey%>'></script>
   	<script>
	window.onload = function () { 
			getCustomerName();
		}
    var custId;
    var summaryTable;
    var customerName ;
	var sourceId;
	var destinationId;
	var sLat;
	var sLon;
	var dLat;
	var dLon;
	var circleArray=[];
	var polygonCoords=[];
	var directionsDisplay;
	var jsonArray = [];
	var dragPointArray = [];
	var myLatLngS;
	var myLatLngD;
	var buffermarkers=[];
	var circles=[];
	var polygonmarkers=[];
	var sHub;
	var dHub;
	var legUniqId;
	var polygons=[];
	var buffermarkersmart = [];
    var circlessmart = [];
    var polygonsmart = [];
    var polygonmarkersmart = [];
    var buffermarkerscheck = [];
    var circlescheck = [];
    var polygonscheck = [];
    var polygonmarkerscheck = [];
    var polylatlongs=[];
    var plotClick;
    var directionDisplayArr=[];
    var legArray= [];
    var routeIdPdf=0;
	sessionStorage.clear();
	var detentionDataJsonArray;
	var currRouteId;
	var tatMarkersArray = [];
	var tatInfowindowsArray = [];
	var completeRoutePath;
	var legTAT = 0;
	var legIdsArray = [];
    var materialListStore;
	dataTableArray = [];
	
	

	
	
    function getPDFMap(){
        window.open("<%=request.getContextPath()%>/RouteMapPDF?&routeId="+routeIdPdf+"&routeName="+document.getElementById("routeNameId").value);
    }
    function changeTab(tab) {
    if (document.getElementById("cust_names").value == "") {
        sweetAlert("Please select customer");
        return;
    }else{
    	$('.nav-tabs a[href="#' + tab + '"]').tab('show');
	 	 clearAllTemplateData();
    	 $('#viewBtn').hide();
    	 $('#addId').hide();
    	 $('#backButtonId1').hide();
    	 $('#summaryId').removeClass("show");  
    }
    };
     function changeTab1(tab1) {
        if (document.getElementById("cust_names").value == "") {
            sweetAlert("Please select customer!!");
            return;
        } else {
            $('.nav-tabs a[href="#' + tab1 + '"]').tab('show');
            clearAllData();
            $('#addId').hide();
            $('#viewBtn').hide();
            $('#summaryId').hide();
            $('#summaryId').removeClass("show");            
        }
    };
    $('a[data-toggle="tab"]').on('shown.bs.tab', function (e) {
	  var target = $(e.target).attr("href") // activated tab
	  if(target=='#summaryId'){
	  	$('#viewBtn').show();
	  	$('#addId').show();
        $('#clearId').show();
	  }
	});
    function checkSpcialChar(event){
	    var regex = new RegExp("[0-9a-zA-Z ._^%$#&*'(){|}<=>:;?!~@,-]+");
		var key = String.fromCharCode(!event.charCode ? event.which: event.charCode);
		if (!regex.test(key)) 
		{
		    event.preventDefault();
		    return false;
		} 
	}	
    function activeTab(tab) {
        $('.nav-tabs a[href="#' + tab + '"]').tab('show');
    };
    activeTab('summaryId');
    function loadData(){
    if (document.getElementById("cust_names").value == "") {
        sweetAlert("Please select customer");
        return;
    }else{
    	summaryTable = $('#summaryTable').DataTable({
            "ajax": {
                "url": "<%=request.getContextPath()%>/LegCreationAction.do?param=getRouteMasterDetails",
                "dataSrc": "routeDataRoot",
                "data": {
                    tripCustId: document.getElementById("cust_names").value
                }
            },
            "oLanguage": {
                "sEmptyTable": "No data available"
            },
            "bDestroy": true,
            "responsive": true,
	        	"dom": 'Bfrtip',
        	 	"buttons": [{extend:'pageLength'},
        	 				{extend:'excel',
        	 				text: 'Export to Excel',
                            className: 'btn btn-primary',
        	 				exportOptions: {
				                columns: [0,1,2,3,4,5,6]
				            }}
        	 				],
            columnDefs: [
            		{ width: 30, targets: 0 },
		            { width: 200, targets: 1 },
		            { width: 100, targets: 2 },
		            { width: 50, targets: 3 },
		            { width: 50, targets: 4 },
		            { width: 50, targets: 5 },
		            { width: 50, targets: 6 },
		            { width: 50, targets: 7 }
		        ],
            "columns": [{
                "data": "slNoIndex"
            }, {
                "data": "routeNameIndex"
            }, {
                "data": "routeKeyIndex"
            }, {
                "data": "distanceIndex"
            }, {
                "data": "TATIndex"
            }, {
                "data": "radiusIndex"
            }, {
                "data": "statusIndex"
            }, {
                "data": "action"
            }, {
                "data": "action1"
            }]
        });
        }
    }

  function initialize() {
       var mumbai = new google.maps.LatLng(22.89, 78.88);
       var mapOptions = {
           zoom: 7,
           center: mumbai
       };
       map = new google.maps.Map(document.getElementById('dvMap'), mapOptions);
   }
   google.maps.event.addDomListener(window, 'load', initialize);
  	function getCustomerName() {
        $.ajax({
           url: '<%=request.getContextPath()%>/IndentMasterDetails.do?param=getCustomer',
            success: function(response) {
                custList = JSON.parse(response);
                var output = '';
                for (var i = 0; i < custList["customerRoot"].length; i++) {
                    $('#cust_names').append($("<option></option>").attr("value", custList["customerRoot"][i].CustId).text(custList["customerRoot"][i].CustName));
                }
               	$("#cust_names").select2();
		loadRouteAndMaterialData();
		loadAllTemplates();
            }
        });
    }
     var leghubId=0;

     var counter=0;
     var totalTAT=0;
     var dist=0;

	 

$('#routeId').change(function() {
		clearAllData();
        routeId = $('#routeId option:selected').attr('value');
        legIdsArray = [];
		detentionDataJsonArray = [];
    	loadTemplateSummaryData(detentionDataJsonArray,false);
        if(routeId > 0){
       		getlegIds(routeId,true);
		}
}); 
	  
	 $('#materialId').change(function() {
        routeId = $('#routeId option:selected').attr('value');
        if(routeId > 0){
       		plotMywindows(completeRoutePath);
        }
        
    });
	
	
	 $('#cust_names').change(function() {
		clearAllData();
        loadAllTemplates();
        
    });
	  
      $("body").on("click", ".remove", function(e) {
        $(this).parents(".control-group").remove();
        removeId = $(this).attr("id");
        counter--;
        sessionStorage.removeItem(removeId);
      
       for (var i = 0; i < tatMarkersArray.length; i++) {
		   tatMarkersArray[i].setMap(null);
		}
      
        $('#checkAddBtn').show();
        if(removeId>1){
        	$('#'+(removeId-1)).show();
        }
        legArray.pop();
        if (directionsDisplay != null) {
            directionsDisplay.setMap(null);
        }
        totalTAT=0;
      	dist=0;
      	for (var j = 0; j < sessionStorage.length; j++) {
      	 	detention=$('#leg' + (j+1) + ' option:selected').attr("detention");
	      	if(j==0){
	      		detention=0;
	      	}
            totalTAT=totalTAT + Number($('#leg' + (j+1) + ' option:selected').attr("TAT"))+Number(detention);
  	    	dist = dist+Number($('#leg' + (j+1) + ' option:selected').attr("distance"));
        }
  		document.getElementById("TATId").value = convertMinutesToDDHHMM(Number(totalTAT *60000));
  		document.getElementById("distanceId").value = dist;
      //  getRouteLatlongs(legIds,currRouteId);
		legIds="";
		polylatlongs=[];
		myLatLngD="";
		myLatLngS="";
    });

	 function getRouteLatlongs(legIds,currRouteId,chkptIcon){
	 legIds="";
		 google.maps.event.trigger(map, 'resize');
	 		//detentionDataJsonArray = [];
		 	for (var j = 0; j < sessionStorage.length; j++) {
	            legID = sessionStorage.getItem(j + 1);
	            legIds+=legID+',';
	        }
			
			$.ajax({
				url: '<%=request.getContextPath()%>/LegCreationAction.do?param=getLatLongsForCompleteRoute',
				data:{
					legIds: legIds,
					routeId : currRouteId
				},
			    success: function(result){
			    	results = JSON.parse(result);
			    	completeRoutePath = results;
					 
					for (var i = 0; i < results["routelatlongRoot"].length; i++) {
						if((results["routelatlongRoot"][i].type=='SOURCE')){
							myLatLngS= new google.maps.LatLng(results["routelatlongRoot"][i].lat, results["routelatlongRoot"][i].lon);
						}
						if(results["routelatlongRoot"][i].type=='DESTINATION'){
							myLatLngD= new google.maps.LatLng(results["routelatlongRoot"][i].lat, results["routelatlongRoot"][i].lon);
						}
						if(results["routelatlongRoot"][i].type=='CHECKPOINT'){
							 polylatlongs.push({
					               location: new google.maps.LatLng(results["routelatlongRoot"][i].lat, results["routelatlongRoot"][i].lon),
					               stopover: true
					          });
						}
						if(results["routelatlongRoot"][i].type=='DRAGPOINT'){
						 polylatlongs.push({
					               location: new google.maps.LatLng(results["routelatlongRoot"][i].lat, results["routelatlongRoot"][i].lon),
					               stopover: false
					          });
						}
					}
					plotRoute();
					if (chkptIcon){
					plotInfowindows(completeRoutePath);
					}
					
					
				}
			});
		}
	var legIds="";
    function plotRoute() {
    	for (var i = 0; i < directionDisplayArr.length; i++) {
			directionDisplayArr[i].setMap(null);
		}
        var directionsService = new google.maps.DirectionsService;
        directionsDisplay = new google.maps.DirectionsRenderer({
            map: map,
            polylineOptions: { strokeColor: "black" }
        });
        directionsService.route({
            origin: myLatLngS,
            destination: myLatLngD,
            waypoints: polylatlongs,
            travelMode: google.maps.TravelMode.DRIVING
            
        }, function(response, status) {
            if (status === google.maps.DirectionsStatus.OK) {
                directionsDisplay.setDirections(response);
                directionDisplayArr.push(directionsDisplay);
            } else {
                console.log("Invalid Request "+status);
            }
        });
        
       
    }

    function clearAllTemplateData(){
    	document.getElementById("templateName").value = '';
	$("#routeId").val('').trigger('change');
	$("#materialId").val('').trigger('change');
	detentionDataJsonArray=[];
	loadTemplateSummaryData(detentionDataJsonArray,true);
    }
    function clearAllData(){
    	polylatlongs=[];
    	legPointArray=[];
        counter=0;
        sessionStorage.clear();
      //  document.getElementById("distanceId").value = "";
       // document.getElementById("TATId").value = "";
        for (var i = 0; i < circleArray.length; i++) {
           circleArray[i].setMap(null);
        }
        for (var i = 0; i < polygonCoords.length; i++) {
		   polygonCoords[i].setMap(null);
		}
		for (var i = 0; i < directionDisplayArr.length; i++) {
		   directionDisplayArr[i].setMap(null);
		}
		for (var i = 0,arr=tatMarkersArray.length; i < arr; i++) {
		   tatMarkersArray[i].setMap(null);
		}
		$(".control-group").remove();
		legIds="";
		leghubId=0;
		totalTAT=0;
		myLatLngD="";
		myLatLngS="";
		document.getElementById("dialogBoxId").innerHTML = "";
		legArray=[];
		//document.getElementById("routeNameId").value = "";
        //document.getElementById("routeKeyId").value = "";
        //document.getElementById("routeRadiusId").value = "";
        routeUniqId=0;
        $('#backButtonId1').hide();
        tripCountC=0;
        detentionDataJsonArray = [];
		currRouteId = "";
	   
    }
    function resetAllData(){
    	swal({
			  title: "Are you sure you want to clear all the data?",
			  type: "warning",
			  showCancelButton: true,
			  confirmButtonClass: "btn-danger",
			  confirmButtonText: "Yes, clear it!",
			  cancelButtonText: "No, cancel!",
			  closeOnConfirm: false,
			  closeOnCancel: true
			},
			function(isConfirm) {
			  if (isConfirm) {
			  	clearAllData();
			    swal("Cleared!");
			  } else {
			  }
			});
    }
    var routeUniqId;
    var statusA ="";
    var buttonValue="";
    function addRouteTemplate(){
     $('#routeId').prop('disabled', false);
	 $('#templateName').prop('disabled', false);
	 $('#materialId').prop('disabled', false);
	 $('#saveBtn').prop('disabled', false);
	 routeTemplateMode = "add";  
	 changeTab('mapViewId');
    }
    function viewRouteTemplate(routeTemplateId,templateName,routeId) {
        $("#routeId").val(routeId);//.trigger('change');
    	var params = {
			id :routeTemplateId
		}
    	 $.ajax({
             url: '<%=request.getContextPath()%>/LegCreationAction.do?param=getRouteTemplateDetailsById',
             data: params,
             success: function(response) {
			     templateDetails = JSON.parse(response);
	             loadTemplateSummaryData(templateDetails["templateDetails"],true);
             }
         });
        changeTab('mapViewId');
        $('#viewBtn').hide();
        $('#addId').hide();
		$('#templateName').val(templateName);
	 	$("#routeId").val(routeId);//.trigger('change');
	    $('#routeId').prop('disabled', true);
	    $('#templateName').prop('disabled', true);
		$('#materialId').prop('disabled', true);
		$('#saveBtn').prop('disabled', true);
		 
		 getlegIds(routeId,false);
    }
    function modifyRouteTemplate(routeTemplateId,templateName,routeId) {
        $("#routeId").val(routeId).trigger('change');
        var templateDetails = "";
        detentionDataJsonArray = [];
    	var params = {
			id :routeTemplateId
		}
    	 $.ajax({
             url: '<%=request.getContextPath()%>/LegCreationAction.do?param=getRouteTemplateDetailsById',
             data: params,
             success: function(response) {
			     templateDetails = JSON.parse(response);
	             loadTemplateSummaryData(templateDetails["templateDetails"],false);
	             console.log(templateDetails["templateDetails"]);
	             
	              for(var i=0;i< templateDetails["templateDetails"].length;i++){
	              		var obj= templateDetails["templateDetails"][i];
	              		console.log(obj);
					    var legTATdetails = obj.legTATdetails;
					    console.log(obj.legTATdetails);
					     for (var j=0; j<legTATdetails.length; j++){
					     var obj1 = legTATdetails[j];
							detentionDataJsonArray.push({"materialId" : obj.materialID , "materialName" : obj.materialName , "legId" : obj1.legId , "legName" : obj1.legName , "TAT" : obj1.TAT , "runtime" : obj1.runtime, "detention" : obj1.detention, "saved" : 'Y',"deleted":"N"});	     
					     }
				 }
					     console.log("1221 detentionDataJsonArray length  :: "+JSON.stringify(detentionDataJsonArray));
             	}
         });
   
        changeTab('mapViewId');
        $('#viewBtn').hide();
        $('#addId').hide();
		$('#templateName').val(templateName);
	 	$("#routeId").val(routeId).trigger('change');
	    $('#routeId').prop('disabled', true);
	    $('#templateName').prop('disabled', true);
	    $('#materialId').prop('disabled', false);
	    $('#saveBtn').prop('disabled', false);
	    //getlegIds(routeId,true);
	    routeTemplateMode = "modify";
    }
    function goBack(){
            changeTab('summaryId');
	    clearAllData();
	    $('#viewBtn').show();
	    $('#addId').show();
	    $('#summaryId').show();
	    loadAllTemplates();
    }
    function getlegIds(routeId,chkptIcon){
    	 LegList="";
    	 var j=0;
    	 $.ajax({
           url: '<%=request.getContextPath()%>/LegCreationAction.do?param=getLegList',
           data:{
           	 routeId: routeId
           },
            success: function(response) {
                legList = JSON.parse(response);
                legIdsArray= [];
                for (var i = 0; i < legList["legListRoot"].length; i++) {
                    j++;
                    sessionStorage.setItem(j, legList["legListRoot"][i].legId);
					legIdsArray.push(legList["legListRoot"][i].legId);
                }
                getRouteLatlongs("",routeId,chkptIcon);
                counter = j;
            }
     	  });
    }
 
     function saveInfoWindowDetails() {
     console.log("clicked");
		 
		 var matrId  = $('#materialId option:selected').attr('value');
		
		 if (matrId > 0){   
	              var  legId1= document.getElementById("legIdOfWindow").value;
	              var legName1 = document.getElementById("legNameOfWindow").value;
	              var materialId1 = $('#materialId option:selected').attr('value');//document.getElementById("materialIdWindow").value;
				  var tatWindow = document.getElementById("tat").value;
				  var detentionWindow = document.getElementById("detentionOfWindow").value;
				  var runTimeWindow = document.getElementById("runTime").value;
	              var datePattern = /^\d{2}:([0-1]\d|2[0-3]):[0-5]\d$/  // /^([01]\d|2[0-3]):?([0-5]\d)$/;
		          if(!datePattern.test(document.getElementById("tat").value)){
		           	   sweetAlert("Enter TAT time in DD:HH:mm format");
		               return;
		           }
				  if(!datePattern.test(document.getElementById("runTime").value)){
		           	   sweetAlert("Enter Run Time in DD:HH:mm format");
		               return;
		          }
			     if(!datePattern.test(document.getElementById("detentionOfWindow").value)){
	           	   sweetAlert("Enter Detention in DD:HH:mm format");
	               return;
	             }
				 if (detentionDataJsonArray.length > 0){
					 var count = 0; 
						for(var i = 0; i < detentionDataJsonArray.length; i++) {
							var chkpt = detentionDataJsonArray[i];
		                   		if((chkpt.materialId == materialId1)  && (chkpt.legId == legId1) ){
		                   		  count = count + 1;
		                   		}
						}
						 if (count == 0){
					          detentionDataJsonArray.push({"materialId" : matrId , "materialName" : $('#materialId option:selected').attr('name'), "legId" : legId1 , "legName" : legName1 , "TAT" : tatWindow , "runtime" : runTimeWindow, "detention" : detentionWindow, "saved" : 'Y',"deleted":"N"});
					     }
			    }else{
			          detentionDataJsonArray.push({"materialId" : matrId , "materialName" : $('#materialId option:selected').attr('name'), "legId" : legId1 , "legName" : legName1 , "TAT" : tatWindow , "runtime" : runTimeWindow, "detention" : detentionWindow, "saved" : 'Y',"deleted":"N"});
			    }
							
					for(var i = 0; i < detentionDataJsonArray.length; i++) {
						var detchkpt = detentionDataJsonArray[i];
					  var detchkpt2 = detchkpt;
					  
	                   if((detchkpt2.materialId == materialId1)  && (detchkpt2.legId == legId1) ){
						   
	                    detchkpt.TAT = tatWindow;
						detchkpt.runtime = runTimeWindow;
						detchkpt.saved = 'Y';
						detchkpt.detention=detentionWindow;
						var matId1 = materialId1;
						var matName1 = detchkpt.materialName;
						var legId1 = detchkpt.legId;
						var legName1 = detchkpt.legName1;
						var tat1 = tatWindow;
						var runTime1 = runTimeWindow;
						 
							for (var kk = 0; kk < completeRoutePath["routelatlongRoot"].length; kk++) {
				    			if( completeRoutePath["routelatlongRoot"][kk].legId == legId1){
				      			completeRoutePath["routelatlongRoot"][kk].TAT = tatWindow;
								completeRoutePath["routelatlongRoot"][kk].RUN_TIME = runTimeWindow;
								completeRoutePath["routelatlongRoot"][kk].DDHHMMdetention = detentionWindow;
							 }
							 convertMaterialArrayToJSOnhierachy(detentionDataJsonArray);
				    		}
							
							plotSavedInfowindow(completeRoutePath); 
							
	               	  }
	              };
			              
				  
              }else{
				  sweetAlert("Please select material !!");
				  return;
			  }
			  console.log("ended");
				  
      }
      
      function cancelInfo() {
      
       setTimeout(function() {
            tatInfowindowsArray.forEach(function (infowindow){
              		infowindow.close();
              });
              
               }, 1000);
      }
                    
	  function onlyNumbersWithColon(e) {
		     var charCode;
		     if (e.keyCode > 0) {
		     charCode = e.which || e.keyCode;
		     }
		     else if (typeof (e.charCode) != "undefined") {
		     charCode = e.which || e.keyCode;
		     }
		     if (charCode == 58)
		     return true
		     if (charCode > 31 && (charCode < 48 || charCode > 57))
		     return false;
		     return true;
     }
    
      				 
	 function plotInfowindows(completeRoutePath){
	 	 if(tatMarkersArray.length >0){
		 	 for (var j = 0,arr=tatMarkersArray.length; j < arr; j++) {
			   tatMarkersArray[j].setMap(null);
			 }
		 }
		 tatMarkersArray = [];
		 tatInfowindowsArray = [];
		 var totalDetention = 0;
		 var newLegTAT = 0;
		 var materialId = $('#materialId option:selected').attr('value');
		     for (var i = 0; i < completeRoutePath["routelatlongRoot"].length; i++) {
				 if(completeRoutePath["routelatlongRoot"][i].legDest== true){
					 var detentionForWindow = completeRoutePath["routelatlongRoot"][i].DDHHMMdetention;
				     var legIdForWindow = completeRoutePath["routelatlongRoot"][i].legId;
					 var latLong=new google.maps.LatLng(completeRoutePath["routelatlongRoot"][i].lat, completeRoutePath["routelatlongRoot"][i].lon);
					 var legName = completeRoutePath["routelatlongRoot"][i].LEG_NAME;
					 var tat = completeRoutePath["routelatlongRoot"][i].TAT;
					 var runTime = completeRoutePath["routelatlongRoot"][i].RUN_TIME;
					 var DDHHMMdetention = completeRoutePath["routelatlongRoot"][i].DDHHMMdetention
					 drawWindows(materialId,legIdForWindow,legName,detentionForWindow,runTime,tat,latLong);																
				 }
			}	
			cancelInfo();				
     }

	 function loadTemplateSummaryData(result,disableRemove){
	    	 if ($.fn.DataTable.isDataTable('#templateSummaryTable')) {
	             $('#templateSummaryTable').DataTable().clear().destroy();
	         }
			 var rows = new Array();
			 if(disableRemove == true){
				 var button ="<button class='btn btn-info btn-md' type='button' disabled><i class='glyphicon glyphicon-remove'></i> Remove</button>";
			 }else{
			 	var button ="<button class='btn btn-info btn-md' type='button'><i class='glyphicon glyphicon-remove'></i> Remove</button>";
			 }
			 var routeName = $('#routeId option:selected').text();
			 $.each(result, function(i, item) {
	                var row = { 
				  "0" : 0,
				  "1" : item.materialID,
	                          "2" : item.materialName,
				  "3" : routeName,
				  "4" : item.legTATdetails,	
				  "5" : item.totalTAT,
				  "6" : item.totalRunTime,
				  "7" : item.totalStoppage,			  
				  "8" : button
	                         }
	                   rows.push(row);
	              });
	                table = $('#templateSummaryTable').DataTable({
	                    "scrollY": "280px",
	                    "scrollX": true,
	                    paging : true,
	                    "serverSide": false,
	                    "oLanguage": {
	                        "sEmptyTable": "No data available"
	                    },"columns": [
				            {
				                "className":      'details-control',
				                "orderable":      false,
				                "data":           null,
				                "defaultContent": ''
				            },{},{},{},{},{},{},{},{}
				        ],
			    		"bFilter": true,
	       		    	"bInfo": false,
	     	    	    "dom": 'Bfrtip',
	     	    	    "processing": true,
			     		"iDisplayLength": 5,
	                    "buttons": [{
	                   		extend: 'pageLength'
	               	   	}]             	  
	                  });
			  table.columns( [1,4,5,6,7] ).visible( false );
	                  table.rows.add(rows).draw();
 	   		 
	    }
	    function loadAllTemplates(){
	    	 if ($.fn.DataTable.isDataTable('#templateTable')) {
	             $('#templateTable').DataTable().clear().destroy();
	         }
	    	 $.ajax({
	             type: "POST",
	             url: '<%=request.getContextPath()%>/LegCreationAction.do?param=getAllRouteTemplates',
	             "data": {
	             	 tripCustId: document.getElementById("cust_names").value
	             },
	             success: function(result) {
	              result = JSON.parse(result).routeTemplateRoot;
		 		  var rows = new Array();
		       if(result.length > 0){
	         	  $.each(result, function(i, item) {
	                  var row = { 
	                          "0" : item.slNoIndex,
				  			  "1" : item.ID,
	                          "2" : item.templateName,
				 			  "3" : item.routeId,
	                          "4" : item.routeName,
	                          "5" : item.materialName,
	                          "6" : item.view,
	                          "7" : item.modify
	                         }
	                  rows.push(row);
	              });
		      }
	                table = $('#templateTable').DataTable({
	                    "scrollY": "280px",
	                    "scrollX": true,
	                    paging : true,
	                    "serverSide": false,
	                    "oLanguage": {
	                        "sEmptyTable": "No data available"
	                    },
			    	"bFilter": true,
	       		    	"bInfo": false,
	     	    	   	"dom": 'Bfrtip',
	     	    	   	"processing": true,
	                    "buttons": [{
	                   		extend: 'pageLength'
	               	   	}]             	  
	                  });
	                  table.rows.add(rows).draw();
			  table.columns(1).visible( false );
			  table.columns(3).visible( false );
			}
	          });
	    }
	    
    function createTemplate(){
    	var templateName = document.getElementById("templateName").value;
	    var routeId = document.getElementById("routeId").value;
        if(templateName == ""){
			sweetAlert("Please enter Template Name");
			return;
        }
        if(routeId == ""){
        	sweetAlert("Please select Route name");
			return;
        }
        if(document.getElementById("materialId").value == ""){
        	sweetAlert("Please select Material");
			return;
        }
        var detailsEnteredOnMap =false;
        
        
        for(var i = 0; i < detentionDataJsonArray.length; i++) {
    	var obj = detentionDataJsonArray[i];
    	
 			if(obj.saved == 'Y'){
				 var legIdcount = legIdsArray.length;
				 var legCount = 0;
 			for(var l = 0; l < detentionDataJsonArray.length; l++) {
 					var obj1 = detentionDataJsonArray[l];
 					if (obj.materialId == obj1.materialId){
 						if(obj1.saved == 'Y'){
   							legCount++;
 				}
 			  }
			 }
			
			 if (legCount == legIdcount ){
			 detailsEnteredOnMap = true;		
			 }else{
			 sweetAlert("Please enter runtime for all legs on the map for the selected material");
			 return;
		}
 	}	
    }
        if(detailsEnteredOnMap == false){
        	sweetAlert("Please enter details on the map");
			return;
        }
        if(routeTemplateMode == "add"){
		    	 var params={
		    	    		templateName: templateName,
		    	    		routeId:routeId,
							tripCustId: document.getElementById("cust_names").value,
		    	    		routeLegMaterialAssoc: JSON.stringify(detentionDataJsonArray)
		 	 	  };
			 $.ajax({
		             url: '<%=request.getContextPath()%>/LegCreationAction.do?param=createRouteTemplate',
			         type: "POST",
		             data: params,
		             success: function(response) {
				if (response == "SUCCESS") {
		                    sweetAlert("Saved Successfully");
		                     setTimeout(function() {
		                         clearAllTemplateData();
		                         goBack();
		                     }, 1000);
		                 } else {
		                     sweetAlert(response);
		                     clearAllTemplateData();
		                 }
		             }
		         });	
        }
        else if(routeTemplateMode == "modify"){
	    	 var params={
	    			    templateId: templateId,
						tripCustId: document.getElementById("cust_names").value,
	    	    		routeLegMaterialAssoc: JSON.stringify(detentionDataJsonArray)
	 	 	  };
		 	$.ajax({
	             url: '<%=request.getContextPath()%>/LegCreationAction.do?param=updateRouteTemplate',
		         type: "POST",
	             data: params,
	             success: function(response) {
				if (response == "SUCCESS") {
	                    sweetAlert("Updated Successfully");
	                     setTimeout(function() {
	                         clearAllTemplateData();
	                         goBack();
	                     }, 1000);
	                 } else {
	                     sweetAlert(response);
	                     clearAllTemplateData();
	                 }
	             }
	         });
        }        
    }
     $('#templateTable').unbind().on('click', 'td', function(event) {
		var table = $('#templateTable').DataTable();
		var columnIndex = table.cell(this).index().column;
		var aPos = $('#templateTable').dataTable().fnGetPosition(this);
	        var data = $('#templateTable').dataTable().fnGetData(aPos[0]);
	        templateId = data[1];
			var templateName = data[2];
			var routeId = data[3];
		if(columnIndex == 6){//view button click
			viewRouteTemplate(templateId,templateName,routeId);
		}
		if(columnIndex == 7){//modify button click
			modifyRouteTemplate(templateId,templateName,routeId);
			
		}
	});  
 	$('#templateSummaryTable').unbind().on('click', 'td', function(event) {
	// $('#templateSummaryTable tbody').on('click', 'td', function () {
              var table = $('#templateSummaryTable').DataTable();
	      var columnIndex = table.cell(this).index().column;
	      var tr = $(this).closest('tr');
	       var row = table.row( tr );
	    if(columnIndex ==0){
	       if ( row.child.isShown() ) {
	           tr.removeClass( 'details' );
	           row.child.hide();
	           tr.removeClass('shown');
	       }
	       else {
	           tr.addClass( 'details' );
	           row.child( format(row.data()[4],row.data()[5],row.data()[6],row.data()[7])).show(); //leg TAT details
	           tr.addClass('shown');
	       }
	      }
	    else if(columnIndex ==8){//Remove button index
	    	console.log(row.data());
		var rowTodelete = table.row( $(this).parents('tr') );
		swal({
			  title: "Are you sure you want to remove the material?",
			  type: "warning",
			  showCancelButton: true,
			  confirmButtonClass: "btn-danger",
			  confirmButtonText: "Yes",
			  cancelButtonText: "No",
			  closeOnConfirm: true,
			  closeOnCancel: true
			},
			function(isConfirm) {
			  if (isConfirm) {
			  	removeMaterialFromArray(row.data()[1]);//materialId
	    			rowTodelete.remove().draw();
			  } else {
			  }
			});
	    }
	});
    
    function removeMaterialFromArray(materialId){
	var indexesTodelete=[];
	for(var i = 0; i < detentionDataJsonArray.length; i++) {
		var obj = detentionDataJsonArray[i];
		if(obj.materialId ==materialId){
			obj.deleted='Y'
		}
	 }
	 console.log(detentionDataJsonArray);
  }
    
 function format(d,totalTAT,totalRunTime,totalStoppage ) {
   var tbody="";
   var a;
   if(d.length>0)
    {
            for(var i=0;i<d.length;i++)
            {
            var row="";
            row += '<tr>'
                row += '<td>'+d[i].legName+'</td>';
                row += '<td>'+d[i].detention+'</td>';
				row += '<td>'+d[i].runtime+'</td>';
				row += '<td>'+d[i].TAT+'</td>';
                row += '</tr>';
                tbody+=row;
            }
	    var row="";
            row += '<tr>'
                row += '<td><b>Total</b> </td>';
                row += '<td>'+totalStoppage+'</td>';
                row += '<td>'+totalRunTime+'</td>';
				row += '<td>'+totalTAT+'</td>';
                row += '</tr>';
                //objTo.appendChild(row);
                tbody+=row;
            a = '<div style="width:40%;">'+
                '<table class="table table-bordered" >'+
                ' <thead>'+
                '<tr>'+
                   '<th>Leg Name</th>'+
                   '<th>Stoppage(DD:HH:mm)</th>'+
                   '<th>RunTime(DD:HH:mm)</th>'+
		   		   '<th>TAT(DD:HH:mm)</th>'+
                '</tr>'+
                '</thead>' +
                '<tbody id="tbodyId">'+tbody+'</tbody>'+
            '</table>'+
            '</div>';
   }
   else
   {
            var row="";
            row += '<tr>'
                row += '<td colspan="14"><b>No Records Found </b></td>';
                row += '<td></td>';
                row += '<td></td>';    
		row += '<td></td>';    
		row += '<td></td>';             
                row += '</tr>';
                tbody+=row;

        a = '<div style="overflow-x:auto;width:40%">'+
        '<table  cellpadding="5" cellspacing="0" border="0">'+
        ' <thead>'+
        '</thead>'+
        '<tbody id="tbodyId">'+tbody+'</tbody>'+
    '</table>'+
    '</div>';
   }
   return a;
}


function convertMaterialArrayToJSOnhierachy(array){
	var materialToLegTATMap = {};
	for(var i = 0; i < array.length; i++) {
    		var obj = array[i];
		var key = obj.materialId +"+"+obj.materialName
		var legTATDetail= {};
		legTATDetail["legName"] = obj.legName;
		legTATDetail["TAT"] = obj.TAT;
		legTATDetail["runtime"] = obj.runtime;
		legTATDetail["detention"] = obj.detention;
		if(obj.saved == 'Y' && obj.deleted== 'N'){
			if (materialToLegTATMap.hasOwnProperty(key) == false){
				var legTATdetailsArray = new Array();
				legTATdetailsArray.push(legTATDetail);
				materialToLegTATMap[key] = legTATdetailsArray;
			}else{
				legTATdetailsArray = materialToLegTATMap[key];
				legTATdetailsArray.push(legTATDetail);
				materialToLegTATMap[key] = legTATdetailsArray;
			}	
		}	
	}
	
	var finalMaterialLegJSONArray = new Array();
	for(var key in materialToLegTATMap){
		var finalObj = new Object();
		finalObj["materialID"] = key.split('+')[0];
		finalObj["materialName"] = key.split('+')[1];
		finalObj["legTATdetails"] = materialToLegTATMap[key];
		//calculate sum of TAT
		var totalTAT="00:00:00";
		var totalRunTime="00:00:00";
		var totalStoppage="00:00:00";
		console.log(materialToLegTATMap[key][0]);
		for(var i=0; i < materialToLegTATMap[key].length;i++){
			totalTAT = addTwoDDHHMM(totalTAT,materialToLegTATMap[key][i].TAT);
			totalRunTime = addTwoDDHHMM(totalRunTime,materialToLegTATMap[key][i].runtime);
			totalStoppage = addTwoDDHHMM(totalStoppage,materialToLegTATMap[key][i].detention);
		}
		finalObj["totalTAT"] = totalTAT;
		finalObj["totalRunTime"] = totalRunTime;
		finalObj["totalStoppage"] = totalStoppage;
		finalMaterialLegJSONArray.push(finalObj);
	}
	console.log("finalMaterialLegJSONArray");
	console.log(finalMaterialLegJSONArray);
	loadTemplateSummaryData(finalMaterialLegJSONArray,false);
}

	function addTwoDDHHMM(time1 , time2){ 
	        var splitTime1= time1.split(':');
	        var splitTime2= time2.split(':');
		day = Number(splitTime1[0]) + Number(splitTime2[0]);
		hour = Number(splitTime1[1]) + Number(splitTime2[1]);
		minute = Number(splitTime1[2]) + Number(splitTime2[2]);
		day = day + hour/24;
		hour = hour % 24;
		hour = hour + minute/60;
		minute = minute%60;
		
		var total = padzero(day)+":"+padzero(hour)+":"+padzero(minute);
		
		return total;
	}
	function padzero(day){
		day = Math.floor(day);
		return (day < 10 ? '0' : '') + day;
	}

   function plotSavedInfowindow(completeRoutePath){
	 	 if(tatMarkersArray.length >0){
		 	 for (var j = 0,arr=tatMarkersArray.length; j < arr; j++) {
			   tatMarkersArray[j].setMap(null);
			 }
		 }
		 tatMarkersArray = [];
		 tatInfowindowsArray = [];
		 var totalDetention = 0;
		 var newLegTAT = 0;
	 
		 for (var k = 0; k < materialListStore["materialListRoot"].length ; k++) {
			var materialId = materialListStore["materialListRoot"][k].idIndex;
			var mat = materialListStore["materialListRoot"][k];  
			 for (var i = 0; i < completeRoutePath["routelatlongRoot"].length; i++) {
				if(completeRoutePath["routelatlongRoot"][i].legDest== true){
					 var detentionForWindow = completeRoutePath["routelatlongRoot"][i].DDHHMMdetention;
					 var legIdForWindow = completeRoutePath["routelatlongRoot"][i].legId;
					 var latLong=new google.maps.LatLng(completeRoutePath["routelatlongRoot"][i].lat, completeRoutePath["routelatlongRoot"][i].lon);
					 var legName = completeRoutePath["routelatlongRoot"][i].LEG_NAME;
					 var tat = completeRoutePath["routelatlongRoot"][i].TAT;
					 var runTime = completeRoutePath["routelatlongRoot"][i].RUN_TIME;
					 drawWindows(materialId,legIdForWindow,legName,detentionForWindow,runTime,tat,latLong);	
				}
			}	
		}
		cancelInfo();					
   }

	function plotMywindows(completeRoutePath){
	 	 if(tatMarkersArray.length >0){
	 	 for (var j = 0,arr=tatMarkersArray.length; j < arr; j++) {
		   tatMarkersArray[j].setMap(null);
		 }
		}
	 	 console.log("asaskaskans: "+JSON.stringify(completeRoutePath));
		 //detentionDataJsonArray = [];
		 tatMarkersArray = [];
		 tatInfowindowsArray = [];
		 var totalDetention = 0;
		 var newLegTAT = 0;
		 
		 
		 if (detentionDataJsonArray.length > 0){
		  	 var count = 0;
			 var myMatId = $('#materialId option:selected').attr('value');
			 console.log("myMatId: "+myMatId);
			 console.log("detentionDataJsonArray.length: "+detentionDataJsonArray.length);
			 for (var jjj = 0 ; jjj<detentionDataJsonArray.length;jjj++){
				 var myArr = detentionDataJsonArray[jjj];
				 console.log("myArr.materialId : "+myArr.materialId);
				 if (myArr.materialId == myMatId){
				 	count = count + 1;
					for (var i = 0; i < completeRoutePath["routelatlongRoot"].length; i++) {
						if(completeRoutePath["routelatlongRoot"][i].legDest== true){
							 var detentionForWindow = completeRoutePath["routelatlongRoot"][i].DDHHMMdetention;
							 var tatofthiswindow = completeRoutePath["routelatlongRoot"][i].TAT;
							 var legIdForWindow = completeRoutePath["routelatlongRoot"][i].legId;
							 var latLong=new google.maps.LatLng(completeRoutePath["routelatlongRoot"][i].lat, completeRoutePath["routelatlongRoot"][i].lon);
							 var legName = completeRoutePath["routelatlongRoot"][i].LEG_NAME;
							 if (completeRoutePath["routelatlongRoot"][i].legId == myArr.legId){
								drawWindows(myArr.materialId,legIdForWindow,legName,myArr.detention,myArr.runtime,myArr.TAT,latLong);
							 }
//							 var exists = checkTheObject(myMatId,legIdForWindow);
								//	 if (exists){
								//		 var myObj = findTheObject(myMatId,legIdForWindow);
								//		 drawWindows(myArr.materialId,legIdForWindow,legName,myObj.detention,myObj.runtime,myObj.TAT,latLong);
								//		 }
								//	 else{
								//		 drawWindows(myArr.materialId,legIdForWindow,legName,detentionForWindow,'',tatofthiswindow,latLong);
								//		}
							
						}
					}
				}
			}
			if (count == 0){
				plotInfowindows(completeRoutePath);
			}
			 
		}else{
			plotInfowindows(completeRoutePath);
		}											
		 cancelInfo();					
  }

	  function findTheObject (materialId,legId){
		  for (var m = 0 ; m<detentionDataJsonArray.length;m++){
			  var myObj = detentionDataJsonArray[m];
			  if ((myObj.materialId == materialId ) && (myObj.legId== legId)){
				  return myObj;
				  }
			  }
		  }

	  function checkTheObject (materialId,legId){
		  for (var m = 0 ; m<detentionDataJsonArray.length;m++){
			  var myObj = detentionDataJsonArray[m];
			  if ((myObj.materialId == materialId ) && (myObj.legId== legId)){
				  return true;
				  }
			  }
		    return false;
		  }
	
		function loadRouteAndMaterialData(){
			detentionDataJsonArray = [];
			var customerId = document.getElementById("cust_names").value;
			$("#routeId").empty().select2();
		$.ajax({
	        url: '<%=request.getContextPath()%>/TripCreatAction.do?param=getRouteNames',
	        data: {
	        	custId : customerId,
	        	legConcept:'Y',
	        	hubAssociatedRoutes : 'N'
	  
	        },
	        success: function(result) {
	            routeList = JSON.parse(result);
				for (var i = 0; i < routeList["RouteNameRoot"].length; i++) {
                    $('#routeId').append($("<option></option>").attr("value", routeList["RouteNameRoot"][i].RouteId).attr("count",routeList["RouteNameRoot"][i].legCount)
                    .text(routeList["RouteNameRoot"][i].RouteName));
	            }
	            $('#routeId').select2();
	        }    
				
		});
		$("#materialId").empty();
		
		$.ajax({
	        url: '<%=request.getContextPath()%>/MaterialMasterAction.do?param=getMaterialMasterDetails',
	        data: {
	        	custId : customerId
	        },
	        success: function(result) {
	             materialListStore = JSON.parse(result);
				 for (var i = 0; i < materialListStore["materialListRoot"].length; i++) {
                    $('#materialId').append($("<option></option>").attr("value", materialListStore["materialListRoot"][i].idIndex).attr("name", materialListStore["materialListRoot"][i].materialNameIndex)
                    .text( materialListStore["materialListRoot"][i].materialNameIndex));       
	            }
	        }    
				
		});
		}
		
	 function calculateTAT(){
               var stoppageDuration = document.getElementById("detentionOfWindow").value;
			   var runTimeDuration = document.getElementById("runTime").value;
				   if ((stoppageDuration != '') & (runTimeDuration != '')){
					    var stoppageDurationInMins = convertDDHHMMToMinutes(stoppageDuration);
					    var runtimeDurationInMins = convertDDHHMMToMinutes(runTimeDuration);
					    var tatInMins = parseInt(stoppageDurationInMins) + parseInt(runtimeDurationInMins);
					    document.getElementById("tat").value = convertMinutesToDDHHMM(Number(tatInMins *60000));
				   }
              
      		}
      		
      		
      		
      function drawWindows (materialId,legId,legName,detention,runtime,TAT,latLong){
				detentionimage = {
									url: '/ApplicationImages/VehicleImages/green.png', // This marker is 20 pixels wide by 32 pixels tall.
									size: new google.maps.Size(48, 48), // The origin for this image is 0,0.
									origin: new google.maps.Point(0, 0), // The anchor for this image is the base of the flagpole at 0,32.
									anchor: new google.maps.Point(0, 32)
							}; 	
																	
				  detentionmarker = new google.maps.Marker({
					position:latLong,
					map: map,
					icon:detentionimage
				});
																
				tatMarkersArray.push(detentionmarker);
						var detentioncontent = ' <div style="width:230px;height:85px">' +
						'<table> '+
						'<tr><td><input type="text" id="materialIdWindow" value="'+materialId+'" style="display: none;" /></td></tr> ' +
						'<tr><td><input type="text" id="legIdOfWindow" value="'+legId+'" style="display: none;" /></td></tr> ' +
						'<tr><td><input type="text" id="legNameOfWindow" value="'+legName+'" style="display: none;" /></td></tr> ' +																		
						'<tr><td width="60%"> Stoppage</td><td width="40%"><input type="text" id="detentionOfWindow" onchange="calculateTAT()" value="'+detention+'" maxlength = 8 onkeypress="return onlyNumbersWithColon(event);"/></td></tr> '+
						'<tr><td width="60%">Run Time</td><td width="40%"><input type="text" id="runTime" value="'+runtime+'" maxlength = 8 onchange="calculateTAT()"  onkeypress="return onlyNumbersWithColon(event);"/></td></tr> '+
						'<tr><td width="60%">TAT</td><td width="40%"><input type="text" id="tat" value="'+TAT+'" maxlength = 8 disabled onkeypress="return onlyNumbersWithColon(event);"/></td></tr> '+
						'<tr><td>* (DD:HH:mm)</td><td style="text-align:center;padding-top: 1px;"><input type="button"  value="Save" id="saveInfo" onclick="saveInfoWindowDetails()"/></td></tr> ' +
						'</table> </div>';

						tatinfowindow = new google.maps.InfoWindow({
					content:detentioncontent,
					marker:detentionmarker
				
					});
																	
				google.maps.event.addListener(detentionmarker,'click', (function(detentionmarker,detentioncontent,tatinfowindow){ 
						return function() {
								  tatInfowindowsArray.forEach(function (infowindow){
					              		infowindow.close();
					              });
								tatinfowindow.setContent(detentioncontent);
								tatinfowindow.open(map,detentionmarker);
							};
						})(detentionmarker,detentioncontent,tatinfowindow)); 
						//detentionmarker.setAnimation(google.maps.Animation.DROP); 
						
						tatInfowindowsArray.push(tatinfowindow);
      
      }	
	
			
      		
	
</script>

<!--

//-->
</script>
  <jsp:include page="../Common/footer.jsp" />
		<!-- </body>   -->
	<!-- </html> -->