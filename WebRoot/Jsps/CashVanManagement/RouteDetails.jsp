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
	
	if(request.getParameter("status")!=null && !request.getParameter("status").equals("")){
	   customerId=Integer.parseInt(request.getParameter("custId"));
	}
	
ArrayList<String> tobeConverted = new ArrayList<String>();

tobeConverted.add("Consumer_Enrolment_Form");
tobeConverted.add("Consumer_Details");

tobeConverted.add("Customer_Name");
tobeConverted.add("Select_Customer");

tobeConverted.add("Consumer_Type");
tobeConverted.add("Select_Consumer_Type");

tobeConverted.add("District");
tobeConverted.add("Select_District");

tobeConverted.add("Taluka");
tobeConverted.add("Select_Taluka");

tobeConverted.add("Village");
tobeConverted.add("Enter_Village");

tobeConverted.add("Mobile_No");
tobeConverted.add("Enter_Mobile_No");

tobeConverted.add("Email_ID");
tobeConverted.add("Enter_Email_Id");

tobeConverted.add("Address");
tobeConverted.add("Enter_Address");

tobeConverted.add("Identity_Proof_Type");
tobeConverted.add("Select_Identity_Proof_Type");

tobeConverted.add("Sand_Consumer_Name");
tobeConverted.add("Enter_Sand_Consumer_Name");

tobeConverted.add("Project_Name");
tobeConverted.add("Enter_Project_Name");

tobeConverted.add("Project_Duration_From");
tobeConverted.add("Select_Project_Duration_From");

tobeConverted.add("Project_Duration_To");
tobeConverted.add("Select_Project_Duration_To");

tobeConverted.add("Contractor_Name");
tobeConverted.add("Enter_Contractor_Name");

tobeConverted.add("Government_Dept_Name");
tobeConverted.add("Enter_Government_Dept_Name");

tobeConverted.add("Dept_Contact_Name");
tobeConverted.add("Enter_Dept_Contact_Name");

tobeConverted.add("Enter_Work_Location");
tobeConverted.add("Work_Location");

tobeConverted.add("Work_Location_Details");
tobeConverted.add("Same_As_Above");

tobeConverted.add("Work_Details");

tobeConverted.add("Housing_Approval_Authority");
tobeConverted.add("Enter_Housing_Approval_Authority");

tobeConverted.add("Housing_Approval_Plan_Number");
tobeConverted.add("Enter_Housing_Approval_Plan_Number");

tobeConverted.add("Project_Approval_Authority");
tobeConverted.add("Enter_Project_Approval_Authority");

tobeConverted.add("Project_Approval_Plan_Number");
tobeConverted.add("Enter_Project_Approval_Plan_Number");

tobeConverted.add("Total_Builtup_Area");
tobeConverted.add("Enter_Total_Builtup_Area");

tobeConverted.add("No_Of_Buildings");
tobeConverted.add("Enter_No_Of_Buildings");

tobeConverted.add("Type_Of_Work");
tobeConverted.add("Select_Type_Of_Work");

tobeConverted.add("Estimated_Sand_Requirement");
tobeConverted.add("Enter_Estimated_Sand_Requirement");

tobeConverted.add("Approved_Sand_Qunatity");
tobeConverted.add("Enter_Approved_Sand_Qunatity");

tobeConverted.add("No_Records_Found");
tobeConverted.add("Clear_Filter_Data");
tobeConverted.add("Add");
tobeConverted.add("SLNO");
tobeConverted.add("Cancel");
tobeConverted.add("Save");

tobeConverted.add("Identity_Proof_No");
tobeConverted.add("Enter_Identity_Proof_No");
tobeConverted.add("Consumer_Application_No");

tobeConverted.add("Set_Location");
tobeConverted.add("Work_Location_On_Map");
tobeConverted.add("Remaining_Qunatity"); 
tobeConverted.add("Created_Time");

