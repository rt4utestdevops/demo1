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
if(request.getParameter("startdate") != null && !request.getParameter("startdate").equals("") && request.getParameter("enddate") != null && !request.getParameter("enddate").equals("")){
	startdate = request.getParameter("startdate");
	if(startdate.contains("+0530")){
		startdate = startdate.replace("+0530 ", " ");
	}else{
		startdate = startdate.replace(" 0530 ", " ");
	}
	enddate = request.getParameter("enddate");
	if(enddate.contains("+0530")){
		enddate = enddate.replace("+0530 ", " ");
	}else{
		enddate = enddate.replace(" 0530 ", " ");
	}
}

%>


<!DOCTYPE HTML>
<html>
  <head>
    <base href="<%=basePath%>">
    
    <title>MonthlyReturn</title>
    
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">

  </head>
  
  <body>
     <%if (loginInfo.getStyleSheetOverride().equals("Y")){%>
	<jsp:include page="../Common/ImportJSSandMining.jsp"/>
	<%}else{%>
	<jsp:include page="../Common/ImportJS.jsp" />
   	<%}%>
   	<jsp:include page="../Common/ExportJS.jsp" />
   	<script>
   	var jspName = "Monthly_Returns";
	var exportDataType = "int,string,string,string,string,string,string,string,string,string,string,string,int,string";
	var custId = '<%=custId%>';
	var custName = '<%=custName%>';
	var onload = '<%=onload%>';
	var userAuthority = '<%=userAuthority%>' ;
	var dateprev = new Date().add(Date.DAY, -14); //15 days  ago date
	var datenext = new Date().add(Date.DAY, 30);   //next day date
	var loadMask = new Ext.LoadMask(Ext.getBody(), { msg: "Redirecting To Form" });
	var loadMasks = new Ext.LoadMask(Ext.getBody(), { msg: "Saving" });
	var dtcur = datecur;
	var monthlyFormId;
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
	    resizable: true,
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
	    id: 'customerComboPanelId',
	    layout: 'table',
	    frame: false,
	    width: screen.width - 22,
	    height: 50,
	    layout: 'table',
	    layoutConfig: {
	        columns: 7
	    },
	    items: [{
	            xtype: 'label',
	            text: '',
	            cls: 'labelstyle',
	            height:5,
	            id:'xyz'
	        	},{
	            xtype: 'label',
	            text: '',
	            cls: 'labelstyle',
	            height:5,
	            id:'pqr'
	        	},{
	            xtype: 'label',
	            text: '',
	            cls: 'labelstyle',
	            height:5,
	            id:'abc'
	        	},{
	            xtype: 'label',
	            text: '',
	            cls: 'labelstyle',
	            height:5,
	            id:'xyza'
	        	},{
	            xtype: 'label',
	            text: '',
	            cls: 'labelstyle',
	            height:5,
	            id:'pqrs'
	        	},{
	            xtype: 'label',
	            text: '',
	            cls: 'labelstyle',
	            height:5,
	            id:'abcd'
	        	},{
	            xtype: 'label',
	            text: '',
	            cls: 'labelstyle',
	            height:5,
	            id:'tuvw'
	        	},{
	            xtype: 'label',
	            text: 'Select Customer :',
	            cls: 'labelstyle',
	            id:'efg'
	        	},client,{
	            xtype: 'label',
	            text: 'Start Date :',
	            style:'margin-left: 100px;font-size: 13px;font-family: sans-serif;',
	            id:'startDatelab'
	        	},{
				xtype: 'datefield',
				format:getMonthYearFormat(),  		  
				plugins: 'monthPickerPlugin',
  		        id: 'startDateId',  		        
  		        value: dateprev,
	    		vtype: 'daterange',
	    		cls: 'selectstylePerfect'
				},{
	            xtype: 'label',
	            text: 'End Date :',
	            style:'margin-left: 100px;font-size: 13px;font-family: sans-serif;',
	            id:'endDatelab'
	        	},{
				xtype: 'datefield',
				format:getMonthYearFormat(),  	
				plugins: 'monthPickerPlugin',	   	        
  		        id: 'endDateId',  		        
  		        value: datenext,
	    		cls: 'selectstylePerfect'
				},{
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
             			Ext.example.msg("End Date Must Be Greater than Start Date");
              			Ext.getCmp('startDateId').focus();
              			return;
            		}
            		if (checkMonthValidation(Ext.getCmp('startDateId').getValue(), Ext.getCmp('endDateId').getValue())) {
                        Ext.example.msg("Difference between two dates must not be greater than 30 days");
                        Ext.getCmp('endDateId').focus();
                        return;
                    }
	            	store.load({params:{custId:custId,custName:Ext.getCmp('custcomboId').getRawValue(),startdate:Ext.getCmp('startDateId').getValue(),enddate:Ext.getCmp('endDateId').getValue(),userAuthority:userAuthority,jspName:jspName}});
	            	}
	            }]
	});
