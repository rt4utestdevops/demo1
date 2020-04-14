<%@ page language="java"
	import="java.util.*,java.text.SimpleDateFormat,t4u.functions.*,t4u.beans.*,t4u.common.*"
	pageEncoding="utf-8"%>
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
tobeConverted.add("Group_Name");
tobeConverted.add("SLNO");
tobeConverted.add("Non_Associated");
tobeConverted.add("Associate");
tobeConverted.add("Disassociate");
tobeConverted.add("Associated");
tobeConverted.add("Select_Customer_Name");
tobeConverted.add("Group_Id");
tobeConverted.add("Group_Name_Already_Associated");
tobeConverted.add("Group_Name_Already_Disassociated");
tobeConverted.add("CUSTOMER_ID");
tobeConverted.add("No_Records_Found");
tobeConverted.add("Please_Select_Atleast_One_Group_Name_To_Associate");
tobeConverted.add("Please_Select_Atleast_One_Group_Name_To_Disassociate");
tobeConverted.add("You_Can_Either_Associate_Or_Dissociate_At_a_Time");
tobeConverted.add("Next");


ArrayList<String> convertedWords = new ArrayList<String>();
convertedWords = cf.getLanguageSpecificWordForKey(tobeConverted,language);
String SelectCustomer=convertedWords.get(0); 
String CustomerName=convertedWords.get(1); 
String User=convertedWords.get(2); 

String SelectUser=convertedWords.get(3); 
String GroupName=convertedWords.get(4); 
String SLNO=convertedWords.get(5); 

String NonAssociated=convertedWords.get(6); 
String Associate=convertedWords.get(7); 
String Disassociate=convertedWords.get(8); 
String Associated=convertedWords.get(9); 
String SelectCustomerName =convertedWords.get(10); 
String GroupId =convertedWords.get(11); 
String GroupNameAlreadyAssociated=convertedWords.get(12); 
String GroupNameAlreadyDisAssociated=convertedWords.get(13); 
String CustomerId=convertedWords.get(14); 
String NoRecordsfound=convertedWords.get(15); 
String PleaseselectAtleastOneGroupNameToAssociate=convertedWords.get(16);              
String PleaseselectAtleastOneGroupNameToDisassociate=convertedWords.get(17);
String YouCanEitherAssociateOrDissociateAtaTime=convertedWords.get(18);
String Next=convertedWords.get(19);
String userAuthority=cf.getUserAuthority(systemId,userid);

%>
<!DOCTYPE HTML>
<html>
	<head>
		<title>Sand Hub Group Association</title>
	</head>
	<style>
