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
	String userAuthority=cf.getUserAuthority(loginInfo.getSystemId(),loginInfo.getUserId());
	boolean isAdmin= ("Admin".equals(userAuthority)) ?true : false;
if(loginInfo != null){

			}
else 
 {
 	response.sendRedirect(request.getContextPath()+ "/Jsps/Common/SessionDestroy.html");
 	
 }
%>
<jsp:include page="../Common/header.jsp" />
      <title>Indent Master</title>
      <meta charset="utf-8">
      <meta name="viewport" content="width=device-width, initial-scale=1">
      <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
      <link href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" rel="stylesheet">
      <link href="https://cdn.datatables.net/1.10.16/css/dataTables.bootstrap.min.css" rel="stylesheet">
      <link href="https://cdn.datatables.net/fixedcolumns/3.2.3/css/fixedColumns.dataTables.min.css" rel="stylesheet">
      <link href="https://cdn.datatables.net/select/1.2.3/css/select.dataTables.min.css" rel="stylesheet"/>
      <link href="https://cdn.datatables.net/buttons/1.5.0/css/buttons.bootstrap.min.css" rel="stylesheet"/>
      
<!--       <link href="https://cdn.datatables.net/responsive/2.2.1/css/responsive.bootstrap.min.css" rel="stylesheet" />-->
      
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

<!-- 		<script src="https://cdn.datatables.net/fixedheader/3.1.3/js/dataTables.fixedHeader.min.js"></script>
	<script src="https://cdn.datatables.net/responsive/2.2.1/js/dataTables.responsive.min.js"></script> 
	<script src="https://cdn.datatables.net/responsive/2.2.1/js/responsive.bootstrap.min.js"></script>  -->

<!--      <script src="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.1/js/select2.min.js"></script>
      <link href="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.1/css/select2.min.css" rel="stylesheet" />  -->
      
      
      
	  <link href="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.6-rc.0/css/select2.min.css" rel="stylesheet" />
	  <script src="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.6-rc.0/js/select2.min.js"></script>

	  <link href="../../Main/resources/css/T4Ucommon.css" rel="stylesheet" />
	  
	  
	  
	  
	  
	  
	  
	  
	  
	  
	  
	  
	  
	  
	  	  
      <style>
         .custom{
         padding-left: 15px;
         padding-right: 15px;
         margin-left: auto;
         margin-right: auto;
         padding-top: 10px;
         }
         .modal-open .modal {
         //overflow-x: hidden;
         //overflow-y: hidden;
         overflow : auto;
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
         //margin-top: -34px;
         }
         #example_filter{
         margin-top: -34px;
         }
        
         .table-striped>tbody>tr:nth-of-type(odd) {
					background-color: #f9f9f9;
					height: 20px !important;
		  }
		  .file {
  			visibility: hidden;
  			position: absolute;
		}
		 .wait { position: absolute; left: 0; right: 0; top: 0; bottom: 0; margin: auto; width: 500px; height: 300px; }
		 label {
			display : inline !important;
		}
		.button.col-lg-1 .btn .btn-primary {
			padding-right : 34px !important;
		}
		label {
			display : inline !important;
		}
<!--		.modal-content {-->
<!--			width : 160% !important;-->
<!--		}-->
		
<!--		#indentDetailsImportModalForWidth {-->
<!--			width : 260% !important;-->
<!--		}-->
		//.modal-title
	//	{
		//	text-align: left !important;
		//}
		//input#save1 {
			//text-align : center !important;
		//}
		


		.select2-container--default .select2-selection--single {   
			width : 112% !important;
		}
		@media only screen and (min-width: 768px) {
		.add-intent{
			position: absolute;left: 27%;top: 44%;margin-top: -250px;width:725px;
		}
		}
		@media only screen and (max-width: 768px) {
		.add-intent{
			margin-top: 50px;
		}
		}
		.overFlow{
				overflow-x:auto;
		}
		.select2-container--default .select2-selection--single {
			//width: 196% !important;
		}
		@media only screen and (min-width: 768px) {
		.import-details-intent{
			//position: absolute;left: 10%;top: 45%;;margin-top: -250px;width:165%;
			position: absolute;left: 27%;top: 44%;margin-top: -250px;width:725px;
		}
		}
		
		@media only screen and (min-width: 768px) {
		.import-details-intent{
			//margin-top: 53px;
		}
		}
		@media only screen and (min-width: 768px) {
		.select2-container--default .select2-selection--single {
			/*width: 100% !important;*/
		}
		.select2-hidden-accessible, .select2-container{
			width:160px !important;
		}
		}
		.select2-container--default .select2-selection--single .select2-selection__arrow {
			right: -138px !important;
		}
		@media only screen and (min-width: 768px) { 
		.select2-container--default .select2-selection--single .select2-selection__arrow {
			//right: -8px !important;
		}		
		}
	
		
		

@media screen and (max-width: 767px) {
	#example_filter {
     margin-top: 0px;
}

button#addRow{
   //margin-top:8px !important;
   margin-left:46px !important;
   margin-bottom: -125px !important;
}
#editableGrid_filter {
    margin-top: 36px !important;
}
//.modal-body .dataTables_scrollBody {
    //width: 251% !important;
