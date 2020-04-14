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

ArrayList<String> tobeConverted = new ArrayList<String>();
tobeConverted.add("Service_Vehicle_Association");
tobeConverted.add("SLNO");
tobeConverted.add("Vehicle_No");
tobeConverted.add("Day_Type");
tobeConverted.add("Terminal_Name");
tobeConverted.add("Route_Name");
tobeConverted.add("Origin_Destination");
tobeConverted.add("Distance");
tobeConverted.add("Departure_Arrival");
tobeConverted.add("Vehicle_Model");
tobeConverted.add("Seating_Structure");
tobeConverted.add("Rate");
tobeConverted.add("Status");
tobeConverted.add("Add");
tobeConverted.add("Modify");
tobeConverted.add("Clear_Filter_Data");
tobeConverted.add("Save");
tobeConverted.add("Cancel");
tobeConverted.add("Add_Service_Vehicle_Association");
tobeConverted.add("Modify_Service_Vehicle_Association");
tobeConverted.add("Duration(HH:MM)");
tobeConverted.add("No_Records_Found");
tobeConverted.add("Id");
tobeConverted.add("Service_Name");
tobeConverted.add("Service_Id");
tobeConverted.add("Enter_Service_Name");
tobeConverted.add("Select_Customer_Name");
tobeConverted.add("Enter_Terminal_Name");
tobeConverted.add("Enter_Status");
tobeConverted.add("Enter_Vehicle_No");
tobeConverted.add("Enter_Days_of_Service");
tobeConverted.add("Enter_Route_Name");
tobeConverted.add("Enter_Distance");
tobeConverted.add("Enter_Duration");
tobeConverted.add("Enter_Rate");
tobeConverted.add("Select_Customer");
tobeConverted.add("Enter_Date");
tobeConverted.add("Enter_Seating_Structure");
tobeConverted.add("Enter_Vehicle_Model");
tobeConverted.add("Enter_Departure_Arrival");
tobeConverted.add("Enter_Origin_Destination");
tobeConverted.add("Date");
tobeConverted.add("Driver_Expense");
tobeConverted.add("Worker_Fee");
tobeConverted.add("Miscellaneous_Fee");
tobeConverted.add("Dispatch_Amount");
tobeConverted.add("Insurance");
tobeConverted.add("Tax");
tobeConverted.add("Total");
tobeConverted.add("Add_Vehicle");


ArrayList<String> convertedWords = new ArrayList<String>();
convertedWords = cf.getLanguageSpecificWordForKey(tobeConverted,language);

String serviceVehicleAssociation = convertedWords.get(0);
String slno = convertedWords.get(1);
String vehicleNo = convertedWords.get(2);
String dayType = convertedWords.get(3);
String terminal = convertedWords.get(4);
String routeName = convertedWords.get(5);
String originDestination = convertedWords.get(6);
String distance = convertedWords.get(7);
String departureArrival = convertedWords.get(8);
String vehicleModel = convertedWords.get(9);
String seatingStructure = convertedWords.get(10);
String rate = convertedWords.get(11);
String status = convertedWords.get(12);
String add = convertedWords.get(13);
String modify = convertedWords.get(14);
String clearFilterData = convertedWords.get(15);
String save = convertedWords.get(16);
String cancel = convertedWords.get(17);
String addServiceVehicleAssociation = convertedWords.get(18);
String modifyServiceVehicleAssociation = convertedWords.get(19);
String duration = convertedWords.get(20);
String noRecordFound = convertedWords.get(21);
String Id = convertedWords.get(22);
String serviceName = convertedWords.get(23);
String servicesId = convertedWords.get(24);
String enterservicename= convertedWords.get(25);
String selectcustomername= convertedWords.get(26);
String enterterminalname= convertedWords.get(27);
String enterstatus= convertedWords.get(28);
String entervehicleno= convertedWords.get(29);
String enterdayofservice= convertedWords.get(30);
String enterroutename= convertedWords.get(31);
String enterdistance= convertedWords.get(32);
String enterduration= convertedWords.get(33);
String enterrate= convertedWords.get(34);
String selectcustomer =convertedWords.get(35);
String enterdate = convertedWords.get(36);
String enterseatingstructure = convertedWords.get(37);
String entervehiclemodel = convertedWords.get(38);
String enterdeparturearrival= convertedWords.get(39);
String enterorigindestination= convertedWords.get(40);
String date= convertedWords.get(41);
String driverExpense=convertedWords.get(42);
String workerFee=convertedWords.get(43);
String miscellaneousFee=convertedWords.get(44);
String dispatchAmount=convertedWords.get(45);
String insurance=convertedWords.get(46);
String tax=convertedWords.get(47);
String total=convertedWords.get(48);
String addVehicle=convertedWords.get(49);

%>

