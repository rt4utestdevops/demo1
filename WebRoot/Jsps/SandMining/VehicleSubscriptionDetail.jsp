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
Boolean hiddenValue=true;
	String pageName="Subscription";
	LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
     
if(session.getAttribute("loginInfoDetails")==null){
	loginInfo=new LoginInfoBean();
	loginInfo.setSystemId(0);
	loginInfo.setCustomerId(9999);
	loginInfo.setCustomerName("");
	loginInfo.setUserId(0);
	loginInfo.setOffsetMinutes(330);
	loginInfo.setLanguage("en");
	loginInfo.setIsLtsp(-1);
	loginInfo.setZone("A");
	loginInfo.setCategory("Enterprise");
	loginInfo.setStyleSheetOverride("Y");
	session.setAttribute("loginInfoDetails",loginInfo);
	pageName="Admin";
	}
	
	

	CommonFunctions cf = new CommonFunctions();
	cf.checkLoginInfo((LoginInfoBean) session.getAttribute("loginInfoDetails"), session, request, response);
	String responseaftersubmit="''";
	String feature="1";
	if(session.getAttribute("responseaftersubmit")!=null){
	   responseaftersubmit="'"+session.getAttribute("responseaftersubmit").toString()+"'";
		session.setAttribute("responseaftersubmit",null);
	}	
		
	String language = loginInfo.getLanguage();
	int systemId = loginInfo.getSystemId();
	int customerId = loginInfo.getCustomerId();
	int  userId=loginInfo.getUserId();
	if(customerId == 9999){
	hiddenValue = false;
	}
	
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

String userAuthority=cf.getUserAuthority(systemId,userId);

%>

<!DOCTYPE HTML>
<html>
 <head>
 		<title>Vehicle Subscription </title>	
 		  
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
var jspName = "Vehicle Subscription Details";
var exportDataType = "int,int,string,date,date,string,string,string,date,string,numeric,date,string,date";
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
var prevselect = true;
var subscription;
var amount;
var totalAmount;
var vehNo;
var modeOfPayment;
var id;
var pageName='<%=pageName%>';
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
        hidden: true,
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
                    clientcombostore.load({
                        params: {                        
                			pageName :pageName,
                            pagesystemId: pagesystemId
                        }
                    });
                  //  Ext.getCmp('custcomboId').reset();
                }
            }
        }
    });
    
  
    
    
