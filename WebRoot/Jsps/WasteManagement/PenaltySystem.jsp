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

tobeConverted.add("Date");
tobeConverted.add("Asset_No");
tobeConverted.add("Asset_Type");
tobeConverted.add("Driver_Name");
tobeConverted.add("Driver_Contact_No");
tobeConverted.add("District");
tobeConverted.add("Department");
tobeConverted.add("Governate");
tobeConverted.add("Penalty_Type");
tobeConverted.add("Amount");
tobeConverted.add("Customer_Name");
tobeConverted.add("Select_Customer_Name");
tobeConverted.add("Start_Date");
tobeConverted.add("Select_Start_Date");
tobeConverted.add("End_Date");
tobeConverted.add("Select_End_Date");
tobeConverted.add("View");
tobeConverted.add("Penalty_System_Details");
tobeConverted.add("Penalty_System");
tobeConverted.add("Add");
tobeConverted.add("Modify");
tobeConverted.add("Excel");
tobeConverted.add("Select_Date");
tobeConverted.add("Driver_Number");
tobeConverted.add("Save");
tobeConverted.add("Cancel");
tobeConverted.add("Clear_Filter_Data");
tobeConverted.add("No_Records_Found");
tobeConverted.add("SLNO");
tobeConverted.add("Month_Validation");
tobeConverted.add("District_Name");
tobeConverted.add("Governate_Name");
tobeConverted.add("Department_Name");
tobeConverted.add("No_Record_Selected_for_Modify");
tobeConverted.add("Select_Asset_Number");
tobeConverted.add("Select_Penalty");
tobeConverted.add("Id");
tobeConverted.add("Select_Single_Row");
tobeConverted.add("Modify_Details");
tobeConverted.add("PDF");

ArrayList<String> convertedWords = new ArrayList<String>();
convertedWords = cf.getLanguageSpecificWordForKey(tobeConverted,language);

String Date = convertedWords.get(0);
String VehicleNo = convertedWords.get(1);
String VehicleType = convertedWords.get(2);
String DriverName = convertedWords.get(3);
String DriverContactNo = convertedWords.get(4);
String District = convertedWords.get(5);
String Department = convertedWords.get(6);
String Government = convertedWords.get(7);
String PenaltyType = convertedWords.get(8);
String Amount = convertedWords.get(9);
String CustomerName = convertedWords.get(10);
String SelectCustomerName = convertedWords.get(11);
String StartDate = convertedWords.get(12);
String SelectStartDate = convertedWords.get(13);
String EndDate = convertedWords.get(14);
String SelectEndDate = convertedWords.get(15);
String View = convertedWords.get(16);
String PenaltySystemDetails = convertedWords.get(17);
String PenaltySystem = convertedWords.get(18);
String Add = convertedWords.get(19);
String Modify = convertedWords.get(20);
String Export = convertedWords.get(21);
String SelectDate = convertedWords.get(22);
String DriverNumber = convertedWords.get(23);
String Save = convertedWords.get(24);
String Cancel = convertedWords.get(25);
String ClearFilterData = convertedWords.get(26);
String NoRecordsFound = convertedWords.get(27);
String SLNO = convertedWords.get(28);
String MonthValidation = convertedWords.get(29);
String DistrictName = convertedWords.get(30);
String GovernmentName = convertedWords.get(31);
String DepartmentName = convertedWords.get(32);
String NoRowsSelected = convertedWords.get(33);
String SelectVehicle = convertedWords.get(34);
String SelectPenalty = convertedWords.get(35);
String ID = convertedWords.get(36);
String SelectSingleRow = convertedWords.get(37);
String ModifyDetails = convertedWords.get(38);
String PDF = convertedWords.get(39);

%>

<jsp:include page="../Common/header.jsp" />
 	<title><%=PenaltySystem%></title>
<style>
  .x-panel-tl
	{
		border-bottom: 0px solid !important;
	}
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
			height: 42px !important;
		}
		.footer {
			bottom : -12px !important;
		}
