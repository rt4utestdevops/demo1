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
tobeConverted.add("Plant_Name");
tobeConverted.add("Plant_Master");
tobeConverted.add("Enter_Plant_Name");
tobeConverted.add("Total_Fines");
tobeConverted.add("Total_Lumps");
tobeConverted.add("Total_Rejects");
tobeConverted.add("Total_UFO");
tobeConverted.add("Total_Tailings");
tobeConverted.add("Hub_Location");

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
String PlantName=convertedWords.get(20);
String plantMaster=convertedWords.get(21);
String EnterPlantName=convertedWords.get(22);
String totalFines=convertedWords.get(23);
String totalLumps=convertedWords.get(24);
String totalRejects=convertedWords.get(25);
String totalUFO=convertedWords.get(26);
String totalTailings=convertedWords.get(27);
String hubLocation = convertedWords.get(28);
String totalConcentrates = "Total Concentrates";

String selectHubLocation = "Select Hub Location";

int userId=loginInfo.getUserId(); 
int systemId = loginInfo.getSystemId();
int customerId = loginInfo.getCustomerId();

String userAuthority=cf.getUserAuthority(systemId,userId);	

if(customerId > 0 && loginInfo.getIsLtsp()== -1 && !userAuthority.equalsIgnoreCase("Admin"))
	{
		response.sendRedirect(request.getContextPath()+ "/Jsps/Common/401Error.html");
	}
	else{

%>

<!DOCTYPE HTML>
<html>
	<head>
		<base href="<%=basePath%>">
		<title><%=plantMaster%></title>
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
  var jspName = "Plant Master Details";
  var exportDataType = "int,int,string,string,string,string,string,string,number,number,number,number,number,number,number,number,number,number,number,number,string,string";
  var grid;
  var myWin;
  var buttonValue;
  var orgCode;
  var orgName;
  var selected;
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
                  store.load({
                      params: {
                          CustId: custId,
                          jspName: jspName,
                          CustName: Ext.getCmp('custcomboId').getRawValue()
                      }
                  });
                  HubLocationStore.load({
                    params: {
                        CustID: custId
                    }
                  });
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
                  store.load({
                      params: {
                          CustId: custId,
                          jspName: jspName,
                          CustName: Ext.getCmp('custcomboId').getRawValue()
                      }
                  });
                  HubLocationStore.load({
                    params: {
                        CustID: custId
                    }
                  });
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
              width: 40
          }
      ]
  });
var OrgNameComboStore= new Ext.data.JsonStore({
	url: '<%=request.getContextPath()%>/PlantMasterAction.do?param=getOrgname',
	root: 'OrgnameRoot',
	autoLoad: false,
	id: 'orgnameId',
	fields: ['id','organizationCode','organizationName']
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
    valueField: 'id',
    displayField: 'organizationName',
    cls:'selectstylePerfectnew',
    listeners: {
        select: {
            fn: function () {
            
           	var id=Ext.getCmp('OrgnamecomboId').getValue();
            var row = OrgNameComboStore.findExact('id',id);
            var rec = OrgNameComboStore.getAt(row);
            orgcode=rec.data['organizationCode'];
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
				   url: '<%=request.getContextPath()%>/PlantMasterAction.do?param=getTCNumber',
				   root: 'tcNoRoot',
			       autoLoad: false,
			        id: 'tcId',
				   fields: ['TCNumber','TcId']
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
            }
        }
    }
});
   var mineralStore = new Ext.data.SimpleStore({
        id: 'mineralsComboStoreId',
        fields: ['Name', 'Value'],
        autoLoad: false,
        data: [
            ['Iron Ore', 'Iron Ore'],
            ['Iron Ore(E-Auction)', 'Iron Ore(E-Auction)']
        ]
    });
    //****************************combo for Mineral****************************************
    var mineralCombo = new Ext.form.ComboBox({
        store: mineralStore,
        id: 'mineralId',
        mode: 'local',
        forceSelection: true,
        emptyText: 'Select Mineral',
        resizable: true,
        selectOnFocus: true,
        allowBlank: false,
        anyMatch: true,
        typeAhead: false,
        triggerAction: 'all',
        lazyRender: true,
        valueField: 'Value',
        displayField: 'Name',
        cls: 'selectstylePerfectnew',
        listeners: {
            select: {
                fn: function() {
                }
            }
        }
    });
