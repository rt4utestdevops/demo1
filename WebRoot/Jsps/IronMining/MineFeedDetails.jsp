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
tobeConverted.add("Customer_Name");

tobeConverted.add("Mine_Feed_Details");
tobeConverted.add("Add_Mine_Feed_Details");
tobeConverted.add("Modify_Mine_Feed_Details");
tobeConverted.add("TC_Number");
tobeConverted.add("Select_TC_Number");
tobeConverted.add("Date");
tobeConverted.add("Select_Date");
tobeConverted.add("Organization_Code");
tobeConverted.add("Permit_No");
tobeConverted.add("Select_Permit_No");
tobeConverted.add("Quantity_Of_ROM");
tobeConverted.add("Enter_ROM_Quantity");
tobeConverted.add("Organization_ROM_Quantity");

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
String CustomerName=convertedWords.get(11);

String MineFeedDetails=convertedWords.get(12);
String addMineFeedDetails=convertedWords.get(13);
String modifyMineFeedDetails=convertedWords.get(14);
String tcNo=convertedWords.get(15);
String selectTCNumber=convertedWords.get(16);
String date=convertedWords.get(17);
String selectDate=convertedWords.get(18);
String organizationCode=convertedWords.get(19);
String permitNo=convertedWords.get(20);
String selectPermitNo=convertedWords.get(21);
String ROMQuantity=convertedWords.get(22);
String enterROMQuantity=convertedWords.get(23);
String OrgROMQuantity=convertedWords.get(24);

int userId=loginInfo.getUserId(); 
int systemId = loginInfo.getSystemId();
int customerId = loginInfo.getCustomerId();

String userAuthority=cf.getUserAuthority(systemId,userId);	

        String addButton="true";
	    String modifyButton="true";
	    String deleteButton="false";
	     if(loginInfo.getIsLtsp()== 0)
	    {
	        addButton="true";
		    modifyButton="true";
		    deleteButton="true";
	    }
	else if(loginInfo.getIsLtsp()== -1 && userAuthority.equalsIgnoreCase("User"))
		{
			addButton="true";
		    modifyButton="true";
		    deleteButton="false";
	        
		}else{
		    addButton="false";
		    modifyButton="false";
		    deleteButton="false";
	       
		}
%>

