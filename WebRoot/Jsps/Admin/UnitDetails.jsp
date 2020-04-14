<%@ page language="java"
	import="java.util.*,t4u.functions.CommonFunctions,t4u.beans.*,t4u.common.*"
	pageEncoding="utf-8"%>
<%@page import="t4u.util.MapAPIUtil"%>
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
	LoginInfoBean loginInfo1=new LoginInfoBean();
	loginInfo1=(LoginInfoBean)session.getAttribute("loginInfoDetails");
	if(loginInfo1!=null)
	{
	int mapType=loginInfo1.getMapType();
	loginInfo.setMapType(mapType);
	}
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
	loginInfo.setStyleSheetOverride(str[11].trim());
	loginInfo.setIsLtsp(Integer.parseInt(str[12].trim()));
	loginInfo.setNewMenuStyle(str[13].trim());
	MapAPIUtil mapAPIUtil = new MapAPIUtil();
	MapAPIConfigBean bean = mapAPIUtil.getConfiguration(systemid);
	loginInfo.setMapAPIConfig(bean);
	}
	session.setAttribute("loginInfoDetails",loginInfo);
}
CommonFunctions cf=new CommonFunctions();
  Properties properties = ApplicationListener.prop;
  String LtspsToBlockUnitPage = properties.getProperty("LtspsToBlockUnitPage").trim();
	
  String[] str=LtspsToBlockUnitPage.split(",");
  List<String> systemList=Arrays.asList(str);
LoginInfoBean loginInfo=(LoginInfoBean)session.getAttribute("loginInfoDetails");
String language = loginInfo.getLanguage();
	int systemId = loginInfo.getSystemId();
	int customerId = loginInfo.getCustomerId();
	int userId = loginInfo.getUserId();
String userAuthority=cf.getUserAuthority(systemId,userId);

if(loginInfo==null){
	response.sendRedirect(request.getContextPath()+ "/Jsps/Common/SessionDestroy.html");
}
else if(systemList.contains(String.valueOf(loginInfo.getSystemId())))
{
	response.sendRedirect(path + "/Jsps/Common/401Error.html");
}
else
{
session.setAttribute("loginInfoDetails",loginInfo);
	String customerName=loginInfo.getCustomerName();
	
  ArrayList<String> tobeConverted = new ArrayList<String>();
  tobeConverted.add("Unit_Details");
  tobeConverted.add("Select_Manufcaturer");
  tobeConverted.add("Select_UnitType");
  tobeConverted.add("Unit_Details_Information");
  tobeConverted.add("Unit_Number");
  tobeConverted.add("Enter_Unit_Number");
  tobeConverted.add("Manufaturer");
  tobeConverted.add("Unit_Type");
  tobeConverted.add("Unit_Reference_Id");
  tobeConverted.add("Enter_Unit_ReferenceID");
  tobeConverted.add("Created_Date_And_Time");
  tobeConverted.add("Status");
  tobeConverted.add("Save");
  tobeConverted.add("Select_Date_and_Time");
  tobeConverted.add("Select_Status");
  tobeConverted.add("Cancel");
  tobeConverted.add("Add_Unit_Details");
  tobeConverted.add("Select_Single_Row");
  tobeConverted.add("No_Rows_Selected");
  tobeConverted.add("Delete_Unit_Details");
  tobeConverted.add("Are_you_sure_you_want_to_delete");
  tobeConverted.add("SLNO");
  tobeConverted.add("Modify");
  tobeConverted.add("No_Records_Found");
  tobeConverted.add("Add");
  tobeConverted.add("Delete");
  tobeConverted.add("Remarks");
  tobeConverted.add("Valid_Status");
  tobeConverted.add("Get_Standard_Format");
  tobeConverted.add("Close");
  tobeConverted.add("Clear");
  tobeConverted.add("Import_Unit");
  tobeConverted.add("Select_Mobile_No");
  tobeConverted.add("Mobile_No");
  tobeConverted.add("Transparent_Mode");
  tobeConverted.add("Select_Transparent_Mode");
  tobeConverted.add("IMSI");
  
  
ArrayList<String> convertedWords = new ArrayList<String>();
convertedWords = cf.getLanguageSpecificWordForKey(tobeConverted,language);
 
String UnitDetails = convertedWords.get(0);
String SelectManufcaturer = convertedWords.get(1);
String selectUnitType = convertedWords.get(2);
String UnitDetailsInformation = convertedWords.get(3);
String UnitNumber = convertedWords.get(4);
String EnterUnitNumber = convertedWords.get(5);
String Manufaturer = convertedWords.get(6);
String UnitType = convertedWords.get(7);
String UnitReferenceId = convertedWords.get(8); 
String EnterUnitReferenceID=convertedWords.get(9); 
String CreatedDateAndTime = convertedWords.get(10);
String Status = convertedWords.get(11);
String Save = convertedWords.get(12);
String SelectDateandTime = convertedWords.get(13);
String SelectStatus = convertedWords.get(14);
String Cancel = convertedWords.get(15); 
String AddUnitDetails = convertedWords.get(16);
String selectSingleRow = convertedWords.get(17); 
String noRowsSelected = convertedWords.get(18);
String DeleteUnitDetails = convertedWords.get(19);
String Areyousureyouwanttodelete = convertedWords.get(20); 
String SLNO = convertedWords.get(21);
String Modify = convertedWords.get(22); 
String NoRecordsFound = convertedWords.get(23); 
String Add = convertedWords.get(24); 
String Delete = convertedWords.get(25); 
String Remarks = convertedWords.get(26);
String ValidStatus = convertedWords.get(27);
String GetStandardFormat = convertedWords.get(28);
String Close = convertedWords.get(29);
String Clear = convertedWords.get(30);
String ImportUnit = convertedWords.get(31);
String SelectMobileNo = convertedWords.get(32);
String MobileNo = convertedWords.get(33);
String TransMode1 = convertedWords.get(34);
String SelectTransMode = convertedWords.get(35);
String IMSI = convertedWords.get(36);
%>

<!DOCTYPE HTML>
<html>
	<head>
		<base href="<%=basePath%>">

		<title><%=UnitDetails%></title>
<style>
.x-panel-tl {
	border-bottom: 0px solid !important;
}
.x-form-file-wrap .x-form-file {
	position: absolute;
	right: 0;
	-moz-opacity: 0;
	filter:alpha(opacity: 0);
	opacity: 0;
	z-index: 2;
    height: 22px;
    cursor: pointer;
}
.x-form-file-wrap .x-form-file-btn {
	position: absolute;
	right: 0;
	z-index: 1;
}
.x-form-file-wrap .x-form-file-text {
    position: absolute;
    left: 0;
    z-index: 3;
    color: #777;
}
<%
	String ua = request.getHeader("User-Agent");
	boolean isMSIE10 = (ua != null && ua.indexOf("MSIE 10") != -1);
	boolean isMSIE9 = (ua != null && ua.indexOf("MSIE 9") != -1);
	boolean isMSIE8 = (ua != null && ua.indexOf("MSIE 8") != -1);
	if(isMSIE10 || isMSIE9 || isMSIE8){
%>
#ext-gen127{
width:70px;
}
<%}else{%>
#ext-gen126{
width:70px;
}
<%}%>
.x-form-field-wrap{
 height: 35px;
}
<%if (loginInfo.getStyleSheetOverride().equals("Y")){%>
.x-form-file-wrap .x-form-file {
height:35px;
}
#filePath{
height:30px;
}
<%}%>
</style>	
	</head>
	<body>
		<%if (loginInfo.getStyleSheetOverride().equals("Y")){%>
		<jsp:include page="../Common/ImportJSSandMining.jsp"/>
		<%}else {%>
		<jsp:include page="../Common/ImportJS.jsp" /><%} %>
		<jsp:include page="../Common/ExportJS.jsp" />
