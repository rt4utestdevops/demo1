<%@ page  language="java" import="java.util.*,java.text.SimpleDateFormat,t4u.functions.*,t4u.beans.*,t4u.common.*" pageEncoding="utf-8"%>
<%@ taglib uri="http://packtag.sf.net" prefix="pack"%>
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
	SandMiningFunctions smf = new SandMiningFunctions();

	cf.checkLoginInfo((LoginInfoBean) session.getAttribute("loginInfoDetails"), session, request, response);
	String responseaftersubmit="''";
	String feature="1";
	if(session.getAttribute("responseaftersubmit")!=null){
	   responseaftersubmit="'"+session.getAttribute("responseaftersubmit").toString()+"'";
		session.setAttribute("responseaftersubmit",null);
	}
	
	boolean ConsumerMDPstate;
	boolean isModelCKM;
	boolean isAadharMandatory;
    LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
	String language = loginInfo.getLanguage();
	int systemId = loginInfo.getSystemId();
	int customerId = loginInfo.getCustomerId();
	
	ConsumerMDPstate = smf.status(systemId);
	isModelCKM = smf.isChikkmagalurModel(systemId);
	isAadharMandatory = smf.AadharMandatory(systemId);
	
ArrayList<String> tobeConverted = new ArrayList<String>();

tobeConverted.add("Consumer_Enrolment_Form");
tobeConverted.add("Consumer_Details");

tobeConverted.add("Customer_Name");
tobeConverted.add("Select_Customer");

tobeConverted.add("Consumer_Type");
tobeConverted.add("Select_Consumer_Type");

tobeConverted.add("District");
tobeConverted.add("Select_District");

tobeConverted.add("Taluka");
tobeConverted.add("Select_Taluka");

tobeConverted.add("Village");
tobeConverted.add("Enter_Village");

tobeConverted.add("Mobile_No");
tobeConverted.add("Enter_Mobile_No");

tobeConverted.add("Email_ID");
tobeConverted.add("Enter_Email_Id");

tobeConverted.add("Address");
tobeConverted.add("Enter_Address");

tobeConverted.add("Identity_Proof_Type");
tobeConverted.add("Select_Identity_Proof_Type");

tobeConverted.add("Sand_Consumer_Name");
tobeConverted.add("Enter_Sand_Consumer_Name");

tobeConverted.add("Project_Name");
tobeConverted.add("Enter_Project_Name");

tobeConverted.add("Project_Duration_From");
tobeConverted.add("Select_Project_Duration_From");

tobeConverted.add("Project_Duration_To");
tobeConverted.add("Select_Project_Duration_To");

tobeConverted.add("Contractor_Name");
tobeConverted.add("Enter_Contractor_Name");

tobeConverted.add("Government_Dept_Name");
tobeConverted.add("Enter_Government_Dept_Name");

tobeConverted.add("Dept_Contact_Name");
tobeConverted.add("Enter_Dept_Contact_Name");

tobeConverted.add("Enter_Work_Location");
tobeConverted.add("Work_Location");

tobeConverted.add("Work_Location_Details");
tobeConverted.add("Same_As_Above");

tobeConverted.add("Work_Details");

tobeConverted.add("Housing_Approval_Authority");
tobeConverted.add("Enter_Housing_Approval_Authority");

tobeConverted.add("Housing_Approval_Plan_Number");
tobeConverted.add("Enter_Housing_Approval_Plan_Number");

tobeConverted.add("Project_Approval_Authority");
tobeConverted.add("Enter_Project_Approval_Authority");

tobeConverted.add("Project_Approval_Plan_Number");
tobeConverted.add("Enter_Project_Approval_Plan_Number");

tobeConverted.add("Total_Builtup_Area");
tobeConverted.add("Enter_Total_Builtup_Area");

tobeConverted.add("No_Of_Buildings");
tobeConverted.add("Enter_No_Of_Buildings");

tobeConverted.add("Type_Of_Work");
tobeConverted.add("Select_Type_Of_Work");

tobeConverted.add("Estimated_Sand_Requirement");
tobeConverted.add("Enter_Estimated_Sand_Requirement");

tobeConverted.add("Approved_Sand_Qunatity");
tobeConverted.add("Enter_Approved_Sand_Qunatity");

tobeConverted.add("No_Records_Found");
tobeConverted.add("Clear_Filter_Data");
tobeConverted.add("Add");
tobeConverted.add("SLNO");
tobeConverted.add("Cancel");
tobeConverted.add("Save");

tobeConverted.add("Identity_Proof_No");
tobeConverted.add("Enter_Identity_Proof_No");
tobeConverted.add("Consumer_Application_No");

tobeConverted.add("Set_Location");
tobeConverted.add("Work_Location_On_Map");
tobeConverted.add("Remaining_Qunatity"); 
tobeConverted.add("Created_Time");

ArrayList<String> convertedWords = new ArrayList<String>();
convertedWords = cf.getLanguageSpecificWordForKey(tobeConverted,language);

String ConsumerEnrolmentForm=convertedWords.get(0);
String ConsumerDetails=convertedWords.get(1);

String CustomerName=convertedWords.get(2);
String SelectCustomer=convertedWords.get(3);

String ConsumerType=convertedWords.get(4);
String SelectConsumerType=convertedWords.get(5);

String District=convertedWords.get(6);
String SelectDistrict=convertedWords.get(7);

String Taluka=convertedWords.get(8);
String SelectTaluka=convertedWords.get(9);

String Village=convertedWords.get(10);
String EnterVillage=convertedWords.get(11);

String MobileNo=convertedWords.get(12);
String EnterMobileNo=convertedWords.get(13);

String EmailId=convertedWords.get(14);
String EnterEmailId=convertedWords.get(15);

String Address=convertedWords.get(16);
String EnterAddress=convertedWords.get(17);

String IdentityProofType=convertedWords.get(18);
String SelectIdentityProofType=convertedWords.get(19);

String SandConsumerName=convertedWords.get(20);
String EnterSandConsumerName=convertedWords.get(21);

String ProjectName=convertedWords.get(22);
String EnterProjectName=convertedWords.get(23);

String ProjectDurationFrom=convertedWords.get(24);
String SelectProjectDurationFrom=convertedWords.get(25);

String ProjectDurationTo=convertedWords.get(26);
String SelectProjectDurationTo=convertedWords.get(27);

String ContractorName=convertedWords.get(28);
String EnterContractorName=convertedWords.get(29);

String GovernmentDeptName=convertedWords.get(30);
String EnterGovernmentDeptName=convertedWords.get(31);

String DeptContactName=convertedWords.get(32);
String EnterDeptContactName=convertedWords.get(33);

String WorkLocation=convertedWords.get(34);
String EnterWorkLocation=convertedWords.get(35);

String WorkLocationDetails=convertedWords.get(36);
String SameAsAbove=convertedWords.get(37);
String WorkDetails=convertedWords.get(38);

String HousingApprovalAuthority=convertedWords.get(39);
String EnterHousingApprovalAuthority=convertedWords.get(40);

String HousingApprovalPlanNumber=convertedWords.get(41);
String EnterHousingApprovalPlanNumber=convertedWords.get(42);

String ProjectApprovalAuthority=convertedWords.get(43);
String EnterProjectApprovalAuthority=convertedWords.get(44);

String ProjectApprovalPlanNumber=convertedWords.get(45);
String EnterProjectApprovalPlanNumber=convertedWords.get(46);

String TotalBuiltupArea=convertedWords.get(47);
String EnterTotalBuiltupArea=convertedWords.get(48);

String NoOfBuildings=convertedWords.get(49);
String EnterNoOfBuildings=convertedWords.get(50);

String TypeOfWork=convertedWords.get(51);
String SelectTypeOfWork=convertedWords.get(52);

String EstimatedSandRequirement=convertedWords.get(53);
String EnterEstimatedSandRequirement=convertedWords.get(54);

String ApprovedSandQunatity=convertedWords.get(55);
String EnterApprovedSandQunatity=convertedWords.get(56);

String NoRecordsFound=convertedWords.get(57);
String ClearFilterData=convertedWords.get(58);
String Add=convertedWords.get(59);
String SLNO=convertedWords.get(60);
String Cancel=convertedWords.get(61);
String Save=convertedWords.get(62);

String IdentityProofNo=convertedWords.get(63);
String EnterIdentityProofNo=convertedWords.get(64);
String ConsumerApplicationNo=convertedWords.get(65);

String SetLocation=convertedWords.get(66);
String WorkLocationOnMap=convertedWords.get(67);
String RemainingQunatity=convertedWords.get(68);
String CreatedDate=convertedWords.get(69);

%>

<!DOCTYPE HTML>
<html>
 <head>
 		<title><%=ConsumerEnrolmentForm%></title>	
 		  
</head>	    
	 <style>
  .x-panel-tl
	{
		border-bottom: 0px solid !important;
	}
  </style>
  <body>
   <%if (loginInfo.getStyleSheetOverride().equals("Y")){%>
	<jsp:include page="../Common/ImportJSSandMining.jsp"/>
	<%}else{%>
	<jsp:include page="../Common/ImportJS.jsp" /><%}%>
   <jsp:include page="../Common/ExportJS.jsp" />
        <pack:style src="../../Main/resources/css/LovCombo/Ext.ux.form.LovCombo.css"></pack:style>
	  	<pack:style src="../../Main/resources/css/LovCombo/empty.css"></pack:style>
	  	<pack:style src="../../Main/resources/css/LovCombo/lovcombo.css"></pack:style>
	  	<pack:script src="../../Main/Js/LovCombo/Ext.ux.form.LovCombo.js"></pack:script>
	  	<pack:script src="../../Main/Js/LovCombo/Ext.ux.ThemeCombo.js"></pack:script>
   <script>
var outerPanel;
var exportDataType="int,string,string,string,string,string,string,string,string,string,string,string,date,date,string,string,string,string,string,string,string,string,string,number,number,number,date,string,string,string,string,string";
var jspName = "ConsumerEnrolmentForm";
var grid;
var buttonValue;
var titelForInnerPanel;
var myWin;
var ESR;
var setLocation="false";
var curdate=datecur;
var nexdate=datenext;
var check='YES';
var myWinInactive;
var titleForOTP;
var pdfAppNo ='';
var pdfMobileNo ='';
var pdfConsumerName ='';
var pdfConsumerType ='';
var pdfStockYard ='';
var pdfReqQty ='';
var pdfWorkLocation='';
var pdfIdProofType='';
var pdfIdProof='';
var pdfApprovedQty='';
var titelForInnerPdfPanel;
var myPdfWin;

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
                store.load({
                    params: {
                        CustId: custId,
                        jspName:jspName,
                        custName:Ext.getCmp('custcomboId').getRawValue(),
                        endDate:Ext.getCmp('enddate').getValue(),
                        startDate:Ext.getCmp('startdate').getValue()
                    }
                });
                districtComboStore.load({
                    params: {

                    }
                });
                talukatstore.load({
                    params: {

                    }
                });
            }
        }
    }
});


  var startdate = new Ext.form.DateField({
            fieldLabel: '',
            cls: 'selectstyle',
            format: getDateFormat(),
            emptyText: '',
            allowBlank: false,
            blankText: '',
            submitFormat: getDateTimeFormat(),
            labelSeparator: '',
            allowBlank: false,
            id: 'startdate',
            value: curdate
           });




        var enddate = new Ext.form.DateField({
            fieldLabel: '',
            cls: 'selectstyle',
            format: getDateFormat(),
            emptyText: '',
            allowBlank: false,
            blankText: '',
            submitFormat: getDateFormat(),
            labelSeparator: '',
            allowBlank: false,
            id: 'enddate',
            value: nexdate
            });

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
                custId = Ext.getCmp('custcomboId').getValue();
                store.load({
                    params: {
                        CustId: custId,
                        jspName:jspName,
                        custName:Ext.getCmp('custcomboId').getRawValue(),
                        endDate:Ext.getCmp('enddate').getValue(),
                        startDate:Ext.getCmp('startdate').getValue()
                        
                    }
                });
                districtComboStore.load({
                    params: {

                    }
                });
                talukatstore.load({
                    params: {

                    }
                });
            }
        }
    }
});

var consumerTypeStore = new Ext.data.SimpleStore({
    id: 'consumerTypeId',
    autoLoad: true,
    fields: ['Name', 'Value'],
    data: [
        ['Public', 'Public'],
        ['Contractor', 'Contractor'],
        ['Government', 'Government'],
        ['Ashraya', 'Ashraya']
    ]
});
 
