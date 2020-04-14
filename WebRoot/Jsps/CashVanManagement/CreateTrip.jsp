<%@ page language="java"
	import="java.util.*,t4u.functions.*,t4u.beans.*,t4u.common.*"
	pageEncoding="utf-8"%>
	<%@ taglib uri="http://packtag.sf.net" prefix="pack" %>
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
    int userId=loginInfo.getUserId();
    
    ArrayList<String> tobeConverted=new ArrayList<String>();
	tobeConverted.add("Select_Customer");
	tobeConverted.add("Please_Select_customer");
	tobeConverted.add("SLNO");
	tobeConverted.add("Save");
	tobeConverted.add("No_Records_Found");
	tobeConverted.add("Cancel");
	tobeConverted.add("Error");
	tobeConverted.add("Select_Single_Row");
	tobeConverted.add("Type");
	tobeConverted.add("Select_Type");
	tobeConverted.add("Unique_Id");
	tobeConverted.add("Route_Name");
	tobeConverted.add("Create_Trip");
	tobeConverted.add("Select_Route");
	tobeConverted.add("Select_Vehicle");
	tobeConverted.add("Select_Group");
	tobeConverted.add("Group_Id");
	tobeConverted.add("Group_Name");
	tobeConverted.add("Vehicle_No");
	tobeConverted.add("Mobile_No");
	tobeConverted.add("Email_ID");
	tobeConverted.add("Days");
	tobeConverted.add("Status");
	tobeConverted.add("Enter_Mobile_No");
	tobeConverted.add("Enter_Email_Id");
	tobeConverted.add("Close_Trip_Details");
	tobeConverted.add("Remarks");
	tobeConverted.add("Enter_Remarks");
	tobeConverted.add("Customer_Name");
	tobeConverted.add("Return_Route_Name");
	tobeConverted.add("Assign_To");
	tobeConverted.add("Guest_Alert");
	tobeConverted.add("Inserted_By");
	tobeConverted.add("Inserted_Time");
	tobeConverted.add("Trip_Type");
	tobeConverted.add("Auto_Cancle_Days");
	tobeConverted.add("No_Of_Days");
	tobeConverted.add("Enter_No_Of_Days");
	tobeConverted.add("Enter_Auto_Cancel_Days");
	tobeConverted.add("Cancel_Trip");
	tobeConverted.add("Add_Trip_Information");
	tobeConverted.add("Modify_Trip_Information");
	tobeConverted.add("Close_Trip");
	tobeConverted.add("Enter_Valid_Mobile_Number");
	tobeConverted.add("Enter_Valid_Email_Id");
	tobeConverted.add("Please_Select_Route");
	tobeConverted.add("Return_Trip");
	tobeConverted.add("Start_Date");
	tobeConverted.add("End_Date");
	tobeConverted.add("Select_Start_Date");
	tobeConverted.add("Select_End_Date");
	tobeConverted.add("End_Date_Must_Be_Greater_Than_Start_Date");
	tobeConverted.add("Month_Validation");
	tobeConverted.add("View");
	
ArrayList<String> convertedWords=new ArrayList<String>();
convertedWords=cf.getLanguageSpecificWordForKey(tobeConverted,language);
    String Select_Customer=convertedWords.get(0);
    String Please_Select_customer=convertedWords.get(1);
	String SLNO=convertedWords.get(2);
	String Save =convertedWords.get(3);
	String No_Records_Found=convertedWords.get(4);
	String Cancel=convertedWords.get(5);
	String Error=convertedWords.get(6);
	String Select_Single_Row=convertedWords.get(7);
	String Type=convertedWords.get(8);
	String Select_Type =convertedWords.get(9);
	String Unique_Id=convertedWords.get(10);
	String Route_Name=convertedWords.get(11);
	String Create_Trip=convertedWords.get(12);
	String Select_Route=convertedWords.get(13);
	String Select_Vehicle=convertedWords.get(14);
	String Select_Group =convertedWords.get(15);
	String Group_Id=convertedWords.get(16);
	String Group_Name=convertedWords.get(17);
	String Vehicle_No=convertedWords.get(18);
	String Mobile_No=convertedWords.get(19);
	String Email_Id=convertedWords.get(20);
	String Days =convertedWords.get(21);
	String Status=convertedWords.get(22);
	String Enter_Mobile_No=convertedWords.get(23);
	String Enter_Email_Id=convertedWords.get(24);
	String Close_Trip_Details=convertedWords.get(25);
	String Remarks =convertedWords.get(26);
	String Enter_Remarks=convertedWords.get(27);
	String Customer_Name=convertedWords.get(28);
	String Return_Route_Name=convertedWords.get(29);
	String Assign_To=convertedWords.get(30);
    String Guest_Alert=convertedWords.get(31);
    String Inserted_By=convertedWords.get(32);
	String Inserted_Time=convertedWords.get(33);
	String Trip_Type=convertedWords.get(34);
	String Auto_Cancle_Days=convertedWords.get(35);
	String No_Of_Days=convertedWords.get(36);
	String Enter_No_Of_Days=convertedWords.get(37);
	String Enter_Auto_Cancel_Days=convertedWords.get(38);
	String Cancel_Trip=convertedWords.get(39);
	String Add_Trip_Information=convertedWords.get(40);
	String Modify_Trip_Information=convertedWords.get(41);
	String Close_Trip=convertedWords.get(42);
	String Enter_Valid_Mobile_Number=convertedWords.get(43);
	String Enter_Valid_Email_Id=convertedWords.get(44);
	String Please_Select_Route=convertedWords.get(45);
	String Return_Trip=convertedWords.get(46);
	String startDate=convertedWords.get(47);
	String endDate=convertedWords.get(48);
	String selectStartDate=convertedWords.get(49);
	String selectEndDate=convertedWords.get(50);
	String EndDateMustBeGreaterthanStartDate=convertedWords.get(51);
	String monthValidation=convertedWords.get(52);
	String view=convertedWords.get(53);
%>

<jsp:include page="../Common/header.jsp" />
    <title><%=Create_Trip %></title>
		
	<%if (loginInfo.getStyleSheetOverride().equals("Y")){%>
		<jsp:include page="../Common/ImportJSSandMining.jsp" />
		<%}else {%>
		<jsp:include page="../Common/ImportJS.jsp" />
		<%} %>
		<jsp:include page="../Common/ExportJS.jsp" />
<style>		
		
		label {
			display : inline !important;
		}

		
		.x-window-tl *.x-window-header {
			padding-top : 6px !important;
			height : 46px !important;
		}

		.ext-strict .x-form-text {
			height: 21px !important;			
		}
		#addTrippanelId {
			width : 735px !important;
		}
		.x-layer ul {
		 	min-height:27px !important;
		}
