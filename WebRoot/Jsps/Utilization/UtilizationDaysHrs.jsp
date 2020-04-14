<%@ page  language="java" import="java.util.*,java.text.SimpleDateFormat,t4u.functions.*,t4u.beans.*,t4u.common.*" pageEncoding="utf-8"%>
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
  ArrayList<String> tobeConverted = new ArrayList<String>();
  tobeConverted.add("Vehicle_Utilization_During_Working_Days_And_Working_Hours");
  tobeConverted.add("Select_Asset_Group");
  tobeConverted.add("Select_Customer_Name");
  tobeConverted.add("Customer_Name");
  tobeConverted.add("Asset_Group");
  tobeConverted.add("Start_Date");
  tobeConverted.add("Select_Start_Date");
  tobeConverted.add("End_Date");
  tobeConverted.add("Select_End_Date");
  tobeConverted.add("Submit");
  tobeConverted.add("Month_Validation");
  tobeConverted.add("SLNO");
  tobeConverted.add("Asset_Number");
  tobeConverted.add("Asset_Type");
  tobeConverted.add("Selected_Days");
  tobeConverted.add("Working_Days");
  tobeConverted.add("Non_Working_Days");
  tobeConverted.add("Utilized_Hrs");
  tobeConverted.add("Distance_Travelled");
  tobeConverted.add("Utilization_In_Working_Days");
  tobeConverted.add("Non_Utilization_In_Working_Days");
  tobeConverted.add("Travel_Time");
  tobeConverted.add("Utilizations");
  tobeConverted.add("Non_Utilization_Percentage");
  tobeConverted.add("No_Records_Found");
  tobeConverted.add("Clear_Filter_Data");
  tobeConverted.add("Reconfigure_Grid");
  tobeConverted.add("Excel");
  tobeConverted.add("Utilization_Details");
  tobeConverted.add("Utilization_Graph");
  tobeConverted.add("Utilization_and_NonUtilization");
  tobeConverted.add("End_Date_Must_Be_Greater_Than_Start_Date");
  tobeConverted.add("Asset_Model");
  
       
 ArrayList<String> convertedWords = new ArrayList<String>();
 convertedWords = cf.getLanguageSpecificWordForKey(tobeConverted,language);
 String VehicleUtilizationDaysHours = convertedWords.get(0);
 String SelectGroup = convertedWords.get(1);
 String SelectCustomer = convertedWords.get(2);
 String CustomerName = convertedWords.get(3);
 String AssetName = convertedWords.get(4);
 String StartDate = convertedWords.get(5);
 String SelectStartDate = convertedWords.get(6);
 String EndDate = convertedWords.get(7);
 String SelectEndDate = convertedWords.get(8);
 String Submit = convertedWords.get(9);
 String monthValidation = convertedWords.get(10);
 String slno = convertedWords.get(11);
 String RegistrationNo = convertedWords.get(12);
 String VehicleType = convertedWords.get(13);
 String SelectedDays = convertedWords.get(14);
 String WorkingDays = convertedWords.get(15);
 String NonWorkingDays = convertedWords.get(16);
 String UtilizedHrs = convertedWords.get(17);
 String Distancetravelled = convertedWords.get(18);
 String UtilizationInWorkingDays = convertedWords.get(19);
 String NonUtilizationInWorkingDays = convertedWords.get(20);
 String TravelTime = convertedWords.get(21);
 String UtilizationPercentage = convertedWords.get(22);
 String NonUtilizationPercentage = convertedWords.get(23);
 String NoRecordsFound = convertedWords.get(24);
 String ClearFilterData = convertedWords.get(25);
 String ReconfigureGrid = convertedWords.get(26);
 String Excel = convertedWords.get(27);
 String UtilizationDetails = convertedWords.get(28);
 String UtilizationGraph = convertedWords.get(29);
 String UtilizationandNonUtilization = convertedWords.get(30);
 String EndDateMustBeGreaterthanStartDate = convertedWords.get(31);
 String AssetModel = convertedWords.get(32);
 
 
%>
<!DOCTYPE HTML>
<html class="largehtml">
 <head>
