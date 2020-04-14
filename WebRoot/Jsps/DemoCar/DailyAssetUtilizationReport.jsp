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
	String DailyAssetUtilizationReport=cf.getLabelFromDB("Daily_AssetUtilization_Report",language);
	String SelectDate=cf.getLabelFromDB("Select_Date",language);
	String SelectGroup=cf.getLabelFromDB("Select_Group_Name",language);
	String Date=cf.getLabelFromDB("Date",language);
	String GroupName=cf.getLabelFromDB("Group_Name",language);
	String NoRecordsFound=cf.getLabelFromDB("No_Records_Found",language);
	String ClearFilterData=cf.getLabelFromDB("Clear_Filter_Data",language);
	String ReconfigureGrid=cf.getLabelFromDB("Reconfigure_Grid",language);
	String ClearGrouping=cf.getLabelFromDB("Clear_Grouping",language);
	String RegistrationNo=cf.getLabelFromDB("Registration_No",language);
	String TravelTime=cf.getLabelFromDB("Travel_Time",language);
	String DistanceTravelled=cf.getLabelFromDB("Distance_Travelled",language);
	String OutsideParking=cf.getLabelFromDB("Outside_Parking",language);
	String InsideParking=cf.getLabelFromDB("Inside_Parking",language);
	String Percentage=cf.getLabelFromDB("Percentage",language);
	String Submit=cf.getLabelFromDB("Submit",language);
	String slno=cf.getLabelFromDB("SLNO",language);
	String vehicleNoGname=cf.getLabelFromDB("vehicleNo_Gname",language);
	String assetUtilizationChart=cf.getLabelFromDB("asset_Utilization_Chart",language);
	String DailyAssetUtilizationDetails=cf.getLabelFromDB("Daily_Asset_Utilization_Details",language);
	String percentage=cf.getLabelFromDB("Percentage1",language);
	String Excel=cf.getLabelFromDB("Excel",language);
	String ViewChart=cf.getLabelFromDB("View_Chart",language);
	String NoDataForChart=cf.getLabelFromDB("No_Data_For_Chart",language);
	
	
	
%>

