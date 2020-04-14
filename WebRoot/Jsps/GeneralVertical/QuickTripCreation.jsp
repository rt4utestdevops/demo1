<%@ page language="java"
	import="java.util.*,t4u.functions.*,t4u.beans.*,t4u.common.*,t4u.GeneralVertical.*"
	pageEncoding="utf-8"%>
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
	 String latitudeLongitude = cf.getCoordinates(systemId);

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
	boolean canOverrideActuals =false;
	boolean isCanOverrideActualTimeUsers = false;
	//Check if the user has permission to override actual ATA, ATP,ATD
	if(canOverrideActualTimeUsers != null && !canOverrideActualTimeUsers.equals("")){
		isCanOverrideActualTimeUsers =  true;
		String[] userIds = canOverrideActualTimeUsers.split(",");
		if(Arrays.asList(userIds).contains(new Integer(userId).toString())){
			canOverrideActuals = true;
		}
	}

 	String GoogleApiKey = properties.getProperty("GoogleMapApiKeyen").trim();
 %>

 <jsp:include page="../Common/header.jsp" />


	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.datatables.net/1.10.16/css/dataTables.bootstrap.min.css">
    <link rel="stylesheet" href="https://ajax.googleapis.com/ajax/libs/jqueryui/1.11.1/themes/ui-darkness/jquery-ui.min.css" rel="stylesheet">
	<link rel="stylesheet" href="https://cdn.datatables.net/1.10.16/css/dataTables.bootstrap4.min.css">

<link rel="stylesheet" href="../../Main/sweetAlert/sweetalert.css">
    <script src="https://code.jquery.com/jquery-1.12.4.js"></script>
     <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script>
    <script src="https://cdn.datatables.net/1.10.16/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.datatables.net/1.10.16/js/dataTables.bootstrap.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
 <script src="../../Main/sweetAlert/sweetalert-dev.js"></script>
  <script src="https://malsup.github.io/jquery.form.js"></script>
  <script src="https://cdn.datatables.net/1.10.16/js/dataTables.bootstrap4.min.js"></script>




	<script src="https://www.jqwidgets.com/public/jqwidgets/jqx-all.js"></script>
	<script src="https://www.jqwidgets.com/public/jqwidgets/globalization/globalize.js"></script>
	<link rel="stylesheet" href="https://www.jqwidgets.com/public/jqwidgets/styles/jqx.base.css">
	<link rel="stylesheet" href="https://www.jqwidgets.com/public/jqwidgets/styles/jqx.energyblue.css">
	<link rel="stylesheet" href="https://www.jqwidgets.com/public/jqwidgets/styles/jqx.arctic.css">
	  <link href="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.6-rc.0/css/select2.min.css" rel="stylesheet" />
		  <script src="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.6-rc.0/js/select2.min.js"></script>


     <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-slider/10.0.0/css/bootstrap-slider.css" rel="stylesheet" />
     <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-slider/10.0.0/css/bootstrap-slider.min.css" rel="stylesheet" />
      <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-slider/10.0.0/bootstrap-slider.js"></script>
      <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-slider/10.0.0/bootstrap-slider.min.js"></script>

      <script src="https://cdn.datatables.net/buttons/1.5.1/js/dataTables.buttons.min.js"></script>
	<script src="https://cdn.datatables.net/buttons/1.5.1/js/buttons.flash.min.js"></script>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/jszip/3.1.3/jszip.min.js"></script>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.32/pdfmake.min.js"></script>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.32/vfs_fonts.js"></script>
	<script src="https://cdn.datatables.net/buttons/1.5.1/js/buttons.html5.min.js"></script>
	<script src="https://cdn.datatables.net/buttons/1.5.1/js/buttons.print.min.js"></script>
	<script src="https://use.fontawesome.com/releases/v5.0.9/js/all.js" integrity="sha384-8iPTk2s/jMVj81dnzb/iFR2sdA7u06vHJyyLlAd4snFpCl/SnyUjRrbdJsw1pGIl" crossorigin="anonymous"></script>


          <pack:script src="../../Main/adapter/ext/ext-base.js"></pack:script>
	  <pack:script src="../../Main/Js/ext-all-debug.js"></pack:script>

<!--  	<link rel="stylesheet" href="https://code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">-->


 <style>
  .modal-body {
    position: relative;
    max-height: 500px;
    padding: 15px;
}
.input-group[class*=col-] {
    float: left !important;
    padding-right: 0px;
    margin-left: -54px !important;
}
.comboClass{
   width: 200px;
   height: 25px;

}
.comboClass2{
   width: 200px;
   height: 25px;

}
.comboClassVeh{
   width: 200px;
   height: 25px;

}
.comboClassDriver{
   width: 150px;
   height: 25px;

}
label {
    display: inline-block;
    max-width: 100%;
    margin-bottom: 5px;
    font-weight: 500;
}
#emptyColumn{
	width: 20px;
}
#emptyColumn2{
 	width: 30px;
}
.dataTables_scroll
{
    overflow:auto;
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
    background-color: rgb(0,0,0); /* Fallback color */
    background-color: rgba(0,0,0,0.9); /* Black w/ opacity */
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

.imgclose:hover,
.imgclose:focus {
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

#temperatureColumns{
 	height:50px;
}
#slider slider-horizontal{
width: 100%;
}
.btn{
	font-size:13px;
}

#dateInput1{
    width: 120px !important;
    height: 25px;
}
#dateInput2{
    width: 120px !important;
    height: 25px;
}
 le>
 <style>

#btnReset:hover{
			border: 1px solid #F0AD4E;
}

#btnReset:click{
			border: 1px solid #F0AD4E;
}

#btnAddWaypoint, #btnAddWaypoint:hover, #btnAddWaypoint:click, , #btnAddWaypoint:active{
			border: 1px solid green !important;
}

#btnDestSave, #btnDestSave:hover, #btnDestSave:click{
			border: 1px solid green;
}


 .halfHeader{
	 padding: 5px 64px 5px 12px;
	 background: #37474F;
	 margin-left: -10px;
	 color: white;
 }

.redBorder{
	border:1px solid red !important;
}
 input[type=text], input[type=number], select{
	 height:24px !important;
	 border-radius: 4px;
	 border: 1px solid #AAAAAA;
 }


 hr {
	 margin-top:8px;
	 margin-bottom:8px;


 }
 .card {
							box-shadow:0 2px 10px 0 rgba(0,0,0,0.2),0 2px 20px 0 rgba(0,0,0,0.19);
							padding: 8px;
							margin-bottom:4px;
							border-radius:0px !important;
							}
							.cardSmall {
								box-shadow:0 4px 10px 0 rgba(0,0,0,0.2),0 4px 20px 0 rgba(0,0,0,0.19);
								transition: all 0.3s cubic-bezier(.25,.8,.25,1);


						 }

						 .quickTripHeader{
							 text-align: center;
							 width: 100%;
							 height: 28px;
							 padding: 4px;
							 background: #37474F;
							 color: white;
							 margin-bottom:4px;
						 }

						 .container{
							 margin-bottom:-40px !important;
						 }

						 .flex {
								 display:flex;
						 }
						 .left{
							 width:50%;
						 }

						 .right{
							 width:50%;
						 }

						 .middle{
							 width:25%
						 }

						 .rt{
							 width:25%;
						 }

						 .left50{width: 50%}
						 .right50{width:50%}

						 .redText {
							 color: red;
						 }
						 .greenText {
							 color: green;
						 }
						 .orangeText {
							 color: orange;
						 }

						 .waypointCancel{
							 position: absolute;
								top: -8px;
								right: 0px;
								border: 0px;
								background: white;
							  font-size: 16px;
    						padding: 0px;
						 }
						 						 .mybox{
					   width: 111px;
					    margin-left: 5px;
					}
					.colorbox{

					font-weight:  bold;
					text-align:  center;
					color:  white;
					width: 108px;
					}

 </style>
<!-- </head> -->

<!-- <body onload=getCustomer()>  -->

<div id="loading" style="position:absolute;width:100%;height:130vh;top:0;left:0;display:none;background:#dfdfdf;opacity:0.6;z-index:2;">
	<div style="position:absolute;top:40%;left:50%;z-index:3">
	<img src="../../Main/images/loading.gif" alt=""></div>
</div>
<div class="row" style="margin-top:-16px;">
	<div class="col-xs-12 col-md-12 col-lg-3" style="padding:0px 8px 0px 16px;">
		 <div class="quickTripHeader">QUICK TRIP PLANNER</div>
			<div class="card">

				<div style="display:flex;"><div style="width:50%">Customer Type:<span style="color:red;">*</span></div>
						<div style="width:50%"><select style="width:100%"  class="comboClass" id="addcustNameType" data-live-search="true" required="required"></select></div>
				</div>

				 <div style="display:flex;margin-top:8px;"><div style="width:50%">Customer Name:<span style="color:red">*</span></div>
						<div style="width:50%" id="addcustNameDownIDDiv"><select  style="width:100%" class="comboClass"  required id="addcustNameDownID" data-live-search="true" required="required"></select></div>
				</div>
			</div>

			<div class="card" id="routeDetailsDiv" style="display:none;">
				<div class="flex">
					<div class="left50">ROUTE DETAILS</div>
					<div class="right50"> <!--chooseExisting()-->
						<input type="radio" id="existingRoute" checked onclick="newExistingRouteOnClick()" value="existingRoute" name="newExistingRoute">&nbsp;&nbsp;Existing
						<input type="radio" id="newRoute" style="margin-left:8px;" onclick="newExistingRouteOnClick()"  value="newRoute" name="newExistingRoute">&nbsp;&nbsp;New
					</div>
				</div>
				<div id="existingRouteDropDownDiv" style="width:100%">
					 <hr style="width:100%;border-top: 1px solid #37474F;border-bottom:0px;margin-bottom:16px;"/>
					 <div >
						 <select  style="width:100%" class="comboClass"  required id="existingRouteDropDown" data-live-search="true" onchange="plotOnMap();plotLegDetails()"  required="required"></select>
					 </div>
					 <button id="btnFreezeTrip" class="btn btn-generate btn-md btn-primary btn-block" onclick="goToCreateTrip()"  style="background:#18519E;margin:8px 0px 0px 0px;" type="submit">
						 GO TO CREATE TRIP
					 </button>

			 </div>
			 <div id="newRouteDropDownDiv" style="display:none;">
				 <hr style="width:100%;border-top: 1px solid #37474F;border-bottom:0px;margin-bottom:16px;"/>
				 <div class="flex">
 					<div class="left50 greenText">ADD SOURCE</div>
 					<div class="right50"> <!--chooseExisting()-->
						<select style="width:100%;margin-bottom: 4px;"  class="comboClass" id="addSourceCombo" data-live-search="true" required="required">
							<option value="0">New</option>
							<option value="1">Existing</option>
							<option value="2">Generic New</option>
							<option value="3">Generic Existing</option>
						</select>
						<%-- <input type="radio" id="newSourceRadio" checked onclick="sourceRadioOnClick()" value="newSource" name="sourceRadio">&nbsp;&nbsp;New
						<input type="radio" id="existingSourceRadio" style="margin-left:8px;" onclick="sourceRadioOnClick()"  value="existingSource" name="sourceRadio">&nbsp;&nbsp;Existing --%>
 					</div>
 				</div>
				<div id="sourceSelectSpan" style="display:none;"><select class="form-control form-control-custom" style="width:100%;" id="sourceSelect" name="sourceSelect"></select></div>
				<div id="sourceSelectSpanGeneric" style="display:none;"><select class="form-control form-control-custom" style="width:100%;" id="sourceSelectGeneric" name="sourceSelect"></select></div>

				<div id="sourceDetentionDiv">
					<input type="text" style="width:100%;height:34px;" id="sourceInput" placeholder="Search Box Source"/>
					<div class="flex" id="sDetentionDiv">
						<div class="left" style="margin-top:8px">Detention (HH:mm):</div>
						<div class="right"><input type="text" style="width:98%;height:28px;margin:4px" id="sourceDetention"/></div>
				 </div>
				 <div class="flex" id="sRadiusDiv">
					 <div class="left" style="margin-top:4px">Radius (kms):</div>
					 <div class="right"><input type="number" style="width:98%;height:28px;margin:2px 4px" id="sourceRadius"/></div>
				 </div>
				</div>

				<div id="sourceDetentionDivGeneric" style="display:none;">
					<input type="text" style="width:100%;height:34px;" id="sourceInputGeneric" placeholder="Search Box Generic Source"/>
					<div class="flex" id="sDetentionDivGeneric">
						<div class="left" style="margin-top:8px">Detention (HH:mm):</div>
						<div class="right"><input type="text" style="width:98%;height:28px;margin:4px" id="sourceDetentionGeneric"/></div>
				 </div>
				 <div class="flex" id="sRadiusDivGeneric">
					 <div class="left" style="margin-top:4px">Radius (kms):</div>
					 <div class="right"><input type="number" style="width:98%;height:28px;margin:2px 4px" value="30" id="sourceRadiusGeneric"/></div>
				 </div>
				</div>
				<hr style="width:100%;"/>
				<div class="flex">
				 <div class="left50 redText">ADD DESTINATION</div>
				 <div class="right50">
					 <select style="width:100%;margin-bottom: 4px;"  class="comboClass" id="addDestCombo" data-live-search="true" required="required">
						 <option value="0">New</option>
						 <option value="1">Existing</option>
						 <option value="2">Generic New</option>
						 <option value="3">Generic Existing</option>
					 </select>
					 <%-- <input type="radio" id="newDestRadio"  checked onclick="destRadioOnClick()" value="newDest" name="destRadio">&nbsp;&nbsp;New
				 	 <input type="radio" id="existingDestRadio"  style="margin-left:8px;"  onclick="destRadioOnClick()" value="existingDest" name="destRadio">&nbsp;&nbsp;Existing --%>
 				</div>
			 </div>
			 <div id="destSelectSpan" style="display:none;"><select class="form-control form-control-custom" style="width:100%;" id="destSelect" name="destSelect"></select></div>
			 <div id="destSelectSpanGeneric" style="display:none;"><select class="form-control form-control-custom" style="width:100%;" id="destSelectGeneric" name="destSelect"></select></div>

			 <div id="destDetentionDiv">
				 <input type="text" style="width:100%;height:34px;" id="destInput" placeholder="Search Box Destination"/>
			 	<div class="flex" id="dDetentionDiv">
			 		<div class="left" style="margin-top:8px">Detention (HH:mm):</div>
			 		<div class="right"><input type="text" style="width:98%;height:28px;margin:4px" id="destDetention"/></div>
			  </div>
			  <div class="flex" id="dRadiusDiv">
			 	 <div class="left" style="margin-top:4px">Radius (kms):</div>
			 	 <div class="right"><input type="number" style="width:98%;height:28px;margin:2px 4px;" id="destRadius"/></div>
			 	</div>
			 </div>

			 <div id="destDetentionDivGeneric" style="display:none;">
				 <input type="text" style="width:100%;height:34px;" id="destInputGeneric" placeholder="Search Box Generic Destination"/>
			 	<div class="flex" id="dDetentionDivGeneric">
			 		<div class="left" style="margin-top:8px">Detention (HH:mm):</div>
			 		<div class="right"><input type="text" style="width:98%;height:28px;margin:4px" id="destDetentionGeneric"/></div>
			  </div>
			  <div class="flex" id="dRadiusDivGeneric">
			 	 <div class="left" style="margin-top:4px">Radius (kms):</div>
			 	 <div class="right"><input type="number" style="width:98%;height:28px;margin:2px 4px;" value="30" id="destRadiusGeneric"/></div>
			 	</div>
			 </div>

       <hr style="width:100%;"/>
			 <div id="waypointMainDiv" style="background:#dfdfdf;padding:8px;border:1px solid #a8a8a8;">
				 <div class="flex">
					<div class="left50 orangeText">ADD WAYPOINTS</div>
					<div class="right50">
						<select style="width:100%;margin-bottom: 4px;"  class="comboClass" id="addWaypointsCombo" data-live-search="true" required="required">
							<option value="0">New</option>
							<option value="1">Existing</option>
							<option value="2">Generic New</option>
							<option value="3">Generic Existing</option>
						</select>
						<%-- <input type="radio" id="newWaypointRadio" checked onclick="waypointOnClick()" value="newWaypoint" name="waypointRadio">&nbsp;&nbsp;New
						<input type="radio" id="existingWaypointRadio" style="margin-left:8px;" onclick="waypointOnClick()"  value="existingWaypoint" name="waypointRadio">&nbsp;&nbsp;Existing --%>
					</div>
				</div>
				<div id="waypointSelectSpan" style="display:none;" class="flex">
					<div style="margin-top:4px;width:75%">
						<select class="form-control form-control-custom" style="width:100%;" id="waypointSelect" name="waypointSelect"></select></div>
					<div class="rt" style="margin-top:4px;">
						<button id="btnAddWaypointExisting" class="btn btn-generate btn-md btn-primary btn-block" onclick="addWaypointExisting()"  style="margin-left:4px;background:green;height:26px;padding-top:3px;" type="submit">ADD</button>
					</div>
				</div>
				<div id="waypointSelectSpanGeneric" style="display:none;" class="flex">
					<div style="margin-top:4px;width:75%">
						<select class="form-control form-control-custom" style="width:100%;" id="waypointSelectGeneric" name="waypointSelectGeneric"></select></div>
					<div class="rt" style="margin-top:4px;">
						<button id="btnAddWaypointExistingGeneric" class="btn btn-generate btn-md btn-primary btn-block" onclick="addWaypointExistingGeneric()"  style="margin-left:4px;background:green;height:26px;padding-top:3px;" type="submit">ADD</button>
					</div>
				</div>
				<div id="waypointDiv">
					<input type="text" style="width:100%;height:34px;" id="waypointInput" placeholder="Search Box Waypoint"/>
				 <div class="flex">
					 <div class="left" style="margin-top:8px;">Detention (HH:mm):</div>
					 <div class="right"><input type="text" style="width:98%;height:28px;margin:4px" id="waypointDetention"/></div>
				 </div>
				 <div class="flex">
					<div class="left" style="margin-top:4px;">Radius (kms):</div>
					<div class="middle"><input type="number" style="width:90%;margin:2px;" id="waypointRadius"/>	</div>
					<div class="rt" style="margin-top:2px;"><button id="btnAddWaypoint" class="btn btn-generate btn-md btn-primary btn-block" onclick="addWaypointNew()"  style="background:green;height:26px;padding-top:3px;" type="submit">ADD</button>
					</div>
				 </div>
			 	</div>

				<div id="waypointDivGeneric" style="display:none;">
					<input type="text" style="width:100%;height:34px;" id="waypointInputGeneric" placeholder="Search Box Generic Waypoint"/>
				 <div class="flex">
					 <div class="left" style="margin-top:8px;">Detention (HH:mm):</div>
					 <div class="right"><input type="text" style="width:98%;height:28px;margin:4px" id="waypointDetentionGeneric"/></div>
				 </div>
				 <div class="flex">
					<div class="left" style="margin-top:4px;">Radius (kms):</div>
					<div class="middle"><input type="number" value="30" style="width:90%;margin:2px;" id="waypointRadiusGeneric"/>	</div>
					<div class="rt" style="margin-top:2px;"><button id="btnAddWaypointGeneric" class="btn btn-generate btn-md btn-primary btn-block" onclick="addWaypointNewGeneric()"  style="background:green;height:26px;padding-top:3px;" type="submit">ADD</button>
					</div>
				 </div>
			 	</div>
			</div>
			<hr style="width:100%;"/>
			<div class="flex">
				<div class="left">TAT (HH:mm):<span style="color:red">*</span></div><div class="right"><input type="text" style="height:34px;margin:2px;width:100%" id="tatInput"/></div>
			</div>
			<div class="flex">
				<div class="left">Distance (kms):</div><div class="right"><input type="number" readonly style="height:34px;margin:2px;width:100%;background:#F7F7F7;border: 1px solid #dfdfdf;" id="distanceInput"/></div>
			</div>
			<div class="flex">
				<div class="left">Avg Speed (kms/hr):</div><div class="right"><input type="number" readonly style="height:34px;margin:2px;width:100%;background:#F7F7F7;border: 1px solid #dfdfdf;" id="avgSpeedInput"/></div>
			</div>
			<div class="flex">
				<div class="left" title="Route Key format: sourceCity_destinationCity">Route Key:<span style="color:red">*</span></div>
				<div style="width:51%" id="routeKeyDiv" title="Route Key format: sourceCity_destinationCity"><input type="text" style="margin:2px;width:95%;" id="routeKeyInput"/></div>
				<div id="getRouteIdDiv" style="width:5%;margin-top:4px;display:none;">
					<i onclick="getRouteId()" style="color:green;cursor:pointer;" class="fa fa-check" aria-hidden="true"></i>
				</div>
			</div>
			<div class="card" style="font-size:12px;">
			<b>* Route Key format: sourceCity_destinationCity</b>
			* The ID counter we are showing may not be the same number saved if multiple concurrent users are creating the routes for the same customer in the same city.
		  </div>
			<div class="flex">
				<div class="left">Route Id:<span style="color:red">*</span></div><div class="right"><input type="text" style="height:34px;width:100%;margin:2px;" id="routeNameInput"/></div>
			</div>
			<div class="flex">
			 <div style="width:25%"> <button id="btnReset" class="btn btn-generate btn-md btn-primary btn-block" onclick="reset()"  style="background:#F0AD4E;margin:8px 8px 0px 0px;border: 1px solid #F0AD4E;" type="submit">RESET</button>
			 </div>
			 <div style="margin-right:8px;width:80%"><button id="btnFreeze" class="btn btn-generate btn-md btn-primary btn-block" onclick="freeze()"  style="background:#18519E;margin:8px 0px 0px 8px;" type="submit">SAVE ROUTE <br/>& GO TO CREATE TRIP</button>
				</div>
			</div>
			 </div>
		 </div>
	</div>
	<div class="col-xs-12 col-md-12 col-lg-9" style="padding:0px 16px 0px 0px;" style="position:relative;">
		<div id="legListDiv" style="display:none;position:absolute;top:8px;left:8px;max-width:250px;border:1px solid #A8A8A8;z-index:1;padding:8px;font-size:10px;background:white;">
			<div><strong> ROUTE SUMMARY</strong> </div><br/>
			<div class="flex" id="source">
			</div><hr/>
			<div id="waypoints">
			</div><hr/>
			<div class="flex" id="destination">
			</div>
		</div>
		<div id="mapExisting" style="width: 100%;position: relative;overflow: hidden;border: solid 1px rgba(0, 0, 0, .25);box-shadow: 0 1px 1px rgba(0, 0, 0, .25);height:85vh;">
		</div>
		<div id="map" style="width: 100%;position: relative;overflow: hidden;display:none;border: solid 1px rgba(0, 0, 0, .25);box-shadow: 0 1px 1px rgba(0, 0, 0, .25);height:90vh;">
		</div>
	</div>
