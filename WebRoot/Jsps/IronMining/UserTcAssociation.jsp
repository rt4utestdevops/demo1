<%@ page  language="java" import="java.util.*,java.text.SimpleDateFormat,t4u.functions.*,t4u.beans.*,t4u.common.*" pageEncoding="utf-8"%>
    <%@page import="com.itextpdf.text.log.SysoLogger"%>
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
	int userid = loginInfo.getUserId();
	
	String userAuthority=cf.getUserAuthority(systemId,userid);
	if(customerId > 0 && loginInfo.getIsLtsp()== -1)
	{
		response.sendRedirect(request.getContextPath()+ "/Jsps/Common/401Error.html");
	}
	

int CustIdfrom=0;
if(request.getParameter("CustId")!=null){
	CustIdfrom=Integer.parseInt(request.getParameter("CustId").toString().trim());
}
int UserIdfrom=0;
if(request.getParameter("UserId")!=null){
	UserIdfrom=Integer.parseInt(request.getParameter("UserId").toString().trim());
}

ArrayList<String> tobeConverted = new ArrayList<String>();
tobeConverted.add("Select_Customer");
tobeConverted.add("Customer_Name");
tobeConverted.add("User");
tobeConverted.add("Select_User");
tobeConverted.add("SLNO");
tobeConverted.add("Non_Associated");
tobeConverted.add("Associate");
tobeConverted.add("Disassociate");
tobeConverted.add("Associated");
tobeConverted.add("Select_Customer_Name");
tobeConverted.add("Group_Name_Already_Associated");
tobeConverted.add("Group_Name_Already_Disassociated");
tobeConverted.add("CUSTOMER_ID");
tobeConverted.add("No_Records_Found");
tobeConverted.add("Please_Select_Atleast_One_Group_Name_To_Associate");
tobeConverted.add("Please_Select_Atleast_One_Group_Name_To_Disassociate");
tobeConverted.add("You_Can_Either_Associate_Or_Dissociate_At_a_Time");
tobeConverted.add("Organization_Trader_Name");


