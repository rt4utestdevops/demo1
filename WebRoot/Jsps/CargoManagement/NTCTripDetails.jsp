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
	String currency = cf.getCurrency(systemId);	
%>
<jsp:include page="../Common/header.jsp" />  
    <title>XML Trip Details</title>

  <style>
  .x-panel-tl
	{
		border-bottom: 0px solid !important;
	}
	
#content div.x-grid3-col-numberer {
   text-align: center;
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
		.x-window-tl *.x-window-header {
			padding-top : 6px !important;
		}
		.x-layer ul {
		 	min-height: 27px !important;
		}		
		label {
			display : inline !important;
		}
		.x-menu-list {
			height:auto !important;
		}
   </style>
    
    <script>
    var outerPanel;
 	var ctsb;
 	var jspName="NtcTripDetils";
 	var exportDataType="int,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string";
 	var grid;
 	var titel;
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
	 // Customer store is for getting data for customer combo 	
	var customerStore= new Ext.data.JsonStore({
        url: '<%=request.getContextPath()%>/CommonAction.do?param=getCustomer',
        id: 'vehicleStoreId',
		root: 'CustomerRoot',
		autoload: true,
		remoteSort: true,
		fields: ['CustName','CustId'],
		listeners: {
        load: function(custstore, records, success, options) {
            	if (<%= customerId %> > 0) {
                Ext.getCmp('customercomboId').setValue('<%=customerId%>');
<!--                cityStore.load({-->
<!--        params: {-->
<!--        CustomerId: Ext.getCmp('customercomboId').getValue()-->
<!--        		}-->
<!--       	 		});-->
					cityStore.load({
        params: {
        CustomerId: Ext.getCmp('customercomboId').getValue()
        		}
       	 		});
            }
        }
    }
	});
	 // Customer combo is to show box in UI 
	var customercombo = new Ext.form.ComboBox({
        store: customerStore,
        id: 'customercomboId',
        mode: 'local',
        forceSelection: true,
        emptyText: 'Select Customer',
        selectOnFocus: true,
        allowBlank: false,
        anyMatch: true,
        typeAhead: false,
        triggerAction: 'all',
        lazyRender: true,
        valueField: 'CustId',
        displayField: 'CustName',
        cls: 'selectstylePerfect',
        loadingText: 'Searching...',
	    enableKeyEvents: true,
	    minChars: 2,
	    listeners: {
	    select: {
	    fn: function() {
	    Grid.store.clearData();
  		Grid.view.refresh();
	    }
	    }
	    }
	});
	 // innerPanel is used to get customer and generarate button	in UI
	var innerPanel = new Ext.Panel({
        standardSubmit: true,
        collapsible: false,
        id: 'fuelMaster',
        layout: 'table',
        frame: true,
        layoutConfig: {
        columns: 15
        },
        items: [{width:10},
        		{
                xtype: 'label',
                text: 'Customer' + ' :',
                cls: 'labelstyle',
                id: 'cuslab'
				},
            	{width:10},
            	customercombo,
     			{width:50},
			    { 
			    xtype:'button',
			    text:'Generate Report',
			    id: 'buttonid',
			    width:80,
			    hidden:false,
			    listeners: 
	       		{
		        click:
		        {
			    fn:function()
			    {
				if(Ext.getCmp('customercomboId').getValue() == "" )
							   {
					                 Ext.example.msg("SelectCustomer");
					                 Ext.getCmp('customercomboId').focus();
			                      	 return;
							    }
						//***** For Panel 
				       			NCTCTripDetailsReport.load({
				                        params: {
				                            cusId: Ext.getCmp('customercomboId').getValue(),
				                            cusName: Ext.getCmp('customercomboId').getRawValue(),
                            				jspName:jspName
                       				}
				                });
			       			}
	       				}
       				}
			    	
			    }	
        	]
   		 });
		 // Json reader 
    var reader = new Ext.data.JsonReader({
        idProperty: 'logRoot',
        root: 'ntctripreportroot',
        totalProperty: 'total',
        fields: [{
        	name: 'slnoIndex'
        },{
            name: 'custIndex',
        }, {
            name: 'vehNoIndex'
        }, {
            name: 'tripNoIndex'
        }, {
            name: 'tripInsertIndex'
        },{
            name: 'todLocIndex'
        },{
            name: 'speedIndex'
        }, {
            name: 'dateTimeIndex'
        },{
            name: 'statusOfVehIndex'
        },{
            name: 'fromIndex'
        },{
            name: 'toIndex'
        },{
            name: 'yesterLocIndex'
        },{
            name: 'tripStartIndex'
        },{
            name: 'tripRouteIndex'
        },{
            name: 'tripSalesIndex'
        },{
            name: 'tripstatusIndex'
        },{
            name: 'tripTypeIndex'
        },{
            name: 'tripRemarksIndex'
        },{
            name: 'lrNoIndex'
        },{
            name: 'materialIndex'
        },{
            name: 'dimensionIndex'
        },{
            name: 'transitDaysIndex'
        },{
            name: 'driCodeNoIndex'
        },{
            name: 'driAnaCodeIndex'
        },{
            name: 'driNameIndex'
        },{
            name: 'dlNoIndex'
        },{
            name: 'driMobNoIndex'
        },{
            name: 'crewTypeIndex'
        },{
            name: 'OperatorIndex'
        },{
            name: 'vehModeIndex'
        },{
            name: 'vehMakeIndex'
        },{
            name: 'vehModelIndex'
        },{
            name: 'vehInchargeIndex'
        },{
            name: 'vehTypeIndex'
        },{
            name: 'co-Dri1Index'
        },{
            name: 'co-Dri1AnaIndex'
        },{
            name: 'co-Dri1NameIndex'
        }, {
            name: 'co-CreTypIndex'
        }, {
            name: 'co-DriMobNoIndex'
        }, {
            name: 'co-DriDlNoIndex'
        },{
            name: 'creConNameIndex'
        },{
            name: 'trailerNoIndex'
        },{
            name: 'trailerModIndex'
        },{
            name: 'trailerMakIndex'
        },{
            name: 'trailerModelIndex'
        },{
            name: 'trailerInchrgIndex'
        },{
            name: 'trialerTypeIndex'
        },{
            name: 'lpInIndex'
        },{
            name: 'lpOutIndex'
        },{
            name: 'ulInIndex'
        },{
            name: 'ulOutIndex'
        },{
            name: 'atmCardIndex'
        },{
            name: 'dieselIndex'
        },{
            name: 'tripMillIndex'
        },{
            name: 'haltingReasonIndex'
        },{
            name: 'driGradeIndex'
        },{
            name: 'operatorCodeIndex'
        }
        ]
    });
		// Store for getting data in grid
    var NCTCTripDetailsReport = new Ext.data.GroupingStore({
        autoLoad: false,
        proxy: new Ext.data.HttpProxy({
        url: '<%=request.getContextPath()%>/CargoManagementAction.do?param=getNTCTripReportGrid',
        method: 'POST'    	
        }),
 	    storeId: 'logRoot',
        reader: reader
    });
    //filters 
	var filters = new Ext.ux.grid.GridFilters({
        local: true,
        filters: [{
            type: 'numeric',
            dataIndex: 'slnoIndex'
        },{
            type: 'string',
            dataIndex: 'custIndex'
        }, {
            type: 'string',
            dataIndex: 'vehNoIndex'
        }, {
            type: 'string',
            dataIndex: 'tripNoIndex'
        },{
            type: 'string',
            dataIndex: 'tripInsertIndex'
        }, {
            type: 'string',
            dataIndex: 'todLocIndex'
        },{
            type: 'int',
            dataIndex: 'speedIndex'
        }, {
            type: 'string',
            dataIndex: 'dateTimeIndex'
        }, {
            type: 'string',
            dataIndex: 'statusOfVehIndex'
        }, {
            type: 'string',
            dataIndex: 'fromIndex'
        }, {
            type: 'string',
            dataIndex: 'toIndex'
        },{
            type: 'string',
            dataIndex: 'yesterLocIndex'
        },{
            type: 'string',
            dataIndex: 'tripStartIndex'
        }, {
            type: 'string',
            dataIndex: 'tripRouteIndex'
        }, {
            type: 'string',
            dataIndex: 'tripSalesIndex'
        }, {
            type: 'string',
            dataIndex: 'tripstatusIndex'
        }, {
            type: 'string',
            dataIndex: 'tripTypeIndex'
        }, {
            type: 'string',
            dataIndex: 'tripRemarksIndex'
        }, {
            type: 'string',
            dataIndex: 'lrNoIndex'
        }, {
            type: 'string',
            dataIndex: 'materialIndex'
        }, {
            type: 'string',
            dataIndex: 'dimensionIndex'
        }, {
            type: 'string',
            dataIndex: 'transitDaysIndex'
        }, {
            type: 'string',
            dataIndex: 'driCodeNoIndex'
        }, {
            type: 'string',
            dataIndex: 'driAnaCodeIndex'
        }, {
            type: 'string',
            dataIndex: 'driNameIndex'
        }, {
            type: 'string',
            dataIndex: 'dlNoIndex'
        }, {
            type: 'string',
            dataIndex: 'driMobNoIndex'
        }, {
            type: 'string',
            dataIndex: 'crewTypeIndex'
        }, {
            type: 'string',
            dataIndex: 'OperatorIndex'
        },{
            type: 'string',
            dataIndex: 'vehModeIndex'
        },{
            type: 'string',
            dataIndex: 'vehMakeIndex'
        },{
            type: 'string',
            dataIndex: 'vehModelIndex'
        }, {
            type: 'string',
            dataIndex: 'vehInchargeIndex'
        }, {
            type: 'string',
            dataIndex: 'vehTypeIndex'
        }, {
            type: 'string',
            dataIndex: 'co-Dri1Index'
        }, {
            type: 'string',
            dataIndex: 'co-Dri1AnaIndex'
        },{
            type: 'string',
            dataIndex: 'co-Dri1NameIndex'
        }, {
            type: 'string',
            dataIndex: 'co-CreTypIndex'
        }, {
            type: 'string',
            dataIndex: 'co-DriMobNoIndex'
        }, {
            type: 'string',
            dataIndex: 'co-DriDlNoIndex'
        }, {
            type: 'string',
            dataIndex: 'creConNameIndex'
        }, {
            type: 'string',
            dataIndex: 'trailerNoIndex'
        }, {
            type: 'string',
            dataIndex: 'trailerModIndex'
        }, {
            type: 'string',
            dataIndex: 'trailerMakIndex'
        },{
            type: 'string',
            dataIndex: 'trailerModelIndex'
        }, {
            type: 'string',
            dataIndex: 'trailerInchrgIndex'
        }, {
            type: 'string',
            dataIndex: 'trialerTypeIndex'
        },  {
            type: 'string',
            dataIndex: 'lpInIndex'
        }, {
            type: 'string',
            dataIndex: 'lpOutIndex'
        }, {
            type: 'string',
            dataIndex: 'ulInIndex'
        }, {
            type: 'string',
            dataIndex: 'ulOutIndex'
        }, {
            type: 'string',
            dataIndex: 'atmCardIndex'
        }, {
            type: 'string',
            dataIndex: 'dieselIndex'
        }, {
            type: 'string',
            dataIndex: 'tripMillIndex'
        }, {
            type: 'string',
            dataIndex: 'haltingReasonIndex'
        }, {
            type: 'string',
            dataIndex: 'driGradeIndex'
        }, {
            type: 'string',
            dataIndex: 'operatorCodeIndex'
        }
        ]
      });
		
		//Column Model Config for grid
    var createColModel = function (finish, start) {
        var columns = [
        new Ext.grid.RowNumberer({
        width: 60,
        header: "<span style=font-weight:bold;>Sl No</span>",
        align: 'center'
        }),
        {
        dataIndex: 'slnoIndex',
        hidden: true,
        header: "<span style=font-weight:bold;>Sl No</span>",
        filter: {
        type: 'numeric'
        }
        },
        {
        header: "<span style=font-weight:bold;>Customer Name</span>",
        dataIndex: 'custIndex',
        width: 15,
        filter: {
        type: 'string'
        }
        }, 
        {
        header: "<span style=font-weight:bold;>Vehicle Number</span>",
        dataIndex: 'vehNoIndex',
       	width: 20,
        filter: {
        type: 'string'
        }
        }, 
        {
        header: "<span style=font-weight:bold;>Trip No</span>",
        dataIndex: 'tripNoIndex',
        //width:20,
        filter: {
        type: 'string'
        }
        },
        {
        header: "<span style=font-weight:bold;>Trip Inserted Date</span>",
        dataIndex: 'tripInsertIndex',
        //width:20,
        filter: {
        type: 'string'
        }
        }, 
        {
        header: "<span style=font-weight:bold;>Today Location</span>",
        dataIndex: 'todLocIndex',
        //width: 20,
        filter: {
        type: 'string'
        }
        },
        {
        header: "<span style=font-weight:bold;>Speed</span>",
        dataIndex: 'speedIndex',
        //width: 20,
        filter: {
        type: 'int'
        }
        },
        {
        header: "<span style=font-weight:bold;>Date Time</span>",
        dataIndex: 'dateTimeIndex',
       // width: 15,
        filter: {
        type: 'string'
        }
        },
        {
        header: "<span style=font-weight:bold;>Status Of Vehicle</span>",
        dataIndex: 'statusOfVehIndex',
        width: 15,
        filter: {
        type: 'string'
        }
        },
        {
        header: "<span style=font-weight:bold;>From</span>",
        dataIndex: 'fromIndex',
       // width: 15,
        filter: {
        type: 'string'
        }
        },
        {
        header: "<span style=font-weight:bold;>To</span>",
        dataIndex: 'toIndex',
        //width: 15,
        filter: {
        type: 'string'
        }
        },
        {
        header: "<span style=font-weight:bold;>Yesterday Location</span>",
        dataIndex: 'yesterLocIndex',
      //  width: 20,
        filter: {
        type: 'string'
        }
        },
        {
        header: "<span style=font-weight:bold;>Trip Start Date</span>",
        dataIndex: 'tripStartIndex',
        //width: 20,
        filter: {
        type: 'string'
        }
        },
        {
        header: "<span style=font-weight:bold;>Trip Route Code</span>",
        dataIndex: 'tripRouteIndex',
       /// width: 20,
        filter: {
        type: 'string'
        }
        },
        {
        header: "<span style=font-weight:bold;>Trip Sales Channel</span>",
        dataIndex: 'tripSalesIndex',
       // width: 15,
        filter: {
        type: 'string'
        }
        },
        {
        header: "<span style=font-weight:bold;>Trip Type</span>",
        dataIndex: 'tripTypeIndex',
        //width: 15,
        filter: {
        type: 'string'
        }
        },
        {
        header: "<span style=font-weight:bold;>Trip Remarks</span>",
        dataIndex: 'tripRemarksIndex',
       // width: 30,
        filter: {
        type: 'string'
        }
        },
        {
        header: "<span style=font-weight:bold;>LR Number</span>",
        dataIndex: 'lrNoIndex',
       // width: 30,
        filter: {
        type: 'string'
        }
        },
        {
        header: "<span style=font-weight:bold;>Material</span>",
        dataIndex: 'materialIndex',
       // width: 30,
        filter: {
        type: 'string'
        }
        },
        {
        header: "<span style=font-weight:bold;>Dimensions</span>",
        dataIndex: 'dimensionIndex',
       // width: 30,
        filter: {
        type: 'string'
        }
        },
        {
        header: "<span style=font-weight:bold;>Transit Days</span>",
        dataIndex: 'transitDaysIndex',
       // width: 20,
        filter: {
        type: 'string'
        }
        },
        {
        header: "<span style=font-weight:bold;>Driver Code No</span>",
        dataIndex: 'driCodeNoIndex',
       // width: 30,
        filter: {
        type: 'string'
        }
        },
        {
        header: "<span style=font-weight:bold;>Driver Analysis Code</span>",
        dataIndex: 'driAnaCodeIndex',
       // width: 20,
        filter: {
        type: 'numeric'
        }
        },
        {
        header: "<span style=font-weight:bold;>Driver Name</span>",
        dataIndex: 'driNameIndex',
       // width: 20,
        filter: {
        type: 'string'
        }
        },
        {
        header: "<span style=font-weight:bold;>DL No</span>",
        dataIndex: 'dlNoIndex',
      //  width: 15,
        filter: {
        type: 'string'
        }
        },
        {
        header: "<span style=font-weight:bold;>Driver Mobile No</span>",
        dataIndex: 'driMobNoIndex',
      //  width: 15,
        filter: {
        type: 'string'
        }
        },
        {
        header: "<span style=font-weight:bold;>Crew Type</span>",
        dataIndex: 'crewTypeIndex',
        width: 15,
        filter: {
        type: 'string'
        }
        },
        {
        header: "<span style=font-weight:bold;>Operator Name</span>",
        dataIndex: 'OperatorIndex',
        width: 15,
        filter: {
        type: 'string'
        }
        },
        {
        header: "<span style=font-weight:bold;>Vehicle Mode</span>",
        dataIndex: 'vehModeIndex',
        width: 15,
        filter: {
        type: 'string'
        }
        },
        {
        header: "<span style=font-weight:bold;>Vehicle Make</span>",
        dataIndex: 'vehMakeIndex',
       // width: 20,
        filter: {
        type: 'string'
        }
        },
        {
        header: "<span style=font-weight:bold;>Vehicle Model</span>",
        dataIndex: 'vehModelIndex',
      //  width: 20,
        filter: {
        type: 'string'
        }
        },
        {
        header: "<span style=font-weight:bold;>Vehicle Incharge</span>",
        dataIndex: 'vehInchargeIndex',
       // width: 15,
        filter: {
        type: 'string'
        }
        },
        {
        header: "<span style=font-weight:bold;>Vehicle Type</span>",
        dataIndex: 'vehTypeIndex',
      //  width: 20,
        filter: {
        type: 'string'
        }
        },
        {
        header: "<span style=font-weight:bold;>Co-Driver Code</span>",
        dataIndex: 'co-Dri1Index',
      //  width: 20,
        filter: {
        type: 'string'
        }
        },
        {
        header: "<span style=font-weight:bold;>Co-Driver Analysis Code</span>",
        dataIndex: 'co-Dri1AnaIndex',
      //  width: 20,
        filter: {
        type: 'string'
        }
        },
        {
        header: "<span style=font-weight:bold;>Co-Driver Name</span>",
        dataIndex: 'co-Dri1NameIndex',
      //  width: 20,
        filter: {
        type: 'string'
        }
        },
        {
        header: "<span style=font-weight:bold;>Co-Crew Type</span>",
        dataIndex: 'co-CreTypIndex',
      //  width: 20,
        filter: {
        type: 'string'
        }
        },
        {
        header: "<span style=font-weight:bold;>Co-Driver Mobile No</span>",
        dataIndex: 'co-DriMobNoIndex',
      //  width: 20,
        filter: {
        type: 'string'
        }
        },
        {
        header: "<span style=font-weight:bold;>Co-Driver DL No</span>",
        dataIndex: 'co-DriDlNoIndex',
      //  width: 20,
        filter: {
        type: 'string'
        }
        },
        {
        header: "<span style=font-weight:bold;>Crew Consultancy Name</span>",
        dataIndex: 'creConNameIndex',
      //  width: 20,
        filter: {
        type: 'string'
        }
        },
        {
        header: "<span style=font-weight:bold;>Trailer No</span>",
        dataIndex: 'trailerNoIndex',
      //  width: 20,
        filter: {
        type: 'string'
        }
        },
        {
        header: "<span style=font-weight:bold;>Trailer Mode</span>",
        dataIndex: 'trailerModIndex',
      //  width: 20,
        filter: {
        type: 'string'
        }
        },
        {
        header: "<span style=font-weight:bold;>Trailer Make</span>",
        dataIndex: 'trailerMakIndex',
      //  width: 20,
        filter: {
        type: 'string'
        }
        },
        {
        header: "<span style=font-weight:bold;>Trailer Model</span>",
        dataIndex: 'trailerModelIndex',
      //  width: 20,
        filter: {
        type: 'string'
        }
        },
        {
        header: "<span style=font-weight:bold;>Trailer Incharge</span>",
        dataIndex: 'trailerInchrgIndex',
      //  width: 20,
        filter: {
        type: 'string'
        }
        },
        {
        header: "<span style=font-weight:bold;>Trailer Type</span>",
        dataIndex: 'trialerTypeIndex',
      //  width: 20,
        filter: {
        type: 'string'
        }
        },
        {
        header: "<span style=font-weight:bold;>LP In  Date</span>",
        dataIndex: 'lpInIndex',
      //  width: 20,
        filter: {
        type: 'string'
        }
        },
        {
        header: "<span style=font-weight:bold;>LP Out Date</span>",
        dataIndex: 'lpOutIndex',
      //  width: 20,
        filter: {
        type: 'string'
        }
        },
        {
        header: "<span style=font-weight:bold;>UL In Date</span>",
        dataIndex: 'ulInIndex',
      //  width: 20,
        filter: {
        type: 'string'
        }
        },
        {
        header: "<span style=font-weight:bold;>UL Out Date</span>",
        dataIndex: 'ulOutIndex',
      //  width: 20,
        filter: {
        type: 'string'
        }
        },
        {
        header: "<span style=font-weight:bold;>ATM Card  No</span>",
        dataIndex: 'atmCardIndex',
      //  width: 20,
        filter: {
        type: 'string'
        }
        },
        {
        header: "<span style=font-weight:bold;>Diesel Card No</span>",
        dataIndex: 'dieselIndex',
      //  width: 20,
        filter: {
        type: 'string'
        }
        },
        {
        header: "<span style=font-weight:bold;>Trip Milleage</span>",
        dataIndex: 'tripMillIndex',
      //  width: 20,
        filter: {
        type: 'string'
        }
        },
        {
        header: "<span style=font-weight:bold;>Reason For Halting</span>",
        dataIndex: 'haltingReasonIndex',
      //  width: 20,
        filter: {
        type: 'string'
        }
        },
        {
        header: "<span style=font-weight:bold;>Driver Grade</span>",
        dataIndex: 'driGradeIndex',
      //  width: 20,
        filter: {
        type: 'string'
        }
        },
        {
        header: "<span style=font-weight:bold;>Operator Code</span>",
        dataIndex: 'operatorCodeIndex',
      //  width: 20,
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
	// getGrid 	
	Grid = getGrid('', 'NoRecordsFound',NCTCTripDetailsReport, screen.width - 40, 350, 57, filters, 'ClearFilterData', false, '', 33, false, '', false, '', true, 'Excel', jspName, exportDataType, false, 'PDF');
	// main 
 	Ext.onReady(function(){
	ctsb=tsb;
	Ext.QuickTips.init();
	Ext.Ajax.timeout = 180000;
	Ext.form.Field.prototype.msgTarget = 'side';			         	   			
 	outerPanel = new Ext.Panel({
			title:'XML Trip Details',
			renderTo : 'content',
			standardSubmit: true,
			frame:true,
			cls:'outerpanel',
			border:false,
			items: [innerPanel,Grid]  
			//bbar:ctsb			
			}); 
			var cm = Grid.getColumnModel();
        for (var j = 1; j < cm.getColumnCount(); j++) {
            cm.setColumnWidth(j, 170);
        }
customerStore.load(); 
NCTCTripDetailsReport.load({
 params: {
			 cusId: Ext.getCmp('customercomboId').getValue(),
			 cusName: Ext.getCmp('customercomboId').getRawValue(),
             jspName:jspName
          }
				                }); 
   
	}); 
    </script>
  </div>
 <jsp:include page="../Common/footer.jsp" />
 <!-- </body>   -->
 <!-- </html> -->

