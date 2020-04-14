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
	loginInfo.setCountryCode(Integer.parseInt(str[11].trim()));
	session.setAttribute("loginInfoDetails",loginInfo);
	
}
	
	CommonFunctions cf = new CommonFunctions();
	LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
	cf.checkLoginInfo((LoginInfoBean) session.getAttribute("loginInfoDetails"), session, request, response);
	String responseaftersubmit="''";
	String feature="1";
	if (loginInfo == null) {
		response.sendRedirect(request.getContextPath()
				+ "/Jsps/Common/SessionDestroy.html");
	} else {
		session.setAttribute("loginInfoDetails", loginInfo);
		String language = loginInfo.getLanguage();
		int systemId = loginInfo.getSystemId();
		int customerId = loginInfo.getCustomerId();

ArrayList<String> tobeConverted = new ArrayList<String>();
tobeConverted.add("Add");
tobeConverted.add("Modify");
tobeConverted.add("Customer_Name");
tobeConverted.add("Select_Customer_Name");
tobeConverted.add("No_Records_Found");
tobeConverted.add("Clear_Filter_Data");
tobeConverted.add("SLNO");
tobeConverted.add("Id");
tobeConverted.add("Excel");
tobeConverted.add("Delete");
tobeConverted.add("No_Rows_Selected");
tobeConverted.add("Select_Single_Row");
tobeConverted.add("Save");
tobeConverted.add("Cancel");
tobeConverted.add("TC_No");
tobeConverted.add("Permit_No");
tobeConverted.add("Type");
tobeConverted.add("Select_TC_Number");
tobeConverted.add("Select_Type");
tobeConverted.add("Entered_Date_Time");
tobeConverted.add("Weigh_Bridge_Source");
tobeConverted.add("Weigh_Bridge_Destination");
tobeConverted.add("Select_Weigh_Bridge_Source");
tobeConverted.add("Select_Weigh_Bridge_Destination");
tobeConverted.add("Trip_Sheet_User_Settings");
tobeConverted.add("Select_Permit_No");
tobeConverted.add("Add_User_Setting_Details");
tobeConverted.add("Organization_Trader_Code");
tobeConverted.add("Select_Organisation_Trader_Code");

ArrayList<String> convertedWords = new ArrayList<String>();
convertedWords = cf.getLanguageSpecificWordForKey(tobeConverted,language);

String Add=convertedWords.get(0);
String Modify=convertedWords.get(1);
String CustomerName=convertedWords.get(2);
String SelectCustomerName=convertedWords.get(3);
String NoRecordsFound=convertedWords.get(4);
String ClearFilterData=convertedWords.get(5);
String SLNO=convertedWords.get(6);
String ID=convertedWords.get(7);
String Excel=convertedWords.get(8);
String Delete=convertedWords.get(9);
String NoRowsSelected=convertedWords.get(10);
String SelectSingleRow=convertedWords.get(11);
String Save=convertedWords.get(12);
String Cancel=convertedWords.get(13);
String TC_No=convertedWords.get(14);
String Permit_No=convertedWords.get(15);
String Type=convertedWords.get(16);
String Select_TC_Number=convertedWords.get(17);
String Select_Type=convertedWords.get(18);
String Entered_Date_Time=convertedWords.get(19);
String Weigh_Bridge_Source=convertedWords.get(20);
String Weigh_Bridge_Destination=convertedWords.get(21);
String Select_Weigh_Bridge_Source=convertedWords.get(22);
String Select_Weigh_Bridge_Destination=convertedWords.get(23);
String Tripsheet_User_Settings=convertedWords.get(24);
String Select_Permit_No=convertedWords.get(25);
String Add_User_Setting_Details=convertedWords.get(26);
String OrganisationTrader_Code=convertedWords.get(27);
String Select_OrganisationTrader_Code=convertedWords.get(28);

int userId=loginInfo.getUserId(); 
String userAuthority=cf.getUserAuthority(systemId,userId);	

if(customerId > 0 && loginInfo.getIsLtsp()== -1 && !userAuthority.equalsIgnoreCase("Supervisor"))
	{
		response.sendRedirect(request.getContextPath()+ "/Jsps/Common/401Error.html");
	}
	else{

%>
<!DOCTYPE HTML>
<html>
 <head>
 		<title>Tripsheet User Settings</title>		
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
   <script><!--
   
var outerPanel;
var ctsb;
var jspName = "User Setting";
var exportDataType = "";
var selected;
var grid;
var buttonValue;
var titelForInnerPanel;
var myWin;

var clientcombostore = new Ext.data.JsonStore({
    url: '<%=request.getContextPath()%>/CommonAction.do?param=getCustomer',
    id: 'CustomerStoreId',
    root: 'CustomerRoot',
    autoLoad: true,
    remoteSort: true,
    fields: ['CustId', 'CustName'],
    listeners: {
        load: function(custstore, records, success, options) {
            if ( <%= customerId %> > 0) {
                Ext.getCmp('custcomboId').setValue('<%=customerId%>');
                custId = Ext.getCmp('custcomboId').getValue();
                store.load({
                    params: {
                        CustId: custId
                    }
                });
                TcNoComboStore.load({
                    params: {
                        CustID: custId
                    }
                });
                SouceHubStore.load({
                    params: {
                        CustID: custId
                    }
                });
                  DestinationHubStore.load({
                    params: {
                        CustID: custId
                    }
                });
                OrgCodeComboStore.load({
                    params: {
                        CustID: custId
                    }
                });
            }
        }
    }
});

var Client = new Ext.form.ComboBox({
    store: clientcombostore,
    id: 'custcomboId',
    mode: 'local',
    forceSelection: true,
    emptyText: '<%=SelectCustomerName%>',
    blankText: '<%=SelectCustomerName%>',
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
            fn: function() {
                custId = Ext.getCmp('custcomboId').getValue();
                store.load({
                    params: {
                        CustId: custId
                    }
                });
                OrgCodeComboStore.load({
                    params: {
                        CustID: custId
                    }
                });
                TcNoComboStore.load({
                    params: {
                        CustID: custId
                    }
                });
                SouceHubStore.load({
                    params: {
                        CustID: custId
                    }
                });
              DestinationHubStore.load({
                    params: {
                        CustID: custId
                    }
                });
              OrgCodeComboStore.load({
                    params: {
                        CustID: custId
                    }
                });
            }
        }
    }
});

