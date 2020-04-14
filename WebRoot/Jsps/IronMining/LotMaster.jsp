<%@ page language="java"
	import="java.util.*,t4u.functions.CommonFunctions,t4u.beans.*,t4u.common.*"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://packtag.sf.net" prefix="pack"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
if (request.getParameter("list") != null) {
		String list = request.getParameter("list").toString().trim();
		String[] str = list.split(",");
		int systemid = Integer.parseInt(str[0].trim());
		int customerid = Integer.parseInt(str[1].trim());
		int userid = Integer.parseInt(str[2].trim());
		String language = str[3].trim();
		LoginInfoBean loginInfo = new LoginInfoBean();
		loginInfo.setSystemId(systemid);
		loginInfo.setCustomerId(customerid);
		loginInfo.setUserId(userid);
		loginInfo.setLanguage(language);
		loginInfo.setStyleSheetOverride("N");
		loginInfo.setZone(str[4].trim());
		loginInfo.setOffsetMinutes(Integer.parseInt(str[5].trim()));
		loginInfo.setSystemName(str[6].trim());
		loginInfo.setCategory(str[7].trim());
		loginInfo.setStyleSheetOverride("N");
		if (str.length > 8) {
			loginInfo.setCustomerName(str[8].trim());
		}
		if (str.length > 9) {
			loginInfo.setCategoryType(str[9].trim());
		} 
		if (str.length > 10) {
			loginInfo.setUserName(str[10].trim());
		}
		if(str.length>11){
		loginInfo.setCountryCode(Integer.parseInt(str[11].trim()));
		}
			session.setAttribute("loginInfoDetails", loginInfo);
		}
	CommonFunctions cf = new CommonFunctions();
	LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
	if (loginInfo == null) {
		response.sendRedirect(request.getContextPath()
				+ "/Jsps/Common/SessionDestroy.html");
	} else {
		session.setAttribute("loginInfoDetails", loginInfo);
		String language = loginInfo.getLanguage();
		
ArrayList<String> tobeConverted = new ArrayList<String>();
tobeConverted.add("Add");
tobeConverted.add("No_Records_Found");
tobeConverted.add("Clear_Filter_Data");
tobeConverted.add("Save");
tobeConverted.add("Cancel");
tobeConverted.add("Excel");
tobeConverted.add("Select_Customer");
tobeConverted.add("Customer_Name");
tobeConverted.add("Lot_No");
tobeConverted.add("Lot_Location");
tobeConverted.add("Grade");
tobeConverted.add("Type");
tobeConverted.add("Quantity");
tobeConverted.add("Enter_Grade");
tobeConverted.add("Select_Type");
tobeConverted.add("Enter_Quantity");
tobeConverted.add("SLNO");
tobeConverted.add("Enter_Lot_Number");
tobeConverted.add("Select_Lot_Location");
tobeConverted.add("Lot_Details");
tobeConverted.add("Add_Lot_Details");


ArrayList<String> convertedWords = new ArrayList<String>();
convertedWords = cf.getLanguageSpecificWordForKey(tobeConverted,language);
String Add=convertedWords.get(0);
String NoRecordsFound=convertedWords.get(1);
String ClearFilterData=convertedWords.get(2);
String Save=convertedWords.get(3);
String Cancel=convertedWords.get(4);
String Excel=convertedWords.get(5);
String SelectCustomer=convertedWords.get(6);
String CustomerName=convertedWords.get(7);
String LotNo=convertedWords.get(8);
String LotLocation=convertedWords.get(9);
String Grade=convertedWords.get(10);
String Type=convertedWords.get(11);
String Quantity=convertedWords.get(12);
String EnterGrade=convertedWords.get(13);
String SelectType=convertedWords.get(14);
String EnterQuantity=convertedWords.get(15);
String SLNO=convertedWords.get(16);
String EnterLotNumber=convertedWords.get(17);
String SelectLotLocation=convertedWords.get(18);
String LotDetails=convertedWords.get(19);
String AddLotDetails=convertedWords.get(20);


		 

int userId=loginInfo.getUserId(); 
int systemId = loginInfo.getSystemId();
int customerId = loginInfo.getCustomerId();

String userAuthority=cf.getUserAuthority(systemId,userId);	

if(customerId > 0 && loginInfo.getIsLtsp()== -1 && !userAuthority.equalsIgnoreCase("Admin"))
	{
		response.sendRedirect(request.getContextPath()+ "/Jsps/Common/401Error.html");
	}
	else{

%>

<!DOCTYPE HTML>
<html>
	<head>
		<base href="<%=basePath%>">
		 <title>Lot Master.jsp</title>
	</head>
	<body>
	 <%if (loginInfo.getStyleSheetOverride().equals("Y")){%>
       <jsp:include page="../Common/ImportJSSandMining.jsp"/>
	   <jsp:include page="../IronMining/css.jsp" />
		<%}else {%>
		<jsp:include page="../Common/ImportJS.jsp" />
		<jsp:include page="../IronMining/css.jsp" />
		<%} %>
		 <jsp:include page="../Common/ExportJS.jsp" />
 <script>
 var outerPanel;
 var jspName = "LOT REPORT";
 var exportDataType = "int,string,string,string,string,number,string,number,string,number,string,string,string";
 var grid;
 var dtcur;

 var customercombostore = new Ext.data.JsonStore({
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
                         CustID: custId,
                         jspName: jspName,
                         CustName: Ext.getCmp('custcomboId').getRawValue()
                     }
                 });
                 HubLocationStore.load({
                     params: {
                         CustID: custId
                     }
                 });
             }
         }
     }
 });


 var custnamecombo = new Ext.form.ComboBox({
     store: customercombostore,
     id: 'custcomboId',
     mode: 'local',
     forceSelection: true,
     emptyText: '<%=SelectCustomer%>',
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
                         CustID: custId,
                         jspName: jspName,
                         CustName: Ext.getCmp('custcomboId').getRawValue()
                     }
                 });
                 HubLocationStore.load({
                     params: {
                         CustID: custId
                     }
                 });
             }
         }
     }
 });

 var HubLocationStore = new Ext.data.JsonStore({
     url: '<%=request.getContextPath()%>/PlantMasterAction.do?param=getHubLocation',
     id: 'hubLocationStoreId',
     root: 'sourceHubStoreRoot',
     autoload: false,
     remoteSort: true,
     fields: ['Hubname', 'HubID']
 });

 var HubLocationCombo = new Ext.form.ComboBox({
     store: HubLocationStore,
     id: 'HubLocationcomboId',
     mode: 'local',
     forceSelection: true,
     emptyText: '<%=SelectLotLocation%>',
     blankText: '<%=SelectLotLocation%>',
     resizable: true,
     selectOnFocus: true,
     allowBlank: true,
     anyMatch: true,
     typeAhead: false,
     triggerAction: 'all',
     lazyRender: true,
     valueField: 'HubID',
     displayField: 'Hubname',
     cls: 'selectstylePerfectnew',
     listeners: {
         select: {
             fn: function() {
                 hubLocationId = Ext.getCmp('HubLocationcomboId').getValue();
             }
         }
     }
 });

 var typestore = new Ext.data.SimpleStore({
     id: 'typeStoreId',
     fields: ['Name', 'Value'],
     autoLoad: false,
     data: [
         ['Lumps', 'Lumps'],
         ['Fines', 'Fines'],
         ['ROM', 'ROM'],
         ['Tailings', 'Tailings'],
         ['Concentrates', 'Concentrates']
     ]
 });
 var typeCombo = new Ext.form.ComboBox({
     store: typestore,
     id: 'typecomboId',
     mode: 'local',
     forceSelection: true,
     emptyText: '<%=SelectType%>',
     resizable: true,
     selectOnFocus: true,
     allowBlank: false,
     anyMatch: true,
     typeAhead: false,
     triggerAction: 'all',
     lazyRender: true,
     valueField: 'Value',
     displayField: 'Name',
     cls: 'selectstylePerfectnew',
     listeners: {
         select: {
             fn: function() {}
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
         custnamecombo
     ]
 });

 var innerPanelForLOTMaster = new Ext.form.FormPanel({
     standardSubmit: true,
     collapsible: false,
     autoScroll: false,
     height: 390,
     width: 550,
     frame: false,
     id: 'innerPanelForLotMasterId',
     layout: 'table',
     resizable: true,
     layoutConfig: {
         columns: 4
     },
     items: [{
         xtype: 'fieldset',
         title: '<%=LotDetails%>',
         cls: 'my-fieldset',
         collapsible: false,
         autoScroll: true,
         colspan: 3,
         id: 'LotMasterDetailsid',
         width: 500,
         height: 390,
         layout: 'table',
         layoutConfig: {
             columns: 3,
             tableAttrs: {
                 style: {
                     width: '88%'
                 }
             }
         },
         items: [{
                 xtype: 'label',
                 text: '*',
                 cls: 'mandatoryfield',
                 id: 'lotnoId'
             }, {
                 xtype: 'label',
                 text: '<%=LotNo%>' + ' :',
                 cls: 'labelstylenew',
                 id: 'lotId'
             }, {
                 xtype: 'textfield',
                 cls: 'selectstylePerfectnew',
                 id: 'lotnoid1',
                 mode: 'local',
                 forceSelection: true,
                 emptyText: '<%=EnterLotNumber%>',
                 blankText: '<%=EnterLotNumber%>',
                 labelSeparator: '',
                  listeners:{
					change: function(field, newValue, oldValue){
					field.setValue(newValue.toUpperCase().trim());
					if(field.getValue().length> 50){
					Ext.example.msg("Field exceeded it's Maximum length");
					field.setValue(newValue.substr(0,50).toUpperCase().trim()); field.focus();
					 } 
					}
					}
             },{
                 xtype: 'label',
                 text: '*',
                 cls: 'mandatoryfield',
                 id: 'lotlocationId'
             }, {
                 xtype: 'label',
                 text: '<%=LotLocation%>' + ' :',
                 cls: 'labelstylenew',
                 id: 'lotlocId'
             },
             HubLocationCombo, {
                 xtype: 'label',
                 text: '*',
                 cls: 'mandatoryfield',
                 id: 'gradeid'
             }, {
                 xtype: 'label',
                 text: '<%=Grade%>' + ' :',
                 cls: 'labelstylenew',
                 id: 'gradeId'
             }, {
                 xtype: 'textfield',
                 cls: 'selectstylePerfectnew',
                 id: 'gradeid1',
                 mode: 'local',
                 forceSelection: true,
                 emptyText: '<%=EnterGrade%>',
                 blankText: '<%=EnterGrade%>',
                  labelSeparator: '',
                  listeners:{
					change: function(field, newValue, oldValue){
					field.setValue(newValue.toUpperCase().trim());
					if(field.getValue().length> 50){
					Ext.example.msg("Field exceeded it's Maximum length");
					field.setValue(newValue.substr(0,50).toUpperCase().trim()); field.focus();
					 } 
					}
					}
              }, {
                 xtype: 'label',
                 text: '*',
                 cls: 'mandatoryfield',
                 id: 'typeid'
             }, {
                 xtype: 'label',
                 text: '<%=Type%>' + ' :',
                 cls: 'labelstylenew',
                 id: 'typeid1'
             },
             typeCombo, {
                 xtype: 'label',
                 text: '*',
                 cls: 'mandatoryfield',
                 id: 'quantityid'
             }, {
                 xtype: 'label',
                 text: '<%=Quantity%>' + ' :',
                 cls: 'labelstylenew',
                 id: 'quantityId'
             }, {
                 xtype: 'numberfield',
                 cls: 'selectstylePerfectnew',
                 id: 'quantityID',
                 mode: 'local',
                 forceSelection: true,
                 emptyText: '<%=EnterQuantity%>',
                 blankText: '<%=EnterQuantity%>',
                 selectOnFocus: true,
                 allowBlank: false,
                 allowNegative: false,
                 labelSeparator: '',
                 autoCreate: {
                     tag: "input",
                     maxlength: 9,
                     autocomplete: "off"
                 },
                 allowBlank: false,
                 listeners:{ change: function(f, n, o){ f.setValue(Math.abs(n)); } }
             },{width:10
             }, {
                 xtype: 'label',
                 text: 'Amount Paid(40%)' + ' :',
                 cls: 'labelstylenew',
                 id: 'amountid'
             },{
                 xtype: 'numberfield',
                 cls: 'selectstylePerfectnew',
                 id: 'numid2',
                 mode: 'local',
                 forceSelection: true,
                 emptyText: 'Enter Amount paid',
                 blankText: 'Enter Amount paid',
                 labelSeparator: '',
                 autoCreate: {
                     tag: "input",
                     maxlength: 9,
                     autocomplete: "off"
                 },
                 allowBlank: false,
                 listeners:{ change: function(f, n, o){ f.setValue(Math.abs(n)); } }
              },{width:10 },{
               xtype: 'label',
               cls: 'labelstylenew',
               id: 'startdatelab',
               text: 'Date(40%)' + ' :'
          }, {
              xtype: 'datefield',
              cls: 'selectstylePerfectnew',
              width: 185,
              format: getDateFormat(),
              emptyText: 'Select Date',
              //allowBlank: false,
              blankText: 'Select Date',
              id: 'startdate',
              maxValue:dtcur,
              value: dtcur,
           },{width:10
                }, {
                 xtype: 'label',
                 text: 'Amount Paid(60%)' + ' :',
                 cls: 'labelstylenew',
                 id: 'amountid1'
             },{
                 xtype: 'numberfield',
                 cls: 'selectstylePerfectnew',
                 id: 'numid3',
                 mode: 'local',
                 forceSelection: true,
                 emptyText: 'Enter Amount paid',
                 blankText: 'Enter Amount paid',
                 labelSeparator: '',
                 autoCreate: {
                     tag: "input",
                     maxlength: 9,
                     autocomplete: "off"
                 },
                 allowBlank: false,
                 listeners:{ change: function(f, n, o){ f.setValue(Math.abs(n)); } }
              },{
                width:10
           },{
               xtype: 'label',
               cls: 'labelstylenew',
               id: 'startdatelab1',
               text: 'Date(60%)' + ' :'
          }, {
              xtype: 'datefield',
              cls: 'selectstylePerfectnew',
              width: 185,
              format: getDateFormat(),
              emptyText: 'Select Date',
              //allowBlank: false,
              blankText: 'Select Date',
              id: 'startdate1',
              maxValue:dtcur,
              value: dtcur
           },{
                 xtype: 'label',
                 text: '*',
                 cls: 'mandatoryfield',
                 id: 'remid'
             }, {
                 xtype: 'label',
                 text: 'Remarks' + ' :',
                 cls: 'labelstylenew',
                 id: 'remarksid'
             },{
                 xtype: 'textarea',
                 cls: 'selectstylePerfectnew',
                 id: 'numid1',
                 mode: 'local',
                 forceSelection: true,
                 width:200,
                 height:80,
                 emptyText: 'Enter Remarks',
                 blankText: 'Enter Remarks',
                  labelSeparator: '',
                  listeners:{
					change: function(field, newValue, oldValue){
					field.setValue(newValue.toUpperCase().trim());
					if(field.getValue().length> 500){
					Ext.example.msg("Field exceeded it's Maximum length");
					field.setValue(newValue.substr(0,500).toUpperCase().trim()); field.focus();
					 } 
					}
					}
              }
         ]
     }]
 });
 var innerWinButtonPanel = new Ext.Panel({
     id: 'innerWinButtonPanelId',
     standardSubmit: true,
     collapsible: false,
     autoHeight: true,
     height: 110,
     width: 500,
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


                      var pattern = /^[a-zA-Z0-9][a-zA-Z0-9\s]*/;
                      if (!pattern.test(Ext.getCmp('lotnoid1').getValue())) {
                          Ext.example.msg("Enter Lot Number Starting With Character Or Number");
                          Ext.getCmp('lotnoid1').focus();
                          return;
                        }
                     
                     if (Ext.getCmp('HubLocationcomboId').getValue() == "") {
                         Ext.example.msg("<%=SelectLotLocation%>");
                         Ext.getCmp('HubLocationcomboId').focus();
                         return;
                     }
                      var pattern = /^[a-zA-Z0-9][a-zA-Z0-9\s]*/;
                       if (!pattern.test(Ext.getCmp('gradeid1').getValue())) {
                         Ext.example.msg("Enter Grade Starting With Number or Character");
                         Ext.getCmp('gradeid1').focus();
                         return;
                     }
                     if (Ext.getCmp('typecomboId').getValue() == "") {
                         Ext.example.msg("<%=SelectType%>");
                         Ext.getCmp('typecomboId').focus();
                         return;
                     }
                     if (Ext.getCmp('quantityID').getValue() == "") {
                         Ext.example.msg("<%=EnterQuantity%>");
                         Ext.getCmp('quantityID').focus();
                         Ext.getCmp('quantityID').reset();
                         return;
                     }
                    if (Ext.getCmp('numid2').getValue() != ""  && Ext.getCmp('startdate').getValue() == "") {
                         Ext.example.msg(" Please Enter Date(40%) corresponding to Amount Paid(40%)");
                         Ext.getCmp('startdate').focus();
                         return;
                     }
                     if (Ext.getCmp('numid2').getValue() == ""  && Ext.getCmp('startdate').getValue() != "") {
                         Ext.example.msg(" Please Enter Amount Paid(40%) corresponding to Date(40%)");
                         Ext.getCmp('numid2').focus();
                         return;
                     }
                     if (Ext.getCmp('numid3').getValue() != ""  && Ext.getCmp('startdate1').getValue() == "") {
                         Ext.example.msg(" Please Enter Date(60%) corresponding to Amount Paid(60%)");
                         Ext.getCmp('startdate1').focus();
                         return;
                     }
                     if (Ext.getCmp('numid3').getValue() == ""  && Ext.getCmp('startdate1').getValue() != "") {
                         Ext.example.msg(" Please Enter Amount Paid(60%) corresponding to Date(60%)");
                         Ext.getCmp('numid3').focus();
                         return;
                     }
                     if (Ext.getCmp('numid1').getValue() == "") {
                         Ext.example.msg("Enter Remarks");
                         Ext.getCmp('numid1').focus();
                         Ext.getCmp('numid1').reset();
                         return;
                     }
                     var rec;
                     var selected;
                     if(buttonValue=='Modify'){
                      selected = grid.getSelectionModel().getSelected();
                      id = selected.get('uidIndex');
                    }
                     LotMasterOuterPanelWindow.getEl().mask();
                     Ext.Ajax.request({
                         url: '<%=request.getContextPath()%>/LotMasterAction.do?param=addmodifyLotMasterDetails',
                         method: 'POST',
                         params: {
                             buttonValue: buttonValue,
                             custId: Ext.getCmp('custcomboId').getValue(),
                             LotNo: Ext.getCmp('lotnoid1').getValue(),
                             LotLocation: Ext.getCmp('HubLocationcomboId').getValue(),
                             grade: Ext.getCmp('gradeid1').getValue(),
                             type: Ext.getCmp('typecomboId').getValue(),
                             quantity: Ext.getCmp('quantityID').getValue(),
                             remarks: Ext.getCmp('numid1').getValue(),
                             amount: Ext.getCmp('numid2').getValue(),
                             date: Ext.getCmp('startdate').getValue(),
                             amount1: Ext.getCmp('numid3').getValue(),
                             date1: Ext.getCmp('startdate1').getValue(),
                             id:id

                         },
                         success: function(response, options) {
                             var message = response.responseText;
                             Ext.example.msg(message);
                             Ext.getCmp('lotnoid1').reset();
                             Ext.getCmp('HubLocationcomboId').reset();
                             Ext.getCmp('gradeid1').reset();
                             Ext.getCmp('typecomboId').reset();
                             Ext.getCmp('quantityID').reset();
                             Ext.getCmp('numid1').reset();
                             Ext.getCmp('numid2').reset();
                             Ext.getCmp('startdate').reset();
                             Ext.getCmp('numid3').reset();
                             Ext.getCmp('startdate1').reset();
                             myWin.hide();
                             store.reload();
                             LotMasterOuterPanelWindow.getEl().unmask();
                         },
                         failure: function() {
                             Ext.example.msg("Error");
                             store.reload();
                             myWin.hide();
                             LotMasterOuterPanelWindow.getEl().unmask();
                             Ext.getCmp('lotnoid1').reset();
                             Ext.getCmp('HubLocationcomboId').reset();
                             Ext.getCmp('gradeid1').reset();
                             Ext.getCmp('typecomboId').reset();
                             Ext.getCmp('quantityID').reset();
                             Ext.getCmp('numid1').reset();
                             Ext.getCmp('numid2').reset();
                             Ext.getCmp('startdate').reset();
                             Ext.getCmp('numid3').reset();
                             Ext.getCmp('startdate1').reset();
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
                     Ext.getCmp('lotnoid1').reset();
                     Ext.getCmp('HubLocationcomboId').reset();
                     Ext.getCmp('gradeid1').reset();
                     Ext.getCmp('typecomboId').reset();
                     Ext.getCmp('quantityID').reset();
                     Ext.getCmp('numid1').reset();
                     Ext.getCmp('numid2').reset();
                     Ext.getCmp('startdate').reset();
                     Ext.getCmp('numid3').reset();
                     Ext.getCmp('startdate1').reset();
                 }
             }
         }
     }]
 });
 var LotMasterOuterPanelWindow = new Ext.Panel({
     width: 550,
     height: 500,
     standardSubmit: true,
     frame: true,
     items: [innerPanelForLOTMaster, innerWinButtonPanel]
 })

 myWin = new Ext.Window({
     title: '<%=AddLotDetails%>',
     closable: false,
     resizable: false,
     modal: true,
     autoScroll: false,
     height: 500,
     width: 550,
     frame: true,
     id: 'myWin',
     items: [LotMasterOuterPanelWindow]
 });
 var cancelInnerPanel = new Ext.form.FormPanel({
     standardSubmit: true,
     collapsible: false,
     frame: false,
     id: 'cancel',

     items: [{
         xtype: 'fieldset',
         width: 480,
         title: 'Cancel Details',
         id: 'closefieldset',
         collapsible: false,
         layout: 'table',
         layoutConfig: {
             columns: 5
         },
         items: [{
             xtype: 'label',
             text: '',
             cls: 'mandatoryfield',
             id: 'mandatorycloseLabel'
         }, {
             xtype: 'label',
             text: '*',
             cls: 'mandatoryfield',
             id: 'mandatorycloseLabelId'
         }, {
             xtype: 'label',
             text: 'Remark' + '  :',
             cls: 'labelstyle',
             id: 'remarkLabelId'
         }, {
             width: 10
         }, {
             xtype: 'textarea',
             cls: 'selectstylePerfect',
             id: 'remark',
             emptyText: 'Enter Remarks',
             blankText: 'Enter Remarks'
         }]
     }]
 });
 var winButtonPanelForCancel = new Ext.Panel({
     id: 'winbuttonid12',
     standardSubmit: true,
     collapsible: false,
     height: 8,
     cls: 'windowbuttonpanel',
     frame: true,
     layout: 'table',
     layoutConfig: {
         columns: 4
     },
     buttons: [{
         xtype: 'button',
         text: 'Ok',
         id: 'cancelId1',
         cls: 'buttonstyle',
         iconCls: 'savebutton',
         width: 80,
         listeners: {
             click: {
                 fn: function() {
                     if (Ext.getCmp('remark').getValue() == "") {
                         Ext.example.msg("Enter Remark");
                         Ext.getCmp('remark').focus();
                         return;
                     }
                     cancelWin.getEl().mask();
                     var selected = grid.getSelectionModel().getSelected();
                     id = selected.get('uidIndex');
                     Ext.Ajax.request({
                         url: '<%=request.getContextPath()%>/LotMasterAction.do?param=cancelLotMasterDetails',
                         method: 'POST',
                         params: {
                             id: id,
                             CustID: Ext.getCmp('custcomboId').getValue(),
                             remark: Ext.getCmp('remark').getValue()
                         },
                         success: function(response, options) {
                             var message = response.responseText;
                             Ext.example.msg(message );
                             cancelWin.getEl().unmask();
                             store.reload();
                             cancelWin.hide();
                         },
                         failure: function() {
                             Ext.example.msg("Error");
                             store.reload();
                             Ext.getCmp('remark').reset();
                             cancelWin.hide();
                         }
                     });
                 }
             }
         }
     }, {
         xtype: 'button',
         text: '<%=Cancel%>',
         id: 'cancelButtonId2',
         cls: 'buttonstyle',
         iconCls: 'cancelbutton',
         width: '80',
         listeners: {
             click: {
                 fn: function() {
                     cancelWin.hide();
                     Ext.getCmp('remark').reset();
                 }
             }
         }
     }]
 });
 var cancelPanel = new Ext.Panel({
     standardSubmit: true,
     collapsible: false,
     autoScroll: true,
     width: 490,
     height: 180,
     frame: true,
     id: 'cancelPanel1',
     items: [cancelInnerPanel]
 });
 var outerPanelWindowForCancel = new Ext.Panel({
     standardSubmit: true,
     id: 'cancelwinpanelId1',
     frame: true,
     height: 250,
     width: 520,
     items: [cancelPanel, winButtonPanelForCancel]
 });

 cancelWin = new Ext.Window({
     closable: false,
     modal: true,
     resizable: false,
     autoScroll: false,
     height: 300,
     width: 530,
     id: 'closemyWin',
     items: [outerPanelWindowForCancel]
 });

 function addRecord() {
       Ext.getCmp('lotnoid1').setReadOnly(false);
       Ext.getCmp('HubLocationcomboId').setReadOnly(false);
       Ext.getCmp('gradeid1').setReadOnly(false);
       Ext.getCmp('typecomboId').setReadOnly(false);
  	   Ext.getCmp('quantityID').setReadOnly(false);
  	   Ext.getCmp('numid2').setReadOnly(false);
       Ext.getCmp('startdate').setReadOnly(false);
       Ext.getCmp('numid3').setReadOnly(false);
       Ext.getCmp('startdate1').setReadOnly(false);
  	  
     if (Ext.getCmp('custcomboId').getValue() == "") {
         Ext.example.msg("<%=SelectCustomer%>");
         return;
     }
     buttonValue =  '<%=Add%>';
     AddLotDetails = 'AddDetails';
     myWin.setPosition(450, 10);
     myWin.show();
     Ext.getCmp('lotnoid1').reset();
     Ext.getCmp('HubLocationcomboId').reset();
     Ext.getCmp('gradeid1').reset();
     Ext.getCmp('typecomboId').reset();
     Ext.getCmp('quantityID').reset();
     Ext.getCmp('numid1').reset();
     Ext.getCmp('numid2').reset();
     Ext.getCmp('startdate').reset();
     Ext.getCmp('numid3').reset();
     Ext.getCmp('startdate1').reset();
     
     myWin.setTitle('<%=AddLotDetails%>');

 }

