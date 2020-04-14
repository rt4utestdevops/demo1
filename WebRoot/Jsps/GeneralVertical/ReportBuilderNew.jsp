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
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css" integrity="sha384-Gn5384xqQ1aoWXA+058RXPxPg6fy4IWvTNh0E263XmFcJlSAwiGgFAW/dAiS6JXm" crossorigin="anonymous">
     <link href='https://fonts.googleapis.com/css?family=Orbitron' rel='stylesheet' type='text/css'>
 	<link href="https://fonts.googleapis.com/css?family=Lato" rel="stylesheet">
     <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
     <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.9/umd/popper.min.js"></script>
     <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js"></script>
<jsp:include page="../Common/header.jsp" />
<script>$(document).prop('title', 'Report Builder');</script>

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

 .btn-group{
    width: 100%;
}
 #vehDiv .btn-group .btn{
    width: 100%;
    background: white !important;
     border: 1px solid !important;
    height:33px;
}
 .multiselect-container {
     width: 100%;
}
 .multiselect-container .input-group {
     width:97% !important;

}
 .input-group-btn {
    display:none;
}

 .padRow {
     padding:10px;
}
.padTop10{
     padding-top:10px;
}
 .padTop20{
     padding-top:20px;
}
 .padTop25{
     padding-top:25px;
}
 .padTop30{
     padding-top:30px;
}
 .padTop40{
     padding-top:40px;
}
 .btn-generate{
     background: #18519E !important;
    border:none;
     margin-top: 30px;
}
.form-control-custom {
    border: none;
    z-index: 100;
    border: 1px solid;
    height: 34px !important;
    padding: 0px 0px 0px 8px;
  }
  .form-control-custom:focus {
    border: none;
    border: 1px solid;
    box-shadow: none;
    -webkit-box-shadow: none;
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
 .form-label-group-select > label, .form-label-group > label , .form-label-group-axis >label{
     font-size: 14px;
     color: #777;
     padding-left:10px;
}
 .form-label-group input::-webkit-input-placeholder {
     color: transparent;
}
 .form-label-group input:-ms-input-placeholder {
     color: transparent;
}
 .form-label-group input::-ms-input-placeholder {
     color: transparent;
}
 .form-label-group input::-moz-placeholder {
     color: transparent;
}
 .form-label-group input::placeholder {
     color: transparent;
}
 .format{
     padding:0px 0px 10px 10px;
}

 .hrStyle{
    padding: 5px 5px 20px 20px;
     margin-bottom:20px;
     border-radius:1px;
    opacity:1;
     background: #337AB7;
    text-transform: uppercase;
    color:white;
    height:30px;
}

.row-center{
     display: flex;
     justify-content: center;
}
 .multiselect{
     margin-top: 0px;
     padding: 0px 0px 0px 8px;
}
 .input-error{
     font-size: 12px;
     color: #f26631;
}
 .multiselect{
     display: flex;
     flex-direction: column;
    ;
}

 .filter-card{
     border: none;
     box-shadow: 0 3px 1px -2px rgba(0,0,0,.2), 0 2px 2px 0 rgba(0,0,0,.14), 0 1px 5px 0 rgba(0,0,0,.12);
}
 .filter-header{
     background-color: #333;
     text-align: center;
}
 select option[disabled] {
     display: none;
}
 .center-view{
     flex: 1;
     align-items: center;
     justify-content: center;
}
 .check-lable{
     margin-bottom: 0;
     margin-left: 0.25rem;
}
.input-group-text{
  margin-top: 7px;
  padding: 0px 0px 0px 8px;
}
button[disabled]{
  cursor: not-allowed;
}


 .w3-card-4 {
box-shadow:0 4px 10px 0 rgba(0,0,0,0.2),0 4px 20px 0 rgba(0,0,0,0.19);
   margin:-16px -4px 0px -4px;
 padding-bottom: 8px;
 padding-left:8px;
padding-right:8px;}
 .container-fluid{padding:0px;}

 .padCols {
   padding-left:0px;
   padding-right:4px;
 }

 label {
    margin-bottom: 0.25em;
}
.navbar-brand {
    padding-bottom: 4px!important;
    margin-left: -4px !important;
}
button.dt-button {
  line-height: 1.1em;
}
.dt-buttons{float:right !important;}

#myBtn {
  display: none;
  position: fixed;
  bottom: 16px;
  right: 32px;
  z-index: 99;
  font-size: 18px;
  border: none;
  outline: none;
  background-color: #808080;
  color: white;
  cursor: pointer;
  padding: 15px;
  border-radius: 4px;
}

#myBtn:hover {
  background-color: #555;
}

.fixedLayout {table-layout: fixed !important;}

#report-table {
    border-collapse: collapse;
    width: 100%;
}

#report-table td, #report-table th {
    border: 1px solid #ddd;
    padding: 8px;
}

#reportTable_length{
    padding-left:10px;
}

table {
  margin-top:24px;

}

th {
  background: #808080;
  color: white !important;
  text-transform: uppercase;
  padding:8px;
  border: 1px solid #ddd;
}

 td.details-control {
     background: url('details_open.png') no-repeat 10% 50%;
     cursor: pointer;
}
 tr.shown td.details-control {
     background: url('details_close.png') no-repeat 10% 50%;
     cursor: pointer;
}

table td, table th {
  width: 2.5em;
}
table td+td, table th+th {
  width: auto;
}

