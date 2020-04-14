 <%@ page  language="java" import="java.util.*,java.text.SimpleDateFormat,t4u.functions.*,t4u.beans.*,t4u.common.*" pageEncoding="utf-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
Properties prop = ApplicationListener.prop;
String RFIDwebServicePath=prop.getProperty("WebServiceUrlPathForRFID");
String WEIGHTwebServicePath=prop.getProperty("WebServiceUrlPathForWeight");
System.out.println(request.getParameter("list"));
if (request.getParameter("list") != null) {
		String list = request.getParameter("list").toString().trim();
		String[] str = list.split(",");
		int systemid = Integer.parseInt(str[0].trim());
		int customerid = Integer.parseInt(str[1].trim());
		int userid = Integer.parseInt(str[2].trim());
		String language = str[3].trim();
		LoginInfoBean loginInfo = new LoginInfoBean();
		LoginInfoBean loginInfo1=new LoginInfoBean();
		loginInfo1=(LoginInfoBean)session.getAttribute("loginInfoDetails");
		System.out.println(loginInfo1);
		if(loginInfo1!=null)
		{
		int isLtsp=loginInfo1.getIsLtsp();
		System.out.println("isltsp11== "+loginInfo1.getIsLtsp());
		loginInfo.setIsLtsp(isLtsp);
		}
		loginInfo.setSystemId(systemid);
		loginInfo.setCustomerId(customerid);
		loginInfo.setUserId(userid);
		loginInfo.setLanguage(language);
		loginInfo.setStyleSheetOverride("N");
		loginInfo.setZone(str[4].trim());
		loginInfo.setOffsetMinutes(Integer.parseInt(str[5].trim()));
		loginInfo.setSystemName(str[6].trim());
		loginInfo.setCategory(str[7].trim());
		if (str.length > 8) {
			loginInfo.setCustomerName(str[8].trim());
		}
		if (str.length > 9) {
			loginInfo.setCategoryType(str[9].trim());
		}
		if (str.length > 10) {
			loginInfo.setUserName(str[10].trim());
		}
		if (str.length > 11) {
			loginInfo.setStyleSheetOverride("N");
		}
		if(str.length>12){
		loginInfo.setCountryCode(Integer.parseInt(str[11].trim()));
		}
		session.setAttribute("loginInfoDetails", loginInfo);
	}
	CommonFunctions cf=new CommonFunctions();
	LoginInfoBean loginInfo=(LoginInfoBean)session.getAttribute("loginInfoDetails");
	if(loginInfo==null){
		response.sendRedirect(request.getContextPath()+ "/Jsps/Common/SessionDestroy.html");
	}
	else
	{   
	    session.setAttribute("loginInfoDetails", loginInfo);    
		String language = loginInfo.getLanguage();
		ArrayList<String> tobeConverted=new ArrayList<String>();
		tobeConverted.add("Mining_Trip_Sheet_Generation");
		tobeConverted.add("Please_Select_customer");
		tobeConverted.add("Select_Customer");
		tobeConverted.add("SLNO");
		tobeConverted.add("Type");
		tobeConverted.add("Asset_Number");
		tobeConverted.add("TC_Lease_Name");
		tobeConverted.add("Quantity");
		tobeConverted.add("Validity_Date_Time");
		tobeConverted.add("Grade_And_Mineral_Information");
		tobeConverted.add("ROUTE");
		tobeConverted.add("No_Records_Found");
		tobeConverted.add("Trip_Sheet_Number");
		tobeConverted.add("Enter_Trip_Sheet_Number");
		tobeConverted.add("Add_Trip_Sheet_Information");
		tobeConverted.add("Modify_Trip_Sheet_Information");
		tobeConverted.add("Select_Single_Row");
		tobeConverted.add("Select_Type");
		tobeConverted.add("select_vehicle_No");
		tobeConverted.add("Select_TC_Lease_Name");
		tobeConverted.add("Enter_Quantity");
		tobeConverted.add("Enter_Valid_Date_Time");
		tobeConverted.add("Enter_Grade_Minerals");
		tobeConverted.add("Enter_Route");
		tobeConverted.add("Select_Type");
		
		tobeConverted.add("Select_Route");
		tobeConverted.add("Select_Validity_Date");
		tobeConverted.add("Vehicle_No");
		tobeConverted.add("Enter_Vehicle_No");
		tobeConverted.add("Read_RFID");
		tobeConverted.add("Something_Wrong_in_RFID");
		tobeConverted.add("Grade_And_Mineral");
		tobeConverted.add("kgs");
		tobeConverted.add("Capture");
		tobeConverted.add("Capture_Quantity");
		tobeConverted.add("Something_Wrong_In_weight");
		tobeConverted.add("Save");
		tobeConverted.add("Cancel");
		
		ArrayList<String> convertedWords=new ArrayList<String>();
        convertedWords=cf.getLanguageSpecificWordForKey(tobeConverted,language);
        
		String MiningTripSheetGeneration=convertedWords.get(0);
		String pleaseSelectcustomer=convertedWords.get(1);
		String selectCustomer=convertedWords.get(2);
		String SLNO=convertedWords.get(3);
		String type=convertedWords.get(4);
		String assetNumber=convertedWords.get(5);
		String TCLeaseName=convertedWords.get(6);
		String quantity=convertedWords.get(7);
		String ValidityDateTime=convertedWords.get(8);
		String GradeandMineralInformation=convertedWords.get(9);
		String route=convertedWords.get(10);
		String noRecordsFound=convertedWords.get(11);
		String TripSheetNumber=convertedWords.get(12);
		String enterTripsheetNumber=convertedWords.get(13);
		String addTripSheetInformation=convertedWords.get(14);
		String modifyTripSheetInformation=convertedWords.get(15);
		String SelectSingleRow=convertedWords.get(16);
		String selectType=convertedWords.get(17);
		String selectVehicleNO=convertedWords.get(18);
		String selectTCLeaseName=convertedWords.get(19);
		String enterQuantity=convertedWords.get(20);
		String enterValidDateTime=convertedWords.get(21);
		String enterGradeMinerals=convertedWords.get(22);
		String enterRoute=convertedWords.get(23); 
		String SelectType=convertedWords.get(24);
	
		String SelectRoute=convertedWords.get(25);
		String SelectValidityDate=convertedWords.get(26);
		String VehicleNo=convertedWords.get(27);
		String EnterVehicleNo=convertedWords.get(28);
		String ReadRFID=convertedWords.get(29);
		String SomethingWronginRFID=convertedWords.get(30);
		String GradeAndMineral=convertedWords.get(31);
		String kgs=convertedWords.get(32);
		String Capture=convertedWords.get(33);
		String CaptureQuantity=convertedWords.get(34);
		String SomethingWronginweight=convertedWords.get(35);
		String Save=convertedWords.get(36);
		String Cancel=convertedWords.get(37);
		String Diverted_Quantity="Diverted Quantity";
		String Enter_Diverted_Quantity="Enter Diverted Quantity";
		
		int systemId = loginInfo.getSystemId();
		int userId=loginInfo.getUserId(); 
		int customerId = loginInfo.getCustomerId();
		String userAuthority=cf.getUserAuthority(systemId,userId);	
		String startDatePrev="";
		String endDatePrev="";
		String back="";
		if(request.getParameter("back") != null && !request.getParameter("back").equals("")){
		back = request.getParameter("back"); 
		}
		java.text.SimpleDateFormat format =new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		String startDate="";
		java.util.Date startDatePara=new java.util.Date();
		if(request.getParameter("startDate") != null && !request.getParameter("startDate").equals("")){
		startDate = request.getParameter("startDate");
		startDatePara=new java.util.Date(startDate.substring(0,24)); 
		if(startDate.contains("+0530")){
		   startDatePrev = startDate.replace("+0530 ", " ");
		}else{
		   startDatePrev = startDate.replace(" 0530 ", " ");
		}
		}
		String endDate="";
		java.util.Date endDatePara=new java.util.Date();
		if(request.getParameter("endDate") != null && !request.getParameter("endDate").equals("")){
		endDate = request.getParameter("endDate");
		endDatePara=new java.util.Date(endDate.substring(0,24)); 
		if(endDate.contains("+0530")){
		   endDatePrev = endDate.replace("+0530 ", " ");
		}else{
		   endDatePrev = endDate.replace(" 0530 ", " ");
		}
		}
		String custId="";
		if(request.getParameter("custId") != null && !request.getParameter("custId").equals("")){
		custId = request.getParameter("custId"); 
		}
		String custName="";
		if(request.getParameter("custName") != null && !request.getParameter("custName").equals("")){
		custName = request.getParameter("custName"); 
		}
		
	    String addButton="true";
	    String startButton="true";
	    String stopButton="true";
	    String closetrip="true";
	    String ltsp="true";
	    if(loginInfo.getIsLtsp()== 0)
	    {
	        addButton="true";
		    startButton="true";
	        stopButton="true";
	        closetrip="true";
	        ltsp="true";
	    }
	else if(loginInfo.getIsLtsp()== -1 && userAuthority.equalsIgnoreCase("User"))
		{
			addButton="true";
		    startButton="true";
	        stopButton="true";
	        closetrip="true";
	        
	        
		}else{
		    addButton="false";
		    startButton="false";
	        stopButton="false";
	        closetrip="false"; 
	        ltsp="false";
		}
	if(loginInfo.getIsLtsp()== -1){
		ltsp="false";
	}
%>

<!DOCTYPE HTML>
<html>
 <head>
 		<title>Trip Generation Report For Barge</title>		
</head>	    
	 <style>
  .x-panel-tl
	{
		border-bottom: 0px solid !important;
	}
	.quantityBox
	{
	background-color: white ;
    padding: 10px !important;
    width: 110px !important;
    height: 40px !important;
    margin: 10px !important;
    line-height: 20px !important;
    color: black;
    font-weight: bold !important;
    font-size: 2em !important;
    text-align: center !important;
	}
	.my-label-style {
    font-weight: bold; 
    font-size: 20px;
    text-align: center;
    margin-left: 20px;
}

.my-label-style1 {
    font-weight: bold; 
    font-size: 19px;
    text-align: center;
    margin-left: 20px;
}

.my-label-style2 {
    font-weight: bold; 
    font-size: 15px;
    text-align: center;
    margin-left: 22px !important;
}
.my-label-style3 {
    font-weight: bold; 
    font-size: 15px !important;
    text-align: center;
    margin-left: 23px;
}
.quantityBox1
	{
	background-color: white ;
<!--    padding: 10px !important;-->
<!--    width: 110px !important;-->
<!--    height: 40px !important;-->
<!--    margin: 10px !important;-->
<!--    line-height: 20px !important;-->
    color: black;
    font-weight: bold !important;
    font-size: 15px !important;
    text-align: center !important;
	}

  </style>
  <body>
   <%if (loginInfo.getStyleSheetOverride().equals("Y")){%>
	<jsp:include page="../Common/ImportJSSandMining.jsp"/>
	<%}else{%>
	<jsp:include page="../Common/ImportJS.jsp" /><%}%>
   <jsp:include page="../Common/ExportJS.jsp" />
   <script src="../../Main/Js/modernizr.custom.js"></script>
		<script src="../../Main/modules/common/homeScreen/js/digitalTimer.js"></script>
		<script src="../../Main/Js/jquery.js"></script>
        <script src="../../Main/Js/jquery-ui.js"></script>
   <script>
var grid;
var myWin;
var buttonValue;
var uniqueId;
var closewin;
var outerPanel;
var AssetNo;
var jspName = 'MiningTripSheetGenerationReport';
var exportDataType = "int,string,string,string,string,string,string,string,string,string,string,number,number,int,number,string,string";
var routeName;
var routeId;
var tcId;
var lesseName;
var routeNameForTare;
var routeIdForTare;
var tcIdForTare;
var lesseNameForTare;
var quantity1;
var srcHubId;
var desHubId;
var tripType;
var quantity;
var permitNo;
var pId;
var RFIDquantity;
var balance;
var userSettingId;
var orgName;
var orgCode;
var tareOrgName;
var tcNum;
var datenext = nextDate;
var dateprev = currentDate;
var back = '<%=back%>';
var startDate = '<%=startDate%>';
var sd = '<%=format.format(startDatePara)%>';
var endDate = '<%=endDate%>';
var ed = '<%=format.format(endDatePara)%>';
var custId = '<%=custId%>';
var custName = '<%=custName%>';
var bargeQuantity;
var canceltripWin;
var bargeLocId;
//--------------------------------------------------------------------------//
var Typecombostore = new Ext.data.SimpleStore({
    id: 'TypecombostoreId',
    autoLoad: true,
    fields: ['Name', 'Value'],
    data: [
        ['RFID', 'RFID'],
        ['APPLICATON', 'APPLICATION']
    ]
});

var typecombo = new Ext.form.ComboBox({
    store: Typecombostore,
    id: 'typecomboId',
    mode: 'local',
    forceSelection: true,
    selectOnFocus: true,
    resizable: true,
    allowBlank: false,
    anyMatch: true,
    typeAhead: false,
    triggerAction: 'all',
    lazyRender: true,
    valueField: 'Value',
    displayField: 'Name',
    cls: 'selectstylePerfect',
    blankText: '<%=selectType%>',
    emptyText: '<%=selectType%>',
    listeners: {
        select: {
            fn: function() {
                var cusId;
                if (back == '1') {
                    cusId = custId;
                } else {
                    cusId = Ext.getCmp('custcomboId').getValue();
                }
                vehicleComboStore.load({
                    params: {
                        CustId: cusId
                    }
                });
                var typeValue = Ext.getCmp('typecomboId').getValue();

                if (typeValue == 'RFID') {
                    Ext.getCmp('RFIDId').reset();
                   // Ext.getCmp('vehicleRFIDPanelId').show();
                    //Ext.getCmp('detailsFirstMaster').setHeight(40);
                    //Ext.getCmp('vehicleRFIDPanelId').setHeight(50);
                    Ext.getCmp('mandatoryVehicleId').hide();
                    Ext.getCmp('VehicleNoID').hide();
                    Ext.getCmp('vehiclecomboId').hide();

                    Ext.getCmp('mandatoryRfid').show();
                    Ext.getCmp('RFIDIDs').show();
                    Ext.getCmp('RFIDId').show();
                    Ext.getCmp('RFIDButtId').show();
                    Ext.getCmp('RFIDId').reset();
                    Ext.getCmp('RFIDId').setValue('');
                }
                if (typeValue == 'APPLICATION') {
                    Ext.getCmp('vehiclecomboId').reset();
                    //Ext.getCmp('vehicleRFIDPanelId').show();
                    // Ext.getCmp('detailsFirstMaster').setHeight(40);
                    // Ext.getCmp('vehicleRFIDPanelId').setHeight(50);

                    Ext.getCmp('mandatoryRfid').hide();
                    Ext.getCmp('RFIDIDs').hide();
                    Ext.getCmp('RFIDId').hide();
                    Ext.getCmp('RFIDButtId').hide();

                    Ext.getCmp('mandatoryVehicleId').show();
                    Ext.getCmp('VehicleNoID').show();
                    Ext.getCmp('vehiclecomboId').show();
                    Ext.getCmp('vehiclecomboId').reset();
                    Ext.getCmp('vehiclecomboId').setValue('');
                }
            }
        }
    }
});

var reasonComboStore = new Ext.data.SimpleStore({
    id: 'reasonStoreId',
    autoLoad: true,
    fields: ['Name', 'Value'],
    data: [
        ['1', '1'],
        ['2', '2'],
        ['3', '3'],
        ['4', '4']
    ]
});
var reasonCombo = new Ext.form.ComboBox({
    store: reasonComboStore,
    id: 'reasonComboId',
    mode: 'local',
    forceSelection: true,
    emptyText: 'Select Reason',
    blankText: 'Select Reason',
    resizable: true,
    selectOnFocus: true,
    anyMatch: true,
    typeAhead: false,
    triggerAction: 'all',
    lazyRender: true,
    valueField: 'Value',
    displayField: 'Name',
    cls: 'selectstylePerfect',
    listeners: {}
});

var reasonCombo1 = new Ext.form.ComboBox({
    store: reasonComboStore,
    id: 'reasonComboId1',
    mode: 'local',
    forceSelection: true,
    emptyText: 'Select Reason',
    blankText: 'Select Reason',
    resizable: true,
    selectOnFocus: true,
    anyMatch: true,
    typeAhead: false,
    triggerAction: 'all',
    lazyRender: true,
    valueField: 'Value',
    displayField: 'Name',
    cls: 'selectstylePerfect',
    listeners: {}
});
//************************ Store for Vehicel Number  Here***************************************//
var vehicleComboStore = new Ext.data.JsonStore({
    url: '<%=request.getContextPath()%>/TripSheetGenerationActionForBarge.do?param=getVehicleList',
    id: 'vehicleComboStoreId',
    root: 'vehicleComboStoreRoot',
    autoload: false,
    remoteSort: true,
    fields: ['vehicleNoID', 'vehicleName', 'quantity1', 'bargeQuantity']
});

var vehicleCombo = new Ext.form.ComboBox({
    store: vehicleComboStore,
    id: 'vehiclecomboId',
    mode: 'local',
    forceSelection: true,
    selectOnFocus: true,
    resizable: true,
    anyMatch: true,
    typeAhead: false,
    listWidth: 150,
    triggerAction: 'all',
    lazyRender: true,
    valueField: 'vehicleNoID',
    displayField: 'vehicleName',
    cls: 'selectstylePerfect',
    emptyText: 'Select Barge Name',
    blankText: 'Select Barge Name',
    listeners: {
        select: {
            fn: function() {
                var vehicleNo = Ext.getCmp('vehiclecomboId').getValue();
                var row = vehicleComboStore.findExact('vehicleNoID', vehicleNo);
                var rec = vehicleComboStore.getAt(row);
                Ext.getCmp('quantityId').setValue(rec.data['quantity1']);
                bargeQuantity = rec.data['bargeQuantity'];
                Ext.getCmp('tarequantityId').setValue(parseFloat(bargeQuantity) / 1000);
            }
        }
    }
});


//************************ Store for Route Name  Here***************************************//
var RouteComboStore = new Ext.data.JsonStore({
    url: '<%=request.getContextPath()%>/TripSheetGenerationAction.do?param=getRouteList',
    id: 'routeComboStoreId',
    root: 'routeComboStoreRoot',
    autoload: false,
    remoteSort: true,
    fields: ['routeId', 'routeName']
});

var routeCombo = new Ext.form.ComboBox({
    store: RouteComboStore,
    id: 'routecomboId',
    mode: 'local',
    forceSelection: true,
    selectOnFocus: true,
    resizable: true,
    allowBlank: false,
    anyMatch: true,
    typeAhead: false,
    listWidth: 150,
    triggerAction: 'all',
    lazyRender: true,
    valueField: 'routeId',
    displayField: 'routeName',
    cls: 'selectstylePerfect',
    emptyText: '<%=SelectRoute%>',
    blankText: '<%=SelectRoute%>',
    listeners: {
        select: {
            fn: function() {

            }
        }
    }
});

var routeComboForTare = new Ext.form.ComboBox({
    store: RouteComboStore,
    id: 'routecomboIdforTare',
    mode: 'local',
    forceSelection: true,
    selectOnFocus: true,
    resizable: true,
    allowBlank: false,
    anyMatch: true,
    typeAhead: false,
    listWidth: 150,
    triggerAction: 'all',
    lazyRender: true,
    valueField: 'routeId',
    displayField: 'routeName',
    cls: 'selectstylePerfect',
    emptyText: '<%=SelectRoute%>',
    blankText: '<%=SelectRoute%>',
    listeners: {
        select: {
            fn: function() {

            }
        }
    }
});
//------------------------------validity Date-------------------------//

var StartDate = new Ext.form.DateField({
    width: 185,
    format: getDateTimeFormat(),
    id: 'startDateTime',
    value: datecur,
    //minValue:endDateMinVal,
    //maxValue: new Date(),
    vtype: 'daterange',
    cls: 'selectstylePerfect',
    blankText: '<%=SelectValidityDate%>',
    allowBlank: false,
    listeners: {
        select: {
            fn: function() {

                } 
        } 
    } 
});

var StartDateForTare = new Ext.form.DateField({
    width: 185,
    format: getDateTimeFormat(),
    id: 'startDateTimeForTare',
    value: datecur,
    vtype: 'daterange',
    cls: 'selectstylePerfect',
    blankText: '<%=SelectValidityDate%>',
    allowBlank: false,
    listeners: {
        select: {
            fn: function() {

                } //function
        } //select
    } //listeners
});

var tripStore = new Ext.data.JsonStore({
    url: '<%=request.getContextPath()%>/TripSheetGenerationAction.do?param=getTripDetails',
    id: 'tripStoreId',
    root: 'tripRoot',
    autoload: false,
    fields: ['sHubId', 'dHubId', 'type', 'userSettingId', 'bargeLocId'],
    listeners: {
        load: function() {}
    }
});

var bargeStore = new Ext.data.JsonStore({
    url: '<%=request.getContextPath()%>/TripSheetGenerationActionForBarge.do?param=getBargeStatus',
    id: 'tripStoreId',
    root: 'bargeroot',
    autoload: false,
    fields: ['status'],
    listeners: {
        load: function() {}
    }
});

var bargeStoreForStartBLO = new Ext.data.JsonStore({
    url: '<%=request.getContextPath()%>/TripSheetGenerationActionForBarge.do?param=getBargeStatus1',
    id: 'tripStoreId1',
    root: 'bargeroot1',
    autoload: false,
    fields: ['bargeName','status'],
    listeners: {
        load: function() {}
    }
});

var modifyTripDetails = new Ext.data.JsonStore({
    url: '<%=request.getContextPath()%>/TripSheetGenerationAction.do?param=getPermitBalForModify',
    id: 'tripStoreId',
    root: 'tripRoot',
    autoload: false,
    fields: ['quantity', 'tripSheetQty'],
    listeners: {
        load: function() {}
    }
});

var tripStoreForRfid = new Ext.data.JsonStore({
    url: '<%=request.getContextPath()%>/TripSheetGenerationAction.do?param=getRFIDForTareWeight',
    id: 'tripStoreIdForRfid',
    root: 'tripRoot',
    autoload: false,
    fields: ['routeName', 'lesseName', 'jsonString', 'grade', 'validityDate', 'orgName'],
    listeners: {
        load: function() {}
    }
});

var tripStoreForRfidAdd = new Ext.data.JsonStore({
    url: '<%=request.getContextPath()%>/TripSheetGenerationActionForBarge.do?param=getRFID',
    id: 'tripStoreIdForRfidAdd',
    root: 'tripRoot',
    autoload: false,
    fields: ['quantity1', 'jsonString', 'bargeQuantity'],
    listeners: {
        load: function() {}
    }
});

var tripStoreForTare = new Ext.data.JsonStore({
    url: '<%=request.getContextPath()%>/TripSheetGenerationAction.do?param=getTripDetailsForTare',
    id: 'tripStoreIdForTare',
    root: 'tripRoot',
    autoload: false,
    fields: ['routeId', 'routeName', 'tcId', 'lesseName'],
    listeners: {
        load: function() {}
    }
});

var orgNameStore = new Ext.data.JsonStore({
    url: '<%=request.getContextPath()%>/TripSheetGenerationActionForBarge.do?param=getOrgNameForBarge',
    id: 'orgStoreRoot',
    root: 'orgRoot',
    autoload: false,
    fields: ['orgName', 'orgId'],
    listeners: {
        load: function() {}
    }
});
var orgCombo = new Ext.form.ComboBox({
    store: orgNameStore,
    id: 'orgId',
    mode: 'local',
    forceSelection: true,
    emptyText: 'Select Organization',
    blankText: 'Select Organization',
    resizable: true,
    selectOnFocus: true,
    anyMatch: true,
    typeAhead: false,
    triggerAction: 'all',
    lazyRender: true,
    valueField: 'orgId',
    displayField: 'orgName',
    cls: 'selectstylePerfect',
    listeners: {}
});

//*********************** Store For Customer *****************************************//
var customercombostore = new Ext.data.JsonStore({
    url: '<%=request.getContextPath()%>/CommonAction.do?param=getCustomer',
    id: 'CustomerStoreId',
    root: 'CustomerRoot',
    autoLoad: true,
    remoteSort: true,
    fields: ['CustId', 'CustName'],
    listeners: {
        load: function(custstore, records, success, options) {
            if (<%= customerId %> > 0) {
                Ext.getCmp('custcomboId').setValue('<%=customerId%>');
                var cm = grid.getColumnModel();
                for (var j = 1; j < cm.getColumnCount(); j++) {
                    cm.setColumnWidth(j, 155);
                }
                vehicleComboStore.load({
                    params: {
                        CustId: Ext.getCmp('custcomboId').getValue()
                    }
                });
                tripStore.load({
                    params: {
                        CustID: Ext.getCmp('custcomboId').getValue(),
                    },
                    callback: function() {
                        for (var i = 0; i < tripStore.getCount(); i++) {
                            var rec = tripStore.getAt(i);
                            srcHubId = rec.data['sHubId'];
                            desHubId = rec.data['dHubId'];
                            tripType = rec.data['type'];
                            userSettingId = rec.data['userSettingId'];
                            bargeLocId = rec.data['bargeLocId'];
                        }
                    }
                });
            }
        }
    }
});

//************************ Combo for Customer Starts Here***************************************//
var custnamecombo = new Ext.form.ComboBox({
    store: customercombostore,
    id: 'custcomboId',
    mode: 'local',
    forceSelection: true,
    emptyText: '<%=pleaseSelectcustomer%>',
    selectOnFocus: true,
    resizable: true,
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
                var cm = grid.getColumnModel();
                for (var j = 1; j < cm.getColumnCount(); j++) {
                    cm.setColumnWidth(j, 155);
                }
                vehicleComboStore.load({
                    params: {
                        CustId: Ext.getCmp('custcomboId').getValue()
                    }
                });
                tripStore.load({
                    params: {
                        CustID: Ext.getCmp('custcomboId').getValue(),
                    },
                    callback: function() {
                        for (var i = 0; i < tripStore.getCount(); i++) {
                            var rec = tripStore.getAt(i);
                            srcHubId = rec.data['sHubId'];
                            desHubId = rec.data['dHubId'];
                            tripType = rec.data['type'];
                            userSettingId = rec.data['userSettingId'];
                            bargeLocId = rec.data['bargeLocId'];
                        }
                    }
                });
            }
        }
    }
});

