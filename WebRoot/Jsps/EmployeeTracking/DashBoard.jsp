<%@ page  language="java" import="java.util.*,t4u.functions.CommonFunctions,t4u.beans.*,t4u.common.*" pageEncoding="utf-8"%>
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
	if(str.length>8){
	loginInfo.setCustomerName(str[8].trim());
	}
	session.setAttribute("loginInfoDetails",loginInfo);
}
CommonFunctions cf=new CommonFunctions();
cf.checkLoginInfo((LoginInfoBean)session.getAttribute("loginInfoDetails"),session,request,response);
String ipVal = request.getParameter("ipVal");
LoginInfoBean loginInfo=(LoginInfoBean)session.getAttribute("loginInfoDetails");
String language=loginInfo.getLanguage();
int systemid=loginInfo.getSystemId();
String systemID=Integer.toString(systemid);
int customeridlogged=loginInfo.getCustomerId();
int userid = loginInfo.getUserId();
Properties properties = null;
properties = ApplicationListener.prop;
String audioFilePath = properties.getProperty("DashBoardAlarmSoundPath");


ArrayList<String> tobeConverted = new ArrayList<String>();
tobeConverted.add("Shift_Time_24_Hour");
tobeConverted.add("Vehicles_On_Trip");
tobeConverted.add("Vehicles_On_Trip_Non_Comm");
tobeConverted.add("Vehicles_Arrived");
tobeConverted.add("Employees_On_Trip");
tobeConverted.add("Employees_Picked");
tobeConverted.add("Distress_Alerts");
tobeConverted.add("Overspeed_Alerts");
tobeConverted.add("Non_Communicating_Vehicles");
tobeConverted.add("Idle_Alerts");
tobeConverted.add("Female_1st_Picked");
tobeConverted.add("Hid_Swiped_Not_Matched");
tobeConverted.add("Total_Vehicles");
tobeConverted.add("Non_Communicating_Vehicles");
tobeConverted.add("Vehicles_Yet_To_Arrive");
tobeConverted.add("Gps_Trip_Sheet_Count");

ArrayList<String> convertedWords = new ArrayList<String>();
convertedWords = cf.getLanguageSpecificWordForKey(tobeConverted,language);
String shiftTime24Hour = convertedWords.get(0);
String vehiclesOnTrip = convertedWords.get(1);
String vehiclesOnTripNonComm = convertedWords.get(2);
String vehiclesArrived = convertedWords.get(3);
String employeesOnTrip = convertedWords.get(4);
String employeesPicked = convertedWords.get(5);
String distressAlerts = convertedWords.get(6);
String overspeedAlerts = convertedWords.get(7);
String nonCommunicatingVehicles = convertedWords.get(8);
String idleAlerts = convertedWords.get(9);
String female1stPicked = convertedWords.get(10);
String hidSwipedNotMatched = convertedWords.get(11);
String totalVehicles = convertedWords.get(12).toUpperCase();
String vehiclesYetToArrive = convertedWords.get(13);
String gpsTripSheetCount = convertedWords.get(14);

%>
	<jsp:include page="../Common/header.jsp" />
  <meta http-equiv="X-UA-Compatible" content="IE=9; IE=8; IE=7; IE=EDGE" />
		<title>DashBoard</title>
		<style type="text/css">
		.x-panel-body{
		border: 0 !important;
		background-image: url(/ApplicationImages/DashBoard/DashBoardBackground.png) !important;
				}
<!--		.x-form-field-wrap .x-form-trigger {-->
<!--		opacity: 0.0;-->
<!--		filter:alpha(opacity=0);-->
<!--		}-->
		.x-form-field-wrap .x-form-trigger {
background-image: url(/ApplicationImages/DashBoard/combonew.png) !important;
border-bottom-color: transparent !important;
}
.x-form-field-wrap .x-form-trigger {
background-image: url(/ApplicationImages/DashBoard/combonew.png) !important;
border-bottom-color: transparent !important;
}				
		</style>	
   
  
  <div height="100%" >
   <jsp:include page="../Common/ImportJS.jsp" />
   <script>
   var innerpage=<%=ipVal%>;	
	
	   	    if (innerpage == true) {
				
				if(document.getElementById("topNav")!=null && document.getElementById("topNav")!=undefined)
				{
					document.getElementById("topNav").style.display = "none";
					$(".container").css({"margin-top":"-72px"});
				}
				
			}
   window.onload = function () { 
		timeoutrefresh();
	}
   
 var outerPanel;
 var ctsb;
 var panel1;
 var firsttime=0;
 var tempdistresscount=0;
 var firsttimedistress=0;
 var prevDistressCount=0;
 var prevClientID=0;
 var currentdate=new Date();
 var userid = '<%=userid%>'
 // *********************************************************Refreshing Intervels for each Pannel************************************
 var triptableRefreshTime=300000;  //1 hour 
 var distressRefreshInterval=5000; // 5 seconds
 var overspeedRefreshInterval=60000;// 1 min
 var idleRefreshInterval=60000;
 var totalVehiclesRefreshInterval=60000;
 var nonCOmmunicatingRefreshInterval=60000;
 var firstladypickpRefreshInterval=60000;
 var HIDnotmatchedRefreshInterval=60000;
 //*************************************************************************************************************************************
 //In chrome activate was slow so refreshing the page
  function timeoutrefresh()
     {     
         	setTimeout('refresh()',100);
     }
 function refresh()
                 {
if (Ext.isIE)
{                 
if(document.URL.indexOf("#")==-1)
{
url = document.URL+"#";
location = "#";
location.reload();
}
}
<!---->
<!--                 isChrome = window.chrome;-->
<!--					if(isChrome && parent.flagEmp<2) {-->
<!--					// is chrome-->
<!--						              setTimeout(function(){-->
<!--						              parent.Ext.getCmp('dashboardtab').enable();-->
<!--									  parent.Ext.getCmp('dashboardtab').show();-->
<!--						              parent.Ext.getCmp('dashboardtab').update("<iframe style='width:100%;height:680px;border:0;' src='<%=path%>/Jsps/EmployeeTracking/DashBoard.jsp'></iframe>");-->
<!--						              },0);-->
<!--						              parent.employtracTab.doLayout();-->
<!--						              parent.flagEmp= parent.flagEmp+1;-->
<!--					} -->
                 }
    //***********window resize******************************
  Ext.EventManager.onWindowResize(function () {
   				var width = '100%';
			    var height = '100%';
			    SecondMainPannel.setSize(width, height);
			    SecondMainPannel.doLayout();
			    outerPanel.setSize(width, height);
			    outerPanel.doLayout();

			});
