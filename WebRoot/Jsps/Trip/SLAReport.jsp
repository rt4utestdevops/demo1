<%@ page language="java" import="java.util.*,t4u.functions.CommonFunctions,t4u.beans.*,t4u.common.*" pageEncoding="ISO-8859-1"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
LoginInfoBean loginInfo=(LoginInfoBean)session.getAttribute("loginInfoDetails");
if(loginInfo==null){
	response.sendRedirect(request.getContextPath()+ "/Jsps/Common/SessionDestroy.html");
}
else
{
%>

<jsp:include page="../Common/header.jsp" />
<script>$(document).prop('title', 'SLA Report');</script>
		<link rel="stylesheet" href="https://code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css"/>
		<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
		<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/tempusdominus-bootstrap-4/5.0.0-alpha18/css/tempusdominus-bootstrap-4.min.css">
		<link rel="stylesheet" href="../../Main/sweetAlert/sweetalert.css">

	  <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
	  <script src="https://ajax.aspnetcdn.com/ajax/jquery.validate/1.11.1/jquery.validate.min.js"></script>
      <script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
	  <script src="../../Main/sweetAlert/sweetalert.min.js"></script>
	  <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
      <script src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.21.0/moment.min.js"></script>
      <script src="https://cdnjs.cloudflare.com/ajax/libs/tempusdominus-bootstrap-4/5.0.0-alpha18/js/tempusdominus-bootstrap-4.min.js"></script>
      <script src="https://use.fontawesome.com/releases/v5.0.9/js/all.js" integrity="sha384-8iPTk2s/jMVj81dnzb/iFR2sdA7u06vHJyyLlAd4snFpCl/SnyUjRrbdJsw1pGIl" crossorigin="anonymous"></script>
    
<style>
	.panel-primary {
		width: 50% !important;
		margin-left:25%;
	}
	.btn {
		
		border: none;
		color: white;
		cursor: pointer;
		font-size: 16px;
	}
	.btn:hover {
		background-color: RoyalBlue;
	}
	.form-control {
		width: 40% !important;
		display: inline !important;
	}
	#page-loader{
	  position:fixed;
	  left: 0%;
	  top: 35%;
	  z-index: 1000;
	  width:100%;
	  height:100%;
	  background-position:center;
	  z-index:10000000;
	  opacity: 0.7;
	  filter: alpha(opacity=40); /* For IE8 and earlier */
	}
</style>	
<button type="button" class="btn btn-info"  title="Help Option" class="btn btn-primary btn-sm" style="float: right;" onclick="helpingServlet();">
						<span class="glyphicon glyphicon-question-sign"></span>
</button>
<span  title="Report Columns Setting" style="float: right;margin-right: 1%;visibility: hidden;" >-</span>
 <!-- <button type="button" class="btn btn-info" data-toggle="collapse" style="float: right;" data-target="#demo">User Settings</button> -->
 <button type="button" class="btn btn-info"  style="float: right;"  onClick="showUserTableSetting()" >User Settings</button>
