<%@ page language="java"
	import="java.util.*,t4u.functions.CommonFunctions,t4u.beans.*,t4u.common.*"
	pageEncoding="ISO-8859-1"%>
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
	if(str.length>9){
	loginInfo.setCategoryType(str[9].trim());
	}
	if(str.length>10){
	loginInfo.setUserName(str[10].trim());
	}
	session.setAttribute("loginInfoDetails",loginInfo);
}
CommonFunctions cf=new CommonFunctions();
LoginInfoBean loginInfo=(LoginInfoBean)session.getAttribute("loginInfoDetails");
if(loginInfo==null){
	response.sendRedirect(request.getContextPath()+ "/Jsps/Common/SessionDestroy.html");
}
else
{
session.setAttribute("loginInfoDetails",loginInfo);
String language = loginInfo.getLanguage();
	int systemId = loginInfo.getSystemId();
	int customerId = loginInfo.getCustomerId();
     ArrayList<String> tobeConverted = new ArrayList<String>();
     tobeConverted.add("Route_Details");
     tobeConverted.add("Select_School");
     tobeConverted.add("Select_Type");
     tobeConverted.add("Select_Asset_Number");
     tobeConverted.add("Route_Allocation_Information");
     tobeConverted.add("Route_Code");
     tobeConverted.add("Enter_Route_Code");
     tobeConverted.add("Start_Time");
     tobeConverted.add("Enter_Start_Time");
     tobeConverted.add("Asset_Number");
     tobeConverted.add("Type"); 
     tobeConverted.add("Save");
     tobeConverted.add("Cancel");
     tobeConverted.add("Add");
     tobeConverted.add("Select_Single_Row");
     tobeConverted.add("No_Rows_Selected");
     tobeConverted.add("Modify");
     tobeConverted.add("Delete_Route_Details");
     tobeConverted.add("Are_you_sure_you_want_to_delete");
     tobeConverted.add("SLNO");  
     tobeConverted.add("No_Records_Found");
     tobeConverted.add("PDF");
     tobeConverted.add("Delete");  
     tobeConverted.add("Manage_Route");
 
     ArrayList<String> convertedWords = new ArrayList<String>();
     convertedWords = cf.getLanguageSpecificWordForKey(tobeConverted,language);
     
     String RouteDetails = convertedWords.get(0);
     String SelectSchool = convertedWords.get(1);
     String SelectType = convertedWords.get(2);
     String SelectAssetNumber = convertedWords.get(3);
     String RouteAllocationInformation = convertedWords.get(4);
     String RouteCode = convertedWords.get(5);
     String EnterRouteCode = convertedWords.get(6);
     String StartTime = convertedWords.get(7);
     String EnterStartTime = convertedWords.get(8);
     String AssetNumber = convertedWords.get(9);
     String Type = convertedWords.get(10);
     String Save = convertedWords.get(11);
     String Cancel = convertedWords.get(12);
     String Add = convertedWords.get(13);
     String SelectSingleRow = convertedWords.get(14);
     String NoRowsSelected = convertedWords.get(15);
     String Modify = convertedWords.get(16);
     String DeleteRouteDetails = convertedWords.get(17);
     String Areyousureyouwanttodelete = convertedWords.get(18);
     String SLNO = convertedWords.get(19);
     String NoRecordsFound = convertedWords.get(20);
     String PDF = convertedWords.get(21);
     String Delete = convertedWords.get(22);
     String ManageRoute = convertedWords.get(23);
%>

<jsp:include page="../Common/header.jsp" />
		<base href="<%=basePath%>">

		<title><%=RouteDetails%></title>
		<style>
.x-panel-tl {
	border-bottom: 0px solid !important;
}
</style>

	
	
	<%if (loginInfo.getStyleSheetOverride().equals("Y")){%>
	<jsp:include page="../Common/ImportJSSandMining.jsp"/>
	<%}else {%>
	<jsp:include page="../Common/ImportJS.jsp" /><%} %>
		<jsp:include page="../Common/ExportJS.jsp" />
		<style>
			label {
				display : inline !important;
			}
			.x-window-tl *.x-window-header {
				padding-top : 6px !important;
				height: 36px !important;
			}
			.ext-strict .x-form-text {
				height: 21px !important;
			}
			#addpanelid {
				width : 358px !important;
			}
			.footer {
				bottom : -2px !important;
			}
		</style>
		<script>
		window.onload = function () { 
			refresh();
		}