//**************************** Need to refresh the page once in IE for proper alingment****************************			
<!--if (Ext.isIE)-->
<!--{		-->
<!-- window.onload = function() {-->
<!--    if(!window.location.hash) {-->
<!--        window.location = window.location + '#loaded';-->
<!--        window.location.reload();-->
<!--    }-->
<!--}-->
<!--}			-->
 //******************************store for getting customer name************************
  var custmastcombostore= new Ext.data.JsonStore({
			url:'<%=request.getContextPath()%>/CommonAction.do?param=getallCustomer',
				   id:'CustomerStoreId',
			       root: 'CustomerRoot',
			       autoLoad: true,
			       remoteSort: true,
				   fields: ['CustId','CustName'],
				   listeners: {
    				load: function(cutstore, records, success, options) {
        				 if(<%=customeridlogged%>>0){
				 			Ext.getCmp('custmastcomboId').setValue('<%=customeridlogged%>');
				 			TripDataTable.removeAll(true);
		                 	   Ext.getCmp('dashBoarddistressimage').show();		
		                 	   Ext.getCmp('dashBoarddistress').show();			   	
		                 	   overspeedAlert();
		                 	   totalCount();
		                 	   noncommunicatingAlert();
		                 	   vehicleIdleAlert();
		                 	   firstladyladypicup();
		                 	   HIDnotswiped();
		                 	   getTripdata();	
		                 	   setInterval("getTripdata()", triptableRefreshTime);
		                 	   distressAlert();	
		                 	   setInterval("distressAlert()", distressRefreshInterval);	
				 		  }
    				}
    				}
	});
	
//**************************** Combo for Customer Name***************************************************
 var custnamecombo=new Ext.form.ComboBox({
	        store: custmastcombostore,
	        id:'custmastcomboId',
	        mode: 'local',
	        hidden:false,
	        resizable:true,
	        forceSelection: true,
	        emptyText:'Select Customer',
	        blankText :'Select Customer',
	        selectOnFocus:true,
	        allowBlank: false,
	        typeAhead: true,
	        triggerAction: 'all',
	        lazyRender: true,
	    	valueField: 'CustId',
	    	displayField: 'CustName',
	    	cls:'dashboardcombo',
	    	listeners: {
		                   select: {
		                 	   fn:function(){
		                 	   //firsttimedistress=0;
		                 	   TripDataTable.removeAll(true);
		                 	   Ext.getCmp('dashBoarddistressimage').show();	
		                 	   Ext.getCmp('dashBoarddistress').show();
		                 	   overspeedAlert();
		                 	   totalCount();
		                 	   noncommunicatingAlert();
		                 	   vehicleIdleAlert();
		                 	   firstladyladypicup();
		                 	   HIDnotswiped();
		                 	   getTripdata();	
		                 	   setInterval("getTripdata()", triptableRefreshTime);
		                 	   distressAlert();	
		                 	   setInterval("distressAlert()", distressRefreshInterval);			   	
		                 	   }}
                 	   }   
    });
<!--    var interval = setInterval(function() {-->
<!--    	TripDataTable.removeAll(true);-->
<!--    	getTripdata();-->
<!--		}, triptableRefreshTime); -->
<!--	var distressInterval = setInterval(function() {-->
<!--    	distressAlert();-->
<!--		}, distressRefreshInterval); -->
	var sessionInterval = setInterval(function() {
    	CheckSession();
		}, 1000);	
  	var customerinnerPanel = new Ext.Panel({
		standardSubmit: true,
		collapsible:false,
		frame:false,
		cls:'dashboardcustomerinnerpannel',
		bodyCfg : { cls:'dashboardcustomerinnerpannel' , style: {'background-color': 'transparent'} },
		id:'custcomboMaster',
		layout:'table',
		layoutConfig: {
			columns:2
		},
		items: [custnamecombo,
				{
				xtype: 'label',
				text:currentdate,
				allowBlank: false,
				cls:'dashboardcurrentdatetime',
				hidden:true,
				id:'currendateid'
				}]
		});	
