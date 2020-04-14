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
	if(str.length>11){
	loginInfo.setCountryCode(Integer.parseInt(str[11].trim()));
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
	%>
<jsp:include page="../Common/header.jsp" />
    <title>SandPortQuantityUpdation</title>

  <style>
  .x-panel-tl
	{
		border-bottom: 0px solid !important;
	}

	#totalExclab, #dispatchedLab,#availableLab{
		font-weight: 700;
    	font-size: small;
	}
  </style>
 
   <%if (loginInfo.getStyleSheetOverride().equals("Y")){%>                  
    <jsp:include page="../Common/ImportJSSandMining.jsp"/>                                              
   <%}else {%>  
   <jsp:include page="../Common/ImportJS.jsp" />
   <%} %>
    <!-- for exporting to excel***** -->
   <jsp:include page="../Common/ExportJS.jsp" />
   <style>
		label {
			display : inline !important;
		}
		.ext-strict .x-form-text {
			height: 21px !important;
		}
		.x-window-tl *.x-window-header {
			padding-top : 6px !important;
			height : 36px !important;
		}
		.x-layer ul {
		 	min-height: 27px !important;
		}
		.selectstylePerfect {			
			width: 146px !important;
		}
   </style>
   <script>
    var outerPanel;
 	var ctsb;
 	var dtprev = currentDate;
 	var dtcur = nextDate;
 	var jspName="SandPortQuantityUpdation";
 	var exportDataType="int,date,string,string,string,string,date";
 	var selected;
 	var grid;
 	var buttonValue;
 	var title;
 	var myWin;
 	var tatalAvailable;
 	var totalDispatched;
 	//override function for showing first row in grid
 	Ext.override(Ext.grid.GridView, {
    	afterRender: function(){
        this.mainBody.dom.innerHTML = this.renderRows();
        this.processRows(0, true);
        if(this.deferEmptyText !== true){
            this.applyEmptyText();
        }
        this.fireEvent("viewready", this);//new event
    	}   
	});
	
	//*****************************Quantity Measure store*************************************//
var quantityMeasureStore = new Ext.data.SimpleStore({
    id: 'quantityMeasureId',
    fields: ['quantityMeasure'],
    data: [['CuM'],['Tonn']]
});

//******************************Quantity Measure Combo****************************************************//
var quantityMeasureCombo = new Ext.form.ComboBox({
    store: quantityMeasureStore,
    id: 'quantityMeasurecomboId',
    mode: 'local',
    forceSelection: true,
    emptyText: 'Select Quantity Measure',
    blankText: 'Select Quantity Measure',
    selectOnFocus: true,
    allowBlank: true,
    anyMatch: true,
    typeAhead: false,
    triggerAction: 'all',
    lazyRender: true,
    valueField: 'quantityMeasure',
    displayField: 'quantityMeasure',
    cls: 'selectstylePerfect',
    listeners: {
        select: {
            fn: function() {
            
            }
          }
   		} 
   	 }); 
 //******************************Sand Port Store***************************************************
	  var sandPortStore= new Ext.data.JsonStore({
           url: '<%=request.getContextPath()%>/SandBlockManagementAction.do?param=getSandPortList',
           id: 'sandPortStoreId',
		   root: 'sandPortStoreRoot',
		   autoload: true,
		   remoteSort: true,
		   fields: ['PortName','PortId']
	});
 