<jsp:include page="../Common/header.jsp" />
   	<title>ServiceVehicleAssociation</title>    
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
		label
		{
			display : inline !important;
		}
		input#custcomboId {
			height : 21px !important;
		}
		.x-window-tl *.x-window-header {
			height : 38px !important;
		}
		.ext-strict .x-form-text {
			height : 21px !important;
		}		
		.x-window-tl *.x-window-header {
			padding-top : 6px !important;
		}
		
	</style>

   	<script>
   	var jspName = "Service_Vehicle_Association";
	var exportDataType = "int,int,int,string,string,string,string,string,string,float,string,float,string,string,float,string,float,float,float,float,float,float,float,float";
	var myWin;
	var grid;
 	var buttonValue;
 	var title; 
 	var dtcur = datecur;
    var datemin=new Date();   
    var maxdate = new Date().add(Date.DAY, 9);     
 	var vehicleAssocId=0;
 	var serviceId=0;
 	var statusValue='Active';
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
		                terminalstore.load({params:{custId : Ext.getCmp('custcomboId').getValue()}});
		            	//vehicleRegstore.load({params:{custId : Ext.getCmp('custcomboId').getValue()}});
		            	store.load({params:{jspName:jspName,custId:Ext.getCmp('custcomboId').getValue()}});          
		            }
		           		           
		        }
		    }
		});
   		var client = new Ext.form.ComboBox({
		    store: clientcombostore,
		    id: 'custcomboId',
		    mode: 'local',
		    forceSelection: true,
		    emptyText: '<%=selectcustomername%>',
		    blankText: '<%=selectcustomername%>',
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
		            	terminalstore.load({params:{custId : Ext.getCmp('custcomboId').getValue()}});
		            	//vehicleRegstore.load({params:{custId : Ext.getCmp('custcomboId').getValue()}});
		            	store.load({params:{jspName:jspName,custId:Ext.getCmp('custcomboId').getValue()}});		                 
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
		        columns: 3
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
		            text: '<%=selectcustomer%> :',
		            cls: 'labelstyle',
		            id:'efg'
		        	},{
		            xtype: 'label',
		            text: '',
		            cls: 'labelstyle',
		            id:'mno'
		        	},client]
		});
		var reader = new Ext.data.JsonReader({
	      idProperty: 'serviceVehicleAssociationId',
	      root: 'serviceVehicleAssociation',
	      totalProperty: 'total',
	      fields: [{
	          		type: 'int',
	          		name: 'SNOIndex'
	      		 },{
	          		type: 'int',
	          		name: 'IdIndex'
	      		 },{
	          		type: 'int',
	          		name: 'serviceIdIndex'
	      		 },{
	          		type: 'string',
	          		name: 'serviceNameIndex'
	      		 },{
	          		type: 'string',
	          		name: 'vehicleNumberIndex'
	      		 },{
	          		type: 'date',
	          		name: 'DateIndex'
	      		 },{
	          		type: 'string',
	          		name: 'dayTypeIndex'
	      		 },{
	          		type: 'string',
	          		name: 'terminalIndex'
	      		 },{
	          		type: 'string',
	          		name: 'routeNameIndex'
	      		 },{
	          		type: 'string',
	          		name: 'originDestinationIndex'
	      		 },{
	          		type: 'float',
	          		name: 'distanceIndex'
	      		 },{
	          		type: 'string',
	          		name: 'departureArrivalIndex'
	      		 },{
	          		type: 'float',
	          		name: 'durationIndex'
	      		 },{
	          		type: 'string',
	          		name: 'vehicleModelIndex'
	      		 },{
	          		type: 'string',
	          		name: 'seatingStructIndex'
	      		 },{
	          		type: 'float',
	          		name: 'rateIndex'
	      		 },{
	          		type: 'string',
	          		name: 'statusIndex'
	      		 },{
	          		type: 'float',
	          		name: 'driverExpenseIndex'
	      		 },{
	          		type: 'float',
	          		name: 'workerFeeIndex'
	      		 },{
	          		type: 'float',
	          		name: 'misExpenseIndex'
	      		 },{
	          		type: 'float',
	          		name: 'dispatchIndex'
	      		 },{
	          		type: 'float',
	          		name: 'insuranceIndex'
	      		 },{
	          		type: 'float',
	          		name: 'taxIndex'
	      		 },{
	          		type: 'float',
	          		name: 'totalIndex'
	      		 }]
	    });
	    var filters = new Ext.ux.grid.GridFilters({
	        local: true,
	        filters: [{
				        type: 'int',
				        dataIndex: 'SNOIndex'
				    },{
			            type: 'int',
			            dataIndex: 'serviceIdIndex',		            
	        		 },{
			            type: 'string',
			            dataIndex: 'serviceNameIndex',		            
	        		 },{
			            type: 'string',
			            dataIndex: 'vehicleNumberIndex',		            
	        		 },{
		          		type: 'date',
		          		dataIndex: 'DateIndex'
		      		 },{
		          		type: 'string',
		          		dataIndex: 'dayTypeIndex'
		      		 },{
		          		type: 'string',
		          		dataIndex: 'terminalIndex'
	      		 	},{
		          		type: 'string',
		          		dataIndex: 'routeNameIndex'
	      		 	},{
		          		type: 'string',
		          		dataIndex: 'originDestinationIndex'
	      		 	},{
		          		type: 'float',
		          		dataIndex: 'distanceIndex'
	      		 	},{
		          		type: 'string',
		          		dataIndex: 'departureArrivalIndex'
	      		 	},{
		          		type: 'float',
		          		dataIndex: 'durationIndex'
	      		 	},{
		          		type: 'string',
		          		dataIndex: 'vehicleModelIndex'
	      		 	},{
		          		type: 'string',
		          		dataIndex: 'seatingStructIndex'
	      		 	},{
		          		type: 'float',
		          		dataIndex: 'rateIndex'
	      		 	},{
		          		type: 'string',
		          		dataIndex: 'statusIndex'
	      		 	},{
		          		type: 'float',
		          		dataIndex: 'driverExpenseIndex'
	      		 	},{
		          		type: 'float',
		          		dataIndex: 'workerFeeIndex'
	      		 	},{
		          		type: 'float',
		          		dataIndex: 'misExpenseIndex'
	      		 	},{
		          		type: 'float',
		          		dataIndex: 'dispatchIndex'
	      		 	},{
		          		type: 'float',
		          		dataIndex: 'insuranceIndex'
	      		 	},{
		          		type: 'float',
		          		dataIndex: 'taxIndex'
	      		 	},{
		          		type: 'float',
		          		dataIndex: 'totalIndex'
	      		 	}]
	    });
    var createColModel = function(finish, start) {
	    var columns = [
	     	new Ext.grid.RowNumberer({
	            header : "<span style=font-weight:bold;><%=slno%></span>",
	            width : 70,
	            filter:{
            		type: 'numeric'
				}
	        }),{
	            dataIndex: 'SNOIndex',
	            width: 30,
	            hidden: true,
	            header: "<span style=font-weight:bold;><%=slno%></span>",
	            filter: {
	                type: 'int'
	            }
	        },{
		        header: "<span style=font-weight:bold;><%=Id%></span>",
		        sortable: true,
		        hidden: true,
		        dataIndex: 'IdIndex',
		        filter:{
            		type: 'int'
				}
		    },{
		        header: "<span style=font-weight:bold;><%=servicesId%></span>",
		        sortable: true,
		        hidden: true,
		        dataIndex: 'serviceIdIndex',
		        filter:{
            		type: 'int'
				}
		    },{
		        header: "<span style=font-weight:bold;><%=serviceName%></span>",
		        sortable: true,
		        dataIndex: 'serviceNameIndex',
		        filter:{
            		type: 'string'
				}
		    },{
		        header: "<span style=font-weight:bold;><%=vehicleNo%></span>",
		        sortable: true,
		        dataIndex: 'vehicleNumberIndex',
		        filter:{
            		type: 'string'
				}
		    },{
		        header: "<span style=font-weight:bold;><%=date%></span>",
		        sortable: true,
		        dataIndex: 'DateIndex',
		         renderer: Ext.util.Format.dateRenderer(getDateFormat()),
		        filter:{
            		type: 'date',
				}
		    },{
		        header: "<span style=font-weight:bold;><%=dayType%></span>", 
		        sortable: true,
		        dataIndex: 'dayTypeIndex',
		        filter:{
            		type: 'string'
				}		       
		    },{
		        header: "<span style=font-weight:bold;><%=terminal%></span>",
		        sortable: true,
		        dataIndex: 'terminalIndex',
		        filter:{
            		type: 'string'
				}	        
		    },{
		        header: "<span style=font-weight:bold;><%=routeName%></span>",
		        sortable: true,
		        dataIndex: 'routeNameIndex',
		        filter:{
            		type: 'string'
				}	        
		    },{
		        header: "<span style=font-weight:bold;><%=originDestination%></span>",
		        sortable: true,
		        dataIndex: 'originDestinationIndex',
		        filter:{
            		type: 'string'
				}	        
		    },{
		        header: "<span style=font-weight:bold;><%=distance%></span>",
		        sortable: true,
		        dataIndex: 'distanceIndex',
		        filter:{
            		type: 'float'
				}	        
		    },{
		        header: "<span style=font-weight:bold;><%=departureArrival%></span>",
		        sortable: true,
		        dataIndex: 'departureArrivalIndex',
		        filter:{
            		type: 'string'
				}	        
		    },{
		        header: "<span style=font-weight:bold;><%=duration%></span>",
		        sortable: true,
		        dataIndex: 'durationIndex',
		        filter:{
            		type: 'float'
				}	        
		    },{
		        header: "<span style=font-weight:bold;><%=vehicleModel%></span>",
		        sortable: true,
		        dataIndex: 'vehicleModelIndex',
		        filter:{
            		type: 'string'
				}	        
		    },{
		        header: "<span style=font-weight:bold;><%=seatingStructure%></span>",
		        sortable: true,
		        dataIndex: 'seatingStructIndex',
		        filter:{
            		type: 'string'
				}	        
		    },{
		        header: "<span style=font-weight:bold;><%=rate%></span>",
		        sortable: true,
		        dataIndex: 'rateIndex',
		        filter:{
            		type: 'float'
				}	        
		    },{
		        header: "<span style=font-weight:bold;><%=status%></span>",
		        sortable: true,
		        dataIndex: 'statusIndex',
		        filter:{
            		type: 'string'
				}	        
		    },{
		        header: "<span style=font-weight:bold;><%=driverExpense%></span>",
		        sortable: true,
		        dataIndex: 'driverExpenseIndex',
		        filter:{
            		type: 'float'
				}	        
		    },{
		        header: "<span style=font-weight:bold;><%=workerFee%></span>",
		        sortable: true,
		        dataIndex: 'workerFeeIndex',
		        filter:{
            		type: 'float'
				}	        
		    },{
		        header: "<span style=font-weight:bold;><%=miscellaneousFee%></span>",
		        sortable: true,
		        dataIndex: 'misExpenseIndex',
		        filter:{
            		type: 'float'
				}	        
		    },{
		        header: "<span style=font-weight:bold;><%=dispatchAmount%></span>",
		        sortable: true,
		        dataIndex: 'dispatchIndex',
		        filter:{
            		type: 'float'
				}	        
		    },{
		        header: "<span style=font-weight:bold;><%=insurance%></span>",
		        sortable: true,
		        dataIndex: 'insuranceIndex',
		        filter:{
            		type: 'float'
				}	        
		    },{
		        header: "<span style=font-weight:bold;><%=tax%></span>",
		        sortable: true,
		        dataIndex: 'taxIndex',
		        filter:{
            		type: 'float'
				}	        
		    },{
		        header: "<span style=font-weight:bold;><%=total%></span>",
		        sortable: true,
		        dataIndex: 'totalIndex',
		        filter:{
            		type: 'float'
				}	        
		    }];
	    return new Ext.grid.ColumnModel({
	        columns: columns.slice(start || 0, finish),  
	        defaults: {
	            sortable: true
	        }
	    });
	};
