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

tobeConverted.add("Select_Customer_Name");
tobeConverted.add("Add");
tobeConverted.add("Clear_Filter_Data");
tobeConverted.add("Save");
tobeConverted.add("Cancel");
tobeConverted.add("SLNO");
tobeConverted.add("No_Records_Found");
tobeConverted.add("Customer_Name");
tobeConverted.add("Select_Asset_Number");
tobeConverted.add("Please_Select_Asset_Number");
tobeConverted.add("Please_Select_customer");
tobeConverted.add("Status");
tobeConverted.add("Asset_Number");
tobeConverted.add("Select_Single_Row");
tobeConverted.add("No_Rows_Selected");
tobeConverted.add("Are_you_sure_you_want_to_delete");

ArrayList<String> convertedWords = new ArrayList<String>();
convertedWords = cf.getLanguageSpecificWordForKey(tobeConverted,language);

String SelectCustomerName=convertedWords.get(0);
String Add=convertedWords.get(1);
String ClearFilterData=convertedWords.get(2);
String Save=convertedWords.get(3);
String Cancel=convertedWords.get(4);
String SLNO=convertedWords.get(5);
String NoRecordsFound=convertedWords.get(6);
String CustomerName=convertedWords.get(7);
String SelectAssetNumber=convertedWords.get(8);
String PleaseSelectAssetNumber=convertedWords.get(9);
String PleaseSelectCustomer=convertedWords.get(10);
String Status=convertedWords.get(11);
String AssetNumber=convertedWords.get(12);
String selectSingleRow = convertedWords.get(13); 
String noRowsSelected = convertedWords.get(14);
String Areyousureyouwanttodelete = convertedWords.get(15); 
%>

<jsp:include page="../Common/header.jsp" />   
	 <style>
  .x-panel-tl
	{
		border-bottom: 0px solid !important;
	}
	.fieldsetpanel{
	width:470px;
}
.x-form-cb-label {
    position: relative;
    margin-left:4px;
    top: 2px;
    font-size:13px;
    font-family: sans-serif;
}

  </style>
 
   	<%if (loginInfo.getStyleSheetOverride().equals("Y")){%>
	<jsp:include page="../Common/ImportJSSandMining.jsp"/>
	<%}else {%>
	<jsp:include page="../Common/ImportJS.jsp" /><%}%>
    <jsp:include page="../Common/ExportJS.jsp" />
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
		.x-window-tl *.x-window-header {
			height : 36px !important;
		}
	</style>
<script>
var outerPanel;
var ctsb;
var jspName = "UnitMessageUnion";
var exportDataType = "int,string,string,string,string,int";
var selected;
var grid;
var buttonValue;
var titelForInnerPanel;
var myWin;
var doorChecked=0;
var keyChecked=0;
var accessPermission=true;

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
                regStore.load({
                     params: {
                         CustId: custId
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
                regStore.load({
                     params: {
                         CustId: custId
                     }
                 });
            }
        }
    }
});

var regStore= new Ext.data.JsonStore({
				   url:'<%=request.getContextPath()%>/UnitMessageUnionAction.do?param=getRegNos',
			       root: 'RegNos',
			       autoLoad: false,
				   fields: ['Registration_no']
			     });
			     
var msgTypeStore= new Ext.data.JsonStore({
				   url:'<%=request.getContextPath()%>/UnitMessageUnionAction.do?param=getTypeSetting&type=MESSAGE_TYPE&rType=msgType',
			       root: 'typeRoot',
			       autoLoad: true,
				   fields: ['msgType']
				   
			     });

var comportStore= new Ext.data.JsonStore({
				   url:'<%=request.getContextPath()%>/UnitMessageUnionAction.do?param=getTypeSetting&type=COMPORT&rType=comport',
			       root: 'typeRoot',
			       autoLoad: true,
				   fields: ['comport']
				   
			     });

var purposeStore= new Ext.data.JsonStore({
				   url:'<%=request.getContextPath()%>/UnitMessageUnionAction.do?param=getTypeSetting&type=PURPOSE&rType=purpose',
			       root: 'typeRoot',
			       autoLoad: true,
				   fields: ['purpose']
				   
			     });
			    

