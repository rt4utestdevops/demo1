<%@ page language="java" import="java.util.*,t4u.functions.*,t4u.beans.*,t4u.common.*" pageEncoding="ISO-8859-1"%>
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
	session.setAttribute("loginInfoDetails",loginInfo);
}
CommonFunctions cf=new CommonFunctions();
LoginInfoBean loginInfo=(LoginInfoBean)session.getAttribute("loginInfoDetails");
if(loginInfo==null){
	response.sendRedirect(request.getContextPath()+ "/Jsps/Common/SessionDestroy.html");
}
else
{
session.setAttribute("loginInfoDetails",loginInfo);
String language = loginInfo.getLanguage();
	int systemId = loginInfo.getSystemId();
	int customerId = loginInfo.getCustomerId();
  ArrayList<String> tobeConverted = new ArrayList<String>();
  tobeConverted.add("Instant_SMS");
  tobeConverted.add("Select_School");
  tobeConverted.add("Select_Country");
  tobeConverted.add("SLNO");
  tobeConverted.add("Class");
  tobeConverted.add(" Route");
  tobeConverted.add("Selection");
  tobeConverted.add("School_Name");
  tobeConverted.add("Compose");
  tobeConverted.add("Message");
  tobeConverted.add("Enter_text_message");
  tobeConverted.add("NOTE");
  tobeConverted.add("More_Then_160_Characters_Considered_as_Muliple_SMS_and_donot_add_any_special_characters.");
  tobeConverted.add("Additional_Mobile_Number(Optional)");
  tobeConverted.add("Mobile_No");
  tobeConverted.add("Enter_Mobile_Numbers_Seperated_by_commas._Eg : 8888888888 ,9999999999");
  tobeConverted.add("SMS_Information");
  tobeConverted.add("SMS_available_at_your_account");
  tobeConverted.add("Submit");
  tobeConverted.add("SMS_Summary");
  tobeConverted.add("Routes");
  tobeConverted.add("Available_SMS");
  tobeConverted.add("SMS_to_be_Sent");
  tobeConverted.add("Do_you_Want_to_Continue?.");
  tobeConverted.add("Send_SMS");
  tobeConverted.add("Cancel");
  tobeConverted.add("Summary");
  tobeConverted.add("Select_School_Name");
  tobeConverted.add("Select_Class_Type");
  tobeConverted.add("Select_Route");
  tobeConverted.add("Enter_Message");
  tobeConverted.add("Instant_SMS_Module");
  
  ArrayList<String> convertedWords = new ArrayList<String>();
convertedWords = cf.getLanguageSpecificWordForKey(tobeConverted,language);
 
String InstantSMS = convertedWords.get(0);
String SelectSchool = convertedWords.get(1);
String SelectCountry = convertedWords.get(2);
String SLNO = convertedWords.get(3);
String Class = convertedWords.get(4);
String Route = convertedWords.get(5);
String Selection = convertedWords.get(6);
String SchoolName = convertedWords.get(7);
String Compose = convertedWords.get(8);
String Message = convertedWords.get(9); 
String Entertextmessage = convertedWords.get(10);
String NOTE=convertedWords.get(11); 
String MoreThen160CharactersConsideredasMulipleSMSanddonotaddanyspecialcharacters = convertedWords.get(12);
String AdditionalMobileNumber= convertedWords.get(13);
String MobileNo= convertedWords.get(14);
String EnterMobileNumbersSeperatedbycommasEg88888888889999999999 = convertedWords.get(15);
String SMSInformation = convertedWords.get(16);
String SMSavailableatyouraccount = convertedWords.get(17);
String Submit= convertedWords.get(18);
String SMSSummary = convertedWords.get(19);
String Routes = convertedWords.get(20); 
String AvailableSMS = convertedWords.get(21);
String SMStobeSent = convertedWords.get(22);
String DoyouWanttoContinue= convertedWords.get(23); 
String SendSMS = convertedWords.get(24); 
String Cancel = convertedWords.get(25); 
String Summary = convertedWords.get(26); 
String SelectSchoolName= convertedWords.get(27);
String SelectClassType = convertedWords.get(28); 
String SelectRoute = convertedWords.get(29); 
String EnterMessage = convertedWords.get(30); 
String InstantSMSModule = convertedWords.get(31); 
%>

<jsp:include page="../Common/header.jsp" />
  <title><%=InstantSMS%></title>
    
	 <style>
  .x-panel-tl
	{
		border-bottom: 0px solid !important;
	}
	.col{
			color:#0B0B61;
			font-family: sans-serif;
			font-size:12px;
			width: 350;
		}
	 .col1{
			color:#0B0B61;
			font-family: sans-serif;
			font-size:12px;
			align: right;
		}
		.ext-strict .x-form-text {
			height: 21px !important;
		}	
label {
			display : inline !important;
		}	
		.footer {
			bottom : -26px !important;
		}
		*.x-btn button {
			font: normal 15px arial , tahoma , verdana , helvetica !important;  
		}
		.x-btn-bc {
			border-bottom: 6px solid #5f6f81 !important; 
		}
  </style>
   
 
  <%if (loginInfo.getStyleSheetOverride().equals("Y")){%>                  
    <jsp:include page="../Common/ImportJSSandMining.jsp"/>                                               
   <%}else {%>  
   <jsp:include page="../Common/ImportJS.jsp" /><%} %>
 
   <script>
   var outerPanel;
   var buttonValue;
   /********************resize window event function***********************/
   var manageAllTasksGrid;
   var jspName = "<%=InstantSMS%>";
   window.onload = function () { 
		refresh();
	}

    //**************************************Customers store*******************************************************//  
   var customercombostore = new Ext.data.JsonStore({
       url: '<%=request.getContextPath()%>/CommonAction.do?param=getCustomer',
       id: 'CustomerStoreId',
       root: 'CustomerRoot',
       autoLoad: true,
       remoteSort: true,
       fields: ['CustId', 'CustName'],
       listeners: {
           load: function (custstore, records, success, options) {
               if ( <%= customerId %> > 0) {
                   Ext.getCmp('custcomboId').setValue('<%=customerId%>');
                   custId = Ext.getCmp('custcomboId').getValue();
                   custName = Ext.getCmp('custcomboId').getRawValue();
					countryId=Ext.getCmp('countryId').getValue();
					firstGridStore.load({
                       params: {
                           CustId: custId,
                           CustName: custName
                       }
                   });
                   secondGridStore.load({
                       params: {
                           CustId: custId,
                           CustName: custName
                       }
                   });
                   countrystore.load({
                       params: {
                           countryId: countryId
                       }
                   });
                   //myMask.show();
                   SMSCountStore.load({
                       params: {
                           CustId: custId
                       },
                       callback: function () {
                           if (SMSCountStore.getCount() > 0) {
                               var record = SMSCountStore.getAt(0);
                               document.getElementById('smsId2').innerHTML = record.data['totalSmsCount'];
                           }
                       }
                   });
                   Ext.getCmp('manualphId2').disable();
               }

           }
       }
   });
    //**************************************Customers Combo*******************************************************//
   var custnamecombo = new Ext.form.ComboBox({
       store: customercombostore,
       id: 'custcomboId',
       mode: 'local',
       forceSelection: true,
       emptyText: '<%=SelectSchool%>',
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
               fn: function () {
                   custId = Ext.getCmp('custcomboId').getValue();
                   custName = Ext.getCmp('custcomboId').getRawValue();
                   countryId=Ext.getCmp('countryId').getValue();
                   Ext.getCmp('schoolNoId').setText(custName);
                   Ext.getCmp('messageId2').reset();
                   Ext.getCmp('countryId').reset();
                   Ext.getCmp('manualphId2').reset();
                   Ext.getCmp('mandId3').setValue('0');
                   firstGridStore.load({
                       params: {
                           CustId: custId,
                           CustName: custName
                       }
                   });
                   secondGridStore.load({
                       params: {
                           CustId: custId,
                           CustName: custName
                       }
                   });
                   countrystore.load({
                       params: {
                           countryId:countryId 
                       }
                   });
                   //myMask.show();
                   SMSCountStore.load({
                       params: {
                           CustId: custId
                       },
                       callback: function () {
                           if (SMSCountStore.getCount() > 0) {
                               var record = SMSCountStore.getAt(0);
                               document.getElementById('smsId2').innerHTML = record.data['totalSmsCount'];
                           }
                       }
                   });
                   Ext.getCmp('manualphId2').disable();

                   if ( <%= customerId %> > 0) {
                       Ext.getCmp('mandId3').setValue('0');
                       Ext.getCmp('custcomboId').setValue('<%= customerId %>');
                       custId = Ext.getCmp('custcomboId').getValue();
                       custName = Ext.getCmp('custcomboId').getRawValue();
						countryId=Ext.getCmp('countryId').getValue();
                       firstGridStore.load({
                           params: {
                               CustId: custId,
                               CustName: custName
                           }
                       });
                       secondGridStore.load({
                           params: {
                               CustId: custId,
                               CustName: custName
                           }
                       });
                       countrystore.load({
                           params: {
                               countryId:countryId
                           }
                       });
                       // myMask.show();
                       SMSCountStore.load({
                           params: {
                               CustId: custId
                           },
                           callback: function () {

                               if (SMSCountStore.getCount() > 0) {
                                   var record = SMSCountStore.getAt(0);
                                   document.getElementById('smsId2').innerHTML = record.data['totalSmsCount'];
                               }
                           }
                       });
                        Ext.getCmp('manualphId2').disable();
                   }
               }
           }
       }
   });

   /**************store for getting Countrty List******************/
   var countrystore = new Ext.data.JsonStore({
       url: '<%=request.getContextPath()%>/SendSchoolSmsAction.do?param=getCountryList',
       id: 'CountryStoreId',
       root: 'CountryRoot',
       autoLoad: true,
       fields: ['ISD_CODE', 'CountryName']
   });
    //***** combo for customername
   var countrycombo = new Ext.form.ComboBox({
       store: countrystore,
       id: 'countryId',
       mode: 'local',
       hidden: false,
       forceSelection: true,
       emptyText: '<%=SelectCountry%>',
       blankText: '<%=SelectCountry%>',
       selectOnFocus: true,
       allowBlank: false,
       anyMatch: true,
       typeAhead: false,
       triggerAction: 'all',
       valueField: 'ISD_CODE',
       displayField: 'CountryName',
       cls: 'selectstylePerfect',
       listeners: {
           select: {
               fn: function () {

					 	Ext.getCmp('manualphId2').enable();
               }
           }
       }
   });
    //**************************************SMSCountStore*******************************************************//  
   var SMSCountStore = new Ext.data.JsonStore({
       url: '<%=request.getContextPath()%>/SendSchoolSmsAction.do?param=getSMSCount',
       id: 'SMSCountId',
       root: 'SMSCountRoot',
       autoLoad: false,
       remoteSort: true,
       fields: ['totalSmsCount']
   });
   
   
    setInterval(function() {
    custId = Ext.getCmp('custcomboId').getValue();
     SMSCountStore.load({
        params: {CustId: custId},
        callback: function() {
           if (SMSCountStore.getCount() > 0) {
                var record = SMSCountStore.getAt(0);
                document.getElementById('smsId2').innerHTML = record.data['totalSmsCount'];
            }
       }
   });
}, 3000);

    //**************************************first grid*******************************************************//
   var sm1 = new Ext.grid.CheckboxSelectionModel({
       checkOnly: true
   });

   var cols1 = new Ext.grid.ColumnModel([

       new Ext.grid.RowNumberer({
           header: "<span style=font-weight:bold;><%=SLNO%></span>",
           width: 40
       }), sm1, {
           header: "<span style=font-weight:bold;><%=Class%></span>",
           width: 135,
           sortable: true,
           dataIndex: 'schooltype'
       }
   ]);

   var reader = new Ext.data.JsonReader({
       root: 'sendSchoolSmsRoot',
       fields: [{
           name: 'slnoIndex'
       }, , {
           name: 'schooltype',
           type: 'string'
       }]
   });
   var filters = new Ext.ux.grid.GridFilters({
       local: true,
       filters: [{
           type: 'numeric',
           dataIndex: 'slnoIndex'
       }, {
           dataIndex: 'schooltype',
           type: 'string'
       }]
   });

    //**************************************firstGridStore*******************************************************//   
   var firstGridStore = new Ext.data.Store({
       url: '<%=request.getContextPath()%>/SendSchoolSmsAction.do?param=getSchoolTypeDetails',
       bufferSize: 367,
       reader: reader,
       autoLoad: false,
       remoteSort: true
   });
    //**************************************firstGrid panel*******************************************************//   
   var firstGrid = new Ext.grid.GridPanel({
       title: '<%=Class%>',
       id: 'firstGrid',
       ds: firstGridStore,
       frame: true,
       cm: cols1,
       view: new Ext.grid.GridView({
           nearLimit: 3
       }),
       plugins: [filters],
       stripeRows: true,
       height: 350,
       width: 210,
       autoScroll: true,
       sm: sm1
   });
    //**************************************second grid*******************************************************//
   var sm2 = new Ext.grid.CheckboxSelectionModel({
       checkOnly: true
   });

   var cols = new Ext.grid.ColumnModel([

       new Ext.grid.RowNumberer({
           header: "<span style=font-weight:bold;><%=SLNO%></span>",
           width: 40
       }), sm2, {
           header: "<span style=font-weight:bold;><%= Route%></span>",
           width: 135,
           sortable: true,
           dataIndex: 'route'
       }
   ]);

   var reader1 = new Ext.data.JsonReader({
       root: 'sendSchoolSmsRouteRoot',
       fields: [{
           name: 'slnoIndex'
       }, , {
           name: 'route',
           type: 'string'
       }]
   });
   var filters1 = new Ext.ux.grid.GridFilters({
       local: true,
       filters: [{
           type: 'numeric',
           dataIndex: 'slnoIndex'
       }, {
           dataIndex: 'route',
           type: 'string'
       }]
   });
    //**************************************secondGridStore*******************************************************//   
   var secondGridStore = new Ext.data.Store({
       url: '<%=request.getContextPath()%>/SendSchoolSmsAction.do?param=getRouteDetails',
       bufferSize: 367,
       reader: reader1,
       autoLoad: false,
       remoteSort: true
   });
    //**************************************secondGrid panel*******************************************************//     
   var secondGrid = new Ext.grid.GridPanel({
       title: '<%=Route%>',
       id: 'secondGrid',
       ds: secondGridStore,
       frame: true,
       cm: cols,
       view: new Ext.grid.GridView({
           nearLimit: 3
       }),
       plugins: [filters1],
       stripeRows: true,
       height: 350,
       width: 217,
       autoScroll: true,
       sm: sm2
   });

   var secondRoutePanel = new Ext.Panel({
       title: '<%=Selection%>',
       standardSubmit: true,
       collapsible: false,
       id: 'secondRoutePanelId',
       layout: 'table',
       frame: true,
       width: 440,
       height: 400,
       layoutConfig: {
           columns: 2
       },
       items: [firstGrid, secondGrid]
   });


   var clientPanel = new Ext.Panel({
       standardSubmit: true,
       collapsible: false,
       id: 'traderMaster',
       layout: 'table',
       frame: false,
       width: screen.width - 32,
       height: 40,
       layoutConfig: {
           columns: 6
       },
       items: [{
               xtype: 'label',
               text: '<%=SchoolName%>' + ' :',
               cls: 'labelstyle',
               id: 'custnamelab'
           },
           custnamecombo, {
               width: 80
           }
       ]
   });
