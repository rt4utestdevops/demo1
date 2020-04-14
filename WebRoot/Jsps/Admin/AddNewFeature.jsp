<%@ page  language="java" import="java.util.*,java.text.SimpleDateFormat,t4u.functions.*,t4u.beans.*,t4u.common.*" pageEncoding="utf-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
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
loginInfo.setStyleSheetOverride("Y");

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

	int systemId = loginInfo.getSystemId();
	int customerId = loginInfo.getCustomerId();
ArrayList<String> tobeConverted=new ArrayList<String>();	
	tobeConverted.add("Add_Feature_Details");
	tobeConverted.add("No_Records_Found");
	tobeConverted.add("Clear_Filter_Data");
	tobeConverted.add("Add");
	tobeConverted.add("Modify");
	tobeConverted.add("Delete");
	tobeConverted.add("Id");
	tobeConverted.add("Page_Link");
	tobeConverted.add("Page_Title");
	tobeConverted.add("Menu_Group_Name");
	tobeConverted.add("Sub_Process_Name");
	tobeConverted.add("Process_Name");
	tobeConverted.add("Not_Deleted");
	tobeConverted.add("Are_you_sure_you_want_to_delete");
	tobeConverted.add("Select_Single_Row");
	tobeConverted.add("No_Rows_Selected");
	tobeConverted.add("Select_LTSP");
	tobeConverted.add("Link_Details");
	tobeConverted.add("Select_Process_Type");
	tobeConverted.add("Select_Process_Name");
	tobeConverted.add("Select_Sub_Process_Name");
	tobeConverted.add("Select_Menu_Group_Name");
	tobeConverted.add("Enter_Page_Title");
	tobeConverted.add("Select_Page_Link");
	tobeConverted.add("Add_Feature_Information");
	tobeConverted.add("LTSP");
	tobeConverted.add("Select_Ltsp_Name");
	tobeConverted.add("Add_New_Feature");
	tobeConverted.add("Process_Type");
	tobeConverted.add("Cancel");
	tobeConverted.add("Save");
	tobeConverted.add("SLNO");
	tobeConverted.add("Menu_Details");
	tobeConverted.add("Add_New_Feature_to_LTSP");
	ArrayList<String> convertedWords=new ArrayList<String>();
	convertedWords=cf.getLanguageSpecificWordForKey(tobeConverted, language);	
	

String AddFeatureDetails= convertedWords.get(0);
String NoRecordsFound= convertedWords.get(1);
String ClearFilterData= convertedWords.get(2);
String Add= convertedWords.get(3);
String Modify= convertedWords.get(4);
String Delete= convertedWords.get(5);
String Id= convertedWords.get(6);
String PageLink= convertedWords.get(7);
String PageTitle= convertedWords.get(8);
String MenuGroupName= convertedWords.get(9);
String SubProcessName= convertedWords.get(10);
String ProcessName= convertedWords.get(11);
String NotDeleted= convertedWords.get(12);
String Areyousureyouwanttodelete= convertedWords.get(13);
String SelectSingleRow= convertedWords.get(14);
String NoRowsSelected= convertedWords.get(15);
String SelectLTSP= convertedWords.get(16);
String LinkDetails= convertedWords.get(17);
String SelectProcessType= convertedWords.get(18);
String SelectProcessName= convertedWords.get(19);
String SelectSubProcessName= convertedWords.get(20);
String SelectMenuGroupName= convertedWords.get(21);
String EnterPageTitle= convertedWords.get(22);
String SelectPageLink= convertedWords.get(23);
String AddFeatureInformation= convertedWords.get(24);
String LTSP= convertedWords.get(25);
String SelectLTSPName= convertedWords.get(26);
String AddNewFeature= convertedWords.get(27);
String ProcessType= convertedWords.get(28);
String Cancel= convertedWords.get(29);
String Save= convertedWords.get(30);
String SLNO= convertedWords.get(31);
String MenuDetails= convertedWords.get(32);
String AddNewFeaturetoLTSP = convertedWords.get(33);



%>

<!DOCTYPE HTML>
<html>
 <head>
 		<title><%=AddNewFeature%></title>		
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
var jspName = "AddNewFeature";
var exportDataType = "";
var selected;
var grid;
var buttonValue;
var titelForInnerPanel;
var myWin;
var firstSavePanel = "";
var firstSavePanel1 = "";

var ltspStore = new Ext.data.JsonStore({
    url: '<%=request.getContextPath()%>/AddNewFeatureAction.do?param=getLTSP',
    id: 'ltspStoreId',
    root: 'LTSPRoot',
    autoLoad: true,
    remoteSort: true,
    fields: ['ltspId', 'ltspName'],
    listeners: {}
});

var Ltsp = new Ext.form.ComboBox({
    store: ltspStore,
    id: 'ltspComboId',
    mode: 'local',
    forceSelection: true,
    emptyText: '<%=SelectLTSPName%>',
    blankText: '<%=SelectLTSPName%>',
    selectOnFocus: true,
    allowBlank: false,
    anyMatch: true,
    typeAhead: false,
    triggerAction: 'all',
    lazyRender: true,
    valueField: 'ltspId',
    displayField: 'ltspName',
    cls: 'selectstylePerfect',
    listeners: {
        select: {
            fn: function() {
                //  alert(Ext.getCmp('ltspComboId').getValue());
                store.load({
                    params: {
                        systemIdFromJsp: Ext.getCmp('ltspComboId').getValue()
                    }
                });
                processTypeStore.load();
                pageLinkStore.load();
            }
        }
    }
});

