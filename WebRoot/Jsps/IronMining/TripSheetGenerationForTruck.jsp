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
		tobeConverted.add(" Route");
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
		
		String clientId = "";
		String bargeNo = "";
		String bargeCapacity="";
		String tripNo="";
		String custName="";
if(request.getParameter("custId") != null && !request.getParameter("custId").equals("")){
	clientId = request.getParameter("custId"); 
	session.setAttribute("clientId",clientId);
}
if(request.getParameter("tripNo") != null && !request.getParameter("tripNo").equals("")){
	tripNo = request.getParameter("tripNo"); 
}
if(request.getParameter("bargeNo") != null && !request.getParameter("bargeNo").equals("")){
	bargeNo = request.getParameter("bargeNo"); 
	session.setAttribute("bargeNo",bargeNo);
}
if(request.getParameter("bargeCapacity") != null && !request.getParameter("bargeCapacity").equals("")){
	bargeCapacity = request.getParameter("bargeCapacity"); 
	session.setAttribute("bargeCapacity",bargeCapacity);
}

String bargeId = "";
if(request.getParameter("bargeId") != null && !request.getParameter("bargeId").equals("")){
	bargeId = request.getParameter("bargeId"); 
}

String bargeStatus = "";
if(request.getParameter("status") != null && !request.getParameter("status").equals("")){
	bargeStatus = request.getParameter("status"); 
}

String startDate = "";
if(request.getParameter("startDate") != null && !request.getParameter("startDate").equals("")){
	startDate = request.getParameter("startDate"); 
}

String endDate = "";
if(request.getParameter("endDate") != null && !request.getParameter("endDate").equals("")){
	endDate = request.getParameter("endDate"); 
}

if(request.getParameter("custName") != null && !request.getParameter("custName").equals("")){
	custName = request.getParameter("custName"); 
	System.out.println(custName);
}

int orgId = 0;
if(request.getParameter("orgId") != null && !request.getParameter("orgId").equals("")){
	orgId = Integer.parseInt(request.getParameter("orgId")); 
	session.setAttribute("orgId",orgId);
}
int bargeLocation = 0;
if(request.getParameter("bargeLocation") != null && !request.getParameter("bargeLocation").equals("")){
	bargeLocation = Integer.parseInt(request.getParameter("bargeLocation")); 
	session.setAttribute("bargeLocation",bargeLocation);
}
String cancel;
if(loginInfo.getIsLtsp()== 0)
{
	cancel="true";
}else{
	cancel="false";
}
%>

<!DOCTYPE HTML>
<html>
 <head>
 		<title>Trip Generation Report</title>		
</head>	    
	 <style>
	 .x-form-field-wrap{
 height: 35px;
}

<%if (loginInfo.getStyleSheetOverride().equals("Y")){%>
.x-form-file-wrap .x-form-file {
height:35px;
}
#filePath{
height:30px;
}
<%}%>
.x-panel-tl {
    border-bottom: 0px solid !important;
}
.x-form-file-wrap .x-form-file {
	position: absolute;
	right: 0;
	-moz-opacity: 0;
	filter:alpha(opacity: 0);
	opacity: 0;
	z-index: 2;
    height: 22px;
    cursor: pointer;
}
.x-form-file-wrap .x-form-file-btn {
	position: absolute;
	right: 0;
	z-index: 1;
}
.x-form-file-wrap .x-form-file-text {
    position: absolute;
    left: 0;
    z-index: 3;
    color: #777;
}
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
    font-size: 23px;
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

.my-label-style4 {
    font-weight: bold; 
    font-size: 15px !important;
    text-align: center;
    margin-left: -4px;
}

