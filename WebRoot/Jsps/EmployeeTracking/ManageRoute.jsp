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
tobeConverted.add("Modify");
tobeConverted.add("No_Rows_Selected");
tobeConverted.add("Select_Single_Row");
tobeConverted.add("Clear_Filter_Data");
tobeConverted.add("Save");
tobeConverted.add("Cancel");
tobeConverted.add("SLNO");
tobeConverted.add("No_Records_Found");
tobeConverted.add("Excel");
tobeConverted.add("Id");
tobeConverted.add("Modify_Details");
tobeConverted.add("Customer_Name");
tobeConverted.add("Are_you_sure_you_want_to_delete");
tobeConverted.add("Delete");
tobeConverted.add("Not_Deleted");
tobeConverted.add("Route_Details");
tobeConverted.add("Route_Code");
tobeConverted.add("Start_Time_HHMM");
tobeConverted.add("End_Time_HHMM");
tobeConverted.add("Approximate_Distance_Kms");
tobeConverted.add("Asset_Number");
tobeConverted.add("Add_Details");
tobeConverted.add("Start_Time");
tobeConverted.add("End_Time");
tobeConverted.add("Approximate_Distance");
tobeConverted.add("Approximate_Time");
tobeConverted.add("ETMS_Manage_Route");
tobeConverted.add("Enter_Start_Time");
tobeConverted.add("End_Time_Must_Be_Greater_Than_Start_Time");
tobeConverted.add("Enter_End_Time");
tobeConverted.add("Enter_Approximate_Distance");
tobeConverted.add("Enter_Approximate_Time");
tobeConverted.add("Select_Vehicle_Number");
tobeConverted.add("Validate_Mesg_For_Form");
tobeConverted.add("Enter_Route_Code");
tobeConverted.add("Error");
tobeConverted.add("Approximate_Time_HHMM");
tobeConverted.add("Select_Type");
tobeConverted.add("Type");
tobeConverted.add("Pick_Up");
tobeConverted.add("Drop");
tobeConverted.add("Updated_Time");
ArrayList<String> convertedWords = new ArrayList<String>();
convertedWords = cf.getLanguageSpecificWordForKey(tobeConverted,language);

String SelectCustomerName=convertedWords.get(0);
String Add=convertedWords.get(1);
String Modify=convertedWords.get(2);
String NoRowSelected=convertedWords.get(3);
String SelectSingleRow=convertedWords.get(4);
String ClearFilterData=convertedWords.get(5);
String Save=convertedWords.get(6);
String Cancel=convertedWords.get(7);
String SlNo=convertedWords.get(8);
String NoRecordFound=convertedWords.get(9);
String Excel=convertedWords.get(10);
String Id=convertedWords.get(11);
String ModifyDetails=convertedWords.get(12);
String CustomerName=convertedWords.get(13);
String AreYouSureWantToDelete=convertedWords.get(14);
String Delete=convertedWords.get(15);
String NotDeleted=convertedWords.get(16);
String RouteDetails=convertedWords.get(17);
String RouteCode=convertedWords.get(18);
String StartTimeHHMM=convertedWords.get(19);
String EndTimeHHMM=convertedWords.get(20);
String ApproximateDistanceKms=convertedWords.get(21);
String AssetNumber=convertedWords.get(22);
String AddDetails=convertedWords.get(23);
String StartTime=convertedWords.get(24);
String EndTime=convertedWords.get(25);
String ApproximateDistance=convertedWords.get(26);
String ApproximateTime=convertedWords.get(27);
String ManageRoute=convertedWords.get(28);
String EnterStartTime=convertedWords.get(29);
String ValidateMsg=convertedWords.get(30);
String EnterEndTime=convertedWords.get(31);
String EnterApproximateDistance=convertedWords.get(32);
String EnterApproximateTime=convertedWords.get(33);
String SelectVehicleNumber=convertedWords.get(34);
String ValidateMsg1=convertedWords.get(35);
String EnterRouteCode=convertedWords.get(36);
String Error=convertedWords.get(37);
String ApproximateTimeHHMM=convertedWords.get(38);
String SelectType=convertedWords.get(39);
String Type=convertedWords.get(40);
String PickUp=convertedWords.get(41);
String Drop=convertedWords.get(42);
String Updated_Datetime=convertedWords.get(43);

