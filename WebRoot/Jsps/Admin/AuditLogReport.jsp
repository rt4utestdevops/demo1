<%@ page language="java" import="java.util.*,java.text.SimpleDateFormat,t4u.functions.*,t4u.beans.*,t4u.common.*"
	pageEncoding="utf-8"%>
<%@ taglib uri="http://packtag.sf.net" prefix="pack"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://"
			+ request.getServerName() + ":" + request.getServerPort()
			+ path + "/";
			int systemid=0;
			int userid=0;
if (request.getParameter("list") != null) {
		String list = request.getParameter("list").toString().trim();
		String[] str = list.split(",");
		systemid = Integer.parseInt(str[0].trim());
		int customerid = Integer.parseInt(str[1].trim());
		userid = Integer.parseInt(str[2].trim());
		String language = str[3].trim();
		LoginInfoBean loginInfo = new LoginInfoBean();
		LoginInfoBean loginInfo1=new LoginInfoBean();
		loginInfo1=(LoginInfoBean)session.getAttribute("loginInfoDetails");
		if(loginInfo1!=null)
		{
		int isLtsp=loginInfo1.getIsLtsp();
		loginInfo.setIsLtsp(isLtsp);
		}
		loginInfo.setSystemId(systemid);
		loginInfo.setCustomerId(customerid);
		loginInfo.setUserId(userid);
		loginInfo.setLanguage(language);
		loginInfo.setStyleSheetOverride("N");
		loginInfo.setZone(str[4].trim());
		loginInfo.setOffsetMinutes(Integer.parseInt(str[5].trim()));
		loginInfo.setSystemName(str[6].trim());
		loginInfo.setCategory(str[7].trim());
		if (str.length > 8) {
			loginInfo.setCustomerName(str[8].trim());
		}
		if (str.length > 9) {
			loginInfo.setCategoryType(str[9].trim());
		}
		if (str.length > 10) {
			loginInfo.setUserName(str[10].trim());
		}
		if (str.length > 11) {
			loginInfo.setStyleSheetOverride("N");
		}
		if(str.length>12){
			loginInfo.setCountryCode(Integer.parseInt(str[11].trim()));
		}
		session.setAttribute("loginInfoDetails", loginInfo);
	}
	CommonFunctions cf=new CommonFunctions();
	LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
	cf.checkLoginInfo((LoginInfoBean) session.getAttribute("loginInfoDetails"), session, request, response);
	session.setAttribute("loginInfoDetails", loginInfo);
	String language = loginInfo.getLanguage();
	boolean isLtsp=loginInfo.getIsLtsp()==0;
	systemid = loginInfo.getSystemId();
	userid = loginInfo.getUserId();
	String userAuthority=cf.getUserAuthority(systemid,userid);
	System.out.println((isLtsp==true && userAuthority.equalsIgnoreCase("Admin")));
	if(isLtsp==true){
		response.sendRedirect(request.getContextPath()
				+ "/Jsps/Common/401Error.html");
	}	
%>

