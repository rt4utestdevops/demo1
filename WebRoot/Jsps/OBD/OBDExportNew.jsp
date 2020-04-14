<%@ page language="java" import="java.util.*,t4u.functions.CommonFunctions,t4u.beans.*,t4u.common.*" pageEncoding="UTF-8"%>
<%@ taglib uri="http://packtag.sf.net" prefix="pack" %> 
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
if (request.getParameter("list") != null) {
		String list = request.getParameter("list").toString().trim();
		String[] str = list.split(",");
		int systemid = Integer.parseInt(str[0].trim());
		int customerid = Integer.parseInt(str[1].trim());
		int userid = Integer.parseInt(str[2].trim());
		String language = str[3].trim();
		LoginInfoBean loginInfo = new LoginInfoBean();
		loginInfo.setSystemId(systemid);
		loginInfo.setCustomerId(customerid);
		loginInfo.setUserId(userid);
		loginInfo.setLanguage(language);
		loginInfo.setStyleSheetOverride("N");
		loginInfo.setZone(str[4].trim());
		loginInfo.setOffsetMinutes(Integer.parseInt(str[5].trim()));
		loginInfo.setSystemName(str[6].trim());
		loginInfo.setCategory(str[7].trim());
		if (str.length > 8) {
			loginInfo.setCustomerName(str[8].trim());
		}
		if (str.length > 9) {
			loginInfo.setCategoryType(str[9].trim());
		}
		if (str.length > 10) {
			loginInfo.setUserName(str[10].trim());
		}
		if (str.length > 11) {
			loginInfo.setStyleSheetOverride("N");
		}
		session.setAttribute("loginInfoDetails", loginInfo);
	}
	CommonFunctions cf = new CommonFunctions();
	LoginInfoBean loginInfo = (LoginInfoBean) session
			.getAttribute("loginInfoDetails");
	if (loginInfo == null) {
		response.sendRedirect(request.getContextPath()
				+ "/Jsps/Common/SessionDestroy.html");
	} else {
		session.setAttribute("loginInfoDetails", loginInfo);
		String language = loginInfo.getLanguage();
		int systemId = loginInfo.getSystemId();
		int customerId = loginInfo.getCustomerId();
		int userId = loginInfo.getUserId();
		String RegNO="";
			 ArrayList<String> tobeConverted = new ArrayList<String>();
			 
ArrayList<String> convertedWords = new ArrayList<String>();
convertedWords = cf.getLanguageSpecificWordForKey(tobeConverted,language);

	


%>
<jsp:include page="../Common/header.jsp" />
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.datatables.net/1.10.16/css/dataTables.bootstrap.min.css">
    <link rel="stylesheet" href="https://ajax.googleapis.com/ajax/libs/jqueryui/1.11.1/themes/ui-darkness/jquery-ui.min.css" rel="stylesheet">
	<link rel="stylesheet" href="../../Main/sweetAlert/sweetalert.css">
	<link rel="stylesheet" href="https://www.jqwidgets.com/public/jqwidgets/styles/jqx.base.css">
	<link rel="stylesheet" href="https://www.jqwidgets.com/public/jqwidgets/styles/jqx.energyblue.css">
	<link rel="stylesheet" href="https://www.jqwidgets.com/public/jqwidgets/styles/jqx.arctic.css">

 	<script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
 	<link rel="stylesheet" href="https://cdn.datatables.net/responsive/2.2.1/css/responsive.dataTables.min.css"></link>
    <script src="https://code.jquery.com/jquery-1.12.4.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script>
    <script src="https://cdn.datatables.net/1.10.16/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.datatables.net/1.10.16/js/dataTables.bootstrap.min.js"></script>
    <script src="https://cdn.datatables.net/responsive/2.2.1/js/dataTables.responsive.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
	<script src="../../Main/sweetAlert/sweetalert-dev.js"></script>   
	<script src="https://malsup.github.io/jquery.form.js"></script>
	<script src="https://www.jqwidgets.com/public/jqwidgets/jqx-all.js"></script>
	<script src="https://www.jqwidgets.com/public/jqwidgets/globalization/globalize.js"></script>
	<script src="https://cdn.datatables.net/buttons/1.4.2/js/dataTables.buttons.min.js"></script>
   <script type="text/javascript" src="https://cdn.datatables.net/buttons/1.4.2/js/buttons.bootstrap.min.js"></script>
   <script type="text/javascript" src="//cdn.datatables.net/buttons/1.4.2/js/buttons.colVis.min.js"></script>
   <script src="https://cdn.datatables.net/buttons/1.4.2/js/buttons.flash.min.js"></script>
   <script src="https://cdnjs.cloudflare.com/ajax/libs/jszip/3.1.3/jszip.min.js"></script>
   <script src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.32/pdfmake.min.js"></script>
   <script src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.32/vfs_fonts.js"></script>
   <script src="https://cdn.datatables.net/buttons/1.4.2/js/buttons.html5.min.js"></script>
   <script src="https://cdn.datatables.net/buttons/1.4.2/js/buttons.print.min.js"></script>
	    <link href="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.6-rc.0/css/select2.min.css" rel="stylesheet" />
	<script src="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.6-rc.0/js/select2.min.js"></script>
	
				
 <style>
		 	
	@media (min-width: 576px){
   .form-inline label {
    margin-top: 35px !important;    
    margin-left: 850px !important;
    }
    }

   div.dataTables_wrapper div.dataTables_paginate {   
    margin-left: 986px  !important;
    }
   
  
    #labelId{
    font-weight: normal !important;
    }
    
  
			
 </style>
		 
	<div class="panel panel-primary">
	  <div class="panel-heading">
		<h3 class="panel-title">
                   OBD Report
		</h3>
	</div>
	  
	   
	   <div class="panel-body">
	<div class="row" id="topRow1" style="display:block;">
				<div class="col-lg-6 col-lg-6">
					<label for="staticEmail2" id= "labelId" class="col-sm-4 col-md-4" >Customer Name</label>
						<select class="col-sm-6 col-md-6" id="custDropDownId"  data-live-search="true" style="height:25px;width: 100px;">
							
						</select>
				</div>
		</div>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				   
	<div class="row" id="topRow2" style="display:block;">
				<div class="col-lg-6 col-lg-6" style="display: inherit;">
					 <label for="staticEmail2" id= "labelId" class="col-sm-4 col-md-4" >View Report By:</label>
					 	<div class='col-sm-6 col-md-6 ' style="margin-left: -4% !important;">
							<input type='radio'   value = "Registration No" id="radioId" checked style ="margin-left: 6px;"/>
							<label for = "radioId" id= "labelId"> Registration Number </label>
						</div>
				</div>
		</div>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				  
	<div class="row" id="topRow3" style="display:block;">
				<div class="col-sm-4 col-md-4" style="margin-left: 0%;">
					<label for="staticEmail2" id= "labelId" class="col-sm-5 col-md-5">Registration  No</label>
						<select class="col-sm-5 col-md-5" id="vehicleNoDropDownId"  data-live-search="true" style="height:25px;">
							<option selected></option>
						</select>
				</div>
				
				<div class="col-sm-4 col-md-4" style="display: inherit;">
					 <label for="staticEmail2" id= "labelId" class="col-sm-4 col-md-4" >Start Date</label>
					 	<div class='col-sm-4 col-md-4 input-group date' >
							<input type='text'  id="dateInput1"/>
						</div>
				</div>
					 
				<div class="col-sm-4 col-md-4" style="display: inherit;">
				    <label for="staticEmail2" id= "labelId" class="col-sm-4 col-md-4" >End Date</label>
						<div class='col-sm-4 col-md-4 input-group date' >
							<input type='text'  id="dateInput2"/>
						</div>
				</div>
				   
	      </div>
	<br><br/>      
  <div class="row" id="button" style="display:block;">
	  <div class="col-sm-3 col-md-3" >
		    <button id="reportId" class="btn btn-primary" onclick="generateData()" style="margin-left:569px;" >Generate Report</button> 
		</div>&nbsp;&nbsp;