var vesselNameStore = new Ext.data.JsonStore({
    url: '<%=request.getContextPath()%>/PermitDetailsAction.do?param=getVesselNames',
    root: 'vesselNameRoot',
    autoLoad: false,
    id: 'vesselNameIddd',
    fields: ['vesselName']
});
//****************************combo for Imported****************************************
var vesselNameCombo = new Ext.form.ComboBox({
    store: vesselNameStore,
    id: 'vesselNameId',
    mode: 'local',
    forceSelection: true,
    emptyText: 'Select Vessel Name',
    blankText: 'Select Vessel Name',
    selectOnFocus: true,
    allowBlank: true,
    anyMatch: true,
    typeAhead: false,
    resizable: true,
    triggerAction: 'all',
    lazyRender: true,
    valueField: 'vesselName',
    displayField: 'vesselName',
    cls: 'selectstylePerfect',
    listeners: {
        change: function(f, n, o) { //restrict 50
            if (f.getValue().length > 50) {
                Ext.example.msg("Field reached it's Maximum Size");
                f.setValue(n.substr(0, 50));
                f.focus();
            }
        }
    },
});
// **********************************************Reader configs Starts******************************

var reader = new Ext.data.JsonReader({
    idProperty: 'tripcreationId',
    root: 'miningTripSheetDetailsRoot',
    totalProperty: 'total',
    fields: [{
        name: 'slnoIndex'
    }, {
        name: 'TypeIndex'
    },  {
        name: 'wbsIndex'
    }, {
        name: 'TripSheetNumberIndex'
    }, {
        name: 'assetNoIndex'
    }, {
        name: 'assetIdIndex'
    }, {
        name: 'orgIndex'
    }, {
        name: 'validityDateDataIndex',
        type: 'date',
        dateFormat: getDateTimeFormat()
    }, {
        name: 'uniqueIDIndex'
    }, {
        name: 'statusIndexId'
    }, {
        name: 'q1IndexId'
    }, {
        name: 'QuantityIndex'
    }, {
        name: 'issuedIndexId'
    }, {
        name: 'issuedBy'
    }, {
        name: 'orgIdIndex'
    }, {
        name: 'bargeLocIndex'
    }, {
        name: 'flagIndex'
    }, {
        name: 'vesselNameIndex'
    }, {
        name: 'destinationIndex'
    }, {
        name: 'boatNote'
    }, {
        name: 'reason'
    }, {
        name: 'divQtyIndex'
    }, {
        name: 'closedDateIndex'
    }, {
        name: 'stopBLODateTimeIndexId',
        type: 'date',
        dateFormat: getDateTimeFormat()
    }, {
        name: 'wbdIndex'
    }]
});