var customerComboPanel = new Ext.Panel({
    standardSubmit: true,
    collapsible: false,
    id: 'customerComboPanelId',
    layout: 'table',
    frame: false,
    width: screen.width - 12,
    height: 40,
    layoutConfig: {
        columns: 13
    },
    items: [{
            xtype: 'label',
            text: '<%=CustomerName%>' + ' :',
            cls: 'labelstyle'
        },
        Client
    ]
});

//**********************TC No combo*********************************************//
var TcNoComboStore= new Ext.data.JsonStore({
				   url:'<%=request.getContextPath()%>/UserSettingAction.do?param=getTcNumber',
				   root: 'TcNumberRoot',
			       autoLoad: false,
				   fields: ['TCno','TCID']
	});
	
var TcNoCombo = new Ext.form.ComboBox({
    store: TcNoComboStore,
    id: 'TccomboId',
    mode: 'local',
    forceSelection: true,
    emptyText: '<%=Select_TC_Number%>',
    blankText: '<%=Select_TC_Number%>',
    selectOnFocus: true,
    allowBlank: true,
    anyMatch: true,
    typeAhead: false,
    triggerAction: 'all',
    lazyRender: true,
    valueField: 'TCID',
    displayField: 'TCno',
    cls:'selectstylePerfect',
    resizable: true,
    listeners: {
        select: {
            fn: function () {
            Ext.getCmp('orgComboId').reset();
            Ext.getCmp('userComboId').reset();
            PermitNoStore.load({
                    params: {
                        CustID: custId,
                        tcId: Ext.getCmp('TccomboId').getValue(),
                        orgCode: Ext.getCmp('orgComboId').getValue()
                    }
                });
            userComboStore.load({
                    params: {
                        CustID: custId,
                        tcId: Ext.getCmp('TccomboId').getValue(),
                        orgCode: Ext.getCmp('orgComboId').getValue()
                    }
                });
            }
        }
    }
});

