<%@ page  language="java" import="java.util.*,java.text.SimpleDateFormat,t4u.functions.*,t4u.beans.*,t4u.common.*" pageEncoding="utf-8"%>
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
	int userID=loginInfo.getUserId();
	String userAuthority=cf.getUserAuthority(systemId,userID);
	if(!userAuthority.equalsIgnoreCase("Admin"))
	{
	response.sendRedirect(request.getContextPath()+ "/Jsps/Common/401Error.html");
	}
ArrayList<String> tobeConverted = new ArrayList<String>();
tobeConverted.add("Holidays_Information");
tobeConverted.add("Select_Customer_Name");	
tobeConverted.add("View");
tobeConverted.add("Please_Select_customer");
tobeConverted.add("Please_Select_Start_Date");
tobeConverted.add("Please_Select_End_Date");
tobeConverted.add("Year_Validation");
tobeConverted.add("Customer_Name");
tobeConverted.add("Start_Date");
tobeConverted.add("Select_Start_Date");
tobeConverted.add("End_Date");
tobeConverted.add("Select_End_Date");
tobeConverted.add("Holidays_Report");
tobeConverted.add("Date");
tobeConverted.add("Select_Date");
tobeConverted.add("Reason");
tobeConverted.add("Enter_Reason");
tobeConverted.add("Select_Customer_Name");
tobeConverted.add("Enter_Date");
tobeConverted.add("Cancel");
tobeConverted.add("Add");
tobeConverted.add("Holidays_Details");
tobeConverted.add("No_Rows_Selected");
tobeConverted.add("Select_Single_Row");
tobeConverted.add("Modify");
tobeConverted.add("SLNO");
tobeConverted.add("Id");
tobeConverted.add("No_Records_Found");
tobeConverted.add("Clear_Filter_Data");
tobeConverted.add("Excel");
tobeConverted.add("Save");
tobeConverted.add("End_Date_Must_Be_Greater_Than_Start_Date");

ArrayList<String> convertedWords = new ArrayList<String>();
convertedWords = cf.getLanguageSpecificWordForKey(tobeConverted,language);
String HolidaysInformation=convertedWords.get(0);
String SelectCustomer=convertedWords.get(1);
String View=convertedWords.get(2);
String PleaseselectCustomer=convertedWords.get(3);
String Pleaseselectstartdate=convertedWords.get(4);
String Pleaseselectenddate=convertedWords.get(5);
String YearValidation=convertedWords.get(6);
String Customer=convertedWords.get(7);
String StartDate=convertedWords.get(8);
String SelectStartDate=convertedWords.get(9);
String EndDate=convertedWords.get(10);
String SelectEndDate=convertedWords.get(11);
String HolidaysReport=convertedWords.get(12);
String Date=convertedWords.get(13);
String SelectDate=convertedWords.get(14);
String Reason=convertedWords.get(15);
String EnterReason=convertedWords.get(16);
String SelectCustomerName=convertedWords.get(17);
String EnterDate=convertedWords.get(18);
String Cancel=convertedWords.get(19);
String Add=convertedWords.get(20);
String HolidaysDetails=convertedWords.get(21);
String NoRowsSelected=convertedWords.get(22);
String SelectSingleRow=convertedWords.get(23);
String Modify=convertedWords.get(24);
String SLNO=convertedWords.get(25);
String Id=convertedWords.get(26);
String NoRecordsFound=convertedWords.get(27);
String ClearFilterData=convertedWords.get(28);
String Excel=convertedWords.get(29);
String Save=convertedWords.get(30);
String EndDateMustBeGreaterthanStartDate=convertedWords.get(31);

%>

<jsp:include page="../Common/header.jsp" />
 		<title><%=HolidaysInformation%></title>	
 		<meta http-equiv="X-UA-Compatible" content="IE=8">	
	    
	 <style>
  .x-panel-tl
	{
		border-bottom: 0px solid !important;
	}
  </style>
  
   <%if (loginInfo.getStyleSheetOverride().equals("Y")){%>
	<jsp:include page="../Common/ImportJSSandMining.jsp"/>
	<%}else{%>
	<jsp:include page="../Common/ImportJS.jsp" /><%}%>
   <jsp:include page="../Common/ExportJS.jsp" />
   <style>
	
		label {
				display : inline !important;
		}
		.ext-strict .x-form-text {
			height : 21px !important;
		}
		.x-window-tl *.x-window-header {
			height : 38px !important;
		}
		.x-layer ul {
		 	min-height: 27px !important;
		}
   </style>
   <script>
