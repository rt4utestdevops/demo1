<%@ page  language="java" import="java.util.*,t4u.functions.CommonFunctions,t4u.beans.*,t4u.common.*,t4u.functions.CashVanManagementFunctions" pageEncoding="utf-8"%>
<%@ taglib uri="http://packtag.sf.net" prefix="pack"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
if (request.getParameter("list") != null) {
		String list = request.getParameter("list").toString().trim();
		String[] str = list.split(",");
		int systemid = Integer.parseInt(str[0].trim());
		int clientId = Integer.parseInt(str[1].trim());
		int userid = Integer.parseInt(str[2].trim());
		String language = str[3].trim();
		LoginInfoBean loginInfo = new LoginInfoBean();
		loginInfo.setSystemId(systemid);
		loginInfo.setCustomerId(clientId);
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
		session.setAttribute("loginInfoDetails", loginInfo);
	}
	CommonFunctions cf = new CommonFunctions();
	LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
	if (loginInfo == null) {
		response.sendRedirect(request.getContextPath()+ "/Jsps/Common/SessionDestroy.html");
	} else {
		session.setAttribute("loginInfoDetails", loginInfo);
		String language = loginInfo.getLanguage();
		int systemId = loginInfo.getSystemId();
		int clientId = loginInfo.getCustomerId();
		
		
String HubArrivalDepartureReport = "TripWise Hub Arrival Departure Report";
String SelectClient = "Select Client";
String SelectGroup = "Select Group";
String SelectVehicles = "Select Vehicles";
String generateReport = "Generate Report";
String SelectDateAndMonth = "Select Date And Month";
		
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
	<head>
	<title></title>
	
	<style>
	.x-table-layout td {
    vertical-align: inherit !important;
    }
  
	
	</style>
    <link rel="stylesheet" href="https://ajax.googleapis.com/ajax/libs/jqueryui/1.11.1/themes/ui-darkness/jquery-ui.min.css" rel="stylesheet">
     <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script>
     
     
     <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-slider/10.0.0/css/bootstrap-slider.css" rel="stylesheet" />
     <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-slider/10.0.0/css/bootstrap-slider.min.css" rel="stylesheet" />
      <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-slider/10.0.0/bootstrap-slider.js"></script>
      <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-slider/10.0.0/bootstrap-slider.min.js"></script>
	</head>
	<body>
		<%if (loginInfo.getStyleSheetOverride().equals("Y")){%>                  
        <jsp:include page="../Common/ImportJSSandMining.jsp" />                                                    
        <%}else {%>  
        <jsp:include page="../Common/ImportJS.jsp" /><%} %>
        <jsp:include page="../Common/ExportJS.jsp" />
        
        <pack:style src="../../Main/resources/css/LovCombo/Ext.ux.form.LovCombo.css"></pack:style>
	  	<pack:style src="../../Main/resources/css/LovCombo/empty.css"></pack:style>
	  	<pack:style src="../../Main/resources/css/LovCombo/lovcombo.css"></pack:style>
	  	<pack:script src="../../Main/Js/LovCombo/Ext.ux.form.LovCombo.js"></pack:script>
	  	<pack:script src="../../Main/Js/LovCombo/Ext.ux.ThemeCombo.js"></pack:script>
    
        <script>
    var vehicleGrid;
    var prevmonth = new Date().add(Date.MONTH, -1);
    var reportName = "Tripwise Hub Arrival And Departure Report"
    function getMonthYearFormat() {
     return 'F Y';
    }

    function getReportData() {

     var clientIdSelected = 0;
     if (Ext.getCmp('clientSelectionId').isVisible()) {
      if (Ext.getCmp('clientSelectionId').getValue() == '' || Ext.getCmp('clientSelectionId').getValue() == 'Select Client' || Ext.getCmp('clientSelectionId').getValue() == -1) {
       showAlertMessage("Please Select a Client.");
       return;
      } else {
       clientIdSelected = Ext.getCmp('clientSelectionId').getValue();
      }
     }
     if (Ext.getCmp('groupSelectionId').getValue() == '' ) {
      showAlertMessage("Please Select a Group.");
      return;
     }
     var selectedVehicles = "";

     if (Ext.getCmp('vehicleSelectionId').getValue() == '' || Ext.getCmp('vehicleSelectionId').getValue() == '0') {
      showAlertMessage("Please Select Atleast One Vehicle.");
      return;
     } else {
      selectedVehicles = Ext.getCmp('vehicleSelectionId').getValue();
     }
    


     var requestParameter = "";
 var date1=Ext.getCmp('startHr').getValue().format('Y-m-d H:i:s');
var date2=Ext.getCmp('endHr').getValue().format('Y-m-d H:i:s');
 var newStartDate = date1;
	var newEndDate = date2;
	var dd = newStartDate.split("-");
    var ed = newEndDate.split("-");
    var parsedStartDate = new Date(dd[1] + "/" + dd[0] + "/" + dd[2]);
    var parsedEndDate = new Date(ed[1] + "/" + ed[0] + "/" + ed[2]);
    if (parsedStartDate > parsedEndDate) {
		   	showAlertMessage("End date should be greater than Start date");
		  //document.getElementById("dateInput2").value = currentDate;
    	    return;
	}
    
     if (Ext.getCmp('clientPanelId').isVisible()) {
      requestParameter =   date1 +"^"+date2 +"^" + clientIdSelected + "^" + selectedVehicles+"^"+reportName;
      var clientId1 = clientIdSelected;
     } else {
      requestParameter =  date1 +"^"+date2 +"^" + <%= clientId %> + "^" + selectedVehicles+"^"+reportName;
      var clientId1 = <%= clientId %>;
     }
     
     var param = {
        date1: date1,
        date2: date2,
        regNo: selectedVehicles,
        clientId: clientId1
        }
     	
	$.ajax({
        url: '<%=request.getContextPath()%>/CommonAction.do?param=checkForDataAvailability',
        	data: param,
          success: function(result) {
       //   alert(result);
         if (result == "Records Found") {
              window.open("<%=request.getContextPath()%>/DoorSensorAnalysisExcelServlet?date1="+date1+"&date2="+date2+"&clientId="+clientId1+"&regNo="+selectedVehicles+"&reportName="+reportName);
         
         }else{
          showAlertMessage(result);
         }
          }
          });
     
    }

    function showAlertMessage(message) {
     Ext.MessageBox.show({
      msg: message,
      buttons: Ext.MessageBox.OK
     });
     return;
    }
</script>
<script>
  var vehicleStore;


  Ext.onReady(function() {

   var reportFormPanel = "";
   Ext.QuickTips.init();
   Ext.form.Field.prototype.msgTarget = 'side';


   var clientStore;

   clientStore = new Ext.data.JsonStore({
    url: '<%=request.getContextPath()%>/hubArrivalDep.do?param=getclients',
    root: 'clientRoot',
    autoLoad: true,
    fields: ['clientId', 'clientName']
   });

   vehicleStore = new Ext.data.JsonStore({
    url: '<%=request.getContextPath()%>/hubArrivalDep.do?param=getvehilcesforclients',
    root: 'clientVehicles',
    autoLoad: false,
    fields: ['vehicleNo']
   });

   var groupNameStore = new Ext.data.JsonStore({
    url: '<%=request.getContextPath()%>/hubArrivalDep.do?param=getGroupForClient',
    root: 'GroupStoreList',
    autoLoad: false,
    fields: ['groupId', 'groupName']
   });

   <% if (clientId != 0) { %>
   groupNameStore.load({
    params: {
     globalClientId: <%=clientId%>
    }
   });
   <% } %>

   var selectClientPanel = new Ext.Panel({
    layout: 'table',
    layoutConfig: {
     columns: 3
    },
    id: 'clientPanelId',
    items: [{
     xtype: 'label',
     text: '<%=SelectClient%>',
     width: 138,
     cls: 'labelstyle'
    }, {
     width: 35
    }, {
     xtype: 'combo',
     mode: 'local',
     value: '',
     displayField: 'clientName',
     valueField: 'clientId',
     enableKeyEvents: true,
     triggerAction: 'all',
     emptyText: '<%=SelectClient%>',
     selectOnFocus: true,
     id: 'clientSelectionId',
     width: 230,
     cls: 'myStyle1',
     store: clientStore,
     listeners: {
      select: {
       fn: function() {
        var clientId = Ext.getCmp('clientSelectionId').getValue();

        groupNameStore.load({
         params: {
          globalClientId: clientId
         }
        });

       }
      }
     }
    }]
   });




   var groupPanel = new Ext.Panel({
    layout: 'table',
    layoutConfig: {
     columns: 3
    },
    id: 'groupPanelid',

    items: [{
     xtype: 'label',
     text: '<%=SelectGroup%>',
     width: 138,
     cls: 'labelstyle'
    }, {
     width: 35
    }, {
     xtype: 'combo',
     mode: 'local',
     value: '',
     displayField: 'groupName',
     valueField: 'groupId',
     enableKeyEvents: true,
     resizable: true,
     triggerAction: 'all',
     emptyText: '<%=SelectGroup%>',
     selectOnFocus: true,
     id: 'groupSelectionId',
     width: 155,
     listWidth: 155,
     cls: 'myStyle1',
     store: groupNameStore,
     listeners: {
      select: {
       fn: function() {
        var globalgroup = Ext.getCmp('groupSelectionId').getValue();
        var clientId = "";
        if (<%= clientId %> > 0) {
         clientId = '<%=clientId%>';
        } else {
         clientId = Ext.getCmp('clientSelectionId').getValue();
        }
        vehicleStore.load({
         params: {
          clientId: clientId,
          group: globalgroup
         }
        });
       }
      }
     }
    }]
   });

   groupNameStore.on('load', function() {

    var rec = groupNameStore.getAt(0);
    Ext.getCmp('groupSelectionId').setValue(rec.data['groupId']);

    var clientId = "";
    if (<%= clientId %> > 0) {
     clientId = '<%=clientId%>';
    } else {
     clientId = Ext.getCmp('clientSelectionId').getValue();
    }
    vehicleStore.load({
     params: {
      clientId: clientId,
      group: Ext.getCmp('groupSelectionId').getValue()
     }
    });


   });
	var count=0;
	
	Ext.override(Ext.ux.form.LovCombo, {
		beforeBlur: Ext.emptyFn
	});

<!--   var vehicleGrid = new Ext.ux.form.LovCombo({-->
<!--    id: 'vehicleSelectionId',-->
<!--    width: 230,-->
<!--    hideOnSelect: false,-->
<!--    store: vehicleStore,-->
<!--    emptyText: 'Select Vehicles',-->
<!--    triggerAction: 'all',-->
<!--    valueField: 'vehicleNo',-->
<!--    displayField: 'vehicleNo',-->
<!--    mode: 'local'-->
<!--   });-->


   var vehicleGridPanel = new Ext.Panel({
    layout: 'table',
    layoutConfig: {
     columns: 3
    },
    id: 'vehicleGridPanelId',

    items: [{
     xtype: 'label',
     text: '<%=SelectVehicles%>',
     width: 155,
     cls: 'labelstyle'
    }, {
     width: 20
    }, {
     xtype: 'combo',
     mode: 'local',
     value: '',
     displayField: 'vehicleNo',
     valueField: 'vehicleNo',
     enableKeyEvents: true,
     resizable: true,
     triggerAction: 'all',
     emptyText: '<%=SelectVehicles%>',
     selectOnFocus: true,
     id: 'vehicleSelectionId',
     width: 155,
     listWidth: 155,
     cls: 'myStyle1',
     store: vehicleStore
    }]
   });


   var startTime = new Ext.Panel({
    layout: 'table',
    layoutConfig: {
     columns: 3
    },
    cls: 'myStyle',
    items: [{
     xtype: 'label',
     text: 'Start Date ',
     width: 160,
     cls: 'labelstyle'

    }, {
     width: 52
    }, {
     xtype: 'datefield',
     width: 155,
     format: 'd/m/Y H:i:s',
     emptyText: 'Satrt Date ',
     allowBlank: false,
     blankText: 'Start Date ',
     id: 'startHr',
     value: new Date().format('d/m/Y H:i:s'),
     vtype: 'daterange'
    }]

   });

var endTime = new Ext.Panel({
    layout: 'table',
    layoutConfig: {
     columns: 3
    },
    cls: 'myStyle',
    items: [ {
     xtype: 'label',
     text: 'End Date ',
     width: 160,
     cls: 'labelstyle'
    }, {
     width: 55
    },  {
     xtype: 'datefield',
     width: 155,
     format: 'd/m/Y H:i:s',
     emptyText: 'End Date ',
     allowBlank: false,
     blankText: 'End Date ',
     id: 'endHr',
     value: new Date().format('d/m/Y H:i:s'),
     vtype: 'daterange'
    }]

   });



  
   reportFormPanel = new Ext.FormPanel({
    bodyStyle: 'padding:5px 50px 0',
    standardSubmit: true,
    width: 490,
    labelWidth: 130,
    collapsible: false,
    itemCls: 'style1',
    items: [groupPanel, {
      width: 300,
      height: 10
     },
     vehicleGridPanel, {
      width: 300,
      height: 10
     },
     startTime,
     {
      width: 300,
      height: 10
     },
     endTime
    ]
   });
 


   var p2 = new Ext.Panel({

    frame: false,

    layout: 'anchor',
    bodyStyle: {
     paddingLeft: '200px'

    },
    items: [{
     xtype: 'button',
     id: 'button1',
     text: '<%=generateReport%>',
     width: 80,
     cls: 'buttonStyle',
     listeners: {
      click: {
       fn: function() {
         getReportData();
        } 
      } 
     } 
    }]
   });

   var p1 = new Ext.Panel({
    title: " Door Sensor Analysis Report",

    frame: true,
    width: 500,
    layout: 'table',
    layoutConfig: {
     columns: 1
    },
    items: [reportFormPanel, {
     height: 10
    }, p2]
   });

   var p = new Ext.Panel({
    renderTo: 'content',
    standardSubmit: true,
    frame: false,
    border: false,
    cls: 'outerpanel',
    layout: 'anchor',
    bodyStyle: {
     paddingLeft: '400px'
    },
    height: 600,
    items: [p1]
   });

  });
   </script> 
   </body> 
   </html>
<%}%>