<%@ page language="java" import="java.util.*,java.text.SimpleDateFormat,t4u.functions.*,t4u.beans.*,t4u.common.*" pageEncoding="utf-8"%>
<%@ taglib uri="http://packtag.sf.net" prefix="pack" %>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
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
if(session.getAttribute("responseaftersubmit")!=null){
   	responseaftersubmit="'"+session.getAttribute("responseaftersubmit").toString()+"'";
	session.setAttribute("responseaftersubmit",null);
}		
LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
String language = loginInfo.getLanguage();
int systemId = loginInfo.getSystemId();
int customerId = loginInfo.getCustomerId();
int userId = loginInfo.getUserId();
int custId= 0;
String custName="";
String onload="";
boolean finalSubmit = true;
boolean modify = true;
String userAuthority=cf.getUserAuthority(systemId,userId);
if(userAuthority.equalsIgnoreCase("Admin")){
	finalSubmit = false;
	modify = false;
}
if(request.getParameter("custId") != null && !request.getParameter("custId").equals("") && request.getParameter("custName") != null && !request.getParameter("custName").equals("")){
	custId = Integer.parseInt(request.getParameter("custId")); 
	custName = request.getParameter("custName");
}
if(request.getParameter("onload") != null && !request.getParameter("onload").equals("")){
	onload= request.getParameter("onload");
}
String startdate="";
String enddate="";

%>