//****************************************************************************Grid Store**************************************************************************
		var store = new Ext.data.GroupingStore({
	        autoLoad: false,
	        proxy: new Ext.data.HttpProxy({
	            url: '<%=request.getContextPath()%>/ServiceVehicleAssociation.do?param=getServiceVehicleAssociationList',
	            method: 'POST'
	        }),
	        reader: reader
	    });
/****************************************************************************Registration Combo Store**************************************************************************/
	    var vehicleRegstore = new Ext.data.JsonStore({
		    url: '<%=request.getContextPath()%>/ServiceVehicleAssociation.do?param=getVehicleRegList',
		    id: 'vehicleRegNumberId',
		    root: 'vehicleRegNumber',
		    autoLoad: false,
		    remoteSort: true,
		    fields: ['vehicleNo']	
		});
/****************************************************************************Store Based On ServiceId**************************************************************************/
	    var storeBasedOnServiceId = new Ext.data.JsonStore({
		    url: '<%=request.getContextPath()%>/ServiceVehicleAssociation.do?param=getStoreBasedOnServiceId',
		    id: 'storeBasedOnServiceId',
		    root: 'storeBasedOnServiceId',
		    autoLoad: false,
		    remoteSort: true,
		    fields: ['dayType','routeName','originDestination','distance','departureArrival','duration','vehicleModel','seatingStructure','rate','status']	
		});

/****************************************************************************Service Combo Store**************************************************************************/
	var serviceNamestore = new Ext.data.JsonStore({
		    url: '<%=request.getContextPath()%>/ServiceVehicleAssociation.do?param=getServiceNameList',
		    id: 'serviceNameId',
		    root: 'serviceName',
		    autoLoad: false,
		    remoteSort: true,
		    fields: ['serviceId','serviceName']
		});
/****************************************************************************Terminal Name Combo Store**************************************************************************/
	var terminalstore = new Ext.data.JsonStore({
		    url: '<%=request.getContextPath()%>/ServiceVehicleAssociation.do?param=getTerminalNameList',
		    id: 'terminalNameId',
		    root: 'terminalName',
		    autoLoad: false,
		    remoteSort: true,
		    fields: ['TERMINAL_ID','TERMINAL_NAME']	
		});
/****************************************************************************Terminal Combo**************************************************************************/		
 	var terminalCombo = new Ext.form.ComboBox({ 	
   		cls:'selectstylePerfect',
   		emptyText:'<%=enterterminalname%>',	    			    		
   		blankText :'<%=enterterminalname%>',
   		allowBlank: false,
   		mode: 'local',
   		forceSelection: true,
   		triggerAction: 'all',
   		anyMatch: true,
        onTypeAhead: true,
        selectOnFocus: true,
   		store:terminalstore,
   		valueField:'TERMINAL_ID',
   		displayField:'TERMINAL_NAME',
   		id:'terminalName',
   		listeners:{
   			select: {
	            fn: function () {
	            	  Ext.getCmp('serviceNameNo').reset();
	            	  Ext.getCmp('datetype').reset();
					  Ext.getCmp('routeNames').reset();
					  Ext.getCmp('origin').reset();
					  Ext.getCmp('distance').reset();
					  Ext.getCmp('departurearrival').reset();
					  Ext.getCmp('duration').reset();
					  Ext.getCmp('vehiclemodel').reset();
					  Ext.getCmp('seatingstructure').reset();
					  Ext.getCmp('rate').reset();
					  Ext.getCmp('StatusId').reset();            			            	
		              serviceNamestore.load({
		                	params:{
		                		terminalId:Ext.getCmp('terminalName').getValue(),
		                		custId:Ext.getCmp('custcomboId').getValue()
		                	}
		              });
	            }
	        }
   		}	    		
   });