<div class="panel panel-primary">
    <div class="panel-heading">
        <h3 class="panel-title">SLA Report</h3>
	</div>
    <div class="panel-body" style="padding-top: 0px;">
			
				<div class="col-sm-12 col-md-12 col-lg-12 padCols" style="padding: 1%;">
					<label for="report-start-date">START DATE</label>
                    <input type="text" style="padding:6px;" id="report-start-date" class="form-control form-control-custom" name="reportStartDate"  >
			    </div>
			
				<div class="col-sm-12 col-md-12 col-lg-12 padCols" style="padding: 1%;">
					<label for="report-end-date">END DATE</label>
                    <input type="text" style="padding:6px;margin-left:16px;" id="report-end-date" class="form-control form-control-custom" name="reportEndDate"  >
				</div>
			
			
			<div class="col-sm-4 col-md-4 col-lg-4" style="padding: 1%; margin-left: 44%;">
			<button id="submmitBtn" class="btn" style="background-color: DodgerBlue;" onclick="downloadExcel()"><i class="fa fa-download"></i> Export to Excel (Trip Details)</button>
			</div>
			
			<div class="col-sm-4 col-md-4 col-lg-4" style="padding: 1%; margin-left: 44%;">
			<button id="submmitBtn" class="btn" style="background-color: DodgerBlue;" onclick="downloadLegWiseExcel()"><i class="fa fa-download"></i> Export to Excel (Leg Details)</button>
			</div>
   
    </div>
    
    <div class="alert alert-info" >
    <strong>Note:</strong> Maximum 7 days report can download.</br>
    Please make sure pop ups are enabled on your browser
    </div>

    <div id="disclimer" class="alert alert-warning" style="display:none">
    <strong>Info!</strong> Please wait your report is downloading
     . This will take few seconds to download.
    </div>
  
     <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12 text-center">
       			<div id="page-loader" style="margin-top:10px;display:none;">
				 <img src="../../Main/images/loading.gif" alt="loader" />
				</div>
 	</div>
	
		<div id="columnSetting" class="modal-content modal fade" style="margin-top:1%;width:100%;margin-top:0%;top: -270px;height:510px;overflow:hidden !important">
                        <div class="modal-header">
                            <div class="secondLine" style="display:flex; justify-content:space-between; align-items:baseline;">
                                <h4 id="columnSettingTitle" class="modal-title" style="text-align:left; margin-left:10px;">Column Settings</h4>
                            </div>
							
                            
                        </div>
                        <div class="modal-body" style="overflow-y: auto;">
                            <b>Check the items you want to display.</b>
                            <br/>
                            <input type="checkbox" name="select-all" id="select-all" />Select All
                            <ul id="sortable" style="overflow-x:hidden;overflow-y:scroll;height:300px;">
                            </ul>
                        </div>
                        <div class="modal-footer" style="text-align: center; height:52px;">
                            <input onclick="createOrUpdateListViewColumnSetting()" type="button"  class="btn btn-success" id="columnSettingSave" value="Save" />
                            <button type="reset" class="btn btn-danger" data-dismiss="modal">Close</button>
                        </div>
		</div>
	
	
</div>





