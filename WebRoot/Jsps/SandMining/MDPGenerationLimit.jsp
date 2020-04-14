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

tobeConverted.add("Enter_DD_Date");
tobeConverted.add("Enter_DD_No");
tobeConverted.add("Enter_DD_Amount");
tobeConverted.add("Enter_Approved_Quantity");
tobeConverted.add("Enter_Consumer_Name");
tobeConverted.add("Select_Bank_Name");
tobeConverted.add("Select_Application_No");
tobeConverted.add("Bank_Name");
tobeConverted.add("DD_No");
tobeConverted.add("DD_Date");
tobeConverted.add("DD_Amount");
tobeConverted.add("Approved_Sand_Quantity");
tobeConverted.add("Sand_Consumer_Name");
tobeConverted.add("Consumer_Application_No");
tobeConverted.add("SLNO");
tobeConverted.add("No_Records_Found");
tobeConverted.add("Clear_Filter_Data");
tobeConverted.add("Add");
tobeConverted.add("Modify");
tobeConverted.add("Sand_Consumer_Credit_Details");
tobeConverted.add("Cancel");
tobeConverted.add("Save");
tobeConverted.add("Sand_Consumer_Credit_Master");
tobeConverted.add("Balance_Amount");
tobeConverted.add("Entry_Date");
tobeConverted.add("Branch_Name");
tobeConverted.add("Enter_Branch_Name");
tobeConverted.add("Select_Division");
tobeConverted.add("Division");


ArrayList<String> convertedWords = new ArrayList<String>();
convertedWords = cf.getLanguageSpecificWordForKey(tobeConverted,language);

String Enter_DD_Date=convertedWords.get(0);
String Enter_DD_No=convertedWords.get(1);
String Enter_DD_Amount=convertedWords.get(2);
String Enter_Approved_Quantity=convertedWords.get(3);
String Enter_Consumer_Name=convertedWords.get(4);
String Select_Bank_Name=convertedWords.get(5);
String Select_Application_No=convertedWords.get(6);
String Bank_Name=convertedWords.get(7);
String DD_No=convertedWords.get(8);
String DD_Date=convertedWords.get(9);
String DD_Amount=convertedWords.get(10);
String Approved_Sand_Quantity=convertedWords.get(11);
String Sand_Consumer_Name=convertedWords.get(12);
String Consumer_Application_No=convertedWords.get(13);
String SLNO=convertedWords.get(14);
String NoRecordsFound=convertedWords.get(15);
String ClearFilterData=convertedWords.get(16);
String Add=convertedWords.get(17);
String Modify=convertedWords.get(18);
String Sand_Consumer_Credit_Details=convertedWords.get(19);
String Cancel=convertedWords.get(20);
String Save=convertedWords.get(21);
String Sand_Consumer_Credit_Master=convertedWords.get(22);
String Balance_Amount=convertedWords.get(23);
String Entry_Date=convertedWords.get(24);
String Branch_Name=convertedWords.get(25);
String Enter_Branch_Name=convertedWords.get(26);
String Select_Division=convertedWords.get(27);
String Division=convertedWords.get(28);
%>

<jsp:include page="../Common/header.jsp" />
 		<title>MDP Generation Limit</title>	
 		  
  
	 <style>
  .x-panel-tl
	{
		border-bottom: 0px solid !important;
	}
  </style>

   <%if (loginInfo.getStyleSheetOverride().equals("Y")){%>
	<jsp:include page="../Common/ImportJSSandMining.jsp"/>
	<%}else{%>
	<jsp:include page="../Common/ImportJS.jsp" /><%}%>
   <jsp:include page="../Common/ExportJS.jsp" />
   
   <% String newMenuStyle=loginInfo.getNewMenuStyle();
   if(newMenuStyle.equalsIgnoreCase("YES")){%>
   <style>
		.ext-strict .x-form-text {
		    height: 21px !important;
		}
		label {
			display : inline !important;
		}
		.x-window-tl *.x-window-header {
			padding-top : 6px !important;
		}
		.x-menu-list {
			height:auto !important;
		}
   </style>
   <%}%>
   <script>
   
