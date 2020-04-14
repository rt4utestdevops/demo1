<%@ page language="java"
	import="java.util.*,t4u.functions.*,t4u.beans.*,t4u.common.*,t4u.GeneralVertical.*"
	pageEncoding="utf-8"%>
<%@ taglib uri="http://packtag.sf.net" prefix="pack"%>
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
	GeneralVerticalFunctions gvf = new GeneralVerticalFunctions();
	CreateTripFunction ctf=new CreateTripFunction();
	cf.checkLoginInfo((LoginInfoBean) session.getAttribute("loginInfoDetails"), session, request, response);
	String responseaftersubmit="''";
	String feature="1";
	if(session.getAttribute("responseaftersubmit")!=null){
	   responseaftersubmit="'"+session.getAttribute("responseaftersubmit").toString()+"'";
		session.setAttribute("responseaftersubmit",null);
	}
		
    LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
	String language = loginInfo.getLanguage();
	int systemId = loginInfo.getSystemId();
	int customerId = loginInfo.getCustomerId();
    int userId=loginInfo.getUserId();
    String viewFlag="";
    String startDate="";
    String endDate="";
    String fromTripImageUpload="";
    String unsuccessfulImageUpload="";
    String vehicleNoNew= "";
    String pageId = "";
    String hubId = "";
    String vehicleRepDate = "";
    
	Properties properties = ApplicationListener.prop;
    String GoogleApiKey = properties.getProperty("GoogleMapApiKeyen").trim();
	String FilePath = properties.getProperty("ViewTripImage");
	GeneralVerticalFunctions gf=new GeneralVerticalFunctions();
	if(request.getParameter("pageId") != null && !request.getParameter("pageId").equals("")){
		pageId = request.getParameter("pageId");
	}
	if(request.getParameter("vehicleNo") != null && !request.getParameter("vehicleNo").equals("")){
		vehicleNoNew = request.getParameter("vehicleNo");
	}
	if(request.getParameter("hubId") != null && !request.getParameter("hubId").equals("")){
		hubId = request.getParameter("hubId");
	}
	
	if(request.getParameter("vehicleRepDate") != null && !request.getParameter("vehicleRepDate").equals("")){
		vehicleRepDate = request.getParameter("vehicleRepDate");
	}
    String pageFlagGlobal = request.getParameter("pageFlag");
    
	String userAuthority = cf.getUserAuthority(systemId,userId);
	
	String latitudeLongitude=cf.getCoordinates(systemId);
	
	int offset = loginInfo.getOffsetMinutes();
 %>

<jsp:include page="../Common/header.jsp" />


<link rel="stylesheet"
	href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
<link rel="stylesheet"
	href="https://cdn.datatables.net/1.10.16/css/dataTables.bootstrap.min.css">
<link rel="stylesheet"
	href="https://ajax.googleapis.com/ajax/libs/jqueryui/1.11.1/themes/ui-darkness/jquery-ui.min.css"
	rel="stylesheet">
<link rel="stylesheet"
	href="https://cdn.datatables.net/1.10.16/css/dataTables.bootstrap4.min.css">

<link rel="stylesheet" href="../../Main/sweetAlert/sweetalert.css">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
<script src="https://code.jquery.com/jquery-1.12.4.js"></script>
<script
	src="https://cdnjs.cloudflare.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script>
<script
	src="https://cdn.datatables.net/1.10.16/js/jquery.dataTables.min.js"></script>
<script
	src="https://cdn.datatables.net/1.10.16/js/dataTables.bootstrap.min.js"></script>
<script
	src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
<script src="../../Main/sweetAlert/sweetalert-dev.js"></script>
<script src="https://malsup.github.io/jquery.form.js"></script>
<script
	src="https://cdn.datatables.net/1.10.16/js/dataTables.bootstrap4.min.js"></script>




<script src="https://www.jqwidgets.com/public/jqwidgets/jqx-all.js"></script>
<script
	src="https://www.jqwidgets.com/public/jqwidgets/globalization/globalize.js"></script>
<link rel="stylesheet"
	href="https://www.jqwidgets.com/public/jqwidgets/styles/jqx.base.css">
<link rel="stylesheet"
	href="https://www.jqwidgets.com/public/jqwidgets/styles/jqx.energyblue.css">
<link rel="stylesheet"
	href="https://www.jqwidgets.com/public/jqwidgets/styles/jqx.arctic.css">
<link
	href="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.6-rc.0/css/select2.min.css"
	rel="stylesheet" />
<script
	src="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.6-rc.0/js/select2.min.js"></script>


<link
	href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-slider/10.0.0/css/bootstrap-slider.css"
	rel="stylesheet" />
<link
	href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-slider/10.0.0/css/bootstrap-slider.min.css"
	rel="stylesheet" />
<script
	src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-slider/10.0.0/bootstrap-slider.js"></script>
<script
	src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-slider/10.0.0/bootstrap-slider.min.js"></script>

<script
	src="https://cdn.datatables.net/buttons/1.5.1/js/dataTables.buttons.min.js"></script>
<script
	src="https://cdn.datatables.net/buttons/1.5.1/js/buttons.flash.min.js"></script>
<script
	src="https://cdnjs.cloudflare.com/ajax/libs/jszip/3.1.3/jszip.min.js"></script>
<script
	src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.32/pdfmake.min.js"></script>
<script
	src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.32/vfs_fonts.js"></script>
<script
	src="https://cdn.datatables.net/buttons/1.5.1/js/buttons.html5.min.js"></script>
<script
	src="https://cdn.datatables.net/buttons/1.5.1/js/buttons.print.min.js"></script>

<pack:script src="../../Main/adapter/ext/ext-base.js"></pack:script>
<pack:script src="../../Main/Js/ext-all-debug.js"></pack:script>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">

<!--  	<link rel="stylesheet" href="https://code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">-->


<style>
.modal-body {
	position: relative;
	max-height: 500px;
	padding: 15px;
}

.modal {
	overflow-y: auto;
}

.input-group[class *=col-] {
	float: left !important;
	padding-right: 0px;
	margin-left: -54px !important;
}

.comboClass {
	width: 200px;
	height: 25px;
}

.comboClass2 {
	width: 200px;
	height: 25px;
}

.comboClassVeh {
	width: 200px;
	height: 25px;
}

.comboClassDriver {
	width: 150px;
	height: 25px;
}

label {
	display: inline-block;
	max-width: 100%;
	margin-bottom: 5px;
	font-weight: 500;
}

#emptyColumn {
	width: 20px;
}

#emptyColumn2 {
	width: 30px;
}

.dataTables_scroll {
	overflow: auto;
}

.modalimg {
	display: none; /* Hidden by default */
	position: fixed; /* Stay in place */
	z-index: 1; /* Sit on top */
	padding-top: 100px; /* Location of the box */
	left: 0;
	top: 0;
	width: 100%; /* Full width */
	height: 100%; /* Full height */
	overflow: auto; /* Enable scroll if needed */
	background-color: rgb(0, 0, 0); /* Fallback color */
	background-color: rgba(0, 0, 0, 0.9); /* Black w/ opacity */
}

/* Modal Content (Image) */
.imagecontent {
	margin: auto;
	display: block;
	width: 80%;
	max-width: 700px;
}

.imgclose {
	position: absolute;
	top: 15px;
	right: 35px;
	color: #f1f1f1;
	font-size: 40px;
	font-weight: bold;
	transition: 0.3s;
}

.imgclose:hover,.imgclose:focus {
	color: #bbb;
	text-decoration: none;
	cursor: pointer;
}

#slider12min .slider-track-high {
	background: green;
}

#slider12min .slider-track-low {
	background: red;
}

#slider12min .slider-selection {
	background: yellow;
}

#slider12max .slider-track-high {
	background: red;
}

#slider12max .slider-track-low {
	background: green;
}

#slider12max .slider-selection {
	background: yellow;
}

<!--
#temperatureColumns {--><!--
	height: 50px;
	-->
	<!--
}

-->
#slider slider-horizontal {
	width: 100%;
}

.btn {
	font-size: 13px;
}

#dateInput1 {
	width: 120px !important;
	height: 25px;
}

#dateInput2 {
	width: 120px !important;
	height: 25px;
}

.mybox {
	width: 111px;
	margin-left: 5px;
}

.colorbox {
	font-weight: bold;
	text-align: center;
	color: white;
	width: 108px;
}
style
=
</style>

<div class="panel panel-primary">
	<div class="panel-heading">
		<h3 class="panel-title">
			Semi-Automated Trip Creation
		</h3>
	</div>
	<div class="panel-body">
		<div class="col-lg-12 row">
			<div class="col-lg-9 row">
				<div class="col-lg-3">
					<label for="staticEmail2" class="col-lg-5">
						Customer
					</label>
					<select class="col-lg-7" id="custDropDownId"
						data-live-search="true" onchange="getVehicleAndRouteName(this)"
						style="height: 25px;">
						<option selected></option>
					</select>
				</div>
				<div class="col-lg-6" style="display: inherit;">
					<label for="staticEmail2" class="col-lg-3">
						Start Date
					</label>
					<div class='col-lg-3 input-group date'
						style="margin-left: -6% !important;">
						<input type='text' id="dateInput1" />
					</div>
					<label for="staticEmail2" class="col-lg-3">
						End Date
					</label>
					<div class='col-lg-3 input-group date'
						style="margin-left: -6% !important;">
						<input type='text' id="dateInput2" />
					</div>
				</div>
				<div class="col-lg-3" style="margin-left: 0%;">
					<label for="staticEmail2" class="col-lg-4">
						Type
					</label>
					<select class="col-lg-8" id="statusTypeDropDownId"
						data-live-search="true" style="height: 25px; width: 65%">
						<option selected value="ALL">
							All
						</option>
						<option value="OPEN">
							Open
						</option>
						<option value="CLOSED">
							Closed
						</option>
						<option value="CANCELLED">
							Cancel
						</option>
					</select>

				</div>
			</div>
			<div class="col-lg-3 row">
				<div class="col-lg-2">
					<button id="viewId" class="btn btn-primary" onclick="getData()">
						View
					</button>
				</div> 
				<div class="col-lg-2">
					<button title="ADD" onclick="openAddModal()"
						class="btn btn-primary" style="margin-left: 10px;">
						ADD
					</button>
				</div>
				<div class="col-lg-3">
					<button class="btn btn-info" title="Vehicle Reporting"
						onclick="openVehicleReportPage()" class="btn"
						id="vehicleReportBtnId" style="margin-left: 10px; display: none;">
						Back
					</button>
				</div>
			
			</div>
		</div>
		<div class="col-lg-12 col-md-12 col-sm-12 col-xs-12 text-center">
			<div id="page-loader" style="margin-top: 10px; display: none;">
				<img src="../../Main/images/loading.gif" alt="loader" />
			</div>
		</div>
		<br>
		<br />
		<table id="example" class="table table-striped table-bordered"
			cellspacing="0" width="100%">
			<thead>
				<tr>
					<th>
						#
					</th>
					<th style="display: none;">
						Trip Id
					</th>
					<th>
						Trip Name
					</th>
					<th>
						Source 
					</th>
					<th>
						Check Points
					</th>
					<th>
						Vehicle Number
					</th>
					<th>
						Created By
					</th>
					<th>
						Trip Created Time
					</th>
					<th>
						Trip Start Time
					</th>
					<th>
						Loading Start Time
					</th>
					<th>
						Loading End Time
					</th>
					<th>
						Customer Name
					</th>
					<th>
						Trip No
					</th>
					<th>
						Customer Ref. ID
					</th>
					<th>
						Status
					</th>
					<th style="white-space: nowrap;">
						Temperature Range (°C)
					</th>
					<th >
						Trip End Time
					</th>
					<th >
						Cancel/Close By - Date
					</th>
					<th>
						Cancelled/Closed Remarks
					</th>
					<th>
						Action
					</th>
					<th style="display: none;">
						Trip Cust Id
					</th>
					<th style="display: none;">
						Pre-Load Temp
					</th>
					<th style="display: none;">
						Route Id
					</th>
					<th style="display: none;">
						Product Line
					</th>
				</tr>
			</thead>
		</table>
	</div>
