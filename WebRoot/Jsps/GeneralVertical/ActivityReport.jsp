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
	 
%>
 <jsp:include page="../Common/header.jsp" />

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


</style>
<div class="container-fluid" id="container-report-select">
   <div class="w3-card-4">
      <div class="card-body" style="padding:1em !important">
         <div class="hrStyle text-center" style="margin:-16px -24px 16px -24px;">Vehicle Activity Report</div>
		 
		 
		 
         <div class="row">
			<div class="col-sm-3" id="criteria-vehicle">
				<label class="radio-inline">
				  <input type="radio" id="tripRadio" value="trip" name="optradio">&nbsp;&nbsp;&nbsp;<span id="tripWise" style="font-size: 12px;">Trip Wise</span>
				</label>
            </div>
            <div class="col-sm-2 padCols" id="sd"  " style="margin-top: -13px;">
               <label style= "font-size:11px;" for="report-start-date">Start Date</label>
               <input type="text" style="padding:6px;" id="trip-start-date" class="form-control form-control-custom">
            </div>
            <div class="col-sm-2 padCols" id="ed" style="margin-top: -13px;">
               <label style= "font-size:11px;" for="report-end-date">End Date</label>
               <input type="text" style="padding:6px;" id="trip-end-date" class="form-control form-control-custom" >
            </div>
            <div class="col-sm-2 padCols" style="margin-top: -13px;    margin-right: 123px;">
               <label style= "font-size:11px;" for="report-types">Trip Name</label>
               <div>
                  <select class="form-control"  width="200" style="width: 180px" id="tripName">
                  		<option>Select Trip</option>
                  </select>
               </div>
            </div>
			
        </div>
         <div class="row">
		 
			<div class="col-sm-3">
			 
					<div   id="criteria-vehicle" style="margin-top: 21px;">
						<label class="radio-inline">
						  <input type="radio" id="vehRadio" checked onclick="handleTripVehRadioClick()" value="vehicle" name="optradio">&nbsp;&nbsp;&nbsp;<span style="font-size: 12px;">Vehicle Wise <span id="registeredId" class="dispNone">(Registered)</span></span>
						</label>
					</div>
				   
				 
					<div   id="criteria-unreg-vehicle" style="margin-top: 21px;" class="dispNone">
						<label class="radio-inline">
						  <input type="radio" id="unregVehRadio"  onclick="getUnregistredVehicles()" value="unregVehicle" name="optradio">&nbsp;&nbsp;&nbsp;<span style="font-size: 12px;">Vehicle Wise (UnRegistered)</span>
						</label>
					</div>
			 
						
			</div>
			
			 <div  class="col-sm-2 padCols" style="margin-top: 4px;">
               <label style= "font-size:11px;" for="report-types">Vehicle No</label>
               <div>
                  <select class="form-control" id="vehicleNo">
                  		
                  </select>
               </div>
            </div>
			
            <div class="col-sm-2 padCols" id="sd" style="margin-top: 4px;">
               <label style= "font-size:11px;" for="report-start-date">Start Date</label>
               <input type="text" style="padding:6px;" id="dateInput1" class="form-control form-control-custom" name="reportStartDate" >
            </div>
            <div class="col-sm-2 padCols" id="ed" style="margin-top: 4px;">
               <label style= "font-size:11px;" for="report-end-date">End Date</label>
               <input type="text" style="padding:6px;" id="dateInput2" class="form-control form-control-custom" name="reportEndDate">
            </div>
            <div class="col-sm-3 padCols" id="cv" style="margin-top: 20px;">
               <div class="row" id="row-criteria" style="padding-left: 10px;">
                  <div class="col-sm-2" style ="display:none">
                     <label for="select-criteria-trip">Driver Name</label>
                     <input type="text" class="form-control form-control-custom" id="driverName">
                  </div>
                  
         </div>
      </div>
   </div>
   
      <div class="row">
			<div class="col-sm-3 padCols" style="margin-top: -2px;margin-left: 25%;">
               <label style= "font-size:11px;" >Category Name</label>
               <div>
                  <select class="form-control" width="200" style="width: 181px" id="category" >
                  		<option value="All">ALL</option>
						<option value="Stoppage">STOPPAGE</option>
						<option value="Idle">IDLE</option>
						<option value="Running">RUNNING</option>
                  </select>
               </div>
            </div>
			
			
			<div class="col-sm-2" style="margin-right:-103px">
                     <button class="btn btn-primary" style="background:#18519E;margin-top: 22px;padding-bottom:10px;margin-left: -104px;width: 106px;height: 36px;" onclick = "getGridData();">View</button>
                  </div>
				  
				  <div class="col-sm-2">
				  
                     <button type="button" class="btn btn-primary" style="background:#18519E;margin-top: 22px;height: 36px;"  onclick = "getSummaryDetails();">Summary</button>
     
	<div class="modal fade" id="exampleModal" tabindex="-1" role="dialog" aria-labelledby="SummaryDetailsLabel" aria-hidden="true">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="SummaryDetailsLabel"><b>SummaryDetails</b></h5>
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
		</div>
           <div class="modal-body">
                <div class="row" >
                    <div class="col-md-6">
                     Unit No : 
                    </div>
                    <div class="col-md-6">
                       Total Stop Duration : 
                    </div>
					<div class="col-md-6">
                        Total Idle Duration : 
                    </div>
                    <div class="col-md-6">
                          Average Speed (excluding stops) : 
                    </div>
					<div class="col-md-6">
                         Number Of Overspeed : 
                    </div>
                    <div class="col-md-6">
                         Max Speed : 
                    </div>
					<div class="col-md-6">
                          Engine Hours :  
                    </div>
                    <div class="col-md-6">
                         N/W Loss :  
                    </div>
					<div class="col-md-6">
                          Duration Selected :  
                    </div>
                    <div class="col-md-6">
                         Total Number Of Stop : 
                    </div>
					<div class="col-md-6">
                          Total Number Of Idle  : 
                    </div>
                    <div class="col-md-6">
                          Average Speed (including stops) : 
                    </div>
					<div class="col-md-6">
                          Distance Travelled with Overspeed : 
                    </div>
                    <div class="col-md-6">
                         Travel Time :  
                    </div>
					<div class="col-md-6">
                          Total Distance Travelled :  
                    </div>
                    <div class="col-md-6">
                          Fuel Consumed :
                    </div>
                </div>
	        </div>
	   </div>
  </div>