/*******************resize window event function**********************/
Ext.EventManager.onWindowResize(function () {
    var width = '100%';
    var height = '100%';
    grid.setSize(width, height);
    outerPanel.setSize(width, height);
    outerPanel.doLayout();
});
var outerPanel;
var ctsb;
var jspName = "RouteDetails";
var exportDataType = "int,int,int,number,String,String";
var selected;
var grid;
var buttonValue;
//****************************************customer store****************************//

var clientcombostore = new Ext.data.JsonStore({
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
                custName=Ext.getCmp('custcomboId').getRawValue();
                store.load({
                       params: {
                           CustId: custId,
                           CustName: custName,
                           jspName:jspName
                       }
                   });
                   assetNumberstore.load({
                       params: {
                           CustId: custId,
                           CustName: custName
                       }
                   });
             }
        }
    }
});
//******************************************************************customer Combo******************************************//
 var custnamecombo = new Ext.form.ComboBox({
       store: clientcombostore,
       id: 'custcomboId',
       mode: 'local',
       forceSelection: true,
       emptyText: '<%=SelectSchool%>',
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
                   custId = Ext.getCmp('custcomboId').getValue();
                   custName = Ext.getCmp('custcomboId').getRawValue();
				   store.load({
                       params: {
                           CustId: custId,
                           CustName: custName,
                           jspName:jspName
                       }
                   });
                   assetNumberstore.load({
                       params: {
                           CustId: custId,
                           CustName: custName
                       }
                   });
           
                   if ( <%= customerId %> > 0) {
                       Ext.getCmp('custcomboId').setValue('<%= customerId %>');
                       custId = Ext.getCmp('custcomboId').getValue();
                       custName = Ext.getCmp('custcomboId').getRawValue();
                         store.load({
                           params: {
                               CustId: custId,
                               CustName: custName,
                               jspName:jspName
                           }
                       });
                       assetNumberstore.load({
                           params: {
                               CustId: custId,
                               CustName: custName
                           }
                       });
                       
                   }
               }
           }
       }
   });

/**********************************************TypeStore****************************************/
var typeList = [['pickup','PICK UP'],['drop','DROP']];
var	typeStore = new Ext.data.SimpleStore({
	    		fields: ['typeId','TypeDscription'],
				data: typeList
			});
/*********************************TypeCombo********************************************/
var Typecombo = new Ext.form.ComboBox({
    store: typeStore,
    id: 'typecomboId',
    mode: 'local',
    forceSelection: true,
    emptyText: '<%=SelectType%>',
    blankText: '<%=SelectType%>',
    selectOnFocus: true,
    allowBlank: false,
    anyMatch: true,
    typeAhead: false,
    triggerAction: 'all',
    lazyRender: true,
    valueField: 'typeId',
    displayField: 'TypeDscription',
    cls: 'selectstylePerfect'
});


/**************store for getting ASSET NUMBER List******************/
var assetNumberstore = new Ext.data.JsonStore({
    url: '<%=request.getContextPath()%>/SchoolRouteAllocationAction.do?param=getAssetNumber',
    id: 'assetNumberStoreId',
    root: 'assetNumberRoot',
    autoLoad: true,
    fields: ['AssetNumber']
});
/*******************************comobo for asset Number****************/
var assetNumbercombo = new Ext.form.ComboBox({
    store: assetNumberstore,
    id: 'assetNumberId',
    mode: 'local',
    hidden: false,
    forceSelection: true,
    blankText: '<%=SelectAssetNumber%>',
    emptyText: '<%=SelectAssetNumber%>',
    selectOnFocus: true,
    allowBlank: false,
    anyMatch: true,
    typeAhead: false,
    triggerAction: 'all',
    valueField: 'AssetNumber',
    displayField: 'AssetNumber',
    cls: 'selectstylePerfect',
    listeners: {
        select: {
            fn: function () {
                     
             }
        }
    }
});
/*****************************Combo for Customer********************************************/
var comboPanel = new Ext.Panel({
    standardSubmit: true,
    collapsible: false,
    id: 'traderMaster',
    layout: 'table',
    frame: false,
    width: screen.width - 100,
    height: 40,
    layoutConfig: {
        columns: 3
    },
    items: [{
            xtype: 'label',
            text: '<%=SelectSchool%>' + ' :',
            cls: 'labelstyle'
        },
        custnamecombo,{
        width:80
        }
    ]
});