<jsp:include page="../Common/header.jsp" />
    <base href="<%=basePath%>">
    
    <title>UnblockSandVehicles</title>
    
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">


     <%if (loginInfo.getStyleSheetOverride().equals("Y")){%>
	<jsp:include page="../Common/ImportJSSandMining.jsp"/>
	<%}else{%>
	<jsp:include page="../Common/ImportJS.jsp" />
   	<%}%>
   	<jsp:include page="../Common/ExportJS.jsp" />
	 <% String newMenuStyle=loginInfo.getNewMenuStyle();
		if(newMenuStyle.equalsIgnoreCase("YES")){%>
		<style>							
			label {
				display : inline !important;
			}			
			.ext-strict .x-form-text {
				height: 21px !important;
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
		
			#vehicleNoIdNew{
				margin-left: -24px !important;
			}
			#vehiclenNoLabelId {
				/*margin-left: -46px !important; */
				margin-left: -60px !important;
			}
			#vehiclecomboId {
				/*margin-left : -58px !important; */
				margin-left : -150px !important;
			}
			#blockedDateLabelId {
				margin-right: -36px !important;
    			margin-left: -25px !important;
			}
			#blockDateIdNew {
				/*margin-left: -59px !important; */
				 margin-left: -150px !important;
			}
			#blockingReasonLabelId {
				/*margin-left: 99px !important; */
			}
			#remarksIdNew {
			  /*  margin-left: -60px !important; */
			    margin-left: -151px !important;
			}
			#blockedRemarksLabelIdNew {
				margin-left: -1px !important;
			}
			#blockReasonComboId {
				/*margin-left: 97px !important; */
			}
		/*	#addButtonId {
				margin-left: -25% !important;
			}
			#canButtonId {
				margin-right : 140px !important;
			}  */
		</style>
	 <%}%>
   	<script>
   	var jspName = "Unblock Sand Vehicles";
	var exportDataType = "int,string,string,string,string,string,string,int";
	var custId = '<%=custId%>';
	var custName = '<%=custName%>';
	var onload = '<%=onload%>';
	var userAuthority = '<%=userAuthority%>' ;
	var dateprev = new Date().add(Date.DAY, -14); //15 days  ago date
	var datenext = new Date().add(Date.DAY, 1);   //next day date
	var loadMask = new Ext.LoadMask(Ext.getBody(), { msg: "Redirecting To Form" });
	var loadMasks = new Ext.LoadMask(Ext.getBody(), { msg: "Saving" });
	var currDate = new Date();
	var dtcur = datecur;
	var monthlyFormId;
	var blockedby;
	var id;
	var checkPenalty="No";
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
		                //store.load({params:{custId:custId,custName:Ext.getCmp('custcomboId').getRawValue(),startdate:Ext.getCmp('startDateId').getValue(),endate:Ext.getCmp('endDateId').getValue(),userAuthority:userAuthority,jspName:jspName}});
		                 vehicleComboStore.load({
     					 });
		            }
		        }
		        
		        
		    }
	});
     var client = new Ext.form.ComboBox({
	    store: clientcombostore,
	    id: 'custcomboId',
	    mode: 'local',
	    forceSelection: true,
	    emptyText: 'select customer name',
	    blankText: 'select customer name',
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
	            		//store.load({params:{custId:custId,custName:Ext.getCmp('custcomboId').getRawValue(),startdate:Ext.getCmp('startDateId').getValue(),enddate:Ext.getCmp('endDateId').getValue(),userAuthority:userAuthority,jspName:jspName}});	                 
	            }
	        }
	    }
	});
  	  var clientCombo=new Ext.Panel({
	        standardSubmit: true,
	        collapsible: false,
	        id: 'clientPanelId',
	        layout: 'table',
	        frame: true,
	        width: screen.width - 35,    
	        layoutConfig: {
	            columns: 19
	        },
	        items: [{
	                xtype: 'label',
	                text: 'CustomerName' + ' :',
	                cls: 'labelstyle',
	                id: 'custnamelab'
	            },
	            client,
				{   xtype: 'label',
	                text: '',
	                cls: 'labelstyle',
	                width:50,
	                id: 'empty1'
				}, {width:20},
	            {}, 
				{},
				{   xtype: 'label',
	                text: '',
	                cls: 'labelstyle',
	                 width:50,
	                id: 'empty2'
				}, 
				{width:20},
				{   xtype: 'label',
	                text: '',
	                cls: 'labelstyle',
	                 width:50,
	                id: 'empty4'
				},
				{
	            xtype: 'label',
	            cls: 'labelstyle',
	            id: 'startdatelab2',
	            width: 200,
	            text: 'StartDate' + ' :'
	            },  
				{
	            xtype: 'datefield',          
	            emptyText: 'SelectStartDate',
	            allowBlank: false,
	            blankText: 'SelectStartDate',
	            id: 'startDateId',        
	            cls: 'selectstylePerfect' ,
	            format: getDateFormat(),
	            value: previousDate, 
	            },
				{
				    xtype: 'label',
	                text: '',
	                cls: 'labelstyle',
	                width:50,
	                id: 'empty3'
				},
				{width:20},
				{
	            xtype: 'label',
	            cls: 'labelstyle',
	            id: 'endDatelablepmr',
	            width: 200,
	            text: 'EndDate' + ' :'
	            },  
				{
	            xtype: 'datefield',          
	            emptyText: 'SelectEndDate',
	            allowBlank: false,
	            blankText: 'SelectEndDate',
	            id: 'endDateId',        
	            cls: 'selectstylePerfect' ,
	            format: getDateFormat(),
	            value: datenext, 
	            },
				
				{   xtype: 'label',
	                text: '',
	                cls: 'labelstyle',
	                width:50,
	                id: 'emptyPm'
				},{width:20},
				{   xtype: 'label',
	                text: '',
	                cls: 'labelstyle',
	                 width:100,
	                id: 'emptyp'
				},
				{
	            xtype: 'button',
	            width:100,
	            style:'margin-left:100px;font-size:13px;font-family:sans-serif;',
	            id:'viewId',
	            text: 'View',
	            handler: function(){
	            	if (Ext.getCmp('custcomboId').getValue() == "") {
                        Ext.example.msg("Enter Customer Name");
                        Ext.getCmp('custcomboId').focus();
                        return;
                    }
                    if (Ext.getCmp('startDateId').getValue() == "") {
                        Ext.example.msg("Select Start Date");
                        Ext.getCmp('startDateId').focus();
                        return;
                    }
                    if (Ext.getCmp('endDateId').getValue() == "") {
                        Ext.example.msg("Select End Date");
                        Ext.getCmp('endDateId').focus();
                        return;
                    }
                    if (dateCompare(Ext.getCmp('startDateId').getValue(), Ext.getCmp('endDateId').getValue()) == -1) {
                     Ext.example.msg("EndDate Must Be Greater than StartDate");
                     Ext.getCmp('endDateId').focus();
                     return;
                    }
	            	store.load({params:{custId:custId,startdate:Ext.getCmp('startDateId').getValue(),enddate:Ext.getCmp('endDateId').getValue(),jspname:jspName}});
	            	}
	        }
	        ]
	    });
	
	var unblockReasonStore = new Ext.data.SimpleStore({
    id: 'unblockReasonId',
    autoLoad: true,
    fields: ['Name', 'Value'],
    data: [
        ['DC given instructions', '1'],
        ['SP given instructions', '2'],
        ['EE given instructions','3'],
        ['AEE given instructions','4'],
        ['DMG given instructions','5']
    ]
});

