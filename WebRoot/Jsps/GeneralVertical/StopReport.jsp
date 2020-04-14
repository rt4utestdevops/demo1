<%@ page language="java"
	import="java.util.*,t4u.functions.*,t4u.beans.*,t4u.common.*,t4u.GeneralVertical.*"
	pageEncoding="utf-8"%>
<%@page import="com.itextpdf.text.log.SysoLogger"%>
	<%@ taglib uri="http://packtag.sf.net" prefix="pack" %>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://"+ request.getServerName() + ":" + request.getServerPort()+ path + "/";
	if(request.getParameter("list")!=null){
	String list=request.getParameter("list").toString().trim();
	String[] str=list.split(",");
	int systemid=Integer.parseInt(str[0].trim());
	int customerid=Integer.parseInt(str[1].trim());
	int userid=Integer.parseInt(str[2].trim());
	String language=str[3].trim();
	LoginInfoBean loginInfo=new LoginInfoBean();
	loginInfo.setSystemId(systemid);
	loginInfo.setCustomerId(customerid);
	loginInfo.setUserId(userid);
	loginInfo.setLanguage(language);
	loginInfo.setZone(str[4].trim());
	loginInfo.setOffsetMinutes(Integer.parseInt(str[5].trim()));
	loginInfo.setSystemName(str[6].trim());
	loginInfo.setCategory(str[7].trim());
	loginInfo.setStyleSheetOverride("N");
	if(str.length>8){
	loginInfo.setCustomerName(str[8].trim());
	}
	if(str.length>9){
	loginInfo.setCategoryType(str[9].trim());
	}
	if(str.length>10){
	loginInfo.setUserName(str[10].trim());
	}
	session.setAttribute("loginInfoDetails",loginInfo);
}
	
	CommonFunctions cf = new CommonFunctions();
			
    LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
	String language = loginInfo.getLanguage();
	int systemId = loginInfo.getSystemId();
	int customerId = loginInfo.getCustomerId();
    int userId=loginInfo.getUserId();
	int offset = loginInfo.getOffsetMinutes();
	String offsetHHMM = cf.convertMinutesToHHMMFormat(offset);   
	String distUnits = cf.getUnitOfMeasure(systemId);
	
	MapAPIConfigBean bean = loginInfo.getMapAPIConfig();
    String mapName = bean.getMapName();
    String appKey = bean.getAPIKey();
	String appCode = bean.getAppCode();
	 
%>
 <jsp:include page="../Common/header.jsp" />
 <jsp:include page="../Common/InitializeLeaflet.jsp" />
<link rel="stylesheet" href="https://code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css"/>
<link rel="stylesheet" href="https://cdn.datatables.net/1.10.16/css/dataTables.jqueryui.min.css"/>
<link rel="stylesheet" href="https://cdn.datatables.net/buttons/1.5.1/css/buttons.dataTables.min.css"/>
<link rel="stylesheet" href="https://cdn.datatables.net/1.10.16/css/dataTables.material.min.css"/>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/tempusdominus-bootstrap-4/5.0.0-alpha18/css/tempusdominus-bootstrap-4.min.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-multiselect/0.9.13/css/bootstrap-multiselect.css">
<link rel="stylesheet" href="https://cdn.datatables.net/1.10.16/css/jquery.dataTables.min.css"/>
<link rel="stylesheet" href="https://cdn.datatables.net/fixedheader/3.1.3/css/fixedHeader.dataTables.min.css"/>
<link href="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.6-rc.0/css/select2.min.css" rel="stylesheet" />
<link rel="stylesheet" href="https://www.jqwidgets.com/public/jqwidgets/styles/jqx.base.css">
<link rel="stylesheet" href="https://www.jqwidgets.com/public/jqwidgets/styles/jqx.energyblue.css">
<link rel="stylesheet" href="https://www.jqwidgets.com/public/jqwidgets/styles/jqx.arctic.css">

 	<link href="../../Main/leaflet/leaflet-draw/css/leaflet.css" rel="stylesheet" type="text/css" />
	<script src="../../Main/leaflet/leaflet-draw/js/leaflet.js"></script>
	<script src="https://leaflet.github.io/Leaflet.fullscreen/dist/Leaflet.fullscreen.min.js"></script>
	<link rel="stylesheet" href="https://leaflet.github.io/Leaflet.fullscreen/dist/leaflet.fullscreen.css" />
	<script src="https://unpkg.com/leaflet.markercluster@1.3.0/dist/leaflet.markercluster.js"></script>
	<link rel="stylesheet" href="https://unpkg.com/leaflet.markercluster@1.3.0/dist/MarkerCluster.css" />
	<link rel="stylesheet" href="https://unpkg.com/leaflet.markercluster@1.3.0/dist/MarkerCluster.Default.css" />
	<script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
	<script src="../../Main/leaflet/leaflet-tilelayer-here.js"></script>