</div>
<!-- script src="https://maps.googleapis.com/maps/api/js?v=3.exp&libraries=places,geometry&key=AIzaSyBxAhYgPvdRnKBypG_rGB6EpZSHj0DpVF4&region=IN&libraries=places">  -->
<script src='<%=GoogleApiKey%>&region=IN'></script>
</script>

<script>
var map;
var mapExisting;
var routeValue = "";
var customerKeepId;
var countryName = "India";
var hubList;

var sourceMarker = null;
var sourcePlaceObject;
var markers = [];
var sourcePlace;
var sourceStart = "";
var destPlaceObject;
var destinationMarker = null;
var destinationPlace;
var destinationEnd = "";
var waypointPlaceObject;
var waypointMarker;
var waypointPlace;
var waypointEnd;


var smartHubs;
var waypoints = [];
var hubDetails = [];
var currentWaypointNo = 0;

var existingLegList;
var existingRouteDetails;
var legIds = "";
var polylatlongs=[];
var completeRoutePath;
var dragPointArray = [];
var myLatLngS;
var myLatLngD;
var directionDisplayArr=[];
var checkPointInfoWindowsArray = [];

var directionsService = new google.maps.DirectionsService;
var directionsDisplay = new google.maps.DirectionsRenderer({
	draggable: true,
	suppressMarkers: true,
	map: map
});

var directionsServiceExisting = new google.maps.DirectionsService;
var directionsDisplayExisting = new google.maps.DirectionsRenderer({
		map: mapExisting
});

var totalLegCount = 0;
var currentLeg = 0;
var completeLegDetails = [];
var fullRoute;
var tempSensorNames = [];
var selecedSensorsForAlert = [];

function plotOnMap()
{
	if($("#existingRouteDropDown").val() != null)
	{
		 polylatlongs=[];
		 dragPointArray = [];
		 directionDisplayArr=[];
		 checkPointInfoWindowsArray = [];
		$("#loading").show();
		$.ajax({
				url: '<%=request.getContextPath()%>/LegCreationAction.do?param=getLegList',
				data:{
					routeId: $("#existingRouteDropDown").val()
				},
				 success: function(response) {
						 existingLegList = JSON.parse(response).legListRoot;
						 getRouteLatlongs()
				 }
		 });
  }

}

function getRouteLatlongs(){
	legIds = '';
	google.maps.event.trigger(map, 'resize');
	 for (var j = 0; j < existingLegList.length; j++) {
					 legIds+=existingLegList[j].legId+',';
	 }
	 polylatlongs = [];
	 $.ajax({
		 url: '<%=request.getContextPath()%>/LegCreationAction.do?param=getLatLongsForCompleteRoute',
		 data:{
			 legIds: legIds,
			 routeId : $("#existingRouteDropDown").val()
		 },
			 success: function(result){
				 results = JSON.parse(result);
				 completeRoutePath = results;

			 for (var i = 0; i < results["routelatlongRoot"].length; i++) {
				 if((results["routelatlongRoot"][i].type=='SOURCE')){
					 myLatLngS= new google.maps.LatLng(results["routelatlongRoot"][i].lat, results["routelatlongRoot"][i].lon);
				 }
				 if(results["routelatlongRoot"][i].type=='DESTINATION'){
					 myLatLngD= new google.maps.LatLng(results["routelatlongRoot"][i].lat, results["routelatlongRoot"][i].lon);
				 }
				 if(results["routelatlongRoot"][i].type=='CHECKPOINT'){
						polylatlongs.push({
											location: new google.maps.LatLng(results["routelatlongRoot"][i].lat, results["routelatlongRoot"][i].lon),
											stopover: true
								 });
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
			 $("#loading").hide();
		 }
	 });
 }

 function plotRoute() {
 //clearMarkers();
			 for (var i = 0; i < directionDisplayArr.length; i++) {
			 directionDisplayArr[i].setMap(null);
		 }
		 if(directionsDisplayExisting != null) {
				directionsDisplayExisting.setMap(null);
				directionsDisplayExisting = null;
		}


		 directionsDisplayExisting = new google.maps.DirectionsRenderer({
			 map: mapExisting
		 });
		 //polylatlongs = []

		 directionsServiceExisting.route({
				 origin: myLatLngS,
				 destination: myLatLngD,
				 waypoints: polylatlongs,
				 travelMode: google.maps.TravelMode.DRIVING

		 }, function(response, status) {
				 if (status === google.maps.DirectionsStatus.OK) {
						 directionsDisplayExisting.setDirections(response);
						 directionDisplayArr.push(directionsDisplayExisting);
				 } else {
						 console.log("Invalid Request "+status);
				 }
		 });


 }
 var detentionCheckPointsArray = [];
 var checkPointMarkersArray = [];
 function plotCheckPoints(completeRoutePath){
	 detentionCheckPointsArray = [];
	 checkPointMarkersArray = [];

					cancelInfo();
						 }

						 function cancelInfo() {

							setTimeout(function() {
									 checkPointInfoWindowsArray.forEach(function (infowindow){
												infowindow.close();
										 });

											}, 1000);
						 }

initialize();
function initialize() {
	var mapOptions = {
			zoom: 4.6,
			center: new google.maps.LatLng(<%=latitudeLongitude%>), //23.524681, 77.810561),,
			mapTypeId: google.maps.MapTypeId.ROADMAP,
			mapTypeControl: false,
			gestureHandling: 'greedy',
			styles: [{
							"featureType": "all",
							"elementType": "labels.text.fill",
							"stylers": [{
											"color": "#7c93a3"
									},
									{
											"lightness": "-10"
									}
							]
					},
					{
							"featureType": "water",
							"elementType": "geometry.fill",
							"stylers": [{
									"color": "#7CC7DF"
							}]
					}
			]
	};
	map = new google.maps.Map(document.getElementById('map'), mapOptions);
	mapExisting = new google.maps.Map(document.getElementById('mapExisting'), mapOptions);
	//map.fitBounds(bounds);
	var trafficLayer = new google.maps.TrafficLayer();
	trafficLayer.setMap(map);
	var trafficLayerExisting = new google.maps.TrafficLayer();
	trafficLayerExisting.setMap(mapExisting);

	var geocoder = new google.maps.Geocoder();
	geocoder.geocode({
			'address': countryName
	}, function(results, status) {
			if (status == google.maps.GeocoderStatus.OK) {
					map.setCenter(results[0].geometry.location);
					mapExisting.setCenter(results[0].geometry.location);
			}
	});



}

$(document).ready(function() {

	$.ajax({
			url: '<%=request.getContextPath()%>/QTPAction.do?param=getCustomerType',
			data: {
				custId: <%=customerId%>
			},
			success: function(response) {
				let customerType = JSON.parse(response).customerTypeRoot;


				$option = $('<option value="0">Customer Type</option>');
				 $('#addcustNameType').append($option);

				for (let i = 0; i < customerType.length; i++) {
					let vtl = customerType[i];
					$option = $('<option value="'+vtl.custType+'">'+vtl.custType+'</option>');
					 $('#addcustNameType').append($option);
				}


		 }
	 });
});

$("#addcustNameType").on('change', function() {

	resetExisting();
	reset();
	if($('#addcustNameType').val() == "Broker")
	{
	$("#addSourceCombo option[value='2']").show();
	$("#addSourceCombo option[value='3']").show();
	$("#addDestCombo option[value='2']").show();
	$("#addDestCombo option[value='3']").show();
	$("#addWaypointsCombo option[value='2']").show();
	$("#addWaypointsCombo option[value='3']").show();
	}
	else {
	$("#addSourceCombo option[value='2']").hide();
	$("#addSourceCombo option[value='3']").hide();
	$("#addDestCombo option[value='2']").hide();
	$("#addDestCombo option[value='3']").hide();
	$("#addWaypointsCombo option[value='2']").hide();
	$("#addWaypointsCombo option[value='3']").hide();
	}

	$.ajax({
			url: '<%=request.getContextPath()%>/QTPAction.do?param=getTripCustomers',
			data:{
				custId: <%=customerId%>,
				type: $('#addcustNameType').val()
			},
			success: function(response) {
				let customer = JSON.parse(response).customersRoot;
				$('#addcustNameDownID').find('option').remove();
				$option = $('<option value="0">Customer</option>');
				 $('#addcustNameDownID').append($option);

				for (let i = 0; i < customer.length; i++) {
					let vtl = customer[i];
					$option = $('<option value="'+vtl.tripCustId+'">'+vtl.tripCustName+'</option>');
					 $('#addcustNameDownID').append($option);
				}
				$('#addcustNameDownID').select2();
		 }
	 });
})

$("#addcustNameDownID").on('change', function() {

	resetExisting();
		reset();

	$.ajax({
      url: '<%=request.getContextPath()%>/QTPAction.do?param=getSourceAndDestination',
      data:{
        tripCustId: document.getElementById("addcustNameDownID").value
      },
      success: function(response) {
		  if(response != null){
          hubList = JSON.parse(response).sourceRoot;
          if ($('#addSourceCombo').val() == "1") {
						$("#sourceSelect").empty().select2();
          populateHubs("source");}

          if ($('#addDestCombo').val() == "1") {
						$("#destSelect").empty().select2();
          populateHubs("dest");}

					if ($('#addWaypointsCombo').val() == "1") {
						$("#waypointSelect").empty().select2();
          populateHubs("waypoint");}

					if ($('#addSourceCombo').val() == "3") {
						$("#sourceSelectGeneric").empty().select2();
          populateHubs("sourceGeneric");}

          if ($('#addDestCombo').val() == "3") {
						$("#destSelectGeneric").empty().select2();
          populateHubs("destGeneric");}

					if ($('#addWaypointsCombo').val() == "3") {
						$("#waypointSelectGeneric").empty().select2();
          populateHubs("waypointGeneric");}

        }
     }
   })

	$("#addcustNameDownID").val() != "0"? $("#routeDetailsDiv").show(): $("#routeDetailsDiv").hide();
    $("#loading").show();
    getRoute();
})
function getRoute(){

    $("#existingRouteDropDown").empty().select2();
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
                                    $('#existingRouteDropDown').append($("<option></option>").attr("value", routeList["RouteNameRoot"][i].RouteId).attr("count",routeList["RouteNameRoot"][i].legCount)
                                    .text(routeList["RouteNameRoot"][i].RouteName));
                        }
                        $('#existingRouteDropDown').select2();
                        $("#loading").hide();
                }

    });
    }


function newExistingRouteOnClick(){
	if ($("input[name='newExistingRoute']:checked").val() == "existingRoute") {
		$("#existingRouteDropDownDiv").show();
		$("#newRouteDropDownDiv").hide();
		$("#mapExisting").show();
		$("#map").hide();
		$("#legListDiv").hide();
		reset();

	}
	else {
		$("#existingRouteDropDownDiv").hide();
		$("#newRouteDropDownDiv").show();
		$("#mapExisting").hide();
		$("#map").show();
	}

}


function goToCreateTrip()
{
	routeValue = $("#existingRouteDropDown").val();
	openAddModal();

}

$('#addSourceCombo').on('change', function (e) {
     if ($('#addSourceCombo').val() == "0") {
			 	$("#sourceSelect").empty();
				$("#sourceSelectGeneric").empty();
			 	$("#sourceSelectSpan").hide();
				$("#sourceSelectSpanGeneric").hide();
				$("#sourceDetentionDivGeneric").hide();
			 	$("#sourceDetentionDiv").show();
     }
		 if ($('#addSourceCombo').val() == "1") {
         $("#sourceSelectSpan").show();
         $("#sourceInput").val("");
         $("#sourceDetention").val("");
				 $("#sourceRadius").val("");
				 $("#sourceSelectSpanGeneric").hide();
				 $("#sourceDetentionDivGeneric").hide();
				 $("#sourceDetentionDiv").hide();
         populateHubs("source");
     }
		 if ($('#addSourceCombo').val() == "2") {
			 	$("#sourceSelect").empty();
				$("#sourceSelectGeneric").empty();
				$("#sourceSelectSpan").hide();
				$("#sourceSelectSpanGeneric").hide();
				$("#sourceDetentionDivGeneric").show();
				$("#sourceDetentionDiv").hide();
     }
		 if ($('#addSourceCombo').val() == "3") {
         $("#sourceSelectSpanGeneric").show();
         $("#sourceInputGeneric").val("");
         $("#sourceDetentionGeneric").val("");
				 $("#sourceRadiusGeneric").val("30");
				 $("#sourceSelectSpan").hide();
				 $("#sourceDetentionDivGeneric").hide();
				 $("#sourceDetentionDiv").hide();
         populateHubs("sourceGeneric");
     }
 })
$('#addDestCombo').on('change', function (e) {
     if ($('#addDestCombo').val() == "0") {
			 $("#destSelect").empty();
			 $("#destSelectGeneric").empty();
			 $("#destSelectSpan").hide();
			 $("#destSelectSpanGeneric").hide();
			 $("#destDetentionDivGeneric").hide();
			 $("#destDetentionDiv").show();
		 }
		if ($('#addDestCombo').val() == "1") {
				 $("#destSelectSpan").show();
				 $("#destInput").val("");
				 $("#destDetention").val("");
				$("#destRadius").val("");
				$("#destSelectSpanGeneric").hide();
				$("#destDetentionDivGeneric").hide();
				$("#destDetentionDiv").hide();
				 populateHubs("dest");
		 }
		if ($('#addDestCombo').val() == "2") {
			 $("#destSelect").empty();
			 $("#destSelectGeneric").empty();
			 $("#destSelectSpan").hide();
			 $("#destSelectSpanGeneric").hide();
			 $("#destDetentionDivGeneric").show();
			 $("#destDetentionDiv").hide();
		 }
		if ($('#addDestCombo').val() == "3") {
				 $("#destSelectSpanGeneric").show();
				 $("#destInputGeneric").val("");
				 $("#destDetentionGeneric").val("");
				$("#destRadiusGeneric").val("30");
				$("#destSelectSpan").hide();
				$("#destDetentionDivGeneric").hide();
				$("#destDetentionDiv").hide();
				 populateHubs("destGeneric");
		 }
 })
 $('#addWaypointsCombo').on('change', function (e) {
	 if ($('#addWaypointsCombo').val() == "0") {
		$("#waypointSelect").empty();
		$("#waypointSelectGeneric").empty();
		$("#waypointSelectSpan").hide();
		$("#waypointSelectSpanGeneric").hide();
		$("#waypointDivGeneric").hide();
		$("#waypointDiv").show();
	}
 if ($('#addWaypointsCombo').val() == "1") {
			$("#waypointSelectSpan").show();
			$("#waypointInput").val("");
			$("#waypointDetention").val("");
		 $("#waypointRadius").val("");
		 $("#waypointSelectSpanGeneric").hide();
		 $("#waypointDivGeneric").hide();
		 $("#waypointDiv").hide();
			populateHubs("waypoint");
	}
 if ($('#addWaypointsCombo').val() == "2") {
		$("#waypointSelect").empty();
		$("#waypointSelectGeneric").empty();
		$("#waypointSelectSpan").hide();
		$("#waypointSelectSpanGeneric").hide();
		$("#waypointDivGeneric").show();
		$("#waypointDiv").hide();
	}
 if ($('#addWaypointsCombo').val() == "3") {
			$("#waypointSelectSpanGeneric").show();
			$("#waypointInputGeneric").val("");
			$("#waypointDetentionGeneric").val("");
		 $("#waypointRadiusGeneric").val("30");
		 $("#waypointSelectSpan").hide();
		 $("#waypointDivGeneric").hide();
		 $("#waypointDiv").hide();
			populateHubs("waypointGeneric");
	}
})

 function populateHubs(type) {
   if(type=="source"){
		 $("#sourceSelect").empty();
     for (var i = 0; i < hubList.length; i++) {
			 if(hubList[i].type != "999"){
         $('#sourceSelect').append($("<option></option>").attr("value", hubList[i].Hub_Id).attr("latitude", hubList[i].latitude).attr("name", hubList[i].Hub_Name)
             .attr("longitude", hubList[i].longitude).attr("radius", hubList[i].radius).attr("detention", hubList[i].detention).text(hubList[i].Hub_Name));
     }}
     $('#sourceSelect').select2();
 } else if(type == "dest") {
   $("#destSelect").empty();
   for (var i = 0; i < hubList.length; i++) {
		  if(hubList[i].type != "999"){
       $('#destSelect').append($("<option></option>").attr("value", hubList[i].Hub_Id).attr("latitude", hubList[i].latitude).attr("name", hubList[i].Hub_Name)
           .attr("longitude", hubList[i].longitude).attr("radius", hubList[i].radius).attr("detention", hubList[i].detention).text(hubList[i].Hub_Name));
   }}
   $('#destSelect').select2();
 } else if(type == "waypoint") {
      $("#waypointSelect").empty();
	    for (var i = 0; i < hubList.length; i++) {
				 if(hubList[i].type != "999"){
	        $('#waypointSelect').append($("<option></option>").attr("value", hubList[i].Hub_Id).attr("latitude", hubList[i].latitude).attr("name", hubList[i].Hub_Name)
	            .attr("longitude", hubList[i].longitude).attr("radius", hubList[i].radius).attr("detention", hubList[i].detention).text(hubList[i].Hub_Name));
	    }}
	    $('#waypointSelect').select2();

 }

 if(type=="sourceGeneric"){
	 $("#sourceSelectGeneric").empty();
	 for (var i = 0; i < hubList.length; i++) {
		 if(hubList[i].type == "999" || hubList[i].type == null){
			 $('#sourceSelectGeneric').append($("<option></option>").attr("value", hubList[i].Hub_Id).attr("latitude", hubList[i].latitude).attr("name", hubList[i].Hub_Name)
					 .attr("longitude", hubList[i].longitude).attr("radius", hubList[i].radius).attr("detention", hubList[i].detention).text(hubList[i].Hub_Name));
	 }}
	 $('#sourceSelectGeneric').select2();
} else if(type == "destGeneric") {
	$("#destSelectGeneric").empty();
 for (var i = 0; i < hubList.length; i++) {
	 if(hubList[i].type == "999" || hubList[i].type == null){
		 $('#destSelectGeneric').append($("<option></option>").attr("value", hubList[i].Hub_Id).attr("latitude", hubList[i].latitude).attr("name", hubList[i].Hub_Name)
				 .attr("longitude", hubList[i].longitude).attr("radius", hubList[i].radius).attr("detention", hubList[i].detention).text(hubList[i].Hub_Name));
 }}
 $('#destSelectGeneric').select2();
} else if(type == "waypointGeneric") {
	$("#waypointSelectGeneric").empty();
		for (var i = 0; i < hubList.length; i++) {
			if(hubList[i].type == "999" || hubList[i].type == null){
				$('#waypointSelectGeneric').append($("<option></option>").attr("value", hubList[i].Hub_Id).attr("latitude", hubList[i].latitude).attr("name", hubList[i].Hub_Name)
						.attr("longitude", hubList[i].longitude).attr("radius", hubList[i].radius).attr("detention", hubList[i].detention).text(hubList[i].Hub_Name));
		}}
		$('#waypointSelectGeneric').select2();

}
}

$("#sourceInput").on("change", function()
{
	if($("#sourceInput").val() != null && $("#sourceInput").val() != ""){
			var searchBoxLatLng = $("#sourceInput").val().split(",");
			var searchBoxLatLngLeft = searchBoxLatLng[0].trim();
			var searchBoxLatLngRight = searchBoxLatLng[1].trim();
			if($.isNumeric(searchBoxLatLngLeft) && $.isNumeric(searchBoxLatLngRight))
			{
				    sourceStart = new google.maps.LatLng(searchBoxLatLngLeft,searchBoxLatLngRight);
						geocoder = new google.maps.Geocoder();
						geocoder.geocode({'latLng': sourceStart}, function(results, status) {
							if (status == google.maps.GeocoderStatus.OK) {
								if(sourceMarker != null)
								{
									sourceMarker.setMap(null);
								}
								sourceMarker = new google.maps.Marker({
										map: map,
										// icon: icon,
										title: results[0].formatted_address,
										draggable:true,
										icon: "http://www.google.com/mapfiles/dd-start.png",
										position: sourceStart
								});
								markers.push(sourceMarker);
								sourcePlace = results[0].formatted_address;

								$("#legListDiv").show();
								$("#source").html("<span class='greenText'>SOURCE:&nbsp;</span>"+results[0].formatted_address);
								$("#routeKeyInput").val("");
								$("#routeNameInput").val("");
								$("#routeKeyInput").removeClass("redBorder");
								$("#routeNameInput").removeClass("redBorder");
								map.setZoom(4.6);
								calcRoute()
							}


						google.maps.event.addListener(sourceMarker, 'dragend', function (event) {
								geocoder = new google.maps.Geocoder();
								sourceStart = new google.maps.LatLng(event.latLng.lat(), event.latLng.lng());
								geocoder.geocode({'latLng': sourceStart}, function(results, status) {
									if (status == google.maps.GeocoderStatus.OK) {
										$("#sourceInput").val(results[0].formatted_address);
										$("#source").html("<span class='greenText'>SOURCE:&nbsp;</span>"+results[0].formatted_address);
										$("#routeKeyInput").val("");
										$("#routeNameInput").val("");
										$("#routeKeyInput").removeClass("redBorder");
										$("#routeNameInput").removeClass("redBorder");
										calcRouteWithWaypoints();
									}
								})
						});

	})
				}
			}
})

