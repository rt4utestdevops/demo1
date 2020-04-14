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
<!-- <link href="https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/4.0.0/css/bootstrap.css" rel="stylesheet">-->
<!-- <link href="https://cdn.datatables.net/1.10.16/css/dataTables.bootstrap4.min.css" rel="stylesheet">-->
<!--    <script src="https://code.jquery.com/jquery-1.12.4.js"></script>-->
<!--	<script src="https://cdn.datatables.net/1.10.16/js/jquery.dataTables.min.js"></script>-->
<!--    <script src="https://cdn.datatables.net/1.10.16/js/dataTables.bootstrap4.min.js"></script>-->
<link href="../../Main/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">

	<link href="../../Main/sweetAlert/sweetalert.css" rel="stylesheet">
	<link href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" rel="stylesheet">
	<link href="https://cdn.datatables.net/1.10.16/css/dataTables.bootstrap.min.css" rel="stylesheet">
	<link href="https://cdn.datatables.net/select/1.2.3/css/select.dataTables.min.css" rel="stylesheet"/>

	<script src="../../Main/vendor/jquery/jquery.min.js"></script>
	<script src="../../Main/vendor/bootstrap/js/bootstrap.min.js"></script>

    <script src="../../Main/sweetAlert/sweetalert.min.js"></script>
    <script src="https://cdn.datatables.net/1.10.9/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.datatables.net/1.10.16/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.datatables.net/1.10.16/js/dataTables.bootstrap4.min.js"></script>
    <script src="https://cdn.datatables.net/buttons/1.4.2/js/dataTables.buttons.min.js"></script>


<div class="custom">
		<div class="panel panel-primary">
			<div class="panel-heading">
				<h3 class="panel-title" >
                     UTILIZATION CONFIGARATION 
                  </h3>
			</div>
			<div id="panelBodyID" class="panel-body">
				

				<button class='btn btn-primary' onclick="addNewConfing()">Add New Configuration</button>
				<table id="configTable" class="table table-striped table-bordered" cellspacing="0" width="100%" style="margin-top:1%">
					<thead>
						<tr>
						    <th>ID</th>
							<th>SL NO.</th>
							<th>Customer Name</th>
							<th>Non Comm Duration(min)</th>
							<th>Alert Distance(km)</th>
							<th>Mail List</th>
							<th>Speed Limit</th>
							<th></th>
							
						</tr>
					</thead>
				</table>
			</div>  <!-- end of panel body-->
		</div>  <!-- end of primary panel -->
		</div> <!-- end of custom -->
		
	   <div id="AddModel" class="modal fade" style="margin-top: 8%;" >
  <div class="modal-dialog" >
    <div class="modal-content" style="width: 140%;">
      <div class="modal-header">
        <h4 id="tripDetailsTitle" class="modal-title" >Configuration Details</h4>
        <button type="button" class="close" data-dismiss="modal">&times;</button>
      </div>
      <div class="modal-body" style="max-height: 100%;">
        <div class="col-xs-12 col-md-12 col-lg-12">
          <div class="bs-example">
            <form class="form-horizontal" action="/examples/actions/confirmation.php" method="post">
              <div class="form-group">
                <label for="inputEmail" class="control-label col-xs-4 col-md-4 col-lg-4">Select Customer: </label>
                <div class="col-xs-6 col-md-6 col-lg-6">
                  <select class="form-control" id="customerList" ">
                    <option value=0 style="display:none"> CUSTOMER NAME</option>
                  </select>
                </div>
              </div>
              <div class="form-group">
                <label for="nonCommId" class="control-label col-xs-4 col-md-4 col-lg-4">Enter Non Comm Duration(min):  </label>
                <div class="col-xs-6 col-md-6 col-lg-6">
                  <input type="number" min="1" class="form-control" id="nonCommId" placeholder="Example: 15" required>
                </div>
              </div>
              <div class="form-group">
                <label for="distId" class="control-label col-xs-4 col-md-4 col-lg-4">Enter Alert Distance(km):  </label>
                <div class="col-xs-6 col-md-6 col-lg-6">
                  <input type="number" min="1" class="form-control" id="distId" placeholder="Example: 10" required>
                </div>
              </div>
              <div class="form-group">
                <label for="mailListId" class="control-label col-xs-4 col-md-4 col-lg-4">Email List:  </label>
                <div class="col-xs-6 col-md-6 col-lg-6">
                  <textarea type="text" class="form-control" id="mailListId" placeholder="Example: email1,email2,email3"  required rows="4" cols="50">
                  </textarea>
                </div>
              </div>
            </form>
          </div>
        </div>
      </div>
      <div class="modal-footer" >
        <button  class="btn btn-primary" Onclick="saveNewConfig()">Save</button> 
        <button type="reset" class="btn btn-warning" data-dismiss="modal">Close</button> 
      </div>
    </div>
  </div>
