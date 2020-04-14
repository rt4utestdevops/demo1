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
	tobeConverted.add("Customer_Appointment");
	tobeConverted.add("Add");
	tobeConverted.add("Modify");
	tobeConverted.add("Select_Customer");
	tobeConverted.add("Select_Supervisor");
	tobeConverted.add("Select_Employee");
	tobeConverted.add("Appointment_Details");
	tobeConverted.add("Customer");
	tobeConverted.add("Supervisor");
	tobeConverted.add("Employee");
	tobeConverted.add("Follow_Up_Date");
	tobeConverted.add("Appointment_Time");
	tobeConverted.add("Enter_Appointment_Time");
	tobeConverted.add("Select_Follow_Up_Date");
	tobeConverted.add("Remarks");
	tobeConverted.add("Enter_Remarks");
	tobeConverted.add("Delete");
	tobeConverted.add("Customer_Appointment_Information");
	tobeConverted.add("No_Records_Found");
	tobeConverted.add("Select_Single_Row");
	tobeConverted.add("No_Rows_Selected");
	tobeConverted.add("Modify_Details");
	tobeConverted.add("Save");
	tobeConverted.add("Validate_Mesg_For_Form");
	tobeConverted.add("Cancel");
	tobeConverted.add("SLNO");
	tobeConverted.add("Clear_Filter_Data");
	tobeConverted.add("Are_you_sure_you_want_to_delete"); 
	tobeConverted.add("Not_Deleted");
	tobeConverted.add("Error");
	tobeConverted.add("Location");
	tobeConverted.add("Last_Updated_Time");
	tobeConverted.add("Status");
	tobeConverted.add("Select_Status");
	tobeConverted.add("Follow_Up_Date_Must_Be_Greater_Than_Or_Equal_To_Appointment_Time");
	tobeConverted.add("Schedule_Appointment");
	tobeConverted.add("Start_Date");
	tobeConverted.add("End_Date");
	tobeConverted.add("Select_Start_Date");
	tobeConverted.add("Select_End_Date");
	tobeConverted.add("Month_Validation");
	tobeConverted.add("View");
	tobeConverted.add("start_Date_End_Date_Validation");
	tobeConverted.add("Employee_User");
	tobeConverted.add("Select_Employee_User");
	HashMap langConverted=ApplicationListener.langConverted;
	LanguageWordsBean lwb=null;
	
	ArrayList<String> convertedWords = new ArrayList<String>();
	convertedWords = cf.getLanguageSpecificWordForKey(tobeConverted,language);
	 
	 String CustomerAppointment=convertedWords.get(0);
	 String Add=convertedWords.get(1);
	 String Modify=convertedWords.get(2);
	 String SelectCustomer=convertedWords.get(3);
	 String SelectSupervisor=convertedWords.get(4);
	 String SelectEmployee=convertedWords.get(5);
	 String AppointmentDetails=convertedWords.get(6);
	 String Customer=convertedWords.get(7);
	 String Supervisor=convertedWords.get(8);
	 String Employee=convertedWords.get(9);
	 String FollowUpDate=convertedWords.get(10);
	 String AppointmentTime=convertedWords.get(11);
	 String EnterAppointmentTime=convertedWords.get(12);
	 String SelectFollowUpDate=convertedWords.get(13);
	 String Remarks=convertedWords.get(14);
	 String EnterRemarks=convertedWords.get(15);
	 String Delete=convertedWords.get(16);
	 String CustomerAppointmentInformation=convertedWords.get(17);
	 String NoRecordsFound=convertedWords.get(18);
	 String SelectSingleRow=convertedWords.get(19);
	 String NoRowSelected=convertedWords.get(20);
	 String ModifyDetails=convertedWords.get(21);
	 String Save=convertedWords.get(22);
	 String ValidateMesgForForm=convertedWords.get(23);
	 String Cancel=convertedWords.get(24);
	 String SLNO=convertedWords.get(25);
	 String ClearFilterData=convertedWords.get(26);
	 String AreYouSureWantToDelete=convertedWords.get(27);
	 String NotDeleted=convertedWords.get(28);
	 String Error=convertedWords.get(29);
	 String Location=convertedWords.get(30);
	 String LastUpdatedTime=convertedWords.get(31);
	 String Status=convertedWords.get(32);
	 String SelectStatus=convertedWords.get(33);
	 String DateError=convertedWords.get(34);
	 String ScheduleAppointment=convertedWords.get(35);
	 String StartDate=convertedWords.get(36);
	 String EndDate=convertedWords.get(37);
	 String SelectStartDate=convertedWords.get(38);
	 String SelectEndDate=convertedWords.get(39);
	 String monthValidation=convertedWords.get(40);
	 String View=convertedWords.get(41);
	 String dateValidation=convertedWords.get(42);
	 String EmployeeUser=convertedWords.get(43);
	 String SelectEmployeeUser=convertedWords.get(44); 
