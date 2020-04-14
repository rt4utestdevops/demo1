<%@ page language="java" import="java.util.*,t4u.functions.CommonFunctions,t4u.beans.*,t4u.common.*" pageEncoding="ISO-8859-1"%>
  <%
     String path = request.getContextPath();
     String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
     Properties properties = ApplicationListener.prop;
	 LoginInfoBean loginInfo=(LoginInfoBean) session.getAttribute( "loginInfoDetails");
     //String t4uspringappURL =  "https://track-staging.dhlsmartrucking.com/t4uspringapp/";
     String t4uspringappURL =  properties.getProperty("t4uspringappURL").trim();
     String tripIdFromSLA = request.getParameter("tripId");
	 MapAPIConfigBean bean = loginInfo.getMapAPIConfig();
		String mapName = bean.getMapName();
		String appKey = bean.getAPIKey();
		String appCode = bean.getAppCode();
     %>
    <jsp:include page="../Common/header.jsp" />
    <title>CE Dashboard
    </title>
    <head>
      <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js">
      </script>
      <script src="https://cdn.datatables.net/1.10.19/js/jquery.dataTables.min.js">
      </script>
      <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.8.1/css/all.css" integrity="sha384-50oBUHEmvpQ+1lW4y57PTFmhCaXp0ML5d60M1M7uH2+nqUivzIebhndOJK28anvf" crossorigin="anonymous">
      <link rel="stylesheet" href="https://cdn.datatables.net/1.10.19/css/jquery.dataTables.min.css"/>
      <script src="https://cdn.datatables.net/buttons/1.5.6/js/dataTables.buttons.min.js">
      </script>
      <script src="https://cdn.datatables.net/buttons/1.5.6/js/buttons.flash.min.js">
      </script>
      <script src="https://cdn.datatables.net/buttons/1.5.6/js/buttons.html5.min.js">
      </script>
      <script src="https://cdn.datatables.net/buttons/1.5.6/js/buttons.print.min.js">
      </script>
      <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css"/>
      <link rel="stylesheet" href="https://cdn.datatables.net/1.10.19/css/dataTables.bootstrap.min.css"/>
      <link rel="stylesheet" href="https://cdn.datatables.net/responsive/2.2.3/css/responsive.bootstrap.min.css"/>
      <link href="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.7/css/select2.min.css" rel="stylesheet" />
      <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css" type="text/css" />
      <script src="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.7/js/select2.min.js">
      </script>
      <script type="text/javascript" src="../Analytics/js/charts/flot/fusioncharts/fusioncharts.js">
      </script>
      <script type="text/javascript" src="https://rawgit.com/fusioncharts/fusioncharts-jquery-plugin/develop/dist/fusioncharts.jqueryplugin.min.js">
      </script>
      <script type="text/javascript" src="https://cdn.fusioncharts.com/fusioncharts/latest/themes/fusioncharts.theme.fusion.js">
      </script>
    </head>
    <style>
      ithead th {
        white-space: nowrap;
      }
      thead {
        /*color: #D80613;
        background-color: #FFCB01;*/
        color: #ece9e6 !important;
        background-color: #355869 !important;
        padding-top:8px;
        padding-bottom:8px;
      }
      table.dataTable {
        border-color: #939393;
        border: none;
      }
      body{
        overflow-x: hidden;
      }
      #blinkingRow{
        margin:20px 0px 0px 0px;
        color:white;
        text-align:center;
        font-size:16px;
        display: none;
        background:rgb(58, 96, 115);
      }
      #note{
        margin:8px;
        color:#AB0608;
        text-align:center;
        font-size:14px;
        display: none;
      }
      .blink_me {
        animation: blinker 3s linear infinite;
      }
      @keyframes blinker {
        50% {
          opacity: 0;
        }
      }
      .greenColorBorder{
        color: #7DCB51 !important;
        border: 1px solid #7DCB51!important;
		text-align:center !important;
		padding:8px !important;
      }
      .redColorBorder{
        color: #D40511 !important;
        border: 1px solid #D40511!important;
      }
      .red{
        color: #D40511;
      }
      .green{
        color: #7DCB51;
      }
      .yellow{
        color: #FFCC00;
      }
      .redB{
        background: #D40511 !important;
        transition:all 2s linear !important;
      }
      .greenB{
        background: #7DCB51 !important;
        transition:all 2s linear !important;
      }
      .yellowB{
        background: #FFCC00;
        transition:all 2s linear;
      }
      .greyB{
        background: #dfdfdf;
        transition:all 2s linear;
      }
      .blueB{
        background: #337AB7;
        transition:all 2s linear;
      }
      .mainDivBar{
        width:100%;
        border-radius:4px;
        margin:52px 0px 16px 0px;
        display:flex;
      }
      .mainDivBarInside{
        width:100%;
        max-height:12px;
        border-radius:4px;
        margin-right: -2px;
        margin-left: -2px;
        margin-top:6px;
        display:flex;
        z-index:1;
        position: relative;
      }
      .start{
        border-radius: 50%;
        width:24px;
        height:24px;
        z-index:100;
      }
      .end{
        border-radius: 50%;
        width:24px;
        height:24px;
        z-index:1;
      }
      .flex{
        display:flex;
      }
      .first{
        width:40%;
      }
      .second{
        width:40%;
      }
      .third{
        width:20%;
      }
      .thirdTop{
        display: flex;
        flex: 1;
        justify-content: flex-end;
        flex-direction: row;
      }
      .statusMain{
        /*background:#FFCC00;*/ color: #ece9e6 !important;
        padding:16px;
        border: 1px solid #ece9e6;
        font-weight: 600;
        width: 140px !important;
        font-size:14px !important;
        color:white;
        height: 80px;
        border-radius: 4px;
        display:table-cell;
        vertical-align:center !important;
        text-align:center;
      }
      .detailsBoard {
        background-color: #f7f7f7 !important;
        border-radius: 4px;
        padding: 8px 16px;
        color: #4a4a4a;
        opacity: 1;
        margin-top: 16px;
        z-index: 10000;
        margin-right: 0px !important;
        margin-left: 0px !important;
        box-shadow: 0 4px 10px 0 rgba(0, 0, 0, 0.2), 0 4px 20px 0 rgba(0, 0, 0, 0.19);
      }
      .card {
        /*box-shadow: 0 1px 3px rgba(0,0,0,0.12), 0 1px 2px rgba(0,0,0,0.24);*/
        box-shadow: 0 4px 10px 0 rgba(0, 0, 0, 0.2), 0 4px 20px 0 rgba(0, 0, 0, 0.19);
        /*transition: all 0.3s cubic-bezier(.25,.8,.25,1);*/
        padding: 10px;
        margin: 4px 8px 16px 0px;
        z-index:0;
      }
      .blueDot{
        width:24px;
        height:24px;
        border-radius: 50%;
        background-color: #1565c0;
        ? margin-top: -6px;
        ? margin-right: -12px;
        position:absolute;
      }
      .mainDivBarTop{
        width:100%;
        border-radius:4px;
        margin:16px 0px 8px 0px;
        display:flex;
        font-size:12px;
      }
      .mainDivBarBottom{
        width:100%;
        border-radius:4px;
        margin:0px 0px 24px 0px;
        display:flex;
        font-size:12px;
      }
      .col-lg-8{
        padding:0px;
      }
      .bar{
        position: absolute;
        height: 12px;
      }
      .barDot,.barDotTruck{
        position: absolute;
        height: 24px;
        width: 24px;
        margin-top:-5px;
      }
      .select2-container--default .select2-selection--single {
        height: 32px !important;
        padding-top: 2px !important;
      }
      .select2-container--default .select2-selection--single .select2-selection__arrow b {
        margin-top: 0px !important;
      }
      .tip{
        transform: translateY(-50%) rotate(45deg);
        left: 48%;
        top: 0px;
        position: absolute;
        background-color: #f7f7f7;
        /* z-index: 2; */
        border-width: 1px;
        border-style: solid;
        border-color: #7f7f7f  transparent transparent #7f7f7f;
        width: 23px;
        height: 23px;
      }
      .cardUser {
        box-shadow: 0 2px 5px 0 rgba(0,0,0,0.2), 0 2px 10px 0 rgba(0,0,0,0.19);
        padding: 10px;
        margin-bottom: 8px;
        border-radius: 2px !important;
      }
      hr {
        margin-top: 3px !important;
        margin-bottom: 3px !important;
        border: 0;
        border-top: 1px solid #eee;
      }
      .center-view{
        top:40%;
        left:50%;
        position:fixed;
        height:200px;
        width:200px;
        z-index: 10;
      }
      .center-viewLoading1{
        top:40%;
        left:32%;
        position:fixed;
        height:200px;
        z-index: 10;
      }
      .w3-card-4 {
        margin-top: -32px;
        margin:-16px -4px 0px -4px;
        padding-bottom: 8px;
        padding-left:8px;
        padding-right:8px;
      }
      .hrStyle {
        padding: 4px 16px;
        margin-bottom: 0px;
        border-radius: 2px;
        opacity: 1;
        background: #FFCC00;
        text-transform: uppercase;
        color: #d40511;
        height: 40px;
        align-items:center;
      }
      .select2-container{
        width :300px !important;
      }
      #select2-tripNoSelect-results{
        font-size:12px !important;
      }
      .select2-selection__rendered {
        text-align: center;
      }
      .nowrap{
        white-space:nowrap;
      }
      .actionBox{
        border-radius: 8px;
        padding:8px 8px;
        font-size:12px;
        text-align:center;
        margin:2px 0px;
        width:100% !important;
        font-weight:bold;
      }
      .actionReqText{
        font-size: 16px;
        color: #263238 !important;
        text-transform: capitalize;
      }
      .blue-gradient-rgba {
        background: linear-gradient(to right, rgb(58, 96, 115), rgb(22, 34, 42))!important;
      }
      .orange-gradient-rgba {
        background: linear-gradient(to right, #FFCC00, #D40511) !important;
      }
      .select2-dropdown{
        margin-top: -40px;
      }
      .blink {
        animation: blink 1s steps(5, start) infinite;
        -webkit-animation: blink 1s steps(5, start) infinite;
      }
      @keyframes blink {
        to {
          visibility: hidden;
        }
      }
      @-webkit-keyframes blink {
        to {
          visibility: hidden;
        }
      }
      .arrowStyle{
        width: 0;
        height: 0;
        border-top: 12px solid transparent;
        border-bottom: 12px solid transparent;
        margin-left: 20px;
        margin-top: -18px;
      }
      .object{
        transition:7s;
        -webkit-transition:7s;
        -moz-transition:7s;

      }
      .object:hover{
        right:0;
      }
      .pill{
        min-width:200px;
        border-radius:10px;
        padding:4px 24px;
        background: #FFCC00;
        color: #D40511;
        border: 1px solid #D40511;
        font-weight:bold;
      }
      .dispNone{
        display:none;
      }
      .cardDet {
        font-weight: 600;
        border: 0;
        box-shadow: 0 2px 5px 0 rgba(0, 0, 0, .16), 0 2px 10px 0 rgba(0, 0, 0, .12);
        position: relative;
        display: flex;
        flex-direction: column;
        min-width: 0;
        word-wrap: break-word;
        background-color: #fff;
        background-clip: border-box;
        border-radius: .25rem;
        padding: 0px;
        border: 0px !important;
        text-align: center;
      }
      .cardHeading {
        width: 100%;
        text-align: left;
        color: white;
        border-top-left-radius: 8px;
        border-top-right-radius: 8px;
        font-size: 12px;
        font-weight: 700;
        display: flex;
        justify-content: space-between;
        padding: 8px 20px;
      }
      .blue-gradient-rgba {
        background: linear-gradient(to right, rgb(58, 96, 115), rgb(22, 34, 42))!important;
      }


	   .badge{
        min-width: 80px;
        height: 24px;
        background: linear-gradient(40deg, #777777, #000C40);
        padding-top: 6px !important;
        margin-top: 2px;
        margin-left:16px;
      }

      .list-group-item {
        padding:4px 16px;
      }
      body{
        font-size:12px;
      }
      .bWidth{
        min-width:200px;
      }
      .bWidthXL{
        min-width:400px;
      }
	  		#actionRequiredBoxId{
				min-height: 36px;
				align-items: center;
				display: flex;
				justify-content: center;
			}
			#cardDet ul .list-group-item{
				padding:6px 16px !important;

			}
			#cardDet{
				height:150px !important;width:30% !important;
			}
			
			.tooltipQ {
				

}

