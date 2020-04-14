<%@ page  language="java" import="java.util.*,java.text.SimpleDateFormat,t4u.functions.*,t4u.beans.*,t4u.common.*" pageEncoding="utf-8"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://"+ request.getServerName() + ":" + request.getServerPort()+ path + "/";
	if(request.getParameter("list")!=null){
	String list=request.getParameter("list").toString().trim();
	String[] str=list.split(",");
	System.out.println("list contains:"+str.toString());
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
	tobeConverted.add("Customer_Details");
	tobeConverted.add("Customer_Details");
	tobeConverted.add("Account_Type");
	tobeConverted.add("First_Meeting_Date");	
	tobeConverted.add("ASM");
	tobeConverted.add("TSM");
	tobeConverted.add("Channel_Partner");
	tobeConverted.add("DST");
	tobeConverted.add("Visit_Type");
	tobeConverted.add("Company_Name");
	tobeConverted.add("Enter_Company_Name");
	tobeConverted.add("Company_Address");
	tobeConverted.add("Enter_Company_Address");
	tobeConverted.add("Account_Segment");
	tobeConverted.add("Customer_Name");
	tobeConverted.add("Enter_Customer_name");
	tobeConverted.add("Product_Type");
	tobeConverted.add("Account_Status");
	tobeConverted.add("Escalation_Email_Level_1");
	tobeConverted.add("Escalation_Email_Level_2");
	tobeConverted.add("Escalation_Email_Level_3");
	tobeConverted.add("Escalation_Email_Level_4");
	tobeConverted.add("Select_Customer");
	tobeConverted.add("Customer_Information");
	tobeConverted.add("No_Rows_Selected");
	tobeConverted.add("Select_Single_Row");
	tobeConverted.add("Modify");
	tobeConverted.add("Modify_Details");
	tobeConverted.add("Save");
	tobeConverted.add("Cancel");
	tobeConverted.add("No_Records_Found");
	tobeConverted.add("Clear_Filter_Data");
	tobeConverted.add("Excel");
	tobeConverted.add("Add");
	tobeConverted.add("SLNO");
	tobeConverted.add("Enter_LandLine_No");
	tobeConverted.add("Home");
	tobeConverted.add("Enter_Mobile_No");
	tobeConverted.add("Select_Visit_Type");
	tobeConverted.add("Select_Account_Segment");
	tobeConverted.add("Select_Customer_Status");
	tobeConverted.add("Select_Account_Status");
	tobeConverted.add("Mobile_No");
	tobeConverted.add("Landline_No");
	tobeConverted.add("Email");
	tobeConverted.add("Customer_Status");
	tobeConverted.add("Select_ASM");
	tobeConverted.add("Select_TSM");
	tobeConverted.add("Select_Channel_Partner");
	tobeConverted.add("Select_DST");
	tobeConverted.add("Select_Email_Id_For");
	tobeConverted.add("Select_Product_Type");
	tobeConverted.add("Select_Account_Type");
	tobeConverted.add("Enter_First_Meeting_Date");
	tobeConverted.add("Enter_LandLine_No");
	tobeConverted.add("Enter_Email_Id");
	tobeConverted.add("Validate_Mesg_For_Form");
	tobeConverted.add("Please_Enter_Amount_For_All_Selected_Products");
	tobeConverted.add("Delete");
	tobeConverted.add("Are_you_sure_you_want_to_delete");
	tobeConverted.add("No_Rows_Selected");
	tobeConverted.add("Error");
	tobeConverted.add("Not_Deleted");
	tobeConverted.add("Reconfigure_Grid");
	tobeConverted.add("User_Information");
	tobeConverted.add("View");

	HashMap langConverted=ApplicationListener.langConverted;
	LanguageWordsBean lwb=null;
	
	ArrayList<String> convertedWords = new ArrayList<String>();
	convertedWords = cf.getLanguageSpecificWordForKey(tobeConverted,language);
	 
	String AddCustomer=convertedWords.get(0);
	String CustomerDetails=convertedWords.get(1);
	String AccontType = convertedWords.get(2); 
	String FirstMeetingDate = convertedWords.get(3);  
	String EnterDate = convertedWords.get(53);
	String ASM = convertedWords.get(4);
	String TSM = convertedWords.get(5);
	String ChannelPartner = convertedWords.get(6);
	String DST =convertedWords.get(7);
	String VisitType = convertedWords.get(8);
	String AccountName = convertedWords.get(9);
	String EnterAccountName =convertedWords.get(10);
	String AccountAddress =convertedWords.get(11);
	String EnterAccountAddress=convertedWords.get(12);
	String AccountSegment=convertedWords.get(13);
	String CustomerName=convertedWords.get(14);
	String EnterCustomerName=convertedWords.get(15);
	String ProductType=convertedWords.get(16);
	String AccountStatus=convertedWords.get(17);
	String EscalationEmailLevel1=convertedWords.get(18);
	String EscalationEmailLevel2=convertedWords.get(19);
	String EscalationEmailLevel3=convertedWords.get(20);
	String EscalationEmailLevel4=convertedWords.get(21);
	String SelectCustomer=convertedWords.get(22);
	String CustomerInformation=convertedWords.get(23);
	String NoRowsSelected=convertedWords.get(24);
	String SelectSingleRow=convertedWords.get(25);
	String Modify=convertedWords.get(26);
	String ModifyDetails=convertedWords.get(27);
	String Save=convertedWords.get(28);
	String Cancel=convertedWords.get(29);
	String NoRecordsFound=convertedWords.get(30);
	String ClearFilterData=convertedWords.get(31);
	String Excel=convertedWords.get(32);
	String Add=convertedWords.get(33);
	String SLNO=convertedWords.get(34);
	String EnterLandlineNo=convertedWords.get(35);
	String Home=convertedWords.get(36);
	String EnterMobileNo=convertedWords.get(37);
	String SelectVisitType=convertedWords.get(38);
	String SelectAccountSegment=convertedWords.get(39);
	String SelectCustomerStatus=convertedWords.get(40);
	String SelectAccountStatus=convertedWords.get(41);
	String MobileNo=convertedWords.get(42);
	String LandlineNo=convertedWords.get(43);
	String Email=convertedWords.get(44);
	String CustomerStatus=convertedWords.get(45);
	String SelectASM=convertedWords.get(46);
	String SelectTSM=convertedWords.get(47);
	String SelectChannelPartner=convertedWords.get(48);
	String SelectDST=convertedWords.get(49);
	String SelectEmailId=convertedWords.get(50);
	String SelectProductType=convertedWords.get(51);
	String SelectAccountType=convertedWords.get(52);
	String EnterFirstMeetDate=convertedWords.get(53);
	String EnterLandlineNumber=convertedWords.get(54);
	String EnterEmailId=convertedWords.get(55);
	String ValidateMesgForForm=convertedWords.get(56);
	String EnterAmountError=convertedWords.get(57);
	String Delete=convertedWords.get(58);
	String AreYouSureWantToDelete=convertedWords.get(59);
	String NoRowSelected=convertedWords.get(60);
	String Error=convertedWords.get(61);
	String NotDeleted=convertedWords.get(62);
	String ReconfigureGrid=convertedWords.get(63);
	String UserInformation=convertedWords.get(64);
	String View=convertedWords.get(65);
%>

<jsp:include page="../Common/header.jsp" />   



    <title>
        <%=AddCustomer%>
    </title>

<style>
		.x-panel-bl, .x-panel-nofooter {
			height: 0px;
		}
		.x-panel-tl {
			border-bottom: 0px solid !important;
		}
		img#ext-gen68 {
			//height : 18px !important;
		}	
		.ext-strict .x-form-text {
			height: 21px  !important;
		}		
		label
		{
			display : inline !important;
		}
		div#myWin {
			top : 52px !important;
		}
		.x-window-tl *.x-window-header {
			height : 35px !important;
		}
		.x-layer ul {
			min-height: 27px !important;
		}