<style type="text/css">
.x-panel-body-noheader, .x-panel-mc .x-panel-body {
border-top-color: #99bbe8;
height: 433px;
}
</style>
 <title><%=VehicleUtilizationDaysHours%></title>
 </head>
 <body class="largebody">
 <%if (loginInfo.getStyleSheetOverride().equals("Y")){%>
	<jsp:include page="../Common/ImportJSSandMining.jsp"/>
	<%}else {%>
	<jsp:include page="../Common/ImportJS.jsp" /><%} %>
  <!--   for exporting to excel***** -->
 <jsp:include page="../Common/ExportJS.jsp" />
  <script type="text/javascript" src="../../Main/Js/jsapi.js"></script>
  <style>
	.x-panel-bbar-noborder
	{
		margin-top: -12px !important;
	}
	.x-panel-body-noborder {
		width : 1298px !important;
	}
  </style>
  
 <script>
 google.load("visualization", "1", {packages:["corechart"]});
 var outerPanel;
 var ctsb;
 var dtnext = datecur.add(Date.DAY, -1);   
 var dtcur = datecur.add(Date.DAY, -2); 
 var jspName="VehicleUtilizationDuringWorkingDaysAndWorkingHours";
 var exportDataType= "int,string,string,string,string,int,int,int,int,int,int,float,float,int,int";
 
 Ext.EventManager.onWindowResize(function () {
     var width = '100%';
     var height = '100%';
     grid.setSize(width, height);
     outerPanel.setSize(width, height);
     outerPanel.doLayout();
 });
 
 
 
 
 
 //**************************** Store and Combo for Customer Name***************************************************
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
	        				 if(<%=customerId%>>0)
	        				 {
					 			Ext.getCmp('custcomboId').setValue('<%=customerId%>');
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
	    	cls:'selectstylePerfect',
	    	listeners: 
	    	{
                  select: 
                  {
                	   fn:function()
                	   {
                	   		globalClientId=Ext.getCmp('custcomboId').getValue();
                            store.load();
                	   		assetgroupcombostore.load({
							params:{CustId : globalClientId}
							});
					        store.load();
                	   		
					   }
				  }
 			}
 });
 
 //**************************** Store and Combo for Group Name***************************************************
var assetgroupcombostore= new Ext.data.JsonStore({
			url: '<%=request.getContextPath()%>/UtilizationReportsAction.do?param=getAssetGroup',
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
	    	cls:'selectstylePerfect',
	    	listeners: 
	    	{
		         select: 
		         {
		               fn:function()
		               {     
		                    custId: Ext.getCmp('custcomboId').getValue(),
		                 	assetGroup=Ext.getCmp('assetgroupcomboId').getValue();
                        	store.load();
 					   }
 				 }
 			}
 });	

//**************************** Store and Combo for level of Utilization***************************************************
var arrayStore = [['0','Highest Utilization'],['1','Lowest Utilization']];   
var ActiveStore= new  Ext.data.SimpleStore({
			data:arrayStore,
		    fields: ['id','name']
});
			         
var utilizationCombo=new Ext.form.ComboBox({
			frame:true,
		    store: ActiveStore,
			id:'SelectId',
			width: 150,
			forceSelection:true,
			enableKeyEvents:true,
			mode: 'local',
			triggerAction: 'all',
			value:'0',
			displayField: 'name',
			valueField: 'id', 
	        loadingText: 'Searching...',
	        emptyText:'select level',
            minChars:3,
	        	  listeners: {
		                select: {
		                 	 fn:function(){
		                            	    if(Ext.getCmp('SelectId').getValue()=='1')
						            	   {
                                        	lowestUtilization();
						                   }
						                    else 
						                   {
                                            highestUtilization();
						                   }
      		                             }
		                		} 
                             } 
});
 
 //****************************panel for selecting the customer,group,start and end date***************************************************			 
