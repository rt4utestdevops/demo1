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

tobeConverted.add("Customer_Name");
tobeConverted.add("Select_Customer");
tobeConverted.add("Id");

tobeConverted.add("No_Records_Found");
tobeConverted.add("Clear_Filter_Data");
tobeConverted.add("Add");
tobeConverted.add("SLNO");
tobeConverted.add("Cancel");
tobeConverted.add("Save");

tobeConverted.add("Modify_Details");
tobeConverted.add("Select_Single_Row");
tobeConverted.add("Modify");
tobeConverted.add("No_Rows_Selected");

tobeConverted.add("Vehicle_Operation_Details");

tobeConverted.add("Asset_Number");
tobeConverted.add("Select_Asset_Number");

tobeConverted.add("Asset_Type");
tobeConverted.add("Driver_Name");
tobeConverted.add("Driver_Number");

tobeConverted.add("District");
tobeConverted.add("Enter_District");

tobeConverted.add("Department");
tobeConverted.add("Enter_Department");

tobeConverted.add("Governate");
tobeConverted.add("Enter_Governate");

tobeConverted.add("Department_Office_Contact_Number");
tobeConverted.add("Enter_Department_Office_Contact_Number");

tobeConverted.add("Department_Supervisor");
tobeConverted.add("Enter_Department_Supervisor");

tobeConverted.add("Contractor");
tobeConverted.add("Enter_Contractor");

tobeConverted.add("Department_Manager");
tobeConverted.add("Enter_Department_Manager");


ArrayList<String> convertedWords = new ArrayList<String>();
convertedWords = cf.getLanguageSpecificWordForKey(tobeConverted,language);

String CustomerName=convertedWords.get(0);
String SelectCustomer=convertedWords.get(1);
String ID=convertedWords.get(2);

String NoRecordsFound=convertedWords.get(3);
String ClearFilterData=convertedWords.get(4);
String Add=convertedWords.get(5);
String SLNO=convertedWords.get(6);
String Cancel=convertedWords.get(7);
String Save=convertedWords.get(8);

String ModifyDetails=convertedWords.get(9);
String SelectSingleRow=convertedWords.get(10);
String Modify =convertedWords.get(11);
String NoRowsSelected=convertedWords.get(12);

String VehicleOperationDetails=convertedWords.get(13);

String VehicleNo=convertedWords.get(14);
String SelectVehicleNo=convertedWords.get(15);

String VehicleType=convertedWords.get(16);
String DriverName=convertedWords.get(17);
String DriverContactNo=convertedWords.get(18);

String District=convertedWords.get(19);
String EnterDistrict=convertedWords.get(20);

String Department=convertedWords.get(21);
String EnterDepartment=convertedWords.get(22);

String Governate=convertedWords.get(23);
String EnterGovernate=convertedWords.get(24);

String DeptOfficeNumber=convertedWords.get(25);
String EnterDeptOfficeNumber=convertedWords.get(26);

String DeptSupervisor=convertedWords.get(27);
String EnterDeptSupervisor=convertedWords.get(28);

String Contractor=convertedWords.get(29);
String EnterContractor=convertedWords.get(30);

String DeptManager=convertedWords.get(31);
String EnterDeptManager=convertedWords.get(32);
%>

<jsp:include page="../Common/header.jsp" />
 		<title>Vehicle Operation Window</title>	
 		  
	    
  <style>
	 .x-panel-header
		{
				height: 7% !important;
		}
		.x-grid3-cell-inner,.ext-strict .x-grid3-hd-inner {
			height: 26px !important;
			padding-top: 8px;
		}
		.x-form-text {
			height: 21px !important;
		}
		label {
			display: inline !important;			
		}
		.x-window-tl *.x-window-header {
			height : 46px !important;
		}
  </style>

   <%if (loginInfo.getStyleSheetOverride().equals("Y")){%>
	<jsp:include page="../Common/ImportJSSandMining.jsp"/>
	<%}else{%>
	<jsp:include page="../Common/ImportJS.jsp" /><%}%>
   <jsp:include page="../Common/ExportJS.jsp" />
   <script>