</style>


    <%if (loginInfo.getStyleSheetOverride().equals( "Y")){%>
        <jsp:include page="../Common/ImportJSSandMining.jsp" />
        <%}else{%>
            <jsp:include page="../Common/ImportJS.jsp" />
            <%}%>
                <jsp:include page="../Common/ExportJS.jsp" />
                <script>
var outerpanel;
var ctsb;
var jspName = "CustomerDetails";
var exportDataType = "";
var selected;      
var grid;
var buttonValue;
var titelForInnerPanel;
var myWin;
var amountLs;
var productLs;
var tobeDeleted;
var productsstr = "";
var asmModify;
var tsmModify;
var channelPartnerModify;
var dstModify;
var visitTypeModify;
var accountsegmentModify;
var accstatusModify;
var customerStatusModify;
var escalation1Modify;
var escalation2Modify;
var escalation3Modify;
var escalation4Modify;
var rows = "";
var SelectedRows;
var accnttype;

var asmstore = new Ext.data.JsonStore({
    url: '<%=request.getContextPath()%>/AddCustomerAction.do?param=getASM',
    id: 'asmStoreId',
    root: 'asmRoot',
    autoLoad: false,
    fields: ['asmName', 'asmId']
});

var asmcombo = new Ext.form.ComboBox({
    store: asmstore,
    id: 'asmcomboId',
    mode: 'local',
    hidden: false,
    forceSelection: true,
    emptyText: '<%=SelectASM%>',
    blankText: '<%=SelectASM%>',
    lazyRender: true,
    selectOnFocus: true,
    allowBlank: true,
    autoload: true,
    anyMatch: true,
    typeAhead: false,
    triggerAction: 'all',
    valueField: 'asmId',
    displayField: 'asmName',
    cls: 'selectstylePerfect',
    listeners: {
        select: {
            fn: function() {}
        }
    }
});

var tsmcombo = new Ext.form.ComboBox({
    store: asmstore,
    id: 'tsmcomboId',
    mode: 'local',
    hidden: false,
    forceSelection: true,
    emptyText: '<%=SelectTSM%>',
    blankText: '<%=SelectTSM%>',
    lazyRender: true,
    selectOnFocus: true,
    allowBlank: true,
    autoload: true,
    anyMatch: true,
    typeAhead: false,
    triggerAction: 'all',
    valueField: 'asmId',
    displayField: 'asmName',
    cls: 'selectstylePerfect',
    listeners: {
        select: {
            fn: function() {}
        }
    }
});

var channelpartnercombo = new Ext.form.ComboBox({
    store: asmstore,
    id: 'channelpartnercomboId',
    mode: 'local',
    hidden: false,
    forceSelection: true,
    emptyText: '<%=SelectChannelPartner%>',
    blankText: '<%=SelectChannelPartner%>',
    lazyRender: true,
    selectOnFocus: true,
    allowBlank: true,
    autoload: true,
    anyMatch: true,
    typeAhead: false,
    triggerAction: 'all',
    valueField: 'asmId',
    displayField: 'asmName',
    cls: 'selectstylePerfect',
    listeners: {
        select: {
            fn: function() {}
        }
    }
});

var dstcombo = new Ext.form.ComboBox({
    store: asmstore,
    id: 'dstcomboId',
    mode: 'local',
    hidden: false,
    forceSelection: true,
    emptyText: '<%=SelectDST%>',
    blankText: '<%=SelectDST%>',
    lazyRender: true,
    selectOnFocus: true,
    allowBlank: true,
    autoload: true,
    anyMatch: true,
    typeAhead: false,
    triggerAction: 'all',
    valueField: 'asmId',
    displayField: 'asmName',
    cls: 'selectstylePerfect',
    listeners: {
        select: {
            fn: function() {}
        }
    }
});

var emailstore = new Ext.data.JsonStore({
    url: '<%=request.getContextPath()%>/AddCustomerAction.do?param=getEmail',
    id: 'emailStoreId',
    root: 'emailRoot',
    autoLoad: false,
    fields: ['emailName', 'emailId']
});

var productTypeStore = new Ext.data.JsonStore({
    id: 'productTypeStoreId',
    url: '<%=request.getContextPath()%>/AddCustomerAction.do?param=getProducts',
    root: 'productRoot',
    autoLoad: false,
    fields: ['productId', 'productName', 'num'],
    listeners: {
        load: function() {
            if (buttonValue == '<%=Modify%>') {
                var i = 0;
                var k = 0;
                var selected = grid.getSelectionModel().getSelected();
                var productIds = selected.get('productsDataIndex');
                var amountChng = selected.get('amountsDataIndex');
                amountLs = amountChng.split(",");
                productLs = productIds.split(",");
                productTypeStore.each(function(rec) {
                    i = 0;
                    for (; i < productLs.length; i++) {
                        if (rec.get('productId') == productLs[i]) {
                            productypecheckbox.getSelectionModel().selectRow(k, true);
                            rec.set('num', amountLs[i]);
                        }
                    }
                    k++;
                });
            }
        }
    }
});

var visitTypeStore = new Ext.data.SimpleStore({
    id: 'visitTypeStoreId',
    autoLoad: true,
    fields: ['visitTypeName'],
    data: [['New Customer'],['Existing Customer'],['New Channel Partner'],['Existing channel partner']],
    listeners: {}
});

var escalation1combo = new Ext.form.ComboBox({
    store: emailstore,
    id: 'escalation1comboId',
    mode: 'local',
    hidden: false,
    forceSelection: true,
    emptyText: '<%=SelectEmailId%> <%=EscalationEmailLevel1%>',
    blankText: '<%=SelectEmailId%> <%=EscalationEmailLevel1%>',
    lazyRender: true,
    selectOnFocus: true,
    allowBlank: true,
    autoload: true,
    anyMatch: true,
    typeAhead: false,
    triggerAction: 'all',
    valueField: 'emailId',
    displayField: 'emailName',
    cls: 'selectstylePerfect',
    listeners: {
        select: {
            fn: function() {}
        }
    }
});

var escalation2combo = new Ext.form.ComboBox({
    store: emailstore,
    id: 'escalation2comboId',
    mode: 'local',
    hidden: false,
    forceSelection: true,
    emptyText: '<%=SelectEmailId%> <%=EscalationEmailLevel2%>',
    blankText: '<%=SelectEmailId%> <%=EscalationEmailLevel2%>',
    lazyRender: true,
    selectOnFocus: true,
    allowBlank: true,
    autoload: true,
    anyMatch: true,
    typeAhead: false,
    triggerAction: 'all',
    valueField: 'emailId',
    displayField: 'emailName',
    cls: 'selectstylePerfect',
    listeners: {
        select: {
            fn: function() {}
        }
    }
});

