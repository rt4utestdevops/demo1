<%@ page  language="java" import="java.util.*,t4u.functions.*,t4u.beans.*,t4u.common.*" pageEncoding="utf-8"%>
    <%@ taglib uri="http://packtag.sf.net" prefix="pack" %>
    <%@ taglib uri="http://struts.apache.org/tags-html" prefix="html"%> 
        <%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://"+ request.getServerName() + ":" + request.getServerPort()+ path + "/";
LoginInfoBean loginInfo=new LoginInfoBean();
loginInfo.setSystemId(12);
loginInfo.setUserId(1);
loginInfo.setLanguage("en");
loginInfo.setZone("A");
loginInfo.setOffsetMinutes(330);
loginInfo.setCategory("India");
loginInfo.setCategoryType("South India");
loginInfo.setSystemName("T4U");
loginInfo.setCustomerId(0);
loginInfo.setUserName("t4uaccounts");
if(loginInfo==null){
	response.sendRedirect(request.getContextPath()+ "/Jsps/Common/SessionDestroy.html");
}
else
{
	session.setAttribute("loginInfoDetails",loginInfo);	
	String language="en";
	
	CommonFunctions cf = new CommonFunctions();
	cf.checkLoginInfo((LoginInfoBean) session.getAttribute("loginInfoDetails"), session, request, response);
	String responseaftersubmit="''";
	String feature="1";
	if(session.getAttribute("responseaftersubmit")!=null){
	   responseaftersubmit="'"+session.getAttribute("responseaftersubmit").toString()+"'";
		session.setAttribute("responseaftersubmit",null);
	}
String SelectCustomer="Select Customer"; 
String CustomerName="Customer Name";
String SelectLTSP="Select Ltsp Name";
String LTSPName="Ltsp Name";
String NoRecordsFound = "No Record Found";
String ClearFilterData = "Clear Filter Data";
String Add = "Add";
String SLNO = "SLNO";
String AddDetails = "Add Subscription Payment Details";
String Save = "Save";
String Cancel = "Cancle";

%>
<!DOCTYPE HTML>
<head>
		
		<base href="<%=basePath%>">
		<title>TP Owner Updation</title>
</head>
<style>
   .x-panel-tl {
       border-bottom: 0px solid !important;
   }
</style>
<style>
.x-form-text,.x-form-textarea,.x-combo-list{
	 direction: ltr;
}
</style>
<body>

<pack:script src="../../Main/adapter/ext/ext-base.js"></pack:script>
<pack:script src="../../Main/Js/ext-all-debug.js"></pack:script>
<pack:script src="../../Main/Js/T4UStatusBar.js"></pack:script>
<pack:script src="../../Main/Js/MsgBox.js"></pack:script>
<pack:script src="../../Main/Js/Common.js"></pack:script>
<pack:script src="../../Main/Js/cancelbackspace.js"></pack:script>
<pack:script src="../../Main/resources/ux/statusbar/StatusBar.js"></pack:script>
<pack:script src="../../Main/resources/ux/statusbar/ValidationStatus.js"></pack:script>
<pack:script src="../../Main/resources/ux/fileuploadfield/FileUploadField.js"></pack:script>
<!-- for grid -->
<pack:script src="../../Main/resources/ux/gridfilters/menu/RangeMenu.js"></pack:script>
<pack:script src="../../Main/resources/ux/gridfilters/menu/ListMenu.js"></pack:script>
<pack:script src="../../Main/resources/ux/gridfilters/GridFilters.js"></pack:script>
<pack:script src="../../Main/resources/ux/gridfilters/filter/Filter.js"></pack:script>
<pack:script src="../../Main/resources/ux/gridfilters/filter/StringFilter.js"></pack:script>
<pack:script src="../../Main/resources/ux/gridfilters/filter/DateFilter.js"></pack:script>
<pack:script src="../../Main/resources/ux/gridfilters/filter/ListFilter.js"></pack:script>
<pack:script src="../../Main/resources/ux/gridfilters/filter/NumericFilter.js"></pack:script>
<pack:script src="../../Main/resources/ux/gridfilters/filter/BooleanFilter.js"></pack:script>
<pack:style src="../../Main/resources/css/ext-all.css" />
<pack:style src="../../Main/resources/css/chooser.css" />
<pack:style src="../../Main/resources/css/xtheme-DeepBlue.css" />
<pack:style src="../../Main/modules/sandMining/theme/css/component.css" />
<pack:style src="../../Main/resources/css/dashboard.css" />
<pack:style src="../../Main/modules/sandMining/theme/css/EXTJSExtn.css" />
<pack:style src="../../Main/resources/css/commonnew.css" />
<pack:style src="../../Main/iconCls/icons.css" />
<pack:style src="../../Main/resources/ux/statusbar/css/statusbar.css" />
<!-- for grid -->
<pack:style src="../../Main/resources/ux/gridfilters/css/GridFilters.css" />
<pack:style src="../../Main/resources/ux/gridfilters/css/RangeMenu.css" />
<pack:script src="../../Main/Js/examples1.js"></pack:script>
<pack:style src="../../Main/resources/css/examples1.css" />
<pack:script src="../../Main/Js/jquery.min.js"></pack:script>
<pack:script src="../../Main/Js/jquery-ui.js"></pack:script>	
<pack:script src="../../Main/Js/MonthPickerPlugin.js"></pack:script>


<!-- for exporting to excel***** -->
<jsp:include page="../Common/ExportJS.jsp" />
<script>
document.documentElement.setAttribute("dir", "ltr");
function getwindow(jsp){
window.location=jsp;
 }
</script>
  <table id="tableID" style="width:100%;height:99%;background-color:#FFFFFF;margin-top: 0;overflow:hidden" align="center">
  <tr valign="top" height="99%">
  <td height="99%" id="content">
  </td>
  </tr>
</table>
              
               
 <script>

	var outerPanel;
	var ctsb;
	var exportDataType = "int,int,string,string,string,string,string";
	var jspName ="TP Owner Updation";	
	var buttonValue;
	var unitResponseImportData;
	var start_time ;
	var titelForInnerPanel;
	var curdate=datecur;
	
	var sm = new Ext.grid.CheckboxSelectionModel({});
	
	function isValid(amount) {
    	var pattern = new RegExp('^[0-9]+$');
    	return pattern.test(amount);
	}
 var ltspNameStore = new Ext.data.JsonStore({
        url: '<%=request.getContextPath()%>/LTSP_Subscription_Payment_Action.do?param=getLTSPNames',
        id: 'ltspNameStoreId',
        root: 'ltspNameList',
        autoLoad: true,
        remoteSort: true,
        fields: ['Systemid', 'SystemName']
    });
	
	 var selectLtspDropDown = new Ext.form.ComboBox({
        store: ltspNameStore,
        displayField: 'SystemName',
        valueField: 'Systemid',
        typeAhead: false,
        id: 'selectLtspDropDownID',
        cls: 'selectstylePerfect',
        mode: 'local',
        width: 180,
        triggerAction: 'all',
        emptyText: 'Select LTSP',
        selectOnFocus: true,
        listeners: {
            select: {
                fn: function () {
				
					var pagesystemId = Ext.getCmp('selectLtspDropDownID').getValue();                    
                    clientNameStore.reload({
                        params: {
                            systemid: pagesystemId
                        }
                    });
                }
            }
        }
    });
	
	 var clientNameStore = new Ext.data.JsonStore({
        url: '<%=request.getContextPath()%>/LTSP_Subscription_Payment_Action.do?param=getClientNameswrtSystem',
        root: 'clientNameList',
        autoLoad: false,
        fields: ['clientid', 'clientname']
    });

    var clientNameSelect = new Ext.form.ComboBox({
        fieldLabel: '',
        standardSubmit: true,
        width: 180,
        selectOnFocus: true,
        cls: 'selectstylePerfect',
        forceSelection: true,
        anyMatch: true,
        OnTypeAhead: true,
        store: clientNameStore,
        displayField: 'clientname',
        valueField: 'clientid',
        mode: 'local',
        emptyText: 'Select Client',
        triggerAction: 'all',
        labelSeparator: '',
        id: 'clientId',
        value: "",
        minChars: 2,
        listeners: {
            select: {
                fn: function () {
                  
                } // END OF FUNCTION
            } // END OF SELECT
        } // END OF LISTENERS		
    });
  var innerPanelForUnitDetails = new Ext.form.FormPanel({
    standardSubmit: true,
    collapsible: false,
    autoScroll: true, 
    width: screen.width - 12,
    height:40,
    frame: false,
    id: 'custMaster',
    layout: 'table',
    layoutConfig: {
        columns: 10
    },
     items: [
            {width:40},
            {
                xtype: 'label',
                text: 'Select LTSP :',
                cls: 'labelstyle',
                id: 'UnitNoid'
            },  selectLtspDropDown,{width:40},
            {
                xtype: 'label',
                text: 'Select Client :',
                cls: 'labelstyle',
                id: 'labelclintId'
            },	clientNameSelect,{width:40},
            {	
            	xtype:'button',
				text: 'View',
				width:70,
				listeners: {
				click: {fn:function(){
				
				if(Ext.getCmp('selectLtspDropDownID').getValue()=="")
                       {
                             Ext.example.msg("Select LTSP");
                             return;
                       }
                 
				if(Ext.getCmp('clientId').getValue()=="")
                       {
                             Ext.example.msg("Select Client Name");
                             return;
                       }
                       
                store.load({
                params: {
                    systemId:Ext.getCmp('selectLtspDropDownID').getValue(),
                    custID:Ext.getCmp('clientId').getValue(),
                    jspName : jspName,
                    systemName:Ext.getCmp('selectLtspDropDownID').getRawValue(),
                    custName:Ext.getCmp('clientId').getRawValue()
                }
            });
                       	   
        			   }
        			}
        		}
        	}
        ]
});   

function modifyData()
{

	if(Ext.getCmp('selectLtspDropDownID').getValue()=="")
	   {
	         Ext.example.msg("Select LTSP");
	         return;
	   }
	             
	if(Ext.getCmp('clientId').getValue()=="")
	   {
	         Ext.example.msg("Select Client Name");
	         return;
	   }

	if (grid.getSelectionModel().getCount() == 0) {
           Ext.example.msg("No row selected");
           return;
       }
     if (grid.getSelectionModel().getCount() > 1) {
          Ext.example.msg("Select single row");
           return;
       }
     buttonValue = 'Unblock';  
     var json = '';
     var selected = grid.getSelectionModel().getSelected();
     var tpId = selected.get('tpownerIDindex');
     var status = selected.get('tpstatusindex');
    if( status == 'Unblock'){
     	   Ext.example.msg("TP Owner Is Already In Unblock Status");
           return;
    }
    Ext.MessageBox.confirm('Confirm', "Are You Sure Want To Unblock The TP Owner. Continue...?", function(btn) {
    	if (btn == 'yes') {
    	importPanelWindow.getEl().mask();
    	Ext.Ajax.request({
	             url: '<%=request.getContextPath()%>/LTSP_Subscription_Payment_Action.do?param=activeOrInactiveTpOwnerStatus',
	             method: 'POST',
	             params: { 
	             	 tpownerId: tpId,
	             	 sysId:Ext.getCmp('selectLtspDropDownID').getValue(),
	              	 CustId: Ext.getCmp('clientId').getValue(), 
	                 buttonValue:buttonValue
	             },
	             success: function(response, options){             
                     var message = response.responseText;
                     Ext.example.msg(message);
                     json = '';
                     store.reload();
                     importPanelWindow.getEl().unmask();
	              }, 
	              failure: function(){
	                     store.reload();
                         importPanelWindow.getEl().unmask();
                         json = '';
	                 } // END OF FAILURE 
	         });
         }
    });
}  

function deleteData()
{

	if(Ext.getCmp('selectLtspDropDownID').getValue()=="")
	   {
	         Ext.example.msg("Select LTSP");
	         return;
	   }
	             
	if(Ext.getCmp('clientId').getValue()=="")
	   {
	         Ext.example.msg("Select Client Name");
	         return;
	   }

	if (grid.getSelectionModel().getCount() == 0) {
           Ext.example.msg("No row selected");
           return;
       }
     if (grid.getSelectionModel().getCount() > 1) {
          Ext.example.msg("Select single row");
           return;
       }
     buttonValue = 'Inactive';  
     var json = '';
     var selected = grid.getSelectionModel().getSelected();
     var tpId = selected.get('tpownerIDindex');
     var status = selected.get('tpstatusindex');
    if( status == 'Inactive'){
     	   Ext.example.msg("TP Owner Is Already In Inactive Status");
           return;
    }
    Ext.MessageBox.confirm('Confirm', "Are You Sure Want To Inactive The TP Owner. Continue...?", function(btn) {
    	if (btn == 'yes') {
    	importPanelWindow.getEl().mask();
    	Ext.Ajax.request({
	             url: '<%=request.getContextPath()%>/LTSP_Subscription_Payment_Action.do?param=activeOrInactiveTpOwnerStatus',
	             method: 'POST',
	             params: { 
	             	 tpownerId: tpId,
	             	 sysId:Ext.getCmp('selectLtspDropDownID').getValue(),
	              	 CustId: Ext.getCmp('clientId').getValue(), 
	                 buttonValue:buttonValue
	             },
	             success: function(response, options){             
                     var message = response.responseText;
                     Ext.example.msg(message);
                     json = '';
                     store.reload();
                     importPanelWindow.getEl().unmask();
	              }, 
	              failure: function(){
	                     store.reload();
                         importPanelWindow.getEl().unmask();
                         json = '';
	                 } // END OF FAILURE 
	         });
         }
    });
}



   
 var reader = new Ext.data.JsonReader({
    idProperty: 'sandBlockid',
    root: 'tpOwnerAssetroot',
    totalProperty: 'total',
    fields: [{
        name: 'slnoIndex'
    }, {
    	name: 'tpownerIDindex'
    },{
        name: 'tpownerindex'
    }, {
        name: 'vehiclenoindex'
    }, {
    	name: 'locationindex'
    }, {
        name: 'communicationindex'
    }, {
        name: 'tpstatusindex'
    }]
});

var store = new Ext.data.GroupingStore({
    autoLoad: false,
    proxy: new Ext.data.HttpProxy({
        url: '<%=request.getContextPath()%>/LTSP_Subscription_Payment_Action.do?param=getTPOwnerAssetDetails',
        method: 'POST'
    }),
    storeId: 'sandId',
    reader: reader
});   
    
var filters = new Ext.ux.grid.GridFilters({
    local: true,
    filters: [{
        type: 'numeric',
        dataIndex: 'slnoIndex'
    }, {
    	type: 'numeric',
    	dataIndex: 'tpownerIDindex'
    },{
        type: 'string',
        dataIndex: 'tpownerindex'
    }, {
        type: 'string',
        dataIndex: 'vehiclenoindex'
    }, {
    	type: 'string',
    	dataIndex: 'locationindex'
    }, {
        type: 'string',
        dataIndex: 'communicationindex'
    }, {
        type: 'string',
        dataIndex: 'tpstatusindex'
    }]
});    
   
     
var createColModel = function(finish, start) {
    var columns = [
        new Ext.grid.RowNumberer({
            header: "<span style=font-weight:bold;><%=SLNO%></span>",
            width: 50
        }), {
            dataIndex: 'slnoIndex',
            hidden: true,
            header: "<span style=font-weight:bold;><%=SLNO%></span>",
            filter: {
                type: 'numeric'
            }
        },{
            dataIndex: 'tpownerIDindex',
            hidden: true,
            header: "<span style=font-weight:bold;>TP ID</span>",
           	filter: {
                type: 'numeric'
            }
        },{
            dataIndex: 'tpownerindex',
            header: "<span style=font-weight:bold;>TP Owner</span>",
           filter: {
                type: 'string'
            }
        }, {
            dataIndex: 'vehiclenoindex',
            header: "<span style=font-weight:bold;>Vehicle No</span>",
           filter: {
                type: 'string'
            }
        }, {
            dataIndex: 'locationindex',
            header: "<span style=font-weight:bold;>Location</span>",
           filter: {
                type: 'string'
            }
        },{
            dataIndex: 'communicationindex',
            header: "<span style=font-weight:bold;>Communication Status</span>",
           filter: {
                type: 'string'
            }
        }, {
            dataIndex: 'tpstatusindex',
            header: "<span style=font-weight:bold;>MDP Issuing Status</span>",
           filter: {
                type: 'string'
            }
        }
    ];
    return new Ext.grid.ColumnModel({
        columns: columns.slice(start || 0, finish),
        defaults: {
            sortable: true
        }
    });
}; 
    
//*****************************************************************Grid *******************************************************************************
var grid = getGrid('', '<%=NoRecordsFound%>', store, screen.width - 60, 420, 20, filters, '<%=ClearFilterData%>', false, '', 16, false, '', false, '', true, 'Excel', jspName, exportDataType, false, 'PDF', false, '<%=Add%>', true, 'Unblock', false, 'Inactive');    
    
 var importPanelWindow = new Ext.Panel({
    cls: 'outerpanelwindow',
    frame: true,
    layout: 'column',
    //width: screen.width - 50,
    height:500,
    layoutConfig: {
        columns: 1
    },
    items: [innerPanelForUnitDetails,grid]
});  
    
 Ext.onReady(function () {
    ctsb = tsb;
    Ext.QuickTips.init();
    Ext.Ajax.timeout = 720000;
    Ext.form.Field.prototype.msgTarget = 'side';
    outerPanel = new Ext.Panel({
        title: 'TP Owner Setting',
        renderTo: 'content',
        standardSubmit: true,
        autoScroll: false,
        frame: true,
        border: false,
        width : screen.width-50,
        layout: 'table',
        height:550,
        cls: 'outerpanel',
        items: [importPanelWindow]      
    });
});   
</script>   
</body>
</html>
<%}%>