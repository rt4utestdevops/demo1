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
	loginInfo.setCountryCode(Integer.parseInt(str[11].trim()));
	session.setAttribute("loginInfoDetails",loginInfo);
	
}
	
	CommonFunctions cf = new CommonFunctions();
	LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
	cf.checkLoginInfo((LoginInfoBean) session.getAttribute("loginInfoDetails"), session, request, response);
	String responseaftersubmit="''";
	String feature="1";
	if (loginInfo == null) {
		response.sendRedirect(request.getContextPath()
				+ "/Jsps/Common/SessionDestroy.html");
	} else {
		session.setAttribute("loginInfoDetails", loginInfo);
		String language = loginInfo.getLanguage();
		int systemId = loginInfo.getSystemId();
		int customerId = loginInfo.getCustomerId();

ArrayList<String> tobeConverted = new ArrayList<String>();

tobeConverted.add("Modified_Date_Time");
tobeConverted.add("Add");
tobeConverted.add("Modify");
tobeConverted.add("No_Records_Found");
tobeConverted.add("Clear_Filter_Data");
tobeConverted.add("SLNO");
tobeConverted.add("Id");
tobeConverted.add("Delete");
tobeConverted.add("No_Rows_Selected");
tobeConverted.add("Select_Single_Row");
tobeConverted.add("Save");
tobeConverted.add("Cancel");
tobeConverted.add("Excel");



ArrayList<String> convertedWords = new ArrayList<String>();
convertedWords = cf.getLanguageSpecificWordForKey(tobeConverted,language);

String ModifiedDateTime=convertedWords.get(0);
String Add=convertedWords.get(1);
String Modify=convertedWords.get(2);
String NoRecordsFound=convertedWords.get(3);
String ClearFilterData=convertedWords.get(4);
String SLNO=convertedWords.get(5);
String ID=convertedWords.get(6);
String Delete=convertedWords.get(7);
String NoRowsSelected=convertedWords.get(8);
String SelectSingleRow=convertedWords.get(9);
String Save=convertedWords.get(10);
String Cancel=convertedWords.get(11);
String Excel=convertedWords.get(12);


int userId=loginInfo.getUserId(); 

%>
<!DOCTYPE HTML>
<html>
 <head>
 		<title>Rake Approval </title>		
</head>	    
	 <style>
  .x-panel-tl
	{
		border-bottom: 0px solid !important;
	}
  </style>
  <body>
 		 <table align="center">
			<tr>
				<td id="container"></td>
			</tr>
		</table>
  
   <%if (loginInfo.getStyleSheetOverride().equals("Y")){%>
	<jsp:include page="../Common/ImportJSSandMining.jsp"/>
	<jsp:include page="../IronMining/css.jsp" />
	<%}else{%>
	<jsp:include page="../Common/ImportJS.jsp" />
	<jsp:include page="../IronMining/css.jsp" />
	<%}%>
   <jsp:include page="../Common/ExportJS.jsp" />
   <script>
   
var outerPanel;
var ctsb;
var jspName = "Rake Approval";
var exportDataType = "";
var selected;
var grid;
var buttonValue;
var titelForInnerPanel;
var myWin;
var editedRows = "";
var globalClientId = "";
var editedRows = "";  
var newSpareAdd=0;


var userDS;
var fueltyprname="";
var price="";
<%--var totalDiesel='<%=DieselRequired%>'; --%>
var totalDiesel=400
var RemainingDiesel="0";
var remaiming=0;
var tot=0;
var amount=0;

		var vendorStore =new Ext.data.JsonStore({
				   url:'<%=request.getContextPath()%>/RakeShiftBookingAction.do?param=getVendorNames',
				   root: 'vendornames',
			       autoLoad: true,
				   fields: ['vendorid','vendorname','priceperlit']
			     });
		   var vendorStoreActive =new Ext.data.JsonStore({
				   url:'<%=request.getContextPath()%>/RakeShiftBookingAction.do?param=getActiveVendorNames',
				   root: 'vendornames',
			       autoLoad: true,
				   fields: ['vendorid','vendorname','priceperlit']
			     });	
		
		
			 var vendorCombo = new Ext.form.ComboBox({
			   standardSubmit: true,
			   selectOnFocus:true,
			   forceSelection: true,
			   store: vendorStoreActive,
			   displayField: 'vendorname',
			   resizable:true,
			   valueField: 'vendorid', 
			   id:'vendorid',	
			   mode: 'local',	
			   triggerAction: 'all',
			  labelSeparator: '',
			  enableKeyEvents:true
			
               });
//============================ Grid table creation ================================
		//********** reader *************
     	var reader = new Ext.data.JsonReader({
        idProperty: 'darreaderid',
        root: 'ContainerInfoRoot',
        totalProperty: 'total',
        fields: [{
        	name: 'SLNODataIndex'
        },{
        	name: 'UniqueIdIndex'
        },{
        	name: 'vendorNameDataIndex'
        },{ 
        	name: 'priceDataIndex'
        },{
            name: 'fuelRequiredDataIndex',
        }, {
            name: 'amountDataIndex'
        }]
    });
    
    var plantForIssueSpares = Ext.data.Record.create([
		    {name:'SLNODataIndex'},
		    {name:'uniqueIdDataIndex'},
		    {name:'vendorNameDataIndex'},
            {name:'priceDataIndex'},
            {name:'fuelRequiredDataIndex'},
            {name:'amountDataIndex'}
	]);
//********** store *****************
		var userDS = new Ext.data.GroupingStore({
        autoLoad: false,
        proxy: new Ext.data.HttpProxy({
           	url: '<%=request.getContextPath()%>/RakeShiftBookingAction.do?param=getContainerData',
            method: 'POST'
        }),
        remoteSort: false,
        storeId: 'darstore',
        reader: reader
    	});
    	//*********** filters **********
var filters = new Ext.ux.grid.GridFilters({
        local: true,
        filters: [{
            type: 'numeric',
            dataIndex: 'SLNODataIndex'
        }, {
            type: 'numeric',
            dataIndex: 'UniqueIdIndex'
        }, {
            type: 'string',
            dataIndex: 'vendorNameDataIndex'
        },{
            type: 'numeric',
            dataIndex: 'priceDataIndex'
        },{
            type: 'numeric',
            dataIndex: 'fuelRequiredDataIndex'
        }, {
            type: 'numeric',
            dataIndex: 'amountDataIndex'
        }]
      });
var createColModel = function (finish, start) {

        var columns = [
            new Ext.grid.RowNumberer({
                header: "<span style=font-weight:bold;><%=SLNO%></span>",
                width: 50
            }),{
                dataIndex: 'SLNODataIndex',
                hidden: true,
                header: "<span style=font-weight:bold;><%=SLNO%></span>",
                filter: {
                    type: 'numeric'
                }
            },{
                dataIndex: 'UniqueIdIndex',
                hidden: true,
                width: 40,
                header: "<span style=font-weight:bold;>UID</span>",
                filter: {
                    type: 'numeric'
                }
            },{
                dataIndex: 'vendorNameDataIndex',
                hidden: false,
                header: "<span style=font-weight:bold;>Vendor Name</span>",
                editor: new Ext.grid.GridEditor(vendorCombo),
				renderer:renderVendor,
				width: 50,
                filter: {
                    type: 'string'
                }
            },{
                header: "<span style=font-weight:bold;>Price/Litre</span>",
                dataIndex: 'priceDataIndex',
                hidden: false,
				sortable: true,
                width: 40,
                filter: {
                    type: 'numeric'
                }
            },{
                header: "<span style=font-weight:bold;>Fuel Required</span>",
                dataIndex: 'fuelRequiredDataIndex',
                hidden: false,
				sortable: true,
                width: 40,
                filter: {
                    type: 'numeric'
                },
                editor: new Ext.grid.GridEditor(new Ext.form.NumberField({
                allowNegative: false
                }))
            }, {
        		header: "<span style=font-weight:bold;>Amount</span>",
           	 	dataIndex: 'amountDataIndex',
           	 	hidden: false,
				sortable: true,
				width: 40,
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
    
Grid = getEditorGrid('', '<%=NoRecordsFound%>', userDS, 490, 240, 7, filters, '<%=ClearFilterData%>', false, '', 7, false, '', false, '', false, '<%=Excel%>', jspName, exportDataType, false, 'PDF',false,'<%=Add%>');

function getEditorGrid(gridtitle,emptytext,store,width,height,gridnoofcols,filters,filterstr,reconfigure,reconfigurestr,reconfigurenoofcols,group,groupstr,chart,chartstr,excel,excelstr,jspName,exportDataType,pdf,pdfstr,add,addstr,modify,modifystr,del,delstr){
	 var grid = new Ext.grid.EditorGridPanel({
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
	        plugins: [filters],
	        clicksToEdit: 1,
	        bbar: new Ext.Toolbar({
	        }),
	         tbar: [{
             text: '<b>Add</b>',
             handler: function() {
             var a=parseFloat(tot);
        				var b= parseFloat(totalDiesel);
        				if(a >= b)
  						{
								Ext.example.msg("Cannot Add Any Vendors!!");
                       			return;
  						}
    					newSpareAdd++;
    					if(newSpareAdd > 1){
    							Ext.example.msg("Please save the present row before adding another row...");
                       			return;
    					}
               			var p = new plantForIssueSpares({
					    SLNODataIndex : "new"+newSpareAdd,												     
						uniqueIdDataIndex :"",
						vendorNameDataIndex :"",
					    priceDataIndex :"",
			            fuelRequiredDataIndex:"",
			            amountDataIndex:"",
						ADDataIndex:""
           				  
                     });
                     editedRows = editedRows+"new"+newSpareAdd+",";
		      		 if(Grid.store.data.length==0)
		      		 {
 				         Ext.getCmp('grid').view.emptyText="";
 				         Ext.getCmp('grid').view.refresh();
 				     }
			         Ext.getCmp('grid').stopEditing();
		             Ext.getCmp('grid').store.insert(0, p);
			         Grid.startEditing(0, 2);
			         if(Grid.store.data.length==1)
			         {
 				        Ext.getCmp('grid').view.emptyText="No records found";
 				        Ext.getCmp('grid').view.refresh();
 				     }
             }
             }, '-', {
             text: '<b>Save<b>',
             handler: function() {
       <%--      var json = '';
       					var valid = true; 
       						
       					if(editedRows=="")
						{
							Ext.example.msg("No Rows Has Changed To Save!!");
                       		return;
						}
            			temp=editedRows.split(",");
 			 			isIn=0
 			 			for(var i=0;i<temp.length;i++)
 			 			{
  			 				var row = Grid.store.find('SLNODataIndex',temp[i]);
  			 				if(row==-1)
  			 				{
			 					continue;
							}
							var store = Grid.store.getAt(row);
							if(store.data['vendorNameDataIndex'] =="" )
							{
								Ext.example.msg("Select Vendor Name ");
                       			return;
							}
																						
							if(store.data['fuelRequiredDataIndex'] =="" )
							{
								Ext.example.msg("Please enter Fuel Required");
                       			return;
							}
							
							json += Ext.util.JSON.encode(store.data) + ',';
  			 			}
  			 							
  			 			if(remaiming > 0 || remaiming < 0 )
						{
							if(remaiming > 0)
							{
	             				Ext.example.msg("Please Allocate All The Diesel And Then Save.");
                       			return;
	             			}
	             			else
	             			{
	             				sb.setStatus({
			                       text:'You Cannot Allocate More Diesel Than That Should Be Allocated.', 
        			               iconCls:'',
                			       clear: true
                        		});
	             				Ext.example.msg("You Cannot Allocate More Diesel Than That Should Be Allocated.");
                       			return;
	             			}
						}
  			 			if(valid==false)
  						{
  							return;
  						}
  						else if(json!='')
						{
							json = json.substring(0, json.length - 1);
						}
  										
  						sb.showBusy('Saving form...');

						outerPanel.getEl().mask();
               	Ext.Ajax.request({
							url:'<%=request.getContextPath()%>/AllocateFuel.do?param=save',
							method: 'POST',
							params: {jasondata:json,ClientId:<%=clientId%>,TripId:'<%=TripId%>',subTrip:'<%=subtripId%>',AdditionalDiesel:'<%=AdditionalDiesel%>'},

							success:function(response, options)
							{
								if(response.responseText == "Unable to insert.Please try again.")
								{
									totalDiesel = '<%=DieselRequired%>';
									Ext.getCmp('total2').setText('Diesel Need To Be Allocated:  '+totalDiesel+' Litre.');
									tot = 0;
								}
								temp=editedRows.split(",");
								if(temp.length>4)
			   					{
			   						sb.autoClear=30000;
			   					}
			   					else
			   					{
			   						sb.autoClear=10000;
			   					}

								sb.setStatus({
			                       text:response.responseText,  
        			               iconCls:'',
                			       clear: true
                        		});   
                        				    
                     			userDS.load({
									params:{ClientId:<%=clientId%>,TripId:'<%=TripId%>',subTrip:'<%=subtripId%>'}
								});				
											
							//	setTimeout('window.parent.refresh("Trip")',500)
											
							//	setTimeout('window.parent.refresh("SubTrip")',500)
											
								editedRows = "";
								outerPanel.getEl().unmask();
							},// End of Sucess function
							failure: function() 
							{
								editedRows = "";
								outerPanel.getEl().unmask();
							}// end of failure
										
                    	});// End of Ajax Request  --%>
             }
             }, '-', {
             text: '<b>Refresh<b>',
             handler: function() {
             Grid.store.reload();
             addPlant = 0;
             editedRows = "";
             }
             }, '-', {
             text: '<b>Remove Filters<b>',
             handler: function() {
             Grid.filters.clearFilters();
             addPlant = 0;
             editedRows = "";
             }
             }
             ]
	    });
	if(width>0){
		grid.setSize(width,height);

	}
	if(reconfigure){
		grid.getBottomToolbar().add([
			{
            text: reconfigurestr,
            handler: function () {
			grid.reconfigure(store, createColModel(reconfigurenoofcols));
            } 
        }]);
		}
	return grid;
}

				Grid.on({	
						afteredit: function(e)
						 {
						 	//alert();
							var field=e.field;
							var rec=e.record;
							var  bId = e.record.data['SLNODataIndex'];
							var temp=editedRows.split(",")
							
							isIn=0
							for(var i=0;i<temp.length;i++)
							{
								if(temp[i]==bId)
								{
									isIn=1
								}
							}
							if(isIn==0)
							{
								editedRows = editedRows+bId+",";
							}
							if(field=="vendorNameDataIndex")
							{
								var ven=e.record.data['vendorNameDataIndex'] ;
								
								var idx = vendorStore.findBy(function(record) 
      							{
        							if(record.get('vendorid') == ven) 
        							{
            							price = record.get('priceperlit');
            							e.record.set('priceDataIndex',price);
            							var fuelreq=e.record.data['fuelRequiredDataIndex'] ;
            							amount=parseFloat(fuelreq)*parseFloat(price);
            							if(parseFloat(amount)>0){
            							e.record.set('amountDataIndex',amount.toFixed(2));
            							}
        							}
    							});
							
							}
							if(field=="fuelRequiredDataIndex")
							{
								var fuelreq=e.record.data['fuelRequiredDataIndex'] ;
								var pricelit=e.record.data['priceDataIndex'] ;
								amount=parseFloat(fuelreq)*parseFloat(pricelit);
								 tot=0;
								e.record.set('amountDataIndex',amount.toFixed(2));
								temp=editedRows.split(",");
  			 					isIn=0
  			 					for(var i=0;i<temp.length;i++)
  			 					{
  			 					
  			 						var row = Grid.store.find('SLNODataIndex',temp[i]);
			 						if(row==-1)
			 						{
	 									continue;
									}
  			 					
  			 						var store = Grid.store.getAt(row);
  			 						
  			 						tot = tot + (parseFloat(store.data['fuelRequiredDataIndex']) ) ;
  			 					}
  			 					
<!--								for(var  i= 0 ;i <Grid.store.data.items.length;i++)-->
<!--								{-->
<!--									var rec = Grid.store.getAt(i);-->
<!--									tot = tot + (parseFloat(rec.data['fuelRequiredDataIndex']) ) ;-->
<!--								}-->
								tot=tot.toFixed(2);
								
								remaiming= (parseFloat(totalDiesel)-parseFloat(tot)).toFixed(2);
								//alert(remaiming);
								Ext.getCmp('total2').setText('Remaining Diesel Should Be Allocated:  '+remaiming+' Litre.');
								
							}
									
						}
					});// End Of Grid On
					
					var UGrid = function () 
							{
				 
								return {
								init : function () 
								{
	  								Grid.on({
       	 								"cellclick":{fn: onCellClick }
    									});
		
			
								},
								getDS : function () 
								{
										return userDS;
								}
								}
							}();
							
							
  function onCellClick(grid, rowIndex, columnIndex,e) 
		{ 
      		var r = Grid.store.getAt(rowIndex);
       		var clientId = r.data['SLNODataIndex'];
       		var newClient  = "";
	   		if(clientId.length>3)
	   		{
				newClient = clientId.substring(0,3);
	    	}
	   		
				if(!(newClient=="new"))
				{
           			Grid.getColumnModel().config[columnIndex].editable=false;
        		}
        		else
        		{
	        		Grid.getColumnModel().config[columnIndex].editable=true;
    	
        		}
       		
       }
       
     	 function renderVendor(value, p, r) 
     {
	 	var returnValue="";
	 	if(vendorStore.isFiltered())
		{
			vendorStore.clearFilter();
			          
		}
      	var idx = vendorStore.findBy(function(record) 
      	{
        	if(record.get('vendorid') == value) 
        	{
            	returnValue = record.get('vendorname');
            	return true;
        	}
    	});
 	 	return returnValue;
	}
	Ext.onReady(UGrid.init, UGrid, true);
	
		 function renderVendor(value, p, r) 
     {
	 	var returnValue="";
	 	if(vendorStore.isFiltered())
		{
			vendorStore.clearFilter();
			          
		}
      	var idx = vendorStore.findBy(function(record) 
      	{
        	if(record.get('vendorid') == value) 
        	{
            	returnValue = record.get('vendorname');
            	return true;
        	}
    	});
 	 	return returnValue;
	}	
	
	
	var panel1= new Ext.Panel({
                layout:'table',
                // frame:true,
                id:'id1',
				layoutConfig: {
					columns:1
				},
				items: [{
       				 	xtype: 'label',
       				 	//text:  'Diesel Should Be Allocated:  '+totalDiesel+' Litre.',
       				 	text:'Diesel Should Be Allocated : 350 Litre',
       				 	cls: 'myStyle',
       				 	id:'total1',
       				 	width : 250
    					}]
				});	 
	
    var panel2= new Ext.Panel({
                layout:'table',
                // frame:true,
                id:'id2',
				layoutConfig: {
					columns:1
				},
				items: [{
       				 	xtype: 'label',
       				 	//text:  ' Diesel Need To Be Allocated:  '+totalDiesel+' Litre.',
       				 	text: 'Diesel Need To Be Allocated: 200 Litre', 
       				 	cls: 'myStyle',
       				 	id:'total2',
       				 	width : 350
    					}]
				});
 	
 	
 				var total= new Ext.Panel({
                layout:'table',
                //frame:true,
               <%-- hidden:<%=Values%>, --%>
                id:'main',
				layoutConfig: {
					columns:1
				},
				items: [panel1,{height:10},panel2]
				});	 
				
				
Ext.onReady(function() {
    Ext.QuickTips.init();
    Ext.form.Field.prototype.msgTarget = 'side';
    outerPanel = new Ext.Panel({
        title: 'Fuel Allocation',
        id:'outerPanelId',
        renderTo: 'container',
        standardSubmit: true,
        frame: true,
        width : 500,
	    height : 360,
        cls: 'outerpanel',
        layout: 'table',
        layoutConfig: {
            columns: 1
        },
        items: [Grid,total]
    }); // END OF OUTER	PANEL	
    vendorStore.load();
    vendorStoreActive.load();
 	});// END OF ONREADY()
</script>
</body>
</html>
<%}%>