$("#sourceInputGeneric").on("change", function()
{
	if($("#sourceInputGeneric").val() != null && $("#sourceInputGeneric").val() != ""){
			var searchBoxLatLng = $("#sourceInputGeneric").val().split(",");
			var searchBoxLatLngLeft = searchBoxLatLng[0].trim();
			var searchBoxLatLngRight = searchBoxLatLng[1].trim();
			if($.isNumeric(searchBoxLatLngLeft) && $.isNumeric(searchBoxLatLngRight))
			{
				    sourceStart = new google.maps.LatLng(searchBoxLatLngLeft,searchBoxLatLngRight);
						geocoder = new google.maps.Geocoder();
						geocoder.geocode({'latLng': sourceStart}, function(results, status) {
							if (status == google.maps.GeocoderStatus.OK) {
								if(sourceMarker != null)
								{
									sourceMarker.setMap(null);
								}
								sourceMarker = new google.maps.Marker({
										map: map,
										// icon: icon,
										title: results[0].formatted_address,
										draggable:true,
										icon: "http://www.google.com/mapfiles/dd-start.png",
										position: sourceStart
								});
								markers.push(sourceMarker);
								sourcePlace = results[0].formatted_address;

								$("#legListDiv").show();
								$("#source").html("<span class='greenText'>SOURCE:&nbsp;</span>"+results[0].formatted_address);
								$("#routeKeyInput").val("");
								$("#routeNameInput").val("");
								$("#routeKeyInput").removeClass("redBorder");
								$("#routeNameInput").removeClass("redBorder");
								map.setZoom(4.6);
								calcRoute()
							}


						google.maps.event.addListener(sourceMarker, 'dragend', function (event) {
								geocoder = new google.maps.Geocoder();
								sourceStart = new google.maps.LatLng(event.latLng.lat(), event.latLng.lng());
								geocoder.geocode({'latLng': sourceStart}, function(results, status) {
									if (status == google.maps.GeocoderStatus.OK) {
										$("#sourceInputGeneric").val(results[0].formatted_address);
										$("#source").html("<span class='greenText'>SOURCE:&nbsp;</span>"+results[0].formatted_address);
										$("#routeKeyInput").val("");
										$("#routeNameInput").val("");
										$("#routeKeyInput").removeClass("redBorder");
										$("#routeNameInput").removeClass("redBorder");
										calcRouteWithWaypoints();
									}
								})
						});

	})
				}
			}
})


$("#destInput").on("change", function()
{
	if($("#destInput").val() != null && $("#destInput").val() != ""){
			var searchBoxLatLng = $("#destInput").val().split(",");
			var searchBoxLatLngLeft = searchBoxLatLng[0].trim();
			var searchBoxLatLngRight = searchBoxLatLng[1].trim();
			if($.isNumeric(searchBoxLatLngLeft) && $.isNumeric(searchBoxLatLngRight))
			{
				    destinationEnd = new google.maps.LatLng(searchBoxLatLngLeft,searchBoxLatLngRight);
						alert(3)
						geocoder = new google.maps.Geocoder();
						geocoder.geocode({'latLng': destinationEnd}, function(results, status) {
							if (status == google.maps.GeocoderStatus.OK) {
								if(destinationMarker != null)
								{
									destinationMarker.setMap(null);
								}
								destinationMarker = new google.maps.Marker({
										map: map,
										// icon: icon,
										title: results[0].formatted_address,
										draggable:true,
										icon: "http://www.google.com/mapfiles/dd-end.png",
										position: destinationEnd
								});
								markers.push(destinationMarker);
								destinationPlace = results[0].formatted_address;

								$("#destination").html("<span class='redText'>DESTINATION:&nbsp;</span> "+results[0].formatted_address);
								$("#routeKeyInput").val("");
								$("#routeNameInput").val("");
								$("#routeKeyInput").removeClass("redBorder");
								$("#routeNameInput").removeClass("redBorder");
								map.setZoom(4.6);
								calcRoute()
							}


						google.maps.event.addListener(destinationMarker, 'dragend', function (event) {
								geocoder = new google.maps.Geocoder();
								destinationEnd = new google.maps.LatLng(event.latLng.lat(), event.latLng.lng());
								geocoder.geocode({'latLng': destinationEnd}, function(results, status) {
									if (status == google.maps.GeocoderStatus.OK) {
										$("#destInput").val(results[0].formatted_address);
										$("#destination").html("<span class='redText'>DESTINATION:&nbsp;</span> "+results[0].formatted_address);
										$("#routeKeyInput").val("");
										$("#routeNameInput").val("");
										$("#routeKeyInput").removeClass("redBorder");
										$("#routeNameInput").removeClass("redBorder");
										calcRouteWithWaypoints();
									}
								})
						});
						})


				}
			}
})

$("#waypointInput").on("change", function()
{
	if($("#waypointInput").val() != null && $("#waypointInput").val() != ""){
			var searchBoxLatLng = $("#waypointInput").val().split(",");
			var searchBoxLatLngLeft = searchBoxLatLng[0].trim();
			var searchBoxLatLngRight = searchBoxLatLng[1].trim();
			if($.isNumeric(searchBoxLatLngLeft) && $.isNumeric(searchBoxLatLngRight))
			{
							geocoder = new google.maps.Geocoder();
							var latlng = new google.maps.LatLng(searchBoxLatLngLeft, searchBoxLatLngRight);
							geocoder.geocode({'latLng': latlng}, function(results, status) {
								if (status == google.maps.GeocoderStatus.OK) {
									var add= results[0].formatted_address ;
												 var value=add.split(",");
												 var c=value.length;
												 var ci=value[c-3];


													var country=value[c-1];
													var state=value[c-2];
													var city=value[c-3];

													var cntry = country.replace(/[0-9]/g, '');
													var stat = state.replace(/[0-9]/g, '');
													var cty = city.replace(/[0-9]/g, '');

													stat=stat.toUpperCase();
													cntry=cntry.toUpperCase();
													cty=cty.toUpperCase();
													
													var addressComponent = results[0].address_components;  
	             								    for (var i = 0; i < addressComponent.length; i++) {
           											  for (var j = 0; j < addressComponent[i].types.length; j++) {
               			 									if (addressComponent[i].types[j] == "postal_code") {
                		  										  console.log(addressComponent[i].long_name);
                		   										  newPincode = addressComponent[i].long_name;
               												 }
           												 }
        	   										  }
        											  //alert("New Pincode :: " + newPincode);

												 currentWaypoint = {location: latlng, state: stat, country: cntry, city: cty, pincode:newPincode, add: add, stopover: true, type: ci.replace(/[0-9]/g, '')}


							}

						})
				}
			}
})


// Create the search box and link it to the UI element.
var searchBoxSource = new google.maps.places.SearchBox(document.getElementById('sourceInput'));
var searchBoxSourceGeneric = new google.maps.places.SearchBox(document.getElementById('sourceInputGeneric'));
var searchBoxDest = new google.maps.places.SearchBox(document.getElementById('destInput'));
var searchBoxDestGeneric = new google.maps.places.SearchBox(document.getElementById('destInputGeneric'));
var searchBoxWaypoint = new google.maps.places.SearchBox(document.getElementById('waypointInput'));
var searchBoxWaypointGeneric = new google.maps.places.SearchBox(document.getElementById('waypointInputGeneric'));
// Bias the SearchBox results towards current map's viewport.
map.addListener('bounds_changed', function() {
		searchBoxSource.setBounds(map.getBounds());
		searchBoxDest.setBounds(map.getBounds());
		searchBoxWaypoint.setBounds(map.getBounds());

		searchBoxSourceGeneric.setBounds(map.getBounds());
		searchBoxDestGeneric.setBounds(map.getBounds());
		searchBoxWaypointGeneric.setBounds(map.getBounds());
});

// Listen for the event fired when the user selects a prediction and retrieve
// more details for that place.

searchBoxSource.addListener('places_changed', function() {
		var places = searchBoxSource.getPlaces();
		if (places.length == 0) {
				return;
		}
		// places.forEach(function(place) {
		let place = places[0];
			 sourcePlaceObject = places[0];
				if (!place.geometry) {
						console.log("Returned place contains no geometry");
						return;
				}

				if(sourceMarker != null)
				{
					sourceMarker.setMap(null);
			  }
				sourceMarker = new google.maps.Marker({
						map: map,
						// icon: icon,
						title: place.name,
						draggable:true,
						title: "Source",
						icon: "http://www.google.com/mapfiles/dd-start.png",
						position: place.geometry.location
				});
				markers.push(sourceMarker);
				sourcePlace = place.name;
				sourceStart = new google.maps.LatLng(place.geometry.location.lat(), place.geometry.location.lng());
				$("#legListDiv").show();
				$("#source").html("<span class='greenText'>SOURCE:&nbsp;</span>"+place.name);

				google.maps.event.addListener(sourceMarker, 'dragend', function (event) {
          	geocoder = new google.maps.Geocoder();
						sourceStart = new google.maps.LatLng(event.latLng.lat(), event.latLng.lng());
						geocoder.geocode({'latLng': sourceStart}, function(results, status) {
							if (status == google.maps.GeocoderStatus.OK) {
							  $("#sourceInput").val(results[0].formatted_address);
								$("#source").html("<span class='greenText'>SOURCE:&nbsp;</span>"+results[0].formatted_address);
								$("#routeKeyInput").val("");
								$("#routeNameInput").val("");
								$("#routeKeyInput").removeClass("redBorder");
								$("#routeNameInput").removeClass("redBorder");
								calcRouteWithWaypoints();
							}
						})
        });

		map.setZoom(4.6);
		calcRoute()
});

searchBoxSourceGeneric.addListener('places_changed', function() {
		var places = searchBoxSourceGeneric.getPlaces();
		if (places.length == 0) {
				return;
		}
		// places.forEach(function(place) {
		let place = places[0];
			 sourcePlaceObject = places[0];
				if (!place.geometry) {
						console.log("Returned place contains no geometry");
						return;
				}

				if(sourceMarker != null)
				{
					sourceMarker.setMap(null);
			  }
				sourceMarker = new google.maps.Marker({
						map: map,
						// icon: icon,
						title: place.name,
						draggable:true,
						title: "Source",
						icon: "http://www.google.com/mapfiles/dd-start.png",
						position: place.geometry.location
				});
				markers.push(sourceMarker);
				sourcePlace = place.name;
				sourceStart = new google.maps.LatLng(place.geometry.location.lat(), place.geometry.location.lng());
				$("#legListDiv").show();
				$("#source").html("<span class='greenText'>SOURCE:&nbsp;</span>"+place.name);

				google.maps.event.addListener(sourceMarker, 'dragend', function (event) {
          	geocoder = new google.maps.Geocoder();
						sourceStart = new google.maps.LatLng(event.latLng.lat(), event.latLng.lng());
						geocoder.geocode({'latLng': sourceStart}, function(results, status) {
							if (status == google.maps.GeocoderStatus.OK) {
							  $("#sourceInputGeneric").val(results[0].formatted_address);
								$("#source").html("<span class='greenText'>SOURCE:&nbsp;</span>"+results[0].formatted_address);
								$("#routeKeyInput").val("");
								$("#routeNameInput").val("");
								$("#routeKeyInput").removeClass("redBorder");
								$("#routeNameInput").removeClass("redBorder");
								calcRouteWithWaypoints();
							}
						})
        });

		map.setZoom(4.6);
		calcRoute()
});



searchBoxDest.addListener('places_changed', function() {
		var places = searchBoxDest.getPlaces();
		if (places.length == 0) {
				return;
		}
		markers = [];
		// For each place, get the icon, name and location.
		// places.forEach(function(place) {
			 let place = places[0]
				destPlaceObject = place;
				if (!place.geometry) {
						return;
				}
				// var icon = {
				// 		url: place.icon,
				// 		size: new google.maps.Size(71, 71),
				// 		origin: new google.maps.Point(0, 0),
				// 		anchor: new google.maps.Point(17, 34),
				// 		scaledSize: new google.maps.Size(25, 25)
				// };
				// Create a marker for each place.
				if(destinationMarker != null)
				{
					destinationMarker.setMap(null);
			  }
				destinationMarker = new google.maps.Marker({
						map: map,
						// icon: icon,
						title: place.name,
						title: "Destination",
						icon: "http://www.google.com/mapfiles/dd-end.png",
						draggable:true,
						position: place.geometry.location
				});
				destinationPlace = place.name;
				markers.push(destinationMarker);
				destinationEnd = new google.maps.LatLng(place.geometry.location.lat(), place.geometry.location.lng());
				$("#destination").html("<span class='redText'>DESTINATION:&nbsp;</span>"+place.name);

				google.maps.event.addListener(destinationMarker, 'dragend', function (event) {
          	geocoder = new google.maps.Geocoder();
						destinationEnd = new google.maps.LatLng(event.latLng.lat(), event.latLng.lng());
						geocoder.geocode({'latLng': destinationEnd}, function(results, status) {
							if (status == google.maps.GeocoderStatus.OK) {
							  $("#destInput").val(results[0].formatted_address);
								$("#destination").html("<span class='redText'>DESTINATION:&nbsp;</span> "+results[0].formatted_address);
								$("#routeKeyInput").val("");
								$("#routeNameInput").val("");
								$("#routeKeyInput").removeClass("redBorder");
								$("#routeNameInput").removeClass("redBorder");
								calcRouteWithWaypoints();
							}
						})
        });

		// });
		map.setZoom(4.6);
		calcRoute()
});


searchBoxDestGeneric.addListener('places_changed', function() {
		var places = searchBoxDestGeneric.getPlaces();
		if (places.length == 0) {
				return;
		}
		markers = [];
		// For each place, get the icon, name and location.
		// places.forEach(function(place) {
			 let place = places[0]
				destPlaceObject = place;
				if (!place.geometry) {
						return;
				}
				// var icon = {
				// 		url: place.icon,
				// 		size: new google.maps.Size(71, 71),
				// 		origin: new google.maps.Point(0, 0),
				// 		anchor: new google.maps.Point(17, 34),
				// 		scaledSize: new google.maps.Size(25, 25)
				// };
				// Create a marker for each place.
				if(destinationMarker != null)
				{
					destinationMarker.setMap(null);
			  }
				destinationMarker = new google.maps.Marker({
						map: map,
						// icon: icon,
						title: place.name,
						title: "Destination",
						icon: "http://www.google.com/mapfiles/dd-end.png",
						draggable:true,
						position: place.geometry.location
				});
				destinationPlace = place.name;
				markers.push(destinationMarker);
				destinationEnd = new google.maps.LatLng(place.geometry.location.lat(), place.geometry.location.lng());
				$("#destination").html("<span class='redText'>DESTINATION:&nbsp;</span>"+place.name);

				google.maps.event.addListener(destinationMarker, 'dragend', function (event) {
          	geocoder = new google.maps.Geocoder();
						destinationEnd = new google.maps.LatLng(event.latLng.lat(), event.latLng.lng());
						geocoder.geocode({'latLng': destinationEnd}, function(results, status) {
							if (status == google.maps.GeocoderStatus.OK) {
							  $("#destInputGeneric").val(results[0].formatted_address);
								$("#destination").html("<span class='redText'>DESTINATION:&nbsp;</span> "+results[0].formatted_address);
								$("#routeKeyInput").val("");
								$("#routeNameInput").val("");
								$("#routeKeyInput").removeClass("redBorder");
								$("#routeNameInput").removeClass("redBorder");
								calcRouteWithWaypoints();
							}
						})
        });

		// });
		map.setZoom(4.6);
		calcRoute()
});

var currentWaypoint;
var currentWaypointMarker;

searchBoxWaypoint.addListener('places_changed', function() {
		var places = searchBoxWaypoint.getPlaces();
		if (places.length == 0) {
				return;
		}
		markers = [];
				// places.forEach(function(place) {
		  let place = places[0];
				if (!place.geometry) {
						return;
				}

				geocoder = new google.maps.Geocoder();
				var latlng = new google.maps.LatLng(place.geometry.location.lat(), place.geometry.location.lng());
 		    geocoder.geocode({'latLng': latlng}, function(results, status) {
 		      if (status == google.maps.GeocoderStatus.OK) {
					  var add= results[0].formatted_address ;
 		               var value=add.split(",");
 		               var c=value.length;
 		               var ci=value[c-3];


										var country=value[c-1];
										var state=value[c-2];
										var city=value[c-3];

										var cntry = country.replace(/[0-9]/g, '');
										var stat = state.replace(/[0-9]/g, '');
										var cty = city.replace(/[0-9]/g, '');

										stat=stat.toUpperCase();
										cntry=cntry.toUpperCase();
										cty=cty.toUpperCase();
										
										 var addressComponent = results[0].address_components;  
	             						 for (var i = 0; i < addressComponent.length; i++) {
           									 for (var j = 0; j < addressComponent[i].types.length; j++) {
               									 if (addressComponent[i].types[j] == "postal_code") {
                		   						 console.log(addressComponent[i].long_name);
                		   						 newPincode = addressComponent[i].long_name;
               								 	}
           								 	}
        	    						 }
        							//alert("New Pincode in current Way Point :: " + newPincode);

									 currentWaypoint = {location: latlng, state: stat, country: cntry, city: cty, pincode:newPincode, add: add, stopover: true, type: ci.replace(/[0-9]/g, '')}


 		    }

			})

});


searchBoxWaypointGeneric.addListener('places_changed', function() {
		var places = searchBoxWaypointGeneric.getPlaces();
		if (places.length == 0) {
				return;
		}
		markers = [];
				// places.forEach(function(place) {
		  let place = places[0];
				if (!place.geometry) {
						return;
				}

				geocoder = new google.maps.Geocoder();
				var latlng = new google.maps.LatLng(place.geometry.location.lat(), place.geometry.location.lng());
 		    geocoder.geocode({'latLng': latlng}, function(results, status) {
 		      if (status == google.maps.GeocoderStatus.OK) {
					  var add= results[0].formatted_address ;
 		               var value=add.split(",");
 		               var c=value.length;
 		               var ci=value[c-3];


										var country=value[c-1];
										var state=value[c-2];
										var city=value[c-3];

										var cntry = country.replace(/[0-9]/g, '');
										var stat = state.replace(/[0-9]/g, '');
										var cty = city.replace(/[0-9]/g, '');

										stat=stat.toUpperCase();
										cntry=cntry.toUpperCase();
										cty=cty.toUpperCase();
										
										 var addressComponent = results[0].address_components;  
	             						 for (var i = 0; i < addressComponent.length; i++) {
           									 for (var j = 0; j < addressComponent[i].types.length; j++) {
               									 if (addressComponent[i].types[j] == "postal_code") {
                		   						 console.log(addressComponent[i].long_name);
                		   						 newPincode = addressComponent[i].long_name;
               								 	}
           								 	}
        	    						 }
        							//alert("New Pincode in current Way Point 12:: " + newPincode);

									 currentWaypoint = {location: latlng, state: stat, country: cntry, city: cty, pincode:newPincode, add: add, stopover: true, type: ci.replace(/[0-9]/g, '')}


 		    }

			})

});

function addWaypointExisting()
{
	if($("#waypointSelect").val()=="")
	{
		$("#waypointSelectSpan").addClass("redBorder");
		return;
	}
	else {
		$("#waypointSelectSpan").removeClass("redBorder");
	}


	$("#routeKeyInput").val("");
	$("#routeNameInput").val("");
	$("#routeKeyInput").removeClass("redBorder");
	$("#routeNameInput").removeClass("redBorder");
	var hub =  $("#waypointSelect option:selected");
	sourceMarker = new google.maps.Marker({
			map: map,
			title: "Waypoint",
			label: {
				text: "W" + (waypoints.length+1),
				color: "white",
				fontSize: "8px"
			},
			title: hub.attr("name"),
			position: new google.maps.LatLng(parseFloat(hub.attr("latitude")), parseFloat(hub.attr("longitude")))
	});
	waypoints.push({location: new google.maps.LatLng(parseFloat(hub.attr("latitude")), parseFloat(hub.attr("longitude"))), stopover: true,  type: "customerHub", name:hub.attr("name"), detention:hub.attr("detention"), radius:hub.attr("radius"), marker: sourceMarker });
	$("#waypoints").append("<div style='position:relative;margin-bottom:8px;'><span class='orangeText'>Waypoint&nbsp;"+(++currentWaypointNo)+":&nbsp;</span><br/>"+hub.attr("name") + "<button type='button' class='waypointCancel' onclick='waypointCancelClick("+(currentWaypointNo -1)+")'>&times;</button></div>");
	calcRouteWithWaypoints();
}

function addWaypointExistingGeneric()
{
	if($("#waypointSelectGeneric").val()=="")
	{
		$("#waypointSelectSpanGeneric").addClass("redBorder");
		return;
	}
	else {
		$("#waypointSelectSpanGeneric").removeClass("redBorder");
	}


	$("#routeKeyInput").val("");
	$("#routeNameInput").val("");
	$("#routeKeyInput").removeClass("redBorder");
	$("#routeNameInput").removeClass("redBorder");
	var hub =  $("#waypointSelectGeneric option:selected");
	sourceMarker = new google.maps.Marker({
			map: map,
			title: "Generic Waypoint",
			label: {
				text: "GW" + (waypoints.length+1),
				color: "white",
				fontSize: "8px"
			},
			title: hub.attr("name"),
			position: new google.maps.LatLng(parseFloat(hub.attr("latitude")), parseFloat(hub.attr("longitude")))
	});
	waypoints.push({location: new google.maps.LatLng(parseFloat(hub.attr("latitude")), parseFloat(hub.attr("longitude"))), stopover: true,  type: "genericHub", name:hub.attr("name"), detention:hub.attr("detention"), radius:hub.attr("radius"), marker: sourceMarker });
	$("#waypoints").append("<div style='position:relative;margin-bottom:8px;'><span class='orangeText'>Waypoint&nbsp;"+(++currentWaypointNo)+":&nbsp;</span><br/>"+hub.attr("name") + "<button type='button' class='waypointCancel' onclick='waypointCancelClick("+(currentWaypointNo -1)+")'>&times;</button></div>");
	calcRouteWithWaypoints();
}

function addWaypointNewGeneric()
{
	var error = "";
	if($("#waypointDetentionGeneric").val()=="")
	{
		$("#waypointDetentionGeneric").addClass("redBorder");
		error = "error";
	}
	else {
		$("#waypointDetentionGeneric").removeClass("redBorder");
	}

	if($("#waypointRadiusGeneric").val()=="")
	{
		$("#waypointRadiusGeneric").addClass("redBorder");
		error = "error";
	}
	else {
		$("#waypointRadiusGeneric").removeClass("redBorder");
	}

	if($("#waypointInputGeneric").val()=="")
	{
		$("#waypointInputGeneric").addClass("redBorder");
		error = "error";
	}
	else {
		$("#waypointInputGeneric").removeClass("redBorder");
	}
	if(error != ""){
		return;
	}
	$("#routeKeyInput").val("");
  $("#routeNameInput").val("");
	$("#routeKeyInput").removeClass("redBorder");
	$("#routeNameInput").removeClass("redBorder");
	currentWaypointMarker = new google.maps.Marker({
			map: map,
			// icon: icon,
			title: currentWaypoint.type,
			title: "Waypoint",
			label: {
				text: "GW" + (waypoints.length+1),
				color: "white",
				fontSize: "8px"
			},
			draggable:false,
			position: currentWaypoint.location
	});
	markers.push(currentWaypointMarker);

	waypoints.push({
		location: currentWaypoint.location,
		stopover: true,
		type: currentWaypoint.type,
		state: currentWaypoint.state,
		country: currentWaypoint.country,
		city: currentWaypoint.city,
		pincode:currentWaypoint.pincode,
		add: currentWaypoint.add,
		detention: $("#waypointDetentionGeneric").val(),
		radius: $("#waypointRadiusGeneric").val(),
		name: $("#waypointInputGeneric").val(),
		marker: currentWaypointMarker
	});

	var detentionRadiusDetails = "";

	detentionRadiusDetails = "<br/>Detention (HH:mm):&nbsp;"+$("#waypointDetentionGeneric").val()+"&nbsp;&nbsp;&nbsp;&nbsp;Radius (kms):" + $("#waypointRadiusGeneric").val()
	$("#waypoints").append("<div style='position:relative;margin-bottom:8px;'><span class='orangeText'>Waypoint&nbsp;"+(++currentWaypointNo)+":&nbsp;</span>(New Generic Hub)<br/>"+$("#waypointInputGeneric").val() + detentionRadiusDetails+ "<button type='button' class='waypointCancel' onclick='waypointCancelClick("+(currentWaypointNo -1)+")'>&times;</button></div>");
	$("#waypointDetention").val("");
	$("#waypointRadius").val("");
	$("#waypointInput").val("");
	calcRouteWithWaypoints();
}


