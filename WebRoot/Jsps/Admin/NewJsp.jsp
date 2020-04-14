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

<html>

<head>
    <title>Bootstrap Tree View</title>
    <link href="../../assets/bootstrap-treeview.css" rel="stylesheet">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
    <link href='../../assets/bootstrap-treeview.min.css' rel='stylesheet' type='text/css'>
    
    <!-- Bootstrap core CSS     -->
    <link href="../../assets/css/bootstrap.min.css" rel="stylesheet" />

    <!--  Material Dashboard CSS    -->
    <link href="../../assets/css/material-dashboard.css" rel="stylesheet"/>

    <!--  CSS for Demo Purpose, don't include it in your project     -->
    <link href="../../assets/css/demo.css" rel="stylesheet" />

    <!--     Fonts and icons     -->
    <link href="https://maxcdn.bootstrapcdn.com/font-awesome/latest/css/font-awesome.min.css" rel="stylesheet">
    <link href='https://fonts.googleapis.com/css?family=Roboto:400,700,300|Material+Icons' rel='stylesheet' type='text/css'>
	<link href='https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/4.0.0-beta/css/bootstrap.css' rel='stylesheet' type='text/css'>
    <link href="../../assets/bootstrap-combobox.css" rel="stylesheet" type="text/css">
    
	<style>
		.form-control {
			width: 142%;
		}
		.card{
		 	height: 500px;
		}
		.form-group .checkbox label, .form-group .radio label, .form-group label {
		    font-size: 14px;
		    line-height: 2.42857;
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
		.form-group .checkbox label, .form-group .radio label, .form-group label{
			 color: black;
		}
		.form-control {
		    display: block;
		    width: 100%;
		    padding: 0.5rem 0.75rem;
		    font-size: 14px;
		    line-height: 1.25;
		    color: #495057;
		    background-color: #fff;
		    background-image: none;
		    background-clip: padding-box;
		    border: 1px solid rgba(0, 0, 0, 0.15);
		    border-radius: 0.25rem;
		    transition: border-color ease-in-out 0.15s, box-shadow ease-in-out 0.15s;
		}
	</style>

</head>

<body style="overflow: hidden !important">
    <div class="container">
        <div class="row">
          <div class="col-md-12">
            <div class="card" >
               <div class="card-header" data-background-color="#bdb6b6">
                    <h4 class="title">User Profile</h4>
                </div>
                <div class="form-group">
                    <div class="col-sm-6">
                        <div class="card-content">
                            <div class="col-sm-6">
                                <select class="combobox input-large form-control" id="user_names">
				                 	<option value="" selected="selected">Select a User</option>
				      			</select>
				      			<label>User Name : </label> <label id="userName"></label> </br>
				      			<label>Email : </label> <label id="email"></label> </br>
				      			<label>Mobile No : </label> <label id="phone"></label></br>
				      			<label>Role : </label><label id="role"></label></br>
				      			<label>Created By : </label><label id="createdBy"></label></br>
<!--				      			<label>Created DateTime:</label> <label id="createDate"></label></br>-->
                            </div>
                        </div>
                    </div>
                    <div class="col-sm-6" style="width: 568px; height: 427px; overflow: scroll; overflow-x:hidden;" >
                        <h5>User Group Details</h5>
                        <div id="treeview-expandible" class=""></div>
                    </div>
                </div>
            </div>
        </div>
      </div>
   </div>
    <script src="../../Main/Js/jquery.js"></script>
    <script src="../../assets/bootstrap-treeview.min.js"></script>
    <script src="../../assets/bootstrap-treeview.js"></script>
    <script src="../../assets/bootstrap-combobox.js"></script>
    <script type="text/javascript">
        var data = [];
        var $expandibleTree;
        var $GroupexpandibleTree;
        var userId;
        function getUserNames() {
               $.ajax({
                   url: '<%=request.getContextPath()%>/CustomerAction.do?param=getUsers',
                   success: function(response) {
                       userList = JSON.parse(response);
                       var $userName = $('#user_names');
                       var output = '';
                       $.each(userList, function(index, el) {
                           output += '<option value="'+el.userId+'">'+el.userName+'</option>'
                       });
                       $('#user_names').append(output);
                       $('.combobox').combobox()
                       $('#user_names').change(function() {
						    userId = $('option:selected').attr('value');  
							getGroupNames(userId);
							getUserDetails(userId);
					   });
                   }
               });
           }
           function getUserNames1() {
               $.ajax({
                   url: '<%=request.getContextPath()%>/CustomerAction.do?param=getUsers1',
                   success: function(response) {
                       userList = JSON.parse(response);
                       var $userName = $('#user_names');
                       var output = '';
                       $.each(userList, function(index, el) {
                           output += '<option value="'+el.userId+'">'+el.userName+'</option>'
                       });
                       $('#user_names').append(output);
                       $('.combobox').combobox()
                       $('#user_names').change(function() {
						    userId = $('option:selected').attr('value');  
							getGroupNames(userId);
							getUserDetails(userId);
					   });
                   }
               });
           }
           function getGroupNames(userId){
           	 $.ajax({
                url: '<%=request.getContextPath()%>/CustomerAction.do?param=getGroupsForTreeView',
                data:{
                	userId:userId
                },
                success: function(response) {
                    data = JSON.parse(response);
                    $expandibleTree = $('#treeview-expandible').treeview({
                        data: data,
                        levels: 2,
                        expandIcon: 'glyphicon glyphicon-plus',
                        collapseIcon: 'glyphicon glyphicon-minus',
                        emptyIcon: 'glyphicon',
                        nodeIcon: '',
                        selectedIcon: '',
                        checkedIcon: 'glyphicon glyphicon-check',
                        uncheckedIcon: 'glyphicon glyphicon-unchecked',
                        color:  '#000000',
                        backColor:  '#FFFFFF',
                        borderColor: '#dddddd',
                        onhoverColor: '#F5F5F5',
                        selectedColor: '#FFFFFF',
                        selectedBackColor: '#428bca',
                        searchResultColor: '#D9534F',
                        searchResultBackColor: '#FFFFFF',
                        enableLinks: false,
                        highlightSelected: true,
                        highlightSearchResults: true,
                        showBorder: true,
                        showIcon: true,
                        //showCheckbox: true,
                        showTags: false,
                        multiSelect: false,
                        onNodeCollapsed: function(event, node) {
                        },
                        onNodeExpanded: function(event, node) {
                            $('#expandible-output').prepend('<p>' + node.text + ' was expanded</p>');
                        }
                    });
                }
            });
           }
           function getUserDetails(){
           		$.ajax({
                    url: '<%=request.getContextPath()%>/CustomerAction.do?param=getUserDetails',
                    data: {
                    	userId:userId
                    },
                    success: function(response) {
                        userD = JSON.parse(response);

                        document.getElementById('userName').innerHTML = userD["DBoardRoot"][0].userNameId;
                        document.getElementById('phone').innerHTML = userD["DBoardRoot"][0].phoneId;
                        document.getElementById('email').innerHTML = userD["DBoardRoot"][0].emailId;
                        document.getElementById('role').innerHTML = userD["DBoardRoot"][0].userAuthId;
                        //document.getElementById('createDate').innerHTML = userD["DBoardRoot"][0].createdTimeId;
                        document.getElementById('createdBy').innerHTML = userD["DBoardRoot"][0].createdById;
                    }
                });
           }
        $(function() {
        	<%if((isLtsp==false && userAuthority.equalsIgnoreCase("Admin"))){%>  
			  	  getUserNames();
			<%}else{%>
				 getUserNames1();
			<%}%>

            $('#btn-expand-node.expand-node').on('click', function(e) {
                var levels = $('#select-expand-node-levels').val();
                $expandibleTree.treeview('expandNode', [expandibleNodes, {
                    levels: levels,
                    silent: $('#chk-expand-silent').is(':checked')
                }]);
            });

            $('#btn-collapse-node.expand-node').on('click', function(e) {
                $expandibleTree.treeview('collapseNode', [expandibleNodes, {
                    silent: $('#chk-expand-silent').is(':checked')
                }]);
            });

            $('#btn-toggle-expanded.expand-node').on('click', function(e) {
                $expandibleTree.treeview('toggleNodeExpanded', [expandibleNodes, {
                    silent: $('#chk-expand-silent').is(':checked')
                }]);
            });

            // Expand/collapse all
            $('#btn-expand-all').on('click', function(e) {
                var levels = $('#select-expand-all-levels').val();
                $expandibleTree.treeview('expandAll', {
                    levels: levels,
                    silent: $('#chk-expand-silent').is(':checked')
                });
            });

            $('#btn-collapse-all').on('click', function(e) {
                $expandibleTree.treeview('collapseAll', {
                    silent: $('#chk-expand-silent').is(':checked')
                });
            });

        });
    </script>
</body>

</html>