var consumerTypeCombo = new Ext.form.ComboBox({
    store: consumerTypeStore,
    id: 'consumerTypeComboId',
    mode: 'local',
    forceSelection: true,
    selectOnFocus: true,
    allowBlank: false,
    anyMatch: true,
    typeAhead: false,
    triggerAction: 'all',
    lazyRender: true,
    valueField: 'Value',
    emptyText: '<%=SelectConsumerType%>',
    displayField: 'Name',
    cls: 'selectstylePerfect',
    listeners: {
        select: {
            fn: function() {

                Ext.getCmp('districtcomboId').reset();
                Ext.getCmp('talukacomboid').reset();
                Ext.getCmp('villageId').reset();
                Ext.getCmp('mobileNoId').reset();
                Ext.getCmp('emailIdId').reset();
                Ext.getCmp('addressId').reset();
                Ext.getCmp('identityProofTypeId').reset();
                Ext.getCmp('identityProofNoId').reset();
                Ext.getCmp('sandConsumerNameId').reset();
                Ext.getCmp('contractorNameId').reset();
                Ext.getCmp('projectNameId').reset();
                Ext.getCmp('projectDurationFromId').reset();
                Ext.getCmp('projectDurationToId').reset();
                Ext.getCmp('governmentDeptNameId').reset();
                Ext.getCmp('deptContactNameId').reset();
                Ext.getCmp('housingApprovalAuthorityId').reset();
                Ext.getCmp('housingApprovalPlanNumberId').reset();
                Ext.getCmp('projectApprovalAuthorityId').reset();
                Ext.getCmp('projectApprovalPlanNumberId').reset();
                Ext.getCmp('totalBuiltupAreaId').reset();
                Ext.getCmp('estimatedSandRequirementId').reset();
                Ext.getCmp('approvedSandQunatityId').reset();
                Ext.getCmp('typeOfWorkId').reset();
                Ext.getCmp('noOfBuildingsId').reset();
                Ext.getCmp('districtcombo2Id').reset();
                Ext.getCmp('talukacombo2id').reset();
                Ext.getCmp('village2Id').reset();
                Ext.getCmp('address2Id').reset();
                Ext.getCmp('emailIdId').setValue(' ');
				Ext.getCmp('propertyAssessmentNumberId').reset();
				
<!--				if(<%=isModelCKM%>){-->
<!--					-->
<!--					 Ext.getCmp('propertyAssessmentMandatoryId').show();-->
<!--					 Ext.getCmp('propertyAssessmentLabelId').show();-->
<!--					 Ext.getCmp('propertyAssessmentNumberId').show();-->
<!--					 Ext.getCmp('propertyAssessmentBlankId').show();-->
<!--					-->
<!--				}-->
				
				Ext.getCmp('propertyAssessmentMandatoryId').show();
					 Ext.getCmp('propertyAssessmentLabelId').show();
					 Ext.getCmp('propertyAssessmentNumberId').show();
					 Ext.getCmp('propertyAssessmentBlankId').show();
					 
			   if(<%=isAadharMandatory%>){
					    Ext.getCmp('identityProofTypeId').setValue('AADHAR'); 
						Ext.getCmp('identityProofTypeId').readOnly = true;
					}else{
						Ext.getCmp('identityProofTypeId').readOnly = false;
					}

                if (Ext.getCmp('consumerTypeComboId').getRawValue() == "Public" || Ext.getCmp('consumerTypeComboId').getRawValue() == "Ashraya") {

                    Ext.getCmp('projectNameEmptyId1').hide();
                    Ext.getCmp('projectNameLabelId').hide();
                    Ext.getCmp('projectNameId').hide();
                    Ext.getCmp('projectNameEmptyId2').hide();

                    Ext.getCmp('projectDurationFromEmptyId1').hide();
                    Ext.getCmp('projectDurationFromLabelId').hide();
                    Ext.getCmp('projectDurationFromId').hide();
                    Ext.getCmp('projectDurationFromId2').hide();

                    Ext.getCmp('projectDurationToEmptyId1').hide();
                    Ext.getCmp('projectDurationToLabelId').hide();
                    Ext.getCmp('projectDurationToId').hide();
                    Ext.getCmp('projectDurationToEmptyId2').hide();

                    Ext.getCmp('contractorNameEmptyId1').hide();
                    Ext.getCmp('contractorNameLabelId').hide();
                    Ext.getCmp('contractorNameId').hide();
                    Ext.getCmp('contractorNameEmptyId2').hide();

                    Ext.getCmp('projectApprovalAuthorityEmptyId1').hide();
                    Ext.getCmp('projectApprovalAuthorityLabelId').hide();
                    Ext.getCmp('projectApprovalAuthorityId').hide();
                    Ext.getCmp('projectApprovalAuthorityEmptyId2').hide();

                    Ext.getCmp('projectApprovalPlanNumberEmptyId1').hide();
                    Ext.getCmp('projectApprovalPlanNumberLabelId').hide();
                    Ext.getCmp('projectApprovalPlanNumberId').hide();
                    Ext.getCmp('projectApprovalPlanNumberEmptyId2').hide();

                    Ext.getCmp('governmentDeptNameEmptyId1').hide();
                    Ext.getCmp('governmentDeptNameLabelId').hide();
                    Ext.getCmp('governmentDeptNameId').hide();
                    Ext.getCmp('governmentDeptNameEmptyId2').hide();

                    Ext.getCmp('deptContactNameEmptyId1').hide();
                    Ext.getCmp('deptContactNameLabelId').hide();
                    Ext.getCmp('deptContactNameId').hide();
                    Ext.getCmp('deptContactNameEmptyId2').hide();
                    
                    
<!--					if(<%=isModelCKM%>){-->
<!--						talukatstore.load({-->
<!--							params: {-->
<!--								districtId: 11-->
<!--							}-->
<!--						});-->
<!--                -->
<!--						Ext.getCmp('districtcomboId').setRawValue('CHIKMAGALUR');-->
<!--						Ext.getCmp('districtcomboId').setValue('11');-->
<!--						-->
<!--						Ext.getCmp('districtcomboId').readOnly = true;-->
<!--						-->
<!--						Ext.getCmp('districtcombo3Id').setRawValue('CHIKMAGALUR');-->
<!--						Ext.getCmp('districtcombo3Id').setValue('11');-->
<!--						-->
<!--						Ext.getCmp('districtcombo3Id').readOnly = true;-->
<!--						-->
<!--						Ext.getCmp('identityProofTypeId').setValue('ADHAAR');-->
<!--						Ext.getCmp('identityProofTypeId').readOnly = true;-->
<!--						-->
<!--						-->
<!--						-->
<!--						Ext.getCmp('tpComboId').setValue('0');-->
<!--						Ext.getCmp('tpComboId').hide();-->
<!--						Ext.getCmp('tpid1').hide();-->
<!--						Ext.getCmp('tpid2').hide();-->
<!--						Ext.getCmp('tpid3').hide();-->
<!--						-->
<!--						Ext.getCmp('MoreDetailspanelId').show();-->
<!--												  -->
<!--						 Ext.getCmp('housingApprovalAuthorityEmptyId1').show();-->
<!--						 Ext.getCmp('housingApprovalAuthorityLabelId').show();-->
<!--						 Ext.getCmp('housingApprovalAuthorityId').show();-->
<!--						 Ext.getCmp('housingApprovalAuthorityEmptyId2').show();-->
<!--						 -->
<!--						  Ext.getCmp('housingApprovalAuthorityId').setValue('');-->
<!--						  -->
<!--						 Ext.getCmp('housingApprovalPlanNumberEmptyId1').show();-->
<!--						 Ext.getCmp('housingApprovalPlanNumberLabelId').show();-->
<!--						 Ext.getCmp('housingApprovalPlanNumberId').show();-->
<!--						 Ext.getCmp('housingApprovalPlanNumberEmptyId2').show();-->
<!--						 -->
<!--						  Ext.getCmp('housingApprovalPlanNumberId').setValue('');-->
<!--					-->
<!--					}-->
                    
                    
<!--                    if(!<%=ConsumerMDPstate%>)-->
<!--					{-->
<!--						-->
<!--					-->
<!--	                    Ext.getCmp('housingApprovalAuthorityEmptyId1').show();-->
<!--	                    Ext.getCmp('housingApprovalAuthorityLabelId').show();-->
<!--	                    Ext.getCmp('housingApprovalAuthorityId').show();-->
<!--	                    Ext.getCmp('housingApprovalAuthorityEmptyId2').show();-->
<!--	-->
<!--	                    Ext.getCmp('housingApprovalPlanNumberEmptyId1').show();-->
<!--	                    Ext.getCmp('housingApprovalPlanNumberLabelId').show();-->
<!--	                    Ext.getCmp('housingApprovalPlanNumberId').show();-->
<!--	                    Ext.getCmp('housingApprovalPlanNumberId').show();-->
<!--					}-->
						Ext.getCmp('housingApprovalAuthorityEmptyId1').show();
	                    Ext.getCmp('housingApprovalAuthorityLabelId').show();
	                    Ext.getCmp('housingApprovalAuthorityId').show();
	                    Ext.getCmp('housingApprovalAuthorityEmptyId2').show();
	
	                    Ext.getCmp('housingApprovalPlanNumberEmptyId1').show();
	                    Ext.getCmp('housingApprovalPlanNumberLabelId').show();
	                    Ext.getCmp('housingApprovalPlanNumberId').show();
	                    Ext.getCmp('housingApprovalPlanNumberId').show();
	                    
                    Ext.getCmp('sandConsumerNameEmptyId1').show();
                    Ext.getCmp('sandConsumerNameLabelId').show();
                    Ext.getCmp('sandConsumerNameId').show();
                    Ext.getCmp('sandConsumerNameEmptyId2').show();


                }

                if (Ext.getCmp('consumerTypeComboId').getRawValue() == "Contractor") {
					
<!--					if(<%=isModelCKM%>){-->
<!--						talukatstore.load({-->
<!--							params: {-->
<!--								districtId: 11-->
<!--							}-->
<!--						});-->
<!--						-->
<!--						Ext.getCmp('tpComboId').setValue('0');-->
<!--						Ext.getCmp('tpComboId').hide();-->
<!--						Ext.getCmp('tpid1').hide();-->
<!--						Ext.getCmp('tpid2').hide();-->
<!--						Ext.getCmp('tpid3').hide();-->
<!--                -->
<!--						Ext.getCmp('districtcomboId').setRawValue('CHIKMAGALUR');-->
<!--						Ext.getCmp('districtcomboId').setValue('11');-->
<!--						Ext.getCmp('districtcomboId').readOnly = true;-->
<!--						-->
<!--						Ext.getCmp('districtcombo3Id').setRawValue('CHIKMAGALUR');-->
<!--						Ext.getCmp('districtcombo3Id').setValue('11');-->
<!--						Ext.getCmp('districtcombo3Id').readOnly = true;-->
<!--						-->
<!--						Ext.getCmp('identityProofTypeId').readOnly = false;-->
<!--						-->
<!--						Ext.getCmp('projectApprovalAuthorityEmptyId1').show();-->
<!--						Ext.getCmp('projectApprovalAuthorityLabelId').show();-->
<!--						Ext.getCmp('projectApprovalAuthorityId').show();-->
<!--						Ext.getCmp('projectApprovalAuthorityEmptyId2').show();-->
<!---->
<!--						Ext.getCmp('projectApprovalPlanNumberEmptyId1').show();-->
<!--						Ext.getCmp('projectApprovalPlanNumberLabelId').show();-->
<!--						Ext.getCmp('projectApprovalPlanNumberId').show();-->
<!--						Ext.getCmp('projectApprovalPlanNumberEmptyId2').show();-->
<!--					}-->

                    Ext.getCmp('sandConsumerNameId').hide();
                    Ext.getCmp('sandConsumerNameLabelId').hide();
                    Ext.getCmp('sandConsumerNameEmptyId1').hide();
                    Ext.getCmp('sandConsumerNameEmptyId2').hide();

                    Ext.getCmp('projectNameEmptyId1').show();
                    Ext.getCmp('projectNameLabelId').show();
                    Ext.getCmp('projectNameId').show();
                    Ext.getCmp('projectNameEmptyId2').show();

                    Ext.getCmp('projectDurationFromEmptyId1').show();
                    Ext.getCmp('projectDurationFromLabelId').show();
                    Ext.getCmp('projectDurationFromId').show();
                    Ext.getCmp('projectDurationFromId2').show();

                    Ext.getCmp('projectDurationToEmptyId1').show();
                    Ext.getCmp('projectDurationToLabelId').show();
                    Ext.getCmp('projectDurationToId').show();
                    Ext.getCmp('projectDurationToEmptyId2').show();

                    Ext.getCmp('contractorNameEmptyId1').show();
                    Ext.getCmp('contractorNameLabelId').show();
                    Ext.getCmp('contractorNameId').show();
                    Ext.getCmp('contractorNameEmptyId2').show();
					
<!--					if(!<%=ConsumerMDPstate%>){-->
<!--                    Ext.getCmp('projectApprovalAuthorityEmptyId1').show();-->
<!--                    Ext.getCmp('projectApprovalAuthorityLabelId').show();-->
<!--                    Ext.getCmp('projectApprovalAuthorityId').show();-->
<!--                    Ext.getCmp('projectApprovalAuthorityEmptyId2').show();-->
<!---->
<!--                    Ext.getCmp('projectApprovalPlanNumberEmptyId1').show();-->
<!--                    Ext.getCmp('projectApprovalPlanNumberLabelId').show();-->
<!--                    Ext.getCmp('projectApprovalPlanNumberId').show();-->
<!--                    Ext.getCmp('projectApprovalPlanNumberEmptyId2').show();-->
<!--					}-->
					Ext.getCmp('projectApprovalAuthorityEmptyId1').show();
                    Ext.getCmp('projectApprovalAuthorityLabelId').show();
                    Ext.getCmp('projectApprovalAuthorityId').show();
                    Ext.getCmp('projectApprovalAuthorityEmptyId2').show();

                    Ext.getCmp('projectApprovalPlanNumberEmptyId1').show();
                    Ext.getCmp('projectApprovalPlanNumberLabelId').show();
                    Ext.getCmp('projectApprovalPlanNumberId').show();
                    Ext.getCmp('projectApprovalPlanNumberEmptyId2').show();
					
                    Ext.getCmp('governmentDeptNameEmptyId1').hide();
                    Ext.getCmp('governmentDeptNameLabelId').hide();
                    Ext.getCmp('governmentDeptNameId').hide();
                    Ext.getCmp('governmentDeptNameEmptyId2').hide();

                    Ext.getCmp('deptContactNameEmptyId1').hide();
                    Ext.getCmp('deptContactNameLabelId').hide();
                    Ext.getCmp('deptContactNameId').hide();
                    Ext.getCmp('deptContactNameEmptyId2').hide();

                    Ext.getCmp('housingApprovalAuthorityEmptyId1').hide();
                    Ext.getCmp('housingApprovalAuthorityLabelId').hide();
                    Ext.getCmp('housingApprovalAuthorityId').hide();
                    Ext.getCmp('housingApprovalAuthorityEmptyId2').hide();

                    Ext.getCmp('housingApprovalPlanNumberEmptyId1').hide();
                    Ext.getCmp('housingApprovalPlanNumberLabelId').hide();
                    Ext.getCmp('housingApprovalPlanNumberId').hide();
                    Ext.getCmp('housingApprovalPlanNumberId').hide();

                    Ext.getCmp('sandConsumerNameEmptyId1').hide();
                    Ext.getCmp('sandConsumerNameLabelId').hide();
                    Ext.getCmp('sandConsumerNameId').hide();
                    Ext.getCmp('sandConsumerNameEmptyId2').hide();

                }
                if (Ext.getCmp('consumerTypeComboId').getRawValue() == "Government") {
					
<!--					if(<%=isModelCKM%>){-->
<!--						talukatstore.load({-->
<!--							params: {-->
<!--								districtId: 11-->
<!--							}-->
<!--						});-->
<!--						-->
<!--						Ext.getCmp('tpComboId').setValue('0');-->
<!--						Ext.getCmp('tpComboId').hide();-->
<!--						Ext.getCmp('tpid1').hide();-->
<!--						Ext.getCmp('tpid2').hide();-->
<!--						Ext.getCmp('tpid3').hide();-->
<!--                -->
<!--						Ext.getCmp('districtcomboId').setRawValue('CHIKMAGALUR');-->
<!--						Ext.getCmp('districtcomboId').setValue('11');-->
<!--						Ext.getCmp('districtcomboId').readOnly = true;-->
<!--						-->
<!--						Ext.getCmp('districtcombo3Id').setRawValue('CHIKMAGALUR');-->
<!--						Ext.getCmp('districtcombo3Id').setValue('11');-->
<!--						Ext.getCmp('districtcombo3Id').readOnly = true;-->
<!--						-->
<!--						Ext.getCmp('identityProofTypeId').readOnly = false;-->
<!--						-->
<!--						Ext.getCmp('projectApprovalAuthorityEmptyId1').show();-->
<!--						Ext.getCmp('projectApprovalAuthorityLabelId').show();-->
<!--						Ext.getCmp('projectApprovalAuthorityId').show();-->
<!--						Ext.getCmp('projectApprovalAuthorityEmptyId2').show();-->
<!---->
<!--						Ext.getCmp('projectApprovalPlanNumberEmptyId1').show();-->
<!--						Ext.getCmp('projectApprovalPlanNumberLabelId').show();-->
<!--						Ext.getCmp('projectApprovalPlanNumberId').show();-->
<!--						Ext.getCmp('projectApprovalPlanNumberEmptyId2').show();-->
<!--					}-->

                    Ext.getCmp('sandConsumerNameId').hide();
                    Ext.getCmp('sandConsumerNameLabelId').hide();
                    Ext.getCmp('sandConsumerNameEmptyId1').hide();
                    Ext.getCmp('sandConsumerNameEmptyId2').hide();

                    Ext.getCmp('contractorNameEmptyId1').hide();
                    Ext.getCmp('contractorNameLabelId').hide();
                    Ext.getCmp('contractorNameId').hide();
                    Ext.getCmp('contractorNameEmptyId2').hide();

                    Ext.getCmp('projectNameEmptyId1').show();
                    Ext.getCmp('projectNameLabelId').show();
                    Ext.getCmp('projectNameId').show();
                    Ext.getCmp('projectNameEmptyId2').show();

                    Ext.getCmp('projectDurationFromEmptyId1').show();
                    Ext.getCmp('projectDurationFromLabelId').show();
                    Ext.getCmp('projectDurationFromId').show();
                    Ext.getCmp('projectDurationFromId2').show();

                    Ext.getCmp('projectDurationToEmptyId1').show();
                    Ext.getCmp('projectDurationToLabelId').show();
                    Ext.getCmp('projectDurationToId').show();
                    Ext.getCmp('projectDurationToEmptyId2').show();
                    
<!--					if(!<%=ConsumerMDPstate%>){-->
<!--                    Ext.getCmp('projectApprovalAuthorityEmptyId1').show();-->
<!--                    Ext.getCmp('projectApprovalAuthorityLabelId').show();-->
<!--                    Ext.getCmp('projectApprovalAuthorityId').show();-->
<!--                    Ext.getCmp('projectApprovalAuthorityEmptyId2').show();-->
<!---->
<!--                    Ext.getCmp('projectApprovalPlanNumberEmptyId1').show();-->
<!--                    Ext.getCmp('projectApprovalPlanNumberLabelId').show();-->
<!--                    Ext.getCmp('projectApprovalPlanNumberId').show();-->
<!--                    Ext.getCmp('projectApprovalPlanNumberEmptyId2').show();-->
<!--					}-->
					Ext.getCmp('projectApprovalAuthorityEmptyId1').show();
                    Ext.getCmp('projectApprovalAuthorityLabelId').show();
                    Ext.getCmp('projectApprovalAuthorityId').show();
                    Ext.getCmp('projectApprovalAuthorityEmptyId2').show();

                    Ext.getCmp('projectApprovalPlanNumberEmptyId1').show();
                    Ext.getCmp('projectApprovalPlanNumberLabelId').show();
                    Ext.getCmp('projectApprovalPlanNumberId').show();
                    Ext.getCmp('projectApprovalPlanNumberEmptyId2').show();
					
                    Ext.getCmp('governmentDeptNameEmptyId1').show();
                    Ext.getCmp('governmentDeptNameLabelId').show();
                    Ext.getCmp('governmentDeptNameId').show();
                    Ext.getCmp('governmentDeptNameEmptyId2').show();

                    Ext.getCmp('deptContactNameEmptyId1').show();
                    Ext.getCmp('deptContactNameLabelId').show();
                    Ext.getCmp('deptContactNameId').show();
                    Ext.getCmp('deptContactNameEmptyId2').show();

                    Ext.getCmp('housingApprovalAuthorityEmptyId1').hide();
                    Ext.getCmp('housingApprovalAuthorityLabelId').hide();
                    Ext.getCmp('housingApprovalAuthorityId').hide();
                    Ext.getCmp('housingApprovalAuthorityEmptyId2').hide();

                    Ext.getCmp('housingApprovalPlanNumberEmptyId1').hide();
                    Ext.getCmp('housingApprovalPlanNumberLabelId').hide();
                    Ext.getCmp('housingApprovalPlanNumberId').hide();
                    Ext.getCmp('housingApprovalPlanNumberId').hide();

                    Ext.getCmp('sandConsumerNameEmptyId1').hide();
                    Ext.getCmp('sandConsumerNameLabelId').hide();
                    Ext.getCmp('sandConsumerNameId').hide();
                    Ext.getCmp('sandConsumerNameEmptyId2').hide();

                }
            }
        }
    }
});