var escalation3combo = new Ext.form.ComboBox({
    store: emailstore,
    id: 'escalation3comboId',
    mode: 'local',
    hidden: false,
    forceSelection: true,
    emptyText: '<%=SelectEmailId%> <%=EscalationEmailLevel3%>',
    blankText: '<%=SelectEmailId%> <%=EscalationEmailLevel3%>',
    lazyRender: true,
    selectOnFocus: true,
    allowBlank: true,
    autoload: true,
    anyMatch: true,
    typeAhead: false,
    triggerAction: 'all',
    valueField: 'emailId',
    displayField: 'emailName',
    cls: 'selectstylePerfect',
    listeners: {
        select: {
            fn: function() {}
        }
    }
});

var escalation4combo = new Ext.form.ComboBox({
    store: emailstore,
    id: 'escalation4comboId',
    mode: 'local',
    hidden: false,
    forceSelection: true,
    emptyText: '<%=SelectEmailId%> <%=EscalationEmailLevel4%>',
    blankText: '<%=SelectEmailId%> <%=EscalationEmailLevel4%>',
    lazyRender: true,
    selectOnFocus: true,
    allowBlank: true,
    autoload: true,
    anyMatch: true,
    typeAhead: false,
    triggerAction: 'all',
    valueField: 'emailId',
    displayField: 'emailName',
    cls: 'selectstylePerfect',
    listeners: {
        select: {
            fn: function() {}
        }
    }
});

var visittypecombo = new Ext.form.ComboBox({
    store: visitTypeStore,
    id: 'visittypecomboId',
    mode: 'local',
    hidden: false,
    forceSelection: true,
    emptyText: '<%=SelectVisitType%>',
    blankText: '<%=SelectVisitType%>',
    lazyRender: true,
    selectOnFocus: true,
    allowBlank: true,
    autoload: true,
    anyMatch: true,
    typeAhead: false,
    triggerAction: 'all',
    valueField: 'visitTypeName',
    displayField: 'visitTypeName',
    cls: 'selectstylePerfect',
    listeners: {
        select: {
            fn: function() {}
        }
    }
});

var accountSegmentStore = new Ext.data.SimpleStore({
    id: 'accountSegmentStoreId',
    autoLoad: true,
    fields: ['accountSegmentName'],
    data: [['Retail'],['SME'],['EBU'],['NEB']],
    listeners: {}
});

var accountsegmentcombo = new Ext.form.ComboBox({
    store: accountSegmentStore,
    id: 'accountsegmentcomboId',
    mode: 'local',
    hidden: false,
    forceSelection: true,
    emptyText: '<%=SelectAccountSegment%>',
    blankText: '<%=SelectAccountSegment%>',
    lazyRender: true,
    selectOnFocus: true,
    allowBlank: true,
    autoload: true,
    anyMatch: true,
    typeAhead: false,
    triggerAction: 'all',
    valueField: 'accountSegmentName',
    displayField: 'accountSegmentName',
    cls: 'selectstylePerfect',
    listeners: {
        select: {
            fn: function() {}
        }
    }
});

var accountStatusStore = new Ext.data.SimpleStore({
    id: 'accountStatusStoreId',
    autoLoad: true,
    fields: ['accountStatusName'],
    data: [['Hot'],['Warm'],['Cold'],['Closed']],
    listeners: {}
});

var accountstatuscombo = new Ext.form.ComboBox({
    store: accountStatusStore,
    id: 'accountstatuscomboId',
    mode: 'local',
    hidden: false,
    forceSelection: true,
    emptyText: '<%=SelectAccountStatus%>',
    blankText: '<%=SelectAccountStatus%>',
    lazyRender: true,
    selectOnFocus: true,
    allowBlank: true,
    autoload: true,
    anyMatch: true,
    typeAhead: false,
    triggerAction: 'all',
    valueField: 'accountStatusName',
    displayField: 'accountStatusName',
    cls: 'selectstylePerfect', 
    listeners: {
        select: {
            fn: function() {}
        }
    }
});
var customerStatusStore = new Ext.data.SimpleStore({
    id: 'customerStatusStoreId',
    autoLoad: true,
    fields: ['customerStatusName'],
    data: [['Active'],['Inactive']],
    listeners: {}
});

var customerstatuscombo = new Ext.form.ComboBox({
    store: customerStatusStore,
    id: 'customerstatuscomboId',
    mode: 'local',
    hidden: false,
    forceSelection: true,
    emptyText: '<%=SelectCustomerStatus%>',
    blankText: '<%=SelectCustomerStatus%>',
    lazyRender: true,
    selectOnFocus: true,
    allowBlank: true,
    autoload: true,
    anyMatch: true,
    typeAhead: false,
    triggerAction: 'all',
    valueField: 'customerStatusName',
    displayField: 'customerStatusName',
    cls: 'selectstylePerfect',
    listeners: {
        select: {
            fn: function() {}
        }
    }
});

var sm = new Ext.grid.CheckboxSelectionModel({
    checkOnly: true,
    mode: 'MULTISELECT',
    listeners: {
        rowselect: function(selectionModel, rowIndex, record) {
            selectedRows = selectionModel.getSelections();
            if (selectedRows.length > 0) {
                rows = rows + "," + rowIndex;
            }
        },
        rowdeselect: function(selectionModel, rowIndex, record) {       
            rows=rows.replace(rowIndex,"");
            record.set('num', "");
        }
    }
});
        
var cm = new Ext.grid.ColumnModel([
    sm, {
        header: 'Select All Products',
        dataIndex: 'productName',
        width: 170,
        sortable: true
    }, {
        header: 'Amount',
        dataIndex: 'num',
        width: 50,
        sortable: true,
        editor: new Ext.grid.GridEditor(new Ext.form.NumberField()),
        editable: true
    }
]);

var productypecheckbox = new Ext.grid.EditorGridPanel({
    id: 'productypecheckboxId',
    store: productTypeStore,
    sm: sm,
    cm: cm,
    clicksToEdit:1,
    stripeRows: true,
    border: true,
    frame: false,
    width: 265,
    height: 160,
    cls: 'bskExtStyle',
    listeners: {
        beforeedit: function(e) {
            var field = e.field;
            rIndex = productypecheckbox.getStore().indexOf(e.record);
            if (rows.indexOf(rIndex) > -1) {
                return true;
            }
            return false;
        }
    }
});

var embeddedColumns = new Ext.Panel({  
	standardSubmit: true,
	collapsible: false,
	layout: 'column',
	columns:2,
	width:170,	
	items: [{xtype:'radio',boxLabel: 'IOIP',name: 'rb',id:'radio1',width:70,height:24},			
			{xtype:'radio',boxLabel: 'COCP',name: 'rb',id:'radio2',width:70}]	 
});