function addWaypointNew()
{
	var error = "";
	if($("#waypointDetention").val()=="")
	{
		$("#waypointDetention").addClass("redBorder");
		error = "error";
	}
	else {
		$("#waypointDetention").removeClass("redBorder");
	}

	if($("#waypointRadius").val()=="")
	{
		$("#waypointRadius").addClass("redBorder");
		error = "error";
	}
	else {
		$("#waypointRadius").removeClass("redBorder");
	}

	if($("#waypointInput").val()=="")
	{
		$("#waypointInput").addClass("redBorder");
		error = "error";
	}
	else {
		$("#waypointInput").removeClass("redBorder");
	}
	if(error != ""){
		return;
	}
	$("#routeKeyInput").val("");
  $("#routeNameInput").val("");
	$("#routeKeyInput").removeClass("redBorder");
	$("#routeNameInput").removeClass("redBorder");
	currentWaypointMarker = new google.maps.Marker({
			map: map,
			// icon: icon,
			title: currentWaypoint.type,
			title: "Waypoint",
			label: {
				text: "W" + (waypoints.length+1),
				color: "white",
				fontSize: "8px"
			},
			draggable:false,
			position: currentWaypoint.location
	});
	markers.push(currentWaypointMarker);

	waypoints.push({
		location: currentWaypoint.location,
		stopover: true,
		type: currentWaypoint.type,
		state: currentWaypoint.state,
		country: currentWaypoint.country,
		city: currentWaypoint.city,
		pincode:currentWaypoint.pincode,
		add: currentWaypoint.add,
		detention: $("#waypointDetention").val(),
		radius: $("#waypointRadius").val(),
		name: $("#waypointInput").val(),
		marker: currentWaypointMarker
	});

	var detentionRadiusDetails = "";

	detentionRadiusDetails = "<br/>Detention (HH:mm):&nbsp;"+$("#waypointDetention").val()+"&nbsp;&nbsp;&nbsp;&nbsp;Radius (kms):" + $("#waypointRadius").val()
	$("#waypoints").append("<div style='position:relative;margin-bottom:8px;'><span class='orangeText'>Waypoint&nbsp;"+(++currentWaypointNo)+":&nbsp;</span>(New Hub)<br/>"+$("#waypointInput").val() + detentionRadiusDetails+ "<button type='button' class='waypointCancel' onclick='waypointCancelClick("+(currentWaypointNo -1)+")'>&times;</button></div>");
	$("#waypointDetention").val("");
	$("#waypointRadius").val("");
	$("#waypointInput").val("");
	calcRouteWithWaypoints();
}

function waypointCancelClick(id)
{
	if(waypoints[id].marker != null)
	{
		waypoints[id].marker.setMap(null);
	}
	waypoints.splice(id, 1);
	$("#waypoints").html("");
	currentWaypointNo = 0;
	var newHub = "";
	var detentionRadiusDetails = "";

	$("#routeKeyInput").val("");
	$("#routeNameInput").val("");
	$("#routeKeyInput").removeClass("redBorder");
	$("#routeNameInput").removeClass("redBorder");
	for(var x=0; x< waypoints.length; x++)
	{
		if(waypoints[x].type != "customerHub" && waypoints[x].type != "smartHub" && waypoints[x].type != "genericHub")
		{
			newHub = "(New Hub)";
			detentionRadiusDetails = "<br/>Detention (HH:mm):&nbsp;"+waypoints[x].detention+"&nbsp;&nbsp;&nbsp;&nbsp;Radius (kms):" + waypoints[x].radius
		}
		else {
			newHub = "";
			detentionRadiusDetails = "";
		}

		var hubType = "Waypoint";
		if(waypoints[x].type == "smartHub"){
			hubType = "Smart Hub";
			waypoints[x].marker.setLabel(
			{
				text: "SH" + (x+1),
				color: "white",
				fontSize: "8px"
			})
		} else {
			waypoints[x].marker.setLabel(
			{
				text: "W" + (x+1),
				color: "white",
				fontSize: "8px"
			})

		}

		$("#waypoints").append("<div style='position:relative;margin-bottom:8px;'><span class='orangeText'>"+hubType+"&nbsp;"+(++currentWaypointNo)+":&nbsp;</span>"+ newHub+"<br/>"+waypoints[x].name + detentionRadiusDetails +"<button type='button' class='waypointCancel' onclick='waypointCancelClick("+(currentWaypointNo -1)+")'>&times;</button></div>");

	}
	calcRouteWithWaypoints();
}

function showSmartHubs()
{
	 for (var i = 0; i < smartHubs.length; i++) {
			// Create a marker for each place.
			var hub = smartHubs[i];
		latitude = parseFloat(hub.latitude);
			longitude = parseFloat(hub.longitude);
			var smartHub = new google.maps.Marker({
					map: map,
					icon: new google.maps.MarkerImage('axis.svg',
		null, null, null, new google.maps.Size(30,30)),
					title: hub.buffername,
					position: {lat: latitude, lng: longitude}
			});


			smartHub.addListener('click', function(event, i) {

				for (var j = 0; j < smartHubs.length; j++) {
					var hub = smartHubs[j];
					var lat = parseFloat(hub.latitude).toFixed(2);
					var lng = parseFloat(hub.longitude).toFixed(2);

					if(event.latLng.lat().toFixed(2) == lat && event.latLng.lng().toFixed(2) == lng){
						mark = new google.maps.Marker({
								map: map,
								title: "SmartHub",
								label: {
									text: "SH" + (waypoints.length+1),
									color: "white",
									fontSize: "8px"
								},
								title: hub.buffername,
								position: new google.maps.LatLng(event.latLng.lat(), event.latLng.lng())
						});
						$("#routeKeyInput").val("");
						$("#routeNameInput").val("");
						$("#routeKeyInput").removeClass("redBorder");
						$("#routeNameInput").removeClass("redBorder");
						waypoints.push({location: new google.maps.LatLng(event.latLng.lat(), event.latLng.lng()), stopover: true, type: "smartHub", name: hub.buffername, detention:hub.detention, radius:hub.radius, marker: mark});
						$("#waypoints").append("<div style='position:relative;margin-bottom:8px;'><span class='orangeText'>Smart Hub&nbsp;"+(++currentWaypointNo)+":&nbsp;</span><br/>"+hub.buffername+ "<button type='button' class='waypointCancel' onclick='waypointCancelClick("+(currentWaypointNo -1)+")'>&times;</button></div>");
						break;
					}
				}

				calcRouteWithWaypoints();
			});

			markers.push(smartHub);
	}
}



  function calcRouteWithWaypoints() {

    if (sourceStart != "" && destinationEnd != "") {

			var waypointsTemp = [];
			for(var x=0; x< waypoints.length; x++)
			{
				var wayPt = {
					location: waypoints[x].location,
				  stopover: waypoints[x].stopover
				}
				waypointsTemp.push(wayPt)

      }

      directionsService.route({
         origin: sourceStart,
         destination: destinationEnd,
         waypoints: waypointsTemp,
         travelMode: 'DRIVING'
       }, function(response, status) {
         if (status === 'OK') {
           directionsDisplay.setDirections(response);
           computeTotalDistance(directionsDisplay.getDirections());
         } else {
          // alert('Could not display directions due to: ' + status);
         }
       });
    }
  }

  function calcRoute() {
      if (sourceStart != "" && destinationEnd != "") {
				var waypointsTemp = [];
				for(var x=0; x< waypoints.length; x++)
				{
					var wayPt = {
						location: waypoints[x].location,
						stopover: waypoints[x].stopover
					}
					waypointsTemp.push(wayPt)

				}
        directionsService.route({
           origin: sourceStart,
           destination: destinationEnd,
           waypoints: waypointsTemp,
           travelMode: 'DRIVING'
         }, function(response, status) {
           if (status === 'OK') {
             directionsDisplay.setDirections(response);
             computeTotalDistance(directionsDisplay.getDirections());
             showSmartHubs();
           } else {
            // alert('Could not display directions due to: ' + status);
           }
         });
      }
		}


		function computeTotalDistance(result) {
	          var total = 0;
	          var myroute = result.routes[0];
						for (var i = 0; i < myroute.legs.length; i++) {
	            total += myroute.legs[i].distance.value;
	          }
	          total = total / 1000;
					  $("#distanceInput").val(total);
	          if($("#tatInput").val() != "")
	          {
	            calculateAvgSpeed();
	          }

	   }

		 $("#sourceRadius").on('change', function() {
			 if(parseInt($("#sourceRadius").val()) > 9){
				 sweetAlert("Please enter single digit radius");
				 $("#sourceRadius").val("");
				 $("#sourceRadius").focus();
				 return;
			 }
			 if(parseInt($("#sourceRadius").val()) < 0){
				 sweetAlert("Please enter positive radius");
				 $("#sourceRadius").val("");
				 $("#sourceRadius").focus();
				 return;
			 }
		})

		$("#destRadius").on('change', function() {
			if(parseInt($("#destRadius").val()) > 9){
				sweetAlert("Please enter single digit radius");
				$("#destRadius").val("");
				$("#destRadius").focus();
				return;
			}
			if(parseInt($("#destRadius").val()) < 0){
				sweetAlert("Please enter positive radius");
				$("#destRadius").val("");
				$("#destRadius").focus();
				return;
			}
	 })

	 $("#waypointRadius").on('change', function() {
		if(parseInt($("#waypointRadius").val()) > 9){
			 sweetAlert("Please enter single digit radius");
			 $("#waypointRadius").val("");
			 $("#waypointRadius").focus();
			 return;
		 }
		 if(parseInt($("#waypointRadius").val()) < 0){
 			 sweetAlert("Please enter positive radius");
 			 $("#waypointRadius").val("");
 			 $("#waypointRadius").focus();
 			 return;
 		 }
	})


		 $("#sourceDetention").on('change', function() {
			  var patt = new RegExp("^([0-9]|0[0-9]|1[0-9]|2[0-3]):[0-5][0-9]$");
	 		 	var res = patt.test($("#sourceDetention").val());
	 		 	if(!res || $("#sourceDetention").val().split(":").length != 2){
	 		 		sweetAlert("Please enter source detention in HH:mm format");
	 		 		$("#sourceDetention").val("");
	 		 		$("#sourceDetention").focus();
	 		 		return;
	 		 	}
		 })

		 $("#destDetention").on('change', function() {
			 var patt = new RegExp("^([0-9]|0[0-9]|1[0-9]|2[0-3]):[0-5][0-9]$");
			 var res = patt.test($("#destDetention").val());
			 if(!res || $("#destDetention").val().split(":").length != 2){
				 sweetAlert("Please enter destination detention in HH:mm format");
				 $("#destDetention").val("");
				 $("#destDetention").focus();
				 return;
			 }
		 })

		 $("#waypointDetention").on('change', function() {
			 var patt = new RegExp("^([0-9]|0[0-9]|1[0-9]|2[0-3]):[0-5][0-9]$");
			 var res = patt.test($("#waypointDetention").val());
			 if(!res || $("#waypointDetention").val().split(":").length != 2){
				 sweetAlert("Please enter waypoint detention in HH:mm format");
				 $("#waypointDetention").val("");
				 $("#waypointDetention").focus();
				 return;
			 }
		 })
        $("#routeNameInput").on('change', function() {
             $.ajax({
                     url: '<%=request.getContextPath()%>/QTPAction.do?param=checkRouteExists',
                     data:{
                       routeName :  $('#routeNameInput').val(),
                       tripCustId : $('#addcustNameDownID').val()
                     },
                     success: function(response) {
                       if(response=='true'){
                          sweetAlert("Route already exists");
                       }
                    }
                  });
         });

		 $("#tatInput").on('change', function() {
		 	 calculateAvgSpeed();
		 });

		 function calculateAvgSpeed()
		 {
		 	var patt = new RegExp("[0-9]:[0-5][0-9]$");
		 	var res = patt.test($("#tatInput").val());
		 	if(!res || $("#tatInput").val().split(":").length != 2){
		 		sweetAlert("Please enter TAT in HH:mm format");
		 		$("#tatInput").val("");
		 		$("#tatInput").focus();
		 		return;
		 	}
		 	var tempTat = $("#tatInput").val().split(":");
			var effectiveTat = (parseInt(tempTat[0]) + (parseInt(tempTat[1])/60));
			var wayPointTotalTat = 0;

			for(var x=0; x< waypoints.length; x++)
			{

				var tempDetention = waypoints[x].detention.split(":");
				var interTat = 0;
				if(tempDetention.length == 1)
				{
						interTat = parseInt(tempDetention[0])/60;
				}
				else {
						interTat = parseInt(tempDetention[0]) + (parseInt(tempDetention[1])/60);
				}
				wayPointTotalTat += interTat;


			}

		 	var avgSpeed = ($("#distanceInput").val()/(effectiveTat - wayPointTotalTat)).toFixed(2);
		 	$("#avgSpeedInput").val(avgSpeed);
		 }

		 $.ajax({
		      type: "POST",
		      url: '<%=request.getContextPath()%>/LegCreationAction.do?param=getSmartHubBuffer',
		      success: function(result) {
		        smartHubs = JSON.parse(result).BufferMapView;
		      }
		 })

		 $("#sourceSelect").on('change', function() {
			 $("#routeKeyInput").val("");
			 $("#routeNameInput").val("");
			 $("#routeKeyInput").removeClass("redBorder");
			 $("#routeNameInput").removeClass("redBorder");
			 	if($("#sourceSelect").val() != ""){
							 var hub =  $("#sourceSelect option:selected");

							 // Create a marker for each place.
							 if(sourceMarker != null)
							 {
								 sourceMarker.setMap(null);
							 }
							 sourceMarker = new google.maps.Marker({
									 map: map,
									 title: hub.attr("name"),
									 title: "Source",
									 icon: "http://www.google.com/mapfiles/dd-start.png",
									 position: {lat: parseFloat(hub.attr("latitude")), lng: parseFloat(hub.attr("longitude"))}
							 });
							 $("#source").html("<span class='greenText'>SOURCE:&nbsp;</span> "+hub.attr("name"));
							 $("#legListDiv").show();
							 markers.push(sourceMarker);
							 sourceStart = new google.maps.LatLng(parseFloat(hub.attr("latitude")), parseFloat(hub.attr("longitude")));
							 calcRoute()
						 }
						 })

						 $("#destSelect").on('change', function() {
							 $("#routeKeyInput").val("");
							 $("#routeNameInput").val("");
							 $("#routeKeyInput").removeClass("redBorder");
							 $("#routeNameInput").removeClass("redBorder");
							 	if($("#destSelect").val() != ""){
										 var hub =  $("#destSelect option:selected");

										 // Create a marker for each place.
										 if(destinationMarker != null)
										 {
											 destinationMarker.setMap(null);
										 }
										 destinationMarker = new google.maps.Marker({
												 map: map,
												 title: "Destination",
							 					 icon: "http://www.google.com/mapfiles/dd-end.png",
												 title: hub.attr("name"),
												 position: {lat: parseFloat(hub.attr("latitude")), lng: parseFloat(hub.attr("longitude"))}
										 });
										 markers.push(destinationMarker);
										 $("#destination").html("<span class='redText'>DESTINATION:&nbsp;</span>"+hub.attr("name"));
										 destinationEnd = new google.maps.LatLng(parseFloat(hub.attr("latitude")), parseFloat(hub.attr("longitude")));
										 calcRoute()

						 }
		 })

		 $("#sourceSelectGeneric").on('change', function() {
			$("#routeKeyInput").val("");
			$("#routeNameInput").val("");
			$("#routeKeyInput").removeClass("redBorder");
			$("#routeNameInput").removeClass("redBorder");
			 if($("#sourceSelectGeneric").val() != ""){
							var hub =  $("#sourceSelectGeneric option:selected");

							// Create a marker for each place.
							if(sourceMarker != null)
							{
								sourceMarker.setMap(null);
							}
							sourceMarker = new google.maps.Marker({
									map: map,
									title: hub.attr("name"),
									title: "Source Generic",
									icon: "http://www.google.com/mapfiles/dd-start.png",
									position: {lat: parseFloat(hub.attr("latitude")), lng: parseFloat(hub.attr("longitude"))}
							});
							$("#source").html("<span class='greenText'>SOURCE:&nbsp;</span> "+hub.attr("name"));
							$("#legListDiv").show();
							markers.push(sourceMarker);
							sourceStart = new google.maps.LatLng(parseFloat(hub.attr("latitude")), parseFloat(hub.attr("longitude")));
							calcRoute()
						}
						})

						$("#destSelectGeneric").on('change', function() {
							$("#routeKeyInput").val("");
							$("#routeNameInput").val("");
							$("#routeKeyInput").removeClass("redBorder");
							$("#routeNameInput").removeClass("redBorder");
							 if($("#destSelectGeneric").val() != ""){
										var hub =  $("#destSelectGeneric option:selected");

										// Create a marker for each place.
										if(destinationMarker != null)
										{
											destinationMarker.setMap(null);
										}
										destinationMarker = new google.maps.Marker({
												map: map,
												title: "Destination Generic",
												icon: "http://www.google.com/mapfiles/dd-end.png",
												title: hub.attr("name"),
												position: {lat: parseFloat(hub.attr("latitude")), lng: parseFloat(hub.attr("longitude"))}
										});
										markers.push(destinationMarker);
										$("#destination").html("<span class='redText'>DESTINATION:&nbsp;</span>"+hub.attr("name"));
										destinationEnd = new google.maps.LatLng(parseFloat(hub.attr("latitude")), parseFloat(hub.attr("longitude")));
										calcRoute()

						}
		})

    $("#routeKeyInput").on("change", function(){
			var patt = $("#routeKeyInput").val().split("_");
	 		if(patt.length != 2){
	 			sweetAlert("Please enter route key in the following format: sourceCity_destinationCity");
	 			$("#routeKeyInput").val("");
	 			$("#routeKeyInput").focus();
				$("#routeKeyDiv").css({"width":"51%"})
				$("#getRouteIdDiv").hide()
				$("#routeNameInput").val("");

	 			return;
	 		}
			else {
				$("#routeKeyDiv").css({"width":"45%"})
				$("#getRouteIdDiv").show()

			}

		})




		 function getRouteId(){
		   var error = "";

		   if($("#addcustNameType").val()=="0")
		   {
		     $("#addcustNameType").addClass("redBorder");
		     error = "error";
		   }
		   else {
		     $("#addcustNameType").removeClass("redBorder");
		   }

		   if($("#addcustNameDownID").val()=="0" || $("#addcustNameDownID").val()=="")
		   {
		     $("#addcustNameDownIDDiv").addClass("redBorder");
		     error = "error";
		   }
		   else {
		     $("#addcustNameDownIDDiv").removeClass("redBorder");
		   }

		   if($("#tatInput").val()=="")
		   {
		     $("#tatInput").addClass("redBorder");
		     error = "error";
		   }
		   else {
		     $("#tatInput").removeClass("redBorder");
		   }

		   if($("#routeKeyInput").val()=="")
		   {
		     $("#routeKeyInput").addClass("redBorder");
		     error = "error";
		   }
		   else {
		     $("#routeKeyInput").removeClass("redBorder");
		   }

		   if ($('#addSourceCombo').val() == "0") {
		     if($("#sourceDetention").val()=="")
		     {
		       $("#sourceDetention").addClass("redBorder");
		       error = "error";
		     }
		     else {
		       $("#sourceDetention").removeClass("redBorder");
		     }

		     if($("#sourceInput").val()=="")
		     {
		       $("#sourceInput").addClass("redBorder");
		       error = "error";
		     }
		     else {
		       $("#sourceInput").removeClass("redBorder");
		     }

		   }

		   if ($('#addDestCombo').val() == "0") {
		     if($("#destDetention").val()=="")
		     {
		       $("#destDetention").addClass("redBorder");
		       error = "error";
		     }
		     else {
		       $("#destDetention").removeClass("redBorder");
		     }

		     if($("#destInput").val()=="")
		     {
		       $("#destInput").addClass("redBorder");
		       error = "error";
		     }
		     else {
		       $("#destInput").removeClass("redBorder");
		     }
		   }

		   if ($('#addSourceCombo').val() == "1") {
		     if($("#sourceSelect").val()=="" || $("#sourceSelect").val()==null )
		     {
		       $("#sourceSelectSpan").addClass("redBorder");
		       error = "error";
		     }
		     else {
		       $("#sourceSelectSpan").removeClass("redBorder");
		     }

		   }

		   if ($('#addDestCombo').val() == "1") {
		     if($("#destSelect").val()=="" || $("#destSelect").val()==null )
		     {
		       $("#destSelectSpan").addClass("redBorder");
		       error = "error";
		     }
		     else {
		       $("#destSelectSpan").removeClass("redBorder");
		     }
		   }

		   if(error != ""){return;}

			 var patt = $("#routeKeyInput").val().split("_");
 			if(patt.length != 2){
 				sweetAlert("Please enter route key in the following format: sourceCity_destinationCity");
 				$("#routeKeyInput").val("");
 				$("#routeKeyInput").focus();
 				return;
 			}

		   $("#loading").show();
		   var sourceCity = "";
		   var destCity= "";

		   geocoder = new google.maps.Geocoder();
		   var latlng = new google.maps.LatLng(sourceStart.lat(), sourceStart.lng());
		  geocoder.geocode({'latLng': latlng}, function(results, status) {
		      if (status == google.maps.GeocoderStatus.OK) {
		        var add= results[0].formatted_address ;
		               var value=add.split(",");
		               count=value.length;
		               city=value[count-3];
		       sourceCity = city.replace(/[0-9]/g, '');
		      }
		      var latlng = new google.maps.LatLng(destinationEnd.lat(), destinationEnd.lng());
		      geocoder.geocode({'latLng': latlng}, function(results, status) {
		        if (status == google.maps.GeocoderStatus.OK) {
		          var add= results[0].formatted_address ;
		               var value=add.split(",");
		               count=value.length;
		               city=value[count-3];
		       destCity = city.replace(/[0-9]/g, '');

		        var touchPointArray = [];
		        for(var x=0; x< waypoints.length; x++)
		        {
		          var sourceLat  = waypoints[x].location.lat().toFixed(2); //source latitude
		          var sourceLng  = waypoints[x].location.lng().toFixed(2); //source longitude

		          		if(waypoints[x].type == "smartHub")
									{
						          for (var j = 0; j < smartHubs.length; j++) {
						            var hub = smartHubs[j];
						            var lat = parseFloat(hub.latitude).toFixed(2);
						            var lng = parseFloat(hub.longitude).toFixed(2);

						            if(sourceLat == lat && sourceLng == lng){
						              touchPointArray.push('{' + (x + 1) + ',' +hub.hubId + ','+ 'smartHub' + '}');
						              break;
						            }
						          }
								}
								else if (waypoints[x].type == "customerHub") {
										for (var j = 0; j < hubList.length; j++) {
										 var hub = hubList[j];
										 var lat = parseFloat(hub.latitude).toFixed(2);
										 var lng = parseFloat(hub.longitude).toFixed(2);

										 if(sourceLat == lat && sourceLng == lng){
											 touchPointArray.push('{' + (x + 1) + ',' +hub.Hub_Id + ','+ 'customerHub' + '}');
											 break;
										 }
									 }
								} else if (waypoints[x].type == "genericHub") {
										for (var j = 0; j < hubList.length; j++) {
										 var hub = hubList[j];
										 var lat = parseFloat(hub.latitude).toFixed(2);
										 var lng = parseFloat(hub.longitude).toFixed(2);

										 if(sourceLat == lat && sourceLng == lng){
											 touchPointArray.push('{' + (x + 1) + ',' +hub.Hub_Id + ','+ 'Generic Hub' + '}');
											 break;
										 }
									 }
								} else {

									if ($('#addWaypointsCombo').val() == "2")
									{
										touchPointArray.push('{' + (x + 1) + ',' +waypoints[x].type+ ','+ 'Generic Hub' + '}');
									}
									else {
										touchPointArray.push('{' + (x + 1) + ',' +waypoints[x].type+ ','+ 'customerHub' + '}');
									}

								}

		        }
						var sourceCityType = "New Hub";
						var sourecHub = $('#sourceSelect').val();
						var destHub =$('#destSelect').val();
				if ($('#addSourceCombo').val() == "2" || $('#addSourceCombo').val() == "3") {
				sourceCityType = "Generic Hub"
				}
				var destCityType = "New Hub";
				if ($('#addDestCombo').val() == "2" || $('#addDestCombo').val() == "3") {
				destCityType = "Generic Hub"
				}
				if($('#addSourceCombo').val() == "3"){
					sourecHub = $('#sourceSelectGeneric').val();
				}
				if ($('#addDestCombo').val() == "3") {
					destHub = $('#destSelectGeneric').val();
				}
		        $.ajax({
		             url: '<%=request.getContextPath()%>/QTPAction.do?param=generateRouteID',
		             data:{
		               custId: <%=customerId%>,
		               routeKey :  $('#routeKeyInput').val(),
		               TAT : $('#tatInput').val(),
		               sourceHub : sourecHub,
		               destHub : destHub,
		               sourceCity : sourceCity,
		               destCity: destCity,
					   sourceCityType: sourceCityType,
					   destCityType: destCityType,
		               touchPointArray : JSON.stringify(touchPointArray),
		               tripCustId : $('#addcustNameDownID').val()
		             },
		             success: function(response) {
									 console.log("Route Id Response",response);
		               result = JSON.parse(response).routeIdRoot;
									 if(result != ""){
										 var rid = result[0].routeId;
										 $("#routeNameInput").val(rid);
			               if(result[0].isComplete==false){
			                 $("#routeNameInput").addClass("redBorder");
			               }
								   }
									 else {
									 	sweetAlert("Error generating route Id")
									 }
		               $("#loading").hide();
		            }
		          });
		        }
		      })
		    });
		 }

		 function resetExisting()
		 {


			 if(directionsDisplayExisting != null) {

				 $("#existingRouteDropDown").val('').trigger('change');
				 $("#mapExisting").html("");
				initialize();
					directionsDisplayExisting.setMap(null);
					directionsDisplayExisting = null;
					directionsDisplayExisting = new google.maps.DirectionsRenderer({
						map: mapExisting
					});
			}






		 }

		 function reset()
		 {

			 if(directionsDisplay != null) {
				 $("#tatInput").val("");
			   $("#distanceInput").val("");
			   $("#avgSpeedInput").val("");
			   $("#routeKeyInput").val("");
			   $("#routeNameInput").val("");
			   $("#sourceDetention").val("");
			   $("#destDetention").val("");
				 $("#waypointDetention").val("");
			   $("#sourceInput").val("");
			   $("#destInput").val("");
				 $("#waypointDetention").val("");
				 $("#sourceRadius").val("");
			   $("#destRadius").val("");
				 $("#waypointRadius").val("");
			   $("#sourceSelect").val('').trigger('change');
			   $("#destSelect").val('').trigger('change');
				 $("#waypointSelect").val('').trigger('change');
				 $("#source").html("");
				 $("#waypoints").html("");
				 $("#destination").html("");
				 $("#legListDiv").hide();
				 
				 $("#sourceDetentionGeneric").val("");
				 $("#destDetentionGeneric").val("");
				 $("#waypointDetentionGeneric").val("");
				 $("#sourceInputGeneric").val("");
				 $("#destInputGeneric").val("");
				 $("#sourceRadiusGeneric").val("30");
				 $("#destRadiusGeneric").val("30");
				 $("#waypointRadiusGeneric").val("30");
				 $("#sourceSelectGeneric").val('').trigger('change');
				 $("#destSelectGeneric").val('').trigger('change');
				 $("#waypointSelectGeneric").val('').trigger('change');


			   waypoints = [];
				 markers  = [];
				 hubDetails = [];
				 sourceMarker = null;
				 destinationMarker = null;
				 sourceStart = "";
				 destinationEnd = "";

				 $("#map").html("");
				 initialize();
			    directionsDisplay.setMap(null);
			    directionsDisplay = null;
					directionsDisplay = new google.maps.DirectionsRenderer({
	 		     draggable: true,
					 suppressMarkers: true,
	 		     map: map
	 		   });

			}





		 }

