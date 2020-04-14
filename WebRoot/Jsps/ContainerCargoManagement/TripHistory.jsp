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

tobeConverted.add("Trip_History");
tobeConverted.add("Loading_Branch_Name");	
tobeConverted.add("Select_Branch");
tobeConverted.add("Select_Branch_Name");
tobeConverted.add("Vehicle_Number");
tobeConverted.add("Select_Vehicle");
tobeConverted.add("Select_Vehicle_Number");
tobeConverted.add("Start_Date");
tobeConverted.add("End_Date");
tobeConverted.add("Select_Start_Date");
tobeConverted.add("Select_End_Date");
tobeConverted.add("View");
tobeConverted.add("End_Date_Must_Be_Greater_Than_Start_Date");
tobeConverted.add("Month_Validation");
tobeConverted.add("SLNO");
tobeConverted.add("Date");
tobeConverted.add("No_Records_Found");
tobeConverted.add("Clear_Filter_Data");
tobeConverted.add("Excel");
tobeConverted.add("Vehicle_Model");
tobeConverted.add("Trip_No");
tobeConverted.add("Loading_Branch");
tobeConverted.add("Principal_Name");
tobeConverted.add("Consignee_Name");
tobeConverted.add("Driver_Name");
tobeConverted.add("Driver_Contact_No");
tobeConverted.add("Trip_Start_Date");
tobeConverted.add("Trip_End_Date");
tobeConverted.add("GR_Number");
tobeConverted.add("GR_Date");
tobeConverted.add("Total_Drums");
tobeConverted.add("Master_Kms");
tobeConverted.add("Fuel_Consumption");
tobeConverted.add("R_Fee");
tobeConverted.add("B_Fee");
tobeConverted.add("Toll");
tobeConverted.add("Driver_Incentive");
tobeConverted.add("Police");
tobeConverted.add("Escort");
tobeConverted.add("Loading");
tobeConverted.add("Labour_Charges");
tobeConverted.add("Octroi");
tobeConverted.add("Other_Expenses");
tobeConverted.add("Morning_Incentive");
tobeConverted.add("Conveyance");
tobeConverted.add("Total_Approved_Additional_Expenses");
tobeConverted.add("Total_Trip_Expense");
tobeConverted.add("Driver_Advance");
tobeConverted.add("Billing_Tariff");
tobeConverted.add("Unloading_Charges");
tobeConverted.add("Detention_Charges");
tobeConverted.add("Receipted_Charges");
tobeConverted.add("Total_Bill");
tobeConverted.add("Profit_And_Loss");
tobeConverted.add("start_Date_End_Date_Validation");
tobeConverted.add("Reconfigure_Grid");
tobeConverted.add("Clear_Grouping");
tobeConverted.add("Trip_History_Report");

ArrayList<String> convertedWords=new ArrayList<String>();
convertedWords=cf.getLanguageSpecificWordForKey(tobeConverted,language);