table.dataTable thead th, table.dataTable thead td {
    padding: 8px 8px !important;
}

.filter-container{
    width: auto;
    height: 100%;
    position: fixed;
    right: 0;
    top: 56px;
    z-index: 20000;padding-bottom:56px;
}
.flex-row{
    display: flex;
    flex-direction: row
}
.flex-center{
  justify-content: center;
  align-items: center;
}
.filter-title{
    border-radius: 2px 0px 0px 2px;
    background-color: #333333;
    padding: 3px 7px;
    font-size: 16px;
    text-transform: uppercase;
    width: 70px;
    color: white;
    text-align: justify;
    text-align-last: center;
    height: fit-content;
    cursor: pointer;
}
.filter-view{
    background-color: #E0E0E0;
    padding: 8px;
    width: 400px;
    height: auto;
    margin-right: -400px;
    overflow-y:scroll;
    border:1px solid #333333;
}

body::-webkit-scrollbar-track,#report-filter-view::-webkit-scrollbar-track
{
	-webkit-box-shadow: inset 0 0 6px rgba(0,0,0,0.3);
	border-radius: 10px;
	background-color: #F5F5F5;
}

body::-webkit-scrollbar,#report-filter-view::-webkit-scrollbar
{
	width: 8px;
	background-color: #F5F5F5;
}

body::-webkit-scrollbar-thumb,#report-filter-view::-webkit-scrollbar-thumb
{
	border-radius: 10px;
	-webkit-box-shadow: inset 0 0 6px rgba(0,0,0,.3);
	background-color: #555;
}

.input-group{
  width: 58% !important;
float: right;
}

#report-filter-reset{
  margin-bottom: 24px;
  margin-right:24px;
  float:right;
  color:#dfdfdf;

}

#filterTitleBtnIcon{
  margin-bottom: 24px;
  margin-right:8px;
  float:right;
  color:#dfdfdf;
}
</style>


        <button onclick="topFunction()" id="myBtn" title="Go to top">Top</button>
        <div class="container-fluid" id="container-report-select">
          <form id="report-form" class="">
            <div class="w3-card-4">
              <div class="card-body" style="padding:1em !important">
                <div class="hrStyle text-center" style="margin:0px -24px 16px -24px;">REPORT PARAMETERS</div>
                <div class="row">
                  <div class="col-sm-2" style="padding-left: 8px;padding-right:4px;">
                    <label for="report-category">CATEGORY</label>
                    <select class="form-control form-control-custom" id="report-category" name="reportCategory" ></select>
                  </div>
                  <div class="col-sm-2 padCols">
                    <label for="report-types">REPORT</label>
                    <select class="form-control form-control-custom" id="report-types" name="reportTypes"></select>
                  </div>

                  <div class="col-sm-2 padCols">
                    <label for="report-start-date">START DATE</label>
                    <input type="text" style="padding:6px;" id="report-start-date" class="form-control form-control-custom" name="reportStartDate" >
                  </div>
                  <div class="col-sm-2 padCols">
                    <label for="report-end-date">END DATE</label>
                    <input type="text" style="padding:6px;" id="report-end-date" class="form-control form-control-custom" name="reportEndDate">
                  </div>
                  <div class="col-sm-4 padCols"><div class="row" id="row-criteria">
                    <div class="col-sm-12" id="criteria-vehicle">
                        <label class="radio-inline">
                          <input type="radio" id="vehRadio" checked onclick="handleTripVehRadioClick(value)" value="vehicles" name="optradio">&nbsp;&nbsp;&nbsp;VEHICLES
                        </label>
                        <label class="radio-inline" style="margin-left:24px;">
                          <input type="radio"  disabled id="tripRadio" onclick="handleTripVehRadioClick(value)" value="trip" name="optradio">&nbsp;&nbsp;&nbsp;<span style="color:#d8d8d8 !important">TRIP</span>
                        </label>
                      <div id="vehDiv">
                      <select class="form-control form-control-custom" id="select-criteria-vehicle" name="selectCriteriaVehicle" multiple></select>
                    </div>
                    <div id="tripDiv">
                      <select class="form-control form-control-custom dispNone" id="select-criteria-trip" name="selectCriteriaTrip" multiple></select>
</div>
                    </div>
                  </div></div>
                </div>
                <div class="row"><div class="col-sm-10">
                <div id="view-parameter" style="margin-top:8px;" class="dispNone">
                  <label for="row-parameter" style="margin-left:-4px;" id="error-parameters">GROUP BY</label>
                  <div class="row" id="row-parameter" style="padding:0px 2px 0px 8px;margin-top:-8px;">
                  </div>
                </div></div>
                <div class="col-sm-2">
                   <a class="card-link">
                     <button id="btn-report-submit" class="btn btn-generate btn-md btn-primary btn-block" style="background:#18519E;margin-top:32px;padding-bottom:10px;" type="submit">Generate Report</button>
                   </a>
				   
                </div>
              </div>
              </div>
            </div>
          </form>
        </div>
        <div class="w3-card-4 dispNone" id="w3Card" style="margin-top:8px;">
        <div class="container-fluid dispNone" id="view-report-table">
          <div class="hrStyle text-center" style="margin:0px -8px 16px -8px;" id="title-report"></div>
          <div class="row" style="padding:0px 16px 0px 16px;">
            <div class="col-sm-12 col-xs-12 col-md-4 col-lg-4">
              <strong>Parameter:&nbsp;&nbsp;</strong>
              <span id="tb-parameter"></span>
            </div>
            <div class="col-sm-12 col-xs-12 col-md-4 col-lg-4">
              <strong>Period:&nbsp;&nbsp;</strong>
              <span id="tb-period"></span>
            </div>
            
            <div class="col-sm-12 col-xs-12 col-md-4 col-lg-4" id="exportOptions">
			