//******************************************************************* Trip Store**************************************************************
var tripDetailsStore=new Ext.data.JsonStore({
				url: '<%=request.getContextPath()%>/DashBoard.do?param=getTripDetails',
				id:'TripDetails',
				root: 'TripDetails',
				autoLoad: false,
				remoteSort: true,
				fields: ['shifttime','vehiclesontrip','vehiclesontripcomm','vehiclesarrived','employeesontrip','employeesonswipe','tripname','shiftstatus']
		});
var distressStore=new Ext.data.JsonStore({
				url: '<%=request.getContextPath()%>/DashBoard.do?param=getDistressCount',
				id:'DistressDetails',
				root: 'DistressDetails',
				autoLoad: false,
				remoteSort: true,
				fields: ['distresscount','distressflag']
		});					
  var customerMainPanel = new Ext.Panel({
		standardSubmit: true,
		collapsible:false,
		frame:false,
		cls:'dashboardcustomerpannel',
		bodyCfg : { cls:'dashboardcustomerpannel' , style: {'background-image': 'url(/ApplicationImages/DashBoard/Box_Blue.png) !important','background-repeat': 'repeat'} },
		id:'custMaster',
		items: [customerinnerPanel]
		});
	 
//*****************************************************************************************************************************************************	
   var DashBoardDistressPannelImage = new Ext.Panel({
		standardSubmit: true,
		collapsible:false,
		border:false,
		frame:false,
		id:'dashBoarddistressimage',
		width:'49%',
		hidden:true,
		bodyCfg : { cls:'inneralertpannelitems' ,style: {'background':'#044452'} },
		items: [{cls:'distressimage'}]
		}); // End of Panel	 
   var DashBoardDistressPannel = new Ext.Panel({
		standardSubmit: true,
		collapsible:false,
		border:false,
		frame:false,
		hidden:false,
		id:'dashBoarddistress',
		width: '49%',
		bodyCfg : { cls:'inneralertpannelitems' ,style: {'background':'#044452'} },
		items: []
		}); // End of Panel
	var DashBoardDistressMainPannel = new Ext.Panel({
		standardSubmit: true,
		collapsible:false,
		border:false,
		frame:false,
		id:'dashBoardmaindistress',
		width:'99%',
		bodyCfg : { cls:'inneralertpannelitems' ,style: {'background':'#044452'} },
		layout:'column',
		layoutConfig: {
			columns:2
		},
		items: [DashBoardDistressPannelImage,DashBoardDistressPannel]
		}); // End of Panel		
	var DashBoardOverspeedPannel = new Ext.Panel({
		standardSubmit: true,
		collapsible:false,
		border:false,
		frame:false,
		id:'dashBoardoverspeed',
		width: '49%',
		bodyCfg : { cls:'inneralertpannelitems' ,style: {'background':'#044452'} },
		items: []
		}); // End of Panel
		
	var DashBoardNonCommunicatingPannel = new Ext.Panel({
		standardSubmit: true,
		collapsible:false,
		border:false,
		frame:false,
		id:'dashBoardnoncommunicatingvehicles',
		width: '49%',
		bodyCfg : { cls:'inneralertpannelitems' ,style: {'background':'#044452'} },
		items: []
		}); // End of Panel
	var DashBoardVehicleStoppagePannel = new Ext.Panel({
		standardSubmit: true,
		collapsible:false,
		border:false,
		frame:false,
		id:'dashBoardvehiclestoppagepannel',
		width: '49%',
		bodyCfg : { cls:'inneralertpannelitems' ,style: {'background':'#044452'} },
		items: []
		}); // End of Panel	
			
	var DashBoardTotalVehiclePannel = new Ext.Panel({
		standardSubmit: true,
		collapsible:false,
		border:false,
		frame:false,
		id:'dashBoardtotalvehicles',
		width: '49%',
		bodyCfg : { cls:'inneralertpannelitems' ,style: {'background':'#044452'} },
		items: []
		}); // End of Panel
	var DashBoardLadyPickupDropPannel = new Ext.Panel({
		standardSubmit: true,
		collapsible:false,
		border:false,
		frame:false,
		width: '49%',
		id:'dashBoardladypickuppannel',
		bodyCfg : { cls:'inneralertpannelitems' ,style: {'background':'#044452'} },
		items: []
		}); // End of Panel
	var DashBoardHIDPannel = new Ext.Panel({
		standardSubmit: true,
		collapsible:false,
		border:false,
		frame:false,
		id:'dashboardHIDpannel',
		width: '49%',
		bodyCfg : { cls:'inneralertpannelitems' ,style: {'background':'#044452'} },
		items: []
		}); // End of Panel				
	var DashBoardLadyPickupMain = new Ext.Panel({
		standardSubmit: true,
		collapsible:false,
		border:false,
		frame:false,
		id:'LadyPickupMainPanelid',
		width:'99%',
		height:110,
		bodyCfg : { cls:'inneralertpannelitems' ,style: {'background':'#044452'} },
		layout:'column',
		layoutConfig: {
			columns:2
		},
		items: [DashBoardLadyPickupDropPannel,DashBoardHIDPannel]
		}); // End of Panel		
	var DashBoardStoppageNonCommPannel = new Ext.Panel({
		standardSubmit: true,
		collapsible:false,
		border:false,
		frame:false,
		id:'NoncommunicatingMainPanelid',
		width:'99%',
		height:90,
		bodyCfg : { cls:'inneralertpannelitems' ,style: {'background':'#044452'} },
		layout:'column',
		layoutConfig: {
			columns:2
		},
		items: [DashBoardVehicleStoppagePannel,DashBoardNonCommunicatingPannel]
		}); // End of Panel			
	var OverSpeedMainPannel = new Ext.Panel({
		standardSubmit: true,
		collapsible:false,
		border:false,
		frame:false,
		id:'dashBoardmainoverspeed',
		width:'99%',
		height:90,
		bodyCfg : { cls:'inneralertpannelitems' ,style: {'background':'#044452'} },
		layout:'column',
		layoutConfig: {
			columns:2
		},
		items: [DashBoardOverspeedPannel,DashBoardTotalVehiclePannel]
		}); // End of Panel	 
 var MainAlertPannel = new Ext.Panel({
		standardSubmit: true,
		collapsible:false,
		border:false,
		frame:false,
		//hidden:true,
		id:'mainalertpannel',
		cls:'innsersecondpannelalert',
		//bodyCfg : { cls:'innsersecondpannel' ,style: {'background':'#044452'} },
		items: [DashBoardDistressMainPannel,OverSpeedMainPannel,DashBoardStoppageNonCommPannel,DashBoardLadyPickupMain]
		}); // End of Panel
