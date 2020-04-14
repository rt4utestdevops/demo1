<%@ page language="java"
	import="java.util.*,t4u.functions.*,t4u.beans.*,t4u.common.*"
	pageEncoding="utf-8"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://"+ request.getServerName() + ":" + request.getServerPort()+ path + "/";
	if(request.getParameter("list")!=null){
	String list=request.getParameter("list").toString().trim();
	String[] str=list.split(",");
	int systemid=Integer.parseInt(str[0].trim());
	int customerid=Integer.parseInt(str[1].trim());
	int userid=Integer.parseInt(str[2].trim());
	String language=str[3].trim();
	LoginInfoBean loginInfo=new LoginInfoBean();
	loginInfo.setSystemId(systemid);
	loginInfo.setCustomerId(customerid);
	loginInfo.setUserId(userid);
	loginInfo.setLanguage(language);
	loginInfo.setZone(str[4].trim());
	loginInfo.setOffsetMinutes(Integer.parseInt(str[5].trim()));
	loginInfo.setSystemName(str[6].trim());
	loginInfo.setCategory(str[7].trim());
	loginInfo.setStyleSheetOverride("N");
	if(str.length>8){
	loginInfo.setCustomerName(str[8].trim());
	}
	if(str.length>9){
	loginInfo.setCategoryType(str[9].trim());
	}
	if(str.length>10){
	loginInfo.setUserName(str[10].trim());
	}
	session.setAttribute("loginInfoDetails",loginInfo);
}
	
	CommonFunctions cf = new CommonFunctions();
	cf.checkLoginInfo((LoginInfoBean) session.getAttribute("loginInfoDetails"), session, request, response);
	String responseaftersubmit="''";
	String feature="1";
	if(session.getAttribute("responseaftersubmit")!=null){
	   responseaftersubmit="'"+session.getAttribute("responseaftersubmit").toString()+"'";
		session.setAttribute("responseaftersubmit",null);
	}
		
    LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
	String language = loginInfo.getLanguage();
	int systemId = loginInfo.getSystemId();
	int customerId = loginInfo.getCustomerId();
    int userId=loginInfo.getUserId();
String userAuthority=cf.getUserAuthority(systemId,userId);


	
ArrayList<String> tobeConverted = new ArrayList<String>();
  tobeConverted.add("Validate_Mesg_For_Form");
  tobeConverted.add("Select_Customer");
  tobeConverted.add("SLNO");
  tobeConverted.add("Customer_Name");
  tobeConverted.add("Start_Date");
  tobeConverted.add("End_Date");
  tobeConverted.add("Select_End_Date");
  tobeConverted.add("Date");
  tobeConverted.add("No_Records_Found");
  tobeConverted.add("Clear_Filter_Data");
  tobeConverted.add("Select_Start_Date");
  tobeConverted.add("End_Date_Must_Be_Greater_Than_Start_Date");
  tobeConverted.add("No_Records_Selected_Please_Select_Atleast_One_Record");
  tobeConverted.add("Generate_Report");
  tobeConverted.add("Excel");
  tobeConverted.add("Month_Validation");  
  tobeConverted.add("Select_Customer_Name");
  tobeConverted.add("No_Rows_Selected");
  tobeConverted.add("Select_Single_Row");
  tobeConverted.add("Modify");
  tobeConverted.add("Driver_Name");
  tobeConverted.add("Type");  
  tobeConverted.add("Select_Group_Name");  
  tobeConverted.add("Driver_Performance_Report");
  tobeConverted.add("Driver_Performance_Details");
  tobeConverted.add("Driver_List");
     
     
ArrayList<String> convertedWords = new ArrayList<String>();
 convertedWords = cf.getLanguageSpecificWordForKey(tobeConverted,language);
 String validateMessage = convertedWords.get(0);
 String SelectCustomer = convertedWords.get(1);
 String SLNO = convertedWords.get(2);
 String CustomerName = convertedWords.get(3);
 String StartDate = convertedWords.get(4);
 String EndDate = convertedWords.get(5);
 String SelectEndDate = convertedWords.get(6);
 String Date = convertedWords.get(7);
 String NoRecordsfound = convertedWords.get(8);
 String ClearFilterData = convertedWords.get(9);
 String SelectStartDate = convertedWords.get(10);
 String EndDateMustBeGreaterthanStartDate = convertedWords.get(11);
 String NoRecordsSelectedPleaseSelectatleastOneRecord = convertedWords.get(12);
 String GenerateReport = convertedWords.get(13);
 String Excel=convertedWords.get(14);
 String monthValidation=convertedWords.get(15);
 String SelectCustomerName = convertedWords.get(16);
 String NoRowsSelected = convertedWords.get(17);
 String SelectSingleRow=convertedWords.get(18);
 String Modify=convertedWords.get(19);
 String DriverName = convertedWords.get(20);
 String Type = convertedWords.get(21);
 String SelectGroupName=convertedWords.get(22);
 String DriverPerformanceReport = convertedWords.get(23);
 String DailyPerformanceReport=convertedWords.get(24);
 String DriverList = convertedWords.get(25);
