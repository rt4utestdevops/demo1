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

tobeConverted.add("Vehicle_Ledger_Report");
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
tobeConverted.add("No_Records_Found");
tobeConverted.add("Clear_Filter_Data");
tobeConverted.add("Excel");
tobeConverted.add("SLNO");
tobeConverted.add("Trip_Start_Date");
tobeConverted.add("Trip_No");
tobeConverted.add("Principal_Name");
tobeConverted.add("Consignee_Name");
tobeConverted.add("R_Fee");
tobeConverted.add("B_Fee");
tobeConverted.add("Toll");
tobeConverted.add("Driver_Incentive");
tobeConverted.add("Police");
tobeConverted.add("Escort");
tobeConverted.add("Loading");
tobeConverted.add("Unloading_Charges");
tobeConverted.add("Octroi");
tobeConverted.add("Labour_Charges");
tobeConverted.add("Other_Expenses");
tobeConverted.add("Total_Trip_Expense");
tobeConverted.add("Advance_Cash");
tobeConverted.add("Total_Approved_Additional_Expenses");
tobeConverted.add("Morning_Incentive");
tobeConverted.add("Conveyance");
ArrayList<String> convertedWords=new ArrayList<String>();
convertedWords=cf.getLanguageSpecificWordForKey(tobeConverted,language);

String VehicleLedgerReport=convertedWords.get(0);
String VehicleNo=convertedWords.get(1);
String SelectVehicle=convertedWords.get(2);
String SelectVehicalNo=convertedWords.get(3);
String StartDate=convertedWords.get(4);
String EndDate=convertedWords.get(5);
String SelectStartDate=convertedWords.get(6);
String SelectEndDate=convertedWords.get(7);
String View=convertedWords.get(8);
String startDateEndDateValication=convertedWords.get(9);
String monthValidation=convertedWords.get(10);
String NoRecordsFound=convertedWords.get(11);
String ClearFilterData=convertedWords.get(12);
String Excel=convertedWords.get(13);
String slno=convertedWords.get(14);
String TripStartDate=convertedWords.get(15);
String TripNo=convertedWords.get(16);
String PrincipalName=convertedWords.get(17);
String ConsigneeName=convertedWords.get(18);
String RFee=convertedWords.get(19);
String BFee=convertedWords.get(20);
String Toll=convertedWords.get(21);
String DriverIncentive=convertedWords.get(22);
String Police=convertedWords.get(23);
String Escort=convertedWords.get(24);
String Loading=convertedWords.get(25);
String UnloadingCharges=convertedWords.get(26);
String Octroi=convertedWords.get(27);
String LabourCharges=convertedWords.get(28);
String OtherExpenses=convertedWords.get(29);
String TotalTripExpense=convertedWords.get(30);
String AdvanceCash=convertedWords.get(31);
String TotalApprovedAdditionalExpenses=convertedWords.get(32);
String MorningIncentive=convertedWords.get(33);
String Conveyance=convertedWords.get(34);
		