var unblockReasonCombo = new Ext.form.ComboBox({
    store: unblockReasonStore,
    id: 'unblockReasonComboId',
    mode: 'local',
    forceSelection: true,
    selectOnFocus: true,
    allowBlank: false,
    anyMatch: true,
    typeAhead: false,
    triggerAction: 'all',
    lazyRender: true,
    valueField: 'Value',
    emptyText: 'Select Unblock Reason',
    displayField: 'Name',
    cls: 'selectstylePerfect'
});

var blockReasonStore = new Ext.data.SimpleStore({
    id: 'blockReasonId',
    autoLoad: true,
    fields: ['Name', 'Value'],
    data: [
        ['No MDP', '1'],
        ['Multiple visits with One MDP', '2'],
        ['Different location MDP','3']
    ]
});

var blockReasonCombo = new Ext.form.ComboBox({
    store: blockReasonStore,
    id: 'blockReasonComboId',
    mode: 'local',
    forceSelection: true,
    selectOnFocus: true,
    allowBlank: false,
    anyMatch: true,
    typeAhead: false,
    triggerAction: 'all',
    lazyRender: true,
    valueField: 'Value',
    emptyText: 'Select Block Reason',
    displayField: 'Name',
    cls: 'selectstylePerfect'
});

//****************************************************************************Reader Filter & Column**************************************************************************		
	var reader = new Ext.data.JsonReader({
      idProperty: 'unblockSandRootId',
      root: 'unblockSandRoot',
      totalProperty: 'total',
      fields: [{
          		name: 'SNOIndex'
      		 },{
          		name: 'VehicleNoIndex'
      		 },{
          		name: 'VehicleGroupIndex'
      		 },{
          		name: 'BlockedReasonIndex'
      		 },{
          		name: 'BlockedRemarksIndex'
      		 },{
          		name: 'BlockedDateIndex'
      		 },{
          		name: 'BlockedByIndex'
      		 },{
          		name: 'IdIndex'
      		 }]
    });
    var filters = new Ext.ux.grid.GridFilters({
        local: true,
        filters: [{
			        type: 'int',
			        dataIndex: 'SNOIndex'
			    },{
		            type: 'string',
		            dataIndex: 'VehicleNoIndex',		            
        		 },{
		            type: 'string',
		            dataIndex: 'VehicleGroupIndex',		            
        		 },{
		            type: 'string',
		            dataIndex: 'BlockedReasonIndex',		            
        		 },{
		            type: 'string',
		            dataIndex: 'BlockedRemarksIndex',		            
        		 },{
		            type: 'string',
		            dataIndex: 'BlockedDateIndex',		            
        		 },{
		            type: 'string',
		            dataIndex: 'BlockedByIndex',		            
        		 },{
		            type: 'int',
		            dataIndex: 'IdIndex',		            
        		 }]
    });
    var createColModel = function(finish, start) {
	    var columns = [
	     	new Ext.grid.RowNumberer({
	            header : "<span style=font-weight:bold;>SLNO</span>",
	            width : 50
	        }),{
	            header: "<span style=font-weight:bold;>SLNO</span>",
	            width: 30,
	            hidden: true,	            
				dataIndex: 'SNOIndex'
	        },{
		        header: "<span style=font-weight:bold;>Vehicle No</span>",
		        sortable: true,
		        hidden: false,
		        dataIndex: 'VehicleNoIndex'
		    },{
		        header: "<span style=font-weight:bold;>Vehicle Group</span>",
		        sortable: true,
		        hidden: false,
		        dataIndex: 'VehicleGroupIndex'
		    },{
		        header: "<span style=font-weight:bold;>Blocked Reason</span>",
		        sortable: true,
		        hidden: false,
		        dataIndex: 'BlockedReasonIndex'
		    },{
		        header: "<span style=font-weight:bold;>Blocked Remarks</span>",
		        sortable: true,
		        hidden: false,
		        dataIndex: 'BlockedRemarksIndex'
		    },{
		        header: "<span style=font-weight:bold;>Blocked Date</span>",
		        sortable: true,
		        hidden: false,
		        dataIndex: 'BlockedDateIndex'
		    },{
		        header: "<span style=font-weight:bold;>Blocked By</span>",
		        sortable: true,
		        hidden: true,
		        hideable: false,
		        dataIndex: 'BlockedByIndex'
		    },{
		        header: "<span style=font-weight:bold;>Id</span>",
		        sortable: true,
		        hidden: true,
		        hideable: false,
		        dataIndex: 'IdIndex'
		    }];
	    return new Ext.grid.ColumnModel({
	        columns: columns.slice(start || 0, finish),  
	        defaults: {
	            sortable: true
	        }
	    });
	};
	var store = new Ext.data.GroupingStore({
        autoLoad: false,
        proxy: new Ext.data.HttpProxy({
            url: '<%=request.getContextPath()%>/SandMiningAction.do?param=getBlockedVehicleDetails',
           method: 'POST'
       }),
       reader: reader
    });
    
    	
