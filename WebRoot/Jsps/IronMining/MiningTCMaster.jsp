<%@ page language="java"
	import="java.util.*,t4u.functions.CommonFunctions,t4u.beans.*,t4u.common.*"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://packtag.sf.net" prefix="pack"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
System.out.println(request.getParameter("list"));
if (request.getParameter("list") != null && !request.getParameter("list").equals(null)) {
		String list = request.getParameter("list").toString().trim();
		String[] str = list.split(",");
		int systemid = Integer.parseInt(str[0].trim());
		int customerid = Integer.parseInt(str[1].trim());
		int userid = Integer.parseInt(str[2].trim());
		String language = str[3].trim();
		LoginInfoBean loginInfo = new LoginInfoBean();
		loginInfo.setSystemId(systemid);
		loginInfo.setCustomerId(customerid);
		loginInfo.setUserId(userid);
		loginInfo.setLanguage(language);
		loginInfo.setStyleSheetOverride("N");
		loginInfo.setZone(str[4].trim());
		loginInfo.setOffsetMinutes(Integer.parseInt(str[5].trim()));
		loginInfo.setSystemName(str[6].trim());
		loginInfo.setCategory(str[7].trim());
		loginInfo.setStyleSheetOverride("N");
		if (str.length > 8) {
			loginInfo.setCustomerName(str[8].trim());
		}
		if (str.length > 9) {
			loginInfo.setCategoryType(str[9].trim());
		}
		if (str.length > 10) {
			loginInfo.setUserName(str[10].trim());
		}
		if(str.length>11){
		loginInfo.setCountryCode(Integer.parseInt(str[11].trim()));
		}
			session.setAttribute("loginInfoDetails", loginInfo);
		}
	CommonFunctions cf = new CommonFunctions();
	String ipVal = request.getParameter("ipVal");	
	LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
	if (loginInfo == null) {
		response.sendRedirect(request.getContextPath()
				+ "/Jsps/Common/SessionDestroy.html");
	} else {
		session.setAttribute("loginInfoDetails", loginInfo);
		String language = loginInfo.getLanguage();
		
			 
ArrayList<String> tobeConverted = new ArrayList<String>();
tobeConverted.add("Add");
tobeConverted.add("Modify");
tobeConverted.add("No_Records_Found");
tobeConverted.add("Clear_Filter_Data");
tobeConverted.add("Save");
tobeConverted.add("Cancel");

tobeConverted.add("SLNO");
tobeConverted.add("No_Rows_Selected");
tobeConverted.add("Select_Single_Row");
tobeConverted.add("Add_Details");
tobeConverted.add("Select_Customer");

tobeConverted.add("District");  
tobeConverted.add("Taluka");
tobeConverted.add("Village");
tobeConverted.add("Area");
tobeConverted.add("Status");

tobeConverted.add("Select_District");
tobeConverted.add("Select_Taluka");
tobeConverted.add("Enter_Village");
tobeConverted.add("Enter_Area");
tobeConverted.add("Select_Status");

tobeConverted.add("TC_Master");  
tobeConverted.add("TC_Master_Details");
tobeConverted.add("Order_Number");
tobeConverted.add("Enter_Order_Number");
tobeConverted.add("TC_Number");

tobeConverted.add("Enter_TC_Number");
tobeConverted.add("Name_Of_The_Lessee");
tobeConverted.add("Enter_Lessee_Name");
tobeConverted.add("Issued_Date");
tobeConverted.add("Enter_Issued_Date");

tobeConverted.add("Id");
tobeConverted.add("District_Code");
tobeConverted.add("Taluk_Code");
tobeConverted.add("Customer_Name");

tobeConverted.add("REG_IBM");
tobeConverted.add("Enter_REG_IBM");
tobeConverted.add("Mine_Code");
tobeConverted.add("Enter_Mine_Code");

tobeConverted.add("Mineral_Name");
tobeConverted.add("Select_Mineral_Name");
tobeConverted.add("Name_Of _Mine");
tobeConverted.add("Enter_Name_Of _Mine");

tobeConverted.add("State");
tobeConverted.add("Select_State");
tobeConverted.add("PinCode");
tobeConverted.add("Enter_Pincode");

tobeConverted.add("Fax");
tobeConverted.add("Enter_Fax");
tobeConverted.add("Phone_No");
tobeConverted.add("Enter_Phone_No");

tobeConverted.add("Email");
tobeConverted.add("Enter_Email");
tobeConverted.add("Post_Office");
tobeConverted.add("Enter_Post_Office");
tobeConverted.add("EC_Capping_Limit");
tobeConverted.add("Enter_EC_Capping_Limit");

tobeConverted.add("Processing_Plant");
tobeConverted.add("Select_Processing_Plant");
tobeConverted.add("MPL");
tobeConverted.add("Enter_MPL");
tobeConverted.add("Wallet_Linked");
tobeConverted.add("Select_Wallet_Linked");
tobeConverted.add("Amount_Of_ROM");
tobeConverted.add("Quantity_Of_ROM");
tobeConverted.add("MPL_Balance");
tobeConverted.add("Enter_MPL_Balance");
tobeConverted.add("Hub");
tobeConverted.add("Select_Hub");
tobeConverted.add("Select_Mine_Code");
tobeConverted.add("Hub_Id");
tobeConverted.add("Mine_Code_Id");
tobeConverted.add("Lease_Name");
tobeConverted.add("Mine_Name");
tobeConverted.add("Lease_Area");
tobeConverted.add("Enter_Mine_Name");
tobeConverted.add("Enter_Lease_Area");
tobeConverted.add("Enter_Valid_Email_Id");
tobeConverted.add("Year");
tobeConverted.add("Enter_Year");

ArrayList<String> convertedWords = new ArrayList<String>();
convertedWords = cf.getLanguageSpecificWordForKey(tobeConverted,language);
String Add=convertedWords.get(0);
String Modify=convertedWords.get(1);
String NoRecordsFound=convertedWords.get(2);
String ClearFilterData=convertedWords.get(3);
String Save=convertedWords.get(4);
String Cancel=convertedWords.get(5);

String SLNO=convertedWords.get(6);
String NoRowsSelected=convertedWords.get(7);
String SelectSingleRow=convertedWords.get(8);
String AddDetails=convertedWords.get(9);
String SelectCustomer=convertedWords.get(10);

String District=convertedWords.get(11);
String Taluka=convertedWords.get(12);
String Village=convertedWords.get(13);
String Area=convertedWords.get(14);
String Status=convertedWords.get(15);

String SelectDistrict=convertedWords.get(16);
String SelectTaluka=convertedWords.get(17);
String EnterVillage=convertedWords.get(18);
String EnterArea=convertedWords.get(19);
String SelectStatus=convertedWords.get(20);

String TCMaster=convertedWords.get(21);
String TCMasterDetails=convertedWords.get(22);
String OrderNumber=convertedWords.get(23);
String EnterOrderNumber=convertedWords.get(24);
String TCNumber=convertedWords.get(25);


String EnterTCNumber=convertedWords.get(26);
String NameOfTheLessee =convertedWords.get(27);
String EnterLesseeName=convertedWords.get(28);
String IssuedDate=convertedWords.get(29);
String EnterIssuedDate=convertedWords.get(30);

String Id=convertedWords.get(31);
String DistrictCode=convertedWords.get(32);
String TalukCode=convertedWords.get(33);
String CustomerName=convertedWords.get(34);

String REGIBM=convertedWords.get(35);
String EnterREGIBM=convertedWords.get(36);
String MineCode=convertedWords.get(37);
String EnterMineCode=convertedWords.get(38);

String NameOfMineral=convertedWords.get(39);
String EnterNameOfMineral=convertedWords.get(40);
String NameOfMine=convertedWords.get(41);
String EnterNameOfMine=convertedWords.get(42);

String State=convertedWords.get(43);
String SelectState=convertedWords.get(44);
String pin=convertedWords.get(45);
String EnterPin=convertedWords.get(46);

String FaxNo=convertedWords.get(47);
String EnterFaxNo=convertedWords.get(48);
String PhoneNo=convertedWords.get(49);
String EnterPhoneNo=convertedWords.get(50);

String Email=convertedWords.get(51);
String EnterEmail=convertedWords.get(52);
String PostOffice=convertedWords.get(53);
String EnterPostOffice=convertedWords.get(54);

String EcCappingLimit=convertedWords.get(55);
String EnterEcCappingLimit=convertedWords.get(56);

String ProcessingPlant=convertedWords.get(57);
String SelectProcessingPlant=convertedWords.get(58);
String MPL=convertedWords.get(59);
String EnterMPL=convertedWords.get(60);
String WalletLinked=convertedWords.get(61);
String SelectWalletLinked=convertedWords.get(62);
String AmountOfROM=convertedWords.get(63);
String QuantityOfROM=convertedWords.get(64);
String MPLBalance=convertedWords.get(65);
String EnterMPLBalance=convertedWords.get(66);
String HUB=convertedWords.get(67);
String SelectHUB=convertedWords.get(68);
String SelectMineCode=convertedWords.get(69);
String HubId=convertedWords.get(70);
String MineCodeId=convertedWords.get(71);
String LeaseName=convertedWords.get(72);
String MineName=convertedWords.get(73);
String LeaseArea=convertedWords.get(74);
String EnterMineName=convertedWords.get(75);
String EnterLeaseArea=convertedWords.get(76);
String EnterValidEmailId=convertedWords.get(77);
String Year=convertedWords.get(78);
String Enter_Year=convertedWords.get(79);
String MplShouldBeLess="MPL Allocated should not be more then EC Allocated of Mine";
String EnterEnhance="Enter MPL Enhanced";
String EnterMPLProduction="Total Production";
String EnterMPLtransportation="Total Transportation";
String EnterMPLCarryForward="Carry Forward";

int userId=loginInfo.getUserId(); 
int systemId = loginInfo.getSystemId();
int customerId = loginInfo.getCustomerId();

String userAuthority=cf.getUserAuthority(systemId,userId);	

if(customerId > 0 && loginInfo.getIsLtsp()== -1 && !userAuthority.equalsIgnoreCase("Admin"))
	{
		response.sendRedirect(request.getContextPath()+ "/Jsps/Common/401Error.html");
	}
	else{
Calendar calender=Calendar.getInstance();
//calender.set(Calendar.MONTH,Calendar.MONTH+1);
//System.out.println(calender.get(Calendar.MONTH));
boolean carryEditable=false;
if(calender.get(Calendar.MONTH)==3){ carryEditable=true; }
String year="";
String curYear=String.valueOf(calender.get(Calendar.YEAR));
String preYear=String.valueOf(calender.get(Calendar.YEAR)-1);
String nextYear=String.valueOf(calender.get(Calendar.YEAR)+1);
if(calender.get(Calendar.MONTH) >=3){
	year = curYear+"-"+nextYear;
}else{
	year = preYear+"-"+curYear;
}
%>

<jsp:include page="../Common/header.jsp" />
		<base href="<%=basePath%>">
		<title><%=TCMasterDetails%></title>
	
	 <%if (loginInfo.getStyleSheetOverride().equals("Y")){%>
       <jsp:include page="../Common/ImportJSSandMining.jsp"/>
	   <jsp:include page="../IronMining/css.jsp" />
		<%}else {%>
		<jsp:include page="../Common/ImportJS.jsp" />
		<jsp:include page="../IronMining/css.jsp" />
		<%} %>
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
			div#myWin {
				top : 52px !important;
			}
		</style>
	 <%}%>
 <script>
  var innerpage=<%=ipVal%>;
	
	   	    if (innerpage == true) {
				
				if(document.getElementById("topNav")!=null && document.getElementById("topNav")!=undefined)
				{
					document.getElementById("topNav").style.display = "none";
					$(".container").css({"margin-top":"-72px"});
				}
				
			}
  var outerPanel;
  var jspName = "TC Master Details";
  var exportDataType = "int,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,number,number,number,string,string,string,string,string,string,number,number,string,string,string,string,number,string,number,number,number,number";
  var grid;
  var myWin;
  var buttonValue;
  var talukModify;
  var districtModify;
  var districtModify1;
  var stateModify;
  var stateModify1;
  var hubModify;
  var mineCodeModify;
  var hubStore;
  var mineCodeStore;
  var ecLimit;
  var ecCapLimit;
  var year='<%=year%>';
  var maxCarryedTC=0;
  var productionBal=0;
  Ext.apply(Ext.form.VTypes, {
                hyphenMask:/[0-9-]/,
                hyphenRe: /^\d+-\d{1,2}$/,  
                hyphen:function(x){
                return this.hyphenRe.test(x);
                }   
            });  
  //----------------------------------customer store---------------------------// 
  var customercombostore = new Ext.data.JsonStore({
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
                  statecombostore.load();
                  store.load({
                      params: {
                          CustId: custId,
                          jspName: jspName,
                          CustName: Ext.getCmp('custcomboId').getRawValue()
                      }
                  });
                  hubStore.load({
                      params: {
                          clientId:custId
                      }
                  });
                  mineCodeStore.load({
                      params: {
                          clientId:custId
                      }
                  });
              }
          }
      }
  });
  //******************************************************************customer Combo******************************************//
  var custnamecombo = new Ext.form.ComboBox({
      store: customercombostore,
      id: 'custcomboId',
      mode: 'local',
      forceSelection: true,
      emptyText: '<%=SelectCustomer%>',
      resizable: true,
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
                  custName = Ext.getCmp('custcomboId').getRawValue();
                  statecombostore.load();
                  store.load({
                      params: {
                          CustId: custId,
                          jspName: jspName,
                          CustName: Ext.getCmp('custcomboId').getRawValue()
                      }
                  });
                  hubStore.load({
                      params: {
                          clientId:custId
                      }
                  });
                  mineCodeStore.load({
                      params: {
                          clientId:custId
                      }
                  });
              }
          }
      }
  });
  //*************************************************Client Panel**************************************************************//
  var clientPanel = new Ext.Panel({
      standardSubmit: true,
      collapsible: false,
      id: 'clientPanelId',
      layout: 'table',
      frame: false,
      width: screen.width - 60,
      height: 50,
      layoutConfig: {
          columns: 15
      },
      items: [{
              xtype: 'label',
              text: '<%=CustomerName%>' + ' :',
              cls: 'labelstyle',
              id: 'ltspcomboId'
          },
          custnamecombo, {
              width: 40
          }
      ]
  });
  //******************************************Add and Modify function *********************************************************************//
  //----------------------------------------------State Store --------------------------------------------//
    var statecombostore = new Ext.data.JsonStore({
      url: '<%=request.getContextPath()%>/CommonAction.do?param=getStates',
      id: 'StateStoreId',
      root: 'StateRoot',
      autoLoad: true,
      remoteSort: true,
      fields: ['StateID', 'stateName']
  });
  
  //----------------------------------------------State Combo --------------------------------------------//