<!--	<script src="../../Main/leaflet/initializeleaflet.js"></script>-->
	<link rel="stylesheet" href="../../Main/leaflet/leaflet.measure.css"/>
    <script src="../../Main/leaflet/leaflet.measure.js"></script>
	<script src="https://unpkg.com/esri-leaflet@2.3.1/dist/esri-leaflet.js"
  integrity="sha512-Np+ry4Dro5siJ1HZ0hTwn2jsmu/hMNrYw1EIK9EjsEVbDge4AaQhjeTGRg2ispHg7ZgDMVrSDjNrzH/kAO9Law=="
  crossorigin=""></script>
<style>
    .btn-generate{
    background: #18519E !important;
    border:none;
    margin-top: 30px;
    }

    .form-control-filter {
    float:right;
    border-radius:2px;
    border: none;
    z-index: 100;
    border: 1px solid;
    height: 34px !important;
    padding: 0px 0px 0px 8px;
    }
    .form-control-filter:focus {
    border: none;
    border: 1px solid;
    box-shadow: none;
    -webkit-box-shadow: none;
    }
    .form-label-group {
    position: relative;
    width:100%;
    margin-bottom: 1rem;
    }
    .form-label-group-axis-left {
    position: relative;
    float:left;
    width:50%;
    margin-bottom: 1rem;
    }
    .form-label-group-axis-right {
    position: relative;
    float:right;
    padding-left: 5px;
    width:50%;
    margin-bottom: 1rem;
    }
    .disp{
    display:block;
    }
    .dispNone{
    display:none;
    }
    .disp-flex{
    display: flex;
    }

    label {
    margin-bottom: 0.25em;
    font-weight: 700;
    }
   
    .w3-card-4 {
	box-shadow:0 4px 10px 0 rgba(0,0,0,0.2),0 4px 20px 0 rgba(0,0,0,0.19);
    margin:-16px -4px 0px -4px;
 	padding-bottom: 8px;
 	padding-left:8px;
	padding-right:8px;
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
			width: 300px !important;
    height: 34px;
    border: 1px solid !important;
		}
		
		.hrStyle {
    padding: 5px 5px 20px 20px;
    margin-bottom: 20px;
    border-radius: 1px;
    opacity: 1;
    background: #337AB7;
    text-transform: uppercase;
    color: white;
    height: 30px;
}
.input-group-btn{
display:none;
}
.input-group{
width: 272px;
}

.multiselect-container {
				     font-size:12px !important;
				     overflow-x: scroll !important;
				}	
				.multiselect-container>li>a {
				    margin-left: -15px;
				}
				a {
				    text-decoration: none; 
				    color: black; 
				}
.table {
    width: 100%;
    max-width: 100%;
    margin-bottom: 1rem;
    background-color: transparent;
    font-size: 12px;
}
.sorting_1 {
	text-align: center !important;
}
  
   .modal {
   position: fixed;
   top: 5%;
   left: 30%;
   z-index: 1050;
   width: 81%;
   bottom: unset;
   background-color: #ffffff;
   border: 1px solid #999;
   border: 1px solid rgba(0, 0, 0, 0.3);
   -webkit-border-radius: 6px;
   -moz-border-radius: 6px;
   border-radius: 6px;
   -webkit-box-shadow: 0 3px 7px rgba(0, 0, 0, 0.3);
   -moz-box-shadow: 0 3px 7px rgba(0, 0, 0, 0.3);
   box-shadow: 0 3px 7px rgba(0, 0, 0, 0.3);
   -webkit-background-clip: padding-box;
   -moz-background-clip: padding-box;
   background-clip: padding-box;
   outline: none;
   overflow-y: hidden;
   }
   #select2-tripName-results {
   	font-size: 11px;
   }
   #select2-vehicleNo-results {
   	font-size: 11px;
   }
