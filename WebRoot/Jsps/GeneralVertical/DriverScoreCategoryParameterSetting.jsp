<%@ page language="java"
	import="java.util.*,t4u.functions.*,t4u.beans.*,t4u.common.*"
	pageEncoding="utf-8"%>
	<%@ taglib uri="http://packtag.sf.net" prefix="pack" %>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";%>


<jsp:include page="../Common/header.jsp" />
	
	
	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.datatables.net/1.10.16/css/dataTables.bootstrap.min.css">
    <link rel="stylesheet" href="https://ajax.googleapis.com/ajax/libs/jqueryui/1.11.1/themes/ui-darkness/jquery-ui.min.css" rel="stylesheet">
	<link rel="stylesheet" href="../../Main/sweetAlert/sweetalert.css">
	<link rel="stylesheet" href="https://cdn.datatables.net/1.10.16/css/dataTables.bootstrap4.min.css">
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

<style>
label {
    display: inline-block;
    max-width: 100%;
    margin-bottom: 5px;
    font-weight: 500;
}
table {
font-size: smaller;

}

</style>


 
  
  <!-- <body onload="getCustomer();">  -->
  
  
	
<div class="panel panel-primary">
	<div class="panel-heading">
	<h4  align="center" class="panel-title">Driver Parameter Setting</h3></div>
	<div class="panel-body">
	
	<div class="col-lg-12 row">
		
				<div class="col-lg-3 ">
					<label for="staticEmail2" class="col-lg-6 ">Customer Name:</label>
					
						<select class="col-lg-6" id="custDropDownId" onchange="loadData()" data-live-search="true" style="height:25px;">
						<option style="display: none"></option>

					
						  
						</select>

				</div>
			    <div class="col-lg-3 ">
					 <label for="staticEmail2" class="col-lg-6 ">Vehicle Model:</label>
					 
					<select class="col-lg-6" id="vehicleModelDropDownID"   data-live-search="true"  style="height:25px;">