var innerPanelForCustomerDetails = new Ext.form.FormPanel({
    standardSubmit: true,
    collapsible: false,
    autoScroll: true,
    height: 410,
    width: 530,
    frame: true,
    id: 'innerPanelForCustomerDetailsId',
    layout: 'table',
    layoutConfig: {
        columns: 4
    },
    items: [{
        xtype: 'fieldset',
        title: '<%=CustomerDetails%>',
        cls: 'fieldsetpanel',
        collapsible: false,
        autoScroll:false,
        colspan: 3,
        id: 'CustomerDetailsId',
        width: 500,
        layout: 'table',
        layoutConfig: {
            columns: 4
        },
        items: [{ xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'accountTypeEmptyId1'                      
        },{
            xtype: 'label',
            text: '<%=AccontType%>' + ' :',
            cls: 'labelstyle',
            id: 'accountTypeLabelId'            
        }, embeddedColumns ,{ 		       
        }, {
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'firstMeetEmptyId1'
        }, {
            xtype: 'label',
            text: '<%=FirstMeetingDate%>' + ' :',   
            cls: 'labelstyle',
            id: 'firstMeetLabelId'
        }, {
            xtype: 'datefield',
            cls: 'selectstylePerfect',
            emptyText: '<%=EnterDate%>',
            emptyText: '<%=EnterDate%>',
            format: getDateFormat(),
            width: 50,
            id: 'firstMeetDateId',
        }, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'firstMeetEmptyId2'
        },{
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'asmEmptyId1'
        }, {
            xtype: 'label',
            text: '<%=ASM%>' + ' :',
            cls: 'labelstyle',
            id: 'asmLabelId'
        },  asmcombo, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'asmId2'
        }, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'tsmEmptyId1'
        },{
            xtype: 'label',
            text: '<%=TSM%>' + ' :',
            cls: 'labelstyle',
            id: 'tsmLabelId'
        },  tsmcombo, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'tsmEmptyId2'
        }, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'channelPartnerEmptyId1'
        },{
            xtype: 'label',
            text: '<%=ChannelPartner%>' + ' :',
            cls: 'labelstyle',
            id: 'channelPartnerLabelId'
        },  channelpartnercombo, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'channelPartnerEmptyId2'
        },{
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'dstEmptyId1'
        },  {
            xtype: 'label',
            text: '<%=DST%>' + ' :',
            cls: 'labelstyle',
            id: 'dstLabelId'
        }, dstcombo, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'dstEmptyId2'
        },{
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'visitTypeEmptyId1'
        }, {
            xtype: 'label',
            text: '<%=VisitType%>' + ' :',
            cls: 'labelstyle',
            id: 'visitTypeLabelId'
        },  visittypecombo, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'visitTypeEmptyId2'
        },{
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'accNameEmptyId1'
        }, {
            xtype: 'label',
            text: '<%=AccountName%>' + ' :',
            cls: 'labelstyle',
            id: 'accNameLabelId'
        },  {
            xtype: 'textfield',
            cls: 'selectstylePerfect',
            blankText: '<%=EnterAccountName%>',
            emptyText: '<%=EnterAccountName%>',
            id: 'accountNameId',
            regex: validate('alphanumericname')
        }, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'accountNameId2'
        },{
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'accountAddressEmptyId1'
        },  {
            xtype: 'label',
            text: '<%=AccountAddress%>' + ' :',
            cls: 'labelstyle',
            id: 'accountAddressLabelId'
        }, {
            xtype: 'textarea',
            cls: 'selectstylePerfect',
            blankText: '<%=EnterAccountAddress%>',
            emptyText: '<%=EnterAccountAddress%>',
            id: 'accountAddressId'
        }, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'accountAddressEmptyId2'
        },{
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'accsegmentEmptyId1'
        }, {
            xtype: 'label',
            text: '<%=AccountSegment%>' + ' :',
            cls: 'labelstyle',
            id: 'accsegmentLabelId'
        },  accountsegmentcombo, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'accsegmentEmptyId2'
        }, {
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'customerNameEmptyId1'
        },{
            xtype: 'label',
            text: '<%=CustomerName%>' + ' :',
            cls: 'labelstyle',
            id: 'customerNameLabelId'
        },  {
            xtype: 'textfield',
            cls: 'selectstylePerfect',
            blankText: '<%=EnterCustomerName%>',
            emptyText: '<%=EnterCustomerName%>',
            id: 'customerNameId',
            regex: validate('alphanumericname')
        }, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'customerNameEmptyId2'
        }, {
            xtype: 'fieldset',
            title: '<%=UserInformation%>',
            autoHeight: true,
            width: 475,
            colspan: 3,
            layout: 'table',
            layoutConfig: {
                columns: 4
            },
            collapsed: false,
            items: [{
                xtype: 'label',
                text: '*',
                cls: 'mandatoryfield',
                id: 'mobileNoLabelEmptyId1'
            }, {
                xtype: 'label',
                text: '<%=MobileNo%>' + ' :',
                cls: 'labelstyle',
                id: 'mobileNoLabelId'
            }, {
                xtype: 'textfield',
                maskRe:/\d/,
                cls: 'selectstylePerfect',
                blankText: '<%=EnterMobileNo%>',
                emptyText: '<%=EnterMobileNo%>',
                id: 'mobileNoId'
            }, {
                xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                id: 'mobileNoLabelEmptyId2'
            },{
                xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                id: 'landLineLabelEmptyId1'
            }, {
                xtype: 'label',
                text: '<%=LandlineNo%>' + ' :',
                cls: 'labelstyle',
                id: 'landLineLabelId'
            },  {
                xtype: 'textfield',
                maskRe:/\d/,
                cls: 'selectstylePerfect',
                blankText: '<%=EnterLandlineNo%>',
                emptyText: '<%=EnterLandlineNo%>',
                id: 'landLineNoId'
            }, {
                xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                id: 'landLineLabelEmptyId2'
            },{
                xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                id: 'emailLabelEmptyId1'
            }, {
                xtype: 'label',
                text: '<%=Email%>' + ' :',
                cls: 'labelstyle',
                id: 'emailLabelId'
            },  {
                xtype: 'textfield',
                cls: 'selectstylePerfect',
                blankText: '<%=EnterEmailId%>',
                emptyText: '<%=EnterEmailId%>',
                id: 'emailId',
                vtype:'email'
            }, {
                xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                id: 'emailLabelEmptyId2'
            }]
        }, {
            width: 20
        }, {
            xtype: 'fieldset',
            title: '<%=ProductType%>',
            autoHeight: true,
            width: 475,
            colspan: 3,
            layout: 'table',
            layoutConfig: {
                columns: 4
            },
            items: [{
                xtype: 'label',
                text: '*',
                cls: 'mandatoryfield',
                id: 'productTypeEmptyId1'
            }, {
                xtype: 'label',
                text: '<%=ProductType%>' + ' :',
                cls: 'labelstyle',
                id: 'productTypeLabelId'
            }, productypecheckbox, {
                xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                id: 'productTypeEmptyId2'
            }]
        }, {
            width: 20
        },  {
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'accountStatusEmptyId1'
        },{
            xtype: 'label',
            text: '<%=AccountStatus%>' + ' :',
            cls: 'labelstyle',
            id: 'accountStatusLabelId'
        }, accountstatuscombo, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'accountStatusEmptyId2'
        },{
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'customerStatusEmptyId1'
        }, {
            xtype: 'label',
            text: '<%=CustomerStatus%>' + ' :',
            cls: 'labelstyle',
            id: 'customerStatusLabelId'
        },  customerstatuscombo, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'customerStatusEmptyId2'
        }, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'escalation1EmptyId1'
        }, {
            xtype: 'label',
            text: '<%=EscalationEmailLevel1%>' + ' :',
            cls: 'labelstyle',
            id: 'escalation1LabelId'
        }, escalation1combo, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'escalation1EmptyId2'
        },{
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'escalation2EmptyId1'
        }, {
            xtype: 'label',
            text: '<%=EscalationEmailLevel2%>' + ' :',
            cls: 'labelstyle',
            id: 'escalation2LabelId'
        },  escalation2combo, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'escalation2EmptyId2'
        }, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'escalation3EmptyId1'
        },{
            xtype: 'label',
            text: '<%=EscalationEmailLevel3%>' + ' :',
            cls: 'labelstyle',
            id: 'escalation3LabelId'
        },  escalation3combo, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'escalation3EmptyId2'
        },{
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'escalation4EmptyId1'
        }, {
            xtype: 'label',
            text: '<%=EscalationEmailLevel4%>' + ' :',
            cls: 'labelstyle',
            id: 'escalation4LabelId'
        },  escalation4combo, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'escalation4EmptyId2'
        }]
    }]
});

