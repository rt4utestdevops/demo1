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

tobeConverted.add("Select_Customer_Name");
tobeConverted.add("Add");
tobeConverted.add("Clear_Filter_Data");
tobeConverted.add("Save");
tobeConverted.add("Cancel");
tobeConverted.add("SLNO");
tobeConverted.add("No_Records_Found");
tobeConverted.add("Excel");
tobeConverted.add("Customer_Name");
tobeConverted.add("Select_Asset_Number");
tobeConverted.add("Select_Command_Type");
tobeConverted.add("Please_Select_Command_Type");
tobeConverted.add("Please_Select_Asset_Number");
tobeConverted.add("Please_Select_customer");
tobeConverted.add("Distance(KMs)");
tobeConverted.add("DateTime");
tobeConverted.add("Location");
tobeConverted.add("Action_Time");
tobeConverted.add("Status");
tobeConverted.add("Asset_Number");
tobeConverted.add("Fuel");
tobeConverted.add("OBD_Fuel_Consumption");
tobeConverted.add("OBD_Fuel_Consumption_Details");
tobeConverted.add("Add_KLE_Request");
tobeConverted.add("KLE_Request_Information");

tobeConverted.add("Start_Date");
tobeConverted.add("Select_Start_Date");
tobeConverted.add("End_Date");
tobeConverted.add("Select_End_Date");
tobeConverted.add("View");
tobeConverted.add("Month_Validation");
tobeConverted.add("Request_Id");
tobeConverted.add("Command_Mode");

ArrayList<String> convertedWords = new ArrayList<String>();
convertedWords = cf.getLanguageSpecificWordForKey(tobeConverted,language);

String SelectCustomerName=convertedWords.get(0);
String Add=convertedWords.get(1);
String ClearFilterData=convertedWords.get(2);
String Save=convertedWords.get(3);
String Cancel=convertedWords.get(4);
String SLNO=convertedWords.get(5);
String NoRecordsFound=convertedWords.get(6);
String Excel=convertedWords.get(7);
String CustomerName=convertedWords.get(8);
String SelectAssetNumber=convertedWords.get(9);
String SelectCommandType=convertedWords.get(10);
String PleaseSelectCommandType=convertedWords.get(11);
String PleaseSelectAssetNumber=convertedWords.get(12);
String PleaseSelectCustomer=convertedWords.get(13);
String Distance=convertedWords.get(14);
String DateTime=convertedWords.get(15);
String Location=convertedWords.get(16);
String ActionTime=convertedWords.get(17);
String Status=convertedWords.get(18);
String AssetNumber=convertedWords.get(19);
String Fuel=convertedWords.get(20);
String OBDFuelConsumption=convertedWords.get(21);
String OBDFuelConsumptionDetails=convertedWords.get(22);
String AddKLERequest=convertedWords.get(23);
// String OBDFuelConsumptionInformation="OBD Fuel Consumption Details";//convertedWords.get(24);

String StartDate = convertedWords.get(25);
String SelectStartDate = convertedWords.get(26);
String EndDate = convertedWords.get(27);
String SelectEndDate = convertedWords.get(28);
String View = convertedWords.get(29);
String monthValidation = convertedWords.get(30);
String RequestId= convertedWords.get(31);
String CommandMode=convertedWords.get(32);
%>

<jsp:include page="../Common/header.jsp" />   
	 <style>
  .x-panel-tl
	{
		border-bottom: 0px solid !important;
	}
	.fieldsetpanel{
	width:470px;
}
.x-form-cb-label {
    position: relative;
    margin-left:4px;
    top: 2px;
    font-size:13px;
    font-family: sans-serif;
}
.labelstyle {
	spacing: 10px;
	height: 20px;
	width: 150 px !important;
	min-width: 150px !important;
	margin-bottom: 5px !important;
	margin-left: 5px !important;
	font-size: 12px;
	font-family: sans-serif;
	font-weight:bold;
}
.x-form-field-wrap .x-form-trigger{
	height: 18px !important;
}


  </style>
 
   	<%if (loginInfo.getStyleSheetOverride().equals("Y")){%>
	<jsp:include page="../Common/ImportJSSandMining.jsp"/>
	<%}else {%>
	<jsp:include page="../Common/ImportJS.jsp" /><%}%>
    <jsp:include page="../Common/ExportJS.jsp" />
	<style>
		label{
			display : inline !important;
		}
		.x-layer ul {
			min-height: 27px !important;	
		}
		.x-menu-list {
			height:auto !important;
		}
		.x-window-tl *.x-window-header {
			padding-top : 6px !important;			
		}
	</style>