var clientcombostore = new Ext.data.JsonStore({
    url: '<%=request.getContextPath()%>/VehicleSubscriptionAction.do?param=getCustomer',
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
                var pagesystemId = Ext.getCmp('selectLtspDropDownID').getValue();
                store.load({
                    params: {
                        CustId: custId,
                        custName:custName,
                        jspname:jspName,
                         pageName :pageName,
                         pagesystemId:pagesystemId
                        
                    }
                });
              
                subscriptionStore.load({
                params: {
                CustId: custId,
                pageName :pageName,
                pagesystemId: pagesystemId
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
            var pagesystemId = Ext.getCmp('selectLtspDropDownID').getValue();
                custId = Ext.getCmp('custcomboId').getValue();
                custName=Ext.getCmp('custcomboId').getRawValue();                
				
                store.load({
                    params: {
                        CustId: custId,
                        custName:custName,
                        jspname:jspName,
                         pageName :pageName,
                         pagesystemId:pagesystemId
                    }
                });
                
                subscriptionStore.load({
                params: {
                CustId: custId,
                pageName :pageName,
                pagesystemId: pagesystemId
                }
                });
            }
        }
    }
});

	var vehicleNoStore= new Ext.data.JsonStore({
	   url:'<%=request.getContextPath()%>/VehicleSubscriptionAction.do?param=getVehicleNo',
	   id:'vehicleStoreId',
       root: 'vehiclestoreList',
       autoLoad: false,
       remoteSort:true,
	   fields: ['PermitNoNew']
     });
			     
   var vehicleNoCombo=new Ext.form.ComboBox({
	  frame:true,
	  store: vehicleNoStore,
	  id:'vehicleComboId',
	  width: 175,
	  forceSelection:true,
	  emptyText:'Select Vehicle No',
	  anyMatch:true,
      onTypeAhead:true,
	  enableKeyEvents:true,
	  mode: 'local',
	  triggerAction: 'all',
	  displayField: 'PermitNoNew',
	  valueField: 'PermitNoNew',
	  cls: 'selectstylePerfect',
	  listeners: {
               select: {
               	 fn:function(){ 
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
   // hidden: true,
    triggerAction: 'all',
    lazyRender: true,
    valueField: 'bankid',
    displayField: 'bankName',
    cls: 'selectstylePerfect',
    listeners: {
        select: {
            fn: function() {
            
            if(Ext.getCmp('ddNoTextId').getValue()=="")
            {
           
             Ext.example.msg("Please Enter DD No");
             Ext.getCmp('ddNoTextId').focus();
             return;
            }
            if(Ext.getCmp('ddNoTextId').getValue()!="")
            {
            Ext.Ajax.request({
						url: '<%=request.getContextPath()%>/SandBlockManagementAction.do?param=getBankCode',
						method: 'POST',
						params:
						{
							bankId: Ext.getCmp('bankNamecomboId').getValue(),
							ddNo: Ext.getCmp('ddNoTextId').getValue()
						},
						success:function(response, options)
						{
						var ddno=response.responseText;
						if(ddno=='DD No Already Exist')
						{
						 Ext.getCmp('ddNoTextId').setValue("");
						 Ext.example.msg(ddno);
						 Ext.getCmp('bankNamecomboId').reset();
						 return;
						}
						Ext.getCmp('ddNoTextId').setValue(ddno);
						
						
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

		
	var subscriptionStore= new Ext.data.JsonStore({
	   url:'<%=request.getContextPath()%>/VehicleSubscriptionAction.do?param=getSubscriptionDetails',
	   id:'subscriptionStoreId',
       root: 'subscriptionList',
       autoLoad: false,
       remoteSort:true,
	   fields: ['customerId','subscriptionDuration','amountPerMonth','totalAmount','subscriptionType']
     });


    var billingtypeStore = new Ext.data.SimpleStore({
        id: 'billingTypeId',
        fields: ['Name'],
        autoLoad: true,
        data: [
            ['Billable'],
            ['Non Billable']
        ]
    });
    //****************************combo for Permit request type****************************************
    var billingtypeCombo = new Ext.form.ComboBox({
        store: billingtypeStore,
        id: 'billingtypecomboId',
        mode: 'local',
        hidden: <%=hiddenValue%>,
        forceSelection: true,
        emptyText: 'Select Billing Type',
        resizable: true,
        selectOnFocus: true,
        allowBlank: false,
        anyMatch: true,
        typeAhead: false,
        triggerAction: 'all',
        value: billingtypeStore.getAt(0).data['Name'],
        valueField: 'Name',
        displayField: 'Name',
        cls: 'selectstylePerfect',
    });
 	//custId = Ext.getCmp('custcomboId').getValue();
   //   var row = subscriptionStore.find('customerId',custId);
	//  var rec = subscriptionStore.getAt(row);	  
	//  subscriptionType=rec.data['subscriptionType'];
   
   
     var MonthStore = new Ext.data.JsonStore({
		       url:'<%=request.getContextPath()%>/VehicleSubscriptionAction.do?param=getMonthDetails',
			   id:'MonthStoreId',
		       root: 'MonthStoreIdList',
		       autoLoad: false,
		       remoteSort:true,
			   fields: ['durationMonths']
		});
		
      var MonthOverrideCombo=new Ext.form.ComboBox({
	  frame:true,
	  store: MonthStore,
	  editable: false,
	  id:'subscriptionid',
	  width: 75,
	  forceSelection:true,
	  emptyText:'Select month',	 
	  anyMatch:true,
      onTypeAhead:true,
	  enableKeyEvents:true,
	  mode: 'local',
	  triggerAction: 'all',
	  displayField: 'durationMonths',
	  valueField: 'durationMonths',
	  listeners: {
               select: {
               	 fn:function(){
	               	var newamt= amount*Ext.getCmp('subscriptionid').getValue();             
	               	Ext.getCmp('amountTextId').setValue(newamt);
	               	Ext.getCmp('totallabelId').setText(":"+newamt);
	               	totalAmount=newamt;
	               	
	               	}
				}
			}
 		});
     
	var startdate = new Ext.form.DateField({
        fieldLabel: '',
        cls: 'selectstyle',
        format: getDateFormat(),
        emptyText: 'Select Date',
        allowBlank: false,
        blankText: '',
        submitFormat: getDateFormat(),
        labelSeparator: '',
        allowBlank: false,
        id: 'startdate',
        //value: curdate,
        listeners: {
               select: {
               	 fn:function(){
               		var sDate = Ext.getCmp('startdate').getValue();
               		var endMonth = new Date(sDate).add(Date.MONTH,parseInt(subscription));
               	 	Ext.getCmp('enddate').setValue(endMonth);
               	 	var reminderDate = new Date(endMonth).add(Date.DAY, -10);
               	 	Ext.getCmp('reminderdate').setValue(reminderDate);
               	 	
               	 }
               	}
               }
    });

   var enddate = new Ext.form.DateField({
       fieldLabel: '',
       cls: 'selectstyle',
       format: getDateFormat(),
       emptyText: 'Select Date',
       allowBlank: false,
       blankText: '',
       submitFormat: getDateFormat(),
       labelSeparator: '',
       allowBlank: false,
       id: 'enddate',
       readOnly: true
   });
   
   var reminderDate = new Ext.form.DateField({
       fieldLabel: '',
       cls: 'selectstyle',
       format: getDateFormat(),
       emptyText: 'Select Date',
       allowBlank: false,
       blankText: '',
       submitFormat: getDateFormat(),
       labelSeparator: '',
       allowBlank: false,
       id: 'reminderdate',
       readOnly: true
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
            id : 'LTSPLableid',
            hidden: true,
            text: 'LTSP Name' + ' :',
            cls: 'labelstyle'
        },
        selectLtspDropDown, {width:25},
        {
            xtype: 'label',
              id : 'ClientLableid',
            text: 'Customer Name' + ' :',
            cls: 'labelstyle'
        },
        Client, {width:25}
        
    ]
});


		if('<%=customerId%>'== 9999){
			Ext.getCmp('selectLtspDropDownID').setVisible(true);
			Ext.getCmp('LTSPLableid').setVisible(true); 
		}else{
			Ext.getCmp('selectLtspDropDownID').setVisible(false);
			Ext.getCmp('LTSPLableid').setVisible(false);
		}

 var innerPanelWindow = new Ext.form.FormPanel({
    standardSubmit: true,
    collapsible: false,
    autoScroll: true,
    height: 330,
    width: 690,
    frame: true,
    id: 'innerPanelId',
    layout: 'table',
    layoutConfig: {
        columns: 1
    },
    items: [{
        xtype: 'fieldset',
        title: 'Subscription Details',
        cls: 'fieldsetpanel',
        collapsible: false,
        colspan: 3,
        id: 'sandBlockDetailsId',
        width: 660,
        height: 70,
        layout: 'table',
        layoutConfig: {
            columns: 13
        },
        items: [{height : 20},{
            	xtype: 'label',
            	text: '',
            	cls: 'mandatoryfield',
            	id: 'mandId1'
        	},{
                xtype: 'label',
                text: 'Subscription Duration',
                cls: 'labelstyle',
                id: 'subcriptionlabid'
            },MonthOverrideCombo ,
            {width : 20},{
            	xtype: 'label',
            	text: '',
            	cls: 'mandatoryfield',
            	id: 'mandId2'
        	},{
                xtype: 'label',
                text: 'Amount per Month',
                cls: 'labelstyle',
                id: 'amountPerlabelId'
            },	{
                xtype: 'label',
                text: '',
                cls: 'labelstyle',
                id: 'amountlabelId'
            },
            {width : 20},{
            	xtype: 'label',
            	text: '',
            	cls: 'mandatoryfield',
            	id: 'mandId3'
        	},{
                xtype: 'label',
                text: 'Total Amount',
                cls: 'labelstyle',
                id: 'labeltotalId'
            },	{
                xtype: 'label',
                text: '',
                cls: 'labelstyle',
                id: 'totallabelId'
            },{width : 20}] 
    },{
        xtype: 'fieldset',
        title: 'Mode of Payment',
        cls: 'fieldsetpanel',
        collapsible: false,
        colspan: 3,
        id: 'paymentfieldsetId',
        border:false,
        width: 660,
        height: 250,
        layout: 'table',
        layoutConfig: {
            columns: 6
        },
        items: [{height : 20},
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
						Ext.getCmp('ddNolabelId').enable();
						Ext.getCmp('ddNoTextId').enable();    
						Ext.getCmp('ddDateId').enable();
						Ext.getCmp('ddDatefieldId').enable(); 
						Ext.getCmp('bankNamelabelId').enable(); 
						Ext.getCmp('bankNamecomboId').enable(); 
						Ext.getCmp('amountTextId').disable();
                        }
                    }
                }
            }, {
                xtype: 'label',
                text: 'DD/Recipt No ',
                cls: 'labelstyle',
                id:'ddNoradiolabelId'
            },{width:30},{
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
                    	Ext.getCmp('ddNolabelId').disable();
						Ext.getCmp('ddNoTextId').disable();  
						Ext.getCmp('ddDateId').disable();
						Ext.getCmp('ddDatefieldId').disable(); 
						Ext.getCmp('bankNamelabelId').disable(); 
						Ext.getCmp('bankNamecomboId').disable(); 	
						Ext.getCmp('ddNoTextId').reset();
						Ext.getCmp('ddDatefieldId').reset();
						Ext.getCmp('bankNamecomboId').reset();
						Ext.getCmp('amountTextId').disable();
					
                        }
                    }
                }
            }, {
                xtype: 'label',
                text: 'Cash',
                cls: 'labelstyle',
                id : 'cashradiolabelid'
            },
            {height:30},
            {
                xtype: 'label',
                text: 'DD No :',
                cls: 'labelstyle',
               // hidden: true,
                id:'ddNolabelId'
            },{
	            xtype: 'textfield',
	            cls: 'selectstylePerfect',
	            allowBlank: false,
	             maskRe:new RegExp("[a-zA-Z0-9 ]"),
	           // hidden: true,
	            blankText: 'Enter DD No',
	            emptyText: 'Enter DD No',
	            listeners:{
					change: function(field, newValue, oldValue){
					if(field.getValue().length>25){ 
					Ext.example.msg("Field exceeded it's Maximum length");
					field.setValue(newValue.substr(0,20)); field.focus();
					 } 
					}
					},
	            labelSeparator: '',
	            id: 'ddNoTextId'
	        },{width:30},{},{},
	        {height:30},
	        {
                xtype: 'label',
                text: 'DD Date :',
                cls: 'labelstyle',
               // hidden: true,
                id:'ddDateId'
            },{
	            xtype: 'datefield',
	            cls: 'selectstylePerfect',
	            format: getDateFormat(),
	            allowBlank: false,
	            //value:curdate,
	            //hidden: true,
	            //maxValue: curdate, 
	            editable: false,
	            emptyText: 'Select DD Date',
	            emptyText: 'Select DD Date',
	            id: 'ddDatefieldId'
        	},{width:30},{},{},
	        {height:30},
	        {
                xtype: 'label',
                text: 'Bank Name :',
                cls: 'labelstyle',
                //hidden: true,
                id:'bankNamelabelId'
            },bankNameCombo,{width:30},{},{},
            {height:30},
            {
                xtype: 'label',
                text: 'Amount Paid :',
                cls: 'labelstyle',
                id:'amountPaidlabelId'
            },{
	            xtype: 'numberfield',
	            cls: 'selectstylePerfect',
	            allowBlank: false,
	            allowNegative:false,
	            editable:false,
	            blankText: 'Enter Amount',
	            emptyText: 'Enter Amount',
	            labelSeparator: '',
	            regex : /^[0-9]+$/,
	            id: 'amountTextId',
	            listeners: {
			          'change':function(){
			                var r=0;
							var amt=Ext.getCmp('amountTextId').getValue();
							if(amt < parseInt(totalAmount)){
								Ext.example.msg("Amount Paid Should Not Be Less Than Total Amount");
                        		Ext.getCmp('amountTextId').focus();
                        		return;
							}
						}
					}
        },{},{},{width:30},
            {height:30},
            {
                xtype: 'label',
                text: 'Billing Category :',
                hidden: <%=hiddenValue%>,
                cls: 'labelstyle',
                id:'billingCategorylabelId'
            },billingtypeCombo
            
        ] 
    }
    
    ]
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
                
                    if(radioDD.checked){                                  
                         	if(Ext.getCmp('ddNoTextId').getValue()== ""){
                         		Ext.example.msg("Enter DD/Recipt No");
                        		Ext.getCmp('ddNoTextId').focus();
                        		return;
                        		}
                        	if(Ext.getCmp('ddDatefieldId').getValue()== ""){
                         		Ext.example.msg("Select DD Date");
                        		Ext.getCmp('ddDatefieldId').focus();
                        		return;
                        		}
                        	if(Ext.getCmp('bankNamecomboId').getValue()== ""){
                         		Ext.example.msg("Select Bank Name");
                        		Ext.getCmp('bankNamecomboId').focus();
                        		return;
                        		}
                        	modeOfPayment="DD/Recipt";
                        } 
                    if(radiocash.checked){
                    	modeOfPayment="Cash";
                    }
                    if (Ext.getCmp('amountTextId').getValue() == "") {
                        Ext.example.msg("Enter Amount");
                        Ext.getCmp('amountTextId').focus();
                        return;
                    }
                    var amt=Ext.getCmp('amountTextId').getValue();
					if(amt < parseInt(totalAmount)){
						Ext.example.msg("Amount Paid Should Not Be Less Than Total Amount");
                      		Ext.getCmp('amountTextId').focus();
                      		return;
					}
					if (buttonValue == "<%=Modify%>") {
                        var selected = grid.getSelectionModel().getSelected();
                        id = selected.get('idIndex');
                        remainderDate = selected.get('remainderDateindex');
                        startDate = selected.get('startDateindex');
                        endDate = selected.get('endDateindex');
                        vechNo = selected.get('VehicleNoindex');
                        }
                        
           		     OuterPanelWindow.getEl().mask();
                     var pagesystemId = Ext.getCmp('selectLtspDropDownID').getValue();
				 		custId = Ext.getCmp('custcomboId').getValue();
						custName=Ext.getCmp('custcomboId').getRawValue();
						if(custId==9999){
								custId = Ext.getCmp('clientId').getValue();
				                custName=Ext.getCmp('clientId').getRawValue();
						}
                      Ext.Ajax.request({
                        url: '<%=request.getContextPath()%>/VehicleSubscriptionAction.do?param=addModifyVehicleSubscriptionDetails',
                        method: 'POST',
                        params: {
                            buttonValue: buttonValue,
                            custId: custId,
                            vehicleNo: vechNo,
                            startDate: startDate,
                            endDate: endDate,
                            remainderDate:remainderDate,
                            modeOfPayment: modeOfPayment,
                            ddNo: Ext.getCmp('ddNoTextId').getValue(),
                            ddDate: Ext.getCmp('ddDatefieldId').getValue(),
                            bankName: Ext.getCmp('bankNamecomboId').getRawValue(),
                            totalAmount: Ext.getCmp('amountTextId').getValue(),  
                            subscription: Ext.getCmp('subscriptionid').getValue(),
                            id: id,
                            billing: Ext.getCmp('billingtypecomboId').getValue(),
                            pagesystemId:pagesystemId
                            
                        },
                        success: function(response, options) {
                            var message = response.responseText;
                            Ext.example.msg(message);
                           //	Ext.getCmp('newVehicleNoTextId').reset();
	                		//Ext.getCmp('vehicleComboId').reset();  
	                		//Ext.getCmp('startdate').reset();
	                		//Ext.getCmp('enddate').reset();
	                		//Ext.getCmp('reminderdate').reset();
	                		Ext.getCmp('ddNoTextId').reset();
							Ext.getCmp('ddDatefieldId').reset();
							Ext.getCmp('bankNamecomboId').reset();
							Ext.getCmp('amountTextId').disable();
						//	Ext.getCmp('radioExistingVeh').setValue(true);
			      			Ext.getCmp('radioDD').setValue(true);
                            myWin.hide();
                            OuterPanelWindow.getEl().unmask();
                             store.reload();
                            
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
                
                		//Ext.getCmp('newVehicleNoTextId').reset();
                		//Ext.getCmp('vehicleComboId').reset();  
                		//Ext.getCmp('startdate').reset();
                		//Ext.getCmp('enddate').reset();
                		//Ext.getCmp('reminderdate').reset();
                		Ext.getCmp('ddNoTextId').reset();
						Ext.getCmp('ddDatefieldId').reset();
						Ext.getCmp('bankNamecomboId').reset();
						Ext.getCmp('amountTextId').disable();
						//Ext.getCmp('radioExistingVeh').setValue(true);
			      		Ext.getCmp('radioDD').setValue(true);
                    myWin.hide();
                }
            }
        }
    }]
});

var OuterPanelWindow = new Ext.Panel({
    width: 700,
    height: 400,
    standardSubmit: true,
    frame: false,
    items: [innerPanelWindow, innerWinButtonPanel]
});

myWin = new Ext.Window({
    title: titelForInnerPanel,
    closable: false,
    resizable: false,
    modal: true,
    autoScroll: false,
    height: 450,
    width: 700,
    id: 'myWin',
    items: [OuterPanelWindow]
});

function addRecord() {
if(Ext.getCmp('custcomboId').getValue()=="")
{
  Ext.example.msg("Select Customer");
  return;
}
      buttonValue="Renwal";
      var selected = grid.getSelectionModel().getSelected();
      id = selected.get('idIndex');
      var Startdate = selected.get('startDateindex');
      var Enddate = selected.get('endDateindex');
      var EnddateCmp = selected.get('hideEndDateIndex');
      var vechNumber = selected.get('VehicleNoindex');
      var weekago=  new Date(EnddateCmp).add(Date.DAY, -7);
        var today=  new Date();
      var ed = new Date(EnddateCmp);
     // alert(weekago);
	      if(weekago>today){
		      Ext.example.msg(" Renwal can be done,before one Week");
		      return;
	      }
	    var pagesystemId = Ext.getCmp('selectLtspDropDownID').getValue();
 		custId = Ext.getCmp('custcomboId').getValue();
		custName=Ext.getCmp('custcomboId').getRawValue();
		if(custId==9999){
				custId = Ext.getCmp('clientId').getValue();
                custName=Ext.getCmp('clientId').getRawValue();
		}
      Ext.MessageBox.show({
 						title: '',
 						msg: 'Are you sure, you want Renwal',
 						buttons: Ext.MessageBox.YESNO,
 						icon: Ext.MessageBox.QUESTION,
 						fn: function(btn) {
 							if (btn == 'yes') {
 								Ext.Ajax.request({
 									url: '<%=request.getContextPath()%>/VehicleSubscriptionAction.do?param=renawalOfSubscription',
 									method: 'POST',
 									params: {
 										Startdate: Startdate,
 										Enddate: Enddate,
 										CustId: custId,
 										id:id,
 										vechNumber:vechNumber,
 										pagesystemId:pagesystemId
 										
 									},
 									success: function(response, options) {
 										var message = response.responseText;
 										Ext.MessageBox.show({
 											title: '',
 											msg: 'Renwal '+message,
 											buttons: Ext.MessageBox.OK,
 										});
							              store.load({
							                  params: {
							                      CustId: custId,
							                      custName:custName,
							                      jspname:jspName,
						                         pageName :pageName,
						                         pagesystemId:pagesystemId
							                  }
							              });
 									},
 									failure: function() {
 										Ext.example.msg("Error!! Try again later");
 									}
 								}); 								 			                
 								
 							}
 						}
 					});
 					
 				  store.load({
                  params: {
                      CustId: custId,
                      custName:custName,
                      jspname:jspName,
                      pageName :pageName,
                      pagesystemId:pagesystemId
                  }
              });
              vehicleNoStore.load({
              params: {
             		 CustId: custId
              }
              });
              subscriptionStore.load({
              params: {
              	CustId: custId,
                pageName :pageName,
                pagesystemId: pagesystemId
              }
              });
<!--      titelForInnerPanel = 'Add Vehicle Subscriptipon Details';-->
<!--      custId = Ext.getCmp('custcomboId').getValue();-->
<!--      var row = subscriptionStore.find('customerId',custId);-->
<!--	  var rec = subscriptionStore.getAt(row);-->
<!--	  if(rec == undefined){-->
<!--	  	Ext.example.msg("Please Enter LTSP Subscription Details");-->
<!--		  return;-->
<!--	  }-->
<!--	  -->
<!--      myWin.setPosition(430, 80);-->
<!--      myWin.setTitle(titelForInnerPanel);-->
<!--      myWin.show();-->
<!--      -->
<!--      subscriptionType=rec.data['subscriptionType'];-->
<!--	  subscription=rec.data['subscriptionDuration'];-->
<!--	  amount=rec.data['amountPerMonth'];-->
<!--	  totalAmount=rec.data['totalAmount'];-->
<!--      Ext.getCmp('subscriptionid').setValue(subscription);-->
<!--      Ext.getCmp('amountlabelId').setText(":"+amount);-->
<!--      Ext.getCmp('totallabelId').setText(":"+totalAmount);-->
}

  function modifyData() {
       //clientcombostore.reload();
       var today = new Date();
       if(Ext.getCmp('custcomboId').getValue()=="")
		{
		  Ext.example.msg("Select Customer");
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
      buttonValue="Modify";
      titelForInnerPanel = 'Modify Vehicle Subscriptipon Details';
      
      var select = grid.getSelectionModel().getSelected();
       if((select.get('modeOfPaymentindex') == "DD/Recipt" && select.get('ddNoindex') != '')||select.get('modeOfPaymentindex') == "Cash" ){
           Ext.example.msg(" Already Modified");
           return;
       }
      myWin.setPosition(430, 80);
      myWin.setTitle(titelForInnerPanel);
      myWin.show();
      
      custId = Ext.getCmp('custcomboId').getValue();
      var row = subscriptionStore.find('customerId',custId);
	  var rec = subscriptionStore.getAt(row);
	  
	  subscriptionType=rec.data['subscriptionType'];  
	 // alert(subscriptionType);
	  if(subscriptionType != 'Override'){
		 Ext.getCmp('subscriptionid').setDisabled(true);
	  }else{
	 	 Ext.getCmp('subscriptionid').setDisabled(false);
	  }
	  subscription=rec.data['subscriptionDuration'];	  
	   MonthStore.load({
                params: {
                CustId: custId,
                subscription: subscription
                }
                });             
	  
	  amount=rec.data['amountPerMonth'];
	  totalAmount=rec.data['totalAmount'];
      Ext.getCmp('subscriptionid').setValue(subscription);
      Ext.getCmp('amountlabelId').setText(":"+amount);
      Ext.getCmp('totallabelId').setText(":"+totalAmount);
      
      var selected = grid.getSelectionModel().getSelected();
      if(selected.get('modeOfPaymentindex') == "DD/Recipt"){
      	Ext.getCmp('radioDD').setValue(true);
      }else{
      	Ext.getCmp('radiocash').setValue(true);
      }
      Ext.getCmp('ddNoTextId').setValue(selected.get('ddNoindex'));
      Ext.getCmp('ddDatefieldId').setValue(selected.get('ddDateindex'));
      Ext.getCmp('bankNamecomboId').setValue(selected.get('bankNameindex'));
      Ext.getCmp('amountTextId').setValue(selected.get('totalAmountindex'));
       Ext.getCmp('amountTextId').disable();
      var StartDate = selected.get('startDateindex');
      var dateDifrnc = new Date(StartDate).add(Date.DAY, 25);
      if(subscriptionType == 'Override'){
	        if (today > dateDifrnc) {
	       Ext.getCmp('subscriptionid').setDisabled(false);
	        }
        }else{
	        Ext.getCmp('subscriptionid').setDisabled(true);
	        }
  }
var reader = new Ext.data.JsonReader({
    idProperty: 'sandBlockid',
    root: 'vehicleSubscriptiontroot',
    totalProperty: 'total',
    fields: [{
        name: 'slnoIndex'
    }, {
        name: 'VehicleNoindex'
    }, {
   		// type: 'date',
        name: 'startDateindex'
    }, {
    	//type: 'date',
        name: 'endDateindex' 
    }, {
        name: 'modeOfPaymentindex'
    }, {
        name: 'ddNoindex'
    }, {
        name: 'ddDateindex'
    }, {
        name: 'bankNameindex'
    }, {
        name: 'totalAmountindex'
    }, {
    	//type: 'date',
        name: 'remainderDateindex'
    },{
        name: 'vehicleStatusindex'
    },{
    	name: 'insertedDateindex'
    },{
    	name: 'idIndex'
    },{
    	name: 'hideEndDateIndex'
    }]
});

var store = new Ext.data.GroupingStore({
    autoLoad: false,
    proxy: new Ext.data.HttpProxy({
        url: '<%=request.getContextPath()%>/VehicleSubscriptionAction.do?param=getVehicleSubscriptionDetails',
        method: 'POST'
    }),
    storeId: 'subId',
    reader: reader
});

var filters = new Ext.ux.grid.GridFilters({
    local: true,
    filters: [{
        type: 'numeric',
        dataIndex: 'slnoIndex'
    }, {
        type: 'string',
        dataIndex: 'VehicleNoindex'
    }, {
        type: 'date',
        dataIndex: 'startDateindex'
    }, {
        type: 'date',
        dataIndex: 'endDateindex'
    }, {
        type: 'string',
        dataIndex: 'modeOfPaymentindex'
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
        type: 'numeric',
        dataIndex: 'totalAmountindex'
    }, {
        type: 'date',
        dataIndex: 'remainderDateindex'
    }, {
        type: 'string',
        dataIndex: 'vehicleStatusindex'
    },{
        type: 'date',
        dataIndex: 'insertedDateindex'
    },{
        type: 'numeric',
        dataIndex: 'idIndex'
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
            dataIndex: 'idIndex',
            hidden: true,
            header: "<span style=font-weight:bold;>ID</span>",
            filter: {
                type: 'numeric'
            }
        },{
            dataIndex: 'VehicleNoindex',
            header: "<span style=font-weight:bold;>Vehicle No</span>",
           filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;>Validity Start Date</span>",
            dataIndex: 'startDateindex',
            width: 100,
          //  renderer: Ext.util.Format.dateRenderer(getDateFormat()),
            filter: {
                type: 'date'
            }
        }, {
            header: "<span style=font-weight:bold;>Validity End Date</span>",
            dataIndex: 'endDateindex',
            width: 100,
        //     renderer: Ext.util.Format.dateRenderer(getDateFormat()),
            filter: {
                type: 'date'
            }
        }, {
            header: "<span style=font-weight:bold;>Mode Of Payment</span>",
            dataIndex: 'modeOfPaymentindex',
            width: 100,
            filter: {
                type: 'string'
            }
        },  {
            header: "<span style=font-weight:bold;><%=DD_No%></span>",
            dataIndex: 'ddNoindex',
            width: 100,
            filter: {
                type: 'number'
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
            header: "<span style=font-weight:bold;>Total Amount</span>",
            dataIndex: 'totalAmountindex',
            width: 100,
            filter: {
                type: 'numeric'
            }
        }, {
            header: "<span style=font-weight:bold;>Payment Remainder Date</span>",
            dataIndex: 'remainderDateindex',
            width: 100,
            // renderer: Ext.util.Format.dateRenderer(getDateFormat()),
            filter: {
                type: 'date'
            }
        }, {
            header: "<span style=font-weight:bold;>Vehicle Status</span>",
            dataIndex: 'vehicleStatusindex',
            width: 100,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;>Inserted Date</span>",
            dataIndex: 'insertedDateindex',
           //  renderer: Ext.util.Format.dateRenderer(getDateFormat()),
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
grid = getGrid('Vehicle Subscription Details', '<%=NoRecordsFound%>', store, screen.width - 45, 440, 20, filters, '<%=ClearFilterData%>', false, '', 16, false, '', false, '', true, 'Excel', jspName, exportDataType, false, 'PDF', true, 'Renwal', true, '<%=Modify%>', false, '');
//******************************************************************************************************************************************************

Ext.onReady(function() {
    ctsb = tsb;
    Ext.QuickTips.init();
    Ext.form.Field.prototype.msgTarget = 'side';
    outerPanel = new Ext.Panel({
     //   title: 'Vehicle Subscription',
        renderTo: 'content',
        standardSubmit: true,
        frame: true,
        height:550,
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