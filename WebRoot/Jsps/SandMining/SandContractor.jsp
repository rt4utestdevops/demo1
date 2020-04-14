<%@ page  language="java" import="java.util.*,java.text.SimpleDateFormat,t4u.functions.*,t4u.beans.*,t4u.common.*" pageEncoding="utf-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
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
tobeConverted.add("Select_Customer_Name");

tobeConverted.add("Contractor_Information");
tobeConverted.add("State");
tobeConverted.add("Select_State");

tobeConverted.add("District");
tobeConverted.add("Select_District");
tobeConverted.add("Sub_Division");
tobeConverted.add("Select_Sub_Division");

tobeConverted.add("Taluka");
tobeConverted.add("Select_Taluka");
tobeConverted.add("Village");
tobeConverted.add("Enter_Village");

tobeConverted.add("Gram_Panchayat");
tobeConverted.add("Enter_Gram_Panchayat");
tobeConverted.add("Contractor_Name");

tobeConverted.add("Enter_Contractor_Name");
tobeConverted.add("Contract_No");
tobeConverted.add("Enter_Contract_No");

tobeConverted.add("Contract_Start_Date");
tobeConverted.add("Enter_Contract_Start_Date");

tobeConverted.add("Contract_End_Date");
tobeConverted.add("Enter_Contract_End_Date");

tobeConverted.add("Contractor_Status");
tobeConverted.add("Select_Contractor_Status");

tobeConverted.add("Contractor_Adress");
tobeConverted.add("Enter_Contractor_Adress");

tobeConverted.add("Sand_Block");
tobeConverted.add("Select_Sand_Block");

tobeConverted.add("Contractor_Sand_Excavation_Limit");
tobeConverted.add("Enter_Contractor_Sand_Excavation_Limit");

tobeConverted.add("Save");
tobeConverted.add("Customer_Name");
tobeConverted.add("Add");
tobeConverted.add("Modify");

tobeConverted.add("Contractor_Details");
tobeConverted.add("No_Records_Found");
tobeConverted.add("Clear_Filter_Data");

tobeConverted.add("No_Rows_Selected");
tobeConverted.add("Select_Single_Row");
tobeConverted.add("Excel");
tobeConverted.add("Modify_Details");
tobeConverted.add("Cancel");

tobeConverted.add("SLNO");
tobeConverted.add("Validate_Mesg_For_Form");
tobeConverted.add("End_Date_Must_Be_Greater_Than_Start_Date");


ArrayList<String> convertedWords = new ArrayList<String>();
convertedWords = cf.getLanguageSpecificWordForKey(tobeConverted,language);

String SelectCustomerName=convertedWords.get(0);

String ContractorInformation=convertedWords.get(1);
String State=convertedWords.get(2);
String SelectState=convertedWords.get(3);

String District=convertedWords.get(4);
String SelectDistrict=convertedWords.get(5);
String SubDivision=convertedWords.get(6);
String SelectSubDivision=convertedWords.get(7);

String Taluka=convertedWords.get(8);
String SelectTaluka=convertedWords.get(9);
String Village=convertedWords.get(10);
String EnterVillage=convertedWords.get(11);

String GramPanchayat=convertedWords.get(12);
String EnterGramPanchayat=convertedWords.get(13);
String ContractorName=convertedWords.get(14);

String EnterContractorName=convertedWords.get(15);
String ContractNo=convertedWords.get(16);
String EnterContractNo=convertedWords.get(17);

String ContractStartDate=convertedWords.get(18);
String EnterContractStartDate=convertedWords.get(19);

String ContractEndDate=convertedWords.get(20);
String EnterContractEndDate=convertedWords.get(21);

String ContractorStatus=convertedWords.get(22);
String SelectContractorStatus=convertedWords.get(23);

String ContractorAdress=convertedWords.get(24);
String EnterContractorAdress=convertedWords.get(25);  

String SandBlock=convertedWords.get(26);
String SelectSandBlock=convertedWords.get(27);

String ContractorSandExcavationLimit=convertedWords.get(28);
String EnterContractorSandExcavationLimit=convertedWords.get(29);

String Save=convertedWords.get(30);
String CustomerName=convertedWords.get(31);
String Add=convertedWords.get(32);
String Modify=convertedWords.get(33);

String ContractorDetails=convertedWords.get(34);
String NoRecordsFound=convertedWords.get(35);
String ClearFilterData=convertedWords.get(36);

String NoRowsSelected=convertedWords.get(37);
String SelectSingleRow=convertedWords.get(38);
String Excel=convertedWords.get(39);
String ModifyDetails=convertedWords.get(40);
String Cancel=convertedWords.get(41);

String SLNO=convertedWords.get(42);
String ValidateMesgForForm=convertedWords.get(43);
String EndDateMustBeGreaterthanStartDate=convertedWords.get(44);


%>