<div class="dt-buttons"><div class="filter-title" id="filterTitleBtn">Filter</div></div>
<div class="dt-buttons" id="generateExcelId"   onclick="generateExcelNew('EXCEL')"> 
				<button class="dt-button buttons-excel buttons-html5" tabindex="0" aria-controls="report-table">
				<span>Excel</span>
				</button> 
			</div>
			<div class="dt-buttons" id="generatePDFId"  value="PDF"  onclick="generateExcelNew('PDF')">
                <button class="dt-button buttons-excel buttons-html5" tabindex="0" aria-controls="report-table">
                <span>PDF</span>
                </button>
            </div>
            </div>
          </div>
          <div class="table-responsive" id="divTable" style="padding:8px 14px 0px 14px;">
            <table id="report-table" class="display"  width="100%" cellspacing="0">
            </table>
            <div class='flex-row filter-container'>
            <div class="filter-view" id="report-filter-view">
                <div style="height:32px;background:#545B62;margin:-8px -8px 16px -8px;padding:8px 4px 4px 8px;opacity:0.8;color:#dfdfdf;">
                  FILTER
                  <i id="filterTitleBtnIcon" class="fas fa-times "></i>
                  <i id="report-filter-reset" class="fas fa-redo "></i>
            </div>
              <!--<div class="flex-row flex-center">
                <button type="button" class="btn btn-primary" id="report-filter-reset">Reset</button>
              </div>-->
              <div id="filter-elements"></div>

            </div>
          </div>
          </div>
        </div>
        </div>
        <div class="center-view dispNone" id="loading-report" style="margin-top:24px;">
          <img src="../../Main/images/loading.gif" alt="">
        </div>
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
      <script src="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.6-rc.0/js/select2.min.js"></script>
      <script src="https://use.fontawesome.com/releases/v5.0.9/js/all.js" integrity="sha384-8iPTk2s/jMVj81dnzb/iFR2sdA7u06vHJyyLlAd4snFpCl/SnyUjRrbdJsw1pGIl" crossorigin="anonymous"></script>
      <script>

        let categories;
        let vehicleTripLegList;
        let tableColumnsData;
        let filterColIndex;
        let filterType ;
        let tableCount = 0;
        let parameterType = "radio";
        let parameterInputName = parameterType == "radio" ? 'reportParameters' : 'reportParameters[]'
        let reportId;
		var gridData;

        window.onscroll = function() {scrollFunction();
        };
        function scrollFunction() {
            if (document.body.scrollTop > 20 || document.documentElement.scrollTop > 20) {
                document.getElementById("myBtn").style.display = "block";
            } else {
                document.getElementById("myBtn").style.display = "none";
            }
        }

        // When the user clicks on the button, scroll to the top of the document
        function topFunction() {
            document.body.scrollTop = 0;
            document.documentElement.scrollTop = 0;
        }

        function handleTripVehRadioClick(value)
        {
          if(value == "vehicles"){
            $("#vehDiv").show();
            $("#tripDiv").hide();
            createMultiselect("vehicles");
          }
          else {
            $("#vehDiv").hide();
            $("#tripDiv").show();
            createMultiselect("trips");
          }
        }
        $(document).ready(function() {
          $("#footSpan").html("&copy; " + (new Date()).getFullYear() + " telematics4u");
          $("#dateDisplay").html(new Date($.now()));
          $.ajax({
            url: '<%=request.getContextPath()%>/ReportBuilderAction.do?param=getReportMaster',
            type: 'GET',
            async: false,
            dataType: 'json',
            context: document.body,
            beforeSend: function () {
              loading(true);
            },
            success:function(resultData){
              categories = resultData.reportJanon;
              showcategory();
            },
            error: function (xhr, status, error) {

            }
          });
          $.ajax({
            url: '<%=request.getContextPath()%>/ReportBuilderAction.do?param=getVehicleNo',
            type: 'GET',
            async: false,
            dataType: 'json',
            context: document.body,
            beforeSend: function () {

            },
            success:function(resultData){
              vehicleTripLegList = resultData;
              //createMultiselect();
            },
            error: function (xhr, status, error) {

            }
          });
          $.validator.addMethod("needsSelection", function(value, element) {
            return $(element).find('option:selected').length > 0;
          }, "atleast Select one");
          $('#report-form').validate({
            rules:{
              reportCategory:{
                required: true,
              },
              reportTypes:{
                required: true,
              },
              reportStartDate:{
                required:true,
              },
              reportEndDate:{
                required: true,
              },
              reportParameters:{
                required:true,
              }
            },
            errorPlacement: function(error, element) {
              error.addClass('input-error');
              if (element.attr('name') == 'reportParameters') {
                error.appendTo($('#error-parameters'));
              } else {
                error.insertAfter(element);
              }
           }
          });
          $('#report-form').submit(function (event) {
            event.preventDefault();
            if (!$('#report-form').valid()) {
                event.stopPropagation();
                return;
            }
            let categoryId = $('#report-category').val();
            let category = categories.find(category => category.categoryId == categoryId);
            let criteria = category.enabledSearchCriteria;
            let vehicles = $('#select-criteria-vehicle')
            let trips = $('#select-criteria-trip');
            if (criteria == 'All' && (vehicles.val().length == 0 && trips.val().length == 0)) {
              if (vehicles.val().length == 0) {
                addErrorLabel(vehicles);
              }
              if (trips.val().length == 0) {
                addErrorLabel(trips);
              }
              return;
            } else if (criteria == 'Vehicle' && vehicles.val().length == 0) {
              if (vehicles.val().length == 0) {
                addErrorLabel(vehicles);
              }
              return;
            } else if (criteria == 'Trip' && (trips.val().length == 0)) {
              if (trips.val().length == 0) {
                addErrorLabel(trips);
              }
              return;
            }
            $('#btn-report-submit').prop('disabled', true);
            loading(true);
            $('#view-report-table').removeClass().addClass('dispNone');
            $('#w3Card').addClass('dispNone');
            let parameters = [];
            let selectedParameter = $("input[type='radio'][name='reportParameters']:checked");
            parameters.push(selectedParameter.val());
            let reportInput = {
              reportId : $('#report-types').val(),
              parameterSelected: parameters.toString(),
              startDate: $('#report-start-date').val(),
              endDate: $('#report-end-date').val(),
              vehicles: vehicles.val().toString(),
              trips: trips.val().toString(),
            } /*<%=request.getContextPath()%>/ReportBuilderAction.do?param=generateReport*/
            $.ajax({
                url: '<%=request.getContextPath()%>/ReportBuilderAction.do?param=generateReport',
                type : 'GET',
                data: reportInput,
                async: false,
                dataType: "json",
                timeout: 0,
                beforeSend: function () {
                },
                success: function(tableData) {
					gridData=tableData;
                      createTable(tableData, reportInput)
					   document.getElementById("generateExcelId").style.display = "block";
                },
                error: function (xhr, status, error) {
                  console.log(xhr, status, error);
                }
            });
          })
          $('#filterTitleBtn').click(function (e) {
              if ($('#report-filter-view').css('margin-right') == '-400px')
              {
              $('#report-filter-view').css('margin-right', '0px');
            } else {
              $('#report-filter-view').toggle();}
            })
            $('#filterTitleBtnIcon').click(function (e) {
                  $('#report-filter-view').toggle();
              })
        });
        $.fn.dataTable.ext.search.push(
  function (settings, data, dataIndex) {
    let regexTime = /^[0-9]{2}|[0-9][:][0-9]{2}$/
    let regexKm = /^\d+(\.\d+)?$/
    let regexDDHHMM = /^([0-9]{2}|[0-9])[:]([0-9]{2}|[0-9])[:]([0-9]{2}|[0-9])$/
    let totalValid = 0
    for (let i = 0; i < tableColumnsData.length; i++) {
      let columnDetail = tableColumnsData[i][0]
      if (columnDetail.filter == 'TRUE') {
        let colFilterVal = null
        if (columnDetail.filterType == 'DateTime') {
          let date = $('#header-filter-'+ i).datetimepicker('date')
          colFilterVal = date != null ? date['_d'] : undefined
        } else {
          colFilterVal = $('#header-filter-'+ i).val()
        }
        let colDataVal = data[i + 1]
        if (colFilterVal == undefined || colFilterVal == '') {
          totalValid++
        } else {
          let op = $("input[type='radio'][name='headerFilterRadio"+ i + "']:checked").val()
          if (columnDetail.filterType == 'DD:HH:MM') {
            if (!regexDDHHMM.test(colFilterVal)) {
              totalValid++
            } else {
              let colFilFIndex = colFilterVal.indexOf(':')
              let colColFIndex = colDataVal.indexOf(':')
              let colFilLIndex = colFilterVal.lastIndexOf(':')
              let colColLIndex = colDataVal.lastIndexOf(':')
              let filterDD = parseInt(colFilterVal.substring(0, colFilFIndex))
              let filterHH = parseInt(colFilterVal.substring(colFilFIndex + 1, colFilLIndex))
              let filterMM = parseInt(colFilterVal.substring(colFilLIndex + 1, colFilLIndex + 3))
              let colDD = parseInt(colDataVal.substring(0, colColFIndex))
              let colHH = parseInt(colDataVal.substring(colColFIndex + 1, colColLIndex))
              let colMM = parseInt(colDataVal.substring(colColLIndex + 1, colColLIndex + 3))
              if (isNaN(filterHH) || isNaN(colHH) || isNaN(filterMM) || isNaN(colMM) || isNaN(filterDD) || isNaN(colDD)) {
                totalValid++
              } else {
                if (filterDD == colDD && filterHH == colHH && filterMM == colMM) {
                  totalValid++
                }
              }
            }
          } else if (columnDetail.filterType == 'Time') {
            if (!regexTime.test(colFilterVal)) {
              totalValid++
            } else {
              let colFilIndex = colFilterVal.indexOf(':')
              let colColIndex = colDataVal.indexOf(':')
              let filterHH = parseInt(colFilterVal.substring(0, colFilIndex))
              let colHH = parseInt(colDataVal.substring(0, colColIndex))
              let filterMM = parseInt(colFilterVal.substring(colFilIndex + 1, colColIndex + 3))
              let colMM = parseInt(colDataVal.substring(colColIndex + 1, colColIndex + 3))
              if (isNaN(filterHH) || isNaN(colHH) || isNaN(filterMM) || isNaN(colMM)) {
                totalValid++
              } else {
                if (op == 'less') { // less than
                  if (colHH < filterHH) {
                    totalValid++
                  } else if (colHH == filterHH && colMM < filterMM) {
                    totalValid++
                  }
                } else if (op == 'eq') { // equal to
                  if (colHH == filterHH && colMM == filterMM) {
                    totalValid++
                  }
                } else {
                  if (colHH > filterHH) {
                    totalValid++
                  } else if (colHH == filterHH && colMM > filterMM) {
                    totalValid++
                  }
                }
              }
            }
          } else if (columnDetail.filterType == 'Number') {
            if (!regexKm.test(colFilterVal)) {
              totalValid++
            }
            let fVal = parseFloat(colFilterVal)
            let calVal = parseFloat(colDataVal)
            if (op == 'less') { // less than
              calVal < fVal ? totalValid++ : ''
            } else if (op == 'eq') {
              calVal == fVal ? totalValid++ : ''
            } else { // greate than
              calVal > fVal ? totalValid++ : ''
            }
          } else if (columnDetail.filterType == 'DateTime') {
            let filterValDateTime = new Date(colFilterVal).getTime()
            let cValDateTime = new Date(colDataVal).getTime()
            if (!isNaN(filterValDateTime) && !isNaN(cValDateTime)) {
              if (op == 'less') { // less than
                cValDateTime < filterValDateTime ? totalValid++ : ''
              } else if (op == 'eq') {
                cValDateTime == filterValDateTime ? totalValid++ : ''
              } else { // greate than
                cValDateTime > filterValDateTime ? totalValid++ : ''
              }
            } else {
              totalValid++
            }
          } else if (columnDetail.filterType == 'Text') {
            if (colDataVal.indexOf(colFilterVal) !== -1) {
              totalValid++
            }
          }
        }
      }
    }
    let totalfilterFieds = tableColumnsData.filter((field, index) => {
      return field[0].filter == 'TRUE'
    }).length
    return totalfilterFieds == totalValid
  }
)
        function createTable(tableData, reportInput) {
          $("#tb-period").html('').html(reportInput.startDate + " to " + reportInput.endDate);
          $("#title-report").html('').html($("#report-types option:selected").text());
          $("#tb-parameter").html('').html($('input[name="reportParameters"]:checked').parent().find('label').text());
          let tableColumns = [{title: "SlNo"}];
          let childColumn = [{title: "SlNo"}]
          tableColumnsData = null
          if(tableData.tableReponsejson == null || tableData.tableReponsejson == "")
          {
          	
            tableColumns = [{}];
            childColumn = [{}]
            tableData.tableReponsejson = [{
            	"0":"No Data Available for this Selection"
            }];
            

          }

          let targets = [0];
          let childTargets = [0];
          let tableRows = [];
          let indexKey = 0;
          tableData = tableData.tableReponsejson;
          tableColumnsData = Object.values(tableData[0])
          for (let key in tableData[0]) {
            if (tableData[0].hasOwnProperty(key)) {
              if (key != "drillDownTable" ) {
                if (tableData[0][indexKey][0]['filter'] == "TRUE") {
                  filterColIndex = indexKey + 1;
                  filterType = tableData[0][indexKey][0]['filterType'];
                }
                tableColumns.push({title: tableData[0][indexKey][0]['title']});
                targets.push(indexKey+1);
                indexKey += 1;
              } else {
                for (let i = 0; i < tableData[0]['drillDownTable'].length; i++) {
                  childColumn.push({title: tableData[0]['drillDownTable'][i]})
                  childTargets.push(i + 1);
                };
              }
            }
          }
          for (let i = 1; i < tableData.length; i++) {
            let indexKey = 0;
            tableRows[i - 1] = [tableData[i]['drillDownTable'] == undefined ? i : ''];
            for (var key in tableData[i]) {
              if (tableData[i].hasOwnProperty(key)) {
                if (key != "drillDownTable" ) {
                  tableRows[i - 1].push(tableData[i][indexKey]);
                  indexKey += 1;
                }
              }
            }
          }

          if ($.fn.DataTable.isDataTable("#report-table")) {
            $('#report-table').DataTable().clear().destroy();
            $('#report-table').html("");
          }
          let table = $('#report-table').DataTable({
              columnDefs: [{
                targets: targets,
                className: ''
              }],
              ordering: true,
              searching: true,
              paging: true,
              iDisplayLength: 100,
              data: tableRows,
              columns: tableColumns,
              fixedHeader: {
                header: true,
                headerOffset: $('#topNav').outerHeight() - 24
              },
              createdRow: function( row, data, dataIndex ) {
                if (tableData[dataIndex + 1]['drillDownTable'] != undefined) {
                  $($(row).children()[0]).addClass('details-control');
                }
              }
          });


         // if(reportId == "40"){
            if ($.fn.DataTable.isDataTable("#report-table")) {
              $('#report-table').DataTable().clear().destroy();
              $('#report-table').html("");
            }
            table = $('#report-table').DataTable({
                columnDefs: [{
                  targets: targets,
                  className: ''
                }],
                ordering: true,
                searching: true,
                paging: false,
                iDisplayLength: 100,
                data: tableRows,
                columns: tableColumns,
                "scrollY":"350px",
                "scrollX": true,
                createdRow: function( row, data, dataIndex ) {
                  if (tableData[dataIndex + 1]['drillDownTable'] != undefined) {
                    $($(row).children()[0]).addClass('details-control');
                  }
                }
            });
            $("#report-table").css("margin-top","-16px");
       //   }
          $("#report-table").addClass("fixedLayout");

          createTableColumnFilter('report-table', tableData[0], table);
          $('#btn-report-submit').prop('disabled', false);
          loading(false);
          $('#view-report-table').removeClass().addClass('container-fluid');
          $('#w3Card').removeClass('dispNone');
          $('html, body').animate({
             scrollTop: $("#w3Card").offset().top - 60
          }, 1000);
          $('#filter-report').unbind('keyup')
          $('#filter-report').keyup( function(event) {
                table.draw();
          });
          $('#report-table tbody').off('click');
          $('#report-table tbody').on('click', 'td.details-control', function () {
            let tr = $(this).closest('tr');
            let row = table.row( tr );
            let rowIndex = $(this).parent().index();
            if ( row.child.isShown() ) {
               // This row is already open - close it
               row.child.hide();
               tr.removeClass('shown');
            }
            else {
               // Open this row
               let childRow = tableData[rowIndex + 1]['drillDownTable'];
               for (var i = 0; i < childRow.length; i++) {
                 childRow[i].unshift(i + 1);
               }
               row.child('<table id="report-table-child-'+rowIndex+'" cellpadding="5" class="mdl-data-table" style="text-align:left;" width="100%" cellspacing="0" border="0"></table>')
               .show();
               let childTable = $('#report-table-child-'+rowIndex).DataTable({
                   columnDefs: [{
                     targets: childTargets,
                     className: 'mdl-data-table__cell--non-numeric'
                   }],
                   data: childRow,
                   columns: childColumn,
                   ordering: true,
                   searching: true,
                   paging: true,
                   iDisplayLength: 100
               });
               tr.addClass('shown');
            }
          });

          var buttons = new $.fn.dataTable.Buttons(table, {
               buttons: [
               //  'excel',
              //   'pdf',
                 'print'
              ]
          }).container().appendTo($('#exportOptions'));
          $("#report-table>thead").prepend("<tr style='visibility:hidden;'><th style='width:2.5em !important;'></th></tr>");

          $('#report-table').DataTable().draw();

        }
        function addErrorLabel(element) {
          element.parent().append('<label class="error input-error">* Required</label>');
        }
        function createMultiselect(key){
          //for (var key in vehicleTripLegList) {
            //if (vehicleTripLegList.hasOwnProperty(key)) {
              let multiSelect ;
              if (key == 'vehicles') {
                multiSelect = $('#select-criteria-vehicle')

              } else if (key == 'trips') {
                multiSelect = $('#select-criteria-trip')

              }
              multiSelect.find('option').remove();
              for (let i = 0; i < vehicleTripLegList[key].length; i++) {
                let vtl = vehicleTripLegList[key][i];
                $option = $('<option value="'+vtl.key+'">'+vtl.value+'</option>');
                multiSelect.append($option);
              }

              multiSelect.multiselect({
                enableFiltering: true,
                includeSelectAllOption: true,
                maxHeight: 200,
                maxWidth: 300,
                dropUp: false,
                cssClass: key,
                onChange: function(option, checked, select) {
                  removeError(multiSelect);
                },
                onSelectAll:function (event) {
                  removeError(multiSelect);
                }
              });
              multiSelect.multiselect('refresh');
            //}
          //}
        }
        function removeError(multiSelect) {
          if(multiSelect.parent().find('.error').length > 0){
            multiSelect.parent().find('.error').remove();
          }
        }
        function showcategory() {
          categorySelect = $('#report-category');
          categorySelect.find('option').remove();
          $("#report-start-date").datepicker({
              dateFormat: 'dd/mm/yy',
              onSelect: function(selected, event) {
                  $("#report-end-date").datepicker("option", "minDate", selected);
                  setTimeout(function(){$("#report-end-date").datepicker('show');},10);
              }
          });
          $("#report-end-date").datepicker({
              dateFormat: 'dd/mm/yy',
              onSelect: function(selected) {
                  $("#report-start-date").datepicker("option", "maxDate", selected)
              }
          });
          categorySelect.append('<option value="" disabled selected>Select</option>');
          for (let i = 0; i < categories.length; i++) {
            let category = categories[i];
            option = "<option value=" + category.categoryId + ">" + category.categoryName + "</option>";
            categorySelect.append(option);
          }
          loading(false);
          $('#report-category').on('change', function() {
            let categoryId = $(this).val();
            reportSelect = $('#report-types');
            reportSelect.find('option').remove();
            reportSelect.append('<option value="" disabled selected>Select</option>');
            let selectedCategory = categories.find(category => category.categoryId == categoryId);
            for (let i = 0; i < selectedCategory.reports.length; i++) {
              let reportType = selectedCategory.reports[i];
              option = "<option value=" + reportType.reportId + ">" + reportType.reportName + "</option>";
              reportSelect.append(option);
            }
            let criteria = selectedCategory.enabledSearchCriteria;
            let criteriaVehicle = $('#criteria-vehicle');
            let criteriaTrip = $('#criteria-trip');
            if (criteria == 'All') {
              addMultiValidation($('#report-form'), [criteriaVehicle, criteriaTrip], []);
            } else if (criteria == 'Vehicle') {
                addMultiValidation($('#report-form'), [criteriaVehicle], [criteriaTrip]);
            } else if (criteria == 'Trip') {
              addMultiValidation($('#report-form'), [criteriaTrip], [criteriaVehicle]);
            }
          });
          $('#report-types').on('change', function() {
            let categoryId = $('#report-category').val();
            reportId = $(this).val()


            if(reportId == "38"){
              createMultiselect("vehicles");
              $('#select-criteria-vehicle').multiselect('destroy');
              $('#select-criteria-vehicle').prop("multiple", "");
              $('#select-criteria-vehicle').select2();
            }
            else {
              if($('#select-criteria-vehicle').hasClass("select2-hidden-accessible")){
              $('#select-criteria-vehicle').select2('destroy');
              $('#select-criteria-vehicle').prop("multiple", "multiple");}
              createMultiselect("vehicles");
            }
            let selectedCategory = categories.find(category => category.categoryId == categoryId);
            let selectedReport = selectedCategory.reports.find(report => report.reportId == reportId);
            $('#view-parameter').removeClass().addClass('disp');
            parametersRow = $('#row-parameter');
            parametersRow.empty();
            for (let i = 0; i < selectedReport.parameters.length; i++) {
              let parameter = selectedReport.parameters[i];
              let key = Object.keys(parameter)[0];
              parametersRow.append('<div class="col-xs-6 col-sm-6 col-md-2 col-lg-2" style="padding:0px 4px;"><div class="input-group-text"><input type="'+parameterType +'" value="'+ key +'" id="report-parameter-'+key+'" name="'+parameterInputName +'"><label class="check-lable" for="report-parameter-'+key+'">'+parameter[key]+'</label></div></div>');
            }
          })
        }
        function addMultiValidation(form, adds, removes) {
          for (let i = 0; i < adds.leleth; i++) {
            form.validate();
            adds[i].rules("add", {
              required:true,
              needsSelection: true,
            });
          }
          for (let i = 0; i < removes.leleth; i++) {
            form.validate();
            removes[i].rules("add", "required needsSelection");
          }
        }
        function loading(show) {
          loadingEle = $('#loading-report');
          loadingEle.removeClass().addClass(show ? 'center-view disp-flex' : 'center-view dispNone');
        }

        function createTableColumnFilter (tableEleId, columnDetails, table) {
  let tableEle = $('#'+ tableEleId)
  let filterView = $('#report-filter-view > #filter-elements')
  filterView.empty()
  for (const key in columnDetails) {
    if (columnDetails.hasOwnProperty(key)) {
      let columnInfo = columnDetails[key][0]
      let opHTML = getOperatorHTML(key)
      if (columnInfo.filterType == 'DD:HH:MM') { /*<label for="header-filter-'+ key + '"></label>*/
        filterView.append('<div class="form-group">'+ columnInfo.title + '<input type="text" class="form-control-filter" id="header-filter-'+ key + '" placeholder="DD:HH:MM"><hr/></div>')
        $('#header-filter-'+ key).unbind('keyup')
        $('#header-filter-'+ key).keyup(function (event) {
          table.draw()
        })
      } else if (columnInfo.filterType == 'Text') {/*<label for="header-filter-'+ key + '"></label>*/
        filterView.append('<div class="form-group">'+ columnInfo.title + '<input type="text" class="form-control-filter" id="header-filter-'+ key + '" placeholder="Search"><hr/></div>')
        $('#header-filter-'+ key).unbind('keyup')
        $('#header-filter-'+ key).keyup(function (event) {
          table.draw()
        })
      } else if (columnInfo.filterType == 'Number') {/*<label for="header-filter-'+ key + '"></label>*/
        filterView.append('<div class="form-group">'+ opHTML + columnInfo.title + '<input type="text" class="form-control-filter" id="header-filter-'+ key + '" placeholder="0.00"><hr/></div>')
        $('#header-filter-'+ key).unbind('keyup')
        $('#header-filter-'+ key).keyup(function (event) {
          table.draw()
        })
      }else if (columnInfo.filterType == 'DateTime') {/*<label for="header-filter-'+ key + '"></label>*/
        filterView.append('<div class="form-group">'+ opHTML + columnInfo.title + '<div class="input-group date" id="header-filter-'+ key + '" data-target-input="nearest"><input type="text" class="form-control-filter datetimepicker-input" data-target="#header-filter-'+ key + '" /><div class="input-group-append" data-target="#header-filter-'+ key + '" data-toggle="datetimepicker"><div class="input-group-text"><i class="fa fa-calendar"></i></div></div></div><hr/></div>')
        $('#header-filter-'+ key).datetimepicker('destroy')
        $('#header-filter-'+ key).datetimepicker()
        $('#header-filter-'+ key).on('change.datetimepicker', function (e) {
          table.draw()
        })
      } else if (columnInfo.filterType == 'Time') {/*<label for="header-filter-'+ key + '"></label>*/
        filterView.append('<div class="form-group">'+ opHTML + columnInfo.title + '<input type="text" class="form-control-filter" id="header-filter-'+ key + '" placeholder="HH:MM"><hr/></div>')
        $("#header-filter-"+ key).unbind('keyup')
        $("#header-filter-"+ key).keyup(function (event) {
          table.draw()
        })
      }
      $("input:radio[name='headerFilterRadio"+ key +"']").off('change')
      $("input:radio[name='headerFilterRadio"+ key +"']").on('change', function (event) {
        event.stopPropagation()
        table.draw()
      })
    }
  }
  $('#report-filter-reset').off('click')
  $('#report-filter-reset').on('click', function (e) {
    e.stopPropagation()
    for (const key in columnDetails) {
      if (columnDetails.hasOwnProperty(key)) {
        let columnInfo = columnDetails[key][0]
        if (columnInfo.filterType == 'DateTime') {
          $('#header-filter-'+ key).datetimepicker('clear')
        } else {
          $('#header-filter-'+ key).val('')
        }
        $('#header-filter-op-'+ key + '-1').attr('checked', false)
        $('#header-filter-op-'+ key + '-1').parent('label').removeClass('active')
        $('#header-filter-op-'+ key + '-2').attr('checked', true)
        $('#header-filter-op-'+ key + '-2').parent('label').addClass('active')
        $('#header-filter-op-'+ key + '-3').attr('checked', false)
        $('#header-filter-op-'+ key + '-3').parent('label').removeClass('active')
      }
    }
    table.draw()
  })
}
function getOperatorHTML (key) {
  return '<div class="btn-group btn-group-toggle" data-toggle="buttons" style="margin-bottom:10px"><label class="btn btn-secondary" style="flex:1"><input type="radio" name="headerFilterRadio'+ key + '" id="header-filter-op-'+ key + '-1" autocomplete="off" value="less"><</label><label class="btn btn-secondary active" style="flex:1"><input type="radio" name="headerFilterRadio'+ key + '" id="header-filter-op-'+ key + '-2" autocomplete="off" value="eq" checked>=</label><label class="btn btn-secondary" style="flex:1"><input type="radio" name="headerFilterRadio'+ key + '" id="header-filter-op-'+ key +'-3" autocomplete="off" value="great">></label></div>'
}