</style>
	<div class="container-fluid" id="container-report-select">
   <div class="w3-card-4">
      <div class="card-body" style="padding:1em !important">
         <div class="hrStyle text-center" style="margin:-16px -24px 16px -24px;">Vehicle Stoppage Report</div>
         <div class="row">
			<div class="col-sm-2" id="criteria-vehicle">
				<label class="radio-inline">
				  <input type="radio" id="vehRadio" value="trip" name="optradio">&nbsp;&nbsp;&nbsp;<span id="tripWise">Trip Wise</span>
				</label>
            </div>
            <div class="col-sm-2 padCols" id="sd" style="margin-top: -13px;">
               <label style= "font-size:11px;" for="report-start-date">Start Date</label>
               <input type="text" style="padding:6px;" id="trip-start-date" class="form-control form-control-custom">
            </div>
            <div class="col-sm-2 padCols" id="ed" style="margin-top: -13px;">
               <label style= "font-size:11px;" for="report-end-date">End Date</label>
               <input type="text" style="padding:6px;" id="trip-end-date" class="form-control form-control-custom" >
            </div>
            <div class="col-sm-3 padCols" style="margin-top: -13px;">
               <label style= "font-size:11px;" for="report-types">Trip Name</label>
               <div>
                  <select class="form-control" id="tripName">
                  		<option>Select Trip</option>
                  </select>
               </div>
            </div>
        </div>
         <div class="row">
         	<div class="col-sm-2" id="criteria-vehicle" style="margin-top: 21px;">
				<label class="radio-inline">
				  <input type="radio" id="tripRadio" checked onclick="handleTripVehRadioClick(value)" value="vehicle" name="optradio">&nbsp;&nbsp;&nbsp;<span style="">Vehicle Wise</span>
				</label>
            </div>
            <div class="col-sm-2 padCols">
               <label style= "font-size:11px;" for="report-types">Vehicle No</label>
               <div>
                  <select class="form-control" id="vehicleNo">
                  		<option>Select Vehicle</option>
                  </select>
               </div>
            </div>
            <div class="col-sm-2 padCols" id="sd">
               <label style= "font-size:11px;" for="report-start-date">Start Date</label>
               <input type="text" style="padding:6px;" id="dateInput1" class="form-control form-control-custom" name="reportStartDate" >
            </div>
            <div class="col-sm-2 padCols" id="ed">
               <label style= "font-size:11px;" for="report-end-date">End Date</label>
               <input type="text" style="padding:6px;" id="dateInput2" class="form-control form-control-custom" name="reportEndDate">
            </div>
            <div class="col-sm-4 padCols" id="cv">
               <div class="row" id="row-criteria" style="padding-left: 10px;">
                  <div class="col-sm-4" style ="display:none">
                     <label for="select-criteria-trip">Driver Name</label>
                     <input type="text" class="form-control form-control-custom" id="driverName">
                  </div>
                  <div class="col-sm-3">
                     <button class="btn btn-primary" style="background:#18519E;margin-top: 26px;padding-bottom:10px;margin-left: -6px;width: 106px;height: 36px;" onclick = "getGridData();">View</button>
                  </div>
                  <div class="col-sm-8">
                     <h5 id="totalHrs" style="margin-top: 35px;font-size: 14px;color: red;margin-left: 10px;">Total Stoppage(dd:hh:mm): </h5>
                  </div>
               </div>
            </div>
         </div>
      </div>
   </div>
   <div style="overflow: auto !important;">
      <table id="speedReportTable" class="table table-striped table-bordered" cellspacing="0" width="100%">
         <thead>
            <tr>
               <th>SL. No</th>
               <th>Start Date</th>
               <th>End Date</th>
               <th>Location</th>
               <th>Latitude</th>
               <th>Longitude</th>
               <th>Duration (DD:HH:MM)</th>
