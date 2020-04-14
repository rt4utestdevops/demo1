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
	     if(loginInfo.getIsLtsp()== 0)
	    {
	        addButton="true";
		    modifyButton="true";
	    }
	else if(loginInfo.getIsLtsp()== -1 && userAuthority.equalsIgnoreCase("User"))
		{
			addButton="true";
		    modifyButton="true";
	        
		}else{
		    addButton="false";
		    modifyButton="false";
	       
		}
%>

<!DOCTYPE HTML>
<html>
	<head>
		<base href="<%=basePath%>">
		<title>Lot Allocation</title>
	</head>
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
	<body>
	 <%if (loginInfo.getStyleSheetOverride().equals("Y")){%>
       <jsp:include page="../Common/ImportJSSandMining.jsp"/>
		<%}else {%>
		<jsp:include page="../Common/ImportJS.jsp" />
		<%} %>
		 <jsp:include page="../Common/ExportJS.jsp" />
 <script>
 var outerPanel;
  var jspName = "LotDetails";
  var exportDataType = "int,string,string,string,number,int,string,string";
  var grid;
  var store;
  var myWin;
  var buttonValue;
  var uniqueId;
  var OrgCode;
  var dtcur = datecur;
  var orgId;
  var myWinForChallan;
  var hubId ;
  var type;
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
                          custId: Ext.getCmp('custcomboId').getValue()
                      }
                  });
                  lotNoStore.load({
                      params: {
                      	  custId:  Ext.getCmp('custcomboId').getValue()
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
                          custId: Ext.getCmp('custcomboId').getValue()
                      }
                  });
                  lotNoStore.load({
                      params: {
                      	  custId: custId
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
      height: 40,
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

  //----------------------------------------------Plant Store --------------------------------------------//
  var lotNoStore = new Ext.data.JsonStore({
      url: '<%=request.getContextPath()%>/LotMasterAction.do?param=getLotNo',
      id: 'lotStoreId',
      root: 'lotNameRoot',
      autoLoad: false,
      remoteSort: true,
      fields: ['lotId','lotName','lotLoc','qty','hubId','type']
  });
  //----------------------------------------------Plant Combo --------------------------------------------// 
  var lotNoCombo = new Ext.form.ComboBox({
      store: lotNoStore,
      id: 'lotNoId',
      mode: 'local',
      forceSelection: true,
      emptyText: 'Select Lot NO',
      blankText: 'Select Lot No',
      resizable: true,
      selectOnFocus: true,
      allowBlank: false,
      anyMatch: true,
      typeAhead: false,
      triggerAction: 'all',
      lazyRender: true,
      valueField: 'lotId',
      displayField: 'lotName',
      cls: 'selectstylePerfect',
      listeners: {
          select: {
              fn: function() {
              	  var lotNo = Ext.getCmp('lotNoId').getValue();
                  var row = lotNoStore.find('lotId', lotNo);
                  var rec = lotNoStore.getAt(row);
                  Ext.getCmp('LotQuantityId').setValue(rec.data['qty']);
                  Ext.getCmp('lotLocId').setValue(rec.data['lotLoc']);
                  hubId=rec.data['hubId'];
                  type=rec.data['type'];
              }
          }
      }
  });
  
    //----------------------------------------------ORGANIZATION Store --------------------------------------------//
  var orgNameStore = new Ext.data.JsonStore({
      url: '<%=request.getContextPath()%>/LotMasterAction.do?param=getOrgNames',
      id: 'orgStoreId',
      root: 'orgRoot',
      autoLoad: false,
      remoteSort: true,
      fields: ['id','organizationName','organizationCode']
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
      valueField: 'id',
      displayField: 'organizationName',
      cls: 'selectstylePerfect',
      listeners: {
          select: {
              fn: function() {
              	 
              }
          }
      }
  });
  
  var innerPanelForLot = new Ext.form.FormPanel({
      standardSubmit: true,
      collapsible: false,
      autoScroll: true,
      height: 200,
      width: 480,
      frame: true,
      id: 'innerPanelForlotId',
      layout: 'table',
      resizable: true,
      layoutConfig: {
          columns: 4
      },
      items: [{
          xtype: 'fieldset',
          title: 'Lot Allocation Details',
          cls: 'fieldsetpanel',
          collapsible: false,
          autoScroll: true,
          colspan: 3,
          id: 'lotDetailsid',
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
              id: 'lotEmptyId'
          }, {
              xtype: 'label',
              text: 'lot No' + ' :',
              cls: 'labelstyle',
              id: 'lotNoLabelId'
          }, lotNoCombo, {
              xtype: 'label',
              text: '*',
              cls: 'mandatoryfield',
              id: 'lotLocEmptyId'
          }, {
              xtype: 'label',
              text: 'Lot Location' + ' :',
              cls: 'labelstyle',
              id: 'lotLocLabelId'
          }, {
              xtype: 'textfield',
              cls: 'selectstylePerfect',
              blankText: '',
              emptyText: '',
              labelSeparator: '',
              allowBlank: true,
              readOnly: true,
              id: 'lotLocId'
          }, {
              xtype: 'label',
              text: '*',
              cls: 'mandatoryfield',
              id: 'orgEmptyId'
          }, {
              xtype: 'label',
              text: 'Organization Name' + ' :',
              cls: 'labelstyle',
              id: 'orgLabelId'
          }, orgNameCombo,
          {
              xtype: 'label',
              text: '*',
              cls: 'mandatoryfield',
              id: 'lotQuantityEmptyId'
          }, {
              xtype: 'label',
              text: 'Lot Quantity(tons)' + ' :',
              cls: 'labelstyle',
              id: 'lotQuantityLabelId'
          }, {
              xtype: 'numberfield',
              cls: 'selectstylePerfect',
              allowNegative: false,
              labelSeparator: '',
              allowBlank: false,
              readOnly:true,
              id: 'LotQuantityId'
          }, {
              xtype: 'label',
              text: '*',
              cls: 'mandatoryfield',
              id: 'quantityEmptyId'
          }, {
              xtype: 'label',
              text: 'Quantity (tons)' + ' :',
              cls: 'labelstyle',
              id: 'quantityLabelId'
          }, {
              xtype: 'numberfield',
              cls: 'selectstylePerfect',
              blankText: 'Enter Quantity',
              emptyText: 'Enter Quantity',
              allowNegative: false,
              labelSeparator: '',
              allowBlank: false,
              allowNegative: false,
              listeners:{ change: function(f, n, o){ f.setValue(Math.abs(n)); } },
              autoCreate: {
                     tag: "input",
                     maxlength: 9,
                     autocomplete: "off"
                 },
              id: 'quantityId'
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
                      if (Ext.getCmp('lotNoId').getValue() == "") {
                          Ext.example.msg("Select LotNo");
                          Ext.getCmp('lotNoId').focus();
                          return;
                      }
                      if (Ext.getCmp('orgComboId').getValue() == "") {
                      	  Ext.example.msg("Select Organization Name");
                          Ext.getCmp('orgComboId').focus();
                          return;
                      }
                      if (Ext.getCmp('quantityId').getValue() == "") {
                          Ext.example.msg("Enter Quantity");
                          Ext.getCmp('quantityId').focus();
                          return;
                      }
                      var Qty = Ext.getCmp('quantityId').getValue();
                      var convertedQty = parseFloat(Qty);
                      var bal = Ext.getCmp('LotQuantityId').getValue();
                      if (convertedQty > bal) {
                          Ext.example.msg("Quantity is greater than the Lot qty");
                          Ext.getCmp('quantityId').reset();
                          Ext.getCmp('quantityId').focus();
                          return;
                      }

                       lotPanelWindow.getEl().mask();
                      Ext.Ajax.request({
                          url: '<%=request.getContextPath()%>/LotMasterAction.do?param=addLotDetails',
                          method: 'POST',
                          params: {
                              custId: Ext.getCmp('custcomboId').getValue(),
                              custName: Ext.getCmp('custcomboId').getRawValue(),
                              lotNo: Ext.getCmp('lotNoId').getValue(),
                              orgId: Ext.getCmp('orgComboId').getValue(),
                              quantity: Ext.getCmp('quantityId').getValue(),
                              lotLoc : hubId,
                              type : type
                          },
                          success: function(response, options) {
                              var message = response.responseText;
                              Ext.example.msg(message);
                              Ext.getCmp('lotNoId').reset();
                              Ext.getCmp('orgComboId').reset();
                              Ext.getCmp('quantityId').reset();
                              myWin.hide();
                              store.reload();
                              lotPanelWindow.getEl().unmask();
                              lotNoStore.load({
			                      params: {
			                      	  custId:  Ext.getCmp('custcomboId').getValue()
			                      }
			                  });
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
  
  var lotPanelWindow = new Ext.Panel({
      width: 490,
      height: 300,
      standardSubmit: true,
      frame: true,
      items: [innerPanelForLot, innerWinButtonPanel]
  });

  myWin = new Ext.Window({
      title: 'titelForInnerPanel',
      closable: false,
      resizable: false,
      modal: true,
      autoScroll: false,
      height: 300,
      width: 500,
      frame: true,
      id: 'myWin',
      items: [lotPanelWindow]
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
                     id = selected.get('uidIndex');
                     Ext.Ajax.request({
                         url: '<%=request.getContextPath()%>/LotMasterAction.do?param=cancelLotDetails',
                         method: 'POST',
                         params: {
                             id: id,
                             CustID: Ext.getCmp('custcomboId').getValue(),
                             remark: Ext.getCmp('remark').getValue(),
                             orgId: selected.get('orgIdIndex') ,
                             quantity: selected.get('quantityIndex'),
                             lotLoc: selected.get('lotLocIdIndex'),
                             type: selected.get('typeIndex'),
                         },
                         success: function(response, options) {
                             var message = response.responseText;
                             Ext.example.msg(message);
                             cancelWin.getEl().unmask();
                             store.reload();
                             cancelWin.hide();
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
      titelForInnerPanel = 'Add Lot Details';
      myWin.setPosition(450, 60);
      myWin.show();
      myWin.setTitle(titelForInnerPanel);
      Ext.getCmp('orgComboId').reset();
      Ext.getCmp('quantityId').reset();
      Ext.getCmp('lotNoId').reset();
      lotNoStore.load({
           params: {
           	  custId:  Ext.getCmp('custcomboId').getValue()
           }
       });
  }

  //***************************************************************************************//
  var reader = new Ext.data.JsonReader({
      idProperty: 'lotDetails',
      root: 'lotDetailsRoot',
      totalProperty: 'total',
      fields: [{
          name: 'slnoIndex'
      }, {
          name: 'lotNoIndex'
      }, {
          name: 'lotLocIndex'
      }, {
          name: 'organizationNameIndex'
      }, {
          name: 'quantityIndex'
      }, {
      	  name: 'uidIndex'
      }, {
      	  name: 'lotLocIdIndex'
      }, {
      	  name: 'orgIdIndex'
      }, {
      	  name: 'typeIndex'
      }, {
      	  name: 'statusIndex'
      }, {
      	  name: 'remarksIndex'
      }]
  });

  store = new Ext.data.GroupingStore({
      autoLoad: false,
      proxy: new Ext.data.HttpProxy({
          url: '<%=request.getContextPath()%>/LotMasterAction.do?param=getLotDetails',
          method: 'POST'
      }),
      remoteSort: false,
      storeId: 'lotDetailsStore',
      reader: reader
  });

  var filters = new Ext.ux.grid.GridFilters({
      local: true,
      filters: [{
          type: 'numeric',
          dataIndex: 'slnoIndex'
      }, {
          type: 'string',
          dataIndex: 'lotNoIndex'
      }, {
          type: 'string',
          dataIndex: 'lotLocIndex'
      },{
          type: 'string',
          dataIndex: 'organizationNameIndex'
      },{
          type: 'numeric',
          dataIndex: 'quantityIndex'
      },{
          type: 'string',
          dataIndex: 'statusIndex'
      },{
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
          }, {
              dataIndex: 'lotNoIndex',
              header: "<span style=font-weight:bold;>Lot No</span>"
          }, {
              dataIndex: 'lotLocIndex',
              header: "<span style=font-weight:bold;>Lot Location</span>"
          }, {
              dataIndex: 'organizationNameIndex',
              header: "<span style=font-weight:bold;>Organization Name</span>"
          }, {
              dataIndex: 'quantityIndex',
              align: 'right',
              header: "<span style=font-weight:bold;>Quantity</span>"
          }, {
          	  dataIndex: 'uidIndex',
          	  hidden: true,
          	  header: "ID"
          }, {
             header: "<span style=font-weight:bold;>Status</span>",
             dataIndex: 'statusIndex'
         }, {
             header: "<span style=font-weight:bold;>Remarks</span>",
             dataIndex: 'remarksIndex'
         }
      ];
      return new Ext.grid.ColumnModel({
          columns: columns.slice(start || 0, finish),
          defaults: {
              sortable: true
          }
      });
  };

  grid = getGrid('Lot Details', '<%=NoRecordsFound%>', store, screen.width - 40, 440,37, filters, 'Clear Filter Data', false, '', 23, false, '', false, '', true, 'Excel', jspName, exportDataType, false, 'PDF', true, 'Add', false, '', true, 'Cancel', false, '', false, 'Destination Weight', false, 'Close Trip',false,'',false,'',false,'',false,'Import PO Qty');

     
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
          cm.setColumnWidth(j, 300);
      }
      sb = Ext.getCmp('form-statusbar');
  });

 </script>
</body>
</html>
<%}%>

 