%>

<jsp:include page="../Common/header.jsp" /> 


    <title>
        <%=ScheduleAppointment%>
    </title>
<style>
.x-panel-bl, .x-panel-nofooter {
    height: 0px;
}
.x-panel-tl {
    border-bottom: 0px solid !important;
}
		label
		{
			display : inline !important;
		}
		.ext-strict .x-form-text {
			height: 21px !important;
		}
		.x-window-tl *.x-window-header {			
			height : 38px !important;
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
var jspName = "FFM Customer Appointment";
var exportDataType = "";
var selected;      
var grid;
var buttonValue;
var titelForInnerPanel;
var myWin;
var tobeDeleted;
var SelectedRows;
var uniqueId="";
var custNameModify="";
var supervisorModify="";
var employeeModify="";
var statusModify="";
var empUserModify="";

var statusstore = new Ext.data.SimpleStore({
    id: 'statusStoreId',
    autoLoad: true,
    fields: ['statusName', 'statusId'],
    data: [
        ['Pending', '0'],['Completed','1']
    ]
});

var statuscombo = new Ext.form.ComboBox({
    store: statusstore,
    id: 'statuscomboId',
    mode: 'local',
    hidden: false,
    forceSelection: true,
    emptyText: '<%=SelectStatus%>',
    blankText: '<%=SelectStatus%>',
    lazyRender: true,
    selectOnFocus: true,
    allowBlank: true,
    autoload: true,
    anyMatch: true,
    typeAhead: false,
    triggerAction: 'all',
    valueField: 'statusId',
    displayField: 'statusName',
    cls: 'selectstylePerfect',
    listeners: {
        select: {
            fn: function() {}
        }
    }
});

var ffmcustomerstore = new Ext.data.JsonStore({
    url: '<%=request.getContextPath()%>/FFMCustomerAppointmentAction.do?param=getCustomerForAppt',
    id: 'ffmcustomerStoreId',
    root: 'ffmcustomerRoot',
    autoLoad: false,
    fields: ['ffmcustomerName', 'ffmcustomerId']
});

var ffmcustomercombo = new Ext.form.ComboBox({
    store: ffmcustomerstore,
    id: 'ffmcustomercomboId',
    mode: 'local',
    hidden: false,
    forceSelection: true,
    emptyText: '<%=SelectCustomer%>',
    blankText: '<%=SelectCustomer%>',
    lazyRender: true,
    selectOnFocus: true,
    allowBlank: true,
    autoload: true,
    anyMatch: true,
    typeAhead: false,
    triggerAction: 'all',
    valueField: 'ffmcustomerId',
    displayField: 'ffmcustomerName',
    cls: 'selectstylePerfect',
    listeners: {
        select: {
            fn: function() {}
        }
    }
});

var supervisorstore = new Ext.data.JsonStore({
    url: '<%=request.getContextPath()%>/FFMCustomerAppointmentAction.do?param=getSupervisor',
    id: 'supervisorStoreId',
    root: 'supervisorRoot',
    autoLoad: false,
    fields: ['supervisorName','supervisorId']
});

var supervisorcombo = new Ext.form.ComboBox({
    store: supervisorstore,
    id: 'supervisorcomboId',
    mode: 'local',
    hidden: false,
    forceSelection: true,
    emptyText: '<%=SelectSupervisor%>',
    blankText: '<%=SelectSupervisor%>',
    lazyRender: true,
    selectOnFocus: true,
    allowBlank: true,
    autoload: true,
    anyMatch: true,
    typeAhead: false,
    triggerAction: 'all',
    valueField: 'supervisorId',
    displayField: 'supervisorName',
    cls: 'selectstylePerfect',
    listeners: {
        select: {
            fn: function() {}
        }
    }
});

var empuserstore = new Ext.data.JsonStore({
    url: '<%=request.getContextPath()%>/FFMCustomerAppointmentAction.do?param=getSupervisor',
    id: 'empuserStoreId',
    root: 'supervisorRoot',
    autoLoad: false,
    fields: ['supervisorName','supervisorId']
});

var empusercombo = new Ext.form.ComboBox({
    store: empuserstore,
    id: 'empusercomboId',
    mode: 'local',
    hidden: false,
    forceSelection: true,
    emptyText: '<%=SelectEmployeeUser%>',
    blankText: '<%=SelectEmployeeUser%>',
    lazyRender: true,
    selectOnFocus: true,
    allowBlank: true,
    autoload: true,
    anyMatch: true,
    typeAhead: false,
    triggerAction: 'all',
    valueField: 'supervisorId',
    displayField: 'supervisorName',
    cls: 'selectstylePerfect',
    listeners: {
        select: {
            fn: function() {}
        }
    }
});

var employeestore = new Ext.data.JsonStore({
    url: '<%=request.getContextPath()%>/FFMCustomerAppointmentAction.do?param=getEmployees',
    id: 'employeeStoreId',
    root: 'employeeRoot',
    autoLoad: false,
    fields: ['employeeName']
});

var employeecombo = new Ext.form.ComboBox({
    store: employeestore,
    id: 'employeecomboId',
    mode: 'local',
    hidden: false,
    forceSelection: true,
    emptyText: '<%=SelectEmployee%>',
    blankText: '<%=SelectEmployee%>',
    lazyRender: true,
    selectOnFocus: true,
    allowBlank: true,
    autoload: true,
    anyMatch: true,
    typeAhead: false,
    triggerAction: 'all',
    valueField: 'employeeName',
    displayField: 'employeeName',
    cls: 'selectstylePerfect',
    listeners: {
        select: {
            fn: function() {}
        }
    }
});

var innerPanelForCustomerDetails = new Ext.form.FormPanel({
    standardSubmit: true,
    collapsible: false,
    autoScroll: true,
    height: 210,
    width: 410,
    frame: true,
    id: 'innerPanelForCustomerDetailsId',
    layout: 'table',
    layoutConfig: {
        columns: 4
    },
    items: [{
        xtype: 'fieldset',
        title: '<%=AppointmentDetails%>',
        cls: 'fieldsetpanel',
        collapsible: false,
        autoScroll:false,
        colspan: 3,
        id: 'CustomerDetailsId',
        width: 380,
        layout: 'table',
        layoutConfig: {
            columns: 4
        },
        items: [{ xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'customerEmptyId1'                      
        },{
            xtype: 'label',
            text: '<%=Customer%>' + ' :',
            cls: 'labelstyle',
            id: 'customerLabelId'            
        }, ffmcustomercombo ,{
         	xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'customerEmptyId2'	       
        },{
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'supervisorEmptyId1'
        },{
            xtype: 'label',
            text: '<%=Supervisor%>' + ' :',   
            cls: 'labelstyle',
            id: 'supervisorLabelId'
        }, supervisorcombo ,{
         	xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'supervisorEmptyId2'	       
        }, {
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'employeeEmptyId1'
        },{
            xtype: 'label',
            text: '<%=Employee%>' + ' :',   
            cls: 'labelstyle',
            id: 'employeeLabelId'
        }, employeecombo ,{
         	xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'employeeEmptyId2'	       
        }, {
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'empUserEmptyId1'
        },{
            xtype: 'label',
            text: '<%=EmployeeUser%>' + ' :',   
            cls: 'labelstyle',
            id: 'empUserLabelId'
        }, empusercombo ,{
         	xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'empUserEmptyId2'	       
        },{
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'appointTimeEmptyId1'
        },{
            xtype: 'label',
            text: '<%=AppointmentTime%>' + ' :',
            cls: 'labelstyle',
            id: 'appointmentTimeLabelId'
        }, {
            xtype: 'datefield',
            cls: 'selectstylePerfect',
            emptyText: '<%=EnterAppointmentTime%>',
            emptyText: '<%=EnterAppointmentTime%>',
            format: getDateTimeFormat(),
            width: 50,
            id: 'appointmentTimeId'
        }, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'appointmentTimeEmptyId2'
        },{
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'remarksEmptyId1'
        }, {
            xtype: 'label',
            text: '<%=Remarks%>' + ' :',
            cls: 'labelstyle',
            id: 'remarksLabelId'
        }, {
            xtype: 'textfield',
            cls: 'selectstylePerfect',           
            blankText: '<%=EnterRemarks%>',
            emptyText: '<%=EnterRemarks%>',
            id: 'remarksId'
        }, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'remarksEmptyId2'
        },  {
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'followUpDateEmptyId1'
        },{
            xtype: 'label',
            text: '<%=FollowUpDate%>' + ' :',
            cls: 'labelstyle',
            id: 'followUpDateLabelId'
        }, {
            xtype: 'datefield',
            cls: 'selectstylePerfect',
            emptyText: '<%=SelectFollowUpDate%>',
            emptyText: '<%=SelectFollowUpDate%>',
            format: getDateFormat(),
            width: 50,
            id: 'followUpDateId'
        }, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'followUpDateEmptyId2'
        },{
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'statusId1'
        },{
            xtype: 'label',
            text: '<%=Status%>' + ' :',
            cls: 'labelstyle',
            id: 'statusLabelId'
        },statuscombo ,{
         	xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'statusId2'	       
        }]        
        }]
  });

