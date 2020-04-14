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
	String ipVal = request.getParameter("ipVal");	
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
tobeConverted.add("Mine_Code");
tobeConverted.add("Enter_Mine_Code");
tobeConverted.add("Mine_Details");
tobeConverted.add("Mine_Name");
tobeConverted.add("Enter_Mine_Name");
tobeConverted.add("IBM_Number");
tobeConverted.add("Enter_IBM_Number");
tobeConverted.add("EC_Limit");
tobeConverted.add("Enter_EC_Limit");
tobeConverted.add("Add_Mine_Details");
tobeConverted.add("Modify_Mine_Details");
tobeConverted.add("Wallet_Amount");
tobeConverted.add("Wallet_Quantity");
tobeConverted.add("EC_Balance");
tobeConverted.add("Organization_Code");
tobeConverted.add("Organization_Name");
tobeConverted.add("Enter_Organization_Name");
tobeConverted.add("Select_Organization_Code");

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
String Mine_Code=convertedWords.get(14);
String Enter_Mine_Code=convertedWords.get(15);
String Mine_Details=convertedWords.get(16);
String Mining_Company_Name=convertedWords.get(17);
String Enter_Mining_Company_Name=convertedWords.get(18);
String IBM_Number=convertedWords.get(19);
String Enter_IBM_Number=convertedWords.get(20);
String EC_Limit="EC Allocated";
String Enter_EC_Limit="Enter EC Allocated";
String Add_Mine_Details=convertedWords.get(23);
String Modify_Mine_Details=convertedWords.get(24);
String Wallet_Amount=convertedWords.get(25);
String Wallet_Quantity=convertedWords.get(26);
String EC_Balance=convertedWords.get(27);
String Organization_Code=convertedWords.get(28);
String Organization_Name=convertedWords.get(29);
String Enter_Organization_Name=convertedWords.get(30);
String Select_Organization_Code=convertedWords.get(31);

String enhanced_EC="Enhanced EC";
String Enter_enhanced_EC="Enter Enhanced EC"; 
String carry_forward_EC="Carry Forwarded EC";
String Enter_carry_forward_EC="Enter carry forwarded EC";
String total_EC="Total EC";
String Financial_Year="Financial Year";
String remarks="Remarks";
String Enter_Remarks="Enter Remarks";

Calendar calender=Calendar.getInstance();
//calender.set(Calendar.MONTH,Calendar.MONTH+1);
//System.out.println(calender.get(Calendar.MONTH));
boolean carryEditable=false;
if(calender.get(Calendar.MONTH)==3){ carryEditable=true; }
String year="";
String curYear=String.valueOf(calender.get(Calendar.YEAR));
String preYear=String.valueOf(calender.get(Calendar.YEAR)-1);
String nextYear=String.valueOf(calender.get(Calendar.YEAR)+1);
if(calender.get(Calendar.MONTH) >=3){
	year = curYear+"-"+nextYear;
}else{
	year = preYear+"-"+curYear;
}

int userId=loginInfo.getUserId(); 
String userAuthority=cf.getUserAuthority(systemId,userId);	

if(customerId > 0 && loginInfo.getIsLtsp()== -1 && !userAuthority.equalsIgnoreCase("Admin"))
	{
		response.sendRedirect(request.getContextPath()+ "/Jsps/Common/401Error.html");
	}
	else{

%>
<jsp:include page="../Common/header.jsp" />
 		<title>Mine Details</title>		
 
	 <style>
  .x-panel-tl
	{
		border-bottom: 0px solid !important;
	}
  </style>
 
   <%if (loginInfo.getStyleSheetOverride().equals("Y")){%>
	<jsp:include page="../Common/ImportJSSandMining.jsp"/>
	<jsp:include page="../IronMining/css.jsp" />
	<%}else{%>
	<jsp:include page="../Common/ImportJS.jsp" />
	<jsp:include page="../IronMining/css.jsp" />
	<%}%>
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
					height : 38px !important;
				}
				.x-layer ul {
					min-height: 27px !important;
				}	
				div#myWin {
					top : 52px !important;
				}
				.x-menu-list {
					height:auto !important;
				}
			</style>
		<%}%>
   <script>
   var innerpage=<%=ipVal%>;
	
	   	    if (innerpage == true) {
				
				if(document.getElementById("topNav")!=null && document.getElementById("topNav")!=undefined)
				{
					document.getElementById("topNav").style.display = "none";
					$(".container").css({"margin-top":"-72px"});
				}
				
			}
   