</div>
  <br><br/>
		
	</div>
	
	
  
     <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12 text-center">
       			<div id="page-loader" style="margin-top:10px;display:none;">
				 <img src="../../Main/images/loading.gif" alt="loader" />
				</div>
 	</div>
</div>
				
	
	
 <script><!--
   
    
     window.onload = function () { 
		getCustomerAndVehicleNo();
	}
	
    var jspName = "OBD Report";
    var custId;
    var previousDate = new Date();
    
      	 previousDate.setDate(previousDate.getUTCDate() - 1);
      	 previousDate.setHours(previousDate.getUTCHours());
	  	 previousDate.setMinutes(previousDate.getUTCMinutes());
	 	 previousDate.setSeconds(previousDate.getUTCSeconds());

 var currentDate = new Date();
	 	 currentDate.setDate(currentDate.getUTCDate());
      	 currentDate.setHours(currentDate.getUTCHours());
	  	 currentDate.setMinutes(currentDate.getUTCMinutes());
	 	 currentDate.setSeconds(currentDate.getUTCSeconds());
  
    $(document).ready( function () {
       
       $("#dateInput1").jqxDateTimeInput({ theme: "arctic", formatString: "dd-MM-yyyy HH:mm:ss", showTimeButton: true, width: '235px', height: '25px'});
       $('#dateInput1 ').jqxDateTimeInput('setDate', previousDate);
       $("#dateInput2").jqxDateTimeInput({ theme: "arctic", formatString: "dd-MM-yyyy HH:mm:ss", showTimeButton: true, width: '235px', height: '25px'});
       $('#dateInput2 ').jqxDateTimeInput('setDate', currentDate);

     });

    var custName;
	var custarray=[];
	var vehicleList;
    
    function getCustomerAndVehicleNo(){

	$("#vehicleNoDropDownId").empty().select2();
	
	    $.ajax({
			url: '<%=request.getContextPath()%>/CommonAction.do?param=getCustomer',
			
			success: function(result) {
				 customerDetails = JSON.parse(result);
				for (var i = 0; i < customerDetails["CustomerRoot"].length; i++) {
					$('#custDropDownId').append($("<option></option>").attr("value", customerDetails["CustomerRoot"][i].CustId).text(customerDetails["CustomerRoot"][i].CustName));
					custId = customerDetails["CustomerRoot"][i].CustId;
				}
					 $('#custDropDownId').select2();
					 
					 
		$.ajax({
            url: '<%=request.getContextPath()%>/OBDAction.do?param=getGroups',
           datatype : "application/json",
	     data : {
		   CustId: custId,
		   },
          success: function(result) {
                   vehicleList = JSON.parse(result);
               for (var i = 0; i < vehicleList["groupNameList"].length; i++) {
                    $('#vehicleNoDropDownId').append($("<option></option>").attr("value", vehicleList["groupNameList"][i].groupId).text(vehicleList["groupNameList"][i].groupName));
	            }
	            $('#vehicleNoDropDownId').select2();

		}
	
	});	 
					 
		}
	});
	 
}
      
      var startDate;
      var endDate;
      var vehclNo;
      var customerId;
      
  function generateData(){
       startDate=document.getElementById("dateInput1").value;
       endDate=document.getElementById("dateInput2").value; 
       vehclNo= document.getElementById("vehicleNoDropDownId").value;
                            
       var dateDiff = monthValidation(startDate, endDate);
       var dayDiff = dateValidation(startDate, endDate);
       
       if($("#reportId").prop("checked", true)){
            if(document.getElementById("vehicleNoDropDownId").value == "Select Vehicle No"){
                  sweetAlert("Select Vehicle Number");
                  return;
                  }
              }

       if (!dayDiff) {
                  sweetAlert("End date must be greater than the Start date!");
                  return;
               }
       if (!dateDiff) {
                  sweetAlert("Date range should not exceed 7 days!");
                  return;
               } 
        else {
        $('#reportId').prop('disabled', true);
        $('#dateInput1').prop('disabled', true);
        $('#dateInput2').prop('disabled', true);
        document.getElementById("page-loader").style.display = "block";
       $.ajax({
        url: '<%=request.getContextPath()%>/OBDAction.do?param=getOBDExcelNew',
        datatype : "application/json",
	     data : {
		   CustId:custId,
		   RegNo:vehclNo,
		   StartDate:startDate,
		   EndDate:endDate,
		   jspName: jspName
		  },
        
               success: function(responseText) {
                 console.log("response",responseText );
                document.getElementById("page-loader").style.display = "none";
                $('#reportId').prop('disabled', false);
                $('#dateInput1').prop('disabled', false);
                $('#dateInput2').prop('disabled', false);
                 if(responseText!="No Records Found"){
                window.open("<%=request.getContextPath()%>/LegDetailsExport?relativePath=" + responseText);
                }else{
                  sweetAlert("No Records Found!");
                }
              } 
            }); 
               
            } 
		}
      
      	 
  function dateValidation(date1, date2) {
    var dd = date1.split("-");
    var ed = date2.split("-");
    var startDate = new Date(dd[1] + "-" + dd[0] + "-" + dd[2]);
    var endDate = new Date(ed[1] + "-" + ed[0] + "-" + ed[2]);
    if (endDate >= startDate) {
        return true;
    } else {
        return false;
    }
    }
      
 function monthValidation(date1, date2) {
    var dd = date1.split("-");
    var ed = date2.split("-");
    var startDate = new Date(dd[1] + "-" + dd[0] + "-" + dd[2]);
    var endDate = new Date(ed[1] + "-" + ed[0] + "-" + ed[2]);
    var timeDiff = Math.abs(endDate.getTime() - startDate.getTime());
    var daysDiff = Math.ceil(timeDiff / (1000 * 3600 * 24));
    
    if (daysDiff <= 7) {
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

--></script>
 
<jsp:include page="../Common/footer.jsp" />
	<!-- </body>   -->
<!-- </html> -->
 
<%}%>