var innerWinButtonPanel = new Ext.Panel({
    id: 'innerWinButtonPanelId',
    standardSubmit: true,
    collapsible: false,
    autoHeight: true,
    height: 40,
    width: 410,
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
                    if (Ext.getCmp('ffmcustomercomboId').getValue() == "") {
                        Ext.example.msg("<%=SelectCustomer%>");
                        Ext.getCmp('ffmcustomercomboId').focus();
                        return;
                    }                                        
                    if (Ext.getCmp('supervisorcomboId').getValue() == "") {
                        Ext.example.msg("<%=SelectSupervisor%>");
                        Ext.getCmp('supervisorcomboId').focus();
                        return;
                    }
                    if (Ext.getCmp('empusercomboId').getValue() == "") {
                        Ext.example.msg("<%=SelectEmployeeUser%>");
                        Ext.getCmp('empusercomboId').focus();
                        return;
                    }                  
                    if (Ext.getCmp('employeecomboId').getValue() == "") {
                        Ext.example.msg("<%=SelectEmployee%>");
                        Ext.getCmp('employeecomboId').focus();
                        return;
                    }
                    if (Ext.getCmp('appointmentTimeId').getValue() == "") {
                        Ext.example.msg("<%=EnterAppointmentTime%>");
                        Ext.getCmp('appointmentTimeId').focus();
                        return;
                    }                  
                    if (Ext.getCmp('followUpDateId').getValue() == "") {
                        Ext.example.msg("<%=SelectFollowUpDate%>");
                        Ext.getCmp('followUpDateId').focus();
                        return;
                    }
                    if (Ext.getCmp('statuscomboId').getValue() == "") {
                        Ext.example.msg("<%=SelectStatus%>");
                        Ext.getCmp('statuscomboId').focus();
                        return;
                    }               
                	var dateresult= DateCompare2(Ext.getCmp('followUpDateId').getValue().format('d/m/Y'),Ext.getCmp('appointmentTimeId').getValue().format('d/m/Y'));
                    if(dateresult){
                        Ext.example.msg("<%=DateError%>");
                        return;
                    }
                    			
                    var selected = grid.getSelectionModel().getSelected();                 
                    if (buttonValue == 'Modify') {
                    	uniqueId=selected.get('uniqueIdDataIndex');
                       if (selected.get('customerIndex') != Ext.getCmp('ffmcustomercomboId').getValue()) {
                            custNameModify = Ext.getCmp('ffmcustomercomboId').getValue();
                        } else {
                            custNameModify=selected.get('customerIndex');
                            var index = ffmcustomerstore.findExact('ffmcustomerName', selected.get('customerIndex'));                
                    		var record = ffmcustomerstore.getAt(index);               
                            custNameModify=record.data['ffmcustomerId'];  
                        }
                        if (selected.get('supervisorIndex') != Ext.getCmp('supervisorcomboId').getValue()) {
                            supervisorModify = Ext.getCmp('supervisorcomboId').getValue();
                        } else {
                        	var index = supervisorstore.findExact('supervisorName', selected.get('supervisorIndex'));                
                    		var record = supervisorstore.getAt(index);               
                            supervisorModify=record.data['supervisorId']; 
                        }
                        
                        if (selected.get('employeeIndex') != Ext.getCmp('employeecomboId').getValue()) {
                            employeeModify = Ext.getCmp('employeecomboId').getValue();
                        } else {
                            employeeModify=selected.get('employeeIndex'); 
                        }
                        if (selected.get('empuserIndex') != Ext.getCmp('empusercomboId').getValue()) {
                            empUserModify = Ext.getCmp('empusercomboId').getValue();
                        } else {
                        	var index = empuserstore.findExact('supervisorName', selected.get('empuserIndex'));                
                    		var record = empuserstore.getAt(index);               
                            empUserModify=record.data['supervisorId']; 
                        }
                        if (selected.get('statusIndex') != Ext.getCmp('statuscomboId').getValue()) {
                            statusModify = Ext.getCmp('statuscomboId').getValue();
                        } else {
                        	var index = statusstore.findExact('statusName', selected.get('statusIndex'));                
                    		var record = statusstore.getAt(index);               
                            statusModify=record.data['statusId']; 
                        } 
                    }
                     
                    if (innerPanelForCustomerDetails.getForm().isValid()) {
                        addCustomerOuterPanelWindow.getEl().mask();
                        Ext.Ajax.request({
                            url: '<%=request.getContextPath()%>/FFMCustomerAppointmentAction.do?param=appointmentAddAndModify',
                            method: 'POST',
                            params: {
                                buttonValue: buttonValue,
                                custId:Ext.getCmp('customercomboId').getValue(),
                                custName: Ext.getCmp('ffmcustomercomboId').getValue(),
                                supervisor: Ext.getCmp('supervisorcomboId').getValue(),
                             	employee:Ext.getCmp('employeecomboId').getValue(),
                             	appointmentTime:Ext.getCmp('appointmentTimeId').getValue(),
                             	remark:Ext.getCmp('remarksId').getValue(),
                             	followUpDate:Ext.getCmp('followUpDateId').getValue(),
                             	status:Ext.getCmp('statuscomboId').getValue(),
                             	empUser:Ext.getCmp('empusercomboId').getValue(),
                             	uniqueId:uniqueId,
                             	custNameModify:custNameModify,
                             	supervisorModify:supervisorModify,
                             	employeeModify:employeeModify,
                             	statusModify:statusModify,
                             	empUserModify: empUserModify
                            },
                            success: function(response, options) {
                                var message = response.responseText;
                                Ext.example.msg(message);
                                myWin.hide();
                                addCustomerOuterPanelWindow.getEl().unmask();
                                store.reload();                                                           	
                                Ext.getCmp('ffmcustomercomboId').reset();
                                Ext.getCmp('supervisorcomboId').reset();
                                Ext.getCmp('employeecomboId').reset();
                                Ext.getCmp('appointmentTimeId').reset();
                                Ext.getCmp('remarksId').reset();
                                Ext.getCmp('followUpDateId').reset();                               
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
                    myWin.hide();
                }
            }
        }
    }]
});