%>
<jsp:include page="../Common/header.jsp" /> 
    <title><%=VehicleLedgerReport%></title>
 
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
	label {
			display : inline !important;
		}
		.x-window-tl *.x-window-header {
			padding-top : 6px !important;
		}
		.ext-strict .x-form-text {
			height: 21px !important;
		}
		.x-layer ul {
		 	min-height: 27px !important;
		}

   </style>
    
    <script>
    var outerPanel;
 	var ctsb;
 	var dtprev;
 	var dtcur;
 	var jspName="VehicleLedgerReport";
 	var exportDataType="int,date,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string";
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
	//***** vehicle combo *******		
	var vehicleStore= new Ext.data.JsonStore({
           url: '<%=request.getContextPath()%>/VehicleLedgerAction.do?param=getVehicles',
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
  	items: [{width: 40},
  		    {
  		     xtype: 'label',
  		     text: '<%=VehicleNo%>' + ' :',
  		     cls: 'labelstyle',
  		     id: 'vehiclelab'
  		   },
  		     vehiclecombo, {
  		     width: 100
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
  		     width: 100
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
  		     width: 100
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
  		                VehicleLedgerStore.load({
  		                    params: {
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
        root: 'VehicleLedgerRoot',
        totalProperty: 'total',
        fields: [{
        	name: 'slnoIndex'
        }, {
            name: 'tripStartDateIndex',
            type: 'date',
  		    dateFormat: getDateTimeFormat()
        },{
            name: 'tripNoIndex'
        }, {
            name: 'principalNameIndex'
        }, {
            name: 'consigneeNameIndex'
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
            name: 'unloadingChargesIndex'
        }, {
            name: 'octroiIndex'
        }, {
            name: 'labourChargesIndex'
        },  {
            name: 'otherExpensesIndex'
        }, {
            name: 'totalTripExpenseIndex'
        }, {
            name: 'driverAdvanceIndex'
        }, {
            name: 'totalApprovedAdditionalExpensesIndex'
        }, {
            name: 'morningIncentiveIndex'
        }, {
            name: 'conveyanceIndex'
        }]
    });
		//********** store *****************
		var VehicleLedgerStore = new Ext.data.GroupingStore({
        autoLoad: false,
        proxy: new Ext.data.HttpProxy({
           	url: '<%=request.getContextPath()%>/VehicleLedgerAction.do?param=getVehicleLedgerData',
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
            type: 'date',
            dataIndex: 'tripStartDateIndex'
        },{
            type: 'string',
            dataIndex: 'tripNoIndex'
        }, {
            type: 'string',
            dataIndex: 'principalNameIndex'
        },{
            type: 'string',
            dataIndex: 'consigneeNameIndex'
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
            dataIndex: 'unloadingChargesIndex'
        },{
            type: 'numeric',
            dataIndex: 'octroiIndex'
        },{
            type: 'numeric',
            dataIndex: 'labourChargesIndex'
        },{
            type: 'numeric',
            dataIndex: 'otherExpensesIndex'
        },{
            type: 'numeric',
            dataIndex: 'totalTripExpenseIndex'
        },{
            type: 'numeric',
            dataIndex: 'driverAdvanceIndex'
        },{
            type: 'numeric',
            dataIndex: 'totalApprovedAdditionalExpensesIndex'
        },{
            type: 'numeric',
            dataIndex: 'morningIncentiveIndex'
        },{
            type: 'numeric',
            dataIndex: 'conveyanceIndex'
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
                header: "<span style=font-weight:bold;><%=TripStartDate%></span>",
                dataIndex: 'tripStartDateIndex',
				renderer: Ext.util.Format.dateRenderer(getDateTimeFormat()),
				width: 120,
                filter: {
                    type: 'date'
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
                header: "<span style=font-weight:bold;><%=UnloadingCharges%></span>",
                dataIndex: 'unloadingChargesIndex',
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
                header: "<span style=font-weight:bold;><%=LabourCharges%></span>",
                dataIndex: 'labourChargesIndex',
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
                header: "<span style=font-weight:bold;><%=TotalTripExpense%></span>",
                dataIndex: 'totalTripExpenseIndex',
                width: 100,
                filter: {
                    type: 'numeric'
                }
            },{
                header: "<span style=font-weight:bold;><%=AdvanceCash%></span>",
                dataIndex: 'driverAdvanceIndex',
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
	summaryGrid = getGrid('', '<%=NoRecordsFound%>', VehicleLedgerStore, screen.width - 45, 425, 22, filters, '<%=ClearFilterData%>', false, '', 22, false, '', false, '', true, '<%=Excel%>', jspName, exportDataType, false, 'PDF');
	
 	//*****main starts from here*************************
 	Ext.onReady(function(){
	ctsb=tsb;
	Ext.QuickTips.init();
	Ext.form.Field.prototype.msgTarget = 'side';	         	   			
 	outerPanel = new Ext.Panel({
			title:'Vehicle Ledger Report',
			renderTo : 'content',
			standardSubmit: true,
			frame:true,
			cls:'outerpanel',
			border:false,
			items: [innerPanel,summaryGrid]		
			}); 
			vehicleStore.load();
	summaryGrid.reconfigure(VehicleLedgerStore, createColModel(22))
	}); 
	
 	    </script>
  </div>
 <jsp:include page="../Common/footer.jsp" />
 <!-- </body>   -->
 <!-- </html> -->