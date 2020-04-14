 <%@ page language="java"
	import="java.util.*,t4u.functions.*,t4u.beans.*,t4u.common.*,t4u.GeneralVertical.*,t4u.util.*"
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
	CommonUtility cu = new CommonUtility();
			
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
	
	//int loggedInClientId = loginInfo.getClientId();
	
	String startDate1=cu.setPreviousDateForReports(offset);
	String endDate1 = cu.setCurrentDateForReports1(offset);
	
	String time1=cu.setCurrentDateForReports(offset);
	
	String timeStr[]=time1.split(":");
	
	String Hour=timeStr[0];
	String Min = timeStr[1];
	
	String startDateStr[] = startDate1.split("/");
	String endDateStr[] = endDate1.split("/");
	Properties properties=ApplicationListener.prop;
	String t4uspringappURL = properties.getProperty("t4uspringappURL").trim();
        //String t4uspringappURL1 =  "https://track-staging.dhlsmartrucking.com/t4uspringapp/";
		//String t4uspringappURL =  "http://localhost:8095/t4uspringapp/";
	 System.out.println(t4uspringappURL);
	 
%>
 <jsp:include page="../Common/header.jsp" />
 <jsp:include page="../Common/InitializeLeaflet.jsp" />
<link rel="stylesheet" href="https://code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css"/>
<link rel="stylesheet" href="https://cdn.datatables.net/1.10.16/css/dataTables.jqueryui.min.css"/>
<link rel="stylesheet" href="https://cdn.datatables.net/buttons/1.5.1/css/buttons.dataTables.min.css"/>
<link rel="stylesheet" href="https://cdn.datatables.net/1.10.16/css/dataTables.material.min.css"/>
<!--
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
-->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/tempusdominus-bootstrap-4/5.0.0-alpha18/css/tempusdominus-bootstrap-4.min.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-multiselect/0.9.13/css/bootstrap-multiselect.css">
<link rel="stylesheet" href="https://cdn.datatables.net/1.10.16/css/jquery.dataTables.min.css"/>
<link rel="stylesheet" href="https://cdn.datatables.net/fixedheader/3.1.3/css/fixedHeader.dataTables.min.css"/>
<link href="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.6-rc.0/css/select2.min.css" rel="stylesheet" />
<link rel="stylesheet" href="https://www.jqwidgets.com/public/jqwidgets/styles/jqx.base.css">
<link rel="stylesheet" href="https://www.jqwidgets.com/public/jqwidgets/styles/jqx.energyblue.css">
<link rel="stylesheet" href="https://www.jqwidgets.com/public/jqwidgets/styles/jqx.arctic.css">

	  <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.8.1/css/all.css" integrity="sha384-50oBUHEmvpQ+1lW4y57PTFmhCaXp0ML5d60M1M7uH2+nqUivzIebhndOJK28anvf" crossorigin="anonymous">

      <link href="../../Main/vendor/font-awesome/css/font-awesome.min.css" rel="stylesheet" type="text/css">

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
    margin:-16px -4px 100px -4px;
 	padding-bottom: 37px;
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
		   font-size: 20px;
		   padding: 12px;

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
   
   
   .modal-open .modal {
    /* overflow-x: hidden; */
    /* overflow-y: auto; */
}


.modal {

    position: fixed;
    top: 37%;
    left: 8%;
    z-index: 1050;
    width: 40px;
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
#exampleModal{
	background-color: transparent !important;
	 box-shadow:none;
	 webkit-box-shadow:none;
	   moz-box-shadow:none;
	    border: 0px;
	 border-box: none;
	
}
 h5 {
  font-size: 30px;
  color: #000;
  border-bottom: 1px solid ;
  padding-bottom: 5px;
}

#summaryDiv{
	width:50px;
bottom: -45px;
}

.leftCol{
	color:blue;
	font-size: 12px;
}
.dispNone{
  display:none;
}

#tripSelectId{
	margin-left:10px;
}

</style>
<div class="container-fluid" id="container-report-select">
   <div class="w3-card-4">
      <div class="card-body" style="padding:1em !important">
         <div class="hrStyle text-center" style="margin:-16px -24px 16px -24px;">Container Lock/Unlock History Report</div>
			<div class="row">
			<div class="col-lg-2">
			</div>

            <div class="col-sm-3 padCols" style="margin-top: 6px;margin-left: 10%">
               <label style= "font-size:11px;" for="report-types">Trip Name</label>
               <div>
                  <select class="form-control" id="tripName" onload="getTrips()">
                  		<option>Select Trip</option>
                  </select>
               </div>
            </div>
          <button class="btn btn-primary" style="background:#18519E;margin-top: 25px;padding-bottom:10px;margin-left:30px;width: 106px;height: 36px;" onclick = "getGridData();">View</button>
         
		 </div>

	<div class="row" id="loading-report" style="margin-left: 609px; display:none">
			<img src="../../Main/images/loading.gif" alt="">
	</div>
   <div class="row" style="margin-top:16px;margin-left:5px;margin-right:5px;">
	   <div class="col-lg-12" id="tableDiv" style="overflow: auto !important;width:100%;">
		  <table id="activityReportTable" class="table table-striped table-bordered" style="width:100%" cellspacing="0">
			 <thead>
				<tr>
					<th>Sl.No.</th>
                    <th>Vehicle No</th>
					<th>Trip No </th>
                    <th>Location </th>  
					<th>Customer Name</th> 										  
                    <th>Driver Name</th>
                    <th>Driver Contact</th>
                    <th>Unlock Request Time</th>
                    <th>Unlock Status</th>
                    <th>Requested CT User</th>
				</tr>
			 </thead>
		  </table>
	   </div>
	   </div>
 </div> 