.weatherContainer .tooltiptext {
  visibility: hidden;
  width: 250px;
  background-color: white;
  color: #000;
  text-align: center;
  border-radius: 6px;
  padding: 5px 0;
  border: 1px solid #ffcc00;

  /* Position the tooltip */
  position: absolute;
  z-index: 1;
  top: -900%;
  left: 64%;
  margin-left: -60px;
}

.weatherContainer:hover .tooltiptext {
  visibility: visible;
}

/*.toolTipDiv{
  border-bottom: 1px solid #dfdfdf;
  margin:2px 8px;
  text-align: left;
}*/

.toolTipDivLast{
  margin:2px 8px;
  text-align: left;
}

.weatherContainer{
	width:250px;margin-top:-8px;margin-bottom:8px;position:absolute;left:62%;}
	
	.imgDiv{
		width:60px;height:60px;
		background: rgb(58, 96, 115);
    border-radius: 50%;
    justify-content: center;
    display: flex;
	align-items: center;}

    </style>
    <div class="center-view" style="display:none;" id="loading-div">
      <img src="../../Main/images/loading.gif" alt="">
    </div>
    <div id="loading"  class="center-viewLoading1" style="/* display: none; */">
      <img id="loading-image" src="https://www.dhlsmartrucking.com/images/loading1.gif" alt="Loading...">
      <div style="width:100%;text-align:center;padding-top:16px;"> PLEASE SELECT A TRIP...
      </div>
    </div>
    <div class="w3-card-4">
      <div class="card-body hrStyle" style="justify-content:space-between;display:flex;">
        <div style="font-weight:bold;font-size:14px;">Customer Excellence Dashboard
        </div>
        <div>
          <select id="tripNoSelect" onchange="getDetails(true);" style="width:200px;height:30px !important;">
          </select>
        </div>
      </div>
    </div>
    <div id="tripDetDiv" style="display:none;">
      <div class="flex" style="justify-content:space-between;">
        <div class="cardDet" id="cardDet" >
          <div class="cardHeading blue-gradient-rgba">
            <div class="threePixelPadding" style="text-align:center;width:100%">TRIP DETAILS
            </div>
          </div>
          <ul class="list-group">
            <li  class="list-group-item d-flex justify-content-between align-items-center flexRow">
							<span data-toggle="tooltip" title="">Trip No.
              </span>
              <span class="badge badge-primary badge-pill bWidth" id="tripNo" >
                <i class="fas fa-spinner fa-spin spinnerColor">
                </i>
              </span>
            </li>
            <li class="list-group-item d-flex justify-content-between align-items-center flexRow">
              <span data-toggle="tooltip" title="">Vehicle No.
              </span>
              <span class="badge badge-primary badge-pill bWidth" id="vehicleNo" >
                <i class="fas fa-spinner fa-spin spinnerColor">
                </i>
              </span>
            </li>
            <li class="list-group-item d-flex justify-content-between align-items-center flexRow" style="padding:7px 16px !important;">
              <span data-toggle="tooltip" title="">Customer Name
              </span>
              <span class="badge badge-primary badge-pill bWidth" id="customerName">
                <i class="fas fa-spinner fa-spin spinnerColor">
                </i>
              </span>
            </li>
          </ul>
        </div>
        <div class="cardDet" style="height:148px;margin-left:16px;width:20%;">
          <div class="cardHeading blue-gradient-rgba">
            <div class="threePixelPadding" style="text-align:center;width:100%">TRIP STATUS
            </div>
          </div>
          <ul class="list-group">
            <li  class="list-group-item d-flex justify-content-between align-items-center flexRow">
              <div class="badge" id="statusMainBack" style="padding:32px 16px;width: 100%;margin-left: 0px;" >
                <div>
                  <div id="statusMain">
                    <strong>
                    </strong>
                  </div>
                  <div id="by" style="display:none;margin-top:2px;"><span id="lateEarly">Late</span> By:&nbsp;
                    <span id="delayedBy" style="font-size:12px;display:none;">HH:mm
                    </span>
                  </div>
                </div>
              </div>
            </li>
            <li class="list-group-item d-flex justify-content-between align-items-center flexRow">
              <span data-toggle="tooltip" title="">CH Detention
              </span>
              <span class="badge badge-primary badge-pill" id="chDetention">
                <i class="fas fa-spinner fa-spin spinnerColor">
                </i>
              </span>
            </li>
            <li class="list-group-item d-flex justify-content-between align-items-center flexRow">
              <span data-toggle="tooltip" title="">SH Detention
              </span>
              <span class="badge badge-primary badge-pill" id="shDetention">
                <i class="fas fa-spinner fa-spin spinnerColor">
                </i>
              </span>
            </li>
          </ul>
        </div>
        <div class="cardDet" style="height:136px;margin-left:16px;width:50%;">
          <div class="cardHeading blue-gradient-rgba">
            <div class="threePixelPadding" style="text-align:center;width:100%">TRIP ACTION
            </div>
          </div>
          <ul class="list-group">
            <li  class="list-group-item d-flex justify-content-between align-items-center flexRow">
              <div id = "actionRequiredBoxId" class="actionBox bWidthXL" style="padding: 2px 2px ; color:white !important;">
                <span id="actionReqText" style="color:white !important;">
                </span>
              </div>
            </li>
            <li class="list-group-item d-flex justify-content-between align-items-center flexRow">
              <span data-toggle="tooltip" title="">Current Location
              </span>
              <span class="badge badge-primary badge-pill bWidthXL" id="currentLoc" >
                <i class="fas fa-spinner fa-spin spinnerColor">
                </i>
              </span>
            </li>
            <li class="list-group-item d-flex justify-content-between align-items-center flexRow">
              <span data-toggle="tooltip" title="">Status
              </span>
              <span class="badge badge-primary badge-pill bWidthXL" id="tripCreationStatus">
                <i class="fas fa-spinner fa-spin spinnerColor">
                </i>
              </span>
            </li>
          </ul>
        </div>
        <!-- <div style="display:flex;flex-direction:column;width:85%">