<script>
 var columns = [
				"Sl. No.",																																																																																																																																																																																																																																																												
		"Trip Creation Time",																																																																																																																																																																																																																																																												
		"Trip Creation Month",																																																																																																																																																																																																																																																												
		"Trip ID",																																																																																																																																																																																																																																																												
		"Trip No.",																																																																																																																																																																																																																																																												
		"Trip Type",																																																																																																																																																																																																																																																												
		"Trip Category",																																																																																																																																																																																																																																																												
		"Route ID",																																																																																																																																																																																																																																																												
		"Make of Vehicle",																																																																																																																																																																																																																																																												
		"Type of Vehicle",																																																																																																																																																																																																																																																												
		"Vehicle Number",																																																																																																																																																																																																																																																												
		"Customer Type",																																																																																																																																																																																																																																																												
		"Customer Name",																																																																																																																																																																																																																																																												
		"Customer Reference ID",																																																																																																																																																																																																																																																												
		"Driver 1 Name",																																																																																																																																																																																																																																																												
		"Driver 1 Contact",																																																																																																																																																																																																																																																												
		"Driver 2 Name",																																																																																																																																																																																																																																																												
		"Driver 2 Contact",																																																																																																																																																																																																																																																												
		"Driver 3 Name",																																																																																																																																																																																																																																																												
		"Driver 3 Contact",																																																																																																																																																																																																																																																												
		"Driver 4 Name",																																																																																																																																																																																																																																																												
		"Driver 4 Contact",																																																																																																																																																																																																																																																												
		"Driver 5 Name",																																																																																																																																																																																																																																																												
		"Driver 5 Contact",																																																																																																																																																																																																																																																												
		"Driver 6 Name",																																																																																																																																																																																																																																																												
		"Driver 6 Contact",																																																																																																																																																																																																																																																												
		"Location",																																																																																																																																																																																																																																																												
		"Route Key",																																																																																																																																																																																																																																																												
		"Origin Hub",																																																																																																																																																																																																																																																												
		"Destination Hub",																																																																																																																																																																																																																																																												
		"Origin City",		
		"Source Pincode",																																																																																																																																																																																																																																																										
		"Origin State",																																																																																																																																																																																																																																																												
		"Destination City",	
		"Destination Pincode",																																																																																																																																																																																																																																																											
		"Destination State",																																																																																																																																																																																																																																																												
		"STP",																																																																																																																																																																																																																																																												
		"ATP",																																																																																																																																																																																																																																																												
		"Placement Delay (HH:mm:ss)",																																																																																																																																																																																																																																																												
		"Origin Hub Stoppage Allowed (HH:mm:ss)",																																																																																																																																																																																																																																																												
		"Origin Hub Stoppage Actual Duration (HH:mm:ss)",																																																																																																																																																																																																																																																												
		"Origin Hub (Loading) Detention (HH:mm:ss)",																																																																																																																																																																																																																																																												
		"STD",																																																																																																																																																																																																																																																												
		"ATD",																																																																																																																																																																																																																																																												
		"Departure Delay wrt STD (HH:mm:ss)",																																																																																																																																																																																																																																																												
		"Planned Transit Time (incl. planned stoppages) (HH:mm:ss)",																																																																																																																																																																																																																																																												
		"Touching Point 1",																																																																																																																																																																																																																																																												
		"Touching Point 1 Stoppage Allowed (HH:mm:ss)",																																																																																																																																																																																																																																																												
		"Touching Point 1 Stoppage Actual Duration (HH:mm:ss)",																																																																																																																																																																																																																																																												
		"Touching Point 1 Detention (HH:mm:ss)",																																																																																																																																																																																																																																																												
		"Touching Point 2",																																																																																																																																																																																																																																																												
		"Touching Point 2 Stoppage Allowed (HH:mm:ss)",																																																																																																																																																																																																																																																												
		"Touching Point 2 Stoppage Actual Duration (HH:mm:ss)",																																																																																																																																																																																																																																																												
		"Touching Point 2 Detention (HH:mm:ss)",																																																																																																																																																																																																																																																												
		"Touching Point 3",																																																																																																																																																																																																																																																											
		"Touching Point 3 Stoppage Allowed (HH:mm:ss)",																																																																																																																																																																																																																																																												
		"Touching Point 3 Stoppage Actual Duration (HH:mm:ss)",																																																																																																																																																																																																																																																												
		"Touching Point 3 Detention (HH:mm:ss)",																																																																																																																																																																																																																																																												
		"Touching Point 4",																																																																																																																																																																																																																																																												
		"Touching Point 4 Stoppage Allowed (HH:mm:ss)",																																																																																																																																																																																																																																																												
		"Touching Point 4 Stoppage Actual Duration (HH:mm:ss)",																																																																																																																																																																																																																																																												
		"Touching Point 4 Detention (HH:mm:ss)",																																																																																																																																																																																																																																																												
		"Touching Point 5",																																																																																																																																																																																																																																																												
		"Touching Point 5 Stoppage Allowed (HH:mm:ss)",																																																																																																																																																																																																																																																												
		"Touching Point 5 Stoppage Actual Duration (HH:mm:ss)",																																																																																																																																																																																																																																																												
		"Touching Point 5 Detention (HH:mm:ss)",																																																																																																																																																																																																																																																												
		"Touching Point 6",																																																																																																																																																																																																																																																												
		"Touching Point 6 Stoppage Allowed (HH:mm:ss)",																																																																																																																																																																																																																																																												
		"Touching Point 6 Stoppage Actual Duration (HH:mm:ss)",																																																																																																																																																																																																																																																												
		"Touching Point 6 Detention (HH:mm:ss)",																																																																																																																																																																																																																																																												
		"Touching Point 7",																																																																																																																																																																																																																																																												
		"Touching Point 7 Stoppage Allowed (HH:mm:ss)",																																																																																																																																																																																																																																																												
		"Touching Point 7 Stoppage Actual Duration (HH:mm:ss)",																																																																																																																																																																																																																																																												
		"Touching Point 7 Detention (HH:mm:ss)",																																																																																																																																																																																																																																																												
		"STA wrt STD",																																																																																																																																																																																																																																																												
		"STA wrt ATD",																																																																																																																																																																																																																																																												
		"ETA",																																																																																																																																																																																																																																																												
		"Next touching point",																																																																																																																																																																																																																																																												
		"Distance to next touching point",																																																																																																																																																																																																																																																												
		"ETA to next touching point",																																																																																																																																																																																																																																																												
		"ATA",																																																																																																																																																																																																																																																												
		"Actual Transit Time incl. planned and unplanned stoppages (HH:mm:ss)",																																																																																																																																																																																																																																																												
		"Transit Delay (HH:mm:ss)",		
		"Trip Close/Canceled Time",																																																																																																																																																																																																																																																										
		"Trip Status",																																																																																																																																																																																																																																																												
		"Reason for Delay",																																																																																																																																																																																																																																																												
		"Reason for Cancellation",																																																																																																																																																																																																																																																												
		"Destination Hub Stoppage Allowed (HH:mm:ss)",																																																																																																																																																																																																																																																												
		"Destination Hub Stoppage Actual Duration (HH:mm:ss)",																																																																																																																																																																																																																																																												
		"Destination Hub (Unloading) Detention (HH:mm:ss)",																																																																																																																																																																																																																																																												
		"Total In-transit Planned Customer Hub Stoppage Allowed (HH:mm:ss)",																																																																																																																																																																																																																																																												
		"Total In-transit Planned Customer Hub Stoppage Actual Duration (HH:mm:ss)",																																																																																																																																																																																																																																																												
		"Total In-transit Planned Customer Hub Stoppage Detention (HH:mm:ss)",																																																																																																																																																																																																																																																												
		"Total In-transit Planned SmartHub Stoppage Allowed (HH:mm:ss)",																																																																																																																																																																																																																																																												
		"Total In-transit Planned SmartHub Stoppage Actual Duration (HH:mm:ss)",																																																																																																																																																																																																																																																												
		"Total In-transit Planned SmartHub Stoppage Detention (HH:mm:ss)",																																																																																																																																																																																																																																																												
		"Unplanned Stoppage (HH:mm:ss)",																																																																																																																																																																																																																																																												
		"Total Truck Running Time (HH:mm:ss)",																																																																																																																																																																																																																																																												
		"Ops Dry Run (kms)",																																																																																																																																																																																																																																																												
		"Customer Dry Run (kms)",																																																																																																																																																																																																																																																												
		"Trip Distance (kms)",																																																																																																																																																																																																																																																												
		"Total Distance (kms)",																																																																																																																																																																																																																																																												
		"Average Speed (kms/h)",																																																																																																																																																																																																																																																												
		"Fuel Consumed(L)",																																																																																																																																																																																																																																																												
		"LLS Mileage (kms/L)",																																																																																																																																																																																																																																																												
		"OBD Mileage (kms/L)",																																																																																																																																																																																																																																																												
		"Temperature required",	
		"Temp @ Reefer(Actual Temperature at ATA (°C))",																																																																																																																																																																																																																																																												
		"Temp @ Middle(Actual Temperature at ATA (°C))",																																																																																																																																																																																																																																																												
		"Temp @ Door(Actual Temperature at ATA (°C))",	
		"Reefer(GREEN-BAND) - Temp Duration % (% of actual transit time)",																																																																																																																																																																																																																																																												
		"Middle(GREEN-BAND) - Temp Duration % (% of actual transit time)",																																																																																																																																																																																																																																																													
		"Door(GREEN-BAND) - Temp Duration % (% of actual transit time)",																																																																																																																																																																																																																																																													
		"Reefer(YELLOW-BAND) - Temp Duration % (% of actual transit time)",																																																																																																																																																																																																																																																												
		"Middle(YELLOW-BAND) - Temp Duration % (% of actual transit time)",																																																																																																																																																																																																																																																													
		"Door(YELLOW-BAND) - Temp Duration % (% of actual transit time)",
		"Reefer(RED-BAND) - Temp Duration % (% of actual transit time)",																																																																																																																																																																																																																																																												
		"Middle(RED-BAND) - Temp Duration % (% of actual transit time)",																																																																																																																																																																																																																																																													
		"Door(RED-BAND) - Temp Duration % (% of actual transit time)",
		"Precooling  Setup Time",
		"Precooling Achieved Time",
		"Time to Achieve Precooling (HH:mm:ss)",
	 ];