</div>

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
	var regNo;
	var globalVehicleRawValue;
	var vehicleType;
	var timeBand;
	var startDateTime;
	var endDateTime;
	var serviceRecieverNew;
	var selectedVehicle;
	let t4uspringappURL = '<%=t4uspringappURL%>';
	
	if ('<%=systemId%>' != 268){
		//$('#criteria-unreg-vehicle').removeClass("dispNone");	
		$('#disc').removeClass("dispNone");	
		$('#registeredId').removeClass("dispNone");			
	} 
	
	var yesterdayDate = new Date(<%=startDateStr[2]%>, (<%=startDateStr[1]%> -1), <%=startDateStr[0]%>, <%=timeStr[0]%>, <%=timeStr[1]%>, 0, 0);
	var currentDate = new Date(<%=endDateStr[2]%>, (<%=endDateStr[1]%> -1), <%=endDateStr[0]%>, <%=timeStr[0]%>, <%=timeStr[1]%>, 0, 0);
	var tableN;

	var tripId =0;
   
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
getTrips();
function getTrips(){
	$('#loading-report').show();
		$.ajax({
			type:"GET",
			url: t4uspringappURL + 'tripsList',
			datatype:'json',
			contentType:"application/json",

        success: function(result) {
        //console.log("Trips are", result);
            tripNoList = result.responseBody;
			//console.log(tripNoList);
			
             for (var i = 0; i < tripNoList.length; i++) {
                   $('#tripName').append($("<option></option>")
				   .attr("value", tripNoList[i].tripNo)
                   .attr("vehicleNo", tripNoList[i].vehicleNo)
				   .attr("tripCreationTime", tripNoList[i].tripCreationTime)
                   .text(tripNoList[i].tripNo));
				 } 
            $('#tripName').select2();
			$('#loading-report').hide();
		}
	});
	}
	
		
	$('#tripName').change(function() {
	   var vehicleNo = $('#tripName option:selected').attr("vehicleNo");
		$('#vehicleNo').val(vehicleNo).trigger('change');
});
   function getGridData(){
	   selectedVehicle= $('#tripName option:selected').attr("vehicleNo");
		$("#tableDiv").removeClass("col-lg-9");
	  $("#tableDiv").addClass("col-lg-12");
      $("#tableDiv").show();
      $('#loading-report').show();
	  $("#tableDiv").show();
	
		
    $.ajax({
		type: "GET",
		url: t4uspringappURL + 'auditTableDetails?vehicleNo=' + $('#tripName option:selected').attr("vehicleNo") ,
		datatype:'json',
		contentType:"application/json",
  success: function(result) {
	  result = result.responseBody;
	    let rows = [];
        //console.log(result);
		let slno = 1;

       $.each(result, function(i, item) {
		let row = {
					"0": slno,
                    "1": item.vehicleNo==="" ? selectedVehicle :item.vehicleNo ,
                    "2": item.tripNo,
                    "3": item.location,
                    "4": item.customerName,
                    "5": item.driverName,
                    "6": item.driverContact,
					"7" : item.unlockRequestDateTime,	
					"8": item.unlockStatus,
					"9": item.requestedCTUser,
					//"10": item.lng
           }
				//geocodeLatLng(slno,item.lat,item.lng);
                rows.push(row); 
				slno++;
            })
			
			
    if ($.fn.DataTable.isDataTable("#activityReportTable")) {
        $('#activityReportTable').DataTable().clear().destroy();
    }

    tableN = $('#activityReportTable').DataTable({
        "scrollY": "300px",
        "scrollX": "300px",
        paging: false,
       
        "oLanguage": {
            "sEmptyTable": "No data available"
        },
        dom: 'Bfrtip',
        buttons: [
            {
                extend: 'excel',
                text: 'Export to Excel',
                title: 'Container Lock/Unlock History Report ' ,
                className: 'btn btn-primary',
                exportOptions: {
                    columns: ':visible'
                }
            }
        ]
    });
	if(rows.length > 0){
    tableN.rows.add(rows).draw();}
    $('#loading-report').hide();
}
});

}

