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
	int systemId = loginInfo.getSystemId();
	int customerId=loginInfo.getCustomerId();
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
    
    if(session.getAttribute("viewFlag")!=null){
    	viewFlag=session.getAttribute("viewFlag").toString();
    } 
    if(session.getAttribute("startDate")!=null){
     	startDate=session.getAttribute("startDate").toString();
    }
   if(session.getAttribute("endDate")!=null){
     	endDate=session.getAttribute("endDate").toString();
   }
    if(session.getAttribute("fromTripImageUpload")!=null){
    	fromTripImageUpload=session.getAttribute("fromTripImageUpload").toString();
   }
   if(session.getAttribute("unsuccessfulImageUpload")!=null){
    	unsuccessfulImageUpload=session.getAttribute("unsuccessfulImageUpload").toString();
   }
	Properties properties = ApplicationListener.prop;
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
    
    String legConcept = gvf.getLegConcept(systemId,customerId);
    
	String userAuthority = cf.getUserAuthority(systemId,userId);
	
	ArrayList<String> settingData=ctf.getTripSheetSettingData(systemId,customerId);
	String averageSpeed = settingData.get(0);
	String allEvents = settingData.get(1);
	String extraFields = settingData.get(2);
	String vehicleReporting = settingData.get(3);
	String hubAssociatedRoutes = settingData.get(4);
	String swapVehicleColumn = settingData.get(5);
	String rowData = settingData.get(6);
	String materialClient = settingData.get(7);
	String canOverrideActualTimeUsers = settingData.get(8);
	String category = settingData.get(9);
	String humidity = settingData.get(10);
	String temperature = settingData.get(11);
	String events = settingData.get(12);
	boolean canOverrideActuals =true;
	boolean isCanOverrideActualTimeUsers = false;
	//Check if the user has permission to override actual ATA, ATP,ATD
	if(canOverrideActualTimeUsers != null && !canOverrideActualTimeUsers.equals("")){
		isCanOverrideActualTimeUsers =  true;
		String[] userIds = canOverrideActualTimeUsers.split(",");
		if(Arrays.asList(userIds).contains(new Integer(userId).toString())){
			canOverrideActuals = true;
		}
	}
	int offset = loginInfo.getOffsetMinutes();
	
	int atpContraint = Integer.parseInt(properties.getProperty("atpContraint"));
	int atdContraint = Integer.parseInt(properties.getProperty("atdContraint"));
	String t4uspringappURL = properties.getProperty("t4uspringappURL").trim();
        
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
#closemodalcontent {
	width : max-content !important;
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

.updateActual{
	top: 60px !important;
    position: absolute;
    width: 90%;
    margin-left: 5%;
    height: 85%;
}


</style>
<!-- </head> -->

<!-- <body onload=getCustomer()>  -->

<div class="panel panel-primary">
	<div class="panel-heading">
		<h3 class="panel-title">
			Trip Actions & Summary
		</h3>
	</div>
	<div class="panel-body" style="overflow:hidden">
		<div class="row">
			<div class="col-lg-9">
			<div class="row">
				<div class="col-lg-3" style = "display:none;">
					<label for="staticEmail2" class="col-lg-5" style = "margin-left: -19px;">
						Customer
					</label>

					<select class="col-lg-7" id="custDropDownId"
						data-live-search="true" onchange="getVehicleAndRouteName(this)"
						style="height: 25px;">
						<!--						<option style="display: none"></option>-->
						<option selected></option>

					</select>

				</div>
				<div class="col-lg-8" style="display: inherit; margin-left: 30px;">
					<label for="staticEmail2" class="col-lg-3" >
						Start Date
					</label>
					<div class='col-lg-3 input-group date'
						style="margin-left: -9% !important;">
						<input type='text' id="dateInput1" />
					</div>
					<label for="staticEmail2" class="col-lg-3" style = "margin-left: -25px;">
						End Date
					</label>
					<div class='col-lg-3 input-group date'
						style="margin-left: -9% !important;">
						<input type='text' id="dateInput2" />
					</div>
				
				<div class="col-lg-3" style="margin-left: 2px;">
					<label for="staticEmail2" class="col-lg-4" style = "margin-left: -50px; top: 2px;">
						Type
					</label>
					<select class="col-lg-12" id="statusTypeDropDownId"
						data-live-search="true" style="height: 25px; position: relative; left: 12px;">
						<option selected value="ALL" >
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
						<option value="UPCOMING">
							Upcoming
						</option>
					</select>

				</div>
				
				 <div class="col-lg-3" >
                    <label for="staticEmail2" class="col-lg-10" style = " top: 3px; margin-left: -13px;">
						Vehicle No
					</label>
                  <div style = "position: relative; left: 90px; top:-24px;">
                  <select class="col-lg-12" id="vehicleNo" >
                  		<option>All</option>
                  </select>
               </div>
				</div>
				 </div>
               
				
				</div>
			</div>
			<div class="col-lg-3">
<!--			<div class="row">-->
<!--				<div class="col-lg-2">-->
					<button id="viewId" class="btn btn-primary" onclick="getData()">
						View
					</button>
<!--				</div> -->
<!--				<div class="col-lg-2">-->
					<button id = "addId" title="ADD" onclick="openAddModal()"
						class="btn btn-primary" >
						ADD
					</button>
<!--				</div>-->
<!--				<div class="col-lg-3">-->
					<button id="overrideActualsBtn" class="btn btn-primary"
						onclick="openOverideActualsModal()">
						Override Actuals
					</button>
<!--				</div>-->
<!--				<div class="col-lg-3">-->
				<button id="updateActualId" type="button" class="btn btn-danger btn-sm" style="background-color:#337ab7" onclick="openUpdateActualsModal()" >
	      			<span id="countenvelope" class="glyphicon glyphicon-envelope" title="To update missing actuals of closed trips"></span>
	  			</button>
<!--	  			</div>-->
<!--				<div class="col-lg-3">-->
					<button class="btn btn-info" title="Vehicle Reporting"
						onclick="openVehicleReportPage()" class="btn"
						id="vehicleReportBtnId" style="margin-left: 10px; display: none;">
						Back
					</button>
<!--				</div>-->
<!--			</div>-->
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
						Route Name
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
						Trip Date / Time
					</th>
					<th>
						Average Speed (kms/hr)
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
					<th>
						Overridden By
					</th>
					<th>
						Overridden Date
					</th>
					<th>
						Overridden Remarks
					</th>
					<th >
						Cancel/Close/Reopen By - Date
					</th>
					<th>
						Cancelled/Closed/Reopened Remarks
					</th>
					<th>
						Image
					</th>
					<th>
						Action
					</th>
					<th>
						Modify
					</th>
					<th style="display: none;">
						Change Route
					</th>
					<th id="swapVehicleColumnId">
						Swap Vehicle
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
					<th style="display: none;">
						ATD
					</th>
					<th style="display: none;">
						Seal No
					</th>
					<th style="display: none;">
						No Of Bags
					</th>
					<th style="display: none;">
						Trip Type
					</th>
					<th style="display: none;">
						No Of Bags
					</th>
					<th style="display: none;">
						Opening Kms
					</th>
					<th style="display: none;">
						Trip Remarks
					</th>
					<th style="display: none;">
						Route Template
					</th>
					<th style="display: none;">
						Material
					</th>
					<th style="display: none;">
						Total TAT
					</th>
					<th style="display: none;">
						Total RunTime
					</th>
					<th style="display: none;">
						STA
					</th>
					<th style="display: none;">
						ATA
					</th>
					<th style="display: none;">
						Category
					</th>
					<th style="display: none;">
						ACTUAL TRIP END TIME
					</th>
					<th style="display: none;">
						STP
					</th>
					<th style="display: none;">
						ATP
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
									Customer Name
								</td>
								<td>
									<select class="comboClass" id="addcustNameDownID"
										data-live-search="true" required="required"></select>
								</td>

								<td id="routeNameLblTDId">
									Route Name
								</td>
								<td id="routeNameTDId">
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
								<td id="routeTemplateLblTDId">
									Route Template
								</td>
								<td id="routeTemplateId">
									<select class="comboClass" id="routeTemplateDropDownID"
										data-live-search="true" required="required"
										onchange="loadMaterials()"></select>
								</td>
								<td id="productLineLblId">
									Product Line
								</td>
								<td id="productLineId">
									<select class="comboClassVeh" id="addProductLineComboId"
										required="required" onchange="checkProduct()"></select>
								</td>
								<td id="materialLblId">
									Material
								</td>
								<td id="materialId">
									<select class="comboClassVeh" id="addMaterialComboId"
										required="required" onchange="loadRouteLegTATDetails()"></select>
								</td>
							</tr>
							<tr>
								<td>
									Vehicle Number
								</td>
								<!-- <td><select class="comboClassVeh" id="addvehicleDropDownID"  required="required" onchange="checkAssociationDetails()"></select></td> -->
								<td>
									<select class="comboClassVeh" id="addvehicleDropDownID"
										required="required"></select>
								</td>

								<td>
									Customer Ref. ID
								</td>
								<td>
									<input type="text" class="form-control comboClass"
										maxLength="15" id="custReferenceId"
										onkeypress="return checkSpcialChar(event)">
								</td>

								<td id="categoryLblId">
									Category
								</td>
								<td id="categoryId">
									<select class="comboClassVeh" id="categoryComboId"
										required="required"></select>
								</td>
								<!-- <td>Trip  No</td>
				      			<td><input type="text" class="form-control comboClass" maxLength="15" id="addorderId" onkeypress="return checkSpcialChar(event)" ></td> -->
							</tr>
							<tr>
								<td>
									Trip Date/Time
								</td>
								<td>
									<input type="text" id="adddateTimeInput" class='form-control'>
								</td>

								<td>
									Average Speed (km/hr)
								</td>
								<td>
									<input type="text" class="form-control comboClass"
										id="avgSpeedId" min="1" maxLength="4" step="any"
										class='comboClass' onkeypress="return checkSpeed(event)"
										onchange="checkTemperature1(this.id,this.value)">
								</td>

								<td data-toggle="tooltip" data-placement="bottom"
									title="Upload Delivery Challan or Trip Related Slips">
									Upload Image
								</td>
								<td>
									<form id="imageForm"
										action="<%=request.getContextPath()%>/UploadCreateTripImage"
										enctype="multipart/form-data" method="POST">
										<input type="file" class="inputstl" id="imgUploadId"
											name="sentfile" accept=".jpg" data-toggle="tooltip"
											data-placement="bottom"
											title="Upload Delivery Challan or Trip Related Slips">
									</form>
								</td>
							</tr>
							<tr id="totalTATDetails">
								<td>
									Total TAT(DD:HH:mm)
								</td>
								<td>
									<input type="text" id="totalTAT"
										class="form-control comboClass" disabled>
								</td>

								<td>
									Total RunTime(DD:HH:mm)
								</td>
								<td>
									<input type="text" id="totalRunTime"
										class="form-control comboClass" disabled>
								</td>
								</td>

							</tr>
							<%=rowData%>
							<tr>
								<td>
									Vehicle Type
								</td>
								<td>
									<input type="text" class="form-control comboClass" disabled
										maxLength="15" id="vehicleTypeId">
								</td>

								<td>
									Vehicle Model
								</td>
								<td>
									<input type="text" class="form-control comboClass" disabled
										maxLength="15" id="vehicleModelId">
								</td>



							</tr>
							<!--				      		<tr id="extraFields">				      							      			      			-->
							<!--				      			<td>Seal Number</td>-->
							<!--				      			<td><input type="text" class="form-control comboClass" maxLength="10" id="sealNoId" onkeypress="return checkSpcialChar(event)"></td>-->
							<!--				      			-->
							<!--				      			<td>Number of Bags</td>-->
							<!--				      			<td><input type="text" class="form-control comboClass" id="noOfBagsId" min="0" maxLength="4" step="any" class='comboClass' onkeypress="return checkSpeed(event)"></td>	-->
							<!--				      			-->
							<!--				      			<td>Trip Type</td>-->
							<!--				      			<td><input type="text" class="form-control comboClass" maxLength="15" id="tripTypeId" onkeypress="return checkSpcialChar(event)"></td>-->
							<!--				      		</tr>-->
							<!--				      		<tr id="extraFields2">				      							      			      			-->
							<!--				      			<td>Number of Fluid Bags</td>-->
							<!--				      			<td><input type="text" class="form-control comboClass" min="0" maxLength="10" id="fluidBagsId" onkeypress="return checkSpeed(event)"></td>-->
							<!--				      			-->
							<!--				      			<td>Opening Kms</td>-->
							<!--				      			<td><input type="text" class="form-control comboClass" id="openingKmsId" min="0" maxLength="4" step="any" class='comboClass' onkeypress="return checkSpeed(event)"></td>	-->
							<!--				      			-->
							<!--				      			<td>Remarks</td>-->
							<!--				      			<td><input type="text" class="form-control comboClass" maxLength="100" id="tripRemarksId" onkeypress="return checkSpcialChar(event)"></td>-->
							<!--				      		</tr>-->
							<tr>
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
								<table id="tempTableId"
									class="table table-sm table-bordered table-striped"
									style="display: none">
									<tr>
										<td align="center">
											Pre-loading Temperature (°C)
										</td>
										<td>
											<input type="text" id="preTempId" maxLength="4" step="any"
												class='comboClass'
												" 
					      				onkeypress="return checkTemperature(event)"
												onchange="checkTemperature1(this.id,this.value)">
										</td>
										<td align="center" style="width: 28%;" id="humidity">
											Humidity (%)
										</td>
										<td id="humiditymin">
											Min
										</td>
										<td id="humidityminId">
											<input type="text" id="minHumidityId" min="1" maxLength="3"
												step="any" class='comboClass'
												onkeypress="return checkSpeed(event)"
												onchange="checkTemperature1(this.id,this.value)">
										</td>
										<td id="humiditymax">
											Max
										</td>
										<td id="humiditymaxId">
											<input type="text" id="maxHumidityId" min="1" maxLength="3"
												step="any" class='comboClass'
												onkeypress="return checkSpeed(event)"
												onchange="checkTemperature1(this.id,this.value)">
										</td>
									</tr>
								</table>
							</tr>
							<tr>
								<table class="" id="tempConfigTableId" style="display: none">

									<tbody id="temperatureTableId"></tbody>
								</table>
							</tr>
							<div id="event">
								<tr>
									<td>
										Events
									</td>
									<td>
										<table>
											<tr>
												<td>
													<label>
														<input id="checkboxAll" type="checkbox" value="0">
														ALL
													</label>
												</td>
											</tr>
											<tr>
												<td>
													<label>
														<input id="checkbox1" type="checkbox" value="105">
														Harsh Driving
													</label>
												</td>
												<td id="emptyColumn2">
												</td>
												<td>
													<label>
														<input id="checkbox2" type="checkbox" value="17">
														Hub Arrival
													</label>
												</td>
												<td id="emptyColumn2">
												</td>
												<td>
													<label>
														<input id="checkbox3" type="checkbox" value="135">
														Trip Start
													</label>
												</td>
												<td id="emptyColumn2">
												</td>
												<td>
													<label>
														<input id="checkbox4" type="checkbox" value="18">
														Hub Departure
													</label>
												</td>
												<td id="emptyColumn2">
												</td>
												<td>
													<label>
														<input id="checkbox5" type="checkbox" value="136">
														Trip End
													</label>
												</td>
												<td id="emptyColumn2">
												</td>
												<td>
													<label>
														<input id="checkbox6" type="checkbox" value="5">
														Route Deviation
													</label>
												</td>
												<td id="emptyColumn2">
												</td>
												<td>
													<label>
														<input id="checkbox7" type="checkbox" value="2">
														Over Speed
													</label>
												</td>
												<td id="emptyColumn2">
												</td>
												<td>
													<label>
														<input id="checkbox14" type="checkbox" value="194">
														High/Low RPM
													</label>
												</td>
											</tr>
											<tr>
												<td>
													<label>
														<input id="checkbox8" type="checkbox" value="39">
														Idle
													</label>
												</td>
												<td id="emptyColumn2">
												</td>
												<td>
													<label>
														<input id="checkbox9" type="checkbox" value="1">
														Vehicle Stoppage
													</label>
												</td>
												<td id="emptyColumn2">
												</td>
												<td>
													<label>
														<input id="checkbox10" type="checkbox" value="37">
														Seat Belt
													</label>
												</td>
												<td id="emptyColumn2">
												</td>
												<td>
													<label>
														<input id="checkbox11" type="checkbox" value="85">
														Vehicle Non-Communicating
													</label>
												</td>
												<td id="emptyColumn2">
												</td>
												<td>
													<label>
														<input id="checkbox12" type="checkbox" value="134">
														Route Re-join
													</label>
												</td>
												<td id="emptyColumn2">
												</td>
												<td>
													<label>
														<input id="checkbox13" type="checkbox" value="38">
														Door Sensor
													</label>
												</td>
												<td id="emptyColumn2">
												</td>
												<td>
													<label>
														<input id="checkbox15" type="checkbox" value="193">
														Low Fuel
													</label>
												</td>
												<td id="emptyColumn2">
												</td>
												<td>
													<label>
														<input id="checkbox16" type="checkbox" value="195">
														Mileage
													</label>
												</td>
												<td id="emptyColumn2">
												</td>
											</tr>
										</table>
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
							data-live-search="true" required="required"></select>
					</span>
					<br />
				</div>
				<div id="showRemarksId">
					<label for="remarks" style="text-align: center;">
						Remarks
					</label>
					<textarea class="form-control rounded-0" id="remarksId" rows="3"></textarea>
					<br />
				</div>
				<button
					style="margin-left: 215px; background-color: #158e1a; border-color: #158e1a; margin-top: 25px;"
					type="button" onclick="cancelTrip()" class="btn btn-success">
					Save
				</button>
				<button
					style="margin-left: 16px; background-color: #da2618; border-color: #da2618; margin-top: 25px;"
					type="button" class="btn btn-warning" data-dismiss="modal"
					onclick="closeCancelTrip()">
					Cancel
				</button>
			</div>
		</div>

	</div>
</div>

<div class="modal fade" id="closeModal" role="dialog" 	data-backdrop="static" data-keyboard="false">
	<div class="modal-dialog" style="margin-top: 8%">
		<!-- Modal content-->
		<div class="modal-content" id="closemodalcontent">
			<div class="modal-body" align="center !important">
				<table class="table table-sm table-bordered table-striped" 	id="ataTable">
					<tbody>
						<tr> 
							<td>STP</td>
							<td><input type="text" id="stpDateTimeClosure" class="form-control comboClass" readonly></td>
							<td>ATP <sup><font color="red">&nbsp;*</font></sup></td>
							<td><input type="text" id="atpDateTimeClsoure" class='form-control'></td>
				   		</tr>
				   		<tr> 
							<td>STD</td>
							<td><input type="text" id="stdDateTimeClosure" class="form-control comboClass" readonly></td>
							<td>ATD <sup><font color="red">&nbsp;*</font></sup></td>
							<td><input type="text" id="atdDateTimeClsoure" class='form-control'></td>
				   		</tr>
						<tr> 
							<td>STA</td>
							<td><input type="text" id="staDateTime" class="form-control comboClass" readonly></td>
							<td>ATA <sup><font color="red">&nbsp;*</font></sup></td>
							<td><input type="text" id="ataDateTimeInput" class='form-control'></td>
				   		</tr>
				  		<tr>
							<td>Trip End Time <sup><font color="red">&nbsp;*</font></sup> </td>
							<td><input type="text" id="tripEndDateTimeInput" class='form-control'></td>
				  		</tr>
					</tbody>
				</table>
				<label for="remarks" style="text-align: center;"> Remarks <sup><font color="red">&nbsp;*</font></sup></label>
				<textarea class="form-control rounded-0" id="remarksCloseId" rows="3"></textarea>
				<br />
				<button  style="margin-left: 185px; background-color: #158e1a; border-color: #158e1a;" type="button" onclick="closeTrip()"   class="btn btn-success"> Save and Close </button>
				<button	style="margin-left: 16px; background-color: #da2618; border-color: #da2618;" type="button" class="btn btn-warning" data-dismiss="modal"  onclick="closeTripCloseModal()"> Cancel </button>
			</div>
		</div>

	</div>
</div>

<div class="modalimg" id="viewImageModal">
	<!--        <button type="button" class="close" data-dismiss="modal">&times;</button>-->
	<span id="imgCloseId" class="imgclose">&times;</span>
	<img id="tripImage" class="imagecontent" onerror="imgError()" />
	<!--		    <img class="modal-content" id="tripImage" img src="file://C:/CreateTripImage/Trip_Id_7976.jpg" />  style="width: 700px;height: 500px;margin-top: 189px;margin-left: px;" -->
	<!--img src="/ApplicationImages/CreateTripImage/Trip_Id_7976.jpg"-->

	<div id="caption"></div>
