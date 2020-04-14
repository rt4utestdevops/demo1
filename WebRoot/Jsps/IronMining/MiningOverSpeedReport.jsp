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
		     
		 ArrayList<String> tobeConverted = new ArrayList<String>();
			 tobeConverted.add("SLNO");
			 tobeConverted.add("Mining_Over_Speed_Report");
			 tobeConverted.add("Select_Customer");
			 tobeConverted.add("Select_Asset_Group");
			 tobeConverted.add("Customer_Name");
			 tobeConverted.add("Asset_Group");
			 tobeConverted.add("Start_Date");
			 tobeConverted.add("End_Date");
			 tobeConverted.add("View");
			 tobeConverted.add("Select_Start_Date");
			 tobeConverted.add("Select_End_Date");
			 tobeConverted.add("End_Date_Must_Be_Greater_Than_Start_Date");
			 tobeConverted.add("Month_Validation");
			 tobeConverted.add("Asset_Number");
			 tobeConverted.add("Group_Name");
			 tobeConverted.add("Date");
			 tobeConverted.add("GPS_DATE_TIME");
			 tobeConverted.add("GMT");
			 tobeConverted.add("Latitude");
			 tobeConverted.add("Longitude");
			 tobeConverted.add("Location");
			 tobeConverted.add("Speed");
			 tobeConverted.add("OS_LIMIT");
			 tobeConverted.add("No_Records_Found");
			 tobeConverted.add("Clear_Filter_Data");
			 tobeConverted.add("Excel");
			 tobeConverted.add("Trip_Sheet_No");
		
	ArrayList<String> convertedWords = new ArrayList<String>();
            convertedWords = cf.getLanguageSpecificWordForKey(tobeConverted,language);
			String SLNO =convertedWords.get(0);
		    String miningOverSpeedReport =convertedWords.get(1);
		    String selectCustomer = convertedWords.get(2);
		    String selectAssetGroup =convertedWords.get(3);
		    String customerName=convertedWords.get(4);
		    String assetGroup =convertedWords.get(5);
		    String startDate =convertedWords.get(6);
			String endDate = convertedWords.get(7);
			String view =convertedWords.get(8);
			String selectStartDate =convertedWords.get(9);
			String selectEndDate =convertedWords.get(10);
			String endDateMustBeGreaterthanStartDate =convertedWords.get(11);
			String monthValidation=convertedWords.get(12);
			String assetNumber =convertedWords.get(13);
			String groupName =convertedWords.get(14);
			String date =convertedWords.get(15);
			String gpsDateTime=convertedWords.get(16);
			String gmt=convertedWords.get(17);
			String latitude=convertedWords.get(18);
			String longitude=convertedWords.get(19);
			String location=convertedWords.get(20);
			String speed=convertedWords.get(21);
			String osLimit=convertedWords.get(22);
			String NoRecordsfound=convertedWords.get(23);
			String ClearFilterData =convertedWords.get(24);
		    String Excel=convertedWords.get(25);
		    String TripSheetNumber=convertedWords.get(26);
%>