%>

<jsp:include page="../Common/header.jsp" />



    <title>
        <%=DailyPerformanceReport%>
    </title>

<style>
    .x-panel-tl {
        border-bottom: 0px solid !important;
    }
</style>
<style type="text/css">
    .col {
        color: #0B0B61;
        font-family: sans-serif;
        font-size: 12px;
        width: 400;
    }
    white-row .x-grid3-cell-inner {
        background-color: #FFFFFF;
        font-style: italic;
        color: black;
    }
    .green-row .x-grid3-cell-inner {
        background-color: lightgreen;
        font-style: italic;
        color: black;
    }
    
    .red-row .x-grid3-cell-inner {
        background-color: #E55B3C;
        font-style: italic;
        color: black;
    }
    
    .yellow-row .x-grid3-cell-inner {
        background-color: #FDD017;
        font-style: italic;
        color: black;
    }
	
		label
		{
			display : inline !important;
		}		
		.x-window-tl *.x-window-header {
			padding-top : 6px !important;
		}
		.ext-strict .x-form-text {
			height: 21px !important;
		}
		.x-window-tl *.x-window-header {
			height : 30px !important;
		}
		.x-layer ul {
		 	min-height: 27px !important;
		}		
		.x-menu-list {
			height: auto !important;
		}
	