</div>


<div id="modify" class="modal fade" data-backdrop="static" data-keyboard="false"> 
	<div class="modal-dialog" 		style="position: absolute; left: 2%; top: 52%; margin-top: -250px; width: 95% !important; max-width: 100% !important;">
		<div class="modal-content">
			<div class="modal-header" style="padding: 1px;">
				<h4 id="nome" class="modal-title"> 	Modify Trip Information </h4>
				<button type="button" onclick="cancel()" class="close" 	data-dismiss="modal"> &times; </button>
			</div>
			<div class="modal-body" style="max-height: 100%; margin-bottom: 2px;">
				<div class="col-md-12"> 
					<table class="table table-sm table-bordered table-striped">
						<tbody>
							<tr>
								<td>Customer Name</td>
								<td><input type="text" class="form-control comboClass" 	id="modifycustNameDownID" readonly> </td>
								<td id="modifyRouteNameLbl"> Route Name </td>
								<td id="modifyRouteTemplateLbl"> Route Template Name </td>
								<td>
									<select class="comboClass" id="modifyrouteDropDownID"  onchange="plotLegDetailsModificationOnRouteChange()" data-live-search="true">
									</select>
								</td>

								<!--<td><input type="text" class="form-control comboClass" id="modifyrouteDropDownID" ></td>  
				      			      	
				      			-->
								<td id="modifyProductlinelbl"> Product Line </td>
								<td id="modifyMaterialLbl"> Material </td>
								<td id="nonMaterialClient">
									<select class="comboClass" id="modifyProductLineComboId"  onchange="checkProductModify()" data-live-search="true"> 	</select>
								</td>
								<td id="materialClient"> <input type="text" class="form-control comboClass"   id="modifyMaterialValueId" readonly> 	</td>
							</tr>
							<tr>
								<td> 	Vehicle Number </td>
								<td> <select class="comboClass" id="modifyvehicleDropDownID" 	data-live-search="true"> </select> 	</td>

								<!--<td><input type="text" class="form-control comboClass" id="modifyvehicleDropDownID" ></td>  	
									      			
				      			-->
								<td> Customer Ref. ID </td>
								<td> 	<input type="text" class="form-control comboClass" 	id="modifycustrefID" required>  	</td>
								<td> 	Trip No  </td>
								<td> 	<input type="text" class="form-control comboClass" id="modifyorderId"  readonly>  </td>
							</tr>

							<tr>
								<td> Trip Date/Time 	</td>
								<td> 	<input type="text" id="dateTimeInput" class='form-control'> </td>

								<td> Average Speed (kms/hr) </td>
								<td>
									<input type="text" id="avgSpeedModifyId"
										class="form-control comboClass" min="1" maxLength="4"
										step="any" onkeypress="return checkSpeed(event)"
										onchange="checkTemperature1(this.id,this.value)">
								</td>

								<td id="pleLoadTempLblId">
									Pre-Loading Temperature (°C)
								</td>
								<td>
									<input type="text" id="preloadTempModifyId"
										class="form-control comboClass"
										onchange="checkTemperature1(this.id,this.value)">
								</td>
							</tr>
							<tr id="totalTATDetailsMod">
								<td>
									Total TAT
								</td>
								<td>
									<input type="text" id="totalTATMod" class='form-control'
										disabled>
								</td>

								<td>
									Total RunTime
								</td>
								<td>
									<input type="text" id="totalRunTimeMod" class='form-control'
										disabled>
								</td>
								</td>
							</tr>
							<tr>
								<td id="modifycategorylbl">
									Category
								</td>
								<td id="modifycategory">
									<select class="comboClass" id="modifycategoryComboId"
										data-live-search="true">
									</select>
								</td>
								<!--<td id="modifycategory"><input type="text" class="form-control comboClass" id="modifycategoryComboId" readonly></td>  				      		-->
							</tr>
							<!--				      		<tr id="modifyExtraFields">				      							      			      			-->
							<!--				      			<td>Seal Number</td>-->
							<!--				      			<td><input type="text" class="form-control comboClass" maxLength="10" id="modifySealNoId" onkeypress="return checkSpcialChar(event)"></td>-->
							<!--				      			-->
							<!--				      			<td>Number of Bags</td>-->
							<!--				      			<td><input type="text" class="form-control comboClass" id="modifyNoOfBagsId" min="0" maxLength="4" step="any" class='comboClass' onkeypress="return checkSpeed(event)"></td>	-->
							<!--				      			-->
							<!--				      			<td>Trip Type</td>-->
							<!--				      			<td><input type="text" class="form-control comboClass" maxLength="15" id="modifyTripTypeId" onkeypress="return checkSpcialChar(event)"></td>-->
							<!--				      		</tr>-->
							<!--				      		<tr id="modifyExtraFields2">				      							      			      			-->
							<!--				      			<td>Number of Fluid Bags</td>-->
							<!--				      			<td><input type="text" class="form-control comboClass" min="0" maxLength="10" id="modifyFluidBagsId" onkeypress="return checkSpeed(event)"></td>-->
							<!--				      			-->
							<!--				      			<td>Opening Kms</td>-->
							<!--				      			<td><input type="text" class="form-control comboClass" id="modifyOpeningKmsId" min="0" maxLength="4" step="any" class='comboClass' onkeypress="return checkSpeed(event)"></td>	-->
							<!--				      			-->
							<!--				      			<td>Remarks</td>-->
							<!--				      			<td><input type="text" class="form-control comboClass" maxLength="50" id="modifyTripRemarksId" onkeypress="return checkSpcialChar(event)"></td>-->
							<!--				      		</tr>-->
							<tr>
								<table class="table table-sm table-bordered table-striped"
									id="modifyTabelId"
									style="display: none; max-height: 150px; overflow-y: auto !important">
									<tr>
										<th style="width: 20px;"></th>
										<th style="width: 20px; display: none;"></th>
										<th style="width: 150px;">
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
										<th style="width: 200px"></th>
									</tr>
									<tbody id="modifyLegTableId">
									</tbody>
								</table>
							</tr>
							<tr>
								<table id="modTempConfigTableId" style="display: none;">
									<tbody id="modTemperatureTableId"
										style="max-height: 100px; overflow-y: auto !important"></tbody>
								</table>
							</tr>
						</tbody>
					</table>
				</div>
				<div id="modTemperatureEvents" style="margin-left:14px">
				</div>
			</div>
			<div class="modal-footer" style="text-align: center;">
				<input onclick="modifyData()" type="button" class="btn btn-primary"
					id="updateButtionId"
					style="background-color: #158e1a; border-color: #158e1a; "
					value="Update" />
				<button type="reset" onclick="cancel()" class="btn btn-warning"
					style="background-color: #da2618 !important; border-color: #da2618 !important;"
					data-dismiss="modal">
					Close
				</button>

			</div>
		</div>
	</div>
</div>

<div id="overrideActuals" class="modal fade" data-backdrop="static"
	data-keyboard="false">
	<div class="modal-dialog"
		style="position: absolute; left: 20%; top: 52%; margin-top: -250px; width: 60% !important; max-width: 100% !important;">
		<div class="modal-content">
			<div class="modal-header" style="padding: 1px;">
				<h4 id="nome" class="modal-title">
					Override Actuals
				</h4>
				<button type="button" onclick="cancel()" class="close"
					data-dismiss="modal">
					&times;
				</button>
			</div>
			<div class="modal-body" style="max-height: 50%; margin-bottom: 0px;">
				<div class="col-md-12">
					<table class="table table-sm table-bordered table-striped">
						<tbody>
							<tr>
								<td>Trip No <sup><font color="red">&nbsp;*</font></sup></td>
								<td><select style="width: 250px : height : 25px" id="tripNameCombo" onchange="loadScheduleAndActualTime()"></select></td>
							</tr>
						</tbody>	
					</table>
					<table class="table table-sm table-bordered table-striped">
						<tbody>		
							<tr>
								<td>STP</td>
								<td><input type="text" id="stpDateTime" class="form-control comboClass" readonly></td>
								<td>ATP</td>
								<td><input type="text" id="atpDateTimeInput" class='form-control'></td>
							</tr>
							<tr>
								<td>STD</td>
								<td><input type="text" id="stdDateTime" class="form-control comboClass" readonly></td>
								<td>ATD</td>
								<td><input type="text" id="atdDateTimeInput" class='form-control'></td>
							</tr>
							<tr>
								<td>STA</td>
								<td><input type="text" id="staDateTimeOverride" class="form-control comboClass" readonly></td>
								<td>ATA</td>
								<td><input type="text" id="ataDateTimeInputOverride" class='form-control'></td>
							</tr>
						</tbody>
					</table>
					<table class="table table-sm table-bordered table-striped">
						<tbody>
							<tr>
								<td style="width: 25%;"><label for="remarks" style="text-align: center;">Remarks</label></td>
								<td><textarea class="form-control rounded-0" id="overrideRemarksId"rows="3"></textarea><br /></td>
							</tr>
						</tbody>
					</table>
				</div>
			</div>
			<div class="modal-footer" style="text-align: center;">
				<input onclick="overrideActualTime()" type="button"
					class="btn btn-primary"
					style="background-color: #158e1a; border-color: #158e1a;"
					value="Update" />
				<button type="reset" onclick="cancel()" class="btn btn-warning"
					style="background-color: #da2618 !important; border-color: #da2618 !important;"
					data-dismiss="modal">
					Cancel
				</button>
			</div>
		</div>
	</div>
</div>

<div id="chengeRoute" class="modal fade" data-backdrop="static"
	data-keyboard="false">
	<div class="modal-dialog"
		style="position: absolute; left: 2%; top: 52%; margin-top: -250px; width: 95% !important; max-width: 100% !important;">
		<div class="modal-content">
			<div class="modal-header" style="padding: 1px;">
				<h4 id="routeChangeTitleId" class="modal-title">
					Route Change-Over
				</h4>
				<button type="button" class="close" onclick="" data-dismiss="modal">
					&times;
				</button>
			</div>
			<div class="modal-body" style="max-height: 50%; margin-bottom: 0px;">
				<div class="col-md-12">
					<table class="table table-sm table-bordered table-striped"
						style="margin-bottom: 0px;">
						<tbody>
							<tr>
								<td>
									Customer Name
								</td>
								<td>
									<input type="text" class="form-control comboClass"
										id="routeChangeCustId" readonly>
								</td>

								<td>
									Current Name
								</td>
								<td>
									<input type="text" class="form-control comboClass"
										id="oldRouteDropDownID" readonly>
								</td>

								<td>
									Modifying Route
								</td>
								<td>
									<select class="comboClass" id="changeRouteId"
										data-live-search="true" required="required" onchange=""></select>
									<input onclick="createRoute()" id="changeCreateRouteId"
										type="button" class="btn btn-primary" data-dismiss="modal"
										style="height: 28px; display: none" value="Create" />
									<input onclick="viewRoute('change')" id="changeViewRouteBtnId"
										type="button" class="btn btn-primary"
										style="height: 28px; display: none" value="View" />
								</td>
							</tr>
						</tbody>
					</table>
				</div>
			</div>
			<div class="modal-footer" style="text-align: center; padding: 8px;">
				<input id="save2" onclick="saveRouteChange()" type="button"
					style="background-color: #158e1a !important; border-color: #158e1a !important;"
					class="btn btn-primary" value="Save" />
				<button type="reset" class="btn btn-warning"
					style="background-color: #da2618 !important; border-color: #da2618 !important;"
					data-dismiss="modal">
					Close
				</button>

			</div>
		</div>
	</div>
</div>

<div id="swapVehicleModal" class="modal fade" data-backdrop="static"
	data-keyboard="false">
	<div class="modal-dialog"
		style="position: absolute; left: 2%; top: 52%; margin-top: -250px; width: 95% !important; max-width: 100% !important;">
		<div class="modal-content">
			<div class="modal-header" style="padding: 1px;">
				<h4 id="swapVehicleTitleId" class="modal-title">
					Swap Vehicle
				</h4>
				<button type="button" class="close" onclick="" data-dismiss="modal">
					&times;
				</button>
			</div>
			<div class="modal-body" style="max-height: 50%; margin-bottom: 0px;">
				<div class="col-md-12">
					<table class="table table-sm table-bordered table-striped"
						style="margin-bottom: 0px;">
						<tbody>
							<tr>
								<td>
									Customer Name
								</td>
								<td>
									<input type="text" class="form-control comboClass"
										id="swapVehicleCustId" readonly>
								</td>

								<td>
									Route Name
								</td>
								<td>
									<input type="text" class="form-control comboClass"
										id="swapVehiclerouteDropDownID" readonly>
								</td>

								<td>
									Product Line
								</td>
								<td>
									<input type="text" class="form-control comboClass"
										id="swapVehicleProductLineComboId" readonly>
								</td>
							</tr>
							<tr>
								<td>
									Customer Ref. ID
								</td>
								<td>
									<input type="text" class="form-control comboClass"
										id="swapVehiclecustrefID" readonly>
								</td>

								<td>
									Trip No
								</td>
								<td>
									<input type="text" class="form-control comboClass"
										id="swapVehicleorderId" readonly>
								</td>

								<td>
									Trip Date/Time
								</td>
								<td>
									<input type="text" id="swapVehicledateTimeInput"
										class='form-control' readonly>
								</td>
							</tr>
							<tr>
								<td>
									Current Vehicle
								</td>
								<td>
									<input type="text" class="form-control comboClass"
										id="oldSwappedVehicleId" readonly>
								</td>

								<td>
									New Vehicle
								</td>
								<td>
									<select class="comboClass" id="newSwappedVehicleId"
										data-live-search="true" required="required" onchange=""></select>
								</td>
								<td>
									Remarks
								</td>
								<td>
									<input type="text" class="form-control comboClass"
										id="vehicleSwapRemarks">
								</td>
							</tr>
						</tbody>
					</table>
				</div>
			</div>
			<div class="modal-footer" style="text-align: center; padding: 8px;">
				<input id="saveVehicleSwap" onclick="saveVehicleSwap()"
					type="button"
					style="background-color: #158e1a !important; border-color: #158e1a !important;"
					class="btn btn-primary" value="Swap" />
				<button type="reset" class="btn btn-warning"
					style="background-color: #da2618 !important; border-color: #da2618 !important;"
					data-dismiss="modal">
					Close
				</button>

			</div>
		</div>
	</div>
</div>


	<div id="reopenTrip" class="modal fade" data-backdrop="static" data-keyboard="false">
		<div class="modal-dialog" style="position: absolute; left: 20%; top: 52%; margin-top: -250px; width: 60% !important; max-width: 100% !important;">
			<div class="modal-content">
				<div class="modal-header" style="padding: 1px;">
					<h4 id="nome" class="modal-title"> 	Re-open closed trips </h4> 
						<button type="button" onclick="cancelReopenModal()" class="close" 	data-dismiss="modal"> 	&times; </button>
				</div>
				<div class="col-lg-12 col-md-12 col-sm-12 col-xs-12 text-center">
					<div id="page-loader1" style="margin-top: 10px; display: none;">
						<img src="../../Main/images/loading.gif" alt="loader" />
					</div>
				</div>
				<div class="modal-body" style="max-height: 50%; margin-bottom: 0px;">
					<div class="col-md-12">
						<table class="table table-sm table-bordered table-striped">
							<tbody>
								
								<tr>
									<td>ATA</td>
									<td><input type="text" id="closedTripATA" class='form-control comboClass' disabled ></td>
								</tr>
								
								<tr>
									<td><label for="remarks1111" style="text-align: center;">Reason</label></td>
									<td><textarea class="form-control rounded-0" id="reopenReasonId"	rows="3"></textarea><br /></td>
								</tr>
							</tbody>
						</table>
					</div>
				</div>
				<div class="modal-footer" style="text-align: center;">
					<input onclick="reopenClosedTrip()" type="button" class="btn btn-primary" style="background-color: #158e1a; border-color: #158e1a;" value="Reopen"	 />
					<button type="reset" onclick="cancelReopenModal()" class="btn btn-warning" style="background-color: #da2618 !important; border-color: #da2618 !important;"  data-dismiss="modal"> 	Close </button>
				</div>
			</div>
		</div>
	</div>
	
	<div id="updateActualsModal" class="modal-content modal fade updateActual" >
	                    <div class="modal-header">
	                        <div class="secondLine" style="display:flex; justify-content:space-between; align-items:baseline;">
	                            <h4 id="updateATAforClosedTripHeading" class="modal-title" style="text-align:left; margin-left:10px;">Update Trip Actuals</h4>
	                        </div>
	                    </div>
	                    <div class="modal-body" style="">
	                        <div class="row">
	                            <div class="col-lg-12">
	                                <div class="col-lg-12" style="border: solid  1px lightgray;">
	                                    <table id="actualUpdateTable" class="table table-striped table-bordered" cellspacing="0" style="width:-1px;">
	                                        <thead>
	                                            <tr>
	                                                <th>S No</th>
													<th style="display:none;">tripId</th>
	                                                <th>Trip No</th>
	                                                <th>Vehicle Number</th>
	                                                <th>ATP</th>
	                                                <th>ATD</th>
	                                                <th>ATA</th>
	                                                <th>Trip End Time</th>
													<th>Update Actuals</th>
	                                            </tr>
	                                        </thead>
	                                    </table>
	                                </div>
	                            </div>
	                        </div>
	                    </div>
	                    <div class="modal-footer" style="text-align: right; height:52px;">
	                        <button type="reset" class="btn btn-danger" data-dismiss="modal" onclick="loadAjaxForEnvelop()">Close</button>
	                    </div>
                    </div>
		   
		   <div id="updateActualsFieldsModal"  class="modal-content modal fade" style="display: none;position: absolute;top: 75px;height: 56vh;width:60%;margin-left:20%" data-backdrop="static" data-keyboard="false">
			<div class="modal-content">
				<div class="modal-header" style="padding: 1px;">
					<h4 id="updateATAModalName" class="modal-title">Update ATA</h4> 
						<button type="button"  class="close" 	data-dismiss="modal"> 	&times; </button>
				</div>
				<div class="col-lg-12 col-md-12 col-sm-12 col-xs-12 text-center">
					<div id="page-loader1" style="margin-top: 10px; display: none;">
						<img src="../../Main/images/loading.gif" alt="loader" />
					</div>
				</div>
				<div class="modal-body" style="max-height: 50%; margin-bottom: 0px;">
					<div class="col-md-12">
						<table class="table table-sm table-bordered table-striped">
							<tbody>
								<tr style="display : none;">
									<td>TRIP Id</td>
									<td><input type="text" id="tripIdActualUpdate"  disabled ></td>
								</tr>
								<tr style="display : none;">
									<td>vehicle No</td>
									<td><input type="text" id="vehicelNoActualUpdate"  disabled ></td>
								</tr>
								<tr style="display : none;">
									<td>Shipment Id</td>
									<td><input type="text" id="shipmentActualUpdate"  disabled ></td>
								</tr>
								<tr style="display : none;">
									<td>Order Id</td>
									<td><input type="text" id="orderIdActualUpdate"  disabled ></td>
								</tr>
								<tr>
									<td>ATP</td>
									<td><input type="text" id="atpActualUpdateId" class='form-control comboClass'></td>
								</tr>
								<tr>
									<td>ATD</td>
									<td><input type="text" id="atdActualUpdateId"  class='form-control comboClass'></td>
								</tr>
								<tr>
									<td>ATA</td>
									<td><input type="text" id="ataActualUpdteId" class='form-control comboClass'></td>
								</tr>
								<tr>
									<td>Trip End Time (Should not be before ATA)</td>
									<td><input type="text" id="tripEndTimeActualUpdateId" class='form-control comboClass'></td>
								</tr> 
							</tbody>
						</table>
					</div>
				</div>
				<div class="modal-footer" style="text-align: center;">
					<input onclick="updateATA()" type="button" class="btn btn-primary" style="background-color: #158e1a; border-color: #158e1a;" value="Update"	 />
					<button type="reset"  class="btn btn-warning" style="background-color: #da2618 !important; border-color: #da2618 !important;"  data-dismiss="modal"> Cancel </button>
				</div>
			</div>
		 
	</div>