$(document).ready(function() {

    var todayTimeStamp = +new Date; // Unix timestamp in milliseconds
    var oneDayTimeStamp = 1000 * 60 * 60 * 24; // Milliseconds in a day
    var diff = todayTimeStamp - (oneDayTimeStamp * 29);
    var yesterdayDate = new Date(diff);
    var today = new Date(todayTimeStamp);

    var date1 = new Date();
    date1.setFullYear(today.getFullYear(), (today.getMonth()), today.getDate());
    var date2 = new Date();
    date2.setFullYear(yesterdayDate.getFullYear(), (yesterdayDate.getMonth()), yesterdayDate.getDate());

    $("#report-start-date").datepicker({
        dateFormat: 'dd/mm/yy',
        onSelect: function(selected, event) {
            $("#report-end-date").datepicker("option", "minDate", selected);
            setTimeout(function() {
                $("#report-end-date").datepicker('show');
            }, 10);
        }
    });
    $("#report-end-date").datepicker({
        dateFormat: 'dd/mm/yy',
        onSelect: function(selected) {
            $("#report-start-date").datepicker("option", "maxDate", selected)
        }
    });


});


function downloadExcel() {
    var startDate = document.getElementById('report-start-date').value;
    var endDate = document.getElementById('report-end-date').value;
    var dateRange = startDate + '-' + endDate;
    var dateDiff = monthValidation(startDate, endDate);
    var dayDiff = dateValidation(startDate, endDate);

    if (!dayDiff) {
        sweetAlert("Start Date should be greater than End Date");
        return;
    }
    if (!dateDiff) {
        sweetAlert("Date Range should not exceeds 7 days");
        return;
    } else {
        $('#submmitBtn').prop('disabled', true);
        $('#report-start-date').prop('disabled', true);
        $('#report-end-date').prop('disabled', true);
        document.getElementById("page-loader").style.display = "block";
        document.getElementById("disclimer").style.display = "block";

        $.ajax({
            type: "POST",
            url: '<%=request.getContextPath()%>/UtilizationReportsAction.do?param=getSlaReport',
            data: {
                startDate: startDate.split("/").reverse().join("-"),
                endDate: endDate.split("/").reverse().join("-")

            },
            success: function(responseText) {
                document.getElementById("page-loader").style.display = "none";
                document.getElementById("disclimer").style.display = "none";
                $('#submmitBtn').prop('disabled', false);
                $('#report-start-date').prop('disabled', false);
                $('#report-end-date').prop('disabled', false);
                if (responseText != "Failed to Download Report") {
                    window.open("<%=request.getContextPath()%>/LegDetailsExport?relativePath=" + responseText);
                    //  document.getElementById("page-loader").style.display="none";
                } else {
                    //document.getElementById("page-loader").style.display="none";
                }
            }
        });
    }

}

