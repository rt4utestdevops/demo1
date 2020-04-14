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
    int userId=loginInfo.getUserId();
String userAuthority=cf.getUserAuthority(systemId,userId);

String modifybutton="";

if(loginInfo.getIsLtsp() == 0 && userAuthority.equalsIgnoreCase("Admin"))
	    {
		  modifybutton = "true";
    	}else
	       {
			  modifybutton = "false";
	        }


	
ArrayList<String> tobeConverted = new ArrayList<String>();
  tobeConverted.add("Waste_Management_Summary_Report");
  tobeConverted.add("Select_Asset_type");
  tobeConverted.add("Select_Customer");
  tobeConverted.add("SLNO");
  tobeConverted.add("Asset_Number");
  tobeConverted.add("Asset_Details");
  tobeConverted.add("Customer_Name");
  tobeConverted.add("Asset_Type");
  tobeConverted.add("Start_Date");
  tobeConverted.add("End_Date");
  tobeConverted.add("Select_End_Date");
  tobeConverted.add("Date");
  tobeConverted.add("Asset_Group");
  tobeConverted.add("Total_Running_Time");
  tobeConverted.add("Total_Weight_Carried");
  tobeConverted.add("No_Records_Found");
  tobeConverted.add("Clear_Filter_Data");
  tobeConverted.add("Select_Start_Date");
  tobeConverted.add("End_Date_Must_Be_Greater_Than_Start_Date");
  tobeConverted.add("No_Records_Selected_Please_Select_Atleast_One_Record");
  tobeConverted.add("Generate_Report");
  tobeConverted.add("Excel");
  tobeConverted.add("Month_Validation");  
  tobeConverted.add("Daily_Waste_Management_Summary_Report");
  
   tobeConverted.add("Enter_Remarks");
   tobeConverted.add("Enter_Total_Weight_Carried");
   tobeConverted.add("Select_Customer_Name");
   tobeConverted.add("No_Rows_Selected");
   tobeConverted.add("Select_Single_Row");
   tobeConverted.add("Modify");
   tobeConverted.add("Modify_Details");
   tobeConverted.add("Validate_Mesg_For_Form");
   tobeConverted.add("Remarks");
   tobeConverted.add("Cancel");
   tobeConverted.add("Save");
   tobeConverted.add("Waste_Management_Summary_Details");
     
     
ArrayList<String> convertedWords = new ArrayList<String>();
 convertedWords = cf.getLanguageSpecificWordForKey(tobeConverted,language);
 String WasteManagementSummaryReport = convertedWords.get(0);
 String SelectAssettype = convertedWords.get(1);
 String SelectCustomer = convertedWords.get(2);
 String SLNO = convertedWords.get(3);
 String AssetNumber = convertedWords.get(4);
 String AssetDetails = convertedWords.get(5);
 String CustomerName = convertedWords.get(6);
 String AssetType = convertedWords.get(7);
 String StartDate = convertedWords.get(8);
 String EndDate = convertedWords.get(9);
 String SelectEndDate = convertedWords.get(10);
 String Date = convertedWords.get(11);
 String AssetGroup = convertedWords.get(12);
 String TotalRunningTime = convertedWords.get(13);
 String TotalWeightCarried = convertedWords.get(14);
 String NoRecordsfound = convertedWords.get(15);
 String ClearFilterData = convertedWords.get(16);
 String SelectStartDate = convertedWords.get(17);
 String EndDateMustBeGreaterthanStartDate = convertedWords.get(18);
 String NoRecordsSelectedPleaseSelectatleastOneRecord = convertedWords.get(19);
 String GenerateReport = convertedWords.get(20);
 String Excel=convertedWords.get(21);
 String monthValidation=convertedWords.get(22);
 String DailyWasteManagementSummaryReport=convertedWords.get(23);
    
 String EnterRemarks = convertedWords.get(24);
 String EnterTotalWeightCarried = convertedWords.get(25);
 String SelectCustomerName = convertedWords.get(26);
 String NoRowsSelected = convertedWords.get(27);
 String SelectSingleRow=convertedWords.get(28);
 String Modify=convertedWords.get(29);
 String ModifyDetails=convertedWords.get(30);
 String validateMessage = convertedWords.get(31);
 String Remarks = convertedWords.get(32);
 String Cancel = convertedWords.get(33);
 String Save = convertedWords.get(34);
 String WasteManagementSummaryDetails = convertedWords.get(35);