<!--						<option style="display: none"></option>-->
					<option selected></option>
						</select>
			     </div>
					<button id="viewId" class="col-lg-1 btn btn-primary" onclick="getDriverScoreGridData()">View</button>
					<button title="ADD" onclick="openAddModal()"   class="col-lg-1 btn btn-warning" style="margin-left:50px;">ADD</button>
		</div>
		<br><br/>
			<table id="example" class="table table-striped table-bordered" cellspacing="0" width="100%">
           		<thead>
                 	<tr>
					<th>Sl No</th>
					<th style="display:none;">Uid</th>
					<th>Vehicle Model</th>
					<th>Parameter Name</th>
					<th>Max Value</th>
					<th>Min Value</th>
					<th>Type of Value</th>
					<th>Modify</th>
				</thead>
			</table>
		</div>
	</div>
	
	    	<div id="add" class="modal fade" style="margin-right: 12%;">
        <div class="modal-dialog" style="position: absolute;left: 40%;top: 44%;margin-top: -150px;width:725px;">
            <div class="modal-content">
                <div class="modal-header">
                    <h4 id="nome" class="modal-title">Add Driver Score Parameters</h4>
					 <button type="button" class="close" data-dismiss="modal" style="margin-top: -8px;">&times;</button>
                </div>
                <div class="modal-body" style="max-height: 50%;">
		           <div class="col-md-12">
		           <form  method="post" id="register-form" name = "register-form" >
			      	<table class="table table-sm table-bordered table-striped">
			      		<tbody>
							<tr>	      			
				      			<td>Parameter Name : </td>
				      			<td><select class="form-control" id="paramNameDropDownID" data-live-search="true" required="required">
									<option> </option>
									</select></td>
				      		</tr>
							<tr>	      			
				      			<td>Min Value : </td>
				      			<td><input type="number" id="minValueId" name ="MinValueName" class="form-control" min="1" maxlength="6" onkeypress="return checkVal(event)" oninput="javascript: if (this.value.length > this.maxLength) this.value = this.value.slice(0, this.maxLength); " /></td>
				      		</tr>
				      		<tr>	      			
				      			<td>Max Value : </td>
				      			<td><input type="number" id="maxValueId" name ="MaxValueName" class='form-control' min="1" maxlength="6" onkeypress="return checkVal(event)" oninput="javascript: if (this.value.length > this.maxLength) this.value = this.value.slice(0, this.maxLength); " /></td>
				      		</tr>

			      		</tbody>
			      	</table>
			      	</form>
			      </div>
                </div>
                
                <div class="modal-footer"  style="text-align: center;" >
                	<input  type="button"  class="btn btn-primary" value="Save" onclick="saveData()"/>  	<!-- onclick="saveData()" -->
                    <button type="reset"  onclick="cancel()" class="btn btn-warning" data-dismiss="modal">Cancel</button> 
                    
                </div>
            </div>
        </div>
    </div>
    
    	<div id="modify" class="modal fade" style="margin-right: 12%;">
        <div class="modal-dialog" style="position: absolute;left: 40%;top: 44%;margin-top: -100px;width:725px;">
            <div class="modal-content">
                <div class="modal-header">
                    <h4 id="nome" class="modal-title">Modify Driver Score Parameters</h4>
					 <button type="button" class="close" data-dismiss="modal">&times;</button>
                </div>
                <div class="modal-body" style="max-height: 150%;">
		           <div class="col-md-12">
		           <form  method="post" id="register-form" name = "register-form" >
			      	<table class="table table-sm table-bordered table-striped">
			      		<tbody>
							<tr>	      			
				      			<td>Parameter Name : </td>
				      			<td><input type="text" id="modifyParamNameDropDownID" class='form-control'"></td>
				      		</tr>
							<tr>	      			
				      			<td>Min Value : </td>
				      			<td><input type="number" id="modifyMinValueId" name ="MinValueRedBoxName" class='form-control' min="1" maxlength="6" onkeypress="return checkVal(event)" oninput="javascript: if (this.value.length > this.maxLength) this.value = this.value.slice(0, this.maxLength); "></td>
				      		</tr>
				      		<tr>	      			
				      			<td>Max Value : </td>
				      			<td><input type="number" id="modifyMaxValueId" name ="MaxValueRedBoxName" class='form-control' min="1" maxlength="6" onkeypress="return checkVal(event)" oninput="javascript: if (this.value.length > this.maxLength) this.value = this.value.slice(0, this.maxLength); "></td>
				      		</tr>

			      		</tbody>
			      	</table>
			      	</form>
			      </div>
                </div>
                
                <div class="modal-footer"  style="text-align: center;" >
                	<input  type="button"  class="btn btn-primary" value="Update" onclick="modifyData()"  data-dismiss="modal">  <!-- onclick="saveData()" -->
					
                    <button type="reset"  onclick="cancelModify()" class="btn btn-warning" data-dismiss="modal">Cancel</button> 
                    
                </div>
            </div>
        </div>
    </div>
	
	
	<script>
	
	 window.onload = function () { 
		getCustomer();
	}
	
 var table;
 var modelList;
 var vehicleModelArray = [];
 var modelNameSelected;
 var modelIdSelected;
 var custId;
 var customerName;
 var custarray=[];
 var customerDetails; 
 var paramList;
 var allParamList;
 var paramNameArray = [];
 var uid;
 var pName;
 
  
   function getCustomer(){
	$.ajax({
        url: '<%=request.getContextPath()%>/CommonAction.do?param=getCustomer',
          success: function(result) {
 			customerDetails= JSON.parse(result);
			console.log("customerdetails",customerDetails);
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
			getVehicleModel(); 
			}
		}
	});
	}
	
function checkVal(event){
   	if(!((event.keyCode >= 48) && (event.keyCode <= 57) || event.keyCode == 46)){
      		event.returnValue = false;
      		return;
   	}
   	event.returnValue = true;
}
   
