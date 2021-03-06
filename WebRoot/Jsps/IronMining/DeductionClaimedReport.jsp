
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
		    String SelectMineral="Select Mineral";
		    String DeductionClaimed="Deduction Claimed";
		    String SelectDeductionClaimed="Select Deduction Claimed";
		    String UnitInRs="Unit In Rs";
%>

<jsp:include page="../Common/header.jsp" />
    <base href="<%=basePath%>">
    <title>Deduction Claimed Report</title>
  
  <%if (loginInfo.getStyleSheetOverride().equals("Y")){%>
       <jsp:include page="../Common/ImportJSSandMining.jsp"/>
		<%}else {%>
		<jsp:include page="../Common/ImportJS.jsp" />
		<%} %>
		 <jsp:include page="../Common/ExportJS.jsp" />
		 <style>
			.x-panel-header
			{
				height: 7% !important;
			}		
			.x-grid3-cell-inner,.ext-strict .x-grid3-hd-inner {
				height: 26px !important;
				padding-top: 8px;
			}
			.x-window-tl *.x-window-header {
				padding-top : 6px !important;
			}
			label {
				display : inline !important;
			}
			.ext-strict .x-form-text {
				height: 21px !important;
			}
			.x-menu-list {
				height:auto !important;
			}
			.x-layer ul {
				//min-height: 27px !important;
			}
		</style>
 <script>
    //-------------------------------------------------------------------------------//
    var outerPanel;
    var jspName = "DeductiionClaimedReport";
    var json = "";
    var deductionClaimedGrid;
	var exportDataType = "int,string,string,float";
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

       
     var mineralStore =new Ext.data.SimpleStore({
        id: 'mineralStoreId',
        autoLoad: true,
        fields: ['name','value'],
        data: [['Iron Ore','Iron Ore'], 
        	   ['Bauxite/Laterite','Bauxite/Laterite'],
        	   ['Manganese','Manganese']
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
        emptyText: '<%=SelectMineral%>',
        displayField: 'name',
        cls: 'selectstylePerfect',
        listeners: {
            select: {
                fn: function() {
                    // Listener Logic
                    
                }
            }
        }
    });
    
     var deductionClaimedStore =new Ext.data.SimpleStore({
        id: 'deductionClaimedStoreId',
        autoLoad: true,
        fields: ['name','value'],
        data: [['Cost of Transportation','(a) Cost of Transportation (indicate Loading station and Distance from mines in remarks)'], 
        		 ['Loading & unloading Charges','(b) Loading and unloading Charges'],
        		 ['Railway freight','(c) Railway freight, if applicable (indicate destination and distance)'],
        		 ['Port Handling charges','(d) Port Handling charges/export duty (idicate name of port)'],
        		 ['Sampling & Analysis Charges','(e) Charges for Sampling and Analysis'],
        		 ['Rent for stocking yard','(f) Rent for the plot at stocking yard']
        		]
    });

    var deductionClaimedCombo = new Ext.form.ComboBox({
        store: deductionClaimedStore,
        id: 'deductionClaimedComboId',
        mode: 'local',
        forceSelection: true,
        selectOnFocus: true,
        resizable: true,
        allowBlank: false,
        anyMatch: true,
        typeAhead: false,
        triggerAction: 'all',
        lazyRender: true,
        valueField: 'value',
        emptyText: '<%=SelectDeductionClaimed%>',
        displayField: 'name',
        cls: 'selectstylePerfect',
        listeners: {
            select: {
                fn: function() {
                    // Listener Logic
                    
                }
            }
        }
    });
      //-------------------------------------------------------------------------------------------------------//
  
    //-------------------------------------------------------------------------------------------------------//
    var clientPanel = new Ext.Panel({
        standardSubmit: true,
        collapsible: false,
        id: '',
        layout: 'table',
        frame: true,
        width: screen.width - 20,
        height: 75,
        layoutConfig: {
            columns: 9
        },
        items: [{
                xtype: 'label',
                text: '<%=CustomerName%>' + ' :',
                cls: 'labelstyle',
                id: 'custnamelab'
            },{
                width: 50
            },
            custnamecombo, {
                width: 150
            }, {
                xtype: 'label',
                text: '<%=MonthYear%>' + ' :',
                cls: 'labelstyle',
                id: ''
            },{
                width: 50
            },{
					xtype: 'datefield',
					format:getMonthYearFormat(),  	
					plugins: 'monthPickerPlugin',	
					emptyText: '<%=SelectMonthYear%>',        
					id: 'DateId',  		        
					value: dtcur,  		     
					vtype: 'daterange',
					cls: 'selectstylePerfect'
					}, {
                width: 50
            },  {
                width: 50
            }, {
                xtype: 'label',
                text: '<%=MineralName%>' + ' :',
                cls: 'labelstyle',
                id: ''
            },{
                width: 50
            },
            mineralCombo,  {
                width: 50
            },
            {
                xtype: 'label',
                cls: 'labelstyle',
                id: '',
                text: '<%=DeductionClaimed%>' + ' :'
            }, {
                width: 50
            },
            deductionClaimedCombo,  {
                width: 100
            }, {
                xtype: 'button',
                text: '<%=GenerateReport%>',
                id: 'generateReport',
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
                            if (Ext.getCmp('DateId').getValue() == "") {
                                Ext.example.msg("<%=SelectMonthYear%>");
                   				 Ext.getCmp('DateId').focus();
                                return;
                            }
                            
                            if (Ext.getCmp('mineralComboId').getValue() == "") {
                                Ext.example.msg("<%=SelectMineral%>");
                   				Ext.getCmp('mineralComboId').focus();
                                return;
                            }

                            if (Ext.getCmp('deductionClaimedComboId').getValue() == "") {
                                Ext.example.msg("<%=SelectDeductionClaimed%>");
                                Ext.getCmp('deductionClaimedComboId').focus();
                                return;
                            } 
                           var custName=Ext.getCmp('custcomboId').getRawValue();
                            store.load({
                                params: {
                                    CustId: custId,
                                    custName: custName,
                                    jspName:jspName,
                                    systemId: <%=systemId%>,
                                    monthYear:Ext.getCmp('DateId').getRawValue(),
                                    mineralname:Ext.getCmp('mineralComboId').getValue(),
                                    deductioinClaimed:Ext.getCmp('deductionClaimedComboId').getRawValue(),
                                    deductionClaimedvalue:Ext.getCmp('deductionClaimedComboId').getValue()
                                    
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
        idProperty: 'DeductionDetailsRootId',
        root: 'DeductionDetailsRoot',
        totalProperty: 'total',
        fields: [ {
            name: 'slnoIndex'
        },{
            name: 'MineCodeIndex',
            type: 'string'
        }, {
            name: 'TcNoIndex',
            type: 'string'
        }, {
            name: 'UnitInRsIndex',
            type: 'numeric'
        }]
    });

    //-----------------------------------------------store---------------------------------------------------//
    var store = new Ext.data.GroupingStore({
        autoLoad: false,
        proxy: new Ext.data.HttpProxy({
            url: '<%=request.getContextPath()%>/MonthlyReturnsReportsAction.do?param=getDeductionDetails',
            method: 'POST'
        }),
        remoteSort: false,
        sortInfo: {
            field: 'MineCodeIndex',
            direction: 'ASC'
        },
        bufferSize: 700,
        reader: reader
    });
    //------------------------------------------Filters--------------------------------------------------------//
    var filters = new Ext.ux.grid.GridFilters({
        local: true,
        filters: [  {
            dataIndex: 'slnoIndex',
            type: 'numeric'
        }, {
            dataIndex: 'MineCodeIndex',
            type: 'string'
        }, {
            dataIndex: 'TcNoIndex',
            type: 'string'
        }, {
            dataIndex: 'UnitInRsIndex',
            type: 'numeric'
        }]
    });
    //--------------------------------------------------column Model---------------------------------------//
    var createColModel = function(finish, start) {
        var columns = [
             new Ext.grid.RowNumberer({
                header: "<span style=font-weight:bold;><%=SLNO%></span>",
                width: 50
            }), {
                dataIndex: 'slnoIndex',
                hidden: true,
                header: "<span style=font-weight:bold;>SlNo</span>",
                filter: {
                    type: 'numeric'
                }
            }, {
                header: '<b><%=MineCode%></b>',
                sortable: true,
              	width: 120,
                dataIndex: 'MineCodeIndex'
            }, {
                header: '<b><%=TcNo%></b>',
                sortable: true,
                width: 120,
                dataIndex: 'TcNoIndex'
            }, {
                header: '<b><%=UnitInRs%></b>',
                sortable: true,
               	width: 120,
                dataIndex: 'UnitInRsIndex'
            }        ];
        return new Ext.grid.ColumnModel({
            columns: columns.slice(start || 0, finish),
            defaults: {
                sortable: true
            }
        });
    };
    //---------------------------------------------------------grid-------------------------------------------//

	deductionClaimedGrid = getGrid('Deduction Claimed Details', '<%=NoRecordsfound%>', store, screen.width - 38, 400, 5, filters, '<%=ClearFilterData%>', false, '', 4, false, '', false, '', true, '<%=Excel%>', jspName, exportDataType, false, 'PDF',false,'Add',false,'Modify',false,'',false,'',false,'Generate PDF');


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
        items: [deductionClaimedGrid]
       
    });

  function getMonthYearFormat(){
		return 'F Y';
	}
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
            height: screen.height-220,
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
