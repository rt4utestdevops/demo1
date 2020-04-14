<%@ page language="java"
import="java.util.*,t4u.functions.CommonFunctions,t4u.beans.*,t4u.common.*"
pageEncoding="UTF-8"%>
<%@ taglib uri="http://packtag.sf.net" prefix="pack"%>
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
	int offset = loginInfo.getOffsetMinutes();
	int customerId = loginInfo.getCustomerId();
	int customeridlogged=loginInfo.getCustomerId();
	String customerName1="null";
	if(customeridlogged>0)
	{
	customerName1=cf.getCustomerName(String.valueOf(customeridlogged),systemId);
	}
	ArrayList<String> tobeConverted = new ArrayList<String>();
	
	tobeConverted.add("Select_Customer_Name");
	tobeConverted.add("Customer_Name");
	tobeConverted.add("Start_Date");
	tobeConverted.add("Select_Start_Date");
	tobeConverted.add("End_Date");
	tobeConverted.add("Select_End_Date");
	tobeConverted.add("SLNO");
	tobeConverted.add("Excel");
	tobeConverted.add("PDF");
	tobeConverted.add("Clear_Filter_Data");
	tobeConverted.add("No_Records_Found");
	tobeConverted.add("Please_Select_customer");
	tobeConverted.add("Please_Select_Start_Date");
	tobeConverted.add("Please_Select_End_Date");
	tobeConverted.add("End_Date_Must_Be_Greater_Than_Start_Date");
	tobeConverted.add("Month_Validation");
	tobeConverted.add("Start_Month");
	tobeConverted.add("End_Month");
	
	String clientID=request.getParameter("cutomerID");
	
	ArrayList<String> convertedWords = new ArrayList<String>();
	convertedWords = cf.getLanguageSpecificWordForKey(tobeConverted,language);
	String SelectCustomer=convertedWords.get(0);
	String CustomerName=convertedWords.get(1);
	String StartDate=convertedWords.get(2);
	String SelectStartDate=convertedWords.get(3);
	String EndDate=convertedWords.get(4);
	String SelectEndDate=convertedWords.get(5);
	String SLNO=convertedWords.get(6);
	String Excel=convertedWords.get(7);
	String PDF=convertedWords.get(8);
	String ClearFilterData=convertedWords.get(9);
	String NoRecordsfound=convertedWords.get(10);
	String PleaseSelectCustomer=convertedWords.get(11);
	String PleaseSelectStartDate=convertedWords.get(12);
	String PleaseSelectEndDate=convertedWords.get(13);
	String EndDateMustBeGreaterthanStartDate=convertedWords.get(14);
	String monthValidation=convertedWords.get(15);
	String StartMonthYear =convertedWords.get(16);
	String EndMonthYear =convertedWords.get(17);
	String StaffActivitySummaryReport="Staff Activity Summary Report";//convertedWords.get(40);
	String Group  = "Group";
	String SelectGroup = "Select Group";
	String Date = "Date";
	String PleaseSelectGroup = "Please Select Group";
	String VehicleNo = "Vehicle No";
	String GroupName = "Group Name";
	
	String DaysUsed = "Days used";
	String TripDuration ="Trip Duration";
	String Distance = "Distance";
	String MaxSpeed = "Max Speed";
	String SpeedLimit = "Speed Limit";
	String OSCount = "OS Count";
	String HACount = "HA Count";
	String HBCount = "HB Count";
	String IdleCount = "Idle Count";
	String IdleDuration = "Idle Duration";
	String OsDuration = "OS Duration";
	String TotalDuration = "Total Duration";
	String LastCommTime = "Last Comm Time";
	String LastOdoReading = "Last Odometer Reading";
	String SeatBeltCount = "SeatBelt Count" ;
	
	
	%>
	
	<jsp:include page="../Common/header.jsp" />
			<title><%=StaffActivitySummaryReport%></title>
		
		<style>
		.x-panel-tl {
			border-bottom: 0px solid !important;
		}
		.x-form-invalid-icon {
		    left: 170px;
		    top: 0px;
		    visibility: visible;
		}
		
		</style>
		
			<%if (loginInfo.getStyleSheetOverride().equals("Y")){%>
			<jsp:include page="../Common/ImportJSSandMining.jsp" />
			<%}else {%>
			<jsp:include page="../Common/ImportJS.jsp" />
			<%} %>
			<jsp:include page="../Common/ExportJS.jsp" />
			<style>
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
		.x-window-tl *.x-window-header {
			padding-top : 6px !important;
		}
		.footer {
			bottom : -22px !important;
		}
			</style>
	
	<script>
	 	Ext.Ajax.timeout = 360000;
	    var dt;
	    var dt1 = dateprev; 
	    dt = dt1; // -1 day from current day  
	    var outerPanel;
	    var dtprev = dt;
	    var prevmonth = new Date().add(Date.MONTH, -1);
	    var currmonth = new Date();
	    var nextDaate = new Date().add(Date.DAY, 1);
	    var datecurEnd = new Date();
	    var  datecurSatrt = new Date();
	    datecurSatrt = datecurSatrt.format('d-m-Y')+" 00:00:00";
	    var jspName = '<%=StaffActivitySummaryReport%>';
	    var reportName = '<%=StaffActivitySummaryReport%>';
	    var exportDataType = "int,string,number,string,number,number,number,number,number,number,number,number,string,numeric,string,date,number";
	    var startDate = "";
	    var endDate = "";
	    var newDate = new Date().add(Date.DAY, -1);
	    var grid;  
	    var buttonClick = ''; 
	   
	   function dateCompare2(fromDate, toDate) {
			if(fromDate < toDate) {
				return 1;
			} else if(toDate < fromDate) {
				return -1;
			}
			return 0;
		}  
	 
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
	                  GroupComboStore.load({
	                  params:{
	                  clientId : Ext.getCmp('custcomboId').getValue()
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
	        emptyText: '<%=SelectCustomer%>',
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
	                    Ext.getCmp('GroupNameComboId').reset();
	                  GroupComboStore.load({
	                  params:{
	                  clientId : Ext.getCmp('custcomboId').getValue()
	                  }
	                  });
	                }
	            }
	        }
	    });
	  var GroupComboStore = new Ext.data.JsonStore({
	    url: '<%=request.getContextPath()%>/StaffActivitySummaryAction.do?param=getVehicleGroup',
	    id: 'GroupComboStoreId',
	    root: 'GroupStoreRootUser',
	    autoLoad: false,
	    remoteSort: true,
	    fields: ['GroupId','GroupName']
	});
	
	GroupNameCombo = new Ext.form.ComboBox({
	    store: GroupComboStore,
	    id: 'GroupNameComboId',
	    mode: 'local',
	    forceSelection: true,
	    emptyText: '<%=SelectGroup%>',
	    blankText: '<%=SelectGroup%>',
	    selectOnFocus: true,
	    allowBlank: false,
	    anyMatch: true,
	    typeAhead: false,
	    triggerAction: 'all',
	    lazyRender: true,
	    valueField: 'GroupId',
	    displayField: 'GroupName',
	    cls: 'selectstylePerfect',
	    listeners: {
	        select: {
	            fn: function() {
	            
	          	jspName = '<%=StaffActivitySummaryReport%>';
	          	reportName = '<%=StaffActivitySummaryReport%>';
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
	                text: '<%=CustomerName%>' + ' :',
	                cls: 'labelstyle',
	                id: 'custnamelab'
	            },
	            custnamecombo,
				{   xtype: 'label',
	                text: '',
	                cls: 'labelstyle',
	                width:50,
	                id: 'empty1'
				}, {width:20},
	            {
	                xtype: 'label',
	                text: '<%=Group%>' + ' :',
	                cls: 'labelstyle',
	                id: 'assetTypelab'
	            }, 
				GroupNameCombo,
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
	            text: '<%=StartDate%>' + ' :'
	            },  
				{
	            xtype: 'datefield',          
	            emptyText: '<%=SelectStartDate%>',
	            allowBlank: false,
	            blankText: '<%=SelectStartDate%>',
	            id: 'startdate2',        
	            cls: 'selectstyle' ,
	            format: getDateFormat(),
	            value: previousDate, 
	            maxValue: previousDate        
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
	            text: '<%=EndDate%>' + ' :'
	            },  
				{
	            xtype: 'datefield',          
	            emptyText: '<%=SelectEndDate%>',
	            allowBlank: false,
	            blankText: '<%=SelectEndDate%>',
	            id: 'endDatePmr',        
	            cls: 'selectstyle' ,
	            format: getDateFormat(),
	            value:  currentDate, 
	            maxValue: currentDate           
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
                    Ext.example.msg("<%=PleaseSelectCustomer%>");
                    Ext.getCmp('custcomboId').focus();
                    return;
                }
                
	            if (Ext.getCmp('GroupNameComboId').getValue() == "") {
                    Ext.example.msg("<%=SelectGroup%>");
                    Ext.getCmp('GroupNameComboId').focus();
                    return;
                }
                
                 if (dateCompare(Ext.getCmp('startdate2').getValue(), Ext.getCmp('endDatePmr').getValue()) == -1) {
                     Ext.example.msg("<%=EndDateMustBeGreaterthanStartDate%>");
                     Ext.getCmp('endDatePmr').focus();
                     return;
                 }

	            
	            if (checkMonthValidation(Ext.getCmp('startdate2').getValue(), Ext.getCmp('endDatePmr').getValue())) {
                      Ext.example.msg("<%=monthValidation%>");
                      Ext.getCmp('endDatePmr').focus();
                      return;
                }
                
	            store.load({
	                  params:{
	                  CustId : Ext.getCmp('custcomboId').getValue(),
	                  GroupId : Ext.getCmp('GroupNameComboId').getValue(),
	                  Date:Ext.getCmp('startdate2').getValue().format('d-m-Y H:i:s'),
	                  JspName:jspName,
	                  CustName:Ext.getCmp('custcomboId').getRawValue(),
	                  GroupName:Ext.getCmp('GroupNameComboId').getRawValue(),
	                  endDate:Ext.getCmp('endDatePmr').getValue().format('d-m-Y H:i:s')
	                  }
	                  });
	        }
	        }
	        ]
	    });
	
	    var reader = new Ext.data.JsonReader({
	        idProperty: 'ReportId',
	        root: 'ViewRoot',
	        totalProperty: 'total',
	        fields: [{
	            name: 'slnoIndex'
	        }, {
	            name: 'vehicleNoDataIndex'
	        },  {
	            name: 'daysUsedIndex'
	        }, {
	            name: 'tripDurationIndex'
	        },{
	            name: 'distanceIndex'
	        }, {
	            name: 'maxSpeedIndex'
	        }, {
	            name: 'speedLimitIndex'
	        }, {        
	            name: 'OSCountIndex'
	        }, {        
	            name: 'HACountIndex'
	        },{        
	            name: 'HBCountIndex'
	        },{        
	            name: 'IdleCountIndex'
	        },{        
	            name: 'SeatBeltCountIndex'
	        },{        
	            name: 'IdledurationIndex'
	        },{        
	            name: 'OSdurationIndex'
	        },{        
	            name: 'TotaldurationIndex'
	        },{        
	            name: 'LastCommTimeIndex'
	        },{
	            name: 'LastOdometerIndex'
	        }]
	    });
	    
	    var store = new Ext.data.GroupingStore({
	        autoLoad: false,
	        proxy: new Ext.data.HttpProxy({
	            url: '<%=request.getContextPath()%>/StaffActivitySummaryAction.do?param=View',
	            method: 'POST'
	        }),
	        remoteSort: false,
	        storeId: 'ViewRootId',
	        reader: reader
	    });
	    
	    var filters = new Ext.ux.grid.GridFilters({
	        local: true,
	        filters: [{
	       
	         type: 'numeric',
	            dataIndex: 'slnoIndex'
	        }, {
	            type: 'string',
	            dataIndex: 'vehicleNoDataIndex'
	        },  {
	             type: 'numeric',
	            dataIndex: 'daysUsedIndex'
	        }, {
	            type: 'numeric',
	            dataIndex: 'tripDurationIndex'
	        },{
	            type: 'numeric',
	            dataIndex: 'distanceIndex'
	        },{
	             type: 'numeric',
	            dataIndex: 'maxSpeedIndex'
	        },{
	            type: 'numeric',
	            dataIndex: 'speedLimitIndex'
	        }, {
	            type: 'numeric',
	            dataIndex: 'OSCountIndex'
	        }, {
	            type: 'numeric',
	            dataIndex: 'HACountIndex'
	        },{
	            type: 'numeric',
	            dataIndex: 'HBCountIndex'
	        },{
	            type: 'numeric',
	            dataIndex: 'IdleCountIndex'
	        },{
	            type: 'numeric',
	            dataIndex: 'SeatBeltCountIndex'
	        },{
	            type: 'numeric',
	            dataIndex: 'IdledurationIndex'
	        },{
	            type: 'numeric',
	            dataIndex: 'OSdurationIndex'
	        },{
	            type: 'numeric',
	            dataIndex: 'TotaldurationIndex'
	        },{
	            type: 'date',
	            dataIndex: 'LastCommTimeIndex'
	        },{
	            type: 'numeric',
	            dataIndex: 'LastOdometerIndex'
	        }
	       
	        ]
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
	            },
			   {
	                header: "<span style=font-weight:bold;><%=VehicleNo%></span>",
	                dataIndex: 'vehicleNoDataIndex',
	                width: 100,
	                filter: {
	                    type: 'string'
	                }
	            },
			    {
	                header: "<span style=font-weight:bold;><%=DaysUsed%></span>",
	                dataIndex: 'daysUsedIndex',
	                width: 100,                
	                filter: {
	                    type: 'numeric'
	                }
	            },
				{
	                header: "<span style=font-weight:bold;><%=TripDuration%></span>",
	                dataIndex: 'tripDurationIndex',
	                width: 100,
	                filter: {
	                    type: 'numeric'
	                }
	            },{
	                header: "<span style=font-weight:bold;><%=Distance%></span>",
	                dataIndex: 'distanceIndex',
	                width: 100,
	                filter: {
	                    type: 'numeric'
	                }
	            },
				{
	                header: "<span style=font-weight:bold;><%=MaxSpeed%></span>",
	                dataIndex: 'maxSpeedIndex',
	                width: 80,
	                filter: {
	                    type: 'numeric'
	                }
	            },
				{
	                header: "<span style=font-weight:bold;><%=SpeedLimit%></span>",
	                dataIndex: 'speedLimitIndex',
	                width: 100,
	                filter: {
	                    type: 'numeric'
	                }
	            },{
	                header: "<span style=font-weight:bold;><%=OSCount%></span>",
	                dataIndex: 'OSCountIndex',
	                width: 80,
	                filter: {
	                    type: 'numeric'
	                }
	            },{
	                header: "<span style=font-weight:bold;><%=HACount%></span>",
	                dataIndex: 'HACountIndex',
	                width: 80,
	                filter: {
	                    type: 'numeric'
	                }
	            },{
	                header: "<span style=font-weight:bold;><%=HBCount%></span>",
	                dataIndex: 'HBCountIndex',
	                width: 80,
	                filter: {
	                    type: 'numeric'
	                }
	            },{
	                header: "<span style=font-weight:bold;><%=IdleCount%></span>",
	                dataIndex: 'IdleCountIndex',
	                width: 80,
	                filter: {
	                    type: 'numeric'
	                }
	            },{
	                header: "<span style=font-weight:bold;><%=SeatBeltCount%></span>",
	                dataIndex: 'SeatBeltCountIndex',
	                width: 80,
	                filter: {
	                    type: 'numeric'
	                }
	            },
				{
	                header: "<span style=font-weight:bold;><%=IdleDuration%></span>",
	                dataIndex: 'IdledurationIndex',
	                width: 100,
	                filter: {
	                    type: 'numeric'
	                }
	            },
				{
	                header: "<span style=font-weight:bold;><%=OsDuration%></span>",
	                dataIndex: 'OSdurationIndex',
	                width: 100,
	                filter: {
	                    type: 'numeric'
	                }
	            },{
	                header: "<span style=font-weight:bold;><%=TotalDuration%></span>",
	                dataIndex: 'TotaldurationIndex',
	                width: 100,
	                filter: {
	                    type: 'numeric'
	                }
	            },{
	                header: "<span style=font-weight:bold;><%=LastCommTime%></span>",
	                dataIndex: 'LastCommTimeIndex',
	                width: 100,
	                filter: {
	                    type: 'date'
	                }
	            },
	            {
	                header: "<span style=font-weight:bold;><%=LastOdoReading%></span>",
	                dataIndex: 'LastOdometerIndex',
	                width: 100,
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
	    var grid = CustomizedGrid('', '<%=NoRecordsfound%>', store, screen.width - 35, 470, 18, filters, '<%=ClearFilterData%>', false, '', 14, false, '', false, '', true, '<%=Excel%>', jspName, exportDataType, true, '<%=PDF%>');
	 
	 
	   function CustomizedGrid(gridtitle,emptytext,store,width,height,gridnoofcols,filters,filterstr,reconfigure,reconfigurestr,reconfigurenoofcols,group,groupstr,chart,chartstr,excel,excelstr,jspName,exportDataType,pdf,pdfstr,add,addstr,modify,modifystr,del,delstr,closetrip,closestr,verify,verifystr,approve, approvestr,copy, copystr,postpone,postponestr,importExcel,importStr,save,saveStr,clearData,clearStr,close,closeStr){
		 var grid = new Ext.grid.GridPanel({
		    	title:gridtitle,
		        border: false,
		        height: getGridHeight(),
		        autoScroll:true,
		        store: store,
		        id:'grid',
		        colModel: createColModel(gridnoofcols),
		        loadMask: true,
		        view: new Ext.grid.GroupingView({
		        	autoFill:true,
		            groupTextTpl: getGroupConfig(),
		            emptyText: emptytext,deferEmptyText: false
		        }),
		        listeners: {
	                render : function(grid){
	                  grid.store.on('load', function(store, records, options){
	                    grid.getSelectionModel().selectFirstRow();       
	                  });                      
	                }
	               },
		        plugins: [filters],	       
		        bbar: new Ext.Toolbar({
		        })
		    });
		if(width>0){
			grid.setSize(width,height);
		}
		 grid.getBottomToolbar().add([
		        '->',
		        {
		            text: filterstr,
		            iconCls : 'clearfilterbutton',
		            handler: function () {
		        	grid.filters.clearFilters();
		            } 
		        }]);
		if(reconfigure){
			grid.getBottomToolbar().add([
			 '-',                            
				{
	            text: reconfigurestr,
	            handler: function () {
				grid.reconfigure(store, createColModel(reconfigurenoofcols));
	            } 
	        }]);
			}
			if(group){
				grid.getBottomToolbar().add([
				'-',                             
				{
				    text:groupstr,
				    handler : function(){
					store.clearGrouping();
				    }    
				  }]);
			}
			if(add)
			{
				grid.getBottomToolbar().add([
				'-',                             
				{
				    text:addstr,
				    iconCls : 'addbutton',
				    handler : function(){
				    addRecord();
	
				    }    
				  }]);
			}	
			if(modify)
			{
				grid.getBottomToolbar().add([
				'-',                             
				{
				    text:modifystr,
				    iconCls : 'editbutton',
				    id: 'modifyId',
				    handler : function(){
				    modifyData();
	
				    }    
				  }]);
			}	
			if(del)
			{
				grid.getBottomToolbar().add([
				'-',                             
				{
				    text:delstr,
				    iconCls : 'deletebutton',
				    id: 'gridDeleteId',
				    handler : function(){
				    deleteData();
	
				    }    
				  }]);
			}
			if(copy)
			{
				grid.getBottomToolbar().add([
				'-',                             
				{
				    text:copystr,
				    iconCls : 'copybutton',
				    id: 'gridCopyId',
				    handler : function(){
				    copyData();
				   }    
				  }]);
			}	
			if(chart)
			{
				grid.getBottomToolbar().add([
				'-',                             
				{
				    text:chartstr,
				    handler : function(){
					columnchart();
				    }    
				  }]);
			}
			if(excel)
			{
				grid.getBottomToolbar().add([
				{
				    text:'',
				    iconCls : 'excelbutton',
				    handler : function(){
					getordreport('xls','All',jspName,grid,exportDataType);
				    }    
				  }]);
			}
			if(pdf)
			{
				grid.getBottomToolbar().add([
				{
				    text:'',
				    iconCls : 'pdfbutton',
				    handler : function(){
				    getordreport('pdf','All',jspName,grid,exportDataType);
	
				    }    
				  }]);
			}
			if(closetrip)
			{
				grid.getBottomToolbar().add([
				'-',                             
				{
				    text:closestr,
				    iconCls:'closeTripbuttonS',
				    id: 'gridCloseTripId',
				    handler : function(){
					closetripsummary();
				    }    
				  }]);
			}
			if(verify)
			{
				grid.getBottomToolbar().add([
				'-',                             
				{
				    text:verifystr,
				    iconCls:'',
				    id: 'gridVerifyId',
				    handler : function(){
						verifyFunction();
				    }    
				  }]);
			}
			if(approve)
			{
				grid.getBottomToolbar().add([
				'-',                             
				{
				    text:approvestr,
				    iconCls:'',
				    id: 'gridApproveId',
				    handler : function(){
						approveFunction();
				    }    
				  }]);
			}
			if(postpone)
			{
				grid.getBottomToolbar().add([
				'-',                             
				{
				    text:postponestr,
				    iconCls:'postponebutton',
				    id: 'gridPostponeId',
				    handler : function(){
						postponeFunction();
				    }    
				  }]);
			}
			if(importExcel)
			{
				grid.getBottomToolbar().add([
				'-',                             
				{
				    text:importStr,
				    iconCls : 'excelbutton',
				    handler : function(){
				    importExcelData();
	
				    }    
				  }]);
			}
			if(save)
			{
				grid.getBottomToolbar().add([
				'-',                            
				{
				    text:saveStr,
				    iconCls : 'savebutton',
				    handler : function(){
				    saveDate();
	
				    }    
				  }]);
			}
			if(clearData)
			{
				grid.getBottomToolbar().add([
				'-',                            
				{
				    text:clearStr,
				    iconCls : 'clearbutton',
				    handler : function(){
				    clearInputData();
	
				    }    
				  }]);
			}
			if(close)
			{
				grid.getBottomToolbar().add([
				'-',                            
				{
				    text:closeStr,
				    iconCls : 'closebutton',
				    handler : function(){
				    closeImportWin();
	
				    }    
				  }]);
			}
	
		return grid;
	}
	 
	    Ext.onReady(function() {
	        ctsb = tsb;
	        Ext.QuickTips.init();
	        Ext.form.Field.prototype.msgTarget = 'side';
	        outerPanel = new Ext.Panel({
	            title: '<%=StaffActivitySummaryReport%>',
	            renderTo: 'content',
	            standardSubmit: true,
	            frame: true,
	            cls: 'outerpanel',
	            layout: 'table',
	            height: 555,
	            layoutConfig: {
	                columns: 1
	            },
	            items: [clientPanel, grid]
	  
	        });
	        sb = Ext.getCmp('form-statusbar');
			jspName = '<%=StaffActivitySummaryReport%>'; 
			reportName = '<%=StaffActivitySummaryReport%>';
	    });
	 
	</script>
	 <jsp:include page="../Common/footer.jsp" />
 <!-- </body>   -->
 <!-- </html> -->