var vehicleComboStore = new Ext.data.JsonStore({
    url: '<%=request.getContextPath()%>/SandMiningAction.do?param=getRegisteredVehicles',
    id: 'vehicleStoreId',
    root: 'VehiclesRoot',
    autoload: true,
    remoteSort: true,
    fields: ['vehicleNo'],
    listeners: {
        load: function() {}
    }
});

var vehicleCombo = new Ext.form.ComboBox({
    store: vehicleComboStore,
    id: 'vehiclecomboId',
    mode: 'local',
    forceSelection: true,
    emptyText: 'Vehicle No',
    blankText: 'Vehicle No',
    selectOnFocus: true,
    allowBlank: true,
    anyMatch: true,
    typeAhead: false,
    triggerAction: 'all',
    lazyRender: true,
    //valueField: 'StateID',
    displayField: 'vehicleNo',
    cls: 'selectstylePerfect',
    listeners: {
        select: {
            fn: function() {
            }
        }
    }
});
    
//****************************************************************************Grid Store**************************************************************************
    grid = getGrid('','noRecordFound',store,screen.width - 40,380,20,filters,'clearFilterData',false,'',9,false,'',false,'',true,'Excel',jspName,exportDataType,false,'',true,'Add',false,'Modify',false,'',false,'',true,'Unblock Vehicles');
