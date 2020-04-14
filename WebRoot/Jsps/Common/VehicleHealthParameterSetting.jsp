<%@ page language="java"
	import="java.util.*,t4u.functions.CommonFunctions,t4u.beans.*,t4u.common.*"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://packtag.sf.net" prefix="pack"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://"
			+ request.getServerName() + ":" + request.getServerPort()
			+ path + "/";
	CommonFunctions cf = new CommonFunctions();
	LoginInfoBean loginInfo = (LoginInfoBean) session
			.getAttribute("loginInfoDetails");
	if (loginInfo != null) {
	} else {
		response.sendRedirect(request.getContextPath()
				+ "/Jsps/Common/SessionDestroy.html");
	}
	String PageName = "";
	PageName = "Vehicle Health Parameter Setting";
%>

<!doctype html>
<html>
<head>
    <title>Vehicle Health Parameter Setting</title>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.datatables.net/1.10.16/css/dataTables.bootstrap.min.css">
    <link rel="stylesheet" href="http://ajax.googleapis.com/ajax/libs/jqueryui/1.11.1/themes/ui-darkness/jquery-ui.min.css" rel="stylesheet">
    <link rel="stylesheet" href="../../Main/sweetAlert/sweetalert.css">
    <script src="https://code.jquery.com/jquery-1.12.4.js"></script>
    <script src="../../Main/Js/jquery.validate.min.js"></script>
    <script src="https://cdn.datatables.net/1.10.16/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.datatables.net/1.10.16/js/dataTables.bootstrap.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
    <script src="../../Main/sweetAlert/sweetalert-dev.js"></script> 
    
    <style>
#title{
    font-weight: 600;
    font-size: 25px;
    color: dodgerblue;
}
#example_filter{
   margin-top: -40px;
}
.modal-body {
    position: relative;
    overflow-y: hidden;
    max-height: 500px;
    padding: 15px;
}
.form-control1 {
    display: block;
    width: 20%;
    height: 34px;
    padding: 6px 12px;
    font-size: 14px;
    line-height: 1.42857143;
    color: #555;
    background-color: #fff;
    background-image: none;
    border: 1px solid #ccc;
    border-radius: 4px;
    -webkit-box-shadow: inset 0 1px 1px rgba(0,0,0,.075);
    box-shadow: inset 0 1px 1px rgba(0,0,0,.075);
    -webkit-transition: border-color ease-in-out .15s,-webkit-box-shadow ease-in-out .15s;
    -o-transition: border-color ease-in-out .15s,box-shadow ease-in-out .15s;
    transition: border-color ease-in-out .15s,box-shadow ease-in-out .15s;
}
</style>

</head>
<body onload="LoadData()">
    <div class="col-lg-12">
        <div class="col-lg-12">
            <div class="panel panel-default">
                <div class="panel-heading" id="title">
                    Vehicle Health Parameter Setting
				</div>
                <div class="panel-body">
                    <p>
                         <label> Model Name: </label>
                         <select class="form-control1" id="vehicleModelDropDownID" onchange="getVehicleModelDetails(); " >
						    <option style="display: none"></option> 
						  </select>
						  
					   <button title="ADD" data-toggle="modal" class="btn btn-info btn-md" onclick="addVehicleParameter() ">ADD</button>  <!--data-target="#add" -->
                    </p>
                    <table id="example" class="table table-striped table-bordered" cellspacing="0" width="100%">
                        <thead>
                            <tr>
 								<th>ID</th>                           
                                <th>PARAMETER NAME</th>
                                <th>HIGH ATTENTION MIN</th>				<!-- Min RED value -->
                                <th>HIGH ATTENTION MAX</th>
<!--                                <th>DISTANCE</th>-->
                                <th>NEAR TO THRESHOLD MIN</th>			<!-- Min YELLOW value -->
                                <th>NEAR TO THRESHOLD MAX</th>
<!--                                <th>DISTANCE</th>-->
                                <th>BACK TO NORMAL MIN</th>				<!-- Min GREEN value -->
                                <th>BACK TO NORMAL MAX</th>
