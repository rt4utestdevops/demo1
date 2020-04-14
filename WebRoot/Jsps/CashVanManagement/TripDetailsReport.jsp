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
	
	tobeConverted.add("SLNO");
	tobeConverted.add("Back");		
	tobeConverted.add("No_Records_Found");
	tobeConverted.add("Clear_Filter_Data");
	tobeConverted.add("Select_Single_Row");
	tobeConverted.add("Excel");
	tobeConverted.add("PDF");
	tobeConverted.add("Trip_Start_Date_Time");
    tobeConverted.add("Trip_End_Date_Time");
    tobeConverted.add("Trip_No");
	tobeConverted.add("Vehicle_No");
	tobeConverted.add("Business_Id");
	tobeConverted.add("Business_Type");		
	tobeConverted.add("Msp");
	tobeConverted.add("Bank");
	tobeConverted.add("Arrival_Date_Time");
	tobeConverted.add("Departure_Date_Time");
	tobeConverted.add("Distance_Travelled");
	tobeConverted.add("Duration");
	tobeConverted.add("Selec_Trip_No");
	
	
	
	ArrayList<String> convertedWords=new ArrayList<String>();
	convertedWords=cf.getLanguageSpecificWordForKey(tobeConverted, language);	
	

	String SlNo = convertedWords.get(0);
	String Back = convertedWords.get(1);	
	String NoRecordsFound = convertedWords.get(2);
	String ClearFilterData = convertedWords.get(3);
	String SelectSingleRow = convertedWords.get(4); 
	String Excel = convertedWords.get(5); 
	String PDF = convertedWords.get(6); 
	String TripStartDate=convertedWords.get(7); 
	String TripEndDate=convertedWords.get(8); 
	String TripNo=convertedWords.get(9); 
	String VehicleNo=convertedWords.get(10); 
	String BusinessId=convertedWords.get(11); 
	String BusinessType=convertedWords.get(12); 
	String Msp=convertedWords.get(13); 
	String Bank=convertedWords.get(14); 
	String ArrivalTime=convertedWords.get(15); 
	String DepartureTime=convertedWords.get(16); 
	String kmsTravelled=convertedWords.get(17); 
	String Duration=convertedWords.get(18); 
	String SelectTripNo=convertedWords.get(19);
		
%>

