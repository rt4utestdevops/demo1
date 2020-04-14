<%@ page language="java" import="java.util.*,t4u.functions.*,t4u.beans.*,t4u.common.*" pageEncoding="ISO-8859-1"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
CommonFunctions cf = new CommonFunctions();
int systemid = loginInfo.getSystemId();
String latitudeLongitude = cf.getCoordinates(systemid);
MapAPIConfigBean bean = loginInfo.getMapAPIConfig();
String mapName = bean.getMapName();
String appKey = bean.getAPIKey();
String appCode = bean.getAppCode();
String sessionId = request.getSession().getId();
%>

<jsp:include page="../Common/header.jsp" />
<jsp:include page="../Common/InitializeLeaflet.jsp" />
    <!-- Bootstrap -->
    <link href="vendors/bootstrap/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.8.1/css/all.css" integrity="sha384-50oBUHEmvpQ+1lW4y57PTFmhCaXp0ML5d60M1M7uH2+nqUivzIebhndOJK28anvf" crossorigin="anonymous">

    <!-- Font Awesome -->
    <link href="vendors/font-awesome/css/font-awesome.min.css" rel="stylesheet">
    <!-- iCheck -->
    <link href="vendors/iCheck/skins/flat/green.css" rel="stylesheet">

    <!-- bootstrap-progressbar -->
    <link href="vendors/bootstrap-progressbar/css/bootstrap-progressbar-3.3.4.min.css" rel="stylesheet">
    <!-- bootstrap-daterangepicker -->
    <link href="vendors/bootstrap-daterangepicker/daterangepicker.css" rel="stylesheet">

    <!-- Custom Theme Style -->
    <link href="css/custom.min.css" rel="stylesheet">

    <link rel="stylesheet" href="https://www.jqwidgets.com/public/jqwidgets/styles/jqx.base.css">
    <link rel="stylesheet" href="https://www.jqwidgets.com/public/jqwidgets/styles/jqx.energyblue.css">
    <link rel="stylesheet" href="https://www.jqwidgets.com/public/jqwidgets/styles/jqx.arctic.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-multiselect/0.9.13/css/bootstrap-multiselect.css">
    <link rel="stylesheet" href="../../Main/sweetAlert/sweetalert.css">
    <head><meta http-equiv="refresh" content="600"></head>

    <style>
	.multiselect {
		padding:2px !important;
		height:24px !important;
		
		margin-top:16px;
	}
	
	.panelHeight {
            height: 184px !important;
        }

    .panelHeight184 {
            height: 184px !important;
        }

    .panelHeight160 {
            height: 160px !important;
        }

    .panelHeight120 {
            height: 120px !important;
        }

    .panelHeight110 {
            height: 110px !important;
        }

    .panelHeight96 {
            height: 96px !important;
        }

     p {
            margin: 0 0 2px;
        }

     table {
            margin-top: 16px;
        }

    .x_panel {
            padding: 4px 8px !important;
            border-radius: 8px;
        }

    .count {
            cursor: pointer;
        }

     p {
            cursor: pointer;
        }
        
     #opsheader{
       cursor: pointer;
     }
     

     .tile_count .tile_stats_count .count {
            font-size: 30px;
        }

     .tile_count .tile_stats_count {
            margin-bottom: 0px;
            border-bottom: 0;
            padding-bottom: 4px;
        }

     .x_title {
            padding: 0px 4px 0px;
        }

     .x_content {
            padding: 0 4px 0px;
            margin-top: 0px;
        }

      h2 {
            font-size: 16px;
        }

      h4 {
            font-size: 14px !important;
            margin-top: 8px !important;
            margin-bottom: 4px !important;
        }

      .tableTop {
            margin-top: 12px;
        }

      #datatable1,
      #datatable2,
      #datatable3,
      #datatable0 {
            height: 0;
            padding-left: 4px;
            overflow: hidden;
            -webkit-transition: all .8s ease;
            -moz-transition: all .8s ease;
            -ms-transition: all .8s ease;
            -o-transition: all .8s ease;
            transition: all .8s ease;
            
        }

       .close {
            color: red !important;
            padding: 0px 4px;
            font-size: 20px;
            cursor: pointer;
            opacity: 1;

        }

       .datatableHeader {
            width: 100%;
            height: 40px;
            text-align: left;
            font-size: 14px;
            padding: 2px 4px;
            border-radius: 8px;
            text-transform: uppercase;
            display: flex;
        }

       .dataTables_filter {
            margin-top: -32px;
        }

        /* width */
        ::-webkit-scrollbar {
            width: 8px;
            height:8px;

        }

        .jqx-widget-content {
            z-index: 20000 !important;
        }

        /* Track */
        ::-webkit-scrollbar-track {
            background: #f1f1f1;
            border-radius: 8px
        }

        /* Handle */
        ::-webkit-scrollbar-thumb {
            background: #888;
            border-radius: 8px
        }

        /* Handle on hover */
        ::-webkit-scrollbar-thumb:hover {
            background: #555;
        }

        #datatable0Header,
        #datatable1Header,
        #datatable2Header,
        #datatable3Header {
            background-color: #1ABB9C;
            color: white;
            margin-left: -4px;
            padding: 4px 8px 4px 8px;
          

        }

        .datatableHeader input {
            border-radius: 8px;
            height: 24px;
            font-size: 14px;
            float: right;
            margin-right: 8px;
            padding-left: 8px;
            
        }

        .datatableHeader button {
            border-radius: 8px;
            height: 24px;
            font-size: 14px;
            margin-right: 24px;
            float: right;

        }

        .dataTables_filter input {
            border-radius: 8px;
           
        }

        .flex {
            display: flex;
        }

        .textbox-n {
            margin-right: 16px;
           
        }

        #inputstartDate0,
        #inputendDate0,
        #inputstartDate1,
        #inputendDate1,
        #inputstartDate2,
        #inputendDate2,
        #inputstartDate3,
        #inputendDate3 {
            padding: 0px !important;
            
        }

        .center-view {
            margin-top: 22%;
            left: 50%;
            position: fixed;
            height: 200px;
            width: 200px;
            z-index: 10;

        }
		.nav-sm .container.body .right_col {
             padding: 4px 16px;
             margin-left: 0px !important;
             z-index: 2;
        }
       .main_container{
             margin-top:-42px !important;
             overflow:hidden;
        }

       .right_col{
            padding: 16px 8px  !important;
        }

       footer{
           margin-left:0px !important;
        }
   
      .form-control {
                    display: block;
                    width: 100%;
                    height: 24px;
                    padding: 6px 12px;
                    font-size: 14px;
                    line-height: 1.42857143;
                    color: #555;
                    background-color: #fff;
                    background-image: none;
                    border: 1px solid #aaa;
                    border-radius: 4px;
                    -webkit-box-shadow: inset 0 1px 1px rgba(0, 0, 0, .075);
                     box-shadow: inset 0 1px 1px rgba(0, 0, 0, .075);
                    -webkit-transition: border-color ease-in-out .15s, -webkit-box-shadow ease-in-out .15s;
                    -o-transition: border-color ease-in-out .15s, box-shadow ease-in-out .15s;
                    transition: border-color ease-in-out .15s, box-shadow ease-in-out .15s;
                  
                }
       .caret{
                display:none;
             }
       .multiselect{
                width: 222px !important; 
                   }
                
       #viewId{
		       height:24px !important;
		       width:70px;
		       padding-top: 3px;
		      }
		      
	   #dateInput1{
		       transform: translate(-10%, -10%);
		      }
	   #dateInput2{
		       transform: translate(-10%, -10%);
		      }
	      
	   #disclimer1,
	   #disclimer2,
	   #disclimer3
	    {
         display: none;
         margin-top: 123px;
               }
       
      
	

    </style>
    <div class="center-view" style="display:none;" id="loading-div">
        <img src="../../Main/images/loading.gif" alt="">
    </div>
    <div class="container body">
        <div class="main_container">


            <!-- page content -->
            <div class="right_col" id="topCount" role="main">
                <!-- top tiles -->
               




                <div class="row" style="margin-top:4px;">
                    
                    <div class="col-md-9 col-sm-12 col-xs-12">
                    <div class="row tile_count" style="margin-bottom:0px !important;">
                    <div class="col-md-2 col-sm-4 col-xs-6 tile_stats_count">
                        <span class="count_top"><i class="fa fa-trucks"></i> Total Vehicles</span>
                        <div class="count" onclick="OpenDataTable('0','Total Vehicles','totalVehicles')" id='totalVehicles'><i class="fas fa-spinner fa-spin" style="color:#dfdfdf;"></i></div>
                    </div>
                    <div class="col-md-2 col-sm-4 col-xs-6 tile_stats_count">
                        <span class="count_top">On Trip</span>
                        <div class="count green" onclick="OpenDataTable('0','On Trip','onTripVehicles')" id='onTripVehicles'><i class="fas fa-spinner fa-spin" style="color:#dfdfdf;"></i></div>
                       <!--   <span class="count_bottom"><i class="green"><i class="fa fa-sort-asc"></i>5% </i> From last Week</span> -->
                    </div>
                    <div class="col-md-2 col-sm-4 col-xs-6 tile_stats_count">
                        <span class="count_top">At Hub Locations</span>
                        <div class="count" onclick="OpenDataTable('0','At Hub Locations','vehiclesAtHubLocations')" id='vehiclesAtHubLocations'><i class="fas fa-spinner fa-spin" style="color:#dfdfdf;"></i></div>
                    </div>
                    <div class="col-md-2 col-sm-4 col-xs-6 tile_stats_count">
                        <span class="count_top">At Service Stations</span>
                        <div class="count" onclick="OpenDataTable('0','At Service Stations','vehiclesAtServiceStation')" id='vehiclesAtServiceStation'><i class="fas fa-spinner fa-spin" style="color:#dfdfdf;"></i></div>
                    </div>
                    <div class="col-md-2 col-sm-4 col-xs-6 tile_stats_count">
                        <span class="count_top">UnAuth Movement</span>
                        <div class="count" onclick="OpenDataTable('0','UnAuth Movement','onRoadVehicles')" id='onRoadVehicles'><i class="fas fa-spinner fa-spin" style="color:#dfdfdf;"></i></div>
                    </div>
                    <div class="col-md-2 col-sm-4 col-xs-6 tile_stats_count">
                        <span class="count_top">Total KMS today</span>
                        <div class="count" onclick="OpenDataTable('0','Total Kms Today','totalKmsToday')" id='totalKmsToday'><i class="fas fa-spinner fa-spin" style="color:#dfdfdf;"></i></div>
                        <!--<span class="count_bottom"><i class="green"><i class="fa fa-sort-asc"></i>34% </i> From last Week</span> -->
                        </div>
                </div>
                <!-- /top tiles -->
				
				<div class="row" id="topRow" style="display:none;">
				    <div class="col-lg-1.5 col-md-1.5 col-sm-1.5 col-xs-1.5" style="margin-top:16px;margin-left: 8px;">
				    <label>&nbsp;&nbsp;Group Name:</label>
				    </div>&nbsp;&nbsp;
					<div class="col-lg-3 col-md-3 col-sm-3 col-xs-3">
					<select class="form-control" id="group_names" multiple >
					 </select>
					</div>&nbsp;&nbsp;
					<div class="col-lg-3 col-md-3 col-sm-3 col-xs-3">
						<input type='text'  id="dateInput1" style="width:90% ;margin-left:20px;margin-top:16px;"/>
					</div>&nbsp;&nbsp;
					<div class="col-lg-3 col-md-3 col-sm-3 col-xs-3" >
						<input type='text'  id="dateInput2" style="width:90% !important;margin-left:20px;margin-top:16px" />
					</div>&nbsp;&nbsp;
					<div class="col-lg-1 col-md-1 col-sm-1 col-xs-1" >
					<button id="viewId" class="btn btn-primary" onclick="getData()" style="margin-left:0px;margin-top:16px;" >GO</button> 
					</div>&nbsp;&nbsp;
					<div class="col-lg-0.5 col-md-0.5 col-sm-0.5 col-xs-0.5" >
					<button type="button" onclick="reloadPage();" data-toggle="tooltip" title= "Refresh" style = "margin-top: 16px;"><span class="glyphicon glyphicon-refresh"></span></button>
					</div>
				</div>
                
                    
                <div id="datatable0" style="margin-top:8px;">
                    <div class="datatableHeader">
                        <div style="width:30%"><span id="datatable0Header">Count</span></div>
                        <div class="flex" style="justify-content:flex-end;width:70%">
                            <input placeholder="End Date" class="textbox-n" type="text" id="startDate0">
                            <input placeholder="Start Date" class="textbox-n" type="text" id="endDate0">
                            <button id="button0" class="btn-primary" style="margin-right:64px;" onclick="OpenDataTable('0', '','')">GO</button>
                            <i onclick="closetable('0')" class="fa fa-close close"></i>
                        </div>
                    </div>
                     <table id="myTable0" class="display" cellspacing="0" width="100%">                
                 </table>
                </div>
                    
                    
                        <div class="row" id="row1" style="margin-top:8px;">


                          <!--   <div class="col-md-4 col-sm-4 col-xs-12">
                                <div class="x_panel tile fixed_height_220 panelHeight">
                                    <div class="x_title">
                                     <!--   <h2><i class="fa fa-road" style="font-size:20px;color:#009688;"></i>&nbsp;&nbsp;TRIP STATUS OVERVIEW</h2>    
                                         <h2><i class="fa fa-line-chart" style="font-size:20px;color:#009688;"></i>&nbsp;&nbsp;PERFORMANCE OPS</h2>
                                         
                                        <div class="clearfix"></div>
                                    </div>
                                    <div class="x_content row" style="margin-left:0px;">
                                        <div class="col-md-6 x_panel panelHeight120" style="text-align:center;width:50%;padding:0px;">
                                            <h4>SOURCE</h4>
                                            <table class="tableTop" style="width:100%">
                                                <tr>
                                                    <th>
                                                        <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6" style="padding:0px;">
                                                            <p style="text-align:center;">On Time<br /> Start </p>
                                                        </div>  
                                                        <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12" style="padding-left: 1px;">
                                                            <p style="text-align:center;">Delayed<br /> Start </p>
                                                        </div>
                                                    </th>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <table class="tile_info">
                                                            <tr>
                                                                <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6">
                                                                    <p class="" style="color:green;font-size:18px;" onclick="OpenDataTable('1','Source - On Time Start','sourceOnTimeStart')" id="sourceOnTimeStart"><i class="fas fa-spinner fa-spin" style="color:#dfdfdf;"></i></p>
                                                                </div>  
                                                                <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12">
                                                                    <p class="" style="color:green;font-size:18px;" onclick="OpenDataTable('1','Source - Delayed Start','sourceDelayedStart')" id="sourceDelayedStart"><i class="fas fa-spinner fa-spin" style="color:#dfdfdf;"></i></p>

                                                                </div>
                                                            </tr>

                                                        </table>
                                                    </td>
                                                </tr>
                                            </table>
                                        </div>


                                        <div class="col-md-6 x_panel panelHeight120" style="text-align:center;width:50%;padding:0px">
                                            <h4>DESTINATION</h4>
                                            <table class="tableTop" style="width:100%">
                                                <tr>
                                                    <th>
                                                          <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6" style="padding:0px">
                                                            <p style="text-align:center;">On Time<br /> Reach</p>
                                                        </div>  
                                                        <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12" style="padding-left: 1px;";>
                                                            <p style="text-align:center;">Delayed <br />Reach</p>
                                                        </div>
                                                    </th>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <table class="tile_info">
                                                            <tr>
                                                               <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6">
                                                                   <p class="" style="color:green;font-size:18px;" onclick="OpenDataTable('1','Destination - On Time Reach','destinationOnTimeReach')" id="destinationOnTimeReach"><i class="fas fa-spinner fa-spin" style="color:#dfdfdf;"></i></p>                                                                    
                                                                    
                                                                </div>  
                                                                <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12">
                                                                   <p class="" style="color:green;font-size:18px;" onclick="OpenDataTable('1','Destination - Delayed Reach','destinationDelayedReach')" id="destinationDelayedReach"><i class="fas fa-spinner fa-spin" style="color:#dfdfdf;"></i></p>
                                                                </div>
                                                            </tr>

                                                        </table>
                                                    </td>
                                                </tr>
                                            </table>
                                        </div>  

                                    </div>
                                </div>
                            </div> -->
                            
                           <div class="col-md-4 col-sm-4 col-xs-12">
                                <div class="x_panel tile fixed_height_220 panelHeight">
                                    <div class="x_title">
                                     <!--   <h2><i class="fa fa-road" style="font-size:20px;color:#009688;"></i>&nbsp;&nbsp;TRIP STATUS OVERVIEW</h2> -->   
                                         <h2 onclick="OpenDataTable('1','Delay-Start-Reach','delayStartOrReach')" id = "opsheader" data-toggle="tooltip" title="Click here to get combined report" style=color:#FF0000; ><i class="fa fa-line-chart" style="font-size:20px;color:#009688;" ></i>&nbsp;&nbsp;PERFORMANCE OPS</h2>
                                        <div class="clearfix"></div>
                                    </div>
                                    <div class="x_content row" style="margin-left:0px;">
                                        <div class="col-md-12 x_panel panelHeight120" style="text-align:center;width:50%;padding:0px;">
                                             
                                            <table class="tableTop" style="width:100%">
                                                <tr>
                                                    <th>
                                                         
                                                        <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6" style="padding-left: 1px;">
                                                            <p style="text-align:center;">Delayed<br /> Start </p>
                                                        </div>
                                                         <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6" style="padding-left: 1px;";>
                                                            <p style="text-align:center;">Delayed <br />Reach</p>
                                                        </div>
                                                    </th>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <table class="tile_info">
                                                            <tr>
                                                                
                                                                <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6">
                                                                    <p class="" style="color:green;font-size:18px;" onclick="OpenDataTable('1','Source - Delayed Start','sourceDelayedStart')" id="sourceDelayedStart"><i class="fas fa-spinner fa-spin" style="color:#dfdfdf;"></i></p>

                                                                </div>
                                                                
                                                                  <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6">
                                                                   <p class="" style="color:green;font-size:18px;" onclick="OpenDataTable('1','Destination - Delayed Reach','destinationDelayedReach')" id="destinationDelayedReach"><i class="fas fa-spinner fa-spin" style="color:#dfdfdf;"></i></p>
                                                                </div>
                                                            </tr>

                                                        </table>
                                                    </td>
                                                </tr>
                                            </table>
                                        </div>


                                       

                                    </div>
                                </div>
                            </div> 
                            
                            <div class="col-md-4 col-sm-4 col-xs-12">
                                <div class="x_panel tile fixed_height_220 panelHeight">
                                    <div class="x_title">
                                        <h2><i class="fas fa-route" style="font-size:20px;color:#009688;"></i>&nbsp;&nbsp;TRIP OPS (Vehicle Counts)</h2>
                                        <div class="clearfix"></div>
                                    </div>
                                    <div class="x_content row" style="margin-left:0px;">
                                        <div class="col-md-12 x_panel panelHeight120" id="opsTable">
                                            <table class="" style="width:100%;margin-top:8px;">
                                                <tr>
                                                    <th style="text-align:center;">
                                                        <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4" style="padding:0px;">
                                                            <p>Extra KMS</p>
                                                        </div>
                                                        <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4" style="padding:0px;">
                                                            <p data-toggle="tooltip" title="Vehicles when crossed state's border">Interstate</p>
                                                        </div>
                                                        <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4" style="padding:0px;">
                                                            <p>Near Fuel St.</p>
                                                        </div>
                                                    </th>
                                                </tr>
                                                <tr>
                                                    <td style="text-align:center;">
                                                        <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4" style="padding:0px;">
                                                            <p class="" style="color:green;font-size:18px;" onclick="OpenDataTable('1','Extra Kms','extraKMS')" id='extraKMS'><i class="fas fa-spinner fa-spin" style="color:#dfdfdf;"></i></p>
                                                        </div>
                                                        <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4" style="padding:0px;">
                                                            <p class="" style="color:green;font-size:18px;" onclick="OpenDataTable('1','Interstate','crossBorderCount')" id='crossBorderCount'><i class="fas fa-spinner fa-spin" style="color:#dfdfdf;"></i></p>
                                                        </div>
                                                        <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4" style="padding:0px;">
                                                            <p class="" style="color:green;font-size:18px;" onclick="OpenDataTable('1','Near Fuel St.','nearFuelStn')" id='nearFuelStationCount'><i class="fas fa-spinner fa-spin" style="color:#dfdfdf;"></i></p>
                                                        </div>

                                                    </td>
                                                </tr>
                                            </table>
                                            <table class="" style="width:100%;margin-top:8px;">
                                                <tr>
                                                    <th style="text-align:center;">
                                                        <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4" style="padding:0px;">
                                                            <p>Mileage</p>
                                                        </div>
                                                        <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4" style="padding:0px;">
                                                            <p>Refuel</p>
                                                        </div>
                                                        <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4" style="padding:0px;">
                                                            <p>Pilferage</p>
                                                        </div>
                                                    </th>
                                                </tr>
                                                <tr>
                                                    <td style="text-align:center;">
                                                        <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4" style="padding:0px;">
                                                            <p class="" style="color:green;font-size:18px;" onclick="OpenDataTable('1','Mileage','mileage')" id='mileage'><i class="fas fa-spinner fa-spin" style="color:#dfdfdf;"></i></p>
                                                        </div>
                                                        <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4" style="padding:0px;">
                                                            <p class="" style="color:green;font-size:18px;" onclick="OpenDataTable('1','Refuel','refuel')" id='refuel'><i class="fas fa-spinner fa-spin" style="color:#dfdfdf;"></i></p>
                                                        </div>
                                                        <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4" style="padding:0px;">
                                                            <p class="" style="color:green;font-size:18px;" onclick="OpenDataTable('1','Pilferage','pilferage')" id='pilferage'><i class="fas fa-spinner fa-spin" style="color:#dfdfdf;"></i></p>
                                                        </div>

                                                    </td>
                                                </tr>
                                            </table>
                                        </div>



                                    </div>
                                </div>
                            </div>

                            <div class="col-md-4 col-sm-4 col-xs-12">
                                <div class="x_panel tile fixed_height_220 panelHeight">
                                    <div class="x_title">
                                        <h2> <i class="fa fa-exclamation-circle" style="font-size:20px;color:#ef5350;"></i>&nbsp;&nbsp;TRIP ALERTS</h2>
                                        <div class="clearfix"></div>
                                    </div>
                                    <div class="x_content row" style="margin-left:0px;">
                                        <div class="col-md-12 x_panel panelHeight120">
                                            <table class="" style="width:100%;">
                                                <tr>
                                                    <th style="text-align:center;">
                                                        <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4" style="padding:0px;">
                                                            <p>Pickup<br /> Risk</p>
                                                        </div>
                                                        <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4" style="padding:0px;">
                                                            <p data-toggle="tooltip" title="Vehilces entered to Restrictive zones">Restrictive<br /> Zone</p>
                                                        </div>
                                                        <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4" style="padding:0px;">
                                                            <p>Low<br /> Fuel</p>
                                                        </div>
                                                    </th>
                                                </tr>
                                                <tr>
                                                    <td style="text-align:center;">
                                                        <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4" style="padding:0px;">
                                                            <p class="" style="color:green;font-size:18px;" onclick="OpenDataTable('1','Pickup Risk','pickupRisk')" id="pickupRisk"><i class="fas fa-spinner fa-spin" style="color:#dfdfdf;"></i></p>
                                                        </div>
                                                        <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4" style="padding:0px;">
                                                            <p class="" style="color:red;font-size:18px;font-weight:bold" onclick="OpenDataTable('1','Restrictive Zones','restrictiveZones')" id="restrictiveZones"><i class="fas fa-spinner fa-spin" style="color:#dfdfdf;"></i></p>
                                                        </div>
                                                        <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4" style="padding:0px;">
                                                            <p class="" style="color:green;font-size:18px;" onclick="OpenDataTable('1','Low Fuel','lowFuel')" id='lowFuelCount'><i class="fas fa-spinner fa-spin" style="color:#dfdfdf;"></i></p>
                                                        </div>

                                                    </td>
                                                </tr>
                                            </table>
                                        </div>



                                    </div>
                                </div>
                            </div>

                        </div>
                        <div id="datatable1" style="">
                            <div class="datatableHeader">
                                <div style="width:30%"><span id="datatable1Header">Count</span></div>
                                 
                                <div class="flex" style="justify-content:flex-end;width:70%; transform: translate(-10%, -10%);">
                                
                                  <button id="emailId1" type="button" class="btn btn-danger btn-sm" style="
                                  width: 50px; height: 28px;  margin-left: -86px; " onclick="loadDataThroughEmail('1')" >
	      		                    <span class="glyphicon glyphicon-envelope" title="Email"></span>  
	  		                        </button>
                                    <input placeholder="End Date" class="textbox-n" type="text" id="startDate1">
                                    <input placeholder="Start Date" class="textbox-n" type="text" id="endDate1">
                                    
                                    <button class="btn-primary" style="margin-right:64px;" onclick="OpenDataTable('1', '','')">GO</button>
                                    <i onclick="closetable('1')" class="fa fa-close close"></i>
                                </div>
                            </div>


                             <table id="myTable1" class="display" cellspacing="0" width="100%">
                             <span id="disclimer1" ><i class="fa fa-warning" style="font-size:24px;color:red"></i>&nbsp;Click on the Email button  to receive the data through Email</span>
                             </table>
                        </div>
                        <div class="row" id="row2">


                            <div class="col-md-4 col-sm-4 col-xs-12">
                                <div class="x_panel tile fixed_height_220 panelHeight160">
                                    <div class="x_title">
                                        <h2><i class="fas fa-car" style="font-size:20px;color:#009688;"></i>&nbsp;&nbsp;VEHICLE HEALTH</h2>
                                        <div class="clearfix"></div>
                                    </div>
                                    <div class="x_content row" style="margin-left:0px;">
                                        <div class="col-md-8 x_panel panelHeight96" style="width:50%;text-align:center;">
                                            <h4>ENGINE</h4>
                                            <table class="tableTop" style="width:100%">
                                                <tr>
                                                    <th style="text-align:center;">
                                                        <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4" style="padding:0px;">
                                                            <p data-toggle="tooltip" title="Calculated based on DTC error codes with 'P' prefix">Critical</p>
                                                        </div>
                                                        <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4" style="padding:0px;">
                                                            <p data-toggle="tooltip" title="Calulated on parameters such as Coolant temperature,Mainfold absolute pressure, Fuel rail pressure,MAF air flow rate, Engine RPM">High</p>
                                                        </div>
                                                        <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4" style="padding:0px;">
                                                            <p data-toggle="tooltip" title="Calulated on parameters such as Coolant temperature,Mainfold absolute pressure, Fuel rail pressure,MAF air flow rate,  Engine RPM">Low</p>
                                                        </div>
                                                    </th>
                                                </tr>
                                                <tr>
                                                    <td style="text-align:center;">
                                                        <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4" style="padding:0px;">
                                                            <p class="" style="color:red;font-size:18px;" onclick="OpenDataTable('2','Engine - Critical','engineCritical')" id='engineCritical'><i class="fas fa-spinner fa-spin" style="color:#dfdfdf;"></i></p>
                                                        </div>
                                                        <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4" style="padding:0px;">
                                                            <p class="" style="color:orange;font-size:18px;font-weight:bold" onclick="OpenDataTable('2','Engine - High','engineHigh')" id="engineHigh"><i class="fas fa-spinner fa-spin" style="color:#dfdfdf;"></i></p>
                                                        </div>
                                                        <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4" style="padding:0px;">
                                                            <p class="" style="color:green;font-size:18px;" onclick="OpenDataTable('2','Engine - Low','engineLow')" id="engineLow"><i class="fas fa-spinner fa-spin" style="color:#dfdfdf;"></i></p>
                                                        </div>

                                                    </td>
                                                </tr>
                                            </table>
                                        </div>
                                        <div class="col-md-4 x_panel panelHeight96" style="width:50%;text-align:center;">
                                            <h4>BATTERY</h4>
                                            <table class="tableTop" style="width:100% ;">
                                                <tr>
                                                    <th style="text-align:center;">
                                                        <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6" style="padding:0px;">
                                                            <p data-toggle="tooltip" title="When battery falls below 9 volts">Low</p>
                                                        </div>
                                                        <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6" style="padding:0px;">
                                                            <p data-toggle="tooltip" title="When battery goes beyond 15.5 volts">High</p>
                                                        </div>

                                                    </th>
                                                </tr>
                                                <tr>
                                                    <td style="text-align:center;">
                                                        <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6" style="padding:0px;">
                                                            <p class="" style="color:red;font-size:18px;" onclick="OpenDataTable('2','Battery - Low','batteryLow')" id="batteryLow"><i class="fas fa-spinner fa-spin" style="color:#dfdfdf;"></i></p>
                                                        </div>
                                                        <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6" style="padding:0px;">
                                                            <p class="" style="color:green;font-size:18px;font-weight:bold" onclick="OpenDataTable('2','Battery - High','batteryHigh')" id = "batteryHigh"><i class="fas fa-spinner fa-spin" style="color:#dfdfdf;"></i></p>
                                                        </div>


                                                    </td>
                                                </tr>
                                            </table>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div class="col-md-4 col-sm-4 col-xs-12">
                                <div class="x_panel tile fixed_height_220 panelHeight160">
                                    <div class="x_title">
                                        <h2><i class="fa fa-plus" style="font-size:20px;color:#009688;"></i>&nbsp;&nbsp;HEALTH OPS</h2>
                                        <div class="clearfix"></div>
                                    </div>
                                    <div class="x_content row" style="margin-left:0px;">
                                        <div class="col-md-12 x_panel panelHeight96">
                                            <table class="" style="width:100%;margin-top:8px;">
                                                <tr>
                                                    <th style="text-align:center;">
                                                        <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4" style="padding:0px;">
                                                            <p>DTC Error<br /> Codes</p>
                                                        </div>
                                                        <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4" style="padding:0px;">
                                                            <p>MIL ON</p>
                                                        </div>
                                                        <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4" style="padding:0px;">
                                                            <p>Mileage<br /> Drop</p>
                                                        </div>
                                                    </th>
                                                </tr>
                                                <tr>
                                                    <td style="text-align:center;">
                                                        <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4" style="padding:0px;">
                                                            <p class="" style="color:green;font-size:18px;" onclick="OpenDataTable('2','DTC Error Codes','healthOPSDTCErrors')" id="healthOPSDTCErrors"><i class="fas fa-spinner fa-spin" style="color:#dfdfdf;"></i></p>
                                                        </div>
                                                        <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4" style="padding:0px;">
                                                            <p class="" style="color:red;font-size:18px;font-weight:bold" onclick="OpenDataTable('2','MIL ON','healthOPSMil')" id="healthOPSMil"><i class="fas fa-spinner fa-spin" style="color:#dfdfdf;"></i></p>
                                                        </div>
                                                        <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4" style="padding:0px;">
                                                            <p class="" style="color:green;font-size:18px;" onclick="OpenDataTable('2','Mileage Drop','mileageDrop')" id='mileageDrop'><i class="fas fa-spinner fa-spin" style="color:#dfdfdf;"></i></p>
                                                        </div>

                                                    </td>
                                                </tr>
                                            </table>
                                        </div>



                                    </div>
                                </div>
                            </div>



                            <div class="col-md-4 col-sm-4 col-xs-12">
                                <div class="x_panel tile fixed_height_220 panelHeight160">
                                    <div class="x_title">
                                        <h2><i class="fa fa-exclamation-circle" style="font-size:20px;color:#ef5350;"></i>&nbsp;&nbsp;HEALTH ALERTS</h2>
                                        <div class="clearfix"></div>
                                    </div>
                                    <div class="x_content row" style="margin-left:0px;">
                                        <div class="col-md-12 x_panel panelHeight96">
                                            <table class="" style="width:100%">
                                                <tr>
                                                    <th style="text-align:center;">
                                                        <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6" style="padding:0px;">
                                                            <p data-toggle="tooltip" title="Preventive and Statuatory alerts">Service Reminders</p>
                                                        </div>
                                                        <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6" style="padding:0px;">
                                                            <p>Accident</p>
                                                        </div>
                                                        <!-- <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4" style="padding:0px;">
                                                            <p>Bad</p>   -->
                                                        </div>
                                                    </th>
                                                </tr>
                                                <tr>
                                                    <td style="text-align:center;">
                                                        <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6" style="padding:0px;">
                                                            <p class="" style="color:green;font-size:18px;" onclick="OpenDataTable('2','Health ALERTS - Time Bound','serviceReminder')" id="serviceReminder"><i class="fas fa-spinner fa-spin" style="color:#dfdfdf;"></i></p>
                                                        </div>
                                                        <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6" style="padding:0px;">
                                                            <p class="" style="color:orange;font-size:18px;font-weight:bold" onclick="OpenDataTable('2','health Alerts - Accident','accident')" id="accident"><i class="fas fa-spinner fa-spin" style="color:#dfdfdf;"></i></p>
                                                        </div>
                                                       <!--  <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4" style="padding:0px;">
                                                            <p class="" style="color:red;font-size:18px;" onclick="OpenDataTable('2','Health Alerts - Bad','')">0</p>
                                                        </div>   -->

                                                    </td>
                                                </tr>
                                            </table>
                                        </div>
                                    </div>
                                </div>
                            </div>

                        </div>
                        <div id="datatable2" style="">
                            <div class="datatableHeader">
                                <div style="width:30%"><span id="datatable2Header">Count</span></div>
                                <div class="flex" style="justify-content:flex-end;width:70%; transform: translate(-10%, -10%);">
                               
                                     <button id="emailId2" type="button" class="btn btn-danger btn-sm" style="
                                     width: 50px; height: 28px;  margin-left: -86px; " onclick="loadDataThroughEmail('2')" >
	      		                    <span class="glyphicon glyphicon-envelope" title="Email"></span>  
	  		                        </button>
                                    <input placeholder="End Date" class="textbox-n" type="text" id="startDate2">
                                    <input placeholder="Start Date" class="textbox-n" type="text" id="endDate2">
                                    <button class="btn-primary" style="margin-right:64px;" onclick="OpenDataTable('2', '','')">GO</button>
                                    <i onclick="closetable('2')" class="fa fa-close close"></i>
                                </div>
                            </div>


                            <table id="myTable2" class="display" cellspacing="0" width="100%">
                            <span id="disclimer2" ><i class="fa fa-warning" style="font-size:24px;color:red"></i>&nbsp;Click on the Email button  to receive the data through Email</span>
                            </table>
                        </div>

                        <div class="row" id="row3">


                            <div class="col-md-4 col-sm-4 col-xs-12">
                                <div class="x_panel tile fixed_height_220 panelHeight160">
                                    <div class="x_title">
                                        <h2><i class="fa fa-tachometer" style="font-size:20px;color:#009688;"></i>&nbsp;&nbsp;DRIVING PERFORMANCE</h2>
                                        <div class="clearfix"></div>
                                    </div>
                                    <div class="x_content row" style="margin-left:0px;">
                                        <div class="col-md-12 x_panel panelHeight96">
                                            <table class="" style="width:100%">
                                                <tr>
                                                    <th style="text-align:center;">
                                                        <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4" style="padding:0px;">
                                                            <p data-toggle="tooltip" title="Score between 90 to 100">Good</p>
                                                        </div>
                                                        <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4" style="padding:0px;">
                                                            <p data-toggle="tooltip" title="Score beetween 70 to 90">Average</p>
                                                        </div>
                                                        <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4" style="padding:0px;">
                                                            <p data-toggle="tooltip" title="Scores between 0 to 70">Bad</p>
                                                        </div>
                                                    </th>
                                                </tr>
                                                <tr>
                                                    <td style="text-align:center;">
                                                        <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4" style="padding:0px;">
                                                            <p class="" style="color:green;font-size:18px;" onclick="OpenDataTable('3','Driving Performance - Good','drivingPerformanceGood')" id="drivingPerformanceGood"><i class="fas fa-spinner fa-spin" style="color:#dfdfdf;"></i></p>
                                                        </div>
                                                        <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4" style="padding:0px;">
                                                            <p class="" style="color:orange;font-size:18px;font-weight:bold" onclick="OpenDataTable('3','Driving Performance - Average','drivingPerformanceAvg')" id="drivingPerformanceAvg"><i class="fas fa-spinner fa-spin" style="color:#dfdfdf;"></i></p>
                                                        </div>
                                                        <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4" style="padding:0px;">
                                                            <p class="" style="color:red;font-size:18px;" onclick="OpenDataTable('3','Driving Performance - bad','drivingPerformanceBad')" id="drivingPerformanceBad"><i class="fas fa-spinner fa-spin" style="color:#dfdfdf;"></i></p>
                                                        </div>

                                                    </td>
                                                </tr>
                                            </table>
                                        </div>
                                    </div>
                                </div>
                            </div>

						                            <div class="col-md-4 col-sm-4 col-xs-12">
                                <div class="x_panel tile fixed_height_220 panelHeight160">
                                    <div class="x_title">
                                       <h2><i class="fa fa-exclamation-circle" style="font-size:20px;color:#ef5350;"></i>&nbsp;&nbsp;PERFORMANCE ALERTS</h2>
                                        <div class="clearfix"></div>
                                    </div>
                                    <div class="x_content row" style="margin-left:0px;">
                                        <div class="col-md-12 x_panel panelHeight96">
                                            <table class="" style="width:100%">
                                                <tr>
                                                    <th style="text-align:center;">
                                                        <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4" style="padding:0px;">
                                                            <p>HA</p>
                                                        </div>
                                                        <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4" style="padding:0px;">
                                                            <p>HB</p>
                                                        </div>
                                                        <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4" style="padding:0px;">
                                                            <p>HC</p>
                                                        </div>
                                                    </th>
                                                </tr>
                                                <tr>
                                                    <td style="text-align:center;">
                                                        <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4" style="padding:0px;">
                                                            <p class="" style="color:green;font-size:18px;" onclick="OpenDataTable('3','Alerts - HA','ha')" id="ha"><i class="fas fa-spinner fa-spin" style="color:#dfdfdf;"></i></p>
                                                        </div>
                                                        <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4" style="padding:0px;">
                                                            <p class="" style="color:red;font-size:18px;font-weight:bold" onclick="OpenDataTable('3','Alerts - HB','hb')" id="hb"><i class="fas fa-spinner fa-spin" style="color:#dfdfdf;"></i></p>
                                                        </div>
                                                        <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4" style="padding:0px;">
                                                            <p class="" style="color:green;font-size:18px;" onclick="OpenDataTable('3','Alerts - HC','hc')" id="hc"><i class="fas fa-spinner fa-spin" style="color:#dfdfdf;"></i></p>
                                                        </div>
                                                    </td>
                                                </tr>
                                            </table>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            
                             <div class="col-md-4 col-sm-4 col-xs-12">
                                <div class="x_panel tile fixed_height_220 panelHeight160">
                                    <div class="x_title">
                                       <h2><i class="fa fa-exclamation-circle" style="font-size:20px;color:#ef5350;"></i>&nbsp;&nbsp;IDLING</h2>
                                        <div class="clearfix"></div>
                                    </div>
                                    <div class="x_content row" style="margin-left:0px;">
                                        <div class="col-md-12 x_panel panelHeight96">
                                            <table class="" style="width:100%">
                                                <tr>
                                                    <th style="text-align:center;">
                                                        <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4" style="padding:0px;">
                                                            <p style = "margin-left: 119px;">Idling</p>
                                                        </div>
                                                  </th>
                                                </tr>
                                                <tr>
                                                    <td style="text-align:center;">
                                                        <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4" style="padding:0px;">
                                                            <p class="" style="color:green;font-size:18px;margin-left: 123px;" onclick="OpenDataTable('3','IDLE','idle')" id="idle"><i class="fas fa-spinner fa-spin" style="color:#dfdfdf;"></i></p>
                                                        </div>
                                                       
                                                    </td>
                                                </tr>
                                            </table>
                                        </div>
                                    </div>
                                </div>
                            </div>
                          
                            

                            <div class="col-md-4 col-sm-4 col-xs-12">
                                <div class="x_panel tile fixed_height_220 panelHeight160" style="display:none">
                                    <div class="x_title">
                                        <h2><i class="fa fa-line-chart" style="font-size:20px;color:#009688;"></i>&nbsp;&nbsp;PERFORMANCE OPS</h2>
                                        <div class="clearfix"></div>
                                    </div>
                                    <div class="x_content row" style="margin-left:0px;">
                                        <div class="col-md-12 x_panel panelHeight96">
                                            <table class="" style="width:100%">
                                                <tr>
                                                    <th style="text-align:center;">
                                                        <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6" style="padding:0px;">
                                                            <p>On Time Delivery</p>
                                                        </div>
                                                        <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6" style="padding:0px;">
                                                            <p>On Time Pickup</p>
                                                        </div>

                                                    </th>
                                                </tr>
                                                <tr>
                                                    <td style="text-align:center;">
                                                        <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6" style="padding:0px;">
                                                            <p class="" style="color:green;font-size:18px;" onclick="OpenDataTable('3','On Time Delivery','onTimeDelivery')" id="onTimeDelivery"><i class="fas fa-spinner fa-spin" style="color:#dfdfdf;"></i></p>
                                                        </div>
                                                        <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6" style="padding:0px;">
                                                            <p class="" style="color:red;font-size:18px;font-weight:bold" onclick="OpenDataTable('3','On Time Pickup','onTimePickup')" id="onTimePickup"><i class="fas fa-spinner fa-spin" style="color:#dfdfdf;"></i></p>
                                                        </div>
                                                    </td>
                                                </tr>
                                            </table>
                                        </div>
                                    </div>
                                </div>
                            </div>
                      
                       




                        </div>
                        <div id="datatable3" style="">
                            <div class="datatableHeader">
                                <div style="width:30%"><span id="datatable3Header">Count</span></div>
                                <div class="flex" style="justify-content:flex-end;width:70%; transform: translate(-10%, -10%);">
                                
                                    <button id="emailId3" type="button" class="btn btn-danger btn-sm" style="
                                    width: 50px; height: 28px;  margin-left: -86px; " onclick="loadDataThroughEmail('3')" >
	      		                    <span class="glyphicon glyphicon-envelope" title="Email"></span>  
	  		                        </button>
                                    <input placeholder="End Date" class="textbox-n" type="text" id="startDate3">
                                    <input placeholder="Start Date" class="textbox-n" type="text" id="endDate3">
                                    <button class="btn-primary" style="margin-right:64px;" onclick="OpenDataTable('3', '','')">GO</button>
                                    <i onclick="closetable('3')" class="fa fa-close close"></i>
                                </div>
                            </div>
                            <table id="myTable3" class="display" cellspacing="0" width="100%">
                            <span id="disclimer3" ><i class="fa fa-warning" style="font-size:24px;color:red"></i>&nbsp;Click on the Email button  to receive the data through Email</span>
                            </table>
                        </div>
                    </div>
                    <div class="col-md-3 col-sm-12 col-xs-12">
                        <div class="row" style="margin-top:16px;">

                            <div class="col-md-12 col-sm-12 col-xs-12">
                                <div class="x_panel" style="height:610px;padding:0px !important;">
                                    <div id="map" class="col-md-12 col-sm-12 col-xs-12" style="height:610px;width:100%;border-radius:8px;"></div>
                                </div>
                            </div>

                        </div>



                    </div>
                </div>
            </div>
            <!-- /page content -->

           
        </div>
    </div>



    <!-- jQuery -->
    <script src="vendors/jquery/dist/jquery.min.js"></script>
    <script src="//code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
    <script src="https://www.jqwidgets.com/public/jqwidgets/jqx-all.js"></script>
    <script src="https://www.jqwidgets.com/public/jqwidgets/globalization/globalize.js"></script>
    <!-- Bootstrap -->
    <script src="vendors/bootstrap/dist/js/bootstrap.min.js"></script>

    <!-- Custom Theme Scripts -->
    <script src="js/custom.min.js"></script>
    <script src="https://developers.google.com/maps/documentation/javascript/examples/markerclusterer/markerclusterer.js">
    </script>
