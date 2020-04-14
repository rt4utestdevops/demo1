
<%@ page language="java" import="java.util.*,t4u.functions.CommonFunctions,t4u.beans.*,t4u.common.*" pageEncoding="UTF-8"%>
<%@ taglib uri="http://packtag.sf.net" prefix="pack" %> 
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
if (request.getParameter("list") != null) {
		String list = request.getParameter("list").toString().trim();
		String[] str = list.split(",");
		int systemid = Integer.parseInt(str[0].trim());
		int customerid = Integer.parseInt(str[1].trim());
		int userid = Integer.parseInt(str[2].trim());
		String language = str[3].trim();
		LoginInfoBean loginInfo = new LoginInfoBean();
		loginInfo.setSystemId(systemid);
		loginInfo.setCustomerId(customerid);
		loginInfo.setUserId(userid);
		loginInfo.setLanguage(language);
		loginInfo.setStyleSheetOverride("N");
		loginInfo.setZone(str[4].trim());
		loginInfo.setOffsetMinutes(Integer.parseInt(str[5].trim()));
		loginInfo.setSystemName(str[6].trim());
		loginInfo.setCategory(str[7].trim());
		if (str.length > 8) {
			loginInfo.setCustomerName(str[8].trim());
		}
		if (str.length > 9) {
			loginInfo.setCategoryType(str[9].trim());
		}
		if (str.length > 10) {
			loginInfo.setUserName(str[10].trim());
		}
		if (str.length > 11) {
			loginInfo.setStyleSheetOverride("N");
		}
		session.setAttribute("loginInfoDetails", loginInfo);
	}
	CommonFunctions cf = new CommonFunctions();
	LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
	if (loginInfo == null) {
			response.sendRedirect(request.getContextPath()+ "/Jsps/Common/SessionDestroy.html");
	} else {
		session.setAttribute("loginInfoDetails", loginInfo);
		String language = loginInfo.getLanguage();
		int systemId = loginInfo.getSystemId();
		int customerId = loginInfo.getCustomerId();
	    int userId=loginInfo.getUserId(); 
	    String userAuthority=cf.getUserAuthority(systemId,userId);	
   if(false)
	{
		response.sendRedirect(request.getContextPath()+ "/Jsps/Common/401Error.html");
	}
	else{
		
%>

<jsp:include page="../Common/header.jsp" />
    <base href="<%=basePath%>">
    <title>Route Density</title>
 
  <%if (loginInfo.getStyleSheetOverride().equals("Y")){%>
       <jsp:include page="../Common/ImportJSSandMining.jsp"/>
		<%}else {%>
		<jsp:include page="../Common/ImportJS.jsp" />
		<%} %>
		 <jsp:include page="../Common/ExportJS.jsp" />
	  <% String newMenuStyle=loginInfo.getNewMenuStyle();
		if(newMenuStyle.equalsIgnoreCase("YES")){%>
		<style>			
			label {
				display : inline !important;
			}			
			.ext-strict .x-form-text {
				height: 21px !important;
			}
			.x-layer ul {
				min-height: 27px !important;
			}						
			.x-menu-list {
				height:auto !important;
			}				
			.x-window-tl *.x-window-header {			
				padding-top : 6px !important;
			}			
		</style>
	 <%}%>
 <script>
    //-------------------------------------------------------------------------------//
    var outerPanel;
    var jspName = "Route Density Report";
    var grid;
	var exportDataType = "int,int,string,string,string,int,string";
	var buttonValue;
	var dtcur = datecur;
    //----------------------------------customer store---------------------------// 
    var customercombostore = new Ext.data.JsonStore({
        url: '<%=request.getContextPath()%>/CommonAction.do?param=getCustomer',
        id: 'CustomerStoreId',
        root: 'CustomerRoot',
        autoLoad: true,
        remoteSort: true,
        fields: ['CustId', 'CustName'],
        listeners: {
            load: function(custstore, records, success, options) {
                if ( <%= customerId %> > 0) {
                    Ext.getCmp('custcomboId').setValue('<%=customerId%>');
                    custId = Ext.getCmp('custcomboId').getValue();
                    custName = Ext.getCmp('custcomboId').getRawValue();
                }
            }
        }
    });
    //******************************************************************customer Combo******************************************//
    var custnamecombo = new Ext.form.ComboBox({
        store: customercombostore,
        id: 'custcomboId',
        mode: 'local',
        forceSelection: true,
        emptyText: 'Select Customer',
        resizable: true,
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
                    }
                }
            }
    });

    //-------------------------------------------------------------------------------------------------------//
    var clientPanel = new Ext.Panel({
        standardSubmit: true,
        collapsible: false,
        id: '',
        layout: 'table',
        frame: true,
        width: screen.width - 20,
        height: 65,
        layoutConfig: {
            columns: 5
        },
        items: [{
                xtype: 'label',
                text: 'Customer Name' + ' :',
                cls: 'labelstyle',
                id: 'custnamelab'
            },{
                width: 30
            },custnamecombo,
              {
                width: 50
            },{
                xtype: 'button',
                text: 'view',
                id: 'generateReport',
                cls: 'buttonwastemanagement',
                width: 60,
                listeners: {
                    click: {
                        fn: function() {
                            if (Ext.getCmp('custcomboId').getValue() == "") {
                                Ext.example.msg("Select Customer");
                                Ext.getCmp('custcomboId').focus();
                                 return;
             				  }
                           var custName=Ext.getCmp('custcomboId').getRawValue();
                            store.load({
                                params: {
                                    CustId: custId,
                                    custName: custName,
                                    jspName:jspName
                                }
                            });
                        }
                    }
                }
            }
        ]
    });
	    var activeInnerPanel = new Ext.form.FormPanel({
        standardSubmit: true,
        collapsible: false,
        frame: false,
        id: 'cancel',

        items: [{
            xtype: 'fieldset',
            width: 480,
            title: 'Acitve/Inactive Details',
            id: 'closefieldset',
            collapsible: false,
            layout: 'table',
            layoutConfig: {
                columns: 5
            },
            items: [{
                xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                id: 'mandatorycloseLabel'
            }, {
                xtype: 'label',
                text: '*',
                cls: 'mandatoryfield',
                id: 'mandatorycloseLabelId'
            }, {
                xtype: 'label',
                text: 'Remark' + '  :',
                cls: 'labelstyle',
                id: 'remarkLabelId'
            }, {
                width: 10
            }, {
                xtype: 'textarea',
                cls: 'selectstylePerfect',
                id: 'remark',
                emptyText: 'Enter Remarks',
                blankText: 'Enter Remarks'
            }]
        }]
    });
    var winButtonPanelForActive = new Ext.Panel({
        id: 'winbuttonid12',
        standardSubmit: true,
        collapsible: false,
        height: 8,
        cls: 'windowbuttonpanel',
        frame: true,
        layout: 'table',
        layoutConfig: {
            columns: 4
        },
        buttons: [{
            xtype: 'button',
            text: 'Ok',
            id: 'cancelId1',
            cls: 'buttonstyle',
            iconCls: 'savebutton',
            width: 80,
            listeners: {
                click: {
                    fn: function() {
                        if (Ext.getCmp('remark').getValue() == "") {
                            Ext.example.msg("Enter Remark");
                            Ext.getCmp('remark').focus();
                            return;
                        }
                        activeWin.getEl().mask();
                        var selected = grid.getSelectionModel().getSelected();
                        id = selected.get('idIndex');
                        Ext.Ajax.request({
                            url: '<%=request.getContextPath()%>/MiningRouteMasterAction.do?param=activeInactiveRoutes',
                            method: 'POST',
                            params: {
                                id: id,
                                CustID: 0,
                                remark: Ext.getCmp('remark').getValue(),
                                status: selected.get('statusIndex')
                            },
                            success: function(response, options) {
                                var message = response.responseText;
                                Ext.example.msg(message);
                                activeWin.getEl().unmask();
                                store.reload();
                                activeWin.hide();
                                Ext.getCmp('remark').reset();
                            },
                            failure: function() {
                                Ext.example.msg("Error");
                                store.load({
			                        params: {
			                            CustId: custId,
			                            jspName: jspName,
			                            CustName: Ext.getCmp('custcomboId').getRawValue()
			                        }
			                    });
                                Ext.getCmp('remark').reset();
                                activeWin.hide();
                            }
                        });
                    }
                }
            }
        }, {
            xtype: 'button',
            text: 'Cancel',
            id: 'cancelButtonId2',
            cls: 'buttonstyle',
            iconCls: 'cancelbutton',
            width: '80',
            listeners: {
                click: {
                    fn: function() {
                        activeWin.hide();
                        Ext.getCmp('remark').reset();
                    }
                }
            }
        }]
    });

	var ActivePanel = new Ext.Panel({
        standardSubmit: true,
        collapsible: false,
        autoScroll: true,
        width: 490,
        height: 180,
        frame: true,
        id: 'cancelPanel1',
        items: [activeInnerPanel]
    });
    var outerPanelWindowForActive = new Ext.Panel({
        standardSubmit: true,
        id: 'cancelwinpanelId1',
        frame: true,
        height: 250,
        width: 520,
        items: [ActivePanel, winButtonPanelForActive]
    });

    activeWin = new Ext.Window({
        closable: false,
        modal: true,
        resizable: false,
        autoScroll: false,
        height: 300,
        width: 530,
        id: 'closemyWin',
        items: [outerPanelWindowForActive]
    });
    function addRecord(){
       if (grid.getSelectionModel().getSelected() == null) {
          Ext.example.msg('No Records found');
          return;
      }
      if(grid.getSelectionModel().getCount()>1){
        Ext.example.msg("Select Single Row");
        return;
      }
      var selected=grid.getSelectionModel().getSelected();
      var routeId=selected.get('idIndex');
      openPopWin("<%=basePath%>Jsps/IronMining/RouteWiseTripDetails.jsp?routeId="+routeId,'Trip Details',screen.width*0.98,screen.height*0.60);
    }
    function openPopWin(url,title,width,height)
	{
		popWin = new Ext.Window({
		title: title,
		autoShow : false,
		constrain : false,
		constrainHeader : false,
		resizable : false,
		maximizable : true,
		minimizable : false,
		width:width,
	    height:height,
		closable : true,
		stateful : false,
		html : "<iframe style='width:100%;height:100%' src="+url+"></iframe>",
		scripts:true,
		shim : false
		});
		popWin.setPosition(10, 50);
		popWin.show();
	}
	
	function closetripsummary() {

        selected = grid.getSelectionModel().getSelected();
        if (grid.getSelectionModel().getCount() == 0) {
            Ext.example.msg("No Rows Selected");
            return;
        }
        if (grid.getSelectionModel().getCount() > 1) {
            Ext.example.msg("Select Single Row");
            return;
        }
        if (selected.get('motherRStatus') == 'Inactive') {
            Ext.example.msg("Can't change status");
            return;
        }
        activeWin.show();
    }
    //---------------------------------------------------Reader-------------------------------------------------------//
    var reader = new Ext.data.JsonReader({
        idProperty: 'StoctYartMasterRootId',
        root: 'routeDensityRoot',
        totalProperty: 'total',
        fields: [ {
            name: 'slnoIndex'
        },{
            name: 'idIndex'
        },{
            name: 'routeNameIndex'
        },{
            name: 'OrganizationNameIndex'
        },{
            name: 'motherRNameNameIndex'
        },{
            name: 'tripsheetCountIndex'
        },{
            name: 'statusIndex'
        },{
            name: 'motherRStatus'
        }]
    });
    //-----------------------------------------------store---------------------------------------------------//
    var store = new Ext.data.GroupingStore({
        autoLoad: false,
        proxy: new Ext.data.HttpProxy({
            url: '<%=request.getContextPath()%>/RouteDensityAction.do?param=getRouteDetails',
            method: 'POST'
        }),
        remoteSort: false,
        sortInfo: {
            field: 'slnoIndex',
            direction: 'ASC'
        },
        bufferSize: 700,
        reader: reader
    });
    //------------------------------------------Filters--------------------------------------------------------//
    var filters = new Ext.ux.grid.GridFilters({
        local: true,
        filters: [  {
            dataIndex: 'slnoIndex',
            type: 'numeric'
        }, {
            dataIndex: 'idIndex',
            type: 'int'
        }, {
            dataIndex: 'routeNameIndex',
            type: 'string'
        }, {
            dataIndex: 'OrganizationNameIndex',
            type: 'string'
        },{
            dataIndex: 'motherRNameNameIndex',
            type: 'string'
        }, {
            dataIndex: 'tripsheetCountIndex',
            type: 'int'
        },{
            dataIndex: 'statusIndex',
            type: 'string'
        }]
    });
    //--------------------------------------------------column Model---------------------------------------//
    var createColModel = function(finish, start) {
        var columns = [
             new Ext.grid.RowNumberer({
                header: "<span style=font-weight:bold;>SLNO</span>",
                width: 50
            }), {
                dataIndex: 'slnoIndex',
                width: 50,
                hidden: true,
                header: "<span style=font-weight:bold;>SlNo</span>"
            }, {
                header: '<b>ID</b>',
                dataIndex: 'idIndex',
                hidden:true
            }, {
                header: '<b>Route Name</b>',
                dataIndex: 'routeNameIndex'
            }, {
                header: '<b>Organization Name</b>',
                dataIndex: 'OrganizationNameIndex'
            }, {
                header: '<b>Mother Route Name</b>',
                dataIndex: 'motherRNameNameIndex'
            }, {
                header: '<b>Open TripSheet Count</b>',
                dataIndex: 'tripsheetCountIndex'
            }, {
                header: '<b>Status</b>',
                dataIndex: 'statusIndex'
            }];
        return new Ext.grid.ColumnModel({
            columns: columns.slice(start || 0, finish),
            defaults: {
                sortable: true
            }
        });
    };
    //---------------------------------------------------------grid-------------------------------------------//

	grid = getGrid('Route Density Report', 'No Records found', store, screen.width - 38, 400, 20, filters, 'Clear Filter Data', false, '', 12, false, '', false, '', true, 'Excel', jspName, exportDataType, false, 'PDF',true,'View Details',false,'Modify',false,'',true,'Active/Inactive',false,'Generate PDF');

    //--------------------------------------------------------------------------------------------------------//

    var mainPanel = new Ext.Panel({
        standardSubmit: true,
        frame: true,
        width: screen.width - 30,
        height: 420,
        layout: 'table',
        layoutConfig: {
            columns: 1
        },
        items: [grid]
       
    });

    Ext.onReady(function() {
        outerPanel = new Ext.Panel({
            renderTo: 'content',
            standardSubmit: true,
            autoScroll: false,
            frame: true,
            border: false,
            id: 'outer',
            layout: 'table',
            width: screen.width-22,
            height: screen.height-220,
            cls: 'outerpanel',
            layoutConfig: {
                columns: 1
            },
            items: [clientPanel, mainPanel]
        });
        var cm =grid.getColumnModel();  
	    for (var j = 1; j < cm.getColumnCount(); j++) {
	       cm.setColumnWidth(j,300);
	    }
    });
    
</script>
 <jsp:include page="../Common/footer.jsp" />
 <!-- </body>   -->
 <!-- </html> -->
<%}%>
<%} %>
