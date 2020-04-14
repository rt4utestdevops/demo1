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
tobeConverted.add("Add");
tobeConverted.add("Modify");
tobeConverted.add("Customer_Name");
tobeConverted.add("Select_Customer_Name");
tobeConverted.add("No_Records_Found");
tobeConverted.add("Clear_Filter_Data");
tobeConverted.add("SLNO");
tobeConverted.add("Id");
tobeConverted.add("Excel");
tobeConverted.add("Delete");
tobeConverted.add("No_Rows_Selected");
tobeConverted.add("Select_Single_Row");
tobeConverted.add("Save");
tobeConverted.add("Cancel");


ArrayList<String> convertedWords = new ArrayList<String>();
convertedWords = cf.getLanguageSpecificWordForKey(tobeConverted,language);

String Add=convertedWords.get(0);
String Modify=convertedWords.get(1);
String CustomerName=convertedWords.get(2);
String SelectCustomerName=convertedWords.get(3);
String NoRecordsFound=convertedWords.get(4);
String ClearFilterData=convertedWords.get(5);
String SLNO=convertedWords.get(6);
String ID=convertedWords.get(7);
String Excel=convertedWords.get(8);
String Delete=convertedWords.get(9);
String NoRowsSelected=convertedWords.get(10);
String SelectSingleRow=convertedWords.get(11);
String Save=convertedWords.get(12);
String Cancel=convertedWords.get(13);

String motherRouteMaster="Mother Route Master";
String Add_MotherRouteMaster ="Add Mother Route Details";
String Modify_MotherRouteMaster ="Modify Mother Route Details";
String titleForInactiveWin ="Reason for Inactive";
String EnterReasonForInactive ="Enter Reason For Inactive";
String mRouteName="Mother Route Name";
String Enter_mRouteName="Enter Mother Route Name";
String tripSheetLimit="Mother Route Density";
String Enter_tripSheetLimit="Enter Mother Route Density";
String tsAssigned="Mother Route Tripsheet Assigned";
String tsBalance="Mother Route Tripsheet Balance";
String status="Status";

int userId=loginInfo.getUserId(); 
String userAuthority=cf.getUserAuthority(systemId,userId);	

if(customerId > 0 && loginInfo.getIsLtsp()== -1 && !userAuthority.equalsIgnoreCase("Admin"))
	{
		response.sendRedirect(request.getContextPath()+ "/Jsps/Common/401Error.html");
	}
	else{

%>
<!DOCTYPE HTML>
<html>
 <head>
 		<title>Mother Route Master</title>		
</head>	    
	 <style>
  .x-panel-tl
	{
		border-bottom: 0px solid !important;
	}
  </style>
  <body>
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
var jspName = "Mother Route Master";
var exportDataType = "int,string,int,string,string,string,string,string,string,string,string,int";
var selected;
var id;
var grid;
var buttonValue;
var titelForInnerPanel;
var myWin;
var inactiveWin;
var usedTripsheetCount=0;

var clientcombostore = new Ext.data.JsonStore({
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
                store.load({
                    params: {
                        custId: custId,
                        jspName: jspName,
                        custName: Ext.getCmp('custcomboId').getRawValue()
                    }
                });
            }
        }
    }
});

var Client = new Ext.form.ComboBox({
    store: clientcombostore,
    id: 'custcomboId',
    mode: 'local',
    forceSelection: true,
    emptyText: '<%=SelectCustomerName%>',
    blankText: '<%=SelectCustomerName%>',
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
                store.load({
                    params: {
                        custId: custId,
                        jspName: jspName,
                        custName: Ext.getCmp('custcomboId').getRawValue()
                    }
                });
            }
        }
    }
});

var customerComboPanel = new Ext.Panel({
    standardSubmit: true,
    collapsible: false,
    id: 'customerComboPanelId',
    layout: 'table',
    frame: false,
    width: screen.width - 12,
    height: 40,
    layoutConfig: {
        columns: 13
    },
    items: [{
            xtype: 'label',
            text: '<%=CustomerName%>' + ' :',
            cls: 'labelstyle'
        },
        Client
    ]
});
 