<!DOCTYPE HTML>
<html>
	<head>
		<title>Trip Details</title>		
	</head>	    
  
  	<body>
   		 <%if (loginInfo.getStyleSheetOverride().equals("Y")){%>                  
    <jsp:include page="../Common/ImportJSSandMining.jsp"/>                                               
   <%}else {%>  
   <jsp:include page="../Common/ImportJS.jsp" /><%} %>
   		<!-- for exporting to excel***** -->
        <jsp:include page="../Common/ExportJS.jsp" />
   	<script>
   	var jspName = "Trip_Details_Report";
  	var exportDataType = "int,string,string,date,date,string,string,string,string,date,date,string,number,string,date,string,number";
    var outerPanel;
    var ctsb;
    var detailsGrid;
    var tripNo = parent.tripNo;
    var startDate=parent.startDt;
    var endDate=parent.endDt;
    var globalCustomerId = parent.globalCustomerID;
    var globalCustomerName = parent.globalCustomerName;
	

	var tripstore = new Ext.data.JsonStore({
	    url: '<%=request.getContextPath()%>/CMSDashBoardAction.do?param=getTripNo',
	    id: 'tripNoStoreId',
	    root: 'tripNoRoot',
	    autoLoad: true,
	    remoteSort: true,
	    fields: ['tripNo']
	});
	
	tripstore.on('beforeload',function(store, operation,eOpts){
   				operation.params={
          	    	CustId : globalCustomerId,
          	    	startDt:startDate,
          	    	endDt:endDate
          	    };
    });
    
    tripstore.on('load',function(store, operation,eOpts){  	    
    	Ext.getCmp('tripNoComboId').setValue(tripNo);
       tripDetailsStore.load({
	        params : {
	            CustId: globalCustomerId,
	            tripNo: Ext.getCmp('tripNoComboId').getValue(),
	            jspName: jspName
	        },
	       callback: function(){
  var selectedrow = detailsGrid.getSelectionModel().getSelected();
  if(selectedrow == 'undefined' || selectedrow == "undefined" || selectedrow == undefined ){
  Ext.getCmp('VehicleNoId').setValue("");
 Ext.getCmp('TripStartTimeId').setValue("");
 Ext.getCmp('TripCloseDateId').setValue("");
  }else{
  Ext.getCmp('VehicleNoId').setValue(selectedrow.get('vehicleNumberDataIndex'));
 Ext.getCmp('TripStartTimeId').setValue(selectedrow.get('startDtDataIndex').format('d-m-Y h:i:s'));
 Ext.getCmp('TripCloseDateId').setValue(selectedrow.get('endDtDataIndex').format('d-m-Y h:i:s'));
}

}
	    });    	    
	},this);

	var tripNocombo = new Ext.form.ComboBox({
	    store: tripstore,
	    id: 'tripNoComboId',
	    mode: 'local',
	    forceSelection: true,
	    emptyText: '<%=SelectTripNo%>',
	    selectOnFocus: true,
	    allowBlank: false,
	    anyMatch: true,
	    typeAhead: false,
	    triggerAction: 'all',
	    lazyRender: true,
	    valueField: 'tripNo',
	    displayField: 'tripNo',
	    cls: 'selectperfectstyle',
	    listeners: {
	        select: {
	            fn: function () {	                
	                tripDetailsStore.load({
	                	params : {
	                		CustId: globalCustomerId,
	                		tripNo: Ext.getCmp('tripNoComboId').getValue(),
	                		jspName: jspName
	                	},
	                	callback: function(){
	  var selectedrow = detailsGrid.getSelectionModel().getSelected();	                	
	  if(selectedrow == 'undefined' || selectedrow == "undefined" || selectedrow == undefined ){
  Ext.getCmp('VehicleNoId').setValue("");
 Ext.getCmp('TripStartTimeId').setValue("");
 Ext.getCmp('TripCloseDateId').setValue("");
  }else{                	
  Ext.getCmp('VehicleNoId').setValue(selectedrow.get('vehicleNumberDataIndex'));
 Ext.getCmp('TripStartTimeId').setValue(selectedrow.get('startDtDataIndex').format('d-m-Y h:i:s'));
 Ext.getCmp('TripCloseDateId').setValue(selectedrow.get('endDtDataIndex').format('d-m-Y h:i:s'));
}

}
	                	
	                });
	            }
	        }
	    }
	});

    var reader = new Ext.data.JsonReader({
        idProperty: 'darreaderid',
        root: 'tripDetailsRoot',
        totalProperty: 'total',
        fields: [{
            name: 'slnoIndex'
        }, {
            name: 'vehicleNumberDataIndex'
        }, {
            name: 'tripNoDataIndex'
        }, {
            name: 'startDtDataIndex',
            type: 'date',
            dateFormat: 'c'
        }, {
            name: 'endDtDataIndex',
            type: 'date',
            dateFormat: 'c'
        }, {
            name: 'businessIdDataIndex'
        }, {
            name: 'businessTypeDataIndex'
        }, {
            name: 'mspDataIndex'
        }, {
            name: 'bankDataIndex'
        }, {
            name: 'arrivalTimeDataIndex',
            type: 'date',
            dateFormat: 'c'
        }, {
            name: 'deptTimeDataIndex',
            type: 'date',
            dateFormat: 'c'
        }, {
            name: 'durationDataIndex'
        }, {
            name: 'kmsTravelledDataIndex'
        },{
            name: 'OnAccOfDataIndex'        
        },{
            name: 'jobCompletionDataIndex'
        },{
            name: 'locationDataIndex'        
        },{
            name: 'totalAmountDataIndex'        
        }]
    });

    var tripDetailsStore = new Ext.data.GroupingStore({
        autoLoad: false,
        proxy: new Ext.data.HttpProxy({
            url: '<%=request.getContextPath()%>/CMSDashBoardAction.do?param=getTripDetailsReport',
            method: 'POST'
        }),
        remoteSort: false,
        storeId: 'detailsStore',
        reader: reader
    });

    var filters = new Ext.ux.grid.GridFilters({
        local: true,
        filters: [{
            type: 'numeric',
            dataIndex: 'slnoIndex'
        }, {
            type: 'string',
            dataIndex: 'vehicleNumberDataIndex'
        }, {
            type: 'string',
            dataIndex: 'tripNoDataIndex'
        }, {
            type: 'date',
            dataIndex: 'startDtDataIndex'
        }, {
            type: 'date',
            dataIndex: 'endDtDataIndex'
        }, {
            type: 'string',
            dataIndex: 'businessIdDataIndex'
        }, {
            type: 'string',
            dataIndex: 'businessTypeDataIndex'
        }, {
            type: 'string',
            dataIndex: 'mspDataIndex'
        }, {
            type: 'string',
            dataIndex: 'bankDataIndex'
        }, {
            type: 'date',
            dataIndex: 'arrivalTimeDataIndex'
        }, {
            type: 'date',
            dataIndex: 'deptTimeDataIndex'
        }, {
            type: 'numeric',
            dataIndex: 'durationDataIndex'
        }, {
            type: 'numeric',
            dataIndex: 'kmsTravelledDataIndex'
        },{
            type: 'string',
            dataIndex: 'OnAccOfDataIndex'
        
        }, {
            type: 'date',
            dataIndex: 'jobCompletionDataIndex'  
        },{
            type: 'string',
            dataIndex: 'locationDataIndex'
        
        },{
            type: 'string',
            dataIndex: 'totalAmountDataIndex'
        
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
                header: "<span style=font-weight:bold;><%=VehicleNo%></span>",
                dataIndex: 'vehicleNumberDataIndex',
                hidden:true,
                filter: {
                    type: 'string'
                }
            }, {
                header: "<span style=font-weight:bold;><%=TripNo%></span>",
                dataIndex: 'tripNoDataIndex',
                hidden:true,
                filter: {
                    type: 'string'
                }
            }, {
                header: "<span style=font-weight:bold;><%=TripStartDate%></span>",
                dataIndex: 'startDtDataIndex',
                renderer: Ext.util.Format.dateRenderer(getDateTimeFormat()),
                 hidden:true,
                filter: {
                    type: 'date'
                }
            }, {
                header: "<span style=font-weight:bold;><%=TripEndDate%></span>",
                dataIndex: 'endDtDataIndex',
                renderer: Ext.util.Format.dateRenderer(getDateTimeFormat()),
                 hidden:true,
                filter: {
                    type: 'date'
                }
            }, {
                header: "<span style=font-weight:bold;><%=BusinessId%></span>",
                dataIndex: 'businessIdDataIndex',
                filter: {
                    type: 'string'
                }
            }, {
                header: "<span style=font-weight:bold;><%=BusinessType%></span>",
                dataIndex: 'businessTypeDataIndex',
                filter: {
                    type: 'string'
                }
            }, {
                header: "<span style=font-weight:bold;><%=Msp%></span>",
                dataIndex: 'mspDataIndex',
                 hidden:true,
                filter: {
                    type: 'string'
                }
            }, {
                header: "<span style=font-weight:bold;><%=Bank%></span>",
                dataIndex: 'bankDataIndex',
                filter: {
                    type: 'string'
                }
            }, {
                header: "<span style=font-weight:bold;><%=ArrivalTime%></span>",
                dataIndex: 'arrivalTimeDataIndex',
                renderer: Ext.util.Format.dateRenderer(getDateTimeFormat()),
                 hidden:true,
                filter: {
                    type: 'date'
                }
            }, {
                header: "<span style=font-weight:bold;><%=DepartureTime%></span>",
                dataIndex: 'deptTimeDataIndex',
                renderer: Ext.util.Format.dateRenderer(getDateTimeFormat()),
                 hidden:true,
                filter: {
                    type: 'date'
                }
            }, {
                header: "<span style=font-weight:bold;><%=Duration%></span>",
                dataIndex: 'durationDataIndex',
                 hidden:true,
                filter: {
                    type: 'numeric'
                }
            }, {
                header: "<span style=font-weight:bold;><%=kmsTravelled%></span>",
                dataIndex: 'kmsTravelledDataIndex',
                 hidden:true,
                filter: {
                    type: 'numeric'
                }
            },
            {
                header: "<span style=font-weight:bold;>On Acc Of</span>",
                dataIndex: 'OnAccOfDataIndex',
                filter: {
                    type: 'string'
                }
            },  {
                header: "<span style=font-weight:bold;>Job Completion Date</span>",
                dataIndex: 'jobCompletionDataIndex',
                renderer: Ext.util.Format.dateRenderer(getDateTimeFormat()),
                 hidden:false,
                filter: {
                    type: 'date'
                }
                
                },
            {
                header: "<span style=font-weight:bold;>Location</span>",
                dataIndex: 'locationDataIndex',
                filter: {
                    type: 'string'
                }
            },
            {
                header: "<span style=font-weight:bold;>Total Amount</span>",
                dataIndex: 'totalAmountDataIndex',
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

    detailsGrid = getGrid('', '<%=NoRecordsFound%>', tripDetailsStore, screen.width - 38, 410, 18, filters, '<%=ClearFilterData%>', false, '', 16, false, '', false, '', true, '<%=Excel%>', jspName, exportDataType, true, '<%=PDF%>');

    var innerPanel = new Ext.Panel({
        standardSubmit: true,
        collapsible: false,
        id: 'detailsId',
        layout: 'table',
        frame: true,
        layoutConfig: {
            columns: 12
        },
        items: [{
                xtype: 'label',
                text: '<%=TripNo%>' + ' :',
                cls: 'labelstyle',
                id: 'tripNoId'
            },
            tripNocombo,            { 
              
                xtype: 'label',
                cls: 'labelstyle',
                id: 'lkrLabelId1123',
                text: '  ' ,
                width:80
                
                },  {
                xtype: 'label',
                cls: 'labelstyle',
                id: 'VehicleNoLabelId',
                text: 'Vehicle No' + ' :'
            }, {
              
                xtype: 'textfield',
                cls: 'selectstylePerfect',
                //width: 185,
                emptyText: 'Vehicle No',
                allowBlank: false,
                blankText: 'Vehicle No',
                id: 'VehicleNoId',             
                allowBlank: false,
                readOnly:true
            },
              { 
              
                xtype: 'label',
                cls: 'labelstyle',
                id: 'lkrLabelId11',
                text: '  ' ,
                width:80
                
                },  
           {
                xtype: 'label',
                cls: 'labelstyle',
                id: 'TripStartTimeLabelId',
                text: 'Trip Start Time' + ' :'
            }, {
              
                xtype: 'textfield',
                cls: 'selectstylePerfect',
                //width: 185,
                emptyText: 'Trip Start Time',
                allowBlank: false,
                blankText: 'Trip Start Time',
                id: 'TripStartTimeId',
                allowBlank: false,
                readOnly:true
            },
                { xtype: 'label',
                cls: 'labelstyle',
                id: 'lkrLabelId12',
                text: '  ' ,
                width:80},  
           {
                xtype: 'label',
                cls: 'labelstyle',
                id: 'TripEndTimeLabelId',
                text: 'Trip Close Time' + ' :'
            }, {
              
                xtype: 'textfield',
                cls: 'selectstylePerfect',
                //width: 185,
                emptyText: 'Trip Close Date',
                allowBlank: false,
                blankText: 'Trip Close Date',
                id: 'TripCloseDateId',              
                allowBlank: false,
                readOnly:true
            },
                { xtype: 'label',
                cls: 'labelstyle',
                id: 'lkrLabelId13',
                text: '  ' ,
                width:80}
        ]
    }); // End of Panel	
    
    var backButtonPanel = new Ext.Panel({   
        id: 'backbuttonid',
        standardSubmit: true,
        collapsible: false,
        cls: 'nextbuttonpanel',
        frame: false,
        layout: 'table',
        layoutConfig: {
            columns: 1
        },
        items: [{
            xtype: 'button',
            text: '<%=Back%>',
            id: 'backButtId',
            iconCls: 'backbutton',
            width: 80,
            listeners: {
                click: {
                    fn: function () {
						parent.Ext.getCmp('tripSummaryId').enable();
						parent.Ext.getCmp('tripSummaryId').show();
						parent.Ext.getCmp('tripDetailsId').disable();
                    }
                }
            }
        }]  	
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
            layoutConfig: {
                columns: 1
            },
            items: [innerPanel, detailsGrid, backButtonPanel]
            //bbar: ctsb
        });
    });
</script>
  	</body>
</html>