</style>



    <%if (loginInfo.getStyleSheetOverride().equals("Y")){%>
        <jsp:include page="../Common/ImportJSSandMining.jsp" />
        <%}else {%>
            <jsp:include page="../Common/ImportJS.jsp" />
            <%} %>
                <jsp:include page="../Common/ExportJsForDriver.jsp" />
                <script>
                    <!--
                    var outerPanel;
					window.onload = function () { 
						refresh();
					}
                    function refresh() {
                        isChrome = window.chrome;
                        if (isChrome && parent.flagASSET < 2) {
                            setTimeout(
                                function() {
                                }, 0);
                            parent.UtilizationTab.doLayout();
                            parent.flagASSET = parent.flagASSET + 1;
                        }
                    }
                    /********************resize window event function***********************/
                    Ext.EventManager.onWindowResize(function() {
                        var width = '99%';
                        var height = '100%';
                        grid.setSize(width, height);
                        outerPanel.setSize(width, height);
                        outerPanel.doLayout();
                    });
                    var manageAllTasksGrid;
                    var dtprev = dateprev;
                    var dtcur = datecur;
                    var jspName = "DriverPerformanceReport";
                    var exportDataType = "int,int,string,date,float,float,float,float,float,float,float,float,float,float,float";
                    var json = "";
                    var titelForInnerPanel = "Summary Details";
                    var gridData = "";
                    var groid = "";

                    var dt7 = new Date().add(Date.DAY, -7);
                    var dt30 = new Date().add(Date.MONTH, -1);

                    function DateCompare3(startDate, endDate) {

                        var startddindex = startDate.indexOf('/');
                        var startdd = startDate.substring(0, startddindex);

                        var startmmindex = startDate.lastIndexOf('/');
                        var startmm = startDate.substring(startddindex + 1, startmmindex);
                        var startyear = startDate.substring(startmmindex + 1, startDate.length);

                        var endddindex = endDate.indexOf('/');
                        var enddd = endDate.substring(0, endddindex);

                        var endmmindex = endDate.lastIndexOf('/');

                        var endmm = endDate.substring(endddindex + 1, endmmindex);
                        var endyear = endDate.substring(endmmindex + 1, endDate.length);
                        var date1 = new Date(startmm + "/" + startdd + "/" + startyear);
                        var date2 = new Date(endmm + "/" + enddd + "/" + endyear);
                        if (date1 <= date2) {
                            return true;
                        } else {
                            return false;
                        }
                    }

                    var groupnamestore = new Ext.data.JsonStore({
                        url: '<%=request.getContextPath()%>/drivarPerformanceAction.do?param=getGroupNames',
                        root: 'GroupStoreList',
                        fields: ['groupId', 'groupName']
                    });

                    var driverStore = new Ext.data.JsonStore({
                        url: '<%=request.getContextPath()%>/drivarPerformanceAction.do?param=getDriversGroups',
                        id: 'assetTypeId',
                        root: 'assetTypeRoot',
                        autoload: false,
                        remoteSort: true,
                        fields: ['driverId', 'driverName'],
                        listeners: {
                            load: function() {}
                        }

                    });

                    var customercombostore = new Ext.data.JsonStore({
                        url: '<%=request.getContextPath()%>/CommonAction.do?param=getCustomer',
                        id: 'CustomerStoreId',
                        root: 'CustomerRoot',
                        autoLoad: true,
                        remoteSort: true,
                        fields: ['CustId', 'CustName'],

                        listeners: {
                            load: function(custstore, records, success, options) {
                                if (<%= customerId %> > 0) {
                                    Ext.getCmp('custcomboId').setValue('<%=customerId%>');
                                    custId = Ext.getCmp('custcomboId').getValue();
                                    custName = Ext.getCmp('custcomboId').getRawValue();
                                    driverStore.load({
                                        params: {
                                            CustId: custId
                                        }
                                    });
                                }
                                globalAssetNumber = "";
                                custId = Ext.getCmp('custcomboId').getValue();
                                custName = Ext.getCmp('custcomboId').getRawValue();
                                var globalGroupId = Ext.getCmp('TypeId').getValue();
                                groupnamestore.load({
                                    params: {
                                        CustId: custId
                                    }
                                });

                                firstGridStore.reload({
                                    params: {
                                        CustId: custId,
                                        CustName: custName
                                    }
                                });

                                store.load();
                                if (<%= customerId %> > 0) {
                                    Ext.getCmp('custcomboId').setValue('<%=customerId%>');
                                    custId = Ext.getCmp('custcomboId').getValue();
                                    custName = Ext.getCmp('custcomboId').getRawValue();
                                    var globalGroupId = Ext.getCmp('TypeId').getValue()
                                    firstGridStore.load({
                                        params: {
                                            CustId: custId,
                                            CustName: custName
                                        }
                                    });
                                    groupnamestore.load({
                                        params: {
                                            CustId: custId
                                        }
                                    });
                                    store.load();
                                }
                            }
                        }
                    });

                    var arrayStore = [
                        ['Daily'],
                        ['Weekly'],
                        ['Monthly']
                    ];
                    var TypeStore = new Ext.data.SimpleStore({
                        data: arrayStore,
                        fields: ['name']
                    });

                    var Typecombo = new Ext.form.ComboBox({
                        fieldLabel: '',
                         cls: 'labelstyle',
                        store: TypeStore,
                        labelWidth: 60,
                        id: 'TypeId',
                        width: 100,
                        forceSelection: true,
                        enableKeyEvents: true,
                        mode: 'local',
                        anyMatch: true,
                        onTypeAhead: true,
                        triggerAction: 'all',
                        value: 'Daily',
                        displayField: 'name',
                        valueField: 'name',
                        emptyText: '',
                        listeners: {
                            select: {

                                fn: function() {
                                    var type = Ext.getCmp('TypeId').getValue();
                                    Ext.getCmp('enddate').setDisabled(true);
                                    if (type == 'Daily') {
                                        Ext.getCmp('enddate').setDisabled(false);
                                        Ext.getCmp('startdate').setValue(dtprev);
                                        Ext.getCmp('enddate').setValue(datecur);
                                        grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('startDate'), false);
                                    } else if (type == 'Weekly') {
                                        Ext.getCmp('startdate').setValue(dt7);
                                        Ext.getCmp('enddate').setValue(datecur);
                                        grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('startDate'), true);
                                    } else if (type == 'Monthly') {
                                        Ext.getCmp('startdate').setValue(dt30);
                                        Ext.getCmp('enddate').setValue(datecur);
                                        grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('startDate'), true);
                                    }
                                    store.load();
                                }
                            }
                        }
                    });

                    var custnamecombo = new Ext.form.ComboBox({
                        store: customercombostore,
                        id: 'custcomboId',
                        mode: 'local',
                        forceSelection: true,
                        emptyText: '<%=SelectCustomer%>',
                        selectOnFocus: true,
                        allowBlank: false,
                        anyMatch: true,
                        typeAhead: false,
                        triggerAction: 'all',
                        lazyRender: true,
                        valueField: 'CustId',
                        displayField: 'CustName',
                        cls: 'selectstyle',
                        listeners: {
                            select: {
                                fn: function() {
                                    globalAssetNumber = "";
                                    custId = Ext.getCmp('custcomboId').getValue();
                                    custName = Ext.getCmp('custcomboId').getRawValue();
                                    var globalGroupId = Ext.getCmp('TypeId').getValue();
                                    groupnamestore.load({
                                        params: {
                                            CustId: custId
                                        }
                                    });

                                    firstGridStore.reload({
                                        params: {
                                            CustId: custId,
                                            CustName: custName
                                        }
                                    });

                                    store.load();
                                    if (<%= customerId %> > 0) {
                                        Ext.getCmp('custcomboId').setValue('<%=customerId%>');
                                        custId = Ext.getCmp('custcomboId').getValue();
                                        custName = Ext.getCmp('custcomboId').getRawValue();
                                        var globalGroupId = Ext.getCmp('TypeId').getValue()
                                        firstGridStore.load({
                                            params: {
                                                CustId: custId,
                                                CustName: custName
                                            }
                                        });
                                        groupnamestore.load({
                                            params: {
                                                CustId: custId
                                            }
                                        });
                                        store.load();
                                    }
                                }
                            }
                        }
                    });

                    var sm1 = new Ext.grid.CheckboxSelectionModel({
                        checkOnly: true
                    });

                    var cols1 = new Ext.grid.ColumnModel([

                        new Ext.grid.RowNumberer({
                            header: "<span style=font-weight:bold;><%=SLNO%></span>",
                            width: 40
                        }), sm1, {
                            header: '<b><%=DriverName%></b>',
                            width: 155,
                            sortable: true,
                            dataIndex: 'driverName'
                        }


                    ]);

                    var reader1 = new Ext.data.JsonReader({
                        root: 'driverGridRoot',
                        fields: [{
                            name: 'driverId'
                        }, {
                            name: 'driverName',
                            type: 'string'
                        }]
                    });

                    var filters1 = new Ext.ux.grid.GridFilters({
                        local: true,
                        filters: [{
                                dataIndex: 'driverId',
                                type: 'string'
                            }, {
                                dataIndex: 'driverName',
                                type: 'string'
                            }

                        ]
                    });

                    var firstGridStore = new Ext.data.Store({
                        url: '<%=request.getContextPath()%>/drivarPerformanceAction.do?param=getDriversGroups',
                        bufferSize: 367,
                        reader: reader1,
                        autoLoad: false,
                        remoteSort: true
                    });

                    var firstGrid = getSelectionModelGrid('<%=DriverList%>', '<%=NoRecordsfound%>', firstGridStore, 250, 390, cols1, 4, filters1, sm1);


                    var clientPanel = new Ext.Panel({
                        standardSubmit: true,
                        collapsible: false,
                        id: 'traderMaster',
                        layout: 'table',
                        frame: false,
                        width: screen.width - 32,
                        height: 70,
                        layoutConfig: {
                            columns: 9
                        },
                        items: [{
                                xtype: 'label',
                                text: '<%=CustomerName%>' + ' :',
                                cls: 'labelstyle',
                                id: 'custnamelab'
                            },
                            custnamecombo, {
                                width: 10
                            }, {

                                xtype: 'label',
                                text: 'Group Name' +' : ',
                                width: 185,
                                cls: 'labelstyle',
                                id: 'GroupName_Id'
                            }, {
                                xtype: 'combo',
                                width: 160,
                                cls: 'labelstyle',
                                store: groupnamestore,
                                displayField: 'groupName',
                                valueField: 'groupId',
                                mode: 'local',
                                forceSelection: true,
                                resizable: true,
                                triggerAction: 'all',
                                anyMatch: true,
                                onTypeAhead: true,
                                selectOnFocus: true,
                                emptyText: 'Select Group Name',
                                labelSeparator: '',
                                id: 'GroupNameId',
                                name: 'group',
                                loadingText: 'Searching...',
                                enableKeyEvents: true,
                                minChars: 2,
                                listeners: {
                                    select: {
                                        fn: function() {
                                                globalGroupId = Ext.getCmp('GroupNameId').getValue();
                                                globalClientId = Ext.getCmp('custcomboId').getValue();
                                                firstGridStore.load({
                                                    params: {
                                                        clientId: globalClientId,
                                                        groupId: globalGroupId
                                                    }
                                                });
                                                store.load();
                                            } // End of Function
                                    } // END OF SELECT
                                } // END OF LISTENERS		
                            }, {
                                width: 100
                            }, {
                                xtype: 'label',
                                text: '<%=Type%>' + ' : ',
                                cls: 'labelstyle',
                                id: 'assetTypelab'
                            },
                            Typecombo, {
                                width: 5
                            }, {
                                xtype: 'label',
                                cls: 'labelstyle',
                                id: 'startdatelab',
                                text: '<%=StartDate%>' + ' : '
                            }, {
                                xtype: 'datefield',
                                cls: 'selectstyle',
                                width: 185,
                                format: getDateFormat(),
                                emptyText: 'SelectStartDate',
                                allowBlank: false,
                                blankText: 'SelectStartDate',
                                id: 'startdate',
                                value: dtprev,
                                endDateField: 'enddate',
                                listeners: {
                                    change: function(field, oldValue) {
                                        var type = Ext.getCmp('TypeId').getValue();

                                        if (type == "") {
                                            Ext.example.msg("please select TYPE");
                                        } else if (type == 'Daily') {
					 var ss= Ext.getCmp('startdate').getValue();
                	  var end =Ext.getCmp('enddate').getValue();
                	  if(end!="" && ss!=""){
                	   var ddyy = new Date(ss)
                	   var datecur1 =new Date(datecur);
                	   var datecur2 =new Date(end);
                	   var message="";
									if (DateCompare3(ddyy.toString(),datecur2.toString()) == false){
									  message = "End Date Time should not be less than start date.";
									}
									if(message != ""){
										 Ext.example.msg(message);
										//showAlertMessage(message);
										Ext.getCmp('startdate').setValue("");
										Ext.getCmp('startdate').focus();
										return;
									}	
									}
									else{
									Ext.example.msg("Select Start Date ");
										Ext.getCmp('enddate').focus();
									}
					} else if (type == 'Weekly') {
                                            var ss = Ext.getCmp('startdate').getValue();
                                            Ext.getCmp('enddate').setDisabled(true);
                                            var ddyy = new Date(ss).add(Date.DAY, 7);
                                            var datecur1 = new Date(datecur);

                                            var message = "";
                                            if (DateCompare3(ddyy.toString(), datecur1.toString()) == false) {
                                                message = "End Date Time should not be greater than Todays date.";
                                            }
                                            if (message != "") {
                                                Ext.example.msg(message);
                                                Ext.getCmp('startdate').setValue("");
                                                Ext.getCmp('startdate').focus();
                                                return;
                                            }
                                            Ext.getCmp('enddate').setValue(ddyy);
                                        } else if (type == 'Monthly') {
                                            var ss = Ext.getCmp('startdate').getValue();
                                            Ext.getCmp('enddate').setDisabled(true);
                                            var ddyy = new Date(ss).add(Date.MONTH, 1);
                                            var datecur1 = new Date(datecur);
                                            var message = "";
                                            if (DateCompare3(ddyy.toString(), datecur1.toString()) == false) {
                                                message = "End Date Time should not be greater than Todays date.";
                                            }
                                            if (message != "") {
                                                Ext.example.msg(message);
                                                Ext.getCmp('startdate').setValue("");
                                                Ext.getCmp('startdate').focus();
                                                return;
                                            }
                                            Ext.getCmp('enddate').setValue(ddyy);
                                        }
                                    }
                                }
                            }, {
                                width: 80
                            }, {
                                xtype: 'label',
                                cls: 'labelstyle',
                                id: 'enddatelab',
                                text: '<%=EndDate%>' + ' : '
                            }, {
                                xtype: 'datefield',
                                cls: 'selectstyle',
                                width: 185,
                                format: getDateFormat(),
                                emptyText: '<%=SelectEndDate%>',
                                allowBlank: false,
                                blankText: '<%=SelectEndDate%>',
                                id: 'enddate',
                                value: datecur,
                                startDateField: 'startdate',
                                listeners: {
                                    change: function(field, oldValue) {
                	  var end =Ext.getCmp('enddate').getValue();
                	    if(end!=""){
                	   var datecur1 =new Date(datecur);
                	   var datecur2 =new Date(end);
                	   var message="";
									if(DateCompare3(datecur2.toString(),datecur1.toString()) == false){
									  message = "End Date Time should not be greater than Todays date.";
									}
									if(message != ""){
										 Ext.example.msg(message);
										Ext.getCmp('startdate').setValue("");
										Ext.getCmp('startdate').focus();
										return;
									}	
									}else{
									 
									    Ext.example.msg("Select End Date");
										Ext.getCmp('enddate').focus();
									}
					
			}
                                }
                            }
                        ]
                    });

                    var reader = new Ext.data.JsonReader({
                        idProperty: 'tripcreationId',
                        root: 'DriverPerformanceRoot',
                        totalProperty: 'total',
                        fields: [{
                            name: 'slnoIndex1'
                        }, {
                            name: 'rowid'
                        }, {
                            name: 'driverName'
                        }, {
                            name: 'startDate'
                        }, {
                            name: 'distanceTravelled'
                        }, {
                            name: 'durationingr'
                        }, {
                            name: 'durationinbt'
                        }, {
                            name: 'totaloverspeed'
                        }, {
                            name: 'overspeedscore'
                        }, {
                            name: 'acclcount'
                        }, {
                            name: 'acclcountscore'
                        }, {
                            name: 'declcount'
                        }, {
                            name: 'declcountscore'
                        }, {
                            name: 'totalscore',
                            type: 'float'
                        }, {
                            name: 'maxspeed'
                        }]
                    });

                    var store = new Ext.data.GroupingStore({
                        autoLoad: false,
                        proxy: new Ext.data.HttpProxy({
                            url: '<%=request.getContextPath()%>/drivarPerformanceAction.do?param=generateReportPDO',
                            method: 'POST'
                        }),
                        remoteSort: false,
                        sortInfo: {
                            field: 'totalscore',
                            direction: 'DESC'
                        },
                        storeId: 'driverPerformancereport',
                        reader: reader
                    });

                    var filters = new Ext.ux.grid.GridFilters({
                        local: true,
                        filters: [{
                            type: 'numeric',
                            dataIndex: 'slnoIndex1'
                        }, {
                            type: 'numeric',
                            dataIndex: 'rowid'
                        }, {
                            type: 'string',
                            dataIndex: 'driverName'
                        }, {
                            type: 'date',
                            dataIndex: 'startDate'
                        }, {
                            type: 'numeric',
                            dataIndex: 'distanceTravelled'
                        }, {
                            type: 'numeric',
                            dataIndex: 'durationingr'
                        }, {
                            type: 'numeric',
                            dataIndex: 'durationinbt'
                        }, {
                            type: 'numeric',
                            dataIndex: 'totaloverspeed'
                        }, {
                            type: 'numeric',
                            dataIndex: 'overspeedscore'
                        }, {
                            type: 'numeric',
                            dataIndex: 'maxspeed'
                        }, {
                            type: 'numeric',
                            dataIndex: 'acclcount'
                        }, {
                            type: 'numeric',
                            dataIndex: 'acclcountscore'
                        }, {
                            type: 'numeric',
                            dataIndex: 'declcount'
                        }, {
                            type: 'numeric',
                            dataIndex: 'declcountscore'
                        }, {
                            type: 'numeric',
                            dataIndex: 'totalscore'
                        }]
                    });

                    var createColModel = function(finish, start) {

                        var columns = [
                            new Ext.grid.RowNumberer({
                                header: "<span style=font-weight:bold;><%=SLNO%></span>",
                                width: 50
                            }), {
                                dataIndex: 'slnoIndex1',
                                hidden: true,
                                header: "<span style=font-weight:bold;><%=SLNO%></span>",
                                filter: {
                                    type: 'numeric'
                                }
                            }, {
                                header: "<span style=font-weight:bold;>ROW ID</span>",
                                dataIndex: 'rowid',
                                hidden: true,
                                width: 50,
                                filter: {
                                    type: 'numeric'
                                }
                            }, {
                                header: "<span style=font-weight:bold;>DRIVER NAME</span>",
                                dataIndex: 'driverName',
                                width: 50,
                                filter: {
                                    type: 'String'
                                }
                            }, {
                                header: "<span style=font-weight:bold;>START DATE</span>",
                                dataIndex: 'startDate',
                                renderer: Ext.util.Format.dateRenderer(getDateFormat()),
                                width: 50,
                                filter: {
                                    type: 'Date'
                                }
                            }, {
                                header: "<span style=font-weight:bold;>DISTANCE DRIVEN(kms)</span>",
                                dataIndex: 'distanceTravelled',
                                hidden: false,
                                width: 50,
                                filter: {
                                    type: 'numeric'
                                }
                            }, {
                                header: "<span style=font-weight:bold;>OVERSPEED DURATION IN GRADED ROADS(secs)</span>",
                                dataIndex: 'durationingr',
                                decimalPrecision: 2,
                                hidden : true,
                                width: 70,
                                filter: {
                                    type: 'numeric'
                                }
                            }, {
                                header: "<span style=font-weight:bold;>OVERSPEED DURATION IN BLACKTOP ROADS(secs)</span>",
                                dataIndex: 'durationinbt',
                                decimalPrecision: 2,
                                hidden : true,
                                width: 70,
                                filter: {
                                    type: 'numeric'
                                }
                            }, {
                                header: "<span style=font-weight:bold;>TOTAL OVERSPEED DURATION(secs)</span>",
                                dataIndex: 'totaloverspeed',
                                hidden: false,
                                width: 70,
                                filter: {
                                    type: 'numeric'
                                }
                            }, {
                                header: "<span style=font-weight:bold;>OVERSPEED SCORE(/100kms)</span>",
                                dataIndex: 'overspeedscore',
                                hidden: false,
                                width: 50,
                                filter: {
                                    type: 'numeric'
                                }
                            }, {
                                header: "<span style=font-weight:bold;>MAX SPEED(kms/hr)</span>",
                                dataIndex: 'maxspeed',
                                hidden: false,
                                width: 50,
                                filter: {
                                    type: 'numeric'
                                }
                            }, {
                                header: "<span style=font-weight:bold;>HARSH ACCL COUNT</span>",
                                dataIndex: 'acclcount',
                                hidden: false,
                                width: 50,
                                filter: {
                                    type: 'numeric'
                                }
                            }, {
                                header: "<span style=font-weight:bold;>HARSH ACCL SCORE(/100kms)</span>",
                                dataIndex: 'acclcountscore',
                                hidden: false,
                                width: 50,
                                filter: {
                                    type: 'numeric'
                                }
                            }, {
                                header: "<span style=font-weight:bold;>HARSH BRAKING COUNT</span>",
                                dataIndex: 'declcount',
                                hidden: false,
                                width: 50,
                                filter: {
                                    type: 'numeric'
                                }
                            }, {
                                header: "<span style=font-weight:bold;>HARSH BRAKING SCORE(/100kms)</span>",
                                dataIndex: 'declcountscore',
                                hidden: false,
                                width: 50,
                                filter: {
                                    type: 'numeric'
                                }
                            }, {
                                header: "<span style=font-weight:bold;>RAG</span>",
                                dataIndex: 'totalscore',
                                hidden: false,
                                width: 50,
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
                    var notePanel = new Ext.Panel({
                        standardSubmit: true,
                        id: 'notePanelID',
                        hidden: false,
                        collapsible: false,
                        items: [{
                            html: "<div >Note:</div>",
                            style: 'font-weight:bold;font-size:14px;',
                            cellCls: 'bskExtStyle'
                        }, {
                            html: "<table><TR><TD></TD><TD class=col>** The result is based on GMT time. </TD></TR><tr><td></td><td class=col><img src='<%=request.getContextPath()%>/Main/images/Drlegend_green.png' width='35px' height='15px' />&nbsp;Total Score is less than 2</td></tr> <tr><td></td><td class=col><img src='<%=request.getContextPath()%>/Main/images/Drlegend_yellow.png' width='35px' height='15px' />&nbsp;Total Score is in the range 2 to 5</td></tr><tr><td></td><td class=col><img src='<%=request.getContextPath()%>/Main/images/Drlegend_red.png' width='35px' height='15px'/>&nbsp;Total Score greater than 5 </td></tr></table>",
                            style: 'font-size:12px;',
                            cellCls: 'bskExtStyle'
                        }]
                    });
                    grid = getGrid('<%=DailyPerformanceReport%>', '<%=NoRecordsfound%>', store, screen.width - 285, 300, 16, filters, '<%=ClearFilterData%>', false, '', 14, false, '', false, '', true, '<%=Excel%>', jspName, exportDataType, true, 'PDF', false, 'Add');

                    grid.getView().getRowClass = function(record, index) {

                        var score = record.data.totalscore;
                        var distanceDriven = record.data.distanceTravelled;
                        if(parseInt(distanceDriven) == 0){
                        	rowcolour = 'white-row';
                        }else if (parseInt(score) < 2) {
                            rowcolour = 'green-row';
                        } else if (parseInt(score) >= 2 && parseInt(score) < 5) {
                            rowcolour = 'yellow-row';
                        } else if (parseInt(score) >= 5) {
                            rowcolour = 'red-row';
                        }

                        return rowcolour
                    };

                    var secondGridPanel = new Ext.Panel({
                        standardSubmit: true,
                        collapsible: false,
                        id: 'secondPanelId',
                        layout: 'table',
                        frame: true,
                        width: 1100,
                        height: 410,
                        layoutConfig: {
                            columns: 1
                        },
                        items: [grid, notePanel]

                    });

                    var manageAllTasksPanel = new Ext.Panel({
                        standardSubmit: true,
                        collapsible: false,
                        id: 'vesselPanelId',
                        layout: 'table',
                        frame: false,
                        width: '100%',
                        height: 400,
                        layoutConfig: {
                            columns: 2
                        },
                        items: [firstGrid, secondGridPanel]

                    });

                    var allButtonsPannel = new Ext.Panel({
                        standardSubmit: true,
                        collapsibli: false,
                        id: 'buttonpannelid',
                        layout: 'table',
                        frame: false,
                        width: 180,
                        height: 30,
                        layoutConfig: {
                            columns: 3
                        },
                        items: [{
                            width: 80
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
                                        if (Ext.getCmp('GroupNameId').getValue() == "") {
                                            Ext.example.msg("<%=SelectGroupName%>");
                                            Ext.getCmp('GroupNameId').focus();
                                            return;
                                        }
                                       
                                        if (Ext.getCmp('startdate').getValue() == "") {
                                            Ext.example.msg("<%=SelectStartDate%>");
                                            Ext.getCmp('startdate').focus();
                                            return;
                                        }
                                        if (Ext.getCmp('enddate').getValue() == "") {
                                            Ext.example.msg("<%=SelectEndDate%>");
                                            Ext.getCmp('enddate').focus();
                                            return;
                                        }
                                        if (dateCompare(Ext.getCmp('startdate').getValue(), Ext.getCmp('enddate').getValue()) == -1) {
                                            Ext.example.msg("<%=EndDateMustBeGreaterthanStartDate%>");
                                            Ext.getCmp('enddate').focus();
                                            return;
                                        }
                                        if (checkMonthValidation(Ext.getCmp('startdate').getValue(), Ext.getCmp('enddate').getValue())) {
                                            Ext.example.msg("<%=monthValidation%>");
                                            Ext.getCmp('enddate').focus();
                                            return;
                                        }
                                        var startDate = Ext.getCmp('startdate').getValue();
                                        var type = Ext.getCmp('TypeId').getValue();
                                        var endDate = Ext.getCmp('enddate').getValue();
                                        var assetType = Ext.getCmp('TypeId').getValue();
                                        var Groupname = Ext.getCmp('GroupNameId').getRawValue();
                                        var selectedDriverIds = "";
                                        var records = firstGrid.getSelectionModel().getSelections();
                                        for (var i = 0; i < records.length; i++) {
                                            var recordrem = records[i];
                                            var driverId = recordrem.data['driverId'];
                                            selectedDriverIds = selectedDriverIds + "||" + driverId
                                        }
                                        if (firstGrid.getSelectionModel().getCount() == 0) {
                                            Ext.example.msg("<%=NoRecordsSelectedPleaseSelectatleastOneRecord%>");
                                            return;
                                        }
                                        store.load({
                                            params: {
                                                CustId: custId,
                                                custName: Ext.getCmp('custcomboId').getRawValue(),
                                                AssetType: assetType,
                                                StartDate: startDate,
                                                EndDate: endDate,
                                                gridData: selectedDriverIds,
                                                jspName: jspName,
                                                groid: globalGroupId,
                                                groupName: Groupname,
                                                type: type
                                            }
                                        });

                                    }
                                }
                            }
                        }, {
                            width: 10
                        }]
                    });

                    Ext.onReady(function() {
                        ctsb = tsb;
                        Ext.QuickTips.init();
                        Ext.form.Field.prototype.msgTarget = 'side';
                        outerPanel = new Ext.Panel({
                            title: 'Driver Performance Report',
                            renderTo: 'content',
                            standardSubmit: true,
                            frame: true,
                            width: screen.width - 15,
                            height: 550,
                            cls: 'outerpanel',
                            layout: 'table',
                            layoutConfig: {
                                columns: 1
                            },
                            items: [clientPanel, manageAllTasksPanel, allButtonsPannel]
                        });
                        sb = Ext.getCmp('form-statusbar');
                    });
                    -->
                </script>
<jsp:include page="../Common/footer.jsp" />
 <!-- </body>   -->
 <!-- </html> -->