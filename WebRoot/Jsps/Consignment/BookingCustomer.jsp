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
tobeConverted.add("Booking_Customer");
tobeConverted.add("Select_Customer");

tobeConverted.add("Booking_Customer_Details");
tobeConverted.add("CUSTOMER_ID");
tobeConverted.add("Enter_Customer_Id");

tobeConverted.add("Customer_Name");
tobeConverted.add("Enter_Customer_name");
tobeConverted.add("Address");

tobeConverted.add("Enter_Address");
tobeConverted.add("Email_ID");
tobeConverted.add("Enter_Email_Id");

tobeConverted.add("Phone_No");
tobeConverted.add("Enter_Phone_No");
tobeConverted.add("Mobile_No");
tobeConverted.add("Enter_Mobile_No");

tobeConverted.add("Fax");
tobeConverted.add("Enter_Fax");
tobeConverted.add("Tin");
tobeConverted.add("Enter_Tin");

tobeConverted.add("City");
tobeConverted.add("Enter_City");
tobeConverted.add("State");
tobeConverted.add("Select_State");

tobeConverted.add("Region");
tobeConverted.add("Select_Region");
tobeConverted.add("Status");

tobeConverted.add("Add");
tobeConverted.add("Modify");

tobeConverted.add("No_Rows_Selected");
tobeConverted.add("Select_Single_Row");
tobeConverted.add("Clear_Filter_Data");

tobeConverted.add("Save");
tobeConverted.add("Cancel");

tobeConverted.add("SLNO");
tobeConverted.add("No_Records_Found");


tobeConverted.add("Unique_Id");
tobeConverted.add("Modify_Customer_Details");

tobeConverted.add("User_Name");
tobeConverted.add("Enter_User_Name");
tobeConverted.add("PASSWORD");
tobeConverted.add("Enter_Password");

ArrayList<String> convertedWords = new ArrayList<String>();
convertedWords = cf.getLanguageSpecificWordForKey(tobeConverted,language);

String BookingCustomer=convertedWords.get(0);
String Selectclient=convertedWords.get(1);


String BookingCustomerDetails=convertedWords.get(2);
String CustomerId=convertedWords.get(3);
String EnterCustomerId=convertedWords.get(4);

String CustomerName=convertedWords.get(5);
String EnterCustomerName=convertedWords.get(6);
String Address=convertedWords.get(7);

String EnterAddress=convertedWords.get(8);
String EmailId=convertedWords.get(9);
String EnterEmailId=convertedWords.get(10);

String PhoneNo=convertedWords.get(11);
String EnterPhoneNo=convertedWords.get(12);
String MobileNo=convertedWords.get(13);
String EnterMobileNo=convertedWords.get(14);

String Fax=convertedWords.get(15);
String EnterFax=convertedWords.get(16);
String Tin=convertedWords.get(17);
String EnterTin=convertedWords.get(18);


String City=convertedWords.get(19);
String EnterCity=convertedWords.get(20);
String State=convertedWords.get(21);
String SelectState=convertedWords.get(22);

String Region=convertedWords.get(23);
String SelectRegion=convertedWords.get(24);
String Status=convertedWords.get(25);



String Add=convertedWords.get(26);
String Modify=convertedWords.get(27);

String NoRowsSelected=convertedWords.get(28);
String SelectSingleRow=convertedWords.get(29);
String ClearFilterData=convertedWords.get(30);

String Save=convertedWords.get(31);
String Cancel=convertedWords.get(32);

String SLNO=convertedWords.get(33);
String NoRecordsFound=convertedWords.get(34);


String UniqueId=convertedWords.get(35);
String ModifyCustomerDetails=convertedWords.get(36);

String UserId=convertedWords.get(37);
String EnterUserName=convertedWords.get(38);
String Password=convertedWords.get(39);
String EnterPassword=convertedWords.get(40);

%>

<jsp:include page="../Common/header.jsp" />
 		<title><%=BookingCustomer%></title>	
 		     
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
   <style>
	.ext-strict .x-form-text {
		height: 21px !important;
	}	
	label {
		display : inline !important;
	}
	.x-window-tl *.x-window-header {
		height: 38px !important;
	}
	.x-layer ul {
	 	min-height: 27px !important;
	}
	.x-menu-list {
			margin-bottom : 0px !important;
		}
   </style>
   <script>