<script async>
	
	 window.onload = function () { 
		getCustomer();
		
		//loadAjaxForEnvelop();
	}
	
	
	let t4uspringappURL = "<%=t4uspringappURL%>";
	let systemId = <%=systemId%>;
	let customerId = <%=customerId%>;
    var table;
    var customerDetails;
    var addcustomerDetails;
    var status;
    var routeList;
    var routeListarray = [];
    var uniqueId;
    var currentDate = new Date();
    var restrictDate = new Date(currentDate).getDate()-7;
    var restrictMonth = new Date(currentDate).getMonth();
    var restrictYear =new Date(currentDate).getFullYear();
	currentDate.setHours(23);
	currentDate.setMinutes(59);
	currentDate.setSeconds(59);
	var viewFlag="<%=viewFlag%>";
	var startDate="<%=startDate%>";
	var endDate="<%=endDate%>";
	var fromTripImageUpload="<%=fromTripImageUpload%>";
	var unsuccessfulImageUpload="<%=unsuccessfulImageUpload%>";
	var tripId =0;
	var imgModal = document.getElementById('viewImageModal');
	var span = document.getElementById("imgCloseId");
	var filePath="<%=FilePath%>";
	var sliderMin;
	var sliderMax;
	var associatedTemp;
	var vehicleAssoList;
	var checkBoxVal = '<%=allEvents%>';
	var avgSpeedVal = '<%=averageSpeed%>';
	var newFields = '<%=extraFields%>';
	var hubAssociatedRoutes = '<%=hubAssociatedRoutes%>';
	var vehicleReporting = '<%=vehicleReporting%>';
	var materialClient = '<%=materialClient%>';
	var category = '<%=category%>';
	var humidity = '<%=humidity%>';
	var temp = '<%=temperature%>';
	var events = '<%=events%>';
    var vehicleArray = []; 
    var recordsCount = 0;
    var globalRouteId = "";
    var modiFyCount = 0;
    var pageFlag = '<%=pageFlagGlobal%>'
    var globalVehicleSelected;
    var vehicleRepDate = '<%=vehicleRepDate%>';
    var globalTripCustId;
    var swapVehicleColumn = '<%=swapVehicleColumn%>';
    var canOverrideActuals ='<%=canOverrideActuals%>';
    var isCanOverrideActualTimeUsers ='<%=isCanOverrideActualTimeUsers%>';
    var destinationArrived = false;
    var minPositiveTemp = 0;
    var minNegativeTemp = 0;
    var maxPositiveTemp = 0;
    var maxNegativeTemp = 0;
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
    
    var now = new Date ();
	var n = new Date( now.getTime() + (now.getTimezoneOffset() * 60000));
    d2 = new Date ( n );
	d2.setMinutes ( n.getMinutes() + <%=offset%> );
	console.log ( d2 );
    var arrOfRole = [];
	let roles = [];
	
	var hasEditPermissionForEndTime =false;
	var isValid =false;
   $(document).ready(function () {
	   $('#addId').hide();
	   $.ajax({
		  type: 'GET',
		  url: t4uspringappURL + 'tripsolutionauth?systemId='+systemId+'&customerId=' + customerId,
		  datatype: 'json',
		  contentType: "application/json",
		  success: function(response) {
			  
			  roles = response.responseBody;
			  
			  roles.forEach(function(item){
				  arrOfRole.push(item.roleName);
				  if(item.roleName === "<%=userAuthority%>" && item.editPermissionToEndTime === 'Y')
				  {
					  hasEditPermissionForEndTime = true;
					 
				  }
				  if("<%=userAuthority%>" == item.roleName)
				  {
				    isValid = true;
					//break;
				  }
			  })			  
		
		 
			  
			   
   //if('<%=userAuthority%>' != 'ProdOwn' && '<%=userAuthority%>' != 'T4u Users'){
		if(isValid){
			loadAjaxForEnvelop();
		   }
		   
		   $("#adddateTimeInput").jqxDateTimeInput({ theme: "arctic", formatString: "dd/MM/yyyy HH:mm", showTimeButton: true, width: '200px', height: '25px'});
		   $('#adddateTimeInput ').jqxDateTimeInput('setDate', new Date());
		   $('#adddateTimeInput ').jqxDateTimeInput({min: new Date(restrictYear, restrictMonth, restrictDate)});
		   $("#dateTimeInput").jqxDateTimeInput({ theme: "arctic", formatString: "dd/MM/yyyy HH:mm",  showTimeButton: true, width: '200px', height: '25px' });
		   $('#dateTimeInput ').jqxDateTimeInput('setDate', new Date()); 
		   //$('#dateTimeInput ').jqxDateTimeInput({min: new Date(restrictYear, restrictMonth, restrictDate)});

		   $("#atpDateTimeInput").jqxDateTimeInput({ theme: "arctic", formatString: "dd/MM/yyyy HH:mm",  showTimeButton: true, width: '200px', height: '25px' });
		   $('#atpDateTimeInput').jqxDateTimeInput('setDate', '');
		   $('#atpDateTimeInput').jqxDateTimeInput('setMaxDate', new Date());
		   
		   $("#ataDateTimeInput").jqxDateTimeInput({ theme: "arctic", formatString: "dd/MM/yyyy HH:mm",  showTimeButton: true, width: '200px', height: '25px' });
		   $('#ataDateTimeInput').jqxDateTimeInput('setDate', '');
		   $('#ataDateTimeInput').jqxDateTimeInput('setMaxDate', new Date());
		   
		   $("#atdDateTimeInput").jqxDateTimeInput({ theme: "arctic", formatString: "dd/MM/yyyy HH:mm",  showTimeButton: true, width: '200px', height: '25px' });
		   $('#atdDateTimeInput').jqxDateTimeInput('setDate', '');
		   $('#atdDateTimeInput').jqxDateTimeInput('setMaxDate', new Date());
		   
		   $("#dateInput1").jqxDateTimeInput({ theme: "arctic", formatString: "dd/MM/yyyy", showTimeButton: false, width: '197px', height: '25px'});
		   $('#dateInput1 ').jqxDateTimeInput('setDate', new Date());
		   $("#dateInput2").jqxDateTimeInput({ theme: "arctic", formatString: "dd/MM/yyyy", showTimeButton: false, width: '197px', height: '25px'});
		   $('#dateInput2 ').jqxDateTimeInput('setDate', currentDate);
		   
		   $("#atpDateTimeClsoure").jqxDateTimeInput({ theme: "arctic", formatString: "dd/MM/yyyy HH:mm",  showTimeButton: true, width: '200px', height: '25px'});
		   $('#atpDateTimeClsoure').jqxDateTimeInput('setDate', '');
		   $('#atpDateTimeClsoure').jqxDateTimeInput('setMaxDate', new Date());
		   
		   $("#atdDateTimeClsoure").jqxDateTimeInput({ theme: "arctic", formatString: "dd/MM/yyyy HH:mm",  showTimeButton: true, width: '200px', height: '25px' });
		   $('#atdDateTimeClsoure').jqxDateTimeInput('setDate', '');
		   $('#atdDateTimeClsoure').jqxDateTimeInput('setMaxDate', new Date());
		   
		   $("#tripEndDateTimeInput").jqxDateTimeInput({ theme: "arctic", formatString: "dd/MM/yyyy HH:mm",  showTimeButton: true, width: '200px', height: '25px' });
		   $('#tripEndDateTimeInput').jqxDateTimeInput('setDate', new Date());
		   $('#tripEndDateTimeInput').jqxDateTimeInput('setMaxDate', new Date());

			$("#atpActualUpdateId").jqxDateTimeInput({ theme: "arctic", formatString: "dd/MM/yyyy HH:mm",  showTimeButton: true, width: '200px', height: '25px'});
		   $('#atpActualUpdateId').jqxDateTimeInput('setDate', '');
		   $('#atpActualUpdateId').jqxDateTimeInput('setMaxDate', new Date());
		   
		   $("#atdActualUpdateId").jqxDateTimeInput({ theme: "arctic", formatString: "dd/MM/yyyy HH:mm",  showTimeButton: true, width: '200px', height: '25px' });
		   $('#atdActualUpdateId').jqxDateTimeInput('setDate', '');
		   $('#atdActualUpdateId').jqxDateTimeInput('setMaxDate', new Date());
		   
		   $("#ataActualUpdteId").jqxDateTimeInput({ theme: "arctic", formatString: "dd/MM/yyyy HH:mm",  showTimeButton: true, width: '200px', height: '25px' });
		   $('#ataActualUpdteId').jqxDateTimeInput('setDate', new Date());
		   $('#ataActualUpdteId').jqxDateTimeInput('setMaxDate', new Date());

			$("#tripEndTimeActualUpdateId").jqxDateTimeInput({ theme: "arctic", formatString: "dd/MM/yyyy HH:mm",  showTimeButton: true, width: '200px', height: '25px' });
			$('#tripEndTimeActualUpdateId').jqxDateTimeInput('setDate', new Date());
			$('#tripEndTimeActualUpdateId').jqxDateTimeInput('setMaxDate', new Date());

			$("#ataDateTimeInputOverride").jqxDateTimeInput({ theme: "arctic", formatString: "dd/MM/yyyy HH:mm",  showTimeButton: true, width: '200px', height: '25px' });
			$('#ataDateTimeInputOverride').jqxDateTimeInput('setDate', '');
			$('#ataDateTimeInputOverride').jqxDateTimeInput('setMaxDate', new Date());
		   if(category == 'N'){
			   document.getElementById("categoryLblId").style.display = 'none';
			   document.getElementById("categoryId").style.display = 'none';
			   document.getElementById("modifycategorylbl").style.display = 'none';
			   document.getElementById("modifycategory").style.display = 'none';
		   }
		   
		   if('<%=pageId%>' == 'vehicleReport'){
				getCustomer();
				$('#adddateTimeInput ').jqxDateTimeInput('setDate', new Date(vehicleRepDate));
				$("#addrouteDropDownID").empty().select2();
				$("#addProductLineComboId").empty().select2();
				$("#categoryComboId").empty().select2();
				$('#add').modal('show');
				hideFieldsBasedOnMaterialClient();
				$('#vehicleReportBtnId').show();
				loadCustomerAndVehicle();
				setTimeout( function(){
					loadData();
					document.getElementById("avgSpeedId").value = avgSpeedVal;
					$('#addvehicleDropDownID').val('<%=vehicleNoNew%>').trigger('change');
					if(checkBoxVal=='Y'){
						document.getElementById("checkboxAll").checked = true;
						//document.getElementById("checkbox1").checked = true;
						document.getElementById("checkbox2").checked = true;
						document.getElementById("checkbox3").checked = true;
						document.getElementById("checkbox4").checked = true;
						document.getElementById("checkbox5").checked = true;
						document.getElementById("checkbox6").checked = true;
						document.getElementById("checkbox7").checked = true;
						document.getElementById("checkbox8").checked = true;
						document.getElementById("checkbox9").checked = true;
						document.getElementById("checkbox10").checked = true;
						document.getElementById("checkbox11").checked = true;
						document.getElementById("checkbox12").checked = true;
						//document.getElementById("checkbox13").checked = true;
						document.getElementById("checkbox14").checked = true;
						document.getElementById("checkbox15").checked = true;
						document.getElementById("checkbox16").checked = true;
					}
				},1000);
				
			}else if('<%=pageId%>' == 'route'){
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
					//loadData();
					
					document.getElementById("avgSpeedId").value = avgSpeedVal;
					$('#addrouteDropDownID').val(localStorage.getItem("routeId")).trigger('change');
					$('#addcustNameDownID').val(localStorage.getItem("tripCustId")).trigger('change');
					$('#avgSpeedId').val(localStorage.getItem("avgSpeed")).trigger('change');
					checkBoxVal = localStorage.getItem("checkValue");
					$('#addvehicleDropDownID').val('<%=vehicleNoNew%>').trigger('change');
					if(checkBoxVal=='Y'){
						document.getElementById("checkboxAll").checked = true;
						//document.getElementById("checkbox1").checked = true;
						document.getElementById("checkbox2").checked = true;
						document.getElementById("checkbox3").checked = true;
						document.getElementById("checkbox4").checked = true;
						document.getElementById("checkbox5").checked = true;
						document.getElementById("checkbox6").checked = true;
						document.getElementById("checkbox7").checked = true;
						document.getElementById("checkbox8").checked = true;
						document.getElementById("checkbox9").checked = true;
						document.getElementById("checkbox10").checked = true;
						document.getElementById("checkbox11").checked = true;
						document.getElementById("checkbox12").checked = true;
						//document.getElementById("checkbox13").checked = true;
						document.getElementById("checkbox14").checked = true;
						document.getElementById("checkbox15").checked = true;
						document.getElementById("checkbox16").checked = true;
					}
				},1000);
			}else{
				$('#vehicleReportBtnId').hide();
			}
		   //$("#ex12c").slider({ id: "slider12c", min: 0, max: 10, range: true, value: [3, 7] });
		//	sliderMin = new Slider("#exMin", { id: "slider12min", min: -70, max: 70, range: true, value: [minNegativeTemp, maxNegativeTemp] });
		//	sliderMin.on("slide", function(slideEvt) {
			 //console.log(sliderMin.getValue());
		  //    });
			
		 //   sliderMax = new Slider("#exMax", { id: "slider12max", min: -70, max: 70, range: true, value: [minPositiveTemp, maxPositiveTemp] });
		//	sliderMax.on("slide", function(slideEvt) {
			 //console.log(sliderMax.getValue());
		 //     });
				   
			$("#adddateTimeInput").change(function() {
				
				if(vehicleReporting == 'Y'){
					loadCustomerAndVehicle();
				}
				else{
					setSTAandSTD();
				}
			})
			$("#dateTimeInput").change(function() {
				setSTAandSTDonModify();
			})
			$("#addcustNameDownID").change(function() {
				loadData();
				if(materialClient == 'Y'){
					loadRouteTemplates();
				}
				$("#temperatureTableId").empty();
				$("#temperatureEvents").empty();
				allTemperaturesArray = [];
				temperatureCounter = 0;
			})
			}
	  }); //Success Close
	  
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
			 

});

 

function loadRouteTemplates(){
		$("#routeTemplateDropDownID").empty().select2();
		$.ajax({
	        url: '<%=request.getContextPath()%>/LegCreationAction.do?param=getAllRouteTemplates',
	        data: {
	        	tripCustId : $('#addcustNameDownID option:selected').attr("value")
	  
	        },
	        success: function(result) {
	            routeList = JSON.parse(result);
	            $('#routeTemplateDropDownID').append($("<option></option>").attr("value", 0).text("--Select Route Template--"));
	            for (var i = 0; i < routeList["routeTemplateRoot"].length; i++) {
                    $('#routeTemplateDropDownID').append($("<option></option>").attr("value", routeList["routeTemplateRoot"][i].ID).attr("routeId", routeList["routeTemplateRoot"][i].routeId).text(routeList["routeTemplateRoot"][i].templateName));
	            }
	            $('#routeTemplateDropDownID').select2();
	        }    
				
	  });
}

function loadMaterials(){
	$("#addMaterialComboId").empty().select2();
	document.getElementById("totalTAT").value= '';	
	document.getElementById("totalRunTime").value= '';
		$.ajax({
	        url: '<%=request.getContextPath()%>/LegCreationAction.do?param=getAllMaterialsByTemplateId',
	        data: {
	        	id : $('#routeTemplateDropDownID option:selected').attr("value"),
			tripCustId : $('#addcustNameDownID option:selected').attr("value")
	  		
	        },
	        success: function(result) {
	            routeList = JSON.parse(result);
		     $('#addMaterialComboId').append($("<option></option>").attr("value", 0).text("--Select Material--"));
	            for (var i = 0; i < routeList["templateDetails"].length; i++) {
                    $('#addMaterialComboId').append($("<option></option>").attr("value", routeList["templateDetails"][i].materialId).attr('totalTAT',routeList["templateDetails"][i].totalTAT).attr('totalRunTime',routeList["templateDetails"][i].totalRunTime).text(routeList["templateDetails"][i].materialName));
	            }
	            $('#addMaterialComboId').select2();
	        }    
				
	  });
	  plotLegDetails();
}

	function loadRouteLegTATDetails(){
		document.getElementById("totalTAT").value= $('#addMaterialComboId option:selected').attr("totalTAT");	
		document.getElementById("totalRunTime").value= $('#addMaterialComboId option:selected').attr("totalRunTime");	
	}
	var globalATPOverride;
	var globalATDOverride;
	var globalATAOverride;
	var globalATPDisabled = false;
	var globalATDdisabled = false;
	function loadScheduleAndActualTime(){
		$('#stpDateTime').val($('#tripNameCombo option:selected').attr("STP"));
	 	$('#atpDateTimeInput').jqxDateTimeInput('setDate', $('#tripNameCombo option:selected').attr("ATP"));
	 	
	 	$('#atdDateTimeInput').jqxDateTimeInput('setDate', $('#tripNameCombo option:selected').attr("ATD"));
	  	$('#stdDateTime').val($('#tripNameCombo option:selected').attr("STD"));
	  	
	  	$('#ataDateTimeInputOverride').jqxDateTimeInput('setDate', $('#tripNameCombo option:selected').attr("ATA"));
	  	$('#staDateTimeOverride').val($('#tripNameCombo option:selected').attr("STA"));
	  	
	 	$('#overrideRemarksId').val($('#tripNameCombo option:selected').attr("remarks"));
	 	
	 	//if('<%=userAuthority%>' != 'ProdOwn' && '<%=userAuthority%>' != 'T4u Users'){
if(!isValid){
		 	if(document.getElementById("atpDateTimeInput").value.trim().length == 0){
				$("#atpDateTimeInput").jqxDateTimeInput({ disabled: false });
				globalATPDisabled = false;
			}else{
			 	$("#atpDateTimeInput").jqxDateTimeInput({ disabled: true });
			 	globalATPDisabled = true;
			}
			if(document.getElementById("atdDateTimeInput").value.trim().length == 0){
				$("#atdDateTimeInput").jqxDateTimeInput({ disabled: false });
				globalATDdisabled = false;
			}else{
			 	$("#atdDateTimeInput").jqxDateTimeInput({ disabled: true });
			 	globalATDdisabled = true;
			}
			if(document.getElementById("ataDateTimeInputOverride").value.trim().length == 0){
				$("#ataDateTimeInputOverride").jqxDateTimeInput({ disabled: false });
			}else{
			 	$("#ataDateTimeInputOverride").jqxDateTimeInput({ disabled: true });
			}
		}
		globalATPOverride = document.getElementById("atpDateTimeInput").value.trim();
		globalATDOverride = document.getElementById("atdDateTimeInput").value.trim();
		globalATAOverride = document.getElementById("ataDateTimeInputOverride").value.trim();
	}

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
			//custId = customerDetails["CustomerRoot"][i].CustId;
            //custName = customerDetails["CustomerRoot"][i].CustName;
           
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
			

			
			}//if
		}
	});
	
	if(fromTripImageUpload=="fromTripImageUpload"){
	
	if(unsuccessfulImageUpload=="unsuccessfulImageUpload"){
		sweetAlert("Image Upload Unsuccessful");
		<%session.setAttribute("unsuccessfulImageUpload", "");%>
	}
	else{
		sweetAlert("Saved Successfully");
		getData();
        document.getElementById("custReferenceId").value="";
       // document.getElementById("addorderId").value="";
	    document.getElementById("imgUploadId").value = "";
	    $('#adddateTimeInput ').jqxDateTimeInput('setDate', new Date());
	    $('input:checkbox').removeAttr('checked');
	    document.getElementById("avgSpeedId").value = "";
		$('#add').modal('hide');
		<%session.setAttribute("startDate","");%>
		<%session.setAttribute("endDate","");%>
		<%session.setAttribute("viewFlag","");%>
		<%session.setAttribute("fromTripImageUpload","");%>
		document.getElementById("dateInput1").value=startDate;
		document.getElementById("dateInput2").value=endDate;
		if(viewFlag=="viewFlag"){
			getData();
		}
	}
	}
 }
    
  //############function cancle##########
	function cancel(){
	  	document.getElementById("addcustNameDownID").value="";
	  	document.getElementById("custReferenceId").value="";
	  	//document.getElementById("addorderId").value="";
	    document.getElementById("addvehicleDropDownID").value="";
	    document.getElementById("addrouteDropDownID").value = "";
	   // $('#adddateTimeInput ').jqxDateTimeInput('setDate', new Date());
	    $('input:checkbox').removeAttr('checked');
	    document.getElementById("modifycustNameDownID").value="";
	    document.getElementById("modifycustrefID").value="";
		document.getElementById("modifyorderId").value="";
		document.getElementById("modifyrouteDropDownID").value="";
		document.getElementById("modifyvehicleDropDownID").value="";
		$("#addrouteDropDownID").empty().select2();
        $("#addvehicleDropDownID").empty().select2();
<!--		$("#legTableId").empty();-->
<!--		$('#tabelId').empty()-->
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
	var regno = $("#vehicleNo").val();
    if(startDate > endDate){
    sweetAlert("End date should be greater than Start date");
		       	    document.getElementById("dateInput2").value = currentDate;
		       	    }
    var statusType = document.getElementById("statusTypeDropDownId").value;
    if(customerName == ''){
    	sweetAlert("Please select customer");
    }
    else{
		 $.ajax({
            type: "POST",
            url: '<%=request.getContextPath()%>/TripCreatAction.do?param=getTripDetails',
            "data": {
            	 CustId: customerId,
                 startdate: startDate,
                 enddate: endDate,
                 statusType: statusType,
				 regno : regno
            },
            success: function(result) {
				document.getElementById("page-loader").style.display="none";
             result = JSON.parse(result).ticketDetailsRoot;
             if ($.fn.DataTable.isDataTable('#example')) {
                 $('#example').DataTable().clear().destroy();
             }
         	var rows = new Array();
			if(result != ""){
             $.each(result, function(i, item) {
           var row = { "0":item.slnoIndex,
                         "1" : item.uniqueIdIndex,
                         "2" : item.shipmentIdIndex,
                         "3" : item.routeNameDataIndex,
                         "4" : item.vehicleDataIndex,
                         "5" : item.insertedByDataIndex,
                         "6" : item.insertedTimeDataIndex,
                         "7" : item.plannedDateTimeIndex,
                         "8" : item.avgSpeedIndex,
                         "9" : item.customerNameIndex,
                         "10" : item.orderIdIndex,
                         "11" : item.custRefIdIndex,
                         "12" : item.statusDataIndex,
                         "13" : item.tempRangeDataIndex,
                         "14" : item.overriddenBy,
                         "15" : item.overriddenDate,
                         "16" : item.overriddenRemarks,
                         "17" : item.actionByDate,
                         "18" : item.cancelledRemarks,
                         "19" : "<button class='btn btn-info btn-md' data-toggle='tooltip' data-placement='bottom' title='View Uploaded Trip Image'>View Image</button>",
                         "20" : item.actionIndex,
                         "21" : item.modifyIndex,
                         "22" : item.changeRouteIndex,
                         "23" : item.swapVehicleIndex,
                         "24" : item.tripCustId,
                         "25" : item.routeIdIndex,
			 			 "26" : item.preLoadTempIndex,
                         "27" : item.productLineIndex,
                         "28" : item.atdIndex,
                         "29" : item.sealNoIndex,
                         "30" : item.noOfBagsIndex,
                         "31" : item.tripTypeIndex,
                         "32" : item.noOfFluidBagsIndex,
                         "33" : item.openingKmsIndex,
                         "34" : item.tripRemarksIndex,
						 "35" : item.routeTemplateName,
			 			 "36" : item.materialName,
			 			 "37" : item.totalTAT,
			 			 "38" : item.totalRunTime,
			 			 "39" : item.STA,
			 			 "40" : item.ATA,
			 			 "41" : item.category,
			 			 "42" : item.actualTripEndTime,
			 			 "43" : item.stpIndex,
			 			 "44" : item.atpIndex			 			 
               }
               rows.push(row);
             });
			}
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

		 	     table.columns( [1,22,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44] ).visible( false );
		 	   if(swapVehicleColumn == 'N'){
	    		document.getElementById("swapVehicleColumnId").style.display = "none";
	    		table.column( 23 ).visible( false );	//enabling swap vehicle column based on trip sheet setting
	   		 }	
		   		 if(isCanOverrideActualTimeUsers == 'false'){
		   			table.column(14).visible( false );
		   			table.column(15).visible( false );
		   			table.column(16).visible( false );
		   		 }
	        }
        
     	});
        jQuery('.dataTable').wrap('<div class="dataTables_scroll" />');
    }
   } 
   	var globalSTPClose;
	var globalATPClose;
	var globalATDClose;
	var globalATAClose;
	var globalTripEndTimeClose; 
	
	var globalDisableATP = false;
	var globalDisableATD = false;  
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
<!--	    var modSealNo = (data['sealNoIndex']);-->
<!--	    var modNoOfBags = (data['noOfBagsIndex']);-->
<!--	    var modTripType = (data['tripTypeIndex']);-->
<!--	    var modNoOfFluidBags = (data['noOfFluidBagsIndex']);-->
<!--	    var modOpeningKms = (data['openingKmsIndex']);-->
<!--	    var modTripRemarks = (data['tripRemarksIndex']);-->
	        globalTripCustId = (data[24]);//tripCustId
	        $('#modifycustNameDownID').val(custName);
	        $('#modifycustrefID').val(refId);
	        $('#modifyorderId').val(orderId);
	     // $('#modifyrouteDropDownID').val(globalRouteId);
	      //$('#modifyvehicleDropDownID').val(globalVehicleSelected);
	        $('#dateTimeInput').val(plannedDate);
	        $('#avgSpeedModifyId').val(avgSpeed);
	        $('#preloadTempModifyId').val(prLoadTemp);
	        $('#modifyProductLineComboId').val(productLine);
	        globalProductLineSelected = data[27];
	        globalShipmentId = data[2];
	        globalLRNo = data[10];
	        var actualTripEndTime = data[42];
	        $('#modifycategoryComboId').val(category);