//**********************User combo*********************************************//
var userComboStore= new Ext.data.JsonStore({
				   url:'<%=request.getContextPath()%>/UserSettingAction.do?param=getUserNames',
				   root: 'userRoot',
			       autoLoad: false,
				   fields: ['userName','userId']
	});
	
var userCombo = new Ext.form.ComboBox({
    store: userComboStore,
    id: 'userComboId',
    mode: 'local',
    forceSelection: true,
    emptyText: 'Select User Name',
    blankText: 'Select User Name',
    selectOnFocus: true,
    allowBlank: true,
    anyMatch: true,
    typeAhead: false,
    triggerAction: 'all',
    lazyRender: true,
    valueField: 'userId',
    displayField: 'userName',
    cls:'selectstylePerfect',
    resizable: true,
    listeners: {
        select: {
            fn: function () {
            }
        }
    }
});

//**********************User combo*********************************************//
var OrgCodeComboStore= new Ext.data.JsonStore({
				   url:'<%=request.getContextPath()%>/UserSettingAction.do?param=getOrganisationCode',
				   root: 'orgRoot',
			       autoLoad: false,
				   fields: ['orgCode','orgId']
	});
	
var OrgCodeCombo = new Ext.form.ComboBox({
    store: OrgCodeComboStore,
    id: 'orgComboId',
    mode: 'local',
    forceSelection: true,
    emptyText: '<%=Select_OrganisationTrader_Code%>',
    blankText: '<%=Select_OrganisationTrader_Code%>',
    selectOnFocus: true,
    allowBlank: true,
    anyMatch: true,
    typeAhead: false,
    triggerAction: 'all',
    lazyRender: true,
    valueField: 'orgId',
    displayField: 'orgCode',
    cls:'selectstylePerfect',
    resizable: true,
    listeners: {
        select: {
            fn: function () {
            Ext.getCmp('TccomboId').reset();
            Ext.getCmp('userComboId').reset();
                PermitNoStore.load({
                    params: {
                        CustID: custId,
                        tcId: Ext.getCmp('TccomboId').getValue(),
                        orgCode: Ext.getCmp('orgComboId').getValue()
                    }
                });
                userComboStore.load({
                    params: {
                        CustID: custId,
                        tcId: Ext.getCmp('TccomboId').getValue(),
                        orgCode: Ext.getCmp('orgComboId').getValue()
                    }
                });
            }
        }
    }
});

//*******************************PermitNO****************************************//
 var PermitNoStore= new Ext.data.JsonStore({
           url: '<%=request.getContextPath()%>/UserSettingAction.do?param=getPermitNo',
           id: 'permitNocomboId11',
		   root: 'permitNoStoreRoot',
		   autoload: false,
	       remoteSort: true,
		   fields: ['ID','PermitNo']
	});
	
	//****************************combo for RouteId****************************************

  var permitSelect = new Ext.grid.CheckboxSelectionModel();
  var permitNoGrid = new Ext.grid.GridPanel({
		id:'permitGridId',
		store: PermitNoStore,
		columns: [permitSelect, {
		header:'Select Permit No',
		hidden:false,
		sortable:true,
		width: 195,
		id:'selectpermitId',
		columns: [{
		      xtype:'checkcolumn',
		      dataIndex:'PermitNo'
		     }]
		   }
		],
		sm: permitSelect,
		plugins: filters,
		stripeRows:true,
		border:true,
		frame:false,
		width: 215,
		height: 145,
		style:'margin-left:5px;',
		cls:'bskExtStyle'
		});
		
//************************************combo for Souce Hub**********************************//
 var SouceHubStore= new Ext.data.JsonStore({
           url: '<%=request.getContextPath()%>/UserSettingAction.do?param=getSourcehub',
           id: 'sourcehubcomboId11',
				    root: 'sourceHubStoreRoot',
				    autoload: false,
				    remoteSort: true,
				    fields: ['Hubname','HubID']
	});
	