</div>



<div id="add" class="modal fade" data-backdrop="static"
	data-keyboard="false">
	<div class=""
		style="position: absolute; left: 2%; top: 52%; margin-top: -275px; width: 95%;">
		<div class="modal-content">
			<div class="modal-header" style="padding: 1px;">
				<h4 id="nome" class="modal-title">
					Add Trip Information
				</h4>
				<button type="button" class="close" onclick="cancel()"
					data-dismiss="modal">
					&times;
				</button>
			</div>
			<div class="modal-body" style="height: 500px; margin-bottom: 0px;overflow-y : auto;">
				<div class="col-md-12">
					<table class="table table-sm table-bordered table-striped"
						style="margin-bottom: 0px;">
						<tbody>
							<tr>
								<td>
									Customer Name <span style="color:red;">*</span>
								</td>
								<td>
									<select class="comboClass" id="addcustNameDownID"
										data-live-search="true" required="required"></select>
								</td>
								<td id="productLineLblId" >
									Product Line <span style="color:red;">*</span>
								</td>
								<td id="productLineId" >
									<select class="comboClassVeh" id="addProductLineComboId"
										required="required" onchange="checkProduct()"></select>
								</td>
								<td>
									Vehicle Number <span style="color:red;">*</span>
								</td>
								<td>
									<select class="comboClassVeh" id="addvehicleDropDownID"
										required="required"></select>
								</td>
							</tr>
							<tr>
								<td id="routeNameLbl" style="display:none">
									Route Name
								</td>
								<td id="routeNameIn" style="display:none">
									<select class="comboClass" id="addrouteDropDownID"
										data-live-search="true" required="required"
										onchange="plotLegDetails()"></select>
									<input onclick="createRoute()" id="createRouteId" type="button"
										class="btn btn-primary" data-dismiss="modal"
										style="height: 28px;" value="Create" />
									<input onclick="viewRoute('add')" id="viewRouteBtnId"
										type="button" class="btn btn-primary" style="height: 28px;"
										value="View" />
								</td>
								<td id="tripStartTimeLbl">
									Trip Start <span style="color:red;">*</span>
								</td>
								<td id="tripStartTimeIn">
									<input type="text" id="adddateTimeInput" class='form-control'>
								</td>
								<td id="hubDepartureLbl">
									Source Point <span style="color:red;">*</span>
								</td>
								<td id="hubDepartureIn">
									<select  id="sourceId" class="comboClass"  ></select>
								</td>
								<td id="tripEndTimeLbl">
									Trip End
								</td>
								<td id="tripEndTimeIn">
									<input type="text" id="tripEndTimeInput" class='form-control'>
								</td>
								<td id="checkPointBasisLbl" >
									Check Points
								</td>
								<td id="checkPointBasisIn" >
									<input type="text" id="checkPointsTxt" class='form-control' disabled>
									<input onclick="openCheckPointModal()" id="addcheckRouteBtnId"
										type="button" class="btn btn-primary" style="height: 28px;"
										value="Add check points" />
								</td>
							</tr>
								<td id="loadingStartTimeInputLbl">
									Loading Start <span style="color:red;">*</span>
								</td>
								<td id="loadingStartTimeInputIn">
									<input type="text" id="loadingStartTimeInput" class='form-control'>
								</td>
								<td id="loadingEndTimeInputLbl">
									Loading End <span style="color:red;">*</span>
								</td>
								<td id="loadingEndTimeInputIn">
									<input type="text" id="loadingEndTimeInput" class='form-control'>
								</td>
								<td>
									Customer Ref. ID <span style="color:red;">*</span>
								</td>
								<td>
									<input type="text" class="form-control comboClass"
										maxLength="15" id="custReferenceId"
										onkeypress="return checkSpcialChar(event)">
								</td>
							</tr>
								<table class="table table-sm table-bordered table-striped" id="tabelId" style="display: none ;max-height: 150px; overflow-y: auto !important;    margin-top: 15px;">
									<tr>
										<th style="width: 20px;"></th>
										<th style="width: 20px; display: none;"></th>
										<th style="width: 200px;">
											Leg Name
										</th>
										<th style="width: 300px">
											Source
										</th>
										<th style="width: 300px">
											Destination
										</th>
										<th style="width: 250px">
											STD
										</th>
										<th style="width: 250px">
											STA
										</th>
										<th style="width: 200px">
											Drivers
										</th>
										<th style="width: 200px">
											Apply Same Drivers for other Legs
											<input type="checkbox" id="checkSelected"
												onclick="checkboxValidation()" required>
										</th>
									</tr>
									<tbody id="legTableId">
									</tbody>
								</table>
							</tr>
							<tr>
							</tr>
							<tr>
								<table class="" id="tempConfigTableId" style="display: none">

									<tbody id="temperatureTableId"></tbody>
								</table>
							</tr>
							<div id="event" style="padding-top:25px">
								<tr>
									<td>
										<b>Events</b>
									</td>
									<td>
										<div id="eventTable"> </div>
									</td>
								</tr>
							</div>
							<div id="temperatureEvents">
							</div>
						</tbody>
					</table>
				</div>
			</div>
			<div class="modal-footer" style="text-align: center; padding: 8px;">
				<input id="save1" onclick="saveData()" type="button"
					style="background-color: #158e1a !important; border-color: #158e1a !important;"
					class="btn btn-primary" value="Save" />
				<button type="reset" onclick="cancel()" class="btn btn-warning"
					style="background-color: #da2618 !important; border-color: #da2618 !important;"
					data-dismiss="modal">
					Cancel
				</button>

			</div>
		</div>
	</div>
</div>

<div id="checkpointModal" class="modal fade" data-backdrop="static"
	data-keyboard="false">
	<div class=""
		style="position: absolute; left: 2%; top: 52%; margin-top: -275px; width: 95%;">
		<div class="modal-content">
			<div class="modal-header" style="padding: 1px;">
				<h4 id="nome" class="modal-title">
					Add check points
				</h4>
				<button type="button" class="close" data-dismiss="modal">
					&times;
				</button>
			</div>
			<div class="modal-body" style="height: 500px; margin-bottom: 0px;overflow-y : auto;">
			<div class="row">
				  <div class="col-md-5">
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
                    </div>
                   <div class="col-md-6">
                        <div id="dvMap" style="width: 800px; height: 417px; margin-top: 8px; border: 1px solid gray;"></div>
                        <div>
                        	<h5 id="dialogBoxId" style="color:red;"></h5>
                        </div>
                     </div>
                  </div>
			</div>
			<div class="modal-footer" style="text-align: center; padding: 8px;">
				<input id="addCheckPoints" onclick="addCheckPoints()" type="button"
					style="background-color: #158e1a !important; border-color: #158e1a !important;"
					class="btn btn-primary" value="Save" />
	
			</div>
		</div>
	</div>
</div>

<div class="modal fade" id="cancelModal" role="dialog"
	data-backdrop="static" data-keyboard="false">
	<div class="modal-dialog" style="margin-top: 8%">

		<!-- Modal content-->
		<div class="modal-content">
			<div class="modal-body" align="center !important">
				<div>
					<label for="remarks" style="text-align: center;">
						Reason *
					</label>
					<span style="padding-left: 112px;"><select
							class="comboClass" id="tripCancellationRemarks"
							data-live-search="true" required="required" onchange="showRemarks()"></select>
					</span>
					<br />
				</div>
				<div id="showRemarksId" style="display: none">
					<label for="remarks" style="text-align: center;">
						Remarks
					</label>
					<textarea class="form-control rounded-0" id="remarksId" rows="3"></textarea>
					<br />
				</div>
				<button
					style="margin-left: 215px; background-color: #158e1a; border-color: #158e1a; margin-top: 25px;"
					type="button" onclick="cancelTrip()" class="btn btn-success">
					Yes
				</button>
				<button
					style="margin-left: 16px; background-color: #da2618; border-color: #da2618; margin-top: 25px;"
					type="button" class="btn btn-warning" data-dismiss="modal"
					onclick="closeCancelTrip()">
					No
				</button>
			</div>
		</div>

	</div>
</div>

<div class="modal fade" id="closeModal" role="dialog" 	data-backdrop="static" data-keyboard="false">
	<div class="modal-dialog" style="margin-top: 8%">
		<!-- Modal content-->
		<div class="modal-content">
			<div class="modal-body" align="center !important">
			    Trip End Time <input type="text" id="tripCloseTimeInput" class='form-control'>
				<label for="remarks" style="text-align: center;"> Remarks * </label>
				<textarea class="form-control rounded-0" id="remarksCloseId" rows="3"></textarea>
				<br />
				<button  style="margin-left: 215px; background-color: #158e1a; border-color: #158e1a;" type="button" onclick="closeTrip()"   class="btn btn-success"> Yes </button>
				<button	style="margin-left: 16px; background-color: #da2618; border-color: #da2618;" type="button" class="btn btn-warning" data-dismiss="modal"  onclick="closeTripCloseModal()"> No </button>
			</div>
		</div>

	</div>
