<%@ page  language="java" import="java.util.*,t4u.functions.*,t4u.beans.*,t4u.common.*" pageEncoding="utf-8"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://"+ request.getServerName() + ":" + request.getServerPort()+ path + "/";
	CommonFunctions cf = new CommonFunctions();
	cf.checkLoginInfo((LoginInfoBean) session.getAttribute("loginInfoDetails"), session, request, response);

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
    
    CashVanManagementFunctions cvm = new CashVanManagementFunctions();
    String currentDate = cvm.getCurrentDateandTime(0);	
    String toDate = cvm.setCurrentDateForReports(0)+" 23:59:59";
	String fromDate = cvm.setCurrentDateForReports(0)+" 00:00:00";
%>

<!DOCTYPE HTML>
<html>
<head>
	<title></title>	
	
<style>

#totalValueId, #totalValueLblId{
	font-weight: 700;
    font-size: medium;
} 
#chequeBalanceId, #jewelleryBalanceId, #foreignCurrencyBalanceId, #foreignCurrencyBalanceLblId,
	#jewelleryBalanceLblId, #chequeBalanceLblId, #sealedBagBalanceId, #sealedBagBalanceLblId, #availableBalanceId, #availableBlnceLblId,
	#ledgerBalanceId, #legderBalanceLblId, #dateLblId{
	font-weight: 700;
    font-size: small;
}
.green-row .x-grid3-cell-inner {
	background-color: #A4A4A4;font-style: italic;color: white;
}
</style>	
</head>	    
<body>
	<%if (loginInfo.getStyleSheetOverride().equals("Y")){%>                  
    	<jsp:include page="../Common/ImportJSSandMining.jsp"/>                                               
   	<%}else {%>  
   		<jsp:include page="../Common/ImportJS.jsp" /><%} %>
		
   	<script>
   	var outerPanel;
    var ctsb;
    var Grid;
    var dtprev = dateprev;
    var dtcur = datecur;
	var jspName;
	var exportDataType;	
	var value;

  	var currentInventoryBanance = new Ext.data.JsonStore({
        url: '<%=request.getContextPath()%>/cashDispenseAction.do?param=getCurrentInventoryBalance',
        root: 'currentInventoryRoot',
        autoLoad: false,
        remoteSort: true,
        fields: ['ledgerBalance', 'availableBalance','sealedBagBalance','chequeBalance','jewelleryBalance','forexBalance','total']
    });
    
    var customercombostore = new Ext.data.JsonStore({
        url: '<%=request.getContextPath()%>/cashDispenseAction.do?param=getCustomer',
        id: 'CustomerStoreId',
        root: 'CustomerRoot',
        autoLoad: true,
        remoteSort: true,
        fields: ['CustId', 'CustName']
    });

	var typeArray = [['1','Trip'],['2','Business Type']];
 	var typestore = new Ext.data.SimpleStore({
 		data: typeArray,
        autoLoad: true,
        remoteSort: true,
        fields: ['typeId', 'typeName']
    });	
    var typeCombo = new Ext.form.ComboBox({
        store: typestore,
        id: 'typeComboId',
        mode: 'local',
        forceSelection: true,
        emptyText: 'Select Type',
        selectOnFocus: true,
        allowBlank: false,
        anyMatch: true,
        typeAhead: false,
        triggerAction: 'all',
        lazyRender: true,
        valueField: 'typeId',
        displayField: 'typeName',
        cls: 'selectstylePerfect',
        listeners: {
            select: {
                fn: function () {
                if(Ext.getCmp('typeComboId').getValue() == '1'){
                	Ext.getCmp('custtypeLblId').hide();
                	Ext.getCmp('custTypeComboId').hide();
                }else if(Ext.getCmp('typeComboId').getValue() == '2'){
                	Ext.getCmp('custtypeLblId').show();
                	Ext.getCmp('custTypeComboId').show();
                	Ext.getCmp('custtypeLblId').setText('Business Type');
                }
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
        cls: 'selectstylePerfect',
        listeners: {
            select: {
                fn: function () {
                }
            }
        }
    });

	var customerTypeArray = [['0','All'],['1','ATM Replinshment'],['2','Cash Delivery'],['3','Cash Pickup'],['4','ATM Deposit'],['5','Cash Transfer']];
 	var customerTypestore = new Ext.data.SimpleStore({
 		data: customerTypeArray,
        autoLoad: false,
        fields: ['custtypeId', 'custtypeName']
    });	
    var custTypeCombo = new Ext.form.ComboBox({
        store: customerTypestore,
        id: 'custTypeComboId',
        mode: 'local',
        forceSelection: true,
        emptyText: '',
        selectOnFocus: true,
        allowBlank: false,
        anyMatch: true,
        typeAhead: false,
        triggerAction: 'all',
        lazyRender: true,
        valueField: 'custtypeId',
        displayField: 'custtypeName',
        cls: 'selectstylePerfect',
        listeners: {
            select: {
                fn: function () {
                }
            }
        }
    });
    var reader = new Ext.data.JsonReader({
        idProperty: 'readerId',
        root: 'vaultLedgerRoot',
        totalProperty: 'total',
        fields: [{
            name: 'slnoIndex'
        },{
            name: 'dateTimeDI',
            type: 'date',
            dateFormat: 'c'
        },{
            name: 'tripNoDI'
        },{
            name: 'custTypeDI'
        },{
            name: 'onAccOffDI'
        },{
            name: 'businessIdDI'
        },{
            name: 'amountDI'
        },{
            name: 'cashDispenseDI'
        },{
            name: 'cashInwardDI'
        },{
            name: 'sealedBagDispDI'
        },{
            name: 'sealedBagInwardDI'
        },{
            name: 'chequeDispDI'
        },{
            name: 'chequeInwardDI'
        },{
            name: 'jewelleryDispDI'
        },{
            name: 'jewelleryInwardDI'
        },{
            name: 'foreignCurrencyDispDI'
        },{
            name: 'foreignCurrencyInwardDI'
        },{
        	name: 'inwardModeDI'
        }]
    });

    var store = new Ext.data.GroupingStore({
        autoLoad: false,
        proxy: new Ext.data.HttpProxy({
            url: '<%=request.getContextPath()%>/cashDispenseAction.do?param=getVaultLedger',
            method: 'POST'
        }),
        remoteSort: false,
        storeId: 'summaryStoreId',
        reader: reader,
        listeners:{
        load: function(){
        	getTotals();
        }
        }
    });

    var filters = new Ext.ux.grid.GridFilters({
        local: true,
        filters: [{
            type: 'numeric',
            dataIndex: 'slnoIndex'
        }, {
            type: 'date',
            dataIndex: 'dateTimeDI'
        }, {
            type: 'string',
            dataIndex: 'tripNoDI'
        }, {
            type: 'string',
            dataIndex: 'custTypeDI'
        },{
            type: 'string',
            dataIndex: 'onAccOffDI'
        },{
            type: 'string',
            dataIndex: 'businessIdDI'
        },{
            type: 'string',
            dataIndex: 'amountDI'
        },{
            type: 'float',
            dataIndex: 'cashDispenseDI'
        },{
            type: 'float',
            dataIndex: 'cashInwardDI'
        },{
            type: 'float',
            dataIndex: 'sealedBagDispDI'
        },{
            type: 'float',
            dataIndex: 'sealedBagInwardDI'
        },{
            type: 'float',
            dataIndex: 'chequeDispDI'
        },{
            type: 'float',
            dataIndex: 'chequeInwardDI'
        },{
            type: 'float',
            dataIndex: 'jewelleryDispDI'
        },{
            type: 'float',
            dataIndex: 'jewelleryInwardDI'
        },{
            type: 'float',
            dataIndex: 'foreignCurrencyDispDI'
        },{
            type: 'float',
            dataIndex: 'foreignCurrencyInwardDI'
        },{
        	type: 'string',
        	dataIndex: 'inwardModeDI'
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
                header: "<span style=font-weight:bold;>Date Time</span>",
                dataIndex: 'dateTimeDI',
               	renderer: Ext.util.Format.dateRenderer(getDateTimeFormat()),
                filter: {
                    type: 'date'
                }
            }, {
                header: "<span style=font-weight:bold;><%=TripNo%></span>",
                dataIndex: 'tripNoDI',
                filter: {
                    type: 'string'
                }
            },{
                header: "<span style=font-weight:bold;>Business Type</span>",
                dataIndex: 'custTypeDI',
                filter: {
                    type: 'string'
                }
            },{
                header: "<span style=font-weight:bold;>On Account Of</span>",
                dataIndex: 'onAccOffDI',
                filter: {
                    type: 'string'
                }
            },{
                header: "<span style=font-weight:bold;>Business Id</span>",
                dataIndex: 'businessIdDI',
                filter: {
                    type: 'string'
                }
            },{
                header: "<span style=font-weight:bold;>Amount (Cr/Dr)</span>",
                dataIndex: 'amountDI',
                filter: {
                    type: 'string'
                },
                align: 'right'
            },{
                header: "<span style=font-weight:bold;>Inward Mode</span>",
                dataIndex: 'inwardModeDI',
                filter: {
                    type: 'string'
                },
                hidden: true
            },{
                header: "<span style=font-weight:bold;>Cash Dispense</span>",
                dataIndex: 'cashDispenseDI',
                filter: {
                    type: 'float'
                },
                hidden:true
            },{
                header: "<span style=font-weight:bold;>Cash Inward</span>",
                dataIndex: 'cashInwardDI',
                filter: {
                    type: 'float'
                },
                hidden:true
            },{
                header: "<span style=font-weight:bold;>Sealed Bag Dispense</span>",
                dataIndex: 'sealedBagDispDI',
                filter: {
                    type: 'float'
                },
                hidden:true
            },{
                header: "<span style=font-weight:bold;>Sealed Bag Inward</span>",
                dataIndex: 'sealedBagInwardDI',
                filter: {
                    type: 'float'
                },
                hidden:true
            },{
                header: "<span style=font-weight:bold;>Cheque Dispense</span>",
                dataIndex: 'chequeDispDI',
                filter: {
                    type: 'float'
                },
                hidden:true
            },{
                header: "<span style=font-weight:bold;>Cheque Inward</span>",
                dataIndex: 'chequeInwardDI',
                filter: {
                    type: 'float'
                },
                hidden:true
            },{
                header: "<span style=font-weight:bold;>Jewellery Dispense</span>",
                dataIndex: 'jewelleryDispDI',
                filter: {
                    type: 'float'
                },
                hidden:true
            },{
                header: "<span style=font-weight:bold;>Jewellery Inward</span>",
                dataIndex: 'jewelleryInwardDI',
                filter: {
                    type: 'float'
                },
                hidden:true
            },{
                header: "<span style=font-weight:bold;>Foreign Currency Dispense</span>",
                dataIndex: 'foreignCurrencyDispDI',
                filter: {
                    type: 'float'
                },
                hidden:true
            },{
                header: "<span style=font-weight:bold;>Foreign Currency Inward</span>",
                dataIndex: 'foreignCurrencyInwardDI',
                filter: {
                    type: 'float'
                },
                hidden:true
            }];
			return new Ext.grid.ColumnModel({
            columns: columns.slice(start || 0, finish),
            defaults: {
                sortable: true
            }
        });
    };
	var fieldPanel = new Ext.Panel({
    	standardSubmit: true,
        collapsible: false,
        title:'',
        id: 'fieldPanelId',
        layout: 'table',
        frame: false,
        layoutConfig: {
            columns: 4
        },
        items: [{height:20},{height:20},{height:20},{height:20},{
            xtype: 'label',
            text: 'Total Cash Dispense' + ' :',
            cls: 'labelstyle',
            id: 'cashDispTotalLblId'
            },{width:5},{
            xtype: 'label',
            text: '',
            cls: 'labelstyle',
            id: 'cashDispTotalId'
            },{height:5},{height:5},{height:5},{height:5},{width:50},{
            xtype: 'label',
            text: 'Total Cash Inward' + ' :',
            cls: 'labelstyle',
            id: 'totalCashInwardLabelId'
        	},{width:5},{
            xtype: 'label',
            text: '',
            cls: 'labelstyle',
            id: 'cashInwardTotalId'
        	},{height:15},{height:15},{height:15},{height:15},{width:50},{
            xtype: 'label',
            text: 'Total Sealed Bag Dispense' + ' :',
            cls: 'labelstyle',
            id: 'sealBagDispTotalLblId'
            },{width:5},{
            xtype: 'label',
            text: '',
            cls: 'labelstyle',
            id: 'sealedBagDispTotalId'
            },{height:5},{height:5},{height:5},{height:5},{width:50},{
            xtype: 'label',
            text: 'Total Sealed Bag Inward' + ' :',
            cls: 'labelstyle',
            id: 'totalSealBagInwardLabelId'
        	},{width:5},{
            xtype: 'label',
            text: '',
            cls: 'labelstyle',
            id: 'sealBagInwardTotalId'
        	},{height:15},{height:15},{height:15},{height:15},{width:50},{
            xtype: 'label',
            text: 'Total Cheque Dispense' + ' :',
            cls: 'labelstyle',
            id: 'chequeDispTotalLblId'
            },{width:5},{
            xtype: 'label',
            text: '',
            cls: 'labelstyle',
            id: 'chequeDispTotalId'
            },{height:5},{height:5},{height:5},{height:5},{width:50},{
            xtype: 'label',
            text: 'Total Cheque Inward' + ' :',
            cls: 'labelstyle',
            id: 'totalchequeInwardLabelId'
        	},{width:5},{
            xtype: 'label',
            text: '',
            cls: 'labelstyle',
            id: 'chequeInwardTotalId'
        	},{height:15},{height:15},{height:15},{height:15},{width:50},{
            xtype: 'label',
            text: 'Total Jewellery Dispense' + ' :',
            cls: 'labelstyle',
            id: 'jewelleryDispTotalLblId'
            },{width:5},{
            xtype: 'label',
            text: '',
            cls: 'labelstyle',
            id: 'jewelleryDispTotalId'
            },{height:5},{height:5},{height:5},{height:5},{width:50},{
            xtype: 'label',
            text: 'Total Jewellery Inward' + ' :',
            cls: 'labelstyle',
            id: 'totalJewelleryInwardLabelId'
        	},{width:5},{
            xtype: 'label',
            text: '',
            cls: 'labelstyle',
            id: 'jewelleryInwardTotalId'
        	},{height:15},{height:15},{height:15},{height:15},{width:50},{
            xtype: 'label',
            text: 'Total Foreign Currency Dispense' + ' :',
            cls: 'labelstyle',
            id: 'foreignCurrencyDispTotalLblId'
            },{width:5},{
            xtype: 'label',
            text: '',
            cls: 'labelstyle',
            id: 'foreignCurrencyDispTotalId'
            },{height:5},{height:5},{height:5},{height:5},{width:50},{
            xtype: 'label',
            text: 'Total Foreign Currency Inward' + ' :',
            cls: 'labelstyle',
            id: 'totalForeignCurrencyInwardLabelId'
        	},{width:5},{
            xtype: 'label',
            text: '',
            cls: 'labelstyle',
            id: 'foreignCurrencyInwardTotalId'
        	},{height:20},{height:20},{height:20},{height:20},{width:50},{
            xtype: 'label',
            text: '<%=currentDate%>',
            cls: 'labelstyle',
            id: 'dateLblId'
            },{width:5},{
            xtype: 'label',
            text: '',
            cls: 'labelstyle'
            },{height:10},{height:10},{height:10},{height:10},{width:50},{
            xtype: 'label',
            text: 'Ledger Balance'+' :',
            cls: 'labelstyle',
            id: 'legderBalanceLblId'
        	},{width:5},{
            xtype: 'label',
            text: '',
            cls: 'labelstyle',
            id: 'ledgerBalanceId'
        	},{height:10},{height:10},{height:10},{height:10},{width:50},{
            xtype: 'label',
            text: 'Available balance'+' :',
            cls: 'labelstyle',
            id: 'availableBlnceLblId'
        	},{width:5},{
            xtype: 'label',
            text: '',
            cls: 'labelstyle',
            id: 'availableBalanceId'
        	},{height:10},{height:10},{height:10},{height:10},{width:50},{
            xtype: 'label',
            text: 'Sealed Bag Balance'+' :',
            cls: 'labelstyle',
            id: 'sealedBagBalanceLblId'
        	},{width:5},{
            xtype: 'label',
            text: '',
            cls: 'labelstyle',
            id: 'sealedBagBalanceId'
        	},{height:10},{height:10},{height:10},{height:10},{width:50},{
            xtype: 'label',
            text: 'Cheque Balance'+' :',
            cls: 'labelstyle',
            id: 'chequeBalanceLblId'
        	},{width:5},{
            xtype: 'label',
            text: '',
            cls: 'labelstyle',
            id: 'chequeBalanceId'
        	},{height:10},{height:10},{height:10},{height:10},{width:50},{
            xtype: 'label',
            text: 'Jewellery Balance'+' :',
            cls: 'labelstyle',
            id: 'jewelleryBalanceLblId'
        	},{width:5},{
            xtype: 'label',
            text: '',
            cls: 'labelstyle',
            id: 'jewelleryBalanceId'
        	},{height:10},{height:10},{height:10},{height:10},{width:50},{
            xtype: 'label',
            text: 'Foreign Currency Balance'+' :',
            cls: 'labelstyle',
            id: 'foreignCurrencyBalanceLblId'
        	},{width:5},{
            xtype: 'label',
            text: '',
            cls: 'labelstyle',
            id: 'foreignCurrencyBalanceId'
        	},{height:10},{height:10},{height:10},{height:10},{width:50},{
            xtype: 'label',
            text: 'Total Value'+' :',
            cls: 'labelstyle',
            id: 'totalValueLblId'
        	},{width:5},{
            xtype: 'label',
            text: '',
            cls: 'labelstyle',
            id: 'totalValueId'
        	}]
    });
    Grid = getGrid('', '<%=NoRecordsFound%>', store, 920, 400, 18, filters, '', false, '', 18, false, '', false, '', false, '<%=Excel%>', jspName, exportDataType, true, '<%=PDF%>');
	function getGrid(gridtitle,emptytext,store,width,height,gridnoofcols,filters,filterstr,reconfigure,reconfigurestr,reconfigurenoofcols,group,groupstr,chart,chartstr,excel,excelstr,jspName,exportDataType,pdf,pdfstr,add,addstr,modify,modifystr,del,delstr,closetrip,closestr,verify,verifystr,approve, approvestr,copy, copystr,postpone,postponestr,importExcel,importStr,save,saveStr,clearData,clearStr,close,closeStr){
		var grid = new Ext.grid.GridPanel({
	    	title:gridtitle,
	        border: false,
	        height: getGridHeight(),
	        autoScroll:true,
	        store: store,
	        id:'grid',
	        colModel: createColModel(gridnoofcols),
	        loadMask: true,
	        view: new Ext.grid.GroupingView({
	        	autoFill:true,
	            groupTextTpl: getGroupConfig(),
	            emptyText: emptytext,deferEmptyText: false
	        }),
	        listeners: {
                render : function(grid){
                  grid.store.on('load', function(store, records, options){
                    grid.getSelectionModel().selectFirstRow();       
                  });                      
                }
               },
	        bbar: new Ext.Toolbar({
	        })
	    });
	if(width>0){
		grid.setSize(width,height);
	}

	if(reconfigure){
		grid.getBottomToolbar().add([
		 '-',                            
			{
            text: reconfigurestr,
            handler: function () {
			grid.reconfigure(store, createColModel(reconfigurenoofcols));
            } 
        }]);
		}
		if(group){
			grid.getBottomToolbar().add([
			'-',                             
			{
			    text:groupstr,
			    handler : function(){
				store.clearGrouping();
			    }    
			  }]);
		}

		if(excel)
		{
			grid.getBottomToolbar().add([
			'-',                             
			{
			    text:'',
			    iconCls : 'excelbutton',
			    handler : function(){
				getordreport('xls','All',jspName,grid,exportDataType);
			    }    
			  }]);
		}
		if(pdf)
		{
			grid.getBottomToolbar().add([
			'->',                             
			{
			    text:'',
			    iconCls : 'pdfbutton',
			    handler : function(){
			    getordreport('pdf','All',jspName,grid,exportDataType);

			    }    
			  }]);
		}
		return grid;
	}
	store.on('datachanged', function () {
    	getTotals();
    });
    function valuewithcommas(value){
    	return value.replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1,");
    }
	function getordreport(type,desc,filename,grid,exportDataType){
		if (Ext.getCmp('custcomboId').getRawValue() == "") {
           Ext.example.msg("<%=SelectCustomer%>");
           Ext.getCmp('custcomboId').focus();
           return;
	    }
		var cvsCustId = Ext.getCmp('custcomboId').getValue();
		var startDate = Ext.getCmp('tripStartDtId').getRawValue();
		var endDate = Ext.getCmp('tripEndDtId').getRawValue();
		var custType = Ext.getCmp('custTypeComboId').getValue();
		parent.open("<%=request.getContextPath()%>/exportLedger?cvsCustId="+ cvsCustId +"&startDate="+ startDate +"&endDate="+endDate+"&custType="+ custType +"");
	}
	var Panel = new Ext.Panel({
        standardSubmit: true,
        collapsible: false,
        title:'',
        id: 'panelId',
        layout: 'table',
        width: 920,
        frame: true,
        layoutConfig: {
            columns: 11
        },
        items: [{
            xtype: 'label',
            text: '<%=CustomerName%>' + ' :',
            cls: 'labelstyle',
            id: 'custnamelab'
            },{width:5},custnamecombo,{width:30},{
            xtype: 'label',
            text: 'Type' + ' :',
            cls: 'labelstyle',
            id: 'typeLblId'
        	},{width:5},typeCombo,{width:30},{
            xtype: 'label',
            text: 'Business Type' + ' :',
            cls: 'labelstyle',
            id: 'custtypeLblId'
        	},{width:5},custTypeCombo,{
            xtype: 'label',
            text: 'From' + ' :',
            cls: 'labelstyle',
            id: 'tripStartDtLabelId'
        	},{width:5},{
            xtype: 'datefield',
            cls: 'selectstylePerfect',
            format: getDateTimeFormat(),
            value:'<%=fromDate%>',
            id: 'tripStartDtId'
        	},{width:30},{
            xtype: 'label',
            text: 'To',
            cls: 'labelstyle',
            id: 'tripEndDtLabelId'
        	},{width:5},{
            xtype: 'datefield',
            cls: 'selectstylePerfect',
            format: getDateTimeFormat(),
            value:'<%=toDate%>',
            id: 'tripEndDtId'
        	},{width:30},{
  		    xtype: 'button',
  		    text: '<%=View%>',
  		    id: 'viewButton',
  		    cls: ' ',
  		    width: 60,
  		    listeners: {
  		    	click: {
  		        	fn: function () {
	                    if (Ext.getCmp('custcomboId').getRawValue() == "") {
	                        Ext.example.msg("<%=SelectCustomer%>");
	                        Ext.getCmp('custcomboId').focus();
	                        return;
	                    }
	                    if (Ext.getCmp('typeComboId').getRawValue() == "") {
	                        Ext.example.msg("<%=SelectCustomer%>");
	                        Ext.getCmp('typeComboId').focus();
	                        return;
	                    }
	                    if(Ext.getCmp('typeComboId').getValue() == '2'){
		                    if (Ext.getCmp('custTypeComboId').getValue() == "") {
		                        Ext.example.msg("Please select Business Type");
		                        Ext.getCmp('custTypeComboId').focus();
		                        return;
		                    }
	                    }
	                    if (Ext.getCmp('tripStartDtId').getValue() == "") {
	                        Ext.example.msg("<%=SelectStartDate%>");
	                        Ext.getCmp('tripStartDtId').focus();
	                        return;
	                    }
	                    if (Ext.getCmp('tripEndDtId').getValue() == "") {
	                        Ext.example.msg("<%=SelectEndDate%>");
	                        Ext.getCmp('tripEndDtId').focus();
	                        return;
	                    }
		                var startdates = Ext.getCmp('tripStartDtId').getValue();
		                var enddates = Ext.getCmp('tripEndDtId').getValue();
		                        
		                if (dateCompare(startdates,enddates) == -1) {
                        	Ext.example.msg("<%=EndDateMustBeGreaterthanStartDate%>");
                           	Ext.getCmp('tripEndDtId').focus();
                           	return;
                        }
                        if (checkMonthValidation(startdates, enddates)) {
                            Ext.example.msg("<%=MonthValidation%>");
                            Ext.getCmp('tripEndDtId').focus();
                            return;
		                }
		                store.load({
                        params:{
                       		CustId: Ext.getCmp('custcomboId').getValue(),
                          	startDate: Ext.getCmp('tripStartDtId').getValue(),
                          	endDate: Ext.getCmp('tripEndDtId').getValue(),
                          	custType: Ext.getCmp('custTypeComboId').getValue()
                        }
                        });
                        currentInventoryBanance.load({
                        	params:{custId:Ext.getCmp('custcomboId').getValue()},
                        	callback: function(){
                        		var rec = currentInventoryBanance.getAt(0);
                        		
                        		
                        		Ext.getCmp('ledgerBalanceId').setText(valuewithcommas(rec.data['ledgerBalance'].toFixed(2)));
                        		Ext.getCmp('availableBalanceId').setText(valuewithcommas(rec.data['availableBalance'].toFixed(2)));
                        		Ext.getCmp('sealedBagBalanceId').setText(valuewithcommas(rec.data['sealedBagBalance'].toFixed(2)));
                        		Ext.getCmp('chequeBalanceId').setText(valuewithcommas(rec.data['chequeBalance'].toFixed(2)));
                        		Ext.getCmp('jewelleryBalanceId').setText(valuewithcommas(rec.data['jewelleryBalance'].toFixed(2)));
                        		Ext.getCmp('foreignCurrencyBalanceId').setText(valuewithcommas(rec.data['forexBalance'].toFixed(2)));
                        		Ext.getCmp('totalValueId').setText(valuewithcommas(rec.data['total'].toFixed(2)));
                        	}
                        });
  		             }
  		           }
  		        }
  		    }]
    }); // End of Panel	
    function getTotals() {
    tot = 0.0;
    tot1 = 0.0;
    tot2 = 0.0;
    tot3 = 0.0;
    tot4 = 0.0;
    tot5 = 0.0;
    tot6 = 0.0;
    tot7 = 0.0;
    tot8 = 0.0;
    tot9 = 0.0;
    for (var i = 0; i < Grid.store.data.items.length; i++) {
        var rec = Grid.store.getAt(i);
		tot = tot + (parseFloat(rec.data['cashDispenseDI']));
		tot1 = tot1 + (parseFloat(rec.data['cashInwardDI']));
		tot2 = tot2 + (parseFloat(rec.data['sealedBagDispDI']));
		tot3 = tot3 + (parseFloat(rec.data['sealedBagInwardDI']));
		tot4 = tot4 + (parseFloat(rec.data['chequeDispDI']));
		tot5 = tot5 + (parseFloat(rec.data['chequeInwardDI']));
		tot6 = tot6 + (parseFloat(rec.data['jewelleryDispDI']));
		tot7 = tot7 + (parseFloat(rec.data['jewelleryInwardDI']));
		tot8 = tot8 + (parseFloat(rec.data['foreignCurrencyDispDI']));
		tot9 = tot9 + (parseFloat(rec.data['foreignCurrencyInwardDI']));
    }
    tot = tot.toFixed(2);
	tot1 = tot1.toFixed(2);	
	tot2 = tot2.toFixed(2);
	tot3 = tot3.toFixed(2);
	tot4 = tot4.toFixed(2);
	tot5 = tot5.toFixed(2);
	tot6 = tot6.toFixed(2);
	tot7 = tot7.toFixed(2);
	tot8 = tot8.toFixed(2);
	tot9 = tot9.toFixed(2);
    if (tot == "NaN") {
        tot = 0.0;
    }
    if (tot1 == "NaN") {
        tot1 = 0.0;
    }
    if (tot2 == "NaN") {
        tot2 = 0.0;
    }
    if (tot3 == "NaN") {
        tot3 = 0.0;
    }
    if (tot4 == "NaN") {
        tot4 = 0.0;
    }
    if (tot5 == "NaN") {
        tot5 = 0.0;
    }
    if (tot6 == "NaN") {
        tot6 = 0.0;
    }
    if (tot7 == "NaN") {
        tot7 = 0.0;
    }
    if (tot8 == "NaN") {
        tot8 = 0.0;
    }
    if (tot9 == "NaN") {
        tot9 = 0.0;
    }
    
    
    Ext.getCmp('cashDispTotalId').setText(valuewithcommas(tot)+" Dr");
    Ext.getCmp('cashInwardTotalId').setText(valuewithcommas(tot1)+" Cr");
    Ext.getCmp('sealedBagDispTotalId').setText(valuewithcommas(tot2)+" Dr");
    Ext.getCmp('sealBagInwardTotalId').setText(valuewithcommas(tot3)+" Cr");
    Ext.getCmp('chequeDispTotalId').setText(valuewithcommas(tot4)+" Dr");
    Ext.getCmp('chequeInwardTotalId').setText(valuewithcommas(tot5)+" Cr");
    Ext.getCmp('jewelleryDispTotalId').setText(valuewithcommas(tot6)+" Dr");
    Ext.getCmp('jewelleryInwardTotalId').setText(valuewithcommas(tot7)+" Cr");
    Ext.getCmp('foreignCurrencyDispTotalId').setText(valuewithcommas(tot8)+" Dr");
    Ext.getCmp('foreignCurrencyInwardTotalId').setText(valuewithcommas(tot9)+" Cr");
	}
	var notePanel = new Ext.Panel({
        id: 'notePanelId',
        standardSubmit: true,
        collapsible: false,
        frame: false,
        layout: 'table',
        layoutConfig: {
            columns: 1
        },
        items: [{
        	html:'<div style="font-weight:bold;color:black;font-size:13px;margin:10px 0px 5px 0px;">Note: SB - indicates sealed bag amount, CQ - indicates cheque amount, JW - indicates jewellery amount, FX - indicates foreign currency</b></div>'
        }]  	
    });
    var PanelGrid = new Ext.Panel({
        id: 'panelGridId',
        standardSubmit: true,
        collapsible: false,
        frame: false,
        layout: 'table',
        layoutConfig: {
            columns: 1
        },
        items: [Grid, notePanel]  	
    });
    var Panel1 = new Ext.Panel({
        id: 'gridPanelId',
        standardSubmit: true,
        collapsible: false,
        frame: false,
        layout: 'table',
        layoutConfig: {
            columns: 1
        },
        items: [Panel, PanelGrid]  	
    });
	
    Ext.onReady(function () {
        ctsb = tsb;
        Ext.QuickTips.init();
        Ext.form.Field.prototype.msgTarget = 'side';
        outerPanel = new Ext.Panel({
            renderTo: 'content',
            standardSubmit: true,
            frame: true,
            cls: 'outerpanel',
            layout: 'table',
            height: 510,
            width: screen.width-30,
            layoutConfig: {
                columns: 2
            },
            items: [Panel1, fieldPanel]
        });
    var cm = Grid.getColumnModel();  
    for (var j = 1; j < cm.getColumnCount(); j++) {
       cm.setColumnWidth(j,139);
    }
    Grid.getView().getRowClass = function(record, index) {
    	var rowcolour;
    	var inwardMode = record.data.inwardModeDI;
    	if (inwardMode == "SUSPEND TRIP"){
        	rowcolour = 'green-row';}
        	return rowcolour;
    };
    });
</script>
</body>
</html>