var outerPanel;
var exportDataType = "int,int,string,string,string,string,string,string,string,string,string,string,string";
var jspName = "Vehicle_Maintance_Window";
var grid;
var buttonValue;
var titelForInnerPanel;
var myWin;


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
                         CustId: Ext.getCmp('custcomboId').getValue(),
                         jspName:jspName,
                         custName:Ext.getCmp('custcomboId').getRawValue()
                     }
                 });
                 vehicleNoStore.load({
                    params: {
                        CustId: Ext.getCmp('custcomboId').getValue()
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
               custId = Ext.getCmp('custcomboId').getValue();
               store.load({
                    params: {
                        CustId: Ext.getCmp('custcomboId').getValue(),
                        jspName:jspName,
                        custName:Ext.getCmp('custcomboId').getRawValue()
                    }
                });
               vehicleNoStore.load({
                    params: {
                        CustId: Ext.getCmp('custcomboId').getValue()
                    }
                });
            }
        }
    }
});

var vehicleNoStore = new Ext.data.JsonStore({
    url: '<%=request.getContextPath()%>/VehicleOperationWindowAction.do?param=getVehicleNo',
    id: 'vehicleNoStoreId',
    root: 'vehicleNoRoot',
    autoLoad: false,
    remoteSort: true,
    fields: ['vehicleNo', 'assetType', 'driverName', 'driverContactNo'],
    listeners: {
        load: function(custstore, records, success, options) {
        }
    }
});

