<%@ page language="java" import="java.util.*,t4u.functions.CommonFunctions,t4u.beans.*,t4u.common.*,t4u.functions.*" pageEncoding="ISO-8859-1"%>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
    LoginInfoBean loginInfo=(LoginInfoBean)session.getAttribute("loginInfoDetails");
    if(loginInfo==null){
       response.sendRedirect(request.getContextPath()+ "/Jsps/Common/SessionDestroy.html");
    }
    boolean isCustLogin = false;
    GeneralVerticalFunctions gvf = new GeneralVerticalFunctions();
	int loginUserId=loginInfo.getUserId();
	int systemId = loginInfo.getSystemId();
	int custId= gvf.getUserAssociatedCustomerID(loginUserId,systemId);
	if(custId != 0) {isCustLogin = true;}
 	if(isCustLogin){
 	   response.sendRedirect(request.getContextPath()+ "/Jsps/Common/403Error.html");
 	}
    %>
<jsp:include page="../Common/header.jsp" />
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
</style>
<div class="container-fluid" id="container-report-select">
        <div class="w3-card-4">
            <div class="card-body" style="padding:1em !important">
                <div class="hrStyle text-center" style="margin:-16px -24px 16px -24px;">TCL Trips History Dashboard</div>
                <div class="row">
                    <div class="col-sm-3 padCols">
                        <label for="report-types">Customer Name</label>
                        <div id="custNameDiv">
                            <select class="form-control" id="custName"  multiple="multiple"></select>
                        </div>
                    </div>
                    <div class="col-sm-2 padCols" id="sd">
                        <label for="report-start-date">Start Date</label>
                        <input type="text" style="padding:6px;" id="report-start-date" class="form-control form-control-custom" name="reportStartDate" >
                    </div>
                    <div class="col-sm-2 padCols" id="ed">
                        <label for="report-end-date">End Date</label>
                        <input type="text" style="padding:6px;" id="report-end-date" class="form-control form-control-custom" name="reportEndDate">
                    </div>
                    <div class="col-sm-5 padCols" id="cv">
                        <div class="row" id="row-criteria" style="padding-left: 10px;">
                            <div class="col-sm-6">
                                <label for="select-criteria-trip">Trip Names</label>
                                <select class="form-control form-control-custom" id="select-criteria-trip" name="selectCriteriaTrip" multiple></select>
                            </div>
                            <div class="col-sm-6">
                                <button id="btn-report-submit" class="btn btn-primary" style="background:#18519E;margin-top:26px;padding-bottom:10px;margin-left: 65px;" onclick = "getGridData();">View Trips</button>
                                 <a href="javascript:void(0);" title="Download reports and graphs for the selected trips" target="_blank">
                                 	<img id="downloadBtn" src="/ApplicationImages/Download-Icon.png" style="vertical-align: bottom;width: 45px;margin-left: 10px;" onclick = "downloadAll();">
                                 </a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        
        <div style="overflow: auto !important;">
			<table id="reportTable" class="table table-striped table-bordered" cellspacing="0" width="100%">
           		<thead>
                 	<tr>
					<th>Sl. No</th>
					<th>TripId</th>
					<th>TripNo</th>
					<th>Customer Name</th>
					<th>Vehicle Number</th>
					<th>Trip ID</th>
					<th>Start Date</th>
					<th>End Date</th>
					<th>Status</th>
					<th>Download</th>
					</tr>
				</thead>
			</table>
		</div>
</div>
<div class="center-view dispNone" id="loading-report" style="margin-top:24px;">
    <img src="../../Main/images/loading.gif" alt="">
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
<script src="../../Main/sweetAlert/sweetalert-dev.js"></script>   
<script>
	function getReport(tripId,type) {
	    window.open("<%=request.getContextPath()%>/TemperatureServlet?tripId="+tripId+"&type="+type);
    }
    getTripCustomerType();
    function getReport1(tripId,type) 
    {
    $.ajax({
	        url: '<%=request.getContextPath()%>/TemperatureServlet?tripId='+tripId+'&type='+type,
	        success: function(result) {
	      	if(result=="success")
	      	{
	      	sweetAlert("Successfully updated on server");
	      	}
	      	else
	      	{
	      	sweetAlert("Failure in sending File");
	      	}
	        }
		});
    } 
    function getTripCustomerType() {
	$.ajax({
	        url: '<%=request.getContextPath()%>/TripCreatAction.do?param=getCustomerNames',
	        success: function(result) {
	            var addcustList = JSON.parse(result);
	             console.log(addcustList);
	            for (var i = 0; i < addcustList["customerRoot"].length; i++) {
		            if(addcustList["customerRoot"][i].CustId !='0'){
		              $('#custName').append($("<option></option>").attr("value", addcustList["customerRoot"][i].CustId).text(addcustList["customerRoot"][i].CustName));
		            }
	            }
                $('#custName').multiselect({
		            nonSelectedText:'Select Customer',
	 				includeSelectAllOption: true,
					enableFiltering: true,
					enableCaseInsensitiveFiltering: true,
	 				numberDisplayed: 1,
	 				cssClass:'form-control-custom'
	 				});
	 				$("#custName").multiselect('selectAll', true);
	  				$("#custName").multiselect('updateButtonText');
				}
		});
		}
		$("#report-start-date").datepicker({
              dateFormat: 'dd/mm/yy',
              timeFormat: "HH:mm:ss",
              onSelect: function(selected, event) {
                  $("#report-end-date").datepicker("option", "minDate", selected);
                  setTimeout(function(){$("#report-end-date").datepicker('show');},10);
                  getTrips();
              }
          });
          $("#report-end-date").datepicker({
              dateFormat: 'dd/mm/yy',
              timeFormat: "HH:mm:ss",
              onSelect: function(selected) {
                  $("#report-start-date").datepicker("option", "maxDate", selected);
                  getTrips();
              }
          });