</div>
<!--endoff add model -->
<div id="updateModel" class="modal fade" style="margin-top: 8%;" >
  <div class="modal-dialog" >
    <div class="modal-content" style="width: 140%;">
      <div class="modal-header">
        <h4 id="tripDetailsTitle" class="modal-title" >Configuration Details</h4>
        <button type="button" class="close" data-dismiss="modal">&times;</button>
      </div>
      <div class="modal-body" style="max-height: 100%;">
        <div class="col-xs-12 col-md-12 col-lg-12">
          <div class="bs-example">
            <form class="form-horizontal" action="/examples/actions/confirmation.php" method="post">
              <input type="number"  id="id" style="display:none">
              <div class="form-group">
                <label for="custName1" class="control-label col-xs-4 col-md-4 col-lg-4">Customer Name:  </label>
                <div class="col-xs-6 col-md-6 col-lg-6">
                  <input type="text"  class="form-control" id="custName1" placeholder="Customer Name" required>
                </div>
              </div>
              <div class="form-group">
                <label for="nonCommId1" class="control-label col-xs-4 col-md-4 col-lg-4">Enter Non Comm Duration(min):  </label>
                <div class="col-xs-6 col-md-6 col-lg-6">
                  <input type="number" min="1" class="form-control" id="nonCommId1" placeholder="Example: 15" required>
                </div>
              </div>
              <div class="form-group">
                <label for="distId1" class="control-label col-xs-4 col-md-4 col-lg-4">Enter Alert Distance(km):  </label>
                <div class="col-xs-6 col-md-6 col-lg-6">
                  <input type="number" min="1" class="form-control" id="distId1" placeholder="Example: 10" required>
                </div>
              </div>
              <div class="form-group">
                <label for="mailListId1" class="control-label col-xs-4 col-md-4 col-lg-4">Email List:  </label>
                <div class="col-xs-6 col-md-6 col-lg-6">
                  <textarea type="text" class="form-control" id="mailListId1" placeholder="Example: email1,email2,email3"  required rows="4" cols="50">
                  </textarea>
                </div>
              </div>
            </form>
          </div>
        </div>
      </div>
      <div class="modal-footer" >
        <button  class="btn btn-primary" Onclick="UpdateConfigData()">Update</button> 
        <button type="reset" class="btn btn-warning" data-dismiss="modal">Close</button> 
      </div>
    </div>
  </div>