</div>

<div class="modalimg" id="viewImageModal">
	<span id="imgCloseId" class="imgclose">&times;</span>
	<img id="tripImage" class="imagecontent" onerror="imgError()" />
	<div id="caption"></div>
</div>


<div align="left"><script src="<%=GoogleApiKey%>"></script> 
<script>
	
	 window.onload = function () { 
		getCustomer();
		getTripConfiguration();
	}
	
    var table;
    var customerDetails;
    var addcustomerDetails;
    var status;
    var routeList;
    var routeListarray = [];
    var uniqueId;
    var currentDate = new Date();
    var restrictDate = new Date(currentDate).getDate();
    var restrictMonth = new Date(currentDate).getMonth();
    var restrictYear =new Date(currentDate).getFullYear();
	currentDate.setHours(23);
	currentDate.setMinutes(59);
	currentDate.setSeconds(59);
	var tripId =0;
	var imgModal = document.getElementById('viewImageModal');
	var span = document.getElementById("imgCloseId");
	var filePath="<%=FilePath%>";
	var sliderMin;
	var sliderMax;
	var associatedTemp;
	var vehicleAssoList;
    var vehicleArray = []; 
    var recordsCount = 0;
    var globalRouteId = "";
    var modiFyCount = 0;
    var pageFlag = '<%=pageFlagGlobal%>'
    var globalVehicleSelected;
    var vehicleRepDate = '<%=vehicleRepDate%>';
    var globalTripCustId;
    var destinationArrived = false;
    var minPositiveTemp = "";
    var minNegativeTemp = "";
    var maxPositiveTemp = "";
    var maxNegativeTemp = "";
    var temperaturesArray ;
    var allTemperaturesArray = [];
    var temperatureCounter = 0;
    var globalProductLineSelected;
    var remarksList;
    var modTempConfigList = [];
    var modtemperatureCounter = 0;
    var modTemperaturesArray = [];
    var modTempeartureArrayData;
    var globalShipmentId;
    var routeChangedCount = 0;
    var globalLRNo;
    var tempSensorNames = [];
    
    var selecedSensorsForAlert = [];
    var directionsDisplay;
    var maxDrag=0;
     var myLatLngS;
     var myLatLngD;
     sessionStorage.clear();
     var sessionStorageKeys = [];
    localStorage.clear();
    var srcDestMarkers = [];
    var checkPointNamesArray = '';
    var semiAutoTripConfig = {};
    var checkPointArray = [];
   
 var now = new Date ();
	var n = new Date( now.getTime() + (now.getTimezoneOffset() * 60000));
    d2 = new Date ( n );
	d2.setMinutes ( n.getMinutes() + <%=offset%> );
	//console.log ( d2 );   
    
$(document).ready(function () {
   $("#adddateTimeInput").jqxDateTimeInput({ theme: "arctic", formatString: "dd/MM/yyyy HH:mm", showTimeButton: true, width: '200px', height: '25px'});
   $('#adddateTimeInput ').jqxDateTimeInput('setDate', d2);
   $('#adddateTimeInput ').jqxDateTimeInput({min: new Date(restrictYear, restrictMonth, restrictDate)});
   $("#tripEndTimeInput").jqxDateTimeInput({ theme: "arctic", formatString: "dd/MM/yyyy HH:mm", showTimeButton: true, width: '200px', height: '25px'});
   $('#tripEndTimeInput ').jqxDateTimeInput('setDate', new Date());
   $('#tripEndTimeInput ').jqxDateTimeInput({min: new Date(restrictYear, restrictMonth, restrictDate)});
  
   $("#dateInput1").jqxDateTimeInput({ theme: "arctic", formatString: "dd/MM/yyyy", showTimeButton: false, width: '197px', height: '25px'});
   $('#dateInput1 ').jqxDateTimeInput('setDate', new Date());
   $("#dateInput2").jqxDateTimeInput({ theme: "arctic", formatString: "dd/MM/yyyy", showTimeButton: false, width: '197px', height: '25px'});
   $('#dateInput2 ').jqxDateTimeInput('setDate', new Date());
   
    $("#loadingStartTimeInput").jqxDateTimeInput({ theme: "arctic", formatString: "dd/MM/yyyy HH:mm", showTimeButton: true, width: '200px', height: '25px'});
	$('#loadingStartTimeInput').jqxDateTimeInput({min: new Date(restrictYear, restrictMonth, restrictDate)});
	$('#loadingStartTimeInput').jqxDateTimeInput('setDate',  d2);    
	$("#loadingEndTimeInput").jqxDateTimeInput({ theme: "arctic", formatString: "dd/MM/yyyy HH:mm", showTimeButton: true, width: '200px', height: '25px'});
	$('#loadingEndTimeInput').jqxDateTimeInput({min: new Date(restrictYear, restrictMonth, restrictDate)});
	$('#loadingEndTimeInput ').jqxDateTimeInput('setDate',  d2);   
	$("#tripCloseTimeInput").jqxDateTimeInput({ theme: "arctic", formatString: "dd/MM/yyyy HH:mm",  showTimeButton: true, width: '200px', height: '25px' });
    $('#tripCloseTimeInput').jqxDateTimeInput({min: new Date(restrictYear, restrictMonth, restrictDate)});
	$('#tripCloseTimeInput').jqxDateTimeInput('setDate',  new Date()); 
if('<%=pageId%>' == 'route'){
   		getCustomer();
   		$("#addrouteDropDownID").empty().select2();
   		$("#addProductLineComboId").empty().select2();
   		$("#categoryComboId").empty().select2();
   		$('#add').modal('show');
   		hideFieldsBasedOnMaterialClient();
   		if(pageFlag == 'true'){
   			$('#vehicleReportBtnId').show();
   		}else{
   			$('#vehicleReportBtnId').hide();
   		}
   		loadCustomerAndVehicle();
   		setTimeout( function(){
   			document.getElementById("avgSpeedId").value = avgSpeedVal;
   			$('#addrouteDropDownID').val(localStorage.getItem("routeId")).trigger('change');
   			$('#addcustNameDownID').val(localStorage.getItem("tripCustId")).trigger('change');
   			$('#avgSpeedId').val(localStorage.getItem("avgSpeed")).trigger('change');
   			checkBoxVal = localStorage.getItem("checkValue");
   			$('#addvehicleDropDownID').val('<%=vehicleNoNew%>').trigger('change');
   			if(checkBoxVal=='Y'){
			}
   		},1000);
   	}else{
   		$('#vehicleReportBtnId').hide();
   	}

	$("#addcustNameDownID").change(function() {
		loadData();
		$("#temperatureTableId").empty();
		$("#temperatureEvents").empty();
		allTemperaturesArray = [];
		temperatureCounter = 0;
	})

});

//##########function to get customer details#############//