var innerPanel = new Ext.Panel({
		standardSubmit: true,
		collapsible:false,
		cls:'innerpanelgridpercentage1',
		id:'innerpanels',
		border:true,
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
					text: '<%=AssetName%>'+':',
					cls:'labelstyle',
					id:'groupnamelab'
				},
				assetgroupcombo,{width:50},
				{
					xtype: 'label',
					cls:'labelstyle',
					id:'startdatelab',
					text: '<%=StartDate%>'+':'
				},
				{
					xtype:'datefield',
		    		cls:'selectstylePerfect',
		    		format:getDateFormat(),
		    		emptyText:'<%=SelectStartDate%>',
		    		allowBlank: false,
		    		blankText :'<%=SelectStartDate%>',
		    		id:'startdate',
		    		value:dtcur
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
		    		cls:'selectstylePerfect',
		    		format:getDateFormat(),
		    		emptyText:'<%=SelectEndDate%>',
		    		allowBlank: false,
		    		blankText :'<%=SelectEndDate%>',
		    		id:'enddate',
		    		maxValue: dtnext,
		    		value:dtnext
		    	},
	    		{width:50},
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
			       			   // store.load();
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
            		 			
            		 			
            		 			
            		 			
            		 			
            		 			//alert(Ext.getCmp('assetgroupcomboId').getValue());
                                store.load({
				       			params: {
				                        custId: Ext.getCmp('custcomboId').getValue(),
				                        groupId: Ext.getCmp('assetgroupcomboId').getValue(),
				                        startDate: Ext.getCmp('startdate').getValue(),
                            		    endDate:Ext.getCmp('enddate').getValue(),
                            			gname:Ext.getCmp('assetgroupcomboId').getRawValue(),
                            			jspName:jspName,
                            			custName: Ext.getCmp('custcomboId').getRawValue()
				                        }
				                    });
				          }
	       			}
       			}
       		}
       	]
}); 

//**************************** reader config***************************************************
var reader = new Ext.data.JsonReader({
         idProperty: 'darreaderid',
         root: 'utilizationdata',
         totalProperty: 'total',
         fields: [
                   {name: 'slnoIndex'}, 
                   {name: 'groupIndex'}, 
                   {name: 'registrationIndex'}, 
                   {name: 'vehicleTypeIndex'}, 
                   {name: 'assetModelIndex'},
                   {name: 'selectedDaysIndex'},
                   {name: 'workingDaysIndex'},
                   {name: 'nonWorkingDaysIndex'}, 
                   {name: 'utilizationIndex'}, 
                   {name: 'nonUtilizationIndex'}, 
                   {name: 'utilizedhrsIndex'} ,
                   {name: 'travelTimeIndex'},
                   {name: 'distanceTravelledIndex'},
                   {name: 'utilizationPercentageIndex'},
                   {name: 'nonUtilizationPercentageIndex'}
                 ]
});	

//**************************** Store config***************************************************
var store =  new Ext.data.GroupingStore({
        autoLoad:false,
        proxy: new Ext.data.HttpProxy({
        url: '<%=request.getContextPath()%>/UtilizationReportsAction.do?param=getDataForWorkingDaysWorkingHrs',
        method: 'POST'
		}),
		  remoteSort: false,
         sortInfo: {
         field: 'utilizationPercentageIndex',
         direction: 'DESC'
     },
       
        storeId: 'darStore',
        reader:reader
});

//****************************filter config***************************************************
var filters = new Ext.ux.grid.GridFilters({
    local:true,
        filters: [
        {type: 'numeric',dataIndex: 'slnoIndex'}, 
        {type: 'string',dataIndex: 'groupIndex'}, 
        {type: 'string',dataIndex: 'registrationIndex'},
        {type: 'string',dataIndex: 'vehicleTypeIndex'}, 
        {type: 'string',dataIndex: 'assetModelIndex'},
        {type: 'int',dataIndex: 'selectedDaysIndex'},
        {type: 'int',dataIndex: 'workingDaysIndex'},
        {type: 'int',dataIndex: 'nonWorkingDaysIndex'}, 
        {type: 'int',dataIndex: 'utilizationIndex'}, 
        {type: 'int',dataIndex: 'nonUtilizationIndex'}, 
        {type: 'int',dataIndex: 'utilizedhrsIndex'} ,
        {type: 'float',dataIndex: 'travelTimeIndex'},
        {type: 'float',dataIndex: 'distanceTravelledIndex'},
        {type: 'int',dataIndex: 'utilizationPercentageIndex'},
        {type: 'int',dataIndex: 'nonUtilizationPercentageIndex'}
        ]
});    