String TripHistory=convertedWords.get(0);
String LoadingBranchName=convertedWords.get(1);
String SelectBranch=convertedWords.get(2);
String SelectBranchName=convertedWords.get(3);
String VehicleNo=convertedWords.get(4);
String SelectVehicle=convertedWords.get(5);
String SelectVehicalNo=convertedWords.get(6);
String StartDate=convertedWords.get(7);
String EndDate=convertedWords.get(8);
String SelectStartDate=convertedWords.get(9);
String SelectEndDate=convertedWords.get(10);
String View=convertedWords.get(11);
String startDateEndDateValication=convertedWords.get(12);
String monthValidation=convertedWords.get(13);
String slno=convertedWords.get(14);
String NoRecordsFound=convertedWords.get(16);
String ClearFilterData=convertedWords.get(17);
String Excel=convertedWords.get(18);
String VehicleModel=convertedWords.get(19);
String TripNo=convertedWords.get(20);
String LoadingBranch=convertedWords.get(21);
String PrincipalName=convertedWords.get(22);
String ConsigneeName=convertedWords.get(23);
String DriverName=convertedWords.get(24);
String DriverContactNo=convertedWords.get(25);
String TripStartDate=convertedWords.get(26);
String TripEndDate=convertedWords.get(27);
String GRNo=convertedWords.get(28);
String GRDate=convertedWords.get(29);
String TotalDrums=convertedWords.get(30);
String MasterKms=convertedWords.get(31);
String FuelConsumption=convertedWords.get(32);
String RFee=convertedWords.get(33);
String BFee=convertedWords.get(34);
String Toll=convertedWords.get(35);
String DriverIncentive=convertedWords.get(36);
String Police=convertedWords.get(37);
String Escort=convertedWords.get(38);
String Loading=convertedWords.get(39);
String LabourCharges=convertedWords.get(40);
String Octroi=convertedWords.get(41);
String OtherExpenses=convertedWords.get(42);
String MorningIncentive=convertedWords.get(43);
String Conveyance=convertedWords.get(44);
String TotalApprovedAdditionalExpenses=convertedWords.get(45);
String TotalTripExpense=convertedWords.get(46);
String DriverAdvance=convertedWords.get(47);
String BillingTariff=convertedWords.get(48);
String UnloadingCharges=convertedWords.get(49);
String DetentionCharges=convertedWords.get(50);
String ReceiptedCharges=convertedWords.get(51);
String TotalBill=convertedWords.get(52);
String ProfitAndLoss=convertedWords.get(53);
		