</style>

   
   	<%if (loginInfo.getStyleSheetOverride().equals("Y")){%>
	<jsp:include page="../Common/ImportJSSandMining.jsp"/>
	<%}else {%>
	<jsp:include page="../Common/ImportJS.jsp" /><%}%>
    <jsp:include page="../Common/ExportJS.jsp" />
<script>
	var outerPanel;
	var ctsb;
	var jspName = "PenaltySystem";
	var exportDataType = "int,int,date,string,string,string,String,string,string,string,string,string";
	var selected;
	var grid;
	var buttonValue;
	var titelForInnerPanel;
	var myWin;
	var dtprev = datecur.add(Date.DAY, -1);
	var dtcur = datecur;

var clientcombostore = new Ext.data.JsonStore({
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
                vehicleStore.load({
                     params: {
                         CustId: custId
                     }
                 });
                 penaltyStore.load({
                     params: {
                         CustId: custId
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
                vehicleStore.load({
                     params: {
                         CustId: custId
                     }
                 });
                 penaltyStore.load({
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
    width: screen.width - 40,
    height: 40,
    layoutConfig: {
        columns: 20
    },
    items: [{
            	xtype: 'label',
            	text: '<%=CustomerName%>' + ' :',
            	cls: 'labelstyle'
        	},
        	Client,{width:30},
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
  		        value: dtprev,
  		        endDateField: 'enddate'
  		    },{width: 60}, 
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
  		        value:dtcur,
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
  		                        if (Ext.getCmp('custcomboId').getValue() == "") {
  		                            Ext.example.msg("<%=SelectCustomerName%>");
  		                            Ext.getCmp('custcomboId').focus();
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
  		                        
  		                        
  		                        if (checkMonthValidation(startdates, enddates)) {
  		                            Ext.example.msg("<%=MonthValidation%>");
  		                            Ext.getCmp('enddate').focus();
  		                            return;
  		                        }
  		                        store.load({
                                    params: {
                                        CustId: Ext.getCmp('custcomboId').getValue(),
  		                                startdate: Ext.getCmp('startdate').getValue(),
  		                                enddate: Ext.getCmp('enddate').getValue(),
  		                                jspName:jspName
                                    }
                                });
  		                    }
  		                }
  		            }
  		    },{width:30}
    ]
});

	var vehicleStore = new Ext.data.JsonStore({
				   url:'<%=request.getContextPath()%>/PenaltySystemAction.do?param=getVehicles',
			       root: 'VehicleDetails',
			       autoLoad: false,
				   fields: ['AssetId','VehicleNo','VehicleType','DriverName','DriverMobileNo','District','Department','Government']
	});
			     
			     
	var vehicleNumber = new Ext.form.ComboBox({
	  	
	  	frame:true,
	 	store: vehicleStore,
	 	id:'VehicleNumberId',
	 	width: 150,
	 	cls: 'selectstylePerfect',
	 	hidden:false,
	 	anyMatch:true,
	 	onTypeAhead:true,
	 	forceSelection:true,
	 	enableKeyEvents:true,
	 	mode: 'local',
	 	emptyText:'<%=SelectVehicle%>',
	 	blankText:'<%=SelectVehicle%>',
	 	triggerAction: 'all',
	 	displayField: 'VehicleNo',
	 	valueField: 'AssetId',
	 	listeners: {
		             select: {
		                 	   fn:function(){
		                 	   	  	  var row = vehicleStore.find('AssetId',Ext.getCmp('VehicleNumberId').getValue());
									  var rec = vehicleStore.getAt(row);
		                 	   		  Ext.getCmp('vehicleTypeLabelId').setValue(rec.data['VehicleType']);
		                 	   		  Ext.getCmp('driverNameLabelId').setValue(rec.data['DriverName']);
		                 	   		  Ext.getCmp('driverNumberLabelId').setValue(rec.data['DriverMobileNo']);
		                 	   		  Ext.getCmp('districtLabelId').setValue(rec.data['District']);
		                 	   		  Ext.getCmp('departmentLabelId').setValue(rec.data['Department']);
		                 	   		  Ext.getCmp('governmentLabelId').setValue(rec.data['Government']);
		                 	   }
		                 	}
		          }	    
    }); 


	var penaltyStore = new Ext.data.JsonStore({
				   url:'<%=request.getContextPath()%>/PenaltySystemAction.do?param=getPenalty',
			       root: 'PenaltyDetails',
			       autoLoad: false,
				   fields: ['PenaltyId','PenaltyType','Amount']
	}); 

 	var PenaltyType = new Ext.form.ComboBox({
	 
	 		frame:true,
		 	store: penaltyStore,
	 		id:'PenaltyTypeId',
	 		width: 150,
	 		cls: 'selectstylePerfect',
	 		hidden:false,
	 		anyMatch:true,
	 		onTypeAhead:true,
	 		forceSelection:true,
	 		enableKeyEvents:true,
	 		mode: 'local',
	 		emptyText:'<%=SelectPenalty%>',
	 		blankText:'<%=SelectPenalty%>',
	 		triggerAction: 'all',
	 		displayField: 'PenaltyType',
	 		valueField: 'PenaltyId',
	 		listeners: {
		                 select: {
		                 	   	   fn:function(){
		                 	   	   		var row = penaltyStore.find('PenaltyId',Ext.getCmp('PenaltyTypeId').getValue());
										var rec = penaltyStore.getAt(row);
		                 	   			Ext.getCmp('amountLabelId').setValue(rec.data['Amount']);
		                 	   	   }
		                         }
		               }	    
    }); 

 var innerPanelForPenaltySystemDetails = new Ext.form.FormPanel({
    standardSubmit: true,
    collapsible: false,
    autoScroll: true,
    height: 320,
    width: 385,
    frame: true,
    id: 'innerPanelForPenaltySystemDetailsId',
    layout: 'table',
    layoutConfig: {
        columns: 4
    },
    items: [{
        xtype: 'fieldset',
        title: '',
        cls: 'fieldsetpanel',
        collapsible: false,
        colspan: 3,
        id: 'PenaltySystemId',
        width: 370,
        layout: 'table',
        layoutConfig: {
            columns: 3
        },
        items: [{
            		xtype: 'label',
            		text: '*',
            		cls: 'mandatoryfield',
            		id: 'dateMandotoryId'
        	},{
            		xtype: 'label',
            		text: '<%=SelectDate%>' + ' :',
            		cls: 'labelstyle',
            		id: 'selectDateId'
        	},{
        			xtype: 'datefield',
  		        	cls: 'selectstylePerfect',
  		        	width: 185,
  		        	format: getDateTimeFormat(),
  		        	emptyText: '<%=SelectDate%>',
  		        	allowBlank: false,
  		        	blankText: '<%=SelectDate%>',
  		        	id: 'date',
  		        	value:dtcur,
  		        	vtype: 'daterange'
        	},{
            		xtype: 'label',
            		text: '*',
            		cls: 'mandatoryfield',
            		id: 'vehicleMandotoryId'
        	},{
        			xtype: 'label',
            		text: '<%=VehicleNo%>' + ' :',
            		cls: 'labelstyle',
            		id: 'vehicleNoId'
        	},
					vehicleNumber
			,{
            		xtype: 'label',
            		text: ' ',
            		cls: 'mandatoryfield',
            		id: 'vehicleTypeMandotoryId'
        	},{
					xtype: 'label',
            		text: '<%=VehicleType%>' + ' :',
            		cls: 'labelstyle',
            		id: 'vehicleTypeId'
			},{
					xtype: 'textfield',
            		cls: 'selectstylePerfect',
            		allowBlank: false,
            		blankText: '<%=VehicleType%>',
            		emptyText: '<%=VehicleType%>',
            		labelSeparator: '',
            		allowBlank: false,
            		disabled : true,
            		id: 'vehicleTypeLabelId'
			},{
            		xtype: 'label',
            		text: ' ',
            		cls: 'mandatoryfield',
            		id: 'driverNameMandotoryId'
        	},{
					xtype: 'label',
            		text: '<%=DriverName%>' + ' :',
            		cls: 'labelstyle',
            		id: 'driverNameId'
			},{
					xtype: 'textfield',
            		cls: 'selectstylePerfect',
            		allowBlank: false,
            		blankText: '<%=DriverName%>',
            		emptyText: '<%=DriverName%>',
            		labelSeparator: '',
            		allowBlank: false,
            		disabled : true,
            		id: 'driverNameLabelId'
			},{
            		xtype: 'label',
            		text: ' ',
            		cls: 'mandatoryfield',
            		id: 'driverNumberMandotoryId'
        	},{
					xtype: 'label',
            		text: '<%=DriverNumber%>' + ' :',
            		cls: 'labelstyle',
            		id: 'driverNumberId'
			},{
					xtype: 'textfield',
            		cls: 'selectstylePerfect',
            		allowBlank: false,
            		blankText: '<%=DriverNumber%>',
            		emptyText: '<%=DriverNumber%>',
            		labelSeparator: '',
            		allowBlank: false,
            		disabled : true,
            		id: 'driverNumberLabelId'
			},{
            		xtype: 'label',
            		text: ' ',
            		cls: 'mandatoryfield',
            		id: 'districtMandotoryId'
        	},{
					xtype: 'label',
            		text: '<%=District%>' + ' :',
            		cls: 'labelstyle',
            		id: 'districtId'
			},{
					xtype: 'textfield',
            		cls: 'selectstylePerfect',
            		allowBlank: false,
            		blankText: '<%=DistrictName%>',
            		emptyText: '<%=DistrictName%>',
            		labelSeparator: '',
            		allowBlank: false,
            		disabled : true,
            		id: 'districtLabelId'
			},{
            		xtype: 'label',
            		text: ' ',
            		cls: 'mandatoryfield',
            		id: 'departmentMandotoryId'
        	},{
					xtype: 'label',
            		text: '<%=Department%>' + ' :',
            		cls: 'labelstyle',
            		id: 'departmentId'
			},{
					xtype: 'textfield',
            		cls: 'selectstylePerfect',
            		allowBlank: false,
            		blankText: '<%=DepartmentName%>',
            		emptyText: '<%=DepartmentName%>',
            		labelSeparator: '',
            		allowBlank: false,
            		disabled : true,
            		id: 'departmentLabelId'
			},{
            		xtype: 'label',
            		text: ' ',
            		cls: 'mandatoryfield',
            		id: 'governmentMandotoryId'
        	},{
					xtype: 'label',
            		text: '<%=Government%>' + ' :',
            		cls: 'labelstyle',
            		id: 'governmentId'
			},{
					xtype: 'textfield',
            		cls: 'selectstylePerfect',
            		allowBlank: false,
            		blankText: '<%=GovernmentName%>',
            		emptyText: '<%=GovernmentName%>',
            		labelSeparator: '',
            		allowBlank: false,
            		disabled : true,
            		id: 'governmentLabelId'
			},{
            		xtype: 'label',
            		text: '*',
            		cls: 'mandatoryfield',
            		id: 'penaltyTypeMandotoryId'
        	},{
					xtype: 'label',
            		text: '<%=PenaltyType%>' + ' :',
            		cls: 'labelstyle',
            		id: 'penaltyTypeId'
			},
					PenaltyType
			,{
            		xtype: 'label',
            		text: ' ',
            		cls: 'mandatoryfield',
            		id: 'amountMandotoryId'
        	},{
					xtype: 'label',
            		text: '<%=Amount%>' + ' :',
            		cls: 'labelstyle',
            		id: 'amountId'
			},{
					xtype: 'textfield',
            		cls: 'selectstylePerfect',
            		allowBlank: false,
            		blankText: '<%=Amount%>',
            		emptyText: '<%=Amount%>',
            		labelSeparator: '',
            		allowBlank: false,
            		disabled : true,
            		id: 'amountLabelId'
			}
       ]
    }]
});

var innerWinButtonPanel = new Ext.Panel({
    id: 'innerWinButtonPanelId',
    standardSubmit: true,
    collapsible: false,
    autoHeight: true,
    height: 70,
    width: 385,
    frame: true,
    layout: 'table',
    layoutConfig: {
        columns: 4
    },
    buttons: [{
        xtype: 'button',
        text: 'Save',
        iconCls: 'savebutton',
        id: 'saveButtonId',
        cls: 'buttonstyle',
        width: 70,
        listeners: {
            click: {
                fn: function () {
                  
                  	if (Ext.getCmp('date').getValue() == "") {
                        Ext.example.msg("<%=SelectDate%>");
                        Ext.getCmp('date').focus();
                        return;
                    }
                    if (Ext.getCmp('VehicleNumberId').getValue() == "") {
                        Ext.example.msg("<%=SelectVehicle%>");
                        Ext.getCmp('VehicleNumberId').focus();
                        return;
                    }
                    if (Ext.getCmp('PenaltyTypeId').getValue() == "") {
                        Ext.example.msg("<%=SelectPenalty%>");
                        Ext.getCmp('PenaltyTypeId').focus();
                        return;
                    }
                   
                    
                    if (innerPanelForPenaltySystemDetails.getForm().isValid()) {
                     	
                     	var id=0;
                      	if(buttonValue == 'Modify'){
                    		var selected = grid.getSelectionModel().getSelected();
                            id = selected.get('IndexIdDataIndex');
                            Ext.getCmp('VehicleNumberId').setValue(id);
                      	}
                      	
                       PenaltySystemOuterPanelWindow.getEl().mask();
                        Ext.Ajax.request({
                            url: '<%=request.getContextPath()%>/PenaltySystemAction.do?param=savePenaltySystem',
                            method: 'POST',
                            params: {
                                buttonValue: buttonValue,
                                CustId: Ext.getCmp('custcomboId').getValue(),
                                date: Ext.getCmp('date').getValue(),
                                assetId: Ext.getCmp('VehicleNumberId').getValue(),
                                penaltyId: Ext.getCmp('PenaltyTypeId').getValue(),
                                id:id
                            },
                            success: function (response, options) {
                                var message = response.responseText;
                                Ext.example.msg(message);
                                Ext.getCmp('date').reset();
                                Ext.getCmp('VehicleNumberId').reset();
                                Ext.getCmp('vehicleTypeLabelId').reset();
                                Ext.getCmp('districtLabelId').reset();
                                Ext.getCmp('governmentLabelId').reset();
                                Ext.getCmp('departmentLabelId').reset();
                                Ext.getCmp('PenaltyTypeId').reset();
                                Ext.getCmp('amountLabelId').reset();
                                Ext.getCmp('driverNameLabelId').reset();
                                Ext.getCmp('driverNumberLabelId').reset();
                                myWin.hide();

                                PenaltySystemOuterPanelWindow.getEl().unmask();
                                store.load({
                                    params: {
                                        CustId: Ext.getCmp('custcomboId').getValue(),
                                        startdate: Ext.getCmp('startdate').getValue(),
  		                                enddate: Ext.getCmp('enddate').getValue(),
 		                                jspName:jspName
                                    }
                                });
                            },
                            failure: function () {
                                 Ext.example.msg("Error");
                                 store.reload();
                                 myWin.hide();
                            }
                        });
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
                fn: function () {
                    myWin.hide();
                }
            }
        }
    }]
});

var PenaltySystemOuterPanelWindow = new Ext.Panel({
    width: 400,
    height: 420,
    standardSubmit: true,
    frame: true,
    items: [innerPanelForPenaltySystemDetails, innerWinButtonPanel]
});

myWin = new Ext.Window({
    title: titelForInnerPanel,
    closable: false,
    resizable: false,
    modal: true,
    autoScroll: false,
    height: 433,
    width: 410,
    id: 'myWin',
    items: [PenaltySystemOuterPanelWindow]
});

function addRecord() {
    if (Ext.getCmp('custcomboId').getValue() == "") {
         Ext.example.msg("<%=SelectCustomerName%>");
         Ext.getCmp('custcomboId').focus();
         return;
    }
    buttonValue = '<%=Add%>';
    titelForInnerPanel = '<%=PenaltySystem%>';
    myWin.setPosition(450, 50);
    myWin.show();
    myWin.setTitle(titelForInnerPanel);
    Ext.getCmp('VehicleNumberId').reset();
    Ext.getCmp('VehicleNumberId').setDisabled(false);
    Ext.getCmp('date').setDisabled(false);
    Ext.getCmp('date').reset();
    Ext.getCmp('VehicleNumberId').reset();
    Ext.getCmp('vehicleTypeLabelId').reset();
    Ext.getCmp('districtLabelId').reset();
    Ext.getCmp('governmentLabelId').reset();
    Ext.getCmp('departmentLabelId').reset();
    Ext.getCmp('driverNameLabelId').reset();
    Ext.getCmp('driverNumberLabelId').reset();
    Ext.getCmp('PenaltyTypeId').reset();
    Ext.getCmp('amountLabelId').reset();
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
    titelForInnerPanel = '<%=ModifyDetails%>';
    myWin.setPosition(450, 50);
    myWin.setTitle(titelForInnerPanel);
    myWin.show();
    var selected = grid.getSelectionModel().getSelected();
    Ext.getCmp('date').setValue(selected.get('DateDataIndex'));
    Ext.getCmp('VehicleNumberId').setValue(selected.get('VehicleNoDataIndex'));
    Ext.getCmp('vehicleTypeLabelId').setValue(selected.get('VehicleTypeDataIndex'));
    Ext.getCmp('districtLabelId').setValue(selected.get('DistrictDataIndex'));
    Ext.getCmp('governmentLabelId').setValue(selected.get('GovernmentDataIndex'));
    Ext.getCmp('departmentLabelId').setValue(selected.get('DepartmentDataIndex'));
    Ext.getCmp('driverNameLabelId').setValue(selected.get('DriverNameDataIndex'));
    Ext.getCmp('driverNumberLabelId').setValue(selected.get('DriverContactNoDataIndex'));
    Ext.getCmp('PenaltyTypeId').setValue(selected.get('PenaltyTypeDataIndex'));
    Ext.getCmp('amountLabelId').setValue(selected.get('AmountDataIndex'));
    Ext.getCmp('VehicleNumberId').setDisabled(true);
   	Ext.getCmp('date').setDisabled(true);
}    

var reader = new Ext.data.JsonReader({
    idProperty: 'PenaltySystemId',
    root: 'PenaltySystemRoot',
    totalProperty: 'total',
    fields: [{
        name: 'slnoIndex'
    },{
    	name: 'IndexIdDataIndex'
    },{
        name: 'DateDataIndex'
    },{
        name: 'VehicleNoDataIndex'
    }, {
        name: 'VehicleTypeDataIndex'
    },{
        name: 'DriverNameDataIndex'
	}, {
        name: 'DriverContactNoDataIndex'
    }, {
        name: 'DistrictDataIndex'
    },{
        name: 'DepartmentDataIndex'
    },{
        name: 'GovernmentDataIndex'
    },{
        name: 'PenaltyTypeDataIndex'
    },{
        name: 'AmountDataIndex'
    }]
});

var store = new Ext.data.GroupingStore({
    autoLoad: false,
    proxy: new Ext.data.HttpProxy({
        url: '<%=request.getContextPath()%>/PenaltySystemAction.do?param=getPenaltySystemDetails',
        method: 'POST'
    }),
    storeId: 'PenaltySystemId',
    reader: reader
});

var filters = new Ext.ux.grid.GridFilters({
    local: true,
    filters: [{
        type: 'numeric',
        dataIndex: 'slnoIndex'
    },{
    	type:'numeric',
    	dataIndex: 'IndexIdDataIndex'
    }, {
        type: 'date',
        dataIndex: 'DateDataIndex'
    }, {
        type: 'string',
        dataIndex: 'VehicleNoDataIndex'
    }, {
        type: 'string',
        dataIndex: 'VehicleTypeDataIndex'
    },{
        type: 'string',
        dataIndex: 'DriverNameDataIndex'
    },{
        type: 'numeric',
        dataIndex: 'DriverContactNoDataIndex'
    },{
        type: 'string',
        dataIndex: 'DistrictDataIndex'
    },{
        type: 'string',
        dataIndex: 'DepartmentDataIndex'
    },{
        type: 'string',
        dataIndex: 'GovernmentDataIndex'
    },{	
    	type: 'String',
        dataIndex: 'PenaltyTypeDataIndex'
    },{
    	type: 'numeric',
        dataIndex: 'AmountDataIndex'
    }]
});

var createColModel = function (finish, start) {
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
            dataIndex: 'IndexIdDataIndex',
            hidden: true,
            header: "<span style=font-weight:bold;><%=ID%></span>",
            filter: {
                type: 'numeric'
            }
        },{
            header: "<span style=font-weight:bold;><%=Date%></span>",
            dataIndex: 'DateDataIndex',
            width: 100,
            filter: {
                type: 'date'
            }
        }, {
            header: "<span style=font-weight:bold;><%=VehicleNo%></span>",
            dataIndex: 'VehicleNoDataIndex',
            width: 100,
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;><%=VehicleType%></span>",
            dataIndex: 'VehicleTypeDataIndex',
            width: 100,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=DriverName%></span>",
            dataIndex: 'DriverNameDataIndex',
            width: 100,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=DriverContactNo%></span>",
            dataIndex: 'DriverContactNoDataIndex',
            width: 100,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=District%></span>",
            dataIndex: 'DistrictDataIndex',
            width: 100,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=Department%></span>",
            dataIndex: 'DepartmentDataIndex',
            width: 100,
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;><%=Government%></span>",
            dataIndex: 'GovernmentDataIndex',
            width: 100,
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;><%=PenaltyType%></span>",
            dataIndex: 'PenaltyTypeDataIndex',
            width: 100,
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;><%=Amount%></span>",
            dataIndex: 'AmountDataIndex',
            width: 100,
            filter: {
                type: 'numeric'
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
grid = getGrid('<%=PenaltySystemDetails%>','<%=NoRecordsFound%>', store, screen.width - 40, 420, 14, filters, '<%=ClearFilterData%>', false, '', 16, false, '', false, '', true, '<%=Export%>', jspName, exportDataType, true, '<%=PDF%>', true, '<%=Add%>',true,'<%=Modify%>');
//******************************************************************************************************************************************************
Ext.onReady(function () {
    ctsb = tsb;
    Ext.QuickTips.init();
    Ext.form.Field.prototype.msgTarget = 'side';
    outerPanel = new Ext.Panel({
        title: '<%=PenaltySystem%>',
        renderTo: 'content',
        standardSubmit: true,
        frame: true,
        width: screen.width-28,
        height: 540,
        cls: 'outerpanel',
        layout: 'table',
        layoutConfig: {
            columns: 1
        },
        items: [customerComboPanel, grid]
    });
});</script>
<jsp:include page="../Common/footer.jsp" />
 <!-- </body>   -->
 <!-- </html> -->
