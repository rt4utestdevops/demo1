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
tobeConverted.add("Enter_Customer_name"); 
tobeConverted.add("Enter_Gender");       
tobeConverted.add("Enter_Martial_Status");  

tobeConverted.add("Enter_Employment_Type");   
tobeConverted.add("Select_State");
tobeConverted.add("Select_Country");

tobeConverted.add("Select_Group_Name");
tobeConverted.add("Personal_Information");
tobeConverted.add("First_Name");

tobeConverted.add("Enter_First_Name");
tobeConverted.add("Last_Name");              
tobeConverted.add("Enter_Last_Name");

tobeConverted.add("Address");
tobeConverted.add("Enter_Address");
tobeConverted.add("Permanent_Address");

tobeConverted.add("Enter_Permanent_Address");
tobeConverted.add("City");
tobeConverted.add("Enter_City");

tobeConverted.add("Other_City");
tobeConverted.add("Enter_Other_City");
tobeConverted.add("State"); 
              
tobeConverted.add("Country");
tobeConverted.add("Telephone_No");
tobeConverted.add("Enter_Telephone_No");

tobeConverted.add("Mobile_No"); 
tobeConverted.add("Enter_Mobile_No");
tobeConverted.add("Date_Of_Birth");

tobeConverted.add("Gender");
tobeConverted.add("Nationality");
tobeConverted.add("Enter_Nationality");

tobeConverted.add("Martial_Status");             
tobeConverted.add("Please_Select_customer");
tobeConverted.add("Save");

tobeConverted.add("Cancel");
tobeConverted.add("Employment_Information");
tobeConverted.add("Employment_Type");

tobeConverted.add("Employment_ID");
tobeConverted.add("Enter_Employment_Id");
tobeConverted.add("Client");

tobeConverted.add("Enter_Client");
tobeConverted.add("Date_Of_Joining");               
tobeConverted.add("Enter_Date_Of_Joining");

tobeConverted.add("Date_Of_Leaving");
tobeConverted.add("Blood_Group");
tobeConverted.add("Enter_Blood_Group");

tobeConverted.add("Group_Name");
tobeConverted.add("Active_Status");
tobeConverted.add("Enter_Active_Status");

tobeConverted.add("Remarks");
tobeConverted.add("Enter_Remarks");
tobeConverted.add("Government_Or_Residence_ID");   
        
tobeConverted.add("Enter_Government_Or_Residence_ID");           
tobeConverted.add("Customer");
tobeConverted.add("Rfid_Code");

tobeConverted.add("Enter_Rfid_Code");
tobeConverted.add("Insurance_Information");
tobeConverted.add("Medical_Insurance_No");

tobeConverted.add("Enter_Medical_Insurance_No");
tobeConverted.add("Medical_Insurance_Company");
tobeConverted.add("Enter_Medical_Insurance_Company");

tobeConverted.add("Medical_Insurance_Expiry_Date");       
tobeConverted.add("Driver_Information");
tobeConverted.add("License_No");

tobeConverted.add("Enter_License_No");
tobeConverted.add("License_Place");
tobeConverted.add("Enter_License_Place");

tobeConverted.add("License_Issue_Date");
tobeConverted.add("License_Renewed_Date");
tobeConverted.add("License_Expiry_Date");

tobeConverted.add("Gunmen_Information");
tobeConverted.add("Gun_License_No");           
tobeConverted.add("Enter_Gun_License_No");

tobeConverted.add("Gun_License_Type");
tobeConverted.add("Enter_Gun_License_Type");
tobeConverted.add("Gun_License_Issue_Date");

tobeConverted.add("Gun_License_Issue_Place");
tobeConverted.add("Enter_Gun_License_Issue_Place");
tobeConverted.add("Gun_License_Expiry_Date");

tobeConverted.add("Employee_Name");
tobeConverted.add("Employee_Type");
tobeConverted.add("Driver_Details"); 
          
tobeConverted.add("Customer_Name");
tobeConverted.add("Crew_Master_Information");
tobeConverted.add("Crew_Master_Data_Report");


tobeConverted.add("Select_Status");
tobeConverted.add("Edit");
tobeConverted.add("Select_Driver");

tobeConverted.add("Select_Customer_Name");
tobeConverted.add("Personal_Information_Details"); 
tobeConverted.add("Government_Or_Residence_ID_Expiry_Date");

tobeConverted.add("Employee_Information_Details");        
tobeConverted.add("Insurance_Information_Details");
tobeConverted.add("Enter_Expiry_Date");

tobeConverted.add("Driver_Information_Details");
tobeConverted.add("Gunmen_Information");
tobeConverted.add("Driver_Id");

tobeConverted.add("Crew_Information");
tobeConverted.add("Gunmen_Information_Details");
tobeConverted.add("Next");

tobeConverted.add("Add_Crew");
tobeConverted.add("Employee_Information_Details");          
tobeConverted.add("Insurance_Information");

tobeConverted.add("Insurance_Information_Details");
tobeConverted.add("Driver_Information");
tobeConverted.add("Gunmen_Information_Details");  
       
tobeConverted.add("Crew_Details");
tobeConverted.add("Gunmen_Information");
tobeConverted.add("Enter_Employee_Unique_Code");

tobeConverted.add("Enter_License_Expiry_Date");
tobeConverted.add("Employee_Unique_Code");         
tobeConverted.add("Enter_Gun_License_Expiry_Date");

tobeConverted.add("Enter_Gun_License_Number");

tobeConverted.add("Workman_Compensation_Id");
tobeConverted.add("Enter_Workman_Compensation_Id");
tobeConverted.add("Passport_Number");
tobeConverted.add("Expiry_Date");
tobeConverted.add("Enter_Passport_Number");
tobeConverted.add("Select_Expiry_Date");
tobeConverted.add("Passport_Number_Expiry_Date");
tobeConverted.add("Workman_Compensation_Expiry_Date");
//tobeConverted.add("Preferred_Company");
//tobeConverted.add("Custodian_Information");


ArrayList<String> convertedWords = new ArrayList<String>();
convertedWords = cf.getLanguageSpecificWordForKey(tobeConverted,language);
String EnterCustomerName=convertedWords.get(0);
String EnterGender=convertedWords.get(1);
String EnterMartialStatus=convertedWords.get(2);

String EnterEmploymentType=convertedWords.get(3);
String selectState=convertedWords.get(4);
String SelectCountry=convertedWords.get(5);

String SelectGroupName=convertedWords.get(6);
String PersonalInformation=convertedWords.get(7);
String FirstName=convertedWords.get(8);

String EnterFirstName=convertedWords.get(9);
String LastName=convertedWords.get(10);
String EnterLastName=convertedWords.get(11);

String Address=convertedWords.get(12);
String EnterAddress=convertedWords.get(13);
String PermanentAddress=convertedWords.get(14);

String EnterPermanentAddress=convertedWords.get(15);
String City=convertedWords.get(16);
String EnterCity=convertedWords.get(17);

String OtherCity=convertedWords.get(18);
String EnterOtherCity=convertedWords.get(19);
String State=convertedWords.get(20);

String Country=convertedWords.get(21);
String TelephoneNo=convertedWords.get(22);
String EnterTelephoneNo=convertedWords.get(23);

String MobileNo=convertedWords.get(24);
String EnterMobileNo=convertedWords.get(25);
String DateOfBirth=convertedWords.get(26);

String Gender=convertedWords.get(27);
String Nationality=convertedWords.get(28);
String EnterNationality=convertedWords.get(29);

String MartialStatus=convertedWords.get(30);
String PleaseSelectCustomer=convertedWords.get(31);
String Save=convertedWords.get(32);

String Cancel=convertedWords.get(33);
String EmploymentInformation=convertedWords.get(34);
String EmploymentType=convertedWords.get(35);

String EmploymentID=convertedWords.get(36);
String EnterEmploymentId=convertedWords.get(37);
String Client=convertedWords.get(38);

String EnterClient=convertedWords.get(39);
String DateOfJoining=convertedWords.get(40);
String EnterDateOfJoining=convertedWords.get(41);

String DateOfLeaving=convertedWords.get(42);
String BloodGroup=convertedWords.get(43);
String EnterBloodGroup=convertedWords.get(44);

String GroupName=convertedWords.get(45);
String ActiveStatus=convertedWords.get(46);
String EnterActiveStatus=convertedWords.get(47);

String Remarks=convertedWords.get(48);
String EnterRemarks=convertedWords.get(49);
String GovernmentorResidenceID=convertedWords.get(50);

String EnterGovernmentorResidenceId=convertedWords.get(51);
String Customer=convertedWords.get(52);
String RFIDCode=convertedWords.get(53);

String EnterRFIDCode=convertedWords.get(54);
String InsuranceInformation=convertedWords.get(55);
String MedicalInsuranceNo=convertedWords.get(56);

String EnterMedicalInsuranceNo=convertedWords.get(57);
String MedicalInsuranceCompany=convertedWords.get(58);
String EnterMedicalInsuranceCompany=convertedWords.get(59);

String MedicalInsuranceExpiryDate=convertedWords.get(60);
String DriverInformation=convertedWords.get(61);
String LicenseNo=convertedWords.get(62);

String EnterLicenseNo=convertedWords.get(63);
String LicensePlace=convertedWords.get(64);
String EnterLicensePlace=convertedWords.get(65);

String LicenseIssueDate=convertedWords.get(66);
String LicenseRenewedDate=convertedWords.get(67);
String LicenseExpiryDate=convertedWords.get(68);

String GunMenInformation=convertedWords.get(69);
String GunLicenseNo=convertedWords.get(70);
String EnterGunLicenseNo=convertedWords.get(71);

String GunLicenseType=convertedWords.get(72);
String EnterGunLicenseType=convertedWords.get(73);
String GunLicenseIssueDate=convertedWords.get(74);

String GunLicenseIssuePlace=convertedWords.get(75);
String EnterGunLicenseIssuePlace=convertedWords.get(76);
String GunLicenseExpiryDate=convertedWords.get(77);

String EmployeeName=convertedWords.get(78);
String EmployeeType=convertedWords.get(79);
String DriverDetails=convertedWords.get(80);

String CustomerName=convertedWords.get(81);
String CrewMasterInformation=convertedWords.get(82);
String CrewMasterDataReport=convertedWords.get(83);

String selectStatus=convertedWords.get(84);
String Edit=convertedWords.get(85);
String SelectDriver=convertedWords.get(86);

String SelectCustomerName=convertedWords.get(87);
String PersonalInformationDetails=convertedWords.get(88);
String GovernmentorResidenceIDExpiryDate=convertedWords.get(89);

String EmployeeInformationDetails=convertedWords.get(90);
String InsuranceInformationDetails=convertedWords.get(91);
String EnterExpiryDate=convertedWords.get(92);

String DriverInformationDetails=convertedWords.get(93);
String GunmenInformation=convertedWords.get(94);
String DriverId=convertedWords.get(95);

String CrewInformation=convertedWords.get(96);
String GunmenInformationDetails=convertedWords.get(97);
String Next=convertedWords.get(98);

String AddCrew=convertedWords.get(99);
String CrewEmployeeInformationDetails=convertedWords.get(100);
String CrewInsuranceInformation=convertedWords.get(101);

String CrewInsuranceInformationDetails=convertedWords.get(102);
String CrewDriverInformation=convertedWords.get(103);
String CrewGunmenInformationDetails=convertedWords.get(104);

String CrewDetails=convertedWords.get(105);
String CrewGunmenInformation=convertedWords.get(106);
String EnterEmployeeUniqueCode=convertedWords.get(107);

String EnterLicenseExpiryDate=convertedWords.get(108);
String EmployeeUniqueCode=convertedWords.get(109);
String EnterGunLicenseExpiryDate=convertedWords.get(110);

String EnterGunLicenseNumber=convertedWords.get(111);

String WorkmanCompensationId=convertedWords.get(112);
String EnterWorkmanCompensationId=convertedWords.get(113);
String PassportNumber=convertedWords.get(114);
String ExpiryDate=convertedWords.get(115);
String EnterPassportNumber=convertedWords.get(116);
String SelectExpiryDate=convertedWords.get(117);
String PassportNumberExpiryDate=convertedWords.get(118);
String WorkmanCompensationExpiryDate=convertedWords.get(119);
String preferedCompany = "Prefered Company";
String CustodianInformation = "Custodian Information";
 %>


<jsp:include page="../Common/header.jsp" />
<!-- <html class="largehtml">  -->

 		<title></title>		
	    
	 <style>
	 html {
	overflow-x: hidden;
	overflow-y: hidden;
}
  .x-panel-tl
	{
		border-bottom: 0px solid !important;
	}
	
  </style>

   <%if (loginInfo.getStyleSheetOverride().equals("Y")){%>                  
     <jsp:include page="../Common/ImportJSCashVan.jsp" />
     <jsp:include page="../Common/ImportJSSandMining.jsp"/>
     <link rel="stylesheet" href="../../Main/resources/css/common.css" type="text/css"/>   
		<style>
			label {
				display : inline !important;
			}
			.ext-strict .x-form-text {
				height : 21px !important;
			}
			.x-window-tl *.x-window-header {
				padding-top : 6px !important;
			}		
			.x-layer ul {
				min-height: 27px !important;
			}
			
		</style>
   <%}else {%>  
   <jsp:include page="../Common/ImportJS.jsp" /><%} %>
   <jsp:include page="../Common/ExportJS.jsp" />
   <script>
   var outerPanel;
   var AssetNumber;
   var dtprev = dateprev;
   var dtcur = datecur;
   var jspName = "CrewMasterDataReport";
   var exportDataType = "";
   var driverId = "";
   var titelForInnerPanel;
   var titelForEmployeePanel;
   var titelForInformationPanel;
   var titelForDriverPanel;
   var titelForGunPanel;
   var CrewtitelForEmployeePanel;
   var titelForCrewInformationPanel;
   var crewtitelForDriverPanel;
   var crewtitelForGunPanel;
   var StateId = "";
   var CountryId = "";
   var GroupId = "";
   var selected = "";
   var  customerNmaes;
   var  buttonValue;               
   var cusNames = "";
   
var customercheckstore = new Ext.data.JsonStore({
    url: '<%=request.getContextPath()%>/CMSDashBoardAction.do?param=getcustomer',
    id: 'customercheckStoreId',
    root: 'customerRoot',
    autoLoad: false,
    fields: ['customerName2'],
    listeners: {
        load: function() {
       
            if(buttonValue == '<%=AddCrew%>')
            {
            customerGrid2.getSelectionModel();
            }
            else
            {
           
            	var i = 0;
            	var k = 0;
            	if (buttonValue == '<%=Edit%>') {            	
                 cusNames=document.getElementById('preferedCompanyLabelId').innerText;   	               
                	cusLs = cusNames.split(",");
                	customercheckstore.each(function(rec) {
                    i = 0;
                    for (; i < cusLs.length; i++) {
                        if (rec.get('customerName2') == cusLs[i]) {
                            customerGrid.getSelectionModel().selectRow(k, true);
                        }
                    }
                    k++;
                	});
            }	}
        }
    }
});  


var customerSelect2 = new Ext.grid.CheckboxSelectionModel();
var customerGrid2 = new Ext.grid.GridPanel({
    id: 'customerGridId2',
    hidden:true,
    store: customercheckstore, 
    columns: [
        customerSelect2, {
            header: 'Select Customer',
            hidden: false,
            sortable: true,
            width: 123,
            dataIndex: 'customerName2'
        }
    ],
    sm: customerSelect2,
    stripeRows: true,
    border: true,
    frame: false,
    width: 165,
    height: 180,
    style: 'margin-left:5px;',
    cls: 'bskExtStyle'
});

