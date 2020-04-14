<%@ page  language="java" import="java.util.*,t4u.functions.CommonFunctions,t4u.beans.*,t4u.common.*" pageEncoding="utf-8"%>
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
		session.setAttribute("loginInfoDetails",loginInfo);
	}
	CommonFunctions cf=new CommonFunctions();
	cf.checkLoginInfo((LoginInfoBean)session.getAttribute("loginInfoDetails"),session,request,response);
	LoginInfoBean loginInfo=(LoginInfoBean)session.getAttribute("loginInfoDetails");
	String language=loginInfo.getLanguage();
	int customeridlogged=loginInfo.getCustomerId();
	
	//getting hashmap with language specific words
	HashMap langConverted=ApplicationListener.langConverted;
	
	String SelectCustomer=cf.getLabelFromDB("Select_Customer",language);
	String CustomerName=cf.getLabelFromDB("Customer_Name",language);
	String Submit=cf.getLabelFromDB("Submit",language);
	String NoRecordsFound=cf.getLabelFromDB("No_Records_Found",language);
	String assetGroupHubAssociation=cf.getLabelFromDB("Asset_Group_Hub_Association",language);
	String selectAssetGroup=cf.getLabelFromDB("Select_Asset_Group",language);
	String assetGroup=cf.getLabelFromDB("Asset_Group",language);
	String disAssociate=cf.getLabelFromDB("Dis_Associate",language);
	String loadingRecordPleaseWait=cf.getLabelFromDB("Loading_Record_Please_Wait",language);
	String associatedHubs=cf.getLabelFromDB("Associated_Hubs",language);
	String hubName=cf.getLabelFromDB("Hub_Name",language);
	String hubId=cf.getLabelFromDB("Hub_Id",language);
	String associate=cf.getLabelFromDB("Associate",language);
	String nonAssociatedHubs=cf.getLabelFromDB("Non_Associated_Hubs",language);
	String savingform=cf.getLabelFromDB("Saving_Form",language);
	String pleaseSelectHub=cf.getLabelFromDB("Please_Select_Hub",language);
	String ClearFilterData=cf.getLabelFromDB("Clear_Filter_Data",language);
	
%>

<!DOCTYPE HTML>
<html class="largehtml">
  <head>