var SourceHubCombo = new Ext.form.ComboBox({
    store: SouceHubStore,
    id: 'sourceHubcomboId',
    mode: 'local',
    forceSelection: true,
    emptyText: '<%=Select_Weigh_Bridge_Source%>',
    blankText: '<%=Select_Weigh_Bridge_Source%>',
    selectOnFocus: true,
    allowBlank: true,
    anyMatch: true,
    typeAhead: false,
    triggerAction: 'all',
    lazyRender: true,
    valueField: 'HubID',
    displayField: 'Hubname',
    cls:'selectstylePerfect',
    resizable: true,
    listeners: {
        select: {
            fn: function () {

            }
        }
    }
});
//************************************combo for Destination Hub**********************************//
 var DestinationHubStore= new Ext.data.JsonStore({
           url: '<%=request.getContextPath()%>/UserSettingAction.do?param=getSourcehub',
           id: 'destinationhubcomboId11',
				    root: 'sourceHubStoreRoot',
				    autoload: false,
				    remoteSort: true,
				    fields: ['Hubname','HubID']
	});
	
var DestinationHubCombo = new Ext.form.ComboBox({
    store: DestinationHubStore,
    id: 'destinationHubcomboId',
    mode: 'local',
    forceSelection: true,
    emptyText: '<%=Select_Weigh_Bridge_Destination%>',
    blankText: '<%=Select_Weigh_Bridge_Destination%>',
    selectOnFocus: true,
    allowBlank: true,
    anyMatch: true,
    typeAhead: false,
    triggerAction: 'all',
    lazyRender: true,
    valueField: 'HubID',
    displayField: 'Hubname',
    cls:'selectstylePerfect',
    resizable: true,
    listeners: {
        select: {
            fn: function () {

            }
        }
    }
});
//******************************store for Type**********************************
	var typeStore = new Ext.data.SimpleStore({
     id: 'typeComboStoreId',
	      fields: ['Name', 'Value'],
	      autoLoad: false,
	      data: [
	          ['Open', 'Open'],
	          ['Close', 'Close'],
			  ['Both', 'Both']
	      ]
 });

//****************************combo for Type****************************************
 var typeCombo = new Ext.form.ComboBox({
     store: typeStore,
     id: 'typecomboId',
     mode: 'local',
     forceSelection: true,
     emptyText: '<%=Select_Type%>',
     selectOnFocus: true,
     allowBlank: false,
     anyMatch: true,
     typeAhead: false,
     triggerAction: 'all',
     lazyRender: true,
     valueField:'Value',
 	 displayField:'Name',
 	 cls: 'selectstylePerfect',
     listeners: {
         select: {
             fn: function () {
                 if(Ext.getCmp('typecomboId').getValue()== 'Open'){
                    Ext.getCmp('closeTypecomboId').hide();
                    Ext.getCmp('closeTypeId').hide();
                    Ext.getCmp('mandatorycloseTypeId').hide();
                 }else{
                    Ext.getCmp('closeTypecomboId').show();
                    Ext.getCmp('closeTypeId').show();
                    Ext.getCmp('mandatorycloseTypeId').show();
                 }
                 }
             }
         }
     
 });
 
 //******************************store for close Type**********************************
	var CloseTypeStore = new Ext.data.SimpleStore({
     id: 'closeTypeComboStoreId',
	      fields: ['Name', 'Value'],
	      autoLoad: true,
	      data: [
	          ['Close with Tare @ D', 'Close with Tare @ D'],
	          ['Close w/o Tare @ D', 'Close w/o Tare @ D'],
			  ['Manual Close', 'Manual Close']
	      ]
 });

//****************************combo for close Type****************************************
 var ClosingTypeCombo = new Ext.form.ComboBox({
     store: CloseTypeStore,
     id: 'closeTypecomboId',
     mode: 'local',
     forceSelection: true,
     emptyText: 'Select Close Type',
     selectOnFocus: true,
     allowBlank: false,
     anyMatch: true,
     typeAhead: false,
     triggerAction: 'all',
     lazyRender: true,
     valueField:'Value',
 	 displayField:'Name',
 	 cls: 'selectstylePerfect',
     listeners: {
         select: {
             fn: function () {
                 }
             }
         }
     
 });
 
 