var outerPanel;
var ctsb;
var jspName = "HolidaysInformation";
var exportDataType = "";
var selected;
var grid;
var buttonValue;
var titelForInnerPanel;
var myWin;
var dtprev = dateprev;
var dtcur = datecur;
window.onload = function () { 
		refresh();
	}
var clientcombostore = new Ext.data.JsonStore({
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
                store.load({
                    params: {
                        custId: custId,
                        jspName: jspName,
                        custName: Ext.getCmp('custcomboId').getRawValue()
                    }
                });
            }
        }
    }
});

var Client = new Ext.form.ComboBox({
    store: clientcombostore,
    id: 'custcomboId',
    mode: 'local',
    forceSelection: true,
    emptyText: '<%=SelectCustomer%>',
    blankText: '<%=SelectCustomer%>',
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
                store.load({
                    params: {
                        CustID: Ext.getCmp('custcomboId').getValue(),
                        jspName: jspName,
                        custName: Ext.getCmp('custcomboId').getRawValue()
                    }
                });
            }
        }
    }
});

var editInfo1 = new Ext.Button({
    text: '<%=View%>',
    id: 'viewId',
    cls: 'buttonStyle',
    width: 70,
    handler: function ()

    {
    
      store.load();
    
        var clientName = Ext.getCmp('custcomboId').getValue();
        var startdate = Ext.getCmp('startdate').getValue();
        var enddate = Ext.getCmp('enddate').getValue();
        if (Ext.getCmp('custcomboId').getValue() == "") {
            Ext.example.msg("<%=PleaseselectCustomer%>");
            Ext.getCmp('custcomboId').focus();
            return;
        }

        if (Ext.getCmp('startdate').getValue() == "") {
            Ext.example.msg("<%=Pleaseselectstartdate%>");    
            Ext.getCmp('startdate').focus();
            return;
        }
        if (Ext.getCmp('enddate').getValue() == "") {
            Ext.example.msg("<%=Pleaseselectenddate%>");
            Ext.getCmp('enddate').focus();
            return;
        }

   if (dateCompare(Ext.getCmp('startdate').getValue(), Ext.getCmp('enddate').getValue()) == -1) {
                           Ext.example.msg("<%=EndDateMustBeGreaterthanStartDate%>"); 
                           Ext.getCmp('enddate').focus();
                           return;
                       }


        if (checkYearValidation(Ext.getCmp('startdate').getValue(), Ext.getCmp('enddate').getValue())) {
            Ext.example.msg("<%=YearValidation%>");
            Ext.getCmp('enddate').focus();
            return;
        }

        store.load({
            params: {
                custID: Ext.getCmp('custcomboId').getValue(),
                startdate: Ext.getCmp('startdate').getValue(),
                enddate: Ext.getCmp('enddate').getValue(),
                custName: Ext.getCmp('custcomboId').getRawValue(),
                jspName: jspName
            }

        });

    }
});

var comboPanel = new Ext.Panel({
    standardSubmit: true,
    collapsible: false,
    id: 'traderMaster',
    layout: 'table',
    frame: false,
    width: screen.width - 12,
    height: 40,
    layoutConfig: {
        columns: 13
    },
    items: [{
            xtype: 'label',
            text: '<%=Customer%>' + ' :',
            cls: 'labelstyle'
        },
        Client, {
            width: 100
        }, {
            xtype: 'label',
            cls: 'labelstyle',
            id: 'startdatelab',
            text: '<%=StartDate%>' + ' :'
        }, {
            xtype: 'datefield',
            cls: 'selectstylePerfect',
            width: 185,
            format: getDateFormat(),
            emptyText: '<%=SelectStartDate%>',
            allowBlank: false,
            blankText: '<%=SelectStartDate%>',
            id: 'startdate',
            value: dtprev,
            endDateField: 'enddate'
        }, {
            width: 100
        }, {
            xtype: 'label',
            cls: 'labelstyle',
            id: 'enddatelab',
            text: '<%=EndDate%>' + ' :'
        }, {
            xtype: 'datefield',
            cls: 'selectstylePerfect',
            width: 185,
            format: getDateFormat(),
            emptyText: '<%=SelectEndDate%>',
            allowBlank: false,
            blankText: '<%=SelectEndDate%>',
            id: 'enddate',
            value: datecur,
            startDateField: 'startdate'
        }, {
            width: 100
        },
        editInfo1
    ]
});


