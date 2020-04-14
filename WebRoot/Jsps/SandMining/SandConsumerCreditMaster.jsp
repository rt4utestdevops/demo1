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
	SandMiningFunctions smf = new SandMiningFunctions();
	
	boolean ConsumerMDPstate;
	boolean isModelCKM;
	
	ConsumerMDPstate = smf.status(systemId);
	isModelCKM = smf.isChikkmagalurModel(systemId);
	
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

<!DOCTYPE HTML>
<html>
 <head>
 		<title><%=Sand_Consumer_Credit_Master%></title>	
 		  
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
   <style>
		.selectstyle {
			padding: 0.7px !important;
		} 	
   </style>
   <script>
var outerPanel;
var ctsb;
var jspName = "Sand_Consumer_Credit_Master";
var exportDataType = "int,string,string,string,string,string,string,string,string,string,string";
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
function isValidBranchName(branchName) {
    	var pattern = new RegExp(/^\s*[a-zA-Z_,\s]+\s*$/);
    	return pattern.test(branchName);
	}

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
                store.load({
                    params: {
                        CustId: custId,
                        custName:custName,
                        endDate:Ext.getCmp('enddate').getValue(),
                        startDate:Ext.getCmp('startdate').getValue(),
                        jspname:jspName
                    }
                });
                if(!<%=ConsumerMDPstate%>){
                	applicationNostore.load({
                	params: {
                	CustId: custId
                	}
                  });
                }
                tpNostore.load({
                	params: {
                	CustId: custId
                	}
                });
            }
        }
    }
});

  var startdate = new Ext.form.DateField({
            fieldLabel: '',
            cls: 'selectstyle',
            format: getDateFormat(),
            emptyText: '',
            allowBlank: false,
            blankText: '',
            submitFormat: getDateTimeFormat(),
            labelSeparator: '',
            allowBlank: false,
            id: 'startdate',
            value: curdate
          //  maxValue: dtprev,
            //vtype: 'daterange',
          //  endDateField: 'enddate'

        });




        var enddate = new Ext.form.DateField({
            fieldLabel: '',
            cls: 'selectstyle',
            format: getDateFormat(),
            emptyText: '',
            allowBlank: false,
            blankText: '',
            submitFormat: getDateFormat(),
            labelSeparator: '',
            allowBlank: false,
            id: 'enddate',
            value: nexdate
           // maxValue: dtcur,
           // vtype: 'daterange',
          //  startDateField: 'startdate'
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
                if(!<%=ConsumerMDPstate%>){
	                applicationNostore.load({
	                params: {
	                CustId: custId
	                }
	                });
				}
                tpNostore.load({
                params: {
                CustId: custId
                }
                });
            }
        }
    }
});

var applicationNostore = new Ext.data.JsonStore({
    url: '<%=request.getContextPath()%>/SandBlockManagementAction.do?param=getApplicationNos',
    id: 'stockyardsId',
    root: 'applicationNoRoot',
    autoLoad: false,
    remoteSort: true,
    fields: ['applicationNo', 'consumerName','sandQuantity','mobileNo']
});

var applicationNoCombo = new Ext.form.ComboBox({
    store: applicationNostore,
    id: 'applicationComboId',
    mode: 'local',
    forceSelection: true,
    emptyText: '<%=Select_Application_No%>',
    blankText: '<%=Select_Application_No%>',
    selectOnFocus: true,
    allowBlank: false,
    anyMatch: true,
    typeAhead: false,
    triggerAction: 'all',
    lazyRender: true,
    valueField: 'applicationNo',
    displayField: 'applicationNo',
    cls: 'selectstylePerfect',
    listeners: {
        select: {
            fn: function() {
            if(Ext.getCmp('applicationComboId').getRawValue()!='')
            {
           // var consname=Ext.getCmp('applicationComboId').getValue();
         //   Ext.getCmp('consumerNameId').setValue(consname);
                  var row = applicationNostore.findExact('applicationNo',Ext.getCmp('applicationComboId').getRawValue());
                  var rec = applicationNostore.getAt(row);
                  Ext.getCmp('sandQuantityId').setValue(rec.data['sandQuantity']);
                  Ext.getCmp('consumerNameId').setValue(rec.data['consumerName']);
                  Ext.getCmp('sandQuantityId').disable();
                  
            }
            }
        }
    }
});

