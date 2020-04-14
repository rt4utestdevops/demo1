<%@ page language="java"
	import="java.util.*,t4u.functions.CommonFunctions,t4u.beans.*,t4u.common.*"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://packtag.sf.net" prefix="pack"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";

CommonFunctions cf = new CommonFunctions();
	LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");

if(loginInfo != null){
			}
else
 {
 	response.sendRedirect(request.getContextPath()+ "/Jsps/Common/SessionDestroy.html");

 }
%>
<jsp:include page="../Common/header.jsp" />
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.datatables.net/1.10.16/css/dataTables.bootstrap.min.css">
    <link rel="stylesheet" href="https://ajax.googleapis.com/ajax/libs/jqueryui/1.11.1/themes/ui-darkness/jquery-ui.min.css" rel="stylesheet">
    <link href="../../Main/sweetAlert/sweetalert.css" rel="stylesheet">

    <script src="https://code.jquery.com/jquery-1.12.4.js"></script>
    <script src="https://cdn.datatables.net/1.10.16/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.datatables.net/1.10.16/js/dataTables.bootstrap.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
    <script src="../../Main/sweetAlert/sweetalert.min.js"></script>

        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
      <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-multiselect/0.9.13/css/bootstrap-multiselect.css">
      <link rel="stylesheet" href="../../Main/sweetAlert/sweetalert.css">
      <link href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" rel="stylesheet">
      <link href="https://cdn.datatables.net/1.10.16/css/dataTables.bootstrap.min.css" rel="stylesheet">
      <link href="https://cdn.datatables.net/fixedcolumns/3.2.3/css/fixedColumns.dataTables.min.css" rel="stylesheet">
      <link href="https://cdn.datatables.net/select/1.2.3/css/select.dataTables.min.css" rel="stylesheet"/>
      <link href="https://cdn.datatables.net/buttons/1.5.0/css/buttons.bootstrap.min.css" rel="stylesheet"/>
      <link href="../../Main/custom.css" rel="stylesheet" type="text/css">
      <link href="../../Main/bootstrap.css" rel="stylesheet" type="text/css">

      <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
      <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-multiselect/0.9.13/js/bootstrap-multiselect.min.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.1/js/select2.min.js"></script>
         <script src="https://cdnjs.cloudflare.com/ajax/libs/multiple-select/1.2.0/multiple-select.js"></script>
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
      <script src="../../Main/Js/markerclusterer.js"></script>
      <pack:script src="../../Main/adapter/ext/ext-base.js"></pack:script>
      <pack:script src="../../Main/Js/ext-all-debug.js"></pack:script>
      <pack:script src="../../Main/Js/Common.js"></pack:script>
      <pack:script src="../../Main/Js/MsgBox.js"></pack:script>
      <pack:script src="../../Main/Js/examples1.js"></pack:script>
      
<!--      <script src="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.1/js/select2.min.js"></script>-->
<!--      <link href="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.1/css/select2.min.css" rel="stylesheet" />-->

       <script src="https://www.jqwidgets.com/public/jqwidgets/jqx-all.js"></script>
	  <script src="https://www.jqwidgets.com/public/jqwidgets/globalization/globalize.js"></script>
	  <link rel="stylesheet" href="https://www.jqwidgets.com/public/jqwidgets/styles/jqx.base.css">
	  <link rel="stylesheet" href="https://www.jqwidgets.com/public/jqwidgets/styles/jqx.energyblue.css">
	  <link rel="stylesheet" href="https://www.jqwidgets.com/public/jqwidgets/styles/jqx.arctic.css">

 <style>

.well {
    min-height: 20px;
    padding: 19px;
    margin-bottom: 20px;
    background-color: #fff !important;
    border: 1px solid #333;
    border-radius: 4px;
    -webkit-box-shadow: inset 0 1px 1px rgba(0, 0, 0, .05);
    box-shadow: inset 0 1px 1px rgba(0, 0, 0, .05);
}

.value{
	text-align: center;
	color: coral;
	text-transform: uppercase;
}

.valuelive{
	text-align: center;
	color: #28bf28;
	text-transform: uppercase;
}


.headername
{
	text-align: center;
	font-weight: bold;
	font-size: 11px;
	font-variant: small-caps;

}

a {
    text-decoration: none !important;
}

