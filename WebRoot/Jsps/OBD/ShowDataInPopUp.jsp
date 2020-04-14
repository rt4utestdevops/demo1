<%@ page language="java" import="java.util.*" pageEncoding="ISO-8859-1"%>
<%@ page import="t4u.beans.LoginInfoBean" %>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
String paramid = request.getParameter("altCardId");
String vehiNo = "";
if(request.getParameter("vehNo") != null && !request.getParameter("vehNo").equals("")){
	vehiNo =request.getParameter("vehNo");
}
LoginInfoBean loginInfoBean = (LoginInfoBean) session.getAttribute("loginInfoDetails");
if(loginInfoBean == null){
	response.sendRedirect(request.getContextPath()+ "/Jsps/Common/SessionDestroy.html");
}
%>


<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
  	 <meta charset="utf-8">
      <meta http-equiv="x-ua-compatible" content="ie=edge">
      <title>Show Data Page</title>
      <meta name="description" content="">
      <meta name="viewport" content="width=device-width, initial-scale=1">
      <link rel="stylesheet" href="../../Main/resources/css/obd/wrap-styles.css">
	  <script src="https://code.jquery.com/jquery-1.12.4.js"></script>
	 
     <script src="../../Main/Js/bootstrap.min.js"></script>
	<script src="https://cdn.datatables.net/1.10.15/js/jquery.dataTables.min.js"></script>
	<link  rel="stylesheet" href="https://cdn.datatables.net/1.10.15/css/jquery.dataTables.min.css">
	<style>
	
#tabbodydtc_wrapper{
		padding-top: 5%;
}

div.dataTables_wrapper div.dataTables_processing {
	 margin-top: 10%;
}
.odd{
    background-color: #46546b !IMPORTANT;
    color: #fff !IMPORTANT;
}

.even{
    background-color: #46546b !IMPORTANT;
    color: #fff !IMPORTANT;
}
input {
   border-radius: 4px;
}
.dataTables_wrapper .dataTables_filter input {
    color: black; 
}

label {
    color: white;
}
select{
	color: Black;
}
.code-txt-dtc {
margin-top: 60px;	
}   

button {
	border-radius: 4px;
	background-color: transparent;
	font-weight: 400;
	font-size: 14px;
	color:white;
	background-color: #313642;
}

.error-list-table .table thead tr th {
	font-weight: 500;
	font-size: 14px;
	/*color: rgba(244, 244, 244, 0.9);*/
	color: #46546b ;
	line-height: 22px;
	text-transform: uppercase;
}

body
{
	background-color: #fff;
}

.header {
    background-color: #46546b;
    padding-top: 10px;
    padding-bottom: 10px;
    vertical-align: middle;
    border-bottom: 2px solid #282F3D;
}
</style>
</head>
  
  <body>
  
   <!-- header -->
   
   
      <div class="header-section">
         <section class="header">
            <div class="container-custom">
               <div class="logo">
                  <div class="logo-text">
                     <p>OBD <span class="lg-txt"> Dashboard</span></p>
                  </div>
                  <div class="clearfix"></div>
               </div>
               <div class="menu-items">
                  <div class="search-section">
                 <!--     <div class="icon"><a href="#"><img src="../../Main/resources/images/obd/search.svg" alt="user"></a></div>  
                     <div class="search-field">
                        <input class="search" type="search" placeholder="Search" />
                     </div>  -->
                  </div>
                  <div class="clearfix"></div>
               </div>
               <div class="clearfix"></div>
            </div>
         </section>
      </div>
  <!-- //header -->
 
  
  <!--     <div class=>
         <div id="myModalDTC" class="modal fade" role="dialog">
            <div class="modal-dialog modal-lg">
               
               <div class="modal-content">
                  <div class="modal-body">  -->
				  
				  
			  <!--  	  <div class="obd-modal">   -->
				    <div class="code-txt-dtc">
                     <div class="container">
  <!--                 <button type="button" class="close" data-dismiss="modal">&times;</button> -->
                        <h4 id="dtcCardName"> </h4>
						
						<div class="row">
						 <button type="button" class="btn-md" id="backButtonId">Back</button>
						</div>
						
                        <div class="row">
                         <!--   <div class="col-md-6">
                             <div class="error-list-img">
                                 <img src="../../Main/resources/images/obd/powr_tyrain copy.png" alt="power train">
                              </div>
                           </div> -->
                           <div class="col-md-12">
                              <div class="error-list-table">
                                 <table id="tabbodydtc" class="table table-hover" cellspacing="0" width="100%">
                                    <thead>
                                       <tr>
										 
                                          <th>VEHICLE</th>
                                          <th id="th2">VALUE</th>
                                          <th>TIME</th>
                                          <th id="th4">LOCATION</th>
                                       </tr>
                                    </thead>
                                    
                                 </table>
                              </div>
                           </div>
                        </div>
                     </div>
                 </div>
      <!--            </div>
            </div>
         </div>
      </div>   -->
    
          <!-- Script -->
   
   
      <script type="text/javascript"> 
      
      	$(document).ready(function() { 
		if('<%=paramid%>'=='powerId' || '<%=paramid%>'=='chasisId' || '<%=paramid%>'=='bodyId' || '<%=paramid%>'=='networkId' )
		{
			$('#th2').text('ERROR CODE');
			$('#th4').text('DESCRIPTION');
		}
			
		
		
		// var url1='<%=request.getContextPath()%>/Jsps/OBD/VehicleDiagnosticDashBoard.jsp?RegNo='; 
		 $.fn.dataTable.ext.errMode = 'none';
		var table = $('#tabbodydtc').DataTable({
	 		"ajax": {
            "url": "<%=request.getContextPath()%>/OBDAction.do?param=showDataInPopUp",
            "dataSrc": "listOfContents",
            "data":{popid :'<%=paramid%>',vehiNo :'<%=vehiNo%>'},
        },     
		"columnDefs": [ {
            "searchable": true,
            "orderable": false,
            "targets": 0
        } ],
         "language": {
						 "emptyTable": "",
						 "zeroRecords": ""
					},
		"processing": true,
        "autoWidth": true,
  	    "scrollY": true,    	   		
   		"paging": false,
   		"info":     false,
		"responsive": true,		
        "columns": [ {
                "data": "registrationNo"
            }, {
                "data": "value"
            }, {
                "data": "gpsDateTime"
            }, {
                "data": "location"
            }
        ],
  //var url1='<%=request.getContextPath()%>/Jsps/OBD/VehicleDiagnosticDashBoard.jsp?RegNo='; 
 // http://localhost:8080/Telematics4uApp/Jsps/OBD/MALA741DLHM243762
	 	});
		$('#tabbodydtc').closest('.dataTables_scrollBody').css('max-height', '300px');
     	$('#tabbodydtc').DataTable().draw();
		$('#tabbodydtc').on( 'error.dt', function ( e, settings, techNote, message ) {
        console.log( 'An error has been reported by DataTables: ', message );
			} )
		.DataTable();
		

	 
	
 		//$('.dtcClick').on('click', function(event){	 
		
 		document.getElementById("backButtonId").addEventListener("click", backButton);
	 	function backButton(){
		window.location ="<%=request.getContextPath()%>/Jsps/OBD/obd_dash3.jsp";
		}
		
 });
 			
		
      </script>
      
  </body>
</html>
