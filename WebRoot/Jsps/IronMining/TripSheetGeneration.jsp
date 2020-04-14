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
		tobeConverted.add("Route_Names");
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
		tobeConverted.add("Organization_Trader_Name");
		
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
		String Organization_Trader_Name=convertedWords.get(38);
		
		int systemId = loginInfo.getSystemId();
		int userId=loginInfo.getUserId(); 
		int customerId = loginInfo.getCustomerId();
		String userAuthority=cf.getUserAuthority(systemId,userId);	
	    String addButton="true";
	    String modifyButton="true";
	    String destWeight="true";
	    String closetrip="true";
	    String cancel="true";
	    String tripTransfer="true";
	    String order="RMK/Order";
	    System.out.println("isltsp== "+loginInfo.getIsLtsp());
	     if(loginInfo.getIsLtsp()== 0)
	    {
	        addButton="true";
		    modifyButton="true";
	        destWeight="true";
	        closetrip="true";
	        cancel="true";
	        tripTransfer="true";
	    }
	else if(loginInfo.getIsLtsp()== -1 && userAuthority.equalsIgnoreCase("User"))
		{
			addButton="true";
		    modifyButton="true";
	        destWeight="true";
	        closetrip="true";
	        cancel="true";
	        tripTransfer="false";
		}else{
		    addButton="false";
		    modifyButton="false";
	        destWeight="false";
	        closetrip="false"; 
	        cancel="false";
	        tripTransfer="false";
		}
		

