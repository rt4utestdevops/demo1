<%@ page language="java" import="java.util.*,java.text.SimpleDateFormat,t4u.functions.*,t4u.beans.*,t4u.common.*,org.json.*" pageEncoding="utf-8"%>
<%@ taglib uri="http://packtag.sf.net" prefix="pack" %>
<%
String path = request.getContextPath();
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
	if(str.length>8){
	loginInfo.setCustomerName(str[8].trim());
	}
	session.setAttribute("loginInfoDetails",loginInfo);
}
CommonFunctions cf=new CommonFunctions();
cf.checkLoginInfo((LoginInfoBean)session.getAttribute("loginInfoDetails"),session,request,response);
LoginInfoBean loginInfo=(LoginInfoBean)session.getAttribute("loginInfoDetails");
String language=loginInfo.getLanguage();
int systemid=loginInfo.getSystemId();
int customerId=loginInfo.getCustomerId();
boolean mapViewLink=false;
if(request.getParameter("mapViewlink")!=null)
{
   mapViewLink=true;
}
Calendar cal = Calendar.getInstance();
SimpleDateFormat formatter = new SimpleDateFormat("MMM");
SimpleDateFormat formatter1 = new SimpleDateFormat("dd");
int dayNum=0;
cal.add(Calendar.DATE,-1);
Date dt1=cal.getTime();
int day1=cal.get(Calendar.DAY_OF_WEEK);
cal.add(Calendar.DATE,-1);
Date dt2=cal.getTime();
int day2=cal.get(Calendar.DAY_OF_WEEK);
cal.add(Calendar.DATE,-1);
Date dt3=cal.getTime();
int day3=cal.get(Calendar.DAY_OF_WEEK);
cal.add(Calendar.DATE,-1);
Date dt4=cal.getTime();
int day4=cal.get(Calendar.DAY_OF_WEEK);
cal.add(Calendar.DATE,-1);
Date dt5=cal.getTime();
int day5=cal.get(Calendar.DAY_OF_WEEK);
cal.add(Calendar.DATE,-1);
Date dt6=cal.getTime();
int day6=cal.get(Calendar.DAY_OF_WEEK);
cal.add(Calendar.DATE,-1);
Date dt7=cal.getTime();
int day7=cal.get(Calendar.DAY_OF_WEEK);
String d1 = formatter1.format(dt1);
String date1 = formatter.format(dt1).toUpperCase()+"-"+d1;
String d2 = formatter1.format(dt2);
String date2 = formatter.format(dt2).toUpperCase()+"-"+d2;
String d3 = formatter1.format(dt3);
String date3 = formatter.format(dt3).toUpperCase()+"-"+d3;
String d4 = formatter1.format(dt4);
String date4 = formatter.format(dt4).toUpperCase()+"-"+d4;
String d5 = formatter1.format(dt5);
String date5 = formatter.format(dt5).toUpperCase()+"-"+d5;
String d6 = formatter1.format(dt6);
String date6 = formatter.format(dt6).toUpperCase()+"-"+d6;
String d7 = formatter1.format(dt7);
String date7 = formatter.format(dt7).toUpperCase()+"-"+d7;
%>

