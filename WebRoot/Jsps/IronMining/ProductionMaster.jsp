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
tobeConverted.add("Modify_Details");
tobeConverted.add("Select_Customer");
tobeConverted.add("Customer_Name");

tobeConverted.add("Organization_Code");
tobeConverted.add("Organization_Name");
tobeConverted.add("Select_Organization_Name");
tobeConverted.add("Organization_Code");
tobeConverted.add("Mining_Organization_Master");
tobeConverted.add("TC_Number");
tobeConverted.add("Select_TC_Number");


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
String ModifyDetails=convertedWords.get(10);
String SelectCustomer=convertedWords.get(11);
String CustomerName=convertedWords.get(12);String organizationCode=convertedWords.get(13);
String organizationName=convertedWords.get(14);
String SelectOrganizationName=convertedWords.get(15);
String EnterOrganizationCode=convertedWords.get(16);
String miningOrganizationMaster=convertedWords.get(17);
String tcNumber=convertedWords.get(18);
String EnterTcNumber=convertedWords.get(19);
String productionMaster= "Daywise Production";
String production="Production of the Day";
String EnterProduction= "Enter Production";

int userId=loginInfo.getUserId(); 
int systemId = loginInfo.getSystemId();
int customerId = loginInfo.getCustomerId();

String userAuthority=cf.getUserAuthority(systemId,userId);	

boolean addAuth=false;
boolean modifyAuth=false;
if(userAuthority.equalsIgnoreCase("User")){
	addAuth = false;
	modifyAuth=false;
}else{
	addAuth = true;
	modifyAuth = true;
}
	

%>

<!DOCTYPE HTML>
<html>
	<head>
		<base href="<%=basePath%>">
		<title><%=productionMaster%></title>
	</head>
	<body>
	 <%if (loginInfo.getStyleSheetOverride().equals("Y")){%>
       <jsp:include page="../Common/ImportJSSandMining.jsp"/>
	   <jsp:include page="../IronMining/css.jsp" />
		<%}else {%>
		<jsp:include page="../Common/ImportJS.jsp" />
		<jsp:include page="../IronMining/css.jsp" />
		<%} %>
		 <jsp:include page="../Common/ExportJS.jsp" />
 <script>
  var outerPanel;
  var jspName = "ProductionMaster";
  var exportDataType = "int,string,string,string,string,number,string";
  var grid;
  var myWin;
  var buttonValue;
  var orgCode;
  var orgName;
  var selected;
  var totalProductionQty;
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
                  OrgNameComboStore.load({
                  		params: {
                  		clientId:Ext.getCmp('custcomboId').getValue()
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
                  OrgNameComboStore.load({
                  		params: {
                  		clientId:Ext.getCmp('custcomboId').getValue()
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
              width: 25
          },{
              xtype: 'label',
              cls: 'labelstyle',
              id: 'startdatelab',
              width: 200,
              text: 'From Date' + ' :'
          }, {
              width: 5
          }, {
              xtype: 'datefield',
              cls: 'selectstylePerfect',
              width: 120,
              format: getDateFormat(),
              emptyText: 'Select From Date',
              allowBlank: false,
              blankText: 'Select From Date',
              id: 'startdate',
              value: previousDate
          }, {
              width: 70
          }, {
              xtype: 'label',
              cls: 'labelstyle',
              id: 'enddatelab',
              width: 200,
              text: 'To Date' + ' :'
          }, {
              width: 5
          }, {
              xtype: 'datefield',
              cls: 'selectstylePerfect',
              width: 160,
              format: getDateFormat(),
              emptyText: 'Select To Date',
              allowBlank: false,
              blankText: 'Select To Date',
              id: 'enddate',
              value: currentDate
          }, {
              width: 20
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
                  Ext.example.msg("To Date must be greater than From Date");
                  Ext.getCmp('enddate').focus();
                  return;
              }
              //var Startdates = Ext.getCmp('startdate').getValue();
              //var Enddates = Ext.getCmp('enddate').getValue();
              //var dateDifrnc = new Date(Enddates).add(Date.DAY, -31);
              //if (Startdates < dateDifrnc) {
              //    Ext.example.msg("Difference between two dates should not be  greater than 31 days.");
              //    Ext.getCmp('startdate').focus();
              //    return;
              //}
          	 store.load({
               params: {
                 custId: Ext.getCmp('custcomboId').getValue(),
                 jspName: jspName,
                 custName: Ext.getCmp('custcomboId').getRawValue(),
                 endDate: Ext.getCmp('enddate').getValue(),
        		 startDate: Ext.getCmp('startdate').getValue()
              }
           });
         }
       }
      ]
  });
