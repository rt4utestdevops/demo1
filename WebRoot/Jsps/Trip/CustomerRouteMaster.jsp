<%@ page  language="java" import="java.util.*,t4u.functions.*,t4u.beans.*,t4u.common.*" pageEncoding="utf-8"%>

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
	LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");	
	String language = loginInfo.getLanguage();	
	int systemId = loginInfo.getSystemId();	
	int customerId = loginInfo.getCustomerId();	
	int userId = loginInfo.getUserId();	
	
	ArrayList<String> tobeConverted=new ArrayList<String>();	
	tobeConverted.add("Customer_Name");
	tobeConverted.add("Select_Customer");
	
	tobeConverted.add("Customer_Route_Details");
	tobeConverted.add("SLNO");
	tobeConverted.add("Customer_Location_Name");
	tobeConverted.add("Hub_Name");
	tobeConverted.add("Created_By");
	tobeConverted.add("Created_Time");
	
	tobeConverted.add("Customer_Route_Information");
	tobeConverted.add("Route_Code");
	tobeConverted.add("Enter_Route_Code");
	tobeConverted.add("Select_Hub");
	
	tobeConverted.add("Add_Customer_Information");
	tobeConverted.add("Add");
	tobeConverted.add("Edit");
	tobeConverted.add("Save");
	tobeConverted.add("Close");
	
	tobeConverted.add("No_Records_Found");
	tobeConverted.add("Clear_Filter_Data");
	tobeConverted.add("Select_Single_Row");
	tobeConverted.add("Edit_Customer_Route_Information");
	tobeConverted.add("Customer_Route_Master");
	
	ArrayList<String> convertedWords=new ArrayList<String>();
	convertedWords=cf.getLanguageSpecificWordForKey(tobeConverted, language);	
	
	String CustomerName = convertedWords.get(0);
	String SelectCustomer = convertedWords.get(1);
	
	String CustomerRouteDetails = convertedWords.get(2);
	String SlNO = convertedWords.get(3);
	String CustomerLocationName = convertedWords.get(4);
	String HubName = convertedWords.get(5);	
	String CreatedBy = convertedWords.get(6);
	String CreatedTime = convertedWords.get(7);
	
	String CustomerRouteInformation = convertedWords.get(8);
	String RouteCode = convertedWords.get(9);
	String EnterRouteCode = convertedWords.get(10);
	String SelectHub = convertedWords.get(11);
	
	String AddCustomerInformation = convertedWords.get(12);
	String Add = convertedWords.get(13);
	String Edit = convertedWords.get(14);
	String Save = convertedWords.get(15);
	String Close = convertedWords.get(16);
	
	String NoRecordsFound = convertedWords.get(17);
	String ClearFilterData = convertedWords.get(18);
	String SelectSingleRow = convertedWords.get(19);
	String EditCustomerRouteInformation = convertedWords.get(20); 
	String CustomerRouteMaster = convertedWords.get(21); 	
%>

