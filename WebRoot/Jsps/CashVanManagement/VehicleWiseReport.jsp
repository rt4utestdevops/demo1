<%@ page language="java" import="java.util.*,t4u.functions.*,t4u.beans.*,t4u.common.*" pageEncoding="ISO-8859-1"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";

	CommonFunctions cf = new CommonFunctions();
	cf.checkLoginInfo((LoginInfoBean) session.getAttribute("loginInfoDetails"), session, request, response);

	LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
	String language = loginInfo.getLanguage();
	int systemId = loginInfo.getSystemId();
	int customerId = loginInfo.getCustomerId();

%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <base href="<%=basePath%>">
    
    <title>My JSP 'VehicleWiseReport.jsp' starting page</title>
    
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	<!--
	<link rel="stylesheet" type="text/css" href="styles.css">
	-->

  </head>
 
  <body>
  <%if (loginInfo.getStyleSheetOverride().equals("Y")){%>                  
    <jsp:include page="../Common/ImportJSSandMining.jsp"/>                                               
   <%}else {%>  
   <jsp:include page="../Common/ImportJS.jsp" /><%} %>
   		
   		<!-- for exporting to excel***** -->
        <jsp:include page="../Common/ExportJS.jsp" />
   	<script>
   	var jspName = "VehicleWiseReport";
  	var exportDataType = "int,string,string,string,string,string,string,string,date,string,string,string,string,string";
    var outerPanel;
    var ctsb;
    var summaryGrid;
    var custId;
    var custName;
    var dtprev = dateprev;
    var dtcur = datecur;
    
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
                     VehicleComboStore.load({params:{custId:custId}});
                }
            }
        }
    });

    var custnamecombo = new Ext.form.ComboBox({
        store: customercombostore,
        id: 'custcomboId',
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
        listeners: {
            select: {
                fn: function () {
                    custId = Ext.getCmp('custcomboId').getValue();
                    custName = Ext.getCmp('custcomboId').getRawValue();                    
                     VehicleComboStore.load({params:{custId:custId}});
                }
            }
        }
    });
    
	 
  var VehicleComboStore = new Ext.data.JsonStore({
        url: '<%=request.getContextPath()%>/CashVanReportAction.do?param=getAllVehicleDetails',
        id: 'VehicleComboStoreId',
        root: 'VehicleStoreRoot',
        autoLoad: false,
        remoteSort: true,
        fields: ['VehicleNo']
    });
   
   var VehicleCombo = new Ext.form.ComboBox({
    store: VehicleComboStore,
    id: 'VehicleComboId',
    mode: 'local',
    hidden: false,
    forceSelection: true,
    emptyText: 'Select Vehicle',
    blankText: 'Select Vehicle',
    lazyRender: true,
    selectOnFocus: true,
    allowBlank: true,
    autoload: true,
    anyMatch: true,
    typeAhead: false,
    triggerAction: 'all',
    valueField: 'VehicleNo',
    displayField: 'VehicleNo',
    cls: 'selectstylePerfect',
    listeners: {
        select: {
            fn: function() {
            
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
            columns: 16
        },
        items: [{
                xtype: 'label',
                text: 'Customer Name ' + ' :',
                cls: 'labelstyle',
                id: 'custnamelab'
       },
            custnamecombo,
            {width:'30px'},
			{
                xtype: 'label',
                text: 'Vehicle No' + ' :',
                cls: 'labelstyle',
                id: 'vehicleNolab'
            },
            VehicleCombo,
            {width:'30px'},   
        
        {
            xtype: 'label',
            text: 'Start Date' + ' :',
            cls: 'labelstyle',
            id: 'StartDtLabelId'
        }, {
            xtype: 'datefield',
            cls: 'selectstylePerfect',
             format: 'd/m/Y',
            //format: getDateTimeFormat(),
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
            //format: getDateTimeFormat(),
             format: 'd/m/Y',
            value:dtcur,
            id: 'EndDtId'
        },{width:'30px'},{
  		        xtype: 'button',
  		        text: 'View',
  		        id: 'addbuttonid',
  		        cls: ' ',
  		        width: 80,
  		        listeners: {
  		                click: {
  		                    fn: function () {
  		                        if (Ext.getCmp('custcomboId').getValue() == "") {
  		                            Ext.example.msg("Select Customer");
  		                            Ext.getCmp('custcomboId').focus();
  		                            return;
  		                        }
								 if (Ext.getCmp('VehicleComboId').getValue() == "") {
  		                            Ext.example.msg("Select Vehicle");
  		                            Ext.getCmp('VehicleComboId').focus();
  		                            return;
  		                        }
  		                        if (Ext.getCmp('StartDtId').getValue() == "") {
  		                            Ext.example.msg("Select StartDate");
  		                            Ext.getCmp('StartDtId').focus();
  		                            return;
  		                        }
  		                        if (Ext.getCmp('EndDtId').getValue() == "") {
  		                            Ext.example.msg("Select EndDate");
  		                            Ext.getCmp('EndDtId').focus();
  		                            return;
  		                        }
  		                        var startdates = Ext.getCmp('StartDtId').getValue();
  		                        var enddates = Ext.getCmp('EndDtId').getValue();
  		                        
  		                    if (dateCompare(startdates,enddates) == -1) {
                             Ext.example.msg("End Date Must Be Greater than Start Date");
                             Ext.getCmp('EndDtId').focus();
                             return;
                               }
                                if (checkMonthValidation(startdates, enddates)) {
  		                            Ext.example.msg("Provide Month Validation");
  		                            Ext.getCmp('EndDtId').focus();
  		                            return;
  		                        }
  		                        vehiclewiseReportStore.load({
                                    params: {
                                        CustId: Ext.getCmp('custcomboId').getValue(),
  		                                startdate: Ext.getCmp('StartDtId').getValue(),
  		                                enddate: Ext.getCmp('EndDtId').getValue(),
  		                                vehicleNo:Ext.getCmp('VehicleComboId').getValue(),
  		                                custName:Ext.getCmp('custcomboId').getRawValue(),
 		                                jspName:jspName
                                    }
                                });  
  		                    }
  		                }
  		            }
  		    },{width:30}
        ]
    }); // End of Panel	 
        
  
    var reader = new Ext.data.JsonReader({
        idProperty: 'readerId',
        root: 'VehicleWiseSummaryRoot',
        totalProperty: 'total',
        fields: [{
            name: 'slnoIndex'
        },{
            name: 'vehicleNoDataIndex'
        },{
            name: 'businessIdDataIndex'
        },{
            name: 'customerNameDataIndex'
        },{
            name: 'trNumberDataIndex'
        },{
            name: 'businessTypeDataIndex'
        },{
            name: 'deliveryDataIndex'
        },{
            name: 'locationDataIndex'
        },{
            name: 'hubDataIndex'
        },{
            name: 'DateDataIndex',
            type: 'date',
            dateFormat: 'c'
        },{
        	name: 'singleDataIndex'
        },{
            name: 'oneWayDataIndex'
        },{
        	name: 'saidtoContainDataIndex'
        },{
            name: 'RateDataIndex'
        },{
        	name: 'AmountDataIndex'
        }]
    });

    var vehiclewiseReportStore = new Ext.data.GroupingStore({
        autoLoad: false,
        proxy: new Ext.data.HttpProxy({
            url: '<%=request.getContextPath()%>/CashVanReportAction.do?param=getvehiclewiseReport',
            method: 'POST'
        }),
        remoteSort: false,
        storeId: 'vehiclewiseReportId',
        reader: reader
    });


    var filters = new Ext.ux.grid.GridFilters({
        local: true,
        filters: [{
            type: 'numeric',
            dataIndex: 'slnoIndex'
        }, {
            type: 'string',
            dataIndex: 'vehicleNoDataIndex'
        }, {
            type: 'string',
            dataIndex: 'businessIdDataIndex'
        }, {
            type: 'string',
            dataIndex: 'customerNameDataIndex'
        }, {
            type: 'string',
            dataIndex: 'trNumberDataIndex'
        }, {
            type: 'string',
            dataIndex: 'businessTypeDataIndex'
        }, {
            type: 'string',
            dataIndex: 'deliveryDataIndex'
        }, {
            type: 'string',
            dataIndex: 'locationDataIndex'
        }, {
            type: 'string',
            dataIndex: 'hubDataIndex'
        }, {
            type: 'date',
            dataIndex: 'DateDataIndex'
        },{
        	type: 'string',
            dataIndex: 'singleDataIndex'
        }, {
            type: 'string',
            dataIndex: 'oneWayDataIndex'
        },{
        	type: 'string',
            dataIndex: 'saidtoContainDataIndex'
        }, {
            type: 'string',
            dataIndex: 'RateDataIndex'
        },{
        	type: 'string',
            dataIndex: 'AmountDataIndex'
        }]
    });
    
   //************************************Column Model Config******************************************
    var createColModel = function (finish, start) {

        var columns = [
            new Ext.grid.RowNumberer({
                header: "<span style=font-weight:bold;>Sl No</span>",
                width: 50
            }), {
                dataIndex: 'slnoIndex',
                hidden: true,
                header: "<span style=font-weight:bold;>Sl No</span>",
                filter: {
                    type: 'numeric'
                }
            },{
                header: "<span style=font-weight:bold;>Vehicle No</span>",
                dataIndex: 'vehicleNoDataIndex',
                filter: {
                    type: 'string'
                }
            }, {
                header: "<span style=font-weight:bold;>Business Id</span>",
                dataIndex: 'businessIdDataIndex',
                filter: {
                    type: 'string'
                }
            }, {
                header: "<span style=font-weight:bold;>Customer Name-Bank Name</span>",
                dataIndex: 'customerNameDataIndex',
                filter: {
                    type: 'string'
                }
            }, {
                header: "<span style=font-weight:bold;>TR Number</span>",
                dataIndex: 'trNumberDataIndex',
                filter: {
                    type: 'string'
                }
            },{
                header: "<span style=font-weight:bold;>Business Type</span>",
                dataIndex: 'businessTypeDataIndex',
                filter: {
                    type: 'string'
                }
            },{
                header: "<span style=font-weight:bold;>Delivery Customer</span>",
                dataIndex: 'deliveryDataIndex',
                filter: {
                    type: 'string'
                }
            },{
                header: "<span style=font-weight:bold;>Location/Address </span>",
                dataIndex: 'locationDataIndex',
                filter: {
                    type: 'string'
                }
            },{
                header: "<span style=font-weight:bold;>Hub</span>",
                dataIndex: 'hubDataIndex',
                filter: {
                    type: 'string'
            	}
            }, {
                header: "<span style=font-weight:bold;>Date</span>",
                dataIndex: 'DateDataIndex',
                renderer: Ext.util.Format.dateRenderer(getDateTimeFormat()),
                filter: {
                    type: 'date'
                }
            },{
                header: "<span style=font-weight:bold;>Single/Combine</span>",
                dataIndex: 'singleDataIndex',
                filter: {
                    type: 'string'
                }
            },{
                header: "<span style=font-weight:bold;>One Way/Two way </span>",
                dataIndex: 'oneWayDataIndex',
                filter: {
                    type: 'string'
                }
            },{
                header: "<span style=font-weight:bold;>Said to contain</span>",
                dataIndex: 'saidtoContainDataIndex',
                filter: {
                    type: 'string'
            	}
            },{
                header: "<span style=font-weight:bold;>Rate</span>",
                dataIndex: 'RateDataIndex',
                filter: {
                    type: 'string'
                }
            },{
                header: "<span style=font-weight:bold;>Amount</span>",
                dataIndex: 'AmountDataIndex',
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
    
   summaryGrid = getGrid('', 'No Records Found', vehiclewiseReportStore, screen.width - 35, 400, 22, filters, 'Clear Filter Data', false, '', 10, false, '', false, '', true, 'Excel', jspName, exportDataType, true, 'PDF'); 
    

	  Ext.onReady(function () {
        ctsb = tsb;
        Ext.QuickTips.init();
        Ext.form.Field.prototype.msgTarget = 'side';

        outerPanel = new Ext.Panel({
        	title:'Vehicle Wise Report',
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
       cm.setColumnWidth(j,155);
    }
    });
 </script>
  </body>
</html>