.tripimportimagepanel {
	width: 100%;
	height: 200px;
	background-image:
		url(/ApplicationImages/ExcelImportFormats/TripsheetImportImage.png)
		!important;
	background-repeat: no-repeat;
}
.quantityBox1
	{
	background-color: white ;
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
        var jspName = 'MiningTripSheetGenerationForTruck';
        var exportDataType = "int,string,string,string,string,string,string,string,string,string,string,number,number,number,number,string,string,string";
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
        var loadMask = new Ext.LoadMask(Ext.getBody(), { msg: "Saving" });
   	    var clientId = '<%=clientId%>';
   	    var tripNo = '<%=tripNo%>';
   	    var bargeCapacity = '<%=bargeCapacity%>';
   	    var bargeId = '<%=bargeId%>';
        var bargeNo = '<%=bargeNo%>';
        var bargeQuantity;
        var bargeStatus= '<%=bargeStatus%>';
        var endDate = '<%=endDate%>';
        var startDate = '<%=startDate%>';
        var custName = '<%=custName%>';
        var orgId='<%=orgId%>';
        var bargeLocation='<%=bargeLocation%>';
        var permitNo;
        var grade;
        var rsSource;
		var rsDestination;
		var transactionNo;
		var bargeLocId;
		
        var BargeQuantityStore = new Ext.data.JsonStore({
            url: '<%=request.getContextPath()%>/TripSheetGenerationForTruckAction.do?param=getBargeQuantity',
            id: 'bargeQtyId',
            root: 'bargeRoot',
            autoload: false,
            remoteSort: true,
            fields: ['bargeQuantity'],
            listeners: {
                load: function() {}
            }
        });
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
            anyMatch: true,
            typeAhead: false,
            triggerAction: 'all',
            lazyRender: true,
            valueField: 'Value',
            displayField: 'Name',
            value: Typecombostore.getAt(1).data['Value'],
            cls: 'selectstylePerfect',
            blankText: '<%=selectType%>',
            emptyText: '<%=selectType%>',
            listeners: {
                select: {
                    fn: function() {
                        vehicleComboStore.load({
                            params: {
                                CustId: clientId
                            }
                        });
                        var typeValue = Ext.getCmp('typecomboId').getValue();
                        if (typeValue == 'RFID') {
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
                        if (typeValue == 'APPLICATION') {
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



        var TypecombostoreTare = new Ext.data.SimpleStore({
            id: 'TypecombostoreIdFare',
            autoLoad: true,
            fields: ['Name', 'Value'],
            data: [
                ['RFID', 'RFID'],
                ['APPLICATION', 'APPLICATION']
            ]
        });


        var typecomboforTare = new Ext.form.ComboBox({
            store: TypecombostoreTare,
            id: 'typecomboIdTare',
            mode: 'local',
            forceSelection: true,
            emptyText: '<%=selectType%>',
            blankText: '<%=selectType%>',
            selectOnFocus: true,
            allowBlank: false,
            anyMatch: true,
            typeAhead: false,
            triggerAction: 'all',
            lazyRender: true,
            valueField: 'Value',
            displayField: 'Name',
            cls: 'selectstylePerfect',
            listeners: {
                select: {
                    fn: function() {
                        var typeValue = Ext.getCmp('typecomboIdTare').getValue();
                        if (typeValue == 'RFID') {
                            Ext.getCmp('RFIDId').reset();
                            Ext.getCmp('vehicleRFIDPanelIdTare').show();
                            Ext.getCmp('detailsFirstMasterTare').setHeight(40);
                            Ext.getCmp('vehicleRFIDPanelIdTare').setHeight(50);
                            Ext.getCmp('mandatoryVehicleIdT').hide();
                            Ext.getCmp('VehicleNoIDT').hide();
                            Ext.getCmp('vehiclecomboIdTare').hide();

                            Ext.getCmp('mandatoryRfidT').show();
                            Ext.getCmp('RFIDIDsT').show();
                            Ext.getCmp('RFIDIdT').show();
                            Ext.getCmp('RFIDButtIdT').show();
                        }
                        if (typeValue == 'APPLICATION') {
                            Ext.getCmp('vehiclecomboIdTare').reset();
                            Ext.getCmp('vehicleRFIDPanelIdTare').show();
                            Ext.getCmp('detailsFirstMasterTare').setHeight(40);
                            Ext.getCmp('vehicleRFIDPanelIdTare').setHeight(50);
                            Ext.getCmp('mandatoryRfidT').hide();
                            Ext.getCmp('RFIDIDsT').hide();
                            Ext.getCmp('RFIDIdT').hide();
                            Ext.getCmp('RFIDButtIdT').hide();

                            Ext.getCmp('mandatoryVehicleIdT').show();
                            Ext.getCmp('VehicleNoIDT').show();
                            Ext.getCmp('vehiclecomboIdTare').show();
                        }

                    }
                }
            }
        });

        //************************ Store for Permit No Here***************************************//
        var permitNoComboStore = new Ext.data.JsonStore({
            url: '<%=request.getContextPath()%>/TripSheetGenerationForTruckAction.do?param=getPermitNo',
            id: 'permitStoreId',
            root: 'permitRoot',
            autoload: false,
            remoteSort: true,
            fields: ['routeId','routeName','quantity','permitNo','pId','tripSheetQty','grade','tcId','orgCode','leaseName','orgName','motherVessel'],
            listeners: {
                load: function() {}
            }
        });

        var permitCombo = new Ext.form.ComboBox({
            store: permitNoComboStore,
            id: 'permitcomboId',
            mode: 'local',
            forceSelection: true,
            emptyText: 'Select Permit No',
            blankText: 'Select Permit No',
            selectOnFocus: true,
            allowBlank: true,
            listWidth: 150,
            anyMatch: true,
            typeAhead: false,
            triggerAction: 'all',
            lazyRender: true,
            valueField: 'pId',
            displayField: 'permitNo',
            cls: 'selectstylePerfect',
            listeners: {
                select: {
                    fn: function() {
                        var id = Ext.getCmp('permitcomboId').getValue();
                        var row = permitNoComboStore.findExact('pId', id);
                        var rec = permitNoComboStore.getAt(row);
                        routeName = rec.data['routeName'];
						routeId = rec.data['routeId'];
						quantity = rec.data['quantity'];
						permitNo = rec.data['permitNo'];
						pId = rec.data['pId'];
						balance = rec.data['tripSheetQty'];
						tcId=rec.data['tcId'];
                        orgName=rec.data['orgName'];
                        lesseName=rec.data['leaseName'];
                        orgCode=rec.data['orgCode'];
						grade = rec.data['grade'];
						Ext.getCmp('routecomboId').setValue(routeName);
			            Ext.getCmp('quantityId2').setValue(quantity);
			            Ext.getCmp('quantityId2b').setValue(balance);
			            Ext.getCmp('gradeAndMineralscomboId').setValue(grade);
			            if (tcId == '' || tcId == 0) {
                           Ext.getCmp('orgcomboId').setValue(orgName);
                           Ext.getCmp('tcNamecomboId').hide();
                           Ext.getCmp('TcleaseNameID').hide();
                           Ext.getCmp('mandatoryTcleaseName').hide();
                           
                           //Ext.getCmp('tcNamecomboId').show();
                           Ext.getCmp('orgcomboId').show();
                           Ext.getCmp('OrgNameNameID').show();
                           Ext.getCmp('mandatoryTcleaseName12').show();
                       } else {
                           Ext.getCmp('tcNamecomboId').setValue(lesseName);
                           Ext.getCmp('orgcomboId').hide();
                           Ext.getCmp('OrgNameNameID').hide();
                           Ext.getCmp('mandatoryTcleaseName12').hide();
                           
                            //Ext.getCmp('orgcomboId').show();
                           Ext.getCmp('tcNamecomboId').show();
                           Ext.getCmp('TcleaseNameID').show();
                           Ext.getCmp('mandatoryTcleaseName').show();
                       }
			            permitNo= rec.data['permitNo'];
			            var motherVessel= rec.data['motherVessel'];
			            if(motherVessel.length>0){
			            Ext.getCmp('MotherVesselTextId').setValue(motherVessel);
			            	motherVesselLabelPanel.show();
			            }else{
			            	Ext.getCmp('MotherVesselTextId').reset();
			            	motherVesselLabelPanel.hide();
			            }
                    }
                }
            }
        });

        //************************ Store for Vehicel Number  Here***************************************//
        var vehicleComboStore = new Ext.data.JsonStore({
            url: '<%=request.getContextPath()%>/TripSheetGenerationForTruckAction.do?param=getVehicleList',
            id: 'vehicleComboStoreId',
            root: 'vehicleComboStoreRoot',
            autoload: false,
            remoteSort: true,
            fields: ['vehicleNoID', 'vehicleName', 'quantity1','pucExpStatus','incExpStatus']
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
            emptyText: '<%=selectVehicleNO%>',
            blankText: '<%=selectVehicleNO%>',
            listeners: {
                select: {
                    fn: function() {
                        var vehicleNo = Ext.getCmp('vehiclecomboId').getValue();
                        var row = vehicleComboStore.findExact('vehicleNoID', vehicleNo);
                        var rec = vehicleComboStore.getAt(row);
                        quantity1 = rec.data['quantity1'];
                        incExpStatus = rec.data['incExpStatus'];
                        pucExpStatus= rec.data['pucExpStatus'];
                        Ext.getCmp('tarequantityId').setValue(quantity1);

                        if (Ext.get('quantityId').getValue() != "") {
                            RFIDquantity = Ext.getCmp('quantityId').getValue();
                            var actualQuantity = parseFloat(RFIDquantity) - parseFloat(Ext.get('tarequantityId').getValue());
                            Ext.getCmp('actualquantityId').setValue(actualQuantity);
                         
                        } else {
                            Ext.getCmp('actualquantityId').setValue(0);
                        }
                        if(incExpStatus=='False'){
                           Ext.MessageBox.show({
						  	msg: 'Insurance expired.Please renew for trip sheet allocation',
						  	buttons: Ext.MessageBox.OK
						   });
                           Ext.getCmp('vehiclecomboId').reset();
                           return;
                        }
                        if(pucExpStatus=='False'){
                          Ext.MessageBox.show({
						  	msg: 'PUC expired.Please renew for trip sheet allocation.',
						  	buttons: Ext.MessageBox.OK
						   });
                          Ext.getCmp('vehiclecomboId').reset();
                          return;
                        }
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

                        } 
                } 
            } 
        });

       var tripStore = new Ext.data.JsonStore({
            url: '<%=request.getContextPath()%>/TripSheetGenerationAction.do?param=getTripDetails',
            id: 'tripStoreId',
            root: 'tripRoot',
            autoload: false,
            fields: ['sHubId', 'dHubId', 'type','userSettingId','bargeLocId'],
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
            url: '<%=request.getContextPath()%>/TripSheetGenerationAction.do?param=getRFID',
            id: 'tripStoreIdForRfidAdd',
            root: 'tripRoot',
            autoload: false,
            fields: ['quantity1', 'jsonString'],
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
         //************************ Store for time***************************************//
         var timeStore = new Ext.data.JsonStore({
             url: '<%=request.getContextPath()%>/TripSheetGenerationAction.do?param=getServerTime',
             id: 'timeId',
             root: 'timeRoot',
             autoload: false,
             remoteSort: true,
             fields: ['time','day','id','startTime','endTime','breakSTime','breakETime','nonCommHrs'],
             listeners: {
                 load: function() {}
             }
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
            }, {
                name: 'TripSheetNumberIndex'
            }, {
                name: 'assetNoIndex'
            }, {
                name: 'tcLeaseNoIndex'
            }, {
                name: 'validityDateDataIndex',
                type: 'date',
                dateFormat: getDateTimeFormat()
            }, {
                name: 'gradeAndMineralIndex'
            }, {
                name: 'RouteIndex'
            }, {
                name: 'uniqueIDIndex'
            }, {
                name: 'tcLeaseNoIndexId'
            }, {
                name: 'orgNameIndex'
            }, {
                name: 'gradeAndMineralIndexId'
            }, {
                name: 'RouteIndexId'
            }, {
                name: 'statusIndexId'
            }, {
                name: 'q1IndexId'
            }, {
                name: 'QuantityIndex'
            }, {
                name: 'netIndexId'
            }, {
                name: 'actualQtyIndexId'
            }, {
                name: 'permitIndexId'
            }, {
                name: 'issuedIndexId'
            },{
            	name: 'shipNameIndexId'
            },{
            	name: 'commStatusIndexId'
            },{
            	name: 'permitTypeIndex'
            }]
        });

        // **********************************************Reader configs Ends******************************
        //********************************************Store Configs For Grid*************************

        var store = new Ext.data.GroupingStore({
            autoLoad: false,
            proxy: new Ext.data.HttpProxy({
                url: '<%=request.getContextPath()%>/TripSheetGenerationForTruckAction.do?param=getMiningTripSheetDetails',
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
                dataIndex: 'TripSheetNumberIndex'
            }, {
                type: 'string',
                dataIndex: 'assetNoIndex'
            }, {
                type: 'string',
                dataIndex: 'tcLeaseNoIndex'
            }, {
                type: 'string',
                dataIndex: 'orgNameIndex'
            }, {
                type: 'date',
                dataIndex: 'validityDateDataIndex'
            }, {
                type: 'string',
                dataIndex: 'gradeAndMineralIndex'
            }, {
                type: 'string',
                dataIndex: 'RouteIndex'
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
                type: 'float',
                dataIndex: 'netIndexId'
            },  {
                type: 'float',
                dataIndex: 'actualQtyIndexId'
            }, {
                type: 'string',
                dataIndex: 'permitIndexId'
            }, {
                type: 'string',
                dataIndex: 'issuedIndexId'
            }, {
                type: 'string',
                dataIndex: 'shipNameIndexId'
            }, {
                type: 'string',
                dataIndex: 'commStatusIndexId'
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
                    header: "<span style=font-weight:bold;><%=TripSheetNumber%></span>",
                    dataIndex: 'TripSheetNumberIndex',
                    filter: {
                        type: 'string'
                    }
                }, {
                    header: "<span style=font-weight:bold;><%=assetNumber%></span>",
                    dataIndex: 'assetNoIndex',
                    filter: {
                        type: 'string'
                    }
                }, {
                    header: "<span style=font-weight:bold;><%=TCLeaseName%></span>",
                    dataIndex: 'tcLeaseNoIndex',
                    filter: {
                        type: 'string'
                    }
                }, {
                    header: "<span style=font-weight:bold;>Organization Name</span>",
                    dataIndex: 'orgNameIndex',
                    filter: {
                        type: 'string'
                    }
                }, {
                    header: "<span style=font-weight:bold;>Issued Date</span>",
                    dataIndex: 'issuedIndexId',
                    filter: {
                        type: 'string'
                    }

                }, {
                    header: "<span style=font-weight:bold;><%=ValidityDateTime%></span>",
                    dataIndex: 'validityDateDataIndex',
                    renderer: Ext.util.Format.dateRenderer(getDateTimeFormat()),
                    filter: {
                        type: 'date'
                    }
                }, {
                    header: "<span style=font-weight:bold;><%=GradeandMineralInformation%></span>",
                    dataIndex: 'gradeAndMineralIndex',
                    filter: {
                        type: 'string'
                    }
                }, {
                    header: "<span style=font-weight:bold;>Route</span>",
                    dataIndex: 'RouteIndex',
                    filter: {
                        type: 'string'
                    }
                }, {
                    header: "<span style=font-weight:bold;>Status</span>",
                    dataIndex: 'statusIndexId',
                    hidden: false,
                    filter: {
                        type: 'string'
                        
                    }
                }, {
                    header: "<span style=font-weight:bold;>Tare Weight1</span>",
                    dataIndex: 'q1IndexId',
                    align: 'right',
                    sortable: true,
                    filter: {
                        type: 'int'
                    }
                }, {
                    header: "<span style=font-weight:bold;>Gross Weight1</span>",
                    dataIndex: 'QuantityIndex',
                    align: 'right',
                    sortable: true,
                    filter: {
                        type: 'int'
                    }
                }, {
                    header: "<span style=font-weight:bold;>Net Weight</span>",
                    dataIndex: 'netIndexId',
                    align: 'right',
                    sortable: true,
                    filter: {
                        type: 'float'
                    }
                },  {
                    header: "<span style=font-weight:bold;>Actual Quantity</span>",
                    dataIndex: 'actualQtyIndexId',
                    align: 'right',
                    hidden: true,
                    filter: {
                        type: 'float'
                    }
                }, {
                    header: "<span style=font-weight:bold;>Permit No</span>",
                    dataIndex: 'permitIndexId',
                    hidden: false,
                    filter: {
                        type: 'string'
                    }
                },{
                    header: "<span style=font-weight:bold;>Vessel Name</span>",
                    dataIndex: 'shipNameIndexId',
                    hidden: false,
                    filter: {
                        type: 'string'
                    }
                },{
                    header: "<span style=font-weight:bold;>Communicating Status</span>",
                    dataIndex: 'commStatusIndexId',
                    hidden: false,
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
        //*********************************************Column model config Ends*************************** 	
        //******************************************Creating Grid By Passing Parameter***********************

        grid = getGrid('<%=MiningTripSheetGeneration%>', '<%=noRecordsFound%>', store, screen.width - 55, 420, 20, filters, 'Clear Filter Data', false, '', 20, false, '', false, '', true, 'Excel', jspName, exportDataType, false, 'PDF', true, 'Add', false, 'Modify', <%=cancel%>, 'Cancel', false, '', false, 'Destination Weight', false, 'Close Trip',false,'',false,'',true,'Import Excel');

        //**********************************End Of Creating Grid By Passing Parameter*************************

        var detailsFirstPanel = new Ext.Panel({
            standardSubmit: true,
            collapsible: false,
            id: 'detailsFirstMaster',
            layout: 'table',
            frame: false,
            border: false,
            height: 30,
            width: 433,
            layoutConfig: {
                columns: 5
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
            }, {
                width: 82
            }, typecombo, {
                xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                id: 'mandatoryTypeid'
            }]
        });

       
        //----------------------------------------------------------------//	
        var vehicleRFIDPanel = new Ext.Panel({
            id: 'vehicleRFIDPanelId',
            standardSubmit: true,
            hidden: true,
            layout: 'table',
            frame: false,
            //height:80,
            width: 437,
            layoutConfig: {
                columns: 6
            },
            items: [{
                xtype: 'label',
                text: '*',
                cls: 'mandatoryfield',
                id: 'mandatoryVehicleId'
            }, {
                xtype: 'label',
                text: '<%=VehicleNo%>' + ' :',
                cls: 'labelstyle',
                id: 'VehicleNoID'
            }, {
                width: 48
            }, vehicleCombo, {
                width: 20
            }, {
                xtype: 'label',
                text: '',
                hidden:true,
                cls: 'mandatoryfield',
                id: 'mandatoryVehicleNoId'
            }, {
                xtype: 'label',
                text: '*',
                cls: 'mandatoryfield',
                id: 'mandatoryRfid'
            }, {
                xtype: 'label',
                text: '<%=VehicleNo%>:',
                cls: 'labelstyle',
                id: 'RFIDIDs'
            }, {
                width: 52
            }, {
                xtype: 'textfield',
                cls: 'selectstylePerfect',
                emptyText: '<%=EnterVehicleNo%>',
                allowBlank: false,
                readOnly: true,
                blankText: '<%=EnterVehicleNo%>',
                id: 'RFIDId'
            }, {
                width: 20
            }, {
                xtype: 'button',
                text: '<%=ReadRFID%>',
                width: 80,
                id: 'RFIDButtId',
                cls: 'buttonstyle',
                listeners: {
                    click: {
                        fn: function() {
                                var RFIDValue;
                                $.ajax({
                                    type: "GET",
                                    url: '<%=RFIDwebServicePath%>',
                                    success: function(data) {
                                       if(data.includes('RSSOURCE') || data.includes('RSDESTINATION') || data.includes('TRANSACTION_NO')){  
                                          split1=data.split('RSSOURCE');
                                          split2=split1[1].split('RSDESTINATION');
                                          split3=split2[1].split('TRANSACTION_NO');
                                       
	                                      RFIDValue1 = split1[0].split('==');
	                                      RFIDValue=RFIDValue1[1];
	                                      rsSource=split2[0].replace('==','');
	                                      rsDestination=split3[0].replace('==','');
	                                      transactionNo=split3[1].replace('==','');
                                       }else{
                                          RFIDValue=data;
                                          rsSource="NA";
                                          rsDestination="NA";
                                          transactionNo="NA";
                                       }
                                      tripStoreForRfidAdd.load({
                                            params: {
                                                CustID: clientId,
                                                RFIDValue: RFIDValue
                                            },
                                            callback: function() {
                                                for (var i = 0; i < tripStoreForRfidAdd.getCount(); i++) {
                                                    var rec = tripStoreForRfidAdd.getAt(i);
                                                    var vehicleName = rec.data['jsonString'];
                                                    quantity1 = rec.data['quantity1'];

                                                }
                                                if (tripStoreForRfidAdd.getCount() == 0) {
                                                    Ext.example.msg("<%=SomethingWronginRFID%>");
                                                    Ext.getCmp('RFIDIdT').setValue("<%=EnterVehicleNo%>");
                                                } else {
                                                    Ext.getCmp('RFIDId').setValue(vehicleName);
                                                    Ext.getCmp('tarequantityId').setValue(quantity1);
                                                    if (RFIDquantity != "") {
                                                        var actualQuantity = parseFloat(RFIDquantity) - parseFloat(Ext.get('tarequantityId').getValue());
                                                        Ext.getCmp('actualquantityId').setValue(actualQuantity);
                                          
                       								       
                                                    } else {
                                                        Ext.getCmp('actualquantityId').setValue(0);
                                                    }
                                                }
                                            }

                                        });
                                    },
                                    error: function() {
                                        Ext.example.msg("Some thing went Wrong");
                                    }
                                });
                                //alert('hello='+RFIDValue);
                                //Ajax request starts here
                                <!--		                        Ext.Ajax.request({-->
                                <!--		                            url: '<%=request.getContextPath()%>/TripSheetGenerationAction.do?param=getRFID',-->
                                <!--		                            method: 'POST',-->
                                <!--		                            params: {-->
                                <!--		                            RFIDValue:RFIDValue,-->
                                <!--		                            CustID: Ext.getCmp('custcomboId').getValue()-->
                                <!--		                            },-->
                                <!--		                            success: function (response, options) {-->
                                <!--										var message = response.responseText;-->
                                <!--										//alert(message);-->
                                <!--										var vehicleNos = message.replace(/[\:'",.\{\}\[\]\\\/]/gi,'');-->
                                <!--										if(vehicleNos=="vno"){-->
                                <!--										Ext.example.msg("<%=SomethingWronginRFID%>");-->
                                <!--										Ext.getCmp('RFIDId').setValue("<%=EnterVehicleNo%>");-->
                                <!--										}else{-->
                                <!--										var vehicleNoss = vehicleNos.substring(3);-->
                                <!--										//alert(vehicleNoss);-->
                                <!--										Ext.getCmp('RFIDId').setValue(vehicleNoss);-->
                                <!--										}-->
                                <!--		                            },-->
                                <!--		                            failure: function () {-->
                                <!--										Ext.example.msg("Some thing goes Wrong");-->
                                <!--		                            }-->
                                <!--		                        });-->
                            } //fun
                    } //click
                } //listeners
            }]
        });

       

        var detailsSecondPanel = new Ext.Panel({
            standardSubmit: true,
            collapsible: false,
            id: 'detailsSecondMaster',
            layout: 'table',
            frame: false,
            height: 210,
            width: 437,
            layoutConfig: {
                columns: 5
            },
            items: [{
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
                hidden:true,
                id: 'mandatoryTripsheetNumber'
            }, {
                xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                hidden:true,
                id: 'mandatoryTripsheetNumber1'
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
                text: '',
                cls: 'mandatoryfield',
                id: 'mandatoryvalidityDateId1'
            }, {
                xtype: 'label',
                text: '*',
                cls: 'mandatoryfield',
                id: 'mandatoryRouteId2p'
            }, {
                xtype: 'label',
                text: 'Permit No' + ' :',
                cls: 'labelstyle',
                id: 'permitId'
            },permitCombo, {
                xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                id: 'mandatoryperId'
            }, {
                xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                id: 'mandatoryperId1'
            }, {
                xtype: 'label',
                text: '*',
                cls: 'mandatoryfield',
                id: 'mandatoryTcleaseName'
            }, {
                xtype: 'label',
                text: '<%=TCLeaseName%>' + ' :',
                cls: 'labelstyle',
                id: 'TcleaseNameID'
            }, {
                xtype: 'textfield',
                width: 139,
                cls: 'selectstylePerfect',
                emptyText: '',
                allowBlank: false,
                readOnly: true,
                blankText: '',
                id: 'tcNamecomboId'
            }, {
                xtype: 'label',
                text: '',
                hidden:true,
                cls: 'mandatoryfield',
                id: 'mandatoryTcleaseNameId'
            }, {
                xtype: 'label',
                text: '',
                hidden:true,
                cls: 'mandatoryfield',
                id: 'mandatoryTripsheetNumber155d1'
            }, {
                xtype: 'label',
                text: '*',
                cls: 'mandatoryfield',
                id: 'mandatoryTcleaseName12'
            }, {
                xtype: 'label',
                text: 'Organisation Name' + ' :',
                cls: 'labelstyle',
                id: 'OrgNameNameID'
            }, {
                xtype: 'textfield',
                width: 139,
                cls: 'selectstylePerfect',
                emptyText: '',
                allowBlank: false,
                readOnly: true,
                blankText: '',
                id: 'orgcomboId'
            }, {
                xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                id: 'mandatoryTcleaseNameId13'
            }, {
                xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                id: 'mandatoryTcleaseNameId1'
            }, {
                xtype: 'label',
                text: '*',
                cls: 'mandatoryfield',
                id: 'mandatoryRouteId2'
            }, {
                xtype: 'label',
                text: '<%=route%>' + ' :',
                cls: 'labelstyle',
                id: 'RouteID'
            }, {
                xtype: 'textarea',
                width: 150,
                height:40,
                resizable: true,
                cls: 'selectstylePerfect',
                emptyText: '',
                allowBlank: false,
                readOnly: true,
                blankText: '',
                id: 'routecomboId'
            }, {
                xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                id: 'mandatoryRouteId'
            }, {
                xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                id: 'mandatoryGradeInforId1s'
            }, {
                xtype: 'label',
                text: '*',
                cls: 'mandatoryfield',
                id: 'mandatoryGradeId'
            }, {
                xtype: 'label',
                text: '<%=GradeAndMineral%>' + ' :',
                cls: 'labelstyle',
                id: 'gradeAndMineralsID'
            }, {
                xtype: 'textfield',
                width: 139,
                cls: 'selectstylePerfect',
                emptyText: '',
                allowBlank: false,
                readOnly: true,
                blankText: '',
                id: 'gradeAndMineralscomboId'
            }, {
                xtype: 'label',
                text: '',
                hidden:true,
                cls: 'mandatoryfield',
                id: 'mandatoryGradeInforId'
            }, {
                xtype: 'label',
                text: '',
                hidden:true,
                cls: 'mandatoryfield',
                id: 'mandatoryGradeInforId1'
            }]
        });
		var motherVesselLabelPanel = new Ext.Panel({
            standardSubmit: true,
            collapsible: false,
            id: 'motherVesselLabelPanelId',
            hidden: 'true',
            layout: 'table',
            frame: false,
            height: 40,
            width: 437,
            layoutConfig: {
                columns: 4
            },
            items: [{
                xtype: 'label',
                text: '*',
                cls: 'mandatoryfield',
                id: 'mandatoryMVesselId'
            }, {
                xtype: 'label',
                text: 'Vessel Name :',
                cls: 'labelstyle',
                id: 'motherVesselId'
            },{width:35}, {
                xtype: 'textarea',
                width: 150,
                height:40,
                resizable: true,
                cls: 'selectstylePerfect',
                allowBlank: false,
                readOnly: true,
                id: 'MotherVesselTextId'
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
                text: 'Gross Weight' + '',
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
                xtype: 'textfield',
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
                text: '<%=kgs%>',
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
            }, {
                xtype: 'button',
                iconCls : 'capturebutton',
                text: '<%=Capture%>',
                scale: 'large',
                name: 'filepath',
                id: 'captureWeightId',
                width: 80,
                cls: 'buttonstyle',
                listeners: {
                    click: {
                        fn: function() {
                                var buttonValue = '<%=CaptureQuantity%>';
                                $.ajax({
                                    type: "GET",
                                    url: '<%=WEIGHTwebServicePath%>',
                                    success: function(data) {
                                        Ext.getCmp('quantityId').setValue(data);
                                    },
                                    error: function() {
                                        Ext.example.msg("Some thing went Wrong");
                                    }
                                });
                                //Ajax request starts here
                                <!--		                        Ext.Ajax.request({-->
                                <!--		                            url: '<%=request.getContextPath()%>/TripSheetGenerationAction.do?param=getCaptureQuantity',-->
                                <!--								    method: 'POST',-->
                                <!--		                            params: {-->
                                <!--		                            buttonValue:buttonValue,-->
                                <!--		                            CustID: Ext.getCmp('custcomboId').getValue()-->
                                <!--		                            },-->
                                <!--		                            success: function (response, options) {-->
                                <!--										var message = response.responseText;-->
                                <!--										var weights = message.replace(/[\:'",.\{\}\[\]\\\/]/gi,'');-->
                                <!--										//alert(weights);-->
                                <!--										if(weights=="Weight"){-->
                                <!--										Ext.example.msg("<%=SomethingWronginweight%>");-->
                                <!--										Ext.getCmp('quantityId').setValue("");-->
                                <!--										}else{-->
                                <!--										var weightss=weights.substring(6);-->
                                <!--										//alert(weightss);-->
                                <!--										Ext.getCmp('quantityId').setValue(weightss);-->
                                <!--										}-->
                                <!--		                            },-->
                                <!--		                            failure: function () {-->
                                <!--										Ext.example.msg("Error");-->
                                <!--		                            }-->
                                <!--		                        });-->
                                //}); 
                            } //fun
                    } //click
                } //listeners
            }]
        });



        var innerThirdFifthPanel = new Ext.Panel({
            standardSubmit: true,
            collapsible: false,
            id: 'innerfifthMaster',
            layout: 'table',
            frame: false,
            height: 40,
            width: 210,
            layoutConfig: {
                columns: 3
            },
            items: [{
                xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                id: 'mandatoryQTYId1'
            }, {
                xtype: 'label',
                text: 'Permit Quantity' + '',
                cls: 'my-label-style3',
                id: 'QuantityID2'
            }, {
                width: 5
            }]
        });


        var innerThirdFifthPanel1 = new Ext.Panel({
            standardSubmit: true,
            collapsible: false,
            id: 'innerfifthMaster1',
            layout: 'table',
            frame: false,
            height: 40,
            width: 210,
            layoutConfig: {
                columns: 3
            },
            items: [{
                width: 24
            }, {
                xtype: 'textfield',
                width: 139,
                cls: 'quantityBox1',
                emptyText: '',
                allowBlank: false,
                readOnly: true,
                blankText: '',
                id: 'quantityId2'
            }, {
                xtype: 'label',
                text: 'tons',
                cls: 'labelstyle',
                id: 'perQtyTonsId'
            }]
        });

        var innerThirdSixthPanel = new Ext.Panel({
            standardSubmit: true,
            collapsible: false,
            id: 'innerThirdSixthPanelMaser',
            layout: 'table',
            frame: false,
            height: 40,
            width: 210,
            layoutConfig: {
                columns: 3
            },
            items: [{
                xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                id: 'mandatoryQTYIdp'
            }, {
                xtype: 'label',
                text: 'Permit Balance' + '',
                cls: 'my-label-style2',
                id: 'QuantityID2b'
            }, {
                width: 5
            }]
        });

        var innerThirdSixthPanel1 = new Ext.Panel({
            standardSubmit: true,
            collapsible: false,
            id: 'innerThirdSixthPanelMaser1',
            layout: 'table',
            frame: false,
            height: 40,
            width: 210,
            layoutConfig: {
                columns: 3
            },
            items: [{
                width: 24
            }, {
                xtype: 'textfield',
                width: 139,
                cls: 'quantityBox1',
                emptyText: '',
                allowBlank: false,
                readOnly: true,
                blankText: '',
                id: 'quantityId2b'
            }, {
                xtype: 'label',
                text: 'tons',
                cls: 'labelstyle',
                id: 'balTonsId'
            }]
        });


        

        var detailsThirdPanel = new Ext.Panel({
            standardSubmit: true,
            collapsible: false,
            id: 'detailsThirdMaster',
            layout: 'table',
            frame: true,
            height: 375,
            width: 210,
            layoutConfig: {
                columns: 1
            },
            items: [innerThirdfirstPanel, innerThirdSecondPanel, innerThird3Panel, innerThirdFifthPanel, innerThirdFifthPanel1, innerThirdSixthPanel, innerThirdSixthPanel1]
        });

    
        //****************************** Window For Adding Trip Information****************************
        var interval;
        var winButtonPanel = new Ext.Panel({
            id: 'winbuttonid',
            standardSubmit: true,
            collapsible: false,
            height: 50,
            cls: 'windowbuttonpanel',
            frame: true,
            layout: 'table',
            layoutConfig: {
                columns: 3
            },
            items: [{
                width: 501
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
                        var row = timeStore.findExact('id', 1);
	                    var rec = timeStore.getAt(row);
	                    var nonCommHrs=rec.data['nonCommHrs'];
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
                            if (Ext.getCmp('quantityId').getValue() == "") {
                                Ext.example.msg("<%=enterQuantity%>");
                                Ext.getCmp('quantityId').focus();
                                return;
                            }
                            if (Ext.getCmp('startDateTime').getValue() == "") {
                                Ext.example.msg("<%=enterValidDateTime%>");
                                Ext.getCmp('startDateTime').focus();
                                return;
                            }
                            if (Ext.getCmp('gradeAndMineralscomboId').getValue() == "") {
                                Ext.example.msg("<%=enterGradeMinerals%>");
                                Ext.getCmp('gradeAndMineralscomboId').focus();
                                return;
                            }
                            if (Ext.getCmp('routecomboId').getValue() == "") {
                                Ext.example.msg("<%=enterRoute%>");
                                Ext.getCmp('routecomboId').focus();
                                return;
                            }
                            var pid=Ext.getCmp('permitcomboId').getValue();
                            var row = permitNoComboStore.findExact('pId', pid);
                            if(row==-1){ 
                               Ext.example.msg("Please Select permit No");
                               Ext.getCmp('permitcomboId').reset();
                               Ext.getCmp('permitcomboId').focus();
                               return;
                            }
                            if (orgCode != orgId) {
                                Ext.example.msg("Please select Same organization Permit");
                                return;
                            }
                            if(Ext.getCmp('permitcomboId').getRawValue().indexOf('IE')==0){
                            	var row1 = store.findExact('permitTypeIndex', 'International Export');
	                            if (row1!=null&& row1!=-1 &&store.getAt(row1)!=null) {
	                            	var rec = store.getAt(0);
	                        		if (rec.data['shipNameIndexId'] != Ext.getCmp('MotherVesselTextId').getValue()) {
		 								Ext.example.msg("Permit can not be load as Vessel is different");
		                                return;
	                                }
	                            }
                            }
                            var VehicleNoBaseType = "";
                            if (Ext.getCmp('typecomboId').getValue() == "RFID") {
                                VehicleNoBaseType = Ext.getCmp('RFIDId').getValue();
                            }
                            if (Ext.getCmp('typecomboId').getValue() == "APPLICATION") {
                                VehicleNoBaseType = Ext.getCmp('vehiclecomboId').getValue();
                            }

                            if ((parseFloat(Ext.getCmp('tarequantityId').getValue())) > (parseFloat(Ext.getCmp('quantityId').getValue()))) {
                                Ext.example.msg("Gross Weight should be greater than Tare Weight");
                                return;
                            }
                            if (Ext.getCmp('typecomboId').getValue() == "APPLICATION") {
                                rsSource = "NA",
							    rsDestination = "NA",
							    transactionNo = "NA";
                            }
                            //-------------------------------------------------------------------------------------//	    
                            if (buttonValue == 'modify') {
                                var leaseModify;
                                var gradeModify;
                                var routeModify;
                                var selected = grid.getSelectionModel().getSelected();
                                uniqueId = selected.get('uniqueIDIndex');

                                if (selected.get('tcLeaseNoIndex') != Ext.getCmp('tcNamecomboId').getValue()) {
                                    leaseModify = Ext.getCmp('tcNamecomboId').getValue();
                                } else {
                                    leaseModify = selected.get('tcLeaseNoIndexId');
                                }
                                if (selected.get('gradeAndMineralIndex') != Ext.getCmp('gradeAndMineralscomboId').getValue()) {
                                    gradeModify = Ext.getCmp('gradeAndMineralscomboId').getValue();
                                } else {
                                    gradeModify = selected.get('gradeAndMineralIndexId');
                                }
                                if (selected.get('RouteIndex') != Ext.getCmp('routecomboId').getValue()) {
                                    routeModify = Ext.getCmp('routecomboId').getValue();
                                } else {
                                    routeModify = selected.get('RouteIndexId');
                                }
                            }
                            if (Ext.getCmp('actualquantityId').getValue() == '') {
                                Ext.example.msg("Please enter actual quantity");
                                return;
                            }
                            if (buttonValue == 'add') {
                                var actQty = Ext.getCmp('actualquantityId').getValue();
                                var convertedQty = parseFloat(actQty) / 1000;
                                
                                var convertedBargeQuantity;
                            if(bargeQuantity!=0){
                            convertedBargeQuantity=parseFloat(bargeQuantity)/1000;
                            }else{
                            convertedBargeQuantity=0;
                            }
                            
                            var remaingBargeQty=parseFloat(convertedQty)+parseFloat(convertedBargeQuantity);
                            
                            var bargeQty=Ext.getCmp('bargeQuantity').getValue();
                       		var barCap=Ext.getCmp('bargeCapacityId').getValue();
                       		var netBargeCapacity=parseFloat(barCap)-parseFloat(bargeQty);
                       		
                                var netBargeQuantity= Ext.getCmp('bargeNetCapacityId').getValue();
                                if(parseFloat(convertedQty)>parseFloat(netBargeQuantity)){
                                 Ext.example.msg("Net Quantity is greater than the Barge available quantity");
                                  return;
                                }else{
                                Ext.getCmp('bargeNetCapacityId').setValue(netBargeCapacity.toFixed(3));
                                Ext.getCmp('bargeQuantity').setValue(remaingBargeQty.toFixed(3));
                                }
                                
                                
                                var balanceQty = parseFloat(Ext.getCmp('quantityId2b').getValue()) - convertedQty;
                                if (balanceQty < 0) {
                                    Ext.example.msg("Net Quantity is greater than the Permit Balance");
                                    return;
                                } else {
                                    Ext.getCmp('quantityId2b').setValue(balanceQty.toFixed(3));
                                }
                                
                               
                            
                            }
                            myWin.getEl().mask();
                            Ext.Ajax.request({
                                url: '<%=request.getContextPath()%>/TripSheetGenerationForTruckAction.do?param=saveormodifyGenrateTripSheet',
                                method: 'POST',
                                params: {
                                    buttonValue: buttonValue,
                                    CustID: clientId,
                                    type: Ext.getCmp('typecomboId').getValue(),
                                    vehicleNo: VehicleNoBaseType,
                                    tcLeaseName: tcId,
                                    quantity: Ext.getCmp('quantityId').getValue(),
                                    validityDateTime: Ext.getCmp('startDateTime').getValue(),
                                    gradetype: Ext.getCmp('gradeAndMineralscomboId').getValue(),
                                    routeId: routeId,
                                    uniqueId: uniqueId,
                                    leaseModify: leaseModify,
                                    gradeModify: gradeModify,
                                    routeModify: routeModify,
                                    srcHubId: srcHubId,
                                    quantity1: quantity1,
                                    desHubId: desHubId,
                                    permitNo: permitNo,
                                    pId: pId,
                                    orgCode: orgCode,
                                    actualQuantity: Ext.getCmp('actualquantityId').getValue(),
                                    userSettingId: userSettingId,
                                    tripNo: tripNo,
                                    bargeId : bargeId,
                                    bargeQuantity :bargeQuantity,
                                    bargeStatus : bargeStatus,
                                    rsSource : rsSource,
									rsDestination : rsDestination,
									transactionNo : transactionNo,
									bargeNo: bargeNo,
									bargeCapacity:bargeCapacity,
									nonCommHrs:nonCommHrs
                                },
                                success: function(response, options) {
                                    var message = response.responseText;
                                    Ext.example.msg(message);
                                    if(message=="0"){
                                       message="Error in Saving Trip Sheet Details";
                                       Ext.example.msg(message);
                                    }else if(message=="-1"){
                                        message="Permit Balance is over or trip exists for vehicle or Barge Qty is over or Permit is disassociated. Please check.";
                                        Ext.example.msg(message);
                                    }else if(message>0){
                                        message="Trip Sheet Details Saved Successfully";
                                        Ext.example.msg(message);
                                    }

                                    //Ext.getCmp('typecomboId').reset();
                                    Ext.getCmp('vehiclecomboId').reset();
                                    Ext.getCmp('RFIDId').reset();
                                    Ext.getCmp('tcNamecomboId').reset();
                                    Ext.getCmp('quantityId').reset();
                                    Ext.getCmp('startDateTime').reset();
                                    myWin.hide();
                                    myWin.getEl().unmask();
                                    store.load({
                                        params: {
                                        	jspName: jspName,
                                            CustID: clientId,
                                            bargeId: bargeId
                                        }
                                    });
                                    tripStore.load({
                                        params: {
                                            CustID: clientId,
                                        },
                                        callback: function() {
                                            for (var i = 0; i < tripStore.getCount(); i++) {
                                                var rec = tripStore.getAt(i);
                                                //tcId = rec.data['tcId'];
                                                //lesseName = rec.data['lesseName'];
                                                srcHubId = rec.data['sHubId'];
                                                desHubId = rec.data['dHubId'];
                                                tripType = rec.data['type'];
                                                userSettingId = rec.data['userSettingId'];
                                                bargeLocId=rec.data['bargeLocId'];
                                            }
                                        }
                                    });
	                                    permitNoComboStore.load({
	                            params: {
	                                CustID: clientId
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
            height: 375,
            frame: true,
            id: 'addCaseInfo',
            layout: 'table',
            layoutConfig: {
                columns: 1
            },
            items: [detailsFirstPanel, vehicleRFIDPanel, detailsSecondPanel, motherVesselLabelPanel]
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
                text: ' ',
                cls: 'mandatoryfield',
                id: 'mandatoryTareQtyId'
            }, {
                xtype: 'label',
                text: 'Tare Weight' + '',
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
                xtype: 'textfield',
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
                text: '<%=kgs%>',
                cls: 'labelstyle',
                id: 'tarekgsId'
            }]
        });
        
        var emptyPanel = new Ext.Panel({
            standardSubmit: true,
            collapsible: false,
            id: 'emptyPanel',
            layout: 'table',
            frame: false,
            height: 40,
            width: 210,
            layoutConfig: {
                columns: 3
            },
            items: [{
                width: 15
            }]
        });
        
         var bargeCapacityLabelPanel = new Ext.Panel({
            standardSubmit: true,
            collapsible: false,
            id: 'bargeCapacityLabelPanel',
            layout: 'table',
            frame: false,
            height: 40,
            width: 210,
            layoutConfig: {
                columns: 3
            },
            items: [{
                xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                id: 'mandatoryBargeCapacityLabel'
            }, {
                xtype: 'label',
                text: 'Barge Capacity' + '',
                cls: 'my-label-style3',
                id: 'bargeCapacityID2'
            }, {
                width: 5
            }]
        });


        var bargeCapacityPanel = new Ext.Panel({
            standardSubmit: true,
            collapsible: false,
            id: 'bargeCapacityPanel',
            layout: 'table',
            frame: false,
            height: 40,
            width: 210,
            layoutConfig: {
                columns: 3
            },
            items: [{
                width: 24
            }, {
                xtype: 'textfield',
                width: 139,
                cls: 'quantityBox1',
                emptyText: '',
                allowBlank: false,
                readOnly: true,
                blankText: '',
                id: 'bargeCapacityId'
            }, {
                xtype: 'label',
                text: 'tons',
                cls: 'labelstyle',
                id: 'bargeCapacityTonsId'
            }]
        });

        var bargeQuantityLabelPanel = new Ext.Panel({
            standardSubmit: true,
            collapsible: false,
            id: 'bargeQuantityLabelPanel',
            layout: 'table',
            frame: false,
            height: 40,
            width: 210,
            layoutConfig: {
                columns: 3
            },
            items: [{
                xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                id: 'mandatorybargequantityLabel'
            }, {
                xtype: 'label',
                text: 'Barge Quantity' + '',
                cls: 'my-label-style2',
                id: 'BargeQuantityLabel'
            }, {
                width: 5
            }]
        });

        var bargeQuantityPanel = new Ext.Panel({
            standardSubmit: true,
            collapsible: false,
            id: 'bargeQuantityPanel',
            layout: 'table',
            frame: false,
            height: 40,
            width: 210,
            layoutConfig: {
                columns: 3
            },
            items: [{
                width: 24
            }, {
                xtype: 'textfield',
                width: 139,
                cls: 'quantityBox1',
                emptyText: '',
                allowBlank: false,
                readOnly: true,
                blankText: '',
                id: 'bargeQuantity',
                allowDecimals: false
            }, {
                xtype: 'label',
                text: 'tons',
                cls: 'labelstyle',
                id: 'barQtyTons'
            }]
        });

        var detailsForthPanel = new Ext.Panel({
            standardSubmit: true,
            collapsible: false,
            id: 'detailsForthPanel',
            layout: 'table',
            frame: true,
            height: 375,
            width: 210,
            layoutConfig: {
                columns: 1
            },
            items: [firstForthPanel, secondForthPanel,emptyPanel,bargeCapacityLabelPanel,bargeCapacityPanel,bargeQuantityLabelPanel,bargeQuantityPanel]
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
                text: '<%=kgs%>',
                cls: 'labelstyle',
                id: 'actualkgsId'
            }]
        });
        
         var emptyPanel2 = new Ext.Panel({
            standardSubmit: true,
            collapsible: false,
            id: 'emptyPanel2',
            layout: 'table',
            frame: false,
            height: 40,
            width: 210,
            layoutConfig: {
                columns: 3
            },
            items: [{
                width: 15
            }]
        });
        
         var bargeNetLabelPanel = new Ext.Panel({
            standardSubmit: true,
            collapsible: false,
            id: 'bargeNetLabelPanel',
            layout: 'table',
            frame: false,
            height: 40,
            width: 210,
            layoutConfig: {
                columns: 3
            },
            items: [{
                xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                id: 'mandatoryBargeNetLabel'
            }, {
                xtype: 'label',
                text: 'Available Barge Quantity' + '',
                cls: 'my-label-style4',
                id: 'bargeNetID2'
            }, {
                width: 5
            }]
        });


        var bargeNetPanel = new Ext.Panel({
            standardSubmit: true,
            collapsible: false,
            id: 'bargeNetPanel',
            layout: 'table',
            frame: false,
            height: 40,
            width: 210,
            layoutConfig: {
                columns: 3
            },
            items: [{
                width: 24
            }, {
                xtype: 'textfield',
                width: 139,
                cls: 'quantityBox1',
                emptyText: '',
                allowBlank: false,
                readOnly: true,
                blankText: '',
                id: 'bargeNetCapacityId'
            }, {
                xtype: 'label',
                text: 'tons',
                cls: 'labelstyle',
                id: 'bargeNetTonsId'
            }]
        });
        
          var bargeNameLabelPanel = new Ext.Panel({
            standardSubmit: true,
            collapsible: false,
            id: 'bargeNameLabelPanel',
            layout: 'table',
            frame: false,
            height: 40,
            width: 210,
            layoutConfig: {
                columns: 3
            },
            items: [{
                xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                id: 'mandatoryBargeNameLabel'
            }, {
                xtype: 'label',
                text: 'Barge Name' + '',
                cls: 'my-label-style3',
                id: 'bargeNameID2'
            }, {
                width: 5
            }]
        });


        var bargeNamePanel = new Ext.Panel({
            standardSubmit: true,
            collapsible: false,
            id: 'bargeNamePanel',
            layout: 'table',
            frame: false,
            height: 40,
            width: 210,
            layoutConfig: {
                columns: 3
            },
            items: [{
                width: 24
            }, {
                xtype: 'textfield',
                width: 139,
                cls: 'quantityBox1',
                emptyText: '',
                allowBlank: false,
                readOnly: true,
                blankText: '',
                id: 'bargeNameId'
            }, {
                xtype: 'label',
                text: '',
                cls: 'labelstyle',
                id: 'bargenamet'
            }]
        });

        var detailsFifthPanel = new Ext.Panel({
            standardSubmit: true,
            collapsible: false,
            id: 'detailsFifthPanel',
            layout: 'table',
            frame: true,
            height: 375,
            width: 240,
            layoutConfig: {
                columns: 1
            },
            items: [firstFifthPanel, secondFifthPanel,emptyPanel2,bargeNetLabelPanel,bargeNetPanel,bargeNameLabelPanel,bargeNamePanel]
        });
        //----------------------------------------Inside two panel-------------------------------------------------//	
        var caseTwoInnerPanel = new Ext.Panel({
            standardSubmit: true,
            collapsible: false,
            autoScroll: true,
            width: 1180,
            height: 395,
            frame: true,
            id: 'InneraddCaseInfo',
            layout: 'table',
            layoutConfig: {
                columns: 4
            },
            items: [caseInnerPanel, detailsThirdPanel, detailsForthPanel, detailsFifthPanel]
        });

      
        //****************************** Window For Adding Trip Information Ends Here************************
        var outerPanelWindow = new Ext.Panel({
            standardSubmit: true,
            id: 'winpanelId',
            frame: true,
            height: 445,
            width: 1180,
            items: [caseTwoInnerPanel, winButtonPanel]
        });

      
        //************************* Outer Pannel *********************************************************//
        myWin = new Ext.Window({
            title: 'My Window',
            closable: false,
            resizable: false,
            modal: true,
            autoScroll: false,
            height: 495,
            width: 1200,
            id: 'myWin',
            items: [outerPanelWindow]
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
                        Ext.example.msg("Enter Remark");
                        Ext.getCmp('remark').focus();
                        return;
                    }
                    canceltripWin.getEl().mask();
                    var selected = grid.getSelectionModel().getSelected();
                      id = selected.get('uniqueIDIndex');
                        permitNo = selected.get('permitIndexId');
                        tcId = selected.get('tcLeaseNoIndexId');
                        routeId = selected.get('RouteIndexId');
                        assetNo=selected.get('assetNoIndex');
                        Ext.Ajax.request({
                            url: '<%=request.getContextPath()%>/TripSheetGenerationForTruckAction.do?param=cancelBargeTruckTrip',
                            method: 'POST',
                            params: {
                                id: id,
                                CustID: clientId,
                                permitNo : permitNo,
                                tcId: tcId,
                                routeId : routeId,
                                assetNo:assetNo,
                                remark: Ext.getCmp('remark').getValue()
                            },
                            success: function(response, options) {
                                var message = response.responseText;
                                Ext.example.msg(message);
                                canceltripWin.getEl().unmask();
                                canceltripWin.hide();
                                store.load({
                                        params: {
                                        	jspName: jspName,
                                            CustID: clientId,
                                            bargeId: bargeId
                                        }
                                    });
                                permitNoComboStore.load({
                                   params: {
                                       CustID: clientId
                                   }
                               });
                               

                        },
                        failure: function() {
                            Ext.example.msg("Error");
                            store.reload();
                            Ext.getCmp('remark').reset();
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

                }
            }
        }
    }]
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
            text: 'Remark' + '  :',
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
        }]
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
          BargeQuantityStore.load({
                        params: {
                         CustID: clientId,
                         bargeNo : bargeNo
                         },callback: function() {
                                for (var i = 0; i < BargeQuantityStore.getCount(); i++) {
                                    var rec = BargeQuantityStore.getAt(i);
                                    bargeQuantity = rec.data['bargeQuantity'];
                                    var conBargeQty=(parseFloat(bargeQuantity)/1000);
                                    Ext.getCmp('bargeQuantity').setValue(conBargeQty.toFixed(3));     
                                    var conNetQty= parseFloat(bargeCapacity)-parseFloat(parseFloat(bargeQuantity)/1000);
                                    Ext.getCmp('bargeNetCapacityId').setValue(conNetQty.toFixed(3));
                                }
                            }
                        });
            timeStore.load({
                params: {
                      CustID: clientId
                      }
           });
            interval = setInterval(function() {
                $.ajax({
                    type: "GET",
                    url: '<%=WEIGHTwebServicePath%>',
                    success: function(data) {
                        Ext.getCmp('quantityId').setValue(data);
                        RFIDquantity = Ext.getCmp('quantityId').getValue();
                        if (Ext.get('tarequantityId').getValue() != "" && Ext.get('tarequantityId').getValue() != null) {
                            var actualQuantity = parseFloat(RFIDquantity) - parseFloat(Ext.get('tarequantityId').getValue());
                            Ext.getCmp('actualquantityId').setValue(actualQuantity);
                         
                        } else {
                            Ext.getCmp('actualquantityId').setValue(0);
                        }
                    }
                });
            }, 5000);

            buttonValue = "add";
            title = 'Add Truck Trip Sheet Information';
            myWin.setTitle(title);
            var d = new Date();
            d.setDate(d.getDate() + 1);
            d.setHours(18);
            d.setSeconds(00);
            d.setMinutes(00);
             if(bargeLocation!= bargeLocId){
	          	  Ext.example.msg(" Please do the user setting ");
	              return;             
             }
  			 if(bargeStatus=='In-Transit'){
	          	  Ext.example.msg("Barge Loading is Stopped");
	              return;             
             }else if(bargeStatus=='Closed-Completed Trip'){
	          	  Ext.example.msg("Barge trip sheet is closed");
	              return;             
             }else if(bargeStatus=='In-transit Modified'){
	          	  Ext.example.msg("Barge Loading is Stopped");
	              return;             
             }else if(bargeStatus== 'Closed-Cancelled Trip'){
	              Ext.example.msg("Trip has been cancelled");
	              return; 
             }else if(bargeStatus== 'Closed Diverted Trip'){
	              Ext.example.msg("Barge Loading is Stopped");
	              return; 
             }
            //vehicleComboStore.load();
            $('#vehiclecomboId').val('');
            Ext.getCmp('typecomboId').setDisabled(false);
            Ext.getCmp('RFIDId').enable;
            Ext.getCmp('RFIDButtId').setDisabled(false);


            Ext.getCmp('vehiclecomboId').setDisabled(false);
            Ext.getCmp('captureWeightId').enable();

            Ext.getCmp('tripsheetNumberLabelId').hide(),
            Ext.getCmp('mandatorytripsheetNumberId').hide(),
            Ext.getCmp('enrollNumberId').hide(),
            Ext.getCmp('RFIDId').setValue('');
            Ext.getCmp('quantityId').setValue('');
            Ext.getCmp('tarequantityId').setValue('');
            Ext.getCmp('actualquantityId').setValue('');
            Ext.getCmp('startDateTime').setValue(d);
          //  Ext.getCmp('gradeAndMineralscomboId').setValue('');
            Ext.getCmp('permitcomboId').enable();
           // Ext.getCmp('permitcomboId').setValue('');
         //   Ext.getCmp('routecomboId').setValue('');
		//	Ext.getCmp('quantityId2').setValue('');
		//	Ext.getCmp('quantityId2b').setValue('');
			Ext.getCmp('bargeQuantity').setValue('');
            Ext.getCmp('bargeCapacityId').setValue('');
            Ext.getCmp('bargeNetCapacityId').setValue('');
            if (tripType == 'Close' || tripType == undefined) {
                Ext.example.msg("Please do the user setting");
                return;
            }
            Ext.getCmp('bargeCapacityId').setValue(bargeCapacity);
            if(bargeQuantity=="" || bargeQuantity==null){
            bargeQuantity=0;
            }
            Ext.getCmp('bargeQuantity').setValue(parseFloat(bargeQuantity)/1000);
            Ext.getCmp('bargeNameId').setValue(bargeNo);
          //  alert(parseFloat(bargeCapacity)-parseFloat(parseFloat(bargeQuantity)/1000));
           
            Ext.getCmp('innerfifthMaster').show();
         if(Ext.getCmp('permitcomboId').getValue()!=null && Ext.getCmp('permitcomboId').getValue()!=''){
			permitNoComboStore.load({
             params: {
                 CustID: clientId
            },callback: function() {
                 var id = Ext.getCmp('permitcomboId').getValue();
        			var row = permitNoComboStore.findExact('pId', id);
          		var rec = permitNoComboStore.getAt(row);
            		quantity = rec.data['quantity'];
            		balance = rec.data['tripSheetQty'];
            		Ext.getCmp('quantityId2').setValue(quantity);
            		Ext.getCmp('quantityId2b').setValue(balance); 
             }
          });
			
			}
			vehicleComboStore.load({  params: { CustId: clientId } });
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
            }else{
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
            myWin.show();
        }
        
        function deleteData(){
                buttonValue = "cancelTrip";
                var selected = grid.getSelectionModel().getSelected();
                if (clientId == "") {
                     Ext.example.msg("<%=pleaseSelectcustomer%>");
                     return;
                 }
                 if (grid.getSelectionModel().getCount() > 1) {
                     Ext.example.msg("<%=SelectSingleRow%>");
                     return;
                 }
                 if (grid.getSelectionModel().getSelected() == null) {
                     Ext.example.msg("<%=noRecordsFound%>");
                     return;
                 }
                 canceltripWin.show();
       }
        
var reader1 = new Ext.data.JsonReader({
    root: 'TripDetailsImportRoot',
    totalProperty: 'total',
    fields: [{
        name: 'importslnoIndex'
    }, {
        name: 'importtypeindex'
    }, {
        name: 'importvehicleNoindex'
    },{
        name: 'importvalidityDateindex'
    }, {
        name: 'importpermitNoindex'
    }, {
        name: 'importgrossWeightindex'
    }, {
        name: 'importtripstatusindex'
    },{
        name: 'importtripremarksindex'
    },{
        name: 'importpermitIdindex'
    },{
        name: 'importpermitQtyindex'
    },{
        name: 'importtareWeightindex'
    },{
        name: 'importnetWeightindex'
    },{
        name: 'importgradeindex'
    },{
        name: 'importrouteIdindex'
    },{
        name: 'importorgCodeindex'
    },{
    	name:'importtcIdindex' 
    },{
    	name:'transactionIDindex' 
    },{
    	name:'bargeIDindex' 
    },{
    	name:'commStatusindex' 
    }]
});

var importstore = new Ext.data.GroupingStore({
    proxy: new Ext.data.HttpProxy({
        url: '<%=request.getContextPath()%>/SimDetailsAction.do?param=getImportSimDetails',
        method: 'POST'
    }),
    remoteSort: false,
    bufferSize: 700,
    autoLoad: false,
    reader: reader1
}); 

//****************************grid filters

//****************column Model Config
var createColModel = function (finish, start) {
    var columns = [
        new Ext.grid.RowNumberer({
            header: "<span style=font-weight:bold;><%=SLNO%></span>",
            width: 50
        }), {
            header: "<span style=font-weight:bold;><%=SLNO%></span>",
            dataIndex: 'importslnoIndex',
            hidden: true,
            width: 100
        },
        {
            header: "<span style=font-weight:bold;>Type</span>",
            hidden: false,
            width: 80,
            dataIndex: 'importtypeindex'
        }, {
            header: "<span style=font-weight:bold;>Vehicle No</span>",
            hidden: false,
            width: 105,
            dataIndex: 'importvehicleNoindex'
        }, {
            header: "<span style=font-weight:bold;>Validity DateTime</span>",
            hidden: false,
            width: 130,
            dataIndex: 'importvalidityDateindex'
        },
       {
            header: "<span style=font-weight:bold;>Permit No</span>",
            hidden: false,
            width: 150,
            dataIndex: 'importpermitNoindex'
        },
       {
            header: "<span style=font-weight:bold;>Gross Weight</span>",
            hidden: false,
            width: 100,
            dataIndex: 'importgrossWeightindex'
        },
        {
            header: "<span style=font-weight:bold;>Transaction Id</span>",
            hidden: false,
            width: 120,
            dataIndex: 'transactionIDindex'
        },
        {
            header: "<span style=font-weight:bold;>Barge Id</span>",
            hidden: false,
            width: 80,
            dataIndex: 'bargeIDindex'
        },{
            header: "<span style=font-weight:bold;>Valid Status</span>",
            hidden: false,
            width: 80,
            dataIndex: 'importtripstatusindex',
            renderer: checkValid
        },{
            header: "<span style=font-weight:bold;>Remarks</span>",
            hidden: false,
            width: 290,
            dataIndex: 'importtripremarksindex'
        },{
            header: "<span style=font-weight:bold;>Permit Id</span>",
            hidden: true,
            width: 80,
            dataIndex: 'importpermitIdindex'
        },{
            header: "<span style=font-weight:bold;>Permit Quantity</span>",
            hidden: true,
            width: 100,
            dataIndex: 'importpermitQtyindex'
        },{
            header: "<span style=font-weight:bold;>Tare Weight</span>",
            hidden: true,
            width: 100,
            dataIndex: 'importtareWeightindex'
        },{
            header: "<span style=font-weight:bold;>Net Weight</span>",
            hidden: true,
            width: 100,
            dataIndex: 'importnetWeightindex'
        },{
            header: "<span style=font-weight:bold;>Grade</span>",
            hidden: true,
            width: 100,
            dataIndex: 'importgradeindex'
        },{
            header: "<span style=font-weight:bold;>Route Id</span>",
            hidden: true,
            width: 100,
            dataIndex: 'importrouteIdindex'
        },{
            header: "<span style=font-weight:bold;>Org Code</span>",
            hidden: true,
            width: 100,
            dataIndex: 'importorgCodeindex'
        },{
            header: "<span style=font-weight:bold;>Tc Id</span>",
            hidden: true,
            width: 100,
            dataIndex: 'importtcIdindex'
        },{
            header: "<span style=font-weight:bold;>Comm Status</span>",
            hidden: true,
            width: 100,
            dataIndex: 'commStatusindex'
        }

    ];
    return new Ext.grid.ColumnModel({
        columns: columns.slice(start || 0, finish),
        defaults: {
            sortable: false
        }
    });
};

function checkValid(val) {
    if (val == "Invalid") {
        return '<img src="/ApplicationImages/ApplicationButtonIcons/No.png">';
    } else if (val == "Valid") {
        return '<img src="/ApplicationImages/ApplicationButtonIcons/Yes.png">';
    }
} 
 
 function getImportExcelGrid(gridtitle,emptytext,store,width,height,gridnoofcols,filters,filterstr,reconfigure,reconfigurestr,reconfigurenoofcols,group,groupstr,chart,chartstr,excel,excelstr,jspName,exportDataType,pdf,pdfstr,add,addstr,modify,modifystr,del,delstr,closetrip,closestr,verify,verifystr,approve, approvestr,copy, copystr,postpone,postponestr,importExcel,importStr,save,saveStr,clearData,clearStr,close,closeStr){
	 var grid = new Ext.grid.GridPanel({
	    	title:gridtitle,
	        border: false,
	        height: getGridHeight(),
	        autoScroll:true,
	        sortable: false,
	        store: store,
	        id:'grid',
	        colModel: createColModel(gridnoofcols),
	        loadMask: true,
	        listeners: {
                render : function(grid){
                  grid.store.on('load', function(store, records, options){
                    grid.getSelectionModel().selectFirstRow();       
                  });                      
                }
               },
	        bbar: new Ext.Toolbar({
	        })
	    });
	if(width>0){
		grid.setSize(width,height);
	}
	 grid.getBottomToolbar().add(['->']);
		if(save)
		{
			grid.getBottomToolbar().add([
			'-',                            
			{
			    text:saveStr,
			    iconCls : 'savebutton',
			    handler : function(){
			    saveDate();

			    }    
			  }]);
		}
		if(clearData)
		{
			grid.getBottomToolbar().add([
			'-',                            
			{
			    text:clearStr,
			    iconCls : 'clearbutton',
			    handler : function(){
			    clearInputData();

			    }    
			  }]);
		}
		if(close)
		{
			grid.getBottomToolbar().add([
			'-',                            
			{
			    text:closeStr,
			    iconCls : 'closebutton',
			    handler : function(){
			    closeImportWin();

			    }    
			  }]);
		}

	return grid;
}
 
 
importgrid = getImportExcelGrid('', 'No Records Found', importstore, 1225, 198, 20, '','', false, '', 20, false, '', false, '', false, 'Excel', jspName, exportDataType, false, 'PDF', false, 'Add', false, 'Modify', false, 'Delete',false,'',false,'',false,'',false,'',false,'',false,'',true,'Save',true,'Clear',true,'Close');	
      
     
       
var excelImageFormat = new Ext.FormPanel({
    standardSubmit: true,
    collapsible: false,
    id: 'excelMaster',

    height: 170,
    width: '100%',
    frame: false,
    items: [{
        cls: 'tripimportimagepanel'
    }]
});

        
var fp = new Ext.FormPanel({

    fileUpload: true,
    width: '100%',
    frame: true,
    autoHeight: true,
    standardSubmit: false,
    labelWidth: 70,
    defaults: {
        anchor: '95%',
        allowBlank: false,
        msgTarget: 'side'
    },
    items: [{
        xtype: 'fileuploadfield',
        id: 'filePath',
        width: 60,
        emptyText: 'Browse',
        fieldLabel: 'ChooseFile',
        name: 'filePath',
        buttonText: '',
        buttonCfg: {
	        iconCls: 'browsebutton'
        },
        listeners: {

            fileselected: {
                fn: function () {
                    var filePath = document.getElementById('filePath').value;
                    var imgext = filePath.substring(filePath.lastIndexOf(".") + 1, filePath.length);
                    if (imgext == "xls" || imgext == "xlsx") {

                    } else {
                        Ext.MessageBox.show({
                            msg: 'Please select only .xls or .xlsx files',
                            buttons: Ext.MessageBox.OK
                        });
                        Ext.getCmp('filePath').setValue("");
                        return;
                    }
                }
            }

        }
    }],
    buttons: [{
        text: 'Upload',
        iconCls : 'uploadbutton',
        handler: function () {
            if (fp.getForm().isValid()) {
            
                var filePath = document.getElementById('filePath').value;

                var imgext = filePath.substring(filePath.lastIndexOf(".") + 1, filePath.length);
                if (imgext == "xls" || imgext == "xlsx") {
					clearInputData();
                } else {
                    Ext.MessageBox.show({
                        msg: 'Please select only .xls or .xlsx files',
                        buttons: Ext.MessageBox.OK
                    });
                    Ext.getCmp('filePath').setValue("");
                    return;
                }      
                fp.getForm().submit({
                    url: '<%=request.getContextPath()%>/TripSheetGenerationForTruckAction.do?param=importTripDetailsExcel',
                    enctype: 'multipart/form-data',
                    waitMsg: 'Uploading your file...',
                    success: function (response, action) {
						
						Ext.Ajax.request({
                        url: '<%=request.getContextPath()%>/TripSheetGenerationForTruckAction.do?param=getImportTripDetails',
                        method: 'POST',
                        params: {
                            simImportResponse: action.response.responseText
                        },
                        success: function (response, options) {
                            simResponseImportData  = Ext.util.JSON.decode(response.responseText);
                            importstore.loadData(simResponseImportData);
                            
                        },
                        failure: function () {
                        Ext.example.msg("Error");
                        }
                    });
                        
                    },
                    failure: function () {
                    Ext.example.msg("Please Upload The Standard Format");
                    }
                });
            }
        }
    }, {
		text: 'Get Standard Format',
		iconCls : 'downloadbutton',
	    handler : function(){
	    Ext.getCmp('filePath').setValue("Upload the Standard Format");
	    fp.getForm().submit({
	    	url:'<%=request.getContextPath()%>/TripSheetGenerationForTruckAction.do?param=openStandardFileFormats'
	    	});
		}	   
	}]
});
var importPanelWindow = new Ext.Panel({
    cls: 'outerpanelwindow',
    frame: false,
    layout: 'column',
    layoutConfig: {
        columns: 1
    },
    items: [fp,excelImageFormat,importgrid]
});

importWin = new Ext.Window({
    title: 'Tripsheet Import Details',
    width: 1240,
    height:483,
    closable: false,
    modal: true,
    resizable: false,
    autoScroll: false,
    id: 'importWin',
    items: [importPanelWindow]
});   
<%if (loginInfo.getStyleSheetOverride().equals("Y")){%>
 importWin.setHeight(505);
importWin.setWidth(1240);
<%}%>     
        
        
 function saveDate(){
var simValidCount = 0;
var totalSimcount = importstore.data.length;
    for (var i = 0; i < importstore.data.length; i++) {
        var record = importstore.getAt(i);
        var checkvalidOrInvalid = record.data['importtripstatusindex'];
        if (checkvalidOrInvalid == 'Valid') {
            simValidCount++;
        }
    }
    
	var saveJson = getJsonOfStore(importstore);
	
Ext.Msg.show({
        title: 'Saving..',
        msg: 'We have ' + simValidCount + ' valid transaction to be saved out of ' + totalSimcount + ' .Do you want to continue?',
        buttons: Ext.Msg.YESNO,
        fn: function (btn) {
            if (btn == 'no') {
                return;
            }
            if (btn == 'yes') {
		if (saveJson != '[]' && simValidCount>0) {
         Ext.Ajax.request({
               url: '<%=request.getContextPath()%>/TripSheetGenerationForTruckAction.do?param=saveImportTripDetails',
               method: 'POST',
               params: {
                            tripDataSaveParam: saveJson,
                            bargeStatus : bargeStatus,
                            custId : clientId,
                            bargeId : bargeId,
                            bargeCapacity : bargeCapacity,
                            bargeNo : bargeNo,
                            tripNo : tripNo,
                            userSettingId : userSettingId,
                            srcHubId : srcHubId,
                            desHubId : desHubId
                            
               },
               success: function (response, options) {
               			var message = response.responseText;
               			Ext.example.msg(message);
               			 store.load({
                                        params: {
                                        	jspName: jspName,
                                            CustID: clientId,
                                            bargeId: bargeId
                                        }
                                    });
                        permitNoComboStore.load({
	                            params: {
	                                CustID: clientId
	                            }
	                        });
	                        
							Ext.getCmp('routecomboId').setValue("");
				            Ext.getCmp('quantityId2').setValue("");
				            Ext.getCmp('quantityId2b').setValue("");
				            Ext.getCmp('gradeAndMineralscomboId').setValue("");
				            Ext.getCmp('permitcomboId').setValue("");
	                        
               },
               failure: function () {
               Ext.example.msg("Error");
                        }
               });
               clearInputData();
               fp.getForm().reset();
               importWin.hide();
           }else{
           Ext.MessageBox.show({
                        msg: "You don't have any Valid Information to Proceed",
                        buttons: Ext.MessageBox.OK
                    });
           }
         }
       }
     });
}
function getJsonOfStore(importstore) {
    var datar = new Array();
    var jsonDataEncode = "";
    var recordss = importstore.getRange();
    for (var i = 0; i < recordss.length; i++) {
        datar.push(recordss[i].data);
    }
    jsonDataEncode = Ext.util.JSON.encode(datar);

    return jsonDataEncode;
}
function clearInputData() {
    importgrid.store.clearData();
    importgrid.view.refresh();
}

function closeImportWin(){
fp.getForm().reset();
            importWin.hide();
			clearInputData();
}

function importExcelData() {
    importButton = "import";
    importTitle = 'Truck Trip Sheet Import Details';
        if(bargeStatus=='In-Transit'){
     	  Ext.example.msg("Barge Loading is Stopped");
         return;             
        }
        
        if(bargeStatus=='Closed-Completed Trip'){
     	  Ext.example.msg("Barge trip sheet is closed");
         return;             
        }
         if(bargeStatus=='In-transit Modified'){
     	  Ext.example.msg("Barge Loading is Stopped");
         return;             
        }
        if(bargeStatus== 'Closed-Cancelled Trip'){
         Ext.example.msg("Trip has been cancelled");
         return; 
        }else if(bargeStatus== 'Closed Diverted Trip'){
	              Ext.example.msg("Barge Loading is Stopped");
	              return; 
             }
    importWin.show();
    importWin.setTitle(importTitle);
}

        //*********************** Function to Modify Data ***********************************
      

var back='1';
var buttonPanel=new Ext.FormPanel({
       	id: 'buttonid',
       	cls:'colorid',
       	frame:true,
           buttons:[{
              		text: 'Back',
              		cls:'colorid',
              		iconCls:'backbutton',
              		hidden:false,
              		handler : function(){
								var bargeTrip='/Telematics4uApp/Jsps/IronMining/TripSheetGenerationForBargeFirstTab.jsp?back='+back+'&startDate='+startDate+'&endDate='+endDate+'&custId='+clientId+'&custName='+custName;
			              		parent.Ext.getCmp('partOneTab').disable();
			              		parent.Ext.getCmp('generalBargeTab').enable();
			              		parent.Ext.getCmp('generalBargeTab').show();
			              		parent.Ext.getCmp('generalBargeTab').update("<iframe style='width:100%;height:530px;border:0;'  src='"+bargeTrip+"'></iframe>");
		          
						}
              		}]
	 });

        Ext.onReady(function() {
            Ext.QuickTips.init();
            Ext.form.Field.prototype.msgTarget = 'side';
            outerPanel = new Ext.Panel({
                renderTo: 'content',
                standardSubmit: true,
                frame: true,
                height: 500,
                width: screen.width - 40,
                items: [grid,buttonPanel]
            });
            
             var cm = grid.getColumnModel();
                        for (var j = 1; j < cm.getColumnCount(); j++) {
                            cm.setColumnWidth(j, 155);
                        }
                        
                        permitNoComboStore.load({
                            params: {
                                CustID: clientId
                            }
                        });
                        tripStore.load({
                            params: {
                                CustID: clientId
                            },
                            callback: function() {
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
                        
                          store.load({
                                        params: {
                                        	jspName: jspName,
                                            CustID: clientId,
                                            bargeId: bargeId
                                        }
                                    });
                     Ext.Ajax.timeout = 180000;
                        
        });			
   </script>
  </body>
</html>
<%}%>