/****************************************************************Message pannl*************************************/
   var MessageDetailPanel = new Ext.form.FormPanel({
       standardSubmit: true,
       // autoScroll:true,
       collapsible: false,
       title: '<%=Compose%>',
       id: 'messageDetailsId',
       layout: 'table',
       frame: true,
       width: 748,
       height: 140,
       layoutConfig: {
           columns: 4
       },
       items: [{
           xtype: 'label',
           text: '<%=Message%>' + ' :',
           cls: 'labelstyle',
           id: 'messageId22'
       }, {
           width: 41
       }, {
           xtype: 'textarea',
           emptyText: '<%=Entertextmessage%>',
           allowBlank: false,
           id: 'messageId2',
           name: 'f_message',
           anchor: '-15 40%',
           name: 'limitedtextarea',
           height: 50,
           width: 593,
           maskRe: /[a-zA-Z0-9 ,.]/,
           enableKeyEvents: true,
           listeners: {
               keyup: {
                   fn: function () {
                       var maxLength = 5000;
                       var text = document.getElementById('messageId2').value;
                       //alert(text);
                       var textLength = text.length;
                       Ext.getCmp('mandId3').setValue(textLength);
                       //Ext.get('mandId3').setStyle('color', 'green');
                       if (textLength == 160) {
                           Ext.get('mandId3').setStyle('color', 'red');
                           //Ext.getCmp('disId').setValue('you exceed your charater limit, This will considered as a Multiple SMS..');
                       }
                   }
               }
           }
       }, {
           xtype: 'label',
           text: '',
           cls: 'mandatoryfield',
           id: 'mandatoryMessageId3'
       }, {
           xtype: 'label',
           text: '',
           cls: 'labelstyle',
           id: 'emptyId'
       }, {
           xtype: 'label',
           text: '',
           cls: 'mandatoryfield',
           id: 'mandatoryemptyId2'
       }, {
           xtype: 'label',
           id: 'emptyId2'
       }, {
           xtype: 'label',
           text: '',
           cls: 'mandatoryfield',
           id: 'mandatoryemptyId3'
       }, {
           xtype: 'label',
           text: '<%=NOTE%>' + ' :',
           cls: 'labelstyle',
           id: 'noteId'
       }, {
           xtype: 'label',
           text: '',
           cls: 'mandatoryfield',
           id: 'mandatoryNoteId2'
       }, {
           xtype: 'label',
           text: '<%=MoreThen160CharactersConsideredasMulipleSMSanddonotaddanyspecialcharacters%>',
           cls: 'labelstyle',
           id: 'noteId2'
       }, {
           xtype: 'textfield',
           readOnly:true,
           width: 40,
           height: 21,
           id: 'mandId3'
       }]
   });
