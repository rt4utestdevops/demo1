<%@page  language="java" import="java.util.*,t4u.functions.*,t4u.beans.*,t4u.common.*" pageEncoding="utf-8"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://"+ request.getServerName() + ":" + request.getServerPort()+ path + "/";
	CommonFunctions cf = new CommonFunctions();
	cf.checkLoginInfo((LoginInfoBean) session.getAttribute("loginInfoDetails"), session, request, response);

	LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
	String language = loginInfo.getLanguage();
	int systemId = loginInfo.getSystemId();
	int customerId = loginInfo.getCustomerId();
	String currency = cf.getCurrency(systemId);
	//System.out.println("currency-->"+currency);
	
	ArrayList<String> tobeConverted=new ArrayList<String>();	
	tobeConverted.add("Fuelly_Report_Title");
	tobeConverted.add("Customer_Name");
	tobeConverted.add("Select_Customer");
	tobeConverted.add("Asset_Group");
	tobeConverted.add("Select_Asset_Group");
	tobeConverted.add("Start_Date");
	tobeConverted.add("Select_Start_Date");
	tobeConverted.add("End_Date");
	tobeConverted.add("Select_End_Date");
	tobeConverted.add("View");
	tobeConverted.add("SLNO");
	tobeConverted.add("Asset_Number");
	tobeConverted.add("Vehicle_Model");
	tobeConverted.add("Driver_Name");
	tobeConverted.add("Date");
	tobeConverted.add("Odometer");
	tobeConverted.add("Fuel");
	tobeConverted.add("Amount");
	tobeConverted.add("Slip_No");
	tobeConverted.add("Fuel_Station_Name");
	tobeConverted.add("Mileage");
	tobeConverted.add("Approximate_Mileage");
	tobeConverted.add("Deviation");
	tobeConverted.add("Fuel_Mileage_Details");
	tobeConverted.add("No_Records_Found");
	tobeConverted.add("Clear_Filter_Data");
	tobeConverted.add("Reconfigure_Grid");
	tobeConverted.add("Clear_Grouping");
	tobeConverted.add("Excel");
	tobeConverted.add("Month_Validation");
	tobeConverted.add("Fuel_Mileage_Summary");
	tobeConverted.add("Average_Mileage");
	tobeConverted.add("Total_Fuel_Up");
	tobeConverted.add("Total_Amount");
	tobeConverted.add("Total_Refuel");
	tobeConverted.add("Petro_Card_Number");
	tobeConverted.add("Delete");
	tobeConverted.add("Are_you_sure_you_want_to_delete");
	tobeConverted.add("Select_Single_Row");
	tobeConverted.add("Deleting");
	tobeConverted.add("Week_Validation");
	tobeConverted.add("Amount_Per_Ltr");
	tobeConverted.add("Fuel_Type");	
	
	ArrayList<String> convertedWords=new ArrayList<String>();
	convertedWords=cf.getLanguageSpecificWordForKey(tobeConverted, language);
	
	String fuellyReportforTitle = convertedWords.get(0);	
	String CustomerName = convertedWords.get(1);
	String SelectCustomer = convertedWords.get(2);
	String AssetGroup = convertedWords.get(3);
	String SelectAssetGroup = convertedWords.get(4);
	String StartDate = convertedWords.get(5);
	String SelectStartDate = convertedWords.get(6);
	String EndDate = convertedWords.get(7);
	String SelectEndDate = convertedWords.get(8);
	String View = convertedWords.get(9);
	String SlNo = convertedWords.get(10);
	String AssetNumber = convertedWords.get(11);
	String VehicleModel = convertedWords.get(12);
	String DriverName = convertedWords.get(13);
	String Date = convertedWords.get(14);
	String Odometer = convertedWords.get(15);
	String Fuel = convertedWords.get(16);
	String Amount = convertedWords.get(17);
	String SlipNo = convertedWords.get(18);
	String FuelStationName = convertedWords.get(19);
	String Mileage = convertedWords.get(20);
	String ApproximateMileage = convertedWords.get(21);
	String Deviation = convertedWords.get(22);
	String Fuel_Mileage_Details = convertedWords.get(23);
	String NoRecordsFound = convertedWords.get(24);
	String ClearFilterData = convertedWords.get(25);
	String ReconfigureGrid = convertedWords.get(26);
	String ClearGrouping = convertedWords.get(27);
	String Excel = convertedWords.get(28);
	String monthValidation = convertedWords.get(29);
	String Fuel_Mileage_Summary = convertedWords.get(30);
	String AverageMileage = convertedWords.get(31);
	String TotalFuelUps =convertedWords.get(32);
	String TotalAmount = convertedWords.get(33);
	String FuelInLts = convertedWords.get(34);
	String PetroCardNumber = convertedWords.get(35);
	String Delete = convertedWords.get(36);
	String wantToDelete = convertedWords.get(37);
	String selectSingleRow=convertedWords.get(38);
	String deleting=convertedWords.get(39);
	String WeekValidation = convertedWords.get(40);
	String AmountPerLtr = convertedWords.get(41);
	String FuelType = convertedWords.get(42);
	String GrandTotal="Total Amount";