var processTypeStore = new Ext.data.JsonStore({
    url: '<%=request.getContextPath()%>/AddNewFeatureAction.do?param=getProcessType',
    id: 'procesTypeStoreId',
    root: 'processTypeRoot',
    autoload: true,
    remoteSort: true,
    fields: ['ProcessId', 'processType'],
    listeners: {}
});

var processTypeCombo = new Ext.form.ComboBox({
    store: processTypeStore,
    id: 'processTypecomboId',
    mode: 'local',
    forceSelection: true,
    emptyText: '<%=SelectProcessType%>',
    blankText: '<%=SelectProcessType%>',
    selectOnFocus: true,
    allowBlank: false,
    anyMatch: true,
    typeAhead: false,
    triggerAction: 'all',
    lazyRender: true,
    valueField: 'ProcessId',
    displayField: 'processType',
    cls: 'selectstylePerfect',
    listeners: {
        select: {
            fn: function() {
                //  alert(Ext.getCmp('processTypecomboId').getRawValue());
                Ext.getCmp('processNamecomboId').reset();
                Ext.getCmp('subProcessNamecomboId').reset();
                Ext.getCmp('menuGroupNamecomboId').reset();
                processNameStore.load({
                    params: {
                        processType: Ext.getCmp('processTypecomboId').getValue()
                    }
                });
                
                subProcessNameStore.load({
                    params: {
                       
                    }
                });
            }
        }
    }
});

var processNameStore = new Ext.data.JsonStore({
    url: '<%=request.getContextPath()%>/AddNewFeatureAction.do?param=getProcessName',
    id: 'procesTypeStoreId',
    root: 'processNameRoot',
    autoload: true,
    remoteSort: true,
    fields: ['processId', 'processName'],
    listeners: {}
});

var processNameCombo = new Ext.form.ComboBox({
    store: processNameStore,
    id: 'processNamecomboId',
    mode: 'local',
    forceSelection: true,
    emptyText: '<%=SelectProcessName%>',
    blankText: '<%=SelectProcessName%>',
    selectOnFocus: true,
    allowBlank: false,
    anyMatch: true,
    typeAhead: false,
    triggerAction: 'all',
    lazyRender: true,
    valueField: 'processId',
    displayField: 'processName',
    cls: 'selectstylePerfect',
    listeners: {
        select: {
            fn: function() {
                // alert(Ext.getCmp('processNamecomboId').getValue());
                Ext.getCmp('subProcessNamecomboId').reset();
                Ext.getCmp('menuGroupNamecomboId').reset();
                subProcessNameStore.load({
                    params: {
                        processId: Ext.getCmp('processNamecomboId').getValue()
                    }
                });
                subProcessStoreForSecondPanel.load({
                    params: {
                        processId: Ext.getCmp('processNamecomboId').getValue()
                    }
                });
                
                menuGroupNameStore.load({
                    params: {
                        
                    }
                });
            }
        }
    }
});

var subProcessNameStore = new Ext.data.JsonStore({
    url: '<%=request.getContextPath()%>/AddNewFeatureAction.do?param=getSubProcessName',
    id: 'subProcessNameStoreId',
    root: 'subProcessNameRoot',
    autoload: true,
    remoteSort: true,
    fields: ['SubProcessId', 'SubProcessName'],
    listeners: {}
});

var subProcessNameCombo = new Ext.form.ComboBox({
    store: subProcessNameStore,
    id: 'subProcessNamecomboId',
    mode: 'local',
    forceSelection: true,
    emptyText: '<%=SelectSubProcessName%>',
    blankText: '<%=SelectSubProcessName%>',
    selectOnFocus: true,
    allowBlank: false,
    anyMatch: true,
    typeAhead: false,
    triggerAction: 'all',
    lazyRender: true,
    valueField: 'SubProcessId',
    displayField: 'SubProcessName',
    cls: 'selectstylePerfect',
    listeners: {
        select: {
            fn: function() {
               // alert(Ext.getCmp('subProcessNamecomboId').getValue());
                Ext.getCmp('menuGroupNamecomboId').reset();
                menuGroupNameStore.load({
                    params: {
                        subProcessId: Ext.getCmp('subProcessNamecomboId').getValue()
                    }
                });
            }
        }
    }
});

var menuGroupNameStore = new Ext.data.JsonStore({
    url: '<%=request.getContextPath()%>/AddNewFeatureAction.do?param=getmenuGroupName',
    id: 'menuGroupNameStoreId',
    root: 'menuGroupNameRoot',
    autoload: true,
    remoteSort: true,
    fields: ['MenuGroupNameId', 'MenuGroupName'],
    listeners: {}
});

var MenuGroupNameCombo = new Ext.form.ComboBox({
    store: menuGroupNameStore,
    id: 'menuGroupNamecomboId',
    mode: 'local',
    forceSelection: true,
    emptyText: '<%=SelectMenuGroupName%>',
    blankText: '<%=SelectMenuGroupName%>',
    selectOnFocus: true,
    allowBlank: false,
    anyMatch: true,
    typeAhead: false,
    triggerAction: 'all',
    lazyRender: true,
    valueField: 'MenuGroupNameId',
    displayField: 'MenuGroupName',
    cls: 'selectstylePerfect',
    listeners: {
        select: {
            fn: function() {}
        }
    }
});

var pageLinkStore = new Ext.data.JsonStore({
    url: '<%=request.getContextPath()%>/AddNewFeatureAction.do?param=getPageLink',
    id: 'pageLinkStoreId',
    root: 'pageLinkRoot',
    autoload: true,
    remoteSort: true,
    fields: ['pageLinkId', 'pageLinkName'],
    listeners: {}
});

