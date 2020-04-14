<%@ page language="java"
	import="java.util.*,t4u.functions.CommonFunctions,t4u.beans.*,t4u.common.*"
	pageEncoding="utf-8"%>
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
	loginInfo.setStyleSheetOverride("N");;
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
cf.checkLoginInfo((LoginInfoBean)session.getAttribute("loginInfoDetails"),session,request,response);
String responseaftersubmit="''";
String feature="1";
if(session.getAttribute("responseaftersubmit")!=null){
   responseaftersubmit="'"+session.getAttribute("responseaftersubmit").toString()+"'";
	session.setAttribute("responseaftersubmit",null);
}

LoginInfoBean loginInfo=(LoginInfoBean)session.getAttribute("loginInfoDetails");
String language=loginInfo.getLanguage();
int systemid=loginInfo.getSystemId();
String systemID=Integer.toString(systemid);
int customeridlogged=loginInfo.getCustomerId();
int CustIdPassed=0;
String addModifyDel="true";
if(customeridlogged>0)
addModifyDel="false";

if(request.getParameter("CustId")!=null){
	CustIdPassed=Integer.parseInt(request.getParameter("CustId").toString().trim());
}

ArrayList<String> tobeConverted = new ArrayList<String>();
tobeConverted.add("Hub_Operational_Window");
tobeConverted.add("Customer");	
tobeConverted.add("SLNO");
tobeConverted.add("Add");
tobeConverted.add("Modify");
tobeConverted.add("Save");
tobeConverted.add("Cancel");
tobeConverted.add("Operational_Type");
tobeConverted.add("Place_Name");
tobeConverted.add("Hub_Name");
tobeConverted.add("Vehicle_Type");
tobeConverted.add("Enter_Place_Name");
tobeConverted.add("Enter_Hub_Name");
tobeConverted.add("Enter_Operational_Type");
tobeConverted.add("No_Rows_Selected");
tobeConverted.add("Select_Single_Row");
tobeConverted.add("No_Records_Found");
tobeConverted.add("Clear_Filter_Data");
tobeConverted.add("Select_Customer_Name");
tobeConverted.add("Select_Operational_Type");
tobeConverted.add("Customer_Name");
tobeConverted.add("Select_Name");
tobeConverted.add("Select_Hub_Name");
tobeConverted.add("Are_you_sure_you_want_to_delete");
tobeConverted.add("Registration_No");
tobeConverted.add("Detention");
tobeConverted.add("Arrival_Time");
tobeConverted.add("Last_Communicated_Date_Time");
tobeConverted.add("Vehicle_Count");
tobeConverted.add("Hub_Operation_Information");
tobeConverted.add("Delete");
tobeConverted.add("Details");
tobeConverted.add("Hub_Operational_Details");
tobeConverted.add("Close_Details");
tobeConverted.add("Add_Hub_Operation");

ArrayList<String> convertedWords = new ArrayList<String>();
convertedWords = cf.getLanguageSpecificWordForKey(tobeConverted,language);

String HubOperationWindow=convertedWords.get(0);
String Customer=convertedWords.get(1);
String SLNO=convertedWords.get(2);
String Add=convertedWords.get(3);
String Modify=convertedWords.get(4);
String Save=convertedWords.get(5);
String Cancel=convertedWords.get(6);
String OperationalType=convertedWords.get(7);
String PlaceName=convertedWords.get(8);
String HubName=convertedWords.get(9);
String VehicleType=convertedWords.get(10);
String EnterPlaceName=convertedWords.get(11);
String EnterHubName=convertedWords.get(12);
String EnterOperationalType=convertedWords.get(13);
String NoRowsSelected=convertedWords.get(14);
String SelectSingleRow=convertedWords.get(15);
String NoRecordsFound=convertedWords.get(16);
String ClearFilterData=convertedWords.get(17);
String SelectCustomerName=convertedWords.get(18);
String SelectOperationalType=convertedWords.get(19);
String CustomerName=convertedWords.get(20);
String SelectName=convertedWords.get(21);  
String SelectHubName=convertedWords.get(22);
String Areyousureyouwanttodelete=convertedWords.get(23);
String RegistrationNo=convertedWords.get(24);     
String Detention=convertedWords.get(25); 
String ActualArrival=convertedWords.get(26); 
String LastCommunicated=convertedWords.get(27);
String VehicleCount=convertedWords.get(28);
String HubOperationInformation=convertedWords.get(29); 
String Delete=convertedWords.get(30);
String Details=convertedWords.get(31); 
String HubOperationalDetails=convertedWords.get(32);
String CloseDetails=convertedWords.get(33); 
String AddHubOperation=convertedWords.get(34);
%>

