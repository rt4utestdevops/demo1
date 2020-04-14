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
	String ipVal = request.getParameter("ipVal");
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
tobeConverted.add("Add_Details");
tobeConverted.add("Add");
tobeConverted.add("Modify");
tobeConverted.add("Customer_Name");
tobeConverted.add("Select_Customer_Name");
tobeConverted.add("Accounts_Head_Information");
tobeConverted.add("No_Records_Found");
tobeConverted.add("Clear_Filter_Data");
tobeConverted.add("SLNO");
tobeConverted.add("Id");
tobeConverted.add("Payment_Acc_Head");
tobeConverted.add("Description");
tobeConverted.add("Excel");
tobeConverted.add("Delete");
tobeConverted.add("Accounts_Head_Master_Information");
tobeConverted.add("No_Rows_Selected");
tobeConverted.add("Select_Single_Row");
tobeConverted.add("Modify_Details");
tobeConverted.add("Enter_Payment_Acc_Head");
tobeConverted.add("Enter_Description");
tobeConverted.add("Save");
tobeConverted.add("Cancel");
ArrayList<String> convertedWords = new ArrayList<String>();
convertedWords = cf.getLanguageSpecificWordForKey(tobeConverted,language);

String AddDetails=convertedWords.get(0);
String Add=convertedWords.get(1);
String Modify=convertedWords.get(2);
String CustomerName=convertedWords.get(3);
String SelectCustomerName=convertedWords.get(4);
String AccountsHeadInformation=convertedWords.get(5);
String NoRecordsFound=convertedWords.get(6);
String ClearFilterData=convertedWords.get(7);
String SLNO=convertedWords.get(8);
String ID=convertedWords.get(9);
String PaymentAccHead=convertedWords.get(10);
String Description=convertedWords.get(11);
String Excel=convertedWords.get(12);
String Delete=convertedWords.get(13);
String AccountsHeadMasterInformation=convertedWords.get(14);
String NoRowsSelected=convertedWords.get(15);
String SelectSingleRow=convertedWords.get(16);
String ModifyDetails=convertedWords.get(17);
String EnterPaymentAccHead=convertedWords.get(18);
String EnterDescription=convertedWords.get(19);
String Save=convertedWords.get(20);
String Cancel=convertedWords.get(21);

int userId=loginInfo.getUserId(); 
String userAuthority=cf.getUserAuthority(systemId,userId);	