var innerPanelForHolidaysDetails = new Ext.form.FormPanel({
    standardSubmit: true,
    collapsible: false,
    autoScroll: true,
    height: 120,
    width: 400,
    frame: true,
    id: 'custMaster',
    layout: 'table',
    layoutConfig: {
        columns: 4
    },
    items: [{
        xtype: 'fieldset',
        title: '<%=HolidaysInformation%>',
        cls: 'fieldsetpanel',
        collapsible: false,
        colspan: 3,
        id: 'addpanelid',
        width: 360,
        layout: 'table',
        layoutConfig: {
            columns: 3,
            tableAttrs: {
		            style: {
		                width: '88%'
		            }
        			}
        },
        items: [{
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'mandatoryDateId'
        }, {
            xtype: 'label',
            text: '<%=Date%>' + ' :',
            cls: 'labelstyle',
            id: 'dateTxtId'
        },{
            xtype: 'datefield',
            cls: 'selectstylePerfect',
            id: 'dateId',
            format: getDateFormat(),
            allowBlank: false,
            blankText: '<%=SelectDate%>',
            submitFormat: getDateFormat(),
            labelSeparator: '',
            allowBlank: false,
            value: dtcur
        },{
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'mandatoryRreaeasonsId'
        }, {
            xtype: 'label',
            text: '<%=Reason%>' + ' :',
            cls: 'labelstyle',
            id: 'reasonsTxtId'
        }, {
            xtype: 'textfield',
            regex: validate('name'),
            emptyText: '<%=EnterReason%>',
            allowBlank: false,
            blankText: '<%=EnterReason%>',
            cls: 'selectstylePerfect',
            id: 'reasonsId'
        }]
    }]
});

var innerWinButtonPanel = new Ext.Panel({
    id: 'winbuttonid',
    standardSubmit: true,
    collapsible: false,
    autoHeight: true,
    height: 100,
    width: 380,
    frame: true,
    layout: 'table',
    layoutConfig: {
        columns: 4
    },
    buttons: [{
        xtype: 'button',
        text: '<%=Save%>',
        id: 'addButtId',
        iconCls:'savebutton',
        cls: 'buttonstyle',
        width: 70,
        listeners: {
            click: {
                fn: function () {
                    if (Ext.getCmp('custcomboId').getValue() == "") {
                        Ext.example.msg("<%=SelectCustomerName%>");
                        return;
                    }

                    if (Ext.getCmp('dateId').getValue() == "") {
                        Ext.example.msg("<%=EnterDate%>");
                        return;
                    }

                    if (Ext.getCmp('reasonsId').getValue() == "") {
                        Ext.example.msg("<%=EnterReason%>");    
                        return;
                    }

                    if (innerPanelForHolidaysDetails.getForm().isValid()) {
                        var id;
                        if (buttonValue == 'Modify') {
                            var selected = grid.getSelectionModel().getSelected();
                            id = selected.get('idDataIndex');
                        }
                        holidaysOuterPanelWindow.getEl().mask();
                        //alert(Ext.getCmp('reasonsId').getValue());
                        Ext.Ajax.request({
                            url: '<%=request.getContextPath()%>/PreferencesAction.do?param=holidaysAddModify',
                            method: 'POST',
                            params: {
                                buttonValue: buttonValue,
                                CustID: Ext.getCmp('custcomboId').getValue(),
                                custName: Ext.getCmp('custcomboId').getRawValue(),
                                date: Ext.getCmp('dateId').getValue(),
                                id: id,
                                reasons: Ext.getCmp('reasonsId').getValue(),
                                jspName: jspName
                            },
                            success: function (response, options) {
                                var message = response.responseText;
                                Ext.example.msg(message);
                                Ext.getCmp('dateId').reset();
                                Ext.getCmp('reasonsId').reset();
                                myWin.hide();
                                store.load({
                                    params: {
                                        custID: Ext.getCmp('custcomboId').getValue(),
                                        startdate: Ext.getCmp('startdate').getValue(),
                                        enddate: Ext.getCmp('enddate').getValue(),
                                        custName: Ext.getCmp('custcomboId').getRawValue(),
                                        jspName: jspName
                                    }

                                });
                                holidaysOuterPanelWindow.getEl().unmask();
                            },
                            failure: function () {
                                Ext.example.msg("Error");
                                store.reload();
                                myWin.hide();
                            }
                        });
                    }
                }
            }
        }
    }, {
        xtype: 'button',
        text: '<%=Cancel%>',
        id: 'canButtId',
        cls: 'buttonstyle',
        iconCls: 'cancelbutton',
        width: 70,
        listeners: {
            click: {
                fn: function () {
                    myWin.hide();
                }
            }
        }
    }]
});

var holidaysOuterPanelWindow = new Ext.Panel({
    width: 390,
    height: 250,
    standardSubmit: true,
    frame: true,
    items: [innerPanelForHolidaysDetails, innerWinButtonPanel]
});

myWin = new Ext.Window({
    title: titelForInnerPanel,
    closable: false,
    resizable: false,
    modal: true,
    autoScroll: false,
    height: 230,
    width: 390,
    id: 'myWin',
    items: [holidaysOuterPanelWindow]
});

