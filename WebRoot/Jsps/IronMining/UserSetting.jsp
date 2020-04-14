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
	LoginInfoBean loginInfo1=new LoginInfoBean();
		loginInfo1=(LoginInfoBean)session.getAttribute("loginInfoDetails");
		if(loginInfo1!=null)
		{
		int isLtsp=loginInfo1.getIsLtsp();
		loginInfo.setIsLtsp(isLtsp);
		}
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
	boolean button;
	boolean wbS;
	boolean wbD;
	boolean bargeH;
	boolean type;
	boolean closingT;
	String userAuthority=cf.getUserAuthority(systemId,userid);
	System.out.println(loginInfo.getIsLtsp());
	if(customerId > 0 && loginInfo.getIsLtsp()== -1)
	{
	System.out.println(userAuthority);
		//response.sendRedirect(request.getContextPath()+ "/Jsps/Common/401Error.html");
		if(userAuthority.equals("Admin")){
			button=false;
			wbS=false;
			wbD=false;
			bargeH=false;
			type=false;
			closingT=false;
		}else if(userAuthority.equals("Supervisor")){
			button=false;
			wbS=true;
			wbD=true;
			bargeH=true;
			type=true;
			closingT=true;
		}else{
			button=true;
			wbS=true;
			wbD=true;
			bargeH=true;
			type=true;
			closingT=true;
		}
	}else{
		button=false;
		wbS=false;
		wbD=false;
		bargeH=false;
		type=false;
		closingT=false;
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
tobeConverted.add("Permits_Already_Associated");
tobeConverted.add("Permits_Already_Disassociated");
tobeConverted.add("CUSTOMER_ID");
tobeConverted.add("No_Records_Found");
tobeConverted.add("Please_Select_Atleast_One_Permit_To_Associate");
tobeConverted.add("Please_Select_Atleast_One_Permit_To_Disassociate");
tobeConverted.add("You_Can_Either_Associate_Or_Dissociate_At_a_Time");
tobeConverted.add("Organization_Trader_Name");
tobeConverted.add("Select_TC_Number");
tobeConverted.add("Select_Organisation_Trader_Code");
tobeConverted.add("Select_Weigh_Bridge_Source");
tobeConverted.add("Select_Weigh_Bridge_Destination");
tobeConverted.add("Select_Type");


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
String GroupNameAlreadyAssociated=convertedWords.get(10);//Permits_Already_Associated 
String GroupNameAlreadyDisAssociated=convertedWords.get(11);//Permits_Already_Disassociated 
String CustomerId=convertedWords.get(12); 
String NoRecordsfound=convertedWords.get(13); 
String PleaseselectAtleastOnePermitToAssociate=convertedWords.get(14);              
String PleaseselectAtleastOnePermitToDisassociate=convertedWords.get(15);
String YouCanEitherAssociateOrDissociateAtaTime=convertedWords.get(16);
String OrganizationName=convertedWords.get(17);
String Select_TC_Number=convertedWords.get(18);
String Select_OrganisationTrader_Code=convertedWords.get(19);
String Select_Weigh_Bridge_Source=convertedWords.get(20);
String Select_Weigh_Bridge_Destination=convertedWords.get(21);
String Select_Type=convertedWords.get(22);
String Select_Barge_Hub="Select Barge Hub";
String selectOperationType="Select Operation Type";
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
		</style>
	 <%}%>
              <script>
    var selected;
    var globalCustomerID = parent.globalCustomerID;
    var flag = false;

 var clientcombostore = new Ext.data.JsonStore({
                      url: '<%=request.getContextPath()%>/CommonAction.do?param=getCustomer',
					  id: 'CustomerStoreId',
					  root: 'CustomerRoot',
					  autoLoad: true,
					  remoteSort: true,
					  fields: ['CustId', 'CustName'],
                       listeners: {
                           load: function(custstore, records, success, options) {
                           		   if('<%=customerId%>'!=0){
                                   Ext.getCmp('custcomboId').setValue('<%=customerId%>');
                                   
                                   custId = Ext.getCmp('custcomboId').getValue();
                                   userComboStore.load({
					                    params: {
					                        CustID: custId
					                    }
					                });
					                }
					                if('<%=loginInfo.getIsLtsp()%>'== 0){
					                	Ext.getCmp('operationTypeComboId').setReadOnly(false);
					                }else{
					                	Ext.getCmp('operationTypeComboId').setReadOnly(true);
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
                    Ext.getCmp('userComboId').reset();
                    Ext.getCmp('sourceHubcomboId').reset();
                    Ext.getCmp('destinationHubcomboId').reset();
                    Ext.getCmp('typecomboId').reset();
                    Ext.getCmp('closeTypecomboId').reset();
                    userComboStore.load({
                        params: {
                            CustID: custId
                        }
                    });
                    firstGridStore.removeAll();
                    secondGridStore.removeAll();
                    WBHubStore.removeAll();
                }
            }
        }
    });

    var userComboStore = new Ext.data.JsonStore({
        url: '<%=request.getContextPath()%>/UserSettingAction.do?param=getUserNames',
        root: 'userRoot',
        autoLoad: false,
        fields: ['userName', 'userId']
    });

    var Users = new Ext.form.ComboBox({
        store: userComboStore,
        id: 'userComboId',
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
                    Ext.getCmp('sourceHubcomboId').reset();
                    Ext.getCmp('destinationHubcomboId').reset();
                    Ext.getCmp('bargeHubComboId').reset();
                    Ext.getCmp('typecomboId').reset();
                    Ext.getCmp('closeTypecomboId').reset();
                    bargeHubStore.load({
                        params: {
                            custID: Ext.getCmp('custcomboId').getValue()
                        }
                    });
                    WBHubStore.load({
                        params: {
                            custID: Ext.getCmp('custcomboId').getValue(),
                            userID: Ext.getCmp('userComboId').getValue()
                        },
                        callback: function() {
                            UserAssociatedWBStore.load({
                                params: {
                                    userId: Ext.getCmp('userComboId').getValue()
                                },
                                callback: function() {
                                    if (UserAssociatedWBStore != null && UserAssociatedWBStore.getAt(0) != null) {
                                        var rec = UserAssociatedWBStore.getAt(0);
                                        var srcHub = rec.data['SourceHubId'];
                                        var srcHubRow = WBHubStore.find('HubID', srcHub);
                                        if (srcHubRow != -1) {
                                            var srcHubRec = WBHubStore.getAt(srcHubRow);
                                            var srcHub1 = srcHubRec.data['Hubname'];
                                            Ext.getCmp('sourceHubcomboId').setValue(srcHub);
                                            Ext.getCmp('sourceHubcomboId').setRawValue(srcHub1);
                                        }
                                        var destHub = rec.data['DestiHubId'];
                                        var destHubRow = WBHubStore.find('HubID', destHub);
                                        if (destHubRow != -1) {
                                            var destHubRec = WBHubStore.getAt(destHubRow);
                                            var destHub1 = destHubRec.data['Hubname'];
                                            Ext.getCmp('destinationHubcomboId').setValue(destHub);
                                            Ext.getCmp('destinationHubcomboId').setRawValue(destHub1);
                                        }
                                        var bargeHub = rec.data['BargeHubId'];
                                        var bargeHubRow = bargeHubStore.find('HubID', bargeHub);
                                        if (bargeHubRow != -1) {
                                            var bargeHubRec = bargeHubStore.getAt(bargeHubRow);
                                            var bargeHub1 = bargeHubRec.data['Hubname'];
                                            Ext.getCmp('bargeHubComboId').setValue(bargeHub);
                                            Ext.getCmp('bargeHubComboId').setRawValue(bargeHub1);
                                        }
                                        var type = rec.data['Type'];
                                        Ext.getCmp('typecomboId').setValue(type);
                                        if (type != 'Open') {
                                            var closingType = rec.data['ClosingType'];
                                            Ext.getCmp('closeTypecomboId').setValue(closingType);
                                            Ext.getCmp('closeTypecomboId').show();
                                            Ext.getCmp('closeTypeId').show();
                                        } else {
                                            Ext.getCmp('closeTypecomboId').hide();
                                            Ext.getCmp('closeTypeId').hide();
                                        }
                                      var operationType=rec.data['operationType'];
                                      var operationTypeRow =operationTypeStore.find('Value',operationType);
                                      if(operationTypeRow!=-1){
                                      Ext.getCmp('operationTypeComboId').setValue(operationType);
                                      }
                                    }
                                }
                            });
                        }
                    });
                    firstGridStore.load({
                        params: {
                            CustId: Ext.getCmp('custcomboId').getValue(),
                            userId: Ext.getCmp('userComboId').getValue()
                        }
                    });
                    secondGridStore.load({
                        params: {
                            CustId: Ext.getCmp('custcomboId').getValue(),
                            userId: Ext.getCmp('userComboId').getValue()
                        }
                    });
                }
            }
        }
    });

    //************************************combo for User Associated WBStore  **********************************//
    var UserAssociatedWBStore = new Ext.data.JsonStore({
        url: '<%=request.getContextPath()%>/UserSettingAction.do?param=getWeighbridgesAssociatedToUser',
        id: 'UserAssociatedWBStoreId',
        root: 'UserAssociatedWBStoreRoot',
        autoload: false,
        remoteSort: true,
        fields: ['SourceHubId', 'DestiHubId', 'BargeHubId', 'Type', 'ClosingType','operationType']
    });
    //************************************combo for Souce Hub**********************************//
    var WBHubStore = new Ext.data.JsonStore({
        url: '<%=request.getContextPath()%>/UserSettingAction.do?param=getSourcehubNew',
        id: 'sourcehubcomboId11',
        root: 'sourceHubStoreRoot',
        autoload: false,
        remoteSort: true,
        fields: ['Hubname', 'HubID']
    });

    var SourceHubCombo = new Ext.form.ComboBox({
        store: WBHubStore,
        id: 'sourceHubcomboId',
        mode: 'local',
        forceSelection: true,
        emptyText: '<%=Select_Weigh_Bridge_Source%>',
        blankText: '<%=Select_Weigh_Bridge_Source%>',
        resizable: true,
        selectOnFocus: true,
        allowBlank: true,
        anyMatch: true,
        typeAhead: false,
        triggerAction: 'all',
        lazyRender: true,
        valueField: 'HubID',
        displayField: 'Hubname',
        cls: 'selectstylePerfect',
        resizable: true,
        readOnly:<%=wbS%>,
        listeners: {
            select: {
                fn: function() {

                }
            }
        }
    });

    var DestinationHubCombo = new Ext.form.ComboBox({
        store: WBHubStore,
        id: 'destinationHubcomboId',
        mode: 'local',
        forceSelection: true,
        emptyText: '<%=Select_Weigh_Bridge_Destination%>',
        blankText: '<%=Select_Weigh_Bridge_Destination%>',
        resizable: true,
        selectOnFocus: true,
        allowBlank: true,
        anyMatch: true,
        typeAhead: false,
        triggerAction: 'all',
        lazyRender: true,
        valueField: 'HubID',
        displayField: 'Hubname',
        cls: 'selectstylePerfect',
        resizable: true,
        readOnly:<%=wbD%>,
        listeners: {
            select: {
                fn: function() {

                }
            }
        }
    });
    var bargeHubStore = new Ext.data.JsonStore({
        url: '<%=request.getContextPath()%>/UserSettingAction.do?param=getBargeHubs',
        id: 'getBargeHubsStoreId',
        root: 'bargeHubStoreRoot',
        autoload: false,
        remoteSort: true,
        fields: ['Hubname', 'HubID']
    });

    var bargeHubCombo = new Ext.form.ComboBox({
        store: bargeHubStore,
        id: 'bargeHubComboId',
        mode: 'local',
        forceSelection: true,
        emptyText: '<%=Select_Barge_Hub%>',
        blankText: '<%=Select_Barge_Hub%>',
        resizable: true,
        selectOnFocus: true,
        allowBlank: true,
        anyMatch: true,
        typeAhead: false,
        triggerAction: 'all',
        lazyRender: true,
        valueField: 'HubID',
        displayField: 'Hubname',
        cls: 'selectstylePerfect',
        readOnly:<%=bargeH%>,
        resizable: true,
        listeners: {
            select: {
                fn: function() {

                }
            }
        }
    });
    //******************************store for Type**********************************
    var typeStore = new Ext.data.SimpleStore({
        id: 'typeComboStoreId',
        fields: ['Name', 'Value'],
        autoLoad: false,
        data: [
            ['Open', 'Open'],
            ['Close', 'Close'],
            ['Both', 'Both']
        ]
    });

    //****************************combo for Type****************************************
    var typeCombo = new Ext.form.ComboBox({
        store: typeStore,
        id: 'typecomboId',
        mode: 'local',
        forceSelection: true,
        emptyText: '<%=Select_Type%>',
        resizable: true,
        selectOnFocus: true,
        allowBlank: false,
        anyMatch: true,
        typeAhead: false,
        triggerAction: 'all',
        lazyRender: true,
        valueField: 'Value',
        displayField: 'Name',
        readOnly:<%=type%>,
        cls: 'selectstylePerfect',
        listeners: {
            select: {
                fn: function() {
                    if (Ext.getCmp('typecomboId').getValue() == 'Open') {
                        Ext.getCmp('closeTypecomboId').reset();
                        Ext.getCmp('closeTypecomboId').hide();
                        Ext.getCmp('closeTypeId').hide();
                    } else {
                        Ext.getCmp('closeTypecomboId').reset();
                        Ext.getCmp('closeTypecomboId').show();
                        Ext.getCmp('closeTypeId').show();
                    }
                }
            }
        }

    });

    //******************************store for close Type**********************************
    var CloseTypeStore = new Ext.data.SimpleStore({
        id: 'closeTypeComboStoreId',
        fields: ['Name', 'Value'],
        autoLoad: true,
        data: [
            ['Close with Tare @ D', 'Close with Tare @ D'],
            ['Close w/o Tare @ D', 'Close w/o Tare @ D'],
            ['Manual Close', 'Manual Close']
        ]
    });

    //****************************combo for close Type****************************************
    var ClosingTypeCombo = new Ext.form.ComboBox({
        store: CloseTypeStore,
        id: 'closeTypecomboId',
        mode: 'local',
        forceSelection: true,
        emptyText: 'Select Closed Type',
        resizable: true,
        selectOnFocus: true,
        allowBlank: false,
        hidden: true,
        anyMatch: true,
        typeAhead: false,
        triggerAction: 'all',
        lazyRender: true,
        valueField: 'Value',
        displayField: 'Name',
        cls: 'selectstylePerfect',
        readOnly:<%=closingT%>,
        listeners: {
            select: {
                fn: function() {}
            }
        }

    });
 //******************************store for Type**********************************
    var operationTypeStore = new Ext.data.SimpleStore({
        id: 'opertionTypeStoreId',
        fields: ['Name', 'Value'],
        autoLoad: false,
        data: [
            ['Application', 'A'],
            ['RFID', 'R'],
            ['Both', 'B']
        ]
    });
    var operationTypeCombo = new Ext.form.ComboBox({
        store: operationTypeStore,
        id: 'operationTypeComboId',
        mode: 'local',
        forceSelection: true,
        emptyText: 'Select Operation Type',
        resizable: true,
        selectOnFocus: true,
        allowBlank: false,
        anyMatch: true,
        typeAhead: false,
        triggerAction: 'all',
        lazyRender: true,
        valueField: 'Value',
        displayField: 'Name',
        cls: 'selectstylePerfect',
        
    });


    var comboPanel = new Ext.Panel({
        standardSubmit: true,
        collapsible: false,
        id: 'traderMaster',
        layout: 'table',
        frame: false,
        width: screen.width - 12,
        height: 100,
        layoutConfig: {
            columns: 9
        },
        items: [{
                xtype: 'label',
                text: 'Customer' + ' :',
                cls: 'labelstyle'
            },
            Client, {
                width: 15
            }, {
                xtype: 'label',
                text: '<%=User%>' + ' :',
                cls: 'labelstyle'
            },
            Users, {
                width: 15
            }, {
                xtype: 'label',
                text: 'Weighbridge Source' + ' :',
                cls: 'labelstyle'
            },
            SourceHubCombo, {
                width: 15
            }, {
                xtype: 'label',
                text: 'Weighbridge Dest' + ' :',
                cls: 'labelstyle'
            },
            DestinationHubCombo, {
                width: 15
            }, {
                xtype: 'label',
                text: 'Barge Hub' + ' :',
                cls: 'labelstyle'
            },
            bargeHubCombo, {
                width: 15
            }, {
                xtype: 'label',
                text: 'Type' + ' :',
                cls: 'labelstyle'
            },
            typeCombo, {
                width: 15
            }, {
                xtype: 'label',
                text: 'Closing Type' + ' :',
                id: 'closeTypeId',
                hidden: true,
                cls: 'labelstyle'
            },
            ClosingTypeCombo, {
                width: 15
            }, {
                xtype: 'label',
                text: 'Operation Type' + ' :',
                id: 'operationTypeId',
                cls: 'labelstyle'
            },
            operationTypeCombo
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
            header: '<b>Permit No</b>',
            width: 160,
            sortable: true,
            dataIndex: 'permitNoIndex'
        }, {
            header: '<b>Permit Id</b>',
            width: 190,
            sortable: true,
            hidden: true,
            dataIndex: 'permitIdIndex'
        }, {
            header: '<b>Quantity</b>',
            width: 100,
            sortable: true,
            dataIndex: 'permitQty'
        }, {
            header: '<b>Balance</b>',
            width: 100,
            sortable: true,
            dataIndex: 'permitBalance'
        }, {
            header: '<b>TC NO</b>',
            width: 100,
            sortable: true,
            dataIndex: 'tcNoIndex'
        }, {
            header: '<b>ORG NAME</b>',
            width: 100,
            sortable: true,
            dataIndex: 'orgNameIndex'
        }, {
            header: '<b>Route Name</b>',
            width: 100,
            sortable: true,
            dataIndex: 'routeNameIndex'
        }, {
            header: '<b>From Location</b>',
            width: 100,
            sortable: true,
            dataIndex: 'startLocationIndex'
        }, {
            header: '<b>To Location</b>',
            width: 100,
            sortable: true,
            dataIndex: 'endLocationIndex'
        }, {
            header: '<b>TC Id</b>',
            width: 100,
            sortable: true,
            hidden: true,
            dataIndex: 'tcIdIndex'
        }, {
            header: '<b>Org Id</b>',
            width: 100,
            sortable: true,
            hidden: true,
            dataIndex: 'orgIdIndex'
        }
    ]);

    var reader1 = new Ext.data.JsonReader({
        root: 'firstGridRoot',
        fields: [{
            name: 'slnoIndex'
        }, {
            name: 'permitIdIndex',
            type: 'string'
        }, {
            name: 'permitNoIndex',
            type: 'string'
        }, {
            name: 'permitQty',
            type: 'string'
        }, {
            name: 'permitBalance',
            type: 'string'
        }, {
            name: 'tcIdIndex',
            type: 'string'
        }, {
            name: 'tcNoIndex',
            type: 'string'
        }, {
            name: 'orgIdIndex',
            type: 'string'
        }, {
            name: 'orgNameIndex',
            type: 'string'
        }, {
            name: 'routeNameIndex',
            type: 'string'
        }, {
            name: 'startLocationIndex',
            type: 'string'
        }, {
            name: 'endLocationIndex',
            type: 'string'
        }]
    });

    var filters1 = new Ext.ux.grid.GridFilters({
        local: true,
        filters: [{
            type: 'numeric',
            dataIndex: 'slnoIndex'
        }, {
            dataIndex: 'permitIdIndex',
            type: 'string'
        }, {
            dataIndex: 'permitNoIndex',
            type: 'string'
        }, {
            dataIndex: 'permitQty',
            type: 'int'
        }, {
            dataIndex: 'permitBalance',
            type: 'int'
        }, {
            dataIndex: 'tcIdIndex',
            type: 'int'
        }, {
            dataIndex: 'tcNoIndex',
            type: 'string'
        }, {
            dataIndex: 'orgIdIndex',
            type: 'int'
        }, {
            dataIndex: 'orgNameIndex',
            type: 'string'
        }, {
            dataIndex: 'routeNameIndex',
            type: 'string'
        }, {
            dataIndex: 'startLocationIndex',
            type: 'string'
        }, {
            dataIndex: 'endLocationIndex',
            type: 'string'
        }]
    });

    var firstGridStore = new Ext.data.Store({
        url: '<%=request.getContextPath()%>/UserSettingAction.do?param=getDataForNonAssociation',
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
            header: '<b>Permit No</b>',
            width: 160,
            sortable: true,
            dataIndex: 'permitNoIndex2'
        }, {
            header: '<b>Permit Id</b>',
            width: 190,
            sortable: true,
            hidden: true,
            dataIndex: 'permitIdIndex2'
        }, {
            header: '<b>Quantity</b>',
            width: 100,
            sortable: true,
            dataIndex: 'permitQty2'
        }, {
            header: '<b>Balance</b>',
            width: 100,
            sortable: true,
            dataIndex: 'permitBalance2'
        }, {
            header: '<b>TC NO</b>',
            width: 100,
            sortable: true,
            dataIndex: 'tcNoIndex2'
        }, {
            header: '<b>ORG NAME</b>',
            width: 100,
            sortable: true,
            dataIndex: 'orgNameIndex2'
        }, {
            header: '<b>Route Name</b>',
            width: 100,
            sortable: true,
            dataIndex: 'routeNameIndex2'
        }, {
            header: '<b>From Location</b>',
            width: 100,
            sortable: true,
            dataIndex: 'startLocationIndex2'
        }, {
            header: '<b>To Location</b>',
            width: 100,
            sortable: true,
            dataIndex: 'endLocationIndex2'
        }, {
            header: '<b>TC Id</b>',
            width: 100,
            sortable: false,
            hidden: true,
            dataIndex: 'tcIdIndex2'
        }, {
            header: '<b>Org Id</b>',
            width: 100,
            sortable: false,
            hidden: true,
            dataIndex: 'orgIdIndex2'
        }
    ]);

    var reader2 = new Ext.data.JsonReader({
        root: 'secondGridRoot',
        fields: [{
            name: 'slnoIndex2'
        }, {
            name: 'permitIdIndex2',
            type: 'string'
        }, {
            name: 'permitNoIndex2',
            type: 'string'
        }, {
            name: 'permitQty2',
            type: 'string'
        }, {
            name: 'permitBalance2',
            type: 'string'
        }, {
            name: 'tcIdIndex2',
            type: 'string'
        }, {
            name: 'tcNoIndex2',
            type: 'string'
        }, {
            name: 'orgIdIndex2',
            type: 'string'
        }, {
            name: 'orgNameIndex2',
            type: 'string'
        }, {
            name: 'routeNameIndex2',
            type: 'string'
        }, {
            name: 'startLocationIndex2',
            type: 'string'
        }, {
            name: 'endLocationIndex2',
            type: 'string'
        }]
    });

    var filters2 = new Ext.ux.grid.GridFilters({
        local: true,
        filters: [{
            type: 'numeric',
            dataIndex: 'slnoIndex2'
        }, {
            dataIndex: 'permitIdIndex2',
            type: 'string'
        }, {
            dataIndex: 'permitNoIndex2',
            type: 'string'
        }, {
            dataIndex: 'permitQty2',
            type: 'int'
        }, {
            dataIndex: 'permitBalance2',
            type: 'int'
        }, {
            dataIndex: 'tcIdIndex2',
            type: 'int'
        }, {
            dataIndex: 'tcNoIndex2',
            type: 'string'
        }, {
            dataIndex: 'orgIdIndex2',
            type: 'int'
        }, {
            dataIndex: 'orgNameIndex2',
            type: 'string'
        }]
    });

    var secondGridStore = new Ext.data.Store({
        url: '<%=request.getContextPath()%>/UserSettingAction.do?param=getDataForAssociation',
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
            text: "<span style=font-weight:bold;>Associate/Save</span>",
            id: 'associateId',
            iconCls: 'associatebutton',
            cls: 'userassetbuttonstyle',
            width: 80,
            hidden: <%=button%>,
            listeners: {
                click: {
                    fn: function() {
                        if (Ext.getCmp('custcomboId').getValue() == "" && Ext.getCmp('custcomboId').getValue() != "0") {
                            Ext.example.msg("<%=SelectCustomerName%>");
                            return;
                        }
                        if (Ext.getCmp('userComboId').getValue() == "") {
                            Ext.example.msg("<%=SelectUser%>");
                            return;
                        }
                        if (Ext.getCmp('typecomboId').getValue() == "Open" || Ext.getCmp('typecomboId').getValue() == "Both") {
                            if (Ext.getCmp('sourceHubcomboId').getValue() == "") {
                                Ext.example.msg("<%=Select_Weigh_Bridge_Source%>");
                                return;
                            }
                        }
                        if (Ext.getCmp('typecomboId').getValue() == "Close" || Ext.getCmp('typecomboId').getValue() == "Both") {
                            if (Ext.getCmp('destinationHubcomboId').getValue() == "") {
                                Ext.example.msg("<%=Select_Weigh_Bridge_Destination%>");
                                return;
                            }
                        }
                        if (Ext.getCmp('typecomboId').getValue() == "") {
                            Ext.example.msg("<%=Select_Type%>");
                            return;
                        }
                        if (Ext.getCmp('typecomboId').getValue() != "Open" && Ext.getCmp('closeTypecomboId').getValue() == "") {
                            Ext.example.msg("Select Closed Type");
                            return;
                        }
                        if (Ext.getCmp('operationTypeComboId').getValue() == "") {
                            Ext.example.msg("<%=selectOperationType%>");
                            Ext.getCmp('operationTypeComboId').focus();
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
                            url: '<%=request.getContextPath()%>/UserSettingAction.do?param=associateGroup',
                            method: 'POST',
                            params: {
                                CustID: Ext.getCmp('custcomboId').getValue(),
                                custName: Ext.getCmp('custcomboId').getRawValue(),
                                gridData: json,
                                userIdFromJsp: Ext.getCmp('userComboId').getValue(),
                                sourceHubId: Ext.getCmp('sourceHubcomboId').getValue(),
                                destnationHubId: Ext.getCmp('destinationHubcomboId').getValue(),
                                bargeHubId: Ext.getCmp('bargeHubComboId').getValue(),
                                type: Ext.getCmp('typecomboId').getValue(),
                                closedType: Ext.getCmp('closeTypecomboId').getValue(),
                                operationType: Ext.getCmp('operationTypeComboId').getValue()
                            },
                            success: function(response, options) {
                                var message = response.responseText;
                                Ext.example.msg(message);
                                outerPanel.getEl().unmask();
                                firstGridStore.load({
                                    params: {
                                        CustId: Ext.getCmp('custcomboId').getValue(),
                                        userId: Ext.getCmp('userComboId').getValue(),
                                    }
                                });
                                secondGridStore.load({
                                    params: {
                                        CustId: Ext.getCmp('custcomboId').getValue(),
                                        userId: Ext.getCmp('userComboId').getValue(),
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
            hidden: <%=button%>,
            listeners: {
                click: {
                    fn: function() {
                        if (Ext.getCmp('custcomboId').getValue() == "" && Ext.getCmp('custcomboId').getValue() != "0") {
                            Ext.example.msg("<%=SelectCustomerName%>");
                            return;
                        }

                        if (Ext.getCmp('userComboId').getValue() == "") {
                            Ext.example.msg("<%=SelectUser%>");
                            return;
                        }
                        if (Ext.getCmp('typecomboId').getValue() == "Open" || Ext.getCmp('typecomboId').getValue() == "Both") {
                            if (Ext.getCmp('sourceHubcomboId').getValue() == "") {
                                Ext.example.msg("<%=Select_Weigh_Bridge_Source%>");
                                return;
                            }
                        }
                        if (Ext.getCmp('typecomboId').getValue() == "Close" || Ext.getCmp('typecomboId').getValue() == "Both") {
                            if (Ext.getCmp('destinationHubcomboId').getValue() == "") {
                                Ext.example.msg("<%=Select_Weigh_Bridge_Destination%>");
                                return;
                            }
                        }
                        if (Ext.getCmp('typecomboId').getValue() == "") {
                            Ext.example.msg("<%=Select_Type%>");
                            return;
                        }
                        if (Ext.getCmp('typecomboId').getValue() != "Open" && Ext.getCmp('closeTypecomboId').getValue() == "") {
                            Ext.example.msg("Select Closed Type");
                            return;
                        }
                        if (Ext.getCmp('operationTypeComboId').getValue() == "") {
                            Ext.example.msg("<%=selectOperationType%>");
                            Ext.getCmp('operationTypeComboId').focus();
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
                            Ext.example.msg('<%=PleaseselectAtleastOnePermitToDisassociate%>');
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
                            url: '<%=request.getContextPath()%>/UserSettingAction.do?param=dissociateGroup',
                            method: 'POST',
                            params: {
                                CustID: Ext.getCmp('custcomboId').getValue(),
                                custName: Ext.getCmp('custcomboId').getRawValue(),
                                gridData2: json2,
                                userIdFromJsp: Ext.getCmp('userComboId').getValue(),
                                sourceHubId: Ext.getCmp('sourceHubcomboId').getValue(),
                                destnationHubId: Ext.getCmp('destinationHubcomboId').getValue(),
                                bargeHubId: Ext.getCmp('bargeHubComboId').getValue(),
                                type: Ext.getCmp('typecomboId').getValue(),
                                closedType: Ext.getCmp('closeTypecomboId').getValue(),
                                operationType: Ext.getCmp('operationTypeComboId').getValue()
                            },
                            success: function(response, options) {
                                var message = response.responseText;
                                Ext.example.msg(message);
                                outerPanel.getEl().unmask();
                                firstGridStore.load({
                                    params: {
                                        CustId: Ext.getCmp('custcomboId').getValue(),
                                        userId: Ext.getCmp('userComboId').getValue()
                                    }
                                });
                                secondGridStore.load({
                                    params: {
                                        CustId: Ext.getCmp('custcomboId').getValue(),
                                        userId: Ext.getCmp('userComboId').getValue()
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

    var grid1 = getSelectionModelGrid('<%=NonAssociated%>', '<%=NoRecordsfound%>', firstGridStore, 565, 370, cols1, 6, filters1, sm1);
    var grid2 = getSelectionModelGrid('<%=Associated%>', '<%=NoRecordsfound%>', secondGridStore, 565, 370, cols2, 6, filters2, sm2);

    var firstGridForNonAssociation = new Ext.Panel({
        standardSubmit: true,
        collapsible: false,
        id: 'FirstGridForNonAssociationId',
        layout: 'table',
        frame: false,
        width: 575,
        height: 380,
        items: [grid1]
    });


    var secondGridPanel = new Ext.Panel({
        standardSubmit: true,
        collapsible: false,
        id: 'secondGridPanelId',
        layout: 'table',
        frame: false,
        width: 575,
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
            width: 10
        }, associateAndDissociatebuttonsPanel, {
            width: 5
        }, secondGridPanel]
    });

    var notePanels = new Ext.Panel({
        standardSubmit: true,
        collapsible: false,
        id: 'notePanelId',
        layout: 'table',
        frame: false,
        width: '100%',
        //height: 15,
        layoutConfig: {
            columns: 1
        },
        items: {
            xtype: 'label',
            text: 'NOTE : Selection of Barge loading Jetty is necessary for the barge users',
            cls: 'labelstyle',
            id: 'noteLabelId'
        }
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
            height: 540,
            layout: 'table',
            layoutConfig: {
                columns: 1
            },
            items: [comboPanel, firstAndSecondPanels, notePanels]
        });
        sb = Ext.getCmp('form-statusbar');
    });
</script>
 <jsp:include page="../Common/footer.jsp" />
 <!-- </body>   -->
 <!-- </html> -->