%>
<jsp:include page="../Common/header.jsp" /> 
    <title><%=TripHistory%></title>
 
  <style>
  .x-panel-tl
	{
		border-bottom: 0px solid !important;
	}
	#addbuttonid{
	margin-top: -9px !important ;
	}
  </style>
  <div height="100%">
   <%if (loginInfo.getStyleSheetOverride().equals("Y")){%>                  
    <jsp:include page="../Common/ImportJSSandMining.jsp"/>                                              
   <%}else {%>  
   <jsp:include page="../Common/ImportJS.jsp" />
   <%} %>
    <!-- for exporting to excel***** -->
   <jsp:include page="../Common/ExportJS.jsp" />
   <style>
	.ext-strict .x-form-text {
		height: 21px !important;
	}	
	label {
		display : inline !important;
	}
	.x-layer ul {
		min-height: 27px !important;
	}
	.x-window-tl *.x-window-header {
		padding-top : 6px !important;
	}
   </style>
    
    <script>
    var outerPanel;
 	var ctsb;
 	var dtprev;
 	var dtcur;
 	var jspName="TripHistory";
 	var exportDataType="int,string,string,string,string,string,string,string,string, date, date, number,number,number,number,number,number,number,number,number,number,number,number,number,number,number,number,number,number,number,number,number,number,number,number,string";
 	var selected;
 	var grid;
 	var buttonValue;
 	var titel;
 	var globalCustomerID=parent.globalCustomerID;
 	var myWin;
 	
 	//override function for showing first row in grid
 	Ext.override(Ext.grid.GridView, {
    	afterRender: function(){
        this.mainBody.dom.innerHTML = this.renderRows();
        this.processRows(0, true);
        if(this.deferEmptyText !== true){
            this.applyEmptyText();
        }
        this.fireEvent("viewready", this);//new event
    	}   
	});
	//***** BranchName combo ********
	var BranchNameStore = new Ext.data.JsonStore({
	   url: '<%=request.getContextPath()%>/TripHistoryAction.do?param=getBranch',
	   id:'BranchNameId',
       root: 'BranchNameList',
       autoLoad: true,
       remoteSort:true,
	   fields: ['BranchId','BranchName']
     });
	var BranchNamecombo = new Ext.form.ComboBox({
        store: BranchNameStore,
        id: 'brnachComboId',
        mode: 'local',
        forceSelection: true,
        emptyText: '<%=SelectBranch%>',
        selectOnFocus: true,
        allowBlank: false,
        anyMatch: true,
        typeAhead: false,
        triggerAction: 'all',
        lazyRender: true,
        valueField: 'BranchId',
        displayField: 'BranchName',
        cls: 'selectstylePerfect',
        loadingText: 'Searching...',
	    enableKeyEvents: true,
	    minChars: 2,
	    listeners: {
	        select: {
	            fn: function() {
	                branchNameId = Ext.getCmp('brnachComboId').getValue();
	                
	                summaryGrid.store.clearData();
  		            summaryGrid.view.refresh();
	            }
	        }
	    }
	});
	//***** vehicle combo *******		
	var vehicleStore= new Ext.data.JsonStore({
           url: '<%=request.getContextPath()%>/PTFuelLogAction.do?param=getVehicles',
           id: 'vehicleStoreId',
				    root: 'vehicleStoreRoot',
				    autoload: false,
				    remoteSort: true,
				    fields: ['VehicleNo']
	});
	  var vehiclecombo = new Ext.form.ComboBox({
        store: vehicleStore,
        id: 'vehiclecomboId',
        mode: 'local',
        forceSelection: true,
        emptyText: '<%=SelectVehicle%>',
        selectOnFocus: true,
        allowBlank: false,
        anyMatch: true,
        typeAhead: false,
        triggerAction: 'all',
        lazyRender: true,
        valueField: 'VehicleNo',
        displayField: 'VehicleNo',
        cls: 'selectstylePerfect',
        loadingText: 'Searching...',
	    enableKeyEvents: true,
	    minChars: 2,
	    listeners: {
	        select: {
	            fn: function() {
	                vehId = Ext.getCmp('vehiclecomboId').getValue();
	                
	                summaryGrid.store.clearData();
  		            summaryGrid.view.refresh();
	            }
	        }
	    }
	});	
	
	//********* innerPanel ********		
	var innerPanel = new Ext.Panel({
  	standardSubmit: true,
  	collapsible: false,
  	id: 'traderMaster',
  	layout: 'table',
  	frame: true,
  	width: screen.width -45,
  	layoutConfig: {
  	columns: 15
  	},
  	items: [
  			{
  		     xtype: 'label',
  		     text: '<%=LoadingBranchName%>' + ' :',
  		     cls: 'labelstyle',
  		     id: 'branchnamelab'
  		   },
  		     BranchNamecombo, {
  		     width: 40
  		   },
  		    {
  		     xtype: 'label',
  		     text: '<%=VehicleNo%>' + ' :',
  		     cls: 'labelstyle',
  		     id: 'vehiclelab'
  		   },
  		     vehiclecombo, {
  		     width: 40
  		   },
  		    {
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
  		     width: 40
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
  		     width: 60
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
  		                if(Ext.getCmp('brnachComboId').getValue() == "") {
  		                   Ext.example.msg("<%=SelectBranchName%>");
  		                   Ext.getCmp('brnachComboId').focus();
  		                   return;
  		                }
  		              	if(Ext.getCmp('vehiclecomboId').getValue() == "" ) {
						   Ext.example.msg("<%=SelectVehicalNo%>");
						   Ext.getCmp('vehiclecomboId').focus();
				           return;
						}
						if(Ext.getCmp('startdate').getValue() == "" ) {
						   Ext.example.msg("<%=SelectStartDate%>");
						   Ext.getCmp('startdate').focus();
				           return;
						}
						if(Ext.getCmp('enddate').getValue() == "" ) {
						   Ext.example.msg("<%=SelectEndDate%>");
						   Ext.getCmp('enddate').focus();
				           return;
						}
							    
						var startdates=Ext.getCmp('startdate').getValue();
            		 	var enddates=Ext.getCmp('enddate').getValue();
            		 			
            		 	var d1 = new Date(startdates);
            		 	var d2 = new Date(enddates);
            		 			
               		 	if(d1>d2)
            		 	{
							Ext.example.msg("<%=startDateEndDateValication%>");
							return;
						}	
								
						if (checkMonthValidation(startdates, enddates)) {
  		                    Ext.example.msg("<%=monthValidation%>");
  		                    Ext.getCmp('enddate').focus();
  		                    return;
  		                }
  		                TripHistoryStore.load({
  		                    params: {
  		                    	branchNameId: Ext.getCmp('brnachComboId').getValue(),
  		                    	branchName: Ext.getCmp('brnachComboId').getRawValue(),
  		                       	vehId: Ext.getCmp('vehiclecomboId').getValue(),
  		                        startDate: Ext.getCmp('startdate').getValue(),
  		                        endDate: Ext.getCmp('enddate').getValue(),
  		                        jspName: jspName
  		                    	},
  		                    });	                       
  		                 }
  		              }
  		           }
  		        }
  		    ]
  		}); // End of Panel	
