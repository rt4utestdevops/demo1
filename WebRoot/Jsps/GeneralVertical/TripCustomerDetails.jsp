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

 <jsp:include page="../Common/header.jsp" />
      <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
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
      <script src="../../Main/DatatableEditor/jquery.tabledit.js"></script>
<!--      <script src="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.1/js/select2.min.js"></script>-->
<!--      <link href="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.1/css/select2.min.css" rel="stylesheet" />-->
	
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
      </style>

  
 
   <!--  <body onload="getCustNames()">  -->
      <div class="custom">
         <div class="panel panel-primary">
            <div class="panel-heading">
               <h3 class="panel-title" >
                  Customer Details
               </h3>
            </div>
            <div class="panel-body">
               <div class="panel row" style="padding:1% ;margin: 0%;">
                  <div class="col-lg-12 col-md-12">
                     <div class="col-xs-4 col-md-3 col-lg-3  ">
                        <select class="form-control" id="custNames" >
                           <option value="">Select Customer name</option>
                        </select>
                     </div>
                     
                     <div class="col-md-4" style="width: 80px;">
                        <button title="ADD" class=" col-md-12 col-lg-12 btn btn-warning" onclick="addCustomerDetails();" style="margin-left: 10px;width: 50px;">Add</button>
                     </div>
                     <div class="col-md-4" style="width: 80px;">
                        <button title="View" class="col-md-12 col-lg-12  btn btn-warning" onclick="viewDetails();" style="margin-left: 10px;width: 50px;">View</button>
                     </div>
                   
                  </div>
               </div>
               <!--End of header Panel-->
               <div style="overflow: auto !important;">
                  <table id="example" class="table table-striped table-bordered" cellspacing="0" width="100%" style="margin-top:1%">
                     <thead>
                        <tr>      
                           <th>Sl No</th>                
                           <th>Customer Name</th>    
                           <th>Contact Person</th>
                           <th>Contact No</th>
						   <th>Contact No2</th>
                           <th>Contact Address</th>
                           <th>Customer Reference ID</th> 
                           <th>Type</th>
                           <th>Status</th>                         
                           <th>Actions</th>
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
         <div class="modal-dialog" style="position: absolute;left: 27%;top: 44%;margin-top: -250px;width:725px;">
            <div class="modal-content">
               <div class="modal-header">
                  <h4 id="nome" class="modal-title">Add Customer Details</h4>
				    <button type="button" class="close" onclick="eraseData()" data-dismiss="modal">&times;</button>
               </div>
               <div class="modal-body" style="max-height: 50%;margin-bottom: -19px;">
                  <div class="col-md-12">
                     <table class="table table-sm table-bordered table-striped">
                        <tbody>
                           <tr>
                              <td>Customer Name</td>
                              <td><input type="text" class="form-control comboClass" maxLength="100" id="custNameId"></td>
                           </tr>    
                           <tr>
                              <td>Contact Person</td>
                              <td><input type="text" class="form-control comboClass" maxLength="100" id="contactPersonId"></td>
                           </tr>                  
                           <tr>
                              <td>Contact No</td>
                              <td><input type="text" class="form-control comboClass" maxlength="15" id="contactNoId"  onkeypress="return event.charCode >= 48 && event.charCode <= 57" pattern="[0-9]{5}"></td>
                           </tr>
						   <tr>
                              <td>Contact No2</td>
                              <td><input type="text" class="form-control comboClass" maxlength="15" id="contactNo2Id"  onkeypress="return event.charCode >= 48 && event.charCode <= 57" pattern="[0-9]{5}"></td>
                           </tr>
                           <tr>
                              <td>Contact Address</td>
                              <td><input type="text" class="form-control comboClass" maxLength="100" id="contactAddressId"></td>
                           </tr> 
                           <tr>
                              <td>Customer Reference ID</td>
                              <td><input type="text" class="form-control comboClass" maxLength="15" id="referenceId"></td>
                           </tr>
                            <tr>
                              <td id="custtype">Type</td>
                              <td><select class="form-control" id="custtypeid" style="width:254px"></select></td>
                           </tr>
                            <tr>
                              <td id="statusId">Status</td>
                              <td> <select class="form-control" id="statusIdform1" >
                              <option value="Active" selected id="active">Active</option>
                           </tr>                         
                        </tbody>
                     </table>
                  </div>
               </div>
               <div class="modal-footer"  style="text-align: center;">
                  <input id="save1" onclick="saveData()" type="button" class="btn btn-primary" value="Save" />
                  <button type="reset" class="btn btn-warning" onclick="eraseData()" data-dismiss="modal" >Cancel</button>
                  <!-- <button type="reset"  onclick="cancel()" class="btn btn-warning" data-dismiss="modal">Cancel</button> -->
               </div>
            </div>
         </div>
      </div>
      
      
      <div id="detailsModal" class="modal fade" >
         <div class="modal-dialog" style="position: absolute;left: 27%;top: 44%;margin-top: -250px;width:725px;">
            <div class="modal-content">
               <div class="modal-header">
                 
                  <h4 id="nome" class="modal-title">Modify Customer Details</h4>
				   <button type="button" class="close" data-dismiss="modal">&times;</button>
               </div>
               <div class="modal-body" style="max-height: 50%;margin-bottom:-19px;">
                  <div class="col-md-12">
                     <table class="table table-sm table-bordered table-striped">
                        <tbody>
                           <tr>
                              <td id="custNamelabelId">Customer Name</td>
                              <td><input type="text" class="form-control comboClass" maxLength="100" id="custNameId1" ></td>
                           </tr>  
                           <tr>
                              <td id="namelabelId">Contact Person</td>
                              <td><input type="text" class="form-control comboClass" maxLength="100" id="contactPersonId1"></td>
                              <!-- <td><input type="text" class="form-control comboClass" maxLength="100" id="contactPersonId1" onkeypress="return ((event.charCode > 64 && event.charCode < 91) || (event.charCode > 96 && event.charCode < 123))"></td> -->
                           </tr>                     
                           <tr>
                              <td id="nolabelId">Contact No</td>
                              <td><input type="text"  class="form-control comboClass" maxlength="15" id="contactNoId1"  onkeypress="return event.charCode >= 48 && event.charCode <= 57" pattern="[0-9]{10,10}"></td>
                           </tr>						                     
                           <tr>
                              <td id="nolabelId">Contact No2</td>
                              <td><input type="text"  class="form-control comboClass" maxlength="15" id="contactNo2Id1"  onkeypress="return event.charCode >= 48 && event.charCode <= 57" pattern="[0-9]{10,10}"></td>
                           </tr>
                           <tr>
                              <td id="addresslabelId">Contact Address</td>
                              <td><input type="text" class="form-control comboClass" maxLength="100" id="contactAddressId1" ></td>
                           </tr> 
                           <tr>
                              <td id="reflabelId">Customer Reference ID</td>
                              <td><input type="text" class="form-control comboClass" maxLength="15" id="referenceId1"></td>
                           </tr>
                            <tr>
                              <td id="custtype">Type</td>
                              <td><select class="form-control" id="custtypeid1" style="width:254px"></select></td>
                           </tr>
                           <tr>
                              <td id="statusId">Status</td>
                              <td> <select class="form-control" id="statusIdform" >
                              <option value="Active" selected >Active</option>
    						  <option value="Inactive">Inactive</option></select></td>
                           </tr>
                          
                        </tbody>
                     </table>
                  </div>
               </div>
               <div class="modal-footer"  style="text-align: center;">
                  <input id="saveedit" onclick="saveDataEdit()" type="button" class="btn btn-primary" value="Save" />
                  <button type="reset" class="btn btn-warning" data-dismiss="modal">Cancel</button> 
               </div>
            </div>
         </div>
      </div>
 <script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
 <script type="text/javascript">
 
  window.onload = function () { 
		getCustNames();
		loadcustomerTypeCombo(custtype);
	}

    var custId;
    var table;
    var buttonValue;
    var uniqueId;
    var custtypeId;
    var custtypeId1;
    var custtype="";
    var buttonname="";
    function addCustomerDetails() {
        var customerName = document.getElementById("custNames").value;
        if (customerName == "") {
            sweetAlert("Please select customer");
            return;
        }
        $('#add').modal('show');
    }
    function viewDetails() {
        getCustomerMasterData(custId);
    }
