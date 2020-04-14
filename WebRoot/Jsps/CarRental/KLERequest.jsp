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
tobeConverted.add("Excel");
tobeConverted.add("Customer_Name");
tobeConverted.add("Select_Asset_Number");
tobeConverted.add("Select_Command_Type");
tobeConverted.add("Please_Select_Command_Type");
tobeConverted.add("Please_Select_Asset_Number");
tobeConverted.add("Please_Select_customer");
tobeConverted.add("Unit_Number");
tobeConverted.add("DateTime");
tobeConverted.add("Location");
tobeConverted.add("Action_Time");
tobeConverted.add("Status");
tobeConverted.add("Asset_Number");
tobeConverted.add("Command_Type");
tobeConverted.add("KLE_Request");
tobeConverted.add("KLE_Request_Details");
tobeConverted.add("Add_KLE_Request");
tobeConverted.add("KLE_Request_Information");

tobeConverted.add("Start_Date");
tobeConverted.add("Select_Start_Date");
tobeConverted.add("End_Date");
tobeConverted.add("Select_End_Date");
tobeConverted.add("View");
tobeConverted.add("Month_Validation");
tobeConverted.add("Request_Id");
tobeConverted.add("Command_Mode");

ArrayList<String> convertedWords = new ArrayList<String>();
convertedWords = cf.getLanguageSpecificWordForKey(tobeConverted,language);

String SelectCustomerName=convertedWords.get(0);
String Add=convertedWords.get(1);
String ClearFilterData=convertedWords.get(2);
String Save=convertedWords.get(3);
String Cancel=convertedWords.get(4);
String SLNO=convertedWords.get(5);
String NoRecordsFound=convertedWords.get(6);
String Excel=convertedWords.get(7);
String CustomerName=convertedWords.get(8);
String SelectAssetNumber=convertedWords.get(9);
String SelectCommandType=convertedWords.get(10);
String PleaseSelectCommandType=convertedWords.get(11);
String PleaseSelectAssetNumber=convertedWords.get(12);
String PleaseSelectCustomer=convertedWords.get(13);
String UnitNumber=convertedWords.get(14);
String DateTime=convertedWords.get(15);
String Location=convertedWords.get(16);
String ActionTime=convertedWords.get(17);
String Status=convertedWords.get(18);
String AssetNumber=convertedWords.get(19);
String CommandType=convertedWords.get(20);
String KLERequest=convertedWords.get(21);
String KLERequestDetails=convertedWords.get(22);
String AddKLERequest=convertedWords.get(23);
String KLERequestInformation=convertedWords.get(24);

String StartDate = convertedWords.get(25);
String SelectStartDate = convertedWords.get(26);
String EndDate = convertedWords.get(27);
String SelectEndDate = convertedWords.get(28);
String View = convertedWords.get(29);
String monthValidation = convertedWords.get(30);
String RequestId= convertedWords.get(31);
String CommandMode=convertedWords.get(32);
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
		label
		{
			display : inline !important;
		}
		.x-window-tl *.x-window-header {
			padding-top : 6px !important;
		}
		.ext-strict .x-form-text {
			height: 21px !important;
		}
		fieldset#KLErequestId {
			width : 365px !important;
		}
		.x-layer ul {
		 	min-height:26px !important;
		}
	</style>