//********************************************** ALERT PANNEL ENDS****************************************************************************
var TripHeaderPannel = new Ext.Panel({
		standardSubmit: true,
		collapsible:false,
		border:false,
		frame:false,
		id:'dashBoardtripheaderid',
		bodyCfg : { cls:'dashboardmainheader' , style: {'background-image': 'url(/ApplicationImages/DashBoard/Box_Black.png) !important','background-repeat': 'repeat'} },
		height:70,
		layout:'column',
		layoutConfig: {
			columns:6
		},
		items: [{
				xtype: 'label',
				text:'<%=shiftTime24Hour %>',
				allowBlank: false,
				hidden:false,
				cls:'dashboardtripheader',
				bodyCfg:{style:'padding-top:20px'},
				width:'16%',
				id:'totalroutesheaderid1'
				},
				{
				xtype: 'label',
				text:'<%=vehiclesOnTrip %>',
				allowBlank: false,
				hidden:false,
				cls:'dashboardtripheader',
				width:'17%',
				id:'totalroutesheaderid2'
				},
				{
				xtype: 'label',
				text:'<%=gpsTripSheetCount%>',
				allowBlank: false,
				hidden:false,
				cls:'dashboardtripheader',
				width:'19%',
				id:'totalroutesheaderidnoncomm'
				},
				{
				xtype: 'label',
				text:'<%=vehiclesYetToArrive %>',
				allowBlank: false,
				hidden:false,
				cls:'dashboardtripheader',
				width:'16%',
				id:'totalroutesheaderid3'
				},
				{
				xtype: 'label',
				text:'<%=employeesOnTrip %>',
				allowBlank: false,
				hidden:false,
				cls:'dashboardtripheader',
				width:'16%',
				id:'totalroutesheaderid4'
				},
				{
				xtype: 'label',
				text:'<%=employeesPicked %>',
				allowBlank: false,
				hidden:false,
				cls:'dashboardtripheader',
				width:'16%',
				id:'totalroutesheaderid5'
				}
				]
		}); // End of Panel
	var TripHeaderPannelDrop = new Ext.Panel({
		standardSubmit: true,
		collapsible:false,
		border:false,
		frame:false,
		id:'dashBoardtripheaderdropid',
		bodyCfg : { cls:'dashboardmainheader' , style: {'background-image': 'url(/ApplicationImages/DashBoard/Box_Black.png) !important','background-repeat': 'repeat'} },
		height:70,
		layout:'column',
		layoutConfig: {
			columns:6
		},
		items: [{
				xtype: 'label',
				text:'<%=shiftTime24Hour %>',
				allowBlank: false,
				hidden:false,
				cls:'dashboardtripheader',
				bodyCfg:{style:'padding-top:20px'},
				width:'16%',
				id:'totalroutesheaderid1'
				},
				{
				xtype: 'label',
				text:'<%=vehiclesOnTrip %>',
				allowBlank: false,
				hidden:false,
				cls:'dashboardtripheader',
				width:'17%',
				id:'totalroutesheaderid2'
				},
				{
				xtype: 'label',
				text:'<%=vehiclesOnTripNonComm %>',
				allowBlank: false,
				hidden:false,
				cls:'dashboardtripheader',
				width:'19%',
				id:'totalroutesheaderidnoncomm'
				},
				{
				xtype: 'label',
				text:'<%=vehiclesArrived %>',
				allowBlank: false,
				hidden:false,
				cls:'dashboardtripheader',
				width:'16%',
				id:'totalroutesheaderid3'
				},
				{
				xtype: 'label',
				text:'<%=employeesOnTrip %>',
				allowBlank: false,
				hidden:false,
				cls:'dashboardtripheader',
				width:'16%',
				id:'totalroutesheaderid4'
				},
				{
				xtype: 'label',
				text:'<%=employeesPicked %>',
				allowBlank: false,
				hidden:false,
				cls:'dashboardtripheader',
				width:'16%',
				id:'totalroutesheaderid5'
				}
				]
		}); // End of Panel
			
	var TripDataTable = new Ext.Panel({
		standardSubmit: true,
		collapsible:false,
		border:false,
		frame:false,
		id:'dashBoardtripdatatable',
		height:400,
		items: []
		}); // End of Panel		