//}
}
.modal-body #example_filter {
	margin-top: 43px;
}
		
		.select2-dropdown--below {
			width : 200px !important;
		}
		
	    .dataTables_scrollHead {
			overflow : initial !important;
		}
		.dataTables_scrollBody {
			//overflow : hidden !important;
				//width: 500% !important;
			width: 100% !important;
		}
		.dataTables_scroll {
			//overflow : auto !important;
		}  	
	
	.select2-container--default .select2-selection--single {
		width: 188% !important;
	}
	.select2-dropdown--below {
		width: 300px !important;
	}
	.dataTables_scrollBody {
	/* position: relative; */
    overflow: auto;
    /* height: 50vh; */
    width: 100%;
    max-height: 200px;
	}
	#editableGrid {
		//height : 600px !important;
	}
      </style>

   
      <div class="custom">
         <div class="panel panel-primary">
            <div class="panel-heading">
               <h3 class="panel-title" >
                  Indent Creation
               </h3>
            </div>
            <div class="panel-body">
               <div class="panel row" style="padding:1% ;margin: 0%;">
                  <div class="col-lg-12 ">
                     <div class="col-sm-3  " style="margin-bottom:8px">
                        <select class="form-control" id="custNames" >
                           <option value="">Select Customer Name</option>
                        </select>
                     </div>
                     <div class="col-sm-3  " style="margin-bottom:8px">
                        <select class="form-control" id="cust_names" >
                        <!--   <option value="">Select Customer</option> -->
                        </select>
                     </div>
                     <div class="col-sm-1" style="margin-bottom:8px">
                        <button title="ADD" class="col-lg-1 btn btn-primary" onclick="addOrUpdateIndent(null,null,null,0);" style="width: 80px; padding-right : 36px;">Add</button>
                     </div>
                     
                     <div class="col-sm-1" style="margin-bottom:8px">
                        <button title="View" class="col-lg-1 btn btn-primary" onclick="viewDetails();" style="width: 80px; padding-right : 42px;">View</button>
                     </div>
                     <div class="col-sm-2" style="margin-bottom:8px">
                         <button class="btn btn-primary" id="importIndentMaster" onclick="importExcelData()" style="width: 150px;margin-right:-40px;">Import Indent</button> 
                     </div>
                     <div class="col-sm-2" style="margin-bottom:8px">
                         <button class="btn btn-primary" id="importIndentMaster" onclick="importIndentDetailsExcel()"style="width: 200px; ">Import Indent Model Details</button> 
                     </div>
                  </div>
               </div>
               <!--End of header Panel-->
               <div style="overflow: auto !important;">
                  <table id="example" class="table table-striped table-bordered " cellspacing="0" width="100%" style="margin-top:1%">
                     <thead>
                        <tr>
                           <th rowspan="2">Sl No</th>
                           <th rowspan="2">Node</th>
                           <th rowspan="2">Region</th>
                           <th colspan="5" style="text-align: center;">Number of Vehicles</th>
                           <th rowspan="2">Supervisor Name</th>
                           <th rowspan="2">Supervisor Contact</th>
                           <th rowspan="2">Action</th>
                           <th rowspan="2">Modify</th>
                        </tr>
                        <tr>
                           <th>Dedicated</th>
                           <th>Ad-hoc</th>
                           <th>Total</th>
                           <th>Assigned Dedicated</th>
                           <th>Assigned Ad-hoc</th>
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
      <div id="addModify" class="modal fade" >
         <div class="modal-dialog"><!-- add-intent">   -->
            <div class="modal-content" style="width : 700px; margin-left : -100px;">
               <div class="modal-header">
               <h4 id="titleAddOrUpdate" class="modal-title" style="text-align: left"></h4>
               <button type="button" class="close" data-dismiss="modal">&times;</button>                                     
               </div>
               <div class="modal-body" style="max-height: 50%;margin-bottom: -35px;">
                  <div class="col-md-12">
                     <table class="table table-sm table-bordered table-striped">
                        <tbody>
                           <tr>
                              <td>Node<sup><font color="red">&nbsp;*</font></sup></td>
                              <td>
                                 <select class="form-control" id="nodeId" >
                                    <option value="">Select Node</option>
                                 </select>
                              </td>
                           </tr>
                           <tr>
                              <td>Region<sup><font color="red">&nbsp;*</font></sup></td>
                              <td>
                                 <select class="form-control" id="regionId" >
                                    <option value="">Select below Region</option>
                                    <option value="North">North</option>
                                    <option value="South">South</option>
                                    <option value="East">East</option>
                                    <option value="West">West</option>
                                 </select>
                              </td>
                           </tr>
                           <tr>
                              <td>Dedicated Number of Vehicles<sup><font color="red">&nbsp;*</font></sup></td>
                              <td><input type="number" min="0" class="form-control comboClass" maxLength="15" id="dedicatedId"></td>
                           </tr>
                           <tr>
                              <td>Ad-hoc Number of Vehicles<sup><font color="red">&nbsp;*</font></sup></td>
                              <td><input type="number" min="0" class="form-control comboClass" maxLength="15" id="adHocId"></td>
                           </tr>
                           <tr>
                              <td>Supervisor Name<sup><font color="red">&nbsp;*</font></sup></td>
                              <td><input type="text" class="form-control comboClass" maxLength="100" id="superNameId"></td>
                           </tr>
                           <tr>
                              <td>Supervisor Contact<sup><font color="red">&nbsp;*</font></sup></td>
                              <td><input type="text" class="form-control comboClass" maxLength="60" id="superContactId"></td>
                           </tr>
                        </tbody>
                     </table>
                  </div>
               </div>
               
               <div class="modal-footer"  style="text-align: center;">
               	<div class="row" style="width:100%;">
               		<div class="col-sm-3 col-md-3 col-lg-3">
               		</div>
               		<div class="col-sm-6 col-md-6 col-lg-6">
               			<input id="save1" onclick="saveData()" type="button" class="btn btn-success" value="Save" />
                  		<button type="reset" class="btn btn-danger" data-dismiss="modal">Cancel</button>
               		</div>
               		<div class="col-sm-3 col-md-3 col-lg-3">
               		</div>
               	</div>
               	
                   
               </div>
             
            </div>
         </div>
      </div>
	  	 
	  
      <div id="gridModal"  class="modal fade" style="overflow:scroll;">    
      	<div class="modal-dialog"><!--add-intent" >-->
         <div class="modal-content" style="width : 200%; margin-left: -192px;">
     <!--     <div id="indentDetailsImportModalForWidth">    -->
            <div class="modal-header" id="mheader">
              
               <h4 id="tripEventsTitle" class="modal-title" style="text-align: left"></h4>
               <button type="button" class="close"  data-dismiss="modal">&times;</button>
              </div> 
<!--                  <div class="secondLine" style="display:flex; justify-content:space-between; padding-left: 985px;align-items:baseline;">                  
               </div> -->
                
               
               <br>
               <table id="VehiclesCount" class="table table-bordered table-striped table-condensed" style="margin-top:10px;margin-left:10px;width:25%">
                   <thead>
                   		<tr>
      						<th colspan="4">Number of Vehicles</th>
      					</tr>
      					<tr>
                           <th>Type</th>
                           <th>Total</th>
                           <th>Assigned</th>
                           <th>Remaining</th>
                        </tr>
    				</thead>
					<tbody>
	               		<tr>
	               			<td>Dedicated </td>
	               			<td ><div id="totalDedicated"></div></td>
	               			<td><div  id="assignedDedicated"></div></td>
	               			<td><div id="remainingDedicated"></div></td>
	               		</tr>
	               		<tr>
	               			<td >Ad-hoc </td>
	               			<td><div id="totalAdhoc"></div></td>
	               			<td><div id="assignedAdhoc"></div></td>
	               			<td><div id="remainingAdhoc"></div></td>
	               		</tr>
               		</tbody>
               </table>
<!--             </div>  -->
            <div class="modal-body" style="height: 100%;">
               <div class="row">
                  <div class="col-md-12">
                     <div  style="border: solid  1px lightgray;">
                      						  
                        <button class="btn btn-primary" id="addRow" style="margin-top: 3px;margin-bottom: -50px;margin-left: 260px;">Add Row</button> 
                        <table id="editableGrid"  class="table table-striped table-bordered">
                           <thead>
                              <tr>
                                 <th>Sl No</th>
                                 <th>Node</th>
                                 <th>Vehicle Type</th>
                                 <th>Vehicle Model</th>
                                 <th>No Of Vehicles</th>
                                 <th>Dedicated/Ad-hoc</th>
                                 <th>Placement Time(HH:mm)</th>
                                 <th>Action</th>
                              </tr>
                           </thead>
                        </table>
                      

                     </div>
                  </div>
               </div>
            </div>
            <div class="modal-footer"  style="text-align: center; height:70px; padding:0px !important;" >
            	<div class="col-lg-12">
               		<div class="col-lg-4">
               		</div>
               		<div class="col-lg-4">
               			<input id="saveEditable" onclick="saveDataForEditableGrid()" type="button" class="btn btn-success" value="Validate" style="margin-top: 10px;align : center;"/>
               		</div>
               		<div class="col-lg-4">
               		</div>
               	</div>               
            </div>
         </div>
	 </div>
	 </div>