%>

<jsp:include page="../Common/header.jsp" />
 		<title><%=ManageRoute%></title>		

	 <style>
  .x-panel-tl
	{
		border-bottom: 0px solid !important;
	}
	label {
		display: inline !important;
	}
  </style>
    <%if (loginInfo.getStyleSheetOverride().equals("Y")){%>
	<jsp:include page="../Common/ImportJSSandMining.jsp"/>
	<%}else {%>
	<jsp:include page="../Common/ImportJS.jsp" /><%} %>
   	<jsp:include page="../Common/ExportJS.jsp" />
	<style>
		.ext-strict .x-form-text {
			height: 21px !important;
		}
		.x-window-tl *.x-window-header {
			height: 38px !important;
		}
		fieldset#RouteInformationId {
			width : 350px !important;
		}
		.x-layer ul {
		 	min-height:27px !important;
		}
	</style>
<script>
var outerPanel;
var ctsb;
var jspName = "ManageRoute";
var selected;
var grid;
var buttonValue;
var titelForInnerPanel;
var myWin;
var pickUpDropStore;
var exportDataType = "int,string,string,string,string,string,string,string,string,int";
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

            }
            store.load({
                    params: {
                        CustId: custId,
                        jspName:jspName,
                        custName:Ext.getCmp('custcomboId').getRawValue()
                    }
                });
        }
    }
});
var regStore= new Ext.data.JsonStore({
				   url:'<%=request.getContextPath()%>/ManageRouteAction.do?param=getRegNos',
			       root: 'RegNos',
			       autoLoad: false,
				   fields: ['Registration_no']
				   
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
            fn: function () {
                custId = Ext.getCmp('custcomboId').getValue();
                store.load({
                    params: {
                         CustId: custId,
                         jspName:jspName,
                         custName:Ext.getCmp('custcomboId').getRawValue()
                    }
                });
            }
        }
    }
});
    if(<%=systemId%> ==105){
     pickUpDropStore = new Ext.data.SimpleStore({
            id: 'pickUpDropId',
            fields: ['Name'],
            autoLoad: true,
            data:[ ['PickUp-P1'],['PickUp-P2'],
            [ 'Drop-D1'],[ 'Drop-D2']]
        });
    }
    else{
    
   pickUpDropStore = new Ext.data.SimpleStore({
            id: 'pickUpDropId',
            fields: ['Name'],
            autoLoad: true,
            data:[ ['PickUp'],
            [ 'Drop']]
        });
    }
    
        
var vehicleNumber = new Ext.form.ComboBox({
	  frame:true,
	 store:regStore,
	 id:'VehicleNumberId',
	 width: 150,
	 cls: 'selectstylePerfect',
	 hidden:false,
	 anyMatch:true,
	 onTypeAhead:true,
	 forceSelection:true,
	 enableKeyEvents:true,
	 mode: 'local',
	 emptyText:'<%=SelectVehicleNumber%>',
	 triggerAction: 'all',
	 displayField: 'Registration_no',
	 valueField: 'Registration_no',
	 listeners: {
		                   select: {
		                 	   fn:function(){
		                 	   vehicleId = Ext.getCmp('VehicleNumberId').getValue();
		                 	   }
		                 	  }
		                    }	    
                        }); 
                        
