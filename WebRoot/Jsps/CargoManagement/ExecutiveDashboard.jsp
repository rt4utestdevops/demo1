<%@ taglib uri="http://packtag.sf.net" prefix="pack" %>
<%@ page  language="java" import="java.util.*,java.text.SimpleDateFormat,t4u.functions.*,t4u.beans.*,t4u.common.*" pageEncoding="utf-8"%>
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
	String clientID=request.getParameter("cutomerID");
	String type=request.getParameter("type");
	LoginInfoBean loginInfo=new LoginInfoBean();
	loginInfo.setSystemId(systemid);
	loginInfo.setCustomerId(customerid);
	loginInfo.setUserId(userid);
	loginInfo.setLanguage(language);
	loginInfo.setZone(str[4].trim());
	loginInfo.setOffsetMinutes(Integer.parseInt(str[5].trim()));
	loginInfo.setSystemName(str[6].trim());
	loginInfo.setCategory(str[7].trim());
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
  int cutomerIDPassed=0;
  if(request.getParameter("cutomerIDPassed")!=null)
  {
  cutomerIDPassed=Integer.parseInt(request.getParameter("cutomerIDPassed"));
  }
  String SelectCustomer="Select Customer";
  String CustomerName="Customer Name";
%>

<jsp:include page="../Common/header.jsp" />

	    <meta charset="UTF-8" />
		<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1"> 
		<meta name="viewport" content="width=device-width, initial-scale=1.0"> 
		<title>Executive DashBoard</title>
		<link rel="stylesheet" type="text/css" href="../../Main/modules/xpressCargo/dashBoard/css/dashboard.css" />
		<pack:script src="../../Main/adapter/ext/ext-base.js"></pack:script>
		<pack:script src="../../Main/Js/ext-all-debug.js"></pack:script>
		<pack:style src="../../Main/resources/css/ext-all.css" />
		<script src="../../Main/Js/modernizr.custom.js"></script>
		<style type="text/css">
		.x-panel-mc {
			border: 0 none;
			padding: 0;
			margin: 0;
			padding-top: 6px;
			font: normal 11px tahoma,arial,helvetica,sans-serif;
			background-color: #ececec;
			}
		.x-panel-ml {
			background-color: #ececec;
			background-image: none;	
			}
		.x-panel-mr {
			background-image: none;
			}
					
		</style>
		<style>
			.container {
				height: 0px !important;
			}	
			label {
				display : inline !important;
			}	
			.ext-strict .x-form-text {
				height: 21px !important;
			}
			.iconspace {
				height: 0px !important;
			 }
		</style>

	<div class="container">	
			<header>
			<h1>
				<span>Dashboard</span>
			</h1>	
			</header>
			<div class="combodiv" id= "customerIddiv">
			</div>
			<div class="elementsdiv" style="height:420px;">
			<div class="dashboardmain">
			<div class="onschedulediv">
			<div class="iconspace"></div>
			<span class="iconon" id="onschedulecountid">0</span>
			<span class="spanon">On Schedule Vehicles</span>
			<div class="onscheduledetails"  onclick="gotoDetails('onschedule');"></div>
			</div>
			<div class="totalassetdiv">
			<div class="iconspace"></div>
			<span class="totalasseticon" id="totalassetcountid">0</span>
			<span class="span">Total Assets</span>
			<div class="totalassetsdetails"  onclick="gotoDetails('totalasset');"></div>
			</div>
			<div class="nogpsdiv">
			<div class="iconspace"></div>
			<span class="icon" id="nogpscountid">0</span>
			<span class="span">No GPS</span>
			<div class="nogpsdetails"  onclick="gotoDetails('nogps');"></div>
			</div>
			<div class="communicatingdiv">
			<div class="iconspace"></div>
			<span class="icon" id="noncommunicatingcountid">0</span>
			<span class="span">Non Communicating Vehicles</span>
			<div class="noncommdetails"  onclick="gotoDetails('noncommunicating');"></div>
			</div>
			</div>
			<div class="dashboardmain">
			<div class="bsvactionreqdiv">
			<div class="iconspace"></div>
			<span class="icon1" id="bsvactionreqcountid">0</span>
			<span class="span1">Behind the Schedule Vehicles<br>(Action Required)</span>
			<div class="bsvactionreqdetails"  onclick="gotoDetails('bsvactionreq');"></div>
			</div>
			<div class="bsvunderobsdiv">
			<div class="iconspace"></div>
			<span class="icon1" id="bsvunderobscountid">0</span>
			<span class="span2">Behind the Schedule Vehicles<br>(Under Observation)</span>
			<div class="bsvunderobvdetails"  onclick="gotoDetails('bsvunderobv');"></div>
			</div>
			</div>
			</div>
			</div>
			</div>
			<script type="text/javascript">
		var customercombostore= new Ext.data.JsonStore({
			       url:'<%=request.getContextPath()%>/CommonAction.do?param=getCustomer',
				   id:'CustomerStoreId',
			       root: 'CustomerRoot',
			       autoLoad: true,
			       remoteSort: true,
				   fields: ['CustId','CustName'],
				   listeners: 
				   {
	    				load: function(custstore, records, success, options) 
	    				{
	        				 if(<%=customerId%>>0)
	        				 {
	        				 	Ext.getCmp('custcomboId').setValue(<%=customerId%>);
					 			globalClientId=Ext.getCmp('custcomboId').getValue();
					 			getExecutiveDashboardElementsCount();
                        		
					 		 }
					 		 else if(<%=cutomerIDPassed%>>0)
					 		 {
					 		 Ext.getCmp('custcomboId').setValue(<%=cutomerIDPassed%>);
					 		 globalClientId=Ext.getCmp('custcomboId').getValue();
                	         getExecutiveDashboardElementsCount();
					 		 }
	    				}
    			  }
});
 var custnamecombo=new Ext.form.ComboBox({
	        store: customercombostore,
	        id:'custcomboId',
	        mode: 'local',
	        forceSelection: true,
	        emptyText:'<%=SelectCustomer%>',
	        selectOnFocus:true,
	        allowBlank: false,
	        anyMatch:true,
            typeAhead: false,
	        triggerAction: 'all',
	        lazyRender: true,
	    	valueField: 'CustId',
	    	displayField: 'CustName',
	    	//cls:'selectstylePerfect'
	    	listeners: 
	    	{
                  select: 
                  {
                	   fn:function()
                	   {    
                	        globalClientId=Ext.getCmp('custcomboId').getValue();
                	        getExecutiveDashboardElementsCount();
                	    }
				  }
 			}
 });
		var outerPanel = new Ext.Panel({
 			//renderTo: 'content',
            standardSubmit: true,
            frame: true,
            height:500,
			cls: 'mainpanelpercentage',
			layout:'table',
			layoutConfig:{columns:2},
            items:[{
					xtype: 'label',
					text: '<%=CustomerName%>'+':',
					cls:'labelstyle',
					id:'custnamelab'
			    },
				custnamecombo]
			
});
outerPanel.render('customerIddiv');
var executiveDashBoardElements = new Ext.data.JsonStore({
				url: '<%=request.getContextPath()%>/CargoManagementAction.do?param=getExecutiveDashboardElementsCount',
				id:'executiveDashboardElementsCountId',
				root: 'ExecutiveDashBoardElementCountRoot',
				autoLoad: false,
				remoteSort: true,
				fields: ['totalAssetCount','noGpsCount','nonComm','onSchedule','bsvAction','bsvUnder']
		});
		
		function getExecutiveDashboardElementsCount(){
			executiveDashBoardElements.load({
			params:{CustId : globalClientId},
				callback: function(){
					 for(var i=0;i<=executiveDashBoardElements.getCount()-1;i++) {
              		 	var rec = executiveDashBoardElements.getAt(i);
              			document.getElementById('totalassetcountid').innerHTML = rec.data['totalAssetCount'];
              			document.getElementById('nogpscountid').innerHTML = rec.data['noGpsCount'];
              			document.getElementById('noncommunicatingcountid').innerHTML = rec.data['nonComm'];
              			
              			document.getElementById('onschedulecountid').innerHTML = rec.data['onSchedule'];
              			document.getElementById('bsvactionreqcountid').innerHTML = rec.data['bsvAction'];
              			document.getElementById('bsvunderobscountid').innerHTML = rec.data['bsvUnder'];
					}
				}
			});	
			}
			
			
		function gotoDetails(type)
		{
		if (Ext.getCmp('custcomboId').getValue() == "") {

                        return;
                    }
		var customerIdPassed=Ext.getCmp('custcomboId').getValue();
		var custName=Ext.getCmp('custcomboId').getRawValue();
		window.location ="<%=request.getContextPath()%>/Jsps/CargoManagement/ExecutiveDashBoardDetails.jsp?cutomerID="+customerIdPassed+"&type="+type+"&custName="+custName;
		}	
			

            </script>
			 <jsp:include page="../Common/footer.jsp" />
 <!-- </body>   -->
 <!-- </html> -->