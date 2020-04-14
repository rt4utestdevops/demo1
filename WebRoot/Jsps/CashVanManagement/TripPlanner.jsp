<%@ page language="java"
	import="java.util.*,java.text.SimpleDateFormat,t4u.functions.*,t4u.beans.*,t4u.common.*"
	pageEncoding="utf-8"%>
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
tobeConverted.add("Trip_Planner_Details");
tobeConverted.add("Trip_Planner");
tobeConverted.add("Create_Trip");
tobeConverted.add("Modify_Trip");
tobeConverted.add("Close_Trip");
tobeConverted.add("Trip_No");
tobeConverted.add("Vehicle_Number");
tobeConverted.add("Hub");
tobeConverted.add("ROUTE");
tobeConverted.add("SLNO");
tobeConverted.add("Select_Customer");
tobeConverted.add("No_Records_Found");
tobeConverted.add("Trip_Planning");
tobeConverted.add("Clear_Filter_Data");
tobeConverted.add("Excel");
tobeConverted.add("Select_Hub");
tobeConverted.add("Select_Route_Name");
tobeConverted.add("Select_Vehicle_Number");
tobeConverted.add("Select_Atm");
tobeConverted.add("Select_Driver_Name");
tobeConverted.add("Select_Gunman_1");
tobeConverted.add("Select_Gunman_2");
tobeConverted.add("Save");
tobeConverted.add("Cancel");  
tobeConverted.add("Validate_Mesg_For_Form");
tobeConverted.add("Select_Customer_Name");
tobeConverted.add("No_Rows_Selected");
tobeConverted.add("Select_Single_Row");
tobeConverted.add("Trip_Closure_Details");
tobeConverted.add("Trip_Closing_Date_Time");
tobeConverted.add("Modify");
tobeConverted.add("Modify_Details");
tobeConverted.add("Select_Region");
tobeConverted.add("Select_Location");
tobeConverted.add("Trip_Closing_Hub");
tobeConverted.add("Region");
tobeConverted.add("Location");
tobeConverted.add("Select_All_Atms");
tobeConverted.add("Delete");
tobeConverted.add("Error");
tobeConverted.add("Enter_Trip_Close_Date");
tobeConverted.add("ATM");
tobeConverted.add("Route_Name");
tobeConverted.add("Driver_Name");
tobeConverted.add("Gunman_1");
tobeConverted.add("Gunman_2");
tobeConverted.add("Customer_Name");
tobeConverted.add("Status");
tobeConverted.add("Start_Date");
tobeConverted.add("Trip_Closed_Date");
tobeConverted.add("Trip_Start_Date");
tobeConverted.add("Cannot_Modify_If_Trip_Is_Closed");
tobeConverted.add("Trip_Already_Closed");
tobeConverted.add("End_Date_Must_Be_Greater_Than_Start_Date");
tobeConverted.add("Please_Enter_Opening_Odometer");
tobeConverted.add("Opening_Odometer");
tobeConverted.add("Select_Start_Date");
tobeConverted.add("Closing_Odometer");
tobeConverted.add("Enter_Closing_Odometer");
tobeConverted.add("Select_Custodian_Name1");
tobeConverted.add("Select_Custodian_Name2");
tobeConverted.add("Custodian_Name1");
tobeConverted.add("Custodian_Name2");
tobeConverted.add("Business_Details");
tobeConverted.add("Route_Id");

ArrayList<String> convertedWords = new ArrayList<String>();
convertedWords = cf.getLanguageSpecificWordForKey(tobeConverted,language);
String TripPlannerDetails=convertedWords.get(0);
String TripPlannerInformation=convertedWords.get(1);
String CreateTrip=convertedWords.get(2);
String ModifyTrip=convertedWords.get(3);
String CloseTrip=convertedWords.get(4);
String TripNo=convertedWords.get(5);
String VehicleNumber=convertedWords.get(6);
String Hub=convertedWords.get(7);
String Route=convertedWords.get(8);
String SLNO=convertedWords.get(9);
String SelectClient=convertedWords.get(10);
String NoRecordsFound=convertedWords.get(11);
String TripPlanning=convertedWords.get(12);
String ClearFilterData=convertedWords.get(13);
String Excel=convertedWords.get(14);
String SelectHub=convertedWords.get(15);
String SelectRouteName=convertedWords.get(16);
String SelectVehicleNumber=convertedWords.get(17);
String SelectATM=convertedWords.get(18);
String SelectDriverName=convertedWords.get(19);
String SelectGunman1=convertedWords.get(20);
String SelectGunman2=convertedWords.get(21);
String Save=convertedWords.get(22);
String Cancel=convertedWords.get(23);  
String ValidateMesgForForm=convertedWords.get(24);
String SelectCustomerName=convertedWords.get(25);
String NoRowsSelected=convertedWords.get(26);
String SelectSingleRow=convertedWords.get(27);
String TripClosureDetails=convertedWords.get(28);
String TripClosingDateTime=convertedWords.get(29);
String Modify=convertedWords.get(30);
String ModifyDetails=convertedWords.get(31);
String SelectRegion=convertedWords.get(32);
String SelectLocation=convertedWords.get(33);
String TripClosingLocation=convertedWords.get(34);
String Region=convertedWords.get(35);
String Location=convertedWords.get(36);
String selectAtm=convertedWords.get(37);
String Delete=convertedWords.get(38);
String Error=convertedWords.get(39);
String EnterDateTime=convertedWords.get(40);
String ATM=convertedWords.get(41);
String RouteName=convertedWords.get(42);
String DriverName=convertedWords.get(43);
String Gunman1=convertedWords.get(44);
String Gunman2=convertedWords.get(45);
String CustomerName=convertedWords.get(46);
String Status=convertedWords.get(47);
String StartedDate=convertedWords.get(48);
String TripClosedDate=convertedWords.get(49);
String TripCreationDate=convertedWords.get(50);
String CannotModifyIfTripIsClosed=convertedWords.get(51);
String TripAlreadyClosed = convertedWords.get(52);
String EndDateMustBeGreaterthanStartDate = convertedWords.get(53);
String EnterOpeningOdometer=convertedWords.get(54);
String OpeningOdometer=convertedWords.get(55);
String SelectTripCreationDate=convertedWords.get(56);
String ClosingOdometer=convertedWords.get(57);
String EnterClosingOdometer=convertedWords.get(58);
String SelectCustodianName1=convertedWords.get(59);
String SelectCustodianName2=convertedWords.get(60);
String CustodianName1=convertedWords.get(61);
String CustodianName2=convertedWords.get(62);
String BusinessDetail=convertedWords.get(63);
String RouteId=convertedWords.get(64);
%>