%>

<jsp:include page="../Common/header.jsp" />

 
 		<title><%=DailyWasteManagementSummaryReport%></title>		
    
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
			bottom : -14px !important;
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
                   parent.Ext.getCmp('dailywastemanagement').enable();
                   parent.Ext.getCmp('dailywastemanagement').show();
                   parent.Ext.getCmp('dailywastemanagement').update("<iframe style='width:100%;height:600px;border:0;'src='<%=path%>/Jsps/WasteManagement/WasteManagementSummaryReport.jsp'></iframe>");
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
   var jspName = "DailyWasteManagementSummaryReport";
   var exportDataType = "int,string,date,string,number,number,number";
   var json="";
   var titelForInnerPanel="Summary Details";
   var gridData = "";

   var assetTypeStore = new Ext.data.JsonStore({
       url: '<%=request.getContextPath()%>/WasteManagementReportAction.do?param=getAssetType',
       id: 'assetTypeId',
       root: 'assetTypeRoot',
       autoload: false,
       remoteSort: true,
       fields: ['AssetType'],

       listeners: {
           load: function () {}
       }

   });

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
                   
                  store.load();
                   Ext.getCmp('assettypecomboId').reset();

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
                       
                       store.load();
  
                   }

               }
           }
       }
   });

   var sm1 = new Ext.grid.CheckboxSelectionModel({
       checkOnly: true
   });

   var cols1 = new Ext.grid.ColumnModel([

       new Ext.grid.RowNumberer({
           header: "<span style=font-weight:bold;><%=SLNO%></span>",
           width: 40
       }), sm1, {
           header: '<b><%=AssetNumber%></b>',
           width: 155,
           sortable: true,
           dataIndex: 'assetnumber'
       }
      

   ]);

   var reader1 = new Ext.data.JsonReader({
       root: 'managerAssetRoot',
       fields: [{
           name: 'slnoIndex'
       }, , {
           name: 'assetnumber',
           type: 'string'
       }]
   });

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

   var firstGridStore = new Ext.data.Store({
       url: '<%=request.getContextPath()%>/WasteManagementReportAction.do?param=getAssetNumber',
       bufferSize: 367,
       reader: reader1,
       autoLoad: false,
       remoteSort: true
   });

   var firstGrid = getSelectionModelGrid('<%=AssetDetails%>', '<%=NoRecordsfound%>', firstGridStore, 250, 400, cols1, 4, filters1, sm1);


   var clientPanel = new Ext.Panel({
       standardSubmit: true,
       collapsible: false,
       id: 'traderMaster',
       layout: 'table',
       frame: false,
       width: screen.width - 32,
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
               emptyText: 'SelectStartDate',
               allowBlank: false,
               blankText: 'SelectStartDate',
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

   var reader = new Ext.data.JsonReader({
       idProperty: 'tripcreationId',
       root: 'WasterManagementRoot',
       totalProperty: 'total',
       fields: [{
           name: 'slnoIndex1'
       }, {
           name: 'registrationNoDataIndex'
       }, {
           name: 'dateDataIndex'
       }, {
           name: 'assetGroupDataIndex'
       }, {
           name: 'totalRunningTimeDataIndex'
       }, {
           name: 'totalWeightCarriedDataIndex'
       },{
           name: 'uniqueIdDataIndex'
       },{
           name: 'remarksDataIndex'
       }]
   });

   var store = new Ext.data.GroupingStore({
       autoLoad: false,
       proxy: new Ext.data.HttpProxy({
           url: '<%=request.getContextPath()%>/WasteManagementReportAction.do?param=getWasteManagementSummaryReport',
           method: 'POST'
       }),
       remoteSort: false,
       sortInfo: {
           field: 'registrationNoDataIndex',
           direction: 'ASC'
       },
       storeId: 'wastemanagementreport',
       reader: reader
   });

   var filters = new Ext.ux.grid.GridFilters({
       local: true,
       filters: [{
           type: 'numeric',
           dataIndex: 'slnoIndex1'
       }, {
           type: 'string',
           dataIndex: 'registrationNoDataIndex'
       }, {
           type: 'date',
           dataIndex: 'dateDataIndex'
       }, {
           type: 'string',
           dataIndex: 'assetGroupDataIndex'
       }, {
           type: 'numeric',
           dataIndex: 'totalRunningTimeDataIndex'
       }, {
           type: 'numeric',
           dataIndex: 'totalWeightCarriedDataIndex'
       },{
           type: 'numeric',
           dataIndex: 'uniqueIdDataIndex'
       }]
   });

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
               dataIndex: 'registrationNoDataIndex',
               width: 30,
               filter: {
                   type: 'string'
               }
           }, {
               header: "<span style=font-weight:bold;><%=Date%></span>",
               dataIndex: 'dateDataIndex',
               width: 30,
               filter: {
                   type: 'date'
               }
           }, {
               header: "<span style=font-weight:bold;><%=AssetGroup%></span>",
               dataIndex: 'assetGroupDataIndex',
               hidden: false,
               width: 30,
               filter: {
                   type: 'string'
               }
           }, {
               header: "<span style=font-weight:bold;><%=TotalRunningTime%></span>",
               dataIndex: 'totalRunningTimeDataIndex',
               decimalPrecision: 2,
               width: 50,
               filter: {
                   type: 'numeric'
               }
           }, {
               header: "<span style=font-weight:bold;><%=TotalWeightCarried%></span>",
               dataIndex: 'totalWeightCarriedDataIndex',
               decimalPrecision: 2,
               width: 50,
               filter: {
                   type: 'numeric'
               }
           }, {
               header: "<span style=font-weight:bold;>Unique Id</span>",
               dataIndex: 'uniqueIdDataIndex',
               hidden:true,
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
//----------------------------------------------------------MODIFY---------------------------------------------------------------------------------------------------------------------//

var innerPanelForWasteSummary = new Ext.form.FormPanel({
    standardSubmit: true,
    collapsible: false,
    autoScroll: true,
    height: 280,
    width: 470,
    frame: true,
    id: 'innerPanelForWasteSummaryId',
    layout: 'table',
    layoutConfig: {
        columns: 4
    },
    items: [{
        xtype: 'fieldset',
        title: '<%=WasteManagementSummaryDetails%>',
        cls: 'fieldsetpanel',
        collapsible: false,
        colspan: 3,
        id: 'wasteSummaryId',
        width: 450,
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
            text: '',
            cls: 'mandatoryfield',
            id: 'assetNumberEmptyId'
        }, {
            xtype: 'label',
            text: '<%=AssetNumber%>' + ' :',
            cls: 'labelstyle',
            id: 'assetNumberLabelId'
        }, {
            xtype: 'textfield',
            cls: 'selectstylePerfect',
            allowBlank: false,
            labelSeparator: '',
             id: 'assetNumberId'
        }, 



		{
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'dateEmptyId'
        }, {
            xtype: 'label',
            text: '<%=Date%>' + ' :',
            cls: 'labelstyle',
            id: 'dateLabelId'
        },{
            xtype: 'datefield',
                  cls: 'selectstylePerfect',
                  format: getDateFormat(),
            allowBlank: false,
            labelSeparator: '',
            id: 'dateId'
        }, 
		
		 {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'assetGroupEmptyId'
        }, {
            xtype: 'label',
            text: '<%=AssetGroup%>' + ' :',
            cls: 'labelstyle',
            id: 'assetGroupLabelId'
        },{
            xtype: 'textfield',
            cls: 'selectstylePerfect',
            allowBlank: false,
            labelSeparator: '',
            id: 'assetGroupId'
        }, 


        {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'totalRunningTimeEmptyId'
        }, {
            xtype: 'label',
            text: '<%=TotalRunningTime%>' + ' :',
            cls: 'labelstyle',
            id: 'totalRunningTimeLabelId'
        },{
            xtype: 'textfield',
            cls: 'selectstylePerfect',
            allowBlank: false,
            labelSeparator: '',
            id: 'totalRunningTimeId'
        }, 
		{
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'weightEmptyId'
        }, {
            xtype: 'label',
            text: '<%=TotalWeightCarried%>' + ' :',
            cls: 'labelstyle',
            id: 'totalWeightCarriedLabelId'
        },{
            xtype: 'textfield',
            cls: 'selectstylePerfect',
            allowBlank: false,
           // minValue: 1,
            regex:/^\d+(\.\d+)?$/,
            labelSeparator: '',
            id: 'totalWeightId'
        }, 
		
		
		{
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'remarksEmptyId'
        }, {
            xtype: 'label',
            text: '<%=Remarks%>' + ' :',
            cls: 'labelstyle',
            id: 'remarksLabelId'
        }, {
            xtype: 'textarea',
            cls:'selectstylePerfect',
			allowBlank: false,
	    	emptyText:'<%=EnterRemarks%>',
            id: 'remarksId'
        }]
    }]
});
var innerWinButtonPanel = new Ext.Panel({
    id: 'innerWinButtonPanelId',
    standardSubmit: true,
    collapsible: false,
    autoHeight: true,
    height: 80,
    width: 470,
    frame: true,
    layout: 'table',
    layoutConfig: {
        columns: 4
    },
    buttons: [{
        xtype: 'button',
        text: '<%=Save%>',
        id: 'saveButtonId',
        iconCls:'savebutton',
        cls: 'buttonstyle',
        width: 70,
        listeners: {
            click: {
                fn: function () {
                    if (Ext.getCmp('totalWeightId').getValue() == "" || Ext.getCmp('totalWeightId').getValue() == 0 ) {
                        Ext.example.msg("<%=EnterTotalWeightCarried%>");
                        return;
                    }
					
					
                    if (Ext.getCmp('remarksId').getValue() == "") {
                    Ext.example.msg("<%=EnterRemarks%>");
                    return;
                    }
                    
                      var startDate = Ext.getCmp('startdate').getValue();

                       var endDate = Ext.getCmp('enddate').getValue();

                       var assetType = Ext.getCmp('assettypecomboId').getValue();
                    
                    
                    //var gridData = "";
                       var json1 = "";
                       var records11 = firstGrid.getSelectionModel().getSelections();
                       for (var i = 0; i < records11.length; i++) {
                           var record11 = records11[i];
                           var row1 = firstGrid.store.findExact('slnoIndex', record11.get('slnoIndex'));
                           var store11 = firstGrid.store.getAt(row1);
                           json1 = json1 + Ext.util.JSON.encode(store11.data) + ',';
                       }
                    
                    
                        if (innerPanelForWasteSummary.getForm().isValid()) {   
                        wasteSummaryOuterPanelWindow.getEl().mask();
                        var selected = grid.getSelectionModel().getSelected();
                        var uniqueId = selected.get('uniqueIdDataIndex');
                        Ext.Ajax.request({
                            url: '<%=request.getContextPath()%>/WasteManagementReportAction.do?param=modifywasteManagementInformation',
                            method: 'POST',
                            params: {
                                uniqueId: uniqueId,
                                totalWeightCarried: Ext.getCmp('totalWeightId').getValue(),
                                remarks: Ext.getCmp('remarksId').getValue()
                                
                            },
                            success: function (response, options) {
                                var message = response.responseText;
                                Ext.example.msg(message);
                                myWin.hide();
                                wasteSummaryOuterPanelWindow.getEl().unmask();
                                 store.load({
                           params: {
                               CustId: custId,
                               custName: Ext.getCmp('custcomboId').getRawValue(),
                               AssetType: assetType,
                               StartDate: startDate,
                               EndDate: endDate,
                               gridData: json1,
                               jspName: jspName
                           }
                       });
                            },
                            failure: function () {
                            Ext.example.msg("Error");
                                
                                myWin.hide();
                            }
                        });
                        }else{
						Ext.example.msg("<%=validateMessage%>");
					}
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
                fn: function () {
                    myWin.hide();
                }
            }
        }
    }]
});
var wasteSummaryOuterPanelWindow = new Ext.Panel({
    width: 490,
    height: 360,
    standardSubmit: true,
    frame: true,
    items: [innerPanelForWasteSummary, innerWinButtonPanel]
});
myWin = new Ext.Window({
    title: titelForInnerPanel,
    closable: false,
    resizable: false,
    modal: true,
    autoScroll: false,
    height: 405,
    width: 490,
    id: 'myWin',
    items: [wasteSummaryOuterPanelWindow]
});


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
    myWin.setPosition(530, 100);
    myWin.setTitle(titelForInnerPanel);
    myWin.show();
    Ext.getCmp('assetNumberId').disable();
    Ext.getCmp('dateId').disable();
    Ext.getCmp('assetGroupId').disable();
    Ext.getCmp('totalRunningTimeId').disable();
    
                 
    var selected = grid.getSelectionModel().getSelected();
    Ext.getCmp('assetNumberId').setValue(selected.get('registrationNoDataIndex'));
    Ext.getCmp('dateId').setValue(selected.get('dateDataIndex'));
    Ext.getCmp('assetGroupId').setValue(selected.get('assetGroupDataIndex'));
    Ext.getCmp('totalRunningTimeId').setValue(selected.get('totalRunningTimeDataIndex'));
    Ext.getCmp('totalWeightId').setValue(selected.get('totalWeightCarriedDataIndex'));
    Ext.getCmp('remarksId').setValue(selected.get('remarksDataIndex'));
}





   grid = getGrid('<%=DailyWasteManagementSummaryReport%>', '<%=NoRecordsfound%>', store, screen.width - 290, 390, 8, filters, '<%=ClearFilterData%>', false, '', 14, false, '', false, '', true, '<%=Excel%>', jspName, exportDataType, true, 'PDF',false, 'Add', <%=modifybutton%>, '<%=Modify%>');
   

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

   var manageAllTasksPanel = new Ext.Panel({
       standardSubmit: true,
       collapsible: false,
       id: 'vesselPanelId',
       layout: 'table',
       frame: false,
       width: '100%',
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
                       if (Ext.getCmp('custcomboId').getValue() == "") {
                           Ext.example.msg("<%=SelectCustomer%>");
                           Ext.getCmp('custcomboId').focus();
                           return;
                       }

                       if (Ext.getCmp('assettypecomboId').getValue() == "") {
                           Ext.example.msg("<%=SelectAssettype%>");
                           Ext.getCmp('assettypecomboId').focus();
                           return;
                       }

                       if (Ext.getCmp('startdate').getValue() == "") {
                           Ext.example.msg("<%=SelectStartDate%>");
            		 	   Ext.getCmp('startdate').focus();
                           return;
                       }

                       if (Ext.getCmp('enddate').getValue() == "") {
                           Ext.example.msg("<%=SelectEndDate%>");
            		 	   Ext.getCmp('enddate').focus();
                           return;
                       }

                       if (dateCompare(Ext.getCmp('startdate').getValue(), Ext.getCmp('enddate').getValue()) == -1) {
                          
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

                     //  var gridData = "";
                       var json = "";
                       var records1 = firstGrid.getSelectionModel().getSelections();
                       for (var i = 0; i < records1.length; i++) {
                           var record1 = records1[i];
                           var row = firstGrid.store.findExact('slnoIndex', record1.get('slnoIndex'));
                           var store1 = firstGrid.store.getAt(row);
                           json = json + Ext.util.JSON.encode(store1.data) + ',';
                       }

                       if (firstGrid.getSelectionModel().getCount() == 0) {
                           
                           
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
           width:screen.width-25,
           height:545,
           cls: 'outerpanel',
           layout: 'table',
           layoutConfig: {
               columns: 1
           },
           items: [clientPanel, manageAllTasksPanel, allButtonsPannel]
          // bbar: ctsb
       });
       sb = Ext.getCmp('form-statusbar');

   });
   </script>
  <jsp:include page="../Common/footer.jsp" />
 <!-- </body>   -->
 <!-- </html> -->