// **********************************************Reader configs Ends******************************
//********************************************Store Configs For Grid*************************

var store = new Ext.data.GroupingStore({
    autoLoad: false,
    proxy: new Ext.data.HttpProxy({
        url: '<%=request.getContextPath()%>/TripSheetGenerationActionForBarge.do?param=getMiningTripSheetDetails',
        method: 'POST'
    }),
    remoteSort: false,
    storeId: 'miningTripsheetDetailsStore',
    reader: reader
});

//********************************************Store Configs For Grid Ends*************************
//********************************************************************Filter Config***************

var filters = new Ext.ux.grid.GridFilters({
    local: true,
    filters: [{
        type: 'numeric',
        dataIndex: 'slnoIndex'
    }, {
        type: 'string',
        dataIndex: 'TypeIndex'
    }, {
        type: 'string',
        dataIndex: 'wbsIndex'
    }, {
        type: 'string',
        dataIndex: 'TripSheetNumberIndex'
    }, {
        type: 'string',
        dataIndex: 'assetNoIndex'
    }, {
        type: 'string',
        dataIndex: 'assetIdIndex'
    }, {
        type: 'string',
        dataIndex: 'orgIndex'
    }, {
        type: 'date',
        dataIndex: 'validityDateDataIndex'
    }, {
        type: 'string',
        dataIndex: 'statusIndexId'
    }, {
        type: 'int',
        dataIndex: 'q1IndexId'
    }, {
        type: 'int',
        dataIndex: 'QuantityIndex'
    }, {
        type: 'string',
        dataIndex: 'issuedIndexId'
    }, {
        type: 'int',
        dataIndex: 'uniqueIDIndex'
    }, {
        type: 'string',
        dataIndex: 'vesselNameIndex'
    }, {
        type: 'string',
        dataIndex: 'destinationIndex'
    }, {
        type: 'string',
        dataIndex: 'boatNote'
    }, {
        type: 'string',
        dataIndex: 'reason'
    }, {
        type: 'string',
        dataIndex: 'divQtyIndex'
    }, {
        type: 'date',
        dataIndex: 'closedDateIndex'
    }, {
        type: 'date',
        dataIndex: 'stopBLODateTimeIndexId'
    }, {
        type: 'string',
        dataIndex: 'wbdIndex'
    }]
});

//***************************************************Filter Config Ends ***********************

//*********************************************Column model config**********************************
var createColModel = function(finish, start) {

    var columns = [
        new Ext.grid.RowNumberer({
            header: "<span style=font-weight:bold;>SLNO</span>",
            width: 50
        }), {
            dataIndex: 'slnoIndex',
            hidden: true,
            header: "<span style=font-weight:bold;><%=SLNO%></span>",
            filter: {
                type: 'numeric'
            }
        }, {
            header: "<span style=font-weight:bold;><%=type%></span>",
            dataIndex: 'TypeIndex',
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;>WB@S</span>",
            dataIndex: 'wbsIndex',
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=TripSheetNumber%></span>",
            dataIndex: 'TripSheetNumberIndex',
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;>Barge Name</span>",
            dataIndex: 'assetNoIndex',
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;>Asset Id</span>",
            dataIndex: 'assetIdIndex'
        }, {
            header: "<span style=font-weight:bold;>Organization Name</span>",
            dataIndex: 'orgIndex'
        }, {
            header: "<span style=font-weight:bold;>Issued Date</span>",
            dataIndex: 'issuedIndexId',
            filter: {
                type: 'string'
            },
            hidden: false
        }, {
            header: "<span style=font-weight:bold;>Stop BLO DateTime</span>",
            dataIndex: 'stopBLODateTimeIndexId',
            renderer: Ext.util.Format.dateRenderer(getDateTimeFormat()),
            filter: {
                type: 'date'
            },
            hidden: true
        }, {
            header: "<span style=font-weight:bold;><%=ValidityDateTime%></span>",
            dataIndex: 'validityDateDataIndex',
            renderer: Ext.util.Format.dateRenderer(getDateTimeFormat()),
            filter: {
                type: 'date'
            }
        }, {
            header: "<span style=font-weight:bold;>Status</span>",
            dataIndex: 'statusIndexId',
            hidden: false,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;>Barge Capacity</span>",
            dataIndex: 'QuantityIndex',
            sortable: true,
            align: 'right',
            filter: {
                type: 'int'
            }
        }, {
            header: "<span style=font-weight:bold;>Barge Quantity</span>",
            dataIndex: 'q1IndexId',
            //width: 110,    
            sortable: true,
            align: 'right',
            filter: {
                type: 'int'
            }
        }, {
            header: "<span style=font-weight:bold;>Unique Id</span>",
            dataIndex: 'uniqueIDIndex',
            hidden: true,
            sortable: true,
            filter: {
                type: 'int'
            }
        }, {
            header: "<span style=font-weight:bold;>Vessel Name</span>",
            dataIndex: 'vesselNameIndex',
            hidden: false,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;>Destination</span>",
            dataIndex: 'destinationIndex',
            hidden: false,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;>Boat Note</span>",
            dataIndex: 'boatNote',
            hidden: false,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;>Reason</span>",
            dataIndex: 'reason',
            hidden: false,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;>Unloaded Quantity</span>",
            dataIndex: 'divQtyIndex',
            align: 'right',
            hidden: false
        },{
            header: "<span style=font-weight:bold;>Closed DateTime</span>",
            dataIndex: 'closedDateIndex',
            hidden: false,
            sortable: true,
            filter: {
                type: 'date'
            }
        },{
            header: "<span style=font-weight:bold;>WB@D</span>",
            dataIndex: 'wbdIndex',
            filter: {
                type: 'string'
            }
        },

    ];
    return new Ext.grid.ColumnModel({
        columns: columns.slice(start || 0, finish),
        defaults: {
            sortable: true
        }
    });
};
//*********************************************Column model config Ends*************************** 	
//******************************************Creating Grid By Passing Parameter***********************