var tpNostore = new Ext.data.JsonStore({
    url: '<%=request.getContextPath()%>/SandBlockManagementAction.do?param=getTpNos',
    id: 'stockyardsId',
    root: 'tpNoRoot',
    autoLoad: false,
    remoteSort: true,
    fields: ['tpNo','tpId','tpMobileNo']
});

var tpNoCombo = new Ext.form.ComboBox({
    store: tpNostore,
    id: 'tpComboId',
    mode: 'local',
    forceSelection: true,
    emptyText: 'Select Tp No',
    blankText: 'Select Tp No',
    selectOnFocus: true,
    allowBlank: false,
    anyMatch: true,
    typeAhead: false,
    triggerAction: 'all',
    lazyRender: true,
    valueField: 'tpId',
    displayField: 'tpNo',
    cls: 'selectstylePerfect',
    listeners: {
        select: {
            fn: function() {
            var tpId=Ext.getCmp('tpComboId').getValue();
            if(<%=ConsumerMDPstate%>){
	            applicationNostore.load({
	                params: {
	                CustId: Ext.getCmp('custcomboId').getValue(),
	                tpNo: tpId
	                }
	            });
              }
            }
        }
    }
});

var bankNamestore = new Ext.data.JsonStore({
    url: '<%=request.getContextPath()%>/SandBlockManagementAction.do?param=getBankNames',
    id: 'stockyardsId',
    root: 'bankNameroot',
    autoLoad: true,
    remoteSort: true,
    fields: ['bankid', 'bankName']
});