//============================ Grid table creation ================================
		//********** reader *************
     	var reader = new Ext.data.JsonReader({
        idProperty: 'darreaderid',
        root: 'TripHistoryRoot',
        totalProperty: 'total',
        fields: [{
        	name: 'slnoIndex'
        },{
            name: 'loadingBranchIndex'
        }, {
            name: 'vehicalNoIndex'
        }, {
            name: 'vehicalModelIndex'
        }, {
            name: 'tripNoIndex'
        }, {
            name: 'principalNameIndex'
        }, {
            name: 'consigneeNameIndex'
        }, {
            name: 'driverNameIndex'
        }, {
            name: 'driverContactNoIndex'
        }, {
            name: 'tripStartDateIndex',
            type: 'date',
  		    dateFormat: getDateTimeFormat()
        }, {
            name: 'tripEndDateIndex',
            type: 'date',
  		    dateFormat: getDateTimeFormat()
        }, {
            name: 'grNoIndex'
        }, {
            name: 'totalDrumsIndex'
        }, {
            name: 'masterKMSIndex'
        }, {
            name: 'fuelConsumptionIndex'
        }, {
            name: 'rFeeIndex'
        }, {
            name: 'bFeeIndex'
        }, {
            name: 'tollIndex'
        }, {
            name: 'driverIncentiveIndex'
        }, {
            name: 'policeIndex'
        }, {
            name: 'escortIndex'
        }, {
            name: 'loadingIndex'
        }, {
            name: 'labourChargesIndex'
        }, {
            name: 'octroiIndex'
        }, {
            name: 'otherExpensesIndex'
        }, {
            name: 'morningIncentiveIndex'
        }, {
            name: 'conveyanceIndex'
        }, {
            name: 'totalApprovedAdditionalExpensesIndex'
        }, {
            name: 'totalTripExpenseIndex'
        }, {
            name: 'driverAdvanceIndex'
        }, {
            name: 'billingTariffIndex'
        }, {
            name: 'unloadingChargesIndex'
        }, {
            name: 'detentionChargesIndex'
        }, {
            name: 'receiptedChargesIndex'
        }, {
            name: 'totalBillIndex'
        }, {
            name: 'profitLossIndex'
        }]
    });
		//********** store *****************
		var TripHistoryStore = new Ext.data.GroupingStore({
        autoLoad: false,
        proxy: new Ext.data.HttpProxy({
           	url: '<%=request.getContextPath()%>/TripHistoryAction.do?param=getTripHistoryData',
            method: 'POST'
        }),
        remoteSort: false,
        storeId: 'darstore',
        reader: reader
    	});
    	
		//*********** filters **********
		var filters = new Ext.ux.grid.GridFilters({
        local: true,
        filters: [{
            type: 'numeric',
            dataIndex: 'slnoIndex'
        },{
            type: 'string',
            dataIndex: 'loadingBranchIndex'
        }, {
            type: 'string',
            dataIndex: 'vehicalNoIndex'
        }, {
            type: 'string',
            dataIndex: 'vehicalModelIndex'
        }, {
            type: 'string',
            dataIndex: 'tripNoIndex'
        }, {
            type: 'string',
            dataIndex: 'principalNameIndex'
        },{
            type: 'string',
            dataIndex: 'consigneeNameIndex'
        },{
            type: 'string',
            dataIndex: 'driverNameIndex'
        },{
            type: 'string',
            dataIndex: 'driverContactNoIndex'
        },{
            type: 'date',
            dataIndex: 'tripStartDateIndex'
        },{
            type: 'date',
            dataIndex: 'tripEndDateIndex'
        },{
            type: 'numeric',
            dataIndex: 'grNoIndex'
        },{
            type: 'numeric',
            dataIndex: 'totalDrumsIndex'
        },{
            type: 'numeric',
            dataIndex: 'masterKMSIndex'
        },{
            type: 'numeric',
            dataIndex: 'fuelConsumptionIndex'
        },{
            type: 'numeric',
            dataIndex: 'rFeeIndex'
        },{
            type: 'numeric',
            dataIndex: 'bFeeIndex'
        },{
            type: 'numeric',
            dataIndex: 'tollIndex'
        },{
            type: 'numeric',
            dataIndex: 'driverIncentiveIndex'
        },{
            type: 'numeric',
            dataIndex: 'policeIndex'
        },{
            type: 'numeric',
            dataIndex: 'escortIndex'
        },{
            type: 'numeric',
            dataIndex: 'loadingIndex'
        },{
            type: 'numeric',
            dataIndex: 'labourChargesIndex'
        },{
            type: 'numeric',
            dataIndex: 'octroiIndex'
        },{
            type: 'numeric',
            dataIndex: 'otherExpensesIndex'
        },{
            type: 'numeric',
            dataIndex: 'morningIncentiveIndex'
        },{
            type: 'numeric',
            dataIndex: 'conveyanceIndex'
        },{
            type: 'numeric',
            dataIndex: 'totalApprovedAdditionalExpensesIndex'
        },{
            type: 'numeric',
            dataIndex: 'totalTripExpenseIndex'
        },{
            type: 'numeric',
            dataIndex: 'driverAdvanceIndex'
        },{
            type: 'numeric',
            dataIndex: 'billingTariffIndex'
        },{
            type: 'numeric',
            dataIndex: 'unloadingChargesIndex'
        },{
            type: 'numeric',
            dataIndex: 'detentionChargesIndex'
        },{
            type: 'numeric',
            dataIndex: 'receiptedChargesIndex'
        },{
            type: 'numeric',
            dataIndex: 'totalBillIndex'
        },{
            type: 'numeric',
            dataIndex: 'profitLossIndex'
        }]
      });
		
		//************************************Column Model Config******************************************
    	var createColModel = function (finish, start) {

        var columns = [
            new Ext.grid.RowNumberer({
                header: "<span style=font-weight:bold;><%=slno%></span>",
                width: 50
            }),{
                dataIndex: 'slnoIndex',
                hidden: true,
                header: "<span style=font-weight:bold;><%=slno%></span>",
                filter: {
                    type: 'numeric'
                }
            }, {
                header: "<span style=font-weight:bold;><%=LoadingBranch%></span>",
                dataIndex: 'loadingBranchIndex',
                width: 100,
                filter: {
                    type: 'string'
                }
            }, {
                header: "<span style=font-weight:bold;><%=VehicleNo%></span>",
                dataIndex: 'vehicalNoIndex',
                width: 100,
                filter: {
                    type: 'string'
                }
            }, {
                header: "<span style=font-weight:bold;><%=VehicleModel%></span>",
                dataIndex: 'vehicalModelIndex',
                width: 100,
                filter: {
                    type: 'string'
                }
            }, {
                header: "<span style=font-weight:bold;><%=TripNo%></span>",
                dataIndex: 'tripNoIndex',
                width: 100,
                filter: {
                    type: 'string'
                }
            },{
                header: "<span style=font-weight:bold;><%=PrincipalName%></span>",
                dataIndex: 'principalNameIndex',
                width: 100,
                filter: {
                    type: 'string'
                }
            },{
                header: "<span style=font-weight:bold;><%=ConsigneeName%></span>",
                dataIndex: 'consigneeNameIndex',
                width: 100,
                filter: {
                    type: 'string'
                }
            },{
                header: "<span style=font-weight:bold;><%=DriverName%></span>",
                dataIndex: 'driverNameIndex',
                width: 100,
                filter: {
                    type: 'string'
                }
            },{
                header: "<span style=font-weight:bold;><%=DriverContactNo%></span>",
                dataIndex: 'driverContactNoIndex',
                width: 100,
                filter: {
                    type: 'string'
                }
            },{
                header: "<span style=font-weight:bold;><%=TripStartDate%></span>",
                dataIndex: 'tripStartDateIndex',
				renderer: Ext.util.Format.dateRenderer(getDateTimeFormat()),
				width: 120,
                filter: {
                    type: 'date'
                }
            },{
        		header: "<span style=font-weight:bold;><%=TripEndDate%></span>",
           	 	dataIndex: 'tripEndDateIndex',
            	renderer: Ext.util.Format.dateRenderer(getDateTimeFormat()),
            	width: 120,
            	filter: {
            	type: 'date'
            	}
        	},{
                header: "<span style=font-weight:bold;><%=GRNo%></span>",
                dataIndex: 'grNoIndex',
                width: 100,
                filter: {
                    type: 'numeric'
                }
            },{
                header: "<span style=font-weight:bold;><%=TotalDrums%></span>",
                dataIndex: 'totalDrumsIndex',
                width: 100,
                filter: {
                    type: 'numeric'
                }
            },{
                header: "<span style=font-weight:bold;><%=MasterKms%></span>",
                dataIndex: 'masterKMSIndex',
                width: 100,
                filter: {
                    type: 'numeric'
                }
            },{
                header: "<span style=font-weight:bold;><%=FuelConsumption%></span>",
                dataIndex: 'fuelConsumptionIndex',
                width: 100,
                filter: {
                    type: 'numeric'
                }
            },{
                header: "<span style=font-weight:bold;><%=RFee%></span>",
                dataIndex: 'rFeeIndex',
              width: 100,
                filter: {
                    type: 'numeric'
                }
            },{
                header: "<span style=font-weight:bold;><%=BFee%></span>",
                dataIndex: 'bFeeIndex',
                width: 100,
                filter: {
                    type: 'numeric'
                }
            },{
                header: "<span style=font-weight:bold;><%=Toll%></span>",
                dataIndex: 'tollIndex',
                width: 100,
                filter: {
                    type: 'numeric'
                }
            },{
                header: "<span style=font-weight:bold;><%=DriverIncentive%></span>",
                dataIndex: 'driverIncentiveIndex',
                width: 100,
                filter: {
                    type: 'numeric'
                }
            },{
                header: "<span style=font-weight:bold;><%=Police%></span>",
                dataIndex: 'policeIndex',
                width: 100,
                filter: {
                    type: 'numeric'
                }
            },{
                header: "<span style=font-weight:bold;><%=Escort%></span>",
                dataIndex: 'escortIndex',
                width: 100,
                filter: {
                    type: 'numeric'
                }
            },{
                header: "<span style=font-weight:bold;><%=Loading%></span>",
                dataIndex: 'loadingIndex',
                width: 100,
                filter: {
                    type: 'numeric'
                }
            },{
                header: "<span style=font-weight:bold;><%=LabourCharges%></span>",
                dataIndex: 'labourChargesIndex',
                width: 100,
                filter: {
                    type: 'numeric'
                }
            },{
                header: "<span style=font-weight:bold;><%=Octroi%></span>",
                dataIndex: 'octroiIndex',
                width: 100,
                filter: {
                    type: 'numeric'
                }
            },{
                header: "<span style=font-weight:bold;><%=OtherExpenses%></span>",
                dataIndex: 'otherExpensesIndex',
                width: 100,
                filter: {
                    type: 'numeric'
                }
            },{
                header: "<span style=font-weight:bold;><%=MorningIncentive%></span>",
                dataIndex: 'morningIncentiveIndex',
                width: 100,
                filter: {
                    type: 'numeric'
                }
            },{
                header: "<span style=font-weight:bold;><%=Conveyance%></span>",
                dataIndex: 'conveyanceIndex',
                width: 100,
                filter: {
                    type: 'numeric'
                }
            },{
                header: "<span style=font-weight:bold;><%=TotalApprovedAdditionalExpenses%></span>",
                dataIndex: 'totalApprovedAdditionalExpensesIndex',
                width: 100,
                filter: {
                    type: 'numeric'
                }
            },{
                header: "<span style=font-weight:bold;><%=TotalTripExpense%></span>",
                dataIndex: 'totalTripExpenseIndex',
                width: 100,
                filter: {
                    type: 'numeric'
                }
            },{
                header: "<span style=font-weight:bold;><%=DriverAdvance%></span>",
                dataIndex: 'driverAdvanceIndex',
                width: 100,
                filter: {
                    type: 'numeric'
                }
            },{
                header: "<span style=font-weight:bold;><%=BillingTariff%></span>",
                dataIndex: 'billingTariffIndex',
                width: 100,
                filter: {
                    type: 'numeric'
                }
            },{
                header: "<span style=font-weight:bold;><%=UnloadingCharges%></span>",
                dataIndex: 'unloadingChargesIndex',
                width: 100,
                filter: {
                    type: 'numeric'
                }
            },{
                header: "<span style=font-weight:bold;><%=DetentionCharges%></span>",
                dataIndex: 'detentionChargesIndex',
                width: 100,
                filter: {
                    type: 'numeric'
                }
            },{
                header: "<span style=font-weight:bold;><%=ReceiptedCharges%></span>",
                dataIndex: 'receiptedChargesIndex',
                width: 100,
                filter: {
                    type: 'numeric'
                }
            },{
                header: "<span style=font-weight:bold;><%=TotalBill%></span>",
                dataIndex: 'totalBillIndex',
                width: 100,
                filter: {
                    type: 'numeric'
                }
            },{
                header: "<span style=font-weight:bold;><%=ProfitAndLoss%></span>",
                dataIndex: 'profitLossIndex',
                width: 100,
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
	//***************** getGrid ****************************	
	summaryGrid = getGrid('', '<%=NoRecordsFound%>', TripHistoryStore, screen.width - 45, 425, 38, filters, '<%=ClearFilterData%>', false, '', 38, false, '', false, '', true, '<%=Excel%>', jspName, exportDataType, false, 'PDF');
	
 	//*****main starts from here*************************
 	Ext.onReady(function(){
	ctsb=tsb;
	Ext.QuickTips.init();
	Ext.form.Field.prototype.msgTarget = 'side';	         	   			
 	outerPanel = new Ext.Panel({
			title:'Trip History',
			renderTo : 'content',
			standardSubmit: true,
			frame:true,
			cls:'outerpanel',
			border:false,
			items: [innerPanel,summaryGrid]		
			}); 
			BranchNameStore.load();
			vehicleStore.load();
	summaryGrid.reconfigure(TripHistoryStore, createColModel(38))
	}); 
	
 	    </script>
  </div>
 <jsp:include page="../Common/footer.jsp" />
 <!-- </body>   -->
 <!-- </html> -->