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
	if(str.length>11){
	loginInfo.setCountryCode(Integer.parseInt(str[11].trim()));
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
	
ArrayList<String> tobeConverted = new ArrayList<String>();

tobeConverted.add("Associated_Geofence");
tobeConverted.add("Direct_Loading");
tobeConverted.add("Assessed_Quantity");
tobeConverted.add("Assessed_Quantity_Metric");

tobeConverted.add("Sand_Block_Status");
tobeConverted.add("Sand_Block_Type");
tobeConverted.add("Environmental_Clearance");
tobeConverted.add("River_Name");

tobeConverted.add("Sand_Block_Address");
tobeConverted.add("Survey_No");
tobeConverted.add("Sand_Block_No");
tobeConverted.add("Sand_Block_Name");

tobeConverted.add("Village");
tobeConverted.add("Gram_Panchayat");
tobeConverted.add("Taluka");
tobeConverted.add("Sub_Division");

tobeConverted.add("Division");
tobeConverted.add("District");
tobeConverted.add("State");
tobeConverted.add("SLNO");

tobeConverted.add("Select_State_Name");
tobeConverted.add("Select_District_Name");
tobeConverted.add("Select_Division_Name");
tobeConverted.add("Select_Sub_Division");

tobeConverted.add("Select_Taluka");
tobeConverted.add("Enter_Gram_Panchayat");
tobeConverted.add("Enter_Village");
tobeConverted.add("Enter_Sand_Block_Name");
tobeConverted.add("Enter_Sand_Block_No");

tobeConverted.add("Enter_Survey_No");
tobeConverted.add("Enter_Sand_Block_Address");
tobeConverted.add("Enter_River_Name");
tobeConverted.add("Enter_Environmental_Clearance");

tobeConverted.add("Enter_Sand_Block_Type");
tobeConverted.add("Enter_Sand_Block_Status");
tobeConverted.add("Enter_Assessed_Quantity_Metric");
tobeConverted.add("Enter_Assessed_Quantity");

tobeConverted.add("Enter_Whether_Direct_Loading_Is_Allowed");
tobeConverted.add("Enter_Associated_Geofence");
tobeConverted.add("Select_Division");
tobeConverted.add("Sand_Block_Management");

tobeConverted.add("No_Records_Found");
tobeConverted.add("Clear_Filter_Data");
tobeConverted.add("Add");
tobeConverted.add("Modify");

tobeConverted.add("Modify_Details");
tobeConverted.add("No_Rows_Selected");
tobeConverted.add("Select_Single_Row");
tobeConverted.add("Sand_Block_Details");

tobeConverted.add("Cancel");
tobeConverted.add("Save");
tobeConverted.add("Select_Environmental_Clearence");
tobeConverted.add("Select_Sand_Block_Type");

tobeConverted.add("Select_Sand_Block_Status");
tobeConverted.add("Select_Direct_Loading");
tobeConverted.add("Select_Assessed_Quantity_Metric");
tobeConverted.add("Select_State");

tobeConverted.add("Select_District");
tobeConverted.add("Select_Geofence");


ArrayList<String> convertedWords = new ArrayList<String>();
convertedWords = cf.getLanguageSpecificWordForKey(tobeConverted,language);

String AssociatedGeofence=convertedWords.get(0);
String DirectLoading=convertedWords.get(1);
String AssessedQuantity=convertedWords.get(2);
String AssessedQuantityMetric=convertedWords.get(3);

String SandBlockStatus=convertedWords.get(4);
String SandBlockType=convertedWords.get(5);
String EnvironmentalClearance=convertedWords.get(6);
String RiverName=convertedWords.get(7);

String SandBlockAddress=convertedWords.get(8);
String SurveyNo=convertedWords.get(9);
String SandBlockNo=convertedWords.get(10);
String SandBlockName=convertedWords.get(11);

String Village=convertedWords.get(12);
String GramPanchayat=convertedWords.get(13);
String Taluka=convertedWords.get(14);
String SubDivision=convertedWords.get(15);

String Division=convertedWords.get(16);
String District=convertedWords.get(17);
String State=convertedWords.get(18);
String SLNO=convertedWords.get(19);

String SelectStateName=convertedWords.get(20);
String SelectDistrictName=convertedWords.get(21);
String SelectDivisionName=convertedWords.get(22);
String SelectSubDivision=convertedWords.get(23);

String SelectTaluka=convertedWords.get(24);
String EnterGramPanchayat=convertedWords.get(25);
String EnterVillage=convertedWords.get(26);
String EnterSandBlockName=convertedWords.get(27);
String EnterSandBlockNo=convertedWords.get(28);
String EnterSurveyNo=convertedWords.get(29);
String EnterSandBlockAddress=convertedWords.get(30);
String EnterRiverName=convertedWords.get(31);
String EnterEnvironmentalClearance=convertedWords.get(32);
String EnterSandBlockType=convertedWords.get(33);
String EnterSandBlockStatus=convertedWords.get(34);
String EnterAssessedQuantityMetric=convertedWords.get(35);
String EnterAssessedQuantity=convertedWords.get(36);
String EnterWhetherDirectLoadingIsAllowed=convertedWords.get(37);
String EnterAssociatedGeofence=convertedWords.get(38);
String SelectDivision=convertedWords.get(39);
String SandBlockManagement=convertedWords.get(40);
String NoRecordsFound=convertedWords.get(41);
String ClearFilterData=convertedWords.get(42);
String Add=convertedWords.get(43);
String Modify=convertedWords.get(44);
String ModifyDetails=convertedWords.get(45);
String NoRowsSelected=convertedWords.get(46);
String SelectSingleRow=convertedWords.get(47);
String SandBlockDetails=convertedWords.get(48);
String Cancel=convertedWords.get(49);
String Save=convertedWords.get(50);
String SelectEnvironmentalClearence=convertedWords.get(51);
String SelectSandBlockType=convertedWords.get(52);
String SelectSandBlockStatus=convertedWords.get(53);
String SelectDirectLoading=convertedWords.get(54);
String SelectAssessedQuantityMetric=convertedWords.get(55);
String SelectState=convertedWords.get(56);
String Selectdistrict=convertedWords.get(57);
String SelectGeofence=convertedWords.get(58);


%>

<!DOCTYPE HTML>
<html>
 <head>
 		<title>AUTO RICKSHAW</title>	
 		  
</head>	    
	 <style>
  .x-panel-tl
	{
		border-bottom: 0px solid !important;
	}
  </style>
  <body>
   <%if (loginInfo.getStyleSheetOverride().equals("Y")){%>
	<jsp:include page="../Common/ImportJSSandMining.jsp"/>
	<%}else{%>
	<jsp:include page="../Common/ImportJS.jsp" /><%}%>
   <jsp:include page="../Common/ExportJS.jsp" />
   <script>
var outerPanel;
var ctsb;
var jspName = "SandBlockManagementReport";
var exportDataType = "int,string,string,string,string";
var selected;
var grid;
var buttonValue;
var titelForInnerPanel;
var myWin;
var beaconIDModify;
var driverNameModify;
var AutoNumberModify;
var custName;

var innerPanelForSandBlockManagement = new Ext.form.FormPanel({
    standardSubmit: true,
    collapsible: false,
    autoScroll: true,
    height: 175,
    width: 450,
    frame: true,
    id: 'innerPanelForSandBlockManagementId',
    layout: 'table',
    layoutConfig: {
        columns: 4
    },
    items: [{
        xtype: 'fieldset',
        title: 'Beacon Driver Association',
        cls: 'fieldsetpanel',
        collapsible: false,
        colspan: 3,
        id: 'sandBlockDetailsId',
        width: 420,
        layout: 'table',
        layoutConfig: {
            columns: 4
        },
        items: [{
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'stateEmptyId1'
        }, {
            xtype: 'label',
            text: 'Beacon Id' + ' :',
            cls: 'labelstyle',
            id: 'stateLabelId'
        }, {
            xtype: 'textfield',
            cls: 'selectstylePerfect',
            allowBlank: false,
            blankText: 'Enter BeaconID',
            emptyText: 'Enter BeaconID',
            labelSeparator: '',
            id: 'BeaconTextId'
        }, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'stateEmptyId2'
        },  {
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'districtEmptyId1'
        },{
            xtype: 'label',
            text: 'Driver Name' + ' :',
            cls: 'labelstyle',
            id: 'districtLabelId'
        }, {
            xtype: 'textfield',
            cls: 'selectstylePerfect',
            allowBlank: false,
            blankText: 'Enter DriverName',
            emptyText: 'Enter DriverName',
            labelSeparator: '',
            id: 'DriverNameTextId'
        }, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'districtEmptyId2'
        }, {
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'subDivisionEmptyId1'
        }, {
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'subDivisionEmptyId1'
        }, {
            xtype: 'label',
            text: 'Auto Rickshaw No' + ' :',
            cls: 'labelstyle',
            id: 'subDivisionLabelId'
        }, {
            xtype: 'textfield',
            cls: 'selectstylePerfect',
            allowBlank: false,
            blankText: 'Enter Auto Number',
            emptyText: 'Enter Auto Number',
            labelSeparator: '',
            id: 'AutoNoTextId'
        }]
    }]
});