var outerPanel;
var ctsb;
var jspName = "MDP_Generation_Limit";
var exportDataType = "int,int,date,int,int,int,int,string,date";
var custName="";
var selected;
var grid;
var buttonValue;
var titelForInnerPanel;
var bankCode="";
var myWin;
var nexdate=datenext;
var stateModify;
var districtModify;
var subDivisionModify;
var geoModify;
var stateModify1;
var districtModify1;
var curdate=datecur;
var prevdate = dateprev;
var uniqueId;
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
                custName=Ext.getCmp('custcomboId').getRawValue();
            }
        }
    }
});

var Client = new Ext.form.ComboBox({
    store: clientcombostore,
    id: 'custcomboId',
    mode: 'local',
    forceSelection: true,
    emptyText: '<%=Select_Division%>',
    blankText: '<%=Select_Division%>',
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
                custName=Ext.getCmp('custcomboId').getRawValue();
                applicationNostore.load({
                params: {
                CustId: custId
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
            text: '<%=Division%>' + ' :',
            cls: 'labelstyle'
	        },
	        Client, {width:25},
	        { 
	        xtype: 'label',
	        text: 'Start Date' + ' :',
	        cls: 'labelstyle'
	        },{
            xtype: 'datefield',
            cls: 'selectstylePerfect',
            width: 185,
            format: getDateFormat(),
            emptyText: 'Select Date',
            allowBlank: false,
            blankText: 'Select Date',
            id: 'startdate',
            vtype: 'daterange'
  		    },
	        {width:25},
	        {
	        xtype: 'label',
	        text: 'End Date' + ' :',
	        cls: 'labelstyle'
	        },{
            xtype: 'datefield',
            cls: 'selectstylePerfect',
            width: 185,
            format: getDateFormat(),
            emptyText: 'Select Date',
            allowBlank: false,
            blankText: 'Select Date',
            id: 'enddate',
            vtype: 'daterange'
  		    },
	        {width:40},
	        {
	        xtype:'button',
			text: 'View',
			width:70,
			listeners: {
						click: {fn:function(){
						
						if(Ext.getCmp('custcomboId').getValue()=="")
                       {
                             Ext.example.msg("<%=Select_Division%>");
                             return;
                       }
                       if(Ext.getCmp('startdate').getValue()=="")
                       {
                             Ext.example.msg("Select From Date");
                             return;
                       }
                       if(Ext.getCmp('enddate').getValue()=="")
                       {
                             Ext.example.msg("Select To Date");
                             return;
                       }
						 if (dateCompare(Ext.getCmp('startdate').getValue(), Ext.getCmp('enddate').getValue()) == -1) {
                             Ext.example.msg("To Date Should Be Greater than From Date");
                             return;
                       }
                       
                        var Startdates=Ext.getCmp('startdate').getValue();
             		 	var Enddates=Ext.getCmp('enddate').getValue();
            	        var Startdate = new Date(Enddates).add(Date.DAY, -30);
             		 	  if(Startdates <  Startdate)
             		 					{
             		 					Ext.example.msg("Difference between two dates should not be  more than 30 days.");
             		 					return;
             		 					}
						 store.load({
                                params: {
                                    CustId: Ext.getCmp('custcomboId').getValue(),
                                    custName:Ext.getCmp('custcomboId').getRawValue(),
                                    endDate:Ext.getCmp('enddate').getValue(),
                                    startDate:Ext.getCmp('startdate').getValue(),
                                    jspname:jspName
                                	}
                            	});
						}
			}}}
    ]
});

var innerPanelForSandBlockManagement = new Ext.form.FormPanel({
    standardSubmit: true,
    collapsible: false,
    autoScroll: true,
    height: 290,
    width: 450,
    frame: true,
    id: 'innerPanelForSandBlockManagementId',
    layout: 'table',
    layoutConfig: {
        columns: 4
    },
    items: [{
        xtype: 'fieldset',
        title: 'Day Wise MDP Generation Settings',
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
            id: 'fromdateId1'
        }, {
		    xtype: 'label',
		    text : 'From Date' + ' :',
		    cls: 'labelstyle',
		    id: 'startdatelab',
		    width:60
		}, {
            xtype: 'datefield',
           	cls: 'selectstyle',
            width: 185,
            format: getDateFormat(),
            emptyText: 'Select Date',
            allowBlank: false,
            minValue:curdate,
            blankText: 'Select Date',
            id: 'fromdateId',
            vtype: 'daterange',
            endDateField: 'enddateId'
  		 }, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'dateEmptyId2'
        }, {
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'todateId1'
        }, {
		    xtype: 'label',
		    text : 'To Date' + ' :',
		    cls: 'labelstyle',
		    id: 'enddatelab',
		    width:60
		}, {
            xtype: 'datefield',
           	cls: 'selectstyle',
            width: 185,
            format: getDateFormat(),
            emptyText: 'Select Date',
            allowBlank: false,
           // minValue:curdate,
            blankText: 'Select Date',
            id: 'enddateId',
            vtype: 'daterange'
            
  		 }, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'todateEmptyId2'
        },{
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'govtEmptyid1'
        }, {
            xtype: 'label',
            text: 'Government' + ' :',
            cls: 'labelstyle',
            id: 'governmentlabelid'
        }, {
            xtype: 'numberfield',
            cls: 'selectstylePerfect',
            allowBlank: false,
            allowNegative:false,
            allowDecimals:false,
            blankText: 'Enter max MDP generation per day',
            emptyText: 'Enter max MDP generation per day',
            labelSeparator: '',
            id: 'governmentNameId'
        }, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'governmentEmptyid2'
        }, {
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'publicId1'
        }, {
            xtype: 'label',
            text: 'Public' + ':',
            cls: 'labelstyle',
            id: 'publicId2'
        }, {
            xtype: 'numberfield',
            cls: 'selectstylePerfect',
            allowBlank: false,
            allowNegative:false,
            allowDecimals:false,
            blankText: 'Enter max MDP generation per day',
            emptyText: 'Enter max MDP generation per day',
            labelSeparator: '',
            id: 'publictextId'
        }, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'publicId3'
        },   {
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'contractorId1'
        }, {
            xtype: 'label',
            text: 'Contractor' + ' :',
            cls: 'labelstyle',
            id: 'contractorId2'
        }, {
            xtype: 'numberfield',
            cls: 'selectstylePerfect',
            allowBlank: false,
            allowNegative:false,
            allowDecimals:false,
            blankText: 'Enter max MDP generation per day',
            emptyText: 'Enter max MDP generation per day',
            labelSeparator: '',
            id: 'contractortextId'
        }, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'contractorId3'
        },  {
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'ashrayaId1'
        }, {
            xtype: 'label',
            text: 'Ashraya' + ' :',
            cls: 'labelstyle',
            id: 'ashrayaId2'
        }, {
            xtype: 'numberfield',
            cls: 'selectstylePerfect',
            allowBlank: false,
            allowNegative:false,
            allowDecimals:false,
            blankText: 'Enter max MDP generation per day',
            emptyText: 'Enter max MDP generation per day',
            labelSeparator: '',
            id: 'ashrayatextId'
        }, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'ashrayaId3'
        },{
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'updatebyId1'
        }, {
            xtype: 'label',
            text: 'Last Updated By' + ' :',
            cls: 'labelstyle',
            id: 'updateByLabelId2'
        }, {
            xtype: 'textfield',
            cls: 'selectstylePerfect',
            blankText: '',
            emptyText: '',
            labelSeparator: '',
            readOnly: true,
            id: 'updatedBytextId'
        }, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'updateById3'
        },{
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'updateDateId1'
        }, {
            xtype: 'label',
            text: 'Last Updated' + ' :',
            cls: 'labelstyle',
            id: 'updateDateId2'
        }, {
            xtype: 'textfield',
            cls: 'selectstylePerfect',
            blankText: '',
            emptyText: '',
            labelSeparator: '',
            readOnly: true,
            id: 'updateDatetextId'
        }, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'updateDateId3'
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
                    if (Ext.getCmp('custcomboId').getValue() == "") {
                        Ext.example.msg("<%=Select_Division%>");
                        return;
                    }
                    if (Ext.getCmp('fromdateId').getValue() == "") {
                        Ext.example.msg("Select From Date");
                        Ext.getCmp('fromdateId').focus();
                        return;
                    }
                     if (Ext.getCmp('enddateId').getValue() == "" && buttonValue == 'Add') {
                        Ext.example.msg("Select To Date");
                        Ext.getCmp('enddateId').focus();
                        return;
                    }
                    var startdates=Ext.getCmp('fromdateId').getValue();
            		var enddates=Ext.getCmp('enddateId').getValue();
            		 			
       		 			var d1 = new Date(startdates);
       		 			var d2 = new Date(enddates);
       		 			if(d1>d2)
	       		 		{
							Ext.example.msg("Valid To Should Be Greater than Valid From Date");
							return;
						}
                     
                    if (Ext.getCmp('governmentNameId').getValue() === "") {
                        Ext.example.msg("Enter Government maximum MDP generation per day ");
                        Ext.getCmp('governmentNameId').focus();
                        return;
                    }
                    if (Ext.getCmp('publictextId').getValue() === "") {
                        Ext.example.msg("Enter Public maximum MDP generation per day");
                        Ext.getCmp('publictextId').focus();
                        return;
                    }
                    if (Ext.getCmp('contractortextId').getValue() === '') {
                        Ext.example.msg("Enter Contractor maximum MDP generation per day ");
                        Ext.getCmp('contractortextId').focus();
                        return;
                    }
                    
                    if (Ext.getCmp('ashrayatextId').getValue() === "") {
                         Ext.example.msg("Enter Ashraya maximum MDP generation per day ");
                         Ext.getCmp('ashrayatextId').focus();
                        return;
                    }
                   
                   if (buttonValue == 'Modify') {
                            var selected = grid.getSelectionModel().getSelected();
                            uniqueId = selected.get('uniqueIdDataIndex');
                        }
                   
                    sandBlockManagementOuterPanelWindow.getEl().mask();
                     Ext.Ajax.request({
                        url: '<%=request.getContextPath()%>/ConsumerMDPGeneratorAction.do?param=addModifySandMdpLimit',
                        method: 'POST',
                        params: {
                            buttonValue: buttonValue,
                            custId: Ext.getCmp('custcomboId').getValue(),
                            fromDateId: Ext.getCmp('fromdateId').getValue(),
                            endDateId: Ext.getCmp('enddateId').getValue(),
                            governmentNameId: Ext.getCmp('governmentNameId').getValue(),
                            publictextId: Ext.getCmp('publictextId').getValue(),
                            contractortextId: Ext.getCmp('contractortextId').getRawValue(),
                            ashrayatextId: Ext.getCmp('ashrayatextId').getValue(),
                            ashrayatextId: Ext.getCmp('ashrayatextId').getValue(),
                            uniqueId : uniqueId
                        },
                        success: function(response, options) {
                            var message = response.responseText;
                            Ext.example.msg(message);
                            Ext.getCmp('fromdateId').reset();
                            Ext.getCmp('enddateId').reset();
                            Ext.getCmp('governmentNameId').reset();
                            Ext.getCmp('publictextId').reset();
                            Ext.getCmp('contractortextId').reset();
                            Ext.getCmp('ashrayatextId').reset();
                            Ext.getCmp('updatedBytextId').reset();
                            Ext.getCmp('updateDatetextId').reset();
                            myWin.hide();
                            sandBlockManagementOuterPanelWindow.getEl().unmask();
                            store.load({
                                params: {
                                    CustId: Ext.getCmp('custcomboId').getValue(),
                                    custName:Ext.getCmp('custcomboId').getRawValue(),
                                    endDate:Ext.getCmp('enddate').getValue(),
                                    startDate:Ext.getCmp('startdate').getValue(),
                                    jspname:jspName
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
                    Ext.getCmp('fromdateId').reset();
                    Ext.getCmp('enddateId').reset();
                    Ext.getCmp('governmentNameId').reset();
                    Ext.getCmp('publictextId').reset();
                    Ext.getCmp('contractortextId').reset();
                    Ext.getCmp('ashrayatextId').reset();
                    Ext.getCmp('updatedBytextId').reset();
                    Ext.getCmp('updateDatetextId').reset();
                    myWin.hide();
                }
            }
        }
    }]
});

