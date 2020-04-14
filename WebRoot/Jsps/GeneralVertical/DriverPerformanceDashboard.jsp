<%@ page language="java" import="java.util.*,t4u.functions.CommonFunctions,t4u.beans.*,t4u.common.*" pageEncoding="UTF-8"%>
<%@ taglib uri="http://packtag.sf.net" prefix="pack"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://"+ request.getServerName() + ":" + request.getServerPort()+ path + "/";
	LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
	if (loginInfo != null) {
	} else {
		response.sendRedirect(request.getContextPath()+ "/Jsps/Common/SessionDestroy.html");
	}
%>
<jsp:include page="../Common/header.jsp" />
<script>$(document).prop('title', 'Driver Performance Dashboard');</script>
		<link rel="stylesheet"
			href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
		<link rel="stylesheet"
			href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-multiselect/0.9.13/css/bootstrap-multiselect.css">
		<link rel="stylesheet" href="../../Main/sweetAlert/sweetalert.css">
		<link
			href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css"
			rel="stylesheet">
		<link
			href="https://cdn.datatables.net/1.10.16/css/dataTables.bootstrap.min.css"
			rel="stylesheet">
		<link
			href="https://cdn.datatables.net/fixedcolumns/3.2.3/css/fixedColumns.dataTables.min.css"
			rel="stylesheet">
		<link
			href="https://cdn.datatables.net/select/1.2.3/css/select.dataTables.min.css"
			rel="stylesheet" />
		<link
			href="https://cdn.datatables.net/buttons/1.5.0/css/buttons.bootstrap.min.css"
			rel="stylesheet" />
		<link rel="stylesheet"
			href="https://www.jqwidgets.com/public/jqwidgets/styles/jqx.base.css">
		<link rel="stylesheet"
			href="https://www.jqwidgets.com/public/jqwidgets/styles/jqx.energyblue.css">
		<link rel="stylesheet"
			href="https://www.jqwidgets.com/public/jqwidgets/styles/jqx.arctic.css">
		<link rel="stylesheet"
	        href="https://use.fontawesome.com/releases/v5.7.2/css/all.css">
		<link href="../../Main/vendor/customselect2.css" rel="stylesheet"/>
		
		<script
			src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
		<script
			src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
		<script
			src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-multiselect/0.9.13/js/bootstrap-multiselect.min.js"></script>
		<script src="../../Main/sweetAlert/sweetalert.min.js"></script>
		<script src="https://unpkg.com/sweetalert/dist/sweetalert.min.js"></script>
		<script
			src="https://cdn.datatables.net/1.10.16/js/jquery.dataTables.min.js"></script>
		<script
			src="https://cdn.datatables.net/1.10.16/js/dataTables.bootstrap4.min.js"></script>
		<script
			src="https://cdn.datatables.net/buttons/1.4.2/js/dataTables.buttons.min.js"></script>
		<script
			src="https://cdnjs.cloudflare.com/ajax/libs/jszip/3.1.3/jszip.min.js"></script>
		<script
			src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.32/pdfmake.min.js"></script>
		<script
			src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.32/vfs_fonts.js"></script>
		<script
			src="https://cdn.datatables.net/buttons/1.4.2/js/buttons.html5.min.js"></script>
		<script
			src="https://cdn.datatables.net/select/1.2.3/js/dataTables.select.min.js"></script>
		<script
			src="https://cdn.datatables.net/fixedcolumns/3.2.3/js/dataTables.fixedColumns.min.js"></script>

		<script type="text/javascript"
			src="https://cdn.datatables.net/buttons/1.4.2/js/buttons.bootstrap.min.js"></script>
		<script type="text/javascript"
			src="//cdn.datatables.net/buttons/1.4.2/js/buttons.colVis.min.js"></script>
		<script
			src="https://cdn.datatables.net/buttons/1.4.2/js/buttons.flash.min.js"></script>
		<script src="https://www.jqwidgets.com/public/jqwidgets/jqx-all.js"></script>
		
		<script src="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.6-rc.0/js/select2.min.js"></script>	
		
<style>
	.select2-container{
         width: 180px !important;
         margin-left: 24px;
     }
	.select2{
	 margin-bottom:8px !important;
	 }
	 .select2-dropdown{
         margin-left:-24px !important;
     }
	          .select2-container--default .select2-results > .select2-results__options {
		 	width: 180px;
		    font-size: 11px;
		}
	 
	.tabs-container{width:100%;margin:auto;}

	.custom {
	padding-left: 15px;
	padding-right: 15px;
	margin-left: auto;
	margin-right: auto;
	padding-top: 3px;
	}

.align {
	text-align: center
}

.panel {
	margin-bottom: 17px;
	background-color: #fff;
	box-shadow:0 4px 10px 0 rgba(0,0,0,0.2),0 4px 20px 0 rgba(0,0,0,0.19);
}

.percentageWell {
	float: right;
	background-color: #5cb85c;
	color: #fff;
	padding: 7px;
	border-radius: 4px;
	/* border: 1px solid #333; */
	border-bottom: 1px solid #333;
	border-left: 1px solid #333;
	text-align: center;
	width: 55px;
}

#description {
	padding-right: 1%;
}

#panelBox {
	    margin: 6px 0px 0px 0px;
}

#panelBox1 {
	height: 45px;
}

#panelBox2 {
	height: 164px;
	margin-top: 14px;
}

#example_wrapper {
	margin-top: -1%;
	border: solid 1px rgba(0, 0, 0, .25);
	padding: 1%;
	box-shadow: 0 1px 1px rgba(0, 0, 0, .25);
	width: 104%;
	margin-left: -19px;
}

#mainTable_wrapper {
	margin-top: 1%;
	border: solid 1px rgba(0, 0, 0, .25);
	padding: 1%;
	box-shadow: 0 1px 1px rgba(0, 0, 0, .25);
	width: 98.7%;
}

#summaryTable_wrapper {
	margin-top: 1%;
	border: solid 1px rgba(0, 0, 0, .25);
	padding: 1%;
	box-shadow: 0 1px 1px rgba(0, 0, 0, .25);
	width: 98.7%;
}

#detailedTable_wrapper {
	margin-top: 1%;
	border: solid 1px rgba(0, 0, 0, .25);
	padding: 1%;
	box-shadow: 0 1px 1px rgba(0, 0, 0, .25);
	width: 98.7%;
}
#scoreValueTable_wrapper {
	margin-top: 1%;
	border: solid 1px rgba(0, 0, 0, .25);
	padding: 1%;
	box-shadow: 0 1px 1px rgba(0, 0, 0, .25);
	width: 98.7%;
}
#example_filter {
	display: none;
}

#example_length {
	display: none;
}

.dataTables_scroll {
	overflow: auto;
}

#example_paginate {
	display: none;
}

#example_info {
	display: none;
}

.navDPD
{

display: flex;
flex-wrap: wrap;
padding-left: 0;
margin-bottom: 0;
}

.nav-tabs>li.active>a,.nav-tabs>li.active>a:focus,.nav-tabs>li.active>a:hover
	{
	color: black;
	cursor: default;
	font-weight: 700;
}

.nav-tabs>li>a {
	font-weight: 700;
}

.col-md-5 {
	width: 20.666667%;
}

.label {
	display: inline;
	padding: .2em .6em .3em;
	font-size: 99%;
	font-weight: 700;
	line-height: 3;
	color: #fff;
	text-align: center;
	white-space: nowrap;
	vertical-align: baseline;
	border-radius: .25em;
}

.head {
	height: 28px;
}

.headTitle {
	font-size: 13px;
	text-align: center;
	font-weight: bold;
}

.btn-success {
	color: #fff;
	background-color: #5cb85c;
	border-color: #4cae4c;
	margin-left: 10px;
	height: 28px;
	line-height: 0.428571;
}

.btn-success1 {
	color: #fff;
	background-color: #337ab7;
	border-color: #337ab7;
	margin-left: 10px;
	height: 28px;
	line-height: 0.428571;
}

/*#mainTable_filter {
	margin-top: -38px;
}

#summaryTable_filter {
	margin-top: -35px;
}

#detailedTable_filter {
	margin-top: -38px;
}*/

td.details-control {
	background: url('../../Main/images/details_open.png') no-repeat center
		center;
	cursor: pointer;
}

tr.shown td.details-control {
	background: url('../../Main/images/details_close.png') no-repeat center
		center;
}

.row {
	width:100%;
}

.modal-backdrop {
	z-index: 0;
}

.modal {
	position: fixed;
	top: 6%;
	left: 0%;
	z-index: 1;
	width: 88%;
	bottom: unset;
	background-color: #ffffff;
	border: 1px solid #999;
	border: 1px solid rgba(0, 0, 0, 0.3);
	-webkit-box-shadow: 0 3px 7px rgba(0, 0, 0, 0.3);
	-moz-box-shadow: 0 3px 7px rgba(0, 0, 0, 0.3);
	box-shadow: 0 3px 7px rgba(0, 0, 0, 0.3);
	-webkit-background-clip: padding-box;
	-moz-background-clip: padding-box;
	background-clip: padding-box;
	outline: none;
	border-radius: 4px;
	overflow-y: auto;
}

.modal-content .modal-body {
	padding-top: 24px;
	padding-right: 24px;
	padding-bottom: 16px;
	padding-left: 24px;
	overflow-y: auto;
	max-height: 400px;
}

