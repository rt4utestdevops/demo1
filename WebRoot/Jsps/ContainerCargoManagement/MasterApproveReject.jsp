<%@ page language="java" import="java.util.*" pageEncoding="ISO-8859-1"%>
<%@page import="t4u.beans.LoginInfoBean"%>
<%@page import="t4u.functions.CommonFunctions"%>
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
	tobeConverted.add("SLNO");
	tobeConverted.add("Select_client");
	tobeConverted.add("Select_Master");
	tobeConverted.add("UID");
	tobeConverted.add("Company_Name");
	tobeConverted.add("Company_Id");
	tobeConverted.add("Customer_Type");
	tobeConverted.add("Inv_Type");
	tobeConverted.add("Location");
	tobeConverted.add("Vehicle_Model");
	tobeConverted.add("Principal_Name");
	tobeConverted.add("Consignee_Name");
	tobeConverted.add("Fuel_Consumption");
	tobeConverted.add("Fuel_Company_Name");
	tobeConverted.add("Fuel_Type");
	tobeConverted.add("Holiday");
	tobeConverted.add("Holiday_Date");
	tobeConverted.add("Detention_Type");
	tobeConverted.add("Cleaner");
	tobeConverted.add("Address");
	tobeConverted.add("Status");
	tobeConverted.add("Master_Approve_Reject");
	tobeConverted.add("No_Records_Found");
	tobeConverted.add("City");
	tobeConverted.add("State");
	tobeConverted.add("Country");
	tobeConverted.add("Factory_1");
	tobeConverted.add("Mobile");
	tobeConverted.add("Email");
	tobeConverted.add("Phone_No");
	tobeConverted.add("Contact_Person");
	tobeConverted.add("Contact_Person_Phone_No");
	tobeConverted.add("PAN_No");
	tobeConverted.add("ST_No");
	tobeConverted.add("TIN_No");
	tobeConverted.add("Effective_From");
	tobeConverted.add("Effective_To");
	tobeConverted.add("KMS");
	tobeConverted.add("R_Fee");
	tobeConverted.add("B_Fee");
	tobeConverted.add("Toll");
	tobeConverted.add("Driver_Incentive");
	tobeConverted.add("Police");
	tobeConverted.add("Escort");
	tobeConverted.add("Labour_Charges");
	tobeConverted.add("Other_Expenses");
	tobeConverted.add("Total");
	tobeConverted.add("Vendor_Name");
	tobeConverted.add("Rate");
	tobeConverted.add("License");
	tobeConverted.add("Insurance");
	tobeConverted.add("Pollution");
	tobeConverted.add("Shoes");
	tobeConverted.add("Fluroscent_Jacket");
	tobeConverted.add("Fixed_Rate");
	tobeConverted.add("Rate_Per_Drum");
	tobeConverted.add("Principal_From");
	tobeConverted.add("Principal_To");
	tobeConverted.add("Principal_Cost");
	tobeConverted.add("Consignee_From");
	tobeConverted.add("Consignee_To");
	tobeConverted.add("Consignee_Cost");
	tobeConverted.add("Cleaner_Id");
	tobeConverted.add("Salary");
	tobeConverted.add("Reverse_Horn");
	tobeConverted.add("No_Smoking_No_Fire");
	tobeConverted.add("Fitness");
	
	ArrayList<String> convertedWords = new ArrayList<String>();
	convertedWords = cf.getLanguageSpecificWordForKey(tobeConverted,language);
	
	String SLNO = convertedWords.get(0);
	String selectClient = convertedWords.get(1);
	String selectMaster = convertedWords.get(2);
	String UID = convertedWords.get(3);
	String companyName = convertedWords.get(4);
	String companyId = convertedWords.get(5);
	String customerType = convertedWords.get(6);
	String invType = convertedWords.get(7);
	String location = convertedWords.get(8);
	String vehicleModel = convertedWords.get(9);
	String principalName = convertedWords.get(10);
	String consigneeName = convertedWords.get(11);
	String fuelConsumption = convertedWords.get(12);
	String fuelCompanyName = convertedWords.get(13);
	String fuelType = convertedWords.get(14);
	String holidayName = convertedWords.get(15);
	String holidayDate = convertedWords.get(16);
	String detentionType = convertedWords.get(17);
	String cleaner = convertedWords.get(18);
	String address = convertedWords.get(19);
	String status = convertedWords.get(20);
	String masterApproveReject = convertedWords.get(21);
	String NoRecordsFound = convertedWords.get(22);
	String city = convertedWords.get(23);
	String state = convertedWords.get(24);
	String country = convertedWords.get(25);
	String factory1 = convertedWords.get(26);
	String mobile = convertedWords.get(27)+"-1";
	String email = convertedWords.get(28)+"-1";
	String phoneNo = convertedWords.get(29)+"-1";
	String contactPerson = convertedWords.get(30);
	String contactPersonPhoneNo = convertedWords.get(31);
	String panNo = convertedWords.get(32);
	String stNo = convertedWords.get(33);
	String tinNo = convertedWords.get(34);
	String effectiveFrom = convertedWords.get(35);
	String effectiveTo = convertedWords.get(36);
	String kms = convertedWords.get(37);
	String rFee = convertedWords.get(38);
	String bFee = convertedWords.get(39);
	String tollFee = convertedWords.get(40);
	String driverIncentive = convertedWords.get(41);
	String police = convertedWords.get(42);
	String escort = convertedWords.get(43);
	String labourCharges = convertedWords.get(44);
	String othersExp = convertedWords.get(45);
	String total = convertedWords.get(46);
	String vendorName = convertedWords.get(47);
	String rate = convertedWords.get(48);
	String license = convertedWords.get(49);
	String insurance = convertedWords.get(50);
	String pollution = convertedWords.get(51);
	String shoes = convertedWords.get(52);
	String fluroscentJacket = convertedWords.get(53);
	String fixedRate = convertedWords.get(54);
	String ratePerDrum = convertedWords.get(55);
	String principalFrom = convertedWords.get(56);
	String principalTo = convertedWords.get(57);
	String principalCost = convertedWords.get(58);
	String consigneeFrom = convertedWords.get(59);
	String consigneeTo = convertedWords.get(60);
	String consigneeCost = convertedWords.get(61);
	String cleanerId = convertedWords.get(62);
	String salary = convertedWords.get(63);
	String reverseHorn = convertedWords.get(64);
	String noSmokingAndFire = convertedWords.get(65);
	String fitness = convertedWords.get(66);
%>