//****************************column model config***************************************************		
var createColModel = function (finish, start) 
    {
        var columns = [
        new Ext.grid.RowNumberer({header: "<span style=font-weight:bold;><%=slno%></span>",width:40}),
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
            header: "<span style=font-weight:bold;><%=AssetName%></span>",
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
        	header: "<span style=font-weight:bold;><%=VehicleType%></span>",
            dataIndex: 'vehicleTypeIndex',
            filter: 
            {
            	type: 'string'
            }
         }, {
        	header: "<span style=font-weight:bold;><%=AssetModel%></span>",
            dataIndex: 'assetModelIndex',
            filter: 
            {
            	type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;><%=SelectedDays%></span>",
            dataIndex: 'selectedDaysIndex',
            filter: {
            type: 'int'
            }
        },
        {
            header: "<span style=font-weight:bold;><%=WorkingDays%></span>",
            dataIndex: 'workingDaysIndex',
            filter: {
            type: 'int'
            }
        }, {
            header: "<span style=font-weight:bold;><%=NonWorkingDays%></span>",
            dataIndex: 'nonWorkingDaysIndex',
            filter: {
            type: 'int'
            }
        }, {
            header: "<span style=font-weight:bold;><%=UtilizationInWorkingDays%></span>",
            dataIndex: 'utilizationIndex',
            filter: {
            type: 'int'
            }
        }, 
        {
            header: "<span style=font-weight:bold;><%=NonUtilizationInWorkingDays%></span>",
            dataIndex: 'nonUtilizationIndex',
            filter: {
            type: 'int'
            }
        }, 
        {
            header: "<span style=font-weight:bold;><%=UtilizedHrs%></span>",
            dataIndex: 'utilizedhrsIndex',
            filter: {
            type: 'int'
            }
         },
         {
            header: "<span style=font-weight:bold;><%=TravelTime%></span>",
            dataIndex: 'travelTimeIndex',
            filter: {
            type: 'float'
            }
          },
          {
            header: "<span style=font-weight:bold;><%=Distancetravelled%></span>",
            dataIndex: 'distanceTravelledIndex',
            filter: {
            type: 'float'
            }
            },
          {
            header: "<span style=font-weight:bold;><%=UtilizationPercentage%></span>",
            dataIndex: 'utilizationPercentageIndex',
            
            filter: {
            type: 'int'
            }
          },
          {
            header: "<span style=font-weight:bold;><%=NonUtilizationPercentage%></span>",
            dataIndex: 'nonUtilizationPercentageIndex',
           filter: {
            type: 'int'
            }
          }
       ]
       

     return new Ext.grid.ColumnModel({
          columns: columns.slice(start || 0, finish),
          defaults: {
                sortable: true
            }
        });
 };
    
   //**************************** grid panel config***************************************************
var grid = getGrid('<%=VehicleUtilizationDaysHours%>', '<%=NoRecordsFound%>', store, screen.width - 60, 362, 16, filters, '<%=ClearFilterData%>', true, '<%=ReconfigureGrid%>', 15, false, '', false, '', true, '<%=Excel%>', jspName, exportDataType, true, 'PDF');
   
    //**************************** panel for tabs***************************************************
var utilizationTabs = new Ext.TabPanel({
	    resizeTabs: false, // turn off tab resizing
	    enableTabScroll:false,
	    activeTab: 'revenueGridTab',
	    id: 'mainTabPanelId',
	    frame:true,
	    height:390,
	    width: screen.width-43,
	    listeners: {
	    	        'tabchange': function(tabPanel, tab){
            	    if(tab.id == 'graphTab')
            	    {
            	      highestUtilization();
					  Ext.getCmp('innerpanels').disable();
					}
					else
					{
				      Ext.getCmp('innerpanels').enable();
				      if(Ext.getCmp('SelectId').getValue()=='1')
				      {
				        Ext.getCmp('SelectId').setValue('0');
				      }
					}
            	}
              }
});

	//**************************** panel for graph***************************************************
