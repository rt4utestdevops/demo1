<%@ page language="java"
	import="java.util.*,t4u.functions.CommonFunctions,t4u.beans.*,t4u.common.*"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://packtag.sf.net" prefix="pack"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";

CommonFunctions cf = new CommonFunctions();
	LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
	int customerId=0;
if(loginInfo != null){

			}
else 
 {
 	response.sendRedirect(request.getContextPath()+ "/Jsps/Common/SessionDestroy.html");
 	
 }
%>
<!--<!doctype html>-->
<!--<html lang="en">-->
<!--   <head>-->
<!--      <title>Vehicle Maintenance Report</title>-->
<!--      <meta charset="utf-8">-->
<!--      <meta name="viewport" content="width=device-width, initial-scale=1">-->
 <jsp:include page="../Common/header.jsp" />
      <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
      <link href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" rel="stylesheet">
      <link href="https://cdn.datatables.net/1.10.16/css/dataTables.bootstrap.min.css" rel="stylesheet">
      <link href="https://cdn.datatables.net/fixedcolumns/3.2.3/css/fixedColumns.dataTables.min.css" rel="stylesheet">
      <link href="https://cdn.datatables.net/select/1.2.3/css/select.dataTables.min.css" rel="stylesheet"/>
      <link href="https://cdn.datatables.net/buttons/1.5.0/css/buttons.bootstrap.min.css" rel="stylesheet"/>
      <link href="../../Main/sweetAlert/sweetalert.css" rel="stylesheet">
      <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
      <script src="//ajax.googleapis.com/ajax/libs/jquery/1.11.2/jquery.min.js"></script>
      <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
      <script src="https://cdn.datatables.net/1.10.16/js/jquery.dataTables.min.js"></script>
      <script src="https://cdn.datatables.net/1.10.16/js/dataTables.bootstrap4.min.js"></script>
      <script src="https://cdn.datatables.net/buttons/1.4.2/js/dataTables.buttons.min.js"></script>
      <script src="https://cdn.datatables.net/buttons/1.4.2/js/buttons.html5.min.js"></script>
      <script src = "https://cdn.datatables.net/select/1.2.3/js/dataTables.select.min.js"></script>
      <script src="https://cdn.datatables.net/fixedcolumns/3.2.3/js/dataTables.fixedColumns.min.js"></script>
      <!--      <script src="https://code.jquery.com/jquery-1.12.4.js"></script>-->
      <script src="https://cdnjs.cloudflare.com/ajax/libs/jszip/3.1.3/jszip.min.js"></script>
      <script src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.32/pdfmake.min.js"></script>
      <script src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.32/vfs_fonts.js"></script>
      <script type="text/javascript" src="https://cdn.datatables.net/buttons/1.4.2/js/buttons.bootstrap.min.js"></script>
      <script type="text/javascript" src="//cdn.datatables.net/buttons/1.4.2/js/buttons.colVis.min.js"></script>
      <script src="https://cdn.datatables.net/buttons/1.4.2/js/buttons.flash.min.js"></script>
      <script src="../../Main/sweetAlert/sweetalert.min.js"></script>
      <link href="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.6-rc.0/css/select2.min.css" rel="stylesheet" />
	  <script src="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.6-rc.0/js/select2.min.js"></script>
      
      <script src="https://www.jqwidgets.com/public/jqwidgets/jqx-all.js"></script>
	  <script src="https://www.jqwidgets.com/public/jqwidgets/globalization/globalize.js"></script>
	  <link rel="stylesheet" href="https://www.jqwidgets.com/public/jqwidgets/styles/jqx.base.css">
	  <link rel="stylesheet" href="https://www.jqwidgets.com/public/jqwidgets/styles/jqx.energyblue.css">
	  <link rel="stylesheet" href="https://www.jqwidgets.com/public/jqwidgets/styles/jqx.arctic.css">
	  <link href="https://cdn.datatables.net/buttons/1.4.2/css/buttons.bootstrap.min.css" rel="stylesheet">
	
      <style>
         .custom{
         padding-left: 15px;
         padding-right: 15px;
         margin-left: auto;
         margin-right: auto;
         padding-top: 10px;
         }
         .modal-open .modal {
         overflow-x: hidden;
         overflow-y: hidden;
         }
         .modalEdit {
         position: fixed;
         top: 5%;	
         left: 8%;
         z-index: 1050;
         width: 81%;
         bottom:unset;
         background-color: #ffffff;
         border: 1px solid #999;
         border: 1px solid rgba(0, 0, 0, 0.3);
         -webkit-border-radius: 6px;
         -moz-border-radius: 6px;
         border-radius: 6px;
         -webkit-box-shadow: 0 3px 7px rgba(0, 0, 0, 0.3);
         -moz-box-shadow: 0 3px 7px rgba(0, 0, 0, 0.3);
         box-shadow: 0 3px 7px rgba(0, 0, 0, 0.3);
         -webkit-background-clip: padding-box;
         -moz-background-clip: padding-box;
         background-clip: padding-box;
         outline: none;
         }
         table.table-bordered.dataTable th:last-child, table.table-bordered.dataTable th:last-child, table.table-bordered.dataTable td:last-child, table.table-bordered.dataTable td:last-child {
         border-right-width: 1px;
         }
         #editableGrid_filter{
         margin-top: -34px;
         }
         #example_filter{
         margin-top: -34px;
         }
         .select2-container{
         	width:433px !important;
         }
         
         .table-striped>tbody>tr:nth-of-type(odd) {
					background-color: #f9f9f9;
					height: 20px !important;
		  }
		  
      </style>