var addCustomerOuterPanelWindow = new Ext.Panel({
    width: 420,
    height: 295,
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
    height: 300,
    width: 425,
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
	Ext.getCmp('ffmcustomercomboId').setValue("");
    Ext.getCmp('supervisorcomboId').setValue("");
    Ext.getCmp('employeecomboId').setValue("");
    Ext.getCmp('empusercomboId').setValue("");
    Ext.getCmp('appointmentTimeId').setValue("");
    Ext.getCmp('remarksId').setValue("");
    Ext.getCmp('followUpDateId').setValue(""); 
    Ext.getCmp('statuscomboId').setValue("0");
    Ext.getCmp('statuscomboId').disable();  
    titelForInnerPanel = '<%=CustomerAppointmentInformation%>';
    myWin.setPosition(450, 125);
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
	Ext.getCmp('customercomboId').show();
	Ext.getCmp('ffmcustomercomboId').show();
    Ext.getCmp('supervisorcomboId').show();
    Ext.getCmp('employeecomboId').show();
    Ext.getCmp('appointmentTimeId').show();
    Ext.getCmp('remarksId').show();
    Ext.getCmp('followUpDateId').show();
    Ext.getCmp('ffmcustomercomboId').setValue(selected.get('customerIndex'));
    Ext.getCmp('supervisorcomboId').setValue(selected.get('supervisorIndex'));
    Ext.getCmp('employeecomboId').setValue(selected.get('employeeIndex'));
    Ext.getCmp('empusercomboId').setValue(selected.get('empuserIndex'));
    Ext.getCmp('appointmentTimeId').setValue(selected.get('appointmentTimeIndex'));
    Ext.getCmp('remarksId').setValue(selected.get('remarksIndex'));
    Ext.getCmp('followUpDateId').setValue(selected.get('followUpDateIndex'));
    Ext.getCmp('statuscomboId').setValue(selected.get('statusIndex'));
    Ext.getCmp('statuscomboId').disable();
    myWin.setPosition(450, 125);
    myWin.show();
    myWin.setTitle(titelForInnerPanel);
}

function deleteData() {
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
                        url: '<%=request.getContextPath()%>/FFMCustomerAppointmentAction.do?param=deleteAppointmentData',
                        method: 'POST',
                        params: {
                        	custId: Ext.getCmp('customercomboId').getValue(),                          
                            uniqueId: selected.get('uniqueIdDataIndex')
                        },
                        success: function(response, options) {
                            var message = response.responseText;
                            Ext.example.msg(message);
                            outerPanel.getEl().unmask();
                            store.reload();
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

function DateCompare2 (startDate, endDate)   {	   
	 var startddindex = startDate.indexOf('/');
	 var startdd = startDate.substring(0,startddindex);
	 var startmmindex = startDate.lastIndexOf('/');
	 var startmm = startDate.substring(startddindex+1,startmmindex);
	 var startyear = startDate.substring(startmmindex+1,startDate.length);
	 
	 var endddindex = endDate.indexOf('/');
	 var enddd = endDate.substring(0,endddindex);
	 var endmmindex = endDate.lastIndexOf('/');
	 var endmm = endDate.substring(endddindex+1,endmmindex);
	 var endyear = endDate.substring(endmmindex+1,endDate.length);
	 
	 var date1=new Date(startmm+"/"+startdd+"/"+startyear);
	 var date2=new Date(endmm+"/"+enddd+"/"+endyear); 		
	if (date1 < date2){
	 	return true;
	}else {
	 	return false;
	}		
};

var reader = new Ext.data.JsonReader({
    idProperty: 'appointmetDetailsId',
    root: 'appointmentRoot',
    totalProperty: 'total',
    fields: [{
        name: 'slnoIndex',
        type: 'int'
    }, {
        name: 'uniqueIdDataIndex',
        type: 'int'
    }, {
        name: 'customerIndex',
        type: 'string'
    }, {
        name: 'supervisorIndex',
        type: 'string'
    }, {
        name: 'employeeIndex',
        type: 'string'
    },{
        name: 'empuserIndex',
        type: 'string'
    }, {
        name: 'appointmentTimeIndex',
        type: 'date',
        format: getDateTimeFormat()
    }, {
        name: 'remarksIndex',
        type: 'string'
    }, {
        name: 'followUpDateIndex',
        type: 'date',
        format: getDateFormat()
    }, {
        name: 'locationIndex',
        type: 'string'
    }, {
        name: 'lastUpdatedTimeIndex',
        type: 'date',
        format: getDateTimeFormat()
    }, {
        name: 'statusIndex',
        type: 'string'
    }]
});

var store = new Ext.data.GroupingStore({
    autoLoad: true,
    proxy: new Ext.data.HttpProxy({
        url: '<%=request.getContextPath()%>/FFMCustomerAppointmentAction.do?param=getAppointmentDetails',
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
        dataIndex: 'customerIndex',
        type: 'string'
    }, {
        dataIndex: 'supervisorIndex',
        type: 'string'
    }, {
        dataIndex: 'employeeIndex',
        type: 'string'
    }, {
        dataIndex: 'empuserIndex',
        type: 'string'
    }, {
        dataIndex: 'appointmentTimeIndex',
        type: 'date'
    }, {
        dataIndex: 'remarksIndex',
        type: 'string'
    }, {
        dataIndex: 'followUpDateIndex',
        type: 'date'
    },{
        dataIndex: 'locationIndex',
        type: 'string'
    }, {
        dataIndex: 'lastUpdatedTimeIndex',
        type: 'date'
    },{
        dataIndex: 'statusIndex',
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
            dataIndex: 'customerIndex',
            header: "<span style=font-weight:bold;><%=Customer%></span>",
            width: 120,
            filter: {
                type: 'string'
            }
        }, {
            dataIndex: 'supervisorIndex',
            header: "<span style=font-weight:bold;><%=Supervisor%></span>",
            width: 150,
            filter: {
                type: 'string'
            }
        }, {
            dataIndex: 'employeeIndex',
            header: "<span style=font-weight:bold;><%=Employee%></span>",
            width: 150,
            filter: {
                type: 'string'
            }
        },{
            dataIndex: 'empuserIndex',
            header: "<span style=font-weight:bold;><%=EmployeeUser%></span>",
            width: 150,
            filter: {
                type: 'string'
            }
        }, {
            dataIndex: 'appointmentTimeIndex',
            header: "<span style=font-weight:bold;><%=AppointmentTime%></span>",
            width: 150,
            renderer: Ext.util.Format.dateRenderer(getDateTimeFormat()),
            filter: {
                type: 'date'
            }
        },{
            dataIndex: 'remarksIndex',
            header: "<span style=font-weight:bold;><%=Remarks%></span>",
            width: 150,
            filter: {
                type: 'string'
            }
        }, {
            dataIndex: 'followUpDateIndex',
            header: "<span style=font-weight:bold;><%=FollowUpDate%></span>",
            width: 150,
            renderer: Ext.util.Format.dateRenderer(getDateFormat()),
            filter: {
                type: 'date'
            }
        },{
            dataIndex: 'locationIndex',
            header: "<span style=font-weight:bold;><%=Location%></span>",
            width: 150,
            filter: {
                type: 'string'
            }
        }, {
            dataIndex: 'lastUpdatedTimeIndex',
            header: "<span style=font-weight:bold;><%=LastUpdatedTime%></span>",
            width: 150,
            renderer: Ext.util.Format.dateRenderer(getDateTimeFormat()),
            filter: {
                type: 'date'
            }
        },{
            dataIndex: 'statusIndex',
            header: "<span style=font-weight:bold;><%=Status%></span>",
            width: 150,
            filter: {
                type: 'string'
            }
        }];
    return new Ext.grid.ColumnModel({
        columns: columns.slice(start || 0, finish), 
        defaults: {
            sortable: true
        }
    });
};

//*****************************************************************Grid *******************************************************************************
grid = getGrid('<%=AppointmentDetails%>', '<%=NoRecordsFound%>', store, screen.width - 40, 440, 22, filters, '<%=ClearFilterData%>', false,'', 22, false, '', false, '', false, '', jspName, exportDataType, false, 'PDF', true, '<%=Add%>', true, '<%=Modify%>', true, '<%=Delete
%>');
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
            ffmcustomerstore.load({
                params: {
                    custId: Ext.getCmp('customercomboId').getValue()
                }
            });
            supervisorstore.load({
                params: {
                    custId: Ext.getCmp('customercomboId').getValue()
                }
            });
            empuserstore.load({
                params: {
                    custId: Ext.getCmp('customercomboId').getValue()
                }
            });
            employeestore.load({
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
                ffmcustomerstore.load({
                    params: {
                        custId: Ext.getCmp('customercomboId').getValue()
                    }
                });
               supervisorstore.load({
                    params: {
                        custId: Ext.getCmp('customercomboId').getValue()
                    }
                });                
                employeestore.load({
                    params: {
                        custId: Ext.getCmp('customercomboId').getValue()
                    }
                });
                empuserstore.load({
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
        custcombo,{width:30},
        	{
  		        xtype: 'label',
  		        cls: 'labelstyle',
  		        id: 'startdatelab',
  				text: '<%=StartDate%>' + ' :'
  			},{
  		        xtype: 'datefield',
  		        cls: 'selectstylePerfect',
  		        width: 185,
  		        format: getDateTimeFormat(),
  		        emptyText: '<%=SelectStartDate%>',
  		        allowBlank: false,
  		        blankText: '<%=SelectStartDate%>',
  		        id: 'startdate',
  		        vtype: 'daterange',
  		        endDateField: 'enddate'
  		    },{width: 50}, 
  		    {
  		        xtype: 'label',
  		        cls: 'labelstyle',
  		        id: 'enddatelab',
  		        text: '<%=EndDate%>' + ' :'
  		    },{
  		        xtype: 'datefield',
  		        cls: 'selectstylePerfect',
  		        width: 185,
  		        format: getDateTimeFormat(),
  		        emptyText: '<%=SelectEndDate%>',
  		        allowBlank: false,
  		        blankText: '<%=SelectEndDate%>',
  		        id: 'enddate',
  		        vtype: 'daterange',
  		        startDateField: 'startdate'
  		    },{width: 30},
  		    {
  		        xtype: 'button',
  		        text: '<%=View%>',
  		        id: 'addbuttonid',
  		        cls: ' ',
  		        width: 80,
  		        listeners: {
  		                click: {
  		               	   fn: function () {
  		                        if (Ext.getCmp('customercomboId').getValue() == "") {
  		                            Ext.example.msg("<%=SelectCustomer%>");
  		                            Ext.getCmp('customercomboId').focus();
  		                            return;
  		                        }
  		                        if (Ext.getCmp('startdate').getValue() == "") {
  		                            Ext.example.msg("<%=SelectStartDate%>");
  		                            Ext.getCmp('startdate').focus();
  		                            return;
  		                        }
  		                        if (Ext.getCmp('enddate').getValue() == "") {
  		                            Ext.example.msg("<%=SelectEndDate%>");
  		                            Ext.getCmp('enddate').focus();
  		                            return;
  		                        }
  		                        var startdates = Ext.getCmp('startdate').getValue();
  		                        var enddates = Ext.getCmp('enddate').getValue();
  		                        
  		                        if (startdates>enddates) {
  		                            Ext.example.msg("<%=dateValidation%>");
  		                            Ext.getCmp('enddate').focus();  		                            	
  		                            return;
  		                        }
  		                        if (checkMonthValidation(startdates, enddates)) {
  		                            Ext.example.msg("<%=monthValidation%>");
  		                            Ext.getCmp('enddate').focus();  		                            	
  		                            return;
  		                        }
  		                        store.removeAll();  		                      
								store.load({
                                    params: {
                                        custId: Ext.getCmp('customercomboId').getValue(),                                    
  		                                startdate: Ext.getCmp('startdate').getValue(),
  		                                enddate: Ext.getCmp('enddate').getValue(),  		                                
  		                                
                                    }
                                });  		               
  		                    }
  		                }
  		            }
  		    }
    ]
});

Ext.onReady(function() {
    ctsb = tsb;
    Ext.QuickTips.init();
    Ext.form.Field.prototype.msgTarget = 'side';
    outerPanel = new Ext.Panel({
        title: '<%=CustomerAppointmentInformation%>',
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


    
    
    
    
    