/****************************************************************************Service Combo**************************************************************************/		
	var serviceCombo = new Ext.form.ComboBox({
	       	store:serviceNamestore,
	       	mode: 'local',
	       	forceSelection: true,
	       	selectOnFocus: true,
	       	allowBlank: false,
	       	anyMatch: true,
	       	typeAhead: false,
	       	triggerAction: 'all',
	       	lazyRender: true,
	       	cls:'selectstylePerfect',
		    emptyText:'<%=enterservicename%>',	    			    		
		    blankText :'<%=enterservicename%>',
		  	valueField:'serviceId',
		  	displayField:'serviceName',
		  	id:'serviceNameNo',
		  	listeners:{
		  		select: {
		           fn: function () {
		           		storeBasedOnServiceId.load({
		                	params:{
		                		serviceId:Ext.getCmp('serviceNameNo').getValue(),
		                		custId:Ext.getCmp('custcomboId').getValue()
		                	},
		                	callback:function(){
		                		if(storeBasedOnServiceId.getCount()>0){
		                			  var record=storeBasedOnServiceId.getAt(0);
		                			  Ext.getCmp('datetype').setValue(record.data['dayType']);
 									  Ext.getCmp('routeNames').setValue(record.data['routeName']);
									  Ext.getCmp('origin').setValue(record.data['originDestination']);
									  Ext.getCmp('distance').setValue(record.data['distance']);
									  Ext.getCmp('departurearrival').setValue(record.data['departureArrival']);
									  Ext.getCmp('duration').setValue(record.data['duration']);
									  Ext.getCmp('vehiclemodel').setValue(record.data['vehicleModel']);
									  Ext.getCmp('seatingstructure').setValue(record.data['seatingStructure']);
									  Ext.getCmp('rate').setValue(record.data['rate']);
									
		                		}
		                	}
		                });	            				            	
		            }
		        }
		  	}	 
		 });
	  
	var StatusStore = new Ext.data.SimpleStore({
      id: 'StatusStorId',
      fields: ['Name', 'Value'],
      autoLoad: true,
      data: [
          ['Active', 'Active'],
          ['Inactive', 'Inactive']
      ]
  });

  var Status = new Ext.form.ComboBox({
      frame: true,
      store: StatusStore,
      id: 'StatusId',
      width: 150,
      cls: 'selectstylePerfect',
      hidden: false,
      allowBlank: false,
      anyMatch: true,
      onTypeAhead: true,
      forceSelection: true,
      enableKeyEvents: true,
      mode: 'local',
      emptyText: '<%=enterstatus%>',
      triggerAction: 'all',
      displayField: 'Name',
      value: 'Active',
      valueField: 'Value',
      listeners: {
          select: {
              fn: function() {
                  statusValue = Ext.getCmp('StatusId').getValue();
              }
          }
      }
  });
/****************************************************************************Inner panel for displaying form field**************************************************************************/	    		   		
	var innerPanel = new Ext.form.FormPanel({
		standardSubmit: true,	
		autoScroll:true,
		frame:true,
		height:150,
		width:442,
		id:'serviceVehicleAssoc',
		layout:'table',
		layoutConfig: {columns:3},
		items:[{
            	xtype:'label',
            	text:'*',
            	cls:'mandatoryfield',
            	id:'mandatoryterminalName'
            	},{
				xtype: 'label',
				cls:'labelstyle',
				id:'terminalNamelab',
				text: '<%=terminal%> :'
				},terminalCombo,{
            	xtype:'label',
            	text:'*',
            	cls:'mandatoryfield',
            	id:'mandatoryservicename'
            	},{
				xtype: 'label',
				cls:'labelstyle',
				id:'serviceNamelab',
				text: '<%=serviceName%> :'
				},serviceCombo,{
            	xtype:'label',
            	text:'*',
            	cls:'mandatoryfield',
            	id:'mandatorydate'
            	},{
				xtype: 'label',
				cls:'labelstyle',
				id:'datetlab',
				text: '<%=enterdate%> :'
				},{
				xtype: 'datefield',
				format:getDateFormat(),  		        
  		        id: 'DateId',  		        
  		        value: dtcur,
  		        minValue: datemin,
  		        maxValue:maxdate,
	    		vtype: 'daterange',
	    		cls: 'selectstylePerfect'
				},{
            	xtype:'label',
            	text:' ',
            	cls:'mandatoryfield',
            	id:'mandatorydateId'
            	},
				{
				xtype: 'label',
				cls:'labelstyle',
				id:'datetlab1',
				text: 'Next 10 Days Association : '
				},{
				xtype: 'checkbox',
			id:'checkId',
			boxLabel:'',
			height:30,
			width:30,
			checked: true
				},{
            	xtype:'label',
            	text:'*',
            	cls:'mandatoryfield',
            	id:'mandatorydaytype'
            	},{
				xtype: 'label',
				cls:'labelstyle',
				id:'datetypelab',
				text: '<%=dayType%> :'
				},{
				xtype:'textfield',
	    		cls:'selectstylePerfect',
	    		emptyText:'<%=enterdayofservice%>',	    			    		
	    		blankText :'<%=enterdayofservice%>',
	    		allowBlank: false,
	    		readOnly:true,	    		
	    		id:'datetype'	    		
	    		},{
            	xtype:'label',
            	text:'*',
            	cls:'mandatoryfield',
            	id:'mandatoryrouteName'
            	},{
				xtype: 'label',
				cls:'labelstyle',
				id:'routeNamelab',
				text: '<%=routeName%> :'
				},{
				xtype:'textfield',
	    		cls:'selectstylePerfect',
	    		emptyText:'<%=enterroutename%>',	    			    		
	    		blankText :'<%=enterroutename%>',
	    		allowBlank: false,
	    		readOnly:true,
	    		id:'routeNames'	    		
	    		},{
            	xtype:'label',
            	text:'*',
            	cls:'mandatoryfield',
            	id:'mandatoryorigin'
            	},{
				xtype: 'label',
				cls:'labelstyle',
				id:'originlab',
				text: '<%=originDestination%> :'
				},{
				xtype:'textfield',
	    		cls:'selectstylePerfect',
	    		emptyText:'<%=enterorigindestination%>',	    			    		
	    		blankText :'<%=enterorigindestination%>',
	    		allowBlank: false,
	    		readOnly:true,
	    		id:'origin'	    		
	    		},{
            	xtype:'label',
            	text:'*',
            	cls:'mandatoryfield',
            	id:'mandatorydistance'
            	},{
				xtype: 'label',
				cls:'labelstyle',
				id:'distancelab',
				text: '<%=distance%> :'
				},{
				xtype:'textfield',
	    		cls:'selectstylePerfect',
	    		emptyText:'<%=enterdistance%>',	    			    		
	    		blankText :'<%=enterdistance%>',
	    		allowBlank: false,
	    		readOnly:true,
	    		id:'distance'	    		
	    		},{
            	xtype:'label',
            	text:'*',
            	cls:'mandatoryfield',
            	id:'mandatorydeparture'
            	},{
				xtype: 'label',
				cls:'labelstyle',
				id:'departurelab',
				text: '<%=departureArrival%> :'
				},{
				xtype:'textfield',
	    		cls:'selectstylePerfect',
	    		emptyText:'<%=enterdeparturearrival%>',	    			    		
	    		blankText :'<%=enterdeparturearrival%>',
	    		allowBlank: false,
	    		readOnly:true,
	    		id:'departurearrival'	    		
	    		},{
            	xtype:'label',
            	text:'*',
            	cls:'mandatoryfield',
            	id:'mandatoryduration'
            	},{
				xtype: 'label',
				cls:'labelstyle',
				id:'durationlab',
				text: '<%=duration%>:'
				},{
				xtype:'textfield',
	    		cls:'selectstylePerfect',
	    		emptyText:'<%=enterduration%>',	    			    		
	    		blankText :'<%=enterduration%>',
	    		allowBlank: false,
	    		readOnly:true,
	    		id:'duration'	    		
	    		},{
            	xtype:'label',
            	text:'*',
            	cls:'mandatoryfield',
            	id:'mandatoryvehiclemodel'
            	},{
				xtype: 'label',
				cls:'labelstyle',
				id:'vehiclemodellab',
				text: '<%=vehicleModel%> :'
				},{
				xtype:'textfield',
	    		cls:'selectstylePerfect',
	    		emptyText:'<%=entervehiclemodel%>',	    			    		
	    		blankText :'<%=entervehiclemodel%>',
	    		allowBlank: false,
	    		readOnly:true,
	    		id:'vehiclemodel'	    		
	    		},{
            	xtype:'label',
            	text:'*',
            	cls:'mandatoryfield',
            	id:'mandatoryseatingstructure'
            	},{
				xtype: 'label',
				cls:'labelstyle',
				id:'seatingstructurelab',
				text: '<%=seatingStructure%> :'
				},{
				xtype:'textfield',
	    		cls:'selectstylePerfect',
	    		emptyText:'<%=enterseatingstructure%>',	    			    		
	    		blankText :'<%=enterseatingstructure%>',
	    		allowBlank: false,
	    		readOnly:true,
	    		id:'seatingstructure'	    		
	    		},{
            	xtype:'label',
            	text:'*',
            	cls:'mandatoryfield',
            	id:'mandatoryrate'
            	},{
				xtype: 'label',
				cls:'labelstyle',
				id:'ratelab',
				text: '<%=rate%> :'
				},{
				xtype:'textfield',
	    		cls:'selectstylePerfect',
	    		emptyText:'<%=enterrate%>',	    			    		
	    		blankText :'<%=enterrate%>',
	    		allowBlank: false,
	    		readOnly:true,
	    		id:'rate'	    		
	    		},{
            	xtype:'label',
            	text:'*',
            	cls:'mandatoryfield',
            	id:'mandatorystatus'
            	},{
				xtype: 'label',
				cls:'labelstyle',
				id:'statuslab',
				text: '<%=status%> :'
				}, Status]
	    });
