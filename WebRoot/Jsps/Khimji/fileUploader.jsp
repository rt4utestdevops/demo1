<%@ page language="java" import="java.util.*" pageEncoding="ISO-8859-1"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<!DOCTYPE html>
<html lang="en">
<head>
  <title>Bootstrap Example</title>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.datatables.net/1.10.16/css/dataTables.bootstrap.min.css">
    <link rel="stylesheet" href="http://ajax.googleapis.com/ajax/libs/jqueryui/1.11.1/themes/ui-darkness/jquery-ui.min.css" rel="stylesheet">

    <script src="https://code.jquery.com/jquery-1.12.4.js"></script>
    <script src="https://cdn.datatables.net/1.10.16/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.datatables.net/1.10.16/js/dataTables.bootstrap.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
    
  
   
</head>
<body>
  <br>
<div class="container">

<form class="form-inline" action="<%=request.getContextPath()%>/FileUploadServlet" enctype="multipart/form-data" method="post">
	<div class="form-group" > 
		Select file<input class="form-group" type="file" name="dataFile" id="fileChooser">
		<input type="submit" value="Upload" name="Upload">
	</div>
</form> 
<button style="margin-left: 100px;" onclick="tabulateExcel()">Tabulate Excel </button>


</div>


<div class="panel-body">
                   
                    <table id="example" class="table table-striped table-bordered" cellspacing="0" width="100%">
                        <thead>
                            <tr>
                                <th>SLNO</th>
                                <th>CUSTOMER NAME</th>
                                <th>PRIORITY</th>
                                <th>ORDER NO</th>
                                <th>ORDER DATE</th>
                                <th>ORDER VALUE </th>
                                <th>DELIVERY DATE</th>
                                <th>TOTAL WEIGHT</th>
                                <th>UNIQUE ID</th>
                            </tr>
                        </thead>
                    </table>
                </div>

<script type="text/javascript">
function tabulateExcel()
{

	
     // getVechileFuelSummary("TS10XTR7437");
     var table = $('#example').DataTable({
         "processing": true,
         //  "serverSide": true,
         "ajax": {
             "url": "<%=request.getContextPath()%>/khimjiTripCreationAction.do?param=getOrderValues",
            
             "dataSrc": "ExcelValueRoot"
         },
         "bLengthChange": false,
         "columns": [{
             "data": "slno"
         }, {
             "data": "customerName"
         }, {
             "data": "priority"
         }, {
             "data": "orderNumber"
         },{
             "data": "orderDate"
         },{
             "data": "orderValue"
         },{
             "data": "deliveryDate"
         },{
             "data": "totalWeight"
         },{
             "data": "uniqueCode"
         }]
     });
	$('#example tbody').on('click', 'td', function() {
		var data = table.row( this ).data();
		var uniqueId = data['uniqueCode'];
		window.location.href = "<%=request.getContextPath()%>/Jsps/Trip/KhimjiTripCreation.jsp?uniqueId="+uniqueId+"";
	});
}
</script>
</body>
</html>