/****************************************************************************Ext onReady Outer panel window**************************************************************************/
//12345
 var innerPanelForBlockingVehicleDetailsNew = new Ext.form.FormPanel({
      standardSubmit: true,
      collapsible: false,
      autoScroll: true,
     // height: 170,
     // width: 430,
      height: 300,
      width: 430,
      frame: true,
      id: 'innerPanelForBlockingVehicleDetailsNewId',
      layout: 'table',
      resizable: true,
      layoutConfig: {
         columns: 5
      },

      items: [ {
              height: 30
          }, {
              xtype: 'label',
              text: '*',
              cls: 'mandatoryfield',
              id: 'vehicleNoIdNew'
          }, {
              xtype: 'label',
              text: 'Vehicle No' + ' :',
              cls: 'labelstyle',
              id: 'vehiclenNoLabelId'
          }, vehicleCombo, {
              height: 30
          },  {
              xtype: 'label',
              text: '',
              cls: 'mandatoryfield',
              id: 'blockedDateId'
          }, {
              xtype: 'label',
              text: 'Blocking Date' + ' :',
              cls: 'labelstyle',
              //format: getDateFormat(),
              id: 'blockedDateLabelId',
              
          }, {
              xtype: 'label',
              text: '',
              cls: 'mandatoryfield',
              id: 'blockedDateId2'
          }, {
	            xtype: 'datefield',          
	            emptyText: '',
	            allowBlank: false,
	            blankText: '',
	            id: 'blockDateIdNew',        
	            cls: 'selectstylePerfect' ,
	            format: getDateFormat(),
	            value: currDate, 
	            disabled: true,
	       }, {
              height: 30
           }, {
              xtype: 'label',
              text: '*',
              cls: 'mandatoryfield',
              id: 'blockingReasonEmptyId'
           }, {
              xtype: 'label',
              text: 'Reason' + ' :',
              cls: 'labelstyle',
              id: 'blockingReasonLabelId'
          }, blockReasonCombo, {
              height: 30
           }, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'blockingreasonEmptyId2'
          },
          {
              xtype: 'label',
              text: '*',
              cls: 'mandatoryfield',
              id: 'blockedRemarksIdNew'
          }, {
              xtype: 'label',
              text: 'Remarks' + ' :',
              cls: 'labelstyle',
              id: 'blockedRemarksLabelIdNew'
          }, {
              xtype: 'label',
              text: '',
              cls: 'mandatoryfield',
              id: 'blockedRemarksId2'
          }, {
              xtype: 'textarea',
              cls: 'selectstylePerfect',
              allowBlank: false,
              id: 'remarksIdNew',
              resizable: true,
              blankText: 'Enter Remarks',
              emptyText: 'Enter Remarks'
          } 
      ]

  });
 var innerPanelForBlockingVehicleDetails = new Ext.form.FormPanel({
      standardSubmit: true,
      collapsible: false,
      autoScroll: true,
      height: 300,
      width: 430,
      frame: true,
      id: 'innerPanelForBlockingVehicleDetailsId',
      layout: 'table',
      resizable: true,
      layoutConfig: {
          columns: 5
      },

      items: [{
              height: 30
          }, {
              xtype: 'label',
              text: '*',
              cls: 'mandatoryfield',
              id: 'vehicleNoEmptyId'
          }, {
              xtype: 'label',
              text: 'Vehicle No' + ' :',
              cls: 'labelstyle',
              id: 'vehiclenoLabelId'
          }, {
              xtype: 'label',
              text: '',
              cls: 'mandatoryfield',
              id: 'vehicleNoEmptyId2'
          }, {
              xtype: 'textfield',
              cls: 'selectstylePerfect',
              id: 'vehicleNoID',
              allowBlank: false,
              blankText: '',
              emptyText: '',
              autoCreate: {
                  tag: "input",
                  maxlength: 50,
                  type: "text",
                  size: "200",
                  autocomplete: "off"
              },
              disabled: true,
              mode: 'local',
              labelSeparator: ''
          }, {
              height: 30
          }, {
              xtype: 'label',
              text: '*',
              cls: 'mandatoryfield',
              id: 'blockedReasonEmptyId'
          }, {
              xtype: 'label',
              text: 'Blocked Reason' + ' :',
              cls: 'labelstyle',
              id: 'blockedReasonLabelId'
          }, {
              xtype: 'label',
              text: '',
              cls: 'mandatoryfield',
              id: 'blockreasonEmptyId2'

          }, {
              xtype: 'textfield',
              cls: 'selectstylePerfect',
              id: 'blockedReasonID',
              allowBlank: false,
              blankText: '',
              emptyText: '',
              autoCreate: {
                  tag: "input",
                  maxlength: 50,
                  type: "text",
                  size: "200",
                  autocomplete: "off"
              },
              disabled: true,
              mode: 'local',
              labelSeparator: ''
          }, {
              height: 30
          }, {
              xtype: 'label',
              text: '*',
              cls: 'mandatoryfield',
              id: 'blockedremarksEmptyId'
          }, {
              xtype: 'label',
              text: 'Blocked Remarks' + ' :',
              cls: 'labelstyle',
              id: 'blockedremarksLabelId'
          }, {
              xtype: 'label',
              text: '',
              cls: 'mandatoryfield',
              id: 'blockedremarksEmptyId2'
          }, {
              xtype: 'textfield',
              cls: 'selectstylePerfect',
              id: 'blockedremarksID',
              allowBlank: false,
              blankText: '',
              emptyText: '',
              autoCreate: {
                  tag: "input",
                  maxlength: 50,
                  type: "text",
                  size: "200",
                  autocomplete: "off"
              },
              disabled: true,
              mode: 'local',
              labelSeparator: ''
          }, {
              height: 30
          }, {
              xtype: 'label',
              text: '*',
              cls: 'mandatoryfield',
              id: 'blockeddateEmptyId'
          }, {
              xtype: 'label',
              text: 'Blocked Date' + ' :',
              cls: 'labelstyle',
              id: 'blockeddateLabelId'
          }, {
              xtype: 'label',
              text: '',
              cls: 'mandatoryfield',
              id: 'blockeddateEmptyId2'
          }, {
              xtype: 'textfield',
              cls: 'selectstylePerfect',
              id: 'blockeddateID',
              allowBlank: false,
              blankText: '',
              emptyText: '',
              autoCreate: {
                  tag: "input",
                  maxlength: 50,
                  type: "text",
                  size: "200",
                  autocomplete: "off"
              },
              disabled: true,
              mode: 'local',
              labelSeparator: ''
          }, {
              height: 30
          }, {
              xtype: 'label',
              text: '*',
              cls: 'mandatoryfield',
              id: 'unblockingReasonEmptyId'
          }, {
              xtype: 'label',
              text: 'Unblocking Reason' + ' :',
              cls: 'labelstyle',
              id: 'unblockingReasonLabelId'
          }, {
              xtype: 'label',
              text: '',
              cls: 'mandatoryfield',
              id: 'blockingreasonEmptyId2'
          }, unblockReasonCombo, {
              height: 30
          }, {
              xtype: 'label',
              text: '*',
              cls: 'mandatoryfield',
              id: 'penaltyId'
          }, {
              xtype: 'label',
              text: 'Penalty Collected ?' + ' :',
              cls: 'labelstyle',
              id: 'penaltyLabelId'
          }, {
              xtype: 'radio',
              boxLabel: 'Yes',
              name: 'rb',
              inputValue: '3',
              checked: false,
              id: 'penaltyyes',
              listeners:{		        
		      check:{fn:function(){
		      if(this.checked){
		      checkPenalty="Yes";
		      Ext.getCmp('penaltyyesID').enable();
		      }
		      }
		      }
		      }
          }, {
              xtype: 'numberfield',
              cls: 'selectstylePerfect',
              allowBlank: false,
              id: 'penaltyyesID',
              autoCreate: {//restricts user to 6 chars max, 
                   tag: "input",
                   maxlength: 10,
                   type: "text",
                   size: "6",
                   autocomplete: "off"
               },
              blankText: 'Enter Penalty Amount',
              emptyText: 'Enter Penalty Amount'
          }, {
              height: 30
          }, {
              xtype: 'label',
              text: '',
              cls: 'mandatoryfield',
              id: 'penaltynoId'
          }, {
              xtype: 'label',
              text: '',
              cls: 'labelstyle',
              id: 'penaltynoLabelId'
          }, {
              xtype: 'radio',
              boxLabel: 'No',
              name: 'rb',
              inputValue: '3',
              checked: true,
              id:'penaltynoID',
              listeners:{		        
		      check:{fn:function(){
		      if(this.checked){
		      checkPenalty="No";
		      Ext.getCmp('penaltyyesID').disable();
		      Ext.getCmp('penaltyyesID').reset();
		      }
		      }
		      }
		      }
          }, {
              xtype: 'label',
              text: '',
              cls: 'mandatoryfield',
              id: 'penaltynoId2'
          }, {
              height: 30
          }, {
              xtype: 'label',
              text: '*',
              cls: 'mandatoryfield',
              id: 'remarksEmptyId'
          }, {
              xtype: 'label',
              text: 'Remarks' + ' :',
              cls: 'labelstyle',
              id: 'remarksLabelId'
          }, {

              xtype: 'label',
              text: '',
              cls: 'mandatoryfield',
              id: 'remarksEmptyId2'
          }, {
              xtype: 'textarea',
              cls: 'selectstylePerfect',
              allowBlank: false,
              id: 'remarksID',
              resizable: true,
              blankText: 'Enter Remarks',
              emptyText: 'Enter Remarks'
          }

      ]

  });
  
  var innerWinButtonPanel = new Ext.Panel({
      id: 'winbuttonid',
      standardSubmit: true,
      collapsible: false,
      autoHeight: true,
      height: 230,
      width: 430,
      frame: true,
      layout: 'table',
      layoutConfig: {
          columns: 4
      },
      buttons: [{
          xtype: 'button',
          text: 'Submit',
          id: 'addButtId',
          cls: 'buttonstyle',
          iconCls: 'savebutton',
          width: 70,
          listeners: {
          click: {
          fn :function() {
           if (Ext.getCmp('unblockReasonComboId').getRawValue() == "") {
            Ext.example.msg("select Unblock Reason");
             return;
           }
           if(checkPenalty== "Yes"){
           if (Ext.getCmp('penaltyyesID').getValue() == "") {
             Ext.example.msg("Enter Penalty Amount");
                        return;
           }
           }
            if (Ext.getCmp('remarksID').getValue() == "") {
             Ext.example.msg("Enter Remarks");
                        return;
           }
          Ext.Ajax.request({
                            url: '<%=request.getContextPath()%>/SandMiningAction.do?param=UnBlockVehicles',
                            method: 'POST',
                            params: {
                                buttonValue: buttonValue,
                                CustId: Ext.getCmp('custcomboId').getValue(),
                                vehicleno: Ext.getCmp('vehicleNoID').getValue(),
                                blockedReason: Ext.getCmp('blockedReasonID').getValue(),
                                blockedremarks: Ext.getCmp('blockedremarksID').getValue(),
                                blockeddate: Ext.getCmp('blockeddateID').getValue(),
                                unblockingReason: Ext.getCmp('unblockReasonComboId').getRawValue(),
                                blockedby: blockedby,
                                Id: id,
                                remarks: Ext.getCmp('remarksID').getValue(),
                                checkPenalty: checkPenalty,
                                checkPenaltyAmt: Ext.getCmp('penaltyyesID').getValue()
                                
                            },
                            success: function(response, options) {
                                var message = response.responseText;
                                Ext.example.msg(message);
							    Ext.getCmp('unblockReasonComboId').reset();
								Ext.getCmp('remarksID').reset();
								Ext.getCmp('vehicleNoID').reset();
								Ext.getCmp('blockedReasonID').reset();
								Ext.getCmp('blockeddateID').reset();
								Ext.getCmp('blockedremarksID').reset();
                                myWin.hide();
	            	store.load({params:{custId:custId,startdate:Ext.getCmp('startDateId').getValue(),enddate:Ext.getCmp('endDateId').getValue(),jspname:jspName}});
                            },
                            failure: function() {
                                Ext.example.msg("Error");
                                store.reload();
                                myWin.hide();
                            }
                        });
                }
            }
        }
      }, {
        xtype: 'button',
        text: 'Cancel',
        id: 'canButtId',
        cls: 'buttonstyle',
        iconCls: 'cancelbutton',
        width: 70,
        listeners: {
            click: {
                fn: function() {
                Ext.getDom('penaltynoID').checked = true;
                myWin.hide();
                myWinNew.hide();
                }
            }
        }
    }]
  });
  
  var BlockingOuterPanelWindow = new Ext.Panel({
      width: 450,
      height: 370,
      standardSubmit: true,
      frame: true,
      items: [innerPanelForBlockingVehicleDetails, innerWinButtonPanel]
  });
  
  
  var innerWinButtonPanelNew = new Ext.Panel({
      id: 'winButtonIdNew',
      standardSubmit: true,
      collapsible: false,
      autoHeight: true,
   //   height: 90,
   //   width: 390,
      height: 230,
      width: 430,
      frame: true,
      layout: 'table',
      layoutConfig: {
          columns: 4
      },
      buttons: [{
          xtype: 'button',
          text: 'Submit',
          id: 'addButtonIdNew',
          cls: 'buttonstyle',
          iconCls: 'savebutton',
          width: 70,
          listeners: {
          click: {
          fn :function() {
           if (Ext.getCmp('vehiclecomboId').getRawValue() == "") {
            Ext.example.msg("Select Vehicle ");
             return;
           }
           if (Ext.getCmp('blockReasonComboId').getRawValue() == "") {
            Ext.example.msg("Select Blocking Reason");
             return;
           }
           if (Ext.getCmp('remarksIdNew').getValue() == "") {
             Ext.example.msg("Enter Remarks");
             return;
          }
          Ext.Ajax.request({
                            url: '<%=request.getContextPath()%>/SandMiningAction.do?param=InsertBlockedVehicles',
                            method: 'POST',
                            params: {
                                buttonValue: buttonValue,
                                CustId: Ext.getCmp('custcomboId').getValue(),
                                vehicleno: Ext.getCmp('vehiclecomboId').getValue(),
                              	remarks: Ext.getCmp('remarksIdNew').getRawValue(),
                               	blockingReason : Ext.getCmp('blockReasonComboId').getValue()
                            },
                            success: function(response, options) {
                                var message = response.responseText;
                                Ext.example.msg(message);
							    Ext.getCmp('remarksIdNew').reset();
								Ext.getCmp('blockReasonComboId').reset();
								Ext.getCmp('vehiclecomboId').reset();
                                myWinNew.hide();
                            },
                            failure: function() {
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
        text: 'Cancel',
        id: 'canButtonId',
        cls: 'buttonstyle',
        iconCls: 'cancelbutton',
        width: 70,
        listeners: {
            click: {
                fn: function() {
                    myWinNew.hide();
                    myWin.hide();
                }
            }
        }
    }]
  });
  
   var BlockingOuterPanelWindowNew = new Ext.Panel({
     // width: 450,
     // height: 250,
      width: 450,
      height: 370,
      standardSubmit: true,
      frame: false,
      items: [innerPanelForBlockingVehicleDetailsNew,innerWinButtonPanelNew]
  });
  
  myWin = new Ext.Window({
      title: 'titelForInnerPanel',
      closable: false,
      resizable: false,
      modal: true,
      autoScroll: false,
      height: 420,
      width: 450,
       frame: true,
      id: 'myWin',
      items: [BlockingOuterPanelWindow]
  });
  
    myWinNew = new Ext.Window({
      title: 'titelForInnerPanel',
      closable: false,
      resizable: false,
      modal: true,
      autoScroll: false,
      //height: 250,
      //width: 420,
      height: 420,
      width: 450,// 340
      frame: true,
      id: 'myWinNew',
      items: [BlockingOuterPanelWindowNew]
  });
       
	function verifyFunction(){
	var selected = grid.getSelectionModel().getSelected();
        if (Ext.getCmp('custcomboId').getValue() == "") {
            Ext.example.msg("Select Customer Name");
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
	buttonValue = "Unblock Vehicle";
	titelForInnerPanel = 'Unblocking Vehicle Details';
	myWin.setPosition(450,50);
	myWin.show();
	myWin.setTitle(titelForInnerPanel); 
	var selected = grid.getSelectionModel().getSelected();
	vehicleNo = selected.get('VehicleNoIndex');
	blockedReason=selected.get('BlockedReasonIndex')
	blockedremarks=selected.get('BlockedRemarksIndex');
	blockeddate=selected.get('BlockedDateIndex');
	blockedby=selected.get('BlockedByIndex');
	id=selected.get('IdIndex');
	Ext.getCmp('penaltyyesID').disable();
	Ext.getCmp('penaltynoID').enable();
	var penaltyyesID=Ext.getCmp('penaltyyesID').getValue();
	Ext.getCmp('vehicleNoID').setValue(vehicleNo);
	Ext.getCmp('blockedReasonID').setValue(blockedReason);
	Ext.getCmp('blockeddateID').setValue(blockeddate);
	Ext.getCmp('blockedremarksID').setValue(blockedremarks);
	Ext.getCmp('unblockReasonComboId').reset();
	Ext.getCmp('penaltyyesID').reset();
	Ext.getCmp('remarksID').reset();
	
	}
	
	
	  
	function addRecord(){
		//myWin.hide();
		buttonValue = "Add";
		myWinNew.setPosition(450,50);
		myWinNew.show();
		myWinNew.setTitle('Block Vehicles'); 
		Ext.getCmp('vehiclecomboId').reset();
		Ext.getCmp('remarksIdNew').reset();
		Ext.getCmp('blockReasonComboId').reset();
	}
	

		Ext.onReady(function () {
		    Ext.QuickTips.init();
		    Ext.form.Field.prototype.msgTarget = 'side';
		    outerPanel = new Ext.Panel({
		        title: 'Unblock Sand Vehicles',		        
		        standardSubmit: true,
		        frame: false,
		        width: screen.width-22,
		        height:520,
		        renderTo: 'content',
		        cls: 'outerpanel',
		        layout: 'table',
		        layoutConfig: {
		            columns: 1
		        },
		        items: [clientCombo,grid]
		    });
		});		
   	</script>
 <jsp:include page="../Common/footer.jsp" />
 <!-- </body>   -->
 <!-- </html> -->
