<%@ page language="java" import="java.util.*,t4u.functions.*,t4u.beans.*,t4u.common.*" pageEncoding="ISO-8859-1"%>
<%@ taglib uri="http://packtag.sf.net" prefix="pack" %>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
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
if(session.getAttribute("responseaftersubmit")!=null){
   	responseaftersubmit="'"+session.getAttribute("responseaftersubmit").toString()+"'";
	session.setAttribute("responseaftersubmit",null);
}		
LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
String language = loginInfo.getLanguage();
int systemId = loginInfo.getSystemId();
int customerId = loginInfo.getCustomerId();
int userId = loginInfo.getUserId();
String userAuthority = cf.getUserAuthority(systemId,userId);
String custId="";
String custName="";
String load = "";
if(request.getParameter("custId") != null && !request.getParameter("custId").equals("") && request.getParameter("custName") != null && !request.getParameter("custName").equals("")){
	custId = request.getParameter("custId");
	custName = request.getParameter("custName");
	load = request.getParameter("load");
}
%>

<!DOCTYPE HTML>
<html>
  <head>
    <title>MonthlyReturnsDashboard</title>
    
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	<pack:style src="../../Main/resources/css/ext-all.css" />
	<pack:script src="../../Main/adapter/ext/ext-base.js"></pack:script>
	<pack:script src="../../Main/Js/ext-all-debug.js"></pack:script>
	<link rel="stylesheet" href="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/css/bootstrap.min.css">
  	<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script>
  	<script src="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/js/bootstrap.min.js"></script>
  	<pack:script src="../../Main/Js/examples1.js"></pack:script>
	<pack:style src="../../Main/resources/css/examples1.css" />
	<style>
	body {
	  font-family: 'Open Sans', sans-serif !important;
	  font-size: 25px;
	  line-height: 1.42857143;
	  color: #333;
	  background-color: #fff;
	  background-image: url(/ApplicationImages/DashBoard/DashBoardBackground.png) !important;
	}
	.pull-left {
	  float: left!important;
	  font-family: 'Open Sans', sans-serif !important;
	  font-size: 12px;
	  color: #337ab7;
	}
	.panel-body{
		display: block;
	    font-size: 24px;
	    color: #5eb9f9;
	    padding: 2px 2px;
	    font-family: 'Lato', Calibri, Arial, sans-serif;
	}
	.container {
	  width: 100%;
	  margin-top:3%;
	  background-color: #COCOCO;
	}
	.huge{
		  text-align: center;
		  font-family: Open Sans, Light;
	      font-size: 33px;
	}
	.huge_text{
		text-align: center;
		font-family: Open Sans, Light;
	    font-size: 22px;
	}
	.col-xs-9 {
	  width: 97%;
	}
	.panel-green{
		border-color: #8cc22e;
	}
	.panel-green > .panel-heading {
	  border-color: #8cc22e;
	  color: #fff;
	  background-color: #8cc22e;
	}
	.panel-blue {
	  border-color: #12a7cc;
	}
	.panel-blue > .panel-heading {
	  border-color: #12a7cc;
	  color: #fff;
	  background-color: #12a7cc;
	}
	.panel-black {
	  border-color: #646464;
	}
	.panel-black > .panel-heading {
	  border-color: #646464;
	  color: #fff;
	  background-color: #646464;
	}
	.panel-red {
	  border-color: #C94223;
	}
	.panel-red > .panel-heading {
	  border-color: #C94223;
	  color: #fff;
	  background-color: #C94223;
	}
	
	@media (min-width: 1200px){
		.col-lg-3 {
		  width: 40%;
		  margin-left:0.5%;
		}
	}
	.x-form-field-wrap .x-form-trigger{
		top:8px;
	}
	.ext-strict .x-form-text{
		height:20px;
	}
	</style>

  </head>
  
  
