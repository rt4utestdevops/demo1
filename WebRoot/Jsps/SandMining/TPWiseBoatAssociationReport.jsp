<%@ page language="java"
	import="java.util.*,t4u.functions.*,t4u.beans.*,t4u.common.*"
	pageEncoding="utf-8"%>
<%@ taglib uri="http://packtag.sf.net" prefix="pack"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://"+ request.getServerName() + ":" + request.getServerPort()+ path + "/";
	if(request.getParameter("list")!=null){
	String list=request.getParameter("list").toString().trim();
	String[] str=list.split(",");
	int systemid=Integer.parseInt(str[0].trim());
	int customerid=Integer.parseInt(str[1].trim());
	int userid=Integer.parseInt(str[2].trim());
	String language=str[3].trim();
	LoginInfoBean loginInfo=new LoginInfoBean();
	loginInfo.setSystemId(systemid);
	loginInfo.setCustomerId(customerid);
	loginInfo.setUserId(userid);
	loginInfo.setLanguage(language);
	loginInfo.setZone(str[4].trim());
	loginInfo.setOffsetMinutes(Integer.parseInt(str[5].trim()));
	loginInfo.setSystemName(str[6].trim());
	loginInfo.setCategory(str[7].trim());
	loginInfo.setStyleSheetOverride("N");
	if(str.length>8){
	loginInfo.setCustomerName(str[8].trim());
	}
	if(str.length>9){
	loginInfo.setCategoryType(str[9].trim());
	}
	if(str.length>10){
	loginInfo.setUserName(str[10].trim());
	}
	session.setAttribute("loginInfoDetails",loginInfo);
}
	
	CommonFunctions cf = new CommonFunctions();
	cf.checkLoginInfo((LoginInfoBean) session.getAttribute("loginInfoDetails"), session, request, response);
	String responseaftersubmit="''";
	String feature="1";
	if(session.getAttribute("responseaftersubmit")!=null){
	   responseaftersubmit="'"+session.getAttribute("responseaftersubmit").toString()+"'";
		session.setAttribute("responseaftersubmit",null);
	}
		
    LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
	String language = loginInfo.getLanguage();
	int systemId = loginInfo.getSystemId();
	int customerId = loginInfo.getCustomerId();
    int userId=loginInfo.getUserId();
    
 %>

<jsp:include page="../Common/header.jsp" />
<title>TP Wise Boat Association Report</title>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">


<link href="../../Main/vendor/bootstrap/css/bootstrap.min.css"
	rel="stylesheet">

<link href="../../Main/vendor/metisMenu/metisMenu.min.css"
	rel="stylesheet">

<link href="../../Main/dist/css/sb-admin-2.css" rel="stylesheet">
<link href="../../Main/vendor/font-awesome/css/font-awesome.min.css"
	rel="stylesheet" type="text/css">
<link href="../../Main/sweetAlert/sweetalert.css" rel="stylesheet">
<link
	href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css"
	rel="stylesheet">
<link
	href="https://cdn.datatables.net/1.10.16/css/dataTables.bootstrap.min.css"
	rel="stylesheet">
<link
	href="https://cdn.datatables.net/fixedcolumns/3.2.3/css/fixedColumns.dataTables.min.css"
	rel="stylesheet">
<link
	href="https://cdn.datatables.net/select/1.2.3/css/select.dataTables.min.css"
	rel="stylesheet" />
<link
	href="https://cdn.datatables.net/buttons/1.5.0/css/buttons.bootstrap.min.css"
	rel="stylesheet" />

<script src="../../Main/vendor/jquery/jquery.min.js"></script>
<script src="../../Main/vendor/bootstrap/js/bootstrap.min.js"></script>

<script src="../../Main/vendor/metisMenu/metisMenu.min.js"></script>

<script src="../../Main/dist/js/sb-admin-2.js"></script>
<script src="../../Main/Js/markerclusterer.js"></script>
<script src="../../Main/sweetAlert/sweetalert.min.js"></script>
<script
	src="https://cdn.datatables.net/1.10.9/js/jquery.dataTables.min.js"></script>
<script
	src="https://cdn.datatables.net/1.10.16/js/jquery.dataTables.min.js"></script>
<script
	src="https://cdn.datatables.net/1.10.16/js/dataTables.bootstrap4.min.js"></script>