//****************************************************************************Reader Filter & Column**************************************************************************		
	var reader = new Ext.data.JsonReader({
      idProperty: 'monthlyReturnRootId',
      root: 'monthlyReturnRoot',
      totalProperty: 'total',
      fields: [{
          		name: 'SNOIndex'
      		 },{
          		name: 'IDIndex'
      		 },{
          		name: 'returnFormIdIndex'
      		 },{
          		name: 'monthAppliedIndex'
      		 },{
          		name: 'RegIndex'
      		 },{
          		name: 'mineralsIndex'
      		 },{
          		name: 'minesIndex'
      		 },{
          		name: 'tcNoIndex'
      		 },{
          		name: 'ownerIndex'
      		 },{
      		 	name: 'desgnationIndex'
      		 },{
      		 	name: 'statusIndex'
      		 },{
      		 	name: 'remarksIndex'
      		 },{
      		 	name: 'approvedRejectedByIndex'
      		 },{
      		 	name: 'approvedRejectedDTIndex'
      		 }]
    });
    var filters = new Ext.ux.grid.GridFilters({
        local: true,
        filters: [{
			        type: 'int',
			        dataIndex: 'SNOIndex'
			    },{
		            type: 'int',
		            dataIndex: 'IDIndex',		            
        		 },{
		            type: 'string',
		            dataIndex: 'returnFormIdIndex',		            
        		 },{
		            type: 'string',
		            dataIndex: 'monthAppliedIndex',		            
        		 },{
		            type: 'string',
		            dataIndex: 'RegIndex',		            
        		 },{
		            type: 'string',
		            dataIndex: 'mineralsIndex',		            
        		 },{
		            type: 'string',
		            dataIndex: 'minesIndex',		            
        		 },{
	          		type: 'string',
	          		dataIndex: 'tcNoIndex'
	      		 },{
	          		type: 'string',
	          		dataIndex: 'ownerIndex'
	      		 },{
	          		type: 'string',
	          		dataIndex: 'desgnationIndex'
	      		 },{
	          		type: 'string',
	          		dataIndex: 'statusIndex'
	      		 },{
	          		type: 'string',
	          		dataIndex: 'remarksIndex'
	      		 },{
	          		type: 'int',
	          		dataIndex: 'approvedRejectedByIndex'
	      		 },{
	          		type: 'string',
	          		dataIndex: 'approvedRejectedDTIndex'
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
		        header: "<span style=font-weight:bold;>Monthly Form Details Id</span>",
		        sortable: true,
		        hidden: true,
		        dataIndex: 'IDIndex'
		    },{
		        header: "<span style=font-weight:bold;>Return Form Id</span>",
		        sortable: true,
		        hidden: false,
		        dataIndex: 'returnFormIdIndex'
		    },{
		        header: "<span style=font-weight:bold;>Month Applied</span>",
		        sortable: true,
		        hidden: false,
		        dataIndex: 'monthAppliedIndex'
		    },{
		        header: "<span style=font-weight:bold;>IBM Reg. No</span>",
		        sortable: true,
		        dataIndex: 'RegIndex'
		    },{
		        header: "<span style=font-weight:bold;>Minerals Name</span>",
		        sortable: true,
		        dataIndex: 'mineralsIndex'
		    },{
		        header: "<span style=font-weight:bold;>Mining Name</span>",
		        sortable: false,
		        dataIndex: 'minesIndex'
		    },{
		        header: "<span style=font-weight:bold;>TC Number</span>",
		        sortable: false,
		        hidden: false,
		        dataIndex: 'tcNoIndex'
		    },{
		        header: "<span style=font-weight:bold;>Owner</span>",
		        sortable: false,
		        dataIndex: 'ownerIndex'
		    },{
		        header: "<span style=font-weight:bold;>Designation</span>",
		        sortable: false,
		        hidden:true,
		        dataIndex: 'desgnationIndex'
		    },{
		        header: "<span style=font-weight:bold;>Status</span>",
		        sortable: false,
		        hidden:false,
		        dataIndex: 'statusIndex'
		    },{
		        header: "<span style=font-weight:bold;>Remarks</span>",
		        sortable: false,
		        hidden:false,
		        dataIndex: 'remarksIndex'
		    },{
		        header: "<span style=font-weight:bold;>Approved Or Rejected By</span>",
		        sortable: false,
		        hidden: true,
		        dataIndex: 'approvedRejectedByIndex'
		    },{
		        header: "<span style=font-weight:bold;>Approved Or Rejected Date Time</span>",
		        sortable: false,
		        hidden: true,
		        dataIndex: 'approvedRejectedDTIndex'
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
            url: '<%=request.getContextPath()%>/MonthlyReturnsAction.do?param=getMonthlyReturns',
           method: 'POST'
       }),
       reader: reader
    });
