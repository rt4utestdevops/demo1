<%@ page  language="java" import="java.util.*,t4u.functions.*,t4u.beans.*,t4u.common.*" pageEncoding="utf-8"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://"+ request.getServerName() + ":" + request.getServerPort()+ path + "/";
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
 tobeConverted.add("SLNO");
 tobeConverted.add("Sweeping_Management_Summary_Report");
 tobeConverted.add("Select_Asset_type");
 tobeConverted.add("Select_Customer");
 tobeConverted.add("Asset_Number");
 tobeConverted.add("Asset_Details");
 tobeConverted.add("Asset_Type");
 tobeConverted.add("Start_Date");
 tobeConverted.add("Select_Start_Date");
 tobeConverted.add("End_Date");
 tobeConverted.add("Select_End_Date");
 tobeConverted.add("Date");
 tobeConverted.add("Total_Running_Time");
 tobeConverted.add("Total_Brush_Time");
 tobeConverted.add("Sweeping_Management_Report");
 tobeConverted.add("Clear_Filter_Data");
 tobeConverted.add("Generate_Report");
 tobeConverted.add("No_Records_Found");
 tobeConverted.add("Customer_Name");
 tobeConverted.add("End_Date_Must_Be_Greater_Than_Start_Date");
 tobeConverted.add("No_Records_Selected_Please_Select_Atleast_One_Record");
 tobeConverted.add("Excel");
 tobeConverted.add("Asset_Group");
 tobeConverted.add("Month_Validation");
 tobeConverted.add("Sweeping_Operations_Report");
    
ArrayList<String> convertedWords = new ArrayList<String>();
convertedWords = cf.getLanguageSpecificWordForKey(tobeConverted,language);

    String SLNO = convertedWords.get(0);
    String SweepingManagementSummaryReport =  convertedWords.get(1);
    String SelectAssettype =  convertedWords.get(2);
    String SelectCustomer = convertedWords.get(3);
    String AssetNumber = convertedWords.get(4);
    String AssetDetails = convertedWords.get(5);
    String AssetType = convertedWords.get(6);
    String StartDate = convertedWords.get(7);
	String SelectStartDate = convertedWords.get(8);
	String EndDate = convertedWords.get(9);
	String SelectEndDate = convertedWords.get(10);
	String Date = convertedWords.get(11);
	String TotalRunningTime = convertedWords.get(12);
	String TotalBrushTime = convertedWords.get(13);
	String SweepingManagementReport = convertedWords.get(14);
	String ClearFilterData = convertedWords.get(15);
	String GenerateReport = convertedWords.get(16);
	String NoRecordsfound= convertedWords.get(17);
	String CustomerName=convertedWords.get(18);
	String EndDateMustBeGreaterthanStartDate = convertedWords.get(19);
    String NoRecordsSelectedPleaseSelectatleastOneRecord = convertedWords.get(20);
    String Excel=convertedWords.get(21);
    String AssetGroup=convertedWords.get(22);
    String monthValidation=convertedWords.get(23);
    String SweepingOperationsReport=convertedWords.get(24);
	
%>