//********************************************** TRIP PANNEL STARTS****************************************************************************						
   var MainTripPannel = new Ext.Panel({
		standardSubmit: true,
		collapsible:false,
		border:false,
		frame:false,
		//hidden:true,
		id:'maintrippannelid',
		cls:'innsersecondpannel',
		items: [TripHeaderPannel,TripDataTable]
		}); // End of Panel	
	
 var SecondMainPannel = new Ext.Panel({
		standardSubmit: true,
		collapsible:false,
		border:false,
		frame:false,
		id:'secondpannelid',
		cls:'secondpannel',
		layout:'column',
		layoutConfig: {
			columns:4
		},
		items: [{cls:'dashTripAlertSpace'},MainTripPannel,{cls:'dashTripAlertSpace'},MainAlertPannel]
		}); // End of Panel		
//****************************************************DISTRESS***********************************************************************************	
function distressAlert()
{
var loadMask = new Ext.LoadMask('custMaster', {msg:'Loading..'});
distressStore.load({
		                 	    			 params:{
		                 	    			 custID: Ext.getCmp('custmastcomboId').getValue(),
		                 	    			 prevDistressCount:prevDistressCount,
		                 	    			 prevClientID:prevClientID
		                 	    			 },
              		          				 callback:function(records, operation, success){
              		          				 var rec = distressStore.getAt(0);
              		          				 var distresscount=0;
              		          				 var distressflag='false';
              		          				 if(rec.data['distresscount']!='-1')
              		          				 {
              		          				 if(distressStore.getCount()==1)
              		          				 {
              		          				 distresscount=rec.data['distresscount'];
											 distressflag=rec.data['distressflag'];
											 }
											 createDistressPannel(distresscount);
											 if(distressflag=='true')
											 {
											 playAlertSound();
											 }
											 //firsttimedistress=1;
											 prevClientID=Ext.getCmp('custmastcomboId').getValue();
											 prevDistressCount=distresscount;
											 }
											 loadMask.hide();
              		          				 }
              		          				 
              		          				});	
}
function createDistressPannel(overspeedcountno)
{
var countdistress=overspeedcountno;
Ext.getCmp('dashBoarddistress').remove('distressid',true);
Ext.getCmp('dashBoarddistress').doLayout(); 
 var distressPannel = new Ext.Panel({
		standardSubmit: true,
		frame:false,
		border:false,		
		collapsible:false,
		height:107,
		bodyCfg : { cls:'innerdistresspaneldashboard' , style: {'background-color':'#000'} },
		id:'distressid',
		layout:'vbox',
		items:[			
				{
				xtype: 'label',
				text:'<%=distressAlerts %>',
				allowBlank: false,
				hidden:false,
				cls:'dashboarddistressheaderstyle',
				id:'alertheaderd'
				},
				{
				xtype: 'label',
				text:countdistress,
				allowBlank: false,
				hidden:false,
				region: 'center',
				cls:'dashboarddistresscountstyle',
				id:'alertnoidd'
				}]
		}); // End of Panel		
		Ext.getCmp('dashBoarddistress').add(distressPannel);
        Ext.getCmp('dashBoarddistress').doLayout(); 
}
//****************************************************OVERSPEED*****************************************************************************
function overspeedAlert()
{
		                Ext.Ajax.request({
                        url: '<%=request.getContextPath()%>/DashBoard.do?param=getOverSpeedCount',
                        method: 'POST',
                        params: {
                        	custID: Ext.getCmp('custmastcomboId').getValue()
                        },
                        success: function (response, options)
                        {
                        createOverspeedPannel(response.responseText);
                        setTimeout(function(){
          				overspeedAlert();
        				},overspeedRefreshInterval); //refresh again in 60 seconds
                        },
                        failure: function ()
                        {
                        } 
                    });                  
}
function createOverspeedPannel(overspeedcountno)
{
Ext.getCmp('dashBoardoverspeed').remove('overspeedid',true);
Ext.getCmp('dashBoardoverspeed').doLayout(); 
var countoverspeed=overspeedcountno;
var overspeedPannel = new Ext.Panel({
		standardSubmit: true,
		frame:false,
		border:false,		
		collapsible:false,
		height:100,
		bodyCfg : { cls:'innerdistresspaneldashboard' , style: {'background-image': 'url(/ApplicationImages/DashBoard/Box_Yellow.png) !important','background-repeat': 'repeat'} },
		id:'overspeedid',
		layout:'vbox',
		items:[			
				{
				xtype: 'label',
				text:'<%=overspeedAlerts %>',
				allowBlank: false,
				hidden:false,
				cls:'dashboardoverspeedheaderstylegrey',
				id:'overspeedheaderid'
				},
				{
				xtype: 'label',
				text:countoverspeed,
				allowBlank: false,
				hidden:false,
				region: 'center',
				cls:'dashboardcountstylegrey',
				id:'overspeedcountid'
				}]
		}); // End of Panel		
		Ext.getCmp('dashBoardoverspeed').add(overspeedPannel);
        Ext.getCmp('dashBoardoverspeed').doLayout(); 
}
//******************************************************NON COMMUNICATING ALERT******************************************************************
function noncommunicatingAlert()
{
		                Ext.Ajax.request({
                        url: '<%=request.getContextPath()%>/DashBoard.do?param=getNonCommunicatingVehicles',
                        method: 'POST',
                        params: {
                        	custID: Ext.getCmp('custmastcomboId').getValue(),
                        	userid: userid
                        },
                        success: function (response, options)
                        {
                        createnonCommunicatingPannel(response.responseText);
                        setTimeout(function(){
          				noncommunicatingAlert();
        				},nonCOmmunicatingRefreshInterval); //refresh again in 5 seconds
                        },
                        failure: function ()
                        {
                        } 
                    });
}