ArrayList<String> convertedWords = new ArrayList<String>();
convertedWords = cf.getLanguageSpecificWordForKey(tobeConverted,language);
String SelectCustomer=convertedWords.get(0); 
String CustomerName=convertedWords.get(1); 
String User=convertedWords.get(2); 
String SelectUser=convertedWords.get(3); 
String SLNO=convertedWords.get(4); 
String NonAssociated=convertedWords.get(5); 
String Associate=convertedWords.get(6); 
String Disassociate=convertedWords.get(7); 
String Associated=convertedWords.get(8); 
String SelectCustomerName =convertedWords.get(9); 
String GroupNameAlreadyAssociated=convertedWords.get(10); 
String GroupNameAlreadyDisAssociated=convertedWords.get(11); 
String CustomerId=convertedWords.get(12); 
String NoRecordsfound=convertedWords.get(13); 
String PleaseselectAtleastOneGroupNameToAssociate=convertedWords.get(14);              
String PleaseselectAtleastOneGroupNameToDisassociate=convertedWords.get(15);
String YouCanEitherAssociateOrDissociateAtaTime=convertedWords.get(16);
String OrganizationName=convertedWords.get(17);
String TcName="Tc Name";
String TcId="Tc Id";
String orgId="Organization Id";
%>
            <jsp:include page="../Common/header.jsp" />
                <title></title>
           
            <style>
                .x-panel-tl {
                    border-bottom: 0px solid !important;
                }
            </style>

          
                <%if (loginInfo.getStyleSheetOverride().equals("Y")){%>
                    <jsp:include page="../Common/ImportJSSandMining.jsp" />
                    <%}else {%>
                        <jsp:include page="../Common/ImportJS.jsp" />
                        <%} %>
                            <jsp:include page="../Common/ExportJS.jsp" />
	 <% String newMenuStyle=loginInfo.getNewMenuStyle();
		if(newMenuStyle.equalsIgnoreCase("YES")){%>
		<style>	
			.x-panel-header
			{
				height: 7% !important;
			}
			.x-grid3-cell-inner,.ext-strict .x-grid3-hd-inner {
				height: 26px !important;
				padding-top: 8px;
			}		
			label {
				display : inline !important;
			}			
			.ext-strict .x-form-text {
				height: 21px !important;
			}	
			.x-window-tl *.x-window-header {
				padding-top : 6px !important;				
			}					
			.x-layer ul {
				min-height: 27px !important;
			}
			.x-menu-list {
				height:auto !important;
			}
			
		</style>
	 <%}%>
                            <script>
                                var selected;
                                var globalCustomerID = parent.globalCustomerID;
                                var flag = false;
                                var usercombostore = new Ext.data.JsonStore({
                                    url: '<%=request.getContextPath()%>/UserTcAssociationAction.do?param=getUsersBasedOnCustomer',
                                    id: 'userStoreId',
                                    root: 'userRoot',
                                    autoLoad: false,
                                    remoteSort: true,
                                    fields: ['userId', 'userName'],
                                    listeners: {}
                                });


                                var clientcombostore = new Ext.data.JsonStore({
                                    url: '<%=request.getContextPath()%>/UserTcAssociationAction.do?param=getCustomer&paramforltsp=yes',
                                    id: 'CustomerStoreId',
                                    root: 'CustomerRoot',
                                    autoLoad: true,
                                    remoteSort: true,
                                    fields: ['CustId', 'CustName'],
                                    listeners: {
                                        load: function(custstore, records, success, options) {
                                            if (<%= customerId %> > 0) {
                                                Ext.getCmp('custcomboId').setValue('<%=customerId%>');
                                                custId = Ext.getCmp('custcomboId').getValue();
                                                firstGridStore.load({
                                                    params: {
                                                        CustId: Ext.getCmp('custcomboId').getValue(),
                                                        userIdFromJsp: Ext.getCmp('usercomboId').getValue()
                                                    }
                                                });
                                                secondGridStore.load({
                                                    params: {
                                                        CustId: Ext.getCmp('custcomboId').getValue(),
                                                        userIdFromJsp: Ext.getCmp('usercomboId').getValue()
                                                    }
                                                });
                                                if (<%= UserIdfrom %> > 0) {
                                                    usercombostore.load({
                                                        params: {
                                                            CustId: Ext.getCmp('custcomboId').getValue()
                                                        },
                                                        callback: function() {
                                                            firstGridStore.load({
                                                                params: {
                                                                    CustId: Ext.getCmp('custcomboId').getValue(),
                                                                    userIdFromJsp: Ext.getCmp('usercomboId').getValue()
                                                                }
                                                            });
                                                            secondGridStore.load({
                                                                params: {
                                                                    CustId: Ext.getCmp('custcomboId').getValue(),
                                                                    userIdFromJsp: Ext.getCmp('usercomboId').getValue()
                                                                }
                                                            });
                                                        }
                                                    });
                                                } else {
                                                    usercombostore.load({
                                                        params: {
                                                            CustId: Ext.getCmp('custcomboId').getValue()
                                                        },
                                                        callback: function() {
                                                            firstGridStore.load({
                                                                params: {
                                                                    CustId: Ext.getCmp('custcomboId').getValue(),
                                                                    userIdFromJsp: Ext.getCmp('usercomboId').getValue()
                                                                }
                                                            });
                                                            secondGridStore.load({
                                                                params: {
                                                                    CustId: Ext.getCmp('custcomboId').getValue(),
                                                                    userIdFromJsp: Ext.getCmp('usercomboId').getValue()
                                                                }
                                                            });
                                                        }
                                                    });
                                                }

                                            } else if (<%= CustIdfrom %> > 0) {
                                                Ext.getCmp('custcomboId').setValue('<%=CustIdfrom%>');
                                                custId = Ext.getCmp('custcomboId').getValue();
                                                usercombostore.load({
                                                    params: {
                                                        CustId: Ext.getCmp('custcomboId').getValue()
                                                    }
                                                });
                                                firstGridStore.load({
                                                    params: {
                                                        CustId: Ext.getCmp('custcomboId').getValue(),
                                                        userIdFromJsp: Ext.getCmp('usercomboId').getValue()
                                                    }
                                                });
                                                secondGridStore.load({
                                                    params: {
                                                        CustId: Ext.getCmp('custcomboId').getValue(),
                                                        userIdFromJsp: Ext.getCmp('usercomboId').getValue()
                                                    }
                                                });
                                                if (<%= UserIdfrom %> > 0) {
                                                    usercombostore.load({
                                                        params: {
                                                            CustId: Ext.getCmp('custcomboId').getValue()
                                                        },
                                                        callback: function() {
                                                            Ext.getCmp('usercomboId').setValue(<%= UserIdfrom %>);
                                                            firstGridStore.load({
                                                                params: {
                                                                    CustId: Ext.getCmp('custcomboId').getValue(),
                                                                    userIdFromJsp: Ext.getCmp('usercomboId').getValue()
                                                                }
                                                            });
                                                            secondGridStore.load({
                                                                params: {
                                                                    CustId: Ext.getCmp('custcomboId').getValue(),
                                                                    userIdFromJsp: Ext.getCmp('usercomboId').getValue()
                                                                }
                                                            });
                                                        }
                                                    });
                                                }
                                            } else if (<%= CustIdfrom %> == 0 && <%= UserIdfrom %> > 0) {
                                                Ext.getCmp('custcomboId').setValue('<%=CustIdfrom%>');
                                                custId = Ext.getCmp('custcomboId').getValue();
                                                usercombostore.load({
                                                    params: {
                                                        CustId: Ext.getCmp('custcomboId').getValue()
                                                    }
                                                });
                                                firstGridStore.load({
                                                    params: {
                                                        CustId: Ext.getCmp('custcomboId').getValue(),
                                                        userIdFromJsp: Ext.getCmp('usercomboId').getValue()
                                                    }
                                                });
                                                secondGridStore.load({
                                                    params: {
                                                        CustId: Ext.getCmp('custcomboId').getValue(),
                                                        userIdFromJsp: Ext.getCmp('usercomboId').getValue()
                                                    }
                                                });
                                                if (<%= UserIdfrom %> > 0) {
                                                    usercombostore.load({
                                                        params: {
                                                            CustId: Ext.getCmp('custcomboId').getValue()
                                                        },
                                                        callback: function() {
                                                            Ext.getCmp('usercomboId').setValue(<%= UserIdfrom %>);
                                                            firstGridStore.load({
                                                                params: {
                                                                    CustId: Ext.getCmp('custcomboId').getValue(),
                                                                    userIdFromJsp: Ext.getCmp('usercomboId').getValue()
                                                                }
                                                            });
                                                            secondGridStore.load({
                                                                params: {
                                                                    CustId: Ext.getCmp('custcomboId').getValue(),
                                                                    userIdFromJsp: Ext.getCmp('usercomboId').getValue()
                                                                }
                                                            });
                                                        }
                                                    });
                                                }
                                            } else if (globalCustomerID != 0) {
                                                Ext.getCmp('custcomboId').setValue(globalCustomerID);
                                                var globalClientId = Ext.getCmp('custcomboId').getValue();
                                                usercombostore.load({
                                                    params: {
                                                        CustId: globalClientId
                                                    },
                                                    callback: function() {
                                                        if (<%= UserIdfrom %> > 0) {
                                                            Ext.getCmp('usercomboId').setValue(user);
                                                        }
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
                                    emptyText: '<%=SelectCustomer%>',
                                    blankText: '<%=SelectCustomer%>',
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
                                                Ext.getCmp('usercomboId').reset();
                                                usercombostore.load({
                                                    params: {
                                                        CustId: Ext.getCmp('custcomboId').getValue()
                                                    }
                                                });
                                                firstGridStore.load();
                                                secondGridStore.load();
                                            }
                                        }
                                    }
                                });


                                var Users = new Ext.form.ComboBox({
                                    store: usercombostore,
                                    id: 'usercomboId',
                                    mode: 'local',
                                    forceSelection: true,
                                    emptyText: '<%=SelectUser%>',
                                    blankText: '<%=SelectUser%>',
                                    resizable: true,
                                    selectOnFocus: true,
                                    allowBlank: false,
                                    anyMatch: true,
                                    typeAhead: false,
                                    triggerAction: 'all',
                                    lazyRender: true,
                                    valueField: 'userId',
                                    displayField: 'userName',
                                    cls: 'selectstylePerfect',
                                    listeners: {
                                        select: {
                                            fn: function() {
                                                userId = Ext.getCmp('usercomboId').getValue();
                                                firstGridStore.load({
                                                    params: {
                                                        CustId: Ext.getCmp('custcomboId').getValue(),
                                                        userIdFromJsp: Ext.getCmp('usercomboId').getValue()
                                                    }
                                                });
                                                secondGridStore.load({
                                                    params: {
                                                        CustId: Ext.getCmp('custcomboId').getValue(),
                                                        userIdFromJsp: Ext.getCmp('usercomboId').getValue()
                                                    }
                                                });
                                            }
                                        }
                                    }
                                });

                                var comboPanel = new Ext.Panel({
                                    standardSubmit: true,
                                    collapsible: false,
                                    id: 'traderMaster',
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
                                        Client, {
                                            width: 15
                                        }, {
                                            xtype: 'label',
                                            text: '<%=User%>' + ' :',
                                            cls: 'labelstyle'
                                        },
                                        Users
                                    ]
                                });

                                //***************************************************************************FIRST GRID***********************************************************************************//
                                var sm1 = new Ext.grid.CheckboxSelectionModel({
                                    checkOnly: true
                                });

                                var cols1 = new Ext.grid.ColumnModel([
                                    new Ext.grid.RowNumberer({
                                        header: "<span style=font-weight:bold;><%=SLNO%></span>",
                                        width: 40
                                    }), sm1, {
                                        header: '<b><%=TcName%></b>',
                                        width: 195,
                                        sortable: true,
                                        dataIndex: 'tcNameDataIndex'
                                    }, {
                                        header: '<b><%=OrganizationName%></b>',
                                        width: 195,
                                        sortable: true,
                                        dataIndex: 'orgNameDataIndex'
                                    }, {
                                        header: '<b><%=TcId%></b>',
                                        width: 190,
                                        sortable: true,
                                        hidden: true,
                                        dataIndex: 'tcIdDataIndex'
                                    }, {
                                        header: '<b><%=orgId%></b>',
                                        width: 190,
                                        sortable: true,
                                        hidden: true,
                                        dataIndex: 'orgIdDataIndex'
                                    }
                                ]);

                                var reader1 = new Ext.data.JsonReader({
                                    root: 'firstGridRoot',
                                    fields: [{
                                        name: 'slnoIndex'
                                    }, {
                                        name: 'tcNameDataIndex',
                                        type: 'string'
                                    }, {
                                        name: 'orgNameDataIndex',
                                        type: 'string'
                                    }, {
                                        name: 'tcIdDataIndex',
                                        type: 'int'
                                    }, {
                                        name: 'orgIdDataIndex',
                                        type: 'int'
                                    }]
                                });

                                var filters1 = new Ext.ux.grid.GridFilters({
                                    local: true,
                                    filters: [{
                                        type: 'numeric',
                                        dataIndex: 'slnoIndex'
                                    }, {
                                        dataIndex: 'tcNameDataIndex',
                                        type: 'string'
                                    }, {
                                        dataIndex: 'orgNameDataIndex',
                                        type: 'string'
                                    }, {
                                        dataIndex: 'tcIdDataIndex',
                                        type: 'int'
                                    }, {
                                        dataIndex: 'orgIdDataIndex',
                                        type: 'int'
                                    }]
                                });

                                var firstGridStore = new Ext.data.Store({
                                    url: '<%=request.getContextPath()%>/UserTcAssociationAction.do?param=getDataForNonAssociation',
                                    bufferSize: 367,
                                    reader: reader1,
                                    autoLoad: false,
                                    remoteSort: false
                                });

                                //***************************************************************************88SECOND GRID*******************************************************************************************//
                                var sm2 = new Ext.grid.CheckboxSelectionModel({
                                    checkOnly: true
                                });

                                var cols2 = new Ext.grid.ColumnModel([
                                    new Ext.grid.RowNumberer({
                                        header: "<span style=font-weight:bold;><%=SLNO%></span>",
                                        width: 40
                                    }), sm2, {
                                        header: '<b><%=TcName%></b>',
                                        width: 195,
                                        sortable: true,
                                        dataIndex: 'tcNameDataIndex2'
                                    }, {
                                        header: '<b><%=OrganizationName%></b>',
                                        width: 195,
                                        sortable: true,
                                        dataIndex: 'orgNameDataIndex2'
                                    }, {
                                        header: '<b><%=TcId%></b>',
                                        width: 190,
                                        sortable: true,
                                        hidden: true,
                                        dataIndex: 'tcIdDataIndex2'
                                    }, {
                                        header: '<b><%=orgId%></b>',
                                        width: 190,
                                        sortable: true,
                                        hidden: true,
                                        dataIndex: 'orgIdDataIndex2'
                                    }
                                ]);

                                var reader2 = new Ext.data.JsonReader({
                                    root: 'secondGridRoot',
                                    fields: [{
                                        name: 'slnoIndex2'
                                    }, {
                                        name: 'tcNameDataIndex2',
                                        type: 'string'
                                    }, {
                                        name: 'orgNameDataIndex2',
                                        type: 'String'
                                    }, {
                                        name: 'tcIdDataIndex2',
                                        type: 'int'
                                    }, {
                                        name: 'orgIdDataIndex2',
                                        type: 'int'
                                    }]
                                });

                                var filters2 = new Ext.ux.grid.GridFilters({
                                    local: true,
                                    filters: [{
                                        type: 'numeric',
                                        dataIndex: 'slnoIndex2'
                                    }, {
                                        dataIndex: 'tcNameDataIndex2',
                                        type: 'string'
                                    }, {
                                        dataIndex: 'orgNameDataIndex2',
                                        type: 'string'
                                    }, {
                                        dataIndex: 'tcIdDataIndex2',
                                        type: 'int'
                                    }, {
                                        name: 'orgIdDataIndex2',
                                        type: 'int'
                                    }]
                                });

                                var secondGridStore = new Ext.data.Store({
                                    url: '<%=request.getContextPath()%>/UserTcAssociationAction.do?param=getDataForAssociation',
                                    bufferSize: 367,
                                    reader: reader2,
                                    autoLoad: false,
                                    remoteSort: false
                                });

                                var associateAndDissociatebuttonsPanel = new Ext.Panel({
                                    standardSubmit: true,
                                    collapsible: false,
                                    id: 'buttonpannelid',
                                    layout: 'table',
                                    frame: false,
                                    // colspan: 3,
                                    width: 150,
                                    height: 500,
                                    layoutConfig: {
                                        columns: 1
                                    },
                                    items: [{
                                        xtype: 'label',
                                        text: '',
                                        cls: 'mandatoryfield',
                                        id: 'mandatoryFirstNameId1'
                                    }, {
                                        xtype: 'label',
                                        text: '',
                                        cls: 'mandatoryfield',
                                        id: 'mandatoryFirstNameId2'
                                    }, {
                                        xtype: 'label',
                                        text: '',
                                        cls: 'mandatoryfield',
                                        id: 'mandatoryFirstNameId3'
                                    }, {
                                        xtype: 'label',
                                        text: '',
                                        cls: 'mandatoryfield',
                                        id: 'mandatoryFirstNameId4'
                                    }, {
                                        xtype: 'label',
                                        text: '',
                                        cls: 'mandatoryfield',
                                        id: 'mandatoryFirstNameId5'
                                    }, {
                                        xtype: 'label',
                                        text: '',
                                        cls: 'mandatoryfield',
                                        id: 'mandatoryFirstNameId6'
                                    }, {
                                        xtype: 'label',
                                        text: '',
                                        cls: 'mandatoryfield',
                                        id: 'mandatoryFirstNameId7'
                                    }, {
                                        xtype: 'label',
                                        text: '',
                                        cls: 'mandatoryfield',
                                        id: 'mandatoryFirstNameId8'
                                    }, {
                                        xtype: 'label',
                                        text: '',
                                        cls: 'mandatoryfield',
                                        id: 'mandatoryFirstNameId9'
                                    }, {
                                        xtype: 'label',
                                        text: '',
                                        cls: 'mandatoryfield',
                                        id: 'mandatoryFirstNameId10'
                                    }, {
                                        xtype: 'label',
                                        text: '',
                                        cls: 'mandatoryfield',
                                        id: 'mandatoryFirstNameId11'
                                    }, {
                                        xtype: 'label',
                                        text: '',
                                        cls: 'mandatoryfield',
                                        id: 'mandatoryFirstNameId12'
                                    }, {
                                        xtype: 'label',
                                        text: '',
                                        cls: 'mandatoryfield',
                                        id: 'mandatoryFirstNameId13'
                                    }, {
                                        xtype: 'button',
                                        text: "<span style=font-weight:bold;><%=Associate%></span>",
                                        id: 'associateId',
                                        iconCls: 'associatebutton',
                                        cls: 'userassetbuttonstyle',
                                        width: 80,
                                        listeners: {
                                            click: {
                                                fn: function() {
                                                    if (Ext.getCmp('custcomboId').getValue() == "" && Ext.getCmp('custcomboId').getValue() != "0") {
                                                        Ext.example.msg("<%=SelectCustomerName%>");
                                                        return;
                                                    }
                                                    if (Ext.getCmp('usercomboId').getValue() == "") {
                                                        Ext.example.msg("<%=SelectUser%>");
                                                        return;
                                                    }

                                                    if (grid2.getSelectionModel().getSelected() && grid1.getSelectionModel().getSelected()) {
                                                        Ext.example.msg("<%=YouCanEitherAssociateOrDissociateAtaTime%>");
                                                        return;
                                                    }

                                                    if (grid2.getSelectionModel().getSelected()) {
                                                        Ext.example.msg("<%=GroupNameAlreadyAssociated%>");
                                                        return;
                                                    }
                                                    var records4 = grid1.getSelectionModel().getSelected();
                                                    if (records4 == undefined || records4 == "undefined") {
                                                        Ext.example.msg("<%=PleaseselectAtleastOneGroupNameToAssociate%>");
                                                        return;
                                                    }




                                                    var gridData = "";
                                                    var json = "";
                                                    var records1 = grid1.getSelectionModel().getSelections();
                                                    for (var i = 0; i < records1.length; i++) {
                                                        var record1 = records1[i];
                                                        var row = grid1.store.findExact('slnoIndex', record1.get('slnoIndex'));
                                                        var store = grid1.store.getAt(row);
                                                        json = json + Ext.util.JSON.encode(store.data) + ',';
                                                    }
                                                    var selected = grid1.getSelectionModel().getSelected();
                                                    outerPanel.getEl().mask();
                                                    Ext.Ajax.request({
                                                        url: '<%=request.getContextPath()%>/UserTcAssociationAction.do?param=associateGroup',
                                                        method: 'POST',
                                                        params: {
                                                            CustID: Ext.getCmp('custcomboId').getValue(),
                                                            custName: Ext.getCmp('custcomboId').getRawValue(),
                                                            gridData: json,
                                                            userIdFromJsp: Ext.getCmp('usercomboId').getValue()
                                                        },
                                                        success: function(response, options) {
                                                            var message = response.responseText;
                                                            Ext.example.msg(message);
                                                            outerPanel.getEl().unmask();
                                                            firstGridStore.load({
                                                                params: {
                                                                    CustId: Ext.getCmp('custcomboId').getValue(),
                                                                    userIdFromJsp: Ext.getCmp('usercomboId').getValue()
                                                                }
                                                            });
                                                            secondGridStore.load({
                                                                params: {
                                                                    CustId: Ext.getCmp('custcomboId').getValue(),
                                                                    userIdFromJsp: Ext.getCmp('usercomboId').getValue()
                                                                }
                                                            });
                                                        },
                                                        failure: function() {
                                                            Ext.example.msg("Error");
                                                            firstGridStore.reload();
                                                            secondGridStore.reload();

                                                        }
                                                    });
                                                }
                                            }
                                        }
                                    }, {
                                        xtype: 'label',
                                        text: '',
                                        cls: 'mandatoryfield',
                                        id: 'mandatoryFirstNameId14'
                                    }, {
                                        xtype: 'button',
                                        text: '<b><%=Disassociate%></b>',
                                        id: 'dissociateid',
                                        cls: 'userassetbuttonstyle',
                                        iconCls: 'dissociatebutton',
                                        width: 80,
                                        listeners: {
                                            click: {
                                                fn: function() {
                                                    if (Ext.getCmp('custcomboId').getValue() == "" && Ext.getCmp('custcomboId').getValue() != "0") {
                                                        Ext.example.msg("<%=SelectCustomerName%>");
                                                        return;
                                                    }
                                                    if (Ext.getCmp('usercomboId').getValue() == "") {
                                                        Ext.example.msg("<%=SelectUser%>");
                                                        return;
                                                    }
                                                    if (grid2.getSelectionModel().getSelected() && grid1.getSelectionModel().getSelected()) {
                                                        Ext.example.msg("<%=YouCanEitherAssociateOrDissociateAtaTime%>");
                                                        return;
                                                    }

                                                    if (grid1.getSelectionModel().getSelected()) {
                                                        Ext.example.msg("<%=GroupNameAlreadyDisAssociated%>");
                                                        return;
                                                    }
                                                    var records3 = grid2.getSelectionModel().getSelected();
                                                    if (records3 == undefined || records3 == "undefined") {
                                                        Ext.example.msg('<%=PleaseselectAtleastOneGroupNameToDisassociate%>');
                                                        return;
                                                    }
                                                    var gridData2 = "";
                                                    var json2 = "";
                                                    var records2 = grid2.getSelectionModel().getSelections();
                                                    for (var i = 0; i < records2.length; i++) {
                                                        var record2 = records2[i];
                                                        var row = grid2.store.findExact('slnoIndex2', record2.get('slnoIndex2'));
                                                        var store = grid2.store.getAt(row);
                                                        json2 = json2 + Ext.util.JSON.encode(store.data) + ',';
                                                    }
                                                    var selected = grid2.getSelectionModel().getSelected();
                                                    outerPanel.getEl().mask();
                                                    Ext.Ajax.request({
                                                        url: '<%=request.getContextPath()%>/UserTcAssociationAction.do?param=dissociateGroup',
                                                        method: 'POST',
                                                        params: {
                                                            CustID: Ext.getCmp('custcomboId').getValue(),
                                                            custName: Ext.getCmp('custcomboId').getRawValue(),
                                                            gridData2: json2,
                                                            userIdFromJsp: Ext.getCmp('usercomboId').getValue()
                                                        },
                                                        success: function(response, options) {
                                                            var message = response.responseText;
                                                            Ext.example.msg(message);
                                                            outerPanel.getEl().unmask();
                                                            secondGridStore.load({
                                                                params: {
                                                                    CustId: Ext.getCmp('custcomboId').getValue(),
                                                                    userIdFromJsp: Ext.getCmp('usercomboId').getValue()
                                                                }
                                                            });
                                                            firstGridStore.load({
                                                                params: {
                                                                    CustId: Ext.getCmp('custcomboId').getValue(),
                                                                    userIdFromJsp: Ext.getCmp('usercomboId').getValue()
                                                                }
                                                            });
                                                        },
                                                        failure: function() {
                                                            Ext.example.msg("Error");
                                                            firstGridStore.reload();
                                                            secondGridStore.reload();
                                                        }
                                                    });
                                                }
                                            }
                                        }
                                    }]
                                });

                                var grid1 = getSelectionModelGrid('<%=NonAssociated%>', '<%=NoRecordsfound%>', firstGridStore, 470, 370, cols1, 6, filters1, sm1);
                                var grid2 = getSelectionModelGrid('<%=Associated%>', '<%=NoRecordsfound%>', secondGridStore, 470, 370, cols2, 6, filters2, sm2);

                                var firstGridForNonAssociation = new Ext.Panel({
                                    standardSubmit: true,
                                    collapsible: false,
                                    id: 'FirstGridForNonAssociationId',
                                    layout: 'table',
                                    frame: false,
                                    width: 480,
                                    height: 380,
                                    items: [grid1]
                                });


                                var secondGridPanel = new Ext.Panel({
                                    standardSubmit: true,
                                    collapsible: false,
                                    id: 'secondGridPanelId',
                                    layout: 'table',
                                    frame: false,
                                    width: 480,
                                    height: 380,
                                    items: [grid2]
                                });

                                var firstAndSecondPanels = new Ext.Panel({
                                    standardSubmit: true,
                                    collapsible: false,
                                    id: 'firsrAndSecondGridPanelId',
                                    layout: 'table',
                                    frame: false,
                                    width: '100%',
                                    height: 395,
                                    layoutConfig: {
                                        columns: 5
                                    },
                                    items: [firstGridForNonAssociation, {
                                        width: 100
                                    }, associateAndDissociatebuttonsPanel, {
                                        width: 100
                                    }, secondGridPanel]
                                });

                                Ext.onReady(function() {
                                    ctsb = tsb;
                                    Ext.QuickTips.init();
                                    Ext.form.Field.prototype.msgTarget = 'side';
                                    outerPanel = new Ext.Panel({
                                        title: '',
                                        renderTo: 'content',
                                        standardSubmit: true,
                                        frame: true,
                                        width: screen.width - 38,
                                        height: 510,
                                        // cls: 'outerpanel',
                                        layout: 'table',
                                        layoutConfig: {
                                            columns: 1
                                        },
                                        items: [comboPanel, firstAndSecondPanels]
                                            //bbar: ctsb
                                    });
                                    sb = Ext.getCmp('form-statusbar');
                                });
                            </script>
            <jsp:include page="../Common/footer.jsp" />
 <!-- </body>   -->
 <!-- </html> -->