<!--	    $('#modifySealNoId').val(modSealNo);-->
<!--	    $('#modifyNoOfBagsId').val(modNoOfBags);-->
<!--	    $('#modifyTripTypeId').val(modTripType);-->
<!--	    $('#modifyFluidBagsId').val(modNoOfFluidBags);-->
<!--	    $('#modifyOpeningKmsId').val(modOpeningKms);-->
<!--	    $('#modifyTripRemarksId').val(modTripRemarks);-->
<!--	    $('#modifySealNoId').prop('disabled', true);-->
<!--	    $('#modifyNoOfBagsId').prop('disabled', true);-->
<!--	    $('#modifyTripTypeId').prop('disabled', true);-->
<!--	    $('#modifyFluidBagsId').prop('disabled', true);-->
<!--	    $('#modifyOpeningKmsId').prop('disabled', true);-->
<!--	    $('#modifyTripRemarksId').prop('disabled', true);-->
	         if(columnIndex == 19){ //column index 14 is used for Image download button//
	   			//var pageName='PendingRequest';
				//document.getElementById('imgDownload').setAttribute('href', '/UploadCreateTripImage.do?tripId='+uniqueId);//+'&pageName='+pageName+'&agenceName='+agenceName+'&contactPerson='+contactPerson+'&contactNo='+contactNo+'&emailId='+emailId+'&productLine='+productLine+'&campaignBudget='+campaignBudget+'&bookingForm='+bookingForm+'&bookingTo='+bookingTo);
   				imageDownload(uniqueId);
        	}
        	var stp = (data[43]);
        	var atp = (data[44]);
	        if(columnIndex == 20){//actionIndex
	        	if(status == 'OPEN'){
	        		document.getElementById("ataTable").style.display='block';
	        	}else{
	        		document.getElementById("ataTable").style.display='none';
	        	}
        		document.getElementById("remarksCloseId").value="";
       			
       			$('#stpDateTimeClosure').val(stp);
       			$('#atpDateTimeClsoure').val(atp);
       			
       			$('#stdDateTimeClosure').val(plannedDate);
       			$('#atdDateTimeClsoure').val(atd);
       			
       			$('#staDateTime').val(sta);
       			$('#ataDateTimeInput').val(ata);
       			
       			//$('#tripEndDateTimeInput').val(actualTripEndTime);
       			
       			globalSTPClose = stp;
       			globalATPClose = atp;
       			globalATDClose = document.getElementById("atdDateTimeClsoure").value.trim();
       			globalATAClose = ata;
       			globalTripEndTimeClose = actualTripEndTime;
       			
       			if(ata != ''){ // If vehicle has already arrived at destination, then dont allow to override
       				destinationArrived = true;
       				//$("#ataDateTimeInput").jqxDateTimeInput({ disabled: false });
       			}else{
       				destinationArrived = false;
       				//$("#ataDateTimeInput").jqxDateTimeInput({ disabled: false });
       			}
     			//tripEndDateTimeInput		
	
			if(hasEditPermissionForEndTime){	
			 	$("#tripEndDateTimeInput").jqxDateTimeInput({ disabled: false });
			 }else{
			 	$("#tripEndDateTimeInput").jqxDateTimeInput({ disabled: true });
			 }
       			//if('<%=userAuthority%>' != 'ProdOwn' && '<%=userAuthority%>' != 'T4u Users'){
if(!isValid){
		       		if(document.getElementById("atpDateTimeClsoure").value.trim().length == 0){
					 	$("#atpDateTimeClsoure").jqxDateTimeInput({ disabled: false });
					 	globalDisableATP = false;
					 }else{
					 	$("#atpDateTimeClsoure").jqxDateTimeInput({ disabled: true });
					 	globalDisableATP = true;
					 }
					 
					 if(document.getElementById("atdDateTimeClsoure").value.trim().length == 0){
					 	$("#atdDateTimeClsoure").jqxDateTimeInput({ disabled: false });
					 	globalDisableATD = false;
					 }else{
					 	$("#atdDateTimeClsoure").jqxDateTimeInput({ disabled: true });
					 	globalDisableATD = true;
					 }
					 
					 if(document.getElementById("ataDateTimeInput").value.trim().length == 0){
					 	$("#ataDateTimeInput").jqxDateTimeInput({ disabled: false });
					 }else{
					 	$("#ataDateTimeInput").jqxDateTimeInput({ disabled: true });
					 }
				 }
	        }
        	if(columnIndex == 21){//modifyIndex
        		modifyModal(uniqueId,atd,status,globalRouteId,globalTripCustId,globalVehicleSelected,category,productLine,ata);
        	}
        	
        	if(columnIndex == 22){//changeRouteIndex
        		$('#routeChangeCustId').val(custName);
        		$('#oldRouteDropDownID').val(routeName);
        		var check = "N";
				$.ajax({
	        		url: '<%=request.getContextPath()%>/TripCreatAction.do?param=checkLegEnded',
	        		data:{
	        			tripId : uniqueId
	        		},	
	        		success: function(result) {
	        			if (result == "Y") {
							check = "Y";
	            		}
	        		}
				});
        		setTimeout( function(){
        			if(check == "Y"){
        				changeRouteModal(uniqueId,globalTripCustId,globalRouteId);
        			}else{
        				sweetAlert("Leg is not ended, you cannot change the route");
        			}
        		},1000);
        	}
        	if(columnIndex == 23){//swapVehicleIndex
        		$('#swapVehicleCustId').val(custName);
        		$('#oldSwappedVehicleId').val(globalVehicleSelected);
        		$('#swapVehiclecustrefID').val(refId);
		        $('#swapVehicleorderId').val(orderId);
		        $('#swapVehiclerouteDropDownID').val(routeName);
		        $('#swapVehicledateTimeInput').val(plannedDate);
		        $('#swapVehicleProductLineComboId').val(productLine);
        		swapVehicle(uniqueId);
        	}
          if(materialClient == 'Y'){
  		      document.getElementById("modifyRouteNameLbl").style.display = 'none';
  		      document.getElementById("modifyProductlinelbl").style.display = 'none';
  		      document.getElementById("nonMaterialClient").style.display = 'none';
		      $('#modifyrouteDropDownID').val(data[35]);//routeTemplateName
		      $('#modifyMaterialValueId').val(data[36]);//materialName
		      $('#totalTATMod').val(data[37]);//totalTAT
		      $('#totalRunTimeMod').val(data[38]);//totalRunTime
  		   
  		   }else{
  		        document.getElementById("modifyRouteTemplateLbl").style.display = 'none';
  		        document.getElementById("modifyMaterialLbl").style.display = 'none';
  		        document.getElementById("materialClient").style.display = 'none';
			    document.getElementById("totalTATDetailsMod").style.display = 'none';
   		   }
	});

	function modifyModal(uniqueId,atd,status,globalRouteId,globalTripCustId,globalVehicleSelected,category,productLine,ata){
	routeChangedCount = 0;
		modtemperatureCounter = 0;
		modTemperaturesArray = [];
	$('#modify').modal('show');
	if(('<%=legConcept%>' == 'N')){ 	
		$('#preloadTempModifyId').hide();
		$('#pleLoadTempLblId').hide();
	}else{
		$('#preloadTempModifyId').show();
		$('#pleLoadTempLblId').show();
	}
	
	$("#updateButtionId").hide();
	if(status == 'CLOSED' || status == 'CANCEL'){
		$('#dateTimeInput').jqxDateTimeInput({ disabled: true});
		$("#preloadTempModifyId").attr("disabled",true);
		$("#updateButtionId").hide();
		$("#modifyrouteDropDownID").attr("disabled",true);
		$("#modifyvehicleDropDownID").attr("disabled",true);
		$("#modifyProductLineComboId").attr("disabled",true);
		$("#modifycustrefID").attr("disabled",true);
		$("#avgSpeedModifyId").attr("disabled",true);
		$("#modifycategoryComboId").attr("disabled",true);//
		var fields = document.getElementById("modTemperatureTableId").getElementsByTagName('*');
				for(var i = 0; i < fields.length; i++){
					fields[i].disabled = true;
				}
									
	}else{
		
		if(ata != ''){
			
			$('#dateTimeInput').jqxDateTimeInput({ disabled: true});
			$("#preloadTempModifyId").attr("disabled",true);
			$("#modifyrouteDropDownID").attr("disabled",true);
			$("#modifyvehicleDropDownID").attr("disabled",true);
		//	$('#modifyrouteDropDownID').val(globalRouteId);
		//	$('#modifyvehicleDropDownID').val(globalVehicleSelected).trigger('change');
		//	$('#modifycategoryComboId').val(category).trigger('change');
			$('#modifycustrefID').attr("disabled",true);
			$("#modifyProductLineComboId").attr("disabled",true);
			$("#avgSpeedModifyId").attr("disabled",true);
			$("#modifycategoryComboId").attr("disabled",true);
		}else{
			$("#updateButtionId").hide();
			$('#dateTimeInput').jqxDateTimeInput({ disabled: false});
			$("#preloadTempModifyId").attr("disabled",false);
			$("#modifyrouteDropDownID").attr("disabled",false);
			$("#modifyvehicleDropDownID").attr("disabled",false);
			$('#modifycustrefID').attr("disabled",false);
			$("#modifyProductLineComboId").attr("disabled",false);
			$("#avgSpeedModifyId").attr("disabled",false);
			$("#modifycategoryComboId").attr("disabled",false);
		}

			
		}
		
		if(materialClient == 'Y'){
				$("#modifyrouteDropDownID").attr("disabled",true);
				$("#modifyvehicleDropDownID").attr("disabled",true);
				$('#preloadTempModifyId').hide();
				$('#pleLoadTempLblId').hide();
				$("#modifyrouteDropDownID").empty().select2();
				$.ajax({
			        url: '<%=request.getContextPath()%>/LegCreationAction.do?param=getAllRouteTemplates',
			        data: {
			        	tripCustId : globalTripCustId
			  
			        },
			        success: function(result) {
			            routeList = JSON.parse(result);
			            $('#modifyrouteDropDownID').append($("<option></option>").attr("value", 0).text("--Select Route Template--"));
			            for (var i = 0; i < routeList["routeTemplateRoot"].length; i++) {
		                    $('#modifyrouteDropDownID').append($("<option></option>").attr("value", routeList["routeTemplateRoot"][i].routeId).attr("templateId", routeList["routeTemplateRoot"][i].ID).text(routeList["routeTemplateRoot"][i].templateName));
			            }
			            $('#modifyrouteDropDownID').select2();
			            $('#modifyrouteDropDownID').val(globalRouteId).trigger('change');
			        }    
						
			  });
			  var date = document.getElementById('dateTimeInput').value+':00';
			  $("#modifyvehicleDropDownID").empty().select2();
				$.ajax({
			        url: '<%=request.getContextPath()%>/TripCreatAction.do?param=getvehiclesandgroupforclients',
			        data: {
			         productLine : "Dry",
			         vehicleReporting :vehicleReporting,
			         date : date		        	
			        },
			          success: function(result) {
			        	$("#modifyvehicleDropDownID").empty().select2();
			        	//$('#modifyvehicleDropDownID').append($("<option></option>").attr("value", globalVehicleSelected).text(globalVehicleSelected));
			            vehicleList = JSON.parse(result);
			            var found = false;
			            for (var i = 0; i < vehicleList["clientVehicles"].length; i++) {
			             if(vehicleList["clientVehicles"][i].vehicleName === globalVehicleSelected){
		       				 found = true;
		       				 }
		                    $('#modifyvehicleDropDownID').append($("<option></option>").attr("value", vehicleList["clientVehicles"][i].vehicleName).text(vehicleList["clientVehicles"][i].vehicleName));
			            }
			            if(!found){
		                     $('#modifyvehicleDropDownID').append($("<option></option>").attr("value", globalVehicleSelected).text(globalVehicleSelected));
		                }
			            $('#modifyvehicleDropDownID').select2();
			            
			           $('#modifyvehicleDropDownID').val(globalVehicleSelected).trigger('change');
			           
			        }
			    });
			    
			    
			  
		}else{
		
		$("#modifyrouteDropDownID").empty().select2();
		$.ajax({
	        url: '<%=request.getContextPath()%>/TripCreatAction.do?param=getRouteNames',
	        data: {
	        	custId : globalTripCustId,
	        	legConcept:'<%=legConcept%>',
	        	hubAssociatedRoutes : hubAssociatedRoutes
	  
	        },
	        success: function(result) {
	            routeList = JSON.parse(result);
	            for (var i = 0; i < routeList["RouteNameRoot"].length; i++) {
                    $('#modifyrouteDropDownID').append($("<option></option>").attr("value", routeList["RouteNameRoot"][i].RouteId).attr("count",routeList["RouteNameRoot"][i].legCount)
                    .text(routeList["RouteNameRoot"][i].RouteName));
	            }
	            $('#modifyrouteDropDownID').select2();
	            $('#modifyrouteDropDownID').val(globalRouteId).trigger('change');
	        }    
				
		});
		
		$("#modifyProductLineComboId").empty().select2();
		
		$.ajax({
	        url: '<%=request.getContextPath()%>/TripCreatAction.do?param=getProductLine',
	        data: {
	        	custId : globalTripCustId
	        },
	        success: function(result) {
	             var productLineStore = JSON.parse(result);
	            for (var i = 0; i < productLineStore["productLineRoot"].length; i++) {
                    $('#modifyProductLineComboId').append($("<option></option>").attr("value", productLineStore["productLineRoot"][i].productname)
                    .text( productLineStore["productLineRoot"][i].productname));                   
	            }
	            $('#modifyProductLineComboId').select2();
	            $('#modifyProductLineComboId').val(productLine).trigger('change');
	            
	            if((productLine != 'TCL') && (productLine != 'Chiller') && (productLine != 'Freezer')){ 
					$('#preloadTempModifyId').hide();
					$('#pleLoadTempLblId').hide();
				}else{
					$('#preloadTempModifyId').show();
					$('#pleLoadTempLblId').show();
				}
	            
	        }    
		});
		}
		
			$("#modifycategoryComboId").empty().select2();
		
		$.ajax({
	        url: '<%=request.getContextPath()%>/TripCreatAction.do?param=getCategory',
	        data: {
	        	custId : globalTripCustId
	        },
	        success: function(result) {
	             var categoryStore = JSON.parse(result);
	            for (var i = 0; i < categoryStore["categoryRoot"].length; i++) {
                    $('#modifycategoryComboId').append($("<option></option>").attr("value", categoryStore["categoryRoot"][i].categoryvalue)
                    .text( categoryStore["categoryRoot"][i].categoryvalue));                   
	            }
	            $('#modifycategoryComboId').select2();
	            $('#modifycategoryComboId').val(category).trigger('change');
	           	            
	        }    
				
		});
		//var productLine = document.getElementById('modifyProductLineComboId').value;		
		//var date = document.getElementById('dateTimeInput').value;		
		
		//}
	
	
	if(('<%=legConcept%>' == 'N')){ 	
		$('#preloadTempModifyId').hide();
		$('#pleLoadTempLblId').hide();
	}else{
		$('#preloadTempModifyId').show();
		$('#pleLoadTempLblId').show();
	}
	
	if(materialClient == 'Y'){
	$('#preloadTempModifyId').hide();
	$('#pleLoadTempLblId').hide();
	}
	var driverArray = [];
		$("#modifyLegTableId").empty();
		$.ajax({
	        url: '<%=request.getContextPath()%>/TripCreatAction.do?param=getTripLegDetails',
	        data: {
	        	tripId : uniqueId
	        },
	        success: function(result) {
	            var legDetails = JSON.parse(result);
				var count;
				modiFyCount = legDetails["tripLegDetailsRoot"].length;
				if(legDetails["tripLegDetailsRoot"].length > 0){
					document.getElementById("modifyTabelId").style.display = "block";
					for(var i = 0; i < legDetails["tripLegDetailsRoot"].length; i++){
						var source = legDetails["tripLegDetailsRoot"][i].source;
						var destination = legDetails["tripLegDetailsRoot"][i].destination;
						var sta = legDetails["tripLegDetailsRoot"][i].sta;
						var std = legDetails["tripLegDetailsRoot"][i].std;
						var name = legDetails["tripLegDetailsRoot"][i].name;
						var legId = legDetails["tripLegDetailsRoot"][i].legId;
						var driver1 = legDetails["tripLegDetailsRoot"][i].driver1;
						var driver2 = legDetails["tripLegDetailsRoot"][i].driver2;
						driverArray.push(driver1);
						driverArray.push(driver2);
						count = i+1;
						$("#modifyLegTableId").append("<tr><td style='font-weight:700;'>"+ count +". </td> <td style='display:none;' id=legIdm"+count+">"+legId+"</td> <td>"+name+"</td> <td>"+source+"</td>"+
						" <td>"+destination+"</td> <td id=stdIdm"+count+">"+std+"</td> <td id=staIdm"+count+">"+sta+"</td>"+
						" <td><select class=comboClassDriver id=driverIdm1"+count+" data-live-search=true onchange='changeFunModify("+count+")' required=required ></select></td> "+
				 		" <td><select class=comboClassDriver id=driverIdm2"+count+" data-live-search=true onchange='changeFunModify("+count+")' required=required ></select></td></tr>");
						
						if(status == 'CLOSED'){
								//if('<%=userAuthority%>' == 'ProdOwn' || '<%=userAuthority%>' == 'T4u Users'){
								if(isValid){
									$("#driverIdm1"+count).prop("disabled", false);
									$("#driverIdm2"+count).prop("disabled", false);
									$("#updateButtionId").hide();
								}else{
									$("#driverIdm1"+count).prop("disabled", true);
									$("#driverIdm2"+count).prop("disabled", true);
								}
						}else if (status == 'CANCEL'){
									$("#driverIdm1"+count).prop("disabled", true);
									$("#driverIdm2"+count).prop("disabled", true);
						
						}else{
							if(legDetails["tripLegDetailsRoot"][i].ata == ''){
								$("#driverIdm1"+count).prop("disabled", false);
								$("#driverIdm2"+count).prop("disabled", false);
								$("#updateButtionId").hide();
							}else{
								//if('<%=userAuthority%>' == 'ProdOwn' || '<%=userAuthority%>' == 'T4u Users'){
								if(isValid){
									$("#driverIdm1"+count).prop("disabled", false);
									$("#driverIdm2"+count).prop("disabled", false);
									$("#updateButtionId").hide();
								}else{
									$("#driverIdm1"+count).prop("disabled", true);
									$("#driverIdm2"+count).prop("disabled", true);
								}
								
							}
						}
					}
				}else{
					document.getElementById("modifyTabelId").style.display = "none";
				}
			}
		});
		
		setTimeout( function() {
			$.ajax({
	      		url: '<%=request.getContextPath()%>/TripCreatAction.do?param=getDriverList',
	      		data:{
	      			tripId : uniqueId
	      		},
	      		success: function(result) {
	           		driverList = JSON.parse(result);
	           		for(var rec = 1,c=0; rec <= modiFyCount; rec++){
		           		for (var j = 0; j < driverList["driverDetailsRoot"].length; j++) {
		                  	$('#driverIdm1'+rec).append($("<option></option>").attr("value", driverList["driverDetailsRoot"][j].driverId).text(driverList["driverDetailsRoot"][j].driverName));
		                  	$('#driverIdm2'+rec).append($("<option></option>").attr("value", driverList["driverDetailsRoot"][j].driverId).text(driverList["driverDetailsRoot"][j].driverName));
		           		}
		           		$('#driverIdm1'+rec).select2();
			            $('#driverIdm2'+rec).select2();
			            
						$('#driverIdm1'+rec).val(driverArray[c]== null ? '': driverArray[c]).trigger('change');
						$('#driverIdm2'+rec).val(driverArray[c+1]== null ? '': driverArray[c+1]).trigger('change');
						c += 2;
		           	} 
	      		}
			});
		},1000);
	}
	
	function changeRouteModal(uniqueId,tripCustId,globalRouteId){
		$('#chengeRoute').modal('show');
		$("#changeRouteId").empty().select2();
		$.ajax({
     			url: '<%=request.getContextPath()%>/TripCreatAction.do?param=getAvailableRoutes',
     			data:{
     				tripId : uniqueId,
     				routeId : globalRouteId,
     				tripCustId : tripCustId 
     			},
     			success: function(result) {
          			routeList = JSON.parse(result);
          			for(var j = 0; j < routeList["changesRouteRoot"].length; j++){
          				$('#changeRouteId').append($("<option></option>").attr("value", routeList["changesRouteRoot"][j].routeId).attr("count",routeList["changesRouteRoot"][j].legCount)
            				.text(routeList["changesRouteRoot"][j].routeName));
          			}
     			}
		});
	}
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
	        reasonId : reasonId,
	        status: status 	        
	    };
	    
	    $.ajax({
	        url: '<%=request.getContextPath()%>/TripCreatAction.do?param=cancelTrip',
	        data: param,
	        success: function(result) {
	        $('#cancelModal').modal('hide');
	        sweetAlert(result);
	         document.getElementById("remarksId").value="";
	        setTimeout(function(){
	                    getData();
	                    }, 1000);
	        	 
	        }
		})
	}