<!--                  <div class="col-sm-8">-->
<!--                     <h5 id="totalHrs" style="margin-top: 35px;font-size: 14px;color: red;margin-left: 10px;">Total Stoppage(dd:hh:mm): </h5>-->
<!--                  </div>-->
               </div>
            </div>
			
			
			
			</div>
   
   
   <div class="row">

		<div id ="disc"class="col-sm-12 dispNone" style="margin-top: 15px;">

			<div class="dis" style="font-size: 16px;">
			<span> Disclaimer !!! Data for vehicles which are unregistred in past 30 days are being shown here.</span>
			</div>
		</div>
	</div>
	
	<div class="row" id="loading-report" style="margin-left: 609px; display:none">
			<img src="../../Main/images/loading.gif" alt="">
	</div>
   <div class="row" style="margin-top:16px;">
	   <div class="col-lg-12" id="tableDiv" style="overflow: auto !important;">
		  <table id="activityReportTable" class="table table-striped table-bordered" cellspacing="0">
			 <thead>
				<tr>
				   <th>SL. No</th>
				   <th>Date Time</th>
				   <th>Location</th>
				   <th>Latitude</th>
				   <th>Longitude</th>
				   <th>Speed (Kmph)</th>
				   <th>Stoppage Time (hh:mm)</th>
				   <th>Idle Time (hh:mm)</th>
				   <th>Category</th>
				   <th>Odometer</th>
					<th>Distance Travelled (Kmph)</th>
				</tr>
			 </thead>
		  </table>
	   </div>
	   <div style="display:none;border:1px solid black !important;height: 374px;
  " id="summaryDiv" >
	   <div onclick="closeSummaryDiv()">
	   <h5 class="modal-title">Summary
	   <button type="button" class="close" aria-label="Close">
  <span aria-hidden="true">&times;</span>