var innerWinButtonPanel = new Ext.Panel({
    id: 'innerWinButtonPanelId',
    standardSubmit: true,
    collapsible: false,
    autoHeight: true,
    height: 40,
    width: 530,
    frame: false,
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
                    if (Ext.getCmp('customercomboId').getValue() == "") {
                        Ext.example.msg("<%=SelectCustomer%>");
                        Ext.getCmp('customercomboId').focus();
                        return;
                    }
                    if (Ext.getCmp('radio1').getValue() == false && Ext.getCmp('radio2').getValue() == false) {
                        Ext.example.msg("<%=SelectAccountType%>");
                        return;
                    }
                    if(Ext.getCmp('radio1').getValue() == true) {
                    	accnttype=1;
                    } else{
                    	accnttype=2;
                    }
                    
                    if (Ext.getCmp('firstMeetDateId').getValue() == "") {
                        Ext.example.msg("<%=EnterFirstMeetDate%>");
                        Ext.getCmp('firstMeetDateId').focus();
                        return;
                    }                  
                    if (Ext.getCmp('visittypecomboId').getValue() == "") {
                        Ext.example.msg("<%=SelectVisitType%>");
                        Ext.getCmp('visittypecomboId').focus();
                        return;
                    }
                    if (Ext.getCmp('accountNameId').getValue() == "") {
                        Ext.example.msg("<%=EnterAccountName%>");
                        Ext.getCmp('accountNameId').focus();
                        return;
                    }
                    if (Ext.getCmp('accountsegmentcomboId').getValue() == "") {
                        Ext.example.msg("<%=SelectAccountSegment%>");
                        Ext.getCmp('accountsegmentcomboId').focus();
                        return;
                    }
                    if (Ext.getCmp('customerNameId').getValue() == "") {
                        Ext.example.msg("<%=EnterCustomerName%>");
                        Ext.getCmp('customerNameId').focus();
                        return;
                    }
                    if (Ext.getCmp('mobileNoId').getValue() == "") {
                        Ext.example.msg("<%=EnterMobileNo%>");
                        Ext.getCmp('mobileNoId').focus();
                        return;
                    }
                    var selectedProducts;
                    var selectedAmounts = "-";
                    selectedProducts = "-";
                    var recordProducts = productypecheckbox.getSelectionModel().getSelections();
                    for (var i = 0; i < recordProducts.length; i++) {
                        var recordEach = recordProducts[i];
                        var productId = recordEach.data['productId'];
                        var amount = recordEach.data['num'];
                        if (amount == '' ||amount == '-') {
                            Ext.example.msg("<%=EnterAmountError%>");
	                        return;
                        }
                        if (selectedProducts == "-") {
                            selectedProducts = productId;
                            selectedAmounts = amount;
                        } else {
                            selectedProducts = selectedProducts + "," + productId;
                            selectedAmounts = selectedAmounts + "," + amount;
                        }
                    }
                    if (selectedProducts == '' || selectedProducts == '0' || selectedProducts == '-') {
                        Ext.example.msg("<%=SelectProductType%>");
                        return;
                    }
                    if (Ext.getCmp('accountstatuscomboId').getValue() == "") {
                        Ext.example.msg("<%=SelectAccountStatus%>");
                        Ext.getCmp('accountstatuscomboId').focus();
                        return;
                    }
                    if (Ext.getCmp('customerstatuscomboId').getValue() == "") {
                        Ext.example.msg("<%=SelectCustomerStatus%>");
                        Ext.getCmp('customerstatuscomboId').focus();
                        return;
                    }
                    var selected = grid.getSelectionModel().getSelected();
                    var record, Id, refId = 0;
                    if (buttonValue == 'Modify') {
                        if (selected.get('asmIndex') != Ext.getCmp('asmcomboId').getRawValue()) {
                            asmModify = Ext.getCmp('asmcomboId').getRawValue();
                        } else {
                            asmModify=selected.get('asmIndex'); 
                        }
                        if (selected.get('tsmIndex') != Ext.getCmp('tsmcomboId').getRawValue()) {
                            tsmModify = Ext.getCmp('tsmcomboId').getRawValue();
                        } else {
                             tsmModify=selected.get('tsmIndex');
                        }
                        if (selected.get('channelPartnerIndex') != Ext.getCmp('channelpartnercomboId').getRawValue()) {
                            channelPartnerModify = Ext.getCmp('channelpartnercomboId').getRawValue();
                        } else {
                            channelPartnerModify=selected.get('channelPartnerIndex');
                            
                        }
                        if (selected.get('dstIndex') != Ext.getCmp('dstcomboId').getRawValue()) {
                            dstModify = Ext.getCmp('dstcomboId').getRawValue();
                        } else {
                           dstModify = selected.get('dstIndex');
                           
                        }
                        if (selected.get('visitTypeIndex') != Ext.getCmp('visittypecomboId').getValue()) {
                            visitTypeModify = Ext.getCmp('visittypecomboId').getValue();
                        } else {
                            visitTypeModify = selected.get('visitTypeIndex');
                        }
                        if (selected.get('accSegmentIndex') != Ext.getCmp('accountsegmentcomboId').getValue()) {
                            accountsegmentModify = Ext.getCmp('accountsegmentcomboId').getValue();
                        } else {
                            accountsegmentModify = selected.get('accSegmentIndex');
                        }
                        if (selected.get('accStatusIndex') != Ext.getCmp('accountstatuscomboId').getValue()) {
                            accstatusModify = Ext.getCmp('accountstatuscomboId').getValue();
                        } else {
                            accstatusModify = selected.get('accStatusIndex');
                        }
                        if (selected.get('customerStatusIndex') != Ext.getCmp('customerstatuscomboId').getValue()) {
                            customerStatusModify = Ext.getCmp('customerstatuscomboId').getValue();
                        } else {
                            customerStatusModify = selected.get('customerStatusIndex');
                        }
                        if (selected.get('esclvl1Index') != Ext.getCmp('escalation1comboId').getRawValue()) {
                            escalation1Modify = Ext.getCmp('escalation1comboId').getRawValue();
                        } else {
                            escalation1Modify=selected.get('esclvl1Index');
                          
                        }
                        if (selected.get('esclvl2Index') != Ext.getCmp('escalation2comboId').getValue()) {
                            escalation2Modify = Ext.getCmp('escalation2comboId').getRawValue();
                        } else {
                           escalation2Modify=selected.get('esclvl2Index');
                         
                        }
                        if (selected.get('esclvl3Index') != Ext.getCmp('escalation3comboId').getRawValue()) {
                            escalation3Modify = Ext.getCmp('escalation3comboId').getRawValue();
                        } else {
                            escalation3Modify=selected.get('esclvl3Index');
                            
                        }
                        if (selected.get('esclvl4Index') != Ext.getCmp('escalation4comboId').getRawValue()) {
                            escalation4Modify = Ext.getCmp('escalation4comboId').getRawValue();
                        } else {
                             escalation4Modify=selected.get('esclvl4Index');
                          
                        }
                        refId = selected.get('uniqueIdDataIndex');
                    }
                     
                    if (innerPanelForCustomerDetails.getForm().isValid()) {
                        addCustomerOuterPanelWindow.getEl().mask();
                        Ext.Ajax.request({
                            url: '<%=request.getContextPath()%>/AddCustomerAction.do?param=customerAddAndModify',
                            method: 'POST',
                            params: {
                                buttonValue: buttonValue,
                                custId: Ext.getCmp('customercomboId').getValue(),
                                accountType: accnttype,
                                firstMeetDate: Ext.getCmp('firstMeetDateId').getValue(),
                                asm: Ext.getCmp('asmcomboId').getRawValue(),
                                tsm: Ext.getCmp('tsmcomboId').getRawValue(),
                                channelpartner: Ext.getCmp('channelpartnercomboId').getRawValue(),
                                dst: Ext.getCmp('dstcomboId').getRawValue(),
                                visittype: Ext.getCmp('visittypecomboId').getValue(),
                                accountName: Ext.getCmp('accountNameId').getValue(),
                                accountsegment: Ext.getCmp('accountsegmentcomboId').getValue(),
                                customerName: Ext.getCmp('customerNameId').getValue(),
                                mobileNo: Ext.getCmp('mobileNoId').getValue(),
                                landLineNo: Ext.getCmp('landLineNoId').getValue(),
                                emailId: Ext.getCmp('emailId').getValue(),
                                accountstatus: Ext.getCmp('accountstatuscomboId').getValue(),
                                customerstatus: Ext.getCmp('customerstatuscomboId').getValue(),
                                escalation1: Ext.getCmp('escalation1comboId').getRawValue(),
                                escalation2: Ext.getCmp('escalation2comboId').getRawValue(),
                                escalation3: Ext.getCmp('escalation3comboId').getRawValue(),
                                escalation4: Ext.getCmp('escalation4comboId').getRawValue(),
                                products: selectedProducts,
                                amounts: selectedAmounts,
                                accAddress: Ext.getCmp('accountAddressId').getValue(),
                                asmModify: asmModify,
                                tsmModify: tsmModify,
                                channelPartnerModify: channelPartnerModify,
                                dstModify: dstModify,
                                visitTypeModify: visitTypeModify,
                                accountsegmentModify: accountsegmentModify,
                                accstatusModify: accstatusModify,
                                customerstatusModify: customerStatusModify,
                                escalation1Modify: escalation1Modify,
                                escalation2Modify: escalation2Modify,
                                escalation3Modify: escalation3Modify,
                                escalation4Modify: escalation4Modify,
                                refId: refId
                            },
                            success: function(response, options) {
                                var message = response.responseText;
                                Ext.example.msg(message);
                                myWin.hide();
                                addCustomerOuterPanelWindow.getEl().unmask();
                                store.load({
                                    params: {
                                        custId: Ext.getCmp('customercomboId').getValue()
                                    }
                                });
                               	productypecheckbox.getSelectionModel().clearSelections(); 
                                Ext.getCmp('firstMeetDateId').reset();
                                Ext.getCmp('asmcomboId').reset();
                                Ext.getCmp('tsmcomboId').reset();
                                Ext.getCmp('channelpartnercomboId').reset();
                                Ext.getCmp('dstcomboId').reset();
                                Ext.getCmp('visittypecomboId').reset();
                                Ext.getCmp('accountNameId').reset();
                                Ext.getCmp('accountAddressId').reset();
                                Ext.getCmp('accountsegmentcomboId').reset();
                                Ext.getCmp('customerNameId').reset();
                                Ext.getCmp('mobileNoId').reset();
                                Ext.getCmp('landLineNoId').reset();
                                Ext.getCmp('emailId').reset();
                                Ext.getCmp('accountstatuscomboId').reset();
                                Ext.getCmp('customerstatuscomboId').reset();
                                Ext.getCmp('escalation1comboId').reset();
                                Ext.getCmp('escalation2comboId').reset();
                                Ext.getCmp('escalation3comboId').reset();
                                Ext.getCmp('escalation4comboId').reset();
                            },
                            failure: function() {
                                Ext.example.msg("Error");
                                store.reload();
                                myWin.hide();
                            }
                        });
                    } else {
                        Ext.example.msg("<%=ValidateMesgForForm%>");
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
                	productypecheckbox.getSelectionModel().clearSelections();                	                   	
                    myWin.hide();
                }
            }
        }
    }]
});