<!--function checkSpcialChar(event){-->
<!--    if(!((event.keyCode >= 65) && (event.keyCode <= 90) || (event.keyCode >= 97) && (event.keyCode <= 122) || (event.keyCode >= 48) && (event.keyCode <= 57) || event.keyCode == 45 || event.keyCode == 95)){-->
<!--       event.returnValue = false;-->
<!--       return;-->
<!--    }-->
<!--    event.returnValue = true;-->
<!--}      -->
	
function loadData(){
	getVehicleModel();
	//getDriverScoreGridData();
}
	
function getVehicleModel(){ 
     
  	 vehicleModelArray=[];
  	 for (var i = document.getElementById("vehicleModelDropDownID").length - 1; i >= 1; i--) {
        document.getElementById("vehicleModelDropDownID").remove(i);
	}
	 customerName= document.getElementById("custDropDownId").value;
	// alert(" customerName " + customerName)
	//console.log("customerName",customerName);
	 for (var i = 0; i <custarray.length; i++) {
        if (customerName == customerDetails["CustomerRoot"][i].CustName) {
             custId = customerDetails["CustomerRoot"][i].CustId;
        }
	 }
	 
	
	     $.ajax({
         url: '<%=request.getContextPath()%>/DriverScoreParameterSettingAction.do?param=getVehicleModel',
         data: {
                custId:custId,
                },
         success: function(result) {
             modelList = JSON.parse(result);
             for (var i = 0; i < modelList["vehicleModelDetailsRoot"].length; i++) {
                 vehicleModelArray.push(modelList["vehicleModelDetailsRoot"][i].modelName);
             }

             for (i = 0; i < vehicleModelArray.length; i++) {
                 var opt = document.createElement("option");
                 document.getElementById("vehicleModelDropDownID").options.add(opt);
                 opt.text = vehicleModelArray[i];
                 opt.value = vehicleModelArray[i];
             }
         }
     });
}
	
	
function getDriverScoreGridData(){
		if(document.getElementById("custDropDownId").value==""){
    	  sweetAlert("Select customer");
    	  return;
		}
		if(document.getElementById("vehicleModelDropDownID").value==""){
  		    sweetAlert("Select Vehicle Model");
  		    return;
		}	
	
		customerName= document.getElementById("custDropDownId").value;
		modelName = document.getElementById("vehicleModelDropDownID").value;
	
    	for (var i = 0; i < modelList["vehicleModelDetailsRoot"].length; i++) {
       	 	if (modelName == modelList["vehicleModelDetailsRoot"][i].modelName) {
           	 	modelId = modelList["vehicleModelDetailsRoot"][i].modelTypeId;
     	  	}
   		 }
		if ($.fn.DataTable.isDataTable('#example')) {
    		 $('#example').DataTable().destroy();
    	}
      	for (var i = 0; i <custarray.length; i++) {
	        if (customerName == customerDetails["CustomerRoot"][i].CustName) {
	             custId = customerDetails["CustomerRoot"][i].CustId;
	        }
	    }
   		table = $('#example').DataTable({
         //"processing": true,
         // "serverSide": true,
        // "responsive":true,
         "ajax": {
             "url": '<%=request.getContextPath()%>/DriverScoreParameterSettingAction.do?param=getDriverScoreParameterDetails',
             "data": {
				custId:custId,
				modelId:modelId
             },
             "dataSrc": "DriverScoreParameterRoot"
         },
         "bLengthChange": false,
         "columns": [{
             "data": "slnoIndex"
         }, {
             "data": "uIdIndex",
             "visible": false
         },{
             "data": "vehicleModelIndex"
         },{
         	"data": "parameterNameIndex"
         }, {
             "data": "maxValueIndex"
         }, {
             "data": "minValueIndex"
         }, {
             "data": "typeOfValueIndex"
         },{
             "data": "modifyIndex"
         } 
         ]
     });
     jQuery('.dataTable').wrap('<div class="dataTables_scroll" />');
     
	}

 	$('#example').unbind().on('click', 'td', function(event) {
		var columnIndex = table.cell(this).index().column;
        var aPos = $('#example').dataTable().fnGetPosition(this);
        var data = $('#example').dataTable().fnGetData(aPos[0]);
        pName = (data['parameterNameIndex']);
        var minVal = (data['minValueIndex']);
        var maxVal = (data['maxValueIndex']);
        uid= (data['uIdIndex']);
        $('#modifyParamNameDropDownID').val(pName);
        $('#modifyParamNameDropDownID').attr('readonly', 'true');
        $('#modifyMinValueId').val(minVal);
        $('#modifyMaxValueId').val(maxVal);
	});
	