/*********************inner panel for displaying form field in window***********************/
var innerPanelForUnitDetails = new Ext.form.FormPanel({
    standardSubmit: true,
    collapsible: false,
    autoScroll: true,
    height: 200,
    width: 381,
    frame: true,
    id: 'custMaster',
    layout: 'table',
    layoutConfig: {
        columns: 4
    },
    items: [{
        xtype: 'fieldset',
        title: '<%=RouteAllocationInformation%>',
        cls: 'fieldsetpanel',
        collapsible: false,
        colspan: 2,
        id: 'addpanelid',
        width: 360,
        layout: 'table',
        layoutConfig: {
            columns: 4
        },
        items: [{
                xtype: 'label',
                text: '*',
                cls: 'mandatoryfield',
                id: 'mandatoryRouteid'
            }, {
                xtype: 'label',
                text: '<%=RouteCode%>' + ':',
                cls: 'labelstyle',
                id: 'Routeid'
            }, {
                xtype: 'numberfield',
                allowBlank: false,
                allowDecimals: false,
                cls: 'selectstylePerfect',
                emptyText: '<%=EnterRouteCode%>',
                blankText: '<%=EnterRouteCode%>',
                id: 'RouteId'
            }, {
                xtype: 'label',
                text: ''
            },
              {
                xtype: 'label',
                text: '*',
                cls: 'mandatoryfield',
                id: 'mandatoryStartid'
            }, {
                xtype: 'label',
                text: '<%=StartTime%>' + ':',
                cls: 'labelstyle',
                id: 'Startid'
            },{
                xtype: 'textfield',
                allowBlank: false,
                maskRe: /[0-9: ]/,
                allowDecimals: false,
                cls: 'selectstylePerfect',
                emptyText: '<%=EnterStartTime%>',
                blankText: '<%=EnterStartTime%>',
                regex:/^([0-1]?[0-9]|2[0-3]):([0-5][0-9])?$/,
                regexText:'Enter valid format eg,(HH:MM)',
                id: 'startId'
            }, {
                xtype: 'label',
                text: '(HH:MM)',
                cls: 'labelstyle'
            },{
                xtype: 'label',
                text: '*',
                cls: 'mandatoryfield',
                id: 'AssetId'
            },{
                xtype: 'label',
                text: '<%=AssetNumber%>' + ' :',
                cls: 'labelstyle',
                id: 'labelAssetId'
            }, 
            assetNumbercombo, {
                xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                id: 'mandatoryAssetId1'
            }, {
                xtype: 'label',
                text: '*',
                cls: 'mandatoryfield',
                id: 'typeid'
            },{
                xtype: 'label',
                text: '<%=Type%>' + ' :',
                cls: 'labelstyle',
                id: 'labelTypeId'
            },
            Typecombo, {
                xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                id: 'mandatorytypeidId1'
            }
        ]
    }]
});