grid = getGrid('Mining Trip Sheet Generation For Barge', '<%=noRecordsFound%>', store, screen.width - 55, 420, 30, filters, 'Clear Filter Data', false, '', 20, false, '', false, '', false, 'Excel', jspName, exportDataType, false, 'PDF', <%=addButton%>, 'Add', true, 'Modify', true, 'Cancel', false, '', <%=startButton%>, 'Start BLO', <%=stopButton%>, 'Stop BLO', false, '', true, 'View PDF', false, '', false, '', false, '', <%=closetrip%>, 'Close Trip');
grid.getBottomToolbar().add([
    '-', {
        text: '',
        iconCls: 'excelbutton',
        handler: function() {
            getordreport('xls', 'All', jspName, grid, exportDataType);
        }
    }
]);

//**********************************End Of Creating Grid By Passing Parameter*************************


var customerPanel = new Ext.Panel({
    standardSubmit: true,
    collapsible: false,
    id: 'customerMaster',
    layout: 'table',
    cls: 'innerpanelsmallest',
    frame: false,
    width: '100%',
    layoutConfig: {
        columns: 13
    },
    items: [{
            xtype: 'label',
            text: '<%=selectCustomer%>' + ' :',
            cls: 'labelstyle',
            id: 'custnamelab'
        },
        custnamecombo, {
            width: 10
        }, {
            xtype: 'label',
            cls: 'labelstyle',
            id: 'startdatelab',
            width: 200,
            text: 'Start Date' + ' :'
        }, {
            width: 10
        }, {
            xtype: 'datefield',
            cls: 'selectstylePerfect',
            width: 120,
            format: getDateFormat(),
            emptyText: 'Select Start Date',
            allowBlank: false,
            blankText: 'Select Start Date',
            id: 'startdate',
            value: dateprev
        }, {
            width: 50
        }, {
            xtype: 'label',
            cls: 'labelstyle',
            id: 'enddatelab',
            width: 200,
            text: 'End Date' + ' :'
        }, {
            width: 30
        }, {
            xtype: 'datefield',
            cls: 'selectstylePerfect',
            width: 160,
            format: getDateFormat(),
            emptyText: 'Select End Date',
            allowBlank: false,
            blankText: 'Select End Date',
            id: 'enddate',
            value: datenext
        }, {
            width: 20
        }, {
            xtype: 'button',
            text: 'View',
            id: 'submitId',
            cls: 'buttonStyle',
            width: 60,
            handler: function() {
                if (Ext.getCmp('custcomboId').getValue() == "") {
                    Ext.example.msg("Select Customer");
                    Ext.getCmp('custcomboId').focus();
                    return;
                }
                if (dateCompare(Ext.getCmp('startdate').getValue(), Ext.getCmp('enddate').getValue()) == -1) {
                    Ext.example.msg("End date must be greater than Start date");
                    Ext.getCmp('enddate').focus();
                    return;
                }
                var Startdates = Ext.getCmp('startdate').getValue();
                var Enddates = Ext.getCmp('enddate').getValue();
                var dateDifrnc = new Date(Enddates).add(Date.DAY, -7);
                if (Startdates <= dateDifrnc) {
                    Ext.example.msg("Difference between two dates should not be  greater than 7 days.");
                    Ext.getCmp('startdate').focus();
                    return;
                }
                var cusId;
                if (back == '1') {
                    cusId = custId;
                } else {
                    cusId = Ext.getCmp('custcomboId').getValue();
                }
                store.load({
                    params: {
                        CustID: cusId,
                        jspName: jspName,
                        CustName: Ext.getCmp('custcomboId').getRawValue(),
                        endDate: Ext.getCmp('enddate').getValue(),
                        startDate: Ext.getCmp('startdate').getValue()
                    }
                });
            }
        }
    ]
});

//----------------------------------------------------------------//	
var panelForInfo = new Ext.Panel({
    id: 'vehicleRFIDPanelId',
    standardSubmit: true,
    layout: 'table',
    frame: false,
    height: 350,
    width: 437,
    layoutConfig: {
        columns: 4
    },
    items: [{
        xtype: 'label',
        text: '*',
        cls: 'mandatoryfield',
        id: 'mandatoryTypeId'
    }, {
        xtype: 'label',
        text: 'Type' + ' :',
        cls: 'labelstyle',
        id: 'typeNamelab'
    },  typecombo,  {
        xtype: 'label',
        text: '',
        cls: 'mandatoryfield',
        id: 'mandatoryTypeid'
    }, {
        xtype: 'label',
        text: '*',
        cls: 'mandatoryfield',
        id: 'mandatoryVehicleId'
    }, {
        xtype: 'label',
        text: 'Barge Name' + ' :',
        cls: 'labelstyle',
        id: 'VehicleNoID'
    }, vehicleCombo, {
        xtype: 'label',
        text: '',
        cls: 'mandatoryfield',
        id: 'mandatoryVehicleNoId'
    }, {
        xtype: 'label',
        text: '*',
        cls: 'mandatoryfield',
        id: 'mandatoryRfid'
    }, {
        xtype: 'label',
        text: 'Barge No:',
        cls: 'labelstyle',
        id: 'RFIDIDs'
    }, {
        xtype: 'textfield',
        cls: 'selectstylePerfect',
        emptyText: '<%=EnterVehicleNo%>',
        allowBlank: false,
        readOnly: true,
        blankText: '<%=EnterVehicleNo%>',
        id: 'RFIDId'
    }, {
        xtype: 'button',
        text: '<%=ReadRFID%>',
        width: 80,
        id: 'RFIDButtId',
        cls: 'buttonstyle',
        listeners: {
            click: {
                fn: function() {
                        var cusId;
                        if (back == '1') {
                            cusId = custId;
                        } else {
                            cusId = Ext.getCmp('custcomboId').getValue();
                        }
                        var RFIDValue;
                        $.ajax({
                            type: "GET",
                            url: '<%=RFIDwebServicePath%>',
                            success: function(data) {
                                if (data.includes('RSSOURCE') || data.includes('RSDESTINATION') || data.includes('TRANSACTION_NO')) {
                                    split1 = data.split('RSSOURCE');
                                    RFIDValue1 = split1[0].split('==');
                                    RFIDValue = RFIDValue1[1];
                                } else {
                                    RFIDValue = data;
                                }
                                tripStoreForRfidAdd.load({
                                    params: {
                                        CustID: cusId,
                                        RFIDValue: RFIDValue
                                    },
                                    callback: function() {
                                        for (var i = 0; i < tripStoreForRfidAdd.getCount(); i++) {
                                            var rec = tripStoreForRfidAdd.getAt(i);
                                            var vehicleName = rec.data['jsonString'];
                                            quantity1 = rec.data['quantity1'];
                                            bargeQuantity = rec.data['bargeQuantity'];
                                        }
                                        if (tripStoreForRfidAdd.getCount() == 0) {
                                            Ext.example.msg("<%=SomethingWronginRFID%>");
                                            Ext.getCmp('RFIDIdT').setValue("<%=EnterVehicleNo%>");
                                        } else {
                                            Ext.getCmp('RFIDId').setValue(vehicleName);
                                            Ext.getCmp('quantityId').setValue(quantity1);
                                            Ext.getCmp('tarequantityId').setValue(parseFloat(bargeQuantity) / 1000);
                                        }
                                    }
                                });
                            },
                            error: function() {
                                Ext.example.msg("Some thing went Wrong");
                            }
                        });

                    } //fun
            } //click
        } //listeners
    }, {
        xtype: 'label',
        text: '*',
        cls: 'mandatoryfield',
        id: 'mandatoryorg'
    }, {
        xtype: 'label',
        text: 'Organization Name' + ' :',
        cls: 'labelstyle',
        id: 'orgLabelId'
    }, orgCombo, {
        xtype: 'label',
        text: '',
        cls: 'mandatoryfield',
        id: 'mandatoryo'
    }, {
        xtype: 'label',
        text: '*',
        cls: 'mandatoryfield',
        id: 'mandatorytripsheetNumberId'
    }, {
        xtype: 'label',
        text: '<%=TripSheetNumber%>' + '  :',
        cls: 'labelstyle',
        id: 'tripsheetNumberLabelId'
    }, {
        xtype: 'textfield',
        cls: 'selectstylePerfect',
        emptyText: '<%=enterTripsheetNumber%>',
        blankText: '<%=enterTripsheetNumber%>',
        id: 'enrollNumberId',
    }, {
        xtype: 'label',
        text: '',
        cls: 'mandatoryfield',
        id: 'mandatoryTripsheetNumber'
    }, {
        xtype: 'label',
        text: '*',
        cls: 'mandatoryfield',
        id: 'mandatorydateValidityDateTime'
    }, {
        xtype: 'label',
        text: '<%=ValidityDateTime%>' + '  :',
        cls: 'labelstyle',
        id: 'validitydateTimeLabelId'
    }, StartDate, {
        xtype: 'label',
        text: '',
        cls: 'mandatoryfield',
        id: 'mandatoryvalidityDateId'
    }, {
        xtype: 'label',
        text: '*',
        cls: 'mandatoryfield',
        id: 'mandatoryvesselId'
    }, {
        xtype: 'label',
        text: 'Mother Vessel' + '  :',
        cls: 'labelstyle',
        id: 'vesselNameLabelId'
    }, vesselNameCombo, {
        xtype: 'label',
        text: '',
        cls: 'mandatoryfield',
        id: 'mandatoryvessel'
    }, {
        xtype: 'label',
        text: '',
        cls: 'mandatoryfield',
        id: 'mandatorydestinationId'
    }, {
        xtype: 'label',
        text: 'Destination' + '  :',
        cls: 'labelstyle',
        id: 'destiNameLabelId'
    }, {
        xtype: 'textfield',
        cls: 'selectstylePerfect',
        emptyText: 'Enter Destination',
        blankText: 'Enter Destination',
        id: 'destinationNameId'
    }, {
        xtype: 'label',
        text: '',
        cls: 'mandatoryfield',
        id: 'mandatordesti'
    }, {
        xtype: 'label',
        text: '*',
        cls: 'mandatoryfield',
        id: 'mandatorydivQtyId'
    }, {
        xtype: 'label',
        text: '<%=Diverted_Quantity%>' + '  :',
        cls: 'labelstyle',
        id: 'divLabelQtyId'
    }, {
        xtype: 'numberfield',
        cls: 'selectstylePerfect',
        emptyText: '<%=Enter_Diverted_Quantity%>',
        blankText: '<%=Enter_Diverted_Quantity%>',
        id: 'divQtyId'
    }, {
        xtype: 'label',
        text: '',
        cls: 'mandatoryfield',
        id: 'manDivQty'
    }, {
        xtype: 'label',
        text: '*',
        cls: 'mandatoryfield',
        id: 'mandatoryboatnoteId'
    }, {
        xtype: 'label',
        text: 'Boat Note' + '  :',
        cls: 'labelstyle',
        id: 'boatNoteLabelId'
    }, {
        xtype: 'textarea',
        cls: 'selectstylePerfect',
        emptyText: 'Enter Boat Note',
        blankText: 'Enter Boat Note',
        id: 'boatNoteId'
    }, {
        xtype: 'label',
        text: '',
        cls: 'mandatoryfield',
        id: 'mandatornote'
    }, {
        xtype: 'label',
        text: '*',
        cls: 'mandatoryfield',
        id: 'mandatoryreasonId'
    }, {
        xtype: 'label',
        text: 'Reason' + '  :',
        cls: 'labelstyle',
        id: 'reLabelId'
    }, reasonCombo1, {
        xtype: 'label',
        text: '',
        cls: 'mandatoryfield',
        id: 'mandatorres'
    }]
});