var innerPanel = new Ext.form.FormPanel({
    standardSubmit: true,
    collapsible: false,
    //autoScroll: true,
    height: 200,
    width: 570,
    frame: false,
    id: 'innerPanelId',
    layout: 'table',
    layoutConfig: {
        columns: 3
    },
    items: [{
        xtype: 'fieldset',
        title:'<%=motherRouteMaster%>',
        cls: 'my-fieldset',
        collapsible: false,
        colspan:3,
        id: 'fieldsetId',
        width: 550,
        height: 200,
        layout: 'table',
        layoutConfig: {
            columns: 3
        },
        items: [{
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'nameManId'
        },{
            xtype: 'label',
            text: '<%=mRouteName%>' + ' :',
            cls: 'labelstylenew',
            id: 'nameLabId'
        }, {
            xtype: 'textfield',
            cls: 'selectstylePerfectnew',
            id: 'nameId',
            mode: 'local',
            forceSelection: true,
            emptyText: '<%=Enter_mRouteName%>',
            blankText: '<%=Enter_mRouteName%>',
            selectOnFocus: true,
            allowBlank: false,
           listeners:{
					change: function(field, newValue, oldValue){
					field.setValue(newValue.toUpperCase().trim());
					 if(field.getValue().length> 100){
					 Ext.example.msg("Field exceeded it's Maximum length");
					field.setValue(newValue.substr(0,100).toUpperCase().trim()); field.focus(); } 
					 }
					}
        },  {
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'tsLimitManId'
        },{
            xtype: 'label',
            text: '<%=tripSheetLimit%>' + ' :',
            cls: 'labelstylenew',
            id: 'tsLimitLabId'
        }, {
            xtype: 'numberfield',
            cls: 'selectstylePerfectnew',
            id: 'tsLimitId',
            allowBlank: false,
            allowNegative: false,
            anchor: '90%',
            blankText: '<%=Enter_tripSheetLimit%>',
            emptyText: '<%=Enter_tripSheetLimit%>',
            autoCreate: {tag: "input",maxlength: 8,type: "text",size: "50",autocomplete: "off"},
            listeners:{ change: function(f, n, o){
            	 f.setValue(Math.round(Math.abs(n)));
            	 if(Ext.getCmp('tsAssignedId').getValue()!=null){
            	 	Ext.getCmp('tsBalanceId').setValue(n-Number(Ext.getCmp('tsAssignedId').getValue()));
            	 }
            } },
        },  {
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'tsAssignedManId'
        }, {
            xtype: 'label',
            text: '<%=tsAssigned%>' + ' :',
            cls: 'labelstylenew',
            id: 'tsAssignedLabId'
        }, {
            xtype: 'numberfield',
            cls: 'selectstylePerfectnew',
            id: 'tsAssignedId',
            forceSelection: true,
            readOnly:true
        },  {
           xtype: 'label',
           text: '*',
           cls: 'mandatoryfield',
           id: 'tsBalanceManId'
       }, {
           xtype: 'label',
           text: '<%=tsBalance%>' + ' :',
           cls: 'labelstylenew',
           id: 'tsBalanceLabId'
       }, {
            xtype: 'numberfield',
            cls: 'selectstylePerfectnew',
            id: 'tsBalanceId',
            forceSelection: true,
            readOnly:true
       }]
    }]
});

