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
tobeConverted.add("Save");
tobeConverted.add("Cancel");
tobeConverted.add("Trader_Master");
tobeConverted.add("Address");
tobeConverted.add("PAN_No");
tobeConverted.add("Enter_Pan_No");
tobeConverted.add("Enter_Address");
tobeConverted.add("Select_Single_Row");
tobeConverted.add("Issued_Date");
tobeConverted.add("Enter_Issued_Date");
tobeConverted.add("Application_Date");
tobeConverted.add("Select_Application_Date");
tobeConverted.add("IBM_Application_No");
tobeConverted.add("Enter_IBM_Application_No");
tobeConverted.add("Add_Trader_Master_Details");
tobeConverted.add("Modify_Trader_Master_Details");
tobeConverted.add("Enter_IBM_Trader_No");
tobeConverted.add("Enter_Name_Of_Trader");
tobeConverted.add("Name_Of_Trader");
tobeConverted.add("DMG_Trader_No");
tobeConverted.add("Enter_DMG_Trader_No");
tobeConverted.add("Trader_Master_Details");
tobeConverted.add("IBM_Trader_No");
tobeConverted.add("TIN_No");
tobeConverted.add("Enter_TIN_No");
tobeConverted.add("IEC_Number");
tobeConverted.add("Enter_IEC_No");
tobeConverted.add("Purchased_ROM");
tobeConverted.add("Purchased_Processed_Ore");
tobeConverted.add("Type");
tobeConverted.add("Select_Type");
tobeConverted.add("Enter_Name");


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
String Save=convertedWords.get(11);
String Cancel=convertedWords.get(12);
String Trader_Master=convertedWords.get(13);
String Address=convertedWords.get(14);
String PAN_No=convertedWords.get(15);
String Enter_PAN_No=convertedWords.get(16);
String Enter_Address=convertedWords.get(17);
String SelectSingleRow=convertedWords.get(18);
String Date_Of_Issue=convertedWords.get(19);
String Enter_Date_Of_Issue=convertedWords.get(20);
String Application_Date=convertedWords.get(21);
String Select_Application_Date=convertedWords.get(22);
String IBM_Application_No=convertedWords.get(23);
String Enter_IBM_Application_No=convertedWords.get(24);
String Add_Trader_Master_Details=convertedWords.get(25);
String Modify_Trader_Master_Details=convertedWords.get(26);
String Enter_IBM_Trader_No=convertedWords.get(27);
String Enter_Name_Of_Trader=convertedWords.get(28);
String Name_Of_Trader=convertedWords.get(29);
String DMG_Trader_No=convertedWords.get(30);
String Enter_DMG_Trader_No=convertedWords.get(31);
String Trader_Master_Details=convertedWords.get(32);
String IBM_Trader_No=convertedWords.get(33);
String TIN_No=convertedWords.get(34);
String Enter_TIN_No=convertedWords.get(35);
String IEC_Number=convertedWords.get(36);
String Enter_IEC_No=convertedWords.get(37);
String Purchased_ROM=convertedWords.get(38);
String Purchased_Processed_Ore=convertedWords.get(39);
String Type=convertedWords.get(40);
String EnterType=convertedWords.get(41);
String Enter_Name=convertedWords.get(42);
String Please_Enter="Please Enter";

int userId=loginInfo.getUserId(); 
String userAuthority=cf.getUserAuthority(systemId,userId);	
int isltsp=loginInfo.getIsLtsp();
if(customerId > 0 && loginInfo.getIsLtsp()== -1 && !userAuthority.equalsIgnoreCase("Admin"))
	{
		response.sendRedirect(request.getContextPath()+ "/Jsps/Common/401Error.html");
	}
	else{

%>
<!DOCTYPE HTML>
<html>
 <head>
 		<title>Trader Master</title>		
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
	<jsp:include page="../IronMining/css.jsp" />
	<%}else{%>
	<jsp:include page="../Common/ImportJS.jsp" />
	<jsp:include page="../IronMining/css.jsp" />
	<%}%>
   <jsp:include page="../Common/ExportJS.jsp" />
   <script><!--
   
var outerPanel;
var ctsb;
var jspName = "Trader Master";
var exportDataType = "int,int,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,number,number,string,string";
var selected;
var grid;
var buttonValue;
var titelForInnerPanel;
var myWin;
var dtcur = datecur;
var dtprev = dateprev;
var datenext = datenext;