function downloadLegWiseExcel() {
    var startDate = document.getElementById('report-start-date').value;
    var endDate = document.getElementById('report-end-date').value;
    var dateRange = startDate + '-' + endDate;
    var dateDiff = monthValidation(startDate, endDate);
    var dayDiff = dateValidation(startDate, endDate);

    if (!dayDiff) {
        sweetAlert("Start Date should be greater than End Date");
        return;
    }
    if (!dateDiff) {
        sweetAlert("Date Range should not exceeds 7 days");
        return;
    } else {
        $('#submmitBtn').prop('disabled', true);
        $('#report-start-date').prop('disabled', true);
        $('#report-end-date').prop('disabled', true);
        document.getElementById("page-loader").style.display = "block";
        document.getElementById("disclimer").style.display = "block";

        $.ajax({
            type: "POST",
            url: '<%=request.getContextPath()%>/UtilizationReportsAction.do?param=getSlaLegWiseReport',
            data: {
                startDate: startDate.split("/").reverse().join("-"),
                endDate: endDate.split("/").reverse().join("-")

            },
            success: function(responseText) {
                document.getElementById("page-loader").style.display = "none";
                document.getElementById("disclimer").style.display = "none";
                $('#submmitBtn').prop('disabled', false);
                $('#report-start-date').prop('disabled', false);
                $('#report-end-date').prop('disabled', false);
                if (responseText != "Failed to Download Report") {
                    window.open("<%=request.getContextPath()%>/LegDetailsExport?relativePath=" + responseText);
                    //  document.getElementById("page-loader").style.display="none";
                } else {
                    //document.getElementById("page-loader").style.display="none";
                }
            }
        });
    }

}

function dateValidation(date1, date2) {
    var dd = date1.split("/");
    var ed = date2.split("/");
    var startDate = new Date(dd[1] + "/" + dd[0] + "/" + dd[2]);
    var endDate = new Date(ed[1] + "/" + ed[0] + "/" + ed[2]);
    if (endDate >= startDate) {
        return true;
    } else {
        return false;
    }
}

function monthValidation(date1, date2) {
    var dd = date1.split("/");
    var ed = date2.split("/");
    var startDate = new Date(dd[1] + "/" + dd[0] + "/" + dd[2]);
    var endDate = new Date(ed[1] + "/" + ed[0] + "/" + ed[2]);
    var timeDiff = Math.abs(endDate.getTime() - startDate.getTime());
    var daysDiff = Math.ceil(timeDiff / (1000 * 3600 * 24));
    if (daysDiff <= 06) {
        return true;
    } else {
        return false;
    }
}

