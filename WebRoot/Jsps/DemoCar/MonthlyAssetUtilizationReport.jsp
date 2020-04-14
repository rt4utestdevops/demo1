<%@ page  language="java" import="java.util.*,t4u.functions.CommonFunctions,t4u.beans.*,t4u.common.*" pageEncoding="utf-8"%>

<%
	String path = request.getContextPath();
	String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
	CommonFunctions cf=new CommonFunctions();
	cf.checkLoginInfo((LoginInfoBean)session.getAttribute("loginInfoDetails"),session,request,response);
	LoginInfoBean loginInfo=(LoginInfoBean)session.getAttribute("loginInfoDetails");
	String language=loginInfo.getLanguage();
	int customeridlogged=loginInfo.getCustomerId();
	//getting hashmap with language specific words
	HashMap langConverted=ApplicationListener.langConverted;
	
	String SelectCustomer=cf.getLabelFromDB("Select_Customer",language);
	String CustomerName=cf.getLabelFromDB("Customer_Name",language);
	String SelectGroup=cf.getLabelFromDB("Select_Group_Name",language);
	String StartDate=cf.getLabelFromDB("Start_Date",language);
	String SelectStartDate=cf.getLabelFromDB("Select_Start_Date",language);
	String EndDate=cf.getLabelFromDB("End_Date",language);
	String SelectEndDate=cf.getLabelFromDB("Select_End_Date",language);
	String GroupName=cf.getLabelFromDB("Group_Name",language);
	String NoRecordsFound=cf.getLabelFromDB("No_Records_Found",language);
	String ReconfigureGrid=cf.getLabelFromDB("Reconfigure_Grid",language);
	String ClearGrouping=cf.getLabelFromDB("Clear_Grouping",language);
	String ClearFilterData=cf.getLabelFromDB("Clear_Filter_Data",language);
	String RegistrationNo=cf.getLabelFromDB("Registration_No",language);
	String DistanceTravelled=cf.getLabelFromDB("Distance_Travelled",language);
	String MonthlyAssetUtilizationReport=cf.getLabelFromDB("Monthly_Asset_Utilization_Report",language);
	String ActualWorkingDays=cf.getLabelFromDB("Actual_Working_Days",language);
	String Percentage=cf.getLabelFromDB("Percentage",language);
	String Submit=cf.getLabelFromDB("Submit",language);
	String slno=cf.getLabelFromDB("SLNO",language);
	String vehicleNoGname=cf.getLabelFromDB("vehicleNo_Gname",language);
	String assetUtilizationChart=cf.getLabelFromDB("asset_Utilization_Chart",language);
	String monthlyAssetUtilizationDetails=cf.getLabelFromDB("Monthly_Asset_Utilization_Details",language);
	String percentage=cf.getLabelFromDB("Percentage1",language);
	String ViewGraph=cf.getLabelFromDB("View_Graph",language);
	String VehicleUtilized=cf.getLabelFromDB("Vehicle_Utilized",language);
	String NonUtilizedDays=cf.getLabelFromDB("Non_Utilized_Days",language);
	String UtilizedOnHolidays=cf.getLabelFromDB("Utilized_On_Holidays",language);
	String monthValidation=cf.getLabelFromDB("Month_Validation",language);
	String startDateEndDateValication=cf.getLabelFromDB("start_Date_End_Date_Validation",language);
	String holiday=cf.getLabelFromDB("Holiday",language);
	String Excel=cf.getLabelFromDB("Excel",language);
	String ViewChart=cf.getLabelFromDB("View_Chart",language);
	String NoDataForChart=cf.getLabelFromDB("No_Data_For_Chart",language);
	
	
	
%>