//****************************************************************************Button for Inner panel form field**************************************************************************    
	var winButtonPanel=new Ext.Panel({
        	id: 'winbuttonid',
        	standardSubmit: true,			
			cls:'windowbuttonpanel',
			frame:true,
			height:20,
			width:440,
			layout:'table',
			layoutConfig: {
				columns:2
			},
			buttons:[{
       			xtype:'button',
      			text:'<%=save%>',
        		id:'addButtId',
        		iconCls:'savebutton',
        		cls:'buttonstyle',
        		width:80,
       			listeners: 
       			{
        			click:
        			{
       					fn:function(){
       						
		                    if (Ext.getCmp('terminalName').getValue() == "") {
		                        Ext.example.msg("Enter Terminal Name");
		                        Ext.getCmp('terminalName').focus();
		                        return;
		                    }
		                    if (Ext.getCmp('serviceNameNo').getValue() == "") {
		                        Ext.example.msg("Enter Service Number");
		                        Ext.getCmp('serviceNameNo').focus();
		                        return;
		                    }
		                    if (Ext.getCmp('DateId').getValue() == "") {
		                        Ext.example.msg("Enter Date");
		                        Ext.getCmp('DateId').focus();
		                        return;
		                    }
		                    if (Ext.getCmp('StatusId').getValue() == "") {
		                        Ext.example.msg("Enter Status");
		                        Ext.getCmp('StatusId').focus();
		                        return;
		                    }
		                  
		                    if(Ext.getCmp('DateId').getValue()>maxdate){
		                        Ext.example.msg("Association is restricted to 10 days only!");
		                        Ext.getCmp('DateId').focus();
		                        return;
		                    }
		                    
		                    if (innerPanel.getForm().isValid()) {
		                    	if(buttonValue == 'modify'){
			                    	 var selected = grid.getSelectionModel().getSelected();
			                    	 vehicleAssocId = selected.get('IdIndex');
			                    	 if(selected.get('serviceNameIndex') != Ext.getCmp('serviceNameNo').getValue()){
			                    	 	serviceId = Ext.getCmp('serviceNameNo').getValue();
			                    	 }else{
			                    	 	serviceId = selected.get('serviceIdIndex');
			                    	 }
		                    	 }else{
		                    	 	serviceId = Ext.getCmp('serviceNameNo').getValue();
		                    	 }
		                     
		                       Ext.Ajax.request({
		                            url: '<%=request.getContextPath()%>/ServiceVehicleAssociation.do?param=addOrModifyServiceVehicleAssocList',
		                            method: 'POST',
		                            params: {
		                            	buttonValue:buttonValue,
		                            	//vehicleNo : Ext.getCmp('regNo').getValue(),	                            	
		                            	serviceId : serviceId,
		                            	date: Ext.getCmp('DateId').getValue(),
										custId:Ext.getCmp('custcomboId').getValue(),
										status: Ext.getCmp('StatusId').getValue(),
										Id:vehicleAssocId,
										check:Ext.getCmp('checkId').getValue()											                           	                       
		                            },
		                            success: function (response, options) {
		                                var message = response.responseText;
		                                Ext.example.msg(message);
		                                myWin.hide();
		                                store.reload();
		                               },
		                            failure: function () {
		                                Ext.example.msg("Error");		                                
		                                myWin.hide();
		                                store.reload();
		                            }
	                        	});
                          	}
       					}
       				}
       			}
      		},{
       			xtype:'button',
      			text:'<%=cancel%>',
        		id:'cancelButtId',
        		iconCls:'cancelbutton',
        		cls:'buttonstyle',
        		width:80,
       			listeners: 
       			{
        			click:
        			{
       					fn:function()
       					{
       						myWin.hide();
       					}
       				}
       			}
      		}]
	});
	/****************************************************************************Inner panel for add vehicle**************************************************************************/	    		   		
	var addVehicleinnerPanel = new Ext.form.FormPanel({
		standardSubmit: true,	
		autoScroll:true,
		frame:true,
		height:260,
		width:442,
		id:'serviceVehicleadd',
		layout:'table',
		layoutConfig: {columns:3},
		items:[{
      	    	xtype:'label',
            	text:'*',
            	cls:'mandatoryfield',
            	id:'mandatoryservicename1'
            	},{
				xtype: 'label',
				cls:'labelstyle',
				id:'serviceNamelabId',
				text: '<%=serviceName%> :'
				},{
				xtype:'textfield',
	    		cls:'selectstylePerfect',
	    		readOnly:true,
	    		id:'serviceNameId'	    		
	    		},{
            	xtype:'label',
            	text:'*',
            	cls:'mandatoryfield',
            	id:'mandatoryregNo'
            	},{
				xtype: 'label',
				cls:'labelstyle',
				id:'regNolab',
				text: '<%=vehicleNo%> :'
				},{
				xtype:'combo',
	    		cls:'selectstylePerfect',
	    		emptyText:'<%=entervehicleno%>',	    			    		
	    		blankText :'<%=entervehicleno%>',
	    		allowBlank: false,
	    		forceSelection: true,
	    		triggerAction: 'all',
	    		anyMatch: true,
	            onTypeAhead: true,
	            selectOnFocus: true,
	    		store:vehicleRegstore,
	    		mode: 'local',
	    		valueField:'vehicleNo',
	    		displayField:'vehicleNo',
	    		id:'regNo1'	    		
      	    	},{
      	    	xtype:'label',
            	text:'',
            	cls:'mandatoryfield',
            	id:'mandatorydriverexp'
            	},{
				xtype: 'label',
				cls:'labelstyle',
				id:'driverExpenselabId',
				text: '<%=driverExpense%> :'
				},{
				xtype:'numberfield',
				allowNegative: false,
	    		cls:'selectstylePerfect',
	    		id:'driverExpense',
	    		decimalPrecision : 3 ,  
	    		value:0, 
	    		 listeners: {
                change: function(field, newValue, oldValue) {
                if(Ext.getCmp('driverExpense').getValue()==""){
                	Ext.getCmp('driverExpense').setValue(0);
                }
                    Ext.getCmp('totalId').setValue(parseFloat(Ext.getCmp('driverExpense').getValue())+parseFloat(Ext.getCmp('workerFee').getValue())+parseFloat(Ext.getCmp('misExpense').getValue())+parseFloat(Ext.getCmp('dispatchAmount').getValue())+parseFloat(Ext.getCmp('insurance').getValue())+parseFloat(Ext.getCmp('tax').getValue()));
                
                }
            }		
	    		},{
      	    	xtype:'label',
            	text:'',
            	cls:'mandatoryfield',
            	id:'mandatoryworkerfee'
            	},{
				xtype: 'label',
				cls:'labelstyle',
				id:'workerFeelabId',
				text: '<%=workerFee%> :'
				},{
				xtype:'numberfield',
				allowNegative: false,
	    		cls:'selectstylePerfect',
	    		id:'workerFee'	,
	    		value: 0,
	    		decimalPrecision : 3 ,
	    		listeners: {
                change: function(field, newValue, oldValue) {
                if(Ext.getCmp('workerFee').getValue()==""){
                	Ext.getCmp('workerFee').setValue(0)
                }
                    Ext.getCmp('totalId').setValue(parseFloat(Ext.getCmp('driverExpense').getValue())+parseFloat(Ext.getCmp('workerFee').getValue())+parseFloat(Ext.getCmp('misExpense').getValue())+parseFloat(Ext.getCmp('dispatchAmount').getValue())+parseFloat(Ext.getCmp('insurance').getValue())+parseFloat(Ext.getCmp('tax').getValue()));
                
                }
            }	    		
	    		},{
      	    	xtype:'label',
            	text:'',
            	cls:'mandatoryfield',
            	id:'mandatoryMiscExpense'
            	},{
				xtype: 'label',
				cls:'labelstyle',
				id:'miscellaneouslabId',
				text: '<%=miscellaneousFee%> :'
				},{
				xtype:'numberfield',
				allowNegative: false,
	    		cls:'selectstylePerfect',
	    		id:'misExpense'	,
	    		decimalPrecision : 3 ,	
	    		value:0,
	    		listeners: {
                change: function(field, newValue, oldValue) {
                if(Ext.getCmp('misExpense').getValue()=="")
                {
                	Ext.getCmp('misExpense').setValue(0);
                }
                    Ext.getCmp('totalId').setValue(parseFloat(Ext.getCmp('driverExpense').getValue())+parseFloat(Ext.getCmp('workerFee').getValue())+parseFloat(Ext.getCmp('misExpense').getValue())+parseFloat(Ext.getCmp('dispatchAmount').getValue())+parseFloat(Ext.getCmp('insurance').getValue())+parseFloat(Ext.getCmp('tax').getValue()));
                }
            }		
	    		},{
      	    	xtype:'label',
            	text:'',
            	cls:'mandatoryfield',
            	id:'mandatorydispatchAmt'
            	},{
				xtype: 'label',
				cls:'labelstyle',
				id:'dispatchAmtlabId',
				text: '<%=dispatchAmount%> :'
				},{
				xtype:'numberfield',
	    		cls:'selectstylePerfect',
	    		allowNegative: false,
	    		id:'dispatchAmount',
	    		decimalPrecision : 3 ,
	    		value:0,
	    		listeners: {
                change: function(field, newValue, oldValue) {
                if(Ext.getCmp('dispatchAmount').getValue()=="")
                {
                	Ext.getCmp('dispatchAmount').setValue(0);
                }
                    Ext.getCmp('totalId').setValue(parseFloat(Ext.getCmp('driverExpense').getValue())+parseFloat(Ext.getCmp('workerFee').getValue())+parseFloat(Ext.getCmp('misExpense').getValue())+parseFloat(Ext.getCmp('dispatchAmount').getValue())+parseFloat(Ext.getCmp('insurance').getValue())+parseFloat(Ext.getCmp('tax').getValue()));
                }
            }	  		
	    		},{
      	    	xtype:'label',
            	text:'',
            	cls:'mandatoryfield',
            	id:'mandatoryinsurance'
            	},{
				xtype: 'label',
				cls:'labelstyle',
				id:'insurancelabId',
				text: '<%=insurance%> :'
				},{
				xtype:'numberfield',
				allowNegative: false,
	    		cls:'selectstylePerfect',
	    		id:'insurance',
	    		value:0,
	    		decimalPrecision : 3,
	    		listeners: {
                change: function(field, newValue, oldValue) {
                 if(Ext.getCmp('insurance').getValue()=="")
                {
                	Ext.getCmp('insurance').setValue(0);
                }
                    Ext.getCmp('totalId').setValue(parseFloat(Ext.getCmp('driverExpense').getValue())+parseFloat(Ext.getCmp('workerFee').getValue())+parseFloat(Ext.getCmp('misExpense').getValue())+parseFloat(Ext.getCmp('dispatchAmount').getValue())+parseFloat(Ext.getCmp('insurance').getValue())+parseFloat(Ext.getCmp('tax').getValue()));
                }
            }	   
	    				
	    		},{
      	    	xtype:'label',
            	text:'',
            	cls:'mandatoryfield',
            	id:'mandatorytax'
            	},{
				xtype: 'label',
				cls:'labelstyle',
				id:'taxlabId',
				text: '<%=tax%> :'
				},{
				xtype:'numberfield',
				allowNegative: false,
	    		cls:'selectstylePerfect',
	    		id:'tax',
	    		decimalPrecision : 3,
	    		value:0,
	    		listeners: {
                change: function(field, newValue, oldValue) {
                if(Ext.getCmp('tax').getValue()=="")
                {
                	Ext.getCmp('tax').setValue(0);
                }
                    Ext.getCmp('totalId').setValue(parseFloat(Ext.getCmp('driverExpense').getValue())+parseFloat(Ext.getCmp('workerFee').getValue())+parseFloat(Ext.getCmp('misExpense').getValue())+parseFloat(Ext.getCmp('dispatchAmount').getValue())+parseFloat(Ext.getCmp('insurance').getValue())+parseFloat(Ext.getCmp('tax').getValue()));
                }
            }	 	    		
	    		},{
      	    	xtype:'label',
            	text:'',
            	cls:'mandatoryfield',
            	id:'mandatorytotal'
            	},{
				xtype: 'label',
				cls:'labelstyle',
				id:'totallabId',
				text: '<%=total%> :'
				},{
				xtype:'numberfield',
	    		cls:'selectstylePerfect',
	    		id:'totalId',
	    		decimalPrecision : 3,
	    		readonly: true	    		
	    		}]
	    });
	    
	    //****************************************************************************Button for Add Vehicle Inner panel form field**************************************************************************    
	var addVehiclewinButtonPanel=new Ext.Panel({
        	id: 'winbuttonidForAddVehicle',
        	standardSubmit: true,			
			cls:'windowbuttonpanel',
			frame:true,
			height:20,
			width:440,
			layout:'table',
			layoutConfig: {
				columns:2
			},
			buttons:[{
       			xtype:'button',
      			text:'<%=save%>',
        		id:'addVehicleButtId',
        		iconCls:'savebutton',
        		cls:'buttonstyle',
        		width:80,
       			listeners: 
       			{
        			click:
        			{
       					fn:function(){
       						if (Ext.getCmp('regNo1').getValue() == "") {
		                        Ext.example.msg("Enter Registration Number");
		                        Ext.getCmp('regNo1').focus();
		                        return;
		                    }
		                 
		                     var selected = grid.getSelectionModel().getSelected();
			                    	 uniqueId = selected.get('IdIndex');
			                    	 date=selected.get('DateIndex');
			                    	 if(selected.get('vehicleNumberIndex')==""){
			                    	 var addFlag=1;
			                    	 }else{
			                    	 addFlag=0;
			                    	 }
		                       Ext.Ajax.request({
		                            url: '<%=request.getContextPath()%>/ServiceVehicleAssociation.do?param=addVehicle',
		                            method: 'POST',
		                            params: {
		                            	vehicleGrid:selected.get('vehicleNumberIndex'),
		                            	addFlag:addFlag,
		                            	vehicleNo : Ext.getCmp('regNo1').getValue(),	
		                            	driverExpense : Ext.getCmp('driverExpense').getValue(),   
		                            	workerFee : Ext.getCmp('workerFee').getValue(),
		                            	misfee : Ext.getCmp('misExpense').getValue(), 
		                            	dispatchFee : Ext.getCmp('dispatchAmount').getValue(),   
		                            	insurance :  Ext.getCmp('insurance').getValue(), 
		                            	tax :  Ext.getCmp('tax').getValue(),  
		                            	total: Ext.getCmp('totalId').getValue(),                     	
										custId:Ext.getCmp('custcomboId').getValue(),
										Id:uniqueId,
										date:date,
										serviceId:selected.get('serviceIdIndex')										                           	                       
		                            },
		                            success: function (response, options) {
		                                var message = response.responseText;
		                                Ext.example.msg(message);
		                                addVehicleWin.hide();
		                                Ext.getCmp('regNo1').reset();
		                                Ext.getCmp('driverExpense').reset();
		                                Ext.getCmp('workerFee').reset();
		                                Ext.getCmp('misExpense').reset();
		                                Ext.getCmp('dispatchAmount').reset();
		                                Ext.getCmp('insurance').reset();
		                                Ext.getCmp('tax').reset();
		                                Ext.getCmp('totalId').reset();
		                                store.reload();
		                               },
		                            failure: function () {
		                                Ext.example.msg("Error");		                                
		                                addVehicleWin.hide();
		                                Ext.getCmp('regNo1').reset();
		                                Ext.getCmp('driverExpense').reset();
		                                Ext.getCmp('workerFee').reset();
		                                Ext.getCmp('misExpense').reset();
		                                Ext.getCmp('dispatchAmount').reset();
		                                Ext.getCmp('insurance').reset();
		                                Ext.getCmp('tax').reset();
		                                Ext.getCmp('totalId').reset();
		                                store.reload();
		                            }
	                        	});
                          	}
       					}
       				}
       			
      		},{
       			xtype:'button',
      			text:'<%=cancel%>',
        		id:'cancelvehicleButtId',
        		iconCls:'cancelbutton',
        		cls:'buttonstyle',
        		width:80,
       			listeners: 
       			{
        			click:
        			{
       					fn:function()
       					{
       						addVehicleWin.hide();
       						Ext.getCmp('regNo1').reset();
       						Ext.getCmp('driverExpense').reset();
       						Ext.getCmp('workerFee').reset();
       						Ext.getCmp('misExpense').reset();
       						Ext.getCmp('dispatchAmount').reset();
       						Ext.getCmp('insurance').reset();
       						Ext.getCmp('tax').reset();
       						Ext.getCmp('totalId').reset();
       					}
       				}
       			}
      		}]
	});
	