<jsp:include page="../Common/header.jsp" />
		<base href="<%=basePath%>">
		<title>Trip Feed</title>

	<style>
	.browsebutton
	{
		width:65%;
		height:85%;
		background-image: url(/ApplicationImages/ApplicationButtonIcons/Browse.png) !important;
		background-repeat: no-repeat
	}
	<%if (loginInfo.getStyleSheetOverride().equals("Y")){%>
	.x-form-file-wrap .x-form-file {
		height:35px;
	}
	#filePath{
		height:30px;
	}
	#filePath1{
		height:30px;
	}
	
	<%}%>
	.tripimportimagepanel{
		width: 100%;
		height: 200px;
		background-image:
			url(/ApplicationImages/ExcelImportFormats/RTPImage.png)
			!important;
		background-repeat: no-repeat;
	}
	.tripimportimagepanel1{
		width: 100%;
		height: 200px;
		background-image:
			url(/ApplicationImages/ExcelImportFormats/poImage.png)
			!important;
		background-repeat: no-repeat;
	}
	</style>

	 <%if (loginInfo.getStyleSheetOverride().equals("Y")){%>
       <jsp:include page="../Common/ImportJSSandMining.jsp"/>
		<%}else {%>
		<jsp:include page="../Common/ImportJS.jsp" />
		<%} %>
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
			</style>
		<%}%>
 <script>
 var outerPanel;
  var jspName = "TripFeedDetails";
  var exportDataType = "int,string,string,string,string,string,number,string,string,string,string";
  var grid;
  var store;
  var myWin;
  var buttonValue;
  var uniqueId;
  var OrgCode;
  var dtcur = datecur;
  var orgId;
  var myWinForChallan;
  var mineral;
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
              if (<%= customerId %> > 0) {
                  Ext.getCmp('custcomboId').setValue('<%=customerId%>');
                  custId = Ext.getCmp('custcomboId').getValue();
                  custName = Ext.getCmp('custcomboId').getRawValue();
                  orgNameStore.load({
                      params: {
                      	  type:  Ext.getCmp('typeComboId').getValue(),
                          custId: Ext.getCmp('custcomboId').getValue()
                      }
                  });
                  store.load({
                      params: {
                          custId: custId,
                          CustName: custName,
                          jspName: jspName
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
                  orgNameStore.load({
                      params: {
                      	  type:  Ext.getCmp('typeComboId').getValue(),
                          custId: Ext.getCmp('custcomboId').getValue()
                      }
                  });
                  store.load({
                      params: {
                          custId: custId,
                          CustName: custName,
                          jspName: jspName
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
  //----------------------------------------------PermitNumber Store --------------------------------------------//
  var PermitNumbercombostore = new Ext.data.JsonStore({
      url: '<%=request.getContextPath()%>/TripFeedDetailsAction.do?param=getPermitNumber',
      id: 'PermitNoStoreId',
      root: 'PermitNumRoot',
      autoLoad: false,
      remoteSort: true,
      fields: ['PermitId', 'PermitNo', 'permitQty', 'usedQty', 'permitBalance', 'destHubId','mineralType']
  });
  //----------------------------------------------PermitNumber Combo --------------------------------------------// 
  var PermitNumber = new Ext.form.ComboBox({
      store: PermitNumbercombostore,
      id: 'PermitNumberComboId',
      mode: 'local',
      forceSelection: true,
      emptyText: '<%=selectPermitNo%>',
      blankText: '<%=selectPermitNo%>',
      resizable: true,
      selectOnFocus: true,
      allowBlank: false,
      anyMatch: true,
      typeAhead: false,
      triggerAction: 'all',
      lazyRender: true,
      valueField: 'PermitId',
      displayField: 'PermitNo',
      cls: 'selectstylePerfect',
      listeners: {
          select: {
              fn: function() {
                  var permitId = Ext.getCmp('PermitNumberComboId').getValue();
                  var row = PermitNumbercombostore.find('PermitId', permitId);
                  var rec = PermitNumbercombostore.getAt(row);
                  permitQty = rec.data['permitQty'];
                  permitBal = rec.data['permitBalance'];
                  destHubId = rec.data['destHubId'];
                  mineral= rec.data['mineralType'];
                  Ext.getCmp('balanceQuantityId').setValue(permitBal);
                  Ext.getCmp('permitQuantityId').setValue(permitQty);
                  Ext.getCmp('plantComboId').reset();
                  organizationId=0;
                  orgId=Ext.getCmp('PRSTPORGComboId').getValue();
                  plantNameStore.load({
                      params: {
                          custId: Ext.getCmp('custcomboId').getValue(),
                          destHubId: destHubId,
                          orgId: orgId,
                          mineral: mineral
                      }
                  });
              }
          }
      }
  });
  ////////////////////////////////////////Permit number store for self consumption///////////////////////////////////////////////////////////////
  var PermitNumbercombostore1 = new Ext.data.JsonStore({
    url: '<%=request.getContextPath()%>/TripFeedDetailsAction.do?param=getPermitNumberForSelfConsumption',
      id: 'PermitNoStoreId1',
      root: 'PermitNumRoot1',
      autoLoad: false,
      remoteSort: true,
      fields: ['PermitId', 'PermitNo', 'permitQty', 'usedQty', 'permitBalance', 'destHubId','mineralType']
  });
  var PermitNumber1 = new Ext.form.ComboBox({
      store: PermitNumbercombostore1,
      id: 'PermitNumberComboId1',
      mode: 'local',
      forceSelection: true,
      emptyText: 'Select Permit No',
      blankText: 'Select Permit No',
      resizable: true,
      selectOnFocus: true,
      allowBlank: false,
      anyMatch: true,
      typeAhead: false,
      triggerAction: 'all',
      lazyRender: true,
      valueField: 'PermitId',
      displayField: 'PermitNo',
      cls: 'selectstylePerfect',
      listeners: {
          select: {
              fn: function() {
                  var permitId = Ext.getCmp('PermitNumberComboId1').getValue();
                  var row = PermitNumbercombostore1.find('PermitId', permitId);
                  var rec = PermitNumbercombostore1.getAt(row);
                  permitQty = rec.data['permitQty'];
                  permitBal = rec.data['permitBalance'];
                  destHubId = rec.data['destHubId'];
                  mineral= rec.data['mineralType'];
                  Ext.getCmp('balanceQuantityId1').setValue(permitBal);
                  Ext.getCmp('permitQuantityId1').setValue(permitQty);
                  organizationId=0;
                  orgid=Ext.getCmp('PRSTPORGComboId1').getValue();
              }
          }
      }
  });
  //---------------------------------------------Permit no for Self Consumption---------------------------//
    var permittypeStore = new Ext.data.SimpleStore({
        id: 'permitTypeId',
        fields: ['Name', 'Value'],
        autoLoad: false,
        data: [
           ['ROM Transit', 'Rom Transit'],
           ['Purchased ROM Sale Transit Permit', 'Purchased Rom Sale Transit Permit'],
           ['Processed Ore Transit', 'Processed Ore Transit'],
           ['Processed Ore Sale Transit', 'Processed Ore Sale Transit'],
           ['Domestic Export', 'Domestic Export'],
           ['International Export', 'International Export'],
           ['Import Transit Permit', 'Import Transit Permit']
        ]
    });


   var permittypeCombo = new Ext.form.ComboBox({
        store: permittypeStore,
        id: 'permittypecomboId',
        mode: 'local',
        forceSelection: true,
        emptyText: 'Select Permit Type',
        selectOnFocus: true,
        allowBlank: false,
        anyMatch: true,
        typeAhead: false,
        triggerAction: 'all',
        lazyRender: true,
        valueField: 'Value',
        displayField: 'Name',
        cls: 'selectstylePerfect',
        resizable: true,
        listeners: {
          select: {
              fn: function() {
               	  Ext.getCmp('PRSTPORGComboId1').reset();
			      Ext.getCmp('PermitNumberComboId1').reset();
			      Ext.getCmp('ROMQuantityId1').reset();
			      Ext.getCmp('permitQuantityId1').reset();
			      Ext.getCmp('balanceQuantityId1').reset();
			      Ext.getCmp('vehicleId1').reset();
			      PermitNumbercombostore.removeAll(true);
              	  orgNameStore.load({
                      params: {
                      	  permittype:  Ext.getCmp('permittypeCombo').getValue(),
                          custId: Ext.getCmp('custcomboId').getValue()
                      }
                  });
              }
          }
      }
    });
  //----------------------------------------------Plant Store --------------------------------------------//
  var plantNameStore = new Ext.data.JsonStore({
      url: '<%=request.getContextPath()%>/TripFeedDetailsAction.do?param=getPlantNames',
      id: 'plantStoreId',
      root: 'plantNameRoot',
      autoLoad: false,
      remoteSort: true,
      fields: ['plantName', 'plantId']
  });
  //----------------------------------------------Plant Combo --------------------------------------------// 
  var PlantNameCombo = new Ext.form.ComboBox({
      store: plantNameStore,
      id: 'plantComboId',
      mode: 'local',
      forceSelection: true,
      emptyText: 'Select Plant Name',
      blankText: 'Select Plant Name',
      resizable: true,
      selectOnFocus: true,
      allowBlank: false,
      anyMatch: true,
      typeAhead: false,
      triggerAction: 'all',
      lazyRender: true,
      valueField: 'plantId',
      displayField: 'plantName',
      cls: 'selectstylePerfect',
      listeners: {
          select: {
              fn: function() {}
          }
      }
  });
  
    //----------------------------------------------ORGANIZATION Store --------------------------------------------//
  var orgNameStore = new Ext.data.JsonStore({
      url: '<%=request.getContextPath()%>/TripFeedDetailsAction.do?param=getOrgNames',
      id: 'orgStoreId',
      root: 'orgRoot',
      autoLoad: false,
      remoteSort: true,
      fields: ['orgName', 'orgId', 'orgCode']
  });
  //----------------------------------------------ORGANIZATION Combo --------------------------------------------// 
  var orgNameCombo = new Ext.form.ComboBox({
      store: orgNameStore,
      id: 'orgComboId',
      mode: 'local',
      forceSelection: true,
      emptyText: 'Select Organization Name',
      blankText: 'Select Organization Name',
      resizable: true,
      selectOnFocus: true,
      allowBlank: false,
      anyMatch: true,
      typeAhead: false,
      triggerAction: 'all',
      lazyRender: true,
      valueField: 'orgId',
      displayField: 'orgName',
      cls: 'selectstylePerfect',
      listeners: {
          select: {
              fn: function() {
              	 var org = Ext.getCmp('orgComboId').getValue();
                 var r = orgNameStore.find('orgId', org);
                 var rec1 = orgNameStore.getAt(r);
                 orgCode = rec1.data['orgCode'];
                 Ext.getCmp('oraganizationCode1Id').setValue(orgCode);
                 Ext.getCmp('chaplantComboId').reset();
                 Ext.getCmp('challanNumberComboId').reset();
                 challanNumbercombostore.load({
                     params: {
                         custId: Ext.getCmp('custcomboId').getValue(),
                         tcId: org
                     }
                 });
              }
          }
      }
  });
  
    //----------------------------------------------challanNumber Store --------------------------------------------//
  var challanNumbercombostore = new Ext.data.JsonStore({
      url: '<%=request.getContextPath()%>/TripFeedDetailsAction.do?param=getChallanNumber',
      id: 'challanNoStoreId',
      root: 'challanNumRoot',
      autoLoad: false,
      remoteSort: true,
      fields: ['challanId', 'challanNo', 'challanQty', 'challanBalance','mineral','ctoDate']
  });
  //----------------------------------------------challanNumber Combo --------------------------------------------// 
  var challanNumber = new Ext.form.ComboBox({
      store: challanNumbercombostore,
      id: 'challanNumberComboId',
      mode: 'local',
      forceSelection: true,
      emptyText: 'Select Challan Number',
      blankText: 'Select Challan Number',
      resizable: true,
      selectOnFocus: true,
      allowBlank: false,
      anyMatch: true,
      typeAhead: false,
      triggerAction: 'all',
      lazyRender: true,
      valueField: 'challanId',
      displayField: 'challanNo',
      cls: 'selectstylePerfect',
      listeners: {
          select: {
              fn: function() {
                  var challanId = Ext.getCmp('challanNumberComboId').getValue();
                  var row = challanNumbercombostore.find('challanId', challanId);
                  var rec = challanNumbercombostore.getAt(row);
                  challanQty = rec.data['challanQty'];
                  challanBal = rec.data['challanBalance'];
                  mineral=rec.data['mineral'];
                  ctoDate=rec.data['ctoDate'];
                  var d1= Date.parse(new Date());
                  var d2= Date.parse(ctoDate);
<!--                  if(d1 > d2){-->
<!--                 	 	Ext.example.msg("CTO Date Expired");-->
<!--                 	 	Ext.getCmp('challanNumberComboId').reset();-->
<!--                 	 	return;-->
<!--                  }-->
                  Ext.getCmp('challanBalQuantityId').setValue(challanBal);
                  Ext.getCmp('challanQuantityId').setValue(challanQty);
                  plantStore.load({
                     params: {
                         custId: Ext.getCmp('custcomboId').getValue(),
                         orgId: Ext.getCmp('orgComboId').getValue(),
                         mineral : mineral
                     }
                 });
              }
          }
      }
  });
  
  //----------------------------------------------Plant Store for challan --------------------------------------------//
  var plantStore = new Ext.data.JsonStore({
      url: '<%=request.getContextPath()%>/TripFeedDetailsAction.do?param=getPlantNamesForCha',
      id: 'plantStoreId1',
      root: 'plantNameRoot1',
      autoLoad: false,
      remoteSort: true,
      fields: ['plantName', 'plantId']
  });
  //----------------------------------------------Plant Combo for challan--------------------------------------------// 
  var PlantCombo = new Ext.form.ComboBox({
      store: plantStore,
      id: 'chaplantComboId',
      mode: 'local',
      forceSelection: true,
      emptyText: 'Select Plant Name',
      blankText: 'Select Plant Name',
      resizable: true,
      selectOnFocus: true,
      allowBlank: false,
      anyMatch: true,
      typeAhead: false,
      triggerAction: 'all',
      lazyRender: true,
      valueField: 'plantId',
      displayField: 'plantName',
      cls: 'selectstylePerfect',
      listeners: {
          select: {
              fn: function() {}
          }
      }
  });
  //---------------------------------------------Type Combo-------------------------------------------//
  var typeStore = new Ext.data.SimpleStore({
        id: 'typeStoreId',
        fields: ['Name', 'Value'],
        autoLoad: true,
        data: [
            ['Rom Transit', 'Rom Transit'],
            ['Purchased Rom Sale Transit Permit', 'Purchased Rom Sale Transit Permit']
        ]
    });
  var typeCombo = new Ext.form.ComboBox({
        store: typeStore,
        id: 'typeComboId',
        mode: 'local',
        forceSelection: true,
        emptyText: 'Select Permit Type',
        selectOnFocus: true,
        allowBlank: false,
        anyMatch: true,
        typeAhead: false,
        triggerAction: 'all',
        lazyRender: true,
        resizable: true,
        valueField: 'Value',
        displayField: 'Name',
        cls: 'selectstylePerfect',
        listeners: {
          select: {
              fn: function() {
               	  Ext.getCmp('PRSTPORGComboId').reset();
			      Ext.getCmp('oraganizationCodeId').reset();
			      Ext.getCmp('PermitNumberComboId').reset();
			      Ext.getCmp('ROMQuantityId').reset();
			      Ext.getCmp('plantComboId').reset();
			      Ext.getCmp('permitQuantityId').reset();
			      Ext.getCmp('balanceQuantityId').reset();
			      Ext.getCmp('vehicleId').reset();
			      PermitNumbercombostore.removeAll(true);
              	  orgNameStore.load({
                      params: {
                      	  type:  Ext.getCmp('typeComboId').getValue(),
                          custId: Ext.getCmp('custcomboId').getValue()
                      }
                  });
              	  	Ext.getCmp('oraganizationCodeEmptyId').hide();
              	  	Ext.getCmp('oraganizationCodeLabelId').hide();
              	  	Ext.getCmp('oraganizationCodeId').hide();
              	  	Ext.getCmp('ORGPRSTPEmptyId').show();
              	  	Ext.getCmp('ORGPRSTPLabelId').show();
              	  	Ext.getCmp('PRSTPORGComboId').show();
              }
          }
      }
    });
    //-------------------------------------------------PRSTPORGCombo--------------------------------------------------//
    var PRSTPORGCombo = new Ext.form.ComboBox({
      store: orgNameStore,
      id: 'PRSTPORGComboId',
      hidden:true,
      mode: 'local',
      forceSelection: true,
      emptyText: 'Select Organization Name',
      blankText: 'Select Organization Name',
      selectOnFocus: true,
      allowBlank: false,
      anyMatch: true,
      resizable: true,
      typeAhead: false,
      triggerAction: 'all',
      lazyRender: true,
      valueField: 'orgId',
      displayField: 'orgName',
      cls: 'selectstylePerfect',
      listeners: {
          select: {
              fn: function() {
			      Ext.getCmp('oraganizationCodeId').reset();
			      Ext.getCmp('PermitNumberComboId').reset();
			      Ext.getCmp('ROMQuantityId').reset();
			      Ext.getCmp('plantComboId').reset();
			      Ext.getCmp('permitQuantityId').reset();
			      Ext.getCmp('balanceQuantityId').reset();
			      Ext.getCmp('vehicleId').reset();
              	 PermitNumbercombostore.load({
                      params: {
                          custId: Ext.getCmp('custcomboId').getValue(),
                          orgId: Ext.getCmp('PRSTPORGComboId').getValue(),
                          permitType: Ext.getCmp('typeComboId').getValue()
                      }
                  });
              plantNameStore.removeAll(true);
              }
          }
      }
  });
  
  
  var PRSTPORGCombo1= new Ext.form.ComboBox({
        store: orgNameStore,
        id: 'PRSTPORGComboId1',
        mode: 'local',
        forceSelection: true,
        emptyText: 'Select Organization Name',
        selectOnFocus: true,
        allowBlank: false,
        anyMatch: true,
        typeAhead: false,
        triggerAction: 'all',
        lazyRender: true,
        valueField: 'orgId',
        displayField: 'orgName',
        cls: 'selectstylePerfect',
        resizable: true,
        listeners: {
          select: {
              fn: function() {
                  Ext.getCmp('PermitNumberComboId1').reset();
			      Ext.getCmp('ROMQuantityId1').reset();
			      Ext.getCmp('permitQuantityId1').reset();
			      Ext.getCmp('balanceQuantityId1').reset();
			      Ext.getCmp('vehicleId1').reset();
                PermitNumbercombostore1.load({
                  params: {
                      	  custId: Ext.getCmp('custcomboId').getValue(),
                      	  orgid: Ext.getCmp('PRSTPORGComboId1').getValue(),
                          permitType: Ext.getCmp('permittypecomboId').getValue()
                      }
                  });
              }
          }
      }
    });
    
  
    //----------------------------------------------vehicle Store RTP--------------------------------------------//
  var vehicleStore = new Ext.data.JsonStore({
      url: '<%=request.getContextPath()%>/TripFeedDetailsAction.do?param=getVehicleNo',
      id: 'vehicleStoreId',
      root: 'vehicleRoot',
      autoLoad: false,
      remoteSort: true,
      fields: ['vehicleName']
  }); 
  
  var innerPanelForTripFeed = new Ext.form.FormPanel({
      standardSubmit: true,
      collapsible: false,
      autoScroll: true,
      height: 325,
      width: 480,
      frame: true,
      id: 'innerPanelForTripFeedId',
      layout: 'table',
      resizable: true,
      layoutConfig: {
          columns: 4
      },
      items: [{
          xtype: 'fieldset',
          title: 'Trip Feed Details',
          cls: 'fieldsetpanel',
          collapsible: false,
          autoScroll: true,
          colspan: 3,
          id: 'tripFeedDetailsid',
          width: 460,
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
              id: 'typeEmptyId'
          }, {
              xtype: 'label',
              text: 'Permit Type' + ' :',
              cls: 'labelstyle',
              id: 'typeLabelId'
          }, typeCombo, {
              xtype: 'label',
              text: '*',
              cls: 'mandatoryfield',
              id: 'oraganizationCodeEmptyId'
          }, {
              xtype: 'label',
              text: 'Organization Name' + ' :',
              cls: 'labelstyle',
              id: 'oraganizationCodeLabelId'
          }, {
              xtype: 'textfield',
              cls: 'selectstylePerfect',
              blankText: '',
              emptyText: '',
              labelSeparator: '',
              allowBlank: true,
              id: 'oraganizationCodeId'
          }, {
              xtype: 'label',
              text: '*',
              cls: 'mandatoryfield',
              hidden:true,
              id: 'ORGPRSTPEmptyId'
          }, {
              xtype: 'label',
              text: 'Organization Name' + ' :',
              cls: 'labelstyle',
              hidden:true,
              id: 'ORGPRSTPLabelId'
          }, PRSTPORGCombo, {
              xtype: 'label',
              text: '*',
              cls: 'mandatoryfield',
              id: 'permitNoEmptyId'
          }, {
              xtype: 'label',
              text: '<%=permitNo%>' + ' :',
              cls: 'labelstyle',
              id: 'permitNoLabelId'
          }, PermitNumber, {
              xtype: 'label',
              text: '*',
              cls: 'mandatoryfield',
              id: 'permitQuantityEmptyId'
          }, {
              xtype: 'label',
              text: 'Permit Quantity(tons)' + ' :',
              cls: 'labelstyle',
              id: 'permitQuantityLabelId'
          }, {
              xtype: 'numberfield',
              cls: 'selectstylePerfect',
              allowNegative: false,
              labelSeparator: '',
              allowBlank: false,
              readOnly: true,
              id: 'permitQuantityId'
          }, {
              xtype: 'label',
              text: '*',
              cls: 'mandatoryfield',
              id: 'balanceQuantityEmptyId'
          }, {
              xtype: 'label',
              text: 'Permit Balance(tons)' + ' :',
              cls: 'labelstyle',
              id: 'balanceuantityLabelId'
          }, {
              xtype: 'numberfield',
              cls: 'selectstylePerfect',
              allowNegative: false,
              labelSeparator: '',
              allowBlank: false,
              readOnly: true,
              id: 'balanceQuantityId'
          }, {
              xtype: 'label',
              text: '*',
              cls: 'mandatoryfield',
              id: 'plantEmptyId'
          }, {
              xtype: 'label',
              text: 'Plant Name' + ' :',
              cls: 'labelstyle',
              id: 'plantLabelId'
          }, PlantNameCombo, {
              xtype: 'label',
              text: '*',
              cls: 'mandatoryfield',
              id: 'ROMQuantityEmptyId'
          }, {
              xtype: 'label',
              text: 'Quantity (tons)' + ' :',
              cls: 'labelstyle',
              id: 'ROMQuantityLabelId'
          }, {
              xtype: 'numberfield',
              cls: 'selectstylePerfect',
              blankText: 'Enter Quantity',
              emptyText: 'Enter Quantity',
              allowNegative: false,
              labelSeparator: '',
              allowBlank: false,
              listeners:{ change: function(f, n, o){ f.setValue(Math.abs(n)); } },
              autoCreate: { tag: "input",autocomplete: "off",maxlength: 9 },
              id: 'ROMQuantityId'
          }, {
              xtype: 'label',
              text: '',
              cls: 'mandatoryfield',
              id: 'vehicleEmptyId'
          }, {
              xtype: 'label',
              text: 'Vehicle No' + ' :',
              cls: 'labelstyle',
              id: 'vehicleLabelId'
          }, {
              xtype: 'textfield',
              id: 'vehicleId',
              cls: 'selectstylePerfect',
              blankText: 'Enter Vehicle',
              emptyText: 'Enter Vehicle',
              labelSeparator: '',
              allowBlank: false,
              listeners: { change: function(f,n,o){ //restrict 50
              f.setValue(n.toUpperCase().trim());
			  if(f.getValue().length> 50){ Ext.example.msg("Field exceeded it's Maximum length"); 
				f.setValue(n.substr(0,50).toUpperCase().trim()); f.focus(); }
			 } },
          }]
      }]
  });

  var innerWinButtonPanel = new Ext.Panel({
      id: 'winbuttonid',
      standardSubmit: true,
      collapsible: false,
      autoHeight: true,
      height: 90,
      width: 480,
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
                      if (Ext.getCmp('typeComboId').getValue() == "") {
                          Ext.example.msg("Select Permit Type");
                          Ext.getCmp('typeComboId').focus();
                          return;
                      }
                      if (Ext.getCmp('typeComboId').getValue() == "Purchased Rom Sale Transit Permit" && Ext.getCmp('PRSTPORGComboId').getValue() == "") {
                      	  Ext.example.msg("Select Organization Name");
                          Ext.getCmp('PRSTPORGComboId').focus();
                          return;
                      }
                      if (Ext.getCmp('PermitNumberComboId').getValue() == "") {
                          Ext.example.msg("<%=selectPermitNo%>");
                          Ext.getCmp('PermitNumberComboId').focus();
                          return;
                      }
                      if (Ext.getCmp('plantComboId').getValue() == "") {
                          Ext.example.msg("Select Plant Name");
                          Ext.getCmp('plantComboId').focus();
                          return;
                      }
                      if (Ext.getCmp('ROMQuantityId').getValue() == "") {
                          Ext.example.msg("Enter Quantity");
                          Ext.getCmp('ROMQuantityId').focus();
                          return;
                      }
                      var Qty = Ext.getCmp('ROMQuantityId').getValue();
                      var convertedQty = parseFloat(Qty);
                      var permitBal = Ext.getCmp('balanceQuantityId').getValue();
                      if (convertedQty > permitBal) {
                          Ext.example.msg("Quantity is greater than the Permit Balance");
                          Ext.getCmp('ROMQuantityId').reset();
                          Ext.getCmp('ROMQuantityId').focus();
                          return;
                      }

                      tripFeedPanelWindow.getEl().mask();
                      Ext.Ajax.request({
                          url: '<%=request.getContextPath()%>/TripFeedDetailsAction.do?param=addTripFeedDetails',
                          method: 'POST',
                          params: {
                              buttonValue: buttonValue,
                              custId: Ext.getCmp('custcomboId').getValue(),
                              custName: Ext.getCmp('custcomboId').getRawValue(),
                              orgId: orgId,
                              permitId: Ext.getCmp('PermitNumberComboId').getValue(),
                              ROMQuantity: Ext.getCmp('ROMQuantityId').getValue(),
                              plantId: Ext.getCmp('plantComboId').getValue(),
                              vehicleNo: Ext.getCmp('vehicleId').getValue()
                          },
                          success: function(response, options) {
                              var message = response.responseText;
                              Ext.example.msg(message);
                              Ext.getCmp('oraganizationCodeId').reset();
                              Ext.getCmp('PermitNumberComboId').reset();
                              Ext.getCmp('ROMQuantityId').reset();
                              Ext.getCmp('plantComboId').reset();
                              Ext.getCmp('permitQuantityId').reset();
                              Ext.getCmp('balanceQuantityId').reset();
                              Ext.getCmp('vehicleId').reset();
                              myWin.hide();
                              store.reload();
                              tripFeedPanelWindow.getEl().unmask();
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
  
    var innerPanelForChallan = new Ext.form.FormPanel({
      standardSubmit: true,
      collapsible: false,
      autoScroll: true,
      height: 290,
      width: 480,
      frame: true,
      id: 'innerPanelForChallanId',
      layout: 'table',
      resizable: true,
      layoutConfig: {
          columns: 4
      },
      items: [{
          xtype: 'fieldset',
          title: 'Trip Feed Details',
          cls: 'fieldsetpanel',
          collapsible: false,
          autoScroll: true,
          colspan: 3,
          id: 'fieldsetChallanId',
          width: 440,
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
              id: 'orgEmptyId'
          }, {
              xtype: 'label',
              text: 'Organization Name' + ' :',
              cls: 'labelstyle',
              id: 'orgLabelId'
          }, orgNameCombo, {
              xtype: 'label',
              text: '*',
              cls: 'mandatoryfield',
              id: 'oraganizationCode1EmptyId'
          }, {
              xtype: 'label',
              text: 'Organisation Code' + ' :',
              cls: 'labelstyle',
              id: 'oraganizationCode1LabelId'
          }, {
              xtype: 'textfield',
              cls: 'selectstylePerfect',
              blankText: '',
              emptyText: '',
              labelSeparator: '',
              allowBlank: true,
              readOnly: true,
              id: 'oraganizationCode1Id'
          }, {
              xtype: 'label',
              text: '*',
              cls: 'mandatoryfield',
              id: 'challanEmptyId'
          }, {
              xtype: 'label',
              text: 'Challan No' + ' :',
              cls: 'labelstyle',
              id: 'challanLabelId'
          }, challanNumber, {
              xtype: 'label',
              text: '*',
              cls: 'mandatoryfield',
              id: 'challanQuantityEmptyId'
          }, {
              xtype: 'label',
              text: 'Challan Quantity(tons)' + ' :',
              cls: 'labelstyle',
              id: 'challanQuantityLabelId'
          }, {
              xtype: 'numberfield',
              cls: 'selectstylePerfect',
              allowNegative: false,
              labelSeparator: '',
              allowBlank: false,
              readOnly: true,
              id: 'challanQuantityId'
          }, {
              xtype: 'label',
              text: '*',
              cls: 'mandatoryfield',
              id: 'challanBalQuantityEmptyId'
          }, {
              xtype: 'label',
              text: 'Challan Balance(tons)' + ' :',
              cls: 'labelstyle',
              id: 'challanBaluantityLabelId'
          }, {
              xtype: 'numberfield',
              cls: 'selectstylePerfect',
              allowNegative: false,
              labelSeparator: '',
              allowBlank: false,
              readOnly: true,
              id: 'challanBalQuantityId'
          }, {
              xtype: 'label',
              text: '*',
              cls: 'mandatoryfield',
              id: 'plantEmptyId1'
          }, {
              xtype: 'label',
              text: 'Plant Name' + ' :',
              cls: 'labelstyle',
              id: 'plantLabelId1'
          }, PlantCombo, {
              xtype: 'label',
              text: '*',
              cls: 'mandatoryfield',
              id: 'ROMQuantityEmptyId1'
          }, {
              xtype: 'label',
              text: 'Quantity(tons)' + ' :',
              cls: 'labelstyle',
              id: 'ROMQuantityLabelId1'
          }, {
              xtype: 'numberfield',
              cls: 'selectstylePerfect',
              blankText: 'Enter Quantity',
              emptyText: 'Enter Quantity',
              allowNegative: false,
              labelSeparator: '',
              allowBlank: false,
              listeners:{ change: function(f, n, o){ f.setValue(Math.abs(n)); } },
              autoCreate: { tag: "input",autocomplete: "off",maxlength: 9 },
              id: 'ROMQuantityId1'
          }, {
              xtype: 'label',
              text: '',
              cls: 'mandatoryfield',
              id: 'vehicleEmptyId1'
          }, {
              xtype: 'label',
              text: 'Vehicle No' + ' :',
              cls: 'labelstyle',
              id: 'vehicleLabelId1'
          }, {
              xtype: 'textfield',
              id: 'vehicleId1',
              cls: 'selectstylePerfect',
              blankText: 'Enter Vehicle',
              emptyText: 'Enter Vehicle',
              labelSeparator: '',
              allowBlank: false,
              listeners: { change: function(f,n,o){ //restrict 50
              	 f.setValue(n.toUpperCase().trim());
				 if(f.getValue().length> 50){ Ext.example.msg("Field exceeded it's Maximum length"); 
					f.setValue(n.substr(0,50).toUpperCase().trim()); f.focus(); }
			  } },
          }]
      }]
  });
  
    var WinButtonPanel = new Ext.Panel({
      id: 'buttonId',
      standardSubmit: true,
      collapsible: false,
      autoHeight: true,
      height: 90,
      width: 480,
      frame: true,
      layout: 'table',
      layoutConfig: {
          columns: 4
      },
      buttons: [{
          xtype: 'button',
          text: '<%=Save%>',
          id: 'saveButtonId',
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
                      if (Ext.getCmp('orgComboId').getValue() == "") {
                          Ext.example.msg("select Organization Name");
                          Ext.getCmp('orgComboId').focus();
                          return;
                      }
                      if (Ext.getCmp('challanNumberComboId').getValue() == "") {
                          Ext.example.msg("Select Challan No");
                          Ext.getCmp('challanNumberComboId').focus();
                          return;
                      }
                      if (Ext.getCmp('chaplantComboId').getValue() == "") {
                          Ext.example.msg("Select Plant Name");
                          Ext.getCmp('chaplantComboId').focus();
                          return;
                      }
                      if (Ext.getCmp('ROMQuantityId1').getValue() == "") {
                          Ext.example.msg("Enter Quantity");
                          Ext.getCmp('ROMQuantityId1').focus();
                          return;
                      }
                      var Qty = Ext.getCmp('ROMQuantityId1').getValue();
                      var convertedQty = parseFloat(Qty);
                      var challanBal = Ext.getCmp('challanBalQuantityId').getValue();
                      if (convertedQty > challanBal) {
                          Ext.example.msg("Quantity is greater than the challan used Qty");
                          Ext.getCmp('ROMQuantityId1').reset();
                          Ext.getCmp('ROMQuantityId1').focus();
                          return;
                      }

                      addChallanWindow.getEl().mask();
                      Ext.Ajax.request({
                          url: '<%=request.getContextPath()%>/TripFeedDetailsAction.do?param=addChallanTripDetails',
                          method: 'POST',
                          params: {
                              buttonValue: buttonValue,
                              custId: Ext.getCmp('custcomboId').getValue(),
                              custName: Ext.getCmp('custcomboId').getRawValue(),
                              orgId: Ext.getCmp('orgComboId').getValue(),
                              challanId: Ext.getCmp('challanNumberComboId').getValue(),
                              quantity: Ext.getCmp('ROMQuantityId1').getValue(),
                              chaplantId: Ext.getCmp('chaplantComboId').getValue(),
                              vehicleNo: Ext.getCmp('vehicleId1').getValue(),
                              mineral: mineral
                          },
                          success: function(response, options) {
                              var message = response.responseText;
                              Ext.example.msg(message);
                              Ext.getCmp('orgComboId').reset();
                              Ext.getCmp('oraganizationCode1Id').reset();
                              Ext.getCmp('challanNumberComboId').reset();
                              Ext.getCmp('ROMQuantityId1').reset();
                              Ext.getCmp('chaplantComboId').reset();
                              Ext.getCmp('challanQuantityId').reset();
                              Ext.getCmp('challanBalQuantityId').reset();
                              Ext.getCmp('vehicleId1').reset();
                              myWinForChallan.hide();
                              store.reload();
                              addChallanWindow.getEl().unmask();
                          },
                          failure: function() {
                              Ext.example.msg("Error");
                              store.reload();
                              myWinForChallan.hide();
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
                      myWinForChallan.hide();
                  }
              }
          }
      }]
  });
  

  var tripFeedPanelWindow = new Ext.Panel({
      width: 490,
      height: 440,
      standardSubmit: true,
      frame: true,
      items: [innerPanelForTripFeed, innerWinButtonPanel]
  });

  myWin = new Ext.Window({
      title: 'titelForInnerPanel',
      closable: false,
      resizable: false,
      modal: true,
      autoScroll: false,
      height: 440,
      width: 500,
      frame: true,
      id: 'myWin',
      items: [tripFeedPanelWindow]
  });
  
  var addChallanWindow = new Ext.Panel({
      width: 490,
      height: 400,
      standardSubmit: true,
      frame: true,
      items: [innerPanelForChallan, WinButtonPanel]
  });

  myWinForChallan = new Ext.Window({
      title: 'titelForInnerPanel',
      closable: false,
      resizable: false,
      modal: true,
      autoScroll: false,
      height: 400,
      width: 500,
      frame: true,
      id: 'myWin1',
      items: [addChallanWindow]
  });
   var cancelInnerPanel = new Ext.form.FormPanel({
     standardSubmit: true,
     collapsible: false,
     frame: false,
     id: 'cancel',

     items: [{
         xtype: 'fieldset',
         width: 480,
         title: 'Cancel Details',
         id: 'closefieldset',
         collapsible: false,
         layout: 'table',
         layoutConfig: {
             columns: 5
         },
         items: [{
             xtype: 'label',
             text: '',
             cls: 'mandatoryfield',
             id: 'mandatorycloseLabel'
         }, {
             xtype: 'label',
             text: '*',
             cls: 'mandatoryfield',
             id: 'mandatorycloseLabelId'
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
 var winButtonPanelForCancel = new Ext.Panel({
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
         text: 'Ok',
         id: 'cancelId1',
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
                     cancelWin.getEl().mask();
                     var selected = grid.getSelectionModel().getSelected();
                     id = selected.get('idIndex');
                     Ext.Ajax.request({
                         url: '<%=request.getContextPath()%>/TripFeedDetailsAction.do?param=cancelTripFeed',
                         method: 'POST',
                         params: {
                             id: id,
                             CustID: Ext.getCmp('custcomboId').getValue(),
                             remark: Ext.getCmp('remark').getValue(),
                             plantId: selected.get('plantIdIndex'),
							 permitId: selected.get('permitIdIndex'),
							 qty: selected.get('quantityIndex'),
							 challanNo: selected.get('challanNoIndex'),
                         },
                         success: function(response, options) {
                             var message = response.responseText;
                             Ext.example.msg(message);
                             cancelWin.getEl().unmask();
                             store.reload();
                             cancelWin.hide();
                             Ext.getCmp('remark').reset();
                         },
                         failure: function() {
                             Ext.example.msg("Error");
                             store.reload();
                             Ext.getCmp('remark').reset();
                             cancelWin.hide();
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
                     cancelWin.hide();
                     Ext.getCmp('remark').reset();
                 }
             }
         }
     }]
 });
 var cancelPanel = new Ext.Panel({
     standardSubmit: true,
     collapsible: false,
     autoScroll: true,
     width: 490,
     height: 180,
     frame: true,
     id: 'cancelPanel1',
     items: [cancelInnerPanel]
 });
 var outerPanelWindowForCancel = new Ext.Panel({
     standardSubmit: true,
     id: 'cancelwinpanelId1',
     frame: true,
     height: 250,
     width: 520,
     items: [cancelPanel, winButtonPanelForCancel]
 });

 cancelWin = new Ext.Window({
     closable: false,
     modal: true,
     resizable: false,
     autoScroll: false,
     height: 300,
     width: 530,
     id: 'closemyWin',
     items: [outerPanelWindowForCancel]
 });
 
  function deleteData(){
 	selected = grid.getSelectionModel().getSelected();
      if (Ext.getCmp('custcomboId').getValue() == "") {
          Ext.example.msg("<%=SelectCustomer%>");
          return;
      }
      if (grid.getSelectionModel().getCount() == 0) {
          Ext.example.msg("No Rows Selected");
          return;
      }
      if (grid.getSelectionModel().getCount() > 1) {
          Ext.example.msg("Select Single Row");
          return;
      }
      if (selected.get('statusIndex')=='Cancelled') {
          Ext.example.msg("Can't Cancel Cancelled records");
          return;
      }
      cancelWin.show();
 }

  function addRecord() {
      if (Ext.getCmp('custcomboId').getValue() == "") {
          Ext.example.msg("<%=SelectCustomer%>");
          return;
      }
      buttonValue = '<%=Add%>';
      titelForInnerPanel = 'Add Trip Feed Details';
      myWin.setPosition(450, 60);
      myWin.show();
      myWin.setTitle(titelForInnerPanel);
      Ext.getCmp('typeComboId').reset();
      Ext.getCmp('PRSTPORGComboId').reset();
      Ext.getCmp('oraganizationCodeId').reset();
      Ext.getCmp('PermitNumberComboId').reset();
      Ext.getCmp('ROMQuantityId').reset();
      Ext.getCmp('plantComboId').reset();
      Ext.getCmp('permitQuantityId').reset();
      Ext.getCmp('balanceQuantityId').reset();
      Ext.getCmp('vehicleId').reset();
      orgNameStore.removeAll(true);
      plantNameStore.removeAll(true);
  }
  
  function modifyData() {
      if (Ext.getCmp('custcomboId').getValue() == "") {
          Ext.example.msg("<%=SelectCustomer%>");
          return;
      }
      buttonValue = 'addChallan';
      titelForInnerPanel = 'Add challan Details';
      myWinForChallan.setPosition(450, 60);
      myWinForChallan.show();
      myWinForChallan.setTitle(titelForInnerPanel);
      Ext.getCmp('orgComboId').reset();
      Ext.getCmp('oraganizationCode1Id').reset();
      Ext.getCmp('challanNumberComboId').reset();
      Ext.getCmp('ROMQuantityId1').reset();
      Ext.getCmp('chaplantComboId').reset();
      Ext.getCmp('challanQuantityId').reset();
      Ext.getCmp('challanBalQuantityId').reset();
      Ext.getCmp('vehicleId1').reset();
      vehicleStore.load({
           params: {
               custId: Ext.getCmp('custcomboId').getValue()
           }
     });
     orgNameStore.load({
           params: {
           	type:  "",
           	custId: Ext.getCmp('custcomboId').getValue()
           }
    });
  }

  //***************************************************************************************//
  var reader = new Ext.data.JsonReader({
      idProperty: 'tripFeedDetails',
      root: 'tripFeedRoot',
      totalProperty: 'total',
      fields: [{
          name: 'slnoIndex'
      }, {
          name: 'organizationNameIndex'
      }, {
          name: 'permitNoIndex'
      }, {
          name: 'challanNoIndex'
      }, {
          name: 'plantNameIndex'
      }, {
          name: 'quantityIndex'
      }, {
          name: 'vehicleNoIndex'
      }, {
          type: 'date',
          dateFormat: getDateTimeFormat(),
          name: 'issuedDateIndex'
      },{
          name: 'statusIndex'
      }, {
          name: 'remarksIndex'
      }, {
          name: 'plantIdIndex'
      },{
          name: 'permitIdIndex' 
      },{
          name: 'idIndex'
      }]
  });

  store = new Ext.data.GroupingStore({
      autoLoad: false,
      proxy: new Ext.data.HttpProxy({
          url: '<%=request.getContextPath()%>/TripFeedDetailsAction.do?param=getTripFeedDetails',
          method: 'POST'
      }),
      remoteSort: false,
      storeId: 'tripFeedDetailsStore',
      reader: reader
  });

  var filters = new Ext.ux.grid.GridFilters({
      local: true,
      filters: [{
          type: 'numeric',
          dataIndex: 'slnoIndex'
      }, {
          type: 'string',
          dataIndex: 'organizationNameIndex'
      }, {
          type: 'string',
          dataIndex: 'permitNoIndex'
      }, {
          type: 'string',
          dataIndex: 'challanNoIndex'
      }, {
          type: 'string',
          dataIndex: 'plantNameIndex'
      }, {
          type: 'numeric',
          dataIndex: 'quantityIndex'
      }, {
          type: 'string',
          dataIndex: 'vehicleNoIndex'
      }, {
          type: 'date',
          dataIndex: 'issuedDateIndex'
      },{
          type: 'string',
          dataIndex: 'statusIndex'
      }, {
          type: 'string',
          dataIndex: 'remarksIndex'
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
              header: "<span style=font-weight:bold;><%=SLNO%></span>"
          },{
              dataIndex: 'organizationNameIndex',
              header: "<span style=font-weight:bold;>Organization Name</span>"
          }, {
              dataIndex: 'permitNoIndex',
              header: "<span style=font-weight:bold;><%=permitNo%></span>"
          }, {
              dataIndex: 'challanNoIndex',
              header: "<span style=font-weight:bold;>Challan No</span>"
          }, {
              dataIndex: 'plantNameIndex',
              header: "<span style=font-weight:bold;>Plant Name</span>"
          }, {
              dataIndex: 'quantityIndex',
              align: 'right',
              header: "<span style=font-weight:bold;>Quantity</span>"
          }, {
              dataIndex: 'vehicleNoIndex',
              header: "<span style=font-weight:bold;>Vehicle No</span>"
          }, {
              dataIndex: 'issuedDateIndex',
              header: "<span style=font-weight:bold;>Issued Date</span>",
              renderer: Ext.util.Format.dateRenderer(getDateTimeFormat()),
          },{
              dataIndex: 'statusIndex',
              header: "<span style=font-weight:bold;>Status</span>"
          }, {
              dataIndex: 'remarksIndex',
              header: "<span style=font-weight:bold;>Remarks</span>"
          }
      ];
      return new Ext.grid.ColumnModel({
          columns: columns.slice(start || 0, finish),
          defaults: {
              sortable: true
          }
      });
  };
  //////////////////////////////////////////////Self Consumption//////////////////////////////////////////////////
  var innerPanelForSelfConsumption = new Ext.form.FormPanel({
      standardSubmit: true,
      collapsible: false,
      autoScroll: false,
      height: 250,
      width: 480,
      frame: true,
      id: 'innerPanelForSelfConsumptionId',
      layout: 'table',
      resizable: true,
      layoutConfig: {
          columns: 4
      },
      items: [{
          xtype: 'fieldset',
          title: 'Self Consumption Details',
          cls: 'fieldsetpanel',
          collapsible: false,
          autoScroll: true,
          colspan: 3,
          id: 'SelfConsumptionDetailsid',
          width: 460,
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
              id: 'typeEmptyId1'
          }, {
              xtype: 'label',
              text: 'Permit Type' + ' :',
              cls: 'labelstyle',
              id: 'typeLabelId1'
          },permittypeCombo, 
          {
              xtype: 'label',
              text: '*',
              cls: 'mandatoryfield',
              id: 'orgid1'
          }, {
              xtype: 'label',
              text: 'Organization Name' + ' :',
              cls: 'labelstyle',
              id: 'oraganizationCodeLabelId1'
          }, PRSTPORGCombo1,
           {
              xtype: 'label',
              text: '*',
              cls: 'mandatoryfield',
              id: 'permitNoEmptyId1'
          }, {
              xtype: 'label',
              text: '<%=permitNo%>' + ' :',
              cls: 'labelstyle',
              id: 'permitNoLabelId1'
          },PermitNumber1,{
              xtype: 'label',
              text: '*',
              cls: 'mandatoryfield',
              id: 'permitQuantityEmptyId1'
          }, {
              xtype: 'label',
              text: 'Permit Quantity(tons)' + ' :',
              cls: 'labelstyle',
              id: 'permitQuantityLabelId1'
          }, {
              xtype: 'numberfield',
              cls: 'selectstylePerfect',
              allowNegative: false,
              labelSeparator: '',
              allowBlank: false,
              readOnly: true,
              id: 'permitQuantityId1'
          }, {
              xtype: 'label',
              text: '*',
              cls: 'mandatoryfield',
              id: 'balanceQuantityEmptyId1'
          }, {
              xtype: 'label',
              text: 'Permit Balance(tons)' + ' :',
              cls: 'labelstyle',
              id: 'balanceuantityLabelId1'
          }, {
              xtype: 'numberfield',
              cls: 'selectstylePerfect',
              allowNegative: false,
              labelSeparator: '',
              allowBlank: false,
              readOnly: true,
              id: 'balanceQuantityId1'
          }, {
              xtype: 'label',
              text: '*',
              cls: 'mandatoryfield',
              id: 'ROMQuantityEmptyId1'
          }, {
              xtype: 'label',
              text: 'Self Consumption Qty (tons)' + ' :',
              cls: 'labelstyle',
              id: 'ROMQuantityLabelId1'
          }, {
              xtype: 'numberfield',
              cls: 'selectstylePerfect',
              blankText: 'Enter Quantity',
              emptyText: 'Enter Quantity',
              allowNegative: false,
              labelSeparator: '',
              allowBlank: false,
              listeners:{ change: function(f, n, o){ f.setValue(Math.abs(n)); } },
              autoCreate: { tag: "input",autocomplete: "off",maxlength: 9 },
              id: 'ROMQuantityId11'
          }, {
              xtype: 'label',
              text: '',
              cls: 'mandatoryfield',
              id: 'vehicleEmptyId1'
          }, {
              xtype: 'label',
              text: 'Vehicle No' + ' :',
              cls: 'labelstyle',
              id: 'vehicleLabelId1'
          }, {
              xtype: 'textfield',
              id: 'vehicleId1',
              cls: 'selectstylePerfect',
              blankText: 'Enter Vehicle',
              emptyText: 'Enter Vehicle',
              labelSeparator: '',
              allowBlank: false,
              listeners: { change: function(f,n,o){ //restrict 50
              f.setValue(n.toUpperCase().trim());
			 if(f.getValue().length> 50){ Ext.example.msg("Field exceeded it's Maximum length"); 
				f.setValue(n.substr(0,50).toUpperCase().trim()); f.focus(); }
			 } },
          }]
      }]
  });

  var innerWinButtonPanel1 = new Ext.Panel({
      id: 'savecancelbutton',
      standardSubmit: true,
      collapsible: false,
      autoHeight: true,
      height: 90,
      width: 480,
      frame: true,
      layout: 'table',
      layoutConfig: {
          columns: 4
      },
      buttons: [{
          xtype: 'button',
          text: '<%=Save%>',
          id: 'savebutton',
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
                        if (Ext.getCmp('permittypecomboId').getValue() == "") {
                          Ext.example.msg("Select Permit Type");
                          Ext.getCmp('permittypecomboId').focus();
                          return;
                      }
                      if (Ext.getCmp('PRSTPORGComboId1').getValue() == "") {
                          Ext.example.msg("Select Organization Name");
                          Ext.getCmp('PRSTPORGComboId1').focus();
                          return;
                      }
                     if (Ext.getCmp('PermitNumberComboId1').getValue() == "") {
                          Ext.example.msg("Select Permit Number");
                          Ext.getCmp('PermitNumberComboId1').focus();
                          return;
                      }
                     if (Ext.getCmp('ROMQuantityId11').getValue() == "") {
                          Ext.example.msg("Enter Self Consumption Quantity");
                          Ext.getCmp('ROMQuantityId11').focus();
                          return;
                      }
                      var selfqty = Ext.getCmp('ROMQuantityId11').getValue();
                      var selfQty = parseFloat(selfqty);
                      var permitBal = Ext.getCmp('balanceQuantityId1').getValue();
                     
                       if (selfQty > permitBal) {
                          Ext.example.msg(" Self Consumption Quantity is greater than the Permit Balance");
                          Ext.getCmp('ROMQuantityId11').reset();
                          Ext.getCmp('ROMQuantityId11').focus();
                          return;
                      }
                      tripFeedSelfConsumptionWindow.getEl().mask();
                      Ext.Ajax.request({
                          url: '<%=request.getContextPath()%>/TripFeedDetailsAction.do?param=addSelfConsumptionDetails',
                          method: 'POST',
                          params: {
                              buttonValue: buttonValue,
                              custId: Ext.getCmp('custcomboId').getValue(),
                              custName: Ext.getCmp('custcomboId').getRawValue(),
                              orgId: orgid,
                              permitId: Ext.getCmp('PermitNumberComboId1').getValue(),
                              ROMQuantity: Ext.getCmp('ROMQuantityId11').getValue(),
                              vehicleNo: Ext.getCmp('vehicleId1').getValue()
                           },
                          success: function(response, options) {
                              var message = response.responseText;
                              Ext.example.msg(message);
                              Ext.getCmp('permittypecomboId').reset();
                              Ext.getCmp('PRSTPORGComboId1').reset();
                              Ext.getCmp('PermitNumberComboId1').reset();
                              Ext.getCmp('permitQuantityId1').reset();
                              Ext.getCmp('balanceQuantityId1').reset();
                              Ext.getCmp('ROMQuantityId11').reset();
                              Ext.getCmp('vehicleId1').reset();
                              myWin2.hide();
                              store.reload();
                              tripFeedSelfConsumptionWindow.getEl().unmask();
                          },
                          failure: function() {
                              Ext.example.msg("Error");
                              store.reload();
                              myWin2.hide();
                           }
                      });
                  }
              }
          }
      }, {
          xtype: 'button',
          text: '<%=Cancel%>',
          id: 'cancelid',
          cls: 'buttonstyle',
          iconCls: 'cancelbutton',
          width: 70,
          listeners: {
              click: {
                  fn: function() {
                      myWin2.hide();
                              Ext.getCmp('permittypecomboId').reset();
                              Ext.getCmp('PRSTPORGComboId1').reset();
                              Ext.getCmp('PermitNumberComboId1').reset();
                              Ext.getCmp('permitQuantityId1').reset();
                              Ext.getCmp('balanceQuantityId1').reset();
                              Ext.getCmp('ROMQuantityId11').reset();
                              Ext.getCmp('vehicleId1').reset();
                   }
              }
          }
      }]
  });
  
  var tripFeedSelfConsumptionWindow = new Ext.Panel({
      width: 490,
      height: 350,
      standardSubmit: true,
      frame: true,
      items: [innerPanelForSelfConsumption, innerWinButtonPanel1]
  });

  myWin2 = new Ext.Window({
      title: 'Self Consumption',
      closable: false,
      resizable: false,
      modal: true,
      autoScroll: false,
      height: 350,
      width: 500,
      frame: true,
      id: 'myWin2',
      items: [tripFeedSelfConsumptionWindow]
  });
  
  
function closetripsummary(){
   if (Ext.getCmp('custcomboId').getValue() == "") {
          Ext.example.msg("<%=SelectCustomer%>");
          return;
      }
      buttonValue = 'closetrip';
      titelForInnerPanel = 'Add Self Consumption Details';
      myWin.setPosition(450, 60);
      myWin2.show();
      myWin.setTitle(titelForInnerPanel);
      orgNameStore.load({
           params: {
           	permitType:  "",
           	custId: Ext.getCmp('custcomboId').getValue()
           }
    });
    }
  
  grid = getGrid('Trip Feed Details', '<%=NoRecordsFound%>', store, screen.width - 40, 460,37, filters, 'Clear Filter Data', false, '', 23, false, '', false, '', true, 'Excel', jspName, exportDataType, false, 'PDF', true, 'Add ROM Qty', true, 'Add PO Qty', <%=deleteButton%>, 'cancel', true,'Self Consumption', false, 'Destination Weight', false, 'Close Trip',false,'',false,'',true,'Import ROM Qty',true,'Import PO Qty');
  

  //**************************************Import excel for RTP*********************************************************//

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
      root: 'RTPImportRoot',
      totalProperty: 'total',
      fields: [{
          name: 'importslnoIndex'
      }, {
          name: 'importorgNameIndex'
      }, {
          name: 'importPermitNoIndex'
      }, {
          name: 'importQuantityIndex'
      }, {
          name: 'importplantNameIndex'
      }, {
          name: 'importVehicleNoIndex'
      }, {
          name: 'importplantIdIndex'
      }, {
          name: 'importTcIdIndex'
      }, {
          name: 'importOrgIdIndex'
      }, {
          name: 'importpermitIdIndex'
      }, {
          name: 'importValidStatusIndex'
      }, {
          name: 'importRemarksIndex'
      }]
  });

  var importStore = new Ext.data.GroupingStore({
      proxy: new Ext.data.HttpProxy({
          url: '<%=request.getContextPath()%>/TripFeedDetailsAction.do?param=getRTPImportDetails',
          method: 'POST'
      }),
      remoteSort: false,
      bufferSize: 700,
      autoLoad: false,
      reader: importReader
  });

  var createColModel = function(finish, start) {
      var columns = [
          new Ext.grid.RowNumberer({
              header: "<span style=font-weight:bold;><%=SLNO%></span>",
              width: 50
          }), {
              header: "<span style=font-weight:bold;><%=SLNO%></span>",
              dataIndex: 'importslnoIndex',
              hidden: true,
              width: 100
          }, {
              header: "<span style=font-weight:bold;>Organization Name</span>",
              width: 105,
              dataIndex: 'importorgNameIndex'
          }, {
              header: "<span style=font-weight:bold;>Permit No</span>",
              width: 130,
              dataIndex: 'importPermitNoIndex'
          }, {
              header: "<span style=font-weight:bold;>Quantity</span>",
              width: 150,
              dataIndex: 'importQuantityIndex'
          }, {
              header: "<span style=font-weight:bold;>Plant Name</span>",
              width: 100,
              dataIndex: 'importplantNameIndex'
          }, {
              header: "<span style=font-weight:bold;>Vehicle No</span>",
              width: 120,
              dataIndex: 'importVehicleNoIndex'
          }, {
              header: "<span style=font-weight:bold;>Remarks</span>",
              width: 100,
              dataIndex: 'importRemarksIndex'
          }, {
              header: "<span style=font-weight:bold;>Valid Status</span>",
              width: 80,
              dataIndex: 'importValidStatusIndex',
              renderer: checkValid
          }
      ];
      return new Ext.grid.ColumnModel({
          columns: columns.slice(start || 0, finish),
          defaults: {
              sortable: false
          }
      });
  };

  var importgrid = getImportExcelGrid('', 'No Records Found', importStore, 1225, 198, 20, '', '', false, '', 20, false, '', false, '', false, 'Excel', jspName, exportDataType, false, 'PDF', false, 'Add', false, 'Modify', false, 'Delete', false, '', false, '', false, '', false, '', false, '', false, '', true, 'Save', true, 'Clear', true, 'Close');

  var excelImageFormat = new Ext.FormPanel({
      standardSubmit: true,
      collapsible: false,
      id: 'excelImageId',
      height: 170,
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
                      url: '<%=request.getContextPath()%>/TripFeedDetailsAction.do?param=importRTPDetails&custId='+custId,
                      enctype: 'multipart/form-data',
                      waitMsg: 'Uploading your file...',
                      success: function(response, action) {

                          Ext.Ajax.request({
                              url: '<%=request.getContextPath()%>/TripFeedDetailsAction.do?param=getImportRTPDetails',
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
                  url: '<%=request.getContextPath()%>/TripFeedDetailsAction.do?param=openStandardFileFormats'
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
      width: 1240,
      height: 500,
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
                          url: '<%=request.getContextPath()%>/TripFeedDetailsAction.do?param=saveImportDetailsForRTP',
                          method: 'POST',
                          params: {
                              json: saveJson,
                              custId : Ext.getCmp('custcomboId').getValue()
                          },
                          success: function(response, options) {
                              var message = response.responseText;
                              Ext.example.msg(message);
                              store.load({
			                      params: {
			                          custId: Ext.getCmp('custcomboId').getValue(),
			                          CustName: Ext.getCmp('custcomboId').getRawValue(),
			                          jspName: jspName
			                      }
			                  });
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
          Ext.example.msg("<%=SelectCustomer%>");
          return;
      }
      importButton = "import";
      importTitle = 'RTP Import Details';
      importWin.show();
      importWin.setTitle(importTitle);
  }
  
  
    //**************************************Import excel for PO Challan*********************************************************//

  function getImportExcelGridForPO(gridtitle, emptytext, store, width, height, gridnoofcols, filters, filterstr, reconfigure, reconfigurestr, reconfigurenoofcols, group, groupstr, chart, chartstr, excel, excelstr, jspName, exportDataType, pdf, pdfstr, add, addstr, modify, modifystr, del, delstr, closetrip, closestr, verify, verifystr, approve, approvestr, copy, copystr, postpone, postponestr, importExcel, importStr, save, saveStr, clearData, clearStr, close, closeStr) {
      var grid = new Ext.grid.GridPanel({
          title: gridtitle,
          border: false,
          height: getGridHeight(),
          autoScroll: true,
          sortable: false,
          store: store,
          id: 'grid1',
          colModel: createColModelPO(gridnoofcols),
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
                      saveDataPO();

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
                      clearInputDataPO();

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
                      closeImportPOWin();
                  }
              }
          ]);
      }
      return grid;
  }
  var importReaderForPO = new Ext.data.JsonReader({
      root: 'POImportRoot1',
      totalProperty: 'total',
      fields: [{
          name: 'importslnoIndex1'
      }, {
          name: 'importTcNoIndex1'
      }, {
          name: 'importorgNameIndex1'
      }, {
          name: 'importChallanNoIndex1'
      }, {
          name: 'importQuantityIndex1'
      }, {
          name: 'importplantNameIndex1'
      }, {
          name: 'importVehicleNoIndex1'
      }, {
          name: 'importplantIdIndex1'
      }, {
          name: 'importOrgIdIndex1'
      }, {
          name: 'importChallanIdIndex1'
      }, {
          name: 'importValidStatusIndex1'
      }, {
          name: 'importRemarksIndex1'
      }]
  });

  var importPOStore = new Ext.data.GroupingStore({
      proxy: new Ext.data.HttpProxy({
          url: '<%=request.getContextPath()%>/TripFeedDetailsAction.do?param=getImportPOChallanDetails',
          method: 'POST'
      }),
      remoteSort: false,
      bufferSize: 700,
      autoLoad: false,
      reader: importReaderForPO
  });

  var createColModelPO = function(finish, start) {
      var columns = [
          new Ext.grid.RowNumberer({
              header: "<span style=font-weight:bold;><%=SLNO%></span>",
              width: 50
          }), {
              header: "<span style=font-weight:bold;><%=SLNO%></span>",
              dataIndex: 'importslnoIndex1',
              hidden: true,
              width: 100
          }, {
              header: "<span style=font-weight:bold;>Organization Name</span>",
              width: 105,
              dataIndex: 'importorgNameIndex1'
          }, {
              header: "<span style=font-weight:bold;>Challan No</span>",
              width: 130,
              dataIndex: 'importChallanNoIndex1'
          }, {
              header: "<span style=font-weight:bold;>Quantity</span>",
              width: 150,
              dataIndex: 'importQuantityIndex1'
          }, {
              header: "<span style=font-weight:bold;>Plant Name</span>",
              width: 100,
              dataIndex: 'importplantNameIndex1'
          }, {
              header: "<span style=font-weight:bold;>Vehicle No</span>",
              width: 120,
              dataIndex: 'importVehicleNoIndex1'
          }, {
              header: "<span style=font-weight:bold;>Remarks</span>",
              width: 100,
              dataIndex: 'importRemarksIndex1'
          }, {
              header: "<span style=font-weight:bold;>Valid Status</span>",
              width: 80,
              dataIndex: 'importValidStatusIndex1',
              renderer: checkValid
          }
      ];
      return new Ext.grid.ColumnModel({
          columns: columns.slice(start || 0, finish),
          defaults: {
              sortable: false
          }
      });
  };

  var importPOgrid = getImportExcelGridForPO('', 'No Records Found', importPOStore, 1225, 198, 20, '', '', false, '', 20, false, '', false, '', false, 'Excel', jspName, exportDataType, false, 'PDF', false, 'Add', false, 'Modify', false, 'Delete', false, '', false, '', false, '', false, '', false, '', false, '', true, 'Save', true, 'Clear', true, 'Close');

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
                      clearInputDataPO();
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
                      url: '<%=request.getContextPath()%>/TripFeedDetailsAction.do?param=importPOChallanDetails&custId='+custId,
                      enctype: 'multipart/form-data',
                      waitMsg: 'Uploading your file...',
                      success: function(response, action) {
                          Ext.Ajax.request({
                              url: '<%=request.getContextPath()%>/TripFeedDetailsAction.do?param=getImportPOChallanDetails',
                              method: 'POST',
                              params: {
                                  importResponse: action.response.responseText
                              },
                              success: function(response, options) {
                                  var responseImportData1 = Ext.util.JSON.decode(response.responseText);
                                  importPOStore.loadData(responseImportData1);

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
                  url: '<%=request.getContextPath()%>/TripFeedDetailsAction.do?param=openStandardFileFormats1'
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
      items: [fileUploadPanel1, excelImageFormat1, importPOgrid]
  });

  var importWin1 = new Ext.Window({
      title: 'PO Challan Import Details',
      width: 1240,
      height: 500,
      closable: false,
      modal: true,
      resizable: false,
      autoScroll: false,
      id: 'importWin1',
      items: [importPanelWindow1]
  });

   function clearInputDataPO() {
      importPOgrid.store.clearData();
      importPOgrid.view.refresh();
  }
  
  function closeImportPOWin() {
      fileUploadPanel1.getForm().reset();
      importWin1.hide();
      clearInputDataPO();
  }

  function saveDataPO() {
      var ValidCount1 = 0;
      var totalcount1 = importPOStore.data.length;
      for (var i = 0; i < importPOStore.data.length; i++) {
          var record = importPOStore.getAt(i);
          var checkvalidOrInvalid1 = record.data['importValidStatusIndex1'];
          if (checkvalidOrInvalid1 == 'Valid') {
              ValidCount1++;
          }
      }

      var saveJson1 = getJsonOfStore1(importPOStore);

      Ext.Msg.show({
          title: 'Saving..',
          msg: 'We have ' + ValidCount1 + ' valid transaction to be saved out of ' + totalcount1 + ' .Do you want to continue?',
          buttons: Ext.Msg.YESNO,
          fn: function(btn) {
              if (btn == 'no') {
                  return;
              }
              if (btn == 'yes') {
                  if (saveJson1 != '[]' && ValidCount1 > 0) {
                      Ext.Ajax.request({
                          url: '<%=request.getContextPath()%>/TripFeedDetailsAction.do?param=saveImportDetailsForPOChallan',
                          method: 'POST',
                          params: {
                              json1: saveJson1,
                              custId : Ext.getCmp('custcomboId').getValue()
                          },
                          success: function(response, options) {
                              var message = response.responseText;
                              Ext.example.msg(message);
                              store.load({
			                      params: {
			                          custId: Ext.getCmp('custcomboId').getValue(),
			                          CustName: Ext.getCmp('custcomboId').getRawValue(),
			                          jspName: jspName
			                      }
			                  });
                          },
                          failure: function() {
                              Ext.example.msg("Error");
                          }
                      });
                      clearInputDataPO();
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
          Ext.example.msg("<%=SelectCustomer%>");
          return;
      }
      importButton1 = "importPO";
      importTitle1 = 'PO Challan Import Details';
      importWin1.show();
      importWin1.setTitle(importTitle1);
  }
  <%if (loginInfo.getStyleSheetOverride().equals("Y")){%>
	  importWin.setHeight(505);
	  importWin.setWidth(1240);
	  importWin1.setHeight(505);
	  importWin1.setWidth(1240);
  <%}%>
  Ext.onReady(function() {
      ctsb = tsb;
      Ext.QuickTips.init();
      Ext.form.Field.prototype.msgTarget = 'side';
      outerPanel = new Ext.Panel({
          title: '',
          renderTo: 'content',
          standardSubmit: true,
          frame: true,
          width: screen.width - 22,
          cls: 'outerpanel',
          layout: 'table',
          layoutConfig: {
              columns: 1
          },
          items: [clientPanel, grid]
      });
      var cm = grid.getColumnModel();
      for (var j = 1; j < cm.getColumnCount(); j++) {
          cm.setColumnWidth(j, 177);
      }
      sb = Ext.getCmp('form-statusbar');
  });

 </script>
 <jsp:include page="../Common/footer.jsp" />
 <!-- </body>   -->
 <!-- </html> -->
<%}%>

 