<!DOCTYPE html>
<html lang="en" class="no-js">
	<head>
		<meta charset="UTF-8" />
		<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1"> 
		<meta name="viewport" content="width=device-width, initial-scale=1.0"> 
		<title>DashBoard</title>
		<link rel="stylesheet" type="text/css" href="../../Main/modules/ironMining/dashBoard/css/layout.css" />
		<link rel="stylesheet" type="text/css" href="../../Main/modules/ironMining/dashBoard/css/component.css" />
		<script src="../../Main/adapter/ext/ext-base.js"></script>
		<script src="../../Main/Js/ext-all-debug.js"></script>
		<script src="../../Main/Js/modernizr.custom.js"></script>
		<pack:script src="../../Main/Js/MsgBox.js"></pack:script>
		<pack:style src="../../Main/resources/css/ext-all.css" />
		<pack:script src="../../Main/Js/Jquery-min.js"></pack:script>
		<script type = "text/javascript" src="../../Main/Js/jsapi.js"></script>
	</head>
	<body oncontextmenu="return false;" >
	<script type="text/javascript">
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
		function isIE() {
				var myNav = navigator.userAgent.toLowerCase();
			return (myNav.indexOf('msie') != -1) ? parseInt(myNav.split('msie')[1]) : false;
		}

		if(navigator.appName == 'Microsoft Internet Explorer' && isIE () <= 9){
			var customURL = '/Telematics4uApp/Jsps/Common/BrowserSupportDashBoard.html';
			window.location.href = customURL;
			window.location.assign(customURL);
			window.location.replace(customURL); 
			window.document.location = customURL
		}
	</script>
			<div class="container">	
			<!-- Codrops top bar -->
			<header>
				<h1><span>Dashboard</span></h1>	
			</header>
			<div class="combodiv" id= "customerIddiv"> </div>
			<div class="innercontainer" id="innercontainerId">
			<div class="main clearfix">
				<nav id="menu" class="nav">					
					<ul>
					<div class = "dashboardElements" >
						<li class = "totalAsset">
						<a href="<%=request.getContextPath()%>/Jsps/IronMining/MapView.jsp?vehicleType=all">
								<span class="icon">
									<i aria-hidden="true" id = "totalAssetCountId"></i>
								</span>
								<span>Total Vehicle</span>
							</a>
						</li>
						<li class = "noGps"">
						<a href="#">
								<span class="icon"> 
									<i aria-hidden="true" id = "tripsheetIssuedId"></i>
								</span>
								<span>Trip Sheet Issued</span>
							</a>
						</li>						
						<li class="sandPermits">
							<a href="#">
								<span class="icon">
									<i aria-hidden="true" id = "dispachedQuantityId"></i>
								</span>
								<span>Dispatched Quantity(tonnes)</span>
							</a>
						</li>
					</div>
					<div class = "dashboardElements">
						<li class = "communication">
						<a href="<%=request.getContextPath()%>/Jsps/IronMining/MapView.jsp?vehicleType=comm">
								<span class="icon">
									<i aria-hidden="true" id = "commCountId"></i>
								</span>
								<span>Vehicle Communication</span>
							</a>
						</li>
						<li class = "alerts">
						<a href="#">
								<span class="icon">
									<i aria-hidden="true" id = "tripSheetOpenId"></i>
								</span>
								<span>Trip Sheet Open</span>
							</a>
						</li>								
						<li class = "assetArrival">
							<a href="#">
								<span class="icon">
									<i aria-hidden="true" id = "inTransaitQuantityId"></i>
								</span>
								<span>In Transit Quantity(tonnes)</span>
							</a>
						</li>
					</div>
					<div class = "dashboardElements">
						<li class = "nonCommunication">
						<a href="<%=request.getContextPath()%>/Jsps/IronMining/MapView.jsp?vehicleType=noncomm">
								<span class="icon">
									<i aria-hidden="true" id = "nonCommId"></i>
								</span>
								<span>Vehicle Non Comm</span>
							</a>
						</li>
						<li class = "nonCommunication">
						<a href="#">
								<span class="icon">
									<i aria-hidden="true" id = "tripSheetClosedId"></i>
								</span>
								<span>Trip Sheet Closed</span>
							</a>
						</li>
						<li class = "permitsGenerated">
							<a href="#">
								<span class="icon">
									<i aria-hidden="true" class = "permitsGeneratedFont" id = "recievedQuantityId"></i>
								</span>
								<span>Received Quantity(tonnes)</span>
							</a>
						</li>
					</div>
					<div class = "dashboardElements">
						<li class = "permitsGenerated">
							<a href="#">
								<span class="icon">
									<i aria-hidden="true" class = "permitsGeneratedFont" id = "ClosedReturnTripId"></i>
								</span>
								<span>Closed Return Trip</span>
							</a>
						</li>
						
						<li class = "alerts">
							<a href="#">
								<span class="icon">
									<i aria-hidden="true" class = "permitsGeneratedFont" id = "vehiclesmodifiedtripId"></i>
								</span>
								<span>Vehicles with Modified Trip</span>
							</a>
						</li>
						
						<li class = "noGps">
							<a href="#">
								<span class="icon">
									<i aria-hidden="true" class = "permitsGeneratedFont" id = "vehiclesextendedtripId"></i>
								</span>
								<span>Vehicles with Extended Trip</span>
							</a>
						</li>
					</div>
					</ul>
				</nav>
			</div>
			<div>
				<div class = "revenueBarChart" id = "revenuechartdiv"></div>
				<div class = "permitBarChart" id = "permitchartdiv"></div>
			</div>
			</div>
		</div>		
		<script type="text/javascript">
		google.load("visualization", "1", {packages:["corechart"]});	
		
		
		function CheckSession() {
  						Ext.Ajax.request({
                        url: '<%=request.getContextPath()%>/IronDashboardAction.do?param=checkSession',
                        method: 'POST',
                        success: function (response, options)
                        {
                        if(response.responseText=='InvalidSession')
                        {
                        window.location.href = "<%=request.getContextPath()%>/Jsps/Common/SessionDestroy.html";
                        }
                        },
                        failure: function ()
                        {
                        } 
                    });
            }
            
            	
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
	    				     if(<%=mapViewLink%>)
	    				     {
	    				       Ext.getCmp('custcomboId').setValue(parent.parentCustomerID); 
	    				       Ext.getCmp('vehicleTypeId').setValue(parent.parentVehicleType);
	    				       getDashboardElementsCount();
                	   	       setInterval('getDashboardElementsCount()',60000); 
	    				     }
	        				 else if(<%=customerId%>>0)
	        				 {	        				 	
	        				 	Ext.getCmp('custcomboId').setValue(<%=customerId%>); 
	        				 	parent.parentCustomerID=Ext.getCmp('custcomboId').getValue();
	        				 	parent.parentVehicleType=Ext.getCmp('vehicleTypeId').getValue();
					 			getDashboardElementsCount();
                	   	        setInterval('getDashboardElementsCount()',60000);
                        		
					 		 }
	    				}
    			  }
});

