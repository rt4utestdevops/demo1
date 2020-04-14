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

%>

<jsp:include page="../Common/header.jsp" />
	<title>Summary Invoice</title>	
	
<style>

</style>	

	<%if (loginInfo.getStyleSheetOverride().equals("Y")){%>                  
    	<jsp:include page="../Common/ImportJSSandMining.jsp"/>                                               
   	<%}else {%>  
   		<jsp:include page="../Common/ImportJS.jsp" /><%} %>
		<style>
			.x-layer ul {
				min-height: 27px !important;
			}
			label {
				display : inline !important;
			}
			.ext-strict .x-form-text {
				height: 21px !important;
			}
		</style>
		
   	<script>
   	var outerPanel;
    var ctsb;
    var Grid;
    var dtprev = dateprev;
    var dtcur = datecur;
	var jspName;
	var exportDataType;	
	var fromDate = datecur;
	var toDate = nextMonth;
	var invoiceType;
	var typeArray = [['1','Billing'],['2','Unloading']];
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
               		store.load({params:{principalId : ''}});
                }
            }
        }
    });
    var principalComboStore = new Ext.data.JsonStore({
        url: '<%=request.getContextPath()%>/sumarrtInvoicePTAction.do?param=getPrincipal',
        id: 'PrincipalStoreId',
        root: 'PrincipalRoot',
        autoLoad: true,
        remoteSort: true,
        fields: ['principalId', 'principalName', 'invoiceType']
    });

    var principalCombo = new Ext.form.ComboBox({
        store: principalComboStore,
        id: 'principalComboId',
        mode: 'local',
        forceSelection: true,
        emptyText: 'Select Principal',
        selectOnFocus: true,
        allowBlank: false,
        anyMatch: true,
        typeAhead: false,
        triggerAction: 'all',
        lazyRender: true,
        valueField: 'principalId',
        displayField: 'principalName',
        cls: 'selectstylePerfect',
        listeners: {
            select: {
                fn: function () {
                	store.load({params:{principalId : ''}});
                }
            }
        }
    });

    var reader = new Ext.data.JsonReader({
        idProperty: 'readerId',
        root: 'summaryGridRoot',
        totalProperty: 'total',
        fields: [{
            name: 'slnoIndex'
        },{
            name: 'consigneeDI'
        },{
            name: 'quantityDI'
        },{
            name: 'typeDI'
        },{
            name: 'rateDI'
        },{
            name: 'amountDI'
        }]
    });

    var store = new Ext.data.GroupingStore({
        autoLoad: false,
        proxy: new Ext.data.HttpProxy({
            url: '<%=request.getContextPath()%>/sumarrtInvoicePTAction.do?param=getSumarryInvoiceDetails',
            method: 'POST'
        }),
        remoteSort: false,
        storeId: 'summaryStoreId',
        reader: reader
    });

    var filters = new Ext.ux.grid.GridFilters({
        local: true,
        filters: [{
            type: 'numeric',
            dataIndex: 'slnoIndex'
        }, {
            type: 'string',
            dataIndex: 'consigneeDI'
        }, {
            type: 'numeric',
            dataIndex: 'quantityDI'
        }, {
            type: 'string',
            dataIndex: 'typeDI'
        },{
            type: 'numeric',
            dataIndex: 'rateDI'
        },{
            type: 'numeric',
            dataIndex: 'amountDI'
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
                header: "<span style=font-weight:bold;>Consignee</span>",
                dataIndex: 'consigneeDI',
                filter: {
                    type: 'string'
                }
            }, {
                header: "<span style=font-weight:bold;>Quantity</span>",
                dataIndex: 'quantityDI',
                filter: {
                    type: 'nimeric'
                }
            },{
                header: "<span style=font-weight:bold;>Billing Type</span>",
                dataIndex: 'typeDI',
                filter: {
                    type: 'string'
                }
            },{
                header: "<span style=font-weight:bold;>Rate</span>",
                dataIndex: 'rateDI',
                filter: {
                    type: 'numeric'
                }
            },{
                header: "<span style=font-weight:bold;>Amount</span>",
                dataIndex: 'amountDI',
                filter: {
                    type: 'numeric'
                }
            },];
			return new Ext.grid.ColumnModel({
            columns: columns.slice(start || 0, finish),
            defaults: {
                sortable: true
            }
        });
    };

    Grid = getGrid('Invoice Sumarry Details', 'No Records Found', store, screen.width - 35, 420, 10, filters, 'ClearFilterData', false,'', 31, false, '', true, 'Generate');
	
	function columnchart(){
		Ext.getCmp('chartId').disable();
		if (Ext.getCmp('principalComboId').getRawValue() == "") {
           Ext.example.msg("<%=SelectCustomer%>");
           Ext.getCmp('principalComboId').focus();
           Ext.getCmp('chartId').enable();
           return;
	    }
	    if(Grid.getStore().data.length == 0){
	    	Ext.example.msg("No recors found");
           	Ext.getCmp('chartId').enable();
           	return;
	    }
		var principalId = Ext.getCmp('principalComboId').getValue();
		var startDate = Ext.getCmp('tripStartDtId').getRawValue();
		var endDate = Ext.getCmp('tripEndDtId').getRawValue();
		var typeId =  Ext.getCmp('typeComboId').getValue();
		
		parent.open("<%=request.getContextPath()%>/pdfForSummaryInvoice?principalId="+ principalId +"&startDate="+ startDate +"&endDate="+endDate+"&typeId="+ typeId +"&invoiceType="+invoiceType+"");
		Ext.getCmp('chartId').enable();
	}
	var Panel = new Ext.Panel({
        standardSubmit: true,
        collapsible: false,
        title:'',
        id: 'panelId',
        layout: 'table',
        width: screen.width - 30,
        frame: true,
        layoutConfig: {
            columns: 10
        },
        items: [{width:30},{
            xtype: 'label',
            text: 'Principal' + ' :',
            cls: 'labelstyle',
            id: 'custnamelab'
            },{width:5},principalCombo,{width:60},{
            xtype: 'label',
            text: 'Type',
            cls: 'labelstyle',
            id: 'typeLblId'
        	},{width:5},typeCombo,{width:30},{height:30},{width:30},{
            xtype: 'label',
            text: 'From',
            cls: 'labelstyle',
            id: 'tripStartDtLabelId'
        	},{width:5},{
            xtype: 'datefield',
            cls: 'selectstylePerfect',
            format: getDateTimeFormat(),
            value: fromDate,
            id: 'tripStartDtId',
            menuListeners: {
	    	select: function(m, d) {
	    		this.setValue(d);
	    		store.load({params:{principalId : ''}});
	    		}
	    	}
        	},{width:60},{
            xtype: 'label',
            text: 'To',
            cls: 'labelstyle',
            id: 'tripEndDtLabelId'
        	},{width:5},{
            xtype: 'datefield',
            cls: 'selectstylePerfect',
            format: getDateTimeFormat(),
            value: toDate,
            id: 'tripEndDtId',
            menuListeners: {
	    	select: function(m, d) {
	    		this.setValue(d);
	    		store.load({params:{principalId : ''}});
	    		}
	    	}
        	},{width:30},{
  		    xtype: 'button',
  		    text: '<%=View%>',
  		    id: 'viewButton',
  		    cls: ' ',
  		    width: 60,
  		    listeners: {
  		    	click: {
  		        	fn: function () {
	                    if (Ext.getCmp('principalComboId').getRawValue() == "") {
	                        Ext.example.msg("Please select Principal");
	                        Ext.getCmp('principalComboId').focus();
	                        return;
	                    }
	                    if (Ext.getCmp('typeComboId').getRawValue() == "") {
	                        Ext.example.msg("Please select Type");
	                        Ext.getCmp('typeComboId').focus();
	                        return;
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
		                var row = principalComboStore.findExact('principalId',Ext.getCmp('principalComboId').getValue());
		                var rec = principalComboStore.getAt(row);
		                invoiceType = rec.data['invoiceType'];
		                store.load({
                        params:{
                       		principalId: Ext.getCmp('principalComboId').getValue(),
                          	startDate: Ext.getCmp('tripStartDtId').getValue(),
                          	endDate: Ext.getCmp('tripEndDtId').getValue(),
                          	typeId: Ext.getCmp('typeComboId').getValue(),
                          	invoiceType: invoiceType
                        }
                        });
                     }
  		           }
  		        }
  		    }]
    }); // End of Panel	
  
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
                columns: 1
            },
            items: [Panel, Grid]
        });
    var cm = Grid.getColumnModel();  
    for (var j = 1; j < cm.getColumnCount(); j++) {
    	if(j == 2){
    		cm.setColumnWidth(j,420);
    	}else{
    		cm.setColumnWidth(j,210);
    	}
    }
    });
</script>
 <jsp:include page="../Common/footer.jsp" />
 <!-- </body>   -->
 <!-- </html> -->