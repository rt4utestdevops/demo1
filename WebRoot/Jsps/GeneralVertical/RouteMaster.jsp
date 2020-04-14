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
	  
 	  <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-multiselect/0.9.13/js/bootstrap-multiselect.min.js"></script>
	   <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-multiselect/0.9.13/js/bootstrap-multiselect.min.js"></script>
	   <script src="https://cdnjs.cloudflare.com/ajax/libs/multiple-select/1.2.0/multiple-select.js"></script>   
      
	   <link rel="stylesheet" href="https://netdna.bootstrapcdn.com/bootstrap/3.3.2/css/bootstrap.min.css">
	  
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
.dataTables_scrollBody {
			/* position: relative; */
    		/* overflow: auto; */
    		width: 100%;
    		overflow-y: scroll !important;
    		max-height: 486px !important;
		}		
		
		#cust_names{
			 width:196.22px;
			 height: 34px;
		 }


		 .form-control{
		 	 width: 196.22px;
			 height: 34px;
		 }
		 .open>.dropdown-menu {
		     display: block;
		    /* width: 200px; */
			 width : 305px;
		     height: 162px !important;
		     overflow-x: auto !important;
		     overflow-y: visible !important;
		   		 }
		 .multiselect dropdown-toggle btn btn-default{
			 width:196.22px;
			 height: 34px;
		 }

		 .btn-group.open .dropdown-toggle {
		 	 width:196.22px;
			 height: 34px;
		 }
		 .multiselect-selected-text{
		 	 width:196.22px;
			 height: 34px;
		  }
		 .btn-group>.btn:first-child {
		    width: 196.22px;
		  }
		.modal-title{
		   text-align: center;
		  }
		 .btn .caret {
    		display: none;
		  }
		.multiselect-container {
		    overflow-y: auto;
    		height: 211px !important;
		}		
		.multiselect {
			width : 245px !important;
		}
      </style>
 <!--      </head>-->
	<!--<body onload="getCustomerName();">-->
      <div class="custom">
         <div class="col-md-12">
            <div class="panel panel-primary">
               <div class="panel-heading">
                  <h3 class="panel-title" >
                     Route Creation
                  </h3>
               </div>
               <div class="panel-body" style="padding-top: 0px;">
            <!--   	<div class="col-lg-12 row" style="margin-top: 10px;">    -->
			<div class="panel row" style="padding:1% ;margin: 0%;border: 0px dotted !important">
						<label for="staticEmail2" class="col-lg-1 col-md-1 col-sm-12" style="margin-left: 10px;">Customer:</label>
					    <div class="col-lg-3 ">
							<select class="form-control" multiple="multiple" id="cust_names"  onchange="selectCustomers()">
							</select>
						<!--	<select id="cust_names" class="form-control js-example-basic-single select2">
								<option value="">-- Select --</option>
								<option value="00000">ALL</option>
							 </select>  -->
					     </div>
							   <div class="col-xs-12 col-md-1 col-sm-12">
								   <div  style="margin-left: 22px">
		                              <button id="viewBtn" type="button" class="btn btn-primary" onclick="loadData()">View</button>
		                           </div>
		                       </div>
		                       <div class="col-xs-12 col-md-1 col-sm-12">
								   <div>
		                              <button id="addId" type="button" class="btn btn-primary" onclick="addClick('mapViewId')">Add</button>
		                           </div>
		                       </div>
		                        <div>
		                        	<h5 id="dialogBoxId" style="color:red;"></h5>
		                        </div>
					</div>
					
					
                     <div class="tabs-container">
                        <ul class="nav nav-tabs" style="display: table-cell;">
                           <li><a href="#summaryId" data-toggle="tab"  onclick="$('#summaryId').addClass('show');" active>Route Details</a></li>
                     	<!-- <li class="disabled"><a href="#mapViewId">Route Creation</a></li> -->   
                     	   <li><a href="#mapViewId" data-toggle="tab1" onclick="changeRouteCreationTab('mapViewId')">Route Creation</a></li>
                        </ul>
                     </div>
                     <div class="tab-content" id="tabs">
                        <div class="tab-pane" id="summaryId">
                           <table id="summaryTable" class="table table-striped table-bordered" cellspacing="0" width="100%" style="margin-top:1%">
                              <thead>
                                 <tr>
                                    <th>Sl No</th>
                                    <th>Cust Name</th>
                                    <th>Route Name</th>
                                    <th>Route Key</th>
                                    <th>Distance(Km)</th>
                                    <th>TAT(DD:HH:mm)</th>
                                    <th>Radius(m)</th>
                                    <th>Status</th>
                                    <th>Action</th>
                                    <th>Activate/Deactivate</th>
                                 </tr>
                              </thead>
                           </table>
                        </div>
                        <div class="tab-pane" id="mapViewId">
                 		<div class="col-md-4 ">
                            <form class="form" role="form" autocomplete="off" style="margin-top: 13px;">
                                <div class="form-group row">
                                    <label class="col-lg-4 col-md-4 col-form-label form-control-label">Leg Name</label>
                                    <div class="col-lg-8 col-md-8">
                                         <div class="input-group after-add-more">
											  <div class="input-group-btn"> 
												<button id="checkAddBtn" style="margin-top:4px; border-radius: 4px;" class="btn btn-primary add-more" type="button"><i class="glyphicon glyphicon-plus"></i> Click to add Leg</button>
											  </div>
										</div>
                                    </div>
                                </div>
                                <div class="form-group row">
                                    <label class="col-lg-4 col-md-4 col-form-label form-control-label">Distance(Km)</label>
                                    <div class="col-lg-8 col-md-8">
                                        <input class="form-control" type="number" value="" id="distanceId" readonly minValue="0">
                                    </div>
                                </div>
                                <div class="form-group row">
                                    <label class="col-lg-4 col-md-4 col-form-label form-control-label">TAT(DD:HH:mm)</label>
                                    <div class="col-lg-8 col-md-8" >
                                        <input class="form-control" type="text" value="" id="TATId" readonly>
                                    </div>
                                </div>
                                <div class="form-group row">
                                    <label class="col-lg-4 col-md-4 col-form-label form-control-label">Route Name</label>
                                    <div class="col-lg-8 col-md-8">
                                        <input class="form-control" type="text" value="" id="routeNameId" onkeypress="return checkSpcialChar(event)">
                                    </div>
                                </div>
                                <div class="form-group row">
                                    <label class="col-lg-4 col-md-4 col-form-label form-control-label">Route Key</label>
                                    <div class="col-lg-8 col-md-8">
                                        <input class="form-control" type="text" value="" id="routeKeyId">
                                    </div>
                                </div>
                                <div class="form-group row">
                                    <label class="col-lg-4 col-md-4 col-form-label form-control-label">Route Radius(m)</label>
                                    <div class="col-lg-8 col-md-8">
                                        <input class="form-control" type="number" min="1" max="99999999" value="500" id="routeRadiusId"  onkeypress="if(this.value.length==8) return false;">
                                    </div>
                                </div>
                                <div class="form-group row">
                                    <label class="col-lg-4 col-md-4 col-form-label form-control-label"></label>
                                    <div class="col-lg-8 col-md-8">
		                                 <input style="height: 35px;margin-left: 0%;" id="saveBtn" type="button" class="btn btn-success" value="Save Changes" onclick="saveRouteDetails(true);">
		                                 <input style="margin-left: 50%;"type="button" class="btn btn-primary" value="Go Back" onclick="goBack();">
                                    </div>
                                </div>
                                <div class="form-group row">
	                              <label class="col-lg-4 col-md-4 col-form-label form-control-label"></label>
	                              <div class="col-lg-8 col-md-8">
	                                 <input type="button" class="btn btn-danger" value="Clear All" onclick="resetAllData();" style="margin-top: 16px;">
	                              </div>
                                </div>
                            </form>
                    </div>
                	<div class="col-md-7">
                	    <button type="button" class="btn btn-default btn-md" id="backButtonId1" onclick="getPDFMap();" style="display: none;margin-bottom: 4px; margin-top: 4px; background-color: deepskyblue;">PDF</button>
                        <div id="dvMap" style="width: 800px; height: 417px; margin-top: 8px; border: 1px solid gray;"></div>
                        <div class="inline row" style="margin-left: 2px;margin-top: 7px;display: -webkit-box;">
                           <label class="container checkbox-inline col-md-6" style="padding-left: 41px; font-weight: 400;">Show Customer/Smart Hubs
                           <input type="checkbox" id="smartHub">
                           <span class="checkmark"></span>
                           </label>
                           <label class="container checkbox-inline col-md-6" style="padding-left: 41px; font-weight: 400;margin-left: -60%;">Show Checkpoints
                           <input type="checkbox" id="checkPoint">
                           <span class="checkmark"></span>
                           </label>
                        </div>
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
	var detentionCheckPointsArray = [];
	var currRouteId;
	var checkPointMarkersArray = [];
	var checkPointInfoWindowsArray = [];
	var completeRoutePath;
	var legTAT = 0;
    var srcDestMarkers = [];
    var myLatLngC;
	var uniqueId;
    
   $('#cust_names').change(function () {
			document.getElementById("addId").disabled = false;
        	$("#mapViewId").find("*").prop("disabled", false); 
        	document.getElementById("mapViewId").disabled = false; 				
        		
			var custcombo = "";       
			var custselected =$("#cust_names option:selected");        
			custselected.each(function () {
				custcombo += $(this).val() + ",";
			});		
			var combo= custcombo.split(",").join(",");
			var comboLength = custcombo.split(",").length;				
			if(comboLength == 1) {		
				$('#summaryTable').DataTable().clear().destroy();
				location.reload();
			}	
				
	});
    
    function getPDFMap(){
        window.open("<%=request.getContextPath()%>/RouteMapPDF?&routeId="+routeIdPdf+"&routeName="+document.getElementById("routeNameId").value);
    }
 
	function selectCustomers() {
		loadData();
	}
	
	
	function addClick(tab) {
			uniqueId = 0;
		  	var custcombo = "";       
			var custselected =$("#cust_names option:selected");        
			custselected.each(function () {
				custcombo += $(this).val() + ",";
			});		
			var combo= custcombo.split(",").join(",");
			var comboLength = custcombo.split(",").length;
				
			if(comboLength > 2 || document.getElementById("cust_names").value == "") {
				sweetAlert("Please select one customer");
				return;
			} if(uniqueId == 0) {
				changeTab(tab);
			} 
	}
	
	  function changeTab(tab) {     
	    	var custcombo = "";       
			var custselected =$("#cust_names option:selected");        
			custselected.each(function () {
				custcombo += $(this).val() + ",";
			});		
			var combo= custcombo.split(",").join(",");
			var comboLength = custcombo.split(",").length;
	
		  if(document.getElementById("cust_names").value == "") {
			sweetAlert("Please select one customer");
			return;
        } else {
            $('.nav-tabs a[href="#' + tab + '"]').tab('show');
            clearAllData();
            $('#addId').hide();
            $('#viewBtn').hide();           
           $('#summaryId').removeClass("show");             
        }			
    };	
	
	
	
	function changeRouteCreationTab(tab1) {
			uniqueId = 0;
			var custcombo = "";       
			var custselected =$("#cust_names option:selected");
        
			custselected.each(function () {
				custcombo += $(this).val() + ",";
			});		
			var combo= custcombo.split(",").join(",");
			var comboLength = custcombo.split(",").length;
			if(uniqueId != 0){
				return;
			}
			
		if(comboLength > 2  || document.getElementById("cust_names").value == "") {				
			sweetAlert("Please select one customer");
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
		
	var custcombo = "";       
    var custselected = $("#cust_names option:selected");
    custselected.each(function () {
        custcombo += $(this).val() + ",";
    });
    var combo= custcombo.split(",").join(",");
	var param = {
 		custNames:combo                 
    };
		
    if (document.getElementById("cust_names").value == "") {
        sweetAlert("Please select one customer");
        return;
    }else{
    	summaryTable = $('#summaryTable').DataTable({
            "ajax": {
                "url": "<%=request.getContextPath()%>/LegCreationAction.do?param=getRouteMasterDetails",
                "dataSrc": "routeDataRoot",
                "data": {
                    tripCustId: combo//document.getElementById("cust_names").value
                }
            },
            "oLanguage": {
                "sEmptyTable": "No data available"
            },
            "bDestroy": true,
			"scrollY": "300px",
			"scrollX": true,
            "responsive": true,
	        	"dom": 'Bfrtip',
        	 	"buttons": [{extend:'pageLength'},
        	 				{extend:'excel',
        	 				text: 'Export to Excel',
                            className: 'btn btn-primary',
        	 				exportOptions: {
				                columns: [0,1,2,3,4,5,6,7]
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
		            { width: 50, targets: 7 },
					{ width: 50, targets: 8 }
		        ],
            "columns": [{
                "data": "slNoIndex"
            }, {
                "data": "custNameIndex"
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
    $('#smartHub').change(function() {
        if (this.checked) {
            bufferStoreSmartHub.load({
             	params:{
					tripCustId: document.getElementById("cust_names").value
				},
                callback: function() {
                    plotBuffersForSmartHub();
                }
            });
            polygonStoreSmartHub.load({
            	params:{
					tripCustId: document.getElementById("cust_names").value
				},
                callback: function() {
                    plotPolygonSmartHub();
                }
            });
        } else {
            for (var i = 0; i < circlessmart.length; i++) {
                circlessmart[i].setMap(null);
                buffermarkersmart[i].setMap(null);
            }
            for (var i = 0; i < polygonsmart.length; i++) {
                polygonsmart[i].setMap(null);
                polygonmarkersmart[i].setMap(null);
            }
        }
    });
    $('#checkPoint').change(function() {
        if (this.checked) {
            bufferStoreCheckPoint.load({
            	params:{
					tripCustId: document.getElementById("cust_names").value
				},
                callback: function() {
                    plotBuffersForCheckPoint();
                }
            });
            polygonStoreCheckPoint.load({
            	params:{
					tripCustId: document.getElementById("cust_names").value
				},
                callback: function() {
                    plotPolygonCheckPoint();
                }
            });

        } else {
            for (var i = 0; i < circlescheck.length; i++) {
                circlescheck[i].setMap(null);
                buffermarkerscheck[i].setMap(null);
            }
            for (var i = 0; i < polygonscheck.length; i++) {
                polygonscheck[i].setMap(null);
                polygonmarkerscheck[i].setMap(null);
            }
        }
    });	
    var bufferStoreSmartHub=new Ext.data.JsonStore({
			url: '<%=request.getContextPath()%>/LegCreationAction.do?param=getSmartHubBuffer',
			id:'BufferMapView',
			root: 'BufferMapView',
			autoLoad: false,
			remoteSort: true,
			fields: ['longitude','latitude','buffername','radius','imagename']
	});
	var polygonStoreSmartHub=new Ext.data.JsonStore({
				url: '<%=request.getContextPath()%>/LegCreationAction.do?param=getSmartHubPolygon',
				id:'PolygonMapView',
				root: 'PolygonMapView',
				autoLoad: false,
				remoteSort: true,
				fields: ['longitude','latitude','polygonname','sequence','hubid']
		}); 
	var bufferStoreCheckPoint=new Ext.data.JsonStore({
			url: '<%=request.getContextPath()%>/LegCreationAction.do?param=getcheckpointBuffer',
			id:'BufferMapView',
			root: 'BufferMapView1',
			autoLoad: false,
			remoteSort: true,
			fields: ['longitude','latitude','buffername','radius','imagename']
	});
	var polygonStoreCheckPoint=new Ext.data.JsonStore({
				url: '<%=request.getContextPath()%>/LegCreationAction.do?param=getcheckpointPolygon',
				id:'PolygonMapView',
				root: 'PolygonMapView1',
				autoLoad: false,
				remoteSort: true,
				fields: ['longitude','latitude','polygonname','sequence','hubid']
		}); 

	

		
	function plotBuffersForSmartHub(){
		    for(var i=0;i<bufferStoreSmartHub.getCount();i++){
		    var rec=bufferStoreSmartHub.getAt(i);
		    var urlForZero='/ApplicationImages/VehicleImages/red.png';
		    var convertRadiusToMeters = rec.data['radius'] * 1000;
		    var myLatLng = new google.maps.LatLng(rec.data['latitude'],rec.data['longitude']);       	
		        createCircle = {
		            strokeColor: '#A7A005',
	    			strokeOpacity: 0.8,
	    			strokeWeight: 3,
	    			fillColor: '#ECF086',
		            fillOpacity: 0.55,
		            map: map,
		            center: myLatLng,
		            radius: convertRadiusToMeters //In meters
		        };
		  bufferimage = {
		        	url: urlForZero, // This marker is 20 pixels wide by 32 pixels tall.
		        	scaledSize: new google.maps.Size(19, 35), // The origin for this image is 0,0.
		        	origin: new google.maps.Point(0, 0), // The anchor for this image is the base of the flagpole at 0,32.
		        	anchor: new google.maps.Point(0, 32)
		    	};      
	
		  buffermarker = new google.maps.Marker({
	            	position: myLatLng,
	            	id:rec.data['vehicleNo'],
	            	map: map,
	            	icon:bufferimage
	        	});
	        buffercontent=rec.data['buffername']; 	
			bufferinfowindow = new google.maps.InfoWindow({
	      		content:buffercontent,
	      		id:rec.data['vehicleNo'],
	      		marker:buffermarker
	  		});	
	  		
	  		google.maps.event.addListener(buffermarker,'click', (function(buffermarker,buffercontent,bufferinfowindow){ 
	    			return function() {
	        			bufferinfowindow.setContent(buffercontent);
	        			bufferinfowindow.open(map,buffermarker);
	    			};
				})(buffermarker,buffercontent,bufferinfowindow)); 
				buffermarker.setAnimation(google.maps.Animation.DROP); 
	
	
	    		buffermarkersmart[i]=buffermarker;
				circlessmart[i] = new google.maps.Circle(createCircle);
		    }
	    }
	function plotPolygonSmartHub(){
	    var hubid=0;
	    var polygonCoords=[];
	    for(var i=0;i<polygonStoreSmartHub.getCount();i++)
	    {
	    	var rec=polygonStoreSmartHub.getAt(i);
	    	if(i!=polygonStoreSmartHub.getCount()-1 && rec.data['hubid']==polygonStoreSmartHub.getAt(i+1).data['hubid'])
	    	{
	    	var latLong=new google.maps.LatLng(rec.data['latitude'],rec.data['longitude']);
	    	polygonCoords.push(latLong);
	    	continue;
			}
			else
			{
			var latLong=new google.maps.LatLng(rec.data['latitude'],rec.data['longitude']);
	    	polygonCoords.push(latLong);
			}
  			polygon = new google.maps.Polygon({
    			paths: polygonCoords,
    			strokeColor: '#A7A005',
    			strokeOpacity: 0.8,
    			strokeWeight: 3,
    			fillColor: '#ECF086',
	            fillOpacity: 0.55
  				});
  			
  			polygonimage = {
	        	url: '/ApplicationImages/VehicleImages/red.png', // This marker is 20 pixels wide by 32 pixels tall.
	        	size: new google.maps.Size(48, 48), // The origin for this image is 0,0.
	        	origin: new google.maps.Point(0, 0), // The anchor for this image is the base of the flagpole at 0,32.
	        	anchor: new google.maps.Point(0, 32)
	    	}; 	
  				
  			  polygonmarker = new google.maps.Marker({
            	position:latLong,
            	map: map,
            	icon:polygonimage
        	});
        	var polygoncontent=rec.data['polygonname'];
			polygoninfowindow = new google.maps.InfoWindow({
      			content:polygoncontent,
      			marker:polygonmarker
  		});	
  		
     	google.maps.event.addListener(polygonmarker,'click', (function(polygonmarker,polygoncontent,polygoninfowindow){ 
    			return function() {
        			polygoninfowindow.setContent(polygoncontent);
        			polygoninfowindow.open(map,polygonmarker);
    			};
			})(polygonmarker,polygoncontent,polygoninfowindow)); 
			polygonmarker.setAnimation(google.maps.Animation.DROP); 
  			polygon.setMap(map);
  			polygonsmart[hubid]=polygon;
  			polygonmarkersmart[hubid]=polygonmarker;
  			hubid++;
  			polygonCoords=[];
	    }
	    }
	    
	    
	    function plotBuffersForCheckPoint(){
		    for(var i=0;i<bufferStoreCheckPoint.getCount();i++){
		    var rec=bufferStoreCheckPoint.getAt(i);
		    var urlForZero='/ApplicationImages/VehicleImages/green.png';
		    var convertRadiusToMeters = rec.data['radius'] * 1000;
		    var myLatLng = new google.maps.LatLng(rec.data['latitude'],rec.data['longitude']);       	
		        createCircle = {
		            strokeColor: '#A7A005',
	    			strokeOpacity: 0.8,
	    			strokeWeight: 3,
	    			fillColor: '#ECF086',
		            fillOpacity: 0.55,
		            map: map,
		            center: myLatLng,
		            radius: convertRadiusToMeters //In meters
		        };
		  bufferimage = {
		        	url: urlForZero, // This marker is 20 pixels wide by 32 pixels tall.
		        	scaledSize: new google.maps.Size(19, 35), // The origin for this image is 0,0.
		        	origin: new google.maps.Point(0, 0), // The anchor for this image is the base of the flagpole at 0,32.
		        	anchor: new google.maps.Point(0, 32)
		    	};      
	
		  buffermarker = new google.maps.Marker({
	            	position: myLatLng,
	            	id:rec.data['vehicleNo'],
	            	map: map,
	            	icon:bufferimage
	        	});
	        buffercontent=rec.data['buffername']; 	
			bufferinfowindow = new google.maps.InfoWindow({
	      		content:buffercontent,
	      		id:rec.data['vehicleNo'],
	      		marker:buffermarker
	  		});	
	  		
	  		google.maps.event.addListener(buffermarker,'click', (function(buffermarker,buffercontent,bufferinfowindow){ 
	    			return function() {
	        			bufferinfowindow.setContent(buffercontent);
	        			bufferinfowindow.open(map,buffermarker);
	    			};
				})(buffermarker,buffercontent,bufferinfowindow)); 
				buffermarker.setAnimation(google.maps.Animation.DROP); 
	
	
	    		buffermarkerscheck[i]=buffermarker;
				circlescheck[i] = new google.maps.Circle(createCircle);
		    }
	    }
	function plotPolygonCheckPoint(){
	    var hubid=0;
	    var polygonCoords=[];
	    for(var i=0;i<polygonStoreCheckPoint.getCount();i++)
	    {
	    	var rec=polygonStoreCheckPoint.getAt(i);
	    	if(i!=polygonStoreCheckPoint.getCount()-1 && rec.data['hubid']==polygonStoreCheckPoint.getAt(i+1).data['hubid'])
	    	{
	    	var latLong=new google.maps.LatLng(rec.data['latitude'],rec.data['longitude']);
	    	polygonCoords.push(latLong);
	    	continue;
			}
			else
			{
			var latLong=new google.maps.LatLng(rec.data['latitude'],rec.data['longitude']);
	    	polygonCoords.push(latLong);
			}
  			polygon = new google.maps.Polygon({
    			paths: polygonCoords,
    			strokeColor: '#A7A005',
    			strokeOpacity: 0.8,
    			strokeWeight: 3,
    			fillColor: '#ECF086',
	            fillOpacity: 0.55
  				});
  			
  			polygonimage = {
	        	url: '/ApplicationImages/VehicleImages/green.png', // This marker is 20 pixels wide by 32 pixels tall.
	        	size: new google.maps.Size(48, 48), // The origin for this image is 0,0.
	        	origin: new google.maps.Point(0, 0), // The anchor for this image is the base of the flagpole at 0,32.
	        	anchor: new google.maps.Point(0, 32)
	    	}; 	
  				
  			  polygonmarker = new google.maps.Marker({
            	position:latLong,
            	map: map,
            	icon:polygonimage
        	});
        	var polygoncontent=rec.data['polygonname'];
			polygoninfowindow = new google.maps.InfoWindow({
      			content:polygoncontent,
      			marker:polygonmarker
  		});	
  		
     	google.maps.event.addListener(polygonmarker,'click', (function(polygonmarker,polygoncontent,polygoninfowindow){ 
    			return function() {
        			polygoninfowindow.setContent(polygoncontent);
        			polygoninfowindow.open(map,polygonmarker);
    			};
			})(polygonmarker,polygoncontent,polygoninfowindow)); 
			polygonmarker.setAnimation(google.maps.Animation.DROP); 
  			polygon.setMap(map);
  			polygonscheck[hubid]=polygon;
  			polygonmarkerscheck[hubid]=polygonmarker;
  			hubid++;
  			polygonCoords=[];
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
		var Customerarray = [];
        $.ajax({
           url: '<%=request.getContextPath()%>/IndentMasterDetails.do?param=getCustomer',
            success: function(response) {
                custList = JSON.parse(response);
                var output = '';
              /*  for (var i = 0; i < custList["customerRoot"].length; i++) {
                    $('#cust_names').append($("<option></option>").attr("value", custList["customerRoot"][i].CustId).text(custList["customerRoot"][i].CustName));
                }
               	$("#cust_names").select2();   */
				
				 for (var i = 0; i < custList["customerRoot"].length; i++) {
						Customerarray.push(custList["customerRoot"][i].CustName)
				}
				for (i = 0; i < Customerarray.length; i++) {
   			 		$('#cust_names').append($("<option></option>").attr("value", custList["customerRoot"][i].CustId).text(custList["customerRoot"][i].CustName))
	            }
				
	            $('#cust_names').multiselect({
	            nonSelectedText:'Select Customer',
 				includeSelectAllOption: true,
				enableFiltering: true,
				enableCaseInsensitiveFiltering: true,
 				 numberDisplayed: 1
 				});            
	           $("#cust_names").multiselect('selectAll', true);
  				$("#cust_names").multiselect('updateButtonText');
				
               	if(<%=tripPageCheck%> || <%=tripPageCheckMod%>){
			        $("#cust_names").val('<%=tripCustId%>').trigger('change');
			        $('.nav-tabs a[href="#' + 'mapViewId' + '"]').tab('show');
                    clearAllData();
			    }
			    if(<%=tripPageCheckMod%>){
			       viewRoute();
			    }
            }
        });
    }
     var leghubId=0;
     function createCombo(counterI,leg){
     	leghubId=legArray[legArray.length -1];
     	 var html =  '<div class="control-group input-group mydiv" style="margin-top:10px" >'+
          '<select onchange="getLegs('+counterI+')" name="addmore[]" class="form-control select2 checkpointC" id="leg'+counterI+'"'+'>'+
          '<option>Enter Leg '+counterI+'</option></select>'+
          '<div class="input-group-btn"><button title="Remove" class="btn btn-danger remove" style="margin-left: 10px; height: 29px; border-radius: 4px;" type="button" id="' + counterI + '"' + '><i class="glyphicon glyphicon-remove"></i></button>' +
		  '</div>';
		  $(".after-add-more").before(html);
		  $.ajax({
           url: '<%=request.getContextPath()%>/LegCreationAction.do?param=getLegNames',
           data:{
           	  hubId: leghubId,
           	  tripCustId: document.getElementById("cust_names").value
           },
            success: function(response) {
                hubList = JSON.parse(response);
                for (var i = 0; i < hubList["legRoot"].length; i++) {
                    $('#leg'+counterI).append($("<option></option>").attr("value", hubList["legRoot"][i].legId).attr("hubId", hubList["legRoot"][i].hubId)
                    .attr("TAT", hubList["legRoot"][i].TAT).attr("distance", hubList["legRoot"][i].distance).attr("detention", hubList["legRoot"][i].detention).text(hubList["legRoot"][i].legName));
                }
                $('#leg'+counterI).select2();
                if (leg > 0) {
                    $("#leg" + counterI).val(leg).trigger('change');
                }
            }
     	  });
     }
     var counter=0;
     var totalTAT=0;
     var dist=0;
      $(".add-more").click(function(){
     	  counter++;
          createCombo(counter);
          $('#checkAddBtn').hide();
          if(counter>1){
          	$('#'+(counter-1)).hide();
          }
      });
      $("body").on("click", ".remove", function(e) {
        $(this).parents(".control-group").remove();
        removeId = $(this).attr("id");
        counter--;
        sessionStorage.removeItem(removeId);
      
       for (var i = 0; i < checkPointMarkersArray.length; i++) {
		   checkPointMarkersArray[i].setMap(null);
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
          //  totalTAT=totalTAT + Number($('#leg' + (j+1) + ' option:selected').attr("TAT"))+Number(detention);
            totalTAT=totalTAT + Number($('#leg' + (j+1) + ' option:selected').attr("TAT"));
  	    	dist = dist+Number($('#leg' + (j+1) + ' option:selected').attr("distance"));
        }
       // alert("1:::::::: "+totalTAT+"---------"+Number($('#leg' + (j+1) + ' option:selected').attr("TAT"))+"------------"+Number(detention));
  		document.getElementById("TATId").value = convertMinutesToDDHHMM(Number(totalTAT *60000));
  		document.getElementById("distanceId").value = dist;
        getRouteLatlongs(legIds,currRouteId);
		legIds="";
		polylatlongs=[];
		myLatLngD="";
		myLatLngS="";
    });
    function getLegs(id){
        if(<%=tripPageCheckMod%>){
           $('#leg'+id).prop("disabled", true);
        }
      	legIDR=$('#leg' + id + ' option:selected').attr("value");
      	leghubId=$('#leg' + id + ' option:selected').attr("hubId");
      	legArray.push(leghubId);
      	sessionStorage.setItem(id, legIDR);
      	totalTAT=0;
      	dist=0;
      	for (var j = 0; j < sessionStorage.length; j++) {
      	 	detention=$('#leg' + (j+1) + ' option:selected').attr("detention");
	      	if(j==0){
	      		detention=0;
	      	}
           // totalTAT=totalTAT + Number($('#leg' + (j+1) + ' option:selected').attr("TAT"))+Number(detention);
            totalTAT=totalTAT + Number($('#leg' + (j+1) + ' option:selected').attr("TAT"));
  	    	dist = dist+Number($('#leg' + (j+1) + ' option:selected').attr("distance"));
        }
        legTAT = totalTAT;
       // alert("2:::::::::: "+totalTAT+"---------"+Number($('#leg' + (j+1) + ' option:selected').attr("TAT"))+"------------"+Number(detention));
  		document.getElementById("TATId").value = convertMinutesToDDHHMM(Number(totalTAT*60000));
  		document.getElementById("distanceId").value = dist.toFixed(2);
  		if(buttonValue!="modify"){
  			getRouteLatlongs("");
			legIds="";
			polylatlongs=[];
			myLatLngD="";
			myLatLngS="";
  		}
  		if(id>0){
  		  $('#checkAddBtn').show();
  		}
      }
	 function getRouteLatlongs(legIds,currRouteId){
	 	for (var p = 0,leng = srcDestMarkers.length ; p < leng ; p++){
	        var currMar3 = srcDestMarkers[p];
		      currMar3.setMap(null);
        } 
		 google.maps.event.trigger(map, 'resize');
	 		detentionCheckPointsArray = [];
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
							createSDMarker(myLatLngS, results["routelatlongRoot"][i].hubAddress,111);
						}
						if(results["routelatlongRoot"][i].type=='DESTINATION'){
							myLatLngD= new google.maps.LatLng(results["routelatlongRoot"][i].lat, results["routelatlongRoot"][i].lon);
							createSDMarker(myLatLngD, results["routelatlongRoot"][i].hubAddress,999);
						}
						if(results["routelatlongRoot"][i].type=='CHECKPOINT'){
							 polylatlongs.push({
					               location: new google.maps.LatLng(results["routelatlongRoot"][i].lat, results["routelatlongRoot"][i].lon),
					               stopover: true
					          });
					          myLatLngC = new google.maps.LatLng(results["routelatlongRoot"][i].lat, results["routelatlongRoot"][i].lon);
					          createSDMarker(myLatLngC, results["routelatlongRoot"][i].hubAddress,results["routelatlongRoot"][i].hubId);
						}
						if(results["routelatlongRoot"][i].type=='DRAGPOINT'){
						 polylatlongs.push({
					               location: new google.maps.LatLng(results["routelatlongRoot"][i].lat, results["routelatlongRoot"][i].lon),
					               stopover: false
					          });
						}
					}
					plotRoute();
					plotCheckPoints(completeRoutePath);
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
        	suppressMarkers: true,
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
    var tripCountC=0;
    function saveRouteDetails(){
   		var customerName=document.getElementById("cust_names").value;
    	var routeName=document.getElementById("routeNameId").value;
    	var distance=document.getElementById("distanceId").value;
    	var TAT=document.getElementById("TATId").value;
    	var routeKey=document.getElementById("routeKeyId").value;
    	var routeRadius = document.getElementById("routeRadiusId").value;
    	
    	//if(tripCountC > 0){
        //    swal("Trip is created for this route.Can not Modify/Deactivate");
        //    return;
        //}
    	 if (customerName == "") {
            sweetAlert("Please select customer");
            return;
        }
        if(sessionStorage.length==0){
   			sweetAlert("Please Select atleast one Leg");
           	return;
   		}
        if (routeName == "") {
            sweetAlert("Please enter Route Name");
            return;
        }
        if (distance == "") {
            sweetAlert("Please Enter Distance");
            return;
        }
        if (routeKey == "") {
            sweetAlert("Please Enter Route Key");
            return;
        }
        if (TAT == "") {
            sweetAlert("Please Enter TAT");
            return;
        }
        if (routeRadius == "") {
            sweetAlert("Please Enter Route Radius");
            return;
        }
        var legPointArray = [];
        
		var detentionCheckPointValues = JSON.stringify(detentionCheckPointsArray);

        for (var j = 0; j < sessionStorage.length; j++) {
            legID = sessionStorage.getItem(j + 1);
            legPointArray.push('{' + (j + 1) + ',' + legID + '}')
        }
        var legPointData = JSON.stringify(legPointArray);
    	var params={
    		tripCustId: customerName,
    		routeName: routeName,
    		distance: distance,
    		routeKey: routeKey,
    		TAT: TAT,
    		legPointData : legPointData,
    		routeModId :routeUniqId,
    		statusA: statusA,
    		routeRadius :routeRadius,
    		detentionCheckPointsArray :detentionCheckPointValues
    	};
    	//$("#mapViewId").mask();
    	$.ajax({
            url: '<%=request.getContextPath()%>/LegCreationAction.do?param=saveRouteDetails',
            data: params,
            success: function(result) {
                if (result == "Saved Successfully") {
                   sweetAlert("Saved Successfully");
                    setTimeout(function() {
                        clearAllData();
                      
                    }, 1000);
                } else {
                    sweetAlert(result);
                    clearAllData();
                }
            }
        });
        //$("#mapViewId").unmask();
        goBack();
       // summaryTable.ajax.reload();
        loadData();
    }
    function clearAllData(){
    	polylatlongs=[];
    	legPointArray=[];
        counter=0;
        sessionStorage.clear();
        document.getElementById("distanceId").value = "";
        document.getElementById("TATId").value = "";
        for (var i = 0; i < circleArray.length; i++) {
           circleArray[i].setMap(null);
        }
        for (var i = 0; i < polygonCoords.length; i++) {
		   polygonCoords[i].setMap(null);
		}
		for (var i = 0; i < directionDisplayArr.length; i++) {
		   directionDisplayArr[i].setMap(null);
		}
		for (var i = 0,arr=checkPointMarkersArray.length; i < arr; i++) {
		   checkPointMarkersArray[i].setMap(null);
		}
		$(".control-group").remove();
		legIds="";
		leghubId=0;
		totalTAT=0;
		myLatLngD="";
		myLatLngS="";
		document.getElementById("dialogBoxId").innerHTML = "";
		legArray=[];
		document.getElementById("routeNameId").value = "";
        document.getElementById("routeKeyId").value = "";
        document.getElementById("routeRadiusId").value = "";
        routeUniqId=0;
        $('#backButtonId1').hide();
        tripCountC=0;
        detentionCheckPointsArray = [];
		currRouteId = "";
		 for (var p = 0,leng = srcDestMarkers.length ; p < leng ; p++){
	        var currMar3 = srcDestMarkers[p];
		      currMar3.setMap(null);
        } 
	   
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
    function modifyRoute(routeId,routeName,routeKey,distance,TAT,status,routeRadius,tripCount) {
        routeIdPdf=routeId;
		currRouteId = routeId;
    	buttonValue="modify";
        setValuesForMod(routeId,routeName,routeKey,distance,TAT,status,routeRadius,tripCount);
        $('#viewBtn').hide();
        $('#clearId').hide();
        $('#backButtonId1').show();
        $('#addId').hide();
    }
    function setValuesForMod(routeId,routeName,routeKey,distance,TAT,status,routeRadius,tripCount){
		uniqueId = routeId;
    	changeTab('mapViewId');
    	getlegIds(routeId);
        routeUniqId = routeId;
        tripCountC=tripCount;   
        document.getElementById("routeNameId").value = routeName.replace("-"," ");
        document.getElementById("distanceId").value = distance;
        document.getElementById("routeKeyId").value = routeKey.replace("-"," ");
        document.getElementById("TATId").value = TAT;
        document.getElementById("routeRadiusId").value = routeRadius;
        statusA=status;
        setTimeout(function(){ buttonValue="add"; }, 2000);
    }
    function updateStatus(routeId,routeName,routeKey,distance,TAT,status,routeRadius,tripCount){
       // if(tripCount > 0){
       //     swal("Trip is Created for this route.Can not Inactivate");
       //     return;
       // }
    	swal({
		  title: "Are you sure you want to Inactive the Route?",
		  type: "warning",
		  showCancelButton: true,
		  confirmButtonClass: "btn-danger",
		  confirmButtonText: "Yes, Inative it!",
		  closeOnConfirm: false
		},
		function(){
		  $.ajax({
              url: '<%=request.getContextPath()%>/LegCreationAction.do?param=updateStatusForRoute',
              data: {
                  uniqueId: routeId
              },
              success: function(result) {
                 swal("Record has been updated", "");
                 summaryTable.ajax.reload();
              }
          })
		});
    }
    function goBack(){
        if(<%=tripPageCheck%> || <%=tripPageCheckMod%>){
            window.location = "<%=request.getContextPath()%>/Jsps/GeneralVertical/CreateTrip.jsp?pageId=route";
        }else{
            changeTab('summaryId');
	        clearAllData();
	        $('#viewBtn').show();
	        $('#addId').show();
	        $('#summaryId').show();
	       summaryTable.ajax.reload();
        }
      
    }
    function getlegIds(routeId){
    	 LegList="";
    	 var j=0;
    	 $.ajax({
           url: '<%=request.getContextPath()%>/LegCreationAction.do?param=getLegList',
           data:{
           	 routeId: routeId
           },
            success: function(response) {
                legList = JSON.parse(response);
                for (var i = 0; i < legList["legListRoot"].length; i++) {
                    j++;
                    sessionStorage.setItem(j, legList["legListRoot"][i].legId);
                    createCombo(j,legList["legListRoot"][i].legId);
                }
                getRouteLatlongs("",routeId);
                counter = j;
            }
     	  });
    }
    function viewRoute(){
        getlegIds('<%=routeId%>');
        $("#routeNameId").prop("disabled", true);
        $("#distanceId").prop("disabled", true);
        $("#routeKeyId").prop("disabled", true);
        $("#TATId").prop("disabled", true);
        $("#routeRadiusId").prop("disabled", true);
        $('#viewBtn').hide();
        $('#clearId').hide();
        $('#backButtonId1').hide();
        $('#addId').hide();
        $('#saveId').hide();
        $('.add-more').hide();
        
        $.ajax({
           url: '<%=request.getContextPath()%>/LegCreationAction.do?param=getRouteDetails',
           data:{
             routeId: '<%=routeId%>'
           },
            success: function(response) {
                routeList = JSON.parse(response);
                document.getElementById("routeNameId").value = routeList["routeListRoot"][0].routeName;
		        document.getElementById("routeRadiusId").value = routeList["routeListRoot"][0].routeRad;
		        document.getElementById("routeKeyId").value = routeList["routeListRoot"][0].routeKey;
            }
          });
        setTimeout(function(){ buttonValue="add"; }, 2000);
    }
     function saveInfoWindowDetails() {
     
              var  hubId1= document.getElementById("hubIdOfWindow").value;
              var  legId1= document.getElementById("legIdOfWindow").value;
              var  detention1= document.getElementById("detentionOfWindow").value;
              var datePattern = /^\d{2}:[0-5]\d$/  // /^([01]\d|2[0-3]):?([0-5]\d)$/;
	           if(!datePattern.test(document.getElementById("detentionOfWindow").value)){
	           	   sweetAlert("Enter detention time as HH:mm format");
	               return;
	           }
              detentionCheckPointsArray.forEach(function (detchkpt){
				  var detchkpt2 = detchkpt;
				  var  detchkpt1=  detchkpt.replace('{','').replace('}','').split(',');
                   if((detchkpt1[0] == legId1) && (detchkpt1[1] == hubId1)){
                     detchkpt1[2] = detention1;
				  	 var indexValue = detentionCheckPointsArray.indexOf(detchkpt2);
			       	 detentionCheckPointsArray.splice(indexValue, 1);
			   		 detentionCheckPointsArray.push('{' + detchkpt1[0] + ',' + detchkpt1[1] + ',' + detention1 + '}');
			   
			    		for (var i = 0; i < completeRoutePath["routelatlongRoot"].length; i++) {
			    			if( completeRoutePath["routelatlongRoot"][i].hubId == hubId1){
			      			completeRoutePath["routelatlongRoot"][i].detention = detention1;
			     			}
			    		}
				
               	  }
				  plotCheckPoints(completeRoutePath);
				  		  
              });
                    
      }
      
      function cancelInfo() {
      
       setTimeout(function() {
            checkPointInfoWindowsArray.forEach(function (infowindow){
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
    
      				 
	 function plotCheckPoints(completeRoutePath){
	 	 if(checkPointMarkersArray.length >0){
	 	 for (var i = 0,arr=checkPointMarkersArray.length; i < arr; i++) {
		   checkPointMarkersArray[i].setMap(null);
		 }
		}
	 	 
		 detentionCheckPointsArray = [];
		 checkPointMarkersArray = [];
		 var totalDetention = 0;
		 var newLegTAT = 0;
		 for (var i = 0; i < completeRoutePath["routelatlongRoot"].length; i++) {
		 if(completeRoutePath["routelatlongRoot"][i].type=='CHECKPOINT'){
							
         // detention code
         var detentionForWindow = completeRoutePath["routelatlongRoot"][i].detention;
         var hubIdForWindow = completeRoutePath["routelatlongRoot"][i].hubId;
         var legIdForWindow = completeRoutePath["routelatlongRoot"][i].legId;
	     var latLong=new google.maps.LatLng(completeRoutePath["routelatlongRoot"][i].lat, completeRoutePath["routelatlongRoot"][i].lon);
											
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
								        	
								        	checkPointMarkersArray.push(detentionmarker);
								        	var detentioncontent = ' <div style="width: 200px;height : 50px"> ' +
    									        	 ' <input type="text" id="hubIdOfWindow" value="'+hubIdForWindow+'" style="display: none;" /> ' +
										        	 ' <input type="text" id="legIdOfWindow" value="'+legIdForWindow+'" style="display: none;" /> ' +
						                            ' <span>Hub Detention (HH:mm)</span> ' +
						                            ' <input type="text" id="detentionOfWindow" value="'+detentionForWindow+'" maxlength = 5 style="width: 50px;margin-bottom: 6px;margin-left: 10px;" onkeypress="return onlyNumbersWithColon(event);"/><br> ' +
						                            ' <input type="button"  value="Save" id="saveInfo" onclick="saveInfoWindowDetails()" style="margin-top: 15px;margin-left : 90px;"  />' +
						                      //      ' <input type="button"  value="Cancel" id="cancelInfo" onclick="cancelInfo()" style="margin-left: 70px;margin-top: 15px;" />' +
						                            ' </div> ';
												detentioninfowindow = new google.maps.InfoWindow({
								      			content:detentioncontent,
								      			marker:detentionmarker
											
												});
												
												google.maps.event.addListener(detentionmarker,'click', (function(detentionmarker,detentioncontent,detentioninfowindow){ 
					    			return function() {
					        			detentioninfowindow.setContent(detentioncontent);
					        			detentioninfowindow.open(map,detentionmarker);
					    			};
								})(detentionmarker,detentioncontent,detentioninfowindow)); 
								//detentionmarker.setAnimation(google.maps.Animation.DROP); 
								
								checkPointInfoWindowsArray.push(detentioninfowindow);
								
								// detention code ends
								var deten = detentionForWindow.split(":");
								var newdeten = parseInt(deten[0] > 0 ? (deten[0]*60) : 0) + parseInt(deten[1]);
								totalDetention = parseInt(totalDetention)+parseInt(newdeten);
								
								detentionCheckPointsArray.push('{' + legIdForWindow + ',' + hubIdForWindow + ',' + detentionForWindow + '}');
						  }
						}	
						newLegTAT =  parseInt(legTAT) + parseInt(totalDetention);
						var tathhmm = convertMinutesToDDHHMM(Number(newLegTAT *60000));
						document.getElementById("TATId").value = tathhmm;//convertMinutesToDDHHMM(Number(totalTAT));
						cancelInfo();					
      				 }
      				 
      				 
      	function createSDMarker(latlng, title,ID) {
	        for (var k = 0,leng = srcDestMarkers.length ; k < leng ; k++){
		        var currMar = srcDestMarkers[k];
			        if (ID == currMar.id){
			        	currMar.setMap(null);
			        }
	        }    
				var infowindow = new google.maps.InfoWindow();
				var orangeMarker = '/ApplicationImages/VehicleImages/orangeBalloon.png';
				var greenMarker = '/ApplicationImages/VehicleImages/lightGreenBalloon.png';
				var blueMarker = '/ApplicationImages/VehicleImages/blueBalloonNew.png';
				if (ID == 111){
				img = {
		                url: greenMarker, // Source.
		            };
				}else if (ID == 999){
				img = {
		                url: orangeMarker, // Checkpoint.
		            };
				}else{
				img = {
		                url: blueMarker, // Checkpoint.
		            };
				}
				  console.log(" img : "+img.url);
				   console.log(" latlng : "+ latlng);
			    var marker = new google.maps.Marker({
			        position: latlng,
			        title: title,
			        map: map,
			        icon : img,
			        id: ID,
			    });
				srcDestMarkers.push(marker);
				console.log(" MArkers : "+srcDestMarkers.length);
			    google.maps.event.addListener(marker, 'click', function () {
			        infowindow.setContent(title);
			        infowindow.open(map, marker);
			    });
	}
    
</script>
  <jsp:include page="../Common/footer.jsp" />
		<!-- </body>   -->
	<!-- </html> -->