<!--               <th>View On Map</th>-->
            </tr>
         </thead>
      </table>
   </div>
</div>
<div class="center-view dispNone" id="loading-report" style="margin-top:24px;">
    <img src="../../Main/images/loading.gif" alt="">
</div>
<!--<div id="viewMapModal" class="modal-content modal fade" style="margin-top:1%">-->
<!--   <div class="modal-header">-->
<!--      <div class="secondLine" style="display:flex; justify-content:space-between; align-items:baseline;">-->
<!--         <h4 id="onTripVehicle" class="modal-title" style="text-align:left; margin-left:10px;">Action Required for - Geo fence correction</h4>-->
<!--      </div>-->
<!--   </div>-->
<!--   <div class="col-md-12">-->
<!--      <div id="dvMap" style="width: 1000px; height: 417px; margin-top: 8px; margin-left:30px;border: 1px solid gray;"></div>-->
<!--      <div>-->
<!--         <h5 id="dialogBoxId" style="color:red;"></h5>-->
<!--      </div>-->
<!--   </div>-->
<!--   <div class="modal-footer" style="text-align: right; height:52px;">-->
<!--      <button type="reset" class="btn btn-danger" data-dismiss="modal">Close</button>-->
<!--   </div>-->
<!--</div>-->
<link rel="stylesheet" href="../../Main/sweetAlert/sweetalert.css">
<link type="text/css" href="//gyrocode.github.io/jquery-datatables-checkboxes/1.2.11/css/dataTables.checkboxes.css" rel="stylesheet" />

<script src="https://ajax.aspnetcdn.com/ajax/jquery.validate/1.11.1/jquery.validate.min.js"></script>
<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.21.0/moment.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/tempusdominus-bootstrap-4/5.0.0-alpha18/js/tempusdominus-bootstrap-4.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-multiselect/0.9.13/js/bootstrap-multiselect.min.js"></script>
<script src="https://cdn.datatables.net/1.10.16/js/jquery.dataTables.min.js"></script>
<script src="https://cdn.datatables.net/buttons/1.5.1/js/dataTables.buttons.min.js"></script>
<script src="https://cdn.datatables.net/buttons/1.5.1/js/buttons.flash.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jszip/3.1.3/jszip.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.32/pdfmake.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.32/vfs_fonts.js"></script>
<script src="https://cdn.datatables.net/buttons/1.5.1/js/buttons.html5.min.js"></script>
<script src="https://cdn.datatables.net/buttons/1.5.1/js/buttons.print.min.js"></script>
<script src="https://cdn.datatables.net/fixedheader/3.1.3/js/dataTables.fixedHeader.min.js"></script>
<script type="text/javascript" src="https://gyrocode.github.io/jquery-datatables-checkboxes/1.2.11/js/dataTables.checkboxes.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.6-rc.0/js/select2.min.js"></script>
<script src="https://www.jqwidgets.com/public/jqwidgets/jqx-all.js"></script>
	<script src="https://www.jqwidgets.com/public/jqwidgets/globalization/globalize.js"></script>