var pageLinkCombo = new Ext.form.ComboBox({
    store: pageLinkStore,
    id: 'pageLinkcomboId',
    mode: 'local',
    forceSelection: true,
    emptyText: '<%=SelectPageLink%>',
    blankText: '<%=SelectPageLink%>',
    selectOnFocus: true,
    allowBlank: false,
    anyMatch: true,
    resizable:true,
    typeAhead: false,
    triggerAction: 'all',
    lazyRender: true,
    valueField: 'pageLinkId',
    displayField: 'pageLinkName',
    cls: 'selectstylePerfect',
    listeners: {
        select: {
            fn: function() {}
        }
    }
});

var ltspPanel = new Ext.Panel({
    standardSubmit: true,
    collapsible: false,
    id: 'ltspPanelId',
    layout: 'table',
    frame: false,
    width: screen.width - 12,
    height: 40,
    layoutConfig: {
        columns: 13
    },
    items: [{
            xtype: 'label',
            text: '<%=LTSP%>' + ' :',
            cls: 'labelstyle'
        },
        Ltsp
    ]
});

var innerPanelForltspDetails = new Ext.form.FormPanel({
    standardSubmit: true,
    collapsible: false,
    autoScroll: true,
    height: 250,
    width: 400,
    frame: true,
    id: 'innerPanelForLtspDetailsId',
    layout: 'table',
    layoutConfig: {
        columns: 4
    },
    items: [{
        xtype: 'fieldset',
        title: '<%=AddFeatureInformation%>',
        cls: 'fieldsetpanel',
        collapsible: false,
        colspan: 3,
        id: 'addFeatureId',
        width: 360,
        layout: 'table',
        layoutConfig: {
            columns: 3
        },
        items: [{
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'processTypeEmptyId1'
        }, {
            xtype: 'label',
            text: '<%=ProcessType%>' + ' :',
            cls: 'labelstyle',
            id: 'processTypeLabelId'
        }, processTypeCombo, {
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'processNameEmptyId1'
        }, {
            xtype: 'label',
            text: '<%=ProcessName%>' + ' :',
            cls: 'labelstyle',
            id: 'processNameLabelId'
        }, processNameCombo, {
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'subProcessNameEmptyId1'
        }, {
            xtype: 'label',
            text: '<%=SubProcessName%>' + ' :',
            cls: 'labelstyle',
            id: 'subProcessNameLabelId'
        }, subProcessNameCombo, {
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'menuGroupNameId1'
        }, {
            xtype: 'label',
            text: '<%=MenuGroupName%>' + ' :',
            cls: 'labelstyle',
            id: 'menuGroupNameLabelId'
        }, MenuGroupNameCombo, {
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'pageTitleEmptyId1'
        }, {
            xtype: 'label',
            text: '<%=PageTitle%>' + ' :',
            cls: 'labelstyle',
            id: 'pageTitleLabelId'
        }, {
            xtype: 'textfield',
            cls: 'selectstylePerfect',
            allowBlank: false,
            blankText: '<%=EnterPageTitle%>',
            emptyText: '<%=EnterPageTitle%>',
            labelSeparator: '',
            id: 'pageTitleId'
        }, {
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'pageLinkEmptyId1'
        }, {
            xtype: 'label',
            text: '<%=PageLink%>' + ' :',
            cls: 'labelstyle',
            id: 'pageLinkLabelId'
        }, pageLinkCombo]
    }]
});

//-----------------------------------------------------------------------SECOND PANEL-----------------------------------------------------------------------------------------//
var menuGroupNameComboForSecondPanel = new Ext.form.ComboBox({
    store: menuGroupNameStore,
    id: 'menuGroupNameComboForSecondPanelId',
    mode: 'local',
    forceSelection: true,
    emptyText: '<%=SelectMenuGroupName%>',
    blankText: '<%=SelectMenuGroupName%>',
    selectOnFocus: true,
    allowBlank: false,
    anyMatch: true,
    typeAhead: false,
    triggerAction: 'all',
    lazyRender: true,
    valueField: 'MenuGroupNameId',
    displayField: 'MenuGroupName',
    cls: 'selectstylePerfect',
    listeners: {
        select: {
            fn: function() {}
        }
    }
});

var subProcessStoreForSecondPanel = new Ext.data.JsonStore({
    url: '<%=request.getContextPath()%>/AddNewFeatureAction.do?param=getSecondSubProcessName',
    id: 'subProcessStoreForSecondPanelId',
    root: 'subProcessStoreForSecondPanelRoot',
    autoload: true,
    remoteSort: true,
    fields: ['secondSubProcessId', 'secondSubProcessName'],
    listeners: {}
});

var subprocessNameComboForSecondPanel = new Ext.form.ComboBox({
    store: subProcessStoreForSecondPanel,
    id: 'subProcessStoreForSecondPanelComboId',
    mode: 'local',
    forceSelection: true,
    selectOnFocus: true,
    allowBlank: false,
    anyMatch: true,
    typeAhead: false,
    triggerAction: 'all',
    lazyRender: true,
    valueField: 'Value',
    emptyText: 'Select Sub Process',
    displayField: 'secondSubProcessName',
    valueField: 'secondSubProcessId',
    cls: 'selectstylePerfect',
    listeners: {
        select: {
            fn: function() {
                Ext.getCmp('menuGroupNameComboForSecondPanelId').reset();
                menuGroupNameStore.load({
                    params: {
                        subProcessId: Ext.getCmp('subProcessStoreForSecondPanelComboId').getValue()
                    }
                });
            }
        }
    }
});

