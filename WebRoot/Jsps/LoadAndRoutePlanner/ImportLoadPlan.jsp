<%@ page language="java" import="java.util.*" pageEncoding="ISO-8859-1"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";

String downloadPath="C:/loadPlanner";
%>

<!DOCTYPE html>
<html lang="en">
<head>
  <title>Load Optimizer</title>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.datatables.net/1.10.16/css/dataTables.bootstrap.min.css">
    <link rel="stylesheet" href="http://ajax.googleapis.com/ajax/libs/jqueryui/1.11.1/themes/ui-darkness/jquery-ui.min.css" rel="stylesheet">
    <link rel="stylesheet" href="../../Main/sweetAlert/sweetalert.css">
    
    <script src="https://code.jquery.com/jquery-1.12.4.js"></script>
    <script src="https://cdn.datatables.net/1.10.16/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.datatables.net/1.10.16/js/dataTables.bootstrap.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
    <script src="../../Main/sweetAlert/sweetalert.min.js"></script>
   
</head>
<body>
<nav class="navbar navbar-inverse">
  <div class="container-fluid">
    <div class="navbar-header">
      <a class="navbar-brand" href="#" style="color: red;">Load Optimizer</a>
    </div>
<!--    <ul class="nav navbar-nav" >-->
<!--      <li class="active"><a href="#">Load Import</a></li>-->
<!--      <li><a href="<%=path %>/Jsps/LoadAndRoutePlanner/LoadOptimizerTrip.jsp">Create Trip</a></li>-->
<!--    </ul>-->
  </div>
</nav>

  <div class="">
  <div class="panel panel-primary">
   <div class="panel-heading">
   	  <h6>${requestScope.message}</h6>
		<div class="row">
			  <div class="col-lg-7">
		
			  <form class="form-inline" action="<%=request.getContextPath()%>/FileUploadServlet" enctype="multipart/form-data" method="post">
					&nbsp; <b>Select file </b>&nbsp;<input class="form-control" type="file" name="dataFile" id="fileChooser">
					<input class="btn btn-warning" type="submit" onclick="return validate()" value="Upload" name="Upload"> 
					 &nbsp; <a href="<%=request.getContextPath()%>/FileUploadServlet" style="color: white;" download> Download Standard Excel Format</a>
				</form> 
			  </div>
			  <div class="col-lg-5">
				<button class="btn btn-warning" onclick="tabulateExcel()">Tabulate Excel </button>
				<button class="btn btn-warning" id="optimiseId" onclick="getUniqueCode()">Optimizer </button>
			  </div>
			</div>
		</div>
	</div>
	<div class="panel-body">
                   
                    <table id="example" class="table table-striped table-bordered" cellspacing="0" width="100%">
                        <thead>
                            <tr>
                                <th>SLNO</th>
                                <th>PRIORITY</th>
                                <th>CUSTOMER NO</th>
                                <th>CUSTOMER NAME</th>
                                <th>DELIVERY DATE</th>
                                <th>DELIVERY TIME</th>
								<th>ORDER NUMBER</th>
								<th>ORDRE DATE</th>
								<th>ORDER VALUE</th>
                                <th>TOTAL WEIGHT in KG</th>
                                <th>UNIQUE ID</th>
                            </tr>
                        </thead>
                    </table>
 </div>

      <div id="page-loader" style="margin-left:500px;margin-top:200px;display:none;">
				<img src="../../Main/images/loading.gif" alt="loader" />
		</div>
</div>

<script type="text/javascript">
function validate()
{
	var a=document.getElementById('fileChooser').value;
	if(a==""){
		sweetAlert("Please select the File ");
		return false;
	}
		if(a.split('.').pop()=='xlsx'||a.split('.').pop()=='xls')
		{
			return true;
		}
		else
		{
			sweetAlert("Please select .xlsx type of File");
		 	return false;
		}
	return true;
}

</script>
<script type="text/javascript">
var uniqueCode=null;

function tabulateExcel()
{
 document.getElementById("page-loader").style.display="block";

	if ($.fn.DataTable.isDataTable('#example')) {
           $('#example').DataTable().destroy();
       }
	
     // getVechileFuelSummary("TS10XTR7437");
     var table = $('#example').DataTable({
         "processing": true,
         //retrieve: true,
         //  "serverSide": true,
         "ajax": {
             "url": "<%=request.getContextPath()%>/khimjiTripCreationAction.do?param=getOrderValues",
            
             "dataSrc": "ExcelValueRoot"
         },
         "bLengthChange": false,
         "columns": [{
             "data": "slno"
         }, {
             "data": "priority"
         }, {
             "data": "customerNo"
         }, {
             "data": "customerName"
         },{
             "data": "deliveryDate"
         },{
             "data": "deliveryTime"
         },{
             "data": "orderNumber"
         },{
             "data": "orderDate"
         },{
             "data": "orderValue"
         },{
             "data": "totalWeight"
         },{
             "data": "uniqueCode"
	    	}]
     });

	//  table.column(4).visible( false );
	//  table.column(12).visible( false );
	 
	 $('#example').on( 'init.dt',function () {
			     var data = table.row(0).data();
	             uniqueCode = data['uniqueCode'];
	             console.log(uniqueCode);
	          
			} );
 document.getElementById("page-loader").style.display="none";
	
}


function getUniqueCode()
{
 document.getElementById("page-loader").style.display="block";
 $( "#optimiseId" ).prop( "disabled", true );
    if(uniqueCode!=null && uniqueCode!="" && uniqueCode!='undefined'){
     document.getElementById("page-loader").style.display="block";
	           	$.ajax({
				url: "<%=request.getContextPath()%>/khimjiTripCreationAction.do?param=optimseOrderData", 
			    "data":{
			   		uniqueId: uniqueCode
			    },
			    success: function(result){
			     document.getElementById("page-loader").style.display="none";
			     $( "#optimiseId" ).prop( "disabled", false );
			    	if(result.trim() === "Success"){
			    		//sweetAlert("Trip created successfully");
			    		window.location.href = "<%=request.getContextPath()%>/Jsps/LoadAndRoutePlanner/LoadOptimizerTrip.jsp?uniqueId="+uniqueCode+"";
			    	}else{
			    		alert(result);
			    		$( "#optimiseId" ).prop( "disabled", false );
			    	}
			    }
			});
	           
	           //window.location.href = "<%=request.getContextPath()%>/Jsps/LoadAndRoutePlanner/LoadOptimizerTrip.jsp?uniqueId="+uniqueCode+"";

	           }else{
	           
	            document.getElementById("page-loader").style.display="none";
	            $( "#optimiseId" ).prop( "disabled", false );
	              alert("Please load the orders to Optimize")
	              
	           }
}
//localStorage.removeItem("uniqueCode");
</script>
</body>
</html>