var addCustomerOuterPanelWindow = new Ext.Panel({
    width: 540,
    height: 485,
    standardSubmit: true,
    frame: true,
    items: [innerPanelForCustomerDetails, innerWinButtonPanel]
});

myWin = new Ext.Window({
    title: titelForInnerPanel,
    closable: false,
    resizable: false,
    modal: true,
    autoScroll: false,
    height: 500,
    width: 545,
    id: 'myWin',
    items: [addCustomerOuterPanelWindow]
});

function addRecord() {
    if (Ext.getCmp('customercomboId').getValue() == "") {
        Ext.example.msg("<%=SelectCustomer%>");
        Ext.getCmp('customercomboId').focus();
        return;
    }
    buttonValue = '<%=Add%>';
    productTypeStore.load({
        params: {
            custId: Ext.getCmp('customercomboId').getValue()
        }
    });      
    Ext.getCmp('firstMeetDateId').setValue("");
    Ext.getCmp('asmcomboId').setValue("");
    Ext.getCmp('tsmcomboId').setValue("");
    Ext.getCmp('channelpartnercomboId').setValue("");
    Ext.getCmp('dstcomboId').setValue("");
    Ext.getCmp('visittypecomboId').setValue("");
    Ext.getCmp('accountNameId').setValue("");
    Ext.getCmp('accountAddressId').setValue("");
    Ext.getCmp('accountsegmentcomboId').setValue("");
    Ext.getCmp('customerNameId').setValue("");
    Ext.getCmp('mobileNoId').setValue("");
    Ext.getCmp('landLineNoId').setValue("");
    Ext.getCmp('emailId').setValue("");
    Ext.getCmp('accountstatuscomboId').setValue("");
    Ext.getCmp('customerstatuscomboId').setValue("Active");
    Ext.getCmp('escalation1comboId').setValue("");
    Ext.getCmp('escalation2comboId').setValue("");
    Ext.getCmp('escalation3comboId').setValue("");
    Ext.getCmp('escalation4comboId').setValue("");
    Ext.getCmp('radio1').setValue(true);
    titelForInnerPanel = '<%=CustomerInformation%>';
    myWin.setPosition(450, 25);
    myWin.show();
    myWin.setTitle(titelForInnerPanel);
}