</button>
</h5>
<div>
<table>
<div class="row">
                    <div class="col-md-12">
                    <span class="leftCol">Unit No : </span><span id='unitNo' style="font-size: 12px;"><i class="fas fa-spinner fa-spin" style="color:#red;"></i></span>
                    </div>
                    <div class="col-md-12">
                    <span class="leftCol">Total Stop Duration : </span><span id='totalStopDuration'style="font-size: 12px;"><i class="fas fa-spinner fa-spin" style="color:#red;"></i></span>
                    </div>
					<div class="col-md-12">
                    <span class="leftCol">Total Idle Duration : </span><span id='totalIdleDuration'style="font-size: 12px;"><i class="fas fa-spinner fa-spin" style="color:#red;"></i></span>
                    </div>
                    <div class="col-md-12">
                    <span class="leftCol">Average Speed (excluding stops) : </span><span id='averageSpeedexcludingstops'style="font-size: 12px;"><i class="fas fa-spinner fa-spin" style="color:#red;"></i></span>
                    </div>
                    <div class="col-md-12">
                    <span class="leftCol">Max Speed : </span><span id='maxSpeed'style="font-size: 12px;"> <i class="fas fa-spinner fa-spin" style="color:#red;"></i></span>
                    </div>
					<div class="col-md-12">
                    <span class="leftCol">Engine Hours : </span><span id='engineHours'style="font-size:12px;"><i class="fas fa-spinner fa-spin" style="color:#red;"></i></span>
                    </div>
                    <div class="col-md-12">
                    <span class="leftCol">N/W Loss : </span><span id='nwLoss'style="font-size: 12px;"><i class="fas fa-spinner fa-spin" style="color:#red;"></i></span>
                    </div>
					<div class="col-md-12">
                    <span class="leftCol">Duration Selected : </span><span id='durationSelected'style="font-size: 12px;"><i class="fas fa-spinner fa-spin" style="color:#red;"></i></span>
                    </div>
                    <div class="col-md-12">
                    <span class="leftCol">Total Number Of Stops : </span><span id='totalNumberOfStops'style="font-size: 12px;"><i class="fas fa-spinner fa-spin" style="color:#red;"></i></span>
                    </div>
					<div class="col-md-12">
                    <span class="leftCol">Total Number Of Idle : </span><span id='totalNumberOfIdle'style="font-size: 12px;"><i class="fas fa-spinner fa-spin" style="color:#red;"></i></span>
                    </div>
                    <div class="col-md-12">
                    <span class="leftCol">Average Speed (including stops) : </span><span id='averageSpeedincludingstops'style="font-size: 12px;"><i class="fas fa-spinner fa-spin" style="color:#red;"></i></span>
                    </div>
                    <div class="col-md-12">
                    <span class="leftCol">Travel Time : </span><span id='travelTime'style="font-size: 12px;"><i class="fas fa-spinner fa-spin" style="color:#red;";"></i></span>
                    </div>
					<div class="col-md-12">
                    <span class="leftCol">Total Distance Travelled : </span><span id='totalDistanceTravelled'style="font-size: 12px;"><i class="fas fa-spinner fa-spin" style="color:#red;";"></i></span>
                    </div>
                </div>
