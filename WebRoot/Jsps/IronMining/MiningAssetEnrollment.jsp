<%@ page  language="java" import="java.util.*,t4u.functions.CommonFunctions,t4u.beans.*,t4u.common.*" pageEncoding="utf-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
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
		loginInfo.setCountryCode(Integer.parseInt(str[11].trim()));

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
	tobeConverted.add("Select_Customer");
	tobeConverted.add("Mining_Asset_Enrollment");
	tobeConverted.add("Please_Select_customer");
	tobeConverted.add("Enter_Carriage_Capacity");
	tobeConverted.add("SLNO");
	tobeConverted.add("Asset_Number");
	tobeConverted.add("Registration_Date");
	tobeConverted.add("Carriage_Capacity");
	tobeConverted.add("Operating_On_Mine");
	tobeConverted.add("Location");
	tobeConverted.add("Mining_Lease_No");
	tobeConverted.add("Owner_Name");
	tobeConverted.add("House_No");
	tobeConverted.add("Locality");
	tobeConverted.add("City/Village");
	tobeConverted.add("Taluka");
	tobeConverted.add("District");
	tobeConverted.add("State");
	tobeConverted.add("EPIC_No");
	tobeConverted.add("PAN_No");
	tobeConverted.add("Mobile_No");
	tobeConverted.add("Phone_No");
	tobeConverted.add("Bank");
	tobeConverted.add("Branch");
	tobeConverted.add("Account_No");
	tobeConverted.add("Principal_Balance");
	tobeConverted.add("Principal_Over_Dues");
	tobeConverted.add("Interest_Balance");
	tobeConverted.add("Enter_Asset_Number");
	tobeConverted.add("Enter_Registration_Date");
	tobeConverted.add("Enter_Operating_On_Mine");
	tobeConverted.add("Enter_Location");
	tobeConverted.add("Enter_Mining_Lease_No");
	tobeConverted.add("Enter_Owner_Name");
	tobeConverted.add("Enter_House_No");
	tobeConverted.add("Enter_Locality");
	tobeConverted.add("Enter_City");
	tobeConverted.add("Enter_Taluka");
	tobeConverted.add("Select_District_Name");
	tobeConverted.add("Select_State_Name");
	tobeConverted.add("Enter_Epic_No");
	tobeConverted.add("Enter_Pan_No");
	tobeConverted.add("Enter_Mobile_Number");
	tobeConverted.add("Enter_Phone_Number");
	tobeConverted.add("Enter_Bank");
	tobeConverted.add("Enter_Branch");
	tobeConverted.add("Enter_Account_No");
	tobeConverted.add("Enter_Principal_Balance");
	tobeConverted.add("Enter_Principal_Over_dues");
	tobeConverted.add("Enter_Interest_Balance");
	tobeConverted.add("Save");
	tobeConverted.add("No_Records_Found");
	tobeConverted.add("Cancel");
	tobeConverted.add("Error");
	tobeConverted.add("Mining_Asset_Enrollment_Details");
	tobeConverted.add("Add_Asset_Information");
	tobeConverted.add("Modify_Asset_Information");
	tobeConverted.add("Select_Single_Row");
	tobeConverted.add("vehicle_And_Operating_Mine_Details");
	tobeConverted.add("Truck_Owner_Details");
	tobeConverted.add("Hypothication_Details");
	tobeConverted.add("Enrollment_Number");
	tobeConverted.add("Enrollment_Date");
	tobeConverted.add("Acknowledgement_Information");
	tobeConverted.add("Acknowledgement");
	tobeConverted.add("Challan_Number");
	tobeConverted.add("Enter_Challan_Number");
	tobeConverted.add("Challen_Date");
	tobeConverted.add("Enter_Challen_Date");
	tobeConverted.add("Bank_Transaction_Number");
	tobeConverted.add("Enter_Bank_Transaction_Number");
	tobeConverted.add("Amount_Paid");
	tobeConverted.add("Enter_Paid_Amount");
	tobeConverted.add("Validity_Date");
	tobeConverted.add("Enter_Validity_Date");
	tobeConverted.add("Validity_Date_Must_Be_Greater_Than_Challen_Date");
	tobeConverted.add("Acknowledge_By");
	tobeConverted.add("Enter_Enrollment_Number");
	tobeConverted.add("Chassis_No");
    tobeConverted.add("Enter_Chassis_No");
    tobeConverted.add("Adhar_No");
    tobeConverted.add("Enter_Adhar_No");
    tobeConverted.add("Enter_Enrollment_Date");
    tobeConverted.add("Assembly_Constituency");
    tobeConverted.add("Enter_Assembly_Constituency");
    
ArrayList<String> convertedWords=new ArrayList<String>();
convertedWords=cf.getLanguageSpecificWordForKey(tobeConverted,language);
    String selectCustomer=convertedWords.get(0);
	String MiningAssetEnrollment=convertedWords.get(1);
	String pleaseSelectcustomer=convertedWords.get(2);
	String entercarriageCapacity=convertedWords.get(3);
	String SLNO=convertedWords.get(4);
	String assetNumber=convertedWords.get(5);
	String RegistrationDate=convertedWords.get(6);
	String carriageCapacity=convertedWords.get(7);
	String operatingOnMine=convertedWords.get(8);
	String location=convertedWords.get(9);
	String MiningLeaseNo=convertedWords.get(10);
	String OwnerName=convertedWords.get(11);
	String houseNo=convertedWords.get(12);
	String Locality=convertedWords.get(13);
	String City=convertedWords.get(14);
	String taluka=convertedWords.get(15);
	String District=convertedWords.get(16);
	String state=convertedWords.get(17);
	String EPICNo=convertedWords.get(18);
	String PANNo=convertedWords.get(19);
	String MobileNo=convertedWords.get(20);
	String PhoneNo=convertedWords.get(21);
	String Bank=convertedWords.get(22);
	String Branch=convertedWords.get(23);
	String AccountNo=convertedWords.get(24);
	String PrincipalBalance=convertedWords.get(25);
	String PrincipalOverDues=convertedWords.get(26);
	String InterestBalance=convertedWords.get(27);
	String enterAssetNumber=convertedWords.get(28);
	String enterRegistrationDate=convertedWords.get(29);
	String enteroperatingOnMine=convertedWords.get(30);
	String enterLocation=convertedWords.get(31);
	String enterMiningLeaseNo=convertedWords.get(32);
	String enterOwnerName=convertedWords.get(33);
	String enterHouseNo=convertedWords.get(34);
	String enterLocality=convertedWords.get(35);
	String enterCity=convertedWords.get(36);
	String enterTaluka=convertedWords.get(37);
	String enterDistrict=convertedWords.get(38);
	String enterState=convertedWords.get(39);
	String enterEpicNo=convertedWords.get(40);
	String enterPanNo=convertedWords.get(41);
	String enterMobileNumber=convertedWords.get(42);
	String enterPhoneNumber=convertedWords.get(43);
	String enterBank=convertedWords.get(44);
	String enterBranch=convertedWords.get(45);
	String enterPrincipalBalance=convertedWords.get(46);
	String enterPrincipalOverDues=convertedWords.get(47);
	String enterInterestBalance=convertedWords.get(48);
	String enterAccountNo=convertedWords.get(49);
	String save =convertedWords.get(50);
	String noRecordsFound=convertedWords.get(51);
	String cancel=convertedWords.get(52);
	String error=convertedWords.get(53);
	String MiningAssetEnrollmentDetails=convertedWords.get(54);
	String addAssetInformation=convertedWords.get(55);
	String modifyAssetInformation=convertedWords.get(56);
	String SelectSingleRow=convertedWords.get(57);
	String vehicleAndOperatingMineDetails=convertedWords.get(58);
    String AssetOwnerDetails=convertedWords.get(59);
    String hypothicationDetails=convertedWords.get(60);
    String enrollmentNumber=convertedWords.get(61);
    String enrollmentDate=convertedWords.get(62);
    String AcknowledgementInformation=convertedWords.get(63);
	String Acknowledgement=convertedWords.get(64);
	String ChallanNumber=convertedWords.get(65);
	String EnterChallanNumber=convertedWords.get(66);
	String ChallenDate=convertedWords.get(67);
	String EnterChallenDate=convertedWords.get(68);
	String BankTransactionNumber=convertedWords.get(69);
	String EnterBankTransactionNumber=convertedWords.get(70);
	String AmountPaid=convertedWords.get(71);
	String EnterPaidAmount=convertedWords.get(72);
	String ValidityDate=convertedWords.get(73);
	String EnterValidityDate=convertedWords.get(74);
	String validityDateMustBeGreaterthanChallenDate=convertedWords.get(75);
	String AcknowledgeBy=convertedWords.get(76);
	String enterEnrollmentNumber=convertedWords.get(77);
	String ChassisNo=convertedWords.get(78);
	String enterChassisNo=convertedWords.get(79);
	String AdharNo=convertedWords.get(80);
	String enterAdharNo=convertedWords.get(81);
	String enterEnrollmentDate=convertedWords.get(82);
	String AssemblyConstituency=convertedWords.get(83);
	String enterAssemblyConstituency=convertedWords.get(84);
	
	int systemId = loginInfo.getSystemId();
	int userId=loginInfo.getUserId(); 
	int customerId = loginInfo.getCustomerId();
	
	String userAuthority=cf.getUserAuthority(systemId,userId);

	if(customerId > 0 && loginInfo.getIsLtsp()== -1 && !userAuthority.equalsIgnoreCase("Admin"))
	{
		response.sendRedirect(request.getContextPath()+ "/Jsps/Common/401Error.html");
	}
	else{
%>

<jsp:include page="../Common/header.jsp" />
    <base href="<%=basePath%>">
    <title>Mining Asset Enrollment</title>
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	<style>
	             .x-btn-text addbutton{font-family: 'Helvetica', sans-serif;
	                                                  font-size: 12px !important;}
				.x-btn-text editbutton{font-family: 'Helvetica', sans-serif;
				                                                  font-size: 12px !important;}
				.x-btn-text excelbutton{font-family: 'Helvetica', sans-serif;
				                                                  font-size: 12px !important;}
				.x-btn-text pdfbutton{font-family: 'Helvetica', sans-serif;
				                                                  font-size: 12px !important;}
				.x-btn-text{font-family: 'Helvetica', sans-serif;
				                                                  font-size: 12px !important;}
				.x-btn-text clearfilterbutton{font-family: 'Helvetica', sans-serif;
				                                                  font-size: 12px !important;
				}
				.tripimportimagepanel{
					width: 100%;
					height: 200px;
					background-image:
						url(/ApplicationImages/ExcelImportFormats/AssetEnrollmentImage.png)
						!important;
					background-repeat: no-repeat;
				}
	</style>

        <%if (loginInfo.getStyleSheetOverride().equals("Y")){%>                  
        <jsp:include page="../Common/ImportJSSandMining.jsp" />                                                    
        <%}else {%>  
        <jsp:include page="../Common/ImportJS.jsp" /><%} %>
        <jsp:include page="../Common/ExportJS.jsp" />
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
					height:auto !important;
				}
				
			</style>
		<%}%>
        <script>
		var grid;
		var myWin;
		var buttonValue;
		var uniqueId;
		var closewin;
		var approveWin;
		var outerPanel;
		var AssetNo;
	 	var jspName='MiningAssetEnrollmentReport';
    	var exportDataType = "int,string,string,string,string,string,number,string,string,string,string,string,string,string,number,string,string,string,string,string,string,string,string,string,string,string,string";
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
              stateComboStore.load({
                    params: {
                        // CustId: custId
                    }
                });
			districtComboStore.load({
                    params: {
                        
                    }
                });
            }
        }
    }
});
	//*********************** Store For State Here*****************************************//
	var stateComboStore = new Ext.data.JsonStore({
    url: '<%=request.getContextPath()%>/CommonAction.do?param=getStates',
    id: 'stateStoreId',
    root: 'StateRoot',
    autoload: true,
    remoteSort: true,
    fields: ['StateID', 'stateName'],
    listeners: {
        load: function() {}
    }
   });
   
   var stateCombo = new Ext.form.ComboBox({
    store: stateComboStore,
    id: 'statecomboId',
    mode: 'local',
    forceSelection: true,
    emptyText: '<%=enterState%>',
    blankText: '<%=enterState%>',
    resizable: true,
    selectOnFocus: true,
    allowBlank: true,
    anyMatch: true,
    typeAhead: false,
    triggerAction: 'all',
    lazyRender: true,
    valueField: 'StateID',
    displayField: 'stateName',
    cls: 'selectstylePerfect',
    listeners: {
        select: {
            fn: function() {
                Ext.getCmp('districtcomboId').setValue('');
                districtComboStore.load({
                    params: {
                        stateId: Ext.getCmp('statecomboId').getValue()
                    }
                });
            }
        }
    }
});
	
	//************************ Store for District Here***************************************//
	var districtComboStore = new Ext.data.JsonStore({
    url: '<%=request.getContextPath()%>/SandBlockManagementAction.do?param=getDistirctList',
    id: 'districtStoreId',
    root: 'districtRoot',
    autoload: false,
    remoteSort: true,
    fields: ['districtID', 'districtName'],
    listeners: {
        load: function() {}
    }
});

