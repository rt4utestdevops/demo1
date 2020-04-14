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
tobeConverted.add("Branch_Name");
tobeConverted.add("Select_Branch");
//tobeConverted.add("This_Route_is_Already_Exists_Please_Select_Different_One");

ArrayList<String> convertedWords = new ArrayList<String>();
convertedWords = cf.getLanguageSpecificWordForKey(tobeConverted,language);

String VehicleShiftAssociation= "Vehicle Shift Association";//convertedWords.get(0);
String Add=convertedWords.get(1);
String Modify=convertedWords.get(2);
String CustomerName=convertedWords.get(3);
String SelectCustomerName=convertedWords.get(4);
String VehicleShiftAssociationDetails="Vehicle Shift Association Details";//convertedWords.get(5);
String NoRecordsFound=convertedWords.get(6);
String ClearFilterData=convertedWords.get(7);
String SLNO=convertedWords.get(8);
String ID=convertedWords.get(9);
//String ShiftID="Shift ID";//convertedWords.get(10);
String ShiftName="Shift Name";//convertedWords.get(11);
String RouteType=convertedWords.get(12);
String Excel=convertedWords.get(13);
String Delete=convertedWords.get(14);
String AssociateVehicleShift="Associate Vehicles To Shift ";//convertedWords.get(15);
String NoRowsSelected=convertedWords.get(16);
String SelectSingleRow=convertedWords.get(17);
String ModifyDetails=convertedWords.get(18);
String AssociateShift="Vehicle Shift Association Details";//convertedWords.get(19);
String SelectRouteID=convertedWords.get(20);
String SelectShiftName="Select Shift Name";//convertedWords.get(21);
String SelectRouteType=convertedWords.get(22);
String Save=convertedWords.get(23);
String Cancel=convertedWords.get(24);
String branch=convertedWords.get(25);
String selectBranch=convertedWords.get(26);
String StartTime = "Start Time";
String EndTime  = "End Time";
String Status = "Status";
//String EnterStartTime = "Enter Start Time";
//String EnterEndTime = "Enter End Time";
String  InvalidStartTime = "Invalid Start Time";
String  InvalidEndTime = "Invalid End Time";
String AsscID = "Association Id";
String VehicleNo = "Vehicle No";
String SelectVehiceleNo = "Select Vehicle No";
//String RouteisAlreadyExistsPleaseSelectDifferentOne=convertedWords.get(25);

%>
<jsp:include page="../Common/header.jsp" />
 		<title>Vehicle Shift Association</title>		
	    
	 <style>
  .x-panel-tl
	{
		border-bottom: 0px solid !important;
	}
		.x-panel-header
		{
				height: 7% !important;
		}
		.x-grid3-cell-inner,.ext-strict .x-grid3-hd-inner {
			height: 26px !important;
			padding-top: 8px;
		}
		.x-form-text {
			height: 21px !important;
		}
		label {
			display: inline !important;
			
		}
  </style>
  
   <%if (loginInfo.getStyleSheetOverride().equals("Y")){%>
	<jsp:include page="../Common/ImportJSSandMining.jsp"/>
	<%}else{%>
	<jsp:include page="../Common/ImportJS.jsp" /><%}%>
   <jsp:include page="../Common/ExportJS.jsp" />
   <script>
   
var outerPanel;
var ctsb;
var jspName = "ShiftMasterDetails";
var exportDataType = "";
var selected;
var grid;
var buttonValue;
var titelForInnerPanel;
var myWin;
var myWinNew;
var selectedVehicles = "-";
var selectedShiftId = null;
var selectedName = null;
var selectedType = null;
var datecur = datecur;
var dtprev = dtprev;
var duration = "08:00";
var AsscId;
var ShiftId;
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
                        
 VehicleNoComboStore.load({
 params:{
  CustId : Ext.getCmp('custcomboId').getValue()
  
 }
 });
 
vehicleNGroupGridStore.load({
 params:{
  CustId : Ext.getCmp('custcomboId').getValue()
  }
 });
 