function addRecord() {
    if (Ext.getCmp('custcomboId').getValue() == "") {
        Ext.example.msg("<%=SelectCustomerName%>");
        return;
    }
    buttonValue = '<%=Add%>';
    titelForInnerPanel = '<%=HolidaysDetails%>';
    myWin.setPosition(450, 150);
    myWin.show();
    myWin.setTitle(titelForInnerPanel);
    Ext.getCmp('dateId').reset();
    Ext.getCmp('reasonsId').reset();
}

function modifyData() {
    if (Ext.getCmp('custcomboId').getValue() == "") {
        Ext.example.msg("<%=SelectCustomerName%>");
        return;
    }
    if (grid.getSelectionModel().getCount() == 0) {
        Ext.example.msg("<%=NoRowsSelected%>");
        return;
    }
    if (grid.getSelectionModel().getCount() > 1) {
        Ext.example.msg("<%=SelectSingleRow%>");
        return;
    }
    buttonValue = '<%=Modify%>';
    titelForInnerPanel = '<%=Modify%>';
    myWin.setPosition(450, 150);
    myWin.setTitle(titelForInnerPanel);
    myWin.show();

    Ext.getCmp('dateId').show();
    Ext.getCmp('reasonsId').show();
    var selected = grid.getSelectionModel().getSelected();
    Ext.getCmp('dateId').setValue(selected.get('dateDataIndex'));
    Ext.getCmp('reasonsId').setValue(selected.get('reasonsDataIndex'));
}

var reader = new Ext.data.JsonReader({
    idProperty: 'taskMasterid',
    root: 'holidaysRoot',
    totalProperty: 'total',
    fields: [{
        name: 'slnoIndex'
    }, {
        name: 'dateDataIndex'
    }, {
        name: 'reasonsDataIndex'
    }, {
        name: 'idDataIndex'
    }]
});

var store = new Ext.data.GroupingStore({
    autoLoad: false,
    proxy: new Ext.data.HttpProxy({
        url: '<%=request.getContextPath()%>/PreferencesAction.do?param=getHolidaysReport',
        method: 'POST'
    }),
    storeId: 'holidaysId',
    reader: reader
});

var filters = new Ext.ux.grid.GridFilters({
    local: true,
    filters: [{
        type: 'numeric',
        dataIndex: 'slnoIndex'
    }, {
        type: 'date',
        dataIndex: 'dateDataIndex'
    }, {
        type: 'string',
        dataIndex: 'reasonsDataIndex'
    }, {
        type: 'int',
        dataIndex: 'idDataIndex'
    }, ]
});

var createColModel = function (finish, start) {
    var columns = [
        new Ext.grid.RowNumberer({
            header: "<span style=font-weight:bold;><%=SLNO%></span>",
            width: 50
        }), {
            dataIndex: 'slnoIndex',
            hidden: true,
            header: "<span style=font-weight:bold;><%=SLNO%></span>",
            filter: {
                type: 'numeric'
            }
        }, {
            header: "<span style=font-weight:bold;><%=Date%></span>",
            dataIndex: 'dateDataIndex',
            width: 100,
            filter: {
                type: 'date'
            }
        }, {
            header: "<span style=font-weight:bold;><%=Reason%></span>",
            dataIndex: 'reasonsDataIndex',
            width: 100,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=Id%></span>",
            dataIndex: 'idDataIndex',
            width: 100,
            hidden: true,
            filter: {
                type: 'int'
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

//*****************************************************************Grid *******************************************************************************
grid = getGrid('<%=HolidaysInformation%>', '<%=NoRecordsFound%>', store, screen.width - 40, 440, 6, filters, '<%=ClearFilterData%>', false, '', 16, false, '', false, '', false, '<%=Excel%>', jspName, exportDataType, false, 'PDF', true, '<%=Add%>', true, '<%=Modify%>');
//******************************************************************************************************************************************************
Ext.onReady(function () {
    ctsb = tsb;
    Ext.QuickTips.init();
    Ext.form.Field.prototype.msgTarget = 'side';
    outerPanel = new Ext.Panel({
        title: '<%=HolidaysInformation%>',
        renderTo: 'content',
        standardSubmit: true,
        frame: true,
        width:screen.width - 25,
        cls: 'outerpanel',
        layout: 'table',
        layoutConfig: {
            columns: 1
        },
        items: [comboPanel, grid]
        //bbar: ctsb
    });
    sb = Ext.getCmp('form-statusbar');

});
</script>
 <jsp:include page="../Common/footer.jsp" />
 <!-- </body>   -->
 <!-- </html> -->

    
    
    
    
    