var innerWinButtonPanel = new Ext.Panel({
    id: 'innerWinButtonPanelId',
    standardSubmit: true,
    collapsible: false,
    autoHeight: true,
    height: 100,
    width: 450,
    frame: true,
    layout: 'table',
    layoutConfig: {
        columns: 4
    },
    buttons: [{
        xtype: 'button',
        text: '<%=Save%>',
        iconCls:'savebutton',
        id: 'saveButtonId',
        cls: 'buttonstyle',
        width: 70,
        listeners: {
            click: {
                fn: function() {
                    if (Ext.getCmp('BeaconTextId').getValue() == "") {
                        Ext.example.msg("Enter Beacon ID");
                        return;
                    }
                    if (Ext.getCmp('DriverNameTextId').getValue() == "") {
                        Ext.example.msg("Enter Driver Name");
                        return;
                    }
                    if (Ext.getCmp('AutoNoTextId').getValue() == "") {
                        Ext.example.msg("Enter Auto Number");
                        return;
                    }
                 
                     //  if (innerPanelForSandBlockManagement.getForm().isValid()) {
                   // var id;
                    if (buttonValue == 'Modify') {
                        var selected = grid.getSelectionModel().getSelected();
                        //id = selected.get('uniqueIdDataIndex');
                        if (selected.get('BeaconDataIndex') != Ext.getCmp('BeaconTextId').getValue()) {
                            beaconIDModify = Ext.getCmp('BeaconTextId').getValue();
                        } else {
                            beaconIDModify = selected.get('BeaconDataIndex');
                        }
                        
                        if (selected.get('DriverNameDataIndex') != Ext.getCmp('DriverNameTextId').getValue()) {
                            driverNameModify = Ext.getCmp('DriverNameTextId').getValue();
                        } else {
                            driverNameModify = selected.get('DriverNameDataIndex');
                        }
                        
                        if (selected.get('AutoNoDataIndex') != Ext.getCmp('AutoNoTextId').getValue()) {
                            AutoNumberModify = Ext.getCmp('AutoNoTextId').getValue();
                        } else {
                            AutoNumberModify = selected.get('AutoNoDataIndex');
                        }
                                             
                    }
                    sandBlockManagementOuterPanelWindow.getEl().mask();
                    Ext.Ajax.request({
                        url: '<%=request.getContextPath()%>/AutoRickshawAction.do?param=autoRickshawAddAndModify',
                        method: 'POST',
                        params: {
                            buttonValue: buttonValue,
                            beaconID: Ext.getCmp('BeaconTextId').getValue(),
                            driverName: Ext.getCmp('DriverNameTextId').getValue(),
                            AutoNumber: Ext.getCmp('AutoNoTextId').getValue(),
                          
                          //  id: id,
                            beaconIDModify: beaconIDModify,
                            driverNameModify: driverNameModify,
                            AutoNumberModify: AutoNumberModify
                          
                        },
                        success: function(response, options) {
                            var message = response.responseText;
                            Ext.example.msg(message);
                            Ext.getCmp('BeaconTextId').reset();
                            Ext.getCmp('DriverNameTextId').reset();
                            Ext.getCmp('AutoNoTextId').reset();
                            myWin.hide();
                            sandBlockManagementOuterPanelWindow.getEl().unmask();
                            store.load({
                                params: {
                                  //  CustId: Ext.getCmp('custcomboId').getValue(),
                                  //  jspName:jspName,
                        		  //  custName:Ext.getCmp('custcomboId').getRawValue()
                                }
                            });
                            
                        },
                        failure: function() {
                            Ext.example.msg("Error");
                            myWin.hide();
                        }
                    });
                    //  }
                }
            }
        }
    }, {
        xtype: 'button',
        text: '<%=Cancel%>',
        id: 'canButtId',
        cls: 'buttonstyle',
        iconCls: 'cancelbutton',
        width: 70,
        listeners: {
            click: {
                fn: function() {
                    myWin.hide();
                }
            }
        }
    }]
});