function createnonCommunicatingPannel(totalNonCommunicating)
{
Ext.getCmp('dashBoardnoncommunicatingvehicles').remove('totalnoncommunicatingid',true);
Ext.getCmp('dashBoardnoncommunicatingvehicles').doLayout(); 
var nonCommunicatingCount=totalNonCommunicating;
var totalNoncommunicatingVehiclePannel = new Ext.Panel({
		standardSubmit: true,
		frame:false,
		border:false,		
		collapsible:false,
		height:100,
		bodyCfg : { cls:'innerdistresspaneldashboard' , style: {'background-image': 'url(/ApplicationImages/DashBoard/Box_Black.png) !important','background-repeat': 'repeat'} },
		id:'totalnoncommunicatingid',
		layout:'vbox',
		items:[			
				{
				xtype: 'label',
				text:'<%=nonCommunicatingVehicles %>',
				allowBlank: false,
				hidden:false,
				cls:'dashboardoverspeedheaderstyle',
				id:'noncommunicatingheaderid'
				},
				{
				xtype: 'label',
				text:nonCommunicatingCount,
				allowBlank: false,
				hidden:false,
				region: 'center',
				cls:'dashboardcountstyle',
				id:'noncommunicatingcountid'
				}]
		}); // End of Panel		
		Ext.getCmp('dashBoardnoncommunicatingvehicles').add(totalNoncommunicatingVehiclePannel);
        Ext.getCmp('dashBoardnoncommunicatingvehicles').doLayout(); 
}
//************************************************* TOTAL COUNT *****************************************************************************
function totalCount()
{
		                Ext.Ajax.request({
                        url: '<%=request.getContextPath()%>/DashBoard.do?param=getTotalVehicles',
                        method: 'POST',
                        params: {
                        	custID: Ext.getCmp('custmastcomboId').getValue(),
                        	userid: userid
                        },
                        success: function (response, options)
                        {
                        createtotalCountPannel(response.responseText);
                        setTimeout(function(){
          				totalCount();
        				},totalVehiclesRefreshInterval); //refresh again in 5 seconds
                        },
                        failure: function ()
                        {
                        } 
                    });
}

function createtotalCountPannel(totalVehiclecountno)
{
Ext.getCmp('dashBoardtotalvehicles').remove('totalvehiclesid',true);
Ext.getCmp('dashBoardtotalvehicles').doLayout(); 
var totalcount=totalVehiclecountno;
var totalVehiclePannel = new Ext.Panel({
		standardSubmit: true,
		frame:false,
		border:false,		
		collapsible:false,
		height:100,
		bodyCfg : { cls:'innerdistresspaneldashboard' , style: {'background-image': 'url(/ApplicationImages/DashBoard/Box_Black.png) !important','background-repeat': 'repeat'} },
		id:'totalvehiclesid',
		layout:'vbox',
		items:[			
				{
				xtype: 'label',
				text:'<%=totalVehicles %>',
				allowBlank: false,
				hidden:false,
				cls:'dashboardoverspeedheaderstyle',
				id:'totavehiclesheaderid'
				},
				{
				xtype: 'label',
				text:totalcount,
				allowBlank: false,
				hidden:false,
				region: 'center',
				cls:'dashboardcountstyle',
				id:'totalVehiclescountid'
				}]
		}); // End of Panel		
		Ext.getCmp('dashBoardtotalvehicles').add(totalVehiclePannel);
        Ext.getCmp('dashBoardtotalvehicles').doLayout(); 
}
//******************************************************VEHICLE STOPPAGE******************************************************************
function vehicleIdleAlert()
{
		                Ext.Ajax.request({
                        url: '<%=request.getContextPath()%>/DashBoard.do?param=getIdleAlert',
                        method: 'POST',
                        params: {
                        	custID: Ext.getCmp('custmastcomboId').getValue()
                        },
                        success: function (response, options)
                        {
                        createvehicleStoppagePannel(response.responseText);
                        setTimeout(function(){
          				vehicleIdleAlert();
        				},idleRefreshInterval); //refresh again in 5 seconds
                        },
                        failure: function ()
                        {
                        } 
                    });
}

