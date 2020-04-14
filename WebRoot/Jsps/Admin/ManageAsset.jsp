<%@ page language="java"
	import="java.util.*,java.text.SimpleDateFormat,t4u.functions.*,t4u.beans.*,t4u.common.*,org.json.JSONArray,org.json.JSONObject"
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
	LoginInfoBean loginInfo1=new LoginInfoBean();
	loginInfo1=(LoginInfoBean)session.getAttribute("loginInfoDetails");
	if(loginInfo1!=null)
	{
	int mapType=loginInfo1.getMapType();
	loginInfo.setMapType(mapType);
	}
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
	loginInfo.setStyleSheetOverride(str[11].trim());
	}
	loginInfo.setIsLtsp(Integer.parseInt(str[12].trim()));
	loginInfo.setNewMenuStyle(str[13].trim());	
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
		
  Properties properties = ApplicationListener.prop;
  String LtspsToBlockAssetRegCan = properties.getProperty("LtspsToBlockAssetRegCan").trim();
	 LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
	String language = loginInfo.getLanguage();
	int systemId = loginInfo.getSystemId();
	int customerId = loginInfo.getCustomerId();
	int userId = loginInfo.getUserId();
	String userAuthority=cf.getUserAuthority(systemId,userId);
	
  String[] str=LtspsToBlockAssetRegCan.split(",");
  List<String> systemList=Arrays.asList(str);	
		
	String addbutton="";
	String modifybutton="";
	String deletebutton="";
	if(systemList.contains(String.valueOf(loginInfo.getSystemId())) && (customerId == 0 || loginInfo.getIsLtsp() == 0))
	{
	  addbutton = "false";
	  modifybutton = "true";
	  deletebutton = "false";
	}else if(systemList.contains(String.valueOf(loginInfo.getSystemId())) && customerId > 0 && loginInfo.getIsLtsp() == -1)
	{
	  addbutton = "false";
	  modifybutton = "false";
	  deletebutton = "false";
	  if(userAuthority.equalsIgnoreCase("Admin")){
	  	  addbutton = "true";
		  modifybutton = "true";
		  deletebutton = "true";
	  }
	}
	
	
	if(!systemList.contains(String.valueOf(loginInfo.getSystemId())))
	{
	   if(customerId == 0 || loginInfo.getIsLtsp() == 0)
	    {
		  addbutton = "true";
		  modifybutton = "true";
		  deletebutton = "true";
    	}else
	       {
			  addbutton = "false";
			  modifybutton = "false";
			  deletebutton = "false";
			   if(userAuthority.equalsIgnoreCase("Admin")){
			  	  addbutton = "true";
				  modifybutton = "true";
				  deletebutton = "true";
			  }
	        }
	}
	
		
 	
	
ArrayList<String> tobeConverted = new ArrayList<String>();

tobeConverted.add("Asset_Registration");
tobeConverted.add("Select_Customer_Name");
tobeConverted.add("Customer_Name");
tobeConverted.add("Asset_Type");	
tobeConverted.add("Asset_Number");
tobeConverted.add("Group_Name");
tobeConverted.add("Add");
tobeConverted.add("Unit_Number");
tobeConverted.add("Mobile_No");
tobeConverted.add("Save");
tobeConverted.add("Select_Customer_Name");
tobeConverted.add("Cancel");
tobeConverted.add("No_Rows_Selected");
tobeConverted.add("Select_Single_Row");
tobeConverted.add("Modify");
tobeConverted.add("No_Records_Found");
tobeConverted.add("Clear_Filter_Data");
tobeConverted.add("SLNO");
tobeConverted.add("Phone_No");
tobeConverted.add("Asset_Model");
tobeConverted.add("Select_Group_Name");
tobeConverted.add("Enter_Reason");
tobeConverted.add("Enter_Asset_Number");
tobeConverted.add("Unit_Details");
tobeConverted.add("Manufacturer");
tobeConverted.add("Unit_Type");
tobeConverted.add("Device_Reference_Id");
tobeConverted.add("Sim_Details");
tobeConverted.add("Sim_Number");
tobeConverted.add("Service_Provider");
tobeConverted.add("Select_Asset_type");
tobeConverted.add("Delete_Information");
tobeConverted.add("Delete");
tobeConverted.add("If_You_Want_To_Delete_Please_Enter_DELETE_On_Below_Text_Box");
tobeConverted.add("Select_Unit_No");
tobeConverted.add("Are_you_sure_you_want_to_delete");
tobeConverted.add("Select_Mobile_No");
tobeConverted.add("Please_Enter_DELETE_In_Capital_Letters_To_Delete_The_Record");
tobeConverted.add("Vehicle_not_deleted");
tobeConverted.add("Please_Enter_Delete_In_Above_Textfield");
tobeConverted.add("Reason");
tobeConverted.add("Asset_Information");
tobeConverted.add("Asset_Registration_Details");
tobeConverted.add("Modify_Information");
tobeConverted.add("Delete_Details");
tobeConverted.add("Add_New");
tobeConverted.add("Next");
tobeConverted.add("Client");
tobeConverted.add("Owner_Name");
tobeConverted.add("Enter_Owner_Name");
tobeConverted.add("Enter_Owner_Address");
tobeConverted.add("Owner_Address");
tobeConverted.add("Owner_Phone_No");
tobeConverted.add("Enter_Owner_Phone_No");
tobeConverted.add("Asset_ID");
tobeConverted.add("Enter_Asset_Id");
tobeConverted.add("Cannot_Associate_Mobile_No_If_Unit_Number_Is_Empty");
tobeConverted.add("Model_Type_Id");
tobeConverted.add("Group_Id");
tobeConverted.add("Cannot_Associate_None_To_Mobile_No_If_Unit_Number_Is_not_Empty");
tobeConverted.add("Customer");

tobeConverted.add("Select_Asset_Model");
tobeConverted.add("Do_You_Want_To_Associate_To_All_Users_Of_Selected_Group");
tobeConverted.add("Confirmation");
tobeConverted.add("Associate_All_Users_Of_Selected_Group");

tobeConverted.add("Excel");
tobeConverted.add("Registered_Date");
tobeConverted.add("Associated_Date");
tobeConverted.add("Registered_By");


tobeConverted.add("Are_you_sure_want_to_delete_this_registration_number");
tobeConverted.add("Type_DELETE_to_confirm");
tobeConverted.add("Please_Select_Mobile_Number");
tobeConverted.add("Are_you_sure_want_to_associate_only_to_you");
tobeConverted.add("Confirm_Deletion");

tobeConverted.add("Delete_Confirmation");
tobeConverted.add("All_The_Details_Regarding_To_This_Registration_Number_Will_Be_Removed");
tobeConverted.add("NOTE");
tobeConverted.add("CLA_Alert");

ArrayList<String> convertedWords = new ArrayList<String>();
convertedWords = cf.getLanguageSpecificWordForKey(tobeConverted,language);

String AssetRegistration=convertedWords.get(0);
String SelectCustomer=convertedWords.get(1);
String CustomerName=convertedWords.get(2);
String AssetType=convertedWords.get(3);
String AssetNumber=convertedWords.get(4);
String GroupName=convertedWords.get(5);
String Add=convertedWords.get(6);
String UnitNumber=convertedWords.get(7);
String MobileNo=convertedWords.get(8);
String Save=convertedWords.get(9);
String SelectCustomerName=convertedWords.get(10);
String Cancel=convertedWords.get(11);
String NoRowsSelected=convertedWords.get(12);
String SelectSingleRow=convertedWords.get(13);
String Modify=convertedWords.get(14);
String NoRecordsFound=convertedWords.get(15);
String ClearFilterData=convertedWords.get(16);
String SLNO=convertedWords.get(17);
String PhoneNo=convertedWords.get(18);
String AssetModel=convertedWords.get(19);
String SelectGroupName=convertedWords.get(20);
String EnterReason=convertedWords.get(21);
String EnterAssetNumber=convertedWords.get(22);
String UnitDetails=convertedWords.get(23);
String Manufacturer=convertedWords.get(24);
String UnitType=convertedWords.get(25);
String DeviceReferenceId=convertedWords.get(26);
String SimDetails=convertedWords.get(27);
String SimNumber=convertedWords.get(28);
String ServiceProvider=convertedWords.get(29);
String SelectAssetType=convertedWords.get(30);
String DeleteInformation=convertedWords.get(31);
String Delete=convertedWords.get(32);
String IfYouWantToDeletePleaseEnterDELETEOnBelowTextBox=convertedWords.get(33);
String SelectUnitNo=convertedWords.get(34);
String Areyousureyouwanttodelete=convertedWords.get(35);
String SelectMobileNo=convertedWords.get(36);
String PleaseEnterDELETEInCapitalLettersToDeleteTheRecord=convertedWords.get(37);
String VehicleNotDeleted=convertedWords.get(38);
String PLEASEENTERDELETEINABOVETEXTFIELD=convertedWords.get(39);
String Reason=convertedWords.get(40);
String AssetInformation=convertedWords.get(41);
String AssetRegistrationDetails=convertedWords.get(42);
String ModifyInformation=convertedWords.get(43);
String DeleteDetails=convertedWords.get(44);
String AddNew=convertedWords.get(45);
String Next=convertedWords.get(46);
String Client=convertedWords.get(47);
String OwnerName=convertedWords.get(48);
String EnterOwnerName=convertedWords.get(49);
String EnterOwnerAddress=convertedWords.get(50);
String OwnerAddress=convertedWords.get(51);
String OwnerPhoneNo=convertedWords.get(52);
String EnterOwnerPhoneNo=convertedWords.get(53);
String AssetId=convertedWords.get(54);
String EnterAssetId=convertedWords.get(55);
String CannotAssociateMobileNoIfUnitNumberIsEmpty=convertedWords.get(56);
String ModelTypeId=convertedWords.get(57);
String GroupId=convertedWords.get(58);
String CannotAssociateNoneToMobileNoIfUnitNumberIsnotEmpty=convertedWords.get(59);
String Customer=convertedWords.get(60);

String SelectAssetModel=convertedWords.get(61);
String DoYouWantToAssociateToAllUsersOfSelectedGroup=convertedWords.get(62);
String Confirmation=convertedWords.get(63);
String AssociateAllUsersOfSelectedGroup=convertedWords.get(64);

String Excel=convertedWords.get(65);
String RegisteredDate=convertedWords.get(66);
String AssociatedDate=convertedWords.get(67);
String RegisteredBy=convertedWords.get(68);

String Areyousurewanttodeletethisregistrationnumber=convertedWords.get(69);
String TypeDELETEtoconfirm=convertedWords.get(70);
String PleaseSelectMobileNumber=convertedWords.get(71);
String Areyousurewanttoassociateonlytoyou=convertedWords.get(72);
String ConfirmDeletion=convertedWords.get(73);

String DeleteConfirmation=convertedWords.get(74);
String AllTheDetailsRegardingToThisRegistrationNumberWillBeRemoved=convertedWords.get(75);
String Note=convertedWords.get(76);
String CLA_Alert=convertedWords.get(77);
String spl_ch_not_allow="Special characters are not allowed in Asset Number";

LTSP_Subscription_Payment_Function fun = new LTSP_Subscription_Payment_Function();

JSONArray arr  = fun.getLTSPSubscriptionDetails(systemId,customerId,userId);
 
String totalAmount = "";

if(arr.length() > 0){
	JSONObject obj = arr.getJSONObject(0);
	
	totalAmount = obj.getString("totalAmount");
}else{
	 totalAmount = "0.00";
}

AdminFunctions adfun = new AdminFunctions();
String prePaymentMode = adfun.IsPrePaymentMode(systemId) == true ? "Y" : "N" ;
System.out.println(prePaymentMode);
 
%>
<!DOCTYPE HTML>
<html>
	<head>
		<title><%=AssetRegistration%></title>
		<meta http-equiv="X-UA-Compatible" content="IE=8">
	</head>
	<style>
.clearfilterbutton {
	dispaly: none !important;
}

.x-panel-tl {
	border-bottom: 0px solid !important;
}

