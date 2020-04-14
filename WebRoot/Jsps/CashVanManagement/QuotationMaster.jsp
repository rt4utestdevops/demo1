<%@ page  language="java" import="java.util.*,java.text.SimpleDateFormat,t4u.functions.*,t4u.beans.*,t4u.common.*" pageEncoding="utf-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";

    LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
	String language = loginInfo.getLanguage();
	int systemId = loginInfo.getSystemId();
	int customerId = loginInfo.getCustomerId();
    int countryId = loginInfo.getCountryCode();
    CommonFunctions cf = new CommonFunctions();
	cf.checkLoginInfo((LoginInfoBean) session.getAttribute("loginInfoDetails"), session, request, response);
	String responseaftersubmit="''";
	String feature="1";
	if(session.getAttribute("responseaftersubmit")!=null){
	   responseaftersubmit="'"+session.getAttribute("responseaftersubmit").toString()+"'";
		session.setAttribute("responseaftersubmit",null);
	}

	ArrayList<String> tobeConverted = new ArrayList<String>();

tobeConverted.add("Status");
tobeConverted.add("Select_Customer_Name");
tobeConverted.add("Save");
tobeConverted.add("Customer_Name");
tobeConverted.add("Cancel");
tobeConverted.add("Add");
tobeConverted.add("Delete");
tobeConverted.add("Modify");
tobeConverted.add("Modify_Details");
tobeConverted.add("SLNO");
tobeConverted.add("No_Records_Found");
tobeConverted.add("Clear_Filter_Data");
tobeConverted.add("Excel");

ArrayList<String> convertedWords = new ArrayList<String>();
convertedWords = cf.getLanguageSpecificWordForKey(tobeConverted,language);

String Status=convertedWords.get(0);
String SelectCustomerName=convertedWords.get(1);
String Save=convertedWords.get(2);
String Customer_Name = convertedWords.get(3);
String Cancel = convertedWords.get(4);
String Add = convertedWords.get(5);
String Delete = convertedWords.get(6);
String Modify = convertedWords.get(7);
String ModifyDetails = convertedWords.get(8); 
String SLNO = convertedWords.get(9);
String NoRecordsFound = convertedWords.get(10);
String ClearFilterData = convertedWords.get(11);
String Excel = convertedWords.get(12);

%>