var vehicleNocombo = new Ext.form.ComboBox({
    store: vehicleNoStore,
    id: 'vehicleNoComboId',
    mode: 'local',
    forceSelection: true,
    selectOnFocus: true,
    allowBlank: false,
    anyMatch: true,
    typeAhead: false,
    triggerAction: 'all',
    lazyRender: true,
    valueField: 'vehicleNo',
    emptyText: '<%=SelectVehicleNo%>',
    displayField: 'vehicleNo',
    cls: 'selectstylePerfect',
    listeners: {
        select: {
            fn: function() {
             vehicleNo=Ext.getCmp('vehicleNoComboId').getValue();
             var row = vehicleNoStore.find('vehicleNo',vehicleNo);
			 var rec = vehicleNoStore.getAt(row);
			 vehicleType=rec.data['assetType'];
			 driverName=rec.data['driverName'];
			 driverContactNo=rec.data['driverContactNo'];
			 Ext.getCmp('vehicleTypeId').setValue(vehicleType);
			 Ext.getCmp('driverNameId').setValue(driverName);
			 Ext.getCmp('driverContactNoId').setValue(driverContactNo);
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

var innerPanelForVehicleOperation = new Ext.form.FormPanel({
    standardSubmit: true,
    collapsible: false,
    autoScroll: true,
    height: 350,
    width: '100%',
    frame: true,
    id: 'innerPanelForVehicleOperationId',
    layout: 'table',
    layoutConfig: {
        columns: 3
    },
    items: [{
        xtype: 'fieldset',
        title: '<%=VehicleOperationDetails%>',
        cls: 'fieldsetpanel',
        collapsible: false,
        colspan: 3,
        id: 'vehicleOperationDetailsId',
        width: 490,
        layout: 'table',
        layoutConfig: {
            columns: 4
        },
        items: [{
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'vehicleNoEmptyId1'
        }, {
            xtype: 'label',
            text: '<%=VehicleNo%>' + ' :',
            cls: 'labelstyle',
            id: 'vehicleNoLabelId'
        }, vehicleNocombo,{
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'vehicleNoEmptyId2'
        }, {
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'vehicleTypeEmptyId1'
        }, {
            xtype: 'label',
            text: '<%=VehicleType%>' + ' :',
            cls: 'labelstyle',
            id: 'vehicleTypeLabelId'
        }, {
            xtype: 'textfield',
            cls: 'selectstylePerfect',
            allowBlank: false,
            readOnly:true,
            id: 'vehicleTypeId'
        }, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'vehicleTypeEmptyId2'
        }, {
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'driverNameEmptyId1'
        }, {
            xtype: 'label',
            text: '<%=DriverName%>' + ' :',
            cls: 'labelstyle',
            id: 'driverNameLabelId'
        }, {
            xtype: 'textfield',
            cls: 'selectstylePerfect',
            allowBlank: false,
            readOnly:true,
            labelSeparator: '',
            id: 'driverNameId'
        }, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'driverNameEmptyId2'
        },{
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'driverContactNoEmptyId1'
        }, {
            xtype: 'label',
            text: '<%=DriverContactNo%>' + ' :',
            cls: 'labelstyle',
            id: 'driverContactNoLabelId'
        }, {
            xtype: 'numberfield',
            cls: 'selectstylePerfect',
            allowBlank: false,
            readOnly:true,
            labelSeparator: '',
            id: 'driverContactNoId'
        }, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'driverContactNoEmptyId2'
        },{
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'districtEmptyId1'
        }, {
            xtype: 'label',
            text: '<%=District%>' + ' :',
            cls: 'labelstyle',
            id: 'districtLabelId'
        }, {
            xtype: 'textfield',
            cls: 'selectstylePerfect',
            allowBlank: false,
            blankText: '<%=EnterDistrict%>',
            emptyText: '<%=EnterDistrict%>',
            id: 'districtId',
            listeners:{
					change: function(field, newValue, oldValue){
					field.setValue(newValue.toUpperCase());
					}
					}
        }, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'districtEmptyId2'
        }, {
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'DepartmentEmptyId1'
        }, {
            xtype: 'label',
            text: '<%=Department%>' + ' :',
            cls: 'labelstyle',
            id: 'DepartmentLabelId'
        }, {
           xtype: 'textfield',
            cls: 'selectstylePerfect',
            allowBlank: false,
            blankText: '<%=EnterDepartment%>',
            emptyText: '<%=EnterDepartment%>',
            id: 'DepartmentId',
            listeners:{
					change: function(field, newValue, oldValue){
					field.setValue(newValue.toUpperCase());
					}
					}
         }, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'DepartmentEmptyId2'
        },{
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'GovernateEmptyId1'
        }, {
            xtype: 'label',
            text: '<%=Governate%>' + ' :',
            cls: 'labelstyle',
            id: 'GovernateLabelId'
        }, {
           xtype: 'textfield',
            cls: 'selectstylePerfect',
            allowBlank: false,
            blankText: '<%=EnterGovernate%>',
            emptyText: '<%=EnterGovernate%>',
            id: 'GovernateId',
            listeners:{
					change: function(field, newValue, oldValue){
					field.setValue(newValue.toUpperCase());
					}
					}
         }, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'GovernateEmptyId2'
        },{
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'deptContactNoEmptyId1'
        },{
            xtype: 'label',
            text: '<%=DeptOfficeNumber%>' + ' :',
            cls: 'labelstyle',
            id: 'deptContactNoLabelId'
        }, {
            xtype: 'numberfield',
            cls: 'selectstylePerfect',
            allowBlank: false,
            blankText: '<%=EnterDeptOfficeNumber%>',
            emptyText: '<%=EnterDeptOfficeNumber%>',
            id: 'deptContactNoId'
        }, {
            xtype: 'label',
            text:  '',
            id: 'deptContactNoId2'
        },{
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'deptSupervisorEmptyId1'
        },{
            xtype: 'label',
            text: '<%=DeptSupervisor%> ' +' :',
            cls: 'labelstyle',
            id: 'deptSupervisorLabelId'
        }, {
            xtype: 'textfield',
            cls: 'selectstylePerfect',
            allowBlank: false,
            blankText: '<%=EnterDeptSupervisor%>',
            emptyText: '<%=EnterDeptSupervisor%>',
            id: 'deptSupervisorId',
            listeners:{
					change: function(field, newValue, oldValue){
					field.setValue(newValue.toUpperCase());
					}
					}
        }, {
            xtype: 'label',
            text: '',
            id: 'deptSupervisorEmptyId2'
        }, {
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'contractorEmptyId1'
        }, {
            xtype: 'label',
            text: '<%=Contractor%>' + ' :',
            cls: 'labelstyle',
            id: 'contractorLabelId'
        }, {
            xtype: 'textfield',
            cls: 'selectstylePerfect',
            allowBlank: false,
            blankText: '<%=EnterContractor%>',
            emptyText: '<%=EnterContractor%>',
            id: 'contractorId',
            listeners:{
					change: function(field, newValue, oldValue){
					field.setValue(newValue.toUpperCase());
					}
					}
        }, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'contractorId2'
        }, {
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'DeptManagerEmptyId1'
        }, {
            xtype: 'label',
            text: '<%=DeptManager%>' + ' :',
            cls: 'labelstyle',
            id: 'DeptManagerLabelId'
        }, {
            xtype: 'textfield',
            cls: 'selectstylePerfect',
            allowBlank: false,
            blankText: '<%=EnterDeptManager%>',
            emptyText: '<%=EnterDeptManager%>',
            id: 'DeptManagerId',
            listeners:{
					change: function(field, newValue, oldValue){
					field.setValue(newValue.toUpperCase());
					}
					}
        }, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'DeptManagerEmptyId2'
        }]
     }]   
  });      
  
