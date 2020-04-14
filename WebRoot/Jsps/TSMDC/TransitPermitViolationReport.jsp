<%@ page  language="java" import="java.util.*,java.text.SimpleDateFormat,t4u.functions.*,t4u.beans.*,t4u.common.*" pageEncoding="utf-8"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://"+ request.getServerName() + ":" + request.getServerPort()+ path + "/";
	if(request.getParameter("list")!=null)
	{
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
	
	ArrayList<String> tobeConverted=new ArrayList<String>();	
	tobeConverted.add("Trip_Summary_Report");
	tobeConverted.add("Customer_Name");
	tobeConverted.add("Select_Customer");
	
	tobeConverted.add("SLNO");
	tobeConverted.add("Next");		
	tobeConverted.add("No_Records_Found");
	tobeConverted.add("Clear_Filter_Data");
	tobeConverted.add("Select_Single_Row");
	tobeConverted.add("Excel");
	tobeConverted.add("PDF");
	
	tobeConverted.add("Total_Kms_By_Veh_ODO");		
	tobeConverted.add("Total_Kms_By_GPS");
	tobeConverted.add("No_Of_Points_Visited");
	tobeConverted.add("Total_Trip_Hrs");
	tobeConverted.add("Trip_Start_Veh_ODO");
	tobeConverted.add("Trip_End_Veh_ODO");
	tobeConverted.add("Trip_Start_Date_Time");
    tobeConverted.add("Trip_End_Date_Time");
    
    tobeConverted.add("Trip_No");
	tobeConverted.add("Vehicle_No");
	
	tobeConverted.add("Month_Validation");
    tobeConverted.add("Select_Start_Date");
    tobeConverted.add("Select_End_Date");
    tobeConverted.add("View");
    
	tobeConverted.add("Driver_Name");
	tobeConverted.add("Custodian_Name");
	tobeConverted.add("Gunman_Name");
	
	tobeConverted.add("Hub");
	tobeConverted.add(" Route");
	tobeConverted.add("Region");
	tobeConverted.add("Location");		
	tobeConverted.add("End_Date_Must_Be_Greater_Than_Start_Date");
	
	ArrayList<String> convertedWords=new ArrayList<String>();
	convertedWords=cf.getLanguageSpecificWordForKey(tobeConverted, language);	
	
	String TripSummaryReport = convertedWords.get(0);	
	String CustomerName = convertedWords.get(1);
	String SelectCustomer = convertedWords.get(2);
	
	String SlNo = convertedWords.get(3);
	String Next = convertedWords.get(4);	
	String NoRecordsFound = convertedWords.get(5);
	String ClearFilterData = convertedWords.get(6);
	String SelectSingleRow = convertedWords.get(7); 
	String Excel = convertedWords.get(8); 
	String PDF = convertedWords.get(9); 	
	
	String TotalKmsByOdometer=convertedWords.get(10);
	String TotalDistance=convertedWords.get(11); 	
	String VisistedPoints=convertedWords.get(12); 	
	String TotalTripHrs=convertedWords.get(13); 	
	String TripStartVehODO=convertedWords.get(14); 	
	String TripEndVehODO=convertedWords.get(15); 	
	String TripStartDate=convertedWords.get(16); 	
	String TripEndDate=convertedWords.get(17); 	

	String TripNo=convertedWords.get(18); 	
	String VehicleNo=convertedWords.get(19); 	
	String MonthValidation=convertedWords.get(20); 	
	String SelectStartDate=convertedWords.get(21); 	
	String SelectEndDate=convertedWords.get(22); 	
	String View=convertedWords.get(23); 	
	
    String DriverName=convertedWords.get(24); 	
	String CustodianName=convertedWords.get(25); 	
    String Gunman=convertedWords.get(26); 	
    String Hub=convertedWords.get(27); 	
    String Route=convertedWords.get(28); 	
    String Region=convertedWords.get(29); 	
    String Location=convertedWords.get(30); 
    String EndDateMustBeGreaterthanStartDate = convertedWords.get(31);

%>
<!DOCTYPE HTML>
<html>
 <head>
 		<title>Tsmdc Summary Report</title>		
</head>	    
	 <style>
  .x-panel-tl
	{
		border-bottom: 0px solid !important;
	}
	.x-tab-strip-inner
	{
		width: 160px !important;
	}
  </style>
  <body>
   <%if (loginInfo.getStyleSheetOverride().equals("Y")){%>
	<jsp:include page="../Common/ImportJSSandMining.jsp"/>
	<%}else{%>
	<jsp:include page="../Common/ImportJS.jsp" /><%}%>
   <jsp:include page="../Common/ExportJS.jsp" />
   
<script>

	var summaryGrid;
	var myWin;
	var buttonValue;
	var uniqueId;
	var closewin;
	var outerPanel;
	var AssetNo;
 	var jspName='Transit_Validity_Violation_Report';
   	var exportDataType = "int,string,string,string,string,date,number,number,date,string,string";
    var dtprev = dateprev;
	var dtcur = datecur;
	var dtnxt = datenext;
	var reportTypeId;

   	 //*********************** Store For Customer *****************************************//
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
            }
        }
    }
});