<!--      </div>   -->
      <div id="detailsModal" class="modal fade">
         <div class="modal-dialog add-intent">
            <div class="modal-content" style="width : 600px; margin-left : -45px;">
               <div class="modal-header">
			   
					<h4 id="nome" class="modal-title" style="text-align: left">Add Indent Details</h4>
				
					 <button type="button" class="close" data-dismiss="modal" style="margin-top: -2%;">&times;</button>  
               </div>
               <div class="modal-body" style="max-height: 50%;margin-bottom: -35px;">
                  <div class="col-md-12" style="padding:0px;">
                     <table class="table table-sm table-bordered table-striped">
                        <tbody>
                           <tr>
                              <td id="vtypelabelId">Vehicle Type<sup><font color="red">&nbsp;*</font></sup></td>
                              <td>
                                 <select class="form-control" id="vehicleTypeId" >
                                    <option value="">Select Vehicle Type</option>
                                 </select>
                              </td>
                           </tr>
                           <tr>
                              <td id="makelabelId">Vehicle Model<sup><font color="red">&nbsp;*</font></sup></td>
                              <td>
                                 <select class="form-control" id="makeId" >
                                    <option value="">Select Vehicle Model</option>
                                 </select>
                              </td>
                           </tr>
                           <tr>
                              <td>Number of Vehicles<sup><font color="red">&nbsp;*</font></sup></td>
                              <td><input type="number" min="0" class="form-control comboClass" style="width:305px;" maxLength="15" id=noofvehiclesId></td>
                           </tr>
                           <tr>
                              <td>Dedicated/Ad-hoc<sup><font color="red">&nbsp;*</font></sup></td>
                              <td>
                                 <select class="form-control" id="dedicatedadhoc" style="width:305px;" >
                                    <option value="Dedicated">Dedicated</option>
                                    <option value="Ad-hoc">Ad-hoc</option>
                                 </select>
                              </td>
                           </tr>
                           <tr>
                              <td id="ptimelabelId">Placement Time(HH:mm)<sup><font color="red">&nbsp;*</font></sup></td>
                              <td><input type="text" min="0" style="width:305px;" class="form-control comboClass" maxLength="15" id="placementTimeId"></td>
                           </tr>
                        </tbody>
                     </table>
                  </div>
               </div>
               <div class="modal-footer"  style="text-align: center;">
               		<div class="col-lg-12">
               			<div class="col-lg-2">
               			</div>
               			<div class="col-lg-8">
               				<input id="saveedit" onclick="saveDataEdit()" type="button" class="btn btn-success" value="Save" />
                  			<button type="reset" class="btn btn-danger" data-dismiss="modal">Cancel</button> 
               			</div>
               			<div class="col-lg-2">
               			</div>
               		</div> 
                  
               </div>
            </div>
         </div>
      </div>
      <div id="indentMasterImportModal" class="modal fade"><!-- style="overflow:scroll;">  -->
         <div class="modal-dialog add-intent">
            <div class="modal-content" style="width : 1000px; margin-left: -192px;">
               <div class="modal-header">
                  
                  <h4 id="titleIndentMasterImport" class="modal-title" style="text-align : left">Import Indent</h4>
                  <button type="button" class="close" data-dismiss="modal">&times;</button>
               </div>
               <div class="modal-body"><!-- style="max-height: 50%;margin-bottom: -35px;">  -->
	       				<div class="col-xs-12" >
						<form id="importIndentMaster">
						 <div class="form-group">
						    <input type="file" name="img[]" class="file"  id="file">
						    <div class="input-group col-xs-12">
						      <input type="text" id="uploadExcel" class="form-control input-sm" disabled placeholder="Upload Excel">
						      <span class="input-group-btn">
						        <button class="browse btn btn-primary input-md" type="button"><i class="glyphicon glyphicon-search"></i> Browse</button>
						      </span>
						    </div>
						    
						  </div>
						  
							<button type="submit" class="btn btn-primary input-sm" id="upload" ><i class="glyphicon glyphicon-upload"></i>Upload</button>
							<button type="button" class="btn btn-primary input-sm" type="button" 
							id="standarFormat" onclick="window.location.href='<%=request.getContextPath()%>/IndentMasterDetails.do?param=getImportIndentMasterStdFormat'" >
							<i class="glyphicon glyphicon-save-file"></i>Get Standard format</button>
						 
						 </form>
						 
			    		</div>
					
			    		<div class="col-lg-12">
							<div  class="importIndentImagePanel" style="height:150px"></div>
			  			</div>
			  		  
			  		<div class="col-lg-12">
					<div id="overflow" class="overFlow">
	                    <table id="importIndentMasterTable" class="table table-striped table-bordered " cellspacing="0" width="100%" style="margin-top:1%" ">
	                     <thead>
	                        <tr>
	                           <th>Sl No</th>
	                           <th>Node</th>
	                           <th>Region</th>
	                           <th>Dedicated</th>
	                           <th>Ad-hoc</th>
	                           <th>Supervisor Name</th>
	                           <th>Supervisor Contact</th>
	                           <th>Record Status</th>
	                           <th>Remarks</th>
	                        </tr>
	                     </thead>
	                  </table>
					  </div>
                  </div>
               </div>
               <div class="modal-footer"  style="text-align: center;">
               
               		<div class="row" style="width:100%;">
               			<div class="col-sm-3 col-md-3">
               			</div>
               			<div class="col-sm-6 col-md-6">
               				<input id="importSave" type="button" class="btn btn-success" value="Save" onclick="saveImportRecord()"/>
                  			<button type="reset" class="btn btn-danger" data-dismiss="modal">Cancel</button>  
               			</div>
               			<div class="col-sm-3 col-md-3">
               			</div>
               		</div> 
                  
               </div>
            </div>
         </div>
         </div>
 
 <div class="modal fade" id="importIndentResultModal" role="dialog">
    <div class="modal-dialog modal-md">
      <div class="modal-content" style="width : 160% !important;">
        <div class="modal-header">
          <button type="button" class="close" data-dismiss="modal">&times;</button>
			<h4 id="errorTitle" class="modal-title" style="text-align:left; margin-left:5px;">Import Result</h4>
        </div>
        <div class="modal-body" style="margin-top:5px">
			<div id="importIndentResultMsgDiv"></div>
		</div>
        <div class="modal-footer">
          <div class="modal-footer"  style="text-align: center;">          
          			<div class="col-lg-12">
               			<div class="col-lg-4">
               			</div>
               			<div class="col-lg-4">
               				<button type="reset" class="btn btn-danger" data-dismiss="modal">Close</button>  
               			</div>
               			<div class="col-lg-4">
               			</div>
               		</div>                
          </div>
        </div>
      </div>
    </div>
  </div>
       <div id="indentDetailsImportModal" class="modal fade " >
         <div class="modal-dialog import-details-intent"><!-- style="position: absolute;left: 10%;top: 45%;;margin-top: -250px;width:165%;">     -->
            <div class="modal-content" style="width : 1000px; margin-left: -192px;">
            
               <div class="modal-header">
                  
                  <h4 id="titleIndentDetailsImport" class="modal-title" style="text-align : left;">Import Indent Model Details</h4>
                  <button type="button" class="close" data-dismiss="modal">&times;</button>
               </div>
               <div class="modal-body"><!-- style="max-height: 50%;margin-bottom: -35px;">   -->
	       			<div class="row" >
						<form id="importIndentDetails">
						 <div class="form-group">
						    <input type="file" name="img[]" class="file"  id="fileIndentDetails">
						    <div class="input-group col-sm-12">
						      <input type="text" id="uploadIndentDetailsExcel" class="form-control input-sm" disabled placeholder="Upload Excel">
						      <span class="input-group-btn">
						        <button id="browseIndentDetails" class="browse btn btn-primary input-md" type="button"><i class="glyphicon glyphicon-search"></i> Browse</button>
						      </span>
						    </div>
						  </div>
						  
							<button type="submit" class="btn btn-primary input-sm" id="uploadIndentDetails" ><i class="glyphicon glyphicon-upload"></i>Upload</button>
							<button type="button" class="btn btn-primary input-sm" type="button" 
										id="stdIndentVehicle" onclick="window.location.href='<%=request.getContextPath()%>/IndentMasterDetails.do?param=getImportIndentVehicleStdFormat'">
										<i class="glyphicon glyphicon-save-file"></i>Get Standard format</button>
						 </form>
			    		</div>
			    		<div class="col-sm-12">
			  				<div  class="importIndentVehicleImagePanel" style="height:150px"></div>
			  			</div>
						<div class="col-sm-12">
						<div id="overflow" class="overFlow">	
						<table id="indentDetailsImportTable" class="table table-striped table-bordered" cellspacing="0" width="100%" >
							<thead>
								<tr>
									<th>Sl No</th>
									<th>Node</th>
									<th>Vehicle Type</th>
									<th>Vehicle Model</th>
									<th>Dedicated/Ad-hoc</th>
									<th>No of Vehicles</th>
									<th>PlacementTime(HH:mm)</th>
									<th>Record Status</th>
									<th>Remarks</th>
								</tr>
	                      </thead>
	                  </table>
					  </div>
					  </div>
               
               </div>
               <div class="modal-footer"  style="text-align: center;">
               		<div class="row" style="width:100%;">
               			<div class="col-sm-3 col-md-3">
               			</div>
               			<div class="col-sm-6 col-md-6">
               				<input id="importIndentDetailsSaveBtn" type="button" class="btn btn-success" value="Save" onclick="saveImportIndentDetailsRecord()"/>
                  			<button type="reset" class="btn btn-danger" data-dismiss="modal">Cancel</button>  
               			</div>
               			<div class="col-sm-3 col-md-3">
               			</div>
               		</div>                   
               </div>
            </div>
         </div>
         </div>
      
  	      <div class="modal" id="pleaseWaitDialog" data-backdrop="static" data-keyboard="false" role="dialog">
 	       <div class="modal-dialog wait">
            <div class="modal-content" style="width : 160% !important;">
                <div class="modal-header">
                    <h4 class="modal-title">Please wait...</h4>
                </div>
                <div class="modal-body">
                    <div class="progress">
                      <div class="progress-bar progress-bar-info progress-bar-striped active" role="progressbar"
                      aria-valuenow="100" aria-valuemin="0" aria-valuemax="100" style="width:100%; height: 40px">
                      </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
 <script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
 <script type="text/javascript">
    var custId;
    var prntTable;
    var indentId;
    var adhocCVCount;
    var dedicatedCVCount;
    var buttonValue;
    var recordId;
    var vehicleTypeList;
	var indentAddOrModify;
	var totalAdhocVCount={};
	var totalDedicatedVCount={};
	var assignedAdhocCount={};
	var assignedDedicatedCount={};
	var indentMasterId ={};
	var previousAssignedVCount={};
	var previousAssignedType={};
	var exampletable;
	var importIndentMasterRoot={};
	var totalRecords=0;
	var validRecord=0;
	var totalIndentDetailsRecords=0;
	var validIndentDetailsRecord=0;
	var importIndentMasterTable;
	var indentDetailsImportTable;
	window.onload = function () { 
		getTripNames();
	}
    function addOrUpdateIndent(id, adhocCount, dedicatedCount, mode) {
        if(mode == 0){
	        var customerName = document.getElementById("custNames").value;
	        var mllCust = document.getElementById("cust_names").value;
	        if (customerName == "") {
	            sweetAlert("Please select customer");
	            return;
	        }
	        if (mllCust == "") {
	            sweetAlert("Please select customer ID");
	            return;
	        }
	        document.getElementById("regionId").value = "";
            document.getElementById("dedicatedId").value = "";
            document.getElementById("adHocId").value = "";
            document.getElementById("superNameId").value = "";
            document.getElementById("superContactId").value = "";
            $("#nodeId").val('Select Node').trigger('change');
	        indentAddOrModify = "add";
	        $('#addModify').modal('show');
	        $(".modal-header #titleAddOrUpdate").text("Add Indent Details");
	        $('#save1').attr('value', 'Save');
	        document.getElementById("nodeId").disabled=false;
        }
        else{
           	  var param ={
					  id:id
			  };
        	 $.ajax({
                 url: '<%=request.getContextPath()%>/IndentMasterDetails.do?param=getIndentById',
                 data: {
                     id: id,
                 },
                 success: function(result) {
                  results = JSON.parse(result);
                  document.getElementById("regionId").value = results["indentRoot"][0].regionIndex;
                  document.getElementById("dedicatedId").value = results["indentRoot"][0].dedicatedIndex;
                  document.getElementById("adHocId").value = results["indentRoot"][0].adhocIndex;
                  document.getElementById("superNameId").value = results["indentRoot"][0].supervisorName;
                  document.getElementById("superContactId").value = results["indentRoot"][0].supervisorContact;
                  totalAdhocVCount=results["indentRoot"][0].adhocIndex;
                  totalDedicatedVCount=results["indentRoot"][0].dedicatedIndex;
                  
                  indentMasterId = results["indentRoot"][0].id;
                  var nodeId = results["indentRoot"][0].nodeIdIndex;
                  $("#nodeId").val(nodeId).trigger('change');
                  document.getElementById("nodeId").disabled=true;
                 }
                 
             });
        	 assignedAdhocCount = adhocCount;
        	 assignedDedicatedCount = dedicatedCount;
	       	indentAddOrModify = "modify";
	       	$('#addModify').modal('show');
	       	$(".modal-header #titleAddOrUpdate").text("Modify Indent Details");
	        $('#save1').attr('value', 'Update');
        }
    }

    function viewDetails() {
        var mllCust = document.getElementById("cust_names").value;
        getIndentMasterData(custId, mllCust);
    }

    function saveData() {

        var customerName = document.getElementById("custNames").value;
        var mllCust = document.getElementById("cust_names").value;
        var node = document.getElementById("nodeId").value;
        var region = document.getElementById("regionId").value;
        var dedicated = document.getElementById("dedicatedId").value;
        var adhoc = document.getElementById("adHocId").value;
        var superName = document.getElementById("superNameId").value;
        var superContact = document.getElementById("superContactId").value;

        if (customerName == "") {
            sweetAlert("Please select Customer");
            return;
        }
        if (node == "") {
            sweetAlert("Please select Node");
            return;
        }
        if (region == "") {
            sweetAlert("Please select Region");
            return;
        }
        if (dedicated == "") {
            sweetAlert("Please enter Dedicated Number of Vehicles");
            return;
        }
        if (adhoc == "") {
            sweetAlert("Please enter Ad-hoc Number of Vehicles");
            return;
        }
        if (superName == "") {
            sweetAlert("Please enter Supervisor Name");
            return;
        }
        if (superContact == "") {
            sweetAlert("Please enter Supervisor Contact");
            return;
        }
		
        if(indentAddOrModify == "modify")
        {
        	if( Number(document.getElementById("dedicatedId").value) < Number(assignedDedicatedCount))
        	{
            	sweetAlert("Dedicated number of vehicles cannot be less than assigned number of vehicles");
            	return;
        	} 
        	if( Number(document.getElementById("adHocId").value) < Number(assignedAdhocCount))
        	{
            	sweetAlert("Ad-hoc number of vehicles cannot be less than assigned number of vehicles");
            	return;
        	}            	 
        }
        var param = {
            CustId: custId,
            node: node,
            region: region,
            dedicated: dedicated,
            adhoc: adhoc,
            superName: superName,
            superContact: superContact,
            mllCust: mllCust,
            action : indentAddOrModify,
            indentMasterId :indentMasterId
        };
        $.ajax({
            url: '<%=request.getContextPath()%>/IndentMasterDetails.do?param=saveIndentDetails',
            data: param,
            success: function(result) {
                if (result == "success") {
                    if(indentAddOrModify == "add")
                    	sweetAlert("Saved Successfully");
                    else if(indentAddOrModify == "modify")
                    	sweetAlert("Modified Successfully");
                    setTimeout(function() {
                        getIndentMasterData(custId, mllCust);
                       
                        $('#addModify').modal('hide');
                    }, 1000);

                    document.getElementById("nodeId").value = "";
                    document.getElementById("regionId").value = "";
                    document.getElementById("dedicatedId").value = "";
                    document.getElementById("adHocId").value = "";
                    document.getElementById("superNameId").value = "";
                    document.getElementById("superContactId").value = "";

                } else {
                    sweetAlert(result);
                }
                
            }
        });
    }

    function saveDataEdit() {
        var vehicleType = document.getElementById("vehicleTypeId").value;
        var make = document.getElementById("makeId").value;
        var noOfVehicles = document.getElementById("noofvehiclesId").value;
        var DedicaedAdhoc = document.getElementById("dedicatedadhoc").value;
        var placementTime = document.getElementById("placementTimeId").value;
        if (vehicleType == "") {
            sweetAlert("Please select Vehicle Type");
            return;
        }
        if (make == "") {
            sweetAlert("Please select Vehicle Model");
            return;
        }
        if (noOfVehicles == "") {
            sweetAlert("Please enter number of vehicles");
            return;
        }
        if (DedicaedAdhoc == "") {
            sweetAlert("Please Select Type");
            return;
        }
        if (placementTime == "") {
            sweetAlert("Please enter Placement Time");
            return;
        }
        var datePattern = /^([01]\d|2[0-3]):?([0-5]\d)$/;
        if (!datePattern.test(placementTime)) {
            sweetAlert("Enter Placement time in HH:mm format");
            return;
        }
        var result = validate(buttonValue,noOfVehicles,DedicaedAdhoc);
        if(!result){
            return;
        }
        var param = {
            id: indentId,
            vehicleType: vehicleType,
            make: make,
            noOfVehicles: noOfVehicles,
            DedicaedAdhoc: DedicaedAdhoc,
            placementTime: placementTime,
            action: buttonValue,
            indentMasterId : indentMasterId
        };
        $.ajax({
            url: '<%=request.getContextPath()%>/IndentMasterDetails.do?param=saveIndentVehicleDetails',
            data: param,
            success: function(result) {
            	results = JSON.parse(result);
            	
            	var message="";
            	if(results["indentDetailRoot"][0].message == "success"){
	                if(buttonValue =="add"){
	                	updateAssignedCount(noOfVehicles,DedicaedAdhoc,buttonValue);
	                	message="Saved successfully";
	                }else if(buttonValue =="modify"){
		                if(results["indentDetailRoot"][0].assignedAdhocCount != undefined){
	                		assignedAdhocCount = results["indentDetailRoot"][0].assignedAdhocCount;
		                }else{
		                	assignedAdhocCount = 0;
		                }
		                if(results["indentDetailRoot"][0].assignedDedicatedCount != undefined){
	                		assignedDedicatedCount = results["indentDetailRoot"][0].assignedDedicatedCount;
		                }else{
		                	assignedDedicatedCount = 0;
		                }
	                	message="Modified successfully";
	                	updateVehiclesCountTable();
	                }
	            	prntTable.ajax.reload();
	            	$('#detailsModal').modal('hide');
	            	viewDetails();
            	}
            	else{
            		message="Error saving";
            	}
            	sweetAlert(message);
                document.getElementById("vehicleTypeId").value = "";
            	document.getElementById("makeId").value = "";
            	document.getElementById("noofvehiclesId").value = "";
            	document.getElementById("dedicatedadhoc").value = "";
            	document.getElementById("placementTimeId").value = "";
            }
        });
    }

    function updateAssignedCount(noOfVehicles,DedicaedAdhoc,buttonValue){
		if(buttonValue == "add"){
			if(DedicaedAdhoc == "Ad-hoc"){
				assignedAdhocCount = Number(assignedAdhocCount)+Number(noOfVehicles);
			}
			else if(DedicaedAdhoc == "Dedicated"){
				assignedDedicatedCount = Number(assignedDedicatedCount)+Number(noOfVehicles);
			}
		}
		updateVehiclesCountTable();
    }

    function saveDataForEditableGrid() {
        $.ajax({
            url: '<%=request.getContextPath()%>/IndentMasterDetails.do?param=getTotalCount',
            data: {
                id: recordId,
            },
            success: function(result) {
                results = JSON.parse(result);
                //alert(Number(results["countroot"][0].adhoc) + '---- ' + Number(results["countroot"][0].totaladhoc));
                //alert(Number(results["countroot"][0].dedicatedC) + '==== ' + Number(results["countroot"][0].totaldedicatedC));
                if(Number(results["countroot"][0].totaldedicatedC)==0 && Number(results["countroot"][0].totaladhoc)==0){
                	sweetAlert("No records to save");
                }else{

	                if (Number(results["countroot"][0].adhoc) != Number(results["countroot"][0].totaladhoc)) {
	                    sweetAlert("Ad-hoc count is not matching");
	                    return;
	                }
	                if (Number(results["countroot"][0].dedicatedC) != Number(results["countroot"][0].totaldedicatedC)) {
	                    sweetAlert("Dedicated count is not matching");
	                    return;
	                }
	                sweetAlert("Validation successful");
	                prntTable.ajax.reload();
	                $('#gridModal').modal('hide');
                }
            }
        });
    }

    function getIndentMasterData(custId, mllCust) {
        if (document.getElementById("custNames").value == '') {
            sweetAlert("Please select Customer Name");
        } else if (document.getElementById("cust_names").value == '') {
            sweetAlert("Please select Customer");
        } else {
            if ($.fn.DataTable.isDataTable('#example')) {
                $('#example').DataTable().destroy();
            }
            var userAuthority = "<%=userAuthority%>";
            exampletable = $('#example').DataTable({
                "ajax": {
                    "url": "<%=request.getContextPath()%>/IndentMasterDetails.do?param=getIndentMasterDetails",
                    "dataSrc": "indentMasterRoot",
                    "data": {
                        custId: custId,
                        mllCust: mllCust,
                        userAuthority: userAuthority
                    }
                },
                "bLengthChange": true,
                "dom": 'Bfrtip',
                "buttons": [{
                    extend: 'pageLength'
                }, {
                    extend: 'excel',
                    text: 'Export to Excel',
                    className: 'btn btn-primary'
                }],
                "columns": [{
                    "data": "slno"
                },{
                    "data": "nodeIndex"
                }, {
                    "data": "regionIndex"
                }, {
                    "data": "dedicatedIndex"
                }, {
                    "data": "adhocIndex"
                }, {
                    "data": "totalIndex"
                }, {
                    "data": "assignedDedicatedIndex"
                }, {
                    "data": "assignedAdhocIndex"
                }, {
                    "data": "supervisorName"
                }, {
                    "data": "supervisorContact"
                }, {
                    "data": "button"
                }, {
                    "data": "modifyButton",
                    "visible":<%=isAdmin%>
                }]
            });
            
        }
    }
    $('#custNames').change(function() {
        custId = $('#custNames option:selected').attr('value');
        getNodes(custId);
    });

    function  getTripNames() {
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
					    getNodes(customerDetails["CustomerRoot"][0].CustId);
					}
            }
        });
       
        $.ajax({
           url: '<%=request.getContextPath()%>/IndentMasterDetails.do?param=getCustomer',
            success: function(response) {
                custList = JSON.parse(response);
                var output = '';
                for (var i = 0; i < custList["customerRoot"].length; i++) {
                    $('#cust_names').append($("<option></option>").attr("value", custList["customerRoot"][i].CustId).text(custList["customerRoot"][i].CustName));
                }
                 if(custList["CustomerRoot"].length == 1){
				var cName="";
				for (var i = 0; i < custList["CustomerRoot"].length; i++) {
					cName = custList["CustomerRoot"][i].CustName;
				}
				function setSelectedIndex(s, v) {
					for ( var i = 0; i < s.options.length; i++ ) {
       			 		if ( s.options[i].text == v ) {
           		 			s.options[i].selected = true;
           		 			return;
        				}
   			 		}
				}
			setSelectedIndex(document.getElementById('cust_names'),cName);
			}
            }
        });
        getMakeForAdd();
        getVehicleTypeForAdd();
        
        
    }

    function getNodes(custId) {
        for (var i = document.getElementById("nodeId").length - 1; i >= 1; i--) {
            document.getElementById("nodeId").remove(i);
        }
        nodeArray = [];
        $.ajax({
            url: '<%=request.getContextPath()%>/MiddleMileDashboardAction.do?param=getHubs',
            data: {
                CustID: custId
            },
            success: function(result) {
                nodeList = JSON.parse(result);
                for (var i = 1; i < nodeList["HubDetailsRoot"].length; i++) {
                    $('#nodeId').append($("<option></option>").attr("value", nodeList["HubDetailsRoot"][i].hubId).text(nodeList["HubDetailsRoot"][i].hubName));
                }
               $('#nodeId').select2();
            }
        });
    }

    function getVehicleType(vehType) {
        var assetTypeArr = [];
        var vehicle;
        for (var i = document.getElementById("vehicleTypeId").length - 1; i >= 1; i--) {
            document.getElementById("vehicleTypeId").remove(i);
        }
        $.ajax({
            url: '<%=request.getContextPath()%>/IndentMasterDetails.do?param=getAssetType',
            data: {
                CustID: custId
            },
            success: function(result) {
                vehicleTypeList = JSON.parse(result);
                for (var i = 0; i < vehicleTypeList["assetTypeRoot"].length; i++) {
                    $('#vehicleTypeId').append($("<option></option>").attr("value", vehicleTypeList["assetTypeRoot"][i].AssetType).text(vehicleTypeList["assetTypeRoot"][i].AssetType));
                }
              $('#vehicleTypeId').select2();
	              for(var j = 0; j < vehicleTypeList["assetTypeRoot"].length; j++)
	              {
	              		if (vehicleTypeList["assetTypeRoot"][j].AssetType == vehType) {
	              			vehicle = vehicleTypeList["assetTypeRoot"][j].AssetType;
	              		}
	              }
	              $("#vehicleTypeId").val(vehicle).trigger('change');
            }
        });
    }

    function getMake(makeType) {
    var makeValue;
    for (var i = document.getElementById("makeId").length - 1; i >= 1; i--) {
            document.getElementById("makeId").remove(i);
        }
        $.ajax({
            url: '<%=request.getContextPath()%>/IndentMasterDetails.do?param=getMake',
            data: {
                CustID: custId
            },
            success: function(result) {
                makeList = JSON.parse(result);
                for (var i = 0; i < makeList["makeRoot"].length; i++) {
                    $('#makeId').append($("<option></option>").attr("value", makeList["makeRoot"][i].make).text(makeList["makeRoot"][i].make));
                }
                 $('#makeId').select2();
                 
	                for(var j = 0; j < makeList["makeRoot"].length; j++)
	              	{
	              		if (makeList["makeRoot"][j].make == makeType) {
	              			makeValue = makeList["makeRoot"][j].make;
	              		}
	              	}
	                $("#makeId").val(makeValue).trigger('change');
            }
        });
    }
    
       function getVehicleTypeForAdd() {
        for (var i = document.getElementById("vehicleTypeId").length - 1; i >= 1; i--) {
            document.getElementById("vehicleTypeId").remove(i);
        }
        $.ajax({
            url: '<%=request.getContextPath()%>/IndentMasterDetails.do?param=getAssetType',
            data: {
                CustID: custId
            },
            success: function(result) {
                vehicleTypeList = JSON.parse(result);
                for (var i = 0; i < vehicleTypeList["assetTypeRoot"].length; i++) {
                    $('#vehicleTypeId').append($("<option></option>").attr("value", vehicleTypeList["assetTypeRoot"][i].AssetType).text(vehicleTypeList["assetTypeRoot"][i].AssetType));
                }
              $('#vehicleTypeId').select2();
            }
        });
    }
    
    function getMakeForAdd() {
    for (var i = document.getElementById("makeId").length - 1; i >= 1; i--) {
            document.getElementById("makeId").remove(i);
        }
        $.ajax({
            url: '<%=request.getContextPath()%>/IndentMasterDetails.do?param=getMake',
            data: {
                CustID: custId
            },
            success: function(result) {
                makeList = JSON.parse(result);
                for (var i = 0; i < makeList["makeRoot"].length; i++) {
                    $('#makeId').append($("<option></option>").attr("value", makeList["makeRoot"][i].make).text(makeList["makeRoot"][i].make));
                }
                 $('#makeId').select2();
            }
        });
    }

    function openModal(id, adhocC, dedicatedC,totalAssignedAdhoc,totalAssignedDedicated, flag) {
     if(flag=='0' || flag == 0)
     {
        $(".modal-header #tripEventsTitle").text("View Details");
        
     }
     else
     {
     	$(".modal-header #tripEventsTitle").text("Add Details");
     }
        $('#gridModal').modal('show');
        if ($.fn.DataTable.isDataTable('#editableGrid')) {
            $('#editableGrid').DataTable().destroy();
        }
        recordId = id;

        prntTable = $('#editableGrid').DataTable({
            "ajax": {
                "url": "<%=request.getContextPath()%>/IndentMasterDetails.do?param=getIndentMasterDetails1",
                "dataSrc": "indentMasterRoot1",
                "data": {
                    uniqueId: id
                }
            },
            "bLengthChange": false,
            "dom": 'Bfrtip',
            "scrollY": '50vh',
            "buttons": [{
                extend: 'pageLength'
            }, {
                extend: 'excel',
                text: 'Export to Excel',	
                className: 'btn btn-primary'
            }],
            "columns": [{
                "data": "slno"
            }, {
                "data": "node"
            }, {
                "data": "vehcileType"
            }, {
                "data": "make"
            }, {
                "data": "noOfVehcicles"
            }, {
                "data": "dedicated"
            }, {
                "data": "placementTime"
            }, {
                "data": "action"
            }]
        });

        $('#editableGrid').closest('.dataTables_scrollBody').css('max-height', '200px');
        totalAdhocVCount=adhocC;
    	totalDedicatedVCount=dedicatedC;
    	assignedAdhocCount=totalAssignedAdhoc;
    	assignedDedicatedCount=totalAssignedDedicated;
    	updateVehiclesCountTable();
        $('#addRow').on('click', function() {
            //getVehicleTypeForAdd();
           // getMakeForAdd();
           
            $('#detailsModal').modal('show');
            
            document.getElementById("noofvehiclesId").value = "";
        	document.getElementById("dedicatedadhoc").value = "";
        	document.getElementById("placementTimeId").value = "";
        	$("#vehicleTypeId").val('Select Vehicle Type').trigger('change');
       		$("#makeId").val('Select Vehicle Model').trigger('change');
            $("#saveedit").attr('value', 'Save');
            $(".modal-header #nome").text("Add Indent Details");
            indentId = id;
            recordId = id;
            indentMasterId = id;
			buttonValue = 'add';
            $('#vtypelabelId').show();
            $('#vehicleTypeId').show();
            $('#ptimelabelId').show();
            $('#placementTimeId').show();
            $('#makelabelId').show();
            $('#makeId').show();
        });
    }

	function updateVehiclesCountTable(){
		document.getElementById("totalAdhoc").innerHTML=totalAdhocVCount;
		document.getElementById("totalDedicated").innerHTML=totalDedicatedVCount;
		document.getElementById("remainingDedicated").innerHTML=Number(totalDedicatedVCount)-Number(assignedDedicatedCount);
		document.getElementById("remainingAdhoc").innerHTML=Number(totalAdhocVCount)-Number(assignedAdhocCount);
		document.getElementById("assignedAdhoc").innerHTML=assignedAdhocCount;
		document.getElementById("assignedDedicated").innerHTML=assignedDedicatedCount;
	}

	function validate(buttonValue,noOfVehicles,DedicaedAdhoc){
		var assignedAdhocCountTemp=assignedAdhocCount;
		var assignedDedicatedCountTemp=assignedDedicatedCount;
		if(buttonValue =="add"){
			if(DedicaedAdhoc == "Ad-hoc"){
				assignedAdhocCountTemp = Number(assignedAdhocCountTemp)+Number(noOfVehicles);
			}else if(DedicaedAdhoc == "Dedicated"){
				assignedDedicatedCountTemp = Number(assignedDedicatedCountTemp)+Number(noOfVehicles);
			}
		}
		else if(buttonValue =="modify"){
	     	if(DedicaedAdhoc == "Ad-hoc" && previousAssignedType == "Ad-hoc"){
	     		assignedAdhocCountTemp = Number(assignedAdhocCountTemp)-Number(previousAssignedVCount);
	     		assignedAdhocCountTemp = Number(assignedAdhocCountTemp)+Number(noOfVehicles);
	     	}
	     	else if(DedicaedAdhoc == "Ad-hoc" && previousAssignedType == "Dedicated"){
	     		assignedDedicatedCountTemp = Number(assignedDedicatedCountTemp)-Number(previousAssignedVCount);
	     		assignedAdhocCountTemp = Number(assignedAdhocCountTemp)+Number(noOfVehicles);
	     	}
	     	else if(DedicaedAdhoc == "Dedicated" && previousAssignedType == "Dedicated"){
	     		assignedDedicatedCountTemp = Number(assignedDedicatedCountTemp)-Number(previousAssignedVCount);
	     		assignedDedicatedCountTemp = Number(assignedDedicatedCountTemp)+Number(noOfVehicles);
	     	}
	     	else if(DedicaedAdhoc == "Dedicated" && previousAssignedType == "Ad-hoc"){
	     		assignedAdhocCountTemp = Number(assignedAdhocCountTemp)-Number(previousAssignedVCount);
	     		assignedDedicatedCountTemp = Number(assignedDedicatedCountTemp)+Number(noOfVehicles);
	     		
	     	}
		}
		if(Number(assignedAdhocCountTemp) > totalAdhocVCount){
	     	sweetAlert("Assigned number of vehicles cannot be more than Total Ad-hoc vehicles");
	     	return false;
     	}
     	if(Number(assignedDedicatedCountTemp) > totalDedicatedVCount){
	     	sweetAlert("Assigned number of vehicles cannot be more than Total Dedicated vehicles");
	     	return false;;
     	}
     	return true;
	}
    function updateRecord(uniqueId, vtype, vcount, i,vehicleTyp,makeU,pTime) {
   
        $('#detailsModal').modal('show');
        $("#saveedit").attr('value', 'Update');
        $(".modal-header #nome").text("View Indent Details");
        document.getElementById("noofvehiclesId").value = vcount;
        document.getElementById("dedicatedadhoc").value = vtype;
        document.getElementById("placementTimeId").value = pTime;
        document.getElementById("vehicleTypeId").value = vehicleTyp.split("*").join(" ");
        document.getElementById("makeId").value = makeU.split("*").join(" ");
        vehicleTyp=vehicleTyp.split("*").join(" ");
        makeU=makeU.split("*").join(" ");
        getVehicleType(vehicleTyp);
        getMake(makeU);
        
        buttonValue = 'modify';
        indentId = uniqueId;
        recordId = i;
        indentMasterId=i;
     	previousAssignedVCount = vcount;
     	previousAssignedType=vtype;
     	
    }
    /////////////////////Import Indent Master Start///////////////////////////////////////////
    function importExcelData(){
   
    	 $('#indentMasterImportModal').modal('show');
    	 clearIndentImportFormData();
    }

	function clearIndentImportFormData(){
		if ($.fn.DataTable.isDataTable('#importIndentMasterTable')) {
	  	     $('#importIndentMasterTable').dataTable().fnClearTable();
	             $('#importIndentMasterTable').DataTable().destroy();
	         }
	         document.getElementById("uploadExcel").value="";
	         document.getElementById("file").value="";
	         document.getElementById("importSave").disabled=false;
	         totalRecords=0;
	     	 validRecord=0;
	}
    
    $(document).on('click', '.browse', function(){

    	var file = $(this).parent().parent().parent().find('.file');
	  file.trigger('click');
	});
    $(document).on('change', '.file', function(){
	  $(this).parent().find('.form-control').val($(this).val().replace(/C:\\fakepath\\/i, ''));
      });
  
   	$("form#importIndentMaster").submit(function(event){
	 //disable the default form submission
	  event.preventDefault();
	  if(document.getElementById("uploadExcel").value == ""){
	  	sweetAlert("Please choose the file");
		return;
	  }
	  checkFileType(document.getElementById("uploadExcel").value);
	  var mllCust = document.getElementById("cust_names").value;
	  var formData = new FormData($(this)[0]);
	  formData.append("mllCust",mllCust);
	 
	  $.ajax({
	    url: '<%=request.getContextPath()%>/IndentMasterDetails.do?param=importIndentMasterExcel',
	    type: 'POST',
	    data: formData,
	    async: false,
	    cache: false,
	    contentType: false,
	    processData: false,
	    success: function (result) {
			$("#overflow").removeClass("overFlow");
			results = JSON.parse(result);
			if(results["error"] != null)
	    		{	
		    		sweetAlert(results["error"][0]);
			    	return;
	    		}
	    		importIndentMasterRoot = results["importIndentMasterRoot"];
			totalRecords = results["TotalRecords"];
			validRecord = results["ValidRecord"];
	      		populateImportIndentTable(results["importIndentMasterRoot"]);
	      	
	    	}
	  });
  		return false;
	});

	function populateImportIndentTable(importIndentMasterRoot){
	if ($.fn.DataTable.isDataTable('#importIndentMasterTable')) {

		 $('#importIndentMasterTable').dataTable().fnClearTable();
           	 $('#importIndentMasterTable').DataTable().destroy();
          }
	    importIndentMasterTable = $('#importIndentMasterTable').DataTable({
            data: importIndentMasterRoot,
            "bLengthChange": true,
            "columns": [{
                "data": "slNo"
            },{
                "data": "node"
            }, {
                "data": "region"
            }, {
                "data": "dedicated"
            }, {
                "data": "adhoc"
            }, {
                "data": "supervisorName"
            }, {
                "data": "supervisorContact"
            }, {
                "data": "recordStatus"
            }, {
                "data": "errors",
                "visible":true
            }]
        });
	}
	