function modifyData() {
  		  Ext.getCmp('lotnoid1').setReadOnly(true);
          Ext.getCmp('HubLocationcomboId').setReadOnly(true);
          Ext.getCmp('gradeid1').setReadOnly(true);
          Ext.getCmp('typecomboId').setReadOnly(true);
  	      Ext.getCmp('quantityID').setReadOnly(true);
  		 
          if (Ext.getCmp('custcomboId').getValue() == "") {
              Ext.example.msg("SelectCustomer");
              return;
          }
          if (grid.getSelectionModel().getCount() == 0) {
              Ext.example.msg("NoRowsSelected");
              return;
          }
          if (grid.getSelectionModel().getCount() > 1) {
              Ext.example.msg("SelectSingleRow");
              return;
          }
          
          buttonValue = 'Modify';
          titelForInnerPanel = 'ModifyDetails';
          myWin.setPosition(450,10);
          myWin.setTitle(titelForInnerPanel);
          myWin.show();
          selected = grid.getSelectionModel().getSelected();
          if (selected.get('amountindex') != 0  &&  selected.get('dateIndex') != "" && selected.get('amoIndex') != 0 && selected.get('date1Index') != "" ) {
              Ext.example.msg(" Cant Modify the Record ");
              myWin.hide();
              return;
          }
          if (selected.get('statusIndex')=='Cancelled') {
              Ext.example.msg(" Status is cancelled you cannot Modify the Record ");
              myWin.hide();
              return;
          }
          Ext.getCmp('lotnoid1').setValue(selected.get('lotnoindex'));
          Ext.getCmp('HubLocationcomboId').setValue(selected.get('lotlocationindex'));
          Ext.getCmp('gradeid1').setValue(selected.get('gradeindex'));
          Ext.getCmp('typecomboId').setValue(selected.get('typeindex'));
          Ext.getCmp('quantityID').setValue(selected.get('quantityindex'));
          Ext.getCmp('numid1').setValue(selected.get('remarksIndex'));
          Ext.getCmp('numid2').setValue(selected.get('amountindex'));
          Ext.getCmp('startdate').setValue(selected.get('dateIndex'));
          Ext.getCmp('numid3').setValue(selected.get('amoIndex'));
          Ext.getCmp('startdate1').setValue(selected.get('date1Index'));
          if(selected.get('amountindex')!=0){
          	Ext.getCmp('numid2').setReadOnly(true);
          	Ext.getCmp('startdate').setReadOnly(true);
          }
          if(selected.get('amoIndex')!=0){
          	Ext.getCmp('numid3').setReadOnly(true);
          	Ext.getCmp('startdate1').setReadOnly(true);
          }
         
      }
 function deleteData(){
 	selected = grid.getSelectionModel().getSelected();
      if (Ext.getCmp('custcomboId').getValue() == "") {
          Ext.example.msg("<%=SelectCustomer%>");
          return;
      }
      if (grid.getSelectionModel().getCount() == 0) {
          Ext.example.msg("No Rows Selected");
          return;
      }
      if (grid.getSelectionModel().getCount() > 1) {
          Ext.example.msg("Select Single Row");
          return;
      }
      if((selected.get('lotAllCount'))>0){
      	 Ext.example.msg("Lot is already Allocated.Can't cancel");
         return;
      }
      if (selected.get('statusIndex')=='Cancelled') {
          Ext.example.msg("Can't Cancel Cancelled records");
          return;
      }
      cancelWin.show();
 }
 var filters = new Ext.ux.grid.GridFilters({
     local: true,
     filters: [{
         type: 'int',
         dataIndex: 'slnoDataIndex'
     }, {
         type: 'string',
         dataIndex: 'lotnoindex'
     }, {
         type: 'string',
         dataIndex: 'lotlocationindex'
     }, {
         type: 'string',
         dataIndex: 'gradeindex'
     }, {
         type: 'string',
         dataIndex: 'typeindex'
     }, {
         type: 'string',
         dataIndex: 'quantityindex'
     },{
         type: 'string',
         dataIndex: 'statusIndex'
     },{
         type: 'string',
         dataIndex: 'remarksIndex'
     },{ 
         type: 'string',
         dataIndex: 'amountindex'
     },{
         type: 'Date',
         dataIndex: 'dateIndex'
     },{
         type: 'string',
         dataIndex: 'amoIndex'
     },{
         type: 'Date',
         dataIndex: 'date1Index'
     }]
 });

 var reader = new Ext.data.JsonReader({
     idProperty: 'lotid',
     root: 'lotroot',
     totalProperty: 'total',
     fields: [{
         name: 'slnoDataIndex'
     }, {
         name: 'lotnoindex'
     }, {
         name: 'lotlocationindex'
     }, {
         name: 'gradeindex'
     }, {
         name: 'typeindex'
     }, {
         name: 'quantityindex'
     }, {
         name: 'statusIndex'
     }, {
         name: 'remarksIndex'
     }, {
     	 name: 'uidIndex'
     },{
     	 name: 'lotAllCount'
     }, {
         name: 'amountindex'
     }, {
         name: 'dateIndex'
     }, {
         name: 'amoIndex'
     }, {
         name: 'date1Index'
     }]
 });

 var store = new Ext.data.GroupingStore({
     autoLoad: false,
     proxy: new Ext.data.HttpProxy({
         url: '<%=request.getContextPath()%>/LotMasterAction.do?param=getLotMasterDetails',
         method: 'POST'
     }),

     storeId: 'lotdetailid',
     reader: reader
 });
 var createColModel = function(finish, start) {
     var columns = [
         new Ext.grid.RowNumberer({
             header: "<span style=font-weight:bold;><%=SLNO%></span>",
             width: 50
         }), {
             dataIndex: 'slnoDataIndex',
             hidden: true,
             header: "<span style=font-weight:bold;><%=SLNO%></span>"
         }, {
             header: "<span style=font-weight:bold;><%=LotNo%></span>",
             dataIndex: 'lotnoindex',
             width: 80
         }, {
             header: "<span style=font-weight:bold;><%=LotLocation%></span>",
             dataIndex: 'lotlocationindex',
             width: 100
         }, {
             header: "<span style=font-weight:bold;><%=Grade%></span>",
             dataIndex: 'gradeindex',
             width: 100
         }, {
             header: "<span style=font-weight:bold;><%=Type%></span>",
             dataIndex: 'typeindex',
             width: 100
         }, {
             header: "<span style=font-weight:bold;><%=Quantity%></span>",
             dataIndex: 'quantityindex',
             align: 'right',
             width: 100
         }, {
              dataIndex: 'uidIndex',
          	  hidden: true,
          	  header: "ID"
         },{
             header: "<span style=font-weight:bold;>Amount Paid(40%)</span>",
             dataIndex: 'amountindex',
             width: 100
        }, {
             header: "<span style=font-weight:bold;>Date(40%)</span>",
             dataIndex: 'dateIndex',
             //renderer: Ext.util.Format.dateRenderer('d-m-Y'),
             width: 100
         }, {
             header: "<span style=font-weight:bold;>Amount Paid(60%)</span>",
             dataIndex: 'amoIndex',
             width: 100
         }, {
             header: "<span style=font-weight:bold;>Date(60%)</span>",
             dataIndex: 'date1Index',
             //renderer: Ext.util.Format.dateRenderer('d-m-Y '),
             width: 100
         },{
            header: "<span style=font-weight:bold;>Remarks</span>",
             dataIndex: 'remarksIndex',
             width: 100
         },{
            header: "<span style=font-weight:bold;>Status</span>",
             dataIndex: 'statusIndex',
             width: 100
         }
          
     ];
     return new Ext.grid.ColumnModel({
         columns: columns.slice(start || 0, finish),
         defaults: {
             sortable: true
         }
     });
 };


 grid = getGrid('Lot Master', '<%=NoRecordsFound%>', store, screen.width - 40, 440, 18, filters, '<%=ClearFilterData%>', false, '', 16, false, '', false, '', true, '<%=Excel%>', jspName, exportDataType,false,'PDF', true, '<%=Add%>', true, 'Modify', true, 'Cancel');

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
</script>
</body>
</html>
<%}%>
<%}%>
 