//************************ Combo for Customer Starts Here***************************************//
	var custnamecombo = new Ext.form.ComboBox({
    store: customercombostore,
    id: 'custcomboId',
    mode: 'local',
    forceSelection: true,
    emptyText: 'Please Select Customer',
    selectOnFocus: true,
    resizable: true,
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
            fn: function () {
                custId = Ext.getCmp('custcomboId').getValue();
                                                                  
            }
        }
    }
	});
	
	var reportTypeStore =  new Ext.data.SimpleStore({
	  							 id:'reportTypeStoreId',
	  							 autoLoad: true,
	  							 fields: ['reportTypeId', 'reportTyeName'],
	  							 data: [['1', 'Transit Pass Validity Violation'], ['2', 'Transit Pass Quantity Violation']]
							}); 
		
	var reportTypecombo = new Ext.form.ComboBox({
	    store: reportTypeStore,
	    id: 'reportcomboId',
	    mode: 'local',
	    forceSelection: true,
	    emptyText: 'Please Select Report Type',
	    selectOnFocus: true,
	    resizable: true,
	    allowBlank: false,
	    anyMatch: true,
	    typeAhead: false,
	    triggerAction: 'all',
	    lazyRender: true,
	    valueField: 'reportTypeId',
	    displayField: 'reportTyeName',
	    cls: 'selectstylePerfect1',
	    listeners: {
	        select: {
	            fn: function () {
	                reportTypeId = Ext.getCmp('reportcomboId').getValue();
	                                                                  
	            }
	        }
	    }
		});
	
	var innerPanel = new Ext.Panel({
        standardSubmit: true,
        collapsible: false,
        title:'',
        id: 'panelId',
        layout: 'table',
        frame: true,
        layoutConfig: {
            columns: 14
        },
		items: [{
                xtype: 'label',
                text: '<%=CustomerName%>' + ' :',
                cls: 'labelstyle',
                id: 'custnamelab'
       },
            custnamecombo,
            {width:'30px'},
        {
            xtype: 'label',
            text: 'Start Date' + ' :',
            cls: 'labelstyle',
            id: 'StartDtLabelId'
        }, {
            xtype: 'datefield',
            cls: 'selectstylePerfect',
            format: getDateFormat(),
            value:dtprev,
            id: 'StartDtId'
        }, {width:'30px'},{
            xtype: 'label',
            text: 'End Date' + ' :',
            cls: 'labelstyle',
            id: 'EndDtLabelId'
        },{
            xtype: 'datefield',
            cls: 'selectstylePerfect',
            format: getDateFormat(),
            value:dtcur,
            id: 'EndDtId'
        },{width:'30px'},
        {
            xtype: 'label',
            text: 'Reoprt Type' + ' :',
            cls: 'labelstyle',
            id: 'reportTypelab'
       },reportTypecombo,
       {width:'30px'},{
  		        xtype: 'button',
  		        text: '<%=View%>',
  		        id: 'addbuttonid',
  		        cls: ' ',
  		        width: 80,
  		        listeners: {
  		                click: {
  		                    fn: function () {
  		                        if (Ext.getCmp('custcomboId').getValue() == "") {
  		                            Ext.example.msg("<%=SelectCustomer%>");
  		                            Ext.getCmp('custcomboId').focus();
  		                            return;
  		                        }
  		                        if (Ext.getCmp('StartDtId').getValue() == "") {
  		                            Ext.example.msg("<%=SelectStartDate%>");
  		                            Ext.getCmp('StartDtId').focus();
  		                            return;
  		                        }
  		                        if (Ext.getCmp('EndDtId').getValue() == "") {
  		                            Ext.example.msg("<%=SelectEndDate%>");
  		                            Ext.getCmp('EndDtId').focus();
  		                            return;
  		                        }
  		                        var startdates = Ext.getCmp('StartDtId').getValue();
  		                        var enddates = Ext.getCmp('EndDtId').getValue();
  		                        
  		                      if (dateCompare(startdates,enddates) == -1) {
                             Ext.example.msg("<%=EndDateMustBeGreaterthanStartDate%>");
                             Ext.getCmp('EndDtId').focus();
                             return;
                               }
                                if (checkMonthValidation(startdates, enddates)) {
  		                            Ext.example.msg("<%=MonthValidation%>");
  		                            Ext.getCmp('EndDtId').focus();
  		                            return;
  		                        }
  		                        if (Ext.getCmp('reportcomboId').getValue() == "") {
  		                            Ext.example.msg("Select Report Type");
  		                            Ext.getCmp('reportcomboId').focus();
  		                            return;
  		                        }
  		                        SummaryReportStore.load({
                                    params: {
                                        CustId: Ext.getCmp('custcomboId').getValue(),
                                        CustName : Ext.getCmp('custcomboId').getRawValue(),
  		                                startDate: Ext.getCmp('StartDtId').getValue(),
  		                                endDate: Ext.getCmp('EndDtId').getValue(),
  		                                reportType: Ext.getCmp('reportcomboId').getValue(),
 		                                jspName:jspName
                                    }
                                });  
  		                    }
  		                }
  		            }
  		    }
		
		
		]
    }); // End of Panel	
	
	
	var reader = new Ext.data.JsonReader({
        idProperty: 'readerId',
        root: 'TransitValidityViolationRoot',
        totalProperty: 'total',
        fields: [{
            name: 'slnoIndex'
        },{
            name: 'orderIdDataIndex'
        },{
            name: 'customerDataIndex'
        },{
            name: 'transitPermitDataIndex'
        },{
            name: 'vehicleNoDataIndex'
        },{
            name: 'transitDateDataIndex'
        },{
            name: 'transitQtyDataIndex'
        },{
            name: 'weighBridgeQtyDataIndex'
        },{
            name: 'weighBridgeDateDataIndex',
        },{
            name: 'timeDiffDataIndex',
        },{
            name: 'weightDiffDataIndex',
        }]
    });

    var SummaryReportStore = new Ext.data.GroupingStore({
        autoLoad: false,
        proxy: new Ext.data.HttpProxy({
            url: '<%=request.getContextPath()%>/SandTSMDCAction.do?param=getTransitViolationDetails',
            method: 'POST'
        }),
        remoteSort: false,
        storeId: 'weightStoreId',
        reader: reader
    });

    var filters = new Ext.ux.grid.GridFilters({
        local: true,
        filters: [{
            type: 'numeric',
            dataIndex: 'slnoIndex'
        }, {
            type: 'string',
            dataIndex: 'orderIdDataIndex'
        },  {
            type: 'string',
            dataIndex: 'customerDataIndex'
        }, {
            type: 'string',
            dataIndex: 'transitPermitDataIndex'
        },  {
            type: 'string',
            dataIndex: 'vehicleNoDataIndex'
        },  {
            type: 'date',
            dataIndex: 'transitDateDataIndex'
        }, {
            type: 'numeric',
            dataIndex: 'transitQtyDataIndex'
        }, {
            type: 'numeric',
            dataIndex: 'weighBridgeQtyDataIndex'
        }, {
            type: 'date',
            dataIndex: 'weighBridgeDateDataIndex'
        }, {
            type: 'numeric',
            dataIndex: 'timeDiffDataIndex'
        }, {
            type: 'string',
            dataIndex: 'weightDiffDataIndex'
        }]
    });
    
   //************************************Column Model Config******************************************
    var createColModel = function (finish, start) {

        var columns = [
            new Ext.grid.RowNumberer({
                header: "<span style=font-weight:bold;><%=SlNo%></span>",
                width: 50
            }), {
                dataIndex: 'slnoIndex',
                hidden: true,
                header: "<span style=font-weight:bold;><%=SlNo%></span>",
                filter: {
                    type: 'numeric'
                }
            }, {
                header: "<span style=font-weight:bold;>Order Id</span>",
                dataIndex: 'orderIdDataIndex',
                filter: {
                    type: 'string'
                }
            }, {
                header: "<span style=font-weight:bold;>Sand Customer Name</span>",
                dataIndex: 'customerDataIndex',
                filter: {
                    type: 'string'
                }
            }, {
                header: "<span style=font-weight:bold;>Transit Permit No.</span>",
                dataIndex: 'transitPermitDataIndex',
                filter: {
                    type: 'string'
                }
            }, {
                header: "<span style=font-weight:bold;><%=VehicleNo%></span>",
                dataIndex: 'vehicleNoDataIndex',
                filter: {
                    type: 'string'
                }
            }, {
                header: "<span style=font-weight:bold;>Transit Permit Date/Time</span>",
                dataIndex: 'transitDateDataIndex',
                filter: {
                    type: 'date'
                }
            }, {
                header: "<span style=font-weight:bold;>Transit Issued Quantity (Cu M)</span>",
                dataIndex: 'transitQtyDataIndex',
                filter: {
                    type: 'numeric'
                }
            }, {
                header: "<span style=font-weight:bold;>Weigh Bridge Quantity (Cu M)</span>",
                dataIndex: 'weighBridgeQtyDataIndex',
                filter: {
                    type: 'numeric'
                }
            }, {
                header: "<span style=font-weight:bold;>Weigh Bridge Date Time</span>",
                dataIndex: 'weighBridgeDateDataIndex',
                filter: {
                    type: 'date'
                }
            }, {
                header: "<span style=font-weight:bold;>Time Difference (HH:MM)</span>",
                dataIndex: 'timeDiffDataIndex',
                filter: {
                    type: 'string'
                }
            }, {
                header: "<span style=font-weight:bold;>Weight Difference (Cu M)</span>",
                dataIndex: 'weightDiffDataIndex',
                filter: {
                    type: 'string'
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
   
    summaryGrid = getGrid('', '<%=NoRecordsFound%>', SummaryReportStore, screen.width - 35, 400, 22, filters, '<%=ClearFilterData%>', false, '', 10, false, '', false, '', true, '<%=Excel%>', jspName, exportDataType, true, '<%=PDF%>');
      
      Ext.onReady(function () {
        ctsb = tsb;
        Ext.QuickTips.init();
        Ext.form.Field.prototype.msgTarget = 'side';

        outerPanel = new Ext.Panel({
        	title:'Transit Pass Violation Report',
            renderTo: 'content',
            standardSubmit: true,
            frame: true,
            cls: 'outerpanel',
            height: 520,
            width:screen.width-24,
            layout: 'table',
            layoutConfig: {
                columns: 1
            },
            items: [innerPanel, summaryGrid]
            //bbar: ctsb
        });
        if(<%=customerId%> > 0)
	    {
	    Ext.getCmp('custnamelab').hide();
	    Ext.getCmp('custcomboId').hide();
	    }
    var cm = summaryGrid.getColumnModel();  
    for (var j = 1; j < cm.getColumnCount(); j++) {
       cm.setColumnWidth(j,170);
    }
    });
   
   </script>

</body>   
</html>