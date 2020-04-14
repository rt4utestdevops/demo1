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
ArrayList<String> tobeConverted = new ArrayList<String>();
tobeConverted.add("Route_Master");
tobeConverted.add("Add");
tobeConverted.add("Modify");
tobeConverted.add("Customer_Name");
tobeConverted.add("Select_Customer_Name");
tobeConverted.add("Route_Master_Details");
tobeConverted.add("No_Records_Found");
tobeConverted.add("Clear_Filter_Data");
tobeConverted.add("SLNO");
tobeConverted.add("Id");
tobeConverted.add("Route_Id");
tobeConverted.add("Route_Name");
tobeConverted.add("Route_Type");
tobeConverted.add("Excel");
tobeConverted.add("Delete");
tobeConverted.add("Route_Master_Information");
tobeConverted.add("No_Rows_Selected");
tobeConverted.add("Select_Single_Row");
tobeConverted.add("Modify_Details");
tobeConverted.add("Route_Master_Details");
tobeConverted.add("Enter_Route_ID");
tobeConverted.add("Enter_Route_Name");
tobeConverted.add("Enter_Route_Type");
tobeConverted.add("Save");
tobeConverted.add("Cancel");
//tobeConverted.add("This_Route_is_Already_Exists_Please_Select_Different_One");

ArrayList<String> convertedWords = new ArrayList<String>();
convertedWords = cf.getLanguageSpecificWordForKey(tobeConverted,language);

String RouteMaster=convertedWords.get(0);
String Add=convertedWords.get(1);
String Modify=convertedWords.get(2);
String CustomerName=convertedWords.get(3);
String SelectCustomerName=convertedWords.get(4);
String RouteMasterDetails=convertedWords.get(5);
String NoRecordsFound=convertedWords.get(6);
String ClearFilterData=convertedWords.get(7);
String SLNO=convertedWords.get(8);
String ID=convertedWords.get(9);
String RouteID=convertedWords.get(10);
String RouteName=convertedWords.get(11);
String RouteType=convertedWords.get(12);
String Excel=convertedWords.get(13);
String Delete=convertedWords.get(14);
String AddRouteMaster=convertedWords.get(15);
String NoRowsSelected=convertedWords.get(16);
String SelectSingleRow=convertedWords.get(17);
String ModifyDetails=convertedWords.get(18);
String AssociateRoute=convertedWords.get(19);
String SelectRouteID=convertedWords.get(20);
String SelectRouteName=convertedWords.get(21);
String SelectRouteType=convertedWords.get(22);
String Save=convertedWords.get(23);
String Cancel=convertedWords.get(24);
//String RouteisAlreadyExistsPleaseSelectDifferentOne=convertedWords.get(25);

%>
<jsp:include page="../Common/header.jsp" />
 		<title>Armory Pending</title>		
 
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
			}
			.x-layer ul {
				min-height: 27px !important;
			}
			.x-menu-list {
				height:auto !important;
			}
		</style>
	<%}%>
   <script>
   
var outerPanel;
var ctsb;
var jspName = "routeVehicleAssociation";
var exportDataType = "int,string,string,string,string,string,string";
var selected;
var grid;
var buttonValue;
var titelForInnerPanel;
var myWin;
var selectedVehicles = "-";
var selectedRouteId = null;
var selectedName = null;
var selectedType = null;

var clientcombostore = new Ext.data.JsonStore({
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
                custName=Ext.getCmp('custcomboId').getRawValue();
                store.load({
                    params: {
                        CustId: custId,
                        custName:custName,
                         jspName : jspName
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
    emptyText: '<%=SelectCustomerName%>',
    blankText: '<%=SelectCustomerName%>',
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
                custName= Ext.getCmp('custcomboId').getRawValue();
                store.load({
                    params: {
                        CustId: custId,
                        custName:custName,
                         jspName : jspName
                    }
                });
            }
        }
    }
});

var customerComboPanel = new Ext.Panel({
    standardSubmit: true,
    collapsible: false,
    id: 'customerComboPanelId',
    layout: 'table',
    frame: false,
    width: screen.width - 12,
    height: 40,
    layoutConfig: {
        columns: 13
    },
    items: [{
            xtype: 'label',
            text: '<%=CustomerName%>' + ' :',
            cls: 'labelstyle'
        },
        Client
        
    ]
});

