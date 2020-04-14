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
    <title>Operation Summary Report</title>
 
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
 	var jspName="OperationSummaryReportLog";
 	var exportDataType="int,string,string,string,string,string";
 	var grid;
 	var titel;
 	var dtprev = dateprev;
	var dtcur = datecur;
	var dtnxt = datenext;
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
	    cityStore.load({
        params: {
        CustomerId: Ext.getCmp('customercomboId').getValue()
        }
        });
		Ext.getCmp('citycomboId').reset();
	    Grid.store.clearData();
  		Grid.view.refresh();
	    }
	    }
	    }
	});
	 // City store is used to get a data for city combo 
	var cityStore= new Ext.data.JsonStore({
        url: '<%=request.getContextPath()%>/PowerConnectionReportAction.do?param=getCity',
        id: 'cityStoreId',
		root: 'CityRoot',
		autoload: false,
		remoteSort: true,
		fields: ['CityName','CityId']
	});	
	 // City Combo is to show box in UI 
	var citycombo = new Ext.form.ComboBox({
        store: cityStore,
        id: 'citycomboId',
        mode: 'local',
        forceSelection: true,
        emptyText: 'Select City',
        selectOnFocus: true,
        allowBlank: false,
        anyMatch: true,
        typeAhead: false,
        triggerAction: 'all',
        lazyRender: true,
        valueField: 'CityId',
        displayField: 'CityName',
        cls: 'selectstylePerfect',
        loadingText: 'Searching...',
	    enableKeyEvents: true,
	    minChars: 2,
	    listeners: {
	    select: {
	    fn: function() {
	    cityid = Ext.getCmp('citycomboId').getValue();
	    Grid.store.clearData();
  		Grid.view.refresh();
	    }
	    }
	    }
	});	
	 // innerPanel is used to get customer,city,date and generarate button	in UI
	var innerPanel = new Ext.Panel({
        standardSubmit: true,
        collapsible: false,
        id: 'fuelMaster',
        layout: 'table',
        frame: true,
        layoutConfig: {
        columns: 15
        },
        items: [{width:30},
        		{
                xtype: 'label',
                text: 'Customer' + ' :',
                cls: 'labelstyle',
                id: 'cuslab'
				},
            	{width:10},
            	customercombo,
     			{width:85},
     			{
                xtype: 'label',
                text: 'City' + ' :',
                cls: 'labelstyle',
                id: 'vehlab'
               	},
            	{width:10},
            	citycombo,
     			{width:85},
			    {
			    xtype: 'label',
			    text : 'Date' + ':',
			    cls: 'labelstyle',
			    id: 'dateId1',
			    width:60
			    },
			    {width:10},
			    {
  		        xtype: 'datefield',
  		        cls: 'selectstylePerfect',
  		        width: 185,
  		        format: getDateFormat(),
  		        emptyText: 'Select Date',
  		        allowBlank: false,
  		        blankText: 'Select Date',
  		        id: 'startdate',
  		        maxValue: dtprev,
  		        value: dtprev,
  		        vtype: 'daterange'   	
  		        },
  		        {width:85},
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
							    if(Ext.getCmp('citycomboId').getValue() == "" )
							    {
						             Ext.example.msg("SelectCity");
						             Ext.getCmp('citycomboId').focus();
				                     return;
							    }
						//***** For Panel 
				       			OperationSummaryReoprtStore.load({
				                        params: {
				                            cusId: Ext.getCmp('customercomboId').getValue(),
				                            cityId: Ext.getCmp('citycomboId').getValue(),
				                            cusName: Ext.getCmp('customercomboId').getRawValue(),
 											cityName: Ext.getCmp('citycomboId').getRawValue(),
                            				startdate: Ext.getCmp('startdate').getValue(),
                						    enddate: Ext.getCmp('startdate').getValue(),			
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
        root: 'OperationSummaryReportRoot',
        totalProperty: 'total',
        fields: [{
        	name: 'slnoIndex'
        },{
            name: 'cityIndex',
        }, {
            name: 'GPSIndex'
        }, {
            name: 'vehiclesIndex'
        }, {
            name: 'borderIndex'
        }, {
            name: 'GPSTmpIndex'
        }]
    });
		// Store for getting data in grid
    var OperationSummaryReoprtStore = new Ext.data.GroupingStore({
        autoLoad: false,
        proxy: new Ext.data.HttpProxy({
        url: '<%=request.getContextPath()%>/PowerConnectionReportAction.do?param=getOperationSummaryReportGrid',
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
            dataIndex: 'cityIndex'
        }, {
            type: 'string',
            dataIndex: 'GPSIndex'
        }, {
            type: 'string',
            dataIndex: 'vehiclesIndex'
        }, {
            type: 'string',
            dataIndex: 'borderIndex'
        }, {
            type: 'string',
            dataIndex: 'GPSTmpIndex'
        }]
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
        header: "<span style=font-weight:bold;>City</span>",
        dataIndex: 'cityIndex',
        width: 60,
        filter: {
        type: 'string'
        }
        }, 
        {
        header: "<span style=font-weight:bold;>GPS Wiring Tampered </span>",
        dataIndex: 'GPSIndex',
        width: 70,
        filter: {
        type: 'string'
        }
        }, 
        {
        header: "<span style=font-weight:bold;>Vehicles Not Communicating For The Whole Day</span>",
        dataIndex: 'vehiclesIndex',
        width:130,
        filter: {
        type: 'string'
        }
        }, 
        {
        header: "<span style=font-weight:bold;>	Border Crossed And Not Returned By Midnight </span>",
        dataIndex: 'borderIndex',
        width: 120,
        filter: {
        type: 'string'
        }
        },
        {
        header: "<span style=font-weight:bold;>GPS Tampered Crossed Border</span>",
        dataIndex: 'GPSTmpIndex',
        width: 90,
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
	Grid = getGrid('', 'NoRecordsFound',OperationSummaryReoprtStore, screen.width - 35, 425, 7, filters, 'ClearFilterData', false, '', 7, false, '', false, '', true, 'Excel', jspName, exportDataType, true, 'PDF');
	// main 
 	Ext.onReady(function(){
	ctsb=tsb;
	Ext.QuickTips.init();
	Ext.form.Field.prototype.msgTarget = 'side';			         	   			
 	outerPanel = new Ext.Panel({
			title:'Operation Summary Report',
			renderTo : 'content',
			standardSubmit: true,
			frame:true,
			cls:'outerpanel',
			border:false,
			items: [innerPanel,Grid]  
			//bbar:ctsb			
			}); 
			customerStore.load();
			Ext.Ajax.timeout = 180000;  
	}); 
    </script>
  </div>
<jsp:include page="../Common/footer.jsp" />
 <!-- </body>   -->
 <!-- </html> -->