if(customerId > 0 && loginInfo.getIsLtsp()== -1 && !userAuthority.equalsIgnoreCase("Admin"))
	{
		response.sendRedirect(request.getContextPath()+ "/Jsps/Common/401Error.html");
	}
	else{

%>
<jsp:include page="../Common/header.jsp" />
 		<title>Accounts Head Master</title>		
    
	 <style>
  .x-panel-tl
	{
		border-bottom: 0px solid !important;
	}
  </style>

   <%if (loginInfo.getStyleSheetOverride().equals("Y")){%>
	<jsp:include page="../Common/ImportJSSandMining.jsp"/>
	<jsp:include page="../IronMining/css.jsp" />
	<%}else{%>
	<jsp:include page="../Common/ImportJS.jsp" />
	<jsp:include page="../IronMining/css.jsp" />
	<%}%>
   <jsp:include page="../Common/ExportJS.jsp" />
   <style>
		.ext-strict .x-form-text {
			height: 21px !important;
		}
		label {
			display : inline !important;
		}
		.x-layer ul {
		 	min-height: 27px !important;
		}
		.x-window-tl *.x-window-header {
			height : 38px !important;
		}
   </style>
   <script>
			var innerpage=<%=ipVal%>;
	
	   	    if (innerpage == true) {
				
				if(document.getElementById("topNav")!=null && document.getElementById("topNav")!=undefined)
				{
					document.getElementById("topNav").style.display = "none";
					$(".container").css({"margin-top":"-72px"});
				}
				
			}
   
var outerPanel;
var ctsb;
var jspName = "Mineral Master Information";
var exportDataType = "";
var selected;
var grid;
var buttonValue;
var titelForInnerPanel;
var myWin;
var selectedVehicles = "-";
var selectedRouteId = null;
var selectedName = null;
var selectedType = null;

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

var innerPanelForAccountsHeadMasterDeatails = new Ext.form.FormPanel({
    standardSubmit: true,
    collapsible: false,
    autoScroll: true,
    height: 150,
    width: 450,
    frame: false,
    id: 'innerPanelForAccountsHeadMasterDeatailsId',
    layout: 'table',
    layoutConfig: {
        columns: 4
    },
    items: [{
        xtype: 'fieldset',
        title:'<%=AccountsHeadInformation%>',
        cls: 'my-fieldset',
        collapsible: false,
        colspan: 4,
        id: 'MineralInfoId',
        width: 445,
        height:120,
        layout: 'table',
        layoutConfig: {
            columns: 4
        },
        items: [{
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'MandatorymineralId'
        },{
            xtype: 'label',
            text: '<%=PaymentAccHead%>' + ' :',
            cls: 'labelstylenew',
            id: 'mineralCodeLabelId'
        }, {
            xtype: 'textfield',
            cls: 'selectstylePerfectnew',
            id: 'paymentId',
            mode: 'local',
            forceSelection: true,
            height:30,
            emptyText: '<%=EnterPaymentAccHead%>',
            blankText: '<%=EnterPaymentAccHead%>',
            selectOnFocus: true,
            allowBlank: false,
            listeners: { change: function(f,n,o){ //restrict 50
			 if(f.getValue().length> 50){ Ext.example.msg("Field reached it's Maximum Size"); 
				f.setValue(n.substr(0,50)); f.focus(); }
			 } },
        }, {},  {
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'nameEmptyId1'
        },{
            xtype: 'label',
            text: '<%=Description%>' + ' :',
            cls: 'labelstylenew',
            id: 'mineralNameId'
        }, {
            xtype: 'textfield',
            cls: 'selectstylePerfectnew',
            id: 'descriptionId',
            mode: 'local',
            forceSelection: true,
            height:30,
            emptyText: '<%=EnterDescription%>',
            blankText: '<%=EnterDescription%>',
            selectOnFocus: true,
            allowBlank: false,
            listeners: { change: function(f,n,o){//restrict 200
			 if(f.getValue().length> 200){ Ext.example.msg("Field reached it's Maximum Size"); 
				f.setValue(n.substr(0,200)); f.focus(); }
			 } },
        }, {}]
    }]
});

var innerWinButtonPanel = new Ext.Panel({
    id: 'innerWinButtonPanelId',
    standardSubmit: true,
    collapsible: false,
    autoHeight: true,
    height: 100,
    width: 445,
    frame: false,
    layout: 'table',
    layoutConfig: {
        columns: 4
    },
    buttons: [{
        xtype: 'button',
        text: '<%=Save%>',
        id: 'saveButtonId',
        cls: 'buttonstyle',
        iconCls:'savebutton',
        width: 70,
        listeners: {
            click: {
                fn: function() {
                   
                    if (Ext.getCmp('paymentId').getValue() == "") {
                    Ext.example.msg("<%=EnterPaymentAccHead%>");
                        return;
                    }
                     if (Ext.getCmp('descriptionId').getValue() == "") {
                    Ext.example.msg("<%=EnterDescription%>");
                        return;
                    }
                    
                    var rec;
                   
                        if (buttonValue == 'Modify') {
                            var selected = grid.getSelectionModel().getSelected();
                            id = selected.get('uniqueIdDataIndex');
                           
                        }
                         routeMasterOuterPanelWindow.getEl().mask();
                        Ext.Ajax.request({
                            url: '<%=request.getContextPath()%>/AccountsHeadMasterAction.do?param=AddorModifyAccountsHeadDetails',
                            method: 'POST',
                            params: {
                                buttonValue: buttonValue,
                                CustId: Ext.getCmp('custcomboId').getValue(),
                                paymentHead: Ext.getCmp('paymentId').getValue(),
                                description: Ext.getCmp('descriptionId').getValue(),
                                id: id
                            },
                            success: function(response, options) {
                                var message = response.responseText;
                                 Ext.example.msg(message);
							    Ext.getCmp('paymentId').reset();
							    Ext.getCmp('descriptionId').reset();
                                myWin.hide();
                                routeMasterOuterPanelWindow.getEl().unmask();
                                store.load({
                                    params: {
                                        CustId: custId
                                    }
                                });
                            },
                            failure: function() {
                                Ext.example.msg("Error");
                                store.reload();
                                myWin.hide();
                            }
                        });
                    //}
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

var routeMasterOuterPanelWindow = new Ext.Panel({
    width: 460,
    height: 210,
    standardSubmit: true,
    frame: true,
    items: [innerPanelForAccountsHeadMasterDeatails, innerWinButtonPanel]
});

myWin = new Ext.Window({
    title: titelForInnerPanel,
    closable: false,
    resizable: false,
    modal: true,
    autoScroll: false,
    height: 260,
    width: 475,
    id: 'myWin',
    items: [routeMasterOuterPanelWindow]
});

function addRecord() {
    if (Ext.getCmp('custcomboId').getValue() == "") {
     Ext.example.msg("<%=SelectCustomerName%>");
        return;
    }
    buttonValue = '<%=Add%>';
    titelForInnerPanel = '<%=AddDetails%>';
    myWin.setPosition(450, 100);
    myWin.show();
    //  myWin.setHeight(350);

    Ext.getCmp('paymentId').reset();
    Ext.getCmp('descriptionId').reset();
    myWin.setTitle(titelForInnerPanel);
}

function modifyData() {
    if (Ext.getCmp('custcomboId').getValue() == "") {
    Ext.example.msg("<%=SelectCustomerName%>");
        return;
    }
    if (grid.getSelectionModel().getCount() == 0) {
     Ext.example.msg("No Rows Selected");
        return;
    }
    if (grid.getSelectionModel().getCount() > 1) {
     Ext.example.msg("Select Single Row");
        return;
    }
    buttonValue = '<%=Modify%>';
    titelForInnerPanel = '<%=ModifyDetails%>';
    myWin.setPosition(450, 100);
    myWin.setTitle(titelForInnerPanel);
    myWin.show();
 
    var selected = grid.getSelectionModel().getSelected();
    Ext.getCmp('paymentId').setValue(selected.get('paymentHeadDataIndex'));
    Ext.getCmp('descriptionId').setValue(selected.get('descriptionDataIndex'));
    }
var reader = new Ext.data.JsonReader({
    idProperty: 'ownMasterid',
    root: 'AccountsHeadMasterRoot',
    totalProperty: 'total',
    fields: [{
        name: 'slnoIndex'
    }, {
        name: 'paymentHeadDataIndex'
    }, {
        name: 'descriptionDataIndex'
    }, {
        name: 'uniqueIdDataIndex'
    }]
});

var store = new Ext.data.GroupingStore({
    autoLoad: false,
    proxy: new Ext.data.HttpProxy({
        url: '<%=request.getContextPath()%>/AccountsHeadMasterAction.do?param=getAccountsHeadMasterDetails',
        method: 'POST'
    }),
    storeId: 'accountsHeadMasterId',
    reader: reader
});

var filters = new Ext.ux.grid.GridFilters({
    local: true,
    filters: [{
        type: 'numeric',
        dataIndex: 'slnoIndex'
    }, {
        type: 'int',
        dataIndex: 'uniqueIdDataIndex'
    }, {
        type: 'string',
        dataIndex: 'paymentHeadDataIndex'
    }, {
        type: 'string',
        dataIndex: 'descriptionDataIndex'
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
            filter: {
                type: 'numeric'
            }
        },{
            header: "<span style=font-weight:bold;><%=PaymentAccHead%></span>",
            dataIndex: 'paymentHeadDataIndex',
            width: 80,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=Description%></span>",
            dataIndex: 'descriptionDataIndex',
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

grid = getGrid('<%=AccountsHeadMasterInformation%>', '<%=NoRecordsFound%>', store, screen.width - 40, 440, 8, filters, '<%=ClearFilterData%>', false, '', 16, false, '', false, '', false, '<%=Excel%>', jspName, exportDataType, false, 'PDF', true, '<%=Add%>', true, '<%=Modify%>', false, '<%=Delete%>');

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
    sb = Ext.getCmp('form-statusbar');
});
</script>
 <jsp:include page="../Common/footer.jsp" />
 <!-- </body>   -->
 <!-- </html> -->

	<script> 
	  if (innerpage == true) {
				
				
				var divsToHide = document.getElementsByClassName("footer"); //divsToHide is an array
				
					for(var i = 0; i < divsToHide.length; i++){
						divsToHide[i].style.display = "none"; // depending on what you're doing
						$(".container").css({"margin-top":"-72px"});
					}
			}
			
			</script>
<%}%>
<%}%>