.modal-open .modal {
	overflow-x: hidden;
	overflow-y: hidden;
}

.blueGrey {
	background: #337ab7;
}

.blueGreyLight {
	background: #ECEFF1;
}

.whiteFont {
	color: #ffffff;
}

.close {
	float: right;
	display: inline-block;
	padding: 0px 12px 0px 8px;
}

.close:hover {
	cursor: pointer;
}

.infoDiv td {
	padding: 4px 0px 4px 0px;
	vertical-align: top;
	line-height: 12px;
}

.select2 {
	width: 240px !important;
}

.blueGreyDark {
	background: #337ab7;
}

.pointer {
	cursor: pointer;
}
.highlight {
	color: white !important;
	background: #00A0D6 !important;
}

.dataTables_filter {
	margin-top: -32px;
}


.table {
	width: 100%;
	max-width: 100%;
	margin-bottom: 1rem;
	background-color: transparent;
	font-size: 12px;
}

.viewRemark {<!--
	font-size: 16px !important; -->
	height: 200px !important;
	width: 60% !important;
	margin-left: 20% !important;
	margin-top: 30px;
}

#enterRemarkModel{
	background-color: transparent !important;
	-webkit-box-shadow:  none;
	-moz-box-shadow:  none;
	box-shadow: none;
	border: 0px;
	
}

#createTitle {
	text-align: center;
	margin-left: 69px;
	color: white;
	height: 33px;
	padding-top: 6px;
}
.col-md-1, .col-md-2, .col-lg-2 {padding-top:8px;}

.topRowData{
	margin-bottom: 24px;
    color: #ece9e6;
    text-align: center;
	background: #355869;
	border-radius:2px;
	padding: 4px 0px 8px 0px;
	margin-left: 0px !important;
	margin-right: 0px !important;
}
.dhlBackTop{
  color: #D40511;
  background: #FFCC00;
  padding: 8px 16px;
  font-weight: bold;
  border-radius: 2px;
}
.topRow {
	margin-top: -24px;
	background: #355869;
	border-radius: 2px;
	padding: 4px 0px 8px 0px;
	margin-left: 0px !important;
	margin-right: 0px !important;
}
.topHeader {
	font-size: 12px;
	font-weight: 600;
	color: #ece9e6;
}
.leftMargin {
	margin-left: 16px;
}
.panelIncDec{
	padding: 14px 0px 0px 0px !important;
}
.cardUser {
	box-shadow: 0 2px 5px 0 rgba(0,0,0,0.2), 0 2px 10px 0 rgba(0,0,0,0.19);
	padding: 10px;
	margin-bottom: 8px;
	border-radius: 2px !important;
}
.card {
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
	margin-bottom:16px;
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
	padding: 8px 20px 8px 20px;
}
.blue-gradient-rgba {
	background: linear-gradient(to right, rgb(58, 96, 115), rgb(22, 34, 42))!important;
  }
  
  button .caret{
	  display:none !important;
  }
  button {
	      height: 28px;
    padding: 0px 8px !important;
  text-align: left !important;}
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
.bwidth{
	min-width:200px;
	min-height:24px;
	padding-top:6px;
  }
  #bottom5DriverTableId_length{
	  display : none !important;
  }
  #top5DriverTableId_length{
	  display : none !important;
  }
  #bottom5DriverTableId_filter{
	  display : none !important;
  }
  #top5DriverTableId_filter{
	  display : none !important;
  }
  #top5DriverTableId_info{
	  display : none !important;
  }
  #bottom5DriverTableId_info{
	  display : none !important;
  }
  #top5DriverTableId_paginate{
	  display : none !important;
  }
  #bottom5DriverTableId_paginate{
	  display : none !important;
  }
  
  .whiteSpace{
	  white-space:nowrap;
	  text-align:center;
  }
  table tr td{
	  
	  white-space:nowrap;
  }
  
  .select2-results__options{
	  width:100% !important;
  }
  .select2-selection__arrow{
	  margin-right:16px !important;
  }
  
  #trainingRemarksId{
	  white-space:normal;
  }
.label-danger {
    background-color: #D40511 !important;
}
.label-success {
    background-color: #5cb85c !important;
}
</style>
	<div class="center-viewInitial" id="loading-divInitial"  style="display:block;">
		<img src="../../Main/images/loading.gif" alt="" style="position:absolute;left:48%;top: 40vh;z-index:5;">
	</div>
	<div class="center-view" id="loading-div" style="display:none;z-index:5;">
		<img src="../../Main/images/loading.gif" alt="" style="position:absolute;left:48%;top: 40%;">
	</div>
	<div class="topRowData dhlBackTop" id="slaDashboardHeader" style="margin-top:-16px;display:flex;justify-content:space-between;align-items:center;">
		<div style="font-weight:bold;font-size:16px;">DRIVER PERFORMANCE DASHBOARD</div>
    </div>
	<div class="row topRow" style="margin-top:-12px;">
		<div class="col-lg-12"  >
			<div style="display:flex;width:100%">
				<div class="col-lg-3 input-group date"> <span class="topHeader" title="Start of the selected Date"> &nbsp;START DATE </span><br/>
					<input type='text' id="dateInput1" />
                </div>
				<div class="col-lg-3 input-group date" style="margin-left:-100px;"> <span class="topHeader" title="End of the selected Date"> &nbsp;END DATE</span> <br/>
					<input type='text' id="dateInput2" />
				</div>
				<div class="leftMargin" style="margin-left:-100px;"> <span class="topHeader">&nbsp;HUB NAME</span> <br/>
				   <select  id="hubNamesCombo" multiple="multiple" class="input-s" name="state" style="height:24px;"> </select>
				</div>
				<div class="leftMargin" style="margin-left:-0px;" title="Hub associated drivers"> <span class="topHeader" style="margin-left:24px;">&nbsp;DRIVERS</span> <br/>
				   <select  id="driverNamesCombo"  class="form-control"> </select>
				</div>
				<div style="display:flex;padding-top:20px;" title="Click here to see the details">
				   <input onclick="viewClicked()" type="button" class="btn btn-success" style="padding-left:16px;padding-right:16px;" value="View" />
				</div>
			</div>
		</div>
	</div>
	<div class="row" style="margin-top: 8px;">
		<div class="col-lg-4 ">
			<div class="card">
			    <div class="cardHeading blue-gradient-rgba">
                    <div class="threePixelPadding">DRIVER SCORE</div>
                </div>
				<div style="display:flex">
				<div class="col-xs-12 col-md-6 " title="Last to Date :- Overall score from the first day">
					<div id="panelBox2" class="panel">
						<div class="panel-body">
							<h2 class="align" style="font-size: 43px; margin-top: 37px;">
								<span id="overallScore">0</span>
							</h2>
							<h5 id="description" class="align" style="padding-top: 20px;">
								<Span>LTD</span>
							</h5>
						</div>
					</div>
				</div>
				<div class="col-xs-12 col-md-6 " title="Total Score of this month">
					<div id="panelBox2" class="panel">