BranchStore.load({params:{clientId:custId}});
 ShiftNameComboStore.load({
 params:{
  CustId : Ext.getCmp('custcomboId').getValue() 
 }
 });
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
                BranchStore.load({params:{clientId:custId}});
                store.load({
                    params: {
                        CustId: custId
                    }
                });
                        
 VehicleNoComboStore.load({
 params:{
  CustId : Ext.getCmp('custcomboId').getValue()
  
 }
 });
 ShiftNameComboStore.load({
 params:{
  CustId : Ext.getCmp('custcomboId').getValue() 
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

var BranchStore = new Ext.data.JsonStore({
			   url:'<%=request.getContextPath()%>/ShiftMasterActions.do?param=getBranch',
			   id:'BranchStoreId',
		       root: 'BranchStoreRootUser',
		       autoLoad: false,
		       remoteSort: true,
			   fields: ['BranchId','BranchName']
			  });
			  
   var BranchBombo = new Ext.form.ComboBox({
    fieldLabel:'Select Branch',
    store: BranchStore,
    id: 'branchComboId',
    mode: 'local',
    forceSelection: true,
    selectOnFocus: true,  
    anyMatch: true,
    emptyText: 'Select Branch',
    blankText: 'Select Branch',
    typeAhead: false,
    triggerAction: 'all',  
    valueField: 'BranchId',  
    displayField: 'BranchName',
    cls: 'selectstylePerfect',
       listeners: {
           select: {
               fn: function () {
                 
                   shiftGridStore.load({
                       params: {
                           CustId: Ext.getCmp('custcomboId').getValue(),
                           BranchId: Ext.getCmp('branchComboId').getValue()
                       }
                   });
                   
               }
           }
       }
});

 //***************************************************************************FIRST GRID***********************************************************************************//
   
   var sm1 = new Ext.grid.CheckboxSelectionModel({
       checkOnly: true
   });
  
   
   var reader1 = new Ext.data.JsonReader({
       root: 'VehicleAndGroupRoot',
       fields: [{
           name: 'slnoIndex'
       }, {
           name: 'VehicleNo',
           type: 'string'
       }, {
           name: 'VehicleGroupName',
           type: 'string'
       }, {
           name: 'VehicleGroupId',
           type: 'string'
       }]
   });
   
   var filters1 = new Ext.ux.grid.GridFilters({
       local: true,
       filters: [{
           type: 'string',
           dataIndex: 'VehicleNo'
       }, {
           dataIndex: 'VehicleGroupName',
           type: 'string'
       }]
   });
   
   var vehicleNGroupGridStore = new Ext.data.Store({
       url: '<%=request.getContextPath()%>/VehicleShiftAssociationAction.do?param=getVehiclesAndGroupForAssociation',
       bufferSize: 367,
       reader: reader1,
       autoLoad: false,
       remoteSort: false
   });
   
    //***************************************************************************88SECOND GRID*******************************************************************************************//
 
  var sm2 = new Ext.grid.CheckboxSelectionModel({
       checkOnly: true
   });

   
   var reader2 = new Ext.data.JsonReader({
       root: 'shiftGridRoot',
       fields: [{
           name: 'slnoIndex2'
       }, {
           name: 'ShiftId',
           type: 'string'
       }, {
           name: 'ShiftName',
           type: 'string'
       },{
           name: 'StartTime',
           type: 'string'
       },{
           name: 'EndTime',
           type: 'string'
       }]
   });
   
   var filters2 = new Ext.ux.grid.GridFilters({
       local: true,
       filters: [
       {
           dataIndex: 'ShiftName',
           type: 'string'
       }]
   });
   
   var shiftGridStore = new Ext.data.Store({
       url: '<%=request.getContextPath()%>/VehicleShiftAssociationAction.do?param=getShiftsBasedOnBranch',
       bufferSize: 367,
       reader: reader2,
       autoLoad: false,
       remoteSort: false
   });
   
  var grid1= new Ext.grid.EditorGridPanel({
    store: vehicleNGroupGridStore,
    columns: [sm1, {
           header: 'Vehicle Number',         
           sortable: true,
           dataIndex: 'VehicleNo',
           width: 220
       }, {
            header: 'Vehicle Group',           
            sortable: true,          
            dataIndex: 'VehicleGroupName',
            width: 185
       }, {
            header: 'Group Id',           
            sortable: true,
            hidden:true,          
            dataIndex: 'VehicleGroupId'           
       }],
    sm: sm1,
    plugins:[ filters1],
    stripeRows: true,
    border: true,
    frame: false,
    width: 450,
    height: 140,
    style: 'margin-left:5px;',
    cls: 'bskExtStyle'
});
  
   var grid2= new Ext.grid.EditorGridPanel({
    store: shiftGridStore,
    columns: [sm2,{
           header: 'Shift Id',        
           sortable: true,
           hidden:true,
           dataIndex: 'ShiftId'         
       }, {
           header: 'Shift Name',        
           sortable: true,
           dataIndex: 'ShiftName',
           width: 135
       }, {
           header: 'Start Time',          
           sortable: true,        
           dataIndex: 'StartTime',
           width: 135
       }, {
           header: 'End Time',          
           sortable: true,        
           dataIndex: 'EndTime',
           width: 130
       }],
    sm: sm2,
    plugins:[filters2],
    stripeRows: true,
    border: true,
    frame: false,
    width: 450,
    height: 140,
    style: 'margin-left:5px;',
    cls: 'bskExtStyle'
});
  


var VehicleNoComboStore = new Ext.data.JsonStore({
    url: '<%=request.getContextPath()%>/VehicleShiftAssociationAction.do?param=getVehicleNo',
    id: 'VehicleNoStoreId',
    root: 'VehicleNoRoot',
    autoLoad: false,
    remoteSort: true,
    fields: ['VehicleNo']
});



var VehicleNoCombo = new Ext.form.ComboBox({
    store: VehicleNoComboStore,
    id: 'VehicleNoComboId',
    mode: 'local',
    forceSelection: true,
    emptyText: '<%=SelectVehiceleNo%>',
    blankText: '<%=SelectVehiceleNo%>',
    selectOnFocus: true,
    allowBlank: false,
    anyMatch: true,
    typeAhead: false,
    triggerAction: 'all',
    lazyRender: true,
    valueField: 'VehicleNo',
    displayField: 'VehicleNo',
    cls: 'selectstylePerfect',
    listeners: {
        select: {
            fn: function() {
            Ext.getCmp('ShiftNameComboId').reset();
             Ext.getCmp('DepartureFieldId').reset();
              Ext.getCmp('ArrivalFieldId').reset();
             ShiftNameComboStore.load({
 params:{
  CustId : Ext.getCmp('custcomboId').getValue() 
 }
 });
            }
        }
    }
});




var ShiftNameComboStore = new Ext.data.JsonStore({
    url: '<%=request.getContextPath()%>/VehicleShiftAssociationAction.do?param=getShiftNames',
    id: 'ShiftStoreId',
    root: 'ShiftRoot',
    autoLoad: false,
    remoteSort: true,
    fields: ['ShiftId','ShiftName','StartTime','EndTime']
});



var ShiftNameCombo = new Ext.form.ComboBox({
    store: shiftGridStore,
    id: 'ShiftNameComboId',
    mode: 'local',
    forceSelection: true,
    emptyText: '<%=SelectShiftName%>',
    blankText: '<%=SelectShiftName%>',
    selectOnFocus: true,
    allowBlank: false,
    anyMatch: true,
    typeAhead: false,
    triggerAction: 'all',
    lazyRender: true,
    valueField: 'ShiftId',
    displayField: 'ShiftName',
    cls: 'selectstylePerfect',
    listeners: {
        select: {
            fn: function() {
                      var row = ShiftNameComboStore.find('ShiftId',Ext.getCmp('ShiftNameComboId').getValue());
	                  var rec = ShiftNameComboStore.getAt(row);
                      if(typeof rec == 'undefined'){
                      Ext.getCmp('DepartureFieldId').setValue('');
                      Ext.getCmp('ArrivalFieldId').setValue('');
                      }else{
                      
                      Ext.getCmp('DepartureFieldId').setValue(rec.data['StartTime']);
                      Ext.getCmp('ArrivalFieldId').setValue(rec.data['EndTime']);
                      }   
                     
             
            }
        }
    }
});

var innerPanelForShiftMasterDetails = new Ext.form.FormPanel({
    standardSubmit: true,
    collapsible: false,
    autoScroll: true,
    height: 220,
    width: 400,
    frame: false,
    id: 'innerPanelForShiftMasterDetailsId',
    layout: 'table',
    layoutConfig: {
        columns: 4
    },
    items: [{
        xtype: 'fieldset',
        title: '<%=AssociateShift%>',
        cls: 'fieldsetpanel',
        collapsible: false,
        colspan: 4,
        id: 'AssociateShiftId',
        width: 360,
        layout: 'table',
        layoutConfig: {
            columns: 4
        },
        items: [{     
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'nameEmptyIdPra'
        },{
            xtype: 'label',
            text: 'Select Branch' + ' :',
            cls: 'labelstyle',
            id: 'BranchNewLabelId'
        }, BranchBombo, 
        {}, {
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'nameEmptyId'
        },{
            xtype: 'label',
            text: '<%=VehicleNo%>' + ' :',
            cls: 'labelstyle',
            id: 'VehicleNoLabelId'
        }, VehicleNoCombo, 
        {},{
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'nameEmptyId1'
        },{
            xtype: 'label',
            text: '<%=ShiftName%>' + ' :',
            cls: 'labelstyle',
            id: 'nameLabelId'
        }, ShiftNameCombo, {},
        
        {
            xtype: 'label',
            text: '',
            cls: 'labelstyle',
            id: 'EmptyId2'
        },{
            xtype: 'label',
            text: '<%=StartTime%>' + ' :',
            cls: 'labelstyle',
            id: 'startTimeLabelId'
        }, {
           xtype: 'textfield',
            		cls: 'selectstylePerfect',
            		allowBlank: false,
            		labelSeparator: ':',
            		allowBlank: false,           	
            		disabled : true,
            		id: 'DepartureFieldId'
           
        }, {},
        
          {
            xtype: 'label',
            text: '',
            cls: 'labelstyle',
            id: 'EmptyId3'
        },{
            xtype: 'label',
            text: '<%=EndTime%>' + ' :',
            cls: 'labelstyle',
            id: 'EndTimeLabelId'
        }, {
            xtype: 'textfield',
					cls: 'selectstylePerfect',
            		allowBlank: false,
            		labelSeparator: ':',
            		allowBlank: false,           		
            		disabled : true,
            		id: 'ArrivalFieldId'
        }, {},

         {
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'statusEmptyId1'
        }, {
            xtype: 'label',
            text: 'Status' + ' :',
            cls: 'labelstyle',
            id: 'statusLabelId'
        },  statuscombo, {}]
    }]
});

var innerPanelForShiftMasterDetailsAdd = new Ext.form.FormPanel({
    standardSubmit: true,
    collapsible: false,
    autoScroll: true,
    height: 440,
    width: 750,
    frame: false,
    id: 'innerPanelForShiftMasterDetailsAddId',
    layout: 'table',
    layoutConfig: {
        columns: 4
    },
    items: [{
        xtype: 'fieldset',
        title: '<%=AssociateShift%>',
        cls: 'fieldsetpanel',
        collapsible: false,
        colspan: 4,
        id: 'AssociateShiftAddId',
        width: 750,
        layout: 'table',
        layoutConfig: {
            columns: 4
        },
        items: [{     
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'nameEmptyIdPraS'
        },{
            xtype: 'label',
            text: 'Select Branch' + ' :',
            cls: 'labelstyle',
            id: 'BranchComboLableIdA'
        }, {
		 xtype: 'combo',        
         store:BranchStore ,
	     displayField:'BranchName',
	     valueField : 'BranchId',
	     mode: 'local',	  
		 forceSelection:true,
	     triggerAction: 'all',
		 selectOnFocus:true,	
         emptyText:'Select Branch',		
	     id: 'branchComboIdP',	
		 loadingText: 'Searching...',
		 enableKeyEvents:true,
	  	 anyMatch:true,
	     onTypeAhead:true,	
	     cls: 'selectstylePerfect',			
		 listeners: {
		     select: {
		         fn:function(){	
		          vehicleNGroupGridStore.load({
								 	params:{
								  	CustId : Ext.getCmp('custcomboId').getValue()								  
								 	}
								 });			 
				   shiftGridStore.load({
                       params: {
                           CustId: Ext.getCmp('custcomboId').getValue(),
                           BranchId: Ext.getCmp('branchComboIdP').getValue()
                       }
                   });		    
                 } // END OF FUNCTION
		      } // END OF SELECT
		  } // END OF LISTENERS		
		}, 
        {}, {
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'vehicleGridManId'
        },{
            xtype: 'label',
            text: '<%=VehicleNo%>' + ' :',
            cls: 'labelstyle',
            id: 'VehicleGridlId'
        }, grid1,
        {},{
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'selectATMEmptyId2'
        },{ },{ },
        {},{
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'ShiftnameEmptyId1'
        },{
            xtype: 'label',
            text: '<%=ShiftName%>' + ' :',
            cls: 'labelstyle',
            id: 'ShiftnameLabelId'
        }, grid2, {},{
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'eEmptyId4'
        },{ },{ },
        {}, 
        {
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'statusGridManId1'
        }, {
            xtype: 'label',
            text: 'Status' + ' :',
            cls: 'labelstyle',
            id: 'statusGridLabelId'
        },  {
        	xtype: 'combo',
          	store: statuscombostore,
		    id: 'statuscomboIdNew',
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
			}, {}]
    }]
});

var innerWinButtonPanel = new Ext.Panel({
    id: 'innerWinButtonPanelId',
    standardSubmit: true,
    collapsible: false,
    autoHeight: true,
    height: 100,
    width: 400,
    frame: false,
    layout: 'table',
    layoutConfig: {
        columns: 4
    },
    buttons: [{
        xtype: 'button',
        text: '<%=Save%>',
        id: 'saveButtonId',
        cls: 'buttonstyle',
        iconCls:'savebutton',
        width: 70,
        listeners: {
            click: {
                fn: function() {
                    if (Ext.getCmp('custcomboId').getValue() == "") {
                    Ext.example.msg("<%=SelectCustomerName%>");
                        return;
                    }
                  
                   if (Ext.getCmp('VehicleNoComboId').getValue() == "") {
                    Ext.example.msg("<%=SelectVehiceleNo%>");
                        return;
                    }
                  
                    if (Ext.getCmp('ShiftNameComboId').getValue() == "") {
                    Ext.example.msg("<%=SelectShiftName%>");
                        return;
                    }
                   
                     if (Ext.getCmp('statuscomboId').getValue() == "") {
                    	Ext.example.msg("Select Status");
                    	return;
                    }       
                    var rec;
                    if (innerPanelForShiftMasterDetails.getForm().isValid()) {
                        if (buttonValue == 'Modify') {
                            var selected = grid.getSelectionModel().getSelected();
                            AsscId = selected.get('AsscIdDataIndex');
                            ShiftId = selected.get('ShiftIdDataIndex');
                        }else{
                        AsscId = 0;
                        ShiftId = Ext.getCmp('ShiftNameComboId').getValue();
                        }
                        Ext.Ajax.request({
                            url: '<%=request.getContextPath()%>/VehicleShiftAssociationAction.do?param=AddorModify',
                            method: 'POST',
                            params: {
                                buttonValue: buttonValue,
                                CustId : Ext.getCmp('custcomboId').getValue(),
                                ShiftId :  ShiftId, 
                                VehicleNo : Ext.getCmp('VehicleNoComboId').getValue(),                            
                                AsscId : AsscId,
                                Status:Ext.getCmp('statuscomboId').getValue()                             
                            },
                            success: function(response, options) {
                                var message = response.responseText;
                                Ext.example.msg(message);
                                
                              
                                Ext.getCmp('VehicleNoComboId').reset();
                                Ext.getCmp('ShiftNameComboId').reset();
                                Ext.getCmp('DepartureFieldId').reset();
                                Ext.getCmp('ArrivalFieldId').reset();
                                Ext.getCmp('statuscomboId').reset();
                              
                                myWin.hide();
                                outerPanel.getEl().unmask();
                                store.load({
                                    params: {
                                        CustId: custId
                                    }
                                });
                            },
                            failure: function() {
                            outerPanel.getEl().unmask();
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
                fn: function() {
                    myWin.hide();
                }
            }
        }
    }]
});

var innerWinButtonPanelAdd = new Ext.Panel({
    id: 'innerWinButtonAddPanelId',
    standardSubmit: true,
    collapsible: false,
    autoHeight: true,
    height: 100,
    width: 750,
    frame: false,
    layout: 'table',
    layoutConfig: {
        columns: 4
    },
    buttons: [{
        xtype: 'button',
        text: '<%=Save%>',
        id: 'saveButtonAddId',
        cls: 'buttonstyle',
        iconCls:'savebutton',
        width: 70,
        listeners: {
            click: {
                fn: function() {
                    if (Ext.getCmp('custcomboId').getValue() == "") {
                    Ext.example.msg("<%=SelectCustomerName%>");
                        return;
                    }                    
	               if (Ext.getCmp('branchComboIdP').getValue() == "") {
	                    Ext.example.msg("<%=selectBranch%>");
	                        return;
	                    }                        
				 var records4 = grid1.getSelectionModel().getSelected();
                       if (records4 == undefined || records4 == "undefined") {
                           Ext.example.msg("Please Select Atleast One  Vehicle Number");
                           return;
                       }
                       
                       var gridData = "";
                       var json1 = "";
                       var records1 = grid1.getSelectionModel().getSelections();
                       for (var i = 0; i < records1.length; i++) {
                           var record1 = records1[i];
                           var gridRow = grid1.store.findExact('slnoIndex', record1.get('slnoIndex'));
                           var internalGridstore = grid1.store.getAt(gridRow);
                           json1 = json1 + Ext.util.JSON.encode(internalGridstore.data) + ',';
                       }
                       
                    var records3 = grid2.getSelectionModel().getSelected();
                       if (records3 == undefined || records3 == "undefined") {
                       Ext.example.msg('Please Select Atleast One Shift To Associate');
                           return;
                       }
                       var gridData2 = "";
                       var json2 = "";
                       var records2 = grid2.getSelectionModel().getSelections();
                       for (var j = 0; j < records2.length; j++) {
                           var record2 = records2[j];
                           var gridRowP = grid2.store.findExact('slnoIndex2', record2.get('slnoIndex2'));
                           var internalGridstoreP = grid2.store.getAt(gridRowP);
                           json2 = json2 + Ext.util.JSON.encode(internalGridstoreP.data) + ',';
                       }                       

                        Ext.Ajax.request({
                            url: '<%=request.getContextPath()%>/VehicleShiftAssociationAction.do?param=AddorModify',
                            method: 'POST',
                            params: {
                                buttonValue: 'Add',
                                CustId : Ext.getCmp('custcomboId').getValue(),                                                                             
                                AsscId : AsscId,
                                Status: Ext.getCmp('statuscomboIdNew').getValue(),
                                BranchId: Ext.getCmp('branchComboIdP').getValue(),
                                VehicleGrid: json1,
                                ShiftGrid:json2                           
                            },
                            success: function(response, options) {
                                var message = response.responseText;
                                Ext.example.msg(message);                                
                               	shiftGridStore.load();
                   			   	vehicleNGroupGridStore.load({
								 	params:{
								  	CustId : Ext.getCmp('custcomboId').getValue()								  
								 	}
								 });
                   			    Ext.getCmp('branchComboId').reset();                   			
                                Ext.getCmp('statuscomboId').reset();
                                myWinNew.hide();
                                outerPanel.getEl().unmask();
                                store.load({
                                    params: {
                                        CustId: custId
                                    }
                                });
                            },
                            failure: function() {
                            outerPanel.getEl().unmask();
                                Ext.example.msg("Error");
                                store.reload();
                                myWinNew.hide();
                            }
                        });
                    
                }
            }
        }
    }, {
        xtype: 'button',
        text: '<%=Cancel%>',
        id: 'canButtAddId',
        cls: 'buttonstyle',
        iconCls: 'cancelbutton',
        width: 70,
        listeners: {
            click: {
                fn: function() {
                    myWinNew.hide();
                }
            }
        }
    }]
});

var ShiftMasteShiftrPanelWindowNew = new Ext.Panel({
    width: 800,
    height: 500,
    standardSubmit: true,
    frame: true,
    items: [innerPanelForShiftMasterDetailsAdd,innerWinButtonPanelAdd]
});

myWinNew = new Ext.Window({
    title: titelForInnerPanel,
    closable: false,
    resizable: false,
    modal: true,
    autoScroll: false,
    height: 550,
    width: 800,
    id: 'myWinNew',
    items: [ShiftMasteShiftrPanelWindowNew]
});

var ShiftMasteShiftrPanelWindow = new Ext.Panel({
    width: 410,
    height: 350,
    standardSubmit: true,
    frame: true,
    items: [innerPanelForShiftMasterDetails, innerWinButtonPanel]
});

myWin = new Ext.Window({
    title: titelForInnerPanel,
    closable: false,
    resizable: false,
    modal: true,
    autoScroll: false,
    height: 320,
    width: 430,
    id: 'myWin',
    items: [ShiftMasteShiftrPanelWindow]
});

function addRecord() {
    if (Ext.getCmp('custcomboId').getValue() == "") {
     Ext.example.msg("<%=SelectCustomerName%>");
        return;
    }
    buttonValue = '<%=Add%>';
    titelForInnerPanel = '<%=AssociateVehicleShift%>';
    myWinNew.setPosition(360, 60);
    myWinNew.show();
   // myWinNew.setHeight(550);      
       Ext.getCmp('branchComboIdP').reset();
       Ext.getCmp('statuscomboIdNew').reset();
       vehicleNGroupGridStore.reload();
       shiftGridStore.load();
    myWin.setTitle(titelForInnerPanel);
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
    titelForInnerPanel = '<%=ModifyDetails%>';
    myWin.setPosition(450, 150);
    myWin.setTitle(titelForInnerPanel);
    myWin.show();
 
    var selected = grid.getSelectionModel().getSelected();
    
      Ext.getCmp('VehicleNoComboId').setValue(selected.get('VehicleNoDataIndex'));
      Ext.getCmp('ShiftNameComboId').setValue(selected.get('ShiftNameIndex'));
      Ext.getCmp('DepartureFieldId').setValue(selected.get('StartTimeIndex'));
      Ext.getCmp('ArrivalFieldId').setValue(selected.get('EndTimeIndex'));
      Ext.getCmp('statuscomboId').setValue(selected.get('statusIndex'));
      Ext.getCmp('branchComboId').setValue(selected.get('branchIDIndex'));
      Ext.getCmp('VehicleNoComboId').disable();
      Ext.getCmp('branchComboId').disable();
      shiftGridStore.load({
                       params: {
                           CustId: Ext.getCmp('custcomboId').getValue(),
                           BranchId: selected.get('branchIDIndex')
                       }
                   });	
}

function deleteData() {
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
      var selected = grid.getSelectionModel().getSelected();
      AsscId = selected.get('AsscIdDataIndex');
      outerPanel.getEl().mask();
   Ext.Ajax.request({
                            url: '<%=request.getContextPath()%>/VehicleShiftAssociationAction.do?param=deleteAssociateDetails',
                            method: 'POST',
                            params: {
                              
                                CustId : Ext.getCmp('custcomboId').getValue(),                             
                                AsscId : AsscId                              
                            },
                            success: function(response, options) {
                                var message = response.responseText;
                                Ext.example.msg(message);
                                outerPanel.getEl().unmask();
                                store.load({
                                    params: {
                                        CustId: custId
                                    }
                                });
                            },
                            failure: function() {
                                Ext.example.msg("Error");
                                store.reload();
                            }
                        });
   
}

var reader = new Ext.data.JsonReader({
    idProperty: 'Id23',
    root: 'ShiftVehicleAssociationRoot',
    totalProperty: 'total',
    fields: [{
        name: 'slnoIndex'
    }, {
        name: 'AsscIdDataIndex'
    },  {
        name: 'VehicleNoDataIndex'
    },{
        name: 'ShiftNameIndex'
    }, {
        name: 'StartTimeIndex'
    },{
        name: 'EndTimeIndex'
    },{
        name: 'statusIndex'
    },{
        name: 'vehicleGroup'
    },{
        name: 'branchIndex'
    },{
        name: 'branchIDIndex'
    },{
     name: 'ShiftIdDataIndex'
    }]
});

var store = new Ext.data.GroupingStore({
    autoLoad: false,
    proxy: new Ext.data.HttpProxy({
        url: '<%=request.getContextPath()%>/VehicleShiftAssociationAction.do?param=getAssociationDetails',
        method: 'POST'
    }),
    storeId: 'getAssociationDetailsId',
    reader: reader
});

var filters = new Ext.ux.grid.GridFilters({
    local: true,
    filters: [{
        type: 'numeric',
        dataIndex: 'slnoIndex'
    },  {
        type: 'string',
        dataIndex: 'AsscIdDataIndex'
    }, {
        type: 'string',
        dataIndex: 'VehicleNoDataIndex'
    }, {
        type: 'string',
        dataIndex: 'ShiftNameIndex'
    }, {
        type: 'string',
        dataIndex: 'StartTimeIndex'
    }, {
        type: 'string',
        dataIndex: 'EndTimeIndex'
    },  {
        type: 'string',
        dataIndex: 'statusIndex'
    },  {
        type: 'string',
        dataIndex: 'vehicleGroup'
    },  {
        type: 'string',
        dataIndex: 'branchIndex'
    },  {
        type: 'string',
        dataIndex: 'branchIDIndex'
    },  {
        type: 'string',
        dataIndex: 'ShiftIdDataIndex'
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
        }, {
            header: "<span style=font-weight:bold;><%=AsscID%></span>",
            dataIndex: 'AsscIdDataIndex',
            width: 50,
            hidden:true,
            filter: {
                type: 'string'
            },
        }, {
            header: "<span style=font-weight:bold;><%=VehicleNo%></span>",
            dataIndex: 'VehicleNoDataIndex',
            width: 50,            
            filter: {
                type: 'string'
            }
            }, {
            header: "<span style=font-weight:bold;>Vehicle Group</span>",
            dataIndex: 'vehicleGroup',
            width: 50,            
            filter: {
                type: 'string'
            }
            }, {
            header: "<span style=font-weight:bold;><%=ShiftName%></span>",
            dataIndex: 'ShiftNameIndex',
            width: 50,
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;><%=StartTime%></span>",
            dataIndex: 'StartTimeIndex',
            width: 50,
            filter: {
                type: 'string'
            }
        },
        {
            header: "<span style=font-weight:bold;><%=EndTime%></span>",
            dataIndex: 'EndTimeIndex',
            width: 50,
            filter: {
                type: 'string'
            }
        },
        {
            header: "<span style=font-weight:bold;><%=Status%></span>",
            dataIndex: 'statusIndex',
            width: 50,
            filter: {
                type: 'string'
            }
        },
        {
            header: "<span style=font-weight:bold;><%=branch%></span>",
            dataIndex: 'branchIndex',
            width: 50,
            filter: {
                type: 'string'
            }
        },
        {
            header: "Branch ID",
            dataIndex: 'branchIDIndex',
            hidden:true
        },
         {
            header: "Shift ID",
            dataIndex: 'ShiftIdDataIndex',
            hidden:true
        }
        
    ];
    return new Ext.grid.ColumnModel({
        columns: columns.slice(start || 0, finish),
        defaults: {
            sortable: true
        }
    });
};

grid = getGrid('<%=VehicleShiftAssociationDetails%>', '<%=NoRecordsFound%>', store, screen.width - 40, 440, 12, filters, '<%=ClearFilterData%>', false, '', 16, false, '', false, '', false, '<%=Excel%>', jspName, exportDataType, false, 'PDF', true, '<%=Add%>', true, '<%=Modify%>', true, '<%=Delete%>');

Ext.onReady(function() {
    Ext.QuickTips.init();
    Ext.form.Field.prototype.msgTarget = 'side';
    outerPanel = new Ext.Panel({
        title: '<%=VehicleShiftAssociation%>',
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
});</script>
<jsp:include page="../Common/footer.jsp" />
 <!-- </body>   -->
 <!-- </html> -->