body{
 background-color: #f5f5f5;
}

         .custom{
         padding-left: 15px;
         padding-right: 15px;
         margin-left: auto;
         margin-right: auto;
         padding-top: 10px;
         }

 .panel {
         margin-bottom: 5px;
         background-color: #fff;
         border: 1px solid #333 !important;
         border-radius: 4px;
         -webkit-box-shadow: 0 1px 1px rgba(0,0,0,.05);
         box-shadow: 0 1px 1px rgba(0,0,0,.05);

         }

		 .well {
    min-height: 20px;
    padding: 19px;
    margin-bottom: 20px;
    background-color: #fff !important;
    border: 1px solid #333;
    border-radius: 4px;
    -webkit-box-shadow: inset 0 1px 1px rgba(0, 0, 0, .05);
    box-shadow: inset 0 1px 1px rgba(0, 0, 0, .05);
}

.well {
    min-height: 160px !important;
    padding: 19px;
    margin-bottom: 20px;
    background-color: #f5f5f5;
    border: 1px solid #333 !important;
    border-radius: 4px;
    -webkit-box-shadow: inset 0 1px 1px rgba(0,0,0,.05);
    box-shadow: inset 0 1px 1px rgba(0,0,0,.05);
	height: 160px !important;
}


		 #routeList{
			 width:196.22px;
			 height: 34px;
		 }
		 #customerList{
			 width:196.22px;
			 height: 34px;
		 }


		 .form-control{
		 	 width: 196.22px;
			 height: 34px;
		 }
		 .open>.dropdown-menu {
		     display: block;
		     width: 200px;
		     height: 120px !important;
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
   
}
table {
  table-layout:fixed;
}
table td {
  word-wrap: break-word;
  max-width: 400px;
}

#orderTable2{
  white-space:inherit;
}
</style>

<!-- <nav class="navbar navbar-inverse"> -->
  <!-- <div class="container-fluid"> -->
    <!-- <div class="navbar-header"> -->
      <!-- <img src="DHL Logo.png" text="dhllogo">  -->
    <!-- </div> -->
    <!-- <ul class="nav navbar-nav"> -->
      <!-- <li class="active"><a href="#">EXECUTIVE VIEW STATIC</a></li> -->
      <!-- <li><a href="#">EXECUTIVE VIEW LIVE</a></li> -->
      <!-- <li><a href="#">SERVICE LEVEL DASHBOARD</a></li> -->
      <!-- <li><a href="#">SMART TRUCK HEALTH</a></li> -->
      <!-- <li><a href="#">SMART TRUCKER BEHAVIOR</a></li> -->
	  <!-- <li><a href="#">UTILIZATION</a></li>  -->
	  <!-- <li><a href="#">REPORTS</a></li> -->
    <!-- </ul> -->
  <!-- </div> -->
<!-- </nav> -->
 <br>

	<div class="custom" >
	 <div class="panel panel-primary">
      <div class="panel-heading">EXECUTIVE LIVE VIEW</div>
      <div class="panel-body">



               <div class="panel row" style="padding:1% ;margin: 0%;">
			   <div class="col-md-9">	

   				<div class="col-xs-12 col-md-4 ">
				<p>Select Customer: </p>
			     <select class="form-control" multiple="multiple" id="customerList"  onchange="getRouteList()"  >
				</select>
               </div>
               <div class="col-xs-12 col-md-4 ">
			   <p>Select Route: </p> 
			     <select class="form-control" multiple="multiple" id="routeList"   >
				</select>
               </div>
               <div class="col-xs-12 col-md-4 ">
			   <p>Select Product Line: </p> 
			     <select class="form-control" multiple="multiple" id="productLineComboId"  >
				</select>
               </div>   
              

   			   </div>

			  <div class="col-md-3">
			  <p> <br> </p> 
				<input type="submit" class="btn btn-success" onclick="loadDashboardData('custom')" style="border-radius:0px;" value="Submit"/>
			   </div>




			    </div>