function modifyData() {
    if (Ext.getCmp('customercomboId').getValue() == "") {
        Ext.example.msg("<%=SelectCustomer%>");
        Ext.getCmp('customercomboId').focus();
        return;
    }
    if (grid.getSelectionModel().getCount() == 0) {
        Ext.example.msg("<%=NoRowSelected%>");
        return;
    }
    if (grid.getSelectionModel().getCount() > 1) {
        Ext.example.msg("<%=SelectSingleRow%>");
        return;
    }
    buttonValue = '<%=Modify%>';
    titelForInnerPanel = '<%=ModifyDetails%>';
    var selected = grid.getSelectionModel().getSelected();
    Ext.getCmp('asmcomboId').show();
    Ext.getCmp('tsmcomboId').show();
    Ext.getCmp('channelpartnercomboId').show();
    Ext.getCmp('dstcomboId').show();
    Ext.getCmp('visittypecomboId').show()
    Ext.getCmp('accountNameId').show();
    Ext.getCmp('accountAddressId').show();
    Ext.getCmp('accountsegmentcomboId').show();
    Ext.getCmp('customerNameId').show();
    Ext.getCmp('mobileNoId').show();
    Ext.getCmp('landLineNoId').show();
    Ext.getCmp('emailId').show();
    Ext.getCmp('accountstatuscomboId').show();
    Ext.getCmp('customerstatuscomboId').show();
    Ext.getCmp('escalation1comboId').show();
    Ext.getCmp('escalation2comboId').show();
    Ext.getCmp('escalation3comboId').show();
    Ext.getCmp('escalation4comboId').show();
    Ext.getCmp('asmcomboId').setValue(selected.get('asmIndex'));
    Ext.getCmp('tsmcomboId').setValue(selected.get('tsmIndex'));
    Ext.getCmp('channelpartnercomboId').setValue(selected.get('channelPartnerIndex'));
    Ext.getCmp('dstcomboId').setValue(selected.get('dstIndex'));
    Ext.getCmp('visittypecomboId').setValue(selected.get('visitTypeIndex'));
    Ext.getCmp('firstMeetDateId').setValue(selected.get('firstMeetIndex'));
    Ext.getCmp('accountNameId').setValue(selected.get('accNameIndex'));
    Ext.getCmp('accountAddressId').setValue(selected.get('accAddressIndex'));
    Ext.getCmp('accountsegmentcomboId').setValue(selected.get('accSegmentIndex'));
    Ext.getCmp('customerNameId').setValue(selected.get('customerNameIndex'));
    Ext.getCmp('mobileNoId').setValue(selected.get('mobileNoIndex'));
    Ext.getCmp('landLineNoId').setValue(selected.get('landNoIndex'));
    Ext.getCmp('emailId').setValue(selected.get('emailIndex'));
    Ext.getCmp('accountstatuscomboId').setValue(selected.get('accStatusIndex'));
    Ext.getCmp('customerstatuscomboId').setValue(selected.get('customerStatusIndex'));
    Ext.getCmp('escalation1comboId').setValue(selected.get('esclvl1Index'));
    Ext.getCmp('escalation2comboId').setValue(selected.get('esclvl2Index'));
    Ext.getCmp('escalation3comboId').setValue(selected.get('esclvl3Index'));
    Ext.getCmp('escalation4comboId').setValue(selected.get('esclvl4Index'));
    
    if(selected.get('accountTypeIndex')=="IOIP") 
    	Ext.getCmp('radio1').setValue(true);
    else
  		Ext.getCmp('radio2').setValue(true);
   
    productTypeStore.load({
        params: {
            custId: Ext.getCmp('customercomboId').getValue()
        }
    });
    myWin.setPosition(450, 25);
    myWin.show();
    myWin.setTitle(titelForInnerPanel);
}