function helpingServlet() {
	 	window.open("<%=request.getContextPath()%>/HelpDocumentServlet?FileName=SLA Field Logics.pdf");
 } 
 
              function showUserTableSetting() {
                                $('#columnSetting').modal('show');
                                $('#sortable').empty();
                                var pageName = "SLA_REPORT";
                                $.ajax({
                                    url: "<%=request.getContextPath()%>/CommonAction.do?param=getListViewColumnSetting",
									type: 'POST',
                                    data: {
                                        pageName: pageName
                                    },
                                    "dataSrc": "columnSettingsRoot",
                                    success: function(result) {
                                        var checkstatus = "unchecked";
                                        results = JSON.parse(result);
                                        if ((Number(results['columnSettingsRoot'].length) == Number(0))) {
                                            setDefaultUserColumnSetting();
                                            columnSettingAddOrModify = "ADD";
                                        } else {
                                            columnSettingAddOrModify = "UPDATE";
                                            for (var i = 0; i < results['columnSettingsRoot'].length; i++) {
                                                if (results['columnSettingsRoot'][i].visibility == 'true') {
                                                    checkstatus = "checked";
                                                } else {
                                                    checkstatus = "unchecked";
                                                }
                                                $("#sortable").append("<li class='second'><div class='checkbox'><input name='columnSetting' type='checkbox' " + checkstatus + " value='" + results['columnSettingsRoot'][i].id + "'/></div>" + results['columnSettingsRoot'][i].columnName + "</li>");
                                            }
                                        }
                                    }
                                });
                            }
							
							function setDefaultUserColumnSetting() {
                                for (var i = 0; i < columns.length; i++) {
                                    checkstatus = "checked";
                                    $("#sortable").append("<li class='second'><div class='checkbox'><input name='columnSetting' type='checkbox' " + checkstatus + " value='" + columns[i] + "' /></div>" + columns[i] + "</li>");
                                }
                            }
							
							 $('#select-all').click(function(event) {
                                if (this.checked) {
                                    // Iterate each checkbox
                                    $(':checkbox').each(function() {
                                        this.checked = true;
                                    });
                                } else {
                                    $(':checkbox').each(function() {
                                        this.checked = false;
                                    });
                                }
                            });
							

						function createOrUpdateListViewColumnSetting() {
                                if (columnSettingAddOrModify == "ADD") {
                                    createListViewColumnSetting()
                                } else if ((columnSettingAddOrModify == "UPDATE")) {
                                    updateListViewColumnSetting();
                                }
                            }
							
							function createListViewColumnSetting() {
                                var jsonObj = [];
                                var pageName = "SLA_REPORT";
                                $("input[name=columnSetting]").each(function() {
                                    item = {}
                                    item["columnName"] = $(this).val();
                                    item["visibility"] = this.checked;
                                    jsonObj.push(item);
                                });
                                document.getElementById("columnSettingSave").disabled = true;
                                var columnSettings = JSON.stringify(jsonObj);
                                $.ajax({
                                    url: "<%=request.getContextPath()%>/CommonAction.do?param=createListViewColumnSetting",
									type: 'POST',
                                    data: {
                                        columnSettings: columnSettings,
                                        pageName: pageName
                                    },
                                    success: function(result) {
                                        document.getElementById("columnSettingSave").disabled = false;
                                        setTimeout(function() {
                                            sweetAlert("Saved Successfully");
                                            $('#columnSetting').modal('hide');
                                        }, 1000);
                                    }
                                });
                            }
							
							 function updateListViewColumnSetting() {
                                var jsonObj = [];
                                $("input[name=columnSetting]").each(function() {
                                    item = {}
                                    item["id"] = $(this).val();
                                    item["visibility"] = this.checked;
                                    jsonObj.push(item);
                                });
                                document.getElementById("columnSettingSave").disabled = true;
                                var columnSettings = JSON.stringify(jsonObj);
                                $.ajax({
                                    url: "<%=request.getContextPath()%>/CommonAction.do?param=updateListViewColumnSetting",
									  type: 'POST',
                                    data: {
                                        columnSettings: columnSettings
                                    },
                                    success: function(result) {
                                        document.getElementById("columnSettingSave").disabled = false;
                                        setTimeout(function() {
                                            sweetAlert("Saved Successfully");
                                            $('#columnSetting').modal('hide');
                                        }, 1000);

                                    }
                                });
                            }
							
					
					
</script>

      
<jsp:include page="../Common/footer.jsp" />
<%}%>