<body oncontextmenu="return false;" >
  <div class="panel panel-default" style="margin-bottom: 0%;">
    	<div class="panel-body">DASHBOARD</div>
  	</div> 
  	<div class="outer-container">
  		<div class="panel-body" id="custPanelDivId"></div>
  	<div class="container">
  		<div class="row" style="margin:0% 0% 0% 10%;">
                <div class="col-lg-3 col-md-6">
                    <div class="panel panel-green">
                        <div class="panel-heading">
                            <div class="row">                                
                                <div class="col-xs-9 text-right">
                                    <div class="huge" id = "totalFormsCountId">0</div>
                                    <div class="huge_text">Total Forms</div>
                                </div>
                            </div>
                        </div>
                        <div class="panel-footer" onclick="viewDetails('totalforms')">
                            <span class="pull-left">View Details</span>
                            <span class="pull-right"><i class="fa fa-arrow-circle-right"></i></span>
                            <div class="clearfix"></div>
                        </div>
                    </div>
                </div>
                <div class="col-lg-3 col-md-6">
                    <div class="panel panel-blue">
                        <div class="panel-heading">
                            <div class="row">
                                <div class="col-xs-9 text-right">
                                    <div class="huge" id = "pendingActionCountId">0</div>
                                    <div class="huge_text">Pending Action</div>
                                </div>
                            </div>
                        </div>
                        <div class="panel-footer" onclick="viewDetails('pending')">
                            <span class="pull-left">View Details</span>
                            <span class="pull-right"><i class="fa fa-arrow-circle-right"></i></span>
                            <div class="clearfix"></div>
                        </div>
                    </div>
                </div>
             </div>
             <div class="row" style="margin:0% 0% 0% 10%;margin-top: 1%;">   
                <div class="col-lg-3 col-md-6">
                    <div class="panel panel-black">
                        <div class="panel-heading">
                            <div class="row">
                                <div class="col-xs-9 text-right">
                                    <div class="huge" id = "approvedCountId">0</div>
                                    <div class="huge_text">Approved</div>
                                </div>
                            </div>
                        </div>
                        <div class="panel-footer" onclick="viewDetails('approved')">
                            <span class="pull-left">View Details</span>
                            <span class="pull-right"><i class="fa fa-arrow-circle-right"></i></span>
                            <div class="clearfix"></div>
                        </div>
                    </div>
                </div> 
				<div class="col-lg-3 col-md-6">
                    <div class="panel panel-red">
                        <div class="panel-heading">
                            <div class="row">
                                <div class="col-xs-9 text-right">
                                    <div class="huge" id = "rejectedCountId">0</div>
                                    <div class="huge_text">Rejected</div>
                                </div>
                            </div>
                        </div>
                        <div class="panel-footer" onclick="viewDetails('rejected')">
                            <span class="pull-left">View Details</span>
                            <span class="pull-right"><i class="fa fa-arrow-circle-right"></i></span>
                            <div class="clearfix"></div>
                        </div>
                    </div>
                </div>
            </div> 
         </div>
      </div>
  <script>
  	document.onkeydown = function(e) {
      if (event.keyCode == 123) {
          return false;
      }
      if (e.ctrlKey && e.shiftKey && e.keyCode == 'I'.charCodeAt(0)) {
          return false;
      }
      if (e.ctrlKey && e.shiftKey && e.keyCode == 'J'.charCodeAt(0)) {
          return false;
      }
      if (e.ctrlKey && e.keyCode == 'U'.charCodeAt(0)) {
          return false;
      }
  }
     var userAuthority = '<%=userAuthority%>';
     var load = '<%=load%>';
     var custId;
     var custName;
     var clientcombostore = new Ext.data.JsonStore({
	    url: '<%=request.getContextPath()%>/CommonAction.do?param=getCustomer',
	    id: 'CustomerStoreId',
	    root: 'CustomerRoot',
	    autoLoad: true,
	    remoteSort: true,
	    fields: ['CustId', 'CustName'],
	    listeners: {
	        load: function (custstore, records, success, options) {
	            if ( <%= customerId %> > 0) {
	                Ext.getCmp('custcomboId').setValue('<%=customerId%>');
		                custId = Ext.getCmp('custcomboId').getValue();
		                custName = Ext.getCmp('custcomboId').getRawValue();	
		                dashboardCountstore.load({
						params:{userAuthority:userAuthority,custId:custId},
						callback:function(){
							if(dashboardCountstore.getCount()>0){
				                var record = dashboardCountstore.getAt(0);
				                document.getElementById('totalFormsCountId').innerHTML = record.data['totalformscountIndex'];
		             			document.getElementById('pendingActionCountId').innerHTML = record.data['pendingactioncountIndex'];
		             			document.getElementById('approvedCountId').innerHTML = record.data['approvedcountIndex'];
		             			document.getElementById('rejectedCountId').innerHTML = record.data['rejectedcountIndex'];
				            	}
							}
						});	
		            }
		        }
		    }
	});
     var client = new Ext.form.ComboBox({
	    store: clientcombostore,
	    id: 'custcomboId',
	    mode: 'local',
	    forceSelection: true,
	    emptyText: 'select customer name',
	    blankText: 'select customer name',
	    selectOnFocus: true,
	    allowBlank: false,
	    anyMatch: true,
	    typeAhead: false,
	    triggerAction: 'all',
	    lazyRender: true,
	    valueField: 'CustId',
	    displayField: 'CustName',
	    cls: 'selectstylePerfect',
	    listeners: {
	        select: {
	            fn: function () {
	            		custId = Ext.getCmp('custcomboId').getValue();
		                custName = Ext.getCmp('custcomboId').getRawValue();	
	            		dashboardCountstore.load({
						params:{userAuthority:userAuthority,custId:Ext.getCmp('custcomboId').getValue()},
						callback:function(){
							if(dashboardCountstore.getCount()>0){
				                var record = dashboardCountstore.getAt(0);
				                document.getElementById('totalFormsCountId').innerHTML = record.data['totalformscountIndex'];
		             			document.getElementById('pendingActionCountId').innerHTML = record.data['pendingactioncountIndex'];
		             			document.getElementById('approvedCountId').innerHTML = record.data['approvedcountIndex'];
		             			document.getElementById('rejectedCountId').innerHTML = record.data['rejectedcountIndex'];
				            }
						}
					});	                 
	            }
	        }
	    }
	});
  	var clientCombo=new Ext.Panel({
		standardSubmit: true,
	    id: 'datePanelId',
	    layout: 'table',
	    frame: false,
	    border:false,
	    height:50,
	    layout: 'table',
	    cls:'dashboardcustomerinnerpannel',
		bodyCfg : { cls:'dashboardcustomerinnerpannel' , style: {'background-color': 'transparent'} },
	    layoutConfig: {
	        columns: 3
	    },
	    items: [{
	            xtype: 'label',
	            text: 'Select Customer :',
	            style:'display: block;margin-left: 30px;font-weight:300;font-size: 18px;color:rgb(255, 255, 255)',
	            id:'custlabId'
	        	},{
	            xtype: 'label',
	            text: '',
	            style:'display: block;margin-left: 30px;',
	            id:'xyz'
	        	},client]
		});
       	var dashboardCountstore = new Ext.data.JsonStore({
		    url: '<%=request.getContextPath()%>/MonthlyReturnsAction.do?param=getDashboardCount',
		    id: 'dashboardCountId',
		    root: 'dashboardCountRoot',
		    autoLoad: false,
		    remoteSort: true,
		    fields: ['totalformscountIndex','pendingactioncountIndex','approvedcountIndex','rejectedcountIndex']	
		});
		clientCombo.render('custPanelDivId');
		
		function viewDetails(type){
			if(Ext.getCmp('custcomboId').getValue()== ""){
           		Ext.example.msg("Select Customer");
                Ext.getCmp('custcomboId').focus();
                return;
           	}
			if(load != '1'){
				custId = Ext.getCmp('custcomboId').getValue();
			    custName = Ext.getCmp('custcomboId').getRawValue();
		    }else{
		    	custId = '<%=custId%>';
		    	custName = '<%=custName%>';
		    }
		    var monthlyReturnDashboardDetails ='/Telematics4uApp/Jsps/IronMining/MonthlyReturnDashboardDetails.jsp?custId='+custId+'&custName='+custName+'&type='+type;
        	parent.Ext.getCmp('monthlyReturnsDashboardDetailsTab').enable();
	  		parent.Ext.getCmp('monthlyReturnsDashboardTab').disable();
	  		parent.Ext.getCmp('monthlyReturnsDashboardDetailsTab').show();
	  		parent.Ext.getCmp('monthlyReturnsDashboardDetailsTab').update("<iframe style='width:100%;height:525px;border:0;' src='"+monthlyReturnDashboardDetails+"'></iframe>");
		}
		
		Ext.onReady(function () {
		Ext.get(document.body).addClass('ext-chrome-fixes');
        Ext.util.CSS.createStyleSheet('@media screen and (-webkit-min-device-pixel-ratio:0) {.x-grid3-cell{box-sizing: border-box !important;}}', 'chrome-fixes-box-sizing');
	    if(load == '1'){
	    	Ext.getCmp('custcomboId').setValue('<%=custName%>');
		    dashboardCountstore.load({
				params:{userAuthority:userAuthority,custId:'<%=custId%>'},
				callback:function(){
					if(dashboardCountstore.getCount()>0){
		                var record = dashboardCountstore.getAt(0);
		                document.getElementById('totalFormsCountId').innerHTML = record.data['totalformscountIndex'];
             			document.getElementById('pendingActionCountId').innerHTML = record.data['pendingactioncountIndex'];
             			document.getElementById('approvedCountId').innerHTML = record.data['approvedcountIndex'];
             			document.getElementById('rejectedCountId').innerHTML = record.data['rejectedcountIndex'];
		            }
				}
			});
		}
	});	

  </script>
  </body>
</html>
