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
		
   LoginInfoBean loginInfo=(LoginInfoBean)session.getAttribute("loginInfoDetails");
  
String language=loginInfo.getLanguage();
int systemId=loginInfo.getSystemId();
int userId=loginInfo.getUserId();
int customerId=loginInfo.getCustomerId();
ArrayList<String> tobeConverted = new ArrayList<String>();

tobeConverted.add("SLNO");
tobeConverted.add("Non_Associated");
tobeConverted.add("Associate");
tobeConverted.add("Disassociate");
tobeConverted.add("Associated");
tobeConverted.add("No_Records_Found");
tobeConverted.add("You_Can_Either_Associate_Or_Dissociate_At_a_Time");
tobeConverted.add("Select_Customer");
tobeConverted.add("Customer_Name");
tobeConverted.add("Select_Customer_Name");
tobeConverted.add("Asset_Type");
tobeConverted.add("Asset");
tobeConverted.add("Select_Retailer");
tobeConverted.add("Retailer_Asset_Association");
tobeConverted.add("Please_Select_Atleast_One_Asset_To_Associate");
tobeConverted.add("Please_Select_Atleast_One_Asset_To_Disassociate");
tobeConverted.add("Asset_Already_Associated");
tobeConverted.add("Asset_Already_Disassociated");