var sandBlockManagementOuterPanelWindow = new Ext.Panel({
    width: 460,
    height: 340,
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
    height: 390,
    width: 460,
    id: 'myWin',
    items: [sandBlockManagementOuterPanelWindow]
});

function addRecord() {
if(Ext.getCmp('custcomboId').getValue()=="")
{
  Ext.example.msg("<%=Select_Division%>");
  return;
}
      buttonValue="Add";
      titelForInnerPanel = 'MDP Settings';
      myWin.setPosition(450, 80);
      myWin.setTitle(titelForInnerPanel);
      myWin.show();
      Ext.getCmp('fromdateId').reset();
      Ext.getCmp('enddateId').reset();
      Ext.getCmp('governmentNameId').reset();
      Ext.getCmp('publictextId').reset();
      Ext.getCmp('contractortextId').reset();
      Ext.getCmp('ashrayatextId').reset();
      Ext.getCmp('updatedBytextId').reset();
      Ext.getCmp('updateDatetextId').reset();
                    
      Ext.getCmp('fromdateId').enable();
      Ext.getCmp('todateId1').show();
      Ext.getCmp('enddatelab').show();
      Ext.getCmp('enddateId').show();
      Ext.getCmp('updateByLabelId2').hide();
      Ext.getCmp('updatedBytextId').hide();
      Ext.getCmp('updateDateId2').hide();
      Ext.getCmp('updateDatetextId').hide();
}