var outerPanel;
var ctsb;
var jspName = "Booking Customer";
var exportDataType = "";
var selected;
var grid;
var buttonValue;
var titelForInnerPanel;
var myWin;
var stateModify;
var districtModify;
var subDivisionModify;
var geoModify;
var stateModify1;
var districtModify1;
var clientcombostore = new Ext.data.JsonStore({
   url: '<%=request.getContextPath()%>/MapView.do?param=getCustomer',
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
                stateComboStore.load({
                    params: {
                        
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
    emptyText: '<%=Selectclient%>',
    blankText: '<%=Selectclient%>',
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
 					stateComboStore.load({
                    params: {
                        // CustId: custId
                    }
                });
            }
        }
    }
});

var stateComboStore = new Ext.data.JsonStore({
    url: '<%=request.getContextPath()%>/CommonAction.do?param=getStates',
    id: 'stateStoreId',
    root: 'StateRoot',
    autoload: true,
    remoteSort: true,
    fields: ['StateID', 'stateName'],
    listeners: {
        load: function() {}
    }
});

var stateCombo = new Ext.form.ComboBox({
    store: stateComboStore,
    id: 'statecomboId',
    mode: 'local',
    forceSelection: true,
    emptyText: '<%=SelectState%>',
    blankText: '<%=SelectState%>',
    selectOnFocus: true,
    allowBlank: true,
    anyMatch: true,
    typeAhead: false,
    triggerAction: 'all',
    lazyRender: true,
    valueField: 'StateID',
    displayField: 'stateName',
    cls: 'selectstylePerfect',
    listeners: {
        select: {
            fn: function() {
                
            }
        }
    }
});
var Region = [['North'],['East'],['West'],['South']];   
	          var Regionstore= new  Ext.data.SimpleStore({
			       data:Region,
				   fields: ['Regionid']
			     });
			     
			 var RegionCombo = new Ext.form.ComboBox({
     			frame:true,
				  store: Regionstore,
				  id:'regioncomboId',
				//  width: 50,
				  forceSelection:true,
				  enableKeyEvents:true,
				  mode: 'local',
				  anyMatch:true,
	              onTypeAhead:true,
				  triggerAction: 'all',
				  displayField: 'Regionid',
				  cls: 'selectstylePerfect',
				  valueField: 'Regionid', 
	        	  emptyText:'<%=SelectRegion%>',
	        	   listeners: {
		                   select: {
		                 	   fn:function(){
		                 			
									// viewall();
                 			  } 
		                 } 
		               } 	
			});
			
			var Status=[['Active'],['InActive']];
			var Statusstore=new Ext.data.SimpleStore({
				data:Status,
				fields:['Statusid']
			});
			
			var StatusCombo=new Ext.form.ComboBox({
				frame:true,
				store:Statusstore,
				id:'statuscomboId',
				forceselection:true,
				enableKeyEvents:true,
				mode:'local',
				anyMatch:true,
				value:'Active',
				onTypeAhead:true,
				triggerAction:'all',
				displayField:'Statusid',
				cls: 'selectstylePerfect',
				valueField:'Statusid',
				listners: {
						select: {
							fn:function(){
							
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
            text: '<%=Selectclient%>' + ' :',
            cls: 'labelstyle'
        },
        Client
    ]
});
var innerPanelForBookingCustomer = new Ext.form.FormPanel({
    standardSubmit: true,
    collapsible: false,
    autoScroll: true,
    height: 290,
    width: 450,
    frame: true,
    id: 'innerPanelForBookingCustomer',
    layout: 'table',
    layoutConfig: {
        columns: 4
    },
    items: [{
        xtype: 'fieldset',
        title: '<%=BookingCustomerDetails%>',
        cls: 'fieldsetpanel',
        collapsible: false,
        colspan: 3,
        id: 'customerDetailsId',
        width: 420,
        layout: 'table',
        layoutConfig: {
            columns: 4
        },
        items: [{
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'CustomerIdEmptyId1'
        }, {
            xtype: 'label',
            text: '<%=CustomerId%>' + ' :',
            cls: 'labelstyle',
            id: 'CustomerIdLabelId'
        },{
            xtype: 'textfield',
            cls: 'selectstylePerfect',
            allowBlank: true,
            blankText: '<%=EnterCustomerId%>',
            emptyText: '<%=EnterCustomerId%>',
            labelSeparator: '',
            id: 'customerId'
        },{
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'CustomerIdLabelId2'
        },{
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'CustomerNameEmptyId1'
        },  {
            xtype: 'label',
            text: '<%=CustomerName%>' + ' :',
            cls: 'labelstyle',
            id: 'customerNameLabelId'
        }, {
            xtype: 'textfield',
            cls: 'selectstylePerfect',
            allowBlank: false,
            regex:validate('city'),
            blankText: '<%=EnterCustomerName%>',
            emptyText: '<%=EnterCustomerName%>',
            labelSeparator: '',
            id: 'customerName'
            
        },{
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'CustomerNameLabelId2'
        },{
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'emailIdEmptyId2'
        },  {
            xtype: 'label',
            text: '<%=EmailId%>' + ' :',
            cls: 'labelstyle',
            id: 'emailIdLabelId'
        },  {
            xtype: 'textfield',
            cls: 'selectstylePerfect',
            allowBlank: false,
            vtype: 'email',
            blankText: '<%=EnterEmailId%>',
            emptyText: '<%=EnterEmailId%>',
            labelSeparator: '',
            id: 'emailId',
        },{
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'emailIdLabelId2'
        }, {
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'phoneNoEmptyId1'
        }, {
            xtype: 'label',
            text: '<%=PhoneNo%>' + ' :',
            cls: 'labelstyle',
            id: 'phoneNoLabelId'
        },{
            xtype: 'textfield',
            cls: 'selectstylePerfect',
            allowBlank: false,
            regex:validate('phone'),
            blankText: '<%=EnterPhoneNo%>',
            emptyText: '<%=EnterPhoneNo%>',
            labelSeparator: '',
            id: 'phoneNo'
        }, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'phoneLabelId2'
        }, {
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'mobileNoaEmptyId1'
        },  {
            xtype: 'label',
            text: '<%=MobileNo%>' + ' :',
            cls: 'labelstyle',
            id: 'mobileNoLabelId'
        },{
            xtype: 'textfield',
            cls: 'selectstylePerfect',
            allowBlank: true,
            blankText: '<%=EnterMobileNo%>',
            emptyText: '<%=EnterMobileNo%>',
            regex:validate('phone'),
            labelSeparator: '',
            id: 'mobileNo'
        }, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'mobileLabelId2'
        }, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'faxEmptyId1'
        }, {
            xtype: 'label',
            text: '<%=Fax%>' + ' :',
            cls: 'labelstyle',
            id: 'faxLabelId'
        }, {
            xtype: 'textfield',
            cls: 'selectstylePerfect',
            allowBlank: true,
            blankText: '<%=EnterFax%>',
            emptyText: '<%=EnterFax%>',
            labelSeparator: '',
            id: 'faxId'
        }, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'faxLabelId2'
        },{
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'tinEmptyId1'
        },  {
            xtype: 'label',
            text: '<%=Tin%>' + ' :',
            cls: 'labelstyle',
            id: 'tiLabellId'
        }, {
            xtype: 'textfield',
            cls: 'selectstylePerfect',
            allowBlank: true,
            blankText: '<%=EnterTin%>',
            emptyText: '<%=EnterTin%>',
            labelSeparator: '',
            id: 'tinId'
        }, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'tinLabelId2'
        }, {
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'addressEmptyId1'
        },  {
            xtype: 'label',
            text: '<%=Address%>' + ' :',
            cls: 'labelstyle',
            id: 'addressLabelId'
        },{
            xtype: 'textarea',
            cls: 'selectstylePerfect',
            allowBlank: false,
            blankText: '<%=EnterAddress%>',
            emptyText: '<%=EnterAddress%>',
            labelSeparator: '',
            allowBlank: false,
            id: 'addressId'
        }, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'addressLabelId2'
        }, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'cityEmptyId1'
        }, {
            xtype: 'label',
            text: '<%=City%>' + ' :',
            cls: 'labelstyle',
            id: 'cityLabelId'
        }, {
            xtype: 'textfield',
            cls: 'selectstylePerfect',
            allowBlank: true,
            blankText: '<%=EnterCity%>',
            emptyText: '<%=EnterCity%>',
            labelSeparator: '',
            id: 'cityId'
        }, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'cityLabelId2'
        }, 
        
        
        
        {
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'userEmptyId1'
        }, {
            xtype: 'label',
            text: '<%=UserId%>' + ' :',
            cls: 'labelstyle',
            id: 'userLabelId'
        }, {
            xtype: 'textfield',
            cls: 'selectstylePerfect',
            allowBlank: false,
            blankText: '<%=EnterUserName%>',
            emptyText: '<%=EnterUserName%>',
            labelSeparator: '',
            id: 'usernameId'
        }, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'userLabelId2'
        }, 
        
         {
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'pwdEmptyId1'
        }, {
            xtype: 'label',
            text: '<%=Password%>' + ' :',
            cls: 'labelstyle',
            id: 'pwdLabelId'
        }, {
        		xtype:'textfield',
	    		cls:'textrnumberstyle',
	    		inputType:'password',
	    		regex:/((?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=\S+$)(?=.*\W).{8,30})/,
	    		emptyText:'<%=EnterPassword%>',
	    		blankText:'<%=EnterPassword%>',
	    		allowBlank: false,
	    		regexText: '',
	    		id:'userpwdtid' }, 
	    		{
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'pwdLabelId2'
        }, 
        
        {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'stateEmptyId1'
        }, {
            xtype: 'label',
            text: '<%=State%>' + ' :',
            cls: 'labelstyle',
            id: 'stateLabelId'
        },stateCombo,{
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'stateLabelId2'
        }, {
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'regionEmptyId'
        }, {
            xtype: 'label',
            text: '<%=Region%>' + ' :',
            cls: 'labelstyle',
            id: 'regionLabelId'
        }, RegionCombo,{
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'regionLabelId2'
        },{
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'statusEmptyId1'
        },  {
            xtype: 'label',
            text: '<%=Status%>' + ' :',
            cls: 'labelstyle',
            id: 'statusLabelId'
        },StatusCombo,{
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'statusLabelId2'
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
                        Ext.example.msg("<%=Selectclient%>");
                        return;
                    }
                   
                    if (Ext.getCmp('customerName').getValue() == "") {
                        Ext.example.msg("<%=EnterCustomerName%>");
                        return;
                    }
                    if (Ext.getCmp('emailId').getValue() == "") {
                        Ext.example.msg("<%=EnterEmailId%>");
                        return;
                    }
                    if (Ext.getCmp('phoneNo').getValue() == "") {
                        Ext.example.msg("<%=EnterPhoneNo%>");
                        return;
                    }
                    
                    if (Ext.getCmp('mobileNo').getValue() == "") {
                        Ext.example.msg("<%=EnterMobileNo%>");
                        return;
                    }
                    
                    if(Ext.getCmp('addressId').getValue() == "") {
                        Ext.example.msg("<%=EnterAddress%>");
                        return;
                    }
                    
                    if(Ext.getCmp('usernameId').getValue() == "") {
                        Ext.example.msg("Enter User Name");
                        return;
                    }
                    
                    if(Ext.getCmp('userpwdtid').getValue() == "") {
                        Ext.example.msg("<%=EnterPassword%>");
                        return;
                    }
                    
					
					if (Ext.getCmp('regioncomboId').getValue() == "") {
					    Ext.example.msg("<%=SelectRegion%>");
                        return;
                        
                    }

                 
                    if (innerPanelForBookingCustomer.getForm().isValid()) {
                    var id;
                    var selectedCustomerId;
                    var selectedCustomerName;
                    var selectedEmail;
                    var selectedPhoneNo;
                    var selectedMobileNo;
                    var selectedFax;
                    var selectedTin;
                    var selectedAddress;
                    var selectedCity;
                    var selectedState;
                    var selectedRegion;
                    var selectedStatus;
                    var selectedUsername;
                    var selectedPassword;
                   
                    if (buttonValue == '<%=Modify%>') {
                        var selected = grid.getSelectionModel().getSelected();
                        id = selected.get('uniqueIdDataIndex');
 							selectedCustomerId=Ext.getCmp('customerId').getValue();
                            selectedCustomerName=Ext.getCmp('customerName').getValue();
                            selectedEmail=Ext.getCmp('emailId').getValue();
                            selectedPhoneNo=Ext.getCmp('phoneNo').getValue();
                            selectedMobileNo=Ext.getCmp('mobileNo').getValue();
                            selectedFax=Ext.getCmp('faxId').getValue();
                            selectedTin=Ext.getCmp('tinId').getValue();
                            selectedAddress=Ext.getCmp('addressId').getValue();
                            selectedUsername=Ext.getCmp('usernameId').getValue();
                            selectedPassword=Ext.getCmp('userpwdtid').getValue();
                            selectedCity=Ext.getCmp('cityId').getValue();
                            if (selected.get('stateDataIndex') != Ext.getCmp('statecomboId').getValue()) {
                            selectedState = Ext.getCmp('statecomboId').getValue();
                       		 } else {
                            selectedState = selected.get('stateIdDataIndex');
                       		 }
                       		if (selected.get('regionDataIndex') != Ext.getCmp('regioncomboId').getValue()) {
                            selectedRegion = Ext.getCmp('regioncomboId').getValue();
                       		} else {
                            selectedRegion = Ext.getCmp('regioncomboId').getValue();
                       		}
                       		if (selected.get('statusDataIndex') != Ext.getCmp('statuscomboId').getValue()) {
                            selectedStatus = Ext.getCmp('statuscomboId').getValue();
                       		} else {
                            selectedStatus = Ext.getCmp('statuscomboId').getValue();
                       		}
                    }
                    BookingCustomerOuterPanelWindow.getEl().mask();
                    Ext.Ajax.request({
                        url: '<%=request.getContextPath()%>/BookingCustomerAction.do?param=bookingCustomerAddAndModify',
                        method: 'POST',
                        params: {
                            buttonValue: buttonValue,
                            custId: Ext.getCmp('custcomboId').getValue(),
                            customerId:Ext.getCmp('customerId').getValue(),
                            name: Ext.getCmp('customerName').getValue(),
                            email: Ext.getCmp('emailId').getValue(),
                            phone: Ext.getCmp('phoneNo').getValue(),
                            mobile: Ext.getCmp('mobileNo').getRawValue(),
                            fax: Ext.getCmp('faxId').getValue(),
                            tin: Ext.getCmp('tinId').getValue(),
                            address: Ext.getCmp('addressId').getValue(),
                            usernameId: Ext.getCmp('usernameId').getValue(),
                            password: Ext.getCmp('userpwdtid').getValue(),
                            city: Ext.getCmp('cityId').getValue(),
                            state: Ext.getCmp('statecomboId').getValue(),
                            region: Ext.getCmp('regioncomboId').getValue(),
                            status: Ext.getCmp('statuscomboId').getValue(),
                            id: id,
                            selectedCustomerId: selectedCustomerId,
                            selectedCustomerName: selectedCustomerName,
                            selectedEmail: selectedEmail,
                            selectedPhoneNo: selectedPhoneNo,
                            selectedMobileNo: selectedMobileNo,
                            selectedFax: selectedFax,
                            selectedTin: selectedTin,
                            selectedAddress: selectedAddress,
                            selectedCity: selectedCity,
                            selectedState: selectedState,
                            selectedRegion: selectedRegion,
                            selectedStatus: selectedStatus,
                            selectedUserName: selectedUsername,
                            selectedPassword: selectedPassword
                           
                        },
                        success: function(response, options) {
                            var message = response.responseText;
                            Ext.example.msg(message);
                            Ext.getCmp('customerId').reset();
                            Ext.getCmp('customerName').reset();
                            Ext.getCmp('emailId').reset();
                            Ext.getCmp('phoneNo').reset();
                            Ext.getCmp('mobileNo').reset();
                            Ext.getCmp('faxId').reset();
                            Ext.getCmp('tinId').reset();
                            Ext.getCmp('addressId').reset();
                            Ext.getCmp('cityId').reset();
                            Ext.getCmp('usernameId').reset();
                            Ext.getCmp('userpwdtid').reset();
                            Ext.getCmp('statecomboId').reset();
                            Ext.getCmp('regioncomboId').reset();
                            Ext.getCmp('statuscomboId').reset();
                            myWin.hide();
                            BookingCustomerOuterPanelWindow.getEl().unmask();
                            store.load({
                                params: {
                                    CustId: Ext.getCmp('custcomboId').getValue()
                                }
                            });
                        },
                        failure: function() {
                            Ext.example.msg("Error");
                            myWin.hide();
                        }
                    });
                   }else{
                   Ext.example.msg('There is some invalid data in field, please correct it');
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

var BookingCustomerOuterPanelWindow = new Ext.Panel({
    width: 460,
    height: 340,
    standardSubmit: true,
    frame: false,
    items: [innerPanelForBookingCustomer, innerWinButtonPanel]
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
    items: [BookingCustomerOuterPanelWindow]
});




function addRecord() {
    if (Ext.getCmp('custcomboId').getValue() == "") {
        Ext.example.msg("<%=Selectclient%>");
        return;
    }
    buttonValue = '<%=Add%>';
    titelForInnerPanel = '<%=BookingCustomer%>';
    myWin.setPosition(450, 150);
    myWin.show();
    myWin.setTitle(titelForInnerPanel);
    Ext.getCmp('customerId').reset();
    Ext.getCmp('customerName').reset();
    Ext.getCmp('emailId').reset();
    Ext.getCmp('phoneNo').reset();
    Ext.getCmp('mobileNo').reset();
    Ext.getCmp('faxId').reset();
    Ext.getCmp('tinId').reset();
    Ext.getCmp('addressId').reset();
    Ext.getCmp('cityId').reset();
    Ext.getCmp('usernameId').reset();
    Ext.getCmp('userpwdtid').reset();
    Ext.getCmp('statecomboId').reset();
    Ext.getCmp('regioncomboId').reset();
    Ext.getCmp('statuscomboId').reset();
}
function modifyData() {
    if (Ext.getCmp('custcomboId').getValue() == "") {
        Ext.example.msg("<%=Selectclient%>");
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
    titelForInnerPanel = '<%=ModifyCustomerDetails%>';
    myWin.setPosition(450, 150);
    myWin.setTitle(titelForInnerPanel);
    myWin.show();
    var selected = grid.getSelectionModel().getSelected();
    Ext.getCmp('customerId').setValue(selected.get('customerIdDataIndex'));
    Ext.getCmp('customerName').setValue(selected.get('customerNameDataIndex'));
    Ext.getCmp('emailId').setValue(selected.get('emailDataIndex'));
    Ext.getCmp('phoneNo').setValue(selected.get('phoneDataIndex'));
    Ext.getCmp('mobileNo').setValue(selected.get('mobileDataIndex'));
    Ext.getCmp('faxId').setValue(selected.get('faxDataIndex'));
    Ext.getCmp('tinId').setValue(selected.get('tinDataIndex'));
    Ext.getCmp('addressId').setValue(selected.get('addressDataIndex'));
    Ext.getCmp('cityId').setValue(selected.get('cityDataIndex'));
    
    Ext.getCmp('usernameId').setValue(selected.get('userIdDataIndex'));
    Ext.getCmp('userpwdtid').setValue(selected.get('passwordDataIndex'));
   
    Ext.getCmp('statecomboId').setValue(selected.get('stateDataIndex'));
    Ext.getCmp('regioncomboId').setValue(selected.get('regionDataIndex'));
    Ext.getCmp('statuscomboId').setValue(selected.get('statusDataIndex'));
}

var reader = new Ext.data.JsonReader({
    idProperty: 'bookingCustomerid',
    root: 'bookingCustomerRoot',
    totalProperty: 'total',
    fields: [{
        name: 'slnoIndex'
    }, {
        name: 'customerIdDataIndex'
    }, {
        name: 'customerNameDataIndex'
    }, {
        name: 'emailDataIndex'
    }, {
        name: 'phoneDataIndex'
    }, {
        name: 'mobileDataIndex'
    }, {
        name: 'faxDataIndex'
    }, {
        name: 'tinDataIndex'
    }, {
        name: 'addressDataIndex'
    }, {
        name: 'cityDataIndex'
    }, {
        name: 'stateIdDataIndex'
    }, {
        name: 'stateDataIndex'
    },{
        name: 'uniqueIdDataIndex'
    }, {
        name: 'regionDataIndex'
    },{
        name: 'userIdDataIndex'
    },{
        name: 'passwordDataIndex'
    },{
        name: 'statusDataIndex'
    }]
});

var store = new Ext.data.GroupingStore({
    autoLoad: false,
    proxy: new Ext.data.HttpProxy({
        url: '<%=request.getContextPath()%>/BookingCustomerAction.do?param=getBookingCustomerReport',
        method: 'POST'
    }),
    storeId: 'custId',
    reader: reader
});

var filters = new Ext.ux.grid.GridFilters({
    local: true,
    filters: [{
        type: 'numeric',
        dataIndex: 'slnoIndex'
    }, {
        type: 'numeric',
        dataIndex: 'customerIdDataIndex'
    }, {
        type: 'string',
        dataIndex: 'customerNameDataIndex'
    }, {
        type: 'string',
        dataIndex: 'emailDataIndex'
    }, {
        type: 'numeric',
        dataIndex: 'phoneNoDataIndex'
    }, {
        type: 'numeric',
        dataIndex: 'mobileNoDataIndex'
    }, {
        type: 'numeric',
        dataIndex: 'faxDataIndex'
    }, {
        type: 'string',
        dataIndex: 'tinDataIndex'
    }, {
        type: 'string',
        dataIndex: 'addressDataIndex'
    }, {
        type: 'string',
        dataIndex: 'cityDataIndex'
    }, {
        type: 'string',
        dataIndex: 'stateDataIndex'
    }, {
        type: 'string',
        dataIndex: 'regionDataIndex'
    },{
        type: 'string',
        dataIndex: 'userIdDataIndex'
    },{
        type: 'string',
        dataIndex: 'passwordDataIndex'
    },{
        type: 'string',
        dataIndex: 'statusDataIndex'
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
            header: "<span style=font-weight:bold;><%=UniqueId%></span>",
            filter: {
                type: 'numeric'
            }
        }, {
      	    header: "<span style=font-weight:bold;><%=CustomerId%></span>",
            dataIndex: 'customerIdDataIndex',
            filter: {
                type: 'numeric'
            }
        }, {
            header: "<span style=font-weight:bold;><%=CustomerName%></span>",
            dataIndex: 'customerNameDataIndex',
            width: 100,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=EmailId%></span>",
            dataIndex: 'emailDataIndex',
            width: 100,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=PhoneNo%></span>",
            dataIndex: 'phoneDataIndex',
            width: 100,
            filter: {
                type: 'numeric'
            }
        }, {
            header: "<span style=font-weight:bold;><%=MobileNo%></span>",
            dataIndex: 'mobileDataIndex',
            width: 100,
            filter: {
                type: 'numeric'
            }
        }, {
            header: "<span style=font-weight:bold;><%=Fax%></span>",
            dataIndex: 'faxDataIndex',
            width: 100,
            filter: {
                type: 'numeric'
            }
        }, {
            header: "<span style=font-weight:bold;><%=Tin%></span>",
            dataIndex: 'tinDataIndex',
            width: 100,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=Address%></span>",
            dataIndex: 'addressDataIndex',
            width: 100,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=City%></span>",
            dataIndex: 'cityDataIndex',
            width: 100,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=UserId%></span>",
            dataIndex: 'userIdDataIndex',
            filter: {
                type: 'string'
            }
        }, {
            
            header: "<span style=font-weight:bold;><%=Password%></span>",
            dataIndex: 'passwordDataIndex',
            hidden: true,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=State%></span>",
            dataIndex: 'stateDataIndex',
            width: 100,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=Region%></span>",
            dataIndex: 'regionDataIndex',
            width: 100,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=Status%></span>",
            dataIndex: 'statusDataIndex',
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
grid = getGrid('<%=BookingCustomerDetails%>', '<%=NoRecordsFound%>', store, screen.width - 40, 420, 20, filters, '<%=ClearFilterData%>', false, '', 15, false, '', false, '', false, '', jspName, exportDataType, false, 'PDF', true, '<%=Add%>', true, '<%=Modify%>', false, '');
//******************************************************************************************************************************************************
Ext.onReady(function() {
    ctsb = tsb;
    Ext.QuickTips.init();
    Ext.form.Field.prototype.msgTarget = 'side';
    outerPanel = new Ext.Panel({
        title: '<%=BookingCustomer%>',
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
    
    
    
    
    