function openAddModal(){
	paramNameArray=[];
	if(document.getElementById("custDropDownId").value==""){
	      sweetAlert("Select customer");
	}
	if(document.getElementById("vehicleModelDropDownID").value==""){
	      sweetAlert("Select Vehicle Model");
	}

    for (var i = document.getElementById("paramNameDropDownID").length - 1; i >= 1; i--) {
        document.getElementById("paramNameDropDownID").remove(i);
	}
	customerName= document.getElementById("custDropDownId").value;
	for (var i = 0; i <custarray.length; i++) {
       if (customerName == customerDetails["CustomerRoot"][i].CustName) {
            custId = customerDetails["CustomerRoot"][i].CustId;
       }
    }
	    
	modelName = document.getElementById("vehicleModelDropDownID").value;
    for (var i = 0; i < modelList["vehicleModelDetailsRoot"].length; i++) {
        if (modelName == modelList["vehicleModelDetailsRoot"][i].modelName) {
            modelId = modelList["vehicleModelDetailsRoot"][i].modelTypeId;
        }
    }
    var param = {
    	custId:custId,
        modelId: modelId
    }
	
	
	$.ajax({
        url: '<%=request.getContextPath()%>/DriverScoreParameterSettingAction.do?param=getParameterNames',
        data: param,
        success: function(result) {
            paramList = JSON.parse(result);
            for (var i = 0; i < paramList["ParameterNameDetailsRoot"].length; i++) {
                paramNameArray.push(paramList["ParameterNameDetailsRoot"][i].parameterName);
            }
            for (i = 0; i < paramNameArray.length; i++) {
                var opt = document.createElement("option");
                document.getElementById("paramNameDropDownID").options.add(opt);
                opt.text = paramNameArray[i];
                opt.value = paramNameArray[i];
            }
        }
    });

	$('#add').modal('show');
}

function cancel() {
     document.getElementById("paramNameDropDownID").value = "";
     document.getElementById("minValueId").value = "";
     document.getElementById("maxValueId").value = "";
     paramNameArray = [];
}
 
function cancelModify() {
     document.getElementById("modifyParamNameDropDownID").value = "";
     document.getElementById("modifyMinValueId").value = "";
     document.getElementById("modifyMaxValueId").value = "";
     paramNameArray = [];
}
	