var districtComboStore = new Ext.data.JsonStore({
    url: '<%=request.getContextPath()%>/SandBlockManagementAction.do?param=getDistirctListForConsumer',
    id: 'distStoreId',
    root: 'distRoot',
    autoload: false,
    remoteSort: true,
    fields: ['distID', 'distName'],
    listeners: {
        load: function() {}
    }
});
var districtCombo = new Ext.form.ComboBox({
    store: districtComboStore,
    id: 'districtcomboId',
    mode: 'local',
    forceSelection: true,
    emptyText: '<%=SelectDistrict%>',
    blankText: '<%=SelectDistrict%>',
    selectOnFocus: true,
    allowBlank: true,
    anyMatch: true,
    typeAhead: false,
    triggerAction: 'all',
    lazyRender: true,
    valueField: 'distID',
    displayField: 'distName',
    cls: 'selectstylePerfect',
    listeners: {
        select: {
            fn: function() {
				
                Ext.getCmp('talukacomboid').reset();
              
				
<!--				if(!<%=isModelCKM%>){-->
<!--				   talukatstore.load({-->
<!--						params: {-->
<!--							districtId: Ext.getCmp('districtcomboId').getValue()-->
<!--						}-->
<!--					});-->
<!--				}-->
				talukatstore.load({
						params: {
							districtId: Ext.getCmp('districtcomboId').getValue()
						}
					});
				
            }
        }
    }
});
var districtCombo2 = new Ext.form.ComboBox({
    store: districtComboStore,
    id: 'districtcombo2Id',
    mode: 'local',
    forceSelection: true,
    emptyText: '<%=SelectDistrict%>',
    blankText: '<%=SelectDistrict%>',
    selectOnFocus: true,
    allowBlank: true,
    anyMatch: true,
    typeAhead: false,
    triggerAction: 'all',
    lazyRender: true,
    valueField: 'distID',
    displayField: 'distName',
    cls: 'selectstylePerfect',
    listeners: {
        select: {
            fn: function() {
                Ext.getCmp('talukacombo2id').reset();
                talukatstore.load({
                    params: {
                        districtId: Ext.getCmp('districtcombo2Id').getValue()
                    }
                });
                
               
            }
        }
    }
});

var districtCombo3 = new Ext.form.ComboBox({
    store: districtComboStore,
    id: 'districtcombo3Id',
    mode: 'local',
    forceSelection: true,
    emptyText: '<%=SelectDistrict%>',
    blankText: '<%=SelectDistrict%>',
    selectOnFocus: true,
    allowBlank: true,
    anyMatch: true,
    typeAhead: false,
    triggerAction: 'all',
    lazyRender: true,
    valueField: 'distID',
    displayField: 'distName',
    cls: 'selectstylePerfect',
    listeners: {
        select: {
            fn: function() {
                Ext.getCmp('talukacombo3id').reset();
<!--				if(!<%=isModelCKM%>){-->
<!--					talukatstore.load({-->
<!--						params: {-->
<!--							districtId: Ext.getCmp('districtcombo3Id').getValue()-->
<!--						}-->
<!--					});-->
<!--				}-->
				talukatstore.load({
						params: {
							districtId: Ext.getCmp('districtcombo3Id').getValue()
						}
					});
		    }
        }
    }
});


var talukatstore = new Ext.data.JsonStore({
    url: '<%=request.getContextPath()%>/SandBlockManagementAction.do?param=getTaluka',
    id: 'talukaId',
    root: 'talukaRoot',
    autoLoad: false,
    remoteSort: true,
    fields: ['TalukaId', 'TalukaName']
});

var Talukacombo = new Ext.form.ComboBox({
    store: talukatstore,
    id: 'talukacomboid',
    mode: 'local',
    forceSelection: true,
    emptyText: '<%=SelectTaluka%>',
    selectOnFocus: true,
    allowBlank: false,
    anyMatch: true,
    typeAhead: false,
    triggerAction: 'all',
    lazyRender: true,
    valueField: 'TalukaId',
    displayField: 'TalukaName',
    cls: 'selectstylePerfect',
    listeners: {
        select: {
            fn: function() {}
        }
    }
});
var Talukacombo2 = new Ext.form.ComboBox({
    store: talukatstore,
    id: 'talukacombo2id',
    mode: 'local',
    forceSelection: true,
    emptyText: '<%=SelectTaluka%>',
    selectOnFocus: true,
    allowBlank: false,
    anyMatch: true,
    typeAhead: false,
    triggerAction: 'all',
    lazyRender: true,
    valueField: 'TalukaId',
    displayField: 'TalukaName',
    cls: 'selectstylePerfect',
    listeners: {
        select: {
            fn: function() {}
        }
    }
});

var Talukacombo3 = new Ext.form.ComboBox({
    store: talukatstore,
    id: 'talukacombo3id',
    mode: 'local',
    forceSelection: true,
    emptyText: '<%=SelectTaluka%>',
    selectOnFocus: true,
    allowBlank: false,
    anyMatch: true,
    typeAhead: false,
    triggerAction: 'all',
    lazyRender: true,
    valueField: 'TalukaId',
    displayField: 'TalukaName',
    cls: 'selectstylePerfect',
    listeners: {
        select: {
            fn: function() {
				
				
<!--				if(<%=isModelCKM%>){-->
<!--					Ext.getCmp('stockyardComboId').reset();-->
<!--					stockyardStore.load({-->
<!--						params: {-->
<!--							districtId: Ext.getCmp('districtcombo3Id').getValue(),-->
<!--							sandTalukNameValue: Ext.getCmp('talukacombo3id').getValue(),-->
<!--							sandTalukName: Ext.getCmp('talukacombo3id').getRawValue(),-->
<!--							-->
<!--						}-->
<!--					});-->
<!--				}-->
				Ext.getCmp('stockyardComboId').reset();
					stockyardStore.load({
						params: {
							districtId: Ext.getCmp('districtcombo3Id').getValue(),
							sandTalukNameValue: Ext.getCmp('talukacombo3id').getValue(),
							sandTalukName: Ext.getCmp('talukacombo3id').getRawValue(),
							
						}
					});
			}
        }
    }
});

var tempPermitNoStore = new Ext.data.JsonStore({
    url: '<%=request.getContextPath()%>/ConsumerMDPGeneratorAction.do?param=getTempPermitNumbers',
    id: 'TempPermitNoStoreId',
    root: 'TempPermitNoRoot',
    autoLoad: false,
    remoteSort: true,
    fields: ['uniqueId', 'permitNo']
});

var TPCombo = new Ext.form.ComboBox({
    store: tempPermitNoStore,
    id: 'tpComboId',
    mode: 'local',
    forceSelection: true,
    emptyText: 'Select TP Number',
    selectOnFocus: true,
    allowBlank: false,
    anyMatch: true,
    typeAhead: false,
    triggerAction: 'all',
    lazyRender: true,
    displayField: 'permitNo',
    valueField: 'uniqueId',
    cls: 'selectstylePerfect',
    listeners: {
        select: {
            fn: function() {}
        }
    }
});


var stockyardStore = new Ext.data.JsonStore({
    url: '<%=request.getContextPath()%>/ConsumerMDPGeneratorAction.do?param=getStockyardsForConsumer',
    id: 'stockyardId',
    root: 'stockyardRoot',
    autoLoad: false,
    remoteSort: true,
    fields: ['stockyardIdValue', 'stockyardValue']
});

var stockyardCombo = new Ext.form.ComboBox({
    store: stockyardStore,
    id: 'stockyardComboId',
    mode: 'local',
    forceSelection: true,
    emptyText: 'Select stockyard',
    selectOnFocus: true,
    allowBlank: false,
    anyMatch: true,
    typeAhead: false,
    triggerAction: 'all',
    lazyRender: true,
    displayField: 'stockyardValue',
    valueField: 'stockyardIdValue',
    cls: 'selectstylePerfect',
    listeners: {
        select: {
            fn: function() {
            tempPermitNoStore.load({
						params: {
							stockyardId: Ext.getCmp('stockyardComboId').getValue(),
							
						}
					});
            }
        }
    }
});


var CheckPostStore = new Ext.data.JsonStore({
    url: '<%=request.getContextPath()%>/ConsumerMDPGeneratorAction.do?param=getCheckposts',
    id: 'CheckPostStoreId',
    root: 'CheckpostRoot',
    autoLoad: true,
    remoteSort: true,
    fields: ['checkpostsvalue']
});

var CheckPostCombo = new Ext.ux.form.LovCombo({
	    id: 'checkpostcomboId',
	    hidden:true,
	    emptyText: 'select Checkpost',
	    store: CheckPostStore,
	    displayField: 'checkpostsvalue',
    	valueField: 'checkpostsvalue',
	    mode: 'local',
	    forceSelection: true,
	    blankText: '',
	    lazyRender: true,
	    selectOnFocus: true,
	    allowBlank: true,
	    autoload: true,
	    anyMatch: true,
	    typeAhead: false,
	    triggerAction: 'all',
	   	multiSelect:true,
	   	beforeBlur: Ext.emptyFn
	});


//--------Radio Buttons
var RadioButtons = new Ext.Panel({
   		border:false,
   	  	title:'',
		standardSubmit: true,
		hidden:false,
		//width:300,
		id:'RadioButtonsId',
		layout:'table',
		layoutConfig: {columns:5},
		items:[
			
			{
			xtype:'radio',
			id:'LOButtonId',
			value:'LORADIO',
			checked: true,
		   // cls: 'myStyle',	
		    name:'optionX',
		    listeners:{
		        check:{fn:function(){
		        	if(this.checked){
		        	  check='YES';
		        	  Ext.getCmp('checkpostcomboId').show();
		        	}		// end of if	
				}           // end of function
			 }              // end of check
		   }                // end of listeners
		  },                // end of xtype
		  {
		  xtype:'label',
		  width:80,
		  text:'YES',
		  cls:'myStyle'
		  },
			{width:20},
			{
			xtype:'radio',
			id:'TOButtonId',
			value:'TORADIO',
			checked:false,
		   // cls: 'myStyle',	
		    name:'optionX',
		    listeners:{
		        check:{fn:function(){
		        	if(this.checked){
		        		 check='NO';
		        		 Ext.getCmp('checkpostcomboId').hide();
		        
		        	}		// end of if	
				}           // end of function
			 }              // end of check
		   }                // end of listeners
		  },                // end of xtype
		  {
		  xtype:'label',
		  width:20,
		  text:'NO',
		  cls:'myStyle'
		  }		  
		]
		});		


var identityProofTypeStore = new Ext.data.SimpleStore({
    id: 'identityProofTypeStoreId',
    autoLoad: true,
    fields: ['Name', 'Value'],
    data: [
        ['PAN', 'PAN'],
        ['TIN','TIN'],
        ['AADHAR', 'AADHAR'],
        ['EPIC', 'EPIC'],
        ['Passport', 'Passport'],
        ['Ration Card', 'Ration Card'],
        ['Driver License', 'Driver License']
    ]
});

var identityProofType = new Ext.form.ComboBox({
    store: identityProofTypeStore,
    id: 'identityProofTypeId',
    mode: 'local',
    forceSelection: true,
    selectOnFocus: true,
    allowBlank: false,
    anyMatch: true,
    typeAhead: false,
    triggerAction: 'all',
    lazyRender: true,
    emptyText: '<%=SelectIdentityProofType%>',
    valueField: 'Value',
    displayField: 'Name',
    cls: 'selectstylePerfect',
    listeners: {
        select: {
            fn: function() {}
        }
    }
});

