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
    
    <title>BlockAndUnblockVehiclesReport</title>
    
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
		.x-window-tl *.x-window-header {
			padding-top : 6px !important;
		}
	</style>
   	<script>
   	var jspName = "Block And Unblock Vehicles Report";
	var exportDataType = "int,string,string,string,string,string,string,string,string,string,string,string";
	var custId = '<%=custId%>';
	var custName = '<%=custName%>';
	var onload = '<%=onload%>';
	var userAuthority = '<%=userAuthority%>' ;
	var dateprev = new Date().add(Date.DAY, -14); //15 days  ago date
	var datenext = new Date().add(Date.DAY, 1);   //next day date
	var loadMask = new Ext.LoadMask(Ext.getBody(), { msg: "Redirecting To Form" });
	var loadMasks = new Ext.LoadMask(Ext.getBody(), { msg: "Saving" });
	var dtcur = datecur;
	var monthlyFormId;
	var blockedby;
	var type="";
	var cm;
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
		
	var typeStore = new Ext.data.SimpleStore({
    id: 'typeId',
    autoLoad: true,
    fields: ['Name', 'Value'],
    data: [
        ['All', '1'],
        ['Blocked', '2'],
        ['Unblocked','3']
    ]
});

var typeCombo = new Ext.form.ComboBox({
    store: typeStore,
    id: 'typeComboId',
    mode: 'local',
    forceSelection: true,
    selectOnFocus: true,
    allowBlank: false,
    anyMatch: true,
    typeAhead: false,
    triggerAction: 'all',
    lazyRender: true,
    valueField: 'Value',
    emptyText: 'Select Type',
    displayField: 'Name',
    cls: 'selectstylePerfect',
    listeners: {
    select: {
        fn: function() {
		type = Ext.getCmp('typeComboId').getRawValue();
        store = grid.getStore();
        cm = grid.getColumnModel();
        if(type=='Blocked') {
            cm.setHidden(7,true);
            cm.setHidden(8,true);
            cm.setHidden(9,true);
            cm.setHidden(10,true);
            cm.setHidden(11,true);
            cm.setHidden(12,true);
            cm.setHidden(3,false);
            cm.setHidden(4,false);
            cm.setHidden(5,false);
            cm.setHidden(6,false);
           	store.load();
        }else if(type=='Unblocked'){
            cm.setHidden(3,true);
            cm.setHidden(4,true);
            cm.setHidden(5,true);
            cm.setHidden(6,true);
            cm.setHidden(7,false);
            cm.setHidden(8,false);
            cm.setHidden(9,false);
            cm.setHidden(10,false);
            cm.setHidden(11,false);
            cm.setHidden(12,false);
           store.load();
        }else{
        	cm.setHidden(3,false);
            cm.setHidden(4,false);
            cm.setHidden(5,false);
            cm.setHidden(6,false);
            cm.setHidden(7,false);
            cm.setHidden(8,false);
            cm.setHidden(9,false);
            cm.setHidden(10,false);
            cm.setHidden(11,false);
            cm.setHidden(12,false);
           store.load();
			   }
		}
    }
}
});
	  var clientPanel = new Ext.Panel({
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
	            {
	                xtype: 'label',
	                text: 'Type' + ' :',
	                cls: 'labelstyle',
	                id: 'assetTypelab'
	            }, 
				typeCombo,
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
	            text: 'View',
	            id: 'submitId2',
	            cls: 'buttonStyle',
	            width: 60,
	            handler: function() {
	            	if (Ext.getCmp('custcomboId').getValue() == "") {
                        Ext.example.msg("Enter Customer Name");
                        Ext.getCmp('custcomboId').focus();
                        return;
                    }
                    if (Ext.getCmp('typeComboId').getRawValue() == "") {
                        Ext.example.msg("Select Type");
                        Ext.getCmp('typeComboId').focus();
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
                    type= Ext.getCmp('typeComboId').getRawValue();
	            	store.load({params:{custId:custId,startdate:Ext.getCmp('startDateId').getValue(),enddate:Ext.getCmp('endDateId').getValue(),jspname:jspName,type:type}});
	            	}
	        }
	        ]
	    });

