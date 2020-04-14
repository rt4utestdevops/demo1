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
 String daily=cf.getLabelFromDB("Daily",language);
 String monthly=cf.getLabelFromDB("Monthly",language);
 String view=cf.getLabelFromDB("View",language);
 String profitLossReport=cf.getLabelFromDB("Profit_Loss_Report",language);
 String netProfit=cf.getLabelFromDB("Net_Profit",language);
 String maintenanceExpense=cf.getLabelFromDB("Maintenance_Expense",language);
 String tripExpense=cf.getLabelFromDB("Trip_Expense",language);
 String totalIncome=cf.getLabelFromDB("Total_Income_On_Ticket",language);
 String month=cf.getLabelFromDB("Month",language);
 String date=cf.getLabelFromDB("Date",language);
String noOfTickets=cf.getLabelFromDB("No_Of_Seats_Booked",language);
String noOfDays=cf.getLabelFromDB("No_Of_Days_Operated",language);
 String serviceName=cf.getLabelFromDB("Service_Name",language);
 String selectTicketSoldType=cf.getLabelFromDB("Please_Ticket_Sold_Type",language);
 String fromMonthYear=cf.getLabelFromDB("From_Month_And_Year",language);
 String selectFromMonth=cf.getLabelFromDB("Please_Select_From_Month",language);
 String selectToMonth=cf.getLabelFromDB("Please_Select_To_Month",language);
 String toMonthYear=cf.getLabelFromDB("To_Month_And_Year",language);
 String selectFromYear=cf.getLabelFromDB("Please_Select_From_Year",language);
 String selectToYear=cf.getLabelFromDB("Please_Select_To_Year",language);
 String differenceBetweenMonth=cf.getLabelFromDB("Difference_between_from_month_and_to_month_should_be_3_months",language);
 String diffBetweenMonth=cf.getLabelFromDB("To_month_should_be_greater_than_From_month",language);
 String names=cf.getLabelFromDB("Names",language);
 String typeList=cf.getLabelFromDB("Type_List",language);
 
%>

<jsp:include page="../Common/header.jsp" />


    <title>
       <%=profitLossReport%>
    </title>

<style>
 .x-form-cb-label {
    position: relative;
    margin-left:4px;
    top: 2px;
    font-size:13px;
    font-family: sans-serif;
}
		
		
		
		
</style>


	<%if (loginInfo.getStyleSheetOverride().equals("Y")){%>
		<jsp:include page="../Common/ImportJSSandMining.jsp" />
		<%}else {%>
		<jsp:include page="../Common/ImportJS.jsp" />
		<%} %>
		<jsp:include page="../Common/ExportJS.jsp" />
		<style>
		.x-form-check-wrap input {
			vertical-align: middle !important;
		}
		
		.ext-strict .x-form-text 
		{
			height : 21px !important;
		}
		
		.x-window-tl *.x-window-header {
			padding-top : 6px !important;
		}
		label#startdatelab {
			width : 144px !important;
		}
		
		</style>