/****************************************************************************Outer panel window for form field**************************************************************************/
		var outerPanelWindow=new Ext.Panel({
			cls:'outerpanelwindow',
			standardSubmit: true,
			frame:false,
			items: [innerPanel, winButtonPanel]
		});
//***************************************************************************Outer panel for Add Vehicle**************************************************************
var addVehicleouterPanelWindow=new Ext.Panel({
			cls:'outerpanelwindow',
			standardSubmit: true,
			frame:false,
			items: [addVehicleinnerPanel, addVehiclewinButtonPanel]
		});
/****************************************************************************Window For Add and Edit**************************************************************************/
		myWin = new Ext.Window({
		    title: 'titelForInnerPanel',
		    closable: false,
		    resizable: false,
		    modal: true,
		    autoScroll: true,
		    frame:true,
		    height:260,
		    width:450,
		    id: 'myWin',
		    items: [outerPanelWindow]
		});
//****************************************************************************Window For Add Vehicle****************************************************************************
		addVehicleWin = new Ext.Window({
		    title: 'titelForAddVehicle',
		    closable: false,
		    resizable: false,
		    modal: true,
		    autoScroll: true,
		    frame:true,
		    height:370,
		    width:450,
		    id: 'addVehicleWin',
		    items: [addVehicleouterPanelWindow]
		});