//######################function to save details#################
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
	//addorderId = document.getElementById("addorderId").value;
	var routeId = $('#addrouteDropDownID option:selected').attr("value");
	var routeTemplateId = $('#routeTemplateDropDownID option:selected').attr("value");
	var routeName = $('#addrouteDropDownID option:selected').text();
	var vehicleNo= document.getElementById("addvehicleDropDownID").value;
	var categoryComboVal= $('#categoryComboId option:selected').attr("value");
	plannedDateTime = document.getElementById("adddateTimeInput").value;
	custReference=document.getElementById("custReferenceId").value;
	var avgSpeed = document.getElementById("avgSpeedId").value;	
	var	minHumidity = "";
	var maxHumidity = "";
	var minTemp = "";
	var maxTemp = "";
	var preLoadTemp = "";
	var sealNo = "";
	var noOfBags = "";
	var tripType = "";
	var noOfFluidBags = "";
	var openingKms = "";
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
    if(materialClient == 'Y'){
    	if(routeTemplateId=="0" || routeTemplateId == 'undefined'){
		sweetAlert("Please select Route Template");
	    	return;
	}
	if($('#addMaterialComboId option:selected').attr("value") == "0" || $('#addMaterialComboId option:selected').attr("value") == 'undefined'){
    		sweetAlert("Please select Material");
    		return;
      }
      routeName = $('#routeTemplateDropDownID option:selected').text();
      routeId=  $('#routeTemplateDropDownID option:selected').attr("routeId");

    }else{
      if(routeId=="" || routeId == 'undefined'){
    	sweetAlert("Please select Route Name");
    	return;
	}

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
    if(category == "Y" ){
    	if(categoryComboVal == "" || categoryComboVal == 'undefined'||categoryComboVal=="--select category--"){
    		sweetAlert("Please select Category");
    		return;
    	}
    }
    if(plannedDateTime==""){
    	sweetAlert("Please select Trip Date Time");
    	return;
    }
    
  	var avgSpeedCreate = document.getElementById("avgSpeedId").value;
	
    if(avgSpeedCreate == ""){
    	sweetAlert("Please enter average speed");
    	return;
    }
    if(parseFloat(avgSpeedCreate) < 1){
    	sweetAlert("Average speed cannot be zero");
    	return;
    }
    if (parseFloat(avgSpeedCreate) > 99 ){
            sweetAlert("Please Enter Average speed less than 100");
            return;
    }
    //if(associatedTemp>0){
    var productLine12 = document.getElementById('addProductLineComboId').value;
    if(newFields == "Y"){
    	
    	sealNo = document.getElementById("sealNoId").value;
    	noOfBags = document.getElementById("noOfBagsId").value;
    	tripType = document.getElementById("tripTypeId").value;
    	noOfFluidBags = document.getElementById("fluidBagsId").value;
    	openingKms = document.getElementById("openingKmsId").value;
    	tripRemarks = document.getElementById("tripRemarksId").value;
    }
    
    if((productLine12 == "Chiller") || (productLine12 == "Freezer") || (productLine12 == "TCL") ){
    //if((productLine12 == "TCL")){
    			allTemperaturesArray = [];
		    for (var j=0;j < temperatureCounter ;j++ ){
				    var name2 = "";
				    var minNeg = parseFloat(document.getElementById("ex20").value);
				    var maxNeg = parseFloat(document.getElementById("ex30").value);
				    var minPos = parseFloat(document.getElementById("ex40").value);
				    var maxPos = parseFloat(document.getElementById("ex50").value);
				    var sensorName = document.getElementById("ex60").value;
				   // console.log(" minNeg : "+minNeg + " maxNeg : "+maxNeg + " minPos : "+minPos + " maxPos : "+maxPos);
				    
				    if ((Number.isNaN(minNeg)) || (minNeg < -70 || minNeg > 70)){
				    	sweetAlert("Please enter Min negative temperature values between -70 °C to 70 °C for "+name2+" ");
				    	return;
				    } if ((Number.isNaN(maxNeg)) || (maxNeg < -70 || maxNeg > 70)){
				    	sweetAlert("Please enter Max negative temperature values between -70 °C to 70 °C for "+name2+" ");
				    	return;
				    }if ((Number.isNaN(minPos)) || (minPos < -70 || minPos > 70)){
				    	sweetAlert("Please enter Min positive temperature values between -70 °C to 70 °C for "+name2+" ");
				    	return;
				    } if ((Number.isNaN(maxPos)) || (maxPos < -70 || maxPos > 70)){
				    	sweetAlert("Please enter Max positive temperature values between -70 °C to 70 °C for "+name2+" ");
				    	return;
				    }if (minNeg >  maxNeg){
				    	sweetAlert("Min negative temperature value should be less than Max negative temperature value for "+name2+" ");
				    	return;
				    }if (maxNeg > minPos){
				    	sweetAlert("Max negative temperature value should be less than Min positive temperature value for "+name2+" ");
				    	return;
				    }if (minPos > maxPos){
				    	sweetAlert("Min positive temperature value should be less than Max positive temperature value for "+name2+" ");
				    	return;
				    }
				    
				    allTemperaturesArray.push({ name2,  minNeg,  maxNeg , minPos,  maxPos,sensorName}) ;	
					//console.log(" allTemperaturesArray  : "+JSON.stringify(allTemperaturesArray));
				    
		    }
		   selecedSensorsForAlert = [];
		    for (var j=0;j < tempSensorNames.length ;j++ ){
		    	if(document.getElementById(tempSensorNames[j]).checked){
		    		selecedSensorsForAlert.push(tempSensorNames[j])
		    	}
		    }
    	tempeartureArray = JSON.stringify(allTemperaturesArray);///sliderMin.getValue()+"/";
		minHumidity = document.getElementById("minHumidityId").value;
		maxHumidity = document.getElementById("maxHumidityId").value;
		preLoadTemp = document.getElementById('preTempId').value;
    	
   		if(humidity=='Y')
   		{
  		if(minHumidity == ""){
    		sweetAlert("Please enter Minimum Humidity");
    		return;
    	}
    	if(maxHumidity == ""){
    		sweetAlert("Please enter Maximum Humidity");
    		return;
   		}
   		if(parseInt(minHumidity) > 100){
    		sweetAlert("Minimum Humidity % should be between 0 to 100 ");
    		return;
   		}
   		if(parseInt(maxHumidity) > 100){
    		sweetAlert("Maximum Humidity % should be between 0 to 100");
    		return;
   		}
  		if(parseInt(minHumidity) >= parseInt(maxHumidity)){
    		sweetAlert("Maximum Humidity should be greater than Minimum Humidity");
    		return;
   		}
   		}
   		if(productLine12 == "TCL" || productLine12 == "Chiller" || productLine12 == "Freezer"){
	   		if (preLoadTemp == ""){
	   		  sweetAlert("Please enter Pre-Loading Temperature");
	   		  return;
	   		}
   		}
   		if(((parseFloat(document.getElementById('preTempId').value) < -70 || parseFloat(document.getElementById('preTempId').value > 70)))){
   			sweetAlert("Please enter Pre-Loading Temperature in between -70 to 70 °C");
    		return;
   		}
   		
    }else{
    	tempeartureArray = "";
		minHumidity = "";
		maxHumidity = "";
		preLoadTemp = "";
    }
    var fileImgPath = document.getElementById('imgUploadId').value;
    var allDivers = "";
    var dates = "";
    var legId = "";
    for(var i = 1; i <= recordsCount; i++){
   		if(document.getElementById('driverId1'+i).value != '' && document.getElementById('driverId2'+i).value != ''){
   			if(document.getElementById('driverId1'+i).value == document.getElementById('driverId2'+i).value){
   				sweetAlert("Leg "+i+" has same drivers");
   				return;
   			}
   		}
    	allDivers += document.getElementById('driverId1'+i).value+'#'+document.getElementById('driverId2'+i).value+',';
    	dates += $('#tabelId #stdId'+i).text()+'#'+$('#tabelId #staId'+i).text()+',';
    	legId += $('#tabelId #legId'+i).text()+',';
    }
    var param = {
        CustId: customerId,
        routeId: routeId,
        routeName: routeName,
        vehicleNo: vehicleNo,
        plannedDate: plannedDateTime,
        alertId: checkbox,
        addcustomerName:  $('#addcustNameDownID option:selected').text(),
        custReference: custReference,
        avgSpeed : avgSpeedCreate,
        filePath: fileImgPath,
        viewFlag: viewFlag,
        startDate: document.getElementById("dateInput1").value,
        endDate: document.getElementById("dateInput2").value,
        minHumidity: minHumidity,
        maxHumidity: maxHumidity,
        tempeartureArray : tempeartureArray, 
		peLoadTemp : preLoadTemp,
		drivers : allDivers,
		date : dates,
		legId : legId,
		recordsCount : recordsCount,
		productLine : $('#addProductLineComboId option:selected').attr("value"),
		category:$('#categoryComboId option:selected').attr("value"),
		tripCustId : $('#addcustNameDownID option:selected').attr("value"),
		sealNo : sealNo,
		noOfBags : noOfBags,
		tripType : tripType,
		noOfFluidBags : noOfFluidBags,
		openingKms : openingKms,
		tripRemarks : tripRemarks,
		materialClient :materialClient,
		routeTemplateId:$('#routeTemplateDropDownID option:selected').attr("value"),
		materialId : $('#addMaterialComboId option:selected').attr("value"),
		customerName : customerName, // Main  customer for  no generation
		selSensorsToAlertTrigger : JSON.stringify(selecedSensorsForAlert) 
        };
    $.ajax({
        url: '<%=request.getContextPath()%>/TripCreatAction.do?param=saveTripData',
        data: param,
        success: function(result) {
        	if (result == "Saved Successfully") {
<!--        		$.ajax({-->
<!--        			type:"POST",-->
<!--					url : "<%=request.getContextPath()%>/UploadCreateTripImage",		//'UploadCreateTripImage',-->
<!--					enctype: 'multipart/form-data',-->
<!--				//	data : formData,-->
<!--					data : {-->
<!--					filePath : document.getElementById("imageForm").value//$('#userName').val()-->
<!--					},-->
<!--					success : function(responseText) {-->
<!--					//alert("SERVLET SUCCESS");//$('#ajaxGetUserServletResponse').text(responseText);-->
<!--				}-->
<!--				});-->



				if(fileImgPath!="" && fileImgPath != null){
					//alert("IMG PATH"+fileImgPath);
				document.getElementById("imageForm").submit();
				}
   			   //	sweetAlert("Saved Successfully");

   			   if('<%=pageId%>' == 'vehicleReport'){
   			   		openVehicleReportPage();
   			   	}
               		setTimeout(function(){
		               	sweetAlert("Saved Successfully");
		                getData();
		                document.getElementById("addcustNameDownID").value="";
		                document.getElementById("custReferenceId").value="";
		               // document.getElementById("addorderId").value="";
		                document.getElementById("addvehicleDropDownID").value="";
					    document.getElementById("addrouteDropDownID").value = "";
					    document.getElementById("imgUploadId").value = "";
					    $('#adddateTimeInput ').jqxDateTimeInput('setDate', new Date());
					    $('input:checkbox').removeAttr('checked');
					    document.getElementById("avgSpeedId").value = "";
					    $('#add').modal('hide');
					    
					    
					    //$("#addrouteDropDownID").empty().select2();
        				//$("#addvehicleDropDownID").empty().select2();
						//$("#legTableId").empty();
						//$('#tabelId').empty()
					    
               		}, 1000);

                 } else {
                     sweetAlert(result);
                     //getData();
                     //document.getElementById("addcustNameDownID").value="";
                     //document.getElementById("custReferenceId").value="";
                     //document.getElementById("addorderId").value="";
                   	 //document.getElementById("addvehicleDropDownID").value="";
			    	 //document.getElementById("addrouteDropDownID").value = "";
			    	// $('#adddateTimeInput ').jqxDateTimeInput('setDate', new Date());
			    	 $('input:checkbox').removeAttr('checked');
			    	 //document.getElementById("avgSpeedId").value = "";
			    	 //document.getElementById("imgUploadId").value = "";
                 }
        }
		});
	}

	function modifyData(){
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
	
		customerName = document.getElementById("custDropDownId").value;
	    for (var i = 0; i < customerDetails["CustomerRoot"].length; i++) {
	        if (customerName == customerDetails["CustomerRoot"][i].CustName) {
	             customerId = customerDetails["CustomerRoot"][i].CustId;
	
	        }
	      }
	      if(customerName=="" ){
	    	sweetAlert("Please select customer");
	    	return;
	    }
	     
	    var modRouteId = document.getElementById("modifyrouteDropDownID").value;
    	if(modRouteId=="" ){
	    	sweetAlert("Invalid Route Number");
	    	return;
	    }
	    if(materialClient == 'N'){
	    if(document.getElementById("modifyProductLineComboId").value == ""){
	    	sweetAlert("Please select Product Line");
	    	return;
    	}
    	}
	    
    	var modVehNo = document.getElementById("modifyvehicleDropDownID").value;
    	if(modVehNo=="" ){
	    	weetAlert("Please select Vehicle Number");
	    	return;
	    }if(modVehNo=="-- select vehicle number --" ){
	    	weetAlert("Please select Vehicle Number");
	    	return;
	    }
	    //"--Select Remarks--"
	    if(document.getElementById("modifycustrefID").value == ""){
	    	sweetAlert("Please enter Customer Ref. ID");
	    	return;
    	}
	    if(document.getElementById("dateTimeInput").value == ""){
	    	sweetAlert("Please select Trip Date Time");
	    	return;
    	}
    	var avgSpeedMod = document.getElementById("avgSpeedModifyId").value;
    	if(avgSpeedMod == ""){
	    	sweetAlert("Please enter Average Speed ");
	    	return;
    	}
    	if(category == "Y" ){
    	var categoryComboValMod = document.getElementById("modifycategoryComboId").value;
    	if(categoryComboValMod == "" || categoryComboValMod == 'undefined'||categoryComboValMod=="--select category--"){
    		sweetAlert("Please select Category");
    		return;
    	}
    	}
    	if(parseFloat(avgSpeedMod) < 1){
    	sweetAlert("Average speed cannot be zero");
    	return;
    	}
    	if (parseFloat(avgSpeedMod) > 99 ){
            sweetAlert("Please Enter Average speed less than 100");
            return;
     	}
    	
		var plannedDateTime = document.getElementById("dateTimeInput").value;
		
   		if(Number(document.getElementById('preloadTempModifyId').value) > 0 && (Number(document.getElementById('preloadTempModifyId').value) < -70 || Number(document.getElementById('preloadTempModifyId').value > 70))){
   			sweetAlert("Please enter Pre-Loading Temperature in between -70 to 70 °C");
    		return;
   		}
   		    var allDivers = "";
	    
	    var dates = "";
	    var legId = "";
<!--	    var modSealNo = "";-->
<!--		var modNoOfBags = "";-->
<!--		var modTripType = "";-->
<!--		var modNoOfFluidBags = "";-->
<!--		var modOpeningKms = "";-->
<!--		var modTripRemarks = "";-->
<!--		if(newFields == "Y"){-->
<!--			modSealNo = document.getElementById("modifySealNoId").value;-->
<!--    		modNoOfBags = document.getElementById("modifyNoOfBagsId").value;-->
<!--    		modTripType = document.getElementById("modifyTripTypeId").value;-->
<!--    		modNoOfFluidBags = document.getElementById("modifyFluidBagsId").value;-->
<!--    		modOpeningKms = document.getElementById("modifyOpeningKmsId").value;-->
<!--    		modTripRemarks = document.getElementById("modifyTripRemarksId").value;-->
<!--		}-->
		
	    
	    for(var i = 1; i <= modiFyCount; i++){
	   		if(document.getElementById('driverIdm1'+i).value != '' && document.getElementById('driverIdm2'+i).value != ''){
	   			if(document.getElementById('driverIdm1'+i).value == document.getElementById('driverIdm2'+i).value){
	   				sweetAlert("Leg "+i+" has same drivers");
	   				return;
	   			}
	   		}
	    	allDivers += document.getElementById('driverIdm1'+i).value+'#'+document.getElementById('driverIdm2'+i).value+',';
	    	dates += $('#modifyLegTableId #stdIdm'+i).text()+'#'+$('#modifyLegTableId #staIdm'+i).text()+',';
	    	legId += $('#modifyLegTableId #legIdm'+i).text()+',';
	    }
	    
	    
	    	modTempeartureArrayData = "";
	    	var plcombo = document.getElementById("modifyProductLineComboId").value;
	       if(plcombo == "TCL" || plcombo == "Chiller" || plcombo == "Freezer"){
    			modTemperaturesArray = [];
		    for (var l=0;l < modtemperatureCounter ;l++ ){
				    var name2Mod = "";
				    var minNegMod = parseFloat(document.getElementById("exm20").value);
				    var maxNegMod = parseFloat(document.getElementById("exm30").value);
				    var minPosMod = parseFloat(document.getElementById("exm40").value);
				    var maxPosMod = parseFloat(document.getElementById("exm50").value);
				    var sensorNameMod = document.getElementById("exm60").value;
				 //   console.log(" minNeg : "+minNegMod + " maxNeg : "+maxNegMod + " minPos : "+minPosMod + " maxPos : "+maxPosMod);
				    
				    if ((Number.isNaN(minNegMod)) || (minNegMod < -70 || minNegMod > 70)){
				    	sweetAlert("Please enter Min negative temperature values between -70 °C to 70 °C for "+name2Mod+" ");
				    	return;
				    } if ((Number.isNaN(maxNegMod)) || (maxNegMod < -70 || maxNegMod > 70)){
				    	sweetAlert("Please enter Max negative temperature values between -70 °C to 70 °C for "+name2Mod+" ");
				    	return;
				    }if ((Number.isNaN(minPosMod)) || (minPosMod < -70 || minPosMod > 70)){
				    	sweetAlert("Please enter Min positive temperature values between -70 °C to 70 °C for "+name2Mod+" ");
				    	return;
				    } if ((Number.isNaN(maxPosMod)) || (maxPosMod < -70 || maxPosMod > 70)){
				    	sweetAlert("Please enter Max positive temperature values between -70 °C to 70 °C for "+name2Mod+" ");
				    	return;
				    }if (minNegMod >  maxNegMod){
				    	sweetAlert("Min negative temperature value should be less than Max negative temperature value for "+name2Mod+" ");
				    	return;
				    }if (maxNegMod > minPosMod){
				    	sweetAlert("Max negative temperature value should be less than Min positive temperature value for "+name2Mod+" ");
				    	return;
				    }if (minPosMod > maxPosMod){
				    	sweetAlert("Min positive temperature value should be less than Max positive temperature value for "+name2Mod+" ");
				    	return;
				    }
				    
				    modTemperaturesArray.push({ name2Mod,  minNegMod,  maxNegMod , minPosMod,  maxPosMod,sensorNameMod}) ;	
					//console.log(" modTemperaturesArray  : "+JSON.stringify(modTemperaturesArray));
				    
		    }
		    modTempeartureArrayData = JSON.stringify(modTemperaturesArray);
		    selecedSensorsForAlert = [];
		    for (var j=0;j < tempSensorNames.length ;j++ ){
		    	if(document.getElementById(tempSensorNames[j]).checked){
		    		selecedSensorsForAlert.push(tempSensorNames[j])
		    	}
		    }
		    }
	    
	    
	    
	    
		var tripId = uniqueId;
		var routeNameMod = $('#modifyrouteDropDownID option:selected').text();
		var param = {
	        CustId: customerId,
	        plannedDate: plannedDateTime,
	        tripId: tripId,
	        drivers : allDivers,
	        dates : dates,
	        legId : legId,
	        preLoadTemp : document.getElementById('preloadTempModifyId').value,
	        recordsCount : modiFyCount,
	        modifyAvgSpeed : document.getElementById("avgSpeedModifyId").value,
	        vehicleNo : modVehNo,
	        routeId : modRouteId,
	        custRefId : document.getElementById("modifycustrefID").value,
	        category : document.getElementById("modifycategoryComboId").value,
	        productLine :  document.getElementById("modifyProductLineComboId").value,
	        routeName : routeNameMod,
	        modTempeartureData : modTempeartureArrayData,
	        selSensorsToAlertTrigger : JSON.stringify(selecedSensorsForAlert)
	        
<!--	        modSealNo : modSealNo,-->
<!--			modNoOfBags : modNoOfBags,-->
<!--			modTripType : modTripType,-->
<!--			modNoOfFluidBags : modNoOfFluidBags,-->
<!--			modOpeningKms : modOpeningKms,-->
<!--			modTripRemarks : modTripRemarks-->
	        
	    };
	     $.ajax({
	        url: '<%=request.getContextPath()%>/TripCreatAction.do?param=modifyTripData',
	        data: param,
	        success: function(result) {
	        	if (result == "Updated Successfully") {
	                    sweetAlert("Updated Successfully");
	                  	setTimeout(function(){
	                    getData();
	                    document.getElementById("addcustNameDownID").value="";
	                    document.getElementById("custReferenceId").value="";
	                    //document.getElementById("addorderId").value="";
	                    document.getElementById("addvehicleDropDownID").value="";
					    document.getElementById("addrouteDropDownID").value = "";
					    $('#adddateTimeInput ').jqxDateTimeInput('setDate', new Date());
					    $('input:checkbox').removeAttr('checked');
					    document.getElementById("modifycustNameDownID").value="";
					    document.getElementById("modifycustrefID").value="";
					    document.getElementById("modifyorderId").value="";
					    document.getElementById("modifyrouteDropDownID").value="";
					    document.getElementById("modifyvehicleDropDownID").value="";
					    $('#modify').modal('hide');
					    
	                     }, 1000);
	                 } else {
	                     sweetAlert(result);
	                     
	                 }
	        }
		})
	}

	function openOverideActualsModal(){
		$('#overrideActuals').modal('show');
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
	    var statusType = 'OPEN';
	    $('#tripNameCombo').empty().select2();
	    $('#atpDateTimeInput').jqxDateTimeInput('setDate', '');
	    $('#atdDateTimeInput').jqxDateTimeInput('setDate', '');
	    $('#stpDateTime').val('');
	    $('#stdDateTime').val('');
	    $('#overrideRemarksId').val('');
	    $('#ataDateTimeInputOverride').jqxDateTimeInput('setDate', '');
	    $('#staDateTimeOverride').val('');
        $.ajax({
            type: "POST",
            url: '<%=request.getContextPath()%>/TripCreatAction.do?param=getTripScheduleAndActualTime',
            "data": {
            	 CustId: customerId,
                 startdate: startDate,
                 enddate: endDate,
                 statusType: statusType
            },
            success: function(result) {
            	tripList = JSON.parse(result);
   		        $('#tripNameCombo').append($("<option></option>").attr("value", 0).text("--Select Trip No--"));
	            for (var i = 0; i < tripList["tripDetails"].length; i++) {
                	$('#tripNameCombo').append($("<option></option>")
                	.attr("value", tripList["tripDetails"][i].id)
                 	.attr('STP',tripList["tripDetails"][i].STP)
                 	.attr('ATP',tripList["tripDetails"][i].ATP)	
                 	.attr('STA',tripList["tripDetails"][i].STA)
                 	.attr('ATA',tripList["tripDetails"][i].ATA)	
                 	.attr('STD',tripList["tripDetails"][i].STD)
                 	.attr('ATD',tripList["tripDetails"][i].ATD)	
                 	.attr('remarks',tripList["tripDetails"][i].remarks)
                 	.attr('vehicleNo',tripList["tripDetails"][i].vehicleNo)	
                 	.text(tripList["tripDetails"][i].tripNameIndex));
	            }
	            $('#tripNameCombo').select2();
              } 	 
           });
     }

	function overrideActualTime(){
		var tripId = $('#tripNameCombo option:selected').attr("value");
		var vehicleNo =$('#tripNameCombo option:selected').attr("vehicleNo");
		var std = $('#tripNameCombo option:selected').attr("STD");
		if(tripId == 0){
			sweetAlert("Please select a Trip No");
			return;
		}
		var stp = document.getElementById("stpDateTime").value;
		var atp = document.getElementById("atpDateTimeInput").value;
		var atd = document.getElementById("atdDateTimeInput").value;
		if(atp == ''){
			sweetAlert("Please enter ATP");
			return;
		}
		
		if(atd != '' && getDateObject(atp) > getDateObject(atd)){
			sweetAlert("ATD cannot be less than ATP");
			return;
		}
		//if('<%=userAuthority%>' != 'ProdOwn' && '<%=userAuthority%>' != 'T4u Users'){
if(!isValid){
			if(!globalATPDisabled){
				var atpDifference = gettimediff(getDateObject(stp),getDateObject(atp));
				if(parseInt(atpDifference) < parseInt(-(<%=atpContraint%>)) || parseInt(atpDifference) > parseInt(<%=atpContraint%>)){
					sweetAlert("ATP should be within "+<%=atpContraint%>+" hr from STP");
					return;
				}
			}
			if(!globalATDdisabled && atd != ''){
				var atdDifference = gettimediff(getDateObject(atp),getDateObject(atd));
				if(parseInt(atdDifference) < parseInt(-(<%=atdContraint%>)) || parseInt(atdDifference) > parseInt(<%=atdContraint%>)){
					sweetAlert("ATD should be within "+<%=atdContraint%>+" hr of ATP");
					return;
				}
			}
		}
		if(document.getElementById("ataDateTimeInputOverride").value != '' && atd == ''){
			sweetAlert("Please enter ATD");
			return;
		}
	    if (document.getElementById("ataDateTimeInputOverride").value != '' && 
	    	getDateObject(atd) > getDateObject(document.getElementById("ataDateTimeInputOverride").value)) {
	        sweetAlert("ATA cannot be less than ATD");
	        return;
	    }
		var remarks = document.getElementById("overrideRemarksId").value;
		
		var atpChanged = false;
	    var atdChanged = false;
	    var ataChanged = false;
	    
	    if(globalATPOverride != atp){
	    	atpChanged = true
	    }
	    if(globalATDOverride != atd){
	    	atdChanged = true
	    }
	    if(globalATAOverride != document.getElementById("ataDateTimeInputOverride").value){
	    	ataChanged = true
	    	checkATAisValid(tripId,document.getElementById("ataDateTimeInputOverride").value);
	    	
	    }
	    if(!atpChanged && !atdChanged && !ataChanged){
	    	sweetAlert("At least one of ATP,ATD or ATA should be changed to proceed");
	        return;
	    }
		$.ajax({
            type: "POST",
            url: '<%=request.getContextPath()%>/TripCreatAction.do?param=updateTripActualTime',
            "data": {
            	 tripId: tripId,
            	 atp: atp,
            	 atd: atd,
            	 std:std,
            	 remarks:remarks,
            	 vehicleNo:vehicleNo,
            	 ata : document.getElementById("ataDateTimeInputOverride").value,
            	 atpChanged : atpChanged,
            	 atdChanged : atdChanged,
            	 ataChanged : ataChanged
            },
            success: function(result) {
				setTimeout(function(){
	    			sweetAlert(result);
					$('#overrideActuals').modal('hide');
					getData();
	   			}, 1000);
           } 	 
    	});
	}
	function checkATAisValid(tripId,ata){
		$.ajax({
            type: "POST",
            url: '<%=request.getContextPath()%>/TripCreatAction.do?param=checkATAisValid',
            "data": {
            	 tripId: tripId,
            	 ata : ata
            },success: function(result) {
				setTimeout(function(){
	    			if(result != ''){
	    				sweetAlert("ATA cannot be less than last hub departure(ATD) "+result);
	    				return;
	    			}
	    		},500);
           	} 	 
    	});
	}
	function getDateObject(datestr) {
	    var parts = datestr.split(' ');
	    var dateparts = parts[0].split('/');
	    var day = dateparts[0];
	    var month = parseInt(dateparts[1]) - 1;
	    var year = dateparts[2];
	    var timeparts = parts[1].split(':')
	    var hh = timeparts[0];
	    var mm = timeparts[1];
	    var date = new Date(year, month, day, hh, mm, 00, 00);
	    return date;
	}
	function gettimediff(t1, t2) {
	    var diff = t2 - t1;
	    var hours = Math.floor(diff / 3.6e6);
	    var minutes = Math.floor((diff % 3.6e6) / 6e4);
	    var seconds = Math.floor((diff % 6e4) / 1000);
	    if (hours < 10 && hours >= 0) {
	        hours = "0" + hours;
	    }
	    if (minutes < 10 && minutes >= 0) {
	        minutes = "0" + minutes;
	    }
	    if (seconds < 10 && seconds >= 0) {
	        seconds = "0" + seconds;
	    }
	    var duration = hours + ":" + minutes + ":" + seconds;
	    return hours;
	}   
    function openAddModal(){
   		if(document.getElementById("custDropDownId").value==""){
   			sweetAlert("Please select customer name");
    		return;
    	}
		loadCustomerAndVehicle();
		
		setTimeout(function(){
			loadData();
			if(materialClient == 'Y'){
			loadRouteTemplates();
		}},1000);
		document.getElementById("avgSpeedId").value = avgSpeedVal;
		document.getElementById("custReferenceId").value = "";
		//document.getElementById("addorderId").value = "";
		//$("#addrouteDropDownID").empty().select2();
        //$("#addvehicleDropDownID").empty().select2();
		document.getElementById("imgUploadId").value = "";
		//$('#tabelId').empty()
		document.getElementById("tabelId").style.display = "none";
		document.getElementById("tempTableId").style.display = "none";
		document.getElementById("tempConfigTableId").style.display = "none";
		$("#legTableId").empty();
		$("#temperatureEvents").empty();
		document.getElementById("preTempId").value = "";
		document.getElementById("minHumidityId").value = "";
		document.getElementById("maxHumidityId").value = "";
		if(events=='N')
		{
		$('#event').hide();
		}
		if(checkBoxVal=='Y'){
			document.getElementById("checkboxAll").checked = true;
			document.getElementById("checkbox1").checked = true;
			document.getElementById("checkbox2").checked = true;
			document.getElementById("checkbox3").checked = true;
			document.getElementById("checkbox4").checked = true;
			document.getElementById("checkbox5").checked = true;
			document.getElementById("checkbox6").checked = true;
			document.getElementById("checkbox7").checked = true;
			document.getElementById("checkbox8").checked = true;
			document.getElementById("checkbox9").checked = true;
			document.getElementById("checkbox10").checked = true;
			document.getElementById("checkbox11").checked = true;
			document.getElementById("checkbox12").checked = true;
			document.getElementById("checkbox13").checked = true;
			document.getElementById("checkbox14").checked = true;
			document.getElementById("checkbox15").checked = true;
			document.getElementById("checkbox16").checked = true;
		}
		
		//MLLNEWFIELDS
		if(newFields=='N'){
			//document.getElementById("extraFields").style.display = "none";
			//document.getElementById("extraFields2").style.display = "none";
			//document.getElementById("modifyExtraFields").style.display = "none";
			//document.getElementById("modifyExtraFields2").style.display = "none";

		}
		$('#add').modal('show');
		hideFieldsBasedOnMaterialClient();
    }

	function hideFieldsBasedOnMaterialClient(){
		   if(materialClient == 'Y'){
			      document.getElementById("routeNameTDId").style.display = 'none';
			      document.getElementById("routeNameLblTDId").style.display = 'none';
			      document.getElementById("productLineLblId").style.display = 'none';
			      document.getElementById("productLineId").style.display = 'none';
			      document.getElementById("totalTAT").value= '';	
			      document.getElementById("totalRunTime").value= '';
			      $("#addMaterialComboId").empty().select2();
			   
			   }else{
			   		document.getElementById("routeTemplateLblTDId").style.display = 'none';
			        document.getElementById("routeTemplateId").style.display = 'none';
					document.getElementById("materialLblId").style.display = 'none';
			        document.getElementById("materialId").style.display = 'none';
			        document.getElementById("totalTATDetails").style.display = 'none';
			   }
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
                
        
        if(('<%=legConcept%>' == 'N')){        
        	window.location = "<%=request.getContextPath()%>/Jsps/Common/RouteCreation.jsp?custId="+customerId+"&createRouteFromTrip="+createRouteFromTrip+"&vehicleNo=<%=vehicleNoNew%>&pageFlag="+pageFlag+"";
        }else{
        	window.location = "<%=request.getContextPath()%>/Jsps/GeneralVertical/RouteMaster.jsp?custId="+customerId+"&createRouteFromTrip="+createRouteFromTrip+"&vehicleNo=<%=vehicleNoNew%>"+"&routeId="+routeId+"&tripCustId="+tripCustId;
        }
   		     
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
         
		        
        if(('<%=legConcept%>' == 'N')){  
        	var buttonValue="Modify";
        	var viewFromCreateTrip="CreateTrip";
        	window.location = "<%=request.getContextPath()%>/Jsps/Common/RouteCreation.jsp?buttonValue="+buttonValue+"&routeId="+routeId+"&viewFromCreateTrip="+viewFromCreateTrip+"&vehicleNo=<%=vehicleNoNew%>&pageFlag="+pageFlag+"";
        }else{
        	window.location = "<%=request.getContextPath()%>/Jsps/GeneralVertical/RouteMaster.jsp?custId="+customerId+"&createRouteFromTrip="+createRouteFromTrip+"&vehicleNo=<%=vehicleNoNew%>"+"&routeId="+routeId+"&tripCustId="+tripCustId;
        }	
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
	        url: '<%=request.getContextPath()%>/TripCreatAction.do?param=getvehiclesandgroupforclients',
	        data: {
	         productLine : document.getElementById('addProductLineComboId').value,
	         vehicleReporting :vehicleReporting,
	         date : date		        	
	        },
	        success: function(result) {
	            vehicleList = JSON.parse(result);
	            for (var i = 0; i < vehicleList["clientVehicles"].length; i++) {
                    $('#addvehicleDropDownID').append($("<option></option>").attr("value", vehicleList["clientVehicles"][i].vehicleName).text(vehicleList["clientVehicles"][i].vehicleName));
	            }
	            $('#addvehicleDropDownID').select2();
	            
	            
	             vehicleStoreWithTypeAndModel.load({
             	params:{
					productLine : document.getElementById('addProductLineComboId').value,
	         		vehicleReporting :vehicleReporting,
	         		date : date
        	
				},
                callback: function() {
                    setVehicleTypeAndModel();
                }
            });
	        }
	    });
	    if(humidity=='N')
	    {
		$('#humidity').hide();
		$('#humiditymin').hide();
		$('#humiditymax').hide();
		$('#humidityminId').hide();
		$('#humiditymaxId').hide();
	    }
		//alert(":::" + productLine);
		if(productLine == 'TCL' || productLine == 'Chiller' || productLine == 'Freezer')
		{
			document.getElementById("tempTableId").style.display = "block";		
			document.getElementById("tempConfigTableId").style.display = "block";	
		}
		else
		{
			document.getElementById("tempTableId").style.display = "none";		
			document.getElementById("tempConfigTableId").style.display = "none";	
		}
		
	}
	