<!--    <script src="https://maps.googleapis.com/maps/api/js?v=3.exp&libraries=places,geometry&key=AIzaSyCyYEUU6pc21YSjckg3bB41p2EFLCDARGg"></script>-->
    <script src="https://cdn.datatables.net/1.10.19/js/jquery.dataTables.min.js"></script>
    <link rel="stylesheet" href="https://cdn.datatables.net/1.10.19/css/jquery.dataTables.min.css" />
    <script src="https://cdn.datatables.net/buttons/1.5.6/js/dataTables.buttons.min.js"></script>
    <script src="https://cdn.datatables.net/buttons/1.5.6/js/buttons.flash.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jszip/3.1.3/jszip.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.53/pdfmake.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.53/vfs_fonts.js"></script>
    <script src="https://cdn.datatables.net/buttons/1.5.6/js/buttons.html5.min.js"></script>
    <script src="https://cdn.datatables.net/buttons/1.5.6/js/buttons.print.min.js"></script>
	<script src="../../Main/Js/markerclusterer.js"></script>
	<script src="../../Main/sweetAlert/sweetalert.min.js"></script>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-multiselect/0.9.13/js/bootstrap-multiselect.min.js"></script>
	
	<link href="../../Main/leaflet/leaflet-draw/css/leaflet.css" rel="stylesheet" type="text/css" />
    <script src="../../Main/leaflet/leaflet-draw/js/leaflet.js"></script>
	  <script src="https://leaflet.github.io/Leaflet.fullscreen/dist/Leaflet.fullscreen.min.js"></script>
	  <link rel="stylesheet" href="https://leaflet.github.io/Leaflet.fullscreen/dist/leaflet.fullscreen.css" />
	  <script src="https://unpkg.com/leaflet.markercluster@1.3.0/dist/leaflet.markercluster.js"></script>
	  <link rel="stylesheet" href="https://unpkg.com/leaflet.markercluster@1.3.0/dist/MarkerCluster.css" />
	  <link rel="stylesheet" href="https://unpkg.com/leaflet.markercluster@1.3.0/dist/MarkerCluster.Default.css" />
	  <script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
	  <script src="../../Main/leaflet/leaflet-tilelayer-here.js"></script>