var typeOfWorkStore = new Ext.data.SimpleStore({
    id: 'typeOfWorkStoreId',
    autoLoad: true,
    fields: ['Name', 'Value'],
    data: [
        ['Building Ground Floor', '1.2'],
        ['I Floor & Above', '0.8'],
        ['Concrete Road', '0.5'],
        ['Others', '1']
    ]
});

var typeOfWork = new Ext.form.ComboBox({
    store: typeOfWorkStore,
    id: 'typeOfWorkId',
    mode: 'local',
    forceSelection: true,
    selectOnFocus: true,
    allowBlank: false,
    anyMatch: true,
    typeAhead: false,
    triggerAction: 'all',
    lazyRender: true,
    emptyText: '<%=SelectTypeOfWork%>',
    valueField: 'Value',
    displayField: 'Name',
    cls: 'selectstylePerfect',
    listeners: {
        select: {
            fn: function() {
                var noOfBuildings = Ext.getCmp('noOfBuildingsId').getValue();
                var builtUpArea = Ext.getCmp('totalBuiltupAreaId').getValue();
                var qty = Ext.getCmp('typeOfWorkId').getValue();
                ESR = noOfBuildings * builtUpArea * qty;
                ESR = Math.ceil(ESR * 100) / 100;
                Ext.getCmp('estimatedSandRequirementId').setValue(ESR);
            }
        }
    }
});

//For Active Status
function modifyData() {
	if (Ext.getCmp('custcomboId').getValue() == "") {
           Ext.example.msg("Select Client Name");
           return;
       }
	if (grid.getSelectionModel().getCount() == 0) {
           Ext.example.msg("No row selected");
           return;
       }
     if (grid.getSelectionModel().getCount() > 1) {
          Ext.example.msg("Select single row");
           return;
       }
     buttonValue = 'Active';  
     var json = '';
     var selected = grid.getSelectionModel().getSelected();
     var appNoModify = selected.get('appNoDataIndex');
     var status = selected.get('statusIndex');
    if( status == 'Active'){
     	   Ext.example.msg("Consumer Is Already In Active Status");
           return;
    }
    Ext.MessageBox.confirm('Confirm', "Are You Sure Want To Active The Status. Continue...?", function(btn) {
    	if (btn == 'yes') {
    	outerPanel.getEl().mask();
    	Ext.Ajax.request({
	             url: '<%=request.getContextPath()%>/SandBlockManagementAction.do?param=activeOrInactiveDetails',
	             method: 'POST',
	             params: { 
	              	CustId: Ext.getCmp('custcomboId').getValue(), 
	                 appNoModify: appNoModify,
	                 buttonValue:buttonValue
	             },
	             success: function(response, options){             
                     var message = response.responseText;
                     Ext.example.msg(message);
                     json = '';
                     store.reload();
                     outerPanel.getEl().unmask();
	              }, 
	              failure: function(){
	                     store.reload();
                         outerPanel.getEl().unmask();
                         json = '';
	                 } // END OF FAILURE 
	         });
         }
    });
}

	  var innerPanelReject = new Ext.form.FormPanel({
		standardSubmit: true,
	    collapsible: false,    
	    autoScroll: true,    
	    height: 100,
	    width: '100%',
	    frame: true,	 
	    layout: 'table',
	    layoutConfig: {
	        columns: 3
	    },
	    items: [{
	            xtype: 'label',
	            text: '',
	            cls: 'mandatoryfield'	          
	        }, {
	            xtype: 'label',
	            text: 'Please Enter reason for Inactive : ',
	            cls: 'labelstyle'	           
	        },{
	        	xtype: 'textarea',	           
	            cls: 'selectstylePerfect',
	            height :40,
	            width : 50,
	            id:'testAreaReject'
	           }]
	});

var winButtonPanelReject = new Ext.Panel({
    id: 'winbuttonidRej',
    standardSubmit: true,
    collapsible: false,
    autoHeight: true,
    cls: 'windowbuttonpanel',
    frame: true,
    layout: 'table',
    layoutConfig: {
        columns: 2
    },
    buttons: [{
        xtype: 'button',
        text: 'Inactive',
        id:'myWinRejectButId',
        iconCls: 'savebutton',
        cls: 'buttonstyle',
        width: 80,
        listeners: {
            click: {
                fn: function() {
                 	var reasonForReject = Ext.getCmp('testAreaReject').getValue();
                    if (reasonForReject == "") {
                        Ext.example.msg("Please Enter Reason For Inactive");
                        Ext.getCmp('testAreaReject').focus();
                        return;
                    }
                    var selected = grid.getSelectionModel().getSelected();
     				var appNoModify = selected.get('appNoDataIndex');
                    outerPanelWindowReject.getEl().mask();
	    			 Ext.Ajax.request({
		             url: '<%=request.getContextPath()%>/SandBlockManagementAction.do?param=activeOrInactiveDetails',
		             method: 'POST',
		             params: {
		            	 CustId: Ext.getCmp('custcomboId').getValue(), 
		                 appNoModify: appNoModify,
		                 reasonForReject: reasonForReject,
		                 buttonValue:buttonValue
		             },
		             success: function(response, options){             
	                     var message = response.responseText;
	                     Ext.example.msg(message);
	                     json = '';
	                     store.reload();
	                     myWinInactive.hide();
	                     Ext.getCmp('testAreaReject').reset();
	                     outerPanelWindowReject.getEl().unmask();
		              }, 
		              failure: function(){
		                     store.reload();
		                     myWinInactive.hide();
	                         outerPanelWindowReject.getEl().unmask();
	                         json = '';
		                 } // END OF FAILURE 
		         });
 			 		
                }
            }
        }
    }, {
        xtype: 'button',
        text: 'Cancel',
        cls: 'buttonstyle',
        iconCls: 'cancelbutton',
        width: '80',
        listeners: {
            click: {
                fn: function() {    
                 Ext.getCmp('testAreaReject').reset();             
                    myWinInactive.hide();
                }
            }
        }
    }]
});

var outerPanelWindowReject = new Ext.Panel({ 
    standardSubmit: true,
    frame: false,
    items: [innerPanelReject, winButtonPanelReject]
});

 myWinInactive = new Ext.Window({
    title: 'Do you want to Inactive this application ?',
    closable: false,
    modal: true,
    resizable: false,
    height : 200,
    autoScroll: false,
    cls: 'mywindow',
    id: 'myWinReject',
    items: [outerPanelWindowReject]
});


//For Inactive Status
function deleteData() {
	if (Ext.getCmp('custcomboId').getValue() == "") {
           Ext.example.msg("Select Client Name");
           return;
       }
	if (grid.getSelectionModel().getCount() == 0) {
           Ext.example.msg("No row selected");
           return;
       }
     if (grid.getSelectionModel().getCount() > 1) {
          Ext.example.msg("Select single row");
           return;
       }
     buttonValue = 'Inactive';  
     var json = '';
     var selected = grid.getSelectionModel().getSelected();
     var status = selected.get('statusIndex');
    if( status == 'Inactive'){
     	   Ext.example.msg("Consumer Is Already In Inactive Status");
           return;
    }
    
    myWinInactive.show();
 
}


var customerComboPanel = new Ext.Panel({
    standardSubmit: true,
    collapsible: false,
    id: 'customerComboPanelId',
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
        Client,{width:25},
        { xtype: 'label',
            text: 'Start Date' + ' :',
            cls: 'labelstyle'},startdate,{width:25},
            { xtype: 'label',
            text: 'End Date' + ' :',
            cls: 'labelstyle'},enddate,{width:40},{xtype:'button',
						text: 'View',
						width:70,
						listeners: {
						click: {fn:function(){
						
						if(Ext.getCmp('custcomboId').getValue()=="")
                       {
                             Ext.example.msg("Select Customer");
                             return;
                       }
                       if(Ext.getCmp('startdate').getValue()=="")
                       {
                             Ext.example.msg("Select Start Date");
                             return;
                       }
                       if(Ext.getCmp('enddate').getValue()=="")
                       {
                             Ext.example.msg("Select End Date");
                             return;
                       }
						 if (dateCompare(Ext.getCmp('startdate').getValue(), Ext.getCmp('enddate').getValue()) == -1) {
                             Ext.example.msg("End Date Should Be Greater than Start Date");
                             return;
                       }
                       
                        var Startdates=Ext.getCmp('startdate').getValue();
             		 	var Enddates=Ext.getCmp('enddate').getValue();
            	        var Startdate = new Date(Enddates).add(Date.DAY, -31);
             		 	  if(Startdates <  Startdate)
             		 					{
             		 					Ext.example.msg("Difference between two dates should not be  more than 1 Month.");
             		 					return;
             		 					}
						        store.load({
                                params: {
                                     CustId: Ext.getCmp('custcomboId').getValue(),
                                     jspName:jspName,
                                    custName:Ext.getCmp('custcomboId').getRawValue(),
                                    endDate:Ext.getCmp('enddate').getValue(),
                                    startDate:Ext.getCmp('startdate').getValue()
                                }
                            });
						
						}
						}}}
    ]
});