var bankNameCombo = new Ext.form.ComboBox({
    store: bankNamestore,
    id: 'bankNamecomboId',
    mode: 'local',
    forceSelection: true,
    emptyText: '<%=Select_Bank_Name%>',
    blankText: '<%=Select_Bank_Name%>',
    selectOnFocus: true,
    allowBlank: false,
    anyMatch: true,
    typeAhead: false,
    triggerAction: 'all',
    lazyRender: true,
    valueField: 'bankid',
    displayField: 'bankName',
    cls: 'selectstylePerfect',
    listeners: {
        select: {
            fn: function() {
            Ext.getCmp('bankNamecomboId').getValue();
            if(Ext.getCmp('ddNoId').getValue()=="")
            {
             Ext.example.msg("Please Enter DD No");
             Ext.getCmp('ddNoId').focus();
             Ext.getCmp('bankNamecomboId').reset();
             return;
            }
            if(Ext.getCmp('ddNoId').getValue()!="")
            {
            Ext.Ajax.request({
  															url: '<%=request.getContextPath()%>/SandBlockManagementAction.do?param=getBankCode',
															method: 'POST',
															params:
															{
																bankId: Ext.getCmp('bankNamecomboId').getValue(),
																ddNo: Ext.getCmp('ddNoId').getValue()
															},
															success:function(response, options)
															{
															var ddno=response.responseText;
															if(ddno=='DD No Already Exist')
															{
															 Ext.getCmp('ddNoId').setValue("");
															 Ext.example.msg(ddno);
															 Ext.getCmp('bankNamecomboId').reset();
															 return;
															}
															Ext.getCmp('ddNoId').setValue(ddno);
															
															
															}, // end of success
            		failure: function(response, options)
                      {
                     
                      }// end of failure
                        });
            }
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
        { xtype: 'label',
            text: 'Start Date' + ' :',
            cls: 'labelstyle'},startdate,{width:25},
            { xtype: 'label',
            text: 'End Date' + ' :',
            cls: 'labelstyle'},enddate,{width:40},{xtype:'button',
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
                             Ext.example.msg("Select Start Date");
                             return;
                       }
                       if(Ext.getCmp('enddate').getValue()=="")
                       {
                             Ext.example.msg("Select End Date");
                             return;
                       }
						 if (dateCompare(Ext.getCmp('startdate').getValue(), Ext.getCmp('enddate').getValue()) == -1) {
                             Ext.example.msg("End Date Should Be Greater than Start Date");
                             return;
                       }
                       
                        var Startdates=Ext.getCmp('startdate').getValue();
             		 	var Enddates=Ext.getCmp('enddate').getValue();
            	        var Startdate = new Date(Enddates).add(Date.DAY, -7);
             		 	  if(Startdates <  Startdate)
             		 					{
             		 					Ext.example.msg("Difference between two dates should not be  more than 7 days.");
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
    width: 690,
    frame: true,
    id: 'innerPanelForSandBlockManagementId',
    layout: 'table',
    layoutConfig: {
        columns: 1
    },
    items: [{
        xtype: 'fieldset',
        title: '<%=Sand_Consumer_Credit_Details%>',
        cls: 'fieldsetpanel',
        collapsible: false,
        colspan: 3,
        border:false,
        id: 'sandBlockDetailsId',
        width: 660,
        layout: 'table',
        layoutConfig: {
            columns: 6
        },
        items: [{
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'tpEmptyId1'
        }, {
            xtype: 'label',
            text: 'TP No' + ' :',
            cls: 'labelstyle',
            id: 'tpLabelid'
        }, tpNoCombo, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'tpEmptyId2'
        },{},{},{
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'appnoEmptyId1'
        }, {
            xtype: 'label',
            text: 'Application No' + ' :',
            cls: 'labelstyle',
            id: 'appnaLabelid'
        }, applicationNoCombo, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'appnoEmptyId2'
        }, {},{},{
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'consumerEmptyid1'
        }, {
            xtype: 'label',
            text: '<%=Sand_Consumer_Name%>' + ' :',
            cls: 'labelstyle',
            id: 'consumerlabelid'
        }, {
            xtype: 'textfield',
            cls: 'selectstylePerfect',
            allowBlank: false,
            blankText: '<%=Enter_Consumer_Name%>',
            emptyText: '<%=Enter_Consumer_Name%>',
            labelSeparator: '',
            id: 'consumerNameId'
        }, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'consumerEmptyid2'
        }, {},{},{
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'sandQuantityId1'
        }, {
            xtype: 'label',
            text: '<%=Approved_Sand_Quantity%>' + '(CBM):',
            cls: 'labelstyle',
            id: 'sandQuantityId2'
        }, {
            xtype: 'textfield',
            cls: 'selectstylePerfect',
            allowBlank: false,
            allowNegative:false,
            blankText: '<%=Enter_Approved_Quantity%>',
            emptyText: '<%=Enter_Approved_Quantity%>',
            labelSeparator: '',
            id: 'sandQuantityId'
        }, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'sandQuantityId3'
        },{},{},
        {height:30},
        {
                xtype: 'radio',
                id: 'radioDD',
                checked: true,
                name: 'radioDD',
                listeners: {
                    check: function () {
                        if (this.checked) {  
                            if(radiocash.checked){
                              Ext.getCmp('radiocash').setValue(false);
                            }
                            prevselect = false;
                            Ext.getCmp('ddAmountId2').setText('DD Amount' + '  :');
                            Ext.getCmp('ddAmountId').reset();
							Ext.getCmp('ddNoId1').enable();
							Ext.getCmp('ddNoId2').enable();    
							Ext.getCmp('ddNoId').enable();
							Ext.getCmp('ddDateId1').enable(); 
							Ext.getCmp('ddDateId2').enable(); 
							Ext.getCmp('ddDateId').enable(); 
							Ext.getCmp('bankNameId1').enable();
							Ext.getCmp('bankNameId2').enable();
							Ext.getCmp('bankNamecomboId').enable();
							Ext.getCmp('branchNameId1').enable();
							Ext.getCmp('branchNameId2').enable();
							Ext.getCmp('branchNameId').enable();
   							
                        }
                    }
                }
            }, {
                xtype: 'label',
                text: 'DD/Receipt',
                cls: 'labelstyle',
                id:'ddNoradiolabelId'
            },{
                xtype: 'radio',
                id: 'radiocash',
                checked: false, 
                name: 'radiocash',
                listeners: {
                    check: function () {
                        if (this.checked) {                       
                        if(radioDD.checked){                                         
                         Ext.getCmp('radioDD').setValue(false);
                            }    
                            prevselect = false;              
                            Ext.getCmp('ddAmountId2').setText('Amount' + '  :');  
                            Ext.getCmp('ddAmountId').reset(); 
							Ext.getCmp('ddNoId1').disable();
							Ext.getCmp('ddNoId2').disable();    
							Ext.getCmp('ddNoId').disable();
							Ext.getCmp('ddDateId1').disable(); 
							Ext.getCmp('ddDateId2').disable(); 
							Ext.getCmp('ddDateId').disable(); 
							Ext.getCmp('bankNameId1').disable();
							Ext.getCmp('bankNameId2').disable();
							Ext.getCmp('bankNamecomboId').disable();
							Ext.getCmp('branchNameId1').disable();
							Ext.getCmp('branchNameId2').disable();
							Ext.getCmp('branchNameId').disable();
							Ext.getCmp('ddNoId').reset();
							Ext.getCmp('ddDateId').reset();
							Ext.getCmp('bankNamecomboId').reset();
							Ext.getCmp('branchNameId').reset();
					
                        }
                    }
                }
            }, {
                xtype: 'label',
                text: 'Cash',
                cls: 'labelstyle',
                id : 'cashradiolabelid'
            },{height:30},
         {
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'ddAmountId1'
        }, {
            xtype: 'label',
            text: '<%=DD_Amount%>' + ' :',
            cls: 'labelstyle',
            id: 'ddAmountId2'
        }, {
            xtype: 'numberfield',
            cls: 'selectstylePerfect',
            allowBlank: false,
            allowNegative:false,
            blankText: 'Enter Amount',
            emptyText: 'Enter Amount',
            labelSeparator: '',
            autoCreate: {//restricts user to 8 chars max, 
                   tag: "input",
                   maxlength: 8,
                   type: "text",
                   size: "8",
                   autocomplete: "off"
               },
            id: 'ddAmountId'
        }, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'ddAmountId3'
        }, {},{},{
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'ddNoId1'
        }, {
            xtype: 'label',
            text: '<%=DD_No%>' + ' :',
            cls: 'labelstyle',
            id: 'ddNoId2'
        }, {
            xtype: 'textfield',
            cls: 'selectstylePerfect',
            allowBlank: false,
            blankText: '<%=Enter_DD_No%>',
            emptyText: '<%=Enter_DD_No%>',
            labelSeparator: '',
            autoCreate: {//restricts user to 6 chars max, 
                   tag: "input",
                   maxlength: 8,
                   type: "text",
                   size: "8",
                   autocomplete: "off"
               },
            id: 'ddNoId'
        }, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'ddNoId3'
        }, {},{},
        {
                  xtype: 'label',
                  text: '*',
                  cls: 'mandatoryfield',
                  id: 'ddDateId1'
              },{
                  xtype: 'label',
                  text: '<%=DD_Date%>' + ' :',
                  cls: 'labelstyle',
                  id: 'ddDateId2'
              },  {
                  xtype: 'datefield',
                  cls: 'selectstylePerfect',
                  format: getDateFormat(),
                  allowBlank: false,
                  value:curdate,
                  maxValue: curdate, 
                  editable: false,
                  emptyText: '<%=Enter_DD_Date%>',
                  emptyText: '<%=Enter_DD_Date%>',
                  id: 'ddDateId'
              }, {
                  xtype: 'label',
                  text: '',
                  cls: 'mandatoryfield',
                  id: 'ddDateId3'
              },{},{}, {
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'bankNameId1'
        }, {
            xtype: 'label',
            text: '<%=Bank_Name%>' + ' :',
            cls: 'labelstyle',
            id: 'bankNameId2'
        }, bankNameCombo, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'bankNameId3'
        }, {},{},{
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'branchNameId1'
        }, {
            xtype: 'label',
            text: '<%=Branch_Name%>' + ' :',
            cls: 'labelstyle',
            id: 'branchNameId2'
        }, {
            xtype: 'textfield',
            cls: 'selectstylePerfect',
            allowBlank: false,
            blankText: '<%=Enter_Branch_Name%>',
            emptyText: '<%=Enter_Branch_Name%>',
            labelSeparator: '',
            autoCreate: {//restricts user to 50 chars max, 
                   tag: "input",
                   maxlength: 50,
                   regex: /^\s*[a-zA-Z_,\s]+\s*$/,
                   regexText: 'Branch Name should be in Albhates only',
                   type: "text",
                   size: "50",
                   autocomplete: "off"
               },
            id: 'branchNameId'
        }, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'branchNameId3'
        }] 
    }]
});