<!--						<span id="relativeTimeColorId" class="col-md-4 percentageWell"> <span id="percId">0</span>%</span>-->
						<div class="panel-body">
							<h2 class="align" style="font-size: 43px; margin-top: 37px;">
								<span id="presentScore">0</span>
							</h2>
							<h5 id="description" class="align"
								style="padding-top: 20px;">
								<Span>Current Month</span>
							</h5>
						</div>
					</div>
				</div>
				</div>
			</div>
		</div>
		<div class="col-lg-4">
		<div class="card">
			    <div class="cardHeading blue-gradient-rgba">
                    <div class="threePixelPadding">PARAMETER</div>
                </div>

				<div class="col-xs-12 col-md-12" title="Top 2 score of the given Date range">
					<div id="panelBox" class="panel"style="margin-top:16px;">
						<div class="panel-body panelIncDec">
							<div class="col-xs-12 col-md-3 ">
								<h5 id="description" class="align"
									style="font-weight: 700;width: 80px;">
									Increment
								</h5>
								<span class="glyphicon glyphicon-triangle-top"
									style="color: #5cb85c; font-size: 20px;"></span>
							</div>
							<div class="col-xs-12 col-md-9" style="margin-top: -17px;">
								<div class="col-xs-12 col-md-12 ">
									<span id="description1" class="label label-success"></span>
								</div>
								<div class="col-xs-12 col-md-12 ">
									<span id="description2" class="label label-success"></span>
								</div>
							</div>
						</div>
					</div>
				</div>
				<div class="col-xs-12 col-md-12" title="Bottom 2 score of the given Date range">
					<div id="panelBox" class="panel" style="margin-bottom:12px;">
						<div class="panel-body panelIncDec">
							<div class="col-xs-12 col-md-3">
								<h5 id="description" class="align"
									style="font-weight: 700;width: 84px;">
									Decrement
								</h5>
								<span class="glyphicon glyphicon-triangle-bottom"
									style="color: #D40511; font-size: 20px;"></span>
							</div>
							<div class="col-xs-12 col-md-9" style="margin-top: -17px;">
								<div class="col-xs-12 col-md-12 ">
									<span id="description3" class="label label-danger"></span>
								</div>
								<div class="col-xs-12 col-md-12">
									<span id="description4" class="label label-danger"></span>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
		<div class="col-lg-4">
			<div class="card">
			<div class="cardHeading blue-gradient-rgba" style="z-index:6">
                    <div class="threePixelPadding">SCORE DISTRIBUTION</div>
                </div>
				<div class="pie-chart" id="pieChartId" style="margin-top:-8px;z-index:0" title="Score distribution of the given Date range"></div>
			</div>
		</div>
	</div>	
						
	<div class="flex" style="justify-content:space-between; display:none;margin-bottom:16px;" id="driverDetailsId">
		<div class="cardDet col-lg-8" id="cardDet" style="width:64%">
			<div class="cardHeading blue-gradient-rgba">
				<div class="threePixelPadding" style="text-align:center;width:100%">DRIVER DETAILS</div>
			</div>
			<div class="flex" style="justify-content:space-between;">
				<div class="cardDet col-lg-8" id="cardDet" style="width:48%">
					<ul class="list-group">
						<li  class="list-group-item d-flex justify-content-between align-items-center flexRow">
						<span data-toggle="tooltip" title="">Driver Name</span>
						<span class="badge badge-primary badge-pill bwidth blue-gradient-rgba" id="driverNameId" >
						<i class="fas fa-spinner fa-spin spinnerColor"></i>
						</span>
						</li>
						<li class="list-group-item d-flex justify-content-between align-items-center flexRow">
						<span data-toggle="tooltip" title="">Hub Name</span>
						<span class="badge badge-primary badge-pill bwidth blue-gradient-rgba" id="hubNameId" >
						<i class="fas fa-spinner fa-spin spinnerColor"></i>
						</span>
						</li>
					</ul>
				</div>
				<div class="cardDet col-lg-6" style="width:48%;margin-left:4px;">	
					<ul class="list-group">
						<li  class="list-group-item d-flex justify-content-between align-items-center flexRow">
						<span data-toggle="tooltip" title="">Period</span>
						<span class="badge badge-primary badge-pill bwidth blue-gradient-rgba" id="periodId" >
						<i class="fas fa-spinner fa-spin spinnerColor"></i>
						</span>
						</li>
						<li class="list-group-item d-flex justify-content-between align-items-center flexRow">
						<span data-toggle="tooltip" title="">Period Score</span>
						<span class="badge badge-primary badge-pill bwidth blue-gradient-rgba" id="periodScoreId" >
						<i class="fas fa-spinner fa-spin spinnerColor"></i>
						</span>
						</li>
					</ul>
				</div>
			</div>
		</div>	
        <div class="cardDet col-lg-4" style="height:148px;width:32%;margin-left:4px;">
          <div class="cardHeading blue-gradient-rgba">
            <div class="threePixelPadding" style="text-align:center;width:100%">TRAINING REMARKS
            </div>
          </div>
          <ul class="list-group">
            <li  class="list-group-item d-flex justify-content-between align-items-center flexRow">
			  <div class="badge blue-gradient-rgba" id="statusMainBack" style="padding:32px 16px;width: 100%;margin-left: 0px;" >
				<div id="trainingRemarksId">
					<strong>
					</strong>
				 </div>
			  </div>
				<div style="margin-left: 16px;display:flex;flex-direction:column;">
					<div title="View Driver Training Remarks" onclick="viewTrainingRemark()"><a href="#"><i class="far fa-eye"></i></a></div>
					<div title="Add Driver Training Remarks" onclick="enterRemark()"><a href="#"><i class="fas fa-plus"></i></a></div>
			</div>
            </li>
          </ul>
        </div>
    </div>
						
	<div class="row" style="margin-top:32px;">
		<div class="col-lg-6">
		<div class="card">
          <div class="cardHeading blue-gradient-rgba">
            <div class="threePixelPadding" style="text-align:center;width:100%">TOP 5 DRIVERS
            </div>
          </div>
			<div class="panel-body" style="width:115% !important; margin-left:-27px !important;">
				<table id="top5DriverTableId" class="table table-striped table-bordered"
					cellspacing="0" width="98%" style="margin-top: 8px;font-size:11px;">
					<thead>
						<tr>
						<th class="whiteSpace">Rank</th>
						<th class="whiteSpace">Name (Id)</th>
						<th class="whiteSpace">Period Score</th>
						<th class="whiteSpace">Overall Score</th>
						<th class="whiteSpace">Overall Rank</th>
						</tr>
					</thead>
				</table>
			</div>
			</div>
		</div>
		<div class="col-lg-6">
		<div class="card">
			<div class="cardHeading blue-gradient-rgba">
				<div class="threePixelPadding" style="text-align:center;width:100%">FLOP 5 DRIVERS</div>
			</div>
			<div class="panel-body" style="width:115% !important; margin-left:-27px !important;">
				<table id="bottom5DriverTableId" class="table table-striped table-bordered"
					cellspacing="0" width="98%" style="margin-top: 8px;font-size:11px;">
					<thead>
						<tr>
						<th class="whiteSpace">Rank</th>
						<th class="whiteSpace">Name (Id)</th>
						<th class="whiteSpace">Period Score</th>
						<th class="whiteSpace">Overall Score</th>
						<th class="whiteSpace">Overall Rank</th>
						</tr>
					</thead>
				</table>
			</div>
			</div>
		</div>
	</div>
	 <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12 text-center">
			  <div id="page-loader" style="margin-top:10px;display:none;">
			<img src="../../Main/images/loading.gif" alt="loader" />
		</div>
	 </div>
	<div class="row" style="margin-top:16px;">
		<div class="col-lg-12">
		<div class="tabs-container">
		<ul class="nav nav-tabs">
			<li>
				<a href="#summaryId" data-toggle="tab" active>Snapshot</a>
			</li>
			<li>
				<a href="#listViewId" data-toggle="tab">Score Details</a>
			</li>
			<li>
				<a href="#detailsViewId" data-toggle="tab">Values</a>
			</li>
			<li>
				<a href="#scoreValueId" data-toggle="tab">Score-Values</a>
			</li>
		</ul>
	</div>
	<div class="tab-content" id="tabs">
		<div class="tab-pane" id="summaryId">
			<table id="summaryTable"
				class="table table-striped table-bordered" cellspacing="0"
				width="100%" style="margin-top: 1%">
				<thead>
					<tr>
						<th>
							Sl No
						</th>
						<th>
							Employee Id
						</th>
						<th>
							Name
						</th>
						<th>
							Safety Score
						</th>
						<th>
							Performance Score
						</th>
						<th>
							Economy Score
						</th>
						<th>
							Total Score
						</th>
						<th>
							Driver Id
						</th>
						<th>
							Mileage(Kms/L)
						</th>
					</tr>
				</thead>
			</table>
		</div>
		<div class="tab-pane" id="listViewId">
			<i class="fa fa-fw"></i> Driver Information
			<span id="disclimer"> (Double Click on the Records For
				Graph View)</span>
			<table id="mainTable" class="table table-striped table-bordered"
				cellspacing="0" width="100%" style="margin-top: 1%">
				<thead>
					<tr>
						<th>
							Sl No
						</th>
						<th>
							Employee Id
						</th>
						<th>
							Name
						</th>
						<th>
							Total Score
						</th>
						<th>
							No. of trips
						</th>
						<th>
							Total Distance Travelled (Kms)
						</th>
						<th>
							Total Time Travelled (HH:mm)
						</th>
						<th>
							Overall On-time performance
						</th>
						<th>
							Avg LLS Mileage KMPL
						</th>
						<th>
							Avg OBD Mileage KMPL
						</th>
						<th>
							Average Speed (Kms/H)
						</th>
						<th>
							Harsh Acceleration
						</th>
						<th>
							Harsh Braking
						</th>
						<th>
							Harsh Cornering
						</th>
						<th>
							Overspeeding
						</th>
						<th>
							Total Freewheeling Time
						</th>
						<th>
							Unscheduled Stoppage Time
						</th>
						<th>
							Excessive Idling Time
						</th>
						<th>
							Green Band Speed
						</th>
						<th>
							Erratic Speeding
						</th>
						<th>
							Green Band RPM
						</th>
						<th>
							Low RPM
						</th>
						<th>
							High RPM
						</th>
						<th>
							Over-Revving
						</th>
						<th>
							Driver Id
						</th>
						<th>
							OTP Score
						</th>
					</tr>
				</thead>
			</table>
		</div>
		<div class="tab-pane" id="detailsViewId">
			<i class="fa fa-fw"></i> Driver Details
			<span id="disclimer1"> (Click on the Records For Expanded
				View)</span>
				<input type="button" id="legbtn" title="Make Sure Pop-up is not blocked for Your Browser" class="btn btn-primary" value="Leg Wise Export">
			<table id="detailedTable"
				class="table table-striped table-bordered" cellspacing="0"
				width="100%" style="margin-top: 1%">
				<thead>
					<tr>
						<th>
							Sl No
						</th>
						<th>
							Employee Id
						</th>
						<th>
							Name
						</th>
						<th>
							No. of trips
						</th>
						<th>
							Harsh Acceleration (per Hr)
						</th>
						<th>
							Harsh Braking (per Hr)
						</th>
						<th>
							Harsh Cornering (per Hr)
						</th>
						<th>
							Overspeeding (per Hr)
						</th>
						<th>
							Total Freewheeling Time (%Time)
						</th>
						<th>
							Unscheduled Stoppage Time (%Time)
						</th>
						<th>
							Excessive Idling Time (%Time)
						</th>
						<th>
							Green Band Speed (%Time)
						</th>
						<th>
							Erratic Speeding (%Time)
						</th>
						<th>
							Green Band RPM kms (%Time)
						</th>
						<th>
							Low RPM (%Time)
						</th>
						<th>
							High RPM (%Time)
						</th>
						<th>
							Over-Revving (per Hr)
						</th>
						<th>
							Driver Id
						</th>
						<th>
							LLS Mileage KMPL
						</th>
						<th>
							OBD Mileage KMPL
						</th>
						
					</tr>
				</thead>
			</table>
				</div>
			<div class="tab-pane" id="scoreValueId">
			<i class="fa fa-fw"></i> Score-Value