function modifyData() {
  
    if (grid.getSelectionModel().getCount() == 0) {
     Ext.example.msg("NoRowsSelected");
        return;
    }
    if (grid.getSelectionModel().getCount() > 1) {
     Ext.example.msg("SelectSingleRow");
        return;
    }
    Ext.getCmp('fromdateId').reset();
    Ext.getCmp('enddateId').reset();
    Ext.getCmp('governmentNameId').reset();
    Ext.getCmp('publictextId').reset();
    Ext.getCmp('contractortextId').reset();
    Ext.getCmp('ashrayatextId').reset();
    Ext.getCmp('updatedBytextId').reset();
    Ext.getCmp('updateDatetextId').reset();
    
    var selected = grid.getSelectionModel().getSelected();
    if(DateCompare3(selected.get('Dateindex'),prevdate.format('d-m-Y') )){
    	Ext.example.msg("Cannot Update for Previous Date");
        return;
    }else{
    buttonValue = '<%=Modify%>';
    titelForInnerPanel = 'MDP Generation Updation';
    myWin.setPosition(450, 80);
    myWin.setTitle(titelForInnerPanel);
    myWin.show();
    
	Ext.getCmp('fromdateId').setValue(selected.get('Dateindex'));
	Ext.getCmp('fromdateId').disable();
	Ext.getCmp('governmentNameId').setValue(selected.get('govtDataIndex'));
	Ext.getCmp('publictextId').setValue(selected.get('publicDataIndex'));
	Ext.getCmp('contractortextId').setValue(selected.get('contractorDataIndex'));
	Ext.getCmp('ashrayatextId').setValue(selected.get('ashrayaDataIndex'));
	Ext.getCmp('updatedBytextId').setValue(selected.get('updatedbyindex'));
	Ext.getCmp('updateDatetextId').setValue(selected.get('updatedDateindex'));
	id = selected.get('uniqueIdDataIndex');
	Ext.getCmp('updateByLabelId2').show();
    Ext.getCmp('updatedBytextId').show();
    Ext.getCmp('updateDateId2').show();
    Ext.getCmp('updateDatetextId').show();
    Ext.getCmp('todateId1').hide();
    Ext.getCmp('enddatelab').hide();
    Ext.getCmp('enddateId').hide();
	}
}

