<%@ page language="java" import="java.util.*,t4u.functions.CommonFunctions,t4u.beans.*,t4u.common.*" pageEncoding="UTF-8"%>
<%@ taglib uri="http://packtag.sf.net" prefix="pack" %> 
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
if (request.getParameter("list") != null) {
		String list = request.getParameter("list").toString().trim();
		String[] str = list.split(",");
		int systemid = Integer.parseInt(str[0].trim());
		int customerid = Integer.parseInt(str[1].trim());
		int userid = Integer.parseInt(str[2].trim());
		String language = str[3].trim();
		LoginInfoBean loginInfo = new LoginInfoBean();
		loginInfo.setSystemId(systemid);
		loginInfo.setCustomerId(customerid);
		loginInfo.setUserId(userid);
		loginInfo.setLanguage(language);
		loginInfo.setStyleSheetOverride("N");
		loginInfo.setZone(str[4].trim());
		loginInfo.setOffsetMinutes(Integer.parseInt(str[5].trim()));
		loginInfo.setSystemName(str[6].trim());
		loginInfo.setCategory(str[7].trim());
		if (str.length > 8) {
			loginInfo.setCustomerName(str[8].trim());
		}
		if (str.length > 9) {
			loginInfo.setCategoryType(str[9].trim());
		}
		if (str.length > 10) {
			loginInfo.setUserName(str[10].trim());
		}
		if (str.length > 11) {
			loginInfo.setStyleSheetOverride("N");
		}
		session.setAttribute("loginInfoDetails", loginInfo);
	}
	CommonFunctions cf = new CommonFunctions();
	LoginInfoBean loginInfo = (LoginInfoBean) session
			.getAttribute("loginInfoDetails");
	if (loginInfo == null) {
		response.sendRedirect(request.getContextPath()
				+ "/Jsps/Common/SessionDestroy.html");
	} else {
		session.setAttribute("loginInfoDetails", loginInfo);
		String language = loginInfo.getLanguage();
		int systemId = loginInfo.getSystemId();
		int customerId = loginInfo.getCustomerId();
		     
			 
%>

<!DOCTYPE HTML>
<html>
  <head>
    <base href="<%=basePath%>">
    <title>Trip Sheet Summary Report</title>
				<style>
				.labelstyle {
					spacing: 10px;
					height: 20px;
					width: 150 px !important;
					min-width: 150px !important;
					margin-bottom: 5px !important;
					margin-left: 5px !important;
					font-size: 12px;
					font-family: sans-serif;
				}
				.selectstylePerfect {
					height: 20px;
					width: 140px !important;
					listwidth: 120px !important;
					max-listwidth: 120px !important;
					min-listwidth: 120px !important;
					margin: 0px 0px 5px 5px !important;
				}
				.x-btn-text addbutton{font-family: 'Helvetica', sans-serif;
	                                                  font-size: 12px !important;}
				.x-btn-text editbutton{font-family: 'Helvetica', sans-serif;
				                                                  font-size: 12px !important;}
				.x-btn-text excelbutton{font-family: 'Helvetica', sans-serif;
				                                                  font-size: 12px !important;}
				.x-btn-text pdfbutton{font-family: 'Helvetica', sans-serif;
				                                                  font-size: 12px !important;}
				.x-btn-text{font-family: 'Helvetica', sans-serif;
				                                                  font-size: 12px !important;}
				.x-btn-text clearfilterbutton{font-family: 'Helvetica', sans-serif;
				                                                  font-size: 12px !important;
				}
	</style>
  </head>
  <body>
  <%if (loginInfo.getStyleSheetOverride().equals("Y")){%>
       <jsp:include page="../Common/ImportJSSandMining.jsp"/>
		<%}else {%>
		<jsp:include page="../Common/ImportJS.jsp" />
		<%} %>
		 <jsp:include page="../Common/ExportJS.jsp" />
 <script>
    //-------------------------------------------------------------------------------//
    var outerPanel;
    var jspName = "TripSheetSummaryReport";
    var json = "";
    var tripSheetSummaryGrid;
	var exportDataType = "int,string,string,number,number,number,int,int";
	var buttonValue;
	var dtcur = datecur;
    //----------------------------------customer store---------------------------// 
    var customercombostore = new Ext.data.JsonStore({
        url: '<%=request.getContextPath()%>/CommonAction.do?param=getCustomer',
        id: 'CustomerStoreId',
        root: 'CustomerRoot',
        autoLoad: true,
        remoteSort: true,
        fields: ['CustId', 'CustName'],
        listeners: {
            load: function(custstore, records, success, options) {
                if ( <%= customerId %> > 0) {
                    Ext.getCmp('custcomboId').setValue('<%=customerId%>');
                    custId = Ext.getCmp('custcomboId').getValue();
                    custName = Ext.getCmp('custcomboId').getRawValue();
                }
            }
        }
    });

    //******************************************************************customer Combo******************************************//
   var custnamecombo = new Ext.form.ComboBox({
        store: customercombostore,
        id: 'custcomboId',
        mode: 'local',
        forceSelection: true,
        emptyText: 'Select Customer',
        resizable: true,
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
                fn: function() {
                    custId = Ext.getCmp('custcomboId').getValue();
                    custName = Ext.getCmp('custcomboId').getRawValue();
                    
                        store.load();
                    }
                }
            }
    });

 var mineralStore =new Ext.data.SimpleStore({
        id: 'mineralStoreId',
        autoLoad: true,
        fields: ['name','value'],
        data: [['Iron Ore','Iron Ore'], 
        	   ['Iron Ore(E-Auction)','Iron Ore(E-Auction)']
        	  ]
    });

    var mineralCombo = new Ext.form.ComboBox({
        store: mineralStore,
        id: 'mineralComboId',
        mode: 'local',
        forceSelection: true,
        resizable: true,
        selectOnFocus: true,
        allowBlank: false,
        anyMatch: true,
        typeAhead: false,
        triggerAction: 'all',
        lazyRender: true,
        valueField: 'value',
        emptyText: 'Select Mineral',
        displayField: 'name',
        cls: 'selectstylePerfect'
    });
    //-------------------------------------------------------------------------------------------------------//
    var clientPanel = new Ext.Panel({
        standardSubmit: true,
        collapsible: false,
        id: '',
        layout: 'table',
        frame: true,
        width: screen.width - 20,
        height: 72,
        layoutConfig: {
            columns: 9
        },
        items: [{
                xtype: 'label',
                text: 'Customer' + ' :',
                cls: 'labelstyle',
                id: 'custnamelab'
            },{
                width: 5
            },
            custnamecombo, {
                width: 15
            },{
                xtype: 'label',
                text: 'MineralName' + ' :',
                cls: 'labelstyle',
                id: ''
            },{
                width: 5
            },
            mineralCombo,  {width: 100},{},
              {
                xtype: 'label',
                text: 'Start Date' + ' :',
                cls: 'labelstyle',
                id: 'startdatelab'
            },{
                width: 5
            },{
               xtype: 'datefield',
               cls: 'selectstylePerfect',
               width: 120,
               format: getDateFormat(),
               emptyText: 'Select Start Date',
               allowBlank: false,
               blankText: 'Select Start Date',
               id: 'startdate',
               value: currentDate
           }, {
               width: 15
           }, {
               xtype: 'label',
               cls: 'labelstyle',
               id: 'enddatelab',
               text: 'End Date' + ' :'
           }, {
               width: 5
           }, {
               xtype: 'datefield',
               cls: 'selectstylePerfect',
               width: 160,
               format: getDateFormat(),
               emptyText: 'Select End Date',
               allowBlank: false,
               blankText: 'Select End Date',
               id: 'enddate',
               value: nextDate
           }, {
                width: 15
            },  {
                xtype: 'button',
                text: 'GenerateReport',
                id: 'generateReport',
                cls: 'buttonwastemanagement',
                width: 100,
                listeners: {
                    click: {
                        fn: function() {
                            if (Ext.getCmp('custcomboId').getValue() == "") {
                                Ext.example.msg('Select Customer');
                                Ext.getCmp('custcomboId').focus();
                                 return;
             				  }
             				  if (Ext.getCmp('mineralComboId').getValue() == "") {
                                Ext.example.msg('Select Mineral');
                   				Ext.getCmp('mineralComboId').focus();
                                return;
                             }
            				 if(Ext.getCmp('startdate').getValue() == ""){
            				 	Ext.example.msg("Select Start date");
                                Ext.getCmp('startdate').focus();
                                return;
            				 }
            				 if(Ext.getCmp('enddate').getValue() == ""){
            				 	Ext.example.msg("Select End date");
                                Ext.getCmp('enddate').focus();
                                return;
            				 }
                             if (dateCompare(Ext.getCmp('startdate').getValue(), Ext.getCmp('enddate').getValue()) == -1) {
                                Ext.example.msg("End date must be greater than Start date");
                                Ext.getCmp('enddate').focus();
                                return;
                             }

                           var custName=Ext.getCmp('custcomboId').getRawValue();
                           //setTimeout(
                             //function () {
                            store.load({
                                params: {
                                    CustId: custId,
                                    custName: custName,
                                    jspName:jspName,
                                    systemId: 'systemId',
                                    startdate:Ext.getCmp('startdate').getValue(),
                                    enddate:Ext.getCmp('enddate').getValue(),
                                    mineralType:Ext.getCmp('mineralComboId').getValue()
                                }
                            });
                            //},180000);

                        }
                    }
                }
            }
        ]
    });
    //---------------------------------------------------Reader-------------------------------------------------------//
    

    

   
 var reader = new Ext.data.JsonReader({
        idProperty: 'tripSheetSummaryId',
        root: 'TripSheetSummaryReportRoot',
        totalProperty: 'total',
        fields: [{
            name: 'SLNODataIndex'
        }, {
            name: 'orgNameDataIndex'
        }, {
            name: 'permitTypeDataIndex'
        }, {
            name: 'truckTransFinesDataIndex'
        }, {
            name: 'truckTransLumpsDataIndex'
        }, {
            name: 'transportedROMDataIndex'
        }, {
            name: 'truckTripSheetCountDataIndex'
        }, {
            name: 'bargeTripSheetCountDataIndex'
        }]
    });

  var store = new Ext.data.GroupingStore({
        autoLoad: false,
        proxy: new Ext.data.HttpProxy({
            url: '<%=request.getContextPath()%>/TripSheetSummaryAction.do?param=getTripSheetSummaryReport',
            method: 'POST'
        }),
        remoteSort: false,
        bufferSize: 700,
        reader: reader
    });
    //------------------------------------------Filters--------------------------------------------------------//
    var filters = new Ext.ux.grid.GridFilters({
        local: true,
        filters: [{
            dataIndex: 'SLNODataIndex',
            type: 'numeric'
        }, {
            dataIndex: 'orgNameDataIndex',
            type: 'string'
        }, {
            dataIndex: 'permitTypeDataIndex',
            type: 'string'
        }, {
            dataIndex: 'truckTransFinesDataIndex',
            type: 'numeric'
        }, {
            dataIndex: 'truckTransLumpsDataIndex',
            type: 'numeric'
        }, {
            dataIndex: 'transportedROMDataIndex',
            type: 'numeric'
        }, {
            dataIndex: 'truckTripSheetCountDataIndex',
            type: 'int'
        }, {
            dataIndex: 'bargeTripSheetCountDataIndex',
            type: 'int'
        }]
    });
    //--------------------------------------------------column Model---------------------------------------//
    var createColModel = function(finish, start) {
        var columns = [
            new Ext.grid.RowNumberer({
                header: '<b>SL NO</b>',
                width: 50
            }), {
                header: '<b>SL NO</b>',
                hidden: true,
                sortable: true,
               // width: 120,
                dataIndex: 'SLNODataIndex'
            }, {
                header: '<b>Organisation Name</b>',
                //hidden: true,
                sortable: true,
               // width: 150,
                dataIndex: 'orgNameDataIndex'
            }, {
                header: '<b>Permit Type</b>',
                hidden: false,
                sortable: true,
                //width: 200,
                dataIndex: 'permitTypeDataIndex',
               
            }, {
                header: '<b>Transported Fines</b>',
                hidden: false,
                sortable: true,
                //width: 200,
                dataIndex: 'truckTransFinesDataIndex',
                
            }, {
                header: '<b>Transported Lumps</b>',
                hidden: false,
                sortable: true,
                //width: 170,
                dataIndex: 'truckTransLumpsDataIndex'
            }, {
                header: '<b>Transported ROM</b>',
                hidden: false,
                sortable: true,
               // width: 90,
                dataIndex: 'transportedROMDataIndex'
            }, {
                header: '<b>Truck TripSheet Count</b>',
                hidden: true,
                sortable: true,
               // width: 170,
                dataIndex: 'truckTripSheetCountDataIndex'
            }, {
                header: '<b>Barge TripSheet Count</b>',
                hidden: true,
                sortable: true,
                //width: 150,
                dataIndex: 'bargeTripSheetCountDataIndex'
            }
        ];
        return new Ext.grid.ColumnModel({
            columns: columns.slice(start || 0, finish),
            defaults: {
                sortable: true
            }
        });
    };
    
   tripSheetSummaryGrid = getGrid('Trip Sheet Summary Report', 'NoRecordsfound', store, screen.width - 40, 400, 12, filters, 'ClearFilterData', false, '', 14, false, '', false, '', true, 'Excel', jspName, exportDataType, false, 'PDF',false,'Add',false,'Modify',false,'',false,'',false,'Generate PDF');
     
     var mainPanel = new Ext.Panel({
        standardSubmit: true,
        frame: true,
        width: screen.width - 30,
        height: 420,
        layout: 'table',
        layoutConfig: {
            columns: 1
        },
        items: [tripSheetSummaryGrid]
       
    });
    
    Ext.onReady(function() {
    Ext.Ajax.timeout = 60000;
        outerPanel = new Ext.Panel({
            renderTo: 'content',
            standardSubmit: true,
            autoScroll: false,
            frame: true,
            border: false,
            id: 'outer',
            layout: 'table',
            width: screen.width-22,
            height: screen.height-280,
            cls: 'outerpanel',
            layoutConfig: {
                columns: 1
            },
            items: [clientPanel, mainPanel]
        });
    });
    
</script>
  </body>
</html>
<%}%>