//-------------------------------Quantity Panel-------------------------------//
var innerThirdfirstPanel = new Ext.Panel({
    standardSubmit: true,
    collapsible: false,
    id: 'innerThirdMaster',
    layout: 'table',
    frame: false,
    height: 40,
    width: 210,
    layoutConfig: {
        columns: 2
    },
    items: [{
        xtype: 'label',
        text: '*',
        cls: 'mandatoryfield',
        id: 'mandatoryQTYId'
    }, {
        xtype: 'label',
        text: 'Barge Capacity' + '',
        cls: 'my-label-style',
        id: 'QuantityID'
    }]
});

var innerThirdSecondPanel = new Ext.Panel({
    standardSubmit: true,
    collapsible: false,
    id: 'innerThirdSecondMaster',
    layout: 'table',
    frame: false,
    height: 80,
    width: 210,
    layoutConfig: {
        columns: 3
    },
    items: [{
        width: 15
    }, {
        xtype: 'numberfield',
        width: 50,
        height: 60,
        cls: 'quantityBox',
        emptyText: '',
        allowBlank: false,
        readOnly: true,
        blankText: '',
        id: 'quantityId'
    }, {
        xtype: 'label',
        text: 'tons',
        cls: 'labelstyle',
        id: 'kgsId'
    }]
});


var innerThird3Panel = new Ext.FormPanel({
    standardSubmit: true,
    collapsible: false,
    id: 'innerThird3Master',
    layout: 'table',
    frame: false,
    height: 40,
    width: 210,
    layoutConfig: {
        columns: 2
    },
    items: [{
        width: 44
    }]
});

var detailsThirdPanel = new Ext.Panel({
    standardSubmit: true,
    collapsible: false,
    id: 'detailsThirdMaster',
    layout: 'table',
    frame: true,
    height: 385,
    width: 210,
    layoutConfig: {
        columns: 1
    },
    items: [innerThirdfirstPanel, innerThirdSecondPanel, innerThird3Panel]
});


//****************************** Window For Adding Trip Information****************************
var interval;
var winButtonPanel = new Ext.Panel({
    id: 'winbuttonid',
    standardSubmit: true,
    collapsible: false,
    height: 60,
    cls: 'windowbuttonpanel',
    frame: true,
    layout: 'table',
    layoutConfig: {
        columns: 3
    },
    items: [{
        width: 340
    }, {
        xtype: 'button',
        text: '<%=Save%>',
        id: 'addButtId',
        cls: 'buttonstyle',
        iconCls: 'savebutton',
        width: 80,
        listeners: {
            click: {
                fn: function() {
                    if (Ext.getCmp('typecomboId').getValue() == "") {
                        Ext.example.msg("<%=selectType%>");
                        Ext.getCmp('typecomboId').focus();
                        return;
                    }
                    if (Ext.getCmp('typecomboId').getValue() == 'RFID') {
                        if (Ext.getCmp('RFIDId').getValue() == "") {
                            Ext.example.msg("<%=selectVehicleNO%>");
                            Ext.getCmp('RFIDId').focus();
                            return;
                        }
                    } else {
                        if (Ext.getCmp('vehiclecomboId').getValue() == "") {
                            Ext.example.msg("<%=selectVehicleNO%>");
                            Ext.getCmp('vehiclecomboId').focus();
                            return;
                        }
                    }
                    if (buttonValue == 'add') {
                        if (Ext.getCmp('orgId').getValue() == "") {
                            Ext.example.msg("Select Organization name");
                            Ext.getCmp('orgId').focus();
                            return;
                        }
                    }

                    if (Ext.getCmp('quantityId').getValue() == "") {
                        Ext.example.msg("Please enter Barge Capacity");
                        Ext.getCmp('quantityId').focus();
                        return;
                    }

                    if (Ext.getCmp('startDateTime').getValue() == "") {
                        Ext.example.msg("<%=enterValidDateTime%>");
                        Ext.getCmp('startDateTime').focus();
                        return;
                    }

                    if (parseFloat(Ext.getCmp('quantityId').getValue()) < parseFloat(Ext.getCmp('tarequantityId').getValue())) {
                        Ext.example.msg("Barge capacity should be greater than quantity");
                        Ext.getCmp('quantityId').focus();
                        return;
                    }

                    var VehicleNoBaseType = "";
                    var globalClientId = Ext.getCmp('custcomboId').getValue();
                    var customerName = Ext.getCmp('custcomboId').getRawValue();
                    if (Ext.getCmp('typecomboId').getValue() == "RFID") {
                        VehicleNoBaseType = Ext.getCmp('RFIDId').getValue();
                    }
                    if (Ext.getCmp('typecomboId').getValue() == "APPLICATION") {
                        VehicleNoBaseType = Ext.getCmp('vehiclecomboId').getValue();
                    }
                    var status;
                    var flag;
                    var bargeModQty;
                    //-------------------------------------------------------------------------------------//	    
                    if (buttonValue == 'modify') {
                        var leaseModify;
                        var gradeModify;
                        var routeModify;
                        var selected = grid.getSelectionModel().getSelected();
                        uniqueId = selected.get('uniqueIDIndex');
                        status = selected.get('statusIndexId');
                        flag = selected.get('flagIndex');
                        bargeModQty=selected.get('q1IndexId');

                        if (Ext.getCmp('vesselNameId').getValue() == "") {
                            Ext.example.msg("Select vessel Name");
                            Ext.getCmp('vesselNameId').focus();
                            return;
                        }
                        if (Ext.getCmp('divQtyId').getValue() == "" || Ext.getCmp('divQtyId').getValue() == "0") {
                            Ext.example.msg("<%=Enter_Diverted_Quantity%>");
                            Ext.getCmp('divQtyId').focus();
                            return;
                        }
                        if (parseFloat(bargeModQty) < (parseFloat(Ext.getCmp('divQtyId').getValue()))) {
                            Ext.example.msg("Please enter diverted qty less than barge quantity");
                            Ext.getCmp('divQtyId').focus();
                            return;
                        }
                        if (Ext.getCmp('boatNoteId').getValue() == "") {
                            Ext.example.msg("Enter Boat note");
                            Ext.getCmp('boatNoteId').focus();
                            return;
                        }
                        if (Ext.getCmp('reasonComboId1').getValue() == "") {
                            Ext.example.msg("Select reason");
                            Ext.getCmp('reasonComboId1').focus();
                            return;
                        }
                    }
                    var cusId;
                    if (back == '1') {
                        cusId = custId;
                    } else {
                        cusId = Ext.getCmp('custcomboId').getValue();
                    }
                    myWin.getEl().mask();
                    Ext.Ajax.request({
                        url: '<%=request.getContextPath()%>/TripSheetGenerationActionForBarge.do?param=saveormodifyGenrateTripSheetForBarge',
                        method: 'POST',
                        params: {
                            buttonValue: buttonValue,
                            CustID: cusId,
                            type: Ext.getCmp('typecomboId').getValue(),
                            vehicleNo: VehicleNoBaseType,
                            bargeCapacity: Ext.getCmp('quantityId').getValue(),
                            bargeQuantity: 0,
                            validityDateTime: Ext.getCmp('startDateTime').getValue(),
                            userSettingId: userSettingId,
                            vesselName: Ext.getCmp('vesselNameId').getValue(),
                            destination: Ext.getCmp('destinationNameId').getValue(),
                            boatNote: Ext.getCmp('boatNoteId').getValue(),
                            reason: Ext.getCmp('reasonComboId1').getValue(),
                            uniqueId: uniqueId,
                            orgId: Ext.getCmp('orgId').getValue(),
                            bargeLocId: bargeLocId,
                            status: status,
                            flag: flag,
                            divQty: Ext.getCmp('divQtyId').getValue(),
                            modBargeQty: bargeModQty,
                            tripSheetNo: Ext.getCmp('enrollNumberId').getValue()
                        },
                        success: function(response, options) {
                            var message = response.responseText;
                            Ext.example.msg(message);

                            Ext.getCmp('typecomboId').setValue('APPLICATION');
                            Ext.getCmp('vehiclecomboId').reset();
                            Ext.getCmp('RFIDId').reset();
                            Ext.getCmp('quantityId').reset();
                            Ext.getCmp('startDateTime').reset();
                            Ext.getCmp('vesselNameId').reset();
                            Ext.getCmp('destinationNameId').reset();
                            Ext.getCmp('divQtyId').reset();
                            Ext.getCmp('boatNoteId').reset();
                            Ext.getCmp('reasonComboId1').reset();
                            Ext.getCmp('orgId').reset();
                            myWin.hide();
                            myWin.getEl().unmask();
                            store.load({
                                params: {
                                    CustID: cusId,
                                    jspName: jspName,
                                    CustName: Ext.getCmp('custcomboId').getRawValue(),
                                    endDate: Ext.getCmp('enddate').getValue(),
                                    startDate: Ext.getCmp('startdate').getValue()
                                }
                            });
                            vehicleComboStore.load({
                                params: {
                                    CustId: Ext.getCmp('custcomboId').getValue()
                                }
                            });
                            tripStore.load({
                                params: {
                                    CustID: cusId,
                                },
                                callback: function() {
                                    for (var i = 0; i < tripStore.getCount(); i++) {
                                        var rec = tripStore.getAt(i);
                                        srcHubId = rec.data['sHubId'];
                                        desHubId = rec.data['dHubId'];
                                        tripType = rec.data['type'];
                                        userSettingId = rec.data['userSettingId'];
                                        bargeLocId = rec.data['bargeLocId'];
                                    }
                                }
                            });
                        },
                        failure: function() {
                            Ext.example.msg("Error");
                            Ext.getCmp('mandatoryVehicleId').hide();
                            Ext.getCmp('VehicleNoID').hide();
                            Ext.getCmp('vehiclecomboId').hide();
                            Ext.getCmp('mandatoryRfid').hide();
                            Ext.getCmp('RFIDIDs').hide();
                            Ext.getCmp('RFIDId').hide();
                            Ext.getCmp('RFIDButtId').hide();
                            Ext.getCmp('vesselNameId').reset();
                            Ext.getCmp('destinationNameId').reset();
                            Ext.getCmp('divQtyId').reset();
                            Ext.getCmp('boatNoteId').reset();
                            Ext.getCmp('reasonComboId1').reset();
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
        width: '80',
        listeners: {
            click: {
                fn: function() {
                    clearInterval(interval);
                    Ext.getCmp('typecomboId').setValue('APPLICATION');
                    $('#vehiclecomboId').val('');
                    Ext.getCmp('RFIDId').reset();
                   // Ext.getCmp('vehicleRFIDPanelId').hide();
                    Ext.getCmp('mandatoryVehicleId').hide();
                    Ext.getCmp('VehicleNoID').hide();
                    Ext.getCmp('vehiclecomboId').hide();
                    Ext.getCmp('mandatoryRfid').hide();
                    Ext.getCmp('RFIDIDs').hide();
                    Ext.getCmp('RFIDId').hide();
                    Ext.getCmp('RFIDButtId').hide();
                    Ext.getCmp('vesselNameId').reset();
                    Ext.getCmp('destinationNameId').reset();
                    Ext.getCmp('divQtyId').reset();
                    Ext.getCmp('boatNoteId').reset();
                    Ext.getCmp('reasonComboId1').reset();
                    myWin.hide();
                }
            }
        }
    }]
});

//-----------------------------------------------------------//
var caseInnerPanel = new Ext.Panel({
    standardSubmit: true,
    collapsible: false,
    autoScroll: true,
    width: 450,
    height: 385,
    frame: true,
    id: 'addCaseInfo',
    layout: 'table',
    layoutConfig: {
        columns: 1
    },
    items: [panelForInfo]
});

var firstForthPanel = new Ext.Panel({
    standardSubmit: true,
    collapsible: false,
    id: 'firstForthpanelId',
    layout: 'table',
    frame: false,
    height: 40,
    width: 210,
    layoutConfig: {
        columns: 2
    },
    items: [{
        xtype: 'label',
        text: '*',
        cls: 'mandatoryfield',
        id: 'mandatoryTareQtyId'
    }, {
        xtype: 'label',
        text: 'Quantity' + '',
        cls: 'my-label-style',
        id: 'tareQuantityID'
    }]
});
var secondForthPanel = new Ext.Panel({
    standardSubmit: true,
    collapsible: false,
    id: 'secondForthPanelId',
    layout: 'table',
    frame: false,
    height: 80,
    width: 210,
    layoutConfig: {
        columns: 3
    },
    items: [{
        width: 15
    }, {
        xtype: 'numberfield',
        width: 50,
        height: 60,
        cls: 'quantityBox',
        emptyText: '',
        allowBlank: false,
        readOnly: true,
        blankText: '',
        id: 'tarequantityId'
    }, {
        xtype: 'label',
        text: 'tons',
        cls: 'labelstyle',
        id: 'tarekgsId'
    }]
});

var detailsForthPanel = new Ext.Panel({
    standardSubmit: true,
    collapsible: false,
    id: 'detailsForthPanel',
    layout: 'table',
    frame: true,
    height: 385,
    width: 210,
    layoutConfig: {
        columns: 1
    },
    items: [firstForthPanel, secondForthPanel]
});

var firstFifthPanel = new Ext.Panel({
    standardSubmit: true,
    collapsible: false,
    id: 'firstFifthPanelId',
    layout: 'table',
    frame: false,
    height: 40,
    width: 230,
    layoutConfig: {
        columns: 2
    },
    items: [{
        xtype: 'label',
        text: ' ',
        cls: 'mandatoryfield',
        id: 'mandatoryActualQtyId'
    }, {
        xtype: 'label',
        text: 'Net Weight' + '',
        cls: 'my-label-style',
        id: 'actualQuantityID'
    }]
});
var secondFifthPanel = new Ext.Panel({
    standardSubmit: true,
    collapsible: false,
    id: 'secondFifthPanelId',
    layout: 'table',
    frame: false,
    height: 80,
    readonly: true,
    width: 210,
    layoutConfig: {
        columns: 3
    },
    items: [{
        width: 15
    }, {
        xtype: 'textfield',
        width: 50,
        height: 60,
        cls: 'quantityBox',
        emptyText: '',
        allowBlank: false,
        readOnly: true,
        blankText: '',
        id: 'actualquantityId'
    }, {
        xtype: 'label',
        text: 'tons',
        cls: 'labelstyle',
        id: 'actualkgsId'
    }]
});

var detailsFifthPanel = new Ext.Panel({
    standardSubmit: true,
    collapsible: false,
    id: 'detailsFifthPanel',
    layout: 'table',
    frame: true,
    height: 354,
    width: 240,
    layoutConfig: {
        columns: 1
    },
    items: [firstFifthPanel, secondFifthPanel]
});
//----------------------------------------Inside two panel-------------------------------------------------//	
var caseTwoInnerPanel = new Ext.Panel({
    standardSubmit: true,
    collapsible: false,
    autoScroll: true,
    width: 900,
    height: 400,
    frame: true,
    id: 'InneraddCaseInfo',
    layout: 'table',
    layoutConfig: {
        columns: 4
    },
    items: [caseInnerPanel, detailsThirdPanel, detailsForthPanel]
});

//****************************** Window For Adding Trip Information Ends Here************************
var outerPanelWindow = new Ext.Panel({
    standardSubmit: true,
    id: 'winpanelId',
    frame: true,
    height: 480,
    width: 900,
    items: [caseTwoInnerPanel, winButtonPanel]
});

//************************* Outer Pannel *********************************************************//
myWin = new Ext.Window({
    title: 'My Window',
    closable: false,
    resizable: false,
    modal: true,
    autoScroll: false,
    height: 500,
    width: 900,
    id: 'myWin',
    items: [outerPanelWindow]
});


var cancelTripInnerPanel = new Ext.form.FormPanel({
    standardSubmit: true,
    collapsible: false,
    frame: false,
    id: 'canceltrip',

    items: [{
        xtype: 'fieldset',
        width: 480,
        title: 'Cancel Trip',
        id: 'closeTripfieldset',
        collapsible: false,
        layout: 'table',
        layoutConfig: {
            columns: 5
        },
        items: [{
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'mandatorycloseTripLabel'
        }, {
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'mandatorycloseTripLabelId'
        }, {
            xtype: 'label',
            text: 'Boat Note' + '  :',
            cls: 'labelstyle',
            id: 'remarkLabelId'
        }, {
            width: 10
        }, {
            xtype: 'textarea',
            cls: 'selectstylePerfect',
            id: 'remark',
            emptyText: 'Enter Remarks',
            blankText: 'Enter Remarks',
        }, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'mandatorycloseTripLabela'
        }, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'mandatorycloseTripLabels'
        }, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'mandatorycloseTripLabel3'
        }, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'mandatorycloseTripLabel4'
        }, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'mandatorycloseTripLabel5'
        }, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'mandatorycloseTripLabel6'
        }, {
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'mandatorycloseTripLabelId7'
        }, {
            xtype: 'label',
            text: 'Reason' + '  :',
            cls: 'labelstyle',
            id: 'remarkLabelId2'
        }, {
            width: 10
        }, reasonCombo]
    }]
});