var msgTypeCombo = new Ext.form.ComboBox({
	  frame:true,
	 store: msgTypeStore,
	 id:'msgTypeId',
	 width: 150,
	 cls: 'selectstylePerfect',
	 hidden:false,
	 anyMatch:true,
	 onTypeAhead:true,
	 forceSelection:true,
	 enableKeyEvents:true,
	 mode: 'local',
	 emptyText:'Select Message Type',
	 blankText:'Select Message Type',
	 triggerAction: 'all',
	 displayField: 'msgType',
	 valueField: 'msgType',
	 listeners: {
		                   select: {
		                 	   fn:function(){
		                 	   
		                 	   }
		                 	
		                    }
		                    }	    
                        }); 
                        
  var comportCombo = new Ext.form.ComboBox({
	  frame:true,
	 store: comportStore,
	 id:'comportId',
	 width: 150,
	 cls: 'selectstylePerfect',
	 hidden:false,
	 anyMatch:true,
	 onTypeAhead:true,
	 forceSelection:true,
	 enableKeyEvents:true,
	 mode: 'local',
	 emptyText:'Select Comport',
	 blankText:'Select Comport',
	 triggerAction: 'all',
	 displayField: 'comport',
	 valueField: 'comport',
	 listeners: {
		                   select: {
		                 	   fn:function(){
		                 	   
		                 	   }
		                 	
		                    }
		                    }	    
                        }); 
       
       var purposeCombo = new Ext.form.ComboBox({
	  frame:true,
	 store: purposeStore,
	 id:'purposeId',
	 width: 150,
	 cls: 'selectstylePerfect',
	 hidden:false,
	 anyMatch:true,
	 onTypeAhead:true,
	 forceSelection:true,
	 enableKeyEvents:true,
	 mode: 'local',
	 emptyText:'Select Purpose',
	 blankText:'Slect Purpose',
	 triggerAction: 'all',
	 displayField: 'purpose',
	 valueField: 'purpose',
	 listeners: {
		                   select: {
		                 	   fn:function(){
		                 	   
		                 	   }
		                 	
		                    }
		                    }	    
                        }); 
                        
