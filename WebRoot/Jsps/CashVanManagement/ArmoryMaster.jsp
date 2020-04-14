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
 		<title>Armory/Stationary Items</title>		
  
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
		.ext-strict .x-form-text {
			height: 21px !important;
		}
		label {
			display : inline !important;
		}
		.x-layer ul {
		 	min-height: 27px !important;
		}
   </style>
   <script>
   
var outerPanel;
var ctsb;
var jspName = "routeVehicleAssociationDetails";
var exportDataType = "";
var selected;
var grid;
var buttonValue;
var titelForInnerPanel;
var myWin;
var selectedVehicles = "-";
var selectedRouteId = null;
var selectedName = null;
var selectedType = null;
var isactive='Armory';
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
                store.load({
                    params: {
                        CustId: custId
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
                store.load({
                    params: {
                        CustId: custId
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
        columns: 24
    },
    items: [{
            xtype: 'label',
            text: '<%=CustomerName%>' + ' :',
           style:'vertical-align: -webkit-baseline-middle',
            cls: 'labelstyle',
        },
        Client,
        {
        xtype: 'label',
            text: '  ',
            cls: 'labelstyle'
        },
          {
        xtype: 'label',
            text: '  ',
            cls: 'labelstyle'
        },
          {
        xtype: 'label',
            text: '  ',
            cls: 'labelstyle'
        },
        {
        xtype: 'label',
            text: 'Asset Name' + ' : ',
             style:'vertical-align: -webkit-baseline-middle',
            cls: 'labelstyle'
        },
          {
        xtype: 'label',
            text: '  ',
            cls: 'labelstyle'
        },
        {
        xtype: 'textfield',
        id:'itemTextId',
        allowBlank: false,
        margin: '10 0 0 0',
         maskRe: /^[a-zA-Z0-9_ ]*$/
        },
       {
        xtype: 'label',
            text: '  ',
            cls: 'labelstyle'
        }, {
        xtype: 'label',
            text: ' ',
            cls: 'labelstyle'
        },
        
       {
            xtype: 'label',
            text: '',
            //cls: 'mandatoryfield',
            id: 'id1'
        },{
           
            xtype: 'radio',
            id:'radio1',
            text     : ' ',
        	width    : 30,
        	checked  : true,
        	name     : 'option',
   	        value	: 'Armory',
   	        style:'margin-left:20px',
            listeners: {
     	    check : function(){
            if(this.checked){
            isactive = 'Armory'
           }
           }
           }
        },{
         xtype: 'label',
            text: 'Armory ' ,
            style:'vertical-align: -webkit-baseline-middle',
            cls: 'labelstyle',
            id: 'companyNameLabelId',
        }, {width:20
        },{
           
            xtype: 'radio',
            id:'radio2',
            text     : '   ',
   			width    : 30,
		  	checked  : false,
		  	name     : 'option',
   			value	: 'Stationary',
   			style:'margin-left:20px',  	
    	  	listeners: {
     	  	check : function(){
          	if(this.checked){
          	isactive = 'Stationary';        
           }
           }
           }           
        },{
         xtype: 'label',
            text: ' Stationary ',
            style:'vertical-align: -webkit-baseline-middle',
            cls: 'labelstyle',
            id: 'companyNameLabelId2'
        },
        
        {
        width:20
        },
        {
        	xtype: 'button',
        	text: 'Submit',
        	width:50,
          	listeners: {
    		click: function() {
    			var j = Ext.getCmp('itemTextId').getValue();
    			if(j==null || j==''|| Ext.util.Format.trim(j)==''){
    			Ext.example.msg('Item name can not be empty');
    			return;
   		 }
    	    addRecord();
    	}
       	} 
        }]
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



function addRecord() {
    if (Ext.getCmp('custcomboId').getValue() == "") {
     Ext.example.msg("<%=SelectCustomerName%>");
        return;
    }
    var itemName=Ext.getCmp('itemTextId').getValue();
    buttonValue = '<%=Add%>';
         Ext.Ajax.request({
                            url: '<%=request.getContextPath()%>/ArmoryAction.do?param=additem',
                            method: 'POST',
                            params: {
                                buttonValue: buttonValue,
                                CustId: Ext.getCmp('custcomboId').getValue(),
                                item: Ext.getCmp('itemTextId').getValue(),
                                armory: isactive     
                            },
                            success: function(response, options) {
                                var message = response.responseText;
                                custId = Ext.getCmp('custcomboId').getValue();
                store.load({
                    params: {
                        CustId: custId
                    }
                });
                                 Ext.example.msg(message);
                                Ext.getCmp('itemTextId').reset();
                               
                              
                            },
                            failure: function() {
                                Ext.example.msg("Error");
                               
                            }
                        });
}

function modifyData() {
}
var reader = new Ext.data.JsonReader({
    idProperty: 'ownMasterid',
    root: 'armoryItems',
    totalProperty: 'total',
    fields: [{
        name: 'slnoIndex'
    }, {
        name: 'itemName'
    }, {
        name: 'type'
    }]
});

var store = new Ext.data.GroupingStore({
    autoLoad: false,
    proxy: new Ext.data.HttpProxy({
        url: '<%=request.getContextPath()%>/ArmoryAction.do?param=armoryStationaryItems',
        method: 'POST'
    }),
    storeId: 'armoryItemsId',
    reader: reader
});

var filters = new Ext.ux.grid.GridFilters({
    local: true,
    filters: [ {
        type: 'string',
        dataIndex: 'itemName'
    },{
        type: 'string',
        dataIndex: 'type'
    }]
});
var createColModel = function(finish, start) {
    var columns = [
        new Ext.grid.RowNumberer({
            header: "<span style=font-weight:bold;><%=SLNO%></span>",
            width: 50
        }),  {
            header: "<span style=font-weight:bold;>Item Name</span>",
            dataIndex: 'itemName',
            width: 50,
            filter: {
                type: 'string'
            }
        },  {
            header: "<span style=font-weight:bold;>Type</span>",
            dataIndex: 'type',
            width: 50,
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

grid = getGrid('Items', '<%=NoRecordsFound%>', store, screen.width - 40, 440, 8, filters, '', false, '', 16, false, '', false, '', false, '', jspName, '', false, '', false, '', false, '', false, '');

Ext.onReady(function() {
    Ext.QuickTips.init();
    Ext.form.Field.prototype.msgTarget = 'side';
    outerPanel = new Ext.Panel({
        title: 'Armory/Stationary Master',
        renderTo: 'content',
        standardSubmit: true,
        frame: true,
        width: screen.width - 22,
        cls: 'outerpanel',
        layout: 'table',
        layoutConfig: {
            columns: 1
        },
        items: [customerComboPanel, grid]
    });
    sb = Ext.getCmp('form-statusbar');
});



</script>
 <jsp:include page="../Common/footer.jsp" />
 <!-- </body>   -->
 <!-- </html> -->