var innerWinButtonPanel = new Ext.Panel({
    id: 'innerWinButtonPanelId',
    standardSubmit: true,
    collapsible: false,
    autoHeight: true,
    height: 100,
    width: 690,
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
                    if(<%=ConsumerMDPstate%>){
	                    if (Ext.getCmp('tpComboId').getValue() == "") {
	                        Ext.example.msg("Select Tp No");
	                        Ext.getCmp('tpComboId').focus();
	                        return;
	                    }
                    }
                    if (Ext.getCmp('applicationComboId').getValue() == "") {
                        Ext.example.msg("<%=Select_Application_No%>");
                        Ext.getCmp('applicationComboId').focus();
                        return;
                    }
                    if (Ext.getCmp('consumerNameId').getValue() == "") {
                        Ext.example.msg("<%=Enter_Consumer_Name%>");
                        Ext.getCmp('consumerNameId').focus();
                        return;
                    }
                    if (Ext.getCmp('sandQuantityId').getValue() == "") {
                        Ext.example.msg("<%=Enter_Approved_Quantity%>");
                        Ext.getCmp('sandQuantityId').focus();
                        return;
                    }
                     if (Ext.getCmp('ddAmountId').getValue() == "") {
                        Ext.example.msg("Enter Amount");
                        Ext.getCmp('ddAmountId').focus();
                        return;
                    }
                    if(radioDD.checked){ 
                    
                    if (Ext.getCmp('ddNoId').getValue() == "") {
                         Ext.example.msg("<%=Enter_DD_No%>");
                         Ext.getCmp('ddNoId').focus();
                        return;
                    }
                   
                     if (Ext.getCmp('ddDateId').getValue() == "") {
                        Ext.example.msg("<%=Enter_DD_Date%>");
                        Ext.getCmp('ddDateId').focus();
                        return;
                    }
                    
                    if (Ext.getCmp('bankNamecomboId').getValue() == "") {
                        Ext.example.msg("<%=Select_Bank_Name%>");
                        Ext.getCmp('bankNamecomboId').focus();
                        return;
                    }
                    
                    if (Ext.getCmp('branchNameId').getValue() == "") {
                        Ext.example.msg("<%=Enter_Branch_Name%>");
                        Ext.getCmp('branchNameId').focus();
                        return;
                    }
                    var branchName = Ext.getCmp('branchNameId').getValue();
                    	if(!isValidBranchName(branchName))
    					{
       						Ext.example.msg("Enter Valid Branch Name");
        					return;
    					}
                    }
                    var row = applicationNostore.findExact('applicationNo',Ext.getCmp('applicationComboId').getRawValue());
                  	var rec = applicationNostore.getAt(row);
				  	var consumerMobileNo = rec.data['mobileNo'];
				  	var tpMobileNo;
				  	
				  	if(<%=ConsumerMDPstate%>){
				  	var row1 = tpNostore.findExact('tpId',Ext.getCmp('tpComboId').getValue());
                  	var rec1 = tpNostore.getAt(row1);
				    tpMobileNo = rec1.data['tpMobileNo'];
				  	
				  	var tpNo=Ext.getCmp('tpComboId').getRawValue();
                    var applicationNo= Ext.getCmp('applicationComboId').getRawValue();
                    var consumerName= Ext.getCmp('consumerNameId').getValue();
                    var sandQuantity= Ext.getCmp('sandQuantityId').getValue();
                    var ddAmount= Ext.getCmp('ddAmountId').getRawValue();
                    var consumerMobileNo= consumerMobileNo;
                    var tpMobileNo = tpMobileNo;
                   }
                   
                    sandBlockManagementOuterPanelWindow.getEl().mask();
                     Ext.Ajax.request({
                        url: '<%=request.getContextPath()%>/SandBlockManagementAction.do?param=addModifySandCreditMaster',
                        method: 'POST',
                        params: {
                            buttonValue: buttonValue,
                            custId: Ext.getCmp('custcomboId').getValue(),
                            tpId: Ext.getCmp('tpComboId').getValue(),
                            tpNo: Ext.getCmp('tpComboId').getRawValue(),
                            applicationNo: Ext.getCmp('applicationComboId').getRawValue(),
                            consumerName: Ext.getCmp('consumerNameId').getValue(),
                            sandQuantity: Ext.getCmp('sandQuantityId').getValue(),
                            ddAmount: Ext.getCmp('ddAmountId').getRawValue(),
                            ddNo: Ext.getCmp('ddNoId').getValue(),
                            ddDate: Ext.getCmp('ddDateId').getValue(),
                            bankName: Ext.getCmp('bankNamecomboId').getValue(),
                            branchName: Ext.getCmp('branchNameId').getValue(),
                            consumerMobileNo : consumerMobileNo,
                            tpMobileNo : tpMobileNo,
                            id: id
                            
                        },
                        success: function(response, options) {
                            var message = response.responseText;
                          //  Ext.example.msg(message);
                            var res = message.substr(0,5);
                            
                            Ext.getCmp('tpComboId').reset();
                            Ext.getCmp('applicationComboId').reset();
                            Ext.getCmp('consumerNameId').reset();
                            Ext.getCmp('sandQuantityId').reset();
                            Ext.getCmp('ddAmountId').reset();
                            Ext.getCmp('ddNoId').reset();
                            Ext.getCmp('ddDateId').reset();
                            Ext.getCmp('bankNamecomboId').reset();
                            Ext.getCmp('branchNameId').reset();
                            Ext.getCmp('radioDD').setValue(true);
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
                            
<!--                            geoFencestore.load({-->
<!--                    params: {-->
<!--                        custId: Ext.getCmp('custcomboId').getValue()-->
<!--                    }-->
<!--                });-->
                if(res=='Saved'){
               
					Ext.example.msg(response.responseText);
					if(<%=ConsumerMDPstate%>){
						window.open("<%=request.getContextPath()%>/Sand_Consumer_Credit_Reciept?systemId="+<%=systemId%>+"&appNo="+applicationNo+"&consumerName="+consumerName+"&reqQty="+sandQuantity+"&amount="+ddAmount+"&tpNo="+tpNo+"&tpMobile="+tpMobileNo);
					}else{
						Ext.example.msg(message);
					}
                }
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
                			Ext.getCmp('tpComboId').reset();
                            Ext.getCmp('applicationComboId').reset();
                            Ext.getCmp('consumerNameId').reset();
                            Ext.getCmp('sandQuantityId').reset();
                            Ext.getCmp('ddAmountId').reset();
                            Ext.getCmp('ddNoId').reset();
                            Ext.getCmp('ddDateId').reset();
                            Ext.getCmp('bankNamecomboId').reset();
                            Ext.getCmp('branchNameId').reset();
                            Ext.getCmp('radioDD').setValue(true);
                    myWin.hide();
                }
            }
        }
    }]
});