<jsp:include page="../Common/header.jsp" />
 		<title><%=ContractorInformation%></title>		
  
	 <style>
  .x-panel-tl
	{
		border-bottom: 0px solid !important;
	}
  </style>

   <%if (loginInfo.getStyleSheetOverride().equals("Y")){%>
	<jsp:include page="../Common/ImportJSSandMining.jsp"/>
	<%}else{%>
	<jsp:include page="../Common/ImportJS.jsp" /><%}%>
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
			.x-layer ul {
				min-height: 27px !important;
			}						
			.x-menu-list {
				height:auto !important;
			}				
			.x-window-tl *.x-window-header {			
				padding-top : 6px !important;
				height : 38px !important;
			}	
			fieldset#contractorinformationid {
				width : 380px !important;
			}
			.selectstylePerfect {    
				width: 144px !important;
			}
		</style>
	 <%}%>	
 <script>
  var jspName = "ContractorInformation";
  var exportDataType = "int,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string";
  var outerPanel;
  var ctsb;
  var dtprev = dateprev;
  var dtcur = datecur;
  var selected;
  var grid;
  var buttonValue;
  var titelForInnerPanel;
  var myWindow;
  
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
                  custName = Ext.getCmp('custcomboId').getRawValue();
                  store.load({
                      params: {
                          CustId: custId,
                          jspName:jspName,
                          custName:custName
                      }
                  });
                   statecombostore.load();
                    districtcombostore.load({
                      params: {
                      }
                  });
                  subDivisionstore.load({
                    params: {
                        CustId: Ext.getCmp('custcomboId').getValue()
                    }
                });
                  sandBlockComboStore.load(
                  {
                      params: {
                       custId: Ext.getCmp('custcomboId').getValue()
                       }
                  });
                  talukacombostore.load({
                      params: {
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
      emptyText: '<%=SelectCustomerName%>',
      blankText: '<%=SelectCustomerName%>',
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
                  var custId = Ext.getCmp('custcomboId').getValue();
                  custName = Ext.getCmp('custcomboId').getRawValue();
                  statecombostore.load();
                  store.load({
                      params: {
                          CustId: custId,
                          jspName:jspName,
                          custName:custName
                      }
                  });
                   districtcombostore.load({
                      params: {
                      }
                  });
                  
                  subDivisionstore.load({
                    params: {
                        CustId: Ext.getCmp('custcomboId').getValue()
                    }
                });
                  
                  talukacombostore.load({
                      params: {
                       }
                  });
                  sandBlockComboStore.load(
                  {
                      params: {
                       custId: Ext.getCmp('custcomboId').getValue()
                       }
                  });
              }
          }
      }
  });
  
  var statecombostore = new Ext.data.JsonStore({
      url: '<%=request.getContextPath()%>/CommonAction.do?param=getStates',
      id: 'StateStoreId',
      root: 'StateRoot',
      autoLoad: false,
      remoteSort: true,
      fields: ['StateID', 'stateName']
  });
  
  var State = new Ext.form.ComboBox({
      store: statecombostore,
      id: 'stateId',
      mode: 'local',
      forceSelection: true,
      emptyText: '<%=SelectState%>',
      blankText: '<%=SelectState%>',
      selectOnFocus: true,
      allowBlank: false,
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
                  var stateId = Ext.getCmp('stateId').getValue();
                  Ext.getCmp('districtId').reset();
                  Ext.getCmp('talukaId').reset();
                  districtcombostore.load({
                      params: {
                          stateId: stateId
                      }
                  });
                  talukacombostore.load({
                      params: {
                          districtId: Ext.getCmp('districtId').getValue()
                      }
                  });
              }
          }
      }
  });
  
  var districtcombostore = new Ext.data.JsonStore({
      url: '<%=request.getContextPath()%>/SandBlockManagementAction.do?param=getDistirctList',
      id: 'districtStoreId',
      root: 'districtRoot',
      autoLoad: false,
      remoteSort: true,
      fields: ['districtID', 'districtName']
  });
  
  var District = new Ext.form.ComboBox({
      store: districtcombostore,
      id: 'districtId',
      mode: 'local',
      forceSelection: true,
      emptyText: '<%=SelectDistrict%>',
      blankText: '<%=SelectDistrict%>',
      selectOnFocus: true,
      allowBlank: false,
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
                  var districtId = Ext.getCmp('districtId').getValue();
                  Ext.getCmp('talukaId').reset();
                  talukacombostore.load({
                      params: {
                          districtId: districtId
                      }
                  });
              }
          }
      }
  });
  
  var subDivisionstore = new Ext.data.JsonStore({
    url: '<%=request.getContextPath()%>/CommonAction.do?param=getgroup',
    id: 'subDivisionStoreId',
    root: 'GroupRoot',
    autoLoad: false,
    remoteSort: true,
    fields: ['GroupId', 'GroupName']
});