<br>

	<div class="row">
        <div class="col-lg-4 col-sm-12 col-xs-12 col-md-6" >
        <a href="#" onClick="showDiv(1);">
          <div class="well" data-toggle="modal" data-target="">
           <h2 class="value" id="unAssignedCount">0</h2>
            <p class="headername">UNASSIGNED</p>
          </div>
       </a>
        </div>
        <div class="col-lg-4 col-sm-12 col-xs-12 col-md-6">
        <a href="#" onClick="showDiv2(4);">
		  <div class="well" data-toggle="modal" data-target="">
         	 <h2 class="valuelive" id="AssignedEnRouteCount">0</h2>
             <p class="headername">ASSIGNED, EN-ROUTE PLACEMENT</p>
          </div>
	  </a>
        </div>
        <div class="col-lg-4 col-sm-12 col-xs-12 col-md-6">
        <a href="#" onClick="showDiv2(5);">
          <div class="well" data-toggle="modal" data-target="">
           <h2 class="valuelive" id="assignedPlacedCount">0</h2>
            <p class="headername">ASSIGNED, PLACED</p>
          </div>
         </a>
        </div>
     </div>



	<div class="row">
       
		
			 <!-- <div class="col-lg-6 col-sm-12 col-xs-12 col-md-6">
			   <a href="#" onClick="showDiv(2);">
			  <div class="well" data-toggle="modal" data-target="">
			   <h2 class="value" id="idleCount">0</h2>
				<p class="headername">IDLE</p>
			 </div>
			 </a> 
			 </div> -->
			 <div class="col-lg-3 col-sm-12 col-xs-12 col-md-6" style="width:30%">
			 <a href="#" onClick="showDiv3(3);">
			  <div class="well" data-toggle="modal" data-target="">
			   <h2 class="value" id="underMaintainancecount">0</h2>
				<p class="headername">UNDER MAINTENANCE</p>
			 </div>
			 </a>
			</div>
		
		
        <div class="">
         <div id="page-loader" style="margin-top:10px;display:none;">
					<img src="../../Main/images/loading.gif" alt="" />
				</div>
        </div>
        
          
			 <div class="col-lg-3 col-sm-12 col-xs-12 col-md-6">
			 <a href="#" onClick="showDiv2(6);">
			  <div class="well" data-toggle="modal" data-target="">
			   <h2 class="valuelive" id="onTimeCount">0</h2>
				<p class="headername">ON-TIME</p>
			 </div>
			 </a>
			 </div>
			 <div class="	col-lg-3 col-sm-12 col-xs-12 col-md-6" style="width:30%">
			 <a href="#" onClick="showDiv2(7);">
			  <div class="well" >
			   <h2 class="value" id="delayedCount">0</h2>
				<p class="headername">DELAYED</p>
			  </div>
			  </a>
			</div>
			
			
			 <div class="col-lg-3 col-sm-12 col-xs-12 col-md-6" style="width:30%">
			  <a href="#" onClick="showDiv2(8);">
				  <div class="well" data-toggle="modal" data-target="">
				   <h2 class="value" id="heldAtCustCount">0</h2>
					<p class="headername">HELD AT CUST HUB</p>
			 
			 </a>
		 </div>
		</div>
        </div>
		</div>
     </div>

</div>
</div>

	 <div id="unAssigned" class="modal fade" style="margin-right: 2%;">
        <div class="" style="position: relative;left:2%;top: 44%;margin-top: -250px;width:90%;height:400px;">
            <div class="modal-content">
                <div class="modal-header">
                    <h4 id="tripDetailsTitle" class="modal-title" style="margin-bottom: -13px;">Vehicle Details</h4>