/********************************button**************************************/
var innerWinButtonPanel = new Ext.Panel({
    id: 'winbuttonid',
    standardSubmit: true,
    collapsible: false,
    autoHeight: true,
    height: 100,
    width: 381,
    frame: true,
    layout: 'table',
    layoutConfig: {
        columns: 4
    },
    buttons: [{
        xtype: 'button',
        text: '<%=Save%>',
        iconCls:'savebutton',
        id: 'addButtId',
        cls: 'buttonstyle',
        width: 70,
        listeners: {
            click: {
                fn: function () {


                    if (Ext.getCmp('RouteId').getValue() == "") {
                        Ext.example.msg("<%=EnterRouteCode%>");
                        Ext.getCmp('RouteId').focus();
                        return;
                    }
					if (Ext.getCmp('startId').getValue() == "") {
					    Ext.example.msg("<%=EnterStartTime%>");
                        Ext.getCmp('startId').focus();
                        return;
                    }
                    
                    if (Ext.getCmp('assetNumberId').getValue() == "") {
                        Ext.example.msg("<%=SelectAssetNumber%>");   
                        Ext.getCmp('assetNumberId').focus();
                        return;
                    }
					
					if (Ext.getCmp('typecomboId').getValue() == "") {
					    Ext.example.msg("<%=SelectType%>");
                        Ext.getCmp('typecomboId').focus();
                        return;
                    }

                    if (innerPanelForUnitDetails.getForm().isValid()) {
                          var routeGrid;
                          var startTimeGrid;
                          var assetNoGrid;
                          var typeGrid;
                          var uniqueId;
                          var selected;
                        if (buttonValue == 'modify') {
                            selected = grid.getSelectionModel().getSelected();
                            uniqueId=selected.get('IdDataIndex');
                            routeGrid = selected.get('routeDataIndex');
                            startTimeGrid = selected.get('startTimeDataIndex');
                            assetNoGrid = selected.get('assetNumberDataIndex');
                            typeGrid = selected.get('DropTypeDataIndex');
                            // alert(selected.get('assetNumberDataIndex'));
                            //alert(uniqueId);
                        }
                        Ext.getCmp('addButtId').disable();
                        Ext.getCmp('canButtId').disable();
                        Ext.Ajax.request({
                            url: '<%=request.getContextPath()%>/SchoolRouteAllocationAction.do?param=saveRouteAllocationInformation',
                            method: 'POST',
                            params: {
                                  UniqueId:uniqueId,
                                  custId:Ext.getCmp('custcomboId').getValue(),
                                  buttonValue: buttonValue,
                                  route: Ext.getCmp('RouteId').getValue(),
                                  startTime: Ext.getCmp('startId').getValue(),
                                  assetNo: Ext.getCmp('assetNumberId').getValue(),
                                  type: Ext.getCmp('typecomboId').getValue(),
                                  RouteGrid: routeGrid,
                                  StartTimeGrid: startTimeGrid,
                                  AssetNoGrid: assetNoGrid,
                                  TypeGrid: typeGrid
                            },
                              success: function (response, options) {
                                var message = response.responseText;
                                Ext.example.msg(message);
                                myWin.hide();
                                 store.reload({
                                    params: {
                                    CustId: custId,
                                    CustName: custName,
                                    jspName:jspName
                                    }
                                  });
                                   Ext.getCmp('RouteId').reset();
                                   Ext.getCmp('startId').reset();
                                   Ext.getCmp('assetNumberId').reset();
                                   Ext.getCmp('typecomboId').reset();
                                   Ext.getCmp('addButtId').enable();
                                   Ext.getCmp('canButtId').enable();
                                   outerPanelWindow.getEl().unmask();
                            },
                            failure: function () {
                                Ext.example.msg("Failed to Insert...");
                                store.reload();
                                Ext.getCmp('addButtId').enable();
                                Ext.getCmp('canButtId').enable();
                                myWin.hide();
                            }
                        });
                    }
                }
            }
        }
    }, {
        xtype: 'button',
        text: '<%=Cancel%>',
        id: 'canButtId',
        cls: 'buttonstyle',
        iconCls: 'cancelbutton',
        width: 70,
        listeners: {
            click: {
                fn: function () {
                    myWin.hide();
                  Ext.getCmp('RouteId').reset();
                  Ext.getCmp('startId').reset();
                  Ext.getCmp('assetNumberId').reset();
                  Ext.getCmp('typecomboId').reset();
                }
            }
        }
    }]
});
/***********panel contains window content info***************************/
var outerPanelWindow = new Ext.Panel({
    //width:540,
    cls: 'outerpanelwindow',
    standardSubmit: true,
    frame: false,
    items: [innerPanelForUnitDetails, innerWinButtonPanel]
});
/***********************window for form field****************************/
myWin = new Ext.Window({
    title: 'titel',
    closable: false,
    modal: true,
    resizable: false,
    autoScroll: false,
    cls: '',
    //height : 400,
    width: 395,
    id: 'myWin',
    items: [outerPanelWindow]
});

