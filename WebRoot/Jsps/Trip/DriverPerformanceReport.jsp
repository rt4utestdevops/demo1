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
	String customerName="-----";
if(loginInfo != null){
customerName=loginInfo.getCustomerName();
customerId = loginInfo.getCustomerId();

System.out.println("customerName: "+loginInfo.getCustomerName());
			}
else 
 {
 	response.sendRedirect(request.getContextPath()+ "/Jsps/Common/SessionDestroy.html");
 	
 }
%>
 <jsp:include page="../Common/header.jsp" />
      <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
      <link href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" rel="stylesheet">
	<link href="https://cdn.datatables.net/1.10.16/css/dataTables.bootstrap.min.css" rel="stylesheet">
	<link href="https://cdn.datatables.net/fixedcolumns/3.2.3/css/fixedColumns.dataTables.min.css" rel="stylesheet">
	<link href="https://cdn.datatables.net/select/1.2.3/css/select.dataTables.min.css" rel="stylesheet"/>
	<link href="https://cdn.datatables.net/buttons/1.5.0/css/buttons.bootstrap.min.css" rel="stylesheet"/>
	<link href="../../Main/sweetAlert/sweetalert.css" rel="stylesheet">	
      
 <link rel="stylesheet" href="https://www.jqwidgets.com/jquery-widgets-demo/jqwidgets/styles/jqx.base.css" type="text/css" />
			
			
			
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
      <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
   
	 <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
     <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
    <script src="https://cdn.datatables.net/1.10.16/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.datatables.net/1.10.16/js/dataTables.bootstrap4.min.js"></script>
    <script src="https://cdn.datatables.net/buttons/1.4.2/js/dataTables.buttons.min.js"></script>
	<script src="https://cdn.datatables.net/buttons/1.4.2/js/buttons.html5.min.js"></script>
	<script src = "https://cdn.datatables.net/select/1.2.3/js/dataTables.select.min.js"></script>
    <script src="https://cdn.datatables.net/fixedcolumns/3.2.3/js/dataTables.fixedColumns.min.js"></script>
    
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jszip/3.1.3/jszip.min.js"></script>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.32/pdfmake.min.js"></script>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.32/vfs_fonts.js"></script>
   
	<script type="text/javascript" src="https://cdn.datatables.net/buttons/1.4.2/js/buttons.bootstrap.min.js"></script>
	<script type="text/javascript" src="//cdn.datatables.net/buttons/1.4.2/js/buttons.colVis.min.js"></script>
	<script src="https://cdn.datatables.net/buttons/1.4.2/js/buttons.flash.min.js"></script>
	<script src="../../Main/sweetAlert/sweetalert.min.js"></script>

	 <script type="text/javascript" src="https://www.jqwidgets.com/jquery-widgets-demo/scripts/demos.js"></script>
    <script type="text/javascript" src="https://www.jqwidgets.com/jquery-widgets-demo/jqwidgets/jqxcore.js"></script>
    <script type="text/javascript" src="https://www.jqwidgets.com/jquery-widgets-demo/jqwidgets/jqxdatetimeinput.js"></script>
    <script type="text/javascript" src="https://www.jqwidgets.com/jquery-widgets-demo/jqwidgets/jqxcalendar.js"></script>
    <script type="text/javascript" src="https://www.jqwidgets.com/jquery-widgets-demo/jqwidgets/jqxtooltip.js"></script>
    <script type="text/javascript" src="https://www.jqwidgets.com/jquery-widgets-demo/jqwidgets/globalization/globalize.js"></script>
	
      <style>
         .custom{
         padding-left: 15px;
         padding-right: 15px;
         margin-left: auto;
         margin-right: auto;
         padding-top: 10px;
         }
         .
		 
      </style>
<!--   </head>-->
  
 <!-- <body> -->
      <div class="custom">
         <div class="panel panel-primary">
               
			   <div class="panel-heading">
                  <h3 class="panel-title" >
                     DRIVER PERFORMANCE REPORT 
                  </h3>
               </div>
			   
			   <div class="panel-body">
			   
			   <div class="panel row" style="padding:1% ;margin: 0%;"> 
			   <div class="col-lg-9 col-md-9">
			   <div class="col-xs-6 col-md-3 col-lg-3  ">
			     <select class="form-control" id="customerList" >
					<option> <%=customerName%></option>
				</select> 
               </div>
			   
				
				
				<div class="col-xs-6 col-md-3 col-lg-3 form-group">
								<div class='input-group date' id='dateInput'>
									<input type='text' placeholder="Date Range" class="form-control" />
									<span class="input-group-addon"><span class="glyphicon glyphicon-calendar"></span> </span>
								</div>
				</div>
				
				
			   <div class="col-md-3">
				<button type="button"  class="btn btn-success" onclick="getDriverPerformanceReport()">Submit</button>
			    </div>
			 
			  
			   </div>
			    
			    </div>  <!--End of header Panel-->
			    
			    <div style="overflow: auto !important;">
			   <table id="example" class="table table-striped table-bordered" cellspacing="0" width="100%" style="margin-top:1%">
					<thead>
						<tr>
							<th>SLNO</th>
						    <th>TRIP ID</th>
							<th>DRIVER NAME</th>
							<th>REGISTER NO</th>
							<th>VEHICLE MAKE</th>
							<th>FROM-TO</th>