function createvehicleStoppagePannel(vehicleStoppageAlert)
{
Ext.getCmp('dashBoardvehiclestoppagepannel').remove('vehiclestoppageid',true);
Ext.getCmp('dashBoardvehiclestoppagepannel').doLayout(); 
var vehiclestoppageCount=vehicleStoppageAlert;
var vehicleStoppagePannel = new Ext.Panel({
		standardSubmit: true,
		frame:false,
		border:false,		
		collapsible:false,
		height:100,
		bodyCfg : { cls:'innerdistresspaneldashboard' , style: {'background-image': 'url(/ApplicationImages/DashBoard/Box_Blue.png) !important','background-repeat': 'repeat'} },
		id:'vehiclestoppageid',
		layout:'vbox',
		items:[			
				{
				xtype: 'label',
				text:'<%=idleAlerts %>',
				allowBlank: false,
				hidden:false,
				cls:'dashboardoverspeedheaderstylegrey',
				id:'vehiclestoppageheaderid'
				},
				{
				xtype: 'label',
				text:vehiclestoppageCount,
				allowBlank: false,
				hidden:false,
				region: 'center',
				cls:'dashboardcountstylegrey',
				id:'vehiclestoppgecount'
				}]
		}); // End of Panel		
		Ext.getCmp('dashBoardvehiclestoppagepannel').add(vehicleStoppagePannel);
        Ext.getCmp('dashBoardvehiclestoppagepannel').doLayout(); 
}
//*************************************************LADY PICKU UP/DROP*******************************************************************************
function firstladyladypicup()
{
		                Ext.Ajax.request({
                        url: '<%=request.getContextPath()%>/DashBoard.do?param=getFirstLadyPickup',
                        method: 'POST',
                        params: {
                        	custID: Ext.getCmp('custmastcomboId').getValue()
                        },
                        success: function (response, options)
                        {
                        createladypickupdropPannel(response.responseText);
                        setTimeout(function(){
          				firstladyladypicup();
        				},firstladypickpRefreshInterval); //refresh again in 5 seconds
                        },
                        failure: function ()
                        {
                        } 
                    });
}
function createladypickupdropPannel(ladyPickupDropAlert)
{
Ext.getCmp('dashBoardladypickuppannel').remove('ladypickupid',true);
Ext.getCmp('dashBoardladypickuppannel').doLayout(); 
var ladyPickupDrop=ladyPickupDropAlert;
var ladyPickupPannel = new Ext.Panel({
		standardSubmit: true,
		frame:false,
		border:false,		
		collapsible:false,
		height:100,
		bodyCfg : { cls:'innerdistresspaneldashboard' , style: {'background-image': 'url(/ApplicationImages/DashBoard/Box_Green.png) !important','background-repeat': 'repeat'} },
		id:'ladypickupid',
		layout:'vbox',
		items:[			
				{
				xtype: 'label',
				text:'<%=female1stPicked %>',
				allowBlank: false,
				hidden:false,
				cls:'dashboardoverspeedheaderstylegrey',
				id:'ladypickupheaderid'
				},
				{
				xtype: 'label',
				text:ladyPickupDrop,
				allowBlank: false,
				hidden:false,
				region: 'center',
				cls:'dashboardcountstylegrey',
				id:'ladypickupcountcount'
				}]
		}); // End of Panel		
		Ext.getCmp('dashBoardladypickuppannel').add(ladyPickupPannel);
        Ext.getCmp('dashBoardladypickuppannel').doLayout(); 
}
//********************************************************TOTAL ROUTES************************************************************************										
function HIDnotswiped()
{
		                Ext.Ajax.request({
                        url: '<%=request.getContextPath()%>/DashBoard.do?param=getHIDnotswiped',
                        method: 'POST',
                        params: {
                        	custID: Ext.getCmp('custmastcomboId').getValue()
                        },
                        success: function (response, options)
                        {
                        createHIDPannel(response.responseText);
                        setTimeout(function(){
          				HIDnotswiped();
        				},HIDnotmatchedRefreshInterval); //refresh again in 5 seconds
                        },
                        failure: function ()
                        {
                        } 
                    });
}
function createHIDPannel(HIDcount)
{
Ext.getCmp('dashboardHIDpannel').remove('HIDnotswipedid',true);
Ext.getCmp('dashboardHIDpannel').doLayout(); 
var totalHIDcount=HIDcount;
var HIDPannel = new Ext.Panel({
		standardSubmit: true,
		frame:false,
		border:false,		
		collapsible:false,
		height:100,
		bodyCfg : { cls:'innerdistresspaneldashboard' , style: {'background-image': 'url(/ApplicationImages/DashBoard/Box_Black.png) !important','background-repeat': 'repeat'} },
		id:'HIDnotswipedid',
		layout:'vbox',
		items:[			
				{
				xtype: 'label',
				text:'<%=hidSwipedNotMatched %>',
				allowBlank: false,
				hidden:false,
				cls:'dashboardoverspeedheaderstyle',
				id:'totalhidcountheader'
				},
				{
				xtype: 'label',
				text:totalHIDcount,
				allowBlank: false,
				hidden:false,
				region: 'center',
				cls:'dashboardcountstyle',
				id:'totalhidcount'
				}]
		}); // End of Panel		
		Ext.getCmp('dashboardHIDpannel').add(HIDPannel);
        Ext.getCmp('dashboardHIDpannel').doLayout(); 
}
//*********************************************************Trip data tblepannel**********************************************
function createtripdataPannel(time,vehicleontrip,vehiclesontripcomm,vehiclearrived,employeesontrip,employeespickupdrop,i,color,fontcolor)
{
var tripdataPannel = new Ext.Panel({
		standardSubmit: true,
		frame:false,
		border:false,		
		collapsible:false,
		bodyCfg : { cls:'innernaltripdatapannel' , style: {'background-color':color} },
		id:'tripdataid'+i,
		layout:'column',
		layoutConfig: {
			columns:6
		},
		items:[			
				{
				xtype: 'label',
				text:time,
				allowBlank: false,
				hidden:false,
				width:'16%',
				height:40,
				cls:'tripdatastyle',
				style: {
				color:fontcolor
				},
				id:'tripshifttime'+i
				},
				{
				xtype: 'label',
				text:vehicleontrip,
				allowBlank: false,
				hidden:false,
				width:'17%',
				height:40,
				cls:'tripdatastyle',
				style: {
				color:fontcolor
				},
				id:'tripdetailsvehicletrip'+i
				},
				{
				xtype: 'label',
				text:vehiclesontripcomm,
				allowBlank: false,
				hidden:false,
				width:'19%',
				height:40,
				cls:'tripdatastyle',
				style: {
				color:fontcolor
				},
				id:'tripdetailsvehicletripnoncomm'+i
				},{
				xtype: 'label',
				text:vehiclearrived,
				allowBlank: false,
				hidden:false,
				width:'16%',
				height:40,
				cls:'tripdatastyle',
				style: {
				color:fontcolor
				},
				id:'tripvehiclearrived'+i
				},{
				xtype: 'label',
				text:employeesontrip,
				allowBlank: false,
				hidden:false,
				width:'16%',
				height:40,
				cls:'tripdatastyle',
				style: {
				color:fontcolor
				},
				id:'tripemployeesontrip'+i
				},{
				xtype: 'label',
				text:employeespickupdrop,
				allowBlank: false,
				hidden:false,
				width:'16%',
				height:40,
				cls:'tripdatastyle',
				style: {
				color:fontcolor
				},
				id:'tripemployeepickupdrop'+i
				}]
		}); // End of Panel		
		Ext.getCmp('dashBoardtripdatatable').add(tripdataPannel);
        Ext.getCmp('dashBoardtripdatatable').doLayout(); 
}
function getTripdata()
{
 var loadMask = new Ext.LoadMask('outerpannelid', {msg:'Loading..'});
		                 	    loadMask.show();								 
								tripDetailsStore.load({
		                 	    			 params:{custID: Ext.getCmp('custmastcomboId').getValue()},
              		          				 callback:function(){
              		          				 TripDataTable.removeAll(true);
              		          				 loadMask.hide();
              		          				 for(var i=0;i<=tripDetailsStore.getCount()-1;i++)
              		          				 {
              		          				 var rec = tripDetailsStore.getAt(i);
              		          				 var shifttime=rec.data['shifttime'];
											 var vehiclesontrip=rec.data['vehiclesontrip'];
											 var vehiclesontripcomm=rec.data['vehiclesontripcomm'];
											 var vehiclesarrived=rec.data['vehiclesarrived'];
											 var employeesontrip=rec.data['employeesontrip'];
											 var employeesonswipe=rec.data['employeesonswipe'];
											 var shiftstatus=rec.data['shiftstatus'];
											 var color="";
											 var fontcolor="";
											 if(shiftstatus=='Y')
											 {
											 color='#FFD413';
											 fontcolor='#000000';
											 }
											 else
											 {
											 color='#22849A';
											 fontcolor='#FFFFFF';
											 }
											 createtripdataPannel(shifttime,vehiclesontrip,vehiclesontripcomm,vehiclesarrived,employeesontrip,employeesonswipe,i,color,fontcolor);
              		          				 }
              		          				 }
              		          				});	

}
function CheckSession() {
                <%LoginInfoBean loginInfosession=(LoginInfoBean)session.getAttribute("loginInfoDetails");
                if (loginInfosession == null) {
					response.sendRedirect(request.getContextPath()+ "/Jsps/Common/SessionDestroy.html");
                }
                %>
            }