var secondPanelForSubProcessDetails = new Ext.form.FormPanel({
    standardSubmit: true,
    collapsible: false,
    autoScroll: true,
    height: 150,
    width: 400,
    frame: true,
    id: 'secondPanelForSubProcessDetailsId',
    layout: 'table',
    layoutConfig: {
        columns: 4
    },
    items: [{
        xtype: 'fieldset',
        title: 'Sub Process Information',
        cls: 'fieldsetpanel',
        collapsible: false,
        colspan: 3,
        id: 'SubProcessInformationId',
        width: 360,
        layout: 'table',
        layoutConfig: {
            columns: 3
        },
        items: [{
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'SubProcessNameIdForSecondPanel1'
        }, {
            xtype: 'label',
            text: '<%=SubProcessName%>' + ' :',
            cls: 'labelstyle',
            id: 'SubProcessNameIdForSecondPanel'
        }, subprocessNameComboForSecondPanel, {
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'menuGroupNameEmptyId1ForEmptyPanel'
        }, {
            xtype: 'label',
            text: '<%=MenuGroupName%>' + ' :',
            cls: 'labelstyle',
            id: 'menuGroupNameLabelIdForSecondPanel'
        }, menuGroupNameComboForSecondPanel]
    }]
});

var subProcessInnerWinButtonPanel = new Ext.Panel({
    id: 'subProcessInnerWinButtonPanelId',
    standardSubmit: true,
    collapsible: false,
    autoHeight: true,
    height: 80,
    width: 400,
    frame: true,
    layout: 'table',
    layoutConfig: {
        columns: 4
    },
    buttons: [{
        xtype: 'button',
        text: '<%=Save%>',
        id: 'saveButtonIdForSecondPanel',
        cls: 'buttonstyle',
        iconCls: 'savebutton',
        width: 70,
        listeners: {
            click: {
                fn: function() {
                    if (Ext.getCmp('subProcessStoreForSecondPanelComboId').getValue() == "") {
                        Ext.example.msg("<%=SelectSubProcessName%>");
                        return;
                    }
                    if (Ext.getCmp('menuGroupNameComboForSecondPanelId').getValue() == "") {
                        Ext.example.msg("<%=SelectMenuGroupName%>");
                        return;
                    }
                    subProcessOuterPanelWindow.getEl().mask();
                    Ext.Ajax.request({
                        url: '<%=request.getContextPath()%>/AddNewFeatureAction.do?param=addNewFeatureAddAndModify',
                        method: 'POST',
                        params: {
                            buttonValue: buttonValue,
                            systemIdFromJsp: Ext.getCmp('ltspComboId').getValue(),
                            processType: Ext.getCmp('processTypecomboId').getRawValue(),
                            processName: Ext.getCmp('processNamecomboId').getValue(),
                            subProcessName: Ext.getCmp('subProcessNamecomboId').getValue(),
                            menuGroupName: Ext.getCmp('menuGroupNamecomboId').getValue(),
                            pageTitle: Ext.getCmp('pageTitleId').getValue(),
                            pageTitleName: Ext.getCmp('pageLinkcomboId').getRawValue(),
                            pageLink: Ext.getCmp('pageLinkcomboId').getValue(),
                            secondSubProcessId: Ext.getCmp('subProcessStoreForSecondPanelComboId').getValue(),
                            secondMenuGroupId: Ext.getCmp('menuGroupNameComboForSecondPanelId').getValue(),
                            subProcessRawName: Ext.getCmp('subProcessNamecomboId').getRawValue()
                        },
                        success: function(response, options) {
                            var message = response.responseText;
                            Ext.example.msg(message);
                            Ext.getCmp('processTypecomboId').reset();
                            Ext.getCmp('processNamecomboId').reset();
                            Ext.getCmp('subProcessNamecomboId').reset();
                            Ext.getCmp('menuGroupNamecomboId').reset();
                            Ext.getCmp('pageLinkcomboId').reset();
                            Ext.getCmp('pageTitleId').reset();
                            Ext.getCmp('subProcessStoreForSecondPanelComboId').reset();
                            Ext.getCmp('menuGroupNameComboForSecondPanelId').reset();
                            myWinForSecondPanel.hide();
                            subProcessOuterPanelWindow.getEl().unmask();
                            store.load({
                                params: {
                                    systemIdFromJsp: Ext.getCmp('ltspComboId').getValue()
                                }
                            });
                            firstSavePanel = '';
                        },
                        failure: function() {
                            ctsb.setStatus({
                                text: getMessageForStatus("Error"),
                                iconCls: '',
                                clear: true
                            });
                            myWinForSecondPanel.hide();
                            firstSavePanel = '';
                        }
                    });
                }
            }
        }
    }, {
        xtype: 'button',
        text: '<%=Cancel%>',
        id: 'canButtIdForSecondPanel',
        cls: 'buttonstyle',
        iconCls: 'cancelbutton',
        width: 70,
        listeners: {
            click: {
                fn: function() {
                    firstSavePanel = '';
                    myWinForSecondPanel.hide();
                    Ext.getCmp('subProcessStoreForSecondPanelComboId').reset();
                    Ext.getCmp('menuGroupNameComboForSecondPanelId').reset();
                }
            }
        }
    }]
});

var subProcessOuterPanelWindow = new Ext.Panel({
    width: 410,
    height: 230,
    standardSubmit: true,
    frame: true,
    items: [secondPanelForSubProcessDetails, subProcessInnerWinButtonPanel]
});

