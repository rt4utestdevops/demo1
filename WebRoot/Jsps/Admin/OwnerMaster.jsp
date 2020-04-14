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
tobeConverted.add("Owner_Master");
tobeConverted.add("Select_Customer_Name");

tobeConverted.add("Owner_Information");
tobeConverted.add("First_Name");
tobeConverted.add("Enter_First_Name");

tobeConverted.add("Last_Name");
tobeConverted.add("Enter_Last_Name");
tobeConverted.add("Address");

tobeConverted.add("Enter_Address");
tobeConverted.add("Email_ID");
tobeConverted.add("Enter_Email_Id");

tobeConverted.add("Phone_No");
tobeConverted.add("Enter_Phone_No");
tobeConverted.add("Landline_No");

tobeConverted.add("Owner_Details");
tobeConverted.add("Add");
tobeConverted.add("Modify");

tobeConverted.add("No_Rows_Selected");
tobeConverted.add("Select_Single_Row");
tobeConverted.add("Clear_Filter_Data");

tobeConverted.add("Enter_LandLine_No");
tobeConverted.add("Save");
tobeConverted.add("Cancel");

tobeConverted.add("SLNO");
tobeConverted.add("No_Records_Found");
tobeConverted.add("Excel");

tobeConverted.add("Id");
tobeConverted.add("Modify_Details");
tobeConverted.add("Owner_Name");
tobeConverted.add("Customer_Name");
tobeConverted.add("Are_you_sure_you_want_to_delete");
tobeConverted.add("Delete");
tobeConverted.add("Not_Deleted");

ArrayList<String> convertedWords = new ArrayList<String>();
convertedWords = cf.getLanguageSpecificWordForKey(tobeConverted,language);

String OwnerMaster=convertedWords.get(0);
String SelectCustomerName=convertedWords.get(1);


String OwnerInformation=convertedWords.get(2);
String FirstName=convertedWords.get(3);
String EnterFirstName=convertedWords.get(4);

String LastName=convertedWords.get(5);
String EnterLastName=convertedWords.get(6);
String Address=convertedWords.get(7);

String EnterAddress=convertedWords.get(8);
String EmailId=convertedWords.get(9);
String EnterEmailId=convertedWords.get(10);

String PhoneNo=convertedWords.get(11);
String EnterPhoneNo=convertedWords.get(12);
String LandLineNo=convertedWords.get(13);

String OwnerDetails=convertedWords.get(14);
String Add=convertedWords.get(15);
String Modify=convertedWords.get(16);

String NoRowsSelected=convertedWords.get(17);
String SelectSingleRow=convertedWords.get(18);
String ClearFilterData=convertedWords.get(19);

String EnterLandLineNo=convertedWords.get(20);
String Save=convertedWords.get(21);
String Cancel=convertedWords.get(22);

String SLNO=convertedWords.get(23);
String NoRecordsFound=convertedWords.get(24);
String Excel=convertedWords.get(25);

String Id=convertedWords.get(26);
String ModifyDetails=convertedWords.get(27);
String OwnerName=convertedWords.get(28);
String CustomerName=convertedWords.get(29);
String Areyousureyouwanttodelete=convertedWords.get(30);
String Delete=convertedWords.get(31);
String NotDeleted=convertedWords.get(32);

%>

<jsp:include page="../Common/header.jsp" />
 		<title><%=OwnerMaster%></title>		
    
	 <style>
		.x-panel-tl
		{
			border-bottom: 0px solid !important;
		}
		label {
			display : inline !important;
		}
		.ext-strict .x-form-text {
			height: 21px !important;
		}
		.x-window-tl *.x-window-header {
			height : 36px !important;
		}
		.x-layer ul {
		 	min-height: 27px !important;
		}
  </style>

   <%if (loginInfo.getStyleSheetOverride().equals("Y")){%>
	<jsp:include page="../Common/ImportJSSandMining.jsp"/>
	<%}else{%>
	<jsp:include page="../Common/ImportJS.jsp" /><%}%>
   <jsp:include page="../Common/ExportJS.jsp" />
   <script>