<jsp:include page="../Common/header.jsp" />
		<title><%=HubOperationWindow%></title>
	
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
			.ext-strict .x-form-text {
				height: 21px !important;
			}
			.x-layer ul {
				min-height:26px !important;
			}			
			.x-menu-list {
				height:auto !important;
			}
		</style>
		<script>
   
var outerPanel;
var ctsb;
var jspName = "HubOperationWindow";
var exportDataType = "int,string,string,string,string";
var selected;
var grid;
var buttonValue;
var titelForInnerPanel;
var myWin;
var detailsWin;	


var clientcombostore = new Ext.data.JsonStore({
    url: '<%=request.getContextPath()%>/CommonAction.do?param=getCustomer',
    id: 'CustomerStoreId',
    root: 'CustomerRoot',
    autoLoad: true,
    remoteSort: true,
    fields: ['CustId', 'CustName'],
    listeners: {
        load: function (custstore, records, success, options) {
          if ( <%= customeridlogged %> > 0) {
          Ext.getCmp('custcomboId').setValue('<%=customeridlogged%>');
          custId = Ext.getCmp('custcomboId').getValue();
              
            }
        }
    }
});
var typeList1 = [['Plant','Mining Plant'],['Pit','Mining Pit'],['Port','Port'],['Jetty','Jetty'],['Spot','Hot Spot'],['Stack','Stack'],['Lease','Lease'] ,['Weighbridge','Weighbridge']];
var	typeStore = new Ext.data.SimpleStore({
	    		fields: ['typeId','TypeDscription'],
				data: typeList1
			});

var typeList = [['All','All'],['Plant','Mining Plant'],['Pit','Mining Pit'],['Port','Port'],['Jetty','Jetty'],['Spot','Hot Spot'],['Stack','Stack'],['Lease','Lease'] ,['Weighbridge','Weighbridge']];
var	operationcombostore = new Ext.data.SimpleStore({
	    		fields: ['typeId','TypeDscription'],
				data: typeList,
				autoLoad: false,
				listeners: {
                
                 }
			     });