<!DOCTYPE HTML>
<html class="largehtml">
 <head>
 

    <title><%=MonthlyAssetUtilizationReport%></title>
 </head>
   <style>
   
  .x-tab-panel
 {
       height: 532px;
 }
 #ext-comp-1006{
 	height: 532px;
 }
       .x-panel .innerpanelgridpercentage
       {
       height: 45px;
       } 
       .x-tab-panel-header .x-unselectable{
        height:18px;
       } 
       </style>
 <body class="largebody">
 <%if (loginInfo.getStyleSheetOverride().equals("Y")){%>
<jsp:include page="../Common/ImportJSSandMining.jsp"/>
<%}else {%>
<jsp:include page="../Common/ImportJS.jsp" /><%} %>
 <jsp:include page="../Common/ExportJS.jsp" />

 <script>
   
 var outerPanel;
 var ctsb;
 var dtnext = datecur;   
 var dtcur = datecur.add(Date.DAY, -1); 
 
 var assetGroup;
 var globalClientId;
 var popupcol;
 var popuppie;
 
 var chartstore;
 var sdate;
 var edate;
 
  var XaxisLable='<%=vehicleNoGname%>'.replace(/ /gi,'%20');
  var YaxisLable='<%=percentage%>';
  var pageName='<%=assetUtilizationChart%>'.replace(/ /gi,'%20'); 
  var chartColour="0x4863A0";
  var toolTip="Both";
	/********************resize window event function***********************/
   Ext.EventManager.onWindowResize(function () {
   				var width = '100%';
			    var height = '100%';
				grid.setSize(width, height);
			    outerPanel.setSize(width, height);
			    outerPanel.doLayout();
	});
   chartstore= new Ext.data.JsonStore({
			url:'<%=request.getContextPath()%>/ColumnChartAction.do?param=MonthlycolumnChartData',
				   id:'ColumnChartStoreId',
			       root: 'monthlycolumnchartroot',
			       autoLoad: false,
				   fields: ['Xaxis','Yaxis']
  });
  //for exporting to excel***** 
 var jspName="MonthlyAssetUtilizationReport";
 var exportDataType= "int,string,string,number,int,int,int,number,int,int";
  
  function columnchart()
  {
  
  		if(store.data.length==0)
        {
	         Ext.example.msg("<%=NoDataForChart%>");
	         return;
        }
	    
	    var clientid= Ext.getCmp('custcomboId').getValue();
		var groupid =  Ext.getCmp('assetgroupcomboId').getValue();
		var sdate = Ext.getCmp('startdate').getValue();
		var edate = Ext.getCmp('enddate').getValue();
  
  	    if(popupcol)
  	    {
  	   		popupcol.close();
  	    }
  	   
	    sdate=sdate.format("Y-m-d");
	    edate=edate.format("Y-m-d");
	   
	    chartstore.load({params:{clientId: globalClientId,groupId:groupid,sdate:sdate,edate:edate}});
	   
 	    popupcol = new Ext.Window({
			title: '<%=assetUtilizationChart%>',
			closeAction : 'hide', 
			autoShow : false,
			constrain : true,
			constrainHeader : false,
			resizable : false,
			maximizable : true,
			buttonAlign : "center",
			width:800,
			height:500,
			plain : false, 
			footer : true,
			closable : true,
			stateful : false,
			html : "<iframe style='width:100%;height:100%' src=<%=request.getContextPath()%>/Jsps/DemoCar/ColumnChart.jsp?XaxisLable="+XaxisLable+"&YaxisLable="+YaxisLable+"&pageName="+pageName+"&chartColour="+chartColour+"&toolTip="+toolTip+"></iframe>"
			});
			popupcol.setPosition(50, 50);
			popupcol.show();
				
  }
 
  var assetgroupcombostore= new Ext.data.JsonStore({
			url:'<%=request.getContextPath()%>/UtilizationReportsAction.do?param=getAssetGroup',
				   id:'GroupStoreId',
			       root: 'assetGroupRoot',
			       autoLoad: false,
			       remoteSort: true,
				   fields: ['groupId','groupName']
				
	  });
	  
	  var assetgroupcombo=new Ext.form.ComboBox({
	        store: assetgroupcombostore,
	        id:'assetgroupcomboId',
	        mode: 'local',
	        forceSelection: true,
	        emptyText:'<%=SelectGroup%>',
	        selectOnFocus:true,
	        allowBlank: false,
	        anyMatch:true,
            typeAhead: false,
	        triggerAction: 'all',
	        lazyRender: true,
	    	valueField: 'groupId',
	    	displayField: 'groupName',
	    	cls:'selectstyle',
	    	listeners: 
	    	{
		         select: 
		         {
		               fn:function()
		               {
		                 	assetGroup=Ext.getCmp('assetgroupcomboId').getValue();
		                 	store.load();
 					   }
 				 }
 			}
 	  });	
 var customercombostore= new Ext.data.JsonStore({
			url:'<%=request.getContextPath()%>/CommonAction.do?param=getCustomer',
				   id:'CustomerStoreId',
			       root: 'CustomerRoot',
			       autoLoad: true,
			       remoteSort: true,
				   fields: ['CustId','CustName'],
				   listeners: 
				   {
	    				load: function(custstore, records, success, options) 
	    				{
	        				 if(<%=customeridlogged%>>0)
	        				 {
					 			Ext.getCmp('custcomboId').setValue('<%=customeridlogged%>');
					 			store.load();
	                	   		globalClientId=Ext.getCmp('custcomboId').getValue();
	                	   		assetgroupcombostore.load({
								params:{CustId : globalClientId}
								});
					 		 }
	    				}
    			  }
	});
	
 var custnamecombo=new Ext.form.ComboBox({
	        store: customercombostore,
	        id:'custcomboId',
	        mode: 'local',
	        forceSelection: true,
	        emptyText:'<%=SelectCustomer%>',
	        selectOnFocus:true,
	        allowBlank: false,
	        anyMatch:true,
            typeAhead: false,
	        triggerAction: 'all',
	        lazyRender: true,
	    	valueField: 'CustId',
	    	displayField: 'CustName',
	    	cls:'selectstyle',
	    	listeners: 
	    	{
                  select: 
                  {
                	   fn:function()
                	   {
                	   		store.load();
                	   		globalClientId=Ext.getCmp('custcomboId').getValue();
                	   		assetgroupcombostore.load({
							params:{CustId : globalClientId}
							});
					   }
				  }
 			}
 			});
 			
 			
   		
 								
 var reader = new Ext.data.JsonReader({
        idProperty: 'darreaderid',
        root: 'dardata',
        totalProperty: 'total',
        fields: [
        {name: 'slnoIndex'}, 
        {name: 'groupIndex'}, 
        {name: 'registrationIndex'}, 
        {name: 'totalDistanceIndex'}, 
        {name: 'actualWorkingDaysIndex'},
        {name: 'holidayIndex'},
        {name: 'vehicleUtilizedIndex'}, 
        {name: 'percentageIndex'}, 
        {name: 'nonUtilizedDaysIndex'}, 
        {name: 'utilizedOnHolidayIndex'} 
        ]
	});
	
 var store =  new Ext.data.GroupingStore({
        autoLoad:false,
        proxy: new Ext.data.HttpProxy({
        url:'<%=request.getContextPath()%>/MonthlyAssetUtilizationReportAction.do?param=getData',
        method: 'POST'
		}),
        remoteSort: false,
        sortInfo: 
        {
            field: 'groupIndex',
            direction: 'ASC'
        },
        groupField:'groupIndex',
        storeId: 'darStore',
        reader:reader
    });
    store.on('beforeload',function(store, operation,eOpts)
    {
        operation.params={
        	custId: Ext.getCmp('custcomboId').getValue(),
            groupId: Ext.getCmp('assetgroupcomboId').getValue(),
            startDate: Ext.getCmp('startdate').getValue(),
            endDate:Ext.getCmp('enddate').getValue(),
        	gname:Ext.getCmp('assetgroupcomboId').getRawValue(),
        	jspName:jspName
           };
	},this);
    var filters = new Ext.ux.grid.GridFilters({
    local:true,
        filters: [
        {type: 'numeric',dataIndex: 'slnoIndex'}, 
        {type: 'string',dataIndex: 'groupIndex'}, 
        {type: 'string',dataIndex: 'registrationIndex'},
        {type: 'numeric',dataIndex: 'totalDistanceIndex'}, 
        {type: 'numeric',dataIndex: 'actualWorkingDaysIndex'}, 
        {type: 'numeric',dataIndex: 'holidayIndex'}, 
        {type: 'numeric',dataIndex: 'vehicleUtilizedIndex'}, 
        {type: 'numeric',dataIndex: 'percentageIndex'}, 
        {type: 'numeric',dataIndex: 'nonUtilizedDaysIndex'}, 
        {type: 'numeric',dataIndex: 'utilizedOnHolidayIndex'} 
        ]
    });    
    
    
    
    
    var createColModel = function (finish, start) 
    {
        var columns = [
        new Ext.grid.RowNumberer({header: "<span style=font-weight:bold;><%=slno%></span>",width:50}),
        {
            header: "<span style=font-weight:bold;><%=slno%></span>",
            dataIndex: 'slnoIndex',
            hidden:true,
            filter:
            {
            	type: 'numeric'
			}
        },
        {
            header: "<span style=font-weight:bold;><%=GroupName%></span>",
            dataIndex: 'groupIndex',
            filter:
            {
            	type: 'string'
			}
        }, {
        	header: "<span style=font-weight:bold;><%=RegistrationNo%></span>",
            dataIndex: 'registrationIndex',
            filter: {
            type: 'string'
            }
        }, {
        	header: "<span style=font-weight:bold;><%=DistanceTravelled%></span>",
            dataIndex: 'totalDistanceIndex',
            filter: 
            {
            	type: 'numeric'
            }
        },
        {
            header: "<span style=font-weight:bold;><%=ActualWorkingDays%></span>",
            dataIndex: 'actualWorkingDaysIndex',
            filter: {
            type: 'numeric'
            }
        },
        {
            header: "<span style=font-weight:bold;><%=holiday%></span>",
            dataIndex: 'holidayIndex',
            hidden:true,
            filter: {
            type: 'numeric'
            }
        }, {
            header: "<span style=font-weight:bold;><%=VehicleUtilized%></span>",
            dataIndex: 'vehicleUtilizedIndex',
            filter: {
            type: 'numeric'
            }
        }, {
            header: "<span style=font-weight:bold;><%=Percentage%></span>",
            dataIndex: 'percentageIndex',
            filter: {
            type: 'numeric'
            }
        }, 
        {
            header: "<span style=font-weight:bold;><%=NonUtilizedDays%></span>",
            dataIndex: 'nonUtilizedDaysIndex',
            filter: {
            type: 'numeric'
            }
        }, 
        {
            header: "<span style=font-weight:bold;><%=UtilizedOnHolidays%></span>",
            dataIndex: 'utilizedOnHolidayIndex',
            filter: {
            type: 'numeric'
            }
        }];

        return new Ext.grid.ColumnModel({
            columns: columns.slice(start || 0, finish),
            defaults: {
                sortable: true
            }
        });
    };
    
    var grid=getGrid('<%=monthlyAssetUtilizationDetails%>','<%=NoRecordsFound%>',store,screen.width - 50,290,8,filters,'<%=ClearFilterData%>',true,'<%=ReconfigureGrid%>',10,true,'<%=ClearGrouping%>',true,'<%=ViewChart%>',true,'<%=Excel%>',jspName,exportDataType,false,'');
    
    var innerPanel = new Ext.Panel({
		standardSubmit: true,
		collapsible:false,
		cls:'innerpanelgridpercentage',
		id:'innerpanels',
		layout:'table',
		layoutConfig: {
			columns:13
		},
		items: [
				{
					xtype: 'label',
					text: '<%=CustomerName%>'+':',
					cls:'labelstyle',
					id:'custnamelab'
				},
				custnamecombo,{width:50},
				{
					xtype: 'label',
					text: '<%=GroupName%>'+':',
					cls:'labelstyle',
					id:'groupnamelab'
				},
				assetgroupcombo,{width:50}
				,
				{
					xtype: 'label',
					cls:'labelstyle',
					id:'startdatelab',
					text: '<%=StartDate%>'+':'
				},
				{
					xtype:'datefield',
		    		cls:'selectstyle',
		    		format:getDateFormat(),
		    		emptyText:'<%=SelectStartDate%>',
		    		allowBlank: false,
		    		blankText :'<%=SelectStartDate%>',
		    		id:'startdate',
		    		value:dtcur,
		    		maxValue:dtcur
	    		}
	    		,{width:50},
				{
					xtype: 'label',
					cls:'labelstyle',
					id:'enddatelab',
					text: '<%=EndDate%>'+':'
				},
				{
					xtype:'datefield',
		    		cls:'selectstyle',
		    		format:getDateFormat(),
		    		emptyText:'<%=SelectEndDate%>',
		    		allowBlank: false,
		    		blankText :'<%=SelectEndDate%>',
		    		id:'enddate',
		    		value:dtnext,
		    		maxValue:dtnext
	    		}
	    		,{width:50},
	    		{
	       			xtype:'button',
	      			text:'<%=Submit%>',
	        		id:'addbuttonid',
	        		cls:' ',
	        		width:50,
	       			listeners: 
	       			{
		        		click:
		        		{
			       			fn:function()
			       			{
				   			 	if(Ext.getCmp('custcomboId').getValue() == "" )
							    {
						                 Ext.example.msg("<%=SelectCustomer%>");
						                 Ext.getCmp('custcomboId').focus();
				                      	 return;
							    }
							    if(Ext.getCmp('assetgroupcomboId').getValue() == "" )
							    {
						                 Ext.example.msg("<%=SelectGroup%>");
						              	 Ext.getCmp('assetgroupcomboId').focus();
				                      	 return;
							    }
							    if(Ext.getCmp('startdate').getValue() == "" )
							    {
						             Ext.example.msg("<%=SelectStartDate%>");
						             Ext.getCmp('startdate').focus();
				                     return;
							    }
							    if(Ext.getCmp('enddate').getValue() == "" )
							    {
						             Ext.example.msg("<%=SelectEndDate%>");
						             Ext.getCmp('enddate').focus();
				                     return;
							    }
							    
							    var startdates=Ext.getCmp('startdate').getValue();
            		 			var enddates=Ext.getCmp('enddate').getValue();
            		 			
            		 			var d1 = new Date(startdates);
            		 			var d2 = new Date(enddates);
            		 			
            		 						
            		 			if(d1>d2)
            		 			{
										Ext.example.msg("<%=startDateEndDateValication%>");
										return;
								}	
            		 						
            		 			var Startdate11 = new Date(enddates).add(Date.MONTH, -1);
            		 			if(startdates < Startdate11 )
            		 			{
            		 					Ext.example.msg("<%=monthValidation%>");
            		           			Ext.getCmp('enddate').focus(); 
               		    				return;
            		 			}
							    
				       			store.load({
				                        params: {
				                            custId: Ext.getCmp('custcomboId').getValue(),
				                            groupId: Ext.getCmp('assetgroupcomboId').getValue(),
				                            startDate: Ext.getCmp('startdate').getValue(),
                            				endDate:Ext.getCmp('enddate').getValue(),
                            				gname:Ext.getCmp('assetgroupcomboId').getRawValue(),
                            				jspName:jspName
				                        }
				                    });
			       			}
	       				}
       				}
       			}
       		]
		}); 
		
  var NotePanel = new Ext.Panel({
			    standardSubmit: true,
			    hidden:false,
			    id:'noteId',
			    cls:'innerpanelgridpercentage',
			    items: [{height:10},{ html: "<td><font size='2'><b> NOTE : </b></font></td>"},{height:5},
			    { html: "<td><font size='2'>Actual working days :  Total Duration Selected – Holidays.</font></td>"},{height:5},
			    { html: "<td><font size='2'>Vehicle utilized :  If Vehicle Moved >5kms During Actual Working Days.</font></td>"},{height:5},
			    { html: "<td><font size='2'>Percentage :  (Vehicle Utilized/Actual Working Days)* 100</font></td>"},{height:5},
			    { html: "<td><font size='2'>Non utilized days :   Actual working days- Vehicle utilized.</font></td>"},{height:5},
			    { html: "<td><font size='2'>Utilized on Holidays :   No of days vehicle utilized During Holidays.</font></td>"}
			    ]
 });
 	  
 Ext.onReady(function()
 {
	ctsb=tsb;
	Ext.QuickTips.init();
	Ext.form.Field.prototype.msgTarget = 'side';		         	   			
 	outerPanel = new Ext.Panel({
 			title:'<%=MonthlyAssetUtilizationReport%>',
			renderTo: 'content',
            standardSubmit: true,
            height:520,
            width:screen.width-45,
			frame: true,
            //cls: 'mainpanelpercentage',
            layout: 'fit',
			items: [innerPanel,grid,NotePanel]
			//bbar:ctsb			
			}); 
 });		
	
  </script>
  </body>
</html>