var cancelTripPanel = new Ext.Panel({
    standardSubmit: true,
    collapsible: false,
    autoScroll: true,
    width: 490,
    height: 180,
    frame: true,
    id: 'cancelTripPanel1',
    items: [cancelTripInnerPanel]
});

var winButtonPanelForCancelTrip = new Ext.Panel({
    id: 'winbuttonid12',
    standardSubmit: true,
    collapsible: false,
    height: 8,
    cls: 'windowbuttonpanel',
    frame: true,
    layout: 'table',
    layoutConfig: {
        columns: 4
    },
    buttons: [{
        xtype: 'button',
        text: 'Cancel Trip',
        id: 'cancelTripId1',
        cls: 'buttonstyle',
        iconCls: 'savebutton',
        width: 80,
        listeners: {
            click: {
                fn: function() {
                    if (Ext.getCmp('remark').getValue() == "") {
                        Ext.example.msg("Enter Boat Note");
                        return;
                    }

                    if (Ext.getCmp('reasonComboId').getValue() == "") {
                        Ext.example.msg("Select Reason");
                        return;
                    }
                    canceltripWin.getEl().mask();
                    var selected = grid.getSelectionModel().getSelected();
                    Ext.Ajax.request({
                        url: '<%=request.getContextPath()%>/TripSheetGenerationActionForBarge.do?param=cancelTrip',
                        method: 'POST',
                        params: {
                            remark: Ext.getCmp('remark').getValue(),
                            reason: Ext.getCmp('reasonComboId').getValue(),
                            custId: Ext.getCmp('custcomboId').getValue(),
                            uniqueNo: selected.get('uniqueIDIndex')
                        },
                        success: function(response, options) {
                            var message = response.responseText;
                            Ext.example.msg(message);
                            canceltripWin.hide();
                            canceltripWin.getEl().unmask();
                            store.load({
                                params: {
                                    CustID: cusId,
                                    jspName: jspName,
                                    CustName: Ext.getCmp('custcomboId').getRawValue(),
                                    endDate: Ext.getCmp('enddate').getValue(),
                                    startDate: Ext.getCmp('startdate').getValue()
                                }
                            });
                            Ext.getCmp('remark').reset();
                            Ext.getCmp('reasonComboId').reset();

                        },
                        failure: function() {
                            Ext.example.msg("Error");
                            store.reload();
                            Ext.getCmp('remark').reset();
                            Ext.getCmp('reasonComboId').reset();
                            canceltripWin.hide();
                        }
                    });

                }
            }
        }
    }, {
        xtype: 'button',
        text: '<%=Cancel%>',
        id: 'cancelButtonId2',
        cls: 'buttonstyle',
        iconCls: 'cancelbutton',
        width: '80',
        listeners: {
            click: {
                fn: function() {
                    canceltripWin.hide();
                    Ext.getCmp('remark').reset();
                    Ext.getCmp('reasonComboId').reset();

                }
            }
        }
    }]
});

var outerPanelWindowForCancelTrip = new Ext.Panel({
    standardSubmit: true,
    id: 'cancelwinpanelId1',
    frame: true,
    height: 250,
    width: 520,
    items: [cancelTripPanel, winButtonPanelForCancelTrip]
});

canceltripWin = new Ext.Window({
    closable: false,
    modal: true,
    resizable: false,
    autoScroll: false,
    height: 300,
    width: 530,
    id: 'closemyWin',
    items: [outerPanelWindowForCancelTrip]
});