<script>
var outerPanel;
var ctsb;
var jspName = "OBDFuelConsumption";
var exportDataType = "int,string,number,number,string";
var selected;
var grid;
var buttonValue;
var titelForInnerPanel;
var myWin;
var doorChecked=0;
var keyChecked=0;

var regStore= new Ext.data.JsonStore({
	   url:'<%=request.getContextPath()%>/OBDAction.do?param=getRegNos',
	   root: 'RegNos',
	   autoLoad: true,
	   fields: ['Registration_no']
	});
			     
			     
var vehicleNumber = new Ext.form.ComboBox({
	  frame:true,
	 store: regStore,
	 id:'VehicleNumberId',
	 width: 180,
	 cls: 'selectstylePerfect',
	 hidden:false,
	 anyMatch:true,
	 onTypeAhead:true,
	 forceSelection:true,
	 enableKeyEvents:true,
	 mode: 'local',
	 emptyText:'<%=SelectAssetNumber%>',
	 blankText:'<%=SelectAssetNumber%>',
	 triggerAction: 'all',
	 displayField: 'Registration_no',
	 valueField: 'Registration_no',
	 listeners: {
		select: {
		fn:function(){
		   store.load({params: {vehicleNo: ''}});              	   
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
    width: screen.width - 40,
    height: 40,
    layoutConfig: {
        columns: 11
    },
    items: [{width:30},{
            	xtype: 'label',
            	text: '<%=AssetNumber%>' + ' :',
            	cls: 'labelstyle'
        	},
        	vehicleNumber,{width:30},
        	{
  		        xtype: 'label',
  		        cls: 'labelstyle',
  		        id: 'startdatelab',
  				text: '<%=StartDate%>' + ' :'
  			},{
  		        xtype: 'datefield',
  		        cls: 'selectstylePerfect',
  		        width: 185,
  		        format: getDateTimeFormat(),
  		        emptyText: '<%=SelectStartDate%>',
  		        allowBlank: false,
  		        blankText: '<%=SelectStartDate%>',
  		        id: 'startdate',
  		        vtype: 'daterange',
  		        endDateField: 'enddate',
  		        listeners: {
             		'change' : function(field, newValue, oldValue) {
						store.load({params: {vehicleNo: ''}});
            		}
        		}
  		    },{width: 60}, 
  		    {
  		        xtype: 'label',
  		        cls: 'labelstyle',
  		        id: 'enddatelab',
  		        text: '<%=EndDate%>' + ' :'
  		    },{
  		        xtype: 'datefield',
  		        cls: 'selectstylePerfect',
  		        width: 185,
  		        format: getDateTimeFormat(),
  		        emptyText: '<%=SelectEndDate%>',
  		        allowBlank: false,
  		        blankText: '<%=SelectEndDate%>',
  		        id: 'enddate',
  		        vtype: 'daterange',
  		        startDateField: 'startdate',
  		        listeners: {
             		'change' : function(field, newValue, oldValue) {
						store.load({params: {vehicleNo: ''}});
            		}
        		}
  		    },{width: 30},
  		    {
  		        xtype: 'button',
  		        text: '<%=View%>',
  		        id: 'addbuttonid',
  		        cls: ' ',
  		        width: 80,
  		        listeners: {
  		                click: {
  		                    fn: function () {
  		                        if (Ext.getCmp('VehicleNumberId').getValue() == "") {
			                        Ext.example.msg("<%=PleaseSelectAssetNumber%>");
			                        Ext.getCmp('VehicleNumberId').focus();
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
  		                        var startdates = Ext.getCmp('startdate').getValue();
  		                        var enddates = Ext.getCmp('enddate').getValue();
  		                        
  		                        
  		                        if (checkMonthValidation(startdates, enddates)) {
  		                            Ext.example.msg("<%=monthValidation%>");
  		                            Ext.getCmp('enddate').focus();
  		                            return;
  		                        }
  		                        store.load({
                                    params: {
                                        vehicleNo: Ext.getCmp('VehicleNumberId').getValue(),
  		                                startdate: Ext.getCmp('startdate').getValue(),
  		                                enddate: Ext.getCmp('enddate').getValue(),
  		                                jspName:jspName,
                                    }
                                });
  		                    }
  		                }
  		            }
  		    }
    ]
});

var reader = new Ext.data.JsonReader({
    idProperty: 'OBDFuelConsumptionid',
    root: 'OBDFuelConsumptionRoot',
    totalProperty: 'total',
    fields: [{
        name: 'slnoIndex'
    }, {
        name: 'registrationNoDataIndex'
    }, {
        name: 'distanceDataIndex'
    }, {
        name: 'fuelDataIndex'
    },{
    	name: 'fuelDateDataIndex'
    } ]
});

var store = new Ext.data.GroupingStore({
    autoLoad: false,
    proxy: new Ext.data.HttpProxy({
        url: '<%=request.getContextPath()%>/OBDAction.do?param=getOBDFuelReport',
        method: 'POST'
    }),
    storeId: 'ODBDFuelId',
    reader: reader
});

var filters = new Ext.ux.grid.GridFilters({
    local: true,
    filters: [{
        type: 'numeric',
        dataIndex: 'slnoIndex'
    }, {
        type: 'string',
        dataIndex: 'registrationNoDataIndex'
    }, {
        type: 'numeric',
        dataIndex: 'distanceDataIndex'
    }, {
        type: 'numeric',
        dataIndex: 'fuelDataIndex'
    },{
        type: 'date',
        dataIndex: 'fuelDateDataIndex'
    }]
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
            header: "<span style=font-weight:bold;><%=AssetNumber%></span>",
            dataIndex: 'registrationNoDataIndex',
            width: 100,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=Distance%></span>",
            dataIndex: 'distanceDataIndex',
            width: 100,
            filter: {
                type: 'numeric'
            }
        },{
            header: "<span style=font-weight:bold;><%=Fuel%></span>",
            dataIndex: 'fuelDataIndex',
            width: 100,
            filter: {
                type: 'numeric'
            }
        },{
        	 header: "<span style=font-weight:bold;>Date</span>",
        	 dataIndex: 'fuelDateDataIndex',
            renderer: Ext.util.Format.dateRenderer(getDateFormat()),
            width: 150,
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
//*****************************************************************Grid *******************************************************************************
grid = getGrid('', '<%=NoRecordsFound%>', store, screen.width - 40, 410, 14, filters, '<%=ClearFilterData%>', false, '', 16, false, '', false, '', true, '<%=Excel%>', jspName, exportDataType, false, 'PDF', false, '<%=Add%>');
//******************************************************************************************************************************************************
Ext.onReady(function () {
    ctsb = tsb;
    Ext.QuickTips.init();
    Ext.form.Field.prototype.msgTarget = 'side';
    outerPanel = new Ext.Panel({
        title: '<%=OBDFuelConsumption%>',
        renderTo: 'content',
        standardSubmit: true,
        frame: true,
        width: screen.width-28,
        height: 510,
        cls: 'outerpanel',
        layout: 'table',
        layoutConfig: {
            columns: 1
        },
        items: [customerComboPanel, grid]
        //bbar: ctsb
    });
    sb = Ext.getCmp('form-statusbar');
});</script>
 <jsp:include page="../Common/footer.jsp" />
 <!-- </body>   -->
 <!-- </html> -->
    
    
    
    
    