<script>
var outerPanel;
var ctsb;
var jspName = "KLERequest";
var exportDataType = "int,string,string,string,date,String,date,string,string";
var selected;
var grid;
var buttonValue;
var titelForInnerPanel;
var myWin;
var doorChecked=0;
var keyChecked=0;
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
  		        id: 'startdatelab',
  				text: '<%=StartDate%>' + ' :'
  			},{
  		        xtype: 'datefield',
  		        cls: 'selectstylePerfect',
  		        width: 185,
  		        format: getDateTimeFormat(),
  		        emptyText: '<%=SelectStartDate%>',
  		        allowBlank: false,
  		        blankText: '<%=SelectStartDate%>',
  		        id: 'startdate',
  		        vtype: 'daterange',
  		        endDateField: 'enddate'
  		    },{width: 60}, 
  		    {
  		        xtype: 'label',
  		        cls: 'labelstyle',
  		        id: 'enddatelab',
  		        text: '<%=EndDate%>' + ' :'
  		    },{
  		        xtype: 'datefield',
  		        cls: 'selectstylePerfect',
  		        width: 185,
  		        format: getDateTimeFormat(),
  		        emptyText: '<%=SelectEndDate%>',
  		        allowBlank: false,
  		        blankText: '<%=SelectEndDate%>',
  		        id: 'enddate',
  		        vtype: 'daterange',
  		        startDateField: 'startdate'
  		    },{width: 30},
  		    {
  		        xtype: 'button',
  		        text: '<%=View%>',
  		        id: 'addbuttonid',
  		        cls: ' ',
  		        width: 80,
  		        listeners: {
  		                click: {
  		                    fn: function () {
  		                        if (Ext.getCmp('custcomboId').getValue() == "") {
  		                            Ext.example.msg("<%=SelectCustomerName%>");
  		                            Ext.getCmp('custcomboId').focus();
  		                            return;
  		                        }
  		                        if (Ext.getCmp('startdate').getValue() == "") {
  		                            Ext.example.msg("<%=SelectStartDate%>");
  		                            Ext.getCmp('startdate').focus();
  		                            return;
  		                        }
  		                        if (Ext.getCmp('enddate').getValue() == "") {
  		                            Ext.example.msg("<%=SelectEndDate%>");
  		                            Ext.getCmp('enddate').focus();
  		                            return;
  		                        }
  		                        var startdates = Ext.getCmp('startdate').getValue();
  		                        var enddates = Ext.getCmp('enddate').getValue();
  		                        
  		                        
  		                        if (checkMonthValidation(startdates, enddates)) {
  		                            Ext.example.msg("<%=monthValidation%>");
  		                            Ext.getCmp('enddate').focus();
  		                            return;
  		                        }
  		                        store.load({
                                    params: {
                                        CustId: Ext.getCmp('custcomboId').getValue(),
  		                                startdate: Ext.getCmp('startdate').getValue(),
  		                                enddate: Ext.getCmp('enddate').getValue(),
  		                                jspName:jspName,
  		                                pageName:'KLERequest'
                                    }
                                });
  		                    }
  		                }
  		            }
  		    },{width:30},
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

var regStore= new Ext.data.JsonStore({
				   url:'<%=request.getContextPath()%>/KLERequestAction.do?param=getRegNos',
			       root: 'RegNos',
			       autoLoad: false,
				   fields: ['Registration_no']
				   
			     });
			     
			     
var vehicleNumber = new Ext.form.ComboBox({
	  frame:true,
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
		                 	   
		                 	   }
		                 	
		                    }
		                    }	    
                        }); 

 


 var commandTypeComboStore = new Ext.data.SimpleStore({
            id:0,
    		fields: ['name'],
    		autoLoad: false,
			data:[['LOCK','LOCK'],['UNLOCK','UNLOCK']]
		});	 
		
		
		
		
 
var commandTypeCombo = new Ext.form.ComboBox({
        		  frame:true,
				  store: commandTypeComboStore,
				  id:'commandTypeId',
				  width: 175,
				  forceSelection:true,
				  enableKeyEvents:true,
				  blankText: '<%=SelectCommandType%>',
      			  emptyText: '<%=SelectCommandType%>',
				  mode: 'local',
				  triggerAction: 'all',
				  value:'',
				  displayField: 'name',
				  valueField: 'name',
				  cls: 'selectstylePerfect',
				  listeners: {
		                   select: {
		                 	   fn:function(){
		                 	   if(Ext.getCmp('commandTypeId').getValue()=="MOBILIZE" || Ext.getCmp('commandTypeId').getValue()=="IMMOBILIZE" ){
		                 	   		Ext.getCmp('Id3').hide();
		                 	   		Ext.getCmp('custcommandmode').hide();
		                 	   		Ext.getCmp('commandModeId').hide();
		                 	   		Ext.getCmp('Door').hide();
		                 	   		Ext.getCmp('Key').hide();
		                 	   		
		                 	   }
		                 	   else{
									Ext.getCmp('Id3').show();
		                 	 		Ext.getCmp('custcommandmode').show();
		                 	   		Ext.getCmp('commandModeId').show();
		                 	   		Ext.getCmp('Door').show();
		                 	   		Ext.getCmp('Key').show();
		                 	   }
	                 	   }
		                 	
		                    }
		                    }	    
                        }); 
                        
            var commandModeComboStore = new Ext.data.SimpleStore({
            	id:0,
    			fields: ['name'],
    			autoLoad: false,
				data:[['SMS','SMS'],['GPRS','GPRS']]
			});	 
                        
                  var commandModeCombo = new Ext.form.ComboBox({
        		  frame:true,
				  store: commandModeComboStore,
				  id:'commandModeId',
				  width: 175,
				  forceSelection:true,
				  enableKeyEvents:true,
				  blankText: '',
      			  emptyText: '',
				  mode: 'local',
				  triggerAction: 'all',
				  value:'GPRS',
				  displayField: 'name',
				  valueField: 'name',
				  cls: 'selectstylePerfect',
				  listeners: {
		                   select: {
		                 	   fn:function(){
	                 	   }
		                 	
		                    }
		                    }	    
                        }); 
 		