function generateExcel(){
			 $.ajax({
            url: '<%=request.getContextPath()%>/ReportBuilderAction.do?param=getExcelData',
			    type : 'POST',
               data:{
            	gridData:(JSON.stringify(gridData))
                },
                async: false,
            success: function(responseText) {
            if (responseText != "Failed to Download Report") {
				//?cameraNo="+cameraNo+"
                window.open("<%=request.getContextPath()%>/FileDownloader?fileName="+responseText);
            }else{
				alert(responseText);
			}
        }
        });
	
}

	var typeParam1;
function generateExcelNew(typeParam1){ 
         let categoryId = $('#report-category').val();
            let category = categories.find(category => category.categoryId == categoryId);
            let criteria = category.enabledSearchCriteria;
            let vehicles = $('#select-criteria-vehicle')
            let repParams = $('#row-parameter')
            let reporttypes = $('#report-types')
            let trips = $('#select-criteria-trip');
              let reportId1 = $('#report-types').val();
            if (criteria == 'All' && (vehicles.val().length == 0 && trips.val().length == 0)) {
              if (vehicles.val().length == 0) {
                addErrorLabel(vehicles);
              }
              if (trips.val().length == 0) {
                addErrorLabel(vehicles);
              }
              return;
            } else if (criteria == 'Vehicle' && vehicles.val().length == 0) {
              if (vehicles.val().length == 0) {
                addErrorLabel(vehicles);
              }
              if(reporttypes.val().length == 0) {
                  addErrorLabel(reporttypes);
              }
              if(reportId1 == "select"){
              addErrorLabel(reporttypes);
              } 
            
              return;
            } else if (criteria == 'Trip' && (vehicles.val().length == 0)) {
              if (vehicles.val().length == 0) {
                addErrorLabel(vehicles);
              }

              return;
            } else if (criteria == 'Hub' && (vehicles.val().length == 0)) {
                            if (vehicles.val().length == 0) {
                                addErrorLabel(vehicles);
                            }
                            return;
                        }
            loading(false);
            let parameters = [];
            let parameters1 = [];
            let selectedParameter = $("input[type='radio'][name='reportParameters']:checked");
            let selectedParameter1 = $("input[type='checkbox'][name='reportParameters1']:checked");
            let selectedParam1 =  $.each($("input[type='checkbox'][name='reportParameters1']:checked"), function(){           
                parameters1.push($(this).val());
            });
            parameters.push(selectedParameter.val());
             let reportInfo = "";
            let reportInput = {
             categoryId : $('#report-category').val(),
              reportId : reporttypes.val().toString(),
              parameterSelected: parameters.toString(),
              parameterSelectedNew: parameters1.toString(),
              startDate: $('#report-start-date').val(),
              endDate: $('#report-end-date').val(),
              vehicles: vehicles.val().toString(),
              trips: trips.val().toString(),
			  radius: $('#radius').val(),
              reportName: $("#report-types option:selected").text(),
              reportInfo: reportInfo,
              typeParam1:typeParam1
            } 
             $.ajax({
                type : 'POST',
                 url: '<%=request.getContextPath()%>/ReportBuilderAction.do?param=exportData',
                data: reportInput,
                async: false,
            	success: function(responseText) {
        		if(typeParam1 == "EXCEL"){
            		if (responseText != "Failed to Download Report") {
                		window.open("<%=request.getContextPath()%>/LegDetailsExport?relativePath=" + responseText);
            		}else{
                		alert(responseText);
            		}
          	    }else if(typeParam1 == "PDF"){
           			if (responseText != "Failed to Download Report") {
                		window.open("<%=request.getContextPath()%>/LegDetailsExport?relativePath=" + responseText);
            		}else{
                		alert(responseText);
            		}
           		}
         	} 
        });

}
      </script>
<jsp:include page="../Common/footer.jsp" />
<%}%>