<jsp:include page="../Common/header.jsp" />
    <base href="<%=basePath%>">
    <title>Mining OverSpeed Report</title>
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
				.x-btn-text clearfilterbutton{font-family: 'Helvetica', sans-serif;
				                                                  font-size: 12px !important;
				}
	</style>

  <%if (loginInfo.getStyleSheetOverride().equals("Y")){%>
       <jsp:include page="../Common/ImportJSSandMining.jsp"/>
		<%}else {%>
		<jsp:include page="../Common/ImportJS.jsp" />
		<%} %>
		 <jsp:include page="../Common/ExportJS.jsp" />
		 <% String newMenuStyle=loginInfo.getNewMenuStyle();
			if(newMenuStyle.equalsIgnoreCase("YES")){%>
			<style>
				.ext-strict .x-form-text {
					height: 21px !important;
				}
				label {
					display : inline !important;
				}
				.x-window-tl *.x-window-header {
					padding-top : 6px !important;
					height : 38px !important;
				}
				.x-layer ul {
					min-height: 27px !important;
				}					
				.x-menu-list {
					height: auto !important;
				}
				
			</style>
		<%}%>
 <script>
 //--------------------date validation----------------------------------------------//
 function dateCompare(fromDate, toDate) {
	
	if(fromDate < toDate) {
		return 1;
	} else if(toDate < fromDate) {
		return -1;
	}
	return 0;
}
//---------------------------------------------------------------------------------------//
    //-------------------------------------------------------------------------------//
    var outerPanel;
    var jspName = "MiningOverSpeedReport";
    var exportDataType = "int,string,string,date,date,date,string,string,string,string,number,number";
    var dtprev = dateprev;
    var dtcur = datecur;
    var json = "";
    var startDate = "";
    var endDate = "";
    var tripGrid;

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
                    groupStore.load({
                        params: {
                            CustId: custId
                        }
                    });
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
        emptyText: '<%=selectCustomer%>',
        resizable: true,
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
                    custId = Ext.getCmp('custcomboId').getValue();
                    custName = Ext.getCmp('custcomboId').getRawValue();
                    groupStore.load({
                        params: {
                            CustId: custId
                        }
                    });
                    store.load();
                    if ( <%= customerId %> > 0) {
                        Ext.getCmp('custcomboId').setValue('<%=customerId%>');
                        custId = Ext.getCmp('custcomboId').getValue();
                        custName = Ext.getCmp('custcomboId').getRawValue();
                        groupStore.load({
                            params: {
                                CustId: custId
                            }
                        });
                    }
                    Ext.getCmp('groupNameComboId').reset();
                    store.load();
                }
            }
        }
    });

    var groupStore = new Ext.data.JsonStore({
        url: '<%=request.getContextPath()%>/TripSheetReportAction.do?param=getGroups',
        id: 'groupId',
        root: 'groupNameList',
        autoLoad: false,
        remoteSort: true,
        fields: ['groupId', 'groupName']
    });

    var groupNameCombo = new Ext.form.ComboBox({
        fieldLabel: '',
        store: groupStore,
        id: 'groupNameComboId',
        // width: 150,
        emptyText: '<%=selectAssetGroup%>',
        blankText: '<%=selectAssetGroup%>',
        // labelWidth: 100,
        resizable: true,
        hidden: false,
        forceSelection: true,
        enableKeyEvents: true,
        mode: 'local',
        triggerAction: 'all',
        displayField: 'groupName',
        valueField: 'groupId',
        loadingText: 'Searching...',
        cls: 'selectstyle',
        minChars: 3,
        listeners: {
            select: {
                fn: function() {
                    CustId = Ext.getCmp('custcomboId').getValue();
                    groupId = Ext.getCmp('groupNameComboId').getValue();
					
                    if (Ext.getCmp('groupNameComboId').getValue() == 0) {
                        tripGrid.getColumnModel().setHidden(tripGrid.getColumnModel().findColumnIndex('GroupNameDataIndex'), false);
	                    var cm = tripGrid.getColumnModel();  
					    for (var j = 1; j < cm.getColumnCount(); j++) {
					       cm.setColumnWidth(j,150);
					    }
                    } else {
                        tripGrid.getColumnModel().setHidden(tripGrid.getColumnModel().findColumnIndex('GroupNameDataIndex'), true);
                         var cm = tripGrid.getColumnModel();  
					    for (var j = 1; j < cm.getColumnCount(); j++) {
					       cm.setColumnWidth(j,150);
					    }
                    }
                     store.load();
                }
            }
        }
    });

    //-------------------------------------------------------------------------------------------------------//
    var clientPanel = new Ext.Panel({
        standardSubmit: true,
        collapsible: false,
        id: 'traderMaster',
        layout: 'table',
        frame: true,
        width: screen.width - 20,
        height: 75,
        layoutConfig: {
            columns: 10
        },
        items: [{
                xtype: 'label',
                text: '<%=customerName%>' + ' :',
                cls: 'labelstyle',
                id: 'custnamelab'
            },
            custnamecombo, {
                width: 30
            }, {
                xtype: 'label',
                text: '<%=assetGroup%>' + ' :',
                cls: 'labelstyle',
                id: 'assetGrouplab'
            },
            groupNameCombo, {
                width: 30
            },{
                width: 50
            },{
                width: 50
            },{
                width: 50
            },{
                width: 50
            },
            {
                xtype: 'label',
                cls: 'labelstyle',
                id: 'startdatelab',
                text: '<%=startDate%>' + ' :'
            }, {
                xtype: 'datefield',
                cls: 'selectstyle',
                width: 185,
                format: getDateFormat(),
                emptyText: '<%=selectStartDate%>',
                allowBlank: false,
                blankText: '<%=selectStartDate%>',
                id: 'startdate',
                value: datecur,//dtprev,
                endDateField: 'enddate'
            }, {
                width: 50
            }, {
                width: 50
            }, {
                xtype: 'button',
                text: '<%=view%>',
                id: 'viewReport',
                cls: 'buttonwastemanagement',
                width: 100,
                listeners: {
                    click: {
                        fn: function() {
                            if (Ext.getCmp('custcomboId').getValue() == "") {
							    Ext.example.msg("<%=selectCustomer%>");
                                Ext.getCmp('custcomboId').focus();
                                return;
                            }
                            if (Ext.getCmp('groupNameComboId').getValue() == "") {
							    Ext.example.msg("<%=selectAssetGroup%>");
                                Ext.getCmp('groupNameComboId').focus();
                                return;
                            }
                            
                            if (Ext.getCmp('startdate').getValue() == "") {
							    Ext.example.msg("<%=selectStartDate%>");
                                Ext.getCmp('startdate').focus();
                                return;
                            }
<!---->
<!--                            if (Ext.getCmp('enddate').getValue() == "") {-->
<!--							    Ext.example.msg("<%=selectEndDate%>");-->
<!--                                Ext.getCmp('enddate').focus();-->
<!--                                return;-->
<!--                            }-->

<!--                            if (Ext.getCmp('groupNameComboId').getValue() == 0) {-->
<!--                                var v_from = Ext.getCmp('startdate').value;-->
<!--                                var v_to = Ext.getCmp('enddate').value;-->
<!--                                var str = v_from.split("-");-->
<!--                                var frmDate = new Date(str[1] + "-" + str[0] + "-" + str[2]); //mm/dd/yyyy-->
<!--                                str = v_to.split("-");-->
<!--                                var todateDay = str[0];-->
<!--                                var toDate = new Date(str[1] + "-" + str[0] + "-" + str[2]); //mm/dd/yyyy-->
<!--                                var one_day = 1000 * 60 * 60 * 24;-->
<!--                                var days = parseInt((toDate.getTime() - frmDate.getTime()) / one_day);-->
<!--                                if (days >= 1) {-->
<!--                                Ext.example.msg("Difference Between Two Dates Cannot Be Greater Than 1 Days");-->
<!--                                    return;-->
<!--                                }-->
<!--                            }else{-->
<!--                             var v_from = Ext.getCmp('startdate').value;-->
<!--                                var v_to = Ext.getCmp('enddate').value;-->
<!--                                var str = v_from.split("-");-->
<!--                                var frmDate = new Date(str[1] + "-" + str[0] + "-" + str[2]); //mm/dd/yyyy-->
<!--                                str = v_to.split("-");-->
<!--                                var todateDay = str[0];-->
<!--                                var toDate = new Date(str[1] + "-" + str[0] + "-" + str[2]); //mm/dd/yyyy-->
<!--                                var one_day = 1000 * 60 * 60 * 24;-->
<!--                                var days = parseInt((toDate.getTime() - frmDate.getTime()) / one_day);-->
<!--                                -->
<!--                                if (days >= 4) {-->
<!--                                Ext.example.msg("Difference Between Two Dates Cannot Be Greater Than 3 Days");-->
<!--                                    return;-->
<!--                                }-->
<!--                            }-->
<!--                             if (dateCompare(Ext.getCmp('startdate').getValue(), Ext.getCmp('enddate').getValue()) == -1) {-->
<!--							 Ext.example.msg("<%=endDateMustBeGreaterthanStartDate%>");-->
<!--                                Ext.getCmp('enddate').focus();-->
<!--                                return;-->
<!--                            }-->
<!--                            -->
<!--                            if (checkMonthValidation(Ext.getCmp('startdate').getValue(), Ext.getCmp('enddate').getValue())) {-->
<!--							 Ext.example.msg("<%=monthValidation%>");-->
<!--                                return;-->
<!--                            }-->
                            var startDate = Ext.getCmp('startdate').getValue();
                            var endDate = Ext.getCmp('startdate').getValue();
                            var groupIds = Ext.getCmp('groupNameComboId').getValue();

                           // alert('santhosh');
                            store.load({
                                params: {
                                    CustId: custId,
                                    custName: Ext.getCmp('custcomboId').getRawValue(),
                                    StartDate: startDate,
                                    EndDate: endDate,
                                    jspName: jspName,
                                    groupId: groupIds,
                                    groupName: Ext.getCmp('groupNameComboId').getRawValue()
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
        idProperty: 'overSpeedId',
        root: 'miningOverSpeedReportDetailsRoot',
        totalProperty: 'total',
        fields: [{
            name: 'SLNODataIndex',
            type: 'int'
        }, {
            name: 'AssetNoDataIndex',
            type: 'string'
        }, {
            name: 'GroupNameDataIndex',
            type: 'string'
        }, {
            name: 'DateAndTimeDataIndex',
            type: 'date'
        }, {
            name: 'GpsDateAndTimeDataIndex',
            type: 'date'
        }, {
            name: 'GmtDateAndTimeDataIndex',
            type: 'date'
        }, {
            name: 'latitudeDataIndex',
            type: 'string'
        }, {
            name: 'longitudeDataIndex',
            type: 'string'
        }, {
            name: 'LocationDataIndex',
            type: 'string'
        },{
            name: 'tripSheetNoDataIndex',
            type: 'String'
        },{
            name: 'speedDataIndex',
            type: 'numeric'
        }, {
            name: 'osLimitDataIndex',
            type: 'numeric'
        }]
    });

    //-----------------------------------------Reader configs Ends-------------------------------------------//
    //-----------------------------------------------store---------------------------------------------------//
    var store = new Ext.data.GroupingStore({
        autoLoad: false,
        proxy: new Ext.data.HttpProxy({
            url: '<%=request.getContextPath()%>/MiningOverSpeed.do?param=getMiningOverSpeedDetails',
            method: 'POST'
        }),
        remoteSort: false,
        sortInfo: {
            field: 'AssetNoDataIndex',
            direction: 'ASC'
        },
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
            dataIndex: 'AssetNoDataIndex',
            type: 'string'
        }, {
            dataIndex: 'GroupNameDataIndex',
            type: 'string'
        }, {
            dataIndex: 'DateAndTimeDataIndex',
            type: 'date'
        }, {
            dataIndex: 'GpsDateAndTimeDataIndex',
            type: 'date'
        }, {
            dataIndex: 'GmtDateAndTimeDataIndex',
            type: 'date'
        }, {
            dataIndex: 'latitudeDataIndex',
            type: 'string'
        }, {
            dataIndex: 'longitudeDataIndex',
            type: 'string'
        }, {
            dataIndex: 'LocationDataIndex',
            type: 'string'
        },{
            dataIndex: 'tripSheetNoDataIndex',
            type: 'string'
        }, {
            dataIndex: 'speedDataIndex',
            type: 'numeric'
        }, {
            dataIndex: 'osLimitDataIndex',
            type: 'numeric'
        }]
    });
    //--------------------------------------------------column Model---------------------------------------//
    var createColModel = function(finish, start) {
        var columns = [
            new Ext.grid.RowNumberer({
                header: '<b>SL NO</b>',
                width: 50
            }), {
                header: '<b><%=SLNO%></b>',
                hidden: true,
                sortable: true,
                dataIndex: 'SLNODataIndex'
            }, {
                header: '<b><%=assetNumber%></b>',
                //hidden: true,
                sortable: true,
                dataIndex: 'AssetNoDataIndex'
            }, {
                header: '<b><%=groupName%></b>',
                hidden: false,
                sortable: true,
                dataIndex: 'GroupNameDataIndex',
                hideable: true
            }, {
                header: '<b><%=date%></b>',
                hidden: false,
                sortable: true,
                renderer: Ext.util.Format.dateRenderer(getDateTimeFormat()),
                dataIndex: 'DateAndTimeDataIndex',
                filter: {
                type: 'date'
               }
            }, {
                header: '<b><%=gpsDateTime%></b>',
                hidden: false,
                sortable: true,
                renderer: Ext.util.Format.dateRenderer(getDateTimeFormat()),
                dataIndex: 'GpsDateAndTimeDataIndex',
                filter: {
                type: 'date'
               }
            }, {
                header: '<b><%=gmt%></b>',
                hidden: false,
                sortable: true,
                renderer: Ext.util.Format.dateRenderer(getDateTimeFormat()),
                dataIndex: 'GmtDateAndTimeDataIndex',
                filter: {
                type: 'date'
               }
            }, {
                header: '<b><%=latitude%></b>',
                hidden: false,
                sortable: true,
                dataIndex: 'latitudeDataIndex'
            }, {
                header: '<b><%=longitude%></b>',
                hidden: false,
                sortable: true,
                dataIndex: 'longitudeDataIndex'
            }, {
                header: '<b><%=location%></b>',
                hidden: false,
                sortable: true,
                dataIndex: 'LocationDataIndex'
            },{
                header: '<b><%=TripSheetNumber%></b>',
                hidden: false,
                sortable: true,
                dataIndex: 'tripSheetNoDataIndex'
            },{
                header: '<b><%=speed%></b>',
                hidden: false,
                sortable: true,
                dataIndex: 'speedDataIndex'
            }, {
                header: '<b><%=osLimit%></b>',
                hidden: true,
                sortable: true,
                dataIndex: 'osLimitDataIndex'
            }
        ];
        return new Ext.grid.ColumnModel({
            columns: columns.slice(start || 0, finish),
            defaults: {
                sortable: true
            }
        });
    };

    //---------------------------------------------------------grid-------------------------------------------//

    tripGrid = getGrid('<%=miningOverSpeedReport%>', '<%=NoRecordsfound%>', store, screen.width - 45, 400, 24, filters, '<%=ClearFilterData%>', false, '', 20, false, '', false, '', true, '<%=Excel%>', jspName, exportDataType, false, '');

    //--------------------------------------------------------------------------------------------------------//

     var mainPanel = new Ext.Panel({
        standardSubmit: true,
        frame: true,
        //autoScroll: true,
        width: screen.width - 20,
        height: 420,
        layout: 'table',
        layoutConfig: {
            columns: 1
        },
        items: [
            tripGrid
        ]
    });

    Ext.onReady(function() {
        Ext.QuickTips.init();
        Ext.Ajax.timeout = 360000;
        Ext.form.Field.prototype.msgTarget = 'side';
        outerPanel = new Ext.Panel({
            title: '',
            renderTo: 'content',
            standardSubmit: true,
            autoScroll: false,
            frame: true,
            border: false,
            id: 'outer',
            layout: 'table',
            width: 1360,
            height: 530,
            cls: 'outerpanel',
            layoutConfig: {
                columns: 1
            },
            items: [clientPanel, mainPanel],
        });
        //tripGrid.show();
    });
</script>
  <jsp:include page="../Common/footer.jsp" />
 <!-- </body>   -->
 <!-- </html> -->
<%}%>