<!--   </head>-->
<!--   <body onload="getCustomers();">-->
      <div class="custom">
         <div class="panel panel-primary">
            <div class="panel-heading">
               <h3 class="panel-title" >
                 Material Master
               </h3>
            </div>
            <div class="panel-body">
               <div class="panel row" style="padding:1% ;margin: 0%;">
                  <div class="row" style="width: 70%;">
                     <div class="col-xs-3 col-md-3 col-lg-3 col-sm-3 ">
                        <select class="form-control" id="custNames">
                           <option value="">Select Customer Name</option>
                        </select>
                     </div>
                     <button title="View" class=" col-lg-1 col-md-1 col-sm-1 col-xs-1 btn btn-primary" onclick="viewDetails();" >View</button>
                     <div class="col-lg-1 col-md-1 col-sm-1 col-xs-1" ></div>
                     <button  title="ADD" class="col-lg-1 col-md-1 col-sm-1 col-xs-1 btn  btn-primary" onclick="addMaterialMaster();" style="margin-left:-6%">Add</button>	
                  </div>
               </div>
               <!--End of header Panel-->
               <div class="col-sm-12 col-md-12" style="overflow: auto !important;">
                  <table id="example" class="table table-striped table-bordered" cellspacing="0" width="100%" style="margin-top:1%">
                     <thead>
                        <tr>
                           <th >Sl No</th>
                           <th >ID</th>
                           <th >Material Name</th>
                           <th >Edit</th>
                           <th >Delete</th>
                        </tr>
                       
                     </thead>
                  </table>
               </div>
               <!-- end of table -->
            </div>
            <!-- end of panel body -->
         </div>
         <!-- end of panel  -->
      </div>
      <!-- end of main div : custom -->
      <div id="add" class="modal fade" >
         <div class="" style="position: absolute;left: 27%;top: 44%;margin-top: -250px;width:725px;">
            <div class="modal-content">
               <div class="modal-header">
                  <h4 id="nome" class="modal-title">Add Material </h4>
				   <button type="button" class="close" data-dismiss="modal" style="margin-top: -8px;">&times;</button>
               </div>
               <div class="modal-body" style="max-height: 50%;margin-bottom: -35px;">
                  <div class="col-md-12">
                     <table class="table table-sm table-bordered table-striped">
                        <tbody>
                           <tr>
                              <td>Material Name<sup><font color="red">&nbsp;*</font></sup></td>
                              <td>
                             		 <input type='text'  id="materialNameId"  />
                              </td>
                           </tr>
                        </tbody>
                     </table>
                  </div>
               </div>
               <div class="modal-footer"  style="text-align: center;">
                  <input id="save1" onclick="saveData()" type="button" class="btn btn-success" value="Save" />
                  <button type="reset" class="btn btn-danger" data-dismiss="modal">Cancel</button> 
               </div>
            </div>
         </div>
      </div>

       <div id="editMaterial" class="modal fade" >
         <div class="modal-dialog" style="position: absolute;left: 27%;top: 44%;margin-top: -250px;width:725px;">
            <div class="modal-content">
               <div class="modal-header">
                  <button type="button" class="close" data-dismiss="modal">&times;</button>
                  <h4 id="nome" class="modal-title">Update Material Details</h4>
               </div>
               <div class="modal-body" style="max-height: 50%;margin-bottom: -35px;">
                  <div class="col-md-12">
                     <table class="table table-sm table-bordered table-striped">
                        <tbody>
                        <tr style="display:none;">
                              <td>Id<sup><font color="red">&nbsp;*</font></sup></td>
                              <td>
                                 <input class="form-control" id="selectedId"  disabled/ >
                              </td>
                           </tr>
                           <tr>
                              <td>Material Namer<sup><font color="red">&nbsp;*</font></sup></td>
                              <td>
                                 <input class="form-control" id="selectedMaterial" />
                              </td>
                           </tr>
                        </tbody>
                     </table>
                  </div>
               </div>
               <div class="modal-footer"  style="text-align: center;">
                  <input id="save1" onclick="saveEditedData()" type="submit" class="btn btn-success" value="Save" />
                  <button type="reset" class="btn btn-danger" data-dismiss="modal">Cancel</button> 
               </div>
            </div>
         </div>
      </div>

            <div id="deleteMaterial" class="modal fade" >
         <div class="modal-dialog" style="position: absolute;left: 27%;top: 44%;margin-top: -250px;width:725px;">
            <div class="modal-content">
               <div class="modal-header">
                  <button type="button" class="close" data-dismiss="modal">&times;</button>
                  <h4 id="nome" class="modal-title">Delete Material Details</h4>
               </div>
               <div class="modal-body" style="max-height: 50%;margin-bottom: -35px;">
                  <div class="col-md-12">
                     <table class="table table-sm table-bordered table-striped">
                        <tbody>
                        <tr style="display:none;">
                              <td>Id<sup><font color="red">&nbsp;*</font></sup></td>
                              <td>
                                 <input class="form-control" id="selectedIdDelete"  disabled/ >
                              </td>
                           </tr>
                           <tr>
                              <td>Material Name</td>
                              <td>
                                 <input class="form-control" id="selectedMaterialDelete"  disabled/ >
                              </td>
                           </tr>
                        </tbody>
                     </table>
                  </div>
               </div>
               <div class="modal-footer"  style="text-align: center;">
                  <input id="save1" onclick="deleteMaterial()" type="button" class="btn btn-success" value="Save" />
                  <button type="reset" class="btn btn-danger" data-dismiss="modal">Cancel</button> 
               </div>
            </div>
         </div>
      </div>
      
      
 <script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
 <script >
 
  
 window.onload = function () { 
		getCustomers();
	}
 
  var yesterdayDate = new Date();
      yesterdayDate.setDate(yesterdayDate.getDate() - 1);
      yesterdayDate.setHours(00);
	  yesterdayDate.setMinutes(00);
	  yesterdayDate.setSeconds(00);
  $(document).ready(function () {
   
   
 //  $("#dateInput1").jqxDateTimeInput({ theme: "arctic", formatString: "dd/MM/yyyy HH:mm:ss", showTimeButton: true, width: '50%', height: '25px' ,min: yesterdayDate});
 //  $('#dateInput1 ').jqxDateTimeInput('setDate', new Date());
 //  $("#dateInput2").jqxDateTimeInput({ theme: "arctic", formatString: "dd/MM/yyyy HH:mm:ss", showTimeButton: true, width: '50%', height: '25px' });
 //  $('#dateInput2 ').jqxDateTimeInput('setDate', new Date());
//   $("#dateInput3").jqxDateTimeInput({ theme: "arctic", formatString: "dd/MM/yyyy HH:mm:ss", showTimeButton: true, width: '50%', height: '25px'});
//  $('#dateInput3 ').jqxDateTimeInput('setDate', new Date());
 //  $("#dateInput4").jqxDateTimeInput({ theme: "arctic", formatString: "dd/MM/yyyy HH:mm:ss", showTimeButton: true, width: '50%', height: '25px'});
 //  $('#dateInput4 ').jqxDateTimeInput('setDate', new Date());
  

});
 </script>

 <script type="text/javascript">
    var custId;
    var prntTable;
    var indentId;
    var adhocCVCount;
    var dedicatedCVCount;
    var buttonValue;
    var recordId;
    var vehicleTypeList;
    var vehicleList;

    function addMaterialMaster() {
        var customerName = document.getElementById("custNames").value;
        if (customerName == "") {
            sweetAlert("Please select customer");
            return;
        }
        $('#add').modal('show');
    }

    function viewDetails() {
    
        getMaterialMasterDetails(custId);
    }

    function saveData() {

        var materialName = document.getElementById("materialNameId").value;
       

        if (materialName == "") {
            sweetAlert("Please Enter Material Name");
            return;
        }
       
        var param = {
            materialName: materialName,
            custId : custId
        };
        $.ajax({
            url: '<%=request.getContextPath()%>/MaterialMasterAction.do?param=saveMaterialMasterDetails',
            data: param,
            success: function(result) {
                if (result == "Saved Successfully") {
                    sweetAlert("Saved Successfully");
					getMaterialMasterDetails(custId);
                } else {
                    sweetAlert("Not Saved ");
                }
                
                 $('#add').modal('hide');
                  document.getElementById("materialNameId").value = "";
            }
        });
    }
    
     function dateValidation(date1,date2) {
     var time1=date1.split(" ");
     var time2=date2.split(" ");
     var dd = date1.split("/");
     var ed = date2.split("/");
     var startDate = new Date(dd[1] + "/" + dd[0] + "/" + dd[2]+" "+time1[1]);
     var endDate = new Date(ed[1] + "/" + ed[0] + "/" + ed[2]+" "+time2[1]);
     if (endDate >= startDate ) 
	{
	  return true;
	}else{
	   return false;
	}
 }
     function saveEditedData() {

        var id = document.getElementById("selectedId").value;
        var materialName = document.getElementById("selectedMaterial").value;
        if (materialName == "") {
            sweetAlert("Please Enter Material");
            return;
        }
        
        var param = {
            materialName: materialName,
            id: id
        };
        $.ajax({
            url: '<%=request.getContextPath()%>/MaterialMasterAction.do?param=updateMaterialMasterDetails',
            data: param,
            success: function(result) {
                if (result == "Updated Successfully") {
                    sweetAlert("Updated Successfully");
                    getMaterialMasterDetails(custId);

                } else {
                    sweetAlert("Not Updated");
                }
                
                $('#editMaterial').modal('hide');
            }
             
        });
    }
    
    
      function deleteMaterial() {

        var id = document.getElementById("selectedIdDelete").value;
        var materialName = document.getElementById("selectedMaterialDelete").value;
       
        
        var param = {
            materialName: materialName,
            id: id
        };
        $.ajax({
            url: '<%=request.getContextPath()%>/MaterialMasterAction.do?param=deleteMaterialMasterDetails',
            data: param,
            success: function(result) {
                if (result == "Deleted Successfully") {
                    sweetAlert("Deleted Successfully");
                    getMaterialMasterDetails(custId);

                } else {
                    sweetAlert("Not Deleted");
                }
                
                $('#deleteMaterial').modal('hide');
                
              
            }
             
        });
    }
    
    function openModal1(id, materialName) {
    var materialName1 = materialName.split('^').join(' ');
     $('#editMaterial').modal('show');
      document.getElementById("selectedId").value = id;
      document.getElementById("selectedMaterial").value = materialName;
    }

    function openModal2(id, materialName) {
    var materialName1 = materialName.split('^').join(' ');
     $('#deleteMaterial').modal('show');
      document.getElementById("selectedIdDelete").value = id;
      document.getElementById("selectedMaterialDelete").value = materialName;
    }
    



    function getMaterialMasterDetails(custId) {
        if (document.getElementById("custNames").value == '') {
            sweetAlert("Please select Customer Name");
        } else {
            if ($.fn.DataTable.isDataTable('#example')) {
                $('#example').DataTable().destroy();
            }
            var table = $('#example').DataTable({
                "ajax": {
                    "url": "<%=request.getContextPath()%>/MaterialMasterAction.do?param=getMaterialMasterDetails",
                    "dataSrc": "materialListRoot",
                    "data": {
                        custId: custId
                    }
                },
                "bLengthChange": true,
                "dom": 'Bfrtip',
                "buttons": [{
                    extend: 'pageLength'
                }, {
                    extend: 'excel',
                    text: 'Export To Excel',
                    className: 'btn btn-primary',
                    exportOptions: {
			                columns: ':visible'
			            }
                }],
                "columns": [{
                    "data": "slNo"
                },{
                    "data": "idIndex",
                    "visible":false
                }, {
                    "data": "materialNameIndex"
                }, {
                    "data": "editButton",
                    "visible":false
                },  {
                    "data": "deleteButton",
                    "visible":false
                }]
            });
        }
    }
    $('#custNames').change(function() {
        custId = $('#custNames option:selected').attr('value');
        if(custId > 0){
       		getMaterialMasterDetails(custId);
        }
        
    });

    function  getCustomers(){
        $.ajax({
            url: '<%=request.getContextPath()%>/CommonAction.do?param=getCustomer',
            async: false,
            success: function(result) {
                customerDetails = JSON.parse(result);
                for (var i = 0; i < customerDetails["CustomerRoot"].length; i++) {
                    $('#custNames').append($("<option></option>").attr("value", customerDetails["CustomerRoot"][i].CustId).text(customerDetails["CustomerRoot"][i].CustName));
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
						setSelectedIndex(document.getElementById('custNames'),cName);
						custId = customerDetails["CustomerRoot"][0].CustId;
					   	getMaterialMasterDetails(custId);
					}
            }
        });
    }

    
</script>
<jsp:include page="../Common/footer.jsp" />
<!--</body>-->
<!---->
<!--</html> -->