var outerPanel;
var ctsb;
var jspName = "OwnerInformation";
var exportDataType = "";
var selected;
var grid;
var buttonValue;
var titelForInnerPanel;
var myWin;
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
var innerPanelForOwnerDetails = new Ext.form.FormPanel({
    standardSubmit: true,
    collapsible: false,
    autoScroll: true,
    height: 250,
    width: 400,
    frame: true,
    id: 'innerPanelForOwnerDetailsId',
    layout: 'table',
    layoutConfig: {
        columns: 4
    },
    items: [{
        xtype: 'fieldset',
        title: '<%=OwnerInformation%>',
        cls: 'fieldsetpanel',
        collapsible: false,
        colspan: 3,
        id: 'OwnerInformationId',
        width: 360,
        layout: 'table',
        layoutConfig: {
            columns: 3,
             tableAttrs: {
		            style: {
		                width: '88%'
		            }
        			}
        },
        items: [{
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'firstNameEmptyId1'
        }, {
            xtype: 'label',
            text: '<%=FirstName%>' + ' :',
            cls: 'labelstyle',
            id: 'firstNameLabelId'
        }, {
            xtype: 'textfield',
            cls: 'selectstylePerfect',
            allowBlank: false,
            regex:validate('city'),
            blankText: '<%=EnterFirstName%>',
            emptyText: '<%=EnterFirstName%>',
            labelSeparator: '',
            allowBlank: false,
            id: 'firstNameId'
        },  {
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'lastNameEmptyId1'
        }, {
            xtype: 'label',
            text: '<%=LastName%>' + ' :',
            cls: 'labelstyle',
            id: 'lastNameLabelId'
        },{
            xtype: 'textfield',
            cls: 'selectstylePerfect',
            allowBlank: false,
            blankText: '<%=EnterLastName%>',
            emptyText: '<%=EnterLastName%>',
            labelSeparator: '',
            allowBlank: false,
            id: 'lastNameId'
        }, {
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'addressEmptyId1'
        }, {
            xtype: 'label',
            text: '<%=Address%>' + ' :',
            cls: 'labelstyle',
            id: 'addressLabelId'
        },{
            xtype: 'textarea',
            cls: 'selectstylePerfect',
            allowBlank: false,
            blankText: '<%=EnterAddress%>',
            emptyText: '<%=EnterAddress%>',
            labelSeparator: '',
            allowBlank: false,
            id: 'addressId'
        }, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'emailIdEmptyId1'
        }, {
            xtype: 'label',
            text: '<%=EmailId%>' + ' :',
            cls: 'labelstyle',
            id: 'emailIdLabelId'
        }, {
            xtype: 'textfield',
            cls:'selectstylePerfect',
	    	vtype: 'email',
	    	emptyText:'<%=EnterEmailId%>',
	    	emptyText:'<%=EnterEmailId%>',
            id: 'emaidIdId'
        },{
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'phoneNoEmptyId1'
        },{ xtype: 'label',
            text: '<%=PhoneNo%>' + ' :',
            cls: 'labelstyle',
            id: 'phoneNoLabelId'
        },  {
            xtype: 'numberfield',
            cls: 'selectstylePerfect',
            allowBlank: false,
            blankText: '<%=EnterPhoneNo%>',
            emptyText: '<%=EnterPhoneNo%>',
            labelSeparator: '',
            regex:validate('phone'),
            maxLength : 20,
            id: 'phoneNoId'
        }, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'landLineNoEmptyId1'
        }, {
            xtype: 'label',
            text: '<%=LandLineNo%>' + ' :',
            cls: 'labelstyle',
            id: 'landLineNoLabelId'
        }, {
            xtype: 'numberfield',
            cls: 'selectstylePerfect',
           // allowBlank: true,
            blankText: '<%=EnterLandLineNo%>',
            emptyText: '<%=EnterLandLineNo%>',
            labelSeparator: '',
            //regex:validate('phone'),
            maxLength : 20,
            id: 'landLineNoId'
        }]
    }]
});
var innerWinButtonPanel = new Ext.Panel({
    id: 'innerWinButtonPanelId',
    standardSubmit: true,
    collapsible: false,
    autoHeight: true,
    height: 80,
    width: 400,
    frame: true,
    layout: 'table',
    layoutConfig: {
        columns: 4
    },
    buttons: [{
        xtype: 'button',
        text: '<%=Save%>',
        id: 'saveButtonId',
        iconCls:'savebutton',
        cls: 'buttonstyle',
        width: 70,
        listeners: {
            click: {
                fn: function () {
                    if (Ext.getCmp('custcomboId').getValue() == "") {
                        Ext.example.msg("<%=SelectCustomerName%>");
                        return;
                    }
                    if (Ext.getCmp('firstNameId').getValue() == "") {
                    Ext.example.msg("<%=EnterFirstName%>");
                    return;
                    }
                    if (Ext.getCmp('lastNameId').getValue() == "") {
                        Ext.example.msg("<%=EnterLastName%>");
                        return;
                    }
                    if (Ext.getCmp('addressId').getValue() == "") {
                        Ext.example.msg("<%=EnterAddress%>");
                        return;
                    }
                    
                    if (Ext.getCmp('phoneNoId').getValue() == "") {
                        Ext.example.msg("<%=EnterPhoneNo%>");
                        return;
                    }
                    
                    if (innerPanelForOwnerDetails.getForm().isValid()) {
                        var id;
                        var seletedFrstnme;
                        var selectedLstNme;
                        var selectedAdrr;
                        var selectedEmil;
                        var selectedPho;
                        var selectedLand;
                        
                        if (buttonValue == 'Modify') {
                            var selected = grid.getSelectionModel().getSelected();
                            id = selected.get('idDataIndex');
                            seletedFrstnme=selected.get('firstNameDataIndex');
                            selectedLstNme=selected.get('lastNameDataIndex');
                            selectedAdrr=selected.get('addressDataIndex');
                            selectedEmil=selected.get('emailIdDataIndex');
                            selectedPho=selected.get('phoneNoDataIndex');
                            selectedLand=selected.get('landLineNoDataIndex');
                        }
                        ownerMasterOuterPanelWindow.getEl().mask();
                        Ext.Ajax.request({
                            url: '<%=request.getContextPath()%>/OwnerMasterAction.do?param=ownerMasterAddAndModify',
                            method: 'POST',
                            params: {
                                buttonValue: buttonValue,
                                CustId: Ext.getCmp('custcomboId').getValue(),
                                custName: Ext.getCmp('custcomboId').getRawValue(),
                                firstName: Ext.getCmp('firstNameId').getValue(),
                                lastName: Ext.getCmp('lastNameId').getValue(),
                                address: Ext.getCmp('addressId').getValue(),
                                emailId: Ext.getCmp('emaidIdId').getValue(),
                                phoneNo: Ext.getCmp('phoneNoId').getValue(),
                                landlineNo: Ext.getCmp('landLineNoId').getValue(),
                                id: id,
                                gridFirstName:seletedFrstnme,
                                gridLastName:selectedLstNme,
                                gridAddress:selectedAdrr,
                                gridEmailId:selectedEmil,
                                gridPhoneNo:selectedPho,
                                gridLandLineno:selectedLand
                            },
                            success: function (response, options) {
                                var message = response.responseText;
                                Ext.example.msg(message);
                                Ext.getCmp('firstNameId').reset();
                                Ext.getCmp('lastNameId').reset();
                                Ext.getCmp('addressId').reset();
                                Ext.getCmp('emaidIdId').reset();
                                Ext.getCmp('phoneNoId').reset();
                                Ext.getCmp('landLineNoId').reset();
                                myWin.hide();
                                ownerMasterOuterPanelWindow.getEl().unmask();
                                store.load({
                                    params: {
                                        CustId: custId
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
                    myWin.hide();
                }
            }
        }
    }]
});
var ownerMasterOuterPanelWindow = new Ext.Panel({
    width: 410,
    height: 310,
    standardSubmit: true,
    frame: true,
    items: [innerPanelForOwnerDetails, innerWinButtonPanel]
});
myWin = new Ext.Window({
    title: titelForInnerPanel,
    closable: false,
    resizable: false,
    modal: true,
    autoScroll: false,
    height: 360,
    width: 430,
    id: 'myWin',
    items: [ownerMasterOuterPanelWindow]
});

function addRecord() {
    if (Ext.getCmp('custcomboId').getValue() == "") {
        Ext.example.msg("<%=SelectCustomerName%>");
        return;
    }
    buttonValue = '<%=Add%>';
    titelForInnerPanel = '<%=OwnerDetails%>';
    myWin.setPosition(450, 150);
    myWin.show();
    myWin.setTitle(titelForInnerPanel);
    Ext.getCmp('firstNameId').reset();
    Ext.getCmp('lastNameId').reset();
    Ext.getCmp('addressId').reset();
    Ext.getCmp('emaidIdId').reset();
    Ext.getCmp('phoneNoId').reset();
    Ext.getCmp('landLineNoId').reset();
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
    titelForInnerPanel = '<%=ModifyDetails%>';
    myWin.setPosition(450, 150);
    myWin.setTitle(titelForInnerPanel);
    myWin.show();
    Ext.getCmp('firstNameId').show();
    Ext.getCmp('lastNameId').show();
    Ext.getCmp('addressId').show();
    Ext.getCmp('emaidIdId').show();
    Ext.getCmp('phoneNoId').show();
    Ext.getCmp('landLineNoId').show();
    var selected = grid.getSelectionModel().getSelected();
    Ext.getCmp('firstNameId').setValue(selected.get('firstNameDataIndex'));
    Ext.getCmp('lastNameId').setValue(selected.get('lastNameDataIndex'));
    Ext.getCmp('addressId').setValue(selected.get('addressDataIndex'));
    Ext.getCmp('emaidIdId').setValue(selected.get('emailIdDataIndex'));
    Ext.getCmp('phoneNoId').setValue(selected.get('phoneNoDataIndex'));
    Ext.getCmp('landLineNoId').setValue(selected.get('landLineNoDataIndex'));
}

function deleteData() {

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
    Ext.Msg.show({
        title: 'Delete',
        msg: '<%=Areyousureyouwanttodelete%>',
        buttons: {
            yes: true,
            no: true
        },
        fn: function (btn) {
            switch (btn) {
            case 'yes':
                var selected = grid.getSelectionModel().getSelected();
                id = selected.get('idDataIndex');
                outerPanel.getEl().mask();
                Ext.Ajax.request({
                    url: '<%=request.getContextPath()%>/OwnerMasterAction.do?param=deleteData',
                    method: 'POST',
                    params: {
                        CustId: Ext.getCmp('custcomboId').getValue(),
                        id: id
                    },
                    success: function (response, options) {
                        var message = response.responseText;
                        Ext.example.msg(message);
                        outerPanel.getEl().unmask();
                        store.load({
                            params: {
                                CustId: custId
                            }
                        });
                    },
                    failure: function () {
                        Ext.example.msg("Error");
                        store.reload();
                    }
                });
                break;
            case 'no':
                Ext.example.msg("<%=NotDeleted%>");
                store.reload();
                break;
            }
        }
    });
}
var reader = new Ext.data.JsonReader({
    idProperty: 'ownMasterid',
    root: 'ownerMastersRoot',
    totalProperty: 'total',
    fields: [{
        name: 'slnoIndex'
    }, {
        name: 'firstNameDataIndex'
    }, {
        name: 'lastNameDataIndex'
    }, {
        name: 'addressDataIndex'
    }, {
        name: 'emailIdDataIndex'
    }, {
        name: 'phoneNoDataIndex'
    }, {
        name: 'landLineNoDataIndex'
    }, {
        name: 'idDataIndex'
    },{
        name: 'firstNameAndLastNameDataIndex'
    } ]
});
var store = new Ext.data.GroupingStore({
    autoLoad: false,
    proxy: new Ext.data.HttpProxy({
        url: '<%=request.getContextPath()%>/OwnerMasterAction.do?param=getOwnerMasterReport',
        method: 'POST'
    }),
    storeId: 'ownersId',
    reader: reader
});
var filters = new Ext.ux.grid.GridFilters({
    local: true,
    filters: [{
        type: 'numeric',
        dataIndex: 'slnoIndex'
    }, {
        type: 'string',
        dataIndex: 'firstNameDataIndex'
    }, {
        type: 'string',
        dataIndex: 'lastNameDataIndex'
    }, {
        type: 'string',
        dataIndex: 'addressDataIndex'
    }, {
        type: 'string',
        dataIndex: 'emailIdDataIndex'
    }, {
        type: 'string',
        dataIndex: 'phoneNoDataIndex'
    }, {
        type: 'string',
        dataIndex: 'landLineNoDataIndex'
    }, {
        type: 'int',
        dataIndex: 'idDataIndex'
    }, {
        type: 'string',
        dataIndex: 'firstNameAndLastNameDataIndex'
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
            header: "<span style=font-weight:bold;><%=OwnerName%></span>",
            dataIndex: 'firstNameAndLastNameDataIndex',
            width: 100,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=LastName%></span>",
            dataIndex: 'lastNameDataIndex',
            hidden: true,
            width: 100,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=Address%></span>",
            dataIndex: 'addressDataIndex',
            width: 100,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=EmailId%></span>",
            dataIndex: 'emailIdDataIndex',
            width: 100,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=PhoneNo%></span>",
            dataIndex: 'phoneNoDataIndex',
            width: 100,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=LandLineNo%></span>",
            dataIndex: 'landLineNoDataIndex',
            width: 100,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=Id%></span>",
            dataIndex: 'idDataIndex',
            hidden: true,
            width: 100,
            filter: {
                type: 'int'
            }
        },{
            header: "<span style=font-weight:bold;><%=FirstName%></span>",
            dataIndex: 'firstNameDataIndex',
            hidden: true,
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
grid = getGrid('<%=OwnerDetails%>', '<%=NoRecordsFound%>', store, screen.width - 40, 440, 10, filters, '<%=ClearFilterData%>', false, '', 16, false, '', false, '', false, '<%=Excel%>', jspName, exportDataType, false, 'PDF', true, '<%=Add%>', true, '<%=Modify%>', true, '<%=Delete%>');
//******************************************************************************************************************************************************
Ext.onReady(function () {
    ctsb = tsb;
    Ext.QuickTips.init();
    Ext.form.Field.prototype.msgTarget = 'side';
    outerPanel = new Ext.Panel({
        title: '<%=OwnerInformation%>',
        renderTo: 'content',
        standardSubmit: true,
        frame: true,
        width: screen.width-22,
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
    
    
    
    
    