<jsp:include page="../Common/header.jsp" />
    <title>Master Approve Reject</title>
 
  	<%if (loginInfo.getStyleSheetOverride().equals("Y")){%>
	<jsp:include page="../Common/ImportJSSandMining.jsp"/>
	<%}else{%>
	<jsp:include page="../Common/ImportJS.jsp" />
	<%}%>
   <jsp:include page="../Common/ExportJS.jsp" />
   <style>
	.ext-strict .x-form-text {
		height: 21px !important;
	}
	label {
		display : inline !important;
	}
   </style>
    <script><!--
    
    var globalClientId ;
    var custName ;
    var grid ;
    var masterId = 0;
    var id = 0;
    var principalId = 0;
	var	consigneeId = 0;
	var	detentionTypeId = 0;
    
    var clientComboStore = new Ext.data.JsonStore({
              url: '<%=request.getContextPath()%>/CommonAction.do?param=getCustomer',
              id: 'clientNameStoreId',
              root: 'CustomerRoot',
              autoLoad: true,
              remoteSort: true,
              fields: ['CustId', 'CustName']
    });
    clientComboStore.on('load', function() {
        if (clientComboStore.data.items.length == 1) {
            var rec = clientComboStore .getAt(0);
            Ext.getCmp('custcomboId').setValue(rec.data['CustId']);
            globalClientId = Ext.getCmp('custcomboId').getValue();
            custName = Ext.getCmp('custcomboId').getRawValue();
            masterComboStore.load();
        }
    });

	var customerCombo = new Ext.form.ComboBox({
	    store: clientComboStore,
	    id: 'custcomboId',
	    mode: 'local',
	    forceSelection: true,
	    emptyText: '<%=selectClient%>',
	    blankText: '<%=selectClient%>',
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
	                globalClientId = Ext.getCmp('custcomboId').getValue();
	                custName = Ext.getCmp('custcomboId').getRawValue();
	            }
	        }
	    }
	});
	
	var masterComboStore = new Ext.data.JsonStore({
              url: '<%=request.getContextPath()%>/masterApproveRejectAction.do?param=getMaster',
              id: 'masterNameStoreId',
              root: 'masterRoot',
              autoLoad: true,
              remoteSort: true,
              fields: ['masterId', 'masterName']
    }); 
	
	var masterCombo = new Ext.form.ComboBox({
	    store: masterComboStore,
	    id: 'masterComboId',
	    mode: 'local',
	    forceSelection: true,
	    emptyText: '<%=selectMaster%>',
	    blankText: '<%=selectMaster%>',
	    selectOnFocus: true,
	    allowBlank: false,
	    anyMatch: true,
	    typeAhead: false,
	    triggerAction: 'all',
	    lazyRender: true,
	    valueField: 'masterId',
	    displayField: 'masterName',
	    cls: 'selectstylePerfect',
	    listeners: {
	        select: {
	            fn: function() {
	                masterId = Ext.getCmp('masterComboId').getValue();
					
	                if(masterId == 1) {//Customer Master
		               	store.removeAll();
					    gridDetails.hide();
					    pendingStore.removeAll();	
					    
	                	grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('IdIndex'), true);
						grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('companyNameIndex'), false);
						grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('companyCodeIndex'), false);
						grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('customerTypeIndex'), false);
						grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('invTypeIndex'), false);
						grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('locationIndex'), true);
						grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('vehicleModelIndex'), true);
						grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('principalNameIndex'), true);
						grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('consigneeNameIndex'), true);
						grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('fuelConsumptionIndex'), true);
						grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('fuelCmpnyNameIndex'), true);
						grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('fuelTypeIndex'), true);
						grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('holidayNameIndex'), true);
						//grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('holidayDateIndex'), true);
						grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('detentionTypeIndex'), true);
						grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('conductorNameIndex'), true);
						grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('conductorAddressIndex'), true);
						grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('statusIndex'), false);
						
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('addressIndex'), false);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('cityIndex'), false);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('stateIndex'), false);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('countryIndex'), false);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('factory1Index'), false);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('mobile1Index'), false);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('email1Index'), false);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('phoneNo1Index'), false);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('contactPersonIndex'), false);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('contactPersonPhoneNoIndex'), false);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('panNoIndex'), false);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('stNoIndex'), false);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('tinNoIndex'), false);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('effectiveFromIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('effectiveToIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('kmsIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('rFeeIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('bFeeIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('tollFeeIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('driverIncentiveIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('policeIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('escortIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('labourChargesIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('othersExpIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('totalIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('vendorNameIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('locationIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('fuelTypeIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('rateIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('licenseIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('insuranceIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('pollutionIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('shoesIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('fluroscentJacketIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('reverseHornIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('noSmokingAndFireIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('fitnessIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('holidayDateIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('fixedRateIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('ratePerDrumIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('principalFromIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('principalToIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('principalCostIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('consigneeFromIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('consigneeToIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('consigneeCostIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('cleanerIdIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('salaryIndex'), true);
	                } else if(masterId == 2) {//Toll Model Rate Master
		               	store.removeAll();
					    gridDetails.hide();
					    pendingStore.removeAll();	
					    	                
	                	grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('IdIndex'), true);
						grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('companyNameIndex'), true);
						grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('companyCodeIndex'), true);
						grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('customerTypeIndex'), true);
						grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('invTypeIndex'), true);
						grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('locationIndex'), false);
						grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('vehicleModelIndex'), false);
						grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('principalNameIndex'), true);
						grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('consigneeNameIndex'), true);
						grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('fuelConsumptionIndex'), true);
						grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('fuelCmpnyNameIndex'), true);
						grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('fuelTypeIndex'), true);
						grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('holidayNameIndex'), true);
						//grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('holidayDateIndex'), true);
						grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('detentionTypeIndex'), true);
						grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('conductorNameIndex'), true);
						grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('conductorAddressIndex'), true);
						grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('statusIndex'), true);
						
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('addressIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('cityIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('stateIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('countryIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('factory1Index'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('mobile1Index'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('email1Index'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('phoneNo1Index'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('contactPersonIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('contactPersonPhoneNoIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('panNoIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('stNoIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('tinNoIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('effectiveFromIndex'), false);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('effectiveToIndex'), false);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('kmsIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('rFeeIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('bFeeIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('tollFeeIndex'), false);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('driverIncentiveIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('policeIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('escortIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('labourChargesIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('othersExpIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('totalIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('vendorNameIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('locationIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('fuelTypeIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('rateIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('licenseIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('insuranceIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('pollutionIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('shoesIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('fluroscentJacketIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('reverseHornIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('noSmokingAndFireIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('fitnessIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('holidayDateIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('fixedRateIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('ratePerDrumIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('principalFromIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('principalToIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('principalCostIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('consigneeFromIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('consigneeToIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('consigneeCostIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('cleanerIdIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('salaryIndex'), true);
												
	                } else if(masterId == 3) {//Expense Master
		               	store.removeAll();
					    gridDetails.hide();
					    pendingStore.removeAll();	
					    	                
	                	grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('IdIndex'), true);
						grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('companyNameIndex'), true);
						grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('companyCodeIndex'), true);
						grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('customerTypeIndex'), true);
						grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('invTypeIndex'), true);
						grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('locationIndex'), true);
						grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('vehicleModelIndex'), false);
						grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('principalNameIndex'), false);
						grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('consigneeNameIndex'), false);
						grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('fuelConsumptionIndex'), false);
						grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('fuelCmpnyNameIndex'), true);
						grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('fuelTypeIndex'), true);
						grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('holidayNameIndex'), true);
						//grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('holidayDateIndex'), true);
						grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('detentionTypeIndex'), true);
						grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('conductorNameIndex'), true);
						grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('conductorAddressIndex'), true);
						grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('statusIndex'), true);
						//----------------------
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('addressIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('cityIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('stateIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('countryIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('factory1Index'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('mobile1Index'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('email1Index'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('phoneNo1Index'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('contactPersonIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('contactPersonPhoneNoIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('panNoIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('stNoIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('tinNoIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('effectiveFromIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('effectiveToIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('kmsIndex'), false);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('rFeeIndex'), false);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('bFeeIndex'), false);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('tollFeeIndex'), false);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('driverIncentiveIndex'), false);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('policeIndex'), false);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('escortIndex'), false);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('labourChargesIndex'), false);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('othersExpIndex'), false);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('totalIndex'), false);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('vendorNameIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('locationIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('fuelTypeIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('rateIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('licenseIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('insuranceIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('pollutionIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('shoesIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('fluroscentJacketIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('reverseHornIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('noSmokingAndFireIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('fitnessIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('holidayDateIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('fixedRateIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('ratePerDrumIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('principalFromIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('principalToIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('principalCostIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('consigneeFromIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('consigneeToIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('consigneeCostIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('cleanerIdIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('salaryIndex'), true);
												
	                } else if(masterId == 4) {//Fuel Rate Master
		               	store.removeAll();
					    gridDetails.hide();
					    pendingStore.removeAll();	
					    	                
		                grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('IdIndex'), true);
						grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('companyNameIndex'), true);
						grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('companyCodeIndex'), true);
						grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('customerTypeIndex'), true);
						grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('invTypeIndex'), true);
						grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('locationIndex'), true);
						grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('vehicleModelIndex'), true);
						grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('principalNameIndex'), true);
						grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('consigneeNameIndex'), true);
						grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('fuelConsumptionIndex'), true);
						grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('fuelCmpnyNameIndex'), false);
						grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('fuelTypeIndex'), false);
						grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('holidayNameIndex'), true);
						//grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('holidayDateIndex'), true);
						grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('detentionTypeIndex'), true);
						grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('conductorNameIndex'), true);
						grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('conductorAddressIndex'), true);
						grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('statusIndex'), false);
						//--------------------
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('addressIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('cityIndex'), false);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('stateIndex'), false);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('countryIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('factory1Index'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('mobile1Index'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('email1Index'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('phoneNo1Index'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('contactPersonIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('contactPersonPhoneNoIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('panNoIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('stNoIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('tinNoIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('effectiveFromIndex'), false);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('effectiveToIndex'), false);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('kmsIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('rFeeIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('bFeeIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('tollFeeIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('driverIncentiveIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('policeIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('escortIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('labourChargesIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('othersExpIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('totalIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('vendorNameIndex'), false);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('locationIndex'), false);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('fuelTypeIndex'), false);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('rateIndex'), false);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('licenseIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('insuranceIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('pollutionIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('shoesIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('fluroscentJacketIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('reverseHornIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('noSmokingAndFireIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('fitnessIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('holidayDateIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('fixedRateIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('ratePerDrumIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('principalFromIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('principalToIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('principalCostIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('consigneeFromIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('consigneeToIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('consigneeCostIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('cleanerIdIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('salaryIndex'), true);
												
	                } else if(masterId == 5) {//HSC Master
		               	store.removeAll();
					    gridDetails.hide();
					    pendingStore.removeAll();	
					    	                
	                	grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('IdIndex'), true);
						grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('companyNameIndex'), false);
						grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('companyCodeIndex'), true);
						grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('customerTypeIndex'), false);
						grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('invTypeIndex'), true);
						grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('locationIndex'), true);
						grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('vehicleModelIndex'), true);
						grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('principalNameIndex'), true);
						grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('consigneeNameIndex'), true);
						grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('fuelConsumptionIndex'), true);
						grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('fuelCmpnyNameIndex'), true);
						grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('fuelTypeIndex'), true);
						grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('holidayNameIndex'), true);
						//grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('holidayDateIndex'), true);
						grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('detentionTypeIndex'), true);
						grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('conductorNameIndex'), true);
						grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('conductorAddressIndex'), true);
						grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('statusIndex'), true);
						//----------------------
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('addressIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('cityIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('stateIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('countryIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('factory1Index'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('mobile1Index'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('email1Index'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('phoneNo1Index'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('contactPersonIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('contactPersonPhoneNoIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('panNoIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('stNoIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('tinNoIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('effectiveFromIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('effectiveToIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('kmsIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('rFeeIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('bFeeIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('tollFeeIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('driverIncentiveIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('policeIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('escortIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('labourChargesIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('othersExpIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('totalIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('vendorNameIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('locationIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('fuelTypeIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('rateIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('licenseIndex'), false);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('insuranceIndex'), false);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('pollutionIndex'), false);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('shoesIndex'), false);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('fluroscentJacketIndex'), false);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('reverseHornIndex'), false);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('noSmokingAndFireIndex'), false);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('fitnessIndex'), false);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('holidayDateIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('fixedRateIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('ratePerDrumIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('principalFromIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('principalToIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('principalCostIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('consigneeFromIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('consigneeToIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('consigneeCostIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('cleanerIdIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('salaryIndex'), true);
	                } else if(masterId == 6) {
		               	store.removeAll();
					    gridDetails.hide();
					    pendingStore.removeAll();	
					    	                
	                	grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('IdIndex'), true);
						grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('companyNameIndex'), true);
						grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('companyCodeIndex'), true);
						grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('customerTypeIndex'), true);
						grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('invTypeIndex'), true);
						grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('locationIndex'), true);
						grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('vehicleModelIndex'), true);
						grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('principalNameIndex'), true);
						grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('consigneeNameIndex'), true);
						grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('fuelConsumptionIndex'), true);
						grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('fuelCmpnyNameIndex'), true);
						grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('fuelTypeIndex'), true);
						grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('holidayNameIndex'), false);
						//grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('holidayDateIndex'), true);
						grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('detentionTypeIndex'), true);
						grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('conductorNameIndex'), true);
						grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('conductorAddressIndex'), true);
						grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('statusIndex'), true);
						//---------------------
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('addressIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('cityIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('stateIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('countryIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('factory1Index'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('mobile1Index'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('email1Index'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('phoneNo1Index'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('contactPersonIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('contactPersonPhoneNoIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('panNoIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('stNoIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('tinNoIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('effectiveFromIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('effectiveToIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('kmsIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('rFeeIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('bFeeIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('tollFeeIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('driverIncentiveIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('policeIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('escortIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('labourChargesIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('othersExpIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('totalIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('vendorNameIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('locationIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('fuelTypeIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('rateIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('licenseIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('insuranceIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('pollutionIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('shoesIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('fluroscentJacketIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('reverseHornIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('noSmokingAndFireIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('fitnessIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('holidayDateIndex'), false);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('fixedRateIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('ratePerDrumIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('principalFromIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('principalToIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('principalCostIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('consigneeFromIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('consigneeToIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('consigneeCostIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('cleanerIdIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('salaryIndex'), true);
												
	                } else if(masterId == 7) {
		               	store.removeAll();
					    gridDetails.hide();
					    pendingStore.removeAll();	
					    	                
	                	grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('IdIndex'), true);
						grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('companyNameIndex'), true);
						grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('companyCodeIndex'), true);
						grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('customerTypeIndex'), true);
						grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('invTypeIndex'), true);
						grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('locationIndex'), true);
						grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('vehicleModelIndex'), true);
						grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('principalNameIndex'), false);
						grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('consigneeNameIndex'), false);
						grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('fuelConsumptionIndex'), true);
						grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('fuelCmpnyNameIndex'), true);
						grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('fuelTypeIndex'), true);
						grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('holidayNameIndex'), true);
						//grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('holidayDateIndex'), true);
						grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('detentionTypeIndex'), false);
						grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('conductorNameIndex'), true);
						grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('conductorAddressIndex'), true);
						grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('statusIndex'), true);
						//--------------------------
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('addressIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('cityIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('stateIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('countryIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('factory1Index'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('mobile1Index'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('email1Index'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('phoneNo1Index'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('contactPersonIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('contactPersonPhoneNoIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('panNoIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('stNoIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('tinNoIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('effectiveFromIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('effectiveToIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('kmsIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('rFeeIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('bFeeIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('tollFeeIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('driverIncentiveIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('policeIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('escortIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('labourChargesIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('othersExpIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('totalIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('vendorNameIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('locationIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('fuelTypeIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('rateIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('licenseIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('insuranceIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('pollutionIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('shoesIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('fluroscentJacketIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('reverseHornIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('noSmokingAndFireIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('fitnessIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('holidayDateIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('fixedRateIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('ratePerDrumIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('principalFromIndex'), false);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('principalToIndex'), false);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('principalCostIndex'), false);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('consigneeFromIndex'), false);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('consigneeToIndex'), false);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('consigneeCostIndex'), false);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('cleanerIdIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('salaryIndex'), true);
						
	                } else if(masterId == 8) {
		               	store.removeAll();
					    gridDetails.hide();
					    pendingStore.removeAll();	
					    	                
	                	grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('IdIndex'), true);
						grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('companyNameIndex'), true);
						grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('companyCodeIndex'), true);
						grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('customerTypeIndex'), true);
						grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('invTypeIndex'), true);
						grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('locationIndex'), true);
						grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('vehicleModelIndex'), true);
						grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('principalNameIndex'), true);
						grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('consigneeNameIndex'), true);
						grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('fuelConsumptionIndex'), true);
						grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('fuelCmpnyNameIndex'), true);
						grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('fuelTypeIndex'), true);
						grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('holidayNameIndex'), true);
						//grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('holidayDateIndex'), true);
						grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('detentionTypeIndex'), true);
						console.log(grid.getColumnModel().findColumnIndex('conductorNameIndex'));
						grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('conductorNameIndex'), false);
						grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('conductorAddressIndex'), false);
						grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('statusIndex'), false);
						//------------------------
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('addressIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('cityIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('stateIndex'), false);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('countryIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('factory1Index'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('mobile1Index'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('email1Index'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('phoneNo1Index'), false);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('contactPersonIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('contactPersonPhoneNoIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('panNoIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('stNoIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('tinNoIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('effectiveFromIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('effectiveToIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('kmsIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('rFeeIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('bFeeIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('tollFeeIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('driverIncentiveIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('policeIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('escortIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('labourChargesIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('othersExpIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('totalIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('vendorNameIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('locationIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('fuelTypeIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('rateIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('licenseIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('insuranceIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('pollutionIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('shoesIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('fluroscentJacketIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('reverseHornIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('noSmokingAndFireIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('fitnessIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('holidayDateIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('fixedRateIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('ratePerDrumIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('principalFromIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('principalToIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('principalCostIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('consigneeFromIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('consigneeToIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('consigneeCostIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('cleanerIdIndex'), false);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('salaryIndex'), false);
						
	                } else if(masterId == 9 || masterId == 10) {
		               	store.removeAll()
					    gridDetails.hide();
					    pendingStore.removeAll();	
					    	                
	                	grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('IdIndex'), true);
						grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('companyNameIndex'), true);
						grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('companyCodeIndex'), true);
						grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('customerTypeIndex'), true);
						grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('invTypeIndex'), true);
						grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('locationIndex'), true);
						grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('vehicleModelIndex'), true);
						grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('principalNameIndex'), false);
						grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('consigneeNameIndex'), false);
						grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('fuelConsumptionIndex'), true);
						grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('fuelCmpnyNameIndex'), true);
						grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('fuelTypeIndex'), true);
						grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('holidayNameIndex'), true);
						//grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('holidayDateIndex'), true);
						grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('detentionTypeIndex'), true);
						grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('conductorNameIndex'), true);
						grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('conductorAddressIndex'), true);
						grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('statusIndex'), true);
						//----------------
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('addressIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('cityIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('stateIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('countryIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('factory1Index'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('mobile1Index'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('email1Index'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('phoneNo1Index'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('contactPersonIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('contactPersonPhoneNoIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('panNoIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('stNoIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('tinNoIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('effectiveFromIndex'), false);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('effectiveToIndex'), false);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('kmsIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('rFeeIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('bFeeIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('tollFeeIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('driverIncentiveIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('policeIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('escortIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('labourChargesIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('othersExpIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('totalIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('vendorNameIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('locationIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('fuelTypeIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('rateIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('licenseIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('insuranceIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('pollutionIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('shoesIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('fluroscentJacketIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('reverseHornIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('noSmokingAndFireIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('fitnessIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('holidayDateIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('fixedRateIndex'), false);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('ratePerDrumIndex'), false);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('principalFromIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('principalToIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('principalCostIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('consigneeFromIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('consigneeToIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('consigneeCostIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('cleanerIdIndex'), true);
						gridDetails.getColumnModel().setHidden(gridDetails.getColumnModel().findColumnIndex('salaryIndex'), true);
						
	                }
	            }
	        }
	    }
	}); 
	
   var custAndMasterPanel = new Ext.Panel({
    standardSubmit: false,
	frame: true,
	autoHeight: true,
	border: false,
   	layout : 'table',
   	layoutConfig : { 
   		columns : 10 
   	},
   	items : [ { width : 30 }, {
   			xtype : 'label',
   			text : 'Select Master' + ' : ',
   			cls : 'labelstyle'
   		}, { width : 30 },
   			masterCombo,{ width : 50 }, {
   			xtype : 'button',
   			text : 'View',
   			handler : function(){
				    gridDetails.hide();
				    pendingStore.removeAll();   			
   					store.load({params:{
						masterId: masterId
					}});
   			}	
   		} 
   		
   	]
   });
   
   
//******************grid config starts********************************************************
		// **********************reader configs
	var reader = new Ext.data.JsonReader({
        idProperty: 'masterReaderId',
        root: 'masterRoot',
        totalProperty: 'total',
        fields: [
        {name: 'slnoIndex'},
        {name: 'IdIndex'},
        {name: 'companyNameIndex'},
        {name: 'companyCodeIndex'},
        {name: 'customerTypeIndex'},
        {name: 'invTypeIndex'},
        {name: 'locationIndex'},
        {name: 'vehicleModelIndex'},
        {name: 'principalNameIndex'},
        {name: 'consigneeNameIndex'},
        {name: 'principalIdIndex'},
        {name: 'consigneeIdIndex'},
        {name: 'fuelConsumptionIndex'},
		{name: 'fuelCmpnyNameIndex'},
        {name: 'fuelTypeIndex'},
		{name: 'holidayNameIndex'},
		{name: 'detentionTypeIndex'},
		{name: 'detentionTypeIdIndex'},
		{name: 'conductorNameIndex'},
        {name: 'conductorAddressIndex'},
        {name: 'statusIndex'}
        ]
    });

//************************* store configs
	var store =  new Ext.data.GroupingStore({
        autoLoad: false,
        proxy: new Ext.data.HttpProxy({
        url:'<%=request.getContextPath()%>/masterApproveRejectAction.do?param=getMasterDetails',
        method: 'POST'
		}),
        remoteSort: false,
        sortInfo: {
            field: 'IdIndex',
            direction: 'ASC'
        },
        storeId: 'masterStore',
        reader:reader
    });
    
//**********************filter config
    var filters = new Ext.ux.grid.GridFilters({
    local:true,
        filters: [
        	{type: 'numeric',dataIndex: 'slnoIndex'},
        	{type: 'numeric',dataIndex: 'IdIndex'},
	        {type: 'string', dataIndex: 'companyNameIndex'},
	        {type: 'string', dataIndex: 'companyCodeIndex'},
	        {type: 'string', dataIndex: 'customerTypeIndex'},
	        {type: 'string', dataIndex: 'invTypeIndex'},
	        {type: 'string', dataIndex: 'locationIndex'},
	        {type: 'string', dataIndex: 'vehicleModelIndex'},
	        {type: 'string', dataIndex: 'principalNameIndex'},
	        {type: 'string', dataIndex: 'consigneeNameIndex'},
	        {type: 'string', dataIndex: 'principalIdIndex'},
	        {type: 'string', dataIndex: 'consigneeIdIndex'},
	        {type: 'numeric', dataIndex: 'fuelConsumptionIndex'},
	        {type: 'string', dataIndex: 'fuelCmpnyNameIndex'},
	        {type: 'string', dataIndex: 'fuelTypeIndex'},
	        {type: 'string', dataIndex: 'holidayNameIndex'},
	        {type: 'string', dataIndex: 'detentionTypeIndex'},
	        {type: 'numeric', dataIndex: 'detentionTypeIdIndex'},
	        {type: 'string', dataIndex: 'conductorNameIndex'},
	        {type: 'string', dataIndex: 'conductorAddressIndex'},
	        {type: 'string', dataIndex: 'statusIndex'}
        ]
    });

//**************column model config
    var createColModel = function (finish, start) {

        var columns = [
        new Ext.grid.RowNumberer({header: "<span style=font-weight:bold;><%=SLNO%></span>",width:40}),
        {
            dataIndex: 'slnoIndex',
            hidden: true,
            width: 150,
            header: "<span style=font-weight:bold;><%=SLNO%></span>"
        },
        {
            dataIndex: 'IdIndex',
            hidden: true,
            width: 150,
            header: "<span style=font-weight:bold;><%=UID%></span>"
        },
        {
            dataIndex: 'companyNameIndex',
            hidden: false,
            width: 150,
            header: "<span style=font-weight:bold;><%=companyName%></span>"
        },
        {
			dataIndex: 'companyCodeIndex',
            hidden: false,
            width: 150,
            header: "<span style=font-weight:bold;><%=companyId%></span>"
		},
		{
			dataIndex: 'customerTypeIndex',
            hidden: false,
            width: 150,
            header: "<span style=font-weight:bold;><%=customerType%></span>"
		},
		{
			dataIndex: 'invTypeIndex',
            hidden: false,
            width: 150,
            header: "<span style=font-weight:bold;><%=invType%></span>"
		},
		{
			dataIndex: 'locationIndex',
            hidden: false,
            width: 150,
            header: "<span style=font-weight:bold;><%=location%></span>"
		},
		{
			dataIndex: 'vehicleModelIndex',
            hidden:false,
            width: 150,
            header: "<span style=font-weight:bold;><%=vehicleModel%></span>"
		},
		{
			dataIndex: 'principalNameIndex',
            hidden: false,
            width: 150,
            header: "<span style=font-weight:bold;><%=principalName%></span>"
		},
		{
			dataIndex: 'consigneeNameIndex',
            hidden: false,
            width: 150,
            header: "<span style=font-weight:bold;><%=consigneeName%></span>"
		},
		{
			dataIndex: 'principalIdIndex',
            hidden: true,
            hideable: false,
            width: 150,
            header: "<span style=font-weight:bold;>Principal Id</span>"
		},
		{
			dataIndex: 'consigneeIdIndex',
            hidden: true,
            hideable: false,
            width: 150,
            header: "<span style=font-weight:bold;>Consignee Id</span>"
		},
		{
			dataIndex: 'fuelConsumptionIndex',
            hidden:false,
            width: 150,
            header: "<span style=font-weight:bold;><%=fuelConsumption%></span>"
		},
		{
			dataIndex: 'fuelCmpnyNameIndex',
            hidden: false,
            width: 150,
            header: "<span style=font-weight:bold;><%=fuelCompanyName%></span>"
		},
		{
			dataIndex: 'fuelTypeIndex',
            hidden:false,
            width: 150,
            header: "<span style=font-weight:bold;><%=fuelType%></span>"
		},
		{
			dataIndex: 'holidayNameIndex',
            hidden: false,
            width: 150,
            header: "<span style=font-weight:bold;><%=holidayName%></span>"
		},
		{
			dataIndex: 'detentionTypeIndex',
            hidden:  false,
            width: 150,
            header: "<span style=font-weight:bold;><%=detentionType%></span>"
		},
		{
			dataIndex: 'detentionTypeIdIndex',
            hidden:  true,
            hideable: false,
            width: 150,
            header: "<span style=font-weight:bold;>Detention Type Id</span>"
		},
		{
			dataIndex: 'conductorNameIndex',
            hidden:false,
            width: 150,
            header: "<span style=font-weight:bold;><%=cleaner%></span>"
		},
		{
			dataIndex: 'conductorAddressIndex',
            hidden: false,
            width: 150,
            header: "<span style=font-weight:bold;><%=address%></span>"
		},
		{
			dataIndex: 'statusIndex',
            hidden: false,
            width: 150,
            header: "<span style=font-weight:bold;><%=status%></span>"
		}
       ];

        return new Ext.grid.ColumnModel({
            columns: columns.slice(start || 0, finish),
            defaults: {
                sortable: true
            }
         })
       };


//----------------------------------------------Approve Grid Details Start-----------------------------------
	var pendingReader = new Ext.data.JsonReader({
        idProperty: 'pendingReaderId',
        root: 'masterPendingRoot',
        totalProperty: 'total',
        fields: [
        {name: 'slnoIndex'},
        {name: 'rowDetailsIndex'},
        {name: 'addressIndex'},
        {name: 'cityIndex'},
        {name: 'stateIndex'},
        {name: 'countryIndex'},
        {name: 'factory1Index'},
        {name: 'mobile1Index'},
        {name: 'email1Index'},
        {name: 'phoneNo1Index'},
        {name: 'contactPersonIndex'},
        {name: 'contactPersonPhoneNoIndex'},
		{name: 'panNoIndex'},
        {name: 'stNoIndex'},
		{name: 'tinNoIndex'},
        {name: 'effectiveFromIndex'},
		{name: 'effectiveToIndex'},
		{name: 'kmsIndex'},
        {name: 'rFeeIndex'},
        {name: 'bFeeIndex'},
        {name: 'tollFeeIndex'},
        {name: 'driverIncentiveIndex'},
        {name: 'policeIndex'},
        {name: 'escortIndex'},
        {name: 'labourChargesIndex'},
        {name: 'othersExpIndex'},
		{name: 'totalIndex'},
        {name: 'vendorNameIndex'},
		{name: 'locationIndex'},
        {name: 'fuelTypeIndex'},
		{name: 'rateIndex'},
		{name: 'licenseIndex'},
		{name: 'insuranceIndex'},
        {name: 'pollutionIndex'},
        {name: 'shoesIndex'},
        {name: 'fluroscentJacketIndex'},
        {name: 'reverseHornIndex'},
		{name: 'noSmokingAndFireIndex'},
		{name: 'fitnessIndex'},
        {name: 'holidayDateIndex'},
        {name: 'fixedRateIndex'},
        {name: 'ratePerDrumIndex'},
        {name: 'principalFromIndex'},
        {name: 'principalToIndex'},
        {name: 'principalCostIndex'},
		{name: 'consigneeFromIndex'},
        {name: 'consigneeToIndex'},
		{name: 'consigneeCostIndex'},
        {name: 'cleanerIdIndex'},
		{name: 'salaryIndex'}
        ]
    });

//************************* store configs
	var pendingStore =  new Ext.data.GroupingStore({
        autoLoad: false,
        proxy: new Ext.data.HttpProxy({
        url:'<%=request.getContextPath()%>/masterApproveRejectAction.do?param=getPendingMasterDetails',
        method: 'POST'
		}),
        remoteSort: false,
        sortInfo: {
            field: 'slnoIndex',
            direction: 'ASC'
        },
        storeId: 'masterPendingStore',
        reader:pendingReader
    });
    
    var pendingFilters = new Ext.ux.grid.GridFilters({
    local:true,
	filters: [
		{type: 'numeric',dataIndex: 'slnoIndex'},
		{type: 'string',dataIndex: 'rowDetailsIndex'},
		{type: 'string',dataIndex: 'addressIndex'},
		{type: 'string', dataIndex: 'cityIndex'},
		{type: 'string', dataIndex: 'stateIndex'},
		{type: 'string', dataIndex: 'countryIndex'},
		{type: 'string', dataIndex: 'factory1Index'},
		{type: 'numeric', dataIndex: 'mobile1Index'},
		{type: 'string', dataIndex: 'email1Index'},
		{type: 'numeric', dataIndex: 'phoneNo1Index'},
		{type: 'string', dataIndex: 'contactPersonIndex'},
		{type: 'numeric', dataIndex: 'contactPersonPhoneNoIndex'},
		{type: 'string', dataIndex: 'panNoIndex'},
		{type: 'string', dataIndex: 'stNoIndex'},
		{type: 'string', dataIndex: 'tinNoIndex'},
		{type: 'date', dataIndex: 'effectiveFromIndex'},
		{type: 'date', dataIndex: 'effectiveToIndex'},
		{type: 'numeric', dataIndex: 'kmsIndex'},
		{type: 'numeric', dataIndex: 'rFeeIndex'},
		{type: 'numeric', dataIndex: 'bFeeIndex'},	
		{type: 'numeric',dataIndex: 'tollFeeIndex'},
		{type: 'numeric',dataIndex: 'driverIncentiveIndex'},
		{type: 'numeric', dataIndex: 'policeIndex'},
		{type: 'numeric', dataIndex: 'escortIndex'},
		{type: 'numeric', dataIndex: 'labourChargesIndex'},
		{type: 'numeric', dataIndex: 'othersExpIndex'},
		{type: 'numeric', dataIndex: 'totalIndex'},
		{type: 'string', dataIndex: 'vendorNameIndex'},
		{type: 'string', dataIndex: 'locationIndex'},
		{type: 'string', dataIndex: 'fuelTypeIndex'},
		{type: 'numeric', dataIndex: 'rateIndex'},
		{type: 'string', dataIndex: 'licenseIndex'},
		{type: 'string', dataIndex: 'insuranceIndex'},
		{type: 'string', dataIndex: 'pollutionIndex'},
		{type: 'string', dataIndex: 'shoesIndex'},
		{type: 'string', dataIndex: 'fluroscentJacketIndex'},
		{type: 'string', dataIndex: 'reverseHornIndex'},
		{type: 'string', dataIndex: 'noSmokingAndFireIndex'},
		{type: 'string', dataIndex: 'fitnessIndex'},
		{type: 'date', dataIndex: 'holidayDateIndex'},
		{type: 'numeric', dataIndex: 'fixedRateIndex'},
		{type: 'numeric', dataIndex: 'ratePerDrumIndex'},	
		{type: 'string', dataIndex: 'principalFromIndex'},
		{type: 'string', dataIndex: 'principalToIndex'},
		{type: 'numeric', dataIndex: 'principalCostIndex'},
		{type: 'string', dataIndex: 'consigneeFromIndex'},
		{type: 'string', dataIndex: 'consigneeToIndex'},
		{type: 'numeric', dataIndex: 'consigneeCostIndex'},
		{type: 'string', dataIndex: 'cleanerIdIndex'},
		{type: 'numeric', dataIndex: 'salaryIndex'}
	]
    });

//**************column model config
   var pendingCreateColModel = function (finish, start) {

        var columns = [
		new Ext.grid.RowNumberer({header: "<span style=font-weight:bold;><%=SLNO%></span>",width:40}),
		{
			dataIndex: 'slnoIndex',
			hidden: true,
			width: 150,
			header: "<span style=font-weight:bold;><%=SLNO%></span>"
		},
		{
			dataIndex: 'rowDetailsIndex',
			hidden: false,
			width: 150,
			header: "<span style=font-weight:bold;>Row</span>"
		},
		{
			dataIndex: 'addressIndex',
			hidden: false,
			width: 150,
			header: "<span style=font-weight:bold;><%=address%></span>"
		},
		{
			dataIndex: 'cityIndex',
			hidden: false,
			width: 150,
			header: "<span style=font-weight:bold;><%=city%></span>"
		},
		{
			dataIndex: 'stateIndex',
			hidden: false,
			width: 150,
			header: "<span style=font-weight:bold;><%=state%></span>"
		},
		{
			dataIndex: 'countryIndex',
			hidden: false,
			width: 150,
			header: "<span style=font-weight:bold;><%=country%></span>"
		},
		{
			dataIndex: 'factory1Index',
            hidden: false,
			width: 150,
            header: "<span style=font-weight:bold;><%=factory1%></span>"
		},
		{
			dataIndex: 'mobile1Index',
            hidden: false,
			width: 150,
            header: "<span style=font-weight:bold;><%=mobile%></span>"
		},
		{
			dataIndex: 'email1Index',
            hidden: false,
			width: 150,
            header: "<span style=font-weight:bold;><%=email%></span>"
		},
		{
			dataIndex: 'phoneNo1Index',
            hidden: false,
			width: 150,
            header: "<span style=font-weight:bold;><%=phoneNo%></span>"
		},
		{
			dataIndex: 'contactPersonIndex',
            hidden: false,
			width: 150,
            header: "<span style=font-weight:bold;><%=contactPerson%></span>"
		},
		{
			dataIndex: 'contactPersonPhoneNoIndex',
            hidden: false,
			width: 150,
            header: "<span style=font-weight:bold;><%=contactPersonPhoneNo%></span>"
		},
		{
			dataIndex: 'panNoIndex',
            hidden: false,
			width: 150,
            header: "<span style=font-weight:bold;><%=panNo%></span>"
		},
		{
			dataIndex: 'stNoIndex',
            hidden: false,
			width: 150,
            header: "<span style=font-weight:bold;><%=stNo%></span>"
		},
		{
			dataIndex: 'tinNoIndex',
            hidden: false,
			width: 150,
            header: "<span style=font-weight:bold;><%=tinNo%></span>"
		},
		{
			dataIndex: 'effectiveFromIndex',
            hidden: true,
			width: 150,
            header: "<span style=font-weight:bold;><%=effectiveFrom%></span>",
            renderer: new Ext.util.Format.dateRenderer('d/m/Y H:i:s')
		},
		{
			dataIndex: 'effectiveToIndex',
            hidden: true,
			width: 150,
            header: "<span style=font-weight:bold;><%=effectiveTo%></span>",
            renderer: new Ext.util.Format.dateRenderer('d/m/Y H:i:s')
		},
		{
			dataIndex: 'kmsIndex',
            hidden: true,
			width: 150,
            header: "<span style=font-weight:bold;><%=kms%></span>"
		},
		{
			dataIndex: 'rFeeIndex',
            hidden: true,
			width: 150,
            header: "<span style=font-weight:bold;><%=rFee%></span>"
		},
		{
			dataIndex: 'bFeeIndex',
            hidden: true,
			width: 150,
            header: "<span style=font-weight:bold;><%=bFee%></span>"
		},
		{
			dataIndex: 'tollFeeIndex',
            hidden: true,
			width: 150,
            header: "<span style=font-weight:bold;><%=tollFee%></span>"
		},
		{
			dataIndex: 'driverIncentiveIndex',
			hidden:  true,
			width: 150,
			header: "<span style=font-weight:bold;><%=driverIncentive%></span>"
		},
		{
			dataIndex: 'policeIndex',
			hidden: true,
			width: 150,
			header: "<span style=font-weight:bold;><%=police%></span>"
		},
		{
			dataIndex: 'escortIndex',
			hidden: true,
			width: 150,
			header: "<span style=font-weight:bold;><%=escort%></span>"
		},
		{
			dataIndex: 'labourChargesIndex',
			hidden: true,
			width: 150,
			header: "<span style=font-weight:bold;><%=labourCharges%></span>"
		},
		{
			dataIndex: 'othersExpIndex',
			hidden: true,
			width: 150,
			header: "<span style=font-weight:bold;><%=othersExp%></span>"
		},
		{
			dataIndex: 'totalIndex',
            hidden: true,
			width: 150,
            header: "<span style=font-weight:bold;><%=total%></span>"
		},
		{
			dataIndex: 'vendorNameIndex',
            hidden: true,
			width: 150,
            header: "<span style=font-weight:bold;><%=vendorName%></span>"
		},
		{
			dataIndex: 'locationIndex',
            hidden: true,
			width: 150,
            header: "<span style=font-weight:bold;><%=location%></span>"
		},
		{
			dataIndex: 'fuelTypeIndex',
            hidden: true,
			width: 150,
            header: "<span style=font-weight:bold;><%=fuelType%></span>"
		},
		{
			dataIndex: 'rateIndex',
            hidden: true,
			width: 150,
            header: "<span style=font-weight:bold;><%=rate%></span>"
		},
		{
			dataIndex: 'licenseIndex',
            hidden: true,
			width: 150,
            header: "<span style=font-weight:bold;><%=license%></span>"
		},
		{
			dataIndex: 'insuranceIndex',
            hidden: true,
			width: 150,
            header: "<span style=font-weight:bold;><%=insurance%></span>"
		},
		{
			dataIndex: 'pollutionIndex',
            hidden: true,
			width: 150,
            header: "<span style=font-weight:bold;><%=pollution%></span>"
		},
		{
			dataIndex: 'shoesIndex',
            hidden: true,
			width: 150,
            header: "<span style=font-weight:bold;><%=shoes%></span>"
		},
		{
			dataIndex: 'fluroscentJacketIndex',
            hidden:true,
			width: 150,
            header: "<span style=font-weight:bold;><%=fluroscentJacket%></span>"
		},
		{
			dataIndex: 'reverseHornIndex',
            hidden:true,
			width: 150,
            header: "<span style=font-weight:bold;><%=reverseHorn%></span>"
		},
		{
			dataIndex: 'noSmokingAndFireIndex',
            hidden:true,
			width: 150,
            header: "<span style=font-weight:bold;><%=noSmokingAndFire%></span>"
		},
		{
			dataIndex: 'fitnessIndex',
            hidden:true,
			width: 150,
            header: "<span style=font-weight:bold;><%=fitness%></span>"
		},		
		{
			dataIndex: 'holidayDateIndex',
            hidden:true,
			width: 150,
            header: "<span style=font-weight:bold;><%=holidayDate%></span>"
		},
		{
			dataIndex: 'fixedRateIndex',
            hidden:true,
			width: 150,
            header: "<span style=font-weight:bold;><%=fixedRate%></span>"
		},
		{
			dataIndex: 'ratePerDrumIndex',
            hidden:true,
			width: 150,
            header: "<span style=font-weight:bold;><%=ratePerDrum%></span>"
		},
		{
			dataIndex: 'principalFromIndex',
            hidden:true,
			width: 150,
            header: "<span style=font-weight:bold;><%=principalFrom%></span>"
		},
		{
			dataIndex: 'principalToIndex',
            hidden:true,
			width: 150,
            header: "<span style=font-weight:bold;><%=principalTo%></span>"
		},
		{
			dataIndex: 'principalCostIndex',
            hidden:true,
			width: 150,
            header: "<span style=font-weight:bold;><%=principalCost%></span>"
		},
		{
			dataIndex: 'consigneeFromIndex',
            hidden:true,
			width: 150,
            header: "<span style=font-weight:bold;><%=consigneeFrom%></span>"
		},
		{
			dataIndex: 'consigneeToIndex',
            hidden:true,
			width: 150,
            header: "<span style=font-weight:bold;><%=consigneeTo%></span>"
		},
		{
			dataIndex: 'consigneeCostIndex',
            hidden:true,
			width: 150,
            header: "<span style=font-weight:bold;><%=consigneeCost%></span>"
		},
		{
			dataIndex: 'cleanerIdIndex',
            hidden:true,
			width: 150,
            header: "<span style=font-weight:bold;><%=cleanerId%></span>"
		},
		{
			dataIndex: 'salaryIndex',
            hidden:true,
			width: 150,
            header: "<span style=font-weight:bold;><%=salary%></span>"
		}
		
		
       ];

        return new Ext.grid.ColumnModel({
            columns: columns.slice(start || 0, finish),
            defaults: {
                sortable: true
            }
         })
       };

grid = getGrid('Master Details','<%=NoRecordsFound%>',store,screen.width-60,200,25,filters,'Clear Filter Data',false,'',22,false,'',false,'',false,'','','',false,'',false,'',false,'',false,'');

gridDetails = getSecondGrid('<%=masterApproveReject%>','<%=NoRecordsFound%>',pendingStore,screen.width-60,200,50,pendingFilters,true,'Clear Filter Data',true,'Approve',true,'Reject');

function getSecondGrid(gridtitle,emptytext,store,width,height,noOfColumns,filters,filterNeed,filterstr,modify,modifystr,del,delstr){
	 var grid = new Ext.grid.GridPanel({
	    	title:gridtitle,
	        border: false,
	        height: getGridHeight(),
	        autoScroll:true,
	        hidden : true,
	        store: store,
	        id:'secondGrid',
	        colModel: pendingCreateColModel(noOfColumns),
	        loadMask: true,
	        view: new Ext.grid.GroupingView({
	        	autoFill:true,
	            groupTextTpl: getGroupConfig(),
	            emptyText: emptytext,deferEmptyText: false
	        }),
	        listeners: {
               render : function(grid){
                 grid.store.on('load', function(store, records, options){
                   grid.getSelectionModel().selectFirstRow();       
                 });                      
               }
              },
	        plugins: [filters],	       
	        bbar: new Ext.Toolbar({
	        })
	    });
	if(width>0){
		grid.setSize(width,height);
	}
		if(filterNeed){
			grid.getBottomToolbar().add([
	        '->',
	        {
	            text: filterstr,
	            iconCls : 'clearfilterbutton',
	            handler: function () {
	        	grid.filters.clearFilters();
	            } 
	        }]);
		} else {
			grid.getBottomToolbar().add(['->']);
		}
		if(modify)
		{
			grid.getBottomToolbar().add([
			'-',                             
			{
			    text:modifystr,
			    iconCls : 'validatebutton',
			    handler : function(){
			    approveData();

			    }    
			  }]);
		}
		if(del)
		{
			grid.getBottomToolbar().add([
			'-',                             
			{
			    text:delstr,
			    iconCls : 'deletebuttonNew',
			    id: 'gridDeleteId',
			    handler : function(){
			    rejectData();

			    }    
			  }]);
		}	
	return grid;
}

	function approveData() {
		Ext.Msg.show({
		   title:'Approve',
		   msg: 'Would you like to approve your changes?',
		   buttons: Ext.MessageBox.OKCANCEL,
		   animEl: 'elId',
		   icon: Ext.MessageBox.QUESTION,
		   fn: function(btn, opts){
		   
		   	if(btn == 'ok') {
		   		Ext.Ajax.request({
				   url: '<%=request.getContextPath()%>/masterApproveRejectAction.do?param=approve',
				   method: 'POST',
				   params: {masterId: masterId, id: id, principalId: principalId, consigneeId: consigneeId, detentionTypeId: detentionTypeId},
				   success: function(response, opts) {
				   		  //alert('sucsess' + response.responseText);
					   	  Ext.example.msg(response.responseText);
					      store.load({params:{
				        		masterId: masterId
				        	}
				          });
					      gridDetails.hide();
					      pendingStore.removeAll();				      
				   },
				   failure: function(response, opts) {
				  // alert('failure' + response.responseText);
					   	  Ext.example.msg(response.responseText);
					      store.load({params:{
				        		masterId: masterId
				        	}
				          });
					      gridDetails.hide();
					      pendingStore.removeAll();				      
				   }
				});
				}
		   }
		});
	}
	
	function rejectData() {
		Ext.Msg.show({
		   title:'Reject',
		   msg: 'Would you like to reject your changes?',
		   buttons: Ext.MessageBox.OKCANCEL,
		   animEl: 'elId',
		   icon: Ext.MessageBox.QUESTION,
		   fn: function(btn,text){
		  // alert(btn);
		   		if(btn == 'ok') {
			   		Ext.Ajax.request({
					   url: '<%=request.getContextPath()%>/masterApproveRejectAction.do?param=reject',
					   method: 'POST',
					   params: {masterId: masterId, id: id, principalId: principalId, consigneeId: consigneeId, detentionTypeId: detentionTypeId},
					   success: function(response, options) {
					   	 // alert('sucsess' + response.responseText);
					   	  Ext.example.msg(response.responseText);
					      store.load({params:{
				        		masterId: masterId
				        	}
				          });
					      gridDetails.hide();
					      pendingStore.removeAll();
					   },
					   failure: function(response, options) {
					   //	  alert('faliure' + response.responseText);
					   	  Ext.example.msg(response.responseText);
					      store.load({params:{
				        		masterId: masterId
				        	}
				          });
				          gridDetails.hide();
					      pendingStore.removeAll();
					   }
					});
				}
		   }
		});
	}
  		
	grid.on('rowclick', function(grid, rowIndex, columnIndex, e) {
		var rec = grid.getSelectionModel().getSelected();
		id = rec.get('IdIndex');
		principalId = rec.get('principalIdIndex');
		consigneeId = rec.get('consigneeIdIndex');
		detentionTypeId = rec.get('detentionTypeIdIndex');
		//console.log("rec.get('IdIndex') : "+rec.get('IdIndex'));
        //console.log(grid, rowIndex, columnIndex, e);
        gridDetails.show();
        pendingStore.load({params:{
        		masterId: masterId, id: id, principalId: principalId, consigneeId: consigneeId, detentionTypeId: detentionTypeId
        	}
        });
    }, this);
            
   Ext.onReady(function(){
	ctsb=tsb;
	Ext.QuickTips.init();
	Ext.form.Field.prototype.msgTarget = 'side';			         	   			
 	outerPanel = new Ext.Panel({
			title:'',
			renderTo : 'content',
			standardSubmit: true,
			autoScroll:false,
			frame:true,
			border:false,
			width:screen.width-38,
			height:500,
			cls:'outerpanel',
			items: [custAndMasterPanel, grid, gridDetails]
			//bbar:ctsb
		});
		grid.reconfigure(store, createColModel(22))
		gridDetails.reconfigure(pendingStore, pendingCreateColModel(50))
	}); 
	
	--></script>  
  <jsp:include page="../Common/footer.jsp" />
 <!-- </body>   -->
 <!-- </html> -->