<button type="button" class="close" data-dismiss="modal">&times;</button>
							  </div>
                <div class="modal-body" style="max-height: 100%;">
                    <div class="row" style="margin-top:-9px;">
                    	<div class="col-lg-12 col-sm-12" style="border: solid  1px lightgray;  margin-top:-10px;">
                        	<table id="orderTable"  class="table table-striped table-bordered" cellspacing="0" width="100%">
			                	<thead>
		                    		<tr>
		                        		<th>Sl No</th>
		                        		<th>Vehicle No</th>
		                       	    <th>GPS Date</th>
		                       	    <th>Location</th>
		                       		</tr>
		                    	</thead>
		               		</table>
		               		<div>
                    			<p id="totalPanel"></p>
                    		</div>
                    	</div>
                  </div>
                </div>
                <div class="modal-footer"  style="text-align: right; height:52px;">
                    <button type="reset" class="btn btn-danger" data-dismiss="modal">Close</button>

                </div>
            </div>
        </div>
    </div>

    <div id="underMaintenance" class="modal fade" style="margin-right: 2%;">
        <div class="" style="position: relative;left:2%;top: 44%;margin-top: -250px;width:90%;height:400px;">
            <div class="modal-content">
                <div class="modal-header">
                    <h4 id="tripDetailsTitle" class="modal-title" style="margin-bottom: -13px;">Vehicle Details</h4>
										<button type="button" class="close" data-dismiss="modal">&times;</button>
								</div>
                <div class="modal-body" style="max-height: 100%;">
                    <div class="row" style="margin-top:-9px;">
                    	<div class="col-lg-12 col-sm-12" style="border: solid  1px lightgray;  margin-top:-10px;">
                        	<table id="orderTableForMaintenance"  class="table table-striped table-bordered" cellspacing="0" width="100%">
			                	<thead>
		                    		<tr>
		                        		<th>Sl No</th>
		                        		<th>Vehicle No</th>
		                        		<th>Start Date</th>
		                        	    <th>GPS Date</th>
		                        	    <th>Location</th>
		                        	    <th>Remarks</th>
		                        	    <th>Action</th>
		                       		</tr>
		                    	</thead>
		               		</table>
		               		<div>
                    			<p id="totalPanel"></p>
                    		</div>
                    	</div>
                  </div>
                </div>
                <div class="modal-footer"  style="text-align: right; height:52px;">
                    <button type="reset" class="btn btn-danger" data-dismiss="modal">Close</button>

                </div>
            </div>
        </div>
    </div>

	 	 <div id="orderTableModel2" class="modal fade" style="margin-right: 2%;"><!--modal-dialog-->
        <div class="" style="position: relative;left:2%;top: 44%;margin-top: -250px;width:90%;height:400px;">
            <div class="modal-content">
                <div class="modal-header">
									<h4 id="tripDetailsTitle" class="modal-title" style="margin-bottom: -13px;">Vehicle Details</h4>
                    <button type="button" class="close" data-dismiss="modal">&times;</button>

                </div>
                <div class="modal-body" style="max-height: 100%;">
                    <div class="row" style="margin-top:-9px;">
                    	<div class="col-lg-12 col-sm-12" style="border: solid  1px lightgray; margin-top:-10px;">
                        	<table id="orderTable2"  class="table table-striped table-bordered" cellspacing="0" width="100%">
			                	<thead>
		                    		<tr>
		                        		<th>Sl No</th>
		                        		<th>Customer Name</th>
		                        		<th>Route Name</th>
		                        		<th>Vehicle No</th>
		                        	    <th>GPS Date</th>
		                        	    <th>Location</th>

		                       		</tr>
		                    	</thead>
		               		</table>
		               		<div>
                    			<p id="totalPanel"></p>
                    		</div>
                    	</div>
                  </div>
                </div>
                <div class="modal-footer"  style="text-align: right; height:52px;">
                    <button type="reset" class="btn btn-danger" data-dismiss="modal">Close</button>

                </div>
            </div>
        </div>
    </div>

    <div id="closeMaintenance" class="modal fade" ><!--modal-dialog-->
         <div class="" style="position: absolute;left: 27%;top: 44%;margin-top: -250px;width:90%;">
            <div class="modal-content">
               <div class="modal-header
								 <h4 id="nome" class="modal-title">End Maintenance</h4>
                  <button type="button" class="close" data-dismiss="modal">&times;</button>

               </div>
               <div class="modal-body" style="max-height: 50%;margin-bottom: -35px;">
                  <div class="col-md-12">
                     <table class="table table-sm table-bordered table-striped">
                        <tbody>
                        <tr style="display:none;">
                              <td>Id<sup><font color="red">&nbsp;*</font></sup></td>
                              <td>
                                 <input class="form-control" id="selectedId"  disabled/ >
                              </td>
                           </tr>
                           <tr>
                              <td>Vehicle Number<sup><font color="red">&nbsp;*</font></sup></td>
                              <td>
                                 <input class="form-control" id="selectedVehicleId"  disabled/ >
                              </td>
                           </tr>
                           <tr>
                              <td>Start Date<sup><font color="red">&nbsp;*</font></sup></td>
                              <td>
                                 <input type='text' class="form-control"  id="selectedStartDate"  disabled />
                              </td>
                           </tr>

                           <tr>
                              <td>Remarks<sup><font color="red">&nbsp;*</font></sup></td>
                              <td><textarea type="text" class="form-control comboClass" maxLength="500" id="selectedRemarksId" rows="10" style="overflow:auto;resize:none"  disabled/></textarea></td>
                           </tr>

                            <tr>
                              <td>End Date<sup><font color="red">&nbsp;*</font></sup></td>
                              <td><input type="text" class="form-control" maxLength="500" id="dateInput2" /></td>
                           </tr>
                        </tbody>
                     </table>
                  </div>
               </div>
               <div class="modal-footer"  style="text-align: center;">
                  <input id="save1" onclick="saveEditedData()" type="button" class="btn btn-success" value="Save" />
                  <button type="reset" class="btn btn-danger" data-dismiss="modal">Cancel</button>
               </div>
            </div>
         </div>
      </div>

	<script type="text/javascript">