<!--                                <th>DISTANCE</th>-->
                                <th>MODIFY</th>
                            </tr>
                        </thead>

                    </table>
                </div>
                <!-- /.panel-body -->
            </div>
            <!-- /.panel -->
        </div>
    </div>
    	<div id="add" class="modal fade" style="margin-right: 12%;">
        <div class="modal-dialog" style="position: absolute;left: 27%;top: 44%;margin-top: -250px;width:725px;">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                    <h4 id="nome" class="modal-title">Add Vehicle Health Parameters</h4>
                </div>
                <div class="modal-body" style="max-height: 50%;">
		           <div class="col-md-12">
		           <form  method="post" id="register-form" name = "register-form" >
			      	<table class="table table-sm table-bordered table-striped">
			      		<tbody>
							<tr>	      			
				      			<td>Model Name : </td>
				      			<td><input type="text" id="vehicleModelNameId" class='form-control'></td>
				      		</tr>
							<tr>	      			
				      			<td>Parameter Name : </td>
				      			<td><select class="form-control" id="paramNameDropDownID" data-live-search="true" required="required">
									<option> </option>
									</select></td>
				      		</tr>
							<tr>	      			
				      			<td>High Attention Min</td>
				      			<td><input type="number" id="MinValueRedBoxId" name ="MinValueRedBoxName" class='form-control'></td>
				      		</tr>
				      		<tr>	      			
				      			<td>High Attention Max</td>
				      			<td><input type="number" id="MaxValueRedBoxId" name ="MaxValueRedBoxName" class='form-control'></td>
				      		</tr>
				      		<tr>	      			
				      			<td>Near to Threshold Min</td>
				      			<td><input type="number" id="MinValueYellowBoxId" name ="MinValueYellowBoxName" class='form-control'></td>
				      		</tr>
				      		<tr>	      			
				      			<td>Near to Threshold Max</td>
				      			<td><input type="number" id="MaxValueYellowBoxId" name ="MinValueYellowBoxName" class='form-control'></td>
				      		</tr>
				      		<tr>	      			
				      			<td>Back to Normal Min</td>
				      			<td><input type="number" id="MinValueGreenBoxId" name ="MinValueGreenBoxName" class='form-control'></td>
				      		</tr>
				      		<tr>	      			
				      			<td>Back to Normal Max</td>
				      			<td><input type="number" id="MaxValueGreenBoxId" name ="MinValueGreenBoxName" class='form-control'></td>
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
        <div class="modal-dialog" style="position: absolute;left: 27%;top: 44%;margin-top: -250px;width:725px;">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                    <h4 id="nome" class="modal-title">Modify Vehicle Health Parameters</h4>
                </div>
                <div class="modal-body" style="max-height: 50%;">
		           <div class="col-md-12">
			      	<table class="table table-sm table-bordered table-striped">
			      		<tbody>
							<tr>	      			
				      			<td>Model Name : </td>
				      			<td><input type="text" id="modifyVehicleModelNameId" class='form-control'></td>
				      		</tr>
							<tr>	      			
				      			<td>Parameter Name : </td>
				      			<td><input type="text" id="modifyParamNameDropDownID" class='form-control'">
									</td>
				      		</tr>
							<tr>	      			
				      			<td>High Attention Min</td>
				      			<td><input type="number" id="modifyMinValueRedBoxId" class='form-control' ></td>
				      		</tr>
				      		<tr>	      			
				      			<td>High Attention Max</td>
				      			<td><input type="number" id="modifyMaxValueRedBoxId" class='form-control'></td>
				      		</tr>
				      		<tr>	      			
				      			<td>Near to Threshold Min</td>
				      			<td><input type="number" id="modifyMinValueYellowBoxId" class='form-control'></td>
				      		</tr>
				      		<tr>	      			
				      			<td>Near to Threshold Max</td>
				      			<td><input type="number" id="modifyMaxValueYellowBoxId" class='form-control'></td>
				      		</tr>
				      		<tr>	      			
				      			<td>Back to Normal Min</td>
				      			<td><input type="number" id="modifyMinValueGreenBoxId" class='form-control'></td>
				      		</tr>
				      		<tr>	      			
				      			<td>Back to Normal Max</td>
				      			<td><input type="number" id="modifyMaxValueGreenBoxId" class='form-control'></td>
				      		</tr>

			      		</tbody>
			      	</table>
			      </div>
                </div>
                <div class="modal-footer"  style="text-align: center;">
                	<input onclick="modifyAndSaveData()" type="button" class="btn btn-primary" value="Save" />
                    <button type="reset"  onclick="cancelModify()" class="btn btn-warning" data-dismiss="modal">Cancel</button> 
                    
                </div>
            </div>
        </div>
    </div>
    
  <script>
 var pageName = '<%=PageName%>'
 var modelList;
 var paramList;
 var allParamList;
 var paramNameArray = [];
 var vehicleModelArray = [];
 var modelNameSelected;
 var modelIdSelected;
 var table;
 var dataForHistoryTable;
 var paramIdForModify = 0;

 function getVehicleModelDetails() {
     if ($.fn.DataTable.isDataTable('#example')) {
         $('#example').DataTable().destroy();
     }
     modelNameSelected = $("#vehicleModelDropDownID").val();
     for (var i = 0; i < modelList["vehicleModelDetailsRoot"].length; i++) {
         if (modelNameSelected == modelList["vehicleModelDetailsRoot"][i].modelName) {
             modelIdSelected = modelList["vehicleModelDetailsRoot"][i].modelTypeId;
         }
     }
     table = $('#example').DataTable({
         "processing": true,
         "serverSide": true,
         "bPaginate": false,
         "bInfo": false,
         "ajax": {
             "url": "<%=request.getContextPath()%>/vehicleHealthParameterSettingAction.do?param=getVehicleParameterDetails",
             "data": {
                 ModelIdSelected: modelIdSelected
             },
             "dataSrc": "vehicleParameterDetailsRoot"
         },
         "bLengthChange": false,
         "columns": [{
                 "data": "parameterId"
             }, {
                 "data": "parameterName"
             }, {
                 "data": "minValueRed"
             }, {
                 "data": "maxValueRed"
             },
             <!--          {-->
             <!--         	 "data": "distanceRed"-->
             <!--         }, -->
             {
                 "data": "minValueYellow"
             }, {
                 "data": "maxValueYellow"
             },
             <!--          {-->
             <!--         	 "data": "distanceYellow"-->
             <!--         },-->
             {
                 "data": "minValueGreen"
             }, {
                 "data": "maxValueGreen"
             },
             <!--          {-->
             <!--         	 "data": "distanceGreen"-->
             <!--         },-->
             {
                 "defaultContent": "<button class='btn btn-info btn-md' onclick='modifyVehicleParameter()'>Modify</button>"
             }
         ]
     });
     table.column(0).visible(false);
 }
 
 function addVehicleParameter() {
    var modelName = "";
    var modelId = "";
    paramNameArray = [];
    paramlist = "";
    modelName = document.getElementById("vehicleModelDropDownID").value;
    if (modelName == "") {
        sweetAlert("Please select vehicle model");
        return;
    }
    for (var i = document.getElementById("paramNameDropDownID").length - 1; i >= 1; i--) {
        document.getElementById("paramNameDropDownID").remove(i);
    }
    for (var i = 0; i < modelList["vehicleModelDetailsRoot"].length; i++) {
        if (modelName == modelList["vehicleModelDetailsRoot"][i].modelName) {
            modelId = modelList["vehicleModelDetailsRoot"][i].modelTypeId;
        }
    }
    var param = {
        modelId: modelId
    }
    $.ajax({
        url: '<%=request.getContextPath()%>/vehicleHealthParameterSettingAction.do?param=getParameterNames',
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
    $("#vehicleModelNameId").val(modelName);
    $('#vehicleModelNameId').attr('readonly', 'true');
}
 
 function saveData() {
     var paramName;
     var paramId;
     var vehicleModelName;
     var vehicleModelId;
     var val = [];
     var minValueRed;
     var maxValueRed;
     var minValueYellow;
     var maxValueYellow;
     var minValueGreen;
     var maxValueGreen;

     paramName = document.getElementById("paramNameDropDownID").value;
     vehicleModelName = document.getElementById("vehicleModelDropDownID").value;
     for (var i = 0; i < modelList["vehicleModelDetailsRoot"].length; i++) {
         if (vehicleModelName == modelList["vehicleModelDetailsRoot"][i].modelName) {
             vehicleModelId = modelList["vehicleModelDetailsRoot"][i].modelTypeId;
         }
     }
     if (paramName == "") {
         sweetAlert("Please select parameter name");
         return;
     }
     for (var i = 0; i < paramList["ParameterNameDetailsRoot"].length; i++) {
         if (paramName == paramList["ParameterNameDetailsRoot"][i].parameterName) {
             paramId = paramList["ParameterNameDetailsRoot"][i].parameterId;
         }
     }
     minValueRed = document.getElementById("MinValueRedBoxId").value;
     maxValueRed = document.getElementById("MaxValueRedBoxId").value;
     minValueYellow = document.getElementById("MinValueYellowBoxId").value;
     maxValueYellow = document.getElementById("MaxValueYellowBoxId").value;
     minValueGreen = document.getElementById("MinValueGreenBoxId").value;
     maxValueGreen = document.getElementById("MaxValueGreenBoxId").value;
     if (vehicleModelName == "") {
         sweetAlert("Please select vehicle model");
         return;
     } else if (paramName == "") {
         sweetAlert("Please select parameter name");
         return;
     } else if (minValueRed == "") {
         sweetAlert("Please enter High Attention min value");
         return;
     } else if (maxValueRed == "") {
         sweetAlert("Please enter High Attention max value");
         return;
     } else if (minValueYellow == "") {
         sweetAlert("Please enter Near to Threshold min value");
         return;
     } else if (maxValueYellow == "") {
         sweetAlert("Please enter Near to Threshold max value");
         return;
     } else if (minValueGreen == "") {
         sweetAlert("Please enter Back to Normal min value");
         return;
     } else if (minValueGreen == "") {
         sweetAlert("Please enter Back to Normal max value");
         return;
     } else if (maxValueYellow <= minValueYellow || maxValueGreen <= minValueGreen) {
         sweetAlert("MAX value must be greater than MIN value");
         return;
     } else if (minValueRed <= maxValueYellow || minValueRed <= minValueYellow) {
         sweetAlert("High Attention value must be greater than Near to Threshold value");
         return;
     } else if (minValueRed <= maxValueGreen || minValueRed <= minValueGreen) {
         sweetAlert("High Attention value must be greater than Back to Normal value");
         return;
     } else if (minValueYellow <= maxValueGreen || minValueYellow <= minValueGreen || maxValueYellow <= maxValueGreen || maxValueYellow <= minValueGreen) {
         sweetAlert("Near to Threshold value must be greater than Back to Normal value");
         return;
     } else {
         var param = {
             paramId: paramId,
             vehicleModelId: vehicleModelId,
             minValueRed: minValueRed,
             maxValueRed: maxValueRed,
             minValueYellow: minValueYellow,
             maxValueYellow: maxValueYellow,
             minValueGreen: minValueGreen,
             maxValueGreen: maxValueGreen,
         };
         $.ajax({
             url: '<%=request.getContextPath()%>/vehicleHealthParameterSettingAction.do?param=saveVehicleHealthParameters',
             data: param,
             success: function(result) {
                 if (result == "Saved Successfully") {
                     sweetAlert("Saved Successfully");
                     $('#add').modal('hide');
                     setTimeout(function() {
                         getVehicleModelDetails();
                         document.getElementById("paramNameDropDownID").value = "";
                         //  document.getElementById("vehicleModelDropDownID").value = "";
                         document.getElementById("MinValueRedBoxId").value = "";
                         document.getElementById("MaxValueRedBoxId").value = "";
                         document.getElementById("MinValueYellowBoxId").value = "";
                         document.getElementById("MaxValueYellowBoxId").value = "";
                         document.getElementById("MinValueGreenBoxId").value = "";
                         document.getElementById("MaxValueGreenBoxId").value = "";
                         paramNameArray = [];
                     }, 1000);
                 } else {
                     sweetAlert(result);
                     $('#add').modal('hide');
                     getVehicleModelDetails();
                     document.getElementById("paramNameDropDownID").value = "";
                     // document.getElementById("vehicleModelDropDownID").value = "";
                     document.getElementById("MinValueRedBoxId").value = "";
                     document.getElementById("MaxValueRedBoxId").value = "";
                     document.getElementById("MinValueYellowBoxId").value = "";
                     document.getElementById("MaxValueYellowBoxId").value = "";
                     document.getElementById("MinValueGreenBoxId").value = "";
                     document.getElementById("MaxValueGreenBoxId").value = "";
                     paramNameArray = [];
                 }
             }
         })
     } //else
 }

 function cancel() {
     document.getElementById("paramNameDropDownID").value = "";
     document.getElementById("MinValueRedBoxId").value = "";
     document.getElementById("MaxValueRedBoxId").value = "";
     document.getElementById("MinValueYellowBoxId").value = "";
     document.getElementById("MaxValueYellowBoxId").value = "";
     document.getElementById("MinValueGreenBoxId").value = "";
     document.getElementById("MaxValueGreenBoxId").value = "";
     paramNameArray = [];

 }
    
function modifyVehicleParameter() {
    var modelName = "";
    var modelId = "";
    var paramName = "";
    var data = [];
    dataForHistoryTable = [];
    modelName = document.getElementById("vehicleModelDropDownID").value;
    for (var i = 0; i < modelList["vehicleModelDetailsRoot"].length; i++) {
        if (modelName == modelList["vehicleModelDetailsRoot"][i].modelName) {
            modelId = modelList["vehicleModelDetailsRoot"][i].modelTypeId;

        }
    }
    var paramModelId = {
        modelId: modelId
    }
    $('#modify').modal('show');
    $("#modifyVehicleModelNameId").val(modelName);
    $('#modifyVehicleModelNameId').attr('readonly', 'true');
    $('#example tbody').on('click', 'button', function() {

        data = table.row($(this).parents('tr')).data();
        paramName = data['parameterName'];
        paramIdForModify = data['parameterId'];
        $("#modifyParamNameDropDownID").val(data['parameterName']);
        $('#modifyParamNameDropDownID').attr('readonly', 'true');
        $("#modifyMinValueRedBoxId").val(data['minValueRed']);
        $("#modifyMaxValueRedBoxId").val(data['maxValueRed']);
        $("#modifyMinValueYellowBoxId").val(data['minValueYellow']);
        $("#modifyMaxValueYellowBoxId").val(data['maxValueYellow']);
        $("#modifyMinValueGreenBoxId").val(data['minValueGreen']);
        $("#modifyMaxValueGreenBoxId").val(data['maxValueGreen']);
        dataForHistoryTable.push('{' + data['minValueRed'] + ',' + data['maxValueRed'] + ',' + data['minValueYellow'] + ',' + data['maxValueYellow'] + ',' + data['minValueGreen'] + ',' + data['maxValueGreen'] + '}');
    });
}

function modifyAndSaveData() {
    var vehicleModelName;
    var vehicleModelId;
    var val = [];
    var newMinValueRed;
    var newMaxValueRed;
    var newMinValueYellow;
    var newMaxValueYellow;
    var newMinValueGreen;
    var newMaxValueGreen;

    vehicleModelName = document.getElementById("vehicleModelDropDownID").value;
    for (var i = 0; i < modelList["vehicleModelDetailsRoot"].length; i++) {
        if (vehicleModelName == modelList["vehicleModelDetailsRoot"][i].modelName) {
            vehicleModelId = modelList["vehicleModelDetailsRoot"][i].modelTypeId;
        }
    }
    newMinValueRed = document.getElementById("modifyMinValueRedBoxId").value;
    newMaxValueRed = document.getElementById("modifyMaxValueRedBoxId").value;
    newMinValueYellow = document.getElementById("modifyMinValueYellowBoxId").value;
    newMaxValueYellow = document.getElementById("modifyMaxValueYellowBoxId").value;
    newMinValueGreen = document.getElementById("modifyMinValueGreenBoxId").value;
    newMaxValueGreen = document.getElementById("modifyMaxValueGreenBoxId").value;
    if (vehicleModelName == "") {
        sweetAlert("Please select vehicle model");
        return;
    } else if (newMinValueRed == "") {
        sweetAlert("Please enter High Attention min value");
        return;
    } else if (newMaxValueRed == "") {
        sweetAlert("Please enter High Attention max value");
        return;
    } else if (newMinValueYellow == "") {
        sweetAlert("Please enter Near to Threshold min value");
        return;
    } else if (newMaxValueYellow == "") {
        sweetAlert("Please enter Near to Threshold max value");
        return;
    } else if (newMinValueGreen == "") {
        sweetAlert("Please enter Back to Normal min value");
        return;
    } else if (newMaxValueGreen == "") {
        sweetAlert("Please enter Back to Normal max value");
        return;
    } else if (newMaxValueYellow <= newMinValueYellow || newMaxValueGreen <= newMinValueGreen) {
        sweetAlert("MAX value must be greater than MIN value");
        return;
    } else if (newMinValueRed <= newMaxValueYellow || newMinValueRed <= newMinValueYellow) {
        sweetAlert("High Attention value must be greater than Near to Threshold value");
        return;
    } else if (newMinValueRed <= newMaxValueGreen || newMinValueRed <= newMaxValueGreen) {
        sweetAlert("High Attention value must be greater than Back to Normal value");
        return;
    } else if (newMinValueYellow <= newMaxValueGreen || newMinValueYellow <= newMinValueGreen || newMaxValueYellow <= newMaxValueGreen || newMaxValueYellow <= newMinValueGreen) {
        sweetAlert("Near to Threshold value must be greater than Back to Normal value");
        return;

    } else {

        var historyTableData = JSON.stringify(dataForHistoryTable);
        var param = {
            paramId: paramIdForModify,
            vehicleModelId: vehicleModelId,
            minValueRed: newMinValueRed,
            maxValueRed: newMaxValueRed,
            minValueYellow: newMinValueYellow,
            maxValueYellow: newMaxValueYellow,
            minValueGreen: newMinValueGreen,
            maxValueGreen: newMaxValueGreen,
            historyDataJson: historyTableData
        };

        $.ajax({
            url: '<%=request.getContextPath()%>/vehicleHealthParameterSettingAction.do?param=updateVehicleHealthParameters',
            data: param,
            success: function(result) {
                if (result == "Updated Successfully") {
                    sweetAlert("Updated Successfully");
                    $('#modify').modal('hide');
                    setTimeout(function() {
                        getVehicleModelDetails();
                        document.getElementById("modifyParamNameDropDownID").value = "";
                        document.getElementById("modifyVehicleModelNameId").value = "";
                        document.getElementById("modifyMinValueRedBoxId").value = "";
                        document.getElementById("modifyMaxValueRedBoxId").value = "";
                        document.getElementById("modifyMinValueYellowBoxId").value = "";
                        document.getElementById("modifyMaxValueYellowBoxId").value = "";
                        document.getElementById("modifyMinValueGreenBoxId").value = "";
                        document.getElementById("modifyMaxValueGreenBoxId").value = "";
                        dataForHistoryTable = [];
                    }, 1000);
                } else {
                    sweetAlert(result);
                    $('#modify').modal('hide');
                    getVehicleModelDetails();
                    document.getElementById("modifyParamNameDropDownID").value = "";
                    document.getElementById("modifyVehicleModelNameId").value = "";
                    document.getElementById("modifyMinValueRedBoxId").value = "";
                    document.getElementById("modifyMaxValueRedBoxId").value = "";
                    document.getElementById("modifyMinValueYellowBoxId").value = "";
                    document.getElementById("modifyMaxValueYellowBoxId").value = "";
                    document.getElementById("modifyMinValueGreenBoxId").value = "";
                    document.getElementById("modifyMaxValueGreenBoxId").value = "";
                    dataForHistoryTable = [];
                }
            }
        }) //ajax
    } //else
}

function cancelModify() {
    document.getElementById("modifyParamNameDropDownID").value = "";
    document.getElementById("modifyVehicleModelNameId").value = "";
    document.getElementById("modifyMinValueRedBoxId").value = "";
    document.getElementById("modifyMaxValueRedBoxId").value = "";
    document.getElementById("modifyMinValueYellowBoxId").value = "";
    document.getElementById("modifyMaxValueYellowBoxId").value = "";
    document.getElementById("modifyMinValueGreenBoxId").value = "";
    document.getElementById("modifyMaxValueGreenBoxId").value = "";
    dataForHistoryTable = [];

}

 function LoadData() {
     $.ajax({
         url: '<%=request.getContextPath()%>/vehicleHealthParameterSettingAction.do?param=getVehicleModel',
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
  </script>
 </body>
</html>