var Operation1=new Ext.form.ComboBox({
    store: typeStore,
    id: 'operationcomboId1',
    mode: 'local',
    forceSelection: true,
    emptyText: '<%=SelectOperationalType%>',
    blankText: '<%=SelectOperationalType%>',
    selectOnFocus: true,
    allowBlank: false,
    anyMatch: true,
    typeAhead: false,
    triggerAction: 'all',
    lazyRender: true,
    valueField: 'typeId',
    displayField: 'TypeDscription',
    cls: 'selectstylePerfect',
    listeners: {
        select: {
               fn: function () {
               if (Ext.getCmp('operationcomboId1').getValue() == "") {
             	   Ext.getCmp('operationcomboId1').focus(),  
             	   Ext.example.msg("<%=SelectOperationalType%>");
             	return;
        		}
                custId = Ext.getCmp('custcomboId').getValue();
                PlaceNameComboStore.load({
                params: {
                CustID: Ext.getCmp('custcomboId').getValue(),
                jspName: jspName,
                hubOpID: Ext.getCmp('operationcomboId1').getValue(),
                custName: Ext.getCmp('custcomboId').getRawValue()
                    }
                });
            }
        }
    }
});
var Operation=new Ext.form.ComboBox({
 store: operationcombostore,
    id: 'operationcomboId',
    mode: 'local',
    forceSelection: true,
    emptyText: '<%=SelectOperationalType%>',
    blankText: '<%=SelectOperationalType%>',
    selectOnFocus: true,
    allowBlank: false,
    anyMatch: true,
    typeAhead: false,
    triggerAction: 'all',
    lazyRender: true,
    valueField: 'typeId',
    displayField: 'TypeDscription',
    cls: 'selectstylePerfect',
    listeners: {
        select: {
            fn: function () {
               if ( <%= customeridlogged %> > 0) {
                       Ext.getCmp('custcomboId').setValue('<%=customeridlogged%>');
                       custId = Ext.getCmp('custcomboId').getValue();
                       custName = Ext.getCmp('custcomboId').getRawValue();
                      
                       
                       if (Ext.getCmp('custcomboId').getValue() == "") 
                       {
             	       Ext.getCmp('custcomboId').focus(),  
             	       Ext.getCmp('operationcomboId').reset(),
             	       Ext.example.msg("<%=SelectCustomerName%>");
             	  return;
        		}
            custId = Ext.getCmp('custcomboId').getValue();
            hubOperationStore.load({
            params: {
            CustID: Ext.getCmp('custcomboId').getValue(),
            jspName: jspName,
            hubOpID: Ext.getCmp('operationcomboId').getValue(),
            custName: Ext.getCmp('custcomboId').getRawValue()
                    }
            });
                 } 
               if (Ext.getCmp('custcomboId').getValue() == "") {
             	Ext.getCmp('custcomboId').focus(),  
             	Ext.getCmp('operationcomboId').reset(),
             	Ext.example.msg("<%=SelectCustomerName%>");
             	return;
        		}
            custId = Ext.getCmp('custcomboId').getValue();
            hubOperationStore.load({
            params: {
            CustID: Ext.getCmp('custcomboId').getValue(),
            jspName: jspName,
            hubOpID: Ext.getCmp('operationcomboId').getValue(),
            custName: Ext.getCmp('custcomboId').getRawValue()
                    }
                });
            }
        }
    }
});
//-----------Cucstomer combo------------//

var Customer = new Ext.form.ComboBox({
    store: clientcombostore,
    id: 'custcomboId',
    mode: 'local',
    forceSelection: true,
    emptyText: '<%=SelectCustomerName%>',
    blankText: '<%=SelectCustomerName%>',
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
                if ( <%= customeridlogged %> > 0) {
                       Ext.getCmp('custcomboId').setValue('<%=customeridlogged%>');
                       custId = Ext.getCmp('custcomboId').getValue();
                       custName = Ext.getCmp('custcomboId').getRawValue();
                      
                  }     
                custId = Ext.getCmp('custcomboId').getValue();
               Ext.getCmp('operationcomboId').focus(),
               Ext.getCmp('operationcomboId').reset()
               
            }
        }
    }
});

//-----------Hub Names comboStore------------//

var PlaceNameComboStore = new Ext.data.JsonStore({
    url: '<%=request.getContextPath()%>/IronDashboardAction.do?param=getPlaceNames',
    id: 'PlaceStoreId',
    root: 'PlaceRoot',
    autoLoad: false,
    remoteSort: true,
    fields: ['PlaceId', 'PlaceName'],
    listeners: {
        load: function (custstore, records, success, options) {
           if ( <%= customeridlogged %> > 0) {
           Ext.getCmp('custcomboId').setValue('<%=customeridlogged%>');
           custId = Ext.getCmp('custcomboId').getValue();
           
           }
         }
    }
});

//-----------Hub Names comboStore------------//

var PlaceNameCombo = new Ext.form.ComboBox({
    store: PlaceNameComboStore,
    id: 'nameId',
    mode: 'local',
    forceSelection: true,
    emptyText: '<%=SelectHubName%>',
    blankText: '<%=SelectHubName%>',
    selectOnFocus: true,
    allowBlank: false,
    anyMatch: true,
    typeAhead: false,
    triggerAction: 'all',
    lazyRender: true,
    valueField: 'PlaceId',
    displayField: 'PlaceName',
    cls: 'selectstylePerfect',
    listeners: {
        select: {
            fn: function () {
                
            }
        }
    }
});