function saveData(){
	customerName= document.getElementById("custDropDownId").value;
	modelName = document.getElementById("vehicleModelDropDownID").value;
	var paramName = document.getElementById("paramNameDropDownID").value;
	var maxValue = document.getElementById("maxValueId").value;
	var minValue = document.getElementById("minValueId").value;
	if (customerName == "") {
         sweetAlert("Please select customer");
         return;
     } else if (paramName == "") {
         sweetAlert("Please select parameter name");
         return;
     } else if (modelName == "") {
         sweetAlert("Please select vehicle model");
         return;
     } else if (maxValue == "") {
         sweetAlert("Please enter max value");
         return;
     }  else if (minValue == "") {
         sweetAlert("Please enter min value");
         return;
     } else if (parseFloat(minValue) >= parseFloat(maxValue)) {
         sweetAlert("MAX value must be greater than MIN value");
         return;
     }
	 for (var i = 0; i <custarray.length; i++) {
       	if (customerName == customerDetails["CustomerRoot"][i].CustName) {
            custId = customerDetails["CustomerRoot"][i].CustId;
      	}
	 }
	    
    for (var i = 0; i < modelList["vehicleModelDetailsRoot"].length; i++) {
        if (modelName == modelList["vehicleModelDetailsRoot"][i].modelName) {
            modelId = modelList["vehicleModelDetailsRoot"][i].modelTypeId;
        }
    }
    
    var param = {
    	custId: custId,
        modelId: modelId,
        paramName: paramName,
        maxValue: maxValue,
        minValue: minValue
    }
     $.ajax({
             url: '<%=request.getContextPath()%>/DriverScoreParameterSettingAction.do?param=saveDriverScoreParameters',
             data: param,
             success: function(result) {
				 
                 if (result == "Saved Successfully") {
                     sweetAlert("Saved Successfully");
                     $('#add').modal('hide');
                     setTimeout(function() {
                         getDriverScoreGridData();
                         document.getElementById("paramNameDropDownID").value = "";
                         //  document.getElementById("vehicleModelDropDownID").value = "";
                         document.getElementById("minValueId").value = "";
                         document.getElementById("maxValueId").value = "";
                         paramNameArray = [];
                     }, 1000);
                 } else {
                     sweetAlert(result);
                     $('#add').modal('hide');
					getDriverScoreGridData();
                     document.getElementById("paramNameDropDownID").value = "";
                     // document.getElementById("vehicleModelDropDownID").value = "";
                     document.getElementById("minValueId").value = "";
                     document.getElementById("maxValueId").value = "";
                     paramNameArray = [];
                 }
             }
         })
	}
	
	function modifyData(){
		customerName= document.getElementById("custDropDownId").value;
	    for (var i = 0; i <custarray.length; i++) {
	        if (customerName == customerDetails["CustomerRoot"][i].CustName) {
	             custId = customerDetails["CustomerRoot"][i].CustId;
	        }
	    }
	    
	var modifyMaxValue = document.getElementById("modifyMaxValueId").value;
	var modifyMinValue = document.getElementById("modifyMinValueId").value;
	var uniqueId=uid;
	var modifyParamName=pName;
	
	if (customerName == "") {
         sweetAlert("Please select customer");
         return;
     } else if (modifyMaxValue == "") {
         sweetAlert("Please enter max value");
         return;
     }  else if (modifyMinValue == "") {
         sweetAlert("Please enter min value");
         return;
     } else if (parseFloat(modifyMinValue) >= parseFloat(modifyMaxValue)) {
         sweetAlert("MAX value must be greater than MIN value");
         return;
     }
	var param = {
    	custId: custId,
        uniqueId: uniqueId,
        modifyMaxValue: modifyMaxValue,
        modifyMinValue: modifyMinValue,
        modifyParamName:modifyParamName
    }
     $.ajax({
             url: '<%=request.getContextPath()%>/DriverScoreParameterSettingAction.do?param=modifyDriverScoreParameters',
             data: param,
             success: function(result) {
				 
                 if (result == "Updated Successfully") {
                     sweetAlert("Updated Successfully");
                     $('#modify').modal('hide');
                     getDriverScoreGridData();
                     setTimeout(function() {
                         document.getElementById("modifyParamNameDropDownID").value = "";
                         //  document.getElementById("vehicleModelDropDownID").value = "";
                         document.getElementById("modifyMinValueId").value = "";
                         document.getElementById("modifyMaxValueId").value = "";
                         paramNameArray = [];
                         modifyParamName="";
                     }, 1000);
                 } else {
                     sweetAlert(result);
                     $('#modify').modal('hide');
                     getDriverScoreGridData();
                     document.getElementById("modifyParamNameDropDownID").value = "";
                     // document.getElementById("vehicleModelDropDownID").value = "";
                     document.getElementById("modifyMinValueId").value = "";
                     document.getElementById("modifyMaxValueId").value = "";
                     paramNameArray = [];
                     modifyParamName="";
                 }
             }
         })
	}
 </script>
<jsp:include page="../Common/footer.jsp" />
	<!-- </body>   -->
<!-- </html> -->