<!--								<span id="disclimer"> (Double Click on the Records For-->
<!--									Graph View)</span>-->
			<input type="button" id="legReportForDriverScorebtn" title="Make Sure Pop-up is not blocked for Your Browser" class="btn btn-primary" value="Leg Report For Driver Score Export" style="margin-left:2%; margin-top:1%;">
			<table id="scoreValueTable" class="table table-striped table-bordered"
				cellspacing="0" width="100%" style="margin-top: 1%">
				<thead>
					<tr>
						<th rowspan="2">
							Sl No
						</th>
						<th rowspan="2">
							Employee Id
						</th>
						<th rowspan="2">
							Name
						</th>
						<th rowspan="2">
							Total Score
						</th>
						<th rowspan="2">
							No. of trips
						</th>
						<th rowspan="2">
							Total Distance Travelled (Kms)
						</th>
						<th rowspan="2">
							Total Time Travelled (HH:mm)
						</th>
						<th rowspan="2">
							Overall On-time performance
						</th>
						<th rowspan="2">
							Avg LLS Mileage KMPL
						</th>
						<th rowspan="2">
							Avg OBD Mileage KMPL
						</th>
						<th rowspan="2">
							Average Speed (Kms/H)
						</th>
						<th colspan="12" style="text-align: center;background-color: #d0e1e1;">
							Scores
						</th>
						<th colspan="12" style="text-align: center;background-color: #9999ff;">
							Values
						</th>
					</tr>
					<tr>
						<th>
							Harsh Acceleration
						</th>
						<th>
							Harsh Braking
						</th>
						<th>
							Harsh Cornering
						</th>
						<th>
							Overspeeding
						</th>
						<th>
							Total Freewheeling Time
						</th>
						<th>
							Unscheduled Stoppage Time
						</th>
						<th>
							Excessive Idling Time
						</th>
						<th>
							Green Band Speed
						</th>
<!--											<th>-->
<!--												Erratic Speeding-->
<!--											</th>-->
						<th>
							Green Band RPM
						</th>
						<th>
							Low RPM
						</th>
						<th>
							High RPM
						</th>
						<th>
							Over-Revving
						</th>
						<th>
							Harsh Acceleration (per Hr)
						</th>
						<th>
							Harsh Braking (per Hr)
						</th>
						<th>
							Harsh Cornering (per Hr)
						</th>
						<th>
							Overspeeding (per Hr)
						</th>
						<th>
							Total Freewheeling Time (%Time)
						</th>
						<th>
							Unscheduled Stoppage Time (%Time)
						</th>
						<th>
							Excessive Idling Time (%Time)
						</th>
						<th>
							Green Band Speed (%Time)
						</th>
<!--											<th>-->
<!--												Erratic Speeding (%Time)-->
<!--											</th>-->
						<th>
							Green Band RPM kms (%Time)
						</th>
						<th>
							Low RPM (%Time)
						</th>
						<th>
							High RPM (%Time)
						</th>
						<th>
							Over-Revving (per Hr)
						</th>
						<th>
							Driver Id
						</th>
						<th>
							OTP Score
						</th>
					</tr>
				</thead>
			</table>
		</div>
				
			</div>
		</div>
	</div>


		<div id="add" class="modal fade"
			style="width: 90%; margin-left: 63px;     margin-top: 65px;">
			<div class="modal-content">
				<div class="modal-header" style="border-bottom: none;">

					<div style="margin-left: 20%;">
						From
						<span class="badge" id="drivernameId"></span> To
						<span class="badge" id="drivernameId1"></span> &nbsp;&nbsp;&nbsp;
						OTP:
						<span class="badge" id="otpId"></span>&nbsp;&nbsp;&nbsp; Mileage:
						<span class="badge" id="MileageId"></span> OBD Mileage:
						<span class="badge" id="OBDMileageId"></span>
					</div>
						<div style="    margin-top: -1%;    margin-left: 35%;">
						<button type="button" class="close" style="align: right;"
							data-dismiss="modal">
							&times;
						</button>
					</div>
				</div>
				<div class="modal-body" style="height: 100%;">
					<div class="row">
						<div class="col-lg-12" style="margin-top: -30px;">
							<div id="chart_div"></div>
						</div>
					</div>
				</div>
			</div>
		</div>
		
	<div id="viewRemarkModal" class="modal fade viewRemark" style="height: 85% !important;z-index:7;">
		<div class="row blueGreyDark modalHeader">
			<div class="col-md-10">
				<h4 id="createTitle" class="modal-title">
					Remarks 
				</h4>
			</div>
			<div class="col-md-2 fa fa-window-close" data-dismiss="modal"
				style="cursor: pointer; color: white; text-align: right; padding-right: 10px; margin-top: 9px;">
			</div>
		</div>
		<div class="modal-body"
			style="margin-top: 8px; height: 80vh; overflow-y: auto; padding-top: 10px;">
			<table id="viewRemarkTable" class="table table-striped table-bordered"
				cellspacing="0" width="100%">
				<thead>
					<tr>
						<th>S No</th>
						<th>Driver Name(Id)</th>
						<th>Hub Name</th>
						<th>Score</th>
						<th>Remarks</th>
						<th>Updated By</th>
					</tr>
				</thead>
			</table>
		</div>
	</div>

	<div id="enterRemarkModel" class="modal fade" style="margin-top: 8%;z-index:7;" >
	  <div class="modal-dialog" >
		<div class="modal-content" style="width: 140%;">
		  <div class="modal-header">
		   <button type="button" class="close" data-dismiss="modal">&times;</button>
		  </div>
		  <div class="modal-body" style="max-height: 100%;">
			<div class="col-xs-12 col-md-12 col-lg-12">
				<div class="form-group">
					<label for="enterRemarkId" class="control-label col-xs-4 col-md-4 col-lg-4">Enter Remark:  </label>
					<div class="col-xs-6 col-md-6 col-lg-6">
					  <textarea type="text" class="form-control" id="enterRemarkTextId" placeholder="Enter remarks">
					  </textarea>
					</div>
				</div>
			</div>
		  </div>
		  <div class="modal-footer" >
			<button  class="btn btn-primary" Onclick="saveTrainingRemarks()">Save</button> 
			<button type="reset" class="btn btn-warning" data-dismiss="modal">Close</button> 
		  </div>
		</div>
	  </div>
	</div>