.x-panel-tl {
	border-bottom: 0px solid !important;
}
</style>
	<body>
		<%if (loginInfo.getStyleSheetOverride().equals("Y")){%>
		<jsp:include page="../Common/ImportJSSandMining.jsp" />
		<%}else {%>
		<jsp:include page="../Common/ImportJS.jsp" />
		<%} %>
		<jsp:include page="../Common/ExportJS.jsp" />
		<script>
   var pageName='Sand Hub Group Association';
   var selected;
   var globalCustomerID=parent.globalCustomerID;
   var flag=false;
     
   var clientcombostore = new Ext.data.JsonStore({
       url: '<%=request.getContextPath()%>/CommonAction.do?param=getCustomer&paramforltsp=yes',
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
              <%--     firstGridStore.load({
                       params: {
                           CustId: Ext.getCmp('custcomboId').getValue(),
                           userIdFromJsp: Ext.getCmp('groupNameComboId').getValue()
                       }
                   });
                   secondGridStore.load({
                       params: {
                           CustId: Ext.getCmp('custcomboId').getValue(),
                           userIdFromJsp: Ext.getCmp('groupNameComboId').getValue()
                       }
                   }); --%>
                   groupNamecombostore.load({
                       params: {
                           CustId: Ext.getCmp('custcomboId').getValue()
                       }
                   });
                    
               }
           }
       }
   });   
   
   var groupNamecombostore = new Ext.data.JsonStore({
       url: '<%=request.getContextPath()%>/TPOwnerAssetAssociationAction.do?param=getGroupNameBasedOnCustomer',
       id: 'groupStoreId',
       root: 'groupStoreRoot',
       autoLoad: false,
       remoteSort: true,
       fields: ['groupId', 'groupName'],
       listeners: {
      }
   });
   
   var Client = new Ext.form.ComboBox({
       store: clientcombostore,
       id: 'custcomboId',
       mode: 'local',
       forceSelection: true,
       emptyText: '<%=SelectCustomer%>',
       blankText: '<%=SelectCustomer%>',
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
                   Ext.getCmp('groupNameComboId').reset();
                   groupNamecombostore.load({
                       params: {
                           CustId: Ext.getCmp('custcomboId').getValue()
                       }
                   });
                  
                  // firstGridStore.load();
                  // secondGridStore.load();
               }
           }
       }
   });
   
   var groupNameCombo = new Ext.form.ComboBox({
       store: groupNamecombostore,
       id: 'groupNameComboId',
       mode: 'local',
       forceSelection: true,
       emptyText: 'Select Group Name',
       blankText: 'Select Group Name',
       selectOnFocus: true,
       allowBlank: false,
       anyMatch: true,
       typeAhead: false,
       triggerAction: 'all',
       lazyRender: true,
       valueField: 'groupId',
       displayField: 'groupName',
       cls: 'selectstylePerfect',
       listeners: {
           select: {
               fn: function () {
                   //tpOwnerId = Ext.getCmp('groupNameComboId').getValue();
                     firstGridStore.load({
                       params: {
                           CustId: Ext.getCmp('custcomboId').getValue(),
                           userIdFromJsp: Ext.getCmp('groupNameComboId').getValue()
                       }
                   });
                   secondGridStore.load({
                       params: {
                           CustId: Ext.getCmp('custcomboId').getValue(),
                           userIdFromJsp: Ext.getCmp('groupNameComboId').getValue()
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
           columns: 30
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
               text: 'Group Name' + ' :',
               cls: 'labelstyle'
           }, 
           groupNameCombo,{
           		width: 15
           }
           
           
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
           header: '<b>Hub Id</b>',
           width: 155,
           hidden: true,
           sortable: true,
           dataIndex: 'hubIdIndex1'
       },{
           header: '<b>Hub Name</b>',
           width: 370,
           sortable: true,
           dataIndex: 'hubNameIndex1'
       }
   ]);
   
   var reader1 = new Ext.data.JsonReader({
       root: 'firstGridRoot',
       fields: [{
           name: 'slnoIndex'
       }, {
           name: 'hubIdIndex1',
           type: 'int'
       },{
           name: 'hubNameIndex1',
           type: 'string'
       }]
   });
   
   var filters1 = new Ext.ux.grid.GridFilters({
       local: true,
       filters: [{
           type: 'numeric',
           dataIndex: 'slnoIndex'
       },{
           dataIndex: 'hubIdIndex1',
           type: 'int'
       },{
           dataIndex: 'hubNameIndex1',
           type: 'string'
       }]
   });
   
   var firstGridStore = new Ext.data.Store({
       url: '<%=request.getContextPath()%>/TPOwnerAssetAssociationAction.do?param=getHubNameForNonAssociation',
       bufferSize: 367,
       reader: reader1,
       autoLoad: false,
       remoteSort: false
   });   
   
     //***************************************************************************SECOND GRID*******************************************************************************************//
   var sm2 = new Ext.grid.CheckboxSelectionModel({
       checkOnly: true
   });
   
   var cols2 = new Ext.grid.ColumnModel([
       new Ext.grid.RowNumberer({
           header: "<span style=font-weight:bold;><%=SLNO%></span>",
           width: 40
       }), sm2, {
           header: '<b>Hub Id</b>',
           width: 155,
           hidden: true,
           sortable: true,
           dataIndex: 'hubIdIndex2'
       },{
           header: '<b>Hub Name</b>',
           width: 370,
           sortable: true,
           dataIndex: 'hubNameIndex2'
       }
   ]);
   
   var reader2 = new Ext.data.JsonReader({
       root: 'secondGridRoot',
       fields: [{
           name: 'slnoIndex2'
       }, {
           name: 'hubIdIndex2',
           type: 'int'
       }, {
           name: 'hubNameIndex2',
           type: 'string'
       }]
   });
   
   var filters2 = new Ext.ux.grid.GridFilters({
       local: true,
       filters: [{
           type: 'numeric',
           dataIndex: 'slnoIndex2'
       }, {
           dataIndex: 'hubIdIndex2',
           type: 'int'
       },{
           dataIndex: 'hubNameIndex2',
           type: 'string'
       }]
   });
   
   var secondGridStore = new Ext.data.Store({
       url: '<%=request.getContextPath()%>/TPOwnerAssetAssociationAction.do?param=getHubNameDataForAssociation',
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
                   fn: function () {
                     if (Ext.getCmp('custcomboId').getValue() == "" && Ext.getCmp('custcomboId').getValue() != "0") {
                          Ext.example.msg("<%=SelectCustomerName%>");
                           return;
                       }
                       if (Ext.getCmp('groupNameComboId').getValue() == "") {
                           Ext.example.msg("Select Group Name");
                           return;
                       }

                       
                        if (grid2.getSelectionModel().getSelected() && grid1.getSelectionModel().getSelected() ) {
                           Ext.example.msg("<%=YouCanEitherAssociateOrDissociateAtaTime%>");
                           return;
                       }
                       
                       if (grid2.getSelectionModel().getSelected()) {
                              Ext.example.msg("Hub Name Already Associated");
                           return;
                       }
                       var records4 = grid1.getSelectionModel().getSelected();
                       if (records4 == undefined || records4 == "undefined") {
                           Ext.example.msg("Please select atleast one Hub Name to associate");
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
                           url: '<%=request.getContextPath()%>/TPOwnerAssetAssociationAction.do?param=associateHubName',
                           method: 'POST',
                           params: {
                               CustID: Ext.getCmp('custcomboId').getValue(),
                               custName: Ext.getCmp('custcomboId').getRawValue(),
                               gridData: json,
                               userIdFromJsp: Ext.getCmp('groupNameComboId').getValue()
                           },
                           success: function (response, options) {
                               var message = response.responseText;
                               Ext.example.msg(message);
                               outerPanel.getEl().unmask();
                               secondGridStore.load({
                                   params: {
                                       CustId: Ext.getCmp('custcomboId').getValue(),
                                       userIdFromJsp: Ext.getCmp('groupNameComboId').getValue()
                                   }
                               });
                               firstGridStore.load({
                                   params: {
                                       CustId: Ext.getCmp('custcomboId').getValue(),
                                       userIdFromJsp: Ext.getCmp('groupNameComboId').getValue()
                                   }
                               });
                           },
                           failure: function () {
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
                   fn: function () {
                     if (Ext.getCmp('custcomboId').getValue() == "" && Ext.getCmp('custcomboId').getValue() != "0") {
                       Ext.example.msg("<%=SelectCustomerName%>");
                           return;
                       }
                       if (Ext.getCmp('groupNameComboId').getValue() == "") {
                           Ext.example.msg("Select TP Owner");
                           return;
                       }
                       
                        if (grid2.getSelectionModel().getSelected() && grid1.getSelectionModel().getSelected() ) {
                        Ext.example.msg("<%=YouCanEitherAssociateOrDissociateAtaTime%>");
                           return;
                       }
                       
                       if (grid1.getSelectionModel().getSelected()) {
                       Ext.example.msg("Hub Name Already DisAssociated");
                           return;
                       }
                       var records3 = grid2.getSelectionModel().getSelected();
                       if (records3 == undefined || records3 == "undefined") {
                       Ext.example.msg("Please select atleast one Hub Name to disassociate");
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
                           url: '<%=request.getContextPath()%>/TPOwnerAssetAssociationAction.do?param=dissociateHubFromGroup',
                           method: 'POST',
                           params: {
                               CustID: Ext.getCmp('custcomboId').getValue(),
                               custName: Ext.getCmp('custcomboId').getRawValue(),
                               gridData2: json2,
                               userIdFromJsp: Ext.getCmp('groupNameComboId').getValue(),
                            },
                           success: function (response, options) {
                               var message = response.responseText;
                               Ext.example.msg(message);
                               outerPanel.getEl().unmask();
                               secondGridStore.load({
                                   params: {
                                       CustId: Ext.getCmp('custcomboId').getValue(),
                                       userIdFromJsp: Ext.getCmp('groupNameComboId').getValue()
                                   }
                               });
                               firstGridStore.load({
                                   params: {
                                       CustId: Ext.getCmp('custcomboId').getValue(),
                                       userIdFromJsp: Ext.getCmp('groupNameComboId').getValue()
                                   }
                               });
                           },
                           failure: function () {
                           Ext.example.msg("Error");
                               firstGridStore.reload();
                               secondGridStore.reload();
                           }
                       });  
                   }
               }
           }
       } ]
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
       items: [firstGridForNonAssociation, {width: 100},associateAndDissociatebuttonsPanel,{width: 100},secondGridPanel
       ]
   });   
   
     Ext.onReady(function () {
       ctsb = tsb;
       Ext.QuickTips.init();
       Ext.form.Field.prototype.msgTarget = 'side';
       outerPanel = new Ext.Panel({
           title: 'Hub Group Association',
           renderTo: 'content',
           standardSubmit: true,
           frame: true,
           width: screen.width-38,
           height:510,
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
	</body>
</html>