</style>		
<script>
					Ext.Ajax.timeout = 360000;
                    var jspName = 'Create Trip';
                    var exportDataType = "int,string,string,string,string,string,string,string,string,string,string";
                    var json = "";
                    var gridData = "";
                    var groid = "";
                    var dtprev = dateprev;
    				var dtcur = datecur;
    				var datenext = datenext;
                    var globalType= "";
                    var  globalClientId= "";
                    var loadMask = new Ext.LoadMask(Ext.getBody(), { msg: "Saving" });
				
    var customercombostore = new Ext.data.JsonStore({
        url: '<%=request.getContextPath()%>/CommonAction.do?param=getCustomer',
        id: 'CustomerStoreId',
        root: 'CustomerRoot',
        autoLoad: true,
        remoteSort: true,
        fields: ['CustId', 'CustName'],
        listeners: {
            load: function(custstore, records, success, options) {
                if (<%= customerId %> > 0) {
                    Ext.getCmp('custcomboId').setValue('<%=customerId%>');
                    custId = Ext.getCmp('custcomboId').getValue();
                    custName = Ext.getCmp('custcomboId').getRawValue();  
                     routecombostore.load({
                    params:{
                    CustId:Ext.getCmp('custcomboId').getValue()
                    }
                    });
                    
                      alertcombostore.load({
                        params: {
                            CustId: Ext.getCmp('custcomboId').getValue()
                        }
                      });
                         
                }
            }
        }
    });

    var custnamecombo = new Ext.form.ComboBox({
        store: customercombostore,
        id: 'custcomboId',
        mode: 'local',
        forceSelection: true,
        emptyText: '<%=Select_Customer%>',
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
                    custName = Ext.getCmp('custcomboId').getRawValue();
                    if (<%= customerId %> > 0) {
                        Ext.getCmp('custcomboId').setValue('<%=customerId%>');
                        custId = Ext.getCmp('custcomboId').getValue();
                        custName = Ext.getCmp('custcomboId').getRawValue();
                    }
                    routecombostore.load({
                    params:{
                    CustId:Ext.getCmp('custcomboId').getValue()
                    }
                    });
                    
                    alertcombostore.load({
                        params: {
                            CustId: Ext.getCmp('custcomboId').getValue()
                        }
                      });
                    
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
        width: screen.width - 40,    
        layoutConfig: {
            columns:10
        },
        items: [{
                xtype: 'label',
                text: '<%=Customer_Name%>' + ' :',
                cls: 'labelstyle',
                id: 'custnamelab'
            },
            custnamecombo,
            { width: 50 },
            {	xtype: 'label',
                cls: 'labelstyle',
                id: 'startdatelab',
                text: '<%=startDate%>' + ' :'
            }, {
                xtype: 'datefield',
                cls: 'selectstylePerfect',
                width: 185,
                format: getDateFormat(),
                emptyText: '<%=selectStartDate%>',
                allowBlank: false,
                blankText: '<%=selectStartDate%>',
                id: 'startdateId',
                value: datecur,
                endDateField: 'enddate'
            }, { width: 50 }, 
            {
                xtype: 'label',
                cls: 'labelstyle',
                id: 'enddatelab',
                text: '<%=endDate%>' + ' :'
            }, {
                xtype: 'datefield',
                cls: 'selectstyle',
                width: 185,
                format: getDateFormat(),
                emptyText: '<%=selectEndDate%>',
                allowBlank: false,
                blankText: '<%=selectEndDate%>',
                id: 'enddateId',
                value: datenext,
                startDateField: 'startdate'
            }, {
                width: 50
            }, {
                xtype: 'button',
                text: '<%=view%>',
                id: 'generateReport',
                cls: 'buttonwastemanagement',
                width: 60,
                listeners: {
                    click: {
                        fn: function() {
                            if (Ext.getCmp('custcomboId').getValue() == "") {
                                Ext.example.msg("<%=Select_Customer%>");
                                Ext.getCmp('custcomboId').focus();
                                return;
                            }

                            if (Ext.getCmp('startdateId').getValue() == "") {
                                Ext.example.msg("<%=selectStartDate%>");
                                Ext.getCmp('startdateId').focus();
                                return;
                            }

                            if (Ext.getCmp('enddateId').getValue() == "") {
                                Ext.example.msg("<%=selectEndDate%>");
                                Ext.getCmp('enddateId').focus();
                                return;
                            }

                            if (dateCompare(Ext.getCmp('startdateId').getValue(), Ext.getCmp('enddateId').getValue()) == -1) {
                                Ext.example.msg("<%=EndDateMustBeGreaterthanStartDate%>");
                                Ext.getCmp('enddateId').focus();
                                return;
                            }

                            if (checkMonthValidation(Ext.getCmp('startdateId').getValue(), Ext.getCmp('enddateId').getValue())) {
                                Ext.example.msg("<%=monthValidation%>");
                                Ext.getCmp('enddateId').focus();
                                return;
                            }
                            store.load({
                                params: {
                                    startdate: Ext.getCmp('startdateId').getValue(),
                        			enddate: Ext.getCmp('enddateId').getValue(),
                                    CustId: Ext.getCmp('custcomboId').getValue()
                                }
                            });

                        }
            		   }
            		  }
            		}  	
        ]
    });
    
    var routecombostore = new Ext.data.JsonStore({
	    url: '<%=request.getContextPath()%>/CreateTripAction.do?param=getRouteNames',
	    id: 'RouteNametoreId',
	    root: 'RouteNameRoot',
	    autoLoad: false,
	    remoteSort: true,
	    fields: ['RouteId', 'RouteName']
	});
	
    
    var routeCombo = new Ext.form.ComboBox({
    store: routecombostore,
    id: 'routenamecomboId',
    mode: 'local',
    forceSelection: true,
    emptyText: '<%=Select_Route%>',
    selectOnFocus: true,
    hidden:false,
    allowBlank: true,
    anyMatch: true,
    typeAhead: false,
    triggerAction: 'all',
    valueField: 'RouteId',
    width: 170,
    displayField: 'RouteName',
    cls: 'selectstylePerfect',
    listeners: {
        select: {
           
        }
    }
});
var vehiclecombostoreForModify = new Ext.data.JsonStore({
        url: '<%=request.getContextPath()%>/CreateTripAction.do?param=getVehicledetailsForModify',
        root: 'clientVehiclesForModify',
        autoLoad: true,
        fields: ['unique','vehicleNo'],
         listeners: {
        load: function() {
            var k = 0;
  	 		vehiclecombostoreForModify.each(function(rec) {
          	vehicleGridForModify.getSelectionModel().selectRow(k, true);
        	k++;
     });
        }
    }
    });
 	
 	
 	var vehicleSelect1 = new Ext.grid.CheckboxSelectionModel();
 	var vehicleGridForModify = new Ext.grid.GridPanel({
    id: 'vehicleGridIdForModify',
    store: vehiclecombostoreForModify,
    columns: [
        vehicleSelect1, {
            header: '<%=Select_Vehicle%>',
            hidden: false,
            sortable: true,
            width: 123,
            id: 'selectAllVehicleId1',
            columns: [{
                xtype: 'checkcolumn',
                dataIndex: 'vehicleNo'
            
            }]
        }
    ],
    sm: vehicleSelect1,
    plugins: filters,
    stripeRows: true,
    border: true,
    frame: false,
    width: 165,
    height: 145,
    style: 'margin-left:5px;',
    cls: 'bskExtStyle',
    deferRowRender: false
    
});


var groupcombostoreForModify = new Ext.data.JsonStore({
        url: '<%=request.getContextPath()%>/CreateTripAction.do?param=getGroupdetailsForModify',
        root: 'clientGroupsForModify',
        autoLoad: true,
        fields: ['unique','groupName'],
         listeners: {
        load: function() {
            var k = 0;
  	 		groupcombostoreForModify.each(function(rec) {
          	groupGridForModify.getSelectionModel().selectRow(k, true);
        	k++;
     });
        }
    }
    });
 	
 	
 	var groupSelect1 = new Ext.grid.CheckboxSelectionModel();
 	var groupGridForModify = new Ext.grid.GridPanel({
    id: 'groupGridIdForModify',
    store: groupcombostoreForModify,
    columns: [
        groupSelect1, {
            header: '<%=Select_Group%>',
            hidden: false,
            sortable: true,
            width: 123,
            id: 'selectAllGroupId1',
            columns: [{
                xtype: 'checkcolumn',
                dataIndex: 'groupName'
            
            }]
        }
    ],
    sm: groupSelect1,
    plugins: filters,
    stripeRows: true,
    border: true,
    frame: false,
    width: 165,
    height: 145,
    style: 'margin-left:5px;',
    cls: 'bskExtStyle',
    deferRowRender: false
    
});
 
 var alertnamecombostoreForModify = new Ext.data.JsonStore({
        url: '<%=request.getContextPath()%>/CreateTripAction.do?param=getalertNameForModify',
        root: 'alertnamesForModify',
        autoLoad: true,
        fields: ['unique','alertName'],
         listeners: {
        load: function() {
            var k = 0;
  	 		alertnamecombostoreForModify.each(function(rec) {
          	alertnameGridForModify.getSelectionModel().selectRow(k, true);
        	k++;
     });
        }
    }
    });
 	
 	
 	var alertname1 = new Ext.grid.CheckboxSelectionModel();
 	var alertnameGridForModify = new Ext.grid.GridPanel({
    id: 'alertnameGridIdForModify',
    store: alertnamecombostoreForModify,
    columns: [
        groupSelect1, {
            header: 'Select Alert Name',
            hidden: false,
            sortable: true,
            width: 123,
            id: 'selectAllGroupId1',
            columns: [{
                xtype: 'checkcolumn',
                dataIndex: 'groupName'
            
            }]
        }
    ],
    sm: alertname1,
    plugins: filters,
    stripeRows: true,
    border: true,
    frame: false,
    width: 165,
    height: 145,
    style: 'margin-left:5px;',
    cls: 'bskExtStyle',
    deferRowRender: false
    
});
  var alertcombostore= new Ext.data.JsonStore({
		url:'<%=request.getContextPath()%>/CreateTripAction.do?param=getAlert',
		id:'alertStoreId',
		root:'alertStoreList',
		autoLoad:false,
		fields : ['alertId','alertName']
		});

  var alertSelect = new Ext.grid.CheckboxSelectionModel();
  var filters3 = new Ext.ux.grid.GridFilters({
	local : true,
	filters:[{
		dataIndex : 'alertName',
		type: 'string'
	}]
});	
  var alertGrid = new Ext.grid.GridPanel({
		id:'alertGridId',
		store: alertcombostore,
		columns: [alertSelect, {
		header:'Select Alert',
		hidden:false,
		sortable:true,
		dataIndex:'alertName',
		width: 123,
		id:'selectAllAlertId',
		columns: [{
		      xtype:'checkcolumn',
		      dataIndex:'alertName'
		     }]
		   }
		],
		sm: alertSelect,
		plugins: filters3,
		stripeRows:true,
		border:true,
		frame:false,
		width: 165,
		height: 145,
		style:'margin-left:5px;',
		cls:'bskExtStyle'
		});
		