var graphPannel = new Ext.Panel({
                id:'levelid',
	     		border:false,
	     		autoScroll:true,
	     		height: 330,
	     		cls: 'mainpanelpercentage',
	     		layout: 'fit',
            	html : '<table width="100%"><tr><tr> <td> <div id="utilizationchartdiv" align="center"> </div></td></tr></table>'
            	
});
    addTab();

	
       function addTab() {
            utilizationTabs.add({
	        title: '<%=UtilizationDetails%>',
	        iconCls: 'admintab',
	        id: 'revenueGridTab',
	        items: [grid]
	    }).show();

	        utilizationTabs.add({
	        title: '<%=UtilizationGraph%>',
	        iconCls: 'admintab',
	        autoScroll:false,
	        frame:true,
	        id: 'graphTab',
	        items:[utilizationCombo,graphPannel]
	    }).show();
	   } 
	 //**************************** graph for highestUtilization***************************************************   
	   function highestUtilization() {
			var barchartutilizationgraph = new google.visualization.ColumnChart(document.getElementById('utilizationchartdiv'));
            var barchartutilizationdata = new google.visualization.DataTable();
            barchartutilizationdata.addColumn('string', 'Count');
            barchartutilizationdata.addColumn('number', 'Utilization(%) During Working Days(during working HRS');
            barchartutilizationdata.addColumn('number', 'Non Utilization(%) During Working Days(during working HRS)');
            var rowdata = new Array();
            var utilizationsubdivision='';
            var count=0;
  			var utilization=0;
  			var nonutilization=0;
  			var storeCount = store.getCount();
  			var noRecord=20;
  			if(storeCount<20){
  			       noRecord=store.getCount();
  			       
  			}
  			
  			for  (var i = 0; i < noRecord; i++){
				var rec = store.getAt(i);
				utilizationsubdivision=rec.data['registrationIndex'];
				if(store.getCount()!=1 && i!=store.getCount()-1 && utilizationsubdivision==store.getAt(i+1).data['registrationIndex'])
				   {
					 utilization=parseInt(utilization)+parseInt(rec.data['utilizationPercentageIndex']);
					 nonutilization=parseInt(nonutilization)+parseInt(rec.data['nonUtilizationPercentageIndex']);
					 continue;
				   }
				else if(store.getCount()!=1 && i==store.getCount()-1 && utilizationsubdivision==store.getAt(i-1).data['registrationIndex'])
				   {
					 utilization=parseInt(utilization)+parseInt(rec.data['utilizationPercentageIndex']);
					 nonutilization=parseInt(nonutilization)+parseInt(rec.data['nonUtilizationPercentageIndex']);
				   }
				else
				   {
					 utilization=parseInt(utilization)+parseInt(rec.data['utilizationPercentageIndex']);
					 nonutilization=parseInt(nonutilization)+parseInt(rec.data['nonUtilizationPercentageIndex']);
				   }
				rowdata.push(utilizationsubdivision);
                rowdata.push(Math.round(utilization)*1);
                rowdata.push(Math.round(nonutilization)*1);
                utilization=0;
                nonutilization=0;
                count++;
                }
            barchartutilizationdata.addRows(count+1); 
            var k = 0;
            var m=0;
            var n=0;
          for (i = 0; i <count; i++) {
               for (j = 0; j <= 2; j++) {
                           rowdata[k];
              	           var rec = store.getAt(i);
                           barchartutilizationdata.setCell(i, j,  rowdata[k]);
                           k++;
               }
            }
            count=0;
			var options = {
                title: '<%=VehicleUtilizationDaysHours%>',
                titleTextStyle: {
                   align: 'center',
                   fontSize: 15
                },
                pieSliceText: "value",
                legend: {
                    position: 'right',
                   textStyle: {color: 'black', fontSize:12}

                },
               sliceVisibilityThreshold:0,
               width:1000,
               height:400,
               isStacked: false,
               hAxis:{title:'<%=RegistrationNo%>',textStyle:{fontSize: 10},titleTextStyle: { italic: false}},
               vAxis:{title:'<%=UtilizationandNonUtilization%>',titleTextStyle: { italic: false} }
          };
          barchartutilizationgraph.draw(barchartutilizationdata, options);
 }
 
