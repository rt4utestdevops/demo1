 <%@ page  language="java" import="java.util.*,java.text.SimpleDateFormat,t4u.functions.*,t4u.beans.*,t4u.common.*" pageEncoding="utf-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
Properties prop = ApplicationListener.prop;
String RFIDwebServicePath=prop.getProperty("WebServiceUrlPathForRFID");
String WEIGHTwebServicePath=prop.getProperty("WebServiceUrlPathForWeight");
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
		if(loginInfo1!=null)
		{
		int isLtsp=loginInfo1.getIsLtsp();
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
		String startDate="";
		if(request.getParameter("startDate") != null && !request.getParameter("startDate").equals("")){
		startDate = request.getParameter("startDate"); 
		if(startDate.contains("+0530")){
		   startDatePrev = startDate.replace("+0530 ", " ");
		}else{
		   startDatePrev = startDate.replace(" 0530 ", " ");
		}
		}
		String endDate="";
		if(request.getParameter("endDate") != null && !request.getParameter("endDate").equals("")){
		endDate = request.getParameter("endDate"); 
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
	    if(loginInfo.getIsLtsp()== 0)
	    {
	        addButton="true";
		    startButton="true";
	        stopButton="true";
	        closetrip="true";
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
		}

%>

<!DOCTYPE HTML>
<html>
 <head>
 		<title>Train Trip Sheet</title>		
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
	 	var jspName='MiningTripSheetGenerationReport';
    	var exportDataType = "int,string,string,string,string,string,string,string,number,number,int,string";
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
 		var sd=new Date(startDate);
 		var endDate = '<%=endDate%>';
 		var ed=new Date(endDate);
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
					   if(back=='1'){
						 cusId=custId;
						}else{
						 cusId=Ext.getCmp('custcomboId').getValue();
					   }
                  vehicleComboStore.load({
				                    params: {
				                    CustId:cusId
				                     }
				             });	
                 var typeValue= Ext.getCmp('typecomboId').getValue();
   
  				 if(typeValue=='RFID'){
				   Ext.getCmp('RFIDId').reset();
				   Ext.getCmp('vehicleRFIDPanelId').show();
				   Ext.getCmp('detailsFirstMaster').setHeight(40);
				   Ext.getCmp('vehicleRFIDPanelId').setHeight(50);
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
				  if(typeValue=='APPLICATION'){ 
				   Ext.getCmp('vehiclecomboId').reset();
				  Ext.getCmp('vehicleRFIDPanelId').show(); 
				  Ext.getCmp('detailsFirstMaster').setHeight(40);
				  Ext.getCmp('vehicleRFIDPanelId').setHeight(50);
				 
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
	fields: ['Name','Value'],
	data: [['1','1'],['2','2'],['3','3'],['4','4']]
});


var reasonCombo = new Ext.form.ComboBox({
        store: reasonComboStore,
        id:'reasonComboId',
        mode: 'local',
        forceSelection: true,
        emptyText:'Select Reason',
        blankText:'Select Reason',
        selectOnFocus:true,
        anyMatch:true,
        typeAhead: false,
        triggerAction: 'all',
        lazyRender: true,
    	valueField: 'Value',
    	displayField: 'Name',
    	cls:'selectstylePerfect',
    	listeners: {
    }
    });
    
    var reasonCombo1 = new Ext.form.ComboBox({
        store: reasonComboStore,
        id:'reasonComboId1',
        mode: 'local',
        forceSelection: true,
        emptyText:'Select Reason',
        blankText:'Select Reason',
        selectOnFocus:true,
        anyMatch:true,
        typeAhead: false,
        triggerAction: 'all',
        lazyRender: true,
    	valueField: 'Value',
    	displayField: 'Name',
    	cls:'selectstylePerfect',
    	listeners: {
    }
    });
//************************ Store for Vehicel Number  Here***************************************//
	var vehicleComboStore = new Ext.data.JsonStore({
    url: '<%=request.getContextPath()%>/TripSheetGenerationActionForBarge.do?param=getVehicleList',
    id: 'vehicleComboStoreId',
    root: 'vehicleComboStoreRoot',
    autoload: false,
    remoteSort: true,
    fields: ['vehicleNoID', 'vehicleName','quantity1','bargeQuantity']
});



var vehicleCombo = new Ext.form.ComboBox({
    store: vehicleComboStore,
    id: 'vehiclecomboId',
    mode: 'local',
    forceSelection: true,
    selectOnFocus: true,
    resizable: true,
  //  allowBlank: false,
    anyMatch: true,
    typeAhead: false,
    listWidth:150,
    triggerAction: 'all',
    lazyRender: true,
    valueField: 'vehicleNoID',
    displayField: 'vehicleName',
    cls: 'selectstylePerfect',
	emptyText: 'Select Train Name',
    blankText: 'Select Train Name',
    listeners: {
        select: {
            fn: function() {
            var vehicleNo=Ext.getCmp('vehiclecomboId').getValue();
            var row = vehicleComboStore.findExact('vehicleNoID',vehicleNo);
            var rec = vehicleComboStore.getAt(row);
            Ext.getCmp('quantityId').setValue(rec.data['quantity1']);
            bargeQuantity=rec.data['bargeQuantity'];
            Ext.getCmp('tarequantityId').setValue(parseFloat(bargeQuantity)/1000)
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
    listWidth:150,
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
    listWidth:150,
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
			cls:'selectstylePerfect',
		    blankText: '<%=SelectValidityDate%>',
		    allowBlank:false,
				listeners: 	{
				     select:{
				         fn: function(){
				        
				         }//function
				       }//select
					}//listeners
	    });
	  
var StartDateForTare = new Ext.form.DateField({
			width: 185,
			format: getDateTimeFormat(),
			id: 'startDateTimeForTare',
            value: datecur,
            //minValue:endDateMinVal,
   			//maxValue: new Date(),
            vtype: 'daterange',
			cls:'selectstylePerfect',
		    blankText: '<%=SelectValidityDate%>',
		    allowBlank:false,
				listeners: 	{
				     select:{
				         fn: function(){
				        
				         }//function
				       }//select
					}//listeners
	    });
	    
 var tripStore = new Ext.data.JsonStore({
            url: '<%=request.getContextPath()%>/TripSheetGenerationAction.do?param=getTripDetails',
            id: 'tripStoreId',
            root: 'tripRoot',
            autoload: false,
            fields:  ['sHubId', 'dHubId', 'type','userSettingId','bargeLocId'],
            listeners: {
                load: function() {}
            }
        });

var modifyTripDetails = new Ext.data.JsonStore({
    url: '<%=request.getContextPath()%>/TripSheetGenerationAction.do?param=getPermitBalForModify',
    id: 'tripStoreId',
    root: 'tripRoot',
    autoload: false,
    fields: ['quantity','tripSheetQty'],
    listeners: {
        load: function() {}
    }
});

var tripStoreForRfid = new Ext.data.JsonStore({
    url: '<%=request.getContextPath()%>/TripSheetGenerationAction.do?param=getRFIDForTareWeight',
    id: 'tripStoreIdForRfid',
    root: 'tripRoot',
    autoload: false,
    fields: ['routeName','lesseName','jsonString','grade','validityDate','orgName'],
    listeners: {
        load: function() {}
    }
});

var tripStoreForRfidAdd = new Ext.data.JsonStore({
    url: '<%=request.getContextPath()%>/TripSheetGenerationActionForBarge.do?param=getRFID',
    id: 'tripStoreIdForRfidAdd',
    root: 'tripRoot',
    autoload: false,
    fields: ['quantity1','jsonString','bargeQuantity'],
    listeners: {
        load: function() {}
    }
});

var tripStoreForTare = new Ext.data.JsonStore({
    url: '<%=request.getContextPath()%>/TripSheetGenerationAction.do?param=getTripDetailsForTare',
    id: 'tripStoreIdForTare',
    root: 'tripRoot',
    autoload: false,
    fields: ['routeId','routeName','tcId','lesseName'],
    listeners: {
        load: function() {}
    }
});

var orgNameStore = new Ext.data.JsonStore({
    url: '<%=request.getContextPath()%>/TripSheetGenerationActionForBarge.do?param=getOrgNameForBarge',
    id: 'orgStoreRoot',
    root: 'orgRoot',
    autoload: false,
    fields: ['orgName','orgId'],
    listeners: {
        load: function() {}
    }
});
 var orgCombo = new Ext.form.ComboBox({
        store: orgNameStore,
        id:'orgId',
        mode: 'local',
        forceSelection: true,
        emptyText:'Select Organization',
        blankText:'Select Organization',
        selectOnFocus:true,
        anyMatch:true,
        typeAhead: false,
        triggerAction: 'all',
        lazyRender: true,
    	valueField: 'orgId',
    	displayField: 'orgName',
    	cls:'selectstylePerfect',
    	listeners: {
    }
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
        load: function (custstore, records, success, options) {
            if ( <%= customerId %> > 0) {            
                Ext.getCmp('custcomboId').setValue('<%=customerId%>');
                 var cm = grid.getColumnModel();  
					    for (var j = 1; j < cm.getColumnCount(); j++) {
					       cm.setColumnWidth(j,155);
					    }
				vehicleComboStore.load({
				                    params: {
				                    CustId: Ext.getCmp('custcomboId').getValue()
				                     }
				             });	
				         


              tripStore.load({
								    params:{
								    CustID :Ext.getCmp('custcomboId').getValue(),
								    },
								    callback : function() {
								     for (var i = 0; i < tripStore.getCount(); i++) {
								     	 var rec = tripStore.getAt(i);
							            //tcId = rec.data['tcId'];
	                                    //lesseName = rec.data['lesseName'];
	                                    srcHubId = rec.data['sHubId'];
	                                    desHubId = rec.data['dHubId'];
	                                    tripType = rec.data['type'];
	                                    userSettingId = rec.data['userSettingId'];
	                                    bargeLocId=rec.data['bargeLocId'];
	                                    //orgName = rec.data['orgName'];
	                                    //orgCode = rec.data['orgCode'];
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
            fn: function () {
                custId = Ext.getCmp('custcomboId').getValue();
                 var cm = grid.getColumnModel();  
					    for (var j = 1; j < cm.getColumnCount(); j++) {
					       cm.setColumnWidth(j,155);
					    }

             	vehicleComboStore.load({
				                    params: {
				                    CustId: Ext.getCmp('custcomboId').getValue()
				                     }
				             });
				
				
				 tripStore.load({
								    params:{
								    CustID :Ext.getCmp('custcomboId').getValue(),
								    },
								    callback : function() {
								     for (var i = 0; i < tripStore.getCount(); i++) {
								     	 var rec = tripStore.getAt(i);
							           // tcId = rec.data['tcId'];
	                                    //lesseName = rec.data['lesseName'];
	                                    srcHubId = rec.data['sHubId'];
	                                    desHubId = rec.data['dHubId'];
	                                    tripType = rec.data['type'];
	                                    userSettingId = rec.data['userSettingId'];
	                                    bargeLocId=rec.data['bargeLocId'];
	                                    //orgName = rec.data['orgName'];
	                                    //orgCode = rec.data['orgCode'];
							            }
								    }
	    
	    					});
	    		
                                               
            }
        }
    }
	});
	
	

// **********************************************Reader configs Starts******************************
    
     var reader = new Ext.data.JsonReader({
        idProperty: 'tripcreationId',
    	root: 'trainTripSheetDetailsRoot',
    	totalProperty: 'total',
    	fields: [{
        name: 'slnoIndex'
    	},{
        name: 'TypeIndex'
    	},{
        name: 'TripSheetNumberIndex'
    	},{
        name: 'assetNoIndex'
    	},{
        name: 'validityDateDataIndex',
          type: 'date',
  		  dateFormat: getDateTimeFormat()
        },{
    	name: 'uniqueIDIndex'
    	},{
    	name: 'statusIndexId'
    	},{
    	name: 'q1IndexId'
    	},{
    	name: 'QuantityIndex'
    	},{
    	name : 'issuedIndexId'
    	},{
    	name : 'orgIdIndex'
    	},{
    	name : 'bargeLocIndex'
    	},{
    	name : 'vesselNameIndex'
    	},{
    	name : 'destinationIndex'
    	},{
    	name : 'boatNote'
    	},{
    	name : 'reason'
    	},{
    	name : 'closedDateIndex'
    	},{
    	name : 'stopBLODateTimeIndexId',
    	type: 'date',
  		  dateFormat: getDateTimeFormat()
    	}
    	]
    });
    
    // **********************************************Reader configs Ends******************************
    //********************************************Store Configs For Grid*************************

    var store = new Ext.data.GroupingStore({
        autoLoad: false,
        proxy: new Ext.data.HttpProxy({
            url: '<%=request.getContextPath()%>/TripSheetGenerationActionForBarge.do?param=getTrainTripSheetDetails',
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
    	},{
    	type: 'string',
        dataIndex: 'TypeIndex'
    	},{
    	type: 'string',
        dataIndex: 'TripSheetNumberIndex'
    	},{
    	type: 'string',
        dataIndex: 'assetNoIndex'
    	},{
    	type: 'date',
        dataIndex: 'validityDateDataIndex'
    	},{
    	type: 'string',
        dataIndex: 'statusIndexId'
    	},{
        type: 'int',
        dataIndex: 'q1IndexId'
    	},{
        type: 'int',
        dataIndex: 'QuantityIndex'
    	},{
    	type : 'string',
    	dataIndex : 'issuedIndexId'
    	},
    	{
    	type : 'int',
    	dataIndex : 'uniqueIDIndex'
    	},{
    	type:'string',
    	dataIndex : 'vesselNameIndex'
    	},{
    	type:'string',
    	dataIndex : 'destinationIndex'
    	},{
    	type:'string',
    	dataIndex : 'boatNote'
    	},{
    	type:'string',
    	dataIndex : 'reason'
    	},{
    	type: 'date',
    	dataIndex : 'closedDateIndex'
    	},{
    	type: 'date',
    	dataIndex : 'stopBLODateTimeIndexId'
    	}]
    	});
    	
    	//***************************************************Filter Config Ends ***********************

    //*********************************************Column model config**********************************
    var createColModel = function (finish, start) {

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
    		},{
        	header: "<span style=font-weight:bold;><%=TripSheetNumber%></span>",
        	dataIndex: 'TripSheetNumberIndex',
        	filter: {
            type: 'string'
        	}
    		},{
        	header: "<span style=font-weight:bold;>Train Name</span>",
        	dataIndex: 'assetNoIndex',
        	filter: {
            type: 'string'
        	}
    		},{
    		header: "<span style=font-weight:bold;>Issued Date</span>",
        	dataIndex: 'issuedIndexId',
        	filter: {
            type: 'string'
        	},
    		hidden :false
    		},{
    		header: "<span style=font-weight:bold;>Stop BLO DateTime</span>",
        	dataIndex: 'stopBLODateTimeIndexId',
        	renderer: Ext.util.Format.dateRenderer(getDateTimeFormat()),
        	filter: {
            type: 'date'
        	},
    		hidden :true
    		},{
        	header: "<span style=font-weight:bold;><%=ValidityDateTime%></span>",
        	dataIndex: 'validityDateDataIndex',
        	renderer: Ext.util.Format.dateRenderer(getDateTimeFormat()),
        	//width: 80,
        	filter: {
            type: 'date'
        	}
    		},{
        	header: "<span style=font-weight:bold;>Status</span>",
        	dataIndex: 'statusIndexId',
        	hidden :false,
        	filter: {
            type: 'string'
        	}
    		},{
    		header: "<span style=font-weight:bold;>Train Capacity</span>",
    		dataIndex: 'QuantityIndex',
    		//width: 110,    
    		sortable: true,	
    		align: 'right',	
    		filter: {
    		type: 'int'
    		}
    		},{
    		header: "<span style=font-weight:bold;>Quantity</span>",
    		dataIndex: 'q1IndexId',
    		//width: 110,    
    		sortable: true,
    		align: 'right',		
    		filter: {
    		type: 'int'
    		}
    		},{
    		header: "<span style=font-weight:bold;>Unique Id</span>",
    		dataIndex: 'uniqueIDIndex',
			hidden : true,
    		sortable: true,		
    		filter: {
    		type: 'int'
    		}
    		},{
        	header: "<span style=font-weight:bold;>Vessel Name</span>",
        	dataIndex: 'vesselNameIndex',
        	hidden :false,
        	filter: {
            type: 'string'
        	}
    		},{
        	header: "<span style=font-weight:bold;>Destination</span>",
        	dataIndex: 'destinationIndex',
        	hidden :false,
        	filter: {
            type: 'string'
        	}
    		},{
        	header: "<span style=font-weight:bold;>Boat Note</span>",
        	dataIndex: 'boatNote',
        	hidden :false,
        	filter: {
            type: 'string'
        	}
    		},{
        	header: "<span style=font-weight:bold;>Reason</span>",
        	dataIndex: 'reason',
        	hidden :false,
        	filter: {
            type: 'string'
        	}
    		},{
    		header: "<span style=font-weight:bold;>Closed DateTime</span>",
    		dataIndex: 'closedDateIndex',
			hidden : false,
    		sortable: true,		
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
     //*********************************************Column model config Ends*************************** 	
    //******************************************Creating Grid By Passing Parameter***********************
    
     grid = getGrid('Mining Train Trip Sheet Generation', '<%=noRecordsFound%>', store,screen.width-55,420, 20, filters, 'Clear Filter Data', false, '', 20, false, '', false, '', false, 'Excel', jspName, exportDataType, false, 'PDF',<%=addButton%>,'Add',true,'Modify',true,'Cancel',false,'',<%=startButton%>,'Start BLO',<%=stopButton%>,'Stop BLO',false,'',true,'View PDF',false,'',false,'',false,'',<%=closetrip%>,'Close Trip');
     grid.getBottomToolbar().add([
			'-',                             
			{
			    text:'',
			    iconCls : 'excelbutton',
			    handler : function(){
				getordreport('xls','All',jspName,grid,exportDataType);
			    }    
			}]);
					
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
        			custnamecombo,{width:10},
        			{
            xtype: 'label',
            cls: 'labelstyle',
            id: 'startdatelab',
            width: 200,
            text: 'Start Date' + ' :'
        }, {
            width: 10
        },{
            xtype: 'datefield',
            cls: 'selectstylePerfect',
            width:120,
            format: getDateFormat(),
            emptyText: 'Select Start Date',
            allowBlank: false,
            blankText: 'Select Start Date',
            id: 'startdate',
            value: dateprev
           // startDateField: 'startdate'
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
            width:160,
            format: getDateFormat(),
            emptyText: 'Select End Date',
            allowBlank: false,
            blankText: 'Select End Date',
            id: 'enddate',
            value: datenext
           // startDateField: 'startdate'
        },{width:20},{
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
			var Startdates=Ext.getCmp('startdate').getValue();
            var Enddates=Ext.getCmp('enddate').getValue();
            var dateDifrnc = new Date(Enddates).add(Date.DAY, -7);
            if(Startdates <=  dateDifrnc)
             {
              Ext.example.msg("Difference between two dates should not be  greater than 7 days.");
              Ext.getCmp('startdate').focus();
		      return;
			}
			  var cusId;
					   if(back=='1'){
						 cusId=custId;
						}else{
						 cusId=Ext.getCmp('custcomboId').getValue();
					   }
						
						store.load({
				                   params: {
				                        CustID: cusId,
				                        jspName: jspName,
				                        CustName: Ext.getCmp('custcomboId').getRawValue(),
				                        endDate : Ext.getCmp('enddate').getValue(),
				                        startDate: Ext.getCmp('startdate').getValue()
				                 }
				               });
						
						
            
        }
        }]
	});	    
	   
//------------------------------------------------------------------------//	    
var detailsFirstPanel = new Ext.Panel({
   				standardSubmit: true,
    			collapsible: false,
    			id: 'detailsFirstMaster',
    			layout: 'table',
    			frame: false,
    			border:false,
    			height:50,
				width :433,
    			layoutConfig: {
        		columns:5
    			},
    			items: [{
                   xtype: 'label',
                   text: '*',
                   cls: 'mandatoryfield',
                   id: 'mandatoryTypeId'
               },{
            		xtype: 'label',
           		    text: 'Type' + ' :',
            		cls: 'labelstyle',
            		id: 'typeNamelab'
        		},{width:82},typecombo,{
                   xtype: 'label',
                   text: '',
                   cls: 'mandatoryfield',
                   id: 'mandatoryTypeid'
                 }
        			]
	});
	

//----------------------------------------------------------------//	
 var vehicleRFIDPanel = new Ext.Panel({ 
		        id: 'vehicleRFIDPanelId', 
                standardSubmit: true,
    			hidden: true,
    			layout: 'table',
    			frame: false,
    			//height:80,
				width :437,
    			layoutConfig: {
        		columns: 6
    			},	
			items:[{
                   xtype: 'label',
                   text: '*',
                   cls: 'mandatoryfield',
                   id: 'mandatoryVehicleId'
               },{
                   xtype: 'label',
                   text: 'Train Name' + ' :',
                   cls: 'labelstyle',
                   id: 'VehicleNoID'
               },{width:48},vehicleCombo,{width:20},{
                   xtype: 'label',
                   text: '',
                   cls: 'mandatoryfield',
                   id: 'mandatoryVehicleNoId'
               },
               {
                   xtype: 'label',
                   text: '*',
                   cls: 'mandatoryfield',
                   id: 'mandatoryorg'
               },{
                   xtype: 'label',
                   text: 'Organization Name' + ' :',
                   cls: 'labelstyle',
                   id: 'orgLabelId'
               },{width:48},orgCombo,{width:20},{
                   xtype: 'label',
                   text: '',
                   cls: 'mandatoryfield',
                   id: 'mandatoryo'
               },
               {
                   xtype: 'label',
                   text: '*',
                   cls: 'mandatoryfield',
                   id: 'mandatoryRfid'
               },{
                   xtype: 'label',
                   text: 'Train No:',
                   cls: 'labelstyle',
                   id: 'RFIDIDs'
               },{width:52},{
                   xtype: 'textfield',
                   cls: 'selectstylePerfect',
                   emptyText: '<%=EnterVehicleNo%>',
                   allowBlank: false,
				   readOnly:true,
                   blankText: '<%=EnterVehicleNo%>',
                   id: 'RFIDId'
               },{width:20},{
                                      xtype:'button',
                   text:'<%=ReadRFID%>',
                   width:80,
                   id: 'RFIDButtId',
                   cls: 'buttonstyle',
                    listeners: {
		            click: {
		                fn: function () {
		                var cusId;
					   if(back=='1'){
						 cusId=custId;
						}else{
						 cusId=Ext.getCmp('custcomboId').getValue();
					   }
							var RFIDValue;
							$.ajax({
							type:"GET",
				    		url:'<%=RFIDwebServicePath%>',   			
				   			 success:
				       		 function(data){
				       		   if(data.includes('RSSOURCE') || data.includes('RSDESTINATION') || data.includes('TRANSACTION_NO')){
                                  split1=data.split('RSSOURCE');
                                  RFIDValue1 = split1[0].split('==');
                                  RFIDValue=RFIDValue1[1];
                                }else{
                                  RFIDValue = data;
                                }
				              tripStoreForRfidAdd.load({
								    params:{
								    CustID :cusId,
								    RFIDValue:RFIDValue
								    },
								    callback : function() {
								     for (var i = 0; i < tripStoreForRfidAdd.getCount(); i++) {
								     	var rec = tripStoreForRfidAdd.getAt(i);
							            var vehicleName = rec.data['jsonString'];
							            quantity1 = rec.data['quantity1'];
							            bargeQuantity = rec.data['bargeQuantity'];
							            }
							            if(tripStoreForRfidAdd.getCount()==0){
										Ext.example.msg("<%=SomethingWronginRFID%>");
										Ext.getCmp('RFIDIdT').setValue("<%=EnterVehicleNo%>");
										}else{
											Ext.getCmp('RFIDId').setValue(vehicleName);
                                            Ext.getCmp('quantityId').setValue(quantity1);
                                            Ext.getCmp('tarequantityId').setValue(parseFloat(bargeQuantity)/1000);
										}
								    }
	    
	    					});
				        	},error:function(){
					        	Ext.example.msg("Some thing went Wrong");
					        	}
							});

		                }//fun
		            }//click
      			  }//listeners
               }
			   ]
    }); 


var detailsSecondPanel = new Ext.Panel({
   				standardSubmit: true,
    			collapsible: false,
    			id: 'detailsSecondMaster',
    			layout: 'table',
    			frame: false,
    			height:280,
				width :437,
    			layoutConfig: {
        		columns: 5
    			},
    			items: [{
                xtype: 'label',
                text: '*',
                cls: 'mandatoryfield',
                id: 'mandatorytripsheetNumberId'
            },{
                xtype: 'label',
                text: '<%=TripSheetNumber%>'+'  :',
                cls: 'labelstyle',
                id: 'tripsheetNumberLabelId'
            },{
			    xtype: 'textfield',
                cls: 'selectstylePerfect',               
                emptyText: '<%=enterTripsheetNumber%>',
                blankText: '<%=enterTripsheetNumber%>',
                id: 'enrollNumberId',
            },{
                xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                id: 'mandatoryTripsheetNumber'
            },{
                xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                id: 'mandatoryTripsheetNumber1'
            },{
                xtype: 'label',
                text: ' ',
                cls: 'labelstyle',
                id: 'tripsheetNumberLabel55'
            },{
			    xtype: 'label',
                cls: 'selectstylePerfect',               
                emptyText: '',
                blankText: '',
                id: 'enrollNumberId55',
            },{
                xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                id: 'mandatoryTripsheetNumber55'
            },{
                xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                id: 'mandatoryTripsheetNumber1554'
            },{
                xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                id: 'mandatoryTripsheetNumber155d'
            },{
                xtype: 'label',
                text: '*',
                cls: 'mandatoryfield',
                id: 'mandatorydateValidityDateTime'
				}, {
					xtype: 'label',
					text: '<%=ValidityDateTime%>'+'  :',
					cls: 'labelstyle',
					id: 'validitydateTimeLabelId'
				},StartDate,{
					   xtype: 'label',
					   text: '',
					   cls: 'mandatoryfield',
					   id: 'mandatoryvalidityDateId'
               },{
					   xtype: 'label',
					   text: '',
					   cls: 'mandatoryfield',
					   id: 'mandatoryvalidityDateId1'
               },{
                xtype: 'label',
                text: ' ',
                cls: 'mandatoryfield',
                id: 'mandatorydateValidityDateTime77'
				}, {
					xtype: 'label',
					text: ' ',
					cls: 'labelstyle',
					id: 'validitydateTimeLabelId77'
				},{
					   xtype: 'label',
					   text: '',
					   cls: 'mandatoryfield',
					   id: 'mandatoryvalidityDateId77'
               },{
					   xtype: 'label',
					   text: '',
					   cls: 'mandatoryfield',
					   id: 'mandatoryvalidityDateId877'
               },{
					   xtype: 'label',
					   text: '',
					   cls: 'mandatoryfield',
					   id: 'mandatoryvalidityDateId88'
               },{
                xtype: 'label',
                text: ' ',
                cls: 'mandatoryfield',
                id: 'mandatoryvesselId'  
            },{
                xtype: 'label',
                text: 'Mother Vessel'+'  :',
                cls: 'labelstyle',
                id: 'vesselNameLabelId'
            },{
			    xtype: 'textfield',
                cls: 'selectstylePerfect',               
                emptyText: 'Enter Mother Vessel',
                blankText: 'Enter Mother Vessel',
                id: 'vesselNameId'
            },{
                xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                id: 'mandatoryvessel'
            },{
                xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                id: 'mandatoryvessel2'
            },{
                xtype: 'label',
                text: ' ',
                cls: 'mandatoryfield',
                id: 'mandatoryvessel3'
				}, {
					xtype: 'label',
					text: ' ',
					cls: 'labelstyle',
					id: 'vessel1'
				},{
					   xtype: 'label',
					   text: '',
					   cls: 'mandatoryfield',
					   id: 'vessel2'
               },{
					   xtype: 'label',
					   text: '',
					   cls: 'mandatoryfield',
					   id: 'vessel3'
               },{
					   xtype: 'label',
					   text: '',
					   cls: 'mandatoryfield',
					   id: 'vessel14'
               },{
                xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                id: 'mandatorydestinationId'  
            },{
                xtype: 'label',
                text: 'Destination'+'  :',
                cls: 'labelstyle',
                id: 'destiNameLabelId'
            },{
			    xtype: 'textfield',
                cls: 'selectstylePerfect',               
                emptyText: 'Enter Destination',
                blankText: 'Enter Destination',
                id: 'destinationNameId'
            },{
                xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                id: 'mandatordesti'
            },{
                xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                id: 'mandatorydesti1'
            },{
                xtype: 'label',
                text: ' ',
                cls: 'mandatoryfield',
                id: 'mandatorydesti2'
				}, {
					xtype: 'label',
					text: ' ',
					cls: 'labelstyle',
					id: 'desti1'
				},{
					   xtype: 'label',
					   text: '',
					   cls: 'mandatoryfield',
					   id: 'desti2'
               },{
					   xtype: 'label',
					   text: '',
					   cls: 'mandatoryfield',
					   id: 'desti3'
               },{
					   xtype: 'label',
					   text: '',
					   cls: 'mandatoryfield',
					   id: 'desti4'
               },{
                xtype: 'label',
                text: '*',
                cls: 'mandatoryfield',
                id: 'mandatoryboatnoteId'  
                
            },{
                xtype: 'label',
                text: 'Boat Note'+'  :',
                cls: 'labelstyle',
                id: 'boatNoteLabelId'
            },{
			    xtype: 'textarea',
                cls: 'selectstylePerfect',               
                emptyText: 'Enter Boat Note',
                blankText: 'Enter Boat Note',
                id: 'boatNoteId'
            },{
                xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                id: 'mandatornote'
            },{
                xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                id: 'mandatorynote1'
            },{
                xtype: 'label',
                text: ' ',
                cls: 'mandatoryfield',
                id: 'mandatorynote2'
				}, {
					xtype: 'label',
					text: ' ',
					cls: 'labelstyle',
					id: 'note1'
				},{
					   xtype: 'label',
					   text: '',
					   cls: 'mandatoryfield',
					   id: 'note2'
               },{
					   xtype: 'label',
					   text: '',
					   cls: 'mandatoryfield',
					   id: 'note3'
               },{
					   xtype: 'label',
					   text: '',
					   cls: 'mandatoryfield',
					   id: 'note4'
               },{
                xtype: 'label',
                text: '*',
                cls: 'mandatoryfield',
                id: 'mandatoryreasonId'  
                
            },{
                xtype: 'label',
                text: 'Reason'+'  :',
                cls: 'labelstyle',
                id: 'reLabelId'
            },reasonCombo1,{
                xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                id: 'mandatorres'
            },{
                xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                id: 'mandatoryreason1'
            },{
                xtype: 'label',
                text: ' ',
                cls: 'mandatoryfield',
                id: 'mandatoryreason2'
				}, {
					xtype: 'label',
					text: ' ',
					cls: 'labelstyle',
					id: 'reason1'
				},{
					   xtype: 'label',
					   text: '',
					   cls: 'mandatoryfield',
					   id: 'reason2'
               },{
					   xtype: 'label',
					   text: '',
					   cls: 'mandatoryfield',
					   id: 'reason3'
               },{
					   xtype: 'label',
					   text: '',
					   cls: 'mandatoryfield',
					   id: 'reason4'
               }]
	});
	

//-------------------------------Quantity Panel-------------------------------//
var innerThirdfirstPanel = new Ext.Panel({
   				standardSubmit: true,
    			collapsible: false,
    			id: 'innerThirdMaster',
    			layout: 'table',
    			frame: false,
    			height:40,
				width :210,
    			layoutConfig: {
        		columns: 2
    			},
    			items: [{
                   xtype: 'label',
                   text: '*',
                   cls: 'mandatoryfield',
                   id: 'mandatoryQTYId'
               },{
                   xtype: 'label',
                   text: 'Train Capacity' + '',
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
    			height:80,
				width :210,
    			layoutConfig: {
        		columns: 3
    			},
    			items: [{width:15},{
                   xtype: 'numberfield',
                   width:50,
                   height:60,
                   cls: 'quantityBox',
                   emptyText: '',
                   allowBlank: false,
				   readOnly : true,
                   blankText: '',
                   id: 'quantityId'
               },{
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
    			height:40,
				width :210,
    			layoutConfig: {
        		columns: 2
    			},
    			items: [{width:44}]
	      });
	      





var detailsThirdPanel = new Ext.Panel({
   				standardSubmit: true,
    			collapsible: false,
    			id: 'detailsThirdMaster',
    			layout: 'table',
    			frame: true,
    			height:385,
				width :210,
    			layoutConfig: {
        		columns: 1
    			},
    			items: [innerThirdfirstPanel,innerThirdSecondPanel,innerThird3Panel]
	});
	

	//****************************** Window For Adding Trip Information****************************
	var interval;
   var winButtonPanel = new Ext.Panel({
    id: 'winbuttonid',
    standardSubmit: true,
    collapsible: false,
    height:60,
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
        iconCls : 'savebutton',
        width: 80,
        listeners: {
            click: {
                fn: function () {
					 if (Ext.getCmp('typecomboId').getValue() == "") {
				    Ext.example.msg("<%=selectType%>");
				    Ext.getCmp('typecomboId').focus();
				    return;
				    }
					if(Ext.getCmp('typecomboId').getValue()=='RFID'){
					if (Ext.getCmp('RFIDId').getValue() == "") {
				    Ext.example.msg("<%=selectVehicleNO%>");
				    Ext.getCmp('RFIDId').focus();
				    return;
				    }
					}else{
					if (Ext.getCmp('vehiclecomboId').getValue() == "") {
				    Ext.example.msg("<%=selectVehicleNO%>");
				    Ext.getCmp('vehiclecomboId').focus();
				    return;
				    }
					}	
					
					if (Ext.getCmp('quantityId').getValue() == "") {
				    Ext.example.msg("Please enter Train Capacity");
				    Ext.getCmp('quantityId').focus();
				    return;
				    }
				    
				   
					if (Ext.getCmp('startDateTime').getValue() == "") {
				    Ext.example.msg("<%=enterValidDateTime%>");
				    Ext.getCmp('startDateTime').focus();
				    return;
				    }
					
				    if( parseFloat(Ext.getCmp('quantityId').getValue()) < parseFloat(Ext.getCmp('tarequantityId').getValue()) ){
				    Ext.example.msg("Train capacity should be greater than quantity");
				    Ext.getCmp('quantityId').focus();
				    return;
				    }
				 
				    
				    
				    var VehicleNoBaseType="";
				     var globalClientId=Ext.getCmp('custcomboId').getValue();
                     var customerName=Ext.getCmp('custcomboId').getRawValue();
				    if(Ext.getCmp('typecomboId').getValue()=="RFID"){
				       VehicleNoBaseType=Ext.getCmp('RFIDId').getValue();
				    }
				    if(Ext.getCmp('typecomboId').getValue()=="APPLICATION"){
				       VehicleNoBaseType=Ext.getCmp('vehiclecomboId').getValue();
				    }
				    

			//-------------------------------------------------------------------------------------//	    
				    if (buttonValue == 'modify') {
				    	var leaseModify;
				    	var gradeModify;
				    	var routeModify;
                        var selected = grid.getSelectionModel().getSelected();
                        uniqueId = selected.get('uniqueIDIndex');
					    
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
					   if(back=='1'){
						 cusId=custId;
						}else{
						 cusId=Ext.getCmp('custcomboId').getValue();
					   }
                    myWin.getEl().mask();
                    //Performs Save Operation
                     //Ajax request starts her
                        Ext.Ajax.request({
                            url: '<%=request.getContextPath()%>/TripSheetGenerationActionForBarge.do?param=saveormodifyGenrateTripSheetForBarge',
                            method: 'POST',
                            params: {
                            buttonValue:buttonValue,
                            CustID: cusId,
                            type:Ext.getCmp('typecomboId').getValue(),
                            vehicleNo:VehicleNoBaseType,
                            bargeCapacity : Ext.getCmp('quantityId').getValue(),
                            bargeQuantity : 0,
                            validityDateTime:Ext.getCmp('startDateTime').getValue(),
 							userSettingId : userSettingId,
 							vesselName: Ext.getCmp('vesselNameId').getValue(),
							destination: Ext.getCmp('destinationNameId').getValue(),
							boatNote: Ext.getCmp('boatNoteId').getValue(),
							reason:	Ext.getCmp('reasonComboId1').getValue(),
							uniqueId: uniqueId,
							tripSheetType:'TRAIN',
							orgId: Ext.getCmp('orgId').getValue()
                            },
                            success: function (response, options) {
								var message = response.responseText;
								Ext.example.msg(message);
								
                        		Ext.getCmp('typecomboId').setValue('APPLICATION');
								Ext.getCmp('vehiclecomboId').reset();
								Ext.getCmp('RFIDId').reset();
								Ext.getCmp('quantityId').reset();
								Ext.getCmp('startDateTime').reset();
								Ext.getCmp('vesselNameId').reset();
								Ext.getCmp('destinationNameId').reset();
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
				                        endDate : Ext.getCmp('enddate').getValue(),
				                        startDate: Ext.getCmp('startdate').getValue()
				                 }
				               });
				               vehicleComboStore.load({
				                    params: {
				                    CustId: Ext.getCmp('custcomboId').getValue()
				                     }
				             	});
				                tripStore.load({
								    params:{
								    CustID :cusId,
								    },
								    callback : function() {
								     for (var i = 0; i < tripStore.getCount(); i++) {
								     	 var rec = tripStore.getAt(i);
							            //tcId = rec.data['tcId'];
	                                    //lesseName = rec.data['lesseName'];
	                                    srcHubId = rec.data['sHubId'];
	                                    desHubId = rec.data['dHubId'];
	                                    tripType = rec.data['type'];
	                                    userSettingId = rec.data['userSettingId'];
	                                    bargeLocId=rec.data['bargeLocId'];
	                                    //orgName = rec.data['orgName'];
	                                   // orgCode = rec.data['orgCode'];
							            }
								    }
	    
	    					});
	    		
                            },
                            failure: function () {
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
        iconCls : 'cancelbutton',
        width: '80',
        listeners: {
            click: {
                fn: function () {
                clearInterval(interval);
                Ext.getCmp('typecomboId').setValue('APPLICATION');
         		$('#vehiclecomboId').val('');
				Ext.getCmp('RFIDId').reset();
                Ext.getCmp('vehicleRFIDPanelId').hide(); 
				Ext.getCmp('mandatoryVehicleId').hide();
				Ext.getCmp('VehicleNoID').hide();
				Ext.getCmp('vehiclecomboId').hide();
				Ext.getCmp('mandatoryRfid').hide();
				Ext.getCmp('RFIDIDs').hide();
				Ext.getCmp('RFIDId').hide();
				Ext.getCmp('RFIDButtId').hide();
				Ext.getCmp('vesselNameId').reset();
				Ext.getCmp('destinationNameId').reset();
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
       height:385,
       frame: true,
       id: 'addCaseInfo',
       layout: 'table',
       layoutConfig: {
           columns: 1
       },
    			items: [detailsFirstPanel,vehicleRFIDPanel,detailsSecondPanel]
	});
	

	
	var firstForthPanel = new Ext.Panel({
   				standardSubmit: true,
    			collapsible: false,
    			id: 'firstForthpanelId',
    			layout: 'table',
    			frame: false,
    			height:40,
				width :210,
    			layoutConfig: {
        		columns: 2
    			},
    			items: [{
                   xtype: 'label',
                   text: '*',
                   cls: 'mandatoryfield',
                   id: 'mandatoryTareQtyId'
               },{
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
    			height:80,
				width :210,
    			layoutConfig: {
        		columns: 3
    			},
    			items: [{width:15},{
                   xtype: 'numberfield',
                   width:50,
                   height:60,
                   cls: 'quantityBox',
                   emptyText: '',
                   allowBlank: false,
				   readOnly: true,
                   blankText: '',
                   id: 'tarequantityId'
               },{
                   xtype: 'label',
                   text: 'tons',
                   cls: 'labelstyle',
                   id: 'tarekgsId'
               }]
	});
	
	var detailsForthPanel= new Ext.Panel({
		standardSubmit: true,
		collapsible: false,
		id: 'detailsForthPanel',
		layout: 'table',
		frame: true,
		height:385,
	    width :210,
		layoutConfig: {
   		columns: 1
		},
		items: [firstForthPanel,secondForthPanel]
	});
	
	var firstFifthPanel = new Ext.Panel({
   				standardSubmit: true,
    			collapsible: false,
    			id: 'firstFifthPanelId',
    			layout: 'table',
    			frame: false,
    			height:40,
				width :230,
    			layoutConfig: {
        		columns: 2
    			},
    			items: [{
                   xtype: 'label',
                   text: ' ',
                   cls: 'mandatoryfield',
                   id: 'mandatoryActualQtyId'
               },{
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
    			height:80,
    			readonly : true,
				width :210,
    			layoutConfig: {
        		columns: 3
    			},
    			items: [{width:15},{
                   xtype: 'textfield',
                   width:50,
                   height:60,
                   cls: 'quantityBox',
                   emptyText: '',
                   allowBlank: false,
				   readOnly: true,
                   blankText: '',
                   id: 'actualquantityId'
               },{
                   xtype: 'label',
                   text: 'tons',
                   cls: 'labelstyle',
                   id: 'actualkgsId'
               }]
	});
	
	var detailsFifthPanel= new Ext.Panel({
		standardSubmit: true,
		collapsible: false,
		id: 'detailsFifthPanel',
		layout: 'table',
		frame: true,
		height:354,
	    width :240,
		layoutConfig: {
   		columns: 1
		},
		items: [firstFifthPanel,secondFifthPanel]
	});
//----------------------------------------Inside two panel-------------------------------------------------//	
var caseTwoInnerPanel = new Ext.Panel({
       standardSubmit: true,
       collapsible: false,
       autoScroll: true,
       width: 900,
       height:400,
       frame: true,
       id: 'InneraddCaseInfo',
       layout: 'table',
       layoutConfig: {
           columns: 4
       },
    			items: [caseInnerPanel,detailsThirdPanel,detailsForthPanel]
	});
	


//****************************** Window For Adding Trip Information Ends Here************************
 		var outerPanelWindow = new Ext.Panel({
   		standardSubmit: true,
   		id:'winpanelId',
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
    //autoScroll: true,
    frame: false,
    id: 'canceltrip',
    
    items: [{
        xtype: 'fieldset',
       // cls:'fieldsetpanel',
       width:480,
       //height:400,
        title: 'Cancel Trip',
        id:'closeTripfieldset',
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
            },{
                xtype: 'label',
                text: '*',
                cls: 'mandatoryfield',
                id: 'mandatorycloseTripLabelId'
            },{
                xtype: 'label',
                text: 'Boat Note'+'  :',
                cls: 'labelstyle',
                id: 'remarkLabelId'
            },{width:10},{
                xtype: 'textarea',
                cls:'selectstylePerfect',  
                id: 'remark',
                emptyText: 'Enter Remarks',
                blankText: 'Enter Remarks',
            },{
                xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                id: 'mandatorycloseTripLabela'
            },{
                xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                id: 'mandatorycloseTripLabels'
            },{
                xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                id: 'mandatorycloseTripLabel3'
            },{
                xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                id: 'mandatorycloseTripLabel4'
            },{
                xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                id: 'mandatorycloseTripLabel5'
            },{
                xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                id: 'mandatorycloseTripLabel6'
            },{
                xtype: 'label',
                text: '*',
                cls: 'mandatoryfield',
                id: 'mandatorycloseTripLabelId7'
            },{
                xtype: 'label',
                text: 'Reason'+'  :',
                cls: 'labelstyle',
                id: 'remarkLabelId2'
            },{width:10},reasonCombo
            ]
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
    height:8,
    cls: 'windowbuttonpanel',
    frame: true,
    layout:'table',
	layoutConfig: {
			columns:4
		},
		  buttons: [{
 	        xtype: 'button',
 	         text: 'Cancel Trip',
       		 id: 'cancelTripId1',
        	 cls: 'buttonstyle',
             iconCls : 'savebutton',
             width: 80,
             listeners: {
            click: {
                fn: function () {
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
                                uniqueNo: selected.get('uniqueIDIndex'),
                               
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
				                        endDate : Ext.getCmp('enddate').getValue(),
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
           iconCls : 'cancelbutton',
           width: '80',
           listeners: {
            click: {
                fn: function () {
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
   		id:'cancelwinpanelId1',
    	frame: true,
        height: 250,
        width: 520,  
    	items: [cancelTripPanel,winButtonPanelForCancelTrip]
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
var cusId;
if(back=='1'){
	 cusId=custId;
	 }else{
	 cusId=Ext.getCmp('custcomboId').getValue();
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
			d.setDate(d.getDate()+1);
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
                Ext.getCmp('vehicleRFIDPanelId').show();
                Ext.getCmp('detailsFirstMaster').setHeight(40);
                Ext.getCmp('vehicleRFIDPanelId').setHeight(50);
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

		
    	
		Ext.getCmp('RFIDId').setValue('');
	//	Ext.getCmp('tcNamecomboId').disable();
		Ext.getCmp('quantityId').setValue('');
		Ext.getCmp('tarequantityId').setValue('');
		Ext.getCmp('actualquantityId').setValue('');
		Ext.getCmp('startDateTime').setValue(d);
 	//	Ext.getCmp('routecomboId').disable();
		if(tripType=='Close' || tripType==undefined){
		Ext.example.msg("Please do the user setting");
		return;
		}
		if(bargeLocId==0 || bargeLocId==undefined){
			Ext.example.msg("Please do the user setting");
			return;
		}
	   // Ext.getCmp('innerfifthMaster').show();
	   

	     myWin.show();
	   
	}
	
   //*********************** Function to Modify Data ***********************************
    function modifyData() {
    //alert('modify data');
     if(back=='1'){
	 cusId=custId;
	 }else{
	 cusId=Ext.getCmp('custcomboId').getValue();
	 }
    if (Ext.getCmp('custcomboId').getValue() == "") {
    	Ext.example.msg("<%=pleaseSelectcustomer%>");
    	Ext.getCmp('custcomboId').focus();
        return;
    }
    if(grid.getSelectionModel().getCount()>1){
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
    if(status=='CLOSE'){
       Ext.example.msg("Trip sheet already closed");
        return;
    }
   
    if(status=='BLO In-Transit'){
       Ext.example.msg("Stop Loading Train to modify");
        return;
    }
    if(status=='Closed-Completed Trip'){
       Ext.example.msg("Trip sheet already closed");
        return;
    }
    if(status=='Closed-Cancelled Trip'){
       Ext.example.msg("Trip sheet already cancelled");
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
                          Ext.getCmp('RFIDId').setValue(selected.get('assetNoIndex'));
                          Ext.getCmp('vehicleRFIDPanelId').show();
                          Ext.getCmp('detailsFirstMaster').setHeight(40);
                          Ext.getCmp('vehicleRFIDPanelId').setHeight(50);
                          Ext.getCmp('mandatoryVehicleId').hide();
                          Ext.getCmp('VehicleNoID').hide();
                          Ext.getCmp('vehiclecomboId').hide();

                          Ext.getCmp('mandatoryRfid').show();
                          Ext.getCmp('RFIDIDs').show();
                          Ext.getCmp('RFIDId').show();
                          Ext.getCmp('RFIDButtId').show();
                      }
                      if (type == "APPLICATION") {
                          Ext.getCmp('vehiclecomboId').setValue(selected.get('assetNoIndex'));
                          Ext.getCmp('vehicleRFIDPanelId').show();
                          Ext.getCmp('detailsFirstMaster').setHeight(40);
                          Ext.getCmp('vehicleRFIDPanelId').setHeight(50);
                          Ext.getCmp('mandatoryRfid').hide();
                          Ext.getCmp('RFIDIDs').hide();
                          Ext.getCmp('RFIDId').hide();
                          Ext.getCmp('RFIDButtId').hide();

                          Ext.getCmp('mandatoryVehicleId').show();
                          Ext.getCmp('VehicleNoID').show();
                          Ext.getCmp('vehiclecomboId').show();
                      }
                      Ext.getCmp('startDateTime').setValue(selected.get('validityDateDataIndex'));
                      Ext.getCmp('vesselNameId').setValue(selected.get('vesselNameIndex'));
                      Ext.getCmp('destinationNameId').setValue(selected.get('destinationIndex'));
                      Ext.getCmp('boatNoteId').setValue(selected.get('boatNote'));
                      Ext.getCmp('reasonComboId1').setValue(selected.get('reason'));
                      
                      Ext.getCmp('tripsheetNumberLabelId').show();
					  Ext.getCmp('mandatorytripsheetNumberId').show();
					  Ext.getCmp('enrollNumberId').show();
					  
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
				    	
    	
                       Ext.getCmp('enrollNumberId').disable();
                       Ext.getCmp('enrollNumberId').setValue(selected.get('TripSheetNumberIndex'));
                       Ext.getCmp('typecomboId').setValue(selected.get('TypeIndex'));
                       Ext.getCmp('typecomboId').setDisabled(true);
                       Ext.getCmp('RFIDId').disable;
                       Ext.getCmp('RFIDButtId').setDisabled(true);
                       Ext.getCmp('vehiclecomboId').setDisabled(true);
                       Ext.getCmp('quantityId').setValue(capacity);
                       Ext.getCmp('tarequantityId').setValue(tareWeigh);
                   //    Ext.getCmp('innerfifthMaster').show();
					myWin.show();

    }
    
     function verifyFunction() {
     if (Ext.getCmp('custcomboId').getValue() == "") {
    	Ext.example.msg("<%=pleaseSelectcustomer%>");
    	Ext.getCmp('custcomboId').focus();
        return;
    }
    if(grid.getSelectionModel().getCount()>1){
        Ext.example.msg("<%=SelectSingleRow%>");
        return;
    }
 
    if (grid.getSelectionModel().getSelected() == null) {
        Ext.example.msg("<%=noRecordsFound%>");
        Ext.getCmp('custcomboId').focus();
        return;
    }
    
           var cusId;
		   if(back=='1'){
			 cusId=custId;
			}else{
			 cusId=Ext.getCmp('custcomboId').getValue();
		   }
           var CustID=cusId;
           var selected = grid.getSelectionModel().getSelected();
	       var tripNo=selected.get('TripSheetNumberIndex');
	       var bargeNo = selected.get('assetNoIndex');
	       var bargeCapacity=selected.get('QuantityIndex');
	       var bargeQuantity1= selected.get('q1IndexId');
	       var bargeId = selected.get('uniqueIDIndex');
	       var status = selected.get('statusIndexId');
	       var endDate = Ext.getCmp('enddate').getValue();
		   var startDate= Ext.getCmp('startdate').getValue();
		   var orgId = selected.get('orgIdIndex');
		   var bargeLocation = selected.get('bargeLocIndex');
	//	   alert(endDate);
		   var custName=Ext.getCmp('custcomboId').getRawValue()
           var tripSheetForTruck='/Telematics4uApp/Jsps/IronMining/TripSheetGenerationForTrain.jsp?custId='+CustID+'&tripNo='+tripNo+'&bargeNo='+bargeNo+'&bargeCapacity='+bargeCapacity+'&bargeQuantity='+bargeQuantity1+'&bargeId='+bargeId+'&status='+status+'&startDate='+startDate+'&endDate='+endDate+'&custName='+custName+'&orgId='+orgId+'&bargeLocation='+bargeLocation;
			parent.Ext.getCmp('partOneTab').enable();
			parent.Ext.getCmp('generalBargeTab').disable();
			parent.Ext.getCmp('partOneTab').show();
			parent.Ext.getCmp('partOneTab').update("<iframe style='width:100%;height:525px;border:0;' src='"+tripSheetForTruck+"'></iframe>");
	//		loadMask.hide();
			
	
        }
        
     function deleteData(){
     if(back=='1'){
	 cusId=custId;
	 }else{
	 cusId=Ext.getCmp('custcomboId').getValue();
	 }
    if (Ext.getCmp('custcomboId').getValue() == "") {
    	Ext.example.msg("<%=pleaseSelectcustomer%>");
    	Ext.getCmp('custcomboId').focus();
        return;
    }
    if(grid.getSelectionModel().getCount()>1){
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
    if(status=='Closed-Completed Trip'){
       Ext.example.msg("Trip sheet already closed");
        return;
    }
    if(status=='Closed-Cancelled Trip'){
       Ext.example.msg("Trip sheet already cancelled");
        return;
    }
    if(status=='BLO In-Transit'){
       Ext.example.msg("Stop Loading Train to cancel");
        return;
    }
    
    
    var titelForcloseTrip = 'Cancel Trip';
    canceltripWin.setTitle(titelForcloseTrip);
    canceltripWin.show();
    
}   
        

   function closeImportWin() {
   var cusId;
    if(back=='1'){
	 cusId=custId;
	 }else{
	 cusId=Ext.getCmp('custcomboId').getValue();
	 }
     var selected = grid.getSelectionModel().getSelected();
     
     if (Ext.getCmp('custcomboId').getValue() == "") {
             Ext.example.msg("<%=pleaseSelectcustomer%>");
             Ext.getCmp('custcomboId').focus();
        	 return;
    	}
    	
    if(grid.getSelectionModel().getCount()>1){
        Ext.example.msg("<%=SelectSingleRow%>");
        return;
    }
 
    if (grid.getSelectionModel().getSelected() == null) {
        Ext.example.msg("No Records Found");
        Ext.getCmp('custcomboId').focus();
        return;
    }
     if(selected.get('statusIndexId')=='Closed-Completed Trip'){
	 Ext.example.msg("Trip sheet already closed");
	 return;
	 } 
	 if(selected.get('statusIndexId')=='Closed-Cancelled Trip'){
	 Ext.example.msg("Trip sheet already Cancelled");
	 return;
	 } 

     if(selected.get('statusIndexId')=='BLO In-Transit'){
	 Ext.example.msg("Stop Loading Trip to Close");
	 return;
	 }
	 
     buttonValue = "close trip";
	if(tripType=='Open' || tripType==undefined )
	 {
	 	Ext.example.msg("Please do the user setting");
		return;
	 }
	
     	 Ext.MessageBox.show({
         title:'',
          msg: 'Are you sure you want to close trip?',
          buttons: Ext.MessageBox.YESNO,
          icon: Ext.MessageBox.QUESTION,
          fn: function(btn) {
                 if(btn=='yes')
                 {
                 	
     				tripSheetNo=selected.get('TripSheetNumberIndex')
     				assetNo=selected.get('assetNoIndex');
     				 Ext.Ajax.request({
 	                        url: '<%=request.getContextPath()%>/TripSheetGenerationActionForBarge.do?param=closeTrip',
 	                        method: 'POST',
 	                        params: {
 	                            tripSheetNo : tripSheetNo,
 	                            assetNo : assetNo,
 	                            CustID: cusId
 	                        },
 	                        success: function (response, options) {
 	                            var message = response.responseText;
 	                            Ext.example.msg(message);
 	                         store.load({
				                   params: {
				                        CustID: cusId,
				                        jspName: jspName,
				                        CustName: Ext.getCmp('custcomboId').getRawValue(),
				                        endDate : Ext.getCmp('enddate').getValue(),
				                        startDate: Ext.getCmp('startdate').getValue()
				                 }
				               });
 	                        },
 	                        failure: function () {
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
    	
    if(grid.getSelectionModel().getCount()>1){
        Ext.example.msg("<%=SelectSingleRow%>");
        return;
    }
 
    if (grid.getSelectionModel().getSelected() == null) {
        Ext.example.msg("No Records Found");
        Ext.getCmp('custcomboId').focus();
        return;
    }
    
	 if(selected.get('statusIndexId')=='In-Transit'){
	 Ext.example.msg("Train Loading has been already stopped");
	 return;
	 }
	 if(selected.get('statusIndexId')=='In-transit Modified'){
     	  Ext.example.msg("Train Loading is Stopped");
         return;             
        }
        
	 if(selected.get('statusIndexId')=='OPEN'){
	  Ext.example.msg("Train has not been loaded");
	 return;
	 }
	  if(selected.get('statusIndexId')=='Closed-Completed Trip'){
	  Ext.example.msg("Trip sheet already closed");
	 return;
	 }
	  var selected = grid.getSelectionModel().getSelected();
	 var bargeId = selected.get('uniqueIDIndex');
	 var cusId;
	 if(back=='1'){
	 cusId=custId;
	 }else{
	 cusId=Ext.getCmp('custcomboId').getValue();
	 }
     	 Ext.MessageBox.show({
         title:'',
          msg: 'Are you sure you want to stop?',
          buttons: Ext.MessageBox.YESNO,
          icon: Ext.MessageBox.QUESTION,
          fn: function(btn) {
                 if(btn=='yes')
                 {
                 	
     				tripSheetNo=selected.get('TripSheetNumberIndex')
     				assetNo=selected.get('assetNoIndex');
     				 Ext.Ajax.request({
 	                        url: '<%=request.getContextPath()%>/TripSheetGenerationActionForBarge.do?param=stopblo',
 	                        method: 'POST',
 	                        params: {
 	                            tripSheetNo : tripSheetNo,
 	                            assetNo : assetNo,
 	                            CustID: cusId
 	                        },
 	                        success: function (response, options) {
 	                            var message = response.responseText;
 	                            Ext.example.msg(message);
 	                         store.load({
				                   params: {
				                        CustID: cusId,
				                        jspName: jspName,
				                        CustName: Ext.getCmp('custcomboId').getRawValue(),
				                        endDate : Ext.getCmp('enddate').getValue(),
				                        startDate: Ext.getCmp('startdate').getValue()
				                 }
				               });
				               window.open("<%=request.getContextPath()%>/tripSheetPdfForBarge?uniqueId="+bargeId);
 	                        },
 	                        failure: function () {
 	                            Ext.example.msg("Error");
 	                            
 	                        }
 	                    });
     				
                 }
               }   
		});
		
        }
        
        function postponeFunction(){
         //alert('modify data');
     if(back=='1'){
	 cusId=custId;
	 }else{
	 cusId=Ext.getCmp('custcomboId').getValue();
	 }
    if (Ext.getCmp('custcomboId').getValue() == "") {
    	Ext.example.msg("<%=pleaseSelectcustomer%>");
    	Ext.getCmp('custcomboId').focus();
        return;
    }
    if(grid.getSelectionModel().getCount()>1){
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
<!--    if(status=='Closed-Completed Trip'){-->
<!--       Ext.example.msg("Trip sheet already closed");-->
<!--        return;-->
<!--    }-->
    if(status=='OPEN'){
       Ext.example.msg("Please Load the Train");
        return;
    }
    if(status=='BLO In-Transit'){
       Ext.example.msg("Stop Loading Train to view PDF");
        return;
    }
	if(!(parseFloat(selected.get('q1IndexId'))>0)){
	  Ext.example.msg("Load the Train to view PDF");
	 return;
	 }
    	window.open("<%=request.getContextPath()%>/tripSheetPdfForBarge?uniqueId="+bargeId);
        }
   

        Ext.onReady(function () {
	    Ext.QuickTips.init();
	    Ext.form.Field.prototype.msgTarget = 'side';
	    outerPanel = new Ext.Panel({
        renderTo: 'content',
        standardSubmit: true,
        frame: true,
        height:500,
        width:screen.width-40,
        items: [customerPanel,grid]
    });
     
    if(back=='1'){

		var prevfromdate = '<%=startDatePrev%>';
		var dt = new Date(prevfromdate);
		var mnth = ("0" + (dt.getMonth()+1)).slice(-2);
		var day  = ("0" + dt.getDate()).slice(-2);
		var prevfromdates= [day,mnth,dt.getFullYear() ].join("-");
		
		var prevtodate = '<%=endDatePrev%>';
		var dts = new Date(prevtodate);
		var mnths = ("0" + (dts.getMonth()+1)).slice(-2);
		var days  = ("0" + dts.getDate()).slice(-2);
		var prevtodates= [days,mnths,dts.getFullYear() ].join("-");
		
        Ext.getCmp('custcomboId').setValue(custName); 
		Ext.getCmp('enddate').setValue(prevtodates);
		Ext.getCmp('startdate').setValue(prevfromdates);
		
    store.load({
                  params: {
                       CustID: custId,
                       jspName: jspName,
                       CustName: Ext.getCmp('custcomboId').getRawValue(),
                       endDate : ed,
                       startDate: sd
                }
		 });
		 tripStore.load({
								    params:{
								    CustID :custId,
								    },
								    callback : function() {
								     for (var i = 0; i < tripStore.getCount(); i++) {
								     	 var rec = tripStore.getAt(i);
							            //tcId = rec.data['tcId'];
	                                    //lesseName = rec.data['lesseName'];
	                                    srcHubId = rec.data['sHubId'];
	                                    desHubId = rec.data['dHubId'];
	                                    tripType = rec.data['type'];
	                                    userSettingId = rec.data['userSettingId'];
	                                    bargeLocId=rec.data['bargeLocId'];
	                                    //orgName = rec.data['orgName'];
	                                    //orgCode = rec.data['orgCode'];
							            }
								    }
	    
	    					});
		
    }  
});				
   </script>
  </body>
</html>
<%}%>