//********************************************** Function for playing Alarm Sound when distress count increases********************
function playAlertSound()
{
			var url='<%=audioFilePath%>';
			document.getElementById("alarmsoundspan").innerHTML="<embed src='"+url+"' hidden=true autostart=true loop=false>";
}

//**************************************************  Main starts from here **************************************************
 Ext.onReady(function(){
	ctsb=tsb;
	Ext.QuickTips.init();
	Ext.Ajax.timeout = 360000;
	Ext.form.Field.prototype.msgTarget = 'side';			         	   			
 	outerPanel = new Ext.Panel({
			renderTo : 'content',
			standardSubmit: true,
			frame:false,
			height:screen.height-217,
			cls:'dashboardmainpannel',
			id:'outerpannelid',
			items: [customerMainPanel,{cls:'dashboardspace2'},SecondMainPannel,{cls:'dashboardspace3'},{cls:'dashboardspace4'}]	
			});
			 		                
	});

   
   </script>
  <span id=alarmsoundspan></span>
  </div>
  <jsp:include page="../Common/footer.jsp" />
 <!-- </body>   -->
 <!-- </html> -->
 <script> 
	  if (innerpage == true) {
				var divsToHide = document.getElementsByClassName("footer"); //divsToHide is an array
				
					for(var i = 0; i < divsToHide.length; i++){
						divsToHide[i].style.display = "none"; // depending on what you're doing
						$(".container").css({"margin-top":"-72px"});
					}
	  }
						
	</script>