<!--							<th>TO</th>-->
							<th>TOTAL ALERT</th>
							<th>HARSH ACCELERATION</th>
							<th>HARSH BREAKING</th>
							<th>HARSH CURVING</th>
							<th>OVERSPEED</th>
<!--							<th>ON-TIME PERFORMANCE</th>-->
							<th>TOTAL TRAVELLED(km)</th>
<!--							<th>MILEAGE</th>-->
							<th>AVG SPEED(km)</th>
							<th>MAX SPEED(km)</th>
<!--							<th>AVG. RPM</th>-->
					 </tr>
					</thead>	
							
				</table>
				</div>	<!-- end of table -->
			   
			   </div>  <!-- end of panel body -->
	  </div> <!-- end of panel  -->
	  </div> <!-- end of main div : custom -->
	  
	  <div id='jqxWidget'>
        </div>
     <script type="text/javascript">
	 
	    $(document).ready(function () {
   	 	$("#dateInput").jqxDateTimeInput({  formatString: "dd/MM/yyyy", showTimeButton: false, width: '197px', height: '25px',max: new Date(),selectionMode: 'range'});
	 <!-- $("#dateInput1").on('change', function (event) { -->
                    <!-- var selection = event.args.range; -->
					<!-- alert(selection.from.toLocaleDateString() +  "---" + selection.to.toLocaleDateString()); -->
      <!-- }); -->
	  
	         //     var date1 = new Date();
             //   date1.setFullYear(2017, 11, 18);
              //  var date2 = new Date();
              //  date2.setFullYear(2017, 11, 28);
             //   $("#dateInput").jqxDateTimeInput('setRange', date1, date2);
  	
});

function getDriverPerformanceReport(){
var dateRange=document.getElementById('dateInput').value;
var dateDiff=checkMonthValidation(dateRange);
if(dateDiff){

if ($.fn.DataTable.isDataTable('#example')) {
            $('#example').DataTable().destroy();
  }

        var table = $('#example').DataTable({
            "ajax": {
                "url": "<%=request.getContextPath()%>/tripDashBoardAction.do?param=getDriverPerformaceInfo",
                "dataSrc": "DriverPerformace",
                  "data": {
					dateRange: dateRange
					
               }
            },
            "bLengthChange": false,
             "dom": 'Bfrtip',
       		"buttons": [{extend:'pageLength'},{extend:'excel'}],
            "columns": [{
                "data": "slno"
            }, {
                "data": "tripId"
            }, {
                "data": "driverName"
            }, {
                "data": "regNo"
            }, {
                "data": "make"
            }, {
                "data": "from"
            },
<!--             {-->
<!--                "data": "to"-->
<!--            },-->
             {
                "data": "totalAlert"
            }, {
                "data": "ha"
            }, {
                "data": "hb"
            }, {
                "data": "hc"
            }, {
                "data": "overSpeed"
            },
<!--             {-->
<!--                "data": "onTimePerformance"-->
<!--            },-->
             {
                "data": "kmsTravelled"
            },
<!--             {-->
<!--                "data": "mileage"-->
<!--            },-->
             {
                "data": "avgSpeed"
            }, {
                "data": "maxSpeed"
            }]
        });
        
       }else{
       sweetAlert("Maximum you can select date range of one week ");
       
       }
		
			}
			
		function checkMonthValidation(dateRange){ 
		  var res = dateRange.split(" - ");
		   var date1=res[0].trim();
		   var date2=res[1].trim();
		   var dd=date1.split("/");
		    var ed=date2.split("/");
		var startDate = new Date(dd[1]+"/"+dd[0]+"/"+dd[2]);
		var endDate = new Date(ed[1]+"/"+ed[0]+"/"+ed[2]);
		//alert(res[0].trim());
		//alert(res[1].trim());
		var timeDiff = Math.abs(endDate.getTime() - startDate.getTime());
		var daysDiff = Math.ceil(timeDiff / (1000 * 3600 * 24));
		if(daysDiff <= 6 ){
		  	return true;
		}else{
		 	return false;
		}	
	}

 </script>
  <jsp:include page="../Common/footer.jsp" />
	<!-- </body>   -->
<!-- </html> -->
 