var autoRickshawOuterPanelWindow = new Ext.Panel({
    width: 460,
    height: 250,
    standardSubmit: true,
    frame: false,
    items: [innerPanelForSandBlockManagement, innerWinButtonPanel]
});

myWin = new Ext.Window({
    title: titelForInnerPanel,
    closable: false,
    resizable: false,
    modal: true,
    autoScroll: false,
    height: 300,
    width: 460,
    id: 'myWin',
    items: [autoRickshawOuterPanelWindow]
});

function addRecord() {
   
    buttonValue = '<%=Add%>';
    titelForInnerPanel = 'Auto Rickshaw';
    myWin.setPosition(450, 150);
    Ext.getCmp('BeaconTextId').enable();
    Ext.getCmp('DriverNameTextId').enable();
    Ext.getCmp('AutoNoTextId').enable();
   
    myWin.show();
    myWin.setTitle(titelForInnerPanel);
    Ext.getCmp('BeaconTextId').reset();
    Ext.getCmp('DriverNameTextId').reset();
    Ext.getCmp('AutoNoTextId').reset();
      
}

function modifyData() {
  
    if (grid.getSelectionModel().getCount() == 0) {
        Ext.example.msg("<%=NoRowsSelected%>");
        return;
    }
    if (grid.getSelectionModel().getCount() > 1) {
        Ext.example.msg("<%=SelectSingleRow%>");
        return;
    }
    buttonValue = '<%=Modify%>';
    titelForInnerPanel = '<%=ModifyDetails%>';
    myWin.setPosition(450, 150);
    myWin.setTitle(titelForInnerPanel);
    myWin.show();
    var selected = grid.getSelectionModel().getSelected();
    Ext.getCmp('BeaconTextId').setValue(selected.get('BeaconDataIndex'));
    Ext.getCmp('DriverNameTextId').setValue(selected.get('DriverNameDataIndex'));
    Ext.getCmp('AutoNoTextId').setValue(selected.get('AutoNoDataIndex'));
    
   
}