var wDetention = "";
var wRadius = "";
var wLocation = null;
		 function freeze(){

		   var error = "";

		   if($("#addcustNameType").val()=="0")
		   {
		     $("#addcustNameType").addClass("redBorder");
		     error = "error";
		   }
		   else {
		     $("#addcustNameType").removeClass("redBorder");
		   }

		   if($("#addcustNameDownID").val()=="0" || $("#addcustNameDownID").val()=="")
		   {
		     $("#addcustNameDownIDDiv").addClass("redBorder");
		     error = "error";
		   }
		   else {
		     $("#addcustNameDownIDDiv").removeClass("redBorder");
		   }

		   if($("#tatInput").val()=="")
		   {
		     $("#tatInput").addClass("redBorder");
		     error = "error";
		   }
		   else {
		     $("#tatInput").removeClass("redBorder");
		   }

		   if($("#routeKeyInput").val()=="")
		   {
		     $("#routeKeyInput").addClass("redBorder");
		     error = "error";
		   }
		   else {
		     $("#routeKeyInput").removeClass("redBorder");
		   }

		   if($("#routeNameInput").val()=="")
		   {
		     $("#routeNameInput").addClass("redBorder");
		     error = "error";
		   }
		   else {
		     $("#routeNameInput").removeClass("redBorder");
		   }

		   if ($('#addSourceCombo').val() == "0") {
		     if($("#sourceDetention").val()=="")
		     {
		       $("#sourceDetention").addClass("redBorder");
		       error = "error";
		     }
		     else {
		       $("#sourceDetention").removeClass("redBorder");
		     }

		     if($("#sourceRadius").val()=="")
		     {
		       $("#sourceRadius").addClass("redBorder");
		       error = "error";
		     }
		     else {
		       $("#sourceRadius").removeClass("redBorder");
		     }

		     if($("#sourceInput").val()=="")
		     {
		       $("#sourceInput").addClass("redBorder");
		       error = "error";
		     }
		     else {
		       $("#sourceInput").removeClass("redBorder");
		     }

		   }

			 if ($('#addSourceCombo').val() == "2") {
				if($("#sourceDetentionGeneric").val()=="")
				{
					$("#sourceDetentionGeneric").addClass("redBorder");
					error = "error";
				}
				else {
					$("#sourceDetentionGeneric").removeClass("redBorder");
				}

				if($("#sourceRadiusGeneric").val()=="")
				{
					$("#sourceRadiusGeneric").addClass("redBorder");
					error = "error";
				}
				else {
					$("#sourceRadiusGeneric").removeClass("redBorder");
				}

				if($("#sourceInputGeneric").val()=="")
				{
					$("#sourceInputGeneric").addClass("redBorder");
					error = "error";
				}
				else {
					$("#sourceInputGeneric").removeClass("redBorder");
				}

			}

		  if ($('#addDestCombo').val() == "0") {
		     if($("#destDetention").val()=="")
		     {
		       $("#destDetention").addClass("redBorder");
		       error = "error";
		     }
		     else {
		       $("#destDetention").removeClass("redBorder");
		     }

		     if($("#destRadius").val()=="")
		     {
		       $("#destRadius").addClass("redBorder");
		       error = "error";
		     }
		     else {
		       $("#destRadius").removeClass("redBorder");
		     }


		     if($("#destInput").val()=="")
		     {
		       $("#destInput").addClass("redBorder");
		       error = "error";
		     }
		     else {
		       $("#destInput").removeClass("redBorder");
		     }
		   }

			 if ($('#addDestCombo').val() == "2") {
					if($("#destDetentionGeneric").val()=="")
					{
						$("#destDetentionGeneric").addClass("redBorder");
						error = "error";
					}
					else {
						$("#destDetentionGeneric").removeClass("redBorder");
					}

					if($("#destRadiusGeneric").val()=="")
					{
						$("#destRadiusGeneric").addClass("redBorder");
						error = "error";
					}
					else {
						$("#destRadiusGeneric").removeClass("redBorder");
					}


					if($("#destInputGeneric").val()=="")
					{
						$("#destInputGeneric").addClass("redBorder");
						error = "error";
					}
					else {
						$("#destInputGeneric").removeClass("redBorder");
					}
				}


		   if ($('#addSourceCombo').val() == "1") {
		     if($("#sourceSelect").val()=="" || $("#sourceSelect").val()==null )
		     {
		       $("#sourceSelectSpan").addClass("redBorder");
		       error = "error";
		     }
		     else {
		       $("#sourceSelectSpan").removeClass("redBorder");
		     }

		   }

			 if ($('#addSourceCombo').val() == "3") {
		     if($("#sourceSelectGeneric").val()=="" || $("#sourceSelectGeneric").val()==null )
		     {
		       $("#sourceSelectSpanGeneric").addClass("redBorder");
		       error = "error";
		     }
		     else {
		       $("#sourceSelectSpanGeneric").removeClass("redBorder");
		     }

		   }

		   if ($('#addDestCombo').val() == "1") {
		     if($("#destSelect").val()=="" || $("#destSelect").val()==null )
		     {
		       $("#destSelectSpan").addClass("redBorder");
		       error = "error";
		     }
		     else {
		       $("#destSelectSpan").removeClass("redBorder");
		     }
		   }

			 if ($('#addDestCombo').val() == "3") {
		     if($("#destSelectGeneric").val()=="" || $("#destSelectGeneric").val()==null )
		     {
		       $("#destSelectGeneric").addClass("redBorder");
		       error = "error";
		     }
		     else {
		       $("#destSelectGeneric").removeClass("redBorder");
		     }
		   }
		   if(error != ""){return;}

			 if($("#routeNameInput").val().split("***").length > 1)
			 {
				 sweetAlert("Please correct the Route Id.");
				 $("#routeNameInput").addClass("redBorder");
				 return;
			 }
			 else {
			 	 $("#routeNameInput").removeClass("redBorder");
			 }



		   $("#loading").show();

       	var geocoder = new google.maps.Geocoder();
		   if ($('#addSourceCombo').val() == "0" || $('#addSourceCombo').val() == "2") {
		     var latlng = new google.maps.LatLng(sourceStart.lat(), sourceStart.lng());
		     geocoder.geocode({'latLng': latlng}, function(results, status) {
		        if (status == google.maps.GeocoderStatus.OK) {
		           var add= results[0].formatted_address ;
		           var value=add.split(",");
		           count=value.length;

			     var addressComponent = results[0].address_components;  
	             for (var i = 0; i < addressComponent.length; i++) {
           			 for (var j = 0; j < addressComponent[i].types.length; j++) {
               			 if (addressComponent[i].types[j] == "postal_code") {
                		    console.log(addressComponent[i].long_name);
                		    newPincode = addressComponent[i].long_name;
               			 }
           			 }
        	     }
        		//alert("New Pincode :: " + newPincode);

		           country=value[count-1];
		           state=value[count-2];
		           city=value[count-3];

		           var cntry = country.replace(/[0-9]/g, '');
		           var stat = state.replace(/[0-9]/g, '');
		           var cty = city.replace(/[0-9]/g, '');

		           stat=stat.toUpperCase();
		           cntry=cntry.toUpperCase();
		           cty=cty.toUpperCase();
							 var geofenceType = "Customer Hub";
							 var sourceDetention = "";
							 var sourceRadius = "";

			 		     if ($('#addSourceCombo').val() == "2") {
								 geofenceType = "Generic Hub";
								 sourceDetention = $('#sourceDetentionGeneric').val();
								 sourceRadius = $('#sourceRadiusGeneric').val();
							 }
							 else {
								 sourceDetention = $('#sourceDetention').val();
  							 sourceRadius = $('#sourceRadius').val();
							 }
		           params = {
		             CustID: <%=customerId%>,
		             locationName:sourcePlaceObject.formatted_address ,
		             locationType: 32,
		             geofenceType: geofenceType,
		             radius:  sourceRadius,
		             latitude: sourcePlaceObject.geometry.location.lat(),
		             longitude: sourcePlaceObject.geometry.location.lng(),
		             gmt: "",
		             standardDuration: sourceDetention,
		             state: stat,
		             country: cntry,
		             city: cty,
		             pincode:newPincode,
		             isModify: false,
		             hubId: 0,
		             id: 0,
		             pageName: '',
		             checkBoxValue: true,
		             tripCustomerId: $('#addcustNameDownID').val(),
		             region: '',
		             area: '',
		             contactPerson: '',
		             address: sourcePlaceObject.formatted_address ,
		             desc: '',
					 sequence: 0
		           }
		           hubDetails.push(params);
		        }
		      })
		   }
			 else {

				 if ($('#addSourceCombo').val() == "1") {
			 	   hubDetails.push({
						 hubId: $('#sourceSelect').val(),
						 type: "customerHub",
						 sequence: 0
					 })
				 }
				 else {
					 hubDetails.push({
						 hubId: $('#sourceSelectGeneric').val(),
						 type: "Generic Hub",
						 sequence: 0
					 })

				 }
			 }

			 for(var x=0; x< waypoints.length; x++)
			 {
				  var sourceLat  = waypoints[x].location.lat().toFixed(2); //source latitude
				 var sourceLng  = waypoints[x].location.lng().toFixed(2); //source longitude

						 if(waypoints[x].type == "smartHub")
						 {
								 for (var j = 0; j < smartHubs.length; j++) {
									 var hub = smartHubs[j];
									 var lat = parseFloat(hub.latitude).toFixed(2);
									 var lng = parseFloat(hub.longitude).toFixed(2);

									 if(sourceLat == lat && sourceLng == lng){
										 hubDetails.push({
											 hubId: hub.hubId,
											 type: "smartHub",
											 sequence: hubDetails.length + 1
										 })
										 break;
									 }
								 }
					 }
					 else if (waypoints[x].type == "customerHub") {
							 for (var j = 0; j < hubList.length; j++) {
								var hub = hubList[j];
								var lat = parseFloat(hub.latitude).toFixed(2);
								var lng = parseFloat(hub.longitude).toFixed(2);

								if(sourceLat == lat && sourceLng == lng){
									hubDetails.push({
										hubId: hub.Hub_Id,
										type: "customerHub",
										 sequence: hubDetails.length + 1
									})
									break;
								}
							}
					 } else if (waypoints[x].type == "genericHub") {
							 for (var j = 0; j < hubList.length; j++) {
								var hub = hubList[j];
								var lat = parseFloat(hub.latitude).toFixed(2);
								var lng = parseFloat(hub.longitude).toFixed(2);

								if(sourceLat == lat && sourceLng == lng){
									hubDetails.push({
										hubId: hub.Hub_Id,
										type: "Generic Hub",
										 sequence: hubDetails.length + 1
									})
									break;
								}
							}
					 } else {
						 var geofenceType = 'Customer Hub';
						  if ($('#addWaypointsCombo').val() == "2") {
								geofenceType = 'Generic Hub';
							}
						 wRadius = waypoints[x].radius;
						 wDetention = waypoints[x].detention;
						 wLocation = waypoints[x].location;
						 params = {
							CustID: <%=customerId%>,
							locationName:waypoints[x].add ,
							locationType: 32,
							geofenceType: geofenceType,
							radius:  wRadius,
							latitude: wLocation.lat(),
							longitude: wLocation.lng(),
							gmt: "",
							standardDuration: wDetention,
							state:  waypoints[x].state,
							country:  waypoints[x].country,
							city:  waypoints[x].city,
							pincode:waypoints[x].pincode,
							isModify: false,
							hubId: 0,
							id: 0,
							pageName: '',
							checkBoxValue: true,
							tripCustomerId: $('#addcustNameDownID').val(),
							region: '',
							area: '',
							contactPerson: '',
							address:  waypoints[x].add ,
							desc: '',
							sequence: hubDetails.length + 1
						}
						hubDetails.push(params);
					 }

			 }

		   if ($('#addDestCombo').val() == "0" || $('#addDestCombo').val() == "2") {
		     var latlng = new google.maps.LatLng(destinationEnd.lat(), destinationEnd.lng());
		     geocoder.geocode({'latLng': latlng}, function(results, status) {
		        if (status == google.maps.GeocoderStatus.OK) {
		          var add= results[0].formatted_address ;
		          var value=add.split(",");
		          count=value.length;
		                    country=value[count-1];
		                    state=value[count-2];
		                    city=value[count-3];
		                    
		         var addressComponent = results[0].address_components;  
	             for (var i = 0; i < addressComponent.length; i++) {
           			 for (var j = 0; j < addressComponent[i].types.length; j++) {
               			 if (addressComponent[i].types[j] == "postal_code") {
                		    console.log(addressComponent[i].long_name);
                		    newPincode = addressComponent[i].long_name;
               			 }
           			 }
        	     }
        		//alert("New Pincode inside addDestCombo :: " + newPincode);         

		          var cntry = country.replace(/[0-9]/g, '');
		          var stat = state.replace(/[0-9]/g, '');
		          var cty = city.replace(/[0-9]/g, '');

		          stat=stat.toUpperCase();
		          cntry=cntry.toUpperCase();
		          cty=cty.toUpperCase();
							var geofenceType = "Customer Hub";
							var destDetention = "";
							var destRadius = "";

							if ($('#addDestCombo').val() == "2") {
								geofenceType = "Generic Hub";
								destDetention = $('#destDetentionGeneric').val();
								destRadius = $('#destRadiusGeneric').val();
							}
							else {
								destDetention = $('#destDetention').val();
								destRadius = $('#destRadius').val();
							}
		             params = {
		              CustID: <%=customerId%>,
		              locationName:destPlaceObject.formatted_address ,
		              locationType: 32,
		              geofenceType: geofenceType,
		              radius:  destRadius,
		              latitude: destPlaceObject.geometry.location.lat(),
		              longitude: destPlaceObject.geometry.location.lng(),
		              gmt: "",
		              standardDuration: destDetention,
		              state: stat,
		              country: cntry,
		              city: cty,
		              pincode:newPincode,
		              isModify: false,
		              hubId: 0,
		              id: 0,
		              pageName: '',
		              checkBoxValue: true,
		              tripCustomerId: $('#addcustNameDownID').val(),
		              region: '',
		              area: '',
		              contactPerson: '',
		              address: destPlaceObject.formatted_address ,
		              desc: '',
		 						  sequence: 999
		            }
		            hubDetails.push(params);
		         }
		       })
		   }
			 else {
				 if ($('#addDestCombo').val() == "1") {
			 	   hubDetails.push({
						 hubId: $('#destSelect').val(),
						 type: "customerHub",
						 sequence: 999
					 })
				 }
				 else {
					 hubDetails.push({
						 hubId: $('#destSelectGeneric').val(),
						 type: "Generic Hub",
						 sequence: 999
					 })

				 }
			 }

			 saveRouteAndGoCreateTrip();


		 }



		  function saveRouteAndGoCreateTrip()
		  {

		    var result = directionsDisplay.getDirections();
		    fullRoute = result.routes[0];
		    var legDetails = [];
		    totalLegCount = fullRoute.legs.length;
		    saveLegsRecursive();


		  }

		  function saveLegsRecursive() {
		    if(currentLeg == totalLegCount){
		      var routeDetails = {
		        TAT : $("#tatInput").val(),
		      	detentionCheckPointsArray: "",
		      	distance:$("#distanceInput").val(),
		      	legPointData:"",
		      	routeKey : $("#routeKeyInput").val(),
		      	routeModId : 0,
		      	routeName : $("#routeNameInput").val(),
		       avgSpeed : $("#avgSpeedInput").val(),
		      	routeRadius : 1000,
		      	statusA : "",
		      	tripCustId : $("#addcustNameDownID").val() //trip customer id
		      }
		      console.log("Route Details", {
							hubDetails  : hubDetails,
							legDetails  : completeLegDetails,
							routeDetails: routeDetails
					});
		         $.ajax({
		               url: '<%=request.getContextPath()%>/QTPAction.do?param=saveRoute',
		               type : 'POST',
		               data: {
						   	 			 hubDetails   : JSON.stringify(hubDetails),
		                   legDetails   : JSON.stringify(completeLegDetails),
		                   routeDetails : JSON.stringify(routeDetails)
		               },
		               success: function(response) {
		                    if(JSON.parse(response).message == 'Saved Successfully')
												{
													  routeValue = JSON.parse(response).routeKey;
													  openAddModal();
													  loadData();
														$("#avgSpeedId").val($("#avgSpeedInput").val());
						                plotLegDetails();
												}
												else {
												     sweetAlert(JSON.parse(response).message);
														 //reset();
												}
												hubDetails = [];
												completeLegDetails = [];
		                    $("#loading").hide();
		               }
		         });
		      return;
		    }


		    var outsideLeg = fullRoute.legs[currentLeg];
		    var legDirection = new google.maps.DirectionsService;
				console.log("OutSide Leg", outsideLeg)
		    var start = new google.maps.LatLng(parseFloat(outsideLeg.start_location.lat()), parseFloat(outsideLeg.start_location.lng()));
		    var end = new google.maps.LatLng(parseFloat(outsideLeg.end_location.lat()), parseFloat(outsideLeg.end_location.lng()));
		    var intermediateWaypoints = [];
		    for(var zz=0;zz<outsideLeg.via_waypoints.length;zz++){
		        intermediateWaypoints.push({location: new google.maps.LatLng(outsideLeg.via_waypoints[zz].lat(), outsideLeg.via_waypoints[zz].lng()), stopover: false});
		    }

		    legDirection.route({
		           origin: start ,
		           destination: end,
		           waypoints: intermediateWaypoints,
		           travelMode: 'DRIVING'
		         }, function(response, status) {
		           if (status === 'OK') {

		             var leg = fullRoute.legs[currentLeg];

		             var sourcehub = {
									 hubId: "",
									 detention: "",
									 radius:  ""
								 };
		             var desthub = {
									 hubId: "",
									 detention:"",
									 radius:  ""
								 };

		             if(totalLegCount == 1)
		             {
		               if ($('#addSourceCombo').val() == "1") {
		                 sourcehub = {
		                   hubId: $("#sourceSelect").val(),
		                   detention: $("#sourceSelect option:selected").attr("detention"),
		                   radius: $("#sourceSelect option:selected").attr("radius")
		                 }
		               }
		               if ($('#addDestCombo').val() == "1") {
		                 desthub = {
		                   hubId: $("#destSelect").val(),
		                   detention: $("#destSelect option:selected").attr("detention"),
		                   radius: $("#destSelect option:selected").attr("radius")
		                 }
		               }

		             }
		             else {
		               if(currentLeg == 0)
		               {
		                 if ($('#addSourceCombo').val() == "1") {
		                   sourcehub = {
		                     hubId: $("#sourceSelect").val(),
		                     detention: $("#sourceSelect").attr("detention"),
		                     radius: $("#sourceSelect").attr("radius")
		                   }
		                 }
		                 for (var j = 0; j < smartHubs.length; j++) {
		                   var hub = smartHubs[j];
		                   var lat = parseFloat(hub.latitude).toFixed(2);
		                   var lng = parseFloat(hub.longitude).toFixed(2);

		                   var destLat  = leg.end_location.lat().toFixed(2); //destination latitude
		                   var destLng = leg.end_location.lng().toFixed(2); //destination longitude
		                   if(destLat == lat && destLng == lng){ desthub = hub}
		                 }
										 if(desthub.HubId == "")
										 {
											 for (var j = 0; j < hubList.length; j++) {
			                   var hub = hubList[j];
			                   var lat = parseFloat(hub.latitude).toFixed(2);
			                   var lng = parseFloat(hub.longitude).toFixed(2);

			                   var destLat  = leg.end_location.lat().toFixed(2); //destination latitude
			                   var destLng = leg.end_location.lng().toFixed(2); //destination longitude
			                   if(destLat == lat && destLng == lng){ desthub = hub}
			                 }

										 }

		               }
		               else if(currentLeg == (totalLegCount -1))
		               {
		                 for (var j = 0; j < smartHubs.length; j++) {
		                   var hub = smartHubs[j];
		                   var lat = parseFloat(hub.latitude).toFixed(2);
		                   var lng = parseFloat(hub.longitude).toFixed(2);
		                   var sourceLat  = leg.start_location.lat().toFixed(2); //source latitude
		                   var sourceLng  = leg.start_location.lng().toFixed(2); //source longitude
		                   if(sourceLat == lat && sourceLng == lng){ sourcehub = hub}
		                 }
										 if(sourcehub.HubId == "")
										 {
											 for (var j = 0; j < hubList.length; j++) {
			                   var hub = hubList[j];
			                   var lat = parseFloat(hub.latitude).toFixed(2);
			                   var lng = parseFloat(hub.longitude).toFixed(2);

			                   var destLat  = leg.end_location.lat().toFixed(2); //destination latitude
			                   var destLng = leg.end_location.lng().toFixed(2); //destination longitude
			                   if(sourceLat == lat && sourceLng == lng){ sourcehub = hub}
			                 }

										 }

		                 if ($('#addDestCombo').val() == "1") {
		                   desthub = {
		                     hubId: $("#destSelect").val(),
		                     detention: $("#destSelect").attr("detention"),
		                     radius: $("#destSelect").attr("radius")
		                   }
		                 }
		               }
		               else {
		                 for (var j = 0; j < smartHubs.length; j++) {
		                   var hub = smartHubs[j];
		                   var lat = parseFloat(hub.latitude).toFixed(2);
		                   var lng = parseFloat(hub.longitude).toFixed(2);


		                   var sourceLat  = leg.start_location.lat().toFixed(2); //source latitude
		                   var sourceLng  = leg.start_location.lng().toFixed(2); //source longitude
		                   if(sourceLat == lat && sourceLng == lng){ sourcehub = hub}

		                   var destLat  = leg.end_location.lat().toFixed(2); //destination latitude
		                   var destLng = leg.end_location.lng().toFixed(2); //destination longitude
		                   if(destLat == lat && destLng == lng){ desthub = hub}
		                 }
										 for (var j = 0; j < hubList.length; j++) {
		                   var hub = hubList[j];
		                   var lat = parseFloat(hub.latitude).toFixed(2);
		                   var lng = parseFloat(hub.longitude).toFixed(2);

											 if(sourcehub.hubId == ""){
		                   		var sourceLat  = leg.start_location.lat().toFixed(2); //source latitude
		                   		var sourceLng  = leg.start_location.lng().toFixed(2); //source longitude
		                   		if(sourceLat == lat && sourceLng == lng){ sourcehub = hub}
										 	 }

											 if(desthub.hubId == ""){
		                   		var destLat  = leg.end_location.lat().toFixed(2); //destination latitude
		                   		var destLng = leg.end_location.lng().toFixed(2); //destination longitude
		                   		if(destLat == lat && destLng == lng){ desthub = hub}
										 	 }
		                 }

		               }
		             }

          			 var durationArr = [];
		             var jsonArray = [];
		             var dragPointArray = [];
		             var distanceArr = [];

		             durationArr.push('{0'  + ',0' + '}')
		             durationArr.push('{1,' + (leg.duration.value/60).toFixed() + '}')

		             distanceArr.push('{0'  + ',0' + '}')
		             distanceArr.push('{1,' + (leg.distance.value/1000) + '}')

		             for(var w1=0;w1<leg.via_waypoint.length;++w1){
		                 dragPointArray.push('{' + (w1 + 1) + ',' +leg.via_waypoint[w1].location.toString() + ','+currentLeg+'}');
		             }

		             var legNo = currentLeg+1;
		             var rute = response.routes[0].overview_path;
		             for (var z = 0; z < rute.length; z++) {
		                 jsonArray.push('{' + (z + 1) + ',' + rute[z].lat() + ',' + rute[z].lng() + '}');
		             }

		             var legDet = {
		                tripCustId: $("#addcustNameDownID").val(), //trip customer id
		                legName:"LEG NAME " + legNo, //leg name entry field
		                source: sourcehub.Hub_Id == undefined? sourcehub.hubId:sourcehub.Hub_Id , //source hubId
		                destination: desthub.Hub_Id  == undefined? desthub.hubId:desthub.Hub_Id, //destination hubId
		                distance: leg.distance.value/1000, // from google direction api
		                TAT:"", // calculation
		                avgSpeed:"", //entry field
		                checkPointArray:"[]", //if any
		                dLat:leg.end_location.lat(), //destination latitude
		                dLon:leg.end_location.lng(), //destination longitude
		                destinationDet:desthub.detention, //destination hub detention
		                destinationRad:desthub.radius, //destination hub radius
		                distanceArr: distanceArr, // array of distance
		                dragPointArray: dragPointArray, // array of drag points
		                durationArr: durationArr, // array of duration
		                jsonArray: jsonArray,
		                legModId:0,
		                sLat:leg.start_location.lat(), //source latitude
		                sLon:leg.start_location.lng(), //source longitude
		                sourceDet:sourcehub.detention, //source hub detention
		                sourceRad:sourcehub.radius, //source hub radius
		                statusA:"" // By default
		             }
		             currentLeg++;
		             completeLegDetails.push(legDet);
		             saveLegsRecursive();
		             }
		         });



		  }