%>
<!DOCTYPE html>
<html>
	<head>
		<title><%=fuellyReportforTitle%></title>	
		<meta http-equiv="X-UA-Compatible" content="IE=11,IE=10,IE=9,IE=8" />	
	</head>	    
  
  	<body onload="refresh();" >
  	<%if (loginInfo.getStyleSheetOverride().equals("Y")){%>                  
        <jsp:include page="../Common/ImportJSSandMining.jsp"/>                                               
        <%}else {%> 
        <jsp:include page="../Common/ImportJS.jsp" /><%} %>
   		<!-- for exporting to excel***** -->
        <jsp:include page="../Common/ExportJS.jsp" />
   	<script>
   	  	var outerPanel;
  		var ctsb;
  		var dtprev;
  		var dtcur;
  		var titel;
  		var myWin;
  		var jspName = "FuelReconciliationReport";
  		var jspNameSummary = "FuelReconciliationSummaryReport";
  		var exportDataType = "int,string,string,string,date,int,float,float,float,string,string,string,float,float,float,string";
  		var exportDataTypeForSummary = "int,string,string,float,int,float,float";
		var currency = '<%=currency%>';
		var tot;
  		 //In chrome activate was slow so refreshing the page
		//------------------------------------------//
     function setReports(type,desc,subtotal){
     var subtotal=Ext.getCmp('total').text;
       return subtotal;
     }
    function getfuelMileageSummaryTotal(){
		 tot = parseFloat(fuelMileageSummaryGrid.store.sum('totalAmount')).toFixed(3);
		 tot=tot+" "+currency;
		Ext.getCmp('total').setText(tot);
		}
	function getfuelMileageTotals(){
		 tot = parseFloat(fuelMileageGrid.store.sum('amount')).toFixed(3);
		 tot=tot+" "+currency;
		 Ext.getCmp('total').setText(tot);
		}