<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="">
    <meta name="author" content="">
    <meta http-equiv="refresh" content="3000" />

    <title>Audit Log Report</title>

    <meta content='width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0' name='viewport' />
    <meta name="viewport" content="width=device-width" />

    <!-- Bootstrap core CSS     -->
    <link href="../../assets/css/bootstrap.min.css" rel="stylesheet" />

    <!--  Material Dashboard CSS    -->
    <link href="../../assets/css/material-dashboard.css" rel="stylesheet"/>

    <!--  CSS for Demo Purpose, don't include it in your project     -->
    <link href="../../assets/css/demo.css" rel="stylesheet" />

    <!--     Fonts and icons     -->
    <link href="https://maxcdn.bootstrapcdn.com/font-awesome/latest/css/font-awesome.min.css" rel="stylesheet">
    <link href='https://fonts.googleapis.com/css?family=Roboto:400,700,300|Material+Icons' rel='stylesheet' type='text/css'>
    <link href='https://cdn.datatables.net/1.10.16/css/dataTables.bootstrap4.min.css' rel='stylesheet' type='text/css'>
    <link href='https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/4.0.0-beta/css/bootstrap.css' rel='stylesheet' type='text/css'>
    <link href="../../assets/bootstrap-combobox.css" rel="stylesheet" type="text/css">
    <!-- jQuery CDN -->
     <script src="../../Main/Js/jquery.js"></script>
	 <script src="https://cdn.datatables.net/1.10.9/js/jquery.dataTables.min.js"></script>
     <script src="https://cdn.datatables.net/1.10.16/js/dataTables.bootstrap4.min.js"></script>
     
     <script src="../../assets/bootstrap-table.js"></script>
      <script src="../../assets/bootstrap-combobox.js"></script>
      
  <!--     changed     -->
   
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.datatables.net/1.10.16/css/dataTables.bootstrap.min.css">
    <link rel="stylesheet" href="https://ajax.googleapis.com/ajax/libs/jqueryui/1.11.1/themes/ui-darkness/jquery-ui.min.css" rel="stylesheet">

	<script src="https://cdn.datatables.net/buttons/1.4.2/js/dataTables.buttons.min.js"></script>
	<script type="text/javascript" src="https://cdn.datatables.net/buttons/1.4.2/js/buttons.bootstrap.min.js"></script>
	<script type="text/javascript" src="//cdn.datatables.net/buttons/1.4.2/js/buttons.colVis.min.js"></script>
	<script src="https://cdn.datatables.net/buttons/1.4.2/js/buttons.flash.min.js"></script>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/jszip/3.1.3/jszip.min.js"></script>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.32/pdfmake.min.js"></script>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.32/vfs_fonts.js"></script>
	<script src="https://cdn.datatables.net/buttons/1.4.2/js/buttons.html5.min.js"></script>
	<script src="https://cdn.datatables.net/buttons/1.4.2/js/buttons.print.min.js"></script>
	
      
</head>
<style>
.table-wrapper {
    display: block;
    max-height: 400px;
    overflow-y: auto;
    -ms-overflow-style: -ms-autohiding-scrollbar;
}
 body {
  margin: 0;
  font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif;
  font-size: 13px;
  font-weight: normal;
  line-height: 1.5;
  color: #212529;
}
.form-control{
	font-size: 13px;
	border: 1px solid rgba(0, 0, 0, 0.15) !important;
}

.input-group-addon{
font-size: 26px;
}
.input-group-addon {
    padding: .5rem .75rem;
    margin-bottom: 0;
    font-size: 1rem;
    font-weight: 400;
    line-height: 1.25;
    color: #464a4c;
    text-align: center;
    background-color: #eceeef !important;
    border: 1px solid rgba(0,0,0,.15)!important;
    border-radius: .25rem;
}
label {
    font-size: 14px;
    line-height: 1.42857;
    color: black;
    font-weight: 400;
}
select.form-control-sm:not([size]):not([multiple]), .input-group-sm > select.form-control:not([size]):not([multiple]), .input-group-sm > select.input-group-addon:not([size]):not([multiple]), .input-group-sm > .input-group-btn > select.btn:not([size]):not([multiple]) {
    height: 29px;
    border: 1px solid rgba(0, 0, 0, 0.15) !important;
    border-radius: 5px !important;
}
.card .card-content {
    padding: 15px 20px;
    background-color: whitesmoke;
}
.typeahead-long {
	overflow-x: hidden !important;
}
</style>
<body style="overflow: hidden !important">
<div class="main-content">
<div class="container-fluid">

    <div class="row">
        <div class="col-md-12">
            <div class="card">
               <div class="card-header" style="background-color : gray !important ">
				    <div class="row" style="padding-top: 17px;margin-left: 10px;">
				        <div class="col-lg-3 col-md-12">
				            <select class="combobox input-large form-control" id="user_names">
				                 <option value="" selected="selected">Select a User</option>
				            </select>
				        </div>
				        <div class="col-lg-6 col-md-12"><h2 align="center">User Audit Report</h2></div>
				        <div class="col-lg-3 col-md-6">
				         <select name="MyName" class="combobox input-large form-control" id="timeband">
				                <option value="1" selected="selected">1 Day</span></option>
				                <option value="2">1 Week</span></option>
				                <option value="3">15 Days</span></option>
				                <option value="4">1 Month</span></option>
				            </select>
				        </div>
				    </div>
               </div>
                <div class="card-content">
					<div class="table-wrapper">
			          <table id="example" class="table table-striped table-bordered" cellspacing="0" width="100%">
					        <thead>
					            <tr style="background-color: gray; font-size: larger; color: white;">
					                <th>Sl No</th>
					                <th>User Name</th>
					                <th>Page Name</th>
					                <th>Action</th>
					                <th>Remarks</th>
					                <th>Date Time</th>
					                <th>Req Time</th> <!-- t4u506 -->
					                <th>Res Time</th>  <!-- t4u506 -->
					            </tr>
					        </thead>
					  </table>   
			        </div>
                </div>
            </div>
        </div>
    </div>