function saveImportRecord(){
	if(Number(totalRecords) >0){
		if(Number(validRecord) ==0){
			sweetAlert("No valid records to save");
			return;
		}else{
	    		swal({
			  title:  "We have " + validRecord + " valid transaction to be saved out of " + totalRecords + " .Do you want to continue?",
		 
			  type: "warning",
			  showCancelButton: true,

			  confirmButtonText: "Yes",
			  closeOnConfirm: true

			},
			function(){
	              document.getElementById("importSave").disabled=true;
				  var mllCust = document.getElementById("cust_names").value;
				  showPleaseWait();
				  $.ajax({
		              		  url: '<%=request.getContextPath()%>/IndentMasterDetails.do?param=saveIndentMasterImportData',
				              data: {
				                  custId : custId,
				                  mllCust: mllCust
				              },
		             	 success: function(result) {
				           hidePleaseWait();
				           $('#importIndentResultModal').modal('show');
				           document.getElementById("importIndentResultMsgDiv").innerHTML=result;
				           document.getElementById("importSave").disabled=false;
				           clearIndentImportFormData();
				           setTimeout(function() {
				        	   viewDetails();
		                       		   $('#indentMasterImportModal').modal('hide');
		                          }, 1000);
	              }
	           })
		});
	    }
	}
    }