var sandBlockManagementOuterPanelWindow = new Ext.Panel({
    width: 700,
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
    width: 700,
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
      titelForInnerPanel = '<%=Sand_Consumer_Credit_Details%>';
      myWin.setPosition(450, 80);
      myWin.setTitle(titelForInnerPanel);
      myWin.show();
       if(<%=ConsumerMDPstate%>){
	 Ext.getCmp('sandQuantityId2').setText('Approved Sand Quantity' + '(Tons):');
	 }
}



var reader = new Ext.data.JsonReader({
    idProperty: 'sandBlockid',
    root: 'consumerCreditroot',
    totalProperty: 'total',
    fields: [{
        name: 'slnoIndex'
    }, {
        name: 'applicationNoindex'
    }, {
        name: 'consumerNameindex'
    }, {
        name: 'approvedQuantityindex' 
    }, {
        name: 'ddAmountindex'
    },{
        name: 'balanceAmountindex'
    }, {
        name: 'ddNoindex'
    }, {
        name: 'ddDateindex'
    }, {
        name: 'bankNameindex'
    }, {
        name: 'branchNameindex'
    }, {
        name: 'entryDateindex'
    }]
});

var store = new Ext.data.GroupingStore({
    autoLoad: false,
    proxy: new Ext.data.HttpProxy({
        url: '<%=request.getContextPath()%>/SandBlockManagementAction.do?param=getConsumerCreditDetails',
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
        type: 'string',
        dataIndex: 'applicationNoindex'
    }, {
        type: 'string',
        dataIndex: 'consumerNameindex'
    }, {
        type: 'numeric',
        dataIndex: 'approvedQuantityindex'
    }, {
        type: 'numeric',
        dataIndex: 'ddAmountindex'
    }, {
        type: 'numeric',
        dataIndex: 'balanceAmountindex'
    }, {
        type: 'string',
        dataIndex: 'ddNoindex'
    }, {
        type: 'date',
        dataIndex: 'ddDateindex'
    }, {
        type: 'string',
        dataIndex: 'bankNameindex'
    }, {
        type: 'string',
        dataIndex: 'branchNameindex'
    }, {
        type: 'date',
        dataIndex: 'entryDateindex'
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
            dataIndex: 'applicationNoindex',
            header: "<span style=font-weight:bold;><%=Consumer_Application_No%></span>",
           filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=Sand_Consumer_Name%></span>",
            dataIndex: 'consumerNameindex',
            width: 100,
            filter: {
                type: 'numeric'
            }
        }, {
            header: "<span style=font-weight:bold;><%=Approved_Sand_Quantity%></span>",
            dataIndex: 'approvedQuantityindex',
            width: 100,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;>Amount</span>",
            dataIndex: 'ddAmountindex',
            width: 100,
            filter: {
                type: 'numeric'
            }
        }, {
            header: "<span style=font-weight:bold;><%=Balance_Amount%></span>",
            dataIndex: 'balanceAmountindex',
            width: 100,
            filter: {
                type: 'numeric'
            }
        },  {
            header: "<span style=font-weight:bold;><%=DD_No%></span>",
            dataIndex: 'ddNoindex',
            width: 100,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=DD_Date%></span>",
            dataIndex: 'ddDateindex',
            width: 100,
            filter: {
                type: 'date'
            }
        }, {
            header: "<span style=font-weight:bold;><%=Bank_Name%></span>",
            dataIndex: 'bankNameindex',
            width: 100,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=Branch_Name%></span>",
            dataIndex: 'branchNameindex',
            width: 100,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=Entry_Date%></span>",
            dataIndex: 'entryDateindex',
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
grid = getGrid('<%=Sand_Consumer_Credit_Master%>', '<%=NoRecordsFound%>', store, screen.width - 40, 420, 20, filters, '<%=ClearFilterData%>', false, '', 16, false, '', false, '', true, 'Excel', jspName, exportDataType, true, 'PDF', true, '<%=Add%>', false, '<%=Modify%>', false, '');
//******************************************************************************************************************************************************
Ext.onReady(function() {
    ctsb = tsb;
    Ext.QuickTips.init();
    Ext.form.Field.prototype.msgTarget = 'side';
    outerPanel = new Ext.Panel({
        title: '<%=Sand_Consumer_Credit_Master%>',
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
    if(!<%=ConsumerMDPstate%>){
    Ext.getCmp('tpEmptyId1').hide();
    Ext.getCmp('tpLabelid').hide();
    Ext.getCmp('tpComboId').hide();
    Ext.getCmp('tpEmptyId2').hide();
    }
});
</script>
</body>
</html>
    
    
    
    
    