var innerPanelForKLEDetails = new Ext.form.FormPanel({
    standardSubmit: true,
    collapsible: false,
    autoScroll: true,
    height: 168,
    width: 385,
    frame: true,
    id: 'innerPanelForKLERequestDetailsId',
    layout: 'table',
    layoutConfig: {
        columns: 4
    },
    items: [{
        xtype: 'fieldset',
        title: '<%=KLERequestInformation%>',
        cls: 'fieldsetpanel',
        collapsible: false,
        colspan: 3,
        id: 'KLErequestId',
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
        	vehicleNumber,
        	{
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'Id2'
            },{
			xtype: 'label',
			text: '<%=CommandType%>' + ' :',
			cls:'labelstyle',
		    id:'custmastcountrylab'
			},{width:5},
	    	commandTypeCombo,
	    	{
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'Id3'
            },
	    	{
			xtype: 'label',
			text: '<%=CommandMode%>' + ' :',
			cls:'labelstyle',
		    id:'custcommandmode'
			},{width:5},
	    	commandModeCombo,{width:5},{
			xtype: 'checkbox',
			id:'Door',
			boxLabel:'Validate Door Status',
			checked: true
			},{width:10},
			{
			xtype: 'checkbox',
			id:'Key',
			boxLabel:'Validate Key Holder Status',
			checked: true
			}
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
        text: 'Send',
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
                    if (Ext.getCmp('commandTypeId').getValue() == "") {
                        Ext.example.msg("<%=PleaseSelectCommandType%>");
                        Ext.getCmp('commandTypeId').focus();
                        return;
                    }
                   
                    
                    if (innerPanelForKLEDetails.getForm().isValid()) {
                     
                       KLEOuterPanelWindow.getEl().mask();
                        Ext.Ajax.request({
                            url: '<%=request.getContextPath()%>/KLERequestAction.do?param=save',
                            method: 'POST',
                            params: {
                                buttonValue: buttonValue,
                                CustId: Ext.getCmp('custcomboId').getValue(),
                                registrationNo: Ext.getCmp('VehicleNumberId').getValue(),
                                commandType: Ext.getCmp('commandTypeId').getValue(),
                                doorChecked:Ext.getCmp('Door').getValue(),
                                keyChecked:Ext.getCmp('Key').getValue(),
                                commandMode: Ext.getCmp('commandModeId').getValue(),
                                
                            },
                            success: function (response, options) {
                                var message = response.responseText;
                                Ext.example.msg(message);
                                Ext.getCmp('VehicleNumberId').reset();
                                Ext.getCmp('commandTypeId').reset();
                                Ext.getCmp('commandModeId').reset();
                                Ext.getCmp("Door").setValue(true);
                                Ext.getCmp("Key").setValue(true);
                                Ext.getCmp('Id3').show();
		                 	 	Ext.getCmp('custcommandmode').show();
		                 	   	Ext.getCmp('commandModeId').show();
		                 	   	Ext.getCmp('Door').show();
		                 	   	Ext.getCmp('Key').show();
                                myWin.hide();
                                KLEOuterPanelWindow.getEl().unmask();
                                store.load({
                                    params: {
                                        CustId: Ext.getCmp('custcomboId').getValue(),
  		                                startdate: Ext.getCmp('startdate').getValue(),
  		                                enddate: Ext.getCmp('enddate').getValue(),
  		                                jspName:jspName,
  		                                pageName:'KLERequest'
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
                     Ext.getCmp('VehicleNumberId').reset();
                     Ext.getCmp('commandTypeId').reset();
                     Ext.getCmp('commandModeId').reset();
                     Ext.getCmp("Door").setValue(true);
                     Ext.getCmp("Key").setValue(true);
                     Ext.getCmp('Id3').show();
		             Ext.getCmp('custcommandmode').show();
		             Ext.getCmp('commandModeId').show();
		             Ext.getCmp('Door').show();
		             Ext.getCmp('Key').show();
                     myWin.hide();
                }
            }
        }
    }]
});

var KLEOuterPanelWindow = new Ext.Panel({
    width: 400,
    height: 238,
    standardSubmit: true,
    frame: true,
    items: [innerPanelForKLEDetails, innerWinButtonPanel]
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
    items: [KLEOuterPanelWindow]
});

function addRecord() {
    if (Ext.getCmp('custcomboId').getValue() == "") {
         Ext.example.msg("<%=PleaseSelectCustomer%>");
         Ext.getCmp('custcomboId').focus();
         return;
    }
    buttonValue = '<%=Add%>';
    titelForInnerPanel = '<%=AddKLERequest%>';
    myWin.setPosition(450, 150);
    myWin.show();
    myWin.setTitle(titelForInnerPanel);
    Ext.getCmp('VehicleNumberId').reset();
    Ext.getCmp('commandTypeId').reset();
   
}

var reader = new Ext.data.JsonReader({
    idProperty: 'KLERequestid',
    root: 'KLERequestRoot',
    totalProperty: 'total',
    fields: [{
        name: 'slnoIndex'
    }, {
        name: 'registrationNoDataIndex'
    }, {
        name: 'unitNoDataIndex'
    }, {
        name: 'commandTypeDataIndex'
    },{
        name: 'GPSDataIndex',
	     type: 'date',
	     dateFormat: getDateTimeFormat()
    }, {
        name: 'locationDataIndex'
    }, {
        name: 'insertedTimeDataIndex',
        type: 'date',
	    dateFormat: getDateTimeFormat()
    }, {
        name: 'statusDataIndex'
    },{
        name: 'requestidDataIndex'
    }  ]
});

var store = new Ext.data.GroupingStore({
    autoLoad: false,
    proxy: new Ext.data.HttpProxy({
        url: '<%=request.getContextPath()%>/KLERequestAction.do?param=getKLERequestReport',
        method: 'POST'
    }),
    storeId: 'KLERequestId',
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
        dataIndex: 'unitNoDataIndex'
    }, {
        type: 'string',
        dataIndex: 'commandTypeDataIndex'
    },{
        type: 'date',
        dataIndex: 'GPSDataIndex'
    }, {
        type: 'string',
        dataIndex: 'locationDataIndex'
    }, {
        type: 'date',
        dataIndex: 'insertedTimeDataIndex'
    }, {
        type: 'string',
        dataIndex: 'statusDataIndex'
    },{
        type: 'string',
        dataIndex: 'requestidDataIndex'
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
            header: "<span style=font-weight:bold;><%=UnitNumber%></span>",
            dataIndex: 'unitNoDataIndex',
            width: 100,
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;><%=CommandType%></span>",
            dataIndex: 'commandTypeDataIndex',
            width: 100,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=DateTime%></span>",
            renderer: Ext.util.Format.dateRenderer(getDateTimeFormat()),
            dataIndex: 'GPSDataIndex',
            width: 100,
            filter: {
                type: 'date'
            }
        }, {
            header: "<span style=font-weight:bold;><%=Location%></span>",
            dataIndex: 'locationDataIndex',
            width: 100,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=ActionTime%></span>",
            renderer: Ext.util.Format.dateRenderer(getDateTimeFormat()),
            dataIndex: 'insertedTimeDataIndex',
            width: 100,
            filter: {
                type: 'date'
            }
        }, {
            header: "<span style=font-weight:bold;><%=Status%></span>",
            dataIndex: 'statusDataIndex',
            width: 100,
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;><%=RequestId%></span>",
            dataIndex: 'requestidDataIndex',
            width: 100,
            filter: {
                type: 'string'
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
grid = getGrid('<%=KLERequestDetails%>', '<%=NoRecordsFound%>', store, screen.width - 40, 420, 14, filters, '<%=ClearFilterData%>', false, '', 16, false, '', false, '', true, '<%=Excel%>', jspName, exportDataType, false, 'PDF', true, '<%=Add%>');
//******************************************************************************************************************************************************
Ext.onReady(function () {
    ctsb = tsb;
    Ext.QuickTips.init();
    Ext.form.Field.prototype.msgTarget = 'side';
    outerPanel = new Ext.Panel({
        title: '<%=KLERequest%>',
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
});</script>
<jsp:include page="../Common/footer.jsp" />
 <!-- </body>   -->
 <!-- </html> -->
    
    
    
    
    