</script>
<script>
//history.pushState({ foo: 'fake' }, 'Fake Url', 'ExecutiveLiveView#');
 $(document).ready(function () {

 //  $("#dateInput1").jqxDateTimeInput({ theme: "arctic", formatString: "dd/MM/yyyy HH:mm:ss", showTimeButton: true, width: '50%', height: '25px' });
 //  $('#dateInput1 ').jqxDateTimeInput('setDate', new Date());
   $("#dateInput2").jqxDateTimeInput({ theme: "arctic", formatString: "dd/MM/yyyy HH:mm:ss", showTimeButton: true, width: '50%', height: '25px' });
   $('#dateInput2 ').jqxDateTimeInput('setDate', new Date());
	 getCustomerList();
});
</script>
<script type="text/javascript">
	function refresh (timeoutPeriod){
		refresh = setTimeout(function(){window.location.reload(true);},timeoutPeriod);
	}
</script>
<script type="text/javascript">
var call;
function loadDashboardData(call){

var client;
var routeId;
var productLine;


  		var custcombo = "";
        var routcombo = "";
        var productcombo = "";
        var custselected = $("#customerList option:selected");
        custselected.each(function () {
           custcombo += $(this).val() + ",";
         //   custcombo += $(this).attr('id')+ ",";
        });

        var selected = $("#routeList option:selected");
        selected.each(function () {
            routcombo += $(this).val() + ",";
        });
       
        
        var productSelected = $("#productLineComboId option:selected");
        productSelected.each(function () {
            productcombo += $(this).val() + ",";
        });

    var combo1= custcombo;//.split(",").join(",");
	var combo2= routcombo.split(",").join(",");
	var combo3= productcombo.split(",").join(",");
	

if(call=='default'){
  //$('#routeList').append('<option value="1"></option>');
  //$('#productLineComboId').append('<option value="ALL">ALL</option>');
  clientId='Select All';
  routeId=1;
 //productLine = 'ALL';
 productLine = 'Select All';

}else{
 clientId=combo1;//document.getElementById("customerList").value;
 routeId=combo2;//document.getElementById("routeList").value;
 productLine = combo3;//document.getElementById("productLineComboId").value;

}

if(clientId==0)
{
	sweetAlert("Please select Customer Name");
}
else if(routeId==0)
{
	sweetAlert("Please select Route");
}
else if(productLine=="")
{
	sweetAlert("Please select Product Line");
}
else {

 var param = {
//customerList:clientId,
//routeList: routeId,
//productLine : productLine
 			customerList:combo1,
            selectedRoute:combo2,
            productList:combo3           
        };
 document.getElementById("page-loader").style.display="block"; 

$.ajax({
        url: '<%=request.getContextPath()%>/tripDashBoardAction.do?param=getUnassignedVehicles',
        type : "POST",
        data: param,
        success: function(result) {
         document.getElementById("page-loader").style.display="none";

            var dashboard = JSON.parse(result);
            document.getElementById('unAssignedCount').innerHTML=dashboard['dashboardDetais'][0].UnAssignedCount;
            document.getElementById('AssignedEnRouteCount').innerHTML=dashboard['dashboardDetais'][0].EnroutementCount;
            //document.getElementById('idleCount').innerHTML=dashboard['dashboardDetais'][0].IdleCount;
            document.getElementById('assignedPlacedCount').innerHTML=dashboard['dashboardDetais'][0].assignedplacementcount;
            document.getElementById('underMaintainancecount').innerHTML=dashboard['dashboardDetais'][0].UnderMaintainanceCount;
            document.getElementById('onTimeCount').innerHTML=dashboard['dashboardDetais'][0].OntimeCount;
            document.getElementById('delayedCount').innerHTML=dashboard['dashboardDetais'][0].DelayedCount;
            document.getElementById('heldAtCustCount').innerHTML=dashboard['dashboardDetais'][0].DetentionCount;
        }

    });
    }  

}