function addRecord() {
 bargeStore.load();
    var cusId;
    if (back == '1') {
        cusId = custId;
    } else {
        cusId = Ext.getCmp('custcomboId').getValue();
    }
    if (Ext.getCmp('custcomboId').getValue() == "") {
        Ext.example.msg("<%=pleaseSelectcustomer%>");
        Ext.getCmp('custcomboId').focus();
        return;
    }
    Ext.getCmp('quantityId').enable();
    Ext.getCmp('tarequantityId').enable();

    buttonValue = "add";
    title = '<%=addTripSheetInformation%>';
    myWin.setTitle(title);
    orgNameStore.load();
    var d = new Date();
    d.setDate(d.getDate() + 1);
    d.setHours(18);
    d.setSeconds(00);
    d.setMinutes(00);

    vehicleComboStore.load();
    Ext.getCmp('mandatoryreasonId').hide();
    Ext.getCmp('reLabelId').hide();
    Ext.getCmp('reasonComboId1').hide();

    Ext.getCmp('typecomboId').setDisabled(false);
    Ext.getCmp('RFIDId').enable;
    Ext.getCmp('RFIDButtId').setDisabled(false);

    Ext.getCmp('typecomboId').setValue('APPLICATION');
    if (Ext.getCmp('typecomboId').getValue() == 'APPLICATION') {
        Ext.getCmp('vehiclecomboId').reset();
        Ext.getCmp('mandatoryRfid').hide();
        Ext.getCmp('RFIDIDs').hide();
        Ext.getCmp('RFIDId').hide();
        Ext.getCmp('RFIDButtId').hide();
        Ext.getCmp('mandatoryVehicleId').show();
        Ext.getCmp('VehicleNoID').show();
        Ext.getCmp('vehiclecomboId').show();
        Ext.getCmp('vehiclecomboId').reset();
        Ext.getCmp('vehiclecomboId').setValue('');
    }

    Ext.getCmp('vehiclecomboId').setDisabled(false);

    Ext.getCmp('tripsheetNumberLabelId').hide();
    Ext.getCmp('mandatorytripsheetNumberId').hide();
    Ext.getCmp('enrollNumberId').hide();

    Ext.getCmp('mandatoryvesselId').hide();
    Ext.getCmp('vesselNameLabelId').hide();
    Ext.getCmp('vesselNameId').hide();

    Ext.getCmp('mandatorydestinationId').hide();
    Ext.getCmp('destiNameLabelId').hide();
    Ext.getCmp('destinationNameId').hide();

    Ext.getCmp('mandatoryboatnoteId').hide();
    Ext.getCmp('boatNoteLabelId').hide();
    Ext.getCmp('boatNoteId').hide();

    Ext.getCmp('mandatoryboatnoteId').hide();
    Ext.getCmp('divLabelQtyId').hide();
    Ext.getCmp('divQtyId').hide();
    Ext.getCmp('mandatorydivQtyId').hide();

    Ext.getCmp('RFIDId').setValue('');
    Ext.getCmp('quantityId').setValue('');
    Ext.getCmp('tarequantityId').setValue('');
    Ext.getCmp('actualquantityId').setValue('');
    Ext.getCmp('startDateTime').setValue(d);

    Ext.getCmp('orgLabelId').show();
    Ext.getCmp('mandatoryorg').show();
    Ext.getCmp('mandatoryo').show();
    Ext.getCmp('orgId').show();

    Ext.getCmp('orgId').reset();

    if (tripType == 'Close' || tripType == undefined) {
        Ext.example.msg("Please do the user setting");
        return;
    }
    if (bargeLocId == 0 || bargeLocId == undefined) {
        Ext.example.msg("Please do the user setting");
        return;
    }
    setTimeout(function(){
    var rec = bargeStore.getAt(0);
    if(rec != undefined){
	    statusB = rec.data['status'];
	    if (statusB == true) {
		  Ext.example.msg("Barge Trip is already opened.");
		  return;
		}
	}
    myWin.show();
    },1000);

}

//*********************** Function to Modify Data ***********************************
function modifyData() {
    if (back == '1') {
        cusId = custId;
    } else {
        cusId = Ext.getCmp('custcomboId').getValue();
    }
    if (Ext.getCmp('custcomboId').getValue() == "") {
        Ext.example.msg("<%=pleaseSelectcustomer%>");
        Ext.getCmp('custcomboId').focus();
        return;
    }
    if (grid.getSelectionModel().getCount() > 1) {
        Ext.example.msg("<%=SelectSingleRow%>");
        return;
    }

    if (grid.getSelectionModel().getSelected() == null) {
        Ext.example.msg("<%=noRecordsFound%>");
        Ext.getCmp('custcomboId').focus();
        return;
    }
    var selected = grid.getSelectionModel().getSelected();
    var status = selected.get('statusIndexId');
    var bargeId = selected.get('uniqueIDIndex');
    if (status == 'CLOSE') {
        Ext.example.msg("Trip sheet already closed");
        return;
    }
        if (status == 'Closed-Completed Trip') {
            Ext.example.msg("Trip sheet already closed");
            return;
        }
        if (status == 'Closed-Completed-Modified Trip') {
            Ext.example.msg("Trip sheet already closed");
            return;
        }

    if (status == 'BLO In-Transit') {
        Ext.example.msg("Stop Loading Barge to modify");
        return;
    }else if (status == 'Closed-Cancelled Trip') {
        Ext.example.msg("Trip sheet already cancelled");
        return;
    }else if (status == 'Closed Diverted Trip') {
        Ext.example.msg("Diverted trip can not be modify.");
        return;
    }

    buttonValue = "modify";
    titel = "<%=modifyTripSheetInformation%>"
    myWin.setTitle(titel);

    var selected = grid.getSelectionModel().getSelected();
    var type = selected.get('TypeIndex');
    var tareWeigh = selected.get('q1IndexId');
    var capacity = selected.get('QuantityIndex');
    if (type == "RFID") {
        Ext.getCmp('mandatoryRfid').show();Ext.getCmp('RFIDIDs').show();Ext.getCmp('RFIDId').show();Ext.getCmp('RFIDButtId').show();
        Ext.getCmp('RFIDId').setValue(selected.get('assetNoIndex'));
        Ext.getCmp('mandatoryVehicleId').hide();Ext.getCmp('VehicleNoID').hide();Ext.getCmp('vehiclecomboId').hide();Ext.getCmp('mandatoryVehicleNoId').hide();
    }
    if (type == "APPLICATION") {
        Ext.getCmp('mandatoryVehicleId').show();
        Ext.getCmp('VehicleNoID').show();
        Ext.getCmp('vehiclecomboId').show();
        Ext.getCmp('mandatoryVehicleNoId').show();
        
        Ext.getCmp('vehiclecomboId').setValue(selected.get('assetNoIndex'));
        
        Ext.getCmp('mandatoryRfid').hide();
        Ext.getCmp('RFIDIDs').hide();
        Ext.getCmp('RFIDId').hide();
        Ext.getCmp('RFIDButtId').hide();
    }
    Ext.getCmp('tripsheetNumberLabelId').show();
    Ext.getCmp('mandatorytripsheetNumberId').show();
    Ext.getCmp('enrollNumberId').show();
    Ext.getCmp('mandatoryTripsheetNumber').show();

    Ext.getCmp('mandatoryvesselId').show();
    Ext.getCmp('vesselNameLabelId').show();
    Ext.getCmp('vesselNameId').show(),

    Ext.getCmp('mandatorydestinationId').show();
    Ext.getCmp('destiNameLabelId').show();
    Ext.getCmp('destinationNameId').show();

    Ext.getCmp('mandatoryboatnoteId').show();
    Ext.getCmp('boatNoteLabelId').show();
    Ext.getCmp('boatNoteId').show();

    Ext.getCmp('mandatoryreasonId').show();
    Ext.getCmp('reLabelId').show();
    Ext.getCmp('reasonComboId1').show();
    
    Ext.getCmp('orgLabelId').hide();
    Ext.getCmp('mandatoryorg').hide();
    Ext.getCmp('mandatoryo').hide();
    Ext.getCmp('orgId').hide();
    
    Ext.getCmp('mandatoryboatnoteId').show();
    Ext.getCmp('divLabelQtyId').show();
    Ext.getCmp('divQtyId').show();
    Ext.getCmp('mandatorydivQtyId').show();
    
    Ext.getCmp('enrollNumberId').setValue(selected.get('TripSheetNumberIndex'));
    Ext.getCmp('orgId').setValue(selected.get('orgIdIndex'));
    Ext.getCmp('typecomboId').setValue(selected.get('TypeIndex'));
    Ext.getCmp('startDateTime').setValue(selected.get('validityDateDataIndex'));
    //Ext.getCmp('vesselNameId').setValue(selected.get('vesselNameIndex'));
    Ext.getCmp('destinationNameId').setValue(selected.get('destinationIndex'));
    Ext.getCmp('boatNoteId').setValue(selected.get('boatNote'));
    Ext.getCmp('reasonComboId1').setValue(selected.get('reason'));
	Ext.getCmp('quantityId').setValue(capacity);
    Ext.getCmp('tarequantityId').setValue(tareWeigh);
    //Ext.getCmp('divQtyId').setValue(selected.get('divQtyIndex'));
    
    Ext.getCmp('enrollNumberId').disable();
    Ext.getCmp('typecomboId').setDisabled(true);
    Ext.getCmp('RFIDId').disable;
    Ext.getCmp('RFIDButtId').setDisabled(true);
    Ext.getCmp('vehiclecomboId').setDisabled(true);
    
    vesselNameStore.load({
          params: {
              custId: Ext.getCmp('custcomboId').getValue()
          }
     });
    myWin.show();

}

function verifyFunction() {
    if (Ext.getCmp('custcomboId').getValue() == "") {
        Ext.example.msg("<%=pleaseSelectcustomer%>");
        Ext.getCmp('custcomboId').focus();
        return;
    }
    if (grid.getSelectionModel().getCount() > 1) {
        Ext.example.msg("<%=SelectSingleRow%>");
        return;
    }

    if (grid.getSelectionModel().getSelected() == null) {
        Ext.example.msg("<%=noRecordsFound%>");
        Ext.getCmp('custcomboId').focus();
        return;
    }
    var selected = grid.getSelectionModel().getSelected();
    var arr = selected.get('TripSheetNumberIndex').split("-");
    if(arr[1]!=null){
    	Ext.example.msg("Can not perform Start BLO on this Trip");
        return;
    }

    var cusId;
    if (back == '1') {
        cusId = custId;
    } else {
        cusId = Ext.getCmp('custcomboId').getValue();
    }
    var CustID = cusId;
    var selected = grid.getSelectionModel().getSelected();
    var tripNo = selected.get('TripSheetNumberIndex');
    var bargeNo = selected.get('assetNoIndex');
    bargeStoreForStartBLO.load({
    	params:{
    		bargeNo: bargeNo
    	}
    });
    //var row = bargeStoreForStartBLO.findExact('bargeName', bargeNo);
     setTimeout(function(){
    var rec = bargeStoreForStartBLO.getAt(0);
    if(rec != undefined){
    statusB = rec.data['status'];
    if (statusB == true) {
	  //Ext.example.msg("Barge is in BLO-InTransit state");
	  //return;
	}
    }   
    var bargeCapacity = selected.get('QuantityIndex');
    var bargeQuantity1 = selected.get('q1IndexId');
    var bargeId = selected.get('uniqueIDIndex');
    var status = selected.get('statusIndexId');
    var endDate = Ext.getCmp('enddate').getValue();
    var startDate = Ext.getCmp('startdate').getValue();
    var orgId = selected.get('orgIdIndex');
    var bargeLocation = selected.get('bargeLocIndex');
    var custName = Ext.getCmp('custcomboId').getRawValue();
    var tripSheetForTruck = '/Telematics4uApp/Jsps/IronMining/TripSheetGenerationForTruck.jsp?custId=' + CustID + '&tripNo=' + tripNo + '&bargeNo=' + bargeNo + '&bargeCapacity=' + bargeCapacity + '&bargeQuantity=' + bargeQuantity1 + '&bargeId=' + bargeId + '&status=' + status + '&startDate=' + startDate + '&endDate=' + endDate + '&custName=' + custName + '&orgId=' + orgId + '&bargeLocation=' + bargeLocation;
    parent.Ext.getCmp('partOneTab').enable();
    parent.Ext.getCmp('generalBargeTab').disable();
    parent.Ext.getCmp('partOneTab').show();
    parent.Ext.getCmp('partOneTab').update("<iframe style='width:100%;height:525px;border:0;' src='" + tripSheetForTruck + "'></iframe>");
    }, 1000);
}