</script>

<div class="panel panel-primary" style="display:none;">
	<div class="panel-heading">
	<h3 class="panel-title">
                     Trip Creation
                  </h3></div>
	<div class="panel-body">
	<div class="col-lg-12 row">
		<div class="col-lg-9 row">
				<div class="col-lg-3">
					<label for="staticEmail2" class="col-lg-5">Customer</label>

						<select class="col-lg-7" id="custDropDownId"  data-live-search="true" onchange="getVehicleAndRouteName(this)" style="height:25px;">
<!--						<option style="display: none"></option>-->
						<option selected></option>

						</select>

				</div>
			    <div class="col-lg-6" style="display: inherit;">
					 <label for="staticEmail2" class="col-lg-3" >Start Date</label>
					<div class='col-lg-3 input-group date' style="margin-left: -6% !important;">
						<input type='text'  id="dateInput1"/>
					</div>
<!--			     </div>-->
<!--					<div class="col-lg-4" style="display: inherit;">-->
							 <label for="staticEmail2" class="col-lg-3">End Date</label>
							<div class='col-lg-3 input-group date' style="margin-left: -6% !important;">
								<input type='text'  id="dateInput2"/>
							</div>
					 </div>
					<div class="col-lg-3" style="margin-left: 0%;">
					<label for="staticEmail2" class="col-lg-4">Type</label>
						<select class="col-lg-8" id="statusTypeDropDownId"  data-live-search="true" style="height:25px;width:65%">
						<option selected value = "ALL">All</option>
						<option value = "OPEN">Open</option>
						<option value = "CLOSED">Closed</option>
						<option value = "CANCELLED">Cancel</option>
						</select>

				</div>
				</div>
				<div class="col-lg-3 row">
					<div class="col-lg-3">
						<button id="viewId" class="btn btn-primary" onclick="getData()">View</button>
					</div>
					<div class="col-lg-3">
						<button title="ADD" onclick="openAddModal()" class="btn btn-primary" style="margin-left: 10px;" >ADD</button>
					</div>
					<div class="col-lg-3">
						<button  id="overrideActualsBtn" class="btn btn-primary" onclick="openOverideActualsModal()" style="margin-left: 10px; display: none;">Override ATP ATD</button>
					</div>
					<div class="col-lg-3">
						<button class="btn btn-info" title="Vehicle Reporting" onclick="openVehicleReportPage()"  class="btn" id="vehicleReportBtnId" style="margin-left: 10px; display: none;">Back</button>
					</div>

				</div>
		</div>
		 <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12 text-center">
       			<div id="page-loader" style="margin-top:10px;display:none;">
				 <img src="../../Main/images/loading.gif" alt="loader" />
				</div>
       		</div>
		<br><br/>
			<table id="example" class="table table-striped table-bordered" cellspacing="0" width="100%" >
           		<thead>
                 	<tr>
					<th>#</th>
					<th style="display:none;">Trip Id</th>
					<th>Trip Name</th>
					<th>Route Name</th>
					<th>Vehicle Number</th>
					<th>Created By</th>
					<th>Trip Created Time</th>
					<th>Trip Date / Time</th>
					<th>Average Speed (kms/hr)</th>
					<th>Customer Name</th>
					<th>Trip  No</th>
					<th>Customer Ref. ID</th>
					<th>Status</th>
					<th style="white-space: nowrap;">Temperature Range (°C)</th>
					<th>Overridden By</th>
					<th>Overridden Date</th>
					<th>Overridden Remarks</th>
					<th>Cancelled Remarks</th>
					<th>Image</th>
					<th>Action</th>
					<th>Modify</th>
					<th>Change Route</th>
					<th id="swapVehicleColumnId">Swap Vehicle</th>
					<th style="display:none;">Trip Cust Id</th>
					<th style="display:none;">Pre-Load Temp</th>
					<th style="display:none;">Route Id</th>
					<th style="display:none;">Product Line</th>
					<th style="display:none;">ATD</th>
					<th style="display:none;">Seal No</th>
					<th style="display:none;">No Of Bags</th>
					<th style="display:none;">Trip Type</th>
					<th style="display:none;">No Of Bags</th>
					<th style="display:none;">Opening Kms</th>
					<th style="display:none;">Trip Remarks</th>
					<th style="display:none;">Route Template</th>
					<th style="display:none;">Material</th>
					<th style="display:none;">Total TAT</th>
					<th style="display:none;">Total RunTime</th>
					<th style="display:none;">STA</th>
					<th style="display:none;">ATA</th>
					<th style="display:none;">Category</th>

					</tr>
				</thead>
			</table>
		</div>
	</div>


	<div id="add" class="modal fade" data-backdrop="static" data-keyboard="false" >
        <div class="" style="position: absolute;left: 2%;top: 6%;width:95%;">
            <div class="modal-content">
							<div class="modal-header" style="padding:1px;">
									 <div class="quickTripHeader" style="padding-top:6px;border-radius:4px;height:32px;">ADD TRIP INFORMATION
					<button type="button" class="close" onclick="cancel()" style="margin-top: -10px;color: white;" data-dismiss="modal">&times;</button>
				</div></div>
                <div class="modal-body" style="max-height: 50%;margin-bottom: 0px;">
		           <div class="col-md-12">
								 <table class="table table-sm table-bordered table-striped" style="margin-bottom: 0px;">
		 							<tbody>
		 								<tr>
		 									<td id="routeNameLblTDId">Route Name</td>
		 									<td id="routeNameTDId"><select class="comboClass" id="addrouteDropDownID" data-live-search="true" required="required" onchange="plotLegDetails()" ></select>
		 							<%-- <input onclick="createRoute()" id="createRouteId" type="button" class="btn btn-primary" data-dismiss="modal" style="height:28px;" value="Create"/>
		 							<input onclick="viewRoute('add')" id="viewRouteBtnId" type="button" class="btn btn-primary"  style="height:28px;" value="View" /> --%>
		 						</td>
		 						<td id="routeTemplateLblTDId">Route Template</td>
		 									<td id="routeTemplateId"><select class="comboClass" id="routeTemplateDropDownID" data-live-search="true" required="required" onchange="loadMaterials()" ></select>
		 						</td>
		 									<td id="productLineLblId">Product Line</td>
		 									<td id="productLineId"><select class="comboClassVeh" id="addProductLineComboId"  required="required" onchange="checkProduct()"></select></td>
		 							<td id="materialLblId">Material</td>
		 									<td id="materialId"><select class="comboClassVeh" id="addMaterialComboId"  required="required" onchange="loadRouteLegTATDetails()"></select></td>
		 								</tr>
		 								<tr>
							<td>Vehicle Number</td>
				      			<!-- <td><select class="comboClassVeh" id="addvehicleDropDownID"  required="required" onchange="checkAssociationDetails()"></select></td> -->
				      			<td><select class="comboClassVeh" id="addvehicleDropDownID"  required="required"></select></td>

				      			<td>Customer Ref. ID</td>
				      			<td><input type="text" class="form-control comboClass" maxLength="15" id="custReferenceId" onkeypress="return checkSpcialChar(event)"></td>

	      						<td id="categoryLblId">Category</td>
				      			<td id="categoryId"><select class="comboClassVeh" id="categoryComboId"  required="required" ></select></td>
				      			<!-- <td>Trip  No</td>
				      			<td><input type="text" class="form-control comboClass" maxLength="15" id="addorderId" onkeypress="return checkSpcialChar(event)" ></td> -->
				      		</tr>
				      		<tr>
								<td>Trip Date/Time</td>
				      			<td><input type="text" id="adddateTimeInput" class='form-control' ></td>

				      			<td>Average Speed (km/hr)</td>
				      			<td><input type="text" class="form-control comboClass" id="avgSpeedId" min="1" maxLength="4" step="any" class='comboClass' onkeypress="return checkSpeed(event)" onchange = "checkTemperature1(this.id,this.value)"></td>

				      			<td data-toggle="tooltip" data-placement="bottom" title="Upload Delivery Challan or Trip Related Slips">Upload Image</td>
				      			<td>
					      			<form id="imageForm" action="<%=request.getContextPath()%>/UploadCreateTripImage" enctype="multipart/form-data" method="POST"  >
					      			<input type="file" class="inputstl" id="imgUploadId" name="sentfile" accept=".jpg"  data-toggle="tooltip" data-placement="bottom" title="Upload Delivery Challan or Trip Related Slips">
					      			</form>
				      			</td>
				      		</tr>
				      		<tr id="totalTATDetails">
							<td>Total TAT(DD:HH:mm) </td>
				      			<td><input type="text" id="totalTAT" class="form-control comboClass" disabled></td>

				      			<td>Total RunTime(DD:HH:mm)</td>
				      			<td><input type="text" id="totalRunTime" class="form-control comboClass" disabled></td></td>

				      		</tr>
				      		<%=rowData%>
						<tr>
							<td>Vehicle Type</td>
				      			<td><input type="text" class="form-control comboClass" disabled maxLength="15" id="vehicleTypeId" ></td>

				      			<td>Vehicle Model</td>
				      			<td><input type="text" class="form-control comboClass" disabled maxLength="15" id="vehicleModelId" ></td>



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
				      			<table  class="table" id="tabelId" style="display:none">
				      			<tr>
				      				<th style="width:20px;"></th>
				      				<th style="width:20px; display:none;"></th>
				      				<th style="width:200px;">Leg Name</th>
				      				<th style="width:300px">Source</th>
				      				<th style="width:300px">Destination</th>
				      				<th style="width:250px">STD</th>
				      				<th style="width:250px">STA</th>
				      				<th style="width:200px">Drivers</th>
				      				<th style="width:200px">Apply Same Drivers for other Legs <input type="checkbox" id="checkSelected" onclick="checkboxValidation()" required></th>
				      			</tr>
				      			<tbody id = "legTableId">
				      			</tbody>
				      			</table>
				      		</tr>
				      		<tr>
				      			<table id="tempTableId" class="table table-sm table-bordered table-striped" style="display:none">
				      			<tr>
				      				<td align="center" >Pre-loading Temperature (°C)</td>
					      			<td><input type="text" id="preTempId"  maxLength="4" step="any" class='comboClass'"
					      				onkeypress="return checkTemperature(event)" onchange = "checkTemperature1(this.id,this.value)"></td>
					      			<td align="center" style="width: 28%;" id="humidity">Humidity (%)</td>
					      			<td id="humiditymin">Min</td>
					      			<td id="humidityminId"><input type="text" id="minHumidityId" min="1" maxLength="3" step="any" class='comboClass' onkeypress="return checkSpeed(event)" onchange = "checkTemperature1(this.id,this.value)"></td>
					      			<td id="humiditymax">Max</td>
					      			<td id="humiditymaxId"><input type="text" id="maxHumidityId" min="1" maxLength="3" step="any" class='comboClass' onkeypress="return checkSpeed(event)" onchange = "checkTemperature1(this.id,this.value)"></td>
				      			</tr>
				      			</table>
				      		</tr>
				      		<tr><table class=""  id ="tempConfigTableId"  style="display:none">
				      		<tbody id="temperatureTableId" ></tbody>
				      		</table></tr>
				      		<div id="event">
				      		<tr>
				      			<td>Events</td>
				      			<td>
				      			<table>
				      			<tr>
								<td><label><input id="checkboxAll" type="checkbox"  value="0"> ALL</label></td>
								</tr>
								<tr>
				      				<td><label><input id="checkbox1" type="checkbox" value="105"> Harsh Driving</label></td>
									<td id="emptyColumn2"> </td>
									<td><label><input id="checkbox2" type="checkbox" value="17"> Hub Arrival</label></td>
									<td id="emptyColumn2"> </td>
									<td><label><input id="checkbox3" type="checkbox" value="135"> Trip Start</label></td>
									<td id="emptyColumn2"> </td>
									<td><label><input id="checkbox4" type="checkbox" value="18"> Hub Departure</label></td>
									<td id="emptyColumn2"> </td>
									<td><label><input id="checkbox5" type="checkbox" value="136"> Trip End</label> </td>
									<td id="emptyColumn2"> </td>
									<td><label><input id="checkbox6" type="checkbox" value="5"> Route Deviation</label></td>
									<td id="emptyColumn2"> </td>
									<td><label><input id="checkbox7" type="checkbox" value="2"> Over Speed</label></td>
									<td id="emptyColumn2"> </td>
									<td><label><input id="checkbox14" type="checkbox" value="194"> High/Low RPM</label></td>
								</tr>
								<tr>
									<td><label><input id="checkbox8" type="checkbox" value="39"> Idle</label></td>
									<td id="emptyColumn2"> </td>
									<td><label><input id="checkbox9" type="checkbox" value="1"> Vehicle Stoppage</label></td>
									<td id="emptyColumn2"> </td>
									<td><label><input id="checkbox10" type="checkbox" value="37"> Seat Belt</label></td>
									<td id="emptyColumn2"> </td>
									<td><label><input id="checkbox11" type="checkbox" value="85"> Vehicle Non-Communicating</label></td>
									<td id="emptyColumn2"> </td>
									<td><label><input id="checkbox12" type="checkbox" value="134"> Route Re-join</label></td>
									<td id="emptyColumn2"> </td>
									<td><label><input id="checkbox13" type="checkbox" value="38"> Door Sensor</label></td>
									<td id="emptyColumn2"> </td>
									<td><label><input id="checkbox15" type="checkbox" value="193"> Low Fuel</label></td>
									<td id="emptyColumn2"> </td>
									<td><label><input id="checkbox16" type="checkbox" value="195"> Mileage</label></td>
									<td id="emptyColumn2"> </td>
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
                <div class="modal-footer"  style="text-align: center; padding: 8px;">
                	<input id="save1" onclick="saveData()" type="button" style="background-color:#158e1a  !important; border-color:#158e1a  !important; " class="btn btn-primary" value="Save" />
                    <button type="reset"  onclick="cancel()" class="btn btn-warning" style="background-color:#da2618  !important; border-color:#da2618  !important;" data-dismiss="modal">Cancel</button>

                </div>
            </div>
        </div>
    </div>


	    <div class="modal fade" id="cancelModal" role="dialog" data-backdrop="static" data-keyboard="false" >
		    <div class="modal-dialog" style="margin-top:8%">

		      <!-- Modal content-->
		      <div class="modal-content">
		        <div class="modal-body" align="center !important"  >
		        <div>
		        	<label for="remarks" style="text-align: center;">Reason *</label>
		              <span style="padding-left : 112px;"><select class="comboClass" id="tripCancellationRemarks" data-live-search="true" required="required"></select></span>
		          </div>
		              <label for="remarks" style="text-align: center;">Remarks </label>
    				  <textarea class="form-control rounded-0" id="remarksId" rows="3" ></textarea><br/>
		          <button style="margin-left:215px;background-color:#158e1a; border-color:#158e1a;" type="button" onclick="cancelTrip()" class="btn btn-success" >Yes</button>
		          <button style="margin-left: 16px;background-color:#da2618; border-color:#da2618;" type="button" class="btn btn-warning" data-dismiss="modal" onclick="closeCancelTrip()">No</button>
		        </div>
		      </div>

		    </div>
	  </div>

	  <div class="modal fade" id="closeModal" role="dialog" data-backdrop="static" data-keyboard="false">
		    <div class="modal-dialog" style="margin-top:8%">

		      <!-- Modal content-->
		      <div class="modal-content">
		        <div class="modal-body" align="center !important" >

		           <label for="remarks" style="text-align: center;">Remarks *</label>
    				  <textarea class="form-control rounded-0" id="remarksCloseId" rows="3"></textarea><br/>
    				  <table class="table table-sm table-bordered table-striped" id="ataTable">
			      		<tbody>
				      		<tr>
				      			<td>STA</td>
								<td><input type="text" id="staDateTime" class="form-control comboClass" readonly></td>
				      		</tr>
				      		<tr>
								<td>ATA</td>
								<td><input type="text" id="ataDateTimeInput" class='form-control'></td>
				      		</tr>

			      		</tbody>
			      	</table>
		          <button style="margin-left:215px; background-color:#158e1a; border-color:#158e1a;" type="button" onclick="closeTrip()" data-dismiss="modal" class="btn btn-success" >Yes</button>
		          <button style="margin-left: 16px; background-color:#da2618; border-color:#da2618;" type="button" class="btn btn-warning" data-dismiss="modal" onclick="closeTripCloseModal()">No</button>
		        </div>
		      </div>

		    </div>
	  </div>

        <div class="modalimg" id="viewImageModal">