</div>
</div>

   
<script>
var userId;
var table;
var timeBand=1;
$(function() {
<%if((isLtsp==false && userAuthority.equalsIgnoreCase("Admin"))){%>  
  	  getUserNames();
<%}else{%>
	 getUserNames1();
<%}%>
});
$('#timeband').change(function() {
    //timeBand = $('option:selected').attr('value');  
    timeBand = $('#timeband option:selected').val();
    if(userId==""){
    	alert("Please Select User");
    }
    getAuditLogReport(userId,timeBand);
});
$('#user_names').change(function() { 
    userId = $('option:selected').attr('value');  
	getAuditLogReport(userId,timeBand);
});
function getAuditLogReport(userId,timeBand){
		if(userId=="ALL" || userId>0){
		 table = $('#example').DataTable({
	      	"ajax": {
	        	"url": "<%=request.getContextPath()%>/CustomerAction.do?param=getAuditLogReport",
	            "dataSrc": "auditReport",
	            "processData": true,
	            "data":{
	            	userId: userId,
	            	timeBand: timeBand
	            }
	        },
	        dom: 'Bfrtip',
        	buttons: [ 'excel', 'pdf'],
            "oLanguage": {
                "sEmptyTable": "No data available"
            },
            "buttons": [{extend:'pageLength'},
	      	 				{extend:'excel',
	      	 				title: 'User Audit Report',
	      	 				},{extend:'pdf',
	      	 				title: 'User Audit Report',
	      	 				},
	      	 ],
	        height:200,
	        "bDestroy": true,
	        //"scrollY": '50vh',
       		//"scrollCollapse": true,
       		//t4u506 added req ans res time ID's
	        "columns": [{
	        		"data": "id"
	        	}, {
	                "data": "userNameId"
	            }, {
	                "data": "pageNameId"
	            }, {
	                "data": "actionId"
	            }, {
	                "data": "remarksId"
	            }, {
	                "data": "dateTimeId"
	            },  {
	                "data": "reqTimeId"
	            }, {
	                "data": "resTimeId"
	            }]
	    });
	    
	    //t4u506 added 2 ID's above
	   // $('#example').closest('.dataTables_scrollBody').css('max-height', '160px');
	    }
}
		         

         function getUserNames() {
                        $.ajax({
                            url: '<%=request.getContextPath()%>/CustomerAction.do?param=getUsers',
                            success: function(response) {
                                userList = JSON.parse(response);
                                var $userName = $('#user_names');
                                var output = '';
                                <%if(userAuthority.equalsIgnoreCase("Admin")){%>    
									 output += '<option value="ALL">ALL</option>'
 								<%}%>
                                $.each(userList, function(index, el) {
                                    output += '<option value="'+el.userId+'">'+el.userName+'</option>'
                                });
                                $('#user_names').append(output);
                                $('.combobox').combobox()
                            }
                        });
                       
                    }
                    function getUserNames1() {
                        $.ajax({
                            url: '<%=request.getContextPath()%>/CustomerAction.do?param=getUsers1',
                            data: {
                            	userIdAuth: '<%=userid%>'
                            },
                            success: function(response) {
                                userList = JSON.parse(response);
                                var $userName = $('#user_names');
                                var output = '';
                                <%if(userAuthority.equalsIgnoreCase("Admin"))
								{%>    
									 output += '<option value="ALL">ALL</option>'
 								<%}%>
                                $.each(userList, function(index, el) {
                                    output += '<option value="'+el.userId+'">'+el.userName+'</option>'
                                });
                                $('#user_names').append(output);
                                $('.combobox').combobox()
                            }
                        });
                       
                    }
</script>
</body>

</html>