<script>
 var pageName='<%=UnitDetails%>';
 Ext.Ajax.timeout = 360000;
/*******************resize window event function**********************/
Ext.EventManager.onWindowResize(function () {
    var width = '100%';
    var height = '100%';
    grid.setSize(width, height);
    outerPanel.setSize(width, height);
    outerPanel.doLayout();
});
var dtcur = datecur;
var dtprev = dateprev;
var outerPanel;
var ctsb;
var jspName ="UnitDetails";
var exportDataType = "int,String,string,string,string,string,string";
var selected;
var grid;
var buttonValue;
var unitResponseImportData;
/**********************************************RfidStore****************************************/
var Rfidcombostore = new Ext.data.SimpleStore({
    id: 'RfidcombostoreId',
    autoLoad: true,
    fields: ['Name', 'Value'],
    data: [
        ['ACTIVE', 'ACTIVE'],
        ['INACTIVE', 'INACTIVE']
    ]
});
/*********************************RfidCombo********************************************/
var Rfidcombo = new Ext.form.ComboBox({
    store: Rfidcombostore,
    id: 'RfidcomboId',
    mode: 'local',
    forceSelection: true,
    selectOnFocus: true,
    allowBlank: false,
    anyMatch: true,
    typeAhead: false,
    triggerAction: 'all',
    lazyRender: true,
    valueField: 'Value',
    value: 'ACTIVE',
    displayField: 'Name',
    cls: 'selectstylePerfect'
});

/**************************************unitType List***********************************/
var unittypestore = new Ext.data.JsonStore({
    url: '<%=request.getContextPath()%>/UnitDetailsAction.do?param=getunittypes',
    id: 'UnitTypeStoreId',
    root: 'unitTypeRoot',
    autoLoad: false,
    fields: ['UnitTypeCode', 'UnitTypeDesc']
});

/**************************************combo unitType List***********************************/
var unitTypecombo = new Ext.form.ComboBox({
    store: unittypestore,
    id: 'unittypecomboId',
    mode: 'local',
    hidden: false,
    forceSelection: true,
    blankText: '<%=selectUnitType%>',
    emptyText: '<%=selectUnitType%>',
    allowBlank: false,
    anyMatch: true,
    typeAhead: false,
    triggerAction: 'all',
    valueField: 'UnitTypeCode',
    displayField: 'UnitTypeDesc',
    cls: 'selectstylePerfect',
    listeners: {
        select: {
            fn: function () {
                unitType: Ext.getCmp('unittypecomboId').getValue();
            }
        }
    }
});

/**************store for getting Manufaturer List******************/
var manufactrerstore = new Ext.data.JsonStore({
    url: '<%=request.getContextPath()%>/UnitDetailsAction.do?param=getManufacturer',
    id: 'manufacturerStoreId',
    root: 'manufacturerRoot',
    autoLoad: true,
    fields: ['id', 'name']
});
/*******************************comobo for Manufacturer****************/
var manufacturercombo = new Ext.form.ComboBox({
    store: manufactrerstore,
    id: 'manufacturerCode',
    mode: 'local',
    hidden: false,
    forceSelection: true,
    blankText: '<%=SelectManufcaturer%>',
    emptyText: '<%=SelectManufcaturer%>',
    selectOnFocus: true,
    allowBlank: false,
    anyMatch: true,
    typeAhead: false,
    triggerAction: 'all',
    valueField: 'id',
    displayField: 'name',
    cls: 'selectstylePerfect',
    listeners: {
        select: {
            fn: function () {
                Ext.getCmp('unittypecomboId').reset();
                if(Ext.getCmp('manufacturerCode').getValue()==32){
                    Ext.getCmp('mandatoryUnitreferenceNoId').setText('*');
                    Ext.getCmp('mandatorymobileNoId').show();
                	Ext.getCmp('mobileNoTxtId').show();
                	Ext.getCmp('mobileNocomboId').show();
                	if(buttonValue=='modify'){
               	      if(grid.getSelectionModel().getSelected().get('predefinedMobileNum')==""){
               	      	Ext.getCmp('mobileNocomboId').reset();
               	      }else{
                		Ext.getCmp('mobileNocomboId').setValue(grid.getSelectionModel().getSelected().get('predefinedMobileNum'));
                	  }
	                }
                	mobileNumberStore.load();
                    
                }else{
                 	Ext.getCmp('mandatoryUnitreferenceNoId').setText('');
                 	Ext.getCmp('mandatorymobileNoId').hide();
                	Ext.getCmp('mobileNoTxtId').hide();
                	Ext.getCmp('mobileNocomboId').hide();
                }
                unittypestore.load({
                    params: {
                        manufacturerCode: Ext.getCmp('manufacturerCode').getValue()
                    }
                });
            }
        }
    }
});