.x-btn-bc {
	display: none;
}
</style>
	<body height="100%">
		<%if (loginInfo.getStyleSheetOverride().equals("Y")){%>
		<jsp:include page="../Common/ImportJSSandMining.jsp" />
		<%}else {%>
		<jsp:include page="../Common/ImportJS.jsp" />
		<%} %>
		<jsp:include page="../Common/ExportJS.jsp" />
		<script>
   var pageName='<%=AssetRegistration%>';
   Ext.Ajax.timeout = 360000;
   var outerPanel;
   var ctsb;
   var jspName = "AssetRegistration";
   var selected;
   var grid;
   var exportDataType = "";
   var buttonValue;
   var titelForInnerPanel;
   var myWinForAssetRegistration;
   var buttonValue = "";
   var mobileNo = "";
   var myWinForAssetRegistration;
   var setGroupId = "";
   var saveButtonTxt = '<%=Save%>';
   var prePaymentMode = '<%=prePaymentMode%>' == 'Y' ? true : false;

   
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
<!--                   store.load({-->
<!--                       params: {-->
<!--                           CustId: Ext.getCmp('custcomboId').getValue()-->
<!--                       }-->
<!--                   });-->
                   blockedVehicleStore.load({
                   params:{
                   	 CustId: custId
                   }
                   });
                   assetNoStore.load({
                    params: {
                            CustId: custId
                    }
                    });
                   assetTypeStore.load({
                       params: {
                           // CustId: custId
                       }
                   });
                   unitTypeStore.load({
                       params: {
                           CustId: custId
                       }
                   });
                   mobileNumberStore.load({
                       params: {
                           //CustId: custId
                       }
                   });
                   groupStore.load({
                       params: {
                           CustId: custId
                       }
                   });
                   registrationNoStore.load({
                       params: {
                           CustId: custId
                       }
                   });
                   ownerStore.load({
                       params: {
                           CustId: custId
                       }
                   });
                   
                   assetModelStore.load({
                       params: {
                           CustId: custId
                       }
                   });
                   reasonStore.load();
               }
           }
       }
   });
   

	function checkWhetherPrepaymentMode(){
		
	}
   
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
               Ext.getCmp('autoCompleteId').reset();
                   custId = Ext.getCmp('custcomboId').getValue();