<jsp:include page="../Common/header.jsp" />
		<title><%= CustomerRouteMaster %></title>		
	
  	<%if (loginInfo.getStyleSheetOverride().equals("Y")){%>
<jsp:include page="../Common/ImportJSSandMining.jsp"/>
<%}else {%>
<jsp:include page="../Common/ImportJS.jsp" /><%} %>	
	<style>
		.ext-strict .x-form-text {
			height : 21px !important;
		}
		.x-window-tl *.x-window-header {
			height : 33px !important;
		}
		label
		{
			display : inline !important;
		}
		.footer {
			bottom : -18px !important;
		}
		.x-layer ul {
		 	min-height: 27px !important;
		}
	</style>
	
   	<script>
    var outerPanel;
    var ctsb;
    var title;
    var myWin;
    var buttonValue;
    var dtprev;
    var customerRouteGrid;
    var buttonValue;
    var selected;
    
   	
    var clientNameStore = new Ext.data.JsonStore({
        url: '<%=request.getContextPath()%>/CommonAction.do?param=getCustomer',
        id: 'clientNameStoreId',
        root: 'CustomerRoot',
        autoLoad: true,
        remoteSort: true,
        fields: ['CustId', 'CustName'],
        listeners: {
            load: function (clientNameStore, records, success) {
             if ( <%= customerId %> > 0) {
          Ext.getCmp('clientId').setValue('<%=customerId%>');
          clientId = Ext.getCmp('clientId').getValue();              
            }
            clientId = Ext.getCmp('clientId').getValue(); 
               store.load({
                       params: {
                           clientId: clientId
                        }
                  });      
                   
                 }
            }
       });

    var custnamecombo = new Ext.form.ComboBox({
        store: clientNameStore,
        id: 'clientId',
        mode: 'local',
        fieldLabel:'<%= CustomerName%>',
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
                fn: function () {
                    clientId = Ext.getCmp('clientId').getValue();
                    store.load({
                       params: {
                           clientId: clientId
                        }
                  });
                  hubStore.load({
                  params:{clientId: Ext.getCmp('clientId').getValue()}
                  });
                 }
            }
        }
    });
  
  var hubStore = new Ext.data.JsonStore({
		    url: '<%=request.getContextPath()%>/CustomerRouteMasterAction.do?param=getHubNames',
		    id: 'hubNameStoreId',
		    root: 'hubNameList',
		    autoLoad: true,
		    remoteSort: true,
		    params: {
                           clientId: Ext.getCmp('clientId').getValue()
                        },
		    fields: ['hubid', 'hubname']
		});
		
		
	 var Hubcombo = new Ext.form.ComboBox({								
   				store: hubStore,										 
   			    fieldLabel:'<%=SelectHub%> ',												
   				displayField:'hubname',										
   				valueField:'hubid',											
   				typeAhead: true,
   				width:200,
   				cls:'selectstylePerfect',
   				mode: 'local',												
   				triggerAction: 'all',
   				id:'hubid',											
   				emptyText:'<%=SelectHub%>',
   				selectOnFocus:true,
    			listeners: {
		                   select: {
		                 	   fn:function(){
		                 	   var HubName= Ext.getCmp('hubid').getValue();
		              
		                 	   }
		                 	   }
		                 	   }
			});
    
      var customerInnerPanel = new Ext.form.FormPanel({
        standardSubmit: true,
        title: '<%=CustomerRouteInformation%>',
        collapsible: false,       
        height: 120,
        labelWidth: 50,        
        frame: true,
        id: 'addCustomerRouteInfo',
		layout: 'table',
        layoutConfig: {
            columns: 3
        },
        items: [{
                xtype: 'label',
                text: '*',
                cls: 'mandatoryfield',
                id: 'routeCodeLableId1'
            },{
                xtype: 'label',
                text: '<%=RouteCode%> :',
                cls: 'labelstyle',
                id: 'routeCodeLableId'
            },
            {
                xtype: 'textfield',
                cls: 'selectstylePerfect',                
                emptyText: '<%=EnterRouteCode%>',
                blankText: '<%=EnterRouteCode%>',   
                id: 'routeCodeID'                
            },{
                xtype: 'label',
                text: '*',
                cls: 'mandatoryfield',
                id: 'routeCodeLableId2'
            },{
                xtype: 'label',
                text: '<%= SelectHub%> :',
                cls: 'labelstyle',
                id: 'hubLableId'
            },
               Hubcombo
            ]
       });
       
       var winButtonPanel = new Ext.Panel({
        id: 'winbuttonid',
        standardSubmit: true,
        collapsible: false,
        buttonAlign : 'center',
        cls: 'windowbuttonpanel',
        frame: true,
        height: 40,
        layout: 'table',
        layoutConfig: {
            columns: 3
        },
        items: [{
            width: 280
        }, {
            xtype: 'button',
            text: '<%=Save%>',
            id: 'addButtId',
           	cls: 'buttonstyle',
           	buttonAlign : 'center',
            iconCls: 'savebutton',
            width: 80,
            listeners: {
                click: {
                    fn: function () {                       
                        if (Ext.getCmp('routeCodeID').getValue().trim() == "") {
                        	Ext.example.msg("<%=EnterRouteCode%>");
							Ext.getCmp('routeCodeID').focus();
                            return;
                        }
                        if (Ext.getCmp('hubid').getValue() == "") {
                            Ext.example.msg("<%=SelectHub%>");
                            Ext.getCmp('hubid').focus();
                            return;
                        }
 
                        var buttonPanel = Ext.getCmp('winbuttonid');
                        var selectdName;
                        buttonPanel.getEl().mask();
                        if (buttonValue == 'modify') {
                            var selected = customerRouteGrid.getSelectionModel().getSelected();
                            hubid = selected.get('hubid');
                            selectdName=selected.get('customerLocationName');
							}
						Ext.Ajax.request({
				  							url: '<%=request.getContextPath()%>/CustomerRouteMasterAction.do?param=InsertTrip',
											method: 'POST',
											params: {
											buttonValue:buttonValue,
											clientId:Ext.getCmp('clientId').getValue(),
											routeCodeID:Ext.getCmp('routeCodeID').getValue(),
											hubid:Ext.getCmp('hubid').getValue(),
											selectdName:selectdName
											},
											success:function(response)
											{
				      	        				Ext.getCmp('routeCodeID').setValue("");
						          				Ext.getCmp('hubid').setValue("");
		        								var msg = response.responseText;
		        								Ext.example.msg(msg);
                                				store.load({
                       							params: {
                           								clientId: clientId
                        							}
                 								});                  		 			
							   				}  ,
							   				
						   			  failure:function(){
						   			  Ext.example.msg("Error");
						   				}
      	 							});
      	 							
      	 				store.load({
                       		params: {
                           		clientId: clientId
                        		},
                        		callback: function () {
                                Ext.getCmp('routeCodeID').reset();
                                Ext.getCmp('hubid').reset();
                              
                                myWin.hide();
                                buttonPanel.getEl().unmask();

                                Ext.getCmp('routeCodeID').enable();
                                Ext.getCmp('hubid').enable();
                            }
                 		}); 
                      }
                  }
              }
        }, {
            xtype: 'button',
            text: '<%= Close%>',
            id: 'canButtId',
            cls: 'buttonstyle',
            buttonAlign : 'center',
            iconCls: 'cancelbutton',
            width: '80',
            listeners: {
                click: {
                    fn: function () {
                        Ext.getCmp('routeCodeID').reset();
                        Ext.getCmp('hubid').reset();
                        
                        var buttonPanel = Ext.getCmp('winbuttonid');
                        buttonPanel.getEl().unmask();
                        myWin.hide();
                    }
                }
            }
            }]
            
        });

    var outerPanelWindow = new Ext.Panel({
        cls: 'outerpanelwindow',
        standardSubmit: true,
        frame: false,
        items: [customerInnerPanel,winButtonPanel]
    });

   
    myWin = new Ext.Window({
        title: '<%=CustomerRouteInformation%>' ,
        closable: false,
        modal: true,
        resizable: false,
        autoScroll: false,
       height:200,
       width:500,
        id: 'myWin',
        items: [outerPanelWindow]
    });

    function modifyData() {
        if (Ext.getCmp('clientId').getValue() == "") {
         Ext.example.msg("<%=SelectCustomer%>");
         Ext.getCmp('clientId').focus();
            return;
        }

        if (customerRouteGrid.getSelectionModel().getCount() == 0) {
        	 Ext.example.msg("<%=SelectSingleRow%>");
            return;
        }
        if (customerRouteGrid.getSelectionModel().getCount() > 1) {
       		 Ext.example.msg("<%=SelectSingleRow%>");
            return;
        }
        buttonValue = "modify";
        title = '<%=EditCustomerRouteInformation%>';
        myWin.setPosition(450, 150);
        myWin.setTitle(title);
        myWin.show();

        Ext.getCmp('clientId').enable();
        Ext.getCmp('routeCodeID').disable();
        var selected = customerRouteGrid.getSelectionModel().getSelected();
        Ext.getCmp('routeCodeID').setValue(selected.get('customerLocationName'));
        Ext.getCmp('hubid').setValue(selected.get('hubid'));
 
    }

    function addRecord() {

        if (Ext.getCmp('clientId').getValue() == "") {
        	Ext.example.msg("<%=SelectCustomer%>");
            Ext.getCmp('clientId').focus();
            return;
        }
        
        Ext.getCmp('routeCodeID').enable();
        Ext.getCmp('hubid').enable();
        
        buttonValue = "add";
        title = '<%=AddCustomerInformation%>';
        myWin.setPosition(450, 150);
        myWin.show();
        myWin.setTitle(title);
    }

    function onCellClickOnGrid(customerRouteGrid, rowIndex, columnIndex, e)
     {
        if (Ext.getCmp('clientId').getValue() == "") {
       		Ext.example.msg("<%=SelectCustomer%>");
            Ext.getCmp('clientId').focus();
            return;
        }

        if (customerRouteGrid.getSelectionModel().getCount() == 0) {
        	Ext.example.msg("<%=SelectSingleRow%>");
            return;
        }
        if (customerRouteGrid.getSelectionModel().getCount() > 1) {
        	Ext.example.msg("<%=SelectSingleRow%>");
            return;
        }
      }
    
    var reader = new Ext.data.JsonReader({
        idProperty: 'readerid',
        root: 'customerRouteInfoRoot',
        totalProperty: 'total',
        fields: [{
            name: 'slnoIndex'
        },{
            name: 'customerLocationName'
        }, {
            name: 'hubid',
            type:'string'
        },{
            name: 'created By'
        },{ 
            name: 'created Time',           
            type: 'date',
            dateFormat: getDateTimeFormat()        
                      
        }]
    });
    
     var store = new Ext.data.GroupingStore({
                autoLoad: false,
                proxy: new Ext.data.HttpProxy({
                    url: '<%=request.getContextPath()%>/CustomerRouteMasterAction.do?param=getCustomerRouteInformation',
                    method: 'POST'
                //  remoteSort: true, 
                }),                               
                storeId: 'darStore',
                reader: reader
            });

    var filters = new Ext.ux.grid.GridFilters({
        local: true,
        filters: [{
            type: 'numeric',
            dataIndex: 'slnoIndex'
        },{
            type: 'string',
            dataIndex: 'customerLocationName'
        }, {
            type: 'string',
            dataIndex: 'hubid'
        },{
            type: 'string',
            dataIndex: 'created By'
        }, {
            type: 'date',
            dataIndex: 'created Time'
        }]
    });

    
    var createColModel = function (finish, start) {

        var columns = [
            new Ext.grid.RowNumberer({
                header: "<span style=font-weight:bold;><%=SlNO%></span>",
                width: 50
            }), {
                dataIndex: 'slnoIndex',
                hidden: true,
                header: "<span style=font-weight:bold;><%=SlNO%></span>",
                filter: {
                    type: 'numeric'
                }
            },{
                header: "<span style=font-weight:bold;><%=CustomerLocationName%></span>",
                dataIndex: 'customerLocationName',
                width: 130,
                filter: {
                    type: 'string'
                }
            }, {
                header: "<span style=font-weight:bold;><%=HubName%></span>",
                dataIndex: 'hubid',
                width: 120,
                filter: {
                    type: 'string'
                }
            },{
                header: "<span style=font-weight:bold;><%=CreatedBy%></span>",
                dataIndex: 'created By',
                filter: {
                    type: 'string'
                }
            },{
                dataIndex: 'created Time',
                header: "<span style=font-weight:bold;><%=CreatedTime%></span>",
                width: 100,
                renderer: Ext.util.Format.dateRenderer(getDateTimeFormat()),                
                filter: {
                    type: 'date'
                }
            }];

        return new Ext.grid.ColumnModel({
            columns: columns.slice(start || 0, finish),
            defaults: {
                sortable: true
            }
        });
    };

    customerRouteGrid = getGrid('<%=CustomerRouteDetails%>', '<%=NoRecordsFound%>', store, screen.width - 45, screen.height-300,8, filters, '<%=ClearFilterData%>', false, '', 16, false, '', false, '', false, '', '', '', false, '', true, '<%=Add%>', true, '<%=Edit%>');

    customerRouteGrid.on({
        "cellclick": {
            fn: onCellClickOnGrid
        }
    });

    
var innerPanel = new Ext.Panel({
    standardSubmit: true,
    collapsible: false,
    id: 'traderMaster',
    layout: 'table',
    frame: true,
    layoutConfig: {
        columns: 2
    },
    items: [{
            xtype: 'label',
            text: '<%=CustomerName%>' + ' :',          
            id:'customerlabel'
        },
        custnamecombo
    ]
});

    Ext.onReady(function () {
        ctsb = tsb;
        Ext.QuickTips.init();
        Ext.form.Field.prototype.msgTarget = 'side';

            outerPanel = new Ext.Panel({
            renderTo: 'content',
            standardSubmit: true,
            frame: true,
           	width:screen.width-30,
           	height:screen.height-220,
            cls: 'outerpanel',
            items: [innerPanel, customerRouteGrid]
            //bbar: ctsb
        });
    });
</script>
<jsp:include page="../Common/footer.jsp" />
 <!-- </body>   -->
 <!-- </html> -->