var returnTripStore = new Ext.data.SimpleStore({
    id: 'returnTripStoreId',
     autoLoad: true,
	fields: ['Name','Value'],
	data: [['Yes','Yes'],['No','No']]
	});

	var returnTripCombo = new Ext.form.ComboBox({
	store: returnTripStore,
	id: 'returnTripComboId',
	mode: 'local',
	value: 'Yes',
	selectOnFocus: true,
	allowBlank: true,
	typeAhead: false,
	triggerAction: 'all',
	valueField: 'Value',
	width: 170,
	displayField: 'Name',
	cls: 'selectstylePerfect' ,
	listeners: {
        select: {
           		fn:function(){
           		if(Ext.getCmp('returnTripComboId').getValue()=='Yes'){
           		Ext.getCmp('returnroutenamecomboId').show();
           		Ext.getCmp('mandatoryReturnRouteNameLabel').show();
           		Ext.getCmp('mandatoryReturnRouteName').show();
           		Ext.getCmp('ReturnRouteNameLabelId').show();
           		}else{
           		Ext.getCmp('returnroutenamecomboId').hide();
           		Ext.getCmp('mandatoryReturnRouteNameLabel').hide();
           		Ext.getCmp('mandatoryReturnRouteName').hide();
           		Ext.getCmp('ReturnRouteNameLabelId').hide();
           		}
           		}
        }
    }
	});
	
	

	var ReturnRouteCombo = new Ext.form.ComboBox({
    store: routecombostore,
    id: 'returnroutenamecomboId',
    mode: 'local',
    forceSelection: true,
    emptyText: '<%=Select_Route%>',
    selectOnFocus: true,
    allowBlank: true,
    anyMatch: true,
    typeAhead: false,
    triggerAction: 'all',
    valueField: 'RouteId',
    width: 170,
    displayField: 'RouteName',
    cls: 'selectstylePerfect',
    listeners: {
        
    }
});

	var AssignToStore = new Ext.data.SimpleStore({
    id: 'assignToStoreId',
    autoLoad: true,
	fields: ['Name','Value'],
	data: [['Group','Group'],['Vehicle','Vehicle']]
	});
	
   var AssignToCombo = new Ext.form.ComboBox({
	store: AssignToStore,
	id: 'assignToComboId',
	mode: 'local',
	selectOnFocus: true,
	allowBlank: true,
	typeAhead: false,
	triggerAction: 'all',
	valueField: 'Value',
	width: 170,
	displayField: 'Name',
	value:'Group',
	cls: 'selectstylePerfect' ,
	emptyText: 'Select Type',
	listeners: {
        select: {
           fn: function(){
            vehiclecombostore.load({
	           params: {
	           
	           }
	           });
	           
	           groupcombostore.load({
	           params: {
	           
	           }
	           });
	           
	           
           		
           if(Ext.getCmp('assignToComboId').getValue()=='Group'){
           		Ext.getCmp('groupGridId').show();
           		Ext.getCmp('mandatoryGroupNamelabel').show();
           		Ext.getCmp('mandatoryGroupNameLabelId').show();
           		Ext.getCmp('groupNameLabelId').show();
           		
           		Ext.getCmp('vehicleGridId').hide();
           		Ext.getCmp('mandatoryVehicleNoLabel').hide();
           		Ext.getCmp('mandatoryvehicleNoLabelId').hide();
           		Ext.getCmp('vehicleNoLabelId').hide();
           		
           		groupcombostore.load({
           		params:{
           		clientid:Ext.getCmp('custcomboId').getValue()
           		}
           		});
           	
           		}else{
           		Ext.getCmp('groupGridId').hide();
           		Ext.getCmp('mandatoryGroupNamelabel').hide();
           		Ext.getCmp('mandatoryGroupNameLabelId').hide();
           		Ext.getCmp('groupNameLabelId').hide();
           		
           		Ext.getCmp('vehicleGridId').show();
           		Ext.getCmp('mandatoryVehicleNoLabel').show();
           		Ext.getCmp('mandatoryvehicleNoLabelId').show();
           		Ext.getCmp('vehicleNoLabelId').show();
           		
           		
           	   vehiclecombostore.load({
	           params: {
	           clientId:Ext.getCmp('custcomboId').getValue(),
	           groupId:0
	           }
	           });
           		}
           
           }
        }
       
    }
	});
	
	 var groupcombostore= new Ext.data.JsonStore({
    	url:'<%=request.getContextPath()%>/CreateTripAction.do?param=getGroupNames',
    	id: 'groupStoreId',
    	root: 'GroupStoreList',
    	autoLoad: false,
    	fields : ['groupId','groupName']
    });
    var filters2 = new Ext.ux.grid.GridFilters({
		local : true,
		filters:[{
			dataIndex: 'groupName',
			type: 'string'
		}]
	});
    var groupSelect = new Ext.grid.CheckboxSelectionModel();
	var groupGrid = new Ext.grid.GridPanel({
    id: 'groupGridId',
    store: groupcombostore,
    columns: [
        groupSelect, {
            header: '<%=Select_Group%>',
            hidden: false,
            sortable: true,
            dataIndex: 'groupName',
            width: 123,
            id: 'selectAllGroupId',
            columns: [{
                xtype: 'checkcolumn',
                dataIndex: 'groupName'
            }]
        }
    ],
    sm: groupSelect,
    plugins: filters2,
    stripeRows: true,
    border: true,
    frame: false,
    width: 165,
    height: 145,
    style: 'margin-left:5px;',
    cls: 'bskExtStyle'
});

var vehiclecombostore = new Ext.data.JsonStore({
        url: '<%=request.getContextPath()%>/CreateTripAction.do?param=getvehiclesandgroupforclients',
        root: 'clientVehicles',
        autoLoad: true,
        fields: ['groupId','vehicleName']
        
    });

var vehicleSelect = new Ext.grid.CheckboxSelectionModel();
var filters1 = new Ext.ux.grid.GridFilters({
	local : true,
	filters:[{
		dataIndex : 'vehicleName',
		type: 'string'
	}]
});
var vehicleGrid = new Ext.grid.GridPanel({
    id: 'vehicleGridId',
    store: vehiclecombostore,
    columns: [
        vehicleSelect, {
            header: '<%=Select_Vehicle%>',
            hidden: false,
            sortable: true,
            width: 123,
           	dataIndex: 'vehicleName',
            id: 'selectAllVehicleId',
            columns: [{
                xtype: 'checkcolumn',
                dataIndex: 'vehicleName'
            }]
        }
    ],
    sm: vehicleSelect,
    plugins: filters1,
    stripeRows: true,
    border: true,
    frame: false,
    width: 165,
    height: 140,
    style: 'margin-left:5px;',
    cls: 'bskExtStyle'
});

var GuestAlertStore = new Ext.data.SimpleStore({
    id: 'assignToStoreId',
    autoLoad: true,
	fields: ['Name','Value'],
	data: [['Yes','Yes'],['No','No']]
	});
	