myWinForSecondPanel = new Ext.Window({
    title: 'Sub Process Details',
    closable: false,
    resizable: false,
    modal: true,
    autoScroll: false,
    height: 290,
    width: 430,
    id: 'myWinForSecondPanelId',
    items: [subProcessOuterPanelWindow]
});

//----------------------------------------------------------------------END OF SECOND PANEL------------------------------------------------------------------------------------//

//-------------------------------------------------------------------POP FOR ADD ON PACKAGE-------------------------------------------------------------------------------------//
var subProcessIdStore = new Ext.data.SimpleStore({
    id: 'subProcessIdStoreId',
    autoLoad: true,
    fields: ['Name', 'Value'],
    data: [
        ['Actions', 'Actions'],
        ['Reports', 'Reports'],
        ['Preferences', 'Preferences']
    ]
});

var subProcessComboForAddOnPackage = new Ext.form.ComboBox({
    store: subProcessIdStore,
    id: 'subProcessComboForAddOnPackageId',
    mode: 'local',
    forceSelection: true,
    selectOnFocus: true,
    allowBlank: false,
    anyMatch: true,
    typeAhead: false,
    triggerAction: 'all',
    lazyRender: true,
    valueField: 'Value',
    emptyText: 'Select Sub Process',
    displayField: 'Name',
    cls: 'selectstylePerfect',
    listeners: {
        select: {
            fn: function() {
           // alert("1st Sub Process"  +Ext.getCmp('processNamecomboId').getRawValue());
          //  alert("2st Sub Process"  +Ext.getCmp('subProcessComboForAddOnPackageId').getRawValue());
             menuGroupNameStoreForAddOnPackage.load({
                                params: {
                                    processNameFromFirstPanel: Ext.getCmp('processNamecomboId').getRawValue(),
				                    subProcessRawNameFromSecondPanel: Ext.getCmp('subProcessComboForAddOnPackageId').getRawValue()
                                }
                            });
            

            }
        }
    }
});

var menuGroupNameStoreForAddOnPackage = new Ext.data.JsonStore({
    url: '<%=request.getContextPath()%>/AddNewFeatureAction.do?param=getMenuGroupNameForAddOnPackage',
    id: 'menuGroupNameComboForAddOnPackageId',
    root: 'menuGroupNameComboForAddOnPackageRoot',
    autoload: true,
    remoteSort: true,
    fields: ['menuGroupNameComboForAddOnPackageId', 'menuGroupNameComboForAddOnPackageName'],
    listeners: {}
});

var menuGroupComboForAddOnPackage = new Ext.form.ComboBox({
    store: menuGroupNameStoreForAddOnPackage,
    id: 'menuGroupNameStoreForAddOnPackageId',
    mode: 'local',
    forceSelection: true,
    selectOnFocus: true,
    allowBlank: false,
    anyMatch: true,
    typeAhead: false,
    triggerAction: 'all',
    lazyRender: true,
    emptyText: 'Select Sub Process',
    displayField: 'menuGroupNameComboForAddOnPackageName',
    valueField: 'menuGroupNameComboForAddOnPackageId',
    cls: 'selectstylePerfect',
    listeners: {
        select: {
            fn: function() {
                
            }
        }
    }
});

var secondPanelForAddOnPackage = new Ext.form.FormPanel({
    standardSubmit: true,
    collapsible: false,
    autoScroll: true,
    height: 150,
    width: 400,
    frame: true,
    id: 'secondPanelForAddOnPackageId',
    layout: 'table',
    layoutConfig: {
        columns: 4
    },
    items: [{
        xtype: 'fieldset',
        title: 'Add On Package Information',
        cls: 'fieldsetpanel',
        collapsible: false,
        colspan: 3,
        id: 'addOnPackageInformationId',
        width: 360,
        layout: 'table',
        layoutConfig: {
            columns: 3
        },
        items: [{
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'SubProcessNameIdForAddOnPackage1'
        }, {
            xtype: 'label',
            text: '<%=SubProcessName%>' + ' :',
            cls: 'labelstyle',
            id: 'SubProcessNameIdForAddOnPackage'
        }, subProcessComboForAddOnPackage, {
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'menuGroupNameEmptyId1ForAddOnPackage'
        }, {
            xtype: 'label',
            text: '<%=MenuGroupName%>' + ' :',
            cls: 'labelstyle',
            id: 'menuGroupNameLabelIdForAddOnPackage'
        }, menuGroupComboForAddOnPackage]
    }]
});