//******************************** Hub Location **************************************//
var HubLocationStore= new Ext.data.JsonStore({
           url: '<%=request.getContextPath()%>/PlantMasterAction.do?param=getHubLocation',
           id: 'hubLocationStoreId',
				    root: 'sourceHubStoreRoot',
				    autoload: false,
				    remoteSort: true,
				    fields: ['Hubname','HubID']
	});
	
var HubLocationCombo = new Ext.form.ComboBox({
    store: HubLocationStore,
    id: 'HubLocationcomboId',
    mode: 'local',
    forceSelection: true,
    emptyText: '<%=selectHubLocation%>',
    blankText: '<%=selectHubLocation%>',
    resizable: true,
    selectOnFocus: true,
    allowBlank: true,
    anyMatch: true,
    typeAhead: false,
    triggerAction: 'all',
    lazyRender: true,
    valueField: 'HubID',
    displayField: 'Hubname',
    cls:'selectstylePerfectnew',
    listeners: {
        select: {
            fn: function () {
				hubLocationId=Ext.getCmp('HubLocationcomboId').getValue();
            }
        }
    }
});
  //******************************************Add and Modify function *********************************************************************//
  var innerPanelForPlantMasterDetails = new Ext.form.FormPanel({
      standardSubmit: true,
      collapsible: false,
      autoScroll: true,
      height: 228,
      width: 470,
      frame: true,
      id: 'innerPanelForPlantMasterDetailsId',
      layout: 'table',
      resizable: true,
      layoutConfig: {
          columns: 4
      },
      items: [{
          xtype: 'fieldset',
          title: '<%=plantMaster%>',
          cls: 'my-fieldset',
          collapsible: false, 
          autoScroll: true,
          colspan: 3,
          id: 'PlantMasterDetailsid',
          width: 455,
          height: 210,
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
              id: 'plantNameEmptyId'
          }, {
              xtype: 'label',
              text: '<%=PlantName%>' + ' :',
              cls: 'labelstylenew',
              id: 'plantNameLabelId'
          }, {
              xtype: 'textfield',
              cls: 'selectstylePerfectnew',
              allowBlank: false,
              blankText: '<%=EnterPlantName%>',
              emptyText: '<%=EnterPlantName%>',
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
              id: 'plantNameID'
        }, {
              xtype: 'label',
              text: '*',
              cls: 'mandatoryfield',
              id: 'hubLocEmptyId'
          }, {
              xtype: 'label',
              text: '<%=hubLocation%>' + ' :',
              cls: 'labelstylenew',
              id: 'hubLocLabelId'
          },  HubLocationCombo,
          {
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
              blankText: '<%=EnterOrganizationCode%>',
              emptyText: '<%=EnterOrganizationCode%>',
              autoCreate: {//restricts user to 50 chars max, 
                   tag: "input",
                   maxlength: 50,
                   type: "text",
                   size: "50",
                   autocomplete: "off"
               },
              labelSeparator: '',
              listeners:{
					change: function(field, newValue, oldValue){
					field.setValue(newValue.toUpperCase());
					}
					}
          },{
              xtype: 'label',
              text: '',
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
              id: 'hubLocEmptyId55'
          }, {
              xtype: 'label',
              text: 'Mineral Type' + ' :',
              cls: 'labelstylenew',
              id: 'mineralLabelId'
          },  mineralCombo,
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
                      var pattern = /^[a-zA-Z0-9][a-zA-Z0-9\s]*/;
                      if (!pattern.test(Ext.getCmp('plantNameID').getValue())) {
                          Ext.example.msg("Enter Plant Name Starting With Character Or Number");
                          Ext.getCmp('plantNameID').focus();
                          return;
                        }
                        if (Ext.getCmp('HubLocationcomboId').getValue() == "") {
                          Ext.example.msg("<%=selectHubLocation%>");
                          Ext.getCmp('HubLocationcomboId').focus();
                          return;
                      }
                      var pattern = /^[a-zA-Z0-9][a-zA-Z0-9\s]*/;
                      if (!pattern.test(Ext.getCmp('OrgnamecomboId').getValue())) {
                          Ext.example.msg("<%=SelectOrganizationName%>");
                          Ext.getCmp('OrgnamecomboId').focus();
                          return;
                      }
                      if (Ext.getCmp('orgCodeID').getValue() == "") {
                          Ext.example.msg("<%=EnterOrganizationCode%>");
                          Ext.getCmp('orgCodeID').focus();
                          return;
                      }
                      if (Ext.getCmp('mineralId').getValue() == "") {
                          Ext.example.msg("Select Mineral Type");
                          Ext.getCmp('mineralId').focus();
                          return;
                      }
                      var id;
                      var orgNameModify;
                      var tcNoModify;
                      if (buttonValue == '<%=Modify%>') {
                          selected = grid.getSelectionModel().getSelected();
                          id = selected.get('UniqueIDIndex');
                          if (selected.get('OrganizationNameIndex') != Ext.getCmp('OrgnamecomboId').getValue()) {
                                orgNameModify = Ext.getCmp('OrgnamecomboId').getValue();
                            } else {
                                orgNameModify = selected.get('OrgIdIndex');
                            }
                            if (selected.get('TcNoIndex') != Ext.getCmp('tcNoId').getValue()) {
                                tcNoModify = Ext.getCmp('tcNoId').getValue();
                            } else {
                                tcNoModify = selected.get('TcIdIndex');
                            }
                      }
                      PlantMasterOuterPanelWindow.getEl().mask();
                      Ext.Ajax.request({
                          url: '<%=request.getContextPath()%>/PlantMasterAction.do?param=plantMasterAddModify',
                          method: 'POST',
                          params: {
                              buttonValue: buttonValue,
                              CustID: Ext.getCmp('custcomboId').getValue(),
                              id: id,
                              plantName:Ext.getCmp('plantNameID').getValue(),
                              hubLocId:Ext.getCmp('HubLocationcomboId').getValue(),
                              tcNo:Ext.getCmp('tcNoId').getValue(),
                              orgCode:Ext.getCmp('orgCodeID').getValue(),
                              orgName:Ext.getCmp('OrgnamecomboId').getValue(),
                              orgNameModify : orgNameModify,
                              tcNoModify : tcNoModify,
                              mineralType : Ext.getCmp('mineralId').getValue()
                          },
                          success: function(response, options) {
                              var message = response.responseText;
                              console.log(message);
                              Ext.example.msg(message);
                              Ext.getCmp('orgCodeID').reset();
       						  Ext.getCmp('OrgnamecomboId').reset();
       						  Ext.getCmp('tcNoId').reset();
       						  Ext.getCmp('plantNameID').reset();
       						  Ext.getCmp('HubLocationcomboId').reset();
       						  Ext.getCmp('mineralId').reset();
                              myWin.hide();
                              store.reload();
                              PlantMasterOuterPanelWindow.getEl().unmask();
                          },
                          failure: function() {
                              Ext.example.msg("Error");
                              Ext.getCmp('orgCodeID').reset();
       						  Ext.getCmp('OrgnamecomboId').reset();
       						  Ext.getCmp('tcNoId').reset();
       						  Ext.getCmp('plantNameID').reset();
       						  Ext.getCmp('HubLocationcomboId').reset();
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
  
  var PlantMasterOuterPanelWindow = new Ext.Panel({
      width: 500,
      height: 290,
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
      height: 350,
      width: 500,
       frame: true,
      id: 'myWin',
      items: [PlantMasterOuterPanelWindow]
  });

  function addRecord() {
  	  Ext.getCmp('OrgnamecomboId').setReadOnly(false);
  	  Ext.getCmp('tcNoId').setReadOnly(false);
  	   Ext.getCmp('mineralId').setReadOnly(false);
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
      Ext.getCmp('orgCodeID').reset();
      Ext.getCmp('OrgnamecomboId').reset();
   	  Ext.getCmp('tcNoId').reset();
      Ext.getCmp('plantNameID').reset();
      Ext.getCmp('HubLocationcomboId').reset();
      Ext.getCmp('mineralId').reset();
      TcNoComboStore.load({
            params : {
            CustId:0,
            orgid:0
            }
            });
  }

  function modifyData() {
  		  Ext.getCmp('OrgnamecomboId').setReadOnly(true);
  		  Ext.getCmp('tcNoId').setReadOnly(true);
  		   Ext.getCmp('mineralId').setReadOnly(true);
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
          titelForInnerPanel = '<%=ModifyDetails%>';
          myWin.setPosition(450,50);
          myWin.setTitle(titelForInnerPanel);
          myWin.show();
          selected = grid.getSelectionModel().getSelected();
          if(selected.get('HubIdIndex')!=0){
          Ext.getCmp('HubLocationcomboId').setValue(selected.get('HubIdIndex'));
          }else{Ext.getCmp('HubLocationcomboId').reset();}
          Ext.getCmp('orgCodeID').setValue(selected.get('OrganizationCodeIndex'));
          Ext.getCmp('OrgnamecomboId').setValue(selected.get('OrganizationNameIndex'));
          Ext.getCmp('plantNameID').setValue(selected.get('PlantNameIndex'));
          Ext.getCmp('tcNoId').setValue(selected.get('TcNoIndex'));
          Ext.getCmp('mineralId').setValue(selected.get('mineralIndex'));
          TcNoComboStore.load({
            params : {
            CustId:Ext.getCmp('custcomboId').getValue(),
            orgid: selected.get('OrgIdIndex')
            }
            });
      }
      //***************************************************************************************//
  var reader = new Ext.data.JsonReader({
      idProperty: 'MiningPlantMasterDetails',
      root: 'MiningPlantMasterRoot',
      totalProperty: 'total',
      fields: [{
          name: 'slnoIndex'
      },{
          name: 'UniqueIDIndex'
      },{
          name: 'PlantNameIndex'
      },{
          name: 'HubNameIndex'
      },{
          name: 'HubIdIndex'
      },{
          name: 'OrganizationNameIndex'
      },{
          name: 'OrganizationCodeIndex'
      },{
          name: 'TcNoIndex'
      },{
          name: 'mineralIndex'
      },{
          name: 'TotalFinesIndex'
      },{
          name: 'UsedFinesIndex'
      },{
          name: 'TotalLumpsIndex'
      },{
          name: 'UsedLumpsIndex'
      },{
          name: 'TotalRejectsIndex'
      },{
          name: 'UsedRejectsIndex'
      },{
          name: 'TotalUFOIndex'
      },{
          name: 'UsedUFOIndex'
      },{
          name: 'TotalTailingIndex'
      },{
          name: 'UsedTailingIndex'
      },{
          name: 'TotalConcentratesIndex'
      },{
          name: 'UsedConcentratesIndex'
      },{
          name: 'OrgIdIndex'
      },{
          name: 'TcIdIndex'
      }]
  });
  
  var store = new Ext.data.GroupingStore({
      autoLoad: false,
      proxy: new Ext.data.HttpProxy({
          url: '<%=request.getContextPath()%>/PlantMasterAction.do?param=getPlantMasterDetails',
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
          dataIndex: 'UniqueIDIndex'
      },{
          type: 'string',
          dataIndex: 'PlantNameIndex'
      },{
          type: 'string',
          dataIndex: 'HubNameIndex'
      },{
          type: 'string',
          dataIndex: 'OrganizationNameIndex'
      },{
          type: 'string',
          dataIndex: 'OrganizationCodeIndex'
      },{
          type: 'string',
          dataIndex: 'TcNoIndex'
      },{
          type: 'string',
          dataIndex: 'mineralIndex'
      },{
          type: 'numeric',
          dataIndex: 'TotalFinesIndex'
      },{
          type: 'numeric',
          dataIndex: 'UsedFinesIndex'
      },{
          type: 'numeric',
          dataIndex: 'TotalLumpsIndex'
      },{
          type: 'numeric',
          dataIndex: 'UsedLumpsIndex'
      },{
          type: 'numeric',
          dataIndex: 'TotalRejectsIndex'
      },{
          type: 'numeric',
          dataIndex: 'UsedRejectsIndex'
      },{
          type: 'numeric',
          dataIndex: 'TotalUFOIndex'
      },{
          type: 'numeric',
          dataIndex: 'UsedUFOIndex'
      },{
          type: 'numeric',
          dataIndex: 'TotalTailingIndex'
      },{
          type: 'numeric',
          dataIndex: 'UsedTailingIndex'
      },{
          type: 'numeric',
          dataIndex: 'TotalConcentratesIndex'
      },{
          type: 'numeric',
          dataIndex: 'UsedConcentratesIndex'
      },{
          type: 'string',
          dataIndex: 'OrgIdIndex'
      },{
          type: 'string',
          dataIndex: 'TcIdIndex'
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
          	  header: "<span style=font-weight:bold;>ID</span>",
              dataIndex: 'UniqueIDIndex',
              hidden: true,
              width: 50
          },{
              header: "<span style=font-weight:bold;><%=PlantName%></span>",
              dataIndex: 'PlantNameIndex',
              hidden: false,
              width: 150
          },{
              header: "<span style=font-weight:bold;><%=hubLocation%></span>",
              dataIndex: 'HubNameIndex',
              hidden: false,
              width: 150
          },{
          	  header: "<span style=font-weight:bold;><%=organizationName%></span>",
              dataIndex: 'OrganizationNameIndex',
              hidden: false,
              width: 150
          },{
              header: "<span style=font-weight:bold;><%=organizationCode%></span>",
              dataIndex: 'OrganizationCodeIndex',
              hidden: false,
              width: 150
              
          },{
          	  header: "<span style=font-weight:bold;><%=tcNumber%></span>",
              dataIndex: 'TcNoIndex',
              hidden: false,
              width: 100
          },{
          	  header: "<span style=font-weight:bold;>Mineral Type</span>",
              dataIndex: 'mineralIndex',
              hidden: false,
              width: 100
          },{
          	  header: "<span style=font-weight:bold;><%=totalFines%></span>",
              dataIndex: 'TotalFinesIndex',
              align: 'right',
              hidden: false,
              width: 100
          },{
          	  header: "<span style=font-weight:bold;>Used Fines</span>",
              dataIndex: 'UsedFinesIndex',
              align: 'right',
              hidden: false,
              width: 100
          },{
          	  header: "<span style=font-weight:bold;><%=totalLumps%></span>",
              dataIndex: 'TotalLumpsIndex',
              align: 'right',
              hidden: false,
              width: 110
          },{
          	  header: "<span style=font-weight:bold;>Used Lumps</span>",
              dataIndex: 'UsedLumpsIndex',
              align: 'right',
              hidden: false,
              width: 110
          },{
          	  header: "<span style=font-weight:bold;><%=totalRejects%></span>",
              dataIndex: 'TotalRejectsIndex',
              align: 'right',
              hidden: false,
              width: 110
          },{
          	  header: "<span style=font-weight:bold;>Used Rejects</span>",
              dataIndex: 'UsedRejectsIndex',
              align: 'right',
              hidden: false,
              width: 110
          },{
          	  header: "<span style=font-weight:bold;><%=totalUFO%></span>",
              dataIndex: 'TotalUFOIndex',
              align: 'right',
              hidden: false,
              width: 100
          },{
          	  header: "<span style=font-weight:bold;>Used UFO</span>",
              dataIndex: 'UsedUFOIndex',
              align: 'right',
              hidden: false,
              width: 100
          },{
          	  header: "<span style=font-weight:bold;><%=totalTailings%></span>",
              dataIndex: 'TotalTailingIndex',
              align: 'right',
              hidden: false,
              width: 100
          },{
          	  header: "<span style=font-weight:bold;>Used Tailings</span>",
              dataIndex: 'UsedTailingIndex',
              align: 'right',
              hidden: false,
              width: 100
          },{
          	  header: "<span style=font-weight:bold;><%=totalConcentrates%></span>",
              dataIndex: 'TotalConcentratesIndex',
              align: 'right',
              hidden: false,
              width: 150
          },{
          	  header: "<span style=font-weight:bold;>Used Concentrates</span>",
              dataIndex: 'UsedConcentratesIndex',
              align: 'right',
              hidden: false,
              width: 150
          },{
          	  header: "<span style=font-weight:bold;>Org Id</span>",
              dataIndex: 'OrgIdIndex',
              hidden: true,
              width: 	50
          },{
          	  header: "<span style=font-weight:bold;>Tc Id</span>",
              dataIndex: 'TcIdIndex',
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
  
  grid = getGrid('<%=plantMaster%>', '<%=NoRecordsFound%>', store, screen.width - 40, 460, 37, filters, '<%=ClearFilterData%>', false, '', 23, false, '', false, '', true, 'Excel', jspName, exportDataType, false, 'PDF', true, '<%=Add%>', true, '<%=Modify%>', false, 'Delete');
  
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
       cm.setColumnWidth(j,150);
    }
    sb = Ext.getCmp('form-statusbar');
});

  </script>
</body>
</html>
<%}%>
<%}%>
 