//***********************************function for add button in grid that will open form window**************************************************//
function addRecord() {
if (Ext.getCmp('custcomboId').getValue() == "") {
	    Ext.example.msg("Select Customer");
        Ext.getCmp('custcomboId').focus();
        return;
    }
    buttonValue = "add";
    titel = '<%=Add%>';
    myWin.show();
     Ext.getCmp('typecomboId').enable();
        Ext.getCmp('RouteId').reset();
        Ext.getCmp('startId').reset();
        Ext.getCmp('assetNumberId').reset();
        Ext.getCmp('typecomboId').reset();
        
    myWin.setTitle(titel);
	
}
//**************************************function for modify button in grid that will open form window*********************************************//
function modifyData() {
    if (grid.getSelectionModel().getCount() > 1) {
        Ext.example.msg("<%=SelectSingleRow%>");
        return;
    }

    if (grid.getSelectionModel().getSelected() == null) {
        Ext.example.msg("<%=NoRowsSelected%>");
        return;
    }
    buttonValue = "modify";
    titelForInnerPanel = '<%=Modify%>';
     custId = Ext.getCmp('custcomboId').getValue();
    var selected = grid.getSelectionModel().getSelected();
           myWin.setPosition(450, 150);
           myWin.setTitle(titelForInnerPanel);
            myWin.show();
             Ext.getCmp('typecomboId').disable();
            Ext.getCmp('RouteId').setValue(selected.get('routeDataIndex'));
            Ext.getCmp('startId').setValue(selected.get('startTimeDataIndex'));
            Ext.getCmp('assetNumberId').setValue(selected.get('assetNumberDataIndex'));
            Ext.getCmp('typecomboId').setValue(selected.get('DropTypeDataIndex'));
}
//******************function for delete button in grid that will open form window********************************//
function deleteData() {
    if (grid.getSelectionModel().getCount() > 1) {
        Ext.example.msg("<%=SelectSingleRow%>");
        return;
    }

    if (grid.getSelectionModel().getSelected() == null) {
        Ext.example.msg("<%=NoRowsSelected%>");
        return;
    }
    Ext.Msg.show({
        title: '<%=DeleteRouteDetails%>',
        msg: '<%=Areyousureyouwanttodelete%>',
        progressText: 'Deleting  ...',
        buttons: {
            yes: true,
            no: true
        },
        fn: function (btn) {
            switch (btn) {
            case 'yes':
                var selected = grid.getSelectionModel().getSelected();
                var uniqueId=selected.get('IdDataIndex');
                var custId = Ext.getCmp('custcomboId').getValue();
                var routeGrid = selected.get('routeDataIndex');
				var type=selected.get('DropTypeDataIndex');
                Ext.Ajax.request({
                    url: '<%=request.getContextPath()%>/SchoolRouteAllocationAction.do?param=deleteRoueAllocationDetails',
                    method: 'POST',
                    params: {
                        UniqueId:uniqueId,
                        CustId:custId,
                        route:routeGrid,
                        type:type
                    },
                    success: function (response, options) {
                        var message = response.responseText;
                        Ext.example.msg(message);
                       store.reload();
                       outerPanelWindow.getEl().unmask();
                    },
                    failure: function () {
                        Ext.example.msg("Error");
                        store.reload();
                        outerPanelWindow.getEl().unmask();

                    }
                });

                break;
            case 'no':
                Ext.example.msg("RouteDetails not Deleted..");
                store.reload();
                break;

            }
        }
    });
}