var reader = new Ext.data.JsonReader({
    idProperty: 'autoRickshawid',
    root: 'AutoRickshawRoot',
    totalProperty: 'total',
    fields: [{
        name: 'slnoIndex'
    }, {
        name: 'BeaconDataIndex'
    }, {
        name: 'DriverNameDataIndex'
    }, {
        name: 'AutoNoDataIndex'
    }]
});

var store = new Ext.data.GroupingStore({
    autoLoad: false,
    proxy: new Ext.data.HttpProxy({
        url: '<%=request.getContextPath()%>/AutoRickshawAction.do?param=getAutoRickshawReport',
        method: 'POST'
    }),
    storeId: 'autoId',
    reader: reader
});

var filters = new Ext.ux.grid.GridFilters({
    local: true,
    filters: [{
        type: 'numeric',
        dataIndex: 'slnoIndex'
    }, {
        type: 'string',
        dataIndex: 'BeaconDataIndex'
    }, {
        type: 'string',
        dataIndex: 'DriverNameDataIndex'
    }, {
        type: 'string',
        dataIndex: 'AutoNoDataIndex'
    }]
});

var createColModel = function(finish, start) {
    var columns = [
        new Ext.grid.RowNumberer({
            header: "<span style=font-weight:bold;><%=SLNO%></span>",
            width: 50
        }), {
            dataIndex: 'slnoIndex',
            header: "<span style=font-weight:bold;><%=SLNO%></span>",
            width: 50,
            hidden:true,
            filter: {
                type: 'numeric'
            }
        }, {
            dataIndex: 'BeaconDataIndex',
            header: "<span style=font-weight:bold;>Beacon ID</span>",
            width: 50,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;>Driver Name</span>",
            dataIndex: 'DriverNameDataIndex',
            width: 100,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;>Auto Rickshaw No</span>",
            dataIndex: 'AutoNoDataIndex',
            width: 100,
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
grid = getGrid('Beacon Driver Association', '<%=NoRecordsFound%>', store, screen.width - 40, 420, 5, filters, '<%=ClearFilterData%>', false, '', 16, false, '', false, '', true, 'Excel', jspName, exportDataType, true, 'PDF', true, '<%=Add%>', true, '<%=Modify%>', false, '');
//******************************************************************************************************************************************************
Ext.onReady(function() {
    ctsb = tsb;
    Ext.QuickTips.init();
    Ext.form.Field.prototype.msgTarget = 'side';
    outerPanel = new Ext.Panel({
       
        renderTo: 'content',
        standardSubmit: true,
        frame: true,
        width: screen.width - 22,
        cls: 'outerpanel',
        layout: 'table',
        layoutConfig: {
            columns: 1
        },
        items: [grid]
    });
    sb = Ext.getCmp('form-statusbar');
});
</script>
</body>
</html>
    
    
    
    
    