ArrayList<String> convertedWords = new ArrayList<String>();
convertedWords = cf.getLanguageSpecificWordForKey(tobeConverted,language);

String ConsumerEnrolmentForm=convertedWords.get(0);
String ConsumerDetails=convertedWords.get(1);

String CustomerName=convertedWords.get(2);
String SelectCustomer=convertedWords.get(3);

String ConsumerType=convertedWords.get(4);
String SelectConsumerType=convertedWords.get(5);

String District=convertedWords.get(6);
String SelectDistrict=convertedWords.get(7);

String Taluka=convertedWords.get(8);
String SelectTaluka=convertedWords.get(9);

String Village=convertedWords.get(10);
String EnterVillage=convertedWords.get(11);

String MobileNo=convertedWords.get(12);
String EnterMobileNo=convertedWords.get(13);

String EmailId=convertedWords.get(14);
String EnterEmailId=convertedWords.get(15);

String Address=convertedWords.get(16);
String EnterAddress=convertedWords.get(17);

String IdentityProofType=convertedWords.get(18);
String SelectIdentityProofType=convertedWords.get(19);

String SandConsumerName=convertedWords.get(20);
String EnterSandConsumerName=convertedWords.get(21);

String ProjectName=convertedWords.get(22);
String EnterProjectName=convertedWords.get(23);

String ProjectDurationFrom=convertedWords.get(24);
String SelectProjectDurationFrom=convertedWords.get(25);

String ProjectDurationTo=convertedWords.get(26);
String SelectProjectDurationTo=convertedWords.get(27);

String ContractorName=convertedWords.get(28);
String EnterContractorName=convertedWords.get(29);

String GovernmentDeptName=convertedWords.get(30);
String EnterGovernmentDeptName=convertedWords.get(31);

String DeptContactName=convertedWords.get(32);
String EnterDeptContactName=convertedWords.get(33);

String WorkLocation=convertedWords.get(34);
String EnterWorkLocation=convertedWords.get(35);

String WorkLocationDetails=convertedWords.get(36);
String SameAsAbove=convertedWords.get(37);
String WorkDetails=convertedWords.get(38);

String HousingApprovalAuthority=convertedWords.get(39);
String EnterHousingApprovalAuthority=convertedWords.get(40);

String HousingApprovalPlanNumber=convertedWords.get(41);
String EnterHousingApprovalPlanNumber=convertedWords.get(42);

String ProjectApprovalAuthority=convertedWords.get(43);
String EnterProjectApprovalAuthority=convertedWords.get(44);

String ProjectApprovalPlanNumber=convertedWords.get(45);
String EnterProjectApprovalPlanNumber=convertedWords.get(46);

String TotalBuiltupArea=convertedWords.get(47);
String EnterTotalBuiltupArea=convertedWords.get(48);

String NoOfBuildings=convertedWords.get(49);
String EnterNoOfBuildings=convertedWords.get(50);

String TypeOfWork=convertedWords.get(51);
String SelectTypeOfWork=convertedWords.get(52);

String EstimatedSandRequirement=convertedWords.get(53);
String EnterEstimatedSandRequirement=convertedWords.get(54);

String ApprovedSandQunatity=convertedWords.get(55);
String EnterApprovedSandQunatity=convertedWords.get(56);

String NoRecordsFound=convertedWords.get(57);
String ClearFilterData=convertedWords.get(58);
String Add=convertedWords.get(59);
String SLNO=convertedWords.get(60);
String Cancel=convertedWords.get(61);
String Save=convertedWords.get(62);

String IdentityProofNo=convertedWords.get(63);
String EnterIdentityProofNo=convertedWords.get(64);
String ConsumerApplicationNo=convertedWords.get(65);

String SetLocation=convertedWords.get(66);
String WorkLocationOnMap=convertedWords.get(67);
String RemainingQunatity=convertedWords.get(68);
String CreatedDate=convertedWords.get(69);

%>

<!DOCTYPE HTML>
<html>
 <head>
 		<title>Route Details</title>	
 		  