function eraseData(){
document.getElementById("custNameId").value = "";
                        document.getElementById("contactPersonId").value = "";
                        document.getElementById("contactNoId").value = "";
						document.getElementById("contactNo2Id").value = "";
                        document.getElementById("contactAddressId").value = "";
                        document.getElementById("referenceId").value = "";
                        document.getElementById("custtypeid").value = "";
                        document.getElementById("statusIdform1").value = document.getElementById("active").value; 
}
    function saveData() {

        var customerName = document.getElementById("custNames").value;
        var custName = document.getElementById("custNameId").value;
       var contactPerson = document.getElementById("contactPersonId").value;
       var contactNo = document.getElementById("contactNoId").value;
	   var contactNo2 = document.getElementById("contactNo2Id").value;
        var contactAddress = document.getElementById("contactAddressId").value;
        var reference = document.getElementById("referenceId").value;
        var status = $("#statusIdform1 :selected").text();
        var type=$('#custtypeid').find('option:selected').text();
        if (customerName == "") {
            sweetAlert("Please select customer");
            return;
        }  
        if (custName == "") {
            sweetAlert("Please Enter Customer Name");
            return;
        }      
        if (contactPerson == "") {
            sweetAlert("Please Enter Contact Person");
            return;
        }
        var matches = contactPerson.match(/\d+/g);
		if (matches != null) {
		    sweetAlert("Please Enter valid Contact Person");
            return;
		}  
        if (contactNo == "") {
            sweetAlert("Please Enter Contact Number");
            return;
        }
        /*if (contactNo.length !=15) {            	
                sweetAlert("Please Enter 10 Digit Contact No");
                return;
        }
        if (contactNo2!=="" && contactNo2.length !=10) {            	
                sweetAlert("Please Enter 10 Digit Contact No 2");
                return;
        }*/
        if (contactAddress == "") {
            sweetAlert("Please Enter Contact Address");
            return;
        }
        if(type== "Select type" || type==''){
        	sweetAlert("Please Select Type");
            return;
        }
    //    if (reference == "") {
    //        sweetAlert("Please Enter Customer Reference ID");
    //        return;
    //    }
       
        var param = {
            CustId: custId,
            custName:custName,
            contactPerson: contactPerson,
            contactNo: contactNo,
			contactNo2: contactNo2,
            status:status,
            contactAddress: contactAddress,
            reference: reference,
            custtypeId:type
        };
        $.ajax({
            url: '<%=request.getContextPath()%>/TripMasterDetails.do?param=saveCustomerDetails',
            data: param,
            success: function(result) {
                if (result == "Saved Successfully") {
                    sweetAlert("Saved Successfully");
                    setTimeout(function() {
                        getCustomerMasterData(custId);
                         eraseData();                      
                        $('#add').modal('hide');
                    }, 1000);

                } else {
                    sweetAlert(result);
                    getCustomerMasterData(custId);
                    eraseData();                   
                }
            }
        });
    }

    function saveDataEdit() {
    	var customerName = document.getElementById("custNameId1").value;
    	var contactPerson = document.getElementById("contactPersonId1").value;    
        var contactNo = document.getElementById("contactNoId1").value;
		var contactNo2 = document.getElementById("contactNo2Id1").value;
        var contactAddress = document.getElementById("contactAddressId1").value;
        var reference = document.getElementById("referenceId1").value;
		var status = $("#statusIdform :selected").text();
		var type=$('#custtypeid1').find('option:selected').text();
            if (customerName == "") {
                sweetAlert("Please Enter Customer Name");
                return;
            }
            if (contactPerson == "") {
                sweetAlert("Please Enter Contact Person");
                return;
            }
            var matches = contactPerson.match(/\d+/g);
			if (matches != null) {
			    sweetAlert("Please Enter valid Contact Person");
	            return;
			}  
            if (contactNo == "") {            	
                sweetAlert("Please Enter Contact No");
                return;
            } 
            /*if (contactNo.length !=10) {            	
                sweetAlert("Please Enter 10 Digit Contact No");
                return;
            }			
            if (contactNo2!="" && contactNo2.length !=10) {            	
                sweetAlert("Please Enter 10 Digit Contact No 2");
                return;
            }*/
            if (contactAddress == "") {
                sweetAlert("Please Enter Contact Address");
                return;
            }
            if(custtypeId1== "Select type" || type== ""){
         	sweetAlert("Please Select Type");
            return;
        }
        
        var param = {        
            id: uniqueId,
            custId:custId,
            customerName:customerName,
            contactPerson: contactPerson,
            contactNo: contactNo,
			contactNo2: contactNo2,
            status:status,
            contactAddress: contactAddress, 
            reference: reference,
            custtypeId1:custtypeId1,           
            action: buttonValue
        };
        $.ajax({
            url: '<%=request.getContextPath()%>/TripMasterDetails.do?param=saveEditCustomerDetails',
            data: param,
            success: function(result) {
                sweetAlert(result);
                document.getElementById("custNameId1").value = "";
                document.getElementById("contactPersonId1").value = "";
                document.getElementById("contactNoId1").value = "";
				document.getElementById("contactNo2Id1").value = "";
                document.getElementById("contactAddressId1").value = "";
                document.getElementById("referenceId1").value = "";      
                document.getElementById("custtypeid1").value = "";
                document.getElementById("statusIdform").value = "";
                $('#detailsModal').modal('hide'); 
                setTimeout(function(){
	            table.ajax.reload();
	                     }, 1000);
            }
        });
    }

    function getCustomerMasterData(custId) {
        if (document.getElementById("custNames").value == '') {
            sweetAlert("Please select Customer name");
        } else {
            if ($.fn.DataTable.isDataTable('#example')) {
                $('#example').DataTable().destroy();
            }
            table = $('#example').DataTable({
                "ajax": {
                    "url": "<%=request.getContextPath()%>/TripMasterDetails.do?param=getCustomerMasterDetails",
                    "dataSrc": "customerMasterRoot",
                    "data": {
                        custId: custId,
                    }
                },
                "bLengthChange": false,
                "dom": 'Bfrtip',
                "buttons": [{
                    extend: 'pageLength'
                }, {
                    extend: 'excel'
                }],
                "columns": [{
                    "data": "slno"
                }, {
                    "data": "custNameIndex"
                }, {
                    "data": "contactPersonIndex"
                }, {
                    "data": "contactNoIndex"
                }, {
                    "data": "contactNo2Index"
                }, {
                    "data": "contactAddressIndex"
                }, {
                    "data": "refIndex"
                }, {
                    "data": "custtypeIndex"
                }, {
                    "data": "statusIndex"
                }, {
                    "data": "button"
                }]
            });
        }
    }
    $('#custNames').change(function() {
        custId = $('#custNames option:selected').attr('value');
    });

    function getCustNames() {
        $.ajax({
            url: '<%=request.getContextPath()%>/CommonAction.do?param=getCustomer',
            success: function(result) {
                customerDetails = JSON.parse(result);
                for (var i = 0; i < customerDetails["CustomerRoot"].length; i++) {
                    $('#custNames').append($("<option></option>").attr("value", customerDetails["CustomerRoot"][i].CustId).text(customerDetails["CustomerRoot"][i].CustName));
                }
            }
        });
       
    } 
     $('#custtypeid').change(function() {
        custtypeId = $('#custtypeid option:selected').attr('value');
    }); 
     $('#custtypeid1').change(function() {
        custtypeId1 = $('#custtypeid1 option:selected').attr('value');
    });
     function loadcustomerTypeCombo(custtype)
			{
			$.ajax({
	        url: '<%=request.getContextPath()%>/TripMasterDetails.do?param=loadcustomertype',
	        success: function(result) {
	            var custList = JSON.parse(result);
	            if(custtype!="" || buttonname!="")
	            {
	            for (var i = 0; i < custList["custype"].length; i++) {
                    $('#custtypeid1').append($("<option></option>").attr("value", custList["custype"][i].custypevalue).text(custList["custype"][i].custypevalue));
	            }
	            $('#custtypeid1').val(custtype.replace("-"," ")).trigger('change');
	            }
	           else{
	            for (var i = 0; i < custList["custype"].length; i++) {
                    $('#custtypeid').append($("<option></option>").attr("value", custList["custype"][i].custypevalue).text(custList["custype"][i].custypevalue));
	            }
	            }
            }
	    });
	} 
	
    function openModal(name,contactPerson,contactNo,contactNo2,contactAddress,custReferenceId,custtype,status,id){
    buttonname = document.getElementById("myBtn").name;
   	 $('#detailsModal').modal('show');
   	loadcustomerTypeCombo(custtype,buttonname);
                document.getElementById("custNameId1").value = name.split('$').join(' ').split('#').join('\'');
                document.getElementById("contactPersonId1").value = contactPerson.split('$').join(' ').split('#').join('\'');
                document.getElementById("contactNoId1").value = contactNo;
				document.getElementById("contactNo2Id1").value = contactNo2;
                document.getElementById("contactAddressId1").value = contactAddress.split('$').join(' ').split('#').join('\'');
                document.getElementById("referenceId1").value = custReferenceId.split('$').join(' ').split('#').join('\'');
                $('#statusIdform').val(status.replace("-"," ")).trigger('change');  
		   	 	uniqueId=id;
		   	 	$("#custtypeid1").empty().select2();
    }
           
</script>
    
 <jsp:include page="../Common/footer.jsp" />
	<!-- </body>   -->
<!-- </html> -->
 