var districtCombo = new Ext.form.ComboBox({
    store: districtComboStore,
    id: 'districtcomboId',
    mode: 'local',
    forceSelection: true,
    emptyText: '<%=enterDistrict%>',
    blankText: '<%=enterDistrict%>',
    resizable: true,
    selectOnFocus: true,
    allowBlank: true,
    anyMatch: true,
    typeAhead: false,
    triggerAction: 'all',
    lazyRender: true,
    valueField: 'districtID',
    displayField: 'districtName',
    cls: 'selectstylePerfect',
    listeners: {
        select: {
            fn: function() {
               
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
              stateComboStore.load({
                    params: {
                        // CustId: custId
                    }
                });
			districtComboStore.load({
                    params: {
                        
                    }
                });
            }
        }
    }
	});
	//************************ Combo for Customer Ends Here***************************************//	
   	// **********************************************Reader configs Starts******************************
    
     var reader = new Ext.data.JsonReader({
        idProperty: 'tripcreationId',
    	root: 'miningAssetEnrollDetailsRoot',
    	totalProperty: 'total',
    	fields: [{
        name: 'slnoIndex'
    	},{
        name: 'EnrollmentNumberIndex'
    	},{
        name: 'EnrollmentDateIndex',
        type: 'date'
    	},{
        name: 'assetNoIndex'
    	},{
        name: 'RegistrationDateIndex',
        type: 'date',
    	},{
    	name: 'engineNoIndex'
    	},{
    	name: 'carriageCapacityIndex'
    	},{
    	name: 'operatingOnMineIndex'
    	},{
    	name: 'locationIndex'
    	},{
    	name: 'MiningLeaseNoIndex'
    	},{
		name:'ChasisNoIndex'
		},{
		name:'InsurancePolicyNumber'
		},{
		name:'InsuranceExpiryDate',
		 type: 'date'
		},{
		name:'PucNumber'
		},{
		name:'PucExpiredDate',
		 type: 'date'
		},{
		name:'roadTaxValidityDate',
		 type: 'date'
		},{
		name:'permitValidityDate',
		 type: 'date'
		},{
        name: 'OwnerNameIndex'
    	},{
    	name:'AssemblyConstituencyIndex'
    	},{
        name: 'houseNoIndex'
    	},{
        name: 'localityIndex'
    	},{
        name: 'cityIndex'
    	},{
        name: 'talukaIndex'
    	},{
    	name: 'DistrictIndex'
    	},{
    	name: 'StateIndex'
    	},{
        name: 'EPICNoIndex'
    	},{
        name: 'PANNoIndex'
    	},{
        name: 'MobileNoIndex'
    	},{
        name: 'PhoneNoIndex'
    	},{
        name: 'AadharNoIndex'
        },{
        name: 'BankIndex'
    	},{
        name: 'BranchIndex'
    	},{
		name:'PrincipalBalanceIndex'
		},{
		name:'PrincipalOverDuesIndex'
		},{
		name:'PrincipalInterestIndex'
		},{
        name: 'AccountNoIndex'
    	},{
        name: 'statusIndex'
    	},{
        name: 'uniqueIdDataIndex'
        },{
        name: 'challenNoIndex'
        },{
        name: 'challenDataIndex',
        type: 'date'
        },{
        name: 'banktransactionDataIndex'
        },{
        name: 'amountPaidDataIndex'
        },{
        name: 'validityDateDataIndex',
         type: 'date'
        },{
    	name: 'AcknowledgeByIndex'
    	},{
    	name: 'districtIdIndex'
    	},{
    	name: 'stateIdIndex'
    	},{
    	name: 'status'
    	},{
    	name: 'reasonOfInactive'
    	}]
    });
    
    // **********************************************Reader configs Ends******************************
    //********************************************Store Configs For Grid*************************

    var store = new Ext.data.GroupingStore({
        autoLoad: false,
        proxy: new Ext.data.HttpProxy({
            url: '<%=request.getContextPath()%>/MiningAssetEnrollment.do?param=getAssetEnrollmentDetails',
            method: 'POST'
        }),
        remoteSort: false,
        storeId: 'miningAssetEnrollDetailsStore',
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
        dataIndex: 'EnrollmentNumberIndex'
    	},{
    	type: 'date',
        dataIndex: 'EnrollmentDateIndex'
    	},
    	{
    	type: 'string',
        dataIndex: 'assetNoIndex'
    	},{
        type: 'date',
        dataIndex: 'RegistrationDateIndex'
    	},{
    	type: 'string',
    	dataIndex: 'engineNoIndex'
    	},{
        type: 'string',
        dataIndex: 'carriageCapacityIndex'
    	},{
    	type: 'string',
        dataIndex: 'operatingOnMineIndex'
    	},{
    	type: 'string',
        dataIndex: 'location'
    	}, {
        type: 'string',
        dataIndex: 'MiningLeaseNoIndex'
    	}, {
    	type: 'string',
    	name:'InsurancePolicyNumber'
		},{
		type: 'date',
		name:'InsuranceExpiryDate'
		},{
		type: 'string',
		name:'PucNumber'
		},{
		type: 'date',
		name:'PucExpiredDate'
		},{
		type: 'date',
		name:'roadTaxValidityDate'
		},{
		type: 'date',
		name:'permitValidityDate'
		},{
        type: 'string',
        dataIndex: 'OwnerNameIndex'
    	},{
    	type:'string',
    	dataIndex:'AssemblyConstituencyIndex'
    	},{
        type: 'string',
        dataIndex: 'DistrictIndex'
    	}, {
        type: 'string',
        dataIndex: 'StateIndex'
    	}, {
        type: 'string',
        dataIndex: 'EPICNoIndex'
    	}, {
        type: 'string',
        dataIndex: 'PANNoIndex'
    	}, {
        type: 'string',
        dataIndex: 'MobileNoIndex'
    	}, {
        type: 'string',
        dataIndex: 'PhoneNoIndex'
    	}, {
        type: 'string',
        dataIndex: 'BankIndex'
    	}, {
        type: 'string',
        dataIndex: 'BranchIndex'
    	},{
        type: 'string',
        dataIndex: 'AccountNoIndex'
    	},{
        type: 'string',
        dataIndex: 'PrincipalBalanceIndex'
    	}, {
        type: 'string',
        dataIndex: 'challenNoIndex'
    	},{
    	type: 'date',
        dataIndex: 'challenDataIndex'
    	}, {
        type: 'string',
        dataIndex: 'banktransactionDataIndex'
    	}, {
        type: 'int',
        dataIndex: 'amountPaidDataIndex'
    	},{
    	type: 'date',
        dataIndex: 'validityDateDataIndex'
    	}, {
        type: 'string',
        dataIndex: 'AcknowledgeByIndex'
    	}, {
        type: 'string',
        dataIndex: 'districtIdIndex'
    	}, {
        type: 'string',
        dataIndex: 'stateIdIndex'
    	}, {
        type: 'string',
        dataIndex: 'status'
    	}, {
        type: 'string',
        dataIndex: 'reasonOfInactive'
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
        	header: "<span style=font-weight:bold;><%=enrollmentNumber%></span>",
        	dataIndex: 'EnrollmentNumberIndex',
        	filter: {
            type: 'string'
        	}
    		}, {
        	header: "<span style=font-weight:bold;><%=enrollmentDate%></span>",
        	dataIndex: 'EnrollmentDateIndex',
        	 renderer: Ext.util.Format.dateRenderer(getDateFormat()),
            //renderer: Ext.util.Format.dateRenderer('dd/mm/YYYY'),
        	filter: {
            type: 'date'
        	}
    		}, {
        	header: "<span style=font-weight:bold;><%=assetNumber%></span>",
        	dataIndex: 'assetNoIndex',
        	filter: {
            type: 'string'
        	}
    		},{
        	dataIndex: 'RegistrationDateIndex',
        	header: "<span style=font-weight:bold;><%=RegistrationDate%></span>",
        	renderer: Ext.util.Format.dateRenderer(getDateFormat()),
            //renderer: Ext.util.Format.dateRenderer('dd/mm/YYYY'),
        	//width: 110,        	
        	filter: {
            type: 'date'
        	}
    		},{
        	header: "<span style=font-weight:bold;>Engine Number</span>",
        	dataIndex: 'engineNoIndex'
    		},{
    		header: "<span style=font-weight:bold;><%=carriageCapacity%></span>",
    		dataIndex: 'carriageCapacityIndex',
    		//width: 110,
    		align: 'right',    
    		sortable: true,		
    		filter: {
    		type: 'int'
    		}
    		},{
        	header: "<span style=font-weight:bold;><%=OwnerName%></span>",
        	dataIndex: 'OwnerNameIndex',
        	//width: 80,
        	filter: {
            type: 'string'
        	}
    		},{
        	header: "<span style=font-weight:bold;><%=AssemblyConstituency%></span>",
        	dataIndex: 'AssemblyConstituencyIndex',
        	//width: 80,
        	filter: {
            type: 'string'
        	}
    		},{
        	header: "<span style=font-weight:bold;><%=District%></span>",
        	dataIndex: 'DistrictIndex',
        	//width: 120,
        	filter: {
            type: 'string'
        	}
    		},{
        	header: "<span style=font-weight:bold;><%=state%></span>",
        	dataIndex: 'StateIndex',
        	//width: 80,
        	filter: {
            type: 'string'
        	}
    		},{
        	header: "<span style=font-weight:bold;><%=ChallanNumber%></span>",
        	dataIndex: 'challenNoIndex',
        	//width: 80,
        	filter: {
            type: 'string'
        	}
    		},{
        	header: "<span style=font-weight:bold;><%=ChallenDate%></span>",
        	dataIndex: 'challenDataIndex',
        	renderer: Ext.util.Format.dateRenderer(getDateFormat()),
        	filter: {
            type: 'date'
        	}
    		},{
        	header: "<span style=font-weight:bold;><%=BankTransactionNumber%></span>",
        	dataIndex: 'banktransactionDataIndex',
        	filter: {
            type: 'string'
        	}
    		},{
        	header: "<span style=font-weight:bold;><%=AmountPaid%></span>",
        	dataIndex: 'amountPaidDataIndex',
        	align: 'right',
        	filter: {
            type: 'int'
        	}
    		},{
        	header: "<span style=font-weight:bold;><%=ValidityDate%></span>",
        	dataIndex: 'validityDateDataIndex',
        	renderer: Ext.util.Format.dateRenderer(getDateFormat()),
        	//width: 80,
        	filter: {
            type: 'date'
        	}
    		},{
        	header: "<span style=font-weight:bold;><%=AcknowledgeBy%></span>",
        	dataIndex: 'AcknowledgeByIndex',
        	//width: 80,
        	filter: {
            type: 'String'
        	}
    		},{
        	header: "<span style=font-weight:bold;>District Name</span>",
        	dataIndex: 'districtIdIndex',
        	hidden:true,
        	hideable: false,
        	filter: {
            type: 'string'
        	}
    		},{
        	header: "<span style=font-weight:bold;>State Name</span>",
        	dataIndex: 'stateIdIndex',
        	hidden:true,
        	hideable: false,
        	filter: {
            type: 'string'
        	}
    		},{
    		header: "<span style=font-weight:bold;>Insurance Policy No</span>",
        	dataIndex: 'InsurancePolicyNumber',
        	
        	filter: {
            type: 'string'
        	}
    		},{
    		header: "<span style=font-weight:bold;>Insurance Expiry Date</span>",
        	dataIndex: 'InsuranceExpiryDate',
        	renderer: Ext.util.Format.dateRenderer(getDateFormat()),
       	    filter: {
            type: 'date'
        	}
    		},{
    		header: "<span style=font-weight:bold;>PUC Number</span>",
        	dataIndex: 'PucNumber',
            filter: {
            type: 'string'
        	}
    		},{
    		header: "<span style=font-weight:bold;>PUC Expiry Date</span>",
        	dataIndex: 'PucExpiredDate',
        	renderer: Ext.util.Format.dateRenderer(getDateFormat()),
       	    filter: {
            type: 'date'
        	}
    		},{
    		header: "<span style=font-weight:bold;>RoadTax Validity Date</span>",
        	dataIndex: 'roadTaxValidityDate',
        	renderer: Ext.util.Format.dateRenderer(getDateFormat()),
       	    filter: {
            type: 'date'
        	}
    		},{
    		header: "<span style=font-weight:bold;>Permit Validity Date</span>",
        	dataIndex: 'permitValidityDate',
        	renderer: Ext.util.Format.dateRenderer(getDateFormat()),
       	    filter: {
            type: 'date'
        	}
    		},{
    		header: "<span style=font-weight:bold;>Status</span>",
        	dataIndex: 'status',
       	    filter: {
            type: 'string'
        	}
    		},{
    		header: "<span style=font-weight:bold;>Reason For Inactive</span>",
        	dataIndex: 'reasonOfInactive',
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
    //******************************************Creating By Passing Parameter***********************
    
 grid = getGrid('<%=MiningAssetEnrollmentDetails%>', '<%=noRecordsFound%>', store,screen.width-55,420,40, filters, 'Clear Filter Data', false, '', 20, false, '', false, '', true, 'Excel', jspName, exportDataType, false, 'PDF', true, 'Add', true, 'Modify',
false, '', false , '',false,'',true,'<%=Acknowledgement%>',false,'',false,'',true,'Import Asset Details',true,'Update Asset Details');
    
    
  //**************************************Import excel for Asset*********************************************************//

   function checkValid(val) {
      if (val == "Invalid") {
          return '<img src="/ApplicationImages/ApplicationButtonIcons/No.png">';
      } else if (val == "Valid") {
          return '<img src="/ApplicationImages/ApplicationButtonIcons/Yes.png">';
      }
  }

  function getImportExcelGrid(gridtitle, emptytext, store, width, height, gridnoofcols, filters, filterstr, reconfigure, reconfigurestr, reconfigurenoofcols, group, groupstr, chart, chartstr, excel, excelstr, jspName, exportDataType, pdf, pdfstr, add, addstr, modify, modifystr, del, delstr, closetrip, closestr, verify, verifystr, approve, approvestr, copy, copystr, postpone, postponestr, importExcel, importStr, save, saveStr, clearData, clearStr, close, closeStr) {
      var grid = new Ext.grid.GridPanel({
          title: gridtitle,
          border: false,
          height: getGridHeight(),
          autoScroll: true,
          sortable: false,
          store: store,
          id: 'grid',
          colModel: createColModel(gridnoofcols),
          loadMask: true,
          listeners: {
              render: function(grid) {
                  grid.store.on('load', function(store, records, options) {
                      grid.getSelectionModel().selectFirstRow();
                  });
              }
          },
          bbar: new Ext.Toolbar({})
      });
      if (width > 0) {
          grid.setSize(width, height);
      }
      grid.getBottomToolbar().add(['->']);
      if (save) {
          grid.getBottomToolbar().add([
              '-', {
                  text: saveStr,
                  iconCls: 'savebutton',
                  handler: function() {
                      saveData();

                  }
              }
          ]);
      }
      if (clearData) {
          grid.getBottomToolbar().add([
              '-', {
                  text: clearStr,
                  iconCls: 'clearbutton',
                  handler: function() {
                      clearInputData();

                  }
              }
          ]);
      }
      if (close) {
          grid.getBottomToolbar().add([
              '-', {
                  text: closeStr,
                  iconCls: 'closebutton',
                  handler: function() {
                      closeImportWin();

                  }
              }
          ]);
      }

      return grid;
  } 
  
  var importReader = new Ext.data.JsonReader({
      root: 'AssetMining',
      totalProperty: 'total',
      fields: [{
          name: 'importassetnoIndex'
      }, {
          name: 'importregistrationdateIndex',
          type: 'string'
      }, {
          name: 'importcarriagecapacityIndex'
      }, {
          name: 'importOperatingonmineIndex'
      }, {
          name: 'importlocationIndex'
      }, {
          name: 'importminingleasenoIndex'
      }, {
          name: 'importchassingnoIndex'
      }, {
          name: 'importpolicynoIndex'
      }, {
          name: 'importinsuranceexpirydateIndex',
          type: 'string'
      }, {
          name: 'importpucnoIndex'
      }, {
          type: 'string',
          name: 'importpucexpirydateIndex'
      }, {
          type: 'string',
          name: 'importroadTaxValiditydateIndex'
      }, {
          type: 'string',
          name: 'importpermitValiditydateIndex'
      }, {
          name: 'importownernameIndex'
      }, {
          name: 'importAssemblyConstituencyIndex'
	  }, {
		  name: 'importHouseNoIndex'
      }, {
	      name: 'importLocalityIndex'
      }, {
	      name: 'importCityIndex'
      }, {
	      name: 'importTalukaIndex'
      }, {
	      name: 'importStateIndex'
      }, {
	     name: 'importDistrictIndex'
      }, {
	     name: 'importEPICNoIndex'
      }, {
	     name: 'importPANNoIndex'
      }, {
	     name: 'importMobileNoIndex'
      }, {
	     name: 'importPhoneNoIndex'
      }, {
	     name: 'importAadharNoIndex'
      }, {
         type: 'string',
	     name: 'importEnrollmentDateIndex'
	  }, {
	     name: 'importBankIndex'
      }, {
	    name: 'importBranchIndex'
      }, {
	    name: 'importPrincipalBalanceIndex'
      }, {
	    name: 'importPrincipalOverDuesIndex'
      }, {
	    name: 'importInterestBalanceIndex'
      }, {
	    name: 'importAccountNoIndex'
	  },{
	    name: 'importValidStatusIndex'
	  }, {
         name: 'importRemarksIndex'
      }, {
         name: 'importstateidIndex'
      }, {
         name: 'importdistrictidIndex'
      }, {
      	 name: 'importEngineNoIndex'
      }]
  });
	    
    
   	var importStore = new Ext.data.GroupingStore({
      proxy: new Ext.data.HttpProxy({
          //url: '<%=request.getContextPath()%>/MiningAssetEnrollment.do?param=getimportAddDetails',
          method: 'POST'
      }),
      remoteSort: false,
      bufferSize: 700,
      autoLoad: false,
      reader: importReader
  });
   	
   	var createColModel = function(finish, start) {
      var columns = [{
            header: "<span style=font-weight:bold;><%=assetNumber%></span>",
            dataIndex: 'importassetnoIndex',
            hidden: false,           
             },{
        	header: "<span style=font-weight:bold;><%=RegistrationDate%></span>",
            dataIndex: 'importregistrationdateIndex',
            hidden: false,
			//renderer: Ext.util.Format.dateRenderer('d/m/Y')
            
    		},{
    		header: "<span style=font-weight:bold;><%=carriageCapacity%></span>",
    		dataIndex: 'importcarriagecapacityIndex',
            hidden: false
    		},{
        	header: "<span style=font-weight:bold;><%=operatingOnMine%></span>",
        	dataIndex: 'importOperatingonmineIndex',
             hidden: false
    		},{
    		header: "<span style=font-weight:bold;><%=location%></span>",
        	dataIndex: 'importlocationIndex',
            hidden: false
    		},{
        	header: "<span style=font-weight:bold;><%=MiningLeaseNo%></span>",
        	dataIndex: 'importminingleasenoIndex',
        	hidden: false
    		},{
        	header: "<span style=font-weight:bold;><%=ChassisNo%></span>",
        	dataIndex: 'importchassingnoIndex',
        	hidden: false
    		},{
			header: "<span style=font-weight:bold;>Insurance Policy No</span>",
        	dataIndex: 'importpolicynoIndex',
            hidden: false
    		},{	
    		header: "<span style=font-weight:bold;>Insurance ExpiryDate</span>",
    		//renderer: Ext.util.Format.dateRenderer('d/m/Y'),
        	dataIndex: 'importinsuranceexpirydateIndex',
        	hidden: false
    		},{
        	header: "<span style=font-weight:bold;>Puc Number</span>",
        	dataIndex: 'importpucnoIndex',
			
        	hidden: false
    		},{
        	header: "<span style=font-weight:bold;>Puc Expiry Date </span>",
        	dataIndex: 'importpucexpirydateIndex',
        	//renderer: Ext.util.Format.dateRenderer('d/m/Y'),
        	hidden: false
            },{
            header: "<span style=font-weight:bold;>RoadTax Validity Date</span>",
            dataIndex: 'importroadTaxValiditydateIndex'
            }, {
            header: "<span style=font-weight:bold;>Permit Validity Date</span>",
            dataIndex: 'importpermitValiditydateIndex'
            }, {
    		header: "<span style=font-weight:bold;><%=OwnerName%></span>",
        	dataIndex: 'importownernameIndex',
            
        	hidden: false
    		},{
    		header: "<span style=font-weight:bold;><%=AssemblyConstituency%></span>",
        	dataIndex: 'importAssemblyConstituencyIndex',
            width: 100,
        	hidden: false
    		},{
    		header: "<span style=font-weight:bold;><%=houseNo%></span>",
        	dataIndex: 'importHouseNoIndex',
            hidden: false
			},{
    		header: "<span style=font-weight:bold;><%=Locality%></span>",
        	dataIndex: 'importLocalityIndex',
            hidden: false
			},{
    		header: "<span style=font-weight:bold;><%=City%></span>",
        	dataIndex: 'importCityIndex',
            
        	hidden: false
			},{
    		header: "<span style=font-weight:bold;><%=taluka%></span>",
        	dataIndex: 'importTalukaIndex',
            
        	hidden: false
			},{
    		header: "<span style=font-weight:bold;><%=state%></span>",
        	dataIndex: 'importStateIndex',
            
        	hidden: false
			},{
    		header: "<span style=font-weight:bold;><%=District%></span>",
        	dataIndex: 'importDistrictIndex',
            hidden: false
			},{
            header: "<span style=font-weight:bold;><%=EPICNo%></span>",
        	dataIndex: 'importEPICNoIndex',
            hidden: false
			},{
    		header: "<span style=font-weight:bold;><%=PANNo%></span>",
        	dataIndex: 'importPANNoIndex',
            hidden: false
			},{
			header: "<span style=font-weight:bold;><%=MobileNo%></span>",
        	dataIndex: 'importMobileNoIndex',
            hidden: false
			},{
    		header: "<span style=font-weight:bold;><%=PhoneNo%></span>",
        	dataIndex: 'importPhoneNoIndex',
            hidden: false
			},{
    		header: "<span style=font-weight:bold;><%=AdharNo%></span>",
        	dataIndex: 'importAadharNoIndex',
            hidden: false
			},{
    		header: "<span style=font-weight:bold;><%=enrollmentDate%></span>",
        	dataIndex: 'importEnrollmentDateIndex',
            hidden: false,
            //renderer: Ext.util.Format.dateRenderer('d/m/Y')
			},{
			header: "<span style=font-weight:bold;><%=Bank%></span>",
        	dataIndex: 'importBankIndex',
            hidden: false
        	
    		},{
        	header: "<span style=font-weight:bold;><%=Branch%></span>",
        	dataIndex: 'importBranchIndex',
            hidden: false
        	},{
        	header: "<span style=font-weight:bold;><%=PrincipalBalance%></span>",
        	dataIndex: 'importPrincipalBalanceIndex',
            hidden: false
        	
    		},{
        	header: "<span style=font-weight:bold;><%=PrincipalOverDues%></span>",
        	dataIndex: 'importPrincipalOverDuesIndex',
            hidden: false
        	
    		},{
    		header: "<span style=font-weight:bold;><%=InterestBalance%></span>",
        	dataIndex: 'importInterestBalanceIndex',
            hidden: false
        	
    		},{
    		header: "<span style=font-weight:bold;><%=AccountNo%></span>",
        	dataIndex: 'importAccountNoIndex',
            hidden: false
    		 
           },{
    		header: "<span style=font-weight:bold;>Engine Number</span>",
        	dataIndex: 'importEngineNoIndex',
            hidden: false
    		 
           }, {
              header: "<span style=font-weight:bold;>Valid Status</span>",
              width: 80,
              dataIndex: 'importValidStatusIndex',
              renderer: checkValid
              }, {
              header: "<span style=font-weight:bold;>Remarks</span>",
              width: 100,
              dataIndex: 'importRemarksIndex'
          }
      ];
      return new Ext.grid.ColumnModel({
          columns: columns.slice(start || 0, finish),
          defaults: {
              sortable: false
          }
      });
  };
  
 var importgrid = getImportExcelGrid('', '<%=noRecordsFound%>', importStore,1298,200,47, '', '', false, '', 25, false, '', false, '', false, 'Excel',
 jspName, exportDataType, false, 'PDF', false, 'Add', false, 'Modify', false, 'Delete', false, '', false, '', false, '', false, '', false, '', false, '', true, 'Save', true, 'Clear', true, 'Close');
	
	
var excelImageFormat = new Ext.FormPanel({
      standardSubmit: true,
      collapsible: false,
      id: 'excelImageId',
      height: 150,
      width: '100%',
      frame: false,
      items: [{
          cls: 'tripimportimagepanel'
      }]
  });
  var fileUploadPanel = new Ext.FormPanel({
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
          fieldLabel: 'Choose File',
          name: 'filePath',
          buttonText: '',
          buttonCfg: {
              iconCls: 'browsebutton'
          },
          listeners: {
              fileselected: {
                  fn: function() {
                      var filePath = document.getElementById('filePath').value;
                      var imgext = filePath.substring(filePath.lastIndexOf(".") + 1, filePath.length);
                      if (imgext == "xls" || imgext == "xlsx") {} else {
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
          iconCls: 'uploadbutton',
          handler: function() {
              if (fileUploadPanel.getForm().isValid()) {
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
                   var custId= Ext.getCmp('custcomboId').getValue()
                  fileUploadPanel.getForm().submit({
                      url: '<%=request.getContextPath()%>/MiningAssetEnrollment.do?param=getImportInsuranceDetails&custId='+custId,
                      enctype: 'multipart/form-data',
                      waitMsg: 'Uploading your file...',
                      success: function(response, action) {

                          Ext.Ajax.request({
                              url: '<%=request.getContextPath()%>/MiningAssetEnrollment.do?param=getimportAddDetails',
                              method: 'POST',
                              params: {
                                  importResponse: action.response.responseText
                              },
                              success: function(response, options) {
                                  responseImportData = Ext.util.JSON.decode(response.responseText);
                                  importStore.loadData(responseImportData);

                              },
                              failure: function() {
                                  Ext.example.msg("Error");
                              }
                          });
                      },
                      failure: function() {
                          Ext.example.msg("Please Upload The Standard Format");
                      }
                  });
              }
          }
      }, {
          text: 'Get Standard Format',
          iconCls: 'downloadbutton',
          handler: function() {
              Ext.getCmp('filePath').setValue("Upload the Standard Format");
              fileUploadPanel.getForm().submit({
                  url: '<%=request.getContextPath()%>/MiningAssetEnrollment.do?param=openStandardFileFormats'
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
      items: [fileUploadPanel, excelImageFormat, importgrid]
  });

  var importWin = new Ext.Window({
      title: 'RTP Import Details',
      width: 1400,
      height:600,
      closable: false,
      modal: true,
      resizable: false,
      autoScroll: false,
      id: 'importWin',
      items: [importPanelWindow]
  });

   function clearInputData() {
      importgrid.store.clearData();
      importgrid.view.refresh();
  }
  
  function closeImportWin() {
      fileUploadPanel.getForm().reset();
      importWin.hide();
      clearInputData();
  }

  function saveData() {
      var ValidCount = 0;
      var totalcount = importStore.data.length;
      for (var i = 0; i < importStore.data.length; i++) {
          var record = importStore.getAt(i);
          var checkvalidOrInvalid = record.data['importValidStatusIndex'];
          if (checkvalidOrInvalid == 'Valid') {
              ValidCount++;
          }
      }

      var saveJson = getJsonOfStore(importStore);

      Ext.Msg.show({
          title: 'Saving..',
          msg: 'We have ' + ValidCount + ' valid transaction to be saved out of ' + totalcount + ' .Do you want to continue?',
          buttons: Ext.Msg.YESNO,
          fn: function(btn) {
              if (btn == 'no') {
                  return;
              }
              if (btn == 'yes') {
                  if (saveJson != '[]' && ValidCount > 0) {
                      Ext.Ajax.request({
                        url: '<%=request.getContextPath()%>/MiningAssetEnrollment.do?param=saveImportDetailsForInsurance',
                          method: 'POST',
                         params: {
                              json: saveJson,
                              custId : Ext.getCmp('custcomboId').getValue(),
                              CustName: Ext.getCmp('custcomboId').getRawValue()
                          },
                          success: function(response, options) {
                              var message = response.responseText;
                              Ext.example.msg(message);
                          },
                          failure: function() {
                              Ext.example.msg("Error");
                          }
                      });
                      clearInputData();
                      fileUploadPanel.getForm().reset();
                      importWin.hide();
                  } else {
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

  function importExcelData() {
  	  if (Ext.getCmp('custcomboId').getValue() == "") {
          Ext.example.msg("SelectCustomer");
          return;
      }
      importButton = "import";
      importTitle = 'Asset Import Details';
      importWin.show();
      importWin.setTitle(importTitle);
  }
	
//**********************************End Of Creating Grid By Passing Parameter*************************

    //**************************************Import excel for Update asset details*********************************************************//

  function getImportExcelGridForUpdateAssets(gridtitle, emptytext, store, width, height, gridnoofcols, filters, filterstr, reconfigure, reconfigurestr, reconfigurenoofcols, group, groupstr, chart, chartstr, excel, excelstr, jspName, exportDataType, pdf, pdfstr, add, addstr, modify, modifystr, del, delstr, closetrip, closestr, verify, verifystr, approve, approvestr, copy, copystr, postpone, postponestr, importExcel, importStr, save, saveStr, clearData, clearStr, close, closeStr) {
      var grid = new Ext.grid.GridPanel({
          title: gridtitle,
          border: false,
          height: getGridHeight(),
          autoScroll: true,
          sortable: false,
          store: store,
          id: 'grid1',
          colModel: createColModelAssetU(gridnoofcols),
          loadMask: true,
          listeners: {
              render: function(grid) {
                  grid.store.on('load', function(store, records, options) {
                      grid.getSelectionModel().selectFirstRow();
                  });
              }
          },
          bbar: new Ext.Toolbar({})
      });
      if (width > 0) {
          grid.setSize(width, height);
      }
      grid.getBottomToolbar().add(['->']);
      if (save) {
          grid.getBottomToolbar().add([
              '-', {
                  text: saveStr,
                  iconCls: 'savebutton',
                  handler: function() {
                      saveDataA();

                  }
              }
          ]);
      }
      if (clearData) {
          grid.getBottomToolbar().add([
              '-', {
                  text: clearStr,
                  iconCls: 'clearbutton',
                  handler: function() {
                      clearInputDataA();

                  }
              }
          ]);
      }
      if (close) {
          grid.getBottomToolbar().add([
              '-', {
                  text: closeStr,
                  iconCls: 'closebutton',
                  handler: function() {
                      closeImportAWin();
                  }
              }
          ]);
      }
      return grid;
  }
  var modImpAssetReader = new Ext.data.JsonReader({
      root: 'modImpAssetRoot',
      totalProperty: 'total',
      fields: [{
          name: 'impSlnoIdx'
      }, {
          name: 'impAssetNoIdx'
      }, {
      	  name: 'impEngineNoIdx'
      }, {
          name: 'UIDIdx'
      }, {
          name: 'impInsuranseNoIdx'
      }, {
          name: 'impInsuranseExpDateIdx',
          type: 'date'
      }, {
          name: 'impPucNoIdx'
      }, {
          name: 'impPucExpDate',
          type: 'date'
      }, {
          name: 'impRoadTaxValDate',
          type: 'date'
      }, {
          name: 'imppermitValDate',
          type: 'date'
      }, {
          name: 'impChallanNoIdx'
      }, {
          name: 'impChallanDateIdx',
          type: 'date'
      }, {
          name: 'impBankTransactionNoIdx'
      }, {
          name: 'impAmountPaidIdx'
      }, {
          name: 'impValidityDateIdx',
          type: 'date'
      }, {
      	  name: 'impOperatingOnMineIdx'
      }, {
      	  name: 'impLocationIdx'
      }, {
      	  name: 'impMiningLeaseNoIdx'
      }, {
      	  name: 'impChassisNoIdx'
      }, {
      	  name: 'impConstituencyIdx'
      }, {
      	  name: 'impHouseNoIdx'
      }, {
      	  name: 'impLocalityIdx'
      }, {
      	  name: 'impCityIdx'
      }, {
      	  name: 'impTalukaIdx'
      }, {
      	  name: 'impEpicNoIdx'
      }, {
      	  name: 'impPanNoIdx'
      }, {
      	  name: 'impMobileNoIdx'
      }, {
      	  name: 'impPhoneNoIdx'
      }, {
      	  name: 'impAadharNoIdx'
      }, {
      	  name: 'impBankIdx'
      }, {
      	  name: 'impBranchIdx'
      }, {
      	  name: 'impPrincipalBalanceIdx'
      }, {
      	  name: 'impPrincipalOverDueIdx'
      }, {
      	  name: 'impInterestBalanceIdx'
      }, {
      	  name: 'impAccountNoIdx'
      }, {
          name: 'impAssetStatusIdx'
      }, {
          name: 'impValidStatusIdx'
      }, {
          name: 'importRemarksIndex'
      }]
  });

  var importAssetUStore = new Ext.data.GroupingStore({
      proxy: new Ext.data.HttpProxy({
          url: '<%=request.getContextPath()%>/MiningAssetEnrollment.do?param=getImportAssetUpdateDetails',
          method: 'POST'
      }),
      remoteSort: false,
      bufferSize: 700,
      autoLoad: false,
      reader: modImpAssetReader
  });

  var createColModelAssetU = function(finish, start) {
      var columns = [
          new Ext.grid.RowNumberer({
              header: "<span style=font-weight:bold;><%=SLNO%></span>",
              width: 50
          }), {
              header: "<span style=font-weight:bold;><%=SLNO%></span>",
              dataIndex: 'impSlnoIdx',
              hidden: true,
              width: 100
          },  {
              header: "<span style=font-weight:bold;>Assert Number</span>",
              width: 105,
              dataIndex: 'impAssetNoIdx'
          },  {
              header: "<span style=font-weight:bold;>Engine Number</span>",
              width: 105,
              dataIndex: 'impEngineNoIdx'
          },  {
              header: "<span style=font-weight:bold;>Insurance Number</span>",
              width: 130,
              dataIndex: 'impInsuranseNoIdx'
          }, {
              header: "<span style=font-weight:bold;>Insurance Expiry Date</span>",
              width: 150,
              renderer: Ext.util.Format.dateRenderer('d/m/Y'),
              dataIndex: 'impInsuranseExpDateIdx'
          }, {
              header: "<span style=font-weight:bold;>Puc No</span>",
              width: 100,
              dataIndex: 'impPucNoIdx'
          }, {
              header: "<span style=font-weight:bold;>Puc Expiry Date</span>",
              width: 120,
              renderer: Ext.util.Format.dateRenderer('d/m/Y'),
              dataIndex: 'impPucExpDate'
          }, {
	          header: "<span style=font-weight:bold;>RoadTax Validity Date</span>",
	          width: 120,
              renderer: Ext.util.Format.dateRenderer('d/m/Y'),
	          dataIndex: 'impRoadTaxValDate'
          }, {
              header: "<span style=font-weight:bold;>Permit Validity Date</span>",
              width: 120,
              renderer: Ext.util.Format.dateRenderer('d/m/Y'),
              dataIndex: 'imppermitValDate'
          }, {
              header: "<span style=font-weight:bold;>Challan Number</span>",
              width: 100,
              dataIndex: 'impChallanNoIdx'
          }, {
              header: "<span style=font-weight:bold;>Challan Date</span>",
              width: 100,
              renderer: Ext.util.Format.dateRenderer('d/m/Y'),
              dataIndex: 'impChallanDateIdx'
          }, {
              header: "<span style=font-weight:bold;>Bank Transaction Number</span>",
              width: 130,
              dataIndex: 'impBankTransactionNoIdx'
          }, {
              header: "<span style=font-weight:bold;>Amount Paid</span>",
              width: 100,
              dataIndex: 'impAmountPaidIdx'
          }, {
              header: "<span style=font-weight:bold;>Validity Date</span>",
              width: 120,
              renderer: Ext.util.Format.dateRenderer('d/m/Y'),
              dataIndex: 'impValidityDateIdx'
          }, {
              header: "<span style=font-weight:bold;>Operating On Mine</span>",
              width: 120,
              dataIndex: 'impOperatingOnMineIdx'
          }, {
              header: "<span style=font-weight:bold;>Location</span>",
              width: 100,
              dataIndex: 'impLocationIdx'
          }, {
              header: "<span style=font-weight:bold;>Mining Lease No </span>",
              width: 120,
              dataIndex: 'impMiningLeaseNoIdx'
          }, {
              header: "<span style=font-weight:bold;>Chassis No</span>",
              width: 100,
              dataIndex: 'impChassisNoIdx'
          }, {
              header: "<span style=font-weight:bold;>Assembly Constituency</span>",
              width: 120,
              dataIndex: 'impConstituencyIdx'
          }, {
              header: "<span style=font-weight:bold;>House No</span>",
              width: 100,
              dataIndex: 'impHouseNoIdx'
          }, {
              header: "<span style=font-weight:bold;>Locality</span>",
              width: 100,
              dataIndex: 'impLocalityIdx'
          }, {
              header: "<span style=font-weight:bold;>City/Village</span>",
              width: 100,
              dataIndex: 'impCityIdx'
          }, {
              header: "<span style=font-weight:bold;>Taluka</span>",
              width: 100,
              dataIndex: 'impTalukaIdx'
          }, {
              header: "<span style=font-weight:bold;>EPIC No</span>",
              width: 100,
              dataIndex: 'impEpicNoIdx'
          }, {
              header: "<span style=font-weight:bold;>PAN No</span>",
              width: 100,
              dataIndex: 'impPanNoIdx'
          }, {
              header: "<span style=font-weight:bold;>Mobile No</span>",
              width: 100,
              dataIndex: 'impMobileNoIdx'
          }, {
              header: "<span style=font-weight:bold;>Phone No</span>",
              width: 100,
              dataIndex: 'impPhoneNoIdx'
          }, {
              header: "<span style=font-weight:bold;>Aadhar No</span>",
              width: 100,
              dataIndex: 'impAadharNoIdx'
          }, {
              header: "<span style=font-weight:bold;>Bank</span>",
              width: 100,
              dataIndex: 'impBankIdx'
          }, {
              header: "<span style=font-weight:bold;>Branch</span>",
              width: 100,
              dataIndex: 'impBranchIdx'
          }, {
              header: "<span style=font-weight:bold;>Principal Balance</span>",
              width: 100,
              dataIndex: 'impPrincipalBalanceIdx'
          }, {
              header: "<span style=font-weight:bold;>Principal Over Due</span>",
              width: 100,
              dataIndex: 'impPrincipalOverDueIdx'
          }, {
              header: "<span style=font-weight:bold;>Interest Balance</span>",
              width: 100,
              dataIndex: 'impInterestBalanceIdx'
          }, {
              header: "<span style=font-weight:bold;>Account No</span>",
              width: 100,
              dataIndex: 'impAccountNoIdx'
          }, {
              header: "<span style=font-weight:bold;>Modified Status</span>",
              width: 120,
              hidden: true,
              dataIndex: 'impValidStatusIdx'
          }, {
              header: "<span style=font-weight:bold;>Status</span>",
              width: 80,
              dataIndex: 'impValidStatusIdx',
              renderer: checkValid
          }, {
              header: "<span style=font-weight:bold;>Remarks</span>",
              width: 300,
              dataIndex: 'importRemarksIndex'
          },
      ];
      return new Ext.grid.ColumnModel({
          columns: columns.slice(start || 0, finish),
          defaults: {
              sortable: false
          }
      });
  };

  var importassetUgrid = getImportExcelGridForUpdateAssets('', 'No Records Found', importAssetUStore, 1300, 198+170, 50, '', '', false, '', 50, false, '', false, '', false, 'Excel', jspName, exportDataType, false, 'PDF', false, 'Add', false, 'Modify', false, 'Delete', false, '', false, '', false, '', false, '', false, '', false, '', true, 'Save', true, 'Clear', true, 'Close');

  var excelImageFormat1 = new Ext.FormPanel({
      standardSubmit: true,
      collapsible: false,
      id: 'excelImageId1',
      height: 170,
      width: '100%',
      frame: false,
      items: [{
          cls: 'tripimportimagepanel1'
      }]
  });
  var fileUploadPanel1 = new Ext.FormPanel({
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
          id: 'filePath1',
          width: 60,
          emptyText: 'Browse',
          fieldLabel: 'Choose File',
          name: 'filePath',
          buttonText: '',
          buttonCfg: {
              iconCls: 'browsebutton'
          },
          listeners: {
              fileselected: {
                  fn: function() {
                      var filePath = document.getElementById('filePath1').value;
                      var imgext = filePath.substring(filePath.lastIndexOf(".") + 1, filePath.length);
                      if (imgext == "xls" || imgext == "xlsx") {} else {
                          Ext.MessageBox.show({
                              msg: 'Please select only .xls or .xlsx files',
                              buttons: Ext.MessageBox.OK
                          });
                          Ext.getCmp('filePath1').setValue("");
                          return;
                      }
                  }
              }
          }
      }],
      buttons: [{
          text: 'Upload',
          iconCls: 'uploadbutton',
          handler: function() {
              if (fileUploadPanel1.getForm().isValid()) {
                  var filePath = document.getElementById('filePath1').value;
                  var imgext = filePath.substring(filePath.lastIndexOf(".") + 1, filePath.length);
                  if (imgext == "xls" || imgext == "xlsx") {
                      clearInputDataA();
                  } else {
                      Ext.MessageBox.show({
                          msg: 'Please select only .xls or .xlsx files',
                          buttons: Ext.MessageBox.OK
                      });
                      Ext.getCmp('filePath1').setValue("");
                      return;
                  }
                   var custId= Ext.getCmp('custcomboId').getValue()
                  fileUploadPanel1.getForm().submit({
                      url: '<%=request.getContextPath()%>/MiningAssetEnrollment.do?param=importAssetUpdateDetails&custId='+custId,
                      enctype: 'multipart/form-data',
                      waitMsg: 'Uploading your file...',
                      success: function(response, action) {
                          Ext.Ajax.request({
                              url: '<%=request.getContextPath()%>/MiningAssetEnrollment.do?param=getImportAssetUpdateDetails',
                              method: 'POST',
                              params: {
                                  importResponse: action.response.responseText
                              },
                              success: function(response, options) {
                                  var responseImportData1 = Ext.util.JSON.decode(response.responseText);
                                  importAssetUStore.loadData(responseImportData1);

                              },
                              failure: function() {
                                  Ext.example.msg("Error");
                              }
                          });
                      },
                      failure: function() {
                          Ext.example.msg("Please Upload The Standard Format");
                      }
                  });
              }
          }
      }, {
          text: 'Get Standard Format',
          iconCls: 'downloadbutton',
          handler: function() {
              Ext.getCmp('filePath1').setValue("Upload the Standard Format");
              fileUploadPanel1.getForm().submit({
                  url: '<%=request.getContextPath()%>/MiningAssetEnrollment.do?param=openStandardFileFormatsForModify'
              });
          }
      }]
  });

  var importPanelWindow1 = new Ext.Panel({
      cls: 'outerpanelwindow',
      frame: false,
      layout: 'column',
      layoutConfig: {
          columns: 1
      },
      items: [fileUploadPanel1,  importassetUgrid]//excelImageFormat1
  });

  var importWin1 = new Ext.Window({
      title: 'Aseet Import Details',
      width: 1400,
      height: 500,
      closable: false,
      modal: true,
      resizable: false,
      autoScroll: false,
      id: 'importWin1',
      items: [importPanelWindow1]
  });

   function clearInputDataA() {
      importassetUgrid.store.clearData();
      importassetUgrid.view.refresh();
  }
  
  function closeImportAWin() {
      fileUploadPanel1.getForm().reset();
      importWin1.hide();
      clearInputDataA();
  }

  function saveDataA() {
      var ValidCount1 = 0;
      var totalcount1 = importAssetUStore.data.length;
      for (var i = 0; i < importAssetUStore.data.length; i++) {
          var record = importAssetUStore.getAt(i);
          var checkvalidOrInvalid1 = record.data['impValidStatusIdx'];
          if (checkvalidOrInvalid1 == 'Valid') {
              ValidCount1++;
          }
      }

      var updateJson = getJsonOfStore1(importAssetUStore);

      Ext.Msg.show({
          title: 'Saving..',
          msg: 'We have ' + ValidCount1 + ' valid transaction to be update out of ' + totalcount1 + ' .Do you want to continue?',
          buttons: Ext.Msg.YESNO,
          fn: function(btn) {
              if (btn == 'no') {
                  return;
              }
              if (btn == 'yes') {
                  if (updateJson != '[]' && ValidCount1 > 0) {
                      Ext.Ajax.request({
                          url: '<%=request.getContextPath()%>/MiningAssetEnrollment.do?param=updateImportDetailsForAsset',
                          method: 'POST',
                          params: {
                              updateJson: updateJson,
                              custId : Ext.getCmp('custcomboId').getValue()
                          },
                          success: function(response, options) {
                          	  store.reload();
                              var message = response.responseText;
                              Ext.example.msg(message);
                          },
                          failure: function() {
                              store.reload();
                              Ext.example.msg("Error");
                          }
                      });
                      clearInputDataA();
                      fileUploadPanel1.getForm().reset();
                      importWin1.hide();
                  } else {
                      Ext.MessageBox.show({
                          msg: "You don't have any Valid Information to Proceed",
                          buttons: Ext.MessageBox.OK
                      });
                  }
              }
          }
      });
  }

  function getJsonOfStore1(importstore1) {
      var datar = new Array();
      var jsonDataEncode = "";
      var recordss = importstore1.getRange();
      for (var i = 0; i < recordss.length; i++) {
          datar.push(recordss[i].data);
      }
      jsonDataEncode = Ext.util.JSON.encode(datar);
      return jsonDataEncode;
  }

  function saveDate() {
  	  if (Ext.getCmp('custcomboId').getValue() == "") {
          Ext.example.msg("<%=selectCustomer%>");
          return;
      }
      importButton1 = "importAsset";
      importTitle1 = 'Aseet Details';
      importWin1.show();
      importWin1.setTitle(importTitle1);
  }
  
  <%if (loginInfo.getStyleSheetOverride().equals("Y")){%>
	  importWin.setHeight(515);
	  importWin.setWidth(1320);
	  importWin1.setHeight(515);
	  importWin1.setWidth(1320);
	  
  <%}%>
	var customerPanel = new Ext.Panel({
   				standardSubmit: true,
    			collapsible: false,
    			id: 'customerMaster',
    			layout: 'table',
    			cls: 'innerpanelsmallest',
    			frame: false,
    			width: '100%',
    			layoutConfig: {
        		columns: 5
    			},
    			items: [{
	                	xtype: 'label',
	           		    text: '<%=selectCustomer%>' + ' :',
	            		cls: 'labelstyle',
	            		id: 'custnamelab'
		            },{
		                width: 30
		            },custnamecombo,
		              {
		                width: 50
		            },{
		                xtype: 'button',
		                text: 'View',
		                id: 'generateReport',
		                cls: 'buttonwastemanagement',
		                width: 60,
		                listeners: {
		                    click: {
		                        fn: function() {
	                               if (Ext.getCmp('custcomboId').getValue() == "") {
	                                  Ext.example.msg("Select customer");
	                                  Ext.getCmp('custcomboId').focus();
	                                  return;
	             				   }
		                           var custName=Ext.getCmp('custcomboId').getRawValue();
		                           store.load({
					                    params: {
					                        CustID: Ext.getCmp('custcomboId').getValue(),
					                        jspName: jspName,
					                        CustName: Ext.getCmp('custcomboId').getRawValue()
					                  }
					               });
		                        }
		                    }
		                }
		            }]
				});
	 //****************************** Inner Pannel  Adding Inforamtion ***************
   var vehicleAndOperatingMinePanel = new Ext.form.FormPanel({
    standardSubmit: true,
    collapsible: false,
    frame: false,
    height:412,
    id: 'addVehicleMineOperatingId',
    items: [{
        xtype: 'fieldset',
        title: '<%=vehicleAndOperatingMineDetails%>',
        id:'VehicleMinepanelId',
        collapsible: false,
        width: 400,
        height:412,
        layout: 'table',
        layoutConfig: {
            columns: 4
        },
        items: [{
                xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                id: 'mandatoryenrollNumber'
            },{
                xtype: 'label',
                text: '<%=enrollmentNumber%>'+'  :',
                cls: 'labelstyle',
                id: 'enrollmentNumberLabelId'
            },{width:37},{
			    xtype: 'textfield',
                cls: 'selectstylePerfect',               
                emptyText: '<%=enterEnrollmentNumber%>',
                blankText: '<%=enterEnrollmentNumber%>',
                id: 'enrollNumberId',
            },{
                xtype: 'label',
                text: '*',
                cls: 'mandatoryfield',
                id: 'mandatoryassetNumber'
            },{
                xtype: 'label',
                text: '<%=assetNumber%>'+'  :',
                cls: 'labelstyle',
                id: 'assetNumberLabelId'
            },{width:37},{
			    xtype: 'textfield',
                cls: 'selectstylePerfect', 
                maskRe: /[a-zA-Z0-9 ]/,
                emptyText: '<%=enterAssetNumber%>',
                blankText: '<%=enterAssetNumber%>',
                id: 'assetNumberId',
                mode: 'local',
                forceSelection: true,
                selectOnFocus: true,
                listeners: { change: function(f,n,o){ //restrict 25
					f.setValue(n.toUpperCase().trim());
					if(f.getValue().length> 25){ Ext.example.msg("Field exceeded it's Maximum length"); 
						f.setValue(n.substr(0,25).toUpperCase().trim()); f.focus(); }
				 } },
            },{
                xtype: 'label',
                text: '*',
                cls: 'mandatoryfield',
                id: 'mandatorydateRegDateTime'
            }, {
                xtype: 'label',
                text: '<%=RegistrationDate%>'+'  :',
                cls: 'labelstyle',
                id: 'registrationdateLabelId'
            },{width:37},{
                xtype: 'datefield',
                cls: 'selectstylePerfect',
                width: 185,
                format: getDateFormat(),
                emptyText: '<%=enterRegistrationDate%>',
                allowBlank: false,
                blankText: '<%=enterRegistrationDate%>',
                id: 'regstartdate',
                value: datecur
            },
            //-------------------------------//
            {
                xtype: 'label',
                text: '*',
                cls: 'mandatoryfield',
                id: 'mandatoryengineNumber'
            },{
                xtype: 'label',
                text: 'Engine Number'+'  :',
                cls: 'labelstyle',
                id: 'engineNumberLabelId'
            },{width:37},{
			    xtype: 'textfield',
                cls: 'selectstylePerfect', 
                //maskRe: /[a-zA-Z0-9 ]/,
                emptyText: 'Enter Engine Number',
                blankText: 'Enter Engine Number',
                id: 'engineNumberId',
                mode: 'local',
                forceSelection: true,
                selectOnFocus: true,
                listeners: { change: function(f,n,o){ //restrict 50
					f.setValue(n.toUpperCase().trim());
					if(f.getValue().length> 50){ Ext.example.msg("Field exceeded it's Maximum length"); 
						f.setValue(n.substr(0,50).toUpperCase().trim()); f.focus(); }
				 } },
            },{
                xtype: 'label',
                text: '*',
                cls: 'mandatoryfield',
                id: 'mandatorycarriageCapacity'
            },{
                xtype: 'label',
                text: '<%=carriageCapacity%>'+'  :',
                cls: 'labelstyle',
                id: 'carriageCapacityLabelId'
            },{width:37},{
			    xtype: 'numberfield',
                cls: 'selectstylePerfect',               
                stripCharsRe :/[,]/,
                emptyText: '<%=entercarriageCapacity%>',
                blankText: '<%=entercarriageCapacity%>',
                autoCreate: { //restricts 
                       tag: "input",
                       maxlength: 9,
                       autocomplete: "off"
                   },
                id: 'carriageCapacityId'
            },
            //--------------------------------//
            {
                xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                id: 'mandatoryoperatingOnMine'
            }, {
                xtype: 'label',
                text: '<%=operatingOnMine%>' +' :',
                cls: 'labelstyle',
                id: 'operatingOnMinenLabelId'
            },{width:37},{
                xtype: 'textfield',
                cls: 'selectstylePerfect',               
                stripCharsRe :/[,]/,
                emptyText: '<%=enteroperatingOnMine%>',
                blankText: '<%=enteroperatingOnMine%>',
                id: 'operatingOnMineId',
                 mode: 'local',
                forceSelection: true,
                selectOnFocus: true,
                listeners: { change: function(f,n,o){ //restrict 50
					f.setValue(n.toUpperCase().trim());
					if(f.getValue().length> 50){ Ext.example.msg("Field exceeded it's Maximum length"); 
						f.setValue(n.substr(0,50).toUpperCase().trim()); f.focus(); }
				} },
            },
            {
                xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                id: 'mandatorylocation'
            }, {
                xtype: 'label',
                text: '<%=location%>' +' :',
                cls: 'labelstyle',
                id: 'locationLabelId'
            },{width:37},{
                xtype: 'textfield',
                cls: 'selectstylePerfect',               
                stripCharsRe :/[,]/,
                emptyText: '<%=enterLocation%>',
                blankText: '<%=enterLocation%>',
                id: 'locationId',
                 mode: 'local',
                forceSelection: true,
                selectOnFocus: true,
                listeners: { change: function(f,n,o){ //restrict 500
					f.setValue(n.toUpperCase().trim());
					if(f.getValue().length> 500){ Ext.example.msg("Field exceeded it's Maximum length"); 
						f.setValue(n.substr(0,500).toUpperCase().trim()); f.focus(); }
				 } },
            },
			{
                xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                id: 'mandatoryMiningLeaseNo'
            }, {
                xtype: 'label',
                text: '<%=MiningLeaseNo%>' +' :',
                cls: 'labelstyle',
                id: 'MiningLeaseNoLabelId'
            },{width:37},{
                xtype: 'textfield',
                cls: 'selectstylePerfect',               
                stripCharsRe :/[,]/,
                emptyText: '<%=enterMiningLeaseNo%>',
                blankText: '<%=enterMiningLeaseNo%>',
                id: 'MiningLeaseNoId',
                 mode: 'local',
                forceSelection: true,
                selectOnFocus: true,
                listeners: { change: function(f,n,o){ //restrict 50
				f.setValue(n.toUpperCase().trim());
				if(f.getValue().length> 50){ Ext.example.msg("Field exceeded it's Maximum length"); 
					f.setValue(n.substr(0,50).toUpperCase().trim()); f.focus(); }
			 } },
            },
			{
                xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                id: 'mandatoryChassisNo'
            }, {
                xtype: 'label',
                text: '<%=ChassisNo%>' +' :',
                cls: 'labelstyle',
                id: 'ChassisNoLabelId'
            },{width:37},{
                xtype: 'textfield',
                cls: 'selectstylePerfect',               
                stripCharsRe :/[,]/,
                emptyText: '<%=enterChassisNo%>',
                blankText: '<%=enterChassisNo%>',
                id: 'ChassisNoId',
                mode: 'local',
                forceSelection: true,
                selectOnFocus: true,
                listeners: { change: function(f,n,o){ //restrict 25
					f.setValue(n.toUpperCase().trim());
					if(f.getValue().length> 25){ Ext.example.msg("Field exceeded it's Maximum length"); 
						f.setValue(n.substr(0,25).toUpperCase().trim()); f.focus(); }
				 } },
            },
            {
                xtype: 'label',
                text: '*',
                cls: 'mandatoryfield',
                id: 'mandatoryinsurranceNo'
            }, {
                xtype: 'label',
                text: 'Insurance Policy No' +' :',
                cls: 'labelstyle',
                id: 'InsurranceNoLabelId'
            },{width:37},{
             xtype: 'textfield',
                cls: 'selectstylePerfect', 
                maskRe: /[a-zA-Z0-9 ]/,
                emptyText: 'Enter Insurance No',
                blankText: 'Enter Insurance No',
                id: 'InsuranceNoId',
                mode: 'local',
                forceSelection: true,
                selectOnFocus: true,
                listeners: { change: function(f,n,o){ //restrict 50
					f.setValue(n.toUpperCase().trim());
					if(f.getValue().length> 50){ Ext.example.msg("Field exceeded it's Maximum length"); 
						f.setValue(n.substr(0,50).toUpperCase().trim()); f.focus(); }
				 } },
            },
            {
                xtype: 'label',
                text: '*',
                cls: 'mandatoryfield',
                id: 'expirydate'
            }, {
                xtype: 'label',
                text: 'Insurance ExpiryDate' +' :',
                cls: 'labelstyle',
                id: 'Insurranceexpirydate'
            },{width:37},{
                xtype: 'datefield',
                cls: 'selectstylePerfect',
                width: 185,
                format: getDateFormat(),
                emptyText: 'Enter the Expiry date',
                allowBlank: false,
                blankText: 'Enter the Expiry date',
                id: 'InsuranceexpiryId',
                minValue:datecur,
                value: datecur
            },
            {
                xtype: 'label',
                text: '*',
                cls: 'mandatoryfield',
                id: 'pucnumber'
            }, {
                xtype: 'label',
                text: 'Puc Number' +' :',
                cls: 'labelstyle',
                id: 'pucno'
            },{width:37},{
            
            xtype: 'textfield',
                cls: 'selectstylePerfect', 
                maskRe: /[a-zA-Z0-9 ]/,
                emptyText: 'Enter Puc No',
                blankText: 'Enter Puc No',
                id: 'pucnoid',
                mode: 'local',
                forceSelection: true,
                selectOnFocus: true,
                listeners: { change: function(f,n,o){ //restrict 50
					f.setValue(n.toUpperCase().trim());
					if(f.getValue().length> 50){ Ext.example.msg("Field exceeded it's Maximum length"); 
						f.setValue(n.substr(0,50).toUpperCase().trim()); f.focus(); }
				} },
            }, {
                xtype: 'label',
                text: '*',
                cls: 'mandatoryfield',
                id: 'pucexpirydate'
            }, {
                xtype: 'label',
                text: 'Puc Expiry Date' +' :',
                cls: 'labelstyle',
                id: 'pucdate'
            },{width:37},{
               xtype: 'datefield',
                cls: 'selectstylePerfect',
                width: 185,
                format: getDateFormat(),
                emptyText: 'Enter the PUC  Expiry date',
                allowBlank: false,
                blankText: 'Enter the PUC Expiry date',
                id: 'pucdateid',
                minValue:datecur,
                value: datecur
                
               } ,{
                xtype: 'label',
                text: '*',
                cls: 'mandatoryfield',
                id: 'roadTaxvaliditydate'
            }, {
                xtype: 'label',
                text: 'Road Tax Validity Date' +' :',
                cls: 'labelstyle',
                id: 'roadTaxvalidityLabel'
            },{width:37},{
               xtype: 'datefield',
                cls: 'selectstylePerfect',
                width: 185,
                format: getDateFormat(),
                emptyText: 'Enter Road Tax Validity date',
                allowBlank: false,
                blankText: 'Enter Road Tax Validity date',
                id: 'roadTaxvalidityId',
                minValue:datecur,
                value: datecur
               } ,{
                xtype: 'label',
                text: '*',
                cls: 'mandatoryfield',
                id: 'permitvaliditydate'
            }, {
                xtype: 'label',
                text: 'Permit Validity Date' +' :',
                cls: 'labelstyle',
                id: 'permitvalidityLabel'
            },{width:37},{
               xtype: 'datefield',
                cls: 'selectstylePerfect',
                width: 185,
                format: getDateFormat(),
                emptyText: 'Enter Permit Validity date',
                allowBlank: false,
                blankText: 'Enter Permit Validity date',
                id: 'permitvalidityId',
                minValue:datecur,
                value: datecur
               } 
            ]
		 }]
});		
//****************************************asset Owner Details*******************************//
   var assetOwnerDetailsPanel = new Ext.form.FormPanel({
    standardSubmit: true,
    collapsible: false,
    //autoScroll: true,
    height:412,
    frame: false,
    id: 'AssetOwnerDetailsId',
    items: [{
        xtype: 'fieldset',
        title: '<%=AssetOwnerDetails%>',
        id:'AssetOwnerDetailspanelId',
        collapsible: false,
        width: 400,
        height:412,
        layout: 'table',
        layoutConfig: {
            columns: 4
        },
        items: [{
                xtype: 'label',
                text: '*',
                cls: 'mandatoryfield',
                id: 'mandatoryownerName'
            },{
                xtype: 'label',
                text: '<%=OwnerName%>'+'  :',
                cls: 'labelstyle',
                id: 'OwnerNameLabelId'
            },{width:10},{
			    xtype: 'textfield',
                cls: 'selectstylePerfect',               
                stripCharsRe :/[,]/,
                emptyText: '<%=enterOwnerName%>',
                blankText: '<%=enterOwnerName%>',
                id: 'OwnerNameId',
                 mode: 'local',
                forceSelection: true,
                selectOnFocus: true,
                listeners: { change: function(f,n,o){ //restrict 50
					f.setValue(n.toUpperCase().trim());
					if(f.getValue().length> 50){ Ext.example.msg("Field exceeded it's Maximum length"); 
						f.setValue(n.substr(0,50).toUpperCase().trim()); f.focus(); }
				} },
            },{
                xtype: 'label',
                text: '*',
                cls: 'mandatoryfield',
                id: 'mandatoryAssemblyName'
            },{
                xtype: 'label',
                text: '<%=AssemblyConstituency%>'+'  :',
                cls: 'labelstyle',
                id: 'AssemblyNameLabelId'
            },{width:10},{
			    xtype: 'textfield',
                cls: 'selectstylePerfect',               
                stripCharsRe :/[,]/,
                emptyText: '<%=enterAssemblyConstituency%>',
                blankText: '<%=enterAssemblyConstituency%>',
                id: 'AssemblyNameId',
                 mode: 'local',
                forceSelection: true,
                selectOnFocus: true,
                listeners: { change: function(f,n,o){ //restrict 50
					f.setValue(n.toUpperCase().trim());
					if(f.getValue().length> 50){ Ext.example.msg("Field exceeded it's Maximum length"); 
						f.setValue(n.substr(0,50).toUpperCase().trim()); f.focus(); }
				} },
            },{
                xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                id: 'mandatoryhouseNo'
            }, {
                xtype: 'label',
                text: '<%=houseNo%>'+'  :',
                cls: 'labelstyle',
                id: 'houseNoLabelId'
            },{width:10},{
                xtype: 'textfield',
                cls: 'selectstylePerfect',               
                stripCharsRe :/[,]/,
                emptyText: '<%=enterHouseNo%>',
                blankText: '<%=enterHouseNo%>',
                listeners: { change: function(f,n,o){ //restrict 50
					if(f.getValue().length> 50){ Ext.example.msg("Field exceeded it's Maximum length"); 
						f.setValue(n.substr(0,50)); f.focus(); }
				} },
                id: 'houseNoId'
            },
            //-------------------------------//
            {
                xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                id: 'mandatoryLocality'
            },{
                xtype: 'label',
                text: '<%=Locality%>'+'  :',
                cls: 'labelstyle',
                id: 'LocalityLabelId'
            },{width:10},{
			    xtype: 'textfield',
                cls: 'selectstylePerfect',               
                stripCharsRe :/[,]/,
                emptyText: '<%=enterLocality%>',
                blankText: '<%=enterLocality%>',
                id: 'LocalityId',
                 mode: 'local',
                forceSelection: true,
                selectOnFocus: true,
                listeners: { change: function(f,n,o){ //restrict 50
					f.setValue(n.toUpperCase().trim());
					if(f.getValue().length> 50){ Ext.example.msg("Field exceeded it's Maximum length"); 
						f.setValue(n.substr(0,50).toUpperCase().trim()); f.focus(); }
				} },
            },
            //--------------------------------//
            {
                xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                id: 'mandatoryCity'
            }, {
                xtype: 'label',
                text: '<%=City%>' +' :',
                cls: 'labelstyle',
                id: 'CityLabelId'
            },{width:10},{
                xtype: 'textfield',
                cls: 'selectstylePerfect',               
                stripCharsRe :/[,]/,
                emptyText: '<%=enterCity%>',
                blankText: '<%=enterCity%>',
                id: 'enterCityId',
                 mode: 'local',
                forceSelection: true,
                selectOnFocus: true,
                listeners: { change: function(f,n,o){ //restrict 50
					f.setValue(n.toUpperCase().trim());
					if(f.getValue().length> 50){ Ext.example.msg("Field exceeded it's Maximum length"); 
						f.setValue(n.substr(0,50).toUpperCase().trim()); f.focus(); }
				} },
            },
            {
                xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                id: 'mandatorytaluka'
            }, {
                xtype: 'label',
                text: '<%=taluka%>' +' :',
                cls: 'labelstyle',
                id: 'talukaLabelId'
            },{width:10},{
                xtype: 'textfield',
                cls: 'selectstylePerfect',               
                stripCharsRe :/[,]/,
                emptyText: '<%=enterTaluka%>',
                blankText: '<%=enterTaluka%>',
                id: 'talukaId',
                 mode: 'local',
                forceSelection: true,
                selectOnFocus: true,
                listeners: { change: function(f,n,o){ //restrict 50
					f.setValue(n.toUpperCase().trim());
					if(f.getValue().length> 50){ Ext.example.msg("Field exceeded it's Maximum length"); 
						f.setValue(n.substr(0,50).toUpperCase().trim()); f.focus(); }
				} },
            },
			{
                xtype: 'label',
                text: '*',
                cls: 'mandatoryfield',
                id: 'mandatorystate'
            }, {
                xtype: 'label',
                text: '<%=state%>' +' :',
                cls: 'labelstyle',
                id: 'stateLabelId'
            },{width:10},stateCombo,{
                xtype: 'label',
                text: '*',
                cls: 'mandatoryfield',
                id: 'mandatoryDistrict'
            }, {
                xtype: 'label',
                text: '<%=District%>' +' :',
                cls: 'labelstyle',
                id: 'DistrictLabelId'
            },{width:10},districtCombo,
			{
                xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                id: 'mandatoryEPICNo'
            }, {
                xtype: 'label',
                text: '<%=EPICNo%>' +' :',
                cls: 'labelstyle',
                id: 'EPICNoLabelId'
            },{width:10},{
                xtype: 'textfield',
                cls: 'selectstylePerfect',               
                stripCharsRe :/[,]/,
                emptyText: '<%=enterEpicNo%>',
                blankText: '<%=enterEpicNo%>',
                id: 'EPICNoId',
                 mode: 'local',
                forceSelection: true,
                selectOnFocus: true,
                lilisteners: { change: function(f,n,o){ //restrict 50
					f.setValue(n.toUpperCase().trim());
					if(f.getValue().length> 50){ Ext.example.msg("Field exceeded it's Maximum length"); 
						f.setValue(n.substr(0,50).toUpperCase().trim()); f.focus(); }
				} },
            },
			{
                xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                id: 'mandatoryPANNo'
            }, {
                xtype: 'label',
                text: '<%=PANNo%>' +' :',
                cls: 'labelstyle',
                id: 'PANNoLabelId'
            },{width:10},{
                xtype: 'textfield',
                cls: 'selectstylePerfect',               
                stripCharsRe :/[,]/,
                emptyText: '<%=enterPanNo%>',
                blankText: '<%=enterPanNo%>',
                listeners: { change: function(f,n,o){ //restrict 50
					f.setValue(n.toUpperCase().trim());
					if(f.getValue().length> 50){ Ext.example.msg("Field exceeded it's Maximum length"); 
						f.setValue(n.substr(0,50).toUpperCase().trim()); f.focus(); }
				} },
                id: 'PANNoId'
            },
			{
                xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                id: 'mandatoryMobileNo'
            }, {
                xtype: 'label',
                text: '<%=MobileNo%>' +' :',
                cls: 'labelstyle',
                id: 'MobileNoLabelId'
            },{width:10},{
                xtype: 'numberfield',
                cls: 'selectstylePerfect',               
                stripCharsRe :/[,]/,
                emptyText: '<%=enterMobileNumber%>',
                blankText: '<%=enterMobileNumber%>',
               autoCreate: { //restricts 
                       tag: "input",
                       maxlength: 10,
                       type: "text",
                       size: "200",
                       autocomplete: "off"
                   },
                id: 'MobileNoId'
            },
			{
                xtype: 'label',
                text: '',
                cls: 'mndatoryfield',
                id: 'mandatoryPhoneNo'
            }, {
                xtype: 'label',
                text: '<%=PhoneNo%>' +' :',
                cls: 'labelstyle',
                id: 'PhoneNoLabelId'
            },{width:10},{
                xtype: 'numberfield',
                cls: 'selectstylePerfect',               
                emptyText: '<%=enterPhoneNumber%>',
                blankText: '<%=enterPhoneNumber%>',
                autoCreate: { //restricts 
                       tag: "input",
                       maxlength: 15,
                       type: "text",
                       size: "200",
                       autocomplete: "off"
                   },
                id: 'PhoneNoId'
            },
			{
                xtype: 'label',
                text: '',
                cls: 'mndatoryfield',
                id: 'mandatoryAdharNo'
            }, {
                xtype: 'label',
                text: '<%=AdharNo%>' +' :',
                cls: 'labelstyle',
                id: 'AdharNoId'
            },{width:10},{
                xtype: 'textfield',
                cls: 'selectstylePerfect',               
                stripCharsRe :/[,]/,
                emptyText: '<%=enterAdharNo%>',
                blankText: '<%=enterAdharNo%>',
                autoCreate: { //restricts 
                       tag: "input",
                       maxlength: 16,
                       type: "text",
                       autocomplete: "off"
                   },
                id: 'adharNoId'
            },{
                xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                id: 'mandatorydateEnrollDate'
            },{
                xtype: 'label',
                text: '<%=enrollmentDate%>'+'  :',
                cls: 'labelstyle',
                id: 'EnrollDateLabelId'
            },{width:10},{
                xtype: 'datefield',
                cls: 'selectstylePerfect',
                width: 185,
                format: getDateFormat(),
                emptyText: '<%=enterEnrollmentDate%>',
                allowBlank: false,
                blankText: '<%=enterEnrollmentDate%>',
                id: 'EnrollDateId',
                value: datecur
            }]
		 }]
});	
//*****************************************bank details**************************************//
var bankDetailsPanel = new Ext.form.FormPanel({
    standardSubmit: true,
    collapsible: false,
    frame: false,
    id: 'bankDetailsId',
    items: [{
        xtype: 'fieldset',
        title: '<%=hypothicationDetails%>',
        id:'bankDetailspanelId',
        collapsible: false,
        width: 400,
        height:200,
        layout: 'table',
        layoutConfig: {
            columns: 5
        },
        items: [{
                xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                id: 'mandatorybank'
            },{
                xtype: 'label',
                text: '<%=Bank%>'+'  :',
                cls: 'labelstyle',
                id: 'BankLabelId'
            },{width:37},{
			    xtype: 'textfield',
                cls: 'selectstylePerfect',               
                stripCharsRe :/[,]/,
                emptyText: '<%=enterBank%>',
                blankText: '<%=enterBank%>',
                id: 'BankId',
                 mode: 'local',
                forceSelection: true,
                selectOnFocus: true,
                listeners: { change: function(f,n,o){ //restrict 50
				f.setValue(n.toUpperCase().trim());
				if(f.getValue().length> 50){ Ext.example.msg("Field exceeded it's Maximum length"); 
					f.setValue(n.substr(0,50).toUpperCase().trim()); f.focus(); }
			 } },
            },{
                xtype: 'label',
                text: '',
                cls: 'labelstyle',
                id: 'mandatorybank1'
            },{
                xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                id: 'mandatoryBranch'
            }, {
                xtype: 'label',
                text: '<%=Branch%>'+'  :',
                cls: 'labelstyle',
                id: 'BranchLabelId'
            },{width:37},{
                xtype: 'textfield',
                cls: 'selectstylePerfect',               
                stripCharsRe :/[,]/,
                emptyText: '<%=enterBranch%>',
                blankText: '<%=enterBranch%>',
                id: 'BranchId',
                 mode: 'local',
                forceSelection: true,
                selectOnFocus: true,
                listeners: { change: function(f,n,o){ //restrict 50
				f.setValue(n.toUpperCase().trim());
				if(f.getValue().length> 50){ Ext.example.msg("Field exceeded it's Maximum length"); 
					f.setValue(n.substr(0,50).toUpperCase().trim()); f.focus(); }
			 } },
            },{
                xtype: 'label',
                text: '',
                cls: 'labelstyle',
                id: 'mandatorybank2'
            },
            //-------------------------------//
            {
                xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                id: 'mandatoryPrincipalBalance'
            },{
                xtype: 'label',
                text: '<%=PrincipalBalance%>'+'  :',
                cls: 'labelstyle',
                id: 'PrincipalBalanceLabelId'
            },{width:37},{
			    xtype: 'numberfield',
                cls: 'selectstylePerfect',               
                stripCharsRe :/[,]/,
                emptyText: '<%=enterPrincipalBalance%>',
                blankText: '<%=enterPrincipalBalance%>',
                id: 'PrincipalBalanceId',
                autoCreate: { tag: "input",autocomplete: "off",maxlength: 9 },
				listeners:{ change: function(f, n, o){ f.setValue(Math.abs(n)); } },
                 mode: 'local',
                forceSelection: true,
                selectOnFocus: true,
            },{
                xtype: 'label',
                text: '(Rs)',
                cls: 'labelstyle',
                id: 'mandatorybank3'
            },
            //--------------------------------//
            {
                xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                id: 'mandatoryPrincipalOverDues'
            }, {
                xtype: 'label',
                text: '<%=PrincipalOverDues%>' +' :',
                cls: 'labelstyle',
                id: 'PrincipalOverDuesLabelId'
            },{width:37},{
                xtype: 'numberfield',
                cls: 'selectstylePerfect',               
                stripCharsRe :/[,]/,
                emptyText: '<%=enterPrincipalOverDues%>',
                blankText: '<%=enterPrincipalOverDues%>',
                autoCreate: { tag: "input",autocomplete: "off",maxlength: 9 },
				listeners:{ change: function(f, n, o){ f.setValue(Math.abs(n)); } },
                id: 'PrincipalOverDuesId'
            },{
                xtype: 'label',
                text: '(Rs)',
                cls: 'labelstyle',
                id: 'mandatorybank4'
            },
            {
                xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                id: 'mandatoryInterestBalance'
            }, {
                xtype: 'label',
                text: '<%=InterestBalance%>' +' :',
                cls: 'labelstyle',
                id: 'InterestBalanceLabelId'
            },{width:37},{
                xtype: 'numberfield',
                cls: 'selectstylePerfect',               
                stripCharsRe :/[,]/,
                emptyText: '<%=enterInterestBalance%>',
                blankText: '<%=enterInterestBalance%>',
                autoCreate: { tag: "input",autocomplete: "off",maxlength: 9 },
				listeners:{ change: function(f, n, o){ f.setValue(Math.abs(n)); } },
                id: 'InterestBalanceId'
            },{
                xtype: 'label',
                text: '(Rs)',
                cls: 'labelstyle',
                id: 'mandatorybank5'
            },
			{
                xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                id: 'mandatoryAccountNo'
            }, {
                xtype: 'label',
                text: '<%=AccountNo%>' +' :',
                cls: 'labelstyle',
                id: 'AccountNoLabelId'
            },{width:37},{
                xtype: 'textfield',
                cls: 'selectstylePerfect',               
                stripCharsRe :/[,]/,
                emptyText: '<%=enterAccountNo%>',
                blankText: '<%=enterAccountNo%>',
                id: 'AccountNoId',
                 mode: 'local',
                forceSelection: true,
                selectOnFocus: true,
                listeners: { change: function(f,n,o){ //restrict 50
					f.setValue(n.toUpperCase().trim());
					if(f.getValue().length> 50){ Ext.example.msg("Field exceeded it's Maximum length"); 
						f.setValue(n.substr(0,50).toUpperCase().trim()); f.focus(); }
				 } },
            },{
                xtype: 'label',
                text: '',
                cls: 'labelstyle',
                id: 'mandatorybank6'
            }]
		 }]
});
var caseInnerPanel = new Ext.Panel({
       standardSubmit: true,
       collapsible: false,
       autoScroll: true,
       width: 1250,
       height:425,
       frame: true,
       id: 'addCaseInfo',
       layout: 'table',
       layoutConfig: {
           columns: 3
       },
           items: [vehicleAndOperatingMinePanel,assetOwnerDetailsPanel,bankDetailsPanel]
   });
    //****************************** Window For Adding Trip Information****************************
   var winButtonPanel = new Ext.Panel({
    id: 'winbuttonid',
    standardSubmit: true,
    collapsible: false,
    height:70,
    cls: 'windowbuttonpanel',
    frame: true,
    layout: 'table',
    layoutConfig: {
        columns: 3
    },
    items: [{
        width: 550
    }, {
        xtype: 'button',
        text: '<%=save%>',
        id: 'addButtId',
        cls: 'buttonstyle',
        iconCls : 'savebutton',
        width: 80,
        listeners: {
            click: {
                fn: function () {
                var globalClientId=Ext.getCmp('custcomboId').getValue();
                var customerName=Ext.getCmp('custcomboId').getRawValue();
                var vehicleNo=Ext.getCmp('assetNumberId').getValue();
                if (Ext.getCmp('assetNumberId').getValue() == "") {
				    Ext.example.msg("<%=enterAssetNumber%>");
				    Ext.getCmp('assetNumberId').focus();
				    return;
				    }
				if (Ext.getCmp('regstartdate').getValue() == "") {
				    Ext.example.msg("<%=enterRegistrationDate%>");
				    Ext.getCmp('regstartdate').focus();
				    return;
				    }
				if (Ext.getCmp('engineNumberId').getValue() == "") {
				    Ext.example.msg("Enter Engine Number");
				    Ext.getCmp('engineNumberId').focus();
				    return;
				    }    
				if (Ext.getCmp('carriageCapacityId').getValue() == "") {
				    Ext.example.msg("<%=entercarriageCapacity%>");
				    Ext.getCmp('carriageCapacityId').focus();
				    return;
				    }
<!--				if (Ext.getCmp('operatingOnMineId').getValue() == "") {-->
<!--				    Ext.example.msg("<%=enteroperatingOnMine%>");-->
<!--				    Ext.getCmp('operatingOnMineId').focus();-->
<!--				    return;-->
<!--				    }-->
<!--				if (Ext.getCmp('locationId').getValue() == "") {-->
<!--				    Ext.example.msg("<%=enterLocation%>");-->
<!--				    Ext.getCmp('locationId').focus();-->
<!--				    return;-->
<!--				    }-->
<!--				if (Ext.getCmp('MiningLeaseNoId').getValue() == "") {-->
<!--				    Ext.example.msg("<%=enterMiningLeaseNo%>");-->
<!--				    Ext.getCmp('MiningLeaseNoId').focus();-->
<!--				    return;-->
<!--				    }-->
                    if (Ext.getCmp('InsuranceNoId').getValue() == "") {
					    Ext.example.msg("Enter Insurance  No");
					    Ext.getCmp('InsuranceNoId').focus();
					    return;
					    }

                    if (Ext.getCmp('InsuranceexpiryId').getValue() == "") {
					    Ext.example.msg("Enter Insurance Expiry date");
					    Ext.getCmp('InsuranceexpiryId').focus();
					    return;
					    }

                  if (Ext.getCmp('pucnoid').getValue() == "") {
				    Ext.example.msg("Enter PUC No");
				    Ext.getCmp('pucnoid').focus();
				    return;
				    }

                  if (Ext.getCmp('pucdateid').getValue() == "") {
				    Ext.example.msg("Enter PUC Expiry date");
				    Ext.getCmp('pucdateid').focus();
				    return;
				    }
				    if (Ext.getCmp('roadTaxvalidityId').getValue() == "") {
				    Ext.example.msg("Enter Road Tax Validity date");
				    Ext.getCmp('roadTaxvalidityId').focus();
				    return;
				    }
				    if (Ext.getCmp('permitvalidityId').getValue() == "") {
				    Ext.example.msg("Enter Permit Validity date");
				    Ext.getCmp('permitvalidityId').focus();
				    return;
				    }

				   if (Ext.getCmp('OwnerNameId').getValue() == "") {
				    Ext.example.msg("<%=enterOwnerName%>");
				    Ext.getCmp('OwnerNameId').focus();
				    return;
				    }
				   if (Ext.getCmp('AssemblyNameId').getValue() == "") {
					    Ext.example.msg("<%=enterAssemblyConstituency%>");
					    Ext.getCmp('AssemblyNameId').focus();
					    return;
					    }
<!--				if (Ext.getCmp('LocalityId').getValue() == "") {-->
<!--				    Ext.example.msg("<%=enterLocality%>");-->
<!--				    Ext.getCmp('LocalityId').focus();-->
<!--				    return;-->
<!--				    }-->
<!--				if (Ext.getCmp('enterCityId').getValue() == "") {-->
<!--				    Ext.example.msg("<%=enterCity%>");-->
<!--				    Ext.getCmp('enterCityId').focus();-->
<!--				    return;-->
<!--				    }-->
<!--				if (Ext.getCmp('talukaId').getValue() == "") {-->
<!--				    Ext.example.msg("<%=enterTaluka%>");-->
<!--				    Ext.getCmp('talukaId').focus();-->
<!--				    return;-->
<!--				    }-->

                  if (Ext.getCmp('statecomboId').getValue() == "") {
				    Ext.example.msg("<%=enterState%>");
				    Ext.getCmp('statecomboId').focus();
				    return;
				    } 
				  if (Ext.getCmp('districtcomboId').getValue() == "") {
				    Ext.example.msg("<%=enterDistrict%>");
				    Ext.getCmp('districtcomboId').focus();
				    return;
				    }
				
<!--				if (Ext.getCmp('EPICNoId').getValue() == "") {-->
<!--				    Ext.example.msg("<%=enterEpicNo%>");-->
<!--				    Ext.getCmp('EPICNoId').focus();-->
<!--				    return;-->
<!--				    }-->
<!--				if (Ext.getCmp('PANNoId').getValue() == "") {-->
<!--				    Ext.example.msg("<%=enterPanNo%>");-->
<!--				    Ext.getCmp('PANNoId').focus();-->
<!--				    return;-->
<!--				    }-->
<!--				if (Ext.getCmp('MobileNoId').getValue() == "") {-->
<!--				    Ext.example.msg("<%=enterMobileNumber%>");-->
<!--				    Ext.getCmp('MobileNoId').focus();-->
<!--				    return;-->
<!--				    }-->
<!--				if (Ext.getCmp('PhoneNoId').getValue() == "") {-->
<!--				    Ext.example.msg("<%=enterPhoneNumber%>");-->
<!--				    Ext.getCmp('PhoneNoId').focus();-->
<!--				    return;-->
<!--				    }-->
<!--				if (Ext.getCmp('BankId').getValue() == "") {-->
<!--				    Ext.example.msg("<%=enterBank%>");-->
<!--				    Ext.getCmp('BankId').focus();-->
<!--				    return;-->
<!--				    }-->
<!--				if (Ext.getCmp('BranchId').getValue() == "") {-->
<!--				    Ext.example.msg("<%=enterBranch%>");-->
<!--				    Ext.getCmp('BranchId').focus();-->
<!--				    return;-->
<!--				    }	-->
<!--				if (Ext.getCmp('PrincipalBalanceId').getValue() == "") {-->
<!--				    Ext.example.msg("<%=enterPrincipalBalance%>");-->
<!--				    Ext.getCmp('PrincipalBalanceId').focus();-->
<!--				    return;-->
<!--				    }-->
<!--				if (Ext.getCmp('PrincipalOverDuesId').getValue() == "") {-->
<!--				    Ext.example.msg("<%=enterPrincipalOverDues%>");-->
<!--				    Ext.getCmp('PrincipalOverDuesId').focus();-->
<!--				    return;-->
<!--				    }	-->
<!--				if (Ext.getCmp('InterestBalanceId').getValue() == "") {-->
<!--				    Ext.example.msg("<%=enterInterestBalance%>");-->
<!--				    Ext.getCmp('InterestBalanceId').focus();-->
<!--				    return;-->
<!--				    }-->
<!--				if (Ext.getCmp('AccountNoId').getValue() == "") {-->
<!--				    Ext.example.msg("<%=enterAccountNo%>");-->
<!--				    Ext.getCmp('AccountNoId').focus();-->
<!--				    return;-->
<!--				    }	      -->
//--------------------------------------------------------------------------------------------------------------------//
				if (buttonValue == 'modify') {
                        var selected = grid.getSelectionModel().getSelected();
                        uniqueId = selected.get('uniqueIdDataIndex');
                        
                        if (selected.get('StateIndex') != Ext.getCmp('statecomboId').getValue()) {
                            stateModify = Ext.getCmp('statecomboId').getValue();
                        } else {
                            stateModify = selected.get('StateIndex');
                        }
                        if (selected.get('DistrictIndex') != Ext.getCmp('districtcomboId').getValue()) {
                            districtModify = Ext.getCmp('districtcomboId').getValue();
                        } else {
                            districtModify = selected.get('DistrictIndex');
                        }
                     }
                    myWin.getEl().mask();
                    //Performs Save Operation
                     //Ajax request starts here
                        Ext.Ajax.request({
                            url: '<%=request.getContextPath()%>/MiningAssetEnrollment.do?param=saveormodifyAssetEnrollment',
                            method: 'POST',
                            params: {
                            buttonValue:buttonValue,
                            CustID: Ext.getCmp('custcomboId').getValue(),
                            AssetNo:Ext.getCmp('assetNumberId').getValue(),
							RegDate:Ext.getCmp('regstartdate').getValue(),
							engineNo:Ext.getCmp('engineNumberId').getValue(),
							CarriageCapacity:Ext.getCmp('carriageCapacityId').getValue(),
							operationMine:Ext.getCmp('operatingOnMineId').getValue(),
							location:Ext.getCmp('locationId').getValue(),
							leaseNo:Ext.getCmp('MiningLeaseNoId').getValue(),
							ChassisNo:Ext.getCmp('ChassisNoId').getValue(),
							InsurancePolicyNo:Ext.getCmp('InsuranceNoId').getValue(),
							InsuranceExpiryDate:Ext.getCmp('InsuranceexpiryId').getValue(),
							PucNumber:Ext.getCmp('pucnoid').getValue(),
							PucExpiryDate:Ext.getCmp('pucdateid').getValue(),
	                        ownerName:Ext.getCmp('OwnerNameId').getValue(),
							houseNo:Ext.getCmp('houseNoId').getValue(),
							locality:Ext.getCmp('LocalityId').getValue(),
							city:Ext.getCmp('enterCityId').getValue(),
							taluk:Ext.getCmp('talukaId').getValue(),
							district:Ext.getCmp('districtcomboId').getValue(),
							state:Ext.getCmp('statecomboId').getValue(),
							epicNo:Ext.getCmp('EPICNoId').getValue(),
							panNo:Ext.getCmp('PANNoId').getValue(),
							MobileNo:Ext.getCmp('MobileNoId').getValue(),
							PhoneNo:Ext.getCmp('PhoneNoId').getValue(),
							adharNo:Ext.getCmp('adharNoId').getValue(),
							EnrollDate:Ext.getCmp('EnrollDateId').getValue(),
							Bank:Ext.getCmp('BankId').getValue(),
							Branch:Ext.getCmp('BranchId').getValue(),
							princiaplBal:Ext.getCmp('PrincipalBalanceId').getValue(),
							overDues:Ext.getCmp('PrincipalOverDuesId').getValue(),
							InterestBal:Ext.getCmp('InterestBalanceId').getValue(),
							AccountNo:Ext.getCmp('AccountNoId').getValue(),
							uniqueId:uniqueId,
							CustName: Ext.getCmp('custcomboId').getRawValue(),
							assemblyName:Ext.getCmp('AssemblyNameId').getValue(),
							roadTaxValidityDate :Ext.getCmp('roadTaxvalidityId').getValue(),
							permitValidityDate :Ext.getCmp('permitvalidityId').getValue()
                            },
                            success: function (response, options) {
								var message = response.responseText;
								Ext.example.msg(message);
								if (message=='<p>Asset Number Already Enrolled.</p>') {
									Ext.example.msg(message);
								} else {
									window.open("<%=request.getContextPath()%>/AssetEnrollmentPdf?systemId=" + <%=systemId%> +"&clientId=" + globalClientId+"&clientName="+customerName+"&vehicleNo="+vehicleNo);
								}
                        		Ext.getCmp('assetNumberId').reset();
                        		Ext.getCmp('engineNumberId').reset();
								Ext.getCmp('regstartdate').reset();
								Ext.getCmp('carriageCapacityId').reset();
								Ext.getCmp('operatingOnMineId').reset();
								Ext.getCmp('locationId').reset();
								Ext.getCmp('MiningLeaseNoId').reset();
								Ext.getCmp('InsuranceNoId').reset();
								Ext.getCmp('InsuranceexpiryId').reset();
								Ext.getCmp('pucnoid').reset();
								Ext.getCmp('pucdateid').reset();
								Ext.getCmp('OwnerNameId').reset();
								Ext.getCmp('AssemblyNameId').reset();
								Ext.getCmp('houseNoId').reset();
								Ext.getCmp('LocalityId').reset();
								Ext.getCmp('enterCityId').reset();
								Ext.getCmp('talukaId').reset();
								Ext.getCmp('districtcomboId').reset();
								Ext.getCmp('statecomboId').reset();
								Ext.getCmp('EPICNoId').reset();
								Ext.getCmp('PANNoId').reset();
								Ext.getCmp('MobileNoId').reset();
								Ext.getCmp('PhoneNoId').reset();
								Ext.getCmp('BankId').reset();
								Ext.getCmp('BranchId').reset();
								Ext.getCmp('PrincipalBalanceId').reset();
								Ext.getCmp('PrincipalOverDuesId').reset();
								Ext.getCmp('InterestBalanceId').reset();
								Ext.getCmp('AccountNoId').reset();
								Ext.getCmp('ChassisNoId').reset();
								Ext.getCmp('adharNoId').reset();
								Ext.getCmp('EnrollDateId').reset();
								Ext.getCmp('roadTaxvalidityId').reset();
								Ext.getCmp('permitvalidityId').reset();
                    			myWin.hide();
                    			myWin.getEl().unmask();  
                            },
                            failure: function () {
								Ext.example.msg("Error");
								myWin.hide();
                            }
                        });
                }
            }
        }
    }, {
        xtype: 'button',
        text: '<%=cancel%>',
        id: 'canButtId',
        cls: 'buttonstyle',
        iconCls : 'cancelbutton',
        width: '80',
        listeners: {
      
            click: {
                fn: function () {
                    myWin.hide();
                }
            }
        }
    }]
});
   //****************************** Window For Adding Trip Information Ends Here************************
 		var outerPanelWindow = new Ext.Panel({
   		standardSubmit: true,
   		id:'radiocasewinpanelId',
    	frame: true,
        height: 790,
        width: 1240,  
    	items: [caseInnerPanel, winButtonPanel]
		});
   //************************* Outer Pannel *******************************************//
 myWin = new Ext.Window({
    title: 'My Window',
    closable: false,
    modal: true,
    resizable: false,
    autoScroll: false,
    height: 530,
    width: 1250,
    id: 'myWin',
    items: [outerPanelWindow]
});
//*****************************************acknowledgement window**********************************//
var  currentDayNextYear = datecur.add(Date.DAY,-1);
var aknowledgePanel = new Ext.form.FormPanel({
 	    standardSubmit: true,
 	    collapsible: false,
 	    autoScroll: true,
 	    height: 200,
 	    width: 420,
 	    frame: true,
 	    id: 'approveid',
 	    layout: 'table',
 	    layoutConfig: {
 	        columns: 4,
 	        style: {
 	            // width: '10%'
 	        }
 	    },
 	    
 	    items: [{
        xtype: 'fieldset',
        title: '<%=AcknowledgementInformation%>',
        cls: 'fieldsetpanel',
        collapsible: false,
        colspan: 3,
        id: 'apprpanelid',
         width: 390,
        layout: 'table',
        layoutConfig: {
            columns: 4
        },
 	    
 	    
 	    items: [{
 	        xtype: 'label',
 	        text: '*',
 	        cls: 'mandatoryfield',
 	        id: 'mandatoryq'
 	    }, {
 	        xtype: 'label',
 	        text: '<%=ChallanNumber%>' + ' :',
 	        cls: 'labelstyle',
 	        id: 'ChallanNumbertxt'
 	    }, {
 	        xtype: 'textfield',
 	        emptyText: '<%=EnterChallanNumber%>',
 	        allowBlank: false,
 	        blankText: '<%=EnterChallanNumber%>',
 	        autoCreate: { //restricts 
                       tag: "input",
                       maxlength: 50,
                       type: "text",
                       size: "200",
                       autocomplete: "off"
                   },
 	        cls: 'selectstylePerfect',
 	        id: 'ChallanNumberid',
 	         mode: 'local',
                forceSelection: true,
                selectOnFocus: true,
                listeners: {
                change: function(field, newValue, oldValue) {
                    field.setValue(newValue.toUpperCase().trim());
                }
            }
 	    }, {
 	        xtype: 'label',
 	        text: '',
 	        cls: 'selectstylePerfect',
 	        id: 'mandatoryrsss'
 	    },
		
		
		{
 	        xtype: 'label',
 	        text: '*',
 	        cls: 'mandatoryfield',
 	        id: 'mandatorysfd'
 	    }, {
 	        xtype: 'label',
 	        text: '<%=ChallenDate%>' + ' :',
 	        cls: 'labelstyle',
 	        id: 'rem2txtss'
 	    }, {
 	        xtype: 'datefield',
 	        emptyText: '<%=EnterChallenDate%>',
 	        allowBlank: false,
 	        editable:false,
 	        blankText: '<%=EnterChallenDate%>',
 	        cls: 'selectstylePerfect',
 	        format: getDateFormat(),
            value: datecur,
 	        id: 'rem2ids',
 	        listeners: 	{
				     select:{
				         fn: function(){
				        var setDates=Ext.getCmp('rem2ids').getValue().add(Date.DAY,-1);
				        var  endDateVal = setDates.add(Date.YEAR,1);
				        //var  endDateMinVal = Ext.getCmp('rem2ids').getValue().add(Date.YEAR,1);
				        var  endDateMaxVal = setDates.add(Date.YEAR,1);
				        //alert(endDateMaxVal);
				        Ext.getCmp('rem2idrr').setValue(endDateVal);
				       // Ext.getCmp('rem2idrr').setMinValue(endDateMinVal);
				        Ext.getCmp('rem2idrr').setMaxValue(endDateMaxVal);
				         }//function
				       }//select
				    }//listeners
 	    }, {
 	        xtype: 'label',
 	        text: '',
 	        cls: 'selectstylePerfect',
 	        id: 'mandatorytss'
 	    },
		
		{
 	        xtype: 'label',
 	        text: '*',
 	        cls: 'mandatoryfield',
 	        id: 'mandatorysts'
 	    }, {
 	        xtype: 'label',
 	        text: '<%=BankTransactionNumber%>' + ' :',
 	        cls: 'labelstyle',
 	        id: 'rem29txt'
 	    }, {
 	        xtype: 'textfield',
 	        emptyText: '<%=EnterBankTransactionNumber%>',
 	        allowBlank: false,
 	        blankText: '<%=EnterBankTransactionNumber%>',
 	        autoCreate: { //restricts 
                       tag: "input",
                       maxlength: 20,
                       type: "text",
                       size: "200",
                       autocomplete: "off"
                   },
 	        cls: 'selectstylePerfect',
 	        id: 'rem12id'
 	    }, {
 	        xtype: 'label',
 	        text: '',
 	        cls: 'selectstylePerfect',
 	        id: 'mandatoryt'
 	    },
		
		{
 	        xtype: 'label',
 	        text: '*',
 	        cls: 'mandatoryfield',
 	        id: 'mandatorysw'
 	    }, {
 	        xtype: 'label',
 	        text: '<%=AmountPaid%>' + ' :',
 	        cls: 'labelstyle',
 	        id: 'rem21txt'
 	    }, {
 	        xtype: 'numberfield',
 	        emptyText: '<%=EnterPaidAmount%>',
 	        allowBlank: false,
 	        blankText: '<%=EnterPaidAmount%>',
 	        autoCreate: { //restricts 
                       tag: "input",
                       maxlength: 20,
                       type: "text",
                       size: "200",
                       autocomplete: "off"
                   },
 	        cls: 'selectstylePerfect',
 	        id: 'rem2id2'
 	    }, {
 	        xtype: 'label',
 	        text: '',
 	        cls: 'selectstylePerfect',
 	        id: 'mandatorytt'
 	    },
		
		{
 	        xtype: 'label',
 	        text: '*',
 	        cls: 'mandatoryfield',
 	        id: 'mandatorysrr'
 	    }, {
 	        xtype: 'label',
 	        text: '<%=ValidityDate%>' + ' :',
 	        cls: 'labelstyle',
 	        id: 'rem2txtrr'
 	    }, {
 	        xtype: 'datefield',
 	        editable:false,
 	        cls: 'selectstylePerfect',
            format: getDateFormat(),
            emptyText: '<%=EnterValidityDate%>',
            allowBlank: false,
            blankText: '<%=EnterValidityDate%>',
 	        id: 'rem2idrr',
 	        value: currentDayNextYear.add(Date.YEAR,1),
 	        maxValue:currentDayNextYear.add(Date.YEAR,1),
 	        	listeners: 	{
				     select:{
				         fn: function(){
				        
				         }//function
				       }//select
					}//listeners
 	    }, {
 	        xtype: 'label',
 	        text: '',
 	        cls: 'selectstylePerfect',
 	        id: 'mandatorytrr'
 	    }]
 	 }] 
 	});
 	
 	var aknowledgeButtonPanel = new Ext.Panel({
 	    id: 'approvepanelid',
 	    standardSubmit: true,
 	    collapsible: false,
 	    autoHeight: true,
 	     height: 10,
 	    width: 420,
 	    frame: true,
 	    layout: 'table',
 	    layoutConfig: {
 	        columns: 4
 	    },
 	    buttons: [{
 	        xtype: 'button',
 	        text: '<%=Acknowledgement%>',
 	        id: 'saveId',
 	        cls: 'buttonstyle',
 	        width: 70,
 	        listeners: {
 	            click: {
 	                fn: function () {
 	                    var ackGlobalId=Ext.getCmp('custcomboId').getValue();
						if (Ext.getCmp('ChallanNumberid').getValue() == "") {
						 Ext.example.msg("<%=EnterChallanNumber%>");
						 Ext.getCmp('ChallanNumberid').focus();
						 return;
						 }
						 if (Ext.getCmp('rem2ids').getValue() == "") {
						 Ext.example.msg("<%=EnterChallenDate%>");
						 Ext.getCmp('rem2ids').focus();
						 return;
						 }
						 if (Ext.getCmp('rem12id').getValue() == "") {
						 Ext.example.msg("<%=EnterBankTransactionNumber%>");
						 Ext.getCmp('rem12id').focus();
						 return;
						 }
						 if (Ext.getCmp('rem2id2').getValue() == "") {
						 Ext.example.msg("<%=EnterPaidAmount%>");
						 Ext.getCmp('rem2id2').focus();
						 return;
						 }
						 if (Ext.getCmp('rem2idrr').getValue() == "") {
						 Ext.example.msg("<%=EnterValidityDate%>");
						 Ext.getCmp('rem2idrr').focus();
						 return;
						 }
					   if (dateCompare(Ext.getCmp('rem2ids').getValue(), Ext.getCmp('rem2idrr').getValue()) == -1) {
	                  		Ext.example.msg("<%=validityDateMustBeGreaterthanChallenDate%>");
	                        Ext.getCmp('rem2idrr').focus();
	                          return;
	                      }
						if (buttonValue == 'acknowledge') {
						 var selected = grid.getSelectionModel().getSelected();
                          ackuniqueId = selected.get('uniqueIdDataIndex');
                          acVehicleNo = selected.get('assetNoIndex');
                          stateModify = selected.get('stateIdIndex');
		                  districtModify = selected.get('districtIdIndex');
		                   }
						    Ext.Ajax.request({
 	                        url: '<%=request.getContextPath()%>/MiningAssetEnrollment.do?param=acknowledgeSave',
 	                        method: 'POST',
 	                        params: {
 	                            enrollNumberIds:selected.get('EnrollmentNumberIndex'),
								EnrollDateIds:selected.get('EnrollmentDateIndex'),
						        assetNumberIds:selected.get('assetNoIndex'),
								regstartdates:selected.get('RegistrationDateIndex'),
								carriageCapacityIds:selected.get('carriageCapacityIndex'),
								operatingOnMineIds:selected.get('operatingOnMineIndex'),
								locationIds:selected.get('locationIndex'),
								MiningLeaseNoIds:selected.get('MiningLeaseNoIndex'),
								ChassisNoIds:selected.get('ChasisNoIndex'),
								InsuranceNoIds:selected.get('InsurancePolicyNumber'),
								InsuranceexpiryIds:selected.get('InsuranceExpiryDate'),
								pucnoids:selected.get('PucNumber'),
								pucdateids:selected.get('PucExpiredDate'),
							    OwnerNameIds:selected.get('OwnerNameIndex'),
								AssemblyNameIds:selected.get('AssemblyConstituencyIndex'),
								houseNoIds:selected.get('houseNoIndex'),
								LocalityIds:selected.get('localityIndex'),
								enterCityIds:selected.get('cityIndex'),
								talukaIds:selected.get('talukaIndex'),
								districtcomboIds:districtModify,
								statecomboIds:stateModify,
								EPICNoIds:selected.get('EPICNoIndex'),
								PANNoIds:selected.get('PANNoIndex'),
								MobileNoIds:selected.get('MobileNoIndex'),
								PhoneNoIds:selected.get('PhoneNoIndex'),
								adharNoIds:selected.get('AadharNoIndex'),
								BankIds:selected.get('BankIndex'),
								BranchIds:selected.get('BranchIndex'),
								PrincipalBalanceIds:selected.get('PrincipalBalanceIndex'),
								PrincipalOverDuesIds:selected.get('PrincipalOverDuesIndex'),
								InterestBalanceIds:selected.get('PrincipalInterestIndex'),
								AccountNoIds:selected.get('AccountNoIndex'),
								challenNoIds:selected.get('challenNoIndex'),
						        challenDataDates:selected.get('challenDataIndex'),
						        banktransactions:selected.get('banktransactionDataIndex'),
						        amountPaidDatas:selected.get('amountPaidDataIndex'),
						        validityDatedatas:selected.get('validityDateDataIndex'),
						        StatusGrid:selected.get('statusIndex'),      
 	                            ackuniqueId:ackuniqueId,
 	                            CustId: Ext.getCmp('custcomboId').getValue(),
 	                            VehicleNo: AssetNo,
								challenNo: Ext.getCmp('ChallanNumberid').getValue(),
 	                            challendate: Ext.getCmp('rem2ids').getValue(),
 	                            BankTransactionNumber: Ext.getCmp('rem12id').getValue(),
 	                            PaidAmount:Ext.getCmp('rem2id2').getValue(),
								ValidityDate:Ext.getCmp('rem2idrr').getValue()
 	                        },
 	                        success: function (response, options) {
 	                            var message = response.responseText;
 	                            Ext.example.msg(message);
 	                            
 	                          window.open("<%=request.getContextPath()%>/AssetAcknowledgementPdf?systemId=" + <%=systemId%> +"&clientId=" + ackGlobalId+"&vehicleNo="+acVehicleNo);   
 	                          
								 Ext.getCmp('ChallanNumberid').reset(),
 	                             Ext.getCmp('rem2ids').reset(),
 	                             Ext.getCmp('rem12id').reset(),
 	                             Ext.getCmp('rem2id2').reset(),
								 Ext.getCmp('rem2idrr').reset()
 	                             approveWin.hide();
 	                             
 	                        },
 	                        failure: function () {
 	                            Ext.example.msg("Error");
 	                            approveWin.hide();
 	                        }
 	                    });
 	                }
 	            }
 	        }
 	    }, {
 	        xtype: 'button',
 	        text: '<%=cancel%>',
 	        id: 'cancelButtonId',
 	        cls: 'buttonstyle',
 	        iconCls: 'cancelbutton',
 	        width: 70,
 	        listeners: {
 	            click: {
 	                fn: function () {
 	                Ext.getCmp('ChallanNumberid').reset(); 
					Ext.getCmp('rem2ids').reset();
					Ext.getCmp('rem12id').reset();
					Ext.getCmp('rem2id2').reset();
					Ext.getCmp('rem2idrr').reset();
 	                approveWin.hide();
 	                }
 	            }
 	        }
 	    }]
 	});

 	var aknowledgePanelWindow = new Ext.Panel({
 	    id:'mainPanelId',
 	    height: 300,
 	    width: 450,
 	    standardSubmit: true,
 	    frame: true,
 	    items: [aknowledgePanel, aknowledgeButtonPanel]
 	});
 	
 	approveWin = new Ext.Window({
 		title: '<%=AcknowledgementInformation%>',
 	    closable: false,
 	    resizable: false,
 	    modal: true,
 	    autoScroll: false,
 	    height: 330,
 	    width: 450,
 	    id: 'myWinApprove',
 	    items: [aknowledgePanelWindow]
 	});
   //**************************Function For Adding Customer Information For Trip*******************
      function addRecord() {  
    	if (Ext.getCmp('custcomboId').getValue() == "") {
             Ext.example.msg("<%=pleaseSelectcustomer%>");
             Ext.getCmp('custcomboId').focus();
        	 return;
    	}
    	buttonValue = "add";
    	title = '<%=addAssetInformation%>';
    	myWin.setTitle(title);
		Ext.getCmp('enrollNumberId').hide();
		Ext.getCmp('mandatoryenrollNumber').hide();
		Ext.getCmp('enrollmentNumberLabelId').hide();
    	Ext.getCmp('assetNumberId').setReadOnly(false);
    	Ext.getCmp('EnrollDateId').setReadOnly(false);
		Ext.getCmp('regstartdate').setReadOnly(false);
		Ext.getCmp('carriageCapacityId').setReadOnly(false);
		Ext.getCmp('OwnerNameId').setReadOnly(false);
		Ext.getCmp('districtcomboId').setReadOnly(false);
		Ext.getCmp('statecomboId').setReadOnly(false);
    	Ext.getCmp('assetNumberId').setValue("");
		Ext.getCmp('regstartdate').setValue(datecur);
		Ext.getCmp('engineNumberId').setValue("");
		Ext.getCmp('carriageCapacityId').setValue("");
		Ext.getCmp('operatingOnMineId').setValue("");
		Ext.getCmp('locationId').setValue("");
		Ext.getCmp('MiningLeaseNoId').setValue("");
		Ext.getCmp('OwnerNameId').setValue("");
		Ext.getCmp('AssemblyNameId').setValue("");
		Ext.getCmp('houseNoId').setValue("");
		Ext.getCmp('LocalityId').setValue("");
		Ext.getCmp('enterCityId').setValue("");
		Ext.getCmp('talukaId').setValue("");
		Ext.getCmp('districtcomboId').setValue("");
		Ext.getCmp('statecomboId').setValue("");
		Ext.getCmp('EPICNoId').setValue("");
		Ext.getCmp('PANNoId').setValue("");
		Ext.getCmp('MobileNoId').setValue("");
		Ext.getCmp('PhoneNoId').setValue("");
		Ext.getCmp('ChassisNoId').setValue("");
		Ext.getCmp('InsuranceNoId').setValue("");
		Ext.getCmp('InsuranceexpiryId').setReadOnly(false);
		Ext.getCmp('InsuranceexpiryId').setValue(datecur);
		Ext.getCmp('pucnoid').setValue("");
		Ext.getCmp('pucdateid').setReadOnly(false);
		Ext.getCmp('pucdateid').setValue(datecur);
		Ext.getCmp('adharNoId').setValue("");
		Ext.getCmp('EnrollDateId').setValue(datecur);
		Ext.getCmp('BankId').setValue("");
		Ext.getCmp('BranchId').setValue("");
		Ext.getCmp('PrincipalBalanceId').setValue("");
		Ext.getCmp('PrincipalOverDuesId').setValue("");
		Ext.getCmp('InterestBalanceId').setValue("");
		Ext.getCmp('AccountNoId').setValue("");
		Ext.getCmp('roadTaxvalidityId').setValue(datecur);
		Ext.getCmp('permitvalidityId').setValue(datecur);
	    myWin.show(); 
	}
	
	
   //*********************** Function to Modify Data ***********************************
    function modifyData() {
    //alert('modify data');
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
<!--    var selected = grid.getSelectionModel().getSelected();-->
<!--	var status=selected.get('statusIndex');-->
<!--    //alert(status);-->
<!--	if (status == "Active") {-->
<!--	Ext.example.msg("You Couldnot Modify ,Acknowledgement Already done for this Enrollment Number");-->
<!--	return;-->
<!--	}-->
    buttonValue = "modify";
        titel = "<%=modifyAssetInformation%>"
        myWin.setTitle(titel);
        var selected = grid.getSelectionModel().getSelected();
        Ext.getCmp('mandatoryenrollNumber').show(),
		Ext.getCmp('enrollmentNumberLabelId').show(),
		Ext.getCmp('enrollNumberId').show(),
	    ///Ext.getCmp('mandatoryenrollNumber').disable(),
		//Ext.getCmp('enrollmentNumberLabelId').disable(),
		Ext.getCmp('enrollNumberId').setReadOnly(true);
		Ext.getCmp('EnrollDateId').setReadOnly(true);
        Ext.getCmp('assetNumberId').setReadOnly(true);
		Ext.getCmp('regstartdate').setReadOnly(true);
		Ext.getCmp('carriageCapacityId').setReadOnly(true);
		Ext.getCmp('OwnerNameId').setReadOnly(true);
		Ext.getCmp('districtcomboId').setReadOnly(true);
		Ext.getCmp('statecomboId').setReadOnly(true);
		Ext.getCmp('enrollNumberId').setValue(selected.get('EnrollmentNumberIndex'));
		Ext.getCmp('EnrollDateId').setValue(selected.get('EnrollmentDateIndex'));
        Ext.getCmp('assetNumberId').setValue(selected.get('assetNoIndex'));
		Ext.getCmp('regstartdate').setValue(selected.get('RegistrationDateIndex'));
		Ext.getCmp('engineNumberId').setValue(selected.get('engineNoIndex'));
		Ext.getCmp('carriageCapacityId').setValue(selected.get('carriageCapacityIndex'));
		Ext.getCmp('operatingOnMineId').setValue(selected.get('operatingOnMineIndex'));
		Ext.getCmp('locationId').setValue(selected.get('locationIndex'));
		Ext.getCmp('MiningLeaseNoId').setValue(selected.get('MiningLeaseNoIndex'));
		Ext.getCmp('ChassisNoId').setValue(selected.get('ChasisNoIndex'));
		Ext.getCmp('InsuranceNoId').setValue(selected.get('InsurancePolicyNumber'));
		Ext.getCmp('InsuranceexpiryId').setValue(selected.get('InsuranceExpiryDate'));
	    Ext.getCmp('pucnoid').setValue(selected.get('PucNumber'));
	    Ext.getCmp('pucdateid').setValue(selected.get('PucExpiredDate'));
		Ext.getCmp('OwnerNameId').setValue(selected.get('OwnerNameIndex'));
		Ext.getCmp('AssemblyNameId').setValue(selected.get('AssemblyConstituencyIndex'));
		Ext.getCmp('houseNoId').setValue(selected.get('houseNoIndex'));
		Ext.getCmp('LocalityId').setValue(selected.get('localityIndex'));
		Ext.getCmp('enterCityId').setValue(selected.get('cityIndex'));
		Ext.getCmp('talukaId').setValue(selected.get('talukaIndex'));
		Ext.getCmp('districtcomboId').setValue(selected.get('DistrictIndex'));
		Ext.getCmp('statecomboId').setValue(selected.get('StateIndex'));
		Ext.getCmp('EPICNoId').setValue(selected.get('EPICNoIndex'));
		Ext.getCmp('PANNoId').setValue(selected.get('PANNoIndex'));
		Ext.getCmp('MobileNoId').setValue(selected.get('MobileNoIndex'));
		Ext.getCmp('PhoneNoId').setValue(selected.get('PhoneNoIndex'));
		Ext.getCmp('adharNoId').setValue(selected.get('AadharNoIndex'));
		Ext.getCmp('BankId').setValue(selected.get('BankIndex'));
		Ext.getCmp('BranchId').setValue(selected.get('BranchIndex'));
		Ext.getCmp('PrincipalBalanceId').setValue(selected.get('PrincipalBalanceIndex'));
		Ext.getCmp('PrincipalOverDuesId').setValue(selected.get('PrincipalOverDuesIndex'));
		Ext.getCmp('InterestBalanceId').setValue(selected.get('PrincipalInterestIndex'));
		Ext.getCmp('AccountNoId').setValue(selected.get('AccountNoIndex'));
		Ext.getCmp('roadTaxvalidityId').setValue(selected.get('roadTaxValidityDate'));
		Ext.getCmp('permitvalidityId').setValue(selected.get('permitValidityDate'));
        myWin.show();
    }
   //*********************** Function to Acknowledgement ***********************************
    function approveFunction() {
    //alert('Aknowledge');
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
     buttonValue = "acknowledge";
	var selected = grid.getSelectionModel().getSelected();
	    AssetNo=selected.get('assetNoIndex');
	    var status=selected.get('statusIndex');
	var sdate=selected.get('validityDateDataIndex');//Ext.getCmp('rem2idrr').getValue();
	var cudate=datecur;
	if (status == "Active") {
		if((sdate > cudate)){
		Ext.example.msg("Acknowledgement Already done for this Enrollment Number");
		return;
		}
	}
	
    approveWin.show();
   }
   //*********************** Function to Modify Data Ends Here **************************	
	Ext.onReady(function () {
    Ext.QuickTips.init();
    Ext.form.Field.prototype.msgTarget = 'side';
    outerPanel = new Ext.Panel({
        //title: 'Trip Creation',
        renderTo: 'content',
        standardSubmit: true,
        frame: true,
        //cls: 'outerpanel',
        height:500,
        width:screen.width-40,
        items: [customerPanel,grid]
    });     
});				
   </script>
 <jsp:include page="../Common/footer.jsp" />
 <!-- </body>   -->
 <!-- </html> -->
<%}%>
<%}%>