/////////////////////Import Indent Master End///////////////////////////////////////////
/////////////////////Import Indent Vehicle Details Start////////////////////////////////
    function importIndentDetailsExcel(){
    	 $('#indentDetailsImportModal').modal('show');
    	 clearIndentVehicleImportFormData();
    }

	function clearIndentVehicleImportFormData(){
		if ($.fn.DataTable.isDataTable('#indentDetailsImportTable')) {
 	     	 $('#indentDetailsImportTable').dataTable().fnClearTable();
        	  $('#indentDetailsImportTable').DataTable().destroy();
        }
        document.getElementById("uploadIndentDetailsExcel").value="";
        document.getElementById("fileIndentDetails").value="";
        document.getElementById("uploadIndentDetails").disabled=false;
        document.getElementById("importIndentDetailsSaveBtn").disabled=false;
        totalIndentDetailsRecords=0;
        validIndentDetailsRecord=0;
	}
    
    $(document).on('click', '.browseIndentDetails', function(){
    	var file = $(this).parent().parent().parent().find('.fileIndentDetails');
	  	file.trigger('click');
	});
    $(document).on('change', '.fileIndentDetails', function(){
	  	$(this).parent().find('.form-control').val($(this).val().replace(/C:\\fakepath\\/i, ''));
      });
  
   	$("form#importIndentDetails").submit(function(event){
	 //disable the default form submission
	  event.preventDefault();
	  if(document.getElementById("uploadIndentDetailsExcel").value == ""){
	  	sweetAlert("Please choose the file");
		return;
	  }

	  document.getElementById("uploadIndentDetails").disabled=true;
	  checkFileType(document.getElementById("uploadIndentDetailsExcel").value);
	  var mllCust = document.getElementById("cust_names").value;
	  var formData = new FormData($(this)[0]);
	  formData.append("mllCust",mllCust);  
		
	  $.ajax({
	    url: '<%=request.getContextPath()%>/IndentMasterDetails.do?param=importIndentDetailsExcel',
	    type: 'POST',
	    data: formData,
	    async: false,
	    cache: false,
	    contentType: false,
	    processData: false,
	    success: function (result) {
	    	results = JSON.parse(result);
		document.getElementById("uploadIndentDetails").disabled=false;
	    	if(results["error"] != null)
	    	{	
		    	sweetAlert(results["error"][0]);
		    	return;
	    	}
	    	importIndentMasterRoot = results["importIndentDetailsRoot"];
			totalIndentDetailsRecords = results["TotalRecords"];
			validIndentDetailsRecord = results["ValidRecord"];
	
	      	populateImportIndentDetailsTable(results["importIndentDetailsRoot"]);
	      
	    }
	  });
  		return false;
	});

	function populateImportIndentDetailsTable(importIndentDetailsRoot){
		if ($.fn.DataTable.isDataTable('#indentDetailsImportTable')) {
            $('#indentDetailsImportTable').DataTable().destroy();
        }

		indentDetailsImportTable = $('#indentDetailsImportTable').DataTable({
            data: importIndentMasterRoot,
            //"bLengthChange": true,
            "bLengthChange": true,            
            "columns": [{
                "data": "slNo"
            },{
                "data": "node"
            }, {
                "data": "vehicleType"
            }, {
                "data": "make"
            }, {
                "data": "dedicatedOrAdhoc"
            }, {
                "data": "noOfVehicles"
            }, {
                "data": "placementTime"
            }, {
                "data": "recordStatus"
            }, {
                "data": "errors",
                "visible":true
            }]
        });
	}