function geocodeLatLng(slno,lat, lon) {
	fetch('https://reverse.geocoder.api.here.com/6.2/reversegeocode.json?prox=' + lat + "," + lon + ',250&mode=retrieveAddresses&maxresults=1&gen=9&app_id=' + '<%=appKey%>' + '&app_code=' + '<%=appCode%>').then(function (response) {
		resp = response.json();
		return resp;
	}).then(function (json) {
		//console.log('geocode:: ',json);
		if ('error' in json) {
			//alert("address not found");
		}
		district = "";
		var cntry = json.Response.View[0].Result[0].Location.Address.AdditionalData[0].value.replace(/[0-9]/g, '');
		var stat = json.Response.View[0].Result[0].Location.Address.AdditionalData[1].value.replace(/[0-9]/g, '');
		district = json.Response.View[0].Result[0].Location.Address.AdditionalData[2].value.replace(/[0-9]/g, '');
		var cty = "";
		if ('City' in json.Response.View[0].Result[0].Location.Address) {
			cty = json.Response.View[0].Result[0].Location.Address.City.replace(/[0-9]/g, '')
		} else if ('village' in json.address) {
			cty = json.address.village.replace(/[0-9]/g, '')
		} else if ('hamlet' in json.address) {
			cty = json.address.hamlet.replace(/[0-9]/g, '')
		} else if ('town' in json.address) {
			cty = json.address.town.replace(/[0-9]/g, '')
		} else {
			cty = "";
		}
		var locationSmartLock = cty+','+district+','+stat+','+cntry
		$("#loc"+slno).html(locationSmartLock);
		$("#ulRowDataSummary").appendTo('<li class="second"><div class="row"><div class="col-lg-4"><strong>Current Location: </strong></div><div class="col-lg-8">' + locationSmartLock + '</div></div></li>');
	return locationSmartLock;
	})
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
  
  function closeSummaryDiv(){
      $("#summaryDiv").hide("slow");
      $("#summaryDiv").removeClass("col-lg-3");
	  $("#tableDiv").removeClass("col-lg-9");
	  $("#tableDiv").addClass("col-lg-12");
  }
  function getSummaryDetails(){
	  $("#summaryDiv").show("slow");
	  $("#summaryDiv").addClass("col-lg-3");
	  $("#tableDiv").removeClass("col-lg-12");
	  $("#tableDiv").addClass("col-lg-9");
  
    regno = $("#vehicleNo").val();
    	 if(document.getElementById("vehicleNo").value == "Select Vehicle"){
			  //$("#summaryDiv").hide();
			   $("#tableDiv").hide();
			 sweetAlert("Please select VehicleNo");
		    return;
		 }
	startDate = document.getElementById("dateInput1").value;
	endDate = document.getElementById("dateInput2").value;
    if(document.getElementById("vehicleNo").value == ""){
    	 	sweetAlert("Please select Customer");
		 return;
	}else{
  
	  $.ajax({
		   url	  :'<%=request.getContextPath()%>/TripBasedReportAction.do?param=getSummaryDetailsStore',
	 data: {
        globalClientId: <%=customerId%> ,
        globalVehicleId: regno,
        globalVehicleRawValue: regno,
        globalTripId: tripId,
        vehicleType: vehicleType ,
        timeBand: timeBand,
        startDateTime: startDate,
        endDateTime: endDate,
        SelectedClientName: ""
    },
     success: function(result) {
     result = JSON.parse(result);
    // console.log("summaryDetails",result);
     result = result["SummaryDetailsRoot"];
      //console.log("summaryDetailsRoot",result);
	  $("#unitNo").html(result[0].unitNumber);
	  $("#totalStopDuration").html(result[0].totalStopDuration);
	  $("#totalIdleDuration").html(result[0].totalIdleDuration); 
	  $("#averageSpeedexcludingstops").html(result[0].averageSpeedExcludingStop+" kmph");
	  $("#numberOfOverspeed").html(result[0].numberOfOverSpeed);
	  $("#maxSpeed").html(result[0].maxSpeed+" kmph");
	  $("#engineHours").html(result[0].engineHours);
	  $("#nwLoss").html(result[0].nwloss);
	  $("#durationSelected").html(result[0].durationSelected);
	  $("#totalNumberOfStops").html(result[0].totalNoOfStops);
	  $("#totalNumberOfIdle").html(result[0].totalNoOfIdle);
	  $("#averageSpeedincludingstops").html(result[0].averageSpeedIncludingStop+" kmph");
	  $("#distanceTravelledwithOverspeed").html(result[0].distanceTravelledWithOverSpeed+" kms");
	  $("#travelTime").html(result[0].travelTime);
	  $("#totalDistanceTravelled").html(result[0].totalDistanceTravelled+" kms");
	  $("#fuelConsumed").html(result[0].FuelConsumed);
	 }
  })	
 
  }}
  
  
  
</script>
   <jsp:include page="../Common/footer.jsp" />

 