var vehicleNumber = new Ext.form.ComboBox({
	 store: regStore,
	 id:'VehicleNumberId',
	 width: 150,
	 cls: 'selectstylePerfect',
	 hidden:false,
	 anyMatch:true,
	 onTypeAhead:true,
	 forceSelection:true,
	 enableKeyEvents:true,
	 mode: 'local',
	 emptyText:'<%=SelectAssetNumber%>',
	 blankText:'<%=SelectAssetNumber%>',
	 triggerAction: 'all',
	 displayField: 'Registration_no',
	 valueField: 'Registration_no',
	 listeners: {
		                   select: {
		                 	   fn:function(){
		                 	        if (Ext.getCmp('custcomboId').getValue() == "") {
  		                            Ext.example.msg("<%=SelectCustomerName%>");
  		                            Ext.getCmp('custcomboId').focus();
  		                            return;
  		                        }
  		                        
							if (Ext.getCmp('VehicleNumberId').getValue() == "") {
			                        Ext.example.msg("<%=PleaseSelectAssetNumber%>");
			                        Ext.getCmp('VehicleNumberId').focus();
			                        return;
			                    }
  		                        store.load({
                                    params: {
                                        CustId: Ext.getCmp('custcomboId').getValue(),
  		                                vehicleNumber: Ext.getCmp('VehicleNumberId').getValue(),
  		                                jspName:jspName,
  		                                pageName:jspName
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
    width: screen.width - 40,
    height: 40,
    layoutConfig: {
        columns: 20
    },
    items: [{
            	xtype: 'label',
            	text: '<%=CustomerName%>' + ' :',
            	cls: 'labelstyle'
        	},
        	Client,{width:30},
        	{
  		        xtype: 'label',
  		        cls: 'labelstyle',
  		        id: 'vehicleNumberlab',
  				text: '<%=AssetNumber%>' + ' :'
  			},vehicleNumber,{width: 30}, 
  			{
			 	xtype    : 'button',
		     	text     : 'Refresh',
			 	width    : 90,
			 	id		  : 'refreshId',
			 	cls   	  : 'myStyle',
			 	listeners: {
			 		click : {
			 			fn: function(){
			 				store.reload();
			 				regStore.reload();
			 				}
			 		}
			 	}
		   }
    ]
});
 
var innerPanelDetails = new Ext.form.FormPanel({
    standardSubmit: true,
    collapsible: false,
    autoScroll: true,
    height: 168,
    width: 385,
    frame: true,
    id: 'innerPanelDetailsId',
    layout: 'table',
    layoutConfig: {
        columns: 4
    },
    items: [{
        xtype: 'fieldset',
        title: 'Message Association Information',
        cls: 'fieldsetpanel',
        collapsible: false,
        colspan: 3,
        id: 'AssociationId',
        width: 370,
        layout: 'table',
        layoutConfig: {
            columns: 4
        },
        items: [{
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'Id1'
            },{
            xtype: 'label',
            text: '<%=AssetNumber%>' + ' :',
            cls: 'labelstyle',
            id: 'registrationNoId11'
        	},{width:5},
        	{
        	xtype: 'textfield',
              allowBlank: false,
              cls: 'selectstylePerfect',
              id: 'vehicleNumberTextId'
               },
        	{
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'Id2'
            },{
			xtype: 'label',
			text: 'Message Type' + ' :',
			cls:'labelstyle',
		    id:'msgtypelab'
			},{width:5},
	    	msgTypeCombo,
	    	{
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'Id3'
            },
	    	{
			xtype: 'label',
			text: 'Comport' + ' :',
			cls:'labelstyle',
		    id:'comportlabel'
			},{width:5},
	    	comportCombo,{
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'Id4'
            },
	    	{
			xtype: 'label',
			text: 'Purpose' + ' :',
			cls:'labelstyle',
		    id:'purposelabel'
			},{width:5},
	    	purposeCombo
       ]
    }]
});

var innerWinButtonPanel = new Ext.Panel({
    id: 'innerWinButtonPanelId',
    standardSubmit: true,
    collapsible: false,
    autoHeight: true,
    height: 100,
    width: 380,
    frame: true,
    layout: 'table',
    layoutConfig: {
        columns: 4
    },
    buttons: [{
        xtype: 'button',
        text: 'Save',
        id: 'saveButtonId',
        cls: 'buttonstyle',
        width: 70,
        listeners: {
            click: {
                fn: function () {
                    if (Ext.getCmp('VehicleNumberId').getValue() == "") {
                        Ext.example.msg("<%=PleaseSelectAssetNumber%>");
                        Ext.getCmp('VehicleNumberId').focus();
                        return;
                    }
                    if (Ext.getCmp('vehicleNumberTextId').getValue() == "") {
                        Ext.example.msg("Please Select Vehicle Number");
                        Ext.getCmp('VehicleNumberId').focus();
                        return;
                    }
                    
                    if (Ext.getCmp('msgTypeId').getValue() == "") {
                        Ext.example.msg("Please Select Message Type");
                        Ext.getCmp('msgTypeId').focus();
                        return;
                    }
                    
                    if (Ext.getCmp('comportId').getValue() == "") {
                        Ext.example.msg("Please Select Comport");
                        Ext.getCmp('comportId').focus();
                        return;
                    }
                    
                    if (Ext.getCmp('purposeId').getValue() == "") {
                        Ext.example.msg("Please Select Purpose");
                        Ext.getCmp('purposeId').focus();
                        return;
                    }
                   var uniqueIdParam,msgTypeGrid,purposeGrid,comportGrid;
                    if (buttonValue == 'modify') {
                    		//If Modify get vehice number from textfield
                            selected = grid.getSelectionModel().getSelected();
                            registrationNo=selected.get('registrationNoDataIndex');
                            uniqueIdParam=selected.get('uniqueIdDataIndex');
                            msgTypeGrid = selected.get('msgTypeDataIndex');
                            purposeGrid=selected.get('purposeDataIndex');
                            comportGrid=selected.get('comportDataIndex');
                        }else{
                        	//If Add get vehice number from combo
                        	registrationNo=Ext.getCmp('VehicleNumberId').getValue();
                        }
                        
                    if (innerPanelDetails.getForm().isValid()) {
                     
                       OuterPanelWindow.getEl().mask();
                        Ext.Ajax.request({
                            url: '<%=request.getContextPath()%>/UnitMessageUnionAction.do?param=save',
                            method: 'POST',
                            params: {
                                buttonValue: buttonValue,
                                CustId: Ext.getCmp('custcomboId').getValue(),
                                registrationNo: registrationNo,
                                msgType: Ext.getCmp('msgTypeId').getValue(),
                                purpose: Ext.getCmp('purposeId').getValue(),
                                comport: Ext.getCmp('comportId').getValue(),
                                uniqueIdParam:uniqueIdParam,
                                msgTypeGrid: msgTypeGrid,
                                purposeGrid: purposeGrid,
                                comportGrid: comportGrid
                            },
                            success: function (response, options) {
                                var message = response.responseText;
                                Ext.example.msg(message);
                                Ext.getCmp('msgTypeId').reset();
                                Ext.getCmp('purposeId').reset();
                                Ext.getCmp('comportId').reset();
                                myWin.hide();
                                OuterPanelWindow.getEl().unmask();
                                store.load({
                                    params: {
                                        CustId: Ext.getCmp('custcomboId').getValue(),
  		                                vehicleNumber: Ext.getCmp('VehicleNumberId').getValue(),
  		                                jspName:jspName,
  		                                pageName:jspName
                                    }
                                });
                            },
                            failure: function () {
                                 Ext.example.msg("Error");
                                 store.reload();
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
                                Ext.getCmp('msgTypeId').reset();
                                Ext.getCmp('purposeId').reset();
                                Ext.getCmp('comportId').reset();
                     myWin.hide();
                }
            }
        }
    }]
});

var OuterPanelWindow = new Ext.Panel({
    width: 400,
    height: 238,
    standardSubmit: true,
    frame: true,
    items: [innerPanelDetails, innerWinButtonPanel]
});

myWin = new Ext.Window({
    title: titelForInnerPanel,
    closable: false,
    resizable: false,
    modal: true,
    autoScroll: false,
    height: 290,
    width: 410,
    id: 'myWin',
    items: [OuterPanelWindow]
});

function addRecord() {
    if (Ext.getCmp('custcomboId').getValue() == "") {
         Ext.example.msg("<%=PleaseSelectCustomer%>");
         Ext.getCmp('custcomboId').focus();
         return;
    }
    
       if(Ext.getCmp('VehicleNumberId').getValue()=='VIEW ALL'){
    	Ext.example.msg("<%=selectSingleRow%>");
        Ext.getCmp('VehicleNumberId').focus();
         return;
    }
    buttonValue = '<%=Add%>';
    titelForInnerPanel = 'Add Message Association';
    myWin.setPosition(450, 150);
    myWin.show();
    myWin.setTitle(titelForInnerPanel);
    Ext.getCmp('vehicleNumberTextId').setValue(Ext.getCmp('VehicleNumberId').getValue());
    Ext.getCmp('vehicleNumberTextId').setDisabled(true);
    Ext.getCmp('msgTypeId').setDisabled(false);
    Ext.getCmp('msgTypeId').reset();
    Ext.getCmp('comportId').reset();
    Ext.getCmp('purposeId').reset();
   
}



//function for modify button in grid that will open form window
function modifyData() {
    if (grid.getSelectionModel().getCount() > 1) {
        Ext.example.msg("<%=selectSingleRow%>");
        return;
    }

    if (grid.getSelectionModel().getSelected() == null) {
        Ext.example.msg("<%=noRowsSelected%>");
        return;
    }
    buttonValue = "modify";
    titelForInnerPanel = "Modify";
    var selected = grid.getSelectionModel().getSelected();
            //myWin.setPosition(450, 150);
            myWin.setTitle(titelForInnerPanel);
            myWin.show();
             Ext.getCmp('vehicleNumberTextId').setValue(selected.get('registrationNoDataIndex'));
             Ext.getCmp('vehicleNumberTextId').setDisabled(true);
             Ext.getCmp('msgTypeId').setDisabled(true);
             Ext.getCmp('msgTypeId').setValue(selected.get('msgTypeDataIndex'));
            Ext.getCmp('purposeId').setValue(selected.get('purposeDataIndex'));
            Ext.getCmp('comportId').setValue(selected.get('comportDataIndex'));
}

function deleteData() {
    if (grid.getSelectionModel().getCount() > 1) {
        Ext.example.msg("<%=selectSingleRow%>");
        return;
    }

    if (grid.getSelectionModel().getSelected() == null) {
        Ext.example.msg("<%=noRowsSelected%>");
        return;
    }
     if(Ext.getCmp('VehicleNumberId').getValue()=='VIEW ALL'){
    	Ext.example.msg("<%=selectSingleRow%>");
        Ext.getCmp('VehicleNumberId').focus();
         return;
    }
    Ext.Msg.show({
        title: 'Delete Association Data',
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
                Ext.Ajax.request({
                    url: '<%=request.getContextPath()%>/UnitMessageUnionAction.do?param=deleteUnionDetails',
                    method: 'POST',
                    params: {
                    			CustId: Ext.getCmp('custcomboId').getValue(),
						 		registrationNo: selected.get('registrationNoDataIndex'),
                                msgType: selected.get('msgTypeDataIndex'),
                                purpose: selected.get('purposeDataIndex'),
                                comport: selected.get('comportDataIndex'),
                                uniqueId: selected.get('uniqueIdDataIndex'),
                                pageName: jspName
                    },
                    success: function (response, options) {
                        var message = response.responseText;
                        Ext.example.msg(message);
                        store.reload({
                        params: {
					    	CustId: Ext.getCmp('custcomboId').getValue(),
  		                                vehicleNumber: Ext.getCmp('VehicleNumberId').getValue(),
  		                                jspName:jspName,
  		                                pageName:jspName
                         }
                       });
                        //outerPanelWindow.getEl().unmask();
                    },
                    failure: function () {
                        Ext.example.msg("Error");
                        store.reload();
                        outerPanelWindow.getEl().unmask();

                    }
                });

                break;
            case 'no':
                Ext.example.msg("Association not Deleted..");
                store.reload();
                break;

            }
        }
    });
}

var reader = new Ext.data.JsonReader({
    idProperty: 'MsgAssocid',
    root: 'MsgAssocRoot',
    totalProperty: 'total',
    fields: [{
        name: 'slnoIndex'
    }, {
        name: 'registrationNoDataIndex'
    }, {
        name: 'msgTypeDataIndex'
    }, {
        name: 'comportDataIndex'
    }, {
        name: 'purposeDataIndex'
    }, {
        name: 'uniqueIdDataIndex'
    } ]
});

var store = new Ext.data.GroupingStore({
    autoLoad: false,
    proxy: new Ext.data.HttpProxy({
        url: '<%=request.getContextPath()%>/UnitMessageUnionAction.do?param=getMsgAssocReport',
        method: 'POST'
    }),
    storeId: 'MsgRequestId',
    reader: reader
});

var filters = new Ext.ux.grid.GridFilters({
    local: true,
    filters: [{
        type: 'numeric',
        dataIndex: 'slnoIndex'
    }, {
        type: 'string',
        dataIndex: 'registrationNoDataIndex'
    }, {
        type: 'string',
        dataIndex: 'msgTypeDataIndex'
    }, {
        type: 'string',
        dataIndex: 'comportDataIndex'
    }, {
        type: 'string',
        dataIndex: 'purposeDataIndex'
    }, {
        type: 'numeric',
        dataIndex: 'uniqueIdDataIndex'
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
            header: "<span style=font-weight:bold;><%=SLNO%></span>",
            filter: {
                type: 'numeric'
            }
        }, {
            header: "<span style=font-weight:bold;><%=AssetNumber%></span>",
            dataIndex: 'registrationNoDataIndex',
            width: 100,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;>Message Type</span>",
            dataIndex: 'msgTypeDataIndex',
            width: 100,
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;>ComPort</span>",
            dataIndex: 'comportDataIndex',
            width: 100,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;>Purpose</span>",
            dataIndex: 'purposeDataIndex',
            width: 100,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;>Unique Id</span>",
            dataIndex: 'uniqueIdDataIndex',
            width: 100,
            hidden:true,
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
grid = getGrid('Message Assoiation Details', '<%=NoRecordsFound%>', store, screen.width - 40, 420, 14, filters, '<%=ClearFilterData%>', false, '', 16, false, '', false, '', true, 'Excel', jspName, exportDataType, false, 'PDF', true, '<%=Add%>',true,'Modify',true,'Delete');
//******************************************************************************************************************************************************
Ext.onReady(function () {
    ctsb = tsb;
    Ext.QuickTips.init();
    Ext.form.Field.prototype.msgTarget = 'side';
    outerPanel = new Ext.Panel({
        title: 'Message Association',
        renderTo: 'content',
        standardSubmit: true,
        frame: true,
        width: screen.width-28,
        height: 540,
        cls: 'outerpanel',
        layout: 'table',
        layoutConfig: {
            columns: 1
        },
        items: [customerComboPanel, grid]
        //bbar: ctsb
    });
    sb = Ext.getCmp('form-statusbar');
});
</script>
 <jsp:include page="../Common/footer.jsp" />
 <!-- </body>   -->
 <!-- </html> -->

    
    
    
    
    

