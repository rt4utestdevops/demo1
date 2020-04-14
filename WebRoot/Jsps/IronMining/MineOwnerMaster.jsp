<%@ page language="java"
	import="java.util.*,t4u.functions.CommonFunctions,t4u.beans.*,t4u.common.*"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://packtag.sf.net" prefix="pack"%>
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
		loginInfo.setSystemId(systemid);
		loginInfo.setCustomerId(customerid);
		loginInfo.setUserId(userid);
		loginInfo.setLanguage(language);
		loginInfo.setStyleSheetOverride("N");
		loginInfo.setZone(str[4].trim());
		loginInfo.setOffsetMinutes(Integer.parseInt(str[5].trim()));
		loginInfo.setSystemName(str[6].trim());
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
		tobeConverted.add("Status");

		tobeConverted.add("Select_District");
		tobeConverted.add("Select_Taluka");
		tobeConverted.add("Enter_Village");
		tobeConverted.add("TC_Master");

		tobeConverted.add("TC_Number");

		tobeConverted.add("Name_Of_The_Lessee");
		tobeConverted.add("Enter_Lessee_Name");

		tobeConverted.add("Id");
		tobeConverted.add("District_Code");
		tobeConverted.add("Taluk_Code");
		tobeConverted.add("Customer_Name");

		tobeConverted.add("State");
		tobeConverted.add("Enter_State");
		tobeConverted.add("PinCode");
		tobeConverted.add("Enter_Pincode");

		tobeConverted.add("Phone_No");
		tobeConverted.add("Enter_Phone_No");
		tobeConverted.add("Post_Office");
		tobeConverted.add("Enter_Post_Office");

		tobeConverted.add("Type");
		tobeConverted.add("Select_Type");
		tobeConverted.add("Mine_Owner_Details");

		tobeConverted.add("Year");
		tobeConverted.add("Enter_Year");
		tobeConverted.add("Name");
		tobeConverted.add("Enter_Name");

		tobeConverted.add("Address");
		tobeConverted.add("Enter_Address");
		tobeConverted.add("Contact_Person");
		tobeConverted.add("Enter_Contact_Person");

		tobeConverted.add("PAN_No");
		tobeConverted.add("Enter_Pan_No");
		tobeConverted.add("TAN_No");
		tobeConverted.add("Enter_TAN_No");

		tobeConverted.add("Banker");
		tobeConverted.add("Enter_Banker");
		tobeConverted.add("Branch");
		tobeConverted.add("Enter_Branch");

		tobeConverted.add("Select_TC_Number");
		tobeConverted.add("State_Code");

		tobeConverted.add("Fax");
		tobeConverted.add("Enter_Fax");
		tobeConverted.add("Email");
		tobeConverted.add("Enter_Email");
		tobeConverted.add("Enter_Valid_Email_Id");

		ArrayList<String> convertedWords = new ArrayList<String>();
		convertedWords = cf.getLanguageSpecificWordForKey(
				tobeConverted, language);
		String Add = convertedWords.get(0);
		String Modify = convertedWords.get(1);
		String NoRecordsFound = convertedWords.get(2);
		String ClearFilterData = convertedWords.get(3);
		String Save = convertedWords.get(4);
		String Cancel = convertedWords.get(5);

		String SLNO = convertedWords.get(6);
		String NoRowsSelected = convertedWords.get(7);
		String SelectSingleRow = convertedWords.get(8);
		String AddDetails = convertedWords.get(9);
		String SelectCustomer = convertedWords.get(10);

		String District = convertedWords.get(11);
		String Taluka = convertedWords.get(12);
		String Village = convertedWords.get(13);
		String Status = convertedWords.get(14);

		String SelectDistrict = convertedWords.get(15);
		String SelectTaluka = convertedWords.get(16);
		String EnterVillage = convertedWords.get(17);

		String TCMaster = convertedWords.get(18);
		String TCNumber = convertedWords.get(19);
		String NameOfTheLessee = convertedWords.get(20);
		String EnterLesseeName = convertedWords.get(21);

		String Id = convertedWords.get(22);
		String DistrictCode = convertedWords.get(23);
		String TalukCode = convertedWords.get(24);
		String CustomerName = convertedWords.get(25);

		String State = convertedWords.get(26);
		String SelectState = convertedWords.get(27);
		String pin = convertedWords.get(28);
		String EnterPin = convertedWords.get(29);

		String PhoneNo = convertedWords.get(30);
		String EnterPhoneNo = convertedWords.get(31);
		String PostOffice = convertedWords.get(32);
		String EnterPostOffice = convertedWords.get(33);

		String Type = convertedWords.get(34);
		String SelectType = convertedWords.get(35);
		String MineOwnerDetails = convertedWords.get(36);

		String Year = convertedWords.get(37);
		String EnterYear = convertedWords.get(38);
		String Name = convertedWords.get(39);
		String EnterName = convertedWords.get(40);

		String Address = convertedWords.get(41);
		String EnterAddress = convertedWords.get(42);
		String ContactPerson = convertedWords.get(43);
		String EnterContactPerson = convertedWords.get(44);

		String PANNo = convertedWords.get(45);
		String EnterPANNo = convertedWords.get(46);
		String TANNo = convertedWords.get(47);
		String EnterTANNo = convertedWords.get(48);

		String Banker = convertedWords.get(49);
		String EnterBanker = convertedWords.get(50);
		String Branch = convertedWords.get(51);
		String EnterBranch = convertedWords.get(52);

		String SelectTCNumber = convertedWords.get(53);
		String StateCode = convertedWords.get(54);

		String FaxNo = convertedWords.get(55);
		String EnterFaxNo = convertedWords.get(56);
		String Email = convertedWords.get(57);
		String EnterEmail = convertedWords.get(58);
		String EnterValidEmailId = convertedWords.get(59);

		int userId = loginInfo.getUserId();
		int systemId = loginInfo.getSystemId();
		int customerId = loginInfo.getCustomerId();
		String userAuthority = cf.getUserAuthority(systemId, userId);

		if (customerId > 0 && loginInfo.getIsLtsp() == -1
				&& !userAuthority.equalsIgnoreCase("Admin")) {
			response.sendRedirect(request.getContextPath()
					+ "/Jsps/Common/401Error.html");
		} else {
%>

<jsp:include page="../Common/header.jsp" />
		<base href="<%=basePath%>">
		<title><%=MineOwnerDetails%></title>

		<%
			if (loginInfo.getStyleSheetOverride().equals("Y")) {
		%>
		<jsp:include page="../Common/ImportJSSandMining.jsp" />
		<jsp:include page="../IronMining/css.jsp" />
		<%
			} else {
		%>
		<jsp:include page="../Common/ImportJS.jsp" />
		<jsp:include page="../IronMining/css.jsp" />
		<%
			}
		%>
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
				div#myWin {
					top : 52px !important;
				}
				.x-menu-list {
					height:auto !important;
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
  var jspName = "Owner Master Details";
  var exportDataType = "int,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,int,int,int,int";
  var grid;
  var myWin;
  var buttonValue;
  var talukModify;
  var districtModify;
  var districtModify1;
  var stateModify;
  var stateModify1;
  var numModify;
  Ext.apply(Ext.form.VTypes, {
    'phoneMask': /[\-\+0-9\(\)\s\.Ext]/, 
    'phoneRe': /^(\({1}[0-9]{3}\){1}\s{1})([0-9]{3}[-]{1}[0-9]{4})$|^(((\+44)? ?(\(0\))? ?)|(0))( ?[0-9]{3,4}){3}$|^Ext. [0-9]+$/, 
    'phone': function (v) {
        return this.phoneRe.test(v); 
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
              if ( <%=customerId%> > 0) {
                  Ext.getCmp('custcomboId').setValue('<%=customerId%>');
                  custId = Ext.getCmp('custcomboId').getValue();
                  custName = Ext.getCmp('custcomboId').getRawValue();
                  statecombostore.load();
                  TCNumbercombostore.load({
                      params: {
                          CustId: custId
                      }
                  });
                  store.load({
                      params: {
                          CustId: custId,
                          jspName: jspName,
                          CustName: Ext.getCmp('custcomboId').getRawValue()
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
                  TCNumbercombostore.load({
                      params: {
                          CustId: custId
                      }
                  });
                  //typeStore.load();
                  store.load({
                      params: {
                          CustId: custId,
                          jspName: jspName,
                          CustName: Ext.getCmp('custcomboId').getRawValue()
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
    //----------------------------------------------TCNumber Store --------------------------------------------//
    var TCNumbercombostore = new Ext.data.JsonStore({
      url: '<%=request.getContextPath()%>/MiningTCMasterAction.do?param=getTCNumber',
      id: 'TCNoStoreId',
      root: 'TCNoRoot',
      autoLoad: true,
      remoteSort: true,
      fields: ['TCNumber','TCID','year','pin','fax','email','phone','area','name','lessename','state','district','village','taluk','talukCode','districtCode']
  });
  
  //----------------------------------------------TCNumber Combo --------------------------------------------//
var TCNumber = new Ext.form.ComboBox({
      store: TCNumbercombostore,
      id: 'TCNoId',
      mode: 'local',
      forceSelection: true,
      emptyText: '<%=SelectTCNumber%>',
      blankText: '<%=SelectTCNumber%>',
      resizable: true,
      selectOnFocus: true,
      allowBlank: false,
      anyMatch: true,
      typeAhead: false,
      triggerAction: 'all',
      lazyRender: true,
      valueField: 'TCID',
      displayField: 'TCNumber',
      cls: 'selectstylePerfectnew',
      listeners: {
          select: {
             fn: function() {
             var tcId=Ext.getCmp('TCNoId').getValue();
             var row = TCNumbercombostore.find('TCID',tcId);
			 var rec = TCNumbercombostore.getAt(row);
			 year=rec.data['year'];
			 pin=rec.data['pin'];
			 fax=rec.data['fax'];
			 phone=rec.data['phone'];
			 area=rec.data['area'];
			 email=rec.data['email'];
			 name=rec.data['name'];
			 lesseename=rec.data['lessename'];
			 state=rec.data['state'];
			 district=rec.data['district'];
			 taluka=rec.data['taluk'];
			 village=rec.data['village'];
			 talukCode=rec.data['talukCode'];
			 districtCode=rec.data['districtCode'];
			 Ext.getCmp('yearId').setValue(year);
			 Ext.getCmp('nameId').setValue(name);
			 Ext.getCmp('postOfficeId').setValue(area);
			 Ext.getCmp('pinId').setValue(pin);
			 Ext.getCmp('phoneNoId').setValue(phone);
			 Ext.getCmp('faxNoId').setValue(fax);
			 Ext.getCmp('emailId').setValue(email);
			 Ext.getCmp('lesseeId').setValue(lesseename);
			 Ext.getCmp('districtComboId').setValue(districtCode);
			 Ext.getCmp('districtComboId').setRawValue(district);
			 Ext.getCmp('stateId').setValue(state);
			 Ext.getCmp('talukComboId').setValue(talukCode);
			 Ext.getCmp('talukComboId').setRawValue(taluka);
			 Ext.getCmp('villageId').setValue(village);
			 
              }
          },
            change: function(field, newValue, oldValue){
            tcNumber=Ext.getCmp('TCNoId').getRawValue();
             var row = TCNumbercombostore.find('TCNumber',tcNumber);
			 var rec = TCNumbercombostore.getAt(row);
			 year=rec.data['year'];
			 pin=rec.data['pin'];
			 fax=rec.data['fax'];
			 phone=rec.data['phone'];
			 area=rec.data['area'];
			 email=rec.data['email'];
			 name=rec.data['name'];
			 lesseename=rec.data['lessename'];
			 state=rec.data['state'];
			 district=rec.data['district'];
			 taluka=rec.data['taluk'];
			 village=rec.data['village'];
			 talukCode=rec.data['talukCode'];
			 districtCode=rec.data['districtCode'];
			 Ext.getCmp('yearId').setValue(year);
			 Ext.getCmp('nameId').setValue(name);
			 Ext.getCmp('postOfficeId').setValue(area);
			 Ext.getCmp('pinId').setValue(pin);
			 Ext.getCmp('phoneNoId').setValue(phone);
			 Ext.getCmp('faxNoId').setValue(fax);
			 Ext.getCmp('emailId').setValue(email);
			 Ext.getCmp('lesseeId').setValue(lesseename);
			 Ext.getCmp('districtComboId').setRawValue(district);
			 Ext.getCmp('stateId').setValue(state);
			 Ext.getCmp('talukComboId').setRawValue(taluka);
			 Ext.getCmp('villageId').setValue(village);
			// Ext.getCmp('districtComboId').setValue(districtCode);
			 //Ext.getCmp('talukComboId').setValue(talukCode);
			}
      }
  });
  
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
  
  //----------------------------------------------District Store --------------------------------------------//
  var districtStore = new Ext.data.JsonStore({
      url: '<%=request.getContextPath()%>/MiningTCMasterAction.do?param=getDistrictNames',
      id: 'districteStoreId',
      root: 'districtCodeRoot',
      autoLoad: false,
      remoteSort: true,
      fields: ['District', 'Value']
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
 
  var innerPanelForMineOwnerDetails = new Ext.form.FormPanel({
      standardSubmit: true,
      collapsible: false,
      autoScroll: true,
      height: 345,
      width: 860,
      frame: true,
      id: 'innerPanelDetailsId',
      layout: 'table',
      resizable: true,
      layoutConfig: {
          columns: 4
      },
      items: [{
          xtype: 'fieldset',
          title: '<%=MineOwnerDetails%>',
          cls: 'my-fieldset',
          collapsible: false, 
          colspan: 3,
          id: 'mineOwnerDetailsid',
          width: 820,
          height: 320,
          layout: 'table',
          layoutConfig: {
              columns: 2
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
              id: 'tcNoEmptyId'
          }, {
              xtype: 'label',
              text: '<%=TCNumber%>' + ' :',
              cls: 'labelstylenew',
              id: 'tcNoLabelId'
          }, TCNumber,
          {
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
              xtype: 'textfield',
              cls: 'selectstylePerfectnew',
              allowBlank: false,
              readOnly:true,
              blankText: '<%=EnterYear%>',
              emptyText: '<%=EnterYear%>',
              labelSeparator: '',
              allowBlank: false,
              id: 'yearId'
          },{
              xtype: 'label',
              text: '*',
              cls: 'mandatoryfield',
              id: 'nameEmptyId'
          }, {
              xtype: 'label',
              text: ' Name Of Lease' + ' :',
              cls: 'labelstylenew',
              id: 'nameLabelId'
          }, {
              xtype: 'textfield',
              cls: 'selectstylePerfectnew',
              allowBlank: false,
              readOnly:true,
              blankText: 'Enter Name Of Lease',
              emptyText: 'Enter Name Of Lease',
              autoCreate: {//restricts user to 100 chars max, 
                   tag: "input",
                   maxlength: 100,
                   type: "text",
                   size: "100",
                   autocomplete: "off"
               },
              labelSeparator: '',
              allowBlank: false,
              id: 'nameId'
          },{
              xtype: 'label',
              text: '*',
              cls: 'mandatoryfield',
              id: 'lesseeEmptyId'
          }, {
              xtype: 'label',
              text: '<%=NameOfTheLessee%>' + ' :',
              cls: 'labelstylenew',
              id: 'lesseeLabelId'
          }, {
              xtype: 'textfield',
              cls: 'selectstylePerfectnew',
              allowBlank: false,
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
              id: 'lesseeId'
          },{
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
          }, districtCombo,
          {
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
              emptyText: '<%=EnterVillage%>',
              blankText: '<%=EnterVillage%> ',
              listeners: { change: function(f,n,o){ //restrict 50
			 if(f.getValue().length> 50){ Ext.example.msg("Field exceeded it's Maximum length"); 
				f.setValue(n.substr(0,50)); f.focus(); }
			 } },
              labelSeparator: '',
              allowBlank: false,
              id: 'villageId'
          },{
              xtype: 'label',
              text: ' ',
              cls: 'mandatoryfield',
              id: 'postEmptyId'
          }, {
              xtype: 'label',
              text: 'PostOffice' + ' :',
              cls: 'labelstylenew',
              id: 'postLabelId'
          },{
              xtype: 'textfield',
              cls: 'selectstylePerfectnew',
              allowBlank: false,
              readOnly:true,
              blankText: '<%=EnterPostOffice%>',
              emptyText: '<%=EnterPostOffice%>',
              autoCreate: {//restricts user to 50 chars max, 
                   tag: "input",
                   maxlength: 50,
                   type: "text",
                   size: "50",
                   autocomplete: "off"
               },
              labelSeparator: '',
              decimalPrecision:3,
              allowBlank: false,
              id: 'postOfficeId'
          },{
              xtype: 'label',
              text: ' ',
              cls: 'mandatoryfield',
              id: 'addressEmptyId'
          }, {
              xtype: 'label',
              text: '<%=Address%>' + ' :',
              cls: 'labelstylenew',
              id: 'addressLabelId'
          },{
              xtype: 'textfield',
              cls: 'selectstylePerfectnew',
              allowBlank: false,
              blankText: '<%=EnterAddress%>',
              emptyText: '<%=EnterAddress%>',
              listeners:{
					  change: function(field, newValue, oldValue){
					  if(field.getValue().length> 100){ Ext.example.msg("Field exceeded it's Maximum length"); 
				      field.setValue(newValue.substr(0,100)); field.focus(); 
					 } 
					 }
					},
              labelSeparator: '',
              decimalPrecision:3,
              allowBlank: false,
              id: 'addressId'
          }]  
          },{
          xtype: 'panel',
	        id: 'SHid',
	        width: 350,
	        layout: 'table',
	        layoutConfig: {
	            columns: 3
	        },
	        items: [{
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
              readOnly:true,
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
              allowBlank: false,
              id: 'pinId'
          }, 
          {
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
              readOnly:true,
              blankText: '<%=EnterPhoneNo%>',
              emptyText: '<%=EnterPhoneNo%>',
              vtype:'phone',
              autoCreate: {//restricts user to 20 chars max, 
                   tag: "input",
                   maxlength: 20,
                   type: "text",
                   size: "20",
                   autocomplete: "off"
               },
              labelSeparator: '',
              allowBlank: false,
              id: 'phoneNoId'
          },{
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
              readOnly:true,
              blankText: '<%=EnterFaxNo%>',
              emptyText: '<%=EnterFaxNo%>',
              vtype:'phone',
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
              readOnly:true,
              blankText: '<%=EnterEmail%>',
              emptyText: '<%=EnterEmail%>',
              autoCreate: {//restricts user to 50 chars max, 
                   tag: "input",
                   maxlength: 50,
                   type: "text",
                   size: "50",
                   autocomplete: "off"
               },
              labelSeparator: '',
              allowBlank: false,
              id: 'emailId'
          },{
              xtype: 'label',
              text: '*',
              cls: 'mandatoryfield',
              id: 'contactPersonEmptyId'
          }, {
              xtype: 'label',
              text: '<%=ContactPerson%>' + ' :',
              cls: 'labelstylenew',
              id: 'contactPersonLabelId'
          }, {
              xtype: 'textfield',
              cls: 'selectstylePerfectnew',
              maskRe:new RegExp("[a-zA-Z0-9 ]"),
              allowBlank: false,
              blankText: '<%=EnterContactPerson%>',
              emptyText: '<%=EnterContactPerson%>',
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
              id: 'contactPersonId'
          },{
              xtype: 'label',
              text: '*',
              cls: 'mandatoryfield',
              id: 'panNoEmptyId'
          }, {
              xtype: 'label',
              text: '<%=PANNo%>' + ' :',
              cls: 'labelstylenew',
              id: 'panNoLabelId'
          }, {
              xtype: 'textfield',
              cls: 'selectstylePerfectnew',
              allowBlank: false,
              blankText: '<%=EnterPANNo%>',
              emptyText: '<%=EnterPANNo%>',
            listeners:{
					change: function(field, newValue, oldValue){
					if(field.getValue().length> 30){ 
					field.setValue(newValue.toUpperCase().trim());
					Ext.example.msg("Field exceeded it's Maximum length");
					field.setValue(newValue.substr(0,30).toUpperCase().trim()); field.focus();
					 } 
					}
					},
              labelSeparator: '',
              allowBlank: false,
              id: 'panNoId'
          },{
              xtype: 'label',
              text: '*',
              cls: 'mandatoryfield',
              id: 'tanNoEmptyId'
          }, {
              xtype: 'label',
              text: '<%=TANNo%>' + ' :',
              cls: 'labelstylenew',
              id: 'tanNoLabelId'
          }, {
              xtype: 'textfield',
              cls: 'selectstylePerfectnew',
              allowBlank: false,
              blankText: '<%=EnterTANNo%>',
              emptyText: '<%=EnterTANNo%>',
               listeners:{
					change: function(field, newValue, oldValue){
					if(field.getValue().length> 30){ 
					Ext.example.msg("Field exceeded it's Maximum length");
					field.setValue(newValue.substr(0,30)); field.focus();
					 } 
					}
					},
              labelSeparator: '',
              allowBlank: false,
              id: 'tanNoId'
          },{
              xtype: 'label',
              text: '*',
              cls: 'mandatoryfield',
              id: 'bankerEmptyId'
          }, {
              xtype: 'label',
              text: '<%=Banker%>' + ' :',
              cls: 'labelstylenew',
              id: 'bankerLabelId'
          }, {
              xtype: 'textfield',
              cls: 'selectstylePerfectnew',
              allowBlank: false,
              blankText: '<%=EnterBanker%>',
              emptyText: '<%=EnterBanker%>',
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
              id: 'bankerId'
          },{
              xtype: 'label',
              text: '*',
              cls: 'mandatoryfield',
              id: 'branchEmptyId'
          }, {
              xtype: 'label',
              text: '<%=Branch%>' + ' :',
              cls: 'labelstylenew',
              id: 'branchLabelId'
          }, {
              xtype: 'textfield',
              cls: 'selectstylePerfectnew',
              allowBlank: false,
              blankText: '<%=EnterBranch%>',
              emptyText: '<%=EnterBranch%>',
              selectOnFocus: true,
              allowBlank: false,
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
              id: 'branchId'
          }
          ]
          }]
      }]
  });
  
  var innerWinButtonPanel = new Ext.Panel({
      id: 'winbuttonid',
      standardSubmit: true,
      collapsible: false,
      //autoHeight: true,
      height: 40,
      width: 820,
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
                      if (Ext.getCmp('TCNoId').getValue() == "") {
                          Ext.example.msg("<%=SelectTCNumber%>");
                          Ext.getCmp('TCNoId').focus();
                          return;
                      }
                      if (Ext.getCmp('yearId').getValue() == "") {
                          Ext.example.msg("<%=EnterYear%>");
                          Ext.getCmp('yearId').focus();
                          return;
                      }
                      if (Ext.getCmp('nameId').getValue() == "") {
                          Ext.example.msg("<%=EnterName%>");
                          Ext.getCmp('nameId').focus();
                          return;
                      }
                      if (Ext.getCmp('lesseeId').getValue() == "") {
                          Ext.example.msg("<%=EnterLesseeName%>");
                          Ext.getCmp('lesseeId').focus();
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
                      if (Ext.getCmp('contactPersonId').getValue() == "") {
                          Ext.example.msg("<%=EnterContactPerson%>");
                          Ext.getCmp('contactPersonId').focus();
                          return;
                      }
                      if (Ext.getCmp('panNoId').getValue() == "") {
                          Ext.example.msg("<%=EnterPANNo%>");
                          Ext.getCmp('panNoId').focus();
                          return;
                      }
                      if (Ext.getCmp('tanNoId').getValue() == "") {
                          Ext.example.msg("<%=EnterTANNo%>");
                          Ext.getCmp('tanNoId').focus();
                          return;
                      }
                      if (Ext.getCmp('bankerId').getValue() == "") {
                          Ext.example.msg("<%=EnterBanker%>");
                          Ext.getCmp('bankerId').focus();
                          return;
                      }
                      if (Ext.getCmp('branchId').getValue() == "") {
                          Ext.example.msg("<%=EnterBranch%>");
                          Ext.getCmp('branchId').focus();
                          return;
                      }
                      var id;
                      if (buttonValue == '<%=Modify%>') {
                          var selected = grid.getSelectionModel().getSelected();
                          id = selected.get('IdDataIndex');
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
                          if (selected.get('tcNumberDataIndex') == Ext.getCmp('TCNoId').getValue()) {
                             numModify = selected.get('tcIdDataIndex');  
                          } else {
                            numModify = Ext.getCmp('TCNoId').getValue(); 
                          }
                      }
                      mineOwnerOuterPanelWindow.getEl().mask();
                      Ext.Ajax.request({
                          url: '<%=request.getContextPath()%>/MiningTCMasterAction.do?param=addAndModifyMineOwnerDetails',
                          method: 'POST',
                          params: {
                              buttonValue: buttonValue,
                              CustID: Ext.getCmp('custcomboId').getValue(),
                              CustName: Ext.getCmp('custcomboId').getRawValue(),
                              tcNumber: Ext.getCmp('TCNoId').getRawValue(),
                              tcID: Ext.getCmp('TCNoId').getValue(),
                              year:Ext.getCmp('yearId').getValue(),
                              name:Ext.getCmp('nameId').getValue(),
                              lesseeName:Ext.getCmp('lesseeId').getValue(),
                              state:Ext.getCmp('stateId').getValue(),
                              district:Ext.getCmp('districtComboId').getValue(),
                              taluk:Ext.getCmp('talukComboId').getValue(),
                              village:Ext.getCmp('villageId').getValue(),
                              postOffice:Ext.getCmp('postOfficeId').getValue(),
                              address:Ext.getCmp('addressId').getValue(),
                              pin:Ext.getCmp('pinId').getValue(),
                              phoneNo:Ext.getCmp('phoneNoId').getValue(),
                              faxNo:Ext.getCmp('faxNoId').getValue(),
                              emailId:Ext.getCmp('emailId').getValue(),
                              contactPerson:Ext.getCmp('contactPersonId').getValue(),
                              panNo:Ext.getCmp('panNoId').getValue(),
                              tanNo:Ext.getCmp('tanNoId').getValue(),
                              banker:Ext.getCmp('bankerId').getValue(),
                              branch:Ext.getCmp('branchId').getValue(),
                              districtModify: districtModify,
                              talukModify: talukModify,
                              stateModify: stateModify,
                              id: id,
                              tCID:numModify,
                              jspName: jspName
                          },
                          success: function(response, options) {
                              var message = response.responseText;
                              Ext.example.msg(message);
                              Ext.getCmp('TCNoId').reset();
                              Ext.getCmp('yearId').reset();
                              Ext.getCmp('nameId').reset();
                              Ext.getCmp('lesseeId').reset();
                              Ext.getCmp('stateId').reset();
                              Ext.getCmp('districtComboId').reset();
                              Ext.getCmp('talukComboId').reset();
                              Ext.getCmp('villageId').reset();
                              Ext.getCmp('postOfficeId').reset();
                              Ext.getCmp('addressId').reset();
						      Ext.getCmp('pinId').reset();
						      Ext.getCmp('phoneNoId').reset();
						      Ext.getCmp('faxNoId').reset();
                              Ext.getCmp('emailId').reset();
						      Ext.getCmp('contactPersonId').reset();
						      Ext.getCmp('panNoId').reset();
						      Ext.getCmp('tanNoId').reset();
						      Ext.getCmp('bankerId').reset();
						      Ext.getCmp('branchId').reset();
                              myWin.hide();
                              store.reload();
                              mineOwnerOuterPanelWindow.getEl().unmask();
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
  
  var mineOwnerOuterPanelWindow = new Ext.Panel({
      width: 840,
      height: 505,
      standardSubmit: true,
      frame: true,
      items: [innerPanelForMineOwnerDetails, innerWinButtonPanel]
  });
  
  myWin = new Ext.Window({
      title: 'titelForInnerPanel',
      closable: false,
      resizable: false,
      modal: true,
      autoScroll: false,
      height: 450,
      width: 850,
       frame: true,
      id: 'myWin',
      items: [mineOwnerOuterPanelWindow]
  });

  function addRecord() {
  TCNumbercombostore.load({
                      params: {
                          CustId: Ext.getCmp('custcomboId').getValue(),
                          //tcId: Ext.getCmp('TCNoId').getValue()
                      }
                  });
      if (Ext.getCmp('custcomboId').getValue() == "") {
          Ext.example.msg("<%=SelectCustomer%>");
          return;
      }
      buttonValue = '<%=Add%>';
      titelForInnerPanel = '<%=AddDetails%>';
      myWin.setPosition(200,40);
      myWin.show();
      myWin.setTitle(titelForInnerPanel);
      Ext.getCmp('TCNoId').reset();
      Ext.getCmp('yearId').reset();
      Ext.getCmp('nameId').reset();
      Ext.getCmp('lesseeId').reset();
      Ext.getCmp('stateId').reset();
      Ext.getCmp('districtComboId').reset();
      Ext.getCmp('talukComboId').reset();
      Ext.getCmp('villageId').reset();
      Ext.getCmp('postOfficeId').reset();
      Ext.getCmp('addressId').reset();
      Ext.getCmp('pinId').reset();
      Ext.getCmp('phoneNoId').reset();
      Ext.getCmp('faxNoId').reset();
      Ext.getCmp('emailId').reset();
      Ext.getCmp('contactPersonId').reset();
      Ext.getCmp('panNoId').reset();
      Ext.getCmp('tanNoId').reset();
      Ext.getCmp('bankerId').reset();
      Ext.getCmp('branchId').reset();
  }

  function modifyData() {
  
  TCNumbercombostore.load({
    params: {
        CustId: Ext.getCmp('custcomboId').getValue(),
         //tcId: Ext.getCmp('TCNoId').getValue()
    }
});
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
          myWin.setPosition(200, 50);
          myWin.setTitle(titelForInnerPanel);
          myWin.show();
          var selected = grid.getSelectionModel().getSelected();
          Ext.getCmp('TCNoId').setValue(selected.get('tcNumberDataIndex'));
          Ext.getCmp('yearId').setValue(selected.get('yearDataIndex'));
          Ext.getCmp('nameId').setValue(selected.get('nameDataIndex'));
          Ext.getCmp('lesseeId').setValue(selected.get('lesseeNameDataIndex'));
          Ext.getCmp('stateId').setValue(selected.get('stateDataIndex'));
          Ext.getCmp('districtComboId').setValue(selected.get('DistrictDataIndex'));
          Ext.getCmp('talukComboId').setValue(selected.get('TalukDataIndex'));
          Ext.getCmp('villageId').setValue(selected.get('VillageDataIndex'));
          Ext.getCmp('postOfficeId').setValue(selected.get('postOfficeDataIndex'));
          Ext.getCmp('addressId').setValue(selected.get('addressDataIndex'));
          Ext.getCmp('pinId').setValue(selected.get('pinDataIndex'));
          Ext.getCmp('phoneNoId').setValue(selected.get('phoneNoDataIndex'));
          Ext.getCmp('contactPersonId').setValue(selected.get('contactPersonDataIndex'));
          Ext.getCmp('faxNoId').setValue(selected.get('faxNoDataIndex'));
          Ext.getCmp('emailId').setValue(selected.get('emailDataIndex'));
          Ext.getCmp('panNoId').setValue(selected.get('panNoDataIndex'));
          Ext.getCmp('tanNoId').setValue(selected.get('tanNoDataIndex'));
          Ext.getCmp('bankerId').setValue(selected.get('bankerDataIndex'));
          Ext.getCmp('branchId').setValue(selected.get('branchDataIndex'));
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
      }
      
      function validateEmail(email) {
    	var re = validate('email');
    	return re.test(email);
	  }
      
      //***************************************************************************************//
  var reader = new Ext.data.JsonReader({
      idProperty: 'mineOwnerMasterDetails',
      root: 'mineOwnerMasterDetailsRoot',
      totalProperty: 'total',
      fields: [{
          name: 'slnoIndex'
      }, {
          name: 'tcNumberDataIndex'
      },{
          name: 'yearDataIndex'
      },{
          name: 'nameDataIndex'
      },{
          name: 'contactPersonDataIndex'
      },{
          name: 'lesseeNameDataIndex'
      },{
          name: 'stateDataIndex'
      },{
          name: 'DistrictDataIndex'
      },{
          name: 'TalukDataIndex'
      },{
          name: 'VillageDataIndex'
      },{
          name: 'postOfficeDataIndex'
      },{
          name: 'addressDataIndex'
      },{
          name: 'pinDataIndex'
      },{
          name: 'phoneNoDataIndex'
      },{
          name: 'faxNoDataIndex'
      },{
          name: 'emailDataIndex'
      },{
          name: 'panNoDataIndex'
      },{
          name: 'tanNoDataIndex'
      },{
          name: 'bankerDataIndex'
      },{
          name: 'branchDataIndex'
      },{
          name: 'IdDataIndex'
      },{
          name: 'districtIdDataIndex'
      },{
          name: 'TalukIdDataIndex'
      },{
          name: 'stateIdDataIndex'
      },{
          name: 'tcIdDataIndex'
      }]
  });
  
  var store = new Ext.data.GroupingStore({
      autoLoad: false,
      proxy: new Ext.data.HttpProxy({
          url: '<%=request.getContextPath()%>/MiningTCMasterAction.do?param=getOwnerMasterDeatils',
          method: 'POST'
      }),
      remoteSort: false,
      storeId: 'mineOwnerMasterDetails',
      reader: reader
  });
  
  var filters = new Ext.ux.grid.GridFilters({
      local: true,
      filters: [{
          type: 'numeric',
          dataIndex: 'slnoIndex'
      }, {
          type: 'string',
          dataIndex: 'tcNumberDataIndex'
      },{
          type: 'numeric',
          dataIndex: 'yearDataIndex'
      },{
          type: 'string',
          dataIndex: 'nameDataIndex'
      },{
          type: 'string',
          dataIndex: 'contactPersonDataIndex'
      },{
          type: 'string',
          dataIndex: 'lesseeNameDataIndex'
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
          dataIndex: 'postOfficeDataIndex'
      },{
          type: 'string',
          dataIndex: 'addressDataIndex'
      },{
          type: 'string',
          dataIndex: 'pinDataIndex'
      },{
          type: 'string',
          dataIndex: 'phoneNoDataIndex'
      },{
          type: 'numeric',
          dataIndex: 'faxNoDataIndex'
      },{
          type: 'string',
          dataIndex: 'emailDataIndex'
      },{
          type: 'string',
          dataIndex: 'panNoDataIndex'
      },{
          type: 'string',
          dataIndex: 'tanNoDataIndex'
      },{
          type: 'string',
          dataIndex: 'bankerDataIndex'
      },{
          type: 'string',
          dataIndex: 'branchDataIndex'
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
          type: 'int',
          dataIndex: 'tcIdDataIndex'
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
              header: "<span style=font-weight:bold;><%=TCNumber%></span>",
              dataIndex: 'tcNumberDataIndex',
              filter: {
                  type: 'string'
              }
          },{
              header: "<span style=font-weight:bold;><%=Year%></span>",
              dataIndex: 'yearDataIndex',
              filter: {
                  type: 'string'
              }
          },{
              header: "<span style=font-weight:bold;>Name Of Lease</span>",
              dataIndex: 'nameDataIndex',
              filter: {
                  type: 'string'
              }
          },{
              header: "<span style=font-weight:bold;><%=ContactPerson%></span>",
              dataIndex: 'contactPersonDataIndex',
              filter: {
                  type: 'string'
              }
          },{
              header: "<span style=font-weight:bold;><%=NameOfTheLessee%></span>",
              dataIndex: 'lesseeNameDataIndex',
              filter: {
                  type: 'string'
              }
          },{
              header: "<span style=font-weight:bold;><%=State%></span>",
              dataIndex: 'stateDataIndex',
              filter: {
                  type: 'string'
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
              header: "<span style=font-weight:bold;><%=PostOffice%></span>",
              dataIndex: 'postOfficeDataIndex',
              filter: {
                  type: 'string'
              }
          },{
              header: "<span style=font-weight:bold;><%=Address%></span>",
              dataIndex: 'addressDataIndex',
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
              header: "<span style=font-weight:bold;><%=PhoneNo%></span>",
              dataIndex: 'phoneNoDataIndex',
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
              header: "<span style=font-weight:bold;><%=Email%></span>",
              dataIndex: 'emailDataIndex',
              filter: {
                  type: 'string'
              }
          },{
              header: "<span style=font-weight:bold;><%=PANNo%></span>",
              dataIndex: 'panNoDataIndex',
              filter: {
                  type: 'string'
              }
          },{
              header: "<span style=font-weight:bold;><%=TANNo%></span>",
              dataIndex: 'tanNoDataIndex',
              filter: {
                  type: 'string'
              }
          }, {
              header: "<span style=font-weight:bold;><%=Banker%></span>",
              dataIndex: 'bankerDataIndex',
              filter: {
                  type: 'string'
              }
          },{
              header: "<span style=font-weight:bold;><%=Branch%></span>",
              dataIndex: 'branchDataIndex',
              filter: {
                  type: 'string'
              }
          },{
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
              header: "<span style=font-weight:bold;><%=StateCode%></span>",
              dataIndex: 'stateIdDataIndex',
              hidden: true,
              filter: {
                  type: 'int'
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
  
  grid = getGrid('<%=MineOwnerDetails%>', '<%=NoRecordsFound%>', store, screen.width - 40, 460, 31, filters, '<%=ClearFilterData%>', false, '', 17, false, '', false, '', true, 'Excel', jspName, exportDataType, false, 'PDF', true, '<%=Add%>', true, '<%=Modify%>', false, 'Delete');
  
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
 