/********************* Combo for Mobile Number (CLA) *******************************/
 var mobileNumberStore = new Ext.data.JsonStore({
       url: '<%=request.getContextPath()%>/UnitDetailsAction.do?param=getMobileNoForCLA',
       id: 'mobileNoId',
       root: 'mobileNoRoot',
       autoload: true,
       remoteSort: true,
       fields: ['MobileNumber', 'SimNumber', 'ServiceProvider'],
       listeners: {
           load: function() {}
       }
   });
   
   var mobileNumberCombo = new Ext.form.ComboBox({
       store: mobileNumberStore,
       id: 'mobileNocomboId',
       mode: 'local',
       hidden: true,
       forceSelection: true,
       emptyText: '<%=SelectMobileNo%>',
       blankText: '<%=SelectMobileNo%>',
       selectOnFocus: true,
       allowBlank: false,
       anyMatch: true,
       typeAhead: false,
       triggerAction: 'all',
       value: 'None',
       lazyRender: true,
       valueField: 'MobileNumber',
       displayField: 'MobileNumber',
       cls: 'selectstylePerfect'
   });

/**********************************************TransparentModeStore****************************************/
var transparentmodecombostore = new Ext.data.SimpleStore({
    id: 'transparentmodecombostoreId',
    autoLoad: true,
    fields: ['Name', 'Value'],
    data: [
        ['ACTIVE', 'ACTIVE'],
        ['INACTIVE', 'INACTIVE']
    ]
});
/*********************************TransparentCombo********************************************/
var transparentcombo = new Ext.form.ComboBox({
    store: transparentmodecombostore,
    id: 'transparentcomboId',
    mode: 'local',
    forceSelection: true,
    selectOnFocus: true,
    allowBlank: false,
    anyMatch: true,
    typeAhead: false,
    triggerAction: 'all',
    lazyRender: true,
    valueField: 'Value',
    value: 'INACTIVE',
    displayField: 'Name',
    cls: 'selectstylePerfect'
});
/*********************inner panel for displaying form field in window***********************/
var innerPanelForUnitDetails = new Ext.form.FormPanel({
    standardSubmit: true,
    collapsible: false,
    autoScroll: true,
    height: 270,
    width: 490,
    frame: true,
    id: 'custMaster',
    layout: 'table',
    labelWidth: 200,
    layoutConfig: {
        columns: 4
    },
    items: [{
        xtype: 'fieldset',
        title: '<%=UnitDetailsInformation%>',
       // cls: 'fieldsetpanel',
        collapsible: false,
        colspan: 3,
        id: 'addpanelid',
        width: 478,
        layout: 'table',
        layoutConfig: {
            columns: 4,
            tableAttrs: {
		            style: {
		                width: '90%'
		            }
        			}
        },
        items: [{
                xtype: 'label',
                text: '*',
                cls: 'mandatoryfield',
                id: 'mandatoryUnitNoId'
            },{
                xtype: 'label',
                text: '<%=UnitNumber%>' + ':',
                cls: 'labelstyle',
                id: 'UnitNoid'
            },  {
                xtype: 'textfield',
                allowBlank: false,
                allowDecimals: false,
                 maxLength: 15,
                cls: 'selectstylePerfect',
                emptyText: '<%=EnterUnitNumber%>',
                blankText: '<%=EnterUnitNumber%>',
                id: 'UnitNoId'
            },{},{
                xtype: 'label',
                text: '*',
                cls: 'mandatoryfield',
                id: 'ManufaturerId'
            }, {
                xtype: 'label',
                text: '<%=Manufaturer%>' + ' :',
                cls: 'labelstyle',
                id: 'labelManufaturerId'
            }, 
            manufacturercombo,{},
             {
                xtype: 'label',
                text: '*',
                cls: 'mandatoryfield',
                id: 'UnitTypeId'
            },{
                xtype: 'label',
                text: '<%=UnitType%>' + ' :',
                cls: 'labelstyle',
                id: 'labelUnitTypeId'
            }, 
            unitTypecombo,{},
             {
                xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                id: 'mandatoryUnitreferenceNoId'
            },
            {
                xtype: 'label',
                text: '<%=UnitReferenceId%>' + ':',
                cls: 'labelstyle',
                id: 'UnitRefNoid'
            }, {
                xtype: 'textfield',
                //regex: validate('alphanumericname'),
                //allowBlank:false,
                allowDecimals: false,
                 maxLength: 50,
                cls: 'selectstylePerfect',
                emptyText: '<%=EnterUnitReferenceID%>',
                blankText: '<%=EnterUnitReferenceID%>',
                id: 'UnitReferenceNoId'
            },{}, {
                xtype: 'label',
                text: '*',
                cls: 'mandatoryfield',
                id: 'RfId'
            },{
                xtype: 'label',
                text: '<%=Status%>' + ' :',
                cls: 'labelstyle',
                id: 'labelRfidConnectivityId'
            }, 
            Rfidcombo,{},
             {
               xtype: 'label',
               text: '*',
               hidden: true,
               cls: 'mandatoryfield',
               id: 'mandatorymobileNoId'
           },{
               xtype: 'label',
               hidden: true,
               text: '<%=MobileNo%>' + ' :',
               cls: 'labelstyle',
               id: 'mobileNoTxtId'
           },
           mobileNumberCombo, {},{
               xtype: 'label',
               text: '*',
               cls: 'mandatoryfield',
               id: 'mandatorytransparentModeId'
           },{
                xtype: 'label',
                text: '<%=TransMode1%>' + ' :',
                cls: 'labelstyle',
                id: 'labelTransperentModeId'
            }, 
            transparentcombo,{}
        ]
    }]
});