function getCustomer(){
	var custId;
	var custName;
	var custarray=[];
	$.ajax({
        url: '<%=request.getContextPath()%>/CommonAction.do?param=getCustomer',
          success: function(result) {
                   customerDetails = JSON.parse(result);
            for (var i = 0; i < customerDetails["CustomerRoot"].length; i++) {
            custarray.push(customerDetails["CustomerRoot"][i].CustName);
			}
			
		for (i = 0; i < custarray.length; i++) {
                var opt = document.createElement("option");
                document.getElementById("custDropDownId").options.add(opt);
                opt.text = custarray[i];
                opt.value = custarray[i];
            }
            
			if(customerDetails["CustomerRoot"].length == 1){
				var cName="";
				for (var i = 0; i < customerDetails["CustomerRoot"].length; i++) {
					cName = customerDetails["CustomerRoot"][i].CustName;
				}
				function setSelectedIndex(s, v) {
					for ( var i = 0; i < s.options.length; i++ ) {
       			 		if ( s.options[i].text == v ) {
           		 			s.options[i].selected = true;
           		 			return;
        				}
   			 		}
				}
		setSelectedIndex(document.getElementById('custDropDownId'),cName);
			
		var custId;
	    var customerName = document.getElementById("custDropDownId").value;
	
	    for (var i = 0; i < customerDetails["CustomerRoot"].length; i++) {
	        if (customerName == customerDetails["CustomerRoot"][i].CustName) {
	             custId = customerDetails["CustomerRoot"][i].CustId;
	
	        }
	    }
	    var vehicleList;
	    var vehicleListarray = [];
	   var vehicleArray=[];
	    var addcustList;
	    }
	   }
	});
	
 }
    
  //############function cancle##########
	function cancel(){
	  	document.getElementById("addcustNameDownID").value="";
	  	document.getElementById("custReferenceId").value="";
	  	document.getElementById("checkPointsTxt").value="";
	    document.getElementById("addvehicleDropDownID").value="";
	    document.getElementById("addrouteDropDownID").value = "";
		$("#addrouteDropDownID").empty().select2();
        $("#addvehicleDropDownID").empty().select2();
    }
    
    //#############function to get grid data###################
  function getData(){
  document.getElementById("page-loader").style.display="block";
    viewFlag='viewFlag';
    if ($.fn.DataTable.isDataTable('#example')) {
            $('#example').DataTable().clear().destroy();
        }
    
      var customerId;
      var customerName = document.getElementById("custDropDownId").value;
    for (var i = 0; i < customerDetails["CustomerRoot"].length; i++) {
        if (customerName == customerDetails["CustomerRoot"][i].CustName) {
             customerId = customerDetails["CustomerRoot"][i].CustId;

        }
    }
    
    var startDate=document.getElementById("dateInput1").value;
    startDate=startDate.split("/").reverse().join("-");
    var endDate=document.getElementById("dateInput2").value;
    endDate=endDate.split("/").reverse().join("-");
    if(startDate > endDate){
    sweetAlert("End date should be greater than Start date");
		       	    document.getElementById("dateInput2").value = currentDate;
		       	    //return;
		   		}
    var statusType = document.getElementById("statusTypeDropDownId").value;
    if(customerName == ''){
    	sweetAlert("Please select customer");
    }
    else{
        $.ajax({
            type: "POST",
            url: '<%=request.getContextPath()%>/SemiAutoTripAction.do?param=getSemiAutoTripDetails',
            "data": {
            	 CustId: customerId,
                 startdate: startDate,
                 enddate: endDate,
                 statusType: statusType
            },
            success: function(result) {
            document.getElementById("page-loader").style.display="none";
             result = JSON.parse(result).ticketDetailsRoot;
             if ($.fn.DataTable.isDataTable('#example')) {
                 $('#example').DataTable().clear().destroy();
             }
         	var rows = new Array();
             $.each(result, function(i, item) {
           var row = { "0":item.slnoIndex,
                         "1" : item.uniqueIdIndex,
                         "2" : item.shipmentIdIndex,
                         "3" : item.sourceHubName,
                         "4" : item.routeNameDataIndex,
                         "5" : item.vehicleDataIndex,
                         "6" : item.insertedByDataIndex,
                         "7" : item.insertedTimeDataIndex,
                         "8" : item.plannedDateTimeIndex,
                         "9" : item.loadStartTime,
                         "10" : item.loadEndTime,
                         "11" : item.customerNameIndex,
                         "12" : item.orderIdIndex,
                         "13" : item.custRefIdIndex,
                         "14" : item.statusDataIndex,
                         "15" : item.tempRangeDataIndex,
                         "16" : item.tripEndTime,
                         "17" : item.actionByDate,
                         "18" : item.cancelledRemarks,
                         "19" : item.actionIndex,
                         "20" : item.tripCustId,
                         "21" : item.routeIdIndex,
						 "22" : item.preLoadTempIndex,
                         "23" : item.productLineIndex
               }
               
               rows.push(row);
             });
               table = $('#example').DataTable({
                   "scrollY": "280px",
                   "scrollX": true,
                   paging : true,
                   "serverSide": false,
                   "oLanguage": {
                       "sEmptyTable": "No data available"
                   },
    	    "dom": 'Bfrtip',
    	    "processing": true,
                  "buttons": [{
                  		extend: 'pageLength'
              		}, {
                  extend: 'excelHtml5',
                  customize: function(xlsx) {
                  var sheet = xlsx.xl.worksheets['sheet1.xml'];

                 // Loop over the cells in column `C`
                 $('row c[r^="M"]', sheet).each( function () {
                   // Get the value
                       $(this).attr( 's', '55' );//to wrap text
                 });
           },
   text: 'Export to Excel',
  title: 'Trip Details',
     	           className: 'btn btn-primary',
   exportOptions: {
                columns: ':visible'
           }
             	 }],             	  
                 });
                 table.rows.add(rows).draw();

		 	     table.columns( [1,20,21,22,23] ).visible( false );
	        }
        
     	});
        jQuery('.dataTable').wrap('<div class="dataTables_scroll" />');
    }
   } 
        
	$('#example').unbind().on('click', 'td', function(event) {
		var columnIndex = table.cell(this).index().column;
	        var aPos = $('#example').dataTable().fnGetPosition(this);
	        var data = $('#example').dataTable().fnGetData(aPos[0]);
	        var custName = (data[9]);//customerNameIndex
	        var orderId = (data[10]);//orderIdIndex
	        var routeName = (data[3]);//routeNameDataIndex
	        globalVehicleSelected = (data[4]);//vehicleDataIndex
	        var plannedDate = (data[7]);//plannedDateTimeIndex
	        var refId=(data[11]);//custRefIdIndex
	        var prLoadTemp = (data[26]);//preLoadTempIndex
	        globalRouteId = data[25];//routeIdIndex
	        status = (data[12]);//statusDataIndex
	        uniqueId = (data[1]);//uniqueIdIndex
	        var avgSpeed = data[8];//avgSpeedIndex
	        var productLine = (data[27]);//productLineIndex
	        var atd = (data[28]);//atdIndex
	        var sta = (data[39]);//sta
	        var ata = (data[40]);//ata
	        var category = (data[41]);//category
	        globalTripCustId = (data[24]);//tripCustId
	        $('#modifycustNameDownID').val(custName);
	        $('#modifycustrefID').val(refId);
	        $('#modifyorderId').val(orderId);
	     //   $('#modifyrouteDropDownID').val(globalRouteId);
	        //$('#modifyvehicleDropDownID').val(globalVehicleSelected);
	        $('#dateTimeInput').val(plannedDate);
	        $('#avgSpeedModifyId').val(avgSpeed);
	        $('#preloadTempModifyId').val(prLoadTemp);
	        $('#modifyProductLineComboId').val(productLine);
	        globalProductLineSelected = data[27];
	        globalShipmentId = data[2];
	        globalLRNo = data[10];
	        var actualTripEndTime = data[42];
	              	
	});

//##################function to cancle trip#######################
	function cancelTrip(){
	var remarks= "";
	var reasonId = document.getElementById("tripCancellationRemarks").value;
	if(reasonId == "--Select Remarks--" ){
    	sweetAlert("Please select a reason");
    	return;
    }
		var customerId;
	        var customerName = document.getElementById("custDropDownId").value;
	    for (var i = 0; i < customerDetails["CustomerRoot"].length; i++) {
	        if (customerName == customerDetails["CustomerRoot"][i].CustName) {
	             customerId = customerDetails["CustomerRoot"][i].CustId;
	
	        }
	    }
	    var remarksDetails = document.getElementById("remarksId").value;
	    
	    if (reasonId== "Others"){
		    if(remarksDetails.trim().length==0){
				sweetAlert("Please Enter Remarks");
				document.getElementById("remarksId").value="";		
	    		return;	
		}
	    }
	    
	    
	    //var remarksDetails = document.getElementById("remarksId").value;
	  var param = {
	        uniqueId: uniqueId,
	        vehicleNo: globalVehicleSelected,
	        remarks: remarksDetails,
	        reasonId : reasonId 	        
	    };
	    
	    $.ajax({
	        url: '<%=request.getContextPath()%>/SemiAutoTripAction.do?param=cancelTrip',
	        data: param,
	        success: function(result) {
	        $('#cancelModal').modal('hide');
	        	if (result == "Trip Cancelled") {
	                     sweetAlert("Trip Cancelled!!");
	                     document.getElementById("remarksId").value="";
 	                     //setTimeout(function(){
	                       getData();
	                     //}, 1000);
	                 } else {
	                 	document.getElementById("remarksId").value="";
	                    sweetAlert(result);
	                 }
	        }
		})
	}

//######################function to save details#################

	function validateTripDataBasedonConfig(){
		//if(semiAutoTripConfig.tripStartCriteria.includes('HUB_DEPARTURE')){
			if(document.getElementById("sourceId").value == 0 || document.getElementById("sourceId").value == '--Select Source---'){
				sweetAlert("Please select source hub");
				return false;
			}
		//}
	return true;
	}
	