var innerPanelForConsumerEnrolmentForm = new Ext.form.FormPanel({
    standardSubmit: true,
    collapsible: false,
    autoScroll: true,
    height: 340,
    width: '100%',
    frame: true,
    id: 'innerPanelForConsumerEnrolmentFormId',
    layout: 'table',
    layoutConfig: {
        columns: 3
    },
    items: [{
        xtype: 'fieldset',
        title: '<%=ConsumerDetails%>',
        cls: 'fieldsetpanel',
        collapsible: false,
        colspan: 3,
        id: 'consumerDetailsId',
        width: 450,
        layout: 'table',
        layoutConfig: {
            columns: 4
        },
        items: [{
            xtype: 'label',
            text: '*',
            width: 20,
            cls: 'mandatoryfield',
            id: 'consumerTypeEmptyId1'
        }, {
            xtype: 'label',
            text: '<%=ConsumerType%>' + ' :',
            cls: 'labelstyle',
            id: 'consumerTypeLabelId'
        }, consumerTypeCombo, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'consumerTypeEmptyId2'
        }, {
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'districtEmptyId1'
        }, {
            xtype: 'label',
            text: '<%=District%>' + ' :',
            cls: 'labelstyle',
            id: 'districtLabelId'
        }, districtCombo, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'districtEmptyId2'
        }, {
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'talukaEmptyId1'
        }, {
            xtype: 'label',
            text: '<%=Taluka%>' + ' :',
            cls: 'labelstyle',
            id: 'talukaLabelId'
        }, Talukacombo, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'talukaEmptyId2'
        }, {
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'villagetEmptyId1'
        }, {
            xtype: 'label',
            text: '<%=Village%>' + ' :',
            cls: 'labelstyle',
            id: 'villageLabelId'
        }, {
            xtype: 'textfield',
            cls: 'selectstylePerfect',
            allowBlank: false,
            blankText: '<%=EnterVillage%>',
            emptyText: '<%=EnterVillage%>',
            labelSeparator: '',
            id: 'villageId'
        }, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'villageEmptyId2'
        }, {
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'mobileNoEmptyId1'
        }, {
            xtype: 'label',
            text: '<%=MobileNo%>' + ' :',
            cls: 'labelstyle',
            id: 'mobileNoLabelId'
	    }, {
            xtype: 'numberfield',
            cls: 'selectstylePerfect',
            allowBlank: false,
            blankText: '<%=EnterMobileNo%>',
            emptyText: '<%=EnterMobileNo%>',
            id: 'mobileNoId',
			autoCreate : { //restricts user to 11 chars max, cannot enter 21st char
				 tag: "input", 
				 maxlength : 10, 
				 type: "text", 
				 size: "20", 
				 autocomplete: "off"
			}
        }, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'mobileNoEmptyId2'
        }, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'emailIdEmptyId1'
        }, {
            xtype: 'label',
            text: '<%=EmailId%>' + ' :',
            cls: 'labelstyle',
            id: 'emailIdLabelId'
        }, {
            xtype: 'textfield',
            cls: 'selectstylePerfect',
            allowBlank: false,
            regex:validate('email'),
            blankText: '<%=EnterEmailId%>',
            emptyText: '<%=EnterEmailId%>',
            id: 'emailIdId'
        }, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'emailIdId2'
        }, {
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'addressEmptyId1'
        }, {
            xtype: 'label',
            text: '<%=Address%>' + ' :',
            cls: 'labelstyle',
            id: 'addressLabelId'
        }, {
            xtype: 'textfield',
            cls: 'selectstylePerfect',
            allowBlank: false,
            blankText: '<%=EnterAddress%>',
            emptyText: '<%=EnterAddress%>',
            id: 'addressId'
        }, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'addressEmptyId2'
        }, {
            xtype: 'label',
            text: '*',
            hidden:true,
            cls: 'mandatoryfield',
            id: 'identityProofTypeEmptyId1'
        }, {
            xtype: 'label',
            text: '<%=IdentityProofType%>' + ' :',
            cls: 'labelstyle',
            id: 'identityProofTypeLabelId'
        }, identityProofType, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'identityProofTypeEmptyId2'
        }, {
            xtype: 'label',
            text: '*',
            hidden:true,
            cls: 'mandatoryfield',
            id: 'identityProofNoEmptyId1'
        }, {
            xtype: 'label',
            text: '<%=IdentityProofNo%>' + ' :',
            cls: 'labelstyle',
            id: 'identityProofNoLabelId'
        }, {
            xtype: 'textfield',
            cls: 'selectstylePerfect',
            allowBlank: false,
            blankText: '<%=EnterIdentityProofNo%>',
            emptyText: '<%=EnterIdentityProofNo%>',
            id: 'identityProofNoId'
			 
        }, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'identityProofNoEmptyId2'
        }, {
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'sandConsumerNameEmptyId1'
        }, {
            xtype: 'label',
            text: '<%=SandConsumerName%>' + ' :',
            cls: 'labelstyle',
            id: 'sandConsumerNameLabelId'
        }, {
            xtype: 'textfield',
            cls: 'selectstylePerfect',
            allowBlank: true,
            blankText: '<%=EnterSandConsumerName%>',
            emptyText: '<%=EnterSandConsumerName%>',
            labelSeparator: '',
            id: 'sandConsumerNameId'
        }, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'sandConsumerNameEmptyId2'
        }, {
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'projectNameEmptyId1'
        }, {
            xtype: 'label',
            text: '<%=ProjectName%>' + ' :',
            cls: 'labelstyle',
            id: 'projectNameLabelId'
        }, {
            xtype: 'textfield',
            cls: 'selectstylePerfect',
            allowBlank: false,
            blankText: '<%=EnterProjectName%>',
            emptyText: '<%=EnterProjectName%>',
            id: 'projectNameId'
        }, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'projectNameEmptyId2'
        }, {
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'projectDurationFromEmptyId1'
        }, {
            xtype: 'label',
            text: '<%=ProjectDurationFrom%>' + ' :',
            cls: 'labelstyle',
            id: 'projectDurationFromLabelId'
        }, {
            xtype: 'datefield',
            cls: 'selectstylePerfect',
            format: getDateFormat(),
            allowBlank: false,
            blankText: '<%=SelectProjectDurationFrom%>',
            emptyText: '<%=SelectProjectDurationFrom%>',
            id: 'projectDurationFromId'
        }, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'projectDurationFromId2'
        }, {
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'projectDurationToEmptyId1'
        }, {
            xtype: 'label',
            text: '<%=ProjectDurationTo%>' + ' :',
            cls: 'labelstyle',
            id: 'projectDurationToLabelId'
        }, {
            xtype: 'datefield',
            cls: 'selectstylePerfect',
            format: getDateFormat(),
            allowBlank: false,
            blankText: '<%=SelectProjectDurationTo%>',
            emptyText: '<%=SelectProjectDurationTo%>',
            id: 'projectDurationToId'
        }, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'projectDurationToEmptyId2'
        }, {
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'contractorNameEmptyId1'
        }, {
            xtype: 'label',
            text: '<%=ContractorName%>' + ' :',
            cls: 'labelstyle',
            id: 'contractorNameLabelId'
        }, {
            xtype: 'textfield',
            cls: 'selectstylePerfect',
            allowBlank: false,
            blankText: '<%=EnterContractorName%>',
            emptyText: '<%=EnterContractorName%>',
            id: 'contractorNameId'
        }, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'contractorNameEmptyId2'
        }, {
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'governmentDeptNameEmptyId1'
        }, {
            xtype: 'label',
            text: '<%=GovernmentDeptName%>' + ' :',
            cls: 'labelstyle',
            id: 'governmentDeptNameLabelId'
        }, {
            xtype: 'textfield',
            cls: 'selectstylePerfect',
            allowBlank: false,
            blankText: '<%=EnterGovernmentDeptName%>',
            emptyText: '<%=EnterGovernmentDeptName%>',
            id: 'governmentDeptNameId'
        }, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'governmentDeptNameEmptyId2'
        }, {
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'deptContactNameEmptyId1'
        }, {
            xtype: 'label',
            text: '<%=DeptContactName%>' + ' :',
            cls: 'labelstyle',
            id: 'deptContactNameLabelId'
        }, {
            xtype: 'textfield',
            cls: 'selectstylePerfect',
            allowBlank: false,
            blankText: '<%=EnterDeptContactName%>',
            emptyText: '<%=EnterDeptContactName%>',
            id: 'deptContactNameId'
        }, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'deptContactNameEmptyId2'
        }]
    }, {
        xtype: 'fieldset',
        title: '<%=WorkLocationDetails%>',
        cls: 'fieldsetpanel',
        collapsible: false,
        colspan: 3,
        id: 'WorkLocationDetailspanelId',
        width: 450,
        layout: 'table',
        layoutConfig: {
            columns: 4
        },
        items: [{    
                xtype: 'checkbox',
                name: 'active',
                inputValue: '1',
                height: '25px',
                id: 'consumerCheckBoxId',
                listeners: {
                    check: function(cb, checked) {
                        if (Ext.getCmp('consumerCheckBoxId').getValue() == true) {
                            Ext.getCmp('districtcombo2Id').setValue(Ext.getCmp('districtcomboId').getValue());
                            Ext.getCmp('talukacombo2id').setValue(Ext.getCmp('talukacomboid').getValue());
                            Ext.getCmp('village2Id').setValue(Ext.getCmp('villageId').getValue());
                            Ext.getCmp('address2Id').setValue(Ext.getCmp('addressId').getValue());
                            Ext.getCmp('districtcombo2Id').disable();
                            Ext.getCmp('talukacombo2id').disable();
                            Ext.getCmp('village2Id').disable();
                            Ext.getCmp('address2Id').disable();
                        } else {
                            Ext.getCmp('districtcombo2Id').enable();
                            Ext.getCmp('talukacombo2id').enable();
                            Ext.getCmp('village2Id').enable();
                            Ext.getCmp('address2Id').enable();
                            Ext.getCmp('districtcombo2Id').reset();
                            Ext.getCmp('talukacombo2id').reset();
                            Ext.getCmp('village2Id').reset();
                            Ext.getCmp('address2Id').reset();
                        }
                    }
                }
            }, {
                xtype: 'label',
                text: '<%=SameAsAbove%>',
                cls: 'labelstyle',
                id: 'SameAsAboveId1'
            }, {
                width: 20
            }, {
                width: 20
            }, {
                xtype: 'label',
                text: '*',
                cls: 'mandatoryfield',
                id: 'district2EmptyId1'
            }, {
                xtype: 'label',
                text: '<%=District%>' + ' :',
                cls: 'labelstyle',
                id: 'district2LabelId'
            },
            districtCombo2, {
                xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                id: 'district2EmptyId2'
            }, {
                xtype: 'label',
                text: '*',
                cls: 'mandatoryfield',
                id: 'taluka2EmptyId1'
            }, {
                xtype: 'label',
                text: '<%=Taluka%>' + ' :',
                cls: 'labelstyle',
                id: 'taluka2LabelId'
            },
            Talukacombo2, {
                xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                id: 'taluka2EmptyId2'
            }, {
                xtype: 'label',
                text: '*',
                cls: 'mandatoryfield',
                id: 'village2tEmptyId1'
            }, {
                xtype: 'label',
                text: '<%=Village%>' + ' :',
                cls: 'labelstyle',
                id: 'village2LabelId'
            }, {
                xtype: 'textfield',
                cls: 'selectstylePerfect',
                allowBlank: false,
                blankText: '<%=EnterVillage%>',
                emptyText: '<%=EnterVillage%>',
                labelSeparator: '',
                id: 'village2Id'
            }, {
                xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                id: 'village2EmptyId2'
            }, {
                xtype: 'label',
                text: '*',
                cls: 'mandatoryfield',
                id: 'address2EmptyId1'
            }, {
                xtype: 'label',
                text: '<%=Address%>' + ' :',
                cls: 'labelstyle',
                id: 'address2LabelId'
            }, {
                xtype: 'textfield',
                cls: 'selectstylePerfect',
                allowBlank: false,
                blankText: '<%=EnterAddress%>',
                emptyText: '<%=EnterAddress%>',
                id: 'address2Id'
            }, {
                xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                id: 'address2EmptyId2'
            },{
                xtype: 'label',
                text: '*',
                cls: 'mandatoryfield',
                id: 'workLocationOnMapEmptyId1'
            }, {
                xtype: 'label',
                text: '<%=WorkLocationOnMap%>' + ' :',
                cls: 'labelstyle',
                id: 'workLocationOnMapLabelId'
            }, {
                xtype: 'button',
                text: '<%=SetLocation%>',
                id: 'workLocationOnMapId',
                cls: 'buttonstyle',
                width: 70,
                listeners: {
                   click: {
                      fn: function() {
                          setLocation="true";
                          parent.Ext.getCmp('workLocationMapId').enable();
	                      parent.Ext.getCmp('workLocationMapId').show();
	                      parent.Ext.getCmp('workLocationMapId').update("<iframe style='width:100%;height:530px;border:0;'src='<%=path%>/Jsps/SandMining/ConsumerWorkLocationMap.jsp'></iframe>");
                }
            }
        }
             }, {
                xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                id: 'workLocationOnMapEmptyId2'
            }
        ]
    }, {
        xtype: 'fieldset',
        title: '<%=WorkDetails%>',
        cls: 'fieldsetpanel',
        collapsible: false,
        colspan: 3,
        id: 'WorkDetailspanelId',
        width: 450,
        layout: 'table',
        layoutConfig: {
            columns: 4
        },
        items: [{
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'housingApprovalAuthorityEmptyId1'
        }, {
            xtype: 'label',
            text: '<%=HousingApprovalAuthority%>' + ' :',
            cls: 'labelstyle',
            id: 'housingApprovalAuthorityLabelId'
        }, {
            xtype: 'textfield',
            cls: 'selectstylePerfect',
            allowBlank: false,
            blankText: '<%=EnterHousingApprovalAuthority%>',
            emptyText: '<%=EnterHousingApprovalAuthority%>',
            labelSeparator: '',
            id: 'housingApprovalAuthorityId'
        }, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'housingApprovalAuthorityEmptyId2'
        }, {
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'housingApprovalPlanNumberEmptyId1'
        }, {
            xtype: 'label',
            text: '<%=HousingApprovalPlanNumber%>' + ' :',
            cls: 'labelstyle',
            id: 'housingApprovalPlanNumberLabelId'
        }, {
            xtype: 'textfield',
            cls: 'selectstylePerfect',
            allowBlank: false,
            blankText: '<%=EnterHousingApprovalPlanNumber%>',
            emptyText: '<%=EnterHousingApprovalPlanNumber%>',
            labelSeparator: '',
            id: 'housingApprovalPlanNumberId'
        }, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'housingApprovalPlanNumberEmptyId2'
        }, {
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'projectApprovalAuthorityEmptyId1'
        }, {
            xtype: 'label',
            text: '<%=ProjectApprovalAuthority%>' + ' :',
            cls: 'labelstyle',
            id: 'projectApprovalAuthorityLabelId'
        }, {
            xtype: 'textfield',
            cls: 'selectstylePerfect',
            allowBlank: false,
            blankText: '<%=EnterProjectApprovalAuthority%>',
            emptyText: '<%=EnterProjectApprovalAuthority%>',
            labelSeparator: '',
            id: 'projectApprovalAuthorityId'
        }, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'projectApprovalAuthorityEmptyId2'
        }, {
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'projectApprovalPlanNumberEmptyId1'
        }, {
            xtype: 'label',
            text: '<%=ProjectApprovalPlanNumber%>' + ' :',
            cls: 'labelstyle',
            id: 'projectApprovalPlanNumberLabelId'
        }, {
            xtype: 'textfield',
            cls: 'selectstylePerfect',
            allowBlank: false,
            blankText: '<%=EnterProjectApprovalPlanNumber%>',
            emptyText: '<%=EnterProjectApprovalPlanNumber%>',
            labelSeparator: '',
            id: 'projectApprovalPlanNumberId'
        }, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'projectApprovalPlanNumberEmptyId2'
        }, {
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'totalBuiltupAreaEmptyId1'
        }, {
            xtype: 'label',
            text: '<%=TotalBuiltupArea %>' + ' :',
            cls: 'labelstyle',
            id: 'totalBuiltupAreaLabelId'
        }, {
            xtype: 'numberfield',
            cls: 'selectstylePerfect',
            allowBlank: false,
            blankText: '<%=EnterTotalBuiltupArea%>',
            emptyText: '<%=EnterTotalBuiltupArea%>',
            allowDecimal: true,
            labelSeparator: '',
            id: 'totalBuiltupAreaId'
        }, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'totalBuiltupAreaEmptyId2'
        }, {
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'noOfBuildingsEmptyId1'
        }, {
            xtype: 'label',
            text: '<%=NoOfBuildings %>' + ' :',
            cls: 'labelstyle',
            id: 'noOfBuildingsLabelId'
        }, {
            xtype: 'numberfield',
            cls: 'selectstylePerfect',
            allowBlank: false,
            blankText: '<%=EnterNoOfBuildings%>',
            emptyText: '<%=EnterNoOfBuildings%>',
            labelSeparator: '',
            allowDecimal: false,
            id: 'noOfBuildingsId'
        }, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'noOfBuildingsEmptyId2'
        }, {
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'typeOfWorkEmptyId1'
        }, {
            xtype: 'label',
            text: '<%=TypeOfWork%>' + ' :',
            cls: 'labelstyle',
            id: 'typeOfWorkLabelId'
        }, typeOfWork, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'typeOfWorkEmptyId2'
        }, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
			hidden:true,
            id: 'propertyAssessmentMandatoryId'
        }, {
            xtype: 'label',
            text: 'Property Assessment No',
			hidden:true,
            cls: 'labelstyle',
            id: 'propertyAssessmentLabelId'
        }, {
            xtype: 'numberfield',
            cls: 'selectstylePerfect',
            allowBlank: true,
            blankText: 'Property Assessment Num',
            emptyText: 'Property Assessment Num',
            labelSeparator: '',
			hidden:true,
            id: 'propertyAssessmentNumberId'
        }, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
			hidden:true,
            id: 'propertyAssessmentBlankId'
        }, {
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'estimatedSandRequirementEmptyId1'
        }, {
            xtype: 'label',
            text: '<%=EstimatedSandRequirement%>' +' (CBM/Ton)'+ ':',
            cls: 'labelstyle',
            id: 'estimatedSandRequirementLabelId'
        }, {
            xtype: 'numberfield',
            cls: 'selectstylePerfect',
            allowBlank: false,
            blankText: '<%=EnterEstimatedSandRequirement%>',
            emptyText: '<%=EnterEstimatedSandRequirement%>',
            labelSeparator: '',
            readOnly: false,
            id: 'estimatedSandRequirementId'
        }, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'estimatedSandRequirementEmptyId2'
        }, {
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'approvedSandQunatityEmptyId1'
        }, {
            xtype: 'label',
            text: '<%=ApprovedSandQunatity%>' + ' (CBM/Ton)'+':',
            cls: 'labelstyle',
            id: 'approvedSandQunatityLabelId'
        }, {
            xtype: 'numberfield',
            cls: 'selectstylePerfect',
            allowBlank: true,
            blankText: '<%=EnterApprovedSandQunatity%>',
            emptyText: '<%=EnterApprovedSandQunatity%>',
            labelSeparator: '',
            id: 'approvedSandQunatityId'
        }, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'approvedSandQunatityEmptyId2'
        }]
    },
    
    {
        xtype: 'fieldset',
        title: 'More Info',
        hidden:false,
        cls: 'fieldsetpanel',
        collapsible: false,
        colspan: 3,
        id: 'MoreDetailspanelId',
        width: 450,
        layout: 'table',
        layoutConfig: {
            columns: 4
        },
        items: [     
        {
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 's1'
        }, {
            xtype: 'label',
            text: 'Sand Required From <%=District%>' + ' :',
            cls: 'labelstyle',
            id: 's2'
        }, districtCombo3, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 's3'
        }, {
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 's4'
        }, {
            xtype: 'label',
            text: 'Sand Required From <%=Taluka%>' + ' :',
            cls: 'labelstyle',
            id: 's5'
        }, Talukacombo3,{
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 's6'
        },{
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'stockyardMandatoryId'
        }, {
            xtype: 'label',
            text: 'Sand Stockyard:',
            cls: 'labelstyle',
            id: 'stockyardLabelId'
        },stockyardCombo,{
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'stockyardBlankId'
        }, {
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'tpid1'
        }, {
            xtype: 'label',
            text: 'Sand Required From TP No:',
            cls: 'labelstyle',
            id: 'tpid2'
        }, TPCombo, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'tpid3'
        },
<!--          {-->
<!--            xtype: 'label',-->
<!--            text: '',-->
<!--            cls: 'mandatoryfield',-->
<!--            id: 'routeMandatory'-->
<!--        }, {-->
<!--            xtype: 'label',-->
<!--            text: 'Route Contains CheckPost ? :',-->
<!--            cls: 'labelstyle',-->
<!--            id: 'routeLabel'-->
<!--        }, RadioButtons, {-->
<!--            xtype: 'label',-->
<!--            text: '',-->
<!--            cls: 'mandatoryfield',-->
<!--            id: 'routeBlankId'-->
<!--        },-->
<!--        -->
<!--         {-->
<!--            xtype: 'label',-->
<!--            text: '',-->
<!--            cls: 'mandatoryfield',-->
<!--            id: 'ckeckpostMandatory'-->
<!--        }, {-->
<!--            xtype: 'label',-->
<!--            text: '',-->
<!--            cls: 'labelstyle',-->
<!--            id: 'checkpostLabel'-->
<!--        }, -->
<!--          CheckPostCombo-->
        
        
        	
        
        
        ]
    }]
});