var vehicleTypeStore = new Ext.data.SimpleStore({
                id: 'vehicletypestoreId',
                autoLoad: true,
                fields: ['Name', 'Value'],
                data: [
                    ['TRUCK', 'TRUCK'],
                    ['BARGE', 'BARGE']
                ]
            });

 var custnamecombo=new Ext.form.ComboBox({
	        store: customercombostore,
	        id:'custcomboId',
	        mode: 'local',
	        forceSelection: true,
	        emptyText:'Select Customer',
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
                	        parent.parentCustomerID=Ext.getCmp('custcomboId').getValue();
                	        parent.parentVehicleType=Ext.getCmp('vehicleTypeId').getValue();
                	        getDashboardElementsCount();
                	   	    setInterval('getDashboardElementsCount()',60000);
                	    }
				  }
 			}
 });
 
  var vehicleType=new Ext.form.ComboBox({
	        store: vehicleTypeStore,
	        id:'vehicleTypeId',
	        mode: 'local',
	        forceSelection: true,
	        //emptyText:'TRUCK',
	        //blankText:'TRUCK',
	        allowBlanks:false,
	        value:'TRUCK',
	        selectOnFocus:true,
	        anyMatch:true,
            typeAhead: false,
	        triggerAction: 'all',
	        lazyRender: true,
	    	valueField: 'Name',
	    	displayField: 'Value',
	    	//cls:'selectstylePerfect'
	    	listeners: 
	    	{
                  select: 
                  {
                	   fn:function()
                	   {    
                	    if(Ext.getCmp('custcomboId').getValue()=="")
                	    {
                	    alert('Please select Customer');
                	    Ext.getCmp('vehicleTypeId').reset();
                	    return;
                	    }
                	    parent.parentVehicleType=Ext.getCmp('vehicleTypeId').getValue();
                	   	getDashboardElementsCount();
                	   	setInterval('getDashboardElementsCount()',60000);
                	   }
				  }
 			}
 });
 
		var outerPanel = new Ext.Panel({
 			//renderTo: 'content',
            standardSubmit: true,
            frame: true,
            //height:550,
			cls: 'mainpanelpercentage',
			layout:'column',
			layoutConfig:{columns:5},
            items:[{
					xtype: 'label',
					text: 'Customer Name'+':',
					cls:'labelstyle',
					id:'custnamelab'
			    },
				custnamecombo,{width:10,height:5},
				{
					xtype: 'label',
					text: 'Vehicle Type'+':',
					cls:'labelstyle',
					id:'vehicleTypelblId'
			    },
				vehicleType
				]
			
});
setTimeout('renderDiv()',500);

