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

<jsp:include page="../Common/header.jsp" />
	<title></title>
	<style>
	.x-table-layout td {
    vertical-align: inherit !important;
    }
	
  
	
	</style>

	
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
		<style>
			.x-window-tl *.x-window-header {
				padding-top : 6px !important;
			}
			label {
				//display : inline !important;
			}
			#groupPanelid {
				width : 432px !important;
			}
			.x-table-layout-ct {
				width : 432px !important;
			}
			.x-panel-body-noborder .x-form {
				width : 460px !important;
			}
			.ext-strict .x-form-text {
				height: 21px !important;
			}
			input#groupSelectionId {
				margin-left: -66px !important;
			}
			input#vehicleSelectionId {
				margin-left: -52px !important;
			}
			input#startHr {
				margin-left: -30px !important;
			}
			.x-btn-text {
				font-size : 15px !important;
			}
		</style>
    
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
     if (Ext.getCmp('groupSelectionId').getValue() == '' || Ext.getCmp('groupSelectionId').getValue() == '0') {
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
 var date1=Ext.getCmp('startHr').getValue();
 var year1= date1.getFullYear();
 var month1 = date1.getMonth();
     if (Ext.getCmp('clientPanelId').isVisible()) {
      requestParameter = year1 + "|"+ month1 +"|" + clientIdSelected + "|" + selectedVehicles+"|"+reportName;
     } else {
      requestParameter = year1 + "|"+ month1 +"|"+ + <%= clientId %> + "|" + selectedVehicles+"|"+reportName;
     }
     window.open("<%=request.getContextPath()%>/tripWiseHubArrivalAndDepartureExcel?requestParameter="+requestParameter+"");

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
     width: 33
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
     width: 230,
     listWidth: 230,
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
	var vehicleCombo = new Ext.ux.form.LovCombo({
		id:'vehicleSelectionId',	
		store: vehicleStore,
		mode: 'local',
        cls: 'selectstylePerfect',
	    forceSelection: true,
	     resizable: true,
	    emptyText: 'Select Vehicle No',
	    //blankText: '',
	    maxSelections : 10,
	    lazyRender: true,
	    selectOnFocus: true,
	    allowBlank: false,
	    autoload: true,
	    anyMatch: true,
	    typeAhead: false,
	    triggerAction: 'all',
	    valueField: 'vehicleNo',
	    displayField: 'vehicleNo',
	    multiSelect:true,
		beforeBlur: Ext.emptyFn,
   		listeners: {
          select:function(record, index) {     
				var newVeh=[];
				newVeh = Ext.getCmp('vehicleSelectionId').getRawValue().trim().split(',');
			}
	     }
	});
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
     width: 150,
     cls: 'labelstyle'
    }, {
     width: 20
    }, vehicleCombo]
   });


   var startTime = new Ext.Panel({
    layout: 'table',
    layoutConfig: {
     columns: 3
    },
    cls: 'myStyle',
    items: [{
     xtype: 'label',
     text: 'Select Month & Year',
     width: 145,
     cls: 'labelstyle'

    }, {
     width: 20
    }, {
     xtype: 'datefield',
     width: 200,
     format: getMonthYearFormat(),
     plugins: 'monthPickerPlugin',
     emptyText: '<%=SelectDateAndMonth%>',
     allowBlank: false,
     blankText: '<%=SelectDateAndMonth%>',
     id: 'startHr',
     value: prevmonth,
     vtype: 'daterange'
    }]

   });


   <% if (clientId == 0) { %>
   reportFormPanel = new Ext.FormPanel({
    bodyStyle: 'padding:5px 50px 0',
    standardSubmit: true,
    width: 490,
    labelWidth: 130,
    collapsible: false,
    itemCls: 'style1',
    items: [selectClientPanel, {
      width: 300,
      height: 10
     }, groupPanel, {
      width: 300,
      height: 10
     },
     vehicleGridPanel, {
      width: 300,
      height: 10
     },
     startTime
    ]
   });
   <% } else { %>

   reportFormPanel = new Ext.FormPanel({
    bodyStyle: 'padding:5px 50px 0',
    standardSubmit: true,
    width: 490,
    border: false,
    labelWidth: 130,
    collapsible: false,
    itemCls: 'style1',
    items: [groupPanel, {
      width: 300
     }, {
      height: 10
     },
     vehicleGridPanel, {
      width: 300
     }, {
      height: 10
     },
     startTime
    ]
   });
   <% } %>


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
    title: "<%=HubArrivalDepartureReport%>",

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
    <jsp:include page="../Common/footer.jsp" />
 <!-- </body>   -->
 <!-- </html> -->
<%}%>