var statuscombostore = new Ext.data.SimpleStore({
    id: 'statuscombostoreId',
    autoLoad: true,
    fields: ['Name', 'Value'],
    data: [
        ['Active', 'Active'],
        ['Inactive', 'Inactive']
    ]
});

var statuscombo = new Ext.form.ComboBox({
    store: statuscombostore,
    id: 'statuscomboId',
    mode: 'local',
    forceSelection: true,
    selectOnFocus: true,
    allowBlank: false,
    anyMatch: true,
    emptyText: 'Select Status',
    blankText: 'Select Status',
    typeAhead: false,
    triggerAction: 'all',
    lazyRender: true,
    valueField: 'Value',
    value: 'Active',
    displayField: 'Name',
    cls: 'selectstylePerfect'
});




var reader = new Ext.data.JsonReader({
    idProperty: 'ownMasterid',
    root: 'pendingArmories',
    totalProperty: 'total',
    fields: [{
        name: 'slnoIndex'
    }, {
        name: 'tripNo'
    }, {
        name: 'assetName'
    }, {
        name: 'assetNo'
    },{
        name: 'branchName'
    }, {
        name: 'customerName'
    }, {
        name: 'date'
    } ]
});

var store = new Ext.data.GroupingStore({
    autoLoad: false,
    proxy: new Ext.data.HttpProxy({
        url: '<%=request.getContextPath()%>/ArmoryAction.do?param=getPendingArmories',
        method: 'POST'
    }),
    storeId: 'pendingArmories',
    reader: reader
});

var filters = new Ext.ux.grid.GridFilters({
    local: true,
    filters: [{
     type:'int',
        name: 'slnoIndex'
    }, {
    type:'numeric',
        dataIndex: 'tripNo'
    }, {
      type:'string',
        dataIndex: 'assetName'
    }, {
      type:'string',
        dataIndex: 'assetNo'
    }, {
      type:'string',
        dataIndex: 'branchName'
    }, {
      type:'string',
        dataIndex: 'customerName'
    }, {
      type:'date',
        dataIndex: 'date'
    }]
});
var createColModel = function(finish, start) {
    var columns = [
        new Ext.grid.RowNumberer({
            header: "<span style=font-weight:bold;><%=SLNO%></span>",
            width: 50
        }),  {
        header: "<span style=font-weight:bold;><%=SLNO%></span>",
        hidden:true,
            dataIndex: 'slnoIndex',
            width: 50,
            filter: {
                type: 'int'
            }
        },  {
            header: "<span style=font-weight:bold;>Trip Number</span>",
            dataIndex: 'tripNo',
            width: 50,
            filter: {
                type: 'numeric'
            }
        },  {
            header: "<span style=font-weight:bold;>Asset Name</span>",
            dataIndex: 'assetName',
            width: 50,
            filter: {
                type: 'string'
            }
        } ,{
            header: "<span style=font-weight:bold;>Asset Number</span>",
            dataIndex: 'assetNo',
            width: 50,
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;>Branch</span>",
            dataIndex: 'branchName',
            width: 50,
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;>Customer</span>",
            dataIndex: 'customerName',
            width: 50,
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;>Date</span>",
            dataIndex: 'date',
            width: 50,
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

grid = getGrid('Armory Pending', '<%=NoRecordsFound%>', store, screen.width-40, 550, 10, filters,'', false, '', 7, false, '', false, '', true, '<%=Excel%>',jspName, exportDataType,'Pdf',true);

Ext.onReady(function() {
    Ext.QuickTips.init();
    Ext.form.Field.prototype.msgTarget = 'side';
    outerPanel = new Ext.Panel({
        title: 'Armory Pending',
        renderTo: 'content',
        standardSubmit: true,
        frame: true,
        width: screen.width - 20,
        height: 550,
        cls: 'outerpanel',
        layout: 'table',
        layoutConfig: {
            columns: 1
        },
        items: [customerComboPanel, grid]
    });
    sb = Ext.getCmp('form-statusbar');
});


$( ".clearfilterbutton" ).hide();
</script>

 <jsp:include page="../Common/footer.jsp" />
 <!-- </body>   -->
 <!-- </html> -->