var reader = new Ext.data.JsonReader({
    idProperty: 'sandBlockid',
    root: 'MdpGenerationLimitRoot',
    totalProperty: 'total',
    fields: [{
        name: 'slnoIndex'
    }, {
        name: 'uniqueIdDataIndex'
    }, {
        name: 'Dateindex',
    }, {
        name: 'govtDataIndex'
    }, {
        name: 'publicDataIndex' 
    }, {
        name: 'contractorDataIndex'
    },{
        name: 'ashrayaDataIndex'
    },{
        name: 'updatedbyindex'
    },{
        name: 'updatedDateindex'
    }]
});

var store = new Ext.data.GroupingStore({
    autoLoad: false,
    proxy: new Ext.data.HttpProxy({
        url: '<%=request.getContextPath()%>/ConsumerMDPGeneratorAction.do?param=getMdpGenerationLimitDetails',
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
        dataIndex: 'uniqueIdDataIndex'
    }, {
        type: 'date',
        dataIndex: 'Dateindex'
    }, {
        type: 'numeric',
        dataIndex: 'govtDataIndex'
    }, {
        type: 'numeric',
        dataIndex: 'publicDataIndex'
    }, {
        type: 'numeric',
        dataIndex: 'contractorDataIndex'
    }, {
        type: 'numeric',
        dataIndex: 'ashrayaDataIndex'
    },{
        type: 'string',
        dataIndex: 'updatedbyindex'
    },{
        type: 'date',
        dataIndex: 'updatedDateindex'
    }  ]
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
            header: "<span style=font-weight:bold;>Unique Id</span>",
            dataIndex: 'uniqueIdDataIndex',
            hidden: true,
            width: 100,
            filter: {
                type: 'numeric'
            }
        },{
            header: "<span style=font-weight:bold;>Date</span>",
            dataIndex: 'Dateindex',
            width: 100,
            filter: {
                type: 'date'
            }
        }, {
            header: "<span style=font-weight:bold;>Government</span>",
            dataIndex: 'govtDataIndex',
            width: 100,
            filter: {
                type: 'numeric'
            }
        }, {
            header: "<span style=font-weight:bold;>Public</span>",
            dataIndex: 'publicDataIndex',
            width: 100,
            filter: {
                type: 'numeric'
            }
        }, {
            header: "<span style=font-weight:bold;>Contractor</span>",
            dataIndex: 'contractorDataIndex',
            width: 100,
            filter: {
                type: 'numeric'
            }
        },{
            header: "<span style=font-weight:bold;>Ashraya</span>",
            dataIndex: 'ashrayaDataIndex',
            width: 100,
            filter: {
                type: 'numeric'
            }
        },{
            header: "<span style=font-weight:bold;>Updated By</span>",
            dataIndex: 'updatedbyindex',
            hidden: true,
            width: 100,
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;>Updated date</span>",
            dataIndex: 'updatedDateindex',
            hidden: true,
            width: 100,
            filter: {
                type: 'date'
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
grid = getGrid('', '<%=NoRecordsFound%>', store, screen.width - 40, 420, 20, filters, '<%=ClearFilterData%>', false, '', 16, false, '', false, '', true, 'Excel', jspName, exportDataType, true, 'PDF', true, '<%=Add%>', true, '<%=Modify%>', false, '');
//******************************************************************************************************************************************************
Ext.onReady(function() {
    ctsb = tsb;
    Ext.QuickTips.init();
    Ext.form.Field.prototype.msgTarget = 'side';
    outerPanel = new Ext.Panel({
        title: 'MDP Generation Limit',
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
 <jsp:include page="../Common/footer.jsp" />
 <!-- </body>   -->
 <!-- </html> -->