<jsp:include page="../Common/header.jsp" />
		<title>Trip Planner</title>

	
		<%if (loginInfo.getStyleSheetOverride().equals("Y")){%>
		<jsp:include page="../Common/ImportJSSandMining.jsp" />
		<%}else {%>
		<jsp:include page="../Common/ImportJS.jsp" />
		<%} %>
		<jsp:include page="../Common/ExportJS.jsp" />
		<style>
		label {
			display : inline !important;
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
		
		.x-window-tl *.x-window-header {
			height : 38px !important;
		}
   </style>
		<script><!--
var dtcur = datecur;
var outerPanel;
var jspName = "Trip Planner";
var exportDataType = "";
var titelForInnerPanel;
var titelForInnerDelPanel;
var checkGroup = [];
var id;
var buttonValue;
var regionModify = 0;;
var locationModify;
var hubModify;
var routeNameModify;
var custodianNameModify;
var vehicleNoModify;
var driverNameModify;
var gunman1Modify;
var gunman2Modify;
var tripNo;
var atmLs;
var atmcheckstore = new Ext.data.JsonStore({
    url: '<%=request.getContextPath()%>/CMSDashBoardAction.do?param=getATM',
    id: 'atmcheckStoreId',
    root: 'atmRoot',
    autoLoad: true,
    fields: ['Id','atmId', 'atmName','customer','businessId','onAccountDataIndex'],
    listeners: {
        load: function() {
            	   	
        }
    }
});



var onAccountStore = new Ext.data.JsonStore({
    url: '<%=request.getContextPath()%>/CMSDashBoardAction.do?param=getCustomerMasterDetails',
    id: 'onAccountStoreId',
    root: 'customerMasterRoot',
    autoLoad: true,
    fields: ['CustomerId','CompanyNameDataIndex'],
     listeners: {
        load: function() {
        
        }}});

var onAccountCombo = new Ext.form.ComboBox({
    store: onAccountStore,
    id: 'onAccountComboId',
    mode: 'local',
    hidden: true,
    forceSelection: true,
    emptyText: 'Select One',
    blankText: 'Select One',
    lazyRender: true,
    selectOnFocus: true,
    allowBlank: true,
    autoload: true,
    anyMatch: true,
    typeAhead: false,
    triggerAction: 'all',
    valueField: 'CustomerId',
    displayField: 'CompanyNameDataIndex',
    cls: 'selectstylePerfect',
    listeners: {
        select: {
            fn: function() {}
        }
    }
});

var gunman2store = new Ext.data.JsonStore({
    url: '<%=request.getContextPath()%>/CMSDashBoardAction.do?param=getGunman',
    id: 'gunman2StoreId',
    root: 'gunman1Root',
    autoLoad: false,
    fields: ['gunman1Name','gunman1Id']
 });

var gunman2combo = new Ext.form.ComboBox({
    store: gunman2store,
    id: 'gunman2comboId',
    mode: 'local',
    hidden: false,
    forceSelection: true,
    emptyText: '<%=SelectGunman2%>',
    blankText: '<%=SelectGunman2%>',
    lazyRender: true,
    selectOnFocus: true,
    allowBlank: true,
    autoload: true,
    anyMatch: true,
    typeAhead: false,
    triggerAction: 'all',
    valueField: 'gunman1Id',
    displayField: 'gunman1Name',
    cls: 'selectstylePerfect',
    listeners: {
        select: {
            fn: function() {}
        }
    }
});

var gunmanstore = new Ext.data.JsonStore({
    url: '<%=request.getContextPath()%>/CMSDashBoardAction.do?param=getGunman',
    id: 'gunman1StoreId',
    root: 'gunman1Root',
    autoLoad: false,
    fields: ['gunman1Name','gunman1Id']
});

var gunman1combo = new Ext.form.ComboBox({
    store: gunmanstore,
    id: 'gunman1comboId',
    mode: 'local',
    hidden: false,
    forceSelection: true,
    emptyText: '<%=SelectGunman1%>',
    blankText: '<%=SelectGunman1%>',
    lazyRender: true,
    selectOnFocus: true,
    allowBlank: true,
    autoload: true,
    anyMatch: true,
    typeAhead: false,
    triggerAction: 'all',
    valueField: 'gunman1Id',
    displayField: 'gunman1Name',
    cls: 'selectstylePerfect',
    listeners: {
        select: {
            fn: function() {}
        }
    }
});
var custodianstore = new Ext.data.JsonStore({
    url: '<%=request.getContextPath()%>/CMSDashBoardAction.do?param=getCustoName',
    id: 'custoStoreId',
    root: 'custoNameRoot',
    autoLoad: false,
    fields: ['custoName']
});
var custodian1store = new Ext.data.JsonStore({
    url: '<%=request.getContextPath()%>/CMSDashBoardAction.do?param=getCustodianName',
    id: 'custodian1StoreId',
    root: 'custodianNameRoot',
    autoLoad: false,
    fields: ['custodianName','custodianId']
});

var custodian1combo = new Ext.form.ComboBox({
    store: custodian1store,
    id: 'custodian1comboId',
    mode: 'local',
    hidden: false,
    forceSelection: true,
    emptyText: '<%=SelectCustodianName1%>',
    blankText: '<%=SelectCustodianName1%>',
    lazyRender: true,
    selectOnFocus: true,
    allowBlank: true,
    autoload: true,
    anyMatch: true,
    typeAhead: false,
    triggerAction: 'all',
    valueField: 'custodianId',
    displayField: 'custodianName',
    cls: 'selectstylePerfect',
    listeners: {
        select: {
            fn: function() {}
        }
    }
});

var custodian2store = new Ext.data.JsonStore({
    url: '<%=request.getContextPath()%>/CMSDashBoardAction.do?param=getCustodianName',
    id: 'custodian2StoreId',
    root: 'custodianNameRoot',
    autoLoad: false,
    fields: ['custodianName','custodianId']
});

var custodian2combo = new Ext.form.ComboBox({
    store: custodian2store,
    id: 'custodian2comboId',
    mode: 'local',
    hidden: false,
    forceSelection: true,
    emptyText: '<%=SelectCustodianName2%>',
    blankText: '<%=SelectCustodianName2%>',
    lazyRender: true,
    selectOnFocus: true,
    allowBlank: true,
    autoload: true,
    anyMatch: true,
    typeAhead: false,
    triggerAction: 'all',
    valueField: 'custodianId',
    displayField: 'custodianName',
    cls: 'selectstylePerfect',
    listeners: {
        select: {
            fn: function() {}
        }
    }
});

var driverstore = new Ext.data.JsonStore({
    url: '<%=request.getContextPath()%>/CMSDashBoardAction.do?param=getDriverName',
    id: 'driverStoreId',
    root: 'driverNameRoot',
    autoLoad: false,
    fields: ['driverName','driverId']
});

var drivercombo = new Ext.form.ComboBox({
    store: driverstore,
    id: 'drivercomboId',
    mode: 'local',
    hidden: false,
    forceSelection: true,
    emptyText: '<%=SelectDriverName%>',
    blankText: '<%=SelectDriverName%>',
    lazyRender: true,
    selectOnFocus: true,
    allowBlank: true,
    autoload: true,
    anyMatch: true,
    typeAhead: false,
    triggerAction: 'all',
    valueField: 'driverId',
    displayField: 'driverName',
    cls: 'selectstylePerfect',
    listeners: {
        select: {
            fn: function() {}
        }
    }
});

var vehiclestore = new Ext.data.JsonStore({
    url: '<%=request.getContextPath()%>/CMSDashBoardAction.do?param=getVehicleNo',
    id: 'vehicleStoreId',
    root: 'vehicleNoRoot',
    autoLoad: false,
    fields: ['vehicleNoName']
});

var vehiclecombo = new Ext.form.ComboBox({
    store: vehiclestore,
    id: 'vehiclecomboId',
    mode: 'local',
    hidden: false,
    forceSelection: true,
    emptyText: '<%=SelectVehicleNumber%>',
    blankText: '<%=SelectVehicleNumber%>',
    lazyRender: true,
    selectOnFocus: true,
    allowBlank: true,
    autoload: true,
    anyMatch: true,
    typeAhead: false,
    triggerAction: 'all',
    valueField: 'vehicleNoName',
    displayField: 'vehicleNoName',
    cls: 'selectstylePerfect',
    listeners: {
        select: {
            fn: function() {}
        }
    }
});


var routestore = new Ext.data.JsonStore({
    url: '<%=request.getContextPath()%>/CMSDashBoardAction.do?param=getRoute',
    id: 'routeStoreId',
    root: 'routeRoot',
    autoLoad: false,
    fields: ['routeId','routeName']
});

var routecombo = new Ext.form.ComboBox({
    store: routestore,
    id: 'routecomboId',
    mode: 'local',
    hidden: false,
    forceSelection: true,
    emptyText: '<%=SelectRouteName%>',
    blankText: '<%=SelectRouteName%>',
    lazyRender: true,
    selectOnFocus: true,
    allowBlank: true,
    autoload: true,
    anyMatch: true,
    typeAhead: false,
    triggerAction: 'all',
    valueField: 'routeId',
    displayField: 'routeName',
    cls: 'selectstylePerfect',
    listeners: {
        select: {
            fn: function() {

tripSheetNoStore.load({
                    params: {
                        custId: Ext.getCmp('clientcomboId').getValue(),
                        routeId: Ext.getCmp('routecomboId').getValue(),
                        date:Ext.getCmp('tripCreationDtId').getValue()
                             }
                });

                custodianstore.load({
				    params: {
				    routeId:Ext.getCmp('routecomboId').getValue(),
				    custId: Ext.getCmp('clientcomboId').getValue()
				    },
			    callback: function() {
			    var rec=custodianstore.getAt(0);
			      if(typeof rec == 'undefined' ){
			         custoValue='';
			      }
			      else{
			        custoValue=rec.data['custoName'];
			        }
			        if(buttonValue=='Create Trip'){
			        Ext.getCmp('custodian1comboId').setValue(custoValue);
			        }
			      }
			    });
			    Ext.getCmp('tripSheetNocomboId').reset();
			    atmGrid.store.clearData();
  		        atmGrid.view.refresh();
            }
        }
    }
});

var regionstore = new Ext.data.JsonStore({
    url: '<%=request.getContextPath()%>/CMSDashBoardAction.do?param=getRegion',
    id: 'regionStoreId',
    root: 'regionRoot',
    autoLoad: false,
    fields: ['regionName']
});

var regioncombo = new Ext.form.ComboBox({
    store: regionstore,
    id: 'regioncomboId',
    mode: 'local',
    hidden: false,
    forceSelection: true,
    emptyText: '<%=SelectRegion%>',
    blankText: '<%=SelectRegion%>',
    lazyRender: true,
    selectOnFocus: true,
    allowBlank: true,
    anyMatch: true,
    typeAhead: false,
    triggerAction: 'all',
    valueField: 'regionName',
    displayField: 'regionName',
    cls: 'selectstylePerfect',
    listeners: {
        select: {
            fn: function() {
               
                Ext.getCmp('routecomboId').reset();
               routestore.load({
                    params: {
                        custId: Ext.getCmp('clientcomboId').getValue(),
                       // regionId: Ext.getCmp('regioncomboId').getValue(),
                             }
                });
            }
        }
    }
});

var tripSheetNoStore = new Ext.data.JsonStore({
    url: '<%=request.getContextPath()%>/CMSDashBoardAction.do?param=getTripSheetNo',
    id: 'TripSheetNoStoreId',
    root: 'TripSheetNoRoot',
    autoLoad: false,
    fields: ['TripSheetNo']
});


var tripSheetNocombo = new Ext.form.ComboBox({
    store: tripSheetNoStore,
    id: 'tripSheetNocomboId',
    mode: 'local',
    hidden: false,
    forceSelection: true,
    emptyText: 'Select Trip Sheet',
    blankText: 'Select Trip Sheet',
    lazyRender: true,
    selectOnFocus: true,
    allowBlank: true,
    anyMatch: true,
    typeAhead: false,
    triggerAction: 'all',
    valueField: 'TripSheetNo',
    displayField: 'TripSheetNo',
    cls: 'selectstylePerfect',
    listeners: {
        select: {
            fn: function() {
                atmcheckstore.load({
        
                    params: {
                        custId: Ext.getCmp('clientcomboId').getValue(),
                        tripSheetNo: Ext.getCmp('tripSheetNocomboId').getValue()
                       
                    }
                });  
       
            }
        }
    }
});


var innerPanelForTripPlanDelDetails = new Ext.form.FormPanel({
    standardSubmit: true,
    collapsible: false,
    autoScroll: false,
    height: 135,
    width: 400,
    frame: true,
    id: 'innerPanelForTripPlanDelDetailsId',
    layout: 'table',
    layoutConfig: {
        columns: 4
    },
    items: [{
        xtype: 'fieldset',
        title: '<%=TripClosureDetails%>',
        cls: 'fieldsetpanel',
        collapsible: false,
        colspan: 4,
        id: 'TripClosureDetailsId',
        width: 380,
        height:120,
        layout: 'table',
        layoutConfig: {
            columns: 4
        },
        items: [
      
      
        {
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'tripClosureDateTimeEmptyId1'
        },
        {
            xtype: 'label',
            text: '<%=TripClosingDateTime%>' + ' :',
            cls: 'labelstyle',
            id: 'tripClosureDateTimeLabelId'
        }, {
            xtype: 'datefield',
            cls: 'selectstylePerfect',
            id: 'tripClosureDateTimeId',
            readOnly: true,
            format:getDateTimeFormat()
        },{
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'tripClosureDateTimeEmptyId2'
        },
        {
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'closingOdometerEmptyId1'
        },
        {
            xtype: 'label',
            text: '<%=ClosingOdometer%>' + ' :',
            cls: 'labelstyle',
            id: 'closingOdometerLabelId'
        }, {
            xtype: 'numberfield',
            cls: 'selectstylePerfect',
            emptyText: '<%=EnterClosingOdometer%>',
            id: 'closingOdometerId',
        }, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'closingOdometerEmptyId2'
        }]
    }]
});
var innerWinButtonDelPanel = new Ext.Panel({
    id: 'innerWinButtonDelPanelId',
    standardSubmit: true,
    collapsible: false,
    autoHeight: true,
    height: 150,
    width: 410,
    frame: true,
    layout: 'table',
    layoutConfig: {
        columns: 4
    },
    buttons: [{
        xtype: 'button',
        text: '<%=CloseTrip%>',
        id: 'saveButtonDelId',
        iconCls:'closeTripbuttonS',
        cls: 'buttonstyle',
        width: 70,
        listeners: {
            click: {
                fn: function() {
      				
                    if(Ext.getCmp('tripClosureDateTimeId').getValue()=="") {
                   		Ext.example.msg("<%=EnterDateTime%>");
                        return;
                    }
                     var selected = grid.getSelectionModel().getSelected();
                    if (dateCompare(selected.get('tripCreationDateDataIndex'),Ext.getCmp('tripClosureDateTimeId').getValue()) == -1) {
                             Ext.example.msg("<%=EndDateMustBeGreaterthanStartDate%>");
                             Ext.getCmp('enddate').focus();
                             return;
                       }
                    if(Ext.getCmp('closingOdometerId').getValue()=="") {
                   		Ext.example.msg("<%=EnterClosingOdometer%>");
                        return;
                    }
                    if (Ext.getCmp('closingOdometerId').getValue() <= selected.get('openingOdometerDataIndex')) {
                             Ext.example.msg("Closing Odometer Should Be Greater Than Opening Odometer");
                             Ext.getCmp('closingOdometerId').focus();
                             return;
                       }
                         if ( selected.get('statusDataIndex') != 'Armory Closed' ) {
                             Ext.example.msg("Trip Can Be Closed Only If All Armory Assets Are Closed.");                           
                             return;
                       }
                    if (innerPanelForTripPlanDelDetails.getForm().isValid()) {
                    	
                        var selected = grid.getSelectionModel().getSelected();
                        tripPlanDelOuterPanelWindow.getEl().mask();
                        Ext.Ajax.request({
                            url: '<%=request.getContextPath()%>/CMSDashBoardAction.do?param=deleteData',
                            method: 'POST',
                            params: {
                                custId: Ext.getCmp('clientcomboId').getValue(),
                             
                                tripCloseDate: Ext.getCmp('tripClosureDateTimeId').getValue(),
                                tripNo: selected.get('tripNoDataIndex'),
                                closingOdometer:Ext.getCmp('closingOdometerId').getValue(),
                                tripshtNo:selected.get('tripSheetNoDataIndex'),
                                vehicleNo:selected.get('vehicleNoDataIndex'),
                                tripStartDt:selected.get('tripCreationDateDataIndex'),
                            },
                            success: function(response, options) {
                                var message = response.responseText;
                               Ext.example.msg(message);
                               
                                Ext.getCmp('tripClosureDateTimeId').reset();
                                Ext.getCmp('closingOdometerId').reset();
                                myWin2.hide();
                                tripPlanDelOuterPanelWindow.getEl().unmask();
                                store.load({
                                    params: {
                                        custId: Ext.getCmp('clientcomboId').getValue()
                                    }
                                });
                                 vehiclestore.load({
			                       params: {
			                        custId: Ext.getCmp('clientcomboId').getValue()
			                    }
			                });
                            },
                            failure: function() {
                            Ext.example.msg("Error");
                                
                                store.reload();
                                myWin2.hide();
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
        id: 'canButtDelId',
        cls: 'buttonstyle',
        iconCls: 'cancelbutton',
        width: 70,
     listeners: {
            click: {
                fn: function() {
                Ext.getCmp('closingOdometerId').reset();
                 store.reload();
                 myWin2.hide();
                }
                }
                }
    }]
});
var tripPlanDelOuterPanelWindow = new Ext.Panel({
    width: 420,
    height: 190,
    standardSubmit: true,
    frame: true,
    items: [innerPanelForTripPlanDelDetails, innerWinButtonDelPanel]
 });
myWin2 = new Ext.Window({
    title: titelForInnerPanel,
    closable: false,
    resizable: false,
    modal: true,
    autoScroll: false,
    height: 250,
    width: 420,
    id: 'myWin2',
    items: [tripPlanDelOuterPanelWindow]
});
var businessTripTypeSelect = new Ext.grid.CheckboxSelectionModel();/*{
    listeners:{
        rowselect : function( selectionModel, rowIndex, record){
        var companies="";
            var selectedRows = selectionModel.getSelections();
           if( selectedRows.length > 0){
              
                    for( var i = 0; i < selectedRows.length; i++) {
                       companies=companies+selectedRows[i].data.customer+",";
                       console.log(companies)
                    }
             
              custodian1store.load({
                    params: {
                        custId: Ext.getCmp('clientcomboId').getValue(),
                        regionId: Ext.getCmp('regioncomboId').getValue(),
                        companies:companies
                             }
                });
                // More code related to deselection of a chekbox
            }
           
        }
    }
});

*/


var atmGrid =  new Ext.grid.EditorGridPanel({
    id: 'businessGridId',
    store: atmcheckstore,
   // listeners : {
//'celldblclick' : cellClickEvent //add cell click event
//},
    columns: [
        {
        header:'Trip Type',
          dataIndex: 'atmName',
        },
        {
        header:'Customer',
        dataIndex: 'customer',
        },{
        header:'Business ID',
        dataIndex: 'businessId'
        }, {
        header: 'On Account',
       sortable: true,
       width: 220,
       dataIndex: 'onAccountDataIndex'
      // hideable: true,
      // renderer: getSupervisorName,
       //editor: new Ext.grid.GridEditor(onAccountCombo),
      // renderer: vehicleModelRenderer
}
    ],
    sm: businessTripTypeSelect,
    plugins: filters,
    stripeRows: true,
    border: true,
    frame: false,
    width: 530,
    height: 145,
    style: 'margin-left:5px;',
    cls: 'bskExtStyle'
});

var innerPanelForOwnerDetails = new Ext.form.FormPanel({
    standardSubmit: true,
    collapsible: false,
    autoScroll: true,
    height: 330,
    width: 730,
    frame: true,
    id: 'innerPanelForOwnerDetailsId',
    layout: 'table',
    layoutConfig: {
        columns: 4
    },
    items: [{
        xtype: 'fieldset',
        title: '<%=TripPlannerDetails%>',
        cls: 'fieldsetpanel',
        collapsible: false,
        colspan: 3,
        id: 'TripPlannerInformationId',
        width:700,
        layout: 'table',
        layoutConfig: {
            columns: 4
        },
        items: [
        {
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'tripCreationDtEmptyId1'
        },
        {
            xtype: 'label',
            text: '<%=TripCreationDate%>' + ' :',
            cls: 'labelstyle',
            id: 'tripCreationDtLabelId'
        }, 
        {
            xtype: 'datefield',
            //readOnly: true,
            minValue:new Date(),
            cls: 'selectstylePerfect',
            id: 'tripCreationDtId',
           // value:dtcur,
            format:getDateTimeFormat()
            
        }, 

         {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'selectRegionEmptyId2'
        },   
        {
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'selectRouteEmptyId1'
        },
        
        {
            xtype: 'label',
            text: '<%=RouteName%>' + ' :',
            cls: 'labelstyle',
            id: 'selectRouteLabelId'
        }, routecombo, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'selectRouteEmptyId2'
        }, 
       {
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'selectRegionEmptyId1'
        },
        {
            xtype: 'label',
            text: ' Trip Sheet No' + ' :',
            cls: 'labelstyle',
            id: 'selectRegionLabelId'
        }, tripSheetNocombo,{
         xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'selectRouteEmptyId22'
        },
        
        
        {
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'selectATMEmptyId1'
        },
        
        {
            xtype: 'label',
            text: '<%=BusinessDetail%>' + ' :',
            cls: 'labelstyle',
            id: 'selectATMLabelId',
            height: 100
        },  atmGrid, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'selectATMEmptyId2'
        },   {
            xtype: 'label',
            text: ' ' + ' ',
            cls: 'labelstyle',
            id: 'empty'
        }, {
            xtype: 'label',
            text: ' '+' ',
            cls: 'mandatoryfield',
            id: 'empty1'
        }, {
            xtype: 'label',
            text: ' '+' ',
            cls: 'mandatoryfield',
            id: 'empty2'
        },
         {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'custodianNameEmptyId1'
        },

        {
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'openingOdometerDtEmptyId1'
        },
        {
            xtype: 'label',
            text: '<%=OpeningOdometer%>' + ' :',
            cls: 'labelstyle',
            id: 'openingOdometerDtLabelId'
        }, {
            xtype: 'numberfield',
            cls: 'selectstylePerfect',
            blankText: '<%=EnterOpeningOdometer%>',
            emptyText: '<%=EnterOpeningOdometer%>',
            id: 'openingOdometerId'
        }, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'openingOdometerEmptyId2'
        },{
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'selectcustodian1EmptyId1'
        },
        {
            xtype: 'label',
            text: '<%=CustodianName1%>' + ' :',
            cls: 'labelstyle',
            id: 'selectcustodian1LabelId'
        }, custodian1combo, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'selectcustodian1EmptyId2'
        }, 
        {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'selectcustodian2EmptyId1'
        },
        {
            xtype: 'label',
            text: '<%=CustodianName2%>' + ' :',
            cls: 'labelstyle',
            id: 'selectcustodian2LabelId'
        },  custodian2combo, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'selectcustodian2EmptyId2'
        },
        {
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'selectVehicleNumberEmptyId1'
        },
        
         {
            xtype: 'label',
            text: '<%=VehicleNumber%>' + ' :',
            cls: 'labelstyle',
            id: 'selectVehicleNumberLabelId'
        },  vehiclecombo, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'selectVehicleNumberId2'
        }, 
         {
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'selectDriverNameEmptyId1'
        },
        {
            xtype: 'label',
            text: '<%=DriverName%>' + ' :',
            cls: 'labelstyle',
            id: 'selectDriverNameLabelId'
        }, drivercombo, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'selectDriverNameEmptyId2'
        }, 
         {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'selectGunman1EmptyId1'
        },
        {
            xtype: 'label',
            text: '<%=Gunman1%>' + ' :',
            cls: 'labelstyle',
            id: 'selectGunman1LabelId'
        }, gunman1combo, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'selectGunman1EmptyId2'
        }, 
        {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'selectGunman2EmptyId1'
        },
        
        {
            xtype: 'label',
            text: '<%=Gunman2%>' + ' :',
            cls: 'labelstyle',
            id: 'selectGunman2LabelId'
        },  gunman2combo, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'selectGunman2EmptyId2'
        }]
    }]
});