<!--	  <script src="../../Main/leaflet/initializeleaflet.js"></script>-->
	  <link rel="stylesheet" href="../../Main/leaflet/leaflet.measure.css"/>
    <script src="../../Main/leaflet/leaflet.measure.js"></script>
	<script src="https://unpkg.com/esri-leaflet@2.3.1/dist/esri-leaflet.js"
  integrity="sha512-Np+ry4Dro5siJ1HZ0hTwn2jsmu/hMNrYw1EIK9EjsEVbDge4AaQhjeTGRg2ispHg7ZgDMVrSDjNrzH/kAO9Law=="
  crossorigin=""></script>


    <script><!--
    
     var sessionId = '<%=sessionId%>';
	
	 $(document).ready( function () {


		 var previousDate = new Date();
      	 previousDate.setDate(previousDate.getDate() - 1);
      	 previousDate.setHours(previousDate.getHours());
	  	 previousDate.setMinutes(previousDate.getMinutes());
	 	 previousDate.setSeconds(previousDate.getSeconds());

	 	 var currentDate = new Date();
		
	 	 

	    for (var i = 0 ; i<4; i++){
					 	$('#startDate'+i).jqxDateTimeInput({ theme: "arctic", formatString: "dd/MM/yyyy HH:mm:ss", showTimeButton: true, width: '197px', height: '25px'});
			   		 	$('#startDate'+i).jqxDateTimeInput('setDate',previousDate);

			   		 	$('#endDate'+i).jqxDateTimeInput({ theme: "arctic", formatString: "dd/MM/yyyy HH:mm:ss", showTimeButton: true, width: '197px', height: '25px'});
			   		 	$('#endDate'+i).jqxDateTimeInput('setDate', new Date());
			         }
	   $("#dateInput1").jqxDateTimeInput({ theme: "arctic", formatString: "dd/MM/yyyy HH:mm:ss", showTimeButton: true, width: '235px', height: '25px'});
       $('#dateInput1 ').jqxDateTimeInput('setDate', previousDate);
       $("#dateInput2").jqxDateTimeInput({ theme: "arctic", formatString: "dd/MM/yyyy HH:mm:ss", showTimeButton: true, width: '235px', height: '25px'});
       $('#dateInput2 ').jqxDateTimeInput('setDate', new Date());

	  $.ajax({
       url: '<%=request.getContextPath()%>/SelfDriveCarDashboardAction.do?param=getDashboardCountsRow0',
       datatype : "application/json",
       data : {
		   startDate: $("#startDate"+0).val(),
		   endDate: $("#endDate"+0).val(),
	   },
       success: function(result) {
		   let obj = JSON.parse(result);
		    $("#totalVehicles").html( obj.totalVehicles);
			$("#onTripVehicles").html( obj.onTripVehicles);
			$("#onRoadVehicles").html( obj.onRoadVehicles);
			$("#vehiclesAtServiceStation").html( obj.vehiclesAtServiceStation);	
			$("#vehiclesAtHubLocations").html( obj.vehiclesAtHubLocations);
			$("#totalKmsToday").html( obj.totalKmsToday);			
	   }
	  })
	  
	  $.ajax({
       url: '<%=request.getContextPath()%>/SelfDriveCarDashboardAction.do?param=getDashboardCountsRow2',
       datatype : "application/json",
       data : {
		   startDate: $("#startDate"+0).val(),
		   endDate: $("#endDate"+0).val(),
	   },
       success: function(result) {
		   console.log("Result", result);
		   let obj = JSON.parse(result);

		    $("#engineHigh").html( obj.engineHigh);
		    $("#engineLow").html( obj.engineLow);
			$("#engineCritical").html( obj.engineCritical);
			$("#healthOPSDTCErrors").html( obj.healthOPSDTCErrors);
			$("#healthOPSMil").html( obj.healthOPSMil);
        	$("#batteryLow").html( obj.batteryCountLow);
			$("#batteryHigh").html( obj.batteryCountHigh);
			$("#mileageDrop").html( obj.mileageDropCount);
			$("#accident").html( obj.accidentCount);
			$("#serviceReminder").html( obj.serviceReminderCount);
	   }
	  })
	  $.ajax({
       url: '<%=request.getContextPath()%>/SelfDriveCarDashboardAction.do?param=getDashboardCountsRow3',
       datatype : "application/json",
       data : {
		   startDate: $("#startDate"+0).val(),
		   endDate: $("#endDate"+0).val(),
	   },
       success: function(result) {
		   console.log("Result", result);
		   let obj = JSON.parse(result);
		    $("#ha").html( obj.HA);
  			$("#hb").html( obj.HB);
  			$("#hc").html( obj.HC);

  			$("#drivingPerformanceGood").html( obj.drivingPerformanceGood);
  			$("#drivingPerformanceAvg").html( obj.drivingPerformanceAvg);
  			$("#drivingPerformanceBad").html( obj.drivingPerformanceBad);
  			
  			$("#idle").html( obj.Idle);

  		//	$("#onTimeDelivery").html( obj.onTimeDelivery);
  		//	$("#onTimePickup").html( obj.onTimePickup);

	   }
	  })
	  $.ajax({
       url: '<%=request.getContextPath()%>/SelfDriveCarDashboardAction.do?param=getDashboardCountsRow1',
       datatype : "application/json",
       data : {
		   startDate: $("#startDate"+0).val(),
		   endDate: $("#endDate"+0).val(),
	   },
       success: function(result) {
		   let obj = JSON.parse(result);
		     
		 //   $("#sourceOnTimeStart").html( obj.sourceOnTimeStart);
  			$("#sourceDelayedStart").html( obj.sourceDelayedStart);
  		//	$("#destinationOnTimeReach").html( obj.destinationOnTimeReach);
  			$("#destinationDelayedReach").html( obj.destinationDelayedReach);
  			$("#extraKMS").html( obj.extraKMS);
			$("#crossBorderCount").html( obj.crossBorderCount);
			$("#nearFuelStationCount").html( obj.nearFuelStationCount);
			$("#lowFuelCount").html( obj.lowFuelCount);
			$("#pickupRisk").html( obj.pickupRiskCount);
			$("#restrictiveZones").html( obj.restrictiveZonesCount);
			$("#mileage").html( obj.mileageCount);
			$("#refuel").html( obj.refuelCount);
			$("#pilferage").html( obj.pilferageCount);
			
	   }
	  })
	 $.ajax({
      url: '<%=request.getContextPath()%>/SelfDriveCarDashboardAction.do?param=getDataByType',
      datatype : "application/json",
	  data : {
		   type: 'onTripVehicles',
		   startDate: $("#startDate0").val(),
		   endDate: $("#endDate0").val(),
	   },
     success: function(result) {
     clearMap();
     var data = JSON.parse(result).tableDataByType;
	 data.splice(0,1);
	 vehicles = [];
	  $.each(data,function(i, item) {
	   var index = 1;
     vehicles.push(item["1"]);
                    //var veh = "'"+item["1"]+"'";
                    
   			})
   			plotOnMap();
	   }
   })
   
    $.ajax({
               url: '<%=request.getContextPath()%>/SelfDriveCarDashboardAction.do?param=getGroupNames',
               success: function(response) {
               groupNameList = JSON.parse(response);
             for (var i = 0; i < groupNameList["groupNameListRoot"].length; i++) {
             $('#group_names').append($("<option></option>").attr("value", groupNameList["groupNameListRoot"][i].groupName).text(groupNameList["groupNameListRoot"][i].groupName));
             }
             $('#group_names').multiselect({
                           nonSelectedText:'ALL',
	                       includeSelectAllOption: true,
						   enableFiltering: true,
						   enableCaseInsensitiveFiltering: true,
						   numberDisplayed: 1,
						   allSelectedText: 'All', 
						   buttonWidth: 160,
						   maxHeight: 200, 
						   includeSelectAllOption: true,
						   selectAllText:'ALL',
						   selectAllValue:'ALL'
							});             				
		                   $("#group_names").multiselect('deselectAll', false);
						   $("#group_names").multiselect('updateButtonText');
						   $("#topRow").show();
							  				
                           }
                           });
                           
              if(sessionStorage.getItem("sessionId")== null){
                  sessionStorage.setItem("sessionId", sessionId);
                 
                 $.ajax({
                 url: '<%=request.getContextPath()%>/SelfDriveCarDashboardAction.do?param=sendAuditLog',
                 data : {
		            sessionId: sessionId,
		            startDate: $("#startDate0").val(),
		            endDate: $("#endDate0").val(),
	                   },
	                   });
	                   }
                           
         });

 var currentvehicleList = [];
 var mcOptions = {
             gridSize: 20,
             maxZoom: 50
     };	
 var vehicles = [];
 var markerClusterArray = [];
 var markerCluster;
 var layerGroup;
 let map;

    function initialize() {
    var here = L.tileLayer("https://1.base.maps.cit.api.here.com/maptile/2.1/maptile/newest/normal.day/{z}/{x}/{y}/256/png8?app_id=" + '<%=appKey%>' + "&app_code=" + '<%=appCode%>', {
        styleId: 997
    })
    var osm = L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
        attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
    });

    map = new L.Map("map", {
        fullscreenControl: {
            pseudoFullscreen: false
        },
        tms: true,
        center: new L.LatLng(<%=latitudeLongitude%>),
        zoom: 4
    });
    var baseMaps = {};
    if ('<%=mapName%>' == 'HERE') {
        baseMaps["HERE"] = here;
        baseMaps["OSM"] = osm;
    } else {
        baseMaps["OSM"] = osm;
    }
    var overlayMaps = {};
    L.control.layers(baseMaps).addTo(map);
    if ('<%=mapName%>' == 'HERE') {
        baseMaps["HERE"].addTo(map);
    } else {
        baseMaps["OSM"].addTo(map);
    }
}