function deleteData() {
    if (back == '1') {
        cusId = custId;
    } else {
        cusId = Ext.getCmp('custcomboId').getValue();
    }
    if (Ext.getCmp('custcomboId').getValue() == "") {
        Ext.example.msg("<%=pleaseSelectcustomer%>");
        Ext.getCmp('custcomboId').focus();
        return;
    }
    if (grid.getSelectionModel().getCount() > 1) {
        Ext.example.msg("<%=SelectSingleRow%>");
        return;
    }
    if (grid.getSelectionModel().getSelected() == null) {
        Ext.example.msg("<%=noRecordsFound%>");
        Ext.getCmp('custcomboId').focus();
        return;
    }
    
    var selected = grid.getSelectionModel().getSelected();
    var status = selected.get('statusIndexId');
    var bargeId = selected.get('uniqueIDIndex');
    if (<%=loginInfo.getIsLtsp()%> != 0 && <%=userAuthority.equalsIgnoreCase("User")%> && selected.get('issuedBy') != <%=userId%>) {
        Ext.example.msg("User cann't cancel selected Trip Sheet");
        return;
    }
    if (status == 'Closed-Completed Trip') {
        Ext.example.msg("Trip sheet already closed");
        return;
    }else if (status == 'Closed-Completed-Modified Trip') {
        Ext.example.msg("Trip sheet already closed");
        return;
    }else if (status == 'Closed-Cancelled Trip') {
        Ext.example.msg("Trip sheet already cancelled");
        return;
    }else if (status == 'BLO In-Transit') {
        Ext.example.msg("Stop Loading Barge to cancel");
        return;
    }else if (status == 'Closed Diverted Trip') {
        Ext.example.msg("Diverted trip can not be cancel.");
        return;
    }else if (status == 'In-transit Diverted Trip') {
        Ext.example.msg("In-transit Diverted trip can not be cancel.");
        return;
    }
    var titelForcloseTrip = 'Cancel Trip';
    canceltripWin.setTitle(titelForcloseTrip);
    canceltripWin.show();
}

function closeImportWin() {
    var cusId;
    if (back == '1') {
        cusId = custId;
    } else {
        cusId = Ext.getCmp('custcomboId').getValue();
    }
    var selected = grid.getSelectionModel().getSelected();

    if (Ext.getCmp('custcomboId').getValue() == "") {
        Ext.example.msg("<%=pleaseSelectcustomer%>");
        Ext.getCmp('custcomboId').focus();
        return;
    }
    if (grid.getSelectionModel().getCount() > 1) {
        Ext.example.msg("<%=SelectSingleRow%>");
        return;
    }
    if (grid.getSelectionModel().getSelected() == null) {
        Ext.example.msg("No Records Found");
        Ext.getCmp('custcomboId').focus();
        return;
    }
    if (selected.get('statusIndexId') == 'Closed-Completed Trip') {
        Ext.example.msg("Trip sheet already closed");
        return;
    }else if (selected.get('statusIndexId') == 'Closed-Completed-Modified Trip') {
        Ext.example.msg("Trip sheet already closed");
        return;
    }else if (selected.get('statusIndexId') == 'Closed-Cancelled Trip') {
        Ext.example.msg("Trip sheet already Cancelled");
        return;
    }else if (selected.get('statusIndexId') == 'BLO In-Transit') {
        Ext.example.msg("Stop Loading Trip to Close");
        return;
    }else if (selected.get('statusIndexId') == 'Closed Diverted Trip') {
        Ext.example.msg("Can not perform Close Trip on Diverted Trip");
        return;
    }
    
    buttonValue = "close trip";
    if (tripType == 'Open' || tripType == undefined) {
        Ext.example.msg("Please do the user setting");
        return;
    }

    Ext.MessageBox.show({
        title: '',
        msg: 'Are you sure you want to close trip?',
        buttons: Ext.MessageBox.YESNO,
        icon: Ext.MessageBox.QUESTION,
        fn: function(btn) {
            if (btn == 'yes') {
                tripSheetNo = selected.get('TripSheetNumberIndex')
                assetNo = selected.get('assetNoIndex');
                Ext.Ajax.request({
                    url: '<%=request.getContextPath()%>/TripSheetGenerationActionForBarge.do?param=closeTrip',
                    method: 'POST',
                    params: {
                        tripSheetNo: tripSheetNo,
                        assetNo: assetNo,
                        CustID: cusId
                    },
                    success: function(response, options) {
                        var message = response.responseText;
                        Ext.example.msg(message);
                        store.load({
                            params: {
                                CustID: cusId,
                                jspName: jspName,
                                CustName: Ext.getCmp('custcomboId').getRawValue(),
                                endDate: Ext.getCmp('enddate').getValue(),
                                startDate: Ext.getCmp('startdate').getValue()
                            }
                        });
                    },
                    failure: function() {
                        Ext.example.msg("Error");
                    }
                });
            }
        }
    });
}

function approveFunction() {
    var selected = grid.getSelectionModel().getSelected();

    if (Ext.getCmp('custcomboId').getValue() == "") {
        Ext.example.msg("<%=pleaseSelectcustomer%>");
        Ext.getCmp('custcomboId').focus();
        return;
    }
    if (grid.getSelectionModel().getCount() > 1) {
        Ext.example.msg("<%=SelectSingleRow%>");
        return;
    }
    if (grid.getSelectionModel().getSelected() == null) {
        Ext.example.msg("No Records Found");
        Ext.getCmp('custcomboId').focus();
        return;
    }
    var bargeLocation1 = selected.get('bargeLocIndex');
    if (bargeLocId == 0 || bargeLocId == undefined) {
        Ext.example.msg("Please do the user setting");
        return;
    }
    if(bargeLocation1!= bargeLocId){
	   Ext.example.msg(" Please do the user setting ");
	   return;             
    }
    if (selected.get('statusIndexId') == 'In-Transit') {
        Ext.example.msg("Barge Loading has been already stopped");
        return;
    }else if (selected.get('statusIndexId') == 'In-transit Modified') {
        Ext.example.msg("Barge Loading is Stopped");
        return;
    }else if (selected.get('statusIndexId') == 'OPEN') {
        Ext.example.msg("Barge has not been loaded");
        return;
    }else if (selected.get('statusIndexId') == 'Closed-Completed Trip') {
        Ext.example.msg("Trip sheet already closed");
        return;
    }else if (selected.get('statusIndexId') == 'Closed-Completed-Modified Trip') {
        Ext.example.msg("Trip sheet already closed");
        return;
    }else if (selected.get('statusIndexId') == 'Closed Diverted Trip') {
        Ext.example.msg("Can not perform Stop BLO on Diverted Trip");
        return;
    }else if (selected.get('statusIndexId') == 'In-transit Diverted Trip') {
        Ext.example.msg("Can not perform Stop BLO on Diverted Trip");
        return;
    }else if (selected.get('statusIndexId') == 'Closed-Cancelled Trip') {
        Ext.example.msg("Can not perform Stop BLO on Diverted Trip");
        return;
    }
    var selected = grid.getSelectionModel().getSelected();
    var bargeId = selected.get('uniqueIDIndex');
    var cusId;
    if (back == '1') {
        cusId = custId;
    } else {
        cusId = Ext.getCmp('custcomboId').getValue();
    }
    Ext.MessageBox.show({
        title: '',
        msg: 'Are you sure you want to stop?',
        buttons: Ext.MessageBox.YESNO,
        icon: Ext.MessageBox.QUESTION,
        fn: function(btn) {
            if (btn == 'yes') {
                tripSheetNo = selected.get('TripSheetNumberIndex')
                assetNo = selected.get('assetNoIndex');
                Ext.Ajax.request({
                    url: '<%=request.getContextPath()%>/TripSheetGenerationActionForBarge.do?param=stopblo',
                    method: 'POST',
                    params: {
                        tripSheetNo: tripSheetNo,
                        assetNo: assetNo,
                        CustID: cusId
                    },
                    success: function(response, options) {
                        var message = response.responseText;
                        Ext.example.msg(message);
                        store.load({
                            params: {
                                CustID: cusId,
                                jspName: jspName,
                                CustName: Ext.getCmp('custcomboId').getRawValue(),
                                endDate: Ext.getCmp('enddate').getValue(),
                                startDate: Ext.getCmp('startdate').getValue()
                            }
                        });
                        window.open("<%=request.getContextPath()%>/tripSheetPdfForBarge?uniqueId=" + bargeId);
                    },
                    failure: function() {
                        Ext.example.msg("Error");
                    }
                });
            }
        }
    });
}

function postponeFunction() {
    if (back == '1') {
        cusId = custId;
    } else {
        cusId = Ext.getCmp('custcomboId').getValue();
    }
    if (Ext.getCmp('custcomboId').getValue() == "") {
        Ext.example.msg("<%=pleaseSelectcustomer%>");
        Ext.getCmp('custcomboId').focus();
        return;
    }
    if (grid.getSelectionModel().getCount() > 1) {
        Ext.example.msg("<%=SelectSingleRow%>");
        return;
    }
    if (grid.getSelectionModel().getSelected() == null) {
        Ext.example.msg("<%=noRecordsFound%>");
        Ext.getCmp('custcomboId').focus();
        return;
    }
    var selected = grid.getSelectionModel().getSelected();
    var status = selected.get('statusIndexId');
    var bargeId = selected.get('uniqueIDIndex');

    if (status == 'OPEN') {
        Ext.example.msg("Please Load the Barge");
        return;
    }
    if (status == 'BLO In-Transit') {
        Ext.example.msg("Stop Loading Barge to view PDF");
        return;
    }
    if ((selected.get('statusIndexId') != 'Closed Diverted Trip') && !(parseFloat(selected.get('q1IndexId')) > 0)) {
        Ext.example.msg("Load the Barge to view PDF");
        return;
    }
    window.open("<%=request.getContextPath()%>/tripSheetPdfForBarge?uniqueId=" + bargeId);
}


Ext.onReady(function() {
    Ext.QuickTips.init();
    Ext.form.Field.prototype.msgTarget = 'side';
    outerPanel = new Ext.Panel({
        renderTo: 'content',
        standardSubmit: true,
        frame: true,
        height: 500,
        width: screen.width - 40,
        items: [customerPanel, grid]
    });

    if (back == '1') {

        var prevfromdate = '<%=startDatePrev%>';
        var dt = new Date(prevfromdate);
        var mnth = ("0" + (dt.getMonth() + 1)).slice(-2);
        var day = ("0" + dt.getDate()).slice(-2);
        var prevfromdates = [day, mnth, dt.getFullYear()].join("-");

        var prevtodate = '<%=endDatePrev%>';
        var dts = new Date(prevtodate);
        var mnths = ("0" + (dts.getMonth() + 1)).slice(-2);
        var days = ("0" + dts.getDate()).slice(-2);
        var prevtodates = [days, mnths, dts.getFullYear()].join("-");

        Ext.getCmp('custcomboId').setValue(custName);
        Ext.getCmp('enddate').setValue(prevtodates);
        Ext.getCmp('startdate').setValue(prevfromdates);

        store.load({
            params: {
                CustID: custId,
                jspName: jspName,
                CustName: Ext.getCmp('custcomboId').getRawValue(),
                endDate: ed,
                startDate: sd
            }
        });
        tripStore.load({
            params: {
                CustID: custId,
            },
            callback: function() {
                for (var i = 0; i < tripStore.getCount(); i++) {
                    var rec = tripStore.getAt(i);
                    srcHubId = rec.data['sHubId'];
                    desHubId = rec.data['dHubId'];
                    tripType = rec.data['type'];
                    userSettingId = rec.data['userSettingId'];
                    bargeLocId = rec.data['bargeLocId'];
                }
            }
        });
    }
});
    </script>
  </body>
</html>
<%}%>