/********************************button**************************************/
var innerWinButtonPanel = new Ext.Panel({
    id: 'winbuttonid',
    standardSubmit: true,
    collapsible: false,
    autoHeight: true,
    height: 100,
    width: 490,
    frame: true,
    layout: 'table',
    layoutConfig: {
        columns: 4
    },
    buttons: [{
        xtype: 'button',
        text: '<%=Save%>',
        id: 'addButtId',
        iconCls:'savebutton',
        cls: 'buttonstyle',
        width: 70,
        listeners: {
            click: {
                fn: function () {


                    if (Ext.getCmp('UnitNoId').getValue() == "") {
                    Ext.example.msg("<%=EnterUnitNumber%>");
                       
                        return;
                    }
					var mobileNum=null;
					
                    if (Ext.getCmp('manufacturerCode').getValue() == "") {
                    Ext.example.msg("<%=SelectManufcaturer%>");
                        
                        return;
                    }else if(Ext.getCmp('manufacturerCode').getValue()==32){
                    	if(Ext.getCmp('UnitReferenceNoId').getValue() == ""){
                      		 Ext.example.msg("<%=EnterUnitReferenceID%>");
                        	return;
                      	}
                      	if(Ext.getCmp('mobileNocomboId').getValue() == ""|| Ext.getCmp('mobileNocomboId').getValue() == "None"){
                      		 Ext.example.msg("<%=SelectMobileNo%>");
                        	return;
                      	}else{
                      		mobileNum=Ext.getCmp('mobileNocomboId').getValue();
                      	}
                    }

                    if (Ext.getCmp('unittypecomboId').getValue() == "") {
                    Ext.example.msg("<%=selectUnitType%>");
                        
                        return;
                    }

                    if (Ext.getCmp('RfidcomboId').getValue() == "") {
                    Ext.example.msg("<%=SelectStatus%>");
                        
                        return;
                    }
					
					 if (Ext.getCmp('transparentcomboId').getValue() == "") {
                    Ext.example.msg("<%=SelectTransMode%>");
                        
                        return;
                    }
                    
                    if (innerPanelForUnitDetails.getForm().isValid()) {
                        var id;
                        var ManufacturerGrid;
                        var unitrefId;
                        var DateAndTimeGrid;
                        var status;
                        var selected;
                        var transModeGrid;
                        var predefinedMobileNumGrid;
                        if (buttonValue == 'modify') {
                            selected = grid.getSelectionModel().getSelected();
                            id = selected.get('unitTypeId');
                            ManufacturerGrid = selected.get('manufacturerid');
                            unitrefId = selected.get('unitIMEI');
                            //DateAndTimeGrid = selected.get('DateAndTime');
                            status = selected.get('Status');
                            predefinedMobileNumGrid = selected.get('predefinedMobileNum');
                            transModeGrid=selected.get('transparentMode');
                        }
                        Ext.Ajax.request({
                            url: '<%=request.getContextPath()%>/UnitDetailsAction.do?param=saveUnitInformation',
                            method: 'POST',
                            params: {
                                buttonValue: buttonValue,
                                UnitNumber: Ext.getCmp('UnitNoId').getValue(),
                                ManufactureCode: Ext.getCmp('manufacturerCode').getValue(),
                                UnitTypeCode: Ext.getCmp('unittypecomboId').getValue(),
                                UnitRefId: Ext.getCmp('UnitReferenceNoId').getValue(),
                                //DateAndTime: Ext.getCmp('startdate').getValue(),
                                STATUS: Ext.getCmp('RfidcomboId').getValue(),
                                id: id,
                                manufacturerGrid: ManufacturerGrid,
                                UnitRef: unitrefId,
                                dateAndTimeGrid: DateAndTimeGrid,
                                Status: status,
                                mobileNum: mobileNum,
								predefinedMobileNumGrid: predefinedMobileNumGrid,
								pageName: pageName,
								transMode:Ext.getCmp('transparentcomboId').getValue(),
								transModeGrid:transModeGrid
                            },
                            success: function (response, options) {
                                var message = response.responseText;
                                Ext.example.msg(message);

                                myWin.hide();
                                Ext.getCmp('UnitNoId').reset();
                                Ext.getCmp('manufacturerCode').reset();
                                Ext.getCmp('unittypecomboId').reset();
                                Ext.getCmp('UnitReferenceNoId').reset();
                              //  Ext.getCmp('startdate').reset();
                                Ext.getCmp('RfidcomboId').reset();
                                Ext.getCmp('transparentcomboId').reset();
                                store.load({
							             params: {
												jspName:jspName
							            }
							      });
                                outerPanelWindow.getEl().unmask();
                            },
                            failure: function () {
                                Ext.example.msg("Error");
                                store.reload();
                                myWin.hide();
                            }
                        });
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
                fn: function () {
                    myWin.hide();
                    Ext.getCmp('UnitNoId').reset();
                    Ext.getCmp('manufacturerCode').reset();
                    Ext.getCmp('unittypecomboId').reset();
                    Ext.getCmp('UnitReferenceNoId').reset();
                   // Ext.getCmp('startdate').reset();
                    Ext.getCmp('RfidcomboId').reset();
                    Ext.getCmp('transparentcomboId').reset();

                }
            }
        }
    }]
});
/***********panel contains window content info***************************/
var outerPanelWindow = new Ext.Panel({
    width:495,
    cls: 'outerpanelwindow',
    standardSubmit: true,
    frame: false,
    items: [innerPanelForUnitDetails, innerWinButtonPanel]
});
/***********************window for form field****************************/
myWin = new Ext.Window({
    title: 'Add',
    closable: false,
    modal: true,
    resizable: false,
    autoScroll: false,
    cls: '',
    width: 510,
    id: 'myWin',
    items: [outerPanelWindow]
});

//function for add button in grid that will open form window
function addRecord() {
    buttonValue = "add";
    titelForInnerPanel = '<%=AddUnitDetails%>';
    myWin.show();
    Ext.getCmp('UnitNoId').enable();
    Ext.getCmp('UnitNoId').reset();
    Ext.getCmp('manufacturerCode').reset();
    Ext.getCmp('unittypecomboId').reset();
    Ext.getCmp('UnitReferenceNoId').reset();
   // Ext.getCmp('startdate').reset();
    Ext.getCmp('RfidcomboId').reset();
    Ext.getCmp('transparentcomboId').reset();
    Ext.getCmp('mobileNocomboId').reset();
    Ext.getCmp('mandatoryUnitreferenceNoId').setText('');
   	Ext.getCmp('mandatorymobileNoId').hide();
  	Ext.getCmp('mobileNoTxtId').hide();
  	Ext.getCmp('mobileNocomboId').hide();
    myWin.setTitle(titelForInnerPanel);
	
}
//function for modify button in grid that will open form window
function modifyData() {
    if (grid.getSelectionModel().getCount() > 1) {
        Ext.example.msg("<%=selectSingleRow%>");
        return;
    }

    if (grid.getSelectionModel().getSelected() == null) {
        Ext.example.msg("<%=noRowsSelected%>");
        return;
    }
    buttonValue = "modify";
    titelForInnerPanel = '<%=Modify%>';
    var selected = grid.getSelectionModel().getSelected();
    unittypestore.load({
        params: {
            manufacturerCode: selected.get('manufacturerid')
        },
        callback: function () {
            //myWin.setPosition(450, 150);
            myWin.setTitle(titelForInnerPanel);
            myWin.show();
            Ext.getCmp('UnitNoId').disable();
            Ext.getCmp('UnitNoId').setValue(selected.get('unitNo'));
            Ext.getCmp('manufacturerCode').setValue(selected.get('manufacturerid'));
            Ext.getCmp('unittypecomboId').setValue(selected.get('unitTypeId'));
            if(selected.get('manufacturerid')==32){
             		Ext.getCmp('mandatoryUnitreferenceNoId').setText('*');
                    Ext.getCmp('mandatorymobileNoId').show();
                	Ext.getCmp('mobileNoTxtId').show();
                	Ext.getCmp('mobileNocomboId').show();
                	mobileNumberStore.load();
                	if(selected.get('predefinedMobileNum')==""){
               	      	Ext.getCmp('mobileNocomboId').reset();
               	    }else{
                		Ext.getCmp('mobileNocomboId').setValue(selected.get('predefinedMobileNum'));
                	}
            }else{
            		Ext.getCmp('mandatoryUnitreferenceNoId').setText('');
                 	Ext.getCmp('mandatorymobileNoId').hide();
                	Ext.getCmp('mobileNoTxtId').hide();
                	Ext.getCmp('mobileNocomboId').hide();
            }
            Ext.getCmp('UnitReferenceNoId').setValue(selected.get('unitIMEI'));
          //  Ext.getCmp('startdate').setValue(selected.get('DateAndTime'));
            Ext.getCmp('RfidcomboId').setValue(selected.get('Status'));
            Ext.getCmp('transparentcomboId').setValue(selected.get('transparentMode'));

        }
    });

}
//function for delete button in grid that will open form window
function deleteData() {
    if (grid.getSelectionModel().getCount() > 1) {
        Ext.example.msg("<%=selectSingleRow%>");
        return;
    }

    if (grid.getSelectionModel().getSelected() == null) {
        Ext.example.msg("<%=noRowsSelected%>");
        return;
    }
    Ext.Msg.show({
        title: '<%=DeleteUnitDetails%>',
        msg: '<%=Areyousureyouwanttodelete%>',
        progressText: 'Deleting  ...',
        buttons: {
            yes: true,
            no: true
        },

        fn: function (btn) {
            switch (btn) {
            case 'yes':
                // outerPanelWindow.getEl().mask();
                //Ajax request
                var selected = grid.getSelectionModel().getSelected();
                Ext.Ajax.request({
                    url: '<%=request.getContextPath()%>/UnitDetailsAction.do?param=deleteUnitDetails',
                    method: 'POST',
                    params: {
                        UnitNumber: selected.get('unitNo'),
                        ManufactureCode: selected.get('manufacturer'),
                        UnitTypeCode: selected.get('unitType'),
                       //DateAndTime: selected.get('DateAndTime'),
                        STATUS: selected.get('Status'),
						pageName: pageName
                    },
                    success: function (response, options) {
                        var message = response.responseText;
                        Ext.example.msg(message);
                        store.reload({
                        params: {
					    jspName:jspName
                         }
                       });
                        //outerPanelWindow.getEl().unmask();
                    },
                    failure: function () {
                        Ext.example.msg("Error");
                        store.reload();
                        outerPanelWindow.getEl().unmask();

                    }
                });

                break;
            case 'no':
                Ext.example.msg("Unit Details not Deleted..");
                store.reload();
                break;

            }
        }
    });
}
//sameer modify

function clearInputData() {
    importgrid.store.clearData();
    importgrid.view.refresh();
}

function importExcelData() {
    importButton = "import";
    importTitle = 'Unit Import Details';
    importWin.show();
    importWin.setTitle(importTitle);
}

var fp = new Ext.FormPanel({

    fileUpload: true,
    width: '100%',
    frame: true,
    autoHeight: true,
    standardSubmit: false,
    labelWidth: 70,
    defaults: {
        anchor: '95%',
        allowBlank: false,
        msgTarget: 'side'
    },
    items: [{
        xtype: 'fileuploadfield',
        id: 'filePath',
        width: 60,
        emptyText: 'Browse',
        fieldLabel: 'ChooseFile',
        name: 'filePath',
        buttonText: 'Browse',
     	buttonCfg: {
            iconCls: 'browsebutton'
        },
        listeners: {

            fileselected: {
                fn: function () {
                    var filePath = document.getElementById('filePath').value;
                    var imgext = filePath.substring(filePath.lastIndexOf(".") + 1, filePath.length);
                    if (imgext == "xls" || imgext == "xlsx") {

                    } else {
                        Ext.MessageBox.show({
                            msg: 'Please select only .xls or .xlsx files',
                            buttons: Ext.MessageBox.OK
                        });
                        Ext.getCmp('filePath').setValue("");
                        return;
                    }
                }
            }

        }
    }],
    buttons: [{
        text: 'Upload',
        iconCls : 'uploadbutton',
        handler: function () {
            if (fp.getForm().isValid()) {
                var filePath = document.getElementById('filePath').value;

                var imgext = filePath.substring(filePath.lastIndexOf(".") + 1, filePath.length);
                if (imgext == "xls" || imgext == "xlsx") {
					clearInputData();
                } else {
                    Ext.MessageBox.show({
                        msg: 'Please select only .xls or .xlsx files',
                        buttons: Ext.MessageBox.OK
                    });
                    Ext.getCmp('filePath').setValue("");
                    return;
                }
                fp.getForm().submit({
                    url: '<%=request.getContextPath()%>/UnitDetailsAction.do?param=importUnitDetailsExcel',
                    enctype: 'multipart/form-data',
                    waitMsg: 'Uploading your file...',
                    success: function (response, action) {
						
						Ext.Ajax.request({
                        url: '<%=request.getContextPath()%>/UnitDetailsAction.do?param=getImportUnitDetails',
                        method: 'POST',
                        params: {
                            unitImportResponse: action.response.responseText
                        },
                        success: function (response, options) {
                            unitResponseImportData  = Ext.util.JSON.decode(response.responseText);
                            importstore.loadData(unitResponseImportData);
                            
                        },
                        failure: function () {
                            Ext.example.msg("Error");
                        }
                    });
                        
                    },
                    failure: function () {
                        Ext.example.msg("Please Upload The Standard Format");
                    }
                });
            }
        }
    },{
		text: '<%=GetStandardFormat%>',
		iconCls : 'downloadbutton',
	    handler : function(){
	    Ext.getCmp('filePath').setValue("Upload the Standard File");
	    fp.getForm().submit({
	    	url:'<%=request.getContextPath()%>/UnitDetailsAction.do?param=openStandardFileFormats'
	    	});
		}	   
	}]
});
function closeImportWin(){
fp.getForm().reset();
            importWin.hide();
			clearInputData();
}
function saveDate(){

var unitValidCount = 0;
var totalUnitcount = importstore.data.length;
    for (var i = 0; i < importstore.data.length; i++) {
        var record = importstore.getAt(i);
        var checkvalidOrInvalid = record.data['importstatusindex'];
        if (checkvalidOrInvalid == 'Valid') {
            unitValidCount++;
        }
    }

	var saveJson = getJsonOfStore(importstore);
	Ext.Msg.show({
        title: 'Saving..',
        msg: 'We have ' + unitValidCount + ' valid transaction to be saved out of ' + totalUnitcount + ' .Do you want to continue?',
        buttons: Ext.Msg.YESNO,
        fn: function (btn) {
            if (btn == 'no') {
                return;
            }
            if (btn == 'yes') {
    
		if (saveJson != '[]' && unitValidCount>0) {
         Ext.Ajax.request({
               url: '<%=request.getContextPath()%>/UnitDetailsAction.do?param=saveImportUnitDetails',
               method: 'POST',
               params: {
                            unitDataSaveParam: saveJson
               },
               success: function (response, options) {
               			var message = response.responseText;
               			store.reload({
                        params: {
					    jspName:jspName
                         }
              			});
              			Ext.example.msg(message);
               },
               failure: function () {
                           Ext.example.msg("Error");
                        }
               });
               clearInputData();
               fp.getForm().reset();
               importWin.hide();
               
           }else{
           Ext.MessageBox.show({
                        msg: "You don't have any Valid Information to Proceed",
                        buttons: Ext.MessageBox.OK
                    });
           }
           }
           }
          });
}
function getJsonOfStore(importstore) {
    var datar = new Array();
    var jsonDataEncode = "";
    var recordss = importstore.getRange();
    for (var i = 0; i < recordss.length; i++) {
        datar.push(recordss[i].data);
    }
    jsonDataEncode = Ext.util.JSON.encode(datar);

    return jsonDataEncode;
}
//sameer grid configuration
//************************* store configs
//***************************jsonreader
var reader = new Ext.data.JsonReader({
    root: 'UnitDetailsImportRoot',
    totalProperty: 'total',
    fields: [{
        name: 'importslnoIndex'
    }, {
        name: 'importunitnoindex'
    }, {
        name: 'importmanufacturerindex'
    },{
        name: 'importunittypeindex'
    }, {
        name: 'importunitreferenceidindex'
    }, {
        name: 'importstatusindex'
    }, {
        name: 'importremarksindex'
    }]
});

var importstore = new Ext.data.GroupingStore({
    proxy: new Ext.data.HttpProxy({
        url: '<%=request.getContextPath()%>/UnitDetailsAction.do?param=getImportUnitDetails',
        method: 'POST'
    }),
    remoteSort: false,
    bufferSize: 700,
    autoLoad: false,
    reader: reader
});
//****************************grid filters
var filters = new Ext.ux.grid.GridFilters({
    local: true,
    filters: [{
            type: 'numeric',
            dataIndex: 'importunitnoindex'
        }, {
            dataIndex: 'importunitnoindex',
            type: 'String'
        }, {
            dataIndex: 'importmanufacturerindex',
            type: 'string'
        },{
            dataIndex: 'importunittypeindex',
            type: 'string'
        }, {
            dataIndex: 'importunitreferenceidindex',
            type: 'string'
        }, {
            dataIndex: 'importstatusindex',
            type: 'string'
        }, {
            dataIndex: 'importremarksindex',
            type: 'string'
        }

    ]
});
//****************column Model Config
var createColModel = function (finish, start) {
    var columns = [
        new Ext.grid.RowNumberer({
            header: "<span style=font-weight:bold;><%=SLNO%></span>",
            width: 50
        }), {
            
            header: "<span style=font-weight:bold;><%=SLNO%></span>",
            dataIndex: 'importslnoIndex',
            hidden: true,
            width: 100,
            filter: {
                type: 'numeric'
            }
        },
        {
            header: "<span style=font-weight:bold;><%=UnitNumber%></span>",
            hidden: false,
            width: 150,
            sortable: true,
            dataIndex: 'importunitnoindex'
        }, {
            header: "<span style=font-weight:bold;><%=Manufaturer%></span>",
            hidden: false,
            width: 120,
            sortable: true,
            dataIndex: 'importmanufacturerindex'
        }, {
            header: "<span style=font-weight:bold;><%=UnitType%></span>",
            hidden: false,
            width: 120,
            sortable: true,
            dataIndex: 'importunittypeindex'
        },

        {
            header: "<span style=font-weight:bold;><%=UnitReferenceId%></span>",
            hidden: false,
            width: 150,
            sortable: true,
            dataIndex: 'importunitreferenceidindex',
            filter: {
                type: 'String'
            }
        },  {
            header: "<span style=font-weight:bold;><%=ValidStatus%></span>",
            hidden: false,
            width: 100,
            sortable: true,
            dataIndex: 'importstatusindex',
            renderer: checkValid,
            filter: {
                type: 'String'
            }

        },{
            header: "<span style=font-weight:bold;><%=Remarks%></span>",
            hidden: false,
            width: 200,
            sortable: true,
            dataIndex: 'importremarksindex',
            filter: {
                type: 'String'
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

function checkValid(val) {
    if (val == "Invalid") {
        return '<img src="/ApplicationImages/ApplicationButtonIcons/No.png">';
    } else if (val == "Valid") {
        return '<img src="/ApplicationImages/ApplicationButtonIcons/Yes.png">';
    }
}
//*******************************grid**************************///
importgrid = getGrid('', '<%=NoRecordsFound%>', importstore, 825, 198, 20, filters,'', false, '', 20, false, '', false, '', false, 'Excel', jspName, exportDataType, false, 'PDF', false, '<%=Add%>', false, '<%=Modify%>', false, '<%=Delete%>',false,'',false,'',false,'',false,'',false,'',false,'',true,'<%=Save%>',true,'<%=Clear%>',true,'<%=Close%>');	

//end grid

var excelImageFormat = new Ext.FormPanel({
    standardSubmit: true,
    collapsible: false,
    id: 'excelMaster',

    height: 170,
    width: '100%',
    frame: false,
    items: [{
        cls: 'importimagepanel'
    }]
});

var importPanelWindow = new Ext.Panel({
    cls: 'outerpanelwindow',
    frame: false,
    layout: 'column',
    layoutConfig: {
        columns: 1
    },
    items: [fp,excelImageFormat,importgrid]
});

importWin = new Ext.Window({
    title: 'Unit Import Details',
    width: 840,
    height:483,
    closable: false,
    modal: true,
    resizable: false,
    autoScroll: false,
    id: 'importWin',
    items: [importPanelWindow]
});

<%if (loginInfo.getStyleSheetOverride().equals("Y")){%>
 importWin.setHeight(505);
importWin.setWidth(840);
<%}%>
//end modify

//***************************jsonreader
var reader = new Ext.data.JsonReader({
    root: 'unitDetailsRoot',
    totalProperty: 'total',
    fields: [{
        name: 'slnoIndex'
    }, {
        name: 'unitNo'
    }, {
        name: 'unitIMEI'
    }, {
        name: 'DateAndTime',
        type: 'date',
        //dateFormat:'d/m/Y'
        format: getDateTimeFormat()
    }, {
        name: 'manufacturerid'
    }, {
        name: 'unitTypeId'
    }, {
        name: 'manufacturer'
    }, {
        name: 'unitType'
    }, {
        name: 'Status'
    }, {
        name: 'predefinedMobileNum'
    }, {
        name: 'transparentMode'
    },{
        name: 'imsi'
    }]
});

//************************* store configs

var store = new Ext.data.GroupingStore({
    // autoLoad:true,
    proxy: new Ext.data.HttpProxy({
        url: '<%=request.getContextPath()%>/UnitDetailsAction.do?param=getUnitDetails',
        method: 'POST'
    }),
    remoteSort: false,
    sortInfo: {
        field: 'DateAndTime',
        direction: 'desc'
    },
    bufferSize: 700,
    autoLoad: false,
    //remoteSort:true,
    reader: reader
});
//****************************grid filters
var filters = new Ext.ux.grid.GridFilters({
    local: true,
    filters: [{
            type: 'numeric',
            dataIndex: 'slnoIndex'
        }, {
            dataIndex: 'unitNo',
            type: 'String'
        }, {
            dataIndex: 'unitIMEI',
            type: 'string'
        }, {
            dataIndex: 'DateAndTime',
            type: 'date'
        }, {
            dataIndex: 'manufacturer',
            type: 'string'
        }, {
            dataIndex: 'unitType',
            type: 'string'
        }, {
            dataIndex: 'Status',
            type: 'string'
        }, {
            dataIndex: 'predefinedMobileNum',
            type: 'string'
        }, {
            dataIndex: 'transparentMode',
            type: 'string'
        }, {
            dataIndex: 'imsi',
            type: 'string'
        }

    ]
});
//****************column Model Config
var createColModel = function (finish, start) {
    var columns = [
        new Ext.grid.RowNumberer({
            header: "<span style=font-weight:bold;><%=SLNO%></span>",
            width: 50
        }), {
            
           // hideable: false,
            header: "<span style=font-weight:bold;><%=SLNO%></span>",
            dataIndex: 'slnoIndex',
            hidden: true,
            width: 100,
            filter: {
                type: 'numeric'
            }
        },
        {
            header: "<span style=font-weight:bold;><%=UnitNumber%></span>",
            hidden: false,
            width: 130,
            sortable: true,
            dataIndex: 'unitNo'
        }, {
            header: "<span style=font-weight:bold;><%=Manufaturer%></span>",
            hidden: false,
            width: 120,
            sortable: true,
            dataIndex: 'manufacturer'

            //renderer:renderManufacturer
        }, {
            header: "<span style=font-weight:bold;><%=UnitType%></span>",
            hidden: false,
            width: 120,
            sortable: true,
            dataIndex: 'unitType'

            //renderer:renderUnitType
        },

        {
            header: "<span style=font-weight:bold;><%=UnitReferenceId%></span>",
            hidden: false,
            width: 130,
            sortable: true,
            dataIndex: 'unitIMEI',
            filter: {
                type: 'String'
            }
        }, {
            header: "<span style=font-weight:bold;><%=CreatedDateAndTime%></span>",
            hidden: false,
            width: 110,
            sortable: true,
            dataIndex: 'DateAndTime',
            renderer: Ext.util.Format.dateRenderer(getDateTimeFormat()),
            //renderer: Ext.util.Format.dateRenderer('d/m/Y'),
            filter: {
                type: 'Date'
            }
        }, {
            header: "<span style=font-weight:bold;><%=Status%></span>",
            hidden: false,
            width: 100,
            sortable: true,
            dataIndex: 'Status',
            filter: {
                type: 'String'
            }
        }, {
            header: "<span style=font-weight:bold;><%=MobileNo%></span>",
            hidden: false,
            width: 100,
            sortable: true,
            dataIndex: 'predefinedMobileNum',
            filter: {
                type: 'String'
            }

        }, {
            header: "<span style=font-weight:bold;><%=TransMode1%></span>",
            hidden: false,
            width: 100,
            sortable: true,
            dataIndex: 'transparentMode',
            filter: {
                type: 'String'
            }

        },{
            header: "<span style=font-weight:bold;><%=IMSI%></span>",
            hidden: false,
            width: 130,
            sortable: true,
            dataIndex: 'imsi',
            filter: {
                type: 'String'
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
//*******************************grid**************************///

<%

if(customerId > 0 )
{

	if(userAuthority.equalsIgnoreCase("Admin"))
	{%>    
    	grid =getGridManager('', '<%=NoRecordsFound%>', store, screen.width - 40, 490, 20, filters,'', false, '', 20, false, '', false, '', false, 'Excel', jspName, exportDataType, false, 'PDF', true, '<%=Add%>', true, '<%=Modify%>', true, '<%=Delete%>',false,'',false,'',false,'',false,'',false,'',true,'<%=ImportUnit%>');				
 	<%} else if(userAuthority.equalsIgnoreCase("Supervisor")) {%>
		grid =getGridManager('', '<%=NoRecordsFound%>', store, screen.width - 40, 490, 20, filters,'', false, '', 20, false, '', false, '', false, 'Excel', jspName, exportDataType, false, 'PDF', false, '<%=Add%>', true, '<%=Modify%>', false, '<%=Delete%>',false,'',false,'',false,'',false,'',false,'',true,'<%=ImportUnit%>');			
	<%} else {%>
							
		grid =getGridManager('', '<%=NoRecordsFound%>', store, screen.width - 40, 490, 20, filters,'', false, '', 20, false, '', false, '', false, 'Excel', jspName, exportDataType, false, 'PDF', false, '<%=Add%>', false, '<%=Modify%>', false, '<%=Delete%>',false,'',false,'',false,'',false,'',false,'',false,'<%=ImportUnit%>');			
	<%}
} else {%>	
		grid =getGridManager('', '<%=NoRecordsFound%>', store, screen.width - 40, 490, 20, filters,'', false, '', 20, false, '', false, '', false, 'Excel', jspName, exportDataType, false, 'PDF', true, '<%=Add%>', true, '<%=Modify%>', true, '<%=Delete%>',false,'',false,'',false,'',false,'',false,'',true,'<%=ImportUnit%>');			
<% }%>	

//*****main starts from here*************************
Ext.onReady(function () {
    ctsb = tsb;
    Ext.QuickTips.init();
    Ext.Ajax.timeout = 180000;
    Ext.form.Field.prototype.msgTarget = 'side';
    outerPanel = new Ext.Panel({
        //title: '<%=UnitDetails%>',
        renderTo: 'content',
        standardSubmit: true,
        autoScroll: false,
        frame: true,
        border: false,
        layout: 'table',
        height:510,
        cls: 'outerpanel',
        items: [grid]
        //bbar: ctsb
    });
    store.load({
             params: {
					jspName:jspName
            }
      });
});
</script>   

	</body>
</html>
<%}%>