//***************************jsonreader****************************************************************//
var reader = new Ext.data.JsonReader({
    root: 'routeDetailsRoot',
    totalProperty: 'total',
    fields: [{
        name: 'slnoDataIndex'
    },{
        name: 'routeDataIndex'
    },{
        name: 'startTimeDataIndex'
    },{
        name: 'assetNumberDataIndex'
    }, {
        name: 'DropTypeDataIndex'
    },{
        name:'IdDataIndex'
    }]
});

//************************* store configs****************************************//
var custName=Ext.getCmp('custcomboId').getRawValue();
var store = new Ext.data.GroupingStore({
    proxy: new Ext.data.HttpProxy({
        url: '<%=request.getContextPath()%>/SchoolRouteAllocationAction.do?param=getRouteAllocationDetails',
        method: 'POST'
    }),
     remoteSort: false,
    sortInfo: {
        field: 'routeDataIndex',
        direction: 'asc'
    },
    bufferSize: 700,
    reader: reader
});
//****************************grid filters*************************************************//
var filters = new Ext.ux.grid.GridFilters({
    local: true,
    filters: [{
            dataIndex: 'slnoDataIndex',
             type: 'numeric'
        }, {
            dataIndex: 'routeDataIndex',
            type: 'int'
        }, {
            dataIndex: 'startTimeDataIndex',
            type: 'String'
        }, {
            dataIndex: 'assetNumberDataIndex',
            type: 'String'
        }, {
            dataIndex: 'DropTypeDataIndex',
            type: 'String'
        }
    ]
});
//****************column Model Config***************************************************//
var createColModel = function (finish, start) {

     var columns = [
         new Ext.grid.RowNumberer({
             header: "<span style=font-weight:bold;><%=SLNO%></span>",
             width: 50
         }), {
             dataIndex: 'slnoDataIndex',
             hidden: true,
             header: "<span style=font-weight:bold;><%=SLNO%></span>",
             width: 100,
             filter: {
                 type: 'numeric'
             }
			},{
            header: "<span style=font-weight:bold;><%= RouteCode%></span>",
            hidden: false,
            width: 110,
            sortable: true,
            dataIndex: 'routeDataIndex',
            filter: {
                type: 'String'
            }
        },{
            header: "<span style=font-weight:bold;><%=StartTime%>(HH:MM)</span>",
            hidden: false,
            width: 120,
            sortable: true,
            dataIndex: 'startTimeDataIndex',
            filter: {
                type: 'float'
            }
        }, {
            header: "<span style=font-weight:bold;><%=AssetNumber%></span>",
            hidden: false,
            width: 120,
            sortable: true,
            dataIndex: 'assetNumberDataIndex',
            filter: {
                type: 'String'
            }
        },{
            header: "<span style=font-weight:bold;><%=Type%></span>",
            hidden: false,
            width: 120,
            sortable: true,
            dataIndex: 'DropTypeDataIndex',
            filter: {
                type: 'String'
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
//*****************************************grid**********************************************//

grid = getGrid('<%=RouteDetails%>', '<%=NoRecordsFound%>', store, screen.width - 40, 425, 20, filters,'', false, '', 20, false, '', false, '', false, '', jspName, exportDataType, true, '<%=PDF%>', true, '<%=Add%>', true, '<%=Modify%>', true, '<%=Delete%>');

//*****main starts from here*******************************************************************//
Ext.onReady(function () {
    ctsb = tsb;
    Ext.QuickTips.init();
    Ext.Ajax.timeout = 120000;
    Ext.form.Field.prototype.msgTarget = 'side';
    outerPanel = new Ext.Panel({
        title: '<%=ManageRoute%>',
        renderTo: 'content',
        standardSubmit: true,
        autoScroll: false,
        frame: true,
        border: false,
        layout: 'table',
        height:540,
        cls: 'outerpanel',
        layoutConfig: {
        columns: 1
         },
        items: [comboPanel,grid]
    });
    //store.load();
});
</script>
<jsp:include page="../Common/footer.jsp" />
 <!-- </body>   -->
 <!-- </html> -->
<%}%>