function saveData(){
	var customerName;
	var customerId;
	var checkbox='';
	var val = [];
	 $(':checkbox:checked').each(function(i){
	 val[i] = $(this).val();  
	 checkbox = checkbox + val[i] +",";
	 }); 
	for (var i = 0; i < customerDetails["CustomerRoot"].length; i++) {
	        if (customerName == customerDetails["CustomerRoot"][i].CustName) {
	             customerId = customerDetails["CustomerRoot"][i].CustId;
	
	        }
	}
	var addcustomerName;
	var addcustomerId;
	var addorderId;
	var plannedDateTime;

	
	customerName = document.getElementById("custDropDownId").value;
	
    for (var i = 0; i < customerDetails["CustomerRoot"].length; i++) {
        if (customerName == customerDetails["CustomerRoot"][i].CustName) {
             customerId = customerDetails["CustomerRoot"][i].CustId;

        }
      }
   if(customerName=="" ){
    	sweetAlert("Please select customer");
    	//document.getElementById("errorMessage").innerHTML="Please select customer";
    	return;
    }
	addcustomerName = $('#addcustNameDownID option:selected').attr("value");
	var routeId = 0;// TODO SAT $('#addrouteDropDownID option:selected').attr("value");
	var routeName = $('#addrouteDropDownID option:selected').text();
	var vehicleNo= document.getElementById("addvehicleDropDownID").value;
	var categoryComboVal= $('#categoryComboId option:selected').attr("value");
	plannedDateTime = document.getElementById("adddateTimeInput").value;
	custReference=document.getElementById("custReferenceId").value;
	var preLoadTemp = "";
	var tripRemarks = "";
	var tempeartureArray = "";
	
	if(customerName=="" ){
    	sweetAlert("Please select customer");
    	return;
    }
    if(addcustomerName == "" || addcustomerName == 0){
		sweetAlert("Please select Trip Customer Name");
    	return;
	}
    if($('#addProductLineComboId option:selected').attr("value") == "" || $('#addProductLineComboId option:selected').attr("value") == 'undefined'){
    	sweetAlert("Please select Product Line");
    	return;
    }
    if(vehicleNo=="-- select vehicle number --"){
    	sweetAlert("Please select Vehicle Number");
    	return;
    }
    if(document.getElementById("custReferenceId").value==""){
		sweetAlert("Please Enter Customer Reference ID");
    	return;
	}
    if(!validateTripDataBasedonConfig()){
    	return;
    }
    var tripStart=document.getElementById("adddateTimeInput").value;
    var loadingStart = document.getElementById("loadingStartTimeInput").value;
    var loadingEnd=document.getElementById("loadingEndTimeInput").value;
      if(loadingEnd >= tripStart){
    sweetAlert("TripStart date should be greater than LoadingEnd date");
		       	   return;
		   		}
	  if(loadingStart >= loadingEnd){
    sweetAlert("LoadingEnd date should be greater than LoadingStart date");
		       	   return;
		   		}
    var productLine12 = 'TCL';//document.getElementById('addProductLineComboId').value;
    if((productLine12 == "Chiller") || (productLine12 == "Freezer") || (productLine12 == "TCL") ){
  			allTemperaturesArray = [];
		    for (var j=0;j < temperatureCounter ;j++ ){
				    var name2 = "";
				    var minNeg = parseFloat(document.getElementById("ex20").value);
				    var maxNeg = parseFloat(document.getElementById("ex30").value);
				    var minPos = parseFloat(document.getElementById("ex40").value);
				    var maxPos = parseFloat(document.getElementById("ex50").value);
				    var sensorName = document.getElementById("ex60").value;
				    if(Number.isNaN(minNeg) || Number.isNaN(maxNeg) || Number.isNaN(minPos) || Number.isNaN(maxPos)){
				    	sweetAlert("Please enter temperature range");
				    	return;
				    }
				    if ((Number.isNaN(minNeg)) || (minNeg < -70 || minNeg > 70)){
				    	sweetAlert("Please enter Min negative temperature values between -70 °C to 70 °C "+name2+" ");
				    	return;
				    } if ((Number.isNaN(maxNeg)) || (maxNeg < -70 || maxNeg > 70)){
				    	sweetAlert("Please enter Max negative temperature values between -70 °C to 70 °C "+name2+" ");
				    	return;
				    }if ((Number.isNaN(minPos)) || (minPos < -70 || minPos > 70)){
				    	sweetAlert("Please enter Min positive temperature values between -70 °C to 70 °C "+name2+" ");
				    	return;
				    } if ((Number.isNaN(maxPos)) || (maxPos < -70 || maxPos > 70)){
				    	sweetAlert("Please enter Max positive temperature values between -70 °C to 70 °C "+name2+" ");
				    	return;
				    }if (minNeg >  maxNeg){
				    	sweetAlert("Min negative temperature value should be less than Max negative temperature value "+name2+" ");
				    	return;
				    }if (maxNeg > minPos){
				    	sweetAlert("Max negative temperature value should be less than Min positive temperature value "+name2+" ");
				    	return;
				    }if (minPos > maxPos){
				    	sweetAlert("Min positive temperature value should be less than Max positive temperature value "+name2+" ");
				    	return;
				    }
				    var temperatureData = {};
				    temperatureData.displayName = 
				    temperatureData.maxNegativeTemp = maxNeg;
				    temperatureData.maxPositiveTemp = maxPos;
				    temperatureData.minNegativeTemp = minNeg;
				    temperatureData.minPositiveTemp = minPos;
				    temperatureData.sensorName = sensorName;
				    allTemperaturesArray.push(temperatureData);
				    //allTemperaturesArray.push({ name2,  minNeg,  maxNeg , minPos,  maxPos,sensorName}) ;	
		    }
		   selecedSensorsForAlert = [];
		    for (var j=0;j < tempSensorNames.length ;j++ ){
		    	if(document.getElementById(tempSensorNames[j]).checked){
		    		selecedSensorsForAlert.push(tempSensorNames[j])
		    	}
		    }
    	tempeartureArray = allTemperaturesArray;///sliderMin.getValue()+"/";
    }else{
    	tempeartureArray = "";
		minHumidity = "";
		maxHumidity = "";
		preLoadTemp = "";
    }
    var fileImgPath = "";//document.getElementById('imgUploadId').value;
    var dates = "";
    var legId = "";
    var checkPointData = JSON.stringify(checkPointArray);
    /*if(semiAutoTripConfig.routeType != 'PLANNED'){
    	routeName = document.getElementById("checkPointsTxt").value;//sat todo
    	avgSpeed = 0;
    }
    if(semiAutoTripConfig.tripStartCriteria){
    	startDate = "";
    }else{
    	startDate = document.getElementById("dateInput1").value;
    }*/

        console.log("**************Input ***********************");
        
        var trackTripDetailsSub = {};
        trackTripDetailsSub.loadStartTime = document.getElementById("loadingStartTimeInput").value;
        trackTripDetailsSub.loadEndTime = document.getElementById("loadingEndTimeInput").value;
       	 var sourceHubDetails = {};
	    sourceHubDetails.hubId = $('#sourceId option:selected').attr("value");
	    sourceHubDetails.name = $('#sourceId option:selected').text();
	    sourceHubDetails.latitude =   $('#sourceId option:selected').attr("latitude");
	    sourceHubDetails.longitude =   $('#sourceId option:selected').attr("longitude");
	    sourceHubDetails.detention = $('#sourceId option:selected').attr("detention");
	    sourceHubDetails.radius = $('#sourceId option:selected').attr("radius");
       	if(checkPointArray.length == 0){
			checkPointArray.push(sourceHubDetails);
       }else{
       		checkPointArray.unshift(sourceHubDetails);
       }
        var paramboot = {
		assetNumber : vehicleNo,
		tripCustomerId :customerId, //check
		customerName : $('#addcustNameDownID option:selected').text(),
		customerRefId : custReference,
		productLine : $('#addProductLineComboId option:selected').attr("value"),
		routeName : document.getElementById("checkPointsTxt").value,
		desTripDetails : JSON.stringify(checkPointArray),
		tripVehicleTemperatureDetails : JSON.stringify(tempeartureArray),
		tripStartTime : document.getElementById("adddateTimeInput").value,
		trackTripDetailsSub : JSON.stringify(trackTripDetailsSub),
		sourceHubName :$('#sourceId option:selected').text()
	}
      console.log(paramboot);
      
    $.ajax({
        url : '<%=request.getContextPath()%>/SemiAutoTripAction.do?param=saveTripMuscat',
        data: paramboot,
	type: 'POST',
        success: function(result) {
        	if (result == "success") {
               		setTimeout(function(){
		               	sweetAlert("Saved Successfully");
		                getData();
		                document.getElementById("addcustNameDownID").value="";
		                document.getElementById("custReferenceId").value="";
		                clearCheckPointsModalData();
		                document.getElementById("addvehicleDropDownID").value="";
					    document.getElementById("addrouteDropDownID").value = "";
					    $('#add').modal('hide');
               		}, 1000);

                 } else {
                     sweetAlert(result.message);
                 }
        }
		});
	}

	function openAddModal(){
		
		var now = new Date ();
	var n = new Date( now.getTime() + (now.getTimezoneOffset() * 60000));
    d2 = new Date ( n );
	d2.setMinutes ( n.getMinutes() + <%=offset%> );

		$(".control-group").remove(); //
		loadCustomerAndVehicle();
		checkProduct()
		clearAddModalFields();
		clearCheckPointsModalData();
		
		$('#add').modal('show');
	}
	function clearAddModalFields(){
		$('#loadingEndTimeInput ').jqxDateTimeInput('setDate', d2);   
		$('#loadingStartTimeInput').jqxDateTimeInput('setDate', d2);  
		$('#adddateTimeInput').jqxDateTimeInput('setDate', d2); 
		$('#sourceId').val(0).trigger('change'); 

	}
	
	

    function checkSpeed(event){
    	if(!((event.keyCode >= 48) && (event.keyCode <= 57) || event.keyCode == 46)){
       		event.returnValue = false;
       		return;
    	}
    	event.returnValue = true;
    }
    function checkTemperature(event,value){
        if(value = 'First'){
            $('#ex11').val();
        }
    	if(!((event.keyCode >= 48) && (event.keyCode <= 57) || event.keyCode == 46 || event.keyCode == 45)){
       		event.returnValue = false;
       		return;
    	}
    	event.returnValue = true;
    }
    function checkTemperature1(id,value){
   // console.log(" id"+id +" value"+value );
    if (value == ''){
    }else{
		    var regex =  new RegExp("^[+-]?[0-9]{1,9}(?:\.[0-9]{1,2})?$");
		    if (regex.test(value)){
		    }else{
		    	document.getElementById(id).value="";
		    }
    	}
    }
    function checkSpcialChar(event){
	    if(!((event.keyCode >= 65) && (event.keyCode <= 90) || (event.keyCode >= 97) && (event.keyCode <= 122) || (event.keyCode >= 48) && (event.keyCode <= 57) || event.keyCode == 45 || event.keyCode == 95)){
	       event.returnValue = false;
	       return;
	    }
	    event.returnValue = true;
    } 
    
   function createRoute(){
    //getData();
    localStorage.clear();
        if(document.getElementById("custDropDownId").value==""){
            sweetAlert("Please select Customer Name");
            return;
        }
        var customerName = document.getElementById("custDropDownId").value;
        for (var i = 0; i < customerDetails["CustomerRoot"].length; i++) {
            if (customerName == customerDetails["CustomerRoot"][i].CustName) {
                 customerId = customerDetails["CustomerRoot"][i].CustId;

             }
        }
        routeId = $('#addrouteDropDownID option:selected').attr("value");
        tripCustId = document.getElementById("addcustNameDownID").value;
        localStorage.setItem("routeId", routeId);
        localStorage.setItem("tripCustId", tripCustId);
        localStorage.setItem("checkValue", checkBoxVal);
        localStorage.setItem("avgSpeed", avgSpeedVal);
        var createRouteFromTrip="createRouteFromTrip";
       	window.location = "<%=request.getContextPath()%>/Jsps/GeneralVertical/RouteMaster.jsp?custId="+customerId+"&createRouteFromTrip="+createRouteFromTrip+"&vehicleNo=<%=vehicleNoNew%>"+"&routeId="+routeId+"&tripCustId="+tripCustId;
    }

    function viewRoute(type){
    	localStorage.clear();
    	var customerName;
    	var routeId;
    	var createRouteFromTrip="modify";
    	var tripCustId;
    	if(type == 'add'){
    		if(document.getElementById("addrouteDropDownID").value=="" ){
	    		sweetAlert("Please select a route");
		    	return;
		    }
		    customerName = document.getElementById("custDropDownId").value;
	        for (var i = 0; i < customerDetails["CustomerRoot"].length; i++) {
	            if (customerName == customerDetails["CustomerRoot"][i].CustName) {
	                 customerId = customerDetails["CustomerRoot"][i].CustId;
	
	             }
	        }
		    routeId =  $('#addrouteDropDownID option:selected').attr("value");
	        tripCustId = document.getElementById("addcustNameDownID").value;
    	}else{
    		if(document.getElementById("changeRouteId").value=="" ){
	    		sweetAlert("Please select a route");
	    		return;
	    	}
		    customerName = document.getElementById("custDropDownId").value;
	        for (var i = 0; i < customerDetails["CustomerRoot"].length; i++) {
	            if (customerName == customerDetails["CustomerRoot"][i].CustName) {
	                 customerId = customerDetails["CustomerRoot"][i].CustId;
	
	             }
	        }
		    routeId =  $('#changeRouteId option:selected').attr("value");
	        tripCustId = globalTripCustId;
    	}
		localStorage.setItem("routeId", routeId);
        localStorage.setItem("tripCustId", tripCustId);
        localStorage.setItem("checkValue", checkBoxVal);
        localStorage.setItem("avgSpeed", avgSpeedVal);
        if('<%=pageId%>' == 'vehicleReport'){
        	pageFlag = 'true';
        }
        	window.location = "<%=request.getContextPath()%>/Jsps/GeneralVertical/RouteMaster.jsp?custId="+customerId+"&createRouteFromTrip="+createRouteFromTrip+"&vehicleNo=<%=vehicleNoNew%>"+"&routeId="+routeId+"&tripCustId="+tripCustId;
	}
	
	function imageValidateAndUpload(){
         var filePath = document.getElementById('imgUploadId').value;
         if(filePath==""){
       		sweetAlert("Please select the File ");
			return false;
         }
         var imgext = filePath.substring(filePath.lastIndexOf(".") + 1, filePath.length);
         if (imgext == "jpg" || imgext == "jpeg") {
         return true;
         } else {
           sweetAlert("Please select .jpeg type of File");
            return false;
         }
         return true;
	}
	
	function imageDownload(uniqueId){
		var completeFileLocation=filePath+"/"+"Trip_Id_"+uniqueId+".jpg";
		//alert(completeFileLocation);
		$('#tripImage').attr('src',completeFileLocation);
    	//alert("TRIP ID : "+tripId);
    	imgModal.style.display="block";
	}
	span.onclick = function() { 
        imgModal.style.display = "none";
    	//$('#viewImageModal').modal('hide');
	}

	function imgError(){
			imgModal.style.display = "none";
			sweetAlert("No image for this trip");
            return;
	}
	
	function checkProduct()
	{
		$("#temperatureEvents").empty();
		$("#temperatureTableId").empty();
		allTemperaturesArray = [];
		temperatureCounter = 0;
		var productLine = document.getElementById('addProductLineComboId').value;		
		var date = document.getElementById('adddateTimeInput').value;		
		
		if (productLine == 'TCL' || productLine == 'Chiller' || productLine == 'Freezer'){
			document.getElementById("tempConfigTableId").style.display = "block";		
			document.getElementById("temperatureTableId").style.display = "block";	
			document.getElementById("temperatureEvents").style.display = "block";	
		}else{
			document.getElementById("tempConfigTableId").style.display = "none";		
			document.getElementById("temperatureTableId").style.display = "none";	
			document.getElementById("temperatureEvents").style.display = "none";	
		}
		//loadCustomerAndVehicle();
		$("#addvehicleDropDownID").empty().select2();
		$.ajax({
	        url: '<%=request.getContextPath()%>/SemiAutoTripAction.do?param=getAvailableVehicles',
	        data: {
	         productLine : document.getElementById('addProductLineComboId').value,
	         vehicleReporting :'N',
	         date : date		        	
	        },
	        success: function(result) {
	            vehicleList = JSON.parse(result);
	            for (var i = 0; i < vehicleList["clientVehicles"].length; i++) {
                    $('#addvehicleDropDownID').append($("<option></option>").attr("value", vehicleList["clientVehicles"][i].vehicleName)
                    .attr("minTempLimit", vehicleList["clientVehicles"][i].minTempLimit).attr("maxTempLimit", vehicleList["clientVehicles"][i].maxTempLimit)
                    .attr("isRS232Assoc", vehicleList["clientVehicles"][i].isRS232Assoc).text(vehicleList["clientVehicles"][i].vehicleName));
	            }
	            $('#addvehicleDropDownID').select2();
	        }
	    });
	  
		if(productLine == 'TCL' || productLine == 'Chiller' || productLine == 'Freezer')
		{
			document.getElementById("tempConfigTableId").style.display = "block";	
		}
		else
		{
			document.getElementById("tempConfigTableId").style.display = "none";	
		}
		
	}

	function openVehicleReportPage(){
		window.location.href = "<%=request.getContextPath()%>/Jsps/DistributionLogistics/VehicleReporting.jsp?hubId=<%=hubId%>";
	}

	function plotLegDetails(){
		$("#legTableId").empty();
		recordsCount = 0;
		var routeId = $('#addrouteDropDownID option:selected').attr("value");
		$.ajax({
	        url: '<%=request.getContextPath()%>/TripCreatAction.do?param=getLegDetails',
	        data: {
	        	routeId : routeId,
	        	date : document.getElementById('adddateTimeInput').value+":00"
	        },
	        success: function(result) {
	            var legDetails = JSON.parse(result);
				var count;
				recordsCount = legDetails["legDetailsRoot"].length;
				if(legDetails["legDetailsRoot"].length > 0){
					document.getElementById("tabelId").style.display = "block";
					for(var i = 0; i < legDetails["legDetailsRoot"].length; i++){
						var source = legDetails["legDetailsRoot"][i].source;
						var destination = legDetails["legDetailsRoot"][i].destination;
						var sta = legDetails["legDetailsRoot"][i].sta;
						var std = legDetails["legDetailsRoot"][i].std;
						var name = legDetails["legDetailsRoot"][i].name;
						var legId = legDetails["legDetailsRoot"][i].legId;
						count = i+1;
						$("#legTableId").append("<tr><td style='font-weight:700;'>"+ count +". </td> <td style='display:none;' id=legId"+count+">"+legId+"</td> <td>"+name+"</td> <td>"+source+"</td>"+
						" <td>"+destination+"</td> <td id=stdId"+count+">"+std+"</td> <td id=staId"+count+">"+sta+"</td>"+
					 	" <td><select class=comboClassDriver id=driverId1"+count+" data-live-search=true onchange='changeFun("+count+")' required=required></select></td> "+
					 	" <td><select class=comboClassDriver id=driverId2"+count+" data-live-search=true onchange='changeFun("+count+")' required=required></select></td></tr>");
					}
				}else{
					document.getElementById("tabelId").style.display = "none";
				}
			}
		});
		setTimeout( function() {
			$.ajax({
	      		url: '<%=request.getContextPath()%>/TripCreatAction.do?param=getDriverList',
	      		success: function(result) {
	           		driverList = JSON.parse(result);
	           		for(var rec = 1; rec <= recordsCount; rec++){
	           		for (var j = 0; j < driverList["driverDetailsRoot"].length; j++) {
	                  	$('#driverId1'+rec).append($("<option></option>").attr("value", driverList["driverDetailsRoot"][j].driverId).text(driverList["driverDetailsRoot"][j].driverName));
	                  	$('#driverId2'+rec).append($("<option></option>").attr("value", driverList["driverDetailsRoot"][j].driverId).text(driverList["driverDetailsRoot"][j].driverName));
	           		}
	           		$('#driverId1'+rec).select2();
		            $('#driverId2'+rec).select2();
		           } 		
	      		}
			});
		},1000);
	}
	function loadCustomerAndVehicle(){
			var date = document.getElementById('adddateTimeInput').value;
		
		$("#addcustNameDownID").empty().select2();
   		$.ajax({
	        url: '<%=request.getContextPath()%>/TripCreatAction.do?param=getCustomer',
	        success: function(result) {
	            addcustList = JSON.parse(result);
	            for (var i = 0; i < addcustList["customerRoot"].length; i++) {
                    $('#addcustNameDownID').append($("<option></option>").attr("value", addcustList["customerRoot"][i].CustId).text(addcustList["customerRoot"][i].CustName));
	            }
	            $('#addcustNameDownID').select2();
			}
		});
	}
	
	
	    $('#addvehicleDropDownID').change(function() {
            $("#temperatureTableId").empty();
            $("#temperatureEvents").empty();
            var currentProductLine = "TCL";//document.getElementById('addProductLineComboId').value;
            if(currentProductLine == "TCL" || currentProductLine == "Chiller" || currentProductLine == "Freezer"){
		        isRS232Vehicle = $('#addvehicleDropDownID option:selected').attr("isRS232Assoc");
				if(isRS232Vehicle == 'N'){
				    maxNegativeTemp = parseFloat($('#addvehicleDropDownID option:selected').attr("minTempLimit"));
				    minNegativeTemp = maxNegativeTemp-5;
				    minPositiveTemp =parseFloat( $('#addvehicleDropDownID option:selected').attr("maxTempLimit"));
				    maxPositiveTemp = minPositiveTemp +5;
					temperatureCounter = 1;
					$("#temperatureTableId").append(
					"<tr><th> Temperature Settings </th></tr>"+
					 "<tr> <td><input value = -70  class='colorbox'  style='color:black' disabled /></td> "+
					 " <td width = 10% ><input class='colorbox' style='background-color: red;' value='Critical' disabled></td><td width = 10%  id=temperatureColumns><input class='mybox' id=ex20 value = "+minNegativeTemp+" type=text style=text-align:center; onkeypress='return checkTemperature(event)' onchange = 'checkTemperature1(this.id,this.value)'  required /></td>"+
					 " <td width = 10% ><input class='colorbox' style='background-color: yellow;color:black' value='Abnormal' disabled ></td><td width = 10%  id=temperatureColumns><input class='mybox' id=ex30  value = "+maxNegativeTemp+" type=text style=text-align:center; onkeypress='return checkTemperature(event)' onchange = 'checkTemperature1(this.id,this.value)' required /></td>"+
					 " <td width = 10% ><input class='colorbox' style='background-color: green;' value='Normal' disabled ></td><td width = 10%  id=temperatureColumns><input class='mybox' id=ex40  value = "+minPositiveTemp+" type=text style=text-align:center; onkeypress='return checkTemperature(event)' onchange = 'checkTemperature1(this.id,this.value)' required /></td>"+
					 " <td width = 10% ><input class='colorbox' style='background-color: yellow;color:black' value='Abnormal' disabled ></td><td width = 10%  id=temperatureColumns><input class='mybox' id=ex50  value = "+maxPositiveTemp+" type=text  style=text-align:center; onkeypress= 'return checkTemperature(event)' onchange = 'checkTemperature1(this.id,this.value)' required /></td> "+
					 " <td width = 10% ><input class='colorbox' style='background-color: red;' value='Critical' disabled ></td> " +
					 " <td><input value = 70  class='colorbox'  style='color:black' disabled /></td> "+
					 " <td width = 10% style=display:none;  id=temperatureColumns><input class='mybox' id=ex60 value = ANALOG  type=text  style=text-align:center; required /></td>					 </tr>");
				}else{
		     		getTemperatureConfigurationForR232();      
			 	 }
			  }
         });
         
         function getTemperatureConfigurationForR232(){
         	$.ajax({
			        url: '<%=request.getContextPath()%>/TripCreatAction.do?param=getTempConfigurationsByVehicleNo',
			        data: {
			         productLine : document.getElementById('addProductLineComboId').value,
			         vehicleNo :  document.getElementById('addvehicleDropDownID').value
		        	
			        },
			        success: function(result) {
			        	temperatureCounter = 0;
			            beanList = JSON.parse(result);
			            if (beanList["tempConfigurationsByVehicleNoDetails"].length > 0){
			            for (var i = 0; i < 1; i++) {
			             temperaturesArray = "";
			             temperatureCounter++;
			            	 var name1 =  beanList["tempConfigurationsByVehicleNoDetails"][i].name ;
							 minPositiveTemp = beanList["tempConfigurationsByVehicleNoDetails"][i].minPositiveTemp; 
						     minNegativeTemp = beanList["tempConfigurationsByVehicleNoDetails"][i].minNegativeTemp;
						     maxPositiveTemp = beanList["tempConfigurationsByVehicleNoDetails"][i].maxPositiveTemp;
						     maxNegativeTemp = beanList["tempConfigurationsByVehicleNoDetails"][i].maxNegativeTemp;
						     var sensor = beanList["tempConfigurationsByVehicleNoDetails"][i].sensorName;
						    $("#temperatureTableId").append(
						    "<tr><th> Temperature Settings </th></tr>"+
						     //" <input value = 'Temperature Setting'  type=text style='text-align:center;width: 55px;' disabled /></td>"+ 
						     "<tr> <td><input value = -70  class='colorbox'  style='color:black' disabled /></td> "+
						     " <td width = 10% ><input class='colorbox' style='background-color: red;' value='Critical' disabled></td><td width = 10%  id=temperatureColumns><input class='mybox' id=ex2"+i+" value = "+minNegativeTemp+"  type=text style=text-align:center; onkeypress='return checkTemperature(event)' onchange = 'checkTemperature1(this.id,this.value)'  required /></td>"+
						     " <td width = 10% ><input class='colorbox' style='background-color: yellow;color:black' value='Abnormal' disabled ></td><td width = 10%  id=temperatureColumns><input class='mybox' id=ex3"+i+" value = "+maxNegativeTemp+"  type=text style=text-align:center; onkeypress='return checkTemperature(event)' onchange = 'checkTemperature1(this.id,this.value)' required /></td>"+
						     " <td width = 10% ><input class='colorbox' style='background-color: green;' value='Normal' disabled ></td><td width = 10%  id=temperatureColumns><input class='mybox' id=ex4"+i+" value = "+minPositiveTemp+"  type=text style=text-align:center; onkeypress='return checkTemperature(event)' onchange = 'checkTemperature1(this.id,this.value)' required /></td>"+
						     " <td width = 10% ><input class='colorbox' style='background-color: yellow;color:black' value='Abnormal' disabled ></td><td width = 10%  id=temperatureColumns><input class='mybox' id=ex5"+i+" value = "+maxPositiveTemp+"  type=text  style=text-align:center; onkeypress= 'return checkTemperature(event)' onchange = 'checkTemperature1(this.id,this.value)' required /></td> "+
						     " <td width = 10% ><input class='colorbox' style='background-color: red;' value='Critical' disabled ></td> " +
						     " <td><input value = 70  class='colorbox'  style='color:black' disabled /></td> "+
						     " <td width = 10% style=display:none;  id=temperatureColumns><input class='mybox' id=ex6"+i+" value = "+sensor+"  type=text  style=text-align:center; required /></td>					 </tr>");
			            }
			           tempSensorNames = [];
			             if(temp=='N')
							 {
							 var fields = document.getElementById("temperatureTableId").getElementsByTagName('*');
								for(var i = 0; i < fields.length; i++)
								{
								    fields[i].disabled = true;
								}
							 }
							 document.getElementById("tempConfigTableId").style.display = "block";		
							 document.getElementById("temperatureTableId").style.display = "block";	
			            }else{
			            sweetAlert("No temperatures found for selected vehicle");
			            checkProduct();
			            }
						    
			        }
			    });
			}
    
    
        function setVehicleTypeAndModel() {
        for (var i = 0; i < vehicleStoreWithTypeAndModel.getCount(); i++) {
            var vehicleName = document.getElementById("addvehicleDropDownID").value;
            var storeVehicle = vehicleStoreWithTypeAndModel.getAt(i);
            if (vehicleName == storeVehicle.data['vehicleName']){
            var type = storeVehicle.data['vehicleType'];
            var model = storeVehicle.data['vehicleModel'];
			document.getElementById("vehicleTypeId").value = type ;
			document.getElementById("vehicleModelId").value = model ;
            }
		}
    }
    
    
	
	//*var vehicleStoreWithTypeAndModel = new Ext.data.JsonStore({
      //  id: 'vehicleStoreWithTypel',
       // root: 'clientVehicles',
       // autoLoad: false,
       // remoteSort: true,
       // fields: ['vehicleName', 'vehicleType', 'vehicleModel']
    //});*//
		
	function loadData(){
		$("#addrouteDropDownID").empty().select2();
		$.ajax({
	        url: '<%=request.getContextPath()%>/TripCreatAction.do?param=getRouteNames',
	        data: {
	        	custId : $('#addcustNameDownID option:selected').attr("value"),
	        	legConcept:'N',
	        	hubAssociatedRoutes : 'Y'
	  
	        },
	        success: function(result) {
	            routeList = JSON.parse(result);
	            for (var i = 0; i < routeList["RouteNameRoot"].length; i++) {
                    $('#addrouteDropDownID').append($("<option></option>").attr("value", routeList["RouteNameRoot"][i].RouteId).attr("count",routeList["RouteNameRoot"][i].legCount)
                    .text(routeList["RouteNameRoot"][i].RouteName));
	            }
	            $('#addrouteDropDownID').select2().trigger('change');
	        }    
				
		});
		$("#categoryComboId").empty().select2();
		$.ajax({
	        url: '<%=request.getContextPath()%>/TripCreatAction.do?param=getCategory',
	        data: {
	        	custId : $('#addcustNameDownID option:selected').attr("value")
	        },
	        success: function(result) {
	             var categoryStore = JSON.parse(result);
	            for (var i = 0; i < categoryStore["categoryRoot"].length; i++) {
                    $('#categoryComboId').append($("<option></option>").attr("value", categoryStore["categoryRoot"][i].categoryvalue)
                    .text( categoryStore["categoryRoot"][i].categoryvalue));                   
	            }
	            $('#categoryComboId').select2();
	           	            
	        }    
				
		});
		 var date = document.getElementById('adddateTimeInput').value;
	}
	function closeTrip(){ 
	    var remarksData = "";
		if('<%=userAuthority%>' != 'Admin'){
			sweetAlert("Only admin users can close the trip");
			return;
		}
		var remarksDetails = document.getElementById("remarksCloseId").value;	
	    if(remarksDetails.trim().length==0){
			sweetAlert("Please Enter Remarks");
			document.getElementById("remarksCloseId").value="";		
    		return;	
		}
		$.ajax({
	        url: '<%=request.getContextPath()%>/SemiAutoTripAction.do?param=closeSemiAutoTrip',
	        data: {
	        	uniqueId,
	        	vehicleNo:globalVehicleSelected,
	        	remarksData: remarksDetails,
	        	tripCloseDate : document.getElementById("tripCloseTimeInput").value
	        },
	        success: function(result) {
	       	$('#closeModal').modal('hide');
                	setTimeout(function(){
                		sweetAlert(result);
                    	getData();
                    }, 1000);
	            }
		});
	}
	
    function closeCancelTrip(){
   		document.getElementById("remarksId").value="";
   }	
   function closeTripCloseModal(){
   		document.getElementById("remarksCloseId").value="";
   }   		
    function validateTripLRNoOnChange(){
       
        var customerName = document.getElementById("custDropDownId").value;
   		var lrNo = document.getElementById('addorderId').value;
   		var tripCustomerId = document.getElementById('addcustNameDownID').value;
   		 $.ajax({
	        url: '<%=request.getContextPath()%>/TripCreatAction.do?param=validateTripLRNo',
	        data: {
	        	lrNo : lrNo,
	        	tripCustomerId : tripCustomerId
	        },
	        success: function(result) {
            		
            		if (result == "NO RECORDS FOUND"){
            			document.getElementById('addorderId').value=lrNo;
            		}else{
            			sweetAlert("Trip  No already exists!!!");
            			document.getElementById('addorderId').value = '';
            		 	return;
            		}
	            }
		});
				
   }
     
   function validateTripLRNo(){
       
        var customerName = document.getElementById("custDropDownId").value;
   		var lrNo = document.getElementById('addorderId').value;
   		var tripCustomerId = document.getElementById('addcustNameDownID').value;			
	    $.ajax({
	        url: '<%=request.getContextPath()%>/TripCreatAction.do?param=validateTripLRNo',
	        data: {
	        	lrNo : lrNo,
	        	tripCustomerId : tripCustomerId
	        },
	        success: function(result) {
            		
            		if (result == "NO RECORDS FOUND"){
            			saveData();
            		}else{
            			sweetAlert("Trip No already exists!!!");
            			document.getElementById('addorderId').value = '';
            		 	return;
            		}
	            }
		});
		
   }
   
	function getTripCancellationRemarks(){
	 if('<%=userAuthority%>' != 'Admin'){
			sweetAlert("Only admin users have authority");
			return;
	}
	
	$('#cancelModal').modal('show');
	remarksList = "";
	$('#tripCancellationRemarks').empty();
	document.getElementById("page-loader").style.display="block";
	$.ajax({
	        url: '<%=request.getContextPath()%>/TripCreatAction.do?param=getTripCancellationRemarks',
	        success: function(result) {
	            remarksList = JSON.parse(result);
	            for (var i = 0; i < remarksList["remarks"].length; i++) {
                    $('#tripCancellationRemarks').append($("<option></option>").attr("value", remarksList["remarks"][i].value).text(remarksList["remarks"][i].value));
	            }
	          document.getElementById("page-loader").style.display="none";
	        }
	    });
	}
	
 	////////////////////////////////////////////////////////////////////SEMI -automated //////////////////////////////////////////////////////
 	function getTripConfiguration(){
 			//Musact pharamcy routename is unplanned
 			document.getElementById("routeNameLbl").style.display = 'none';
			document.getElementById("routeNameIn").style.display = 'none';
 			document.getElementById("tripEndTimeLbl").style.display = 'none';
			document.getElementById("tripEndTimeIn").style.display = 'none';
			document.getElementById("tempConfigTableId").style.display = "block";		
			document.getElementById("temperatureTableId").style.display = "block";	
			document.getElementById("temperatureEvents").style.display = "block";
			
			var eventsTable = "<table><tr>";//Note 38 is hardcoded.read this from property file.
			eventsTable = eventsTable +"<td><label><input id=\"checkbox"+38+"\" type='checkbox' name='eventCheckbox' value="+38+" checked disabled>Temperature</label>&nbsp;&nbsp;</td>";	
			eventsTable = eventsTable + "</tr></table>";
			document.getElementById("eventTable").innerHTML = eventsTable;//SAT
			document.getElementById("eventTable").innerHTML = eventsTable;//SAT
			$("#addProductLineComboId").empty().select2();
	        $('#addProductLineComboId').append($("<option></option>").attr("value","TCL").text("TCL"));                   
	        $('#addProductLineComboId').select2();
	        checkProduct();
	        getCheckPoints();
	        getSource();
 	}
 
 function openCheckPointModal(){
	if(checkPointArray.length == 0){
		//if none of the check points are not saved after selection,
		if(srcDestMarkers != null){
	    	 for (var n = 0,leng = srcDestMarkers.length ; n < leng ; n++){
		        var currMar1 = srcDestMarkers[n];
			        	currMar1.setMap(null);
	        }
	        srcDestMarkers = [];
		counter = 0;  
        }
        }
	//clear this , after click on save in check point modal, again find this value
    checkPointNamesArray = "";
	checkPointArray = [];
 	$('#checkpointModal').modal('show');
 }
 
     function createCombo(counterI, hubId) {
        var html = '<div class="control-group input-group mydiv" style="margin-top:10px" >' +
            '<select onchange="drawCheckpoints(' + counterI + ')" name="addmore[]" class="form-control select2 style="width:200px!important;" checkpointC" id="checkpoint' + counterI + '"' + '>' +
            '<option>Enter checkpoint ' + counterI + '</option></select>' +
            '<div class="input-group-btn"><button title="Remove" class="btn btn-danger remove" style="margin-left: 10px; height: 29px; border-radius: 4px;" type="button" id="' + counterI + '"' + '><i class="glyphicon glyphicon-remove"></i></button>' +
            '</div></div>';
        $(".after-add-more").before(html);


          for (var i = 0; i < deliveryPointList.length; i++) {
              $('#checkpoint' + counterI).append($("<option></option>").attr("value", deliveryPointList[i].hubid).attr("latitude", deliveryPointList[i].latitude)
                  .attr("longitude", deliveryPointList[i].longitude).attr("radius",deliveryPointList[i].radius)
                  .attr("hubAddress",deliveryPointList[i].hubAddress).attr("detention", deliveryPointList[i].standard_Duration)
                  .text(deliveryPointList[i].name));
          }
          $('#checkpoint' + counterI).select2({ width: '100%'});
          if (hubId > 0) {
              $("#checkpoint" + counterI).val(hubId).trigger('change');
          }
    }
    function clearCheckPointsModalData(){
    	counter = 0;
    	sessionStorage.clear();
		sessionStorageKeys = [];
    	checkPointArray = [];
    	checkPointNamesArray = "";
    	if(srcDestMarkers != null){
	    	 for (var n = 0,leng = srcDestMarkers.length ; n < leng ; n++){
		        var currMar1 = srcDestMarkers[n];
			        	currMar1.setMap(null);
	        }  
        }
    }
       var counter = 0;
    $(".add-more").click(function() {
        counter++;
        createCombo(counter);
        $('#checkAddBtn').hide();
    });
     $("body").on("click", ".remove", function(e) {
        $(this).parents(".control-group").remove();
        removeId = $(this).attr("id");
        counter--;
        sessionStorage.removeItem(removeId);
	//remove the key from sessionstorage key
	var index = sessionStorageKeys.indexOf(parseInt(removeId));
	if (index > -1) {
  		sessionStorageKeys.splice(index, 1);
	}
        for (var n = 0,leng = srcDestMarkers.length ; n < leng ; n++){
	        var currMar1 = srcDestMarkers[n];
		        if (removeId == currMar1.id){
		        	currMar1.setMap(null);
		        }
        }  
        $('#checkAddBtn').show();
    });
    
    function initialize() {
        var mumbai = new google.maps.LatLng(<%=latitudeLongitude%>);
        var mapOptions = {
            zoom: 4.6,
            center: mumbai
        };
        map = new google.maps.Map(document.getElementById('dvMap'), mapOptions);
    }
    google.maps.event.addDomListener(window, 'load', initialize);
       var directionsService = new google.maps.DirectionsService;

  function drawCheckpoints(id) {
    	
        myLatLngC = new google.maps.LatLng($('#checkpoint' + id + ' option:selected').attr("latitude"), $('#checkpoint' + id + ' option:selected').attr("longitude"));
        convertintomtrs = Number($('#checkpoint' + id + ' option:selected').attr("radius")) * 1000;
        //DrawCircle(myLatLngC, convertintomtrs);
        sessionStorage.setItem(id, myLatLngC);
        if(!sessionStorageKeys.includes(id)){
			sessionStorageKeys.push(id);
		}
        if (directionsDisplay != null) {
            directionsDisplay.setMap(null);
        }
        //plotRoute(false);
        if(id>0){
           $('#checkAddBtn').show();
           createSDMarker(myLatLngC, $('#checkpoint' + id + ' option:selected').attr("hubAddress"),id);
        }
        
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
	        id: ID
	    });
		srcDestMarkers.push(marker);
	    google.maps.event.addListener(marker, 'click', function () {
	        infowindow.setContent(title);
	        infowindow.open(map, marker);
	    });
	}
  var durationArr=[];
  var distanceArr=[];
  var deliveryPointList = [];
  function getSource() {
        $.ajax({
            url: '<%=request.getContextPath()%>/GeneralVerticalDashboardAction.do?param=getHubsByOperationId',
            data:{
            	hubType : 1 //TODO read this from trip configuration
            },
            success: function(result) {
            $("#sourceId").empty().select2();
	            hubList = JSON.parse(result);
                for (var i = 0; i < hubList["hubDetailsRoot"].length; i++) {
                    $('#sourceId').append($("<option></option>").attr("value", hubList["hubDetailsRoot"][i].hubid).attr("latitude", hubList["hubDetailsRoot"][i].latitude)
                        .attr("longitude", hubList["hubDetailsRoot"][i].longitude).attr("radius", hubList["hubDetailsRoot"][i].radius).attr("detention", hubList["hubDetailsRoot"][i].standard_Duration).attr("hubAddress",
                        hubList["hubDetailsRoot"][i].address).text(hubList["hubDetailsRoot"][i].name));
                }
                $("#sourceId").select2();
            }
        });
    }
    function getCheckPoints() {
        $.ajax({
            url: '<%=request.getContextPath()%>/GeneralVerticalDashboardAction.do?param=getHubsByOperationId',
            data:{
            	hubType : 1
            },
            success: function(result) {
               hubList = JSON.parse(result);
               for (var i = 0; i < hubList["hubDetailsRoot"].length; i++) {
                    hubDetails = {};
                    hubDetails.hubid = hubList["hubDetailsRoot"][i].hubid;
                    hubDetails.latitude = hubList["hubDetailsRoot"][i].latitude;
                    hubDetails.longitude = hubList["hubDetailsRoot"][i].longitude;
                    hubDetails.radius = hubList["hubDetailsRoot"][i].radius;
                    hubDetails.standard_Duration = hubList["hubDetailsRoot"][i].standard_Duration;
                    hubDetails.hubAddress = hubList["hubDetailsRoot"][i].address;
                    hubDetails.name = hubList["hubDetailsRoot"][i].name;
                    deliveryPointList.push(hubDetails);
                }
            }
        });
    }
    function addCheckPoints(){
        var hubIdC=0;
		var checkPointData = {};
		//first push source hub detail
        for (var j = 0; j < sessionStorageKeys.length; j++) {
            arr = sessionStorage.getItem(sessionStorageKeys[j]).replace("(", "").replace(")", "").split(",");
            if(hubIdC == document.getElementById("checkpoint" + (sessionStorageKeys[j])).value){
            	sweetAlert("Sequential checkpoints should not be same.");
            	return;
            }
            hubIdC = document.getElementById("checkpoint" + (sessionStorageKeys[j])).value;
            checkPointData = {};
            checkPointData.hubId = document.getElementById("checkpoint" + (sessionStorageKeys[j])).value;
            checkPointData.latitude = arr[0];
            checkPointData.longitude =  arr[1];
            checkPointData.radius = $("#checkpoint"+sessionStorageKeys[j]+" option:selected").attr("radius");
            checkPointData.detentionTime = $("#checkpoint"+sessionStorageKeys[j]+" option:selected").attr("detention");
            checkPointArray.push(checkPointData);
            //checkPointArray.push('{' + sessionStorageKeys[j] + ',' + arr[0] + ',' + arr[1] + ',' + hubId + ',' + rad + ',' + det + '}')
	    var hubName = $("#checkpoint"+(sessionStorageKeys[j])+" option:selected").text();
	    var hubNameFirstPart = hubName.split(',')[0];
	    checkPointNamesArray = checkPointNamesArray + hubNameFirstPart + '_';
        }
        checkPointNamesArray = checkPointNamesArray.substr(0,checkPointNamesArray.length-1);
    	console.log(checkPointNamesArray);
    	console.log(checkPointArray);
    	document.getElementById("checkPointsTxt").value = checkPointNamesArray;
    	//todo
    	$('#checkpointModal').modal('hide');
    }
    
    function loadTripDetails(){
         if('<%=userAuthority%>' != 'Admin'){
			sweetAlert("Only admin users  have authority");
			return;
		 }else{
			$('#closeModal').modal('show');
		 }
         	
         }
         
    function convertToYYYYMMDDFormat(value){
    	var startDateIn = value;
	    var startDateTime =  startDateIn.split(" ");
	    let startDate = (startDateTime[0].split("/").reverse().join("-")) +" "+ startDateTime[1];
	    return startDate;
    }
	function showRemarks(){
		if(document.getElementById("tripCancellationRemarks").value == "Others"){
			document.getElementById("showRemarksId").style.display="block";
		}else{
			document.getElementById("showRemarksId").style.display="none";
		}
	}
	
	 function checkDateValidation(tripStart, loadingStart,loadingEnd) {
	     
	     var dd = date1.split("/");
	     var ed = date2.split("/");
	     var startDate = new Date(dd[1] + "/" + dd[0] + "/" + dd[2]);
	     var endDate = new Date(ed[1] + "/" + ed[0] + "/" + ed[2]);
	     var timeDiff = Math.abs(endDate.getTime() - startDate.getTime());
	     var daysDiff = Math.ceil(timeDiff / (1000 * 3600 * 24));
	     if (daysDiff <= 7) {
	         return true;
	     } else {
	         return false;
	     }
  }
  function getDateFromStrDate(date){
  		var datesplit = date.split(" ");
  		var datePart = datesplit[0].split("/");
  		var timePart = datesplit[1].split(":");
  		var date =  new Date(datePart[1] , datePart[0] , datePart[2],timePart[0],timePart[1]);
  }
  
  
    </script> 
<jsp:include page="../Common/footer.jsp"></jsp:include> 
<!-- &lt;/body&gt;   --> 
<!-- &lt;/html&gt; --> 
</div>