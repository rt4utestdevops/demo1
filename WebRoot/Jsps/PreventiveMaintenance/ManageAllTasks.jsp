<%@ page  language="java" import="java.util.*,t4u.functions.*,t4u.beans.*,t4u.common.*" pageEncoding="utf-8"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://"+ request.getServerName() + ":" + request.getServerPort()+ path + "/";
	CommonFunctions cf = new CommonFunctions();
	cf.checkLoginInfo((LoginInfoBean) session.getAttribute("loginInfoDetails"), session, request, response);
	
    String clientID=request.getParameter("clientID");
   String alertID=request.getParameter("alertID");
  LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
	String language = loginInfo.getLanguage();
	int systemId = loginInfo.getSystemId();
	int customerId = loginInfo.getCustomerId();

	ArrayList<String> tobeConverted=new ArrayList<String>();	
    tobeConverted.add("Customer_Name");
    tobeConverted.add("Select_Customer");
    tobeConverted.add("SLNO");
    tobeConverted.add("Asset_Model");
    tobeConverted.add("Asset_Number");
    tobeConverted.add("Manage_Service");
    tobeConverted.add("Service_History");                                
    tobeConverted.add("Due_For_Renewal");
    tobeConverted.add("Service_Over_Due");
    tobeConverted.add("No_Records_Found");
	tobeConverted.add("Clear_Filter_Data");
    tobeConverted.add("Select_Single_Row");
    tobeConverted.add("Service_Tasks");
   
	ArrayList<String> convertedWords=new ArrayList<String>();
	convertedWords=cf.getLanguageSpecificWordForKey(tobeConverted, language);	
	String CustomerName = convertedWords.get(0);
	String SelectCustomer = convertedWords.get(1);
	String SLNO = convertedWords.get(2);
	String AssetModel = convertedWords.get(3);
	String AssetNumber = convertedWords.get(4);
	String ManageService = convertedWords.get(5);
	String ServiceHistory = convertedWords.get(6);
	String DueForRenewal=convertedWords.get(7);
	String ServiceOverDue=convertedWords.get(8);
	String NoRecordsFound = convertedWords.get(9);
	String ClearFilterData = convertedWords.get(10);  
	String SelectSingleRow = convertedWords.get(11); 
	String ServiceTasks = convertedWords.get(12); 
%>

