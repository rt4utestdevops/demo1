<%@ page  language="java" import="java.util.*,t4u.functions.CommonFunctions,t4u.beans.*,t4u.common.*,t4u.functions.CashVanManagementFunctions" pageEncoding="utf-8"%>
<%@ taglib uri="http://packtag.sf.net" prefix="pack"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
if (request.getParameter("list") != null) {
		String list = request.getParameter("list").toString().trim();
		String[] str = list.split(",");
		int systemid = Integer.parseInt(str[0].trim());
		int customerid = Integer.parseInt(str[1].trim());
		int userid = Integer.parseInt(str[2].trim());
		String language = str[3].trim();
		LoginInfoBean loginInfo = new LoginInfoBean();
		loginInfo.setSystemId(systemid);
		loginInfo.setCustomerId(customerid);
		loginInfo.setUserId(userid);
		loginInfo.setLanguage(language);
		loginInfo.setStyleSheetOverride("N");
		loginInfo.setZone(str[4].trim());
		loginInfo.setOffsetMinutes(Integer.parseInt(str[5].trim()));
		loginInfo.setSystemName(str[6].trim());
		loginInfo.setCategory(str[7].trim());
		if (str.length > 8) {
			loginInfo.setCustomerName(str[8].trim());
		}
		if (str.length > 9) {
			loginInfo.setCategoryType(str[9].trim());
		}
		if (str.length > 10) {
			loginInfo.setUserName(str[10].trim());
		}
		if (str.length > 11) {
			loginInfo.setStyleSheetOverride("N");
		}
		session.setAttribute("loginInfoDetails", loginInfo);
	}
	CommonFunctions cf = new CommonFunctions();
	LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
	if (loginInfo == null) {
		response.sendRedirect(request.getContextPath()+ "/Jsps/Common/SessionDestroy.html");
	} else {
		session.setAttribute("loginInfoDetails", loginInfo);
		String language = loginInfo.getLanguage();
		int systemId = loginInfo.getSystemId();
		int customerId = loginInfo.getCustomerId();
		String btnValue = request.getParameter("btn");
		String tripSheetNo = "";
		String routeId = "";
		String date = "";
		String routeName = ""; 
		String deliveryCustomerId = "";
		String checkPoint[] = {};
		CashVanManagementFunctions cvmFunc = new CashVanManagementFunctions();
		if(btnValue.equals("Modify")){
			tripSheetNo = request.getParameter("tripSheetNo");
			deliveryCustomerId = request.getParameter("deliveryCustomerId");
			ArrayList<String> dataList = cvmFunc.getDataBasedOnTripSheetNo(systemId,customerId,tripSheetNo);
			if(dataList.size() > 0){
				routeId = dataList.get(0);
				routeName = dataList.get(1);
				date = dataList.get(2);
			}
			String checkPoints = cvmFunc.getCheckPoints(systemId,customerId,tripSheetNo);
			if(checkPoints.length()>0){
				checkPoint = checkPoints.split(",");
			}
		}
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
	<head>
	<title></title>
	<style>
	.x-table-layout td {
    vertical-align: inherit !important;
    }
    .x-btn-text addbutton{font-family: 'Helvetica', sans-serif;
	                                                  font-size: 12px !important;}
	.x-btn-text editbutton{font-family: 'Helvetica', sans-serif;
	                                                  font-size: 12px !important;}
	.x-btn-text excelbutton{font-family: 'Helvetica', sans-serif;
	                                                  font-size: 12px !important;}
	.x-btn-text pdfbutton{font-family: 'Helvetica', sans-serif;
	                                                  font-size: 12px !important;}
	.x-btn-text{font-family: 'Helvetica', sans-serif;
	                                                  font-size: 12px !important;}
	.x-btn-text clearfilterbutton{font-family: 'Helvetica', sans-serif;
	                                                  font-size: 12px !important;
	}
	
	</style>
	</head>
	<body>
		<%if (loginInfo.getStyleSheetOverride().equals("Y")){%>                  
        <jsp:include page="../Common/ImportJSSandMining.jsp" />                                                    
        <%}else {%>  
        <jsp:include page="../Common/ImportJS.jsp" /><%} %>
        <jsp:include page="../Common/ExportJS.jsp" />
        
        <pack:style src="../../Main/resources/css/LovCombo/Ext.ux.form.LovCombo.css"></pack:style>
	  	<pack:style src="../../Main/resources/css/LovCombo/empty.css"></pack:style>
	  	<pack:style src="../../Main/resources/css/LovCombo/lovcombo.css"></pack:style>
	  	<pack:script src="../../Main/Js/LovCombo/Ext.ux.form.LovCombo.js"></pack:script>
	  	<pack:script src="../../Main/Js/LovCombo/Ext.ux.ThemeCombo.js"></pack:script>
	  	 <pack:script src="../../Main/Js/tabkeygrid.js"></pack:script>

    <script>
    var grid;
	var dtcur = datecur;
	var jspName = 'TripCreationReport';
	var exportDataType = "int,string,string,string,string,string,string,number,number,number,string,number,number,string";
	var currentTime = new Date();
	var minDate = dateprev.add(Date.Month, -10);
	var editedRows = "";
	var endDateMinVal = datecur.add(Date.DAY, -30);
	var globalOnAccOf;
	var checkPoint = ['<%=checkPoint%>'];
	var totalAmtStore = new Ext.data.JsonStore({
		url: '<%=request.getContextPath()%>/cashDispenseAction.do?param=getTotalAmount',
		id: 'totalAmtId',
		root: 'totalAmtRoot',
		autoLoad: false,
		fields: ['totalAmt']
	});
	var totalCheckAmtStore = new Ext.data.JsonStore({
		url: '<%=request.getContextPath()%>/cashDispenseAction.do?param=getTotalCheckAmount',
		id: 'totalCheckAmtId',
		root: 'totalCheckAmtRoot',
		autoLoad: false,
		fields: ['totalAmt']
	});
	var totalJewelleryAmtStore = new Ext.data.JsonStore({
		url: '<%=request.getContextPath()%>/cashDispenseAction.do?param=getTotalJewelleryAmount',
		id: 'totalJewellerykAmtId',
		root: 'totalJewelleryAmtRoot',
		autoLoad: false,
		fields: ['totalAmt']
	});
	var totalForeignAmtStore = new Ext.data.JsonStore({
		url: '<%=request.getContextPath()%>/cashDispenseAction.do?param=getTotalForeignAmount',
		id: 'totalForeignAmtId',
		root: 'totalForeignAmtRoot',
		autoLoad: false,
		fields: ['totalAmt']
	});
	var currentRecordsStore = new Ext.data.JsonStore({
		url: '<%=request.getContextPath()%>/cashDispenseAction.do?param=getCurrentVaultDetails',
		id: 'vaultId',
		root: 'valutRoot',
		autoLoad: false,
		fields: ['denom5000,denom2000','denom1000','denom500','denom100','denom50','denom20','denom10','denom5','denom2','denom1','denom050','denom025','denom010','denom005','denom002','denom001']
	});
	var foreignstore = new Ext.data.JsonStore({
		url: '<%=request.getContextPath()%>/cashDispenseAction.do?param=getForeignCurrency',
	    id: 'foreignStoreId',
	    root: 'foreignRoot',
	    autoLoad: false,
	    fields: ['foreignCurrency']
	});

	var fireignComboMultiSelect = new Ext.ux.form.LovCombo({
		id:'foreignComboId',	 
 		width:200,
		maxHeight:200,
		store: foreignstore,
		mode: 'local',
	    hidden: false,
	    forceSelection: true,
	    emptyText: '',
	    blankText: '',
	    lazyRender: true,
	    selectOnFocus: true,
	    allowBlank: true,
	    autoload: true,
	    anyMatch: true,
	    typeAhead: false,
	    triggerAction: 'all',
	    valueField: 'foreignCurrency',
	    displayField: 'foreignCurrency',
	    multiSelect:true,
		beforeBlur: Ext.emptyFn,
		listeners:{
		select: {
		fn: function(){
			var totalCashAmount = grid.getSelectionModel().getSelected().get('totalCashAmntDI');
			var totalSealAmount = grid.getSelectionModel().getSelected().get('totalSealAmntDI');
			var totalCheckAmount = grid.getSelectionModel().getSelected().get('totalCheckAmntDI');
			var totalJewelleryAmount = grid.getSelectionModel().getSelected().get('totalJewellaryAmntDI');
			totalForeignAmtStore.load({
			params: {checkNos: Ext.getCmp('foreignComboId').getValue(),cvsCustId:globalOnAccOf},
			callback: function(){
				var rec = totalForeignAmtStore.getAt(0);
				setTimeout(function(){grid.getSelectionModel().getSelected().set('totalForeignAmntDI',rec.data['totalAmt']);
				grid.getSelectionModel().getSelected().set('totalAmntDI',((rec.data['totalAmt'] + totalCashAmount) + (totalSealAmount + totalCheckAmount) + (totalJewelleryAmount)));},1500);
			}
			});
		}
		}
		}
	});	
	var jewellarystore = new Ext.data.JsonStore({
		url: '<%=request.getContextPath()%>/cashDispenseAction.do?param=getJewellary',
	    id: 'jewellaryStoreId',
	    root: 'jewellaryRoot',
	    autoLoad: false,
	    fields: ['jewellary']
	});

	var jewellaryComboMultiSelect = new Ext.ux.form.LovCombo({
		id:'jewellaryComboId',	 
 		width:200,
		maxHeight:200,
		store: jewellarystore,
		mode: 'local',
	    hidden: false,
	    forceSelection: true,
	    emptyText: '',
	    blankText: '',
	    lazyRender: true,
	    selectOnFocus: true,
	    allowBlank: true,
	    autoload: true,
	    anyMatch: true,
	    typeAhead: false,
	    triggerAction: 'all',
	    valueField: 'jewellary',
	    displayField: 'jewellary',
	    multiSelect:true,
		beforeBlur: Ext.emptyFn,
		listeners:{
		select: {
		fn: function(){
			var totalCashAmount = grid.getSelectionModel().getSelected().get('totalCashAmntDI');
			var totalSealAmount = grid.getSelectionModel().getSelected().get('totalSealAmntDI');
			var totalCheckAmount = grid.getSelectionModel().getSelected().get('totalCheckAmntDI');
			var totalforeignAmount = grid.getSelectionModel().getSelected().get('totalForeignAmntDI');
			totalJewelleryAmtStore.load({
			params: {checkNos: Ext.getCmp('jewellaryComboId').getValue(),cvsCustId:globalOnAccOf},
			callback: function(){
				var rec = totalJewelleryAmtStore.getAt(0);
				setTimeout(function(){grid.getSelectionModel().getSelected().set('totalJewellaryAmntDI',rec.data['totalAmt']);
				grid.getSelectionModel().getSelected().set('totalAmntDI',((rec.data['totalAmt'] + totalCashAmount) + (totalSealAmount + totalCheckAmount) + (totalforeignAmount)));},1500);
			}
			});
		}
		}
		}
	});
	var checkNostore = new Ext.data.JsonStore({
		url: '<%=request.getContextPath()%>/cashDispenseAction.do?param=getCheckNo',
	    id: 'checkNoStoreId',
	    root: 'checkNoRoot',
	    autoLoad: false,
	    fields: ['checkNo']
	});

	var checkNoComboMultiSelect = new Ext.ux.form.LovCombo({
		id:'checkNoComboId',	 
 		width:200,
		maxHeight:200,
		store: checkNostore,
		mode: 'local',
	    hidden: false,
	    forceSelection: true,
	    emptyText: '',
	    blankText: '',
	    lazyRender: true,
	    selectOnFocus: true,
	    allowBlank: true,
	    autoload: true,
	    anyMatch: true,
	    typeAhead: false,
	    triggerAction: 'all',
	    valueField: 'checkNo',
	    displayField: 'checkNo',
	    multiSelect:true,
		beforeBlur: Ext.emptyFn,
		listeners:{
		select: {
		fn: function(){
			var totalCashAmount = grid.getSelectionModel().getSelected().get('totalCashAmntDI');
			var totalSealAmount = grid.getSelectionModel().getSelected().get('totalSealAmntDI');
			var totalJewelleryAmount = grid.getSelectionModel().getSelected().get('totalJewellaryAmntDI');
			var totalForeignAmount = grid.getSelectionModel().getSelected().get('totalForeignAmntDI');
			totalCheckAmtStore.load({
			params: {checkNos: Ext.getCmp('checkNoComboId').getValue(),cvsCustId:globalOnAccOf},
			callback: function(){
				var rec = totalCheckAmtStore.getAt(0);
				setTimeout(function(){grid.getSelectionModel().getSelected().set('totalCheckAmntDI',rec.data['totalAmt']);
				grid.getSelectionModel().getSelected().set('totalAmntDI',((rec.data['totalAmt'] + totalCashAmount) + (totalSealAmount + totalForeignAmount) + (totalJewelleryAmount)));},1500);
			}
			});
		}
		}
		}
	});
	var sealNostore = new Ext.data.JsonStore({
	    url: '<%=request.getContextPath()%>/cashDispenseAction.do?param=getSealNo',
	    id: 'sealNoStoreId',
	    root: 'sealNoRoot',
	    autoLoad: false,
	    fields: ['sealNoName']
	});

	var sealNoComboMultiSelect = new Ext.ux.form.LovCombo({
		id:'sealNoComboId',	 
 		width:200,
		maxHeight:200,
		store: sealNostore,
		mode: 'local',
	    hidden: false,
	    forceSelection: true,
	    emptyText: '',
	    blankText: '',
	    lazyRender: true,
	    selectOnFocus: true,
	    allowBlank: true,
	    autoload: true,
	    anyMatch: true,
	    typeAhead: false,
	    triggerAction: 'all',
	    valueField: 'sealNoName',
	    displayField: 'sealNoName',
	    multiSelect:true,
		beforeBlur: Ext.emptyFn,
		listeners:{
		select: {
		fn: function(){
			var totalCashAmount = grid.getSelectionModel().getSelected().get('totalCashAmntDI');
			var totalCheckAmount = grid.getSelectionModel().getSelected().get('totalCheckAmntDI');
			var totalJewelleryAmount = grid.getSelectionModel().getSelected().get('totalJewellaryAmntDI');
			var totalForeignAmount = grid.getSelectionModel().getSelected().get('totalForeignAmntDI');
			totalAmtStore.load({
			params: {sealNos: Ext.getCmp('sealNoComboId').getValue(),cvsCustId:globalOnAccOf},
			callback: function(){
				var rec = totalAmtStore.getAt(0);
				setTimeout(function(){grid.getSelectionModel().getSelected().set('totalSealAmntDI',rec.data['totalAmt']);
				grid.getSelectionModel().getSelected().set('totalAmntDI',((rec.data['totalAmt'] + totalCashAmount) + (totalCheckAmount + totalJewelleryAmount) + (totalForeignAmount)));},1500);
			}
			});
		}
		}
		}
	});	
	
var sealedOrCashArray = [['Sealed Bag'],['Cash'],['Cheque'],['Jewellery'],['Foreign Currency']];
	var sealedOrCashstore = new Ext.data.SimpleStore({
    data: sealedOrCashArray,
    autoLoad: true,
    fields: ['name']
});
var sealedOrCashCombo = new Ext.ux.form.LovCombo({
    store: sealedOrCashstore,
    id: 'sealedOrCashComboId',
    mode: 'local',
    hidden: false,
    forceSelection: true,
    emptyText: '',
    blankText: '',
    lazyRender: true,
    selectOnFocus: true,
    allowBlank: true,
    autoload: true,
    anyMatch: true,
    typeAhead: false,
    triggerAction: 'all',
    valueField: 'name',
    displayField: 'name',
   	multiSelect:true,
	beforeBlur: Ext.emptyFn,
    listeners: {
        select: {
            fn: function() {
            	grid.getSelectionModel().getSelected().set('sealNoDI',"");
            	grid.getSelectionModel().getSelected().set('checkNoDI',"");
            	grid.getSelectionModel().getSelected().set('jewellaryNoDI',"");
            	grid.getSelectionModel().getSelected().set('foreignCurrencyDI',"");
            	grid.getSelectionModel().getSelected().set('denom5000DI',"0");
            	grid.getSelectionModel().getSelected().set('denom2000DI',"0");
            	grid.getSelectionModel().getSelected().set('denom1000DI',"0");
            	grid.getSelectionModel().getSelected().set('denom500DI',"0");
            	grid.getSelectionModel().getSelected().set('denom100DI',"0");
            	grid.getSelectionModel().getSelected().set('denom50DI',"0");
            	grid.getSelectionModel().getSelected().set('denom20DI',"0");
            	grid.getSelectionModel().getSelected().set('denom10DI',"0");
            	grid.getSelectionModel().getSelected().set('denom5DI',"0");
            	grid.getSelectionModel().getSelected().set('denom2DI',"0");
            	grid.getSelectionModel().getSelected().set('denom1DI',"0");
            	grid.getSelectionModel().getSelected().set('denom050DI',"0");
            	grid.getSelectionModel().getSelected().set('denom025DI',"0");
            	grid.getSelectionModel().getSelected().set('denom010DI',"0");
            	grid.getSelectionModel().getSelected().set('denom005DI',"0");
            	grid.getSelectionModel().getSelected().set('denom002DI',"0");
            	grid.getSelectionModel().getSelected().set('denom001DI',"0");
            	grid.getSelectionModel().getSelected().set('denom5000DI',"0");
            	grid.getSelectionModel().getSelected().set('totalSealAmntDI',"0");
            	grid.getSelectionModel().getSelected().set('totalCashAmntDI',"0");
            	grid.getSelectionModel().getSelected().set('totalCheckAmntDI',"0");
            	grid.getSelectionModel().getSelected().set('totalJewellaryAmntDI',"0");
            	grid.getSelectionModel().getSelected().set('totalForeignAmntDI',"0");
            	grid.getSelectionModel().getSelected().set('totalAmntDI',"0");
				if(Ext.getCmp('sealedOrCashComboId').getValue().includes("Sealed Bag")){
					sealNostore.load({
						params:{customerId:globalOnAccOf,btn:'<%=btnValue%>'}
					});
				}
				if(Ext.getCmp('sealedOrCashComboId').getValue().includes("Cheque")){
					checkNostore.load({
						params:{customerId:globalOnAccOf,btn:'<%=btnValue%>'}
					});
				}
				if(Ext.getCmp('sealedOrCashComboId').getValue().includes("Jewellery")){
					jewellarystore.load({
						params:{customerId:globalOnAccOf,btn:'<%=btnValue%>'}
					});
				}
				if(Ext.getCmp('sealedOrCashComboId').getValue().includes("Foreign Currency")){
					foreignstore.load({
						params:{customerId:globalOnAccOf,btn:'<%=btnValue%>'}
					});
				}
            }
        }
    }
});
var onAccstore = new Ext.data.JsonStore({
    url: '<%=request.getContextPath()%>/cashDispenseAction.do?param=getOnAccOf',
    id: 'onAccStoreId',
    root: 'onAccRoot',
    autoLoad: true,
    fields: ['CustomerId', 'CustomerName']
});
var onAccCombo = new Ext.form.ComboBox({
    store: onAccstore,
    id: 'onAccComboId',
    mode: 'local',
    hidden: false,
    forceSelection: true,
    emptyText: 'Select On Account Of',
    blankText: 'Select On Account Of',
    lazyRender: true,
    selectOnFocus: true,
    allowBlank: true,
    autoload: true,
    anyMatch: true,
    typeAhead: false,
    triggerAction: 'all',
    valueField: 'CustomerId',
    displayField: 'CustomerName',
    //cls: 'selectstylePerfect',
    listeners: {
        select: {
            fn: function() {
				globalOnAccOf = Ext.getCmp('onAccComboId').getValue();
				grid.getSelectionModel().getSelected().set('sealedBagCashDI',"");
            }
        }
    }
});
var routestore = new Ext.data.JsonStore({
    url: '<%=request.getContextPath()%>/cashDispenseAction.do?param=getRoute',
    id: 'routeStoreId',
    root: 'routeRoot',
    autoLoad: true,
    fields: ['routeId', 'routeName']
});
var routecombo = new Ext.form.ComboBox({
    store: routestore,
    id: 'routecomboId',
    mode: 'local',
    hidden: false,
    forceSelection: true,
    emptyText: 'Select Route Name',
    blankText: 'Select Route Name',
    lazyRender: true,
    selectOnFocus: true,
    allowBlank: true,
    autoload: true,
    anyMatch: true,
    typeAhead: false,
    triggerAction: 'all',
    valueField: 'routeId',
    displayField: 'routeName',
    cls: 'selectstylePerfect',
    listeners: {
        select: {
            fn: function() {
                store.load({
                    params: {
                        routeId: Ext.getCmp('routecomboId').getValue(),
                        btnValue: '<%=btnValue%>'
                    }
                });
            }
        }
    }
});

var deliverycustomerStore = new Ext.data.JsonStore({
    	url: '<%=request.getContextPath()%>/cashDispenseAction.do?param=customerId',
    	id: 'deliverycustomerId',
    	root: 'customerIdRoot',
    	autoLoad: true,
    	fields: ['destCustomerId', 'destCustomerName']
	});
	
	var DeliveryCustomerIdCombo = new Ext.form.ComboBox({
    store: deliverycustomerStore,
    id: 'customerComboId',
    mode: 'local',
    forceSelection: true,
    emptyText: 'Select customer ',
    blankText: 'Select customer ',
    selectOnFocus: true,
    allowBlank: true,
    anyMatch: true,
    typeAhead: false,
    triggerAction: 'all',
    lazyRender: true,
    valueField: 'destCustomerId',
    displayField: 'destCustomerName',
    //cls: 'selectstylePerfect',
    //width: 80,
    listeners: {
        select: {
            fn: function() {
    
          var custId = Ext.getCmp('customerComboId').getValue();
         
           deliveryLocationStore.load({
						params:{
						customerId: Ext.getCmp('customerComboId').getValue()
						}
					});
       	   Ext.getCmp('deliveryLocComboId').reset();
           } 
        }
    }
  });
	
	
	var deliveryLocationStore = new Ext.data.JsonStore({
    	url: '<%=request.getContextPath()%>/cashDispenseAction.do?param=deliveryLocation',
    	id: 'deliveryLocationId',
    	root: 'deliveryLocationIdRoot',
    	autoLoad: false,
    	fields: ['deliveryLocId', 'deliveryCustomerName']
	});
	
var deliveryLocIdCombo = new Ext.form.ComboBox({
    store: deliveryLocationStore,
    id: 'deliveryLocComboId',
    mode: 'local',
    forceSelection: true,
    emptyText: 'Select Delivery Location ',
    blankText: 'Select Delivery Location ',
    selectOnFocus: true,
    allowBlank: true,
    anyMatch: true,
    typeAhead: false,
    triggerAction: 'all',
    lazyRender: true,
    valueField: 'deliveryLocId',
    displayField: 'deliveryCustomerName',
    //cls: 'selectstylePerfect',
    //width: 120,
    listeners: {
        select: {
            fn: function() {
         
       			}
            
           } 
        }
  });

var Panel = new Ext.Panel({
    standardSubmit: true,
    collapsible: false,
    id: 'customerMaster',
    layout: 'table',
    cls: 'innerpanelsmallest',
    frame: false,
    width: 50,
    width: screen.width - 80,
    layoutConfig: {
        columns: 12
    },
    items: [{
        width: 150
    }, {
        xtype: 'label',
        text: 'Select Route ' + ' :',
        cls: 'labelstyle',
        id: 'routeLblId'
    }, {
        width: 30
    }, routecombo, {
        width: 150
    }, {
        xtype: 'label',
        text: 'Date ' + ' :',
        width: 20,
        cls: 'labelstyle'
    }, {
        width: 30
    }, {
        xtype: 'datefield',
        cls: 'selectstylePerfect',
        minValue:new Date(),
        width: 185,
        format: getDateFormat(),
        emptyText: '',
        allowBlank: false,
        blankText: '',
        id: 'dateId',
        //value: datecur,
        startDateField: 'startdate'
    }]
});
var reader = new Ext.data.JsonReader({
    idProperty: 'tripcreationId',
    root: 'cashDespenseDetailsViewRoot',
    totalProperty: 'total',
    fields: [{
        name: 'UIDDI'
    }, {
        name: 'slnoIndex'
    }, {
        name: 'customerTypeDI'
    }, {
        name: 'customerNameDI'
    }, {
        name: 'customerIdDI'
    }, {
        name: 'atmIdDI'
    }, {
        name: 'locationDI'
    }, {
    	name: 'deliveryCustomerDI'
    }, {
    	name: 'cashDeliveryLocationDI'
    }, {
        name: 'accOfDI'
    }, {
        name: 'sealedBagCashDI'
    }, {
        name: 'sealNoDI'
    }, {
        name: 'denom5000DI'
    }, {
        name: 'denom2000DI'
    }, {
        name: 'denom1000DI'
    }, {
        name: 'denom500DI'
    }, {
        name: 'denom100DI'
    }, {
        name: 'denom50DI'
    }, {
        name: 'denom20DI'
    }, {
        name: 'denom10DI'
    }, {
        name: 'denom5DI'
    }, {
        name: 'denom2DI'
    }, {
        name: 'denom1DI'
    },{
        name: 'denom050DI'
    },{
        name: 'denom025DI'
    },{
        name: 'denom010DI'
    },{
        name: 'denom005DI'
    },{
        name: 'denom002DI'
    },{
        name: 'denom001DI'
    }, {
        name: 'totalSealAmntDI'
    }, {
        name: 'totalCashAmntDI'
    }, {
        name: 'totalAmntDI'
    },{
    	name: 'checkNoDI'
    },{
    	name: 'totalCheckAmntDI'
    },{
    	name: 'jewellaryNoDI'
    },{
    	name: 'foreignCurrencyDI'
    },{
    	name: 'totalJewellaryAmntDI'
    },{
    	name: 'totalForeignAmntDI'
    }]
});

var store = new Ext.data.GroupingStore({
    autoLoad: false,
    proxy: new Ext.data.HttpProxy({
        url: '<%=request.getContextPath()%>/cashDispenseAction.do?param=getCashDespenseViewDetail',
        method: 'POST'
    }),
    remoteSort: false,
    reader: reader
});

var filters = new Ext.ux.grid.GridFilters({
    local: true,
    filters: [{
        type: 'numeric',
        dataIndex: 'UIDDI'
    }, {
        type: 'numeric',
        dataIndex: 'slnoIndex'
    }, {
        type: 'string',
        dataIndex: 'customerTypeDI'
    }, {
        type: 'string',
        dataIndex: 'customerNameDI'
    }, {
		type: 'numeric',
		dataIndex: 'customerIdDI'    
    },  {
        type: 'string',
        dataIndex: 'atmIdDI'
    }, {
        type: 'string',
        dataIndex: 'locationDI'
    }, {
    	type: 'string',
    	dataIndex: 'deliveryCustomerDI'
    }, {
    	type: 'string',
    	dataIndex: 'cashDeliveryLocationDI'
    }, {
        type: 'string',
        dataIndex: 'accOfDI'
    }, {
        type: 'string',
        dataIndex: 'sealedBagCashDI'
    }, {
        type: 'string',
        dataIndex: 'sealNoDI'
    }, {
        type: 'numeric',
        dataIndex: 'denom5000DI'
    }, {
        type: 'numeric',
        dataIndex: 'denom2000DI'
    }, {
        type: 'numeric',
        dataIndex: 'denom1000DI'
    }, {
        type: 'numeric',
        dataIndex: 'denom500DI'
    }, {
        type: 'numeric',
        dataIndex: 'denom100DI'
    }, {
        type: 'numeric',
        dataIndex: 'denom50DI'
    }, {
        type: 'numeric',
        dataIndex: 'denom20DI'
    }, {
        type: 'numeric',
        dataIndex: 'denom10DI'
    }, {
        type: 'numeric',
        dataIndex: 'denom5DI'
    }, {
        type: 'numeric',
        dataIndex: 'denom2DI'
    }, {
        type: 'numeric',
        dataIndex: 'denom1DI'
    },  {
        type: 'numeric',
        dataIndex: 'denom050DI'
    }, {
        type: 'numeric',
        dataIndex: 'denom025DI'
    }, {
        type: 'numeric',
        dataIndex: 'denom010DI'
    }, {
        type: 'numeric',
        dataIndex: 'denom005DI'
    }, {
        type: 'numeric',
        dataIndex: 'denom002DI'
    }, {
        type: 'numeric',
        dataIndex: 'denom001DI'
    },{
        type: 'numeric',
        dataIndex: 'totalSealAmntDI'
    }, {
        type: 'numeric',
        dataIndex: 'totalCashAmntDI'
    }, {
        type: 'numeric',
        dataIndex: 'totalAmntDI'
    },{
        type: 'string',
        dataIndex: 'checkNoDI'
    },{
        type: 'numeric',
        dataIndex: 'totalCheckAmntDI'
    },{
        type: 'string',
        dataIndex: 'jewellaryNoDI'
    },{
        type: 'string',
        dataIndex: 'foreignCurrencyDI'
    },{
        type: 'numeric',
        dataIndex: 'totalJewellaryAmntDI'
    },{
        type: 'numeric',
        dataIndex: 'totalForeignAmntDI'
    }]
});
var sm = new Ext.grid.CheckboxSelectionModel({});
var createColModel = function(finish, start) {
    var columns = [
        new Ext.grid.RowNumberer({
            header: "<span style=font-weight:bold;>SNo</span>",
            width: 40
        }), sm, {
            dataIndex: 'UIDDI',
            hidden: true,
            header: "<span style=font-weight:bold;>UID</span>",
            filter: {
                type: 'int'
            }
        }, {
            dataIndex: 'slnoIndex',
            hidden: true,
            header: "<span style=font-weight:bold;>Sl No</span>",
            filter: {
                type: 'int'
            }
        }, {
            header: "<span style=font-weight:bold;>Business Type</span>",
            dataIndex: 'customerTypeDI',
            width: 150,
            sortable: true,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;>Customer Name</span>",
            dataIndex: 'customerNameDI',
            width: 140,
            filter: {
                type: 'string'
            }
        },{
        	header: "<span style=font-weight:bold;>Customer Id</span>",
            dataIndex: 'customerIdDI',
            width: 140,
            filter: {
                type: 'int'
            },
            hidden: true
        }, {
            header: "<span style=font-weight:bold;>Business ID</span>",
            dataIndex: 'atmIdDI',
            width: 130,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;>Location</span>",
            dataIndex: 'locationDI',
            width: 130,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;>Delivery Customer Name</span>",
            dataIndex: 'deliveryCustomerDI',
            width: 150,
            filter: {
                type: 'string'
            },
            editor: new Ext.grid.GridEditor(DeliveryCustomerIdCombo),
            renderer: deliveryCustomerRenderer
        }, {
            header: "<span style=font-weight:bold;>Cash Delivery Location</span>",
            dataIndex: 'cashDeliveryLocationDI',
            width: 150,
            filter: {
                type: 'string'
            },
             editor: new Ext.grid.GridEditor(deliveryLocIdCombo),
             renderer: deliveryLocationRenderer
             
        }, {
            header: "<span style=font-weight:bold;>On Account Of</span>",
            dataIndex: 'accOfDI',
            width: 150,
            filter: {
                type: 'string'
            },
            editor: new Ext.grid.GridEditor(onAccCombo),
            renderer: onAccOfRenderer
        }, {
            header: "<span style=font-weight:bold;>Sealed Bag or Cash</span>",
            dataIndex: 'sealedBagCashDI',
            width: 150,
            filter: {
                type: 'string'
            },
            editor: new Ext.grid.GridEditor(sealedOrCashCombo)
        }, {
            header: "<span style=font-weight:bold;>Seal No</span>",
            dataIndex: 'sealNoDI',
            width: 100,
            filter: {
                type: 'string'
            },
            editor: new Ext.grid.GridEditor(sealNoComboMultiSelect)
        }, {
            header: "<span style=font-weight:bold;>Cheque No</span>",
            dataIndex: 'checkNoDI',
            width: 100,
            filter: {
                type: 'string'
            },
            editor: new Ext.grid.GridEditor(checkNoComboMultiSelect)
        },{
            header: "<span style=font-weight:bold;>Jewellary No</span>",
            dataIndex: 'jewellaryNoDI',
            width: 100,
            filter: {
                type: 'string'
            },
            editor: new Ext.grid.GridEditor(jewellaryComboMultiSelect)
        },{
            header: "<span style=font-weight:bold;>Foreign Currency</span>",
            dataIndex: 'foreignCurrencyDI',
            width: 100,
            filter: {
                type: 'string'
            },
            editor: new Ext.grid.GridEditor(fireignComboMultiSelect)
        }, {
            header: "<span style=font-weight:bold;>5000</span>",
            dataIndex: 'denom5000DI',
            width: 80,
            filter: {
                type: 'float'
            },
            editor: new Ext.grid.GridEditor(new Ext.form.NumberField({
                allowBlank: false,
                allowNegative: false,
                decimalPrecision: 0
            }))
        }, {
            header: "<span style=font-weight:bold;>2000</span>",
            dataIndex: 'denom2000DI',
            width: 80,
            filter: {
                type: 'float'
            },
            editor: new Ext.grid.GridEditor(new Ext.form.NumberField({
                allowBlank: false,
                allowNegative: false,
                decimalPrecision: 0
            }))
        }, {
            header: "<span style=font-weight:bold;>1000</span>",
            dataIndex: 'denom1000DI',
            width: 80,
            filter: {
                type: 'float'
            },
            editor: new Ext.grid.GridEditor(new Ext.form.NumberField({
                allowBlank: false,
                allowNegative: false,
                decimalPrecision: 0
            }))
        }, {
            header: "<span style=font-weight:bold;>500</span>",
            dataIndex: 'denom500DI',
            width: 80,
            filter: {
                type: 'float'
            },
            editor: new Ext.grid.GridEditor(new Ext.form.NumberField({
                allowBlank: false,
                allowNegative: false,
                decimalPrecision: 0
            }))
        }, {
            header: "<span style=font-weight:bold;>100</span>",
            dataIndex: 'denom100DI',
            width: 80,
            filter: {
                type: 'float'
            },
            editor: new Ext.grid.GridEditor(new Ext.form.NumberField({
                allowBlank: false,
                allowNegative: false,
                decimalPrecision: 0
            }))
        }, {
            header: "<span style=font-weight:bold;>50</span>",
            dataIndex: 'denom50DI',
            width: 80,
            filter: {
                type: 'float'
            },
            editor: new Ext.grid.GridEditor(new Ext.form.NumberField({
                allowBlank: false,
                allowNegative: false,
                decimalPrecision: 0
            }))
        }, {
            header: "<span style=font-weight:bold;>20</span>",
            dataIndex: 'denom20DI',
            width: 80,
            filter: {
                type: 'float'
            },
            editor: new Ext.grid.GridEditor(new Ext.form.NumberField({
                allowBlank: false,
                allowNegative: false,
                decimalPrecision: 0
            }))
        }, {
            header: "<span style=font-weight:bold;>10</span>",
            dataIndex: 'denom10DI',
            width: 80,
            filter: {
                type: 'float'
            },
            editor: new Ext.grid.GridEditor(new Ext.form.NumberField({
                allowBlank: false,
                allowNegative: false,
                decimalPrecision: 0
            }))
        }, {
            header: "<span style=font-weight:bold;>5</span>",
            dataIndex: 'denom5DI',
            width: 80,
            filter: {
                type: 'float'
            },
            editor: new Ext.grid.GridEditor(new Ext.form.NumberField({
                allowBlank: false,
                allowNegative: false,
                decimalPrecision: 0
            }))
        }, {
            header: "<span style=font-weight:bold;>2</span>",
            dataIndex: 'denom2DI',
            width: 50,
            filter: {
                type: 'float'
            },
            editor: new Ext.grid.GridEditor(new Ext.form.NumberField({
                allowBlank: false,
                allowNegative: false,
                decimalPrecision: 0
            }))
        }, {
            header: "<span style=font-weight:bold;>1</span>",
            dataIndex: 'denom1DI',
            width: 50,
            filter: {
                type: 'float'
            },
            editor: new Ext.grid.GridEditor(new Ext.form.NumberField({
                allowBlank: false,
                allowNegative: false,
                decimalPrecision: 0
            }))
        },
		{
            header: "<span style=font-weight:bold;>0.50</span>",
            dataIndex: 'denom050DI',
            width: 50,
            filter: {
                type: 'float'
            },
            editor: new Ext.grid.GridEditor(new Ext.form.NumberField({
                allowBlank: false,
                allowNegative: false,
                decimalPrecision: 0
            }))
        },
        {
            header: "<span style=font-weight:bold;>0.25</span>",
            dataIndex: 'denom025DI',
            width: 50,
            filter: {
                type: 'float'
            },
            editor: new Ext.grid.GridEditor(new Ext.form.NumberField({
                allowBlank: false,
                allowNegative: false,
                decimalPrecision: 0
            }))
        },{
            header: "<span style=font-weight:bold;>0.10</span>",
            dataIndex: 'denom010DI',
            width: 50,
            autoSizeColumn:true,
            filter: {
                type: 'float'
            },
            editor: new Ext.grid.GridEditor(new Ext.form.NumberField({
                allowBlank: false,
                allowNegative: false,
                decimalPrecision: 0
            }))
        },
        {
            header: "<span style=font-weight:bold;>0.05</span>",
            dataIndex: 'denom005DI',
            width: 80,
            autoSizeColumn:true,
            filter: {
                type: 'float'
            },
            editor: new Ext.grid.GridEditor(new Ext.form.NumberField({
                allowBlank: false,
                allowNegative: false,
                decimalPrecision: 0
            }))
        },{
            header: "<span style=font-weight:bold;>0.02</span>",
            dataIndex: 'denom002DI',
            width: 80,
            autoSizeColumn:true,
            filter: {
                type: 'float'
            },
            editor: new Ext.grid.GridEditor(new Ext.form.NumberField({
                allowBlank: false,
                allowNegative: false,
                decimalPrecision: 0
            }))
        },{
            header: "<span style=font-weight:bold;>0.01</span>",
            dataIndex: 'denom001DI',
            width: 80,
            autoSizeColumn:true,
            filter: {
                type: 'float'
            },
            editor: new Ext.grid.GridEditor(new Ext.form.NumberField({
                allowBlank: false,
                allowNegative: false,
                decimalPrecision: 0
            }))
        },
{
            header: "<span style=font-weight:bold;>Total Cash Amount</span>",
            dataIndex: 'totalCashAmntDI',
            width: 100,
            autoSizeColumn:true,
            filter: {
                type: 'float'
            },
            hidden: false
        }, {
            header: "<span style=font-weight:bold;>Total Seal Amount</span>",
            dataIndex: 'totalSealAmntDI',
            width: 100,
            autoSizeColumn:true,
            filter: {
                type: 'float'
            },
            hidden: false
        }, {
            header: "<span style=font-weight:bold;>Total Cheque Amount</span>",
            dataIndex: 'totalCheckAmntDI',
            width: 130,
            autoSizeColumn:true,
            filter: {
                type: 'float'
            },
            hidden: false
        },{
            header: "<span style=font-weight:bold;>Total Jewellary Amount</span>",
            dataIndex: 'totalJewellaryAmntDI',
            width: 130,
            autoSizeColumn:true,
            filter: {
                type: 'float'
            },
            hidden: false
        },{
            header: "<span style=font-weight:bold;>Total Foreign Currency Amount</span>",
            dataIndex: 'totalForeignAmntDI',
            width: 130,
            autoSizeColumn:true,
            filter: {
                type: 'float'
            },
            hidden: false
        }, {
            header: "<span style=font-weight:bold;>Total Amount</span>",
            dataIndex: 'totalAmntDI',
            autoSizeColumn:true,
            width: 130,
            filter: {
                type: 'float'
            },
            hidden: true
        }
    ];
    return new Ext.grid.ColumnModel({
        columns: columns.slice(start || 0, finish),
        defaults: {
            sortable: true
        }
    });
};

grid = getSelectionModelEditorGridCashVan('', 'No Records Found', store, 1280, 380, 40, filters, 'Clear Filter Data', false, '', 40, false, '', false, '', false, 'Excel', jspName, exportDataType, false, 'PDF', true, 'Save Trip Sheet', false, 'Cancel', true, 'Refresh', sm);

function addRecord() {
    var selected = grid.getSelectionModel().getSelected();
    if (selected == undefined || selected == "undefined") {
        Ext.example.msg("Please select one row");
        return false;
    }
    if('<%=btnValue%>' == "Create"){
        if (Ext.getCmp('routecomboId').getValue() == "") {
        	Ext.example.msg("Please select Route Name");
        	Ext.getCmp('routecomboId').focus();
        	return false;
    	}
    	if (Ext.getCmp('dateId').getValue() == "") {
        	Ext.example.msg("Please select Date");
        	Ext.getCmp('dateId').focus();
        	return false;
    	}
    	var date = Ext.getCmp('dateId').getRawValue();
    	var dateTemp = new Date();
    	dateTemp.setDate(dateTemp.getDate() - 1);
    	//var dateTemp = new Date('DD-MM-YYYY');
    	//var day = dateTemp.getDate();
    	var day = ('0' + dateTemp.getDate()).slice(-2);
    	var month = dateTemp.getMonth()+1;
    	if(month < 9){
    		month = "0"+month;
    	}
    	var year = dateTemp.getFullYear();
        var currentDate = day+'-'+month+'-'+year;
    	//var currentDate =  new Date() ; //t4u506
    	
    	var dat = new Date('DD-MM-YYYY'); //t4u506 
    	
    	 dat = document.getElementById('dateId').value;
    	//dat = day+'-'+month+'-'+year;
    	console.log("Date is " +document.getElementById('dateId').value);
    	console.log("Date conv is " +dat);
    	console.log("Current date " +currentDate);
     	//if(DateCompare3(currentDate,document.getElementById('dateId').value) == false){
    	//if(DateCompare3(currentDate,dat) == false){
    	if (currentDate  > dat ) {  //t4u506
    		Ext.example.msg("Selected date cannot be less than current date");
        	Ext.getCmp('dateId').focus();
       		return false;
    	}
    }

    var json = '';
    var record = grid.getSelectionModel().getSelections();
    for (var i = 0, len = record.length; i < len; i++) {
        var row = record[i];
        if (row.data['customerTypeDI'] == "ATM Replenishment") {
            if (row.data['totalCashAmntDI'] == 0 || row.data['totalCashAmntDI'] == "") {
                Ext.example.msg("Please enter at least one note value");
                return false;
            }
        }
        if (row.data['customerTypeDI'] == "Cash Delivery") {
            if (row.data['accOfDI'] == "" || row.data['accOfDI'] == "0") {
                Ext.example.msg("Please select On Account of");
                return false;
            }
            if (row.data['sealedBagCashDI'] == "") {
            	Ext.example.msg("Please select Sealed Bag or Cash");
            	return false;
        	}
        	if (row.data['sealedBagCashDI'].includes("Sealed Bag")) {
	            if (row.data['sealNoDI'] == "" || row.data['sealNoDI'] == "0") {
	                Ext.example.msg("Please select Seal No");
	                return false;
	            }
        	}
        	if (row.data['sealedBagCashDI'].includes("Cash")) {
	            if (row.data['totalCashAmntDI'] == 0 || row.data['totalCashAmntDI'] == "") {
	                Ext.example.msg("Please enter at least one note value");
	                return false;
	            }
        	}
        	if (row.data['sealedBagCashDI'].includes("Cheque")) {
	            if (row.data['totalCheckAmntDI'] == "0" || row.data['totalCheckAmntDI'] == "") {
	                Ext.example.msg("Please select cheque number");
	                return false;
	            }
        	}
        	if (row.data['sealedBagCashDI'].includes("Jewellery")) {
	            if (row.data['totalJewellaryAmntDI'] == "0" || row.data['totalJewellaryAmntDI'] == "") {
	                Ext.example.msg("Please select jewellery ref number");
	                return false;
	            }
        	}
        	if (row.data['sealedBagCashDI'].includes("Foreign Currency")) {
	            if (row.data['totalForeignAmntDI'] == "0" || row.data['totalForeignAmntDI'] == "") {
	                Ext.example.msg("Please select foreign currency ref number");
	                return false;
	            }
        	}
        }
        if (row.data['customerTypeDI'] == "Cash Transfer") {
	            if (row.data['deliveryCustomerDI'] == 0 || row.data['deliveryCustomerDI'] == "") {
	                Ext.example.msg("Please select delivery customer name");
	                return false;
	            }
	            if (row.data['cashDeliveryLocationDI'] == 0 || row.data['cashDeliveryLocationDI'] == "") {
	                Ext.example.msg("Please select cash dilivery location");
	                return false;
	            }
        	}
        
        json += Ext.util.JSON.encode(row.data) + ',';
    }
    if (json != '') {
        json = json.substring(0, json.length - 1);
    }
    Ext.MessageBox.confirm('Confirm', "Please make sure that all the records which are dispensing are marked. Continue...?", function(btn) {
    	if (btn == 'yes') {
	    Ext.MessageBox.show({
	        title: 'Please wait',
	        msg: 'Closing...',
	        progressText: 'Closing...',
	        width: 300,
	        progress: true,
	        closable: false
	});
	var routeId ;
	if('<%=btnValue%>' == "Modify"){
    	routeId = '<%=routeId%>';
    }else if('<%=btnValue%>' == "Create"){
        routeId =  Ext.getCmp('routecomboId').getValue();
    }
    outerPanel.getEl().mask();
    Ext.Ajax.request({
        url: '<%=request.getContextPath()%>/cashDispenseAction.do?param=saveCashDispense',
        method: 'POST',
        params: {
            json: json,
            routeId: routeId,
            date: Ext.getCmp('dateId').getValue(),
            btnValue: '<%=btnValue%>',
            tripSheetNo: '<%=tripSheetNo%>',
        },
        success: function(response, options) { 
        var msg = response.responseText;
        	if(msg.trim() == "Success"){
        		parent.Ext.example.msg("Cash Dispensed Successfuly...");
        		parent.store.load();
            	parent.myWin1.close();
            	outerPanel.getEl().unmask();
            	json = "";
        	}else if(msg.trim() == "Success1"){
        		parent.Ext.example.msg("Cash Dispense updated successfuly...");
        		parent.store.load();
            	parent.myWin1.close();
            	outerPanel.getEl().unmask();
                json = "";
        	}else{
        		Ext.example.msg(response.responseText);
            	outerPanel.getEl().unmask();
            	json = "";
        	}
        },
        failure: function() {
            outerPanel.getEl().unmask();
            parent.store.reload();
            parent.myWin1.close();
            json = "";
        }
    });
    Ext.MessageBox.hide();
    }
    });
}

function deleteData() {
    grid.store.reload();
}

function onAccOfRenderer(value, p, r) {
    var returnValue = "";
    if (onAccstore.isFiltered()) {
        onAccstore.clearFilter();
    }
    var idx = onAccstore.findBy(function(record) {
        if (record.get('CustomerId') == value) {
            returnValue = record.get('CustomerName');
            return true;
        }
    });
    //r.data['consigneeStr']=returnValue;
    return returnValue;
}

function deliveryCustomerRenderer(value, p, r) {
    var returnValue = "";
    if (deliverycustomerStore.isFiltered()) {
        deliverycustomerStore.clearFilter();
    }
    var idx = deliverycustomerStore.findBy(function(record) {
        if (record.get('destCustomerId') == value) {
            returnValue = record.get('destCustomerName');
            return true;
        }
    });
    //r.data['consigneeStr']=returnValue;
    return returnValue;
}

function deliveryLocationRenderer(value, p, r) {
    var returnValue = "";
    if (deliveryLocationStore.isFiltered()) {
        deliveryLocationStore.clearFilter();
    }
    var idx = deliveryLocationStore.findBy(function(record) {
        if (record.get('deliveryLocId') == value) {
            returnValue = record.get('deliveryCustomerName');
            return true;
        }
    });
    //r.data['consigneeStr']=returnValue;
    return returnValue;
}

grid.on({
	afteredit: function(e) {
        var field = e.field;
        var slno = e.record.data['slnoIndex'];
        var total = (e.record.data['denom5000DI'] * 5000) + (e.record.data['denom2000DI'] * 2000) + (e.record.data['denom1000DI'] * 1000) + (e.record.data['denom500DI'] * 500) + (e.record.data['denom100DI'] * 100) +
            (e.record.data['denom50DI'] * 50) + (e.record.data['denom20DI'] * 20) + (e.record.data['denom10DI'] * 10) + (e.record.data['denom5DI'] * 5) + (e.record.data['denom2DI'] * 2) + (e.record.data['denom1DI'])+ (e.record.data['denom050DI'])+ (e.record.data['denom025DI'])+ (e.record.data['denom010DI'])+ (e.record.data['denom005DI'])+ (e.record.data['denom002DI'])+ (e.record.data['denom001DI']);
        e.record.set("totalCashAmntDI", total);
        setTimeout(function(){e.record.set("totalAmntDI", ((e.record.data['totalSealAmntDI'] + e.record.data['totalCashAmntDI'])+(e.record.data['totalCheckAmntDI'] + e.record.data['totalJewellaryAmntDI'])+(e.record.data['totalForeignAmntDI'])));},1000)
        temp = editedRows.split(",")
        isIn = 0
        for (var i = 0; i < temp.length; i++) {

            if (temp[i] == slno) {
                isIn = 1
            }
        }
        if (isIn == 0) {
            editedRows = editedRows + slno + ",";
        }
    }
});

function onCellClick(grid, rowIndex, columnIndex, e) {
	var r = grid.store.getAt(rowIndex);
	if(r.data['customerTypeDI'] == "Cash pickup" || r.data['customerTypeDI'] == "ATM Deposit"){
    	grid.getColumnModel().config[columnIndex].editable = false;
   	}
   	if(r.data['customerTypeDI'] == "ATM Replenishment"){
   		if(columnIndex == grid.getColumnModel().findColumnIndex('denom5000DI') || columnIndex == grid.getColumnModel().findColumnIndex('denom1000DI')
   			|| columnIndex == grid.getColumnModel().findColumnIndex('denom500DI') || columnIndex == grid.getColumnModel().findColumnIndex('denom100DI') || columnIndex == grid.getColumnModel().findColumnIndex('denom50DI')
   			|| columnIndex == grid.getColumnModel().findColumnIndex('denom20DI') || columnIndex == grid.getColumnModel().findColumnIndex('denom10DI') || columnIndex == grid.getColumnModel().findColumnIndex('denom5DI')
   			|| columnIndex == grid.getColumnModel().findColumnIndex('denom2DI') || columnIndex == grid.getColumnModel().findColumnIndex('denom1DI')|| columnIndex == grid.getColumnModel().findColumnIndex('denom050DI')|| columnIndex == grid.getColumnModel().findColumnIndex('denom025DI')|| columnIndex == grid.getColumnModel().findColumnIndex('denom010DI')|| columnIndex == grid.getColumnModel().findColumnIndex('denom005DI')|| columnIndex == grid.getColumnModel().findColumnIndex('denom002DI')|| columnIndex == grid.getColumnModel().findColumnIndex('denom001DI')){
   			grid.getColumnModel().config[columnIndex].editable = true;
   		}else{
   			grid.getColumnModel().config[columnIndex].editable = false;
   		}
   	}
   	if(r.data['customerTypeDI'] == "Cash Delivery"){
   		grid.getColumnModel().config[grid.getColumnModel().findColumnIndex('accOfDI')].editable = true;
   		grid.getColumnModel().config[grid.getColumnModel().findColumnIndex('sealedBagCashDI')].editable = true;
   		grid.getColumnModel().config[grid.getColumnModel().findColumnIndex('deliveryCustomerDI')].editable = false;
   		grid.getColumnModel().config[grid.getColumnModel().findColumnIndex('cashDeliveryLocationDI')].editable = false;
   		if(r.data['sealedBagCashDI'] == "Cash"){
   			grid.getColumnModel().config[grid.getColumnModel().findColumnIndex('sealNoDI')].editable = false;
   			grid.getColumnModel().config[grid.getColumnModel().findColumnIndex('checkNoDI')].editable = false;
   			grid.getColumnModel().config[grid.getColumnModel().findColumnIndex('jewellaryNoDI')].editable = false;
   			grid.getColumnModel().config[grid.getColumnModel().findColumnIndex('foreignCurrencyDI')].editable = false;
   			grid.getColumnModel().config[grid.getColumnModel().findColumnIndex('denom5000DI')].editable = true;
   			grid.getColumnModel().config[grid.getColumnModel().findColumnIndex('denom2000DI')].editable = true;
   			grid.getColumnModel().config[grid.getColumnModel().findColumnIndex('denom1000DI')].editable = true;
   			grid.getColumnModel().config[grid.getColumnModel().findColumnIndex('denom500DI')].editable = true;
   			grid.getColumnModel().config[grid.getColumnModel().findColumnIndex('denom100DI')].editable = true;
   			grid.getColumnModel().config[grid.getColumnModel().findColumnIndex('denom50DI')].editable = true;
   			grid.getColumnModel().config[grid.getColumnModel().findColumnIndex('denom20DI')].editable = true;
   			grid.getColumnModel().config[grid.getColumnModel().findColumnIndex('denom10DI')].editable = true;
   			grid.getColumnModel().config[grid.getColumnModel().findColumnIndex('denom5DI')].editable = true;
   			grid.getColumnModel().config[grid.getColumnModel().findColumnIndex('denom2DI')].editable = true;
   			grid.getColumnModel().config[grid.getColumnModel().findColumnIndex('denom1DI')].editable = true;
   			grid.getColumnModel().config[grid.getColumnModel().findColumnIndex('denom050DI')].editable = true;
   			grid.getColumnModel().config[grid.getColumnModel().findColumnIndex('denom025DI')].editable = true;
   			grid.getColumnModel().config[grid.getColumnModel().findColumnIndex('denom010DI')].editable = true;
   			grid.getColumnModel().config[grid.getColumnModel().findColumnIndex('denom005DI')].editable = true;
   			grid.getColumnModel().config[grid.getColumnModel().findColumnIndex('denom002DI')].editable = true;
   			grid.getColumnModel().config[grid.getColumnModel().findColumnIndex('denom001DI')].editable = true;
   		}else if(r.data['sealedBagCashDI'] == "Sealed Bag"){
   			grid.getColumnModel().config[grid.getColumnModel().findColumnIndex('sealNoDI')].editable = true;
   			grid.getColumnModel().config[grid.getColumnModel().findColumnIndex('checkNoDI')].editable = false;
   			grid.getColumnModel().config[grid.getColumnModel().findColumnIndex('jewellaryNoDI')].editable = false;
   			grid.getColumnModel().config[grid.getColumnModel().findColumnIndex('foreignCurrencyDI')].editable = false;
   			grid.getColumnModel().config[grid.getColumnModel().findColumnIndex('denom5000DI')].editable = false;
   			grid.getColumnModel().config[grid.getColumnModel().findColumnIndex('denom2000DI')].editable = false;
   			grid.getColumnModel().config[grid.getColumnModel().findColumnIndex('denom1000DI')].editable = false;
   			grid.getColumnModel().config[grid.getColumnModel().findColumnIndex('denom500DI')].editable = false;
   			grid.getColumnModel().config[grid.getColumnModel().findColumnIndex('denom100DI')].editable = false;
   			grid.getColumnModel().config[grid.getColumnModel().findColumnIndex('denom50DI')].editable = false;
   			grid.getColumnModel().config[grid.getColumnModel().findColumnIndex('denom20DI')].editable = false;
   			grid.getColumnModel().config[grid.getColumnModel().findColumnIndex('denom10DI')].editable = false;
   			grid.getColumnModel().config[grid.getColumnModel().findColumnIndex('denom5DI')].editable = false;
   			grid.getColumnModel().config[grid.getColumnModel().findColumnIndex('denom2DI')].editable = false;
   			grid.getColumnModel().config[grid.getColumnModel().findColumnIndex('denom1DI')].editable = false;
   			grid.getColumnModel().config[grid.getColumnModel().findColumnIndex('denom050DI')].editable = false;
   			grid.getColumnModel().config[grid.getColumnModel().findColumnIndex('denom025DI')].editable = false;
   			grid.getColumnModel().config[grid.getColumnModel().findColumnIndex('denom010DI')].editable = false;
   			grid.getColumnModel().config[grid.getColumnModel().findColumnIndex('denom005DI')].editable = false;
   			grid.getColumnModel().config[grid.getColumnModel().findColumnIndex('denom002DI')].editable = false;
   			grid.getColumnModel().config[grid.getColumnModel().findColumnIndex('denom001DI')].editable = false;
   		}else if(r.data['sealedBagCashDI'] == "Cheque"){
   			grid.getColumnModel().config[grid.getColumnModel().findColumnIndex('sealNoDI')].editable = false;
   			grid.getColumnModel().config[grid.getColumnModel().findColumnIndex('checkNoDI')].editable = true;
   			grid.getColumnModel().config[grid.getColumnModel().findColumnIndex('jewellaryNoDI')].editable = false;
   			grid.getColumnModel().config[grid.getColumnModel().findColumnIndex('foreignCurrencyDI')].editable = false;
   			grid.getColumnModel().config[grid.getColumnModel().findColumnIndex('denom5000DI')].editable = false;
   			grid.getColumnModel().config[grid.getColumnModel().findColumnIndex('denom2000DI')].editable = false;
   			grid.getColumnModel().config[grid.getColumnModel().findColumnIndex('denom1000DI')].editable = false;
   			grid.getColumnModel().config[grid.getColumnModel().findColumnIndex('denom500DI')].editable = false;
   			grid.getColumnModel().config[grid.getColumnModel().findColumnIndex('denom100DI')].editable = false;
   			grid.getColumnModel().config[grid.getColumnModel().findColumnIndex('denom50DI')].editable = false;
   			grid.getColumnModel().config[grid.getColumnModel().findColumnIndex('denom20DI')].editable = false;
   			grid.getColumnModel().config[grid.getColumnModel().findColumnIndex('denom10DI')].editable = false;
   			grid.getColumnModel().config[grid.getColumnModel().findColumnIndex('denom5DI')].editable = false;
   			grid.getColumnModel().config[grid.getColumnModel().findColumnIndex('denom2DI')].editable = false;
   			grid.getColumnModel().config[grid.getColumnModel().findColumnIndex('denom1DI')].editable = false;
   			grid.getColumnModel().config[grid.getColumnModel().findColumnIndex('denom050DI')].editable = false;
   			grid.getColumnModel().config[grid.getColumnModel().findColumnIndex('denom025DI')].editable = false;
   			grid.getColumnModel().config[grid.getColumnModel().findColumnIndex('denom010DI')].editable = false;
   			grid.getColumnModel().config[grid.getColumnModel().findColumnIndex('denom005DI')].editable = false;
   			grid.getColumnModel().config[grid.getColumnModel().findColumnIndex('denom002DI')].editable = false;
   			grid.getColumnModel().config[grid.getColumnModel().findColumnIndex('denom001DI')].editable = false;
   		}else if(r.data['sealedBagCashDI'] == "Jewellery"){
   			grid.getColumnModel().config[grid.getColumnModel().findColumnIndex('sealNoDI')].editable = false;
   			grid.getColumnModel().config[grid.getColumnModel().findColumnIndex('checkNoDI')].editable = false;
   			grid.getColumnModel().config[grid.getColumnModel().findColumnIndex('jewellaryNoDI')].editable = true;
   			grid.getColumnModel().config[grid.getColumnModel().findColumnIndex('foreignCurrencyDI')].editable = false;
   			grid.getColumnModel().config[grid.getColumnModel().findColumnIndex('denom5000DI')].editable = false;
   			grid.getColumnModel().config[grid.getColumnModel().findColumnIndex('denom2000DI')].editable = false;
   			grid.getColumnModel().config[grid.getColumnModel().findColumnIndex('denom1000DI')].editable = false;
   			grid.getColumnModel().config[grid.getColumnModel().findColumnIndex('denom500DI')].editable = false;
   			grid.getColumnModel().config[grid.getColumnModel().findColumnIndex('denom100DI')].editable = false;
   			grid.getColumnModel().config[grid.getColumnModel().findColumnIndex('denom50DI')].editable = false;
   			grid.getColumnModel().config[grid.getColumnModel().findColumnIndex('denom20DI')].editable = false;
   			grid.getColumnModel().config[grid.getColumnModel().findColumnIndex('denom10DI')].editable = false;
   			grid.getColumnModel().config[grid.getColumnModel().findColumnIndex('denom5DI')].editable = false;
   			grid.getColumnModel().config[grid.getColumnModel().findColumnIndex('denom2DI')].editable = false;
   			grid.getColumnModel().config[grid.getColumnModel().findColumnIndex('denom1DI')].editable = false;
   			grid.getColumnModel().config[grid.getColumnModel().findColumnIndex('denom050DI')].editable = false;
   			grid.getColumnModel().config[grid.getColumnModel().findColumnIndex('denom025DI')].editable = false;
   			grid.getColumnModel().config[grid.getColumnModel().findColumnIndex('denom010DI')].editable = false;
   			grid.getColumnModel().config[grid.getColumnModel().findColumnIndex('denom005DI')].editable = false;
   			grid.getColumnModel().config[grid.getColumnModel().findColumnIndex('denom002DI')].editable = false;
   			grid.getColumnModel().config[grid.getColumnModel().findColumnIndex('denom001DI')].editable = false;
   		}else if(r.data['sealedBagCashDI'] == "Foreign Currency"){
   			grid.getColumnModel().config[grid.getColumnModel().findColumnIndex('sealNoDI')].editable = false;
   			grid.getColumnModel().config[grid.getColumnModel().findColumnIndex('checkNoDI')].editable = false;
   			grid.getColumnModel().config[grid.getColumnModel().findColumnIndex('jewellaryNoDI')].editable = false;
   			grid.getColumnModel().config[grid.getColumnModel().findColumnIndex('foreignCurrencyDI')].editable = true;
   			grid.getColumnModel().config[grid.getColumnModel().findColumnIndex('denom5000DI')].editable = false;
   			grid.getColumnModel().config[grid.getColumnModel().findColumnIndex('denom2000DI')].editable = false;
   			grid.getColumnModel().config[grid.getColumnModel().findColumnIndex('denom1000DI')].editable = false;
   			grid.getColumnModel().config[grid.getColumnModel().findColumnIndex('denom500DI')].editable = false;
   			grid.getColumnModel().config[grid.getColumnModel().findColumnIndex('denom100DI')].editable = false;
   			grid.getColumnModel().config[grid.getColumnModel().findColumnIndex('denom50DI')].editable = false;
   			grid.getColumnModel().config[grid.getColumnModel().findColumnIndex('denom20DI')].editable = false;
   			grid.getColumnModel().config[grid.getColumnModel().findColumnIndex('denom10DI')].editable = false;
   			grid.getColumnModel().config[grid.getColumnModel().findColumnIndex('denom5DI')].editable = false;
   			grid.getColumnModel().config[grid.getColumnModel().findColumnIndex('denom2DI')].editable = false;
   			grid.getColumnModel().config[grid.getColumnModel().findColumnIndex('denom1DI')].editable = false;
   			grid.getColumnModel().config[grid.getColumnModel().findColumnIndex('denom050DI')].editable = false;
   			grid.getColumnModel().config[grid.getColumnModel().findColumnIndex('denom025DI')].editable = false;
   			grid.getColumnModel().config[grid.getColumnModel().findColumnIndex('denom010DI')].editable = false;
   			grid.getColumnModel().config[grid.getColumnModel().findColumnIndex('denom005DI')].editable = false;
   			grid.getColumnModel().config[grid.getColumnModel().findColumnIndex('denom002DI')].editable = false;
   			grid.getColumnModel().config[grid.getColumnModel().findColumnIndex('denom001DI')].editable = false;
   		}else{
   			grid.getColumnModel().config[grid.getColumnModel().findColumnIndex('sealNoDI')].editable = true;
   			grid.getColumnModel().config[grid.getColumnModel().findColumnIndex('checkNoDI')].editable = true;
   			grid.getColumnModel().config[grid.getColumnModel().findColumnIndex('jewellaryNoDI')].editable = true;
   			grid.getColumnModel().config[grid.getColumnModel().findColumnIndex('foreignCurrencyDI')].editable = true;
   			grid.getColumnModel().config[grid.getColumnModel().findColumnIndex('denom5000DI')].editable = true;
   			grid.getColumnModel().config[grid.getColumnModel().findColumnIndex('denom2000DI')].editable = true;
   			grid.getColumnModel().config[grid.getColumnModel().findColumnIndex('denom1000DI')].editable = true;
   			grid.getColumnModel().config[grid.getColumnModel().findColumnIndex('denom500DI')].editable = true;
   			grid.getColumnModel().config[grid.getColumnModel().findColumnIndex('denom100DI')].editable = true;
   			grid.getColumnModel().config[grid.getColumnModel().findColumnIndex('denom50DI')].editable = true;
   			grid.getColumnModel().config[grid.getColumnModel().findColumnIndex('denom20DI')].editable = true;
   			grid.getColumnModel().config[grid.getColumnModel().findColumnIndex('denom10DI')].editable = true;
   			grid.getColumnModel().config[grid.getColumnModel().findColumnIndex('denom5DI')].editable = true;
   			grid.getColumnModel().config[grid.getColumnModel().findColumnIndex('denom2DI')].editable = true;
   			grid.getColumnModel().config[grid.getColumnModel().findColumnIndex('denom1DI')].editable = true;
   			grid.getColumnModel().config[grid.getColumnModel().findColumnIndex('denom050DI')].editable = true;
   			grid.getColumnModel().config[grid.getColumnModel().findColumnIndex('denom025DI')].editable = true;
   			grid.getColumnModel().config[grid.getColumnModel().findColumnIndex('denom010DI')].editable = true;
   			grid.getColumnModel().config[grid.getColumnModel().findColumnIndex('denom005DI')].editable = true;
   			grid.getColumnModel().config[grid.getColumnModel().findColumnIndex('denom002DI')].editable = true;
   			grid.getColumnModel().config[grid.getColumnModel().findColumnIndex('denom001DI')].editable = true;
   		}
   	}
   if(r.data['customerTypeDI'] == "Cash Transfer"){
   	if(columnIndex == grid.getColumnModel().findColumnIndex('deliveryCustomerDI') || columnIndex == grid.getColumnModel().findColumnIndex('cashDeliveryLocationDI')){
   			grid.getColumnModel().config[columnIndex].editable = true;
   		}else{
   			grid.getColumnModel().config[columnIndex].editable = false;
   		}
   	}
}
var UGrid = function() {
    return {
        init: function() {
            grid.on({
                "cellclick": {
                    fn: onCellClick
                }
            });
        },
        getDS: function() {
            return store;
        }
    } // END OF RETURN
}(); // END OF UGrid

Ext.onReady(UGrid.init, UGrid, true);

Ext.onReady(function() {
    Ext.QuickTips.init();
    Ext.form.Field.prototype.msgTarget = 'side';
    outerPanel = new Ext.Panel({
        //title: 'Create Dispense',
        renderTo: 'content',
        standardSubmit: true,
        frame: true,
        cls: 'outerpanel',
        height: 430,
        width: screen.width - 70,
        items: [Panel, grid]
    });
    if('<%=btnValue%>' == "Modify"){
    	Ext.getCmp('routecomboId').disable();
    	Ext.getCmp('dateId').disable();
    	Ext.getCmp('routecomboId').setValue('<%=routeName%>');
    	Ext.getCmp('dateId').setValue('<%=date%>');
    	
    	deliveryLocationStore.load({
						params:{
						customerId: '<%=deliveryCustomerId%>'
						}
					});
					
    	store.load({
    	params:{
    		tripSheetNo: '<%=tripSheetNo%>',
    		routeId: '<%=routeId%>',
    		date: '<%=date%>',
    		btnValue: '<%=btnValue%>'
    	}
    	});
    	store.on('load', function(){
			<%for(int i = 0; i < checkPoint.length; i++){%>
				var rec=store.find('UIDDI', '<%=checkPoint[i]%>');
				grid.getSelectionModel().selectRow(rec,true);
			<%}%>
		});
    }else if('<%=btnValue%>' == "Create"){
    	Ext.getCmp('routecomboId').enable();
    	Ext.getCmp('dateId').enable();
    	Ext.getCmp('routecomboId').reset();
    	Ext.getCmp('dateId').reset();
    }
    var cm = grid.getColumnModel();  
    for (var j = 2; j < cm.getColumnCount(); j++) {
    if(j == 15 || j== 16 || j== 17 || j== 18 || j== 19 || j== 20 || j== 21 || j== 22 || j== 23 || j== 24 || j== 25|| j== 26|| j== 27|| j== 28|| j== 29|| j== 30|| j== 31|| j== 32){
    	 cm.setColumnWidth(j,50);
   	}else{
   		 cm.setColumnWidth(j,110);
   	}
    }
});

</script>
</body>
</html>
<%}%>