//----------------------------------//
  		function refresh() {
        	isChrome = window.chrome;
            	if(isChrome && parent.flagFuelMileage<2) {
					setTimeout(
                        function(){
                        	parent.Ext.getCmp('FuelMileageDetailsId').enable();
                            	parent.Ext.getCmp('FuelMileageDetailsId').show();
                                parent.Ext.getCmp('FuelMileageDetailsId').update("<iframe style='width:100%;height:600px;border:0;'src='<%=path%>/Jsps/CashVanManagement/FuellyMileage.jsp'></iframe>");
                            },0);
                           	parent.FuelMileageTab.doLayout();
                           	parent.flagFuelMileage= parent.flagFuelMileage+1;                            
                 }
         }
  		
  		function deleteData() 
		{
			if (Ext.getCmp('custcomboId').getValue() == "") {
                Ext.example.msg("<%=SelectCustomer%>");
                Ext.getCmp('custcomboId').focus();
                return;
            }
            if (Ext.getCmp('assetgroupcomboId').getValue() == "") {
                Ext.example.msg("<%=SelectAssetGroup%>");
                Ext.getCmp('assetgroupcomboId').focus();
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
 
            if(fuelMileageGrid.getSelectionModel().getCount() == 0) {
            	Ext.example.msg("<%=NoRecordsFound%>");
            	return;
            }
           
            if(fuelMileageGrid.getSelectionModel().getCount() > 1) {
            	Ext.example.msg("<%=selectSingleRow%>");
            	return;
            }
              
		if(fuelMileageGrid.getSelectionModel().getCount() == 1) {
		
		var selected = fuelMileageGrid.getSelectionModel().getSelected();	
		var regNo = selected.get('registrationNo');
		var odometer = selected.get('odometer');
		
		Ext.Msg.show({
        title: '<%=Delete%>',
        msg: '<%=wantToDelete%>',
        buttons: Ext.Msg.YESNO,
        fn: function (btn) {
              switch (btn) {
                case 'yes':
                    ctsb.showBusy('<%=deleting%>');
                    outerPanel.getEl().mask();
                    //Ajax request
                    Ext.Ajax.request({
                        url: '<%=request.getContextPath()%>/FuelMileage.do?param=deleteFuelMileageDetails',
                        method: 'POST',
                        params: {
                            deleteRegNo: regNo ,
                            deleteOdometer: odometer,
                            customerIdDeleteParam: Ext.getCmp('custcomboId').getValue()
                        },
                        success: function (response, options) {
                            Ext.example.msg(response.responseText);
                            fuelMileageStore.reload();
                            fuelMileageSummaryStore.reload();
                            outerPanel.getEl().unmask();
                        },
                        failure: function () {
                            Ext.example.msg("Error");
                            fuelMileageStore.reload();
                            fuelMileageSummaryStore.reload();
                            outerPanel.getEl().unmask();
                        }
                    });

                    break;
                case 'no':
                    Ext.example.msg("Fuel detail not Deleted");
                    fuelMileageStore.reload();
                    fuelMileageSummaryStore.reload();
                    break;

                }
        }
    });	
    }
}

  		var fuelMileageSummaryReader = new Ext.data.JsonReader({
  		    idProperty: 'darreaderid',
  		    root: 'FuelMileageSummaryRoot',
  		    totalProperty: 'total',
  		    fields: [{
  		        name: 'slnoIndexSummary'
  		    }, {
  		        name: 'registrationNoSummary'
  		    }, {
  		        name: 'vehicleModelSummary'
  		    }, {
  		        name: 'averageMileage'
  		    }, {
  		        name: 'totalFuelUps'
  		    }, {
  		        name: 'totalAmount'
  		    }, {
  		        name: 'fuelInLiters'
  		    }]
  		});

  		var fuelMileageSummaryStore = new Ext.data.GroupingStore({
  		    autoLoad: false,
  		    proxy: new Ext.data.HttpProxy({
  		        url: '<%=request.getContextPath()%>/FuelMileage.do?param=getFuelMileageSummaryData',
  		        method: 'POST'
  		    }),
  		    remoteSort: false,
  		    storeId: 'FuelMileageSummaryStoreId',
  		    reader: fuelMileageSummaryReader
  		});

  		var fuelMileageSummaryFilters = new Ext.ux.grid.GridFilters({
  		    local: true,
  		    filters: [{
  		        type: 'numeric',
  		        dataIndex: 'slnoIndexSummary'
  		    }, {
  		        type: 'string',
  		        dataIndex: 'registrationNoSummary'
  		    }, {
  		        type: 'string',
  		        dataIndex: 'vehicleModelSummary'
  		    }, {
  		        type: 'float',
  		        dataIndex: 'averageMileage'
  		    }, {
  		        type: 'int',
  		        dataIndex: 'totalFuelUps'
  		    }, {
  		        type: 'float',
  		        dataIndex: 'totalAmount'
  		    }, {
  		        type: 'float',
  		        dataIndex: 'fuelInLiters'
  		    }]
  		});

  		 //************************************Column Model for Summary******************************************

  		var columnsSummary = new Ext.grid.ColumnModel([
  		    new Ext.grid.RowNumberer({
  		        header: "<span style=font-weight:bold;><%=SlNo%></span>",
  		        width: 50
  		    }), {
  		        dataIndex: 'slnoIndexSummary',
  		        hidden: true,
  		        header: "<span style=font-weight:bold;><%=SlNo%></span>",
  		        filter: {
  		            type: 'numeric'
  		        }
  		    }, {
  		        header: "<span style=font-weight:bold;><%=AssetNumber%></span>",
  		        dataIndex: 'registrationNoSummary',
  		        width: 120,
  		        filter: {
  		            type: 'string'
  		        }
  		    }, {
  		        header: "<span style=font-weight:bold;><%=VehicleModel%></span>",
  		        dataIndex: 'vehicleModelSummary',
  		        width: 130,
  		        filter: {
  		            type: 'string'
  		        }
  		    }, {
  		        header: "<span style=font-weight:bold;><%=AverageMileage%></span>",
  		        dataIndex: 'averageMileage',
  		        width: 100,
  		        filter: {
  		            type: 'numeric'
  		        }
  		    }, {
  		        header: "<span style=font-weight:bold;><%=TotalFuelUps%></span>",
  		        dataIndex: 'totalFuelUps',
  		        width: 100,
  		        filter: {
  		            type: 'numeric'
  		        }
  		    }, {
  		        header: "<span style=font-weight:bold;><%=TotalAmount%></span>",
  		        dataIndex: 'totalAmount',
  		        width: 100,
  		        filter: {
  		            type: 'numeric'
  		        }
  		    }, {
  		        header: "<span style=font-weight:bold;><%=FuelInLts%></span>",
  		        dataIndex: 'fuelInLiters',
  		        width: 100,
  		        filter: {
  		            type: 'numeric'
  		        }
  		    }
  		]);

  		var reader = new Ext.data.JsonReader({
  		    idProperty: 'darreaderid',
  		    root: 'FuelMileageRoot',
  		    totalProperty: 'total',
  		    fields: [{
  		        name: 'slnoIndex'
  		    }, {
  		        name: 'registrationNo'
  		    }, {
  		        name: 'vehicleModel'
  		    }, {
  		        name: 'driverName'
  		    }, {
  		        name: 'date',
  		        type: 'date',
  		        dateFormat: getDateTimeFormat()
  		    }, {
  		        name: 'odometer'
  		    }, {
  		        name: 'fuel'
  		    }, {
  		        name: 'amount'
  		    }, {
  		    	name: 'amountperltr'
  		    },{
  		    	name: 'fuelType'
  		    },{
  		        name: 'slipNo'
  		    }, {
  		        name: 'fuelStationName'
  		    }, {
  		        name: 'mileage',
  		         type: 'float'
  		    }, {
  		        name: 'approximateMileage'
  		    }, {
  		        name: 'deviation'
  		    }, {
  		        name: 'petroCardNumber'
  		    }]
  		});

  		var fuelMileageStore = new Ext.data.GroupingStore({
  		    autoLoad: false,
  		    proxy: new Ext.data.HttpProxy({
  		        url: '<%=request.getContextPath()%>/FuelMileage.do?param=getFuelMileageData',
  		        method: 'POST'
  		    }),
  		    remoteSort: false,

  		    storeId: 'darStore',
  		    reader: reader
  		});

  		var filters = new Ext.ux.grid.GridFilters({
  		    local: true,
  		    filters: [{
  		        type: 'numeric',
  		        dataIndex: 'slnoIndex'
  		    }, {
  		        type: 'string',
  		        dataIndex: 'registrationNo'
  		    }, {
  		        type: 'string',
  		        dataIndex: 'vehicleModel'
  		    }, {
  		        type: 'string',
  		        dataIndex: 'driverName'
  		    }, {
  		        type: 'date',
  		        dataIndex: 'date'
  		    }, {
  		        type: 'int',
  		        dataIndex: 'odometer'
  		    }, {
  		        type: 'float',
  		        dataIndex: 'fuel'
  		    }, {
  		        type: 'float',
  		        dataIndex: 'amount'
  		    },{
  		    	type:'float',
  		    	dataIndex:'amountperltr'
  		    },{
  		    	type:'string',
  		    	dataIndex: 'fuelType'
  		    },{
  		        type: 'string',
  		        dataIndex: 'slipNo'
  		    }, {
  		        type: 'string',
  		        dataIndex: 'fuelStationName'
  		    }, {
  		        type: 'float',
  		        dataIndex: 'mileage'
  		    }, {
  		        type: 'float',
  		        dataIndex: 'approximateMileage'
  		    }, {
  		        type: 'float',
  		        dataIndex: 'deviation'
  		    }, {
  		        type: 'string',
  		        dataIndex: 'petroCardNumber'
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
  		            header: "<span style=font-weight:bold;><%=AssetNumber%></span>",
  		            dataIndex: 'registrationNo',
  		            width: 120,
  		            filter: {
  		                type: 'string'
  		            }
  		        }, {
  		            header: "<span style=font-weight:bold;><%=VehicleModel%></span>",
  		            dataIndex: 'vehicleModel',
  		            width: 130,
  		            filter: {
  		                type: 'string'
  		            }
  		        }, {
  		            header: "<span style=font-weight:bold;><%=DriverName%></span>",
  		            dataIndex: 'driverName',
  		            width: 120,
  		            filter: {
  		                type: 'string'
  		            }
  		        }, {
  		            dataIndex: 'date',
  		            header: "<span style=font-weight:bold;><%=Date%></span>",
  		            renderer: Ext.util.Format.dateRenderer(getDateTimeFormat()),
  		            width: 150,
  		            filter: {
  		                type: 'date'
  		            }
  		        }, {
  		            header: "<span style=font-weight:bold;><%=Odometer%></span>",
  		            dataIndex: 'odometer',
  		            filter: {
  		                type: 'numeric'
  		            }
  		        }, {
  		            header: "<span style=font-weight:bold;><%=Fuel%></span>",
  		            dataIndex: 'fuel',
  		            filter: {
  		                type: 'numeric'
  		            }
  		        }, {
  		            header: "<span style=font-weight:bold;><%=Amount%></span>",
  		            dataIndex: 'amount',
  		            filter: {
  		                type: 'numeric'
  		            }
  		        },{
  		        	header:"<span style=font-weight:bold;><%=AmountPerLtr%></span>",
  		        	width:140,
  		        	dataIndex:'amountperltr',
  		        	filter: {
  		        			type: 'numeric'
  		        			}
  		        	},{
  		        	header:"<span style=font-weight:bold;><%=FuelType%></span>",
  		        	dataIndex:'fuelType',
  		        	filter: {
  		        			type: 'numeric'
  		        			}
  		        	},{
  		            header: "<span style=font-weight:bold;><%=SlipNo%></span>",
  		            dataIndex: 'slipNo',
  		            filter: {
  		                type: 'string'
  		            }
  		        }, {
  		            header: "<span style=font-weight:bold;><%=FuelStationName%></span>",
  		            dataIndex: 'fuelStationName',
  		            width: 140,
  		            filter: {
  		                type: 'string'
  		            }
  		        }, {
  		            header: "<span style=font-weight:bold;><%=Mileage%></span>",
  		            dataIndex: 'mileage',
  		            filter: {
  		                type: 'float'
  		            }
  		        }, {
  		            header: "<span style=font-weight:bold;><%=ApproximateMileage%></span>",
  		            dataIndex: 'approximateMileage',
  		            width: 140,
  		            filter: {
  		                type: 'numeric'
  		            }
  		        }, {
  		            header: "<span style=font-weight:bold;><%=Deviation%></span>",
  		            dataIndex: 'deviation',
  		            filter: {
  		                type: 'numeric'
  		            }
  		        },{
  		            header: "<span style=font-weight:bold;><%=PetroCardNumber%></span>",
  		            dataIndex: 'petroCardNumber',
  		            width: 140,
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
  		var subTotal ="";
  		var fuelMileageGrid = getGridforSubtotal('', '<%=NoRecordsFound%>', fuelMileageStore, screen.width - 50, 295, 22, filters, '<%=ClearFilterData%>', false, '<%=ReconfigureGrid%>', 15, false, '<%=ClearGrouping%>', false, '', true, '<%=Excel%>', jspName,subTotal,exportDataType, true, 'PDF', false, '', false, '', true, '<%=Delete%>');

  		var fuelMileageSummaryGrid = getMultipleGrid('', '<%=NoRecordsFound%>', fuelMileageSummaryStore, screen.width - 55,292, columnsSummary, fuelMileageSummaryFilters, true, '<%=ClearFilterData%>', false, '<%=ReconfigureGrid%>', 8, false, '<%=ClearGrouping%>', false, '', true, '<%=Excel%>', jspNameSummary, exportDataTypeForSummary, true, 'PDF',subTotal);

  		var fuelMileageTabs = new Ext.TabPanel({
  		    resizeTabs: false, // turn off tab resizing
  		    enableTabScroll: true,
  		    activeTab: 'fuelMileageTab',
  		    id: 'mainTabPanelId',
  		    width: screen.width - 45,
  		    height: screen.height - 445
  		});

  		addTab();

  		function addTab() {
  		    fuelMileageTabs.add({
  		        title: '<%=Fuel_Mileage_Details%>',
  		        iconCls: 'admintab',
  		        id: 'fuelMileageTab',
  		        items: [fuelMileageGrid]
  		    }).show();

  		    fuelMileageTabs.add({
  		        title: '<%=Fuel_Mileage_Summary%>',
  		        iconCls: 'admintab',
  		        autoScroll: true,
  		        id: 'fuelMileageSummaryTab',
  		        items: [fuelMileageSummaryGrid]
  		    }).show();
  		}

  		 //***************************************Customer Store*************************************  		
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
  		                assetGroupsStore.load({
  		                    params: {
  		                        CustId: <%= customerId %> ,
  		                        LTSPId: <%= systemId %>
  		                    }
  		                });
  		            }
  		        }
  		    }
  		});

  		 //***************************************Vehicle store*************************************
  		var assetGroupsStore = new Ext.data.JsonStore({
  		    url: '<%=request.getContextPath()%>/UtilizationReportsAction.do?param=getAssetGroup',
  		    id: 'assetGroupStoreId',
  		    root: 'assetGroupRoot',
  		    autoLoad: false,
  		    remoteSort: true,
  		    fields: ['groupId', 'groupName'],
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
  		    cls: 'selectstylePerfect',
  		    listeners: {
  		        select: {
  		            fn: function () {
  		                custId = Ext.getCmp('custcomboId').getValue();
  		                Ext.getCmp('assetgroupcomboId').reset();

  		                assetGroupsStore.load({
  		                    params: {
  		                        CustId: custId,
  		                        LTSPId: <%= systemId %>
  		                    }
  		                });
  		                fuelMileageGrid.store.clearData();
  		                fuelMileageGrid.view.refresh();

  		                fuelMileageSummaryGrid.store.clearData();
  		                fuelMileageSummaryGrid.view.refresh();

  		                var tabSummaryPanel = Ext.getCmp('mainTabPanelId');
  		                tabSummaryPanel.setActiveTab('fuelMileageTab');
  		            }
  		        }
  		    }
  		});

  		 //****************************************Combo for Vehicle******************************************	
  		var assetgroupcombo = new Ext.form.ComboBox({
  		    store: assetGroupsStore,
  		    id: 'assetgroupcomboId',
  		    mode: 'local',
  		    forceSelection: true,
  		    emptyText: '<%=SelectAssetGroup%>',
  		    selectOnFocus: true,
  		    allowBlank: false,
  		    anyMatch: true,
  		    typeAhead: false,
  		    triggerAction: 'all',
  		    lazyRender: true,
  		    valueField: 'groupId',
  		    displayField: 'groupName',
  		    cls: 'selectstylePerfect',
  		    listeners: {
  		        select: {
  		            fn: function () {
  		                fuelMileageGrid.store.clearData();
  		                fuelMileageGrid.view.refresh();

  		                fuelMileageSummaryGrid.store.clearData();
  		                fuelMileageSummaryGrid.view.refresh();

  		                var tabSummaryPanel = Ext.getCmp('mainTabPanelId');
  		                tabSummaryPanel.setActiveTab('fuelMileageTab');
  		            }
  		        }
  		    }
  		});

  		var innerPanel = new Ext.Panel({
  		    standardSubmit: true,
  		    collapsible: false,
  		    id: 'traderMaster',
  		    layout: 'table',
  		    frame: true,
  		    width: screen.width -45,
  		    layoutConfig: {
  		        columns: 7
  		    },
  		    items: [{
  		            xtype: 'label',
  		            text: '<%=CustomerName%>' + ' :',
  		            cls: 'labelstyle',
  		            id: 'custnamelab'
  		        },
  		        custnamecombo, {
  		            width: 30
  		        }, {
  		            xtype: 'label',
  		            text: '<%=AssetGroup%>' + ' :',
  		            cls: 'labelstyle',
  		            id: 'assetgroupcombolab'
  		        },
  		        assetgroupcombo, {
  		            width: 30
  		        }, {}, {
  		            xtype: 'label',
  		            cls: 'labelstyle',
  		            id: 'startdatelab',
  		            text: '<%=StartDate%>' + ' :'
  		        }, {
  		            xtype: 'datefield',
  		            cls: 'selectstylePerfect',
  		            width: 185,
  		            format: getDateTimeFormat(),
  		            emptyText: '<%=SelectStartDate%>',
  		            allowBlank: false,
  		            blankText: '<%=SelectStartDate%>',
  		            id: 'startdate',
  		            value: dtprev,
  		            vtype: 'daterange',
  		            endDateField: 'enddate'
  		        }, {
  		            width: 30
  		        }, {
  		            xtype: 'label',
  		            cls: 'labelstyle',
  		            id: 'enddatelab',
  		            text: '<%=EndDate%>' + ' :'
  		        }, {
  		            xtype: 'datefield',
  		            cls: 'selectstylePerfect',
  		            width: 185,
  		            format: getDateTimeFormat(),
  		            emptyText: '<%=SelectEndDate%>',
  		            allowBlank: false,
  		            blankText: '<%=SelectEndDate%>',
  		            id: 'enddate',
  		            value: dtcur,
  		            vtype: 'daterange',
  		            startDateField: 'startdate'
  		        }, {
  		            width: 30
  		        }, {
  		            xtype: 'button',
  		            text: '<%=View%>',
  		            id: 'addbuttonid',
  		            cls: ' ',
  		            width: 80,
  		            listeners: {
  		                click: {
  		                    fn: function () {
  		                        //Action for Button
  		                        if (Ext.getCmp('custcomboId').getValue() == "") {
  		                            Ext.example.msg("<%=SelectCustomer%>");
  		                            Ext.getCmp('custcomboId').focus();
  		                            return;
  		                        }
  		                        if (Ext.getCmp('assetgroupcomboId').getValue() == "") {
  		                            Ext.example.msg("<%=SelectAssetGroup%>");
  		                            Ext.getCmp('assetgroupcomboId').focus();
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
  		                        var startdates = Ext.getCmp('startdate').getValue();
  		                        var enddates = Ext.getCmp('enddate').getValue();
  		                        
  		                        if(Ext.getCmp('assetgroupcomboId').getValue() == "0"){
<!--  		                        if(checkWeekValidation(startdates, enddates)){-->
<!--  		                             Ext.example.msg('<%=WeekValidation%>'+' for Group "ALL" ');-->
<!--  		                             Ext.getCmp('enddate').focus();-->
<!--  		                             return;    -->
<!--  		                        }-->
  		                        }
  		                        
  		                        if (checkMonthValidation(startdates, enddates)) {
  		                            Ext.example.msg("<%=monthValidation%>");
  		                            Ext.getCmp('enddate').focus();
  		                            return;
  		                        }
  		                        fuelMileageStore.load({
  		                            params: {
  		                                assetGroupId: Ext.getCmp('assetgroupcomboId').getValue(),
  		                                assetGroupName: Ext.getCmp('assetgroupcomboId').getRawValue(),
  		                                startdate: Ext.getCmp('startdate').getValue(),
  		                                enddate: Ext.getCmp('enddate').getValue(),
  		                                clientId: Ext.getCmp('custcomboId').getValue(),
  		                                jspName: jspName
  		                            },
  		                             callback:function(){//alert("call back called...");
							 	       getfuelMileageTotals();
							 	       }
  		                        });
  		                        
  		                        fuelMileageSummaryStore.load({
  		                            params: {
  		                                assetGroupId: Ext.getCmp('assetgroupcomboId').getValue(),
  		                                assetGroupName: Ext.getCmp('assetgroupcomboId').getRawValue(),
  		                                startdate: Ext.getCmp('startdate').getValue(),
  		                                enddate: Ext.getCmp('enddate').getValue(),
  		                                clientId: Ext.getCmp('custcomboId').getValue(),
  		                                jspNameSummary: jspNameSummary
  		                            }
  		                        });
  		                    }
  		                }
  		            }
  		        }
  		    ]
  		}); // End of Panel	
var disclaimer = new Ext.FormPanel({
    standardSubmit: true,
    collapsible: false,
    id: 'disclaimerId',
    height: 30,
    width: screen.width -44,
    frame: true,
    layout: 'column',
    layoutConfig: {
        columns: 2
    },
    items: [{
        cls: 'outerpanel'
    }, {
        xtype: 'label',
        text: 'NOTE : ',
        style: 'font-weight:bold;'
	}, {
        xtype: 'label',
        text: ' Mileage is calculated as “Dividing the number of kms driven by the number of lts it took to fill the tank”.',
        style: 'margin-left:5px;'
	}
	]
});
 var total=new Ext.form.Label({
						fieldLabel: '',
       				 	style: 'font-weight:bold;',
                        width : 100,
        			  	id: 'total' 
        });
var totals= new Ext.FormPanel({
				id:'totalsId',
				height: 25,
				frame: true,
                layout:'column',
				layoutConfig: {
					columns: 2
				},
				width: screen.width - 44,
				items: [{
       				 	width : 550 
        			  	},{
       				 	xtype: 'label',
       				 	style: 'font-weight:bold;',
       				 	text: '<%=GrandTotal%>:',
       				 	width : 100
    					},total]
		});	 
		 //datachanged 
fuelMileageStore.on('datachanged',function(){
getfuelMileageTotals();
});

fuelMileageSummaryStore.on('datachanged',function(){
getfuelMileageSummaryTotal();
});
  		Ext.onReady(function () {
  		    ctsb = tsb;
  		    Ext.QuickTips.init();
  		    Ext.form.Field.prototype.msgTarget = 'side';

  		    outerPanel = new Ext.Panel({
  		        title: '<%=fuellyReportforTitle%>',
  		        renderTo: 'content',
  		        standardSubmit: true,
  		        frame: true,
  		        width:screen.width-30,
  		        height:510,
  		        cls: 'outerpanel',
  		        layout: 'table',
  		        layoutConfig: {
  		            columns: 1
  		        },
  		        items: [innerPanel, fuelMileageTabs,disclaimer,totals]
  		        //bbar: ctsb
  		    });
  		    Ext.getCmp('total').setText("00"+currency+"");
  		});
 
   	</script>
  	</body>
</html>