var OrgNameComboStore= new Ext.data.JsonStore({
	url: '<%=request.getContextPath()%>/ProductionMasterAction.do?param=getOrgName',
	root: 'OrgnameRoot',
	autoLoad: false,
	id: 'orgnameId',
	fields: ['ORG_ID','ORG_CODE','ORG_NAME']
	});
	
	//****************************combo for OrgCode***************************************
var OrgNameCombo = new Ext.form.ComboBox({
    store: OrgNameComboStore,
    id: 'OrgnamecomboId',
    mode: 'local',
    forceSelection: true,
    emptyText: '<%=SelectOrganizationName%>',
    blankText: '<%=SelectOrganizationName%>',
    resizable: true,
    selectOnFocus: true,
    allowBlank: true,
    anyMatch: true,
    typeAhead: false,
    triggerAction: 'all',
    lazyRender: true,
    valueField: 'ORG_ID',
    displayField: 'ORG_NAME',
    cls:'selectstylePerfectnew',
    listeners: {
        select: {
            fn: function () {
           	var id=Ext.getCmp('OrgnamecomboId').getValue();
            var row = OrgNameComboStore.findExact('ORG_ID',id);
            var rec = OrgNameComboStore.getAt(row);
            orgcode=rec.data['ORG_CODE'];
            Ext.getCmp('orgCodeID').setValue(orgcode);
            TcNoComboStore.load({
            params : {
            CustId:Ext.getCmp('custcomboId').getValue(),
            orgid:Ext.getCmp('OrgnamecomboId').getValue()
            }
            });
            Ext.getCmp('tcNoId').reset();
            }
        }
    }
});
	//****************************combo for tcno***************************************
var TcNoComboStore= new Ext.data.JsonStore({
				   url: '<%=request.getContextPath()%>/ProductionMasterAction.do?param=getTCNumber',
				   root: 'tcNoRoot',
			       autoLoad: false,
			        id: 'tcId',
				   fields: ['TCNumber','TcId','MPL_Allocate','totalProductionQty']
	});