var innerWinButtonPanel = new Ext.Panel({
    id: 'innerWinButtonPanelId',
    standardSubmit: true,
    collapsible: false,
    autoHeight: true,
    height: 80,
    width: 545,
    frame: false,
    layout: 'table',
    layoutConfig: {
        columns: 4
    },
    buttons: [{
        xtype: 'button',
        text: 'Save',
        id: 'saveButtonId',
        cls: 'buttonstyle',
        iconCls:'savebutton',
        width: 70,
        listeners: {
            click: {
                fn: function() {
                	  if(Ext.getCmp('nameId').getValue()==""){
                	  	Ext.example.msg("<%=Enter_mRouteName%>");
                	  	Ext.getCmp('nameId').focus();
                	  	return;
                	  }
                	  var pattern = /^[a-zA-Z0-9][a-zA-Z0-9\s]*/;
                	  if (!pattern.test(Ext.getCmp('tsLimitId').getValue())){
                         Ext.example.msg("<%=Enter_tripSheetLimit%>");
                         Ext.getCmp('tsLimitId').focus();
                         return;
                      }
                	  if (buttonValue == '<%=Modify%>') {
                          selected = grid.getSelectionModel().getSelected();
                          id = selected.get('uidInd');
                          if(Number(usedTripsheetCount)>Number(Ext.getCmp('tsLimitId').getValue())){
                          	Ext.example.msg("Mother route limit should not lesser than Sub routes Tripsheet limit.");
                          	Ext.getCmp('tsLimitId').focus();
                           	return;
                          }
                       }
                   
                       outerPanelWindow.getEl().mask();
                        Ext.Ajax.request({
                            url: '<%=request.getContextPath()%>/MotherRouteMasterAction.do?param=AddorModifyMotherRouteMaster',
                            method: 'POST',
                            params: {
                                buttonValue: buttonValue,
                                custId: Ext.getCmp('custcomboId').getValue(),
                                custName: Ext.getCmp('custcomboId').getRawValue(),
                                mRouteName: Ext.getCmp('nameId').getValue(),
    							tsLimit: Ext.getCmp('tsLimitId').getValue(),
                                id: id
                            },
                            success: function(response, options) {
                                var message = response.responseText;
                                Ext.example.msg(message);
                                myWin.hide();
                                outerPanelWindow.getEl().unmask();
                                store.load({
                                    params: {
                                        custId: custId,
                                        jspName: jspName,
                            			custName: Ext.getCmp('custcomboId').getRawValue()
                                    }
                                });
                            },
                            failure: function() {
                                Ext.example.msg("Error");
                                store.reload();
                                myWin.hide();
                            }
                        });
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
                fn: function() {
                    myWin.hide();
                }
            }
        }
    }]
});

var outerPanelWindow = new Ext.Panel({
    width: 550,
    height: 300,
    standardSubmit: true,
    frame: true,
    items: [innerPanel, innerWinButtonPanel]
});

myWin = new Ext.Window({
    title: titelForInnerPanel,
    closable: false,
    resizable: false,
    modal: true,
    autoScroll: false,
    height: 300,
    width: 570,
    id: 'myWin',
    items: [outerPanelWindow]
});
//--------------inactiveWin-----------//
var inactiveInnerPanel = new Ext.form.FormPanel({
    standardSubmit: true,
    collapsible: false,
    height: 200,
    width: 570,
    frame: false,
    id: 'inactiveInnerPanelId',
    items: [{
        xtype: 'fieldset',
        title:'<%=titleForInactiveWin%>',
        cls: 'my-fieldset',
        collapsible: false,
        id: 'inactivefieldsetId',
        height: 180,
        width: 340,
        layout: 'table',
        layoutConfig: {
            columns: 3
        },
        items: [{
            xtype: 'textarea',
            cls: 'selectstylePerfectnew',
            stripCharsRe: /[,]/,
            height: 60,
            width: 300,
            colspan: 2,
            model: 'local',
            id: 'inactiveTAreaId',
            emptyText: '<%=EnterReasonForInactive%>',
            blankText: '<%=EnterReasonForInactive%>',
            listeners:{
			 change: function(field, newValue, oldValue){
			    field.setValue(newValue.trim());
			    if(field.getValue().length> 500){ Ext.example.msg("Field exceeded it's Maximum length"); 
				  field.setValue(newValue.substr(0,500).toUpperCase().trim()); field.focus(); 
			    } 
			 }
			}
        },{}, {
        colspan:3,
        xtype: 'label',
        text: 'Note: All sub routes will be Inactive.',
        cls: 'mandatoryfield',
        },{colspan:3, height:10}, {
        xtype: 'button',
        text: 'Save',
        cls: 'buttonstyle',
        iconCls:'savebutton',
        width: 70,
        listeners: {
            click: {
                fn: function() {
                	 selected = grid.getSelectionModel().getSelected();
                     id = selected.get('uidInd');
                     if(Ext.getCmp('inactiveTAreaId').getValue()==""){
                     	Ext.example.msg("<%=EnterReasonForInactive%>");
                     	Ext.getCmp('inactiveTAreaId').focus();
                     	return;
                     }
                     inactiveWinPanel.getEl().mask();
                     Ext.Ajax.request({
                         url: '<%=request.getContextPath()%>/MotherRouteMasterAction.do?param=changeStatusForMotherRoute',
                         method: 'POST',
                         params: {
                             status: selected.get('statusInd'),
                             motherRouteId: id,
 							inactiveReason: Ext.getCmp('inactiveTAreaId').getValue()
                         },
                         success: function(response, options) {
                             var message = response.responseText;
                             Ext.example.msg(message);
                             myWin.hide();
                             inactiveWin.hide();
                             inactiveWinPanel.getEl().unmask();
                             store.load({
                                 params: {
                                     custId: custId,
                                     jspName: jspName,
                         			custName: Ext.getCmp('custcomboId').getRawValue()
                                 }
                             });
                         },
                         failure: function() {
                             Ext.example.msg("Error");
                             store.reload();
                             myWin.hide();
                             inactiveWin.hide();
                         }
                     });
                }
            }
        }
    }, {
        xtype: 'button',
        text: '<%=Cancel%>',
        cls: 'buttonstyle',
        iconCls: 'cancelbutton',
        width: 70,
        listeners: {
            click: {
                fn: function() {
                    inactiveWin.hide();
                }
            }
        }
    }]
    }]
});
var inactiveWinPanel = new Ext.Panel({
    height: 200,
    width: 350,
    standardSubmit: true,
    frame: true,
    items: [inactiveInnerPanel]
});
inactiveWin = new Ext.Window({
    title: '<%=titleForInactiveWin%>',
    closable: false,
    resizable: false,
    modal: true,
    autoScroll: false,
    height: 250,
    width: 350,
    id: 'inactiveWinId',
    items: [inactiveWinPanel]
});

function addRecord() {
    if (Ext.getCmp('custcomboId').getValue() == "") {
     Ext.example.msg("<%=SelectCustomerName%>");
        return;
    }
    buttonValue = '<%=Add%>';
    titelForInnerPanel = '<%=Add_MotherRouteMaster%>';
    myWin.setPosition(400, 70);
    myWin.show();
    Ext.getCmp('nameId').reset();
    Ext.getCmp('tsLimitId').reset();
    Ext.getCmp('tsAssignedId').reset();
    Ext.getCmp('tsBalanceId').reset();
	Ext.getCmp('tsAssignedManId').hide();
    Ext.getCmp('tsAssignedLabId').hide();
    Ext.getCmp('tsAssignedId').hide();
    Ext.getCmp('tsBalanceManId').hide();
    Ext.getCmp('tsBalanceLabId').hide();
    Ext.getCmp('tsBalanceId').hide();
   
    myWin.setTitle(titelForInnerPanel);
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
    buttonValue = '<%=Modify%>';
    titelForInnerPanel = '<%=Modify_MotherRouteMaster%>';
    myWin.setPosition(400, 70);
    myWin.setTitle(titelForInnerPanel);
    myWin.show();
 
    var selected = grid.getSelectionModel().getSelected();
    usedTripsheetStore.load({
    	params:{
    		motherRouteId: selected.get('uidInd')
    	},
    	callback:function(){
    		usedTripsheetCount=usedTripsheetStore.getAt(0).get('usedTripsheetCount');
    		Ext.getCmp('tsAssignedId').setValue(usedTripsheetCount);
    		Ext.getCmp('tsBalanceId').setValue(Number(selected.get('tsLimitInd') - usedTripsheetCount));
    	}
    });
    Ext.getCmp('nameId').setValue(selected.get('mRouteNameInd'));
    Ext.getCmp('tsLimitId').setValue(selected.get('tsLimitInd'));
    Ext.getCmp('tsAssignedManId').show();
    Ext.getCmp('tsAssignedLabId').show();
    Ext.getCmp('tsAssignedId').show();
    Ext.getCmp('tsBalanceManId').show();
    Ext.getCmp('tsBalanceLabId').show();
    Ext.getCmp('tsBalanceId').show();
    }
function deleteData(){//Active/Iactive Function
	myWin.hide();
	var selected = grid.getSelectionModel().getSelected();
	var status=selected.get('statusInd');
	if(status=="Inactive"){
		Ext.MessageBox.confirm('Confirm', "All sub routes will be Active. Do you want to continue?",
		    function(btn){
			    if(btn == 'yes'){
				   Ext.MessageBox.show({ }); // END OF MESSAGEBOX.show()
		    myWin.hide();
		    inactiveWin.hide();
		    Ext.MessageBox.hide();
		    
		     id = selected.get('uidInd');
             Ext.Ajax.request({
                 url: '<%=request.getContextPath()%>/MotherRouteMasterAction.do?param=changeStatusForMotherRoute',
                 method: 'POST',
                 params: {
                     status: selected.get('statusInd'),
                     motherRouteId: id,
					 inactiveReason: Ext.getCmp('inactiveTAreaId').getValue()
                 },
                 success: function(response, options) {
                     var message = response.responseText;
                     Ext.example.msg(message);
                     myWin.hide();
                     inactiveWin.hide();
                     store.load({
                         params: {
                            custId: custId,
                            jspName: jspName,
                 			custName: Ext.getCmp('custcomboId').getRawValue()
                         }
                     });
                 },
                 failure: function() {
                     Ext.example.msg("Error");
                     store.reload();
                     myWin.hide();
                     inactiveWin.hide();
                 }
             }); 
		    
		 }//if--yes
	    });// End of MESSAGEBOX.confirm()
	}else{
		Ext.getCmp('inactiveTAreaId').reset();
    	inactiveWin.show();
    	inactiveWin.setPosition(500, 100);
    }	
 }    
var reader = new Ext.data.JsonReader({
    idProperty: 'readerId',
    root: 'motherRouteMasterRoot',
    totalProperty: 'total',
    fields: [{
        name: 'slnoIndex'
    },{
    	name: 'uidInd'
    }, {
        name: 'mRouteNameInd'
    }, {
        name: 'tsLimitInd'
    }, {
        name: 'statusInd'
    }, {
        name: 'inactiveReasonInd'
    }, {
        name: 'statusChangedTimeInd',
        type: 'date'
    }, {
        name: 'statusChangedByInd'
    }, {
        name: 'insertedTimeInd',
        type: 'date'
    }, {
        name: 'insertedByInd'
    }, {
    	name: 'updatedTimeInd',
    	type: 'date'
    }, ,{
    	name: 'updatedByInd'
    }]
});

var store = new Ext.data.GroupingStore({
    autoLoad: false,
    proxy: new Ext.data.HttpProxy({
       url: '<%=request.getContextPath()%>/MotherRouteMasterAction.do?param=getMotherRouteMaster',
        method: 'POST'
    }),
    storeId: 'storeId',
    reader: reader
});

var usedTripsheetStore = new Ext.data.JsonStore({
    url: '<%=request.getContextPath()%>/MotherRouteMasterAction.do?param=getUsedTripsheetCount',
    id: 'usedTripsheetStoreId',
    root: 'usedTripsheetStoreRoot',
    autoload: false,
    remoteSort: true,
    fields: ['usedTripsheetCount']
});

var filters = new Ext.ux.grid.GridFilters({
    local: true,
    filters: [{
        type: 'numeric',
        dataIndex: 'slnoIndex'
    }, {
        type: 'numeric',
        dataIndex: 'uidInd'
    }, {
        type: 'string',
        dataIndex: 'mRouteNameInd'
    }, {
        type: 'numeric',
        dataIndex: 'tsLimitInd'
    }, {
        type: 'string',
        dataIndex: 'statusInd'
    }, {
        type: 'string',
        dataIndex: 'inactiveReasonInd'
    }, {
        type: 'date',
        dataIndex: 'statusChangedTimeInd'
    }, {
        type: 'string',
        dataIndex: 'statusChangedByInd'
    }, {
        type: 'date',
        dataIndex: 'insertedTimeInd'
    }, {
        type: 'string',
        dataIndex: 'insertedByInd'
    }, {
        type: 'date',
        dataIndex: 'updatedTimeInd'
    }, {
        type: 'string',
        dataIndex: 'updatedByInd'
    }]
});
var createColModel = function(finish, start) {
    var columns = [
        new Ext.grid.RowNumberer({
            header: "<span style=font-weight:bold;><%=SLNO%></span>",
            width: 50
        }), {
            dataIndex: 'slnoIndex',
            hidden: true,
            header: "<span style=font-weight:bold;><%=SLNO%></span>",
        },{
            header: "<span style=font-weight:bold;><%=mRouteName%></span>",
            dataIndex: 'mRouteNameInd',
        }, {
            header: "<span style=font-weight:bold;><%=tripSheetLimit%></span>",
            dataIndex: 'tsLimitInd',
        }, {
            header: "<span style=font-weight:bold;><%=status%></span>",
            dataIndex: 'statusInd',
        }, {
            header: "<span style=font-weight:bold;><%=titleForInactiveWin%></span>",
            dataIndex: 'inactiveReasonInd',
        }, {
            header: "<span style=font-weight:bold;>Activated/Inactivated Time</span>",
            dataIndex: 'statusChangedTimeInd',
            renderer: Ext.util.Format.dateRenderer(getDateTimeFormat()),
         }, {
            header: "<span style=font-weight:bold;>Activated/Inactivated By</span>",
            dataIndex: 'statusChangedByInd',
        }, {
            header: "<span style=font-weight:bold;>Inserted Time</span>",
            dataIndex: 'insertedTimeInd',
            renderer: Ext.util.Format.dateRenderer(getDateTimeFormat()),
         }, {
            header: "<span style=font-weight:bold;>Inserted By</span>",
            dataIndex: 'insertedByInd',
        },  {
             header: "<span style=font-weight:bold;>Updated Time</span>",
             dataIndex: 'updatedTimeInd',
             renderer: Ext.util.Format.dateRenderer(getDateTimeFormat()),
        }, {
            header: "<span style=font-weight:bold;>Updated By</span>",
            dataIndex: 'updatedByInd',
        }, {
            dataIndex: 'uidInd',
            hidden: true,
            header: "<span style=font-weight:bold;>uid</span>",
        } ];
    return new Ext.grid.ColumnModel({
        columns: columns.slice(start || 0, finish),
        defaults: {
            sortable: true
        }
    });
};

grid = getGrid('<%=motherRouteMaster%>', '<%=NoRecordsFound%>', store, screen.width - 40, 440, 24, filters, '<%=ClearFilterData%>', false, '', 25, false, '', false, '', true, '<%=Excel%>', jspName, exportDataType, false, 'PDF', true, '<%=Add%>', true, '<%=Modify%>', true, 'Active/Inactive');
grid.getBottomToolbar().add([
'-',                             
{
    text: 'Active/Inactive',
    id: 'gridDeleteId',
    handler : function(){
    deleteData();

    }    
  }]);
Ext.onReady(function() {
    Ext.QuickTips.init();
    Ext.form.Field.prototype.msgTarget = 'side';
    outerPanel = new Ext.Panel({
        title: '',
        renderTo: 'content',
        standardSubmit: true,
        frame: true,
        width: screen.width - 22,
        cls: 'outerpanel',
        layout: 'table',
        layoutConfig: {
            columns: 1
        },
        items: [customerComboPanel, grid]
    });
    var cm =grid.getColumnModel();  
    for (var j = 1; j < cm.getColumnCount(); j++) {
       cm.setColumnWidth(j,230);
    }
    sb = Ext.getCmp('form-statusbar');
});
</script>
</body>
</html>
<%}%>
<%}%>