//**************************** graph for lowestUtilization***************************************************   
        function lowestUtilization() {
			var barchartutilizationgraph = new google.visualization.ColumnChart(document.getElementById('utilizationchartdiv'));
            var barchartutilizationdata = new google.visualization.DataTable();
            barchartutilizationdata.addColumn('string', 'Count');
            barchartutilizationdata.addColumn('number', 'Utilization(%) During Working Days(during working HRS)');
            barchartutilizationdata.addColumn('number', 'Non Utilization(%) During Working Days(during working HRS)');
            var rowdata = new Array();
            var utilizationsubdivision='';
            var count=0;
  			var utilization=0;
  			var nonutilization=0;
  			 var lastTwenty = 20;

     if (store.getCount() < 20) {
     
         lastTwenty = 0;
     }
     if (store.getCount() > 20) {
         lastTwenty = store.getCount()-20;
     }
     		 for (var i = store.getCount() - 1; i >= lastTwenty; i--) {
				var rec = store.getAt(i);
				utilizationsubdivision=rec.data['registrationIndex'];
				if(store.getCount()!=1 && i!=store.getCount()-1 && utilizationsubdivision==store.getAt(i+1).data['registrationIndex'])
						{
							utilization=parseInt(utilization)+parseInt(rec.data['utilizationPercentageIndex']);
							nonutilization=parseInt(nonutilization)+parseInt(rec.data['nonUtilizationPercentageIndex']);
							continue;
						}
				else if(store.getCount()!=1 && i==store.getCount()-1 && utilizationsubdivision==store.getAt(i-1).data['registrationIndex'])
						{
							utilization=parseInt(utilization)+parseInt(rec.data['utilizationPercentageIndex']);
							nonutilization=parseInt(nonutilization)+parseInt(rec.data['nonUtilizationPercentageIndex']);
						}
				else
						{
							utilization=parseInt(utilization)+parseInt(rec.data['utilizationPercentageIndex']);
							nonutilization=parseInt(nonutilization)+parseInt(rec.data['nonUtilizationPercentageIndex']);
						}
				rowdata.push(utilizationsubdivision);
                rowdata.push(Math.round(utilization)*1);
                rowdata.push(Math.round(nonutilization)*1);
                utilization=0;
                nonutilization=0;
                count++;
                }
            barchartutilizationdata.addRows(count+1); 
            var k = 0;
            var m=0;
            var n=0;
           for (i = 0; i <count; i++) {
               for (j = 0; j <= 2; j++) {
                     rowdata[k];
              	     var rec = store.getAt(i);
                     barchartutilizationdata.setCell(i, j,  rowdata[k]);
                     k++;
               }
           }
          count=0;
		  var options = {
                  title: '<%=VehicleUtilizationDaysHours%>',
                  titleTextStyle: {
                         align: 'center',
                         fontSize: 17
                },
                pieSliceText: "value",
                legend: {
                    position: 'right',
                    textStyle: {color: 'black', fontSize:12}
                },
                sliceVisibilityThreshold:0,
                width:1000,
                height:400,
                isStacked: false,
                hAxis:{title:'<%=RegistrationNo%>',textStyle:{fontSize: 10},titleTextStyle: { italic: false}},
                vAxis:{title:'<%=UtilizationandNonUtilization%>',titleTextStyle: { italic: false} }
            };
            barchartutilizationgraph.draw(barchartutilizationdata, options);
 }
 
 //****************************start***************************************************      					
 Ext.onReady(function()
    {
	ctsb=tsb;
	Ext.QuickTips.init();
	Ext.form.Field.prototype.msgTarget = 'side';		         	   			
 	outerPanel = new Ext.Panel({
 			title:'<%=VehicleUtilizationDaysHours%>',
			renderTo: 'content',
            standardSubmit: true,
            //height:545,
            width:screen.width-24,
			frame: true,
            cls: 'mainpanelpercentage',
            layout: 'fit',
			items: [innerPanel,utilizationTabs]
			//bbar:ctsb			
			}); 
			sb = Ext.getCmp('form-statusbar');
});
 </script>
 </body>
</html>