initialize();
    
var currentType = "";
var currentHeader = "";
var groupNameselected = "";
var groupNamecombo = "";
var groupNameArr = "";
var groupName = "";
var startdateSelected= "";
var enddateSelected = "";
var dayDiff1 ="";
var dateDiff1 = "";
var emailEnabled = false;
var dateSwitched = false;

function OpenDataTable(id, headerText, type){
    var latestEDate = $("#endDate"+id).val();
	var latestSDate = $("#startDate"+id).val();
	
		if(isDateChanged){
			if(!dateSwitched){
				for(var x = 1 ; x<=3 ; x++){
					$('#startDate'+x).jqxDateTimeInput('setDate',startDateNew);	   
					$('#endDate'+x).jqxDateTimeInput('setDate', endDateNew);
					dateSwitched = true;
				}
			}else if(endDateNew != latestEDate && startDateNew != latestSDate){
				for(var x = 1 ; x<=3 ; x++){
					$('#startDate'+x).jqxDateTimeInput('setDate',latestSDate);	   
					$('#endDate'+x).jqxDateTimeInput('setDate', latestEDate);
				}
			}else if(endDateNew != latestEDate){
				for(var x = 1 ; x<=3 ; x++){
					$('#startDate'+x).jqxDateTimeInput('setDate',latestSDate);	
				}
			}else if(endDateNew != latestEDate){
				for(var x = 1 ; x<=3 ; x++){
					$('#endDate'+x).jqxDateTimeInput('setDate', latestEDate);
				}
			}
			
		}
			
			
			
 			if(emailEnabled){
 			emailEnabled =false;
 			$('#disclimer'+id).css('display', 'none');
 			
 			if(endDateNew == 'undefined'){
 			var previousDate = new Date();
 				previousDate.setDate(previousDate.getDate() - 1);
 				previousDate.setHours(previousDate.getHours());
 				previousDate.setMinutes(previousDate.getMinutes());
 				previousDate.setSeconds(previousDate.getSeconds());
 			$('#startDate'+id).jqxDateTimeInput('setDate',previousDate);	   
			$('#endDate'+id).jqxDateTimeInput('setDate', new Date());
 			}else{
 			$('#startDate'+id).jqxDateTimeInput('setDate',latestSDate);	   
			$('#endDate'+id).jqxDateTimeInput('setDate', latestEDate);
 			}
 			
 			}
for(let y = 0; y <= 3; y++)
{
	y !== id ? $('#datatable'+y).css({'height': '0px'}): "";
}
if ($.fn.DataTable.isDataTable('#myTable'+id)) { $('#myTable'+id).DataTable().clear().destroy();}
type != '' ? currentType=type: "";
headerText != '' ? currentHeader=headerText: "";


if (type === "totalVehicles" || type === "onTripVehicles" || type === "onRoadVehicles" || type === "vehiclesAtServiceStation" || type === "vehiclesAtHubLocations" || type === "totalKmsToday"){
	$("#startDate0").css("display", "none");
	$("#endDate0").css("display", "none");
	$("#button0").css("display", "none");
	$("#topRow").hide();
	
}else{
	$("#startDate0").css("display", "block");
	$("#endDate0").css("display", "block");
	$("#button0").css("display", "block");
}

$("#loading-div").show();


   
    
 $('#emailId'+id).prop('disabled', true);
 startdateSelected = $("#startDate"+id).val();
 enddateSelected = $("#endDate"+id).val();
 dayDiff1 = dateValidation(startdateSelected, enddateSelected);
    if (!dayDiff1) {
   	     sweetAlert("Start Date should not be greater than End Date");
   	        var previousDate = new Date();
            previousDate.setDate(previousDate.getDate() - 1);
            previousDate.setHours(previousDate.getHours());
            previousDate.setMinutes(previousDate.getMinutes());
            previousDate.setSeconds(previousDate.getSeconds());
   	        $('#startDate'+id).jqxDateTimeInput('setDate',previousDate);	   
			$('#endDate'+id).jqxDateTimeInput('setDate', new Date());
			
         }
        dateDiff1 = monthValidation(startdateSelected, enddateSelected);
        console.log("this is the difference" + dateDiff1);
         if (!dateDiff1) {
                 if(id!=0 && id<=3){
                 emailEnabled = true;
                 $('#emailId'+id).prop('disabled', false);
                 $('#disclimer'+id).css('display', 'contents');
                 $("#loading-div").hide();
                 
                }
	  }else{
      $.ajax({
      url: '<%=request.getContextPath()%>/SelfDriveCarDashboardAction.do?param=getDataByType',
      datatype : "application/json",
	  data : {
		   type: currentType,
		   startDate: $("#startDate"+id).val(),
		   endDate: $("#endDate"+id).val(),
		   groupName : groupName,
	   },
      success: function(result) {
      clearMap();
      var dataSet = JSON.parse(result).tableDataByType;
          
	  var my_columns = [];

		    var headers = Object.keys(dataSet[0]).reduce((a, c) => (a[c] = dataSet[0][c], a), {});
			$.each( headers, function( key, value ) {
			var my_item = {};
			my_item.data = key;
			my_item.title = value;

			my_columns.push(my_item);
			});
	
			dataSet.splice(0,1);
			vehicles = [];
			   $.each(dataSet,function(i, item) {
			   		var index = 1;
                    vehicles.push(item["1"]);
                    var veh = "'"+item["1"]+"'";
                    if ((currentType != 'ha')&&(currentType != 'hb')&&(currentType != 'hc')&&(currentType != 'drivingPerformanceGood')&&(currentType != 'drivingPerformanceAvg')&&(currentType != 'drivingPerformanceBad')&&(currentType != 'serviceReminder')){
				 		item["1"] = '<a style="cursor:pointer" onclick="plotVehicle('+veh+');">'+item["1"]+'</a>';
                     						 		
					}
   			    })
		  if ($.fn.DataTable.isDataTable('#myTable'+id)) { $('#myTable'+id).DataTable().clear().destroy();}
			$('#myTable'+id).html("");
			$('#myTable'+id).DataTable({
				"scrollY": 300,
				"paging": false,
				"ordering": true,
			  "columnDefs": [
				{"className": "dt-left", "targets": "_all"}
			  ],
			 
		 	  data: dataSet,
			  "columns": my_columns,
			  dom: 'Bfrtip',
			  "buttons": [{
									//extend: 'pageLength'
									//}, {
									extend: 'excel',
									text: ' Excel',
									className: 'btn btn-primary excelWidth',
									title: headerText,
	      	 						exportOptions: {
			              			  columns: ':visible'
			           			    }
									}]

			});
			document.getElementById("myTable"+id).deleteTFoot();
			if ((currentType != 'ha')&&(currentType != 'hb')&&(currentType != 'hc')&&(currentType != 'drivingPerformanceGood')&&(currentType != 'drivingPerformanceAvg')&&(currentType != 'drivingPerformanceBad')&&(currentType != 'serviceReminder')){
				plotOnMap();
			}
			
			$("#loading-div").hide();
	   },
	   error: function (result) {
	   		$("#loading-div").hide();
	   }
	   
   })
   }
 
$('#datatable'+id + 'Header').html(currentHeader);
$('#datatable'+id).css({'height': '500'});
if(id == "3")
{
  $("html, body").animate({ scrollTop: $(document).height() }, 1000);
}

}
     var previousDate = new Date();
 	previousDate.setDate(previousDate.getDate() - 1);
 	previousDate.setHours(previousDate.getHours());
 	previousDate.setMinutes(previousDate.getMinutes());
 	previousDate.setSeconds(previousDate.getSeconds());
	
	
	function closetable(id){		
	    $('#datatable'+id).css({'height': '0px'});
	   console.log("This is what is the id",id);
	  
	    if(id =="3")
	    {
	      $("html, body").animate({ scrollTop: 0 }, 1000);
	    }
	    
	    $("#loading-div").hide();
	    $("#topRow").show();
	    $('#disclimer'+id).css('display', 'none');
	    $('#emailId'+id).prop('disabled', true);
	    
	    var flag = dateValidation(startDateNew,endDateNew);
	    if(flag	){
	     	$('#startDate'+id).jqxDateTimeInput('setDate',startDateNew);	   
	   	 	$('#endDate'+id).jqxDateTimeInput('setDate', endDateNew);
	    }else{
	    	$('#startDate'+id).jqxDateTimeInput('setDate',previousDate);	   
	   	 	$('#endDate'+id).jqxDateTimeInput('setDate', new Date());
	    }
	  
	   
	   }
	
	function clearMap() {
    if (markerCluster) {
        map.removeLayer(markerCluster);
    }
    markerClusterArray = [];
}

 function reloadPage(){
        window.location.reload();
       }
	layerGroup = new L.LayerGroup().addTo(map);
	function plotOnMap (){
	 $.ajax({
       url: '<%=request.getContextPath()%>/SelfDriveCarDashboardAction.do?param=getVehicleCurrentPositions',
       datatype : "application/json",
       type: 'POST',
       data : {
		   vehicles: vehicles.toString()
		   	   },
       success: function(result) {
		   let list = JSON.parse(result);
		   layerGroup.clearLayers();
		    if (markerCluster) {
				map.removeLayer(markerCluster);
			}
			markerCluster = L.markerClusterGroup();
		   currentvehicleList = list["vehicleCurrPos"];
            var length=currentvehicleList.length;
		   $.each(list["vehicleCurrPos"],function(i, item) {
		   if (item.latitude !=null && item.longitude!=null) {
		    var pos = new L.LatLng(item.latitude, item.longitude);
                var marker = new L.Marker(pos);		
                var content = item.vehicleNo;
                marker.bindPopup(content);
				if(length>50)
				{
				markerCluster.addLayer(marker);
                markerClusterArray.push(marker);
				map.setView(pos,4);
				}else{
					marker.addTo(layerGroup);
					map.setView(pos,4);
				}
                }
                   });
	  		 map.addLayer(markerCluster);
	  }
	
	})
	}
	
	function plotVehicle(veh){
		clearMap();
		var item;
		layerGroup.clearLayers();
		if (markerCluster) {
				map.removeLayer(markerCluster);
			}
			markerCluster = L.markerClusterGroup();
		for (var k=0; k< currentvehicleList.length;k++){
			var iteratingObj = currentvehicleList[k];
 			if(iteratingObj.vehicleNo.includes(veh)){
				item =  iteratingObj;
				 var marker = new L.Marker(new L.LatLng(item.latitude, item.longitude));
                var content = item.vehicleNo;
                marker.bindPopup(content);
                markerCluster.addLayer(marker);
                markerClusterArray.push(marker);
				break;
             }
		}
		console.log("itemssssss :: "+item);
		
	map.addLayer(markerCluster);
	}
	
	
	 // window.onload = function (){
	 //   var route = "ALL";
	 //  getGroupNames(route);
	//   }
	 
	                      

  			var startDateNew;
            var endDateNew;
            var isDateChanged = false;          
            
            
               function getData(){
                             
                             groupName = "" ;
                             groupNameselected = "";
                             groupNamecombo = "";
                             isDateChanged = false;
                            startDateNew=document.getElementById("dateInput1").value;
                            endDateNew=document.getElementById("dateInput2").value; 
                            
                            if(!dateCheckValidation(endDateNew)){
                            isDateChanged = true;
                            }
                             
                            var dateDiff = monthValidation(startDateNew, endDateNew);
                            var dayDiff = dateValidation(startDateNew, endDateNew);

               if (!dayDiff) {
                  sweetAlert("Start date should not be greater than end date!");
                  return;
                 }
               if (!dateDiff) {
                  sweetAlert("Date range should not exceed 3 days!");
                  return;
                  } else {
                           $('#viewId').prop('enabled', true);
                           $('#dateInput1').prop('enabled', true);
                           $('#dateInput2').prop('enabled', true);
                          $("#loading-div").show();  
					        groupNameselected =$("#group_names option:selected");
					        groupNameselected.each(function () {
					            groupNamecombo += $(this).val() + ",";
					        });
					        
					        groupNameArr=groupNamecombo.split(",");
					          
					        if( groupNameList["groupNameListRoot"].length==groupNameArr.length-1 || groupNamecombo==""){
								groupName="ALL";
							}else{
								groupName=groupNamecombo;
							}
							loadCount(groupName,startDateNew,endDateNew);
                            }
                            }
                            
      function loadCount(groupName,startDateNew,endDateNew){
	                
	        $.ajax({
                    url: "<%=request.getContextPath()%>/SelfDriveCarDashboardAction.do?param=getGroupNameBasedCounts",
                    data: {
                           groupName: groupName,
                           startDateNew: startDateNew,
                           endDateNew: endDateNew,
                       }, 
            success: function(result) {
		           let obj = JSON.parse(result);

		
  			$("#sourceDelayedStart").html( obj.row1.sourceDelayedStart);
  		    $("#destinationDelayedReach").html( obj.row1.destinationDelayedReach);
  			$("#extraKMS").html( obj.row1.extraKMS);
			$("#crossBorderCount").html( obj.row1.crossBorderCount);
			$("#nearFuelStationCount").html( obj.row1.nearFuelStationCount);
			$("#lowFuelCount").html( obj.row1.lowFuelCount);
			$("#pickupRisk").html( obj.row1.pickupRiskCount);
			$("#restrictiveZones").html( obj.row1.restrictiveZonesCount);
			$("#mileage").html( obj.row1.mileageCount);
			$("#refuel").html( obj.row1.refuelCount);
			$("#pilferage").html( obj.row1.pilferageCount);
			$("#engineHigh").html( obj.row2.engineHigh);
		    $("#engineLow").html( obj.row2.engineLow);
			$("#engineCritical").html( obj.row2.engineCritical);
			$("#healthOPSDTCErrors").html( obj.row2.healthOPSDTCErrors);
			$("#healthOPSMil").html( obj.row2.healthOPSMil);
        	$("#batteryLow").html( obj.row2.batteryCountLow);
			$("#batteryHigh").html( obj.row2.batteryCountHigh);
			$("#accident").html( obj.row2.accidentCount);
			$("#serviceReminder").html( obj.row2.serviceReminderCount);
			$("#mileageDrop").html( obj.row2.mileageDropCount);
			$("#ha").html( obj.row3.HA);
  			$("#hb").html( obj.row3.HB);
  			$("#hc").html( obj.row3.HC);
            $("#drivingPerformanceGood").html( obj.row3.drivingPerformanceGood);
  			$("#drivingPerformanceAvg").html( obj.row3.drivingPerformanceAvg);
  			$("#drivingPerformanceBad").html( obj.row3.drivingPerformanceBad);
  			$("#idle").html( obj.row3.Idle);
			
			$("#loading-div").hide();
	        }
	         });
                    
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
    
    console.log("daysDiff" + timeDiff);
    if (daysDiff <= 3) {
        return true;
    } else {
    	if(endDate.getTime() > startDate.getTime()){
    	return false;
    	}
    	else{
    	return true;
    	}
    }
  }
  
  function dateCheckValidation(date1) {
  
    var dd = date1.split("/");
    var startDate = new Date(dd[1] + "/" + dd[0] + "/" + dd[2]);
    var endDate = new Date();
    var timeDiff = Math.abs(endDate.getTime() - startDate.getTime());
    if (timeDiff > 300000 || timeDiff < -300000) {
        return false;
    } else {
        return true;
    }
  }
  
  var startdateSelected= "";
 var enddateSelected = "";
 var previousDate = new Date();
 previousDate.setDate(previousDate.getDate() - 1);
 previousDate.setHours(previousDate.getHours());
 previousDate.setMinutes(previousDate.getMinutes());
 previousDate.setSeconds(previousDate.getSeconds());
  
  
  
  function loadDataThroughEmail(id){
             $.ajax({
                url: '<%=request.getContextPath()%>/SelfDriveCarDashboardAction.do?param=getDataThroughEmail',
                data : {
                      type: currentType,
                      groupName:groupName,
		              startDate: $("#startDate"+id).val(),
		              endDate: $("#endDate"+id).val(),
		             
		   	   },
		   	  });
			$('#startDate'+id).jqxDateTimeInput('setDate',startDateNew);	   
			$('#endDate'+id).jqxDateTimeInput('setDate', endDateNew);
			$('#disclimer'+id).css('display', 'none');
			$('#emailId'+id).prop('disabled', true);
            $("#loading-div").hide();
            
                 
             }
	 
	 



--></script>
<jsp:include page="../Common/footer.jsp" />