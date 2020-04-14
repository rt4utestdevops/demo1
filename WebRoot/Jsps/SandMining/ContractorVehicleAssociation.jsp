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
tobeConverted.add("Contractor");

tobeConverted.add("Select_Contractor");
tobeConverted.add("Vehicle_No");
tobeConverted.add("SLNO");
tobeConverted.add("Non_Associated");
tobeConverted.add("Associate");
tobeConverted.add("Disassociate");
tobeConverted.add("Associated");
tobeConverted.add("Select_Customer_Name");
tobeConverted.add("Vehicle_No_Already_Associated");
tobeConverted.add("Vehicle_No_Already_DisAssociated");
tobeConverted.add("CUSTOMER_ID");
tobeConverted.add("No_Records_Found");
tobeConverted.add("Please_Select_Atleast_One_Vehicle_No_To_Associate");
tobeConverted.add("Please_Select_Atleast_One_Vehicle_No_To_Disassociate");
tobeConverted.add("You_Can_Either_Associate_Or_Dissociate_At_a_Time");
tobeConverted.add("Contractor_Vehicle_Association");


ArrayList<String> convertedWords = new ArrayList<String>();
convertedWords = cf.getLanguageSpecificWordForKey(tobeConverted,language);
String SelectCustomer=convertedWords.get(0); 
String CustomerName=convertedWords.get(1); 
String Contractor=convertedWords.get(2); 

String SelectContractor=convertedWords.get(3); 
String VehicleNo=convertedWords.get(4); 
String SLNO=convertedWords.get(5); 

String NonAssociated=convertedWords.get(6); 
String Associate=convertedWords.get(7); 
String Disassociate=convertedWords.get(8); 
String Associated=convertedWords.get(9); 
String SelectCustomerName =convertedWords.get(10); 

String VehicleNoAlreadyAssociated=convertedWords.get(11); 
String VehicleNoAlreadyDisAssociated=convertedWords.get(12); 
String CustomerId=convertedWords.get(13); 
String NoRecordsfound=convertedWords.get(14); 
String PleaseSelectAtleastOneVehicleNoToAssociate=convertedWords.get(15);              
String PleaseSelectAtleastOneVehicleNoToDisassociate=convertedWords.get(16);
String YouCanEitherAssociateOrDissociateAtaTime=convertedWords.get(17);
String ContractorVehicleAssociation=convertedWords.get(18);