var innerPanelForUserSetting = new Ext.form.FormPanel({
    standardSubmit: true,
    collapsible: false,
    autoScroll: false,
    height: 400,
    width: 680,
    frame: false,
    id: 'innerPanelForUserSettingId',
    layout: 'table',
    layoutConfig: {
        columns: 3
    },
    items: [{
        xtype: 'fieldset',
        title:'<%=Tripsheet_User_Settings%>',
        cls: 'fieldsetpanel',
        collapsible: false,
        colspan:3,
        id: 'UserInfoId',
        width: 650,
        autoScroll: true,
        height: 390,
        layout: 'table',
        layoutConfig: {
            columns: 4
        },
        items: [{
                xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                id: 'mandatoryorg'
            }, {
                xtype: 'label',
                text: '<%=OrganisationTrader_Code%>'+'  :',
                cls: 'labelstyle',
                id: 'orgLabelId'
            },OrgCodeCombo,{width: 10},{
                xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                id: 'mandatoryusert'
            }, {
                xtype: 'label',
                text: '<%=TC_No%>'+'  :',
                cls: 'labelstyle',
                id: 'TcNoLabelId'
            },TcNoCombo,{width: 10},
            {
                xtype: 'label',
                text: '*',
                cls: 'mandatoryfield',
                id: 'mandatoryuser'
            }, {
                xtype: 'label',
                text: 'User Name'+'  :',
                cls: 'labelstyle',
                id: 'userLabelId'
            },userCombo,{width: 10},
             {
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'mandatorynoid'
        },{
            xtype: 'label',
            text: '<%=Permit_No%>' + ' :',
            cls: 'labelstyle',
            id: 'permitNumId'
        }, permitNoGrid,{width: 0},
        {height: 10},{height: 10},{height: 10},{height: 10},
          {
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'mandatoryShubId'
        },{
            xtype: 'label',
            text: '<%=Weigh_Bridge_Source%>' + ' :',
            cls: 'labelstyle',
            id: 'sourceHubId'
        }, SourceHubCombo,{width: 10},
          {
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'mandatoryDhubId'
        },{
            xtype: 'label',
            text: '<%=Weigh_Bridge_Destination%>' + ' :',
            cls: 'labelstyle',
            id: 'destinationHubId'
        }, DestinationHubCombo,{width: 10},
        {
	            xtype: 'label',
	            text: '*',
	            cls: 'mandatoryfield',
	            id: 'mandatorytypeId'
	        }, {
	            xtype: 'label',
	            text: '<%=Type%>' + ' :',
	            cls: 'labelstyle',
	            id: 'typeId'
	        },typeCombo,{width: 10},
	        {
	            xtype: 'label',
	            text: '*',
	            cls: 'mandatoryfield',
	            id: 'mandatorycloseTypeId'
	        }, {
	            xtype: 'label',
	            text: 'Closing Type' + ' :',
	            cls: 'labelstyle',
	            id: 'closeTypeId'
	        },ClosingTypeCombo,{width: 10}
	        ]
    }]
});