<script src="../../Main/sweetAlert/sweetalert-dev.js"></script>   
    <script>
	
    var customerDetails;
    var status;
    var startDate="";
    var endDate = "";
    var uniqueId;
    var currentDate = new Date();
    var yesterdayDate = new Date();
    yesterdayDate.setDate(yesterdayDate.getDate() - 1);
    yesterdayDate.setHours(00);
	yesterdayDate.setMinutes(00);
	yesterdayDate.setSeconds(00);
	currentDate.setHours(23);
	currentDate.setMinutes(59);
	currentDate.setSeconds(59);
	var tableN;

	var tripId =0;
    
   $(document).ready(function () {
   $("#dateInput1").jqxDateTimeInput({ theme: "arctic", formatString: "dd/MM/yyyy HH:mm:ss", showTimeButton: true, width: '100%', height: '25px', max: new Date()});
   $('#dateInput1 ').jqxDateTimeInput('setDate', yesterdayDate);
   $("#dateInput2").jqxDateTimeInput({ theme: "arctic", formatString: "dd/MM/yyyy HH:mm:ss", showTimeButton: true, width: '100%', height: '25px', max: currentDate});
   $('#dateInput2 ').jqxDateTimeInput('setDate', currentDate);
   

	});
	$("#trip-start-date").datepicker({
        dateFormat: 'dd/mm/yy',
        timeFormat: "HH:mm:ss",
        onSelect: function(selected, event) {
            $("#trip-end-date").datepicker("option", "minDate", selected);
            setTimeout(function(){$("#trip-end-date").datepicker('show');},10);
            getTrips();
        }
    });
    $("#trip-end-date").datepicker({
        dateFormat: 'dd/mm/yy',
        timeFormat: "HH:mm:ss",
        onSelect: function(selected) {
            $("#trip-start-date").datepicker("option", "maxDate", selected);
            getTrips();
        }
    });

	$.ajax({
	        url: '<%=request.getContextPath()%>/TripBasedReportAction.do?param=getVehicleStoreId',
	        success: function(result) {
	            regNoList = JSON.parse(result);
	            for (var i = 0; i < regNoList["VehicleRoot"].length; i++) {
                    $('#vehicleNo').append($("<option></option>").attr("value", regNoList["VehicleRoot"][i].VehicleId)
                    .text(regNoList["VehicleRoot"][i].VehicleId));
	            }
	            $('#vehicleNo').select2();
			}
		});
	function getTrips (){
		$.ajax({
        url: '<%=request.getContextPath()%>/TripBasedReportAction.do?param=getTripNames',
        data: {
        	startDate: $('#trip-start-date').val(),
			endDate: $('#trip-end-date').val()
        },
        success: function(result) {
        console.log(result);
            tripNoList = JSON.parse(result);
            for (var i = 0; i < tripNoList["tripRoot"].length; i++) {
                   $('#tripName').append($("<option></option>").attr("value", tripNoList["tripRoot"][i].tripId)
                   .attr("assetNo", tripNoList["tripRoot"][i].assetNo)
                   .attr("startDate", tripNoList["tripRoot"][i].startDate)
                   .attr("endDate", tripNoList["tripRoot"][i].endDate)
                   .text(tripNoList["tripRoot"][i].tripName));
            }
            $('#tripName').select2();
		}
	});
	}
	
		
	$('#tripName').change(function() {
	   var vehicleNo = $('#tripName option:selected').attr("assetNo");
	   var startD = new Date($('#tripName option:selected').attr("startDate"));
	   var endD = new Date($('#tripName option:selected').attr("endDate"));
	   console.log($('#tripName option:selected').attr("startDate")+" , "+$('#tripName option:selected').attr("endDate"));
	   console.log(startD+" , "+endD);
	   $('#vehicleNo').val(vehicleNo).trigger('change');
	   
       //$("#vehicleNo").val('HR55AC0608');
       $("#dateInput1").jqxDateTimeInput({
	        formatString: 'dd/MM/yyyy HH:mm:ss',
	        value: startD
	    });
	    
	    $("#dateInput2").jqxDateTimeInput({
	        formatString: 'dd/MM/yyyy HH:mm:ss',
	        value: endD
	    });
     
    });
    function getGridData(){
    
		 regno = $("#vehicleNo").val();
    	 if(document.getElementById("vehicleNo").value == ""){
    	 	sweetAlert("Please select Customer");
		    return;
    	 }else if (document.getElementById("dateInput1").value == ""){
			sweetAlert("Please select Start Date");
		    return;
		}else if(document.getElementById("dateInput2").value == ""){
			sweetAlert("Please select End Date");
		    return;
		}else{
			startDate = document.getElementById("dateInput1").value;
			endDate = document.getElementById("dateInput2").value;
			var dd = startDate.split("/");
	        var ed = endDate.split("/");
	        var parsedStartDate = new Date(dd[1] + "/" + dd[0] + "/" + dd[2]);
	        var parsedEndDate = new Date(ed[1] + "/" + ed[0] + "/" + ed[2]);
				if (parsedStartDate > parsedEndDate) {
		        	sweetAlert("End date should be greater than Start date");
		       	    document.getElementById("dateInput2").value = currentDate;
		       	    return;
		   		}
		}	
	var actualDurationHrs=0;
	var actualDurationMins=0;
	var actualDurationDays=0;
	var actualDurationSecs=0;
    $.ajax({
    type: "GET",
    url: '<%=request.getContextPath()%>/TripBasedReportAction.do?param=getstopReport',
    data: {
        startdate: startDate,
        enddate: endDate,
        regno: regno
    },
    success: function(result) {
        result = JSON.parse(result);
        result = result["StopReport"];
        let rows = [];
        $.each(result, function(i, item) {
                let row = {
                    "0": item.slno,
                    "1": item.startdate,
                    "2": item.enddate,
                    "3": (item.location === null || item.location === undefined)?"":item.location,
                    "4": item.latitude,
                    "5": item.longitude,
                    "6": item.duration
<!--                    "7": "<div class='location-icon'><a href='#'><img onclick= 'viewOnMap("+item.latitude+","+item.longitude+");' src='+/ApplicationImages/VehicleImagesNew/globe.jpg'/></a></div> "-->
                }
                rows.push(row); 
            	
                totalStr = item.durationNEW.toString().split(":");
                actualDurationDays = actualDurationDays + parseInt(totalStr[0], 10);
                var Hrs = totalStr[1];
                var Min = totalStr[2];
                var sec = totalStr[3];
                actualDurationSecs = actualDurationSecs + parseInt(sec);
                actualDurationHrs = actualDurationHrs + parseInt(Hrs);
                actualDurationMins = actualDurationMins + parseInt(Min);
            })

            if (actualDurationSecs >= 60) {
                actualDurationMins = actualDurationMins + parseInt(actualDurationSecs / 60);
                actualDurationSecs = parseInt(actualDurationSecs % 60);
            }
            if (actualDurationMins >= 60) {
                actualDurationHrs = actualDurationHrs + parseInt(actualDurationMins / 60);
                actualDurationMins = parseInt(actualDurationMins % 60);
            }
            if (actualDurationHrs >= 24) {
                actualDurationDays = actualDurationDays + parseInt(actualDurationHrs / 24);
                actualDurationHrs = parseInt(actualDurationHrs % 24);
            }
            if (actualDurationMins < 10) {
                actualDurationMins = "0" + actualDurationMins;
            }
            if (actualDurationHrs < 10) {
                actualDurationHrs = "0" + actualDurationHrs;
            }
            if (actualDurationDays < 10) {
                actualDurationDays = "0" + actualDurationDays;
            }
            document.getElementById("totalHrs").innerHTML = 'Total Stoppage (dd:hh:mm): '+actualDurationDays+":"+actualDurationHrs+":"+actualDurationMins;

    if ($.fn.DataTable.isDataTable("#speedReportTable")) {
        $('#speedReportTable').DataTable().clear().destroy();
    }

    tableN = $('#speedReportTable').DataTable({
        "scrollY": "300px",
        "scrollX": false,
        paging: false,
        "columnDefs": [
		    { "width": "50px", "targets": 0 },
		    { "width": "100px", "targets": 1 },
		    { "width": "100px", "targets": 2 },
		    { "width": "600px", "targets": 3 }
		],
        "oLanguage": {
            "sEmptyTable": "No data available"
        },
        dom: 'Bfrtip',
        buttons: [
            {
                extend: 'excel',
                text: 'Export to Excel',
                title: 'Stop Report  ' + startDate + " - " + endDate,
                className: 'btn btn-primary',
                exportOptions: {
                    columns: ':visible'
                }
            }
        ]
    });
    tableN.rows.add(rows).draw();
}
});
    }
  var map;
  function viewOnMap(lat ,lon) {
    $('#viewMapModal').modal('show');
    var pos = new L.LatLng(lat, lon);
  	initialize("dvMap", pos, '<%=mapName%>','<%=appKey%>','<%=appCode%>');
    setTimeout(function(){map.invalidateSize();},250);
	imageurl = '/ApplicationImages/VehicleImagesNew/MapImages/default_BR.png';
	image = L.icon({
        iconUrl: imageurl,
        iconSize: [30, 30], // size of the icon
        popupAnchor: [0, -15]
    });
	vehiclemarker = new L.Marker(pos, {
        icon: image
    }).addTo(map);
  }
</script>
   <jsp:include page="../Common/footer.jsp" />

 