var innerWinButtonPanel = new Ext.Panel({
    id: 'innerWinButtonPanelId',
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
        iconCls: 'savebutton',
        id: 'saveButtonId',
        cls: 'buttonstyle',
        width: 70,
        listeners: {
            click: {
                fn: function() {
                    if (Ext.getCmp('custcomboId').getValue() == "") {
                        Ext.example.msg("<%=SelectCustomer%>");
                        return;
                    }
                    if (Ext.getCmp('consumerTypeComboId').getValue() == "") {
                        Ext.example.msg("<%=SelectConsumerType%>");
                        return;
                    }
                    if (Ext.getCmp('districtcomboId').getValue() == "") {
                        Ext.example.msg("<%=SelectDistrict%>");
                        return;
                    }
                    if (Ext.getCmp('talukacomboid').getValue() == "") {
                        Ext.example.msg("<%=SelectTaluka%>");
                        return;
                    }
                    if (Ext.getCmp('villageId').getValue() == "") {
                        Ext.example.msg("<%=EnterVillage%>");
                        return;
                    }
                    
                    if (Ext.getCmp('mobileNoId').getValue() == "") {
                        Ext.example.msg("<%=EnterMobileNo%>");
                        return;
                    }
                     var reg = /^(\+91-|\+91|0)?\d{10}$/;
                     if(Ext.getCmp('mobileNoId').getValue() != ""){
                     var mobileNo = Ext.getCmp('mobileNoId').getValue();
						if (!reg.test(mobileNo)) {
						Ext.example.msg("Enter Valid Mobile Number");
						Ext.getCmp('mobileNoId').focus();
						return;
						}
						}
					
                    if (Ext.getCmp('addressId').getValue() == "") {
                        Ext.example.msg("<%=EnterAddress%>");
                        return;
                    }
                    
                     if (Ext.getCmp('identityProofTypeId').getValue() == "" && <%=ConsumerMDPstate%>) {
                        Ext.example.msg("Select ID Proof Type");
                        return;
                    }
                    
                     if (Ext.getCmp('identityProofNoId').getValue() == "" && <%=ConsumerMDPstate%>) {
                        Ext.example.msg("Select ID Proof Number");
                        return;
                    }
					
					
						var adhar = Ext.getCmp('identityProofNoId').getValue();
						var idType = Ext.getCmp('identityProofTypeId').getValue();
						var reg = new RegExp('^[0-9]$');
						if(idType=='ADHAAR'){
							if(adhar.length!=12){
								Ext.example.msg("Please Enter Valid Adhar Number");
								return;
							}
														
						}
						
<!--						if(<%=isModelCKM%>){-->
<!--							if (Ext.getCmp('stockyardComboId').getValue() == "") {-->
<!--								Ext.example.msg("Please select stockyard");-->
<!--								return;-->
<!--							}-->
<!--							if (Ext.getCmp('propertyAssessmentNumberId').getValue() == "") {-->
<!--								Ext.example.msg("Please Enter Property Assessment Number");-->
<!--								return;-->
<!--							}-->
<!--							-->
<!--							-->
<!--						}-->


                    if (Ext.getCmp('consumerTypeComboId').getRawValue() == "Public" || Ext.getCmp('consumerTypeComboId').getRawValue() == "Ashraya") {

                        if (Ext.getCmp('sandConsumerNameId').getValue() == "") {
                            Ext.example.msg("<%=EnterSandConsumerName%>");
                            return;
                        }
                        if (Ext.getCmp('districtcombo2Id').getValue() == "") {
                            Ext.example.msg("<%=SelectDistrict%>");
                            return;
                        }
                        if (Ext.getCmp('talukacombo2id').getValue() == "") {
                            Ext.example.msg("<%=SelectTaluka%>");
                            return;
                        }
                        if (Ext.getCmp('village2Id').getValue() == "") {
                            Ext.example.msg("<%=EnterVillage%>");
                            return;
                        }
                        if (Ext.getCmp('address2Id').getValue() == "") {
                            Ext.example.msg("<%=EnterAddress%>");
                            return;
                        }
                        if (setLocation == "false") {
                            Ext.example.msg("EnterWorkLocation");
                            return;
                        }
                        if (Ext.getCmp('housingApprovalAuthorityId').getValue() == "" ) {
                            Ext.example.msg("<%=EnterHousingApprovalAuthority%>");
                            return;
                        }
						
						if (Ext.getCmp('housingApprovalAuthorityId').getValue() == "" ) {
								Ext.example.msg("<%=EnterHousingApprovalAuthority%>");
								return;
						}
						if (Ext.getCmp('housingApprovalPlanNumberId').getValue() == "") {
								Ext.example.msg("<%=EnterHousingApprovalPlanNumber%>");
								return;
							}
						
							
                      
						
                    }
                    if (Ext.getCmp('consumerTypeComboId').getRawValue() == "Contractor") {

                        if (Ext.getCmp('projectNameId').getValue() == "") {
                            Ext.example.msg("<%=EnterProjectName%>");
                            return;
                        }
                        if (Ext.getCmp('projectDurationFromId').getValue() == "") {
                            Ext.example.msg("<%=SelectProjectDurationFrom%>");
                            return;
                        }
                        if (Ext.getCmp('projectDurationToId').getValue() == "") {
                            Ext.example.msg("<%=SelectProjectDurationTo%>");
                            return;
                        }
                        if (Ext.getCmp('contractorNameId').getValue() == "") {
                            Ext.example.msg("<%=EnterContractorName%>");
                            return;
                        }
                        if (Ext.getCmp('districtcombo2Id').getValue() == "") {
                            Ext.example.msg("<%=SelectDistrict%>");
                            return;
                        }
                        if (Ext.getCmp('talukacombo2id').getValue() == "") {
                            Ext.example.msg("<%=SelectTaluka%>");
                            return;
                        }
                        if (Ext.getCmp('village2Id').getValue() == "") {
                            Ext.example.msg("<%=EnterVillage%>");
                            return;
                        }
                        if (Ext.getCmp('address2Id').getValue() == "") {
                            Ext.example.msg("<%=EnterAddress%>");
                            return;
                        }
                        if (setLocation == "false" ) {
                            Ext.example.msg("EnterWorkLocation");
                            return;
                        }
                        if (Ext.getCmp('projectApprovalAuthorityId').getValue() == "") {
                            Ext.example.msg("<%=EnterProjectApprovalAuthority%>");
                            return;
                        }
                        if (Ext.getCmp('projectApprovalPlanNumberId').getValue() == "") {
                            Ext.example.msg("<%=EnterProjectApprovalPlanNumber%>");
                            return;
                        }
                    }
                    if (Ext.getCmp('consumerTypeComboId').getRawValue() == "Government") {

                        if (Ext.getCmp('projectNameId').getValue() == "") {
                            Ext.example.msg("<%=EnterProjectName%>");
                            return;
                        }
                        if (Ext.getCmp('projectDurationFromId').getValue() == "") {
                            Ext.example.msg("<%=SelectProjectDurationFrom%>");
                            return;
                        }
                        if (Ext.getCmp('projectDurationToId').getValue() == "") {
                            Ext.example.msg("<%=SelectProjectDurationTo%>");
                            return;
                        }
                        if (Ext.getCmp('governmentDeptNameId').getValue() == "") {
                            Ext.example.msg("<%=EnterGovernmentDeptName%>");
                            return;
                        }
                        if (Ext.getCmp('deptContactNameId').getValue() == "") {
                            Ext.example.msg("<%=EnterDeptContactName%>");
                            return;
                        }
                        if (Ext.getCmp('districtcombo2Id').getValue() == "") {
                            Ext.example.msg("<%=SelectDistrict%>");
                            return;
                        }
                        if (Ext.getCmp('talukacombo2id').getValue() == "") {
                            Ext.example.msg("<%=SelectTaluka%>");
                            return;
                        }
                        if (Ext.getCmp('village2Id').getValue() == "") {
                            Ext.example.msg("<%=EnterVillage%>");
                            return;
                        }
                        if (Ext.getCmp('address2Id').getValue() == "") {
                            Ext.example.msg("<%=EnterAddress%>");
                            return;
                        }
                        if (setLocation == "false") {
                            Ext.example.msg("<%=EnterWorkLocation%>");
                            return;
                        }
                        if (Ext.getCmp('projectApprovalAuthorityId').getValue() == "") {
                            Ext.example.msg("<%=EnterProjectApprovalAuthority%>");
                            return;
                        }
                        if (Ext.getCmp('projectApprovalPlanNumberId').getValue() == "" ) {
                            Ext.example.msg("<%=EnterProjectApprovalPlanNumber%>");
                            return;
                        }
                    }
                    if (Ext.getCmp('totalBuiltupAreaId').getValue() == "" ) {
                        Ext.example.msg("<%=EnterTotalBuiltupArea%>");
                        return;
                    }
                    if (Ext.getCmp('noOfBuildingsId').getValue() == "" ) {
                        Ext.example.msg("<%=EnterNoOfBuildings%>");
                        return;
                    }
                    if (Ext.getCmp('typeOfWorkId').getValue() == "" ) {
                        Ext.example.msg("<%=SelectTypeOfWork%>");
                        return;
                    }
                    if (Ext.getCmp('estimatedSandRequirementId').getValue() == "") {
                        Ext.example.msg("<%=EnterEstimatedSandRequirement%>");
                        return;
                    }
                    if (Ext.getCmp('approvedSandQunatityId').getValue() == "") {
                        Ext.example.msg("<%=EnterApprovedSandQunatity%>");
                        return;
                    }
                    if (Ext.getCmp('approvedSandQunatityId').getValue() > ESR ) {
                        Ext.example.msg("Approved Quantity should be same or less than Estimated quantity");
                        return;
                    }
                    if (Ext.getCmp('districtcombo3Id').getValue() == "" && <%=ConsumerMDPstate%>) {
                        Ext.example.msg("<%=SelectDistrict%>");
                        return;
                    }
                     if (Ext.getCmp('talukacombo3id').getValue() == "" && <%=ConsumerMDPstate%>) {
                        Ext.example.msg("<%=SelectTaluka%>");
                        return;
                    }
                    if (Ext.getCmp('stockyardComboId').getValue() == "" && <%=ConsumerMDPstate%>) {
								Ext.example.msg("Please select stockyard");
								return;
							}
                     if (Ext.getCmp('tpComboId').getValue() == "" && <%=ConsumerMDPstate%>) {
                        Ext.example.msg("Select TP Number");
                        return;
                    }
<!--                    if(check== "YES"){-->
<!--                    if (Ext.getCmp('checkpostcomboId').getValue() == "" && <%=ConsumerMDPstate%>) {-->
<!--                        Ext.example.msg("Please Select Checkposts");-->
<!--                        return;-->
<!--                    	}-->
<!--           			}-->
					
				   
                    consumerEnrolmentFormOuterPanelWindow.getEl().mask();
                    Ext.Ajax.request({
                        url: '<%=request.getContextPath()%>/SandBlockManagementAction.do?param=addSandConsumerDetails',
                        method: 'POST',
                        params: {
                            buttonValue: buttonValue,
                            custId: Ext.getCmp('custcomboId').getValue(),
                            consumerType: Ext.getCmp('consumerTypeComboId').getValue(),
                            district: Ext.getCmp('districtcomboId').getValue(),
                            taluka: Ext.getCmp('talukacomboid').getValue(),
                            village: Ext.getCmp('villageId').getValue(),
                            mobileNo: Ext.getCmp('mobileNoId').getValue(),
                            emailId: Ext.getCmp('emailIdId').getValue(),
                            address: Ext.getCmp('addressId').getValue(),
                            identityProofType: Ext.getCmp('identityProofTypeId').getValue(),
                            identityProofNo: Ext.getCmp('identityProofNoId').getValue(),
                            sandConsumerName: Ext.getCmp('sandConsumerNameId').getValue(),
                            contractorName: Ext.getCmp('contractorNameId').getValue(),
                            projectName: Ext.getCmp('projectNameId').getValue(),
                            projectDurationFrom: Ext.getCmp('projectDurationFromId').getValue(),
                            projectDurationTo: Ext.getCmp('projectDurationToId').getValue(),
                            governmentDeptName: Ext.getCmp('governmentDeptNameId').getValue(),
                            deptContactName: Ext.getCmp('deptContactNameId').getValue(),
                            workdistrict: Ext.getCmp('districtcombo2Id').getValue(),
                            worktaluka: Ext.getCmp('talukacombo2id').getValue(),
                            workvillage: Ext.getCmp('village2Id').getValue(),
                            workaddress: Ext.getCmp('address2Id').getValue(),
                            housingApprovalAuthority: Ext.getCmp('housingApprovalAuthorityId').getValue(),
                            housingApprovalPlanNumber: Ext.getCmp('housingApprovalPlanNumberId').getValue(),
                            projectApprovalAuthority: Ext.getCmp('projectApprovalAuthorityId').getValue(),
                            projectApprovalPlanNumber: Ext.getCmp('projectApprovalPlanNumberId').getValue(),
                            totalBuiltupArea: Ext.getCmp('totalBuiltupAreaId').getValue(),
                            noOfBuildings: Ext.getCmp('noOfBuildingsId').getValue(),
                            typeOfWork: Ext.getCmp('typeOfWorkId').getValue(),
                            estimatedSandRequirement: Ext.getCmp('estimatedSandRequirementId').getValue(),
                            approvedSandQunatity: Ext.getCmp('approvedSandQunatityId').getValue(),
                            fromDistrict: Ext.getCmp('districtcombo3Id').getValue(),
                            fromTaluka: Ext.getCmp('talukacombo3id').getValue(),
                            tpNumber: Ext.getCmp('tpComboId').getRawValue(),
                            tpNumberID: Ext.getCmp('tpComboId').getValue(),
                            checkpost: Ext.getCmp('checkpostcomboId').getRawValue(),
							stockyard: Ext.getCmp('stockyardComboId').getRawValue(),
							propertyAssessmentNum: Ext.getCmp('propertyAssessmentNumberId').getValue()
                            
                        },
                        success: function(response, options) {
							var message = response.responseText;
							var msg = message.split(',');
                           	
                           	var res = message.substr(0,5);
							Ext.example.msg(message);
                           	
                           	if(res=='Saved'){
                            Ext.getCmp('consumerTypeComboId').reset();
                            Ext.getCmp('districtcomboId').reset();
                            Ext.getCmp('talukacomboid').reset();
                            Ext.getCmp('villageId').reset();
                            Ext.getCmp('mobileNoId').reset();
                            Ext.getCmp('emailIdId').reset();
                            Ext.getCmp('addressId').reset();
                            Ext.getCmp('identityProofTypeId').reset();
                            Ext.getCmp('identityProofNoId').reset();
                            Ext.getCmp('sandConsumerNameId').reset();
                            Ext.getCmp('contractorNameId').reset();
                            Ext.getCmp('projectNameId').reset();
                            Ext.getCmp('projectDurationFromId').reset();
                            Ext.getCmp('projectDurationToId').reset();
                            Ext.getCmp('governmentDeptNameId').reset();
                            Ext.getCmp('deptContactNameId').reset();
                            Ext.getCmp('housingApprovalAuthorityId').reset();
                            Ext.getCmp('housingApprovalPlanNumberId').reset();
                            Ext.getCmp('projectApprovalAuthorityId').reset();
                            Ext.getCmp('projectApprovalPlanNumberId').reset();
                            Ext.getCmp('totalBuiltupAreaId').reset();
                            Ext.getCmp('estimatedSandRequirementId').reset();
                            Ext.getCmp('approvedSandQunatityId').reset();
                            Ext.getCmp('typeOfWorkId').reset();
                            Ext.getCmp('noOfBuildingsId').reset();
                            Ext.getCmp('districtcombo2Id').reset();
                            Ext.getCmp('talukacombo2id').reset();
                            Ext.getCmp('village2Id').reset();
                            Ext.getCmp('address2Id').reset();
                            Ext.getCmp('consumerCheckBoxId').reset();
                            Ext.getCmp('districtcombo3Id').reset();
						 	Ext.getCmp('talukacombo3id').reset();
						 	Ext.getCmp('stockyardComboId').reset();
							Ext.getCmp('tpComboId').reset();
						 	
                            myWin.hide();
                            setLocation="false";
                           } 
                            consumerEnrolmentFormOuterPanelWindow.getEl().unmask();
                            store.load({
                                params: {
                                    CustId: Ext.getCmp('custcomboId').getValue(),
                                     jspName:jspName,
                                    custName:Ext.getCmp('custcomboId').getRawValue(),
                                    endDate:Ext.getCmp('enddate').getValue(),
                                    startDate:Ext.getCmp('startdate').getValue()
                                }
                            });
							
							
<!--							if(res=='Saved'){-->
<!--								 Ext.example.msg(response.responseText);-->
<!--								if(<%=isModelCKM%>){-->
<!--									-->
<!--									window.open("<%=request.getContextPath()%>/Sand_Consumer_Reciept?systemId="+<%=systemId%>+"&appNo="+msg[1]+"&consumerName="+msg[2]+"&reqQty="+msg[3]+"&fromStock="+msg[4]+"&consumerType="+msg[5]);-->
<!--								}-->
<!--										window.open("<%=request.getContextPath()%>/Sand_Consumer_Reciept?systemId="+<%=systemId%>+"&appNo="+msg[1]+"&consumerName="+msg[2]+"&reqQty="+msg[3]+"&fromStock="+msg[4]+"&consumerType="+msg[5]);-->
<!--							}-->
<!--							else{-->
<!--								 Ext.example.msg(message);-->
<!--							}-->
                        },
                        failure: function() {
                            Ext.example.msg("Error");
                            consumerEnrolmentFormOuterPanelWindow.getEl().unmask();
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
                fn: function() {
                    myWin.hide();
                }
            }
        }
    }]
});

var consumerEnrolmentFormOuterPanelWindow = new Ext.Panel({
    width: 485,
    height: 400,
    standardSubmit: true,
    frame: false,
    items: [innerPanelForConsumerEnrolmentForm, innerWinButtonPanel]
});

myWin = new Ext.Window({
    title: titelForInnerPanel,
    closable: false,
    resizable: false,
    modal: true,
    autoScroll: false,
    height: 450,
    width: 500,
    id: 'myWin',
    items: [consumerEnrolmentFormOuterPanelWindow]
});

function addRecord() {
    if (Ext.getCmp('custcomboId').getValue() == "") {
        Ext.example.msg("<%=SelectCustomer%>");
        return;
    }
    buttonValue = '<%=Add%>';
    titelForInnerPanel = '<%=ConsumerDetails%>';
    myWin.setPosition(450, 55);
    myWin.show();
    myWin.setTitle(titelForInnerPanel);
    Ext.getCmp('checkpostcomboId').show();
    Ext.getCmp('consumerTypeComboId').reset();
    Ext.getCmp('districtcomboId').reset();
    Ext.getCmp('talukacomboid').reset();
    Ext.getCmp('villageId').reset();
    Ext.getCmp('sandConsumerNameId').reset();
    Ext.getCmp('mobileNoId').reset();
    Ext.getCmp('emailIdId').reset();
    Ext.getCmp('addressId').reset();
    Ext.getCmp('identityProofTypeId').reset();
    Ext.getCmp('identityProofNoId').reset();
    Ext.getCmp('contractorNameId').reset();
    Ext.getCmp('projectNameId').reset();
    Ext.getCmp('projectDurationFromId').reset();
    Ext.getCmp('projectDurationToId').reset();
    Ext.getCmp('governmentDeptNameId').reset();
    Ext.getCmp('deptContactNameId').reset();
    Ext.getCmp('housingApprovalAuthorityId').reset();
    Ext.getCmp('housingApprovalPlanNumberId').reset();
    Ext.getCmp('projectApprovalAuthorityId').reset();
    Ext.getCmp('projectApprovalPlanNumberId').reset();
    Ext.getCmp('totalBuiltupAreaId').reset();
    Ext.getCmp('estimatedSandRequirementId').reset();
    Ext.getCmp('approvedSandQunatityId').reset();
    Ext.getCmp('typeOfWorkId').reset();
    Ext.getCmp('noOfBuildingsId').reset();
    Ext.getCmp('districtcombo2Id').reset();
    Ext.getCmp('talukacombo2id').reset();
    Ext.getCmp('village2Id').reset();
    Ext.getCmp('address2Id').reset();
    Ext.getCmp('districtcombo3Id').reset();
	Ext.getCmp('talukacombo3id').reset();
	Ext.getCmp('tpComboId').reset();
	Ext.getCmp('stockyardComboId').reset();
	Ext.getCmp('consumerCheckBoxId').setValue(false);
	
}

var innerPanelForOTP = new Ext.form.FormPanel({
    standardSubmit: true,
    collapsible: false,
    autoScroll: true,
    height: 80,
    width: '100%',
    frame: true,
    id: 'innerPanelForOTPId',
    layout: 'table',
    layoutConfig: {
        columns: 4
    },
    items: [{height:20},{},{},{},{width:40},
    	{
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'OTPmandatoryId'
        }, {
            xtype: 'label',
            text: 'Enter OTP' + ' :',
            cls: 'labelstyle',
            id: 'OTPLabelId'
	    }, {
            xtype: 'numberfield',
            cls: 'selectstylePerfect',
            allowBlank: false,
            blankText: 'Enter OTP',
            emptyText: 'Enter OTP',
            id: 'OTPTextId',
			autoCreate : { 
				 tag: "input", 
				 maxlength : 6, 
				 type: "text", 
				 size: "6", 
				 autocomplete: "off"
			}
        }]
		});
		
		
var innerWinButtonPanelForOTP = new Ext.Panel({
    id: 'innerWinButtonPanelForOTPId',
    standardSubmit: true,
    collapsible: false,
    autoHeight: true,
    height: 100,
    width: 380,
    frame: true,
    layout: 'table',
    layoutConfig: {
        columns: 4
    },
    buttons: [{
        xtype: 'button',
        text: 'Resend OTP',
        iconCls: 'uploadbutton',
        id: 'resendButtonId',
        cls: 'buttonstyle',
        width: 70,
        listeners: {
            click: {
                fn: function() {
                
                    var selected = grid.getSelectionModel().getSelected();
     				var appNoModify = selected.get('appNoDataIndex');
     				var mobileNo = selected.get('mobileNoDataIndex');
     				var resendOTPButton = 'Resend';
                    OTPPanelWindow.getEl().mask();
	    			 Ext.Ajax.request({
		             url: '<%=request.getContextPath()%>/SandBlockManagementAction.do?param=verifyResendOTP',
		             method: 'POST',
		             params: {
		            	 CustId: Ext.getCmp('custcomboId').getValue(), 
		                 appNoModify: appNoModify,
		                 mobileNo : mobileNo,
		                 buttonValue:resendOTPButton
		             },
		             success: function(response, options){             
	                     var message = response.responseText;
	                     Ext.example.msg(message);
	                    // json = '';
	                    // store.reload();
	                    // myOTPWin.hide();
	                     Ext.getCmp('OTPTextId').reset();
	                     OTPPanelWindow.getEl().unmask();
		              }, 
		              failure: function(){
		                    // store.reload();
		                   //  myOTPWin.hide();
	                         OTPPanelWindow.getEl().unmask();
	                       //  json = '';
		                 } // END OF FAILURE 
		         });
                    
                }
            }
        }
    },{
        xtype: 'button',
        text: 'Verify',
        iconCls: 'validatebutton',
        id: 'verifyButtonId',
        cls: 'buttonstyle',
        width: 70,
        listeners: {
            click: {
                fn: function() {
                var OTPNumber = Ext.getCmp('OTPTextId').getValue();
                    if (OTPNumber == "") {
                        Ext.example.msg("Please Enter OTP");
                        Ext.getCmp('OTPTextId').focus();
                        return;
                    }
                    var selected = grid.getSelectionModel().getSelected();
     				 pdfAppNo = selected.get('appNoDataIndex');
     				 pdfMobileNo = selected.get('mobileNoDataIndex');
     				 pdfConsumerName = selected.get('sandConsumerNameDataIndex');
     				 pdfConsumerType = selected.get('consumerTypeDataIndex');
     				 pdfStockYard = selected.get('stockyardIndex');
     				 pdfReqQty = selected.get('estimatedSandRequirementDataIndex');
     				 pdfWorkLocation=selected.get('workLocationDataIndex');
					 pdfIdProofType=selected.get('idProofTypeIndex');
					 pdfIdProof=selected.get('idProofNoIndex');
					 pdfApprovedQty=selected.get('approvedSandQunatityDataIndex');;
     				
     				var verifyOTPButton = 'Verify';
                    OTPPanelWindow.getEl().mask();
	    			 Ext.Ajax.request({
		             url: '<%=request.getContextPath()%>/SandBlockManagementAction.do?param=verifyResendOTP',
		             method: 'POST',
		             params: {
		            	 CustId: Ext.getCmp('custcomboId').getValue(), 
		                 appNoModify: pdfAppNo,
		                 OTPNumber: OTPNumber,
		                 mobileNo : pdfMobileNo,
		                 buttonValue:verifyOTPButton
		             },
		             success: function(response, options){             
	                     var message = response.responseText;
	                     var msg = message.split(',');
                         var res = message.substr(0,3);
	                     Ext.example.msg(message);
	                     if(res=='OTP'){
								 Ext.example.msg(response.responseText);
							//	 if(<%=ConsumerMDPstate%>){
								 		//printPDF(pdfAppNo,pdfConsumerName,pdfReqQty,pdfStockYard,pdfConsumerType,pdfMobileNo,pdfWorkLocation,pdfIdProofType,pdfIdProof,pdfApprovedQty);
										window.open("<%=request.getContextPath()%>/Sand_Consumer_Reciept?systemId="+<%=systemId%>+"&appNo="+pdfAppNo+"&consumerName="+pdfConsumerName+"&reqQty="+pdfReqQty+"&fromStock="+pdfStockYard+"&consumerType="+pdfConsumerType+"&mobileNo="+pdfMobileNo+"&workLocation="+pdfWorkLocation+"&approvedQty="+pdfApprovedQty+"&idProofType="+pdfIdProofType+"&idProof="+pdfIdProof);
							//	}
							}
							else{
								 Ext.example.msg(message);
							}
	                     json = '';
	                     store.reload();
	                     myOTPWin.hide();
	                     Ext.getCmp('OTPTextId').reset();
	                     OTPPanelWindow.getEl().unmask();
		              }, 
		              failure: function(){
		                     store.reload();
		                     myOTPWin.hide();
	                         OTPPanelWindow.getEl().unmask();
	                         Ext.getCmp('OTPTextId').reset();
	                         json = '';
		                 } // END OF FAILURE 
		         });
                    
                }
            }
        }
    }, {
        xtype: 'button',
        text: '<%=Cancel%>',
        id: 'verifycanButtId',
        cls: 'buttonstyle',
        iconCls: 'cancelbutton',
        width: 70,
        listeners: {
            click: {
                fn: function() {
                    myOTPWin.hide();
                    Ext.getCmp('OTPTextId').reset();
                }
            }
        }
    }]
});

var OTPPanelWindow = new Ext.Panel({
    width: 385,
    height: 190,
    standardSubmit: true,
    frame: false,
    items: [innerPanelForOTP, innerWinButtonPanelForOTP]
});

var myOTPWin = new Ext.Window({
    title: titleForOTP,
    closable: false,
    resizable: false,
    modal: true,
    autoScroll: false,
    height: 200,
    width: 400,
    id: 'myOTPWins',
    items: [OTPPanelWindow]
});


function verifyFunction(){
	
	if (Ext.getCmp('custcomboId').getValue() == "") {
           Ext.example.msg("Select Client Name");
           return;
       }
	if (grid.getSelectionModel().getCount() == 0) {
           Ext.example.msg("No row selected");
           return;
       }
     if (grid.getSelectionModel().getCount() > 1) {
          Ext.example.msg("Select single row");
           return;
       }
<!--     buttonValue = 'Verify';  -->
<!--     var json = '';-->
     var selected = grid.getSelectionModel().getSelected();
     var appNoModify = selected.get('appNoDataIndex');
     var status = selected.get('appstatusIndex');
     if( status == 'approved'){
     	   Ext.example.msg("Application already approved");
           return;
    }else{
	 titleForOTP = "OTP";
     myOTPWin.setPosition(450, 55);
     myOTPWin.show();
     myOTPWin.setTitle(titleForOTP);
     }
}

function printPDF(pdfAppNo,pdfConsumerName,pdfReqQty,pdfStockYard,pdfConsumerType,pdfMobileNo,pdfWorkLocation,pdfIdProofType,pdfIdProof,pdfApprovedQty){    

    titelForInnerPdfPanel = 'PDF Information';
   
    		
    myPdfWin = new Ext.Window({
    title: titelForInnerPdfPanel,
    closable: true,
    resizable: false,
    modal: true,
    autoScroll: false,
    height: 600,
    width: 900,
    id: 'myPdfWin',
    items: [{ 
            
               // html: "<iframe style='width:100%;height:100%' src='<%=request.getContextPath()%>/Sand_Consumer_Reciept?systemId="+<%=systemId%>+"&appNo="+pdfAppNo+"&consumerName="+pdfConsumerName+"&reqQty="+pdfReqQty+"&fromStock="+pdfStockYard+"&consumerType="+pdfConsumerType+"'></iframe>"                  
           		html: "<iframe style='width:100%;height:100%' src='<%=request.getContextPath()%>/Sand_Consumer_Reciept?systemId="+<%=systemId%>+"&appNo="+pdfAppNo+"&consumerName="+pdfConsumerName+"&reqQty="+pdfReqQty+"&fromStock="+pdfStockYard+"&consumerType="+pdfConsumerType+"&mobileNo="+pdfMobileNo+"&workLocation="+pdfWorkLocation+"&approvedQty="+pdfApprovedQty+"&idProofType="+pdfIdProofType+"&idProof="+pdfIdProof +"'></iframe>"
           }]    
});   

 myPdfWin.setPosition(225, 5);
    buttonValue = 'PDF';
    myPdfWin.show();
    myPdfWin.setTitle(titelForInnerPdfPanel);
    
} 


var reader = new Ext.data.JsonReader({
    idProperty: 'sandBlockid',
    root: 'consumerRoot',
    totalProperty: 'total',
    fields: [{
        name: 'slnoIndex'
    }, {
        name: 'consumerTypeDataIndex'
    },{
        name: 'appNoDataIndex'
    }, {
        name: 'district1DataIndex'
    }, {
        name: 'taluka1DataIndex'
    }, {
        name: 'villageDataIndex'
    }, {
        name: 'mobileNoDataIndex'
    }, {
        name: 'emailIdDataIndex'
    }, {
        name: 'addressDataIndex'
    }, {
        name: 'sandConsumerNameDataIndex'
    }, {
        name: 'contractorNameDataIndex'
    }, {
        name: 'projectNameDataIndex'
    }, {
        name: 'projectDurationFromDataIndex'
    }, {
        name: 'projectDurationToDataIndex'
    }, {
        name: 'governmentDeptNameDataIndex'
    }, {
        name: 'deptContactNameDataIndex'
    }, {
        name: 'workLocationDataIndex'
    }, {
        name: 'housingApprovalAuthorityDataIndex'
    }, {
        name: 'housingApprovalPlanNumberDataIndex'
    }, {
        name: 'projectApprovalAuthorityDataIndex'
    }, {
        name: 'projectApprovalPlanNumberDataIndex'
    }, {
        name: 'totalBuiltupAreaDataIndex'
    }, {
        name: 'noOfBuildingsDataIndex'
    }, {
        name: 'estimatedSandRequirementDataIndex'
    }, {
        name: 'approvedSandQunatityDataIndex'
    },{
        name: 'remainingQunatityDataIndex'
    },{
        name: 'CreatedDateDataIndex'
    },{
		name: 'stockyardIndex'
	},{
		name: 'statusIndex'
	},{
		name: 'appstatusIndex'
	},{
		name: 'idProofTypeIndex'
	},{
		name: 'idProofNoIndex'
	}
    ]
});

var store = new Ext.data.GroupingStore({
    autoLoad: false,
    proxy: new Ext.data.HttpProxy({
        url: '<%=request.getContextPath()%>/SandBlockManagementAction.do?param=getConsumerReport',
        method: 'POST'
    }),
    storeId: 'storeId',
    reader: reader
});

var filters = new Ext.ux.grid.GridFilters({
    local: true,
    filters: [{
        type: 'numeric',
        dataIndex: 'slnoIndex'
    }, {
        type: 'string',
        dataIndex: 'consumerTypeDataIndex'
    },{
        type: 'string',
        dataIndex: 'appNoDataIndex'
    }, {
        type: 'string',
        dataIndex: 'district1DataIndex'
    }, {
        type: 'string',
        dataIndex: 'taluka1DataIndex'
    }, {
        type: 'string',
        dataIndex: 'villageDataIndex'
    }, {
        type: 'string',
        dataIndex: 'mobileNoDataIndex'
    }, {
        type: 'string',
        dataIndex: 'emailIdDataIndex'
    }, {
        type: 'string',
        dataIndex: 'addressDataIndex'
    }, {
        type: 'string',
        dataIndex: 'sandConsumerNameDataIndex'
    }, {
        type: 'string',
        dataIndex: 'contractorNameDataIndex'
    }, {
        type: 'string',
        dataIndex: 'projectNameDataIndex'
    }, {
        type: 'date',
        dataIndex: 'projectDurationFromDataIndex'
    }, {
        type: 'date',
        dataIndex: 'projectDurationToDataIndex'
    }, {
        type: 'string',
        dataIndex: 'governmentDeptNameDataIndex'
    }, {
        type: 'string',
        dataIndex: 'deptContactNameDataIndex'
    }, {
        type: 'string',
        dataIndex: 'workLocationDataIndex'
    }, {
        type: 'string',
        dataIndex: 'housingApprovalAuthorityDataIndex'
    }, {
        type: 'string',
        dataIndex: 'housingApprovalPlanNumberDataIndex'
    }, {
        type: 'string',
        dataIndex: 'projectApprovalAuthorityDataIndex'
    }, {
        type: 'string',
        dataIndex: 'projectApprovalPlanNumberDataIndex'
    }, {
        type: 'numeric',
        dataIndex: 'totalBuiltupAreaDataIndex'
    }, {
        type: 'numeric',
        dataIndex: 'noOfBuildingsDataIndex'
    }, {
        type: 'numeric',
        dataIndex: 'estimatedSandRequirementDataIndex'
    },{
        type: 'numeric',
        dataIndex: 'approvedSandQunatityDataIndex'
    }, {
        type: 'numeric',
        dataIndex: 'remainingQunatityDataIndex'
    }, {
        type: 'date',
        dataIndex: 'CreatedDateDataIndex'
    }, {
        type: 'string',
        dataIndex: 'stockyardIndex'
    }, {
        type: 'string',
        dataIndex: 'statusIndex'
    }, {
        type: 'string',
        dataIndex: 'appstatusIndex'
    },{
    	type: 'string',
    	dataIndex: 'idProofTypeIndex'
    },{
    	type: 'string',
    	dataInddex: 'idProofNoIndex'
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
            dataIndex: 'consumerTypeDataIndex',
            header: "<span style=font-weight:bold;><%=ConsumerType%></span>",
            filter: {
                type: 'string'
            }
        }, {
            dataIndex: 'appNoDataIndex',
            header: "<span style=font-weight:bold;><%=ConsumerApplicationNo%></span>",
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;><%=District%></span>",
            dataIndex: 'district1DataIndex',
            width: 100,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=Taluka%></span>",
            dataIndex: 'taluka1DataIndex',
            width: 100,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=Village%></span>",
            dataIndex: 'villageDataIndex',
            hidden: true,
            width: 100,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=MobileNo%></span>",
            dataIndex: 'mobileNoDataIndex',
            width: 100,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=EmailId%></span>",
            dataIndex: 'emailIdDataIndex',
            hidden: true,
            width: 100,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=Address%></span>",
            dataIndex: 'addressDataIndex',
            hidden: true,
            width: 100,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=SandConsumerName%></span>",
            dataIndex: 'sandConsumerNameDataIndex',
            width: 100,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=ContractorName%></span>",
            dataIndex: 'contractorNameDataIndex',
            width: 100,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=ProjectName%></span>",
            dataIndex: 'projectNameDataIndex',
            hidden: true,
            width: 100,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=ProjectDurationFrom%></span>",
            dataIndex: 'projectDurationFromDataIndex',
            hidden: true,
            width: 100,
            filter: {
                type: 'date'
            }
        }, {
            header: "<span style=font-weight:bold;><%=ProjectDurationTo%></span>",
            dataIndex: 'projectDurationToDataIndex',
            hidden: true,
            width: 100,
            filter: {
                type: 'date'
            }
        }, {
            header: "<span style=font-weight:bold;><%=GovernmentDeptName%></span>",
            dataIndex: 'governmentDeptNameDataIndex',
            width: 100,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=DeptContactName%></span>",
            dataIndex: 'deptContactNameDataIndex',
            hidden: true,
            width: 100,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=WorkLocation%></span>",
            dataIndex: 'workLocationDataIndex',
            width: 100,
            filter: {
                type: 'date'
            }
        }, {
            header: "<span style=font-weight:bold;><%=HousingApprovalAuthority%></span>",
            dataIndex: 'housingApprovalAuthorityDataIndex',
            hidden: true,
            width: 100,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=HousingApprovalPlanNumber%></span>",
            dataIndex: 'housingApprovalPlanNumberDataIndex',
            hidden: true,
            width: 100,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=ProjectApprovalAuthority%></span>",
            dataIndex: 'projectApprovalAuthorityDataIndex',
            hidden: true,
            width: 100,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=ProjectApprovalPlanNumber%></span>",
            dataIndex: 'projectApprovalPlanNumberDataIndex',
            hidden: true,
            width: 100,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=TotalBuiltupArea%></span>",
            dataIndex: 'totalBuiltupAreaDataIndex',
            hidden: true,
            width: 100,
            filter: {
                type: 'numeric'
            }
        }, {
            header: "<span style=font-weight:bold;><%=NoOfBuildings%></span>",
            dataIndex: 'noOfBuildingsDataIndex',
            hidden: true,
            width: 100,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=EstimatedSandRequirement%> (CBM)</span>",
            dataIndex: 'estimatedSandRequirementDataIndex',
            width: 100,
            filter: {
                type: 'numeric'
            }
        }, {
            header: "<span style=font-weight:bold;><%=ApprovedSandQunatity%> (CBM)</span>",
            dataIndex: 'approvedSandQunatityDataIndex',
            width: 100,
            filter: {
                type: 'numeric'
            }
        },{
            header: "<span style=font-weight:bold;><%=RemainingQunatity%> (CBM)</span>",
            dataIndex: 'remainingQunatityDataIndex',
            width: 100,
            filter: {
                type: 'numeric'
            }
        }, {
            header: "<span style=font-weight:bold;><%=CreatedDate%></span>",
            dataIndex: 'CreatedDateDataIndex',
            width: 100,
            filter: {
                type: 'date'
            }
        }, {
            header: "<span style=font-weight:bold;>Stockyard Name</span>",
            dataIndex: 'stockyardIndex',
            width: 100,
            hidden: true,
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;>Status</span>",
            dataIndex: 'statusIndex',
            width: 100,
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;>Application Status</span>",
            dataIndex: 'appstatusIndex',
            width: 100,
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;>Id Proof Type</span>",
            dataIndex: 'idProofTypeIndex',
            width: 100,
            hidden: true,
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;>Id Proof No</span>",
            dataIndex: 'idProofNoIndex',
            width: 100,
            hidden: true,
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
grid = getGrid('<%=ConsumerDetails%>', '<%=NoRecordsFound%>', store, screen.width - 40, 420, 34, filters, '<%=ClearFilterData%>', false, '', 18, false, '', false, '', true, 'Excel', jspName, exportDataType, true, 'PDF', true, '<%=Add%>', true, 'Active',true,'Inactive',false,'',true,'OTP');
 
Ext.onReady(function() {
    ctsb = tsb;
    Ext.QuickTips.init();
    Ext.form.Field.prototype.msgTarget = 'side';
    outerPanel = new Ext.Panel({
        title: '<%=ConsumerEnrolmentForm%>',
        renderTo: 'content',
        standardSubmit: true,
        frame: true,
        width: screen.width - 22,
        cls: 'outerpanel',
        layout: 'table',
        layoutConfig: {
            columns: 1
        },
        items: [customerComboPanel, grid]
    });
    sb = Ext.getCmp('form-statusbar');
    
     
	
	 
<!--    if(<%=ConsumerMDPstate%>){-->
<!--    -->
<!--    Ext.getCmp('approvedSandQunatityEmptyId1').hide();-->
<!--    Ext.getCmp('approvedSandQunatityLabelId').hide();-->
<!--    Ext.getCmp('approvedSandQunatityId').hide();-->
<!--    Ext.getCmp('approvedSandQunatityEmptyId2').hide();-->
<!--	-->
<!--	Ext.getCmp('approvedSandQunatityId').setValue('0');-->
<!--	-->
<!--	Ext.getCmp('identityProofTypeEmptyId1').show();-->
<!--    Ext.getCmp('identityProofNoEmptyId1').show();-->
<!--	-->
<!--   Ext.getCmp('MoreDetailspanelId').show();-->
<!--    -->
<!--   -->
<!--    Ext.getCmp('estimatedSandRequirementId').readOnly = false;-->
<!--   -->
<!--   -->
<!--     Ext.getCmp('totalBuiltupAreaEmptyId1').hide();-->
<!--     Ext.getCmp('totalBuiltupAreaLabelId').hide();-->
<!--     Ext.getCmp('totalBuiltupAreaId').hide();-->
<!--     Ext.getCmp('totalBuiltupAreaEmptyId2').hide();-->
<!--     -->
<!--     Ext.getCmp('totalBuiltupAreaId').setValue('0');-->
<!--     -->
<!--     Ext.getCmp('noOfBuildingsEmptyId1').hide();-->
<!--     Ext.getCmp('noOfBuildingsLabelId').hide();-->
<!--     Ext.getCmp('noOfBuildingsId').hide();-->
<!--     Ext.getCmp('noOfBuildingsEmptyId2').hide();-->
<!--     -->
<!--      Ext.getCmp('noOfBuildingsId').setValue('0');-->
<!--      -->
<!--     Ext.getCmp('typeOfWorkEmptyId1').hide();-->
<!--     Ext.getCmp('typeOfWorkLabelId').hide();-->
<!--     Ext.getCmp('typeOfWorkId').hide();-->
<!--     Ext.getCmp('typeOfWorkEmptyId2').hide();-->
<!--     -->
<!--     Ext.getCmp('typeOfWorkId').setValue('Others');-->
<!--	 -->
<!--	 if(!<%=isModelCKM%>){ -->
<!--     Ext.getCmp('housingApprovalAuthorityEmptyId1').hide();-->
<!--     Ext.getCmp('housingApprovalAuthorityLabelId').hide();-->
<!--     Ext.getCmp('housingApprovalAuthorityId').hide();-->
<!--     Ext.getCmp('housingApprovalAuthorityEmptyId2').hide();-->
<!--     -->
<!--      Ext.getCmp('housingApprovalAuthorityId').setValue('Others');-->
<!--      -->
<!--     Ext.getCmp('housingApprovalPlanNumberEmptyId1').hide();-->
<!--     Ext.getCmp('housingApprovalPlanNumberLabelId').hide();-->
<!--     Ext.getCmp('housingApprovalPlanNumberId').hide();-->
<!--     Ext.getCmp('housingApprovalPlanNumberEmptyId2').hide();-->
<!--     -->
<!--      Ext.getCmp('housingApprovalPlanNumberId').setValue(' ');-->
<!--      -->
<!--     Ext.getCmp('projectApprovalAuthorityEmptyId1').hide();-->
<!--     Ext.getCmp('projectApprovalAuthorityLabelId').hide();-->
<!--     Ext.getCmp('projectApprovalAuthorityId').hide();-->
<!--     Ext.getCmp('projectApprovalAuthorityEmptyId2').hide();-->
<!--     -->
<!--      Ext.getCmp('projectApprovalAuthorityId').setValue(' ');-->
<!--      -->
<!--     Ext.getCmp('projectApprovalPlanNumberEmptyId1').hide();-->
<!--     Ext.getCmp('projectApprovalPlanNumberLabelId').hide();-->
<!--     Ext.getCmp('projectApprovalPlanNumberId').hide();-->
<!--     Ext.getCmp('projectApprovalPlanNumberEmptyId2').hide();-->
<!--     -->
<!--      Ext.getCmp('projectApprovalPlanNumberId').setValue(' ');-->
<!--	  -->
<!--   }-->
<!--    -->
<!--    }-->

if(!<%=ConsumerMDPstate%>){
	Ext.getCmp('MoreDetailspanelId').hide();
}
});
</script>
</body>
</html>
    
    
    
    
    