<!--                   store.load({-->
<!--                       params: {-->
<!--                           CustId: Ext.getCmp('custcomboId').getValue()-->
<!--                       }-->
<!--                   });-->
                   blockedVehicleStore.load({
                   params:{
                   	 CustId: custId
                   }
                   });
                   assetTypeStore.load({
                       params: {
                           //CustId: custId
                       }
                   });
                    assetNoStore.load({
                    params: {
                            CustId: custId
                    }
                    });
                   unitTypeStore.load({
                       params: {
                           CustId: custId
                       }
                   });
                   mobileNumberStore.load({
                       params: {
                           //CustId: custId
                       }
                   });
                   groupStore.load({
                       params: {
                           CustId: custId
                       }
                   });
                   registrationNoStore.load({
                       params: {
                           CustId: custId
                       }
                   });
                   ownerStore.load({
                       params: {
                           CustId: custId
                       }
                   });
                   assetModelStore.load({
                       params: {
                           CustId: custId
                       }
                   });
                    reasonStore.load();
                   if ( <%= customerId %> > 0) {
                       Ext.getCmp('custcomboId').setValue('<%=customerId%>');
                       custId = Ext.getCmp('custcomboId').getValue();
                       custName = Ext.getCmp('custcomboId').getRawValue();
<!--                       store.load({-->
<!--                           params: {-->
<!--                               CustId: Ext.getCmp('custcomboId').getValue()-->
<!--                           }-->
<!--                       });-->
                       assetModelStore.load({
                           params: {
                               CustId: custId
                           }
                       });
                       
                       ownerStore.load({
                       params: {
                           CustId: custId
                       }
                   });
                    assetNoStore.load({
                    params: {
                            CustId: custId
                    }
                    });
                    registrationNoStore.load({
                       params: {
                           CustId: custId
                       }
                   });
                   assetTypeStore.load({
                       params: {
                           //CustId: custId
                       }
                   });
                   unitTypeStore.load({
                       params: {
                           CustId: custId
                       }
                   });
                   mobileNumberStore.load({
                       params: {
                           //CustId: custId
                       }
                   });
                   groupStore.load({
                       params: {
                           CustId: custId
                       }
                   });
                   
                   }
                   assetModelStore.load({
                       params: {
                           CustId: custId
                       }
                   });
                   ownerStore.load({
                       params: {
                           CustId: custId
                       }
                   });
                   registrationNoStore.load({
                       params: {
                           CustId: custId
                       }
                   });
                   assetTypeStore.load({
                       params: {
                           //CustId: custId
                       }
                   });
                   unitTypeStore.load({
                       params: {
                           CustId: custId
                       }
                   });
                   mobileNumberStore.load({
                       params: {
                           //CustId: custId
                       }
                   });
                   groupStore.load({
                       params: {
                           CustId: custId
                       }
                   });
                    reasonStore.load();
               }
           }
       }
   });
   var assetNoStore = new Ext.data.JsonStore({
        url: '<%=request.getContextPath()%>/ManageAssetAction.do?param=viewAssetDetails',
        id: 'assetNoId',
        root: 'assetNoRoot',
        autoLoad: false,
        remoteSort: true,
        fields: ['assetNoIndex']
    });
   
     RegisterCombo = new Ext.form.ComboBox({
       store: assetNoStore,
       id: 'autoCompleteId',
       mode: 'local',
       forceSelection: true,
       selectOnFocus: true,
       allowBlank: false,
       anyMatch: true,
       typeAhead: false,
       triggerAction: 'all',
       lazyRender: true,
       valueField: 'assetNoIndex',
       emptyText: 'Registration Number',
       displayField: 'assetNoIndex',
       cls: 'selectstylePerfect',
       listeners: {
           select: {
               fn: function() {
                 //  reason = Ext.getCmp('reasonComboId').getValue();
               }
           }
       }
   });
   
   var Clientformodify = new Ext.form.ComboBox({
       store: clientcombostore,
       id: 'custcomboIdForModify',
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
                   Ext.getCmp('groupNameComboId').reset();
                   // Ext.getCmp('assetModelcomboId').reset();
                   Ext.getCmp('ownerNameId').reset();
                   Ext.getCmp('ownerAddressId').reset();
                   Ext.getCmp('ownerPhoneNoId').reset();
                   custId = Ext.getCmp('custcomboIdForModify').getValue();
                    
                   groupStore.load({
                       params: {
                           CustId: custId
                       }
                   });
                   ownerStore.load({
                       params: {
                           CustId: custId
                       }
                   });
                   assetModelStore.load({
                       params: {
                           CustId: custId
                       }
                   });
                   reasonStore.load();
               }
           }
       }
   });
     var blockedVehicleStore = new Ext.data.JsonStore({
       url: '<%=request.getContextPath()%>/ManageAssetAction.do?param=getBlockedVehicleList',
       id: 'blockedVehicleId',
       root: 'blockedVehicleRoot',
       autoload: false,
       remoteSort: true,
       fields: ['RegistrationNo']
       
   });
   
   var assetTypeStore = new Ext.data.JsonStore({
       url: '<%=request.getContextPath()%>/ManageAssetAction.do?param=getAssetType',
       id: 'assetTypeId',
       root: 'assetTypeRoot',
       autoload: true,
       remoteSort: true,
       fields: ['AssetType'],
       listeners: {
           load: function() {}
       }
   });
   
   var assetTypeCombo = new Ext.form.ComboBox({
       store: assetTypeStore,
       id: 'assettypecomboId',
       mode: 'local',
       forceSelection: true,
       emptyText: '<%=SelectAssetType%>',
       blankText: '<%=SelectAssetType%>',
       selectOnFocus: true,
       allowBlank: false,
       anyMatch: true,
       typeAhead: false,
       triggerAction: 'all',
       lazyRender: true,
       valueField: 'AssetType',
       displayField: 'AssetType',
       cls: 'selectstylePerfect',
       listeners: {
           select: {
               fn: function() {
                   assetType = Ext.getCmp('assettypecomboId').getValue();
               }
           }
       }
   });
   
   var assetModelStore = new Ext.data.JsonStore({
       url: '<%=request.getContextPath()%>/ManageAssetAction.do?param=getAssetModel',
       id: 'assetModelId',
       root: 'assetModelRoot',
       autoload: true,
       remoteSort: true,
       fields: ['ModelTypeId', 'ModelName'],
       listeners: {
           load: function() {}
       }
   });
   
   var assetModelCombo = new Ext.form.ComboBox({
       store: assetModelStore,
       id: 'assetModelcomboId',
       mode: 'local',
       forceSelection: true,
       emptyText: '<%=SelectAssetModel%>',
       blankText: '<%=SelectAssetModel%>',
       selectOnFocus: true,
       allowBlank: true,
       anyMatch: true,
       typeAhead: false,
       triggerAction: 'all',
       lazyRender: true,
       valueField: 'ModelTypeId',
       displayField: 'ModelName',
       cls: 'selectstylePerfect',
       listeners: {
           select: {
               fn: function() {
                   assetModel = Ext.getCmp('assetModelcomboId').getValue();
               }
           }
       }
   });
   
   var unitTypeStore = new Ext.data.JsonStore({
       url: '<%=request.getContextPath()%>/ManageAssetAction.do?param=getUnitType',
       id: 'unitTypeId',
       root: 'unitTypeRoot',
       autoload: true,
       remoteSort: true,
       fields: ['UnitNumber', 'Manufacturer', 'UnitType', 'DeviceReferenceId','UnitNumberRef','ManufactureId'],
       listeners: {
           load: function() {}
       }
   });
   
   var unitTypeCombo = new Ext.form.ComboBox({
       store: unitTypeStore,
       id: 'unittypecomboId',
       mode: 'local',
       forceSelection: true,
       selectOnFocus: true,
       emptyText: '<%=SelectUnitNo%>',
       blankText: '<%=SelectUnitNo%>',
       allowBlank: false,
       anyMatch: true,
       typeAhead: false,
       triggerAction: 'all',
       lazyRender: true,
       value: 'None',
       valueField: 'UnitNumber',
       displayField: 'UnitNumberRef',
       cls: 'selectstylePerfect',
       listeners: {
           select: {
               fn: function() {
                   var unitType = Ext.getCmp('unittypecomboId').getValue();
                   Ext.getCmp('secondPanelId').show();
                   if (Ext.getCmp('unittypecomboId').getValue() == 'None') {
                       Ext.getCmp('mobileDetailsPanelId').show();
                       Ext.getCmp('mobileNocomboId').setValue("None");
                       var row = mobileNumberStore.find('MobileNumber', Ext.getCmp('mobileNocomboId').getValue());
                       var rec = mobileNumberStore.getAt(row);
                       Ext.getCmp('mobileNo1Id').setText(rec.data['MobileNumber']);
                       Ext.getCmp('simNumberId').setText(rec.data['SimNumber']);
                       Ext.getCmp('serviceProviderId').setText(rec.data['ServiceProvider']);
                   }
                   var row = unitTypeStore.find('UnitNumber', Ext.getCmp('unittypecomboId').getValue());
                   var rec = unitTypeStore.getAt(row);
                   Ext.getCmp('unitNumber1Id').setText(rec.data['UnitNumber']);
                   Ext.getCmp('manfacturer1Id').setText(rec.data['Manufacturer']);
                   Ext.getCmp('unitType1Id').setText(rec.data['UnitType']);
                   Ext.getCmp('DeviceReferenceId').setText(rec.data['DeviceReferenceId']);
                   if(rec.data['ManufactureId']=="32"){
                   		Ext.getCmp('mobileDetailsPanelId').show();
                   		
                   		// Get Predefined Mobile Number For CLA/PnP unit
                        Ext.Ajax.request({
                                                   url: '<%=request.getContextPath()%>/ManageAssetAction.do?param=getMobileNoCLA',
                                                   method: 'POST',
                                                   params: {
                                                       unitNumber: Ext.getCmp('unittypecomboId').getValue(),
                                                   },
                                                   success: function(response, options) {
                                                  
                                                   		var my_Variable = JSON.parse(response.responseText);
                                                   		var jsonRes = my_Variable.mobileNoRoot[0];
                                                   
                                                        Ext.getCmp('mobileNocomboId').setValue(jsonRes['MobileNumber']); 
                                                        Ext.getCmp('mobileNocomboId').disable(); 
                                                        Ext.getCmp('mobileNo1Id').setText(jsonRes['MobileNumber']+'( PnP )');
                       									Ext.getCmp('simNumberId').setText(jsonRes['SimNumber']);
                       									Ext.getCmp('serviceProviderId').setText(jsonRes['ServiceProvider']);
                                                   },
                                                   failure: function() {
                                                   Ext.example.msg("Error");
                                                   }
                                               });
                   }else{
                   		Ext.getCmp('mobileNocomboId').enable();
                   }
               }
           }
       }
   });
   var mobileNumberStore = new Ext.data.JsonStore({
       url: '<%=request.getContextPath()%>/ManageAssetAction.do?param=getMobileNo',
       id: 'mobileNoId',
       root: 'mobileNoRoot',
       autoload: true,
       remoteSort: true,
       fields: ['MobileNumber', 'SimNumber', 'ServiceProvider','IsPredefined'],
       listeners: {
           load: function() {}
       }
   });
   var mobileNumberCombo = new Ext.form.ComboBox({
       store: mobileNumberStore,
       id: 'mobileNocomboId',
       mode: 'local',
       forceSelection: true,
       emptyText: '<%=SelectMobileNo%>',
       blankText: '<%=SelectMobileNo%>',
       selectOnFocus: true,
       allowBlank: false,
       anyMatch: true,
       typeAhead: false,
       triggerAction: 'all',
       value: 'None',
       lazyRender: true,
       valueField: 'MobileNumber',
       displayField: 'MobileNumber',
       cls: 'selectstylePerfect',
       listeners: {
           select: {
               fn: function() {
                   var mobileNumber = Ext.getCmp('mobileNocomboId').getValue();
                   Ext.getCmp('mobileDetailsPanelId').show();
                   var row = mobileNumberStore.find('MobileNumber', Ext.getCmp('mobileNocomboId').getValue());
                   var rec = mobileNumberStore.getAt(row);
                   if(rec.data['IsPredefined']=='Yes'){                                       		 
                   		Ext.getCmp('mobileNo1Id').setText(rec.data['MobileNumber']+'( PnP )');
                   }else{
                   		Ext.getCmp('mobileNo1Id').setText(rec.data['MobileNumber']);
                   }
                   Ext.getCmp('simNumberId').setText(rec.data['SimNumber']);
                   Ext.getCmp('serviceProviderId').setText(rec.data['ServiceProvider']);
               }
           }
       }
   });
   
   var groupStore = new Ext.data.JsonStore({
       url: '<%=request.getContextPath()%>/ManageAssetAction.do?param=getGroups',
       id: 'groupId',
       root: 'groupNameList',
       autoLoad: false,
       remoteSort: true,
       fields: ['groupId', 'groupName']
   });
   
   var groupNameCombo = new Ext.form.ComboBox({
       fieldLabel: '',
       store: groupStore,
       id: 'groupNameComboId',
      // width: 150,
       emptyText: '<%=SelectGroupName%>',
       blankText: '<%=SelectGroupName%>',
      // labelWidth: 100,
       resizable: true,
       hidden: false,
       forceSelection: true,
       enableKeyEvents: true,
       mode: 'local',
       triggerAction: 'all',
       displayField: 'groupName',
       valueField: 'groupId',
       loadingText: 'Searching...',
       cls: 'selectstylePerfect',
       minChars: 3,
       listeners: {
           select: {
               fn: function() {
                   CustId = Ext.getCmp('custcomboId').getValue();
               }
           }
       }
   });
   
   var registrationNoStore = new Ext.data.JsonStore({
       url: '<%=request.getContextPath()%>/ManageAssetAction.do?param=getRegistrationNumber',
       id: 'registrationNoId',
       root: 'registrationNoRoot',
       autoload: false,
       remoteSort: true,
       fields: ['RegistrationNumber'],
       listeners: {
           load: function() {}
       }
   });
   
   var reasonStore = new Ext.data.JsonStore({
      url: '<%=request.getContextPath()%>/ManageAssetAction.do?param=getReason',
       id: 'reasonStoreId',
       root: 'reasonStoreRoot',
       autoload: true,
       remoteSort: true,
       fields: ['Name','Name'],
       listeners: {
           load: function() {}
       }
   });
  
   
   var reasonCombo = new Ext.form.ComboBox({
       store: reasonStore,
       id: 'reasonComboId',
       mode: 'local',
       forceSelection: true,
       selectOnFocus: true,
       allowBlank: false,
       anyMatch: true,
       typeAhead: false,
       triggerAction: 'all',
       lazyRender: true,
       valueField: 'Name',
       emptyText: '<%=EnterReason%>',
       displayField: 'Name',
       cls: 'selectstylePerfect',
       listeners: {
           select: {
               fn: function() {
                   reason = Ext.getCmp('reasonComboId').getValue();
               }
           }
       }
   });
   
   var ownerStore = new Ext.data.JsonStore({
       url: '<%=request.getContextPath()%>/ManageAssetAction.do?param=getOwnerNames',
       id: 'ownerNameId',
       root: 'ownerRoot',
       autoLoad: true,
       fields: ['id', 'name', 'ownerAddress', 'ownerPhoneNo','ownerEmailId']
   });
   
   var ownerCombo = new Ext.form.ComboBox({
       store: ownerStore,
       id: 'ownerNameId',
       mode: 'local',
       forceSelection: true,
       selectOnFocus: true,
       allowBlank: true,
       anyMatch: true,
       typeAhead: false,
       triggerAction: 'all',
       lazyRender: true,
       displayField: 'name',
       valueField: 'id',
       emptyText: '<%=EnterOwnerName%>',
       cls: 'selectstylePerfect',
       listeners: {
           select: {
               fn: function() {
                   CustId = Ext.getCmp('custcomboId').getValue();
                   var ownerName = Ext.getCmp('ownerNameId').getValue();
                   var row = ownerStore.find('id', Ext.getCmp('ownerNameId').getValue());
                   var rec = ownerStore.getAt(row);
                   Ext.getCmp('ownerAddressId').setValue(rec.data['ownerAddress']);
                   Ext.getCmp('ownerPhoneNoId').setValue(rec.data['ownerPhoneNo']);
				   if (prePaymentMode){
					    Ext.getCmp('ownerEmailId').setValue(rec.data['ownerEmailId']);
				   }
			   }
           }
       }
   });
   
   var comboPanel = new Ext.Panel({
       standardSubmit: true,
       collapsible: false,
       id: 'traderMaster',
       layout: 'table',
       frame: false,
       width: screen.width - 12,
       height: 40,
      layoutConfig: {
           columns: 18
       },
       items: [{width:150},{
               xtype: 'label',
               text: '<%=CustomerName%>' + ' :',
               cls: 'labelstyle'
           },
           Client,{width:200},{
               xtype: 'label',
               text: 'Registration Number' + ' :',
               cls: 'labelstyle'
           }, RegisterCombo,
                {width:50},  {
                    xtype: 'button',
                    text: 'View',
                    id: 'viewButtonId',
                       cls: 'buttonstyle',
                    width: 20,
                    listeners: {
                         click: {   
                    fn: function() {
                         if(Ext.getCmp('autoCompleteId').getValue()==''){
                         Ext.example.msg("Please select Registration Number");
                                    return;
                         }
                          store.load({
                            params: {
                               CustId: Ext.getCmp('custcomboId').getValue(),
                               vehicleNo : Ext.getCmp('autoCompleteId').getValue()
                                   }        
                             });
                             }
                           }
                          }
                    }
              ]
   });
   
   var innerPanelForAssetRegistration = new Ext.form.FormPanel({
       standardSubmit: true,
       collapsible: false,
       autoScroll: true,
       height: 360,
       width: 460,
       frame: false,
       id: 'custMaster',
       layout: 'table',
       layoutConfig: {
           columns: 3,
           tableAttrs: {
		            style: {
		                width: '90%'
		            }
        			}
       },
       items: [{
               xtype: 'label',
               text: '*',
               cls: 'mandatoryfield',
               id: 'mandatoryclientId'
           },{
               xtype: 'label',
               text: '<%=Customer%>' + ' :',
               cls: 'labelstyle',
               id: 'clientTxtId'
           },
           Clientformodify, 
           {
               xtype: 'label',
               text: '*',
               cls: 'mandatoryfield',
               id: 'mandatoryRegistrationId'
           },  
           {
               xtype: 'label',
               text: '<%=AssetNumber%>' + ' :',
               cls: 'labelstyle',
               id: 'registrationTxtId'
           }, {
               xtype: 'textfield',
               cls: 'selectstylePerfect',
               emptyText: '<%=EnterAssetNumber%>',
               allowBlank: false,
               autoCreate: { //restricts user to 20 chars max, cannot enter 21st char
                   tag: "input",
                   maxlength: 25,
                   type: "text",
                   size: "25",
                   autocomplete: "off"
               },
                 maskRe: /[ a-zA-Z0-9/()-_]/i,
              
               blankText: '<%=EnterAssetNumber%>',
               id: 'registrationNoTextFieldId'
           }, {
               xtype: 'label',
               text: '*',
               cls: 'mandatoryfield',
               id: 'mandatoryAssetId'
           },{
               xtype: 'label',
               text: '<%=AssetType%>' + ' :',
               cls: 'labelstyle',
               id: 'assetTxtId'
           },
           assetTypeCombo, 
            {
               xtype: 'label',
               text: '*',
               cls: 'mandatoryfield',
               id: 'mandatoryGroupNameId'
           }, {
               xtype: 'label',
               text: '<%=GroupName%>' + ' :',
               cls: 'labelstyle',
               id: 'groupNameTxtId'
           },
           groupNameCombo, 
           {
               xtype: 'label',
               text: '',
               cls: 'labelstyle',
               id: 'mandatoryassetModelId1'
           }, {
               xtype: 'label',
               text: '<%=AssetModel%>' + ' :',
               cls: 'labelstyle',
               id: 'assetModelIdForAdd'
           }, 
           assetModelCombo, 
            {
               xtype: 'label',
               text: '',
               cls: 'labelstyle',
               id: 'mandatoryownerNameIdForAdd'
           },{
               xtype: 'label',
               text: '<%=OwnerName%>' + ' :',
               cls: 'labelstyle',
               id: 'ownerNameIdForTxt'
           }, 
           ownerCombo,
            {
               xtype: 'label',
               text: '',
               cls: 'labelstyle',
               id: 'mandatoryownerAddressIdForAdd'
           }, {
               xtype: 'label',
               text: '<%=OwnerAddress%>' + ' :',
               cls: 'labelstyle',
               id: 'ownerAddressIdForTxt'
           }, {
               xtype: 'textarea',
               cls: 'selectstylePerfect',
               emptyText: '<%=EnterOwnerAddress%>',
               allowBlank: true,
               blankText: '<%=EnterOwnerAddress%>',
               id: 'ownerAddressId'
           }, {
               xtype: 'label',
               text: '',
               cls: 'labelstyle',
               id: 'mandatoryownerPhoneNoIdForAdd'
           }, {
               xtype: 'label',
               text: '<%=OwnerPhoneNo%>' + ' :',
               cls: 'labelstyle',
               id: 'ownerPhoneNoIdForTxt'
           }, {
               xtype: 'numberfield',
               cls: 'selectstylePerfect',
               emptyText: '<%=EnterOwnerPhoneNo%>',
               allowBlank: true,
               blankText: '<%=EnterOwnerPhoneNo%>',
               id: 'ownerPhoneNoId'
           },{
               xtype: 'label',
               text: '',
               cls: 'labelstyle',
               id: 'mandatoryownerEmailIdForAdd'
           }, {
               xtype: 'label',
               text: 'Owner Email Id :',
               cls: 'labelstyle',
               id: 'ownerEmailIdForTxt'
           }, {
               xtype: 'textfield',
               cls: 'selectstylePerfect',
               emptyText: 'Enter Owner Email',
			   allowBlank:true,
			   maskRe: /([a-zA-Z0-9\s.@]+)$/,
               blankText: 'Enter Owner Email',
               id: 'ownerEmailId',
           }, 
		   {
               xtype: 'label',
               text: '',
               cls: 'labelstyle',
               id: 'mandatoryPaymentAmountForAdd'
           }, {
               xtype: 'label',
               text: 'Total Amount :',
               cls: 'labelstyle',
               id: 'paymentAmountForTxt'
           }, {
               xtype: 'textfield',
               cls: 'selectstylePerfect',
               emptyText: 'Enter Amount',
               allowBlank: true,
               blankText: 'Enter Amount',
               id: 'paymentAmountId'
           }, 
		   
		   
		   {
               xtype: 'label',
               text: '',
               cls: 'labelstyle',
               id: 'mandatoryAssetIdForAdd'
           },  {
               xtype: 'label',
               text: '<%=AssetId%>' + ' :',
               cls: 'labelstyle',
               id: 'assetIdForTxt'
           }, {
               xtype: 'textfield',
               cls: 'selectstylePerfect',
               emptyText: '<%=EnterAssetId%>',
               allowBlank: true,
               blankText: '<%=EnterAssetId%>',
               id: 'assetId'
           }, {
               xtype: 'label',
               text: '*',
               cls: 'mandatoryfield',
               id: 'mandatoryUnitNumberId'
           },{
               xtype: 'label',
               text: '<%=UnitNumber%>' + ' :',
               cls: 'labelstyle',
               id: 'unitNumberTxtId'
           }, 
           unitTypeCombo, 
            {
               xtype: 'label',
               text: '*',
               cls: 'mandatoryfield',
               id: 'mandatorymobileNoId2'
           },{
               xtype: 'label',
               text: '<%=MobileNo%>' + ' :',
               cls: 'labelstyle',
               id: 'mobileNoTxtId1'
           },
           mobileNumberCombo, 
            {
               xtype: 'checkbox',
               checked: true,
               fieldLabel: '',
               labelSeparator: '',
              // boxLabel: '<%=AssociateAllUsersOfSelectedGroup%>',
               //name: 'owner',
               id: 'usersCheckBoxId'
           },
           {
               xtype: 'label',
               text: '<%=AssociateAllUsersOfSelectedGroup%>',
               cls: 'labelstyle',
               id: 'AssociateAllUsersOfSelectedGroupId1'
           }
          
           
       ]
   });
   
   var secondPanelForUnitDetails = new Ext.Panel({
       standardSubmit: true,
       collapsible: false,
       id: 'secondPanelId',
       layout: 'table',
       frame: false,
       hidden: true,
       items: [{
           xtype: 'fieldset',
           title: '<%=UnitDetails%>',
           width: 400,
           collapsible: false,
           layout: 'table',
           layoutConfig: {
               columns: 4,
               tableAttrs: {
                   style: {}
               }
           },
           items: [{
               xtype: 'label',
               text: '<%=UnitNumber%>' + ' :',
               cls: 'labelstyle',
               id: 'unitNumber1TxtId'
           }, {
               xtype: 'label',
               text: '',
               cls: 'mandatoryfield',
               id: 'mandatoryunitNumber1Id'
           }, {
               xtype: 'label',
               cls: 'labelForUserInterface',
               allowBlank: false,
               id: 'unitNumber1Id',
               listeners: {
                   change: function(field, newValue, oldValue) {
                       field.setValue(newValue.toUpperCase().trim());
                   }
               }
           }, {
               xtype: 'label',
               text: '',
               cls: 'mandatoryfield',
               id: 'mandatoryunitNumber1Id1'
           }, {
               xtype: 'label',
               text: '<%=Manufacturer%>' + ' :',
               cls: 'labelstyle',
               id: 'manfacturer1TxtId'
           }, {
               xtype: 'label',
               text: '',
               cls: 'mandatoryfield',
               id: 'mandatorymanfacturer1Id'
           }, {
               xtype: 'label',
               cls: 'labelForUserInterface',
               allowBlank: false,
               id: 'manfacturer1Id',
               listeners: {
                   change: function(field, newValue, oldValue) {
                       field.setValue(newValue.toUpperCase().trim());
                   }
               }
           }, {
               xtype: 'label',
               text: '',
               cls: 'mandatoryfield',
               id: 'mandatorymanfacturer1Id1'
           }, {
               xtype: 'label',
               text: '<%=UnitType%>' + ' :',
               cls: 'labelstyle',
               id: 'unitType1TxtId'
           }, {
               xtype: 'label',
               text: '',
               cls: 'mandatoryfield',
               id: 'mandatoryunitType1Id'
           }, {
               xtype: 'label',
               cls: 'labelForUserInterface',
               allowBlank: false,
               id: 'unitType1Id',
               listeners: {
                   change: function(field, newValue, oldValue) {
                       field.setValue(newValue.toUpperCase().trim());
                   }
               }
           }, {
               xtype: 'label',
               text: '',
               cls: 'mandatoryfield',
               id: 'mandatoryunitType1Id1'
           }, {
               xtype: 'label',
               text: '<%=DeviceReferenceId%>' + ' :',
               cls: 'labelstyle',
               id: 'deviceReferenceIdTxtId'
           }, {
               xtype: 'label',
               text: '',
               cls: 'mandatoryfield',
               id: 'mandatoryDeviceReference1Id'
           }, {
               xtype: 'label',
               cls: 'labelForUserInterface',
               allowBlank: false,
               id: 'DeviceReferenceId',
               listeners: {
                   change: function(field, newValue, oldValue) {
                       field.setValue(newValue.toUpperCase().trim());
                   }
               }
           }, {
               xtype: 'label',
               text: '',
               cls: 'mandatoryfield',
               id: 'mandatoryDeviceReference1Id1'
           }]
       }]
   });
   
   var secondPanelForMobileDetails = new Ext.Panel({
       standardSubmit: true,
       collapsible: false,
       id: 'mobileDetailsPanelId',
       layout: 'table',
       frame: false,
       hidden: true,
       items: [{
           xtype: 'fieldset',
           title: '<%=SimDetails%>',
           width: 400,
           collapsible: false,
           layout: 'table',
           layoutConfig: {
               columns: 4,
               tableAttrs: {
                   style: {}
               }
           },
           items: [{
               xtype: 'label',
               text: '<%=MobileNo%>' + ' :',
               cls: 'labelstyle',
               id: 'mobileNo1TxtId'
           }, {
               xtype: 'label',
               text: '',
               cls: 'mandatoryfield',
               id: 'mandatoryMobileNo1Id'
           }, {
               xtype: 'label',
               cls: 'labelForUserInterface',
               id: 'mobileNo1Id',
               listeners: {
                   change: function(field, newValue, oldValue) {
                       field.setValue(newValue.toUpperCase().trim());
                   }
               }
           }, {
               xtype: 'label',
               text: '',
               cls: 'mandatoryfield',
               id: 'mandatoryMobileNo1Id1'
              
           }, {
               xtype: 'label',
               text: '<%=SimNumber%>' + ' :',
               cls: 'labelstyle',
               id: 'simNumberTxtId'
           }, {
               xtype: 'label',
               text: '',
               cls: 'mandatoryfield',
               id: 'mandatorySimNumberId'
           }, {
               xtype: 'label',
               cls: 'labelForUserInterface',
               id: 'simNumberId',
               listeners: {
                   change: function(field, newValue, oldValue) {
                       field.setValue(newValue.toUpperCase().trim());
                   }
               }
           }, {
               xtype: 'label',
               text: '',
               cls: 'mandatoryfield',
               id: 'mandatorySimNumberId1'
           }, {
               xtype: 'label',
               text: '<%=ServiceProvider%>' + ' :',
               cls: 'labelstyle',
               id: 'serviceProviderTxtId'
           }, {
               xtype: 'label',
               text: '',
               cls: 'mandatoryfield',
               id: 'mandatoryServiceProviderId'
           }, {
               xtype: 'label',
               cls: 'labelForUserInterface',
               id: 'serviceProviderId',
               listeners: {
                   change: function(field, newValue, oldValue) {
                       field.setValue(newValue.toUpperCase().trim());
                   }
               }
           }, {
               xtype: 'label',
               text: '',
               cls: 'mandatoryfield',
               id: 'mandatoryserviceProviderId1'
           }]
       }]
   });
   
   var innerWinButtonPanelForAssetRegistration = new Ext.Panel({
       id: 'winbuttonid',
       standardSubmit: true,
       collapsible: false,
       autoHeight: true,
       height: 100,
       width: 480,
       frame: true,
       layout: 'table',
       layoutConfig: {
           columns: 4
       },
       buttons: [{
           xtype: 'button',
           text: '<%=Save%>',
           iconCls:'savebutton',
           id: 'addButtId',
           cls: 'buttonstyle',
           width: 70,
           listeners: {
               click: {
                   fn: function() {  
                    var format = /[!@#$%^&*_+\=\[\]{};':"\\|,.<>\?]/;
                       if (Ext.getCmp('custcomboId').getValue() == "") {
                       Ext.example.msg("<%=SelectCustomerName%>");
                       return;
                       }
                       if (buttonValue == 'Modify') {
                           if (Ext.getCmp('custcomboIdForModify').getValue() == "") {
                           Ext.example.msg("<%=SelectCustomerName%>");
                           return;
                           }
                       }
                       if (Ext.getCmp('registrationNoTextFieldId').getValue() == "") {
                           Ext.example.msg("<%=EnterAssetNumber%>");
                           return;
                       }
                     
                      if( Ext.getCmp('registrationNoTextFieldId').getValue().match(format) ){
                           Ext.example.msg("<%=spl_ch_not_allow%>");
                           return;
                       }
                        
                       if (Ext.getCmp('assettypecomboId').getValue() == "") {
                       Ext.example.msg("<%=SelectAssetType%>");
                       return;
                       }
                       
                                               
                        var RegistrationNo= Ext.getCmp('registrationNoTextFieldId').getValue().trim();
					   
					    var isBlocked = blockedVehicleStore.findExact('RegistrationNo',RegistrationNo);
					    if(isBlocked >=0){
					      	 Ext.example.msg("Vehicle has been Blocked,cannot Register");
					         return;
					    }
					    
                       
                       if (Ext.getCmp('groupNameComboId').getValue() == "") {
                           Ext.example.msg("<%=SelectGroupName%>");
                           return;
                       }
                       if (Ext.getCmp('unittypecomboId').getValue() == "") {
                           Ext.example.msg("<%=SelectUnitNo%>");
                           return;
                       }
                       if (Ext.getCmp('mobileNocomboId').getValue() == "") {
                           Ext.example.msg("<%=SelectMobileNo%>");
                           return;
                       }
                       if (Ext.getCmp('unittypecomboId').getValue() == 'None' && Ext.getCmp('mobileNocomboId').getValue() != 'None') {
                           Ext.example.msg("<%=CannotAssociateMobileNoIfUnitNumberIsEmpty%>");
                           return;
                       }
                       if (Ext.getCmp('unittypecomboId').getValue() != 'None' && Ext.getCmp('mobileNocomboId').getValue() == 'None') {
                            Ext.example.msg("<%=PleaseSelectMobileNumber%>");
                            return;
                       }
                       
                       var checkUnitAndMobileNumber=true;
                       var checkManufactureId="";
                       var isPredefined="";
					   var ownerEMail="";
                       if (buttonValue == '<%=Modify%>') {
                       	   var selected = grid.getSelectionModel().getSelected();
                       	
                         if(selected.get('unitNoDataIndex')==Ext.getCmp('unittypecomboId').getValue() && selected.get('phoneNoDataIndex')==Ext.getCmp('mobileNocomboId').getValue()){
                            //If Mobile and Unit are same skip CLA/PnP condition.
                            checkUnitAndMobileNumber=false;
                           
                         }else if(selected.get('unitNoDataIndex')!=Ext.getCmp('unittypecomboId').getValue() && selected.get('phoneNoDataIndex')!=Ext.getCmp('mobileNocomboId').getValue()){
                            checkUnitAndMobileNumber=true;
                            
                         }else if(selected.get('unitNoDataIndex')==Ext.getCmp('unittypecomboId').getValue()){
                         		checkManufactureId=selected.get('manufactureIdDataIndex');
                        
                         }else if(selected.get('manufactureIdDataIndex')=="32"){
                            // If Mobile Number is not modified and manufactureIdDataIndex is of CLA/PnP then Mobile Number is predefined 
                              isPredefined="Yes";
                         }else{
                         	 isPredefined="No";
                         }
                       }
                       
                       if(checkUnitAndMobileNumber==true){
	                        if(isPredefined==""){
		                        var rowMobile = mobileNumberStore.find('MobileNumber', Ext.getCmp('mobileNocomboId').getValue());
		                        var recMobile = mobileNumberStore.getAt(rowMobile);
		                        isPredefined=recMobile.data['IsPredefined'];
	                        }
	                       
	                       if(checkManufactureId==""){
		                        var rowUnit = unitTypeStore.find('UnitNumber', Ext.getCmp('unittypecomboId').getValue());
		                   		var recUnit = unitTypeStore.getAt(rowUnit);
		                   		checkManufactureId=recUnit.data['ManufactureId'];
	                   		}
	                   		
	                   		if(checkManufactureId=="32"){
	                   			if(isPredefined=="Yes"){
	                   			  //OK CLA/PnP is With Predefined Mobile Number
	                   			}else{
	                   				Ext.example.msg("Please select PnP Mobile Numbers");
	                            	return;
	                   			}
	                   		}else{
	                   			if(isPredefined=="Yes"){
	                   			  	Ext.example.msg("This Mobile Number is Not Allowed(Reserved for PnP)");
	                            	return;
	                   			}
	                   		}
                   		}
                   
                       
                       if (buttonValue == '<%=AddNew%>') {
                            var vechNo= Ext.getCmp('registrationNoTextFieldId').getValue().trim();
                              Ext.getCmp('autoCompleteId').setValue(vechNo);
					
						// Razor pay integration
						
						if (prePaymentMode){
														
							if(Ext.getCmp('ownerNameId').getValue() == "" || Ext.getCmp('ownerNameId').getValue() == null || Ext.getCmp('ownerNameId').getValue() == undefined){
								Ext.example.msg("Please select Owner");
	                            	return;
							}
							
							if(Ext.getCmp('ownerEmailId').getValue() == "" || Ext.getCmp('ownerEmailId').getValue() == null || 
								Ext.getCmp('ownerEmailId').getValue() == undefined){
									ownerEMail = "";
							}else{
								ownerEMail = Ext.getCmp('ownerEmailId').getValue();
							}
							
							if(Ext.getCmp('paymentAmountId').getValue() == "" || Ext.getCmp('paymentAmountId').getValue() == null || Ext.getCmp('paymentAmountId').getValue() == undefined || Ext.getCmp('paymentAmountId').getValue() == "0.00"){
								Ext.example.msg("Amount must be greater than 0. Possible reasons are 1. No cutomer launched.  2. Subscription amount not defined for this customer");
	                            	return;
							}
							
							if (Ext.getCmp('unittypecomboId').getValue() == "None") {
								Ext.example.msg("<%=SelectUnitNo%>");
									return;
							}
						}
							  
                           if (Ext.getCmp('usersCheckBoxId').getValue() == true) {
                               Ext.Msg.show({
                                   title: '<%=Confirmation%>',
                                   msg: '<%=DoYouWantToAssociateToAllUsersOfSelectedGroup%>',
                                   buttons: {
                                       yes: true,
                                       no: true
                                   },
                                   fn: function(btn) {
                                       switch (btn) {
                                           case 'yes':
                                               myWinForAssetRegistration.hide();
                                               outerPanel.getEl().mask();
                                               var selected = grid.getSelectionModel().getSelected();
                                               Ext.Ajax.request({
                                                   url: '<%=request.getContextPath()%>/ManageAssetAction.do?param=addModifyRegisterInformation',
                                                   method: 'POST',
                                                   params: {
                                                       buttonValue: buttonValue,
                                                       CustID: Ext.getCmp('custcomboId').getValue(),
                                                       custName: Ext.getCmp('custcomboId').getRawValue(),
                                                       assetType: Ext.getCmp('assettypecomboId').getValue(),
                                                       registrationNo: Ext.getCmp('registrationNoTextFieldId').getValue().trim(),
                                                       groupName: Ext.getCmp('groupNameComboId').getRawValue(),
                                                       groupId: Ext.getCmp('groupNameComboId').getValue(),
                                                       unitType: Ext.getCmp('unittypecomboId').getValue(),
                                                       mobileNo: Ext.getCmp('mobileNocomboId').getValue(),
                                                       assetModel: Ext.getCmp('assetModelcomboId').getValue(),
                                                       ownerName: Ext.getCmp('ownerNameId').getRawValue(),
                                                       ownerId: Ext.getCmp('ownerNameId').getValue(),
                                                       ownerAddress: Ext.getCmp('ownerAddressId').getValue(),
                                                       ownerPhoneNo: Ext.getCmp('ownerPhoneNoId').getValue(),
													   ownerEmailId: ownerEMail,
													   amount: Ext.getCmp('paymentAmountId').getValue(),
                                                       assetId: Ext.getCmp('assetId').getValue(),
                                                       custIdFormodify: Ext.getCmp('custcomboIdForModify').getValue(),
                                                       selectedCheckbox: Ext.getCmp('usersCheckBoxId').getValue(),
                                                       pageName: pageName
                                                   },
                                                   success: function(response, options) {
                                                       var message = response.responseText;
                                                       Ext.example.msg(message);
													   
													      if (prePaymentMode){
														   if(message.includes("Failed")){
															   
														   }else{
															   myWinForAssetRegistration.hide();
															  // assetRegistrationOuterPanelWindow.getEl().unmask();
															   outerPanel.getEl().unmask();
														   }
														}else{
														   myWinForAssetRegistration.hide();
														   //assetRegistrationOuterPanelWindow.getEl().unmask();
														   outerPanel.getEl().unmask();
													    }
													   
                                                     //  myWinForAssetRegistration.hide();
                                                     //  outerPanel.getEl().unmask();
                                                       
                                                       assetNoStore.load({
                                                       	params: {
                                                       	CustId: custId
                                                       	}
                                                       });
                                                       
                                                       unitTypeStore.load({
                                                           params: {
                                                               CustId: custId
                                                           }
                                                       });
                                                       mobileNumberStore.load({
                                                           params: {}
                                                       });
                                                       groupStore.load({
                                                           params: {
                                                               CustId: custId
                                                           }
                                                       });
                                                       assetTypeStore.load({
                                                           params: {
                                                               // CustId: custId
                                                           }
                                                       });
                                                       ownerStore.load({
                                                           params: {
                                                               CustId: custId
                                                           }
                                                       });
                                                       store.load({
                                                           params: {
                                                               CustId: Ext.getCmp('custcomboId').getValue(),
                                                               vehicleNo: vechNo
                                                           }
                                                       });
                                                   },
                                                   failure: function() {
                                                   Ext.example.msg("Error");
                                                   }
                                               });
                                               break;
                                           case 'no':
                                               myWinForAssetRegistration.show();
                                               break;
                                       }
                                   }
                               });
                           } else {
                               Ext.Msg.show({
                                   title: '<%=Confirmation%>',
                                   msg: '<%=Areyousurewanttoassociateonlytoyou%>',
                                   buttons: {
                                       yes: true,
                                       no: true
                                   },
                                   fn: function(btn) {
                                       switch (btn) {
                                           case 'yes':
                                               assetRegistrationOuterPanelWindow.getEl().mask();
                                               Ext.Ajax.request({
                                                   url: '<%=request.getContextPath()%>/ManageAssetAction.do?param=addModifyRegisterInformation',
                                                   method: 'POST',
                                                   params: {
                                                       buttonValue: buttonValue,
                                                       CustID: Ext.getCmp('custcomboId').getValue(),
                                                       custName: Ext.getCmp('custcomboId').getRawValue(),
                                                       assetType: Ext.getCmp('assettypecomboId').getValue(),
                                                       registrationNo: Ext.getCmp('registrationNoTextFieldId').getValue().trim(),
                                                       groupName: Ext.getCmp('groupNameComboId').getRawValue(),
                                                       groupId: Ext.getCmp('groupNameComboId').getValue(),
                                                       unitType: Ext.getCmp('unittypecomboId').getValue(),
                                                       mobileNo: Ext.getCmp('mobileNocomboId').getValue(),
                                                       assetModel: Ext.getCmp('assetModelcomboId').getValue(),
                                                       ownerName: Ext.getCmp('ownerNameId').getRawValue(),
                                                       ownerId: Ext.getCmp('ownerNameId').getValue(),
                                                       ownerAddress: Ext.getCmp('ownerAddressId').getValue(),
                                                       ownerPhoneNo: Ext.getCmp('ownerPhoneNoId').getValue(),
													   ownerEmailId: Ext.getCmp('ownerEmailId').getValue(),
													   amount: Ext.getCmp('paymentAmountId').getValue(),
                                                       assetId: Ext.getCmp('assetId').getValue(),
                                                       custIdFormodify: Ext.getCmp('custcomboIdForModify').getValue(),
                                                       selectedCheckbox: Ext.getCmp('usersCheckBoxId').getValue(),
                                                       pageName: pageName
                                                   },
                                                   success: function(response, options) {
                                                       var message = response.responseText;
                                                       Ext.example.msg(message);
													   if (prePaymentMode){
														   if(message.includes("Failed")){
															   
														   }else{
															   myWinForAssetRegistration.hide();
															   assetRegistrationOuterPanelWindow.getEl().unmask();
														   }
														}else{
														   myWinForAssetRegistration.hide();
														   assetRegistrationOuterPanelWindow.getEl().unmask();
													    }
                                                       
                                                      
                                                       clientcombostore.reload();
                                                       assetNoStore.load({
                                                       	params: {
                                                       	CustId: custId
                                                       	}
                                                       });
                                                       store.load({
                                                           params: {
                                                               CustId: Ext.getCmp('custcomboId').getValue(),
                                                               vehicleNo : Ext.getCmp('autoCompleteId').getValue()
                                                           }
                                                       });
                                                       unitTypeStore.load({
                                                           params: {
                                                               CustId: custId
                                                           }
                                                       });
                                                       mobileNumberStore.load({
                                                           params: {}
                                                       });
                                                       groupStore.load({
                                                           params: {
                                                               CustId: custId
                                                           }
                                                       });
                                                       assetTypeStore.load({
                                                           params: {
                                                               // CustId: custId
                                                           }
                                                       });
                                                       ownerStore.load({
                                                           params: {
                                                               CustId: custId
                                                           }
                                                       });
                                                   },
                                                   failure: function() {
                                                       Ext.example.msg("Error");
                                                       myWinForAssetRegistration.hide();
                                                   }
                                               });
                                               break;
                                           case 'no':
                                               myWinForAssetRegistration.show();
                                               break;
                                       }
                                   }
                               });
                           }
                       }
                       if (buttonValue == '<%=Modify%>') {
                           var modifiedgroupId = Ext.getCmp('groupNameComboId').getValue();
                           if (setGroupId != modifiedgroupId) {
                               if (Ext.getCmp('usersCheckBoxId').getValue() == true) {
                                   Ext.Msg.show({
                                       title: '<%=Confirmation%>',
                                       msg: '<%=DoYouWantToAssociateToAllUsersOfSelectedGroup%>',
                                       buttons: {
                                           yes: true,
                                           no: true
                                       },
                                       fn: function(btn) {
                                           switch (btn) {
                                               case 'yes':
                                                   myWinForAssetRegistration.hide();
                                                   outerPanel.getEl().mask();
                                                   var selected = grid.getSelectionModel().getSelected();
                                                   Ext.Ajax.request({
                                                       url: '<%=request.getContextPath()%>/ManageAssetAction.do?param=addModifyRegisterInformation',
                                                       method: 'POST',
                                                       params: {
                                                           buttonValue: buttonValue,
                                                           CustID: Ext.getCmp('custcomboId').getValue(),
                                                           custName: Ext.getCmp('custcomboId').getRawValue(),
                                                           assetType: Ext.getCmp('assettypecomboId').getValue(),
                                                           registrationNo: Ext.getCmp('registrationNoTextFieldId').getValue().trim(),
                                                           groupName: Ext.getCmp('groupNameComboId').getRawValue(),
                                                           groupId: Ext.getCmp('groupNameComboId').getValue(),
                                                           unitType: Ext.getCmp('unittypecomboId').getValue(),
                                                           mobileNo: Ext.getCmp('mobileNocomboId').getValue(),
                                                           assetModel: Ext.getCmp('assetModelcomboId').getValue(),
                                                           ownerName: Ext.getCmp('ownerNameId').getRawValue(),
                                                           ownerId: Ext.getCmp('ownerNameId').getValue(),
                                                           ownerAddress: Ext.getCmp('ownerAddressId').getValue(),
                                                           ownerPhoneNo: Ext.getCmp('ownerPhoneNoId').getValue(),
														   ownerEmailId: Ext.getCmp('ownerEmailId').getValue(),
														   amount: Ext.getCmp('paymentAmountId').getValue(),
                                                           assetId: Ext.getCmp('assetId').getValue(),
                                                           custIdFormodify: Ext.getCmp('custcomboIdForModify').getValue(),
                                                           selectedCheckbox: Ext.getCmp('usersCheckBoxId').getValue(),
                                                       pageName: pageName
                                                       },
                                                       success: function(response, options) {
                                                           var message = response.responseText;
                                                           Ext.example.msg(message);
                                                           if (prePaymentMode){
														   if(message.includes("Failed")){
															   
														   }else{
															   myWinForAssetRegistration.hide();
															   assetRegistrationOuterPanelWindow.getEl().unmask();
															   outerPanel.getEl().unmask();
														   }
														}else{
														   myWinForAssetRegistration.hide();
														   assetRegistrationOuterPanelWindow.getEl().unmask();
														   outerPanel.getEl().unmask();
													    }
                                                           
                                                           store.load({
                                                               params: {
                                                                   CustId: Ext.getCmp('custcomboId').getValue()
                                                               }
                                                           });
                                                           unitTypeStore.load({
                                                               params: {
                                                                   CustId: custId
                                                               }
                                                           });
                                                           mobileNumberStore.load({
                                                               params: {}
                                                           });
                                                           groupStore.load({
                                                               params: {
                                                                   CustId: custId
                                                               }
                                                           });
                                                           assetTypeStore.load({
                                                               params: {
                                                                   // CustId: custId
                                                               }
                                                           });
                                                           ownerStore.load({
                                                               params: {
                                                                   CustId: custId
                                                               }
                                                           });
                                                       },
                                                       failure: function() {
                                                       Ext.example.msg("Error");
                                                       }
                                                   });
                                                   break;
                                               case 'no':
                                                   myWinForAssetRegistration.show();
                                                   break;
                                           }
                                       }
                                   });
                               } else {
                                   Ext.Msg.show({
                                       title: '<%=Confirmation%>',
                                       msg: '<%=Areyousurewanttoassociateonlytoyou%>',
                                       buttons: {
                                           yes: true,
                                           no: true
                                       },
                                       fn: function(btn) {
                                           switch (btn) {
                                               case 'yes':
                                                   assetRegistrationOuterPanelWindow.getEl().mask();
                                                   Ext.Ajax.request({
                                                       url: '<%=request.getContextPath()%>/ManageAssetAction.do?param=addModifyRegisterInformation',
                                                       method: 'POST',
                                                       params: {
                                                           buttonValue: buttonValue,
                                                           CustID: Ext.getCmp('custcomboId').getValue(),
                                                           custName: Ext.getCmp('custcomboId').getRawValue(),
                                                           assetType: Ext.getCmp('assettypecomboId').getValue(),
                                                           registrationNo: Ext.getCmp('registrationNoTextFieldId').getValue().trim(),
                                                           groupName: Ext.getCmp('groupNameComboId').getRawValue(),
                                                           groupId: Ext.getCmp('groupNameComboId').getValue(),
                                                           unitType: Ext.getCmp('unittypecomboId').getValue(),
                                                           mobileNo: Ext.getCmp('mobileNocomboId').getValue(),
                                                           assetModel: Ext.getCmp('assetModelcomboId').getValue(),
                                                           ownerName: Ext.getCmp('ownerNameId').getRawValue(),
                                                           ownerId: Ext.getCmp('ownerNameId').getValue(),
                                                           ownerAddress: Ext.getCmp('ownerAddressId').getValue(),
                                                           ownerPhoneNo: Ext.getCmp('ownerPhoneNoId').getValue(),
														   ownerEmailId: Ext.getCmp('ownerEmailId').getValue(),
														   amount: Ext.getCmp('paymentAmountId').getValue(),
                                                           assetId: Ext.getCmp('assetId').getValue(),
                                                           custIdFormodify: Ext.getCmp('custcomboIdForModify').getValue(),
                                                           selectedCheckbox: Ext.getCmp('usersCheckBoxId').getValue(),
                                                       	   pageName: pageName
                                                       },
                                                       success: function(response, options) {
                                                           var message = response.responseText;
                                                           ctsb.setStatus({
                                                               text: getMessageForStatus(message),
                                                               iconCls: '',
                                                               clear: true
                                                           });
                                                              if (prePaymentMode){
														   if(message.includes("Failed")){
															   
														   }else{
															   myWinForAssetRegistration.hide();
															   assetRegistrationOuterPanelWindow.getEl().unmask();
															   outerPanel.getEl().unmask();
														   }
														}else{
														   myWinForAssetRegistration.hide();
														   assetRegistrationOuterPanelWindow.getEl().unmask();
														   outerPanel.getEl().unmask();
													    }
                                                           //assetRegistrationOuterPanelWindow.getEl().unmask();
                                                           clientcombostore.reload();
                                                           store.load({
                                                               params: {
                                                                   CustId: Ext.getCmp('custcomboId').getValue(),
                                                             	 	vehicleNo : Ext.getCmp('autoCompleteId').getValue()
                                                               }
                                                           });
                                                           unitTypeStore.load({
                                                               params: {
                                                                   CustId: custId
                                                               }
                                                           });
                                                           mobileNumberStore.load({
                                                               params: {}
                                                           });
                                                           groupStore.load({
                                                               params: {
                                                                   CustId: custId
                                                               }
                                                           });
                                                           assetTypeStore.load({
                                                               params: {
                                                                   // CustId: custId
                                                               }
                                                           });
                                                           ownerStore.load({
                                                               params: {
                                                                   CustId: custId
                                                               }
                                                           });
                                                       },
                                                       failure: function() {
                                                           Ext.example.msg("Error");
                                                           myWinForAssetRegistration.hide();
                                                       }
                                                   });
                                                   break;
                                               case 'no':
                                                   myWinForAssetRegistration.show();
                                                   break;
                                           }
                                       }
                                   });
                               }
                           } else {
                               var selected = grid.getSelectionModel().getSelected();
                               assetRegistrationOuterPanelWindow.getEl().mask();
                               outerPanel.getEl().mask();
                               Ext.Ajax.request({
                                   url: '<%=request.getContextPath()%>/ManageAssetAction.do?param=addModifyRegisterInformation',
                                   method: 'POST',
                                   params: {
                                       buttonValue: buttonValue,
                                       CustID: Ext.getCmp('custcomboId').getValue(),
                                       custName: Ext.getCmp('custcomboId').getRawValue(),
                                       assetType: Ext.getCmp('assettypecomboId').getValue(),
                                       registrationNo: Ext.getCmp('registrationNoTextFieldId').getValue().trim(),
                                       groupName: Ext.getCmp('groupNameComboId').getRawValue(),
                                       groupId: Ext.getCmp('groupNameComboId').getValue(),
                                       unitType: Ext.getCmp('unittypecomboId').getValue(),
                                       mobileNo: Ext.getCmp('mobileNocomboId').getValue(),
                                       assetModel: Ext.getCmp('assetModelcomboId').getValue(),
                                       ownerName: Ext.getCmp('ownerNameId').getRawValue(),
                                       ownerId: Ext.getCmp('ownerNameId').getValue(),
                                       ownerAddress: Ext.getCmp('ownerAddressId').getValue(),
                                       ownerPhoneNo: Ext.getCmp('ownerPhoneNoId').getValue(),
									   ownerEmailId: Ext.getCmp('ownerEmailId').getValue(),
									   amount: Ext.getCmp('paymentAmountId').getValue(),
                                       assetId: Ext.getCmp('assetId').getValue(),
                                       custIdFormodify: Ext.getCmp('custcomboIdForModify').getValue(),
                                       selectedCheckbox: Ext.getCmp('usersCheckBoxId').getValue(),
                                       pageName: pageName
                                   },
                                   success: function(response, options) {
                                       var message = response.responseText;
                                       Ext.example.msg(message);
									      if (prePaymentMode){
												if(message.includes("Failed")){
													
												  }else{
														myWinForAssetRegistration.hide();
														assetRegistrationOuterPanelWindow.getEl().unmask();
														outerPanel.getEl().unmask();
												}
											}else{
														   myWinForAssetRegistration.hide();
														   assetRegistrationOuterPanelWindow.getEl().unmask();
														   outerPanel.getEl().unmask();
													    }
                                      // myWinForAssetRegistration.hide();
                                      // outerPanel.getEl().unmask();
                                      // assetRegistrationOuterPanelWindow.getEl().unmask();
                                       store.load({
                                           params: {
                                               CustId: Ext.getCmp('custcomboId').getValue(),
                                                vehicleNo : Ext.getCmp('autoCompleteId').getValue()
                                           }
                                       });
                                       unitTypeStore.load({
                                           params: {
                                               CustId: custId
                                           }
                                       });
                                       mobileNumberStore.load({
                                           params: {}
                                       });
                                       groupStore.load({
                                           params: {
                                               CustId: custId
                                           }
                                       });
                                       assetTypeStore.load({
                                           params: {
                                               // CustId: custId
                                           }
                                       });
                                       ownerStore.load({
                                           params: {
                                               CustId: custId
                                           }
                                       });
                                   },
                                   failure: function() {
                                   Ext.example.msg("Error");
                                   }
                               });
                           }
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
                       myWinForAssetRegistration.hide();
                   }
               }
           }
       }]
   });
   
   var caseInnerPanel = new Ext.Panel({
       standardSubmit: true,
       collapsible: false,
       autoScroll: true,
       height: 425,
       width: 480,
       frame: true,
       id: 'addCaseInfo',
       layout: 'table',
       layoutConfig: {
           columns: 2
       },
       items: [{
           xtype: 'fieldset',
           title: '<%=AssetRegistrationDetails%>',
           collapsible: false,
           colspan: 3,
           width: 450,
           autoScroll: false,
           id: 'caseinfopanelid',
           layout: 'table',
           layoutConfig: {
               columns: 1
           },
           items: [innerPanelForAssetRegistration, secondPanelForUnitDetails, secondPanelForMobileDetails]
       }]
   });
   
   var assetRegistrationOuterPanelWindow = new Ext.Panel({
       width: 490,
       height: 790,
       standardSubmit: true,
       frame: true,
       items: [caseInnerPanel, innerWinButtonPanelForAssetRegistration]
   });
   
   myWinForAssetRegistration = new Ext.Window({
       title: titelForInnerPanel,
       closable: false,
       resizable: false,
       modal: true,
       autoScroll: false,
       height: 530,
       width: 490,
       id: 'myWinForAssetRegistrationId',
       items: [assetRegistrationOuterPanelWindow]
   });
	
	
   function addRecord() {
	   
       if (Ext.getCmp('custcomboId').getValue() == "") {
		   
           Ext.example.msg("<%=SelectCustomerName%>");
           return;
       }
       groupStore.load({
           params: {
               CustId: Ext.getCmp('custcomboId').getValue()
           }
       });
       ownerStore.load({
           params: {
               CustId: Ext.getCmp('custcomboId').getValue()
           }
       });
       unitTypeStore.load({
           params: {
               CustId: custId
           }
       });
       mobileNumberStore.load({
           params: {}
       });
       
	  buttonValue = '<%=AddNew%>';
	    
	   if (prePaymentMode) {
		   Ext.getCmp('addButtId').setText('Send Payment Request ');
	      
		   Ext.getCmp('mandatoryPaymentAmountForAdd').setText("*");
		   Ext.getCmp('paymentAmountId').setValue('<%=totalAmount%>');
		   Ext.getCmp('mandatoryownerNameIdForAdd').setText("*");
	   }else{
		    Ext.getCmp('paymentAmountId').hide();
			Ext.getCmp('mandatoryPaymentAmountForAdd').hide();
			Ext.getCmp('paymentAmountForTxt').hide();
			Ext.getCmp('ownerEmailId').hide();
			Ext.getCmp('mandatoryownerEmailIdForAdd').hide();
			Ext.getCmp('ownerEmailIdForTxt').hide();
	   }
	  
	   
	  //Ext.getCmp('usersCheckBoxId').show();
       titelForInnerPanel = '<%=AssetInformation%>';
       myWinForAssetRegistration.setPosition(410, 5);
       myWinForAssetRegistration.show();
       Ext.getCmp('usersCheckBoxId').setValue("true");
       Ext.getCmp('ownerAddressId').disable();
       Ext.getCmp('ownerPhoneNoId').disable();
	   Ext.getCmp('paymentAmountId').disable();
	   
       Ext.getCmp('registrationNoTextFieldId').enable();
       Ext.getCmp('mobileNocomboId').enable();
       Ext.getCmp('mobileDetailsPanelId').hide();
       Ext.getCmp('secondPanelId').hide();
       myWinForAssetRegistration.setTitle(titelForInnerPanel);
       Ext.getCmp('assettypecomboId').reset();
       Ext.getCmp('registrationNoTextFieldId').reset();
       Ext.getCmp('groupNameComboId').reset();
       Ext.getCmp('unittypecomboId').reset();
       Ext.getCmp('mobileNocomboId').reset();
       Ext.getCmp('assetModelcomboId').reset();
       Ext.getCmp('ownerNameId').reset();
       Ext.getCmp('ownerAddressId').reset();
       Ext.getCmp('ownerPhoneNoId').reset();
	   Ext.getCmp('ownerEmailId').reset();
	   Ext.getCmp('paymentAmountId').reset();
       Ext.getCmp('assetId').reset();
       Ext.getCmp('mandatoryclientId').hide();
       Ext.getCmp('clientTxtId').hide();
      // Ext.getCmp('mandatoryclientId1').hide();
       Ext.getCmp('custcomboIdForModify').hide();
   }

   function modifyData() {
   		 Ext.getCmp('addButtId').setText('<%=Save%>');
   		 var selected = grid.getSelectionModel().getSelected();
       if(selected.get('manufactureIdDataIndex')=="32"){
       		Ext.getCmp('mobileNocomboId').disable();	
       }else{
       		Ext.getCmp('mobileNocomboId').enable();
       }
      //  clientcombostore.reload();  -- has been commented as inturn loads Grid.
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
       ownerStore.load({
           params: {
               CustId: Ext.getCmp('custcomboId').getValue()
           }
       });
       unitTypeStore.load({
           params: {
               CustId: custId
           }
       });
       mobileNumberStore.load({
           params: {}
       });
       buttonValue = '<%=Modify%>';
       // Ext.getCmp('usersCheckBoxId').hide();
       titelForInnerPanel = '<%=ModifyInformation%>';
       myWinForAssetRegistration.setPosition(410, 5);
       myWinForAssetRegistration.setTitle(titelForInnerPanel);
       myWinForAssetRegistration.show();
       Ext.getCmp('usersCheckBoxId').setValue("true");
       Ext.getCmp('registrationNoTextFieldId').disable();
       Ext.getCmp('ownerAddressId').disable();
       Ext.getCmp('ownerPhoneNoId').disable();
	   Ext.getCmp('ownerEmailId').disable();
	   Ext.getCmp('paymentAmountId').disable();
       Ext.getCmp('custcomboIdForModify').setValue(Ext.getCmp('custcomboId').getValue());
       Ext.getCmp('assettypecomboId').setValue(selected.get('assetTypeDataIndex'));
       Ext.getCmp('registrationNoTextFieldId').setValue(selected.get('registrationNumberDataIndex'));
       Ext.getCmp('groupNameComboId').setValue(selected.get('groupNameDataIndex'));
       Ext.getCmp('unittypecomboId').setValue(selected.get('unitNoDataIndex'));
       Ext.getCmp('groupNameComboId').setValue(selected.get('groupIdDataIndex'));
       Ext.getCmp('mobileNocomboId').setValue(selected.get('phoneNoDataIndex'));
       Ext.getCmp('ownerNameId').setRawValue(selected.get('ownerNameDataIndex'));
       Ext.getCmp('ownerAddressId').setValue(selected.get('ownerAddressDataIndex'));
       Ext.getCmp('ownerPhoneNoId').setValue(selected.get('ownerPhoneNoDataIndex'));
	   Ext.getCmp('ownerEmailId').setValue(selected.get('ownerEmailDataIndex'));
       Ext.getCmp('assetId').setValue(selected.get('assetIdDataIndex'));
       Ext.getCmp('assetModelcomboId').setValue(selected.get('assetModelDataIndex'));
       if (selected.get('assetModelDataIndex') != "") {
           Ext.getCmp('assetModelcomboId').setValue(selected.get('modelTypeIdDataIndex'));
       }
       Ext.getCmp('secondPanelId').hide();
       Ext.getCmp('mobileDetailsPanelId').hide();
       Ext.getCmp('mandatoryclientId').show();
       Ext.getCmp('clientTxtId').show();
      // Ext.getCmp('mandatoryclientId1').show();
       Ext.getCmp('custcomboIdForModify').show();
       setGroupId = selected.get('groupIdDataIndex');
   }
   var deletePanel = new Ext.form.FormPanel({
       standardSubmit: true,
       collapsible: false,
       autoScroll: true,
       height: 100,
       width: 440,
       frame: false,
       id: 'deleteid',
       layout: 'table',
       layoutConfig: {
           columns: 4,
           style: {}
       },
       items: [{
           xtype: 'fieldset',
           title: '<%=DeleteInformation%>',
           width: 400,
           collapsible: false,
           layout: 'table',
           layoutConfig: {
               columns: 4
           },
           items: [{
                   xtype: 'label',
                   text: '<%=Reason%>' + ' :',
                   cls: 'labelstyle',
                   id: 'reasontxt'
               }, {
                   xtype: 'label',
                   text: '',
                   cls: 'mandatoryfield',
                   id: 'mandatoryReasonComboId'
               }, {
                   width: 98
               },
               reasonCombo
           ]
       }]
   });
   
   var deletePanelForNoteAndToTypeDelete = new Ext.form.FormPanel({
       standardSubmit: true,
       collapsible: false,
       autoScroll: true,
       height: 100,
       width: 440,
       frame: false,
       id: 'deletePanelForNoteAndToTypeDeleteId',
       layout: 'table',
       layoutConfig: {
           columns: 4,
           style: {}
       },
       items: [{
           xtype: 'fieldset',
           title: '<%=DeleteConfirmation%>',
           width: 400,
           collapsible: false,
           layout: 'table',
           layoutConfig: {
               columns: 4
           },
           items: [{
               xtype: 'label',
               text: '<%=TypeDELETEtoconfirm%>' + ' :',
               cls: 'labelstyle',
               id: 'empty111'
           }, {
               width: 30
           }, {
               xtype: 'textfield',
               cls: 'selectstylePerfect',
               id: 'deleteTypeId'
           }]
       }]
   });
   
   var deletePanelForNoteAndToTypeDelete1 = new Ext.form.FormPanel({
       standardSubmit: true,
       collapsible: false,
       autoScroll: true,
       height: 40,
       width: 430,
       frame: false,
       id: 'deletePanelForNoteAndToTypeDeleteId1',
       layout: 'table',
       layoutConfig: {
           columns: 2,
           style: {}
       },
       items: [{
           xtype: 'label',
           text: '<%=Note%>:',
           cls: 'labelstyle',
           id: 'empty11115'
       }, {
           xtype: 'label',
           text: '<%=AllTheDetailsRegardingToThisRegistrationNumberWillBeRemoved%>',
           cls: 'labelstyle',
           id: 'deleteTypeId15'
       }]
   });
   var deleteButtonPanel = new Ext.Panel({
       id: 'reasonpanelid',
       standardSubmit: true,
       collapsible: false,
       autoHeight: true,
       height: 5,
       width: 450,
       frame: true,
       layout: 'table',
       layoutConfig: {
           columns: 4
       },
       buttons: [{
           xtype: 'button',
           text: '<%=Delete%>',
           id: 'saveId',
           cls: 'buttonstyle',
           iconCls : 'deletebutton',
           width: 70,
           listeners: {
               click: {
                   fn: function() {
                       deleteDataForSure();
                   }
               }
           }
       }, {
           xtype: 'button',
           text: '<%=Cancel%>',
           id: 'cancelButtonId',
           cls: 'buttonstyle',
           iconCls: 'cancelbutton',
           width: 70,
           listeners: {
               click: {
                   fn: function() {
                       deleteWin.hide();
                   }
               }
           }
       }]
   });
   var assetDeletePanelWindow = new Ext.Panel({
       height: 300,
       width: 450,
       standardSubmit: true,
       frame: true,
       items: [{
           xtype: 'fieldset',
           //title: 'Delete Confirmation',
           width: 435,
           collapsible: false,
           layout: 'table',
           layoutConfig: {
               columns: 1
           },
           items: [deletePanel, deletePanelForNoteAndToTypeDelete, deletePanelForNoteAndToTypeDelete1]
       }]
   });
   deleteWin = new Ext.Window({
       closable: false,
       resizable: false,
       modal: true,
       autoScroll: false,
       height: 390,
       width: 470,
       id: 'myWinDeleteId',
       items: [assetDeletePanelWindow, deleteButtonPanel]
   });

   function deleteData() {
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
       var selected = grid.getSelectionModel().getSelected();
       var RegistrationNo= selected.get('registrationNumberDataIndex');
       var isBlocked = blockedVehicleStore.findExact('RegistrationNo',RegistrationNo);
       if(isBlocked >0){
      	 Ext.example.msg("Vehicle has been blocked,cannot Un-Register");
         return;
       }
       
       buttonValue = '<%=Delete%>';
       titel = '<%=DeleteDetails%>';
       deleteWin.setPosition(410, 30);
       deleteWin.show();
       deleteWin.setTitle(titel);
       Ext.getCmp('reasonComboId').reset();
       Ext.getCmp('deleteTypeId').reset();
   }

   function deleteDataForSure() {
   		var selected = grid.getSelectionModel().getSelected();
       var RegistrationNo= selected.get('registrationNumberDataIndex');
       var isBlocked = blockedVehicleStore.findExact('RegistrationNo',RegistrationNo);
       if(isBlocked >0){
      	 Ext.example.msg("Vehicle Has Been Blocked,Cannot Un-Register");
         return;
       }else{
       if (Ext.getCmp('reasonComboId').getValue() == "") {
           Ext.example.msg("<%=EnterReason%>");
           Ext.getCmp('reasonComboId').focus();
           return;
       }
       if (Ext.getCmp('deleteTypeId').getValue() == '') {
           Ext.example.msg("<%=PLEASEENTERDELETEINABOVETEXTFIELD%>");
           Ext.getCmp('deleteTypeId').focus();
           return;
       }
       if (Ext.getCmp('deleteTypeId').getValue() == 'DELETE') {
           deleteWin.hide();
           Ext.Msg.show({
               title: 'Delete',
               msg: '<%=Areyousureyouwanttodelete%>',
               buttons: {
                   yes: true,
                   no: true
               },
               fn: function(btn) {
                   switch (btn) {
                       case 'yes':
                           outerPanel.getEl().mask();
                           var selected = grid.getSelectionModel().getSelected();
                           Ext.Ajax.request({
                               url: '<%=request.getContextPath()%>/ManageAssetAction.do?param=deleteRecord',
                               method: 'POST',
                               params: {
                                   vehicleRegistrationNo: selected.get('registrationNumberDataIndex'),
                                   reason: Ext.getCmp('reasonComboId').getRawValue(),
                                   unitNumber: selected.get('unitNoDataIndex'),
                                   mobileNo: mobileNo,
                                   custName: Ext.getCmp('custcomboId').getRawValue(),
                                   custId: Ext.getCmp('custcomboId').getValue(),
                                   assettype: selected.get('assetTypeDataIndex'),
                                   pageName: pageName
                               },
                               success: function(response, options) {
                                   var message = response.responseText;
                                   Ext.example.msg(message);
                                   outerPanel.getEl().unmask();
                                   //deleteWinForTypingDeleteInCaps.hide();
                                   deleteWin.hide();
                                   store.load({
                                       params: {
                                           CustId: Ext.getCmp('custcomboId').getValue(),
                                           vehicleNo : Ext.getCmp('autoCompleteId').getValue()
                                       }
                                   });
                                   unitTypeStore.load({
                                       params: {
                                           CustId: custId
                                       }
                                   });
                                   mobileNumberStore.load({
                                       params: {}
                                   });
                                   groupStore.load({
                                       params: {
                                           CustId: custId
                                       }
                                   });
                                   assetTypeStore.load({
                                       params: {
                                           // CustId: custId
                                       }
                                   });
                                   ownerStore.load({
                                       params: {
                                           CustId: custId
                                       }
                                   });
                               },
                               failure: function() {
                               Ext.example.msg("Error");
                                   //  deleteWinForTypingDeleteInCaps.hide();
                               }
                           });
                           break;
                       case 'no':
                           Ext.example.msg("<%=VehicleNotDeleted%>");
                           // store.reload();
                           break;
                   }
               }
           });
       } else {
           if (Ext.getCmp('deleteTypeId').getValue() != 'DELETE') {
           Ext.example.msg("<%=PleaseEnterDELETEInCapitalLettersToDeleteTheRecord%>");
               Ext.getCmp('deleteTypeId').focus();
               //return;
               Ext.getCmp('deleteTypeId').reset();
           }
         }
       }
   }
   
   var reader = new Ext.data.JsonReader({
       idProperty: 'taskMasterid',
       root: 'assetRegistrationRoot',
       totalProperty: 'total',
       fields: [{
           name: 'slnoIndex'
       }, {
           name: 'registrationNumberDataIndex'
       }, {
           name: 'assetTypeDataIndex'
       }, {
           name: 'unitNoDataIndex'
       }, {
           name: 'phoneNoDataIndex'
       }, {
           name: 'groupNameDataIndex'
       }, {
           name: 'assetModelDataIndex'
       }, {
           name: 'groupIdDataIndex'
       }, {
           name: 'ownerNameDataIndex'
       }, {
           name: 'ownerAddressDataIndex'
       }, {
           name: 'ownerPhoneNoDataIndex'
       }, {
           name: 'assetIdDataIndex'
       }, {
           name: 'modelTypeIdDataIndex'
       }, {
           name: 'registeredDateDataIndex',
           type: 'date'
               // format: getDateTimeFormat()
       }, {
           name: 'associatedDateDataIndex',
           type: 'date'
       }, {
           name: 'registeredByDataIndex'
       }, {
           name: 'manufactureIdDataIndex'
       }]
   });
   var store = new Ext.data.GroupingStore({
       autoLoad: false,
       proxy: new Ext.data.HttpProxy({
           url: '<%=request.getContextPath()%>/ManageAssetAction.do?param=getManageRegistrationReport',
           method: 'POST'
       }),
       remoteSort: false,
       sortInfo: {
           field: 'registrationNumberDataIndex',
           direction: 'ASC'
       },
       storeId: 'assetRegistrationId',
       reader: reader
   });
   var filters = new Ext.ux.grid.GridFilters({
       local: true,
       filters: [{
           type: 'numeric',
           dataIndex: 'slnoIndex'
       }, {
           type: 'string',
           dataIndex: 'registrationNumberDataIndex'
       }, {
           type: 'string',
           dataIndex: 'assetTypeDataIndex'
       }, {
           type: 'string',
           dataIndex: 'unitNoDataIndex'
       }, {
           type: 'string',
           dataIndex: 'mobileNoDataIndex'
       }, {
           type: 'string',
           dataIndex: 'phoneNoDataIndex'
       }, {
           type: 'string',
           dataIndex: 'groupNameDataIndex'
       }, {
           type: 'string',
           dataIndex: 'assetModelDataIndex'
       }, {
           type: 'int',
           dataIndex: 'groupIdDataIndex'
       }, {
           type: 'date',
           dataIndex: 'registeredDateDataIndex'
       }, {
           type: 'date',
           dataIndex: 'associatedDateDataIndex'
       }, {
           type: 'string',
           dataIndex: 'registeredByDataIndex'
       }, {
           type: 'string',
           dataIndex: 'manufactureIdDataIndex'
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
               header: "<span style=font-weight:bold;><%=AssetNumber%></span>",
               dataIndex: 'registrationNumberDataIndex',
               width: 100,
               filter: {
                   type: 'date'
               }
           }, {
               header: "<span style=font-weight:bold;><%=AssetType%></span>",
               dataIndex: 'assetTypeDataIndex',
               width: 100,
               filter: {
                   type: 'string'
               }
           }, {
               header: "<span style=font-weight:bold;><%=UnitNumber%></span>",
               dataIndex: 'unitNoDataIndex',
               width: 100,
               filter: {
                   type: 'string'
               }
           }, {
               header: "<span style=font-weight:bold;><%=PhoneNo%></span>",
               dataIndex: 'phoneNoDataIndex',
               width: 100,
               filter: {
                   type: 'string'
               }
           }, {
               header: "<span style=font-weight:bold;><%=GroupName%></span>",
               dataIndex: 'groupNameDataIndex',
               width: 100,
               filter: {
                   type: 'string'
               }
           }, {
               header: "<span style=font-weight:bold;><%=AssetModel%></span>",
               dataIndex: 'assetModelDataIndex',
               width: 100,
               filter: {
                   type: 'string'
               }
           }, {
               header: "<span style=font-weight:bold;><%=GroupId%></span>",
               dataIndex: 'groupIdDataIndex',
               hidden: true,
               width: 100,
               filter: {
                   type: 'int'
               }
           }, {
               header: "<span style=font-weight:bold;><%=OwnerName%></span>",
               dataIndex: 'ownerNameDataIndex',
               hidden: true,
               width: 100,
               filter: {
                   type: 'String'
               }
           }, {
               header: "<span style=font-weight:bold;><%=OwnerAddress%></span>",
               dataIndex: 'ownerAddressDataIndex',
               hidden: true,
               width: 100,
               filter: {
                   type: 'String'
               }
           }, {
               header: "<span style=font-weight:bold;><%=OwnerPhoneNo%></span>",
               dataIndex: 'ownerPhoneNoDataIndex',
               hidden: true,
               width: 100,
               filter: {
                   type: 'String'
               }
           }, {
               header: "<span style=font-weight:bold;><%=AssetId%></span>",
               dataIndex: 'assetIdDataIndex',
               hidden: true,
               width: 100,
               filter: {
                   type: 'String'
               }
           }, {
               header: "<span style=font-weight:bold;><%=ModelTypeId%></span>",
               dataIndex: 'modelTypeIdDataIndex',
               hidden: true,
               width: 100,
               filter: {
                   type: 'int'
               }
           }, {
               header: "<span style=font-weight:bold;><%=RegisteredDate%></span>",
               dataIndex: 'registeredDateDataIndex',
               renderer: Ext.util.Format.dateRenderer(getDateTimeFormat()),
               hidden: false,
               width: 100,
               filter: {
                   type: 'date'
               }
           }, {
               header: "<span style=font-weight:bold;><%=AssociatedDate%></span>",
               dataIndex: 'associatedDateDataIndex',
               hidden: false,
               sortable: true,
               renderer: Ext.util.Format.dateRenderer(getDateTimeFormat()),
               width: 100,
               filter: {
                   type: 'date'
               }
           }, {
               header: "<span style=font-weight:bold;><%=RegisteredBy%></span>",
               dataIndex: 'registeredByDataIndex',
               hidden: false,
               width: 100,
               filter: {
                   type: 'String'
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
   <%
 
 
   if (systemId == 268){
   
   if(customerId > 0 )
   {
	if(userAuthority.equalsIgnoreCase("Admin"))
	{%>    
    		grid = getGridManagerNew('', '<%=NoRecordsFound%>', store, screen.width - 45, 440, 18, filters,  false, '',false, 16, false, '', false, '', false, '<%=Excel%>', jspName, exportDataType, false, 'PDF', <%= addbutton %> , '<%=AddNew%>', <%= modifybutton %> , '<%=Modify%>', true , '<%=Delete%>');
 	<%} else if(userAuthority.equalsIgnoreCase("Supervisor")) {%>
 			grid = getGridManagerNew('', '<%=NoRecordsFound%>', store, screen.width - 45, 440, 18, filters, false, '', false,16, false, '', false, '', false, '<%=Excel%>', jspName, exportDataType, false, 'PDF', <%= addbutton %> , '<%=AddNew%>', <%= modifybutton %> , '<%=Modify%>', true , '<%=Delete%>');
 		<%} else {%>
  			grid = getGridManagerNew('', '<%=NoRecordsFound%>', store, screen.width - 45, 440, 18, filters,  false, '', false,16, false, '', false, '', false, '<%=Excel%>', jspName, exportDataType, false, 'PDF', <%= addbutton %> , '<%=AddNew%>',<%= modifybutton %> , '<%=Modify%>', true, '<%=Delete%>');
 			<%}
     } else {%>
			grid = getGridManagerNew('', '<%=NoRecordsFound%>', store, screen.width - 45, 440, 18, filters,  false, '', false,16, false, '', false, '', false, '<%=Excel%>', jspName, exportDataType, false, 'PDF', <%= addbutton %> , '<%=AddNew%>', <%= modifybutton %> , '<%=Modify%>', true , '<%=Delete%>');
	<% }
	}else{
	if(customerId > 0 )
   {
	if(userAuthority.equalsIgnoreCase("Admin"))
	{%>    
    		grid = getGridManager('', '<%=NoRecordsFound%>', store, screen.width - 45, 440, 18, filters,  '<%=ClearFilterData%>', '',false, 16, false, '', false, '', false, '<%=Excel%>', jspName, exportDataType, false, 'PDF', <%= addbutton %> , '<%=AddNew%>', <%= modifybutton %> , '<%=Modify%>', true , '<%=Delete%>');
 	<%} else if(userAuthority.equalsIgnoreCase("Supervisor")) {%>
 			grid = getGridManager('', '<%=NoRecordsFound%>', store, screen.width - 45, 440, 18, filters,  '<%=ClearFilterData%>','',  false, 16, false, '', false, '', false, '<%=Excel%>', jspName, exportDataType, false, 'PDF', <%= addbutton %> , '<%=AddNew%>', <%= modifybutton %> , '<%=Modify%>', true , '<%=Delete%>');
 		<%} else {%>
  					   grid = getGridManager('', '<%=NoRecordsFound%>', store, screen.width - 45, 440, 18, filters,  '<%=ClearFilterData%>', '', false , 16, false, '', false, '', false, '<%=Excel%>', jspName, exportDataType, false, 'PDF', <%= addbutton %> , '<%=AddNew%>',<%= modifybutton %> , '<%=Modify%>', true, '<%=Delete%>');
 			<%}
     } else {%>
			   grid = getGridManager('', '<%=NoRecordsFound%>', store, screen.width - 45, 440, 18, filters,  '<%=ClearFilterData%>','', false, 16, false, '', false, '', false, '<%=Excel%>', jspName, exportDataType, false, 'PDF', <%= addbutton %> , '<%=AddNew%>', <%= modifybutton %> , '<%=Modify%>', true , '<%=Delete%>');
	<% }
	
	}
	
	%>
   
   false
   
   var nextButtonPanel = new Ext.Panel({
       id: 'nextbuttonid',
       standardSubmit: true,
       collapsible: false,
       cls: 'nextbuttonpanel',
       width: 100,
       frame: false,
       layout: 'table',
       layoutConfig: {
           columns: 1
       },
       items: [{
           xtype: 'button',
           text: '<%=Next%>',
           id: 'nextButtId',
           iconCls: 'nextbutton',
           width: 70,
           listeners: {
               click: {
                   fn: function() {
                       if (Ext.getCmp('custcomboId').getValue() == "") {
                       Ext.example.msg("<%=SelectCustomerName%>");
                           Ext.getCmp('custcomboId').focus();
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
                   }
               }
           }
       }]
   });
   Ext.onReady(function() {
       ctsb = tsb;
       Ext.QuickTips.init();
       Ext.form.Field.prototype.msgTarget = 'side';
       outerPanel = new Ext.Panel({
           //title: '<%=AssetRegistration%>',
           renderTo: 'content',
           standardSubmit: true,
           frame: true,
           width: screen.width - 38,
           height: 495,
           cls: 'outerpanel',
           layout: 'table',
           layoutConfig: {
               columns: 1
           },
           items: [comboPanel, grid]
           //bbar: ctsb
       });
       sb = Ext.getCmp('form-statusbar');
   });
</script>
	</body>
</html>