<style>
.x-tab-panel-body .x-tab-panel-body-top
 {
       height: 532px;
 }
 </style>
  	<title><%=assetGroupHubAssociation%></title>
  </head>
  <body class="largebody" onload="refresh();">
  <%if (loginInfo.getStyleSheetOverride().equals("Y")){%>
<jsp:include page="../Common/ImportJSSandMining.jsp"/>
<%}else {%>
<jsp:include page="../Common/ImportJS.jsp" /><%} %>
  <script>
   
	  var outerPanel;
	  var ctsb;
	  var globalClientId;
	  var assetGroup;
	  var associateHubs;
	  var disassociateHubs;
	  
	  //In chrome activate was slow so refreshing the page
 function refresh()
                 {
                 isChrome = window.chrome;
					if(isChrome && parent.flagDemo<2) {
					// is chrome
						              setTimeout(function(){
						              parent.Ext.getCmp('AssetGroupHubAssociationTab').enable();
									  parent.Ext.getCmp('AssetGroupHubAssociationTab').show();
						              parent.Ext.getCmp('AssetGroupHubAssociationTab').update("<iframe style='width:100%;height:600px;border:0;'src='<%=path%>/Jsps/DemoCar/AssetGroupHubAssociation.jsp'></iframe>");
						              },0);
						              parent.DemoCarTab.doLayout();
						              parent.flagDemo= parent.flagDemo+1;
					} 
                 }
                 /********************resize window event function***********************/
   	 Ext.EventManager.onWindowResize(function () {
   				var width = '100%';
			    var height = '100%';
				firstGrid.setSize(width, height);
			    secondGrid.setSize(width, height);
			    //outerPanel.setSize(width, height);
			    outerPanel.doLayout();
			});
	  //This function is called when associate button is clicked.
	  function associate()
	  {
				var records = firstGrid.selModel.getSelections();
				associateHubs="";
				for (var i = 0, len = records.length; i < len; i++)
				{
	    			var store =  records[i];
	    			var hubId = store.get('HubIdDataIndex'); 
	    			associateHubs = associateHubs + hubId + ",";
	 			}
	 				
	  
  				if(associateHubs=="" )
  				{
					 Ext.example.msg("<%=pleaseSelectHub%>");
                     return;
                }
                      	 
      			                                  
				ctsb.showBusy('<%=savingform%>');
			    outerPanel.getEl().mask();
				Ext.Ajax.request({
	  		    url    : '<%=request.getContextPath()%>/AssetGroupHubAssociationAction.do?param=Associate',
				method : 'POST',
				params : {
				          associateHubs:associateHubs,
				          globalClientId:globalClientId,
				          assetGroup:assetGroup
				          },
				success:function(response, options)
				{
				  			 Ext.example.msg(response.responseText); 
	                       	 firstGridStore.reload();   
							 secondGridStore.reload();  
							 outerPanel.getEl().unmask();
							                  	 
				},
				 failure: function()
				 {
							 firstGridStore.reload();   
							 secondGridStore.reload(); 
							 outerPanel.getEl().unmask();
							                   	 
				 } 
			
 	  		});
		
		
	  }
	  //This function is called when dis-associate button is clicked.
	  function disassociate()
	  {
				var records = secondGrid.selModel.getSelections();
				disassociateHubs="";
				for (var i = 0, len = records.length; i < len; i++)
				{
	    			var store =  records[i];
	    			var hubId = store.get('HubIdDataIndex'); 
	    			disassociateHubs = disassociateHubs + hubId + ",";
	 			}
	 
	  
  				if(disassociateHubs=="" )
  				{
					  Ext.example.msg("<%=pleaseSelectHub%>");
                      return;
                }
                      	 
      			                                  
				ctsb.showBusy('<%=savingform%>');
			    outerPanel.getEl().mask();
				Ext.Ajax.request({
	  		    url    : '<%=request.getContextPath()%>/AssetGroupHubAssociationAction.do?param=DisAssociate',
				method : 'POST',
				params : {
				          disassociateHubs:disassociateHubs,
				          globalClientId:globalClientId,
				          assetGroup:assetGroup
				          },
				success:function(response, options)
				{
				  			 Ext.example.msg(response.responseText);
	                       	 firstGridStore.reload();   
							 secondGridStore.reload();  
							 outerPanel.getEl().unmask();
							                  	 
				 },
				 failure: function()
				 {
							 firstGridStore.reload();   
							 secondGridStore.reload(); 
							 outerPanel.getEl().unmask();
							                   	 
				 } 
			
 	  		}); // END OF AJAX
		
		
		}
		
	  //This is to get the check box column in grid
	  var sm1= new Ext.grid.CheckboxSelectionModel({ 
	  checkOnly: true
         });
         
      //This is to get the check box column in grid   
	  var sm2= new Ext.grid.CheckboxSelectionModel({
	  checkOnly: true
		 });

 	  //Reader for a grid,which is called from grid store the root id given here should be unique. 	
	  var reader1 = new Ext.data.JsonReader({
		    root      : 'reader1root',
            fields	  : [
						  {name:'HubNameDataIndex', type:'string'},
						  {name:'HubIdDataIndex', type:'string'}
			            ] 
      });

	//filter for each column should be defined here.
	var filters1 = new Ext.ux.grid.GridFilters({
	local   : true,
	filters :[
				{dataIndex:'HubNameDataIndex', type:'string'},
				{dataIndex:'HubIdDataIndex', type:'string'}
				
			]
		}); 
	//column model to declare columns required in a grid
	var cols1 = new Ext.grid.ColumnModel( [sm1,
		{ 
		  header:'<b><%=hubName%></b>', 
		  width:380, 
		  sortable: true, 
		  dataIndex: 'HubNameDataIndex'
		},
		{ 
		  header:'<b><%=hubId%></b>', 
		  width: 100, 
		  sortable: true, 
		  hidden:true,
		  dataIndex: 'HubIdDataIndex'
		}
	]);

 	//Store for a grid	
	var firstGridStore = new Ext.data.Store({
      	url	  		: '<%=request.getContextPath()%>/AssetGroupHubAssociationAction.do?param=getNonAssociatedHubsData',
        bufferSize	: 367,
		reader		: reader1,
		autoLoad    : true,
		remoteSort  :true	
    });
 
 	//grid declaration	
	var firstGrid = new Ext.grid.GridPanel({
       title		: '<%=nonAssociatedHubs%>', 
       id			: 'firstGrid',
       ds			: firstGridStore,
       frame		: true,
       cm			: cols1,
	   view 	    : new Ext.grid.GridView({
	                  nearLimit : 3,
                      loadMask : {msg : '<%=loadingRecordPleaseWait%>'},
         		      emptyText:'<%=NoRecordsFound%>' 
			          }),
	   plugins	   : [filters1],			          
       stripeRows  : true,
       height	   : 320,
       width	   : 510,
       autoScroll  : true,
	   loadMask    : {msg: '<%=loadingRecordPleaseWait%>'},
       sm          : sm1,
       tbar		   :
					[
					{
		 			text: '<%=ClearFilterData%>',
		 			handler: function()
		 			{
		 				firstGrid.filters.clearFilters();
					}			
					}/*,'-',{
		 			text:'Refresh',
		 			handler: function()
		 			{
		 				firstGridStore.reload();
					}			
					}*/,'-',{
		 			text:'<%=associate%>',
		 			handler: function()
		 			{
		 				associate();
					}			
					}
					]       

	}); 


	var reader2 = new Ext.data.JsonReader({
		    root      : 'reader2root',
            fields	  : [
						  {name:'HubNameDataIndex', type:'string'},
						  {name:'HubIdDataIndex', type:'string'}
						  
			            ] 
      });


	var filters2 = new Ext.ux.grid.GridFilters({
	local   : true,
	filters :[
				{dataIndex:'HubNameDataIndex', type:'string'},
				{dataIndex:'HubIdDataIndex', type:'string'}
				
			]
		}); 

	var cols2 = new Ext.grid.ColumnModel( [sm2,
		{ 
		  header:'<b><%=hubName%></b>', 
		  width:380, 
		  sortable: true, 
		  dataIndex: 'HubNameDataIndex'
		},
		{ 
		  header:'<b><%=hubId%></b>', 
		  width: 100, 
		  sortable: true, 
		  hidden:true,
		  dataIndex: 'HubIdDataIndex'
		}
	]);


	var secondGridStore = new Ext.data.Store({
      	url	      : '<%=request.getContextPath()%>/AssetGroupHubAssociationAction.do?param=getAssociatedHubsData',
        bufferSize: 367,
		reader	  : reader2,
		autoLoad  : true,
		remoteSort: true	
    }); 

 	var secondGrid = new Ext.grid.GridPanel({
       title		: '<%=associatedHubs%>',
       id			: 'secondGrid',
       ds			: secondGridStore,
       cm			: cols2,
	   view 		: new Ext.grid.GridView({
	             	  nearLimit : 3,
                      loadMask : {msg : '<%=loadingRecordPleaseWait%>'},
         		      emptyText: '<%=NoRecordsFound%>'
			           }),
	   plugins	    : [filters2],			           
       stripeRows	: true,
       frame		: true,
       height		: 320,
       width		: 510,
       autoScroll	:true,
	   loadMask		: {msg: '<%=loadingRecordPleaseWait%>'},
       sm			: sm2,
       tbar			:
					[
					{
		 			text:'<%=ClearFilterData%>',
		 			handler: function()
		 			{
		 				secondGrid.filters.clearFilters();
					}			
					}/*,'-',{
		 			text:'Refresh',
		 			handler: function()
		 			{
		 				secondGridStore.reload();
					}			
					}*/,'-',{
		 			text:'<%=disAssociate%>',
		 			handler: function()
		 			{
		 				disassociate();
					}			
					}
					]

	   });
	  
	   var assetgroupcombostore= new Ext.data.JsonStore({
			url:'<%=request.getContextPath()%>/UtilizationReportsAction.do?param=getAssetGroupExceptAll',
				   id:'GroupStoreId',
			       root: 'assetGroupRoot',
			       autoLoad: true,
			       remoteSort: true,
				   fields: ['groupId','groupName']
				
	  });
	  
	  var assetgroupcombo=new Ext.form.ComboBox({
	        store: assetgroupcombostore,
	        id:'assetgroupcomboId',
	        mode: 'local',
	        forceSelection: true,
	        emptyText:'<%=selectAssetGroup%>',
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
		                 	secondGridStore.load();
		                 	firstGridStore.load();
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
    					load: function(store, records, success, options) 
    					{
	        				 if(<%=customeridlogged%>>0)
	        				 {
					 			Ext.getCmp('custcomboId').setValue('<%=customeridlogged%>');
					 			globalClientId=Ext.getCmp('custcomboId').getValue();
			                 	Ext.getCmp('assetgroupcomboId').setValue('');
			                 	secondGridStore.load();
			                 	firstGridStore.load();
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
		                 	globalClientId=Ext.getCmp('custcomboId').getValue();
		                 	Ext.getCmp('assetgroupcomboId').setValue('');
		                 	secondGridStore.load();
		                 	firstGridStore.load();
		                 	assetgroupcombostore.load({
							params:{CustId : globalClientId}
							});
 					   }
 				 }
 			}
 	  });
	  
	 
	  
	  var innerPanel1 = new Ext.Panel({
	  standardSubmit: true,
	  collapsible:false,
	  cls:'innerpaneloneinchheightpercentage',
	  id:'innerPanel1',
	  layout:'table',
	  layoutConfig: 
	  {
		columns:7
	  },
	  items: [
				{
					xtype: 'label',
					text: '<%=CustomerName%>'+' :',
					cls:'labelstyle',
					id:'custnamelab'
				},
				custnamecombo,{width:50}
				,
				{
					xtype: 'label',
					text: '<%=assetGroup%>'+' :',
					cls:'labelstyle',
					id:'assetgrouplab'
				},
				assetgroupcombo,{width:50},
	    		{
	       			xtype:'button',
	      			text:'<%=Submit%>',
	        		id:'addbuttonid',
	        		cls:' ',
	        		width:60,
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
						              Ext.example.msg("<%=selectAssetGroup%>");
						              Ext.getCmp('assetgroupcomboId').focus();
				                      return;
							    }
							    firstGridStore.load({
								params:{globalClientId : globalClientId,assetGroup:assetGroup}
								});
								
								secondGridStore.load({
								params:{globalClientId : globalClientId,assetGroup:assetGroup}
								});
							    
			    
       						}
       					}
       				}
       			}
       		]
	  }); 
	
	  		
	

 	   var innerpanel2 = new Ext.Panel({
		standardSubmit: true,
	    collapsible:false,
	    id:'innerpanel2',
	    height:490,
	    layout:'table',
		layoutConfig: {columns:3},
		items    	: [
						firstGrid,
						secondGrid
					  ]
	  }); 
	
	  Ext.onReady(function()
	  {
		ctsb=tsb;
		Ext.QuickTips.init();
		Ext.form.Field.prototype.msgTarget = 'side';		         	   			
	 	outerPanel = new Ext.Panel({
				title:'<%=assetGroupHubAssociation%>',
				renderTo : 'content',
				standardSubmit: true,
				height:500,
				width:screen.width-35,
				frame:true,
				//cls:'mainpanelpercentage1',
				layout:'fit',
				items: [innerPanel1,innerpanel2]
				//bbar:ctsb			
				}); 
	  });		
	
  </script>
  </body>
</html>