var GuestAlertCombo=new Ext.form.ComboBox({
	store: GuestAlertStore,
	id: 'guestalertComboId',
	mode: 'local',
	selectOnFocus: true,
	allowBlank: true,
	typeAhead: false,
	value:'Yes',
	triggerAction: 'all',
	valueField: 'Value',
	width: 170,
	displayField: 'Name',
	cls: 'selectstylePerfect' ,
	emptyText: '<%=Select_Type%>',
	listeners: {
        select: {
           fn:function(){
           if(Ext.getCmp('guestalertComboId').getValue()=='No'){
           Ext.getCmp('mandatoryMobileLabelId').hide(),
           Ext.getCmp('mandatoryEmailId').hide(),
           Ext.getCmp('emailId').hide(),
           Ext.getCmp('mobileNoId').hide(),
           Ext.getCmp('mobileLabelId').hide(),
           Ext.getCmp('emailLabelId').hide()
           }else{
            Ext.getCmp('mandatoryMobileLabelId').show(),
           Ext.getCmp('mandatoryEmailId').show(),
           Ext.getCmp('emailId').show(),
           Ext.getCmp('mobileNoId').show(),
           Ext.getCmp('mobileLabelId').show(),
           Ext.getCmp('emailLabelId').show()
           }
           }
        }
    }
	});
	
	var statusComboStore = new Ext.data.SimpleStore({
    id: 'statusStoreId',
    autoLoad: true,
	fields: ['Name','Value'],
	data: [['Active','Active'],['Inactive','Inactive']]
	});
	
	
	var statusCombo=new Ext.form.ComboBox({
	store: statusComboStore,
	id: 'statusComboId',
	mode: 'local',
	selectOnFocus: true,
	allowBlank: true,
	typeAhead: false,
	triggerAction: 'all',
	valueField: 'Value',
	width: 170,
	value:'Active',
	displayField: 'Name',
	cls: 'selectstylePerfect' ,
	listeners: {
        select: {
           
        }
    }
	});
	
    var tripComboStore = new Ext.data.SimpleStore({
    id: 'statusStoreId',
    autoLoad: true,
	fields: ['Name','Value'],
	data: [['Single','Single'],['Auto','Auto']]
	});
	
	
	var tripTypeCombo=new Ext.form.ComboBox({
	store: tripComboStore,
	id: 'tripTypeComboId',
	mode: 'local',
	selectOnFocus: true,
	allowBlank: true,
	typeAhead: false,
	triggerAction: 'all',
	valueField: 'Value',
	width: 170,
	value:'Active',
	displayField: 'Name',
	cls: 'selectstylePerfect' ,
	value:'Single',
	listeners: {
        select: {
        fn: function(){
        Ext.getCmp('daysId').setValue('');
        Ext.getCmp('autodaysId').setValue('');
        
           }
        }
    }
	});
      
      var gridreader = new Ext.data.JsonReader({
        idProperty: 'ticketDetailsId',
    	root: 'ticketDetailsRoot',
    	totalProperty: 'total',
    	fields: [{
        name: 'slnoIndex'
    	},{
        name: 'uniqueIdIndex'
    	},{
        name: 'routeNameDataIndex'
    	},{
    	name:'returnrouteNameDataIndex'
    	},{
    	name:'assignToDataIndex'
    	},{
        name: 'groupNameDataIndex'
    	},{
    	name:'groupIdDataIndex'
    	},{
        name: 'vehicleDataIndex'
    	},{ 
    	name: 'uniqueNoDataIndex'
    	},{
        name: 'insertedByDataIndex'
    	},{
    	name:'guestAlertDataIndex'
    	},{
    	name:'mobileDataIndex'
    	},{
    	name:'emailDataIndex'
    	},{
    	name: 'insertedTimeDataIndex',
    	type: 'date'
    	},{
    	name: 'tripTypeDataIndex',
    	
    	},{
    	name: 'daysDataIndex',
    	
    	},{
    	name: 'autoDataIndex',
    	
    	},{
        name: 'statusDataIndex'
    	},{
        name: 'superMobileNoIndex'
    	},{
        name: 'superEmailIdDataIndex'
    	}]
    });
      
      var filters = new Ext.ux.grid.GridFilters({
        local: true,
    	filters: [{
        type: 'numeric',
        dataIndex: 'slnoIndex'
    	},{
        type: 'numeric',
        dataIndex: 'uniqueIdIndex'
    	},{
    	type: 'string',
        dataIndex: 'routeNameDataIndex'
    	},{
        type: 'string',
        dataIndex: 'returnrouteNameDataIndex'
    	},{
        type: 'string',
        dataIndex: 'assignToDataIndex'
    	},{
    	type: 'string',
        dataIndex: 'groupNameDataIndex'
    	},{
    	type:'int',
    	dataIndex: 'groupIdDataIndex'
    	},{
    	type: 'string',
        dataIndex: 'vehicleDataIndex'
    	},{
    	type: 'string',
    	dataIndex:'uniqueNoDataIndex'
    	},{
    	type: 'string',
        dataIndex: 'guestAlertDataIndex'
    	},{
    	type: 'string',
        dataIndex: 'mobileDataIndex'
    	},{
    	type: 'string',
        dataIndex: 'emailDataIndex'
    	},
    	{
    	type: 'string',
        dataIndex: 'insertedByDataIndex'
    	},{
    	type: 'date',
        dataIndex: 'insertedTimeDataIndex'
    	},{
    	type:'string',
    	dataIndex:'tripTypeDataIndex'
    	},{
    	type:'string',
    	dataIndex:'daysDataIndex'
    	},{
    	type:'string',
    	dataIndex:'autoDataIndex'
    	},{
    	type:'string',
    	dataIndex:'statusDataIndex'
    	},{
    	type:'string',
    	dataIndex:'superMobileNoIndex'
    	},{
    	type:'string',
    	dataIndex:'superEmailIdDataIndex'
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
        	header: "<span style=font-weight:bold;><%=SLNO%>an>",
        	filter: {
            type: 'numeric'
        	}
    		},{
        	dataIndex: 'uniqueIdIndex',
        	hidden: true,
        	header: "<span style=font-weight:bold;><%=Unique_Id%></span>",
        	filter: {
            type: 'numeric'
        	}
    		},{
        	header: "<span style=font-weight:bold;><%=Route_Name%></span>",
        	dataIndex: 'routeNameDataIndex',
        	filter: {
            type: 'string'
        	}
        	
    		}, {
        	header: "<span style=font-weight:bold;><%=Return_Route_Name%></span>",
        	dataIndex: 'returnrouteNameDataIndex',
        	hidden:true,
        	filter: {
            type: 'string'
        	}
        	
    		}, {
        	header: "<span style=font-weight:bold;><%=Assign_To%></span>",
        	dataIndex: 'assignToDataIndex',
        	hidden :true,
        	filter: {
            type: 'string'
        	}
        	
    		},  {
        	header: "<span style=font-weight:bold;><%=Group_Name%></span>",
        	dataIndex: 'groupNameDataIndex',
        	filter: {
            type: 'string'
        	}
    		},{header: "<span style=font-weight:bold;><%=Group_Id%></span>",
        	dataIndex: 'groupIdDataIndex',
        	hidden:true,
        	filter: {
            type: 'int'
        	}},{
    		header: "<span style=font-weight:bold;><%=Vehicle_No%></span>",
    		dataIndex: 'vehicleDataIndex',
    		sortable: true,		
    		filter: {
    		type: 'string'
    		}
    		},{
    		header: "<span style=font-weight:bold;><%=Unique_Id%></span>",
    		dataIndex: 'uniqueNoDataIndex',
    		sortable: true,		
    		hidden :true,
    		filter: {
    		type: 'string'
    		}
    		},{
        	header: "<span style=font-weight:bold;><%=Guest_Alert%></span>",
        	dataIndex: 'guestAlertDataIndex',
        	hidden:true,
        	filter: {
            type: 'string'
        	}
        	
    		}, {
        	header: "<span style=font-weight:bold;><%=Mobile_No%></span>",
        	dataIndex: 'mobileDataIndex',
        	hidden:true,
        	filter: {
            type: 'string'
        	}
        	
    		}, {
        	header: "<span style=font-weight:bold;><%=Email_Id%></span>",
        	dataIndex: 'emailDataIndex',
        	hidden:true,
        	filter: {
            type: 'string'
        	}
        	
    		}, {
    		header: "<span style=font-weight:bold;><%=Inserted_By%></span>",
    		dataIndex: 'insertedByDataIndex',
    		sortable: true,		
    		filter: {
    		type: 'string'
    		}
    		},{
    		header: "<span style=font-weight:bold;><%=Inserted_Time%></span>",
    		dataIndex: 'insertedTimeDataIndex',
    		renderer:Ext.util.Format.dateRenderer(getDateTimeFormat()),
    		sortable: true,		
    		filter: {
    		type: 'date'
    		}
    		},{
    		header: "<span style=font-weight:bold;><%=Trip_Type%></span>",
    		dataIndex: 'tripTypeDataIndex',
    		sortable: true,	
    		hidden: true,	
    		filter: {
    		type: 'string'
    		}
    		},{
    		header: "<span style=font-weight:bold;><%=Days%></span>",
    		dataIndex: 'daysDataIndex',
    		hidden: true,
    		sortable: true,		
    		filter: {
    		type: 'string'
    		}
    		},{
    		header: "<span style=font-weight:bold;><%=Auto_Cancle_Days%></span>",
    		dataIndex: 'autoDataIndex',
    		hidden: true,
    		sortable: true,		
    		filter: {
    		type: 'string'
    		}
    		},{
    		header: "<span style=font-weight:bold;><%=Status%></span>",
    		dataIndex: 'statusDataIndex',
    		sortable: true,		
    		filter: {
    		type: 'string'
    		}
    		},
    		{
    		header: "<span style=font-weight:bold;>Supervisor Mobile NO</span>",
    		dataIndex: 'superMobileNoIndex',
    		sortable: true,		
    		hidden:true,
    		filter: {
    		type: 'string'
    		}
    		},
    		{
    		header: "<span style=font-weight:bold;>Supervisor Email Id</span>",
    		dataIndex: 'superEmailIdDataIndex',
    		sortable: true,	
    		hidden:true,	
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

    
      
     var store = new Ext.data.GroupingStore({
     	proxy: new Ext.data.HttpProxy({
        url: '<%=request.getContextPath()%>/CreateTripAction.do?param=getTripDetails',
        method: 'POST'
        }),
        reader: gridreader,
        autoLoad: false,
        remoteSort: false
     });
                    
    var addTripInnerPanel = new Ext.form.FormPanel({
    standardSubmit: true,
    collapsible: false,
    //autoScroll: true,
    frame: false,
    id: 'OwnerDetailsId',
    items: [{
        xtype: 'fieldset',
       // cls:'fieldsetpanel',
       width:740,
       //height:400,
        title: 'Add Trip details',
        id:'addTrippanelId',
        collapsible: false,
        layout: 'table',
        layoutConfig: {
            columns: 10
        },
        items: [{
                xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                id: 'mandatoryRouteNameLabel'
            },{
                xtype: 'label',
                text: '*',
                cls: 'mandatoryfield',
                id: 'mandatoryRouteNameLabelId'
            },{
                xtype: 'label',
                text: '<%=Route_Name%>'+'  :',
                cls: 'labelstyle',
                id: 'routeNameLabelId'
            },{width:10},routeCombo,{width:10},{width:10},{width:10},{width:10},{width:10}
            ,{
                xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                id: 'mandatoryReturnTripLabel'
            },{
                xtype: 'label',
                text: '*',
                cls: 'mandatoryfield',
                id: 'mandatoryReturntripLabelId'
            },{
                xtype: 'label',
                text: '<%=Return_Trip%>'+'  :',
                cls: 'labelstyle',
                id: 'ReturntripLabelId'
            },{width:10},returnTripCombo
            ,{
                xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                id: 'mandatoryReturnRouteNameLabel',
             //   hidden: true
            },{
                xtype: 'label',
                text: '*',
                cls: 'mandatoryfield',
                id: 'mandatoryReturnRouteName',
                //hidden: true
            }, {
                xtype: 'label',
                text: '<%=Return_Route_Name%>'+'  :',
                cls: 'labelstyle',
                id: 'ReturnRouteNameLabelId',
               // hidden: true
            },{width:10},ReturnRouteCombo,{
                xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                id: 'mandatoryAssignToLabelId'
            },{
                xtype: 'label',
                text: '*',
                cls: 'mandatoryfield',
                id: 'mandatoryAssignTo'
            }, {
                xtype: 'label',
                text: '<%=Assign_To%>' +' :',
                cls: 'labelstyle',
                id: 'assignToLabelId'
            },{width:10},AssignToCombo,{width:10},{width:10},{width:10},{width:10},{width:10},{
                xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                id: 'mandatoryGroupNamelabel',
                hidden: true
            },{
                xtype: 'label',
                text: '*',
                cls: 'mandatoryfield',
                id: 'mandatoryGroupNameLabelId',
               // hidden:true
            }, {
                xtype: 'label',
                text: '<%=Group_Name%>' +' :',
                cls: 'labelstyle',
                id: 'groupNameLabelId',
               // hidden: true
            },{width:10},groupGrid,{width:10},{width:10},{width:10},{width:10},{width:10},{
                xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                id: 'mandatoryVehicleNoLabel'
                
            },{
                xtype: 'label',
                text: '*',
                cls: 'mandatoryfield',
                id: 'mandatoryvehicleNoLabelId'
              
            }, {
                xtype: 'label',
                text: '<%=Vehicle_No%>'+'  :',
                cls: 'labelstyle',
                id: 'vehicleNoLabelId'
               
            },{width:10},vehicleGrid,{width:20},{width:10},{width:10},{width:10},{width:10},
            {
                xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                id: 'mandatorymodifyGroupLabel'
            },{
                xtype: 'label',
                text: '*',
                cls: 'mandatoryfield',
                id: 'mandatorymodifyGroupLabelId'
            }, {
                xtype: 'label',
                text: '<%=Group_Name%>'+'  :',
                cls: 'labelstyle',
                id: 'groupmodifyLabelId'
            },{width:10},groupGridForModify,{width:20},{width:10},{width:10},{width:10},{width:10},{
                xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                id: 'mandatorymodifyVehicleNoLabel'
            },{
                xtype: 'label',
                text: '*',
                cls: 'mandatoryfield',
                id: 'mandatorymodifyvehicleNoLabelId'
            }, {
                xtype: 'label',
                text: '<%=Vehicle_No%>'+'  :',
                cls: 'labelstyle',
                id: 'vehicleNomodifyLabelId'
            },{width:10},vehicleGridForModify,{width:20},{width:10},{width:10},{width:10},{width:10},{
                xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                id: 'mandatoryAlertNameLabel'
                
            },{
                xtype: 'label',
                text: '*',
                cls: 'mandatoryfield',
                id: 'mandatoryalertnameLabelId'
              
            }, {
                xtype: 'label',
                text: 'Alert Name'+'  :',
                cls: 'labelstyle',
                id: 'alertnameId'
               
            },{width:10},alertGrid,{width:10},{width:10},{width:10},{width:10},{width:10},{
                xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                id: 'mandatoryAlertNameLabelmodify'
                
            },{
                xtype: 'label',
                text: '*',
                cls: 'mandatoryfield',
                id: 'mandatoryalertnameLabelIdmodify'
              
            }, {
                xtype: 'label',
                text: 'Alert Name'+'  :',
                cls: 'labelstyle',
                id: 'alertnamemodifyId'
               
            },{width:10},alertnameGridForModify,{width:10},{width:10},{width:10},{width:10},{width:10},{
                xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                id: 'mandatoryGuestAlertLabel'
            },{width:10},{width:10},{width:10},{width:10},{width:10},{width:10},{width:10},{width:10},{width:10},
            {
                xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                id: 'superMobileLabel'
            },{
                xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                id: 'superMobileLabelId'
            }, {
                xtype: 'label',
                text: 'Supervisor Mobile No' +' :',
                cls: 'labelstyle',
                id: 'supermobileLabelId'
            },{width:10},{
            xtype: 'textfield',
            cls: 'selectstylePerfect',
            allowBlank: false,
            blankText: '<%=Enter_Mobile_No%>',
            emptyText: '<%=Enter_Mobile_No%>',
          //  regex:validate('phone'),
            labelSeparator: '',
            id: 'supermobileNoId',
           	maxLength : 12
        },{width:10},{width:10},{width:10},{width:10},{width:10},{
                xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                id: 'superEmailIdLable'
            },{
                xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                id: 'superEmailId'
            }, {
                xtype: 'label',
                text: 'Supervisor Email Id'+'  :',
                cls: 'labelstyle',
                id: 'superemailLabelId'
            },{width:10},{
             xtype: 'textfield',
            cls: 'selectstylePerfect',
            allowBlank: false,
            //vtype: 'email',
            blankText: 'Enter_Email_Id',
            emptyText: 'Enter Email Id',
            labelSeparator: '',
            id: 'superemailId',
            },{width:10},{width:10},{width:10},{width:10},{width:10},
            {width:10},{
                xtype: 'label',
                text: '*',
                cls: 'mandatoryfield',
                id: 'mandatoryGuestAlertLabelId'
            }, {
                xtype: 'label',
                text: '<%=Guest_Alert%>' +' :',
                cls: 'labelstyle',
                id: 'guestAlertLabelId'
            },{width:10},GuestAlertCombo,{width:10},{width:10},{width:10},{width:10},{width:10},
            {
                xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                id: 'mandatoryMobileLabel'
            },{
                xtype: 'label',
                text: '*',
                cls: 'mandatoryfield',
                id: 'mandatoryMobileLabelId'
            }, {
                xtype: 'label',
                text: '<%=Mobile_No%>' +' :',
                cls: 'labelstyle',
                id: 'mobileLabelId'
            },{width:10},{
            xtype: 'textfield',
            cls: 'selectstylePerfect',
            allowBlank: false,
            blankText: '<%=Enter_Mobile_No%>',
            emptyText: '<%=Enter_Mobile_No%>',
          //  regex:validate('phone'),
            labelSeparator: '',
            id: 'mobileNoId',
           	maxLength : 12
        },{width:10},{width:10},{width:10},{width:10},{width:10},{
                xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                id: 'mandatoryEmailIdLable'
            },{
                xtype: 'label',
                text: '*',
                cls: 'mandatoryfield',
                id: 'mandatoryEmailId'
            }, {
                xtype: 'label',
                text: '<%=Email_Id%>'+'  :',
                cls: 'labelstyle',
                id: 'emailLabelId'
            },{width:10},{
             xtype: 'textfield',
            cls: 'selectstylePerfect',
            allowBlank: false,
            //vtype: 'email',
            blankText: 'Enter_Email_Id',
            emptyText: 'Enter Email Id',
            labelSeparator: '',
            id: 'emailId',
            },{width:10},{width:10},{width:10},{width:10},{width:10},
            {
                xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                id: 'mandatorytripTypeLabel'
            },{
                xtype: 'label',
                text: '*',
                cls: 'mandatoryfield',
                id: 'mandatoryTriptype'
            },{
                xtype: 'label',
                text: '<%=Trip_Type%>'  +' :',
                cls: 'labelstyle',
                id: 'tripTypeLabelId'
                
            } ,{width:10},tripTypeCombo,{width:10},{width:10},{width:10},{width:10},{width:10},
            {
            	xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                id: 'mandatoryNoofDaysLabel'
            },{
                xtype: 'label',
                text: '*',
                cls: 'mandatoryfield',
                id: 'mandatoryNoofdaysLabelId'
            }, {
                xtype: 'label',
                text: '<%=No_Of_Days%>' +' :',
                cls: 'labelstyle',
                id: 'noofdaysLabelId'
            },{width:10},{
            xtype: 'numberfield',
            cls: 'selectstylePerfect',
            allowBlank: false,
            blankText: '<%=Enter_No_Of_Days%>',
            emptyText: '<%=Enter_No_Of_Days%>',
            labelSeparator: '',
            id: 'daysId',
        },{width:10},{width:10},{width:10},{width:10},{width:10},
        {
            	xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                id: 'mandatoryAutoLabel',
              
            },{
                xtype: 'label',
                text: '*',
                cls: 'mandatoryfield',
                id: 'mandatoryAutoLabelId',
               
            }, {
                xtype: 'label',
                text: '<%=Auto_Cancle_Days%>' +' :',
                cls: 'labelstyle',
                id: 'autoLabelId',
               
            },{width:10},{
            xtype: 'numberfield',
            cls: 'selectstylePerfect',
            allowBlank: false,
            blankText: '<%=Enter_Auto_Cancel_Days%>',
            emptyText: '<%=Enter_Auto_Cancel_Days%>',
            labelSeparator: '',
            id: 'autodaysId',
         
        },{width:10},{width:10},{width:10},{width:10},{width:10},
            {
                xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                id: 'mandatoryStatusLabel'
            },{
                xtype: 'label',
                text: '*',
                cls: 'mandatoryfield',
                id: 'mandatoryStatus'
            },{
                xtype: 'label',
                text: '<%=Status%>'  +' :',
                cls: 'labelstyle',
                id: 'statusLabelId'
                
            } ,{width:10},statusCombo
            ]
		 }]
});	
     
     
    var closeTripInnerPanel = new Ext.form.FormPanel({
    standardSubmit: true,
    collapsible: false,
    //autoScroll: true,
    frame: false,
    id: 'closetrip',
    
    items: [{
        xtype: 'fieldset',
       // cls:'fieldsetpanel',
       width:295,
       //height:400,
        title: '<%=Close_Trip_Details%>',
        id:'closeTripfieldset',
        collapsible: false,
        layout: 'table',
        layoutConfig: {
            columns: 6
        },
        items: [{
                xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                id: 'mandatorycloseTripLabel'
            },{
                xtype: 'label',
                text: '*',
                cls: 'mandatoryfield',
                id: 'mandatorycloseTripLabelId'
            },{
                xtype: 'label',
                text: '<%=Remarks%>'+'  :',
                cls: 'labelstyle',
                id: 'remarkLabelId'
            },{width:10},{
                xtype: 'textfield',
                cls:'selectstylePerfect',  
                autoCreate: { //restricts 
                       tag: "input",
                       maxlength: 100,
                       type: "numeric",
                       size: "200",
                       autocomplete: "off"
                   },
                id: 'remark',
                emptyText: '<%=Enter_Remarks%>',
                blankText: '<%=Enter_Remarks%>',
            }
            ]
		 }]
});	
     
     
     
      var caseInnerPanel = new Ext.Panel({
       standardSubmit: true,
       collapsible: false,
       autoScroll: true,
       width: 790,
       height: 410,
       frame: true,
       id: 'addCaseInfo',
       items: [addTripInnerPanel]
   });
     
                
     var closeTripPanel = new Ext.Panel({
       standardSubmit: true,
       collapsible: false,
       autoScroll: true,
       width: 371,
       height: 150,
       frame: true,
       id: 'closeTripPanel1',
       items: [closeTripInnerPanel]
   });
   
   var winButtonPanel = new Ext.Panel({
    id: 'winbuttonid',
    standardSubmit: true,
    collapsible: false,
    height:8,
    cls: 'windowbuttonpanel',
    frame: true,
    layout:'table',
	layoutConfig: {
			columns:4
		},
		  buttons: [{
 	        xtype: 'button',
 	         text: '<%=Save%>',
       		 id: 'addButtId',
        	 cls: 'buttonstyle',
             iconCls : 'savebutton',
             width: 80,
             listeners: {
            click: {
                fn: function () {
                	 if (Ext.getCmp('routenamecomboId').getValue() == "") {
                        Ext.example.msg("<%=Please_Select_Route%>");
                        return;
                    }
                  
                    if(Ext.getCmp('returnTripComboId').getValue() == 'Yes')
                    {
                    	if (Ext.getCmp('returnroutenamecomboId').getValue() == "") {
                        Ext.example.msg("Please Select return route");
                        return;
                    	}
                    }
                    
                    var selectedGroup="";
                    var selectedVehicles="";
                    var selectedGroupId="";
                    
                    if(buttonValue=="add"){
                    if(Ext.getCmp('assignToComboId').getValue() == 'Group'){
                    var groupSelect;
                    selectedGroup = "-";
                    
                    var recordGroup = groupGrid.getSelectionModel().getSelections();
                     
                    for (var i = 0; i < recordGroup.length; i++) {
                        var recordEach = recordGroup[i];
                        var groupName = recordEach.data['groupName'];
                        var groupId=recordEach.data['groupId'];
                        if(selectedGroup == "-"){
                        selectedGroup = groupId;
                        }else{
                        selectedGroup = selectedGroup + "," + groupId
                        }
                    }
                     if (selectedGroup == '' || selectedGroup == '0' || selectedGroup == '-') {
                        Ext.example.msg("<%=Select_Group%>");
                        return;
                    }
                    }else{
                 
                    
                    var vehicleSelect;
                    selectedVehicles = "-";
                    selectedGroupId="-";
                    var recordVehicles = vehicleGrid.getSelectionModel().getSelections();
                     
                    for (var i = 0; i < recordVehicles.length; i++) {
                        var recordEach = recordVehicles[i];
                        var vehicleName = recordEach.data['vehicleName'];
                        var groupId=recordEach.data['groupId'];
                        if (selectedVehicles == "-") {
                            selectedVehicles = vehicleName;
                        } else {
                            selectedVehicles = selectedVehicles + "," + vehicleName;
                        }
                        if(selectedGroupId == "-"){
                        selectedGroupId = groupId;
                        }else{
                        selectedGroupId = selectedGroupId + "," + groupId
                        }
                    }
                    if (selectedVehicles == '' || selectedVehicles == '0' || selectedVehicles == '-') {
                        Ext.example.msg("<%=Select_Vehicle%>");
                        return;
                    }
                 }
                    }
                    var selectedAlert="";
                    if(buttonValue=="add"){   
                     selectedAlert="-";
                     var recordAlert = alertGrid.getSelectionModel().getSelections();
                    for (var i = 0; i < recordAlert.length; i++) {
                        var recordEach = recordAlert[i];
                        var alertName = recordEach.data['alertName'];
                        var alertId=recordEach.data['alertId'];
                        if(selectedAlert== "-"){
                        selectedAlert = alertId;
                        }else{
                        selectedAlert = selectedAlert + "," + alertId
                        }
                    }
                     if (selectedAlert == '' || selectedAlert == '0' || selectedAlert == '-') {
                        Ext.example.msg("Select Alert Name");
                        return;
                    }
					}
                    if(Ext.getCmp('guestalertComboId').getValue()=='Yes'){
                    	if (Ext.getCmp('mobileNoId').getValue() == "") {
                        Ext.example.msg("<%=Enter_Mobile_No%>");
                        return;
                        }
                        if (Ext.getCmp('emailId').getValue() == "") {
                        Ext.example.msg("<%=Enter_Email_Id%>");
                        return;
                    	}
                    	
                    	//var pattern = /^[a-zA-Z0-9\-_]+(\.[a-zA-Z0-9\-_]+)*@[a-z0-9]+(\-[a-z0-9]+)*(\.[a-z0-9]+(\-[a-z0-9]+)*)*\.[a-z]{2,4}$/;
                    	
                    	//if(!pattern.test(Ext.getCmp('emailId').getValue())){
                    	//Ext.example.msg("<%=Enter_Valid_Email_Id%>");
                        //return;
                    	//}
                    	//var mobilePattern=/^[0-9]{1,10}$/;
                    	
                    	//if(!mobilePattern.test(Ext.getCmp('mobileNoId').getValue())){
                    	//Ext.example.msg("<%=Enter_Valid_Mobile_Number%>");
                        //return;
                    	//}

                    }
                   
                    
                    if(buttonValue=="add"){
                    if(Ext.getCmp('daysId').getValue()==""){
                    	Ext.example.msg("<%=Enter_No_Of_Days%>");
                        return;
                    }
                    
                    if(Ext.getCmp('autodaysId').getValue()==""){
                    	Ext.example.msg("<%=Enter_Auto_Cancel_Days%>");
                        return;
                    }
                    }
                    
                    
                    var selected = Grid.getSelectionModel().getSelected();
                    
                    if(buttonValue=='add'){
                    var uniqueNo='';
                    }else{
                    uniqueNo=selected.get('uniqueNoDataIndex');
                    }
						 loadMask.show();
                        Ext.Ajax.request({
                            url: '<%=request.getContextPath()%>/CreateTripAction.do?param=createTripAddAndModify',
                            method: 'POST',
                            params: {
                                buttonValue: buttonValue,
                                custId: Ext.getCmp('custcomboId').getValue(),
                                routeName: Ext.getCmp('routenamecomboId').getValue(),
                                returnRouteName: Ext.getCmp('returnroutenamecomboId').getValue(),
                                assignTo: Ext.getCmp('assignToComboId').getValue(),
                                groupName: selectedGroup,
                                groupId:selectedGroupId,
                                vehicleNo: selectedVehicles,
                                guestAlert: Ext.getCmp('guestalertComboId').getValue(),
                                mobileNo: Ext.getCmp('mobileNoId').getValue(),
                                emailId: Ext.getCmp('emailId').getValue(),
                                superMobileNo: Ext.getCmp('supermobileNoId').getValue(),
                                superEmailId: Ext.getCmp('superemailId').getValue(),
                                status: Ext.getCmp('statusComboId').getValue(),
                                uniqueNo: uniqueNo,
                                tripType:Ext.getCmp('tripTypeComboId').getValue(),
                                days: Ext.getCmp('daysId').getValue(),
                                auto: Ext.getCmp('autodaysId').getValue(),
                                alertname: selectedAlert
                            },
                            success: function(response, options) {
                                var message = response.responseText;
                                Ext.example.msg(message);
                                loadMask.hide();
                                myWin.hide();
                                store.load({
                                    params: {
                                    	startdate: Ext.getCmp('startdateId').getValue(),
                        				enddate: Ext.getCmp('enddateId').getValue(),
                                        CustId: Ext.getCmp('custcomboId').getValue()
                                    }
                                });
                                Ext.getCmp('routenamecomboId').reset();
                                Ext.getCmp('returnTripComboId').reset();
                                Ext.getCmp('returnroutenamecomboId').reset();
                                Ext.getCmp('assignToComboId').reset();
                                Ext.getCmp('groupnamecomboId').reset();
                                vehiclecombostore.load({
                                    params: {}
                                });
                                groupcombostore.load({
               					 param:{
                					}
               					 });
               					alertcombostore.load();
                                Ext.getCmp('guestalertComboId').reset();
                                Ext.getCmp('mobileNoId').reset();
                                Ext.getCmp('emailId').reset();
                                Ext.getCmp('statusComboId').reset();
                                Ext.getCmp('mandatoryGroupNamelabel').show();
           						Ext.getCmp('mandatoryGroupNameLabelId').show();
           						Ext.getCmp('groupNameLabelId').show();
           						Ext.getCmp('returnroutenamecomboId').show();
				           		Ext.getCmp('mandatoryReturnRouteNameLabel').show();
				           		Ext.getCmp('mandatoryReturnRouteName').show();
				           		Ext.getCmp('ReturnRouteNameLabelId').show();
						        Ext.getCmp('vehicleGridId').hide();
     							Ext.getCmp('mandatoryVehicleNoLabel').hide();
     							Ext.getCmp('mandatoryvehicleNoLabelId').hide();
     							Ext.getCmp('vehicleNoLabelId').hide();  
                                Ext.getCmp('tripTypeComboId').reset(),
                                Ext.getCmp('daysId').reset(),
                                Ext.getCmp('autodaysId').reset(),
                                Ext.getCmp('alertGridId').reset(),
                                Ext.getCmp('supermobileNoId').reset(),
                                Ext.getCmp('superemailId').reset()
                                
                 
                            },
                            failure: function() {
                                Ext.example.msg("<%=Error%>");
                                loadMask.hide();
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
           iconCls : 'cancelbutton',
           width: '80',
           listeners: {
            click: {
                fn: function () {
                  Ext.getCmp('returnTripComboId').setValue('Yes');
                  Ext.getCmp('statusComboId').setValue('Active');
                  Ext.getCmp('guestalertComboId').setValue('Yes');
                  Ext.getCmp('tripTypeComboId').setValue('Single');
                  Ext.getCmp('assignToComboId').setValue('Group');
                vehiclecombostore.load({
                param:{
                }
                });
                
                groupcombostore.load({
                param:{
                }
                });
              
                 myWin.hide();
                }
            }
        }
 	    }]
});
   
     var winButtonPanelForCloseTrip = new Ext.Panel({
    id: 'winbuttonid12',
    standardSubmit: true,
    collapsible: false,
    height:8,
    cls: 'windowbuttonpanel',
    frame: true,
    layout:'table',
	layoutConfig: {
			columns:4
		},
		  buttons: [{
 	        xtype: 'button',
 	         text: '<%=Cancel_Trip%>',
       		 id: 'cancelTripId1',
        	 cls: 'buttonstyle',
             iconCls : 'savebutton',
             width: 80,
             listeners: {
            click: {
                fn: function () {
                	 if (Ext.getCmp('remark').getValue() == "") {
                        Ext.example.msg("<%=Enter_Remarks%>");
                        return;
                    }
                   
                     var selected = Grid.getSelectionModel().getSelected();
                   
                        Ext.Ajax.request({
                            url: '<%=request.getContextPath()%>/CreateTripAction.do?param=closeTrip',
                            method: 'POST',
                            params: {
                                remark: Ext.getCmp('remark').getValue(),
                                custId: Ext.getCmp('custcomboId').getValue(),
                                uniqueNo: selected.get('uniqueNoDataIndex'),
                               
                            },
                            success: function(response, options) {
                                var message = response.responseText;
                                Ext.example.msg(message);
                                closetripWin.hide();
                                store.load({
                                    params: {
                                    	startdate: Ext.getCmp('startdateId').getValue(),
                        				enddate: Ext.getCmp('enddateId').getValue(),
                                        CustId: Ext.getCmp('custcomboId').getValue()
                                    }
                                });
                               Ext.getCmp('remark').reset()
                 
                            },
                            failure: function() {
                                Ext.example.msg("<%=Error%>");
                                store.reload();
                                closetripWin.hide();
                            }
                        });
                   
                }
            }
        }
    }, {
 	        xtype: 'button',
 	       text: '<%=Cancel%>',
       	   id: 'cancelButtonId2',
           cls: 'buttonstyle',
           iconCls : 'cancelbutton',
           width: '80',
           listeners: {
            click: {
                fn: function () {
                closetripWin.hide();
             	 Ext.getCmp('remark').reset()
                 
                }
            }
        }
 	    }]
});
        
      var outerPanelWindowForCloseTrip = new Ext.Panel({
   		standardSubmit: true,
   		id:'closewinpanelId1',
    	frame: true,
        height: 250,
        width: 371,  
    	items: [closeTripPanel,winButtonPanelForCloseTrip]
	});
	
	           
     var outerPanelWindow = new Ext.Panel({
   		standardSubmit: true,
   		id:'radiocasewinpanelId',
    	frame: true,
        height: 520,
        width: 800,  
    	items: [caseInnerPanel,winButtonPanel]
	});
      
    closetripWin = new Ext.Window({
    closable: false,
    modal: true,
    resizable: false,
    autoScroll: false,
    height: 300,
    width: 371,
    id: 'closemyWin',
    items: [outerPanelWindowForCloseTrip]
	});
      
                    
    myWin = new Ext.Window({
    closable: false,
    modal: true,
    resizable: false,
    autoScroll: false,
    height: 540,
    width: 810,
    id: 'myWin',
    items: [outerPanelWindow]
	});
	
	function addRecord() {  
    	if (Ext.getCmp('custcomboId').getValue() == "") {
             Ext.example.msg("<%=Please_Select_customer%>");
             Ext.getCmp('custcomboId').focus();
        	 return;
    	}
    	Ext.getCmp('routenamecomboId').setValue('');
    	Ext.getCmp('returnroutenamecomboId').setValue('');
    	Ext.getCmp('mobileNoId').setValue('');
    	Ext.getCmp('emailId').setValue('');
    	Ext.getCmp('superemailId').setValue('');
    	Ext.getCmp('supermobileNoId').setValue('');
   		Ext.getCmp('daysId').setValue('');
   		Ext.getCmp('autodaysId').setValue('') ;
   		Ext.getCmp('statusComboId').setValue('Active');
   		Ext.getCmp('guestalertComboId').setValue('Yes');
    	buttonValue = "add";
    	title = '<%=Add_Trip_Information%>';
    	myWin.setTitle(title);
    	myWin.show(); 
    	
        Ext.getCmp('alertGridId').show();
		Ext.getCmp('mandatoryAlertNameLabel').show();
        Ext.getCmp('mandatoryalertnameLabelId').show();
        Ext.getCmp('alertnameId').show();
        
        Ext.getCmp('alertnameGridIdForModify').hide();
        Ext.getCmp('mandatoryAlertNameLabelmodify').hide();
        Ext.getCmp('mandatoryalertnameLabelIdmodify').hide();
        Ext.getCmp('alertnamemodifyId').hide();
            
		Ext.getCmp('vehicleGridIdForModify').hide();
		Ext.getCmp('mandatorymodifyVehicleNoLabel').hide();
    	Ext.getCmp('mandatorymodifyvehicleNoLabelId').hide();
    	Ext.getCmp('vehicleNomodifyLabelId').hide();
    
    	Ext.getCmp('returnroutenamecomboId').show();
    	Ext.getCmp('mandatoryReturnRouteNameLabel').show();
    	Ext.getCmp('mandatoryReturnRouteName').show();
    	Ext.getCmp('ReturnRouteNameLabelId').show();
    
    	Ext.getCmp('groupGridId').show();
    	Ext.getCmp('mandatoryGroupNamelabel').show();
    	Ext.getCmp('mandatoryGroupNameLabelId').show();
    	Ext.getCmp('groupNameLabelId').show();
    
    	Ext.getCmp('groupGridIdForModify').hide();
    	Ext.getCmp('mandatorymodifyGroupLabel').hide();
    	Ext.getCmp('mandatorymodifyGroupLabelId').hide();
    	Ext.getCmp('groupmodifyLabelId').hide();
            
		Ext.getCmp('routenamecomboId').enable();
    	Ext.getCmp('returnTripComboId').enable();
    	Ext.getCmp('returnroutenamecomboId').enable();
    	Ext.getCmp('assignToComboId').enable();
  
	   Ext.getCmp('tripTypeComboId').enable(),
	   Ext.getCmp('daysId').enable(),
	   Ext.getCmp('autodaysId').enable() 
   
	    Ext.getCmp('mandatoryMobileLabelId').show();
	    Ext.getCmp('mandatoryEmailId').show();
	    Ext.getCmp('emailId').show();
	    Ext.getCmp('mobileNoId').show();
	    Ext.getCmp('mobileLabelId').show();
	    Ext.getCmp('emailLabelId').show();

   groupcombostore.load({
           		params:{
           		clientid:Ext.getCmp('custcomboId').getValue()
           		}
           		});
           		alertcombostore.load();
	}
	
	function modifyData() {
	if (Ext.getCmp('custcomboId').getValue() == "") {
             Ext.example.msg("<%=Please_Select_customer%>");
             Ext.getCmp('custcomboId').focus();
        	 return;
    	}
    	
    if (Grid.getSelectionModel().getCount() == 0) {
        Ext.example.msg("Please select a row");
        return;
    }
    if (Grid.getSelectionModel().getCount() > 1) {
        Ext.example.msg("Please select single row");
        return;
    }
    
    buttonValue = 'Modify';
    titelForInnerPanel = '<%=Modify_Trip_Information%>';
    myWin.setTitle(titelForInnerPanel);
    
    Ext.getCmp('routenamecomboId').disable();
    Ext.getCmp('returnTripComboId').disable();
    Ext.getCmp('returnroutenamecomboId').disable();
    Ext.getCmp('assignToComboId').disable();
   
    Ext.getCmp('tripTypeComboId').disable(),
   	Ext.getCmp('daysId').disable(),
   	Ext.getCmp('autodaysId').disable() 
   			
   var selected = Grid.getSelectionModel().getSelected();
   var selected1=vehicleGrid.getSelectionModel().getSelected();
  	var uniqueNum=selected.get('uniqueNoDataIndex');
  	var groupId=selected.get('groupIdDataIndex');
     if(selected.get('statusDataIndex')=='CLOSED'){
      Ext.example.msg("Trip Already Closed");
      return;
    }     
	Ext.getCmp('routenamecomboId').setValue(selected.get('routeNameDataIndex'));
	
	if(selected.get('returnrouteNameDataIndex')==""){
	Ext.getCmp('returnroutenamecomboId').hide();
	Ext.getCmp('mandatoryReturnRouteNameLabel').hide();
    Ext.getCmp('mandatoryReturnRouteName').hide();
    Ext.getCmp('ReturnRouteNameLabelId').hide();
    Ext.getCmp('returnTripComboId').setValue('No');
	}else{
	Ext.getCmp('returnTripComboId').setValue('Yes');
	Ext.getCmp('returnroutenamecomboId').setValue(selected.get('returnrouteNameDataIndex'));
	}
	alertnamecombostoreForModify.load({
            params: {
			custId:Ext.getCmp('custcomboId').getValue(),
            uniqueId:uniqueNum
            }
            });
	        Ext.getCmp('alertGridId').hide();
			Ext.getCmp('mandatoryAlertNameLabel').hide();
            Ext.getCmp('mandatoryalertnameLabelId').hide();
            Ext.getCmp('alertnameId').hide();
            
            Ext.getCmp('alertnameGridIdForModify').show();
            Ext.getCmp('mandatoryAlertNameLabelmodify').show();
            Ext.getCmp('mandatoryalertnameLabelIdmodify').show();
            Ext.getCmp('alertnamemodifyId').show();
            
			alertnameGridForModify.setDisabled(true);
	
	Ext.getCmp('assignToComboId').setValue(selected.get('assignToDataIndex'));
	 
	 if(selected.get('assignToDataIndex')=="Group"){
	 
			groupcombostoreForModify.load({
			params:{
			custId:Ext.getCmp('custcomboId').getValue(),
  			uniqueId:uniqueNum
  			}
			});
			
			
			Ext.getCmp('groupGridIdForModify').show();
			Ext.getCmp('mandatorymodifyGroupLabel').show();
            Ext.getCmp('mandatorymodifyGroupLabelId').show();
            Ext.getCmp('groupmodifyLabelId').show();
            
            Ext.getCmp('groupGridId').hide();
            Ext.getCmp('mandatoryGroupNamelabel').hide();
            Ext.getCmp('mandatoryGroupNameLabelId').hide();
            Ext.getCmp('groupNameLabelId').hide();
            
            Ext.getCmp('vehicleGridId').hide();
     		Ext.getCmp('mandatoryVehicleNoLabel').hide();
     		Ext.getCmp('mandatoryvehicleNoLabelId').hide();
     		Ext.getCmp('vehicleNoLabelId').hide();  
     		
     		Ext.getCmp('vehicleGridIdForModify').hide();
			Ext.getCmp('mandatorymodifyVehicleNoLabel').hide();
            Ext.getCmp('mandatorymodifyvehicleNoLabelId').hide();
            Ext.getCmp('vehicleNomodifyLabelId').hide();
             
           	groupGridForModify.setDisabled(true);
           	
          
          }  else{
       			vehiclecombostoreForModify.load({
  				params:{
  				custId:Ext.getCmp('custcomboId').getValue(),
  				uniqueId:uniqueNum
 				 }
  			});
  			
  			Ext.getCmp('vehicleGridIdForModify').show();
			Ext.getCmp('mandatorymodifyVehicleNoLabel').show();
            Ext.getCmp('mandatorymodifyvehicleNoLabelId').show();
            Ext.getCmp('vehicleNomodifyLabelId').show();
            
            Ext.getCmp('groupGridId').hide();
            Ext.getCmp('mandatoryGroupNamelabel').hide();
            Ext.getCmp('mandatoryGroupNameLabelId').hide();
            Ext.getCmp('groupNameLabelId').hide();
            
            Ext.getCmp('vehicleGridId').hide();
			Ext.getCmp('mandatoryVehicleNoLabel').hide();
            Ext.getCmp('mandatoryvehicleNoLabelId').hide();
            Ext.getCmp('vehicleNoLabelId').hide();
            
            
            Ext.getCmp('groupGridIdForModify').hide();
			Ext.getCmp('mandatorymodifyGroupLabel').hide();
            Ext.getCmp('mandatorymodifyGroupLabelId').hide();
            Ext.getCmp('groupmodifyLabelId').hide();
            
            vehicleGridForModify.setDisabled(true);
            
         }  
	
	Ext.getCmp('guestalertComboId').setValue(selected.get('guestAlertDataIndex'));
	
	if(Ext.getCmp('guestalertComboId').getValue()=="No"){
	 	   Ext.getCmp('mandatoryMobileLabelId').hide();
           Ext.getCmp('mandatoryEmailId').hide();
           Ext.getCmp('emailId').hide();
           Ext.getCmp('mobileNoId').hide();
           Ext.getCmp('mobileLabelId').hide();
           Ext.getCmp('emailLabelId').hide();
           }else{
	Ext.getCmp('mobileNoId').setValue(selected.get('mobileDataIndex'));
	Ext.getCmp('emailId').setValue(selected.get('emailDataIndex'));
	 Ext.getCmp('mandatoryMobileLabelId').show();
     Ext.getCmp('mandatoryEmailId').show();
     Ext.getCmp('emailId').show();
     Ext.getCmp('mobileNoId').show();
     Ext.getCmp('mobileLabelId').show();
     Ext.getCmp('emailLabelId').show();
	
	}
	Ext.getCmp('tripTypeComboId').setValue(selected.get('tripTypeDataIndex'));
	Ext.getCmp('autodaysId').setValue(selected.get('autoDataIndex'));
	Ext.getCmp('daysId').setValue(selected.get('daysDataIndex'));
	Ext.getCmp('statusComboId').setValue(selected.get('statusDataIndex'));
	Ext.getCmp('supermobileNoId').setValue(selected.get('superMobileNoIndex'));
	Ext.getCmp('superemailId').setValue(selected.get('superEmailIdDataIndex'));
    myWin.show();
   
    

}
    
     var Grid = getGrid('<%=Create_Trip%>', '<%=No_Records_Found%>', store, screen.width - 50, 390, 30, filters, 'Clear Filter Data', false, '', 14, false, '', false, '', false, 'excel', jspName, exportDataType, false, 'PDF', true, 'Add',true,'Modify trip',true,'Close trip');
    
    



function deleteData()
{
if (Ext.getCmp('custcomboId').getValue() == "") {
             Ext.example.msg("<%=Please_Select_customer%>");
             Ext.getCmp('custcomboId').focus();
        	 return;
    	}
    	
    if (Grid.getSelectionModel().getCount() == 0) {
        Ext.example.msg("Please select a row");
        return;
    }
    if (Grid.getSelectionModel().getCount() > 1) {
        Ext.example.msg("Please select single row");
        return;
    }
    if(Grid.getSelectionModel().getSelected().get('statusDataIndex')=='CLOSED'){
      Ext.example.msg("Trip Already Closed");
      return;
    } 
   var titelForcloseTrip = '<%=Close_Trip%>';
    closetripWin.setTitle(titelForcloseTrip);
    closetripWin.show();
    
}
     Ext.onReady(function() {      
         Ext.QuickTips.init();
         Ext.form.Field.prototype.msgTarget = 'side';
         outerPanel = new Ext.Panel({
             title: 'Create Trip',
             renderTo: 'content',
             standardSubmit: true,
             frame: true,
             width: screen.width - 30,
             height: 550,
             cls: 'outerpanel',
             layout: 'table',
             layoutConfig: {
                 columns: 1
             },
             items: [clientPanel,Grid]
         });   
           var cm = Grid.getColumnModel();  
					    for (var j = 1; j < cm.getColumnCount(); j++) {
					       cm.setColumnWidth(j,205);
					    }   
		    Ext.getCmp('vehicleGridId').hide();
     		Ext.getCmp('mandatoryVehicleNoLabel').hide();
     		Ext.getCmp('mandatoryvehicleNoLabelId').hide();
     		Ext.getCmp('vehicleNoLabelId').hide();   
     });
</script>
 <jsp:include page="../Common/footer.jsp" />
 <!-- </body>   -->
 <!-- </html> -->