var outerPanel;
var ctsb;
var jspName = "Mine Details";
var exportDataType = "int,string,string,string,string,string,string,number,number,number,number,number,number,number,number,string,string,string,string,string,int";
var selected;
var grid;
var buttonValue;
var titelForInnerPanel;
var myWin;
var year='<%=year%>';
var maxCarryedEC=0;


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
                        CustId: custId,
                        jspName: jspName,
                        CustName: Ext.getCmp('custcomboId').getRawValue()
                    }
                });
                OrgCodeComboStore.load({
                    params: {
                        clientId: custId
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
                        jspName: jspName,
                        CustName: Ext.getCmp('custcomboId').getRawValue()
                    }
                });
                 OrgCodeComboStore.load({
                    params: {
                        clientId: custId
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

 var OrgCodeComboStore= new Ext.data.JsonStore({
				   url: '<%=request.getContextPath()%>/MiningTCMasterAction.do?param=getOrgcode',
				   root: 'OrgcodeRoot',
			       autoLoad: false,
			        id: 'orgcodeId',
				   fields: ['ID','orgcode','orgName']
	});
	
 var maxCarryedECStore= new Ext.data.JsonStore({
				   url: '<%=request.getContextPath()%>/MiningTCMasterAction.do?param=getMaxCarryForwardedEC',
				   root: 'maxCarryedECRoot',
			       autoLoad: false,
			       id: 'maxCarryedECStoreId',
				   fields: ['MAX_CARRYED_EC','ORG_ID']
	});	
	//****************************combo for OrgCode***************************************
var OrgCodeCombo = new Ext.form.ComboBox({
    store: OrgCodeComboStore,
    id: 'OrgcodecomboId',
    mode: 'local',
    forceSelection: true,
    emptyText: '<%=Select_Organization_Code%>',
    blankText: '<%=Select_Organization_Code%>',
    resizable: true,
    selectOnFocus: true,
    allowBlank: true,
    anyMatch: true,
    typeAhead: false,
    triggerAction: 'all',
    lazyRender: true,
    valueField: 'ID',
    displayField: 'orgcode',
    cls:'selectstylePerfectnew',
    listeners: {
        select: {
            fn: function () {
            var id=Ext.getCmp('OrgcodecomboId').getValue();
            var row = OrgCodeComboStore.findExact('ID',id);
            var rec = OrgCodeComboStore.getAt(row);
            orgname=rec.data['orgName'];
            Ext.getCmp('orgnameid').setValue(orgname);
            
            maxCarryedECStore.load({
            	params:{
            		custId: Ext.getCmp('custcomboId').getValue(),
            		orgId: Ext.getCmp('OrgcodecomboId').getValue(),
            		year: Ext.getCmp('financialYearId').getValue()
            	},
            	callback: function(){
            		maxCarryedEC=maxCarryedECStore.getAt(0).data['MAX_CARRYED_EC']
            		//alert(maxCarryedEC)
            	}
            });
            }
        }
    }
});
var innerPanelForMineMasterDetails = new Ext.form.FormPanel({
    standardSubmit: true,
    collapsible: false,
    //autoScroll: true,
    height: 370,
    width: 470,
    frame: false,
    id: 'innerPanelForMineMasterDetailsId',
    layout: 'table',
    layoutConfig: {
        columns: 3
    },
    items: [{
        xtype: 'fieldset',
        title:'<%=Mine_Details%>',
        cls: 'my-fieldset',
        collapsible: false,
        colspan:3,
        id: 'MineralInfoId',
        width: 450,
        height: 370,
        layout: 'table',
        layoutConfig: {
            columns: 4
        },
        items: [{
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'MandatorymineralId'
        },{
            xtype: 'label',
            text: '<%=Mine_Code%>' + ' :',
            cls: 'labelstylenew',
            id: 'mineralCodeLabelId'
        }, {
            xtype: 'textfield',
            cls: 'selectstylePerfectnew',
            id: 'mineralCodeId',
            mode: 'local',
            forceSelection: true,
            emptyText: '<%=Enter_Mine_Code%>',
            blankText: '<%=Enter_Mine_Code%>',
            selectOnFocus: true,
            allowBlank: false,
           listeners:{
					change: function(field, newValue, oldValue){
					field.setValue(newValue.toUpperCase().trim());
					 if(field.getValue().length> 50){
					 Ext.example.msg("Field exceeded it's Maximum length");
					field.setValue(newValue.substr(0,50).toUpperCase().trim()); field.focus(); } 
					 }
					}
        }, {},  {
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'nameEmptyId1'
        },{
            xtype: 'label',
            text: '<%=Mining_Company_Name%>' + ' :',
            cls: 'labelstylenew',
            id: 'miningCompanyNameId'
        }, {
            xtype: 'textfield',
            cls: 'selectstylePerfectnew',
            id: 'miningCompanyNamesId',
            mode: 'local',
            forceSelection: true,
            emptyText: '<%=Enter_Mining_Company_Name%>',
            blankText: '<%=Enter_Mining_Company_Name%>',
            selectOnFocus: true,
            allowBlank: false,
            listeners:{
					change: function(field, newValue, oldValue){
					field.setValue(newValue.toUpperCase());
					if(field.getValue().length> 100){
					Ext.example.msg("Field exceeded it's Maximum length");
					field.setValue(newValue.substr(0,100).toUpperCase().trim()); field.focus(); } 
					}
					}
        }, {},  {
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'numberEmptyId1'
        },{
            xtype: 'label',
            text: '<%=IBM_Number%>' + ' :',
            cls: 'labelstylenew',
            id: 'ibmNoId'
        }, {
            xtype: 'textfield',
            cls: 'selectstylePerfectnew',
            id: 'IbmNoId',
            mode: 'local',
            forceSelection: true,
            emptyText: '<%=Enter_IBM_Number%>',
            blankText: '<%=Enter_IBM_Number%>',
            selectOnFocus: true,
            allowBlank: false,
            listeners:{
					change: function(field, newValue, oldValue){
					field.setValue(newValue.toUpperCase().trim());
					if(field.getValue().length> 100){
					Ext.example.msg("Field exceeded it's Maximum length");
					field.setValue(newValue.substr(0,100).toUpperCase().trim()); field.focus();
					 } 
					}
					}
        }, {},  {
	            xtype: 'label',
	            text: '*',
	            cls: 'mandatoryfield',
	            id: 'orgcodeid'
	        }, {
	            xtype: 'label',
	            text: '<%=Organization_Code%>' + ' :',
	            cls: 'labelstylenew',
	            id: 'OrgcodeLabelId'
	        }, OrgCodeCombo,
	        {}, {
	            xtype: 'label',
	            text: '',
	            cls: 'mandatoryfield'
	        }, {
	            xtype: 'label',
	            text: '<%=Organization_Name%>' + ' :',
	            cls: 'labelstylenew'
	        }, {
	           xtype: 'textfield',
                cls:'selectstylePerfectnew',               
                stripCharsRe :/[,]/,
                autoCreate: {  
                       tag: "input",
                       maxlength: 50,
                       type: "text",
                       size: "200",
                       autocomplete: "off"
                   },
                readOnly:true,
                mode: 'local',
	            id: 'orgnameid'
	    },{},  {
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'yearManId'
        },{
            xtype: 'label',
            text: '<%=Financial_Year%>' + ' :',
            cls: 'labelstylenew',
            id: 'yearLabId'
        }, {
            xtype: 'textfield',
            cls: 'selectstylePerfectnew',
            stripCharsRe: /[,]/,
            autoCreate: { //restricts 
                tag: "input",
                maxlength: 50,
                type: "text",
                size: "200",
                autocomplete: "off"
            },
            id: 'financialYearId',
            mode: 'local',            
        }, {},  {
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'carryForwardId'
        },{
            xtype: 'label',
            text: '<%=carry_forward_EC%>' + ' :',
            cls: 'labelstylenew',
            id: 'carryForwardECLabId'
        }, {
            xtype: 'numberfield',
            cls: 'selectstylePerfectnew',
            id: 'carryForwardECId',
            mode: 'local',
            forceSelection: true,
            emptyText: '<%=Enter_carry_forward_EC%>',
            blankText: '<%=Enter_carry_forward_EC%>',
            selectOnFocus: true,
            allowBlank: false,
            decimalPrecision: 2,
            allowNegative: false,
            autoCreate: { tag: "input",autocomplete: "off",maxlength: 9 },
            listeners:{ change: function(f, n, o){
             f.setValue(Math.abs(n));
             
             var allocktedEC = Ext.getCmp('EcLimitId').getValue();
             var enhancedEC = Ext.getCmp('enhancedECId').getValue();
             var pattern = /[12][0-9]{3}-[12][0-9]{3}$/;
             if (!pattern.test(allocktedEC) && !pattern.test(enhancedEC)){
                 Ext.getCmp('totalECId').setValue(Number(f.getValue()+Number(allocktedEC)+Number(enhancedEC)));
             }
             } },
            
        }, {},  {
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'ecEmptyId1'
        },{
            xtype: 'label',
            text: '<%=EC_Limit%>' + ' :',
            cls: 'labelstylenew',
            id: 'EcId'
        }, {
            xtype: 'numberfield',
            cls: 'selectstylePerfectnew',
            id: 'EcLimitId',
            mode: 'local',
            forceSelection: true,
            emptyText: '<%=Enter_EC_Limit%>',
            blankText: '<%=Enter_EC_Limit%>',
            selectOnFocus: true,
            allowBlank: false,
            decimalPrecision: 2,
            allowNegative: false,
            autoCreate: { tag: "input",autocomplete: "off",maxlength: 9 },
            listeners:{ change: function(f, n, o){
             f.setValue(Math.abs(n)); 
             var carryedEC = Ext.getCmp('carryForwardECId').getValue();
             var enhancedEC = Ext.getCmp('enhancedECId').getValue();
             var pattern = /[12][0-9]{3}-[12][0-9]{3}$/;
             if (!pattern.test(carryedEC) && !pattern.test(enhancedEC)){
             	Ext.getCmp('totalECId').setValue(Number(f.getValue()+Number(carryedEC)+Number(enhancedEC)));
             }
             } },
            
        }, {},  {
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'enhancedEcManId'
        },{
            xtype: 'label',
            text: '<%=enhanced_EC%>' + ' :',
            cls: 'labelstylenew',
            id: 'enhancedECLabId'
        }, {
            xtype: 'numberfield',
            cls: 'selectstylePerfectnew',
            id: 'enhancedECId',
            mode: 'local',
            forceSelection: true,
            emptyText: '<%=Enter_enhanced_EC%>',
            blankText: '<%=Enter_enhanced_EC%>',
            selectOnFocus: true,
            allowBlank: false,
            allowNegative: false,
            autoCreate: { tag: "input",autocomplete: "off",maxlength: 9 },
            listeners:{ change: function(f, n, o){ 
            	f.setValue(Math.abs(n));
            	var carryedEC = Ext.getCmp('carryForwardECId').getValue();
            	var allocatedEC = Ext.getCmp('EcLimitId').getValue();
            	var pattern = /[12][0-9]{3}-[12][0-9]{3}$/;
            	if (!pattern.test(carryedEC) && !pattern.test(allocatedEC)){
	            	Ext.getCmp('totalECId').setValue(Number(f.getValue()+Number(carryedEC)+Number(allocatedEC)));
	            }
            } },
        }, {},  {
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'totalEcManId'
        },{
            xtype: 'label',
            text: '<%=total_EC%>' + ' :',
            cls: 'labelstylenew',
            id: 'totalECLabId'
        }, {
            xtype: 'numberfield',
            cls: 'selectstylePerfectnew',
            id: 'totalECId',
            readOnly: true,
            mode: 'local',
            forceSelection: true,
            emptyText: '<%=total_EC%>',
            blankText: '<%=total_EC%>',
            selectOnFocus: true,
            allowBlank: false,
            decimalPrecision: 2,
            allowNegative: false,
            autoCreate: { tag: "input",autocomplete: "off",maxlength: 9 },
            listeners:{ change: function(f, n, o){ f.setValue(Math.abs(n)); } },
            
        }, {},  {
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'remarksManId'
        },{
            xtype: 'label',
            text: '<%=remarks%>' + ' :',
            cls: 'labelstylenew',
            id: 'remarksLabId'
        }, {
            xtype: 'textarea',
            cls: 'selectstylePerfectnew',
            stripCharsRe: /[,]/,
            height: 50,
            width: 200,
            model: 'local',
            id: 'remarksId',
            emptyText: '<%=Enter_Remarks%>',
            blankText: '<%=Enter_Remarks%>',
            listeners:{
			 change: function(field, newValue, oldValue){
			   field.setValue(newValue.trim());
			    if(field.getValue().length> 100){ Ext.example.msg("Field exceeded it's Maximum length"); 
				  field.setValue(newValue.substr(0,100).toUpperCase().trim()); field.focus(); 
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
    autoHeight: true,
    height: 80,
    width: 445,
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
                   
                    if (Ext.getCmp('mineralCodeId').getValue() == "") {
                    	Ext.example.msg("<%=Enter_Mine_Code%>");
                    	Ext.getCmp('mineralCodeId').focus();
                        return;
                    }
                     if (Ext.getCmp('miningCompanyNamesId').getValue() == "") {
                    	Ext.example.msg("<%=Enter_Mining_Company_Name%>");
                    	Ext.getCmp('miningCompanyNamesId').focus();
                        return;
                    }
                    if (Ext.getCmp('IbmNoId').getValue() == "") {
                    	Ext.example.msg("<%=Enter_IBM_Number%>");
                    	Ext.getCmp('IbmNoId').focus();	
                        return;
                    }
                    if (Ext.getCmp('OrgcodecomboId').getValue() == "") {
                    	Ext.example.msg("<%=Select_Organization_Code%>");
                    	Ext.getCmp('OrgcodecomboId').focus();
                        return;
                    }
                    if (Ext.getCmp('financialYearId').getValue() == "") {
                        Ext.example.msg("Enter Financial Year");
                        Ext.getCmp('financialYearId').focus();
                        return;
                    }
                    var pattern = /[12][0-9]{3}-[12][0-9]{3}$/;
                    if (!pattern.test(Ext.getCmp('financialYearId').getValue())) {
                        Ext.example.msg("Enter Valid Financial Year(Eg:2015-2016)");
                        Ext.getCmp('financialYearId').focus();
                        return;
                    }
                    var fyear = Ext.getCmp('financialYearId').getValue();
                    var syear = fyear.substr(0, 4);
                    var eYear = fyear.substr(5);
                    if ((eYear - syear) == 1 && (eYear - syear) != 0) {} else if ((eYear - syear) < 1) {
                        Ext.example.msg(" Enter Valid Year");
                        Ext.getCmp('financialYearId').focus();
                        return;
                    } else {
                        Ext.example.msg("Only One Year Difference Is Allowed");
                        Ext.getCmp('financialYearId').focus();
                        return;
                    }
                    
                    	var rec;
                        var orgidModify;
                        var pattern = /^[a-zA-Z0-9][a-zA-Z0-9\s]*/;
                        if (buttonValue == 'Modify') {
                            var selected = grid.getSelectionModel().getSelected();
                            id = selected.get('uniqueIdDataIndex');
                            if (selected.get('orgcodeDataIndex') != Ext.getCmp('OrgcodecomboId').getValue()) {
                                orgidModify = Ext.getCmp('OrgcodecomboId').getValue();
                            } else {
                                orgidModify = selected.get('orgIdDataIndex');
                            }
                            
                        if (!pattern.test(Ext.getCmp('enhancedECId').getValue())){
	                         Ext.example.msg("Enter Enhanced EC");
	                         Ext.getCmp('enhancedECId').focus();
	                         return;
                        }
                        if (selected.get('carryForwardedECInd') > Ext.getCmp('carryForwardECId').getValue()) {
                         	Ext.example.msg("Entered Carry Forwarded EC is lesser than previous limit");
                           	return;
                    	}
                    	if(<%=carryEditable%>){
                    	if((maxCarryedEC+Number(selected.get('carryForwardedECInd'))) < Ext.getCmp('carryForwardECId').getValue()){
                        	Ext.example.msg("Entered Carry forwarded EC should not more than "+(maxCarryedEC+Number(selected.get('carryForwardedECInd'))));
                          	Ext.getCmp('carryForwardECId').focus();
                          	return;
                        }
                    	}
                        if (selected.get('EcIndex') > Ext.getCmp('EcLimitId').getValue()) {
                         	Ext.example.msg("Entered EC Allocated is lesser than previous limit");
                           	return;
                    	}
                    	if (selected.get('enhancedECInd') > Ext.getCmp('enhancedECId').getValue()) {
                         	Ext.example.msg("Entered Enhanced EC is lesser than previous limit");
                           	return;
                    	}
                        }else if(buttonValue == 'Add'){
	                        if (!pattern.test(Ext.getCmp('carryForwardECId').getValue())){
	                          Ext.example.msg("Enter Carry forwarded EC");
	                          Ext.getCmp('carryForwardECId').focus();
	                          return;
		                     }
	                      	if (Ext.getCmp('EcLimitId').getValue()==""){
	                          Ext.example.msg("<%=Enter_EC_Limit%>");
	                          Ext.getCmp('EcLimitId').focus();
	                          return;
	                        }
	                        if (!pattern.test(Ext.getCmp('enhancedECId').getValue())){
	                          Ext.example.msg("Enter Enhanced EC");
	                          Ext.getCmp('enhancedECId').focus();
	                          return;
		                     }
	                        //if(Ext.getCmp('carryForwardECId').getValue()=="" && Ext.getCmp('EcLimitId').getValue()=="" && Ext.getCmp('enhancedECId').getValue()==""){
	                        //	Ext.example.msg("Please Enter atleast one type of EC.");
	                        //   return;
	                        //}
	                        if(maxCarryedEC < Ext.getCmp('carryForwardECId').getValue()){
	                        	Ext.example.msg("Entered Carry forwarded EC should not more than "+maxCarryedEC);
	                          	Ext.getCmp('carryForwardECId').focus();
	                          	return;
                       		}		
                        }
                        
                        if (Ext.getCmp('remarksId').getValue() == "") {
	                    	Ext.example.msg("<%=Enter_Remarks%>");
	                    	Ext.getCmp('remaksid').focus();
	                        return;
	                    }
                        
                       routeMasterOuterPanelWindow.getEl().mask();
                        Ext.Ajax.request({
                            url: '<%=request.getContextPath()%>/MiningTCMasterAction.do?param=AddorModifyMineDetails',
                            method: 'POST',
                            params: {
                                buttonValue: buttonValue,
                                CustId: Ext.getCmp('custcomboId').getValue(),
                                CustName: Ext.getCmp('custcomboId').getRawValue(),
                                mineralCode: Ext.getCmp('mineralCodeId').getValue(),
                                miningName: Ext.getCmp('miningCompanyNamesId').getValue(),
                                ibmNo: Ext.getCmp('IbmNoId').getValue(),
                                financialYear: Ext.getCmp('financialYearId').getValue(),
                                carryedEC: Ext.getCmp('carryForwardECId').getValue(),
                                EcLimit: Ext.getCmp('EcLimitId').getValue(),
                                enhancedEC: Ext.getCmp('enhancedECId').getValue(),
                                totalEC: Ext.getCmp('totalECId').getValue(),
                                remarks: Ext.getCmp('remarksId').getValue(),
                                id: id,
                                orgcode: Ext.getCmp('OrgcodecomboId').getRawValue(),
                                orgname: Ext.getCmp('orgnameid').getValue(),
                                orgid:Ext.getCmp('OrgcodecomboId').getValue(),
                                orgidModify : orgidModify
                            },
                            success: function(response, options) {
                                var message = response.responseText;
                                Ext.example.msg(message);
							    Ext.getCmp('mineralCodeId').reset();
							    Ext.getCmp('miningCompanyNamesId').reset();
							    Ext.getCmp('IbmNoId').reset();
							    Ext.getCmp('EcLimitId').reset();
							    Ext.getCmp('OrgcodecomboId').reset();
							    Ext.getCmp('orgnameid').reset();
                                myWin.hide();
                                routeMasterOuterPanelWindow.getEl().unmask();
                                store.load({
                                    params: {
                                        CustId: custId,
                                        jspName: jspName,
                            			CustName: Ext.getCmp('custcomboId').getRawValue()
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
    width: 450,
    height: 470,
    standardSubmit: true,
    frame: true,
    items: [innerPanelForMineMasterDetails, innerWinButtonPanel]
});

myWin = new Ext.Window({
    title: titelForInnerPanel,
    closable: false,
    resizable: false,
    modal: true,
    autoScroll: false,
    height: 470,
    width: 470,
    id: 'myWin',
    items: [routeMasterOuterPanelWindow]
});

function addRecord() {
    if (Ext.getCmp('custcomboId').getValue() == "") {
     Ext.example.msg("<%=SelectCustomerName%>");
        return;
    }
    buttonValue = '<%=Add%>';
    titelForInnerPanel = '<%=Add_Mine_Details%>';
    myWin.setPosition(450, 20);
    myWin.show();
    //  myWin.setHeight(350);

   Ext.getCmp('mineralCodeId').reset();
   Ext.getCmp('miningCompanyNamesId').reset();
   Ext.getCmp('IbmNoId').reset();
   Ext.getCmp('OrgcodecomboId').reset();
   Ext.getCmp('orgnameid').reset();
   Ext.getCmp('OrgcodecomboId').setReadOnly(false);
   Ext.getCmp('financialYearId').setReadOnly(true);
   Ext.getCmp('financialYearId').setValue(year);
   Ext.getCmp('carryForwardECId').reset();
   Ext.getCmp('carryForwardECId').setReadOnly(false);
   Ext.getCmp('EcLimitId').reset();
   Ext.getCmp('enhancedECId').setValue(0);
   Ext.getCmp('totalECId').reset();
   Ext.getCmp('remarksId').reset();
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
    titelForInnerPanel = '<%=Modify_Mine_Details%>';
    myWin.setPosition(450, 20);
    myWin.setTitle(titelForInnerPanel);
    myWin.show();
 
    var selected = grid.getSelectionModel().getSelected();
    Ext.getCmp('mineralCodeId').setValue(selected.get('mineralCodeDataIndex'));
    Ext.getCmp('miningCompanyNamesId').setValue(selected.get('miningcompanyNameIndex'));
    Ext.getCmp('IbmNoId').setValue(selected.get('ibmNumberIndex'));
    Ext.getCmp('financialYearId').setReadOnly(true);
    Ext.getCmp('financialYearId').setValue(selected.get('finanYearInd'));
    if(<%=carryEditable%>){
    	Ext.getCmp('carryForwardECId').setReadOnly(false);
    }else{
    	Ext.getCmp('carryForwardECId').setReadOnly(true);
    }
    Ext.getCmp('carryForwardECId').setValue(selected.get('carryForwardedECInd'));
    Ext.getCmp('EcLimitId').setValue(selected.get('EcIndex'));
    Ext.getCmp('enhancedECId').setValue(selected.get('enhancedECInd'));
    Ext.getCmp('totalECId').setValue(selected.get('totalECInd'));
    Ext.getCmp('remarksId').setValue(selected.get('remarksInd'));
    Ext.getCmp('OrgcodecomboId').setReadOnly(true);
    Ext.getCmp('OrgcodecomboId').setValue(selected.get('orgcodeDataIndex'));
    Ext.getCmp('orgnameid').setValue(selected.get('orgNameDataIndex'));
    maxCarryedECStore.load({
    	params:{
    		custId: Ext.getCmp('custcomboId').getValue(),
    		orgId: selected.get('orgIdDataIndex'),
    		year: Ext.getCmp('financialYearId').getValue()
    	},
    	callback: function(){
    		maxCarryedEC=maxCarryedECStore.getAt(0).data['MAX_CARRYED_EC']
    	}
    });
    }
var reader = new Ext.data.JsonReader({
    idProperty: 'ownMasterid',
    root: 'mineDetailsRoot',
    totalProperty: 'total',
    fields: [{
        name: 'slnoIndex'
    }, {
        name: 'mineralCodeDataIndex'
    }, {
        name: 'miningcompanyNameIndex'
    }, {
        name: 'ibmNumberIndex'
    }, {
        name: 'EcIndex'
    }, {
        name: 'walletAmountIndex'
    }, {
        name: 'walletQuantityIndex'
    }, {
        name: 'ecBalenceIndex'
    }, {
        name: 'ecUsedIndex'
    }, {
        name: 'uniqueIdDataIndex'
    }, {
        name: 'orgcodeDataIndex'
    }, {
        name: 'orgNameDataIndex'
    }, {
        name: 'orgIdDataIndex'
    }, {
        name: 'finanYearInd'
    }, {
        name: 'carryForwardedECInd'
    }, {
        name: 'enhancedECInd'
    }, {
        name: 'totalECInd'
    }, {
    	name: 'remarksInd'
    }, {
    	name: 'insertedTimeInd',
    	type: 'date'
    }, {
    	name: 'insertedByInd'
    }, {
    	name: 'updatedTimeInd',
    	date: 'date'
    }, {
    	name: 'updatedByInd'
    }]
});

var store = new Ext.data.GroupingStore({
    autoLoad: false,
    proxy: new Ext.data.HttpProxy({
       url: '<%=request.getContextPath()%>/MiningTCMasterAction.do?param=getMineDetails',
        method: 'POST'
    }),
    storeId: 'mineMasterId',
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
        dataIndex: 'mineralCodeDataIndex'
    }, {
        type: 'string',
        dataIndex: 'miningcompanyNameIndex'
    }, {
        type: 'string',
        dataIndex: 'ibmNumberIndex'
    }, {
        type: 'string',
        dataIndex: 'finanYearInd'
    }, {
        type: 'numeric',
        dataIndex: 'carryForwardedECInd'
    }, {
        type: 'numeric',
        dataIndex: 'EcIndex'
    }, {
        type: 'numeric',
        dataIndex: 'enhancedECInd'
    }, {
        type: 'numeric',
        dataIndex: 'totalECInd'
    }, {
        type: 'numeric',
        dataIndex: 'walletAmountIndex'
    }, {
        type: 'numeric',
        dataIndex: 'walletQuantityIndex'
    }, {
        type: 'numeric',
        dataIndex: 'ecBalenceIndex'
    }, {
        type: 'numeric',
        dataIndex: 'ecUsedIndex'
    }, {
        type: 'string',
        dataIndex: 'orgcodeDataIndex'
    }, {
        type: 'string',
        dataIndex: 'orgNameDataIndex'
    },{
        type: 'string',
        dataIndex: 'orgIdDataIndex'
    },{
        type: 'string',
        dataIndex: 'remarksInd'
    }, {
    	type: 'date',
        dataIndex: 'insertedTimeInd'
    }, {
    	type: 'string',
        dataIndex: 'insertedByInd'
    }, {
     	type: 'date',
        dataIndex: 'updatedTimeInd'
    }, {
    	type: 'string',
        dataIndex: 'updatedByInd'
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
            header: "<span style=font-weight:bold;><%=Mine_Code%></span>",
            dataIndex: 'mineralCodeDataIndex',
            width: 50,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=Mining_Company_Name%></span>",
            dataIndex: 'miningcompanyNameIndex',
            width: 100,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=IBM_Number%></span>",
            dataIndex: 'ibmNumberIndex',
            width: 100,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=Organization_Code%></span>",
            dataIndex: 'orgcodeDataIndex',
            width: 100,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=Organization_Name%></span>",
            dataIndex: 'orgNameDataIndex',
            width: 100,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=Financial_Year%></span>",
            dataIndex: 'finanYearInd',
            align: 'right',
            width: 70
        }, {
            header: "<span style=font-weight:bold;><%=carry_forward_EC%></span>",
            dataIndex: 'carryForwardedECInd',
            align: 'right',
            width: 100
        },{
            header: "<span style=font-weight:bold;><%=EC_Limit%></span>",
            dataIndex: 'EcIndex',
            align: 'right',
            width: 100,
            filter: {
                type: 'numeric'
            }
        }, {
            header: "<span style=font-weight:bold;><%=enhanced_EC%></span>",
            dataIndex: 'enhancedECInd',
            align: 'right',
            width: 100,
        }, {
            header: "<span style=font-weight:bold;><%=total_EC%></span>",
            dataIndex: 'totalECInd',
            align: 'right',
            width: 100,
        }, {
            header: "<span style=font-weight:bold;><%=Wallet_Amount%></span>",
            dataIndex: 'walletAmountIndex',
            align: 'right',
            width: 100,
            hidden: true,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=Wallet_Quantity%></span>",
            dataIndex: 'walletQuantityIndex',
            align: 'right',
            width: 100,
            hidden:true,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=EC_Balance%></span>",
            dataIndex: 'ecBalenceIndex',
            align: 'right',
            width: 100,
            filter: {
                type: 'string'
            }
        },  {
            header: "<span style=font-weight:bold;>EC Used</span>",
            dataIndex: 'ecUsedIndex',
            align: 'right',
            width: 100,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=remarks%></span>",
            dataIndex: 'remarksInd',
            width: 100
        }, {
            header: "<span style=font-weight:bold;>Inserted Time</span>",
            dataIndex: 'insertedTimeInd',
            renderer: Ext.util.Format.dateRenderer(getDateTimeFormat()),
            filter: {
                type: 'date'
            }
         }, {
            header: "<span style=font-weight:bold;>Inserted By</span>",
            dataIndex: 'insertedByInd',
        },  {
             header: "<span style=font-weight:bold;>Updated Time</span>",
             dataIndex: 'updatedTimeInd',
             renderer: Ext.util.Format.dateRenderer(getDateTimeFormat()),
             filter: {
                 type: 'date'
             }
        }, {
            header: "<span style=font-weight:bold;>Updated By</span>",
            dataIndex: 'updatedByInd',
        },  {
            header: "<span style=font-weight:bold;>org Id</span>",
            dataIndex: 'orgIdDataIndex',
            hidden: true,
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

grid = getGrid('<%=Mine_Details%>', '<%=NoRecordsFound%>', store, screen.width - 40, 440, 24, filters, '<%=ClearFilterData%>', false, '', 25, false, '', false, '', true, '<%=Excel%>', jspName, exportDataType, false, 'PDF', true, '<%=Add%>', true, '<%=Modify%>', false, '<%=Delete%>');

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
       cm.setColumnWidth(j,130);
    }
    sb = Ext.getCmp('form-statusbar');
});
</script>
<jsp:include page="../Common/footer.jsp" />
 <!-- </body>   -->
 <!-- </html> -->
 <script> 
	  if (innerpage == true) {
				
				
				var divsToHide = document.getElementsByClassName("footer"); //divsToHide is an array
				
					for(var i = 0; i < divsToHide.length; i++){
						divsToHide[i].style.display = "none"; // depending on what you're doing
						$(".container").css({"margin-top":"-72px"});
					}
			}
			
			</script> 
<%}%>
<%}%>