var AddOnPackageInnerWinButtonPanel = new Ext.Panel({
    id: 'AddOnPackageInnerWinButtonPanelId',
    standardSubmit: true,
    collapsible: false,
    autoHeight: true,
    height: 80,
    width: 400,
    frame: true,
    layout: 'table',
    layoutConfig: {
        columns: 4
    },
    buttons: [{
        xtype: 'button',
        text: '<%=Save%>',
        id: 'saveButtonIdForAddOnPackage',
        cls: 'buttonstyle',
        iconCls: 'savebutton',
        width: 70,
        listeners: {
            click: {
                fn: function() {
                    if (Ext.getCmp('subProcessComboForAddOnPackageId').getValue() == "") {
                        Ext.example.msg("<%=SelectSubProcessName%>");
                        return;
                    }
                    if (Ext.getCmp('menuGroupNameStoreForAddOnPackageId').getValue() == "") {
                        Ext.example.msg("<%=SelectMenuGroupName%>");
                        return;
                    }
                 //   alert(Ext.getCmp('subProcessComboForAddOnPackageId').getRawValue());
               //     alert(Ext.getCmp('menuGroupNameStoreForAddOnPackageId').getValue());
                    AddOnPackageOuterPanelWindow.getEl().mask();
                    Ext.Ajax.request({
                        url: '<%=request.getContextPath()%>/AddNewFeatureAction.do?param=addNewFeatureAddAndModify',
                        method: 'POST',
                        params: {
                            buttonValue: buttonValue,
                            systemIdFromJsp: Ext.getCmp('ltspComboId').getValue(),
                            processType: Ext.getCmp('processTypecomboId').getRawValue(),
                            processName: Ext.getCmp('processNamecomboId').getValue(),
                            subProcessName: Ext.getCmp('subProcessNamecomboId').getValue(),
                            menuGroupName: Ext.getCmp('menuGroupNamecomboId').getValue(),
                            pageTitle: Ext.getCmp('pageTitleId').getValue(),
                            pageTitleName: Ext.getCmp('pageLinkcomboId').getRawValue(),
                            pageLink: Ext.getCmp('pageLinkcomboId').getValue(),
                            secondSubProcessIdForAddOnPackage: Ext.getCmp('subProcessComboForAddOnPackageId').getRawValue(),
                            secondMenuGroupIdForAddOnPackage: Ext.getCmp('menuGroupNameStoreForAddOnPackageId').getValue(),
                            subProcessRawName: Ext.getCmp('subProcessNamecomboId').getRawValue()
                        },
                        success: function(response, options) {
                            var message = response.responseText;
                            Ext.example.msg(message);
                            Ext.getCmp('processTypecomboId').reset();
                            Ext.getCmp('processNamecomboId').reset();
                            Ext.getCmp('subProcessNamecomboId').reset();
                            Ext.getCmp('menuGroupNamecomboId').reset();
                            Ext.getCmp('pageLinkcomboId').reset();
                            Ext.getCmp('pageTitleId').reset();
                            Ext.getCmp('subProcessComboForAddOnPackageId').reset();
                            Ext.getCmp('menuGroupNameStoreForAddOnPackageId').reset();
                            myWinForAddOnPackage.hide();
                            AddOnPackageOuterPanelWindow.getEl().unmask();
                            store.load({
                                params: {
                                    systemIdFromJsp: Ext.getCmp('ltspComboId').getValue()
                                }
                            });
                           firstSavePanel1='';
                        },
                        failure: function() {
                            ctsb.setStatus({
                                text: getMessageForStatus("Error"),
                                iconCls: '',
                                clear: true
                            });
                            myWinForAddOnPackage.hide();
                          firstSavePanel1='';
                        }
                    });
                }
            }
        }
    }, {
        xtype: 'button',
        text: '<%=Cancel%>',
        id: 'canButtIdForAddOnPackage',
        cls: 'buttonstyle',
        iconCls: 'cancelbutton',
        width: 70,
        listeners: {
            click: {
                fn: function() {
                   firstSavePanel1='';
                    myWinForAddOnPackage.hide();
                             Ext.getCmp('subProcessComboForAddOnPackageId').reset();
                            Ext.getCmp('menuGroupNameStoreForAddOnPackageId').reset();
                 }
            }
        }
    }]
});

var AddOnPackageOuterPanelWindow = new Ext.Panel({
    width: 410,
    height: 230,
    standardSubmit: true,
    frame: true,
    items: [secondPanelForAddOnPackage, AddOnPackageInnerWinButtonPanel]
});

myWinForAddOnPackage = new Ext.Window({
    title: 'Sub Process Details',
    closable: false,
    resizable: false,
    modal: true,
    autoScroll: false,
    height: 290,
    width: 430,
    id: 'myWinForAddOnPackage',
    items: [AddOnPackageOuterPanelWindow]
});


//-------------------------------------------------------------------END OF POP UP PANEL FOR ADD ON PACKAGE---------------------------------------------------------------------//