var table;
var combo;
$('#custName').change(function() {
        var custcombo = "";       
        var custselected =$("#custName option:selected");
        
        custselected.each(function () {
            custcombo += $(this).val() + ",";
        });
		
		combo= custcombo.split(",").join(",");
	
		var custselected =$("#custName option:selected");
		getTrips();
});

                            
                                      function getTrips() {
          $('#select-criteria-trip').html('');
          $("#select-criteria-trip").multiselect('destroy');
          $.ajax({
	        url: '<%=request.getContextPath()%>/tripDashBoardAction.do?param=getTripsForCustomer',
	        data: {
                    startDate: $('#report-start-date').val(),
					endDate: $('#report-end-date').val(),
					tripCustId: combo
             },
	        success: function(result) {
	            tripList = JSON.parse(result);
	            for (var i = 0; i < tripList["tripRoot"].length; i++) {
                    $('#select-criteria-trip').append($("<option></option>").attr("value", tripList["tripRoot"][i].tripId).text(tripList["tripRoot"][i].tripName));
	            }
                $('#select-criteria-trip').multiselect({
		            nonSelectedText:'Select Trip',
	 				includeSelectAllOption: true,
					enableFiltering: true,
					enableCaseInsensitiveFiltering: true,
	 				numberDisplayed: 1,
	 				cssClass:'form-control-custom',
	 				allowClear: true
	 				})
	 				$("#select-criteria-trip").multiselect('selectAll', true);
	  				$("#select-criteria-trip").multiselect('updateButtonText');
				}
		});
		}
      function getGridData() {
    	var tripcombo = "";       
        var tripSelected =$("#select-criteria-trip option:selected");
        
        tripSelected.each(function () {
            tripcombo += $(this).val() + ",";
        });
		
		var combo= tripcombo.split(",").join(",");
	
    	 if(document.getElementById("custName").value == "") {
    	 	sweetAlert("Please select customer");
		    return;
    	 } else if (document.getElementById("select-criteria-trip").value == "") {
			sweetAlert("Please select trip");
		    return;
		}	
        else if (document.getElementById("report-start-date").value == "") {
			sweetAlert("Please select startdate");
		    return;
		}
		else if (document.getElementById("report-end-date").value == "") {
			sweetAlert("Please select enddate");
		    return;
		}
       if ($.fn.DataTable.isDataTable('#reportTable')) {
          $('#reportTable').DataTable().destroy();
      }
      table = $('#reportTable').DataTable({
         "ajax": {
             "url": '<%=request.getContextPath()%>/tripDashBoardAction.do?param=getTrips',
             "type":'POST',
             "data": {
					tripIds: combo
             },
             "dataSrc": "tripGridRoot"
         },
         "bLengthChange": false,
         "pageLength": 50,
         "columns": [{
             "data": "slno"
         }, {
             "data": "tripId"
         },{
             "data": "tripNo"
         },{
             "data": "custName"
         },{
             "data": "assetNo"
         },{ 
             "data": "tripName"
         },{
             "data": "startDate"
         },{
             "data": "endDate"
         },{
             "data": "status"
         },{
             "data": "export"
         }]
     });
     jQuery('.dataTable').wrap('<div class="dataTables_scroll" />');
     table.column( 1 ).visible( false );
    }

	function downloadAll() {
		var tripcombo = "";       
        var tripSelected =$("#select-criteria-trip option:selected");
        
        tripSelected.each(function () {
            tripcombo += $(this).val() + ",";
        });
		
		var tripComboDownload= tripcombo.split(",").join(",");
		var type = 3;
		var tripId = 0;

		window.open("<%=request.getContextPath()%>/TemperatureServlet?tripId="+tripId+"&type="+type+"&tripComboDownload="+tripComboDownload);
	}
   
   
</script>
<jsp:include page="../Common/footer.jsp" />
