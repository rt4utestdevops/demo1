<%@ page language="java"
	import="java.util.*,t4u.functions.CommonFunctions,t4u.beans.*,t4u.common.*"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://packtag.sf.net" prefix="pack"%>
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
		response.sendRedirect(request.getContextPath()
				+ "/Jsps/Common/SessionDestroy.html");
	} else {
		session.setAttribute("loginInfoDetails", loginInfo);
		String language = loginInfo.getLanguage();
		int systemId = loginInfo.getSystemId();
		int customerId = loginInfo.getCustomerId();
	
ArrayList<String> tobeConverted = new ArrayList<String>();
tobeConverted.add("SLNO");
tobeConverted.add("Vehicle_No");
tobeConverted.add("Group_Name");
tobeConverted.add("Cross_Border_Date_and_Time");
tobeConverted.add("Alert_Location");
tobeConverted.add("Returned_Status");
tobeConverted.add("Select_Customer");
tobeConverted.add("Customer_Name");
tobeConverted.add("City");
tobeConverted.add("Date");
tobeConverted.add("Please_Select_customer");
tobeConverted.add("Select_City");
tobeConverted.add("Excel");
tobeConverted.add("PDF");
tobeConverted.add("Clear_Filter_Data");
tobeConverted.add("No_Records_Found");


ArrayList<String> convertedWords = new ArrayList<String>();
convertedWords = cf.getLanguageSpecificWordForKey(tobeConverted,language);
String SLNO=convertedWords.get(0);
String VehicleNo=convertedWords.get(1);
String GroupName=convertedWords.get(2);
String CrossedBorderDateandTime=convertedWords.get(3);
String AlertLocation=convertedWords.get(4);
String ReturnedStatus=convertedWords.get(5);
String SelectCustomer=convertedWords.get(6);
String CustomerName=convertedWords.get(7);
String City=convertedWords.get(8);
String Date=convertedWords.get(9);
String PleaseSelectCustomer=convertedWords.get(10);
String SelectCity=convertedWords.get(11);
String Excel=convertedWords.get(12);
String Pdf=convertedWords.get(13);
String ClearFilterData=convertedWords.get(14);
String NoRecordsFound=convertedWords.get(15);




%>

<jsp:include page="../Common/header.jsp" />
		
		<base href="<%=basePath%>">
		<title>City Wise Cross Bordered Details</title>

<style>
   .x-panel-tl {
       border-bottom: 0px solid !important;
   }
 #content div.x-grid3-col-numberer {
    text-align: center;
}
   
   
</style>

   <%if (loginInfo.getStyleSheetOverride().equals("Y")){%>
	<jsp:include page="../Common/ImportJSSandMining.jsp"/>
	<%}else{%>
	<jsp:include page="../Common/ImportJS.jsp" /><%}%>
   <jsp:include page="../Common/ExportJS.jsp" />
   <style>
	.ext-strict .x-form-text {
		height: 21px !important;
	}
	label {
		display : inline !important;
	}
	.x-window-tl *.x-window-header {
		padding-top : 6px !important;
	}
	.x-layer ul {
		min-height:27px !important;
	}
   </style>
   
<script>
var outerPanel;
var dtprev = dateprev;
var dtcur = datecur;
var dtnxt = datenext;
var jspName = "CityWiseCrossBorderReport";
var exportDataType = "int,string,string,string,string,string,string";
var grid;

var reader = new Ext.data.JsonReader({
    idProperty: 'crossid',
    root: 'CrossTypeRoot',
    totalProperty: 'total',
    fields: [{
        name: 'slnoDataIndex'
    }, {
     name: 'citydataindex'
    }, {
        name: 'VehiclenoDataIndex'
    }, {
        name: 'GroupnameDataIndex'
    }, {
        name: 'crossedborderDataIndex'
    }, {
        name: 'alertlocationDataIndex'
    }, {
        name: 'returnstatusetDataIndex'
    }]
});

var filters = new Ext.ux.grid.GridFilters({
    local: true,
    filters: [{
        type: 'int',
        dataIndex: 'slnoDataIndex'
    }, {
     type: 'string',
        dataIndex: 'citydataindex'
    }, {
        type: 'string',
        dataIndex: 'VehiclenoDataIndex'
    }, {
        type: 'string',
        dataIndex: 'GroupnameDataIndex'
    }, {
        type: 'date',
        dataIndex: 'crossedborderDataIndex'
    }, {
        type: 'string',
        dataIndex: 'alertlocationDataIndex'
    }, {
        type: 'date',
        dataIndex: 'returnstatusetDataIndex'
    }]
});


var store = new Ext.data.GroupingStore({
    autoLoad: false,
    proxy: new Ext.data.HttpProxy({
        url: '<%=request.getContextPath()%>/PowerConnectionReportAction.do?param=getCityWisereports',
        method: 'POST'
    }),

    storeId: 'vehicletypedetailid',
    reader: reader
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
                var cid = Ext.getCmp('custcomboId').setValue('<%=customerId%>');

                custId = Ext.getCmp('custcomboId').getValue();
                custName = Ext.getCmp('custcomboId').getRawValue();

                citycombostore.load({
                    params: {
                        CustomerId: Ext.getCmp('custcomboId').getValue()
                    }
                });
            }
        }
    }
});