<script>
                  
                    var manageAllTasksGrid;
                    var dtprev = dateprev;
                    var dtcur = datecur;
                    var jspName = "Profit And Loss Report";
                    var exportDataType = "int,string,string,string,string,string,string,string,String,String,Sting,Sting,String,String";
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
                   
        var monthliststore =new Ext.data.SimpleStore({
        id:'monthlistId',
        autoLoad:false,
        fields:['MonthId','MonthName'],
        data:[
        		['01','January'],
        		['02','February'],
        		['03','March'],
        		['04','April'],
        		['05','May'],
        		['06','June'],
        		['07','July'],
        		['08','August'],
        		['09','September'],
        		['10','October'],
        		['11','November'],
        		['12','December']
        ]
        });      
            var fromMonthListCombo = new Ext.form.ComboBox({
            store: monthliststore,
            id: 'fromMonthlistId',
            mode: 'local',
            hidden: false,
            resizable: true,
            forceSelection: true,
            selectOnFocus: true,
            allowBlank: false,
            typeAhead: true,
            triggerAction: 'all',
            lazyRender: true,
            width:150,
            valueField: 'MonthId',
            displayField: 'MonthName',
            cls: 'selectstylePerfect',
            listeners: {
                select: {
                    fn: function () {
                    	
                }
            }
            }
        });
        
         var toMonthListCombo = new Ext.form.ComboBox({
            store: monthliststore,
            id: 'toMonthlistId',
            mode: 'local',
            hidden: false,
            resizable: true,
            forceSelection: true,
            selectOnFocus: true,
            allowBlank: false,
            typeAhead: true,
            triggerAction: 'all',
            lazyRender: true,
            width:150,
            valueField: 'MonthId',
            displayField: 'MonthName',
           cls: 'selectstylePerfect',
            listeners: {
                select: {
                    fn: function () {
                    
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
        
        
      
        var yrList = [['1',<%=PrevYear%>],['2',<%=CrntYear%>] ];
       
       var toYrStore = new Ext.data.SimpleStore({
    		fields: ['yearid','yearname'],
			data: yrList
		});	
		
		 var fromYrCombo=new Ext.form.ComboBox({
				  store: toYrStore,
				  id:'fromYrComboId',
				  forceSelection:true,
				  enableKeyEvents:true,
				  width:75,
				  mode: 'local',
				  triggerAction: 'all',
				  displayField: 'yearname',
				  cls: 'selectstyleMonthYear',
				  listeners: {
                	select: {
	                    fn: function () {
	                   	}
                	}
            	}
	       }); 
	       
	        var toYrCombo=new Ext.form.ComboBox({
				  store: toYrStore,
				  id:'toYrComboId',
				  forceSelection:true,
				  enableKeyEvents:true,
				  mode: 'local',
				  triggerAction: 'all',
				  width:75,
				  displayField: 'yearname',
				 cls: 'selectstyleMonthYear',
				  listeners: {
                	select: {
                    	fn: function () {
                    		
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
            },{
                width: 20
            },{
            xtype: 'radiogroup',
            fieldLabel: '',
            width:265,
            id:'radiogroupid',
            items: [
            
            			{boxLabel: '<%=daily%>',name: 'show',id:'daily',width:20,inputValue: '2'},
                		{boxLabel: '<%=monthly%>',name: 'show',id:'monthly',width:20,inputValue: '1',checked:true},
                		
            		],
            	listeners: {
                change: function(field, newValue, oldValue) {
                 if(Ext.getCmp('daily').getValue())
                {
                 	 store.load();  
                	 Ext.getCmp('durationpanel1Id').show();
                	 Ext.getCmp('durationpanel2Id').hide();                	 
                	 secondGrid.getColumnModel().setHidden(secondGrid.getColumnModel().findColumnIndex('serviceNoDataIndex'), false);
                     secondGrid.getColumnModel().setHidden(secondGrid.getColumnModel().findColumnIndex('routeNameDataIndex'), false);
                     secondGrid.getColumnModel().setHidden(secondGrid.getColumnModel().findColumnIndex('dateindex'), false);
                     secondGrid.getColumnModel().setHidden(secondGrid.getColumnModel().findColumnIndex('noOfdaysIndex'), true);
                     secondGrid.getColumnModel().setHidden(secondGrid.getColumnModel().findColumnIndex('monthindex'), true);
                }
                else if(Ext.getCmp('monthly').getValue()){
                 	store.load();  
                    Ext.getCmp('durationpanel1Id').hide();
                    Ext.getCmp('durationpanel2Id').show();
                    secondGrid.getColumnModel().setHidden(secondGrid.getColumnModel().findColumnIndex('serviceNoDataIndex'), true);
                    secondGrid.getColumnModel().setHidden(secondGrid.getColumnModel().findColumnIndex('routeNameDataIndex'), true);
                    secondGrid.getColumnModel().setHidden(secondGrid.getColumnModel().findColumnIndex('dateindex'), true);
                    secondGrid.getColumnModel().setHidden(secondGrid.getColumnModel().findColumnIndex('noOfdaysIndex'), false);
                    secondGrid.getColumnModel().setHidden(secondGrid.getColumnModel().findColumnIndex('monthindex'), false);
                }
            }}
        	}
        ]
    });
                    
     
      var durationpanel1 = new Ext.Panel({
        standardSubmit: true,
        collapsible: false,
        id: 'durationpanel1Id',
        layout: 'table',
        frame: true,
        hidden: true,
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
            width: 10
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
            width: 170
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
        },{width:180},{
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
	       			  daily:Ext.getCmp('daily').getValue(),
	       			  typeName : Ext.getCmp('ticketTypeComboId').getValue(),
	       			  jspName :jspName,
	       			  custName :Ext.getCmp('custcomboId').getRawValue()
       			  }});
        }
        }]
    });
    
    var durationpanel2=new Ext.Panel({
     standardSubmit: true,
        collapsible: false,
        id: 'durationpanel2Id',
        layout: 'table',
        frame: true,
        hidden: false,
        width: screen.width - 40,
        
        layoutConfig: {
            columns: 11
        },
        items: [{
            xtype: 'label',
            cls: 'labelstyle',
            id: 'startmonthlab',
            width: 100,
            text: '<%=fromMonthYear%>' + ' :'
        }, fromMonthListCombo,{
        width:30
        },fromYrCombo,{
            width: 30
        }, {
            xtype: 'label',
            cls: 'labelstyle',
            id: 'endmonthlab',
            width: 200,
            text: '<%=toMonthYear%>' + ' :'
        },  toMonthListCombo,
        {width:10},
        toYrCombo,
        {width:30},{
        xtype: 'button',
        text: '<%=view%>',
        id: 'submitId2',
        cls: 'buttonStyle',
        width: 40,
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
       		 						
      	   				if(Ext.getCmp('fromMonthlistId').getValue() == "" ){
 						     Ext.example.msg("<%=selectFromMonth%>");
 		   	 				 Ext.getCmp('fromMonthlistId').focus(); 
 		    				 return;
 		 				}
       		 						
           	   		   if(Ext.getCmp('toMonthlistId').getValue() == "" ){
          				   Ext.example.msg("<%=selectToMonth%>");
          		   	 	   Ext.getCmp('toMonthlistId').focus(); 
          		    	   return;
       		 			}
       		 						
      		 		   if(Ext.getCmp('fromYrComboId').getValue() == "" ){
         				   Ext.example.msg("<%=selectFromYear%>");
         		   	 	   Ext.getCmp('fromYrComboId').focus(); 
         		    	   return;
      		 			}
      		 						
      		 		  if(Ext.getCmp('toYrComboId').getValue() == "" ){
         					Ext.example.msg("<%=selectToYear%>");				
         		   	 		Ext.getCmp('toYrComboId').focus(); 
         		    		return;
      		 			}
					if(Ext.getCmp('toYrComboId').getValue() != Ext.getCmp('fromYrComboId').getValue()){
							if((Ext.getCmp('fromMonthlistId').getValue()- Ext.getCmp('toMonthlistId').getValue())<10)
							{
							Ext.example.msg("<%=differenceBetweenMonth%>");
							
							Ext.getCmp('toYrComboId').focus();
							return;
							}
							
							}
							if(Ext.getCmp('toYrComboId').getValue() == Ext.getCmp('fromYrComboId').getValue()) {
							if(Ext.getCmp('toMonthlistId').getValue()<Ext.getCmp('fromMonthlistId').getValue())
							{
							Ext.example.msg("<%=diffBetweenMonth%>");				
							Ext.getCmp('toYrComboId').focus();
							return;
							}
							if((Ext.getCmp('toMonthlistId').getValue()- Ext.getCmp('fromMonthlistId').getValue())>6)
							{
							Ext.example.msg("<%=differenceBetweenMonth%>");
							Ext.getCmp('toYrComboId').focus();
							return;
							}
							}
      		 			    var selected = firstGrid.getSelectionModel().getSelected();
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
	       			  fromYear:Ext.getCmp('fromYrComboId').getRawValue(),
	       			  toYear:Ext.getCmp('toYrComboId').getRawValue(),
	       			  names:names,	       			  
	       			  typeName : Ext.getCmp('ticketTypeComboId').getValue(),
	       			  fromMonth : Ext.getCmp('fromMonthlistId').getValue(),
	       			  toMonth : Ext.getCmp('toMonthlistId').getValue(),
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
        name: 'slnoIndex',
        type: 'numeric'
    	},{
        name: 'serviceNoDataIndex',
        type: 'string'
    	},{
        name: 'noOfdaysIndex',
        type: 'numeric'
    	},{
        name: 'routeNameDataIndex',
        type: 'string'
    	},{
        name: 'terminalNameDataIndex',
        type: 'string'
    	},{
        name: 'noOfSeatsDataIndex',
        type: 'numeric'
    	},{
        name: 'vehicleNoDataIndex',
        type: 'string'
    	},{
        name: 'dateindex',
        type: 'date',
        dateFormat: getDateTimeFormat()
    	},{
        name: 'monthindex',
        type: 'string'
    	},{
    	name: 'totalIncomeDataIndex',
    	type: 'string'
    	},{
        name: 'tripExpenseDataIndex',
        type: 'string'
    	},{
        name: 'mainExpenseDataIndex',
        type: 'string'
    	},{
        name: 'netProfitDataIndex',
        type: 'string'
    	}]
    });
      
      var filters = new Ext.ux.grid.GridFilters({
        local: true,
    	filters: [{
        type: 'numeric',
        dataIndex: 'slnoIndex'
    	},{
    	type: 'string',
        dataIndex: 'serviceNoDataIndex'
    	},{
    	type: 'numeric',
        dataIndex: 'noOfdaysIndex'
    	},{
    	type: 'string',
        dataIndex: 'routeNameDataIndex'
    	},{
    	type: 'string',
        dataIndex: 'terminalNameDataIndex'
    	},{
    	type: 'numeric',
        dataIndex: 'noOfSeatsDataIndex'
    	},
    	{
    	type: 'string',
        dataIndex: 'vehicleNoDataIndex'
    	}, {
        type: 'date',
        dataIndex: 'dateindex'
        }, {
        type: 'string',
        dataIndex: 'monthindex'
        },
    	{
    	type: 'string',
        dataIndex: 'totalIncomeDataIndex'
    	},{
    	type: 'string',
        dataIndex: 'tripExpenseDataIndex'
    	},{
    	type: 'string',
        dataIndex: 'mainExpenseDataIndex'
    	},{
    	type: 'string',
        dataIndex: 'netProfitDataIndex'
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
        	header: "<span style=font-weight:bold;><%=serviceName%></span>",        	
        	dataIndex: 'serviceNoDataIndex',
        	filter: {
            type: 'string'
        	}        	
    		},{
        	header: "<span style=font-weight:bold;><%=noOfDays%></span>",
        	dataIndex: 'noOfdaysIndex',  
        	filter: {
            type: 'numeric'
        	}        	
    		}, {
        	header: "<span style=font-weight:bold;><%=routeName%></span>",
        	dataIndex: 'routeNameDataIndex',
        	filter: {
            type: 'string'
        	}
    		},{
        	header: "<span style=font-weight:bold;><%=termianlName%></span>",
        	dataIndex: 'terminalNameDataIndex',
        	filter: {
            type: 'string'
        	}
    		},{
    		header: "<span style=font-weight:bold;><%=noOfTickets%></span>",
    		dataIndex: 'noOfSeatsDataIndex',  
    		filter: {
    		type: 'numeric'
    		}
    		},{
    		header: "<span style=font-weight:bold;><%=vehicleNumber%></span>",
    		dataIndex: 'vehicleNoDataIndex',    
    		filter: {
    		type: 'string'
    		}
    		}, {
               header: "<span style=font-weight:bold;><%=date%></span>",
               dataIndex: 'dateindex',     
               renderer: Ext.util.Format.dateRenderer(getDateTimeFormat()),                                  
               filter: {
               type: 'date'
                }
            },{
    		header: "<span style=font-weight:bold;><%=month%></span>",
    		dataIndex: 'monthindex', 
    		filter: {
    		type: 'string'
    		}
    		},{
    		header: "<span style=font-weight:bold;><%=totalIncome%></span>",
    		dataIndex: 'totalIncomeDataIndex',
    		filter: {
    		type: 'string'
    		}
    		},{
    		header: "<span style=font-weight:bold;><%=tripExpense%></span>",
    		dataIndex: 'tripExpenseDataIndex', 
    		filter: {
    		type: 'string'
    		}
    		},{
    		header: "<span style=font-weight:bold;><%=maintenanceExpense%></span>",
    		dataIndex: 'mainExpenseDataIndex', 
    		filter: {
    		type: 'string'
    		}
    		},{
    		header: "<span style=font-weight:bold;><%=netProfit%></span>",
    		dataIndex: 'netProfitDataIndex',
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
                        url: '<%=request.getContextPath()%>/ProfitAndLossReportAction.do?param=getTypeForGrid',                       
                        reader: reader1,
                        autoLoad: false,
                        remoteSort: false
                    });
    
     var store = new Ext.data.GroupingStore({
     					proxy: new Ext.data.HttpProxy({
                            url: '<%=request.getContextPath()%>/ProfitAndLossReportAction.do?param=getTicketDetails',
                            method: 'POST'
                        }),
                        reader: gridreader,
                        autoLoad: false,
                        remoteSort: false
                    });
    
    
     var firstGrid = getSelectionModelGrid('Type List', '<%=NoRecordsfound%>', firstGridStore, 250, 390, cols1, 4, filters1, sm1);
     var secondGrid = getGrid('<%=profitLossReport%>', '<%=NoRecordsfound%>', store, screen.width - 290, 390, 15, filters, '<%=ClearFilterData%>', false, '', 14, false, '', false, '', true, 'Excel', jspName, exportDataType, true, 'PDF', false, 'Add');
     
     
     
    
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
             title: '<%=profitLossReport%>',
             renderTo: 'content',
             standardSubmit: true,
             frame: true,
             width: screen.width - 20,
             height: 540,
             cls: 'outerpanel',
             layout: 'table',
             layoutConfig: {
                 columns: 1
             },
             items: [clientPanel,durationpanel1,durationpanel2,mainPanel]
         });
         
           var cm = secondGrid.getColumnModel();  
			for (var j = 1; j < cm.getColumnCount(); j++) {
		    cm.setColumnWidth(j,120);
			}
					    
					    
            secondGrid.getColumnModel().setHidden(secondGrid.getColumnModel().findColumnIndex('serviceNoDataIndex'), true);
            secondGrid.getColumnModel().setHidden(secondGrid.getColumnModel().findColumnIndex('routeNameDataIndex'), true);
            secondGrid.getColumnModel().setHidden(secondGrid.getColumnModel().findColumnIndex('dateindex'), true);
         
     });
     
 </script>
 <jsp:include page="../Common/footer.jsp" />
 <!-- </body>   -->
 <!-- </html> -->