//****************************************************************************Reader Filter & Column**************************************************************************		
	var reader = new Ext.data.JsonReader({
      idProperty: 'blockUnblockReportRootId',
      root: 'blockUnblockReportRoot',
      totalProperty: 'total',
      fields: [{
          		name: 'SNOIndex'
      		 },{
          		name: 'VehicleNoIndex'
      		 },{
          		name: 'BlockedReasonIndex'
      		 },{
          		name: 'BlockedRemarksIndex'
      		 },{
          		name: 'BlockedDateIndex'
      		 },{
          		name: 'BlockedByIndex'
      		 },{
          		name: 'UnblockedReasonIndex'
      		 },{
          		name: 'UnblockedRemarksIndex'
      		 },{
          		name: 'UnblockedDateIndex'
      		 },{
          		name: 'UnblockedByIndex'
      		 },{
          		name: 'PenaltyIndex'
      		 },{
          		name: 'PenaltyAmountIndex'
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
		            type: 'string',
		            dataIndex: 'UnblockedReasonIndex',		            
        		 },{
		            type: 'string',
		            dataIndex: 'UnblockedRemarksIndex',		            
        		 },{
		            type: 'string',
		            dataIndex: 'UnblockedDateIndex',		            
        		 },{
		            type: 'string',
		            dataIndex: 'UnblockedByIndex',		            
        		 },{
		            type: 'string',
		            dataIndex: 'PenaltyIndex',		            
        		 },{
		            type: 'string',
		            dataIndex: 'PenaltyAmountIndex',		            
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
		        hidden: false,
		        dataIndex: 'BlockedByIndex'
		    },{
		        header: "<span style=font-weight:bold;>Unblocked Reason</span>",
		        sortable: true,
		        hidden: false,
		        dataIndex: 'UnblockedReasonIndex'
		    },{
		        header: "<span style=font-weight:bold;>Unblocked Remarks</span>",
		        sortable: true,
		        hidden: false,
		        dataIndex: 'UnblockedRemarksIndex'
		    },{
		        header: "<span style=font-weight:bold;>Unblocked Date</span>",
		        sortable: true,
		        hidden: false,
		        dataIndex: 'UnblockedDateIndex'
		    },{
		        header: "<span style=font-weight:bold;>Unblocked By</span>",
		        sortable: true,
		        hidden: false,
		        dataIndex: 'UnblockedByIndex'
		    },{
		        header: "<span style=font-weight:bold;>Penalty</span>",
		        sortable: true,
		        hidden: false,
		        dataIndex: 'PenaltyIndex'
		    },{
		        header: "<span style=font-weight:bold;>Penalty Amount</span>",
		        sortable: true,
		        hidden: false,
		        dataIndex: 'PenaltyAmountIndex'
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
            url: '<%=request.getContextPath()%>/SandMiningAction.do?param=getBlockedUnblockedReport',
           method: 'POST'
       }),
       reader: reader
    });
//****************************************************************************Grid Store**************************************************************************
    grid = getGrid('','noRecordFound',store,screen.width - 40,380,20,filters,'clearFilterData',false,'',9,false,'',false,'',true,'Excel',jspName,exportDataType,false,'',false,'Add',false,'Modify',false,'',false,'');
/****************************************************************************Ext onReady Outer panel window**************************************************************************/

Ext.onReady(function () {
		    Ext.QuickTips.init();
		    Ext.form.Field.prototype.msgTarget = 'side';
		    outerPanel = new Ext.Panel({
		        title: 'Block And Unblock Vehicles Report',		        
		        standardSubmit: true,
		        frame: false,
		        width: screen.width-22,
		        height:540,
		        renderTo: 'content',
		        cls: 'outerpanel',
		        layout: 'table',
		        layoutConfig: {
		            columns: 1
		        },
		        items: [clientPanel,grid]
		    });
		});		
   	</script>
 <jsp:include page="../Common/footer.jsp" />
 <!-- </body>   -->
 <!-- </html> -->