<!DOCTYPE HTML>
<html class="largehtml">
 <head>
 
    <title><%=DailyAssetUtilizationReport%></title>
 </head>
 <body class="largebody">
 	<%if (loginInfo.getStyleSheetOverride().equals("Y")){%>
	<jsp:include page="../Common/ImportJSSandMining.jsp"/>
	<%}else {%>
	<jsp:include page="../Common/ImportJS.jsp" /><%} %>	
 	<jsp:include page="../Common/ExportJS.jsp" />
 	
 <script>  
 var outerPanel;
 var ctsb;
 var prevdate = datecur.add(Date.DAY, -1); 
 var assetGroup;
 var globalClientId;
 var date;
 var popupcol;
 var popuppie;
 var chartstore;
 var gname;
   /**
   
   Points to be followed while using ColumnChart.jsp
   
   1)XaxisLable:Label name of x-axis by default it is "X-Axis".
   
   2)YaxisLable:Label name of y-axis by default it is "Y-Axis".
   
   3)pageName:Chart Name by default it is "Chart Name".
   
   4)chartColour:Reprersents the chart colour which must be in "0x4863a0" format by default it is "0x4863a0".
   
   5)toolTip:If you need value of x-axis in tool tip then you must pass "Xaxis",
   If you need value of y-axis in tool tip then you must pass "Yaxis",
   If you need value of x-axis and value of y-axis in tool tip then you must pass "Both" by default it is "Both".
   
   6)To use the column chart store must be loaded in the parent page and the stpre name must be chartstore,
   value field and display field of the store must be Xaxis and Yaxis .
   
   7)To use this chart y-axis must be numeric type and x-axis must be of string type. 
   
   8)Please dont change anything in ColumnChart if made will effect for all the page which are using ColumnChart.
   
   */
   var XaxisLable='<%=vehicleNoGname%>'.replace(/ /gi,'%20');
   var YaxisLable='<%=percentage%>';
   var pageName='<%=assetUtilizationChart%>'.replace(/ /gi,'%20'); 
   var chartColour="0x4863A0";
   var toolTip="Both";
   var filename;
   var report;
   
   /********************resize window event function***********************/
   Ext.EventManager.onWindowResize(function () {
   				var width = '100%';
			    var height = '100%';
				grid.setSize(width, height);
			    outerPanel.setSize(width, height);
			    outerPanel.doLayout();
	});
 
   chartstore= new Ext.data.JsonStore({
			url:'<%=request.getContextPath()%>/ColumnChartAction.do?param=DailycolumnChartData',
				   id:'ColumnChartStoreId',
			       root: 'columnchartroot',
			       autoLoad: false,
			       remoteSort: true,
				   fields: ['Xaxis','Yaxis']
  });
  /*
  Points to be followed to use Export Action
  
  1)ExportJS.jsp must be included.
  
  2)jspName : Mention the Jsp Name.
  
  3)ExportDataType: This variable must have tha type of the column in the same order mentioned in the columnmodel,Even hidden columns type must also be mentioned.
  
  5)Then send these values to grid function giving excel variable as true.
  
  6)Go to export action give the corresponding header and footer with the file name mentioned has done for many examples.
  
  Note:There must be a hidden SLNO column in all the jsps.
  
  */
   //for exporting to excel***** 
 var jspName="DailyAssetUtilizationReport";
 var exportDataType="int,string,string,number,number,string,string,number";
  
  function columnchart()
  {
  
  		
	   if(store.data.length==0)
	   {
			 Ext.example.msg("<%=NoDataForChart%>");
			 return;
	   }
					    
	   var clientid= Ext.getCmp('custcomboId').getValue();
	   var groupid =  Ext.getCmp('assetgroupcomboId').getValue();
	   var date=Ext.getCmp('date').getValue();
				
  	   if(popupcol)
  	   {
  	   		popupcol.close();
  	   }
  	   
	   date=date.format("Y-m-d");
	   
	   chartstore.load({params:{clientId: globalClientId,groupId:groupid,date:date}});
	   
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
        {name: 'travelTimeIndex'},
        {name: 'distanceTravelledIndex'}, 
        {name: 'outsideParkingIndex'}, 
        {name: 'insideParkingIndex'}, 
        {name: 'percentageIndex'} 
        ]
	});
	
 var store =  new Ext.data.GroupingStore({
        autoLoad:false,
        proxy: new Ext.data.HttpProxy({
        url:'<%=request.getContextPath()%>/DailyAssetUtilizationReportAction.do?param=getData',
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
			 Date:Ext.getCmp('date').getValue(),
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
        {type: 'numeric',dataIndex: 'travelTimeIndex'}, 
        {type: 'numeric',dataIndex: 'distanceTravelledIndex'}, 
        {type: 'string',dataIndex: 'outsideParkingIndex'}, 
        {type: 'string',dataIndex: 'insideParkingIndex'}, 
        {type: 'numeric',dataIndex: 'percentageIndex'} 
        ]
    });    
    
    
    var createColModel = function (finish, start) 
    {
        var columns = [
        new Ext.grid.RowNumberer({header: "<span style=font-weight:bold;><%=slno%></span>",width:50}),
        {
            dataIndex: 'slnoIndex',
            hidden:true,
            header: "<span style=font-weight:bold;><%=slno%></span>",
            filter:
            {
            	type: 'numeric'
			}
        },{
            dataIndex: 'groupIndex',
            header: "<span style=font-weight:bold;><%=GroupName%></span>",
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
            header: "<span style=font-weight:bold;><%=TravelTime%></span>",
            dataIndex: 'travelTimeIndex',
            filter: 
            {
            	type: 'numeric'
            }
        },{
            header: "<span style=font-weight:bold;><%=DistanceTravelled%></span>",
            dataIndex: 'distanceTravelledIndex',
            filter: {
            type: 'numeric'
            }
        }, {
            header: "<span style=font-weight:bold;><%=OutsideParking%></span>",
            dataIndex: 'outsideParkingIndex',
            filter: {
            type: 'string'
            }
        }, 
        {
            header: "<span style=font-weight:bold;><%=InsideParking%></span>",
            dataIndex: 'insideParkingIndex',
            filter: {
            type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=Percentage%></span>",
            dataIndex: 'percentageIndex',
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
    
    
    var grid=getGrid('<%=DailyAssetUtilizationDetails%>','<%=NoRecordsFound%>',store,screen.width - 50,300,8,filters,'<%=ClearFilterData%>',true,'<%=ReconfigureGrid%>',10,true,'<%=ClearGrouping%>',true,'<%=ViewChart%>',true,'<%=Excel%>',jspName,exportDataType,false,'');
 

    var innerPanel = new Ext.Panel({
		standardSubmit: true,
		collapsible:false,
		cls:'innerpaneloneinchheightpercentage',
		id:'innerpanels',
		layout:'table',
		layoutConfig: {
			columns:10
		},
		items: [
				{
					xtype: 'label',
					text: '<%=CustomerName%>'+':',
					cls:'labelstyle',
					id:'custnamelab'
				},
				custnamecombo,{width:20},
				{
					xtype: 'label',
					text: '<%=GroupName%>'+':',
					cls:'labelstyle',
					id:'groupnamelab'
				},
				assetgroupcombo,{width:20}
				,
				{
					xtype: 'label',
					cls:'labelstyle',
					id:'datelab',
					text: '<%=Date%>'+':'
				},
				{
					xtype:'datefield',
		    		cls:'selectstyle',
		    		format:getDateFormat(),
		    		emptyText:'<%=SelectDate%>',
		    		allowBlank: false,
		    		blankText :'<%=SelectDate%>',
		    		id:'date',
		    		value:prevdate,
		    		maxValue:prevdate
	    		}
	    		,{width:20},
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
							    if(Ext.getCmp('date').getValue() == "" )
							    {
						                 Ext.example.msg("<%=SelectDate%>");
						                 Ext.getCmp('date').focus();
				                      	 return;
							    }
							    
				       			store.load({
				                        params: {
				                            custId: Ext.getCmp('custcomboId').getValue(),
				                            groupId: Ext.getCmp('assetgroupcomboId').getValue(),
				                            Date:Ext.getCmp('date').getValue(),
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
			    cls:'innerpanelgridpercentage1',
			    items: [{height:5},{ html: "<td><font size='2'><b> NOTE : </b></font></td>"},{height:5},
			    { html: "<td><font size='2'> Percentage : (Duration outside the parking / Selected duration) * 100 </font></td>"}
			    ]
 });
 	  
 Ext.onReady(function()
 {
	ctsb=tsb;
	Ext.QuickTips.init();
	Ext.form.Field.prototype.msgTarget = 'side';		         	   			
 	outerPanel = new Ext.Panel({
 			title:'<%=DailyAssetUtilizationReport%>',
			renderTo : 'content',
			standardSubmit: true,
			height:520,
			width:screen.width-45,
			frame:true,
			//cls:'mainpanelpercentage',
			layout:'fit',
			items: [innerPanel,grid,NotePanel]
			//bbar:ctsb			
			}); 
 });		
	
  </script>
  </body>
</html>