var clientcombostore = new Ext.data.JsonStore({
    url: '<%=request.getContextPath()%>/CommonAction.do?param=getCustomer',
    id: 'CustomerStoreId',
    root: 'CustomerRoot',
    autoLoad: true,
    remoteSort: true,
    fields: ['CustId', 'CustName'],
    listeners: {
        load: function(custstore, records, success, options) {
            if (<%= customerId %> > 0) {
                Ext.getCmp('custcomboId').setValue('<%=customerId%>');
                custId = Ext.getCmp('custcomboId').getValue();
                store.load({
                    params: {
                        CustId: custId,
                        custName: Ext.getCmp('custcomboId').getRawValue(),
                        jspName:jspName
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
    resizable: true,
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
                        CustId: custId,
                        custName: Ext.getCmp('custcomboId').getRawValue(),
                        jspName:jspName
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

var typeComboStore = new Ext.data.SimpleStore({
    id: 'typeComboStoreId',
    autoLoad: true,
    fields: ['Name','Value'],
    data: [
        ['TRADER','TRADER'],
        ['RAISING CONTRACTOR','RAISING CONTRACTOR'],
    ]
});

var typeCombo= new Ext.form.ComboBox({
    store: typeComboStore,
    id: 'typeComboId',
    mode: 'local',
    forceSelection: true,
    selectOnFocus: true,
    allowBlank: false,
    anyMatch: true,
    typeAhead: false,
    triggerAction: 'all',
    lazyRender: true,
    valueField: 'Value',
    emptyText: '<%=EnterType%>',
    resizable: true,
    value: typeComboStore.getAt(0).data['Value'],
    displayField: 'Name',
    cls: 'selectstylePerfectnew',
     height: 350,
     listeners: {
        select: {
               fn: function() {
               		Ext.getCmp('ibmAppNoId').reset();
                    Ext.getCmp('ApplicationdateId').reset();
                    Ext.getCmp('IBMTraderNoId').reset();
                    Ext.getCmp('nameOfTraderId').reset();
                    Ext.getCmp('addressId').reset();
                    Ext.getCmp('panNoId').reset();
                    Ext.getCmp('iecNoId').reset();
                    Ext.getCmp('tinNoId').reset();
                    Ext.getCmp('dmgNoId').reset();
                    Ext.getCmp('dateOfIssueId').reset();
               		if(Ext.getCmp('typeComboId').getValue()=='RAISING CONTRACTOR'){
               		//Ext.getCmp('myWinId').setTitle(titelForInnerPanel);
               		Ext.getCmp('TraderInfoId').setTitle('Raising Contractor Details');
               		Ext.getCmp('mandatoryIBMTraderNo').setText('');
					Ext.getCmp('IBMTradeNoLabelId').setText('Incorporation Certificate');
			    	Ext.getCmp('NameoftraderLabelId').setText('Name of RC');
			    	Ext.getCmp('iecNoLabelId').setText('Service Tax No');
			    	Ext.getCmp('dmgNoLabelId').setText('DMG RC Code');
			    	}else{
			    	//Ext.getCmp('myWinId').setTitle(titelForInnerPanel);
			    	Ext.getCmp('TraderInfoId').setTitle('<%=Trader_Master_Details%>');
			    	Ext.getCmp('IBMTradeNoLabelId').setText('<%=IBM_Trader_No%>');
			    	Ext.getCmp('mandatoryIBMTraderNo').setText('*');
			    	Ext.getCmp('NameoftraderLabelId').setText('<%=Name_Of_Trader%>');
			    	Ext.getCmp('iecNoLabelId').setText('<%=IEC_Number%>');
			    	Ext.getCmp('dmgNoLabelId').setText('<%=DMG_Trader_No%>');
			    	}
               }
           }
        }
	});

var innerPanelForTraderMasterDetails = new Ext.form.FormPanel({
    standardSubmit: true,
    collapsible: false,
    autoScroll: true,
    height: 360,
    width: 470,
    frame: false,
    id: 'innerPanelForTraderMasterDetailsId',
    layout: 'table',
    layoutConfig: {
        columns: 3
    },
    items: [{
        xtype: 'fieldset',
        title: '<%=Trader_Master_Details%>',
        cls: 'my-fieldset',
        collapsible: false,
        colspan: 3,
        id: 'TraderInfoId',
        width: 470,
        layout: 'table',
        layoutConfig: {
            columns: 4
        },
        items: [{
            xtype: 'label',
            text: ' ',
            cls: 'mandatoryfield',
            id: 'MandatoryimAppNoId'
        }, {
            xtype: 'label',
            text: 'Application No' + ' :',
            cls: 'labelstylenew',
            id: 'ibmAppNoLabelId'
        }, {
            xtype: 'textfield',
            cls: 'selectstylePerfectnew',
            id: 'ibmAppNoId',
            mode: 'local',
            forceSelection: true,
            emptyText: 'Application No',
            blankText: 'Application No',
            selectOnFocus: true,
            allowBlank: false,
            listeners: {
                  change: function(field, newValue, oldValue) {
                  field.setValue(newValue.toUpperCase().trim());
                   if(field.getValue().length> 50){ 
					Ext.example.msg("Field exceeded it's Maximum length");
					field.setValue(newValue.substr(0,50).toUpperCase().trim()); field.focus(); 
					} 
				}            
               }
        }, {},{
            xtype: 'label',
            text: ' ',
            cls: 'mandatoryfield',
            id: 'MandatoryAppNoTBRId'
        }, {
            xtype: 'label',
            text: 'Application No TBR ' + ' :',
            cls: 'labelstylenew',
            id: 'AppNoLabelId'
        }, {
            xtype: 'textfield',
            cls: 'selectstylePerfectnew',
            id: 'appNoTBRId',
            mode: 'local',
            forceSelection: true,
            emptyText: 'Application No TBR',
            blankText: 'Application No TBR',
            selectOnFocus: true,
            allowBlank: false,
            listeners: {
                  change: function(field, newValue, oldValue) {
                  field.setValue(newValue.toUpperCase().trim());
                   if(field.getValue().length> 50){ 
					Ext.example.msg("Field exceeded it's Maximum length");
					field.setValue(newValue.substr(0,50).toUpperCase().trim()); field.focus(); 
					} 
				}            
               }
        }, {}, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'mandatoryApplicationdate'
        }, {
            xtype: 'label',
            text: '<%=Application_Date%>' + ' :',
            cls: 'labelstylenew',
            id: 'ApplicationdateLabelId'
        }, {
            xtype: 'datefield',
            cls: 'selectstylePerfectnew',
            id: 'ApplicationdateId',
            format: getDateFormat(),
            allowBlank: false,
            emptyText: '<%=Select_Application_Date%>',
            blankText: '<%=Select_Application_Date%>',
            submitFormat: getDateFormat(),
            labelSeparator: '',
            value: dtcur
        }, {}, {
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'mandatoryTypeId'
        }, {
            xtype: 'label',
            text: '<%=Type%>' + ' :',
            cls: 'labelstylenew',
            id: 'typeLabelId'
        }, typeCombo, {}, {
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'mandatoryIBMTraderNo'
        }, {
            xtype: 'label',
            text: '<%=IBM_Trader_No%>' + ' :',
            cls: 'labelstylenew',
            id: 'IBMTradeNoLabelId'
        }, {
            xtype: 'textfield',
            cls: 'selectstylePerfectnew',
            id: 'IBMTraderNoId',
            mode: 'local',
            forceSelection: true,
            emptyText: '<%=Please_Enter%>',
            blankText: '<%=Please_Enter%>',
            selectOnFocus: true,
            allowBlank: false,
           listeners: {
                  change: function(field, newValue, oldValue) {
                  field.setValue(newValue.toUpperCase().trim());
                  if(field.getValue().length> 50){ 
					Ext.example.msg("Field exceeded it's Maximum length");
					field.setValue(newValue.substr(0,50).toUpperCase().trim()); field.focus();               
					}
               }
               }
        }, {}, {
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'mandatoryNameoftrader'
        }, {
            xtype: 'label',
            text: '<%=Name_Of_Trader%>' + ' :',
            cls: 'labelstylenew',
            id: 'NameoftraderLabelId'
        }, {
            xtype: 'textfield',
            cls: 'selectstylePerfectnew',
            id: 'nameOfTraderId',
            mode: 'local',
            forceSelection: true,
            emptyText: '<%=Enter_Name%>',
            blankText: '<%=Enter_Name%>',
            selectOnFocus: true,
            allowBlank: false,
            allowNegative: false,
            listeners: {
                  change: function(field, newValue, oldValue) {
                  field.setValue(newValue.toUpperCase().trim());
                  if(field.getValue().length> 50){ 
					Ext.example.msg("Field exceeded it's Maximum length");
					field.setValue(newValue.substr(0,50).toUpperCase().trim()); field.focus();
					}
				}               
              } 
        }, {}, {
            xtype: 'label',
            text: ' ',
            cls: 'mandatoryfield',
            id: 'mandatoryAddress'
        }, {
            xtype: 'label',
            text: '<%=Address%>' + ' :',
            cls: 'labelstylenew',
            id: 'addressLabelId'
        }, {
            xtype: 'textfield',
            cls: 'selectstylePerfectnew',
            id: 'addressId',
            mode: 'local',
            forceSelection: true,
            emptyText: '<%=Enter_Address%>',
            blankText: '<%=Enter_Address%>',
            selectOnFocus: true,
            allowBlank: false,
            allowNegative: false,
           listeners: {
             change: function(field, newValue, oldValue) {
                  if(field.getValue().length> 50){ 
					Ext.example.msg("Field exceeded it's Maximum length");
					field.setValue(newValue.substr(0,50)); field.focus();
				} 
			  }
              }
        }, {}, {
            xtype: 'label',
            text: ' ',
            cls: 'mandatoryfield',
            id: 'mandatorypanNo'
        }, {
            xtype: 'label',
            text: '<%=PAN_No%>' + ' :',
            cls: 'labelstylenew',
            id: 'panNoLabelId'
        }, {
            xtype: 'textfield',
            cls: 'selectstylePerfectnew',
            id: 'panNoId',
            mode: 'local',
            forceSelection: true,
            emptyText: '<%=Enter_PAN_No%>',
            blankText: '<%=Enter_PAN_No%>',
            selectOnFocus: true,
            allowBlank: false,
            allowNegative: false,
            listeners: {
                  change: function(field, newValue, oldValue) {
                  field.setValue(newValue.toUpperCase().trim());
                    if(field.getValue().length> 20){ 
					Ext.example.msg("Field exceeded it's Maximum length");
					field.setValue(newValue.substr(0,20).toUpperCase().trim()); field.focus();              
					 }
					 }
               }
        }, {}, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'mandatoryIecNo'
        }, {
            xtype: 'label',
            text: '<%=IEC_Number%>' + ' :',
            cls: 'labelstylenew',
            id: 'iecNoLabelId'
        }, {
            xtype: 'textfield',
            cls: 'selectstylePerfectnew',
            id: 'iecNoId',
            mode: 'local',
            forceSelection: true,
            emptyText: '<%=Please_Enter%>',
            blankText: '<%=Please_Enter%>',
            selectOnFocus: true,
            allowBlank: false,
            allowNegative: false,
             listeners: {
                  change: function(field, newValue, oldValue) {
                  field.setValue(newValue.toUpperCase().trim());
                   if(field.getValue().length> 50){ 
					Ext.example.msg("Field exceeded it's Maximum length");
					field.setValue(newValue.substr(0,50).toUpperCase().trim()); field.focus();              
					 }
               }
               }
        }, {}, {
            xtype: 'label',
            text: ' ',
            cls: 'mandatoryfield',
            id: 'mandatoryTinNo'
        }, {
            xtype: 'label',
            text: '<%=TIN_No%>' + ' :',
            cls: 'labelstylenew',
            id: 'tinNoLabelId'
        }, {
            xtype: 'textfield',
            id: 'tinNoId',
            cls: 'selectstylePerfectnew',
            mode: 'local',
            forceSelection: true,
            emptyText: '<%=Enter_TIN_No%>',
            blankText: '<%=Enter_TIN_No%>',
            selectOnFocus: true,
            allowBlank: false,
            allowNegative: false,
            listeners: {
                  change: function(field, newValue, oldValue) {
                  field.setValue(newValue.toUpperCase().trim());
                   if(field.getValue().length> 50){ 
					Ext.example.msg("Field exceeded it's Maximum length");
					field.setValue(newValue.substr(0,50).toUpperCase().trim()); field.focus();              
					 }
               }
               }
        }, {}, {
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'mandatorydmgNo'
        }, {
            xtype: 'label',
            text: '<%=DMG_Trader_No%>' + ' :',
            cls: 'labelstylenew',
            id: 'dmgNoLabelId'
        }, {
            xtype: 'textfield',
            cls: 'selectstylePerfectnew',
            id: 'dmgNoId',
            mode: 'local',
            forceSelection: true,
            emptyText: '<%=Please_Enter%>',
            blankText: '<%=Please_Enter%>',
            selectOnFocus: true,
            allowBlank: false,
             listeners: {
                  change: function(field, newValue, oldValue) {
                  field.setValue(newValue.toUpperCase().trim());
                  if(field.getValue().length> 50){ 
					Ext.example.msg("Field exceeded it's Maximum length");
					field.setValue(newValue.substr(0,50).toUpperCase().trim()); field.focus();               
					}
               }
               }
        }, {}, {
            xtype: 'label',
            text: ' ',
            cls: 'mandatoryfield',
            id: 'mandatoryDateOfIssue'
        }, {
            xtype: 'label',
            text: '<%=Date_Of_Issue%>' + ' :',
            cls: 'labelstylenew',
            id: 'DateOfIssueLabelId'
        }, {
            xtype: 'datefield',
            cls: 'selectstylePerfectnew',
            id: 'dateOfIssueId',
            format: getDateFormat(),
            allowBlank: false,
            emptyText: '<%=Enter_Date_Of_Issue%>',
            blankText: '<%=Enter_Date_Of_Issue%>',
            submitFormat: getDateFormat(),
            labelSeparator: '',
            value: dtcur
        }, {},{
            xtype: 'label',
            text: ' ',
            cls: 'mandatoryfield',
            id: 'MandatoryaliasId'
        }, {
            xtype: 'label',
            text: 'Alias Name' + ' :',
            cls: 'labelstylenew',
            id: 'aliasNameLabelId'
        }, {
            xtype: 'textfield',
            cls: 'selectstylePerfectnew',
            id: 'aliasNameId',
            mode: 'local',
            forceSelection: true,
            emptyText: 'Alias Name',
            blankText: 'Alias Name',
            selectOnFocus: true,
            allowBlank: false,
            listeners: {
                  change: function(field, newValue, oldValue) {
                  field.setValue(newValue.toUpperCase().trim());
                   if(field.getValue().length> 50){ 
					Ext.example.msg("Field exceeded it's Maximum length");
					field.setValue(newValue.substr(0,50).toUpperCase().trim()); field.focus(); 
					} 
				}            
               }
        }, {},{
            xtype: 'label',
            text: ' ',
            cls: 'mandatoryfield',
            id: 'MandatorygstNoId'
        }, {
            xtype: 'label',
            text: 'GST No' + ' :',
            cls: 'labelstylenew',
            id: 'gstNoLabelId'
        }, {
            xtype: 'textfield',
            cls: 'selectstylePerfectnew',
            id: 'gstNoId',
            mode: 'local',
            forceSelection: true,
            emptyText: 'Enter GST No',
            blankText: 'Enter GST No',
            selectOnFocus: true,
            allowBlank: false,
            listeners: {
                  change: function(field, newValue, oldValue) {
                  field.setValue(newValue.toUpperCase().trim());
                   if(field.getValue().length> 50){ 
					Ext.example.msg("Field exceeded it's Maximum length");
					field.setValue(newValue.substr(0,50).toUpperCase().trim()); field.focus(); 
					} 
				}            
               }
        }, {}]
    }]
});

var innerWinButtonPanel = new Ext.Panel({
    id: 'innerWinButtonPanelId',
    standardSubmit: true,
    collapsible: false,
    autoHeight: false,
    height: 40,
    width: '100%',
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
        iconCls: 'savebutton',
        width: 70,
        listeners: {
            click: {
                fn: function() {
					if (Ext.getCmp('typeComboId').getValue() == "") {
                        Ext.example.msg("<%=EnterType%>");
                        Ext.getCmp('typeComboId').focus();
                        return;
                    }
<!--                    if (Ext.getCmp('appNoTBRId').getValue() == "") {-->
<!--                        Ext.example.msg("Ebter Application No TBR");-->
<!--                        Ext.getCmp('appNoTBRId').focus();-->
<!--                        return;-->
<!--                    }-->
                    if (Ext.getCmp('IBMTraderNoId').getValue() == "" && Ext.getCmp('typeComboId').getValue() == "TRADER") {
                        Ext.example.msg("<%=Enter_IBM_Trader_No%>");
                        Ext.getCmp('IBMTraderNoId').focus();
                        return;
                    }
                    if (Ext.getCmp('nameOfTraderId').getValue() == "") {
                    	if(Ext.getCmp('typeComboId').getValue() == "TRADER"){
                          Ext.example.msg("<%=Enter_Name_Of_Trader%>");
                        }else{
                          Ext.example.msg("Enter Name Of RC");
                        }
                        Ext.getCmp('nameOfTraderId').focus();
                        return;
                    }
                    if (Ext.getCmp('dmgNoId').getValue() == "") {
                        Ext.example.msg("<%=Enter_DMG_Trader_No%>");
                        Ext.getCmp('dmgNoId').focus();
                        return;
                    }
                    if (Ext.getCmp('aliasNameId').getValue() == "") {
                        Ext.example.msg("Enter Alias Name");
                        Ext.getCmp('aliasNameId').focus();
                        return;
                    }
<!--                    if (Ext.getCmp('gstNoId').getValue() == "") {-->
<!--                        Ext.example.msg("Enter GST No");-->
<!--                        Ext.getCmp('gstNoId').focus();-->
<!--                        return;-->
<!--                    }-->
                    
                    var id;
                    if (buttonValue == 'Modify') {
                        var selected = grid.getSelectionModel().getSelected();
                        id = selected.get('uniqueIdDataIndex');
                    }
                    routeMasterOuterPanelWindow.getEl().mask();
                    Ext.Ajax.request({
                        url: '<%=request.getContextPath()%>/MiningTraderMasterAction.do?param=AddorModifyTraderMasterDetails',
                        method: 'POST',
                        params: {
                            buttonValue: buttonValue,
                            CustId: Ext.getCmp('custcomboId').getValue(),
                            ibmAppNo: Ext.getCmp('ibmAppNoId').getValue(),
                            type: Ext.getCmp('typeComboId').getValue(),
                            appDate: Ext.getCmp('ApplicationdateId').getValue(),
                            ibmTraderNo: Ext.getCmp('IBMTraderNoId').getValue(),
                            nameOfTrader: Ext.getCmp('nameOfTraderId').getValue(),
                            address: Ext.getCmp('addressId').getValue(),
                            panNo: Ext.getCmp('panNoId').getRawValue(),
                            iecNo: Ext.getCmp('iecNoId').getValue(),
                            tinNo: Ext.getCmp('tinNoId').getValue(),
                            dmgTraderNo: Ext.getCmp('dmgNoId').getValue(),
                            dateOfIssue: Ext.getCmp('dateOfIssueId').getValue(),
                            id: id,
                            aliasName: Ext.getCmp('aliasNameId').getValue(),
                            gstNo: Ext.getCmp('gstNoId').getValue(),
                            appNoTBR: Ext.getCmp('appNoTBRId').getValue()
                        },
                        success: function(response, options) {
                            var message = response.responseText;
                            Ext.example.msg(message);
                            Ext.getCmp('ibmAppNoId').reset();
                            Ext.getCmp('ApplicationdateId').reset();
                            Ext.getCmp('typeComboId').reset();
                            Ext.getCmp('IBMTraderNoId').reset();
                            Ext.getCmp('nameOfTraderId').reset();
                            Ext.getCmp('addressId').reset();
                            Ext.getCmp('panNoId').reset();
                            Ext.getCmp('iecNoId').reset();
                            Ext.getCmp('tinNoId').reset();
                            Ext.getCmp('dmgNoId').reset();
                            Ext.getCmp('dateOfIssueId').reset();
                            Ext.getCmp('aliasNameId').reset();
                            Ext.getCmp('gstNoId').reset();
                            Ext.getCmp('appNoTBRId').reset();
                            myWin.hide();
                            routeMasterOuterPanelWindow.getEl().unmask();
                            store.load({
                                params: {
                                    CustId: custId,
			                        custName: Ext.getCmp('custcomboId').getRawValue(),
			                        jspName:jspName
                                },
                                callback: function(){
                                    	if (buttonValue == 'Modify' &&message=="Updated Successfully") {
                                    	//window.open("<%=request.getContextPath()%>/PdfForTrader?autoGeneratedKeys=" + id);
		                                }
		                                else {
		                                var rec = store.getAt(0);
		                                var id1 = rec.data['uniqueIdDataIndex'];
		                                if(message=="Saved Successfully"){
		        						  //window.open("<%=request.getContextPath()%>/PdfForTrader?autoGeneratedKeys=" + id1);
		        						  }
		                                }
                                    }
                            });
                        },
                        failure: function() {
                            Ext.example.msg("Error");
                            store.reload();
                            myWin.hide();
                        }
                    });
                    //}
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
    height: 465,
    width: 490,
    standardSubmit: true,
    frame: true,
    items: [innerPanelForTraderMasterDetails, innerWinButtonPanel]
});

myWin = new Ext.Window({
    title: titelForInnerPanel,
    closable: false,
    resizable: false,
    modal: true,
    autoScroll: false,
    height: 470,
    width: 500,
    id: 'myWinId',
    items: [routeMasterOuterPanelWindow]
});

function addRecord() {
    if (Ext.getCmp('custcomboId').getValue() == "") {
        Ext.example.msg("<%=SelectCustomerName%>");
        return;
    }
    buttonValue = '<%=Add%>';
    titelForInnerPanel = '<%=Add_Trader_Master_Details%>';
    if (Ext.getCmp('typeComboId').getValue() == "RAISING CONTRACTOR") {
    	titelForInnerPanel = '<%=Add_Trader_Master_Details%>';
    	
        
    }
    myWin.setPosition(380, 30);
    myWin.show();
    //  myWin.setHeight(350);

    Ext.getCmp('ibmAppNoId').reset();
    Ext.getCmp('ApplicationdateId').reset();
    Ext.getCmp('typeComboId').reset();
    Ext.getCmp('IBMTraderNoId').reset();
    Ext.getCmp('nameOfTraderId').reset();
    Ext.getCmp('addressId').reset();
    Ext.getCmp('panNoId').reset();
    Ext.getCmp('iecNoId').reset();
    Ext.getCmp('tinNoId').reset();
    Ext.getCmp('dmgNoId').reset();
    Ext.getCmp('dateOfIssueId').reset();
    Ext.getCmp('aliasNameId').reset();
    Ext.getCmp('gstNoId').reset();
    Ext.getCmp('appNoTBRId').reset();
    Ext.getCmp('TraderInfoId').setTitle('<%=Trader_Master_Details%>');
    Ext.getCmp('IBMTradeNoLabelId').setText('<%=IBM_Trader_No%>');
   	Ext.getCmp('mandatoryIBMTraderNo').setText('*');
   	Ext.getCmp('NameoftraderLabelId').setText('<%=Name_Of_Trader%>');
   	Ext.getCmp('iecNoLabelId').setText('<%=IEC_Number%>');
   	Ext.getCmp('dmgNoLabelId').setText('<%=DMG_Trader_No%>');
    Ext.getCmp('dmgNoId').enable();
    Ext.getCmp('IBMTraderNoId').enable();
    Ext.getCmp('ibmAppNoId').enable();
    Ext.getCmp('typeComboId').enable();
    Ext.getCmp('ibmAppNoId').setReadOnly(false);
    Ext.getCmp('IBMTraderNoId').setReadOnly(false);
    Ext.getCmp('dmgNoId').setReadOnly(false);
    Ext.getCmp('typeComboId').setReadOnly(false);
    myWin.setTitle(titelForInnerPanel);
}

function modifyData() {
    if (Ext.getCmp('custcomboId').getValue() == "") {
        Ext.example.msg("<%=SelectCustomerName%>");
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
    buttonValue = '<%=Modify%>';
    titelForInnerPanel = '<%=Modify_Trader_Master_Details%>';
    var selected = grid.getSelectionModel().getSelected();
    if(selected.get('typeIndex')=='RAISING CONTRACTOR'){
     	Ext.getCmp('TraderInfoId').setTitle('Raising Contractor Details');
        Ext.getCmp('mandatoryIBMTraderNo').setText('');
		Ext.getCmp('IBMTradeNoLabelId').setText('Incorporation Certificate');
    	Ext.getCmp('NameoftraderLabelId').setText('Name of RC');
    	Ext.getCmp('iecNoLabelId').setText('Service Tax No');
    	Ext.getCmp('dmgNoLabelId').setText('DMG RC Code');
    }else{
    	Ext.getCmp('TraderInfoId').setTitle('<%=Trader_Master_Details%>');
    	Ext.getCmp('IBMTradeNoLabelId').setText('<%=IBM_Trader_No%>');
    	Ext.getCmp('mandatoryIBMTraderNo').setText('*');
    	Ext.getCmp('NameoftraderLabelId').setText('<%=Name_Of_Trader%>');
    	Ext.getCmp('iecNoLabelId').setText('<%=IEC_Number%>');
    	Ext.getCmp('dmgNoLabelId').setText('<%=DMG_Trader_No%>');
    }
    myWin.setPosition(380, 30);
    myWin.setTitle(titelForInnerPanel);
    myWin.show();

    
    Ext.getCmp('ibmAppNoId').setValue(selected.get('ibmApplicationNoIndex'));
    Ext.getCmp('ApplicationdateId').setValue(selected.get('applicationDateIndex'));
    Ext.getCmp('typeComboId').setValue(selected.get('typeIndex'));
    Ext.getCmp('addressId').setValue(selected.get('addressIndex'));
    Ext.getCmp('panNoId').setValue(selected.get('panNoIndex'));
    Ext.getCmp('tinNoId').setValue(selected.get('tinNoIndex'));
    Ext.getCmp('dateOfIssueId').setValue(selected.get('dateOfIssueIndex'));
    Ext.getCmp('aliasNameId').setValue(selected.get('aliasNameIndex'));
    Ext.getCmp('gstNoId').setValue(selected.get('gstNoIndex'));
    Ext.getCmp('appNoTBRId').setValue(selected.get('applicationNoTBRIndex'));
    if(selected.get('typeIndex')=='RAISING CONTRACTOR'){
	    Ext.getCmp('IBMTraderNoId').setValue(selected.get('incorpCertIndex'));
	    Ext.getCmp('nameOfTraderId').setValue(selected.get('nameOfRCIndex'));
	    Ext.getCmp('iecNoId').setValue(selected.get('serviceTaxIndex'));
	    Ext.getCmp('dmgNoId').setValue(selected.get('dmgRCNoIndex'));
    }else{
	    Ext.getCmp('IBMTraderNoId').setValue(selected.get('ibmTraderNumberIndex'));
	    Ext.getCmp('nameOfTraderId').setValue(selected.get('nameOfTraderIndex'));
	    Ext.getCmp('iecNoId').setValue(selected.get('iecNoIndex'));
	    Ext.getCmp('dmgNoId').setValue(selected.get('dmgTraderNoIndex'));
    }
    if('<%=isltsp%>'==0){
    	Ext.getCmp('IBMTraderNoId').setReadOnly(false);
    	Ext.getCmp('dmgNoId').setReadOnly(false);
    }else{
    	Ext.getCmp('IBMTraderNoId').setReadOnly(true);
    	Ext.getCmp('dmgNoId').setReadOnly(true);
    }
    Ext.getCmp('ibmAppNoId').setReadOnly(true);
    Ext.getCmp('typeComboId').setReadOnly(true);
}

var reader = new Ext.data.JsonReader({
    idProperty: 'ownMasterid',
    root: 'traderMasterDetailsRoot',
    totalProperty: 'total',
    fields: [{
        name: 'slnoIndex'
    }, {
        name: 'uniqueIdDataIndex'
    }, {
        name: 'typeIndex'
    }, {
        name: 'ibmApplicationNoIndex'
    }, {
        name: 'applicationNoTBRIndex'
    }, {
        type: 'date',
        dateFormat: getDateFormat(),
        name: 'applicationDateIndex'
    }, {
        name: 'ibmTraderNumberIndex'
    }, {
        name: 'incorpCertIndex'
    }, {
        name: 'nameOfTraderIndex'
    }, {
        name: 'nameOfRCIndex'
    }, {
        name: 'addressIndex'
    }, {
        name: 'panNoIndex'
    }, {
        name: 'iecNoIndex'
    }, {
        name: 'serviceTaxIndex'
    }, {
        name: 'tinNoIndex'
    }, {
        name: 'dmgTraderNoIndex'
    }, {
        name: 'dmgRCNoIndex'
    }, {
        type: 'date',
        dateFormat: getDateFormat(),
        name: 'dateOfIssueIndex'
    }, {
        name: 'purchasedROMIndex'
    }, {
        name: 'purchasedProcessedOreIndex'
    }, {
        name: 'aliasNameIndex'
    }, {
        name: 'gstNoIndex'
    }]
});

var store = new Ext.data.GroupingStore({
    autoLoad: false,
    proxy: new Ext.data.HttpProxy({
        url: '<%=request.getContextPath()%>/MiningTraderMasterAction.do?param=getTraderMasterDetails',
        method: 'POST'
    }),
    storeId: 'tarderMasterId',
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
        dataIndex: 'typeIndex'
    }, {
        type: 'string',
        dataIndex: 'ibmApplicationNoIndex'
    },  {
        type: 'string',
        dataIndex: 'applicationNoTBRIndex'
    }, {
        type: 'date',
        dataIndex: 'applicationDateIndex'
    }, {
        type: 'string',
        dataIndex: 'ibmTraderNumberIndex'
    }, {
        type: 'string',
        dataIndex: 'incorpCertIndex'
    }, {
        type: 'string',
        dataIndex: 'nameOfTraderIndex'
    }, {
        type: 'string',
        dataIndex: 'nameOfRCIndex'
    }, {
        type: 'string',
        dataIndex: 'addressIndex'
    }, {
        type: 'string',
        dataIndex: 'panNoIndex'
    }, {
        type: 'string',
        dataIndex: 'iecNoIndex'
    }, {
        type: 'string',
        dataIndex: 'serviceTaxIndex'
    }, {
        type: 'string',
        dataIndex: 'tinNoIndex'
    }, {
        type: 'string',
        dataIndex: 'dmgTraderNoIndex'
    }, {
        type: 'string',
        dataIndex: 'dmgRCNoIndex'
    }, {
        type: 'date',
        dataIndex: 'dateOfIssueIndex'
    }, {
        type: 'string',
        dataIndex: 'purchasedROMIndex'
    },{
        type: 'string',
        dataIndex: 'purchasedProcessedOreIndex'
    },{
        type: 'string',
        dataIndex: 'aliasNameIndex'
    },{
        type: 'string',
        dataIndex: 'gstNoIndex'
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
            dataIndex: 'uniqueIdDataIndex',
            hidden: true,
            header: "<span style=font-weight:bold;>Uid</span>",
            filter: {
                type: 'numeric'
            }
        }, {
            header: "<span style=font-weight:bold;><%=Type%></span>",
            dataIndex: 'typeIndex',
            width: 100,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;>Application No</span>",
            dataIndex: 'ibmApplicationNoIndex',
            width: 100,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;>Application No TBR</span>",
            dataIndex: 'applicationNoTBRIndex',
            width: 100,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=Application_Date%></span>",
            dataIndex: 'applicationDateIndex',
            renderer: Ext.util.Format.dateRenderer(getDateFormat()),
            width: 100,
            filter: {
                type: 'date'
            }
        }, {
            header: "<span style=font-weight:bold;><%=IBM_Trader_No%></span>",
            dataIndex: 'ibmTraderNumberIndex',
            width: 100,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;>Incorporation Certificate</span>",
            dataIndex: 'incorpCertIndex',
            width: 100,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=Name_Of_Trader%></span>",
            dataIndex: 'nameOfTraderIndex',
            width: 100,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;>Name Of RC</span>",
            dataIndex: 'nameOfRCIndex',
            width: 100,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=Address%></span>",
            dataIndex: 'addressIndex',
            width: 50,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=PAN_No%></span>",
            dataIndex: 'panNoIndex',
            width: 50,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=IEC_Number%></span>",
            dataIndex: 'iecNoIndex',
            width: 70,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;>Service Tax No</span>",
            dataIndex: 'serviceTaxIndex',
            width: 70,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=TIN_No%></span>",
            dataIndex: 'tinNoIndex',
            width: 50,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=DMG_Trader_No%></span>",
            dataIndex: 'dmgTraderNoIndex',
            width: 100,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;>DMG RC Code</span>",
            dataIndex: 'dmgRCNoIndex',
            width: 100,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=Date_Of_Issue%></span>",
            dataIndex: 'dateOfIssueIndex',
            renderer: Ext.util.Format.dateRenderer(getDateFormat()),
            width: 100,
            filter: {
                type: 'date'
            }
        }, {
            header: "<span style=font-weight:bold;><%=Purchased_ROM%></span>",
            dataIndex: 'purchasedROMIndex',
            width: 100,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=Purchased_Processed_Ore%></span>",
            dataIndex: 'purchasedProcessedOreIndex',
            width: 120,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;>Alias Name</span>",
            dataIndex: 'aliasNameIndex',
            width: 120,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;>GST No</span>",
            dataIndex: 'gstNoIndex',
            width: 120,
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

grid = getGrid('<%=Trader_Master%>', '<%=NoRecordsFound%>', store, screen.width - 60, 440, 30, filters, '<%=ClearFilterData%>', false, '', 21, false, '', false, '', true, '<%=Excel%>', jspName, exportDataType, false, 'PDF', true, '<%=Add%>', true, '<%=Modify%>', false, '<%=Delete%>');

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
    var cm =grid.getColumnModel();  
    for (var j = 1; j < cm.getColumnCount(); j++) {
       if(j==4||j==3){cm.setColumnWidth(j,120); continue;}
       cm.setColumnWidth(j,110);
    }
    sb = Ext.getCmp('form-statusbar');
});
--></script>
</body>
</html>
<%}%>
<%}%>