function renderDiv()
{
outerPanel.render('customerIddiv');
}

		var revenueChart = {
			title: 'Day Wise Quantity',
            titleTextStyle: {
            	color: '#686262',
            	fontSize: 13
            },
            pieSliceText: "value",
            legend: {
                position: 'none'
            },
            sliceVisibilityThreshold:0,
            height: 341,
            isStacked: true,
            backgroundColor: '#E4E4E4',
    		is3D: true,
            hAxis:{title:'Dates',textStyle:{fontSize: 9},titleTextStyle: { italic: false}},
            vAxis:{title:'Quantity (tonnes)',viewWindow: {
                                            min:0
                                            },viewWindow: {
                        min:0
                    },titleTextStyle: { italic: false} }
        };
        
        var permitChart = {
			title: 'Day Wise Trip Sheet Issued',
            titleTextStyle: {
            	color: '#686262',
            	fontSize: 13
            },
            pieSliceText: "value",
            legend: {
                position: 'none'
            },
            sliceVisibilityThreshold: 0,
            height: 331,
            backgroundColor: '#E4E4E4',
    		is3D: true,
            isStacked: true,
            hAxis:{title:'Dates',textStyle:{fontSize: 9},titleTextStyle: { italic: false}},
            vAxis:{title:'Trip Sheet Issued',viewWindow: {
                                            min:0
                                            },maxValue:5,gridlines:{count:6},titleTextStyle: { italic: false} }
        };
		
		var dashBoardElements = new Ext.data.JsonStore({
				url: '<%=request.getContextPath()%>/IronDashboardAction.do?param=getDashboardElementsCount',
				id:'dashboardElementsCountId',
				root: 'DashBoardElementCountRoot',
				autoLoad: false,
				remoteSort: true,
				fields: ['totalAssetCount','tripsheetIssued','dispachedQuantity','commCount','tripSheetOpen','inTransaitQuantity','nonComm','tripSheetClosed','recievedQuantity','ClosedReturnTrip','vehiclesmodifiedtrip','vehiclesextendedtrip']
		});
		
		var dashBoardRevenueChartStore = new Ext.data.JsonStore({
				url: '<%=request.getContextPath()%>/IronDashboardAction.do?param=getDashboardRevenueChart',
				root: 'DashBoardRevenueChartRoot',
				autoLoad: false,
				remoteSort: true,
				fields: ['sunrevenueIndex','monrevenueIndex','tuerevenueIndex','wedrevenueIndex','thurevenueIndex','frirevenueIndex','satrevenueIndex']
		});
		
		var dashBoardPermitChartStore = new Ext.data.JsonStore({
				url: '<%=request.getContextPath()%>/IronDashboardAction.do?param=getDashboardPermitChart',
				root: 'DashBoardPermitChartRoot',
				autoLoad: false,
				remoteSort: true,
				fields: ['sunpermitIndex','monpermitIndex','tuepermitIndex','wedpermitIndex','thupermitIndex','fripermitIndex','satpermitIndex']
		});

		function getDashboardElementsCount(){
		CheckSession();
			dashBoardElements.load({
			params:{customerId:Ext.getCmp('custcomboId').getValue(),vehicleType:Ext.getCmp('vehicleTypeId').getValue()},
				callback: function(){
					 for(var i=0;i<=dashBoardElements.getCount()-1;i++) {
              		 	var rec = dashBoardElements.getAt(i);
              			document.getElementById('totalAssetCountId').innerHTML = rec.data['totalAssetCount'];
              			document.getElementById('tripsheetIssuedId').innerHTML = rec.data['tripsheetIssued'];
              			document.getElementById('dispachedQuantityId').innerHTML = rec.data['dispachedQuantity'];
              			document.getElementById('commCountId').innerHTML = rec.data['commCount'];
              			document.getElementById('tripSheetOpenId').innerHTML = rec.data['tripSheetOpen'];
              			document.getElementById('inTransaitQuantityId').innerHTML = rec.data['inTransaitQuantity'];
              			document.getElementById('nonCommId').innerHTML = rec.data['nonComm'];
              			document.getElementById('tripSheetClosedId').innerHTML = rec.data['tripSheetClosed'];
              			document.getElementById('recievedQuantityId').innerHTML = rec.data['recievedQuantity'];
              			document.getElementById('ClosedReturnTripId').innerHTML = rec.data['ClosedReturnTrip']; 
						document.getElementById('vehiclesmodifiedtripId').innerHTML = rec.data['vehiclesmodifiedtrip'];
              			document.getElementById('vehiclesextendedtripId').innerHTML = rec.data['vehiclesextendedtrip'];              			
					}
				}
			});	
			
			dashBoardRevenueChartStore.load({
			params:{customerId:Ext.getCmp('custcomboId').getValue(),vehicleType:Ext.getCmp('vehicleTypeId').getValue()},
				callback: function(){
					var barchartrevenuegraph = new google.visualization.ColumnChart(document.getElementById('revenuechartdiv'));
            		var rec = dashBoardRevenueChartStore.getAt(0);
            		var barchartrevenuedata = google.visualization.arrayToDataTable([
    					['DAYS', 'QUANTITY'],
    					['<%=date7%>', calcQuantity(<%=day7%>,rec)],
    					['<%=date6%>', calcQuantity(<%=day6%>,rec)],
    					['<%=date5%>', calcQuantity(<%=day5%>,rec)],
    					['<%=date4%>', calcQuantity(<%=day4%>,rec)],
    					['<%=date3%>', calcQuantity(<%=day3%>,rec)],
    					['<%=date2%>', calcQuantity(<%=day2%>,rec)],
    					['<%=date1%>',calcQuantity(<%=day1%>,rec)]
  					]);
            		barchartrevenuegraph.draw(barchartrevenuedata, revenueChart);
				}
			});	
			
			function calcQuantity( dayNum,rec)
			{
			var quantity=0;
			switch(dayNum)
            		{
            		case 1:quantity= parseFloat(rec.data['sunrevenueIndex']);
            		break;
            		case 2:quantity= parseFloat(rec.data['monrevenueIndex']);
            		break;
            		case 3:quantity= parseFloat(rec.data['tuerevenueIndex']);
            		break;
            		case 4:quantity= parseFloat(rec.data['wedrevenueIndex']);
            		break;
            		case 5:quantity= parseFloat(rec.data['thurevenueIndex']);
            		break;
            		case 6:quantity= parseFloat(rec.data['frirevenueIndex']);
            		break;
            		case 7:quantity= parseFloat(rec.data['satrevenueIndex']);
            		break;
            		default:quantity=0;
            		break;
            		}
            		return quantity;
			}
			
			function calcQuantity1( dayNum,rec)
			{
			var quantity=0;
			switch(dayNum)
            		{
            		case 1:quantity= parseFloat(rec.data['sunpermitIndex']);
            		break;
            		case 2:quantity= parseFloat(rec.data['monpermitIndex']);
            		break;
            		case 3:quantity= parseFloat(rec.data['tuepermitIndex']);
            		break;
            		case 4:quantity= parseFloat(rec.data['wedpermitIndex']);
            		break;
            		case 5:quantity= parseFloat(rec.data['thupermitIndex']);
            		break;
            		case 6:quantity= parseFloat(rec.data['fripermitIndex']);
            		break;
            		case 7:quantity= parseFloat(rec.data['satpermitIndex']);
            		break;
            		default:quantity=0;
            		break;
            		}
            		return quantity;
			}
			
			dashBoardPermitChartStore.load({
			params:{customerId:Ext.getCmp('custcomboId').getValue(),vehicleType:Ext.getCmp('vehicleTypeId').getValue()},
				callback: function(){
					var barchartpermitgraph = new google.visualization.ColumnChart(document.getElementById('permitchartdiv'));
            		var rec = dashBoardPermitChartStore.getAt(0);
            		var barchartpermitdata = google.visualization.arrayToDataTable([
    					['DAYS', 'TRIP SHEET'],
    					['<%=date7%>',  calcQuantity1(<%=day7%>,rec)],
    					['<%=date6%>',   calcQuantity1(<%=day6%>,rec)],
    					['<%=date5%>',   calcQuantity1(<%=day5%>,rec)],
    					['<%=date4%>',   calcQuantity1(<%=day4%>,rec)],
    					['<%=date3%>',   calcQuantity1(<%=day3%>,rec)],
    					['<%=date2%>',  calcQuantity1(<%=day2%>,rec)],
    					['<%=date1%>',  calcQuantity1(<%=day1%>,rec)]
  					]);
            		barchartpermitgraph.draw(barchartpermitdata, permitChart);
				}
			});
			
		}
		function gotoMapView(type)
			{
			 window.location ="<%=request.getContextPath()%>/Jsps/IronMining/MapView.jsp?customerID="+Ext.getCmp('custcomboId').getValue()+"&vehicleType="+type;
			 }
		</script>
		

	</body>
</html>