function getCustomerList(){
var CustomerList;
var Customerarray = [];

$.ajax({

	        url: '<%=request.getContextPath()%>/tripDashBoardAction.do?param=getCustNamesForSLA',
	        success: function(response) {
	            custList = JSON.parse(response);
	            var $custName = $('#customerList');
	            var output = '';
	            for (var i = 0; i < custList["customerRoot"].length; i++) {
	                $('#customerList').append($("<option></option>").attr("value", custList["customerRoot"][i].CustId).text(custList["customerRoot"][i].CustName));
	            }
	            $('#customerList').multiselect({
	                nonSelectedText: 'ALL',
	                includeSelectAllOption: true,
	                enableFiltering: true,
	                enableCaseInsensitiveFiltering: true,
	                numberDisplayed: 1,
	                allSelectedText: 'ALL',
	                buttonWidth: 160,
	                maxHeight: 200,
	                includeSelectAllOption: true,
	                selectAllText: 'ALL',
	                selectAllValue: 'ALL',
	            });
	            $("#customerList").multiselect('selectAll', false)
	            $("#customerList").multiselect('updateButtonText');
				//getRouteListFirstTime();
				 getRouteList();
				getProductLine();
	        }
			 });


		// $.ajax({
		// type: "POST",
      // url: '<%=request.getContextPath()%>/tripDashBoardAction.do?param=getCustomerList',
          // success: function(result) {

                   // CustomerList = JSON.parse(result);
            // for (var i = 0; i < CustomerList["customeList"].length; i++) {
			// //Customerarray.push(CustomerList["customeList"][i].customerName)
			 // $('#customerList').append($("<option></option>").attr("value", CustomerList["customeList"][i].customerId).text(CustomerList["customeList"][i].customerName))
// //			 $('#customerList').append($("<option></option>").attr("value", CustomerList["customeList"][i].customerId).attr("id", CustomerList["customeList"][i].customerId).text(CustomerList["customeList"][i].customerName))
			// }
		// //	for (i = 0; i < Customerarray.length; i++) {
   			 // //$('#customerList').append('<option value='+Customerarray[i]+'>'+Customerarray[i]+'</option>')
   		// //	 $('#cust_names').append($("<option></option>").attr("value", custList["customerRoot"][i].CustId).text(custList["customerRoot"][i].CustName))
	     // //       }
	            
	           // $('#customerList').multiselect({
	            // nonSelectedText:'Select Customer',
 				// includeSelectAllOption: true,
 				 // numberDisplayed: 1
 				// });            
	            				// $("#customerList").multiselect('selectAll', false);
  				// $("#customerList").multiselect('updateButtonText');
	           						 // getRouteList();
			// }
			 // });
			// if(call=='default'){
 				//getRouteList();
 				//getProductLine();
		//	  loadDashboardData('default');
//}

 }

 function getRouteList(){

		var custcombo = [];
        var custselected = $("#customerList option:selected");
        custselected.each(function () {
           custcombo += $(this).val() + ",";
           // custcombo += $(this).attr('id')+ ",";
            
        });       

		var routeList;
		var routerarray = [];
		var customerName=custcombo;//document.getElementById("customerList").value;

		for (var i = document.getElementById("routeList").length -1; i >= 1; i--) {
	        document.getElementById("routeList").remove(i);
	    }
 		var param = {
				custList: customerName
        };
	//if(customerName.length > 0){
		
		$.ajax({
	        url: '<%=request.getContextPath()%>/tripDashBoardAction.do?param=getRouteNames',
	        success: function(response) {
	            routeName = JSON.parse(response);
	            var $routeList = $('#routeList');
	            var output = '';
	            $.each(routeName, function() {
	                $('<option value=' + this.routeId + '>' + this.routeName + '</option>').appendTo($routeList);
	            });
	            $('#routeList').multiselect({
	                nonSelectedText: 'ALL',
	                includeSelectAllOption: true,
	                enableFiltering: true,
	                enableCaseInsensitiveFiltering: true,
	                numberDisplayed: 1,
	                allSelectedText: 'ALL',
	                buttonWidth: 160,
	                maxHeight: 200,
	                selectAllText: 'ALL',
	                selectAllValue: 'ALL'
	            });
	            $("#routeList").multiselect('selectAll', false);
	            $("#routeList").multiselect('updateButtonText');

	        }
	    });
		//loadDashboardData();
	// }else{
			// $('#routeList').empty();
            // $('#routeList').multiselect('destroy'); 
	// }
	
 }

function getProductLine(){

for (var i = document.getElementById("productLineComboId").length -1; i >= 1; i--) {
	        document.getElementById("productLineComboId").remove(i);
	    }
var productArray = [];
	$.ajax({
	        url: '<%=request.getContextPath()%>/TripCreatAction.do?param=getProductLine',
	        data: {
	        	custId :0  // appending 0 as which is not using as param in query
	        },

	        success: function(result) {

	            productLineStore = JSON.parse(result);
	            for (var i = 0; i < productLineStore["productLineRoot"].length; i++) {
				productArray.push(productLineStore["productLineRoot"][i].productname)
				}
				for (i = 0; i < productLineStore["productLineRoot"].length; i++) {
	   			 var productname=productLineStore["productLineRoot"][i].productname;
	   			 $('#productLineComboId').append($("<option></option>").attr("value",productname).text(productname));
		            }
		            $('#productLineComboId').multiselect({
	            nonSelectedText:'Select Product Line',
 				includeSelectAllOption: true,
 				 numberDisplayed: 1
 				});
 				$("#productLineComboId").multiselect('selectAll', false);
  				$("#productLineComboId").multiselect('updateButtonText');
			}

		});
		setTimeout(function(){loadDashboardData('custom');},1000);
		
}