var innerWinButtonPanel = new Ext.Panel({
    id: 'innerWinButtonPanelId',
    standardSubmit: true,
    collapsible: false,
    autoHeight: true,
    height: 70,
    width:730,
    frame: true,
    layout: 'table',
    layoutConfig: {
        columns: 4
    },
    buttons: [{
        xtype: 'button',
        text: '<%=Save%>',
        id: 'saveButtonId',
        iconCls: 'savebutton',
        cls: 'buttonstyle',
        width: 70,
        listeners: {
            click: {
                fn: function() {
                    if (Ext.getCmp('clientcomboId').getValue() == "") {
                    Ext.example.msg("<%=SelectCustomerName%>");
                        return;
                    }
                    
                    if (Ext.getCmp('routecomboId').getValue() == "") {
                    Ext.example.msg("<%=SelectRouteName%>");
                                                return;
                    }
                    if (Ext.getCmp('tripSheetNocomboId').getValue() == "") {
                    Ext.example.msg("Select Trip Sheet No");
                        return;
                    }
                    if (Ext.getCmp('openingOdometerId').getValue() == "") {
                    Ext.example.msg("<%=EnterOpeningOdometer%>");
                        return;
                    }
                    if (Ext.getCmp('custodian1comboId').getValue() == "") {
                    Ext.example.msg("<%=SelectCustodianName1%>");
                        return;
                    }
                    if (Ext.getCmp('custodian2comboId').getValue() == Ext.getCmp('custodian1comboId').getValue()) {
                    Ext.example.msg("Custodian1 and Custodian2 Can't be Same");
                        return;
                    }
                    if (Ext.getCmp('vehiclecomboId').getValue() == "") {
                    Ext.example.msg("<%=SelectVehicleNumber%>");
                        return;
                    }
                    if (Ext.getCmp('drivercomboId').getValue() == "") {
                    Ext.example.msg("<%=SelectDriverName%>");
                    
                        return;
                    }
                    if(Ext.getCmp('gunman1comboId').getValue() != "" && Ext.getCmp('gunman2comboId').getValue() != ""){
	                    if (Ext.getCmp('gunman2comboId').getValue() == Ext.getCmp('gunman1comboId').getValue()) {
	                    Ext.example.msg("Gunman1 and Gunman2 Can't be Same");
	                        return;
                    }
                    }
                    var tobeDeleted;
                    if (buttonValue == 'Modify') {
                        var selected = grid.getSelectionModel().getSelected();
                        id = selected.get('uniqueIdDataIndex');
                        tripNo = selected.get('tripNoDataIndex');
<!--                        if (selected.get('regionDataIndex') != Ext.getCmp('regioncomboId').getValue()) {-->
<!--                            regionModify = Ext.getCmp('regioncomboId').getValue();-->
<!--                        } else {-->
<!--                            regionModify = selected.get('regionDataIndex');-->
<!--                        }-->
                        if (selected.get('routeNameDataIndex') != Ext.getCmp('routecomboId').getValue()) {
                            routeNameModify = Ext.getCmp('routecomboId').getRawValue();
                        } else {
                            routeNameModify = selected.get('routeNameDataIndex');
                        }
                        if (selected.get('vehicleNoDataIndex') != Ext.getCmp('vehiclecomboId').getValue()) {
                            vehicleNoModify = Ext.getCmp('vehiclecomboId').getValue();
                        } else {
                            vehicleNoModify = selected.get('vehicleNoDataIndex');
                        }
                        if (selected.get('driverNameDataIndex') != Ext.getCmp('drivercomboId').getValue()) {
                            driverNameModify = Ext.getCmp('drivercomboId').getValue();
                        } else {
                            driverNameModify = selected.get('driverNameDataIndex');
                        }
                        if (selected.get('gunman1DataIndex') != Ext.getCmp('gunman1comboId').getValue()) {
                            gunman1Modify = Ext.getCmp('gunman1comboId').getValue();
                        } else {
                            gunman1Modify = selected.get('gunman1DataIndex');
                        }
                        if (selected.get('gunman2DataIndex') != Ext.getCmp('gunman2comboId').getValue()) {
                            gunman2Modify = Ext.getCmp('gunman2comboId').getValue();
                        } else {
                            gunman2Modify = selected.get('gunman2DataIndex');
                        }
                       
                    }
                    if (innerPanelForOwnerDetails.getForm()
                        .isValid()) {
                        ownerMasterOuterPanelWindow.getEl().mask();
                        Ext.Ajax.request({
                            url: '<%=request.getContextPath()%>/CMSDashBoardAction.do?param=tripPlannerAddAndModify',
                            method: 'POST',
                            params: {
                                buttonValue: buttonValue,
                                custId: Ext.getCmp('clientcomboId').getValue(),
                                region: "0",
                                routeName: Ext.getCmp('routecomboId').getRawValue(),
                                routeId: Ext.getCmp('routecomboId').getValue(),
                                atmList: "0",
                                tripCreationDt: Ext.getCmp('tripCreationDtId').getValue(),
                                openingOdometer: Ext.getCmp('openingOdometerId').getValue(),
                                custodianName1: Ext.getCmp('custodian1comboId').getValue(),
                                custodianName2: Ext.getCmp('custodian2comboId').getValue(),
                                vehicleNo: Ext.getCmp('vehiclecomboId').getValue(),
                                driverName: Ext.getCmp('drivercomboId').getValue(),
                                gunman1: Ext.getCmp('gunman1comboId').getValue(),
                                gunman2: Ext.getCmp('gunman2comboId').getValue(),
                                id: id,
                                regionModify: regionModify,
                                routeNameModify: routeNameModify,
                                vehicleNoModify: vehicleNoModify,
                                driverNameModify: driverNameModify,
                                gunman1Modify: gunman1Modify,
                                gunman2Modify: gunman2Modify,
                                tripNo: tripNo,
                                tobeDeleted: tobeDeleted,
                                tripsheetNo:Ext.getCmp('tripSheetNocomboId').getValue()
                            },
                            success: function(response, options) {
                                var message = response.responseText;
                                Ext.example.msg(message);
                                
                                myWin.hide();
                                ownerMasterOuterPanelWindow.getEl().unmask();
                                store.load({
                                    params: {
                                        custId: Ext.getCmp('clientcomboId').getValue()
                                    }
                                });
                                atmcheckstore.load({
                                    params: {}
                                });
                                 vehiclestore.load({
			                       params: {
			                        custId: Ext.getCmp('clientcomboId').getValue()
			                    }
			                });
			                   // Ext.getCmp('regioncomboId').reset();
                                                              
                                Ext.getCmp('routecomboId').reset();
                                Ext.getCmp('tripSheetNocomboId').reset();
                                Ext.getCmp('tripCreationDtId').reset();
                                Ext.getCmp('openingOdometerId').reset();
                                Ext.getCmp('custodian1comboId').reset();
                                Ext.getCmp('custodian2comboId').reset();
                                Ext.getCmp('vehiclecomboId').reset();
                                Ext.getCmp('drivercomboId').reset();
                                Ext.getCmp('gunman1comboId').reset();
                                Ext.getCmp('gunman2comboId').reset();
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
var ownerMasterOuterPanelWindow = new Ext.Panel({
    width:740,
    height:400,
    standardSubmit: true,
    frame: true,
    items: [innerPanelForOwnerDetails, innerWinButtonPanel]
});

myWin = new Ext.Window({
    title: titelForInnerPanel,
    closable: false,
    resizable: false,
    modal: true,
    autoScroll: false,
    height: 450,
    width: 750,
    id: 'myWin',
    items: [ownerMasterOuterPanelWindow]
});

function addRecord() {
	routestore.load({
        params: {
            custId: Ext.getCmp('clientcomboId').getValue()
        }
    });
    vehiclestore.load({
         params: {
             custId: Ext.getCmp('clientcomboId').getValue()
         }
     });
     gunmanstore.load({
         params: {
             custId: Ext.getCmp('clientcomboId').getValue()
         }
     });
     gunman2store.load({
         params: {
             custId: Ext.getCmp('clientcomboId').getValue()
         }
     });
     driverstore.load({
         params: {
             custId: Ext.getCmp('clientcomboId').getValue()
         }
     });
     custodian1store.load({
         params: {
            custId: Ext.getCmp('clientcomboId').getValue()
         }
     });
     custodian2store.load({
         params: {
             custId: Ext.getCmp('clientcomboId').getValue()
         }
    });
 	var  custoValue;
    if (Ext.getCmp('clientcomboId').getValue() == "") {
    Ext.example.msg("<%=SelectClient%>");
        return;
    }
    buttonValue = '<%=CreateTrip%>';
    titelForInnerPanel = '<%=TripPlannerInformation%>';
    myWin.setPosition(250, 100);
    myWin.show();
    myWin.setTitle(titelForInnerPanel);
    atmcheckstore.removeAll();
    routestore.removeAll();
    atmGrid.getStore().removeAll();
    //Ext.getCmp('regioncomboId').reset();
  
     Ext.getCmp('routecomboId').reset();
     Ext.getCmp('tripSheetNocomboId').reset();
    Ext.getCmp('tripCreationDtId').reset();
    Ext.getCmp('openingOdometerId').reset();
    Ext.getCmp('custodian1comboId').reset();
    Ext.getCmp('custodian2comboId').reset();
    Ext.getCmp('vehiclecomboId').reset();
    Ext.getCmp('drivercomboId').reset();
    Ext.getCmp('gunman1comboId').reset();
    Ext.getCmp('gunman2comboId').reset();
    //Ext.getCmp('regioncomboId').enable();
   
     Ext.getCmp('routecomboId').enable();
     Ext.getCmp('tripSheetNocomboId').enable();
    Ext.getCmp('tripCreationDtId').enable();
    Ext.getCmp('openingOdometerId').enable();
    Ext.getCmp('custodian1comboId').enable();
    Ext.getCmp('custodian2comboId').enable();
    Ext.getCmp('vehiclecomboId').enable();
    Ext.getCmp('drivercomboId').enable();
    Ext.getCmp('gunman1comboId').enable();
    Ext.getCmp('gunman2comboId').enable();
    
    dtcur = new Date();
    Ext.getCmp('tripCreationDtId').setValue(dtcur);
}
function modifyData() {
 var selected = grid.getSelectionModel().getSelected();
    if(selected.get('statusDataIndex')=='Closed') {
    Ext.example.msg("<%=CannotModifyIfTripIsClosed%>");
        return;
    }
    if (Ext.getCmp('clientcomboId').getValue() == "") {
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
    var selected = grid.getSelectionModel().getSelected();
    myWin.setPosition(250, 100);
    myWin.show();
    myWin.setTitle(titelForInnerPanel);
    Ext.getCmp('clientcomboId').show();
    //Ext.getCmp('regioncomboId').show();
 
     Ext.getCmp('routecomboId').show();
     Ext.getCmp('tripSheetNocomboId').show();
    Ext.getCmp('tripCreationDtId').show();
    Ext.getCmp('openingOdometerId').show();
    Ext.getCmp('custodian1comboId').show();
    Ext.getCmp('custodian2comboId').show();
    Ext.getCmp('vehiclecomboId').show();
    Ext.getCmp('drivercomboId').show();
    Ext.getCmp('gunman1comboId').show();
    Ext.getCmp('gunman2comboId').show();
    //Ext.getCmp('regioncomboId').disable();
    
    Ext.getCmp('routecomboId').disable();
     Ext.getCmp('tripSheetNocomboId').disable();
    Ext.getCmp('tripCreationDtId').disable();
    Ext.getCmp('openingOdometerId').disable();
    Ext.getCmp('custodian1comboId').disable();
    Ext.getCmp('custodian2comboId').disable();
    Ext.getCmp('vehiclecomboId').disable();
    Ext.getCmp('drivercomboId').disable();
    Ext.getCmp('gunman1comboId').disable();
    Ext.getCmp('gunman2comboId').disable();
    var selected = grid.getSelectionModel().getSelected();
    //Ext.getCmp('regioncomboId').setValue(selected.get('regionDataIndex'));
  
    Ext.getCmp('routecomboId').setValue(selected.get('routeNameDataIndex'));
    Ext.getCmp('tripCreationDtId').setValue(selected.get('tripCreationDateDataIndex'));
     Ext.getCmp('tripSheetNocomboId').setValue(selected.get('tripSheetNoDataIndex'));
    Ext.getCmp('openingOdometerId').setValue(selected.get('openingOdometerDataIndex'));
    Ext.getCmp('custodian1comboId').setValue(selected.get('custodian1DataIndex'));
    Ext.getCmp('custodian2comboId').setValue(selected.get('custodian2DataIndex'));
    Ext.getCmp('vehiclecomboId').setValue(selected.get('vehicleNoDataIndex'));
    Ext.getCmp('drivercomboId').setValue(selected.get('driverNameDataIndex'));
    Ext.getCmp('gunman1comboId').setValue(selected.get('gunman1DataIndex'));
    Ext.getCmp('gunman2comboId').setValue(selected.get('gunman2DataIndex'));
<!--    if (selected.get('regionDataIndex') != Ext.getCmp('regioncomboId').getValue()) {-->
<!--        regionModify1 = Ext.getCmp('regioncomboId').getValue();-->
<!--    } else {-->
<!--        regionModify1 = selected.get('regionDataIndex');-->
<!--    }-->

    if (selected.get('routeNameDataIndex') != Ext.getCmp('routecomboId').getValue()) {
        routeModify1 = Ext.getCmp('routecomboId').getValue();
    } else {
        routeModify1 = selected.get('routeNameDataIndex');
    }

 var selected2 = grid.getSelectionModel().getSelected();
                	var tripshtNo = selected2.get('tripSheetNoDataIndex');
	  atmcheckstore.load({
        
                    params: {
                        custId: Ext.getCmp('clientcomboId').getValue(),
                        tripSheetNo: tripshtNo
                       
                    }
                }); 
}

function closetripsummary() {

var selected = grid.getSelectionModel().getSelected();
    if(selected.get('statusDataIndex')=='Closed') {
    	Ext.example.msg("<%=TripAlreadyClosed%>");
        return;
    } 
    
    if (Ext.getCmp('clientcomboId').getValue() == "") {
    	Ext.example.msg("<%=SelectCustomerName%>");
        Ext.getCmp('clientcomboId').focus();
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
    buttonValue = '<%=Delete%>';
    var selected = grid.getSelectionModel().getSelected();
    titelForInnerPanel = '<%=CloseTrip%>'; 
    dtcur = new Date();
    Ext.getCmp('tripClosureDateTimeId').setValue(dtcur);
    myWin2.setPosition(450, 150);
    myWin2.show();
    myWin2.setTitle(titelForInnerPanel);
}
var reader = new Ext.data.JsonReader({
    idProperty: 'tripPlanReaderId',
    root: 'tripPlannerRoot',
    totalProperty: 'total',
    fields: [{
        name: 'slnoIndex',
    }, {
        name: 'uniqueIdDataIndex',
    }, {
        name: 'tripNoDataIndex'
    },  {
        name: 'tripSheetNoDataIndex'
    },  
    {
        name: 'vehicleNoDataIndex'
    }, 
<!--    {-->
<!--        name: 'regionDataIndex'-->
<!--    }, -->
    {
        name: 'routeNameDataIndex'
    }, {
        name: 'atmsDataIndex'
    }, {
        name: 'driverNameDataIndex'
    }, {
        name: 'gunman1DataIndex'
    }, {
        name: 'gunman2DataIndex'
    },{
        name: 'tripCreationDateDataIndex',
        type: 'date',
        format: getDateTimeFormat()
    },{
        name: 'openingOdometerDataIndex'
    }, {
        name: 'closingOdometerDataIndex'
    },{
        name: 'custodian1DataIndex'
    }, {
        name: 'custodian2DataIndex'
    }, {
        name: 'statusDataIndex'
    }, {
        name: 'startDateDataIndex',
        type: 'date',
        format: getDateTimeFormat()
    }, {
        name: 'closedDateDataIndex',
        type: 'date',
        format: getDateTimeFormat()
        }, {
        name: 'routeIdDataIndex',
        
    }]
});
var store = new Ext.data.GroupingStore({
    autoLoad: false,
    proxy: new Ext.data.HttpProxy({
        url: '<%=request.getContextPath()%>/CMSDashBoardAction.do?param=getTripPlannerReport',
        method: 'POST'
    }),
    storeId: 'tripPlannerId',
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
        type: 'string',
        dataIndex: 'tripNoDataIndex'
    },{
        type: 'string',
        dataIndex: 'tripSheetNoDataIndex'
    }, {
        type: 'string',
        dataIndex: 'vehicleNoDataIndex'
    },
<!--     {-->
<!--        type: 'string',-->
<!--        dataIndex: 'regionDataIndex'-->
<!--    },-->
     {
        type: 'string',
        dataIndex: 'routeNameDataIndex'
    }, {
        type: 'string',
        dataIndex: 'atmsDataIndex'
    }, {
        type: 'string',
        dataIndex: 'driverNameDataIndex'
    },
<!--     {-->
<!--        type: 'string',-->
<!--        dataIndex: 'gunman1DataIndex'-->
<!--    },-->
     {
        type: 'string',
        dataIndex: 'gunman2DataIndex'
    },{
        type: 'date',
        dataIndex: 'tripCreationDateDataIndex'
    }, {
        type: 'numeric',
        dataIndex: 'openingOdometerDataIndex'
    },{
        type: 'numeric',
        dataIndex: 'closingOdometerDataIndex'
    },{
        type: 'string',
        dataIndex: 'custodian1DataIndex'
    }, {
        type: 'string',
        dataIndex: 'custodian2DataIndex'
    }, {
        type: 'string',
        dataIndex: 'statusDataIndex'
    }, {
        type: 'date',
        dataIndex: 'startDateDataIndex'
    },{
        type: 'date',
        dataIndex: 'closedDateDataIndex'
    },{
        type: 'string',
        dataIndex: 'routeIdDataIndex'
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
            dataIndex: 'tripNoDataIndex',
            header: "<span style=font-weight:bold;><%=TripNo%></span>",
            width: 360,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;>Trip Sheet No</span>",
            dataIndex: 'tripSheetNoDataIndex',
             hidden:false,
            width: 360,
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;><%=VehicleNumber%></span>",
            dataIndex: 'vehicleNoDataIndex',
            width: 360,
            filter: {
                type: 'string'
            }
        },
        
<!--         {-->
<!--            header: "<span style=font-weight:bold;><%=Region%></span>",-->
<!--            dataIndex: 'regionDataIndex',-->
<!--            width: 360,-->
<!--            filter: {-->
<!--                type: 'string'-->
<!--            }-->
<!--        }, -->
        
        {
            header: "<span style=font-weight:bold;><%=Route%></span>",
            dataIndex: 'routeNameDataIndex',
            width: 360,
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;><%=TripCreationDate%></span>",
            dataIndex: 'tripCreationDateDataIndex',
            renderer: Ext.util.Format.dateRenderer(getDateTimeFormat()),
            width: 400,
            filter: {
                type: 'date'
            }
        },{
            header: "<span style=font-weight:bold;><%=OpeningOdometer%></span>",
            dataIndex: 'openingOdometerDataIndex',
            width: 420,
            filter: {
                type: 'numeric'
            }
        },{
            header: "<span style=font-weight:bold;><%=ClosingOdometer%></span>",
            dataIndex: 'closingOdometerDataIndex',
            width: 400,
            hidden:true,
            filter: {
                type: 'numeric'
            }
        },{
            header: "<span style=font-weight:bold;><%=Status%></span>",
            dataIndex: 'statusDataIndex',
            width: 360,
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;>CreatedDate</span>",
            dataIndex: 'startDateDataIndex',
            renderer: Ext.util.Format.dateRenderer(getDateTimeFormat()),
            hidden:true,
            width: 360,
            filter: {
                type: 'date'
            }
        },{
            header: "<span style=font-weight:bold;><%=TripClosedDate%></span>",
            dataIndex: 'closedDateDataIndex',
            renderer: Ext.util.Format.dateRenderer(getDateTimeFormat()),
            hidden:true,
            width: 360,
            filter: {
                type: 'date'
            }
      
         },{
            header: "<span style=font-weight:bold;><%=RouteId%></span>",
            dataIndex: 'routeIdDataIndex',
             hidden:true,
            width: 360,
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
grid = getGrid('<%=TripPlannerDetails%>', '<%=NoRecordsFound%>', store, screen.width - 40, 440, 19, filters, '<%=ClearFilterData%>', false, '', 16, false, '', false, '', false, '<%=Excel%>', jspName, exportDataType, false, 'PDF', true, '<%=CreateTrip%>', false, '<%=ModifyTrip%>', false, '',true, '<%=CloseTrip%>');
//******************************************************************************************************************************************************
var clientcombostore = new Ext.data.JsonStore({
    url: '<%=request.getContextPath()%>/CommonAction.do?param=getCustomer',
    id: 'clientStoreId',
    root: 'CustomerRoot',
    autoLoad: true,
    remoteSort: true,
    fields: ['CustId', 'CustName'],
    listeners: {
    load: function(custstore, records, success, options) {
            if ( <%= customerId %> > 0) {
            	Ext.getCmp('clientcomboId').setValue('<%=customerId%>');
                custId = Ext.getCmp('clientcomboId').getValue();
                store.load({
                    params: {
                        custId: Ext.getCmp('clientcomboId').getValue()
                    }
                });
              
                vehiclestore.load({
                    params: {
                        custId: Ext.getCmp('clientcomboId').getValue()
                    }
                });
                gunmanstore.load({
                    params: {
                        custId: Ext.getCmp('clientcomboId').getValue()
                    }
                });
                gunman2store.load({
                    params: {
                        custId: Ext.getCmp('clientcomboId').getValue()
                    }
                });
                driverstore.load({
                    params: {
                        custId: Ext.getCmp('clientcomboId').getValue()
                    }
                });
                custodian1store.load({
                    params: {
                       custId: Ext.getCmp('clientcomboId').getValue()
                    }
                });
                custodian2store.load({
                    params: {
                        custId: Ext.getCmp('clientcomboId').getValue()
                    }
               });
            }
          }
    }
});
var Client = new Ext.form.ComboBox({
    store: clientcombostore,
    id: 'clientcomboId',
    mode: 'local',
    forceSelection: true,
    emptyText: '<%=SelectClient%>',
    blankText: '<%=SelectClient%>',
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
                        custId: Ext.getCmp('clientcomboId').getValue()
                    }
                });
                        routestore.load({
                    params: {
                        custId: Ext.getCmp('clientcomboId').getValue(),
                       // regionId: Ext.getCmp('regioncomboId').getValue(),
                             }
                });
                vehiclestore.load({
                    params: {
                        custId: Ext.getCmp('clientcomboId').getValue()
                    }
                });
                gunmanstore.load({
                    params: {
                        custId: Ext.getCmp('clientcomboId').getValue()
                    }
                });
                gunman2store.load({
                    params: {
                        custId: Ext.getCmp('clientcomboId').getValue()
                    }
                });
                driverstore.load({
                    params: {
                        custId: Ext.getCmp('clientcomboId').getValue()
                    }
                });
                custodian1store.load({
                    params: {
                       custId: Ext.getCmp('clientcomboId').getValue()
                    }
                });
                custodian2store.load({
                    params: {
                        custId: Ext.getCmp('clientcomboId').getValue()
                    }
               });
            }
        }
    }
});
var ClientComboPanel = new Ext.Panel({
    standardSubmit: true,
    collapsible: false,
    id: 'clientComboPanelId',
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


// rederr for onAccount dropDown
	   function vehicleModelRenderer(value, p, r) {
	   		var returnValue="";
		 	if(onAccountStore.isFiltered()){
				onAccountStore.clearFilter();
			}
	        var idx = onAccountStore.findBy(function(record) {
	   		if(record.get('CustomerId') == value) {
	       		returnValue = record.get('CompanyNameDataIndex');
	       		return true;
	   		}   
			});
			r.data['modelStr']=returnValue;
			return returnValue;
		}
	// based on selected Atms need to fetch prefered custodians for all companies	
	function createCustodian(){
	   var selectedAtms;
                    selectedAtms = "-";
                    var recordAtms = atmGrid.getSelectionModel().getSelections();
                    for (var i = 0; i < recordAtms.length; i++) {
                        var recordEach = recordAtms[i];
                        var atmName = recordEach.data['atmId'];
                         var cvsCustomer = recordEach.data['customer'];
                         var onAccount = recordEach.data['onAccountDataIndex'];
                         }
	
	
	}
	
	 
Ext.onReady(function() {
   
    Ext.QuickTips.init();
    Ext.form.Field.prototype.msgTarget = 'side';
    outerPanel = new Ext.Panel({
        title: '<%=TripPlannerInformation%>',
        renderTo: 'content',
        standardSubmit: true,
        autoscroll: true,
        frame: true,
        width: screen.width - 22,
        cls: 'outerpanel',
        layoutConfig: {
            columns: 1
        },
        items: [ClientComboPanel,grid]
            
    });

    sb = Ext.getCmp('form-statusbar');
});



--></script>
		<script type="text/javascript">

//open popup business details
       function showPopup(){
      
    var OpenWindow = window.open('<%=request.getContextPath()%>'+'/Jsps/CashVanManagement/BusinessDetails.jsp', 'windowName', 'width=800,height=600,resizable=0');
OpenWindow.addEventListener("beforeunload", function(e){

         atmcheckstore.load({
        
                    params: {
                        custId: Ext.getCmp('clientcomboId').getValue(),
                        routeId: Ext.getCmp('routecomboId').getValue()
                       // region: Ext.getCmp('regioncomboId').getValue()
                        
                    }
                });
                onAccountStore.load({
                
                      params: {
                        CustId: Ext.getCmp('clientcomboId').getValue()
                        
                        }
                });
}, false);

}
</script>
	<jsp:include page="../Common/footer.jsp" />
 <!-- </body>   -->
 <!-- </html> -->