//******************************Sand Port Combo****************************************************//
var sandPortCombo = new Ext.form.ComboBox({
    store: sandPortStore,
    id: 'sandPortcomboId',
    mode: 'local',
    forceSelection: true,
    emptyText: 'Select Sand Port',
    blankText: 'Select Sand Port',
    selectOnFocus: true,
    allowBlank: true,
    anyMatch: true,
    typeAhead: false,
    triggerAction: 'all',
    lazyRender: true,
    valueField: 'PortId',
    displayField: 'PortName',
    cls: 'selectstylePerfect',
    listeners: {
        select: {
            fn: function() {
           		Ext.getCmp('excavationQtyDI').reset(); 
            	Ext.getCmp('quantityMeasurecomboId').reset();
            }
          }
   		} 
   	 });
	
	//**************************** datePanel ***********************************************		
	var datePanel = new Ext.Panel({
        standardSubmit: true,
        collapsible: false,
        id: 'dateMasterId',
        layout: 'table',
        frame: true,
        layoutConfig: {
            columns: 10
        },
        items: [{width:30},
			    {
			    xtype: 'label',
			    text : 'Start Date' + ':',
			    cls: 'labelstyle',
			    id: 'startdatelab',
			    width:60
			    },{width:10},
			    {
  		            xtype: 'datefield',
  		            cls: 'selectstylePerfect',
  		            width: 185,
  		            format: getDateTimeFormat(),
  		            emptyText: 'Select Start Date',
  		            allowBlank: false,
  		            blankText: 'Select Start Date',
  		            id: 'startdate',
  		            value: dtprev,
  		            vtype: 'daterange',
  		            endDateField: 'enddate'
  		        },{width:40},
			    {
			    xtype: 'label',
			    text : 'End Date' + ':',
			    cls: 'labelstyle',
			    id: 'enddatelab',
			    width:60
			    },{width:10},
			    {
  		            xtype: 'datefield',
  		            cls: 'selectstylePerfect',
  		            width: 185,
  		            format: getDateTimeFormat(),
  		            emptyText: 'Select End Date',
  		            allowBlank: false,
  		            blankText: 'Select End Date',
  		            id: 'enddate',
  		            value: dtcur,
  		            vtype: 'daterange',
  		            startDateField: 'startdate'
  		        },{width:40},
			    { 
			    	xtype:'button',
			    	text:'View',
			    	id: 'addbuttonid',
			    	width:80,
			    	hidden:false,
			    	listeners: 
	       			{
		        		click:
		        		{
			       			fn:function()
			       			{
							    if(Ext.getCmp('startdate').getValue() == "" )
							    {
						             Ext.example.msg("Select Start Date");
						             Ext.getCmp('startdate').focus();
				                     return;
							    }
							    if(Ext.getCmp('enddate').getValue() == "" )
							    {
						             Ext.example.msg("Select End Date");
						             Ext.getCmp('enddate').focus();
				                     return;
							    }
							    
							    var startdates=Ext.getCmp('startdate').getValue();
            		 			var enddates=Ext.getCmp('enddate').getValue();
            		 			
            		 			var d1 = new Date(startdates);
            		 			var d2 = new Date(enddates);
            		 			
               		 			if(d1>d2)
            		 			{
									Ext.example.msg("startDateEndDateValication");
									return;
								}	
								
								if (checkMonthValidation(startdates, enddates)) {
  		                           Ext.example.msg("Difference between From date and To date cannot be greater than 1 month");
  		                           Ext.getCmp('enddate').focus();
  		                           return;
  		                       }
  		                                  		 			 
				       			Store.load({
				                        params: {
				                            startDate: Ext.getCmp('startdate').getValue(),
                            				endDate:Ext.getCmp('enddate').getValue(),
                            				jspName:jspName
                       				}
				                });
				                totalDispatchedStore.load({
				                		params: {
				                			startDate: Ext.getCmp('startdate').getValue(),
                            				endDate:Ext.getCmp('enddate').getValue()
                            		}
                            	});
				                
			       			}
	       				}
       				}
			    }	
        	]
   		 }); // End of innerPanel
   		 
 	//********* innerPanel ********	
   	var innerPanel = new Ext.Panel({
        standardSubmit: true,
        collapsible: false,
        id: 'innerPanelId',
        layout: 'table',
        height:30,
        frame: true,
        layoutConfig: {
            columns: 9
        },
        items: [{width:30},
        		{
                	xtype: 'label',
                	text: 'Total Excavated' + ' :',
                	cls: 'labelstyle',
                	id: 'totalExclab',
                	width:80
            	},
            	{
                	xtype: 'label',
                	text: '',
                	cls: 'labelstyle',
                	id: 'totalExclabId',
                	width: 80
            	},
            	{width:180},
            	{
                	xtype: 'label',
                	text: 'Total Dispatched '+' :',
                	cls: 'labelstyle',
                	id: 'dispatchedLab',
                	width: 80
            	},
            	{
            		xtype: 'label',
                	text: '',
                	cls: 'labelstyle',
                	id: 'dispatchedLabId',
                	width: 80
            	},{width:180},
            	{
                	xtype: 'label',
                	text: 'Total Available '+' :',
                	cls: 'labelstyle',
                	id: 'availableLab',
                	width: 80
            	},
            	{
            		xtype: 'label',
                	text: '',
                	cls: 'labelstyle',
                	id: 'availableLabId',
                	width: 80
            	}
        	 ]
   		 });
   		 
   	//********************************************* Inner Pannel Window **************************************************************************************	 
   
   	var innerPanelWindow = new Ext.Panel({
        standardSubmit: true,
        collapsible: false,
        autoScroll: false,
        height: 260,
        width: '100%',
        frame: true,
        id: 'innerPanelWindowId',
        layout: 'table',
        layoutConfig: {
            columns: 3
        },
         items: [
         	{
                cls: 'mandatoryfield'
            },{
                cls: 'labelstyle'
            },{
                cls: 'labelstyle'
            },
         	{
            	xtype:'label',
            	text:'*',
            	cls:'mandatoryfield',
            	id:'mandatorydate'
            	},
            {
                xtype: 'label',
                text: 'Date Of Excavation'+' :',
                cls: 'labelstyle',
                id: 'DateValuetxt'
            },
            {
            	xtype: 'datefield', 
            	cls: 'selectstylePerfect', 
            	id: 'DateValueid',
            	//editable:false,
  		        format: getDateTimeFormat(),
  		        allowBlank: false,
  		        value: dtcur,
  		        vtype: 'daterange',
            	maxValue: dtprev
            },
            {
            	xtype:'label',
            	text:'*',
            	cls:'mandatoryfield',
            	id:'mandatorySandPort'
            	},
            {
                xtype: 'label',
                text: 'Sand Port'+' :',
                cls: 'labelstyle',
                id: 'sandPorttxt'
            },sandPortCombo,
            {
            	xtype:'label',
            	text:'*',
            	cls:'mandatoryfield',
            	id:'mandatoryExcQty'
            	},
            {
                xtype: 'label',
                text: 'Excavation Quantity'+' :',
                cls: 'labelstyle',
                id: 'ExcavationQtytxt'
            },{
                xtype: 'numberfield',
                cls: 'selectstylePerfect',               
                emptyText: 'Enter Excavation Quantity',
                blankText: 'Enter Excavation Quantity',
                maxLength: 10,
                decimalPrecision : 3,
                id: 'excavationQtyDI',
                allowBlank: false,
                allowNegative: false
              },
            {
            	xtype:'label',
            	text:'*',
            	cls:'mandatoryfield',
            	id:'mandatoryQty'
            	},
            {
                xtype: 'label',
                text: 'Quantity Measure'+' :',
                cls: 'labelstyle',
                id: 'QtyMeasuretxt'
            },quantityMeasureCombo
            
        ]
       
    }); 
    
   	 
     var winButtonPanel = new Ext.Panel({
        id: 'winbuttonid',
        standardSubmit: true,
        collapsible: false,
        autoHeight: true,
        height: 50,
        width: '100%',
        frame: true,
        layout: 'table',
        layoutConfig: {
            columns: 4
        },
        buttons:[{
            xtype: 'button',
            text: 'Save',
            id: 'addButtId',
            iconCls:'savebutton',
            cls: 'buttonstyle',
            width: 70,
            listeners: {
                click: {
                fn: function () {
              	if(Ext.getCmp('DateValueid').getValue() == "" )
					{
						Ext.example.msg("select Date Of Excavation ");
						Ext.getCmp('DateValueid').focus();
				    	return;
					}
				if(Ext.getCmp('DateValueid').getValue() >dtcur )
					{
						Ext.example.msg("Entered Date Should Be Less Than Current Date");
						Ext.getCmp('DateValueid').focus();
				    	return;
					}
				if(Ext.getCmp('sandPortcomboId').getValue() == "" )
					{
						Ext.example.msg("Select Sand Port");
						Ext.getCmp('sandPortcomboId').focus();
				        return;
					}
				if(Ext.getCmp('excavationQtyDI').getValue() == "" )
					{
						 Ext.example.msg("Enter Excavation Quantity");
						 Ext.getCmp('excavationQtyDI').focus();
				         return;
					}
				if(Ext.getCmp('quantityMeasurecomboId').getValue() == "" )
					{
						 Ext.example.msg("Select Quantity Measure");
						 Ext.getCmp('quantityMeasurecomboId').focus();
				         return;
					}
					outerPanelWindow.getEl().mask();
                        Ext.Ajax.request({
                        	url: '<%=request.getContextPath()%>/SandBlockManagementAction.do?param=saveSandPortQuantity',
                            method: 'POST',
                            params: {
                                buttonValue: buttonValue,
                                dateVal: Ext.getCmp('DateValueid').getValue(),
                                sandPort: Ext.getCmp('sandPortcomboId').getRawValue(),
                                sandPortId: Ext.getCmp('sandPortcomboId').getValue(),
                                excavatedQty: Ext.getCmp('excavationQtyDI').getValue(),                              
                                qtyMeasure: Ext.getCmp('quantityMeasurecomboId').getValue()
                            },
                            success: function (response, options) {
                                var str=response.responseText;
								var array = str.split(",");
								var message = array[0];
								var groupid = array[1];
				       	  		Store.load({
				          			params: {
				            			startDate: Ext.getCmp('startdate').getValue(),
                            			endDate:Ext.getCmp('enddate').getValue(),
                            			jspName:jspName
                       	    			}
				       			});
				       			totalDispatchedStore.load({
				                		params: {
				                			startDate: Ext.getCmp('startdate').getValue(),
                            				endDate:Ext.getCmp('enddate').getValue()
                            		}
                            	});
				       		Ext.example.msg(message);
                                outerPanelWindow.getEl().unmask();
                                myWin.hide();

                            },
                            failure: function () {

                                Ext.example.msg("Error");
                                outerPanelWindow.getEl().unmask();  
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
            iconCls:'cancelbutton',
            cls: 'buttonstyle',
            width: 70,
            listeners: {
                click: {
                    fn: function () {
                        myWin.hide();
						
                    }
                }
            }
        }]

    });
   		 
   	 var outerPanelWindow = new Ext.Panel({
        width: '100%',
        height:330,
        standardSubmit: true,
        frame: false,
        items: [innerPanelWindow, winButtonPanel]
    });
    	 
   	 myWin = new Ext.Window({
        title: title,
        closable: false,
        resizable:false,
        modal: true,
        autoScroll: false,
        height: 365,
        width: '40%',
        id: 'myWin',
        items: [outerPanelWindow]
    });
   		
   //*************************************Function for ADD button*******************
   function addRecord() {
		Ext.getCmp('DateValueid').setValue(new Date);
        buttonValue = "add";
        titel = 'Add Excavation Quantity';
        myWin.show();
        myWin.setTitle(titel);
        sandPortStore.load();
        
        Ext.getCmp('DateValueid').reset();
        Ext.getCmp('sandPortcomboId').reset();
        Ext.getCmp('sandPortcomboId').reset();
        Ext.getCmp('excavationQtyDI').reset();                              
        Ext.getCmp('quantityMeasurecomboId').reset();
   }		
		//*********************************Grid table creation*********************************
		//********** reader *************
     	var reader = new Ext.data.JsonReader({
        idProperty: 'darreaderid',
        root: 'sandPortQuantityRoot',
        totalProperty: 'total',
        fields: [{
        	name: 'slnoIndex'
        },{
            name: 'dateExcavationIndex',
            type: 'date',
  		    dateFormat: getDateTimeFormat()
        }, {
            name: 'sandPortIndex'
        }, {
            name: 'excavatedQtyIndex'
        }, {
            name: 'QtyMeasureIndex'
        }, {
            name: 'createdByIndex'
        }, {
            name: 'createdDateIndex',
            type: 'date',
  		    dateFormat: getDateTimeFormat()
        }, {
        }]
    });
		//********** store *****************
		
		var totalExcavation=0;
		var Store = new Ext.data.GroupingStore({
        autoLoad: false,
        proxy: new Ext.data.HttpProxy({
        	url: '<%=request.getContextPath()%>/SandBlockManagementAction.do?param=getSandPortQuantityData',
            method: 'POST'
        }),
        remoteSort: false,
        storeId: 'datastore',
        reader: reader,
        listeners: {
        'load' :  {
            fn : function(store,records,options) {
                 totalExcavation=0;
				 Store.each(function(rec) {
				       totalExcavation = totalExcavation + parseFloat(rec.get('excavatedQtyIndex'));				       
				 });
				 Ext.getCmp('totalExclabId').setText(totalExcavation.toFixed(2));				
				
				 
            	}
        	}
    	}
    	});
    	
    	//********** Total Dispatched store *****************
		var totalDispatchedStore= new Ext.data.JsonStore({
           url: '<%=request.getContextPath()%>/SandBlockManagementAction.do?param=getTotalDispatchedDetails',
           id: 'totalDispatchedStoreId',
		   root: 'totalDispatchedStoreRoot',
		   autoload: true,
		   remoteSort: true,
		   fields: ['quantity'],
		    listeners: {
        	'load' :  {           
            fn : function(store,records,options) {                               
				 totalDispatchedStore.each(function(rec) {
				 var quantityDispached= parseFloat(rec.get('quantity'));
				 var aval = totalExcavation-quantityDispached;
				       Ext.getCmp('dispatchedLabId').setText(quantityDispached);
				       Ext.getCmp('availableLabId').setText(aval.toFixed(2));
				 });
            }
         }
      }
	});
    	
		//*********** filters **********
		var filters = new Ext.ux.grid.GridFilters({
        local: true,
        filters: [{
            type: 'numeric',
            dataIndex: 'slnoIndex'
        }, {
            type: 'date',
            dataIndex: 'dateExcavationIndex'
        }, {
            type: 'string',
            dataIndex: 'sandPortIndex'
        }, {
            type: 'string',
            dataIndex: 'excavatedQtyIndex'
        }, {
            type: 'string',
            dataIndex: 'QtyMeasureIndex'
        }, {
            type: 'string',
            dataIndex: 'createdByIndex'
        }, {
            type: 'date',
            dataIndex: 'createdDateIndex'
        }]
      });	
	
//************************************Column Model Config******************************************	
    	var createColModel = function (finish, start) {

        var columns = [
            new Ext.grid.RowNumberer({
                header: "<span style=font-weight:bold;>SLNO</span>",
                width: 50
            }),{
                dataIndex: 'slnoIndex',
                hidden: true,
                header: "<span style=font-weight:bold;>SLNO</span>",
                filter: {
                    type: 'numeric'
                }
            }, {
        		header: "<span style=font-weight:bold;>Date Of Excavation</span>",
           	 	dataIndex: 'dateExcavationIndex',
            	renderer: Ext.util.Format.dateRenderer(getDateTimeFormat()),
            	filter: {
            	type: 'date'
            	}
        	}, {
                header: "<span style=font-weight:bold;>Sand Port</span>",
                dataIndex: 'sandPortIndex',
                width: 100,
                filter: {
                    type: 'string'
                }
            }, {
                header: "<span style=font-weight:bold;>Excavated Quantity</span>",
                dataIndex: 'excavatedQtyIndex',
                width: 100,
                filter: {
                    type: 'string'
                }
            }, {
                header: "<span style=font-weight:bold;>Quantity Measure</span>",
                dataIndex: 'QtyMeasureIndex',
                filter: {
                    type: 'string'
                }
            }, {
                header: "<span style=font-weight:bold;>Created By</span>",
                dataIndex: 'createdByIndex',
                filter: {
                    type: 'string'
                }
            }, {
        		header: "<span style=font-weight:bold;>Created Date</span>",
           	 	dataIndex: 'createdDateIndex',
            	renderer: Ext.util.Format.dateRenderer(getDateTimeFormat()),
            	filter: {
            	type: 'date'
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
	//***************************getGrid *******************************	
	summaryGrid = getGrid('', 'NoRecordsFound', Store, screen.width - 35, 425, 8, filters, 'ClearFilterData', false, '', 8, false, '', false, '', true, 'Excel', jspName, exportDataType, false, 'PDF',true,'Add');
	
	//*********************main starts from here*************************
 	Ext.onReady(function(){
	ctsb=tsb;
	Ext.QuickTips.init();
	Ext.form.Field.prototype.msgTarget = 'side';			         	   			
 	outerPanel = new Ext.Panel({
			title:'Daily Excavated Quantity Updation',
			renderTo : 'content',
			standardSubmit: true,
			frame:true,
			cls:'outerpanel',
			border:false,
			items: [datePanel,innerPanel,summaryGrid]  
			//bbar:ctsb			
			}); 
			
			
	});
	
    </script>
   <jsp:include page="../Common/footer.jsp" />
 <!-- </body>   -->
 <!-- </html> -->