var customerSelect = new Ext.grid.CheckboxSelectionModel();
var customerGrid = new Ext.grid.GridPanel({
    id: 'customerGridId',
    hidden:true,
    store: customercheckstore, 
    columns: [
        customerSelect, {
            header: 'Select Customer',
            hidden: false,
            sortable: true,
            width: 123,
            dataIndex: 'customerName2'
        }
    ],
    sm: customerSelect,
    stripeRows: true,
    border: true,
    frame: false,
    width: 165,
    height: 180,
    style: 'margin-left:5px;',
    cls: 'bskExtStyle'
});

   
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
                   custId = Ext.getCmp('custcomboId').getValue();
                   custName = Ext.getCmp('custcomboId').getRawValue();
                   Ext.getCmp('clientLabelId').setText(custName);                  
                   firstGridStoreForDriverName.load({
                       params: {
                           CustId: Ext.getCmp('custcomboId').getValue(),
                           CustName: custName
                       }
                   });
                      employmentTypeStore.load({
                params: {
                        CustId: Ext.getCmp('custcomboId').getValue()
                        }
                   });
                   
                   groupStore.load({
                       params: {
                           CustId: Ext.getCmp('custcomboId').getValue()
                       }
                   });
               }
           }
       }
   });
   var custnamecombo = new Ext.form.ComboBox({
       store: customercombostore,
       emptyText: '<%=EnterCustomerName%>',
       id: 'custcomboId',
       mode: 'local',
       forceSelection: true,
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
                   custName = Ext.getCmp('custcomboId').getRawValue();
                   Ext.getCmp('clientLabelId').setText(custName);
                   Ext.getCmp('clientId1').setValue(custName);
                   editOuterPanelWindowF0rGun.show();
                   editOuterPanelWindowF0rDriver.show();
                   driverId = 0;
                   // Ext.getCmp('firstPersonalInformationId').reset();
                   Ext.getCmp('labelnameId').setText('');
                   Ext.getCmp('labellastNameId').setText('');
                   Ext.getCmp('labeladdressId').setText('');
                   Ext.getCmp('labelpermanentAddressId').setText('');
                   Ext.getCmp('labelcityId').setText('');
                   Ext.getCmp('labelotherCityId').setText('');
                   Ext.getCmp('labelstatelabelId').setText('');
                   Ext.getCmp('labelcountrylabelId').setText('');
                   Ext.getCmp('labeltelephoneId').setText('');
                   Ext.getCmp('labelmobileId').setText('');
                   Ext.getCmp('labeldateOfBirthId').setText('');
                   Ext.getCmp('labelgenderLabelId').setText('');
                   Ext.getCmp('labelnationalityId').setText('');
                   Ext.getCmp('labelmaritialStatusLabelId').setText('');
                   Ext.getCmp('employnemntLabelTypeId').setText('');
                   Ext.getCmp('employmeeLabelId').setText('');
                   Ext.getCmp('dateOfJoiningLabelId').setText('');
                   Ext.getCmp('dateOfLeavingLabelId').setText('');
                   Ext.getCmp('bloodGroupLabelId').setText('');
                   Ext.getCmp('groupNameLabelId').setText('');
                   Ext.getCmp('activeStatusLabelId').setText('');
                   Ext.getCmp('remarksLabelId').setText('');
                   Ext.getCmp('governmentLabelId').setText('');
                   Ext.getCmp('governmentExpiryLabelId').setText('');
                   Ext.getCmp('rfidLabelId').setText('');
                   Ext.getCmp('medicalInsuranceLabelId').setText('');
                   Ext.getCmp('medicalInsuranceCompanyLabelId').setText('');
                   Ext.getCmp('MedicalInsuranceExpiryId').setText('');
                   Ext.getCmp('licenceNoLabelId').setText('');
                   Ext.getCmp('licencePlaceLabelId').setText('');
                   Ext.getCmp('licenceIssueDateLabelId').setText('');
                   Ext.getCmp('licenceRenewedDateLabelId').setText('');
                   Ext.getCmp('preferedCompanyLabelId').setText();
                   Ext.getCmp('licenceExpiryDateLabelId').setText('');
                   Ext.getCmp('gunGicenceNoLabelId').setText('');
                   Ext.getCmp('gunLicenceTypeLabelId').setText('');
                   Ext.getCmp('gunLicenceIssueDateLabelId').setText('');
                   Ext.getCmp('gunLicenceIssuePlaceLabelId').setText('');
                   Ext.getCmp('gunLicenceExpiryDateLabelId').setText('');
                   
                   Ext.getCmp('expiryDateIdForEditPanelLabel').setText('');
                   Ext.getCmp('PassportNumberIdForEditPanelLabel').setText('');
                   Ext.getCmp('WorkManCompensationLabelId').setText('');
                   Ext.getCmp('expiryDateIdForWorkManCompensationLabelId').setText('');
                   
                   firstGridStoreForDriverName.load({
                       params: {
                           CustId: Ext.getCmp('custcomboId').getValue(),
                           CustName: custName
                       }
                   });
                   groupStore.load({
                       params: {
                           CustId: Ext.getCmp('custcomboId').getValue()
                       }
                   });
                   
                       employmentTypeStore.load({
                params: {
                        CustId: Ext.getCmp('custcomboId').getValue()
                        }
                   });
                   if ( <%= customerId %> > 0) {
                       Ext.getCmp('custcomboId').setValue('<%=customerId%>');
                       custId = Ext.getCmp('custcomboId').getValue();
                       custName = Ext.getCmp('custcomboId').getRawValue();
                       Ext.getCmp('clientLabelId').setText(custName);
                       Ext.getCmp('clientId1').setValue(custName);
                       editOuterPanelWindowF0rGun.show();
                       editOuterPanelWindowF0rDriver.show();
                       firstGridStoreForDriverName.load({
                           params: {
                               CustId: Ext.getCmp('custcomboId').getValue(),
                               CustName: custName
                           }
                       });
                       groupStore.load({
                           params: {
                               CustId: Ext.getCmp('custcomboId').getValue()
                           }
                       });
                             
                       employmentTypeStore.load({
                params: {
                        CustId: Ext.getCmp('custcomboId').getValue()
                        }
                   });
                   }
               }
           }
       }
   });
   var genderStore = new Ext.data.SimpleStore({
       id: 'genderStoreId',
       autoLoad: true,
       fields: ['Name', 'Value'],
       data: [
           ['M', 'M'],
           ['F', 'F']
       ]
   });
   var genderCombo = new Ext.form.ComboBox({
       store: genderStore,
       id: 'genderComboId',
       mode: 'local',
       forceSelection: true,
       selectOnFocus: true,
       allowBlank: false,
       anyMatch: true,
       typeAhead: false,
       triggerAction: 'all',
       lazyRender: true,
       valueField: 'Value',
       emptyText: '<%=EnterGender%>',
       displayField: 'Name',
       cls: 'selectstylePerfect'
   });
   var maritialStore = new Ext.data.SimpleStore({
       id: 'maritialStoreId',
       autoLoad: true,
       fields: ['Name', 'Value'],
       data: [
           ['Single', 'Single'],
           ['Married', 'Married']
       ]
   });
   var genderComboforFirst = new Ext.form.ComboBox({
       store: genderStore,
       id: 'genderComboIdforfirst',
       mode: 'local',
       forceSelection: true,
       selectOnFocus: true,
       allowBlank: false,
       anyMatch: true,
       typeAhead: false,
       triggerAction: 'all',
       lazyRender: true,
       valueField: 'Value',
       emptyText: '<%=EnterGender%>',
       displayField: 'Name',
       cls: 'selectstylePerfect'
   });
   var maritialCombo = new Ext.form.ComboBox({
       store: maritialStore,
       id: 'maritialComboId',
       mode: 'local',
       forceSelection: true,
       selectOnFocus: true,
       allowBlank: false,
       anyMatch: true,
       typeAhead: false,
       triggerAction: 'all',
       lazyRender: true,
       valueField: 'Value',
       emptyText: '<%=EnterMartialStatus%>',
       displayField: 'Name',
       cls: 'selectstylePerfect'
   });
   var maritialComboforfirst = new Ext.form.ComboBox({
       store: maritialStore,
       id: 'maritialComboIdforfirst',
       mode: 'local',
       forceSelection: true,
       selectOnFocus: true,
       allowBlank: false,
       anyMatch: true,
       typeAhead: false,
       triggerAction: 'all',
       lazyRender: true,
       valueField: 'Value',
       emptyText: '<%=EnterMartialStatus%>',
       displayField: 'Name',
       cls: 'selectstylePerfect'
   });
   
   	var employmentTypeStore =new Ext.data.JsonStore({
        url: '<%=request.getContextPath()%>/CrewMasterDataAction.do?param=getemploymentType',
        id:'employmentTypeStoreId',
		root: 'employmentTypeRoot',
        autoLoad:false,
		remoteSort: true,
        fields:['empId','employmentType']
        });


   
   var employmentTypeCombo = new Ext.form.ComboBox({
       store: employmentTypeStore,
       id: 'employmentTypeComboId',
       mode: 'local',
       forceSelection: true,
       selectOnFocus: true,
       allowBlank: false,
       anyMatch: true,
       typeAhead: false,
       triggerAction: 'all',
       lazyRender: true,
       valueField: 'empId',
       emptyText: '<%=EnterEmploymentType%>',
       displayField: 'employmentType',
       cls: 'selectstylePerfect'
   });
   var employmentTypeComboForFirst = new Ext.form.ComboBox({
       store: employmentTypeStore,
       id: 'employmentTypeComboIdforfirst',
       mode: 'local',
       forceSelection: true,
       selectOnFocus: true,
       allowBlank: false,
       anyMatch: true,
       typeAhead: false,
       triggerAction: 'all',
       lazyRender: true,
       valueField: 'empId',
       emptyText: '<%=EnterEmploymentType%>',
       displayField: 'employmentType',
       cls: 'selectstylePerfect',
       listeners: {
           select: {
               fn: function () {}
           }
       }
   });
   var statestore = new Ext.data.JsonStore({
       url: '<%=request.getContextPath()%>/CrewMasterDataAction.do?param=getStateList',
       id: 'StateStoreId',
       root: 'StateRoot',
       autoLoad: false,
       fields: ['StateID', 'StateName']
   });
    //***** combo for customername*************/
   var statecombo = new Ext.form.ComboBox({
       store: statestore,
       id: 'statecomboId',
       mode: 'local',
       hidden: false,
       forceSelection: true,
       emptyText: '<%=selectState%>',
       blankText: '<%=selectState%>',
       lazyRender: true,
       selectOnFocus: true,
       allowBlank: false,
       autoload: true,
       anyMatch: true,
       typeAhead: false,
       triggerAction: 'all',
       valueField: 'StateID',
       displayField: 'StateName',
       cls: 'selectstylePerfect',
       listeners: {
           select: {
               fn: function () {}
           }
       }
   });
   var statecomboforFirstPanel = new Ext.form.ComboBox({
       store: statestore,
       id: 'statecomboforfirst',
       mode: 'local',
       hidden: false,
       forceSelection: true,
       emptyText: '<%=selectState%>',
       blankText: '<%=selectState%>',
       lazyRender: true,
       autoLoad: true,
       selectOnFocus: true,
       allowBlank: false,
       anyMatch: true,
       typeAhead: false,
       triggerAction: 'all',
       valueField: 'StateID',
       displayField: 'StateName',
       cls: 'selectstylePerfect',
       listeners: {
           select: {
               fn: function () {
                   StateId = Ext.getCmp('statecomboforfirst').getValue();
               }
           }
       }
   });
   /**************store for getting Countrty List******************/
   var countrystore = new Ext.data.JsonStore({
       url: '<%=request.getContextPath()%>/CrewMasterDataAction.do?param=getCountryList',
       id: 'CountryStoreId',
       root: 'CountryRoot',
       autoLoad: true,
       fields: ['CountryID', 'CountryName']
   });
    //***** combo for customername
   var countrycombo = new Ext.form.ComboBox({
       store: countrystore,
       id: 'countryId',
       mode: 'local',
       hidden: false,
       forceSelection: true,
       emptyText: '<%=SelectCountry%>',
       blankText: '<%=SelectCountry%>',
       selectOnFocus: true,
       allowBlank: false,
       anyMatch: true,
       typeAhead: false,
       triggerAction: 'all',
       valueField: 'CountryID',
       displayField: 'CountryName',
       cls: 'selectstylePerfect',
       listeners: {
           select: {
               fn: function () {
                   statestore.load({
                       params: {
                           countryId: Ext.getCmp('countryId').getValue()
                       }
                   });
               }
           }
       }
   });
   var countrycomboforfirstPanel = new Ext.form.ComboBox({
       store: countrystore,
       id: 'countryIdforfirst',
       mode: 'local',
       hidden: false,
       forceSelection: true,
       emptyText: '<%=SelectCountry%>',
       blankText: '<%=SelectCountry%>',
       selectOnFocus: true,
       allowBlank: false,
       anyMatch: true,
       typeAhead: false,
       triggerAction: 'all',
       valueField: 'CountryID',
       displayField: 'CountryName',
       cls: 'selectstylePerfect',
       listeners: {
           select: {
               fn: function () {
                   CountryId = Ext.getCmp('countryIdforfirst').getValue();
                   Ext.getCmp('statecomboforfirst').reset();
                   statestore.load({
                       params: {
                           countryId: Ext.getCmp('countryIdforfirst').getValue()
                       }
                   });
               }
           }
       }
   });
   var statuscombostore = new Ext.data.SimpleStore({
       id: 'statuscombostoreId',
       autoLoad: true,
       fields: ['Name', 'Value'],
       data: [
           ['Active', 'Active'],
           ['Inactive', 'Inactive']
       ]
   });
   var statuscombo = new Ext.form.ComboBox({
       store: statuscombostore,
       id: 'statuscomboId',
       mode: 'local',
       forceSelection: true,
       selectOnFocus: true,
       allowBlank: false,
       anyMatch: true,
       typeAhead: false,
       triggerAction: 'all',
       lazyRender: true,
       valueField: 'Value',
       value: 'Active',
       displayField: 'Name',
       cls: 'selectstylePerfect'
   });
   var statuscomboForFirst = new Ext.form.ComboBox({
       store: statuscombostore,
       id: 'statuscomboIdforfirst',
       mode: 'local',
       forceSelection: true,
       autoload: true,
       selectOnFocus: true,
       allowBlank: false,
       anyMatch: true,
       typeAhead: false,
       triggerAction: 'all',
       lazyRender: true,
       valueField: 'Value',
       value: 'Active',
       displayField: 'Name',
       cls: 'selectstylePerfect'
   });
   var groupStore = new Ext.data.JsonStore({
       url: '<%=request.getContextPath()%>/CrewMasterDataAction.do?param=getGroups',
       id: 'groupId',
       root: 'groupNameList',
       autoLoad: false,
       remoteSort: true,
       fields: ['groupId', 'groupName']
   });
   var groupNameCombo = new Ext.form.ComboBox({
       fieldLabel: '',
       //frame:true,
       store: groupStore,
       id: 'groupNameComboId',
       width: 150,
       emptyText: '<%=SelectGroupName%>',
       labelWidth: 100,
       hidden: false,
       forceSelection: true,
       enableKeyEvents: true,
       mode: 'local',
       triggerAction: 'all',
       displayField: 'groupName',
       valueField: 'groupId',
       loadingText: 'Searching...',
       cls: 'selectstylePerfect',
       emptyText: '',
       minChars: 3,
       listeners: {
           select: {
               fn: function () {
                   CustId = Ext.getCmp('custcomboId').getValue();
               }
           }
       }
   });
   var groupNameComboForFirst = new Ext.form.ComboBox({
       fieldLabel: '',
       //frame:true,
       store: groupStore,
       id: 'groupNameComboIdforfirst',
       width: 150,
       emptyText: '<%=SelectGroupName%>',
       labelWidth: 100,
       hidden: false,
       forceSelection: true,
       enableKeyEvents: true,
       mode: 'local',
       triggerAction: 'all',
       displayField: 'groupName',
       valueField: 'groupId',
       loadingText: 'Searching...',
       cls: 'selectstylePerfect',
       emptyText: '',
       minChars: 3,
       listeners: {
           select: {
               fn: function () {
                   CustId = Ext.getCmp('custcomboId').getValue();
                   GroupId = Ext.getCmp('groupNameComboIdforfirst').getValue();
               }
           }
       }
   });
   var firstHalfPersonalinformationPanel = new Ext.Panel({
       standardSubmit: true,
       // autoScroll:true,
       collapsible: false,
       id: 'firstHalfId',
       layout: 'table',
       frame: false,
       width: 475,
       height: 180,
       layoutConfig: {
           columns: 2
       },
       items: [{
           xtype: 'label',
           text: '<%=FirstName%>' + ' :',
           cls: 'labelstyle',
           id: 'custnamelab'
       }, {
           xtype: 'label',
           id: 'labelnameId',
           cls: 'labelForUserInterface'
       }, {
           xtype: 'label',
           text: '<%=Address%>' + ' :',
           cls: 'labelstyle',
           id: 'address'
       }, {
           xtype: 'label',
           id: 'labeladdressId',
           cls: 'labelForUserInterface'
       }, {
           xtype: 'label',
           text: '<%=City%>' + ' :',
           cls: 'labelstyle',
           id: 'city'
       }, {
           xtype: 'label',
           id: 'labelcityId',
           cls: 'labelForUserInterface'
       }, {
           xtype: 'label',
           text: '<%=State%>' + ' :',
           cls: 'labelstyle',
           id: 'state'
       }, {
           xtype: 'label',
           id: 'labelstatelabelId',
           cls: 'labelForUserInterface'
       }, {
           xtype: 'label',
           text: '<%=TelephoneNo%>  :',
           cls: 'labelstyle',
           id: 'telephoneNo'
       }, {
           xtype: 'label',
           id: 'labeltelephoneId',
           cls: 'labelForUserInterface'
       }, {
           xtype: 'label',
           text: '<%=DateOfBirth%>' + ' :',
           cls: 'labelstyle',
           id: 'dateOfBirth'
       }, {
           xtype: 'label',
           id: 'labeldateOfBirthId',
           cls: 'labelForUserInterface'
       }, {
           xtype: 'label',
           text: '<%=Nationality%>' + ' :',
           cls: 'labelstyle',
           id: 'nationality'
       }, {
           xtype: 'label',
           id: 'labelnationalityId',
           cls: 'labelForUserInterface'
       },{
           xtype: 'label',
           text: '<%=PassportNumber%>' + ' :',
           cls: 'labelstyle',
           id: 'PassportNumberIdForEditPanel'
       }, {
           xtype: 'label',
           id: 'PassportNumberIdForEditPanelLabel',
           cls: 'labelForUserInterface'
       }]
   });
   var secondHalfPersonalinformationPanel = new Ext.Panel({
       standardSubmit: true,
       // autoScroll:true,
       collapsible: false,
       id: 'secondHalfId',
       layout: 'table',
       frame: false,
       width: 575,
       height: 180,
       layoutConfig: {
           columns: 2
       },
       items: [{
           xtype: 'label',
           text: '<%=LastName%>' + ' :',
           cls: 'labelstyle',
           id: 'lastname'
       }, {
           xtype: 'label',
           id: 'labellastNameId',
           cls: 'labelForUserInterface'
           //width: 150
       }, {
           xtype: 'label',
           text: '<%=PermanentAddress%>' + ' :',
           cls: 'labelstyle',
           id: 'permanentAddress'
       }, {
           xtype: 'label',
           id: 'labelpermanentAddressId',
           cls: 'labelForUserInterface'
       }, {
           xtype: 'label',
           text: '<%=OtherCity%>' + ' :',
           cls: 'labelstyle',
           id: 'otherCity'
       }, {
           xtype: 'label',
           id: 'labelotherCityId',
           cls: 'labelForUserInterface'
       }, {
           xtype: 'label',
           text: '<%=Country%>' + ' :',
           cls: 'labelstyle',
           id: 'country'
       }, {
           xtype: 'label',
           id: 'labelcountrylabelId',
           cls: 'labelForUserInterface'
       }, {
           xtype: 'label',
           text: '<%=MobileNo%>  :',
           cls: 'labelstyle',
           id: 'mobileNo'
       }, {
           xtype: 'label',
           id: 'labelmobileId',
           cls: 'labelForUserInterface'
       }, {
           xtype: 'label',
           text: '<%=Gender%>' + ' :',
           cls: 'labelstyle',
           id: 'gender'
       }, {
           xtype: 'label',
           id: 'labelgenderLabelId',
           cls: 'labelForUserInterface'
       }, {
           xtype: 'label',
           text: '<%=MartialStatus%>' + ' :',
           cls: 'labelstyle',
           id: 'martialStatus'
       }, {
           xtype: 'label',
           id: 'labelmaritialStatusLabelId',
           cls: 'labelForUserInterface'
       },{
           xtype: 'label',
           text: '<%=PassportNumberExpiryDate%>' + ' :',
           cls: 'labelstyle',
           id: 'expiryDateIdForEditPanel'
       }, {
           xtype: 'label',
           id: 'expiryDateIdForEditPanelLabel',
           cls: 'labelForUserInterface'
       }]
   });
   var personalInformationPanel = new Ext.Panel({
       standardSubmit: true,
       // autoScroll:true,
       collapsible: false,
       title: '<%=PersonalInformation%>',
       id: 'firstPersonalInformationId',
       layout: 'table',
       frame: true,
       width: 1000,
       height: 200,
       items: [firstHalfPersonalinformationPanel, secondHalfPersonalinformationPanel]
   });
   var editPanel = new Ext.Panel({
       id: 'editpanelidForPersonalInformationDetails',
       standardSubmit: true,
       collapsible: false,
       autoHeight: true,
       height: 100,
       width: 1000,
       frame: true,
       layout: 'table',
       layoutConfig: {
           columns: 4
       },
       buttons: [{
           xtype: 'button',
           text: '<%=Edit%>',
           iconCls : 'editbutton',
           id: 'editIdPersonalInformationDetails',
           cls: 'buttonstyle',
           width: 70,
           listeners: {
               click: {
                   fn: function () {
                   buttonValue = '<%=Edit%>';
                       addRecord();
                   }
               }
           }
       }]
   });
   var editOuterPanelWindow = new Ext.Panel({
       width: 1000,
       height: 260,
       standardSubmit: true,
       frame: false,
       items: [personalInformationPanel, editPanel]
   });
   myWineditForPersonal = new Ext.Window({
       title: titelForInnerPanel,
       closable: false,
       resizable: false,
       modal: true,
       autoScroll: false,
       height: 330,
       width: 1000,
       id: 'myWinForEditPersonal',
       items: [editOuterPanelWindow]
   });
   var innerPanelForCrewMaster = new Ext.Panel({
       standardSubmit: true,
       collapsible: false,
       autoScroll: true,
       height:222,
       width:455,
       frame: true,
       id: 'custMaster',
       layout: 'table',
       layoutConfig: {
           columns: 4
       },
       items: [{
           xtype: 'fieldset',
           title: '<%=PersonalInformation%>',
           cls: 'fieldsetpanel',
           collapsible: false,
           colspan: 3,
           id: 'addpanelid',
           width: 410,
           height: 550,
           layout: 'table',
           layoutConfig: {
               columns: 3,
               tableAttrs: {
		            style: {
		                width: '100%'
		            }
        			}
           },
           items: [{
                   xtype: 'label',
                   text: '*',
                   cls: 'mandatoryfield',
                   id: 'mandatoryFirstNameId'
               }, {
                   xtype: 'label',
                   text: '<%=FirstName%>' + ' :',
                   cls: 'labelstyle',
                   id: 'firstId'
               }, {
                   xtype: 'textfield',
                   cls: 'selectstylePerfect',
                   regex: validate('alphanumericname'),
                   emptyText: '<%=EnterFirstName%>',
                   allowBlank: false,
                   blankText: '<%=EnterFirstName%>',
                   id: 'nameId1'
               }, {
                   xtype: 'label',
                   text: '',
                   cls: 'mandatoryfield',
                   id: 'mandatorylastNameId'
               },{
                   xtype: 'label',
                   text: '',
                   cls: 'mandatoryfield',
                   id: 'mandatorylastNameId'
               }, {
                   xtype: 'label',
                   text: '<%=LastName%>' + ' :',
                   cls: 'labelstyle',
                   id: 'lastnameId'
               },  {
                   xtype: 'textfield',
                   cls: 'selectstylePerfect',
                   regex: validate('alphanumericname'),
                   emptyText: '<%=EnterLastName%>',
                   allowBlank: false,
                   blankText: '<%=EnterLastName%>',
                   id: 'lastNameId1'
               },{
                   xtype: 'label',
                   text: '',
                   cls: 'mandatoryfield',
                   id: 'mandatoryAddressId'
               },  {
                   xtype: 'label',
                   text: '<%=Address%>' + ' :',
                   cls: 'labelstyle',
                   id: 'addressId12'
               },  {
                   xtype: 'textfield',
                   width: 50,
                   height: 60,
                   cls: 'selectstylePerfect',
                   emptyText: '<%=EnterAddress%>',
                   allowBlank: false,
                   //maxLength:5,
                   autoCreate: { //restricts user to enter only 52 chars max
                       tag: "input",
                       maxlength: 50,
                       type: "text",
                       size: "200",
                       autocomplete: "off"
                   },
                   blankText: '<%=EnterAddress%>',
                   id: 'addressId1'
               }, {
                   xtype: 'label',
                   text: '',
                   cls: 'mandatoryfield',
                   id: 'mandatoryPermanentAddressId'
               }, {
                   xtype: 'label',
                   text: '<%=PermanentAddress%>' + ' :',
                   cls: 'labelstyle',
                   id: 'permanentAddress12'
               },  {
                   xtype: 'textfield',
                   width: 50,
                   height: 60,
                   cls: 'selectstylePerfect',
                   emptyText: '<%=EnterPermanentAddress%>',
                   allowBlank: false,
                   autoCreate: { //restricts user to enter only 52 chars max
                       tag: "input",
                       maxlength: 50,
                       type: "text",
                       size: "200",
                       autocomplete: "off"
                   },
                   blankText: '<%=EnterPermanentAddress%>',
                   id: 'permanentAddressId1'
               }, {
                   xtype: 'label',
                   text: '',
                   cls: 'mandatoryfield',
                   id: 'mandatoryCityId'
               }, {
                   xtype: 'label',
                   text: '<%=City%>' + ' :',
                   cls: 'labelstyle',
                   id: 'city12'
               }, {
                   xtype: 'textfield',
                   cls: 'selectstylePerfect',
                   regex: validate('alphanumericname'),
                   emptyText: '<%=EnterCity%>',
                   allowBlank: false,
                   blankText: '<%=EnterCity%>',
                   id: 'cityId1'
               }, {
                   xtype: 'label',
                   text: '',
                   cls: 'mandatoryfield',
                   id: 'mandatoryOtherCityId'
               },{
                   xtype: 'label',
                   text: '',
                   cls: 'mandatoryfield',
                   id: 'mandatoryOtherCityId'
               },{
                   xtype: 'label',
                   text: 'Other City' + ' :',
                   cls: 'labelstyle',
                   id: 'otherCity12'
               },  {
                   xtype: 'textfield',
                   cls: 'selectstylePerfect',
                   regex: validate('alphanumericname'),
                   emptyText: '<%=EnterOtherCity%>',
                   allowBlank: false,
                   blankText: '<%=EnterOtherCity%>',
                   id: 'otherCityId1'
               }, {
                   xtype: 'label',
                   text: '',
                   cls: 'mandatoryfield',
                   id: 'mandatoryCountryId'
               }, {
                   xtype: 'label',
                   text: '<%=Country%>' + ' :',
                   cls: 'labelstyle',
                   id: 'country12'
               }, 
               countrycomboforfirstPanel,
               {
                   xtype: 'label',
                   text: '',
                   cls: 'mandatoryfield',
                   id: 'mandatoryStateId'
               },
                {
                   xtype: 'label',
                   text: '<%=State%>' + ' :',
                   cls: 'labelstyle',
                   id: 'state12'
               }, 
               statecomboforFirstPanel,{
                   xtype: 'label',
                   text: '',
                   cls: 'mandatoryfield',
                   id: 'mandatoryTelephoneId'
               },{
                   xtype: 'label',
                   text: '<%=TelephoneNo%>  :',
                   cls: 'labelstyle',
                   id: 'telephoneNo12'
               },  {
                   xtype: 'numberfield',
                   allowDecimals: false,
                   cls: 'selectstylePerfect',
                   maxLength: 20,
                   emptyText: '<%=EnterTelephoneNo%>',
                   blankText: '<%=EnterTelephoneNo%>',
                   id: 'telephoneId1'
               },  {
                   xtype: 'label',
                   text: '',
                   cls: 'mandatoryfield',
                   id: 'mandatoryMobileId'
               }, {
                   xtype: 'label',
                   text: '<%=MobileNo%>  :',
                   cls: 'labelstyle',
                   id: 'mobileNo12'
               }, {
                   xtype: 'numberfield',
                   allowDecimals: false,
                   cls: 'selectstylePerfect',
                   maxLength: 20,
                   emptyText: '<%=EnterMobileNo%>',
                   blankText: '<%=EnterMobileNo%>',
                   id: 'mobileId1'
               },{
                   xtype: 'label',
                   text: '',
                   cls: 'mandatoryfield',
                   id: 'mandatoryDateOfBirthId'
               }, {
                   xtype: 'label',
                   text: '<%=DateOfBirth%>' + ' :',
                   cls: 'labelstyle',
                   id: 'dateOfBirth12'
               },  {
                   xtype: 'datefield',
                   cls: 'selectstylePerfect',
                   allowBlank: false,
                   value: dtcur,
                   format: getDateFormat(),
                   allowBlank: false,
                   id: 'dateOfBirthId1'
               }, {
                   xtype: 'label',
                   text: '',
                   cls: 'mandatoryfield',
                   id: 'mandatoryGenderId'
               },{
                   xtype: 'label',
                   text: '<%=Gender%>' + ' :',
                   cls: 'labelstyle',
                   id: 'gender2'
               }, 
               genderComboforFirst,{
                   xtype: 'label',
                   text: '',
                   cls: 'mandatoryfield',
                   id: 'mandatoryNationalityId'
               },  {
                   xtype: 'label',
                   text: '<%=Nationality%>' + ' :',
                   cls: 'labelstyle',
                   id: 'nationality2'
               },  {
                   xtype: 'textfield',
                   cls: 'selectstylePerfect',
                   regex: validate('alphanumericname'),
                   emptyText: '<%=EnterNationality%>',
                   allowBlank: false,
                   blankText: '<%=EnterNationality%>',
                   id: 'nationalityId1'
               }, {
                   xtype: 'label',
                   text: '',
                   cls: 'mandatoryfield',
                   id: 'mandatoryMaritialId1'
               },{
                   xtype: 'label',
                   text: '<%=MartialStatus%>' + ' :',
                   cls: 'labelstyle',
                   id: 'martialStatus12'
               }, 
               maritialComboforfirst, {
                   xtype: 'label',
                   text: '',
                   cls: 'mandatoryfield',
                   id: 'mandatorypassportNumberIdForEditPanelInPersonalInformationId'
               }, {
                   xtype: 'label',
                   text: '<%=PassportNumber%>' + ' :',
                   cls: 'labelstyle',
                   id: 'passportNumberIdForEditPanelInPersonalInformation'
               }, {
                   xtype: 'textfield',
                   cls: 'selectstylePerfect',
                   emptyText: '<%=EnterPassportNumber%>',
                   allowBlank: false,
                   blankText: '<%=EnterPassportNumber%>',
                   id: 'passportNumberIdForEditPanelInPersonalInformationTextField'
               }, {
                   xtype: 'label',
                   text: '',
                   cls: 'mandatoryfield',
                   id: 'mandatoryExpiryDateForEditPanelInPersonalInformationId'
               }, {
                   xtype: 'label',
                   text: '<%=PassportNumberExpiryDate%>' + ' :',
                   cls: 'labelstyle',
                   id: 'ExpiryDateIdForEditPanelInPersonalInformation'
               }, {
                   xtype: 'datefield',
                   cls: 'selectstylePerfect',
                   allowBlank: false,
                   value: dtcur,
                   format: getDateFormat(),
                   allowBlank: false,
                   id: 'expiryDateForEditPanelInPersonalInformationTextField'
               }
           ]
       }]
   });
   var innerWinButtonPanel = new Ext.Panel({
       id: 'winbuttonid',
       standardSubmit: true,
       collapsible: false,
       autoHeight: true,
       height: 110,
       width: 460,
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
                   fn: function () {
                       if (driverId == "") {
                           Ext.example.msg("<%=SelectDriver%>");
                           return;
                       }
                       if (Ext.getCmp('custcomboId').getValue() == "") {
                           Ext.example.msg("<%=PleaseSelectCustomer%>");
                           return;
                       }
                       if (Ext.getCmp('nameId1').getValue() == "") {
                           Ext.example.msg("<%=EnterFirstName%>");
                           return;
                       }
                       crewMasterOuterPanelWindow.getEl().mask();
                       Ext.Ajax.request({
                           url: '<%=request.getContextPath()%>/CrewMasterDataAction.do?param=savePersonalInformation',
                           method: 'POST',
                           params: {
                               CustID: Ext.getCmp('custcomboId').getValue(),
                               custName: Ext.getCmp('custcomboId').getRawValue(),
                               firstName: Ext.getCmp('nameId1').getValue(),
                               lastName: Ext.getCmp('lastNameId1').getValue(),
                               address: Ext.getCmp('addressId1').getValue(),
                               permanentAddress: Ext.getCmp('permanentAddressId1').getValue(),
                               city: Ext.getCmp('cityId1').getValue(),
                               otherCity: Ext.getCmp('otherCityId1').getValue(),
                               state: StateId,
                               country: CountryId,
                               telephoneNo: Ext.getCmp('telephoneId1').getValue(),
                               mobileNo: Ext.getCmp('mobileId1').getValue(),
                               dateOfBirth: Ext.getCmp('dateOfBirthId1').getValue(),
                               gender: Ext.getCmp('genderComboIdforfirst').getValue(),
                               nationality: Ext.getCmp('nationalityId1').getValue(),
                               maritialStatus: Ext.getCmp('maritialComboIdforfirst').getValue(),
                               driverId: driverId,
                               passportNumber:Ext.getCmp('passportNumberIdForEditPanelInPersonalInformationTextField').getValue(),
                               expiryDate:Ext.getCmp('expiryDateForEditPanelInPersonalInformationTextField').getValue()
                           },
                           success: function (response, options) {
                               var message = response.responseText;
                               Ext.example.msg(message);
                               myWin.hide();
                               crewMasterOuterPanelWindow.getEl().unmask();
                               firstGridStoreForDriverName.load({
                                   params: {
                                       CustId: Ext.getCmp('custcomboId').getValue(),
                                       CustName: custName
                                   },
                                   callback: function () {
                                       if (firstGridStoreForDriverName.data.items.length != 0) {
                                           var row = firstGridStoreForDriverName.findExact('DriverIdDataIndex', driverId);
                                           var rec = firstGridStoreForDriverName.getAt(row);
                                           Ext.getCmp('labelnameId').setText(rec.get('driverNameDataIndex'));
                                           Ext.getCmp('labellastNameId').setText(rec.get('lastNameDataIndex'));
                                           Ext.getCmp('labeladdressId').setText(rec.get('presentAddressDataIndex'));
                                           Ext.getCmp('labelpermanentAddressId').setText(rec.get('permanentAddressDataIndex'));
                                           Ext.getCmp('labelcityId').setText(rec.get('cityDataIndex'));
                                           Ext.getCmp('labelotherCityId').setText(rec.get('otherCityDataIndex'));
                                           Ext.getCmp('labelstatelabelId').setText(rec.get('stateDataIndex'));
                                           Ext.getCmp('labelcountrylabelId').setText(rec.get('countryDataIndex'));
                                           Ext.getCmp('labeltelephoneId').setText(rec.get('telephoneDataIndex'));
                                           Ext.getCmp('labelmobileId').setText(rec.get('mobileDataIndex'));
                                           Ext.getCmp('labeldateOfBirthId').setText(rec.get('dateOfBirthDataIndex'));
                                           Ext.getCmp('labelgenderLabelId').setText(rec.get('genderDataIndex'));
                                           Ext.getCmp('labelnationalityId').setText(rec.get('nationalityDataIndex'));
                                           Ext.getCmp('labelmaritialStatusLabelId').setText(rec.get('maritialDataIndex'));
                                           Ext.getCmp('expiryDateIdForEditPanelLabel').setText(rec.get('expiryDateDataIndexforPersonalInformation'));
                                          Ext.getCmp('PassportNumberIdForEditPanelLabel').setText(rec.get('passportNumberDataIndex'));
                                       }
                                   }
                               });
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
   var crewMasterOuterPanelWindow = new Ext.Panel({
       width: 460,
       height: 330,
       standardSubmit: true,
       frame: true,
       items: [innerPanelForCrewMaster, innerWinButtonPanel]
   });
   myWin = new Ext.Window({
       title: titelForInnerPanel,
       closable: false,
       resizable: false,
       modal: true,
       autoScroll: false,
       height: 330,
       width: 470,
       id: 'myWinForrewMasterOuterPanel',
       items: [crewMasterOuterPanelWindow]
   });

   function addRecord() {
       if (Ext.getCmp('custcomboId').getValue() == "") {
           Ext.example.msg("<%=SelectCustomerName%>");
           return;
       }
       if (driverId == "") {
           Ext.example.msg("<%=SelectDriver%>");  
           return;
       }

       
       buttonValue = '<%=Edit%>';
       titelForInnerPanel = '<%=PersonalInformationDetails%>';
       myWin.setPosition(450, 150);
       myWin.show();
       myWin.setTitle(titelForInnerPanel);
       if (firstGridToGetDriverName.getSelectionModel().getCount() == 1) {
           var selected = firstGridToGetDriverName.getSelectionModel().getSelected();
           Ext.getCmp('nameId1').setValue(selected.get('driverNameDataIndex'));
           Ext.getCmp('lastNameId1').setValue(selected.get('lastNameDataIndex'));
           Ext.getCmp('addressId1').setValue(selected.get('presentAddressDataIndex'));
           Ext.getCmp('permanentAddressId1').setValue(selected.get('permanentAddressDataIndex'));
           Ext.getCmp('cityId1').setValue(selected.get('cityDataIndex'));
           Ext.getCmp('otherCityId1').setValue(selected.get('otherCityDataIndex'));
           Ext.getCmp('statecomboforfirst').setValue(selected.get('stateDataIndex'));
           Ext.getCmp('countryIdforfirst').setValue(selected.get('countryDataIndex'));
           Ext.getCmp('telephoneId1').setValue(selected.get('telephoneDataIndex'));
           Ext.getCmp('mobileId1').setValue(selected.get('mobileDataIndex'));
           Ext.getCmp('dateOfBirthId1').setValue(selected.get('dateOfBirthDataIndex'));
           Ext.getCmp('genderComboIdforfirst').setValue(selected.get('genderDataIndex'));
           Ext.getCmp('nationalityId1').setValue(selected.get('nationalityDataIndex'));
           Ext.getCmp('maritialComboIdforfirst').setValue(selected.get('maritialDataIndex'));
           Ext.getCmp('passportNumberIdForEditPanelInPersonalInformationTextField').setValue(selected.get('passportNumberDataIndex'));
           Ext.getCmp('expiryDateForEditPanelInPersonalInformationTextField').setValue(selected.get('expiryDateDataIndexforPersonalInformation'));
           Ext.getCmp('workmanCompensationIdForTextField').setValue(selected.get('workCompensationIdDataIndex'));
           Ext.getCmp('expiryDateworkmanCompensationIdForTextField').setValue(selected.get('workCompensationExpiryDateDataIndex'));
                            
           Ext.getCmp('employmentTypeComboIdforfirst').setValue(selected.get('employmentTypeDataIndex'));
           Ext.getCmp('employmeeId1').setValue(selected.get('employmentIdDataIndex'));
           Ext.getCmp('dateOfJoiningId1').setValue(selected.get('dateOfJoiningDataIndex'));
           Ext.getCmp('dateOfLeavingId1').setValue(selected.get('dateOfLeavingDataIndex'));
           Ext.getCmp('bloodGroupId1').setValue(selected.get('bloodGroupDataIndex'));
           Ext.getCmp('groupNameComboIdforfirst').setValue(selected.get('groupNameDataIndex'));
           Ext.getCmp('statuscomboIdforfirst').setValue(selected.get('activeStatusDataIndex'));
           Ext.getCmp('remarksId1').setValue(selected.get('remarksDataIndex'));
           Ext.getCmp('governmentId1').setValue(selected.get('governmentOrResidenceIdDataIndex'));
           Ext.getCmp('governmentexpiryId1').setValue(selected.get('governmentOrResidenceIdExpiryDateDataIndex'));
           Ext.getCmp('rfidId1').setValue(selected.get('rfidCodeDataIndex'));
           Ext.getCmp('medicalInsuranceId1').setValue(selected.get('medicalInsuranceDataIndex'));
           Ext.getCmp('medicalInsuranceCompanyId1').setValue(selected.get('medicalInsuranceCompanyDataIndex'));
           Ext.getCmp('MedicalInsuranceExpiryDateId1').setValue(selected.get('medicalInsuranceExpiryDateDataIndex'));
           Ext.getCmp('licenceId1').setValue(selected.get('licenseNoDataIndex'));
           Ext.getCmp('licencePlaceId1').setValue(selected.get('licencePlaceDataIndex'));
           Ext.getCmp('licenceIssueDateId1').setValue(selected.get('licenceIssueDateDataIndex'));
           Ext.getCmp('licenceRenewedDateId1').setValue(selected.get('licenceRewenedDateDataIndex'));
           Ext.getCmp('preferedCompanyLabelId').setText(selected.get('preferedCompanyLabelDataIndex'));                    
           Ext.getCmp('licenceExpiryDateId1').setValue(selected.get('licenceExpiryDateDataIndex'));
           Ext.getCmp('gunLicenceId1').setValue(selected.get('gunLicenceNoDataIndex'));
           Ext.getCmp('gunLicenceTypeId1').setValue(selected.get('gunLicenceTypeDataIndex'));
           Ext.getCmp('gunLicenceIssueDateId1').setValue(selected.get('gunLicenceIssueDateDataIndex'));
           Ext.getCmp('gunLicenceIssuePlaceId1').setValue(selected.get('gunLicenceIssuePlaceDataIndex'));
           Ext.getCmp('gunLicenceExpiryDateId1').setValue(selected.get('gunLicenceExpiryDateDataIndex'));
       }
   }
    //********************************************END OF PERSONAL INFORMATION*******************************************************************************//
   var firstHalfForEmploymentInformationPanel = new Ext.Panel({
       standardSubmit: true,
       collapsible: false,
       id: 'firstHalfIdforEmployee',
       layout: 'table',
       frame: false,
       width: 475,
       height: 150,
       layoutConfig: {
           columns: 2
       },
       items: [{
           xtype: 'label',
           text: '<%=EmploymentType%>' + ' :',
           cls: 'labelstyle',
           id: 'employment'
       }, {
           xtype: 'label',
           id: 'employnemntLabelTypeId',
           cls: 'labelForUserInterface'
       }, {
           xtype: 'label',
           text: '<%=EmploymentID%>' + ' :',
           cls: 'labelstyle',
           id: 'employee'
       }, {
           xtype: 'label',
           id: 'employmeeLabelId',
           cls: 'labelForUserInterface'
       }, {
           xtype: 'label',
           text: '<%=DateOfJoining%>' + ' :',
           cls: 'labelstyle',
           id: 'dateOfJoining'
       }, {
           xtype: 'label',
           id: 'dateOfJoiningLabelId',
           cls: 'labelForUserInterface'
       }, {
           xtype: 'label',
           text: '<%=BloodGroup%>' + ' :',
           cls: 'labelstyle',
           id: 'bloodGroup'
       }, {
           xtype: 'label',
           id: 'bloodGroupLabelId',
           cls: 'labelForUserInterface'
       }, {
           xtype: 'label',
           text: '<%=ActiveStatus%>' + ' :',
           cls: 'labelstyle',
           id: 'activeStatus'
       }, {
           xtype: 'label',
           id: 'activeStatusLabelId',
           cls: 'labelForUserInterface'
       }, {
           xtype: 'label',
           text: '<%=GovernmentorResidenceID%>' + ' :',
           cls: 'labelstyle',
           id: 'government'
       }, {
           xtype: 'label',
           id: 'governmentLabelId',
           cls: 'labelForUserInterface'
       }, {
           xtype: 'label',
           text: '<%=EmployeeUniqueCode%>' + ' :',
           cls: 'labelstyle',
           id: 'rfid'
       }, {
           xtype: 'label',
           id: 'rfidLabelId',
           cls: 'labelForUserInterface'
       }]
   });
   var secondHalfForEmploymentInformationPanel = new Ext.Panel({
       standardSubmit: true,
       collapsible: false,
       id: 'secondHalfIdForEmployee',
       layout: 'table',
       frame: false,
       width: 575,
       height: 150,
       layoutConfig: {
           columns: 2
       },
       items: [{
           xtype: 'label',
           text: '<%=Client%>' + ' :',
           cls: 'labelstyle',
           id: 'client'
       }, {
           xtype: 'label',
           id: 'clientLabelId',
           cls: 'labelForUserInterface'
       }, {
           xtype: 'label',
           text: '<%=DateOfLeaving%>' + ' :',
           cls: 'labelstyle',
           id: 'dateOfLeaving'
       }, {
           xtype: 'label',
           id: 'dateOfLeavingLabelId',
           cls: 'labelForUserInterface'
       }, {
           xtype: 'label',
           text: '<%=GroupName%>' + ' :',
           cls: 'labelstyle',
           id: 'GroupName'
       }, {
           xtype: 'label',
           id: 'groupNameLabelId',
           cls: 'labelForUserInterface'
       }, {
           xtype: 'label',
           text: '<%=Remarks%>' + ' :',
           cls: 'labelstyle',
           id: 'remarks'
       }, {
           xtype: 'label',
           id: 'remarksLabelId',
           cls: 'labelForUserInterface'
       }, {
           xtype: 'label',
           text: '<%=GovernmentorResidenceIDExpiryDate%>' + ' :',
           cls: 'labelstyle',
           id: 'governmentexpiry'
       }, {
           xtype: 'label',
           id: 'governmentExpiryLabelId',
           cls: 'labelForUserInterface'
       },{
           xtype: 'label',
           text: '<%=WorkmanCompensationId%>' + ' :',
           cls: 'labelstyle',
           id: 'WorkManCompensationId'
       }, {
           xtype: 'label',
           id: 'WorkManCompensationLabelId',
           cls: 'labelForUserInterface'
       },{
           xtype: 'label',
           text: '<%=WorkmanCompensationExpiryDate%>' + ' :',
           cls: 'labelstyle',
           id: 'expiryDateIdForWorkManCompensation'
       }, {
           xtype: 'label',
           id: 'expiryDateIdForWorkManCompensationLabelId',
           cls: 'labelForUserInterface'
       }]
   });
   var employmentInformationPanel = new Ext.Panel({
       standardSubmit: true,
       collapsible: false,
       title: '<%=EmploymentInformation%>',
       id: 'Master',
       layout: 'table',
       frame: true,
       width: 1000,
       height: 200,
       items: [firstHalfForEmploymentInformationPanel, secondHalfForEmploymentInformationPanel]
   });
   var editPanelForEmployee = new Ext.Panel({
       id: 'editpanelidFoeEmployee',
       standardSubmit: true,
       collapsible: false,
       autoHeight: true,
       height: 200,
       width: 1000,
       frame: true,
       layout: 'table',
       layoutConfig: {
           columns: 4
       },
       buttons: [{
           xtype: 'button',
           text: '<%=Edit%>',
           iconCls : 'editbutton',
           id: 'saveEmployeeId',
           cls: 'buttonstyle',
           width: 70,
           listeners: {
               click: {
                   fn: function () {
                   buttonValue = '<%=Edit%>';
                       employeeInformation();
                   }
               }
           }
       }]
   });
   var editOuterPanelWindowF0rEmployee = new Ext.Panel({
       width: 1000,
       height: 280,
       standardSubmit: true,
       frame: false,
       items: [employmentInformationPanel, editPanelForEmployee]
   });
   myWineditForEmployee = new Ext.Window({
       closable: false,
       resizable: false,
       modal: true,
       autoScroll: false,
       height: 330,
       width: 1000,
       id: 'myWinforEditEmployee',
       items: [editOuterPanelWindowF0rEmployee]
   });
   var innerPanelForEmploymentInformation = new Ext.Panel({
       standardSubmit: true,
       collapsible: false,
       autoScroll: true,
       height: 222,
       width: 560,
       frame: true,
       id: 'employmentInfoId',
       layout: 'table',
       layoutConfig: {
           columns: 4
       },
       items: [{
           xtype: 'fieldset',
           title: '<%=EmploymentInformation%>',
           cls: 'fieldsetpanel',
           collapsible: false,
           colspan: 3,
           id: 'employmentpanelid',
           width: 530,
           height: 480,
           layout: 'table',
           layoutConfig: {
               columns: 3,
               tableAttrs: {
		            style: {
		                width: '88%'
		            }
        			}
           },
           items: [{
                   xtype: 'label',
                   text: '*',
                   cls: 'mandatoryfield',
                   id: 'mandatoryemploymentId'
               },{
                   xtype: 'label',
                   text: '<%=EmploymentType%>' + ' :',
                   cls: 'labelstyle',
                   id: 'employment1'
               }, 
               employmentTypeComboForFirst, 
                {
                   xtype: 'label',
                   text: '*',
                   cls: 'mandatoryfield',
                   id: 'mandatoryEmployeeIdId'
               },  {
                   xtype: 'label',
                   text: '<%=EmploymentID%>' + ' :',
                   cls: 'labelstyle',
                   id: 'employee1'
               },{
                   xtype: 'textfield',
                   cls: 'selectstylePerfect',
                   regex: validate('alphanumericname'),
                   emptyText: '<%=EnterEmploymentId%>',
                   allowBlank: false,
                   blankText: '<%=EnterEmploymentId%>',
                   id: 'employmeeId1'
               },{
                   xtype: 'label',
                   text: '',
                   cls: 'mandatoryfield',
                   id: 'mandatoryClientId'
               }, {
                   xtype: 'label',
                   text: '<%=Client%>' + ' :',
                   cls: 'labelstyle',
                   id: 'client1'
               },  {
                   xtype: 'textfield',
                   cls: 'selectstylePerfect',
                   regex: validate('alphanumericname'),
                   emptyText: '<%=EnterClient%>',
                   allowBlank: false,
                   blankText: '<%=EnterClient%>',
                   id: 'clientId1'
               },{
                   xtype: 'label',
                   text: '',
                   cls: 'mandatoryfield',
                   id: 'mandatoryJoiningId'
               }, {
                   xtype: 'label',
                   text: '<%=DateOfJoining%>' + ' :',
                   cls: 'labelstyle',
                   id: 'dateOfJoining1'
               },  {
                   xtype: 'datefield',
                   cls: 'selectstylePerfect',
                   emptyText: '<%=EnterDateOfJoining%>',
                   allowBlank: false,
                   value: dtcur,
                   format: getDateFormat(),
                   blankText: '<%=EnterDateOfJoining%>',
                   id: 'dateOfJoiningId1'
               },{
                   xtype: 'label',
                   text: '',
                   cls: 'mandatoryfield',
                   id: 'mandatoryLeavingId'
               }, {
                   xtype: 'label',
                   text: '<%=DateOfLeaving%>' + ' :',
                   cls: 'labelstyle',
                   id: 'dateOfLeaving1'
               }, {
                   xtype: 'datefield',
                   cls: 'selectstylePerfect',
                   allowBlank: false,
                   value: dtcur,
                   format: getDateFormat(),
                   allowBlank: false,
                   id: 'dateOfLeavingId1'
               },  {
                   xtype: 'label',
                   text: '',
                   cls: 'mandatoryfield',
                   id: 'mandatoryBloodId'
               }, {
                   xtype: 'label',
                   text: '<%=BloodGroup%>' + ' :',
                   cls: 'labelstyle',
                   id: 'bloodGroup1'
               },{
                   xtype: 'textfield',
                   cls: 'selectstylePerfect',
                   emptyText: '<%=EnterBloodGroup%>',
                   allowBlank: false,
                   blankText: '<%=EnterBloodGroup%>',
                   id: 'bloodGroupId1'
               },  {
                   xtype: 'label',
                   text: '',
                   cls: 'mandatoryfield',
                   id: 'mandatoryGroupId'
               },{
                   xtype: 'label',
                   text: '<%=GroupName%>' + ' :',
                   cls: 'labelstyle',
                   id: 'GroupName1'
               },
               groupNameComboForFirst,
               {
                   xtype: 'label',
                   text: '',
                   cls: 'mandatoryfield',
                   id: 'mandatoryActiveStatusId'
               }, {
                   xtype: 'label',
                   text: '<%=ActiveStatus%>' + ' :',
                   cls: 'labelstyle',
                   id: 'activeStatus1'
               }, 
               statuscomboForFirst,{
                   xtype: 'label',
                   text: '',
                   cls: 'mandatoryfield',
                   id: 'mandatoryRemarksId'
               },  {
                   xtype: 'label',
                   text: '<%=Remarks%>' + ' :',
                   cls: 'labelstyle',
                   id: 'remarks1'
               }, {
                   xtype: 'textarea',
                   width: 50,
                   height: 60,
                   cls: 'selectstylePerfect',
                   emptyText: '<%=EnterRemarks%>',
                   allowBlank: false,
                   autoCreate: { //restricts user to enter only 52 chars max
                       tag: "input",
                       maxlength: 45,
                       type: "text",
                       size: "200",
                       autocomplete: "off"
                   },
                   blankText: '<%=EnterRemarks%>',
                   id: 'remarksId1'
               },  {
                   xtype: 'label',
                   text: '',
                   cls: 'mandatoryfield',
                   id: 'mandatoryGovernmentId'
               },{
                   xtype: 'label',
                   text: '<%=GovernmentorResidenceID%>' + ' :',
                   cls: 'labelstyle',
                   id: 'government1'
               }, {
                   xtype: 'textfield',
                   cls: 'selectstylePerfect',
                   regex: validate('alphanumericname'),
                   emptyText: '<%=EnterGovernmentorResidenceId%>',
                   allowBlank: false,
                   blankText: '<%=EnterGovernmentorResidenceId%>',
                   id: 'governmentId1'
               },{
                   xtype: 'label',
                   text: '',
                   cls: 'mandatoryfield',
                   id: 'mandatorygovernmentexpiryId'
               }, {
                   xtype: 'label',
                   text: '<%=GovernmentorResidenceIDExpiryDate%>' + ' :',
                   cls: 'labelstyle',
                   id: 'governmentexpiry1'
               }, {
                   xtype: 'datefield',
                   cls: 'selectstylePerfect',
                   allowBlank: false,
                   value: dtcur,
                   format: getDateFormat(),
                   allowBlank: false,
                   id: 'governmentexpiryId1'
               },   {
                   xtype: 'label',
                   text: '',
                   cls: 'mandatoryfield',
                   id: 'mandatoryrfidId'
               },{
                   xtype: 'label',
                   text: '<%=EmployeeUniqueCode%>' + ' :',
                   cls: 'labelstyle',
                   id: 'rfid1'
               }, {
                   xtype: 'textfield',
                   cls: 'selectstylePerfect',
                   regex: validate('alphanumericname'),
                   emptyText: '<%=EnterEmployeeUniqueCode%>',
                   allowBlank: false,
                   blankText: '<%=EnterEmployeeUniqueCode%>',
                   id: 'rfidId1'
               },{
                   xtype: 'label',
                   text: '',
                   cls: 'mandatoryfield',
                   id: 'mandatoryWorkmanCompensationIdForEditPanel'
               }, 
               
               {
                   xtype: 'label',
                   text: '<%=WorkmanCompensationId%>' + ' :',
                   cls: 'labelstyle',
                   id: 'workmanCompensationIdForEditPanel'
               }, {
                   xtype: 'textfield',
                   cls: 'selectstylePerfect',
                   emptyText: '<%=EnterWorkmanCompensationId%>',
                   allowBlank: false,
                   blankText: '<%=EnterWorkmanCompensationId%>',
                   id: 'workmanCompensationIdForTextField'
               }, 
               {
                   xtype: 'label',
                   text: '',
                   cls: 'mandatoryfield',
                   id: 'mandatoryexpiryDateForworkmanCompensationIdForEditPanel'
               }, 
               {
                   xtype: 'label',
                   text: '<%=WorkmanCompensationExpiryDate%>' + ' :',
                   cls: 'labelstyle',
                   id: 'expiryDateForworkmanCompensationIdForEditPanel'
               }, {
                   xtype: 'datefield',
                   cls: 'selectstylePerfect',
                   allowBlank: false,
                   value: dtcur,
                   format: getDateFormat(),
                   allowBlank: false,
                   id: 'expiryDateworkmanCompensationIdForTextField'
               }
           ]
       }]
   });
   var innerWinButtonPanelForEmployment = new Ext.Panel({
       id: 'employeewinbuttonid',
       standardSubmit: true,
       collapsible: false,
       autoHeight: true,
       height: 110,
       width: 535,
       frame: true,
       layout: 'table',
       layoutConfig: {
           columns: 4
       },
       buttons: [{
           xtype: 'button',
           text: '<%=Save%>',
           iconCls:'savebutton',
           id: 'employeeaddButtId',
           cls: 'buttonstyle',
           width: 70,
           listeners: {
               click: {
                   fn: function () {
                       if (driverId == "") {
                           Ext.example.msg("<%=SelectDriver%>");
                           return;
                       }
                       if (Ext.getCmp('employmentTypeComboIdforfirst').getValue() == "") {
                           Ext.example.msg("<%=EnterEmploymentType%>");
                           return;
                       }
                       if (Ext.getCmp('employmeeId1').getValue() == "") {
                           Ext.example.msg("<%=EnterEmploymentId%>");
                           return;
                       }
                       var value= employmentTypeStore.find('employmentType',Ext.getCmp('employmentTypeComboIdforfirst').getRawValue());
                       var empIdNew = employmentTypeStore.getAt(value);
                       var EmpIdNew=empIdNew.data['empId'];
                       employmentInformationOuterPanelWindow.getEl().mask();
                       
                      var selected = firstGridToGetDriverName.getSelectionModel().getSelected();
                       Ext.Ajax.request({
                           url: '<%=request.getContextPath()%>/CrewMasterDataAction.do?param=saveEmploymentInformation',
                           method: 'POST',
                           params: {
                               CustID: Ext.getCmp('custcomboId').getValue(),
                               custName: Ext.getCmp('custcomboId').getRawValue(),
                               employementType: EmpIdNew,
                               employmentId: Ext.getCmp('employmeeId1').getValue(),
                               client: Ext.getCmp('clientId1').getValue(),
                               dateOfJoining: Ext.getCmp('dateOfJoiningId1').getValue(),
                               dateOfLeaving: Ext.getCmp('dateOfLeavingId1').getValue(),
                               bloodGroup: Ext.getCmp('bloodGroupId1').getValue(),
                               groupName: GroupId,
                               activeStatus: Ext.getCmp('statuscomboIdforfirst').getValue(),
                               remarks: Ext.getCmp('remarksId1').getValue(),
                               governmentResidenceId: Ext.getCmp('governmentId1').getValue(),
                               governmentResidenceExpiryDate: Ext.getCmp('governmentexpiryId1').getValue(),
                               rfidCode: Ext.getCmp('rfidId1').getValue(),
                               driverId: driverId,
                               workCompensationId:Ext.getCmp('workmanCompensationIdForTextField').getValue(),
                               workCompensationExpiryDate:Ext.getCmp('expiryDateworkmanCompensationIdForTextField').getValue()
                           },
                           success: function (response, options) {
                               var message = response.responseText;
                               Ext.example.msg(message);
<!--                               if (Ext.getCmp('employmentTypeComboIdforfirst').getValue() == 1 || Ext.getCmp('employmentTypeComboIdforfirst').getValue()=='DRIVER' ) {-->
<!--                                    editOuterPanelWindowF0rGun.hide();-->
<!--                                   editOuterPanelWindowF0rDriver.show();-->
<!--                                   -->
<!--                               }-->
                               if (Ext.getCmp('employmentTypeComboIdforfirst').getValue() == 2 || Ext.getCmp('employmentTypeComboIdforfirst').getValue()=='GUNMAN' ) {
                                    editOuterPanelWindowF0rDriver.hide();
                                   editOuterPanelWindowF0rGun.show();
                               } 
                               else { editOuterPanelWindowF0rGun.hide();
                                   editOuterPanelWindowF0rDriver.show();
                               }
<!--                               if (Ext.getCmp('employmentTypeComboIdforfirst').getValue() == 3 || Ext.getCmp('employmentTypeComboIdforfirst').getValue()=='CLEANER' ) {-->
<!--                                    editOuterPanelWindowF0rGun.hide();-->
<!--                                   editOuterPanelWindowF0rDriver.show();-->
<!--                               }-->
<!--                               if (Ext.getCmp('employmentTypeComboIdforfirst').getValue() == 4 || Ext.getCmp('employmentTypeComboIdforfirst').getValue()=='OPERATOR' ) {-->
<!--                                    editOuterPanelWindowF0rGun.hide();-->
<!--                                   editOuterPanelWindowF0rDriver.show();-->
<!--                               }-->
<!--                               if (Ext.getCmp('employmentTypeComboIdforfirst').getValue() == 5 || Ext.getCmp('employmentTypeComboIdforfirst').getValue()=='ESCORTS' ) {-->
<!--                                    editOuterPanelWindowF0rGun.hide();-->
<!--                                   editOuterPanelWindowF0rDriver.show();-->
<!--                               }-->
<!--                                if (Ext.getCmp('employmentTypeComboIdforfirst').getValue() == 6 || Ext.getCmp('employmentTypeComboIdforfirst').getValue()=='SITE ENGINEERS' ) {-->
<!--                                    editOuterPanelWindowF0rGun.hide();-->
<!--                                   editOuterPanelWindowF0rDriver.show();-->
<!--                               }-->
<!--                                if (Ext.getCmp('employmentTypeComboIdforfirst').getValue() == 7 || Ext.getCmp('employmentTypeComboIdforfirst').getValue()=='MANAGERS' ) {-->
<!--                                    editOuterPanelWindowF0rGun.hide();-->
<!--                                   editOuterPanelWindowF0rDriver.show();-->
<!--                               }-->
                               firstGridStoreForDriverName.load({
                                   params: {
                                       CustId: Ext.getCmp('custcomboId').getValue(),
                                       CustName: custName
                                   },
                                   callback: function () {
                                       if (firstGridStoreForDriverName.data.items.length != 0) {
                                           var row = firstGridStoreForDriverName.findExact('DriverIdDataIndex', driverId);
                                           var rec = firstGridStoreForDriverName.getAt(row);
                                           Ext.getCmp('employnemntLabelTypeId').setText(rec.get('employmentTypeDataIndex'));
                                           Ext.getCmp('employmeeLabelId').setText(rec.get('employmentIdDataIndex'));
                                           Ext.getCmp('dateOfJoiningLabelId').setText(rec.get('dateOfJoiningDataIndex'));
                                           Ext.getCmp('dateOfLeavingLabelId').setText(rec.get('dateOfLeavingDataIndex'));
                                           Ext.getCmp('bloodGroupLabelId').setText(rec.get('bloodGroupDataIndex'));
                                           Ext.getCmp('groupNameLabelId').setText(rec.get('groupNameDataIndex'));
                                           Ext.getCmp('activeStatusLabelId').setText(rec.get('activeStatusDataIndex'));
                                           Ext.getCmp('remarksLabelId').setText(rec.get('remarksDataIndex'));
                                           Ext.getCmp('governmentLabelId').setText(rec.get('governmentOrResidenceIdDataIndex'));
                                           Ext.getCmp('governmentExpiryLabelId').setText(rec.get('governmentOrResidenceIdExpiryDateDataIndex'));
                                           Ext.getCmp('rfidLabelId').setText(rec.get('rfidCodeDataIndex'));
                                           Ext.getCmp('WorkManCompensationLabelId').setText(rec.get('workCompensationIdDataIndex'));
                                           Ext.getCmp('expiryDateIdForWorkManCompensationLabelId').setText(rec.get('workCompensationExpiryDateDataIndex'));
                                       }
                                   }
                               });
                               myWinForEmployee.hide();
                               employmentInformationOuterPanelWindow.getEl().unmask();
                           },
                           failure: function () {
                               Ext.example.msg("Error");
                               myWinForEmployee.hide();
                           }
                       });
                   }
               }
           }
       }, {
           xtype: 'button',
           text: '<%=Cancel%>',
           id: 'employeecanButtId',
           cls: 'buttonstyle',
           iconCls: 'cancelbutton',
           width: 70,
           listeners: {
               click: {
                   fn: function () {
                       myWinForEmployee.hide();
                   }
               }
           }
       }]
   });
   var employmentInformationOuterPanelWindow = new Ext.Panel({
       width: 570,
       height: 330,
       standardSubmit: true,
       frame: true,
       items: [innerPanelForEmploymentInformation, innerWinButtonPanelForEmployment]
   });
   myWinForEmployee = new Ext.Window({
       title: titelForEmployeePanel,
       closable: false,
       resizable: false,
       modal: true,
       autoScroll: false,
       height: 330,
       width: 580,
       id: 'myWinEmployee',
       items: [employmentInformationOuterPanelWindow]
   });

   function employeeInformation() {
       if (Ext.getCmp('custcomboId').getValue() == "") {
           Ext.example.msg("<%=SelectCustomerName%>");
           return;
       }
       if (driverId == "") {
           Ext.example.msg("<%=SelectDriver%>");
           return;
       }
       buttonValue = 'Edit';
       titelForEmployeePanel = '<%=EmployeeInformationDetails%>';
       //Ext.getCmp('employmentTypeComboIdforfirst').disable();
       Ext.getCmp('clientId1').disable();
       Ext.getCmp('clientId1').setValue(custName);
       Ext.getCmp('employmeeId1').disable();
       myWinForEmployee.setPosition(450, 150);
       myWinForEmployee.show();
       
       myWinForEmployee.setTitle(titelForEmployeePanel);
       if (firstGridToGetDriverName.getSelectionModel().getCount() == 1) {
           var selected = firstGridToGetDriverName.getSelectionModel().getSelected();
           // driverId = selected.get('DriverIdDataIndex');
           Ext.getCmp('nameId1').setValue(selected.get('driverNameDataIndex'));
           Ext.getCmp('lastNameId1').setValue(selected.get('lastNameDataIndex'));
           Ext.getCmp('addressId1').setValue(selected.get('presentAddressDataIndex'));
           Ext.getCmp('permanentAddressId1').setValue(selected.get('permanentAddressDataIndex'));
           Ext.getCmp('cityId1').setValue(selected.get('cityDataIndex'));
           Ext.getCmp('otherCityId1').setValue(selected.get('otherCityDataIndex'));
           Ext.getCmp('statecomboforfirst').setValue(selected.get('stateDataIndex'));
           Ext.getCmp('countryIdforfirst').setValue(selected.get('countryDataIndex'));
           Ext.getCmp('telephoneId1').setValue(selected.get('telephoneDataIndex'));
           Ext.getCmp('mobileId1').setValue(selected.get('mobileDataIndex'));
           Ext.getCmp('dateOfBirthId1').setValue(selected.get('dateOfBirthDataIndex'));
           Ext.getCmp('genderComboIdforfirst').setValue(selected.get('genderDataIndex'));
           Ext.getCmp('nationalityId1').setValue(selected.get('nationalityDataIndex'));
           Ext.getCmp('maritialComboIdforfirst').setValue(selected.get('maritialDataIndex'));
          Ext.getCmp('passportNumberIdForEditPanelInPersonalInformationTextField').setValue(selected.get('passportNumberDataIndex'));
           Ext.getCmp('expiryDateForEditPanelInPersonalInformationTextField').setValue(selected.get('expiryDateDataIndexforPersonalInformation'));
 
           Ext.getCmp('employmentTypeComboIdforfirst').setValue(selected.get('employeeTypeIDDataIndex'));
           Ext.getCmp('employmeeId1').setValue(selected.get('employmentIdDataIndex'));
           Ext.getCmp('dateOfJoiningId1').setValue(selected.get('dateOfJoiningDataIndex'));
           Ext.getCmp('dateOfLeavingId1').setValue(selected.get('dateOfLeavingDataIndex'));
           Ext.getCmp('bloodGroupId1').setValue(selected.get('bloodGroupDataIndex'));
           Ext.getCmp('groupNameComboIdforfirst').setValue(selected.get('groupNameDataIndex'));
           Ext.getCmp('statuscomboIdforfirst').setValue(selected.get('activeStatusDataIndex'));
           Ext.getCmp('remarksId1').setValue(selected.get('remarksDataIndex'));
           Ext.getCmp('governmentId1').setValue(selected.get('governmentOrResidenceIdDataIndex'));
           Ext.getCmp('governmentexpiryId1').setValue(selected.get('governmentOrResidenceIdExpiryDateDataIndex'));
           Ext.getCmp('rfidId1').setValue(selected.get('rfidCodeDataIndex'));
           Ext.getCmp('workmanCompensationIdForTextField').setValue(selected.get('workCompensationIdDataIndex'));
           Ext.getCmp('expiryDateworkmanCompensationIdForTextField').setValue(selected.get('workCompensationExpiryDateDataIndex'));
           
           Ext.getCmp('medicalInsuranceId1').setValue(selected.get('medicalInsuranceDataIndex'));
           Ext.getCmp('medicalInsuranceCompanyId1').setValue(selected.get('medicalInsuranceCompanyDataIndex'));
           Ext.getCmp('MedicalInsuranceExpiryDateId1').setValue(selected.get('medicalInsuranceExpiryDateDataIndex'));
           Ext.getCmp('licenceId1').setValue(selected.get('licenseNoDataIndex'));
           Ext.getCmp('licencePlaceId1').setValue(selected.get('licencePlaceDataIndex'));
           Ext.getCmp('licenceIssueDateId1').setValue(selected.get('licenceIssueDateDataIndex'));
           Ext.getCmp('licenceRenewedDateId1').setValue(selected.get('licenceRewenedDateDataIndex'));
           Ext.getCmp('preferedCompanyLabelId').setText(selected.get('preferedCompanyLabelDataIndex'));                     
           Ext.getCmp('licenceExpiryDateId1').setValue(selected.get('licenceExpiryDateDataIndex'));
           Ext.getCmp('gunLicenceId1').setValue(selected.get('gunLicenceNoDataIndex'));
           Ext.getCmp('gunLicenceTypeId1').setValue(selected.get('gunLicenceTypeDataIndex'));
           Ext.getCmp('gunLicenceIssueDateId1').setValue(selected.get('gunLicenceIssueDateDataIndex'));
           Ext.getCmp('gunLicenceIssuePlaceId1').setValue(selected.get('gunLicenceIssuePlaceDataIndex'));
           Ext.getCmp('gunLicenceExpiryDateId1').setValue(selected.get('gunLicenceExpiryDateDataIndex'));
       }
   }
    //********************************************************************END OF EMPLOYEE INFORMATION************************************************************//
   var firstHalfForinsuranceInformationPanel = new Ext.Panel({
       standardSubmit: true,
       collapsible: false,
       id: 'firstHalfIdForInsurance',
       layout: 'table',
       frame: false,
       height: 70,
       width: 475,
       layoutConfig: {
           columns: 2
       },
       items: [{
           xtype: 'label',
           text: '<%=MedicalInsuranceNo%>' + ' :',
           cls: 'labelstyle',
           id: 'Medical'
       }, {
           xtype: 'label',
           id: 'medicalInsuranceLabelId',
           cls: 'labelForUserInterface'
       }, {
           xtype: 'label',
           text: '<%=MedicalInsuranceExpiryDate%>' + ' :',
           cls: 'labelstyle',
           id: 'MedicalInsuranceExpiry'
       }, {
           xtype: 'label',
           id: 'MedicalInsuranceExpiryId',
           cls: 'labelForUserInterface'
       }]
   });
   var secondHalfForinsuranceInformationPanel = new Ext.Panel({
       standardSubmit: true,
       collapsible: false,
       id: 'secondHalfIdForInsurance',
       layout: 'table',
       frame: false,
       height: 70,
       width: 575,
       layoutConfig: {
           columns: 2
       },
       items: [{
           xtype: 'label',
           text: '<%=MedicalInsuranceCompany%>' + ' :',
           cls: 'labelstyle',
           id: 'MedicalCompany'
       }, {
           xtype: 'label',
           id: 'medicalInsuranceCompanyLabelId',
           cls: 'labelForUserInterface'
       }]
   });
   var insuranceInformationPanel = new Ext.Panel({
       standardSubmit: true,
       collapsible: false,
       title: '<%=InsuranceInformation%>',
       id: 'insuranceId',
       layout: 'table',
       frame: true,
       height: 130,
       width: 1000,
       items: [firstHalfForinsuranceInformationPanel, secondHalfForinsuranceInformationPanel]
   });
   var editPanelForInsurance = new Ext.Panel({
       id: 'editpanelidFoeInsurance',
       standardSubmit: true,
       collapsible: false,
       autoHeight: true,
       height: 110,
       width: 1000,
       frame: true,
       layout: 'table',
       layoutConfig: {
           columns: 4
       },
       buttons: [{
           xtype: 'button',
           text: '<%=Edit%>',
           iconCls : 'editbutton',
           id: 'saveInsuranceId',
           cls: 'buttonstyle',
           width: 70,
           listeners: {
               click: {
                   fn: function () {
                   buttonValue = '<%=Edit%>';
                       insuranceInformation();
                   }
               }
           }
       }]
   });
   var editOuterPanelWindowF0rInsurance = new Ext.Panel({
       width: 1000,
       height: 190,
       standardSubmit: true,
       frame: false,
       items: [insuranceInformationPanel, editPanelForInsurance]
   });
   myWineditForInsurance = new Ext.Window({
       closable: false,
       resizable: false,
       modal: true,
       autoScroll: false,
       height: 330,
       width: 1000,
       id: 'myWinforEditInsurance',
       items: [editOuterPanelWindowF0rInsurance]
   });
   var innerPanelForInsuranceInformation = new Ext.Panel({
       standardSubmit: true,
       collapsible: false,
       autoScroll: true,
       height: 222,
       width: 455,
       frame: true,
       id: 'insuranceInfoId',
       layout: 'table',
       layoutConfig: {
           columns: 4
       },
       items: [{
           xtype: 'fieldset',
           title: '<%=InsuranceInformation%>',
           cls: 'fieldsetpanel',
           collapsible: false,
           colspan: 3,
           id: 'insurancepanelid',
           width: 410,
           height: 220,
           layout: 'table',
           layoutConfig: {
               columns: 4
           },
           items: [{
               xtype: 'label',
               text: '<%=MedicalInsuranceNo%>' + ' :',
               cls: 'labelstyle',
               id: 'Medical1'
           }, {
               xtype: 'label',
               text: '',
               cls: 'mandatoryfield',
               id: 'mandatorymedicalId'
           }, {
               xtype: 'textfield',
               cls: 'selectstylePerfect',
               regex: validate('alphanumericname'),
               emptyText: '<%=EnterMedicalInsuranceNo%>',
               allowBlank: false,
               blankText: '<%=EnterMedicalInsuranceNo%>',
               id: 'medicalInsuranceId1'
           }, {
               xtype: 'label',
               text: '',
               cls: 'mandatoryfield',
               id: 'mandatorymedicalId1'
           }, {
               xtype: 'label',
               text: '<%=MedicalInsuranceCompany%>' + ' :',
               cls: 'labelstyle',
               id: 'MedicalCompany1'
           }, {
               xtype: 'label',
               text: '',
               cls: 'mandatoryfield',
               id: 'mandatoryMedicalCompanyId'
           }, {
               xtype: 'textfield',
               cls: 'selectstylePerfect',
               emptyText: '<%=EnterMedicalInsuranceCompany%>',
               allowBlank: false,
               blankText: '<%=EnterMedicalInsuranceCompany%>',
               id: 'medicalInsuranceCompanyId1'
           }, {
               xtype: 'label',
               text: '',
               cls: 'mandatoryfield',
               id: 'mandatoryMedicalCompany1'
           }, {
               xtype: 'label',
               text: '<%=MedicalInsuranceExpiryDate%>' + ' :',
               cls: 'labelstyle',
               id: 'MedicalInsuranceExpiry1'
           }, {
               xtype: 'label',
               text: '',
               cls: 'mandatoryfield',
               id: 'mandatoryMedicalInsuranceExpiryId'
           }, {
               xtype: 'datefield',
               cls: 'selectstylePerfect',
               allowBlank: false,
               value: dtcur,
               format: getDateFormat(),
               allowBlank: false,
               id: 'MedicalInsuranceExpiryDateId1'
           }, {
               xtype: 'label',
               text: '',
               cls: 'mandatoryfield',
               id: 'mandatoryMedicalInsuranceExpiry1'
           }]
       }]
   });
   var innerWinButtonPanelForInsurance = new Ext.Panel({
       id: 'insurancewinbuttonid',
       standardSubmit: true,
       collapsible: false,
       autoHeight: true,
       height: 110,
       width: 460,
       frame: true,
       layout: 'table',
       layoutConfig: {
           columns: 4
       },
       buttons: [{
           xtype: 'button',
           text: '<%=Save%>',
           iconCls:'savebutton',
           id: 'insuranceaddButtId',
           cls: 'buttonstyle',
           width: 70,
           listeners: {
               click: {
                   fn: function () {
                       if (driverId == "") {
                           Ext.example.msg("<%=SelectDriver%>");
                           return;
                       }
                       insuranceInformationOuterPanelWindow.getEl().mask();
                       // var selected = firstGridToGetDriverName.getSelectionModel().getSelected();
                       //  driverId = selected.get('DriverIdDataIndex');
                       Ext.Ajax.request({
                           url: '<%=request.getContextPath()%>/CrewMasterDataAction.do?param=saveInsuranceInformation',
                           method: 'POST',
                           params: {
                               CustID: Ext.getCmp('custcomboId').getValue(),
                               custName: Ext.getCmp('custcomboId').getRawValue(),
                               medicalInsuranceId: Ext.getCmp('medicalInsuranceId1').getValue(),
                               medicalInsuranceCompanyName: Ext.getCmp('medicalInsuranceCompanyId1').getValue(),
                               medicalinsuranceExpiryDate: Ext.getCmp('MedicalInsuranceExpiryDateId1').getValue(),
                               driverId: driverId
                           },
                           success: function (response, options) {
                               var message = response.responseText;
                               Ext.example.msg(message);
                               myWinForInformation.hide();
                               firstGridStoreForDriverName.load({
                                   params: {
                                       CustId: Ext.getCmp('custcomboId').getValue(),
                                       CustName: custName
                                   },
                                   callback: function () {
                                       if (firstGridStoreForDriverName.data.items.length != 0) {
                                           var row = firstGridStoreForDriverName.findExact('DriverIdDataIndex', driverId);
                                           var rec = firstGridStoreForDriverName.getAt(row);
                                           Ext.getCmp('medicalInsuranceLabelId').setText(rec.get('medicalInsuranceDataIndex'));
                                           Ext.getCmp('medicalInsuranceCompanyLabelId').setText(rec.get('medicalInsuranceCompanyDataIndex'));
                                           Ext.getCmp('MedicalInsuranceExpiryId').setText(rec.get('medicalInsuranceExpiryDateDataIndex'));
                                       }
                                   }
                               });
                               insuranceInformationOuterPanelWindow.getEl().unmask();
                           },
                           failure: function () {
                               Ext.example.msg("Error");
                               myWinForInformation.hide();
                           }
                       });
                   }
               }
           }
       }, {
           xtype: 'button',
           text: '<%=Cancel%>',
           id: 'informationcanButtId',
           cls: 'buttonstyle',
           iconCls: 'cancelbutton',
           width: 70,
           listeners: {
               click: {
                   fn: function () {
                       myWinForInformation.hide();
                    }
               }
           }
       }]
   });
   var insuranceInformationOuterPanelWindow = new Ext.Panel({
       width: 460,
       height: 330,
       standardSubmit: true,
       frame: true,
       items: [innerPanelForInsuranceInformation, innerWinButtonPanelForInsurance]
   });
   myWinForInformation = new Ext.Window({
       title: titelForInformationPanel,
       closable: false,
       resizable: false,
       modal: true,
       autoScroll: false,
       height: 330,
       width: 470,
       id: 'myWinInformationForInsuranceInformationEditButton',
       items: [insuranceInformationOuterPanelWindow]
   });

   function insuranceInformation() {
       if (Ext.getCmp('custcomboId').getValue() == "") {
           Ext.example.msg("<%=SelectCustomerName%>");
           return;
       }
       if (driverId == "") {
           Ext.example.msg("<%=SelectDriver%>");
           return;
       }
       buttonValue = '<%=Edit%>';
       titelForInformationPanel = '<%=InsuranceInformationDetails%>';
       myWinForInformation.setPosition(450, 150);
       myWinForInformation.show();
       myWinForInformation.setTitle(titelForInformationPanel);
       if (firstGridToGetDriverName.getSelectionModel().getCount() == 1) {
           var selected = firstGridToGetDriverName.getSelectionModel().getSelected();
           Ext.getCmp('nameId1').setValue(selected.get('driverNameDataIndex'));
           Ext.getCmp('lastNameId1').setValue(selected.get('lastNameDataIndex'));
           Ext.getCmp('addressId1').setValue(selected.get('presentAddressDataIndex'));
           Ext.getCmp('permanentAddressId1').setValue(selected.get('permanentAddressDataIndex'));
           Ext.getCmp('cityId1').setValue(selected.get('cityDataIndex'));
           Ext.getCmp('otherCityId1').setValue(selected.get('otherCityDataIndex'));
           Ext.getCmp('statecomboforfirst').setValue(selected.get('stateDataIndex'));
           Ext.getCmp('countryIdforfirst').setValue(selected.get('countryDataIndex'));
           Ext.getCmp('telephoneId1').setValue(selected.get('telephoneDataIndex'));
           Ext.getCmp('mobileId1').setValue(selected.get('mobileDataIndex'));
           Ext.getCmp('dateOfBirthId1').setValue(selected.get('dateOfBirthDataIndex'));
           Ext.getCmp('genderComboIdforfirst').setValue(selected.get('genderDataIndex'));
           Ext.getCmp('nationalityId1').setValue(selected.get('nationalityDataIndex'));
           Ext.getCmp('maritialComboIdforfirst').setValue(selected.get('maritialDataIndex'));
           Ext.getCmp('employmentTypeComboIdforfirst').setValue(selected.get('employmentTypeDataIndex'));
           Ext.getCmp('employmeeId1').setValue(selected.get('employmentIdDataIndex'));
           Ext.getCmp('dateOfJoiningId1').setValue(selected.get('dateOfJoiningDataIndex'));
           Ext.getCmp('dateOfLeavingId1').setValue(selected.get('dateOfLeavingDataIndex'));
           Ext.getCmp('bloodGroupId1').setValue(selected.get('bloodGroupDataIndex'));
           Ext.getCmp('groupNameComboIdforfirst').setValue(selected.get('groupNameDataIndex'));
           Ext.getCmp('statuscomboIdforfirst').setValue(selected.get('activeStatusDataIndex'));
           Ext.getCmp('remarksId1').setValue(selected.get('remarksDataIndex'));
           Ext.getCmp('governmentId1').setValue(selected.get('governmentOrResidenceIdDataIndex'));
           Ext.getCmp('governmentexpiryId1').setValue(selected.get('governmentOrResidenceIdExpiryDateDataIndex'));
           Ext.getCmp('rfidId1').setValue(selected.get('rfidCodeDataIndex'));
           Ext.getCmp('medicalInsuranceId1').setValue(selected.get('medicalInsuranceDataIndex'));
           Ext.getCmp('medicalInsuranceCompanyId1').setValue(selected.get('medicalInsuranceCompanyDataIndex'));
           Ext.getCmp('MedicalInsuranceExpiryDateId1').setValue(selected.get('medicalInsuranceExpiryDateDataIndex'));
           Ext.getCmp('licenceId1').setValue(selected.get('licenseNoDataIndex'));
           Ext.getCmp('licencePlaceId1').setValue(selected.get('licencePlaceDataIndex'));
           Ext.getCmp('licenceIssueDateId1').setValue(selected.get('licenceIssueDateDataIndex'));
           Ext.getCmp('licenceRenewedDateId1').setValue(selected.get('licenceRewenedDateDataIndex'));
           Ext.getCmp('preferedCompanyLabelId').setText(selected.get('preferedCompanyLabelDataIndex'));                     
           Ext.getCmp('licenceExpiryDateId1').setValue(selected.get('licenceExpiryDateDataIndex'));
           Ext.getCmp('gunLicenceId1').setValue(selected.get('gunLicenceNoDataIndex'));
           Ext.getCmp('gunLicenceTypeId1').setValue(selected.get('gunLicenceTypeDataIndex'));
           Ext.getCmp('gunLicenceIssueDateId1').setValue(selected.get('gunLicenceIssueDateDataIndex'));
           Ext.getCmp('gunLicenceIssuePlaceId1').setValue(selected.get('gunLicenceIssuePlaceDataIndex'));
           Ext.getCmp('gunLicenceExpiryDateId1').setValue(selected.get('gunLicenceExpiryDateDataIndex'));
           
           Ext.getCmp('passportNumberIdForEditPanelInPersonalInformationTextField').setValue(selected.get('passportNumberDataIndex'));
           Ext.getCmp('expiryDateForEditPanelInPersonalInformationTextField').setValue(selected.get('expiryDateDataIndexforPersonalInformation'));
           Ext.getCmp('workmanCompensationIdForTextField').setValue(selected.get('workCompensationIdDataIndex'));
           Ext.getCmp('expiryDateworkmanCompensationIdForTextField').setValue(selected.get('workCompensationExpiryDateDataIndex'));
 
 
       }
   }
    //*********************************************END OF INSURANCE PANEL********************************************************************************************// 
   var firstHalfFordriverInformationPanel = new Ext.Panel({
       standardSubmit: true,
       collapsible: false,
       id: 'firstHalfIdForDriver',
       layout: 'table',
       frame: false,
       height: 100,
       width: 475,
       layoutConfig: {
           columns: 2
       },
       items: [{
           xtype: 'label',
           text: '<%=LicenseNo%>' + ' :',
           cls: 'labelstyle',
           id: 'license'
       }, {
           xtype: 'label',
           id: 'licenceNoLabelId',
           cls: 'labelForUserInterface'
       }, {
           xtype: 'label',
           text: '<%=LicenseIssueDate%>' + ' :',
           cls: 'labelstyle',
           id: 'licenceIssueDate'
       }, {
           xtype: 'label',
           id: 'licenceIssueDateLabelId',
           cls: 'labelForUserInterface'
       }, {
           xtype: 'label',
           text: '<%=LicenseExpiryDate%>' + ' :',
           cls: 'labelstyle',
           id: 'licenceExpiryDate'
       }, {
           xtype: 'label',
           id: 'licenceExpiryDateLabelId',
           cls: 'labelForUserInterface'
       }]
   });
   var secondHalfFordriverInformationPanel = new Ext.Panel({
       standardSubmit: true,
       collapsible: false,
       id: 'secondHalfIdForDriver',
       layout: 'table',
       frame: false,
       height: 100,
       width: 575,
       layoutConfig: {
           columns: 2
       },
       items: [{
           xtype: 'label',
           text: '<%=LicensePlace%>' + ' :',
           cls: 'labelstyle',
           id: 'licencePlace'
       }, {
           xtype: 'label',
           id: 'licencePlaceLabelId',
           cls: 'labelForUserInterface'
       }, {
           xtype: 'label',
           text: '<%=LicenseRenewedDate%>' + ' :',
           cls: 'labelstyle',
           id: 'licenceRenewedDate'
       }, {
           xtype: 'label',
           id: 'licenceRenewedDateLabelId',
           cls: 'labelForUserInterface'
       },{
           xtype: 'label',
           text: '<%=preferedCompany%>' + ' :',
           cls: 'labelstyle',
           id: 'preferedCompany',
           hidden:true
       }, {
           xtype: 'label',
           id: 'preferedCompanyLabelId',
           cls: 'labelForUserInterface',
           hidden:true
       }]
   });
   var driverInformationPanel = new Ext.Panel({
       standardSubmit: true,
       collapsible: false,
       title: '<%=CrewInformation%>',
       id: 'driverInformationId',
       layout: 'table',
       frame: true,
       height: 150,
       width: 1000,
       items: [firstHalfFordriverInformationPanel, secondHalfFordriverInformationPanel]
   });
   var editPanelForDriver = new Ext.Panel({
       id: 'editpanelidFoeDriver',
       standardSubmit: true,
       collapsible: false,
       autoHeight: true,
       height: 110,
       width: 1000,
       frame: true,
       layout: 'table',
       layoutConfig: {
           columns: 4
       },
       buttons: [{
           xtype: 'button',
           text: '<%=Edit%>',
           iconCls : 'editbutton',
           id: 'saveDriverId',
           cls: 'buttonstyle',
           width: 70,
           listeners: {
               click: {
                   fn: function () {
                   buttonValue = '<%=Edit%>';
                       DriverInformationForEdit();
                   }
               }
           }
       }]
   });
   var editOuterPanelWindowF0rDriver = new Ext.Panel({
       width: 1000,
       height: 210,
       standardSubmit: true,
       frame: true,
       items: [driverInformationPanel, editPanelForDriver]
   });
   myWineditForDriver = new Ext.Window({
       closable: false,
       resizable: false,
       modal: true,
       autoScroll: false,
       height: 360,
       width: 1000,
       id: 'myWinforEditDriver',
       items: [editOuterPanelWindowF0rDriver]
   });
   var innerPanelForDriverInformation = new Ext.Panel({
       standardSubmit: true,
       collapsible: false,
       autoScroll: true,
       height: 222,
       width: 455,
       frame: true,
       id: 'driverInfoId',
       layout: 'table',
       layoutConfig: {
           columns: 4
       },
       items: [{
           xtype: 'fieldset',
           title: '<%=CrewInformation%>',
           cls: 'fieldsetpanel',
           collapsible: false,
           colspan: 3,
           id: 'driverpanelid',
           width: 410,
           height: 300,
           layout: 'table',
           layoutConfig: {
               columns: 3,
               tableAttrs: {
		            style: {
		                width: '88%'
		            }
        			}
           },
           items: [{
               xtype: 'label',
               text: '*',
               cls: 'mandatoryfield',
               id: 'mandatoryLicenceId'
           },{
               xtype: 'label',
               text: '<%=LicenseNo%>' + ' :',
               cls: 'labelstyle',
               id: 'license1'
           },  {
               xtype: 'textfield',
               cls: 'selectstylePerfect',
               regex: validate('alphanumericname'),
               emptyText: '<%=EnterLicenseNo%>',
               allowBlank: false,
               blankText: '<%=EnterLicenseNo%>',
               id: 'licenceId1'
           },{
               xtype: 'label',
               text: '',
               cls: 'mandatoryfield',
               id: 'mandatorylicencePlaceId'
           }, {
               xtype: 'label',
               text: '<%=LicensePlace%>' + ' :',
               cls: 'labelstyle',
               id: 'licencePlace1'
           },  {
               xtype: 'textfield',
               cls: 'selectstylePerfect',
               regex: validate('alphanumericname'),
               emptyText: '<%=EnterLicensePlace%>',
               allowBlank: false,
               blankText: '<%=EnterLicensePlace%>',
               id: 'licencePlaceId1'
           },{
               xtype: 'label',
               text: '',
               cls: 'mandatoryfield',
               id: 'mandatorylicenceIssueDateId'
           },  {
               xtype: 'label',
               text: '<%=LicenseIssueDate%>' + ' :',
               cls: 'labelstyle',
               id: 'licenceIssueDate'
           }, {
               xtype: 'datefield',
               cls: 'selectstylePerfect',
               allowBlank: false,
               value: dtcur,
               format: getDateFormat(),
               allowBlank: false,
               id: 'licenceIssueDateId1'
           }, {
               xtype: 'label',
               text: '',
               cls: 'mandatoryfield',
               id: 'mandatorylicenceRenewedDateId'
           }, {
               xtype: 'label',
               text: '<%=LicenseRenewedDate%>' + ' :',
               cls: 'labelstyle',
               id: 'licenceRenewedDate1'
           }, {
               xtype: 'datefield',
               cls: 'selectstylePerfect',
               allowBlank: false,
               value: dtcur,
               format: getDateFormat(),
               allowBlank: false,
               id: 'licenceRenewedDateId1'
           },  {
               xtype: 'label',
               text: '*',
               cls: 'mandatoryfield',
               id: 'mandatorylicenceExpiryDateId'
           },{
               xtype: 'label',
               text: '<%=LicenseExpiryDate%>' + ' :',
               cls: 'labelstyle',
               id: 'licenceExpiryDate1'
           }, {
               xtype: 'datefield',
               cls: 'selectstylePerfect',
               allowBlank: false,
               value: dtcur,
               format: getDateFormat(),
               allowBlank: false,
               id: 'licenceExpiryDateId1'
           },{
               xtype: 'label',
               text: '*',
               cls: 'mandatoryfield',
               id: 'mandatorypreferedCompanyId'
           },{
               xtype: 'label',
               text: '<%=preferedCompany%>' + ' :',
               cls: 'labelstyle',
               id: 'preferedCompanyId'
           },customerGrid]
       }]
   });

   var innerWinButtonPanelForInsurance = new Ext.Panel({
       id: 'driverwinbuttonid',
       standardSubmit: true,
       collapsible: false,
       autoHeight: true,
       height: 110,
       width: 460,
       frame: true,
       layout: 'table',
       layoutConfig: {
           columns: 4
       },
       buttons: [{
           xtype: 'button',
           text: '<%=Save%>',
           iconCls:'savebutton',
           id: 'driverButtId',
           cls: 'buttonstyle',
           width: 70,
           listeners: {
               click: {
                   fn: function () {
                   
                   var selected = firstGridToGetDriverName.getSelectionModel().getSelected();
                       if (driverId == "") {
                           Ext.example.msg("<%=SelectDriver%>");
                           return;
                       }
                       if (Ext.getCmp('licenceId1').getValue() == "" && selected.get('employeeTypeDataIndex') != "CUSTODIAN") {
                           Ext.example.msg("<%=EnterLicenseNo%>");
                           return;
                       }
                       if (Ext.getCmp('licenceExpiryDateId1').getValue() == "" && selected.get('employeeTypeDataIndex') != "CUSTODIAN") {
                           Ext.example.msg("<%=EnterExpiryDate%>");
                           return;
                       }
                       driverInformationOuterPanelWindow.getEl().mask();
                       //var selected = firstGridToGetDriverName.getSelectionModel().getSelected();
                       //  driverId = selected.get('DriverIdDataIndex');
                      
                      customerNmaes = "";
                      if (selected.get('employeeTypeDataIndex') == "CUSTODIAN") {
                       var records = customerGrid.getSelectionModel().getSelections();
                        for (var i = 0, len = records.length; i < len; i++) {
                            var store = records[i];
                            var cId = store.get('customerName2');
                            customerNmaes = customerNmaes + cId + ",";
                        }
                       } 
                       
                       Ext.Ajax.request({
                           url: '<%=request.getContextPath()%>/CrewMasterDataAction.do?param=saveDriverInformation',
                           method: 'POST',
                           params: {
                               CustID: Ext.getCmp('custcomboId').getValue(),
                               custName: Ext.getCmp('custcomboId').getRawValue(),
                               licenceId: Ext.getCmp('licenceId1').getValue(),
                               licencePlace: Ext.getCmp('licencePlaceId1').getValue(),
                               licenceIssueDate: Ext.getCmp('licenceIssueDateId1').getValue(),
                               licenceRenewedDate: Ext.getCmp('licenceRenewedDateId1').getValue(),
                               licenceExpiryDate: Ext.getCmp('licenceExpiryDateId1').getValue(),
                               driverId: driverId,
                               preferedCustomerNmaes :customerNmaes
                           },
                           success: function (response, options) {
                               var message = response.responseText;
                               Ext.example.msg(message);
                               myWinForDriver.hide();
                               myWinForInformation.hide();
                               firstGridStoreForDriverName.load({
                                   params: {
                                       CustId: Ext.getCmp('custcomboId').getValue(),
                                       CustName: custName
                                   },
                                   callback: function () {
                                       if (firstGridStoreForDriverName.data.items.length != 0) {
                                           var row = firstGridStoreForDriverName.findExact('DriverIdDataIndex', driverId);
                                           var rec = firstGridStoreForDriverName.getAt(row);
                                           Ext.getCmp('licenceNoLabelId').setText(rec.get('licenseNoDataIndex'));
                                           Ext.getCmp('licencePlaceLabelId').setText(rec.get('licencePlaceDataIndex'));
                                           Ext.getCmp('licenceIssueDateLabelId').setText(rec.get('licenceIssueDateDataIndex'));
                                           Ext.getCmp('licenceRenewedDateLabelId').setText(rec.get('licenceRewenedDateDataIndex'));
                                           Ext.getCmp('preferedCompanyLabelId').setText(rec.get('preferedCompanyLabelDataIndex'));
                                           Ext.getCmp('licenceExpiryDateLabelId').setText(rec.get('licenceExpiryDateDataIndex'));
                                       }
                                   }
                               });
                               driverInformationOuterPanelWindow.getEl().unmask();
                           },
                           failure: function () {
                               Ext.example.msg("Error");   
                               myWinForDriver.hide();
                           }
                       });
                   }
               }
           }
       }, {
           xtype: 'button',
           text: '<%=Cancel%>',
           id: 'drivercanButtId',
           cls: 'buttonstyle',
           iconCls: 'cancelbutton',
           width: 70,
           listeners: {
               click: {
                   fn: function () {
                       myWinForDriver.hide();
                   }
               }
           }
       }]
   });
   var driverInformationOuterPanelWindow = new Ext.Panel({
       width: 460,
       height: 300,
       standardSubmit: true,
       frame: true,
       items: [innerPanelForDriverInformation, innerWinButtonPanelForInsurance]
   });
   myWinForDriver = new Ext.Window({
       title: titelForDriverPanel,
       closable: false,
       resizable: false,
       modal: true,
       autoScroll: false,
       height: 330,
       width: 470,
       id: 'myWinDriverForDriverInformation',
       items: [driverInformationOuterPanelWindow]
   });

   function DriverInformationForEdit() {
       if (Ext.getCmp('custcomboId').getValue() == "") {
           Ext.example.msg("<%=SelectCustomerName%>");
           return;
       }
       if (driverId == "") {
           Ext.example.msg("<%=SelectDriver%>");
           return;
       }
       buttonValue = '<%=Edit%>';
       titelForDriverPanel = '<%=CrewInformation%>';
       myWinForDriver.setPosition(450, 150);
       myWinForDriver.show();
       myWinForDriver.setTitle(titelForDriverPanel);
              customercheckstore.load({
                       params: {
                           CustId: Ext.getCmp('custcomboId').getValue()
                       }
                   });
       if (firstGridToGetDriverName.getSelectionModel().getCount() == 1) {
           var selected = firstGridToGetDriverName.getSelectionModel().getSelected();
           Ext.getCmp('nameId1').setValue(selected.get('driverNameDataIndex'));
           Ext.getCmp('lastNameId1').setValue(selected.get('lastNameDataIndex'));
           Ext.getCmp('addressId1').setValue(selected.get('presentAddressDataIndex'));
           Ext.getCmp('permanentAddressId1').setValue(selected.get('permanentAddressDataIndex'));
           Ext.getCmp('cityId1').setValue(selected.get('cityDataIndex'));
           Ext.getCmp('otherCityId1').setValue(selected.get('otherCityDataIndex'));
           Ext.getCmp('statecomboforfirst').setValue(selected.get('stateDataIndex'));
           Ext.getCmp('countryIdforfirst').setValue(selected.get('countryDataIndex'));
           Ext.getCmp('telephoneId1').setValue(selected.get('telephoneDataIndex'));
           Ext.getCmp('mobileId1').setValue(selected.get('mobileDataIndex'));
           Ext.getCmp('dateOfBirthId1').setValue(selected.get('dateOfBirthDataIndex'));
           Ext.getCmp('genderComboIdforfirst').setValue(selected.get('genderDataIndex'));
           Ext.getCmp('nationalityId1').setValue(selected.get('nationalityDataIndex'));
           Ext.getCmp('maritialComboIdforfirst').setValue(selected.get('maritialDataIndex'));
           Ext.getCmp('employmentTypeComboIdforfirst').setValue(selected.get('employmentTypeDataIndex'));
           Ext.getCmp('employmeeId1').setValue(selected.get('employmentIdDataIndex'));
           Ext.getCmp('dateOfJoiningId1').setValue(selected.get('dateOfJoiningDataIndex'));
           Ext.getCmp('dateOfLeavingId1').setValue(selected.get('dateOfLeavingDataIndex'));
           Ext.getCmp('bloodGroupId1').setValue(selected.get('bloodGroupDataIndex'));
           Ext.getCmp('groupNameComboIdforfirst').setValue(selected.get('groupNameDataIndex'));
           Ext.getCmp('statuscomboIdforfirst').setValue(selected.get('activeStatusDataIndex'));
           Ext.getCmp('remarksId1').setValue(selected.get('remarksDataIndex'));
           Ext.getCmp('governmentId1').setValue(selected.get('governmentOrResidenceIdDataIndex'));
           Ext.getCmp('governmentexpiryId1').setValue(selected.get('governmentOrResidenceIdExpiryDateDataIndex'));
           Ext.getCmp('rfidId1').setValue(selected.get('rfidCodeDataIndex'));
           Ext.getCmp('medicalInsuranceId1').setValue(selected.get('medicalInsuranceDataIndex'));
           Ext.getCmp('medicalInsuranceCompanyId1').setValue(selected.get('medicalInsuranceCompanyDataIndex'));
           Ext.getCmp('MedicalInsuranceExpiryDateId1').setValue(selected.get('medicalInsuranceExpiryDateDataIndex'));
           Ext.getCmp('licenceId1').setValue(selected.get('licenseNoDataIndex'));
           Ext.getCmp('licencePlaceId1').setValue(selected.get('licencePlaceDataIndex'));
           Ext.getCmp('licenceIssueDateId1').setValue(selected.get('licenceIssueDateDataIndex'));
           Ext.getCmp('licenceRenewedDateId1').setValue(selected.get('licenceRewenedDateDataIndex'));
           Ext.getCmp('preferedCompanyLabelId').setText(selected.get('preferedCompanyLabelDataIndex'));           
           Ext.getCmp('licenceExpiryDateId1').setValue(selected.get('licenceExpiryDateDataIndex'));
           Ext.getCmp('gunLicenceId1').setValue(selected.get('gunLicenceNoDataIndex'));
           Ext.getCmp('gunLicenceTypeId1').setValue(selected.get('gunLicenceTypeDataIndex'));
           Ext.getCmp('gunLicenceIssueDateId1').setValue(selected.get('gunLicenceIssueDateDataIndex'));
           Ext.getCmp('gunLicenceIssuePlaceId1').setValue(selected.get('gunLicenceIssuePlaceDataIndex'));
           Ext.getCmp('gunLicenceExpiryDateId1').setValue(selected.get('gunLicenceExpiryDateDataIndex'));
           
           Ext.getCmp('passportNumberIdForEditPanelInPersonalInformationTextField').setValue(selected.get('passportNumberDataIndex'));
           Ext.getCmp('expiryDateForEditPanelInPersonalInformationTextField').setValue(selected.get('expiryDateDataIndexforPersonalInformation'));
           Ext.getCmp('workmanCompensationIdForTextField').setValue(selected.get('workCompensationIdDataIndex'));
           Ext.getCmp('expiryDateworkmanCompensationIdForTextField').setValue(selected.get('workCompensationExpiryDateDataIndex'));
 
       }
   }
    //**********************************************END OF DRIVER PANEL******************************************************************************************//
   var firstHalfForInformationPanel = new Ext.Panel({
       standardSubmit: true,
       collapsible: false,
       id: 'firstHalfIdForGun',
       layout: 'table',
       frame: false,
       width: 475,
       height: 80,
       layoutConfig: {
           columns: 2
       },
       items: [{
           xtype: 'label',
           text: '<%=GunLicenseNo%>' + ' :',
           cls: 'labelstyle',
           id: 'gunlicence'
       }, {
           xtype: 'label',
           id: 'gunGicenceNoLabelId',
           cls: 'labelForUserInterface'
       }, {
           xtype: 'label',
           text: '<%=GunLicenseIssueDate%>' + ' :',
           cls: 'labelstyle',
           id: 'gunLicenceIssueDate'
       }, {
           xtype: 'label',
           id: 'gunLicenceIssueDateLabelId',
           cls: 'labelForUserInterface'
       }, {
           xtype: 'label',
           text: '<%=GunLicenseExpiryDate%>' + ' :',
           cls: 'labelstyle',
           id: 'gunLicenceExpiryDate'
       }, {
           xtype: 'label',
           id: 'gunLicenceExpiryDateLabelId',
           cls: 'labelForUserInterface'
       }]
   });
   var secondHalfForInformationPanel = new Ext.Panel({
       standardSubmit: true,
       collapsible: false,
       id: 'secondHalfIdForGun',
       layout: 'table',
       frame: false,
       width: 575,
       height: 80,
       layoutConfig: {
           columns: 2
       },
       items: [{
           xtype: 'label',
           text: '<%=GunLicenseType%>' + ' :',
           cls: 'labelstyle',
           id: 'gunLicenceType'
       }, {
           xtype: 'label',
           id: 'gunLicenceTypeLabelId',
           cls: 'labelForUserInterface'
       }, {
           xtype: 'label',
           text: '<%=GunLicenseIssuePlace%>' + ' :',
           cls: 'labelstyle',
           id: 'gunLicenceIssuePlace'
       }, {
           xtype: 'label',
           id: 'gunLicenceIssuePlaceLabelId',
           cls: 'labelForUserInterface'
       }]
   });
   var GunMenInformationPanel = new Ext.Panel({
       standardSubmit: true,
       collapsible: false,
       title: '<%=GunMenInformation%>',
       id: 'gunMenId',
       layout: 'table',
       frame: true,
       width: 1000,
       height: 140,
       items: [firstHalfForInformationPanel, secondHalfForInformationPanel]
   });
   var editPanelForInsuranceForGun = new Ext.Panel({
       id: 'editpanelidFoeGun',
       standardSubmit: true,
       collapsible: false,
       autoHeight: true,
       height: 110,
       width: 1000,
       frame: true,
       layout: 'table',
       layoutConfig: {
           columns: 4
       },
       buttons: [{
           xtype: 'button',
           text: '<%=Edit%>',
           iconCls : 'editbutton',
           id: 'saveGunId',
           cls: 'buttonstyle',
           width: 70,
           listeners: {
               click: {
                   fn: function () {
                   buttonValue = '<%=Edit%>';
                       gunInformation();
                   }
               }
           }
       }]
   });
   var editOuterPanelWindowF0rGun = new Ext.Panel({
       width: 1000,
       height: 200,
       standardSubmit: true,
       frame: false,
       items: [GunMenInformationPanel, editPanelForInsuranceForGun]
   });
   myWineditForGun = new Ext.Window({
       closable: false,
       resizable: false,
       modal: true,
       autoScroll: false,
       height: 330,
       width: 1000,
       id: 'myWinforEditForGun',
       items: [editOuterPanelWindowF0rGun]
   });
   var innerPanelForGunInformation = new Ext.Panel({
       standardSubmit: true,
       collapsible: false,
       autoScroll: true,
       height: 260,
       width: 460,
       frame: true,
       id: 'gunInfoId',
       layout: 'table',
       layoutConfig: {
           columns: 4
       },
       items: [{
           xtype: 'fieldset',
           title: '<%=GunmenInformation%>',
           cls: 'fieldsetpanel',
           collapsible: false,
           colspan: 3,
           id: 'gunpanelid',
           width: 430,
           height: 220,
           layout: 'table',
           layoutConfig: {
               columns: 4
           },
           items: [{
               xtype: 'label',
               text: '<%=GunLicenseNo%>' + ' :',
               cls: 'labelstyle',
               id: 'gunlicence'
           }, {
               xtype: 'label',
               text: '',
               cls: 'mandatoryfield',
               id: 'mandatorygunlicenceId'
           }, {
               xtype: 'textfield',
               cls: 'selectstylePerfect',
               regex: validate('alphanumericname'),
               emptyText: '<%=EnterGunLicenseNo%>',
               allowBlank: false,
               blankText: '<%=EnterGunLicenseNo%>',
               id: 'gunLicenceId1'
           }, {
               xtype: 'label',
               text: '',
               cls: 'mandatoryfield',
               id: 'mandatorygunlicenceId1'
           }, {
               xtype: 'label',
               text: '<%=GunLicenseType%>' + ' :',
               cls: 'labelstyle',
               id: 'gunLicenceType1'
           }, {
               xtype: 'label',
               text: '',
               cls: 'mandatoryfield',
               id: 'mandatorygunLicenceTypeId'
           }, {
               xtype: 'textfield',
               cls: 'selectstylePerfect',
               regex: validate('alphanumericname'),
               emptyText: '<%=EnterGunLicenseType%>',
               allowBlank: false,
               blankText: '<%=EnterGunLicenseType%>',
               id: 'gunLicenceTypeId1'
           }, {
               xtype: 'label',
               text: '',
               cls: 'mandatoryfield',
               id: 'mandatorygunLicenceTypeId1'
           }, {
               xtype: 'label',
               text: '<%=GunLicenseIssueDate%>' + ' :',
               cls: 'labelstyle',
               id: 'gunLicenceIssueDate11'
           }, {
               xtype: 'label',
               text: '',
               cls: 'mandatoryfield',
               id: 'mandatorygunLicenceIssueDateId'
           }, {
               xtype: 'datefield',
               cls: 'selectstylePerfect',
               allowBlank: false,
               value: dtcur,
               format: getDateFormat(),
               allowBlank: false,
               id: 'gunLicenceIssueDateId1'
           }, {
               xtype: 'label',
               text: '',
               cls: 'mandatoryfield',
               id: 'mandatorygunLicenceIssueDateId1'
           }, {
               xtype: 'label',
               text: '<%=GunLicenseIssuePlace%>' + ' :',
               cls: 'labelstyle',
               id: 'gunLicenceIssuePlace11'
           }, {
               xtype: 'label',
               text: '',
               cls: 'mandatoryfield',
               id: 'mandatorygunLicenceIssuePlaceId'
           }, {
               xtype: 'textfield',
               cls: 'selectstylePerfect',
               regex: validate('alphanumericname'),
               emptyText: '<%=EnterGunLicenseIssuePlace%>',
               allowBlank: false,
               blankText: '<%=EnterGunLicenseIssuePlace%>',
               id: 'gunLicenceIssuePlaceId1'
           }, {
               xtype: 'label',
               text: '',
               cls: 'mandatoryfield',
               id: 'mandatorygunLicenceIssuePlaceId1'
           }, {
               xtype: 'label',
               text: '<%=GunLicenseExpiryDate%>' + ' :',
               cls: 'labelstyle',
               id: 'gunLicenceExpiryDate11'
           }, {
               xtype: 'label',
               text: '',
               cls: 'mandatoryfield',
               id: 'mandatorygunLicenceExpiryDateId'
           }, {
               xtype: 'datefield',
               cls: 'selectstylePerfect',
               allowBlank: false,
               value: dtcur,
               format: getDateFormat(),
               allowBlank: false,
               id: 'gunLicenceExpiryDateId1'
           }, {
               xtype: 'label',
               text: '',
               cls: 'mandatoryfield',
               id: 'mandatorygunLicenceExpiryDate1'
           }]
       }]
   });
   var innerWinButtonPanelForGun = new Ext.Panel({
       id: 'gunwinbuttonid',
       standardSubmit: true,
       collapsible: false,
       autoHeight: true,
       height: 110,
       width: 460,
       frame: true,
       layout: 'table',
       layoutConfig: {
           columns: 4
       },
       buttons: [{
           xtype: 'button',
           text: '<%=Save%>',
           iconCls:'savebutton',
           id: 'gunButtId',
           cls: 'buttonstyle',
           width: 70,
           listeners: {
               click: {
                   fn: function () {
                       if (driverId == "") {
                           Ext.example.msg("<%=SelectDriver%>");
                           return;
                       }
                       gunInformationOuterPanelWindow.getEl().mask();
                       // var selected = firstGridToGetDriverName.getSelectionModel().getSelected();
                       // driverId = selected.get('DriverIdDataIndex');
                       Ext.Ajax.request({
                           url: '<%=request.getContextPath()%>/CrewMasterDataAction.do?param=saveGunMenInformation',
                           method: 'POST',
                           params: {
                               CustID: Ext.getCmp('custcomboId').getValue(),
                               custName: Ext.getCmp('custcomboId').getRawValue(),
                               gunLicenceId: Ext.getCmp('gunLicenceId1').getValue(),
                               gunLicenceTypeId: Ext.getCmp('gunLicenceTypeId1').getValue(),
                               gunLicenceIssueDate: Ext.getCmp('gunLicenceIssueDateId1').getValue(),
                               gunLicenceIssuePlace: Ext.getCmp('gunLicenceIssuePlaceId1').getValue(),
                               gunLicenceExpiryDate: Ext.getCmp('gunLicenceExpiryDateId1').getValue(),
                               driverId: driverId
                           },
                           success: function (response, options) {
                               var message = response.responseText;
                               Ext.example.msg(message);
                               ctsb.setStatus({
                                   text: getMessageForStatus(message),
                                   iconCls: '',
                                   clear: true
                               });
                               myWinForGun.hide();
                               firstGridStoreForDriverName.load({
                                   params: {
                                       CustId: Ext.getCmp('custcomboId').getValue(),
                                       CustName: custName
                                   },
                                   callback: function () {
                                       if (firstGridStoreForDriverName.data.items.length != 0) {
                                           var row = firstGridStoreForDriverName.findExact('DriverIdDataIndex', driverId);
                                           var rec = firstGridStoreForDriverName.getAt(row);
                                           Ext.getCmp('gunGicenceNoLabelId').setText(rec.get('gunLicenceNoDataIndex'));
                                           Ext.getCmp('gunLicenceTypeLabelId').setText(rec.get('gunLicenceTypeDataIndex'));
                                           Ext.getCmp('gunLicenceIssueDateLabelId').setText(rec.get('gunLicenceIssueDateDataIndex'));
                                           Ext.getCmp('gunLicenceIssuePlaceLabelId').setText(rec.get('gunLicenceIssuePlaceDataIndex'));
                                           Ext.getCmp('gunLicenceExpiryDateLabelId').setText(rec.get('gunLicenceExpiryDateDataIndex'));
                                       }
                                   }
                               });
                               gunInformationOuterPanelWindow.getEl().unmask();
                           },
                           failure: function () {
                               Ext.example.msg("Error");
                               myWinForGun.hide();
                           }
                       });
                   }
               }
           }
       }, {
           xtype: 'button',
           text: '<%=Cancel%>',
           id: 'guncanButtId',
           cls: 'buttonstyle',
           iconCls: 'cancelbutton',
           width: 70,
           listeners: {
               click: {
                   fn: function () {
                       myWinForGun.hide();
                   }
               }
           }
       }]
   });
   var gunInformationOuterPanelWindow = new Ext.Panel({
       width: 460,
       height: 310,
       standardSubmit: true,
       frame: false,
       items: [innerPanelForGunInformation, innerWinButtonPanelForGun]
   });
   myWinForGun = new Ext.Window({
       title: titelForGunPanel,
       closable: false,
       resizable: false,
       modal: true,
       autoScroll: false,
       height: 360,
       width: 470,
       id: 'myWingun',
       items: [gunInformationOuterPanelWindow]
   });

   function gunInformation() {
       if (Ext.getCmp('custcomboId').getValue() == "") {
           Ext.example.msg("<%=SelectCustomerName%>");
           return;
       }
       if (driverId == "") {
           Ext.example.msg("<%=SelectDriver%>");
           return;
       }
       buttonValue = '<%=Edit%>';
       titelForGunPanel = '<%=GunmenInformationDetails%>';
       myWinForGun.setPosition(450, 150);
       myWinForGun.show();
       myWinForGun.setTitle(titelForGunPanel);
       if (firstGridToGetDriverName.getSelectionModel().getCount() == 1) {
           var selected = firstGridToGetDriverName.getSelectionModel().getSelected();
           //driverId = selected.get('DriverIdDataIndex');
           Ext.getCmp('nameId1').setValue(selected.get('driverNameDataIndex'));
           Ext.getCmp('lastNameId1').setValue(selected.get('lastNameDataIndex'));
           Ext.getCmp('addressId1').setValue(selected.get('presentAddressDataIndex'));
           Ext.getCmp('permanentAddressId1').setValue(selected.get('permanentAddressDataIndex'));
           Ext.getCmp('cityId1').setValue(selected.get('cityDataIndex'));
           Ext.getCmp('otherCityId1').setValue(selected.get('otherCityDataIndex'));
           Ext.getCmp('statecomboforfirst').setValue(selected.get('stateDataIndex'));
           Ext.getCmp('countryIdforfirst').setValue(selected.get('countryDataIndex'));
           Ext.getCmp('telephoneId1').setValue(selected.get('telephoneDataIndex'));
           Ext.getCmp('mobileId1').setValue(selected.get('mobileDataIndex'));
           Ext.getCmp('dateOfBirthId1').setValue(selected.get('dateOfBirthDataIndex'));
           Ext.getCmp('genderComboIdforfirst').setValue(selected.get('genderDataIndex'));
           Ext.getCmp('nationalityId1').setValue(selected.get('nationalityDataIndex'));
           Ext.getCmp('maritialComboIdforfirst').setValue(selected.get('maritialDataIndex'));
           Ext.getCmp('employmentTypeComboIdforfirst').setValue(selected.get('employmentTypeDataIndex'));
           Ext.getCmp('employmeeId1').setValue(selected.get('employmentIdDataIndex'));
           Ext.getCmp('dateOfJoiningId1').setValue(selected.get('dateOfJoiningDataIndex'));
           Ext.getCmp('dateOfLeavingId1').setValue(selected.get('dateOfLeavingDataIndex'));
           Ext.getCmp('bloodGroupId1').setValue(selected.get('bloodGroupDataIndex'));
           Ext.getCmp('groupNameComboIdforfirst').setValue(selected.get('groupNameDataIndex'));
           Ext.getCmp('statuscomboIdforfirst').setValue(selected.get('activeStatusDataIndex'));
           Ext.getCmp('remarksId1').setValue(selected.get('remarksDataIndex'));
           Ext.getCmp('governmentId1').setValue(selected.get('governmentOrResidenceIdDataIndex'));
           Ext.getCmp('governmentexpiryId1').setValue(selected.get('governmentOrResidenceIdExpiryDateDataIndex'));
           Ext.getCmp('rfidId1').setValue(selected.get('rfidCodeDataIndex'));
           Ext.getCmp('medicalInsuranceId1').setValue(selected.get('medicalInsuranceDataIndex'));
           Ext.getCmp('medicalInsuranceCompanyId1').setValue(selected.get('medicalInsuranceCompanyDataIndex'));
           Ext.getCmp('MedicalInsuranceExpiryDateId1').setValue(selected.get('medicalInsuranceExpiryDateDataIndex'));
           Ext.getCmp('licenceId1').setValue(selected.get('licenseNoDataIndex'));
           Ext.getCmp('licencePlaceId1').setValue(selected.get('licencePlaceDataIndex'));
           Ext.getCmp('licenceIssueDateId1').setValue(selected.get('licenceIssueDateDataIndex'));
           Ext.getCmp('licenceRenewedDateId1').setValue(selected.get('licenceRewenedDateDataIndex'));
           Ext.getCmp('preferedCompanyLabelId').setText(selected.get('preferedCompanyLabelDataIndex'));          
           Ext.getCmp('licenceExpiryDateId1').setValue(selected.get('licenceExpiryDateDataIndex'));
           Ext.getCmp('gunLicenceId1').setValue(selected.get('gunLicenceNoDataIndex'));
           Ext.getCmp('gunLicenceTypeId1').setValue(selected.get('gunLicenceTypeDataIndex'));
           Ext.getCmp('gunLicenceIssueDateId1').setValue(selected.get('gunLicenceIssueDateDataIndex'));
           Ext.getCmp('gunLicenceIssuePlaceId1').setValue(selected.get('gunLicenceIssuePlaceDataIndex'));
           Ext.getCmp('gunLicenceExpiryDateId1').setValue(selected.get('gunLicenceExpiryDateDataIndex'));
           
           Ext.getCmp('passportNumberIdForEditPanelInPersonalInformationTextField').setValue(selected.get('passportNumberDataIndex'));
           Ext.getCmp('expiryDateForEditPanelInPersonalInformationTextField').setValue(selected.get('expiryDateDataIndexforPersonalInformation'));
           Ext.getCmp('workmanCompensationIdForTextField').setValue(selected.get('workCompensationIdDataIndex'));
           Ext.getCmp('expiryDateworkmanCompensationIdForTextField').setValue(selected.get('workCompensationExpiryDateDataIndex'));
 
       }
   }
   var cols1 = new Ext.grid.ColumnModel([
       new Ext.grid.RowNumberer({
           header: "<span style=font-weight:bold;>SLNO</span>",
           width: 40
       }), {
           header: '<b><%=EmployeeName%></b>',
           width: 120,
           sortable: true,
           dataIndex: 'employeeNameDataIndex'
       }, {
           header: '<b><%=EmployeeType%></b>',
           width: 120,
           sortable: true,
           dataIndex: 'employeeTypeDataIndex'
       }, {
           header: '<b><%=DriverId%></b>',
           width: 120,
           hidden: true,
           dataIndex: 'DriverIdDataIndex'
       }
   ]);
   var reader1 = new Ext.data.JsonReader({
       root: 'driverNameRoot',
       fields: [{
           name: 'slnoIndex'
       }, {
           name: 'driverNameDataIndex',
           type: 'string'
       }, {
           name: 'employeeNameDataIndex',
           type: 'string'
       }, {
           name: 'employeeTypeDataIndex',
           type: 'string'
       }, {
           name: 'employeeTypeIDDataIndex',
           type: 'string'
       }, {
           name: 'DriverIdDataIndex',
           type: 'int'
       }, {
           name: 'lastNameDataIndex',
           type: 'string'
       }, {
           name: 'presentAddressDataIndex',
           type: 'string'
       }, {
           name: 'permanentAddressDataIndex',
           type: 'string'
       }, {
           name: 'cityDataIndex',
           type: 'string'
       }, {
           name: 'otherCityDataIndex',
           type: 'string'
       }, {
           name: 'stateDataIndex',
           type: 'string'
       }, {
           name: 'countryDataIndex',
           type: 'string'
       }, {
           name: 'telephoneDataIndex',
           type: 'string'
       }, {
           name: 'mobileDataIndex',
           type: 'string'
       }, {
           name: 'dateOfBirthDataIndex',
           type: 'string'
       }, {
           name: 'genderDataIndex',
           type: 'string'
       }, {
           name: 'nationalityDataIndex',
           type: 'string'
       }, {
           name: 'maritialDataIndex',
           type: 'string'
       }, {
           name: 'employmentTypeDataIndex',
           type: 'string'
       }, {
           name: 'employmentIdDataIndex',
           type: 'string'
       }, {
           name: 'dateOfJoiningDataIndex',
           type: 'string'
       }, {
           name: 'dateOfLeavingDataIndex',
           type: 'string'
       }, {
           name: 'bloodGroupDataIndex',
           type: 'string'
       }, {
           name: 'groupNameDataIndex',
           type: 'string'
       }, {
           name: 'activeStatusDataIndex',
           type: 'string'
       }, {
           name: 'remarksDataIndex',
           type: 'string'
       }, {
           name: 'governmentOrResidenceIdDataIndex',
           type: 'string'
       }, {
           name: 'governmentOrResidenceIdExpiryDateDataIndex',
           type: 'string'
       }, {
           name: 'rfidCodeDataIndex',
           type: 'string'
       }, {
           name: 'medicalInsuranceDataIndex',
           type: 'string'
       }, {
           name: 'medicalInsuranceCompanyDataIndex',
           type: 'string'
       }, {
           name: 'medicalInsuranceExpiryDateDataIndex',
           type: 'string'
       }, {
           name: 'licenseNoDataIndex',
           type: 'string'
       }, {
           name: 'licencePlaceDataIndex',
           type: 'string'
       }, {
           name: 'licenceIssueDateDataIndex',
           type: 'string'
       }, {
           name: 'licenceRewenedDateDataIndex',
           type: 'string'
       }, {
           name: 'preferedCompanyLabelDataIndex',
           type: 'string'
       }, {
           name: 'licenceExpiryDateDataIndex',
           type: 'string'
       }, {
           name: 'gunLicenceNoDataIndex',
           type: 'string'
       }, {
           name: 'gunLicenceTypeDataIndex',
           type: 'string'
       }, {
           name: 'gunLicenceIssueDateDataIndex',
           type: 'string'
       }, {
           name: 'gunLicenceIssuePlaceDataIndex',
           type: 'string'
       }, {
           name: 'gunLicenceExpiryDateDataIndex',
           type: 'string'
       }, {
           name: 'stateIdDataIndex',
           type: 'int'
       }, {
           name: 'countryIdDataIndex',
           type: 'int'
       }, {
           name: 'groupIdDataIndex',
           type: 'int'
       }, {
           name: 'passportNumberDataIndex',
           type: 'string'
       }, {
           name: 'expiryDateDataIndexforPersonalInformation',
           type: 'string'
       }, {
           name: 'workCompensationIdDataIndex',
           type: 'string'
       }, {
           name: 'workCompensationExpiryDateDataIndex',
           type: 'string'
       }]
   });
   var filters1 = new Ext.ux.grid.GridFilters({
       local: true,
       filters: [{
           type: 'numeric',
           dataIndex: 'slnoIndex'
       }, {
           dataIndex: 'employeeNameDataIndex',
           type: 'string'
       }, {
           dataIndex: 'employeeTypeDataIndex',
           type: 'string'
       }, {
           dataIndex: 'DriverIdDataIndex',
           type: 'int'
       }]
   });
   var firstGridStoreForDriverName = new Ext.data.Store({
       url: '<%=request.getContextPath()%>/CrewMasterDataAction.do?param=getDriverNames',
       bufferSize: 367,
       reader: reader1,
       autoLoad: false,
       remoteSort: true
   });

   function onCellClickOnGrid(firstGridToGetDriverName, rowIndex, columnIndex, e) {
       if (firstGridToGetDriverName.getSelectionModel().getCount() == 1) {
           var selected = firstGridToGetDriverName.getSelectionModel().getSelected();
           driverId = selected.get('DriverIdDataIndex');
<!--           if (selected.get('employeeTypeDataIndex') == "DRIVER" || selected.get('employeeTypeDataIndex') == "CLEANER" || selected.get('employeeTypeDataIndex') == "OPERATOR" || selected.get('employeeTypeDataIndex') == "ESCORTS" || selected.get('employeeTypeDataIndex') == "SITE ENGINEERS" ||  && selected.get('employeeTypeDataIndex') != "GUNMAN"){-->
<!--               editOuterPanelWindowF0rGun.hide();-->
<!--           } else {-->
<!--               editOuterPanelWindowF0rGun.show();-->
<!--           }-->
    
           if (selected.get('employeeTypeDataIndex') == "GUNMAN") {
          
           editOuterPanelWindowF0rGun.show();
               editOuterPanelWindowF0rDriver.hide();
           } else {
               editOuterPanelWindowF0rDriver.show();
               editOuterPanelWindowF0rGun.hide();
           }
            if (selected.get('employeeTypeDataIndex') == "CUSTODIAN") {
Ext.getCmp('preferedCompanyLabelId').show();
Ext.getCmp('preferedCompany').show();
driverInformationPanel.setTitle('<%=CustodianInformation%>');
Ext.getCmp('mandatorypreferedCompanyId').show();
Ext.getCmp('preferedCompanyId').show();
Ext.getCmp('customerGridId').show();
Ext.getCmp('mandatorylicenceExpiryDateId').hide();
Ext.getCmp('mandatoryLicenceId').hide();

customercheckstore.load({
                       params: {
                           CustId: Ext.getCmp('custcomboId').getValue()
                       }
                   });
   }  else{
   		Ext.getCmp('mandatorylicenceExpiryDateId').show();
Ext.getCmp('mandatoryLicenceId').show();
           Ext.getCmp('preferedCompanyLabelId').hide();
           Ext.getCmp('preferedCompany').hide();
          driverInformationPanel.setTitle('<%=CrewInformation%>');
          Ext.getCmp('mandatorypreferedCompanyId').hide();
Ext.getCmp('preferedCompanyId').hide();
Ext.getCmp('customerGridId').hide();
   } 
           Ext.getCmp('labelnameId').setText(selected.get('driverNameDataIndex'));
           Ext.getCmp('labellastNameId').setText(selected.get('lastNameDataIndex'));
           Ext.getCmp('labeladdressId').setText(selected.get('presentAddressDataIndex'));
           Ext.getCmp('labelpermanentAddressId').setText(selected.get('permanentAddressDataIndex'));
           Ext.getCmp('labelcityId').setText(selected.get('cityDataIndex'));
           Ext.getCmp('labelotherCityId').setText(selected.get('otherCityDataIndex'));
           Ext.getCmp('labelstatelabelId').setText(selected.get('stateDataIndex'));
           Ext.getCmp('labelcountrylabelId').setText(selected.get('countryDataIndex'));
           Ext.getCmp('labeltelephoneId').setText(selected.get('telephoneDataIndex'));
           Ext.getCmp('labelmobileId').setText(selected.get('mobileDataIndex'));
           Ext.getCmp('labeldateOfBirthId').setText(selected.get('dateOfBirthDataIndex'));
           Ext.getCmp('labelgenderLabelId').setText(selected.get('genderDataIndex'));
           Ext.getCmp('labelnationalityId').setText(selected.get('nationalityDataIndex'));
           Ext.getCmp('labelmaritialStatusLabelId').setText(selected.get('maritialDataIndex'));
           Ext.getCmp('employnemntLabelTypeId').setText(selected.get('employmentTypeDataIndex'));
           Ext.getCmp('employmeeLabelId').setText(selected.get('employmentIdDataIndex'));
           Ext.getCmp('dateOfJoiningLabelId').setText(selected.get('dateOfJoiningDataIndex'));
           Ext.getCmp('dateOfLeavingLabelId').setText(selected.get('dateOfLeavingDataIndex'));
           Ext.getCmp('bloodGroupLabelId').setText(selected.get('bloodGroupDataIndex'));
           Ext.getCmp('groupNameLabelId').setText(selected.get('groupNameDataIndex'));
           Ext.getCmp('activeStatusLabelId').setText(selected.get('activeStatusDataIndex'));
           Ext.getCmp('remarksLabelId').setText(selected.get('remarksDataIndex'));
           Ext.getCmp('governmentLabelId').setText(selected.get('governmentOrResidenceIdDataIndex'));
           Ext.getCmp('governmentExpiryLabelId').setText(selected.get('governmentOrResidenceIdExpiryDateDataIndex'));
           Ext.getCmp('rfidLabelId').setText(selected.get('rfidCodeDataIndex'));
           Ext.getCmp('medicalInsuranceLabelId').setText(selected.get('medicalInsuranceDataIndex'));
           Ext.getCmp('medicalInsuranceCompanyLabelId').setText(selected.get('medicalInsuranceCompanyDataIndex'));
           Ext.getCmp('MedicalInsuranceExpiryId').setText(selected.get('medicalInsuranceExpiryDateDataIndex'));
           Ext.getCmp('licenceNoLabelId').setText(selected.get('licenseNoDataIndex'));
           Ext.getCmp('licencePlaceLabelId').setText(selected.get('licencePlaceDataIndex'));
           Ext.getCmp('licenceIssueDateLabelId').setText(selected.get('licenceIssueDateDataIndex'));
           Ext.getCmp('licenceRenewedDateLabelId').setText(selected.get('licenceRewenedDateDataIndex'));
           Ext.getCmp('preferedCompanyLabelId').setText(selected.get('preferedCompanyLabelDataIndex'));          
           Ext.getCmp('licenceExpiryDateLabelId').setText(selected.get('licenceExpiryDateDataIndex'));
           Ext.getCmp('gunGicenceNoLabelId').setText(selected.get('gunLicenceNoDataIndex'));
           Ext.getCmp('gunLicenceTypeLabelId').setText(selected.get('gunLicenceTypeDataIndex'));
           Ext.getCmp('gunLicenceIssueDateLabelId').setText(selected.get('gunLicenceIssueDateDataIndex'));
           Ext.getCmp('gunLicenceIssuePlaceLabelId').setText(selected.get('gunLicenceIssuePlaceDataIndex'));
           Ext.getCmp('gunLicenceExpiryDateLabelId').setText(selected.get('gunLicenceExpiryDateDataIndex'));
           
          Ext.getCmp('PassportNumberIdForEditPanelLabel').setText(selected.get('passportNumberDataIndex'));
          Ext.getCmp('expiryDateIdForEditPanelLabel').setText(selected.get('expiryDateDataIndexforPersonalInformation'));
          Ext.getCmp('WorkManCompensationLabelId').setText(selected.get('workCompensationIdDataIndex'));
          Ext.getCmp('expiryDateIdForWorkManCompensationLabelId').setText(selected.get('workCompensationExpiryDateDataIndex'));
       }
   }
    //*******************************************************POPUP FOR PERSONAL INFORMATION*************************************************************//
   var firstGridToGetDriverName = new Ext.grid.GridPanel({
       // title: 'Crew Details',
       id: 'firstGrid',
       ds: firstGridStoreForDriverName,
       frame: true,
       cm: cols1,
       view: new Ext.grid.GridView({
           nearLimit: 2
       }),
       plugins: [filters1],
       stripeRows: true,
       height: 435,
       width: 300,
       autoScroll: true,
       tbar: [{
           xtype: 'button',
           frame: true,
           text: '<b><%=AddCrew%></b>',
           cls: 'buttonstyleforcrew',
           handler: function () {
               addCrewPersonalInformation();
           }
       }]
   });
   var innerPanelForPersonalCrewMaster = new Ext.Panel({
       standardSubmit: true,
       collapsible: false,
       autoScroll: true,
       height: 222,
       width: 455,
       frame: true,
       id: 'crewId',
       layout: 'table',
       layoutConfig: {
           columns: 4
       },
       items: [{
           xtype: 'fieldset',
           title: '<%=CrewInformation%>',
           cls: 'fieldsetpanel',
           collapsible: false,
           colspan: 3,
           id: 'addCrewid',
           width: 420,
           height: 550,
           layout: 'table',
           layoutConfig: {
               columns: 3,
               tableAttrs: {
		            style: {
		                width: '93%'
		            }
        			}
           },
           items: [{
                   xtype: 'label',
                   text: '*',
                   cls: 'mandatoryfield',
                   id: 'mandatoryFirstNameId1'
               },{
                   xtype: 'label',
                   text: '<%=FirstName%>' + ' :',
                   cls: 'labelstyle',
                   id: 'firstId1'
               },  {
                   xtype: 'textfield',
                   cls: 'selectstylePerfect',
                   regex: validate('alphanumericname'),
                   emptyText: '<%=EnterFirstName%>',
                   allowBlank: false,
                   blankText: '<%=EnterFirstName%>',
                   id: 'nameId2'
               }, {
                   xtype: 'label',
                   text: '',
                   cls: 'mandatoryfield',
                   id: 'mandatorylastNameId1'
               },{
                   xtype: 'label',
                   text: '<%=LastName%>' + ' :',
                   cls: 'labelstyle',
                   id: 'lastnameId2'
               }, {
                   xtype: 'textfield',
                   cls: 'selectstylePerfect',
                   regex: validate('alphanumericname'),
                   emptyText: '<%=EnterLastName%>',
                   allowBlank: false,
                   blankText: '<%=EnterLastName%>',
                   id: 'lastNameId2'
               },{
                   xtype: 'label',
                   text: '',
                   cls: 'mandatoryfield',
                   id: 'mandatoryAddressId2'
               }, {
                   xtype: 'label',
                   text: '<%=Address%>' + ' :',
                   cls: 'labelstyle',
                   id: 'addressId22'
               },  {
                   xtype: 'textarea',
                   width: 50,
                   height: 60,
                   cls: 'selectstylePerfect',
                   emptyText: '<%=EnterAddress%>',
                   allowBlank: false,
                   autoCreate: { //restricts user to enter only 52 chars max
                       tag: "input",
                       maxlength: 50,
                       type: "text",
                       size: "200",
                       autocomplete: "off"
                   },
                   blankText: '<%=EnterAddress%>',
                   id: 'addressId2'
               },{
                   xtype: 'label',
                   text: '',
                   cls: 'mandatoryfield',
                   id: 'mandatoryPermanentAddressId'
               },  {
                   xtype: 'label',
                   text: '<%=PermanentAddress%>' + ' :',
                   cls: 'labelstyle',
                   id: 'permanentAddress22'
               }, {
                   xtype: 'textarea',
                   width: 50,
                   height: 60,
                   cls: 'selectstylePerfect',
                   emptyText: '<%=EnterPermanentAddress%>',
                   allowBlank: false,
                   autoCreate: { //restricts user to enter only 52 chars max
                       tag: "input",
                       maxlength: 50,
                       type: "text",
                       size: "200",
                       autocomplete: "off"
                   },
                   blankText: '<%=EnterPermanentAddress%>',
                   id: 'permanentAddressId2'
               }, {
                   xtype: 'label',
                   text: '',
                   cls: 'mandatoryfield',
                   id: 'mandatoryCityId2'
               },  {
                   xtype: 'label',
                   text: '<%=City%>' + ' :',
                   cls: 'labelstyle',
                   id: 'city22'
               },{
                   xtype: 'textfield',
                   cls: 'selectstylePerfect',
                   regex: validate('alphanumericname'),
                   emptyText: '<%=EnterCity%>',
                   allowBlank: false,
                   blankText: '<%=EnterCity%>',
                   id: 'cityId2'
               }, {
                   xtype: 'label',
                   text: '',
                   cls: 'mandatoryfield',
                   id: 'mandatoryOtherCityId2'
               },  {
                   xtype: 'label',
                   text: '<%=OtherCity%>' + ' :',
                   cls: 'labelstyle',
                   id: 'otherCity22'
               },{
                   xtype: 'textfield',
                   cls: 'selectstylePerfect',
                   regex: validate('alphanumericname'),
                   emptyText: '<%=EnterOtherCity%>',
                   allowBlank: false,
                   blankText: '<%=EnterOtherCity%>',
                   id: 'otherCityId2'
               },{
                   xtype: 'label',
                   text: '',
                   cls: 'mandatoryfield',
                   id: 'mandatoryCountryId2'
               },{
                   xtype: 'label',
                   text: '<%=Country%>' + ' :',
                   cls: 'labelstyle',
                   id: 'country22'
               }, 
               countrycombo,
               {
                   xtype: 'label',
                   text: '',
                   cls: 'mandatoryfield',
                   id: 'mandatoryStateId2'
               },
                {
                   xtype: 'label',
                   text: '<%=State%>' + ' :',
                   cls: 'labelstyle',
                   id: 'state22'
               }, 
               statecombo,
                {
                   xtype: 'label',
                   text: '',
                   cls: 'mandatoryfield',
                   id: 'mandatoryTelephoneId2'
               },
                {
                   xtype: 'label',
                   text: '<%=TelephoneNo%>  :',
                   cls: 'labelstyle',
                   id: 'telephoneNo22'
               }, {
                   xtype: 'numberfield',
                   allowDecimals: false,
                   cls: 'selectstylePerfect',
                   maxLength: 20,
                   emptyText: '<%=EnterTelephoneNo%>',
                   blankText: '<%=EnterTelephoneNo%>',
                   id: 'telephoneId2'
               },  {
                   xtype: 'label',
                   text: '',
                   cls: 'mandatoryfield',
                   id: 'mandatoryMobileId2'
               }, {
                   xtype: 'label',
                   text: '<%=MobileNo%>  :',
                   cls: 'labelstyle',
                   id: 'mobileNo22'
               }, {
                   xtype: 'numberfield',
                   allowDecimals: false,
                   cls: 'selectstylePerfect',
                   maxLength: 20,
                   emptyText: '<%=EnterMobileNo%>',
                   blankText: '<%=EnterMobileNo%>',
                   id: 'mobileId2'
               }, {
                   xtype: 'label',
                   text: '',
                   cls: 'mandatoryfield',
                   id: 'mandatoryDateOfBirthId2'
               }, {
                   xtype: 'label',
                   text: '<%=DateOfBirth%>' + ' :',
                   cls: 'labelstyle',
                   id: 'dateOfBirth22'
               }, {
                   xtype: 'datefield',
                   cls: 'selectstylePerfect',
                   allowBlank: false,
                   value: dtcur,
                   format: getDateFormat(),
                   allowBlank: false,
                   id: 'dateOfBirthId2'
               }, {
                   xtype: 'label',
                   text: '',
                   cls: 'mandatoryfield',
                   id: 'mandatoryGenderId2'
               },{
                   xtype: 'label',
                   text: '<%=Gender%>' + ' :',
                   cls: 'labelstyle',
                   id: 'gender22'
               },
               genderCombo, 
               {
                   xtype: 'label',
                   text: '',
                   cls: 'mandatoryfield',
                   id: 'mandatoryNationalityId2'
               }, 
                {
                   xtype: 'label',
                   text: '<%=Nationality%>' + ' :',
                   cls: 'labelstyle',
                   id: 'nationality22'
               }, {
                   xtype: 'textfield',
                   cls: 'selectstylePerfect',
                   regex: validate('alphanumericname'),
                   emptyText: '<%=EnterNationality%>',
                   allowBlank: false,
                   blankText: '<%=EnterNationality%>',
                   id: 'nationalityId2'
               },{
                   xtype: 'label',
                   text: '',
                   cls: 'mandatoryfield',
                   id: 'mandatoryMaritialId2'
               }, {
                   xtype: 'label',
                   text: '<%=MartialStatus%>' + ' :',
                   cls: 'labelstyle',
                   id: 'martialStatus22'
               }, 
               maritialCombo, 
                {
                   xtype: 'label',
                   text: '',
                   cls: 'mandatoryfield',
                   id: 'mandatorypassportNumberIdForInnerPanelInCrewButtonInPersonalInformationId'
               },
               {
                   xtype: 'label',
                   text: '<%=PassportNumber%>' + ' :',
                   cls: 'labelstyle',
                   id: 'passportNumberIdForInnerPanelInCrewButtonPersonalInformation'
               }, {
                   xtype: 'textfield',
                   cls: 'selectstylePerfect',
                   emptyText: '<%=EnterPassportNumber%>',
                   allowBlank: false,
                   blankText: '<%=EnterPassportNumber%>',
                   id: 'passportNumberIdForInnerPanelInCrewButtonInPersonalInformationTextField'
               },{
                   xtype: 'label',
                   text: '',
                   cls: 'mandatoryfield',
                   id: 'mandatoryExpiryDateForInnerPanelInCrewButtonInPersonalInformationId'
               },  {
                   xtype: 'label',
                   text: '<%=PassportNumberExpiryDate%>' + ' :',
                   cls: 'labelstyle',
                   id: 'ExpiryDateIdForInnerPanelInCrewButtonInPersonalInformation'
               }, {
                   xtype: 'datefield',
                   cls: 'selectstylePerfect',
                   allowBlank: false,
                   value: dtcur,
                   format: getDateFormat(),
                   id: 'expiryDateForInnerPanelInCrewButtonInPersonalInformationTextField'
               }
			   
	
           ]
       }]
   });
   
                            
   var innerWinButtonPanelForAddCrew = new Ext.Panel({
       id: 'winbuttonidForAddCrewSaveAndNextButton',
       standardSubmit: true,
       collapsible: false,
       autoHeight: true,
       height: 110,
       width: 460,
       frame: true,
       layout: 'table',
       layoutConfig: {
           columns: 4
       },
       buttons: [{
           xtype: 'button',
           text: '<%=Cancel%>',
           id: 'addCrewPersonalInformationcanButtId',
           cls: 'buttonstyle',
           iconCls: 'cancelbutton',
           width: 70,
           listeners: {
               click: {
                   fn: function () {
                       addCrewmyWin.hide();
                   }
               }
           }
       }, {
           xtype: 'button',
           text: '<%=Next%>',
           id: 'crewnextButtId',
           cls: 'buttonstyle',
           iconCls: 'nextbutton',
           width: 70,
           listeners: {
               click: {
                   fn: function () {
                       if (Ext.getCmp('nameId2').getValue() == "") {
                           Ext.example.msg("<%=EnterFirstName%>");
                           return;
                       }
                       //outerPanel.getEl().unmask();  
                       //lidAndValvePanel.getEl().unmask(); 
                       AddcrewEmployeeInformation();
                       addCrewmyWin.hide();
                   }
               }
           }
       }]
   });
   var PersonalInfocrewMasterOuterPanelWindow = new Ext.Panel({
       width: 460,
       height: 330,
       standardSubmit: true,
       frame: true,
       items: [innerPanelForPersonalCrewMaster, innerWinButtonPanelForAddCrew]
   });
   addCrewmyWin = new Ext.Window({
       title: titelForInnerPanel,
       closable: false,
       resizable: false,
       modal: true,
       autoScroll: false,
       height: 330,
       width: 470,
       id: 'myWinAddCrew',
       items: [PersonalInfocrewMasterOuterPanelWindow]
   });

   function addCrewPersonalInformation() {
       if (Ext.getCmp('custcomboId').getValue() == "") {
           Ext.example.msg("<%=SelectCustomerName%>");
           return;
       }
       buttonValue = '<%=AddCrew%>';
       titelForCrewInnerPanel = '<%=CrewDetails%>';
       addCrewmyWin.setPosition(450, 150);
       addCrewmyWin.show();
       addCrewmyWin.setTitle(titelForCrewInnerPanel);
       driverId = 0;
       Ext.getCmp('crewgunLicenceId1').reset();
       Ext.getCmp('crewgunLicenceTypeId1').reset();
       Ext.getCmp('crewgunLicenceIssueDateId1').reset();
       Ext.getCmp('crewgunLicenceIssuePlaceId1').reset();
       Ext.getCmp('crewgunLicenceExpiryDateId1').reset();
       Ext.getCmp('employmentTypeComboId').reset();
       Ext.getCmp('employmeeIdCrew2').reset();
       Ext.getCmp('clientIdCrew2').reset();
       Ext.getCmp('dateOfJoiningIdCrew2').reset();
       Ext.getCmp('dateOfLeavingIdCrew2').reset();
       Ext.getCmp('bloodGroupIdCrew2').reset();
       Ext.getCmp('groupNameComboId').reset();
       //Ext.getCmp('statuscomboId').reset(),
       Ext.getCmp('remarksIdCrew2').reset();
       Ext.getCmp('governmentIdCrew2').reset();
       Ext.getCmp('governmentexpiryIdCrew2').reset();
       Ext.getCmp('rfidIdCrew2').reset();
       Ext.getCmp('nameId2').reset();
       Ext.getCmp('lastNameId2').reset();
       Ext.getCmp('addressId2').reset();
       Ext.getCmp('permanentAddressId2').reset();
       Ext.getCmp('cityId2').reset();
       Ext.getCmp('otherCityId2').reset();
       Ext.getCmp('statecomboId').reset();
       Ext.getCmp('countryId').reset();
       Ext.getCmp('telephoneId2').reset();
       Ext.getCmp('mobileId2').reset();
       Ext.getCmp('dateOfBirthId2').reset();
       Ext.getCmp('genderComboId').reset();
       Ext.getCmp('nationalityId2').reset();
       Ext.getCmp('maritialComboId').reset();
       Ext.getCmp('crewmedicalInsuranceId1').reset();
       Ext.getCmp('crewmedicalInsuranceCompanyId1').reset();
       Ext.getCmp('crewMedicalInsuranceExpiryDateId1').reset();
       Ext.getCmp('crewlicenceId1').reset();
       Ext.getCmp('crewlicencePlaceId1').reset();
       Ext.getCmp('crewlicenceIssueDateId1').reset();
       Ext.getCmp('crewlicenceRenewedDateId1').reset();
       Ext.getCmp('crewlicenceExpiryDateId').reset();
       
       Ext.getCmp('expiryDateForInnerPanelInCrewButtonInPersonalInformationTextField').reset();
       Ext.getCmp('passportNumberIdForInnerPanelInCrewButtonInPersonalInformationTextField').reset();
       Ext.getCmp('workmanCompensationIdforInnerPanelCrewButtonTextField').reset();
       Ext.getCmp('expiryDateWorkmanCompensationIdforInnerPanelCrewButtonTextField').reset();
       firstGridStoreForDriverName.load({
           params: {
               CustId: Ext.getCmp('custcomboId').getValue(),
               CustName: custName
           }
       });
   }
    //**********************************************8ADD CREW FOR EMPLOYEE INFORMATION*****************************************************************//  
   var innerPanelForAddCrewEmploymentInformation = new Ext.Panel({
       standardSubmit: true,
       collapsible: false,
       autoScroll: true,
       height: 260,
       width: 510,
       frame: false,
       id: 'addCrewEmploymentInfoId',
       layout: 'table',
       layoutConfig: {
           columns: 4
       },
       items: [{
           xtype: 'fieldset',
           title: '<%=EmploymentInformation%>',
           cls: 'fieldsetpanel',
           collapsible: false,
           colspan: 3,
           id: 'CrewEmploymentpanelid',
           width: 490,
           height: 460,
           layout: 'table',
           layoutConfig: {
               columns: 3,
               tableAttrs: {
		            style: {
		                width: '95%'
		            }
        			}
           },
           items: [{
                   xtype: 'label',
                   text: '*',
                   cls: 'mandatoryfield',
                   id: 'mandatoryemploymentIdCrew2'
               },{
                   xtype: 'label',
                   text: '<%=EmploymentType%>' + ' :',
                   cls: 'labelstyle',
                   id: 'employmentcrew1'
               }, 
               employmentTypeCombo,
               {
                   xtype: 'label',
                   text: '*',
                   cls: 'mandatoryfield',
                   id: 'mandatoryEmployeeIdIdCrew2'
               }, 
                {
                   xtype: 'label',
                   text: '<%=EmploymentID%>' + ' :',
                   cls: 'labelstyle',
                   id: 'employeeCrew2'
               }, {
                   xtype: 'textfield',
                   cls: 'selectstylePerfect',
                   regex: validate('alphanumericname'),
                   emptyText: '<%=EnterEmploymentId%>',
                   allowBlank: false,
                   blankText: '<%=EnterEmploymentId%>',
                   id: 'employmeeIdCrew2'
               },
               {
                   xtype: 'label',
                   text: '',
                   cls: 'mandatoryfield',
                   id: 'mandatoryClientIdCrew2'
               }, {
                   xtype: 'label',
                   text: '<%=Client%>' + ' :',
                   cls: 'labelstyle',
                   id: 'clientCrew2'
               },  {
                   xtype: 'textfield',
                   cls: 'selectstylePerfect',
                   regex: validate('alphanumericname'),
                   emptyText: '<%=EnterClient%>',
                   allowBlank: false,
                   blankText: '<%=EnterClient%>',
                   id: 'clientIdCrew2'
               }, {
                   xtype: 'label',
                   text: '',
                   cls: 'mandatoryfield',
                   id: 'mandatoryJoiningIdCrew2'
               },{
                   xtype: 'label',
                   text: '<%=DateOfJoining%>' + ' :',
                   cls: 'labelstyle',
                   id: 'dateOfJoiningCrew2'
               },  {
                   xtype: 'datefield',
                   cls: 'selectstylePerfect',
                   emptyText: '<%=EnterDateOfJoining%>',
                   allowBlank: false,
                   value: dtcur,
                   format: getDateFormat(),
                   blankText: '<%=EnterDateOfJoining%>',
                   id: 'dateOfJoiningIdCrew2'
               },{
                   xtype: 'label',
                   text: '',
                   cls: 'mandatoryfield',
                   id: 'mandatoryLeavingIdCrew2'
               }, {
                   xtype: 'label',
                   text: '<%=DateOfLeaving%>' + ' :',
                   cls: 'labelstyle',
                   id: 'dateOfLeavingCrew2'
               }, {
                   xtype: 'datefield',
                   cls: 'selectstylePerfect',
                   allowBlank: false,
                   value: dtcur,
                   format: getDateFormat(),
                   allowBlank: false,
                   id: 'dateOfLeavingIdCrew2'
               },{
                   xtype: 'label',
                   text: '',
                   cls: 'mandatoryfield',
                   id: 'mandatoryBloodIdCrew2'
               }, {
                   xtype: 'label',
                   text: '<%=BloodGroup%>' + ' :',
                   cls: 'labelstyle',
                   id: 'bloodGroupCrew2'
               }, {
                   xtype: 'textfield',
                   cls: 'selectstylePerfect',
                   emptyText: '<%=EnterBloodGroup%>',
                   allowBlank: false,
                   blankText: '<%=EnterBloodGroup%>',
                   id: 'bloodGroupIdCrew2'
               },{
                   xtype: 'label',
                   text: '',
                   cls: 'mandatoryfield',
                   id: 'mandatoryGroupIdCrew2'
               },  {
                   xtype: 'label',
                   text: '<%=GroupName%>' + ' :',
                   cls: 'labelstyle',
                   id: 'GroupNameCrew2'
               }, 
               groupNameCombo, 
               {
                   xtype: 'label',
                   text: '',
                   cls: 'mandatoryfield',
                   id: 'mandatoryActiveStatusIdCrew2'
               },
                {
                   xtype: 'label',
                   text: '<%=ActiveStatus%>' + ' :',
                   cls: 'labelstyle',
                   id: 'activeStatusCrew2'
               }, 
               statuscombo,
                {
                   xtype: 'label',
                   text: '',
                   cls: 'mandatoryfield',
                   id: 'mandatoryRemarksIdCrew2'
               },
                {
                   xtype: 'label',
                   text: '<%=Remarks%>' + ' :',
                   cls: 'labelstyle',
                   id: 'remarksCrew2'
               }, {
                   xtype: 'textarea',
                   width: 50,
                   height: 60,
                   cls: 'selectstylePerfect',
                   regex: validate('alphanumericname'),
                   emptyText: '<%=EnterRemarks%>',
                   allowBlank: false,
                   autoCreate: { //restricts user to enter only 50 chars max
                       tag: "input",
                       maxlength: 45,
                       type: "text",
                       size: "200",
                       autocomplete: "off"
                   },
                   blankText: '<%=EnterRemarks%>',
                   id: 'remarksIdCrew2'
               },
               {
                   xtype: 'label',
                   text: '',
                   cls: 'mandatoryfield',
                   id: 'mandatoryGovernmentIdCrew2'
               }, {
                   xtype: 'label',
                   text: '<%=GovernmentorResidenceID%>' + ' :',
                   cls: 'labelstyle',
                   id: 'governmentCrew2'
               },  {
                   xtype: 'textfield',
                   cls: 'selectstylePerfect',
                   regex: validate('alphanumericname'),
                   emptyText: '<%=EnterGovernmentorResidenceId%>',
                   allowBlank: false,
                   blankText: '<%=EnterGovernmentorResidenceId%>',
                   id: 'governmentIdCrew2'
               },{
                   xtype: 'label',
                   text: '',
                   cls: 'mandatoryfield',
                   id: 'mandatorygovernmentexpiryIdCrew2'
               },  {
                   xtype: 'label',
                   text: '<%=GovernmentorResidenceIDExpiryDate%>' + ' :',
                   cls: 'labelstyle',
                   id: 'governmentexpiryCrew2'
               }, {
                   xtype: 'datefield',
                   cls: 'selectstylePerfect',
                   allowBlank: false,
                   value: dtcur,
                   format: getDateFormat(),
                   allowBlank: false,
                   id: 'governmentexpiryIdCrew2'
               }, {
                   xtype: 'label',
                   text: '',
                   cls: 'mandatoryfield',
                   id: 'mandatoryrfidIdCrew2'
               },{
                   xtype: 'label',
                   text: '<%=EmployeeUniqueCode%>' + ' :',
                   cls: 'labelstyle',
                   id: 'rfidCrew2'
               },  {
                   xtype: 'textfield',
                   cls: 'selectstylePerfect',
                   regex: validate('alphanumericname'),
                   emptyText: '<%=EnterEmployeeUniqueCode%>',
                   allowBlank: false,
                   blankText: '<%=EnterEmployeeUniqueCode%>',
                   id: 'rfidIdCrew2'
               }, {
                   xtype: 'label',
                   text: '',
                   cls: 'mandatoryfield',
                   id: 'mandatoryWorkmanCompensationIdforInnerPanelCrewButton'
               },{
                   xtype: 'label',
                   text: '<%=WorkmanCompensationId%>' + ' :',
                   cls: 'labelstyle',
                   id: 'workmanCompensationIdforInnerPanelCrewButton'
               },  {
                   xtype: 'textfield',
                   cls: 'selectstylePerfect',
                   emptyText: '<%=EnterWorkmanCompensationId%>',
                   allowBlank: false,
                   blankText: '<%=EnterWorkmanCompensationId%>',
                   id: 'workmanCompensationIdforInnerPanelCrewButtonTextField'
               },{
                   xtype: 'label',
                   text: '',
                   cls: 'mandatoryfield',
                   id: 'mandatoryExpiryDateWorkmanCompensationIdforInnerPanelCrewButton'
               }, {
                   xtype: 'label',
                   text: '<%=WorkmanCompensationExpiryDate%>' + ' :',
                   cls: 'labelstyle',
                   id: 'expiryDateWorkmanCompensationIdforInnerPanelCrewButton'
               },  {
                   xtype: 'datefield',
                   cls: 'selectstylePerfect',
                   value: dtcur,
                   format: getDateFormat(),
                   id: 'expiryDateWorkmanCompensationIdforInnerPanelCrewButtonTextField'
               }]
       }]
   });
      
   var innerWinButtonPanelForEmployment = new Ext.Panel({
       id: 'crewEmployeewinbuttonid',
       standardSubmit: true,
       collapsible: false,
       autoHeight: true,
       height: 110,
       width: 510,
       frame: true,
       layout: 'table',
       layoutConfig: {
           columns: 4
       },
       buttons: [{
           xtype: 'button',
           text: '<%=Cancel%>',
           id: 'CrewemployeecanButtId',
           cls: 'buttonstyle',
           iconCls: 'cancelbutton',
           width: 70,
           listeners: {
               click: {
                   fn: function () {
                       CrewmyWinForEmployee.hide();
                       addCrewmyWin.hide();
                   }
               }
           }
       }, {
           xtype: 'button',
           text: '<%=Next%>',
           id: 'crewInsurancenextButtId',
           cls: 'buttonstyle',
           iconCls: 'nextbutton',
           width: 70,
           listeners: {
               click: {
                   fn: function () {
                       if (Ext.getCmp('employmentTypeComboId').getValue() == "") {
                           Ext.example.msg("<%=EnterEmploymentType%>");
                           return;
                       }
                       if (Ext.getCmp('employmeeIdCrew2').getValue() == "") {
                           Ext.example.msg("<%=EnterEmploymentId%>");
                           return;
                       }
                       //outerPanel.getEl().unmask(); 
                       crewinsuranceInformation();
                       CrewmyWinForEmployee.hide();
                   }
               }
           }
       }]
   });
   var CrewemploymentInformationOuterPanelWindow = new Ext.Panel({
       width: 530,
       height: 330,
       standardSubmit: true,
       frame: true,
       items: [innerPanelForAddCrewEmploymentInformation, innerWinButtonPanelForEmployment]
   });
   CrewmyWinForEmployee = new Ext.Window({
       title: CrewtitelForEmployeePanel,
       closable: false,
       resizable: false,
       modal: true,
       autoScroll: false,
       height: 360,
       width: 540,
       id: 'CrewmyWinEmployee',
       items: [CrewemploymentInformationOuterPanelWindow]
   });

   function AddcrewEmployeeInformation() {
       if (Ext.getCmp('custcomboId').getValue() == "") {
           Ext.example.msg("<%=SelectCustomerName%>");
           return;
       }
       buttonValue = 'Next';
       CrewtitelForEmployeePanel = '<%=CrewEmployeeInformationDetails%>';
       CrewmyWinForEmployee.setPosition(450, 150);
       CrewmyWinForEmployee.show();
       CrewmyWinForEmployee.setTitle(CrewtitelForEmployeePanel);
       custName = Ext.getCmp('custcomboId').getRawValue();
       Ext.getCmp('clientIdCrew2').setValue(custName);
       Ext.getCmp('clientIdCrew2').disable();
   }
    //****************************************************************POPUP FOR ADD CREW INSURANCE **************************************************************//  
   var crewInnerPanelForInsuranceInformation = new Ext.Panel({
       standardSubmit: true,
       collapsible: false,
       autoScroll: true,
       height: 260,
       width: 460,
       frame: true,
       id: 'crewInsuranceInfoId',
       layout: 'table',
       layoutConfig: {
           columns: 4
       },
       items: [{
           xtype: 'fieldset',
           title: '<%=CrewInsuranceInformation%>',
           cls: 'fieldsetpanel',
           collapsible: false,
           colspan: 3,
           id: 'crewInsurancepanelid',
           width: 430,
           height: 230,
           layout: 'table',
           layoutConfig: {
               columns: 4
           },
           items: [{
               xtype: 'label',
               text: '<%=MedicalInsuranceNo%>' + ' :',
               cls: 'labelstyle',
               id: 'crewMedical1'
           }, {
               xtype: 'label',
               text: '',
               cls: 'mandatoryfield',
               id: 'crewmandatorymedicalId'
           }, {
               xtype: 'textfield',
               cls: 'selectstylePerfect',
               regex: validate('alphanumericname'),
               emptyText: '<%=EnterMedicalInsuranceNo%>',
               allowBlank: false,
               blankText: '<%=EnterMedicalInsuranceNo%>',
               id: 'crewmedicalInsuranceId1'
           }, {
               xtype: 'label',
               text: '',
               cls: 'mandatoryfield',
               id: 'crewmandatorymedicalId1'
           }, {
               xtype: 'label',
               text: '<%=MedicalInsuranceCompany%>' + ' :',
               cls: 'labelstyle',
               id: 'crewMedicalCompany1'
           }, {
               xtype: 'label',
               text: '',
               cls: 'mandatoryfield',
               id: 'crewmandatoryMedicalCompanyId'
           }, {
               xtype: 'textfield',
               cls: 'selectstylePerfect',
               emptyText: '<%=EnterMedicalInsuranceCompany%>',
               allowBlank: false,
               blankText: '<%=EnterMedicalInsuranceCompany%>',
               id: 'crewmedicalInsuranceCompanyId1'
           }, {
               xtype: 'label',
               text: '',
               cls: 'mandatoryfield',
               id: 'crewmandatoryMedicalCompany1'
           }, {
               xtype: 'label',
               text: '<%=MedicalInsuranceExpiryDate%>' + ' :',
               cls: 'labelstyle',
               id: 'crewMedicalInsuranceExpiry1'
           }, {
               xtype: 'label',
               text: '',
               cls: 'mandatoryfield',
               id: 'crewmandatoryMedicalInsuranceExpiryId'
           }, {
               xtype: 'datefield',
               cls: 'selectstylePerfect',
               allowBlank: false,
               value: dtcur,
               format: getDateFormat(),
               allowBlank: false,
               id: 'crewMedicalInsuranceExpiryDateId1'
           }, {
               xtype: 'label',
               text: '',
               cls: 'mandatoryfield',
               id: 'crewmandatoryMedicalInsuranceExpiry1'
           }]
       }]
   });
   var crewinnerWinButtonPanelForInsurance = new Ext.Panel({
       id: 'crewInsurancewinbuttonid',
       standardSubmit: true,
       collapsible: false,
       autoHeight: true,
       height: 110,
       width: 460,
       frame: true,
       layout: 'table',
       layoutConfig: {
           columns: 4
       },
       buttons: [{
           xtype: 'button',
           text: '<%=Cancel%>',
           id: 'crewInformationcanButtId',
           cls: 'buttonstyle',
           iconCls: 'cancelbutton',
           width: 70,
           listeners: {
               click: {
                   fn: function () {
                       crewmyWinForInformation.hide();
                       addCrewmyWin.hide();
                       CrewmyWinForEmployee.hide();
                   }
               }
           }
       }, {
           xtype: 'button',
           text: '<%=Next%>',
           id: 'crewNext',
           cls: 'buttonstyle',
           iconCls: 'nextbutton',
           width: 70,
           listeners: {
               click: {
                   fn: function () {
                       
                       if (Ext.getCmp('employmentTypeComboId').getValue() == 2) {
                           crewgunInformation();
                       }
                      
                       else {
                           crewDriverInformation();
                       }
                       crewmyWinForInformation.hide();
                   }
               }
           }
       }]
   });
   var crewinsuranceInformationOuterPanelWindow = new Ext.Panel({
       width: 460,
       height: 330,
       standardSubmit: true,
       frame: true,
       items: [crewInnerPanelForInsuranceInformation, crewinnerWinButtonPanelForInsurance]
   });
   crewmyWinForInformation = new Ext.Window({
       title: titelForCrewInformationPanel,
       closable: false,
       resizable: false,
       modal: true,
       autoScroll: false,
       height: 360,
       width: 470,
       id: 'myWinInformation',
       items: [crewinsuranceInformationOuterPanelWindow]
   });

   function crewinsuranceInformation() {
       if (Ext.getCmp('custcomboId').getValue() == "") {
           Ext.example.msg("<%=SelectCustomerName%>");
           return;
       }
       buttonValue = '<%=Next%>';
       titelForCrewInformationPanel = '<%=CrewInsuranceInformationDetails%>';
       crewmyWinForInformation.setPosition(450, 150);
       crewmyWinForInformation.show();
       crewmyWinForInformation.setTitle(titelForCrewInformationPanel);
   }
   var crewinnerPanelForDriverInformation = new Ext.Panel({
       standardSubmit: true,
       collapsible: false,
       autoScroll: true,
       height: 230,
       width: 455,
       frame: true,
       id: 'crewdriverInfoId',
       layout: 'table',
       layoutConfig: {
           columns: 4
       },
       items: [{
           xtype: 'fieldset',
           title: '<%=CrewInformation%>',
           cls: 'fieldsetpanel',
           collapsible: false,
           colspan: 3,
           id: 'crewdriverpanelid',
           width: 420,
           height: 300,
           layout: 'table',
           layoutConfig: {
               columns: 3,
               tableAttrs: {
		            style: {
		                width: '88%'
		            }
        			}
           },
           items: [{
               xtype: 'label',
               text: '*',
               cls: 'mandatoryfield',
               id: 'crewmandatoryLicenceId'
           }, {
               xtype: 'label',
               text: '<%=LicenseNo%>' + ' :',
               cls: 'labelstyle',
               id: 'crewlicense1'
           }, {
               xtype: 'textfield',
               cls: 'selectstylePerfect',
               regex: validate('alphanumericname'),
               emptyText: '<%=EnterLicenseNo%>',
               allowBlank: false,
               blankText: '<%=EnterLicenseNo%>',
               id: 'crewlicenceId1'
           }, {
               xtype: 'label',
               text: '',
               cls: 'mandatoryfield',
               id: 'crewmandatorylicencePlaceId'
           }, {
               xtype: 'label',
               text: '<%=LicensePlace%>' + ' :',
               cls: 'labelstyle',
               id: 'crewlicencePlace1'
           }, {
               xtype: 'textfield',
               cls: 'selectstylePerfect',
               regex: validate('alphanumericname'),
               emptyText: '<%=EnterLicensePlace%>',
               allowBlank: false,
               blankText: '<%=EnterLicensePlace%>',
               id: 'crewlicencePlaceId1'
           },{
               xtype: 'label',
               text: '',
               cls: 'mandatoryfield',
               id: 'crewmandatorylicenceIssueDateId'
           }, {
               xtype: 'label',
               text: '<%=LicenseIssueDate%>' + ' :',
               cls: 'labelstyle',
               id: 'crewlicenceIssueDate'
           }, {
               xtype: 'datefield',
               cls: 'selectstylePerfect',
               allowBlank: false,
               value: dtcur,
               format: getDateFormat(),
               allowBlank: false,
               id: 'crewlicenceIssueDateId1'
           },{
               xtype: 'label',
               text: '',
               cls: 'mandatoryfield',
               id: 'crewmandatorylicenceRenewedDateId'
           },  {
               xtype: 'label',
               text: '<%=LicenseRenewedDate%>' + ' :',
               cls: 'labelstyle',
               id: 'crewlicenceRenewedDate1'
           }, {
               xtype: 'datefield',
               cls: 'selectstylePerfect',
               allowBlank: false,
               value: dtcur,
               format: getDateFormat(),
               allowBlank: false,
               id: 'crewlicenceRenewedDateId1'
           },{
               xtype: 'label',
               text: '*',
               cls: 'mandatoryfield',
               id: 'crewmandatorylicenceExpiryDateId'
           },{
               xtype: 'label',
               text: '<%=LicenseExpiryDate%>' + ' :',
               cls: 'labelstyle',
               id: 'crewlicenceExpiryDate1'
           },  {
               xtype: 'datefield',
               cls: 'selectstylePerfect',
               allowBlank: false,
               value: dtcur,
               format: getDateFormat(),
               allowBlank: false,
               id: 'crewlicenceExpiryDateId'
           },{
               xtype: 'label',
               text: '*',
               cls: 'mandatoryfield',
               id: 'addMandatorypreferedCompanyId',
               hidden:true
           },{
               xtype: 'label',
               text: '<%=preferedCompany%>' + ' :',
               cls: 'labelstyle',
               id: 'addPreferedCompanyId',
               hidden:true
           },customerGrid2]
       }]
   });
   var crewinnerWinButtonPanelForDriver = new Ext.Panel({
       id: 'crewdriverwinbuttonid',
       standardSubmit: true,
       collapsible: false,
       autoHeight: true,
       height: 110,
       width: 460,
       frame: true,
       layout: 'table',
       layoutConfig: {
           columns: 4
       },
       buttons: [{
           xtype: 'button',
           text: '<%=Save%>',
           id: 'crewlicenceButtonButtId',
           iconCls:'savebutton',
           cls: 'buttonstyle',
           width: 70,
           listeners: {
               click: {
                   fn: function () {
                       if (Ext.getCmp('crewlicenceId1').getValue() == "" && Ext.getCmp('employmentTypeComboId').getRawValue() != 'CUSTODIAN') {
                           Ext.example.msg("<%=EnterLicenseNo%>");
                           return;
                       }
                       if (Ext.getCmp('crewlicenceExpiryDateId').getValue() == "" && Ext.getCmp('employmentTypeComboId').getRawValue() != 'CUSTODIAN') {
                           Ext.example.msg("<%=EnterLicenseExpiryDate%>");
                           return;
                       }
                       secondGridPanelForDetails.getEl().mask();
                       crewdriverInformationOuterPanelWindow.getEl().mask();
                       customerNmaes = "";
                     if(Ext.getCmp('employmentTypeComboId').getRawValue() == 'CUSTODIAN'){      
                    
                       var records = customerGrid2.getSelectionModel().getSelections();

                        for (var i = 0, len = records.length; i < len; i++) {
                            var store = records[i];
                            var cId = store.get('customerName2');
                            customerNmaes = customerNmaes + cId + ",";
                        }
                       }
                       Ext.Ajax.request({
                           url: '<%=request.getContextPath()%>/CrewMasterDataAction.do?param=saveAllPanelInformation',
                           method: 'POST',
                           params: {
                               CustID: Ext.getCmp('custcomboId').getValue(),
                               custName: Ext.getCmp('custcomboId').getRawValue(),
                               gunLicenceId: Ext.getCmp('crewgunLicenceId1').getValue(),
                               gunLicenceTypeId: Ext.getCmp('crewgunLicenceTypeId1').getValue(),
                               gunLicenceIssueDate: Ext.getCmp('crewgunLicenceIssueDateId1').getValue(),
                               gunLicenceIssuePlace: Ext.getCmp('crewgunLicenceIssuePlaceId1').getValue(),
                               gunLicenceExpiryDate: Ext.getCmp('crewgunLicenceExpiryDateId1').getValue(),
                               employementType: Ext.getCmp('employmentTypeComboId').getValue(),
                               employmentId: Ext.getCmp('employmeeIdCrew2').getValue(),
                               client: Ext.getCmp('clientIdCrew2').getValue(),
                               dateOfJoining: Ext.getCmp('dateOfJoiningIdCrew2').getValue(),
                               dateOfLeaving: Ext.getCmp('dateOfLeavingIdCrew2').getValue(),
                               bloodGroup: Ext.getCmp('bloodGroupIdCrew2').getValue(),
                               groupName: Ext.getCmp('groupNameComboId').getValue(),
                               activeStatus: Ext.getCmp('statuscomboId').getValue(),
                               remarks: Ext.getCmp('remarksIdCrew2').getValue(),
                               governmentResidenceId: Ext.getCmp('governmentIdCrew2').getValue(),
                               governmentResidenceExpiryDate: Ext.getCmp('governmentexpiryIdCrew2').getValue(),
                               rfidCode: Ext.getCmp('rfidIdCrew2').getValue(),
                               firstName: Ext.getCmp('nameId2').getValue(),
                               lastName: Ext.getCmp('lastNameId2').getValue(),
                               address: Ext.getCmp('addressId2').getValue(),
                               permanentAddress: Ext.getCmp('permanentAddressId2').getValue(),
                               city: Ext.getCmp('cityId2').getValue(),
                               otherCity: Ext.getCmp('otherCityId2').getValue(),
                               state: Ext.getCmp('statecomboId').getValue(),
                               country: Ext.getCmp('countryId').getValue(),
                               telephoneNo: Ext.getCmp('telephoneId2').getValue(),
                               mobileNo: Ext.getCmp('mobileId2').getValue(),
                               dateOfBirth: Ext.getCmp('dateOfBirthId2').getValue(),
                               gender: Ext.getCmp('genderComboId').getValue(),
                               nationality: Ext.getCmp('nationalityId2').getValue(),
                               maritialStatus: Ext.getCmp('maritialComboId').getValue(),
                               medicalInsuranceId: Ext.getCmp('crewmedicalInsuranceId1').getValue(),
                               medicalInsuranceCompanyName: Ext.getCmp('crewmedicalInsuranceCompanyId1').getValue(),
                               medicalinsuranceExpiryDate: Ext.getCmp('crewMedicalInsuranceExpiryDateId1').getValue(),
                               licenceId: Ext.getCmp('crewlicenceId1').getValue(),
                               licencePlace: Ext.getCmp('crewlicencePlaceId1').getValue(),
                               licenceIssueDate: Ext.getCmp('crewlicenceIssueDateId1').getValue(),
                               licenceRenewedDate: Ext.getCmp('crewlicenceRenewedDateId1').getValue(),
                               licenceExpiryDate: Ext.getCmp('crewlicenceExpiryDateId').getValue(),
                               driverId: driverId,
                               passportNumber:Ext.getCmp('passportNumberIdForInnerPanelInCrewButtonInPersonalInformationTextField').getValue(),
                               passwortExpiryDate:Ext.getCmp('expiryDateForInnerPanelInCrewButtonInPersonalInformationTextField').getValue(),
                               workCompensationId:Ext.getCmp('workmanCompensationIdforInnerPanelCrewButtonTextField').getValue(),
                               workCompensationExpiryDate:Ext.getCmp('expiryDateWorkmanCompensationIdforInnerPanelCrewButtonTextField').getValue(),
                               preferedCustomerNames : customerNmaes
                           },
                           success: function (response, options) {
                               var message = response.responseText;
                               Ext.example.msg(message);
                               Ext.getCmp('crewgunLicenceId1').reset();
                               Ext.getCmp('crewgunLicenceTypeId1').reset();
                               Ext.getCmp('crewgunLicenceIssueDateId1').reset();
                               Ext.getCmp('crewgunLicenceIssuePlaceId1').reset();
                               Ext.getCmp('crewgunLicenceExpiryDateId1').reset();
                               Ext.getCmp('employmentTypeComboId').reset();
                               Ext.getCmp('employmeeIdCrew2').reset();
                               Ext.getCmp('clientIdCrew2').reset();
                               Ext.getCmp('dateOfJoiningIdCrew2').reset();
                               Ext.getCmp('dateOfLeavingIdCrew2').reset();
                               Ext.getCmp('bloodGroupIdCrew2').reset();
                               Ext.getCmp('groupNameComboId').reset();
                               Ext.getCmp('statuscomboId').reset();
                               Ext.getCmp('remarksIdCrew2').reset();
                               Ext.getCmp('governmentIdCrew2').reset();
                               Ext.getCmp('governmentexpiryIdCrew2').reset();
                               Ext.getCmp('rfidIdCrew2').reset();
                               Ext.getCmp('nameId2').reset();
                               Ext.getCmp('lastNameId2').reset();
                               Ext.getCmp('addressId2').reset();
                               Ext.getCmp('permanentAddressId2').reset();
                               Ext.getCmp('cityId2').reset();
                               Ext.getCmp('otherCityId2').reset();
                               Ext.getCmp('statecomboId').reset();
                               Ext.getCmp('countryId').reset();
                               Ext.getCmp('telephoneId2').reset();
                               Ext.getCmp('mobileId2').reset();
                               Ext.getCmp('dateOfBirthId2').reset();
                               Ext.getCmp('genderComboId').reset();
                               Ext.getCmp('nationalityId2').reset();
                               Ext.getCmp('maritialComboId').reset();
                               Ext.getCmp('crewmedicalInsuranceId1').reset();
                               Ext.getCmp('crewmedicalInsuranceCompanyId1').reset();
                               Ext.getCmp('crewMedicalInsuranceExpiryDateId1').reset();
                               Ext.getCmp('crewlicenceId1').reset();
                               Ext.getCmp('crewlicencePlaceId1').reset();
                               Ext.getCmp('crewlicenceIssueDateId1').reset();
                               Ext.getCmp('crewlicenceRenewedDateId1').reset();
                               Ext.getCmp('crewlicenceExpiryDateId').reset();
                               Ext.getCmp('workmanCompensationIdforInnerPanelCrewButtonTextField').reset();
                               Ext.getCmp('expiryDateWorkmanCompensationIdforInnerPanelCrewButtonTextField').reset();
                               Ext.getCmp('workmanCompensationIdforInnerPanelCrewButtonTextField').reset();
                               Ext.getCmp('passportNumberIdForInnerPanelInCrewButtonInPersonalInformationTextField').reset();
                               
                               Ext.getCmp('labelnameId').setText('');
                               Ext.getCmp('labellastNameId').setText('');
                               Ext.getCmp('labeladdressId').setText('');
                               Ext.getCmp('labelpermanentAddressId').setText('');
                               Ext.getCmp('labelcityId').setText('');
                               Ext.getCmp('labelotherCityId').setText('');
                               Ext.getCmp('labelstatelabelId').setText('');
                               Ext.getCmp('labelcountrylabelId').setText('');
                               Ext.getCmp('labeltelephoneId').setText('');
                               Ext.getCmp('labelmobileId').setText('');
                               Ext.getCmp('labeldateOfBirthId').setText('');
                               Ext.getCmp('labelgenderLabelId').setText('');
                               Ext.getCmp('labelnationalityId').setText('');
                               Ext.getCmp('labelmaritialStatusLabelId').setText('');
                               Ext.getCmp('employnemntLabelTypeId').setText('');
                               Ext.getCmp('employmeeLabelId').setText('');
                               Ext.getCmp('dateOfJoiningLabelId').setText('');
                               Ext.getCmp('dateOfLeavingLabelId').setText('');
                               Ext.getCmp('bloodGroupLabelId').setText('');
                               Ext.getCmp('groupNameLabelId').setText('');
                               Ext.getCmp('activeStatusLabelId').setText('');
                               Ext.getCmp('remarksLabelId').setText('');
                               Ext.getCmp('governmentLabelId').setText('');
                               Ext.getCmp('governmentExpiryLabelId').setText('');
                               Ext.getCmp('rfidLabelId').setText('');
                               Ext.getCmp('medicalInsuranceLabelId').setText('');
                               Ext.getCmp('medicalInsuranceCompanyLabelId').setText('');
                               Ext.getCmp('MedicalInsuranceExpiryId').setText('');
                               Ext.getCmp('licenceNoLabelId').setText('');
                               Ext.getCmp('licencePlaceLabelId').setText('');
                               Ext.getCmp('licenceIssueDateLabelId').setText('');
                               Ext.getCmp('licenceRenewedDateLabelId').setText('');
                               Ext.getCmp('preferedCompanyLabelId').setText('');                              
                               Ext.getCmp('licenceExpiryDateLabelId').setText('');
                               Ext.getCmp('gunGicenceNoLabelId').setText('');
                               Ext.getCmp('gunLicenceTypeLabelId').setText('');
                               Ext.getCmp('gunLicenceIssueDateLabelId').setText('');
                               Ext.getCmp('gunLicenceIssuePlaceLabelId').setText('');
                               Ext.getCmp('gunLicenceExpiryDateLabelId').setText('');
                               
                               Ext.getCmp('expiryDateIdForEditPanelLabel').setText('');
                               Ext.getCmp('PassportNumberIdForEditPanelLabel').setText('');
                               Ext.getCmp('WorkManCompensationLabelId').setText('');
                               Ext.getCmp('expiryDateIdForWorkManCompensationLabelId').setText('');
                               
                               crewmyWinForGun.hide();
                               crewmyWinForDriver.hide();
                               crewmyWinForInformation.hide();
                               CrewmyWinForEmployee.hide();
                               addCrewmyWin.hide();
                               secondGridPanelForDetails.getEl().unmask();
                               crewdriverInformationOuterPanelWindow.getEl().unmask();
                               firstGridStoreForDriverName.load({
                                   params: {
                                       CustId: Ext.getCmp('custcomboId').getValue(),
                                       CustName: custName
                                   }
                               });
                           },
                           failure: function () {
                               Ext.example.msg("Error");
                               crewmyWinForGun.hide();
                               crewmyWinForDriver.hide();
                               crewmyWinForInformation.hide();
                               CrewmyWinForEmployee.hide();
                               addCrewmyWin.hide();
                           }
                       });
                   }
               }
           }
       }, {
           xtype: 'button',
           text: '<%=Cancel%>',
           id: 'crewdrivercanButtId',
           cls: 'buttonstyle',
           iconCls: 'cancelbutton',
           width: 70,
           listeners: {
               click: {
                   fn: function () {
                       crewmyWinForDriver.hide();
                       addCrewmyWin.hide();
                       CrewmyWinForEmployee.hide();
                       crewmyWinForInformation.hide();
                   }
               }
           }
       }]
   });
   var crewdriverInformationOuterPanelWindow = new Ext.Panel({
       width: 460,
       height: 330,
       standardSubmit: true,
       frame: true,
       items: [crewinnerPanelForDriverInformation, crewinnerWinButtonPanelForDriver]
   });
   crewmyWinForDriver = new Ext.Window({
       title: crewtitelForDriverPanel,
       closable: false,
       resizable: false,
       modal: true,
       autoScroll: false,
       height: 330,
       width: 470,
       id: 'myWinDriver',
       items: [crewdriverInformationOuterPanelWindow]
   });

   function crewDriverInformation() {
       if (Ext.getCmp('custcomboId').getValue() == "") {
           Ext.example.msg("<%=SelectCustomerName%>");
           return;
       }
       buttonValue = '<%=Next%>';
       crewtitelForDriverPanel = '<%=CrewInformation%>';
       crewmyWinForDriver.setPosition(450, 150);
       crewmyWinForDriver.show();
       crewmyWinForDriver.setTitle(crewtitelForDriverPanel);
if(Ext.getCmp('employmentTypeComboId').getRawValue() == 'CUSTODIAN'){      
Ext.getCmp('addMandatorypreferedCompanyId').show();
Ext.getCmp('addPreferedCompanyId').show();
Ext.getCmp('crewmandatoryLicenceId').hide();
Ext.getCmp('crewmandatorylicenceExpiryDateId').hide();
Ext.getCmp('customerGridId2').show();
customercheckstore.load({
                       params: {
                           CustId: Ext.getCmp('custcomboId').getValue()
                       }
                   });
 }else{                    
Ext.getCmp('addMandatorypreferedCompanyId').hide();
Ext.getCmp('addPreferedCompanyId').hide();
Ext.getCmp('customerGridId2').hide();
Ext.getCmp('crewmandatoryLicenceId').show();
Ext.getCmp('crewmandatorylicenceExpiryDateId').show();

 }      
   }
   var crewinnerPanelForGunInformation = new Ext.Panel({
       standardSubmit: true,
       collapsible: false,
       autoScroll: true,
       height: 260,
       width: 460,
       frame: true,
       id: 'crewgunInfoId',
       layout: 'table',
       layoutConfig: {
           columns: 4
       },
       items: [{
           xtype: 'fieldset',
           title: '<%=CrewGunmenInformation%>',
           cls: 'fieldsetpanel',
           collapsible: false,
           colspan: 3,
           id: 'crewgunpanelid',
           width: 430,
           height: 230,
           layout: 'table',
           layoutConfig: {
               columns: 3,
               tableAttrs: {
		            style: {
		                width: '92%'
		            }
        			}
           },
           items: [{
               xtype: 'label',
               text: '*',
               cls: 'mandatoryfield',
               id: 'crewmandatorygunlicenceId'
           }, {
               xtype: 'label',
               text: '<%=GunLicenseNo%>' + ' :',
               cls: 'labelstyle',
               id: 'crewgunlicence'
           }, {
               xtype: 'textfield',
               cls: 'selectstylePerfect',
               regex: validate('alphanumericname'),
               emptyText: '<%=EnterGunLicenseNo%>',
               allowBlank: false,
               blankText: '<%=EnterGunLicenseNo%>',
               id: 'crewgunLicenceId1'
           },{
               xtype: 'label',
               text: '',
               cls: 'mandatoryfield',
               id: 'crewmandatorygunLicenceTypeId'
           }, {
               xtype: 'label',
               text: '<%=GunLicenseType%>' + ' :',
               cls: 'labelstyle',
               id: 'crewgunLicenceType1'
           },  {
               xtype: 'textfield',
               cls: 'selectstylePerfect',
               regex: validate('alphanumericname'),
               emptyText: '<%=EnterGunLicenseType%>',
               allowBlank: false,
               blankText: '<%=EnterGunLicenseType%>',
               id: 'crewgunLicenceTypeId1'
           }, {
               xtype: 'label',
               text: '',
               cls: 'mandatoryfield',
               id: 'crewmandatorygunLicenceIssueDateId'
           }, {
               xtype: 'label',
               text: '<%=GunLicenseIssueDate%>' + ' :',
               cls: 'labelstyle',
               id: 'crewgunLicenceIssueDate11'
           }, {
               xtype: 'datefield',
               cls: 'selectstylePerfect',
               allowBlank: false,
               value: dtcur,
               format: getDateFormat(),
               allowBlank: false,
               id: 'crewgunLicenceIssueDateId1'
           },{
               xtype: 'label',
               text: '',
               cls: 'mandatoryfield',
               id: 'crewmandatorygunLicenceIssuePlaceId'
           },{
               xtype: 'label',
               text: '<%=GunLicenseIssuePlace%>' + ' :',
               cls: 'labelstyle',
               id: 'crewgunLicenceIssuePlace11'
           },  {
               xtype: 'textfield',
               cls: 'selectstylePerfect',
               regex: validate('alphanumericname'),
               emptyText: '<%=EnterGunLicenseIssuePlace%>',
               allowBlank: false,
               blankText: '<%=EnterGunLicenseIssuePlace%>',
               id: 'crewgunLicenceIssuePlaceId1'
           },  {
               xtype: 'label',
               text: '*',
               cls: 'mandatoryfield',
               id: 'crewmandatorygunLicenceExpiryDateId'
           }, {
               xtype: 'label',
               text: '<%=GunLicenseExpiryDate%>' + ' :',
               cls: 'labelstyle',
               id: 'crewgunLicenceExpiryDate11'
           }, {
               xtype: 'datefield',
               cls: 'selectstylePerfect',
               allowBlank: false,
               value: dtcur,
               format: getDateFormat(),
               allowBlank: false,
               id: 'crewgunLicenceExpiryDateId1'
           }]
       }]
   });
   var crewinnerWinButtonPanelForGun = new Ext.Panel({
       id: 'crewgunwinbuttonid',
       standardSubmit: true,
       collapsible: false,
       autoHeight: true,
       height: 110,
       width: 460,
       frame: true,
       layout: 'table',
       layoutConfig: {
           columns: 4
       },
       buttons: [{
           xtype: 'button',
           text: '<%=Save%>',
           iconCls:'savebutton',
           id: 'crewgunButtId',
           cls: 'buttonstyle',
           width: 70,
           listeners: {
               click: {
                   fn: function () {
                       if (Ext.getCmp('crewgunLicenceId1').getValue() == "") {
                           Ext.example.msg("<%=EnterGunLicenseNumber%>");
                           return;
                       }
                       if (Ext.getCmp('crewgunLicenceExpiryDateId1').getValue() == "") {
                           Ext.example.msg("<%=EnterGunLicenseExpiryDate%>");
                           return;
                       }
                       crewgunInformationOuterPanelWindow.getEl().mask();
                       secondGridPanelForDetails.getEl().mask();
                       Ext.Ajax.request({
                           url: '<%=request.getContextPath()%>/CrewMasterDataAction.do?param=saveAllPanelInformation',
                           method: 'POST',
                           params: {
                               CustID: Ext.getCmp('custcomboId').getValue(),
                               custName: Ext.getCmp('custcomboId').getRawValue(),
                               gunLicenceId: Ext.getCmp('crewgunLicenceId1').getValue(),
                               gunLicenceTypeId: Ext.getCmp('crewgunLicenceTypeId1').getValue(),
                               gunLicenceIssueDate: Ext.getCmp('crewgunLicenceIssueDateId1').getValue(),
                               gunLicenceIssuePlace: Ext.getCmp('crewgunLicenceIssuePlaceId1').getValue(),
                               gunLicenceExpiryDate: Ext.getCmp('crewgunLicenceExpiryDateId1').getValue(),
                               employementType: Ext.getCmp('employmentTypeComboId').getValue(),
                               employmentId: Ext.getCmp('employmeeIdCrew2').getValue(),
                               client: Ext.getCmp('clientIdCrew2').getValue(),
                               dateOfJoining: Ext.getCmp('dateOfJoiningIdCrew2').getValue(),
                               dateOfLeaving: Ext.getCmp('dateOfLeavingIdCrew2').getValue(),
                               bloodGroup: Ext.getCmp('bloodGroupIdCrew2').getValue(),
                               groupName: Ext.getCmp('groupNameComboId').getValue(),
                               activeStatus: Ext.getCmp('statuscomboId').getValue(),
                               remarks: Ext.getCmp('remarksIdCrew2').getValue(),
                               governmentResidenceId: Ext.getCmp('governmentIdCrew2').getValue(),
                               governmentResidenceExpiryDate: Ext.getCmp('governmentexpiryIdCrew2').getValue(),
                               rfidCode: Ext.getCmp('rfidIdCrew2').getValue(),
                               firstName: Ext.getCmp('nameId2').getValue(),
                               lastName: Ext.getCmp('lastNameId2').getValue(),
                               address: Ext.getCmp('addressId2').getValue(),
                               permanentAddress: Ext.getCmp('permanentAddressId2').getValue(),
                               city: Ext.getCmp('cityId2').getValue(),
                               otherCity: Ext.getCmp('otherCityId2').getValue(),
                               state: Ext.getCmp('statecomboId').getValue(),
                               country: Ext.getCmp('countryId').getValue(),
                               telephoneNo: Ext.getCmp('telephoneId2').getValue(),
                               mobileNo: Ext.getCmp('mobileId2').getValue(),
                               dateOfBirth: Ext.getCmp('dateOfBirthId2').getValue(),
                               gender: Ext.getCmp('genderComboId').getValue(),
                               nationality: Ext.getCmp('nationalityId2').getValue(),
                               maritialStatus: Ext.getCmp('maritialComboId').getValue(),
                               medicalInsuranceId: Ext.getCmp('crewmedicalInsuranceId1').getValue(),
                               medicalInsuranceCompanyName: Ext.getCmp('crewmedicalInsuranceCompanyId1').getValue(),
                               medicalinsuranceExpiryDate: Ext.getCmp('crewMedicalInsuranceExpiryDateId1').getValue(),
                               licenceId: Ext.getCmp('crewlicenceId1').getValue(),
                               licencePlace: Ext.getCmp('crewlicencePlaceId1').getValue(),
                               licenceIssueDate: Ext.getCmp('crewlicenceIssueDateId1').getValue(),
                               licenceRenewedDate: Ext.getCmp('crewlicenceRenewedDateId1').getValue(),
                               licenceExpiryDate: Ext.getCmp('crewlicenceExpiryDateId').getValue(),
                               driverId: driverId,
                               
                               passportNumber:Ext.getCmp('passportNumberIdForInnerPanelInCrewButtonInPersonalInformationTextField').getValue(),
                               passwortExpiryDate:Ext.getCmp('expiryDateForInnerPanelInCrewButtonInPersonalInformationTextField').getValue(),
                               workCompensationId:Ext.getCmp('workmanCompensationIdforInnerPanelCrewButtonTextField').getValue(),
                               workCompensationExpiryDate:Ext.getCmp('expiryDateWorkmanCompensationIdforInnerPanelCrewButtonTextField').getValue()
                               
 
                           },
                           success: function (response, options) {
                               var message = response.responseText;
                               Ext.example.msg(message);
                               Ext.getCmp('crewgunLicenceTypeId1').reset();
                               Ext.getCmp('crewgunLicenceIssueDateId1').reset();
                               Ext.getCmp('crewgunLicenceIssuePlaceId1').reset();
                               Ext.getCmp('crewgunLicenceExpiryDateId1').reset();
                               Ext.getCmp('employmentTypeComboId').reset();
                               Ext.getCmp('employmeeIdCrew2').reset();
                               Ext.getCmp('clientIdCrew2').reset();
                               Ext.getCmp('dateOfJoiningIdCrew2').reset();
                               Ext.getCmp('dateOfLeavingIdCrew2').reset();
                               Ext.getCmp('bloodGroupIdCrew2').reset();
                               Ext.getCmp('groupNameComboId').reset();
                               Ext.getCmp('statuscomboId').reset();
                               Ext.getCmp('remarksIdCrew2').reset();
                               Ext.getCmp('governmentIdCrew2').reset();
                               Ext.getCmp('governmentexpiryIdCrew2').reset();
                               Ext.getCmp('rfidIdCrew2').reset();
                               Ext.getCmp('nameId2').reset();
                               Ext.getCmp('lastNameId2').reset();
                               Ext.getCmp('addressId2').reset();
                               Ext.getCmp('permanentAddressId2').reset();
                               Ext.getCmp('cityId2').reset();
                               Ext.getCmp('otherCityId2').reset();
                               Ext.getCmp('statecomboId').reset();
                               Ext.getCmp('countryId').reset();
                               Ext.getCmp('telephoneId2').reset();
                               Ext.getCmp('mobileId2').reset();
                               Ext.getCmp('dateOfBirthId2').reset();
                               Ext.getCmp('genderComboId').reset();
                               Ext.getCmp('nationalityId2').reset();
                               Ext.getCmp('maritialComboId').reset();
                               Ext.getCmp('crewmedicalInsuranceId1').reset();
                               Ext.getCmp('crewmedicalInsuranceCompanyId1').reset();
                               Ext.getCmp('crewMedicalInsuranceExpiryDateId1').reset();
                               Ext.getCmp('crewlicenceId1').reset();
                               Ext.getCmp('crewlicencePlaceId1').reset();
                               Ext.getCmp('crewlicenceIssueDateId1').reset();
                               Ext.getCmp('crewlicenceRenewedDateId1').reset();
                               Ext.getCmp('crewlicenceExpiryDateId').reset();
                               
                               Ext.getCmp('workmanCompensationIdforInnerPanelCrewButtonTextField').reset();
                               Ext.getCmp('expiryDateWorkmanCompensationIdforInnerPanelCrewButtonTextField').reset();
                               Ext.getCmp('workmanCompensationIdforInnerPanelCrewButtonTextField').reset();
                               Ext.getCmp('passportNumberIdForInnerPanelInCrewButtonInPersonalInformationTextField').reset();
                               
                               Ext.getCmp('labelnameId').setText('');
                               Ext.getCmp('labellastNameId').setText('');
                               Ext.getCmp('labeladdressId').setText('');
                               Ext.getCmp('labelpermanentAddressId').setText('');
                               Ext.getCmp('labelcityId').setText('');
                               Ext.getCmp('labelotherCityId').setText('');
                               Ext.getCmp('labelstatelabelId').setText('');
                               Ext.getCmp('labelcountrylabelId').setText('');
                               Ext.getCmp('labeltelephoneId').setText('');
                               Ext.getCmp('labelmobileId').setText('');
                               Ext.getCmp('labeldateOfBirthId').setText('');
                               Ext.getCmp('labelgenderLabelId').setText('');
                               Ext.getCmp('labelnationalityId').setText('');
                               Ext.getCmp('labelmaritialStatusLabelId').setText('');
                               Ext.getCmp('employnemntLabelTypeId').setText('');
                               Ext.getCmp('employmeeLabelId').setText('');
                               Ext.getCmp('dateOfJoiningLabelId').setText('');
                               Ext.getCmp('dateOfLeavingLabelId').setText('');
                               Ext.getCmp('bloodGroupLabelId').setText('');
                               Ext.getCmp('groupNameLabelId').setText('');
                               Ext.getCmp('activeStatusLabelId').setText('');
                               Ext.getCmp('remarksLabelId').setText('');
                               Ext.getCmp('governmentLabelId').setText('');
                               Ext.getCmp('governmentExpiryLabelId').setText('');
                               Ext.getCmp('rfidLabelId').setText('');
                               Ext.getCmp('medicalInsuranceLabelId').setText('');
                               Ext.getCmp('medicalInsuranceCompanyLabelId').setText('');
                               Ext.getCmp('MedicalInsuranceExpiryId').setText('');
                               Ext.getCmp('licenceNoLabelId').setText('');
                               Ext.getCmp('licencePlaceLabelId').setText('');
                               Ext.getCmp('licenceIssueDateLabelId').setText('');
                               Ext.getCmp('licenceRenewedDateLabelId').setText('');
                               Ext.getCmp('preferedCompanyLabelId').setText('');
                               Ext.getCmp('licenceExpiryDateLabelId').setText('');
                               Ext.getCmp('gunGicenceNoLabelId').setText('');
                               Ext.getCmp('gunLicenceTypeLabelId').setText('');
                               Ext.getCmp('gunLicenceIssueDateLabelId').setText('');
                               Ext.getCmp('gunLicenceIssuePlaceLabelId').setText('');
                               Ext.getCmp('gunLicenceExpiryDateLabelId').setText('');
                               
                               Ext.getCmp('expiryDateIdForEditPanelLabel').setText('');
                               Ext.getCmp('PassportNumberIdForEditPanelLabel').setText('');
                               Ext.getCmp('WorkManCompensationLabelId').setText('');
                               Ext.getCmp('expiryDateIdForWorkManCompensationLabelId').setText('');
                               
                                
                               crewmyWinForGun.hide();
                               crewmyWinForDriver.hide();
                               crewmyWinForInformation.hide();
                               CrewmyWinForEmployee.hide();
                               addCrewmyWin.hide();
                               secondGridPanelForDetails.getEl().unmask();
                               crewgunInformationOuterPanelWindow.getEl().unmask();
                               firstGridStoreForDriverName.load({
                                   params: {
                                       CustId: Ext.getCmp('custcomboId').getValue(),
                                       CustName: custName
                                   }
                               });
                           },
                           failure: function () {
                               Ext.example.msg("Error");
                               crewmyWinForGun.hide();
                               crewmyWinForDriver.hide();
                               crewmyWinForInformation.hide();
                               CrewmyWinForEmployee.hide();
                               addCrewmyWin.hide();
                           }
                       });
                   }
               }
           }
       }, {
           xtype: 'button',
           text: '<%=Cancel%>',
           id: 'crewguncanButtId',
           cls: 'buttonstyle',
           iconCls: 'cancelbutton',
           width: 70,
           listeners: {
               click: {
                   fn: function () {
                       crewmyWinForGun.hide();
                       addCrewmyWin.hide();
                       CrewmyWinForEmployee.hide();
                       crewmyWinForInformation.hide();
                       crewmyWinForDriver.hide();
                   }
               }
           }
       }]
   });
   var crewgunInformationOuterPanelWindow = new Ext.Panel({
       width: 460,
       height: 330,
       standardSubmit: true,
       frame: true,
       items: [crewinnerPanelForGunInformation, crewinnerWinButtonPanelForGun]
   });
   crewmyWinForGun = new Ext.Window({
       title: crewtitelForGunPanel,
       closable: false,
       resizable: false,
       modal: true,
       autoScroll: false,
       height: 380,
       width: 470,
       id: 'crewmyWingun',
       items: [crewgunInformationOuterPanelWindow]
   });

   function crewgunInformation() {
       if (Ext.getCmp('custcomboId').getValue() == "") {
           Ext.example.msg("<%=SelectCustomerName%>");
           return;
       }
       buttonValue = '<%=Next%>';
       crewtitelForGunPanel = '<%=CrewGunmenInformationDetails%>';
       crewmyWinForGun.setPosition(450, 150);
       crewmyWinForGun.show();
       crewmyWinForGun.setTitle(crewtitelForGunPanel);
   }
   var allButtonsPannel = new Ext.Panel({
       standardSubmit: true,
       collapsibli: false,
       id: 'id',
       layout: 'table',
       frame: false,
       width: 180,
       height: 30,
       layoutConfig: {
           columns: 3
       },
       items: [{
           width: 80
       }, {
           xtype: 'button',
           text: '<%=AddCrew%>',
           id: 'addCrewIdt',
           cls: 'buttonwastemanagement',
           width: 100,
           listeners: {
               click: {
                   fn: function () {
                       addCrewPersonalInformation()
                   }
               }
           }
       }, {
           width: 10
       }]
   });
   var clientPanel = new Ext.Panel({
       standardSubmit: true,
       collapsible: false,
       id: 'traderMaster',
       layout: 'table',
       frame: false,
       width: screen.width - 29,
       height: 40,
       layoutConfig: {
           columns: 11
       },
       items: [{
               xtype: 'label',
               text: '<%=CustomerName%>' + ' :',
               cls: 'labelstyle',
               id: 'custnamelab'
           },
           custnamecombo, {
               width: 60
           }
       ]
   });
   firstGridToGetDriverName.on({
       "cellclick": {
           fn: onCellClickOnGrid
       }
   });
   var secondGridPanelForDetails = new Ext.Panel({
       standardSubmit: true,
       //title: 'Crew Details',
       collapsible: false,
       id: 'secondPanelId',
       layout: 'table',
       frame: true,
       autoScroll: true,
       //border:true,
       width: 1030,
       height: 460,
       layoutConfig: {
           columns: 1
       },
       items: [editOuterPanelWindow, editOuterPanelWindowF0rEmployee, editOuterPanelWindowF0rInsurance, editOuterPanelWindowF0rDriver, editOuterPanelWindowF0rGun]
   });
   var lidAndValvePanel = new Ext.Panel({
       standardSubmit: true,
       collapsible: false,
       id: 'vesselPanelId',
       layout: 'table',
       frame: false,
       width: screen.width - 22,
       height: 480,
       layoutConfig: {
           columns: 2
       },
       items: [firstGridToGetDriverName, secondGridPanelForDetails]
   });
   Ext.onReady(function () {
       ctsb = tsb;
       Ext.QuickTips.init();
       Ext.form.Field.prototype.msgTarget = 'side';
       outerPanel = new Ext.Panel({
           title: '<%=CrewDetails%>',
           renderTo: 'content',
           standardSubmit: true,
           frame: true,
           width: screen.width-22,
          // cls: 'outerpanel',
           height:550,
           layout: 'table',
           layoutConfig: {
               columns: 1
           },
           items: [clientPanel, lidAndValvePanel]
          // bbar: ctsb
       });
       sb = Ext.getCmp('form-statusbar');
   });  </script>
 <jsp:include page="../Common/footer.jsp" />
 <!-- </body>   -->
 <!-- </html> -->