var custnamecombo = new Ext.form.ComboBox({
    store: customercombostore,
    id: 'custcomboId',
    mode: 'local',
    forceSelection: true,
    emptyText: 'SelectCustomer',
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
                parent.globalCustomerID = Ext.getCmp('custcomboId').getValue();
                citycombostore.load({
                    params: {
                        CustomerId: Ext.getCmp('custcomboId').getValue()
                    }
                });

                Ext.getCmp('citycomboId').reset();
            }
        }
    }
});
var citycombostore = new Ext.data.JsonStore({
    url: '<%=request.getContextPath()%>/PowerConnectionReportAction.do?param=getCity',
    id: 'CityStoreId',
    root: 'CityRoot',
    autoLoad: false,
    remoteSort: true,
    fields: ['CityId', 'CityName']
});
var citynamecombo = new Ext.form.ComboBox({
    store: citycombostore,
    id: 'citycomboId',
    mode: 'local',
    forceSelection: true,
    emptyText: 'Select City',
    selectOnFocus: true,
    allowBlank: false,
    anyMatch: true,
    typeAhead: false,
    triggerAction: 'all',
    lazyRender: true,
    valueField: 'CityId',
    displayField: 'CityName',
    cls: 'selectstylePerfect',
    listeners: {
        select: {
            fn: function() {
                parent.globalCityID = Ext.getCmp('citycomboId').getValue();


            }
        }
    }
});
var editInfo1 = new Ext.Button({
    text: 'Generate Report',
    id: 'reportId',
    cls: 'buttonStyle',
    width: 80,

    handler: function() {
        //store.load();
        var CustomerName = Ext.getCmp('custcomboId').getValue();
        var CityName = Ext.getCmp('citycomboId').getValue();

        if (Ext.getCmp('custcomboId').getValue() == "") {
            Ext.example.msg("<%=PleaseSelectCustomer%>");
            Ext.getCmp('custcomboId').focus();
            return;
        }
        if (Ext.getCmp('citycomboId').getValue() == "") {
            Ext.example.msg("<%=SelectCity%>");
            Ext.getCmp('citycomboId').focus();
            return;
        }

        store.load({
            params: {
                CustId: Ext.getCmp('custcomboId').getValue(),
                custName: Ext.getCmp('custcomboId').getRawValue(),
                CityId: Ext.getCmp('citycomboId').getValue(),
                CityName: Ext.getCmp('citycomboId').getRawValue(),
                startdate: Ext.getCmp('startdate').getValue(),
                enddate: Ext.getCmp('startdate').getValue(),
                jspName: jspName
            }
        });
    }
});

var clientPanel = new Ext.Panel({
    standardView: true,
    collapsible: false,
    id: 'clientPanelId',
    layout: 'table',
    frame: true,
    width: screen.width - 40,
    height: 70,
    layoutConfig: {
        columns: 10
    },
    items: [{
            xtype: 'label',
            text: '<%=CustomerName%>' + ' :',
            cls: 'labelstyle',
            id: 'custnamelab'
        }, custnamecombo, {
            width: 40

        }, {
            xtype: 'label',
            text: '<%=City%>' + ' :',
            cls: 'labelstyle',
            id: 'citynamelab'
        }, citynamecombo, {
            width: 100
        },

        {
            xtype: 'label',
            cls: 'labelstyle',
            id: 'startdatelab',
            text: '<%=Date%>' + ' :'
        }, {
            xtype: 'datefield',
            cls: 'selectstylePerfect',
            width: 185,
            format: getDateFormat(),
            emptyText: 'SelectDate',
            allowBlank: false,
            blankText: 'SelectDate',
            id: 'startdate',
            maxValue: dtcur,
            value: dtprev

        }, {
            width: 50
        },
        editInfo1
    ]
});

var createColModel = function(finish, start) {
    var columns = [
        new Ext.grid.RowNumberer({
            header: "<span style=font-weight:bold;>Sl No</span>",
            width: 60,
            align: 'center'
        }), {
            dataIndex: 'slnoDataIndex',
            hidden: true,
            header: "<span style=font-weight:bold;>Sl No</span>",
            width: 200,

            filter: {
                type: 'int'
            }
        }, {
            dataIndex: 'citydataindex',
            hidden: false,
            header: "<span style=font-weight:bold;><%=City%></span>",
            width: 400,
             filter: {
                type: 'string'
            }
        }, {

            dataIndex: 'VehiclenoDataIndex',
            hidden: false,
            header: "<span style=font-weight:bold;><%=VehicleNo%></span>",
            width: 400,

            filter: {
                type: 'string'
            }
        }, {
            dataIndex: 'GroupnameDataIndex',
            hidden: false,
            header: "<span style=font-weight:bold;><%=GroupName%></span>",
            width: 400,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=CrossedBorderDateandTime%></span>",
            hidden: false,
            width: 500,
            //sortable: false,
            dataIndex: 'crossedborderDataIndex',

            filter: {
                type: 'date'
            }
        }, {
            header: "<span style=font-weight:bold;><%=AlertLocation%></span>",
            hidden: false,
            width: 500,
            //sortable: true,
            dataIndex: 'alertlocationDataIndex',
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;>Returned To Border Date</span>",
            hidden: false,
            width: 500,
            //sortable: true,
            dataIndex: 'returnstatusetDataIndex',
            filter: {
               type: 'date'
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
grid = getGrid('','<%=NoRecordsFound%>', store, screen.width - 40, 350, 60, filters, '', false, '', 60, false, '', false, '', true, '<%=Excel%>', jspName, exportDataType, '', true);
Ext.onReady(function() {
    ctsb = tsb;
    Ext.QuickTips.init();
    Ext.form.Field.prototype.msgTarget = 'side';
    outerPanel = new Ext.Panel({
        title: 'City Wise Cross Border Report',
        renderTo: 'content',
        standardSubmit: true,
        frame: true,
        width: screen.width - 22,
        height: 540,
        layout: 'table',
        layoutConfig: {
            columns: 1
        },
        items: [clientPanel, grid]
    });
    sb = Ext.getCmp('form-statusbar');

});
</script>
  <jsp:include page="../Common/footer.jsp" />
 <!-- </body>   -->
 <!-- </html> -->
<%}%>