var innerWinButtonPanel = new Ext.Panel({
    id: 'innerWinButtonPanelId',
    standardSubmit: true,
    collapsible: false,
    autoHeight: true,
    height: 100,
    width: 650,
    frame: false,
    layout: 'table',
    layoutConfig: {
        columns: 4
    },
    buttons: [{
        xtype: 'button',
        text: 'Save',
        id: 'saveButtonId',
        cls: 'buttonstyle',
        iconCls:'savebutton',
        width: 70,
        listeners: {
            click: {
                fn: function() {
                   
                    if (Ext.getCmp('userComboId').getValue() == "") {
                    Ext.example.msg("Select User Name");
                        return;
                    }
                    if (Ext.getCmp('TccomboId').getValue() == "" && Ext.getCmp('orgComboId').getRawValue() == "") {
                    Ext.example.msg("<%=Select_TC_Number%>" + " Or <%=OrganisationTrader_Code%>");
                        return;
                    }
                    var selectedPermit="";
                    selectedPermit="-";
                    var record = permitNoGrid.getSelectionModel().getSelections();
                    for (var i = 0; i < record.length; i++) {
                        var recordEach = record[i];
                        var permitId=recordEach.data['ID'];
                        if(selectedPermit== "-"){
                        selectedPermit = permitId;
                        }else{
                        selectedPermit = selectedPermit + "," + permitId
                        }
                    }
                     if (selectedPermit == '' || selectedPermit == '0' || selectedPermit == '-') {
                        Ext.example.msg("Select Permit Number");
                        return;
                    }
                    if (Ext.getCmp('sourceHubcomboId').getValue() == "") {
                    Ext.example.msg("<%=Select_Weigh_Bridge_Source%>");
                        return;
                    }
                    if (Ext.getCmp('destinationHubcomboId').getValue() == "") {
                    Ext.example.msg("<%=Select_Weigh_Bridge_Destination%>");
                        return;
                    }
                    if (Ext.getCmp('typecomboId').getValue() == "") {
                    Ext.example.msg("<%=Select_Type%>");
                        return;
                    }
                    if(Ext.getCmp('typecomboId').getValue() == "Close" || Ext.getCmp('typecomboId').getValue() == "Both"){
                       if (Ext.getCmp('closeTypecomboId').getValue() == "") {
                          Ext.example.msg("Select Closing Type");
                          return;
                       }
                    }
                    var rec;
                        Ext.Ajax.request({
                            url: '<%=request.getContextPath()%>/UserSettingAction.do?param=AddorModifyUserSetting',
                            method: 'POST',
                            params: {
                                buttonValue: buttonValue,
                                CustId: Ext.getCmp('custcomboId').getValue(),
                                tcno: Ext.getCmp('TccomboId').getValue(),
                                permitNo: selectedPermit,
                                sourceHub: Ext.getCmp('sourceHubcomboId').getValue(),
                                destinationHub: Ext.getCmp('destinationHubcomboId').getValue(),
                                type: Ext.getCmp('typecomboId').getValue(),
                                userName: Ext.getCmp('userComboId').getValue(),
                                orgCode: Ext.getCmp('orgComboId').getValue(),
                                closeType: Ext.getCmp('closeTypecomboId').getValue()
                            },
                            success: function(response, options) {
                                var message = response.responseText;
                                Ext.example.msg(message);
							    Ext.getCmp('TccomboId').reset(),
                                Ext.getCmp('sourceHubcomboId').reset(),
                                Ext.getCmp('destinationHubcomboId').reset(),
                                Ext.getCmp('typecomboId').reset(),
                                Ext.getCmp('userComboId').reset(),
                                Ext.getCmp('orgComboId').reset()
                                myWin.hide();
                                routeMasterOuterPanelWindow.getEl().unmask();
                                store.load({
                                    params: {
                                        CustId: custId
                                    }
                                });
                                PermitNoStore.load({
				                    params: {
				                    }
				                });
                            },
                            failure: function() {
                                Ext.example.msg("Error");
                                store.reload();
                                myWin.hide();
                            }
                        });
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

var routeMasterOuterPanelWindow = new Ext.Panel({
    width: 700,
    height: 468,
    standardSubmit: true,
    frame: true,
    items: [innerPanelForUserSetting, innerWinButtonPanel]
});

myWin = new Ext.Window({
    title: titelForInnerPanel,
    closable: false,
    resizable: false,
    modal: true,
    autoScroll: false,
    height: 500,
    width: 700,
    id: 'myWin',
    items: [routeMasterOuterPanelWindow]
});

function addRecord() {
    if (Ext.getCmp('custcomboId').getValue() == "") {
     Ext.example.msg("<%=SelectCustomerName%>");
        return;
    }
    buttonValue = '<%=Add%>';
    titelForInnerPanel = '<%=Add_User_Setting_Details%>';
    myWin.setPosition(400, 50);
    myWin.show();
    Ext.getCmp('TccomboId').reset(),
    Ext.getCmp('sourceHubcomboId').reset(),
    Ext.getCmp('destinationHubcomboId').reset(),
    Ext.getCmp('typecomboId').reset(),
    Ext.getCmp('userComboId').reset(),
    Ext.getCmp('orgComboId').reset()
    myWin.setTitle(titelForInnerPanel);
    PermitNoStore.load({
        params: {
        }
    });
    Ext.getCmp('closeTypecomboId').hide();
    Ext.getCmp('closeTypeId').hide();
    Ext.getCmp('mandatorycloseTypeId').hide();
}

var reader = new Ext.data.JsonReader({
    idProperty: 'usersettingid',
    root: 'userSettingRoot',
    totalProperty: 'total',
    fields: [{
        name: 'slnoIndex'
    },{
        name: 'userNameDataIndex'
    },{
        name: 'orgCodeDataIndex'
    }, {
        name: 'tcNoDataIndex'
    }, {
        name: 'permitNoDataIndex'
    }, {
        name: 'sourceHubDataIndex'
    }, {
        name: 'destinationHubDataIndex'
    }, {
        name: 'typeDataIndex'
    }, {
    	type: 'date',
    	dateFormat: getDateTimeFormat(),
        name: 'insertedtimeDataIndex'
    }, {
        name: 'closingTypeDataIndex'
    } ]
});

var store = new Ext.data.GroupingStore({
    autoLoad: false,
    proxy: new Ext.data.HttpProxy({
       url: '<%=request.getContextPath()%>/UserSettingAction.do?param=getUserSettingDetails',
        method: 'POST'
    }),
    storeId: 'usersettingId',
    reader: reader
});

var filters = new Ext.ux.grid.GridFilters({
    local: true,
    filters: [{
        type: 'numeric',
        dataIndex: 'slnoIndex'
    }, {
        type: 'int',
        dataIndex: 'uniqueIdDataIndex'
    }, {
        type: 'string',
        dataIndex: 'userNameDataIndex'
    }, {
        type: 'string',
        dataIndex: 'orgCodeDataIndex'
    },{
        type: 'string',
        dataIndex: 'tcNoDataIndex'
    }, {
        type: 'string',
        dataIndex: 'permitNoDataIndex'
    }, {
        type: 'string',
        dataIndex: 'sourceHubDataIndex'
    }, {
        type: 'string',
        dataIndex: 'destinationHubDataIndex'
    }, {
        type: 'string',
        dataIndex: 'typeDataIndex'
    }, {
        type: 'date',
        dataIndex: 'insertedtimeDataIndex'
   } ,{
        type: 'string',
        dataIndex: 'closingTypeDataIndex'
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
            header: "<span style=font-weight:bold;>User Name</span>",
            dataIndex: 'userNameDataIndex',
            width: 80,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=OrganisationTrader_Code%></span>",
            dataIndex: 'orgCodeDataIndex',
            width: 100,
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;><%=TC_No%></span>",
            dataIndex: 'tcNoDataIndex',
            width: 100,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=Permit_No%></span>",
            dataIndex: 'permitNoDataIndex',
            width: 100,
            hidden:true,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=Weigh_Bridge_Source%></span>",
            dataIndex: 'sourceHubDataIndex',
            width: 100,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=Weigh_Bridge_Destination%></span>",
            dataIndex: 'destinationHubDataIndex',
            width: 100,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=Type%></span>",
            dataIndex: 'typeDataIndex',
            width: 50,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=Entered_Date_Time%></span>",
            dataIndex: 'insertedtimeDataIndex',
            width: 100,
            renderer: Ext.util.Format.dateRenderer(getDateTimeFormat()),
            filter: {
                type: 'date'
            }
        },{
            header: "<span style=font-weight:bold;>Closing Type</span>",
            dataIndex: 'closingTypeDataIndex',
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

grid = getGrid('<%=Tripsheet_User_Settings%>', '<%=NoRecordsFound%>', store, screen.width - 40, 440, 15, filters, '<%=ClearFilterData%>', false, '', 16, false, '', false, '', false, '<%=Excel%>', jspName, exportDataType, false, 'PDF', true, '<%=Add%>', false, '<%=Modify%>', false, '<%=Delete%>');

Ext.onReady(function() {
    Ext.QuickTips.init();
    Ext.form.Field.prototype.msgTarget = 'side';
    outerPanel = new Ext.Panel({
        title: '',
        renderTo: 'content',
        standardSubmit: true,
        frame: true,
        width: screen.width - 22,
        cls: 'outerpanel',
        layout: 'table',
        layoutConfig: {
            columns: 1
        },
        items: [customerComboPanel, grid]
    });
    sb = Ext.getCmp('form-statusbar');
});
--></script>
</body>
</html>
<%}%>
<%}%>