<div style="display:flex;justify-content:space-between;margin:4px 24px; color:#D40511 !important;    right: 0px;
position: absolute;
left: 150px;">
<div><strong class="nowrap"><span class="black">TRIP NO:</span>&nbsp;<span id="tripNo"></span></strong></div>
<div><strong class="nowrap"><span class="black">VEHICLE NO:</span>&nbsp;<span id="vehicleNo"></span></strong></div>
<div><strong class="nowrap"><span class="black">CUSTOMER NAME:</span>&nbsp;<span id="customerName"></span></strong></div>
</div>
<div  class="row nowrap" style="margin:44px 8px 4px 4px;position: absolute;left: 154px; right:16px;">
<div class="col-lg-2" title="Customer Hub Detention" style="padding:0px 0px 8px 16px;">
<strong>CH Detention</strong><br/><span id="chDetention" class="pill">CH Det</span>
</div>
<div class="col-lg-2" title="Smart Hub Detention"  style="padding:0px 0px;">
<strong>SH Detention</strong><br/><span id="shDetention" class="pill">SH Det</span>
</div>
<div class="col-lg-8">
<div id = "actionRequiredBoxId" class="actionBox"><span id="actionReqText"></span></div>
</div>
</div>
</div>-->
      </div>
      <div class="row card" id="blinkingRow" style="display:none;">
        <div class="col-lg-12">
          <div class="blink_me" id="blinkingText">Please Note: The trip has been updated and is currently being re-processed. Please check back after sometime for the latest actuals.
          </div>
        </div>
      </div>
      <div class="row" id="note">
        <div class="col-lg-12">
          <div class="note" id="noteText">
          </div>
        </div>
      </div>
      <div class="row cardUser"  style="background:#f7f7f7;margin-bottom:16px;margin-top: 16px;margin-left: 2px;margin-right: 0px;font-size:12px;padding:0px 0px 8px 0px;border-radius:8px !important;" id="bottomRow">
        <div class="cardHeading blue-gradient-rgba" style="margin-bottom:8px;">
          <div class="threePixelPadding" style="text-align:center;width:100%">TRIP INFORMATION
          </div>
        </div>
        <!-- <div class="col-lg-9" style="padding:4px 0px;background:#dfdfdf;margin-bottom:8px;border: 1px solid #777777;">