</div>
</div>
</table>
	 
	   </div>
   </div>
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
	var regNo;
	var globalVehicleRawValue;
	var vehicleType;
	var timeBand;
	var startDateTime;
	var endDateTime;
	var serviceRecieverNew;
	
	if ('<%=systemId%>' != 268){
		$('#criteria-unreg-vehicle').removeClass("dispNone");	
		$('#disc').removeClass("dispNone");	
		$('#registeredId').removeClass("dispNone");			
	} 
	
	var yesterdayDate = new Date(<%=startDateStr[2]%>, (<%=startDateStr[1]%> -1), <%=startDateStr[0]%>, <%=timeStr[0]%>, <%=timeStr[1]%>, 0, 0);
	var currentDate = new Date(<%=endDateStr[2]%>, (<%=endDateStr[1]%> -1), <%=endDateStr[0]%>, <%=timeStr[0]%>, <%=timeStr[1]%>, 0, 0);
	var tableN;

	var tripId =0;
   
   $(document).ready(function () {
   $("#dateInput1").jqxDateTimeInput({ theme: "arctic", formatString: "dd/MM/yyyy HH:mm:ss", showTimeButton: true, width: '100%', height: '25px', max: new Date()});
   $('#dateInput1 ').jqxDateTimeInput('setDate', yesterdayDate);
   $("#dateInput2").jqxDateTimeInput({ theme: "arctic", formatString: "dd/MM/yyyy HH:mm:ss", showTimeButton: true, width: '100%', height: '25px', max: currentDate});
   $('#dateInput2 ').jqxDateTimeInput('setDate', currentDate);
   
	handleTripVehRadioClick();
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
	 
	 
	 function handleTripVehRadioClick(){
		  $('#loading-report').show();
		 $('#vehicleNo').select2().empty();
			$.ajax({
				url: '<%=request.getContextPath()%>/TripBasedReportAction.do?param=getVehicleStoreId',
				success: function(result) {
					$('#vehicleNo').select2().empty();
					regNoList = JSON.parse(result);
					$('#vehicleNo').append($("<option></option>").attr("value", 0).text("--Select Vehicle---"));
					for (var i = 0; i < regNoList["VehicleRoot"].length; i++) {
						$('#vehicleNo').append($("<option></option>").attr("value", regNoList["VehicleRoot"][i].VehicleId)
						.text(regNoList["VehicleRoot"][i].VehicleId));
					}
					$('#vehicleNo').select2();
					$('#loading-report').hide();
				}
		});
	 }
		
	
	
	function getUnregistredVehicles(){
		$('#loading-report').show();
		$('#vehicleNo').select2().empty();
		$.ajax({
		 url: '<%=request.getContextPath()%>/TripBasedReportAction.do?param=getUnRegisterdVehicles',
	        success: function(result) {
	            regNoList = JSON.parse(result);
				$('#vehicleNo').append($("<option></option>").attr("value", 0).text("--Select Unreg Vehicle---"));
	            for (var i = 0; i < regNoList["UnRegisterdVehiclesRoot"].length; i++) {
                    $('#vehicleNo').append($("<option></option>").attr("value", regNoList["UnRegisterdVehiclesRoot"][i].vehicleNo)
                    .text(regNoList["UnRegisterdVehiclesRoot"][i].vehicleNo));
	            }
	            $('#vehicleNo').select2();
				$('#loading-report').hide();
			}
			});
	}
	
	function getTrips(){
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
	  $("#summaryDiv").addClass("col-lg-3");
	  $("#tableDiv").removeClass("col-lg-9");
	  $("#tableDiv").addClass("col-lg-12");
	  
           $("#tableDiv").show();
            $("#summaryDiv").hide();
		 regno = $("#vehicleNo").val();
    	 if(document.getElementById("vehicleNo").value == "Select Vehicle"){
			 sweetAlert("Please select VehicleNo");
		    return;
    	 }else if(document.getElementById("vehicleNo").value == 0){
			 sweetAlert("Please select VehicleNo");
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
		$('#loading-report').show();
		 $("#tableDiv").show();
		 category = document.getElementById("category").value;
    $.ajax({
    type: "GET",
    url: '<%=request.getContextPath()%>/TripBasedReportAction.do?param=getActivityReportData',
    data: {
        startdate: startDate,
        enddate: endDate,
        regno: regno,
        category:category
    },
    success: function(result) {
        result = JSON.parse(result);
        result = result["ActivityReportDetailsRoot"];
        let rows = [];
        console.log(result);
        $.each(result, function(i, item) {
                let row = {
                    "0": item.slno,
                    "1": item.dateTimeDataIndex,
                    "2": (item.locationDataIndex == null || item.locationDataIndex == undefined)? "":item.locationDataIndex,
                    "3": item.latitudeIndex,
                    "4": item.longitudeIndex,
                    "5": item.speedDataIndex,
                    "6": item.stoppageTimeDataIndex,
                    "7": item.idleTimeDataIndex,
                    "8": item.categoryDataIndex,
                    "9": item.cumuOdoDataIndex,
					"10": item.distanceTravelledDataIndex
                }
                rows.push(row); 
            })

    if ($.fn.DataTable.isDataTable("#activityReportTable")) {
        $('#activityReportTable').DataTable().clear().destroy();
    }

    tableN = $('#activityReportTable').DataTable({
        "scrollY": "300px",
        "scrollX": "300px",
        paging: false,
        "columnDefs": [
		    { "width": "50px", "targets": 0 },
		    { "width": "100px", "targets": 1 },
		    { "width": "199px", "targets": 2 },
		    { "width": "50px", "targets": 3 },
		    { "width": "50px", "targets": 4 },
		    { "width": "30px", "targets": 5 },
		    { "width": "50px", "targets": 6 }
		],
        "oLanguage": {
            "sEmptyTable": "No data available"
        },
        dom: 'Bfrtip',
        buttons: [
            {
                extend: 'excel',
                text: 'Export to Excel',
                title: 'Activity Report  ' + startDate + " - " + endDate,
                className: 'btn btn-primary',
                exportOptions: {
                    columns: ':visible'
                }
            }
        ]
    });
    tableN.rows.add(rows).draw();
    $('#loading-report').hide();
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
			  $("#summaryDiv").hide();
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
     console.log("summaryDetails",result);
     result = result["SummaryDetailsRoot"];
      console.log("summaryDetailsRoot",result);
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
  
  $('input[type=radio][name=optradio]').change(function() {
	  if($("#tripRadio").is(":checked")){
		  $("#vehicleNo").prop("disabled", true);
		  $('#dateInput1').jqxDateTimeInput({disabled: true});
		  $('#dateInput2').jqxDateTimeInput({disabled: true});
		  $("#trip-start-date").datepicker( "option", "disabled", false );
		  $("#trip-end-date").datepicker( "option", "disabled", false );
		  $("#tripName").prop("disabled", false);
		  handleTripVehRadioClick();
		  
	  }else if ($("#vehRadio").is(":checked")){
		  $("#vehicleNo").prop("disabled", false);
		  $('#dateInput1').jqxDateTimeInput({disabled: false});
		  $('#dateInput2').jqxDateTimeInput({disabled: false});
		  $("#trip-start-date").datepicker( "option", "disabled", true );
		  $("#trip-end-date").datepicker( "option", "disabled", true );
		  $("#tripName").prop("disabled", true);
		  
	  }else if ($("#unregVehRadio").is(":checked")){
		  $("#vehicleNo").prop("disabled", false);
		  $("#dateInput1").prop("disabled", false);
		  $("#dateInput2").prop("disabled", false);
		  $("#trip-start-date").datepicker( "option", "disabled", true );
		  $("#trip-end-date").datepicker( "option", "disabled", true );
		  $("#tripName").prop("disabled", true);
	  }
  })
 
  
</script>
   <jsp:include page="../Common/footer.jsp" />

 