<!DOCTYPE HTML>
<html>
	<head>
		<title><%=ServiceTasks%></title>		
	</head>	    
  
  	<body onload="" >
   		 <%if (loginInfo.getStyleSheetOverride().equals("Y")){%>                  
    <jsp:include page="../Common/ImportJSSandMining.jsp"/>                                               
   <%}else {%>  
   <jsp:include page="../Common/ImportJS.jsp" /><%} %>
   
   	<script>
    var outerPanel;
    var ctsb;
  //  var dtprev;
    var custId;
    var manageAllTasksGrid;
    var globalAssetNumber;
    var globalAssetId;
	var type = 0;
	var alertID ="";
	
    //***************************************Customer Store*************************************  		
    var customercombostore = new Ext.data.JsonStore({
        url: '<%=request.getContextPath()%>/CommonAction.do?param=getCustomer',
        id: 'CustomerStoreId',
        root: 'CustomerRoot',
        autoLoad: true,
        remoteSort: true,
        fields: ['CustId', 'CustName'],
        listeners: {
            load: function (custstore, records, success, options) {
                if ( <%= customerId %> > 0) {
                    Ext.getCmp('custcomboId').setValue('<%=customerId%>');
                    custId = Ext.getCmp('custcomboId').getValue();
                    custName = Ext.getCmp('custcomboId').getRawValue();
                    type = 0;
                    manageStore.load({
                        params: {
                            CustId: custId,
                            CustName: custName,
                            Type : type
                        }
                    });
                    Ext.getCmp('allId').setValue(true);
                    Ext.getCmp('dueTaskTaskTabId').disable();
                    Ext.getCmp('expiredTaskTabId').disable();
                    Ext.getCmp('historyTabId').disable();

                    Ext.getCmp('ManageTaskTabId').enable();
                    Ext.getCmp('ManageTaskTabId').show();
                    Ext.getCmp('ManageTaskTabId').update("<iframe style='width:100%;height:600px;border:0;'src='<%=path%>/Jsps/PreventiveMaintenance/ManageTasks.jsp'></iframe>");
                 }
                 if ((<%= clientID %> > 0) && <%=clientID%> != null) {
                    Ext.getCmp('custcomboId').setValue('<%=clientID%>');
                    custId = Ext.getCmp('custcomboId').getValue();
                    custName = Ext.getCmp('custcomboId').getRawValue();
                    
                    
                      if((<%=alertID%>==2) && (<%=alertID%>!= null))
                    {
                    type = 2;
                    manageStore.load({
                        params: {
                            CustId: custId,
                            CustName: custName,
                            Type : type
                        }
                    });
                     Ext.getCmp('dueForRenewalId').setValue(true);
                     Ext.getCmp('dueTaskTaskTabId').enable();
                     Ext.getCmp('dueTaskTaskTabId').show();
                     }else if((<%=alertID%>==1) && (<%=alertID%>!= null))
                     {
                     type = 1;
	                    manageStore.load({
	                        params: {
	                            CustId: custId,
	                            CustName: custName,
	                            Type : type
	                        }
	                    });
                       Ext.getCmp('serviceOverDueId').setValue(true);
                       Ext.getCmp('expiredTaskTabId').enable();
                        Ext.getCmp('expiredTaskTabId').show();
                      }else
                      {
                         type = 0;
	                    manageStore.load({
	                        params: {
	                            CustId: custId,
	                            CustName: custName,
	                            Type : type
	                        }
	                    });
	                    
                         Ext.getCmp('allId').setValue(true);
                         Ext.getCmp('dueTaskTaskTabId').disable();
	                    Ext.getCmp('expiredTaskTabId').disable();
	                    Ext.getCmp('historyTabId').disable();
	
	                    Ext.getCmp('ManageTaskTabId').enable();
	                    Ext.getCmp('ManageTaskTabId').show();
	                    Ext.getCmp('ManageTaskTabId').update("<iframe style='width:100%;height:600px;border:0;'src='<%=path%>/Jsps/PreventiveMaintenance/ManageTasks.jsp'></iframe>");
                      }
                    
                   
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
        cls: 'labelstyle',
        listeners: {
            select: {
                fn: function () {
                    globalAssetNumber="";
                    custId = Ext.getCmp('custcomboId').getValue();
                    custName = Ext.getCmp('custcomboId').getRawValue();
                    type = 0;
                    manageStore.load({
                        params: {
                            CustId: custId,
                            CustName: custName,
                            Type : type
                        }
                    });
                    Ext.getCmp('allId').setValue(true);
                    Ext.getCmp('dueTaskTaskTabId').disable();
                    Ext.getCmp('expiredTaskTabId').disable();
                    Ext.getCmp('historyTabId').disable();

                    Ext.getCmp('ManageTaskTabId').enable();
                    Ext.getCmp('ManageTaskTabId').show();
                    Ext.getCmp('ManageTaskTabId').update("<iframe style='width:100%;height:600px;border:0;'src='<%=path%>/Jsps/PreventiveMaintenance/ManageTasks.jsp'></iframe>");
                     
                    
                       
                     
               }
            }
        }
    });

    function onCellClickOnGrid(manageAllTasksGrid, rowIndex, columnIndex, e) {

        if (Ext.getCmp('custcomboId').getValue() == "") {
            Ext.example.msg("<%=SelectCustomer%>");
            Ext.getCmp('custcomboId').focus();
            return;
        }
        Ext.getCmp('ManageTaskTabId').enable(true);
        Ext.getCmp('dueTaskTaskTabId').enable(true);
        Ext.getCmp('expiredTaskTabId').enable(true);
        Ext.getCmp('historyTabId').enable(true);

        if (manageAllTasksGrid.getSelectionModel().getCount() == 1) {
            var selected = manageAllTasksGrid.getSelectionModel().getSelected();
            globalAssetNumber = selected.get('assetnumber');
            globalAssetId = selected.get('assetModel');
             var activeTab = allTabs.getActiveTab();
             var activeTabIndex = allTabs.items.findIndex('id', activeTab.id);
             if(type==0)
             {
               Ext.getCmp('ManageTaskTabId').enable();
               Ext.getCmp('ManageTaskTabId').show();
               Ext.getCmp('ManageTaskTabId').update("<iframe style='width:100%;height:500px;border:0;'src='<%=path%>/Jsps/PreventiveMaintenance/ManageTasks.jsp'></iframe>");
              }
             
             if(type==2)
             {
                  Ext.getCmp('ManageTaskTabId').hide();
                  Ext.getCmp('expiredTaskTabId').hide();
                  Ext.getCmp('dueTaskTaskTabId').enable();
                  Ext.getCmp('dueTaskTaskTabId').show();
                  Ext.getCmp('dueTaskTaskTabId').update("<iframe style='width:100%;height:500px;border:0;'src='<%=path%>/Jsps/PreventiveMaintenance/ExpiringSoon.jsp'></iframe>");
             }
             
             if(type==1)
             {
              Ext.getCmp('expiredTaskTabId').enable();
              Ext.getCmp('expiredTaskTabId').show();
              Ext.getCmp('expiredTaskTabId').update("<iframe style='width:100%;height:500px;border:0;'src='<%=path%>/Jsps/PreventiveMaintenance/AlreadyExpired.jsp'></iframe>");
             }
        }
    }

    var reader = new Ext.data.JsonReader({
        idProperty: 'darreaderid',
        root: 'managerAssetRoot',
        totalProperty: 'total',
        fields: [{
            name: 'slnoIndex'
        }, {
            name: 'assetModel'
        }, {
            name: 'assetnumber'
        }]
    });

    var manageStore = new Ext.data.GroupingStore({
        autoLoad: false,
        proxy: new Ext.data.HttpProxy({
            url: '<%=request.getContextPath()%>/PreventiveMaintenanceAction.do?param=getAssetNumber',
            method: 'POST'
        }),
        remoteSort: false,

        storeId: 'darStore',
        reader: reader
    });

    var filters = new Ext.ux.grid.GridFilters({
        local: true,
        filters: [{
            type: 'numeric',
            dataIndex: 'slnoIndex'
        }, {
            type: 'int',
            dataIndex: 'assetModel'
        }, {
            type: 'string',
            dataIndex: 'assetnumber'
        }]
    });

    //************************************Column Model Config******************************************
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
            }, {                     
                header: "<span style=font-weight:bold;><%=AssetNumber%></span>",
                dataIndex: 'assetnumber',
                width: 60,
                filter: {
                    type: 'string'
                }
            }, {
                header: "<span style=font-weight:bold;><%=AssetModel%></span>",
                dataIndex: 'assetModel',
                width: 50,
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

    manageAllTasksGrid = getGrid('', '<%=NoRecordsFound%>', manageStore, 310, 380, 4, filters,'<%=ClearFilterData%>', false, '', 4);

    manageAllTasksGrid.on({
        "cellclick": {
            fn: onCellClickOnGrid
        }
    });

    var clientPanel = new Ext.Panel({
        standardSubmit: true,
        collapsible: false,
        id: 'traderMaster',
        layout: 'table',
        frame: true,
        height: 100,
        width: 310,
        layoutConfig: {
            columns: 2
        },
        items: [{
                xtype: 'label',
                text: '<%=CustomerName%>' + ' :',
                cls: 'labelstyle',
                id: 'custnamelab'     
            },
            custnamecombo,
            {
                   xtype: 'radio',
	               id:'allId',
                   text: '',
                  checked:true,
                   name:'option1',
                   listeners:{
					check:{fn:function()
					{
					 if(this.checked){
					radioButValueForDueForRenewal=this.value;
				    type = 0;
					manageStore.load({
                        params: {
                            CustId: custId,
                            Type: type
                       }
                    }); 
                    globalAssetNumber = '';
                    Ext.getCmp('ManageTaskTabId').enable();
                    Ext.getCmp('ManageTaskTabId').show();
                   }
                   } 
                  }  
                }    
                    
          }, {
				    xtype:'label',
				    text:'All',
				    cls: 'labelstyle'
			    },
			    
			    {
                   xtype: 'radio',
	               id:'dueForRenewalId',
                   text: '',
                   checked:false,
                   name:'option1',
                     listeners:{
					check:{fn:function()
					{
					 if(this.checked){
					radioButValueForDueForRenewal=this.value;
				    type=2;
					manageStore.load({
                        params: {
                            CustId: custId,
                            Type: type
                       }
                    }); 
                    globalAssetNumber = '';
                     Ext.getCmp('dueTaskTaskTabId').enable();
                     Ext.getCmp('dueTaskTaskTabId').show();
                   }
                   } 
                  }  
                }  
                }, {
				    xtype:'label',
				    text:'<%=DueForRenewal%>',
			    cls: 'labelstyle'
			    },
			    
			    
			     {
                   xtype: 'radio',
	               id:'serviceOverDueId',
                   text: '',
                   checked:false,
                   name:'option1',
                      listeners:{
					check:{fn:function()
					{
					 if(this.checked){
					radioButValueForDueForRenewal=this.value;
				    type = 1;
					manageStore.load({
                        params: {
                            CustId: custId,
                            Type: type
                       }
                    }); 
                    globalAssetNumber = '';
                    Ext.getCmp('expiredTaskTabId').enable();
                    Ext.getCmp('expiredTaskTabId').show();
                   }
                   } 
                  }  
                }  
                }, {
				    xtype:'label',
				    text:'<%=ServiceOverDue%>',
				    width:100,
				    cls: 'labelstyle'
			    }
			  
           
        ]
    });

    var manageAllTasksPanel = new Ext.Panel({
        standardSubmit: true,
        collapsible: false,
        id: 'vesselPanelId',
        layout: 'table',
        frame: false,
        width: 310,
        height: 500,
        layoutConfig: {
            columns: 1
        },
        items: [clientPanel, manageAllTasksGrid]
    });

    var allTabs = new Ext.TabPanel({
        resizeTabs: false,
        enableTabScroll: true,
        //activeTab: 'ManageTaskTabId',
        width: screen.width - 340,
        height: 530,
        listeners: {
            tabchange: function (tp, newTab, currentTab) {
                var activeTab = allTabs.getActiveTab();
                var activeTabIndex = allTabs.items.findIndex('id', activeTab.id);
                switch (activeTabIndex) {
                case 0:
                    Ext.getCmp('ManageTaskTabId').update("<iframe style='width:100%;height:600px;border:0;'src='<%=path%>/Jsps/PreventiveMaintenance/ManageTasks.jsp'></iframe>");
                    break;
                case 1:
                    Ext.getCmp('dueTaskTaskTabId').update("<iframe style='width:100%;height:600px;border:0;'src='<%=path%>/Jsps/PreventiveMaintenance/ExpiringSoon.jsp'></iframe>");
                    break;
                case 2:
                    Ext.getCmp('expiredTaskTabId').update("<iframe style='width:100%;height:600px;border:0;'src='<%=path%>/Jsps/PreventiveMaintenance/AlreadyExpired.jsp'></iframe>");
                    break;
                case 3:
                    Ext.getCmp('historyTabId').update("<iframe style='width:100%;height:600px;border:0;'src='<%=path%>/Jsps/PreventiveMaintenance/TasksHistory.jsp'></iframe>");
                    break;
                }
            }
        },
        defaults: {
            autoScroll: false
        }
    });
    addTab();

    function addTab() {
        allTabs.add({

            title: '<%=ManageService%>',
            iconCls: 'admintab',
            id: 'ManageTaskTabId',
            html: "<iframe style='width:100%;height:600px;border:0;'src='<%=path%>/Jsps/PreventiveMaintenance/ManageTasks.jsp''></iframe>"

        }).show();

        allTabs.add({

            title: '<%=DueForRenewal%>',
            iconCls: 'admintab',
            id: 'dueTaskTaskTabId',
            html: "<iframe style='width:100%;height:600px;border:0;'src='<%=path%>/Jsps/PreventiveMaintenance/ExpiringSoon.jsp'></iframe>"

        }).show();

        allTabs.add({

            title: '<%=ServiceOverDue%>',
            iconCls: 'admintab',
            id: 'expiredTaskTabId',
            html: "<iframe style='width:100%;height:600px;border:0;'src='<%=path%>/Jsps/PreventiveMaintenance/AlreadyExpired.jsp'></iframe>"

        }).show();

        allTabs.add({

            title: '<%=ServiceHistory%>',
            iconCls: 'admintab',
            id: 'historyTabId',
            html: "<iframe style='width:100%;height:600px;border:0;'src='<%=path%>/Jsps/PreventiveMaintenance/TasksHistory.jsp'></iframe>"

        }).show();

        Ext.getCmp('ManageTaskTabId').disable(true);
        Ext.getCmp('dueTaskTaskTabId').disable(true);
        Ext.getCmp('expiredTaskTabId').disable(true);
        Ext.getCmp('historyTabId').disable(true);
    }

    Ext.onReady(function () {
        ctsb = tsb;
        Ext.QuickTips.init();
        Ext.form.Field.prototype.msgTarget = 'side';

        outerPanel = new Ext.Panel({
            renderTo: 'content',
            standardSubmit: true,
            frame: true,
            title:'Service Details',
            width:screen.width-20,
            height:screen.height-220,
            collapsible: false,
            cls: 'outerpanel',
            layout: 'table',
            layoutConfig: {
                columns: 2
            },
            items: [manageAllTasksPanel, allTabs]
           // bbar: ctsb
        });
    });
	</script>
  	</body>
</html>