//****************************************************************************Add Prepaid Card Details**************************************************************************
	function addRecord() {
	  buttonValue = 'Add';
	  titelForInnerPanel = '<%=addServiceVehicleAssociation%>';
	  myWin.setPosition(460,100);	    	   
	  myWin.setTitle(titelForInnerPanel);	
	  myWin.show();
	  
	  Ext.getCmp('terminalName').enable();
	  Ext.getCmp('terminalName').reset();
	   Ext.getCmp('serviceNameNo').enable(); 
	  Ext.getCmp('serviceNameNo').reset();
	  Ext.getCmp('DateId').enable(); 
	  Ext.getCmp('DateId').reset();
	  Ext.getCmp('StatusId').reset();
	 
	  Ext.getCmp('mandatorydaytype').hide();    
	  Ext.getCmp('datetypelab').hide();
	  Ext.getCmp('datetype').hide();
	
	  Ext.getCmp('mandatoryrouteName').hide();
	  Ext.getCmp('routeNamelab').hide();
	  Ext.getCmp('routeNames').hide();
	
	  Ext.getCmp('mandatoryorigin').hide();
	  Ext.getCmp('originlab').hide();
	  Ext.getCmp('origin').hide();
	
	  Ext.getCmp('mandatorydistance').hide();
	  Ext.getCmp('distancelab').hide();
	  Ext.getCmp('distance').hide();
	
	  Ext.getCmp('mandatorydeparture').hide();    
	  Ext.getCmp('departurelab').hide();
	  Ext.getCmp('departurearrival').hide();
	
	  Ext.getCmp('mandatoryduration').hide();
	  Ext.getCmp('durationlab').hide();
	  Ext.getCmp('duration').hide();
	
	  Ext.getCmp('mandatoryvehiclemodel').hide();
	  Ext.getCmp('vehiclemodellab').hide();
	  Ext.getCmp('vehiclemodel').hide();
	
	  Ext.getCmp('mandatoryseatingstructure').hide();
	  Ext.getCmp('seatingstructurelab').hide();
	  Ext.getCmp('seatingstructure').hide();
	
	  Ext.getCmp('mandatoryrate').hide();
	  Ext.getCmp('ratelab').hide();
	  Ext.getCmp('rate').hide();
	 
	    
	}