function deleteData() {
    if (Ext.getCmp('customercomboId').getValue() == "") {
        Ext.example.msg("<%=SelectCustomer%>");
        Ext.getCmp('customercomboId').focus();
        return;
    }
    if (grid.getSelectionModel().getCount() == 0) {
        Ext.example.msg("<%=NoRowSelected%>");
        return;
    }
    if (grid.getSelectionModel().getCount() > 1) {
        Ext.example.msg("<%=SelectSingleRow%>");
        return;
    }
    Ext.Msg.show({
        title: '<%=Delete%>',
        msg: '<%=AreYouSureWantToDelete%>',
        buttons: {
            yes: true,
            no: true
        },
        fn: function(btn) {
            switch (btn) {
                case 'yes':
                    var selected = grid.getSelectionModel().getSelected();
                    outerPanel.getEl().mask();
                    Ext.Ajax.request({
                        url: '<%=request.getContextPath()%>/AddCustomerAction.do?param=deleteData',
                        method: 'POST',
                        params: {
                            custId: Ext.getCmp('customercomboId').getValue(),
                            refId: selected.get('uniqueIdDataIndex')
                        },
                        success: function(response, options) {
                            var message = response.responseText;
                            Ext.example.msg(message);
                            outerPanel.getEl().unmask();
                            store.load({
                                params: {
                                    custId: Ext.getCmp('customercomboId').getValue()
                                }
                            });
                        },
                        failure: function() {
                            Ext.example.msg("<%=Error%>");
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
    idProperty: 'stockYardid',
    root: 'customerRoot',
    totalProperty: 'total',
    fields: [{
        name: 'slnoIndex',
        type: 'int'
    }, {
        name: 'uniqueIdDataIndex',
        type: 'int'
    }, {
        name: 'accountTypeIndex',
        type: 'string'
    }, {
        name: 'firstMeetIndex',
        type: 'date',
        format: getDateFormat()
    }, {
        name: 'asmIndex',
        type: 'string'
    }, {
        name: 'tsmIndex',
        type: 'string'
    }, {
        name: 'channelPartnerIndex',
        type: 'string'
    }, {
        name: 'dstIndex',
        type: 'string'
    }, {
        name: 'visitTypeIndex',
        type: 'string'
    }, {
        name: 'accNameIndex',
        type: 'string'
    }, {
        name: 'accAddressIndex',
        type: 'string'
    }, {
        name: 'accSegmentIndex',
        type: 'string'
    }, {
        name: 'customerNameIndex',
        type: 'string'
    }, {
        name: 'landNoIndex',
        type: 'string'
    }, {
        name: 'mobileNoIndex',
        type: 'string'
    }, {
        name: 'emailIndex',
        type: 'string'
    }, {
        name: 'accStatusIndex',
        type: 'string'
    }, {
        name: 'customerStatusIndex',
        type: 'string'
    }, {
        name: 'esclvl1Index',
        type: 'string'
    }, {
        name: 'esclvl2Index',
        type: 'string'
    }, {
        name: 'esclvl3Index',
        type: 'string'
    }, {
        name: 'esclvl4Index',
        type: 'string'
    }, , {
        name: 'productsDataIndex',
        type: 'string'
    }, , {
        name: 'amountsDataIndex',
        type: 'string'
    }]
});

var store = new Ext.data.GroupingStore({
    autoLoad: false,
    proxy: new Ext.data.HttpProxy({
        url: '<%=request.getContextPath()%>/AddCustomerAction.do?param=getCustomerDetails',
        method: 'POST'
    }),
    storeId: 'storeId',
    reader: reader
});

var filters = new Ext.ux.grid.GridFilters({
    local: true,
    filters: [{
        type: 'numeric',
        dataIndex: 'slnoIndex'
    }, {
        dataIndex: 'uniqueIdDataIndex',
        type: 'numeric'
    }, {
        dataIndex: 'accountTypeIndex',
        type: 'string'
    }, {
        dataIndex: 'firstMeetIndex',
        type: 'date'
    }, {
        dataIndex: 'asmIndex',
        type: 'string'
    }, {
        dataIndex: 'tsmIndex',
        type: 'string'
    }, {
        dataIndex: 'channelPartnerIndex',
        type: 'string'
    }, {
        dataIndex: 'dstIndex',
        type: 'string'
    }, {
        dataIndex: 'visitTypeIndex',
        type: 'string'
    }, {
        dataIndex: 'accNameIndex',
        type: 'string'
    }, {
        dataIndex: 'accAddressIndex',
        type: 'string'
    }, {
        dataIndex: 'accSegmentIndex',
        type: 'string'
    }, {
        dataIndex: 'customerNameIndex',
        type: 'string'
    }, {
        dataIndex: 'landNoIndex',
        type: 'string'
    }, {
        dataIndex: 'mobileNoIndex',
        type: 'string'
    }, {
        dataIndex: 'emailIndex',
        type: 'string'
    }, {
        dataIndex: 'accStatusIndex',
        type: 'string'
    }, {
        dataIndex: 'customerStatusIndex',
        type: 'string'
    }, {
        dataIndex: 'esclvl1Index',
        type: 'string'
    }, {
        dataIndex: 'esclvl2Index',
        type: 'string'
    }, {
        dataIndex: 'esclvl3Index',
        type: 'string'
    }, {
        dataIndex: 'esclvl4Index',
        type: 'string'
    }, , {
        dataIndex: 'productsDataIndex',
        type: 'string'
    }, , {
        dataIndex: 'amountsDataIndex',
        type: 'string'
    }]
});

var createColModel = function(finish, start) {
    var columns = [
        new Ext.grid.RowNumberer({
            header: "<span style=font-weight:bold;><%=SLNO%></span>",
            width: 50
        }), {
            dataIndex: 'slnoIndex',
            header: "<span style=font-weight:bold;><%=SLNO%></span>",
            hidden: true,
            filter: {
                type: 'numeric'
            }
        },
        {
            dataIndex: 'accountTypeIndex',
            header: "<span style=font-weight:bold;><%=AccontType%></span>",
            width: 120,
            filter: {
                type: 'string'
            }
        }, {
            dataIndex: 'firstMeetIndex',
            header: "<span style=font-weight:bold;><%=FirstMeetingDate%></span>",
            width: 150,
            renderer: Ext.util.Format.dateRenderer(getDateFormat()),
            filter: {
                type: 'date'
            }
        }, {
            dataIndex: 'asmIndex',
            header: "<span style=font-weight:bold;><%=ASM%></span>",
            width: 150,
            filter: {
                type: 'string'
            }
        }, {
            dataIndex: 'tsmIndex',
            header: "<span style=font-weight:bold;><%=TSM%></span>",
            width: 150,
            filter: {
                type: 'string'
            }
        }, {
            dataIndex: 'channelPartnerIndex',
            header: "<span style=font-weight:bold;><%=ChannelPartner%></span>",
            width: 150,
            filter: {
                type: 'string'
            }
        }, {
            dataIndex: 'dstIndex',
            header: "<span style=font-weight:bold;><%=DST%></span>",
            width: 150,
            filter: {
                type: 'string'
            }
        }, {
            dataIndex: 'visitTypeIndex',
            header: "<span style=font-weight:bold;><%=VisitType%></span>",
            width: 150,
            filter: {
                type: 'string'
            }
        }, {
            dataIndex: 'accNameIndex',
            header: "<span style=font-weight:bold;><%=AccountName%></span>",
            width: 150,
            filter: {
                type: 'string'
            }
        }, {
            dataIndex: 'accAddressIndex',
            header: "<span style=font-weight:bold;><%=AccountAddress%></span>",
            width: 200,
            filter: {
                type: 'string'
            }
        }, {
            dataIndex: 'accSegmentIndex',
            header: "<span style=font-weight:bold;><%=AccountSegment%></span>",
            width: 150,
            filter: {
                type: 'string'
            }
        }, {
            dataIndex: 'customerNameIndex',
            header: "<span style=font-weight:bold;><%=CustomerName%></span>",
            width: 150,
            filter: {
                type: 'string'
            }
        }, {
            dataIndex: 'landNoIndex',
            width: 170,
            header: "<span style=font-weight:bold;><%=LandlineNo%></span>",
            filter: {
                type: 'string'
            }
        }, {
            dataIndex: 'mobileNoIndex',
            width: 170,
            header: "<span style=font-weight:bold;><%=MobileNo%></span>",
            filter: {
                type: 'string'
            }
        }, {
            dataIndex: 'emailIndex',
            width: 220,
            header: "<span style=font-weight:bold;><%=Email%></span>",
            filter: {
                type: 'string'
            }
        }, {
            dataIndex: 'accStatusIndex',
            width: 150,
            header: "<span style=font-weight:bold;><%=AccountStatus%></span>",
            filter: {
                type: 'string'
            }
        }, {
            dataIndex: 'customerStatusIndex',
            header: "<span style=font-weight:bold;><%=CustomerStatus%></span>",
            width: 150,
            filter: {
                type: 'string'
            }
        }, {
            dataIndex: 'esclvl1Index',
            header: "<span style=font-weight:bold;><%=EscalationEmailLevel1%></span>",
            width: 220,
            filter: {
                type: 'string'
            }
        }, {
            dataIndex: 'esclvl2Index',
            header: "<span style=font-weight:bold;><%=EscalationEmailLevel2%></span>",
            width: 220,
            filter: {
                type: 'string'
            }
        }, {
            dataIndex: 'esclvl3Index',
            header: "<span style=font-weight:bold;><%=EscalationEmailLevel3%></span>",
            width: 220,
            filter: {
                type: 'string'
            }
        }, {
            dataIndex: 'esclvl4Index',
            header: "<span style=font-weight:bold;><%=EscalationEmailLevel4%></span>",
            width: 220,
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
grid = getGrid('<%=CustomerDetails%>', '<%=NoRecordsFound%>', store, screen.width - 40, 440, 22, filters, '<%=ClearFilterData%>', true,' <%=ReconfigureGrid%>', 22, false, '', false, '', false, '<%=Excel%>', jspName, exportDataType, false, 'PDF', true, '<%=Add%>', true, '<%=Modify%>/<%=View%>', true, '<%=Delete%>');
//******************************************************************************************************************************************************

var customerstore = new Ext.data.JsonStore({
    url: '<%=request.getContextPath()%>/CommonAction.do?param=getCustomer', 
    id: 'CustomerStoreId',
    root: 'CustomerRoot',
    autoLoad: true,
    remoteSort: true,
    fields: ['CustId', 'CustName'],
    listeners: {
        load: function(custstore, records, success, options) {
            if ( <%= customerId %> > 0) {
                Ext.getCmp('customercomboId').setValue('<%=customerId%>');
                custId = Ext.getCmp('customercomboId').getValue();
            }
            store.load({
                 params: {
                     custId: Ext.getCmp('customercomboId').getValue()
                 }
            });
            asmstore.load({
                params: {
                    custId: Ext.getCmp('customercomboId').getValue()
                }
            });
            productTypeStore.load({
                params: {
                    custId: Ext.getCmp('customercomboId').getValue()
                }
            });
            emailstore.load({
                params: {
                    custId: Ext.getCmp('customercomboId').getValue()
                }
            });

        }
    }
});

var custcombo = new Ext.form.ComboBox({
    store: customerstore,
    id: 'customercomboId',
    mode: 'local',
    forceSelection: true,
    emptyText: '<%=SelectCustomer%>',
    blankText: '<%=SelectCustomer%>',
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
                store.load({
                    params: {
                        custId: Ext.getCmp('customercomboId').getValue()
                    }
                });
                asmstore.load({
                    params: {
                        custId: Ext.getCmp('customercomboId').getValue()
                    }
                });
                productTypeStore.load({
                    params: {
                        custId: Ext.getCmp('customercomboId').getValue()
                    }
                });
                emailstore.load({
                    params: {
                        custId: Ext.getCmp('customercomboId').getValue()
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
            text: '<%=SelectCustomer%>' + ' :',
            cls: 'labelstyle'
        },
        custcombo
    ]
});

Ext.onReady(function() {
    ctsb = tsb;
    Ext.QuickTips.init();
    Ext.form.Field.prototype.msgTarget = 'side';
    outerPanel = new Ext.Panel({
        title: '<%=CustomerInformation%>',
        renderTo: 'content',
        standardSubmit: true,
        autoscroll: true,
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

    
    
    
    
    