function saveImportIndentDetailsRecord(){
	if(Number(totalIndentDetailsRecords) == 0 || Number(validIndentDetailsRecord) ==0){
			sweetAlert("No valid records to save");
			return;
	}
	    	swal({
			  title:  "We have " + validIndentDetailsRecord + " valid transaction to be saved out of " + totalIndentDetailsRecords + " .Do you want to continue?",
		 
			  type: "warning",
			  showCancelButton: true,
			  confirmButtonClass: "btn-danger",
			  confirmButtonText: "Yes",
			  closeOnConfirm: true
			},
			function(){
			var mllCust = document.getElementById("cust_names").value;
			document.getElementById("importIndentDetailsSaveBtn").disabled=true;
			showPleaseWait();
	    	  	$.ajax({
	              		  url: '<%=request.getContextPath()%>/IndentMasterDetails.do?param=saveIndentDetailsImportData',
			              data: {
			                  custId : custId,
			                  mllCust: mllCust
			              },
	             	 success: function(result) {
			 				hidePleaseWait();
			            	$('#importIndentResultModal').modal('show');
					 		document.getElementById("importIndentResultMsgDiv").innerHTML=result;
			                clearIndentVehicleImportFormData();
							setTimeout(function() {
			        	   	viewDetails();
	                       		 $('#indentDetailsImportModal').modal('hide');
	                    		}, 500);
	              }
	           })
		});
	
    }



function checkFileType(fileName){
    var ext = fileName.substring(fileName.lastIndexOf('.') + 1);

    if(!(ext =="xls" || ext=="xlsx"))
    {
        sweetAlert("Please choose .xls or .xlsx file");
	return;
    }
}

function getImportIndentMasterStdFormat(){
	$.ajax({
		  url: '<%=request.getContextPath()%>/IndentMasterDetails.do?param=getImportIndentMasterStdFormat',
		 success: function(result) {
      	
		}
	});
}
function showPleaseWait() {
    $("#pleaseWaitDialog").modal("show");
}

function hidePleaseWait() {
    $("#pleaseWaitDialog").modal("hide");
}

 /////////////////////Import Indent Vehicle Details End///////////////////////////////////////////
</script>
 <jsp:include page="../Common/footer.jsp" />
 <!-- </body>   -->
 <!-- </html> -->