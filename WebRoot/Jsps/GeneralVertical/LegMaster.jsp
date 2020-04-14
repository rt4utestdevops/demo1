<%@ page language="java"
	import="java.util.*,t4u.functions.CommonFunctions,t4u.beans.*,t4u.common.*"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://packtag.sf.net" prefix="pack"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
	
	Properties properties = ApplicationListener.prop;
 	String GoogleApiKey = properties.getProperty("GoogleMapApiKeyen").trim();
	
	CommonFunctions cf = new CommonFunctions();
	LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
	if(loginInfo != null){}else{response.sendRedirect(request.getContextPath()+ "/Jsps/Common/SessionDestroy.html");}
%>
	<!--<!doctype html>-->
	<!--<html lang="en">-->
	<!--   <head>-->
	<!--      <title> Leg Master</title>-->
	<!--      <meta charset="utf-8">-->
	<!--      <meta name="viewport" content="width=device-width, initial-scale=1">-->
	 <jsp:include page="../Common/header.jsp" /><link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
      <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-multiselect/0.9.13/css/bootstrap-multiselect.css">
      <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/sweetalert/0.4.2/sweet-alert.min.css" />
<!--      <link rel="stylesheet" href="../../Main/sweetAlert/sweetalert.css">-->
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
<!--      <script src="../../Main/sweetAlert/sweetalert.min.js"></script>-->
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
	   
	  <link rel="stylesheet" href="https://netdna.bootstrapcdn.com/bootstrap/3.3.2/css/bootstrap.min.css">
 
	   		  
      <pack:script src="../../Main/adapter/ext/ext-base.js"></pack:script>
	  <pack:script src="../../Main/Js/ext-all-debug.js"></pack:script>
	  <pack:script src="../../Main/Js/Common.js"></pack:script>
      <pack:script src="../../Main/Js/MsgBox.js"></pack:script>
      <pack:script src="../../Main/Js/examples1.js"></pack:script>
      
      <script src="https://cdnjs.cloudflare.com/ajax/libs/sweetalert/0.4.2/sweet-alert.min.js"></script>
      <pack:script src="../../Main/Js/jQueryMask.js"></pack:script>
      <pack:style src="../../Main/modules/common/jquery.loadmask.css" />
	  
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
		  //  opacity: 0;
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
			width: 261px !important;
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
    		max-height: 300px !important;
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
		     /*width: 200px; */
		     width: 305px;
		     /*height: 120px !important;  */
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
                  Leg Creation
               </h3>
            </div>
            <div class="panel-body" style="padding-top: 0px;">         			   
			   <div class="panel row" style="padding:1% ;margin: 0%;border: 0px dotted !important">
					<label for="staticEmail2" class="col-lg-1 col-md-1 col-sm-12" style="margin-left: 10px;">Customer:</label>
					<div class="col-lg-3 ">
						<select class="form-control" multiple="multiple" id="cust_names"  onchange="selectCustomers();">
						</select>
					</div>
					<div class="col-xs-12 col-md-1 col-sm-12">
						<div>
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
                  <ul class="nav nav-tabs"  style="display: table-cell;">
                     <li><a href="#summaryId" data-toggle="tab" onclick="$('#summaryId').addClass('show');$('#viewBtn').show(); $('#addId').show();" active>Leg Details</a></li>
                      <!-- <li class="disabled"><a href="#mapViewId">Leg Creation</a></li>  --> 
                     <li><a href="#mapViewId" data-toggle="tab1" onclick="changeLegCreationTab('mapViewId')">Leg Creation</a></li> 
                  </ul>
               </div>
               <div class="tab-content" id="tabs">
                  <div class="tab-pane" id="summaryId">
                     <table id="summaryTable" class="table table-striped table-bordered" cellspacing="0" width="100%" style="margin-top:1%">
                        <thead>
                           <tr>
                              <th>Sl No</th>
                              <th>Cust Name</th>
                              <th>Leg Name</th>
                              <th>Source</th>
                              <th>Destination</th>
                              <th>Average Speed(Km/h)</th>
                              <th>Distance(Km)</th>
                              <th>TAT(HH:mm)</th>
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
                              <label class="col-lg-3 col-md-3 col-form-label form-control-label">Source</label>
                              <div class="col-lg-9 col-md-9">
                                 <select id="sourceId" class="form-control js-example-basic-single select2" style="width: 347px;">
                                    <option value="">-- Select --</option>                                    
                                 </select>
                              </div>
                           </div>
                           <div class="form-group row">
                              <label class="col-lg-3 col-md-3 col-form-label form-control-label">Destination</label>
                              <div class="col-lg-9 col-md-9">
                                 <select id="destinationId" class="form-control js-example-basic-single select2" style="width: 347px;">
                                    <option value="">-- Select --</option>
                                 </select>
                              </div>
                           </div>
                           <div class="form-group row">
                              <label class="col-lg-3 col-md-3 col-form-label form-control-label">CheckPoint</label>
                              <div class="col-lg-9 col-md-9">
                                 <div class="input-group after-add-more">
                                    <div class="input-group-btn"> 
                                       <button id="checkAddBtn" style="margin-top:4px; border-radius: 4px;" class="btn btn-primary add-more" type="button"><i class="glyphicon glyphicon-plus"></i>Click to add checkpoint</button>
                                    </div>
                                 </div>
                              </div>
                           </div>
                            <div class="form-group row">
                              <label class="col-lg-3 col-md-3 col-form-label form-control-label">Leg Name</label>
                              <div class="col-lg-9 col-md-9">
                                 <input class="form-control" type="text" value="" id="legNameId" onkeypress="return checkSpcialChar(event)">
                              </div>
                           </div>
                           <div class="form-group row">
                              <label class="col-lg-3 col-md-3 col-form-label form-control-label">Distance(Km)</label>
                              <div class="col-lg-9 col-md-9">
                                 <input class="form-control" type="number" value="" id="distanceId" readonly min="1">
                              </div>
                           </div>
                           <div class="form-group row">
                              <label class="col-lg-3 col-md-3 col-form-label form-control-label">Average Speed(Km/h)</label>
                              <div class="col-lg-9 col-md-9">
                                 <input class="form-control" type="number" value="" id="avgSpeedId" min="1" max ="99" onkeypress='return event.charCode >= 48 && event.charCode <= 57' disabled > 
                              </div>
                           </div>
                           <div class="form-group row">
                              <label class="col-lg-3 col-md-3 col-form-label form-control-label">TAT(HH:mm)</label>
                              <div class="col-lg-9 col-md-9" >
                                 <input class="form-control" type="text" value="" id="TATId" onkeypress="return onlyNumbersWithColon(event);">
                                 
                              </div>
                           </div>
                           <div class="form-group row">
                              <label class="col-lg-3 col-md-3 col-form-label form-control-label"></label>
                              <div class="col-lg-9 col-md-9">
                                 <input style="height: 35px;margin-left: 0%;"id="saveBtn" type="button" class="btn btn-success" value="Save Changes" onclick="saveLegDetails(true);">
                                 <input style="margin-left: 50%;" type="button" class="btn btn-primary" value="Go Back" onclick="goBack();">
                              </div>
                           </div>
                           <div class="form-group row">
                              <label class="col-lg-3 col-md-3 col-form-label form-control-label"></label>
                              <div class="col-lg-9 col-md-9">
                                 <input type="button" class="btn btn-danger" value="Clear All" onclick="resetAllData();" style=" margin-top: 16px;">
                              </div>
                           </div>
                        </form>
                     </div>
                     <div class="col-md-7">
                        <div id="dvMap" style="width: 800px; height: 417px; margin-top: 8px; border: 1px solid gray;"></div>
                        <div class="inline row" style="margin-left: 2px;margin-top: 7px;  display: -webkit-box;"> 
                           <label class="container checkbox-inline col-md-6" style="padding-left: 41px; font-weight: 400;">Show Customer/Smart Hubs
                           <input type="checkbox" id="smartHub">
                           <span class="checkmark"></span>
                           </label>
                           <label class="container checkbox-inline col-md-6" style="padding-left: 41px; font-weight: 400;margin-left: -60%;">Show Checkpoints
                           <input type="checkbox" id="checkPoint">
                           <span class="checkmark"></span>
                           </label>
                        </div>
                        <div>
                        	<h5 id="dialogBoxId" style="color:red;"></h5>
                        </div>
                     </div>
                  </div>
               </div>
            </div>
         </div>
      </div>
   </div>
      
