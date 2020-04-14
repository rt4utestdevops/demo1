<%@ page language="java"
	import="java.util.*,t4u.functions.*,t4u.beans.*,t4u.common.*"
	pageEncoding="utf-8"%>
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
    Calendar cal = Calendar.getInstance();
	int CrntYear = cal.get(Calendar.YEAR);
	int PrevYear = cal.get(Calendar.YEAR)-1;
	    
     
 String SelectCustomer = cf.getLabelFromDB("Select_Customer",language);
 String SLNO = cf.getLabelFromDB("SLNO",language);
 String CustomerName =cf.getLabelFromDB("Customer_Name",language);
 String StartDate = cf.getLabelFromDB("Start_Date",language);
 String EndDate = cf.getLabelFromDB("End_Date",language);
 String SelectEndDate = cf.getLabelFromDB("Select_End_Date",language);
 String NoRecordsfound =  cf.getLabelFromDB("No_Records_Found",language);
 String ClearFilterData = cf.getLabelFromDB("Clear_Filter_Data",language);
 String SelectStartDate =  cf.getLabelFromDB("No_Records_Found",language);
 String EndDateMustBeGreaterthanStartDate = cf.getLabelFromDB("End_Date_Must_Be_Greater_Than_Start_Date",language); 
 String Excel=cf.getLabelFromDB("Excel",language);
 String monthValidation=cf.getLabelFromDB("Month_Validation",language);
 String ticketSold=cf.getLabelFromDB("Ticket_Sold",language);
 String ticketSoldType=cf.getLabelFromDB("Ticket_Sold_Type",language);
 String routeName=cf.getLabelFromDB("Route_Name",language);
 String selectRouteName=cf.getLabelFromDB("Select_Route_Name",language);
 String vehicleNumber=cf.getLabelFromDB("Vehicle_Number",language);
 String selectVehicle=cf.getLabelFromDB("Select_Vehicle_Number",language);
 String termianlName=cf.getLabelFromDB("Terminal_Name",language);
 String selectTerminal=cf.getLabelFromDB("Select_Terminal_Name",language);
 String view=cf.getLabelFromDB("View",language);
 String month=cf.getLabelFromDB("Month",language);
 String selectTicketSoldType=cf.getLabelFromDB("Please_Ticket_Sold_Type",language); 
 String names=cf.getLabelFromDB("Names",language);
 String typeList=cf.getLabelFromDB("Type_List",language);
 String ticketDetails=cf.getLabelFromDB("Ticket_Details",language);
 String Schedule_Date=cf.getLabelFromDB("Schedule_Date",language);
 String Time=cf.getLabelFromDB("Time",language);
 String Vehicle_Type=cf.getLabelFromDB("Vehicle_Type",language);
 String Total_Ticket_Sold=cf.getLabelFromDB("Total_Ticket_Sold",language);
 String Origin=cf.getLabelFromDB("Origin",language);
 String Destination=cf.getLabelFromDB("Destination",language);
 String Duration=cf.getLabelFromDB("Duration",language);
%>

<jsp:include page="../Common/header.jsp" />


    <title>
        <%=ticketDetails %>
    </title>

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
			.ext-strict .x-form-text {
				height : 21px !important;
			}			
			.x-window-tl *.x-window-header {
				padding-top : 6px !important;
			}
		</style>