<!--        <button type="button" class="close" data-dismiss="modal">&times;</button>-->
 	  <span id="imgCloseId" class="imgclose">&times;</span>
  			<img  id="tripImage" class="imagecontent" onerror="imgError()" />
<!--		    <img class="modal-content" id="tripImage" img src="file://C:/CreateTripImage/Trip_Id_7976.jpg" />  style="width: 700px;height: 500px;margin-top: 189px;margin-left: px;" -->
<!--img src="/ApplicationImages/CreateTripImage/Trip_Id_7976.jpg"-->

  			<div id="caption"></div>
		</div>


	<div id="modify" class="modal fade" data-backdrop="static" data-keyboard="false">
        <div class="modal-dialog" style="position: absolute;left: 2%;top: 52%;margin-top: -250px; width: 95% !important;max-width: 100% !important;">
            <div class="modal-content">
                <div class="modal-header"  style="padding:1px;">
                    <h4 id="nome" class="modal-title">Modify Trip Information</h4>
					 <button type="button" onclick="cancel()" class="close" data-dismiss="modal">&times;</button>
                </div>
                <div class="modal-body" style="max-height: 50%;margin-bottom: 0px;">
		           <div class="col-md-12">
			      	<table class="table table-sm table-bordered table-striped">
			      		<tbody>
			      			<tr>
				      			<td>Customer Name</td>
								<td><input type="text" class="form-control comboClass" id="modifycustNameDownID" readonly></td>

								<td id="modifyRouteNameLbl">Route Name</td>
								<td id="modifyRouteTemplateLbl">Route Template Name</td>
				      			<td><select class="comboClass" id="modifyrouteDropDownID" onchange="plotLegDetailsModificationOnRouteChange()" data-live-search="true" >
								</select></td>

								 <!--<td><input type="text" class="form-control comboClass" id="modifyrouteDropDownID" ></td>

				      			--><td id="modifyProductlinelbl">Product Line</td>
							<td id="modifyMaterialLbl">Material</td>
							<td id = "nonMaterialClient"><select class="comboClass" id="modifyProductLineComboId" onchange="checkProductModify()" data-live-search="true" >
								</select></td>
								<td id = "materialClient"><input type="text" class="form-control comboClass" id="modifyMaterialValueId" readonly></td>
				      		</tr>
				      		<tr>
					      		<td>Vehicle Number</td>
				      			<td><select class="comboClass" id="modifyvehicleDropDownID" data-live-search="true" >
								</select></td>

						 	<!--<td><input type="text" class="form-control comboClass" id="modifyvehicleDropDownID" ></td>

				      			--><td>Customer Ref. ID</td>
								<td><input type="text" class="form-control comboClass" id="modifycustrefID" required></td>

				      			<td>Trip  No</td>
				      			<td><input type="text" class="form-control comboClass" id="modifyorderId" readonly></td>
				      		</tr>

				      		<tr>
				      			<td>Trip Date/Time</td>
				      			<td><input type="text" id="dateTimeInput" class='form-control'></td>

				      			<td>Average Speed (kms/hr)</td>
				      			<td><input type="text" id="avgSpeedModifyId" class="form-control comboClass" min="1" maxLength="4" step="any"  onkeypress="return checkSpeed(event)" onchange = "checkTemperature1(this.id,this.value)"></td>

				      			<td id="pleLoadTempLblId">Pre-Loading Temperature (°C)</td>
				      			<td><input type="text" id="preloadTempModifyId" class="form-control comboClass" onchange = "checkTemperature1(this.id,this.value)"></td>
				      		</tr>
				      		<tr id="totalTATDetailsMod">
							<td>Total TAT </td>
				      			<td><input type="text" id="totalTATMod" class='form-control' disabled></td>

				      			<td>Total RunTime</td>
				      			<td><input type="text" id="totalRunTimeMod" class='form-control' disabled></td></td>
				      		</tr>
				      		<tr>
				      		<td id="modifycategorylbl">Category</td>
				      		<td id="modifycategory"><select class="comboClass" id="modifycategoryComboId" data-live-search="true" >
								</select></td>
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
				      			<table  class="table" id="modifyTabelId" style="display:none">
				      			<tr>
				      				<th style="width:20px;"></th>
				      				<th style="width:20px; display:none;"></th>
				      				<th style="width:150px;">Leg Name</th>
				      				<th style="width:300px">Source</th>
				      				<th style="width:300px">Destination</th>
				      				<th style="width:250px">STD</th>
				      				<th style="width:250px">STA</th>
				      				<th style="width:200px">Drivers</th>
				      				<th style="width:200px"></th>
				      			</tr>
				      			<tbody id = "modifyLegTableId">
				      			</tbody>
				      			</table>
				      		</tr>
				      		<tr><table class="table table-sm table-bordered table-striped"  id ="modTempConfigTableId"  style="display:none">
				      		<tbody id="modTemperatureTableId" ></tbody>
				      		</table></tr>
			      		</tbody>
			      	</table>
			      </div>
                </div>
                <div class="modal-footer"  style="text-align: center;">
                	<input  onclick="modifyData()" type="button" class="btn btn-primary" id="updateButtionId" style="background-color:#158e1a; border-color:#158e1a;" value="Update" />
					 <button type="reset"  onclick="cancel()" class="btn btn-warning" style="background-color:#da2618  !important; border-color:#da2618  !important;" data-dismiss="modal">Close</button>

                </div>
            </div>
        </div>
    </div>

	<div id="overrideActuals" class="modal fade" data-backdrop="static" data-keyboard="false">
        <div class="modal-dialog" style="position: absolute;left: 20%;top: 52%;margin-top: -250px; width: 60% !important;max-width: 100% !important;">
            <div class="modal-content">
                <div class="modal-header"  style="padding:1px;">
                    <h4 id="nome" class="modal-title">Override ATP ATD</h4>
					 <button type="button" onclick="cancel()" class="close" data-dismiss="modal">&times;</button>
                </div>
                <div class="modal-body" style="max-height: 50%;margin-bottom: 0px;">
		           <div class="col-md-12">
			      	<table class="table table-sm table-bordered table-striped">
			      		<tbody>
			      			<tr>
				      			<td>Trip Name</td>
								<td><select style="width:500px:height:25px" id="tripNameCombo" onchange="loadScheduleAndActualTime()"></select></td>
				      		</tr>
			      			<tr>
				      			<td>STP</td>
								<td><input type="text"  id="stpDateTime" class="form-control comboClass" readonly></td>
				      		</tr>
				      		<tr>
					      		<td>ATP</td>
								<td><input type="text" id="atpDateTimeInput" class='form-control'></td>
				      		</tr>
				      		<tr>
				      			<td>STD</td>
								<td><input type="text" id="stdDateTime" class="form-control comboClass" readonly></td>
				      		</tr>
				      		<tr>
				      			<td>ATD</td>
								<td><input type="text" id="atdDateTimeInput" class='form-control'></td>
				      		</tr>
				      		<tr>
				      		     <td><label for="remarks" style="text-align: center;">Remarks</label></td>
    				 		     <td><textarea class="form-control rounded-0" id="overrideRemarksId" rows="3"></textarea><br/></td>
    				 		</tr>
			      		</tbody>
			      	</table>
			      </div>
                </div>
                <div class="modal-footer"  style="text-align: center;">
                	<input  onclick="overrideActualTime()" type="button" class="btn btn-primary" style="background-color:#158e1a; border-color:#158e1a;" value="Update" />
					 <button type="reset"  onclick="cancel()" class="btn btn-warning" style="background-color:#da2618  !important; border-color:#da2618  !important;" data-dismiss="modal">Close</button>
                </div>
            </div>
        </div>
    </div>

	<div id="chengeRoute" class="modal fade" data-backdrop="static" data-keyboard="false">
        <div class="modal-dialog" style="position: absolute;left: 2%;top: 52%;margin-top: -250px; width: 95% !important;max-width: 100% !important;">
            <div class="modal-content">
                <div class="modal-header" style="padding:1px;">
                    <h4 id="routeChangeTitleId" class="modal-title">Route Change-Over</h4>
					  <button type="button" class="close" onclick="" data-dismiss="modal">&times;</button>
                </div>
                <div class="modal-body" style="max-height: 50%;margin-bottom: 0px;">
		           <div class="col-md-12">
			      	<table class="table table-sm table-bordered table-striped" style="margin-bottom: 0px;">
			      		<tbody>
			      			<tr>
				      			<td>Customer Name</td>
				      			<td><input type="text" class="form-control comboClass" id="routeChangeCustId" readonly></td>

				      			<td>Current Name</td>
								<td><input type="text" class="form-control comboClass" id="oldRouteDropDownID" readonly></td>

				      			<td>Modifying Route</td>
				      			<td><select class="comboClass" id="changeRouteId" data-live-search="true" required="required" onchange="" ></select>
									<input onclick="createRoute()" id="changeCreateRouteId" type="button" class="btn btn-primary" data-dismiss="modal" style="height:28px;display:none" value="Create"/>
									<input onclick="viewRoute('change')" id="changeViewRouteBtnId" type="button" class="btn btn-primary"  style="height:28px;display:none" value="View" />
								</td>
				      		</tr>
			      		</tbody>
			      	</table>
			      </div>
                </div>
                <div class="modal-footer"  style="text-align: center; padding: 8px;">
                	<input id="save2" onclick="saveRouteChange()" type="button" style="background-color:#158e1a  !important; border-color:#158e1a  !important; " class="btn btn-primary" value="Save" />
                    <button type="reset"  class="btn btn-warning" style="background-color:#da2618  !important; border-color:#da2618  !important;" data-dismiss="modal">Close</button>

                </div>
            </div>
        </div>
    </div>

    	<div id="swapVehicleModal" class="modal fade" data-backdrop="static" data-keyboard="false">
        <div class="modal-dialog" style="position: absolute;left: 2%;top: 52%;margin-top: -250px; width: 95% !important;max-width: 100% !important;">
            <div class="modal-content">
                <div class="modal-header" style="padding:1px;">
                    <h4 id="swapVehicleTitleId" class="modal-title">Swap Vehicle</h4>
					  <button type="button" class="close" onclick="" data-dismiss="modal">&times;</button>
                </div>
                <div class="modal-body" style="max-height: 50%;margin-bottom: 0px;">
		           <div class="col-md-12">
			      	<table class="table table-sm table-bordered table-striped" style="margin-bottom: 0px;">
			      		<tbody>
			      			<tr>
				      			<td>Customer Name</td>
				      			<td><input type="text" class="form-control comboClass" id="swapVehicleCustId" readonly></td>

				      			<td>Route Name</td>
								<td><input type="text" class="form-control comboClass" id="swapVehiclerouteDropDownID" readonly></td>

				      			<td>Product Line</td>
								<td><input type="text" class="form-control comboClass" id="swapVehicleProductLineComboId" readonly></td>
							</tr>
							<tr>
							<td>Customer Ref. ID</td>
								<td><input type="text" class="form-control comboClass" id="swapVehiclecustrefID" readonly></td>

				      			<td>Trip  No</td>
				      			<td><input type="text" class="form-control comboClass" id="swapVehicleorderId" readonly></td>

				      			<td>Trip Date/Time</td>
				      			<td><input type="text" id="swapVehicledateTimeInput" class='form-control' readonly></td>
							</tr>
							<tr>
				      			<td>Current Vehicle</td>
								<td><input type="text" class="form-control comboClass" id="oldSwappedVehicleId" readonly></td>

				      			<td>New Vehicle</td>
				      			<td><select class="comboClass" id="newSwappedVehicleId" data-live-search="true" required="required" onchange="" ></select>
								</td>
								<td>Remarks</td>
								<td><input type="text" class="form-control comboClass" id="vehicleSwapRemarks"></td>
				      		</tr>
			      		</tbody>
			      	</table>
			      </div>
                </div>
                <div class="modal-footer"  style="text-align: center; padding: 8px;">
                	<input id="saveVehicleSwap" onclick="saveVehicleSwap()" type="button" style="background-color:#158e1a  !important; border-color:#158e1a  !important; " class="btn btn-primary" value="Swap" />
                    <button type="reset"  class="btn btn-warning" style="background-color:#da2618  !important; border-color:#da2618  !important;" data-dismiss="modal">Close</button>

                </div>
            </div>
        </div>
    </div>


    <script async>

	 window.onload = function () {
		 if(canOverrideActuals == 'false'){
				$('#overrideActualsBtn').hide();
			}else{
				$('#overrideActualsBtn').show();
			}
		getCustomer();
	}

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
	var newPincode = ""; 	

   $(document).ready(function () {
      $("#adddateTimeInput").jqxDateTimeInput({ theme: "arctic", formatString: "dd/MM/yyyy HH:mm", showTimeButton: true, width: '200px', height: '25px'});
   $('#adddateTimeInput ').jqxDateTimeInput('setDate', new Date());
   $('#adddateTimeInput ').jqxDateTimeInput({min: new Date(restrictYear, restrictMonth, restrictDate)});
   $("#dateTimeInput").jqxDateTimeInput({ theme: "arctic", formatString: "dd/MM/yyyy HH:mm",  showTimeButton: true, width: '200px', height: '25px' });
   $('#dateTimeInput ').jqxDateTimeInput('setDate', new Date());
   $('#dateTimeInput ').jqxDateTimeInput({min: new Date(restrictYear, restrictMonth, restrictDate)});

   $("#atpDateTimeInput").jqxDateTimeInput({ theme: "arctic", formatString: "dd/MM/yyyy HH:mm",  showTimeButton: true, width: '200px', height: '25px' });
   $('#atpDateTimeInput').jqxDateTimeInput('setDate', '');
   $("#ataDateTimeInput").jqxDateTimeInput({ theme: "arctic", formatString: "dd/MM/yyyy HH:mm",  showTimeButton: true, width: '200px', height: '25px' });
   $('#ataDateTimeInput').jqxDateTimeInput('setDate', '');
   $("#atdDateTimeInput").jqxDateTimeInput({ theme: "arctic", formatString: "dd/MM/yyyy HH:mm",  showTimeButton: true, width: '200px', height: '25px' });
   $('#atdDateTimeInput').jqxDateTimeInput('setDate', '');

   $("#dateInput1").jqxDateTimeInput({ theme: "arctic", formatString: "dd/MM/yyyy", showTimeButton: false, width: '197px', height: '25px'});
   $('#dateInput1 ').jqxDateTimeInput('setDate', new Date());
   $("#dateInput2").jqxDateTimeInput({ theme: "arctic", formatString: "dd/MM/yyyy", showTimeButton: false, width: '197px', height: '25px'});
   $('#dateInput2 ').jqxDateTimeInput('setDate', currentDate);

   if(category == 'N')
   {
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
		$("#temperatureEvents").empty();
	})

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

function loadScheduleAndActualTime(){
	 $('#atpDateTimeInput').jqxDateTimeInput('setDate', $('#tripNameCombo option:selected').attr("ATP"));
	 $('#atdDateTimeInput').jqxDateTimeInput('setDate', $('#tripNameCombo option:selected').attr("ATD"));
	 $('#stpDateTime').val($('#tripNameCombo option:selected').attr("STP"));
	 $('#stdDateTime').val($('#tripNameCombo option:selected').attr("STD"));
	 $('#overrideRemarksId').val($('#tripNameCombo option:selected').attr("remarks"));
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
	  	///document.getElementById("addcustNameDownID").value="";
	  	document.getElementById("custReferenceId").value="";
			if(document.getElementById("addorderId") != null)
			{
	  	document.getElementById("addorderId").value="";}
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
                         "17" : item.cancelledRemarks,
                         "18" : "<button class='btn btn-info btn-md' data-toggle='tooltip' data-placement='bottom' title='View Uploaded Trip Image'>View Image</button>",
                         "19" : item.actionIndex,
                         "20" : item.modifyIndex,
                         "21" : item.changeRouteIndex,
                         "22" : item.swapVehicleIndex,
                         "23" : item.tripCustId,
                         "24" : item.routeIdIndex,
			 			 "25" : item.preLoadTempIndex,
                         "26" : item.productLineIndex,
                         "27" : item.atdIndex,
                         "28" : item.sealNoIndex,
                         "29" : item.noOfBagsIndex,
                         "30" : item.tripTypeIndex,
                         "31" : item.noOfFluidBagsIndex,
                         "32" : item.openingKmsIndex,
                         "33" : item.tripRemarksIndex,
						 "34" : item.routeTemplateName,
			 			 "35" : item.materialName,
			 			 "36" : item.totalTAT,
			 			 "37" : item.totalRunTime,
			 			 "38" : item.STA,
			 			 "39" : item.ATA,
			 			 "40" : item.category


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

		 	     table.columns( [1,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40] ).visible( false );
		 	   if(swapVehicleColumn == 'N'){
	    		document.getElementById("swapVehicleColumnId").style.display = "none";
	    		table.column( 22 ).visible( false );	//enabling swap vehicle column based on trip sheet setting
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
	        var prLoadTemp = (data[25]);//preLoadTempIndex
	        globalRouteId = data[24];//routeIdIndex
	        status = (data[12]);//statusDataIndex
	        uniqueId = (data[1]);//uniqueIdIndex
	        var avgSpeed = data[8];//avgSpeedIndex
	        var productLine = (data[26]);//productLineIndex
	        var atd = (data[27]);//atdIndex
	        var sta = (data[38]);//sta
	        var ata = (data[39]);//ata
	        var category = (data[40]);//category
<!--	        var modSealNo = (data['sealNoIndex']);-->
<!--	        var modNoOfBags = (data['noOfBagsIndex']);-->
<!--	        var modTripType = (data['tripTypeIndex']);-->
<!--	        var modNoOfFluidBags = (data['noOfFluidBagsIndex']);-->
<!--	        var modOpeningKms = (data['openingKmsIndex']);-->
<!--	        var modTripRemarks = (data['tripRemarksIndex']);-->
	        globalTripCustId = (data[23]);//tripCustId
	        $('#modifycustNameDownID').val(custName);
	        $('#modifycustrefID').val(refId);
	        $('#modifyorderId').val(orderId);
	     //   $('#modifyrouteDropDownID').val(globalRouteId);
	        //$('#modifyvehicleDropDownID').val(globalVehicleSelected);
	        $('#dateTimeInput').val(plannedDate);
	        $('#avgSpeedModifyId').val(avgSpeed);
	        $('#preloadTempModifyId').val(prLoadTemp);
	        $('#modifyProductLineComboId').val(productLine);
	        globalProductLineSelected = data[26];
	        $('#modifycategoryComboId').val(category);
<!--	        $('#modifySealNoId').val(modSealNo);-->
<!--	        $('#modifyNoOfBagsId').val(modNoOfBags);-->
<!--	        $('#modifyTripTypeId').val(modTripType);-->
<!--	        $('#modifyFluidBagsId').val(modNoOfFluidBags);-->
<!--	        $('#modifyOpeningKmsId').val(modOpeningKms);-->
<!--	        $('#modifyTripRemarksId').val(modTripRemarks);-->
<!--	        $('#modifySealNoId').prop('disabled', true);-->
<!--	        $('#modifyNoOfBagsId').prop('disabled', true);-->
<!--	        $('#modifyTripTypeId').prop('disabled', true);-->
<!--	        $('#modifyFluidBagsId').prop('disabled', true);-->
<!--	        $('#modifyOpeningKmsId').prop('disabled', true);-->
<!--	        $('#modifyTripRemarksId').prop('disabled', true);-->
	         if(columnIndex == 18){ //column index 14 is used for Image download button//
   			 //var pageName='PendingRequest';
		//document.getElementById('imgDownload').setAttribute('href', '/UploadCreateTripImage.do?tripId='+uniqueId);//+'&pageName='+pageName+'&agenceName='+agenceName+'&contactPerson='+contactPerson+'&contactNo='+contactNo+'&emailId='+emailId+'&productLine='+productLine+'&campaignBudget='+campaignBudget+'&bookingForm='+bookingForm+'&bookingTo='+bookingTo);

   			  imageDownload(uniqueId);

        	}
	        if(columnIndex == 19){//actionIndex
	        		document.getElementById("remarksCloseId").value="";
	        		if(canOverrideActuals == 'true')
	        		{
	        			document.getElementById("ataTable").style.display='block';
	        			$('#staDateTime').val(sta);
	        			$('#ataDateTimeInput').val(ata);
	        			if(ata != ''){ // If vehicle has already arrived at destination, then dont allow to override
	        				destinationArrived = true;
	        				$("#ataDateTimeInput").jqxDateTimeInput({ disabled: true });
	        			}else{
	        				destinationArrived = false;
	        				$("#ataDateTimeInput").jqxDateTimeInput({ disabled: false });
	        			}
	        		}else{
	        			document.getElementById("ataTable").style.display='none';
	        		}
	        }
        	if(columnIndex == 20){//modifyIndex
        		modifyModal(uniqueId,atd,status,globalRouteId,globalTripCustId,globalVehicleSelected,category,productLine);
        	}

        	if(columnIndex == 21){//changeRouteIndex
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
        	if(columnIndex == 22){//swapVehicleIndex
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
		      $('#modifyrouteDropDownID').val(data[34]);//routeTemplateName
		      $('#modifyMaterialValueId').val(data[35]);//materialName
		      $('#totalTATMod').val(data[36]);//totalTAT
		      $('#totalRunTimeMod').val(data[37]);//totalRunTime

  		   }else{
  		        document.getElementById("modifyRouteTemplateLbl").style.display = 'none';
  		        document.getElementById("modifyMaterialLbl").style.display = 'none';
  		        document.getElementById("materialClient").style.display = 'none';
			    document.getElementById("totalTATDetailsMod").style.display = 'none';
   		   }
	});

	function modifyModal(uniqueId,atd,status,globalRouteId,globalTripCustId,globalVehicleSelected,category,productLine){
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
		$("#updateButtionId").show();
		if(atd != ''){
			$('#dateTimeInput').jqxDateTimeInput({ disabled: true});
			$("#preloadTempModifyId").attr("disabled",true);
			$("#modifyrouteDropDownID").attr("disabled",true);
			$("#modifyvehicleDropDownID").attr("disabled",true);
		//	$('#modifyrouteDropDownID').val(globalRouteId);
		//	$('#modifyvehicleDropDownID').val(globalVehicleSelected).trigger('change');
		//	$('#modifycategoryComboId').val(category).trigger('change');
			$('#modifycustrefID').attr("disabled",true);
			$("#modifyProductLineComboId").attr("disabled",true);
			$("#avgSpeedModifyId").attr("disabled",false);
		}else{
			$('#dateTimeInput').jqxDateTimeInput({ disabled: false});
			$("#preloadTempModifyId").attr("disabled",false);
			$("#modifyrouteDropDownID").attr("disabled",false);
			$("#modifyvehicleDropDownID").attr("disabled",false);
			$('#modifycustrefID').attr("disabled",false);
			$("#modifyProductLineComboId").attr("disabled",false);
			$("#avgSpeedModifyId").attr("disabled",false);
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

	            if(productLine == 'Dry'){
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
		$("#modifyvehicleDropDownID").empty().select2();
		$.ajax({
	        url: '<%=request.getContextPath()%>/TripCreatAction.do?param=getvehiclesandgroupforclients',
	        data: {
	         productLine : document.getElementById('modifyProductLineComboId').value,
	         vehicleReporting :vehicleReporting,
	         date : document.getElementById('dateTimeInput').value
	        },
	        success: function(result) {
	        	$("#modifyvehicleDropDownID").empty().select2();
	        	$('#modifyvehicleDropDownID').append($("<option></option>").attr("value", globalVehicleSelected).text(globalVehicleSelected));
	            vehicleList = JSON.parse(result);
	            for (var i = 0; i < vehicleList["clientVehicles"].length; i++) {
                    $('#modifyvehicleDropDownID').append($("<option></option>").attr("value", vehicleList["clientVehicles"][i].vehicleName).text(vehicleList["clientVehicles"][i].vehicleName));
	            }

	            $('#modifyvehicleDropDownID').select2();
	            $('#modifyvehicleDropDownID').val(globalVehicleSelected);//.trigger('change');

	        }
	    });
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
								if('<%=userAuthority%>' == 'Admin'){
									$("#driverIdm1"+count).prop("disabled", false);
									$("#driverIdm2"+count).prop("disabled", false);
									$("#updateButtionId").show();
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
							}else{
								if('<%=userAuthority%>' == 'Admin'){
									$("#driverIdm1"+count).prop("disabled", false);
									$("#driverIdm2"+count).prop("disabled", false);
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

			if (productLine != 'Dry'){
			modtemperatureCounter = 0;
			document.getElementById("modTempConfigTableId").style.display = "block";
			document.getElementById("modTemperatureTableId").style.display = "block";
			$.ajax({
	      		url: '<%=request.getContextPath()%>/TripCreatAction.do?param=getExistingTempConfigurations',
	      		data:{
	      			tripId : uniqueId,
	      			vehicleNo : globalVehicleSelected
	      		},
	      		success: function(result) {
	      		$("#modTemperatureTableId").empty();
					        	modtemperatureCounter = 0;
					            modBeanList = JSON.parse(result);
					            if (modBeanList["tempConfigurationsByVehicleNoDetails"].length > 0){


					            for (var i = 0; i < modBeanList["tempConfigurationsByVehicleNoDetails"].length; i++) {
					             console.log(modBeanList["tempConfigurationsByVehicleNoDetails"][i]);
					             temperaturesArray = "";
					             modtemperatureCounter++;
								    $("#modTemperatureTableId").append("<tr><td width = 10%  id=temperatureColumns><input id=exm1"+i+" value = "+modBeanList["tempConfigurationsByVehicleNoDetails"][i].name+"  type=text style=text-align:center;  disabled /></td>"+
								     " <td width = 10% >Min -ve</td><td width = 10%  id=temperatureColumns><input id=exm2"+i+" value = "+modBeanList["tempConfigurationsByVehicleNoDetails"][i].minNegativeTemp+"  type=text style=text-align:center; onkeypress='return checkTemperature(event)' onchange = 'checkTemperature1(this.id,this.value)'  required /></td>"+
								     " <td width = 10%  >Max -ve</td><td width = 10%  id=temperatureColumns><input id=exm3"+i+" value = "+modBeanList["tempConfigurationsByVehicleNoDetails"][i].maxNegativeTemp+"  type=text style=text-align:center; onkeypress='return checkTemperature(event)' onchange = 'checkTemperature1(this.id,this.value)' required /></td>"+
								     " <td width = 10%  >Min +ve</td><td width = 10%  id=temperatureColumns><input id=exm4"+i+" value = "+modBeanList["tempConfigurationsByVehicleNoDetails"][i].minPositiveTemp+"  type=text style=text-align:center; onkeypress='return checkTemperature(event)' onchange = 'checkTemperature1(this.id,this.value)' required /></td>"+
									 " <td width = 10%  >Max +ve</td><td width = 10%  id=temperatureColumns><input id=exm5"+i+" value = "+modBeanList["tempConfigurationsByVehicleNoDetails"][i].maxPositiveTemp+"  type=text  style=text-align:center; onkeypress= 'return checkTemperature(event)' onchange = 'checkTemperature1(this.id,this.value)' required /></td> "+
									" <td width = 10% style=display:none;  id=temperatureColumns><input id=exm6"+i+" value = "+modBeanList["tempConfigurationsByVehicleNoDetails"][i].sensorName+"  type=text  style=text-align:center;  required /></td>					 </tr>");
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
					            checkProduct();
					            document.getElementById("modTempConfigTableId").style.display = "none";
								document.getElementById("modTemperatureTableId").style.display = "none";
					            }

					        }
			});
			}

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
	        reasonId : reasonId
	    };

	    $.ajax({
	        url: '<%=request.getContextPath()%>/TripCreatAction.do?param=cancelTrip',
	        data: param,
	        success: function(result) {
	        $('#cancelModal').modal('hide');
	        	if (result == "Trip Closed") {

	                     sweetAlert("Trip Cancelled Successfully");
	                     document.getElementById("remarksId").value="";
	                   setTimeout(function(){
	                    getData();
	                     }, 1000);
	                 } else {
	                 	document.getElementById("remarksId").value="";
	                    sweetAlert(result);
	                 }
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
    if(vehicleNo=="-- select vehicle number --"){
    	sweetAlert("Please select Vehicle Number");
    	return;
    }
    if($('#addProductLineComboId option:selected').attr("value") == "" || $('#addProductLineComboId option:selected').attr("value") == 'undefined'){
    	sweetAlert("Please select Product Line");
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
    if(document.getElementById("custReferenceId").value==""){
		sweetAlert("Please Enter Customer Reference ID");
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

    //if(productLine == "Chiller" || productLine == "Freezer"){
    if(productLine12 != "Dry"){
    			allTemperaturesArray = [];
		    for (var j=0;j < temperatureCounter ;j++ ){
 var name2 = "";
				    var minNeg = parseFloat(document.getElementById("ex20").value);
				    var maxNeg = parseFloat(document.getElementById("ex30").value);
				    var minPos = parseFloat(document.getElementById("ex40").value);
				    var maxPos = parseFloat(document.getElementById("ex50").value);
				    var sensorName = document.getElementById("ex60").value;
				    console.log(" minNeg : "+minNeg + " maxNeg : "+maxNeg + " minPos : "+minPos + " maxPos : "+maxPos);

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
		customerName : customerName, // Main  customer for  no generation,
		selSensorsToAlertTrigger : JSON.stringify(selecedSensorsForAlert) 
        };
    $.ajax({
        url: '<%=request.getContextPath()%>/QTPAction.do?param=saveTripData',
        data: param,
        success: function(result) {
        var resp =  [] ;
            resp = result.split(",");
        	if (resp[0] == "Saved Successfully") {

				if(fileImgPath!="" && fileImgPath != null){
				document.getElementById("imageForm").submit();
				}

   			   if('<%=pageId%>' == 'vehicleReport'){
   			   		openVehicleReportPage();
   			   	}
               		setTimeout(function(){
		               	sweetAlert("Trip No - "+resp[2]+" saved successfully");
		                getData();
		                getRoute();
		                //document.getElementById("addcustNameDownID").value="";
		                document.getElementById("custReferenceId").value="";
		               // document.getElementById("addorderId").value="";
		                document.getElementById("addvehicleDropDownID").value="";
					    document.getElementById("addrouteDropDownID").value = "";
					    document.getElementById("imgUploadId").value = "";
					    $('#adddateTimeInput ').jqxDateTimeInput('setDate', new Date());
					    $('input:checkbox').removeAttr('checked');
					    document.getElementById("avgSpeedId").value = "";
					    $('#add').modal('hide');
					    reset();
							resetExisting();
					    //window.location.reload();


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
	    	sweetAlert("Invalid Vehicle Number");
	    	return;
	    }if(modVehNo=="-- select vehicle number --" ){
	    	sweetAlert("Invalid Vehicle Number");
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
	       if(document.getElementById("modifyProductLineComboId").value != "Dry"){
    			modTemperaturesArray = [];
		    for (var l=0;l < modtemperatureCounter ;l++ ){
				    var name2Mod = document.getElementById("exm1"+l).value;
				    var minNegMod = parseFloat(document.getElementById("exm2"+l).value);
				    var maxNegMod = parseFloat(document.getElementById("exm3"+l).value);
				    var minPosMod = parseFloat(document.getElementById("exm4"+l).value);
				    var maxPosMod = parseFloat(document.getElementById("exm5"+l).value);
				    var sensorNameMod = document.getElementById("exm6"+l).value;

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

		    }
		    modTempeartureArrayData = JSON.stringify(modTemperaturesArray);
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
	    $('#ataDateTimeInput').jqxDateTimeInput('setDate', '');
	    $('#atdDateTimeInput').jqxDateTimeInput('setDate', '');
	    $('#stpDateTime').val('');
	    $('#staDateTime').val('');
	    $('#stdDateTime').val('');
	    $('#overrideRemarksId').val('');

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
            	console.log(tripList);
   		        $('#tripNameCombo').append($("<option></option>").attr("value", 0).text("--Select Trip Name--"));
	            for (var i = 0; i < tripList["tripDetails"].length; i++) {
                 			$('#tripNameCombo').append($("<option></option>").attr("value", tripList["tripDetails"][i].id)
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
		if(tripId == 0){
			sweetAlert("Please select a Trip name");
			return;
		}

		var atp = document.getElementById("atpDateTimeInput").value;
		var atd = document.getElementById("atdDateTimeInput").value;
		if(atp == ''){
			sweetAlert("Please enter ATP");
			return;
		}
		if(atd == ''){
			sweetAlert("Please enter ATD");
			return;
		}
		var remarks = document.getElementById("overrideRemarksId").value;
		var valAtpDate = atp.split("/");
		var valAtdDate = atd.split("/");
    		var parsedAtpDate = new Date(valAtpDate[1] + "/" + valAtpDate[0] + "/" + valAtpDate[2]);
    		var parsedAtdDate = new Date(valAtdDate[1] + "/" + valAtdDate[0] + "/" + valAtdDate[2]);
		if(parsedAtpDate > parsedAtdDate){
			sweetAlert("ATP cannot be greather than ATD");
			return;
		}

		$.ajax({
            type: "POST",
            url: '<%=request.getContextPath()%>/TripCreatAction.do?param=updateTripActualTime',
            "data": {
            	 tripId: tripId,
            	 atp: atp,
            	 atd: atd,
            	 remarks:remarks,
            	 vehicleNo:vehicleNo
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
    function checkTemperature(event){
    	if(!((event.keyCode >= 48) && (event.keyCode <= 57) || event.keyCode == 46 || event.keyCode == 45)){
       		event.returnValue = false;
       		return;
    	}
    	event.returnValue = true;
    }
    function checkTemperature1(id,value){
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
		var productLine = document.getElementById('addProductLineComboId').value;
		var date = document.getElementById('adddateTimeInput').value;
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
		if(productLine == 'Dry')
		{
			document.getElementById("tempTableId").style.display = "none";
			document.getElementById("tempConfigTableId").style.display = "none";
			document.getElementById("temperatureEvents").style.display = "none";
		}
		else
		{
			document.getElementById("tempTableId").style.display = "block";
			document.getElementById("tempConfigTableId").style.display = "block";
			document.getElementById("temperatureEvents").style.display = "block";
		}

	}

	function openVehicleReportPage(){
		window.location.href = "<%=request.getContextPath()%>/Jsps/DistributionLogistics/VehicleReporting.jsp?hubId=<%=hubId%>";
	}

	function plotLegDetails(){
		$("#legTableId").empty();
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
		            if(currentProductLine != "Dry"){
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
                                 console.log(beanList["tempConfigurationsByVehicleNoDetails"][i]);
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
                                     " <td><input value = -70  class='colorbox'  style='color:black' disabled /></td> "+
                                     " <td width = 10% ><input class='colorbox' style='background-color: red;' value='Critical' disabled></td><td width = 10%  id=temperatureColumns><input class='mybox' id=ex2"+i+" value = "+minNegativeTemp+"  type=text style=text-align:center; onkeypress='return checkTemperature(event)' onchange = 'checkTemperature1(this.id,this.value)'  required /></td>"+
                                     " <td width = 10% ><input class='colorbox' style='background-color: yellow;color:black' value='Abnormal' disabled ></td><td width = 10%  id=temperatureColumns><input class='mybox' id=ex3"+i+" value = "+maxNegativeTemp+"  type=text style=text-align:center; onkeypress='return checkTemperature(event)' onchange = 'checkTemperature1(this.id,this.value)' required /></td>"+
                                     " <td width = 10% ><input class='colorbox' style='background-color: green;' value='Normal' disabled ></td><td width = 10%  id=temperatureColumns><input class='mybox' id=ex4"+i+" value = "+minPositiveTemp+"  type=text style=text-align:center; onkeypress='return checkTemperature(event)' onchange = 'checkTemperature1(this.id,this.value)' required /></td>"+
                                     " <td width = 10% ><input class='colorbox' style='background-color: yellow;color:black' value='Abnormal' disabled ></td><td width = 10%  id=temperatureColumns><input class='mybox' id=ex5"+i+" value = "+maxPositiveTemp+"  type=text  style=text-align:center; onkeypress= 'return checkTemperature(event)' onchange = 'checkTemperature1(this.id,this.value)' required /></td> "+
                                     " <td width = 10% ><input class='colorbox' style='background-color: red;' value='Critical' disabled ></td> " +
                                     " <td><input value = 70  class='colorbox'  style='color:black' disabled /></td> "+
                                     " <td width = 10% style=display:none;  id=temperatureColumns><input class='mybox' id=ex6"+i+" value = "+sensor+"  type=text  style=text-align:center; required /></td>                  </tr>");
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
									 "<td><input  type='checkbox' id="+beanList["tempConfigurationsByVehicleNoDetails"][i].sensorName+" checked> </td> <td><b style='margin-left : 1px;margin-right : 8px;'>"+tempName+" </b> </td> ");
									}else{
								   	 $("#temperatureEvents").append(								     
									 "<td><input  type='checkbox' id="+beanList["tempConfigurationsByVehicleNoDetails"][i].sensorName+"> </td> <td><b style='margin-left : 1px;margin-right : 8px;'>"+tempName+" </b> </td> ");
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
	            $('#addrouteDropDownID').select2();
				$('#addrouteDropDownID').val(routeValue).trigger('change');

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
		var ata = document.getElementById("ataDateTimeInput").value;
		document.getElementById("close"+uniqueId).disabled=true;
		if(destinationArrived == true){
			ata = "";
		}

		$.ajax({
	        url: '<%=request.getContextPath()%>/TripCreatAction.do?param=closeTrip',
	        data: {
	        	uniqueId,
	        	vehicleNo:globalVehicleSelected,
	        	remarksData: remarksDetails,
	        	ata:ata,
	        	destinationArrived:destinationArrived
	        },
	        success: function(result) {
                	setTimeout(function(){
                		sweetAlert(result);
                    	getData();
                    }, 1000);

	            }
		});
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


		var productLine = document.getElementById('modifyProductLineComboId').value;
		var date = document.getElementById('dateTimeInput').value;

		if (productLine != 'Dry'){
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
	            vehicleList = JSON.parse(result);
	            if (globalProductLineSelected == productLine){
	            	 $('#modifyvehicleDropDownID').append($("<option></option>").attr("value", globalVehicleSelected).text(globalVehicleSelected));
	            }

	            for (var i = 0; i < vehicleList["clientVehicles"].length; i++) {
                    $('#modifyvehicleDropDownID').append($("<option></option>").attr("value", vehicleList["clientVehicles"][i].vehicleName).text(vehicleList["clientVehicles"][i].vehicleName));
	            }
	            $('#modifyvehicleDropDownID').select2();
	        }
	    });
	}

		function plotLegDetailsModificationOnRouteChange(){

		var routeId = $('#modifyrouteDropDownID option:selected').attr("value");
		//if(materialClient == 'Y'){
		//	 routeId= $('#modifyrouteDropDownID option:selected').attr("routeId");
		//}
		if (routeId == globalRouteId){
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
	$("#modifyProductLineComboId").change(function() {

		if(document.getElementById('modifyProductLineComboId').value == 'Dry'){
			$('#preloadTempModifyId').hide();
			$('#pleLoadTempLblId').hide();
		}else{
			$('#preloadTempModifyId').show();
			$('#pleLoadTempLblId').show();
		}
	})

	function getTripCancellationRemarks(){
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

		            if(currentProductLineMod != "Dry"){
				           $.ajax({
					        url: myUrl,
					        data: param,
					        success: function(result) {
					        	modtemperatureCounter = 0;
					            beanList = JSON.parse(result);
					            if (beanList["tempConfigurationsByVehicleNoDetails"].length > 0){


					            for (var i = 0; i < beanList["tempConfigurationsByVehicleNoDetails"].length; i++) {
					             console.log(beanList["tempConfigurationsByVehicleNoDetails"][i]);
					             modtemperatureCounter++;
					            		minPositiveTemp = minNegativeTemp = maxPositiveTemp = maxNegativeTemp = "";
					            		var name1 =  beanList["tempConfigurationsByVehicleNoDetails"][i].name ;
									 minPositiveTemp = beanList["tempConfigurationsByVehicleNoDetails"][i].minPositiveTemp;
								     minNegativeTemp = beanList["tempConfigurationsByVehicleNoDetails"][i].minNegativeTemp;
								     maxPositiveTemp = beanList["tempConfigurationsByVehicleNoDetails"][i].maxPositiveTemp;
								     maxNegativeTemp = beanList["tempConfigurationsByVehicleNoDetails"][i].maxNegativeTemp;
								     var sensor = beanList["tempConfigurationsByVehicleNoDetails"][i].sensorName;
								    $("#modTemperatureTableId").append("<tr><td width = 10%  id=temperatureColumns><input id=exm1"+i+" value = "+name1+"  type=text style=text-align:center;  disabled /></td>"+
								     " <td width = 10% >Min -ve</td><td width = 10%  id=temperatureColumns><input id=exm2"+i+" value = "+minNegativeTemp+"  type=text style=text-align:center; onkeypress='return checkTemperature(event)' onchange = 'checkTemperature1(this.id,this.value)'  required /></td>"+
								     " <td width = 10%  >Max -ve</td><td width = 10%  id=temperatureColumns><input id=exm3"+i+" value = "+maxNegativeTemp+"  type=text style=text-align:center; onkeypress='return checkTemperature(event)' onchange = 'checkTemperature1(this.id,this.value)' required /></td>"+
								     " <td width = 10%  >Min +ve</td><td width = 10%  id=temperatureColumns><input id=exm4"+i+" value = "+minPositiveTemp+"  type=text style=text-align:center; onkeypress='return checkTemperature(event)' onchange = 'checkTemperature1(this.id,this.value)' required /></td>"+
									 " <td width = 10%  >Max +ve</td><td width = 10%  id=temperatureColumns><input id=exm5"+i+" value = "+maxPositiveTemp+"  type=text  style=text-align:center; onkeypress= 'return checkTemperature(event)' onchange = 'checkTemperature1(this.id,this.value)' required /></td> "+
									" <td width = 10% style=display:none;  id=temperatureColumns><input id=exm6"+i+" value = "+sensor+"  type=text  style=text-align:center;  required /></td>	 </tr>");
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

    </script>
  <jsp:include page="../Common/footer.jsp" />
	<!-- </body>   -->
<!-- </html> -->