</div>
  <script type="text/javascript">
  var table;
 var custArray = [];
 window.onload = loadData();

 function loadData() {
     loadGrid();
 }


 function loadGrid() {
     table = $('#configTable').DataTable({
         "ajax": {
             "url": "<%=request.getContextPath()%>/tripDashBoardAction.do?param=getUtilConfDetails",
             "dataSrc": "UtilConfDetails",
         },
         "bLengthChange": false,

         "columns": [{
             "data": "Id",
             "visible": false,
             "searchable": false
         }, {
             "data": "slno"
         }, {
             "data": "custName"
         }, {
             "data": "nonCommMin"
         }, {
             "data": "alertDist"
         }, {
             "data": "mailList"
         }, {
             "data": "speedLimit",
             "visible": false,
             "searchable": false
         }, {
             "data": null,
             "defaultContent": "<button class='btn btn-primary'>Modify Configuration</button>"
         }]
     });
     $('#configTable').on('click', 'td', function(event) {
         var columnIndex = table.cell(this).index().column;
         var aPos = $('#configTable').dataTable().fnGetPosition(this);
         var data = $('#configTable').dataTable().fnGetData(aPos[0]);
         var custName = (data['custName']);
         var nonCommMin = (data['nonCommMin']);
         var alertDist = (data['alertDist']);
         var mailList = (data['mailList']);
         var id = (data['Id']);
         if (columnIndex == 7) {
             //updateUtilConfig
             document.getElementById("id").value = id;
             document.getElementById("custName1").value = custName;
             document.getElementById("nonCommId1").value = nonCommMin;
             document.getElementById("distId1").value = alertDist;
             document.getElementById("mailListId1").innerHTML = mailList;
             $("#custName1").attr("disabled", "disabled");



             $('#updateModel').modal('show');

         }

     });
 }

 function addNewConfing() {
     $('#AddModel').modal('show');

     document.getElementById("customerList").value = "";
     document.getElementById("nonCommId").value = "";
     document.getElementById("distId").value = "";
     document.getElementById('mailListId').value = "";

     for (var i = document.getElementById("customerList").length - 1; i >= 1; i--) {
         document.getElementById("customerList").remove(i);
     }
     getCustList();
     getCustomerList();
 }

 function getCustomerList() {
     var CustomerList;
     $.ajax({
         type: "POST",
         url: '<%=request.getContextPath()%>/tripDashBoardAction.do?param=getAllCustomer',
         success: function(result) {
             CustomerList = JSON.parse(result);
             for (var i = 0; i < CustomerList["customerRoot"].length; i++) {
                 var customerId = CustomerList["customerRoot"][i].CustId;
                 var customerName = CustomerList["customerRoot"][i].CustName;
                 $('#customerList').append($("<option></option>").attr("value", customerId).text(customerName));
             }
         }
     });
 }

 function getCustList() {
     var CustList;

     for (var i = 0; i < custArray.length; i++) {
         custArray.pop();
     }
     $.ajax({
         url: '<%=request.getContextPath()%>/tripDashBoardAction.do?param=getUtilConfDetails',
         success: function(result) {
             CustList = JSON.parse(result);
             for (var i = 0; i < CustList["UtilConfDetails"].length; i++) {
                 custArray.push(CustList["UtilConfDetails"][i].custId);
             }
         }
     });

 }

 function validateCaseSensitiveEmail(email) {
     var reg = /^[_a-z0-9-]+(\.[_a-z0-9-]+)*@[a-z0-9-]+(\.[a-z0-9-]+)*(\.[a-z]{2,4})$/;
     if (reg.test(email)) {
         return true;
     } else {
         return false;
     }
 }

 function saveNewConfig() {
     var custId = document.getElementById("customerList").value;
     var nonCommId = document.getElementById("nonCommId").value;
     var distId = document.getElementById("distId").value;
     var mailList = document.getElementById('mailListId').value.trim();
     var strarray = mailList.split(',');
     if (custId == 0) {
         sweetAlert("Please Select Customer Name");
         return;
     }
     if (custId > 0) {
         if (custArray.includes(parseInt(custId))) {
             sweetAlert("Selected Customer Already Added ");
             return;
         }
     }
     if (nonCommId == 0) {
         sweetAlert("Please Enter Non Communication minute");
         return;
     }
     if (distId == 0) {
         sweetAlert("Please Enter Distance ");
         return;
     }
     if (mailList == 0 || mailList == 'undefined' || mailList == "") {
         sweetAlert("Please Enter MailList");
         return;
     } 
	 if(mailList.length>0){
	      for (var i = 0; i < strarray.length; i++) {
			 if(!validateCaseSensitiveEmail(strarray[i])){  
				  sweetAlert("InValid MailId : "+strarray[i]);
				 return ;
			 }
	    }	
		 var params = {
             custId: custId,
             nonCommMin: nonCommId,
             mailList: mailList,
             alertDist: distId,
             speedlimit: -1,
         };

         $.ajax({
             url: '<%=request.getContextPath()%>/tripDashBoardAction.do?param=insertUtilConfig',
             data: params,
             type: "POST",
             success: function(result) {
                 if (result == "Saved Successfully") {
                     sweetAlert("Saved Successfully");
                     setTimeout(function() {}, 1000);
                     table.ajax.reload();
                     $('#AddModel').modal('hide');
                 } else {
                     sweetAlert(result);
                 }
             }
         });
	 }
 }

 function UpdateConfigData() {
     var id = document.getElementById("id").value;

     var nonCommId = document.getElementById("nonCommId1").value;
     var distId = document.getElementById("distId1").value;
     var mailList = document.getElementById('mailListId1').value.trim();
     var listofMail = mailList.split(",");
	 var strarray = mailList.split(',');
			
     if (nonCommId == 0) {
         sweetAlert("Please Enter Non Communication minute");
         return;
     }
     if (distId == 0) {
         sweetAlert("Please Enter Distance ");
         return;
     }
     if (mailList == 0 || mailList == 'undefined' || mailList == "") {
         sweetAlert("Please Enter MailList");
         return;
     } if(mailList.length>0){
	      for (var i = 0; i < strarray.length; i++) {
			 if(!validateCaseSensitiveEmail(strarray[i])){  
				  sweetAlert("InValid MailId : "+strarray[i]);
				 return ;
			 }
	    }
		var params = {
             id: id,
             nonCommMin: nonCommId,
             mailList: mailList,
             alertDist: distId

         };

         $.ajax({
             url: '<%=request.getContextPath()%>/tripDashBoardAction.do?param=updateUtilConfig',
             data: params,
             type: "POST",
             success: function(result) {
                 if (result == "Updated Successfully") {
                     sweetAlert("Updated Successfully");
                     setTimeout(function() {}, 1000);
                     table.ajax.reload();
                     $('#updateModel').modal('hide');
                 } else {
                     sweetAlert(result);
                 }
             }
         });

     }		
	 
         


 }
  </script>
<jsp:include page="../Common/footer.jsp" />