<script src='<%=GoogleApiKey%>'></script>
</script>
<script>
 window.onload = function () { 
			getCustomerName();
		}
    var custId;
    var summaryTable;
    var customerName;
    var sourceId;
    var destinationId;
    var sLat;
    var sLon;
    var dLat;
    var dLon;
    var circleArray = [];
    var polygonCoords = [];
    var directionsDisplay;
    var jsonArray = [];
    var dragPointArray = [];
    var myLatLngS;
    var myLatLngD;
    var sHub;
    var dHub;
    var legUniqId;
    var polygons = [];
    var buffermarkersmart = [];
    var circlessmart = [];
    var polygonsmart = [];
    var polygonmarkersmart = [];
    var buffermarkerscheck = [];
    var circlescheck = [];
    var polygonscheck = [];
    var polygonmarkerscheck = [];
    var statusA ="";
    var addCheck=false;
    var maxCheck=0;
    var maxDrag=0;
     var uniqueId;
    sessionStorage.clear();
    localStorage.clear();
    var srcDestMarkers = [];
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
        function selectCustomers() {		
			loadData();			
		}
		
        $('#cust_names').change(function () {	

				document.getElementById("addId").disabled = false;
        		$("#mapViewId").find("*").prop("disabled", false); 
        		document.getElementById("mapViewId").disabled = false; 				
        		getSourceAndDestination();
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
				return;
			}				
	}); 
    
	$('#avgSpeedId').change(function () {
		dis= Number($('#distanceId').val());
		avg=Number($('#avgSpeedId').val());
		value = dis / avg;
		value = value*60;		
	    document.getElementById("TATId").value = convertMinutesToHHMM(value.toFixed());	 
	});
	$('#TATId').change(function () {
		dis= Number($('#distanceId').val());						
		var time1 = ($('#TATId').val()).split(":");
		var time2 = (parseInt(time1 [0] * 60)+parseInt(time1 [1]));
		tat = time2;
		value = dis / tat;
		value = value*60;			
	    document.getElementById("avgSpeedId").value = (value.toFixed(2));
	});
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
	
	  function changeLegCreationTab(tab1) {
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
	  	//summaryTable.ajax.reload();
	  }
	});

    
     function checkSpcialChar(event){
     
        //var regex = new RegExp("^[0-9a-zA-Z \b]+$");
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

    function getCustomerName() {
    var Customerarray = [];
        $.ajax({
            url: '<%=request.getContextPath()%>/IndentMasterDetails.do?param=getCustomer',
            success: function(response) {
                custList = JSON.parse(response);
             /*   var output = '';
                for (var i = 0; i < custList["customerRoot"].length; i++) {
                    $('#cust_names').append($("<option></option>").attr("value", custList["customerRoot"][i].CustId).text(custList["customerRoot"][i].CustName));
                }
                $("#cust_names").select2();  */
                
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
            }
        });
        getSourceAndDestination();
    }

    function loadData() {
		
		var custNamesId;
		var custcombo = "";       
        var custselected =$("#cust_names option:selected");
        
        custselected.each(function () {
            custcombo += $(this).val() + ",";
        });
		
		var combo= custcombo.split(",").join(",");
	
		var param = {
			custNamesId:combo                 
		};
		var custselected =$("#cust_names option:selected");
        
		$('#summaryId').addClass("show");
        if (document.getElementById("cust_names").value == "") {
            sweetAlert("Please select atleast one customer");
            return;
        } else {
      
            summaryTable = $('#summaryTable').DataTable({
            	"scrollX": true,
                "ajax": {
                    "url": "<%=request.getContextPath()%>/LegCreationAction.do?param=getLegMasterDetails",
                    "dataSrc": "LegDataRoot",
                    "data": {
                        tripCustId: combo//document.getElementById("customerList").value;
                    }
                },
                "oLanguage": {
                    "sEmptyTable": "No data available"
                },
                "bDestroy": true,
                "responsive": true,
                "dom": 'Bfrtip',
									
                "buttons": [{
                        extend: 'pageLength'
                    },
                    {
                        extend: 'excel',
                        text: 'Export to Excel',
                        className: 'btn btn-primary',
                        exportOptions: {
                            columns: [0, 1, 2, 3, 4, 5, 6, 7, 8]
                        }
                    }
                ],
                columnDefs: [{
                        width: 30,
                        targets: 0
                    },
                    {
                        width: 100,
                        targets: 1
                    },
                    {
                        width: 200,
                        targets: 2
                    },
                    {
                        width: 200,
                        targets: 3
                    },
                    {
                        width: 50,
                        targets: 4
                    },
                    {
                        width: 50,
                        targets: 5
                    },
                    {
                        width: 50,
                        targets: 6
                    },
                    {
                        width: 50,
                        targets: 7
                    },
                    {
                        width: 50,
                        targets: 8
                    }
                ],
                "columns": [{
                    "data": "slNoIndex"
                }, {
                    "data": "custNameIndex"
                }, {
                    "data": "legNameIndex"
                }, {
                    "data": "sourceIndex"
                }, {
                    "data": "destinationIndex"
                }, {
                    "data": "avgSpeedIndex"
                }, {
                    "data": "distanceIndex"
                }, {
                    "data": "TATIndex"
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
    var bufferStoreSmartHub = new Ext.data.JsonStore({
        url: '<%=request.getContextPath()%>/LegCreationAction.do?param=getSmartHubBuffer',
        id: 'BufferMapView',
        root: 'BufferMapView',
        autoLoad: false,
        remoteSort: true,
        fields: ['longitude', 'latitude', 'buffername', 'radius', 'imagename']
    });
    var polygonStoreSmartHub = new Ext.data.JsonStore({
        url: '<%=request.getContextPath()%>/LegCreationAction.do?param=getSmartHubPolygon',
        id: 'PolygonMapView',
        root: 'PolygonMapView',
        autoLoad: false,
        remoteSort: true,
        fields: ['longitude', 'latitude', 'polygonname', 'sequence', 'hubid']
    });
    var bufferStoreCheckPoint = new Ext.data.JsonStore({
        url: '<%=request.getContextPath()%>/LegCreationAction.do?param=getcheckpointBuffer',
        id: 'BufferMapView',
        root: 'BufferMapView1',
        autoLoad: false,
        remoteSort: true,
        fields: ['longitude', 'latitude', 'buffername', 'radius', 'imagename']
    });
    var polygonStoreCheckPoint = new Ext.data.JsonStore({
        url: '<%=request.getContextPath()%>/LegCreationAction.do?param=getcheckpointPolygon',
        id: 'PolygonMapView',
        root: 'PolygonMapView1',
        autoLoad: false,
        remoteSort: true,
        fields: ['longitude', 'latitude', 'polygonname', 'sequence', 'hubid']
    });
    
    var polygonStoreForModify=new Ext.data.JsonStore({
		url: '<%=request.getContextPath()%>/createLandmarkAction.do?param=getPolygon',
		id:'PolygonModifyId',
		root: 'PolygonModify',
		autoLoad: false,
		remoteSort: true,
		fields: ['longitude','latitude','sequence','hubid']
	});

    function plotBuffersForSmartHub() {
        for (var i = 0; i < bufferStoreSmartHub.getCount(); i++) {
            var rec = bufferStoreSmartHub.getAt(i);
            var urlForZero = '/ApplicationImages/VehicleImages/red.png';
            var convertRadiusToMeters = rec.data['radius'] * 1000;
            var myLatLng = new google.maps.LatLng(rec.data['latitude'], rec.data['longitude']);
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
                id: rec.data['vehicleNo'],
                map: map,
                icon: bufferimage
            });
            buffercontent = rec.data['buffername'];
            bufferinfowindow = new google.maps.InfoWindow({
                content: buffercontent,
                id: rec.data['vehicleNo'],
                marker: buffermarker
            });

            google.maps.event.addListener(buffermarker, 'click', (function(buffermarker, buffercontent, bufferinfowindow) {
                return function() {
                    bufferinfowindow.setContent(buffercontent);
                    bufferinfowindow.open(map, buffermarker);
                };
            })(buffermarker, buffercontent, bufferinfowindow));
            buffermarker.setAnimation(google.maps.Animation.DROP);

            buffermarkersmart[i] = buffermarker;
            circlessmart[i] = new google.maps.Circle(createCircle);
        }
    }

    function plotPolygonSmartHub() {
        var hubid = 0;
        var polygonCoords = [];
        for (var i = 0; i < polygonStoreSmartHub.getCount(); i++) {
            var rec = polygonStoreSmartHub.getAt(i);
            if (i != polygonStoreSmartHub.getCount() - 1 && rec.data['hubid'] == polygonStoreSmartHub.getAt(i + 1).data['hubid']) {
                var latLong = new google.maps.LatLng(rec.data['latitude'], rec.data['longitude']);
                polygonCoords.push(latLong);
                continue;
            } else {
                var latLong = new google.maps.LatLng(rec.data['latitude'], rec.data['longitude']);
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
                position: latLong,
                map: map,
                icon: polygonimage
            });
            var polygoncontent = rec.data['polygonname'];
            polygoninfowindow = new google.maps.InfoWindow({
                content: polygoncontent,
                marker: polygonmarker
            });
            google.maps.event.addListener(polygonmarker, 'click', (function(polygonmarker, polygoncontent, polygoninfowindow) {
                return function() {
                    polygoninfowindow.setContent(polygoncontent);
                    polygoninfowindow.open(map, polygonmarker);
                };
            })(polygonmarker, polygoncontent, polygoninfowindow));
            polygonmarker.setAnimation(google.maps.Animation.DROP);
            polygon.setMap(map);
            polygonsmart[hubid] = polygon;
            polygonmarkersmart[hubid] = polygonmarker;
            hubid++;
            polygonCoords = [];
        }
    }


    function plotBuffersForCheckPoint() {
        for (var i = 0; i < bufferStoreCheckPoint.getCount(); i++) {
            var rec = bufferStoreCheckPoint.getAt(i);
            var urlForZero = '/ApplicationImages/VehicleImages/green.png';
            var convertRadiusToMeters = rec.data['radius'] * 1000;
            var myLatLng = new google.maps.LatLng(rec.data['latitude'], rec.data['longitude']);
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
                id: rec.data['vehicleNo'],
                map: map,
                icon: bufferimage
            });
            buffercontent = rec.data['buffername'];
            bufferinfowindow = new google.maps.InfoWindow({
                content: buffercontent,
                id: rec.data['vehicleNo'],
                marker: buffermarker
            });
            google.maps.event.addListener(buffermarker, 'click', (function(buffermarker, buffercontent, bufferinfowindow) {
                return function() {
                    bufferinfowindow.setContent(buffercontent);
                    bufferinfowindow.open(map, buffermarker);
                };
            })(buffermarker, buffercontent, bufferinfowindow));
            buffermarker.setAnimation(google.maps.Animation.DROP);

            buffermarkerscheck[i] = buffermarker;
            circlescheck[i] = new google.maps.Circle(createCircle);
        }
    }

    function plotPolygonCheckPoint() {
        var hubid = 0;
        var polygonCoords = [];
        for (var i = 0; i < polygonStoreCheckPoint.getCount(); i++) {
            var rec = polygonStoreCheckPoint.getAt(i);
            if (i != polygonStoreCheckPoint.getCount() - 1 && rec.data['hubid'] == polygonStoreCheckPoint.getAt(i + 1).data['hubid']) {
                var latLong = new google.maps.LatLng(rec.data['latitude'], rec.data['longitude']);
                polygonCoords.push(latLong);
                continue;
            } else {
                var latLong = new google.maps.LatLng(rec.data['latitude'], rec.data['longitude']);
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
                position: latLong,
                map: map,
                icon: polygonimage
            });
            var polygoncontent = rec.data['polygonname'];
            polygoninfowindow = new google.maps.InfoWindow({
                content: polygoncontent,
                marker: polygonmarker
            });
            google.maps.event.addListener(polygonmarker, 'click', (function(polygonmarker, polygoncontent, polygoninfowindow) {
                return function() {
                    polygoninfowindow.setContent(polygoncontent);
                    polygoninfowindow.open(map, polygonmarker);
                };
            })(polygonmarker, polygoncontent, polygoninfowindow));
            polygonmarker.setAnimation(google.maps.Animation.DROP);
            polygon.setMap(map);
            polygonscheck[hubid] = polygon;
            polygonmarkerscheck[hubid] = polygonmarker;
            hubid++;
            polygonCoords = [];
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


	
    function getSourceAndDestination(sHub,dHub) {
        $.ajax({
            url: '<%=request.getContextPath()%>/LegCreationAction.do?param=getSourceAndDestination',
            data:{
            	tripCustId: document.getElementById("cust_names").value
            },
            success: function(response) {
            	$("#sourceId").select2().empty();
                $("#destinationId").select2().empty();
                hubList = JSON.parse(response);
                for (var i = 0; i < hubList["sourceRoot"].length; i++) {
                    $('#sourceId').append($("<option></option>").attr("value", hubList["sourceRoot"][i].Hub_Id).attr("latitude", hubList["sourceRoot"][i].latitude)
                        .attr("longitude", hubList["sourceRoot"][i].longitude).attr("radius", hubList["sourceRoot"][i].radius).attr("detention", hubList["sourceRoot"][i].detention).attr("hubAddress", hubList["sourceRoot"][i].hubAddress).text(hubList["sourceRoot"][i].Hub_Name));

                    $('#destinationId').append($("<option></option>").attr("value", hubList["sourceRoot"][i].Hub_Id).attr("latitude", hubList["sourceRoot"][i].latitude)
                        .attr("longitude", hubList["sourceRoot"][i].longitude).attr("radius", hubList["sourceRoot"][i].radius).attr("detention", hubList["sourceRoot"][i].detention).attr("hubAddress", hubList["sourceRoot"][i].hubAddress).text(hubList["sourceRoot"][i].Hub_Name));
                }
                $("#sourceId").select2();
                $("#destinationId").select2();
                if(dHub>0){
                    $("#destinationId").val(dHub).trigger('change');
                }
                if(sHub>0){
                    $("#sourceId").val(sHub).trigger('change');
                }if (dHub>0 && sHub>0){
                	$("#destinationId").val(dHub).trigger('change');
                	$("#sourceId").val(sHub).trigger('change');
                }
            }
        });
    }

    function createCombo(counterI, hubId) {
        var html = '<div class="control-group input-group mydiv" style="margin-top:10px" >' +
            '<select onchange="drawCheckpoints(' + counterI + ')" name="addmore[]" class="form-control select2 style="width:200px!important;" checkpointC" id="checkpoint' + counterI + '"' + '>' +
            '<option>Enter checkpoint ' + counterI + '</option></select>' +
            '<div class="input-group-btn"><button title="Remove" class="btn btn-danger remove" style="margin-left: 10px; height: 29px; border-radius: 4px;" type="button" id="' + counterI + '"' + '><i class="glyphicon glyphicon-remove"></i></button>' +
            '</div></div>';
        $(".after-add-more").before(html);

        $.ajax({
            url: '<%=request.getContextPath()%>/LegCreationAction.do?param=getCheckPoints',
            data:{
            	tripCustId: document.getElementById("cust_names").value
            },
            success: function(response) {
                hubList = JSON.parse(response);
                for (var i = 0; i < hubList["checkPointRoot"].length; i++) {
                    $('#checkpoint' + counterI).append($("<option></option>").attr("value", hubList["checkPointRoot"][i].Hub_Id).attr("latitude", hubList["checkPointRoot"][i].latitude)
                        .attr("longitude", hubList["checkPointRoot"][i].longitude).attr("radius", hubList["checkPointRoot"][i].radius).attr("detention", hubList["checkPointRoot"][i].detention).attr("hubAddress", hubList["checkPointRoot"][i].hubAddress)
                        .text(hubList["checkPointRoot"][i].Hub_Name));
                }
                $('#checkpoint' + counterI).select2({ width: '100%'});
                if (hubId > 0) {
                    $("#checkpoint" + counterI).val(hubId).trigger('change');
                }
            }
        });
    }
    var counter = 0;
    $(".add-more").click(function() {
        counter++;
        createCombo(counter);
        addCheck=true;
        $('#checkAddBtn').hide();
    });
    $("body").on("click", ".remove", function(e) {
        $(this).parents(".control-group").remove();
        removeId = $(this).attr("id");
        counter--;
        sessionStorage.removeItem(removeId);
        for (var n = 0,leng = srcDestMarkers.length ; n < leng ; n++){
	        var currMar1 = srcDestMarkers[n];
		        if (removeId == currMar1.id){
		        	currMar1.setMap(null);
		        }
        }  
        if (directionsDisplay != null) {
            directionsDisplay.setMap(null);
        }
        plotRoute();
        $('#checkAddBtn').show();
    });

    $("#sourceId").change(function() {
        sourceId = document.getElementById("sourceId").value;
        if (directionsDisplay != null) {
            directionsDisplay.setMap(null);
        }
        var convertintomtrs = $('#sourceId option:selected').attr("radius") * 1000;
        myLatLngS = new google.maps.LatLng($('#sourceId option:selected').attr("latitude"), $('#sourceId option:selected').attr("longitude"));
        sLat = $('#sourceId option:selected').attr("latitude");
        sLon = $('#sourceId option:selected').attr("longitude");
        if ($('#sourceId option:selected').attr("radius") == '-1' || $('#sourceId option:selected').attr("radius") == -1) {
            //drawPolygon(sourceId);
        } else {
            //DrawCircle(myLatLngS, convertintomtrs);
        }
        if(document.getElementById("destinationId").value!=''){
        	plotRoute();
        }
        createSDMarker(myLatLngS, $('#sourceId option:selected').attr("hubAddress"),111);
    });
    $("#destinationId").change(function() {
        if (directionsDisplay != null) {
            directionsDisplay.setMap(null);
        }
        destinationId = document.getElementById("destinationId").value;
        var convertintomtrs = $('#destinationId option:selected').attr("radius") * 1000;
        myLatLngD = new google.maps.LatLng($('#destinationId option:selected').attr("latitude"), $('#destinationId option:selected').attr("longitude"));
        dLat = $('#destinationId option:selected').attr("latitude");
        dLon = $('#destinationId option:selected').attr("longitude");
        if ($('#destinationId option:selected').attr("radius") == '-1' || $('#destinationId option:selected').attr("radius") == -1) {
            //drawPolygon(destinationId);
        } else {
            //DrawCircle(myLatLngD, convertintomtrs);
        }
        plotRoute(false);
        createSDMarker(myLatLngD, $('#destinationId option:selected').attr("hubAddress"),999);
    });

    function drawCheckpoints(id) {
    	
        myLatLngC = new google.maps.LatLng($('#checkpoint' + id + ' option:selected').attr("latitude"), $('#checkpoint' + id + ' option:selected').attr("longitude"));
        convertintomtrs = Number($('#checkpoint' + id + ' option:selected').attr("radius")) * 1000;
        //DrawCircle(myLatLngC, convertintomtrs);
        sessionStorage.setItem(id, myLatLngC);
        if (directionsDisplay != null) {
            directionsDisplay.setMap(null);
        }
        plotRoute(false);
        if(id>0){
           $('#checkAddBtn').show();
           createSDMarker(myLatLngC, $('#checkpoint' + id + ' option:selected').attr("hubAddress"),id);
        }
        
    }

    function DrawCircle(myLatLng, convertintomtrs) {

        createCircle = {
            strokeColor: '#FF8000',
            strokeOpacity: 0.8,
            strokeWeight: 2,
            fillColor: '#FF8000',
            fillOpacity: 0.35,
            map: map,
            center: myLatLng,
            radius: convertintomtrs //In meter
        };
        circle = new google.maps.Circle(createCircle);
        circle.setCenter(myLatLng);
        map.fitBounds(circle.getBounds());
        circleArray.push(circle);
    }

    function drawPolygon(hubId) {
        var polygonCoords1 = [];
        polygonStoreForModify.load({
            params: {
                hubId: hubId
            },
            callback: function() {
                var latLong;
                for (var i = 0; i < polygonStoreForModify.getCount(); i++) {
                    var rec = polygonStoreForModify.getAt(i);
                    if (i != polygonStoreForModify.getCount() && hubId == polygonStoreForModify.getAt(i).data['hubid']) {
                        latLong = new google.maps.LatLng(rec.data['latitude'], rec.data['longitude']);
                        polygonCoords1.push(latLong);
                        continue;
                    }
                }

                polygonNew = new google.maps.Polygon({
                    paths: polygonCoords1,
                    map: map,
                    strokeColor: '#A7A005',
                    strokeOpacity: 0.8,
                    strokeWeight: 3,
                    fillColor: '#ECF086',
                    fillOpacity: 0.55
                }); 
                polygonCoords.push(polygonNew);
                bounds = new google.maps.LatLngBounds();
                for (i = 0; i < polygonCoords1.length; i++) {
                    bounds.extend(polygonCoords1[i]);
                }
                map.fitBounds(bounds);
            }
        });
    }

    function plotRoute(btnValue) {
        var wayPts = [];
        
        for (var j = 1, len = sessionStorage.length+1; j <= len; j++) {
            for(var l=0;l <=maxDrag;l++){
                //for (var l = 1, len = localStorage.length; l <= len; l++) {
                    var dragArr = [];
                    if(localStorage.getItem('checkPoint-'+(j-1)+'dragpoint-'+l) !=null){
                    	//alert("Click ok to see the route");

                        dragArr = localStorage.getItem('checkPoint-'+(j-1)+'dragpoint-'+l).replace("(", "").replace(")", "").split(",");
                        wayPts.push({
                            location: new google.maps.LatLng(dragArr[0], dragArr[1]),
                            stopover: false
                        });
                        localStorage.removeItem('checkPoint-'+(j-1)+'dragpoint-'+l);
                    }
                //}
            }
            if(sessionStorage.getItem(j) !=null){
                var wayptArr = [];
	            wayptArr = sessionStorage.getItem(j).replace("(", "").replace(")", "").split(",");
	            wayPts.push({
	                location: new google.maps.LatLng(wayptArr[0], wayptArr[1]),
	                stopover: true
	            });
            }
            
        }
        if(sessionStorage.length==0){
            for(var l=0;l <=maxDrag;l++){
                    var dragArr = [];
                    if(localStorage.getItem('checkPoint-'+(0)+'dragpoint-'+l) !=null){
                        alert('inside== '+j);
                        dragArr = localStorage.getItem('checkPoint-'+(0)+'dragpoint-'+l).replace("(", "").replace(")", "").split(",");
                        wayPts.push({
                            location: new google.maps.LatLng(dragArr[0], dragArr[1]),
                            stopover: false
                        });
                        localStorage.removeItem('checkPoint-'+(0)+'dragpoint-'+l);
                    }
            }
        }
<!--        for(var j=0;j <=maxCheck;j++){-->
<!--            for (var l = 1, len = localStorage.length; l <= len; l++) {-->
<!--                var dragArr = [];-->
<!--                if(localStorage.getItem('checkPoint-'+(j)+'dragpoint-'+l) !=null){-->
<!--                    dragArr = localStorage.getItem('checkPoint-'+(j)+'dragpoint-'+l).replace("(", "").replace(")", "").split(",");-->
<!--                    wayPts.push({-->
<!--                        location: new google.maps.LatLng(dragArr[0], dragArr[1]),-->
<!--                        stopover: false-->
<!--                    });-->
<!--                    localStorage.removeItem('checkPoint-'+(j)+'dragpoint-'+l);-->
<!--                }-->
<!--            }-->
<!--        }-->
        var directionsService = new google.maps.DirectionsService;
        directionsDisplay = new google.maps.DirectionsRenderer({
        	suppressMarkers: true,
            map: map,
            draggable: true,
            polylineOptions: {
                strokeColor: "green"
            }
        });
        google.maps.event.addListener(directionsDisplay, 'directions_changed', function() {
            plotDrag(directionsDisplay.directions, map, directionsDisplay);
        });
        
        alert("Click ok to see the route");
        directionsService.route({
            origin: myLatLngS,
            destination: myLatLngD,
            waypoints: wayPts,
            travelMode: google.maps.TravelMode.DRIVING

        }, function(response, status) {
            if (status === google.maps.DirectionsStatus.OK) {
                directionsDisplay.setDirections(response);
            } else {
                console.log("Invalid Request " + status);
            }
        });
    }
    var durationArr=[];
    var distanceArr=[];
    function plotDrag(result, map, directionsDisplay) {
        var myRoute = result.routes[0].legs[0];
        jsonArray = [];
        dragPointArray = [];
        distanceArr = [];
        durationArr=[];
        var distance =0;
        var legs = result.routes[0].legs;
        distanceArr.push('{0'  + ',0' + '}')
		for(var i=0; i<result.routes[0].legs.length; ++i) {
			tempDist = legs[i].distance.value;
			
			distanceArr.push('{' + (i + 1) + ',' + (tempDist/1000) + '}')
		    distance += parseFloat(tempDist);
		}
		durationArr.push('{0'  + ',0' + '}')
		for(var i=0; i<result.routes[0].legs.length; ++i) {
            duration = legs[i].duration.value;
            durationArr.push('{' + (i + 1) + ',' + (duration/60).toFixed() + '}')
        }
        for(var w=0; w<result.routes[0].legs.length; ++w) {
            for(var w1=0;w1<result.routes[0].legs[w].via_waypoint.length;++w1){
                dragPointArray.push('{' + (w1 + 1) + ',' +result.routes[0].legs[w].via_waypoint[w1].location.toString() + ','+w+'}');
                //dragPointArray.push('checkPoint-'+w+'dragpoint-'+w1, );
            }
        }
        currentRoute = result.routes[0].overview_path;
        for (var i = 0; i < currentRoute.length; i++) {
            jsonArray.push('{' + (i + 1) + ',' + currentRoute[i].lat() + ',' + currentRoute[i].lng() + '}');
        }
        document.getElementById("distanceId").value = (Number(distance)/1000).toFixed(2);
        if($('#avgSpeedId').val()!=''){
        	dis= Number($('#distanceId').val());
			avg=Number($('#avgSpeedId').val());
			value = dis / avg.toFixed(1);
			value = value*60;
		    document.getElementById("TATId").value = convertMinutesToHHMM(value.toFixed());
        }
         if($('#TATId').val()!=''){
        	dis= Number($('#distanceId').val());			
		    var time1 = ($('#TATId').val()).split(":");
			var time2 = (parseInt(time1 [0] * 60)+parseInt(time1 [1]));
			//alert("time2 "+ time2 );
			tat = time2;			
			value = dis / tat;
			value = value*60;			   
		    document.getElementById("avgSpeedId").value = (value.toFixed(2));
        }
       
    }
    var countC=0;
    function saveLegDetails() {
        var customerName = document.getElementById("cust_names").value;
        var legName = document.getElementById("legNameId").value;
        var source = document.getElementById("sourceId").value;
        var destination = document.getElementById("destinationId").value;
        var distance = document.getElementById("distanceId").value;
        var avgSpeed = document.getElementById("avgSpeedId").value;
        var TAT = document.getElementById("TATId").value;
        if(countC>0){
            swal("Can't modify the leg as route has been already created.");
            return;
        }
        if (customerName == "") {
            sweetAlert("Please select customer");
            return;
        }
        if(document.getElementById("sourceId").value==document.getElementById("destinationId").value){
    		if(sessionStorage.length==0){
    			sweetAlert("Please Select atleast one checkpoint");
            	return;
    		}
    	}
        if (legName == "") {
            sweetAlert("Please Enter Leg Name");
            return;
        }
        if (source == "") {
            sweetAlert("Please Select Source");
            return;
        }
        if (destination == "") {
            sweetAlert("Please Select Destination");
            return;
        }
        if (distance == "") {
            sweetAlert("Please Enter Distance");
            return;
        }
        if (avgSpeed == "") {
            sweetAlert("Please Enter Average Speed");
            return;
        }
        if (TAT == "") {
            sweetAlert("Please Enter TAT");
            return;
        }
        if (parseInt(avgSpeed) == 0){
            sweetAlert("Please Enter Average speed more than Zero");
            return;
        }
        if (parseInt(avgSpeed) > 99 ){
            sweetAlert("Please Enter Average speed less than 100");
            return;
        }
        
        var checkPointArray = [];
        var hubIdC=0;
        for (var j = 0; j < sessionStorage.length; j++) {
            arr = sessionStorage.getItem(j + 1).replace("(", "").replace(")", "").split(",");
            if(hubIdC == document.getElementById("checkpoint" + (j + 1)).value){
            	sweetAlert("Sequential checkpoints should not be same.");
            	return;
            }
            hubIdC = document.getElementById("checkpoint" + (j + 1)).value;
            hubId = document.getElementById("checkpoint" + (j + 1)).value;
            det = $("#checkpoint"+(j + 1)+" option:selected").attr("detention");
            rad = $("#checkpoint"+(j + 1)+" option:selected").attr("radius");
            checkPointArray.push('{' + (j + 1) + ',' + arr[0] + ',' + arr[1] + ',' + hubId + ',' + rad + ',' + det + '}')
<!--            for (var l = 0; l < localStorage.length; l++) {-->
<!--                alert(localStorage.getItem('checkPoint-'+(j+1)+'dragpoint-'+(l+1)));-->
<!--                if(localStorage.getItem('checkPoint-'+(j+1)+'dragpoint-'+(l+1)) !=null){-->
<!--                    dragArr = localStorage.getItem('checkPoint-'+(j+1)+'dragpoint-'+(l+1)).replace("(", "").replace(")", "").split(",");-->
<!--                    dragPointArray.push('{' + (l + 1) + ',' + dragArr[0] +','+dragArr[1]+ ','+(j+1)+'}');-->
<!--                }-->
<!--	        }-->
        }
        var durationArray = JSON.stringify(durationArr);
        var distanceArray = JSON.stringify(distanceArr);
        var checkPointData = JSON.stringify(checkPointArray);
        var jsonData = JSON.stringify(jsonArray);
        var dragPointData = JSON.stringify(dragPointArray);
        var params = {
            tripCustId: customerName,
            legName: legName,
            source: source,
            destination: destination,
            distance: distance,
            avgSpeed: avgSpeed,
            TAT: TAT,
            checkPointArray: checkPointData,
            jsonArray: jsonData,
            dragPointArray: dragPointData,
            sLat: sLat,
            sLon: sLon,
            dLat: dLat,
            dLon: dLon,
            legModId: legUniqId,
            statusA: statusA,
            sourceRad : $('#sourceId option:selected').attr("radius"),
            destinationRad : $('#destinationId option:selected').attr("radius"),
            sourceDet : $('#sourceId option:selected').attr("detention"),
            destinationDet : $('#destinationId option:selected').attr("detention"),
            durationArr: durationArray,
            distanceArr:distanceArray
        };
        $("#mapViewId").mask();
        $.ajax({
            url: '<%=request.getContextPath()%>/LegCreationAction.do?param=saveLegDetails',
            data: params,
            type:"POST",
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
                $("#mapViewId").unmask();
                goBack();
            }
        });
        
    }

    function clearAllData() {
        jsonArray = [];
        dragPointArray = [];
        checkPointArray = [];
        counter = 0;
        sessionStorage.clear();
        localStorage.clear();
        $("#sourceId").empty().select2();
        $("#destinationId").empty().select2();
        document.getElementById("legNameId").value = "";
        document.getElementById("distanceId").value = "";
        document.getElementById("avgSpeedId").value = "";
        document.getElementById("TATId").value = "";
        if (directionsDisplay != null) {
            directionsDisplay.setMap(null);
        }
        $(".control-group").remove();
        getSourceAndDestination();
        document.getElementById("dialogBoxId").innerHTML = "";
        legUniqId = 0;
        countC =0;
        maxCheck=0;
        maxDrag=0;
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
			  }else{
			  }
			});
    }

    function modifyRecord(legId, legName, avgSpeed, distance, TAT,count) {
    	for (var o = 0,leng = srcDestMarkers.length ; o < leng ; o++){
	        var currMar2 = srcDestMarkers[o];
		      currMar2.setMap(null);
        }  
        
        setValuesForMod(legId, legName, avgSpeed, distance, TAT,count);
    }
    function setValuesForMod(legId, legName, avgSpeed, distance, TAT,count){
    	uniqueId = legId;
    	changeTab('mapViewId');
        getRoutePath(legId);	
        legUniqId = legId;
        countC=count;
        document.getElementById("legNameId").value = legName.replace("-"," ");
        document.getElementById("distanceId").value = distance;
        document.getElementById("avgSpeedId").value = avgSpeed;
        document.getElementById("TATId").value = TAT;
        $('#viewBtn').hide();
        $('#addId').hide();
    }
    function updateStatus(legId, legName, avgSpeed, distance, TAT,status,rCount){
        if(rCount>0){
            swal("Can't Deactivate the leg as route has been already created.");
            return;
        }
    	if(status=='Inactive'){
    		inactiveRecord(legId);
    	}else{
    		setValuesForMod(legId, legName, avgSpeed, distance, TAT);
    		statusA=status;
    	}
    }
    function inactiveRecord(legId){
    	swal({
		  title: "Are you sure you want to Inactive the leg?",
		  type: "warning",
		  showCancelButton: true,
		  confirmButtonClass: "btn-danger",
		  confirmButtonText: "Yes, Inative it!",
		  closeOnConfirm: false
		},
		function(){
		  $.ajax({
              url: '<%=request.getContextPath()%>/LegCreationAction.do?param=updateStatus',
              data: {
                  uniqueId: legId
              },
              success: function(result) {
                   swal("Record has been updated", "");
                   summaryTable.ajax.reload();
              }
          })
		});
    }
    function getRoutePath(legId) {
        $.ajax({
            url: '<%=request.getContextPath()%>/LegCreationAction.do?param=getLegLatLongs',
            data: {
                legId: legId
            },
            success: function(result) {
                var j = 0;
                results = JSON.parse(result);
                for (var i = 0; i < results["latLongRoot"].length; i++) {
                    if ((results["latLongRoot"][i].type == 'SOURCE')) {
                        myLatLngS = new google.maps.LatLng(results["latLongRoot"][i].lat, results["latLongRoot"][i].lon);
                        sHub = results["latLongRoot"][i].hubId;
                     //   getSourceAndDestination(sHub,0);
                    }
                    if (results["latLongRoot"][i].type == 'DESTINATION') {
                        myLatLngD = new google.maps.LatLng(results["latLongRoot"][i].lat, results["latLongRoot"][i].lon);
                        dHub = results["latLongRoot"][i].hubId;
                       // createSDMarker(myLatLngS,'Dest');  
                    //    getSourceAndDestination(0,dHub);
                    }
                    if (results["latLongRoot"][i].type == 'CHECKPOINT') {
                        j++;
                        latlong = new google.maps.LatLng(results["latLongRoot"][i].lat, results["latLongRoot"][i].lon);
                        sessionStorage.setItem(j, latlong);
                        createCombo(j, results["latLongRoot"][i].hubId);
                    }
                    if (results["latLongRoot"][i].type == 'DRAGPOINT') {
                        maxCheck = results["latLongRoot"][i].maxCheck;
                        maxDrag = results["latLongRoot"][i].maxdrag;
                        latlong = new google.maps.LatLng(results["latLongRoot"][i].lat, results["latLongRoot"][i].lon);
                        localStorage.setItem('checkPoint-'+parseInt(results["latLongRoot"][i].checkSeq)+'dragpoint-'+parseInt(results["latLongRoot"][i].sequence),
                        latlong);
                    }
                }
                getSourceAndDestination(sHub,dHub);
                counter = j;
                plotRoute(false);
                buttonValue="";
            }
        });
    }

    function goBack() {
   
        changeTab('summaryId');
       
        if(typeof summaryTable==='undefined'){
            //summaryTable.ajax.reload();
        }else{
            summaryTable.ajax.reload();
        }
        $('#viewBtn').show();
        $('#addId').show();
        $('#summaryId').show();
        document.getElementById("dialogBoxId").innerHTML = "";
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
		  
	    var marker = new google.maps.Marker({
	        position: latlng,
	        title: title,
	        map: map,
	        icon : img,
	        id: ID,
	    });
		srcDestMarkers.push(marker);
	    google.maps.event.addListener(marker, 'click', function () {
	        infowindow.setContent(title);
	        infowindow.open(map, marker);
	    });
	}
</script>


	<jsp:include page="../Common/footer.jsp" />
		<!-- </body>   -->
	<!-- </html> -->