<div style="display:flex;">
<div style="text-align:left;margin-left:8px;white-space:nowrap">Current Location:&nbsp;</div>
<div id="currentLoc" style="font-weight: bold;"></div>
</div>
</div>
<div class="col-lg-3" style="padding:4px 0px;background:#dfdfdf;margin-bottom:8px;border: 1px solid #777777;">
<div style="display:flex;">
<div style="width: 30%;text-align:left;margin-left:8px;">Status</div>
<div id="tripCreationStatus" style="font-weight: bold;width: 65%;"></div>
</div>
</div>-->
        <div class="col-lg-3" style="border-right:1px solid #6d6d6d;padding: initial;">
          <div style="display:flex;">
            <div style="width: 30%;text-align:left;margin-left:8px;">Source
            </div>
            <div id="source" style="font-weight: bold;width: 40%;">
            </div>
			<div id="plannedLoadingDetention" style="font-weight: bold;width: 30%;" title="Planned Loading Detention">
            </div>
          </div>
          <hr>
          <div style="display:flex;">
            <div style="width: 30%;text-align:left;margin-left:8px;">Destination
            </div>
            <div id="destination" style="font-weight: bold;width: 40%;" >
            </div>
			<div id="plannedUnloadingDetention" style="font-weight: bold;width: 30%;" title="Planned Unloading Detention">
            </div>
          </div>
          <hr>
          <div style="display:flex;">
            <div style="width: 30%;text-align:left;margin-left:8px;">Next Point At
            </div>
            <div id="distnaceToNextTouchPoint" style="font-weight: bold;width: 70%;">
            </div>
          </div>
          <hr>
          <div style="display:flex;">
            <div style="width: 30%;text-align:left;margin-left:8px;" title = "incl.SH Stoppages">Planned TT 
            </div>
            <div id="plannedTat" style="font-weight: bold;width: 30%;">
            </div>
          </div>
        </div>
        <div class="col-lg-3" style="border-right:1px solid #6d6d6d;padding: initial;">
          <div style="display:flex;">
            <div style="width: 35%;text-align:left;margin-left:8px;">Planned
            </div>
            <div  style="font-weight: bold;width: 50%;">
              <span id="totalDistnaceId">
              </span>
              <span id="extraPlanned" class="red" title="Excess kilometer planned" style="display:none;">(<span id="extraPlannedDistance"></span>)
              </span>
            </div>
          </div>
          <hr>
          <div style="display:flex;">
            <div style="width: 35%;text-align:left;margin-left:8px;">Travelled</div>
            <div  style="font-weight: bold;width: 50%;">
              <span id="distanceCovered">
              </span>
              <span id="extra" class="red" title="Excess kilometer travelled" style="display:none;">(<span id="extraDistance"></span>)
              </span>
            </div>
          </div>
          <hr>
          <div style="display:flex;">
            <div style="width: 35%;text-align:left;margin-left:8px;">Remaining
            </div>
            <div id="remainingDist" style="font-weight: bold;width: 50%;">
            </div>
          </div>
          <hr>
          <div style="display:flex;">
            <div style="width: 35%;text-align:left;margin-left:8px;">
              <span id="ataDependent" title="incl.SH Stoppages">
              </span> TT 
            </div>
            <div id="elapsedTT" style="font-weight: bold;width: 50%;">
            </div>
          </div>
        </div>
        <div class="col-lg-3" style="border-right:1px solid #6d6d6d;padding: initial;">
          <div style="display:flex;">
            <div style="width: 35%;text-align:left;margin-left:8px;">Last Comm Time
            </div>
            <div id="lastCommTime" style="font-weight: bold;width: 50%;">
            </div>
          </div>
          <hr>
          <div style="display:flex;">
            <div style="width: 35%;text-align:left;margin-left:8px;">Created Time
            </div>
            <div id="tripCreated" style="font-weight: bold;width: 50%;">
            </div>
          </div>
          <hr>
          <div style="display:flex;">
            <div style="width: 35%;text-align:left;margin-left:8px;">Updated Time
            </div>
            <div id="tripLastUpdated" style="font-weight: bold;width: 50%;">
            </div>
          </div>
          <hr>
          <div style="display:flex;">
            <div style="width: 35%;text-align:left;margin-left:8px;">Closed Time
            </div>
            <div id="tripClose" style="font-weight: bold;width: 50%;">
            </div>
          </div>
        </div>
        <div class="col-lg-3" style="padding: initial;">
          <div style="display:flex;">
            <div style="width: 20%;text-align:left;margin-left:8px;">Drivers
            </div>
            <div id="driverName" style="font-weight: bold;width: 80%;">
            </div>
          </div>
          <hr>
          <div style="display:flex;">
            <div style="width: 20%;text-align:left;margin-left:8px;">Contacts
            </div>
            <div id="driverContact" style="font-weight: bold;width: 80%;">
            </div>
          </div>
          <hr>
          <div style="display:flex;">
            <div style="width: 20%;text-align:left;margin-left:8px;">Temp. Set
            </div>
            <div id="setTemp" style="font-weight: bold;width: 80%;">
            </div>
          </div>
          <hr>
          <div style="display:flex;">
            <div style="width: 20%;text-align:left;margin-left:8px;">Curr Temp.
            </div>
            <div id="tempCurr" style="font-weight: bold;width: 80%;">
            </div>
          </div>
        </div>
      </div>
      <div class="card" style="background:#f2f2f2;margin-right:0px;">
        <div class="mainDivBarTop">
          <div class="">
            <strong title="Scheduled Time of Placement">STP:
            </strong>
            <span id="stp">
            </span>
            <br/>
            <strong  title="Actual Time of Placement">ATP:
            </strong>
            <span id="atp">
            </span>
          </div>
          <div style="border: 1px solid #777777;border-radius:4px;padding:8px;margin-left:16px;color:white;font-weight:bold;HEIGHT:36PX;" id="placementDuration" title="Placement Delay">Placement Duration
          </div>
          <div id="chart-container" style="width:250px;height:88px;margin-top:-22px;margin-bottom:8px;position:absolute;left:32%">
          </div>
		  <div id="weather-container" class="weatherContainer" >
          </div>		   
          <div  class="thirdTop" style="padding-top: 20px;">
            <strong>
            </strong>
            <span id="nothing">
            </span>
            <br/>
            <strong  title="Scheduled Time of Arrival">STA:&nbsp;
            </strong>
            <span id="sta">
            </span>
          </div>
        </div>
        <div class="mainDivBar">
          <div class="start redB" style="z-index:0" onclick="getDelayDetails('','','sourcedot')" id="start">
          </div>
          <div class="mainDivBarInside greyB" id="innerDivBar">
          </div>
          <div  class="end redB" style="z-index:0" aria-label="end" id="end">
          </div>
        </div>
        <div class="mainDivBarBottom">
          <div class="">
            <strong  title="Scheduled Time of Departure">STD:
            </strong>
            <span id="std">
            </span>
            <br/>
            <strong  title="Actual Time of Departure">ATD:
            </strong>
            <span id="atd">
            </span>
          </div>
          <div style="border: 1px solid #777777;border-radius:4px;padding:8px;margin-left:16px;color:white;font-weight:bold;" id="loadingDuration" title="Departure Delay">Loading Duration
          </div>
          <div  class="thirdTop">
            <strong id="etaLabel" >
            </strong>&nbsp;
            <span id="eta">
            </span>
          </div>
        </div>
      </div>
      <div class="detailsBoard float" style="margin-bottom:16px;display:none;width:550px;z-index:10">
        <!--  <div class="tip"></div>-->
        <div class="row" style="z-index:3;font-size:12px;" >
          <div class="col-lg-6" style="border-right:1px solid">
            <div class="row" >
              <div class="col-lg-4">
                <strong>Start Date
                </strong>
              </div>
              <div class="col-lg-8" id="startd">
              </div>
            </div>
            <hr>
            <div class="row" >
              <div class="col-lg-4">
                <strong>Distance
                </strong>
              </div>
              <div class="col-lg-8" id="distance">
              </div>
            </div>
            <hr>
            <div class="row" >
              <div class="col-lg-4">
                <strong>Status
                </strong>
              </div>
              <div class="col-lg-8" id="statusd">
              </div>
            </div>
          </div>
          <div class="col-lg-6">
            <div class="row" >
              <div class="col-lg-4">
                <strong>End Date
                </strong>
              </div>
              <div class="col-lg-8" id="endd">
              </div>
            </div>
            <hr>
            <div class="row" >
              <div class="col-lg-5">
                <strong>Duration(HH:mm)
                </strong>
              </div>
              <div class="col-lg-7" id="duration">
              </div>
            </div>
          </div>
        </div>
      </div>
      <div class="detailsBoard floatDot" style="margin-bottom:16px;display:none;width:450px;">
        <!--<div class="tip"></div>-->
        <div class="row" style="z-index:3;font-size:12px;" >
          <div class="col-lg-6" style="border-right:1px solid">
            <div class="row" >
              <div class="col-lg-4">
                <strong  title="Scheduled Time of Arrival">STA
                </strong>
              </div>
              <div class="col-lg-8" id="staDot">
              </div>
            </div>
            <hr>
            <div class="row" >
              <div class="col-lg-4">
                <strong  title="Actual Time of Arrival">ATA
                </strong>
              </div>
              <div class="col-lg-8" id="ataDot">
              </div>
            </div>
            <hr>
            <div class="row" >
              <div class="col-lg-4">
                <strong  title="Estimated Time of Arrival">ETA
                </strong>
              </div>
              <div class="col-lg-8" id="etaDot">
              </div>
            </div>
          </div>
          <div class="col-lg-6">
            <div class="row" >
              <div class="col-lg-4">
                <strong  title="Scheduled Time of Departure">STD
                </strong>
              </div>
              <div class="col-lg-8" id="stdDot">
              </div>
            </div>
            <hr>
            <div class="row" >
              <div class="col-lg-4">
                <strong  title="Actual Time of Departure">ATD
                </strong>
              </div>
              <div class="col-lg-8" id="atdDot">
              </div>
            </div>
            <hr>
            <div class="row" >
              <div class="col-lg-4">
                <strong>Hub
                </strong>
              </div>
              <div class="col-lg-8" id="nameDot">
              </div>
            </div>
            <hr>
          </div>
        </div>
      </div>
      <div class="detailsBoard floatDotTruck" style="margin-bottom:16px;display:none;width:300px;">
        <div class="row" style="z-index:3;font-size:12px;" >
          <div class="col-lg-12">
            <div class="row" >
              <div class="col-lg-6">
                <strong>Vehicle Model
                </strong>
              </div>
              <div class="col-lg-6" id="vModel">
              </div>
            </div>
            <hr>
            <div class="row" >
              <div class="col-lg-6">
                <strong>Vehicle Type
                </strong>
              </div>
              <div class="col-lg-6" id="vType">
              </div>
            </div>
            <hr>
            <div class="row" >
              <div class="col-lg-6">
                <strong id="statusTipTop">Speed
                </strong>
              </div>
              <div class="col-lg-6" id="speed">
              </div>
            </div>
            <hr>
            <div class="row" >
              <div class="col-lg-6">
                <strong>Status
                </strong>
              </div>
              <div class="col-lg-6" id="statusTip">
              </div>
            </div>
            <hr>
          </div>
        </div>
      </div>
      <input type="checkbox" checked="true" id="showAll"/> Show All Delays
      <table id="ceTable" class="table table-striped table-bordered dt-responsive nowrap" style="width:100%">
        <thead>
          <tr>
            <th>Delay Type
            </th>
            <th>Delay Start
            </th>
            <th>Delay End
            </th>
            <th>Delay Time (HH:mm)
            </th>
            <th>Location
            </th>
            <th>Possible Reason
            </th>
            <th>Remarks and Acknowledgement
            </th>
          </tr>
        </thead>
      </table>
    </div>
    <script>
      history.pushState({ foo: 'fake' }, 'Fake Url', 'CEDashboard.jsp');
      let t4uspringappURL = '<%=t4uspringappURL%>';
      let totalDistance = 0;
	  let totalDistanceForDot = 0;
      let actualTotalDistance = 0;
      let actualRemainingDistance = 0;
      let distanceCovered = 0;
      let divNum = 0;
      let status = "";
      var startDate = '';
      var endDate = '';
      var startDateForBar ='';
      var endDateForBar='';
      let ceTable;
      let tripIdFromSLA = <%=tripIdFromSLA%>;
      let globalVehicleNo = "";
      let comboLoadedGlobal;
      let ataDest = '';
      let vModel = "";
      let vType = "";
      let dur = "";
      let truckImage = "";
      let referStatus="";
      let showTruck = "";
      function getDetails(comboLoaded) {
        comboLoadedGlobal = comboLoaded;
        if(tripIdFromSLA != null && comboLoaded === true){
          tripIdFromSLA = null;
        }

        var speed = 0;
        var category = "";
		ceTable.search("").draw();
		$('#ceTable').DataTable().clear();
        $("#loading-div").show();
        let tripId = tripIdFromSLA != null ? tripIdFromSLA : document.getElementById("tripNoSelect").value;
		
		
        $.ajax({
          url: t4uspringappURL + 'getTripDetails',
          datatype: 'json',
          contentType: "application/json",
          data: {
            tripId: tripId
          },
          success: function(result) {
            //console.log("Trip Detail", result.responseBody);
            result = result.responseBody;

            let plannedSpeed = result.plannedSpeed;
            let actualSpeed = result.actualSpeed != null ? result.actualSpeed: 0;
            let percentage = 100 - (100 * parseInt(actualSpeed) / parseInt(plannedSpeed));
			let hoverText = parseInt(actualSpeed) > parseInt(plannedSpeed) ? "faster":"slower";
			
			$.ajax({
				  url: t4uspringappURL + 'getWeatherData',
				  datatype: 'json',
				  contentType: "application/json",
				  data: {
					tripId: tripIdFromSLA != null ? tripIdFromSLA : document.getElementById("tripNoSelect").value
				  },
				  success: function (data) {
				  let fallback = '<i class="fas fa-spinner fa-spin spinnerColor"></i>';
				     $("#weather-container").html(fallback);
					 if(result.ata != "" || result.distanceCovered==0) {
						 $("#weather-container").html('');
					 } else {
						if(typeof data.responseBody.iconLink !== 'undefined' && data.responseBody.iconLink !='') {
							$("#weather-container").html("<div class='flex' style='flex-direction:row;'><div class='imgDiv'><img style='height:100%;' src='"+data.responseBody.iconLink+"' /></div><div class='flex' style='flex-direction:column;padding-left:16px;line-height:21px;margin-top: -9px;'><div class='toolTipDiv' style='font-size:16px;font-weight:700;'>"+data.responseBody.temperature+" &#8451<span id='durationDiv'></span></div><div class='toolTipDiv'>"+data.responseBody.visibility+"</div><div class='toolTipDiv'>"+data.responseBody.description.toUpperCase()+"</div><div class='flex' style='flex-direction:column;padding-left:16px;line-height:21px;'><div id='addressDiv'></div></div></div>")
						    geocodeLatLng(data.responseBody.latitude , data.responseBody.longitude);
							getDurationFromRoute(data.responseBody.latitude , data.responseBody.longitude,data.responseBody.currentLatitude , data.responseBody.currentLongitude);
						} else {
							$("#weather-container").html('');
						}
					 }
				  }
			});
            $("#chart-container").insertFusionCharts({
              type: "angulargauge",
              width: "100%",
              height: "100%",
              dataFormat: "json",
              dataSource: {
                chart: {
                  caption: "Planned: " + plannedSpeed + " kmph",
				  captionFontSize: "14",
				  captionFontBold : "0",
				  captionFontColor : "#000000",
                  subcaption: "",
				  "captionPadding": "0",
				  "chartLeftMargin": "0",
				  "chartTopMargin": "0",
				  "chartRightMargin": "0",
				  "chartBottomMargin": "0",
				  "canvasPadding": "0",
                  lowerlimit: "0",
                  upperlimit: "100",
                  showvalue: "1",
                  numbersuffix: " kmph ("+percentage.toFixed(2).replace("-","")+"% "+hoverText+")",
				  numberprefix: "Actual: ",
                  "showTickMarks": "0",
                  "showTickValues": "0",
                  theme: "fusion",
                  bgColor: '#f2f2f2'
                }
                ,
                colorrange: {
                color: [{
                    minvalue: "0",
                    maxvalue: plannedSpeed,
                    code: "#d40511"
                  },{
						minvalue: plannedSpeed,
						maxvalue: "100",
						code: "#28A745"
					}
				]},
                dials: {
                  dial: [
                    {
                      value: actualSpeed,
                      tooltext: percentage.toFixed(2).replace("-","")+"% "+hoverText
                    }
                  ]
                },
                trendpoints: {
                  point: [
                    {
                      startvalue: ""  ,
                      displayvalue: "",
                      thickness: "2",
                      color: "#28A745",
                      usemarker: "1",
                      markerbordercolor: "#28A745",
                      markertooltext: "100%"
                    }
                  ]
                }
              }
            }
			);
            $("#innerDivBar").html("");

			$("#chDetention").html(result.chDetention);
			$("#shDetention").html(result.shDetention);
            truckImage = result.productLine === "TCL" ? "TCL.png": "RegTruck.png";
            truckImage = (result.productLine === "TCL" && result.temperatureOutOfRange) ? "TCLBlink.png": truckImage;
            vModel = result.vehicleModel;
            vType = result.vehicleType;
            dur = result.liveDuration;
            $("#plannedTat").html(result.plannedTransitTime);
            $("#elapsedTT").html(result.elapsedTransitTime);
            $("#setTemp").html(result.temperatureSet === "NA"? result.temperatureSet: result.temperatureSet + " &#8451");
			$("#setTemp").addClass("green");
            $("#tripClose").html("");
			if(result.tripClosedTime != null && result.tripClosedTime !=''){
			    let tripClosedTime = result.tripClosedTime.split(" ");
			    let tripClosedTimeParts = tripClosedTime[0].split("-");
			    const getISTTime = () => {
			      let d = new Date(tripClosedTimeParts[1] + "/" + tripClosedTimeParts[0] + "/" + tripClosedTimeParts[2] + " " + tripClosedTime[1])
			      d =  new Date(d.getTime() + ( 5.5 * 60 * 60 * 1000 ));
			      let dTime = d.toString().split(" ")[4];
			      let dd = d.getDate();
			      let mm = d.getMonth() + 1;
			      if (dd < 10) {
			        dd = '0' + dd;
			      }
			      if (mm < 10) {
			        mm = '0' + mm;
			      }
			      return dd + '-' + mm + '-' + d.getFullYear() + " " + dTime;
			    }
			    $("#tripClose").html(getISTTime);
			 }
            $("#tempCurr").html(result.temparatureAtContainer === "NA" ? result.temparatureAtContainer : result.temparatureAtContainer+" &#8451");
			if(result.actionRequired.includes("out of range")){
			$("#tempCurr").addClass("red");$("#tempCurr").removeClass("green")}
			else{$("#tempCurr").removeClass("red");$("#tempCurr").addClass("green")};

            if(result.temperatureSet === "NA"){$("#tempCurr").removeClass("red");$("#tempCurr").removeClass("green");$("#setTemp").removeClass("green");}

			var delayArr = result.delayedBy.split(" ")
            var delayMin = parseInt(delayArr[0].replace("h","")) + parseInt(delayArr[1].replace("m",""));
            if(result.actionRequired === "" || result.tripCreationStatus !== "OPEN"){
              $("#actionReqText").html("NO ACTION REQUIRED");
              $("#actionRequiredBoxId").addClass("greenB");
              $("#actionRequiredBoxId").removeClass("redB");
            }else{
              $("#actionRequiredBoxId").addClass("redB");
              $("#actionRequiredBoxId").removeClass("greenB");
              $("#actionReqText").html("Action Required :- "+result.actionRequired);
            }
            $("#tripNo").html(result.tripNo);
			$("#tripCreationStatus").html(result.tripCreationStatus+"-"+result.status);
             $("#delayedBy").show();
              $("#by").show();
			if(delayMin > 0){
              $("#statusMainBack").removeClass("greenB");
              $("#statusMainBack").addClass("redB");

              $("#delayedBy").html(result.delayedBy.replace(":","h ") +"")
              $("#statusMain").html("DELAYED")
			  $("#lateEarly").html("Late");
            }else {
              $("#statusMainBack").removeClass("redB");
              $("#statusMainBack").addClass("greenB");
			  $("#lateEarly").html("Early");

              $("#statusMain").html("ON TIME")
            }
			let timeofArrival = (result.ata == null  || result.ata == "") ? getDateObject(result.eta) : getDateObjectATA(result.ata);
            status = result.status;
            if(result.tripCreationStatus === "OPEN") {
              $("#driverName").html(result.driverName);
              $("#driverContact").html(result.driverContact);
            } else {
              $("#driverName").html("NA");
              $("#driverContact").html("NA");
            }
            globalVehicleNo = result.vehicleNo;
            $("#vehicleNo").html(result.vehicleNo);
            $("#source").html(result.source);
			$("#plannedLoadingDetention").html("(" +result.plannedLoadingDetention + ")");
            $("#destination").html(result.destination);
			$("#plannedUnloadingDetention").html("(" + result.plannedUnloadingDetentionTime + ")");
			$("#customerName").html(result.customerName.substr(0,25).toUpperCase() + "...");
			$("#customerName").attr( "title",result.customerName.toUpperCase());
            if(result.ata != ""){
              $("#etaLabel").text("ATA: ");
              $("#distnaceToNextTouchPoint").html(result.nextPointDistance.toFixed(2) + ' km');
              $("#ataDependent").html("Actual");
              var dt = new Date(result.ata);
              dt.setMinutes(dt.getMinutes()+330);
			  $("#eta").html([(dt.getDate() < 10 ? '0' + dt.getDate() : '' + dt.getDate()),(dt.getMonth()+1) < 10 ? '0' + (dt.getMonth()+1) : '' + (dt.getMonth()+1), dt.getFullYear()].join('-')+' '+ [(dt.getHours()) < 10 ? '0' + (dt.getHours()) : '' + (dt.getHours()), (dt.getMinutes()) < 10 ? '0' + (dt.getMinutes()) : '' + (dt.getMinutes()), (dt.getSeconds()) < 10 ? '0' + (dt.getSeconds()) : '' + (dt.getSeconds())].join(':'));
            }
            else{
              $("#distnaceToNextTouchPoint").html(result.nextPointDistance.toFixed(2) + ' km ('+result.nextPoint+')');
              $("#etaLabel").text("ETA: ");
              $("#ataDependent").html("Elapsed");
			  $("#eta").html(result.eta);
            }

            $("#tripCreated").html(result.tripCreationDate);
            $("#tripLastUpdated").html(result.tripUpdatedDate);
            actualRemainingDistance = result.remainingDistance;
            totalDistance = result.distanceCovered + actualRemainingDistance;
            actualTotalDistance = totalDistance;
			totalDistanceForDot = result.totalDistance;
            distanceCovered = result.distanceCovered;
            $("#totalDistnaceId").html(result.totalDistance.toFixed(2) + ' km');
            if(result.totalDistance > (result.distanceCovered + result.remainingDistance)){
              $("#extraPlanned").show();
              $("#extraPlannedDistance").html((result.totalDistance - (result.distanceCovered + result.remainingDistance)).toFixed(2)+' km');
            }
            else{
              $("#extraPlanned").hide();
            }
            $("#distanceCovered").html(result.distanceCovered.toFixed(2) + ' km');
            if((result.distanceCovered + result.remainingDistance) > result.totalDistance){
              $("#extra").show();
              $("#extraDistance").html(((result.distanceCovered + result.remainingDistance) - result.totalDistance).toFixed(2)+' km');
            }
            else{
              $("#extra").hide();
            }
            $("#remainingDist").html(actualRemainingDistance.toFixed(2) + ' km');
            $("#lastCommTime").html(result.lastCommTime);
			let lasCom = gettimediff(getDateObject(result.lastCommTime),new Date() ).split("h");
			//console.log("lasCom", lasCom);
			if(parseInt(lasCom[0]) > 6)
			{
				$("#lastCommTime").addClass("red");}
			else{
				$("#lastCommTime").removeClass("red");
			}
            $("#currentLoc").html(result.currentLocation.substr(0,40).toUpperCase() + "...");
			$("#currentLoc").attr( "title",result.currentLocation.toUpperCase());

            
            speed = result.speed;
            category = result.category;
            var previousDistance = 0;
			let staEarly = "";
            $.each(result.tripSequenceDetails, function(i, item) {
              if (item.sequence === 0) {
                $('#start').attr('aria-label', 'sta:&#10;std:\u000Aatd:\u000Aata:');
                $("#stp").html(item.sta);

                $("#std").html(item.std);
                $("#atp").html(item.ata);
                $("#atd").html(item.atd);
                if(item.ata != ""){
                  let plDuration = gettimediff(getDateObject(item.sta) , getDateObject(item.ata));
                  if(plDuration.includes("-")){
                    $("#placementDuration").addClass("greenB")
                    $("#placementDuration").removeClass("redB");
					plDuration = gettimediff(getDateObject(item.ata),getDateObject(item.sta));
                  }
                  else {
                    $("#placementDuration").addClass("redB");
                    $("#placementDuration").removeClass("greenB")
                  }
                  $("#placementDuration").html(plDuration.replace("-","").replace("-",""));
                  $("#placementDuration").show();
                  showTruck = "";
                }
                else {
                  showTruck = "dispNone";
                  $("#placementDuration").hide()
                }
                if(item.atd != ""){
                  let loadDuration = gettimediff(getDateObject(item.std) , getDateObject(item.atd));
                  if(loadDuration.includes("-")){
                    $("#loadingDuration").addClass("greenB");
                    $("#loadingDuration").removeClass("redB");
					loadDuration = gettimediff(getDateObject(item.atd),getDateObject(item.std));
                  }
                  else {
                    $("#loadingDuration").addClass("redB");
                    $("#loadingDuration").removeClass("greenB");
                  }
                  $("#loadingDuration").html(loadDuration.replace("-","").replace("-",""));
                  $("#loadingDuration").show()
                }
                else {
                  $("#loadingDuration").hide()
                }
                startDateForBar = item.atd;
              }

              if (item.sequence === 100) {
                $('#end').attr('aria-label', 'main navigation');
				staEarly = result.destArrOnAtd;
                (result.destArrOnAtd != null || result.destArrOnAtd != "") ? $("#sta").html(result.destArrOnAtd): "NA";
                ataDest = item.ata;
              }

              if (item.sequence > 0 && item.sequence < 100) {
                let dist = previousDistance + item.distance;
                let distPercent = 0;
                if(dist > totalDistance)
                {
                  distPercent = 100 * dist / actualTotalDistance;
                }
                else{
                  distPercent = 100 * dist / totalDistanceForDot;
                }
                $("#innerDivBar").append("<div id='inside" + divNum + "' class='barDot start blueB' data-ata='" + item.ata + "' data-atd='" + item.atd + "' data-sta='" + item.sta + "' data-std='" + item.std + "' data-name='" + item.name + "' data-eta='" + item.eta + "' style='left:" + distPercent + "%'></div>")
                divNum++;
                previousDistance = dist;

              }
            }
                  );

		if(delayMin <= 0){
			var dt1 = new Date(timeofArrival);
            dt1.setMinutes(dt1.getMinutes()+330);
			
			let earlyByTime = gettimediff(dt1,getDateObject(staEarly));
			$("#delayedBy").html(earlyByTime);
		}


            let prevDistance = 0;
            let prevDistanceRight = actualRemainingDistance;
            let lastPoint = 0;
            var status = '';
            var point = '';
            let tripId = tripIdFromSLA != null ? tripIdFromSLA : document.getElementById("tripNoSelect").value;
            $.ajax({
              url: t4uspringappURL + 'getTripStatusDetails',
              datatype: 'json',
              contentType: "application/json",
              data: {
                tripId: tripId
              },
              success: function(result) {
                let distArr = result.responseBody.reverse();
                let count = 0;
                $.each(result.responseBody, function(i, item) {
                  if (item.point == 'intransit' && (item.status === "DELAYED" || item.status === "ON TIME")) {
                    let dist = item.distance;
                    let distPercent = 100 * dist / totalDistance;
                    let classB = item.status === "DELAYED" ? "redB" : "greenB";
                    let prevDistPercent = 100 * prevDistance / totalDistance;
                    lastPoint = lastPoint + distPercent;
                    if (lastPoint > 100 && ataDest != '') {
                      distPercent = 99 - (lastPoint - distPercent);
                      lastPoint = 98;
                    }
                    else if (lastPoint > 100 && ataDest == '') {
                      distPercent = 95 - (lastPoint - distPercent);
                      lastPoint = 95;
                    }
                    let widthValue = ataDest !== '' ? 99 - (lastPoint - distPercent): parseFloat(distPercent).toFixed(2);
                    prevDistance = prevDistance + item.distance;
                    status = item.status;
                    point = item.point;
                    if(count === 0){
                      if (point == 'intransit' && (status === "DELAYED" || status === "ON TIME")) {
                        startDate = item.startDate;
                        endDate = item.endDate;

			        	getDelayDetails(startDateForBar, ataDest, 'alldelay');
                      }
                    }
                    ++count;
                  }
                  else {
                  }
                }
                      );
                if(count == 0){
                  if ($.fn.DataTable.isDataTable("#ceTable")) {
                    $('#ceTable').DataTable().clear();
                  }
                }
                let truckColor =  "yellow";
                let leftPercent = ataDest !== '' ? "98" : parseFloat(lastPoint).toFixed(2);
                let classBFinal = "";
								if($("#trImage")){$("#trImage").removeClass("object");}
							  $("#innerDivBar").append("<div id='inside" + divNum + "' class='barDotTruck' data-duration='"+dur+" HH:mm' data-vehicleModel='"+vModel+"' data-vehicleType='"+vType+"' data-speed='" + speed+ 'km/hr'+ "' data-status='" + category + "'  style='z-index:10;right:" + (100 * actualRemainingDistance / actualTotalDistance) + "%'><img id='trImage' class='"+referStatus+"  move-right "+showTruck+"' src='"+truckImage+"' style='margin-top:-56px;' /></div>")
                              
							 
							 
								var marginLeftWidth =($(window).width()  -96) * (totalDistanceForDot - actualRemainingDistance) / totalDistanceForDot; // this will return the left and top
								$("#trImage").css('margin-left', '-' + marginLeftWidth + 'px')
                setTimeout(function(){$("#trImage").addClass("object");$("#trImage").css('margin-left', '-35px');},1000);
								divNum++;
                let prevDistPercent = 0;
                let segmentDistanceSum = 0;
                let previousStatus = "ON TIME";
                //console.log("distance Array : ", distArr);
                $.each(distArr, function(i, item) {
                  if (item.point == 'intransit' && (item.status === "DELAYED" || item.status === "ON TIME")) {
                    let dist = item.distance;
                    let distPercent = 100 * dist / actualTotalDistance;
                    let classB = classBFinal = item.status === "DELAYED" ? "redB" : "greenB";
                    prevDistPercent = 100 * prevDistanceRight / actualTotalDistance;
                    prevDistPercent = prevDistPercent > 100 ? 99:prevDistPercent;
                    let widthValue = parseFloat(distPercent).toFixed(2);
                    prevDistanceRight = prevDistanceRight + item.distance;
                    widthValue = widthValue > 100 ? 99:widthValue;
                    endDateForBar = item.startDate;
                    segmentDistanceSum += item.distance;
                    previousStatus = item.status;
                    $("#innerDivBar").append("<div id='inside" + divNum + "' class='bar " + classB + "' data-startd='" + item.startDate + "' data-endd='" + item.endDate + "' data-distance='" + dist.toFixed(2)+' km' + "' data-duration='" + item.duration + "' data-status='" + item.status + "' style='right:" + prevDistPercent + "%;width:" + widthValue + "%;transition: width 5s linear;'></div>")
                    divNum++;
                  }
                }
                      );
                let finalColor = classBFinal === "greenB" ? "#D40511" : "#7DCB51" ;
                $(".barDotTruck").append("<div class='arrowStyle "+showTruck+"' style='border-left:12px solid #FFCC00'></div><div id='weatherInfo'></div>");
				
                let finalDistance = (distanceCovered - segmentDistanceSum) > 0 ? (distanceCovered - segmentDistanceSum).toFixed(2) : 0.00;
                let finalWidthValue = 100 * (finalDistance / actualTotalDistance);
                if(classBFinal === "redB"){
                  classBFinal = "greenB";
                  previousStatus = "ON TIME";
                }
                else if(classBFinal === "greenB"){
                  classBFinal = "redB";
                  previousStatus = "DELAYED";
                }
                if(finalWidthValue > 0){
                  let finalDuration = "00:00"
                  if(startDateForBar != null && startDateForBar !== "" && endDateForBar != null && endDateForBar !== "" &&
                     getDateObject(startDateForBar) <= getDateObject(endDateForBar)){
                    finalDuration = gettimediff(getDateObject(startDateForBar) , getDateObject(endDateForBar));
                  }
                  prevDistPercent = (100 - prevDistPercent) - prevDistPercent;
                  $("#innerDivBar").append("<div id='inside" + divNum + "' class='bar " + classBFinal + "' data-startd='" + startDateForBar + "' data-endd='" + endDateForBar + "' data-distance='" + finalDistance+' km' + "' data-duration='" + finalDuration + "' data-status='" + previousStatus+ "' style='right:" + prevDistPercent + "%;width:" + finalWidthValue + "%;left:0px;transition: width 5s linear;'></div>")
                  divNum++;
                }
                $("#loading-div").hide();
                $("#loading").hide();
                $("#tripDetDiv").show();
              }
            }
                  );
          }
        }
              );
			  
        $(document).on("click", "div.bar", function() {
          $("#showAll"). prop("checked", false);
          getDelayDetails($(this).data('startd'), $(this).data('endd'), 'bar');
        }
                      )
        $(document).on("mouseover", "div.bar", function() {
          if($(this).data('startd') !== "")
          {
            $("#startd").html($(this).data('startd'));
            $("#endd").html($(this).data('endd'));
            $("#distance").html($(this).data('distance'));
            $("#duration").html($(this).data('duration'));
            $("#statusd").html($(this).data('status'));
            var offset_pop = $(this).offset();
            $(".float").css({
              'left': '30%',
              'top': offset_pop.top + 16,
              'position': 'absolute'
            }
                           );
            $(".float").show();
          }
        }
                      );
        $(document).on("mouseleave", "div.bar", function() {
          $(".float").hide();
        }
                      );
        $(document).on("click", "div.barDot", function() {
          //getDetails();
        }
                      )
        $(document).on("mouseover", "div.barDot", function() {
          $("#stdDot").html($(this).data('std'));
          $("#staDot").html($(this).data('sta'));
          $("#atdDot").html($(this).data('atd'));
          $("#ataDot").html($(this).data('ata'));
          $("#etaDot").html($(this).data('eta'));
          $("#nameDot").html($(this).data('name'));
          var offset_pop = $(this).offset();
          $(".floatDot").css({
            'left': '30%',
            'top': offset_pop.top + 16,
            'position': 'absolute'
          }
                            );
          $(".floatDot").show();
        }
                      );
        $(document).on("mouseleave", "div.barDot", function() {
          $(".floatDot").hide();
        }
                      );
        $(document).on("mouseover", "div.barDotTruck", function() {
          $("#lastDate").html($(this).data('lastDate'));
          $("#vModel").html($(this).data('vehiclemodel'));
          $("#vType").html($(this).data('vehicletype'));
          if($(this).data('status') === "RUNNING"){
            $("#speed").html($(this).data('speed'));
            $("#statusTip").html($(this).data('status'));
            $("#statusTipTop").html("Speed");
          }
          else{
            $("#speed").html($(this).data('duration'));
            $("#statusTip").html($(this).data('status'));
            $("#statusTipTop").html("Duration");
          }
          var offset_pop = $(this).offset();
          $(".floatDotTruck").css({
            'left': "40%",
            'top': offset_pop.top + 16,
            'position': 'absolute'
          }
                                 );
          $(".floatDotTruck").show();
        }
                      );
        $(document).on("mouseleave", "div.barDotTruck", function() {
          $(".floatDotTruck").hide();
        }
                      );
      }
      function getDelayDetails(startDate, endDate, type) {
        let rows = [];
        if((startDate == '') && type == 'bar'){
          $('#ceTable').DataTable().clear();
          ceTable.rows.add(rows).draw();
          $("#loading-div").hide();
        }
        else{
          $("#loading-div").show();
          let tripId = tripIdFromSLA != null ? tripIdFromSLA : document.getElementById("tripNoSelect").value;
          $.ajax({
            url: t4uspringappURL + 'getTripDelayDetails',
            datatype: 'json',
            contentType: "application/json",
            data: {
              tripId: tripId,
              startDate: startDate,
              endDate: endDate,
              type: type,
              vehicleNo : globalVehicleNo
            }
            ,
            success: function(result) {
              $.each(result.responseBody, function(i, item) {
                let delayEnd = "";
                let remarks = "";
                let delayStart = "";
                let delayTime = "";
                if(item.delayEnd != null){
                  if(!item.delayEnd.includes("01-01-1900")){
                    delayEnd = item.delayEnd;
                  }
                }
                if(item.delayStart != null){
                  if(!item.delayStart.includes("01-01-1900")){
                    delayStart = item.delayStart;
                  }
                }
                if(delayStart !== "" && delayEnd != ""){
                  delayTime = gettimediff(getDateObject(delayStart),getDateObject(delayEnd))
                }
                if(item.remarks != null && item.remarks !== "reoccuring of idle and stoppage"){
                  remarks = item.remarks;
                }
                if(item.delayType == 'Traffic / Weather'){
                	delayTime = convertMinutesToHHMM(item.delay);
                }
                let row = {
                  "0": item.delayType,
                  "1": delayStart,
                  "2": delayEnd,
                  "3": delayTime,
                  "4": item.location,
                  "5": item.possibleReason,
                  "6": remarks
                }
                rows.push(row);
              }
                    );
              $('#ceTable').DataTable().clear();
              ceTable.rows.add(rows).draw();
              $("#loading-div").hide();
            }
          }
                );
        }
      }
      $('input[type="checkbox"]').click(function() {
        if ($(this).prop("checked") == true) {
          getDelayDetails(startDateForBar, ataDest, 'alldelay');
        }
        else if ($(this).prop("checked") == false) {
          getDelayDetails(startDate, endDate, 'bar');
        }
      }
                                       );
      $(document).ready(function() {
        $("#startd").html();
        $("#endd").html();
        $("#distance").html();
        $("#duration").html();
        $("#statusd").html();
		
		
				
        ceTable = $('#ceTable').DataTable({
          scrollX: true,
          dom: 'Bfrtip',
          buttons: ['excel', 'pdf']
        }
                                         );
        $.ajax({
          url: t4uspringappURL + 'getTripNos',
          datatype: 'json',
          contentType: "application/json",
          data: {
            systemId: 268,
            custId: 5560
          }
          ,
          success: function(result) {
            $("#tripNoSelect").append("<option value='0'>Select a Trip</option>");
            $.each(result.responseBody, function(i, item) {
              $("#tripNoSelect").append("<option value='" + item.tripId + "'>" + item.tripNo + "</option>");
            }
                  );
            $("#tripNoSelect").select2();
          }
        }
              );
        if (tripIdFromSLA != null) {
          getDetails();
        }
      }
                       );
      function viewMap() {
      }
      function getDateObject(datestr) {
        var parts = datestr.split(' ');
        var dateparts = parts[0].split('-');
        var day = dateparts[0];
        var month = parseInt(dateparts[1]) - 1;
        var year = dateparts[2];
        var timeparts = parts[1].split(':')
        var hh = timeparts[0];
        var mm = timeparts[1];
        var ss = timeparts[2];
        var date = new Date(year, month, day, hh, mm, ss, 00);
        return date;
      }

	   function getDateObjectATA(datestr) {
        var parts = datestr.split(' ');
        var dateparts = parts[0].split('-');
        var day = dateparts[2];
        var month = parseInt(dateparts[1]) - 1;
        var year = dateparts[0];
        var timeparts = parts[1].split(':')
        var hh = timeparts[0];
        var mm = timeparts[1];
        var ss = timeparts[2];
        var date = new Date(year, month, day, hh, mm, ss, 00);
        return date;
      }

	  function formatATA(datestr){
		var parts = datestr.split(' ');
        var dateparts = parts[0].split('-');
        var day = dateparts[2];
        var month = parseInt(dateparts[1]);
        var year = dateparts[0];
        var timeparts = parts[1].split(':')
        var hh = timeparts[0];
        var mm = timeparts[1];
        var ss = timeparts[2].replace(".0","");

        return day + "-" + month + "-" + year + " " + hh + ":" + mm + ":" + ss;
	  }
      function gettimediff(t1, t2) {

        var diff = t2 - t1;
        var hours = Math.floor(diff / 3.6e6);
        var minutes = Math.floor((diff % 3.6e6) / 6e4);
        var seconds = Math.floor((diff % 6e4) / 1000);
				if(minutes == 60){
					minutes = 0;
					hours = hours + 1;
				}
				if(minutes == -60){
					minutes = 0;
					hours = hours - 1;
				}
        if (hours < 10 && hours >= 0) {
          hours = "0" + hours;
        }
				if (hours > -10 && hours < 0) {
					hours = "-0" + Math.abs(hours);
				}
        if (minutes < 10 && minutes >= 0) {
          minutes = "0" + minutes;
        }
				if (minutes > -10 && minutes < 0) {
          minutes = "-0" + Math.abs(minutes);
        }

        if (seconds < 10 && seconds >= 0) {
          seconds = "0" + seconds;
        }
        var duration = hours + "h " + minutes + "m";
        return duration;
      }
      function convertMinutesToHHMM(minutes) {
		  var hour = Math.floor(minutes / 60);
		  var min = minutes % 60;
		  hour = hour < 10 ? '0' + hour : hour;
		  min = min < 10 ? '0' + min : min;
		  var duration = hour + "h " + min + "m";
          return duration;
	}
function geocodeLatLng(lat, lon) {
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
		var address = cty+','+district+','+stat+','+cntry
		
		$("#addressDiv").html("<div class='toolTipDiv' style='font-size: 13px;display: flex;width: 330px;margin-left: -16px;'>"+address+"</div>");
		
	})
}

function getDurationFromRoute(lat,lon,currentlat,currentlon) {
waypoints = 'waypoint0='+currentlat +','+currentlon + '&waypoint1='+lat +','+lon;
var url = 'https://route.api.here.com/routing/7.2/calculateroute.json?' + waypoints + '&mode=fastest;car;traffic:disabled&routeattributes=shape&excludeCountries=BGD,PAK,NPL,BTN,CHN&app_id=' + '<%=appKey%>' + '&app_code=' + '<%=appCode%>';    
fetch(url).then(function (response) {      
	resp = response.json();      
	return resp;    
}).then(function (json) { 
	//console.log(Number(json.response.route[0].summary.baseTime)/60);
	let duration = convertMinutesToHHMM((Number(json.response.route[0].summary.baseTime)/60).toFixed(0));
	var divContent = ' (After '+duration+')';
	$("#durationDiv").html(divContent);
	
})
}
    </script>
    <jsp:include page="../Common/footer.jsp" />