<jsp:include page="../Common/header.jsp" />


 		<title><%=SweepingOperationsReport%></title>		
    
	 <style>
  .x-panel-tl
	{
		border-bottom: 0px solid !important;
	}
	
  </style>
  
  <%if (loginInfo.getStyleSheetOverride().equals("Y")){%>                  
    <jsp:include page="../Common/ImportJSSandMining.jsp"/>                                               
   <%}else {%>  
   <jsp:include page="../Common/ImportJS.jsp" /><%} %>
   
   <jsp:include page="../Common/ExportJS.jsp" />
   <style>
	.x-panel-header
		{
				height: 7% !important;
		}
	.x-grid3-cell-inner,.ext-strict .x-grid3-hd-inner {
			height: 26px !important;
			padding-top: 8px;
		}
		.x-form-text {
			height: 21px !important;
		}
		label {
			display : inline !important;
		}
		.x-window-tl *.x-window-header {
			padding-top : 6px !important;
		}
		.footer {
			bottom : -18px !important;
		}
   </style>
   <script>
   var outerPanel;
	window.onload = function () { 
		refresh();
	}
  function refresh() {
      isChrome = window.chrome;
      if (isChrome && parent.flagASSET < 2) {
          setTimeout(
              function () {
                  parent.Ext.getCmp('sweepingoperationreport').enable();
                  parent.Ext.getCmp('sweepingoperationreport').show();
                  parent.Ext.getCmp('sweepingoperationreport').update("<iframe style='width:100%;height:600px;border:0;'src='<%=path%>/Jsps/WasteManagement/SweepingOperationsSummaryReport.jsp'></iframe>");
              }, 0);
          parent.UtilizationTab.doLayout();
          parent.flagASSET = parent.flagASSET + 1;
      }
  }
  /********************resize window event function***********************/
  Ext.EventManager.onWindowResize(function () {
      var width = '99%';
      var height = '100%';
      grid.setSize(width, height);
      outerPanel.setSize(width, height);
      outerPanel.doLayout();
  });
  var manageAllTasksGrid;
  var dtprev = dateprev;
  var dtcur = datecur;
  var jspName = "SweepingOperationsReport";
  var exportDataType = "int,string,date,string,number,number";
  var json="";
  var startDate="";
  var endDate="";
  var assetType="";
   //****************************** Store For Asset Type ************************************
  var assetTypeStore = new Ext.data.JsonStore({
      url: '<%=request.getContextPath()%>/WasteManagementReportAction.do?param=getAssetType',
      id: 'assetTypeId',
      root: 'assetTypeRoot',
      autoload: false,
      remoteSort: true,
      fields: ['AssetType'],

      listeners: {
          load: function () {
      }
      }

   




  });
   //****************************** Store For Asset Type Ends Here ***************************

   //****************************** Store For Customer ****************************************
  var customercombostore = new Ext.data.JsonStore({
      url: '<%=request.getContextPath()%>/CommonAction.do?param=getCustomer',
      id: 'CustomerStoreId',
      root: 'CustomerRoot',
      autoLoad: true,
      remoteSort: true,
      fields: ['CustId', 'CustName'],
      listeners: {
      
          load: function (custstore, records, success, options) {
              if ( <%= customerId %> > 0) {
                  Ext.getCmp('custcomboId').setValue('<%=customerId%>');
                  custId = Ext.getCmp('custcomboId').getValue();
                  custName = Ext.getCmp('custcomboId').getRawValue();
                   assetTypeStore.load({
                       params: {
                           CustId: custId
                       }
                   });
                  
              }
              
          }
          
          
          
          
          
      }
  });
   //****************************** Store For Customer Ends Here ************************************

   //****************************** Combo For Asset Starts Here ************************************
  var assetTypeCombo = new Ext.form.ComboBox({
      store: assetTypeStore,
      id: 'assettypecomboId',
      mode: 'local',
      forceSelection: true,
      emptyText: '<%=SelectAssettype%>',
      selectOnFocus: true,
      allowBlank: false,
      anyMatch: true,
      typeAhead: false,
      triggerAction: 'all',
      lazyRender: true,
      valueField: 'AssetType',
      displayField: 'AssetType',
      cls: 'selectstyle',
      listeners: {
          select: {
              fn: function () {

                  // Listener Logic
                  assetType = Ext.getCmp('assettypecomboId').getValue();
                  firstGridStore.load({
                      params: {
                          CustId: custId,
                          CustName: custName,
                          AssetType: assetType
                      }
                  });
                  store.load();
                 
              }
          }
      }
  });
   //****************************** Combo For Asset Ends Here ************************************
   
   //****************************** Combo For Customer Starts Here ************************************
  var custnamecombo = new Ext.form.ComboBox({
      store: customercombostore,
      id: 'custcomboId',
      mode: 'local',
      forceSelection: true,
      emptyText: '<%=SelectCustomer%>',
      selectOnFocus: true,
      allowBlank: false,
      anyMatch: true,
      typeAhead: false,
      triggerAction: 'all',
      lazyRender: true,
      valueField: 'CustId',
      displayField: 'CustName',
      cls: 'selectstyle',
      listeners: {
          select: {
              fn: function () {
                  globalAssetNumber = "";
                  custId = Ext.getCmp('custcomboId').getValue();
                  custName = Ext.getCmp('custcomboId').getRawValue();
                assetTypeStore.load({
                      params: {
                          CustId: custId


                      }
                  });
                  
                  firstGridStore.reload({
                          params: {
                              CustId: custId,
                              CustName: custName
                          }
                      });
                      
                  store.load({
                          params: {
                              CustId: custId,
                              custName: Ext.getCmp('custcomboId').getRawValue(),
                              AssetType: assetType,
                              StartDate: startDate,
                              EndDate: endDate,
                              gridData: json,
                              jspName: jspName
                          }
                      });
                  
                  

                  Ext.getCmp('assettypecomboId').reset();
                
                   // firstGridStore.reset();
                  
                   if ( <%= customerId %> > 0) {
                   
                      Ext.getCmp('custcomboId').setValue('<%=customerId%>');
                      custId = Ext.getCmp('custcomboId').getValue();
                      custName = Ext.getCmp('custcomboId').getRawValue();
                      firstGridStore.load({
                          params: {
                              CustId: custId,
                              CustName: custName
                          }
                      });

                      assetTypeStore.load({
                          params: {
                              CustId: custId
                          }
                      });

                  }
                  
              }
          }
      }
  });
   //****************************** Combo For Customer Ends Here ************************************

   //****************************** For Check Box ***************************************************
  var sm1 = new Ext.grid.CheckboxSelectionModel({
      checkOnly: true
  });
   //****************************** Check box Ends here *********************************************


   //****************************** Column Model For First Grid *************************************

  var cols1 = new Ext.grid.ColumnModel([

      new Ext.grid.RowNumberer({
          header: "<span style=font-weight:bold;><%=SLNO%></span>",
          width: 40
      }),sm1, {
          header: '<b><%=AssetNumber%></b>',
          width: 155,
          sortable: true,
          dataIndex: 'assetnumber'
      }
      

  ]);

   //****************************** Column For Grid Ends Here *******************************************


   //****************************** Reader For First Grid ***********************************************

  var reader1 = new Ext.data.JsonReader({
      root: 'managerAssetRoot',
      fields: [{
          name: 'slnoIndex'
      }, , {
          name: 'assetnumber',
          type: 'string'
      }]
  });


   //****************************** Reader For First Grid Ends Here  *****************************************


   //****************************** Filter For First Grid ***********************************************

  var filters1 = new Ext.ux.grid.GridFilters({
      local: true,
      filters: [{
              type: 'numeric',
              dataIndex: 'slnoIndex'
          }, {
              dataIndex: 'assetnumber',
              type: 'string'
          }

      ]
  });

   //****************************** FilterEn For First Grid Ends ***********************************************


   //***************************** Store For First Grid to get Asset Number ************************************

  var firstGridStore = new Ext.data.Store({
      url: '<%=request.getContextPath()%>/WasteManagementReportAction.do?param=getAssetNumber',
      bufferSize: 367,
      reader: reader1,
      autoLoad: false,
      remoteSort: true
  });


   //***************************** Store For First Grid to get Asset Number Ends Here*******************************


   //***************************** First Grid Defination Starts Here **********************************************
   var firstGrid = getSelectionModelGrid('<%=AssetDetails%>', '<%=NoRecordsfound%>', firstGridStore, 250, 400, cols1, 4, filters1, sm1);

   //***************************** First Grid Defination Ends Here **********************************************


   //***************************** Client Pannel  Starts Here **********************************************

  var clientPanel = new Ext.Panel({
      standardSubmit: true,
      collapsible: false,
      id: 'traderMaster',
      layout: 'table',
      frame: false,
      width: screen.width -20,
      height: 70,
      layoutConfig: {
          columns: 6
      },
      items: [{
              xtype: 'label',
              text: '<%=CustomerName%>' + ' :',
              cls: 'labelstyle',
              id: 'custnamelab'
          },
          custnamecombo, {
              width: 80
          }, {
              xtype: 'label',
              text: '<%=AssetType%>' + ' :',
              cls: 'labelstyle',
              id: 'assetTypelab'
          },
          assetTypeCombo, {
              width: 5
          }, {
              xtype: 'label',
              cls: 'labelstyle',
              id: 'startdatelab',
              text: '<%=StartDate%>' + ' :'
          }, {
              xtype: 'datefield',
              cls: 'selectstyle',
              width: 185,
              format: getDateFormat(),
              emptyText: '<%=SelectStartDate%>',
              allowBlank: false,
              blankText: '<%=SelectStartDate%>',
              id: 'startdate',
              value: dtprev,
              endDateField: 'enddate'
          }, {
              width: 80
          }, {
              xtype: 'label',
              cls: 'labelstyle',
              id: 'enddatelab',
              text: '<%=EndDate%>' + ' :'
          }, {
              xtype: 'datefield',
              cls: 'selectstyle',
              width: 185,
              format: getDateFormat(),
              emptyText: '<%=SelectEndDate%>',
              allowBlank: false,
              blankText: '<%=SelectEndDate%>',
              id: 'enddate',
               value: datecur,
              startDateField: 'startdate'
          }
      ]
  });


   //***************************** Client Pannel  Ends Here **********************************************



   // **********************************************Reader configs Starts******************************

  var reader = new Ext.data.JsonReader({
      idProperty: 'tripcreationId',
      root: 'SweepingManagementReportDetailsRoot',
      totalProperty: 'total',
      fields: [{
          name: 'slnoIndex1'
      }, {
          name: 'registrationNo'
      }, {
          name: 'date'
      }, {
          name: 'totalrunningtime'
      }, {
          name: 'totalbrushtime'
      }, {
          name: 'assetGroupDataindex'
      }
      ]
  });

   // **********************************************Reader configs Ends******************************

   //********************************************Store Configs For Grid*************************

  var store = new Ext.data.GroupingStore({
      autoLoad: false,
      proxy: new Ext.data.HttpProxy({
          url: '<%=request.getContextPath()%>/WasteManagementReportAction.do?param=getSweepingOperationSummaryReport',
          method: 'POST'
      }),
      remoteSort: false,
      sortInfo: {
          field: 'registrationNo',
          direction: 'ASC'
      },
      storeId: 'wastemanagementreport',
      reader: reader
  });


   //********************************************Store Configs For Grid Ends*************************


   //********************************************************************Filter Config***************

  var filters = new Ext.ux.grid.GridFilters({
      local: true,
      filters: [{
          type: 'numeric',
          dataIndex: 'slnoIndex1'
      }, {
          type: 'string',
          dataIndex: 'registrationNo'
      }, {
          type: 'date',
          dataIndex: 'date'
      }, {
          type: 'numeric',
          dataIndex: 'totalrunningtime'
      }, {
          type: 'numeric',
          dataIndex: 'totalbrushtime'
      }, {
          type: 'string',
          dataIndex: 'assetGroupDataindex'
      },]
  });


   //***************************************************Filter Config second grid Ends ***********************

   //*********************************************Column model config grid starts**********************************

  var createColModel = function (finish, start) {

      var columns = [
          new Ext.grid.RowNumberer({
              header: "<span style=font-weight:bold;><%=SLNO%></span>",
              width: 50
          }), {
              dataIndex: 'slnoIndex1',
              hidden: true,
              header: "<span style=font-weight:bold;><%=SLNO%></span>",
              filter: {
                  type: 'numeric'
              }
          }, {
              header: "<span style=font-weight:bold;><%=AssetNumber%></span>",
              dataIndex: 'registrationNo',
              width: 30,
              filter: {
                  type: 'string'
              }
          }, {
              header: "<span style=font-weight:bold;><%=Date%></span>",
              dataIndex: 'date',
              width: 30,
              filter: {
                  type: 'date'
              }
          }, {
              header: "<span style=font-weight:bold;><%=AssetGroup%></span>",
              dataIndex: 'assetGroupDataindex',
              width: 30,
              filter: {
                  type: 'string'
              }
          }, 
          
            {
              header: "<span style=font-weight:bold;><%=TotalRunningTime%></span>",
              dataIndex: 'totalrunningtime',
              decimalPrecision: 2,
              width: 50,
              filter: {
                  type: 'numeric'
              }
          }, {
              header: "<span style=font-weight:bold;><%=TotalBrushTime%></span>",
              dataIndex: 'totalbrushtime',
              decimalPrecision: 2,
              width: 50,
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


   //*********************************************Column model config grid Ends***************************

  grid = getGrid('  ', '<%=NoRecordsfound%>', store, screen.width - 290, 390, 7, filters, '<%=ClearFilterData%>', false, '', 14, false, '', false, '', true, '<%=Excel%>', jspName, exportDataType, true, 'PDF');

   //**************************** Pannel For First Grid Ends Here **************************************

  var secondGridPanel = new Ext.Panel({
      standardSubmit: true,
      collapsible: false,
      id: 'secondPanelId',
      layout: 'table',
      frame: true,
      width: 1100,
      height: 400,
      layoutConfig: {
          columns: 1
      },
      items: [grid]

  });


   //****************************    Pannel For Second Grid   ********************************************




   //**************************** Pannel For First Grid Starts Here **************************************


  var manageAllTasksPanel = new Ext.Panel({
      standardSubmit: true,
      collapsible: false,
      id: 'vesselPanelId',
      layout: 'table',
      frame: false,
      width:'100%',
      height: 410,
      layoutConfig: {
          columns: 2
      },
      items: [firstGrid, secondGridPanel]

  });

  var allButtonsPannel = new Ext.Panel({
      standardSubmit: true,
      collapsibli: false,
      id: 'buttonpannelid',
      layout: 'table',
      frame: false,
      width: 180,
      height: 30,
      layoutConfig: {
          columns: 3
      },
      items: [{
          width: 80
      }, {
          xtype: 'button',
          text: '<%=GenerateReport%>',
          id: 'generateReport',
          cls: 'buttonwastemanagement',
          width: 100,
          listeners: {
              click: {
                  fn: function () {
                      //Action for Button
                      if (Ext.getCmp('custcomboId').getValue() == "") 
                      {
                          Ext.example.msg("<%=SelectCustomer%>");
                          Ext.getCmp('custcomboId').focus();
                          return;
                      }

                      if (Ext.getCmp('assettypecomboId').getValue() == "") 
                      {
                          Ext.example.msg("<%=SelectAssettype%>");
                          Ext.getCmp('assettypecomboId').focus();
                          return;
                      }

                      if (Ext.getCmp('startdate').getValue() == "") 
                      {
                          Ext.example.msg("<%=SelectStartDate%>");
                          Ext.getCmp('startdate').focus();
                          return;
                      }

                      if (Ext.getCmp('enddate').getValue() == "") 
                      {
                          Ext.example.msg("<%=SelectEndDate%>");
                          Ext.getCmp('enddate').focus();
                          return;
                      }

                      if (dateCompare(Ext.getCmp('startdate').getValue(), Ext.getCmp('enddate').getValue()) == -1) 
                      {
                          Ext.example.msg("<%=EndDateMustBeGreaterthanStartDate%>");        
                          Ext.getCmp('enddate').focus();
                          return;
                      }
                      
                      if(checkMonthValidation(Ext.getCmp('startdate').getValue(),Ext.getCmp('enddate').getValue()))
            		  {
            		      Ext.example.msg("<%=monthValidation%>");
           		   	 	  Ext.getCmp('enddate').focus(); 
               			  return;
            		  }
                      
                       
                      var startDate = Ext.getCmp('startdate').getValue();

                      var endDate = Ext.getCmp('enddate').getValue();

                      var assetType = Ext.getCmp('assettypecomboId').getValue();

                      var gridData = "";
                      var json = "";
                      var records1 = firstGrid.getSelectionModel().getSelections();
                      for (var i = 0; i < records1.length; i++) {
                          var record1 = records1[i];
                          var row = firstGrid.store.findExact('slnoIndex', record1.get('slnoIndex'));
                          var store1 = firstGrid.store.getAt(row);
                          json = json + Ext.util.JSON.encode(store1.data) + ',';
                      }

                      if (firstGrid.getSelectionModel().getCount() == 0) 
                      {
                           Ext.example.msg("<%=NoRecordsSelectedPleaseSelectatleastOneRecord%>");
                           return;
                      }

                      store.load({
                          params: {
                              CustId: custId,
                              custName: Ext.getCmp('custcomboId').getRawValue(),
                              AssetType: assetType,
                              StartDate: startDate,
                              EndDate: endDate,
                              gridData: json,
                              jspName: jspName
                          }
                      });
                  }
              }
          }
      }, {
          width: 10
      }]
  });



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
          height:545,
          width:screen.width-25,
          layout: 'table',
          layoutConfig: {
              columns: 1
          },
          items: [clientPanel, manageAllTasksPanel, allButtonsPannel]
          //bbar: ctsb
      });
      sb = Ext.getCmp('form-statusbar');

  }); </script>
 <jsp:include page="../Common/footer.jsp" />
 <!-- </body>   -->
 <!-- </html> -->