var subDivisioncombo = new Ext.form.ComboBox({
    store: subDivisionstore,
    id: 'groupcomboid',
    mode: 'local',
    forceSelection: true,
    emptyText: '<%=SelectSubDivision%>',
    selectOnFocus: true,
    allowBlank: false,
    anyMatch: true,
    typeAhead: false,
    triggerAction: 'all',
    lazyRender: true,
    valueField: 'GroupId',
    displayField: 'GroupName',
    cls: 'selectstylePerfect',
    listeners: {
        select: {
            fn: function() {}
        }
    }
});
  
  
  var talukacombostore = new Ext.data.JsonStore({
      url: '<%=request.getContextPath()%>/SandBlockManagementAction.do?param=getTaluka',
      id: 'talukaStoreId',
      root: 'talukaRoot',
      autoLoad: false,
      remoteSort: true,
      fields: ['TalukaId', 'TalukaName']
  });
  
  var Taluka = new Ext.form.ComboBox({
      store: talukacombostore,
      id: 'talukaId',
      mode: 'local',
      forceSelection: true,
      emptyText: '<%=SelectTaluka%>',
      blankText: '<%=SelectTaluka%>',
      selectOnFocus: true,
      allowBlank: false,
      anyMatch: true,
      typeAhead: false,
      triggerAction: 'all',
      lazyRender: true,
      valueField: 'TalukaId',
      displayField: 'TalukaName',
      cls: 'selectstylePerfect',
      listeners: {}
  });
  
  var arrayStore = [
      ['Active', 'Active'],
      ['InActive', 'InActive']
  ];
  
  var ConStatuscombostore = new Ext.data.SimpleStore({
      data: arrayStore,
      fields: ['ContractorStatusid', 'ContractorStatus']
  });
  
  var ConStatus = new Ext.form.ComboBox({
      store: ConStatuscombostore,
      id: 'contractorStatusId',
      mode: 'local',
      forceSelection: true,
      emptyText: '<%=SelectContractorStatus%>',
      blankText: '<%=SelectContractorStatus%>',
      selectOnFocus: true,
      allowBlank: false,
      anyMatch: true,
      typeAhead: false,
      triggerAction: 'all',
      lazyRender: true,
      valueField: 'ContractorStatusid',
      displayField: 'ContractorStatus',
      cls: 'selectstylePerfect',
      listeners: {}
  });
  
  var customerComboPanel = new Ext.Panel({
      standardSubmit: true,
      collapsible: false,
      id: 'customerComboPanelId',
      layout: 'table',
      frame: false,
      width: screen.width - 22,
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
  
  var sandBlockComboStore = new Ext.data.JsonStore({
      url: '<%=request.getContextPath()%>/SandBlockManagementAction.do?param=getSandBlocksForContractor',
      id: 'sandBlockStoreId1',
      root: 'sandBlockRoot',
      autoLoad: false,
      remoteSort: true,
      fields: ['sandBlockId', 'sandBlockName']
  });
  
  var sandBlock = new Ext.form.ComboBox({
      store: sandBlockComboStore,
      id: 'sandBlockId',
      mode: 'local',
      forceSelection: true,
      emptyText: '<%=SelectSandBlock%>',
      blankText: '<%=SelectSandBlock%>',
      selectOnFocus: true,
      allowBlank: false,
      anyMatch: true,
      typeAhead: false,
      triggerAction: 'all',
      lazyRender: true,
      valueField: 'sandBlockId',
      displayField: 'sandBlockName',
      cls: 'selectstylePerfect'
  });
  
  var innerPanelForContractorDetails = new Ext.form.FormPanel({
      standardSubmit: true,
      collapsible: false,
      autoScroll: true,
      height: 250,
      width: 435,
      frame: true,
      id: 'innerPanelForContractorDetailsId',
      layout: 'table',
      layoutConfig: {
          columns: 4
      },
      items: [{
          xtype: 'fieldset',
          title: '<%=ContractorInformation%>',
          cls: 'fieldsetpanel',
          collapsible: false,
          colspan: 3,
          id: 'contractorinformationid',
          width: 390,
          layout: 'table',
          layoutConfig: {
              columns: 4
          },
          items: [{
                  xtype: 'label',
                  text: '*',
                  cls: 'mandatoryfield',
                  id: 'stateEmptyId1'
              },{
                  xtype: 'label',
                  text: '<%=State%>' + ' :',
                  cls: 'labelstyle',
                  id: 'stateLabelId'
              },  State, {
                  xtype: 'label',
                  text: '',
                  cls: 'mandatoryfield',
                  id: 'stateEmptyId2'
              }, {
                  xtype: 'label',
                  text: '*',
                  cls: 'mandatoryfield',
                  id: 'lastNameEmptyId1'
              },{
                  xtype: 'label',
                  text: '<%=District%>' + ' :',
                  cls: 'labelstyle',
                  id: 'DistrictLabelId'
              },  District, {
                  xtype: 'label',
                  text: '',
                  cls: 'mandatoryfield',
                  id: 'DistrictId2'
              }, {
                  xtype: 'label',
                  text: '*',
                  cls: 'mandatoryfield',
                  id: 'SubDivisionEmptyId1'
              },{
                  xtype: 'label',
                  text: '<%=SubDivision%>' + ' :',
                  cls: 'labelstyle',
                  id: 'SubDivisionId'
              }, 
              subDivisioncombo, {
                  xtype: 'label',
                  text: '',
                  cls: 'mandatoryfield',
                  id: 'SubDivisionId2'
              },{
                  xtype: 'label',
                  text: '*',
                  cls: 'mandatoryfield',
                  id: 'TalukaEmptyId1'
              },{
                  xtype: 'label',
                  text: '<%=Taluka%>' + ' :',
                  cls: 'labelstyle',
                  id: 'TalukalId'
              }, 
              Taluka, {
                  xtype: 'label',
                  text: '',
                  cls: 'mandatoryfield',
                  id: 'TalukaId2'
              },{
                  xtype: 'label',
                  text: '',
                  cls: 'mandatoryfield',
                  id: 'VillageEmptyId1'
              },  {
                  xtype: 'label',
                  text: '<%=Village%>' + ' :',
                  cls: 'labelstyle',
                  id: 'VillageLabelId'
              }, {
                  xtype: 'textfield',
                  cls: 'selectstylePerfect',
                  emptyText: '<%=EnterVillage%>',
                  regex:validate('alphanumericname'),
                  id: 'villageId'
              }, {
                  xtype: 'label',
                  text: '',
                  cls: 'mandatoryfield',
                  id: 'VillageEmptyId2'
              },{
                  xtype: 'label',
                  text: '',
                  cls: 'mandatoryfield',
                  id: 'GramPanchayatEmptyId1'
              },  {
                  xtype: 'label',
                  text: '<%=GramPanchayat%>' + ' :',
                  cls: 'labelstyle',
                  id: 'GramPanchayatLabelId'
              }, {
                  xtype: 'textfield',
                  cls: 'selectstylePerfect',
                  //allowBlank: false,
                  blankText: '<%=EnterGramPanchayat%>',
                  regex:validate('alphanumericname'),
                  emptyText: '<%=EnterGramPanchayat%>',
                  labelSeparator: '',
                  maxLength: 20,
                  id: 'gramPanchayatId'
              }, {
                  xtype: 'label',
                  text: '',
                  cls: 'mandatoryfield',
                  id: 'GramPanchayatEmptyId2'
              },  {
                  xtype: 'label',
                  text: '*',
                  cls: 'mandatoryfield',
                  id: 'ContractorNameEmptyId1'
              },{
                  xtype: 'label',
                  text: '<%=ContractorName%>' + ' :',
                  cls: 'labelstyle',
                  id: 'ContractorNameLabelId'
              }, {
                  xtype: 'textfield',
                  cls: 'selectstylePerfect',
                  blankText: '<%=EnterContractorName%>',
                  emptyText: '<%=EnterContractorName%>',
                  labelSeparator: '',
                  maxLength: 20,
                  id: 'contractorNameId'
              }, {
                  xtype: 'label',
                  text: '',
                  cls: 'mandatoryfield',
                  id: 'ContractorNameEmptyId2'
              },{
                  xtype: 'label',
                  text: '*',
                  cls: 'mandatoryfield',
                  id: 'ContractNoEmptyId1'
              }, {
                  xtype: 'label',
                  text: '<%=ContractNo%>' + ' :',
                  cls: 'labelstyle',
                  id: 'ContractNolId'
              },  {
                  xtype: 'textfield',
                  cls: 'selectstylePerfect',
                  emptyText: '<%=EnterContractNo%>',
                  regex:validate('alphanumericname'),
                  emptyText: '<%=EnterContractNo%>',
                  id: 'contractNoId'
              }, {
                  xtype: 'label',
                  text: '',
                  cls: 'mandatoryfield',
                  id: 'ContractNoEmptyId2'
              }, {
                  xtype: 'label',
                  text: '*',
                  cls: 'mandatoryfield',
                  id: 'ContractStartDateEmptyId1'
              },{
                  xtype: 'label',
                  text: '<%=ContractStartDate%>' + ' :',
                  cls: 'labelstyle',
                  id: 'ContractStartDateLabelId'
              },  {
                  xtype: 'datefield',
                  cls: 'selectstylePerfect',
                  format: getDateFormat(),
                  allowBlank: false,
                  value: dtprev,
                  emptyText: '<%=EnterContractStartDate%>',
                  emptyText: '<%=EnterContractStartDate%>',
                  id: 'contractStartDateId'
              }, {
                  xtype: 'label',
                  text: '',
                  cls: 'mandatoryfield',
                  id: 'ContractStartDateEmptyId2'
              }, {
                  xtype: 'label',
                  text: '*',
                  cls: 'mandatoryfield',
                  id: 'ContractEndDateEmptyId1'
              }, {
                  xtype: 'label',
                  text: '<%=ContractEndDate%>' + ' :',
                  cls: 'labelstyle',
                  id: 'ContractEndDateLabelId'
              }, {
                  xtype: 'datefield',
                  cls: 'selectstylePerfect',
                  format: getDateFormat(),
                  allowBlank: false,
                  value: dtcur,
                  emptyText: '<%=EnterContractEndDate%>',
                  emptyText: '<%=EnterContractEndDate%>',
                  id: 'contractEndDateId'
              }, {
                  xtype: 'label',
                  text: '',
                  cls: 'mandatoryfield',
                  id: 'ContractEndDateEmptyId2'
              }, {
                  xtype: 'label',
                  text: '*',
                  cls: 'mandatoryfield',
                  id: 'ContractorStatusEmptyId1'
              },{
                  xtype: 'label',
                  text: '<%=ContractorStatus%>' + ' :',
                  cls: 'labelstyle',
                  id: 'ContractorStatusLabelId'
              }, 
              ConStatus, {
                  xtype: 'label',
                  text: '',
                  cls: 'mandatoryfield',
                  id: 'ContractorStatusEmptyId2'
              }, {
                  xtype: 'label',
                  text: '',
                  cls: 'mandatoryfield',
                  id: 'ContractAddressEmptyId1'
              }, {
                  xtype: 'label',
                  text: '<%=ContractorAdress%>' + ' :',
                  cls: 'labelstyle',
                  id: 'ContractAddressLabelId'
              }, {
                  xtype: 'textfield',
                  cls: 'selectstylePerfect',
                  emptyText: '<%=EnterContractorAdress%>',
                  regex:validate('alphanumericname'),
                  emptyText: '<%=EnterContractorAdress%>',
                  id: 'contractAddressId'
              }, {
                  xtype: 'label',
                  text: '',
                  cls: 'mandatoryfield',
                  id: 'contractAddressIdEmptyId2'
              },{
                  xtype: 'label',
                  text: '*',
                  cls: 'mandatoryfield',
                  id: 'SandBlockId1'
              },{
                  xtype: 'label',
                  text: '<%=SandBlock%>' + ' :',
                  cls: 'labelstyle',
                  id: 'SandBlockId'
              }, 
              sandBlock, {
                  xtype: 'label',
                  text: '',
                  cls: 'mandatoryfield',
                  id: 'SandBlockIdEmptyId2'
              },{
                  xtype: 'label',
                  text: '*',
                  cls: 'mandatoryfield',
                  id: 'ContractorSandExcavationLimitEmptyId1'
              },  {
                  xtype: 'label',
                  text: '<%=ContractorSandExcavationLimit%>' + ' :',
                  cls: 'labelstyle',
                  id: 'ContractorSandExcavationLimitLabelId2'
              }, {
                  xtype: 'numberfield',
                  cls: 'selectstylePerfect',
                  emptyText: '<%=EnterContractorSandExcavationLimit%>',
                  allowNegative:false,
                  id: 'ContractorSandExcavationLimitId'
              }, {
                  xtype: 'label',
                  text: '',
                  cls: 'mandatoryfield',
                  id: 'ContractorSandExcavationLimitLabelId3'
              }
          ]
      }]
  });
  
  var innerWindowButtonPanel = new Ext.Panel({
      id: 'innerWindowButtonPanelId',
      standardSubmit: true,
      collapsible: false,
      autoHeight: true,
      height: 130,
      width: 430,
      frame: true,
      layout: 'table',
      layoutConfig: {
          columns: 4
      },
      buttons: [{
          xtype: 'button',
          text: 'Save',
          id: 'saveButtonId',
          iconCls:'savebutton',
          cls: 'buttonstyle',
          width: 70,
          listeners: {
              click: {
                  fn: function() {
                      if (Ext.getCmp('custcomboId').getValue() == "") {
                          Ext.example.msg("<%=SelectCustomerName%>");
                          return;
                      }
                      if (Ext.getCmp('stateId').getValue() == "") {
                          Ext.example.msg("<%=SelectState%>");
                          return;
                      }
                      if (Ext.getCmp('districtId').getValue() == "") {
                          Ext.example.msg("<%=SelectDistrict%>");
                          return;
                      }
                      if (Ext.getCmp('groupcomboid').getValue() == "") {
                          Ext.example.msg("<%=SelectSubDivision%>");
                          return;
                      }
                      if (Ext.getCmp('talukaId').getValue() == "") {
                          Ext.example.msg("<%=SelectTaluka%>");
                          return;
                      }
                    
                      if (Ext.getCmp('contractorNameId').getValue() == "") {
                          Ext.example.msg("<%=EnterContractorName%>");
                          return;
                      }
                      if (Ext.getCmp('contractNoId').getValue() == "") {
                          Ext.example.msg("<%=EnterContractNo%>");
                          return;
                      }
                      if (Ext.getCmp('contractStartDateId').getValue() == "") {
                          Ext.example.msg("<%=EnterContractStartDate%>");
                          return;
                      }
                      if (Ext.getCmp('contractEndDateId').getValue() == "") {
                          Ext.example.msg("<%=EnterContractEndDate%>");
                          return;
                      }
                      if (Ext.getCmp('contractorStatusId').getValue() == "") {
                          Ext.example.msg("<%=SelectContractorStatus%>");
                          return;
                      }
                      if (Ext.getCmp('sandBlockId').getValue() == "") {
                          Ext.example.msg("<%=SelectSandBlock%>");
                          return;
                      }
                      if (Ext.getCmp('ContractorSandExcavationLimitId').getValue() == "") {
                          Ext.example.msg("<%=EnterContractorSandExcavationLimit%>");
                          return;
                      }
                     
                        if (dateCompare(Ext.getCmp('contractStartDateId').getValue(), Ext.getCmp('contractEndDateId').getValue()) == -1) {
                             Ext.example.msg("<%=EndDateMustBeGreaterthanStartDate%>");
                             Ext.getCmp('enddate').focus();
                             return;
                       }
                      var selected = grid.getSelectionModel().getSelected();
                      var districtModify;
                      var stateModify;
                      var subDivisionModify;
                      var sandBlockModify;
                      if (innerPanelForContractorDetails.getForm().isValid()) {
                          var selected;
                          var id;
                          if (buttonValue == '<%=Modify%>') {
                              var selected = grid.getSelectionModel().getSelected();
                              id = selected.get('UniqueidIndex');
                              if (selected.get('stateIndex') != Ext.getCmp('stateId').getValue()) {
                          stateModify = Ext.getCmp('stateId').getValue();
                      } else {
                          stateModify = selected.get('stateId1DataIndex');
                      }
                      if (selected.get('districtDataIndex') != Ext.getCmp('districtId').getValue()) {
                          districtModify = Ext.getCmp('districtId').getValue();
                      } else {
                          districtModify = selected.get('districtId1Index');
                      }
                      if (selected.get('subDivisionDataIndex') != Ext.getCmp('groupcomboid').getValue()) {
                          subDivisionModify = Ext.getCmp('groupcomboid').getValue();
                      } else {
                          subDivisionModify = selected.get('subDivisionId1DataIndex');
                      }
                        if (selected.get('sandBlockDataIndex') != Ext.getCmp('sandBlockId').getValue()) {
                          sandBlockModify = Ext.getCmp('sandBlockId').getValue();
                      } else {
                          sandBlockModify = selected.get('sandBlockId1DataIndex');
                      }
                          }
                          contractorOuterPanelWindow.getEl().mask();
                          Ext.Ajax.request({
                              url: '<%=request.getContextPath()%>/SandBlockManagementAction.do?param=contractorAddAndModify',
                              method: 'POST',
                              params: {
                                  buttonValue: buttonValue,
                                  Uniqueid: id,
                                  CustId: Ext.getCmp('custcomboId').getValue(),
                                  custName: Ext.getCmp('custcomboId').getRawValue(),
                                  state: Ext.getCmp('stateId').getValue(),
                                  district: Ext.getCmp('districtId').getValue(),
                                  subDivision: Ext.getCmp('groupcomboid').getValue(),
                                  taluka: Ext.getCmp('talukaId').getRawValue(),
                                  village: Ext.getCmp('villageId').getValue(),
                                  gramPanchayat: Ext.getCmp('gramPanchayatId').getValue(),
                                  contractorName: Ext.getCmp('contractorNameId').getValue(),
                                  contractNo: Ext.getCmp('contractNoId').getValue(),
                                  contractStartDate: Ext.getCmp('contractStartDateId').getValue(),
                                  contractEndDate: Ext.getCmp('contractEndDateId').getValue(),
                                  contractorStatus: Ext.getCmp('contractorStatusId').getValue(),
                                  contractAddress: Ext.getCmp('contractAddressId').getValue(),
                                  sandBlock: Ext.getCmp('sandBlockId').getValue(),
                                  contractorSandExcavationLimit: Ext.getCmp('ContractorSandExcavationLimitId').getValue(),
                                  stateModify: stateModify,
                                  districtModify: districtModify,
                                  subDivisionModify:subDivisionModify,
                                  sandBlockModify:sandBlockModify
                                  
                              },
                              success: function(response, options) {
                                  var message = response.responseText;
                                  Ext.example.msg(message);
                                  Ext.getCmp('stateId').reset();
                                  Ext.getCmp('districtId').reset();
                                  Ext.getCmp('groupcomboid').reset();
                                  Ext.getCmp('talukaId').reset();
                                  Ext.getCmp('villageId').reset();
                                  Ext.getCmp('gramPanchayatId').reset();
                                  Ext.getCmp('contractorNameId').reset();
                                  Ext.getCmp('contractNoId').reset();
                                  Ext.getCmp('contractStartDateId').reset();
                                  Ext.getCmp('contractEndDateId').reset();
                                  Ext.getCmp('contractorStatusId').reset();
                                  Ext.getCmp('contractAddressId').reset();
                                  Ext.getCmp('sandBlockId').reset();
                                  Ext.getCmp('ContractorSandExcavationLimitId').reset();
                                  myWindow.hide();
                                  contractorOuterPanelWindow.getEl().unmask();
                                  store.reload({});
                              },
                              failure: function() {
                                  Ext.example.msg("Error");
                                  store.reload();
                                  myWindow.hide();
                              }
                          });
                      }
                      else{
                       Ext.example.msg("<%=ValidateMesgForForm%>");
							}			
                  }
              }
          }
      }, {
          xtype: 'button',
          text: 'Cancel',
          id: 'canButtId',
          cls: 'buttonstyle',
          iconCls: 'cancelbutton',
          width: 70,
          listeners: {
              click: {
                  fn: function() {
                      myWindow.hide();
                  }
              }
          }
      }]
  });
  
  var contractorOuterPanelWindow = new Ext.Panel({
      width: 445,// 500,
      height: 400,//400,
      standardSubmit: true,
      frame: true,
      items: [innerPanelForContractorDetails, innerWindowButtonPanel]
  });
  
  var myWindow = new Ext.Window({
      title: titelForInnerPanel,
      closable: false,
      resizable: false,
      modal: true,
      autoScroll: false,
      height: 350,
      width: 450,
      id: 'myWindow',
      items: [contractorOuterPanelWindow]
  });

  function addRecord() {
      if (Ext.getCmp('custcomboId').getValue() == "") {
          Ext.example.msg("<%=SelectCustomerName%>");
          return;
      }
      buttonValue = '<%=Add%>';
      titelForInnerPanel = 'ContractorDetails';
      myWindow.setPosition(450, 150);
      myWindow.show();
      myWindow.setTitle(titelForInnerPanel);
      Ext.getCmp('stateId').reset();
      Ext.getCmp('districtId').reset();
      Ext.getCmp('groupcomboid').reset();
      Ext.getCmp('talukaId').reset();
      Ext.getCmp('villageId').reset();
      Ext.getCmp('gramPanchayatId').reset();
      Ext.getCmp('contractorNameId').reset();
      Ext.getCmp('contractStartDateId').reset();
      Ext.getCmp('contractEndDateId').reset();
      Ext.getCmp('contractorStatusId').reset();
      Ext.getCmp('contractAddressId').reset();
      Ext.getCmp('sandBlockId').reset();
      Ext.getCmp('ContractorSandExcavationLimitId').reset();
  }

  function modifyData() {
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
      buttonValue = '<%=Modify%>';
      titelForInnerPanel = '<%=ModifyDetails%>';
      myWindow.setPosition(450, 150);
      myWindow.setTitle(titelForInnerPanel);
      myWindow.show();
      Ext.getCmp('stateId').show();
      Ext.getCmp('districtId').show();
      Ext.getCmp('groupcomboid').show();
      Ext.getCmp('talukaId').show();
      Ext.getCmp('villageId').show();
      Ext.getCmp('gramPanchayatId').show();
      Ext.getCmp('contractorNameId').show();
      Ext.getCmp('contractNoId').show();
      Ext.getCmp('contractStartDateId').show();
      Ext.getCmp('contractEndDateId').show();
      Ext.getCmp('contractorStatusId').show();
      Ext.getCmp('contractAddressId').show();
      Ext.getCmp('sandBlockId').show();
      Ext.getCmp('ContractorSandExcavationLimitId').show();
      var selected = grid.getSelectionModel().getSelected();
      Ext.getCmp('stateId').setValue(selected.get('stateIndex'));
      Ext.getCmp('districtId').setValue(selected.get('districtDataIndex'));
      Ext.getCmp('groupcomboid').setValue(selected.get('subDivisionDataIndex'));
      Ext.getCmp('talukaId').setValue(selected.get('talukaDataIndex'));
      Ext.getCmp('villageId').setValue(selected.get('villageDataIndex'));
      Ext.getCmp('gramPanchayatId').setValue(selected.get('gramPanchayatDataIndex'));
      Ext.getCmp('contractorNameId').setValue(selected.get('contractorNameDataIndex'));
      Ext.getCmp('contractNoId').setValue(selected.get('contractNoDataIndex'));
      Ext.getCmp('contractStartDateId').setValue(selected.get('contractStartDateDataIndex'));
      Ext.getCmp('contractEndDateId').setValue(selected.get('contractEndDateDataIndex'));
      Ext.getCmp('contractorStatusId').setValue(selected.get('contractorStatusDataIndex'));
      Ext.getCmp('contractAddressId').setValue(selected.get('contractAddressDataIndex'));
      Ext.getCmp('sandBlockId').setValue(selected.get('sandBlockDataIndex'));
      Ext.getCmp('ContractorSandExcavationLimitId').setValue(selected.get('ContractorSandExcavationLimitDataIndex'));
      if (selected.get('stateIndex') != Ext.getCmp('stateId').getValue()) {
          stateModify = Ext.getCmp('stateId').getValue();
      } else {
          stateModify = selected.get('stateId1DataIndex');
      }
      if (selected.get('districtDataIndex') != Ext.getCmp('districtId').getValue()) {
          districtModify = Ext.getCmp('districtId').getValue();
      } else {
          districtModify = selected.get('districtId1Index');
      }
      if (selected.get('subDivisionDataIndex') != Ext.getCmp('groupcomboid').getValue()) {
         subDivisionModify = Ext.getCmp('groupcomboid').getValue();
      } else {
         subDivisionModify = selected.get('subDivisionId1DataIndex');
      }
        if (selected.get('sandBlockDataIndex') != Ext.getCmp('sandBlockId').getValue()) {
         sandBlockModify = Ext.getCmp('sandBlockId').getValue();
      } else {
         sandBlockModify = selected.get('sandBlockId1DataIndex');
      }
      districtcombostore.load({
          params: {
              stateId: stateModify
          }
      });
      talukacombostore.load({
          params: {
              districtId: districtModify
          }
      });
  }
  
  var reader = new Ext.data.JsonReader({
      idProperty: 'contractorid',
      root: 'contractorRoot',
      totalProperty: 'total',
      fields: [{
          name: 'slnoIndex'
      },{
          name: 'UniqueidIndex'
      }, {
          name: 'stateIndex'
      }, {
          name: 'districtDataIndex'
      }, {
          name: 'subDivisionDataIndex'
      }, {
          name: 'talukaDataIndex'
      }, {
          name: 'villageDataIndex'
      }, {
          name: 'gramPanchayatDataIndex'
      }, {
          name: 'contractorNameDataIndex'
      }, {
          name: 'contractNoDataIndex'
      }, {
          name: 'contractStartDateDataIndex',
          type: 'date'
      }, {
          name: 'contractEndDateDataIndex',
          type: 'date'
      }, {
          name: 'contractorStatusDataIndex'
      }, {
          name: 'contractAddressDataIndex'
      },{
          name: 'sandBlockDataIndex'
      }, {
          name: 'ContractorSandExcavationLimitDataIndex'
      },{
          name: 'stateId1DataIndex'
      }, {
          name: 'districtId1Index'
      },{
          name: 'subDivisionId1DataIndex'
      },{
          name: 'sandBlockId1DataIndex'
      }]
  });
  
  var store = new Ext.data.GroupingStore({
      autoLoad: false,
      proxy: new Ext.data.HttpProxy({
          url: '<%=request.getContextPath()%>/SandBlockManagementAction.do?param=getContractorReport',
          method: 'POST'
      }),
      storeId: 'contractorId',
      reader: reader
  });
  
  var filters = new Ext.ux.grid.GridFilters({
      local: true,
      filters: [{
          type: 'int',
          dataIndex: 'slnoIndex'
      },{
          type: 'int',
          dataIndex: 'UniqueidIndex'
      }, {
          type: 'string',
          dataIndex: 'stateIndex'
      }, {
          type: 'string',
          dataIndex: 'districtDataIndex'
      }, {
          type: 'string',
          dataIndex: 'subDivisionDataIndex'
      }, {
          type: 'string',
          dataIndex: 'talukaDataIndex'
      }, {
          type: 'string',
          dataIndex: 'villageDataIndex'
      }, {
          type: 'string',
          dataIndex: 'gramPanchayatDataIndex'
      }, {
          type: 'string',
          dataIndex: 'contractorNameDataIndex'
      }, {
          type: 'string',
          dataIndex: 'contractNoDataIndex'
      }, {
          type: 'date',
          dataIndex: 'contractStartDateDataIndex'
          
      }, {
          type: 'date',
          dataIndex: 'contractEndDateDataIndex'
         
      }, {
          type: 'string',
          dataIndex: 'contractorStatusDataIndex'
      },{
          type: 'string',
          dataIndex: 'sandBlockDataIndex'
      },{
          type: 'string',
          dataIndex: 'ContractorSandExcavationLimitDataIndex'
      },{
          type: 'string',
          dataIndex: 'contractAddressDataIndex'
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
        },{
              dataIndex: 'UniqueidIndex',
              header: "<span style=font-weight:bold;>UniqueId</span>",
              hidden: true,
              filter: {
                  type: 'int'
              }
          },{
              dataIndex: 'stateIndex',
              header: "<span style=font-weight:bold;><%=State%></span>",
              filter: {
                  type: 'string'
              }
          }, {
              header: "<span style=font-weight:bold;><%=District%></span>",
              dataIndex: 'districtDataIndex',
              width: 100,
              filter: {
                  type: 'string'
              }
          },{
              header: "<span style=font-weight:bold;><%=SubDivision%></span>",
              dataIndex: 'subDivisionDataIndex',
              width: 100,
              filter: {
                  type: 'string'
              }
          } ,{
              header: "<span style=font-weight:bold;><%=Taluka%></span>",
              dataIndex: 'talukaDataIndex',
              width: 100,
              filter: {
                  type: 'string'
              }
          }, {
              header: "<span style=font-weight:bold;><%=Village%></span>",
              dataIndex: 'villageDataIndex',
              width: 100,
              filter: {
                  type: 'string'
              }
          }, {
              header: "<span style=font-weight:bold;><%=GramPanchayat%></span>",
              dataIndex: 'gramPanchayatDataIndex',
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
              header: "<span style=font-weight:bold;><%=ContractNo%></span>",
              dataIndex: 'contractNoDataIndex',
              width: 100,
              filter: {
                  type: 'string'
              }
          }, {
              header: "<span style=font-weight:bold;><%=ContractStartDate%></span>",
              dataIndex: 'contractStartDateDataIndex',
              renderer: Ext.util.Format.dateRenderer(getDateFormat()),
              width: 100,
              filter: {
                  type: 'date'
              }
          }, {
              header: "<span style=font-weight:bold;><%=ContractEndDate%></span>",
              dataIndex: 'contractEndDateDataIndex',
              renderer: Ext.util.Format.dateRenderer(getDateFormat()),
              width: 100,
              filter: {
                  type: 'date'
              }
          }, {
              header: "<span style=font-weight:bold;><%=ContractorStatus%></span>",
              dataIndex: 'contractorStatusDataIndex',
              width: 100,
              filter: {
                  type: 'string'
              }
          }, {
              header: "<span style=font-weight:bold;><%=ContractorAdress%></span>",
              dataIndex: 'contractAddressDataIndex',
              width: 100,
              filter: {
                  type: 'string'
              }
          },{
              header: "<span style=font-weight:bold;><%=SandBlock%></span>",
              dataIndex: 'sandBlockDataIndex',
              width: 100,
              filter: {
                  type: 'string'
              }
          },{
              header: "<span style=font-weight:bold;><%=ContractorSandExcavationLimit%></span>",
              dataIndex: 'ContractorSandExcavationLimitDataIndex',
              width: 100,
              filter: {
                  type: 'string'
              }
          }];
      return new Ext.grid.ColumnModel({
          columns: columns.slice(start || 0, finish),
          defaults: {
              sortable: true
          }
      });
  };
  
  //*****************************************************************Grid ***********************************************************************************************************************************************************************
  grid = getGrid('<%=ContractorDetails%>', '<%=NoRecordsFound%>', store, screen.width - 40, 440, 18, filters, '<%=ClearFilterData%>', false, '', 16, false, '', false, '', true, '<%=Excel%>', jspName, exportDataType, true, 'PDF', true, '<%=Add%>', true, '<%=Modify%>');
  //*********************************************************************************************************************************************************************************************************************************************
  Ext.onReady(function() {
      ctsb = tsb;
      Ext.QuickTips.init();
      Ext.form.Field.prototype.msgTarget = 'side';
      outerPanel = new Ext.Panel({
          title: '<%=ContractorInformation%>',
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
  });
</script>
  <jsp:include page="../Common/footer.jsp" />
 <!-- </body>   -->
 <!-- </html> -->