//****************************************************************************Modify Prepaid Card Details**************************************************************************	
	function modifyData(){
	  if (grid.getSelectionModel().getCount() == 0) {
	        Ext.example.msg("No Row Selected");
	        return;
	  }
	  if (grid.getSelectionModel().getCount() > 1) {
	        Ext.example.msg("Select Single Row");
	        return;
	  }
	  buttonValue='modify';
	  title='<%=modifyServiceVehicleAssociation%>';
	  myWin.setPosition(460,100);
	  myWin.setTitle(title);
	  myWin.show();	  	
	  //Ext.getCmp('regNo').disable(); 
	   Ext.getCmp('terminalName').disable(); 
      Ext.getCmp('serviceNameNo').disable(); 
        Ext.getCmp('DateId').disable();
          Ext.getCmp('CheckId').disable();
	  var selected = grid.getSelectionModel().getSelected();	  	  
  //    Ext.getCmp('regNo').setValue(selected.get('vehicleNumberIndex'));
      Ext.getCmp('serviceNameNo').setValue(selected.get('serviceNameIndex'));
	  Ext.getCmp('datetype').setValue(selected.get('dayTypeIndex'));
	  Ext.getCmp('terminalName').setValue(selected.get('terminalIndex'));
	  Ext.getCmp('routeNames').setValue(selected.get('routeNameIndex'));
	  Ext.getCmp('origin').setValue(selected.get('originDestinationIndex'));
	  Ext.getCmp('distance').setValue(selected.get('distanceIndex'));
	  Ext.getCmp('departurearrival').setValue(selected.get('departureArrivalIndex'));
	  Ext.getCmp('duration').setValue(selected.get('durationIndex'));
	  Ext.getCmp('vehiclemodel').setValue(selected.get('vehicleModelIndex'));
	  Ext.getCmp('seatingstructure').setValue(selected.get('seatingStructIndex'));
	  Ext.getCmp('rate').setValue(selected.get('rateIndex'));
	  Ext.getCmp('StatusId').setValue(selected.get('statusIndex')); 
	  Ext.getCmp('DateId').setValue(selected.get('DateIndex')); 
	  Ext.getCmp('mandatorydaytype').show();    
	  Ext.getCmp('datetypelab').show();
	  Ext.getCmp('datetype').show();
	  Ext.getCmp('mandatoryrouteName').show();
	  Ext.getCmp('routeNamelab').show();
	  Ext.getCmp('routeNames').show();
	
	  Ext.getCmp('mandatoryorigin').show();
	  Ext.getCmp('originlab').show();
	  Ext.getCmp('origin').show();
	
	  Ext.getCmp('mandatorydistance').show();
	  Ext.getCmp('distancelab').show();
	  Ext.getCmp('distance').show();
	
	  Ext.getCmp('mandatorydeparture').show();    
	  Ext.getCmp('departurelab').show();
	  Ext.getCmp('departurearrival').show();
	
	  Ext.getCmp('mandatoryduration').show();
	  Ext.getCmp('durationlab').show();
	  Ext.getCmp('duration').show();
	
	  Ext.getCmp('mandatoryvehiclemodel').show();
	  Ext.getCmp('vehiclemodellab').show();
	  Ext.getCmp('vehiclemodel').show();
	
	  Ext.getCmp('mandatoryseatingstructure').show();
	  Ext.getCmp('seatingstructurelab').show();
	  Ext.getCmp('seatingstructure').show();
	
	  Ext.getCmp('mandatoryrate').show();
	  Ext.getCmp('ratelab').show();
	  Ext.getCmp('rate').show();
	       
	}
	
	function addVehicleData(){
	 titelForAddVehicle = 'Add Vehicle';
	  addVehicleWin.setPosition(460,100);	    	   
	  addVehicleWin.setTitle(titelForAddVehicle);	
	  addVehicleWin.show();
	  var selected = grid.getSelectionModel().getSelected();	  	  
      Ext.getCmp('serviceNameId').setValue(selected.get('serviceNameIndex'));
      Ext.getCmp('driverExpense').setValue(selected.get('driverExpenseIndex'));
      Ext.getCmp('workerFee').setValue(selected.get('workerFeeIndex'));
      Ext.getCmp('misExpense').setValue(selected.get('misExpenseIndex'));
      Ext.getCmp('dispatchAmount').setValue(selected.get('dispatchIndex'));
      Ext.getCmp('insurance').setValue(selected.get('insuranceIndex'));
      Ext.getCmp('tax').setValue(selected.get('taxIndex'));
      Ext.getCmp('totalId').setValue(selected.get('totalIndex'));
      Ext.getCmp('serviceNameId').disable();
      Ext.getCmp('totalId').disable();
      if(selected.get('vehicleNumberIndex')!=''){
      Ext.getCmp('regNo1').setValue(selected.get('vehicleNumberIndex'))
      
      }
            vehicleRegstore.load({params:{
            custId : Ext.getCmp('custcomboId').getValue(),
            date:selected.get('DateIndex')
            }});
      
	}

/****************************************************************************Grid**************************************************************************/	    
		grid = getGridVehicle('','<%=noRecordFound%>',store,screen.width - 40,410,25,filters,'<%=clearFilterData%>',false,'',9,false,'',false,'',true,'Excel',jspName,exportDataType,true,'PDF',true,'<%=add%>',true,'<%=modify%>',true,'<%=addVehicle%>',false,'',false,'',false,'');
/****************************************************************************Ext onReady Outer panel window**************************************************************************/
		Ext.onReady(function () {
		    Ext.QuickTips.init();
		    Ext.form.Field.prototype.msgTarget = 'side';
		    outerPanel = new Ext.Panel({
		        title: 'Service Vehicle Association',		        
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
		    var cm = grid.getColumnModel();  
					    for (var j = 1; j < cm.getColumnCount(); j++) {
					       cm.setColumnWidth(j,155);
					    }
		});
   	</script>
<jsp:include page="../Common/footer.jsp" />
 <!-- </body>   -->
 <!-- </html> -->