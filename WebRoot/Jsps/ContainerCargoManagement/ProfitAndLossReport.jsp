<%@ page language="java" import="java.util.*,t4u.beans.*,t4u.functions.CommonFunctions,t4u.common.*" pageEncoding="UTF-8"%>
<%@ taglib uri="http://packtag.sf.net" prefix="pack" %> 
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
String fromMonthYear = "From Month & Year";
String toMonthYear = "To Month & Year";
String SelectMonthYear = "Select Month and Year";
String Submit = "Submit";
String SelectFromMonthYear = "Select From Month & Year";
String SelectToMonthYear = "Select To Month& Year";
String NoRecordsfound = "No Records Found";
String ClearFilterData = "Clear Filter Data";
LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
%>

<jsp:include page="../Common/header.jsp" />
    <base href="<%=basePath%>">
    
    <title>Profit and Loss Report</title>
   
    <%if (loginInfo.getStyleSheetOverride().equals("Y")){%>
       <jsp:include page="../Common/ImportJSSandMining.jsp"/>
		<%}else {%>
		<jsp:include page="../Common/ImportJS.jsp" />
		<%} %>
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
		 .x-panel-bbar-noborder {
			margin-top : -24px !important;
		}
	</style>		 
    <script>
    	var outerPanel;
    	var dtcur = datecur;
    	var dtNext = nextMonth;
        var jspName = "profitandLossReport";
        var exportDataType = "int,string,string,numeric,numeric,numeric,numeric,numeric"
        var panelForSelection = new Ext.Panel({
        standardSubmit: true,
        collapsible: false,
        layout: 'table',
        frame: true,
        width: screen.width - 35,
        height: 50,
        layoutConfig: {
            columns: 10
        },
        items: [{width:50},{
                xtype: 'label',
                text: '<%=fromMonthYear%>' + ' :',
                cls: 'labelstyle'
            }, {width: 20},{
				xtype: 'datefield',
				format:getMonthYearFormat(),  	
				plugins: 'monthPickerPlugin',	
				emptyText: '<%=SelectMonthYear%>',        
				id: 'DateId',  		        
				value: dtcur,  		     
				vtype: 'daterange',
				cls: 'selectstylePerfect'
			},{width: 50},{
                xtype: 'label',
                text: '<%=toMonthYear%>' + ' :',
                cls: 'labelstyle'
            },{width: 20},{
				xtype: 'datefield',
				format:getMonthYearFormat(),  	
				plugins: 'monthPickerPlugin',	
				emptyText: '<%=SelectMonthYear%>',        
				id: 'DateId1',  		        
				value: dtNext,  		     
				vtype: 'daterange',
				cls: 'buttonwastemanagement'
			},{width: 50},{
                xtype: 'button',
                text: '<%=Submit%>',
                id: 'generateReport',
                cls: 'buttonwastemanagement',
                width: 100,
                listeners: {
                    click: { 
                    	fn: function() {
                            if (Ext.getCmp('DateId').getValue() == "") {
                                Ext.example.msg("<%=SelectFromMonthYear%>");
                   				 Ext.getCmp('DateId').focus();
                                return;
                            }
                            if (Ext.getCmp('DateId1').getValue() == "") {
                                Ext.example.msg("<%=SelectToMonthYear%>");
                   				 Ext.getCmp('DateId1').focus();
                                return;
                            }
                            var selected = vehicleGrid.getSelectionModel().getSelected();
		                 	if(selected==undefined || selected=="undefined"){
  								Ext.example.msg("Please select at least one vehicle");
								return;
         					}
     						var records = vehicleGrid.getSelectionModel().getSelections();
					       	var vehicleNo = "";
					       	for (var i = 0, len = records.length; i < len; i++){
						 		var record = records[i];
					       		vehicleNo=vehicleNo + record.get("VehicleNo")+",";
					       	}
                           store.load({
                           	params:{
                           		vehicleNo: vehicleNo,
                           		fromDate: Ext.getCmp('DateId').getValue(),
                           		toDate: Ext.getCmp('DateId1').getValue(),
                           		jspName: jspName
                           	}	
                           }); 
						  }//function
                   		}//click
                	}//listeners
           		}
        	]
    });
    var reader1 = new Ext.data.JsonReader({
        idProperty: 'profitLossRootId',
        root: 'profitLossRoot',
        totalProperty: 'total',
        fields: [ {
        				name: 'SLNODI',
        				type: 'int'
        			},{
			            name: 'vehicleDI',
			            type: 'string'
			        },{
			            name: 'monthDI',
			            type: 'string'
			        },{
			            name: 'sumOfTripsDI',
			            type: 'string'
			        },{
			            name: 'kmsDI',
			            type: 'string'
			        },{
			            name: 'invoiceReceivedDI',
			            type: 'float'
			        },{
			            name: 'expenseDI',
			            type: 'float'
			        },{
			            name: 'profitLossDI',
			            type: 'float'
			        }]
    });
    var filters1 = new Ext.ux.grid.GridFilters({
        local: true,
        filters: [ {
        	dataIndex: 'SLNODI',
        	type: 'numeric'
        },{
            dataIndex: 'vehicleDI',
            type: 'string'
        }, {
            dataIndex: 'monthDI',
            type: 'string'
        }, {
            dataIndex: 'sumOfTripsDI',
            type: 'numeric'
        }, {
            dataIndex: 'kmsDI',
            type: 'numeric'
        }, {
            dataIndex: 'invoiceReceivedDI',
            type: 'numeric'
        }, {
            dataIndex: 'expenseDI',
            type: 'numeric'
        }, {
            dataIndex: 'profitLossDI',
            type: 'numeric'
        }]
    });
    var createColModel = function(finish, start) {
        var columns = [
             new Ext.grid.RowNumberer({
                header: "<span style=font-weight:bold;>SLNO</span>",
                width: 50
            }),{
            	header: '<b>SL No</b>',
                sortable: true,
                hidden: true,
                width: 100,
                dataIndex: 'SLNODI',
                filter: {
                    type: 'numeric'
                }
            },{
                header: '<b>Vehicle</b>',
                sortable: true,
                width: 120,
                dataIndex: 'vehicleDI',
                filter: {
                    type: 'string'
                }
            }, {
                header: '<b>Month</b>',
                sortable: true,
              	width: 100,
                dataIndex: 'monthDI',
                filter: {
                    type: 'string'
                }
            }, {
                header: '<b>Sum of Trips</b>',
                sortable: true,
               	width: 100,
                dataIndex: 'sumOfTripsDI',
                filter: {
                    type: 'numeric'
                }
            }, {
                header: '<b>Sum of Total Master Kms</b>',
                sortable: true,
                width: 140,
                dataIndex: 'kmsDI',
                filter: {
                    type: 'numeric'
                }
            }, {
                header: '<b>Sum of Invoice Received</b>',
                sortable: true,
               	width: 140,
                dataIndex: 'invoiceReceivedDI',
                filter: {
                    type: 'numeric'
                }
            }, {
                header: '<b>Sum of Total Expenses</b>',
                sortable: true,
                width: 140,
                dataIndex: 'expenseDI',
                filter: {
                    type: 'numeric'
                }
            },  {
                header: '<b>Sum of Profit and Loss</b>',
                sortable: true,
              	width: 140,
                dataIndex: 'profitLossDI',
                filter: {
                    type: 'string'
                }
            }];
        return new Ext.grid.ColumnModel({
            columns: columns.slice(start || 0, finish),
            defaults: {
                sortable: true
            }
        });
    };
    var store = new Ext.data.GroupingStore({
        autoLoad: false,
        proxy: new Ext.data.HttpProxy({
            url: '<%=request.getContextPath()%>/profitAndLossPath.do?param=getProfitAndLossDetails',
            method: 'POST'
        }),
        remoteSort: false,
        bufferSize: 700,
        reader: reader1
    });
    var profitGrid = getGrid('Profit and Loss Details', '<%=NoRecordsfound%>', store, 1120, 445, 9, filters1, '<%=ClearFilterData%>', false, '', 11, false, '', false, '', true, 'Excel', jspName, exportDataType, false, 'PDF',false,'Add',false,'Modify',false,'',false,'',false,'Generate PDF');
    
    var filters = new Ext.ux.grid.GridFilters({
        local: true,
        filters:[ {
            dataIndex: 'VehicleNo',
            type: 'string'
        }]
    });    
    var reader = new Ext.data.JsonReader({
        idProperty: 'vehicleGridRootId',
        root: 'vehicleGridRoot',
        totalProperty: 'total',
        fields:[{
				name: 'VehicleNo',
				type: 'string'
			   }]
    });
    var sm= new Ext.grid.CheckboxSelectionModel({});
    var vehicleGridCM = new Ext.grid.ColumnModel(
    	[ sm,{
        header: '<b>Vehicle No</b>',
        sortable: true,
       	width: 120,
        dataIndex: 'VehicleNo',
        filter: {
            	type: 'string'
        	}
        }]
     );   
   	var vehicleGridStore = new Ext.data.GroupingStore({
		url:'<%=request.getContextPath()%>/profitAndLossPath.do?param=getVehicleNo',
		bufferSize: 367,
		reader: reader,
		autoLoad: true,
		remoteSort: true
	}); 
    var vehicleGrid = new Ext.grid.GridPanel({
    		title:'Vehicle No',
	        border: false,
	        height: 470,
	        width: 200,
	        autoScroll:true,
	        store: vehicleGridStore,
	        id:'vehicleGrid',
	        colModel: vehicleGridCM,
	        sm: sm,
	        loadMask: true,
	        view: new Ext.grid.GroupingView({
	        	autoFill:true,
	            emptyText: 'No Records Found',deferEmptyText: false
	        }),
	        listeners: {
               render : function(grid){
                 vehicleGrid.store.on('load', function(store, records, options){
                   vehicleGrid.getSelectionModel().selectFirstRow();       
                 });                      
               }
              },
	        plugins: [filters],	       
	        bbar: new Ext.Toolbar({
	        })
	        });
	        vehicleGrid.getBottomToolbar().add([
	        '->',
	        {
	            text: 'Clear Filters',
	            iconCls : 'clearfilterbutton',
	            handler: function () {
	        	vehicleGrid.filters.clearFilters();
	            } 
	        }]);
    var gridPanel = new Ext.Panel({
    	standardSubmit : true,
    	frame:true,
	    id:'mainpanel',
		width:screen.width-34,
		height: 475,
		layout: 'table',
		layoutConfig:{columns:2},
		items:[vehicleGrid, profitGrid]
    });
    function getMonthYearFormat(){
		return 'F Y';
	}
    Ext.onReady(function() {
        outerPanel = new Ext.Panel({
        	title: 'Profit and Loss Report',
            renderTo: 'content',
            standardSubmit: true,
            autoScroll: false,
            frame: true,
            border: false,
            id: 'outer',
            layout: 'table',
            width: screen.width-22,
            height: screen.height-215,
            cls: 'outerpanel',
            layoutConfig: {
                columns: 1
            },
            items: [panelForSelection, gridPanel]
        });
    });
    </script>
 <jsp:include page="../Common/footer.jsp" />
 <!-- </body>   -->
 <!-- </html> -->