ArrayList<String> convertedWords = new ArrayList<String>();
convertedWords = cf.getLanguageSpecificWordForKey(tobeConverted,language);
String SLNO=convertedWords.get(0); 
String NonAssociated=convertedWords.get(1); 
String Associate=convertedWords.get(2); 
String Disassociate=convertedWords.get(3); 
String Associated=convertedWords.get(4); 
String NoRecordsfound=convertedWords.get(5); 
String YouCanEitherAssociateOrDissociateAtaTime=convertedWords.get(6);
String SelectCustomer=convertedWords.get(7); 
String CustomerName=convertedWords.get(8); 
String SelectCustomerName =convertedWords.get(9); 
String AssetType =convertedWords.get(10); 
String Asset=convertedWords.get(11);
String SelectRetailer=convertedWords.get(12);
String Retailer_Asset_Association=convertedWords.get(13);
String PleaseselectAtleastOneAssetToAssociate =convertedWords.get(14);
String PleaseselectAtleastOneAssetToDisassociate=convertedWords.get(15);
String AssetAlreadyAssociated=convertedWords.get(16);
String AssetAlreadyDisAssociated=convertedWords.get(17);
%>
<jsp:include page="../Common/header.jsp" />
		<title><%=Retailer_Asset_Association%></title>
	
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
			label {
				display : inline !important;
			}		
			.x-layer ul {
				min-height: 27px !important;
			}
			.ext-strict .x-form-text {
				height: 21px !important;
			}						
		 </style>
		<script>
  
   var selectedRetId;
   var selectGrpId;
   var custId = '<%= customerId %>';
   var clientcombostore = new Ext.data.JsonStore({
       url: '<%=request.getContextPath()%>/CommonAction.do?param=getCustomer',
       id: 'CustomerStoreId',
       root: 'CustomerRoot',
       autoLoad: true,
       remoteSort: true,
       fields: ['CustId', 'CustName'],
        listeners: {
                    load: function (custstore, records, success, options) {
                        if ( custId > 0) {
                            Ext.getCmp('custmastcomboId').setValue(custId);
                        }
                    }
                }
              }),
             
   Client = new Ext.form.ComboBox({
       store: clientcombostore,
       id: 'custmastcomboId',
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
                        	custId = Ext.getCmp('custmastcomboId').getValue();
                        	  Ext.getCmp('retailercomboId').reset();
                        	if ( custId > 0) {
	                        	retailercombostore.load({
			                 	  params:{CustId:custId}});
		                 	} 
                        }
                    }
                }
            });
   
   var retailercombostore = new Ext.data.JsonStore({
      url: '<%=request.getContextPath()%>/AssetAssociationActionColdchain.do?param=getRetailer',
       id: 'reatilerStoreId',
       root: 'retailerRoot',
       autoLoad: true,
       remoteSort: true,
       fields: ['retailerId', 'retailerName','groupid'],
       
   });   
     	 
   var Retailers = new Ext.form.ComboBox({
       store: retailercombostore,
       id: 'retailercomboId',
       mode: 'local',
       forceSelection: true,
       emptyText: '<%=SelectRetailer%>',
       blankText: '<%=SelectRetailer%>',
       selectOnFocus: true,
       allowBlank: false,
       anyMatch: true,
       typeAhead: false,
       triggerAction: 'all',
       lazyRender: true,
       valueField: 'retailerId',
       displayField:  'retailerName',
       cls: 'selectstylePerfect',
       listeners: {
           select: {
               fn: function () {
                   custId = Ext.getCmp('custmastcomboId').getValue();
                   var	row = retailercombostore.find('retailerName', Ext.getCmp('retailercomboId').getRawValue());
				   var RetailerComboRecord = retailercombostore.getAt(row);
				   selectGrpId=RetailerComboRecord.data['groupid'];
               	   selectedRetId = Ext.getCmp('retailercomboId').getValue();
	               nonAssociatedAssetStore.load({
	                   params:{
	                        selectedRetIdFrmJsp : selectedRetId,
	                        custIdFrmJsp :custId,
	                        selectGrpIdFrmJsp : selectGrpId
	                   }
	               });
	               associatedAssetStore.load({
	                   params:{
	                        selectedRetIdFrmJsp : selectedRetId,
	                        custIdFrmJsp :custId,
	                        selectGrpIdFrmJsp : selectGrpId
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
       items: [ 
       	   {
               xtype: 'label',
               text: '<%=SelectCustomer%>' + ' :',
               cls: 'labelstyle'
           },
           Client, {
               width: 15
           }, {
               xtype: 'label',
               text: '<%=SelectRetailer%>' + ' :',
               cls: 'labelstyle'
           },
           Retailers
       ]
   });
   
    //*********************************************************NON ASSOCIATED GRID*********************************************************************//
   var sm1 = new Ext.grid.CheckboxSelectionModel({
       checkOnly: true
   });
   
   var NonAssociateCols = new Ext.grid.ColumnModel([
       new Ext.grid.RowNumberer({
           header: "<span style=font-weight:bold;><%=SLNO%></span>",
           width: 40
       }), sm1, {
           header: '<b><%=Asset%></b>',
           width: 155,
           sortable: true,
           dataIndex: 'assetDataIndex'
       },{
           header: '<b><%=AssetType%></b>',
           width: 155,
           sortable: true,
           dataIndex: 'assettypeDataIndex'
       }
   ]);
   
   var NonAssociateReader = new Ext.data.JsonReader({
       root: 'NonassociatedGridRoot',
       fields: [{
           name: 'slnoIndex'
       }, {
           name: 'assetDataIndex',
           type: 'string'
       }, {
           name: 'assettypeDataIndex',
           type: 'string'
       }]
   });
   
   var NonAssociateFilter = new Ext.ux.grid.GridFilters({
       local: true,
       filters: [{
           type: 'numeric',
           dataIndex: 'slnoIndex'
       }, {
           dataIndex: 'assetDataIndex',
           type: 'string'
       }, {
           dataIndex: 'assettypeDataIndex',
           type: 'string'
       }]
   });
   
   var nonAssociatedAssetStore = new Ext.data.Store({
       url: '<%=request.getContextPath()%>/AssetAssociationActionColdchain.do?param=getNonAssociatedAssetDetails',
       bufferSize: 367,
       reader: NonAssociateReader,
       autoLoad: false,
       remoteSort: false
   });
   
    //**************************************************ASSOCIATED GRID*******************************************************************************//
   var sm2 = new Ext.grid.CheckboxSelectionModel({
       checkOnly: true
   });
   
   var AssociateCols = new Ext.grid.ColumnModel([
       new Ext.grid.RowNumberer({
           header: "<span style=font-weight:bold;><%=SLNO%></span>",
           width: 40
       }), sm2, {
           header: '<b><%=Asset%></b>',
           width: 155,
           sortable: true,
           dataIndex: 'assetDataIndex1'
       }, {
           header: '<b><%=AssetType%></b>',
           width: 155,
           sortable: true,
           dataIndex: 'assettypeDataIndex1'
       }
   ]);
   
   var AssociateReader = new Ext.data.JsonReader({
       root: 'AssociatedGridRoot',
       fields: [{
           name: 'slnoIndex1'
       }, {
           name: 'assetDataIndex1',
           type: 'string'
       },{
           name: 'assettypeDataIndex1',
           type: 'string'
       }]
   });
   
   var AssociateFilter = new Ext.ux.grid.GridFilters({
       local: true,
       filters: [{
           type: 'numeric',
           dataIndex: 'slnoIndex1'
       }, {
           dataIndex: 'assetDataIndex1',
           type: 'string'
       }, {
           dataIndex: 'assettypeDataIndex1',
           type: 'string'
       }]
   });
   
   var associatedAssetStore = new Ext.data.Store({
      url: '<%=request.getContextPath()%>/AssetAssociationActionColdchain.do?param=getAssociatedAssetDetails',
       bufferSize: 367,
       reader: AssociateReader,
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
                   fn: function ()
                   {
                       if (Ext.getCmp('custmastcomboId').getValue() == "" && Ext.getCmp('custmastcomboId').getValue() != "0") {
                          Ext.example.msg("<%=SelectCustomerName%>");
                           return; 
                   }
                        if (Ext.getCmp('retailercomboId').getValue() == "" && Ext.getCmp('retailercomboId').getValue() != "0") {
                           Ext.example.msg("<%=SelectRetailer%>");
                           return;
                       }
                        if (AssociatedGrid.getSelectionModel().getSelected() && NonAssociatedGrid.getSelectionModel().getSelected() ) {
                           Ext.example.msg("<%=YouCanEitherAssociateOrDissociateAtaTime%>");
                           return;
                       }
                       
                       if (AssociatedGrid.getSelectionModel().getSelected()) {
                              Ext.example.msg("<%=AssetAlreadyAssociated%>");
                           return;
                       }
                       var NonAssociatedGridRecord = NonAssociatedGrid.getSelectionModel().getSelected();
                       if (NonAssociatedGridRecord == undefined || NonAssociatedGridRecord == "undefined") {
                           Ext.example.msg("<%=PleaseselectAtleastOneAssetToAssociate%>");
                           return;
                       }
                       
                       var gridData = "";
                       var json = "";
                       var records1 = NonAssociatedGrid.getSelectionModel().getSelections();
                       for (var i = 0; i < records1.length; i++) {
                           var record1 = records1[i];
                           var row = NonAssociatedGrid.store.findExact('slnoIndex', record1.get('slnoIndex'));
                           var store = NonAssociatedGrid.store.getAt(row);
                           json = json + Ext.util.JSON.encode(store.data) + ',';
                       }
                       var selected = NonAssociatedGrid.getSelectionModel().getSelected();
                       outerPanel.getEl().mask();
                       Ext.Ajax.request({
                           url: '<%=request.getContextPath()%>/AssetAssociationActionColdchain.do?param=associateAsset',
                           method: 'POST',
                           params: {
                                  selectedRetIdFrmJsp : selectedRetId,
                                  gridData: json,
                                  custIdFrmJsp :custId,
                                  selectGrpIdFrmJsp : selectGrpId
            
                           },
                          
                           success: function (response, options) {
                               var message = response.responseText;
                               Ext.example.msg(message);
                               outerPanel.getEl().unmask();
                               var selectedRetId = Ext.getCmp('retailercomboId').getValue();
                               nonAssociatedAssetStore.load({
                                   params: {
                                selectedRetIdFrmJsp : selectedRetId,
                                custIdFrmJsp :custId,
                                selectGrpIdFrmJsp : selectGrpId
                                   }
                               });
                               associatedAssetStore.load({
                                   params: {
                                      selectedRetIdFrmJsp : selectedRetId,
                                      custIdFrmJsp :custId,
                                      selectGrpIdFrmJsp : selectGrpId
                                   }
                               });
                           },
                           failure: function () {
                           Ext.example.msg("Error");
                               nonAssociatedAssetStore.reload();
                               associatedAssetStore.reload();
                           }
                       });
                   }
               }
           }
       }, {   xtype: 'label',
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
                   
                       if (Ext.getCmp('custmastcomboId').getValue() == "" && Ext.getCmp('custmastcomboId').getValue() != "0") {
                          Ext.example.msg("<%=SelectCustomerName%>");
                           return; 
                   }
                        if (Ext.getCmp('retailercomboId').getValue() == "" && Ext.getCmp('retailercomboId').getValue() != "0") {
                           Ext.example.msg("<%=SelectRetailer%>");
                           return;
                       }
                        if (AssociatedGrid.getSelectionModel().getSelected() && NonAssociatedGrid.getSelectionModel().getSelected() ) {
                        Ext.example.msg("<%=YouCanEitherAssociateOrDissociateAtaTime%>");
                           return;
                       }
                       
                       if (NonAssociatedGrid.getSelectionModel().getSelected()) {
                       Ext.example.msg("<%=AssetAlreadyDisAssociated%>");
                           return;
                       }
                       var AssociatedGridRecord = AssociatedGrid.getSelectionModel().getSelected();
                       if (AssociatedGridRecord == undefined || AssociatedGridRecord == "undefined") {
                       Ext.example.msg('<%=PleaseselectAtleastOneAssetToDisassociate%>');
                           return;
                       }
                       var gridData1 = "";
                       var json1 = "";
                       var records2 = AssociatedGrid.getSelectionModel().getSelections();
                       for (var i = 0; i < records2.length; i++) {
                           var record = records2[i];
                           var row = AssociatedGrid.store.findExact('slnoIndex1', record.get('slnoIndex1'));
                           var store = AssociatedGrid.store.getAt(row);
                           json1 = json1 + Ext.util.JSON.encode(store.data) + ',';
                       }
                       var selected = AssociatedGrid.getSelectionModel().getSelected();
                        outerPanel.getEl().mask();
                       Ext.Ajax.request({
                       url: '<%=request.getContextPath()%>/AssetAssociationActionColdchain.do?param=dissociateAsset',
                           method: 'POST',
                           
                              params: {
                             
                                  selectedRetIdFrmJsp : selectedRetId,
                                  gridData1: json1,
                                  custIdFrmJsp :custId,
                                  selectGrpIdFrmJsp : selectGrpId
            
                            },
                            success: function (response, options) {
                               var message = response.responseText;
                               Ext.example.msg(message);
                               outerPanel.getEl().unmask();
                               var selectedRetId = Ext.getCmp('retailercomboId').getValue();
                               nonAssociatedAssetStore.load({
                                      params: {
                                      selectedRetIdFrmJsp : selectedRetId,
                                      custIdFrmJsp :custId,
                                      selectGrpIdFrmJsp : selectGrpId
                                   }
                               });
                               associatedAssetStore.load({
                                   params: {
                                      selectedRetIdFrmJsp : selectedRetId,
                                      custIdFrmJsp :custId,
                                      selectGrpIdFrmJsp : selectGrpId
                                   }
                               });
                           },
                           failure: function () {
                           Ext.example.msg("Error");
                               nonAssociatedAssetStore.reload();
                               associatedAssetStore.reload();
                           }
                       });
                   }
               }
           }
       } ]
   });
   
   var NonAssociatedGrid = getSelectionModelGrid('<%=NonAssociated%>', '<%=NoRecordsfound%>', nonAssociatedAssetStore, 470, 370, NonAssociateCols, 6, NonAssociateFilter, sm1);
   var AssociatedGrid = getSelectionModelGrid('<%=Associated%>', '<%=NoRecordsfound%>', associatedAssetStore, 470, 370, AssociateCols, 6, AssociateFilter, sm2);
  
    var NonAssociatedGridPanel = new Ext.Panel({
       standardSubmit: true,
       collapsible: false,
       id: 'NonAssociatedGridPanelId',
       layout: 'table',
       frame: false,
       width: 480,
       height: 380,
       items: [NonAssociatedGrid]
   }); 
   
   var AssociatedGridPanel = new Ext.Panel({
       standardSubmit: true,
       collapsible: false,
       id: 'AssociatedGridPanelId',
       layout: 'table',
       frame: false,
       width: 480,
       height: 380,
       items: [AssociatedGrid]
   });
   
   var NonassociatedAndAssociatedPanels = new Ext.Panel({
       standardSubmit: true,
       collapsible: false,
       id: 'NonAssociatedAndAssociatedPanelId',
       layout: 'table',
       frame: false,
       width: '100%',
       height: 395,
       layoutConfig: {
           columns: 5
       },
       items: [NonAssociatedGridPanel, {width: 100},associateAndDissociatebuttonsPanel,{width: 100},AssociatedGridPanel]
   });
  
   Ext.onReady(function () {
       ctsb = tsb;
       Ext.QuickTips.init();
       Ext.form.Field.prototype.msgTarget = 'side';
       outerPanel = new Ext.Panel({
           title: '<%=Retailer_Asset_Association%>',
           renderTo: 'content',
           standardSubmit: true,
           frame: true,
           width: screen.width-38,
           height:510,
           layout: 'table',
           layoutConfig: {
               columns: 1
           },
           items: [comboPanel, NonassociatedAndAssociatedPanels]
       });
       retailercombostore.load({
		                 	  params:{CustId:custId}
		                 	    	});
     
   });
   </script>
	<jsp:include page="../Common/footer.jsp" />
 <!-- </body>   -->
 <!-- </html> -->
