
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
	LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
	if (loginInfo == null) {
			response.sendRedirect(request.getContextPath()+ "/Jsps/Common/SessionDestroy.html");
	} else {
		session.setAttribute("loginInfoDetails", loginInfo);
		String language = loginInfo.getLanguage();
		int systemId = loginInfo.getSystemId();
		int customerId = loginInfo.getCustomerId();
		     
			 ArrayList<String> tobeConverted = new ArrayList<String>();
			 tobeConverted.add("SLNO");
			 tobeConverted.add("Select_Customer");
			 tobeConverted.add("Customer_Name");
			 tobeConverted.add("Mineral_Name");
			 tobeConverted.add("Mine_Code");
			 tobeConverted.add("Month_Year");
			 tobeConverted.add("TC_No");
			 tobeConverted.add("Generate_Report");
			 tobeConverted.add("Communication_Status");
			 tobeConverted.add("Remarks");
			 tobeConverted.add("No_Records_Found");
			 tobeConverted.add("Clear_Filter_Data");
			 tobeConverted.add("Excel");
			 
			ArrayList<String> convertedWords = new ArrayList<String>();
			convertedWords = cf.getLanguageSpecificWordForKey(tobeConverted,language);

		    String SLNO = convertedWords.get(0);
		    String SelectCustomer = convertedWords.get(1);
		    String CustomerName = convertedWords.get(2);
		    String MineralName=convertedWords.get(3);
		    String MineCode=convertedWords.get(4);
		    String MonthYear=convertedWords.get(5);
		    String TcNo=convertedWords.get(6);
		    String GenerateReport=convertedWords.get(7);
			String CommunicationStatus= convertedWords.get(8);
			String remarks= convertedWords.get(9);
			String NoRecordsfound= convertedWords.get(10);
			String ClearFilterData = convertedWords.get(11);
		    String Excel=convertedWords.get(12);
		    String SelectMonthYear="Select Month Year";
		    String SelectReportType="Select Report Type";
%>

<jsp:include page="../Common/header.jsp" />
    <base href="<%=basePath%>">
    <title>Un authorized Block Entry</title>
 
  <%if (loginInfo.getStyleSheetOverride().equals("Y")){%>
       <jsp:include page="../Common/ImportJSSandMining.jsp"/>
		<%}else {%>
		<jsp:include page="../Common/ImportJS.jsp" />
		<%} %>
		 <jsp:include page="../Common/ExportJS.jsp" />
		 <% String newMenuStyle=loginInfo.getNewMenuStyle();
		if(newMenuStyle.equalsIgnoreCase("YES")){%>
		<style>							
			label {
				display : inline !important;
			}			
			.ext-strict .x-form-text {
				height: 21px !important;
			}	
			.x-window-tl *.x-window-header {
				padding-top : 6px !important;				
			}					
			.x-layer ul {
				min-height: 27px !important;
			}
			.x-menu-list {
				height:auto !important;
			}
			.x-panel-body .x-panel-body-noborder {
				height : 330px !important;
			}
		</style>
	 <%}%>
 <script>
    //-------------------------------------------------------------------------------//
    var outerPanel;
    var jspName = "UnAuthorized Block Entry Report";
    var json = "";
    var unAuthBlockEntryGrid;
	var exportDataType = "int,string,string,string,string,string,string,string";
	var buttonValue;
	var dtcur = datecur;
	var title;
	
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
        emptyText: '<%=SelectCustomer%>',
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
                    
                        //store.load();
                    }
                }
            }
    });

       
     var reportTypeStore =new Ext.data.SimpleStore({
        id: 'reportTypeStoreId',
        autoLoad: true,
        fields: ['name','value'],
        data: [['Un Authorized Entry','Un Authorized Entry'], 
        	   ['Red Zone Entry','Red Zone Entry']
        	  ]
    });

    var reportTypeCombo = new Ext.form.ComboBox({
        store: reportTypeStore,
        id: 'reportTypeComboId',
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
        emptyText: 'Select Report Type',
        displayField: 'name',
        cls: 'selectstylePerfect',
        listeners: {
            select: {
                fn: function () {
                	store.load({
                                params: {
                                    CustId: 0,
                                    custName: '',
                                    jspName: jspName,
                                    systemId: 0,
                                    report: '',
                                    startdate:'',
                                    enddate:''
                                }
                            });	 
			            title = Ext.getCmp('reportTypeComboId').getValue();
                    	var reportType = Ext.getCmp('reportTypeComboId').getValue();
			  			if(reportType == 'Un Authorized Entry'){
			  				unAuthBlockEntryGrid.setTitle('UnAuthorized Block Entry Report');
			  				unAuthBlockEntryGrid.getColumnModel().setHidden(unAuthBlockEntryGrid.getColumnModel().findColumnIndex('redZoneIndex'), true);
			  				unAuthBlockEntryGrid.getColumnModel().setHidden(unAuthBlockEntryGrid.getColumnModel().findColumnIndex('authSandBlockIndex'), false);
			  				unAuthBlockEntryGrid.getColumnModel().setHidden(unAuthBlockEntryGrid.getColumnModel().findColumnIndex('unAuthSandBlockIndex'), false);
			  			}else if(reportType == 'Red Zone Entry'){
			  			
			  				unAuthBlockEntryGrid.setTitle('Red Zone Entry Report');
			  				unAuthBlockEntryGrid.getColumnModel().setHidden(unAuthBlockEntryGrid.getColumnModel().findColumnIndex('authSandBlockIndex'), true);
			  				unAuthBlockEntryGrid.getColumnModel().setHidden(unAuthBlockEntryGrid.getColumnModel().findColumnIndex('unAuthSandBlockIndex'), true);
			  				unAuthBlockEntryGrid.getColumnModel().setHidden(unAuthBlockEntryGrid.getColumnModel().findColumnIndex('redZoneIndex'), false);
			  			}
			           
                } // END OF FUNCTION
            } // END OF SELECT
        } // END OF LISTENERS
        
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
                text: 'Report Type' + ' :',
                cls: 'labelstyle',
                id: ''
            },{
                width: 5
            },
            reportTypeCombo,  {width: 100},{},
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
                text: 'View',
                id: 'viewId',
                cls: 'buttonwastemanagement',
                width: 100,
                listeners: {
                    click: {
                        fn: function() {
                            if (Ext.getCmp('custcomboId').getValue() == "") {
                                Ext.example.msg("<%=SelectCustomer%>");
                                Ext.getCmp('custcomboId').focus();
                                 return;
             				  }
             				  if (Ext.getCmp('reportTypeComboId').getValue() == "") {
                                Ext.example.msg("<%=SelectReportType%>");
                   				Ext.getCmp('reportTypeComboId').focus();
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
                            store.load({
                                params: {
                                    CustId: custId,
                                    custName: custName,
                                    jspName:jspName,
                                    systemId: <%=systemId%>,
                                    report: Ext.getCmp('reportTypeComboId').getValue(),
                                    startdate:Ext.getCmp('startdate').getValue(),
                                    enddate:Ext.getCmp('enddate').getValue()
                                }
                            });	 
                        }
                    }
                }
            }
        ]
    });
    //---------------------------------------------------Reader-------------------------------------------------------//
    var reader = new Ext.data.JsonReader({
        idProperty: 'unAuthEntryOrRedZoneRootId',
        root: 'unAuthEntryOrRedZoneRoot',
        totalProperty: 'total',
        fields: [{
        	name: 'slnoIndex'
        }, {
            name: 'vehicleNoIndex'
        }, {
            name: 'authSandBlockIndex'
        }, {
            name: 'unAuthSandBlockIndex'
        }, {
            name: 'redZoneIndex'
        }, {
            name: 'arivalTimeIndex'
        }, {
            name: 'departureTimeIndex'
        }, {
            name: 'detentionTimeIndex'
        }]
    });

    //-----------------------------------------------store---------------------------------------------------//
    var store = new Ext.data.GroupingStore({
        autoLoad: false,
        proxy: new Ext.data.HttpProxy({
            url: '<%=request.getContextPath()%>/SandBoatAssociationAction.do?param=getUnAuthEntryOrRedZoneDetails',
            method: 'POST'
        }),
        remoteSort: false,
        bufferSize: 700,
        reader: reader
    });
    //------------------------------------------Filters--------------------------------------------------------//
    var filters = new Ext.ux.grid.GridFilters({
        local: true,
        filters: [ {
            dataIndex: 'slnoIndex',
            type: 'int'
        }, {
            dataIndex: 'vehicleNoIndex',
            type: 'string'
        }, {
            dataIndex: 'authSandBlockIndex',
            type: 'string'
        }, {
            dataIndex: 'unAuthSandBlockIndex',
            type: 'string'
        }, {
            dataIndex: 'redZoneIndex',
            type: 'string'
        }, {
            dataIndex: 'arivalTimeIndex',
            type: 'date'
        }, {
            dataIndex: 'departureTimeIndex',
            type: 'date'
        }, {
            dataIndex: 'detentionTimeIndex',
            type: 'int'
        }]
    });
    //--------------------------------------------------column Model---------------------------------------//
    var createColModel = function(finish, start) {
        var columns = [
             new Ext.grid.RowNumberer({
                header: "<span style=font-weight:bold;>SlNo</span>",
                width: 60
            }),{
             dataIndex: 'slnoIndex',
             hidden: true,
             width: 50,
             header: "<span style=font-weight:bold;>SLNo</span>"
        	}, {
                dataIndex: 'vehicleNoIndex',
                header: "<span style=font-weight:bold;>Vehicle NO</span>",
                 width: 60,
            },  {
	            dataIndex: 'authSandBlockIndex',
	            header: "<span style=font-weight:bold;>Authorized Sand Block</span>",
	            width: 100
	        },  {
	            dataIndex: 'unAuthSandBlockIndex',
	            header: "<span style=font-weight:bold;>Un Authorized Sand Block</span>",
	            width: 100
	        },  {
	            dataIndex: 'redZoneIndex',
	            header: "<span style=font-weight:bold;>Red Zone</span>",
	            width: 80
	        }, {
	            dataIndex: 'arivalTimeIndex',
	            header: "<span style=font-weight:bold;>Arival Time</span>",
	            width: 60
	        }, {
	            dataIndex: 'departureTimeIndex',
	            header: "<span style=font-weight:bold;>Departure Time</span>",
	            width: 60
	        }, {
	            dataIndex: 'detentionTimeIndex',
	            header: "<span style=font-weight:bold;>Detention Time</span>",
	            width: 50
	        } ];
	        
        return new Ext.grid.ColumnModel({
            columns: columns.slice(start || 0, finish),
            defaults: {
                sortable: true
            }
        });
    };
    //---------------------------------------------------------grid-------------------------------------------//
	unAuthBlockEntryGrid = getGrid('Report', '<%=NoRecordsfound%>', store, screen.width - 40, 400, 18, filters, '<%=ClearFilterData%>', false, '', 20, false, '', false, '', true, '<%=Excel%>', jspName, exportDataType, true, 'PDF',false,'Add',false,'Modify',false,'',false,'',false,'Generate PDF');
    //--------------------------------------------------------------------------------------------------------//
  
    var mainPanel = new Ext.Panel({
        standardSubmit: true,
        frame: true,
        width: screen.width - 30,
        height: 420,
        layout: 'table',
        layoutConfig: {
            columns: 1
        },
        items: [unAuthBlockEntryGrid]
       
    });
    Ext.onReady(function() {
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
 <jsp:include page="../Common/footer.jsp" />
 <!-- </body>   -->
 <!-- </html> -->
<%}%>