<!DOCTYPE HTML>
<html>
 <head>
 		<title>Quotation_Master</title>		
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
	<%}else {%>
	<jsp:include page="../Common/ImportJS.jsp" />
   <%} %>
   <jsp:include page="../Common/ExportJS.jsp" />
   <script>
 
 
  var uploadFileFlag = false;
  var systemId = '<%=systemId%>';
  var buttonValue3;
  var quotationNo2;
  var validFrom2;
  var validTo2;
  var location2;
  var quoteFor2;
  var customer2;
  var quotationCustId;
  var tariffType2;
  var uploadedFile2;
  var tariffAmt2;
  var systemQuoteNo2;
  var custId = '<%=customerId%>';
  var buttonvalue2;
  var quotationId;
  var systemQuotationId;
  var quotationName;
  var titelForInnerPanel2 = "Quotation Details";


  function viewAttacment() {
   var selectedRow = grid.getSelectionModel().getSelected();

   systemQuotationId = selectedRow.get('synsQuotationNoIndex');
   quotationName = selectedRow.get('quotationDataIndex');


   window.open('<%=request.getContextPath()%>/QuotationMasterExcel?systemQuotationId=' + systemQuotationId + '&clientId=' + custId + '&systemId=' + systemId + '');


  }

  function viewRevisionFunction() {

   if (grid.getSelectionModel().getCount() == 0) {
    Ext.example.msg("No Rows Selected");
    return;
   }
   if (grid.getSelectionModel().getCount() > 1) {
    Ext.example.msg("Select Single Row");
    return;
   }

   var selected = grid.getSelectionModel().getSelected();

   var quotationIdForRevision = selected.get('synsQuotationNoIndex');
   var quotationNameForRevision = selected.get('quotationDataIndex');
   var revisionCount = selected.get('RevisionCountDataIndex');
   if (revisionCount == 0) {
    Ext.example.msg("This Quotation Hasn't Revised!!");
    return;

   }
   if (revisionCount != 0) {
    var title = "Quotation -" + quotationNameForRevision + " (" + quotationIdForRevision + ")";
    quotationMasterPopupAdd2.setTitle(title);
    revisionWindow.show();

    store2.load({
     params: {
      CustId: custId,
      QuotationId: quotationIdForRevision
     }
    });
   }
  }


  function approveFunction() {
   if (grid.getSelectionModel().getCount() == 0) {
    Ext.example.msg("NoRowsSelected");
    return;
   }
   if (grid.getSelectionModel().getCount() > 1) {
    Ext.example.msg("SelectSingleRow");
    return;
   }
   myWin2.setPosition(450, 50);
   myWin2.setTitle(titelForInnerPanel2);
   myWin2.show();
   Ext.getCmp('RejectButtId').enable();
   Ext.getCmp('approveButtonId').enable();
   Ext.getCmp('reasoncomboId').reset();
   var selected = grid.getSelectionModel().getSelected();

   quotationId = selected.get('synsQuotationNoIndex');
   Ext.getCmp('SystemGeneratedQuotationNoIdValue').setText(selected.get('synsQuotationNoIndex'));
   Ext.getCmp('QuotationNoIdValue').setText(selected.get('quotationDataIndex'));
   Ext.getCmp('ValidFromIdValue').setText(selected.get('validFromDataIndex'));
   Ext.getCmp('ValidToIdValue').setText(selected.get('validToIndex'));
   Ext.getCmp('LocationIdValue').setText(selected.get('locationIndex'));
   Ext.getCmp('QuoteForIdValue').setText(selected.get('quotForIndex'));
   Ext.getCmp('CustomerIdValue').setText(selected.get('typeIndex'));
   Ext.getCmp('TarrifTypeIdValue').setText(selected.get('tariffTypeIndex'));
   Ext.getCmp('TariffAmountIdValue').setText(selected.get('tariffAmountIndex'));
  }




  function rejectOrApprove() {
   if (Ext.getCmp('reasoncomboId').getValue() == "") {
    Ext.example.msg("Please Select Reason");
    return;
   }

   Ext.Ajax.request({
    url: '<%=request.getContextPath()%>/QuotationMasterHistoryAction.do?param=ApproveOrReject',
    method: 'POST',
    params: {
     custId: custId,
     buttonValue: buttonvalue2,
     quotationId: quotationId,
     statusType: Ext.getCmp('reasoncomboId').getValue(),
     reason:Ext.getCmp('ReasonTextArea1').getValue()
    },
    success: function(response, options) {
     var message = response.responseText;
     Ext.example.msg(message);
Ext.getCmp('ReasonTextArea1').reset();
Ext.getCmp('reasoncomboId').reset();
 	Ext.getCmp('ReasonTextArea1').hide();
      Ext.getCmp('RejectButtId').disable();
      Ext.getCmp('approveButtonId').enable();
            Ext.getCmp('ReasonTextAreaLabel1').hide();
     myWin2.hide();
     store.load({
      params: {
       CustId: custId
      }
     });
     outerPanel.getEl().unmask();

    },
    failure: function() {
     Ext.example.msg("Error");
     store.load({
      params: {
       CustId: custId
      }
     });
     myWin2.hide();
     outerPanel.getEl().unmask();
    }
   });

  }


  var reasoncombostore = new Ext.data.SimpleStore({
   id: 'reasoncombostoreId',
   autoLoad: true,
   fields: ['Name', 'Value'],
   data: [
    ['CONFIRMED', 'CONFIRMED'],
    ['OTHERS', 'OTHERS']
   ]
  });

  var reasoncombo = new Ext.form.ComboBox({
   store: reasoncombostore,
   id: 'reasoncomboId',
   mode: 'local',
   forceSelection: true,
   selectOnFocus: true,
   allowBlank: false,
   anyMatch: true,
   emptyText: 'Select Reason',
   blankText: 'Select Reason',
   typeAhead: false,
   triggerAction: 'all',
   lazyRender: true,
   valueField: 'Value',
   value: '',
   displayField: 'Name',
   cls: 'selectstylePerfect',
   listeners: {
    select: {
    	fn:function() {
     	if (Ext.getCmp('reasoncomboId').getValue() == 'CONFIRMED') {
     	Ext.getCmp('ReasonTextArea1').hide();
      Ext.getCmp('RejectButtId').disable();
      Ext.getCmp('approveButtonId').enable();
            Ext.getCmp('ReasonTextAreaLabel1').hide();

     } else if (Ext.getCmp('reasoncomboId').getValue() == 'OTHERS') {
      Ext.getCmp('RejectButtId').enable();
      Ext.getCmp('approveButtonId').disable();
      Ext.getCmp('ReasonTextAreaLabel1').show();
      Ext.getCmp('ReasonTextArea1').show();
     }
    	
    }
    }
   }


  });

  var innerPanelForQuotationMasterDetails = new Ext.form.FormPanel({
   standardSubmit: false,
   collapsible: false,
   autoScroll: true,
   autoHeight: true,
   width: 400,
   frame: false,
   id: 'innerPanelForCustomerMasterDetailsId',
   layout: 'table',
   layoutConfig: {
    columns: 4
   },
   items: [{
    xtype: 'fieldset',
    title: 'Quotation Details',
    cls: 'fieldsetpanel',
    collapsible: false,
    colspan: 4,
    id: 'QuotationDetailsIdId',
    width: 360,
    layout: 'table',
    layoutConfig: {
     columns: 4
    },
    items: [

     {
      xtype: 'label',
      text: 'Quotation ID' + ' :',
      cls: 'labelstyle',
      id: 'SystemGeneratedQuotationNoId'
     }, {
      xtype: 'label',
      text: '',
      cls: 'labelstyle',
      id: 'SystemGeneratedQuotationNoIdValue'
     },

     {}, {}, {
      xtype: 'label',
      text: '',
      cls: 'labelstyle',
      id: 'emptylabel1'
     }, {
      xtype: 'label',
      text: '',
      cls: 'labelstyle',
      id: 'emptylabel2'
     }, {
      xtype: 'label',
      text: '',
      cls: 'labelstyle',
      id: 'emptylabel3'
     }, {
      xtype: 'label',
      text: '',
      cls: 'labelstyle',
      id: 'emptylabel4'
     }, {
      xtype: 'label',
      text: 'Quotation No' + ' :',
      cls: 'labelstyle',
      id: 'QuotationNoId'
     }, {
      xtype: 'label',
      text: '',
      cls: 'labelstyle',
      id: 'QuotationNoIdValue'
     }, {},

     {}, {
      xtype: 'label',
      text: '',
      cls: 'labelstyle',
      id: 'emptylabel5'
     }, {
      xtype: 'label',
      text: '',
      cls: 'labelstyle',
      id: 'emptylabel6'
     }, {
      xtype: 'label',
      text: '',
      cls: 'labelstyle',
      id: 'emptylabel7'
     }, {
      xtype: 'label',
      text: '',
      cls: 'labelstyle',
      id: 'emptylabel8'
     },

     {
      xtype: 'label',
      text: 'Valid From' + ' :',
      cls: 'labelstyle',
      id: 'ValidFromId'
     }, {
      xtype: 'label',
      text: '',
      cls: 'labelstyle',
      id: 'ValidFromIdValue'
     }, {}, {},

     {
      xtype: 'label',
      text: '',
      cls: 'labelstyle',
      id: 'emptylabel9'
     }, {
      xtype: 'label',
      text: '',
      cls: 'labelstyle',
      id: 'emptylabel10'
     }, {
      xtype: 'label',
      text: '',
      cls: 'labelstyle',
      id: 'emptylabel11'
     }, {
      xtype: 'label',
      text: '',
      cls: 'labelstyle',
      id: 'emptylabel12'
     }, {
      xtype: 'label',
      text: 'Valid To' + ' :',
      cls: 'labelstyle',
      id: 'ValidToId'
     }, {
      xtype: 'label',
      text: '',
      cls: 'labelstyle',
      id: 'ValidToIdValue'
     }, {}, {}, {
      xtype: 'label',
      text: '',
      cls: 'labelstyle',
      id: 'emptylabel13'
     }, {
      xtype: 'label',
      text: '',
      cls: 'labelstyle',
      id: 'emptylabel14'
     }, {
      xtype: 'label',
      text: '',
      cls: 'labelstyle',
      id: 'emptylabel15'
     }, {
      xtype: 'label',
      text: '',
      cls: 'labelstyle',
      id: 'emptylabel16'
     }, {
      xtype: 'label',
      text: 'Location' + ' :',
      cls: 'labelstyle',
      id: 'LocationId'
     }, {
      xtype: 'label',
      text: '',
      cls: 'labelstyle',
      id: 'LocationIdValue'
     }, {}, {},

     {
      xtype: 'label',
      text: '',
      cls: 'labelstyle',
      id: 'emptylabel17'
     }, {
      xtype: 'label',
      text: '',
      cls: 'labelstyle',
      id: 'emptylabel18'
     }, {
      xtype: 'label',
      text: '',
      cls: 'labelstyle',
      id: 'emptylabel19'
     }, {
      xtype: 'label',
      text: '',
      cls: 'labelstyle',
      id: 'emptylabel20'
     },

     {
      xtype: 'label',
      text: 'Quote For' + ' :',
      cls: 'labelstyle',
      id: 'QuoteForId'
     }, {
      xtype: 'label',
      text: '',
      cls: 'labelstyle',
      id: 'QuoteForIdValue'
     }, {}, {},

     {
      xtype: 'label',
      text: '',
      cls: 'labelstyle',
      id: 'emptylabel21'
     }, {
      xtype: 'label',
      text: '',
      cls: 'labelstyle',
      id: 'emptylabel22'
     }, {
      xtype: 'label',
      text: '',
      cls: 'labelstyle',
      id: 'emptylabel23'
     }, {
      xtype: 'label',
      text: '',
      cls: 'labelstyle',
      id: 'emptylabel24'
     },

     {
      xtype: 'label',
      text: 'Customer' + ' :',
      cls: 'labelstyle',
      id: 'CustomerId'
     }, {
      xtype: 'label',
      text: '',
      cls: 'labelstyle',
      id: 'CustomerIdValue'
     }, {}, {},

     {
      xtype: 'label',
      text: '',
      cls: 'labelstyle',
      id: 'emptylabel25'
     }, {
      xtype: 'label',
      text: '',
      cls: 'labelstyle',
      id: 'emptylabel26'
     }, {
      xtype: 'label',
      text: '',
      cls: 'labelstyle',
      id: 'emptylabel27'
     }, {
      xtype: 'label',
      text: '',
      cls: 'labelstyle',
      id: 'emptylabel28'
     },

     {
      xtype: 'label',
      text: 'Tarrif Type' + ' :',
      cls: 'labelstyle',
      id: 'TarrifTypeId'
     }, {
      xtype: 'label',
      text: '',
      cls: 'labelstyle',
      id: 'TarrifTypeIdValue'
     }, {}, {},

     {
      xtype: 'label',
      text: '',
      cls: 'labelstyle',
      id: 'emptylabel29'
     }, {
      xtype: 'label',
      text: '',
      cls: 'labelstyle',
      id: 'emptylabel30'
     }, {
      xtype: 'label',
      text: '',
      cls: 'labelstyle',
      id: 'emptylabel31'
     }, {
      xtype: 'label',
      text: '',
      cls: 'labelstyle',
      id: 'emptylabel32'
     },

     {
      xtype: 'label',
      text: 'Tariff Amount' + ' :',
      cls: 'labelstyle',
      id: 'TariffAmountId'
     }, {
      xtype: 'label',
      text: '',
      cls: 'labelstyle',
      id: 'TariffAmountIdValue'
     }, {}, {}, {
      xtype: 'label',
      text: '',
      cls: 'labelstyle',
      id: 'emptylabel33'
     }, {
      xtype: 'label',
      text: '',
      cls: 'labelstyle',
      id: 'emptylabel34'
     }, {
      xtype: 'label',
      text: '',
      cls: 'labelstyle',
      id: 'emptylabel35'
     }, {
      xtype: 'label',
      text: '',
      cls: 'labelstyle',
      id: 'emptylabel36'
     }



    ]
   }]
  });
  var innerrWinButtonPanel = new Ext.Panel({
   id: 'innerrWinButtonPanelId2',
   standardSubmit: true,
   collapsible: false,
   autoHeight: true,
   height: 100,
   width: 400,
   frame: false,
   layout: 'table',
   layoutConfig: {
    columns: 4
   },
   items: [{
     xtype: 'label',
     text: '*',
     cls: 'mandatoryfield',
     id: 'id1'
    }, {
     xtype: 'label',
     text: 'Select Reason',
     cls: 'labelstyle',
     id: 'SelectReasonIdValue'
    },
    reasoncombo, {},
    {
     xtype: 'label',
     text: ' '+' ',
     cls: 'labelstyle',
     id: 'id2'
    }, {
     xtype: 'label',
     text: 'Comment  ',
     cls: 'labelstyle',
     id: 'ReasonTextAreaLabel1',
     hidden:true,
    },
    {
    xtype:'textarea',
    hidden:true,
    width:170,
    height:37,
     id: 'ReasonTextArea1',
    }, {}
   ]
  });
  var innerWinButtonPanel = new Ext.Panel({
   id: 'innerWinButtonPanelId2',
   standardSubmit: true,
   collapsible: false,
   autoHeight: true,
   height: 100,
   width: 400,
   frame: false,
   layout: 'table',
   layoutConfig: {
    columns: 4
   },
   buttons: [{

    xtype: 'button',
    text: 'View Attachment',
    id: 'ViewtButtId',
    cls: 'buttonstyle',
    iconCls: 'searchbutton',
    width: 70,
    listeners: {
     click: {
      fn: function() {
       viewAttacment();
      }
     }
    }

   }, {
    xtype: 'button',
    text: 'Approve',
    id: 'approveButtonId',
    cls: 'buttonstyle',
    iconCls: 'validatebutton',
    width: 70,
    listeners: {
     click: {
      fn: function() {
       buttonvalue2 = 'APPROVED';
       rejectOrApprove();


      }
     }
    }
   }, {
    xtype: 'button',
    text: 'Reject',
    id: 'RejectButtId',
    cls: 'buttonstyle',
    iconCls: 'nobutton',
    width: 70,
    listeners: {
     click: {
      fn: function() {
       buttonvalue2 = 'REJECTED';
       rejectOrApprove();

      }
     }
    }
   }, {
    xtype: 'button',
    text: 'Cancel',
    id: 'canButtId2',
    cls: 'buttonstyle',
    iconCls: 'cancelbutton',
    width: 70,
    listeners: {
     click: {
      fn: function() {
       myWin2.hide();
      }
     }
    }
   }]
  });

  var RejectOrApproveOuterPanelWindow = new Ext.Panel({
   width: 430,
   autoHeight: true,
   height: 400,
   standardSubmit: true,
   frame: true,
   items: [innerPanelForQuotationMasterDetails, innerrWinButtonPanel, innerWinButtonPanel]
  });

  var myWin2 = new Ext.Window({
   title: titelForInnerPanel2,
   closable: false,
   resizable: false,
   modal: true,
   autoScroll: false,
   autoHeight: true,
   height: 450,
   width: 430,
   id: 'myWin2',
   items: [RejectOrApproveOuterPanelWindow]
  });




  var locationcombostore = new Ext.data.JsonStore({
   autoLoad: true,
   url: '<%=request.getContextPath()%>/quoteFor.do?param=location',
   id: 'locationcombostoreId',

   fields: ['value', 'name'],

  });

  var chooseCustomercombostore = new Ext.data.JsonStore({
   url: '<%=request.getContextPath()%>/CustomerMasterAction.do?param=customer',
   id: 'chooseCustomercombostoreId',
   autoLoad: true,
   fields: ['value', 'name']
  });

  var locationcombo = new Ext.form.ComboBox({
   store: locationcombostore,
   id: 'locationcomboId',
   mode: 'local',
   forceSelection: true,
   selectOnFocus: true,
   allowBlank: false,
   anyMatch: true,
   emptyText: 'Select Location',
   blankText: 'Select Location',
   typeAhead: false,
   triggerAction: 'all',
   lazyRender: true,
   valueField: 'name',
   displayField: 'name',
   cls: 'selectstylePerfect',
   listeners: {
    'change': function(field, selectedValue) {

     chooseCustomercombostore.load({
      params: {
       location: selectedValue,
       CustId: '<%= customerId %>'

      }
     });
    }
   }
  });


  var quoteForcombostore = new Ext.data.SimpleStore({
   id: 'quoteForcombostoreId',
   autoLoad: true,

   fields: ['Name', 'Value'],

   data: [
    ['Cash Transport', 'Cash Transport'],
    ['ATM Operations', 'ATM Operations'],
    ['Cashier', 'Cashier'],
    ['Armed  Guard Duties', 'Armed  Guard Duties'],
    ['Pay Packeting', 'Pay Packeting'],
    ['Security Storage', 'Security Storage'],
    ['Sorting', 'Sorting'],
    ['Cash Management', 'Cash Management']
   ]

  });

  var quoteForcombo = new Ext.form.ComboBox({
   store: quoteForcombostore,
   id: 'quoteForcomboId',
   mode: 'local',
   forceSelection: true,
   selectOnFocus: true,
   allowBlank: false,
   anyMatch: true,
   emptyText: 'Select Quote For',
   blankText: 'Select Quote For',

   typeAhead: false,
   triggerAction: 'all',
   lazyRender: true,
   valueField: 'Value',

   displayField: 'Name',
   cls: 'selectstylePerfect'
  });



  var chooseCustomercombo = new Ext.form.ComboBox({
   store: chooseCustomercombostore,
   id: 'chooseCustomerId',
   mode: 'local',
   forceSelection: true,
   selectOnFocus: true,
   allowBlank: false,
   anyMatch: true,
   emptyText: 'Select Customer',
   blankText: 'Select Customer',
   typeAhead: false,
   triggerAction: 'all',
   lazyRender: true,
   valueField: 'value',

   displayField: 'name',
   cls: 'selectstylePerfect'
  });

  var tariffTypecombostore = new Ext.data.SimpleStore({
   id: 'tariffTypecombostoreId',
   autoLoad: true,
   fields: ['Name', 'Value'],
   data: [
    ['Fixed', 'Fixed'],
    ['Per Transaction', 'Per Transaction'],

   ]
  });

  var tariffTypecombo = new Ext.form.ComboBox({
   store: tariffTypecombostore,
   id: 'tariffTypecomboId',
   mode: 'local',
      forceSelection: true,
   selectOnFocus: true,
   allowBlank: false,
   anyMatch: true,
   emptyText: 'Select Tariff Type',
   blankText: 'Select Tariff Type',
   typeAhead: false,
   triggerAction: 'all',
   lazyRender: true,
   valueField: 'Value',
   displayField: 'Name',
   cls: 'selectstylePerfect'
  });


  /*************************************************************/

  var reader = new Ext.data.JsonReader({
   idProperty: 'ownMasterid',
   root: 'quotationMasterRoot',
   totalProperty: 'total',
   fields: [{
    name: 'slnoIndex'
   }, {
    name: 'quotationDataIndex'
   }, {
    name: 'validFromDataIndex'
   }, {
    name: 'validToIndex'
   }, {
    name: 'locationIndex'
   }, {
    name: 'quotForIndex'
   }, {
    name: 'typeIndex'
   }, {
    name: 'tariffTypeIndex'
   }, {
    name: 'tariffAmountIndex'
   }, {
    name: 'synsQuotationNoIndex'
   }, {
    name: 'uploadedFileIndex'
   }, {
    name: 'RevisionCountDataIndex'
   },{
     name: 'typeIdIndex2'
    }]
  });

  var store = new Ext.data.GroupingStore({
   autoLoad: false,
   proxy: new Ext.data.HttpProxy({
    url: '<%=request.getContextPath()%>/quoteFor.do?param=getData',
    method: 'POST'
   }),
   storeId: "gridStroreId",
   reader: reader
  });
  var filters = new Ext.ux.grid.GridFilters({
   local: true,
   filters: [{
    type: 'numeric',
    dataIndex: 'slnoIndex'
   }, {
    type: 'string',
    dataIndex: 'quotationDataIndex'
   }, {
    type: 'date',
    dataIndex: 'validFromDataIndex'
   }, {
    type: 'date',
    dataIndex: 'validToIndex'
   }, {
    type: 'string',
    dataIndex: 'locationIndex'
   }, {
    type: 'string',
    dataIndex: 'typeIndex'
   }, {
    type: 'string',
    dataIndex: 'tariffTypeIndex'
   }, {
    type: 'string',
    dataIndex: 'synsQuotationNoIndex'
   }, {
    type: 'string',
    dataIndex: 'quotForIndex'
   }, {
    type: 'numeric',
    dataIndex: 'tariffAmountIndex'
   }, {
    type: 'string',
    dataIndex: 'uploadedFileIndex'
   }, {
    type: 'numeric',
    dataIndex: 'RevisionCountDataIndex'
   }]
  });

  var createColModel = function(finish, start) {
   var columns = [
    new Ext.grid.RowNumberer({
     header: "<span style=font-weight:bold;>SLNO</span>",
     width: 50
    }), {
     dataIndex: 'slnoIndex',
     hidden: true,
     header: "<span style=font-weight:bold;>SLNO</span>",
     filter: {
      type: 'numeric'
     }
    }, {
     header: "<span style=font-weight:bold;>Quotation No.</span>",
     dataIndex: 'quotationDataIndex',

     width: 160,
     filter: {
      type: 'string'
     }
    }, {
     header: "<span style=font-weight:bold;>Valid From</span>",
     dataIndex: 'validFromDataIndex',
     width: 160,
     filter: {
      type: 'date'
     }
    }, {
     header: "<span style=font-weight:bold;>Valid To</span>",
     dataIndex: 'validToIndex',
     width: 160,
     filter: {
      type: 'date'
     }
    }, {
     header: "<span style=font-weight:bold;>location</span>",
     dataIndex: 'locationIndex',
     width: 160,
     filter: {
      type: 'string'
     }
    }, {
     header: "<span style=font-weight:bold;>Quote For</span>",
     dataIndex: 'quotForIndex',
     width: 160,
     filter: {
      type: 'string'
     }
    }, {
     header: "<span style=font-weight:bold;>Type</span>",
     dataIndex: 'typeIndex',
     width: 160,
     filter: {
      type: 'string'
     }
    }, {
     header: "<span style=font-weight:bold;>Tariff Type</span>",
     dataIndex: 'tariffTypeIndex',
     width: 160,
     filter: {
      type: 'string'
     }
    }, {
     header: "<span style=font-weight:bold;>Tariff Amount</span>",
     dataIndex: 'tariffAmountIndex',
     width: 160,
     filter: {
      type: 'numeric'
     }
    }, {
     header: "<span style=font-weight:bold;>Sys Quotation No.</span>",
     dataIndex: 'synsQuotationNoIndex',
     width: 160,
     filter: {
      type: 'string'
     }
    }, {
     header: "<span style=font-weight:bold;>Uploaded File Path</span>",
     dataIndex: 'uploadedFileIndex',
     width: 160,
     hidden: true,
     filter: {
      type: 'string'
     }
    }, {
     header: "<span style=font-weight:bold;>Revision No</span>",
     dataIndex: 'RevisionCountDataIndex',
     width: 100,
     hidden: false,
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

  var reader2 = new Ext.data.JsonReader({
   idProperty: 'ownMasterid2',
   root: 'quotationRevisionMasterRoot',
   totalProperty: 'total',

   fields: [{
     name: 'slnoIndex2'
    }, {
     name: 'validFromDataIndex2'
    }, {
     name: 'validToIndex2'
    },{
        name: 'QuotationStatusDataIndex2'
    },{
        name: 'StatusTypeDataIndex2'
    }, {
     name: 'locationIndex2'
    }, {
     name: 'quotForIndex2'
    }, {
     name: 'typeIndex2'
    }, {
     name: 'tariffTypeIndex2'
    }, {
     name: 'tariffAmountIndex2'
    }

   ]
  });

  var store2 = new Ext.data.GroupingStore({
   autoLoad: false,
   proxy: new Ext.data.HttpProxy({
    url: '<%=request.getContextPath()%>/quoteFor.do?param=getRevisionData',
    method: 'POST'
   }),
   storeId: 'revisionStoreId',
   reader: reader2
  });


  var createColModel2 = new Ext.grid.ColumnModel({
   columns: [
    new Ext.grid.RowNumberer({
     header: "<span style=font-weight:bold;>SLNO</span>",
     width: 50
    }), {
     dataIndex: 'slnoIndex2',
     hidden: true,
     header: "<span style=font-weight:bold;>SLNO</span>",
     filter: {
      type: 'numeric'
     }
    }, {
     header: "<span style=font-weight:bold;>Valid From</span>",
     dataIndex: 'validFromDataIndex2',
     width: 130,
     filter: {
      type: 'date'
     }
    }, {
     header: "<span style=font-weight:bold;>Valid To</span>",
     dataIndex: 'validToIndex2',
     width: 130,
     filter: {
      type: 'date'
     }
    }, {
            header: "<span style=font-weight:bold;>Quotation Status</span>",
            dataIndex: 'QuotationStatusDataIndex2',
            width: 130,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;>Status Type</span>",
            dataIndex: 'StatusTypeDataIndex2',
            width: 130,
            filter: {
                type: 'string'
            }
        },{
     header: "<span style=font-weight:bold;>location</span>",
     dataIndex: 'locationIndex2',
     width: 130,
     filter: {
      type: 'string'
     }
    }, {
     header: "<span style=font-weight:bold;>Quote For</span>",
     dataIndex: 'quotForIndex2',
     width: 130,
     filter: {
      type: 'string'
     }
    }, {
     header: "<span style=font-weight:bold;>Type</span>",
     dataIndex: 'typeIndex2',
     width: 130,
     filter: {
      type: 'string'
     }
    }, {
     header: "<span style=font-weight:bold;>Tariff Type</span>",
     dataIndex: 'tariffTypeIndex2',
     width: 130,
     filter: {
      type: 'string'
     }
    }, {
     header: "<span style=font-weight:bold;>Tariff Amount</span>",
     dataIndex: 'tariffAmountIndex2',
     width: 130,
     filter: {
      type: 'numeric'
     }
    }

   ]
  });

  var grid2 = new Ext.grid.GridPanel({
   title: "",
   height: 300,
   width: 1000,
   store: store2,
   colModel: createColModel2,
   viewConfig: {
    forceFit: true
   },

   view: new Ext.grid.GridView({
    loadMask: true,
    emptyText: 'No Records Found'
   }),

  });


  var innerWinButtonPanel3 = new Ext.Panel({
   id: 'innerWinButtonPanelId23',
   standardSubmit: true,
   collapsible: false,
   autoHeight: true,

   width: 980,
   frame: false,
   layout: 'table',
   layoutConfig: {
    columns: 4
   },
   buttons: [{
    xtype: 'button',
    text: 'Close',
    id: 'CloseButtId2',
    cls: 'buttonstyle',
    iconCls: 'cancelbutton',
    width: 70,
    listeners: {
     click: {
      fn: function() {
       revisionWindow.hide();
      }
     }
    }
   }]
  });

  var quotationMasterPopupAdd2 = new Ext.Panel({
   title: 'Quotation Details',
   width: 1000,
   autoHeight: true,
   standardSubmit: true,
   frame: true,
   items: [grid2, innerWinButtonPanel3]
  });

  revisionWindow = new Ext.Window({
   title: 'Quotation Revision Details',
   closable: false,
   resizable: false,
   modal: true,
   autoScroll: false,
   autoHeight: true,
   width: 1010,
   id: 'revisionWindow',
   items: [quotationMasterPopupAdd2]
  });



  var grid = getCashVanGrid('', 'No Record Found', store, screen.width - 40, 510, 14, false, '', filters, 'Clear Filter Data', false, '', 16, false, '', false, '',  true, 'Add', true, 'Modify', false, '', false, '', false, '', true, 'Approve / Reject', false, '', false, '', true, 'View Revision',false,'',false, '', '', '', false, '');

  function viewFuelPercentage() {}


  var fp = new Ext.FormPanel({

   fileUpload: true,
   height: 190,
   width: 410,
   frame: false,
   autoHeight: true,
   standardSubmit: false,
   labelWidth: 70,
   defaults: {
    anchor: '95%',
    allowBlank: false,
    msgTarget: 'side'
   },
   layout: 'table',
   layoutConfig: {
    columns: 4
   },

   items: [{
     xtype: 'label',
     text: '*',
     cls: 'mandatoryfield',
     id: 'routeEmptyId12'
    }, {
     xtype: 'label',
     text: 'Quotation No' + ' :',
     cls: 'labelstyle',
     id: 'quotationNoId2'
    }, {
     xtype: 'textfield',
     cls: 'selectstylePerfect',
     id: 'quotationValueId2',
     mode: 'local',
     width: 180,
     forceSelection: true,
     emptyText: 'Quotation No',
     blankText: 'Quotation No',
     selectOnFocus: true,
     allowBlank: false,
     maskRe: /[a-z0-9\s]/i,
     autoCreate: { //restricts user to 100 chars max, 
      tag: "input",
      maxlength: 100,
      type: "text",
      size: "100",
      autocomplete: "off"
     },
     listeners: {
      change: function(field, newValue, oldValue) {
       field.setValue(newValue.toUpperCase().trim());
      }
     }
    }, {},

    {
     xtype: 'label',
     text: '',
     cls: 'labelstyle',
     id: 'emptylabel37'
    }, {
     xtype: 'label',
     text: '',
     cls: 'labelstyle',
     id: 'emptylabel38'
    }, {
     xtype: 'label',
     text: '',
     cls: 'labelstyle',
     id: 'emptylabel39'
    }, {
     xtype: 'label',
     text: '',
     cls: 'labelstyle',
     id: 'emptylabel40'
    },

    {
     xtype: 'label',
     text: '*',
     cls: 'mandatoryfield'

    }, {
     xtype: 'label',
     text: 'Valid From' + ' :',
     cls: 'labelstyle'

    }, {
     xtype: 'datefield',
     cls: 'selectstylePerfect',
     width: 160,
     format: 'd-m-Y',
     emptyText: '',
     allowBlank: false,
     blankText: '',
     id: 'startdate2',
     value: new Date(),
     listeners: {
       select: function (t,n,o) {
       var selectedElement=Ext.getCmp('startdate2').getValue();
		var newDate    = new Date(),
    	newDate = selectedElement.add(Date.DAY, 30);
    
		Ext.getCmp('enddate2').setValue(newDate);
            }
            }


    }, {},

    {
     xtype: 'label',
     text: '',
     cls: 'labelstyle',
     id: 'emptylabel41'
    }, {
     xtype: 'label',
     text: '',
     cls: 'labelstyle',
     id: 'emptylabel42'
    }, {
     xtype: 'label',
     text: '',
     cls: 'labelstyle',
     id: 'emptylabel43'
    }, {
     xtype: 'label',
     text: '',
     cls: 'labelstyle',
     id: 'emptylabel44'
    },

    {
     xtype: 'label',
     text: '*',
     cls: 'mandatoryfield'

    }, {
     xtype: 'label',
     text: 'Valid To' + ' :',
     cls: 'labelstyle'

    }, {
     xtype: 'datefield',
     cls: 'selectstylePerfect',
     width: 160,
     format: 'd-m-Y',
     emptyText: '',
     allowBlank: false,
     blankText: '',
     id: 'enddate2',
     value: new Date().add(Date.DAY,30)
    }, {},

    {
     xtype: 'label',
     text: '',
     cls: 'labelstyle',
     id: 'emptylabel45'
    }, {
     xtype: 'label',
     text: '',
     cls: 'labelstyle',
     id: 'emptylabel46'
    }, {
     xtype: 'label',
     text: '',
     cls: 'labelstyle',
     id: 'emptylabel47'
    }, {
     xtype: 'label',
     text: '',
     cls: 'labelstyle',
     id: 'emptylabel48'
    },

    {
     xtype: 'label',
     text: '*',
     cls: 'mandatoryfield',

    }, {
     xtype: 'label',
     text: 'location' + ' :',
     cls: 'labelstyle',
     id: 'LocationId2'
    },
    locationcombo, {},

    {
     xtype: 'label',
     text: '',
     cls: 'labelstyle',
     id: 'emptylabel49'
    }, {
     xtype: 'label',
     text: '',
     cls: 'labelstyle',
     id: 'emptylabel50'
    }, {
     xtype: 'label',
     text: '',
     cls: 'labelstyle',
     id: 'emptylabel51'
    }, {
     xtype: 'label',
     text: '',
     cls: 'labelstyle',
     id: 'emptylabel52'
    },

    {
     xtype: 'label',
     text: '*',
     cls: 'mandatoryfield',

    }, {
     xtype: 'label',
     text: 'Quote For',
     cls: 'labelstyle',
     id: 'quotationForId2'
    },
    quoteForcombo, {},


    {
     xtype: 'label',
     text: '',
     cls: 'labelstyle',
     id: 'emptylabel53'
    }, {
     xtype: 'label',
     text: '',
     cls: 'labelstyle',
     id: 'emptylabel54'
    }, {
     xtype: 'label',
     text: '',
     cls: 'labelstyle',
     id: 'emptylabel55'
    }, {
     xtype: 'label',
     text: '',
     cls: 'labelstyle',
     id: 'emptylabel56'
    },


    {
     xtype: 'label',
     text: '*',
     cls: 'mandatoryfield',

    }, {
     xtype: 'label',
     text: 'Customer' + ' :',
     cls: 'labelstyle',
     id: 'chooseCustomerValueId2'
    },
    chooseCustomercombo, {},

    {
     xtype: 'label',
     text: '',
     cls: 'labelstyle',
     id: 'emptylabel57'
    }, {
     xtype: 'label',
     text: '',
     cls: 'labelstyle',
     id: 'emptylabel58'
    }, {
     xtype: 'label',
     text: '',
     cls: 'labelstyle',
     id: 'emptylabel59'
    }, {
     xtype: 'label',
     text: '',
     cls: 'labelstyle',
     id: 'emptylabel60'
    },

    {
     xtype: 'label',
     text: '*',
     cls: 'mandatoryfield',

    }, {
     xtype: 'label',
     text: 'Tariff Type' + ' :',
     cls: 'labelstyle',
     id: 'tariffTypecomboValueId2'
    },
    tariffTypecombo, {},

    {
     xtype: 'label',
     text: '',
     cls: 'labelstyle',
     id: 'emptylabel61'
    }, {
     xtype: 'label',
     text: '',
     cls: 'labelstyle',
     id: 'emptylabel62'
    }, {
     xtype: 'label',
     text: '',
     cls: 'labelstyle',
     id: 'emptylabel63'
    }, {
     xtype: 'label',
     text: '',
     cls: 'labelstyle',
     id: 'emptylabel64'
    },

    {
     xtype: 'label',
     text: '*',
     cls: 'mandatoryfield',
     id: 'tariffAmtLabelId2'
    }, {
     xtype: 'label',
     text: 'Tariff Amt' + ' :',
     cls: 'labelstyle',
     id: 'tariffAmtId2'
    }, {
     xtype: 'textfield',
     cls: 'selectstylePerfect',
     id: 'tariffAmtValueId2',
     mode: 'local',
     forceSelection: true,
     emptyText: 'Enter Tariff Amount',
     blankText: 'Enter Tariff Amount',
     selectOnFocus: true,
     allowBlank: false,
     width: 180,
     maskRe: /[0-9]/i,
     autoCreate: { //restricts user to 100 chars max, 
      tag: "input",
      maxlength: 15,
      type: "text",
      size: "15",
      autocomplete: "off"
     },

    }, {},

    {
     xtype: 'label',
     text: '',
     cls: 'labelstyle',
     id: 'emptylabel65'
    }, {
     xtype: 'label',
     text: '',
     cls: 'labelstyle',
     id: 'emptylabel66'
    }, {
     xtype: 'label',
     text: '',
     cls: 'labelstyle',
     id: 'emptylabel67'
    }, {
     xtype: 'label',
     text: '',
     cls: 'labelstyle',
     id: 'emptylabel68'
    },

    {
     xtype: 'label',
     text: '',
     cls: 'labelstyle',
     id: 'uploadFileLabelId2'
    }, {
     xtype: 'label',
     text: 'Upload File' + ' :',
     cls: 'labelstyle',
     id: 'uploadFileId2'
    },

    {
     xtype: 'textfield',
     inputType: 'file',
     // xtype: 'fileuploadfield',
     id: 'filePath',
     width: 180,
     //emptyText: 'browse',
     //fieldLabel: 'chooseFile',
     name: 'filePath',

     listeners: {

      'change': {
       fn: function() {
        if (buttonValue == 'Modify' && document.getElementById('filePath').value == '') {
         uploadFileFlag = false;
        } else {
         uploadFileFlag = true;

        }
        var filePath = document.getElementById('filePath').value;
        //var imgext = filePath.substring(filePath.lastIndexOf(".") + 1, filePath.length);
        return;
       }
      }

     }
    }, {}, {
     xtype: 'label',
     text: '',
     cls: 'labelstyle',
     id: 'emptylabel651'
    }, {
     xtype: 'label',
     text: '',
     cls: 'labelstyle',
     id: 'emptylabel661'
    }, {
     xtype: 'label',
     text: '',
     cls: 'labelstyle',
     id: 'emptylabel671'
    }, {
     xtype: 'label',
     text: '',
     cls: 'labelstyle',
     id: 'emptylabel681'
    }, {

     xtype: 'label',
     text: '',
     cls: 'labelstyle',
     id: 'emptylabel72'

    }, {
     xtype: 'label',
     text: 'Uploaded File' + ':',
     cls: 'labelstyle',
     id: 'uploadFileId222'


    }, {
    
     xtype: 'textfield',
     cls: 'selectstylePerfect',    
     id: 'uploadedFileId',
     mode: 'local',
     width: 180,
     forceSelection: false,
     emptyText: '',
     blankText: '',
     selectOnFocus: false,
     allowBlank: true
    }, {
     xtype: 'label',
     text: '',
     cls: 'labelstyle',
     id: 'emptylabel73'
    }


   ],
   buttons: [{
    text: 'Save',
    iconCls: 'uploadbutton',
    id:'modifyButtonId',
    handler: function() {
	Ext.getCmp('modifyButtonId').disable();
    if(buttonValue == 'Modify'){
    var selected = grid.getSelectionModel().getSelected();     
      if(  Ext.getCmp('startdate2').getValue().format('Y-m-d')  == selected.get('validFromDataIndex') && Ext.getCmp('enddate2').getValue().format('Y-m-d') == selected.get('validToIndex') && Ext.getCmp('locationcomboId').getRawValue() == selected.get('locationIndex') && Ext.getCmp('quoteForcomboId').getRawValue() == selected.get('quotForIndex') && Ext.getCmp('chooseCustomerId').getRawValue()== selected.get('typeIndex') && Ext.getCmp('tariffTypecomboId').getRawValue() == selected.get('tariffTypeIndex') && Ext.getCmp('tariffAmtValueId2').getValue()== selected.get('tariffAmountIndex')&& document.getElementById('filePath').value=="" ){
	  Ext.example.msg("No Data Is Editted!");
	  Ext.getCmp('modifyButtonId').enable();
      return;
	  }
    }


     var sysQuotationId = "";
     if (Ext.getCmp('quotationValueId2').getValue() == "") {
      Ext.example.msg("Enter Quotation No");
      Ext.getCmp('modifyButtonId').enable();
      return;
     }



     if (Ext.getCmp('startdate2').getValue() == "") {
      Ext.example.msg("Select Start Date");
        Ext.getCmp('modifyButtonId').enable();
      return;
     }
     if (Ext.getCmp('enddate2').getValue() == "") {
      Ext.example.msg("Select End Date");
        Ext.getCmp('modifyButtonId').enable();
      return;
     }
     if (Ext.getCmp('locationcomboId').getValue() == "") {
      Ext.example.msg("Select Location");
        Ext.getCmp('modifyButtonId').enable();
      return;
     }
     if (Ext.getCmp('quoteForcomboId').getValue() == "") {
      Ext.example.msg("Select Qoute For");
        Ext.getCmp('modifyButtonId').enable();
      return;
     }
     if (Ext.getCmp('chooseCustomerId').getRawValue() == "") {
      Ext.example.msg("Select Customer");
        Ext.getCmp('modifyButtonId').enable();
      return;
     }
     if (Ext.getCmp('tariffTypecomboId').getValue() == "") {
      Ext.example.msg("Select Tariff Type");
        Ext.getCmp('modifyButtonId').enable();
      return;
     }

     if (Ext.getCmp('tariffAmtValueId2').getValue() == "") {
      Ext.example.msg("Enter Tariff Amount");
        Ext.getCmp('modifyButtonId').enable();
      return;
     }
  /*  if (document.getElementById(buttonValue != 'Modify' && 'filePath').value == "" ) {
      Ext.example.msg("Please Upload Relevant File");
      return;
     }
*/
     if (dateComparision(Ext.getCmp('startdate2').getValue(), Ext.getCmp('enddate2').getValue()) == -1) {
      Ext.example.msg("Valid-To Date Must Be Grater Than Valid-From Date");
        Ext.getCmp('modifyButtonId').enable();
      return;
     }
     var filePaths = document.getElementById('filePath').value;
     var imgextxt = filePaths.substring(filePaths.lastIndexOf(".") + 1, filePaths.length);

    /* if (buttonValue != 'Modify' && (imgextxt !="") && imgextxt != "xls" && imgextxt != "xlsx") {
      Ext.example.msg("Please select only excel files formats.");
      return;
     }*/


     if (buttonValue == 'Modify') {
      var selected = grid.getSelectionModel().getSelected();
      sysQuotationId = selected.get('synsQuotationNoIndex');
     }


     if (buttonValue == 'Modify' && uploadFileFlag == false) {

      buttonValue3 = buttonValue;
      CustId = '<%= customerId%>',
       quotationNo2 = Ext.getCmp('quotationValueId2').getValue();
      validFrom2 = Ext.getCmp('startdate2').getValue().format('Y-m-d');
      validTo2 = Ext.getCmp('enddate2').getValue().format('Y-m-d');
      location2 = Ext.getCmp('locationcomboId').getValue();
      quoteFor2 = Ext.getCmp('quoteForcomboId').getValue();
      customer2 = Ext.getCmp('chooseCustomerId').getRawValue();
      quotationCustId = Ext.getCmp('chooseCustomerId').getValue();
      tariffType2 = Ext.getCmp('tariffTypecomboId').getValue();
      uploadedFile2 = Ext.getCmp('filePath').getValue();
      tariffAmt2 = Ext.getCmp('tariffAmtValueId2').getValue();
      systemQuoteNo2 = sysQuotationId;
      var selected = grid.getSelectionModel().getSelected();     
      if(Ext.getCmp('chooseCustomerId').getValue() == selected.get('typeIndex')){
      quotationCustId = selected.get('typeIdIndex2');
}
      //manageTripPlannerOuterPanelWindow.getEl().mask();
      Ext.Ajax.request({
       url: '<%=request.getContextPath()%>/quoteFor.do?param=updateQuotation',
       method: 'POST',
       params: {
        buttonValue: buttonValue3,
        CustId: CustId,
        quotationNo: quotationNo2,
        validFrom: validFrom2,
        validTo: validTo2,
        location: location2,
        quoteFor: quoteFor2,
        customer: customer2,
        quotationCustId : quotationCustId,
        tariffType: tariffType2,
        uploadedFile: uploadedFile2,
        tariffAmt: tariffAmt2,
        systemQuoteNo: systemQuoteNo2

       },
       success: function(response, options) {
        var message = "Details Saved Successfully";
        Ext.example.msg(message);
          Ext.getCmp('modifyButtonId').enable();
        myWinAdd.hide();
        outerPanel.getEl().unmask();
        store.load({
         params: {
          CustId: custId
         }
        });
       },
       failure: function() {
        var message = "Details Did Not Saved Successfully";
        Ext.example.msg(message);
          Ext.getCmp('modifyButtonId').enable();
        myWinAdd.hide();
        outerPanel.getEl().unmask();
        store.load({
         params: {
          CustId: custId
         }
        });
       }
      });



     }  else if (buttonValue != 'Modify' && uploadFileFlag == false) {

      buttonValue3 = buttonValue;
      CustId = '<%= customerId%>',
       quotationNo2 = Ext.getCmp('quotationValueId2').getValue();
      validFrom2 = Ext.getCmp('startdate2').getValue().format('Y-m-d');
      validTo2 = Ext.getCmp('enddate2').getValue().format('Y-m-d');
      location2 = Ext.getCmp('locationcomboId').getValue();
      quoteFor2 = Ext.getCmp('quoteForcomboId').getValue();
      customer2 = Ext.getCmp('chooseCustomerId').getRawValue();
      quotationCustId = Ext.getCmp('chooseCustomerId').getValue();
      tariffType2 = Ext.getCmp('tariffTypecomboId').getValue();
      uploadedFile2 = Ext.getCmp('filePath').getValue();
      tariffAmt2 = Ext.getCmp('tariffAmtValueId2').getValue();
      systemQuoteNo2 = sysQuotationId;
      var selected = grid.getSelectionModel().getSelected();
      //manageTripPlannerOuterPanelWindow.getEl().mask();
      Ext.Ajax.request({
       url: '<%=request.getContextPath()%>/quoteFor.do?param=fileUpload',
       method: 'POST',
       params: {
        buttonValue: buttonValue3,
        CustId: CustId,
        quotationNo: quotationNo2,
        validFrom: validFrom2,
        validTo: validTo2,
        location: location2,
        quoteFor: quoteFor2,
        customer: customer2,
        quotationCustId : quotationCustId,
        tariffType: tariffType2,
        uploadedFile: uploadedFile2,
        tariffAmt: tariffAmt2,
        systemQuoteNo: systemQuoteNo2

       },
       success: function(response, options) {
        var message = "Details Saved Successfully";
        Ext.example.msg(message);
        Ext.getCmp('modifyButtonId').enable();
        myWinAdd.hide();
        outerPanel.getEl().unmask();
        store.load({
         params: {
          CustId: custId
         }
        });
       },
       failure: function() {
        var message = "Details Did Not Saved Successfully";
        Ext.example.msg(message);
        Ext.getCmp('modifyButtonId').enable();
        myWinAdd.hide();
        outerPanel.getEl().unmask();
        store.load({
         params: {
          CustId: custId
         }
        });
       }
      });



     } else {
     if (fp.getForm().isValid()) {
       if (buttonValue == 'Add') {
        buttonValue3 = buttonValue;
        CustId = '<%= customerId%>',
         quotationNo2 = Ext.getCmp('quotationValueId2').getValue();
        validFrom2 = Ext.getCmp('startdate2').getValue().format('Y-m-d');
        validTo2 = Ext.getCmp('enddate2').getValue().format('Y-m-d');
        location2 = Ext.getCmp('locationcomboId').getValue();
        quoteFor2 = Ext.getCmp('quoteForcomboId').getValue();
        customer2 = Ext.getCmp('chooseCustomerId').getRawValue();
        quotationCustId = Ext.getCmp('chooseCustomerId').getValue();
        tariffType2 = Ext.getCmp('tariffTypecomboId').getValue();
        uploadedFile2 = Ext.getCmp('filePath').getValue();
        tariffAmt2 = Ext.getCmp('tariffAmtValueId2').getValue();
        systemQuoteNo2 = sysQuotationId;

        var filePath = document.getElementById('filePath').value;

        var imgext = filePath.substring(filePath.lastIndexOf(".") + 1, filePath.length);
        fp.getForm().submit({
         url: '<%=request.getContextPath()%>/quoteFor.do?param=fileUpload&buttonValue=' + buttonValue3 + '&CustId=' + CustId + '&quotationNo=' + quotationNo2 + '&validFrom=' + validFrom2 + '&validTo=' + validTo2 + '&location=' + location2 + '&quoteFor=' + quoteFor2 + '&customer=' + customer2 + '&quotationCustId=' + quotationCustId + '&tariffType=' + tariffType2 + '&uploadedFile=' + uploadedFile2 + '&tariffAmt=' + tariffAmt2 + '&systemQuoteNo=' + systemQuoteNo2 + '',
         enctype: 'multipart/form-data',
         waitMsg: 'Uploading your file...',
         success: function(response, action) {
          var message = "Details Saved Successfully";
          Ext.example.msg(message);
          Ext.getCmp('modifyButtonId').enable();
          myWinAdd.hide();
          outerPanel.getEl().unmask();
          store.load({
           params: {
            CustId: custId
           }
          });
         },
         failure: function() {
          var message = "Details Did Not Saved Successfully";
          Ext.example.msg(message);
          Ext.getCmp('modifyButtonId').enable();
          myWinAdd.hide();
          outerPanel.getEl().unmask();
          store.load({
           params: {
            CustId: custId
           }
          });
         }
        });

       } else if (buttonValue == 'Modify') {
        Ext.MessageBox.confirm('Confirm', 'Old File Will be Deleted And New File Will Be Saved !!',

         function(btn1) {

          if (btn1 == 'yes') {
           buttonValue3 = buttonValue;
           CustId = '<%= customerId%>',
            quotationNo2 = Ext.getCmp('quotationValueId2').getValue();
           validFrom2 = Ext.getCmp('startdate2').getValue().format('Y-m-d');
           validTo2 = Ext.getCmp('enddate2').getValue().format('Y-m-d');
           location2 = Ext.getCmp('locationcomboId').getValue();
           quoteFor2 = Ext.getCmp('quoteForcomboId').getValue();
           customer2 = Ext.getCmp('chooseCustomerId').getRawValue();
           quotationCustId = Ext.getCmp('chooseCustomerId').getValue();           
           tariffType2 = Ext.getCmp('tariffTypecomboId').getValue();
           uploadedFile2 = Ext.getCmp('filePath').getValue();
           tariffAmt2 = Ext.getCmp('tariffAmtValueId2').getValue();
           systemQuoteNo2 = sysQuotationId;
           var selected = grid.getSelectionModel().getSelected();        
           if(Ext.getCmp('chooseCustomerId').getValue() == selected.get('typeIndex')){
           quotationCustId = selected.get('typeIdIndex2');
}
           var filePath = document.getElementById('filePath').value;

           var imgext = filePath.substring(filePath.lastIndexOf(".") + 1, filePath.length);
           fp.getForm().submit({
            url: '<%=request.getContextPath()%>/quoteFor.do?param=fileUpload&buttonValue=' + buttonValue3 + '&CustId=' + CustId + '&quotationNo=' + quotationNo2 + '&validFrom=' + validFrom2 + '&validTo=' + validTo2 + '&location=' + location2 + '&quoteFor=' + quoteFor2 + '&customer=' + customer2 + '&quotationCustId=' + quotationCustId + '&tariffType=' + tariffType2 + '&uploadedFile=' + uploadedFile2 + '&tariffAmt=' + tariffAmt2 + '&systemQuoteNo=' + systemQuoteNo2 + '',
            enctype: 'multipart/form-data',
            waitMsg: 'Uploading your file...',
            success: function(response, action) {
             var message = "Details Saved Successfully";
             Ext.example.msg(message);
             Ext.getCmp('modifyButtonId').enable();
             myWinAdd.hide();
             outerPanel.getEl().unmask();
             store.load({
              params: {
               CustId: custId
              }
             });
            },
            failure: function() {
             var message = "Details Did Not Saved Successfully";
             Ext.example.msg(message);
             Ext.getCmp('modifyButtonId').enable();
             myWinAdd.hide();
             outerPanel.getEl().unmask();
             store.load({
              params: {
               CustId: custId
              }
             });
            }
           });

          }else{  Ext.getCmp('modifyButtonId').enable();}
          Ext.MessageBox.hide();
         }
        );

       }
   }
     }

    }
   }, {
    text: 'Cancel',
    id: 'canButtIdAdd',
    cls: 'buttonstyle',
    iconCls: 'cancelbutton',
    width: 70,
    listeners: {
     click: {
      fn: function() {
          Ext.getCmp('modifyButtonId').enable();
       myWinAdd.hide();
      }
     }
    }
   }]
  });



  var quotationMasterPopupAdd = new Ext.Panel({
   width: 430,
   height: 500,
   standardSubmit: true,
   frame: true,
   items: [fp]
  });


  myWinAdd = new Ext.Window({
   title: '',
   closable: false,
   resizable: false,
   modal: true,
   autoScroll: false,
   height: 500,
   width: 430,
   id: 'myWinAdd',
   items: [quotationMasterPopupAdd]
  });


  function addRecord() {
   uploadFileFlag = false;
   buttonValue = 'Add';
   Ext.getCmp('quotationValueId2').enable();
   Ext.getCmp('filePath').enable();
   titelForInnerPanel = 'Add Quotation';
   myWinAdd.setPosition(450, 30);
   myWinAdd.show();
   myWinAdd.setTitle(titelForInnerPanel);
   Ext.getCmp('filePath').reset();
   Ext.getCmp('uploadedFileId').setValue("");
   Ext.getCmp('uploadFileId222').hide();
   Ext.getCmp('uploadedFileId').hide();
   Ext.getCmp('quotationValueId2').reset();
   Ext.getCmp('quotationValueId2').reset();
   Ext.getCmp('startdate2').reset();
   Ext.getCmp('enddate2').reset();
   Ext.getCmp('chooseCustomerId').reset();
   Ext.getCmp('quoteForcomboId').reset();
   Ext.getCmp('locationcomboId').reset();
   Ext.getCmp('tariffTypecomboId').reset();
   Ext.getCmp('tariffAmtValueId2').reset();

  }

  function modifyData() {


   if (grid.getSelectionModel().getCount() == 0) {
    Ext.example.msg("NoRowsSelected");
    return;
   }
   if (grid.getSelectionModel().getCount() > 1) {
    Ext.example.msg("SelectSingleRow");
    return;
   }

   var selected = grid.getSelectionModel().getSelected();

   uploadFileFlag = false;
   buttonValue = 'Modify';
   titelForInnerPanel = 'Modify Quotation';
   myWinAdd.setPosition(450, 10);
   myWinAdd.show();
   myWinAdd.setTitle(titelForInnerPanel);


   Ext.getCmp('quotationValueId2').setValue(selected.get('quotationDataIndex'));
   Ext.getCmp('quotationValueId2').disable();
   //Ext.getCmp('filePath').disable();

   Ext.getCmp('startdate2').setValue(selected.get('validFromDataIndex'));
   Ext.getCmp('enddate2').setValue(selected.get('validToIndex'));
   Ext.getCmp('locationcomboId').setValue(selected.get('locationIndex'));
   Ext.getCmp('tariffTypecomboId').setValue(selected.get('tariffTypeIndex'));
   Ext.getCmp('tariffAmtValueId2').setValue(selected.get('tariffAmountIndex'));
   Ext.getCmp('chooseCustomerId').setValue(selected.get('typeIndex'));
   Ext.getCmp('quoteForcomboId').setValue(selected.get('quotForIndex'));
   Ext.getCmp('filePath').reset();
   Ext.getCmp('uploadedFileId').setValue(selected.get('uploadedFileIndex'));
   Ext.getCmp('uploadFileId222').show();
   Ext.getCmp('uploadedFileId').show();

  }



  function dateComparision(fromDate, toDate) {

   if (fromDate <= toDate) {
    return 1;
   } else if (toDate < fromDate) {
    return -1;
   }
   return 0;
  }
  

Ext.onReady(function() {
      ctsb = tsb;
      Ext.QuickTips.init();
      Ext.form.Field.prototype.msgTarget = 'side';
      outerPanel = new Ext.Panel({
          renderTo: 'content',
          standardSubmit: true,
          frame: false,
          width: screen.width - 22,
          height: 550,
          cls: 'outerpanel',
          layout: 'table',
          layoutConfig: {
              columns: 1
          },
        items: [grid]
    });
     store.load({
    params: {
    CustId: custId,
   }
   });
    sb = Ext.getCmp('form-statusbar');
});


</script>
   </body></html>