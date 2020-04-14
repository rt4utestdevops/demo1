<%@ page  language="java" import="java.util.*,java.text.SimpleDateFormat,t4u.functions.*,t4u.beans.*,t4u.common.*" pageEncoding="utf-8"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://"+ request.getServerName() + ":" + request.getServerPort()+ path + "/";

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

%>
<jsp:include page="../Common/header.jsp" />
 		<title>SCC Master</title>
 		<meta http-equiv="X-UA-Compatible" content="IE=8">			
   
	 <style>
  .x-panel-tl
	{
		border-bottom: 0px solid !important;
	}
  </style>
  <div height="100%">
  <%if (loginInfo.getStyleSheetOverride().equals("Y")){%>                  
    <jsp:include page="../Common/ImportJSSandMining.jsp"/>                                               
   <%}else {%>  
   <jsp:include page="../Common/ImportJS.jsp" /><%} %>
   <jsp:include page="../Common/ExportJS.jsp" />
   <% String newMenuStyle=loginInfo.getNewMenuStyle();
		if(newMenuStyle.equalsIgnoreCase("YES")){%>
		<style>							
			label {
				display : inline !important;
			}			
			.ext-strict .x-form-text {
				height: 21px !important;
			}
			.x-window-tl *.x-window-header {
				padding-top : 6px !important;
				height : 38px !important;
			}
			.x-layer ul {
				min-height: 27px !important;
			}	
			div#myWinForAssetRegistrationId {
				top : 52px !important;
			}
		</style>
	 <%}%>
   <script>
   Ext.Ajax.timeout = 360000;
   var outerPanel;
   var ctsb;
   var jspName = "SccAssociation";
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
   var custId;
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
                           CustID: Ext.getCmp('custcomboId').getValue()
                       }
                   });
                   unitTypeStore.load({
                       params: {
                           CustId: custId
                       }
                   });

               }
           }
       }
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
                   

                   if ( <%= customerId %> > 0) {
                       Ext.getCmp('custcomboId').setValue('<%=customerId%>');
                       custId = Ext.getCmp('custcomboId').getValue();
                       custName = Ext.getCmp('custcomboId').getRawValue();
                       store.load({
                           params: {
                               CustID: Ext.getCmp('custcomboId').getValue()
                           }
                       });

                   unitTypeStore.load({
                       params: {
                           CustId: custId
                       }
                   });

               }else{
	                custId = Ext.getCmp('custcomboId').getValue();
	                   store.load({
	                       params: {
	                           CustID: custId
	                       }
	                   });
	
	                   unitTypeStore.load({
	                       params: {
	                           CustId: custId
	                       }
	                   });
               }
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
                   custId = Ext.getCmp('custcomboIdForModify').getValue();
               }
           }
       }
   });
   

   var unitTypeStore = new Ext.data.JsonStore({
       url: '<%=request.getContextPath()%>/SccAction.do?param=getUnitType',
       id: 'unitTypeId',
       root: 'unitTypeRoot',
       autoload: true,
       remoteSort: true,
       fields: ['UnitNumber', 'Manufacturer', 'UnitType', 'DeviceReferenceId'],
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
       valueField: 'UnitNumber',
       displayField: 'UnitNumber',
       cls: 'selectstylePerfect',
       listeners: {
           select: {
               fn: function() {
                   var unitType = Ext.getCmp('unittypecomboId').getValue();
                   Ext.getCmp('secondPanelId').show();
                   var row = unitTypeStore.find('UnitNumber', Ext.getCmp('unittypecomboId').getValue());
                   var rec = unitTypeStore.getAt(row);
                   Ext.getCmp('unitNumber1Id').setText(rec.data['UnitNumber']);
                   Ext.getCmp('manfacturer1Id').setText(rec.data['Manufacturer']);
                   Ext.getCmp('unitType1Id').setText(rec.data['UnitType']);
                   Ext.getCmp('DeviceReferenceId').setText(rec.data['DeviceReferenceId']);
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
   
   var innerPanelForAssetRegistration = new Ext.form.FormPanel({
       standardSubmit: true,
       collapsible: false,
       autoScroll: true,
       height: 210,
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
       items: [
           {
               xtype: 'label',
               text: '*',
               cls: 'mandatoryfield',
               id: 'mandatoryRegistrationId'
           },  
           {
               xtype: 'label',
               text: 'SCC ID' + ' :',
               cls: 'labelstyle',
               id: 'registrationTxtId'
           }, {
               xtype: 'textfield',
               cls: 'selectstylePerfect',
               emptyText: 'Enter SCC ID',
               allowBlank: false,
               autoCreate: { //restricts user to 20 chars max, cannot enter 21st char
                   tag: "input",
                   maxlength: 4,
                   type: "text",
                   size: "5",
                   autocomplete: "off"
               },
               maskRe: /[a-zA-Z0-9%$#@!^&*(){}]/i,
              
               blankText: 'Enter SCC ID',
               id: 'sccIdTextFieldId'
           },   
           {
               xtype: 'label',
               text: '*',
               cls: 'mandatoryfield',
               hidden:true            
           },  {
               xtype: 'label',
               text: 'INTERVAL' + ' :',
               cls: 'labelstyle',
               id: 'assetIdForTxt',
               hidden: true
           }, {
               xtype: 'numberfield',
               cls: 'selectstylePerfect',
               emptyText: 'Enter Interval',
               allowBlank: true,
               blankText: 'Enter Interval',
               id: 'reorderLevelTextId',
               value:'0',
               hidden:true
               
           }, {
               xtype: 'label',
               text: '*',
               cls: 'mandatoryfield',
               id: 'mandatoryUnitNumberId'
           },{
               xtype: 'label',
               text: 'UNIT NUMBER' + ' :',
               cls: 'labelstyle',
               id: 'unitNumberTxtId'
           }, 
           unitTypeCombo,{
               xtype: 'label',
               text: '',
               cls: 'labelstyle',
               id: 'mandatoryownerAddressIdForAdd'
           }, {
               xtype: 'label',
               text: 'REMARKS' + ' :',
               cls: 'labelstyle',
               id: 'remarksIdForTxt'
           }, {
               xtype: 'textarea',
               cls: 'selectstylePerfect',
               emptyText: 'Enter remarks, If any',
               allowBlank: true,
               blankText: 'Enter remarks, If any',
               id: 'remarksTexareaId'
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
                       if (Ext.getCmp('custcomboId').getValue() == "") {
                       Ext.example.msg("<%=SelectCustomerName%>");
                       return;
                       }                
                  
	                   if (Ext.getCmp('sccIdTextFieldId').getValue() == "") {
	                           Ext.example.msg("Please Enter SCC ID");
	                           return;
	                       }
	                   
                       
                       if (Ext.getCmp('unittypecomboId').getValue() == "") {
                           Ext.example.msg("<%=SelectUnitNo%>");
                           return;
                       }
                       
<!--                       if (Ext.getCmp('reorderLevelTextId').getValue() == "") {-->
<!--                           Ext.example.msg("Please Enter Interval");-->
<!--                           return;-->
<!--                       }-->
                                 myWinForAssetRegistration.hide();
                                 outerPanel.getEl().mask();
                                 var selected = grid.getSelectionModel().getSelected();
                                 Ext.Ajax.request({
                                     url: '<%=request.getContextPath()%>/SccAction.do?param=addModifyRegisterInformation',
                                     method: 'POST',
                                     params: {
                                         buttonValue: buttonValue,
                                         CustID: Ext.getCmp('custcomboId').getValue(),
                                         reorderLevel: 60,
                                        <!--  Ext.getCmp('reorderLevelTextId').getValue(),-->
                                         remarks: Ext.getCmp('remarksTexareaId').getValue(),
                                         sccId: Ext.getCmp('sccIdTextFieldId').getValue(),
                                         unitNo: Ext.getCmp('unittypecomboId').getValue()
                                     },
                                     success: function(response, options) {
                                         var message = response.responseText;
                                         Ext.example.msg(message);
                                         myWinForAssetRegistration.hide();
                                         outerPanel.getEl().unmask();
                                         store.load({
                                             params: {
                                                 CustID: Ext.getCmp('custcomboId').getValue()
                                             }
                                         });
                                         unitTypeStore.load({
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
       height: 400,
       width: 480,
       frame: true,
       id: 'addCaseInfo',
       layout: 'table',
       layoutConfig: {
           columns: 2
       },
       items: [{
           xtype: 'fieldset',
           title: 'SCC Details',
           collapsible: false,
           colspan: 3,
           width: 450,
           autoScroll: false,
           id: 'caseinfopanelid',
           layout: 'table',
           layoutConfig: {
               columns: 1
           },
           items: [innerPanelForAssetRegistration, secondPanelForUnitDetails]
       }]
   });
   
   var assetRegistrationOuterPanelWindow = new Ext.Panel({
       width: 490,
       height: 500,
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
       height: 500,
       width: 490,
       id: 'myWinForAssetRegistrationId',
       items: [assetRegistrationOuterPanelWindow]
   });

   function addRecord() {
       if (Ext.getCmp('custcomboId').getValue() == "") {
           Ext.example.msg("<%=SelectCustomerName%>");
           return;
       }

       unitTypeStore.load({
           params: {
               CustId: custId
           }
       });

       buttonValue = '<%=AddNew%>';     
       titelForInnerPanel = 'SCC Information';
       myWinForAssetRegistration.setPosition(410, 5);
       myWinForAssetRegistration.show();
       Ext.getCmp('secondPanelId').hide();
       myWinForAssetRegistration.setTitle(titelForInnerPanel);
      
       Ext.getCmp('sccIdTextFieldId').setValue(''); 
       Ext.getCmp('unittypecomboId').reset(); 
       Ext.getCmp('reorderLevelTextId').setValue(''); 
       Ext.getCmp('remarksTexareaId').setValue(''); 
       Ext.getCmp('sccIdTextFieldId').enable(); 
       Ext.getCmp('unittypecomboId').enable();      
   }

   function modifyData() {
       clientcombostore.reload();
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

       unitTypeStore.load({
           params: {
               CustId: custId
           }
       });

       buttonValue = '<%=Modify%>';
       titelForInnerPanel = '<%=ModifyInformation%>';
       myWinForAssetRegistration.setPosition(410, 5);
       myWinForAssetRegistration.setTitle(titelForInnerPanel);
       myWinForAssetRegistration.show();  
     
       var selected = grid.getSelectionModel().getSelected();
       Ext.getCmp('sccIdTextFieldId').setValue(selected.get('sccIdDataIndex')); 
       Ext.getCmp('unittypecomboId').setValue(selected.get('unitNoDataIndex')); 
       Ext.getCmp('reorderLevelTextId').setValue(selected.get('reorderLevelDataIndex')); 
       Ext.getCmp('remarksTexareaId').setValue(selected.get('remarks')); 
       Ext.getCmp('sccIdTextFieldId').disable(); 
       Ext.getCmp('unittypecomboId').disable(); 
     
   }
  
   
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
       height: 200,
       width: 450,
       standardSubmit: true,
       frame: true,
       items: [{
           xtype: 'fieldset',        
           width: 435,
           collapsible: false,
           layout: 'table',
           layoutConfig: {
               columns: 1
           },
           items: [deletePanelForNoteAndToTypeDelete]
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
       buttonValue = '<%=Delete%>';
       titel = '<%=DeleteDetails%>';
       deleteWin.setPosition(410, 30);
       deleteWin.show();
       deleteWin.setTitle(titel);
       Ext.getCmp('deleteTypeId').reset();
   }

   function deleteDataForSure() {      
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
                               url: '<%=request.getContextPath()%>/SccAction.do?param=deteteScc',
                               method: 'POST',
                               params: {
                                   unitNo: selected.get('unitNoDataIndex'),                               
                                   sccId: selected.get('sccIdDataIndex'),
                                   custID: Ext.getCmp('custcomboId').getValue()
                               },
                               success: function(response, options) {
                                   var message = response.responseText;
                                   Ext.example.msg(message);
                                   outerPanel.getEl().unmask();                               
                                   deleteWin.hide();
                                   store.load({
                                       params: {
                                           CustID: Ext.getCmp('custcomboId').getValue()
                                       }
                                   });
                                   unitTypeStore.load({
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
                           Ext.example.msg("SCC Not Deleted");                         
                           break;
                   }
               }
           });
       } else {
           if (Ext.getCmp('deleteTypeId').getValue() != 'DELETE') {
           Ext.example.msg("<%=PleaseEnterDELETEInCapitalLettersToDeleteTheRecord%>");
               Ext.getCmp('deleteTypeId').focus();
               Ext.getCmp('deleteTypeId').reset();
           }
       }
   }
   var reader = new Ext.data.JsonReader({
       idProperty: 'taskMasterid',
       root: 'sccMaster',
       totalProperty: 'total',
       fields: [{
           name: 'slnoIndex'
       },  {
           name: 'unitNoDataIndex'
       }, {
           name: 'sccIdDataIndex'
       }, {
           name: 'vehicleNoDataIndex'
       }, {
       	   name:'macAddDataIndex'
       },{
           name: 'reorderLevelDataIndex'
       }, {
           name: 'associatedBy'
       }, {
           name: 'associatedDate'
       }, {
           name: 'modifiedBy'
       }, {
           name: 'modifiedDate'
       },{
           name: 'remarks'
       }]
   });
   var store = new Ext.data.GroupingStore({
       autoLoad: false,
       proxy: new Ext.data.HttpProxy({
           url: '<%=request.getContextPath()%>/SccAction.do?param=getSccData',
           method: 'POST'
       }),      
       reader: reader
   });
   var filters = new Ext.ux.grid.GridFilters({
       local: true,
       filters: [{
           type: 'numeric',
           dataIndex: 'slnoIndex'
       }, {
           type: 'string',
           dataIndex: 'unitNoDataIndex'
       }, {
           type: 'string',
           dataIndex: 'sccIdDataIndex'
       }, {
           type: 'string',
           dataIndex: 'vehicleNoDataIndex'
       },{
           type: 'string',
           dataIndex: 'macAddDataIndex'
       },{
           type: 'int',
           dataIndex: 'reorderLevelDataIndex'
       }, {
           type: 'string',
           dataIndex: 'associatedBy'
       }, {
           type: 'date',
           dataIndex: 'associatedDate'
       }, {
           type: 'string',
           dataIndex: 'modifiedBy'
       }, {
           type: 'date',
           dataIndex: 'modifiedDate'
       },{
       	   type:'string',
       	   dataIndex:'remarks'
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
               header: "<span style=font-weight:bold;>SCC Id</span>",
               dataIndex: 'sccIdDataIndex',
               width: 100,
               filter: {
                   type: 'date'
               }
           }, {
               header: "<span style=font-weight:bold;>MAC Address</span>",
               dataIndex: 'macAddDataIndex',
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
               header: "<span style=font-weight:bold;>Interval</span>",
               dataIndex: 'reorderLevelDataIndex',
               hidden: true,
               width: 100,
               filter: {
                   type: 'int'
               }
           }, {
               header: "<span style=font-weight:bold;>Asset No</span>",
               dataIndex: 'vehicleNoDataIndex',
               width: 100,
               filter: {
                   type: 'string'
               }
           },  {
               header: "<span style=font-weight:bold;><%=AssociatedDate%></span>",
               dataIndex: 'associatedDate',
               hidden: false,
               sortable: true,
               renderer: Ext.util.Format.dateRenderer(getDateTimeFormat()),
               width: 100,
               filter: {
                   type: 'date'
               }
           }, {
               header: "<span style=font-weight:bold;>Associated By</span>",
               dataIndex: 'associatedBy',
               hidden: false,
               width: 100,
               filter: {
                   type: 'String'
               }
           },{
               header: "<span style=font-weight:bold;>Modified Date</span>",
               dataIndex: 'modifiedDate',
               hidden: false,
               sortable: true,
               renderer: Ext.util.Format.dateRenderer(getDateTimeFormat()),
               width: 100,
               filter: {
                   type: 'date'
               }
           },{
               header: "<span style=font-weight:bold;>Modified By</span>",
               dataIndex: 'modifiedBy',
               hidden: false,
               width: 100,
               filter: {
                   type: 'String'
               }
           },{
               header: "<span style=font-weight:bold;>Remarks</span>",
               dataIndex: 'remarks',
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
   grid = getGrid('SCC ASSOCIATION', '<%=NoRecordsFound%>', store, screen.width - 45, 380, 18, filters, '<%=ClearFilterData%>', false, '', 16, false, '', false, '', false, '<%=Excel%>', jspName, exportDataType, false, 'PDF', <%= addbutton %> , '<%=AddNew%>', '' , '', <%= deletebutton %> , '<%=Delete%>');

   Ext.onReady(function() {
       ctsb = tsb;
       Ext.QuickTips.init();
       Ext.form.Field.prototype.msgTarget = 'side';
       outerPanel = new Ext.Panel({
           title: 'SCC ASSOCIATION DETAILS',
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
       });
       sb = Ext.getCmp('form-statusbar');
   });
</script>
</div>
 <jsp:include page="../Common/footer.jsp" />
 <!-- </body>   -->
 <!-- </html> -->