//-----------Client/Operationtype Panel------------//
var comboPanel = new Ext.Panel({
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
            cls: 'labelstyle',
            id:'customerlabel'
        },
        Customer,{
            xtype: 'label',
            text: '<%=OperationalType%>' + ' :',
            cls: 'labelstyle'
        },Operation
    ]
});

var innerPanelForHubDetails = new Ext.form.FormPanel({
    standardSubmit: true,
    collapsible: false,
    autoScroll: true,
    height: 150,
    width: 400,
    frame: true,
    id: 'custMaster',
    layout: 'table',
    layoutConfig: {
        columns: 4
    },
    items: [{
        xtype: 'fieldset',
        title: '<%=HubOperationInformation%>',
        cls: 'fieldsetpanel',
        collapsible: false,
        colspan: 3,
        id: 'addpanelid',
        width: 360,
        layout: 'table',
        layoutConfig: {
            columns: 3
        },
        items: [{
                xtype: 'label',
                text: '*',
                cls: 'mandatoryfield',
                id: 'mandatoryOpId'
            },{
                xtype: 'label',
                text: '<%=OperationalType%>' + ' :',
                cls: 'labelstyle',
                id: 'taskNameTxtId'
            }, Operation1,  {
                xtype: 'label',
                text: '*',
                cls: 'mandatoryfield',
                id: 'mandatoryTaskNameId1'
            }, {
                xtype: 'label',
                text: '<%=HubName%>' + ' :',
                cls: 'labelstyle',
                id: 'typeTxtId'
            }, PlaceNameCombo,
               {
                xtype: 'label',
                text: '*',
                cls: 'mandatoryfield',
                id: 'mandatoryTaskId'
            },{
                xtype: 'label',
                text: '<%=PlaceName%>' + ' :',
                cls: 'labelstyle',
                id: 'defaultDaysTxtId'
            },{
                xtype: 'textfield',
                emptyText: '<%=EnterPlaceName%>',
                allowBlank: false,
                blankText: '<%=EnterPlaceName%>',
                cls: 'selectstylePerfect',
                id: 'hubId'
            } 
        ]
    }]
});