function showDiv(pageid)
{
 var orderTable;

   if ($.fn.DataTable.isDataTable('#orderTable')) {
           $('#orderTable').DataTable().destroy();
       }

   $('#unAssigned').modal('show');
   orderTable = $('#orderTable').DataTable({
		      	"ajax": {
		        	"url": "<%=request.getContextPath()%>/tripDashBoardAction.do?param=getPanalDetails",
		            "dataSrc": "TableDetails",
		            "data":{
		            	uniqueId : pageid
		            }
		        },
		        "bProcessing": true,
		        "sScrollX": "100%",
		        "sScrollY": "200px",
		        "bDestroy": true,
		        dom: 'Bfrtip',
		        "buttons": [{
                    extend: 'pageLength'
                }, {
                    extend: 'excel',
                    text: 'Export to Excel',
                    className: 'btn btn-primary',
					title: 'Vehicle Details'
                }, {
                    extend: 'pdf',
                    text: 'Export to PDF',
                    className: 'btn btn-primary',
					title: 'Vehicle Details'
                } ],
		        "oLanguage": {
       	 				"sEmptyTable": "No data available"
    			},
	        	"lengthChange":true,
		        "columns": [{
		        		"data": "slNoIndex"
		        	}, {
		                "data": "Vehicle_No"
		            }, {
		                "data": "Gps_Date"
		            }, {
		                "data": "Location"
		            }]
	 		});

}