//****************************************************************************Grid Store**************************************************************************
    grid = getGrid('','noRecordFound',store,screen.width - 40,380,20,filters,'clearFilterData',false,'',9,false,'',false,'',true,'Excel',jspName,exportDataType,false,'',false,'Add',<%=modify%>,'Modify',false,'',false,'',true,'Generate PDF',false,'',false,'',false,'',false,'',<%=finalSubmit%>,'Final Submit');
/****************************************************************************Ext onReady Outer panel window**************************************************************************/
	function modifyData(){
		var selectedRecord = grid.getSelectionModel().getSelected();
		var designation = store.getAt(grid.getStore().indexOf(selectedRecord)).data['desgnationIndex'];
		var autoGeneratedKeys = store.getAt(grid.getStore().indexOf(selectedRecord)).data['IDIndex'];
		var status = store.getAt(grid.getStore().indexOf(selectedRecord)).data['statusIndex'];
		if (grid.getSelectionModel().getCount() == 0) {
	        Ext.example.msg("No Row Selected");
	        return;
	     }
	    if (grid.getSelectionModel().getCount() > 1) {
	        Ext.example.msg("Select Single Row");
	        return;
	    }
	    if(status == "PENDING" || status == "APPROVED" || status == "REJECTED"){
            Ext.example.msg("Submitted form cannot be modified");
            return;
        }else{
		    loadMask.show();
		    var customerId;
       		var customerName;
       		if('<%=onload%>' != '1'){
       			customerId = Ext.getCmp('custcomboId').getValue();	
       			customerName = Ext.getCmp('custcomboId').getRawValue();
       		}else{
       			customerId = '<%=custId%>';
       			customerName = '<%=custName%>';
       		}
			var startdate = Ext.getCmp('startDateId').getValue();
			var enddate  = Ext.getCmp('endDateId').getValue();
			var reloadPrevRec = 'reloadPrevRec';
			var MonthlyReturnsFormOnePartOne='/Telematics4uApp/Jsps/IronMining/MonthlyReturnsFormOnePartOne.jsp?custId='+customerId+'&custName='+customerName+'&startdate='+startdate+'&enddate='+enddate+'&reloadPrevRec='+reloadPrevRec+'&autoGeneratedKeys='+autoGeneratedKeys;
			parent.Ext.getCmp('partOneTab').enable();
			parent.Ext.getCmp('generalLabourTab').disable();
			parent.Ext.getCmp('partOneTab').show();
			parent.Ext.getCmp('partOneTab').update("<iframe style='width:100%;height:525px;border:0;' src='"+MonthlyReturnsFormOnePartOne+"'></iframe>");
			loadMask.hide();
		}
	}
	function verifyFunction(){
		var selectedRecord = grid.getSelectionModel().getSelected();
		var designation = store.getAt(grid.getStore().indexOf(selectedRecord)).data['desgnationIndex'];
		var autoGeneratedId=store.getAt(grid.getStore().indexOf(selectedRecord)).data['IDIndex'];
		if (grid.getSelectionModel().getCount() == 0) {
	        Ext.example.msg("No Row Selected");
	        return;
	     }
	    if (grid.getSelectionModel().getCount() > 1) {
	        Ext.example.msg("Select Single Row");
	        return;
	    }
		if(designation != null && designation != ""){
			window.open("<%=request.getContextPath()%>/PDFForMining?autoGeneratedKeys="+autoGeneratedId);
		}else{
			Ext.example.msg("PDF Cannot be generated");
	        return;
		}
	}
 	function saveDate(){
		var selectedRecord = grid.getSelectionModel().getSelected();
		var designation = store.getAt(grid.getStore().indexOf(selectedRecord)).data['desgnationIndex'];
		monthlyFormId = store.getAt(grid.getStore().indexOf(selectedRecord)).data['IDIndex'];
		var status = store.getAt(grid.getStore().indexOf(selectedRecord)).data['statusIndex'];
		if (grid.getSelectionModel().getCount() == 0) {
	        Ext.example.msg("No Row Selected");
	        return;
	     }
	    if (grid.getSelectionModel().getCount() > 1) {
	        Ext.example.msg("Select Single Row");
	        return;
	    }
	    if(status == "PENDING" || status == "APPROVED" || status == "REJECTED"){
            Ext.example.msg("Form is already submitted");
            return;
        }
        if(designation == null || designation == ""){
			Ext.example.msg("Please complete the form before final submit");
            return;
		}
		Ext.MessageBox.confirm('Confirm', 'Submitted form cannot be modified. Are you sure you want to submit?',finalSubmission);
		
 	}
 	function finalSubmission(btn){
 		if(btn == 'yes'){
	 		loadMasks.show();
	 		Ext.Ajax.request({
	                url: '<%=request.getContextPath()%>/MonthlyReturnsAction.do?param=finalSubmission',
	                method: 'POST',
	                params: {
	             		monthlyFormId:monthlyFormId				                           	                       
	                },
	                success: function (response, options) {
	                   var message = response.responseText;
	                   loadMasks.hide();
	                   Ext.example.msg(message);
	                   store.reload();
	               },
	               failure: function () {
	               	   loadMasks.hide();
	                   Ext.example.msg("Error");		                                
	                 }
	           });
	           
        } 
 	}
	var buttonPanel=new Ext.FormPanel({
       	id: 'buttonid',
       	cls:'colorid',
       	frame:true,
           buttons:[{
              		text: 'Add',
              		cls:'colorid',
              		iconCls:'addbutton',
              		id:'addbuttonId',
              		handler : function(){
              		if (Ext.getCmp('custcomboId').getValue() == "") {
                        Ext.example.msg("Enter Customer Name");
                        Ext.getCmp('custcomboId').focus();
                        return;
                    }
              		loadMask.show();
              		var customerId;
              		var customerName;
              		if('<%=onload%>' != '1'){
              			customerId = Ext.getCmp('custcomboId').getValue();	
              			customerName = Ext.getCmp('custcomboId').getRawValue();
              		}else{
              			customerId = '<%=custId%>';
              			customerName = '<%=custName%>';
              		}
              		var startdate = Ext.getCmp('startDateId').getValue();
              		var enddate  = Ext.getCmp('endDateId').getValue();
					var MonthlyReturnsFormOnePartOne='/Telematics4uApp/Jsps/IronMining/MonthlyReturnsFormOnePartOne.jsp?custId='+customerId+'&custName='+customerName+'&startdate='+startdate+'&enddate='+enddate;
              		parent.Ext.getCmp('partOneTab').enable();
              		parent.Ext.getCmp('generalLabourTab').disable();
              		parent.Ext.getCmp('partOneTab').show();
					parent.Ext.getCmp('partOneTab').update("<iframe style='width:100%;height:525px;border:0;' src='"+MonthlyReturnsFormOnePartOne+"'></iframe>");
              		loadMask.hide();
              		}
              }]
	    });
	    function getMonthYearFormat(){
			return 'F Y';
		}
		Ext.onReady(function () {
		    Ext.QuickTips.init();
		    Ext.form.Field.prototype.msgTarget = 'side';
		    outerPanel = new Ext.Panel({
		        title: 'Authorise Monthly Returns',		        
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
		        items: [clientCombo,grid,buttonPanel]
		    });
		    if(userAuthority == 'Admin'){
		    	buttonPanel.hide();
		    }
		    if('<%=onload%>' == '1'){
		    	 Ext.getCmp('custcomboId').setValue(custName);
		    	 
		    	 var startdate = '<%=startdate%>';
				 var dt = new Date(startdate);
				 var mnth = ("0" + (dt.getMonth()+1)).slice(-2);
				 var day  = ("0" + dt.getDate()).slice(-2);
				 var startdates = [day,mnth,dt.getFullYear() ].join("-");
				 var stdate = [dt.getFullYear(),mnth,day].join("-");
				// Ext.getCmp('startDateId').setValue(startdates);
				 
				 var enddate = '<%=enddate%>';
				 var dts = new Date(enddate);
				 var mnths = ("0" + (dts.getMonth()+1)).slice(-2);
				 var days  = ("0" + dts.getDate()).slice(-2);
				 var enddates = [days,mnths,dts.getFullYear() ].join("-");
				 var eddate = [dt.getFullYear(),mnths,days].join("-");
				 //Ext.getCmp('endDateId').setValue(enddates);
				 
		    	 store.load({params:{custId:'<%=custId%>',custName:'<%=custName%>',startdate:stdate,enddate:eddate,userAuthority:userAuthority,jspName:jspName}});
		    }
		});		
   	</script>
  </body>
</html>