var innerWinButtonPanel = new Ext.Panel({
    id: 'winbuttonid',
    standardSubmit: true,
    collapsible: false,
    autoHeight: true,
    height: 110,
    width: 380,
    frame: true,
    layout: 'table',
    layoutConfig: {
        columns: 4
    }, buttons: [{
        xtype: 'button',
        text: '<%=Save%>',
        iconCls:'savebutton',
        id: 'addButtId',
        cls: 'buttonstyle',
        width: 70,
        listeners: {
            click: {
                fn: function () {
                    if (Ext.getCmp('custcomboId').getValue() == "") {
                        Ext.example.msg("<%=SelectCustomerName%>");
                        return;
                    }
                     if (Ext.getCmp('operationcomboId1').getValue() == "") {
                         Ext.getCmp('operationcomboId1').focus(),
                         Ext.example.msg("<%=SelectOperationalType%>");
                        return;
                    }
                     
                     if (Ext.getCmp('nameId').getValue() == "") {
                        Ext.getCmp('nameId').focus(),
                        Ext.example.msg("<%=SelectHubName%>");
                        return;
                    }
                     if (Ext.getCmp('hubId').getValue().trim() == "") {
                        Ext.getCmp('hubId').focus(),   
                        Ext.example.msg("<%=EnterPlaceName%>");
                        return;
                    }
                    if (innerPanelForHubDetails.getForm().isValid()) {
                        
                        var selectdName;
                        var selected = grid.getSelectionModel().getSelected();
                        
                        if (buttonValue == 'Modify') {
                        var typeID=selected.get('slnoIndex');
                         selectdName=selected.get('ID');
                        }
                        
                        taskMasterOuterPanelWindow.getEl().mask();
                        Ext.Ajax.request({
                            url: '<%=request.getContextPath()%>/IronDashboardAction.do?param=hubOperationAddModify',
                            method: 'POST',
                            params: {
                                buttonValue: buttonValue,
                                CustID: Ext.getCmp('custcomboId').getValue(),
                                hubOpID : Ext.getCmp('operationcomboId1').getValue(),
                                nameId:Ext.getCmp('nameId').getValue(),
                                placeID:Ext.getCmp('hubId').getValue(),
                                typeID:typeID,
                                selectdName:selectdName,
                                jspName: jspName
                            },
                            success: function (response, options) {
                                var message = response.responseText;
                                Ext.example.msg(message);
                                Ext.getCmp('operationcomboId1').reset();
     							Ext.getCmp('nameId').reset();
    							Ext.getCmp('hubId').reset();
                                myWin.hide();
                                hubOperationStore.reload();
                                taskMasterOuterPanelWindow.getEl().unmask();
                            },
                            failure: function () {
                                Ext.example.msg("Error");
                                hubOperationStore.reload();
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
                }
            }
        }
    }]
});

//var selectedName;
var innerDetailsPanel = new Ext.Panel({
    id: 'innerDetailsPanel',
    standardSubmit: true,
    collapsible: false,
    autoHeight:true,
    width: 570,
    frame: true,
   // selectedName:Ext.getCmp('placeDataIndex').getValue(),
    layout: 'table',
    layoutConfig: {
        columns: 5
    },items: [{
            xtype: 'label',
            text: '<%=PlaceName%>' + ' :',
            cls: 'labelstyle1'
            
        },{
            xtype: 'label',
            text: '' ,
            cls: 'labelstyleNew1',
            id:'placeID'
        }, {width:03},{
            xtype: 'label',
            text: '<%=VehicleCount%>' + ' :',
            cls: 'labelstyle'
        },{
            xtype: 'label',
            text: '',
            cls: 'labelstyleNew1',
            id:'countID'
        } ,{
            xtype: 'label',
            text: '<%=OperationalType%>' + ' :',
            cls: 'labelstyle'
        },{
            xtype: 'label',
            text: '' ,
            cls: 'labelstyleNew1',
            id:'typeID'
        }
    ]

        
    
});

//-------------Complete Details WIN,GRID,STORE,FILTER,READER,COLMODEL,BUTTON START---------// 

var copyButtonPanel = new Ext.Panel({
     id: 'copybuttonid',
     standardSubmit: true,
     collapsible: false,
     autoHeight: true,
     height: 110,
     buttonAlign : 'center',
     width: 570,
     frame: true,
     layout: 'table',
     layoutConfig: {
         columns: 4
     },
     buttons: [{
         xtype: 'button',
         text: '<%=CloseDetails%>',
         id: 'cancelsButtId',
         cls: 'buttonstyle',
         iconCls: 'cancelbutton',
         width: 80,
         listeners: {
             click: {
                 fn: function () {
                     detailsWin.hide();
                 }
             }
         }
     }]
 });

//-------------ColumnModel for Details grid---------//
var cols1 = new Ext.grid.ColumnModel([
      new Ext.grid.RowNumberer({
            header: "<span style=font-weight:bold;>SLNO</span>",
            width: 50
        }), {
            dataIndex: 'slnoIndex',
            hidden: true,
            header: "<span style=font-weight:bold;>SLNO</span>",
            filter: {
                type: 'numeric'
            }
        },{
         header: '<b><%=RegistrationNo%></b>',
         width: 170,
         sortable: true,
         dataIndex: 'registrationNoIndex'
     }, {
         header: '<b><%=Detention%></b>',
         width: 170,
         sortable: true,
         hidden: false,
         dataIndex: 'detentionIndex'
     }, {
         header: '<b><%=ActualArrival%></b>',
         width: 170,
         sortable: true,
         hidden: false,
         dataIndex: 'actualArrivalIndex',
         renderer: Ext.util.Format.dateRenderer(getDateTimeFormat()),
         filter: {
                     type: 'date'
                 }
     }, {
         header: '<b><%=LastCommunicated%></b>',
         width: 170,
         sortable: true,
         hidden: false,
         dataIndex: 'lastCommunicatedIndex',
         renderer: Ext.util.Format.dateRenderer(getDateTimeFormat()),
         filter: {
                     type: 'date'
                 }
                } 
 ]);
//-------------Reader for Details grid---------//
var reader1 = new Ext.data.JsonReader({
     root: 'DetailsRoot',
     fields: [{
         name: 'slnoIndex',
         type: 'int'
     }, {
         name: 'registrationNoIndex',
         type: 'string'
     },  {
         name: 'detentionIndex',
         type: 'string'
     },  {
         name: 'actualArrivalIndex',
         type: 'date',
          dateFormat: getDateTimeFormat() 
     },   {
         name: 'lastCommunicatedIndex',
         type: 'date',
          dateFormat: getDateTimeFormat() 
        
     }]
 });

//-------------Filter for Details grid---------//
 var filters1 = new Ext.ux.grid.GridFilters({
     local: true,
     filters: [{
             dataIndex: 'registrationNoIndex',
             type: 'string'
         }, {
             dataIndex: 'detentionIndex',
             type: 'string'
         }, {
             dataIndex: 'actualArrivalIndex',
             type: 'date'
         }, {
             dataIndex: 'lastCommunicatedIndex',
             type: 'date'
         }

     ]
 });
//-------------Grid Store for Details grid---------//
var detailsGridStore = new Ext.data.Store({
     url: '<%=request.getContextPath()%>/IronDashboardAction.do?param=getDetails',
     bufferSize: 367,
     reader: reader1,
     autoLoad: true,
     remoteSort: true
 });

var detailsGrid = new Ext.grid.GridPanel({
     title: 'Details',
     id: 'detailsGrid',
     ds: detailsGridStore,
     frame: true,
     cm: cols1,
     loadMask: true,
     view: new Ext.grid.GridView({
         nearLimit: 3,
         emptyText: 'NoRecordsFound',deferEmptyText: false
     }),
     plugins: [filters1],
     stripeRows: true,
     height: 230,
     width: 570,
     autoScroll: true
     
 });

var detailsOuterPanelWindow = new Ext.Panel({
     standardSubmit: true,
     height: 345,
     width: 595,
     frame: true,
     items: [innerDetailsPanel,detailsGrid, copyButtonPanel]
 });
 
detailsWin= new Ext.Window({
	title:'Details',
    closable: false,
    resizable: false,
    modal: true,
    autoScroll: false,
    height: 380,
    width: 600,
    id: 'detailsWin',
    items: [detailsOuterPanelWindow]
});

//-------------Complete Details WIN,GRID,STORE,FILTER,READER,COLMODEL,BUTTON END---------//

var taskMasterOuterPanelWindow = new Ext.Panel({
    width: 390,
    height:220,
    standardSubmit: true,
    frame: false,
    items: [innerPanelForHubDetails, innerWinButtonPanel]
});

myWin = new Ext.Window({
    title: titelForInnerPanel,
    closable: false,
    resizable: false,
    modal: true,
    autoScroll: false,
    height: 250,
    width: 390,
    id: 'myWin',
    items: [taskMasterOuterPanelWindow]
});

//----Add,modify,delete and details functions---------------//
                                                  
function addRecord() {
    if (Ext.getCmp('custcomboId').getValue() == "") {
        Ext.example.msg("<%=SelectCustomerName%>");
        return;
    }
    buttonValue = '<%=Add%>';
    titelForInnerPanel = '<%=AddHubOperation%>';
    myWin.setPosition(450, 150);
    myWin.setTitle(titelForInnerPanel);
    Ext.getCmp('operationcomboId1').enable();
    Ext.getCmp('operationcomboId1').reset();
    Ext.getCmp('nameId').reset();
    Ext.getCmp('hubId').reset();
    myWin.show();
}

function modifyData() {
    if (Ext.getCmp('custcomboId').getValue() == "") {
        Ext.example.msg("<%=SelectCustomerName%>");
        return;
    }
    if (grid.getSelectionModel().getCount() == 0) {
        Ext.example.msg("<%=NoRowsSelected%>");
        return;
    }
    if (grid.getSelectionModel().getCount() > 1) {
        Ext.example.msg("<%=SelectSingleRow%>");
        return;
    }
    PlaceNameComboStore.load({
                params: {
                CustID: Ext.getCmp('custcomboId').getValue(),
                jspName: jspName,
                hubOpID: Ext.getCmp('operationcomboId1').getValue(),
                custName: Ext.getCmp('custcomboId').getRawValue()
                    }
                });
    buttonValue = 'Modify';
   
    titelForInnerPanel = 'Modify';
    myWin.setPosition(450, 150);
    myWin.setTitle(titelForInnerPanel);
    
    Ext.getCmp('operationcomboId1').disable();
    Ext.getCmp('nameId').show();
    Ext.getCmp('hubId').show();
    var selected = grid.getSelectionModel().getSelected();
    Ext.getCmp('operationcomboId1').setValue(selected.get('operationTypeIndex'));
    Ext.getCmp('hubId').setValue(selected.get('hubDataIndex'));
    Ext.getCmp('nameId').setValue(selected.get('placeDataIndex'));
    myWin.show();
}

//function for delete button in grid that will open form window

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
        title: 'Delete',
        msg: '<%=Areyousureyouwanttodelete%>',
        progressText: 'Deleting  ...',
        buttons: {
            yes: true,
            no: true
        },

        fn: function (btn) {
            switch (btn) {
            case 'yes':
                // outerPanelWindow.getEl().mask();
                //Ajax request
                var selected = grid.getSelectionModel().getSelected();
                var locID = selected.get('ID');
                var typeID=selected.get('slnoIndex');
                Ext.Ajax.request({
                    url: '<%=request.getContextPath()%>/IronDashboardAction.do?param=deleteHubDetails',
                    method: 'POST',
                    params: {
                    CustID:Ext.getCmp('custcomboId').getValue(),
                    locID:locID,
                    typeID:typeID 
                    },
                    success: function (response, options) {

                        var message = response.responseText;
                        Ext.example.msg(message);
                        hubOperationStore.reload();
                        outerPanelWindow.getEl().unmask();
                    },
                    failure: function () {
                        Ext.example.msg("Error");
                        hubOperationStore.reload();
                        outerPanelWindow.getEl().unmask();

                    }
                });

                break;
            case 'no':
                Ext.example.msg("Hub Operation not Deleted.");
                break;

            }
        }
    });
}


 function getDetails() {  
 
    if (grid.getSelectionModel().getCount() == 0) {
        Ext.example.msg("<%=NoRowsSelected%>");
        return;
    }
    if (grid.getSelectionModel().getCount() > 1) {
        Ext.example.msg("<%=SelectSingleRow%>");
        return;
    }
    buttonValue = 'Details';
    titelForInnerPanel = 'Details';
    
    detailsWin.setPosition(410, 120);
    detailsWin.setTitle(titelForInnerPanel);
    Ext.getCmp('operationcomboId1').show();
    Ext.getCmp('nameId').show();
    Ext.getCmp('hubId').show();
    
    
    var selected = grid.getSelectionModel().getSelected();
    
    Ext.getCmp('typeID').setText(selected.get('operationTypeIndex'));
    Ext.getCmp('placeID').setText(selected.get('placeDataIndex'));
    Ext.getCmp('countID').setText(selected.get('vehicleDataIndex'));
    Ext.getCmp('nameId').setValue(selected.get('placeDataIndex'));
    
    detailsGridStore.load({
                 params: {
            CustID:Ext.getCmp('custcomboId').getValue(),
            NameID:Ext.getCmp('nameId').getValue()
         }
     });
    detailsWin.show();
}
  
//----End of Add,modify,delete and details functions---------------//

var reader = new Ext.data.JsonReader({
    idProperty: 'hubOpstoreId',
    root: 'hubOperationRoot',
    totalProperty: 'total',
    fields: [{
        name: 'slnoIndex'
    }, {
        name: 'placeDataIndex'
    }, {
        name: 'hubDataIndex'
    }, {
        name: 'operationTypeIndex'
    }, {
        name: 'vehicleDataIndex'
    }, {
        name:'id'
    }, {
        name:'ID'
    }]
});

var hubOperationStore = new Ext.data.GroupingStore({
    autoLoad: false,
    proxy: new Ext.data.HttpProxy({
        url: '<%=request.getContextPath()%>/IronDashboardAction.do?param=getTypes',
        method: 'POST',
        params: {
                                hubOpid:Ext.getCmp('operationcomboId').getValue(),
                                CustID: Ext.getCmp('custcomboId').getValue(),
                                custName: Ext.getCmp('custcomboId').getValue(),
                                id: id,
                                jspName: jspName
                            }
    }),
    storeId: 'hubOpstoreId',
    reader: reader
});

var filters = new Ext.ux.grid.GridFilters({
    local: true,
    filters: [{
        type: 'numeric',
        dataIndex: 'slnoIndex'
    }, {
        type: 'string',
        dataIndex: 'placeDataIndex'
    }, {
        type: 'string',
        dataIndex: 'hubDataIndex'
    }, {
        type: 'string',
        dataIndex: 'operationTypeIndex'
    }, {
        type: 'int',
        dataIndex: 'vehicleDataIndex'
    }, {
        type: 'string',
        dataIndex: 'ID'
    }]
});

var createColModel = function (finish, start) {
    var columns = [
        new Ext.grid.RowNumberer({
            header: "<span style=font-weight:bold;><%=SLNO%></span>",
            width: 50
        }), {
            dataIndex: 'slnoIndex',
            hidden: true,
            hideable:false,
            header: "<span style=font-weight:bold;><%=SLNO%></span>",
            filter: {
                type: 'numeric'
            }
        }, {
            header: "<span style=font-weight:bold;><%=PlaceName%></span>",
            dataIndex: 'hubDataIndex',
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=HubName%></span>",
            dataIndex: 'placeDataIndex',
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=OperationalType%></span>",
            dataIndex: 'operationTypeIndex',
            filter: {
                type: 'string'
            }
        }, {
            dataIndex: 'vehicleDataIndex',
            header: "<span style=font-weight:bold;><%=VehicleCount%></span>",
            filter: {
                type: 'int'
            }
        },{
            dataIndex: 'ID',
            hidden: true,
            hideable: false,
            header: "<span style=font-weight:bold;>ID</span>",
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

//*****************************************************************Grid *******************************************************************************
grid = getHubOpearationGrid('<%=HubOperationalDetails%>', 'NoRecordsFound', hubOperationStore, screen.width - 40, 445, 10, filters, '<%=ClearFilterData%>', false, '', 16, false, '', false, '', false, '', jspName, exportDataType, false, '', <%=addModifyDel%>, '<%=Add%>', <%=addModifyDel%>, '<%=Modify%>',<%=addModifyDel%>,'<%=Delete%>',true,'<%=Details%>');
//******************************************************************************************************************************************************
Ext.onReady(function () {
    ctsb = tsb;
    Ext.QuickTips.init();
    Ext.form.Field.prototype.msgTarget = 'side';
    outerPanel = new Ext.Panel({
        title: '',
        renderTo: 'content',
        standardSubmit: true,
        frame: true,
        cls: 'outerpanel',
        layout: 'table',
        layoutConfig: {
            columns: 1
        },
        items: [comboPanel, grid]
    });
    sb = Ext.getCmp('form-statusbar');
     
});
</script>
 <jsp:include page="../Common/footer.jsp" />
	<!-- </body>   -->
<!-- </html> -->