var State = new Ext.form.ComboBox({
      store: statecombostore,
      id: 'stateId',
      mode: 'local',
      forceSelection: true,
      emptyText: '<%=SelectState%>',
      blankText: '<%=SelectState%>',
      resizable: true,
      selectOnFocus: true,
      allowBlank: false,
      anyMatch: true,
      typeAhead: false,
      triggerAction: 'all',
      lazyRender: true,
      valueField: 'StateID',
      displayField: 'stateName',
      cls: 'selectstylePerfectnew',
      listeners: {
          select: {
              fn: function() {
                  var stateId = Ext.getCmp('stateId').getValue();
                  Ext.getCmp('districtComboId').reset();
                  Ext.getCmp('talukComboId').reset();
                  districtStore.load({
                      params: {
                          stateId: stateId
                      }
                  });
                  talukStore.load({
                      params: {
                          DistId: Ext.getCmp('districtComboId').getValue()
                      }
                  });
              }
          }
      }
  });
  
   var maxCarryedTCStore= new Ext.data.JsonStore({
				   url: '<%=request.getContextPath()%>/MiningTCMasterAction.do?param=getMaxCarryForwardedTC',
				   root: 'maxCarryedTCRoot',
			       autoLoad: false,
			       id: 'maxCarryedTCStoreId',
				   fields: ['MAX_CARRYED_TC','MINE_ID']
	});	
	
	   var productionStore= new Ext.data.JsonStore({
				   url: '<%=request.getContextPath()%>/MiningTCMasterAction.do?param=getProductionQty',
				   root: 'proRoot',
			       autoLoad: false,
			       id: 'stid',
				   fields: ['PRODUCTION_BAL']
	});	

  
  //----------------------------------------------District Store --------------------------------------------//
  var districtStore = new Ext.data.JsonStore({
      url: '<%=request.getContextPath()%>/MiningTCMasterAction.do?param=getDistrictNames',
      id: 'districteStoreId',
      root: 'districtCodeRoot',
      autoLoad: false,
      remoteSort: true,
      fields: ['District', 'Value'],
  });
  
  //----------------------------------------------District Combo --------------------------------------------//
  var districtCombo = new Ext.form.ComboBox({
      store: districtStore,
      id: 'districtComboId',
      mode: 'local',
      forceSelection: true,
      selectOnFocus: true,
      allowBlank: false,
      anyMatch: true,
      typeAhead: false,
      triggerAction: 'all',
      lazyRender: true,
      valueField: 'Value',
      emptyText: '<%=SelectDistrict%>',
      resizable: true,
      displayField: 'District',
      cls: 'selectstylePerfectnew',
      listeners: {
          select: {
              fn: function() {
                  districtId = Ext.getCmp('districtComboId').getValue();
                  districtName = Ext.getCmp('districtComboId').getRawValue();
                  Ext.getCmp('talukComboId').reset();
                  talukStore.load({
                      params: {
                          DistId: districtId
                      }
                  });
              }
          }
      }
  });
  
  var talukStore = new Ext.data.JsonStore({
      url: '<%=request.getContextPath()%>/MiningTCMasterAction.do?param=gettalukNames',
      id: 'talukeStoreId',
      root: 'talukRoot',
      autoLoad: true,
      remoteSort: true,
      fields: ['Taluk', 'Value'],
      listeners: {}
  });
  
  var talukCombo = new Ext.form.ComboBox({
      store: talukStore,
      id: 'talukComboId',
      mode: 'local',
      forceSelection: true,
      selectOnFocus: true,
      allowBlank: false,
      anyMatch: true,
      typeAhead: false,
      triggerAction: 'all',
      lazyRender: true,
      valueField: 'Value',
      emptyText: '<%=SelectTaluka%>',
      resizable: true,
      displayField: 'Taluk',
      cls: 'selectstylePerfectnew',
      listeners: {
          select: {
              fn: function() {}
          }
      }
  });
  
  var statusTypeStore = new Ext.data.SimpleStore({
      id: 'ststusStoreId',
      autoLoad: true,
      fields: ['Status', 'Value'],
      data: [
          ['Executed', '1'],
          ['In process', '2'],
          ['Lease Executed', '3']
      ]
  });
  
  var statusCombo = new Ext.form.ComboBox({
      store: statusTypeStore,
      id: 'statusId',
      mode: 'local',
      forceSelection: true,
      selectOnFocus: true,
      resizable: true,
      allowBlank: false,
      anyMatch: true,
      typeAhead: false,
      triggerAction: 'all',
      lazyRender: true,
      valueField: 'Value',
      emptyText: '<%=SelectStatus%>',
      displayField: 'Status',
      cls: 'selectstylePerfectnew',
      listeners: {}
  });
  
   mineCodeStore= new Ext.data.JsonStore({
            url: '<%=request.getContextPath()%>/MiningTCMasterAction.do?param=getMineCodeForTCMaster',
            root: 'mineCodeRoot',
            autoLoad: false,
            fields: ['mineId', 'mineName','miningname','ecLimit','ecCapLimit','nameOfLesse']
   });
  
  var mineCodeCombo = new Ext.form.ComboBox({
      store: mineCodeStore,
      id: 'mineCodeId',
      mode: 'local',
      forceSelection: true,
      selectOnFocus: true,
      allowBlank: false,
      anyMatch: true,
      typeAhead: false,
      triggerAction: 'all',
      lazyRender: true,
      valueField: 'mineId',
      emptyText: '<%=SelectMineCode%>',
      resizable: true,
      displayField: 'mineName',
      cls: 'selectstylePerfectnew',
        listeners: {
        select: {
              fn: function () {
     	       var id=Ext.getCmp('mineCodeId').getValue();
            var row = mineCodeStore.findExact('mineId',id);
            var rec = mineCodeStore.getAt(row);
            minename=rec.data['miningname'];
            ecLimit=rec.data['ecLimit'];
            ecCapLimit=rec.data['ecCapLimit'];
            nameOfLesse=rec.data['nameOfLesse'];
            Ext.getCmp('minenameeId').setValue(minename);
            Ext.getCmp('nameOfTheIssueId').setValue(nameOfLesse);
            
             maxCarryedTCStore.load({
            	params:{            	
            		custId: Ext.getCmp('custcomboId').getValue(),
            		mineId: Ext.getCmp('mineCodeId').getValue(),
            		year: year
            	},
            	callback: function(){
            		maxCarryedTC=maxCarryedTCStore.getAt(0).data['MAX_CARRYED_TC']
            		
            	}
            });
        }
    }
    }
  });
  
   var processingStore = new Ext.data.SimpleStore({
      id: 'processingStoreId',
      autoLoad: true,
      fields: ['name', 'Value'],
      data: [
          ['Yes', 'yes'],
          ['No', 'no']
      ]
  });
  
  var processingCombo = new Ext.form.ComboBox({
      store: processingStore,
      id: 'processingId',
      mode: 'local',
      forceSelection: true,
      selectOnFocus: true,
      allowBlank: false,
      anyMatch: true,
      typeAhead: false,
      triggerAction: 'all',
      lazyRender: true,
      valueField: 'Value',
      emptyText: '<%=SelectProcessingPlant%>',
      resizable: true,
      displayField: 'name',
      cls: 'selectstylePerfectnew',
      listeners: { 
      select: {
              fn: function() {
                  if(Ext.getCmp('processingId').getValue() == 'yes'){
	                  Ext.getCmp('hubComboId').reset();
	                  Ext.getCmp('hubComboId').setReadOnly(false);
                  }
                  if(Ext.getCmp('processingId').getValue() == 'no'){
	                  Ext.getCmp('hubComboId').reset();
	                  Ext.getCmp('hubComboId').setReadOnly(true);
                  }
                 }
              }
          }
  });
  
  var walletLinkedStore = new Ext.data.SimpleStore({
      id: 'walletLinkedStoreId',
      autoLoad: true,
      fields: ['name', 'Value'],
      data: [
          ['ROM', 'ROM'],
          ['PROCESSED ORE', 'PROCESSED ORE'],
          ['BAUXITE','BAUXITE']
      ]
  });
  
  var walletLinkedCombo = new Ext.form.ComboBox({
      store: walletLinkedStore,
      id: 'walletLinkedId',
      mode: 'local',
      forceSelection: true,
      selectOnFocus: true,
      allowBlank: false,
      anyMatch: true,
      typeAhead: false,
      triggerAction: 'all',
      lazyRender: true,
      valueField: 'Value',
      emptyText: 'Select EC Linked',
      resizable: true,
      displayField: 'name',
      cls: 'selectstylePerfectnew',
      listeners: {}
  });
  
   hubStore = new Ext.data.JsonStore({
            url: '<%=request.getContextPath()%>/MiningTCMasterAction.do?param=getHubForTCMaster',
            root: 'hubRoot',
            autoLoad: false,
            fields: ['hubId', 'hubName']
   });
        
   var hubCombo= new Ext.form.ComboBox({    
      store: hubStore,
      id: 'hubComboId',
      mode: 'local',
      forceSelection: true,
      selectOnFocus: true,
      allowBlank: false,
      anyMatch: true,
      typeAhead: false,
      triggerAction: 'all',
      lazyRender: true,
      valueField: 'hubId',
      resizable:true,
      emptyText: '<%=SelectHUB%>',
      blankText: '<%=SelectHUB%>',
      resizable: true,
      displayField: 'hubName',
      cls: 'selectstylePerfectnew',
      listeners: {
      }
   });
  var mineralnameStore = new Ext.data.SimpleStore({
      id: 'mineralnameStoreId',
      autoLoad: true,
      fields: ['name', 'Value'],
      data: [
             ['Iron Ore', 'Iron Ore'],
	         ['Bauxite/Laterite', 'Bauxite/Laterite'],
			 ['Manganese', 'Manganese']
      ]
  });
  
  var mineralnameCombo = new Ext.form.ComboBox({
      store: mineralnameStore,
      id: 'mineralNameId',
      mode: 'local',
      forceSelection: true,
      selectOnFocus: true,
      allowBlank: false,
      anyMatch: true,
      typeAhead: false,
      triggerAction: 'all',
      lazyRender: true,
      valueField: 'Value',
      emptyText: '<%=NameOfMineral%>',
      resizable: true,
      displayField: 'name',
      cls: 'selectstylePerfectnew',
      listeners: { }
  });
  
  //******************* 
  var innerPanelForTCMasterDetails = new Ext.form.FormPanel({
      standardSubmit: true,
      collapsible: false,
      autoScroll: false,
      height: 417,
      width: 1290,
      frame: true,
      id: 'innerPanelForGradeDetailsId',
      layout: 'table',
      resizable: true,
      layoutConfig: {
          columns: 4
      },
      items: [{
          xtype: 'fieldset',
          title: '<%=TCMasterDetails%>',
          cls: 'my-fieldset',
          collapsible: false, 
          colspan: 3,
          id: 'TCMasterDetailsid',
          width: 1290,
          height: 395,
          layout: 'table',
          autoScroll:true,
          layoutConfig: {
              columns: 4
          },
          items: [{
	        xtype: 'panel',
	        id: 'FHid',
	        width: 420,
	        layout: 'table',
	        layoutConfig: {
	            columns: 3
	        },
          items: [{
              xtype: 'label',
              text: '*',
              cls: 'mandatoryfield',
              id: 'regIbmEmptyId'
          }, {
              xtype: 'label',
              text: '<%=REGIBM%>' + ' :',
              cls: 'labelstylenew',
              id: 'regIbmLabelId'
          }, {
              xtype: 'textfield',
              cls: 'selectstylePerfectnew',
              allowBlank: false,
              blankText: '<%=EnterREGIBM%>',
              emptyText: '<%=EnterREGIBM%>',
              listeners:{
					change: function(field, newValue, oldValue){
					field.setValue(newValue.toUpperCase().trim());
					 if(field.getValue().length> 50){ 
					Ext.example.msg("Field exceeded it's Maximum length");
					field.setValue(newValue.substr(0,50).toUpperCase().trim()); field.focus();
					 } 
					 }
					},
              labelSeparator: '',
              allowBlank: false,
              id: 'regIbmId'
              
          },{
              xtype: 'label',
              text: '*',
              cls: 'mandatoryfield',
              id: 'mineCodeEmptyId'
          }, {
              xtype: 'label',
              text: '<%=MineCode%>' + ' :',
              cls: 'labelstylenew',
              id: 'mineCodeLabelId'
          },mineCodeCombo,
          {
              xtype: 'label',
              text: '*',
              cls: 'mandatoryfield',
              id: 'minenameEmptyId'
          }, {
              xtype: 'label',
              text: '<%=MineName%>' + ' :',
              cls: 'labelstylenew',
              id: 'minenameLabelId'
          }, {
              xtype: 'textfield',
              cls: 'selectstylePerfectnew',
              allowBlank: false,
              stripCharsRe :/[,]/,
              blankText: '<%=EnterMineName%>',
              emptyText: '<%=EnterMineName%>',
              readOnly:true,
            listeners:{
					change: function(field, newValue, oldValue){
					 if(field.getValue().length> 50){ 
					Ext.example.msg("Field exceeded it's Maximum length");
					field.setValue(newValue.substr(0,50)); field.focus();
					}
					 }
					},
              mode: 'local',
              id: 'minenameeId'
            
          },
         {
              xtype: 'label',
              text: '*',
              cls: 'mandatoryfield',
              id: 'TCNumberEmptyId'
          }, {
              xtype: 'label',
              text: '<%=TCNumber%>' + ' :',
              cls: 'labelstylenew',
              id: 'TCNumberLabelId'
          }, {
              xtype: 'textfield',
              cls: 'selectstylePerfectnew',
              allowBlank: false,
              blankText: '<%=EnterTCNumber%>',
              emptyText: '<%=EnterTCNumber%>',
              listeners:{
					change: function(field, newValue, oldValue){
					 if(field.getValue().length> 10){ 
					Ext.example.msg("Field exceeded it's Maximum length");
					field.setValue(newValue.substr(0,10)); field.focus();
					 } 
					 }
					},
              labelSeparator: '',
              allowBlank: false,
              id: 'TCNumberId'
          },{
              xtype: 'label',
              text: '*',
              cls: 'mandatoryfield',
              id: 'yearEmptyId'
          }, {
              xtype: 'label',
              text: '<%=Year%>' + ' :',
              cls: 'labelstylenew',
              id: 'yearLabelId'
          }, {
              xtype: 'numberfield',
              cls: 'selectstylePerfectnew',
              allowBlank: false,
              listeners:{ change: function(f, n, o){ f.setValue(Math.abs(n)); } },
              blankText: '<%=Enter_Year%>',
              emptyText: '<%=Enter_Year%>',
              autoCreate: { //restricts user to 10 chars max, cannot enter 21st char
                   tag: "input",
                   maxlength: 4,
                   type: "text",
                   size: "4",
                   autocomplete: "off"
               },
              labelSeparator: '',
              allowBlank: false,
              id: 'yearId'
          }, {
              xtype: 'label',
              text: '*',
              cls: 'mandatoryfield',
              id: 'mineralNameEmptyId'
          }, {
              xtype: 'label',
              text: '<%=NameOfMineral%>' + ' :',
              cls: 'labelstylenew',
              id: 'mineralNameLabelId'
          }, mineralnameCombo,{
              xtype: 'label',
              text: '*',
              cls: 'mandatoryfield',
              id: 'mineNameEmptyId'
          }, {
              xtype: 'label',
              text: '<%=LeaseName%>' + ' :',
              cls: 'labelstylenew',
              id: 'mineNameLabelId'
          }, {
              xtype: 'textfield',
              cls: 'selectstylePerfectnew',
              allowBlank: false,
              blankText: '<%=EnterNameOfMine%>',
              emptyText: '<%=EnterNameOfMine%>',
             listeners:{
					change: function(field, newValue, oldValue){
					field.setValue(newValue.toUpperCase().trim());
					if(field.getValue().length> 100){ 
					Ext.example.msg("Field exceeded it's Maximum length");
					field.setValue(newValue.substr(0,100).toUpperCase().trim()); field.focus();
					 } 
					}
					},
              labelSeparator: '',
              allowBlank: false,
              id: 'mineNameId'
           },  {
              xtype: 'label',
              text: '*',
              cls: 'mandatoryfield',
              id: 'LeaseareaEmptyId'
          }, {
              xtype: 'label',
              text: '<%=LeaseArea%>' + ' :',
              cls: 'labelstylenew',
              id: 'leaseareaLabelId'
          }, {
              xtype: 'numberfield',
              cls: 'selectstylePerfectnew',
              allowBlank: false,
              listeners:{ change: function(f, n, o){ f.setValue(Math.abs(n)); } },
              blankText: '<%=EnterLeaseArea%>',
              emptyText: '<%=EnterLeaseArea%>',
              autoCreate: { //restricts user to 50 chars max, 
                   tag: "input",
                   maxlength: 10,
                   type: "text",
                   size: "50",
                   autocomplete: "off"
               },
              labelSeparator: '',
              decimalPrecision:6,
              allowBlank: false,
              id: 'leaseAreaId'
          },{
              xtype: 'label',
              text: '*',
              cls: 'mandatoryfield',
              id: 'nameOfTheEmptyId'
          }, {
              xtype: 'label',
              text: '<%=NameOfTheLessee%>' + ' :',
              cls: 'labelstylenew',
              id: 'nameOfTheLabelId'
          }, {
              xtype: 'textfield',
              cls: 'selectstylePerfectnew',
              allowBlank: false,
              readOnly:true,
              blankText: '<%=EnterLesseeName%>',
              emptyText: '<%=EnterLesseeName%>',
              autoCreate: {//restricts user to 200 chars max, 
                   tag: "input",
                   maxlength: 200,
                   type: "text",
                   size: "200",
                   autocomplete: "off"
               },
              labelSeparator: '',
              allowBlank: false,
              id: 'nameOfTheIssueId'
          },{
              xtype: 'label',
              text: '*',
              cls: 'mandatoryfield',
              id: 'orderNumberEmptyId'
          }, {
              xtype: 'label',
              text: '<%=OrderNumber%>' + ' :',
              cls: 'labelstylenew',
              id: 'orderNumberLabelId'
          }, {
              xtype: 'textfield',
              cls: 'selectstylePerfectnew',
              allowBlank: false,
              blankText: '<%=EnterOrderNumber%>',
              emptyText: '<%=EnterOrderNumber%>',
              listeners:{
					change: function(field, newValue, oldValue){
					if(field.getValue().length> 50){ 
					Ext.example.msg("Field exceeded it's Maximum length");
					field.setValue(newValue.substr(0,50)); field.focus();
					 } 
					}
					},
              labelSeparator: '',
              allowBlank: false,
              id: 'orderNumberId'
          }, {
              xtype: 'label',
              text: '*',
              cls: 'mandatoryfield',
              id: 'issuedDateEmptyId'
          }, {
              xtype: 'label',
              text: 'Order Date' + ' :',
              cls: 'labelstylenew',
              id: 'issuedDateLabelId'
          }, {
              xtype: 'datefield',
              cls: 'selectstylePerfectnew',
              allowBlank: false,
              blankText: 'Enter Order Date',
              emptyText: 'Enter Order Date',
              format: getDateFormat(),
              labelSeparator: '',
              allowBlank: false,
              id: 'issuedDateId'
          }]
        	},{
	        xtype: 'panel',
	        id: 'SHid',
	        width: 400,
	        layout: 'table',
	        layoutConfig: {
	            columns: 3
	        },
	        items: [{
              xtype: 'label',
              text: '*',
              cls: 'mandatoryfield',
              id: 'stateEmptyId'
          }, {
              xtype: 'label',
              text: '<%=State%>' + ' :',
              cls: 'labelstylenew',
              id: 'stateLabelId'
          },State,{
              xtype: 'label',
              text: '*',
              cls: 'mandatoryfield',
              id: 'districtEmptyId'
          }, {
              xtype: 'label',
              text: '<%=District%>' + ' :',
              cls: 'labelstylenew',
              id: 'districtLabelId'
          }, districtCombo,{
            xtype: 'label',
              text: '*',
              cls: 'mandatoryfield',
              id: 'talukEmptyId'
          }, {
              xtype: 'label',
              text: '<%=Taluka%>' + ' :',
              cls: 'labelstylenew',
              id: 'talukLabelId'
          }, talukCombo, {
              xtype: 'label',
              text: '*',
              cls: 'mandatoryfield',
              id: 'villageEmptyId'
          }, {
              xtype: 'label',
              text: '<%=Village%>' + ' :',
              cls: 'labelstylenew',
              id: 'villageLabelId'
          }, {
              xtype: 'textfield',
              cls: 'selectstylePerfectnew',
              allowBlank: false,
              blankText: '<%=EnterVillage%> ',
              emptyText: '<%=EnterVillage%> ',
              listeners:{
					change: function(field, newValue, oldValue){
					if(field.getValue().length> 50){ 
					Ext.example.msg("Field exceeded it's Maximum length");
					field.setValue(newValue.substr(0,50)); field.focus();
					 } 
					}
					},
              labelSeparator: '',
              allowBlank: false,
              id: 'villageId'
          },{
              xtype: 'label',
              text: '*',
              cls: 'mandatoryfield',
              id: 'ctoCodeEmptyId'
          }, {
              xtype: 'label',
              text: 'CTO Code' + ' :',
              cls: 'labelstylenew',
              id: 'ctoCodeLabelId'
          }, {
              xtype: 'textfield',
              cls: 'selectstylePerfectnew',
              allowBlank: false,
              blankText: 'Enter CTO Code ',
              emptyText: 'Enter CTO Code ',
              listeners:{
					change: function(field, newValue, oldValue){
					if(field.getValue().length> 50){ 
					Ext.example.msg("Field exceeded it's Maximum length");
					field.setValue(newValue.substr(0,50)); field.focus();
					 } 
					}
					},
              labelSeparator: '',
              allowBlank: false,
              id: 'ctoCodeId'
          },{
              xtype: 'label',
              text: '*',
              cls: 'mandatoryfield',
              id: 'ctoDateEmptyId'
          }, {
              xtype: 'label',
              text: 'CTO Date' + ' :',
              cls: 'labelstylenew',
              id: 'ctoDateLabelId'
          }, {
              xtype: 'datefield',
              cls: 'selectstylePerfectnew',
              allowBlank: false,
              blankText: 'Select CTO Date',
              emptyText: 'select CTO Date ',
              labelSeparator: '',
              format: getDateFormat(),
              allowBlank: false,
              id: 'ctoDateId'
          },{
              xtype: 'label',
              text: ' ',
              cls: 'mandatoryfield',
              id: 'areaEmptyId'
          }, {
              xtype: 'label',
              text: '<%=PostOffice%>' + ' :',
              cls: 'labelstylenew',
              id: 'areaLabelId'
          }, {
              xtype: 'textfield',
              cls: 'selectstylePerfectnew',
              allowBlank: false,
              blankText: '<%=EnterPostOffice%>',
              emptyText: '<%=EnterPostOffice%>',
              listeners:{
					change: function(field, newValue, oldValue){
					if(field.getValue().length> 50){ 
					Ext.example.msg("Field exceeded it's Maximum length");
					field.setValue(newValue.substr(0,50)); field.focus();
					 } 
					}
					},
              labelSeparator: '',
              allowBlank: false,
              id: 'areaId'
          }, {
              xtype: 'label',
              text: ' ',
              cls: 'mandatoryfield',
              id: 'pinEmptyId'
          }, {
              xtype: 'label',
              text: '<%=pin%>' + ' :',
              cls: 'labelstylenew',
              id: 'pinLabelId'
          }, {
              xtype: 'numberfield',
              cls: 'selectstylePerfectnew',
              allowBlank: false,
              listeners:{ change: function(f, n, o){ f.setValue(Math.abs(n)); } },
              blankText: '<%=EnterPin%>',
              emptyText: '<%=EnterPin%>',
              autoCreate: {//restricts user to 6 chars max, 
                   tag: "input",
                   maxlength: 6,
                   type: "text",
                   size: "6",
                   autocomplete: "off"
               },
              labelSeparator: '',
              allowNegetive: false,
               allowDecimals:false,
              id: 'pinId'
          }, {
              xtype: 'label',
              text: ' ',
              cls: 'mandatoryfield',
              id: 'faxNoEmptyId'
          }, {
              xtype: 'label',
              text: '<%=FaxNo%>' + ' :',
              cls: 'labelstylenew',
              id: 'faxNoLabelId'
          }, {
              xtype: 'textfield',
              cls: 'selectstylePerfectnew',
              allowBlank: false,
              blankText: '<%=EnterFaxNo%>',
              emptyText: '<%=EnterFaxNo%>',
              vtype:'hyphen',
              autoCreate: {//restricts user to 20 chars max, 
                   tag: "input",
                   maxlength: 20,
                   type: "text",
                   size: "20",
                   autocomplete: "off"
               },
              labelSeparator: '',
              allowBlank: false,
              id: 'faxNoId'
          }, {
              xtype: 'label',
              text: ' ',
              cls: 'mandatoryfield',
              id: 'phoneNoEmptyId'
          }, {
              xtype: 'label',
              text: '<%=PhoneNo%>' + ' :',
              cls: 'labelstylenew',
              id: 'phoneNoeLabelId'
          }, {
              xtype: 'textfield',
              cls: 'selectstylePerfectnew',
              allowBlank: false,
              blankText: '<%=EnterPhoneNo%>',
              emptyText: '<%=EnterPhoneNo%>',
              listeners:{
					change: function(field, newValue, oldValue){
					if(field.getValue().length> 10){ 
					Ext.example.msg("Field exceeded it's Maximum length");
					field.setValue(newValue.substr(0,10)); field.focus();
					 } 
					}
					},
              labelSeparator: '',
              allowBlank: false,
              id: 'phoneNoId'
          },{
              xtype: 'label',
              text: ' ',
              cls: 'mandatoryfield',
              id: 'emailEmptyId'
          }, {
              xtype: 'label',
              text: '<%=Email%>' + ' :',
              cls: 'labelstylenew',
              id: 'emailLabelId'
          }, {
              xtype: 'textfield',
              cls: 'selectstylePerfectnew',
              allowBlank: false,
              blankText: '<%=EnterEmail%>',
              emptyText: '<%=EnterEmail%>',
              listeners:{
					change: function(field, newValue, oldValue){
					if(field.getValue().length> 50){ 
					Ext.example.msg("Field exceeded it's Maximum length");
					field.setValue(newValue.substr(0,50)); field.focus();
					 } 
					}
					},
              labelSeparator: '',
              allowBlank: false,
              id: 'emailId'
          }]
        	},{
	        xtype: 'panel',
	        id: 'THid',
	        width: 400,
	        layout: 'table',
	        layoutConfig: {
	            columns: 3
	        },
	        items: [ {
              xtype: 'label',
              text: '*',
              cls: 'mandatoryfield',
              id: 'ststusEmptyId'
          }, {
              xtype: 'label',
              text: '<%=Status%>' + ' :',
              cls: 'labelstylenew',
              id: 'statusLabelId'
          }, statusCombo,
          {
              xtype: 'label',
              text: '*',
              cls: 'mandatoryfield',
              id: 'EcCappingLimitEmptyId'
          }, {
              xtype: 'label',
              text: 'MPL Allocated' + ' :',
              cls: 'labelstylenew',
              id: 'EcCappingLimitLabelId'
          }, {
              xtype: 'numberfield',
              cls: 'selectstylePerfectnew',
              allowBlank: false,
              blankText: '<%=EnterMPL%>',
              emptyText: '<%=EnterMPL%>',
              allowNegative: false,
              autoCreate: {//restricts user to 10 chars max, 
                   tag: "input",
                   maxlength: 10,
                   type: "text",
                   size: "10",
                   autocomplete: "off"
               },listeners:{
					change: function(f, n, o){
					 f.setValue(Math.abs(n));
					 Sum = Ext.getCmp('EcCappingLimitId').getValue()+Ext.getCmp('MplenhanceLimitId').getValue();
					  Ext.getCmp('MPLproductionLimitId').setValue(Sum);
					  
					  carrySum = Sum+Ext.getCmp('MplCarryForwardLimitId').getValue();
					  Ext.getCmp('MpltransportationLimitId').setValue(carrySum);
					 } 
					},
              labelSeparator: '',
              allowBlank: false,
              id: 'EcCappingLimitId'
          }, {
              xtype: 'label',
              text: '',
              cls: 'mandatoryfield',
              id: 'MplenhanceId'
          }, {
              xtype: 'label',
              text: 'MPL Enhanced' + ' :',
              cls: 'labelstylenew',
              id: 'MplenhanceLabelId'
          }, {
              xtype: 'numberfield',
              cls: 'selectstylePerfectnew',
              allowBlank: false,
              value :'0',
              allowNegative: false,
              autoCreate: {//restricts user to 10 chars max, 
                   tag: "input",
                   maxlength: 10,
                   type: "text",
                   size: "10",
                   autocomplete: "off"
               },listeners:{
					change: function(f, n, o){
					 f.setValue(Math.abs(n));
					 Sum = Ext.getCmp('EcCappingLimitId').getValue()+Ext.getCmp('MplenhanceLimitId').getValue();
					  Ext.getCmp('MPLproductionLimitId').setValue(Sum);
					  
					  carrySum = Sum+Ext.getCmp('MplCarryForwardLimitId').getValue();
					  Ext.getCmp('MpltransportationLimitId').setValue(carrySum);
					 } 
					},
              labelSeparator: '',
              allowBlank: false,
              id: 'MplenhanceLimitId'
          },{
              xtype: 'label',
              text: '',
              cls: 'mandatoryfield',
              id: 'MPLproductionId'
          }, {
              xtype: 'label',
              text: 'MPL for Production' + ' :',
              cls: 'labelstylenew',
              id: 'MPLproductionLabelId'
          }, {
              xtype: 'numberfield',
              cls: 'selectstylePerfectnew',
              allowBlank: false,
              listeners:{ change: function(f, n, o){ f.setValue(Math.abs(n)); } },
              blankText: '<%=EnterMPLProduction%>',
              emptyText: '<%=EnterMPLProduction%>',
              allowNegative: false,
              autoCreate: {//restricts user to 10 chars max, 
                   tag: "input",
                   maxlength: 10,
                   type: "text",
                   size: "10",
                   autocomplete: "off"
               },listeners:{
					change: function(f, n, o){
					 f.setValue(Math.abs(n));
					
					 } 
					},
					 readOnly:true,
              labelSeparator: '',
              allowBlank: false,
              id: 'MPLproductionLimitId'
          },
          {
              xtype: 'label',
              text: '',
              cls: 'mandatoryfield',
              id: 'MplCarryForwardId'
          }, {
              xtype: 'label',
              text: 'MPL Carry Forward' + ' :',
              cls: 'labelstylenew',
              id: 'MplCarryForwardLabelId'
          }, {
              xtype: 'numberfield',
              cls: 'selectstylePerfectnew',
              value :'0',
              allowBlank: false,
              listeners:{ change: function(f, n, o){ f.setValue(Math.abs(n)); } },
              blankText: '<%=EnterMPLCarryForward%>',
              emptyText: '<%=EnterMPLCarryForward%>',
              allowNegative: false,
              listeners:{
					change: function(f, n, o){
					 f.setValue(Math.abs(n));
					  Sum = Ext.getCmp('MPLproductionLimitId').getValue()+Ext.getCmp('MplCarryForwardLimitId').getValue();
					  Ext.getCmp('MpltransportationLimitId').setValue(Sum);
					 } 
					},
			 
              labelSeparator: '',
              allowBlank: false,
              id: 'MplCarryForwardLimitId'
          }, {
              xtype: 'label',
              text: '',
              cls: 'mandatoryfield',
              id: 'MpltransportationId'
          }, {
              xtype: 'label',
              text: 'MPL for Transportation' + ' :',
              cls: 'labelstylenew',
              id: 'MpltransportationLabelId'
          }, {
              xtype: 'numberfield',
              cls: 'selectstylePerfectnew',
              allowBlank: false,
              listeners:{ change: function(f, n, o){ f.setValue(Math.abs(n)); } },
               blankText: '<%=EnterMPLtransportation%>',
              emptyText: '<%=EnterMPLtransportation%>',
              allowNegative: false,
              autoCreate: {//restricts user to 10 chars max, 
                   tag: "input",
                   maxlength: 10,
                   type: "text",
                   size: "10",
                   autocomplete: "off"
               },
              readOnly:true,
              labelSeparator: '',
              allowBlank: false,
              id: 'MpltransportationLimitId'
          },{
              xtype: 'label',
              text: '*',
              cls: 'mandatoryfield',
              id: 'processingEmptyId'
          }, {
              xtype: 'label',
              text: '<%=ProcessingPlant%>' + ' :',
              cls: 'labelstylenew',
              id: 'processingLabelId'
          },processingCombo,
           {
              xtype: 'label',
              text: '*',
              cls: 'mandatoryfield',
              id: 'walletLinkedEmptyId'
          }, {
              xtype: 'label',
              text: 'EC Linked' + ' :',
              cls: 'labelstyle',
              id: 'walletLinkedLabelId'
          },walletLinkedCombo,
          { xtype: 'label',
              text: '*',
              cls: 'mandatoryfield',
              id: 'amountOfROMEmptyId'
          }, {
              xtype: 'label',
              text: '<%=AmountOfROM%>' + ' :',
              cls: 'labelstylenew',
              id: 'amountOfROMLabelId'
          },{
              xtype: 'numberfield',
              cls: 'selectstylePerfectnew',
              labelSeparator: '',
              readOnly:true,
              allowBlank: false,
              id: 'amountOfROMId'
          },{ xtype: 'label',
              text: '*',
              cls: 'mandatoryfield',
              id: 'quantityOfROMEmptyId'
          }, {
              xtype: 'label',
              text: '<%=QuantityOfROM%>' + ' :',
              cls: 'labelstylenew',
              id: 'quantityOfROMLabelId'
          },{
              xtype: 'numberfield',
              cls: 'selectstylePerfectnew',
              labelSeparator: '',
              readOnly:true,
              allowBlank: false,
              id: 'quantityOfROMId',
              readOnly: true
          },{ xtype: 'label',
              text: '*',
              cls: 'mandatoryfield',
              id: 'mplBalenceEmptyId'
          }, {
              xtype: 'label',
              text: '<%=MPLBalance%>' + ' :',
              cls: 'labelstylenew',
              id: 'mplBalenceLabelId'
          },{
              xtype: 'numberfield',
              cls: 'selectstylePerfect',
              readOnly:true,
              labelSeparator: '',
              allowBlank: false,
              id: 'mplBalenceId',
              readOnly: true
          },{ xtype: 'label',
              text: '*',
              cls: 'mandatoryfield',
              id: 'hubEmptyId'
          }, {
              xtype: 'label',
              text: '<%=HUB%>' + ' :',
              cls: 'labelstylenew',
              id: 'hubLabelId'
          },hubCombo
          ]
          }]
      }]
  });
  
  var innerWinButtonPanel = new Ext.Panel({
      id: 'winbuttonid',
      standardSubmit: true,
      collapsible: false,
      autoHeight: true,
      height: 50,
      width: 1270,
      frame: true,
      layout: 'table',
      layoutConfig: {
          columns: 4
      },
      buttons: [{
          xtype: 'button',
          text: '<%=Save%>',
          id: 'addButtId',
          cls: 'buttonstyle',
          iconCls: 'savebutton',
          width: 70,
          listeners: {
              click: {
                  fn: function() {
                      if (Ext.getCmp('custcomboId').getValue() == "") {
                          Ext.example.msg("<%=SelectCustomer%>");
                          Ext.getCmp('custcomboId').focus();
                          return;
                      }
                      if (Ext.getCmp('regIbmId').getValue() == "") {
                          Ext.example.msg("<%=EnterREGIBM%>");
                          Ext.getCmp('regIbmId').focus();
                          return;
                      }
                      if (Ext.getCmp('mineCodeId').getValue() == "") {
                          Ext.example.msg("<%=SelectMineCode%>");
                          Ext.getCmp('mineCodeId').focus();
                          return;
                      }
                      if (Ext.getCmp('TCNumberId').getValue() == "") {
                          Ext.example.msg("<%=EnterTCNumber%>");
                          Ext.getCmp('TCNumberId').focus();
                          return;
                      }
                      var pattern = /[0-9]{4}$/;//---/[12][0-9]{2}$/;
                      if (!pattern.test(Ext.getCmp('yearId').getValue())) {
                          Ext.example.msg("Enter A Valid Year");
                          Ext.getCmp('yearId').focus();
                          return;
                      }
                      if (Ext.getCmp('mineralNameId').getValue() == "") {
                          Ext.example.msg("<%=EnterNameOfMineral%>");
                          Ext.getCmp('mineralNameId').focus();
                          return;
                      }
                      if (Ext.getCmp('mineNameId').getValue() == "") {
                          Ext.example.msg("<%=EnterNameOfMine%>");
                          Ext.getCmp('mineNameId').focus();
                          return;
                      }
                     if (Ext.getCmp('leaseAreaId').getValue() == "") {
                          Ext.example.msg("<%=EnterLeaseArea%>");
                          Ext.getCmp('leaseAreaId').focus();
                          return;
                      }
                      if (Ext.getCmp('nameOfTheIssueId').getValue() == "") {
                          Ext.example.msg("<%=EnterLesseeName%>");
                          Ext.getCmp('nameOfTheIssueId').focus();
                          return;
                      }
                      if (Ext.getCmp('orderNumberId').getValue() == "") {
                          Ext.example.msg("<%=EnterOrderNumber%>");
                          Ext.getCmp('orderNumberId').focus();
                          return;
                      }
                      if (Ext.getCmp('issuedDateId').getValue() == "") {
                          Ext.example.msg("Enter Order Date");
                          Ext.getCmp('issuedDateId').focus();
                          return;
                      }
                       if (Ext.getCmp('stateId').getValue() == "") {
                          Ext.example.msg("<%=SelectState%>");
                          Ext.getCmp('stateId').focus();
                          return;
                      }
                      if (Ext.getCmp('districtComboId').getValue() == "") {
                          Ext.example.msg("<%=SelectDistrict%>");
                          Ext.getCmp('districtComboId').focus();
                          return;
                      }
                      if (Ext.getCmp('talukComboId').getValue() == "") {
                          Ext.example.msg("<%=SelectTaluka%>");
                          Ext.getCmp('talukComboId').focus();
                          return;
                      }
                        if (Ext.getCmp('villageId').getValue() == "") {
                          Ext.example.msg("<%=EnterVillage%>");
                          Ext.getCmp('villageId').focus();
                          return;
                      }
<!--                       if (Ext.getCmp('ctoCodeId').getValue() == "") {-->
<!--                          Ext.example.msg("Enter CTO Code");-->
<!--                          Ext.getCmp('ctoCodeId').focus();-->
<!--                          return;-->
<!--                      }-->
<!--                       if (Ext.getCmp('ctoDateId').getValue() == "") {-->
<!--                          Ext.example.msg("Select CTO Date");-->
<!--                          Ext.getCmp('ctoDateId').focus();-->
<!--                          return;-->
<!--                      }-->
                      if (Ext.getCmp('statusId').getValue() == "") {
                          Ext.example.msg("<%=SelectStatus%>");
                          Ext.getCmp('statusId').focus();
                          return;
                      }
                      if (Ext.getCmp('EcCappingLimitId').getValue() == "") {
                          Ext.example.msg("<%=EnterMPL%>");
                          Ext.getCmp('EcCappingLimitId').focus();
                          return;
                      }
                      if (Ext.getCmp('processingId').getValue() == "") {
                          Ext.example.msg("<%=SelectProcessingPlant%>");
                          Ext.getCmp('processingId').focus();
                          return;
                      }
                      if (Ext.getCmp('walletLinkedId').getValue() == "") {
                          Ext.example.msg("<%=SelectWalletLinked%>");
                          Ext.getCmp('walletLinkedId').focus();
                          return;
                      }
                      if (Ext.getCmp('processingId').getValue() == "yes"){
                      if (Ext.getCmp('hubComboId').getValue() == "") {
                          Ext.example.msg("<%=SelectHUB%>");
                          Ext.getCmp('hubComboId').focus();
                          return;
                      }
                      }
                      
                        if (Ext.getCmp('minenameeId').getValue() == "") {
                          Ext.example.msg("<%=EnterMineName%>");
                          Ext.getCmp('minenameeId').focus();
                          return;
                      }
                      var reg = /^(\+91-|\+91|0)?\d{10}$/;
                     if(Ext.getCmp('phoneNoId').getValue() != ""){
                     var mobileNo = Ext.getCmp('phoneNoId').getValue();
						if (!reg.test(mobileNo)) {
						Ext.example.msg("Enter Valid Phone Number");
						Ext.getCmp('phoneNoId').focus();
						return;
						}
						}
						if(Ext.getCmp('emailId').getValue() !=""){
						if(!validateEmail(Ext.getCmp('emailId').getValue())){
                      	   Ext.example.msg("Enter Valid Email (Ex: a@gmail.com)");
                      	   Ext.getCmp('emailId').focus();
                           return;
                      	}
                      	}
                      var id;
                      if (buttonValue == '<%=Add%>') {
	                      	if(parseFloat(ecLimit-ecCapLimit).toFixed(2) < Number(Ext.getCmp('EcCappingLimitId').getValue())){
	                      	  Ext.example.msg("<%=MplShouldBeLess%>");
	                      	  Ext.getCmp('EcCappingLimitId').focus();
	                          return;
	                      }
	                      
	                      if(maxCarryedTC < Ext.getCmp('MplCarryForwardLimitId').getValue()){
	                        	Ext.example.msg("Entered Carry forwarded TC should not more than "+maxCarryedTC);
	                          	Ext.getCmp('MplCarryForwardLimitId').focus();
	                          	return;
                       		}	
	                       
                      }else if (buttonValue == '<%=Modify%>') {
                          var selected = grid.getSelectionModel().getSelected();
                          id = selected.get('IdDataIndex');
                          
                        //  if (selected.get('EcCappingLimitIndex') > Ext.getCmp('EcCappingLimitId').getValue()) {
                         //     Ext.example.msg("Cannot Enter 'MPL Allocated' Less than : "+selected.get('EcCappingLimitIndex')+" value.");
	                     // 	  Ext.getCmp('EcCappingLimitId').focus();
	                     //     return;
                         // }
                                                      
                      //   if (selected.get('MplenhanceLimitIdIndex') > Ext.getCmp('MplenhanceLimitId').getValue()) {
                        //      Ext.example.msg("Cannot Enter 'MPL Enhanced' Less than : "+selected.get('MplenhanceLimitIdIndex')+" value.");
	                    //  	  Ext.getCmp('MplenhanceLimitId').focus(); 
	                     //     return;
                        //  }
                        
                        if ( (selected.get('MplenhanceLimitIdIndex') > Ext.getCmp('MplenhanceLimitId').getValue()) || (selected.get('EcCappingLimitIndex') > Ext.getCmp('EcCappingLimitId').getValue()) ){
                       		
                       		transBal = selected.get('MpltransportationLimitIdIndex') - selected.get('mplBalenceIndex');
                       		proBal=productionBal;
                       		if(transBal<proBal){
                       		MaxReducibleValue = transBal;
                       		}else{
                       		MaxReducibleValue = proBal;
                       		}
                       		
                       		EnhanceReduced  = selected.get('MplenhanceLimitIdIndex') - Ext.getCmp('MplenhanceLimitId').getValue();
                       		AllocatedReduced = selected.get('EcCappingLimitIndex') - Ext.getCmp('EcCappingLimitId').getValue();
                       		if(MaxReducibleValue == 0){
                       		Ext.example.msg("You cannot reduced value!");
	                          return;
                       		}
                       		if((AllocatedReduced+EnhanceReduced)>MaxReducibleValue){
                       		  Ext.example.msg("You can reduce value up to : "+MaxReducibleValue);
	                      	  Ext.getCmp('EcCappingLimitId').focus();
	                          return;
                       		}
                       		
                       		
                       }                        
                        
                          if(<%=carryEditable%>){
                          	 if (selected.get('MplCarryForwardLimitIdIndex') > Ext.getCmp('MplCarryForwardLimitId').getValue()) {
                                Ext.example.msg("Cannot Enter 'MPL Carry Forward' Less than : "+selected.get('MplCarryForwardLimitIdIndex')+" value.");
	                          	Ext.getCmp('MplCarryForwardLimitId').focus();
	                          	return;
                          	 } 
  							 
                    	 	 if((maxCarryedTC+Number(selected.get('MplCarryForwardLimitIdIndex'))) < Ext.getCmp('MplCarryForwardLimitId').getValue()){
	                        	Ext.example.msg("Entered Carry forwarded TC should not be more than "+(maxCarryedTC+Number(selected.get('MplCarryForwardLimitIdIndex'))));
	                          	Ext.getCmp('MplCarryForwardLimitId').focus();
	                          	return;
                        	 }
                        	// if(Ext.getCmp('MplCarryForwardLimitId').getValue() > maxCarryedTC){
	                        // 	Ext.example.msg("Carry forwarded TC should not be more than "+maxCarryedTC);
	                        //  	Ext.getCmp('MplCarryForwardLimitId').focus();
	                        //   	return;
                        	// }  
                          }
                          if (selected.get('stateDataIndex') != Ext.getCmp('stateId').getValue()) {
                              stateModify = Ext.getCmp('stateId').getValue();
                          } else {
                              stateModify = selected.get('stateIdDataIndex');
                          }
                          if (selected.get('DistrictDataIndex') != Ext.getCmp('districtComboId').getValue()) {
                              districtModify = Ext.getCmp('districtComboId').getValue();
                          } else {
                              districtModify = selected.get('districtIdDataIndex');
                          }
                          if (selected.get('TalukDataIndex') != Ext.getCmp('talukComboId').getValue()) {
                              talukModify = Ext.getCmp('talukComboId').getValue();
                          } else {
                              talukModify = selected.get('TalukIdDataIndex');
                          }
                          if (selected.get('hubIndex') != Ext.getCmp('hubComboId').getValue()) {
                              hubModify = Ext.getCmp('hubComboId').getValue();
                          } else {
                              hubModify = selected.get('hubIdIndex');
                          }
                          if (selected.get('mineCodeDataIndex') == Ext.getCmp('mineCodeId').getValue() || selected.get('MineCodeIdIndex') == Ext.getCmp('mineCodeId').getValue()) {
                              
	                          mineCodeModify = selected.get('MineCodeIdIndex');
                              mineCodeStore.load({
					           params: {clientId:custId }
					           });
					           var row = mineCodeStore.findExact('mineId',mineCodeModify);
					           var rec = mineCodeStore.getAt(row);
					           ecLimit=rec.data['ecLimit'];
					           ecCapLimit=rec.data['ecCapLimit'];
	                          if(parseFloat(ecLimit-ecCapLimit).toFixed(2) < (Number(Ext.getCmp('EcCappingLimitId').getValue())-Number(selected.get('EcCappingLimitIndex')))){
	                      	  Ext.example.msg("<%=MplShouldBeLess%>");
	                      	  Ext.getCmp('EcCappingLimitId').focus();
	                          return;
	                      	  }
                          } else {
                              mineCodeModify = Ext.getCmp('mineCodeId').getValue();
					           var row = mineCodeStore.findExact('mineId',mineCodeModify);
					           var rec = mineCodeStore.getAt(row);
					           ecLimit=rec.data['ecLimit'];
					           ecCapLimit=rec.data['ecCapLimit'];
	                          if(parseFloat(ecLimit-ecCapLimit).toFixed(2) < Number(Ext.getCmp('EcCappingLimitId').getValue())){
	                      	  Ext.example.msg("<%=MplShouldBeLess%>");
	                      	  Ext.getCmp('EcCappingLimitId').focus();
	                          return;
	                      	  }
                          }
					       
                      }
                      TCMasterOuterPanelWindow.getEl().mask();
                      Ext.Ajax.request({
                          url: '<%=request.getContextPath()%>/MiningTCMasterAction.do?param=tcMasterAddModify',
                          method: 'POST',
                          params: {
                              buttonValue: buttonValue,
                              CustID: Ext.getCmp('custcomboId').getValue(),
                              CustName: Ext.getCmp('custcomboId').getRawValue(),
                              tcNumber: Ext.getCmp('TCNumberId').getValue(),
                              nameOfTheIssue: Ext.getCmp('nameOfTheIssueId').getValue(),
                              OrderNuber: Ext.getCmp('orderNumberId').getValue(),
                              isuuedDate: Ext.getCmp('issuedDateId').getValue(),
                              district: Ext.getCmp('districtComboId').getValue(),
                              taluk: Ext.getCmp('talukComboId').getValue(),
                              regIbm:Ext.getCmp('regIbmId').getValue(),
                              mineCode:Ext.getCmp('mineCodeId').getValue(),
                              mineCodeValue:Ext.getCmp('mineCodeId').getRawValue(),
                              mineralName:Ext.getCmp('mineralNameId').getValue(),
                              mineName:Ext.getCmp('mineNameId').getValue(),
                              state:Ext.getCmp('stateId').getValue(),
                              pin:Ext.getCmp('pinId').getValue(),
                              faxNo:Ext.getCmp('faxNoId').getValue(),
                              phoneNo:Ext.getCmp('phoneNoId').getValue(),
                              emailId:Ext.getCmp('emailId').getValue(),
                              districtModify: districtModify,
                              talukModify: talukModify,
                              stateModify: stateModify,
                              village: Ext.getCmp('villageId').getValue(),
                              area: Ext.getCmp('areaId').getValue(),
                              status: Ext.getCmp('statusId').getRawValue(),
                              EcCappingLimit: Ext.getCmp('EcCappingLimitId').getValue(),
                              processingPlant:Ext.getCmp('processingId').getValue(),
                              walletLinked:Ext.getCmp('walletLinkedId').getValue(),
                              hub:Ext.getCmp('hubComboId').getValue(),
                              minenamee:Ext.getCmp('minenameeId').getValue(),
                              leasearea:Ext.getCmp('leaseAreaId').getValue(),
                              year:Ext.getCmp('yearId').getValue(),
                              hubModify:hubModify,
                              mineCodeModify:mineCodeModify,
                              id: id,
                              jspName: jspName,
                              ctoCode: Ext.getCmp('ctoCodeId').getValue(),
                              ctoDate: Ext.getCmp('ctoDateId').getValue(),                              
						      mplenh: Ext.getCmp('MplenhanceLimitId').getValue(),
						      mplprod: Ext.getCmp('MPLproductionLimitId').getValue(),
						      mpltrans: Ext.getCmp('MpltransportationLimitId').getValue(),
						      mpltcarry: Ext.getCmp('MplCarryForwardLimitId').getValue(),
						      financialyear: year
                          },
                          success: function(response, options) {
                              var message = response.responseText;
                              Ext.example.msg(message);
                              Ext.getCmp('TCNumberId').reset();
                              Ext.getCmp('nameOfTheIssueId').reset();
                              Ext.getCmp('orderNumberId').reset();
                              Ext.getCmp('issuedDateId').reset();
                              Ext.getCmp('districtComboId').reset();
                              Ext.getCmp('talukComboId').reset();
                              Ext.getCmp('villageId').reset();
                              Ext.getCmp('areaId').reset();
                              Ext.getCmp('statusId').reset();
                              Ext.getCmp('regIbmId').reset();
						      Ext.getCmp('mineCodeId').reset();
						      Ext.getCmp('mineralNameId').reset();
						      Ext.getCmp('mineNameId').reset();
						      Ext.getCmp('pinId').reset();
						      Ext.getCmp('faxNoId').reset();
						      Ext.getCmp('phoneNoId').reset();
						      Ext.getCmp('emailId').reset();
						      Ext.getCmp('EcCappingLimitId').reset();
						      Ext.getCmp('MplenhanceLimitId').reset();
						      Ext.getCmp('MPLproductionLimitId').reset();
						      Ext.getCmp('MpltransportationLimitId').reset();
						      Ext.getCmp('MplCarryForwardLimitId').reset();
						      Ext.getCmp('processingId').reset();
						      Ext.getCmp('walletLinkedId').reset();
						      Ext.getCmp('amountOfROMId').reset();
						      Ext.getCmp('quantityOfROMId').reset();
						      Ext.getCmp('mplBalenceId').reset();
						      Ext.getCmp('hubComboId').reset();
						      Ext.getCmp('minenameeId').reset();
						      Ext.getCmp('leaseAreaId').reset();
						      Ext.getCmp('yearId').reset();
						      Ext.getCmp('ctoDateId').reset();
						      Ext.getCmp('ctoCodeId').reset();
                              myWin.hide();
                              store.reload();
                              TCMasterOuterPanelWindow.getEl().unmask();
                          },
                          failure: function() {
                              Ext.example.msg("Error");
                              store.reload();
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
  
  var TCMasterOuterPanelWindow = new Ext.Panel({
      width: 1290,
   	  height: 480,
      standardSubmit: true,
       autoScroll: false,
      frame: true,
      items: [innerPanelForTCMasterDetails, innerWinButtonPanel]
  });
  
  myWin = new Ext.Window({
      title: 'titelForInnerPanel',
      closable: false,
      resizable: true,
      mode: true,
      modal: true,
      autoScroll: false,
      height: 520,
      width: 1290,
      id: 'myWin',
      items: [TCMasterOuterPanelWindow]
  });

  function addRecord() {
      if (Ext.getCmp('custcomboId').getValue() == "") {
          Ext.example.msg("<%=SelectCustomer%>");
          return;
      }
      buttonValue = '<%=Add%>';
      titelForInnerPanel = '<%=AddDetails%>';
      myWin.setPosition(50,10);
      myWin.show();
      if(<%=carryEditable%>){
		 Ext.getCmp('MplCarryForwardLimitId').setReadOnly(false);
	  }else{
		 Ext.getCmp('MplCarryForwardLimitId').setReadOnly(true);
		}
      Ext.getCmp('TCNumberId').setReadOnly(false);
      Ext.getCmp('EcCappingLimitId').enable();
      Ext.getCmp('processingId').enable();
	  Ext.getCmp('walletLinkedId').enable();
      myWin.setTitle(titelForInnerPanel);
      Ext.getCmp('TCNumberId').reset();
      Ext.getCmp('nameOfTheIssueId').reset();
      Ext.getCmp('orderNumberId').reset();
      Ext.getCmp('issuedDateId').reset();
      Ext.getCmp('districtComboId').reset();
      Ext.getCmp('talukComboId').reset();
      Ext.getCmp('villageId').reset();
      Ext.getCmp('areaId').reset();
      Ext.getCmp('statusId').reset();
      Ext.getCmp('regIbmId').reset();
      Ext.getCmp('mineCodeId').reset();
      Ext.getCmp('mineralNameId').reset();
      Ext.getCmp('mineNameId').reset();
      Ext.getCmp('pinId').reset();
      Ext.getCmp('faxNoId').reset();
      Ext.getCmp('phoneNoId').reset();
      Ext.getCmp('emailId').reset();
      Ext.getCmp('stateId').reset();
      Ext.getCmp('EcCappingLimitId').reset();
	  Ext.getCmp('MplenhanceLimitId').reset();
	  Ext.getCmp('MPLproductionLimitId').reset();
	  Ext.getCmp('MpltransportationLimitId').reset();
	  Ext.getCmp('MplCarryForwardLimitId').reset();
      Ext.getCmp('processingId').reset();
      Ext.getCmp('walletLinkedId').reset();
      Ext.getCmp('amountOfROMId').reset();
	  Ext.getCmp('quantityOfROMId').reset();
      Ext.getCmp('mplBalenceId').reset();
      Ext.getCmp('hubComboId').reset();
      Ext.getCmp('minenameeId').reset();
	  Ext.getCmp('leaseAreaId').reset();
	  Ext.getCmp('yearId').reset();
	  Ext.getCmp('ctoDateId').reset();
	  Ext.getCmp('ctoCodeId').reset();
      Ext.getCmp('amountOfROMId').hide();
      Ext.getCmp('amountOfROMLabelId').hide();
      Ext.getCmp('amountOfROMEmptyId').hide(); 
      Ext.getCmp('quantityOfROMId').hide();
      Ext.getCmp('quantityOfROMLabelId').hide();
      Ext.getCmp('quantityOfROMEmptyId').hide(); 
      Ext.getCmp('mplBalenceId').hide();
      Ext.getCmp('mplBalenceLabelId').hide();
      Ext.getCmp('mplBalenceEmptyId').hide();
      Ext.getCmp('hubComboId').setReadOnly(false);
      mineCodeStore.load({
              params: {
                  clientId:custId
              }
          });
  }

  function modifyData() {
  		if(<%=carryEditable%>){
		 Ext.getCmp('MplCarryForwardLimitId').setReadOnly(false);
	  	}else{
		 Ext.getCmp('MplCarryForwardLimitId').setReadOnly(true);
		}
          if (Ext.getCmp('custcomboId').getValue() == "") {
              Ext.example.msg("<%=SelectCustomer%>");
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
          titelForInnerPanel = '<%=Modify%>';
          myWin.setPosition(50,10);	
          myWin.setHeight(520);
          myWin.setTitle(titelForInnerPanel);
          myWin.show();
          Ext.getCmp('TCNumberId').setReadOnly(true);
          //Ext.getCmp('EcCappingLimitId').disable();
		  var selected = grid.getSelectionModel().getSelected();
          Ext.getCmp('TCNumberId').setValue(selected.get('TCNumberDataIndex'));
          Ext.getCmp('nameOfTheIssueId').setValue(selected.get('NameOfTheIssueDataIndex')); 
          Ext.getCmp('orderNumberId').setValue(selected.get('OrderNumberDataIndex'));
          Ext.getCmp('issuedDateId').setValue(selected.get('DateIssuedDateDataIndex'));
          Ext.getCmp('districtComboId').setValue(selected.get('DistrictDataIndex'));
          Ext.getCmp('talukComboId').setValue(selected.get('TalukDataIndex'));
          Ext.getCmp('villageId').setValue(selected.get('VillageDataIndex'));
          Ext.getCmp('areaId').setValue(selected.get('AreaDataIndex'));
          Ext.getCmp('statusId').setValue(selected.get('StatusDataIndex'));
          Ext.getCmp('EcCappingLimitId').setValue(selected.get('EcCappingLimitIndex'));
          Ext.getCmp('regIbmId').setValue(selected.get('regIbmDataIndex'));
          Ext.getCmp('mineCodeId').setValue(selected.get('mineCodeDataIndex'));
          Ext.getCmp('mineralNameId').setValue(selected.get('mineralNameDataIndex'));
          Ext.getCmp('mineNameId').setValue(selected.get('MineNameDataIndex'));
          Ext.getCmp('stateId').setValue(selected.get('stateDataIndex'));
          Ext.getCmp('pinId').setValue(selected.get('pinDataIndex'));
          Ext.getCmp('faxNoId').setValue(selected.get('faxNoDataIndex'));
          Ext.getCmp('phoneNoId').setValue(selected.get('phoneNoDataIndex'));
          Ext.getCmp('emailId').setValue(selected.get('emailDataIndex'));
          Ext.getCmp('processingId').setValue(selected.get('processingPlantIndex'));
          Ext.getCmp('walletLinkedId').setValue(selected.get('walletLinkedIndex'));
          Ext.getCmp('amountOfROMId').setValue(selected.get('amountOfROMIndex'));
          Ext.getCmp('quantityOfROMId').setValue(selected.get('quantityOfROMIndex'));
          Ext.getCmp('mplBalenceId').setValue(selected.get('mplBalenceIndex'));
          Ext.getCmp('hubComboId').setValue(selected.get('hubIndex'));
          Ext.getCmp('minenameeId').setValue(selected.get('MineNameIdIndex'));
          Ext.getCmp('leaseAreaId').setValue(selected.get('LeaseAreaIdIndex'));
          Ext.getCmp('yearId').setValue(selected.get('yearIdIndex'));
          Ext.getCmp('ctoDateId').setValue(selected.get('ctoDateIndex'));
		  Ext.getCmp('ctoCodeId').setValue(selected.get('ctoCodeIndex'));	    							  
		  Ext.getCmp('MplenhanceLimitId').setValue(selected.get('MplenhanceLimitIdIndex'));
          Ext.getCmp('MPLproductionLimitId').setValue(selected.get('MPLproductionLimitIdIndex'));
          Ext.getCmp('MpltransportationLimitId').setValue(selected.get('MpltransportationLimitIdIndex'));
		  Ext.getCmp('MplCarryForwardLimitId').setValue(selected.get('MplCarryForwardLimitIdIndex'));
		  
          Ext.getCmp('amountOfROMId').hide();
	      Ext.getCmp('amountOfROMLabelId').hide();
	      Ext.getCmp('amountOfROMEmptyId').hide(); 
	      Ext.getCmp('quantityOfROMId').hide();
	      Ext.getCmp('quantityOfROMLabelId').hide();
	      Ext.getCmp('quantityOfROMEmptyId').hide();
          Ext.getCmp('mplBalenceId').hide();
	      Ext.getCmp('mplBalenceLabelId').hide();
	      Ext.getCmp('mplBalenceEmptyId').hide();
          
          if (selected.get('stateDataIndex') != Ext.getCmp('stateId').getValue()) {
              stateModify1 = Ext.getCmp('stateId').getValue();
          } else {
              stateModify1 = selected.get('stateIdDataIndex');
          }
          if (selected.get('DistrictDataIndex') != Ext.getCmp('districtComboId').getValue()) {
              districtModify1 = Ext.getCmp('districtComboId').getValue();
          } else {
              districtModify1 = selected.get('districtIdDataIndex');
          }
          custId = Ext.getCmp('custcomboId').getValue();

          districtStore.load({
              params: {
                   stateId: stateModify1
              }
          });
          talukStore.load({
              params: {
                  DistId: districtModify1
              }
          });
          mineCodeStore.load({
              params: {
                  clientId:custId
              }
          });
             maxCarryedTCStore.load({
            	params:{            	
            		custId: Ext.getCmp('custcomboId').getValue(),
            		mineId:  selected.get('MineCodeIdIndex'),
            		year: year
            	},
            	callback: function(){
            		maxCarryedTC=maxCarryedTCStore.getAt(0).data['MAX_CARRYED_TC']
            		
            	}
            });
            
            productionStore.load({
            	params:{            	
            		tcId:  selected.get('IdDataIndex')
            	},
            	callback: function(){
            		productionBal=productionStore.getAt(0).data['PRODUCTION_BAL']
            	}
            });
          
      }
    function validateEmail(email) {
    	var re = validate('email');
    	return re.test(email);
	}
      
      //***************************************************************************************//
  var reader = new Ext.data.JsonReader({
      idProperty: 'TCMasterDetails',
      root: 'getTCMasterDetails',
      totalProperty: 'total',
      fields: [{
          name: 'slnoIndex'
      }, {
          name: 'regIbmDataIndex'
      },{
          name: 'mineCodeDataIndex'
      },{
          name: 'TCNumberDataIndex'
      },{
          name: 'mineralNameDataIndex'
      },{
          name: 'MineNameDataIndex'
      },{
          name: 'NameOfTheIssueDataIndex'
      },{
          name: 'OrderNumberDataIndex'
      },{
          name: 'DateIssuedDateDataIndex',
          type: 'date',
          dateFormat: 'c'
      },{
          name: 'stateDataIndex'
      },{
          name: 'DistrictDataIndex'
      },{
          name: 'TalukDataIndex'
      },{
          name: 'VillageDataIndex'
      },{
          name: 'ctoCodeIndex'
      },{
          name: 'ctoDateIndex',
           type: 'date',
          dateFormat: 'c'
      },{
          name: 'AreaDataIndex'
      },{
          name: 'pinDataIndex'
      },{
          name: 'faxNoDataIndex'
      },{
          name: 'phoneNoDataIndex'
      },{
          name: 'emailDataIndex'
      },{
          name: 'StatusDataIndex'
      },{
          name: 'EcCappingLimitIndex',
                type: 'float'
      },{
          name: 'mplBalIndex',
                type: 'float'
      },{
          name: 'mplBalenceIndex',
                type: 'float'
      },{
          name: 'IdDataIndex'
      },{
          name: 'districtIdDataIndex'
      },{
          name: 'TalukIdDataIndex'
      },{
          name: 'stateIdDataIndex'
      },{
          name: 'processingPlantIndex'
      },{
          name: 'walletLinkedIndex'
      },{
          name: 'amountOfROMIndex'
      },{
          name: 'quantityOfROMIndex'
      },{
          name: 'hubIndex'
      },{
          name: 'hubIdIndex'
      },{
          name: 'MineCodeIdIndex'
      },{
          name: 'MineNameIdIndex'
      },{
          name: 'LeaseAreaIdIndex',
                type: 'float'
      },{
          name: 'yearIdIndex'
      },{
          name: 'MplenhanceLimitIdIndex',
                type: 'float'
      } ,{
          name: 'MPLproductionLimitIdIndex',
                type: 'float'
      } ,{
          name: 'MpltransportationLimitIdIndex',
                type: 'float'
      } ,{
          name: 'MplCarryForwardLimitIdIndex',
                type: 'float'
      } 
	 ]
  });
  
  var store = new Ext.data.GroupingStore({
      autoLoad: false,
      proxy: new Ext.data.HttpProxy({
          url: '<%=request.getContextPath()%>/MiningTCMasterAction.do?param=getTCMasterDetails',
          method: 'POST'
      }),
      remoteSort: false,
      storeId: 'TCMasterDetails',
      reader: reader
  });
  
  var filters = new Ext.ux.grid.GridFilters({
      local: true,
      filters: [{
          type: 'numeric',
          dataIndex: 'slnoIndex'
      }, {
          type: 'string',
          dataIndex: 'regIbmDataIndex'
      },{
          type: 'string',
          dataIndex: 'mineCodeDataIndex'
      },{
          type: 'string',
          dataIndex: 'TCNumberDataIndex'
      },{
          type: 'string',
          dataIndex: 'mineralNameDataIndex'
      },{
          type: 'string',
          dataIndex: 'MineNameDataIndex'
      },{
          type: 'string',
          dataIndex: 'NameOfTheIssueDataIndex'
      },{
          type: 'int',
          dataIndex: 'OrderNumberDataIndex'
      },{
          type: 'date',
          dataIndex: 'DateIssuedDateDataIndex'
      },{
          type: 'string',
          dataIndex: 'stateDataIndex'
      },{
          type: 'string',
          dataIndex: 'DistrictDataIndex'
      },{
          type: 'string',
          dataIndex: 'TalukDataIndex'
      },{
          type: 'string',
          dataIndex: 'VillageDataIndex'
      },{
          type: 'string',
          dataIndex: 'ctoCodeIndex'
      },{
          type: 'string',
          dataIndex: 'ctoDateIndex'
      },{
          type: 'string',
          dataIndex: 'AreaDataIndex'
      },{
          type: 'string',
          dataIndex: 'pinDataIndex'
      },{
          type: 'string',
          dataIndex: 'faxNoDataIndex'
      },{
          type: 'string',
          dataIndex: 'phoneNoDataIndex'
      },{
          type: 'string',
          dataIndex: 'emailDataIndex'
      },{
          type: 'string',
          dataIndex: 'StatusDataIndex'
      },{
          type: 'numeric',
          dataIndex: 'EcCappingLimitIndex'
      },{
          type: 'numeric',
          dataIndex: 'mplBalIndex'
      },{
          type: 'numeric',
          dataIndex: 'mplBalenceIndex'
      },{
          type: 'int',
          dataIndex: 'IdDataIndex'
      },{
          type: 'int',
          dataIndex: 'districtIdDataIndex'
      },{
          type: 'int',
          dataIndex: 'TalukIdDataIndex'
      },{
          type: 'int',
          dataIndex: 'stateIdDataIndex'
      },{
          type: 'string',
          dataIndex: 'processingPlantIndex'
      },{
          type: 'string',
          dataIndex: 'walletLinkedIndex'
      },{
          type: 'numeric',
          dataIndex: 'amountOfROMIndex'
      },{
          type: 'numeric',
          dataIndex: 'quantityOfROMIndex'
      },{
          type: 'string',
          dataIndex: 'hubIndex'
      },{
          type: 'int',
          dataIndex: 'hubIdIndex'
      },{
          type: 'int',
          dataIndex: 'MineCodeIdIndex'
      },{
          type: 'string',
          dataIndex: 'MineNameIdIndex'
      },{
          type: 'int',
          dataIndex: 'LeaseAreaIdIndex'
      },{
          type: 'string',
          dataIndex: 'yearIdIndex'
      } ,{
          type: 'numeric',
          dataIndex: 'MplenhanceLimitIdIndex'
      },{
          type: 'numeric',
          dataIndex: 'MPLproductionLimitIdIndex'
      },{
          type: 'numeric',
          dataIndex: 'MpltransportationLimitIdIndex'
      },{
          type: 'numeric',
          dataIndex: 'MplCarryForwardLimitIdIndex'
      }]
  });
  var createColModel = function(finish, start) {
      var columns = [
          new Ext.grid.RowNumberer({
              header: "<span style=font-weight:bold;><%=SLNO%></span>",
              width: 50
          }),{
              dataIndex: 'slnoIndex',
              hidden: true,
              header: "<span style=font-weight:bold;><%=SLNO%></span>",
              filter: {
                  type: 'numeric'
              }
          },{
              header: "<span style=font-weight:bold;><%=REGIBM%></span>",
              dataIndex: 'regIbmDataIndex',
              filter: {
                  type: 'string'
              }
          },{
              header: "<span style=font-weight:bold;><%=MineCode%></span>",
              dataIndex: 'mineCodeDataIndex',
              filter: {
                  type: 'string'
              }
          },{
              header: "<span style=font-weight:bold;><%=TCNumber%></span>",
              dataIndex: 'TCNumberDataIndex',
              filter: {
                  type: 'int'
              }
          },{
              header: "<span style=font-weight:bold;><%=NameOfMineral%></span>",
              dataIndex: 'mineralNameDataIndex',
              filter: {
                  type: 'int'
              }
          },{
              header: "<span style=font-weight:bold;><%=LeaseName%></span>",
              dataIndex: 'MineNameDataIndex',
              filter: {
                  type: 'int'
              }
          }, {        
              header: "<span style=font-weight:bold;><%=NameOfTheLessee%></span>",
              dataIndex: 'NameOfTheIssueDataIndex',
              filter: {
                  type: 'string'
              }
          }, {
              header: "<span style=font-weight:bold;><%=State%></span>",
              dataIndex: 'stateDataIndex',
              filter: {
                  type: 'int'
              }
          }, {
              header: "<span style=font-weight:bold;><%=District%></span>",
              dataIndex: 'DistrictDataIndex',
              filter: {
                  type: 'string'
              }
          },{
              header: "<span style=font-weight:bold;><%=Taluka%></span>",
              dataIndex: 'TalukDataIndex',
              filter: {
                  type: 'string'
              }
          },{
              header: "<span style=font-weight:bold;><%=Village%></span>",
              dataIndex: 'VillageDataIndex',
              filter: {
                  type: 'string'
              }
          }, {
              header: "<span style=font-weight:bold;>CTO Code</span>",
              dataIndex: 'ctoCodeIndex',
              filter: {
                  type: 'string'
              }
          }, {
              header: "<span style=font-weight:bold;>CTO Date</span>",
              dataIndex: 'ctoDateIndex',
              renderer: Ext.util.Format.dateRenderer(getDateFormat()),
              filter: {
                  type: 'date'
              }
          }, {
              header: "<span style=font-weight:bold;><%=PostOffice%></span>",
              dataIndex: 'AreaDataIndex',
              filter: {
                  type: 'string'
              }
          },{
              header: "<span style=font-weight:bold;><%=pin%></span>",
              dataIndex: 'pinDataIndex',
              width: 80,
              filter: {
                  type: 'string'
              }
          },{
              header: "<span style=font-weight:bold;><%=FaxNo%></span>",
              dataIndex: 'faxNoDataIndex',
              filter: {
                  type: 'string'
              }
          },{
              header: "<span style=font-weight:bold;><%=PhoneNo%></span>",
              dataIndex: 'phoneNoDataIndex',
              filter: {
                  type: 'string'
              }
          },{
              header: "<span style=font-weight:bold;><%=Email%></span>",
              dataIndex: 'emailDataIndex',
              filter: {
                  type: 'string'
              }
          },{
              header: "<span style=font-weight:bold;><%=OrderNumber%></span>",
              dataIndex: 'OrderNumberDataIndex',
              filter: {
                  type: 'int'
              }
          }, {
              header: "<span style=font-weight:bold;>Order Date</span>",
              dataIndex: 'DateIssuedDateDataIndex',
              renderer: Ext.util.Format.dateRenderer(getDateFormat()),
              filter: {
                  type: 'date'
              }
          }, {
              header: "<span style=font-weight:bold;><%=Status%></span>",
              dataIndex: 'StatusDataIndex',
              filter: {
                  type: 'string'
              }
          }, {
              header: "<span style=font-weight:bold;>MPL Allocated</span>",
              dataIndex: 'EcCappingLimitIndex',
              align: 'right',
              filter: {
                  type: 'numeric'
              }
          },{
              header: "<span style=font-weight:bold;>MPL Balance</span>",
              dataIndex: 'mplBalIndex',
              align: 'right',
              hidden: false,
              filter: {
                  type: 'string'
              }
          },{
              header: "<span style=font-weight:bold;>MPL Used</span>",
              dataIndex: 'mplBalenceIndex',
              align: 'right',
              hidden: false,
              filter: {
                  type: 'string'
              }
          }, {
              header: "<span style=font-weight:bold;><%=Id%></span>",
              dataIndex: 'IdDataIndex',
              hidden: true,
              filter: {
                  type: 'int'
              }
          }, {
              header: "<span style=font-weight:bold;><%=DistrictCode%></span>",
              dataIndex: 'districtIdDataIndex',
              hidden: true,
              filter: {
                  type: 'int'
              }
          }, {
              header: "<span style=font-weight:bold;><%=TalukCode%></span>",
              dataIndex: 'TalukIdDataIndex',
              hidden: true,
              filter: {
                  type: 'int'
              }
          },{
              header: "<span style=font-weight:bold;>StateCode</span>",
              dataIndex: 'stateIdDataIndex',
              hidden: true,
              filter: {
                  type: 'int'
              }
          },{
              header: "<span style=font-weight:bold;><%=ProcessingPlant%></span>",
              dataIndex: 'processingPlantIndex',
              hidden: false,
              filter: {
                  type: 'string'
              }
          },{
              header: "<span style=font-weight:bold;>EC Linked</span>",
              dataIndex: 'walletLinkedIndex',
              hidden: false,
              filter: {
                  type: 'string'
              }
          },{
              header: "<span style=font-weight:bold;><%=AmountOfROM%></span>",
              dataIndex: 'amountOfROMIndex',
              align: 'right',
              hidden: true,
              filter: {
                  type: 'string'
              }
          },{
              header: "<span style=font-weight:bold;><%=QuantityOfROM%></span>",
              dataIndex: 'quantityOfROMIndex',
              align: 'right',
              hidden: true,
              filter: {
                  type: 'string'
              }
          },{
              header: "<span style=font-weight:bold;><%=HUB%></span>",
              dataIndex: 'hubIndex',
              hidden: false,
              filter: {
                  type: 'string'
              }
          },{
              header: "<span style=font-weight:bold;><%=HubId%></span>",
              dataIndex: 'hubIdIndex',
              hidden: true,
              filter: {
                  type: 'int'
              }
          },{
              header: "<span style=font-weight:bold;><%=MineCodeId%></span>",
              dataIndex: 'MineCodeIdIndex',
              hidden: true,
              filter: {
                  type: 'int'
              }
          },{
              header: "<span style=font-weight:bold;><%=MineName%></span>",
              dataIndex: 'MineNameIdIndex',
              hidden: false,
              filter: {
                  type: 'string'
              }
          },{
              header: "<span style=font-weight:bold;>Lease Area/Sqmt</span>",
              dataIndex: 'LeaseAreaIdIndex',
              align: 'right',
              hidden: false,
              filter: {
                  type: 'numeric'
              }
          },{
              header: "<span style=font-weight:bold;>Year</span>",
              dataIndex: 'yearIdIndex',
              align: 'right',
              hidden: false,
              filter: {
                  type: 'string'
              }
          }, {
              header: "<span style=font-weight:bold;>MPL Enhanced</span>",
              dataIndex: 'MplenhanceLimitIdIndex',
              align: 'right',
              filter: {
                  type: 'numeric'
              }
          }, {
              header: "<span style=font-weight:bold;>MPL for Production</span>",
              dataIndex: 'MPLproductionLimitIdIndex',
              align: 'right',
              filter: {
                  type: 'numeric'
              }
          }, {
              header: "<span style=font-weight:bold;>MPL Carry Forward</span>",
              dataIndex: 'MplCarryForwardLimitIdIndex',
              align: 'right',
              filter: {
                  type: 'numeric'
              }
          }, {
              header: "<span style=font-weight:bold;>MPL Transportation</span>",
              dataIndex: 'MpltransportationLimitIdIndex',
              align: 'right',
              filter: {
                  type: 'numeric'
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
  
  grid = getGrid('<%=TCMasterDetails%>', '<%=NoRecordsFound%>', store, screen.width - 90, 460, 47, filters, '<%=ClearFilterData%>', false, '', 23, false, '', false, '', true, 'Excel', jspName, exportDataType, false, 'PDF', true, '<%=Add%>', true, '<%=Modify%>', false, 'Delete');
  
 Ext.onReady(function () {
    ctsb = tsb;
    Ext.QuickTips.init();
    Ext.form.Field.prototype.msgTarget = 'side';
    outerPanel = new Ext.Panel({
        title: '',
        renderTo: 'content',
        standardSubmit: true,
        frame: true,
        width: screen.width-22,
        cls: 'outerpanel',
        layout: 'table',
        layoutConfig: {
            columns: 1
        },
        items: [clientPanel, grid]
    });
    var cm =grid.getColumnModel();  
    for (var j = 1; j < cm.getColumnCount(); j++) {
       cm.setColumnWidth(j,120);
    }
    sb = Ext.getCmp('form-statusbar');
});

  </script>
 <jsp:include page="../Common/footer.jsp" />
 <!-- </body>   -->
 <!-- </html> -->
 <script> 
	  if (innerpage == true) {
				
				
				var divsToHide = document.getElementsByClassName("footer"); //divsToHide is an array
				
					for(var i = 0; i < divsToHide.length; i++){
						divsToHide[i].style.display = "none"; // depending on what you're doing
						$(".container").css({"margin-top":"-72px"});
					}
			}
			
			</script> 
<%}%>
<%}%>
 