<script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
<script>
	//history.pushState({ foo: 'fake' }, 'Fake Url', 'DriverPerformanceDashboard#');
    var toptable;
	var bottomtable;
    var maintable;
    var custId;
    var summaryTable;
    var detailedTable;
    var scoreValueTable;
    var currentDate = new Date();
    var startDate=document.getElementById("dateInput1").value;
    var endDate=document.getElementById("dateInput2").value;
	var globalHubId = 0;
	var globalHubName = "";
	var globalScore = 0;
	var globalDriverName="";
 	var driverSelected = true;

    function activaTab(tab) {
        $('.nav-tabs a[href="#' + tab + '"]').tab('show');
    };
    activaTab('summaryId');

    if ($.fn.DataTable.isDataTable('#top5DriverTableId')) {
        $('#top5DriverTableId').DataTable().destroy();
    }
	if ($.fn.DataTable.isDataTable('#bottom5DriverTableId')) {
        $('#bottom5DriverTableId').DataTable().destroy();
    }
    if ($.fn.DataTable.isDataTable('#mainTable')) {
        $('#mainTable').DataTable().destroy();
    }
    if ($.fn.DataTable.isDataTable('#detailedTable')) {
        $('#detailedTable').DataTable().destroy();
    }
     if ($.fn.DataTable.isDataTable('#scoreValueTable')) {
        $('#scoreValueTable').DataTable().destroy();
    }

	$(document).ready(function() {
		var firstDayOfMonth = new Date(currentDate.getFullYear(), currentDate.getMonth(),1);
		$("#dateInput1").jqxDateTimeInput({ theme: "arctic", formatString: "dd/MM/yyyy", showTimeButton: false, width: '197px', height: '25px'});
		$('#dateInput1 ').jqxDateTimeInput('setDate', firstDayOfMonth);
		$('#dateInput1').jqxDateTimeInput('setMaxDate', new Date());
		
		$("#dateInput2").jqxDateTimeInput({ theme: "arctic", formatString: "dd/MM/yyyy", showTimeButton: false, width: '197px', height: '25px'});
		$('#dateInput2 ').jqxDateTimeInput('setDate', currentDate);
		$('#dateInput2').jqxDateTimeInput('setMaxDate', new Date());
		
		loadHubCombo();
		loadDriverCombo();
		loadData();
	});
	
	function viewClicked(){
		if($("#driverNamesCombo").val() === null){
			swal("Driver not found","Please make sure Drivers are associated to hubs","error");
		}
		$("#loading-div").show();
		loadData();
	}
	function loadHubCombo(){
		$.ajax({
		url: '<%=request.getContextPath()%>/tripDashBoardAction.do?param=getHubNames',
		success: function(response) {
			hubList = JSON.parse(response);
			for (var i = 0; i < hubList["hubNamesRoot"].length; i++) {
				$('#hubNamesCombo').append($("<option></option>").attr("value", hubList["hubNamesRoot"][i].hubId).text(hubList["hubNamesRoot"][i].hubName));
			}
			$('#hubNamesCombo').multiselect({
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
			$("#hubNamesCombo").multiselect('selectAll', false);
			$("#hubNamesCombo").multiselect('updateButtonText');
		}
		});
	}
	$('#hubNamesCombo').change(function () {
		loadDriverCombo(true);
	})
	
	function loadDriverCombo(select){
		$("#driverNamesCombo").empty().select2();
		$.ajax({
		url: '<%=request.getContextPath()%>/tripDashBoardAction.do?param=getDriverNames',
		"data":{
			hubList : $("#hubNamesCombo").val().toString()
		},
		success: function(response) {
			driverList = JSON.parse(response);
			if(driverList["driverNamesRoot"].length > 0){
				$('#driverNamesCombo').append($("<option></option>").attr("value", 0).text("ALL"));
			}
			for (var i = 0; i < driverList["driverNamesRoot"].length; i++) {
				$('#driverNamesCombo').append($("<option></option>").attr("value", driverList["driverNamesRoot"][i].driverId).text(driverList["driverNamesRoot"][i].driverName));
			}
			$('#driverNamesCombo').select2();
		}
		});
	}
	function drawChart() {
		$.ajax({
			url: '<%=request.getContextPath()%>/tripDashBoardAction.do?param=getDriverPerformanceDataForChart',
			data: {
				startDate : document.getElementById("dateInput1").value,
				endDate : document.getElementById("dateInput2").value,
				driverId : $("#driverNamesCombo").val(),
				hubList : $("#hubNamesCombo").val().toString()
			},
			success: function(response) {
				var jsonList = JSON.parse(response);
				var lowCount = jsonList["chartDataRoot"][0].lowCount;
				var mediumCount = jsonList["chartDataRoot"][0].mediumCount;
				var highCount = jsonList["chartDataRoot"][0].highCount;

				var data = google.visualization.arrayToDataTable([
					['Task', 'Vehicle Placement'],
					['0-7', Number(lowCount)],
					['7-9', Number(mediumCount)],
					['9-10', Number(highCount)]
				]);
				var options = {
					width: $("#pieChartId").width(),
					height: $("#pieChartId").height(),
					title: '',
					legend: 'bottom',
					pieSliceText: 'value-and-percentage',
					colors: ['#D40511', '#ffc107', '#5cb85c']
				};
				var chart = new google.visualization.PieChart(document.getElementById('pieChartId'));
				chart.draw(data, options);
			}
		});
	}
	function saveTrainingRemarks(){
			$.ajax({
			url: "<%=request.getContextPath()%>/tripDashBoardAction.do?param=updateRemarks",
			"data": {
				driverId : $("#driverNamesCombo").val(),
				driverName : globalDriverName,
				hubId : globalHubId,
				hubName : globalHubName,
				score : $("#overallScore").text(),
				remarks : $("#enterRemarkTextId").val()
			},
			success: function(remarksResult) {
				if(remarksResult === 'Error.Success'){
					swal("Success", "Trainig remarks updated successfully","success");
				}else{
					swal("Failed", "Error occurred while updating", "error");
				}
				$('#enterRemarkModel').modal('hide');
			}
		});
	}

	function getDateObject(datestr) {
        var parts = datestr.split(' ');
        var dateparts = parts[0].split('/');
        var day = dateparts[0];
        var month = parseInt(dateparts[1]) - 1;
        var year = dateparts[2];
        //var timeparts = parts[1].split(':')
        //var hh = timeparts[0];
        //var mm = timeparts[1];
        //var ss = timeparts[2];
        var date = new Date(year, month, day, 00, 00, 00, 00);
        return date;
     }
 	function loadData() {
 		var driverSelected = true;
         startDate=document.getElementById("dateInput1").value;
   	     endDate=document.getElementById("dateInput2").value;

         val = checkMonthValidation(startDate,endDate);
         if(!val) {
        	swal("Date Validation", "Please select one month date range", "error");
        	return;
    	 }
    	 if(getDateObject(startDate) > getDateObject(endDate)) {
        	swal("Date Validation", "Start date is more than end date", "error");
        	return;
    	 }
		let params = {
			startDate: startDate,
			endDate:endDate,
			driverId : $("#driverNamesCombo").val(),
			hubList : $("#hubNamesCombo").val().toString()
         }
         if($("#driverNamesCombo").val() == null || $("#driverNamesCombo").val() === '0'){
			driverSelected = false;
		 }
		 var driverName = "";
		 var employeeId = "";
		 var trainingRemarks = "NA";
		 var periodScore = 0;
		if(driverSelected){
			$.ajax({
				url: "<%=request.getContextPath()%>/tripDashBoardAction.do?param=getParticularDriverDetails",
				"dataSrc": "driverDetailsRoot",
				"data": params,
				success: function(result) {
					result = JSON.parse(result);
					driverName = result[0].drivername;
					globalHubName = result[0].hubname;
					employeeId = result[0].employeeid;
					//trainingRemarks = result[0].trainingremarks;
					periodScore = result[0].periodScore;
					globalDriverName = driverName+' ('+employeeId+')';
					globalHubId = result[0].hubId;
					
					setTimeout(function(){
						$("#driverNameId").html(driverName+' ('+employeeId+')');
						$("#periodScoreId").html(periodScore);
						$("#hubNameId").html(globalHubName);
						$("#periodId").html(startDate +' - '+endDate);
						
					},1000)
				}
			});
			$("#driverDetailsId").show();
		}else{
			$("#driverDetailsId").hide();
		}
						
		$.ajax({
			url: "<%=request.getContextPath()%>/tripDashBoardAction.do?param=getOverallScore",
			"dataSrc": "overallRoot",
			"data": params,
			success: function(result) {
				results = JSON.parse(result);
				$("#presentScore").text(results["overallRoot"][0].presentScore);
				$("#pastScore").text(results["overallRoot"][0].pastScore);
				if(Number(results["overallRoot"][0].percScore) < 0){
					$('.percentageWell').css('background','#D40511');
				}else{
					$('.percentageWell').css('background','#5cb85c');
				}
				$("#percId").text(results["overallRoot"][0].percScore);
				$("#overallScore").text(results["overallRoot"][0].overallScore);
			}
		});

		$.ajax({
			url: "<%=request.getContextPath()%>/tripDashBoardAction.do?param=getPerformanceDetails",
			"dataSrc": "performanceRoot",
			"data" : params,
			success: function(result) {
				results = JSON.parse(result);
				firstLow=(results["performanceRoot"][0].firstLow).split('=');
				secondLow=(results["performanceRoot"][0].secondLow).split('=');
				firstHigh=(results["performanceRoot"][0].firstHigh).split('=');
				secondHigh=(results["performanceRoot"][0].secondHigh).split('=');

				$("#description3").text(firstLow[0]);
				$("#description4").text(secondLow[0]);
				$("#description1").text(firstHigh[0]);
				$("#description2").text(secondHigh[0]);
				var prameter ="";
				if(firstLow[0] !== "NA" && secondLow[0] !== "NA"){
					if(firstLow[0] === "Harsh-Acceleration" || firstLow[0] === "Hrash-Braking" || firstLow[0] === "Harsh-Curving"
						|| secondLow[0] === "Harsh-Acceleration" || secondLow[0] === "Hrash-Braking" || secondLow[0] === "Harsh-Curving"){
						prameter = "Harsh Driving";
					}
					if(firstLow[0] === "Over-Revving" || firstLow[0] === "Green-Band-RPM" || firstLow[0] === "Low-RPM"
						|| firstLow[0] === "High-RPM" || secondLow[0] === "Over-Revving" || secondLow[0] === "Green-Band-RPM" 
						|| secondLow[0] === "Low-RPM" || secondLow[0] === "High-RPM"){
							
						prameter = prameter === "" ? "Engine RPM Handling" : prameter+" & Engine RPM Handling";
					}
					if(firstLow[0] === "OverSpeed" || firstLow[0] === "Idle" || firstLow[0] === "Unscheduled-Stoppage"
						|| firstLow[0] === "Green-Band-Speed" || secondLow[0] === "OverSpeed" || secondLow[0] === "Idle" 
						|| secondLow[0] === "Unscheduled-Stoppage" || secondLow[0] === "Green-Band-Speed"){
						prameter = prameter === "" ? "Vehicle Speed Consistency" : prameter+" & Vehicle Speed Consistency";
					}
					
					trainingRemarks = "Need to focus on "+prameter;
				}
				$("#trainingRemarksId").html(trainingRemarks);
			}
		});
		google.charts.load('current', {
			'packages': ['line', 'corechart', 'bar']
		});
		google.charts.setOnLoadCallback(drawChart);

        toptable = $('#top5DriverTableId').DataTable({
            "ajax": {
                "url": "<%=request.getContextPath()%>/tripDashBoardAction.do?param=getTopOrBottomDriverDetails",
                "dataSrc": "top3Data",
                "data": {
                    startDate: startDate,
                    endDate:endDate,
					driverId : $("#driverNamesCombo").val(),
					hubList : $("#hubNamesCombo").val().toString(),
					order : 'desc'
                }
            },
            "oLanguage": {
                "sEmptyTable": "No data available"
            },
            "bDestroy": true,
            "responsive": true,
            //"dom": 'Bfrtip',
            "buttons": [
                {
                    extend: 'excel',
                    text: 'Export to Excel',
	      	 		className: 'btn btn-primary',
                    title:'Top 3 Drivers',
                    exportOptions: {
                        columns: [0, 1, 2, 3, 4]
                    }
                }
            ],
             columnDefs: [
            		{ width: 10, targets: 0 },
		            { width: 170, targets: 1 },
		            { width: 50, targets: 2 },
		            { width: 50,  targets: 3 },
		            { width: 50, targets: 4 }
		        ],
            "columns": [{
                "data": "rank"
            }, {
                "data": "driverName"
            }, {
                "data": "periodScore"
            }, {
                "data": "overallScore"
            }, {
                "data": "overallRank"
            }]
        });
		
		bottomtable = $('#bottom5DriverTableId').DataTable({
            "ajax": {
                "url": "<%=request.getContextPath()%>/tripDashBoardAction.do?param=getTopOrBottomDriverDetails",
                "dataSrc": "top3Data",
                "data": {
                    startDate: startDate,
                    endDate:endDate,
					driverId : $("#driverNamesCombo").val(),
					hubList : $("#hubNamesCombo").val().toString(),
					order : 'asc'
                }
            },
            "oLanguage": {
                "sEmptyTable": "No data available"
            },
            "bDestroy": true,
            "responsive": true,
            //"dom": 'Bfrtip',
            "buttons": [
                {
                    extend: 'excel',
                    text: 'Export to Excel',
	      	 		className: 'btn btn-primary',
                    title:'Top 3 Drivers',
                    exportOptions: {
                        columns: [0, 1, 2, 3, 4]
                    }
                }
            ],
             columnDefs: [
            		{ width: 30, targets: 0 },
		            { width: 200, targets: 1 },
		            { width: 50, targets: 2 },
		            { width: 50, targets: 3 },
		            { width: 50, targets: 4 }
		        ],
            "columns": [{
                "data": "rank"
            }, {
                "data": "driverName"
            }, {
                "data": "periodScore"
            }, {
                "data": "overallScore"
            }, {
                "data": "overallRank"
            }]
        });
		
        summaryTable = $('#summaryTable').DataTable({
            "ajax": {
                "url": "<%=request.getContextPath()%>/tripDashBoardAction.do?param=getDriverSummaryData",
                "dataSrc": "driverSummaryDataRoot",
                "data": params
            },
            "oLanguage": {
                "sEmptyTable": "No data available"
            },
            "bDestroy": true,
            "responsive": true,
	        	"dom": 'Bfrtip',
        	 	"buttons": [{extend:'pageLength'},
        	 				{extend:'excel',
        	 				text: 'Export to Excel',
	      	 				className: 'btn btn-primary',
        	 				exportOptions: {
				                columns: [0,1,2,3,4,5]
				            }},{
                    extend: 'pdf',
                    text: 'Export to PDF',
	      	 		className: 'btn btn-primary',
                    exportOptions: {
                        columns: [0, 1, 2, 3, 4,5]
                    }
                }
        	 				],
            columnDefs: [
            		{ width: 30, targets: 0 },
		            { width: 50, targets: 1 },
		            { width: 200, targets: 2 },
		            { width: 50,  targets: 3 },
		            { width: 50, targets: 4 },
		            { width: 50, targets: 5 },
		            { width: 50, targets: 6 }
		        ],
            "columns": [{
                "data": "slNoIndex"
            }, {
                "data": "empIdIndex"
            }, {
                "data": "nameIndex"
            }, {
                "data": "safetyScoreIndex"
            }, {
                "data": "performanceScoreIndex"
            }, {
                "data": "economyScoreIndex"
            }, {
                "data": "totalScoreIndex",
                //"visible":false
            }, {
                "data": "driverId",
                 "visible":false
            },{
            	"data": "mileageIndex",
            	"visible" : false
            }]
        });
        $('#summaryTable tbody').on('dblclick', 'td', function() {
       	    var data = summaryTable.row(this).data();
            var columnIndex = summaryTable.cell(this).index().column;
            driverId = (data['driverId']);
            mileage=  (data['mileageIndex']);
            driverName=  (data['nameIndex']);
            otp=  data['totalScoreIndex']*10;
            empId=  (data['empIdIndex']);
            //loadColumnChart(driverId,mileage,driverName,otp,empId);
        });
        maintable = $('#mainTable').DataTable({
            "ajax": {
                "url": "<%=request.getContextPath()%>/tripDashBoardAction.do?param=getDriverPerformanceData",
                "dataSrc": "driverPerformanceRoot",
                "data": params
            },
            "oLanguage": {
                "sEmptyTable": "No data available"
            },
            "bDestroy": true,
            "responsive": true,
	        	"dom": 'Bfrtip',
        	 	"buttons": [{extend:'pageLength'},
        	 				{extend:'excel',
        	 				text: 'Export to Excel',
	      	 				className: 'btn btn-primary',
        	 				exportOptions: {
				                columns: ':visible' //[0,1,2,3,4,5,6,8,9,10,11,12,13,14,15,16,17,19,20,21,22]
				            }}
        	 				],columnDefs: [
            		{ width: 30, targets: 0 },
		            { width: 50, targets: 1 },
		            { width: 200, targets: 2 },
		            { width: 50,  targets: 3 },
		            { width: 50, targets: 4 },
		            { width: 50, targets: 5 },
		            { width: 50, targets: 6 },
		            { width: 50, targets: 7 },
		            { width: 50, targets: 8 },
		            { width: 50, targets: 9 },
		            { width: 50, targets: 10 },
		            { width: 50, targets: 11 },
		            { width: 50, targets: 12 },
		            { width: 50, targets: 13 },
		            { width: 50, targets: 14 },
		            { width: 50, targets: 15 },
		            { width: 50, targets: 16 },
		            { width: 50, targets: 17 },
		            { width: 50, targets: 18 },
		            { width: 50, targets: 19 },
		            { width: 50, targets: 20 },
		            { width: 50, targets: 21 },
		            { width: 50, targets: 22 },
		        ],
            "columns": [{
                "data": "slNoIndex"
            }, {
                "data": "empIdIndex"
            }, {
                "data": "nameIndex"
            }, {
                "data": "totalScoreIndex"
            }, {
                "data": "NoofTripsIndex"
            }, {
                "data": "totalKmsIndex"
            }, {
                "data": "totalTimeIndex"
            }, {
                "data": "overallPerIndex",
                "visible":false
            }, {
                "data": "avgMilageIndex"
            }, {
                "data": "avgOBDMileageIndex"
            }, {
                "data": "avgSpeedIndex"
            }, {
                "data": "harshAccIndex"
            }, {
                "data": "harshBrakingIndex"
            }, {
                "data": "harshCorneringIndex"
            }, {
                "data": "overspeedingIndex"
            }, {
                "data": "freewheelingIndex"
            }, {
                "data": "unscheduledStoppageIndex"
            }, {
                "data": "excessiveIdlingIndex"
            }, {
                "data": "greenBandSpeedIndex"
            }, {
                "data": "erraticSpeedingIndex",
                "visible":false
            }, {
                "data": "greenBandRpmIndex"
            }, {
                "data": "lowRPMIndex"
            }, {
                "data": "highRPMIndex"
            }, {
                "data": "overRevvingIndex"
            }, {
                "data": "driverIdIndex",
                 "visible":false
            },{
             	"data":"otpScoreIndex",
             	"visible":false
            }]
        });
        jQuery('.dataTable').wrap('<div class="dataTables_scroll" />');
        $('#mainTable tbody').on('dblclick', 'td', function() {
       	    var data = maintable.row(this).data();
            var columnIndex = maintable.cell(this).index().column;
            driverId = (data['driverIdIndex']);
            mileage=  (data['avgMilageIndex']);
            obdMileage=(data['avgOBDMileageIndex']);
            driverName=  (data['nameIndex']);
            otp=  data['otpScoreIndex'];
            empId=  (data['empIdIndex']);
            loadColumnChart(driverId,mileage,driverName,otp,empId,obdMileage);
        });

        detailedTable = $('#detailedTable').DataTable({
            "ajax": {
                "url": "<%=request.getContextPath()%>/tripDashBoardAction.do?param=getDriverPerformanceCount",
                "dataSrc": "driverPerformanceCountRoot",
                "data": params
            },
            "oLanguage": {
                "sEmptyTable": "No data available"
            },
            "bDestroy": true,
            "responsive": true,
            "dom": 'Bfrtip',
            "buttons": [{extend:'pageLength'},
                        {extend:'excel',
                        text: 'Export to Excel',
	      	 			className: 'btn btn-primary',
                        exportOptions: {
                            columns: ':visible'
                        }}
                        ],

            "columns": [{
                "data": "slNoIndex",
                "orderable": true,
                "defaultContent": '',
                "className": 'details-control'
            }, {
                "data": "empIdCIndex"
            }, {
                "data": "nameCIndex"
            }, {
                "data": "NoofTripsCIndex"
            }, {
                "data": "harshAccCountIndex"
            }, {
                "data": "harshBrakingCountIndex"
            }, {
                "data": "harshCorneringCountIndex"
            }, {
                "data": "overspeedingCountIndex"
            }, {
                "data": "freewheelingCountIndex"
            }, {
                "data": "unscheduledStoppageCountIndex"
            }, {
                "data": "excessiveIdlingCountIndex"
            }, {
                "data": "greenBandSpeedCountIndex"
            }, {
                "data": "erraticSpeedingCountIndex",
                "visible":false
            }, {
                "data": "greenBandRpmCountIndex"
            }, {
                "data": "lowRPMCountIndex"
            }, {
                "data": "highRPMCountIndex"
            }, {
                "data": "overRevvingCountIndex"
            }, {
                "data": "driverIdCountIndex",
                 "visible":false
            }, {
                "data": "mileageCountIndex",
            }, {
                "data": "obdMileageCountIndex"
            }],
            "order": [[0, 'asc']]
        });

        jQuery('.dataTable').wrap('<div class="dataTables_scroll" />');
        $('#detailedTable').find('tbody').off('click', 'td.details-control');
        $('#detailedTable tbody').on('click', 'td.details-control', function () {
           var tr = $(this).closest('tr');
           var row = detailedTable.row( tr );
           if ( row.child.isShown() ) {
               tr.removeClass( 'details' );
               row.child.hide();
               tr.removeClass('shown');
           }else {
               tr.addClass( 'details' );
               row.child( format(row.data()) ).show();
               tr.addClass('shown');
           }
       });
       
       scoreValueTable = $('#scoreValueTable').DataTable({
            "ajax": {
                "url": "<%=request.getContextPath()%>/tripDashBoardAction.do?param=getDriverScoreValueData",
                "dataSrc": "driverPerformanceRoot",
                "data": params
            },
            "oLanguage": {
                "sEmptyTable": "No data available"
            },
            "bDestroy": true,
            "responsive": true,
	        	"dom": 'Bfrtip',
        	 	"buttons": [{extend:'pageLength'},
        	 				{extend:'excel',
        	 				text: 'Export to Excel',
        	 				header: true,
        	 				title: 'Driver Performance Score-Value ',
	      	 				className: 'btn btn-primary',
        	 				exportOptions: {
				                columns: ':visible' //[0,1,2,3,4,5,6,8,9,10,11,12,13,14,15,16,17,19,20,21,22]
				            }}
        	 				],columnDefs: [
            		{ width: 30, targets: 0 },
		            { width: 50, targets: 1 },
		            { width: 200, targets: 2 },
		            { width: 50,  targets: 3 },
		            { width: 50, targets: 4 },
		            { width: 50, targets: 5 },
		            { width: 50, targets: 6 },
		            { width: 50, targets: 7 },
		            { width: 50, targets: 8 },
		            { width: 50, targets: 9 },
		            { width: 50, targets: 10 },
		            { width: 50, targets: 11 },
		            { width: 50, targets: 12 },
		            { width: 50, targets: 13 },
		            { width: 50, targets: 14 },
		            { width: 50, targets: 15 },
		            { width: 50, targets: 16 },
		            { width: 50, targets: 17 },
		            { width: 50, targets: 18 },
		            { width: 50, targets: 19 },
		            { width: 50, targets: 20 },
		            { width: 50, targets: 21 },
		            { width: 50, targets: 22 },
		        ],
            "columns": [{
                "data": "slNoIndex"
            }, {
                "data": "empIdIndex"
            }, {
                "data": "nameIndex"
            }, {
                "data": "totalScoreIndex"
            }, {
                "data": "NoofTripsIndex"
            }, {
                "data": "totalKmsIndex"
            }, {
                "data": "totalTimeIndex"
            }, {
                "data": "overallPerIndex",
                "visible":false
            }, {
                "data": "avgMilageIndex"
            }, {
                "data": "avgOBDMileageIndex"
            }, {
                "data": "avgSpeedIndex"
            }, {
                "data": "harshAccIndex"
            }, {
                "data": "harshBrakingIndex"
            }, {
                "data": "harshCorneringIndex"
            }, {
                "data": "overspeedingIndex"
            }, {
                "data": "freewheelingIndex"
            }, {
                "data": "unscheduledStoppageIndex"
            }, {
                "data": "excessiveIdlingIndex"
            }, {
                "data": "greenBandSpeedIndex"
            }, 
<!--            {-->
<!--                "data": "erraticSpeedingIndex",-->
<!--                "visible":false-->
<!--            },-->
             {
                "data": "greenBandRpmIndex"
            }, {
                "data": "lowRPMIndex"
            }, {
                "data": "highRPMIndex"
            }, {
                "data": "overRevvingIndex"
            }, {
                "data": "harshAccCountIndex"
            }, {
                "data": "harshBrakingCountIndex"
            }, {
                "data": "harshCorneringCountIndex"
            }, {
                "data": "overspeedingCountIndex"
            }, {
                "data": "freewheelingCountIndex"
            }, {
                "data": "unscheduledStoppageCountIndex"
            }, {
                "data": "excessiveIdlingCountIndex"
            }, {
                "data": "greenBandSpeedCountIndex"
            }, 
<!--            {-->
<!--                "data": "erraticSpeedingCountIndex",-->
<!--                "visible":false-->
<!--            },-->
             {
                "data": "greenBandRpmCountIndex"
            }, {
                "data": "lowRPMCountIndex"
            }, {
                "data": "highRPMCountIndex"
            }, {
                "data": "overRevvingCountIndex"
            },{
                "data": "driverIdIndex",
                 "visible":false
            },{
             	"data":"otpScoreIndex",
             	"visible":false
            }]
        });
        jQuery('.dataTable').wrap('<div class="dataTables_scroll" />');
		
		$("#loading-div").hide();
		$("#loading-divInitial").hide();
    }
    
    function loadColumnChart(driverId,mileage,driverName,otp,empId) {
        $('#add').modal('show');
        $("#MileageId").text(mileage);
       $("#OBDMileageId").text(obdMileage);
        $("#drivernameId").text(startDate);
        $("#drivernameId1").text(endDate);
        $("#otpId").text(otp+' %');
        google.charts.load("current", {
            packages: ['corechart']
        });
        google.charts.setOnLoadCallback(drawChart);

        function drawChart() {
        $.ajax({
                url: '<%=request.getContextPath()%>/tripDashBoardAction.do?param=getColumnChartDetails',
                data: {
                   	startDate: startDate,
                    endDate:endDate,
                    driverId: driverId
                },
                success: function(response) {
                    var jsonList = JSON.parse(response);

	 				var data = google.visualization.arrayToDataTable([
	                ['Parameter', 'Score','Minimum','Average','Maximum'],
	                ['Harsh Acceleration ', Number(jsonList["columnRoot"][0].ha),Number(jsonList["columnRoot"][0].min_ha),Number(jsonList["columnRoot"][0].avg_ha),Number(jsonList["columnRoot"][0].max_ha)],
					['Harsh Braking', Number(jsonList["columnRoot"][0].hb),Number(jsonList["columnRoot"][0].min_hb),Number(jsonList["columnRoot"][0].avg_hb),Number(jsonList["columnRoot"][0].max_hb)],
					['Harsh Cornering', Number(jsonList["columnRoot"][0].hc),Number(jsonList["columnRoot"][0].min_hc),Number(jsonList["columnRoot"][0].avg_hc),Number(jsonList["columnRoot"][0].max_hc)],
					['Overspeeding', Number(jsonList["columnRoot"][0].overspeed),Number(jsonList["columnRoot"][0].min_overspeed),Number(jsonList["columnRoot"][0].avg_overspeed),Number(jsonList["columnRoot"][0].max_overspeed)],
					['Freewheeling Time', Number(jsonList["columnRoot"][0].freeWwheeling),Number(jsonList["columnRoot"][0].min_freeWwheeling),Number(jsonList["columnRoot"][0].avg_freeWwheeling),Number(jsonList["columnRoot"][0].max_freeWwheeling)],
					['UnScheduled Stop.', Number(jsonList["columnRoot"][0].unscheduledStoppage),Number(jsonList["columnRoot"][0].min_unscheduledStoppage),Number(jsonList["columnRoot"][0].avg_unscheduledStoppage),Number(jsonList["columnRoot"][0].max_unscheduledStoppage)],
					['Excessive Idling', Number(jsonList["columnRoot"][0].idle),Number(jsonList["columnRoot"][0].min_idle),Number(jsonList["columnRoot"][0].avg_idle),Number(jsonList["columnRoot"][0].max_idle)],
					['Green band speed', Number(jsonList["columnRoot"][0].greenBand),Number(jsonList["columnRoot"][0].min_greenBand),Number(jsonList["columnRoot"][0].avg_greenBand),Number(jsonList["columnRoot"][0].max_greenBand)],
					//['Erratic Speeding', Number(jsonList["columnRoot"][0].erratic)],
					['Green Band RPM', Number(jsonList["columnRoot"][0].greenbandrpm),Number(jsonList["columnRoot"][0].min_greenbandrpm),Number(jsonList["columnRoot"][0].avg_greenbandrpm),Number(jsonList["columnRoot"][0].max_greenbandrpm)],
					['Low RPM', Number(jsonList["columnRoot"][0].lowrpm),Number(jsonList["columnRoot"][0].min_lowrpm),Number(jsonList["columnRoot"][0].avg_lowrpm),Number(jsonList["columnRoot"][0].max_lowrpm)],
					['High RPM', Number(jsonList["columnRoot"][0].highrpm),Number(jsonList["columnRoot"][0].min_highrpm),Number(jsonList["columnRoot"][0].avg_highrpm),Number(jsonList["columnRoot"][0].max_highrpm)],
					['Over-Revving', Number(jsonList["columnRoot"][0].overRevv),Number(jsonList["columnRoot"][0].min_overRevv),Number(jsonList["columnRoot"][0].avg_overRevv),Number(jsonList["columnRoot"][0].max_overRevv)]
	            ]);
	            var options = {
	                title: 'Score For '+driverName+' ('+empId+')' ,
	                width: 1150,
	                height: 450,
	                hAxis: {
	                    color: '#1b9e77',
	                    slantedText: true
	                },
	                vAxis: {
	                    title: 'Driver Score',
	                    titleTextStyle: {
	                        color: 'black'
	                    }
	                },
	                seriesType: 'bars',
	                series: {1: {type: 'line'},2: {type: 'line'},3: {type: 'line'}}
	            };
	            var chart = new google.visualization.ComboChart(document.getElementById('chart_div'));
	            chart.draw(data, options);
                }
            });
        }
    }

    function checkMonthValidation(date1, date2) {
     var dd = date1.split("/");
     var ed = date2.split("/");
     var startDate = new Date(dd[1] + "/" + dd[0] + "/" + dd[2]);
     var endDate = new Date(ed[1] + "/" + ed[0] + "/" + ed[2]);
     var timeDiff = Math.abs(endDate.getTime() - startDate.getTime());
     var daysDiff = Math.ceil(timeDiff / (1000 * 3600 * 24));
     if (daysDiff <= 30) {
         return true;
     } else {
         return false;
     }
  }
  
  function viewTrainingRemark(){
    $("#viewRemarkModal").modal("show");
    $.ajax({
        url: '<%=request.getContextPath()%>/tripDashBoardAction.do?param=fetchTrainingRemarksDetails',
        "data": {
            driverId: $("#driverNamesCombo").val()
        },
        contentType: 'application/json',
        success: function(result) {
            let rows = [];
            var data = JSON.parse(result);
            $.each(data.trainingRemarksDetailsRoot, function(i, item) {
                let row = {
                   "0": i + 1,
                    "1": item.driverName,
                    "2": item.hubName,
					"3": item.score,
                    "4": item.remarks,
                    "5": item.user,
                };
                rows.push(row);
            });

            setTimeout(function() {
                if ($.fn.DataTable.isDataTable("#viewRemarkTable")) {
                    $('#viewRemarkTable').DataTable().clear().destroy();
                }
                viewRemarkTable = $('#viewRemarkTable').DataTable({
                    "scrollY": "300px",
                    "scrollX": true,
                    "oLanguage": {
                        "sEmptyTable": "No data available"
                    },
                    dom: 'Bfrtip',
                    buttons: [{
                        extend: 'excel',
                        text: 'Export to Excel',
                        className: "btn btn-primary",
                        title: 'Remarks Excel'
                    }]
                });
                viewRemarkTable.rows.add(rows).draw();
            }, 500);
        }
    })
}

function enterRemark(){
	$("#enterRemarkTextId").val('');
	$('#enterRemarkModel').modal('show');
}
  function format ( d ) {
    var tbody="";
    if(d.legdetails.length>0)
    {
            for(var i=0;i<d.legdetails.length;i++)
            {
            var row="";
            row += '<tr>'
            	row += '<td>'+d.legdetails[i].slNo+'</td>';
                row += '<td>'+d.legdetails[i].legName+'</td>';
                row += '<td>'+d.legdetails[i].tripName+'</td>';
                row += '<td>'+d.legdetails[i].haCount+'</td>';
                row += '<td>'+d.legdetails[i].hbCount+'</td>';
                row += '<td>'+d.legdetails[i].hcCount+'</td>';
                row += '<td>'+d.legdetails[i].overspeedingCount+'</td>';
                row += '<td>'+d.legdetails[i].freewheelingCount+'</td>';
                row += '<td>'+d.legdetails[i].unscheduledStoppageCount+'</td>';
                row += '<td>'+d.legdetails[i].excessiveIdlingCount+'</td>';
                row += '<td>'+d.legdetails[i].greenBandSpeedCount+'</td>';
                row += '<td>'+d.legdetails[i].erraticSpeedingCount+'</td>';
                row += '<td>'+d.legdetails[i].greenBandRpmCount+'</td>';
                row += '<td>'+d.legdetails[i].lowRPMCount+'</td>';
                row += '<td>'+d.legdetails[i].highRPMCount+'</td>';
                row += '<td>'+d.legdetails[i].overRevvingCount+'</td>';
                row += '<td>'+d.legdetails[i].mileage+'</td>';
                row += '<td>'+d.legdetails[i].obdMileage+'</td>';

                row += '</tr>';
                tbody+=row;
            }
            a = '<div style="overflow-x:auto;width:100%">'+
                '<table class="table table-bordered" >'+
                '<thead>'+
                '<tr>'+
                '<th>#</th>'+
                '<th>Leg Name</th>'+
                '<th>Trip Name</th>'+
                '<th>Harsh Acceleration (per Hr)</th>'+
                '<th>Harsh Braking (per Hr)</th>'+
                '<th>Harsh Cornering (per Hr)</th>'+
                '<th>Overspeeding (per Hr)</th>'+
                '<th>Total Freewheeling Time (%Time)</th>'+
                '<th>Unscheduled Stoppage Time (%Time)</th>'+
                '<th>Excessive Idling Time (%Time)</th>'+
                '<th>Green Band Speed (%Time)</th>'+
                '<th>Erratic Speeding (%Time)</th>'+
                '<th>Green Band RPM (%Time)</th>'+
                '<th>Low RPM (%Time)</th>'+
                '<th>High RPM (%Time)</th>'+
                '<th>Over-Revving</th>'+
                '<th>LLS Mileage KMPL</th>'+
                '<th>OBD Mileage KMPL</th>'+
                '</tr>'+
                '</thead>' +
                '<tbody id="tbodyId">'+tbody+'</tbody>'+
            '</table>'+
            '</div>';
   }
   else
   {
            var row="";
            row += '<tr>';
                row += '<td colspan="16">No data found</td>';
                row += '<td></td>';
                row += '<td></td>';
                row += '<td></td>';
                row += '<td></td>';
                row += '<td></td>';
                row += '<td></td>';
                row += '<td></td>';
                row += '<td></td>';
                row += '<td></td>';
                row += '<td></td>';
                row += '<td></td>';
                row += '<td></td>';
                row += '<td></td>';
                row += '<td></td>';
                row += '</tr>';
                tbody+=row;

        a = '<div style="overflow-x:auto;width:100%">'+
        '<table  cellpadding="5" cellspacing="0" border="0">'+
        ' <thead>'+
        '</thead>'+
        '<tbody id="tbodyId">'+tbody+'</tbody>'+
    '</table>'+
    '</div>';
   }
   return a;
}

	$('#legbtn').click(function() {
		document.getElementById("page-loader").style.display="block";
		$.ajax({
			url : '<%=request.getContextPath()%>/LegDetailsExportAction.do?param=createDriverPerformanceLegWiseExcel',
			//type:"POST",
			data :  {
                startDate: startDate,
                endDate:endDate,
				driverId : $("#driverNamesCombo").val(),
				hubList : $("#hubNamesCombo").val().toString()
            },
			success : function(responseText) {
				//$('#ajaxGetUserServletResponse').text(responseText);
				
				window.open("<%=request.getContextPath()%>/LegDetailsExport?relativePath="+responseText);
				//window.open("/LegDetailsExport?relativePath="+responseText);
				document.getElementById("page-loader").style.display="none";
			}
			
		});
		
	});
	
	$('#legReportForDriverScorebtn').click(function() {
        document.getElementById("page-loader").style.display="block";
		$.ajax({
			url : '<%=request.getContextPath()%>/LegDetailsExportAction.do?param=createLegReportForDriverScoreExcel',
			//type:"POST",
			data :  {
				startDate: startDate,
				endDate:endDate,
				driverId : $("#driverNamesCombo").val(),
				hubList : $("#hubNamesCombo").val().toString()
            },
			success : function(responseText) {
				window.open("<%=request.getContextPath()%>/LegDetailsExport?relativePath="+responseText);
				document.getElementById("page-loader").style.display="none";
			}
			
		});
		
	});
	

</script>

</script>
<jsp:include page="../Common/footer.jsp" />