%>

        <jsp:include page="../Common/header.jsp" />
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
				.x-menu-list {
					height: auto !important;
				}
				
			</style>
		<%}%>
            <title>Trip Generation Report</title>
      
        <style>
            .x-panel-tl {
                border-bottom: 0px solid !important;
            }
            
            .quantityBox {
                background-color: white;
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
            .my-label-styleT {
                font-weight: bold;
                font-size: 23px;
                text-align: center;
                margin-left: -125px;
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
            .my-label-style2-1 {
                font-weight: bold;
                font-size: 15px;
                text-align: center;
            }
            
            .my-label-style3 {
                font-weight: bold;
                font-size: 15px !important;
                text-align: center;
                margin-left: 23px;
            }
            
            .quantityBox1 {
                background-color: white;
                <!-- padding: 10px !important;
                --> <!-- width: 110px !important;
                --> <!-- height: 40px !important;
                --> <!-- margin: 10px !important;
                --> <!-- line-height: 20px !important;
                --> color: black;
                font-weight: bold !important;
                font-size: 15px !important;
                text-align: center !important;
            }
           #routecomboId{
             width: 254px !important;
             height: 76px !important;
             font-weight: bold !important;
           }
           #orgcomboId{
             width: 257px !important;
             height: 25px !important;
           }
           #tripsheetNoId{
             width: 185px !important;
           }
           x-panel-body x-table-layout-ct{
           	    height: 421px;
           }
           input#quantityId,input#tarequantityId,input#actualquantityId,#quantityIdC,#quantityIdC2 {
           		height : 60px !important;
           	    width  : 120px !important;
           }
           
        </style>

        
            <%if (loginInfo.getStyleSheetOverride().equals("Y")){%>
                <jsp:include page="../Common/ImportJSSandMining.jsp" />
                <%}else{%>
                    <jsp:include page="../Common/ImportJS.jsp" />
                    <%}%>
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
                            var exportDataType = "int,string,string,string,string,string,string,string,string,string,string,string,string,number,number,number,string,number,number,number,string,number,string,string,string,string,string,string,string,string,string,string,string,string,string,string";
                            var routeName;
                            var routeId;
                            var tcId;
                            var lesseName;
                            var grossweight;
                            var tareweight;
                            var routeNameForTare;
                            var routeIdForTare;
                            var tcIdForTare;
                            var lesseNameForTare;
                            var quantity1;
                            var loadcapacity;
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
                            var grossweightRfid;
                            var tareweightRfid;
                            var rsSource;
							var rsDestination;
							var transactionNo;
							var tripNo;
							var tripId;
							var Transfertareweight;
							var netweightDest;
							var netweightRfid;
							var grossweightDest;
							var loadcapacityClose;
							var tripsheetCount1;
                            var tripsheetCount2;
                            var srcType ;
							
                            //--------------------------------------------------------------------------//
                            var reeasonComboStore = new Ext.data.SimpleStore({
                                id: 'reasoncombostoreId',
                                autoLoad: true,
                                fields: ['Name', 'Value'],
                                data: [
                                    ['Digitizer showing incorrect value', 'Digitizer showing incorrect value'],
                                    ['Weighbridge calibration faulty', 'Weighbridge calibration faulty'],
                                    ['Check Vehicle Tare Weight ', 'Check Vehicle Tare Weight '],
                                    ['Moisture content in Cargo', 'Moisture content in Cargo'],
                                    ['Unauthorized Accessories ', 'Unauthorized Accessories ']
                                ]
                            });

                            var reasoncombo = new Ext.form.ComboBox({
                                store: reeasonComboStore,
                                id: 'reasonCloaseId',
                                mode: 'local',
                                forceSelection: true,
                                selectOnFocus: true,
                                anyMatch: true,
                                typeAhead: false,
                                triggerAction: 'all',
                                resizable: true,
                                lazyRender: true,
                                valueField: 'Value',
                                displayField: 'Name',
                                cls: 'selectstylePerfect',
                                blankText: 'Select Reason',
                                emptyText: 'Select Reason',
                                listeners: {
                                    select: {
                                        fn: function() {
                                        }
                                    }
                                }
                            });
                            var Typecombostore = new Ext.data.JsonStore({
                                url: '<%=request.getContextPath()%>/TripSheetGenerationAction.do?param=getOperationType',
                                id: 'TypecombostoreId',
                                autoLoad: true,
                                fields: ['Name', 'Value'],
                                root: 'operationTypeRoot',
                                autoload: false,
                                remoteSort: true,
                            });

                            var typecombo = new Ext.form.ComboBox({
                                store: Typecombostore,
                                id: 'typecomboId',
                                mode: 'local',
                                forceSelection: true,
                                selectOnFocus: true,
                                resizable: true,
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
                                            vehicleComboStore.load({
                                                params: {
                                                    CustId: Ext.getCmp('custcomboId').getValue()
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


                            var typecomboforTare = new Ext.form.ComboBox({
                                store: Typecombostore,
                                id: 'typecomboIdTare',
                                mode: 'local',
                                forceSelection: true,
                                emptyText: '<%=selectType%>',
                                blankText: '<%=selectType%>',
                                selectOnFocus: true,
                                allowBlank: false,
                                resizable: true,
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

                            //************************ Store for Grade And Minerals  Here***************************************//
                            var gradeComboStore = new Ext.data.JsonStore({
                                url: '<%=request.getContextPath()%>/TripSheetGenerationAction.do?param=getGrade',
                                id: 'gradeStoreId',
                                root: 'gradeRoot',
                                autoload: false,
                                remoteSort: true,
                                fields: ['gradeName'],
                                listeners: {
                                    load: function() {}
                                }
                            });
                            var gradeAndMineralsCombo = new Ext.form.ComboBox({
                                store: gradeComboStore,
                                id: 'gradeAndMineralscomboId',
                                mode: 'local',
                                forceSelection: true,
                                emptyText: '<%=enterGradeMinerals%>',
                                blankText: '<%=enterGradeMinerals%>',
                                selectOnFocus: true,
                                allowBlank: true,
                                listWidth: 150,
                                anyMatch: true,
                                typeAhead: false,
                                triggerAction: 'all',
                                lazyRender: true,
                                valueField: 'gradeName',
                                displayField: 'gradeName',
                                cls: 'selectstylePerfect',
                                resizable: true,
                                listeners: {
                                    select: {
                                        fn: function() {

                                        }
                                    }
                                }
                            });
                            //************************ Store for Vehicel Number  Here***************************************//
                            var vehicleComboStore = new Ext.data.JsonStore({
                                url: '<%=request.getContextPath()%>/TripSheetGenerationAction.do?param=getVehicleList',
                                id: 'vehicleComboStoreId',
                                root: 'vehicleComboStoreRoot',
                                autoload: false,
                                remoteSort: true,
                                fields: ['vehicleNoID', 'vehicleName', 'quantity1','loadcapacity','incExpStatus','pucExpStatus']
                            });

                            var vehicleCombo = new Ext.form.ComboBox({
                                store: vehicleComboStore,
                                id: 'vehiclecomboId',
                                mode: 'local',
                                forceSelection: true,
                                selectOnFocus: true,
                                resizable: true,
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
                                            loadcapacity = rec.data['loadcapacity'];
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
                                    },change: {
                                        fn: function() {
                                            var vehicleNo = Ext.getCmp('vehiclecomboId').getValue();
                                            var row = vehicleComboStore.findExact('vehicleNoID', vehicleNo);
                                            var rec = vehicleComboStore.getAt(row);
                                            quantity1 = rec.data['quantity1'];
                                            loadcapacity = rec.data['loadcapacity'];
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
                            var vehicleCombo1 = new Ext.form.ComboBox({
                                store: vehicleComboStore,
                                id: 'vehiclecombo1Id',
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
                                            var traVehicleNo = Ext.getCmp('vehiclecombo1Id').getValue();
                                            var row = vehicleComboStore.findExact('vehicleNoID', traVehicleNo);
                                            var rec = vehicleComboStore.getAt(row);
                                            Transfertareweight = rec.data['quantity1'];
                                            incExpStatus = rec.data['incExpStatus'];
                                            pucExpStatus= rec.data['pucExpStatus'];
                                            if(incExpStatus=='False'){
                                               Ext.MessageBox.show({
						                         msg: 'Insurance expired.Please renew for trip sheet allocation',
						                         buttons: Ext.MessageBox.OK
						                       });
                                               Ext.getCmp('vehiclecombo1Id').reset();
			                                   return;
                                            }
                                            if(pucExpStatus=='False'){
	                                           Ext.MessageBox.show({
						                         msg: 'PUC expired.Please renew for trip sheet allocation.',
						                         buttons: Ext.MessageBox.OK
						                       });
                                               Ext.getCmp('vehiclecombo1Id').reset();
			                                   return;
                                            }
                                        }
                                    },change: {
                                        fn: function() {
                                            var traVehicleNo = Ext.getCmp('vehiclecombo1Id').getValue();
                                            var row = vehicleComboStore.findExact('vehicleNoID', traVehicleNo);
                                            var rec = vehicleComboStore.getAt(row);
                                            Transfertareweight = rec.data['quantity1'];
                                            incExpStatus = rec.data['incExpStatus'];
                                            pucExpStatus= rec.data['pucExpStatus'];
                                            if(incExpStatus=='False'){
                                               Ext.MessageBox.show({
						                         msg: 'Insurance expired.Please renew for trip sheet allocation',
						                         buttons: Ext.MessageBox.OK
						                       });
                                               Ext.getCmp('vehiclecombo1Id').reset();
			                                   return;
                                            }
                                            if(pucExpStatus=='False'){
	                                           Ext.MessageBox.show({
						                         msg: 'PUC expired.Please renew for trip sheet allocation.',
						                         buttons: Ext.MessageBox.OK
						                       });
                                               Ext.getCmp('vehiclecombo1Id').reset();
			                                   return;
                                            }
                                        }
                                    }
                                }
                            });

                            var vehicleComboStoreForTare = new Ext.data.JsonStore({
                                url: '<%=request.getContextPath()%>/TripSheetGenerationAction.do?param=getVehicleListForTare',
                                id: 'vehicleComboStoreIdTare',
                                root: 'vehicleComboStoreRoot',
                                autoload: false,
                                remoteSort: true,
                                fields: ['tcNo', 'tripName', 'vehicleName', 'validityDate', 'grade', 'orgName','grossWeight','tareWeight','tripNo','tripSheetNo','grossWeightDest','tareWeightDest','loadCapacity']
                            });

                            var vehicleComboForTare = new Ext.form.ComboBox({
                                store: vehicleComboStoreForTare,
                                id: 'vehiclecomboIdTare',
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
                                valueField: 'vehicleName',
                                displayField: 'vehicleName',
                                cls: 'selectstylePerfect',
                                emptyText: '<%=selectVehicleNO%>',
                                blankText: '<%=selectVehicleNO%>',
                                listeners: {
                                    select: {
                                        fn: function() {
                                            var vehicleNo = Ext.getCmp('vehiclecomboIdTare').getValue();
                                            var row = vehicleComboStoreForTare.findExact('vehicleName', vehicleNo);
                                            var rec = vehicleComboStoreForTare.getAt(row);
                                            tcNum = rec.data['tcNo'];
                                            tripName = rec.data['tripName'];
                                            validityDate = rec.data['validityDate'];
                                            grade = rec.data['grade'];
                                            tareOrgName = rec.data['orgName'];
                                            grossweight = rec.data['grossWeight'];
                                            tareweight = rec.data['tareWeight'];
                                            tripNo = rec.data['tripNo'];
                                            grossWeightDest = rec.data['grossWeightDest'];
                                            closeTripShhetNo=rec.data['tripSheetNo'];
                                            netweightDest=grossweight-tareweight;
                                            loadcapacityClose=parseFloat(rec.data['loadCapacity']);
                                            Ext.getCmp('quantityIdC').setValue(grossweight);
                                            Ext.getCmp('quantityIdC2').setValue(tareweight);
                                            
                                            Ext.getCmp('grossWeight@SId').setText(grossweight);
                                            Ext.getCmp('tareWeight@SId').setText(tareweight);
                                            Ext.getCmp('netWeight@SId').setText(netweightDest);
                                            Ext.getCmp('tripsheetId').setText(closeTripShhetNo);
                                           
                                            Ext.getCmp('tcNamecomboIdTare').setValue(tcNum);
                                            Ext.getCmp('routecomboIdforTare').setValue(tripName);
                                            Ext.getCmp('startDateTimeForTare').setValue(validityDate);
                                            Ext.getCmp('gradeAndMineralscomboIdForTare').setValue(grade);
                                            Ext.getCmp('orgNamecomboIdTare').setValue(tareOrgName);
                                            if (tcNum == '') {
                                                Ext.getCmp('mandatoryTcleaseNameT').hide();
                                                Ext.getCmp('TcleaseNameIDT').hide();
                                                Ext.getCmp('tcNamecomboIdTare').hide();
                                                Ext.getCmp('orgNamecomboIdTare').show();
                                                Ext.getCmp('TcleaseNameIDT1').show();
                                                Ext.getCmp('mandatoryTcleaseNameT1').show();
                                            } else {
                                                Ext.getCmp('mandatoryTcleaseNameT').show()
                                                Ext.getCmp('TcleaseNameIDT').show();
                                                Ext.getCmp('tcNamecomboIdTare').show();
                                                Ext.getCmp('orgNamecomboIdTare').hide();
                                                Ext.getCmp('TcleaseNameIDT1').hide();
                                                Ext.getCmp('mandatoryTcleaseNameT1').hide();
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
                                //minValue:endDateMinVal,
                                //maxValue: new Date(),
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
                                fields: ['sHubId', 'dHubId', 'type', 'userSettingId','closingType','tripNo'],
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
                                fields: ['routeName', 'lesseName', 'jsonString', 'grade', 'validityDate', 'orgName','tareWeight','grossWeight','tripNo','grossWeightDestRfid','loadCapacity'],
                                listeners: {
                                    load: function() {}
                                }
                            });

                            var tripStoreForRfidAdd = new Ext.data.JsonStore({
                                url: '<%=request.getContextPath()%>/TripSheetGenerationAction.do?param=getRFID',
                                id: 'tripStoreIdForRfidAdd',
                                root: 'tripRoot',
                                autoload: false,
                                fields: ['quantity1', 'jsonString','loadcapacity','incExpStatus','pucExpStatus'],
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

                            //************************ Store for Permit No Here***************************************//
                            var permitNoComboStore = new Ext.data.JsonStore({
                                url: '<%=request.getContextPath()%>/TripSheetGenerationAction.do?param=getPermitNo',
                                id: 'permitStoreId',
                                root: 'permitRoot',
                                autoload: false,
                                remoteSort: true,
                                fields: ['routeId', 'routeName', 'quantity', 'permitNo', 'pId', 'tripSheetQty','tcId','orgCode','leaseName','orgName','tripsheetCount1','tripsheetCount2','srcType'],
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
                                resizable: true,
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
                                            tripsheetCount1=rec.data['tripsheetCount1'];
                                            tripsheetCount2=rec.data['tripsheetCount2'];
                                            srcType=rec.data['srcType'];
                                            
                                            Ext.getCmp('routecomboId').setValue(routeName);
                                            Ext.getCmp('quantityId2').setValue(quantity);
                                            Ext.getCmp('quantityId2b').setValue(balance);
                                            Ext.getCmp('gradeAndMineralscomboId').reset();
                                            if (tcId == '' || tcId == 0) {
			                                 	
			                                    Ext.getCmp('orgcomboId').setValue(orgName);
			                                    Ext.getCmp('tcNamecomboId').hide();
			                                    Ext.getCmp('TcleaseNameID').hide();
			                                    Ext.getCmp('mandatoryTcleaseName').hide();
			                                    
			                                    Ext.getCmp('orgcomboId').show();
			                                    Ext.getCmp('OrgNameNameID').show();
			                                    Ext.getCmp('mandatoryTcleaseName12').show();
			                                } else {
			                                    Ext.getCmp('tcNamecomboId').setValue(lesseName);
			                                    Ext.getCmp('orgcomboId').hide();
			                                    Ext.getCmp('OrgNameNameID').hide();
			                                    Ext.getCmp('mandatoryTcleaseName12').hide();
			                                    
			                                    Ext.getCmp('tcNamecomboId').show();
			                                    Ext.getCmp('TcleaseNameID').show();
			                                    Ext.getCmp('mandatoryTcleaseName').show();
			                                }
                                            gradeComboStore.load({
                                                params: {
                                                    CustId: Ext.getCmp('custcomboId').getValue(),
                                                    permitID: Ext.getCmp('permitcomboId').getValue(),
                                                    permitNo: Ext.getCmp('permitcomboId').getRawValue(),
                                                    srcType : srcType
                                                },
                                                callback : function(){
                                                	if(gradeComboStore !=null && gradeComboStore.getAt(0)!=null && gradeComboStore.getAt(1)==null){
                                                		var rec = gradeComboStore.getAt(0);
                                                		Ext.getCmp('gradeAndMineralscomboId').setValue(rec.data['gradeName']);
                                                	}
                                                }
                                            });
                                            tripsheetLimitStore.load({
						                        params: {
						                            custId: Ext.getCmp('custcomboId').getValue(),
						                            routeId: routeId
						                        },
						                        callback: function() {
						                            var row1 = tripsheetLimitStore.findExact('id', '1');
						                            var rec1 = tripsheetLimitStore.getAt(row1);
						                            var tripsheetLimit = rec1.data['tripsheetLimit'];
						                            var tripsheetCount = rec1.data['tripsheetCount'];
						
						                            Ext.getCmp('tripsheetLimitTxtId').setValue(parseInt(tripsheetLimit));
						                            Ext.getCmp('tripsheetBalLimitTxtId').setValue(parseInt(tripsheetLimit) - parseInt(tripsheetCount));
						                            if (parseInt(tripsheetCount) >= parseInt(tripsheetLimit)) {
						                                Ext.MessageBox.show({
						                                    msg: 'Route trip sheet limit is exceeded for this Route',
						                                    buttons: Ext.MessageBox.OK
						                                });
						                                return;
						                            }
						                        }
						                    });
                                        }
                                    }
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
                                    load: function(custstore, records, success, options) {
                                        if (<%= customerId %> > 0) {
                                            Ext.getCmp('custcomboId').setValue('<%=customerId%>');
                                            var cm = grid.getColumnModel();
                                            for (var j = 1; j < cm.getColumnCount(); j++) {
                                                cm.setColumnWidth(j, 170);
                                            }
                                            permitNoComboStore.load({
                                                params: {
                                                    CustID: Ext.getCmp('custcomboId').getValue()
                                                }
                                            });
                                            timeStore.load({
			                                params: {
			                                        CustID: Ext.getCmp('custcomboId').getValue()
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
                                                        closingType=rec.data['closingType'];
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
                                            permitNoComboStore.load({
                                                params: {
                                                    CustID: Ext.getCmp('custcomboId').getValue()
                                                }
                                            });
                                            timeStore.load({
			                                params: {
			                                        CustID: Ext.getCmp('custcomboId').getValue()
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
                                                        closingType=rec.data['closingType'];
                                                    }
                                                }
                                            });
                                        }
                                    }
                                }
                            });
							var tripTranferVehiclesStore = new Ext.data.JsonStore({
                                url: '<%=request.getContextPath()%>/TripSheetGenerationAction.do?param=getVehicleListForTripTransfer',
                                id: 'tripTranferVehiclesStoreId',
                                root: 'tripTranferVehiclesRoot',
                                autoload: false,
                                remoteSort: true,
                                fields: ['tripNo','vehicleName','tripSheetNo']
                            });
                            var existingVehicleCombo = new Ext.form.ComboBox({
                                store: tripTranferVehiclesStore,
                                id: 'extVehiclecomboId',
                                mode: 'local',
                                forceSelection: true,
                                selectOnFocus: true,
                                resizable: true,
                                anyMatch: true,
                                typeAhead: false,
                                listWidth: 150,
                                triggerAction: 'all',
                                lazyRender: true,
                                valueField: 'vehicleName',
                                displayField: 'vehicleName',
                                cls: 'selectstylePerfect',
                                emptyText: '<%=selectVehicleNO%>',
                                blankText: '<%=selectVehicleNO%>',
                                listeners: {
                                    select: {
                                        fn: function() {
                                            var ExtVehicleNo = Ext.getCmp('extVehiclecomboId').getValue();
                                            var row = tripTranferVehiclesStore.findExact('vehicleName', ExtVehicleNo);
                                            var rec = tripTranferVehiclesStore.getAt(row);
                                            tripSheetNo = rec.data['tripSheetNo'];
                                            tripId = rec.data['tripNo'];
                                            Ext.getCmp('tripsheetNoId').setValue(tripSheetNo);
                                        }
                                    }
                                }
                            });
                            var bargeTripComboStore = new Ext.data.JsonStore({
                                url: '<%=request.getContextPath()%>/TripSheetGenerationAction.do?param=getBargeTripNo',
                                id: 'bargeTripNoStoreId',
                                root: 'bargeStoreroot',
                                autoload: false,
                                remoteSort: true,
                                fields: ['id','tripNo','bargeStatus','bargeQty','bargeCapacity','assetNo']
                            });
                             var bargeTripCombo = new Ext.form.ComboBox({
                                store: bargeTripComboStore,
                                id: 'bargeTripComboId',
                                mode: 'local',
                                forceSelection: true,
                                selectOnFocus: true,
                                resizable: true,
                                anyMatch: true,
                                typeAhead: false,
                                listWidth: 150,
                                triggerAction: 'all',
                                lazyRender: true,
                                valueField: 'id',
                                displayField: 'tripNo',
                                cls: 'selectstylePerfect',
                                emptyText: 'Select Barge TripNo',
                                blankText: 'Select Barge TripNo',
                                listeners: {
                                    select: {
                                        fn: function() {
                                        	var id = Ext.getCmp('bargeTripComboId').getValue();
							                var row = bargeTripComboStore.findExact('id', id);
							                var rec = bargeTripComboStore.getAt(row);
							                asetNo = rec.data['assetNo'];
							                Ext.getCmp('bargeanmeIdd').setValue(asetNo);
                                        }
                                    }
                                }
                            });
                            
                             var statusstore = new Ext.data.SimpleStore({
							     id: 'statusStoreId',
							     fields: ['Name', 'Value'],
							     autoLoad: false,
							     data: [
							     	 ['All', 'All'],
							         ['Open', 'Open'],
							         ['Close', 'Close'],
							         ['Others', 'Others']
							     ]
							 });
							 var statusCombo = new Ext.form.ComboBox({
							     store: statusstore,
							     id: 'statuscomboId',
							     mode: 'local',
							     forceSelection: true,
							     emptyText: 'Select Status',
							     resizable: true,
							     selectOnFocus: true,
							     allowBlank: false,
							     anyMatch: true,
							     typeAhead: false,
							     triggerAction: 'all',
							     lazyRender: true,
							     valueField: 'Value',
							     displayField: 'Name',
							     value:'Open',
							     cls: 'selectstylePerfectnew',
							     listeners: {
							         select: {
							             fn: function() {}
							         }
							     }
							 });
                            var tripsheetLimitStore = new Ext.data.JsonStore({
						        url: '<%=request.getContextPath()%>/TripSheetGenerationAction.do?param=getTripsheetLimit',
						        id: 'tripsheetLimitId',
						        root: 'tripsheetLimitRoot',
						        autoload: false,
						        remoteSort: true,
						        fields: ['id', 'tripsheetLimit', 'tripsheetCount']
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
                                    name: 'OrderIndex'
                                }, {
                                    name: 'uniqueIDIndex'
                                }, {
                                    name: 'tcLeaseNoIndexId'
                                }, {
                                    name: 'orgNameIndex'
                                }, {
                                    name: 'RouteIndexId'
                                },{
                                    name: 'wbsIndex'
                                }, {
                                    name: 'statusIndexId'
                                }, {
                                    name: 'q1IndexId'
                                }, {
                                    name: 'QuantityIndex'
                                }, {
                                    name: 'netIndexId'
                                }, {
                                    name: 'typedestIndex'
                                }, {
                                    name: 'q2IndexId'
                                }, {
                                    name: 'q3IndexId'
                                },{
                                    name: 'netWghtDestIndex'
                                },{
                                    name: 'wbdIndex'
                                },{
                                    name: 'diffBtwWeight'
                                },{
                                    name: 'closingTypeDataIndex'
                                }, {
                                    name: 'actualQtyIndexId'
                                }, {
                                    name: 'permitIndexId'
                                }, {
                                	name: 'mineralTypeIndexId'
                                }, {
                                    name: 'pIdIndexId'
                                }, {
                                    name: 'issuedIndexId'
                                }, {
                                    name: 'closedDateIndexId'
                                },{
                                    name: 'dsSourceIndex'
                                },{
                                    name: 'dsdestIndex'
                                },{
                                    name: 'transactnIndex'
                                },{
                                    name: 'commStatus'
                                },{
                                    name: 'reasonIndex'
                                },{
                                	name: 'isClosableIndexId'
                                },{
                                	name: 'issuedBy'
                                },{
                                	name: 'lastCommDateIndex'
                                },{
                                	name: 'lastCommLocIndex'
                                },{
                                	name: 'lastCommDateClosingIndex'
                                },{
                                	name: 'lastCommLocClosingIndex'
                                }]
                            });

                            // **********************************************Reader configs Ends******************************
                            //********************************************Store Configs For Grid*************************

                            var store = new Ext.data.GroupingStore({
                                autoLoad: false,
                                proxy: new Ext.data.HttpProxy({
                                    url: '<%=request.getContextPath()%>/TripSheetGenerationAction.do?param=getMiningTripSheetDetails',
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
                                    dataIndex: 'OrderIndex'
                                },{
                                    type: 'string',
                                    dataIndex: 'wbsIndex'
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
                                },{
                                    type: 'string',
                                    dataIndex: 'typedestIndex'
                                }, {
                                    type: 'string',
                                    dataIndex: 'q2IndexId'
                                }, {
                                    type: 'string',
                                    dataIndex: 'q3IndexId'
                                },{
                                    type: 'float',
                                    dataIndex: 'netWghtDestIndex'
                                },{
                                    type: 'string',
                                    dataIndex: 'wbdIndex'
                                },{
                                    type: 'string',
                                    dataIndex: 'diffBtwWeight'
                                },{
                                    type: 'string',
                                    dataIndex: 'closingTypeDataIndex'
                                }, {
                                    type: 'float',
                                    dataIndex: 'actualQtyIndexId'
                                }, {
                                    type: 'int',
                                    dataIndex: 'permitIndexId'
                                }, {
                                	type: 'string',
                                	dataIndex: 'mineralTypeIndexId'
                                }, {
                                    type: 'string',
                                    dataIndex: 'issuedIndexId'
                                }, {
                                    type: 'date',
                                    dataIndex: 'closedDateIndexId'
                                },{
                                    type: 'string',
                                    dataIndex: 'dsSourceIndex'
                                },{
                                    type: 'string',
                                    dataIndex: 'dsdestIndex'
                                },{
                                    type: 'string',
                                    dataIndex: 'transactnIndex'
                                },{
                                    type: 'string',
                                    dataIndex: 'commStatus'
                                },{
                                    type: 'string',
                                    dataIndex: 'reasonIndex'
                                },{
                                    type: 'string',
                                    dataIndex: 'lastCommDateIndex'
                                },{
                                    type: 'string',
                                    dataIndex: 'lastCommLocIndex'
                                },{
                                    type: 'string',
                                    dataIndex: 'lastCommDateClosingIndex'
                                },{
                                    type: 'string',
                                    dataIndex: 'lastCommLocClosingIndex'
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
                                        header: "<span style=font-weight:bold;>Type @ S</span>",
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
                                        //width: 80,
                                        filter: {
                                            type: 'string'
                                        }
                                    }, {
                                        header: "<span style=font-weight:bold;><%=Organization_Trader_Name%></span>",
                                        dataIndex: 'orgNameIndex',
                                        //width: 80,
                                        filter: {
                                            type: 'string'
                                        }
                                    }, {
                                        header: "<span style=font-weight:bold;>Issued Date Time</span>",
                                        dataIndex: 'issuedIndexId',
                                        filter: {
                                            type: 'string'
                                        }

                                    }, {
                                        header: "<span style=font-weight:bold;><%=ValidityDateTime%></span>",
                                        dataIndex: 'validityDateDataIndex',
                                        renderer: Ext.util.Format.dateRenderer(getDateTimeFormat()),
                                        //width: 80,
                                        filter: {
                                            type: 'date'
                                        }
                                    }, {
                                        header: "<span style=font-weight:bold;>Grade / Type</span>",
                                        dataIndex: 'gradeAndMineralIndex',
                                        //width: 80,
                                        filter: {
                                            type: 'string'
                                        }
                                    }, {
                                        header: "<span style=font-weight:bold;><%=route%></span>",
                                        dataIndex: 'RouteIndex',
                                        //width: 80,
                                        filter: {
                                            type: 'string'
                                        }
                                    }, {
                                        header: "<span style=font-weight:bold;><%=order%></span>",
                                        dataIndex: 'OrderIndex'
                                    }, {
                                        header: "<span style=font-weight:bold;>W B @S</span>",
                                        dataIndex: 'wbsIndex',
                                        // hidden: true,
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
                                        header: "<span style=font-weight:bold;>Tare W @ S</span>",
                                        dataIndex: 'q1IndexId',
                                        sortable: true,
                                        align: 'right',
                                        filter: {
                                            type: 'int'
                                        }
                                    }, {
                                        header: "<span style=font-weight:bold;>Gross W @ S</span>",
                                        dataIndex: 'QuantityIndex',
                                        align: 'right',
                                        sortable: true,
                                        filter: {
                                            type: 'int'
                                        }
                                    }, {
                                        header: "<span style=font-weight:bold;>Net W @ S</span>",
                                        dataIndex: 'netIndexId',
                                        //width: 110,    
                                        sortable: true,
                                        align: 'right',
                                        filter: {
                                            type: 'float'
                                        }
                                    },{
                                        header: "<span style=font-weight:bold;>Type @ D</span>",
                                        dataIndex: 'typedestIndex',
                                        //width: 110,    
                                        //hidden: true,
                                        sortable: true,
                                        //align: 'right',
                                        filter: {
                                            type: 'string'
                                        }
                                    }, {
                                        header: "<span style=font-weight:bold;>Gross W @ D</span>",
                                        dataIndex: 'q2IndexId',
                                        //width: 80,
                                        align: 'right',
                                        filter: {
                                            type: 'string'
                                        }
                                    }, {
                                        header: "<span style=font-weight:bold;>Tare  W @ D</span>",
                                        dataIndex: 'q3IndexId',
                                        //width: 80,
                                        align: 'right',
                                        filter: {
                                            type: 'string'
                                        }
                                    }, {
                                        header: "<span style=font-weight:bold;>Net  W @ D</span>",
                                        dataIndex: 'netWghtDestIndex',
                                        //width: 80,
                                        align: 'right',
                                        filter: {
                                            type: 'float'
                                        }
                                    },{
                                        header: "<span style=font-weight:bold;>WB @ D</span>",
                                        dataIndex: 'wbdIndex',
                                        //hidden: true,
                                        //align: 'right',
                                        filter: {
                                            type: 'string'
                                        }
                                    },{
                                        header: "<span style=font-weight:bold;>Net weight Difference(Kgs)</span>",
                                        dataIndex: 'diffBtwWeight',
                                        align: 'right',
                                        filter: {
                                            type: 'string'
                                        }
                                    },{
                                        header: "<span style=font-weight:bold;>Closing Type</span>",
                                        dataIndex: 'closingTypeDataIndex',
                                        hidden:true,
                                        filter: {
                                            type: 'string'
                                        }
                                    },{
                                        header: "<span style=font-weight:bold;>Actual Quantity</span>",
                                        dataIndex: 'actualQtyIndexId',
                                        hidden: true,
                                        align: 'right',
                                        filter: {
                                            type: 'float'
                                        }
                                    }, {
                                        header: "<span style=font-weight:bold;>Permit Id</span>",
                                        dataIndex: 'permitIndexId',
                                        hidden: true,
                                        filter: {
                                            type: 'int'
                                        }
                                    }, {
                                        header: "<span style=font-weight:bold;>Mineral Type</span>",
                                        dataIndex: 'mineralTypeIndexId',
                                    }, {
                                        header: "<span style=font-weight:bold;>Closed DateTime</span>",
                                        dataIndex: 'closedDateIndexId',
                                        hidden: false,
                                        filter: {
                                            type: 'date'
                                        }

                                    },{
                                        header: "<span style=font-weight:bold;>Source Storage Location</span>",
                                        dataIndex: 'dsSourceIndex',
                                        hidden: false,
                                        filter: {
                                            type: 'string'
                                        }

                                    },{
                                        header: "<span style=font-weight:bold;>Destination Storage Location</span>",
                                        dataIndex: 'dsdestIndex',
                                        hidden: false,
                                        filter: {
                                            type: 'string'
                                        }

                                    },{
                                        header: "<span style=font-weight:bold;>Transaction No</span>",
                                        dataIndex: 'transactnIndex',
                                        hidden: false,
                                        filter: {
                                            type: 'string'
                                        }
                                    },{
                                        header: "<span style=font-weight:bold;>Communicating Status</span>",
                                        dataIndex: 'commStatus',
                                        hidden: false,
                                        filter: {
                                            type: 'string'
                                        }
                                    },{
                                        header: "<span style=font-weight:bold;>Trip Transfer Reason</span>",
                                        dataIndex: 'reasonIndex',
                                        hidden: true,
                                        filter: {
                                            type: 'string'
                                        }
                                    },{
                                        header: "<span style=font-weight:bold;>Opening Datetime</span>",
                                        dataIndex: 'lastCommDateIndex',
                                    }, {
                                        header: "<span style=font-weight:bold;>Opening Location</span>",
                                        dataIndex: 'lastCommLocIndex',
                                    }, {
                                        header: "<span style=font-weight:bold;>Closing Datetime</span>",
                                        dataIndex: 'lastCommDateClosingIndex',
                                    }, {
                                        header: "<span style=font-weight:bold;>Closing Location</span>",
                                        dataIndex: 'lastCommLocClosingIndex',
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

                            grid = getGrid('<%=MiningTripSheetGeneration%>', '<%=noRecordsFound%>', store, screen.width - 57, 420, 50, filters, 'Clear Filter Data', false, '', 20, false, '', <%=tripTransfer%>, 'Transfer Trip', false, 'Excel', jspName, exportDataType, false, 'PDF', <%=addButton%>, 'Add', <%=modifyButton%>, 'Modify', <%=cancel%>, 'Cancel', true, 'Manual Close', <%=destWeight%>, 'Destination Weight', <%=closetrip%>, 'Close Trip',true,'Barge Trip Transfer');
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
                                    columns: 16
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
                                        width: 25
                                    }, {
                                        xtype: 'label',
                                        text: 'Status' + ' :',
                                        cls: 'labelstyle',
                                        id: 'statusLab'
                                    },{width:20},
                                    statusCombo, {
                                        width: 30
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
                                                Ext.example.msg("Difference between two dates should not be greater than 7 days.");
                                                Ext.getCmp('startdate').focus();
                                                return;
                                            }
                                            if (Ext.getCmp('statuscomboId').getValue() == "") {
                                                Ext.example.msg("Select Status");
                                                Ext.getCmp('statuscomboId').focus();
                                                return;
                                            }
                                            store.load({
                                                params: {
                                                    CustID: Ext.getCmp('custcomboId').getValue(),
                                                    jspName: jspName,
                                                    CustName: Ext.getCmp('custcomboId').getRawValue(),
                                                    endDate: Ext.getCmp('enddate').getValue(),
                                                    startDate: Ext.getCmp('startdate').getValue(),
                                                    status: Ext.getCmp('statuscomboId').getValue()
                                                }
                                            });



                                        }
                                    }
                                ]
                            });

                            //------------------------------------------------------------------------//	    
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

                            var detailsFirstPanelForTare = new Ext.Panel({
                                standardSubmit: true,
                                collapsible: false,
                                id: 'detailsFirstMasterTare',
                                layout: 'table',
                                frame: false,
                                border: false,
                                height: 50,
                                width: 433,
                                layoutConfig: {
                                    columns: 5
                                },
                                items: [{
                                    xtype: 'label',
                                    text: '*',
                                    cls: 'mandatoryfield',
                                    id: 'mandatoryTypeIdtare'
                                }, {
                                    xtype: 'label',
                                    text: 'Type' + ' :',
                                    cls: 'labelstyle',
                                    id: 'typeNamelabTare'
                                }, {
                                    width: 82
                                }, typecomboforTare, {
                                    xtype: 'label',
                                    text: '',
                                    cls: 'mandatoryfield',
                                    id: 'mandatoryTypeidTare'
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
                                                            if(data.indexOf('RSSOURCE') >=0 || data.indexOf('RSDESTINATION')>=0 || data.indexOf('TRANSACTION_NO')>=0){  
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
                                                                rsSource="";
	                                                            rsDestination="";
	                                                            transactionNo="";
                                                            }
                                                            console.log(RFIDValue+','+rsSource+','+rsDestination+','+transactionNo);
                                                            tripStoreForRfidAdd.load({
                                                                params: {
                                                                    CustID: Ext.getCmp('custcomboId').getValue(),
                                                                    RFIDValue: RFIDValue
                                                                },
                                                                callback: function() {
                                                                    for (var i = 0; i < tripStoreForRfidAdd.getCount(); i++) {
                                                                        var rec = tripStoreForRfidAdd.getAt(i);
                                                                        var vehicleName = rec.data['jsonString'];
                                                                        quantity1 = rec.data['quantity1'];
																		loadcapacity = rec.data['loadcapacity'];
																		incExpStatusRFID = rec.data['incExpStatus'];
                                            							pucExpStatusRFID= rec.data['pucExpStatus'];
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
                                                                        if(incExpStatusRFID=='False'){
							                                               Ext.MessageBox.show({
													                         msg: 'Insurance expired.Please renew for trip sheet allocation',
													                         buttons: Ext.MessageBox.OK
													                       });
													                       Ext.getCmp('vehiclecomboId').reset();
							                                               Ext.getCmp('RFIDId').reset();
                                                                           Ext.getCmp('tarequantityId').reset();
										                                   return;
							                                            }
							                                            if(pucExpStatusRFID=='False'){
								                                           Ext.MessageBox.show({
													                         msg: 'PUC expired.Please renew for trip sheet allocation.',
													                         buttons: Ext.MessageBox.OK
													                       });
							                                               Ext.getCmp('vehiclecomboId').reset();
							                                               Ext.getCmp('RFIDId').reset();
                                                                           Ext.getCmp('tarequantityId').reset();
										                                   return;
							                                            }
                                                                    }
                                                                }

                                                            });
                                                        },
                                                        error: function() {
                                                            Ext.example.msg("<%=SomethingWronginRFID%>");
                                                        }
                                                    });
                                                } //fun
                                        } //click
                                    } //listeners
                                }]
                            });

                            var vehicleRFIDPanelForTare = new Ext.Panel({
                                id: 'vehicleRFIDPanelIdTare',
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
                                    id: 'mandatoryVehicleIdT'
                                }, {
                                    xtype: 'label',
                                    text: '<%=VehicleNo%>' + ' :',
                                    cls: 'labelstyle',
                                    id: 'VehicleNoIDT'
                                }, {
                                    width: 48
                                }, vehicleComboForTare, {
                                    width: 20
                                }, {
                                    xtype: 'label',
                                    text: '',
                                    cls: 'mandatoryfield',
                                    id: 'mandatoryVehicleNoIdT'
                                }, {
                                    xtype: 'label',
                                    text: '*',
                                    cls: 'mandatoryfield',
                                    id: 'mandatoryRfidT'
                                }, {
                                    xtype: 'label',
                                    text: '<%=VehicleNo%>:',
                                    cls: 'labelstyle',
                                    id: 'RFIDIDsT'
                                }, {
                                    width: 52
                                }, {
                                    xtype: 'textfield',
                                    cls: 'selectstylePerfect',
                                    emptyText: '<%=EnterVehicleNo%>',
                                    allowBlank: false,
                                    readOnly: true,
                                    blankText: '<%=EnterVehicleNo%>',
                                    id: 'RFIDIdT'
                                }, {
                                    width: 20
                                }, {
                                    xtype: 'button',
                                    text: '<%=ReadRFID%>',
                                    width: 80,
                                    id: 'RFIDButtIdT',
                                    cls: 'buttonstyle',
                                    listeners: {
                                        click: {
                                            fn: function() {
                                                    var RFIDValue;
                                                    $.ajax({
                                                        type: "GET",
                                                        url: '<%=RFIDwebServicePath%>',
                                                        success: function(data) {
                                                        if(data.indexOf('RSSOURCE') >=0|| data.indexOf('RSDESTINATION')>=0 || data.indexOf('TRANSACTION_NO')>=0){  
                                                           split1=data.split('RSSOURCE');
	                                                       RFIDValue1 = split1[0].split('==');
	                                                       RFIDValue=RFIDValue1[1];
                                                        }else{
                                                          RFIDValue = data;
                                                        }
                                                            tripStoreForRfid.load({
                                                                params: {
                                                                    CustID: Ext.getCmp('custcomboId').getValue(),
                                                                    RFIDValue: RFIDValue,
                                                                    buttonValue: buttonValue,
                                                                    desHubid: desHubId
                                                                },
                                                                callback: function() {
                                                                    for (var i = 0; i < tripStoreForRfid.getCount(); i++) {
                                                                        var rec = tripStoreForRfid.getAt(i);
                                                                        var vehicleName = rec.data['jsonString'];
                                                                        var lesse = rec.data['lesseName'];
                                                                        var trip1 = rec.data['routeName'];
                                                                        var grade = rec.data['grade'];
                                                                        var validity = rec.data['validityDate'];
                                                                        var rfidorgName = rec.data['orgName'];
                                                                        grossweightRfid=rec.data['grossWeight'];
                                                                        tareweightRfid=rec.data['tareWeight'];
                                                                        tripNo=rec.data['tripNo'];
                                                                        netweightRfid=grossweightRfid-tareweightRfid;
                                                                        grossWeightDestRfid=rec.data['grossWeightDestRfid'];
                                                                        loadcapacityClose=parseFloat(rec.data['loadCapacity']);
                                                                    }
                                                                    if (tripStoreForRfid.getCount() == 0) {
                                                                        Ext.example.msg("<%=SomethingWronginRFID%>");
                                                                        Ext.getCmp('RFIDIdT').setValue("<%=EnterVehicleNo%>");
                                                                    } else {
                                                                        Ext.getCmp('RFIDIdT').setValue(vehicleName);
                                                                        Ext.getCmp('tcNamecomboIdTare').setValue(lesse);
                                                                        Ext.getCmp('routecomboIdforTare').setValue(trip1);
                                                                        Ext.getCmp('startDateTimeForTare').setValue(validity);
                                                                        Ext.getCmp('gradeAndMineralscomboIdForTare').setValue(grade);
                                                                        Ext.getCmp('orgNamecomboIdTare').setValue(rfidorgName);
									                                    Ext.getCmp('quantityIdC').setValue(grossweightRfid);
									                                    Ext.getCmp('quantityIdC2').setValue(tareweightRfid);
									                                    grossweight=grossweightRfid;
									                                    tareweight=tareweightRfid;
									                                    netweightDest=netweightRfid;
							                                            Ext.getCmp('grossWeight@SId').setText(grossweight);
							                                            Ext.getCmp('tareWeight@SId').setText(tareweight);
							                                            Ext.getCmp('netWeight@SId').setText(netweightDest)
                                                                        if (lesse == '') {
                                                                            Ext.getCmp('mandatoryTcleaseNameT').hide();
                                                                            Ext.getCmp('TcleaseNameIDT').hide();
                                                                            Ext.getCmp('tcNamecomboIdTare').hide();
                                                                            Ext.getCmp('orgNamecomboIdTare').show();
                                                                            Ext.getCmp('TcleaseNameIDT1').show();
                                                                            Ext.getCmp('mandatoryTcleaseNameT1').show();
                                                                        } else {
                                                                            Ext.getCmp('mandatoryTcleaseNameT').show()
                                                                            Ext.getCmp('TcleaseNameIDT').show();
                                                                            Ext.getCmp('tcNamecomboIdTare').show();
                                                                            Ext.getCmp('orgNamecomboIdTare').hide();
                                                                            Ext.getCmp('TcleaseNameIDT1').hide();
                                                                            Ext.getCmp('mandatoryTcleaseNameT1').hide();
                                                                        }
                                                                    }
                                                                }

                                                            });
                                                        },
                                                        error: function() {
                                                            Ext.example.msg("<%=SomethingWronginRFID%>");
                                                        }
                                                    });
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
                                height: 300,
                                width: 500,
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
                                    id: 'mandatoryTripsheetNumber'
                                }, {
                                    xtype: 'label',
                                    text: '',
                                    cls: 'mandatoryfield',
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
                                    //cls: 'mandatoryfield',
                                    id: 'mandatoryvalidityDateId'
                                }, {
                                    xtype: 'label',
                                    text: '',
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
                                }, permitCombo, {
                                    xtype: 'label',
                                    text: '',
                                    cls: 'mandatoryfield',
                                    id: 'mandatoryperId2'
                                }, {
                                    xtype: 'label',
                                    text: '',
                                    cls: 'mandatoryfield',
                                    id: 'mandatoryperId12'
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
                                    cls: 'mandatoryfield',
                                    id: 'mandatoryTcleaseNameId'
                                }, {
                                    xtype: 'label',
                                    text: '',
                                    cls: 'mandatoryfield',
                                    id: 'mandatoryTripsheetNumber155d1'
                                }, {
                                    xtype: 'label',
                                    text: '*',
                                    cls: 'mandatoryfield',
                                    id: 'mandatoryTcleaseName12'
                                }, {
                                    xtype: 'label',
                                    text: '<%=Organization_Trader_Name%>' + ' :',
                                    cls: 'labelstyle',
                                    id: 'OrgNameNameID'
                                }, {
                                    xtype: 'textfield',
                                    //width: 139,
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
                                    id: 'mandatoryGradeId'
                                }, {
                                    xtype: 'label',
                                    text: '<%=GradeAndMineral%>' + ' :',
                                    cls: 'labelstyle',
                                    id: 'gradeAndMineralsID'
                                }, gradeAndMineralsCombo, {
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
                                    id: 'mandatoryRouteId2'
                                }, {
                                    xtype: 'label',
                                    text: '<%=route%>' + ' :',
                                    cls: 'labelstyle',
                                    id: 'RouteID'
                                }, {
                                    xtype: 'textarea',
                                    width: 210,
                                     height: 40,
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
                                    text: '',
                                    cls: 'mandatoryfield',
                                    id: 'mandatoryOrder'
                                }, {
                                    xtype: 'label',
                                    text: '<%=order%>' + ' :',
                                    cls: 'labelstyle',
                                    id: 'OrderLabId'
                                }, {
                                    xtype: 'textfield',
                                    //width: 139,
                                    cls: 'selectstylePerfect',
                                    listeners: { change: function(f,n,o){ //restrict 50
									 if(f.getValue().length> 50){ Ext.example.msg("Field exceeded it's Maximum length"); 
										f.setValue(n.substr(0,50)); f.focus(); }
									} },
                                    id: 'orderId'
                                }, {
                                    xtype: 'label',
                                    text: '',
                                    cls: 'mandatoryfield',
                                    id: 'orderId1'
                                }, {
                                    xtype: 'label',
                                    text: '',
                                    cls: 'mandatoryfield',
                                    id: 'orderId2'
                                }]
                            });

                            var detailsSecondPanelForTare = new Ext.Panel({
                                standardSubmit: true,
                                collapsible: false,
                                id: 'detailsSecondMasterT',
                                layout: 'table',
                                frame: false,
                                height: 322,
                                width: 450,
                                layoutConfig: {
                                    columns: 5
                                },
                                items: [{
                                    xtype: 'label',
                                    text: ' ',
                                    cls: 'labelstyle',
                                    id: 'tripsheetNumberLabel55T'
                                }, {
                                    xtype: 'label',
                                    cls: 'selectstylePerfect',
                                    emptyText: '',
                                    blankText: '',
                                    id: 'enrollNumberId55T',
                                }, {
                                    xtype: 'label',
                                    text: '',
                                    cls: 'mandatoryfield',
                                    id: 'mandatoryTripsheetNumber55T'
                                }, {
                                    xtype: 'label',
                                    text: '',
                                    cls: 'mandatoryfield',
                                    id: 'mandatoryTripsheetNumber1554T'
                                }, {
                                    xtype: 'label',
                                    text: '',
                                    cls: 'mandatoryfield',
                                    id: 'mandatoryTripsheetNumber155dT'
                                }, {
                                    xtype: 'label',
                                    text: '*',
                                    cls: 'mandatoryfield',
                                    id: 'mandatoryTcleaseNameT'
                                }, {
                                    xtype: 'label',
                                    text: '<%=TCLeaseName%>' + ' :',
                                    cls: 'labelstyle',
                                    id: 'TcleaseNameIDT'
                                }, {
                                    xtype: 'textfield',
                                    width: 139,
                                    cls: 'selectstylePerfect',
                                    emptyText: '',
                                    allowBlank: false,
                                    readOnly: true,
                                    blankText: '',
                                    id: 'tcNamecomboIdTare'
                                }, {
                                    xtype: 'label',
                                    text: '',
                                    cls: 'mandatoryfield',
                                    id: 'mandatoryTcleaseNameIdT'
                                }, {
                                    xtype: 'label',
                                    text: '',
                                    cls: 'mandatoryfield',
                                    id: 'mandatoryTcleaseNameId1T'
                                }, {
                                    xtype: 'label',
                                    text: ' ',
                                    cls: 'mandatoryfield',
                                    id: 'mandatoryTcleaseName55T'
                                }, {
                                    xtype: 'label',
                                    text: ' ',
                                    cls: 'labelstyle',
                                    id: 'TcleaseNameID55T'
                                }, {
                                    xtype: 'label',
                                    text: '',
                                    cls: 'mandatoryfield',
                                    id: 'mandatoryTcleaseNameId55T'
                                }, {
                                    xtype: 'label',
                                    text: '',
                                    cls: 'mandatoryfield',
                                    id: 'mandatoryTcleaseNameId45T'
                                }, {
                                    xtype: 'label',
                                    text: '',
                                    cls: 'mandatoryfield',
                                    id: 'mandatoryTcleaseNameId177T'
                                }, {
                                    xtype: 'label',
                                    text: '*',
                                    cls: 'mandatoryfield',
                                    id: 'mandatoryTcleaseNameT1'
                                }, {
                                    xtype: 'label',
                                    text: '<%=Organization_Trader_Name%>' + ' :',
                                    cls: 'labelstyle',
                                    id: 'TcleaseNameIDT1'
                                }, {
                                    xtype: 'textfield',
                                    width: 139,
                                    cls: 'selectstylePerfect',
                                    emptyText: '',
                                    allowBlank: false,
                                    readOnly: true,
                                    blankText: '',
                                    id: 'orgNamecomboIdTare'
                                }, {
                                    xtype: 'label',
                                    text: '',
                                    cls: 'mandatoryfield',
                                    id: 'mandatoryTcleaseNameIdT1'
                                }, {
                                    xtype: 'label',
                                    text: '',
                                    cls: 'mandatoryfield',
                                    id: 'mandatoryTcleaseNameId1T1'
                                }, {
                                    xtype: 'label',
                                    text: ' ',
                                    cls: 'mandatoryfield',
                                    id: 'mandatoryTcleaseName55T1'
                                }, {
                                    xtype: 'label',
                                    text: ' ',
                                    cls: 'labelstyle',
                                    id: 'TcleaseNameID55T1'
                                }, {
                                    xtype: 'label',
                                    text: '',
                                    cls: 'mandatoryfield',
                                    id: 'mandatoryTcleaseNameId55T1'
                                }, {
                                    xtype: 'label',
                                    text: '',
                                    cls: 'mandatoryfield',
                                    id: 'mandatoryTcleaseNameId45T1'
                                }, {
                                    xtype: 'label',
                                    text: '',
                                    cls: 'mandatoryfield',
                                    id: 'mandatoryTcleaseNameId177T1'
                                }, {
                                    xtype: 'label',
                                    text: '*',
                                    cls: 'mandatoryfield',
                                    id: 'mandatorydateValidityDateTimeT'
                                }, {
                                    xtype: 'label',
                                    text: '<%=ValidityDateTime%>' + '  :',
                                    cls: 'labelstyle',
                                    id: 'validitydateTimeLabelIdT'
                                }, StartDateForTare, {
                                    xtype: 'label',
                                    text: '',
                                    cls: 'mandatoryfield',
                                    id: 'mandatoryvalidityDateIdT'
                                }, {
                                    xtype: 'label',
                                    text: '',
                                    cls: 'mandatoryfield',
                                    id: 'mandatoryvalidityDateId1T'
                                }, {
                                    xtype: 'label',
                                    text: '*',
                                    cls: 'mandatoryfield',
                                    id: 'mandatoryGradeIdT'
                                }, {
                                    xtype: 'label',
                                    text: '<%=GradeAndMineral%>' + ' :',
                                    cls: 'labelstyle',
                                    id: 'gradeAndMineralsIDT'
                                }, {
                                    xtype: 'textfield',
                                    width: 139,
                                    cls: 'selectstylePerfect',
                                    emptyText: '',
                                    allowBlank: false,
                                    readOnly: true,
                                    blankText: '',
                                    id: 'gradeAndMineralscomboIdForTare'
                                }, {
                                    xtype: 'label',
                                    text: '',
                                    cls: 'mandatoryfield',
                                    id: 'mandatoryGradeInforIdT'
                                }, {
                                    xtype: 'label',
                                    text: '',
                                    cls: 'mandatoryfield',
                                    id: 'mandatoryGradeInforId1T'
                                },{
                                    xtype: 'label',
                                    text: '*',
                                    cls: 'mandatoryfield',
                                    id: 'mandatoryRouteId2T'
                                }, {
                                    xtype: 'label',
                                    text: '<%=route%>' + ' :',
                                    cls: 'labelstyle',
                                    id: 'RouteIDT'
                                }, {
                                    xtype: 'textfield',
                                     height: 40,
                                    width: 210,
                                    cls: 'selectstylePerfect',
                                    emptyText: '',
                                    allowBlank: false,
                                    readOnly: true,
                                    blankText: '',
                                    id: 'routecomboIdforTare'
                                }, {
                                    xtype: 'label',
                                    text: '',
                                    cls: 'mandatoryfield',
                                    id: 'mandatoryRouteIdT'
                                }, {
                                    xtype: 'label',
                                    text: '',
                                    cls: 'mandatoryfield',
                                    id: 'mandatoryRouteId1T'
                                }, {
                                    xtype: 'label',
                                    text: '*',
                                    cls: 'mandatoryfield',
                                    id: 'mandatoryreasonId'
                                }, {
                                    xtype: 'label',
                                    text: 'Reason' + ' :',
                                    cls: 'labelstyle',
                                    id: 'ReasnLabel'
                                }, reasoncombo, {
                                    xtype: 'label',
                                    text: '',
                                    cls: 'mandatoryfield',
                                    id: 'mandatoryreasonIdT'
                                }, {
                                    xtype: 'label',
                                    text: '',
                                    cls: 'mandatoryfield',
                                    id: 'mandatoryrsnId1T'
                                },{width:10,height:10},{width:10},{width:10},{width:10},{width:10},{
                                    xtype: 'label',
                                    text: '*',
                                    cls: 'mandatoryfield',
                                    id: 'man9'
                                }, {
                                    xtype: 'label',
                                    text: 'Gross Weight@S' + ' :',
                                    cls: 'my-label-style2-1',
                                    id: 'labelGw@s'
                                }, {
                                    xtype: 'label',
                                    text: '',
                                    cls: 'my-label-style2-1',
                                    id: 'grossWeight@SId'
                                }, {
                                    xtype: 'label',
                                    text: 'kgs',
                                    cls: 'labelstyle',
                                    id: 'man8'
                                }, {
                                    xtype: 'label',
                                    text: '',
                                    cls: 'mandatoryfield',
                                    id: 'man7'
                                },{width:10,height:10},{width:10},{width:10},{width:10},{width:10},{
                                    xtype: 'label',
                                    text: '*',
                                    cls: 'mandatoryfield',
                                    id: 'man6'
                                }, {
                                    xtype: 'label',
                                    text: 'Tare Weight@S' + ' :',
                                    cls: 'my-label-style2-1',
                                    id: 'labelTw@s'
                                }, {
                                    xtype: 'label',
                                    text: '',
                                    cls: 'my-label-style2-1',
                                    id: 'tareWeight@SId'
                                }, {
                                    xtype: 'label',
                                    text: 'kgs',
                                    cls: 'labelstyle',
                                    id: 'man5'
                                }, {
                                    xtype: 'label',
                                    text: '',
                                    cls: 'mandatoryfield',
                                    id: 'man4'
                                },{width:10,height:10},{width:10},{width:10},{width:10},{width:10},{
                                    xtype: 'label',
                                    text: '*',
                                    cls: 'mandatoryfield',
                                    id: 'man3'
                                }, {
                                    xtype: 'label',
                                    text: 'Net Weight@S' + ' :',
                                    cls: 'my-label-style2-1',
                                    id: 'labelNw@s'
                                }, {
                                    xtype: 'label',
                                    text: '',
                                    cls: 'my-label-style2-1',
                                    id: 'netWeight@SId'
                                }, {
                                    xtype: 'label',
                                    text: 'kgs',
                                    cls: 'labelstyle',
                                    id: 'man2'
                                }, {
                                    xtype: 'label',
                                    text: '',
                                    cls: 'mandatoryfield',
                                    id: 'man1'
                                },{width:10,height:10},{width:10},{width:10},{width:10},{width:10},{
                                    xtype: 'label',
                                    text: '*',
                                    cls: 'mandatoryfield',
                                    id: 'man99'
                                }, {
                                    xtype: 'label',
                                    text: 'Trip Sheet No' + ' :',
                                    cls: 'my-label-style2-1',
                                    id: 'labeltripNo'
                                }, {
                                    xtype: 'label',
                                    text: '',
                                    cls: 'my-label-style2-1',
                                    id: 'tripsheetId'
                                }, {
                                    xtype: 'label',
                                    text: '',
                                    cls: 'labelstyle',
                                    id: 'man88'
                                }, {
                                    xtype: 'label',
                                    text: '',
                                    cls: 'mandatoryfield',
                                    id: 'man77'
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
                            var innerThirdfirstPanelForTare = new Ext.Panel({
                                standardSubmit: true,
                                collapsible: false,
                                id: 'innerThirdMasterT',
                                layout: 'table',
                                frame: false,
                                height: 440,
                                width: 233,
                                layoutConfig: {
                                    columns: 2
                                },
                                items: [{
                                    xtype: 'label',
                                    text: '*',
                                    cls: 'mandatoryfield',
                                    id: 'mandatoryQTYIdT'
                                }, {
                                    xtype: 'label',
                                    text: '',
                                    cls: 'my-label-styleT',
                                    id: 'QuantityIDT'
                                },{
                                    xtype: 'textfield',
                                    width: 50,
                                    height: 60,
                                    cls: 'quantityBox',
                                    emptyText: '',
                                    allowBlank: false,
                                    readOnly: true,
                                    blankText: '',
                                    id: 'quantityIdT'
                                }, {
                                    xtype: 'label',
                                    text: '<%=kgs%>',
                                    cls: 'labelstyle',
                                    id: 'kgsIdT'
                                },{
                                    xtype: 'button',
                                    text: '<%=Capture%>',
                                    iconCls: 'capturebutton',
                                    scale: 'large',
                                    name: 'filepath',
                                    id: 'captureWeightIdT',
                                    width: 150,
                                    cls: 'buttonstyle',
                                    listeners: {
                                        click: {
                                            fn: function() {
                                                    var buttonvalue = '<%=CaptureQuantity%>';
                                                    $.ajax({
                                                        type: "GET",
                                                        url: '<%=WEIGHTwebServicePath%>',
                                                        success: function(data) {
															if(data.indexOf('Something is wrong. Please check')<0){
															var netBW;
                                                            	Ext.getCmp('quantityIdT').setValue(data);
                                                            	if(buttonValue=='closetrip'){
                                                            		Ext.getCmp('tareWeight@DId').setValue(grossWeightDest);
                                                            		netBW=grossWeightDest-data;
                                                            		Ext.getCmp('netWeight@DId').setValue(netBW);
                                                            	}else if(buttonValue=='tareWeight'){
                                                            		Ext.getCmp('tareWeight@DId').setValue(tareweight);
                                                            		netBW=data-tareweight;
                                                            		Ext.getCmp('netWeight@DId').setValue(netBW);
                                                            	}
                                                            }
                                                        },
                                                        error: function() {
                                                            Ext.example.msg("<%=SomethingWronginweight%>");
                                                        }
                                                    });
                                                } //fun
                                        } //click
                                    } //listeners
                                },{
                                    width: 10
                                },{
                                    xtype: 'label',
                                    text: '',
                                    cls: 'mandatoryfield',
                                    id: 'mantareWeight@DId'
                                }, {
                                    xtype: 'label',
                                    text: '',
                                    cls: 'my-label-styleT',
                                    id: 'labelTareWeight@DId'
                                },{
                                    xtype: 'textfield',
                                    width: 50,
                                    height: 60,
                                    cls: 'quantityBox',
                                    emptyText: '',
                                    allowBlank: false,
                                    readOnly: true,
                                    blankText: '',
                                    id: 'tareWeight@DId'
                                }, {
                                    xtype: 'label',
                                    text: '<%=kgs%>',
                                    cls: 'labelstyle',
                                    id: 'kgs@TDId'
                                },{
                                    xtype: 'label',
                                    text: '*',
                                    cls: 'mandatoryfield',
                                    id: 'manNetWeight@DId'
                                }, {
                                    xtype: 'label',
                                    text: 'Net Weight @D' + '',
                                    cls: 'my-label-styleT',
                                    id: 'labelNetweight@Did'
                                },{
                                    xtype: 'textfield',
                                    width: 50,
                                    height: 60,
                                    cls: 'quantityBox',
                                    emptyText: '',
                                    allowBlank: false,
                                    readOnly: true,
                                    blankText: '',
                                    id: 'netWeight@DId'
                                }, {
                                    xtype: 'label',
                                    text: '<%=kgs%>',
                                    cls: 'labelstyle',
                                    id: 'kgsNDId'
                                }]
                            });
                            
                            var innerThirdfirstPanelForClose = new Ext.Panel({
                                standardSubmit: true,
                                collapsible: false,
                                id: 'innerThirdMasterC',
                                layout: 'table',
                                frame: false,
                                height: 45,
                                width: 210,
                                layoutConfig: {
                                    columns: 2
                                },
                                items: [{
                                    xtype: 'label',
                                    text: '*',
                                    cls: 'mandatoryfield',
                                    id: 'mandatoryQTYIdC'
                                }, {
                                    xtype: 'label',
                                    text: 'Gross W @ D' + '',
                                    cls: 'my-label-style',
                                    id: 'QuantityIDC'
                                }]
                            });
                            
                            var innerThird2PanelForClose = new Ext.Panel({
                                standardSubmit: true,
                                collapsible: false,
                                id: 'innerThirdMasterC2',
                                layout: 'table',
                                frame: false,
                                height: 45,
                                width: 210,
                                layoutConfig: {
                                    columns: 2
                                },
                                items: [{
                                    xtype: 'label',
                                    text: '*',
                                    cls: 'mandatoryfield',
                                    id: 'mandatoryQTYIdC2'
                                }, {
                                    xtype: 'label',
                                    text: 'Tare W @ D' + '',
                                    cls: 'my-label-style',
                                    id: 'QuantityIDC2'
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

                            var innerThirdSecondPanelForTare = new Ext.Panel({
                                standardSubmit: true,
                                collapsible: false,
                                id: 'innerThirdSecondMasterT',
                                layout: 'table',
                                frame: false,
                                height: 90,
                                width: 210,
                                layoutConfig: {
                                    columns: 3
                                },
                                items: [{
                                    width: 15
                                }]
                            });
                            var innerThirdSecondPanelForClose = new Ext.Panel({
                                standardSubmit: true,
                                collapsible: false,
                                id: 'innerThirdSecondMasterC',
                                layout: 'table',
                                frame: false,
                                height: 90,
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
                                    id: 'quantityIdC'
                                }, {
                                    xtype: 'label',
                                    text: '<%=kgs%>',
                                    cls: 'labelstyle',
                                    id: 'kgsIdC'
                                }]
                            });
                            var innerThirdSecond2PanelForClose = new Ext.Panel({
                                standardSubmit: true,
                                collapsible: false,
                                id: 'innerThirdSecondMasterC2',
                                layout: 'table',
                                frame: false,
                                height: 90,
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
                                    id: 'quantityIdC2'
                                }, {
                                    xtype: 'label',
                                    text: '<%=kgs%>',
                                    cls: 'labelstyle',
                                    id: 'kgsIdC2'
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
                                    text: '<%=Capture%>',
                                    iconCls: 'capturebutton',
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
															if(data.indexOf('Something is wrong. Please check')<0){
                                                            	Ext.getCmp('quantityId').setValue(data);
                                                            }
                                                        },
                                                        error: function() {
                                                            Ext.example.msg("<%=SomethingWronginweight%>");
                                                        }
                                                    });
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

                            var innerThird3PanelForTare = new Ext.FormPanel({
                                standardSubmit: true,
                                collapsible: false,
                                id: 'innerThird3MasterT',
                                layout: 'table',
                                frame: false,
                                height: 50,
                                width: 210,
                                layoutConfig: {
                                    columns: 2
                                },
                                items: []
                            });
                            
                            var innerThird4PanelForTare = new Ext.Panel({
                                standardSubmit: true,
                                collapsible: false,
                                id: 'innerThird4PanelForTareId',
                                layout: 'table',
                                frame: false,
                                height: 60,
                                width: 210,
                                layoutConfig: {
                                    columns: 4
                                },
                                items: [{
                                    xtype: 'label',
                                    text: 'Net W @ S :',
                                    cls: 'my-label-style2-1',
                                    id: 'NetW@SourceLabId'
                                },{ width: 5 }, {
                                    xtype: 'label',
                                    cls: 'my-label-style2-1',
                                    id: 'NetW@SourceId'
                                },{
                                    xtype: 'label',
                                    text: 'kgs',
                                    hidden: 'true',
                                    cls: 'labelstyle',
                                    id: 'NetW@SourceKgId'
                                }]
                            });

                            var detailsThirdPanel = new Ext.Panel({
                                standardSubmit: true,
                                collapsible: false,
                                id: 'detailsThirdMaster',
                                layout: 'table',
                                frame: true,
                                height: 420,
                                width: 210,
                                layoutConfig: {
                                    columns: 1
                                },
                                items: [innerThirdfirstPanel, innerThirdSecondPanel, innerThird3Panel, innerThirdFifthPanel, innerThirdFifthPanel1, innerThirdSixthPanel, innerThirdSixthPanel1]
                            });

                            var detailsThirdPanelForFare = new Ext.Panel({
                                standardSubmit: true,
                                collapsible: false,
                                id: 'detailsThirdMasterFare',
                                layout: 'table',
                                frame: true,
                                height: 430,
                                width: 240,
                                layoutConfig: {
                                    columns: 1
                                },
                                items: [innerThirdfirstPanelForTare]
                            });
                            
                            var detailsThirdPanelForManualClose = new Ext.Panel({
                                standardSubmit: true,
                                collapsible: false,
                                id: 'detailsThirdMasterclose1',
                                layout: 'table',
                                frame: true,
                                height: 430,
                                width: 210,
                                hidden: true,
                                layoutConfig: {
                                    columns: 1
                                },
                                items: [innerThirdfirstPanelForClose,innerThirdSecondPanelForClose,innerThird2PanelForClose,innerThirdSecond2PanelForClose]
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
                                                if(buttonValue == 'add' && Ext.getCmp('permitcomboId').getValue()==""){ 
	                                                Ext.example.msg("Please Select permit No");
                                                    Ext.getCmp('permitcomboId').focus();
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
                                                if (buttonValue != 'modify') {
                                                var pid=Ext.getCmp('permitcomboId').getValue();
                                                var row = permitNoComboStore.findExact('pId', pid);
	                                            if(row==-1){ 
	                                                Ext.example.msg("Please Select permit No");
	                                                Ext.getCmp('permitcomboId').reset();
                                                    Ext.getCmp('permitcomboId').focus();
                                                    return;
	                                            }
												}
                                                var VehicleNoBaseType = "";
                                                var actualQuantity=0;
                                                var globalClientId = Ext.getCmp('custcomboId').getValue();
                                                var customerName = Ext.getCmp('custcomboId').getRawValue();
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
                                               if ((parseFloat(Ext.getCmp('actualquantityId').getValue()))==0) {
                                                    Ext.example.msg("Net Weight Should not be zero");
                                                    return;
                                                }
                                                if (Ext.getCmp('typecomboId').getValue() == "APPLICATION") {
                                                    rsSource = "",
													rsDestination = "",
													transactionNo = "";
                                                }
                                                if (buttonValue == 'add') {
						                            var row1 = tripsheetLimitStore.findExact('id', '1');
						                            var rec1 = tripsheetLimitStore.getAt(row1);
						                            var tripsheetLimit = rec1.data['tripsheetLimit'];
						                            var tripsheetCount = rec1.data['tripsheetCount'];
						
						                            Ext.getCmp('tripsheetLimitTxtId').setValue(parseInt(tripsheetLimit));
						                            Ext.getCmp('tripsheetBalLimitTxtId').setValue(parseInt(tripsheetLimit) - parseInt(tripsheetCount));
						                            if (parseInt(tripsheetCount) >= parseInt(tripsheetLimit)) {
						                                Ext.MessageBox.show({
						                                    msg: 'Route trip sheet limit is exceeded for this Route',
						                                    buttons: Ext.MessageBox.OK
						                                });
						                                return;
						                            }
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
                                                    if (selected.get('gradeAndMineralIndex') != Ext.getCmp('gradeAndMineralscomboId').getRawValue()) {
                                                        gradeModify = Ext.getCmp('gradeAndMineralscomboId').getRawValue();
                                                    } else {
                                                        gradeModify = selected.get('gradeAndMineralIndex');
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
                                                    if (parseFloat(actQty) > parseFloat(loadcapacity)) {
                                                        Ext.example.msg("Net Quantity is greater than Load capacity of vehicle");
                                                        return;
                                                    }
                                                    var balanceQty = parseFloat(Ext.getCmp('quantityId2b').getValue()) - convertedQty;
                                                    if (balanceQty < 0) {
                                                        Ext.example.msg("Net Quantity is greater than the Permit Balance");
                                                        return;
                                                    } else {
                                                        Ext.getCmp('quantityId2b').setValue(balanceQty);
                                                    }
                                                }
                                                actualQuantity=parseFloat(Ext.getCmp('quantityId').getValue())-parseFloat(quantity1);
                                                myWin.getEl().mask();
                                                //Performs Save Operation
                                                //Ajax request starts here
                                                Ext.Ajax.request({
                                                    url: '<%=request.getContextPath()%>/TripSheetGenerationAction.do?param=saveormodifyGenrateTripSheet',
                                                    method: 'POST',
                                                    params: {
                                                        buttonValue: buttonValue,
                                                        CustID: Ext.getCmp('custcomboId').getValue(),
                                                        type: Ext.getCmp('typecomboId').getValue(),
                                                        vehicleNo: VehicleNoBaseType,
                                                        tcLeaseName: tcId,
                                                        quantity: Ext.getCmp('quantityId').getValue(),
                                                        validityDateTime: Ext.getCmp('startDateTime').getValue(),
                                                        grade: Ext.getCmp('gradeAndMineralscomboId').getRawValue(),
                                                        gradetype: Ext.getCmp('gradeAndMineralscomboId').getRawValue(),
                                                        routeId: routeId,
                                                        order: Ext.getCmp('orderId').getValue(),
                                                        CustName: Ext.getCmp('custcomboId').getRawValue(),
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
                                                        actualQuantity: actualQuantity,
                                                        userSettingId: userSettingId,
                                                        rsSource : rsSource,
														rsDestination : rsDestination,
														transactionNo : transactionNo,
														nonCommHrs:nonCommHrs,
														permitBal : Ext.getCmp('quantityId2b').getValue()
                                                    },
                                                    success: function(response, options) {
                                                        var message = response.responseText;
                                                        Ext.example.msg(message);
                                                        if(buttonValue=='add'){
                                                        if(message=="0"){
                                                           message="Error in Saving Trip Sheet Details";
                                                           Ext.example.msg(message);
                                                        }else if(message=="-1"){
                                                            message="Permit Balance is over or trip exists for vehicle or Permit is disassociated. Please check.";
                                                            Ext.example.msg(message);
                                                        }else if(message>0){
                                                            window.open("<%=request.getContextPath()%>/tripSheetPdf?systemId=" + <%=systemId%> + "&clientId=" + globalClientId + "&clientName=" + customerName + "&vehicleNo=" + VehicleNoBaseType + "&buttonValue=" + buttonValue + "&uniqueId=" + message);
                                                            message="Trip Sheet Details Saved Successfully";
                                                            Ext.example.msg(message);
                                                        }
                                                        }
                                                        if(buttonValue=='modify'){
                                                           if(message=="0"){
                                                           message="Trip Sheet Details is not possible for Modified of this Vehicles";
                                                           Ext.example.msg(message);
                                                        }else if(message>0){
	                                                        window.open("<%=request.getContextPath()%>/tripSheetPdf?systemId=" + <%=systemId%> + "&clientId=" + globalClientId + "&clientName=" + customerName + "&vehicleNo=" + VehicleNoBaseType + "&buttonValue=" + buttonValue + "&uniqueId=" + message);
	                                                        message="Trip Sheet Details Modified Successfully";
                                                            Ext.example.msg(message);
                                                        }
                                                        Ext.getCmp('permitcomboId').setValue('');
                                                        Ext.getCmp('gradeAndMineralscomboId').setValue('');
                                                        }
                                                        if(message== "select valid Operational Type"){
                                                        	Ext.getCmp('typecomboId').reset();
                                                        }
                                                        Ext.getCmp('vehiclecomboId').reset();
                                                        Ext.getCmp('RFIDId').reset();
                                                        //Ext.getCmp('tcNamecomboId').reset();
                                                        Ext.getCmp('quantityId').reset();
                                                        Ext.getCmp('startDateTime').reset();
                                                        myWin.hide();
                                                        myWin.getEl().unmask();
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
                                                                    closingType=rec.data['closingType'];
                                                                }
                                                            }
                                                        });
                                                        permitNoComboStore.load({
                                                            params: {
                                                                CustID: Ext.getCmp('custcomboId').getValue()
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
                                                //Ext.getCmp('typecomboId').setValue('APPLICATION');
                                                vehicleComboStore.load();
                                                $('#vehiclecomboId').val('');
                                                Ext.getCmp('RFIDId').reset();
                                                Ext.getCmp('vehicleRFIDPanelId').hide();
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


                            var winButtonPanelForTare = new Ext.Panel({
                                id: 'winbuttonidforTare',
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
                                    width: 240
                                }, {
                                    xtype: 'button',
                                    text: '<%=Save%>',
                                    id: 'addButtIdForTare',
                                    cls: 'buttonstyle',
                                    iconCls: 'savebutton',
                                    width: 80,
                                    listeners: {
                                        click: {
                                            fn: function() {
                                            	var closeQuantity;
                                                var tareqty;
                                                var grossqty;
                                                if (Ext.getCmp('typecomboIdTare').getValue() == "") {
                                                    Ext.example.msg("<%=selectType%>");
                                                    Ext.getCmp('typecomboIdTare').focus();
                                                    return;
                                                }
                                                if (Ext.getCmp('typecomboIdTare').getValue() == 'RFID') {
                                                    if (Ext.getCmp('RFIDIdT').getValue() == "") {
                                                        Ext.example.msg("<%=selectVehicleNO%>");
                                                        Ext.getCmp('RFIDIdT').focus();
                                                        return;
                                                    }
                                                } else {
                                                    if (Ext.getCmp('vehiclecomboIdTare').getValue() == "") {
                                                        Ext.example.msg("<%=selectVehicleNO%>");
                                                        Ext.getCmp('vehiclecomboIdTare').focus();
                                                        return;
                                                    }
                                                }
                                                if(buttonValue!='manualClose'){
                                                  if (Ext.getCmp('quantityIdT').getValue() == "") {
                                                    Ext.example.msg("<%=enterQuantity%>");
                                                    Ext.getCmp('quantityIdT').focus();
                                                    return;
                                                }
                                                if (parseFloat(Ext.getCmp('quantityIdT').getValue()) == "0") {
                                                    Ext.example.msg("Weight is not captured properly.Recapture and close the trip sheet");
                                                    Ext.getCmp('quantityIdT').focus();
                                                    return;
                                                }
                                                }
                                                if (Ext.getCmp('startDateTimeForTare').getValue() == "") {
                                                    Ext.example.msg("<%=enterValidDateTime%>");
                                                    Ext.getCmp('startDateTimeForTare').focus();
                                                    return;
                                                }
                                                if (Ext.getCmp('gradeAndMineralscomboIdForTare').getValue() == "") {
                                                    Ext.example.msg("<%=enterGradeMinerals%>");
                                                    Ext.getCmp('gradeAndMineralscomboIdForTare').focus();
                                                    return;
                                                }
                                                if(closingType=='Close w/o Tare @ D'){
                                                var tareweightD;
                                                var netweightDestination;
                                                 if(Ext.getCmp('typecomboIdTare').getValue() == "APPLICATION"){
                                                     tareweightD=tareweight;
                                                     netweightDestination=netweightDest;
                                                   }else{
                                                     tareweightD=tareweightRfid;
                                                     netweightDestination=netweightRfid;
                                                   }
                                                 var grossWeightD= parseFloat(Ext.getCmp('quantityIdT').getValue());
                                                 var netwg= parseFloat(grossWeightD)-tareweightD;
                                                   if (netweightDestination<(netwg-150) || netweightDestination>(netwg+150)) {
                                                    Ext.getCmp('reasonCloaseId').show();
                                                    Ext.getCmp('mandatoryreasonId').show();
                                                    Ext.getCmp('mandatoryreasonIdT').show();
                                                    Ext.getCmp('mandatoryrsnId1T').show();
                                                    Ext.getCmp('ReasnLabel').show();
                                                    if(Ext.getCmp('reasonCloaseId').getValue()==""){
                                                        Ext.example.msg("Please select Reason");
	                                                    Ext.getCmp('reasonCloaseId').focus();
	                                                    return;
                                                    }
                                                  }
<!--                                                  if(netwg>((loadcapacityClose)+ (loadcapacityClose*0.003))){-->
<!--                                                  	  Ext.example.msg("Destination Quantity is greater than 0.3% of Load capacity of vehicle");-->
<!--	                                                  return;-->
<!--                                                  }-->
                                                }
                                                if(buttonValue=='closetrip'){
                                                 var grossWeightD;
                                                 if(Ext.getCmp('typecomboIdTare').getValue() == "APPLICATION"){
                                                     grossWeightD=grossWeightDest;
                                                     netweightDestination=netweightDest;
                                                 }else{
                                                     grossWeightD=grossWeightDestRfid;
                                                     netweightDestination=netweightRfid;
                                                 }
                                                 var tareWeightD= parseFloat(Ext.getCmp('quantityIdT').getValue());
                                                 var netwg= parseFloat(grossWeightD)-tareWeightD;
                                                 
                                                  if (netweightDestination<(netwg-150) || netweightDestination>(netwg+150)) {
                                                    Ext.getCmp('reasonCloaseId').show();
                                                    Ext.getCmp('mandatoryreasonId').show();
                                                    Ext.getCmp('mandatoryreasonIdT').show();
                                                    Ext.getCmp('mandatoryrsnId1T').show();
                                                    Ext.getCmp('ReasnLabel').show();
                                                    if(Ext.getCmp('reasonCloaseId').getValue()==""){
                                                        Ext.example.msg("Please select Reason");
	                                                    Ext.getCmp('reasonCloaseId').focus();
	                                                    return;
                                                    }
                                                  }
<!--                                                  if(netwg>((loadcapacityClose)+ (loadcapacityClose*0.003))){-->
<!--                                                  	  Ext.example.msg("Destination Quantity is greater than 0.3% of Load capacity of vehicle");-->
<!--	                                                  return;-->
<!--                                                  }-->
                                                }
                                                var VehicleNoBaseTypeTare = "";
                                                var globalClientId = Ext.getCmp('custcomboId').getValue();
                                                var customerName = Ext.getCmp('custcomboId').getRawValue();
                                                if (Ext.getCmp('typecomboIdTare').getValue() == "RFID") {
                                                    VehicleNoBaseTypeTare = Ext.getCmp('RFIDIdT').getValue();
                                                }
                                                if (Ext.getCmp('typecomboIdTare').getValue() == "APPLICATION") {
                                                    VehicleNoBaseTypeTare = Ext.getCmp('vehiclecomboIdTare').getValue();
                                                }
                                                var selected=grid.getSelectionModel().getSelected();
                                                if(closingType=='Close w/o Tare @ D'){
                                                   if(Ext.getCmp('typecomboIdTare').getValue() == "APPLICATION"){
                                                     closeQuantity=tareweight;
                                                   }else{
                                                     closeQuantity=tareweightRfid;
                                                   }
                                                }
                                                if(buttonValue=='manualClose'){
                                                   tareqty=Ext.getCmp('quantityIdC').getValue();
                                                   grossqty=Ext.getCmp('quantityIdC2').getValue();
                                                }
                                                
                                                myWinForTareWeight.getEl().mask();
                                                //Performs Save Operation
                                                //Ajax request starts here
                                                Ext.Ajax.request({
                                                    url: '<%=request.getContextPath()%>/TripSheetGenerationAction.do?param=saveormodifyGenrateTripSheetForTare',
                                                    method: 'POST',
                                                    params: {
                                                        buttonValue: buttonValue,
                                                        CustID: Ext.getCmp('custcomboId').getValue(),
                                                        vehicleNo: VehicleNoBaseTypeTare,
                                                        quantity: Ext.getCmp('quantityIdT').getValue(),
                                                        validityDateTime: Ext.getCmp('startDateTimeForTare').getValue(),
                                                        grade: Ext.getCmp('gradeAndMineralscomboIdForTare').getValue(),
                                                        closingType: closingType,
                                                        closeQuantity: closeQuantity,
                                                        tareqty: tareqty,
                                                        grossqty: grossqty,
                                                        type: Ext.getCmp('typecomboIdTare').getValue(),
                                                        tripNo:tripNo,
                                                        closeReasson :Ext.getCmp('reasonCloaseId').getValue()
                                                    },
                                                    success: function(response, options) {
                                                        var message = response.responseText;
                                                        Ext.example.msg(message);
                                                        //Ext.getCmp('typecomboIdTare').reset();
                                                        Ext.getCmp('vehiclecomboIdTare').reset();
                                                        Ext.getCmp('RFIDIdT').reset();
                                                        Ext.getCmp('tcNamecomboIdTare').reset();
                                                        Ext.getCmp('quantityIdT').reset();
                                                        Ext.getCmp('startDateTimeForTare').reset();
                                                        Ext.getCmp('gradeAndMineralscomboIdForTare').reset();
                                                        Ext.getCmp('routecomboIdforTare').reset();
                                                        myWinForTareWeight.hide();
                                                        myWinForTareWeight.getEl().unmask();
                                                    },
                                                    failure: function() {
                                                        Ext.example.msg("Error");
                                                        Ext.getCmp('mandatoryVehicleIdT').hide();
                                                        Ext.getCmp('VehicleNoIDT').hide();
                                                        Ext.getCmp('vehiclecomboIdTare').hide();
                                                        Ext.getCmp('mandatoryRfidT').hide();
                                                        Ext.getCmp('RFIDIDsT').hide();
                                                        Ext.getCmp('RFIDIdT').hide();
                                                        Ext.getCmp('RFIDButtIdT').hide();
                                                        myWinForTareWeight.hide();
                                                    }
                                                });

                                            }
                                        }
                                    }
                                }, {
                                    xtype: 'button',
                                    text: '<%=Cancel%>',
                                    id: 'canButtIdFortare',
                                    cls: 'buttonstyle',
                                    iconCls: 'cancelbutton',
                                    width: '80',
                                    listeners: {
                                        click: {
                                            fn: function() {
                                                clearInterval(interval);
                                                Ext.getCmp('vehiclecomboIdTare').reset();
                                                Ext.getCmp('RFIDIdT').reset();
                                                Ext.getCmp('vehicleRFIDPanelIdTare').hide();
                                                Ext.getCmp('mandatoryVehicleIdT').hide();
                                                Ext.getCmp('VehicleNoIDT').hide();
                                                Ext.getCmp('vehiclecomboIdTare').hide();
                                                Ext.getCmp('mandatoryRfidT').hide();
                                                Ext.getCmp('RFIDIDsT').hide();
                                                Ext.getCmp('RFIDIdT').hide();
                                                Ext.getCmp('RFIDButtIdT').hide();
                                                myWinForTareWeight.hide();
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
                                width: 600,
                                height: 420,
                                frame: true,
                                id: 'addCaseInfo',
                                layout: 'table',
                                layoutConfig: {
                                    columns: 1
                                },
                                items: [detailsFirstPanel, vehicleRFIDPanel, detailsSecondPanel]
                            });

                            var caseInnerPanelForTare = new Ext.Panel({
                                standardSubmit: true,
                                collapsible: false,
                                //autoScroll: true,
                                width: 450,
                                height: 430,
                                frame: true,
                                id: 'addCaseInfoForTare',
                                layout: 'table',
                                layoutConfig: {
                                    columns: 1
                                },
                                items: [detailsFirstPanelForTare, vehicleRFIDPanelForTare, detailsSecondPanelForTare]
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
                            var thirdForthPanel = new Ext.Panel({
                                standardSubmit: true,
                                collapsible: false,
                                id: 'thirdForthpanelId',
                                layout: 'table',
                                frame: false,
                                height: 300,
                                width: 210,
                                layoutConfig: {
                                    columns: 2
                                },
                                items: [{height:50},{},
                                 {},{
                                    xtype: 'label',
                                    text: 'Trip Sheets Limit',
                                    cls: 'my-label-style2-1',
                                    id: 'tripsheetLimitLabId'
                                },
                                {height:20},{},
                                {width:25 },
                                {
                                    xtype: 'textfield',
                                    width: 130,
                                    cls: 'quantityBox1',
                                    readOnly: true,
                                    id: 'tripsheetLimitTxtId'
                                },
                                { height:20 },{},
                                {}, {
                                    xtype: 'label',
                                    text: 'Trip Sheets Balance',
                                    cls: 'my-label-style2-1',
                                    id: 'tripsheetBalLimitLabId'
                                },{ height:20},{},
                                {width:25}, 
                                {
                                    xtype: 'textfield',
                                    width: 130,
                                    cls: 'quantityBox1',
                                    readOnly: true,
                                    id: 'tripsheetBalLimitTxtId'
                                }]
                            });

                            var detailsForthPanel = new Ext.Panel({
                                standardSubmit: true,
                                collapsible: false,
                                id: 'detailsForthPanel',
                                layout: 'table',
                                frame: true,
                                height: 420,
                                width: 210,
                                layoutConfig: {
                                    columns: 1
                                },
                                items: [firstForthPanel, secondForthPanel,thirdForthPanel]
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

                            var detailsFifthPanel = new Ext.Panel({
                                standardSubmit: true,
                                collapsible: false,
                                id: 'detailsFifthPanel',
                                layout: 'table',
                                frame: true,
                                height: 420,
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
                                width: 1289,
                                height: 440,
                                frame: true,
                                id: 'InneraddCaseInfo',
                                layout: 'table',
                                layoutConfig: {
                                    columns: 4
                                },
                                items: [caseInnerPanel, detailsThirdPanel, detailsForthPanel, detailsFifthPanel]
                            });

                            var caseTwoInnerPanelForTare = new Ext.Panel({
                                standardSubmit: true,
                                collapsible: false,
                                autoScroll: true,
                                width: 715,
                                height: 445,
                                frame: true,
                                id: 'InneraddCaseInfoTare',
                                layout: 'table',
                                layoutConfig: {
                                    columns: 3
                                },
                                items: [caseInnerPanelForTare, detailsThirdPanelForManualClose,detailsThirdPanelForFare]
                            });

                            //****************************** Window For Adding Trip Information Ends Here************************
                            var outerPanelWindow = new Ext.Panel({
                                standardSubmit: true,
                                id: 'winpanelId',
                                frame: true,
                                height: 500,
                                width: 1300,
                                items: [caseTwoInnerPanel, winButtonPanel]
                            });

                            var outerPanelWindowForTareWeight = new Ext.Panel({
                                standardSubmit: true,
                                id: 'winpanelIdForTare',
                                frame: true,
                                height: 550,
                                width: 725,
                                items: [caseTwoInnerPanelForTare, winButtonPanelForTare]
                            });
                            //************************* Outer Pannel *********************************************************//
                            myWin = new Ext.Window({
                                title: 'My Window',
                                closable: false,
                                resizable: false,
                                modal: true,
                                autoScroll: false,
                                height: 550,
                                width: 1320,
                                id: 'myWin',
                                items: [outerPanelWindow]
                            });

                            myWinForTareWeight = new Ext.Window({
                                title: 'My Window',
                                closable: false,
                                resizable: false,
                                modal: true,
                                autoScroll: false,
                                height: 550,
                                width: 740,
                                id: 'myWin1',
                                items: [outerPanelWindowForTareWeight]
                            });
                            
						    var panelForTransferTrip = new Ext.form.FormPanel({
						        standardSubmit: true,
						        collapsible: false,
						        autoScroll: true,
						        height: 200,
						        width: 650,
						        frame: false,
						        id: 'panelForTransferTripId',
						        layout: 'table',
						        layoutConfig: {
						            columns: 1
						        },
						        items: [{
						            xtype: 'fieldset',
						            title: 'Trip Transfer',
						            cls: 'fieldsetpanel',
						            autoScroll: true,
						            collapsible: false,
						            colspan: 3,
						            id: 'tripTransferId',
						            width: 450,
						            height: 350,
						            layout: 'table',
						            layoutConfig: {
						                columns: 4
						            },
						            items: [{
						                xtype: 'label',
						                text: '',
						                cls: 'mandatoryfield',
						                id: 'mandatoryid001'
						            }, {
						                xtype: 'label',
						                text: '*',
						                cls: 'mandatoryfield',
						                id: 'mandatoryLabel1'
						            }, {
						                xtype: 'label',
						                text: 'Existing Trip Vehicle No' + '  :',
						                cls: 'labelstyle',
						                id: 'vehiclelabelId'
						            }, existingVehicleCombo ,
						            {
						                xtype: 'label',
						                text: '',
						                cls: 'mandatoryfield',
						                id: 'mandatoryid01'
						            }, {
						                xtype: 'label',
						                text: '*',
						                cls: 'mandatoryfield',
						                id: 'mandatoryLabel2'
						            }, {
						                xtype: 'label',
						                text: 'Existing TripSheet No' + '  :',
						                cls: 'labelstyle',
						                id: 'tripsheetNoLabelId'
						            }, {
						                xtype: 'textfield',
						                cls: 'selectstylePerfect',
						                id: 'tripsheetNoId',
						                readOnly: true,
						                mode: 'local'
						            }, {
						                xtype: 'label',
						                text: '',
						                cls: 'mandatoryfield',
						                id: 'mandatoryid2'
						            }, {
						                xtype: 'label',
						                text: '*',
						                cls: 'mandatoryfield',
						                id: 'mandatoryLabel3'
						            }, {
						                xtype: 'label',
						                text: 'Replace Vehicle No' + ' :',
						                id:'replaceVNoId',
						                cls: 'labelstyle'
						            },vehicleCombo1, {
						                xtype: 'label',
						                text: '',
						                cls: 'mandatoryfield',
						                id: 'mandatoryid3'
						            }, {
						                xtype: 'label',
						                text: '*',
						                cls: 'mandatoryfield',
						                id: 'mandatoryLabel4'
						            }, {
						                xtype: 'label',
						                text: 'Remarks' + ' :',
						                id: 'remarksLabelId',
						                cls: 'labelstyle'
						            }, {
						                xtype: 'textarea',
						                cls: 'selectstylePerfect',
						                id: 'remarksId',
						                mode: 'local'
						            }]
						        }]
						    });
						    
						    var buttonPanelForTripTransfer = new Ext.Panel({
						        id: 'buttonPanelForTripTransferId',
						        standardSubmit: true,
						        collapsible: false,
						        autoHeight: true,
						        cls: 'windowbuttonpanel',
						        frame: false,
						        layout: 'table',
						        layoutConfig: {
						            columns: 4
						        },
						        buttons: [{
						            xtype: 'button',
						            text: 'Save',
						            id: 'saveButtonID',
						            cls: 'buttonstyle',
						            iconCls: 'savebutton',
						            width: 70,
						            listeners: {
						                click: {
						                    fn: function() { 
						                        if (Ext.getCmp('extVehiclecomboId').getValue() == "") {
						                            Ext.example.msg("Select Vehicle No");
						                            Ext.getCmp('extVehiclecomboId').focus();
						                            return;
						                        }
						                        if (Ext.getCmp('tripsheetNoId').getValue() == "") {
						                            Ext.example.msg("Enter TripSheet No");
						                            Ext.getCmp('tripsheetNoId').focus();
						                            return;
						                        }
						                        if (Ext.getCmp('vehiclecombo1Id').getValue() == "") {
						                            Ext.example.msg("Select Vehicle No");
						                            Ext.getCmp('vehiclecombo1Id').focus();
						                            return;
						                        }
						                        if (Ext.getCmp('remarksId').getValue() == "") {
						                            Ext.example.msg("Enter remarks");
						                            Ext.getCmp('remarksId').focus();
						                            return;
						                        }
						                        transferWin.getEl().mask();
						                        Ext.Ajax.request({
						                            url: '<%=request.getContextPath()%>/TripSheetGenerationAction.do?param=transferTrip',
						                            method: 'POST',
						                            params: {
						                                extVehicleNo: Ext.getCmp('extVehiclecomboId').getRawValue(),
						                                tripSheetNo: Ext.getCmp('tripsheetNoId').getValue(),
						                                ReplaceVehicleNo: Ext.getCmp('vehiclecombo1Id').getValue(),
						                                remark: Ext.getCmp('remarksId').getValue(),
						                                CustId: Ext.getCmp('custcomboId').getValue(),
						                                tripId: tripId,
						                                Transfertareweight: Transfertareweight
						                            },
						                            success: function(response, options) {
						                                var message = response.responseText;
						                                Ext.example.msg(message);
						                                transferWin.hide();
						                                transferWin.getEl().unmask();
						                            },
						                            failure: function() {
						                                Ext.example.msg("Error");
						                                transferWin.error();
						                            }
						                        });
						                    }
						                }
						            }
						        }, {
						            xtype: 'button',
						            text: '<%=Cancel%>',
						            id: 'canButtId1',
						            cls: 'buttonstyle',
						            iconCls: 'cancelbutton',
						            width: 70,
						            listeners: {
						                click: {
						                    fn: function() {
						                        transferWin.hide();
						                    }
						                }
						            }
						        }]
						    });
                            var transferWin = new Ext.Window({
						        title: 'Trip Transfer Informations',
						        closable: false,
						        resizable: false,
						        modal: true,
						        autoScroll: false,
						        height: 300,
						        width: 470,
						        id: 'transferWinId',
						        items: [panelForTransferTrip,buttonPanelForTripTransfer]
						    });
						    
						    var panelForBaargeTransferTrip = new Ext.form.FormPanel({
						        standardSubmit: true,
						        collapsible: false,
						        autoScroll: true,
						        height: 200,
						        width: 650,
						        frame: false,
						        id: 'transferId',
						        layout: 'table',
						        layoutConfig: {
						            columns: 1
						        },
						        items: [{
						            xtype: 'fieldset',
						            title: 'Barge Trip Transfer',
						            cls: 'fieldsetpanel',
						            autoScroll: true,
						            collapsible: false,
						            colspan: 3,
						            id: 'bargetTripId',
						            width: 450,
						            height: 180,
						            layout: 'table',
						            layoutConfig: {
						                columns: 4
						            },
						            items: [{
						                xtype: 'label',
						                text: '',
						                cls: 'mandatoryfield',
						                id: 'mandatoryid0013'
						            }, {
						                xtype: 'label',
						                text: '*',
						                cls: 'mandatoryfield',
						                id: 'mandatoryLabel13'
						            }, {
						                xtype: 'label',
						                text: 'Barge Trip No' + '  :',
						                cls: 'labelstyle',
						                id: 'bargeTripNoId'
						            }, bargeTripCombo ,
						            {
						                xtype: 'label',
						                text: '',
						                cls: 'mandatoryfield',
						                id: 'mandatoryidb'
						            }, {
						                xtype: 'label',
						                text: '',
						                cls: 'mandatoryfield',
						                id: 'mandatoryLabeer'
						            }, {
						                xtype: 'label',
						                text: 'Barge Name' + ' :',
						                id: 'bargeName34',
						                cls: 'labelstyle'
						            }, {
						                xtype: 'textfield',
						                disabled:true,
						                cls: 'selectstylePerfect',
						                id: 'bargeanmeIdd',
						                mode: 'local'
						            },{
						                xtype: 'label',
						                text: '',
						                cls: 'mandatoryfield',
						                id: 'mandatoryid3'
						            }, {
						                xtype: 'label',
						                text: '',
						                cls: 'mandatoryfield',
						                id: 'mandatoryLabel45'
						            }, {
						                xtype: 'label',
						                text: 'Remarks' + ' :',
						                id: 'remarksLabelId1',
						                cls: 'labelstyle'
						            }, {
						                xtype: 'textarea',
						                cls: 'selectstylePerfect',
						                id: 'bargeremarksId',
						                mode: 'local'
						            }]
						        }]
						    });
						     var buttonPanelForBargeTripTransfer = new Ext.Panel({
						        id: 'bargeTripTransferId',
						        standardSubmit: true,
						        collapsible: false,
						        autoHeight: true,
						        cls: 'windowbuttonpanel',
						        frame: false,
						        layout: 'table',
						        layoutConfig: {
						            columns: 4
						        },
						        buttons: [{
						            xtype: 'button',
						            text: 'Save',
						            id: 'saveId',
						            cls: 'buttonstyle',
						            iconCls: 'savebutton',
						            width: 70,
						            listeners: {
						                click: {
						                    fn: function() { 
						                        if (Ext.getCmp('bargeTripComboId').getValue() == "") {
						                            Ext.example.msg("Select Barge TripNo");
						                            Ext.getCmp('bargeTripComboId').focus();
						                            return;
						                        }
						                        var sel=grid.getSelectionModel().getSelected();
						                        var id = Ext.getCmp('bargeTripComboId').getValue();
							                    var row = bargeTripComboStore.findExact('id', id);
							                    var rec = bargeTripComboStore.getAt(row);
							                    bargeStatus = rec.data['bargeStatus'];
							                    bargeQty = rec.data['bargeQty'];
							                    bargeCapacity = rec.data['bargeCapacity'];
							                    
						                        bargeTransferWin.getEl().mask();
						                        Ext.Ajax.request({
						                            url: '<%=request.getContextPath()%>/TripSheetGenerationAction.do?param=transferBargeTrip',
						                            method: 'POST',
						                            params: {
						                                bargeId: Ext.getCmp('bargeTripComboId').getValue(),
						                                tripSheetNo: Ext.getCmp('bargeTripComboId').getRawValue(),
						                                remark: Ext.getCmp('bargeremarksId').getValue(),
						                                CustId: Ext.getCmp('custcomboId').getValue(),
						                                tripId: sel.get('uniqueIDIndex'),
						                                quantity1: sel.get('q1IndexId'),
						                                quantity: sel.get('QuantityIndex'),
						                                permitId: sel.get('pIdIndexId'),
						                                bargeStatus : bargeStatus,
						                                bargeQty: bargeQty,
						                                bargeCapacity: bargeCapacity,
						                                vehicleNo: sel.get('assetNoIndex'),
						                                truckTripNo: sel.get('TripSheetNumberIndex')
						                            },
						                            success: function(response, options) {
						                                var message = response.responseText;
						                                Ext.example.msg(message);
						                                bargeTransferWin.hide();
						                                bargeTransferWin.getEl().unmask();
						                                Ext.getCmp('bargeTripComboId').reset();
						                                Ext.getCmp('bargeremarksId').reset();
						                            },
						                            failure: function() {
						                                Ext.example.msg("Error");
						                                bargeTransferWin.error();
						                            }
						                        });
						                    }
						                }
						            }
						        }, {
						            xtype: 'button',
						            text: '<%=Cancel%>',
						            id: 'canId',
						            cls: 'buttonstyle',
						            iconCls: 'cancelbutton',
						            width: 70,
						            listeners: {
						                click: {
						                    fn: function() {
						                        bargeTransferWin.hide();
						                    }
						                }
						            }
						        }]
						    });
						    var bargeTransferWin = new Ext.Window({
						        title: 'Trip Transfer Informations',
						        closable: false,
						        resizable: false,
						        modal: true,
						        autoScroll: false,
						        height: 300,
						        width: 470,
						        id: 'bargeTransferWinId',
						        items: [panelForBaargeTransferTrip,buttonPanelForBargeTripTransfer]
						    });
						    
						    function copyData(){
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
                                
                                if (selected.get('statusIndexId') == 'Cancelled' || selected.get('statusIndexId') == 'Cancelled-Breakdown'
                                        || selected.get('statusIndexId') == 'CLOSE' || selected.get('statusIndexId') == 'Transfer Trip') {
                                    Ext.example.msg("Trip Transfer can not be done for the Trip");
                                    return;
                                }
                                if(selected.get('statusIndexId') == 'OPEN' && parseFloat(selected.get('q2IndexId'))>0){
                                	Ext.example.msg("Trip Transfer can not be done for the Trip");
                                    return;
                                }
                                bargeTransferWin.show();
                                Ext.getCmp('bargeTripComboId').reset();
						        Ext.getCmp('bargeremarksId').reset();
						        Ext.getCmp('bargeanmeIdd').reset();
                                bargeTripComboStore.load({
                                params: {
                                        CustID: Ext.getCmp('custcomboId').getValue()
                                        }
                                   });
						        }

                            function addRecord() {
                                if (Ext.getCmp('custcomboId').getValue() == "") {
                                    Ext.example.msg("<%=pleaseSelectcustomer%>");
                                    Ext.getCmp('custcomboId').focus();
                                    return;
                                }
                                var isSunday;
                                var time;
                                timeStore.load({
                                params: {
                                        CustID: Ext.getCmp('custcomboId').getValue()
                                        }
                                   });
                                var row = timeStore.findExact('id', 1);
			                    var rec = timeStore.getAt(row);
			                    time = rec.data['time'];
			                    isSunday = rec.data['day'];
			                   
								Typecombostore.reload();
                                interval = setInterval(function() {
                                    $.ajax({
                                        type: "GET",
                                        url: '<%=WEIGHTwebServicePath%>',
                                        success: function(data) {
											if(data.indexOf('Something is wrong. Please check')<0){
                                               Ext.getCmp('quantityId').setValue(data);
                                            }
                                            RFIDquantity = Ext.getCmp('quantityId').getValue();
                                            if (Ext.get('tarequantityId').getValue() != "") {
                                                var actualQuantity = parseFloat(RFIDquantity) - parseFloat(Ext.get('tarequantityId').getValue());
                                                Ext.getCmp('actualquantityId').setValue(actualQuantity);
                                            } else {
                                                Ext.getCmp('actualquantityId').setValue(0);
                                            }
                                        }
                                    });
                                }, 5000);

                                buttonValue = "add";
                                title = '<%=addTripSheetInformation%>';
                                myWin.setTitle(title);
                                var d = new Date();
                                d.setDate(d.getDate() + 1);
                                d.setHours(18);
                                d.setSeconds(00);
                                d.setMinutes(00);

                                $('#vehiclecomboId').val('');
                                Ext.getCmp('typecomboId').setDisabled(false);
                                Ext.getCmp('RFIDId').enable;
                                Ext.getCmp('RFIDButtId').setDisabled(false);

                                //Ext.getCmp('typecomboId').setValue('APPLICATION');
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

                                vehicleComboStore.load({
                                    params: {
                                        CustId: Ext.getCmp('custcomboId').getValue()
                                    }
                                });
                                Ext.getCmp('vehiclecomboId').setDisabled(false);
                                Ext.getCmp('captureWeightId').enable();

                                Ext.getCmp('tripsheetNumberLabelId').hide();
                                Ext.getCmp('mandatorytripsheetNumberId').hide();
                                Ext.getCmp('mandatoryTripsheetNumber1').hide();
                                Ext.getCmp('mandatoryTripsheetNumber').hide();
                                Ext.getCmp('enrollNumberId').hide();
                                Ext.getCmp('RFIDId').setValue('');
                                Ext.getCmp('quantityId').setValue('');
                                Ext.getCmp('tarequantityId').setValue('');
                                Ext.getCmp('actualquantityId').setValue('');
                                Ext.getCmp('startDateTime').setValue(d);
                                Ext.getCmp('permitcomboId').enable();
                                if (tripType == 'Close' || tripType == undefined) {
                                    Ext.example.msg("Please do the user setting");
                                    return;
                                }
                                Ext.getCmp('innerfifthMaster').show();
                                permitNoComboStore.load({
                                params: {
                                        CustID: Ext.getCmp('custcomboId').getValue()
                                   },callback: function() {
                                    }
                                 });
                                
                                if(Ext.getCmp('permitcomboId').getValue()!=null && Ext.getCmp('permitcomboId').getValue()!=''){
								permitNoComboStore.load({
                                params: {
                                        CustID: Ext.getCmp('custcomboId').getValue()
                                   },callback: function() {
                                        var id = Ext.getCmp('permitcomboId').getValue();
								              
                               			var row = permitNoComboStore.findExact('pId', id);
                                 		var rec = permitNoComboStore.getAt(row);
                                   		quantity = rec.data['quantity'];
                                   		balance = rec.data['tripSheetQty'];
                                  		tcId=rec.data['tcId'];
                                        orgName=rec.data['orgName'];
                                        lesseName=rec.data['leaseName'];
                                        orgCode=rec.data['orgCode'];
                                        routeId = rec.data['routeId'];
                                        tripsheetCount1=rec.data['tripsheetCount1'];
                                        tripsheetCount2=rec.data['tripsheetCount2'];
                                        srcType=rec.data['srcType'];
                                   		Ext.getCmp('quantityId2').setValue(quantity);
                                   		Ext.getCmp('quantityId2b').setValue(balance); 
                                    }
                                 });
								}
								 tripsheetLimitStore.load({
						            params: {
						                custId: Ext.getCmp('custcomboId').getValue(),
						                routeId: routeId
						            },
						            callback: function() {
						                var row1 = tripsheetLimitStore.findExact('id', '1');
						                var rec1 = tripsheetLimitStore.getAt(row1);
						                var tripsheetLimit = rec1.data['tripsheetLimit'];
						                var tripsheetCount = rec1.data['tripsheetCount'];
						
						                Ext.getCmp('tripsheetLimitTxtId').setValue(parseInt(tripsheetLimit));
						                Ext.getCmp('tripsheetBalLimitTxtId').setValue(parseInt(tripsheetLimit) - parseInt(tripsheetCount));
						                if (parseInt(tripsheetCount) >= parseInt(tripsheetLimit)) {
						                    Ext.MessageBox.show({
						                        msg: 'Route trip sheet limit is exceeded for this Route',
						                        buttons: Ext.MessageBox.OK
						                    });
						                    return;
						                }
						            }
						        });
                                myWin.show();
                            }
                            //*********************** Function to Modify Data ***********************************
                            function modifyData() {
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
                                
                                if (selected.get('statusIndexId') == 'Cancelled') {
                                    Ext.example.msg("Modification can not be done for Cancelled Trip");
                                    return;
                                }
                                if (selected.get('statusIndexId') == 'Cancelled-Breakdown') {
                                    Ext.example.msg("Modification can not be done for Cancelled Trip");
                                    return;
                                }
                                if (selected.get('statusIndexId') == 'Transfer Trip') {
                                    Ext.example.msg("Modification can not be done for Transferred Trip");
                                    return;
                                }
                                if(<%=loginInfo.getIsLtsp()%>!=0 && selected.get('issuedBy') != <%=userId%>){
				                	Ext.example.msg("User cann't modify selected Trip Sheet");
				                    return;
				                }

                                buttonValue = "modify";
                                titel = "<%=modifyTripSheetInformation%>"
                                myWin.setTitle(titel);
                                
                                var type = selected.get('TypeIndex');
                                var quantity3 = selected.get('q2IndexId');
                                var tareWeigh = selected.get('q1IndexId');
                                var quantity4 = selected.get('q3IndexId');
                                var pid = selected.get('pIdIndexId');
                                var permitNoModify = selected.get('permitIndexId');
                                modifyTripDetails.load({
                                    params: {
                                        CustID: Ext.getCmp('custcomboId').getValue(),
                                        pId: permitNoModify
                                    },
                                    callback: function() {
                                        for (var i = 0; i < modifyTripDetails.getCount(); i++) {
                                            var rec = modifyTripDetails.getAt(i);
                                            Ext.getCmp('quantityId2').setValue(rec.data['quantity']);
                                            Ext.getCmp('quantityId2b').setValue(rec.data['tripSheetQty']);
                                        }
                                    }
                                });
                                Ext.getCmp('typecomboId').setDisabled(true);
                                Ext.getCmp('RFIDId').disable;
                                Ext.getCmp('RFIDButtId').setDisabled(true);
                                Ext.getCmp('vehiclecomboId').setDisabled(true);
                                Ext.getCmp('captureWeightId').disable();
                                Ext.getCmp('tarequantityId').setValue(tareWeigh);
                                Ext.getCmp('innerfifthMaster').show();

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
                                Ext.getCmp('tripsheetNumberLabelId').show(),
                                    Ext.getCmp('mandatorytripsheetNumberId').show(),
                                    Ext.getCmp('mandatoryTripsheetNumber1').show();
                                	Ext.getCmp('mandatoryTripsheetNumber').show();
                                    Ext.getCmp('enrollNumberId').show(),
                                    Ext.getCmp('enrollNumberId').disable(),
                                    Ext.getCmp('enrollNumberId').setValue(selected.get('TripSheetNumberIndex'));
                                Ext.getCmp('typecomboId').setValue(selected.get('TypeIndex'));
                                if (selected.get('tcLeaseNoIndex') == '') {
                                    Ext.getCmp('orgcomboId').setValue(selected.get('orgNameIndex'));
                                    Ext.getCmp('tcNamecomboId').hide();
                                    Ext.getCmp('TcleaseNameID').hide();
                                    Ext.getCmp('mandatoryTcleaseName').hide();
                                    Ext.getCmp('orgcomboId').show();
                                    Ext.getCmp('OrgNameNameID').show();
                                    Ext.getCmp('mandatoryTcleaseName12').show();
                                } else {
                                    Ext.getCmp('tcNamecomboId').setValue(selected.get('tcLeaseNoIndex'));
                                    Ext.getCmp('orgcomboId').hide();
                                    Ext.getCmp('OrgNameNameID').hide();
                                    Ext.getCmp('mandatoryTcleaseName12').hide();
                                    Ext.getCmp('tcNamecomboId').show();
                                    Ext.getCmp('TcleaseNameID').show();
                                    Ext.getCmp('mandatoryTcleaseName').show();
                                }
                                Ext.getCmp('quantityId').setValue(selected.get('QuantityIndex'));
                                Ext.getCmp('startDateTime').setValue(selected.get('validityDateDataIndex'));
                                Ext.getCmp('gradeAndMineralscomboId').setValue(selected.get('gradeAndMineralIndex'));
                                Ext.getCmp('permitcomboId').setValue(selected.get('permitIndexId'));
                                Ext.getCmp('routecomboId').setValue(selected.get('RouteIndex'));
                                Ext.getCmp('orderId').setValue(selected.get('OrderIndex'));
                                Ext.getCmp('permitcomboId').disable();
                                var net = parseInt(selected.get('QuantityIndex')) - parseInt(selected.get('q1IndexId'))
                                Ext.getCmp('actualquantityId').setValue(net);
                                if (quantity3 == '' || quantity4 == '') {
                                    myWin.show();
                                }
                            }

                            //**************************************************Function For Fare Weight****************************************   
                            function verifyFunction() {
                                buttonValue = "tareWeight";
                                Ext.getCmp('QuantityIDT').setText('Gross Weight@D');
                                Ext.getCmp('labelTareWeight@DId').setText('Tare Weight@D');
                                myWinForTareWeight.setTitle("Destination Weight");
                              
                                Ext.getCmp('grossWeight@SId').setText('');
                                Ext.getCmp('tareWeight@SId').setText('');
                                Ext.getCmp('netWeight@SId').setText('');
                                Ext.getCmp('tripsheetId').setText('');
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
                                            closingType=rec.data['closingType'];
                                        }
                                    }

                                });
                                //Ext.getCmp('typecomboIdTare').reset();
                                Typecombostore.reload();
                                Ext.getCmp('RFIDIdT').reset();

                                Ext.getCmp('quantityIdT').reset();
                                Ext.getCmp('startDateTimeForTare').disable();
                                Ext.getCmp('reasonCloaseId').reset();
                                
				                 Ext.getCmp('reasonCloaseId').hide();
				                 Ext.getCmp('mandatoryreasonId').hide();
				                 Ext.getCmp('mandatoryreasonIdT').hide();
				                 Ext.getCmp('mandatoryrsnId1T').hide();
				                 Ext.getCmp('ReasnLabel').hide();
				                 
                                if (tcNum == '') {
                                    Ext.getCmp('tcNamecomboIdTare').hide();
                                    Ext.getCmp('orgNamecomboIdTare').show();
                                } else {
                                    Ext.getCmp('tcNamecomboIdTare').show();
                                    Ext.getCmp('orgNamecomboIdTare').hide();
                                }
                                vehicleComboStoreForTare.load({
                                    params: {
                                        CustId: Ext.getCmp('custcomboId').getValue(),
                                        buttonValue: "tareWeight",
                                        desHubid: desHubId
                                    }
                                });
                                //Ext.getCmp('typecomboIdTare').setValue('APPLICATION');
                                if (Ext.getCmp('typecomboIdTare').getValue() == 'APPLICATION') {
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


                                if (tripType == 'Open' || tripType == undefined) {
                                    Ext.example.msg("Please do the user setting");
                                    return;
                                }
                                if(closingType=='Manual Close'){
                                  Ext.example.msg("Please do the user setting");
                                  return;
                                }
                                Ext.getCmp('orgNamecomboIdTare').hide();
                                Ext.getCmp('TcleaseNameIDT1').hide();
                                Ext.getCmp('mandatoryTcleaseNameT1').hide();
                                myWinForTareWeight.show();
                                Ext.getCmp('detailsThirdMasterFare').show();
                                Ext.getCmp('detailsThirdMasterclose1').hide();

                            }
                            //**************************************************Function For Fare Weight****************************************   
                            function approveFunction() {
                                buttonValue = "closetrip";
                                Ext.getCmp('QuantityIDT').setText('Tare Weight@D');
                                Ext.getCmp('labelTareWeight@DId').setText('Gross Weight@D');
                                myWinForTareWeight.setTitle("Close Trip");
                                Ext.getCmp('grossWeight@SId').setText('');
                                Ext.getCmp('tareWeight@SId').setText('');
                                Ext.getCmp('netWeight@SId').setText('');
                                Ext.getCmp('tripsheetId').setText('');
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
                                            closingType=rec.data['closingType'];
                                        }
                                    }
                                });
                                Ext.getCmp('RFIDIdT').reset();
                                Ext.getCmp('tcNamecomboIdTare').disable();
                                Ext.getCmp('quantityIdT').reset();
                                Ext.getCmp('startDateTimeForTare').disable();
                                Ext.getCmp('gradeAndMineralscomboIdForTare').disable();
                                Ext.getCmp('routecomboIdforTare').disable();
                                
                                 Ext.getCmp('reasonCloaseId').reset();
                                 Ext.getCmp('reasonCloaseId').hide();
                                 Ext.getCmp('mandatoryreasonId').hide();
                                 Ext.getCmp('mandatoryreasonIdT').hide();
                                 Ext.getCmp('mandatoryrsnId1T').hide();
                                 Ext.getCmp('ReasnLabel').hide();

                                vehicleComboStoreForTare.load({
                                    params: {
                                        CustId: Ext.getCmp('custcomboId').getValue(),
                                        buttonValue: "closetrip",
                                        desHubid: desHubId
                                    }
                                });
                                //Ext.getCmp('typecomboIdTare').reset();
                                Typecombostore.reload();
                                if (Ext.getCmp('typecomboIdTare').getValue() == 'APPLICATION') {
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

                                if (tripType == 'Open' || tripType == undefined) {
                                    Ext.example.msg("Please do the user setting");
                                    return;
                                }
                                 if(closingType=='Manual Close' || closingType=='Close w/o Tare @ D'){
	                                Ext.example.msg("Please do the user setting");
	                                return;
                                }
                                Ext.getCmp('orgNamecomboIdTare').hide();
                                Ext.getCmp('TcleaseNameIDT1').hide();
                                Ext.getCmp('mandatoryTcleaseNameT1').hide();
                                myWinForTareWeight.show();
                                Ext.getCmp('detailsThirdMasterFare').show();
                                Ext.getCmp('detailsThirdMasterclose1').hide();
                            }

                            //**************************************************Function For Manual Close****************************************   
                            
                             function closetripsummary(){
                               buttonValue = "manualClose";
                                myWinForTareWeight.setTitle("Manual Close");
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
                                            closingType=rec.data['closingType'];
                                        }
                                    }

                                });
                                Ext.getCmp('RFIDIdT').reset();
                                Ext.getCmp('tcNamecomboIdTare').disable();
                                Ext.getCmp('quantityIdT').reset();
                                Ext.getCmp('startDateTimeForTare').disable();
                                Ext.getCmp('gradeAndMineralscomboIdForTare').disable();
                                Ext.getCmp('routecomboIdforTare').disable();
                                
                                 Ext.getCmp('reasonCloaseId').reset();
                                 Ext.getCmp('reasonCloaseId').hide();
                                 Ext.getCmp('mandatoryreasonId').hide();
                                 Ext.getCmp('mandatoryreasonIdT').hide();
                                 Ext.getCmp('mandatoryrsnId1T').hide();
                                 Ext.getCmp('ReasnLabel').hide();

                                vehicleComboStoreForTare.load({
                                    params: {
                                        CustId: Ext.getCmp('custcomboId').getValue(),
                                        buttonValue: "tareWeight",
                                        desHubid: desHubId
                                    }
                                });
                                //Ext.getCmp('typecomboIdTare').reset();
                                Typecombostore.reload();
                                if (Ext.getCmp('typecomboIdTare').getValue() == 'APPLICATION') {
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
                                if (tripType == 'Open' || tripType == undefined) {
                                    Ext.example.msg("Please do the user setting");
                                    return;
                                }
                                if(closingType=='Close with Tare @ D' || closingType=='Close w/o Tare @ D'){
                                  Ext.example.msg("Please do the user setting");
                                  return;
                                }
                                Ext.getCmp('orgNamecomboIdTare').hide();
                                Ext.getCmp('TcleaseNameIDT1').hide();
                                Ext.getCmp('mandatoryTcleaseNameT1').hide();
                                
                                Ext.getCmp('detailsThirdMasterFare').hide();
                                Ext.getCmp('detailsThirdMasterclose1').show();
                                myWinForTareWeight.show();
                                
                             }
                             
   //**************************************************Function For Cancel Trip****************************************   
                             
              function deleteData(){
                buttonValue = "cancelTrip";
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
                     Ext.example.msg("<%=noRecordsFound%>");
                     Ext.getCmp('custcomboId').focus();
                     return;
                 }
                if (selected.get('statusIndexId') == 'Cancelled') {
                   Ext.example.msg("Record already cancelled");
                   return;
                 }
                 if (selected.get('statusIndexId') == 'CLOSE') {
                   Ext.example.msg("Record already Closed");
                   return;
                 }
                  if (selected.get('statusIndexId') == 'Transfer Trip') {
                   Ext.example.msg("Can't cancel selected Trip Sheet");
                   return;
                 }
                 if (selected.get('statusIndexId') == 'Cancelled-Breakdown') {
                     Ext.example.msg("Record already cancelled");
                     return;
                 }
                 if(<%=loginInfo.getIsLtsp()%>!=0 && selected.get('issuedBy') != <%=userId%>){
                	Ext.example.msg("User cann't cancel selected Trip Sheet");
                    return;
                }
                 if(<%=loginInfo.getIsLtsp()%>!=0 && selected.get('issuedBy') == <%=userId%> && selected.get('isClosableIndexId') == "F"){
                	Ext.example.msg("User cann't cancel the Trip Sheet after 5 minutes from Issued Date Time");
                    return;
                }
                
                Ext.MessageBox.show({
                title: '',
                msg: 'Are you sure you want to Cancel the trip?',
                buttons: Ext.MessageBox.YESNO,
                icon: Ext.MessageBox.QUESTION,
                fn: function(btn) {
                    if (btn == 'yes') {
                        
                        id = selected.get('uniqueIDIndex');
                        permitNo = selected.get('permitIndexId');
                        tcId = selected.get('tcLeaseNoIndexId');
                        routeId = selected.get('RouteIndexId');
                        assetNo=selected.get('assetNoIndex');
                        issuedUser=selected.get('issuedBy');
                        Ext.Ajax.request({
                            url: '<%=request.getContextPath()%>/TripSheetGenerationAction.do?param=cancelTrip',
                            method: 'POST',
                            params: {
                                id: id,
                                CustID: Ext.getCmp('custcomboId').getValue(),
                                permitNo : permitNo,
                                tcId: tcId,
                                routeId : routeId,
                                issuedUser : issuedUser,
                                assetNo:assetNo
                            },
                            success: function(response, options) {
                                var message = response.responseText;
                                Ext.example.msg(message);
                                store.load({
                                    params: {
                                       CustID: Ext.getCmp('custcomboId').getValue(),
                                       jspName: jspName,
                                       CustName: Ext.getCmp('custcomboId').getRawValue(),
                                       endDate: Ext.getCmp('enddate').getValue(),
                                       startDate: Ext.getCmp('startdate').getValue(),
                                       status: Ext.getCmp('statuscomboId').getValue()
                                    }
                                });
                                permitNoComboStore.load({
                                   params: {
                                       CustID: Ext.getCmp('custcomboId').getValue()
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
		      function columnchart(){   
		         Ext.getCmp('extVehiclecomboId').reset();
                 Ext.getCmp('tripsheetNoId').reset();
                 Ext.getCmp('vehiclecombo1Id').reset();
                 Ext.getCmp('remarksId').reset();
                 
		         tripTranferVehiclesStore.load({
                     params: {
                         CustId: Ext.getCmp('custcomboId').getValue()
                     }
                 });
		         vehicleComboStore.load({
                     params: {
                         CustId: Ext.getCmp('custcomboId').getValue()
                     }
                 });
                 if (tripType == 'Close' || tripType == undefined) {
                     Ext.example.msg("Please do the user setting");
                     return;
                 }
		         transferWin.show();
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
                   Ext.Ajax.timeout = 180000;
               });
                        </script>
         <jsp:include page="../Common/footer.jsp" />
 <!-- </body>   -->
 <!-- </html> -->
        <%}%>