/****************************************************************Mobile pannl*************************************/
   var ManualPhoneNumberPanel = new Ext.form.FormPanel({
       standardSubmit: true,
       // autoScroll:true,
       collapsible: false,
       title: '<%=AdditionalMobileNumber%>',
       id: 'manualPhoneNumberId',
       layout: 'table',
       frame: true,
       width: 748,
       height: 160,
       layoutConfig: {
           columns: 4
       },
       items: [{
               xtype: 'label',
               text: '<%=SelectCountry%>',
               cls: 'labelstyle',
               id: 'CountryId'
           }, {
               width: -12
           },
           countrycombo, {
               xtype: 'label',
               text: '',
               cls: 'mandatoryfield',
               id: 'mandatoryCountryId3'
           }, {
               xtype: 'label',
               text: '<%=MobileNo%>' + ' :',
               cls: 'labelstyle',
               id: 'manualphId'
           }, {
               width: 10
           }, {
               xtype: 'textarea',
               allowBlank: false,
               id: 'manualphId2',
               anchor: '-15 40%',
               height: 50,
               width: 591,
               maskRe: /[0-9,]/
           }, {
               xtype: 'label',
               text: '',
               cls: 'mandatoryfield',
               id: 'mandatorymanualphId3'
           }, {
               xtype: 'label',
               text: '',
               cls: 'labelstyle',
               id: 'emptyId'
           }, {
               xtype: 'label',
               text: '',
               cls: 'mandatoryfield',
               id: 'mandatoryemptyId2'
           }, {
               xtype: 'label',
               id: 'emptyId2'
           }, {
               xtype: 'label',
               text: '',
               cls: 'mandatoryfield',
               id: 'mandatoryemptyId3'
           }, {
               xtype: 'label',
               text: '<%=NOTE%>'+ ' :',
               cls: 'labelstyle',
               id: 'mobId'
           }, {
               xtype: 'label',
               text: '',
               cls: 'mandatoryfield',
               id: 'mandatoryMobId2'
           }, {
               xtype: 'label',
               text: '<%=EnterMobileNumbersSeperatedbycommasEg88888888889999999999%>',
               cls: 'labelstyle',
               id: 'mobId2'
           }, {
               xtype: 'label',
               text: '',
               cls: 'mandatoryfield',
               id: 'mandatorymobId3'
           }
       ]
   });
   /****************************************************************SMS volume pannl*************************************/
   var SmsVolumePanel = new Ext.Panel({
       standardSubmit: true,
       // autoScroll:true,
       collapsible: false,
       title: '<%=SMSInformation%>',
       id: 'smsvolumeId',
       layout: 'table',
       frame: true,
       width: 748,
       height: 100,
       layoutConfig: {
           columns: 4
       },
       items: [{
           xtype: 'label',
           text: '',
           cls: 'labelstyle',
           id: 'emptyId'
       }, {
           xtype: 'label',
           text: '',
           cls: 'mandatoryfield',
           id: 'mandatoryemptyId3'
       }, {
           xtype: 'label',
           id: 'emptyId3'
       }, {
           xtype: 'label',
           text: '',
           cls: 'mandatoryfield',
           id: 'mandatoryemptyId4'
       }, {
           xtype: 'label',
           text: '<%=SMSavailableatyouraccount%>' + ' :',
           cls: 'labelstyle',
           id: 'smsId'
       }, {
           xtype: 'label',
           text: '',
           cls: 'mandatoryfield',
           id: 'mandatorySmsId2'
       }, {
           xtype: 'label',
           text: '',
           cls: 'labelstyle',
           id: 'smsId2'
       }, {
           xtype: 'label',
           text: '',
           cls: 'mandatoryfield',
           id: 'mandatorySmsId3'
       }]
   });

   var secondRightPanel = new Ext.Panel({
       standardSubmit: true,
       collapsible: false,
       id: 'secondPanelId',
       layout: 'table',
       frame: true,
       width: 760,
       height: 410,
       layoutConfig: {
           columns: 1
       },
       items: [MessageDetailPanel, ManualPhoneNumberPanel, SmsVolumePanel]
   });

   var manageAllTasksPanel = new Ext.Panel({
       standardSubmit: true,
       collapsible: false,
       id: 'vesselPanelId',
       layout: 'table',
       frame: false,
       width: '100%',
       height: 410,
       layoutConfig: {
           columns: 2
       },
       items: [secondRoutePanel, secondRightPanel]

   });

   var allButtonsPannel = new Ext.Panel({
       standardSubmit: true,
       collapsibli: false,
       id: 'buttonpannelid',
       layout: 'table',
       frame: false,
       width: 580,
       height: 30,
       layoutConfig: {
           columns: 3
       },
       items: [{
           width: 165
       }, {
           xtype: 'button',
           text: '<%=Submit%>',
           id: 'SubmitReport',
           cls: 'buttonwastemanagement',
           width: 100,
           listeners: {
               click: {
                   fn: function () {
                       submitRecord();
                   }
               }
           }
       }, {
           width: 10
       }]
   });
   /*********************inner panel for displaying form field in window***********************/
   var innerPanelForUnitDetails = new Ext.form.FormPanel({
       standardSubmit: true,
       collapsible: false,
       autoScroll: true,
       height: 220,
       width: 586,
       frame: true,
       id: 'custMaster',
       layout: 'table',
       layoutConfig: {
           columns: 4
       },
       items: [{
           xtype: 'fieldset',
           title: '<%=SMSSummary%>',
           cls: 'fieldsetpanel',
           collapsible: false,
           colspan: 2,
           id: 'addpanelid',
           width: 570,
           height:190,
           layout: 'table',
           defaults: {
        			bodyStyle:'padding:1px'
    			},
           layoutConfig: {
               columns: 2
           },
           items: [{
       				 			html: '<div align=left><b><%=SchoolName%>:</b></div>',
       				 			cellCls: 'col'
    					},
    					
    					{
       				 	 		xtype:'label',		 
       				 	 		cls: 'col' ,
                         		id: 'schoolNoId' 
    					},
    					
    					{
       				 			html: '<div align=left><b><%=Class%>:</b></div>',
       				 			cellCls: 'col' 
    					},
    					{
       				 			 xtype:'label',		 
       				 	 		 cls: 'col' ,
                         		 id: 'classId1' 
    					},
    					{
       				 			html: '<div align=left><b><%=Routes%>:</b> </div>',
       				 			cellCls: 'col' 
												    
    					},
    					{		xtype:'label',
       				 			id: 'routeId1',
       				 			cls: 'col' 

    					},
    					{
        			  			html: '<div align=left><b><%=AvailableSMS%> :</b> </div>',
        			  			cellCls: 'col' 
                		},
                		{
                				xtype:'label',
        			  			id:'totalsmsid1',
        			  			cls: 'col' 
                		}
                		,{
        			  			html: '<div align=left><b><%=SMStobeSent%>:</b> </div>',
        			  			cellCls: 'col' 
               			},
               			{
               					xtype:'label',
        			  			id: 'totalstudentsid1',
        			  			cls: 'col' 
               			}]
       }]
   });

   /********************************button**************************************/
   var innerWinButtonPanel = new Ext.Panel({
       id: 'winbuttonid',
       standardSubmit: true,
       collapsible: false,
       autoHeight: true,
       width: 586,
       height: 100,
       frame: true,
       layout: 'table',
       layoutConfig: {
           columns: 4
       },
       items: [{
               xtype: 'label',
               text: '<%=DoyouWanttoContinue%>',
               cls: 'labelstyle',
               id: 'lid'
           },{width:222},{
           xtype: 'button',
           text: 'Send SMS',
           id: 'addButtId',
           iconCls: 'smsSendbutton',
           cls: 'buttonstyle',
           width: 75,
           listeners: {
               click: {
                   fn: function () {
                       var jsonfirst = "";
                       var jsonsecond = "";
                       var records1 = firstGrid.getSelectionModel().getSelections();
                       for (var i = 0; i < records1.length; i++) {
                           var record1 = records1[i];
                           var row = firstGrid.store.findExact('slnoIndex', record1.get('slnoIndex'));
                           var store1 = firstGrid.store.getAt(row);
                           jsonfirst = jsonfirst + Ext.util.JSON.encode(store1.data) + ',';
                       }

                       var records2 = secondGrid.getSelectionModel().getSelections();
                       for (var i = 0; i < records2.length; i++) {
                           var record2 = records2[i];
                           var row = secondGrid.store.findExact('slnoIndex', record2.get('slnoIndex'));
                           var store2 = secondGrid.store.getAt(row);
                           jsonsecond = jsonsecond + Ext.util.JSON.encode(store2.data) + ',';
                       }
                       
                        outerPanel.getEl().mask();
                        var loadMask = new Ext.LoadMask('outerpannelid', {
                           msg: 'Please Wait...'
                       });
                       loadMask.show();
                        Ext.getCmp('addButtId').disable();
                        Ext.getCmp('canButtId').disable();
                       Ext.Ajax.request({
                           url: '<%=request.getContextPath()%>/SendSchoolSmsAction.do?param=SubmitDetails',
                           method: 'POST',
                           params: {
                               FristGridValues: jsonfirst,
                               SecondGridValues: jsonsecond,
                               MessageText: Ext.getCmp('messageId2').getValue(),
                               ManualphNo: Ext.getCmp('manualphId2').getValue(),
                               custId: Ext.getCmp('custcomboId').getValue(),
                               isdCode: Ext.getCmp('countryId').getValue()
                           },
                           success: function (response, options) {
                               var message = response.responseText;
                               Ext.example.msg(message);
                               myWin.hide();
                               Ext.getCmp('mandId3').setValue('0');
                               Ext.getCmp('messageId2').reset();
                               Ext.getCmp('manualphId2').reset();
                               Ext.getCmp('countryId').reset();
                               Ext.getCmp('manualphId2').disable();
                               custId = Ext.getCmp('custcomboId').getValue();
                               firstGridStore.load({
                                   params: {
                                       CustId: custId
                                   }
                               });
                               secondGridStore.load({
                                   params: {
                                       CustId: custId
                                   }
                               });

                               SMSCountStore.reload({
                                   params: {
                                       CustId: custId
                                   },
                                   callback: function () {
                                       if (SMSCountStore.getCount() > 0) {
                                           var record = SMSCountStore.getAt(0);
                                           document.getElementById('smsId2').innerHTML = record.data['totalSmsCount'];
                                       }
                                   }
                               });
                                  Ext.getCmp('addButtId').enable();
                                  Ext.getCmp('canButtId').enable();
                               outerPanel.getEl().unmask();
                           },
                           failure: function () {
                               Ext.example.msg("Error");
                               myWin.hide();
                               firstGridStore.reload();
                               Ext.getCmp('mandId3').setValue('0');
                               secondGridStore.reload();
                               outerPanel.getEl().unmask();
                                 Ext.getCmp('addButtId').enable();
                                 Ext.getCmp('canButtId').enable();
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
                   fn: function () {
                       myWin.hide();
                   }
               }
           }
       }]
   });
   /***********panel contains window content info***************************/
   var outerPanelWindow = new Ext.Panel({
       //width:540,
       cls: 'outerpanelwindow',
       standardSubmit: true,
       frame: false,
       items: [innerPanelForUnitDetails, innerWinButtonPanel]
   });
   /***********************window for form field****************************/
   myWin = new Ext.Window({
       title: 'titel',
       closable: false,
       modal: true,
       resizable: false,
       autoScroll: false,
       cls: '',
       //height : 400,
       width: 600,
       id: 'myWin',
       items: [outerPanelWindow]
   });

   function submitRecord() {
       buttonValue = "Submit";
       titel = '<%=Summary%>';
       if (Ext.getCmp('custcomboId').getValue() == "") {
           Ext.example.msg("<%=SelectSchoolName%>");
           Ext.getCmp('custcomboId').focus();
           return;
       }

       if (firstGrid.getSelectionModel().getCount() == 0) {
           Ext.example.msg("<%=SelectClassType%>");
           return;
       }

       if (secondGrid.getSelectionModel().getCount() == 0) {
           Ext.example.msg("<%=SelectRoute%>");
           return;
       }
       if (Ext.getCmp('messageId2').getValue() == "") {
           Ext.example.msg("<%=EnterMessage%>");
           Ext.getCmp('messageId2').focus();
           return;
       }

       var jsonfirst = "";
       var jsonsecond = "";
       var count;
       var count1;
       var Class;
       var route;
       var records1 = firstGrid.getSelectionModel().getSelections();
       for (var i = 0; i < records1.length; i++) {
           var record1 = records1[i];
           var row = firstGrid.store.findExact('slnoIndex', record1.get('slnoIndex'));
           var store1 = firstGrid.store.getAt(row);
           jsonfirst = jsonfirst + Ext.util.JSON.encode(store1.data) + ',';
       }

       var records2 = secondGrid.getSelectionModel().getSelections();
       for (var i = 0; i < records2.length; i++) {
           var record2 = records2[i];
           var row = secondGrid.store.findExact('slnoIndex', record2.get('slnoIndex'));
           var store2 = secondGrid.store.getAt(row);
           jsonsecond = jsonsecond + Ext.util.JSON.encode(store2.data) + ',';

       }
       custId = Ext.getCmp('custcomboId').getValue();
     
       Ext.Ajax.request({
           url: '<%=request.getContextPath()%>/SendSchoolSmsAction.do?param=getStudentCount',
           method: 'POST',
           params: {
               manualphNo: Ext.getCmp('manualphId2').getValue(),
               FristGridValues: jsonfirst,
               SecondGridValues: jsonsecond,
               isdCode: Ext.getCmp('countryId').getValue(),
               CustId: custId
           },
           success: function (result, request) {
               count = Ext.decode(result.responseText);
               console.log(count);
               count1 = count[0].totalStudentCount;
               Class = count[0].schoolType;
               route = count[0].route;
           },
           callback: function () {
               document.getElementById('totalstudentsid1').innerHTML = count1;
               document.getElementById('classId1').innerHTML = Class;
               document.getElementById('routeId1').innerHTML = route;
           }
       });
       SMSCountStore.load({
           params: {
               CustId: custId
           },
           callback: function () {
               if (SMSCountStore.getCount() > 0) {
                   var record = SMSCountStore.getAt(0);
                   document.getElementById('totalsmsid1').innerHTML = record.data['totalSmsCount'];
               }
           }
       });
       myWin.show();
       myWin.setTitle(titel);
   }
   //setTimeout(submitRecord,500);
   
   Ext.onReady(function () {
       ctsb = tsb;
       Ext.QuickTips.init();
       Ext.form.Field.prototype.msgTarget = 'side';
       Ext.Ajax.timeout = 180000;
       outerPanel = new Ext.Panel({
           title: '<%=InstantSMSModule%>',
           renderTo: 'content',
           id: 'outerpannelid',
           standardSubmit: true,
           frame: true,
           cls: 'outerpanel',
           layout: 'table',
           width:screen.width-25,
           height:555,
           layoutConfig: {
               columns: 1
           },
           items: [clientPanel, manageAllTasksPanel, allButtonsPannel]
       });
       sb = Ext.getCmp('form-statusbar');

   });      
  </script>
  <jsp:include page="../Common/footer.jsp" />
 <!-- </body>   -->
 <!-- </html> -->
<%}%>