<!--		function VehicleReportingDateChange()-->
<!--	{-->
<!--	-->
<!--		var date = document.getElementById('adddateTimeInput').value;-->
<!--		//loadCustomerAndVehicle();-->
<!--		$("#addvehicleDropDownID").empty().select2();-->
<!--		$.ajax({-->
<!--	        url: '<%=request.getContextPath()%>/TripCreatAction.do?param=getvehiclesForVehicleReporting',-->
<!--	        data: {-->
<!--	         	    vehicleReporting :vehicleReporting,-->
<!--	         		date : date		        	-->
<!--	        },-->
<!--	        success: function(result) {-->
<!--	            vehicleList = JSON.parse(result);-->
<!--	            for (var i = 0; i < vehicleList["clientVehicles"].length; i++) {-->
<!--                    $('#addvehicleDropDownID').append($("<option></option>").attr("value", vehicleList["clientVehicles"][i].vehicleName).text(vehicleList["clientVehicles"][i].vehicleName));-->
<!--	            }-->
<!--	            $('#addvehicleDropDownID').select2();-->
<!--	        }-->
<!--	    });-->
<!--		//alert(":::" + productLine);-->
<!--		-->
<!--	}-->

	function openVehicleReportPage(){
		window.location.href = "<%=request.getContextPath()%>/Jsps/DistributionLogistics/VehicleReporting.jsp?hubId=<%=hubId%>";
	}

	function plotLegDetails(){
		$("#legTableId").empty();
		recordsCount = 0;
		var routeId = $('#addrouteDropDownID option:selected').attr("value");
		if(materialClient == 'Y'){
			 routeId= $('#routeTemplateDropDownID option:selected').attr("routeId");
		}
		
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
	function setSTAandSTD() {
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
				for(var i = 0; i < legDetails["legDetailsRoot"].length; i++){
					var source = legDetails["legDetailsRoot"][i].source;
					var destination = legDetails["legDetailsRoot"][i].destination;
					var sta = legDetails["legDetailsRoot"][i].sta;
				var std = legDetails["legDetailsRoot"][i].std;
					count = i+1;
					
					$('#stdId'+count).text(std);
					$('#staId'+count).text(sta);
				}
			}
		});
	}
	
	function setSTAandSTDonModify() {
		$.ajax({
	        url: '<%=request.getContextPath()%>/TripCreatAction.do?param=getLegDetails',
	        data: {
	        	routeId : globalRouteId,
	        	date : document.getElementById('dateTimeInput').value+":00"
	        },
	        success: function(result) {
	            var legDetails = JSON.parse(result);
				var count;
				for(var i = 0; i < legDetails["legDetailsRoot"].length; i++){
					var source = legDetails["legDetailsRoot"][i].source;
					var destination = legDetails["legDetailsRoot"][i].destination;
					var sta = legDetails["legDetailsRoot"][i].sta;
					var std = legDetails["legDetailsRoot"][i].std;
					count = i+1;
					
					$('#stdIdm'+count).text(std);
					$('#staIdm'+count).text(sta);
				}
			}
		});
	}
	var productLine;
	if(materialClient == 'Y'){
		productLine='Dry';
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
		$("#addvehicleDropDownID").empty().select2();		
		$.ajax({
	        url: '<%=request.getContextPath()%>/TripCreatAction.do?param=getvehiclesandgroupforclients',
	        data: {
	         productLine : document.getElementById('addProductLineComboId').value,
	         vehicleReporting :vehicleReporting,
	         date : date
        	
	        },
	        success: function(result) {
	            vehicleList = JSON.parse(result);
	            for (var i = 0; i < vehicleList["clientVehicles"].length; i++) {
                    $('#addvehicleDropDownID').append($("<option></option>").attr("value", vehicleList["clientVehicles"][i].vehicleName).text(vehicleList["clientVehicles"][i].vehicleName));
	            }
	            $('#addvehicleDropDownID').select2();
	        }
	    });
	}
	
	
	    $('#addvehicleDropDownID').change(function() {
	    	
            setVehicleTypeAndModel();
            $("#temperatureTableId").empty();
            $("#temperatureEvents").empty();
            var currentProductLine = document.getElementById('addProductLineComboId').value;
		            if(currentProductLine == "TCL" || currentProductLine == "Chiller" || currentProductLine == "Freezer"){
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
					            		minPositiveTemp = minNegativeTemp = maxPositiveTemp = maxNegativeTemp = "";
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
					            for (var i = 0; i < beanList["tempConfigurationsByVehicleNoDetails"].length ; i++) {
					           	 var tempName = beanList["tempConfigurationsByVehicleNoDetails"][i].name;
					           	 tempSensorNames.push(beanList["tempConfigurationsByVehicleNoDetails"][i].sensorName);
							 		if(i == 0){
							  			$("#temperatureEvents").append("Temperature Events<br>");
							 		}
							 		if(tempName.includes('reefer')){
									 $("#temperatureEvents").append(
									 "<td><input  type='checkbox' id="+beanList["tempConfigurationsByVehicleNoDetails"][i].sensorName+" checked> </td> <td><span style='margin-left : 1px;margin-right : 8px;'>"+tempName+" </span> </td> ");
									}else{
								    	$("#temperatureEvents").append(								     
									 	"<td><input  type='checkbox' id="+beanList["tempConfigurationsByVehicleNoDetails"][i].sensorName+"> </td> <td><span style='margin-left : 1px;margin-right : 8px;'>"+tempName+" </span> </td> ");
					            	}
					            }

					             if(temp=='N')
									 {
									 var fields = document.getElementById("temperatureTableId").getElementsByTagName('*');
										for(var i = 0; i < fields.length; i++)
										{
										    fields[i].disabled = true;
										}
									 }
					            }else{
					            sweetAlert("No temperatures found for selected vehicle");
					            checkProduct();
					            }
								    
					        }
					    });
			    }
         });
    
    
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
    
    
	
	var vehicleStoreWithTypeAndModel = new Ext.data.JsonStore({
         url: '<%=request.getContextPath()%>/TripCreatAction.do?param=getvehiclesandgroupforclients',
        id: 'vehicleStoreWithTypel',
        root: 'clientVehicles',
        autoLoad: false,
        remoteSort: true,
        fields: ['vehicleName', 'vehicleType', 'vehicleModel']
    });
		
	function loadData(){
		$("#addrouteDropDownID").empty().select2();
		$.ajax({
	        url: '<%=request.getContextPath()%>/TripCreatAction.do?param=getRouteNames',
	        data: {
	        	custId : $('#addcustNameDownID option:selected').attr("value"),
	        	legConcept:'<%=legConcept%>',
	        	hubAssociatedRoutes : hubAssociatedRoutes
	  
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
		$("#addProductLineComboId").empty().select2();
		$.ajax({
	        url: '<%=request.getContextPath()%>/TripCreatAction.do?param=getProductLine',
	        data: {
	        	custId : $('#addcustNameDownID option:selected').attr("value")
	        },
	        success: function(result) {
	             var productLineStore = JSON.parse(result);
	            for (var i = 0; i < productLineStore["productLineRoot"].length; i++) {
                    $('#addProductLineComboId').append($("<option></option>").attr("value", productLineStore["productLineRoot"][i].productname)
                    .text( productLineStore["productLineRoot"][i].productname));                   
	            }
	            $('#addProductLineComboId').select2();
	           	            
	        }    
				
		});
		
		 var date = document.getElementById('adddateTimeInput').value;
		 vehicleStoreWithTypeAndModel.load({
			
             	params:{
					productLine : document.getElementById('addProductLineComboId').value,
	         		vehicleReporting :vehicleReporting,
	         		date : date
        	
				},
                callback: function() {
                    setVehicleTypeAndModel();
                }
            });
	}
	function closeTrip(){ 
	    var remarksData = "";
	    if (status == 'OPEN') {
		    if (document.getElementById("atpDateTimeClsoure").value.trim().length == 0) {
		        sweetAlert("Please Enter ATP");
		        document.getElementById("atpDateTimeClsoure").value = "";
		        return;
		    }
		    if (document.getElementById("atdDateTimeClsoure").value.trim().length == 0) {
		        sweetAlert("Please Enter ATD");
		        document.getElementById("atdDateTimeClsoure").value = "";
		        return;
		    }
		    if (getDateObject(document.getElementById("atpDateTimeClsoure").value) > getDateObject(document.getElementById("atdDateTimeClsoure").value)) {
		        sweetAlert("ATD cannot be less than ATP");
		        return;
		    }
		    //if('<%=userAuthority%>' != 'ProdOwn' && '<%=userAuthority%>' != 'T4u Users'){
if(!isValid){
		    	if(!globalDisableATP){
		    		var atpDifference = gettimediff(getDateObject(globalSTPClose),getDateObject(document.getElementById("atpDateTimeClsoure").value.trim()));
					if(parseInt(atpDifference) < parseInt(-(<%=atpContraint%>)) || parseInt(atpDifference) > parseInt(<%=atpContraint%>)){
						sweetAlert("ATP should be within "+<%=atpContraint%>+" hr from STP");
						return;
					}
		    	}
				
				if(!globalDisableATD){
					var atdDifference = gettimediff(getDateObject(document.getElementById("atpDateTimeClsoure").value.trim()),getDateObject(document.getElementById("atdDateTimeClsoure").value.trim()));
					if(parseInt(atdDifference) < parseInt(-(<%=atdContraint%>)) || parseInt(atdDifference) > parseInt(<%=atdContraint%>)){
						sweetAlert("ATD should be within "+<%=atdContraint%>+" hr of ATP");
						return;
					}
				}
			}
		    if (document.getElementById("ataDateTimeInput").value.trim().length == 0) {
		        sweetAlert("Please Enter ATA");
		        document.getElementById("ataDateTimeInput").value = "";
		        return;
		    }
		    if (getDateObject(document.getElementById("atdDateTimeClsoure").value) > getDateObject(document.getElementById("ataDateTimeInput").value)) {
		        sweetAlert("ATA cannot be less than ATD");
		        return;
		    }
		    
		    //ataDateTimeInput > tripEndDateTimeInput
		     if (getDateObject(document.getElementById("ataDateTimeInput").value) > getDateObject(document.getElementById("tripEndDateTimeInput").value)) {
		        sweetAlert("Trip end time can not be before ATA");
		        return;
		    }
		    var atpChanged = false;
		    var atdChanged = false;
		    var ataChanged = false;
		    
		    if(globalATPClose != document.getElementById("atpDateTimeClsoure").value){
		    	atpChanged = true
		    }
		    if(globalATDClose != document.getElementById("atdDateTimeClsoure").value){
		    	atdChanged = true
		    }
		    if(globalATAClose != document.getElementById("ataDateTimeInput").value){
		    	ataChanged = true
		    	checkATAisValid(tripId,document.getElementById("ataDateTimeInput").value);
		    }
		}
		var remarksDetails = document.getElementById("remarksCloseId").value;	
	    if(remarksDetails.trim().length==0){
			sweetAlert("Please Enter Remarks");
			document.getElementById("remarksCloseId").value="";		
    		return;	
		}
		var ata = document.getElementById("ataDateTimeInput").value;
		
		document.getElementById("close"+uniqueId).disabled=true;
		$.ajax({
	        url: '<%=request.getContextPath()%>/TripCreatAction.do?param=closeTrip',
	        data: {
	        	uniqueId,
	        	vehicleNo:globalVehicleSelected,
	        	remarksData: remarksDetails,
	        	ata:ata,
	        	destinationArrived:destinationArrived,
	        	shipmentId: globalShipmentId,
	        	status : status,
	        	lrNo : globalLRNo,
	        	atp: document.getElementById("atpDateTimeClsoure").value,
	        	atd : document.getElementById("atdDateTimeClsoure").value,
	        	atpChanged : atpChanged,
	        	atdChanged : atdChanged,
	        	ataChanged : ataChanged
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
	function getDateDifference (d1,d2){
		return timeDiff = d2.getTime() - d1.getTime();
		 
	}
	function saveRouteChange(){
		var newRouteId = $('#changeRouteId option:selected').attr("value");
		var routeNameNew = $('#changeRouteId option:selected').text(); 
		$.ajax({
	        url: '<%=request.getContextPath()%>/TripCreatAction.do?param=changeRoute',
	        data: {
	        	tripId : uniqueId,
	        	oldRouteId : globalRouteId,
	        	tripCustId : globalTripCustId,
	        	newRouteId : newRouteId,
	        	routeName : routeNameNew
	        },
	        success: function(result) {
                	setTimeout(function(){
                    	getData();
                    }, 1000);
            		sweetAlert(result);
            		$('#chengeRoute').modal('hide');
	            }
		});
	}
	$("#checkboxAll").click(function() {
	 	if( $(this).is(':checked') ){
			document.getElementById("checkbox1").checked = true;
			document.getElementById("checkbox2").checked = true;
			document.getElementById("checkbox3").checked = true;
			document.getElementById("checkbox4").checked = true;
			document.getElementById("checkbox5").checked = true;
			document.getElementById("checkbox6").checked = true;
			document.getElementById("checkbox7").checked = true;
			document.getElementById("checkbox8").checked = true;
			document.getElementById("checkbox9").checked = true;
			document.getElementById("checkbox10").checked = true;
			document.getElementById("checkbox11").checked = true;
			document.getElementById("checkbox12").checked = true;
			document.getElementById("checkbox13").checked = true;
			document.getElementById("checkbox14").checked = true;
			document.getElementById("checkbox15").checked = true;
			document.getElementById("checkbox16").checked = true;
	   }else{
	        document.getElementById("checkbox1").checked = false;
			document.getElementById("checkbox2").checked = false;
			document.getElementById("checkbox3").checked = false;
			document.getElementById("checkbox4").checked = false;
			document.getElementById("checkbox5").checked = false;
			document.getElementById("checkbox6").checked = false;
			document.getElementById("checkbox7").checked = false;
			document.getElementById("checkbox8").checked = false;
			document.getElementById("checkbox9").checked = false;
			document.getElementById("checkbox10").checked = false;
			document.getElementById("checkbox11").checked = false;
			document.getElementById("checkbox12").checked = false;
			document.getElementById("checkbox13").checked = false;
			document.getElementById("checkbox14").checked = false; // new changes last three from  true to false
			document.getElementById("checkbox15").checked = false;
			document.getElementById("checkbox16").checked = false;
	  }
	});
  
	function changeFun(count)
	{
   		for(var i = 1; i <= recordsCount; i++){
   			if(document.getElementById('driverId1'+i).value != '' && document.getElementById('driverId2'+i).value != ''){
   				if(document.getElementById('driverId1'+i).value == document.getElementById('driverId2'+i).value){
   					sweetAlert("Leg "+i+" has same drivers");   				   			
   				}   		   		
   			}   			
   		}    
   	}
   	function changeFunModify(count)
   	{
   	   for(var i = 1; i <= modiFyCount; i++){
	   		if(document.getElementById('driverIdm1'+i).value != '' && document.getElementById('driverIdm2'+i).value != ''){
	   			if(document.getElementById('driverIdm1'+i).value == document.getElementById('driverIdm2'+i).value){
	   				sweetAlert("Leg "+i+" has same drivers");
	   				//$("#driverIdm2 option[value='']" +i).attr('selected', true);
	   				$('#driverIdm2'+count).reset().select2();
	   			}
	   		}	    	
	    }
   	}
   		
   	function checkboxValidation()
   	{	   		   		
   		if(document.getElementById("checkSelected").checked == true)
   		{
   			var data1 = "";
   			var data2 = "";
   			var checkSelected = true;   			   			
   			if(checkSelected)
   			{
   				if(document.getElementById('driverId11').value == "")
				{
   					sweetAlert("Please Select Driver1 for Leg1");
   					document.getElementById("checkSelected").checked = false;
   				} 
   				else
   				{
					for(var i = 1; i <= recordsCount; i++){
   						data1 = document.getElementById('driverId11').value;
   						data2 = document.getElementById('driverId21').value;
   						$('#driverId1'+i).val(data1).trigger('change');
						$('#driverId2'+i).val(data2).trigger('change');
   						}	   							   			   					
   				}      					   							   			
   			}     		   			
   		}
   		//else
   		//{
   			//sweetAlert("Drivers for Leg 1 are already selected");
   			//document.getElementById("checkSelected").checked = true;   			
   		//}   			 			   		
   	}   
   	
   	function swapVehicle(uniqueId){
   		var date = document.getElementById('adddateTimeInput').value;
   	
   		$("#newSwappedVehicleId").empty().select2();
		$.ajax({
	        url: '<%=request.getContextPath()%>/TripCreatAction.do?param=getvehiclesandgroupforclients',
	        data: {
	         productLine : document.getElementById('addProductLineComboId').value,
	         vehicleReporting :vehicleReporting,
	         date : date
	        },
	        success: function(result) {
	            vehicleList = JSON.parse(result);
	            for (var i = 0; i < vehicleList["clientVehicles"].length; i++) {
                    $('#newSwappedVehicleId').append($("<option></option>").attr("value", vehicleList["clientVehicles"][i].vehicleName).text(vehicleList["clientVehicles"][i].vehicleName));
	            }
	            $('#newSwappedVehicleId').select2();
	        }
	    });
   		$('#swapVehicleModal').modal('show');
   	}  	
   	
   function	saveVehicleSwap(){
   		var newVehicleNo = $('#newSwappedVehicleId option:selected').attr("value");
   		var oldVehicleNo = document.getElementById('oldSwappedVehicleId').value;
   		var vehicleSwapRemarks = document.getElementById('vehicleSwapRemarks').value;
   		if(newVehicleNo == "" || newVehicleNo == "-- select vehicle number --"){
    		sweetAlert("Please select the new Vehicle");
    		return;
    	}
   		
   		$.ajax({
	        url: '<%=request.getContextPath()%>/TripCreatAction.do?param=saveSwappedVehicleDetails',
	        data: {
	        	tripId : uniqueId,
	        	oldVehicleNo : oldVehicleNo,
	        	newVehicleNo : newVehicleNo,
	        	vehicleSwapRemarks : vehicleSwapRemarks,
	        },
	        success: function(result) {
            		sweetAlert(result);
            		getData()
            		$('#swapVehicleModal').modal('hide');
            		$('#swapVehicleCustId').val("");
        			$('#oldSwappedVehicleId').val("");
        			$('#swapVehiclecustrefID').val("");
		       		$('#swapVehicleorderId').val("");
		       		$('#swapVehiclerouteDropDownID').val("");
		        	$('#swapVehicledateTimeInput').val("");
		        	$('#swapVehicleProductLineComboId').val("");
		        	$('#vehicleSwapRemarks').val("");
		        	
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
   
   function checkProductModify()
	{
		$("#modTemperatureTableId").empty();
		$("#modTemperatureEvents").empty();
		modTemperaturesArray = [];
		modtemperatureCounter = 0;
	
		var productLine = document.getElementById('modifyProductLineComboId').value;		
		
		
		if(productLine != 'TCL' && productLine != 'Chiller' && productLine != 'Freezer'){ 
			$('#preloadTempModifyId').hide();
			$('#pleLoadTempLblId').hide();
			$("#modTemperatureTableId").empty();
			$("#modTemperatureEvents").empty();
		}else{
			$('#preloadTempModifyId').show();
			$('#pleLoadTempLblId').show();
		}
		
		var date = document.getElementById('dateTimeInput').value;	
		
		if (productLine == 'TCL' || productLine == 'Chiller' || productLine == 'Freezer'){
			document.getElementById("modTempConfigTableId").style.display = "block";		
			document.getElementById("modTemperatureTableId").style.display = "block";	
		}else{
			document.getElementById("modTempConfigTableId").style.display = "none";		
			document.getElementById("modTemperatureTableId").style.display = "none";	
		}	
		$("#modifyvehicleDropDownID").empty().select2();
		$.ajax({
	        url: '<%=request.getContextPath()%>/TripCreatAction.do?param=getvehiclesandgroupforclients',
	        data: {
	         productLine : document.getElementById('modifyProductLineComboId').value,
	         vehicleReporting :vehicleReporting,
	         date : date		        	
	        },
	          success: function(result) {
	        	$("#modifyvehicleDropDownID").empty().select2();
	        	//$('#modifyvehicleDropDownID').append($("<option></option>").attr("value", globalVehicleSelected).text(globalVehicleSelected));
	            vehicleList = JSON.parse(result);
	            var found = false;
	            for (var i = 0; i < vehicleList["clientVehicles"].length; i++) {
	             if(vehicleList["clientVehicles"][i].vehicleName === globalVehicleSelected){
       				 found = true;
       				 }
                    $('#modifyvehicleDropDownID').append($("<option></option>").attr("value", vehicleList["clientVehicles"][i].vehicleName).text(vehicleList["clientVehicles"][i].vehicleName));
	            }
	            if(!found){
                     $('#modifyvehicleDropDownID').append($("<option></option>").attr("value", globalVehicleSelected).text(globalVehicleSelected));
                }
	            $('#modifyvehicleDropDownID').select2();
	            if (globalProductLineSelected == productLine){
	             $('#modifyvehicleDropDownID').val(globalVehicleSelected).trigger('change');
	            }
	           
	           
	        }
	    });
	}
	
		function plotLegDetailsModificationOnRouteChange(){
		
		routeChangedCount++;
		
		var routeId = $('#modifyrouteDropDownID option:selected').attr("value");
		//if(materialClient == 'Y'){
		//	 routeId= $('#modifyrouteDropDownID option:selected').attr("routeId");
		//}
	//	console.log("routeChangedCount :: "+routeChangedCount);
		if (parseInt(routeChangedCount) == 1){
		return;
		}
		if (routeChangedCount == 1){
		return;
		}
		
		$("#modifyLegTableId").empty();
		$.ajax({
	        url: '<%=request.getContextPath()%>/TripCreatAction.do?param=getLegDetails',
	        data: {
	        	routeId : routeId,
	        	date : document.getElementById('dateTimeInput').value+":00"
	        },
	        success: function(result) {
	            var legDetails = JSON.parse(result);
				var count;
				modiFyCount = legDetails["legDetailsRoot"].length;
				if(legDetails["legDetailsRoot"].length > 0){
					document.getElementById("modifyTabelId").style.display = "block";
					for(var i = 0; i < legDetails["legDetailsRoot"].length; i++){
						var source = legDetails["legDetailsRoot"][i].source;
						var destination = legDetails["legDetailsRoot"][i].destination;
						var sta = legDetails["legDetailsRoot"][i].sta;
						var std = legDetails["legDetailsRoot"][i].std;
						var name = legDetails["legDetailsRoot"][i].name;
						var legId = legDetails["legDetailsRoot"][i].legId;
						count = i+1;
						$("#modifyLegTableId").append("<tr><td style='font-weight:700;'>"+ count +". </td> <td style='display:none;' id=legIdm"+count+">"+legId+"</td> <td>"+name+"</td> <td>"+source+"</td>"+
						" <td>"+destination+"</td> <td id=stdIdm"+count+">"+std+"</td> <td id=staIdm"+count+">"+sta+"</td>"+
						" <td><select class=comboClassDriver id=driverIdm1"+count+" data-live-search=true onchange='changeFunModify("+count+")' required=required ></select></td> "+
				 		" <td><select class=comboClassDriver id=driverIdm2"+count+" data-live-search=true onchange='changeFunModify("+count+")' required=required ></select></td></tr>");
						
					}
				}else{
					document.getElementById("modifyTabelId").style.display = "none";
				}
			}
		});
		setTimeout( function() {
			$.ajax({
	      		url: '<%=request.getContextPath()%>/TripCreatAction.do?param=getDriverList',
	      		success: function(result) {
	           		driverList = JSON.parse(result);
	           		for(var rec = 1; rec <= modiFyCount; rec++){
	           		for (var j = 0; j < driverList["driverDetailsRoot"].length; j++) {
	                  	$('#driverIdm1'+rec).append($("<option></option>").attr("value", driverList["driverDetailsRoot"][j].driverId).text(driverList["driverDetailsRoot"][j].driverName));
	                  	$('#driverIdm2'+rec).append($("<option></option>").attr("value", driverList["driverDetailsRoot"][j].driverId).text(driverList["driverDetailsRoot"][j].driverName));
	           		}
	           		$('#driverIdm1'+rec).select2();
		            $('#driverIdm2'+rec).select2();
		           } 		
	      		}
			});
		},1000);
	}
	
	
	function getTripCancellationRemarks(){
	
	 //if('<%=userAuthority%>' != 'ProdOwn' && '<%=userAuthority%>' != 'T4u Users'){
if(!isValid){
			sweetAlert("Only ProdOwn users have this authority");
			return;
	}
	
	$('#cancelModal').modal('show');
	$('#showRemarksId').hide();
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
	
	  $('#modifyvehicleDropDownID').change(function() {
	  var myUrl = "";
	  var param = "";
	  var jsptripId = "";
	  var currentProductLineMod = document.getElementById('modifyProductLineComboId').value;
	  if ((globalVehicleSelected == document.getElementById('modifyvehicleDropDownID').value) ){
	     jsptripId = uniqueId;
	  	myUrl = '<%=request.getContextPath()%>/TripCreatAction.do?param=getExistingTempConfigurations';
	  	 param = {
		  	 tripId: uniqueId,
		     vehicleNo: globalVehicleSelected,
	        
	    };
	  }else{
	   jsptripId = 0;
	  	myUrl = '<%=request.getContextPath()%>/TripCreatAction.do?param=getTempConfigurationsByVehicleNo';
	  	param = {
		        productLine : currentProductLineMod,
		        vehicleNo: document.getElementById('modifyvehicleDropDownID').value,
	    	};
	  }
           $("#modTemperatureTableId").empty();
           $("#modTemperatureEvents").empty();
            
		            if(currentProductLineMod == "TCL" || currentProductLineMod == "Chiller" || currentProductLineMod == "Freezer"){
				           $.ajax({
					        url: myUrl,
					        data: param,
					        success: function(result) {
					        	modtemperatureCounter = 0;
					            beanList = JSON.parse(result);
					         //   console.log("asdf : "+beanList["tempConfigurationsByVehicleNoDetails"].length);
					            if (beanList["tempConfigurationsByVehicleNoDetails"].length > 0){
					            
					           
					            for (var i = 0; i < 1; i++) {
					         //    console.log(beanList["tempConfigurationsByVehicleNoDetails"][i]);
					             modtemperatureCounter++;
					            		minPositiveTemp = minNegativeTemp = maxPositiveTemp = maxNegativeTemp = "";
					            		var name1 =  beanList["tempConfigurationsByVehicleNoDetails"][i].name ;
									 minPositiveTemp = beanList["tempConfigurationsByVehicleNoDetails"][i].minPositiveTemp;
								     minNegativeTemp = beanList["tempConfigurationsByVehicleNoDetails"][i].minNegativeTemp;
								     maxPositiveTemp = beanList["tempConfigurationsByVehicleNoDetails"][i].maxPositiveTemp;
								     maxNegativeTemp = beanList["tempConfigurationsByVehicleNoDetails"][i].maxNegativeTemp;
								     var sensor = beanList["tempConfigurationsByVehicleNoDetails"][i].sensorName;
								     $("#modTemperatureTableId").append(
								     "<tr><th> Temperature Settings </th></tr>"+
								     " <td><input value = -70  type=text class='colorbox' style='color:black' disabled /></td> "+
								     " <td width = 10% ><input class='colorbox' style='background-color: red;' value='Critical' disabled></td><td width = 10%  id=temperatureColumns><input class='mybox' id=exm2"+i+" value = "+minNegativeTemp+"  type=text style=text-align:center; onkeypress='return checkTemperature(event)' onchange = 'checkTemperature1(this.id,this.value)'  required /></td>"+
								     " <td width = 10% ><input class='colorbox' style='background-color: yellow; color:black' value='Abnormal' disabled ></td><td width = 10%  id=temperatureColumns><input class='mybox' id=exm3"+i+" value = "+maxNegativeTemp+"  type=text style=text-align:center; onkeypress='return checkTemperature(event)' onchange = 'checkTemperature1(this.id,this.value)' required /></td>"+
								     " <td width = 10% ><input class='colorbox' style='background-color: green;' value='Normal' disabled ></td><td width = 10%  id=temperatureColumns><input class='mybox' id=exm4"+i+" value = "+minPositiveTemp+"  type=text style=text-align:center; onkeypress='return checkTemperature(event)' onchange = 'checkTemperature1(this.id,this.value)' required /></td>"+
									 " <td width = 10% ><input class='colorbox' style='background-color: yellow; color:black' value='Abnormal' disabled ></td><td width = 10%  id=temperatureColumns><input class='mybox' id=exm5"+i+" value = "+maxPositiveTemp+"  type=text  style=text-align:center; onkeypress= 'return checkTemperature(event)' onchange = 'checkTemperature1(this.id,this.value)' required /></td> "+
									 " <td width = 10% ><input class='colorbox' style='background-color: red;' value='Critical' disabled ></td> " +
                                     " <td><input value = 70  class='colorbox' style='color:black' disabled /></td> "+
									" <td width = 10% style=display:none;  id=temperatureColumns> "+
									" <input class='mybox' id=exm6"+i+" value = "+sensor+"  type=text  style=text-align:center;  required /></td>	 </tr>");
					            }
					            tempSensorNames = [];
					            for (var i = 0; i < beanList["tempConfigurationsByVehicleNoDetails"].length ; i++) {
					           	 var tempName = beanList["tempConfigurationsByVehicleNoDetails"][i].name;
					           	 tempSensorNames.push(beanList["tempConfigurationsByVehicleNoDetails"][i].sensorName);
							 		if(i == 0){
							  			$("#modTemperatureEvents").append("<br>Temperature Events<br>");
							 			}
					           	 	if( beanList["tempConfigurationsByVehicleNoDetails"][i].triggerAlert == 'Y'){
								    	$("#modTemperatureEvents").append(								     
									 		"<td><input  type='checkbox' id="+beanList["tempConfigurationsByVehicleNoDetails"][i].sensorName+" checked> </td> <td><span style='margin-left : 1px;margin-right : 8px;'>"+tempName+" </span> </td> ");
					            	}else{
								    $("#modTemperatureEvents").append(								     
									 "<td><input  type='checkbox' id="+beanList["tempConfigurationsByVehicleNoDetails"][i].sensorName+"> </td> <td><span style='margin-left : 1px;margin-right : 8px;'>"+tempName+" </span> </td> ");					            	
					            	}
					            }

					             if(temp=='N')
									 {
									 var fields = document.getElementById("modTemperatureTableId").getElementsByTagName('*');
										for(var i = 0; i < fields.length; i++)
										{
										    fields[i].disabled = true;
										}
									 }
					            }else{
					            sweetAlert("No temperatures found for selected vehicle");
					            checkProductModify();
					            }
								    
					        }
					    });
			    }else{
			    	modtemperatureCounter = 0;
			    	modTemperaturesArray = [];
			    }
         });
         
         $('#tripCancellationRemarks').change(function() {
	         if ($('#tripCancellationRemarks').val()=='Others'){
	         	$('#showRemarksId').show();
	         }else{
	         	$('#showRemarksId').hide();
	         }
         });
         
         function loadTripDetails(){
				$('#closeModal').modal('show');
         }
         var rows=[];
         function loadAjaxForEnvelop(){
         	var startDate=document.getElementById("dateInput1").value;
	    	startDate=startDate.split("/").reverse().join("-");
	    	var endDate=document.getElementById("dateInput2").value;
	    	endDate=endDate.split("/").reverse().join("-");
			$.ajax({
				type: "POST",
				url: '<%=request.getContextPath()%>/TripCreatAction.do?param=getTripsWhoseActualsAreEmpty',
				data : {
				userAuthority : isValid,
				startDate : startDate,
				endDate : endDate
				},
				success: function(result) {
					rows = [];
					result = JSON.parse(result).getTripsWhoseActualsAreEmptyRoot;
					//if('<%=userAuthority%>' == 'ProdOwn' || '<%=userAuthority%>' == 'T4u Users'){
					if(isValid){
						$('#countenvelope').text('');
					}else{
						$('#countenvelope').text(result.length);
					}
					
					if(result == ""){
					return;
					}
					if(result !=""){
							$.each(result, function(i, item) {
							var row = { 
							"0" : item.slNo,
							"1" : item.tripId,
							"2" : item.orderId,
							"3" : item.vehicleNumber,
							"4" : item.ATP.replace("#"," "),
							"5" : item.ATD.replace("#"," "),
							"6" : item.ATA.replace("#"," "),
							"7" : item.TripEndTime.replace("#"," "),
							"8" : item.button
							}
							rows.push(row);
						});
					}else{
						var row = { 
							"0" : "No Data available"
						}
					}
				}
			});
         }
         
         function openUpdateActualsModal(){
         	//if('<%=userAuthority%>' == 'ProdOwn' || '<%=userAuthority%>' == 'T4u Users'){
         	if(isValid){
				loadAjaxForEnvelop();
			}
         	$('#updateActualsModal').modal('show');
			if ($.fn.DataTable.isDataTable('#actualUpdateTable')) {
				$('#actualUpdateTable').DataTable().clear().destroy();
			}
			ATAVehTable = $('#actualUpdateTable').DataTable({
				"scrollY": "280px",
				//  "scrollX": true,
				paging : true,
				"serverSide": false,
				"oLanguage": {
				"sEmptyTable": "No data available"
				},
				"processing": true
			});
			setTimeout(function(){
			ATAVehTable.rows.add(rows).draw();
			},800);
			
			ATAVehTable.columns( [1] ).visible( false );
         }
    var globalATPUpdateActual;
    var globalATDUpdateActual;
    var globalATAUpdateActual;
    var globalTripEndTimeActual;
	
	var globalATPUpdateActualDisable = false;
    var globalATDUpdateActualDisable = false;

	function loadActualDetailsOfClosedTrip(obj){
		globalATPUpdateActual = obj.ATP.replace("#"," ");
		globalATDUpdateActual = obj.ATD.replace("#"," ");
		globalATAUpdateActual = obj.ATA.replace("#"," ");
		globalTripEndTimeActual = obj.TripEndTime.replace("#"," ");
		 $('#updateATAModalName').html( "Update Actuals for : "+ obj.orderId);
		 $('#tripIdActualUpdate').val(obj.tripId);
		 $('#orderIdActualUpdate').val(obj.orderId);
		 $('#vehicelNoActualUpdate').val(obj.vehicleNumber);
		 $('#shipmentActualUpdate').val(obj.shipmentId);
		 $('#atpActualUpdateId').jqxDateTimeInput('setDate', obj.ATP.replace("#"," "));
		 $('#atdActualUpdateId').jqxDateTimeInput('setDate', obj.ATD.replace("#"," "));
		 $('#ataActualUpdteId').jqxDateTimeInput('setDate', obj.ATA.replace("#"," "));
		 $('#tripEndTimeActualUpdateId').jqxDateTimeInput('setDate', obj.TripEndTime.replace("#"," "));
		 
	 	if(document.getElementById("atpActualUpdateId").value.trim().length == 0){
	 		$("#atpActualUpdateId").jqxDateTimeInput({ disabled: false });
		 	globalATPUpdateActualDisable = false;
	 	}else{
			//if(obj.atpOrAtdOverridden != 0){
				 if(isValid){
			 	$("#atpActualUpdateId").jqxDateTimeInput({ disabled: false });
			 	globalATPUpdateActualDisable = false;
			 }else{
			 	$("#atpActualUpdateId").jqxDateTimeInput({ disabled: true });
			 	globalATPUpdateActualDisable = true;
			 }
		 }
		 if(document.getElementById("atdActualUpdateId").value.trim().length == 0){
		 	$("#atdActualUpdateId").jqxDateTimeInput({ disabled: false });
		 	globalATDUpdateActualDisable = false;
		 }else{
			 
			 if(isValid ){
			// if(obj.atpOrAtdOverridden != 0){
			 	$("#atdActualUpdateId").jqxDateTimeInput({ disabled: false });
			 	globalATDUpdateActualDisable = false;
			 }else{
			 	$("#atdActualUpdateId").jqxDateTimeInput({ disabled: true });
			 	globalATDUpdateActualDisable = false;
			 }
			// }
		 }
		 if(document.getElementById("ataActualUpdteId").value.trim().length == 0){
		 	$("#ataActualUpdteId").jqxDateTimeInput({ disabled: false });
		 }else{
			//if(obj.ataOverridden != 0){
				if(isValid){
			 	$("#ataActualUpdteId").jqxDateTimeInput({ disabled: false });
			 }else{
			 	$("#ataActualUpdteId").jqxDateTimeInput({ disabled: true });
			 }
		 }
		//if('<%=userAuthority%>' != 'ProdOwn' && '<%=userAuthority%>' != 'T4u Users'){
if(!isValid ){	
    
			 if(document.getElementById("tripEndTimeActualUpdateId").value.trim().length == 0){
			 	$("#tripEndTimeActualUpdateId").jqxDateTimeInput({ disabled: false });
			 }else{
			 	$("#tripEndTimeActualUpdateId").jqxDateTimeInput({ disabled: true });
			 }
 		}
		else{
			hasEditPermissionForEndTime ? $("#tripEndTimeActualUpdateId").jqxDateTimeInput({ disabled: false }):$("#tripEndTimeActualUpdateId").jqxDateTimeInput({ disabled: true });
		}
		 
		 $('#updateActualsFieldsModal').modal('show');
	}
 	function updateATA(){
 		 if (document.getElementById("atpActualUpdateId").value.trim().length == 0) {
		        sweetAlert("Please Enter ATP");
		        document.getElementById("atpActualUpdateId").value = "";
		        return;
		    }
		    if (document.getElementById("atdActualUpdateId").value.trim().length == 0) {
		        sweetAlert("Please Enter ATD");
		        document.getElementById("atdActualUpdateId").value = "";
		        return;
		    }
		    if (getDateObject(document.getElementById("atpActualUpdateId").value) > getDateObject(document.getElementById("atdActualUpdateId").value)) {
		        sweetAlert("ATD cannot be less than ATP");
		        return;
		    }
		    //if('<%=userAuthority%>' != 'ProdOwn' && '<%=userAuthority%>' != 'T4u Users'){
if(!isValid){
<!--			var atpDifference = gettimediff(getDateObject(stp),getDateObject(atp));-->
<!--			if(parseInt(atpDifference) < parseInt(-(<%=atpContraint%>)) || parseInt(atpDifference) > parseInt(<%=atpContraint%>)){-->
<!--				sweetAlert("ATP should be within "+<%=atpContraint%>+" hr from STP");-->
<!--				return;-->
<!--			}-->
				if(!globalATDUpdateActualDisable){
					var atdDifferenceUpdateActuals = gettimediff(getDateObject(document.getElementById("atpActualUpdateId").value.trim()),
						getDateObject(document.getElementById("atdActualUpdateId").value.trim()));
					if(parseInt(atdDifferenceUpdateActuals) < parseInt(-(<%=atdContraint%>)) || parseInt(atdDifferenceUpdateActuals) > parseInt(<%=atdContraint%>)){
						sweetAlert("ATD should be within "+<%=atdContraint%>+" hr of ATP");
						return;
					}					
				}
 			}
		    
		    if (document.getElementById("ataActualUpdteId").value.trim().length == 0) {
		        sweetAlert("Please Enter ATA");
		        document.getElementById("ataActualUpdteId").value = "";
		        return;
		    }
		    if (getDateObject(document.getElementById("atdActualUpdateId").value) > getDateObject(document.getElementById("ataActualUpdteId").value)) {
		        sweetAlert("ATA cannot be less than ATD");
		        return;
		    }
		    if (document.getElementById("tripEndTimeActualUpdateId").value.trim().length == 0) {
		        sweetAlert("Please Enter Trip End Time");
		        document.getElementById("tripEndTimeActualUpdateId").value = "";
		        return;
		    }
		    
		    if (getDateObject(document.getElementById("ataActualUpdteId").value) > getDateObject(document.getElementById("tripEndTimeActualUpdateId").value)) {
		        sweetAlert("Trip End Time cannot be less than ATA");
		        return;
		    }
		    var atpChanged = false;
		    var atdChanged = false;
		    var ataChanged = false;
		    var tripEndTimeChanged = false;
		    
		    if(globalATPUpdateActual != document.getElementById("atpActualUpdateId").value){
		    	atpChanged = true
		    }
		    if(globalATDUpdateActual != document.getElementById("atdActualUpdateId").value){
		    	atdChanged = true
		    }
		    if(globalATAUpdateActual != document.getElementById("ataActualUpdteId").value){
		    	ataChanged = true
		    	checkATAisValid(tripId,document.getElementById("ataActualUpdteId").value);
		    }
		    if(globalTripEndTimeActual != document.getElementById("tripEndTimeActualUpdateId").value){
		    	tripEndTimeChanged = true
		    }
		    if(!atpChanged & !atdChanged && !ataChanged && !tripEndTimeChanged){
		    	sweetAlert("At least one of field should be changed to proceed");
	        	return;
		    }
		    $.ajax({
	        url: '<%=request.getContextPath()%>/TripCreatAction.do?param=updateActuals',
	        data: {
	        	tripId : $('#tripIdActualUpdate').val(),
	        	vehicleNo: $('#vehicelNoActualUpdate').val(),
	        	ata: document.getElementById("ataActualUpdteId").value,
	        	status : "OPEN",
	        	atp: document.getElementById("atpActualUpdateId").value,
	        	atd : document.getElementById("atdActualUpdateId").value,
	        	tripEndTime : document.getElementById("tripEndTimeActualUpdateId").value,
	        	atpChanged : atpChanged,
	        	atdChanged : atdChanged,
	        	ataChanged : ataChanged,
	        	tripEndTimeChanged : tripEndTimeChanged
	        },
	        success: function(result) {
	       		$('#updateActualsFieldsModal').modal('hide');
                setTimeout(function(){
                	sweetAlert(result);
                    loadAjaxForEnvelop();
                    setTimeout(function(){
                    	openUpdateActualsModal();
                    },1000);
                }, 500);
            }
		});
 	}
 	setInterval(function(){
 		loadAjaxForEnvelop();
 	}, 30 * 60 * 1000);
    </script>
<jsp:include page="../Common/footer.jsp" />
<!-- </body>   -->
<!-- </html> -->
