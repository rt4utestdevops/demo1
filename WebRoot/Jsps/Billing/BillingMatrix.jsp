 <%@ page  language="java" import="java.util.*,java.text.SimpleDateFormat,t4u.functions.*,t4u.beans.*,t4u.common.*" pageEncoding="utf-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
LoginInfoBean loginInfo=new LoginInfoBean();
loginInfo.setSystemId(12);
loginInfo.setUserId(1);
loginInfo.setLanguage("en");
loginInfo.setZone("A");
loginInfo.setOffsetMinutes(330);
loginInfo.setCategory("India");
loginInfo.setCategoryType("South India");
loginInfo.setSystemName("T4U");
loginInfo.setCustomerId(0);
loginInfo.setUserName("t4uaccounts");
if(loginInfo==null){
	response.sendRedirect(request.getContextPath()+ "/Jsps/Common/SessionDestroy.html");
}
else
{
	session.setAttribute("loginInfoDetails",loginInfo);	
	String language="en";
	
	CommonFunctions cf = new CommonFunctions();
	cf.checkLoginInfo((LoginInfoBean) session.getAttribute("loginInfoDetails"), session, request, response);
	String responseaftersubmit="''";
	String feature="1";
	if(session.getAttribute("responseaftersubmit")!=null){
	   responseaftersubmit="'"+session.getAttribute("responseaftersubmit").toString()+"'";
		session.setAttribute("responseaftersubmit",null);
	}
		
    int systemId = loginInfo.getSystemId();
	int customerId = loginInfo.getCustomerId();
	Calendar cal = Calendar.getInstance();
	int CrntYear = cal.get(Calendar.YEAR);
	int PrevYear = cal.get(Calendar.YEAR)-1;
	int date = cal.get(Calendar.DATE);
	int CurMonth = cal.get(Calendar.MONTH);
	
ArrayList<String> tobeConverted = new ArrayList<String>();
tobeConverted.add("Billing_Matrix_Report");
tobeConverted.add("Select_Bill_Month");
tobeConverted.add("Select_Bill_Year");
tobeConverted.add("Select_Ltsp_Name");
tobeConverted.add("Select_LTSP");
tobeConverted.add("Bill_Month");
tobeConverted.add("Bill_Year");
tobeConverted.add("SLNO");
tobeConverted.add("Vehicle_Number");
tobeConverted.add("Billing_Start_Date");
tobeConverted.add("Billing_End_Date");
tobeConverted.add("Vehicle_Id");
tobeConverted.add("Transporter");
tobeConverted.add("Vehicle_Model");
tobeConverted.add("IMEI_No");
tobeConverted.add("Installation_Date");
tobeConverted.add("HID_Card_Reader_Auto_Grade_Model");
tobeConverted.add("EAM_With_Panic_Button_Installed");
tobeConverted.add("Facility");
tobeConverted.add("GPS_Installed");
tobeConverted.add("No_Of_Days_Active");
tobeConverted.add("GPS_Per_Day_Price");
tobeConverted.add("FMS_Per_Day_Price");
tobeConverted.add("Total_Price");
tobeConverted.add("Excel");
tobeConverted.add("PDF");
tobeConverted.add("Clear_Filter_Data");
tobeConverted.add("No_Records_Found");
tobeConverted.add("FDAS_Per_Day_Price");
tobeConverted.add("Select_Invoice_No");
tobeConverted.add("Invoice_No");
tobeConverted.add("Please_Select_LTSP");
tobeConverted.add("Please_Select_Bill_Month");
tobeConverted.add("Please_Select_Bill_Year");
tobeConverted.add("Please_Select_InVoice_No");
tobeConverted.add("LTSP");
tobeConverted.add("GPS_Vehicle_Days");
tobeConverted.add("NON_GPS_Vehicle_Days");
tobeConverted.add("Billing_Matrix_Details");

ArrayList<String> convertedWords = new ArrayList<String>();
convertedWords = cf.getLanguageSpecificWordForKey(tobeConverted,language);
String BillingMatrixReport=convertedWords.get(0);
String SelectBillMonth=convertedWords.get(1);
String SelectBillYear=convertedWords.get(2);
String SelectLptsName=convertedWords.get(3);
String SelectLTSP=convertedWords.get(4);
String BillMonth=convertedWords.get(5);
String BillYear=convertedWords.get(6);
String SLNO=convertedWords.get(7);
String VehicleNumber=convertedWords.get(8);
String BillingStartDate=convertedWords.get(9);
String BillingEndDate=convertedWords.get(10);
String VehicleId=convertedWords.get(11);
String Transpoter=convertedWords.get(12);
String VehicleModel=convertedWords.get(13);
String IMEINo=convertedWords.get(14);
String InstallationDate=convertedWords.get(15);
String HidCardReaderAutoGradeModel=convertedWords.get(16);
String EAMWithPanicButtonInstalled=convertedWords.get(17);
String Facility=convertedWords.get(18);
String GPSInstalled=convertedWords.get(19);
String NoOfDaysActive=convertedWords.get(20);
String GpsPerDayPrice=convertedWords.get(21);
String FmsPerDayPrice=convertedWords.get(22);
String TotalPrice=convertedWords.get(23);
String Excel=convertedWords.get(24);
String PDF=convertedWords.get(25);
String ClearFilterData=convertedWords.get(26);
String NoRecordsfound=convertedWords.get(27);
String FDAS=convertedWords.get(28);
String SelectInvoiceNo=convertedWords.get(29);
String InvoiceNo=convertedWords.get(30);
String PleaseSelectLtsp=convertedWords.get(31);
String PleaseSelectBillMonth=convertedWords.get(32);
String PleaseSelectBillYear=convertedWords.get(33);
String PleaseSelectInVoiceNo=convertedWords.get(34);
String LTSP=convertedWords.get(35);
String GPSVehicleDays=convertedWords.get(36);
String NONGPSVehicleDays=convertedWords.get(37);
String BillingMatrixDetails =convertedWords.get(38);

%>

<!DOCTYPE HTML>
<html class="largehtml">
 <head>
 		<title><%=BillingMatrixReport%></title>		
</head>	    
	 <style>
  .x-panel-tl
	{
		border-bottom: 0px solid !important;
	}
  </style>
  <body   onLoad="">
   <jsp:include page="../Common/ImportJS.jsp" />
   <!-- <jsp:include page="../Common/ExportJS.jsp" /> -->
   <jsp:include page="../Common/ExportJSForBillingMatrix.jsp" />
   
   <script>
  var outerPanel;
  var dtprev = dateprev;
  var dtcur = datecur;
  var jspName = "BillingMatrixReport";
  var exportDataType = "int,string,string,string,int,int,string,string,string,string,string,string,string,string,string,int,float,float,float,float";
  var dtcur = datecur;
  var grid;
  var curDate = <%= date %>
  
      var monthStore = new Ext.data.JsonStore({
          url: '<%=request.getContextPath()%>/BillingAction.do?param=getMonth',
          id: 'monthStoreId',
          root: 'monthRoot',
          autoLoad: true,
          remoteSort: true,
          fields: ['monthName'],
          listeners: {}
      });
      
  var monthCombo = new Ext.form.ComboBox({
      store: monthStore,
      id: 'monthComboId',
      mode: 'local',
      forceSelection: true,
      selectOnFocus: true,
      allowBlank: false,
      anyMatch: true,
      typeAhead: false,
      triggerAction: 'all',
      lazyRender: true,
      valueField: 'monthName',
      emptyText: '<%=SelectBillMonth%>',
      displayField: 'monthName',
      cls: 'selectstylePerfect',
      listeners: {
          select: {
              fn: function () {
                  store.load();
                  Ext.getCmp('yearComboId').reset();
                  Ext.getCmp('invoicecomboId').reset();
              }
          }
      }
  });
  
  var yearStore = new Ext.data.SimpleStore({
      id: 'yearStoreId',
      autoLoad: true,
      fields: ['Value', 'Name'],
      data: [
          ['1', <%= PrevYear %> ],
          ['2', <%= CrntYear %> ]
      ]
  });
  
  var yearCombo = new Ext.form.ComboBox({
      store: yearStore,
      id: 'yearComboId',
      mode: 'local',
      forceSelection: true,
      selectOnFocus: true,
      allowBlank: false,
      anyMatch: true,
      typeAhead: false,
      triggerAction: 'all',
      lazyRender: true,
      valueField: 'Value',
      emptyText: '<%=SelectBillYear%>',
      displayField: 'Name',
      cls: 'selectstylePerfect',
      listeners: {
          select: {
              fn: function () {
                  store.load();
                  Ext.getCmp('invoicecomboId').reset();
                  invoicestore.load({
                      params: {
                          ltspId: Ext.getCmp('ltspcomboId').getValue(),
                          billMonth: Ext.getCmp('monthComboId').getValue(),
                          billYear: Ext.getCmp('yearComboId').getRawValue()
                      }
                  });
              }
          }
      }
  });
  
  var ltspstore = new Ext.data.JsonStore({
      url: '<%=request.getContextPath()%>/BillingAction.do?param=getLtsp',
      id: 'ltspStoreId',
      root: 'lpstRoot',
      autoLoad: true,
      remoteSort: true,
      fields: ['systemId', 'systemName'],
      listeners: {}
  });
  
  var ltspCombo = new Ext.form.ComboBox({
      store: ltspstore,
      id: 'ltspcomboId',
      mode: 'local',
      forceSelection: true,
      emptyText: '<%=SelectLTSP%>',
      blankText: '<%=SelectLTSP%>',
      selectOnFocus: true,
      allowBlank: false,
      anyMatch: true,
      typeAhead: false,
      triggerAction: 'all',
      lazyRender: true,
      valueField: 'systemId',
      displayField: 'systemName',
      cls: 'selectstylePerfect',
      listeners: {
          select: {
              fn: function () {
                  monthStore.load();
                  store.load();
                  Ext.getCmp('invoicecomboId').reset();
                  Ext.getCmp('monthComboId').reset();
                  Ext.getCmp('yearComboId').reset();
                  Ext.getCmp('monthComboId').show();
                  
                   grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('vehicleNumberDataIndex'), false);
                  grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('billingStartDateDataIndex'), false);
                  grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('billingEndDateDataIndex'), false);
                  grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('gpsVehicleDaysDataIndex'), false);
                  grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('nonGpsVehicleDaysDataIndex'), false);
                  grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('vehicleIdDataIndex'), true);
				  grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('transpoterDataIndex'), true);
                  grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('vehicleModelDataIndex'), true);
                  grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('imeiNoDataIndex'), true);
                  grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('installationDateDataIndex'), true);
                  grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('hidCardReaderAutoGradeModelDataIndex'), true);
                  grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('eamWithPanicButtonInstalledDataIndex'), true);
				  grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('facilityDataIndex'), true);
                  grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('gpsInstalledDataIndex'), true);
                  grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('NoOfDaysActiveDataIndex'), true);
                  grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('gpsPerDaypriceDataIndex'), false);
                  grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('fmsPerDaypriceDataIndex'), false);
                  grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('totalpriceDataIndex'), false);
				  grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('fdasDataIndex'), true);
                  
              }
          }
      }
  });
  
  var invoicestore = new Ext.data.JsonStore({
      url: '<%=request.getContextPath()%>/BillingAction.do?param=getInvoiceNumber',
      id: 'invoiceStoreId',
      root: 'invoiceRoot',
      autoLoad: false,
      remoteSort: true,
      fields: ['invoiceId', 'invoiceId'],
      listeners: {}
  });
  
  var invoiceCombo = new Ext.form.ComboBox({
      store: invoicestore,
      id: 'invoicecomboId',
      mode: 'local',
      forceSelection: true,
      emptyText: '<%=SelectInvoiceNo%>',
      blankText: '<%=SelectInvoiceNo%>',
      selectOnFocus: true,
      allowBlank: false,
      anyMatch: true,
      typeAhead: false,
      triggerAction: 'all',
      lazyRender: true,
      valueField: 'invoiceId',
      displayField: 'invoiceId',
      cls: 'selectstylePerfect',
      listeners: {
          select: {
              fn: function () {
               store.load();
              }
          }
      }
  });
  
  var editInfo1 = new Ext.Button({
      text: 'Submit',
      id: 'submitId',
      cls: 'buttonStyle',
      width: 70,
      handler: function () {
          if (Ext.getCmp('ltspcomboId').getValue() == "") {
              ctsb.setStatus({
                  text: getMessageForStatus('<%=PleaseSelectLtsp%>'),
                  iconCls: '',
                  clear: true
              });
              Ext.getCmp('ltspcomboId').focus();
              return;
          }
          if (Ext.getCmp('monthComboId').getValue() == "") {
              ctsb.setStatus({
                  text: getMessageForStatus('<%=PleaseSelectBillMonth%>'),
                  iconCls: '',
                  clear: true
              });
              Ext.getCmp('monthComboId').focus();
              return;
          }
          if (Ext.getCmp('yearComboId').getValue() == "") {
              ctsb.setStatus({
                  text: getMessageForStatus('<%=PleaseSelectBillYear%>'),
                  iconCls: '',
                  clear: true
              });
              Ext.getCmp('yearComboId').focus();
              return;
          }
          if (Ext.getCmp('invoicecomboId').getValue() == "") {
              ctsb.setStatus({
                  text: getMessageForStatus('<%=PleaseSelectInVoiceNo%>'),
                  iconCls: '',
                  clear: true
              });
              Ext.getCmp('invoicecomboId').focus();
              return;
          }

<!--          if (Ext.getCmp('yearComboId').getRawValue() == <%=PrevYear%>  && !(Ext.getCmp('monthComboId').getValue() == 'December' || Ext.getCmp('monthComboId').getValue() == 'November' || Ext.getCmp('monthComboId').getValue() == 'October'))-->
<!--			{-->
<!--              ctsb.setStatus({-->
<!--                  text: getMessageForStatus('Cannot Select Previous D Year'),-->
<!--                  iconCls: '',-->
<!--                  clear: true-->
<!--              });-->
<!--              Ext.getCmp('yearComboId').focus();-->
<!--              return;-->
<!--          }-->
           store.load({
              params: {
                  ltspId: Ext.getCmp('ltspcomboId').getValue(),
                  invoiceNo: Ext.getCmp('invoicecomboId').getValue(),
                  ltspName: Ext.getCmp('ltspcomboId').getRawValue(),
                  jspName: jspName,
                  month: Ext.getCmp('monthComboId').getValue(),
                  billYear: Ext.getCmp('yearComboId').getRawValue()
              }
          });
      }
  });
  
  var clientPanel = new Ext.Panel({
      standardSubmit: true,
      collapsible: false,
      id: 'clientPanelId',
      layout: 'table',
      frame: true,
      width: screen.width - 60,
      height: 50,
      layoutConfig: {
          columns: 15
      },
      items: [{
              xtype: 'label',
              text: '<%=LTSP%>' + ' :',
              cls: 'labelstyle',
              id: 'ltspId'
          },
          ltspCombo, {
              width: 40
          }, {
              xtype: 'label',
              text: '<%=BillMonth%>' + ' :',
              cls: 'labelstyle',
              id: 'monthId'
          },
          monthCombo, {
              width: 40
          }, {
              xtype: 'label',
              text: '<%=BillYear%>' + ' :',
              cls: 'labelstyle',
              id: 'billYearId'
          },
          yearCombo, {
              width: 40
          }, {
              xtype: 'label',
              text: '<%=InvoiceNo%>' + ' :',
              cls: 'labelstyle',
              id: 'invoiceIdId'
          },
          invoiceCombo, {
              width: 40
          },
          editInfo1
      ]
  });
  
  var reader = new Ext.data.JsonReader({
      idProperty: 'billingReportId',
      root: 'billingreportRoot',
      totalProperty: 'total',
      fields: [{
          name: 'slnoIndex'
      }, {
          name: 'vehicleNumberDataIndex'
      }, {
          name: 'billingStartDateDataIndex'
      }, {
          name: 'billingEndDateDataIndex'
      },{
          name: 'gpsVehicleDaysDataIndex'
      }, {
          name: 'nonGpsVehicleDaysDataIndex'
      },{
          name: 'vehicleIdDataIndex'
      }, {
          name: 'transpoterDataIndex'
      }, {
          name: 'vehicleModelDataIndex'
      }, {
          name: 'imeiNoDataIndex'
      }, {
          name: 'installationDateDataIndex'
      }, {
          name: 'hidCardReaderAutoGradeModelDataIndex'
      }, {
          name: 'eamWithPanicButtonInstalledDataIndex'
      }, {
          name: 'facilityDataIndex'
      }, {
          name: 'gpsInstalledDataIndex'
      }, {
          name: 'NoOfDaysActiveDataIndex'
      }, {
          name: 'gpsPerDaypriceDataIndex'
      }, {
          name: 'fmsPerDaypriceDataIndex'
      }, {
          name: 'totalpriceDataIndex'
      }, {
          name: 'fdasDataIndex'
      }]
  });
  
  var store = new Ext.data.GroupingStore({
      autoLoad: false,
      proxy: new Ext.data.HttpProxy({
          url: '<%=request.getContextPath()%>/BillingAction.do?param=getBillingReport',
          method: 'POST'
      }),
      remoteSort: false,
      storeId: 'billingreport',
      reader: reader
  });
  
  var filters = new Ext.ux.grid.GridFilters({
      local: true,
      filters: [{
          type: 'numeric',
          dataIndex: 'slnoIndex'
      }, {
          type: 'string',
          dataIndex: 'vehicleNumberDataIndex'
      }, {
          type: 'string',
          dataIndex: 'billingStartDateDataIndex'
      }, {
          type: 'string',
          dataIndex: 'billingEndDateDataIndex'
      }, {
          type: 'int',
          dataIndex: 'gpsVehicleDaysDataIndex'
      }, {
          type: 'int',
          dataIndex: 'nonGpsVehicleDaysDataIndex'
      }, {
          type: 'string',
          dataIndex: 'vehicleIdDataIndex'
      }, {
          type: 'string',
          dataIndex: 'transpoterDataIndex'
      }, {
          type: 'string',
          dataIndex: 'vehicleModelDataIndex'
      }, {
          type: 'string',
          dataIndex: 'imeiNoDataIndex'
      }, {
          type: 'string',
          dataIndex: 'installationDateDataIndex'
      }, {
          type: 'string',
          dataIndex: 'hidCardReaderAutoGradeModelDataIndex'
      }, {
          type: 'string',
          dataIndex: 'eamWithPanicButtonInstalledDataIndex'
      }, {
          type: 'string',
          dataIndex: 'facilityDataIndex'
      }, {
          type: 'string',
          dataIndex: 'gpsInstalledDataIndex'
      }, {
          type: 'int',
          dataIndex: 'NoOfDaysActiveDataIndex'
      }, {
          type: 'float',
          dataIndex: 'gpsPerDaypriceDataIndex'
      }, {
          type: 'float',
          dataIndex: 'fmsPerDaypriceDataIndex'
      }, {
          type: 'float',
          dataIndex: 'totalpriceDataIndex'
      }, {
          type: 'float',
          dataIndex: 'fdasDataIndex'
      }]
  });
  
  var createColModel = function (finish, start) {
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
              header: "<span style=font-weight:bold;><%=VehicleNumber%></span>",
              dataIndex: 'vehicleNumberDataIndex',
              width: 100,
              filter: {
                  type: 'string'
              }
          }, {
              header: "<span style=font-weight:bold;><%=BillingStartDate%></span>",
              dataIndex: 'billingStartDateDataIndex',
              width: 100,
              filter: {
                  type: 'string'
              }
          }, {
              header: "<span style=font-weight:bold;><%=BillingEndDate%></span>",
              dataIndex: 'billingEndDateDataIndex',
              width: 100,
              filter: {
                  type: 'string'
              }
          }, {
              header: "<span style=font-weight:bold;><%=GPSVehicleDays%></span>",
              dataIndex: 'gpsVehicleDaysDataIndex',
              width: 100,
              filter: {
                  type: 'int'
              }
          }, {
              header: "<span style=font-weight:bold;><%=NONGPSVehicleDays%></span>",
              dataIndex: 'nonGpsVehicleDaysDataIndex',
              width: 100,
              filter: {
                  type: 'int'
              }
          }, {
              header: "<span style=font-weight:bold;><%=VehicleId%></span>",
              dataIndex: 'vehicleIdDataIndex',
              hidden:true,
              width: 100,
              filter: {
                  type: 'string'
              }
          }, {
              header: "<span style=font-weight:bold;><%=Transpoter%></span>",
              dataIndex: 'transpoterDataIndex',
              width: 100,
              hidden:true,
              filter: {
                  type: 'string'
              }
          }, {
              header: "<span style=font-weight:bold;><%=VehicleModel%></span>",
              dataIndex: 'vehicleModelDataIndex',
              width: 100,
              hidden:true,
              filter: {
                  type: 'string'
              }
          }, {
              header: "<span style=font-weight:bold;><%=IMEINo%></span>",
              dataIndex: 'imeiNoDataIndex',
              width: 100,
              hidden:true,
              filter: {
                  type: 'string'
              }
          }, {
              header: "<span style=font-weight:bold;><%=InstallationDate%></span>",
              dataIndex: 'installationDateDataIndex',
              width: 100,
              hidden:true,
              filter: {
                  type: 'string'
              }
          }, {
              header: "<span style=font-weight:bold;><%=HidCardReaderAutoGradeModel%></span>",
              dataIndex: 'hidCardReaderAutoGradeModelDataIndex',
              width: 100,
              hidden:true,
              filter: {
                  type: 'string'
              }
          }, {
              header: "<span style=font-weight:bold;><%=EAMWithPanicButtonInstalled%></span>",
              dataIndex: 'eamWithPanicButtonInstalledDataIndex',
              width: 100,
              hidden:true,
              filter: {
                  type: 'string'
              }
          }, {
              header: "<span style=font-weight:bold;><%=Facility%></span>",
              dataIndex: 'facilityDataIndex',
              width: 100,
              hidden:true,
              filter: {
                  type: 'string'
              }
          }, {
              header: "<span style=font-weight:bold;><%=GPSInstalled%></span>",
              dataIndex: 'gpsInstalledDataIndex',
              width: 100,
              hidden:true,
              filter: {
                  type: 'string'
              }
          }, {
              header: "<span style=font-weight:bold;><%=NoOfDaysActive%></span>",
              dataIndex: 'NoOfDaysActiveDataIndex',
              width: 100,
              hidden:true,
              filter: {
                  type: 'int'
              }
          }, {
              header: "<span style=font-weight:bold;><%=GpsPerDayPrice%></span>",
              dataIndex: 'gpsPerDaypriceDataIndex',
              width: 100,
              filter: {
                  type: 'float'
              }
          }, {
              header: "<span style=font-weight:bold;><%=FmsPerDayPrice%></span>",
              dataIndex: 'fmsPerDaypriceDataIndex',
              width: 100,
              filter: {
                  type: 'float'
              }
          }, {
              header: "<span style=font-weight:bold;><%=FDAS%></span>",
              dataIndex: 'fdasDataIndex',
              hidden: true,
              width: 100,
              filter: {
                  type: 'float'
              }
          }, {
              header: "<span style=font-weight:bold;><%=TotalPrice%></span>",
              dataIndex: 'totalpriceDataIndex',
              width: 100,
              filter: {
                  type: 'float'
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
  
  var grid = getGrid('<%=BillingMatrixDetails%>', '<%=NoRecordsfound%>', store, screen.width - 140, 380, 22, filters, '<%=ClearFilterData%>', false, '', 14, false, '', false, '', true, '<%=Excel%>', jspName, exportDataType, false, '<%=PDF%>');
  
  
  Ext.onReady(function () {
      ctsb = tsb;
      Ext.QuickTips.init();
      Ext.form.Field.prototype.msgTarget = 'side';
      outerPanel = new Ext.Panel({
          title: '',
          renderTo: 'content',
          standardSubmit: true,
          frame: true,
          cls: 'outerpanel',
          layout: 'table',
          width:screen.width - 130,
          height:510,
          layoutConfig: {
              columns: 1
          },
          items: [clientPanel, grid],
          bbar: ctsb
      });
      sb = Ext.getCmp('form-statusbar');
  });   </script>
 </body>
</html>
<%}%>