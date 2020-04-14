
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
%>

<!DOCTYPE HTML>
<html>
  <head>
    <base href="<%=basePath%>">
    <title>Permit Summary Report</title>
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
    var jspName = "PermitSummaryReport";
    var json = "";
    var permitSummaryGrid;
	var exportDataType = "int,string,string,number,number,number,number,number,number,number,number,number,number,number,number";
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
        emptyText: '<%=SelectMineral%>',
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
                text: '<%=MineralName%>' + ' :',
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
             				  if (Ext.getCmp('mineralComboId').getValue() == "") {
                                Ext.example.msg("<%=SelectMineral%>");
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
                            store.load({
                                params: {
                                    CustId: custId,
                                    custName: custName,
                                    jspName:jspName,
                                    systemId: <%=systemId%>,
                                    startdate:Ext.getCmp('startdate').getValue(),
                                    enddate:Ext.getCmp('enddate').getValue(),
                                    mineralType:Ext.getCmp('mineralComboId').getValue()
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
        idProperty: 'PermitSummaryDetailsRootId',
        root: 'PermitSummaryDetailsRoot',
        totalProperty: 'total',
        fields: [ {
            name: 'slnoIndex'
        }, {
            name: 'orgTraderNameIndex'
        }, {
            name: 'permitTypeIndex'
        }, {
            name: 'ROMQuantitytIndex'
        }, {
            name: 'FinesQuantitytIndex'
        }, {
            name: 'LumpsQuantitytIndex'
        }, {
            name: 'TailingsQuantitytIndex'
        }, {
            name: 'RejectsQuantitytIndex'
        }, {
            name: 'ConcentratesQuantitytIndex'
        }, {
            name: 'transportedROMIndex'
        }, {
            name: 'transportedFinesIndex'
        }, {
            name: 'transportedLumpsIndex'
        }, {
            name: 'transportedTailingsIndex'
        }, {
            name: 'transportedRejectsIndex'
        }, {
            name: 'transportedConcentratesIndex'
        }]
    });

    //-----------------------------------------------store---------------------------------------------------//
    var store = new Ext.data.GroupingStore({
        autoLoad: false,
        proxy: new Ext.data.HttpProxy({
            url: '<%=request.getContextPath()%>/PermitReportAction.do?param=getPermitSummaryDetails',
            method: 'POST'
        }),
        remoteSort: false,
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
            dataIndex: 'orgTraderNameIndex',
            type: 'string'
        }, {
            dataIndex: 'permitTypeIndex',
            type: 'string'
        }, {
            dataIndex: 'ROMQuantitytIndex',
            type: 'numeric'
        }, {
            dataIndex: 'FinesQuantitytIndex',
            type: 'numeric'
        }, {
            dataIndex: 'TailingsQuantitytIndex',
            type: 'numeric'
        }, {
            dataIndex: 'RejectsQuantitytIndex',
            type: 'numeric'
        }, {
            dataIndex: 'ConcentratesQuantitytIndex',
            type: 'numeric'
        }, {
            dataIndex: 'transportedROMIndex',
            type: 'numeric'
        }, {
            dataIndex: 'transportedFinesIndex',
            type: 'numeric'
        }, {
            dataIndex: 'transportedLumpsIndex',
            type: 'numeric'
        }, {
            dataIndex: 'transportedTailingsIndex',
            type: 'numeric'
        }, {
            dataIndex: 'transportedRejectsIndex',
            type: 'numeric'
        }, {
            dataIndex: 'transportedConcentratesIndex',
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
                header: "<span style=font-weight:bold;>SlNo</span>"
            },  {
	            dataIndex: 'orgTraderNameIndex',
	            header: 'Organization/Trader Name'
	        }, {
	            dataIndex: 'permitTypeIndex',
	            header: 'Permit Type'
	        }, {
	            dataIndex: 'ROMQuantitytIndex',
	            header: 'ROM Quantity',
	            align: 'right'
	        }, {
	            dataIndex: 'FinesQuantitytIndex',
	            header: 'Fines Quantity',
	            align: 'right'
	        }, {
	            dataIndex: 'LumpsQuantitytIndex',
	            header: 'Lumps Quantity',
	            align: 'right'
	        }, {
	            dataIndex: 'TailingsQuantitytIndex',
	            header: 'Tailings Quantity',
	            align: 'right'
	        }, {
	            dataIndex: 'RejectsQuantitytIndex',
	            header: 'Rejects Quantity',
	            hidden: true,
	            align: 'right'
	        }, {
	            dataIndex: 'ConcentratesQuantitytIndex',
	            header: 'Concentrates Quantity',
	            align: 'right'
	        }, {
	            dataIndex: 'transportedROMIndex',
	            header: 'TRANSPORTED Rom',
	            align: 'right'
	        }, {
	            dataIndex: 'transportedFinesIndex',
	            header: 'TRANSPORTED Fines',
	            align: 'right'
	        }, {
	            dataIndex: 'transportedLumpsIndex',
	            header: 'TRANSPORTED Lumps',
	            align: 'right'
	        }, {
	            dataIndex: 'transportedTailingsIndex',
	            header: 'TRANSPORTED Tailings',
	            align: 'right'
	        }, {
	            dataIndex: 'transportedRejectsIndex',
	            header: 'TRANSPORTED Rejects',
	            hidden: true,
	            align: 'right'
	        }, {
	            dataIndex: 'transportedConcentratesIndex',
	            header: 'TRANSPORTED Concentrates',
	            align: 'right'
	        }];
        return new Ext.grid.ColumnModel({
            columns: columns.slice(start || 0, finish),
            defaults: {
                sortable: true
            }
        });
    };
    //---------------------------------------------------------grid-------------------------------------------//
	permitSummaryGrid = getGrid('Permit Summary Details', '<%=NoRecordsfound%>', store, screen.width - 40, 400, 18, filters, '<%=ClearFilterData%>', false, '', 20, false, '', false, '', true, '<%=Excel%>', jspName, exportDataType, false, 'PDF',false,'Add',false,'Modify',false,'',false,'',false,'Generate PDF');
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
        items: [permitSummaryGrid]
       
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
        var cm = grid.getColumnModel();
	    for (var j = 1; j < cm.getColumnCount(); j++) {
	        cm.setColumnWidth(j, 150);
	    }
    });
    
</script>
  </body>
</html>
<%}%>