function showDiv2(pageid)
{
 var orderTable2;

   if ($.fn.DataTable.isDataTable('#orderTable2')) {
           $('#orderTable2').DataTable().destroy();
       }

  // var clientId=document.getElementById("customerList").value;
//var routeId=document.getElementById("routeList").value;
//productLine = document.getElementById("productLineComboId").value;


  		var custcombo = "";
        var routcombo = "";
        var productcombo = "";
        var custselected = $("#customerList option:selected");
        custselected.each(function () {
            custcombo += $(this).val() + ",";
         //   custcombo += $(this).attr('id')+ ",";
        });

        var selected = $("#routeList option:selected");
        selected.each(function () {
            routcombo += $(this).val() + ",";
        });
       
        
        var productSelected = $("#productLineComboId option:selected");
        productSelected.each(function () {
            productcombo += $(this).val() + ",";
        });
    var clientId= custcombo;//.split(",").join(",");
	var routeId= routcombo.split(",").join(",");
	var productLine= productcombo.split(",").join(",");

if(clientId==0)
{
	sweetAlert("Please select Customer Name");
}
else if(routeId==0)
{
	sweetAlert("Please select Route");
}
else if(productLine=="")
{
	sweetAlert("Please select Product Line");
}
else {
 var param = {
customerList:clientId,
routeList: routeId,
productLine : productLine
        };
   $('#orderTableModel2').modal('show');
   orderTable2 = $('#orderTable2').DataTable({
		      	"ajax": {
		      	"type":'POST',
		        	"url": "<%=request.getContextPath()%>/tripDashBoardAction.do?param=getAssignedEnroutePlaceDetails",
		            "dataSrc": "TableDetails",
		            "data":{
		            	uniqueId : pageid,
		            	customerList:clientId,
						routeList: routeId,
						productLine : productLine
		            }
		        },
		        "processing": true,
		        "sScrollX": "100%",
		        "sScrollY": "200px",
		        "bDestroy": true,
		        dom: 'Bfrtip',
        		buttons: [
        		{
                    extend: 'pageLength'
                }, {
                    extend: 'excel',
                    text: 'Export to Excel',
                    className: 'btn btn-primary',
                    title: 'Vehicle Details'
                },
            	{
                extend: 'pdfHtml5',
                customize: function (doc) { doc.defaultStyle.fontSize = 8;
                //doc.styles.tableHeader.alignment = 'left'; 
        		doc.content[1].table.widths = [100,100,100,100,100,100,100,100];
                //doc.content[1].table.widths = 
        		//Array(doc.content[1].table.body[0].length + 1).join('10%').split('');
                //doc.styles.tableHeader.fontSize = 5;
                },
                orientation: 'landscape',
                pageSize: 'A4',
                alignment: 'center',
                text: 'Export to PDF',
                className: 'btn btn-primary',
                title: 'Vehicle Details'
            	}
        		],
		        "oLanguage": {
       	 				"sEmptyTable": "No data available"
    			},
	        	"lengthChange":true,
		        "columns": [{
		        		"data": "slNoIndex"
		        	}, {
		        		"data": "Customer_Name"
		        	}, {
		        		"data": "Route_Name"
		        	}, {
		                "data": "Vehicle_No"
		            }, {
		                "data": "Gps_Date"
		            }, {
		                "data": "Location"
		            }]
	 		});
	 }
}
function showDiv3(pageid)
{
 var orderTable;

   if ($.fn.DataTable.isDataTable('#orderTableForMaintenance')) {
           $('#orderTableForMaintenance').DataTable().destroy();
       }

   $('#underMaintenance').modal('show');
   orderTable = $('#orderTableForMaintenance').DataTable({
		      	"ajax": {
		        	"url": "<%=request.getContextPath()%>/tripDashBoardAction.do?param=getPanalDetails",
		            "dataSrc": "TableDetails",
		            "data":{
		            	uniqueId : pageid
		            }
		        },
		        "bProcessing": true,
		        "sScrollX": "100%",
		        "sScrollY": "200px",
		        "bDestroy": true,
		        dom: 'Bfrtip',
		        "buttons": [{
                    extend: 'pageLength'
                }, {
                    extend: 'excel',
                    text: 'Export to Excel',
                    className: 'btn btn-primary',
                    title: 'Vehicle Details'                    
                }, {
                    extend: 'pdf',
                    text: 'Export to PDF',
                    className: 'btn btn-primary',
                    title: 'Vehicle Details'
                } ],
		        "oLanguage": {
       	 				"sEmptyTable": "No data available"
    			},
	        	"lengthChange":true,
		        "columns": [{
		        		"data": "slNoIndex"
		        	}, {
		                "data": "Vehicle_No"
		            },{
		                "data": "startDate"
		            }, {
		                "data": "Gps_Date"
		            }, {
		                "data": "Location"
		            },{
		                "data": "remarks"
		            },  {
                    "data": "button"
                }]
	 		});

}

      function dateValidation(date1,date2) {
     var time1=date1.split(" ");
     var time2=date2.split(" ");
     var dd = date1.split("/");
     var ed = date2.split("/");
     var startDate = new Date(dd[1] + "/" + dd[0] + "/" + dd[2]+" "+time1[1]);
     var endDate = new Date(ed[1] + "/" + ed[0] + "/" + ed[2]+" "+time2[1]);
     if (endDate >= startDate )
	{
	  return true;
	}else{
	   return false;
	}
 }
     function saveEditedData() {

        var startDate = document.getElementById("selectedStartDate").value;
       // startDate.formatString("dd/MM/yyyy HH:mm:ss");
        var id = document.getElementById("selectedId").value;
        var vehicleNumber = document.getElementById("selectedVehicleId").value;
        var endDate = document.getElementById("dateInput2").value;
        var diff=dateValidation(startDate,endDate);
				var dd = startDate.split("/");
		        var ed = endDate.split("/");
		        var parsedStartDate = new Date(dd[1] + "/" + dd[0] + "/" + dd[2]);
		        var parsedEndDate = new Date(ed[1] + "/" + ed[0] + "/" + ed[2]);



        if (startDate == "") {
            sweetAlert("Please select Start Date");
            return;
        }

        if (endDate == "") {
            sweetAlert("Please Enter End Date");
            return;
        }
        if (parsedStartDate > parsedEndDate) {

			        	sweetAlert("End date should be greater than Start date");
			       	    return;
		}

        var param = {
            vehicleNumber: vehicleNumber,
            startDate: startDate,
            id: id,
            endDate : endDate,
        };
        $.ajax({
            url: '<%=request.getContextPath()%>/VehicleMaintenanceAction.do?param=endVehicleMaintenance',
            data: param,
            success: function(result) {
                if (result == "Saved Successfully") {
                    sweetAlert("Saved Successfully");

                } else {
                    sweetAlert("Not Saved");
                }

                $('#closeMaintenance').modal('hide');
                refresh(3000);
            }

        });
    }

 function openModal1(id, vehicleNumber, startDate,remarks, flag) {
    var vehicleNumber1 = vehicleNumber.split('^').join(' ');
    var remarks1 = remarks.split('^').join(' ');
     $(".modal-header #closeMaintenance").text("Close Maintenance");
     $('#closeMaintenance').modal('show');
   //   document.getElementById("selectedRemarksId").value = pTime;
      document.getElementById("selectedId").value = id;
      document.getElementById("selectedStartDate").value = startDate.replace("#"," ");
      document.getElementById("selectedVehicleId").value = vehicleNumber1;
      document.getElementById("selectedRemarksId").value = remarks1;
    }

</script>
<jsp:include page="../Common/footer.jsp" />