<script
	src="https://cdn.datatables.net/buttons/1.4.2/js/dataTables.buttons.min.js"></script>
<script
	src="https://cdnjs.cloudflare.com/ajax/libs/jszip/3.1.3/jszip.min.js"></script>
<script
	src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.32/pdfmake.min.js"></script>
<script
	src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.32/vfs_fonts.js"></script>
<script
	src="https://cdn.datatables.net/buttons/1.4.2/js/buttons.html5.min.js"></script>
<script
	src="https://cdn.datatables.net/select/1.2.3/js/dataTables.select.min.js"></script>
<script
	src="https://cdn.datatables.net/fixedcolumns/3.2.3/js/dataTables.fixedColumns.min.js"></script>

<script type="text/javascript"
	src="https://cdn.datatables.net/buttons/1.4.2/js/buttons.bootstrap.min.js"></script>
<script type="text/javascript"
	src="//cdn.datatables.net/buttons/1.4.2/js/buttons.colVis.min.js"></script>
<script
	src="https://cdn.datatables.net/buttons/1.4.2/js/buttons.flash.min.js"></script>



<script src="https://www.jqwidgets.com/public/jqwidgets/jqx-all.js"></script>
<script
	src="https://www.jqwidgets.com/public/jqwidgets/globalization/globalize.js"></script>
<link rel="stylesheet"
	href="https://www.jqwidgets.com/public/jqwidgets/styles/jqx.base.css">
<link rel="stylesheet"
	href="https://www.jqwidgets.com/public/jqwidgets/styles/jqx.energyblue.css">
<link rel="stylesheet"
	href="https://www.jqwidgets.com/public/jqwidgets/styles/jqx.arctic.css">


<script
	src="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.1/js/select2.min.js"></script>
<link
	href="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.1/css/select2.min.css"
	rel="stylesheet" />



<style>
.modal-body {
	position: relative;
	overflow-y: hidden;
	max-height: 500px;
	padding: 15px;
}

.input-group[class *=col-] {
	float: left !important;
	padding-right: 0px;
	margin-left: -54px !important;
}

.comboClass {
	width: 200px;
	height: 25px;
}

#emptyColumn {
	width: 20px;
}
#example_wrapper {
	margin-top : -48px !important;
}
</style>




<nav class="navbar navbar-default" style="background-color: #5f9ea0;">
<div class="container-fluid">
	<div class="navbar-header">
		<a class="navbar-brand" href="#" style="color: white;">TP Wise Boat Association Report</a>
	</div>
</div>
</nav>


<div class="panel panel-default">
	<div class="panel-heading"
		style="background-color: #5f9ea0; font-weight: bold; vertical-align: middle; position: relative;">
	</div>
	<div class="panel-body" style="overflow-y: auto; height: 80%;">
		<br>
		<br />
		<table id="example" class="table table-striped table-bordered"
			cellspacing="0" width="100%">
			<thead>
				<tr>
					<th>
						Sl No
					</th>
					<th>
						Vehicle Number
					</th>
					<th>
					    Permit Number
					</th>
					<th>
						Loading Hub
					</th>
				</tr>
			</thead>
		</table>
	</div>
</div>



<script>
    var table;
	window.onload = function () { 
		getData();
	}
    //############# function to get grid data ###################
  function getData(){
    if ($.fn.DataTable.isDataTable('#example')) {
            $('#example').DataTable().destroy();
        }
     
     table = $('#example').DataTable({
         "ajax": {
             "url": '<%=request.getContextPath()%>/SandExcavationReportAction.do?param=getTPWiseBoatAssociationDetails',
             "data": {
             },
             "dataSrc": "tpWiseBoatAssocReportDetails"
         },
          "bDestroy": true,
		        "oLanguage": {
       	 				"sEmptyTable": "No data available"
    				},
         "bLengthChange": false,
         "dom": 'Bfrtip',
        	 	"buttons": [{extend:'pageLength'},
        	 				{extend:'excel',
        	 				 exportOptions: {
				               columns: [0,1,2,3]
				             }
				            }
        	 				],
          "columns": [{
             "data": "slnoIndex"
         },{
             "data": "regNoIndex"
         }, {
             "data": "permitNoIndex"
         },{
         	"data":  "loadingHubIndex"
         }]
     });
    }
    
    </script>
<jsp:include page="../Common/footer.jsp" />