</head>	    
	 <style>
  .x-panel-tl
	{
		border-bottom: 0px solid !important;
	}
  </style>
  <body>
   <%if (loginInfo.getStyleSheetOverride().equals("Y")){%>
	<jsp:include page="../Common/ImportJSSandMining.jsp"/>
	<%}else{%>
	<jsp:include page="../Common/ImportJS.jsp" /><%}%>
   <jsp:include page="../Common/ExportJS.jsp" />
   <script>
var outerPanel;
var exportDataType="";
var jspName = "";
var grid;
var buttonValue;
var titelForInnerPanel;
var myWin;

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
                        custId: custId
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
            fn: function() {
                custId = Ext.getCmp('custcomboId').getValue();
                store.load({
                    params: {
                        custId: custId
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

function addRecord() {
    if (Ext.getCmp('custcomboId').getValue() == "") {
        Ext.example.msg("<%=SelectCustomer%>");
        return;
    }
    var custName=Ext.getCmp('custcomboId').getRawValue();
    var custId = Ext.getCmp('custcomboId').getValue();
    buttonValue = '<%=Add%>';
    parent.Ext.getCmp('routeMapId').enable();
	parent.Ext.getCmp('routeMapId').show();
	parent.Ext.getCmp('routeDetailsId').disable();
	var value='/Telematics4uApp/Jsps/CashVanManagement/RouteMap.jsp?custId='+custId+'&buttonValue='+buttonValue+'&custName='+custName;
	parent.Ext.getCmp('routeMapId').update("<iframe style='width:100%;height:530px;border:0;' src='"+value+"'></iframe>");
}
function modifyData() {
      var custId=Ext.getCmp('custcomboId').getValue();
      var selected = grid.getSelectionModel().getSelected();
      var routeId=selected.get('routeIdDataIndex');
      var routeName=selected.get('routeNameDataIndex');
      var source=selected.get('routeFromDataIndex');
      var destination=selected.get('routeToDataIndex');
      var actualDistance=selected.get('actualDistanceDataIndex');
      var expDistance=selected.get('tempDistanceDataIndex');
      var actualduration=selected.get('actualTimeDataIndex');
      var expDuration=selected.get('tempTimeDataIndex');
      var trigger1=selected.get('trigger1DataIndex');
      var trigger2=selected.get('trigger2DataIndex');
      var routeDesp=selected.get('despDataIndex');
      var radius=selected.get('radiusDataIndex');
      var SourceRadius=selected.get('SourceRadiusDataIndex');
      var destRadius=selected.get('destRadiusDataIndex');
      if (Ext.getCmp('custcomboId').getValue() == "") {
          Ext.example.msg("<%=SelectCustomer%>");
          return;
      }
      if (grid.getSelectionModel().getCount() == 0) {
          Ext.example.msg("No records found");
          return;
      }
      if (grid.getSelectionModel().getCount() > 1) {
          Ext.example.msg("SelectSingleRow");
          return;
      }
      if(selected.get('statusDataIndex')=='Inactive') {
    	Ext.example.msg("The Route is already Inactive");
        return;
      } 
    buttonValue = 'Modify';
    parent.Ext.getCmp('routeMapId').enable();
	parent.Ext.getCmp('routeMapId').show();
	parent.Ext.getCmp('routeDetailsId').disable();
	var custId = Ext.getCmp('custcomboId').getValue();
	var value1='/Telematics4uApp/Jsps/CashVanManagement/RouteMap.jsp?custId='+custId+'&buttonValue='+buttonValue+'&routeId='+routeId+'&routeName='+routeName+'&source='+source+'&destination='+destination+'&actualDistance='+actualDistance+'&expDistance='+expDistance+'&actualduration='+actualduration+'&expDuration='+expDuration+'&trigger1='+trigger1+'&trigger2='+trigger2+'&routeDesp='+routeDesp+'&radius='+radius+'&SourceRadius='+SourceRadius+'&destRadius='+destRadius;
	parent.Ext.getCmp('routeMapId').update("<iframe style='width:100%;height:530px;border:0;' src='"+value1+"'></iframe>");
  }
  
  function closetripsummary() {

    var selected = grid.getSelectionModel().getSelected();
    if(selected.get('statusDataIndex')=='Inactive') {
    	Ext.example.msg("The Route is already Inactive");
        return;
    } 
    if (Ext.getCmp('custcomboId').getValue() == "") {
    	Ext.example.msg("Select Customer Name");
        Ext.getCmp('custcomboId').focus();
        return;
    }
    if (grid.getSelectionModel().getCount() == 0) {
    	Ext.example.msg("No Rows Selected");
        return;
    }
    if (grid.getSelectionModel().getCount() > 1) {
    	Ext.example.msg("Select Single Row");
        return;
    }
    Ext.MessageBox.confirm('Confirm', 'Are you sure you want to Inactive?',showMsgBox);
    }
    	 function showMsgBox(btn){
	 	 if(btn == 'yes'){
        	 var selected = grid.getSelectionModel().getSelected();
		     var routeIdD=selected.get('routeIdDataIndex');
		     buttonValue = 'Delete';
                Ext.Ajax.request({
                url: '<%=request.getContextPath()%>/RouteDetailsAction.do?param=InactiveRoute',
                method: 'POST',
                params: {
                    routeId:routeIdD
                },
                success: function(response, options) {
                    var message = response.responseText;
                    Ext.example.msg(message);
                    store.load({
                    params: {
                        custId: custId
                    }
                });
                },
                failure: function() {
                    Ext.example.msg("Unsucessfull");
                }
            });
        }
     }
   
var reader = new Ext.data.JsonReader({
    idProperty: 'routeid',
    root: 'routeDetailsRoot',
    totalProperty: 'total',
    fields: [{
        name: 'slnoIndex'
    }, {
        name: 'routeIdDataIndex'
    },{
        name: 'trigger1DataIndex'
    },{
        name: 'trigger2DataIndex'
    }, {
        name: 'despDataIndex'
    },{
        name: 'routeNameDataIndex'
    },{
        name: 'routeFromDataIndex'
    }, {
        name: 'routeToDataIndex'
    }, {
        name: 'actualDistanceDataIndex'
    }, {
        name: 'tempDistanceDataIndex'
    }, {
        name: 'actualTimeDataIndex'
    }, {
        name: 'tempTimeDataIndex'
    },{
        name: 'statusDataIndex'
    },{
        name: 'radiusDataIndex'
    },{
        name: 'SourceRadiusDataIndex'
    },{
        name: 'destRadiusDataIndex'
    }]
});

var store = new Ext.data.GroupingStore({
    autoLoad: false,
    proxy: new Ext.data.HttpProxy({
        url: '<%=request.getContextPath()%>/RouteDetailsAction.do?param=getRouteDetails',
        method: 'POST'
    }),
    storeId: 'storeId',
    reader: reader
});

var filters = new Ext.ux.grid.GridFilters({
    local: true,
    filters: [{
        type: 'numeric',
        dataIndex: 'slnoIndex'
    },{
        type: 'numeric',
        dataIndex: 'routeIdDataIndex'
    },{
        type: 'string',
        dataIndex: 'trigger1DataIndex'
    },{
        type: 'string',
        dataIndex: 'trigger2DataIndex'
    },{
        type: 'string',
        dataIndex: 'despDataIndex'
    },{
        type: 'string',
        dataIndex: 'routeNameDataIndex'
    },{
        type: 'string',
        dataIndex: 'routeFromDataIndex'
    }, {
        type: 'string',
        dataIndex: 'routeToDataIndex'
    }, {
        type: 'numeric',
        dataIndex: 'actualDistanceDataIndex'
    }, {
        type: 'numeric',
        dataIndex: 'tempDistanceDataIndex'
    }, {
        type: 'numeric',
        dataIndex: 'actualTimeDataIndex'
    }, {
        type: 'numeric',
        dataIndex: 'tempTimeDataIndex'
    },{
        type: 'string',
        dataIndex: 'statusDataIndex'
    },{
        type: 'numeric',
        dataIndex: 'radiusDataIndex'
    },{
        type: 'numeric',
        dataIndex: 'SourceRadiusDataIndex'
    },{
        type: 'numeric',
        dataIndex: 'destRadiusDataIndex'
    }]
});

var createColModel = function(finish, start) {
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
        },{
            dataIndex: 'routeIdDataIndex',
            header: "<span style=font-weight:bold;>Route Id</span>",
            hidden:true,
            filter: {
                type: 'numeric'
            }
        }, {
            dataIndex: 'trigger1DataIndex',
            header: "<span style=font-weight:bold;>Trigger Point 1</span>",
            hidden:true,
            filter: {
                type: 'string'
            }
        }, {
            dataIndex: 'trigger2DataIndex',
            header: "<span style=font-weight:bold;>Trigger Point 2</span>",
            hidden:true,
            filter: {
                type: 'string'
            }
        },{
            dataIndex: 'despDataIndex',
            header: "<span style=font-weight:bold;>Route Description</span>",
            hidden:true,
            filter: {
                type: 'string'
            }
        }, {
            dataIndex: 'routeNameDataIndex',
            header: "<span style=font-weight:bold;>Route Name</span>",
            filter: {
                type: 'string'
            }
        }, {
            dataIndex: 'routeFromDataIndex',
            header: "<span style=font-weight:bold;>Source</span>",
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;>Destination</span>",
            dataIndex: 'routeToDataIndex',
            width: 100,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;>Actual Distance(Km)</span>",
            dataIndex: 'actualDistanceDataIndex',
            width: 100,
            filter: {
                type: 'numeric'
            }
        }, {
            header: "<span style=font-weight:bold;>Expected Distance(Km)</span>",
            dataIndex: 'tempDistanceDataIndex',
            width: 100,
            filter: {
                type: 'numeric'
            }
        }, {
            header: "<span style=font-weight:bold;>Actual Time(HH:MM)</span>",
            dataIndex: 'actualTimeDataIndex',
            width: 100,
            filter: {
                type: 'numeric'
            }
        }, {
            header: "<span style=font-weight:bold;>Expected Time(HH:MM)</span>",
            dataIndex: 'tempTimeDataIndex',
            width: 100,
            filter: {
                type: 'numeric'
            }
        },{
            header: "<span style=font-weight:bold;>Status</span>",
            dataIndex: 'statusDataIndex',
            width: 100,
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;>Radius</span>",
            dataIndex: 'radiusDataIndex',
            width: 100,
            hidden:true,
            filter: {
                type: 'numeric'
            }
        },{
            header: "<span style=font-weight:bold;>Source Radius</span>",
            dataIndex: 'SourceRadiusDataIndex',
            width: 100,
            hidden:true,
            filter: {
                type: 'numeric'
            }
        },{
            header: "<span style=font-weight:bold;>Destination Radius</span>",
            dataIndex: 'destRadiusDataIndex',
            width: 100,
            hidden:true,
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

//*****************************************************************Grid *******************************************************************************
grid = getGrid('Route Details', '<%=NoRecordsFound%>', store, screen.width - 40, 420, 30, filters, '<%=ClearFilterData%>', false, '', 16, false, '', false, '', false, '', jspName, exportDataType, false, 'PDF', true, '<%=Add%>', true, 'View', false, '',true, 'Inactive');
//******************************************************************************************************************************************************
Ext.onReady(function() {
    ctsb = tsb;
    Ext.QuickTips.init();
    Ext.form.Field.prototype.msgTarget = 'side';
    Ext.Ajax.timeout = 120000;  
    outerPanel = new Ext.Panel({
        title: 'Route Details',
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
</body>
</html>
    
    
    
    
    