var TcNoCombo = new Ext.form.ComboBox({
    store: TcNoComboStore,
    id: 'tcNoId',
    mode: 'local',
    forceSelection: true,
    emptyText: '<%=EnterTcNumber%>',
    blankText: '<%=EnterTcNumber%>',
    resizable: true,
    selectOnFocus: true,
    allowBlank: true,
    anyMatch: true,
    typeAhead: false,
    triggerAction: 'all',
    lazyRender: true,
    valueField: 'TcId',
    displayField: 'TCNumber',
    cls:'selectstylePerfectnew',
    listeners: {
     select: {
       fn: function () {
       	   var row = TcNoComboStore.findExact('TcId', Ext.getCmp('tcNoId').getValue());
       	   var rec = TcNoComboStore.getAt(row);
       	   Ext.getCmp('mplAllocId').setValue(rec.data['MPL_Allocate']);
       	   totalProductionQty=rec.data['totalProductionQty'];
       	   Ext.getCmp('mplBalanceId').setValue(rec.data['MPL_Allocate']-totalProductionQty);
       }
     }
    }
});
//******************************************Add and Modify function *********************************************************************//
  var innerPanelForPlantMasterDetails = new Ext.form.FormPanel({
      standardSubmit: true,
      collapsible: false,
      //autoScroll: true,
      height: 280,
      width: 480,
      frame: true,
      id: 'innerPanelForPlantMasterDetailsId',
      layout: 'table',
      resizable: true,
      layoutConfig: {
          columns: 4
      },
      items: [{
          xtype: 'fieldset',
          title: '<%=productionMaster%>',
          cls: 'my-fieldset',
          collapsible: false, 
          autoScroll: true,
          colspan: 3,
          id: 'PlantMasterDetailsid',
          width: 465,
          height: 260,
          layout: 'table',
          layoutConfig: {
              columns: 3,
              tableAttrs: {
                  style: {
                      width: '88%'
                  }
              }
          },
          items: [ {
              xtype: 'label',
              text: '*',
              cls: 'mandatoryfield',
              id: 'dateManId'
          }, {
              xtype: 'label',
              text: 'Date' + ' :',
              cls: 'labelstylenew',
              id: 'dateLabId'
          }, {
              xtype: 'datefield',
              cls: 'selectstylePerfectnew',
              id: 'dateId',
              emptyText: 'Select Date',
              blankText: 'Select Date',
              format: getDateFormat(),
              submitFormat: getDateFormat(),
              value: previousDate,
              maxValue: previousDate
            }, {
              xtype: 'label',
              text: '*',
              cls: 'mandatoryfield',
              id: 'orgNameEmptyId'
          }, {
              xtype: 'label',
              text: '<%=organizationName%>' + ' :',
              cls: 'labelstylenew',
              id: 'orgNameLabelId'
          }, OrgNameCombo,{
              xtype: 'label',
              text: '*',
              cls: 'mandatoryfield',
              id: 'orgCodeEmptyId'
          }, {
              xtype: 'label',
              text: '<%=organizationCode%>' + ' :',
              cls: 'labelstylenew',
              id: 'orgCodeLabelId'
          }, {
              xtype: 'textfield',
              cls: 'selectstylePerfectnew',
              id: 'orgCodeID',
              allowBlank: false,
              readOnly:true,
          },{
              xtype: 'label',
              text: '*',
              cls: 'mandatoryfield',
              id: 'tcNoEmptyId'
          }, {
              xtype: 'label',
              text: '<%=tcNumber%>' + ' :',
              cls: 'labelstylenew',
              id: 'tcNoLabelId'
          },TcNoCombo,{
              xtype: 'label',
              text: '*',
              cls: 'mandatoryfield',
              id: 'mplAllocManId'
          }, {
              xtype: 'label',
              text: 'MPL for Production' + ' :',
              cls: 'labelstylenew',
              id: 'mplAllocLabId'
          },  {
              xtype: 'textfield',
              cls: 'selectstylePerfectnew',
              id: 'mplAllocId',
              allowBlank: false,
              readOnly:true,
          },{
              xtype: 'label',
              text: '*',
              cls: 'mandatoryfield',
              id: 'mplBalanceManId'
          }, {
              xtype: 'label',
              text: 'MPL Balance' + ' :',
              cls: 'labelstylenew',
              id: 'mplBalanceLabId'
          },  {
              xtype: 'textfield',
              cls: 'selectstylePerfectnew',
              id: 'mplBalanceId',
              allowBlank: false,
              readOnly:true,
          },{
              xtype: 'label',
              text: '*',
              cls: 'mandatoryfield',
              id: 'productionManId'
          }, {
              xtype: 'label',
              text: '<%=production%>' + ' :',
              cls: 'labelstylenew',
              id: 'productionLabId'
          },  {
              xtype: 'numberfield',
              cls: 'selectstylePerfectnew',
              id: 'productionId',
              mode: 'local',
              forceSelection: true,
              emptyText: '<%=EnterProduction%>',
              blankText: '<%=EnterProduction%>',
              selectOnFocus: true,
              allowBlank: false,
              decimalPrecision: 2,
              allowNegative: false,
              autoCreate: { tag: "input",autocomplete: "off",maxlength: 9 },
              listeners:{ change: function(f, n, o){
             	f.setValue(Math.abs(n)); 
             
              } },
            
        },
      ]
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
                      if (Ext.getCmp('dateId').getValue() == "") {
                          Ext.example.msg("Select Date");
                          Ext.getCmp('dateId').focus();
                          return;
                      }
                      if(Ext.getCmp('dateId').getValue()>new Date()){
                      	  Ext.example.msg("Date should not be future date.");
                          Ext.getCmp('dateId').focus();
                          return;
                      }
                      if (Ext.getCmp('OrgnamecomboId').getValue() == "") {
                          Ext.example.msg("<%=SelectOrganizationName%>");
                          Ext.getCmp('OrgnamecomboId').focus();
                          return;
                      }
                      if (Ext.getCmp('tcNoId').getValue() == "") {
                          Ext.example.msg("<%=EnterTcNumber%>");
                          Ext.getCmp('tcNoId').focus();
                          return;
                      }
                      var pattern0 = /^[a-zA-Z0-9][a-zA-Z0-9\s]*/;
                      if (!pattern0.test(Ext.getCmp('productionId').getValue())){
                          Ext.example.msg("<%=EnterProduction%>");
                          Ext.getCmp('productionId').focus();
                          return;
                      }
                      var id;
                      if (buttonValue == '<%=Modify%>') {
                          selected = grid.getSelectionModel().getSelected();
                          id = selected.get('uidInd');
                          var qty = Number(Ext.getCmp('productionId').getValue())-Number(selected.get('productionInd'))+Number(totalProductionQty);
                          if(Number(Ext.getCmp('mplAllocId').getValue()) < qty){
	                      	  var qty1 =qty- Number(Ext.getCmp('mplAllocId').getValue());
	                      	  Ext.example.msg("Production Qty should not more than MPL Allocated.Exceeded Qty is "+Number(qty1).toFixed(2));
	                          Ext.getCmp('productionId').focus();
	                          return; 
	                      }
                      }else{
                      	  var qty = Number(Ext.getCmp('productionId').getValue())+Number(totalProductionQty);
	                      if(Number(Ext.getCmp('mplAllocId').getValue()) < qty){
	                      	  var qty1 = qty- Number(Ext.getCmp('mplAllocId').getValue());
	                      	  Ext.example.msg("Production Qty should not more than MPL Allocated.Exceeded Qty is "+Number(qty1).toFixed(2));
	                          Ext.getCmp('productionId').focus();
	                          return; 
	                      }
                      }
                      PlantMasterOuterPanelWindow.getEl().mask();
                      Ext.Ajax.request({
                          url: '<%=request.getContextPath()%>/ProductionMasterAction.do?param=productionMasterAddModify',
                          method: 'POST',
                          params: {
                              buttonValue: buttonValue,
                              custId: Ext.getCmp('custcomboId').getValue(),
                              orgId: Ext.getCmp('OrgnamecomboId').getValue(),
                              tcId: Ext.getCmp('tcNoId').getValue(),
                              productionQty: Ext.getCmp('productionId').getValue(),
                              date : Ext.getCmp('dateId').getValue(),
                              id: id,
                          },
                          success: function(response, options) {
                              var message = response.responseText;
                              console.log(message);
                              Ext.example.msg(message);
                              Ext.getCmp('orgCodeID').reset();
       						  Ext.getCmp('OrgnamecomboId').reset();
       						  Ext.getCmp('tcNoId').reset();
                              myWin.hide();
                              store.load({
				               params: {
				                 custId: Ext.getCmp('custcomboId').getValue(),
				                 jspName: jspName,
				                 custName: Ext.getCmp('custcomboId').getRawValue(),
				                 endDate: Ext.getCmp('enddate').getValue(),
				        		 startDate: Ext.getCmp('startdate').getValue()
				               }
				             });
                              PlantMasterOuterPanelWindow.getEl().unmask();
                          },
                          failure: function() {
                              Ext.example.msg("Error");
                              Ext.getCmp('orgCodeID').reset();
       						  Ext.getCmp('OrgnamecomboId').reset();
       						  Ext.getCmp('tcNoId').reset();
                              store.load({
				               params: {
				                 custId: Ext.getCmp('custcomboId').getValue(),
				                 jspName: jspName,
				                 custName: Ext.getCmp('custcomboId').getRawValue(),
				                 endDate: Ext.getCmp('enddate').getValue(),
				        		 startDate: Ext.getCmp('startdate').getValue()
				               }
				              });
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
  
  var PlantMasterOuterPanelWindow = new Ext.Panel({
      width: 510,
      height: 350,
      standardSubmit: true,
      frame: true,
      items: [innerPanelForPlantMasterDetails, innerWinButtonPanel]
  });
  
  myWin = new Ext.Window({
      title: 'titelForInnerPanel',
      closable: false,
      resizable: false,
      modal: true,
      autoScroll: false,
      height: 400,
      width: 510,
      frame: true,
      id: 'myWin',
      items: [PlantMasterOuterPanelWindow]
  });
//==================================Excel Report====================================//
var innerPanelForReport = new Ext.form.FormPanel({
      standardSubmit: true,
      collapsible: false,
      //autoScroll: true,
      height: 120,
      width: 480,
      frame: true,
      id: 'innerPanelForReportId',
      layout: 'table',
      resizable: true,
      layoutConfig: {
          columns: 4
      },
      items: [{
          xtype: 'fieldset',
          title: 'Day Wise Production Report',
          cls: 'my-fieldset',
          collapsible: false, 
          autoScroll: true,
          colspan: 3,
          id: 'reportfieldId',
          width: 465,
          height: 110,
          layout: 'table',
          layoutConfig: {
              columns: 3,
              tableAttrs: {
                  style: {
                      width: '88%'
                  }
              }
          },
          items: [ {
              xtype: 'label',
              text: '*',
              cls: 'mandatoryfield',
              id: 'dateManId'
          }, {
              xtype: 'label',
              text: 'Star Date' + ' :',
              cls: 'labelstylenew',
              id: 'reporDateLabId'
          }, {
              xtype: 'datefield',
              cls: 'selectstylePerfectnew',
              id: 'reportStartDateId',
              emptyText: 'Select Date',
              blankText: 'Select Date',
              format: getDateFormat(),
              submitFormat: getDateFormat(),
              value: new Date().add(Date.MONTH,-1),
              maxValue: previousDate
            }, {
              xtype: 'label',
              text: '*',
              cls: 'mandatoryfield',
              id: 'noOfDaysManId'
          }, {
              xtype: 'label',
              text: 'No of Days' + ' :',
              cls: 'labelstylenew',
              id: 'noOfDaysLabId'
          },{
              xtype: 'numberfield',
              cls: 'selectstylePerfectnew',
              id: 'noOfDaysId',
              mode: 'local',
              forceSelection: true,
              selectOnFocus: true,
              allowBlank: false,
              decimalPrecision: 0,
              allowNegative: false,
        },
      ]
    }]
  });
  var innerWinButtonPanelForReport = new Ext.Panel({
      id: 'reportButtonId',
      standardSubmit: true,
      collapsible: false,
      autoHeight: true,
      height: 80,
      width: 480,
      frame: true,
      layout: 'table',
      layoutConfig: {
          columns: 4
      },
      buttons: [{
          xtype: 'button',
          text: 'View',
          id: 'viewButtId',
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
                      if (Ext.getCmp('reportStartDateId').getValue() == "") {
                          Ext.example.msg("Select Date");
                          Ext.getCmp('reportStartDateId').focus();
                          return;
                      }
                      if(Ext.getCmp('noOfDaysId').getValue()==""){
                      	  Ext.example.msg("No Of Days should be from 1 to 31");
                          Ext.getCmp('noOfDaysId').focus();
                          return;
                      }
                      if(Ext.getCmp('noOfDaysId').getValue()>31){
                      	  Ext.example.msg("No Of Days should not more than 31");
                          Ext.getCmp('noOfDaysId').focus();
                          return;
                      }
                      window.open("<%=request.getContextPath()%>/DayWiseProductionExcel?date="+Ext.getCmp('reportStartDateId').getRawValue()+"&days="+Ext.getCmp('noOfDaysId').getValue());
                      reportWin.hide();
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
                      reportWin.hide();
                  }
              }
          }
      }]
  });
  var reportPanelWindow = new Ext.Panel({
      width: 510,
      height: 200,
      standardSubmit: true,
      frame: true,
      items: [innerPanelForReport, innerWinButtonPanelForReport]
  });
  
  reportWin = new Ext.Window({
      title: 'Day Wise Report',
      closable: false,
      resizable: false,
      modal: true,
      autoScroll: false,
      height: 250,
      width: 510,
      frame: true,
      id: 'reportWinId',
      items: [reportPanelWindow]
  });
//=====================================================================================//
  function addRecord() {
  	  Ext.getCmp('OrgnamecomboId').setReadOnly(false);
  	  Ext.getCmp('tcNoId').setReadOnly(false);
      if (Ext.getCmp('custcomboId').getValue() == "") {
          Ext.example.msg("<%=SelectCustomer%>");
          Ext.getCmp('custcomboId').focus();
          return;
      }
     
      buttonValue = '<%=Add%>';
      titelForInnerPanel = '<%=AddDetails%>';
      myWin.setPosition(450,50);
      myWin.show();
      myWin.setTitle(titelForInnerPanel);
      Ext.getCmp('dateId').reset(); 
      Ext.getCmp('dateId').setReadOnly(false);
      Ext.getCmp('orgCodeID').reset();
      Ext.getCmp('OrgnamecomboId').reset();
   	  Ext.getCmp('tcNoId').reset();
   	  Ext.getCmp('mplAllocId').reset();
   	  Ext.getCmp('mplBalanceId').reset()
   	  Ext.getCmp('productionId').reset();
  }

  function modifyData() {
  	  Ext.getCmp('dateId').setReadOnly(true);
	  Ext.getCmp('OrgnamecomboId').setReadOnly(true);
	  Ext.getCmp('tcNoId').setReadOnly(true);
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
       selected = grid.getSelectionModel().getSelected();
       if(selected.get('isLatestInd')=='F'){
       	  Ext.example.msg("We can not modify this record. Please select latest one.");
       	  return;
       }
       
       buttonValue = '<%=Modify%>';
       titelForInnerPanel = '<%=ModifyDetails%>';
       myWin.setPosition(450,50);
       myWin.setTitle(titelForInnerPanel);
       myWin.show();
       Ext.getCmp('dateId').setValue(selected.get('dateInd'));
       Ext.getCmp('orgCodeID').setValue(selected.get('orgCodeInd'));
       Ext.getCmp('OrgnamecomboId').setValue(selected.get('orgIdInd'));
       Ext.getCmp('tcNoId').setValue(selected.get('tcIdInd'));
       Ext.getCmp('tcNoId').setRawValue(selected.get('tcNoInd'));
       Ext.getCmp('productionId').setValue(selected.get('productionInd'));
       TcNoComboStore.load({
         params : {
         CustId:Ext.getCmp('custcomboId').getValue(),
         orgid: selected.get('orgIdInd')
         },
         callback: function(){
           var row = TcNoComboStore.findExact('TcId', Ext.getCmp('tcNoId').getValue());
       	   var rec = TcNoComboStore.getAt(row);
       	   Ext.getCmp('mplAllocId').setValue(rec.data['MPL_Allocate']);
       	   totalProductionQty=rec.data['totalProductionQty'];
       	   Ext.getCmp('mplBalanceId').setValue(rec.data['MPL_Allocate']-totalProductionQty);
         }
       });
   }
   //***************************************************************************************//
  var reader = new Ext.data.JsonReader({
      idProperty: 'MiningPlantMasterDetails',
      root: 'ProductionMasterRoot',
      totalProperty: 'total',
      fields: [{
          name: 'slnoIndex'
      },{
          name: 'uidInd'
      },{
          name: 'orgNameInd'
      },{
          name: 'orgCodeInd'
      },{
          name: 'orgIdInd'
      },{
          name: 'tcNoInd'
      },{
          name: 'tcIdInd'
      },{
      	  type: 'date',
      	  dateFormat: getDateFormat(),
          name: 'dateInd'
      },{
      	  name: 'productionInd'
      },{
      	  name: 'isLatestInd'
      }]
  });
  
  var store = new Ext.data.GroupingStore({
      autoLoad: false,
      proxy: new Ext.data.HttpProxy({
          url: '<%=request.getContextPath()%>/ProductionMasterAction.do?param=getProductionMasterDetails',
          method: 'POST'
      }),
      remoteSort: false,
      storeId: 'PlantDetails',
      reader: reader
  });
  
  var filters = new Ext.ux.grid.GridFilters({
      local: true,
      filters: [{
          type: 'numeric',
          dataIndex: 'slnoIndex'
      },{
          type: 'numeric',
          dataIndex: 'uidInd'
      },{
          type: 'string',
          dataIndex: 'orgNameInd'
      },{
          type: 'string',
          dataIndex: 'orgCodeInd'
      },{
          type: 'string',
          dataIndex: 'tcNoInd'
      },{
          type: 'date',
          dataIndex: 'dateInd'
      },{
          type: 'numeric',
          dataIndex: 'productionInd'
      },{
          type: 'int',
          dataIndex: 'orgIdInd'
      },{
          type: 'int',
          dataIndex: 'tcIdInd'
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
              width: 50,
              header: "<span style=font-weight:bold;><%=SLNO%></span>"
          },{
              header: "<span style=font-weight:bold;><%=organizationName%></span>",
              dataIndex: 'orgNameInd',
          },{
              header: "<span style=font-weight:bold;><%=organizationCode%></span>",
              dataIndex: 'orgCodeInd',
          },{
          	  header: "<span style=font-weight:bold;><%=tcNumber%></span>",
              dataIndex: 'tcNoInd',
          },{
              header: "<span style=font-weight:bold;>Date</span>",
              renderer: Ext.util.Format.dateRenderer(getDateFormat()),
              dataIndex: 'dateInd',
              
          },{
          	  header: "<span style=font-weight:bold;><%=production%></span>",
          	  align:'right',
              dataIndex: 'productionInd',
          },{
          	  header: "<span style=font-weight:bold;>ID</span>",
              dataIndex: 'uidInd',
              hidden: true,
              width: 50
          }
      ];
      return new Ext.grid.ColumnModel({
          columns: columns.slice(start || 0, finish),
          defaults: {
              sortable: true
          }
      });
  };
  
  grid = getGrid('<%=productionMaster%>', '<%=NoRecordsFound%>', store, screen.width - 40, 450, 10, filters, '<%=ClearFilterData%>', false, '', 9, false, '', false, '', true, 'Excel', jspName, exportDataType, false, 'PDF', <%=addAuth%>, '<%=Add%>', <%=modifyAuth%>, '<%=Modify%>', false, 'Delete');
  grid.getBottomToolbar().add([
    '-', {
        text: 'Day Wise Report',
        iconCls: 'excelbutton',
        handler: function() {
        	reportWin.show();
        }
    }
]);
 Ext.onReady(function () {
    ctsb = tsb;
    Ext.QuickTips.init();
    Ext.form.Field.prototype.msgTarget = 'side';
    outerPanel = new Ext.Panel({
        title: '',
        renderTo: 'content',
        standardSubmit: true,
        frame: true,
        width: screen.width-25,
        cls: 'outerpanel',
        layout: 'table',
        layoutConfig: {
            columns: 1
        },
        items: [clientPanel, grid]
    });
    var cm =grid.getColumnModel();  
    for (var j = 1; j < cm.getColumnCount(); j++) {
       cm.setColumnWidth(j,250);
    }
    sb = Ext.getCmp('form-statusbar');
});

  </script>
</body>
</html>
<%}%>