var innerWinButtonPanel = new Ext.Panel({
    id: 'innerWinButtonPanelId',
    standardSubmit: true,
    collapsible: false,
    autoHeight: true,
    height: 100,
    width: 530,
    frame: true,
    layout: 'table',
    layoutConfig: {
        columns: 4
    },
    buttons: [{
        xtype: 'button',
        text: '<%=Save%>',
        iconCls: 'savebutton',
        id: 'saveButtonId',
        cls: 'buttonstyle',
        width: 70,
        listeners: {
            click: {
                fn: function() {
                    if (Ext.getCmp('custcomboId').getValue() == "") {
                        Ext.example.msg("<%=SelectCustomer%>");
                        return;
                    }
                    if (Ext.getCmp('vehicleNoComboId').getValue() == "") {
                        Ext.example.msg("<%=SelectVehicleNo%>");
                        return;
                    }
                    if (Ext.getCmp('districtId').getValue() == "") {
                        Ext.example.msg("<%=EnterDistrict%>");
                        Ext.getCmp('districtId').focus();
                        return;
                    }
                    if (Ext.getCmp('DepartmentId').getValue() == "") {
                        Ext.example.msg("<%=EnterDepartment%>");
                        Ext.getCmp('DepartmentId').focus();
                        return;
                    }
                    if (Ext.getCmp('GovernateId').getValue() == "") {
                        Ext.example.msg("<%=EnterGovernate%>");
                        Ext.getCmp('GovernateId').focus();
                        return;
                    }
                    if (Ext.getCmp('deptContactNoId').getValue() == "") {
                        Ext.example.msg("<%=EnterDeptOfficeNumber%>");
                        Ext.getCmp('deptContactNoId').focus();
                        return;
                    }
                    if (Ext.getCmp('deptSupervisorId').getValue() == "") {
                        Ext.example.msg("<%=EnterDeptSupervisor%>");
                        Ext.getCmp('deptSupervisorId').focus();
                        return;
                    }
                    if (Ext.getCmp('contractorId').getValue() == "") {
                        Ext.example.msg("<%=EnterContractor%>");
                        Ext.getCmp('contractorId').focus();
                        return;
                    }
                    if (Ext.getCmp('DeptManagerId').getValue() == "") {
                        Ext.example.msg("<%=EnterDeptManager%>");
                        Ext.getCmp('DeptManagerId').focus();
                        return;
                    }
                    var selected;
                    if (buttonValue == '<%=Modify%>') {
                    var selected = grid.getSelectionModel().getSelected();
                    id=selected.get('idDataIndex');
                    }
                    VehicleOperationOuterPanelWindow.getEl().mask();
                    Ext.Ajax.request({
                        url: '<%=request.getContextPath()%>/VehicleOperationWindowAction.do?param=addAndModifyVehicleDetails',
                        method: 'POST',
                        params: {
                            buttonValue: buttonValue,
                            custId: Ext.getCmp('custcomboId').getValue(),
                            vehicleNo: Ext.getCmp('vehicleNoComboId').getValue(),
                            vehicleType: Ext.getCmp('vehicleTypeId').getValue(),
                            driverName: Ext.getCmp('driverNameId').getValue(),
                            driverContactNo: Ext.getCmp('driverContactNoId').getValue(),
                            district: Ext.getCmp('districtId').getValue(),
                            Department: Ext.getCmp('DepartmentId').getValue(),
                            Governate: Ext.getCmp('GovernateId').getValue(),
                            deptContactNo: Ext.getCmp('deptContactNoId').getValue(),
                            deptSupervisor: Ext.getCmp('deptSupervisorId').getValue(),
                            contractor: Ext.getCmp('contractorId').getValue(),
                            DeptManager: Ext.getCmp('DeptManagerId').getValue(),
                            id:id
                            },
                        success: function(response, options) {
                            var message = response.responseText;
                            Ext.example.msg(message);
                            Ext.getCmp('vehicleNoComboId').reset();
                            Ext.getCmp('vehicleTypeId').reset();
                            Ext.getCmp('driverNameId').reset();
                            Ext.getCmp('driverContactNoId').reset();
                            Ext.getCmp('districtId').reset();
                            Ext.getCmp('DepartmentId').reset();
                            Ext.getCmp('GovernateId').reset();
                            Ext.getCmp('deptContactNoId').reset();
                            Ext.getCmp('deptSupervisorId').reset();
                            Ext.getCmp('contractorId').reset();
                            Ext.getCmp('DeptManagerId').reset();
                            myWin.hide();
                            VehicleOperationOuterPanelWindow.getEl().unmask();
                            vehicleNoStore.load({
                    			params: {
                        			CustId: Ext.getCmp('custcomboId').getValue()
                    			}
                			});
                            store.load({
                                params: {
                                    CustId: Ext.getCmp('custcomboId').getValue(),
                                    jspName:jspName,
                                    custName:Ext.getCmp('custcomboId').getRawValue()
                                }
                            });
                            
                        },
                        failure: function() {
                            Ext.example.msg("Error");
                            myWin.hide();
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
                }
            }
        }
    }]
});

var VehicleOperationOuterPanelWindow = new Ext.Panel({
    width: 530,
    height: 400,
    standardSubmit: true,
    frame: false,
    items: [innerPanelForVehicleOperation, innerWinButtonPanel]
});

myWin = new Ext.Window({
    title: titelForInnerPanel,
    closable: false,
    resizable: false,
    modal: true,
    autoScroll: false,
    height: 450,
    width: 540,
    id: 'myWin',
    items: [VehicleOperationOuterPanelWindow]
});

function addRecord() {
    if (Ext.getCmp('custcomboId').getValue() == "") {
        Ext.example.msg("<%=SelectCustomer%>");
        return;
    }
    buttonValue = '<%=Add%>';
    titelForInnerPanel = '<%=VehicleOperationDetails%>';
    myWin.setPosition(450, 55);
    myWin.show();
    myWin.setTitle(titelForInnerPanel);
    Ext.getCmp('vehicleNoComboId').enable();
     Ext.getCmp('vehicleNoComboId').reset();
     Ext.getCmp('vehicleTypeId').reset();
     Ext.getCmp('driverNameId').reset();
     Ext.getCmp('driverContactNoId').reset();
     Ext.getCmp('districtId').reset();
     Ext.getCmp('DepartmentId').reset();
     Ext.getCmp('GovernateId').reset();
     Ext.getCmp('deptContactNoId').reset();
     Ext.getCmp('deptSupervisorId').reset();
     Ext.getCmp('contractorId').reset();
     Ext.getCmp('DeptManagerId').reset();

}

function modifyData() {
      if (Ext.getCmp('custcomboId').getValue() == "") {
          Ext.example.msg("<%=SelectCustomer%>");
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
      titelForInnerPanel = '<%=ModifyDetails%>';
      myWin.setPosition(450, 55);
      myWin.setTitle(titelForInnerPanel);
      myWin.show();
      Ext.getCmp('vehicleNoComboId').disable();
      var selected = grid.getSelectionModel().getSelected();
      Ext.getCmp('vehicleNoComboId').setValue(selected.get('vehicleNoDataIndex'));
      Ext.getCmp('vehicleTypeId').setValue(selected.get('vehicleNoDataIndex'));
      Ext.getCmp('driverNameId').setValue(selected.get('driverNameDataIndex'));
      Ext.getCmp('driverContactNoId').setValue(selected.get('driverContactNoDataIndex'));
      Ext.getCmp('districtId').setValue(selected.get('districtDataIndex'));
      Ext.getCmp('DepartmentId').setValue(selected.get('departmentDataIndex'));
      Ext.getCmp('GovernateId').setValue(selected.get('governateDataIndex'));
      Ext.getCmp('deptContactNoId').setValue(selected.get('deptOfficeContactNumberDataIndex'));
      Ext.getCmp('deptSupervisorId').setValue(selected.get('deptSupervisorDataIndex'));
      Ext.getCmp('contractorId').setValue(selected.get('ContractorDataIndex'));
      Ext.getCmp('DeptManagerId').setValue(selected.get('deptManagerDataIndex'));
  }
  
var reader = new Ext.data.JsonReader({
    idProperty: 'vehicleopid',
    root: 'vehicleopRoot',
    totalProperty: 'total',
    fields: [{
        name: 'slnoIndex'
    }, {
        name: 'vehicleNoDataIndex'
    },{
        name: 'vehicleTypeDataIndex'
    }, {
        name: 'driverNameDataIndex'
    },{
        name: 'driverContactNoDataIndex'
    }, {
        name: 'districtDataIndex'
    }, {
        name: 'departmentDataIndex'
    }, {
        name: 'governateDataIndex'
    }, {
        name: 'deptOfficeContactNumberDataIndex'
    }, {
        name: 'deptSupervisorDataIndex'
    }, {
        name: 'ContractorDataIndex'
    },{
        name: 'deptManagerDataIndex'
    },{
        name: 'idDataIndex'
    }]
});

var store = new Ext.data.GroupingStore({
    autoLoad: false,
    proxy: new Ext.data.HttpProxy({
        url: '<%=request.getContextPath()%>/VehicleOperationWindowAction.do?param=getVehicleDetails',
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
        type: 'string',
        dataIndex: 'vehicleNoDataIndex'
    },{
        type: 'string',
        dataIndex: 'vehicleTypeDataIndex'
    }, {
        type: 'string',
        dataIndex: 'driverNameDataIndex'
    }, {
        type: 'string',
        dataIndex: 'driverContactNoDataIndex'
    },{
        type: 'string',
        dataIndex: 'districtDataIndex'
    }, {
        type: 'string',
        dataIndex: 'departmentDataIndex'
    },{
        type: 'string',
        dataIndex: 'governateDataIndex'
    }, {
        type: 'string',
        dataIndex: 'deptOfficeContactNumberDataIndex'
    }, {
        type: 'string',
        dataIndex: 'deptSupervisorDataIndex'
    }, {
        type: 'string',
        dataIndex: 'ContractorDataIndex'
    },{
        type: 'string',
        dataIndex: 'deptManagerDataIndex'
    },{
        type: 'numeric',
        dataIndex: 'idDataIndex'
    }]
});

var createColModel = function(finish, start) {
    var columns = [
        new Ext.grid.RowNumberer({
            header: "<span style=font-weight:bold;><%=SLNO%></span>",
            width: 50
        }), {
            dataIndex: 'slnoIndex',
            width: 100,
            hidden: true,
            header: "<span style=font-weight:bold;><%=SLNO%></span>",
            filter: {
                type: 'numeric'
            }
        },{
            header: "<span style=font-weight:bold;><%=ID%></span>",
            dataIndex: 'idDataIndex',
            width: 100,
            hidden:true,
            filter: {
                type: 'numeric'
            }
        }, {
            dataIndex: 'vehicleNoDataIndex',
            width: 100,
            header: "<span style=font-weight:bold;><%=VehicleNo%></span>",
            filter: {
                type: 'string'
            }
        }, {
            dataIndex: 'vehicleTypeDataIndex',
            width: 100,
            header: "<span style=font-weight:bold;><%=VehicleType%></span>",
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;><%=DriverName%></span>",
            dataIndex: 'driverNameDataIndex',
            width: 100,
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;><%=DriverContactNo%></span>",
            dataIndex: 'driverContactNoDataIndex',
            width: 100,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=District%></span>",
            dataIndex: 'districtDataIndex',
            width: 100,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=Department%></span>",
            dataIndex: 'departmentDataIndex',
            width: 100,
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;><%=Governate%></span>",
            dataIndex: 'governateDataIndex',
            width: 100,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=DeptOfficeNumber%></span>",
            dataIndex: 'deptOfficeContactNumberDataIndex',
            width: 100,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=DeptSupervisor%></span>",
            dataIndex: 'deptSupervisorDataIndex',
            width: 100,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=Contractor%></span>",
            dataIndex: 'ContractorDataIndex',
            width: 100,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=DeptManager%></span>",
            dataIndex: 'deptManagerDataIndex',
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
grid = getGrid('<%=VehicleOperationDetails%>', '<%=NoRecordsFound%>', store, screen.width - 40, 420, 27, filters, '<%=ClearFilterData%>', false, '', 16, false, '', false, '', true, 'Excel', jspName, exportDataType, true, 'PDF', true, '<%=Add%>', true, '<%=Modify%>');
//******************************************************************************************************************************************************
Ext.onReady(function() {
    ctsb = tsb;
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
<jsp:include page="../Common/footer.jsp" />
 <!-- </body>   -->
 <!-- </html> -->
    
    
    
    
    