<script>
                  
                    var manageAllTasksGrid;
                    var dtprev = dateprev;
                    var dtcur = datecur;
                    var jspName = 'Ticket Details';
                    var exportDataType = "int,string,string,string,string,string,string,string,string,string,string,string";
                    var json = "";
                    var gridData = "";
                    var groid = "";
                    var globalType= "";
                    var  globalClientId= "";
                    var selectType = "";
				
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
                    custName = Ext.getCmp('custcomboId').getRawValue();
                    if (<%= customerId %> > 0) {
                        Ext.getCmp('custcomboId').setValue('<%=customerId%>');
                        custId = Ext.getCmp('custcomboId').getValue();
                        custName = Ext.getCmp('custcomboId').getRawValue();
                    }
                }
            }
        }
    });                                     

        
        var ticketSoldStore =new Ext.data.SimpleStore({
        id:'ticketStore',
        autoLoad:true,
        fields:['ticketId','ticketName'],
        data:[
        		['01','By Route'],
        		['02','By Vehicle'],
        		['03','By Terminal']
        ]
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
                text: '<%=CustomerName%>' + ' :',
                cls: 'labelstyle',
                id: 'custnamelab'
            },
            custnamecombo, {
                width: 20
            }, {
                xtype: 'label',
                text: '<%=ticketSold%>' + ' :',
                cls: 'labelstyle',
                id: 'assetTypelab'
            }, {
                xtype: 'combo',
                store: ticketSoldStore,
                frame: true,
                width: 250,
                listWidth: 250,
                forceSelection: true,
                enableKeyEvents: true,
                mode: 'local',
                anyMatch: true,
                onTypeAhead: true,
                emptyText:'<%=ticketSoldType%>',
                id: 'ticketTypeComboId',
                mode: 'local',
                allowBlank: false,
                triggerAction: 'all',
                valueField: 'ticketId',
                displayField: 'ticketName',
                listeners: {
                    select: {
                        fn: function() { 
                        globalClientId=Ext.getCmp('custcomboId').getValue();
                        globalType=Ext.getCmp('ticketTypeComboId').getValue(); 
                         if (Ext.getCmp('custcomboId').getValue() == "") {
				   			 Ext.example.msg("<%=SelectCustomer%>");
				   			 Ext.getCmp('custcomboId').focus();
				   			 Ext.getCmp('ticketTypeComboId').reset();
				    		return;
				    	}
                        if(Ext.getCmp('ticketTypeComboId').getValue()=='01')
		                      {
		                      firstGrid.getColumnModel().setColumnHeader(firstGrid.getColumnModel().findColumnIndex('TypeName'),'<b><%=routeName%></b>');
		                      firstGridStore.load({params: {clientId: globalClientId,globalType:globalType}});
		                      selectType = '<%=selectRouteName%>';
		                      }
		                      if (Ext.getCmp('ticketTypeComboId').getValue()=='02')
		                      {
          		               firstGrid.getColumnModel().setColumnHeader(firstGrid.getColumnModel().findColumnIndex('TypeName'),'<b><%=vehicleNumber%></b>');
          		               firstGridStore.load({params: {clientId: globalClientId,globalType:globalType}});
          		               selectType = '<%=selectVehicle%>';
		                     } 
		                      if (Ext.getCmp('ticketTypeComboId').getValue()=='03')
		                      {
		                     	firstGrid.getColumnModel().setColumnHeader(firstGrid.getColumnModel().findColumnIndex('TypeName'),'<b><%=termianlName%></b>');
		                        firstGridStore.load({params: {clientId: globalClientId,globalType:globalType}});
		                        selectType = '<%=selectTerminal%>';
		                      }                 
                            store.load();
                        }
                         
                    }
                }
            }
        ]
    });
                    
     
      var durationpanel1 = new Ext.Panel({
        standardSubmit: true,
        collapsible: false,
        id: 'durationpanel1Id',
        layout: 'table',
        frame: true,
        hidden: false,
        width: screen.width - 40,
        
        layoutConfig: {
            columns: 10
        },
        items: [{
            xtype: 'label',
            cls: 'labelstyle',
            id: 'startdatelab',
            width: 200,
            text: '<%=StartDate%>' + ' :'
        }, {
            width: 30
        }, {
            xtype: 'datefield',
            cls: 'selectstylePerfect',
            width: 160,
            format: getDateFormat(),
            emptyText: '<%=SelectStartDate%>',
            allowBlank: false,
            blankText: '<%=SelectStartDate%>',
            id: 'startdate',
            value: dtprev,
            endDateField: 'enddate'
        }, {
            width: 20
        }, {
            xtype: 'label',
            cls: 'labelstyle',
            id: 'enddatelab',
            width: 200,
            text: '<%=EndDate%>' + ' :'
        }, {
            width: 10
        }, {
            xtype: 'datefield',
            cls: 'selectstylePerfect',
            width:160,
            format: getDateFormat(),
            emptyText: '<%=SelectEndDate%>',
            allowBlank: false,
            blankText: '<%=SelectEndDate%>',
            id: 'enddate',
            value: datecur,
            startDateField: 'startdate'
        },{width:20},{
	        xtype: 'button',
	        text: '<%=view%>',
	        id: 'submitId',
	        cls: 'buttonStyle',
	        width: 60,
	        handler: function() {
             if (Ext.getCmp('custcomboId').getValue() == "") {
				   			 Ext.example.msg("<%=SelectCustomer%>");
				   			 Ext.getCmp('custcomboId').focus();
				    		return;
				    	}
             		 						
      		 			if(Ext.getCmp('ticketTypeComboId').getValue() == "" ){
         					Ext.example.msg("<%=selectTicketSoldType%>");
				   			Ext.getCmp('ticketTypeComboId').focus();
				    		return;
         		   	 	}
         		   	 	
         		   	 	if (dateCompare(Ext.getCmp('startdate').getValue(), Ext.getCmp('enddate').getValue()) == -1) {
				             Ext.example.msg("<%=EndDateMustBeGreaterthanStartDate%>");
				             Ext.getCmp('enddate').focus();
				             return;
						}
						if (checkMonthValidation(Ext.getCmp('startdate').getValue(), Ext.getCmp('enddate').getValue())) {
		                    Ext.example.msg("<%=monthValidation%>");
		                    Ext.getCmp('enddate').focus();
		                    return;
                		}
                		
                		var records = firstGrid.getSelectionModel().getSelections();
                		if(records==undefined || records=='')
       				    {
  						   Ext.example.msg(selectType);
					       return;
         				}
       						var names="";
       						for (var i = 0, len = records.length; i < len; i++){
	 						var record = records[i];
       						names=names+record.get("TypeName")+",";
       						}
       					
      			  store.load({
       			  params:{
	       			  clientId : globalClientId,
	       			  fromDate:Ext.getCmp('startdate').getValue(),
	       			  endDate:Ext.getCmp('enddate').getValue(),
	       			  names:names,
	       			  typeName : Ext.getCmp('ticketTypeComboId').getValue(),
	       			  jspName :jspName,
	       			  custName :Ext.getCmp('custcomboId').getRawValue()
       			  }});
        }
        }]
    });
    
      var reader1 = new Ext.data.JsonReader({
                        root: 'firstGridRoot',
                        fields: [{
                            name: 'Id'
                        }, {
                            name: 'TypeName',
                            type: 'string'
                        }]
                    });
    
    
      var filters1 = new Ext.ux.grid.GridFilters({
                        local: true,
                        filters: [{
                                dataIndex: 'Id',
                                type: 'string'
                            }, {
                                dataIndex: 'TypeName',
                                type: 'string'
                            }

                        ]
                    });
    
       var sm1 = new Ext.grid.CheckboxSelectionModel({
                        checkOnly: true
                    });
                    
                    
      var cols1 = new Ext.grid.ColumnModel([

          new Ext.grid.RowNumberer({
              header: "<span style=font-weight:bold;><%=SLNO%></span>",
              width: 40
          }), sm1, {
              header: '<b><%=names%></b>',
              width: 155,
              sortable: true,
              dataIndex: 'TypeName'
          }


      ]);
      
      var gridreader = new Ext.data.JsonReader({
        idProperty: 'ticketDetailsId',
    	root: 'ticketDetailsRoot',
    	totalProperty: 'total',
    	fields: [{
        name: 'slnoIndex'
    	},{
        name: 'scheduleDateDataIndex',
        type: 'date'
    	},{
        name: 'monthDataIndex'
    	},{
        name: 'timeDataIndex'
    	},{
        name: 'vehicleNoDataIndex'
    	},{
        name: 'routeNameDataIndex'
    	},{
    	name: 'vehicleTypeDataIndex'
    	},{
        name: 'totalSoldDataIndex'
    	},{
        name: 'terminalDataIndex'
    	},{
        name: 'originDataIndex'
    	},{
        name: 'destinationDataIndex'
    	},{
        name: 'durationDataIndex'
    	}]
    });
      
      var filters = new Ext.ux.grid.GridFilters({
        local: true,
    	filters: [{
        type: 'numeric',
        dataIndex: 'slnoIndex'
    	},{
    	type: 'date',
        dataIndex: 'scheduleDateDataIndex'
    	},{
    	type: 'string',
        dataIndex: 'monthDataIndex'
    	},{
    	type: 'string',
        dataIndex: 'timeDataIndex'
    	},
    	{
    	type: 'string',
        dataIndex: 'vehicleNoDataIndex'
    	},{
    	type: 'string',
        dataIndex: 'routeNameDataIndex'
    	},{
    	type: 'string',
        dataIndex: 'vehicleTypeDataIndex'
    	},{
    	type: 'string',
        dataIndex: 'totalSoldDataIndex'
    	},{
    	type: 'string',
        dataIndex: 'terminalDataIndex'
    	},{
    	type: 'string',
        dataIndex: 'originDataIndex'
    	},{
    	type: 'string',
        dataIndex: 'destinationDataIndex'
    	},{
    	type: 'string',
        dataIndex: 'durationDataIndex'
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
    		},{
        	header: "<span style=font-weight:bold;><%=Schedule_Date%></span>",
        	dataIndex: 'scheduleDateDataIndex',
        	renderer: Ext.util.Format.dateRenderer(getDateFormat()),
        	filter: {
            type: 'date'
        	}
        	
    		}, {
        	header: "<span style=font-weight:bold;><%=month%></span>",
        	dataIndex: 'monthDataIndex',
        	filter: {
            type: 'string'
        	}
    		},{
    		header: "<span style=font-weight:bold;><%=Time%></span>",
    		dataIndex: 'timeDataIndex',
    		sortable: true,		
    		filter: {
    		type: 'string'
    		}
    		},{
    		header: "<span style=font-weight:bold;><%=vehicleNumber%></span>",
    		dataIndex: 'vehicleNoDataIndex',
    		sortable: true,		
    		filter: {
    		type: 'string'
    		}
    		},{
    		header: "<span style=font-weight:bold;><%=routeName%></span>",
    		dataIndex: 'routeNameDataIndex',
    		sortable: true,		
    		filter: {
    		type: 'string'
    		}
    		},{
    		header: "<span style=font-weight:bold;><%=Vehicle_Type%></span>",
    		dataIndex: 'vehicleTypeDataIndex',
    		sortable: true,		
    		filter: {
    		type: 'string'
    		}
    		},{
    		header: "<span style=font-weight:bold;><%=Total_Ticket_Sold%></span>",
    		dataIndex: 'totalSoldDataIndex',
    		sortable: true,		
    		filter: {
    		type: 'string'
    		}
    		},{
    		header: "<span style=font-weight:bold;><%=termianlName%></span>",
    		dataIndex: 'terminalDataIndex',
    		sortable: true,		
    		filter: {
    		type: 'string'
    		}
    		},{
    		header: "<span style=font-weight:bold;><%=Origin%></span>",
    		dataIndex: 'originDataIndex',
    		sortable: true,		
    		filter: {
    		type: 'string'
    		}
    		},{
    		header: "<span style=font-weight:bold;><%=Destination%></span>",
    		dataIndex: 'destinationDataIndex',    		
    		sortable: true,		
    		filter: {
    		type: 'string'
    		}
    		},{
        	header: "<span style=font-weight:bold;><%=Duration%></span>",
        	dataIndex: 'durationDataIndex',        	
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

    
    
    var firstGridStore = new Ext.data.Store({
                        url: '<%=request.getContextPath()%>/TicketDetailsAction.do?param=getTypeForGrid',                     
                        reader: reader1,
                        autoLoad: false,
                        remoteSort: false
                    });
    
     var store = new Ext.data.GroupingStore({
     					proxy: new Ext.data.HttpProxy({
                            url: '<%=request.getContextPath()%>/TicketDetailsAction.do?param=getTicketDetails',
                            method: 'POST'
                        }),  
                        reader: gridreader,
                        autoLoad: false,
                        remoteSort: false
                    });
    
    
     var firstGrid = getSelectionModelGrid('<%=typeList%>', '<%=NoRecordsfound%>', firstGridStore, 250, 390, cols1, 4, filters1, sm1);
     var secondGrid = getGrid('<%=ticketDetails%>', '<%=NoRecordsfound%>', store, screen.width - 290, 390, 15, filters, '<%=ClearFilterData%>', false, '', 14, false, '', false, '', true, '<%=Excel%>', jspName, exportDataType, true, 'PDF', false, 'Add');
     
     
     
    
    var mainPanel=new Ext.Panel({
     standardSubmit : true,
     id:'mainpanel',
	 width :screen.width-42,
	 height   	: 500,
	 layout   	: 'table',
	 layoutConfig: {columns:2},
	 items    	: [
	                firstGrid,secondGrid
	                ]
    });
     


     Ext.onReady(function() {      
         Ext.QuickTips.init();
         Ext.form.Field.prototype.msgTarget = 'side';
         outerPanel = new Ext.Panel({
             title: '<%=ticketDetails%>',
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
             items: [clientPanel,durationpanel1,mainPanel]
         });         
     });
</script>
<jsp:include page="../Common/footer.jsp" />
 <!-- </body>   -->
 <!-- </html> -->