var pickDrop = new Ext.form.ComboBox({
	  frame:true,
	 store:pickUpDropStore,
	 id:'pudId',
	 width: 150,
	 cls: 'selectstylePerfect',
	 hidden:false,
	 anyMatch:true,
	 onTypeAhead:true,
	 forceSelection:true,
	 enableKeyEvents:true,
	 mode: 'local',
	 emptyText:'<%=SelectType%>',
	 triggerAction: 'all',
	 displayField: 'Name',
	 valueField: 'Name',
	 listeners: {
		                   select: {
		                 	   fn:function(){
		                 	   pickDropValue = Ext.getCmp('pudId').getValue();
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
    height: 50,
    layout: 'table',
    layoutConfig: {
        columns: 3
    },
    items: [{
            xtype: 'label',
            text: '<%=CustomerName%>' + ' :',
            cls: 'labelstyle'
        },{width:10},
        Client
        
    ]
});
var reader = new Ext.data.JsonReader({
    idProperty: 'manageRouteId',
    root: 'routeDetails',
    totalProperty: 'total',
    fields: [{
        name: 'slnoIndex'
    }, {
        name: 'routeCodeIndex'
    }, {
        name: 'startTimeIndex'
    }, {
        name: 'endTimeIndex'
    },{
        name: 'approximateDistanceIndex'
    },{
        name: 'approximateTimeIndex'
    },{
        name: 'assetNumberIndex'
    }, {
        name: 'pickDropDataIndex'
    },{
        name: 'updatedDatetimeDataIndex'
    },{
        name: 'idDataIndex'
    }
     ]
});
var filters = new Ext.ux.grid.GridFilters({
    local: true,
    filters: [{
        type: 'numeric',
        dataIndex: 'slnoIndex'
    },{
        type: 'string',
        dataIndex: 'routeCodeIndex'
    },{
        type: 'string',
        dataIndex: 'startTimeIndex'
    },{
        type: 'string',
        dataIndex: 'endTimeIndex'
    },{
        type: 'string',
        dataIndex: 'approximateDistanceIndex'
    },{
        type: 'string',
        dataIndex: 'approximateTimeIndex'
    },{
        type: 'string',
        dataIndex: 'assetNumberIndex'
    },{
        type: 'string',
        dataIndex: 'pickDropDataIndex'
    },{
        type: 'date',
        dataIndex: 'updatedDatetimeDataIndex'
    },{
        type: 'int',
        dataIndex: 'idDataIndex'
    } ]
});
var store = new Ext.data.GroupingStore({
    autoLoad: false,
    proxy: new Ext.data.HttpProxy({
        url: '<%=request.getContextPath()%>/ManageRouteAction.do?param=getRouteDetails',
        method: 'POST'
    }),
    storeId: 'manageRouteId',
    reader: reader
});

var createColModel = function (finish, start) {
    var columns = [
        new Ext.grid.RowNumberer({
            header: "<span style=font-weight:bold;><%=SlNo%></span>",
            width: 50
        }), {
            dataIndex: 'slnoIndex',
            hidden: true,
            header: "<span style=font-weight:bold;><%=SlNo%></span>",
            filter: {
                type: 'numeric'
            }
        }, {
            header: "<span style=font-weight:bold;><%=RouteCode%></span>",
            dataIndex: 'routeCodeIndex',
            width: 30,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=StartTimeHHMM%></span>",
            dataIndex: 'startTimeIndex',
            width: 30,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=EndTimeHHMM%></span>",
            dataIndex: 'endTimeIndex',
            width: 30,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=ApproximateDistanceKms%></span>",
            dataIndex: 'approximateDistanceIndex',
            width: 30,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=ApproximateTimeHHMM%></span>",
            dataIndex: 'approximateTimeIndex',
            width: 30,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=AssetNumber%></span>",
            dataIndex: 'assetNumberIndex',
            width: 30,
            filter: {
                type: 'string'
            }
        }, 
            {
            header: "<span style=font-weight:bold;><%=Type%></span>",
            dataIndex: 'pickDropDataIndex',
            width: 30,
            filter: {
                type: 'string'
            }
            },
            {
            header: "<span style=font-weight:bold;><%=Updated_Datetime%></span>",
            dataIndex: 'updatedDatetimeDataIndex',
            width: 30,
            filter: {
                type: 'date'
            }
        },{
            header: "<span style=font-weight:bold;><%=Id%></span>",
            dataIndex: 'idDataIndex',
            hidden: true,
            width: 100,
            filter: {
                type: 'int'
            }
        }];
    return new Ext.grid.ColumnModel({
        columns: columns.slice(start || 0, finish),
        defaults: {
            sortable: true
        }
    });
};
var innerPanelForRouteDetails = new Ext.form.FormPanel({
    standardSubmit: true,
    collapsible: false,
    autoScroll: true,
    height: 270,
    width: 430,
    frame: true,
    id: 'innerPanelForRouteDetailsId',
    layout: 'table',
    layoutConfig: {
        columns: 4
    },
    items: [{
        xtype: 'fieldset',
        title: '<%=RouteDetails%>',
        cls: 'fieldsetpanel',
        collapsible: false,
        id: 'RouteInformationId',
        width: 350,
        layout: 'table',
        layoutConfig: {
            columns: 4
        },
        items: [ 
        {
            xtype: 'label',
            text: '<%=RouteCode%>' + ' :',
            cls: 'labelstyle',
            id: 'Id1'
        },{
            xtype: 'label',
            text: ' ',
            cls: 'mandatoryfield',
            id: 'Id2'
        }, {
            xtype: 'textfield',
            cls: 'selectstylePerfect',
            allowBlank: false,
            blankText: '<%=EnterRouteCode%>',
            emptyText: '<%=EnterRouteCode%>',
            labelSeparator: '',
            allowBlank: false,
            id: 'routeCodeId'
        },{
            xtype: 'label',
            text: ' ',
            cls: 'mandatoryfield',
            id: 'Id3'
        },
        {
            xtype: 'label',
            text: '<%=StartTime%>' + ' :',
            cls: 'labelstyle',
            id: 'startTimeLabelId'
        },{
            xtype: 'label',
            text: ' ',
            cls: 'mandatoryfield',
            id: 'Id4'
        },{
            xtype: 'textfield',
            cls: 'selectstylePerfect',
            blankText: '<%=EnterStartTime%>',
            emptyText: '<%=EnterStartTime%>',
            allowBlank: false,
            regex:/^([0-1][0-9]|2[0-3]):([0-5][0-9])?$/,
            regexText:'Enter valid format eg,(HH:MM)',
            labelSeparator: '',
            allowBlank: false,
            id: 'startTimeId'
        },{
            html:'(HH:MM)',
            id: 'Id5'
        },
        {
            xtype: 'label',
            text: '<%=EndTime%>' + ' :',
            cls: 'labelstyle',
            id: 'endTimeLabelId'
        },{
            xtype: 'label',
            text: ' ',
            cls: 'mandatoryfield',
            id: 'Id6'
        }, {
            xtype: 'textfield',
            cls: 'selectstylePerfect',
            blankText: '<%=EnterEndTime%>',
            emptyText: '<%=EnterEndTime%>',
            allowBlank: false,
            regex:/^([0-1][0-9]|2[0-3]):([0-5][0-9])?$/,
            regexText:'Enter valid format eg,(HH:MM)',
            labelSeparator: '',
            allowBlank: false,
            id: 'endTimeId'
        },{
            html:'(HH:MM)',
            id: 'Id7'
        }, 
        {
            xtype: 'label',
            text: '<%=ApproximateDistance%>'+':',
            cls: 'labelstyle',
            id: 'approximateDistanceLabelId'
        },{
            xtype: 'label',
            text: ' ',
            cls: 'mandatoryfield',
            id: 'Id8'
        }, {
            xtype: 'numberfield',
            cls:'selectstylePerfect',
	    	blankText:'<%=EnterApproximateDistance%>',
	    	emptyText:'<%=EnterApproximateDistance%>',
            id: 'approximateDistanceId'
        }, {
            html:'(Kms)',
            id: 'Id9'
        },{
            xtype: 'label',
            text: '<%=ApproximateTime%>' + ' :',
            cls: 'labelstyle',
            id: 'approximateTimeLabelId'
        }, {
            xtype: 'label',
            text: ' ',
            cls: 'mandatoryfield',
            id: 'Id10'
        }, {
            xtype: 'textfield',
            cls: 'selectstylePerfect',
            allowBlank: false,
            blankText: '<%=EnterApproximateTime%>',
            emptyText: '<%=EnterApproximateTime%>',
            regex:/^([0-1][0-9]|2[0-3]):([0-5][0-9])?$/,
            regexText:'Enter valid format eg,(HH:MM)',
            labelSeparator: '',
            maxLength : 20,
            id: 'approximateTimeId'
        },
        {
            html:'(HH:MM)',
            id: 'Id11'
        },{
            xtype: 'label',
            text: '<%=AssetNumber%>' + ' :',
            cls: 'labelstyle',
            id: 'assetNumberLabelId'
        },{
            xtype: 'label',
            text: ' ',
            cls: 'mandatoryfield',
            id: 'Id12'
        }, vehicleNumber,{
            xtype: 'label',
            text: ' ',
            cls: 'mandatoryfield',
            id: 'Id13'
        },{
            xtype: 'label',
            text: '<%=Type%>' + ' :',
            cls: 'labelstyle',
            id: 'typeLabelId'
        },{
            xtype: 'label',
            text: ' ',
            cls: 'mandatoryfield',
            id: 'Id14'
        }, pickDrop,{
            xtype: 'label',
            text: ' ',
            cls: 'mandatoryfield',
            id: 'Id15'
        }
        ]
    }]
});

var innerWinButtonPanel = new Ext.Panel({
    id: 'innerWinButtonPanelId',
    standardSubmit: true,
    collapsible: false,
    autoHeight: true,
    height: 10,
    width: 350,
    frame: true,
    layout: 'table',
    layoutConfig: {
        columns: 4
    },
    buttons: [{
        xtype: 'button',
        text: '<%=Save%>',
        iconCls:'savebutton',
        id: 'saveButtonId',
        cls: 'buttonstyle',
        width: 70,
        listeners: {
            click: {
                fn: function () {
                    if (Ext.getCmp('routeCodeId').getValue() == "") {
                        Ext.example.msg("<%=EnterRouteCode%>");
                        Ext.getCmp('routeCodeId').focus();
                        return;
                    }
                    if (Ext.getCmp('startTimeId').getValue() == "") {
                        Ext.example.msg("<%=EnterStartTime%>");
                        Ext.getCmp('startTimeId').focus();
                        return;
                    }
                    if (Ext.getCmp('endTimeId').getValue() == "") {
                        Ext.example.msg("<%=EnterEndTime%>");
                        Ext.getCmp('endTimeId').focus();
                        return;
                    }
                    if (Ext.getCmp('startTimeId').getValue()>=Ext.getCmp('endTimeId').getValue()) {
                        Ext.example.msg("<%=ValidateMsg%>");
                        return;
                    }
                    if (Ext.getCmp('approximateDistanceId').getValue() == "") {
                        Ext.example.msg("<%=EnterApproximateDistance%>");
                        Ext.getCmp('approximateDistanceId').focus();
                        return;
                    }
                    if (Ext.getCmp('approximateTimeId').getValue() == "") {
                        Ext.example.msg("<%=EnterApproximateTime%>");
                        Ext.getCmp('approximateTimeId').focus();
                        return;
                    }
                    if (Ext.getCmp('VehicleNumberId').getValue() == "") {
                        Ext.example.msg("<%=SelectVehicleNumber%>");
                        Ext.getCmp('VehicleNumberId').focus();
                        return;
                    }
                    if (Ext.getCmp('pudId').getValue() == "") {
                        Ext.example.msg("<%=SelectType%>");
                        Ext.getCmp('pudId').focus();
                        return;
                    }
                   if (innerPanelForRouteDetails.getForm().isValid()) {
                        var seletedRouteCode;
                        var selectedStartTime;
                        var selectedEndTime;
                        var selectedApproximateDistance;
                        var selectedApproximateTime;
                        var selectedAssetNumber;
                        var selectedType;
                        var id;
                        
                        if (buttonValue == '<%=Modify%>') {
                            var selected = grid.getSelectionModel().getSelected();
                            id = selected.get('idDataIndex');
                            seletedRouteCode=selected.get('routeCodeIndex');
                            selectedStartTime=selected.get('startTimeIndex');
                            selectedEndTime=selected.get('endTimeIndex');
                            selectedApproximateDistance=selected.get('approximateDistanceIndex');
                            selectedApproximateTime=selected.get('approximateTimeIndex');
                            selectedAssetNumber=selected.get('assetNumberIndex');
                            selectedType=selected.get('pickDropDataIndex');
                        }
                        manageRouteOuterPanelWindow.getEl().mask();
                        Ext.Ajax.request({
                            url: '<%=request.getContextPath()%>/ManageRouteAction.do?param=manageRouteAddAndModify',
                            method: 'POST',
                            params: {
                                CustId:custId,
                                buttonValue: buttonValue,
                                routeCode: Ext.getCmp('routeCodeId').getValue(),
                                startTime: Ext.getCmp('startTimeId').getValue(),
                                endTime: Ext.getCmp('endTimeId').getValue(),
                                approDistance: Ext.getCmp('approximateDistanceId').getValue(),
                                approTime: Ext.getCmp('approximateTimeId').getValue(),
                                assetNumber: Ext.getCmp('VehicleNumberId').getValue(),
                                id: id,
                                type: Ext.getCmp('pudId').getValue()
                            },
                            success: function (response, options) {
                                var message = response.responseText;
                                Ext.example.msg(message);
                                Ext.getCmp('routeCodeId').reset();
                                Ext.getCmp('startTimeId').reset();
                                Ext.getCmp('endTimeId').reset();
                                Ext.getCmp('approximateDistanceId').reset();
                                Ext.getCmp('approximateTimeId').reset();
                                Ext.getCmp('VehicleNumberId').reset();
                                Ext.getCmp('pudId').reset();
                                myWin.hide();
                                manageRouteOuterPanelWindow.getEl().unmask();
                                store.load({
                                    params: {
                                        CustId:custId,
		                                jspName:jspName,
								        custName:Ext.getCmp('custcomboId').getRawValue()
		       
                                    }
                                });
                            },
                            failure: function () {
                                Ext.example.msg("<%=Error%>");
                                store.reload();
                                myWin.hide();
                            }
                        });
                    }else{
                    Ext.example.msg("<%=ValidateMsg1%>");
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

var manageRouteOuterPanelWindow = new Ext.Panel({
    width: 390,
    height: 340,
    standardSubmit: true,
    frame: true,
    items: [innerPanelForRouteDetails, innerWinButtonPanel]
});

myWin = new Ext.Window({
    title: titelForInnerPanel,
    closable: false,
    resizable: false,
    modal: true,
    autoScroll: false,
    frame:true,
    height:380,
    width: 390,
    id: 'myWin',
    items: [manageRouteOuterPanelWindow]
});
function addRecord() {
    if (Ext.getCmp('custcomboId').getValue() == "") {
        Ext.example.msg("<%=SelectCustomerName%>");
        Ext.getCmp('custcomboId').focus();
        return;
    }
     regStore.load({
                      params:{
			          clientId:Ext.getCmp('custcomboId').getValue()
			                   }
				             });
    buttonValue = '<%=Add%>';
    titelForInnerPanel = '<%=AddDetails%>';
    myWin.setPosition(400, 50);
    myWin.show();
    myWin.setTitle(titelForInnerPanel);
    Ext.getCmp('routeCodeId').reset();
    Ext.getCmp('startTimeId').reset();
    Ext.getCmp('endTimeId').reset();
    Ext.getCmp('approximateDistanceId').reset();
    Ext.getCmp('approximateTimeId').reset();
    Ext.getCmp('VehicleNumberId').reset();
    Ext.getCmp('pudId').reset();
}

function modifyData() {
    if (Ext.getCmp('custcomboId').getValue() == "") {
        Ext.example.msg("<%=SelectCustomerName%>");
        Ext.getCmp('custcomboId').focus();
        return;
    }
    if (grid.getSelectionModel().getCount() == 0) {
        Ext.example.msg("<%=NoRowSelected%>");
        return;
    }
    if (grid.getSelectionModel().getCount() > 1) {
        Ext.example.msg("<%=SelectSingleRow%>");
        return;
    }
     regStore.load({
                      params:{
			          clientId:Ext.getCmp('custcomboId').getValue()
			                   }
				             });
    buttonValue = '<%=Modify%>';
    titelForInnerPanel = '<%=ModifyDetails%>';
    myWin.setPosition(400, 50);
    myWin.setTitle(titelForInnerPanel);
    myWin.show();
    var selected = grid.getSelectionModel().getSelected();
    Ext.getCmp('routeCodeId').setValue(selected.get('routeCodeIndex'));
    Ext.getCmp('startTimeId').setValue(selected.get('startTimeIndex'));
    Ext.getCmp('endTimeId').setValue(selected.get('endTimeIndex'));
    Ext.getCmp('approximateDistanceId').setValue(selected.get('approximateDistanceIndex'));
    Ext.getCmp('approximateTimeId').setValue(selected.get('approximateTimeIndex'));
    Ext.getCmp('VehicleNumberId').setValue(selected.get('assetNumberIndex'));
     Ext.getCmp('pudId').setValue(selected.get('pickDropDataIndex'));
}

function deleteData() {

 if (Ext.getCmp('custcomboId').getValue() == "") {
                     Ext.example.msg("<%=SelectCustomerName%>");
                      Ext.getCmp('custcomboId').focus();
                        return;
                    }
                    
    if (grid.getSelectionModel().getCount() == 0) {
        Ext.example.msg("<%=NoRowSelected%>");
        return;
    }
    if (grid.getSelectionModel().getCount() > 1) {
        Ext.example.msg("<%=SelectSingleRow%>");
        return;
    }
    Ext.Msg.show({
        title: '<%=Delete%>',
        msg: '<%=AreYouSureWantToDelete%>',
        buttons: {
            yes: true,
            no: true
        },
        fn: function (btn) {
            switch (btn) {
            case 'yes':
                var selected = grid.getSelectionModel().getSelected();
                id = selected.get('idDataIndex');
                outerPanel.getEl().mask();
                Ext.Ajax.request({
                    url: '<%=request.getContextPath()%>/ManageRouteAction.do?param=deleteData',
                    method: 'POST',
                    params: {
                        CustId: Ext.getCmp('custcomboId').getValue(),
                        id: id
                        },
                    success: function (response, options) {
                        var message = response.responseText;
                        Ext.example.msg(message);
                        outerPanel.getEl().unmask();
                        store.load({
                            params: {
                                CustId: custId,
                                jspName:jspName,
                                custName:Ext.getCmp('custcomboId').getRawValue()
                            }
                        });
                    },
                    failure: function () {
                        Ext.example.msg("<%=Error%>");
                        store.reload();
                    }
                });
                break;
            case 'no':
                Ext.example.msg("<%=NotDeleted%>");
                store.reload();
                break;
            }
        }
    });
}
//*****************************************************************Grid *******************************************************************************
grid = getGrid('<%=ManageRoute%>', '<%=NoRecordFound%>',store , screen.width - 35, 400, 15, filters, '<%=ClearFilterData%>', false, '', 20, false, '', false, '', true, '<%=Excel%>', jspName, exportDataType, false, 'PDF', true, '<%=Add%>', true, '<%=Modify%>', true, '<%=Delete%>');
//******************************************************************************************************************************************************
Ext.onReady(function () {
    ctsb = tsb;
    Ext.QuickTips.init();
    Ext.form.Field.prototype.msgTarget = 'side';
    outerPanel = new Ext.Panel({
        title: '<%=ManageRoute%>',
        renderTo: 'content',
        standardSubmit: true,
        frame: true,
        width: screen.width-22,
        height:520,
        cls: 'outerpanel',
        layout: 'table',
        layoutConfig: {
            columns: 1
        },
        items: [customerComboPanel,grid]
    });
    sb = Ext.getCmp('form-statusbar');
 });
 </script>
<jsp:include page="../Common/footer.jsp" />
 <!-- </body>   -->
 <!-- </html> -->