%>
<jsp:include page="../Common/header.jsp" />
		<title><%=ContractorVehicleAssociation%></title>

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
		<style>
			.ext-strict .x-form-text {
				height: 21px !important;
			}
			.x-layer ul {
				min-height: 27px !important;
			}
			label {
				display : inline !important;
			}
		</style>
		<script>
   var selected;
     var globalCustomerID=parent.globalCustomerID;
  var flag=false;
   
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
                  contractorcombostore.load({
                       params: {
                           CustId: Ext.getCmp('custcomboId').getValue()
                       }
                   });
                   }                 
             } 
     } 
     });
   var client = new Ext.form.ComboBox({
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
                   Ext.getCmp('contractorcomboId').reset();
                   contractorcombostore.load({
                       params: {
                           CustId: Ext.getCmp('custcomboId').getValue()
                       }
                   });
               }
           }
       }
   });
   
    var contractorcombostore = new Ext.data.JsonStore({
       url: '<%=request.getContextPath()%>/SandBlockManagementAction.do?param=getContractorBasedOnCustomer',
       id: 'contractorStoreId',
       root: 'contractrRoot',
       autoLoad: false,
       remoteSort: true,
       fields: ['contractorId', 'contractorName'],
       listeners: {
      }
   });
   
   var contractor = new Ext.form.ComboBox({
       store: contractorcombostore,
       id: 'contractorcomboId',
       mode: 'local',
       forceSelection: true,
       emptyText: '<%=SelectContractor%>',
       blankText: '<%=SelectContractor%>',
       selectOnFocus: true,
       allowBlank: false,
       anyMatch: true,
       typeAhead: false,
       triggerAction: 'all',
       lazyRender: true,
       valueField: 'contractorId',
       displayField: 'contractorName',
       cls: 'selectstylePerfect',
       listeners: {
           select: {
               fn: function () {
                   contractorId = Ext.getCmp('contractorcomboId').getValue();
                     firstGridStore.load({
                       params: {
                           CustId: Ext.getCmp('custcomboId').getValue(),
                           contractorIdFromJsp: Ext.getCmp('contractorcomboId').getValue()
                       }
                   });
                   secondGridStore.load({
                       params: {
                           CustId: Ext.getCmp('custcomboId').getValue(),
                           contractorIdFromJsp: Ext.getCmp('contractorcomboId').getValue()
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
           client, {
               width: 15
           }, {
               xtype: 'label',
               text: '<%=Contractor%>' + ' :',
               cls: 'labelstyle'
           },
           contractor
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
           header: '<b><%=VehicleNo%></b>',
           width: 155,
           sortable: true,
           dataIndex: 'vehicleNoDataIndex'
       }
   ]);
   
   var reader1 = new Ext.data.JsonReader({
       root: 'firstGridRoot',
       fields: [{
           name: 'slnoIndex'
       }, {
           name: 'vehicleNoDataIndex',
           type: 'string'
       }]
   });
   
   var filters1 = new Ext.ux.grid.GridFilters({
       local: true,
       filters: [{
           type: 'numeric',
           dataIndex: 'slnoIndex'
       }, {
           dataIndex: 'vehicleNoDataIndex',
           type: 'string'
       }]
   });
   
   var firstGridStore = new Ext.data.Store({
       url: '<%=request.getContextPath()%>/SandBlockManagementAction.do?param=getDataForNonAssociation',
       bufferSize: 367,
       reader: reader1,
       autoLoad: false,
       remoteSort: false
   });
   
    //*************************************************************************** SECOND GRID*******************************************************************************************//
   var sm2 = new Ext.grid.CheckboxSelectionModel({
       checkOnly: true
   });
   
   var cols2 = new Ext.grid.ColumnModel([
       new Ext.grid.RowNumberer({
           header: "<span style=font-weight:bold;><%=SLNO%></span>",
           width: 40
       }), sm2, {
           header: '<b><%=VehicleNo%></b>',
           width: 155,
           sortable: true,
           dataIndex: 'vehicleNoDataIndex2'
       }
   ]);
   
   var reader2 = new Ext.data.JsonReader({
       root: 'secondGridRoot',
       fields: [{
           name: 'slnoIndex2'
       }, {
           name: 'vehicleNoDataIndex2',
           type: 'string'
       }]
   });
   
   var filters2 = new Ext.ux.grid.GridFilters({
       local: true,
       filters: [{
           type: 'numeric',
           dataIndex: 'slnoIndex2'
       }, {
           dataIndex: 'vehicleNoDataIndex2',
           type: 'string'
       }]
   });
   
   var secondGridStore = new Ext.data.Store({
       url: '<%=request.getContextPath()%>/SandBlockManagementAction.do?param=getDataForAssociation',
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
                       if (Ext.getCmp('contractorcomboId').getValue() == "") {
                           Ext.example.msg("<%=SelectContractor%>");
                           return;
                       }
                       
                        if (grid2.getSelectionModel().getSelected() && grid1.getSelectionModel().getSelected() ) {
                           Ext.example.msg("<%=YouCanEitherAssociateOrDissociateAtaTime%>");
                           return;
                       }
                       
                       if (grid2.getSelectionModel().getSelected()) {
                              Ext.example.msg("<%=VehicleNoAlreadyAssociated%>");
                           return;
                       }
                       var records4 = grid1.getSelectionModel().getSelected();
                       if (records4 == undefined || records4 == "undefined") {
                           Ext.example.msg("<%=PleaseSelectAtleastOneVehicleNoToAssociate%>");
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
                           url: '<%=request.getContextPath()%>/SandBlockManagementAction.do?param=associateVehicle',
                           method: 'POST',
                           params: {
                               CustID: Ext.getCmp('custcomboId').getValue(),
                               custName: Ext.getCmp('custcomboId').getRawValue(),
                               gridData: json,
                               contractorIdFromJsp: Ext.getCmp('contractorcomboId').getValue()
                           },
                           success: function (response, options) {
                               var message = response.responseText;
                               Ext.example.msg(message);
                               outerPanel.getEl().unmask();
                               firstGridStore.load({
                                   params: {
                                       CustId: Ext.getCmp('custcomboId').getValue(),
                                       contractorIdFromJsp: Ext.getCmp('contractorcomboId').getValue()
                                   }
                               });
                               secondGridStore.load({
                                   params: {
                                       CustId: Ext.getCmp('custcomboId').getValue(),
                                       contractorIdFromJsp: Ext.getCmp('contractorcomboId').getValue()
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
                       if (Ext.getCmp('contractorcomboId').getValue() == "") {
                           Ext.example.msg("<%=SelectContractor%>");
                           return;
                       }
                        if (grid2.getSelectionModel().getSelected() && grid1.getSelectionModel().getSelected() ) {
                        Ext.example.msg("<%=YouCanEitherAssociateOrDissociateAtaTime%>");
                           return;
                       }
                       
                       if (grid1.getSelectionModel().getSelected()) {
                       Ext.example.msg("<%=VehicleNoAlreadyDisAssociated%>");
                           return;
                       }
                       var records3 = grid2.getSelectionModel().getSelected();
                       if (records3 == undefined || records3 == "undefined") {
                       Ext.example.msg('<%=PleaseSelectAtleastOneVehicleNoToDisassociate%>');
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
                           url: '<%=request.getContextPath()%>/SandBlockManagementAction.do?param=dissociateVehicle',
                           method: 'POST',
                           params: {
                               CustID: Ext.getCmp('custcomboId').getValue(),
                               custName: Ext.getCmp('custcomboId').getRawValue(),
                               gridData2: json2,
                               contractorIdFromJsp: Ext.getCmp('contractorcomboId').getValue()
                            },
                           success: function (response, options) {
                               var message = response.responseText;
                               Ext.example.msg(message);
                               outerPanel.getEl().unmask();
                               firstGridStore.reload();
                               secondGridStore.reload();
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
           title: '<%=ContractorVehicleAssociation%>',
           renderTo: 'content',
           standardSubmit: true,
           frame: true,
           width: screen.width-38,
           height:510,
           layout: 'table',
           layoutConfig: {
               columns: 1
           },
           items: [comboPanel, firstAndSecondPanels]
       });
       sb = Ext.getCmp('form-statusbar');
   });
   </script>
	 <jsp:include page="../Common/footer.jsp" />
 <!-- </body>   -->
 <!-- </html> -->