var innerWinButtonPanel = new Ext.Panel({
    id: 'innerWinButtonPanelId',
    standardSubmit: true,
    collapsible: false,
    autoHeight: true,
    height: 80,
    width: 400,
    frame: true,
    layout: 'table',
    layoutConfig: {
        columns: 4
    },
    buttons: [{
        xtype: 'button',
        text: '<%=Save%>',
        id: 'saveButtonId',
        cls: 'buttonstyle',
        iconCls: 'savebutton',
        width: 70,
        listeners: {
            click: {
                fn: function() {
                    if (Ext.getCmp('ltspComboId').getValue() == "") {
                        Ext.example.msg("<%=SelectLTSP%>");
                        return;
                    }
                    if (Ext.getCmp('processTypecomboId').getValue() == "") {
                        Ext.example.msg("<%=SelectProcessType%>");
                        return;
                    }
                    if (Ext.getCmp('processNamecomboId').getValue() == "") {
                        Ext.example.msg("<%=SelectProcessName%>");
                        return;
                    }
                    if (Ext.getCmp('subProcessNamecomboId').getValue() == "") {
                        Ext.example.msg("<%=SelectSubProcessName%>");
                        return;
                    }
                    if (Ext.getCmp('menuGroupNamecomboId').getValue() == "") {
                        Ext.example.msg("<%=SelectMenuGroupName%>");
                        return;
                    }
                    if (Ext.getCmp('pageTitleId').getValue() == "") {
                        Ext.example.msg("<%=EnterPageTitle%>");
                        return;
                    }
                    if (Ext.getCmp('pageLinkcomboId').getValue() == "") {
                        Ext.example.msg("<%=SelectPageLink%>");
                        return;
                    }
                    if (Ext.getCmp('processTypecomboId').getValue() == 'Vertical_Sol' 
                    	&& !(Ext.getCmp('subProcessNamecomboId').getRawValue().trim() == 'Vertical_Dashboard' || Ext.getCmp('subProcessNamecomboId').getRawValue() == 'Mapview' 
                    		|| Ext.getCmp('subProcessNamecomboId').getRawValue() == 'Alerts' || Ext.getCmp('subProcessNamecomboId').getRawValue() == 'Actions' 
                    		|| Ext.getCmp('subProcessNamecomboId').getRawValue() == 'Preferences' || Ext.getCmp('subProcessNamecomboId').getRawValue() == 'Administration' 
                    		|| Ext.getCmp('subProcessNamecomboId').getRawValue() == 'None' || Ext.getCmp('subProcessNamecomboId').getRawValue() == 'Analytics' 
                    		&& !(Ext.getCmp('subProcessNamecomboId').getRawValue() == 'Reports' && Ext.getCmp('subProcessNamecomboId').geValue() == '50'))) {
                        myWin.hide();
                        myWinForSecondPanel.show();
                        firstSavePanel = '1';
                    }
                 //   alert(Ext.getCmp('processTypecomboId').getValue());
                    if(Ext.getCmp('processTypecomboId').getValue() == 'Add_On_Pkg')
                    {
                       myWin.hide();
                       myWinForAddOnPackage.show();
                       firstSavePanel1 = '2';
                    }
                    
                    
                    
                    
                  //   alert(firstSavePanel);
                 //    alert(firstSavePanel1);
                    if (firstSavePanel != '1' && firstSavePanel1 !='2') {
                   // alert('inside 1st save');
                        if (innerPanelForltspDetails.getForm().isValid()) {
                            ltspOuterPanelWindow.getEl().mask();
                            Ext.Ajax.request({
                                url: '<%=request.getContextPath()%>/AddNewFeatureAction.do?param=addNewFeatureAddAndModify',
                                method: 'POST',
                                params: {
                                    buttonValue: buttonValue,
                                    systemIdFromJsp: Ext.getCmp('ltspComboId').getValue(),
                                    processType: Ext.getCmp('processTypecomboId').getRawValue(),
                                    processName: Ext.getCmp('processNamecomboId').getValue(),
                                    subProcessName: Ext.getCmp('subProcessNamecomboId').getValue(),
                                    menuGroupName: Ext.getCmp('menuGroupNamecomboId').getValue(),
                                    pageTitle: Ext.getCmp('pageTitleId').getValue(),
                                    pageTitleName: Ext.getCmp('pageLinkcomboId').getRawValue(),
                                    pageLink: Ext.getCmp('pageLinkcomboId').getValue(),
                                    subProcessRawName: Ext.getCmp('subProcessNamecomboId').getRawValue()
                                },
                                success: function(response, options) {
                                    var message = response.responseText;
                                    Ext.example.msg(message);
                                    Ext.getCmp('processTypecomboId').reset();
                                    Ext.getCmp('processNamecomboId').reset();
                                    Ext.getCmp('subProcessNamecomboId').reset();
                                    Ext.getCmp('menuGroupNamecomboId').reset();
                                    Ext.getCmp('pageLinkcomboId').reset();
                                    Ext.getCmp('pageTitleId').reset();
                                    myWin.hide();
                                    ltspOuterPanelWindow.getEl().unmask();
                                    store.load({
                                        params: {
                                            systemIdFromJsp: Ext.getCmp('ltspComboId').getValue()
                                        }
                                    });
                                },
                                failure: function() {
                                    ctsb.setStatus({
                                        text: getMessageForStatus("Error"),
                                        iconCls: '',
                                        clear: true
                                    });
                                    myWin.hide();
                                }
                            });
                        }
                    }
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

var ltspOuterPanelWindow = new Ext.Panel({
    width: 410,
    height: 320,
    standardSubmit: true,
    frame: true,
    items: [innerPanelForltspDetails, innerWinButtonPanel]
});

myWin = new Ext.Window({
    title: titelForInnerPanel,
    closable: false,
    resizable: false,
    modal: true,
    autoScroll: false,
    height: 370,
    width: 430,
    id: 'myWin',
    items: [ltspOuterPanelWindow]
});

function addRecord() {
    if (Ext.getCmp('ltspComboId').getValue() == "") {
        Ext.example.msg("<%=SelectLTSP%>");
        return;
    }
    processNameStore.load({
        params: {
            // processType: Ext.getCmp('processTypecomboId').getValue()
        }
    });
    subProcessNameStore.load({
        params: {
            // processId: Ext.getCmp('processNamecomboId').getValue()
        }
    });
    menuGroupNameStore.load({
        params: {
            //  subProcessId: Ext.getCmp('subProcessNamecomboId').getValue()
        }
    });
    buttonValue = '<%=Add%>';
    titelForInnerPanel = '<%=AddFeatureDetails%>';
    myWin.setPosition(450, 150);
    myWin.show();
    myWin.setTitle(titelForInnerPanel);
    Ext.getCmp('processTypecomboId').reset();
    Ext.getCmp('processNamecomboId').reset();
    Ext.getCmp('subProcessNamecomboId').reset();
    Ext.getCmp('menuGroupNamecomboId').reset();
    Ext.getCmp('pageLinkcomboId').reset();
    Ext.getCmp('pageTitleId').reset();
    Ext.getCmp('subProcessStoreForSecondPanelComboId').reset();
    Ext.getCmp('menuGroupNameComboForSecondPanelId').reset();
}

function deleteData() {
//alert(Ext.getCmp('ltspComboId').getValue());
  
    if (Ext.getCmp('ltspComboId').getValue() == "") {
        Ext.example.msg("<%=SelectLTSP%>");
        return;
    }
    if (grid.getSelectionModel().getCount() == 0) {
        Ext.example.msg("<%=NoRowsSelected%>");
        return;
    }
    if (grid.getSelectionModel().getCount() > 1) {
        Ext.example.msg("<%=SelectSingleRow%>");
        return;
    }
     if(Ext.getCmp('ltspComboId').getValue() !='0')
   {
      Ext.example.msg("Cannot Delete For Particular System Id");
      return;
   }
    Ext.Msg.show({
        title: 'Delete',
        msg: '<%=Areyousureyouwanttodelete%>',
        buttons: {
            yes: true,
            no: true
        },
        fn: function(btn) {
            switch (btn) {
                case 'yes':
                    var selected = grid.getSelectionModel().getSelected();
                    processId = selected.get('processNamecomboId');
                    //  alert(selected.get('pageLinkDataIndex'));
                    outerPanel.getEl().mask();
                    Ext.Ajax.request({
                        url: '<%=request.getContextPath()%>/AddNewFeatureAction.do?param=deleteAddFeatureDetails',
                        method: 'POST',
                        params: {
                            buttonValue: buttonValue,
                            systemIdFromJsp: Ext.getCmp('ltspComboId').getValue(),
                            processName: processId,
                            pageLink: selected.get('pageLinkDataIndex')
                        },
                        success: function(response, options) {
                            var message = response.responseText;
                            Ext.example.msg(message);
                            outerPanel.getEl().unmask();
                            store.load({
                                params: {
                                    systemIdFromJsp: Ext.getCmp('ltspComboId').getValue()
                                }
                            });
                        },
                        failure: function() {
                            ctsb.setStatus({
                                text: getMessageForStatus("Error"),
                                iconCls: '',
                                clear: true
                            });
                            store.reload();
                        }
                    });
                    break;
                case 'no':
                    Ext.example.msg("<%=NotDeleted%>");
                    store.reload();
                    break;
            }
        }
    });
}

var reader = new Ext.data.JsonReader({
    idProperty: 'ownMasterid',
    root: 'ltspMasterRoot',
    totalProperty: 'total',
    fields: [{
        name: 'slnoIndex'
    }, {
        name: 'processTypeIndex'
    }, {
        name: 'processNameDataIndex'
    }, {
        name: 'subProcessNameDataIndex'
    }, {
        name: 'menuGroupNameDataIndex'
    }, {
        name: 'pageTitleDataIndex'
    }, {
        name: 'pageLinkDataIndex'
    }]
});

var store = new Ext.data.GroupingStore({
    autoLoad: false,
    proxy: new Ext.data.HttpProxy({
        url: '<%=request.getContextPath()%>/AddNewFeatureAction.do?param=getAddNewFeatureReport',
        method: 'POST'
    }),
    storeId: 'ownersId',
    reader: reader
});

var filters = new Ext.ux.grid.GridFilters({
    local: true,
    filters: [{
        type: 'numeric',
        dataIndex: 'slnoIndex'
    }, {
        type: 'string',
        dataIndex: 'processTypeIndex'
    }, {
        type: 'string',
        dataIndex: 'processNameDataIndex'
    }, {
        type: 'string',
        dataIndex: 'subProcessNameDataIndex'
    }, {
        type: 'string',
        dataIndex: 'menuGroupNameDataIndex'
    }, {
        type: 'string',
        dataIndex: 'pageTitleDataIndex'
    }, {
        type: 'string',
        dataIndex: 'pageLinkDataIndex'
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
        }, {
            header: "<span style=font-weight:bold;><%=ProcessType%></span>",
            dataIndex: 'processTypeIndex',
            width: 100,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=ProcessName%></span>",
            dataIndex: 'processNameDataIndex',
            width: 100,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=SubProcessName%></span>",
            dataIndex: 'subProcessNameDataIndex',
            width: 100,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=MenuGroupName%></span>",
            dataIndex: 'menuGroupNameDataIndex',
            width: 100,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=PageTitle%></span>",
            dataIndex: 'pageTitleDataIndex',
            width: 100,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=PageLink%></span>",
            dataIndex: 'pageLinkDataIndex',
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
grid = getGrid('<%=MenuDetails%>', '<%=NoRecordsFound%>', store, screen.width - 40, 440, 10, filters, '<%=ClearFilterData%>', false, '', 16, false, '', false, '', false, 'Excel', jspName, exportDataType, false, 'PDF', true, '<%=Add%>', false, '<%=Modify%>', true, '<%=Delete%>');
//******************************************************************************************************************************************************
Ext.onReady(function() {
    ctsb = tsb;
    Ext.QuickTips.init();
    Ext.form.Field.prototype.msgTarget = 'side';
    outerPanel = new Ext.Panel({
        title: '<%=AddNewFeaturetoLTSP%>',
        renderTo: 'content',
        standardSubmit: true,
        frame: true,
        width: screen.width - 22,
        cls: 'outerpanel',
        layout: 'table',
        layoutConfig: {
            columns: 1
        },
        items: [ltspPanel, grid]
      //  bbar: ctsb
    });
    sb = Ext.getCmp('form-statusbar');
});
</script>
</body>
</html>
<%}%>
    
    
    
    

