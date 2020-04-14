<%@ page  language="java" import="java.util.*,t4u.functions.CommonFunctions,t4u.beans.*,t4u.common.*,t4u.functions.CashVanManagementFunctions" pageEncoding="utf-8"%>
<%@page import="com.itextpdf.text.log.SysoLogger"%>
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
		int userId = loginInfo.getUserId();
		int isLtsp = loginInfo.getIsLtsp();
		String btnValue = request.getParameter("btn");
		String gridBtn = "";
		if(btnValue.equals("AmendMent")){
			gridBtn = "Amend";
		}else if(btnValue.equals("Reconcile")){
			gridBtn = "Reconcile";
		}else{
			gridBtn = "realData";
		}
		String tripSheetNo = request.getParameter("TripSheetNo");
		String routeId = "";
		String date = "";
		String routeName = ""; 
		String tripNo ="";
		CashVanManagementFunctions cvmFunc = new CashVanManagementFunctions();		
		ArrayList<String> dataList = cvmFunc.getDataBasedOnTripSheetNo2(systemId,customerId,tripSheetNo);
			routeId = dataList.get(0);
			routeName = dataList.get(1);
			date = dataList.get(2);
	        tripNo = dataList.get(3);
	    
	    String journalAuthority = "1"; 
	    String cashAuthority = "1";
	    String reconcileAuthority = "1";
	    if(isLtsp < 0){
		    journalAuthority = cvmFunc.getUserAuthority(systemId,userId,customerId,4); 
		    cashAuthority = cvmFunc.getUserAuthority(systemId,userId,customerId,5); 
		    reconcileAuthority = cvmFunc.getUserAuthority(systemId,userId,customerId,6);     
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
	.x-window-header .x-unselectable .x-window-draggable{
		height: 10px;
    	padding-top: 3px !important;
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

    <script>
    var grid;
	var dtcur = datecur;
	var jspName = 'TripCreationReport';
	var exportDataType = "int,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string";
	var currentTime = new Date();
	var minDate = dateprev.add(Date.Month, -10);
	var editedRows = "";
	var endDateMinVal = datecur.add(Date.DAY, -30);
	var globalOnAccOf;
	var myWin3;
	var atmWindow;
	var lastRow = "No";
	var atmDepositWindow;
	var globalbusinessType;
	var globalCustomerName;
	var journalWin;
	var JournalAuthority = '<%=journalAuthority%>';
	var CashAuthority = '<%=cashAuthority%>';
	var ReconcileAuthority = '<%=reconcileAuthority%>';
	//var totalSumValue =200;
	var totalAmtStore = new Ext.data.JsonStore({
		url: '<%=request.getContextPath()%>/cashDispenseAction.do?param=getTotalAmount',
		id: 'totalAmtId',
		root: 'totalAmtRoot',
		autoLoad: false,
		fields: ['totalAmt']
	});
	var currentRecordsStore = new Ext.data.JsonStore({
		url: '<%=request.getContextPath()%>/cashDispenseAction.do?param=getCurrentVaultDetails',
		id: 'vaultId',
		root: 'valutRoot',
		autoLoad: false,
		fields: ['denom5000,denom2000','denom1000','denom500','denom100','denom50','denom20','denom10','denom5','denom2','denom1']
	});

var Panel = new Ext.Panel({
    standardSubmit: true,
    collapsible: false,
    id: 'customerMaster',
    layout: 'table',
    cls: 'innerpanelsmallest',
    frame: false,
    width: '100%',
    layoutConfig: {
        columns: 16
    },
    items: [ {
        xtype: 'label',
        text: 'Trip Sheet No' + ' :',
        width: 20,
        cls: 'labelstyle'
    }, {
        width: 20
    }, {
        xtype: 'textfield',
        cls: 'selectstylePerfect',
        width: 185,
        emptyText: '',
        readOnly: true,
        id: 'tripSheetNoTextId'
    },{
        width: 20
    }, {
        xtype: 'label',
        text: 'Trip No' + ' :',
        width: 20,
        cls: 'labelstyle'
    }, {
        width: 20
    }, {
        xtype: 'textfield',
        cls: 'selectstylePerfect',
        width: 185,
        emptyText: '',
        readOnly: true,
        id: 'tripNoTextId'
    },{
        width: 20
    },  {
        xtype: 'label',
        text: 'Date ' + ' :',
        width: 20,
        cls: 'labelstyle'
    }, {
        width: 20
    }, {
        xtype: 'textfield',
        cls: 'selectstylePerfect',
        width: 185,
        emptyText: '',
        readOnly: true,
        id: 'dateId'
    },{
        width: 30
    }, {
        xtype: 'label',
        text: 'Route ' + ' :',
        cls: 'labelstyle',
        id: 'routeLblId'
    }, {
        width: 20
    }, {
        xtype: 'textfield',
        text: '',
        cls: 'labelstyle',
        readOnly: true,
        id: 'routeTextlId'
    }, {
        width: 30
    }]
});
var reader = new Ext.data.JsonReader({
    idProperty: 'tripcreationId',
    root: 'cashDespenseDetailsViewRoot',
    totalProperty: 'total',
    fields: [{
        name: 'slnoIndex'
    },{
        name: 'UIDDI'
    },  {
        name: 'customerTypeDI'
    }, {
        name: 'reconcileStatusDI'
    },{
        name: 'trNumberDI'
    },{
        name: 'customerNameDI'
    },{
        name: 'customerIdDI'
    }, {
        name: 'atmIdDI'
    }, {
        name: 'accOfDI'
    }, {
        name: 'delCustDI'
    }, {
        name: 'sealedBagCashDI'
    }, {
        name: 'locationDI'
    }, {
        name: 'sealNoDI'
    },{
        name: 'checkNoDI'
    },{
        name: 'jewelleryNoDI'
    },{
        name: 'foreignCurrencyNoDI'
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
        name: 'totalAmntDI'
    },{
    	name: 'shortExcessStausDI'
    }]

});

var store = new Ext.data.GroupingStore({
    autoLoad: false,
    proxy: new Ext.data.HttpProxy({
        url: '<%=request.getContextPath()%>/CashInwardAction.do?param=getCashDespenseViewForRecocilation',
        method: 'POST'
    }),
    remoteSort: false,
    reader: reader
});

var filters = new Ext.ux.grid.GridFilters({
    local: true,
    filters: [ {
        type: 'int',
        dataIndex: 'slnoIndex'
    },{
        type: 'int',
        dataIndex: 'UIDDI'
    }, {
        type: 'string',
        dataIndex: 'customerTypeDI'
    },{
        type: 'string',
        dataIndex: 'reconcileStatusDI'
    }, {
        type: 'string',
        dataIndex: 'trNumberDI'
    }, {
        type: 'string',
        dataIndex: 'customerNameDI'
    },{
		type: 'numeric',
		dataIndex: 'customerIdDI'    
    }, {
        type: 'string',
        dataIndex: 'atmIdDI'
    }, {
        type: 'string',
        dataIndex: 'accOfDI'
    }, {
        type: 'string',
        dataIndex: 'delCustDI'
    }, {
        type: 'string',
        dataIndex: 'sealedBagCashDI'
    }, {
        type: 'string',
        dataIndex: 'locationDI'
    }, {
        type: 'string',
        dataIndex: 'sealNoDI'   
    },{
        type: 'string',
        dataIndex: 'checkNoDI'       
    },{
        type: 'string',
        dataIndex: 'jewelleryNoDI'       
    },{
        type: 'string',
        dataIndex: 'foreignCurrencyNoDI'    
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
    }, {
        type: 'numeric',
        dataIndex: 'denom050DI'
    },{
        type: 'numeric',
        dataIndex: 'denom025DI'
    },{
        type: 'numeric',
        dataIndex: 'denom010DI'
    },{
        type: 'numeric',
        dataIndex: 'denom005DI'
    },{
        type: 'numeric',
        dataIndex: 'denom002DI'
    },{
        type: 'numeric',
        dataIndex: 'denom001DI'
    },{
        type: 'numeric',
        dataIndex: 'totalAmntDI'
    },{
    	type: 'string',
    	dataIndex: 'shortExcessStausDI'
    }]
});
var createColModel = function(finish, start) {
    var columns = [       new Ext.grid.RowNumberer({
            header: "<span style=font-weight:bold;>SLNO</span>",
            width: 50
        }), 
        {
            hidden: true,
            dataIndex: 'slnoIndex',
            width: 50,
            header: "<span style=font-weight:bold;>Sl No</span>",
            filter: {
                type: 'int'
            }
        },{
            dataIndex: 'UIDDI',
           hidden: true,
            header: "<span style=font-weight:bold;>UID</span>",
            filter: {
                type: 'int'
            }
        },  {
            header: "<span style=font-weight:bold;>Business Type</span>",
            dataIndex: 'customerTypeDI',                      
            sortable: true,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;>Status</span>",
            dataIndex: 'reconcileStatusDI',
            sortable: true,
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;>TR Number</span>",
            dataIndex: 'trNumberDI',
            sortable: true,
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;>Customer Name</span>",
            dataIndex: 'customerNameDI',
            filter: {
                type: 'string'
            }
        },{
        	header: "<span style=font-weight:bold;>Customer Id</span>",
            dataIndex: 'customerIdDI',
            filter: {
                type: 'int'
            }
           , hidden: true
        }, {
            header: "<span style=font-weight:bold;>Business ID</span>",
            dataIndex: 'atmIdDI',
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;>On Account Of</span>",
            dataIndex: 'accOfDI',
            filter: {
                type: 'string'
            },
            renderer: onAccOfRenderer
        }, {
            header: "<span style=font-weight:bold;>Delivery Customer</span>",
            dataIndex: 'delCustDI',
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;>Sealed Bag or Cash</span>",
            dataIndex: 'sealedBagCashDI',
            filter: {
                type: 'string'
            }            
        }, {
            header: "<span style=font-weight:bold;>Location</span>",
            dataIndex: 'locationDI',
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;>Seal No</span>",
            dataIndex: 'sealNoDI',
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;>Cheque No</span>",
            dataIndex: 'checkNoDI',
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;>Jewellery Ref No</span>",
            dataIndex: 'jewelleryNoDI',
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;>Foreign Currency Ref No</span>",
            dataIndex: 'foreignCurrencyNoDI',
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;>5000</span>",
            dataIndex: 'denom5000DI',
            filter: {
                type: 'float'
            }
        }, {
            header: "<span style=font-weight:bold;>2000</span>",
            dataIndex: 'denom2000DI',
            filter: {
                type: 'float'
            }
        }, {
            header: "<span style=font-weight:bold;>1000</span>",
            dataIndex: 'denom1000DI',
            filter: {
                type: 'float'
            }
        }, {
            header: "<span style=font-weight:bold;>500</span>",
            dataIndex: 'denom500DI',
            filter: {
                type: 'float'
            }
        }, {
            header: "<span style=font-weight:bold;>100</span>",
            dataIndex: 'denom100DI',
            filter: {
                type: 'float'
            }
        }, {
            header: "<span style=font-weight:bold;>50</span>",
            dataIndex: 'denom50DI',
            filter: {
                type: 'float'
            }
        }, {
            header: "<span style=font-weight:bold;>20</span>",
            dataIndex: 'denom20DI',
            filter: {
                type: 'float'
            }
        }, {
            header: "<span style=font-weight:bold;>10</span>",
            dataIndex: 'denom10DI',
            filter: {
                type: 'float'
            }
        }, {
            header: "<span style=font-weight:bold;>5</span>",
            dataIndex: 'denom5DI',
            filter: {
                type: 'float'
            }
        }, {
            header: "<span style=font-weight:bold;>2</span>",
            dataIndex: 'denom2DI',
            filter: {
                type: 'float'
            }
        }, {
            header: "<span style=font-weight:bold;>1</span>",
            dataIndex: 'denom1DI',
            filter: {
                type: 'float'
            }
        }, {
            header: "<span style=font-weight:bold;>0.50</span>",
            dataIndex: 'denom050DI',
            filter: {
                type: 'float'
            }
        }, {
            header: "<span style=font-weight:bold;>0.25</span>",
            dataIndex: 'denom025DI',
            filter: {
                type: 'float'
            }
        }, {
            header: "<span style=font-weight:bold;>0.10</span>",
            dataIndex: 'denom010DI',
            filter: {
                type: 'float'
            }
        }, {
            header: "<span style=font-weight:bold;>0.05</span>",
            dataIndex: 'denom005DI',
            filter: {
                type: 'float'
            }
        }, {
            header: "<span style=font-weight:bold;>0.02</span>",
            dataIndex: 'denom002DI',
            filter: {
                type: 'float'
            }
        }, {
            header: "<span style=font-weight:bold;>0.01</span>",
            dataIndex: 'denom001DI',
            filter: {
                type: 'float'
            }
        }, {
            header: "<span style=font-weight:bold;>Total Amount</span>",
            dataIndex: 'totalAmntDI',
            filter: {
                type: 'float'
            }
        }, {
            hidden: true,
            header: "<span style=font-weight:bold;>Short/Excess Status</span>",
            dataIndex: 'shortExcessStausDI',
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

function reconcilationPopup(gridBtn){
		var selected3 = grid.getSelectionModel().getSelected();
		
		var uniqueId = selected3.get('UIDDI');
		var tripSheetNo = '<%=tripSheetNo%>';
		if(gridBtn == 'Amend'){
			if(grid.getStore().data.length == 1){
				lastRow = "yes";
				Ext.MessageBox.confirm('Confirm', "Trip associated to this POI will get closed. Are sure want to continue..?", function(btn) {
    			if (btn == 'yes') {
	    			Ext.MessageBox.show({
	        			title: 'Please wait',
				        msg: 'Closing...',
				        progressText: 'Closing...',
				        width: 300,
				        progress: true,
				        closable: false
						});
				outerPanel.getEl().mask();
				Ext.Ajax.request({
				url:'<%=request.getContextPath()%>/cashDispenseAction.do?param=amendment',
				method: 'POST',
				params:{
				uniqueId : uniqueId,
				lastRow : lastRow,
				tripSheetNo: '<%=tripSheetNo%>'
				},
				success: function(response, options){
					parent.Ext.example.msg(response.responseText);
					parent.grid2.store.reload();
					parent.myWin2.close();
					outerPanel.getEl().unmask();
				},
				failure: function(){
					grid2.store.reload();
					parent.myWin2.close();
					outerPanel.getEl().unmask();
				}
			});
			Ext.MessageBox.hide();
			}
			});
			}else{
			Ext.MessageBox.confirm('Confirm', "Are sure want to Amend the POI..?", function(btn) {
			if (btn == 'yes') {
	    		Ext.MessageBox.show({
	        		title: 'Please wait',
				    msg: 'Closing...',
				    progressText: 'Closing...',
				    width: 300,
				    progress: true,
				    closable: false
				});
			outerPanel.getEl().mask();
			Ext.Ajax.request({
				url:'<%=request.getContextPath()%>/cashDispenseAction.do?param=amendment',
				method: 'POST',
				params:{
				uniqueId : uniqueId,
				lastRow : lastRow,
				tripSheetNo: '<%=tripSheetNo%>'
				},
				success: function(response, options){
					Ext.example.msg(response.responseText);
					grid.store.reload();
					outerPanel.getEl().unmask();
				},
				failure: function(){
					grid.store.reload();
					outerPanel.getEl().unmask();
				}
			});
			Ext.MessageBox.hide();
			}
			});
			}		
		}else{
		if(selected3.get('reconcileStatusDI') !='PENDING'){
			Ext.example.msg("This POI is already reconciled");
            return;
		}
		if(selected3.get('customerTypeDI') == 'ATM Replenishment'){
			if(selected3.get('shortExcessStausDI') != 'CASH ENTERED'){
				Ext.example.msg("Please add journal & physical cash before reconciling");
	            return;
			}
			atmWindow = new Ext.Window({
        	autoShow: false,
        	constrain: false,
        	constrainHeader: false,
        	resizable: false,
        	buttonAlign: "center",
        	height:410,
            width:  1280,
        	id: 'atmPopupId',
        	plain: false,
        	footer: true,
        	closable: true,
        	stateful: false,
        	autoscroll:true,
			html: "<iframe style='width:100%;height:100%' src='<%=request.getContextPath()%>/Jsps/CashVanManagement/AtmRep.jsp?&TripSheetNo=" + tripSheetNo + "&UniqueId=" + uniqueId + "'></iframe>",
            scripts: true,
            shim: false
       		});
	   		atmWindow.show();
		}else if(selected3.get('customerTypeDI') == 'ATM Deposit'){
			if(selected3.get('shortExcessStausDI') != 'CASH ENTERED'){
				Ext.example.msg("Please add journal & physical cash before reconciling");
	            return;
			}
			atmDepositWindow = new Ext.Window({
        	autoShow: false,
        	constrain: false,
        	constrainHeader: false,
        	resizable: false,
        	buttonAlign: "center",
        	height:410,
            width:  1280,
        	id: 'atmDepositId',
        	plain: false,
        	footer: true,
        	closable: true,
        	stateful: false,
        	autoscroll:true,
			html: "<iframe style='width:100%;height:100%' src='<%=request.getContextPath()%>/Jsps/CashVanManagement/AtmDepositReconcile.jsp?&TripSheetNo=" + tripSheetNo + "&UniqueId=" + uniqueId + "'></iframe>",
            scripts: true,
            shim: false
       		});
	   		atmDepositWindow.show();
		}else{
		    myWin3 = new Ext.Window({
        	title: "Dispense Details",
        	autoShow: false,
        	constrain: false,
        	constrainHeader: false,
        	resizable: false,maximizable: false,
        	buttonAlign: "center",
        	height:430,
            width:  1020,
        	id: 'dispenseId3',
        	plain: false,
        	footer: true,
        	closable: true,
        	stateful: false,
        	autoscroll:true,
			html: "<iframe style='width:100%;height:100%' src='<%=request.getContextPath()%>/Jsps/CashVanManagement/Reconcilation.jsp?&TripSheetNo=" + tripSheetNo + "&UniqueId=" + uniqueId + "'></iframe>",
            scripts: true,
            shim: false
       		});
        	myWin3.show();
		}
		}	
		}
	<%if(btnValue.equals("AmendMent")){%>
	grid = getGridArmory('', 'No Records Found', store, screen.width - 92, 354, 38,true,'<%=gridBtn%>',true,'Add',false,'',false,'',false,'', '','' ,'' ,'' , '');
	<%}else if(btnValue.equals("Reconcile")){%>
	grid = getGridArmory('', 'No Records Found', store, screen.width - 92, 354, 38,true,'<%=gridBtn%>',false,'Add',true,'Add Physical Cash',true,'Add Journal',false,'', '', '', '','' , '');
	<%}else {%>
	jspName='RealTimeDataReport';
	grid = getGridArmory('', 'No Records Found', store, screen.width - 92, 354, 38,false,'',false,'',false,'',false,'',true,'Sum', true, 'Excel', jspName, exportDataType, true, 'Pdf');
	<%}%>
	function getGridArmory(gridtitle, emptytext, store, width, height, gridnoofcols ,CreateDispense, CreateDispenseStr,add,addStr,addPhysicalCash,addPhysicalCashStr,jouranlAdd,journalAddStr,sum,sumInVehicle, excel, excelstr, jspName, exportDataType, pdf, pdfstr) {
    var grid = new Ext.grid.GridPanel({
        title: gridtitle,
        border: false,
        height: getGridHeight(),
        autoScroll: true,
        width:170,
        store: store,
        id: 'grid',
        colModel: createColModel(gridnoofcols),
        loadMask: true,
        view: new Ext.grid.GroupingView({
            autoFill: true,
            groupTextTpl: getGroupConfig(),
            emptyText: emptytext,
            deferEmptyText: false
        }),
        listeners: {
            render: function(grid) {
                grid.store.on('load', function(store, records, options) {
                    grid.getSelectionModel().selectFirstRow();
                   
                 
                });
            }
        },

        selModel: new Ext.grid.RowSelectionModel(),
       
        plugins: filters,
        bbar: new Ext.Toolbar({})
    });
    if (width > 0) {
        grid.setSize(width, height);
    }
  
      
    if (CreateDispense) {
        grid.getBottomToolbar().add([
            '->', {
                text: CreateDispenseStr,
                id: 'reconcileId',
                handler: function() {
                reconcilationPopup(CreateDispenseStr);
                }
            }
        ]);
    }
    if (add) {
        grid.getBottomToolbar().add([
            '->', {
                text: addStr,
                id: 'addBtnId',
                handler: function() {
                addRecord();
                }
            }
        ]);
    }
    if(addPhysicalCash){
    	grid.getBottomToolbar().add([
    	'->',{
    		text: addPhysicalCashStr,
    		id: 'physicalCashAddId',
    		handler: function(){
    		physicalCashPopup();
    		}
    	}
    	]);
    }
    if(jouranlAdd){
    	grid.getBottomToolbar().add([
    		'->',{
    			text: journalAddStr,
    			id: 'journalAddId',
    			handler: function(){
    				journalAddPopup();
    			}
    		}
    	]);
    	}
    	
    if (excel) {
        grid.getBottomToolbar().add([
            '-', {
                text: '',
                iconCls: 'excelbutton',
                handler: function() {
                    getordreport('xls', 'All', jspName, grid, exportDataType);
                }
            }
        ]);
    }
    if (pdf) {
        grid.getBottomToolbar().add([
            '-', {
                text: '',
                iconCls: 'pdfbutton',
                handler: function() {
                    getordreport('pdf', 'All', jspName, grid, exportDataType);

                }
            }
        ]);
    }
    	
    
	return grid;
	}
	var innerPanelWindowPhysicalCash = new Ext.form.FormPanel({
	standardSubmit: true,
    collapsible: false,
    autoScroll: true,
    height: 240,
    width: '100%',
    frame: true,
    layout: 'table',
    layoutConfig: {
        columns: 18
    },
    items: [{
    xtype: 'label',
    text: '',
    cls: 'labelstyle'
    },{width:10},{
    xtype: 'label',
    text: 'Physical Good',
    cls: 'labelstyle'
    },{width:10},{
    xtype: 'label',
    text: '',
    cls: 'labelstyle'
    },{width:10},{
    xtype: 'label',
    text: 'Physical Bad',
    cls: 'labelstyle'
    },{width:10},{
    xtype: 'label',
    text: '',
    cls: 'labelstyle'
    },{width:10},{
    xtype: 'label',
    text: 'Rejected Good',
    cls: 'labelstyle'
    },{width:10},{
    xtype: 'label',
    text: '',
    cls: 'labelstyle'
    },{width:10},{
    xtype: 'label',
    text: 'Rejected Bad',
    cls: 'labelstyle'
    },{width:10},{
    xtype: 'label',
    text: '',
    cls: 'labelstyle'
    },{height:5},{
    xtype: 'label',
    text: 'Denominations',
    id: 'denominationLblIdCash',
    cls: 'labelstyle'
    },{width:10},{
    xtype: 'label',
    text: 'Notes',
    cls: 'labelstyle',
    id: 'noteLblIdCash1'
    },{width:10},{
    xtype: 'label',
    text: 'Value',
    cls: 'labelstyle',
    id: 'valueLblIdCash1'
    },{width:10},{
    xtype: 'label',
    text: 'Notes',
    cls: 'labelstyle',
    id: 'noteLblIdCash2'
    },{width:10},{
    xtype: 'label',
    text: 'Value',
    cls: 'labelstyle',
    id: 'valueLblIdCash2'
    },{width:10},{
    xtype: 'label',
    text: 'Notes',
    cls: 'labelstyle',
    id: 'noteLblIdCash3'
    },{width:10},{
    xtype: 'label',
    text: 'Value',
    cls: 'labelstyle',
    id: 'valueLblIdCash3'
    },{width:10},{
    xtype: 'label',
    text: 'Notes',
    cls: 'labelstyle',
    id: 'noteLblIdCash4'
    },{width:10},{
    xtype: 'label',
    text: 'Value',
    cls: 'labelstyle',
    id: 'valueLblIdCash4'
    },{height:40},{//18
    xtype: 'label',
    text: '5000 '+':',
    id: 'journal5000LblIdCash',
    cls: 'labelstyle'
    },{width:10},{
    xtype: 'numberfield',
    cls: 'selectstylePerfect',               
    emptyText: 'Enter 5000 notes',
    blankText: 'Enter 5000 notes',
    id: 'journal5000IdCash1',
   	allowBlank: false,
    allowNegative: false,
    allowDecimals: false,
    listeners:{
	change:{
	fn: function(){
		Ext.getCmp('journal5000ValueIdCash1').setValue(Ext.getCmp('journal5000IdCash1').getValue() * 5000);
	}
	}
	}
    },{width:10},{
    xtype: 'numberfield',
    cls: 'selectstylePerfect',
    id: 'journal5000ValueIdCash1',
    readOnly: true
    },{width:10},{
    xtype: 'numberfield',
    cls: 'selectstylePerfect',               
    emptyText: 'Enter 5000 notes',
    blankText: 'Enter 5000 notes',
    id: 'journal5000IdCash2',
    allowBlank: false,
    allowNegative: false,
    allowDecimals: false,
    listeners:{
	change:{
	fn: function(){
		Ext.getCmp('journal5000ValueIdCash2').setValue(Ext.getCmp('journal5000IdCash2').getValue() * 5000);
	}
	}
	}
    },{width:10},{
    xtype: 'numberfield',
    cls: 'selectstylePerfect',
    id: 'journal5000ValueIdCash2',
    readOnly: true
    },{width:10},{
    xtype: 'numberfield',
    cls: 'selectstylePerfect',               
    emptyText: 'Enter 5000 notes',
    blankText: 'Enter 5000 notes',
    id: 'journal5000IdCash3',
    allowBlank: false,
    allowNegative: false,
    allowDecimals: false,
    listeners:{
	change:{
	fn: function(){
		Ext.getCmp('journal5000ValueIdCash3').setValue(Ext.getCmp('journal5000IdCash3').getValue() * 5000);
	}
	}
	}
    },{width:10},{
    xtype: 'numberfield',
    cls: 'selectstylePerfect',
    id: 'journal5000ValueIdCash3',
    readOnly: true
    },{width:10},{
    xtype: 'numberfield',
    cls: 'selectstylePerfect',               
    emptyText: 'Enter 5000 notes',
    blankText: 'Enter 5000 notes',
    id: 'journal5000IdCash4',
    allowBlank: false,
    allowNegative: false,
    allowDecimals: false,
    listeners:{
	change:{
	fn: function(){
		Ext.getCmp('journal5000ValueIdCash4').setValue(Ext.getCmp('journal5000IdCash4').getValue() * 5000);
	}
	}
	}
    },{width:10},{
    xtype: 'numberfield',
    cls: 'selectstylePerfect',
    id: 'journal5000ValueIdCash4',
    readOnly: true
    },{height:30},{//36
    xtype: 'label',
    text: '2000 '+':',
    id: 'journal2000LblIdCash',
    cls: 'labelstyle'
    },{width:10},{
    xtype: 'numberfield',
    cls: 'selectstylePerfect',               
    emptyText: 'Enter 2000 notes',
    blankText: 'Enter 2000 notes',
    id: 'journal2000IdCash1',
    allowBlank: false,
    allowNegative: false,
    allowDecimals: false,
    listeners:{
	change:{
	fn: function(){
		Ext.getCmp('journal2000ValueIdCash1').setValue(Ext.getCmp('journal2000IdCash1').getValue() * 2000);
	}
	}
	}
    },{width:10},{
    xtype: 'numberfield',
    cls: 'selectstylePerfect',
    id: 'journal2000ValueIdCash1',
    readOnly: true
    },{width:10},{
    xtype: 'numberfield',
    cls: 'selectstylePerfect',               
    emptyText: 'Enter 2000 notes',
    blankText: 'Enter 2000 notes',
    id: 'journal2000IdCash2',
    allowBlank: false,
    allowNegative: false,
    allowDecimals: false,
    listeners:{
	change:{
	fn: function(){
		Ext.getCmp('journal2000ValueIdCash2').setValue(Ext.getCmp('journal2000IdCash2').getValue() * 2000);
	}
	}
	}
    },{width:10},{
    xtype: 'numberfield',
    cls: 'selectstylePerfect',
    id: 'journal2000ValueIdCash2',
    readOnly: true
    },{width:10},{
    xtype: 'numberfield',
    cls: 'selectstylePerfect',               
    emptyText: 'Enter 2000 notes',
    blankText: 'Enter 2000 notes',
    id: 'journal2000IdCash3',
    allowBlank: false,
    allowNegative: false,
    allowDecimals: false,
    listeners:{
	change:{
	fn: function(){
		Ext.getCmp('journal2000ValueIdCash3').setValue(Ext.getCmp('journal2000IdCash3').getValue() * 2000);
	}
	}
	}
    },{width:10},{
    xtype: 'numberfield',
    cls: 'selectstylePerfect',
    id: 'journal2000ValueIdCash3',
    readOnly: true
    },{width:10},{
    xtype: 'numberfield',
    cls: 'selectstylePerfect',               
    emptyText: 'Enter 2000 notes',
    blankText: 'Enter 2000 notes',
    id: 'journal2000IdCash4',
    allowBlank: false,
    allowNegative: false,
    allowDecimals: false,
    listeners:{
	change:{
	fn: function(){
		Ext.getCmp('journal2000ValueIdCash4').setValue(Ext.getCmp('journal2000IdCash4').getValue() * 2000);
	}
	}
	}
    },{width:10},{
    xtype: 'numberfield',
    cls: 'selectstylePerfect',
    id: 'journal2000ValueIdCash4',
    readOnly: true
    },{height:30},{//54
    xtype: 'label',
    text: '1000 '+':',
    id: 'journal1000LblIdCash',
    cls: 'labelstyle'
    },{width:10},{
    xtype: 'numberfield',
    cls: 'selectstylePerfect',               
    emptyText: 'Enter 1000 notes',
    blankText: 'Enter 1000 notes',
    id: 'journal1000IdCash1',
    allowBlank: false,
    allowNegative: false,
    allowDecimals: false,
    listeners:{
	change:{
	fn: function(){
		Ext.getCmp('journal1000ValueIdCash1').setValue(Ext.getCmp('journal1000IdCash1').getValue() * 1000);
	}
	}
	}
    },{width:10},{
    xtype: 'numberfield',
    cls: 'selectstylePerfect',
    id: 'journal1000ValueIdCash1',
    readOnly: true
    },{width:10},{
    xtype: 'numberfield',
    cls: 'selectstylePerfect',               
    emptyText: 'Enter 1000 notes',
    blankText: 'Enter 1000 notes',
    id: 'journal1000IdCash2',
    allowBlank: false,
    allowNegative: false,
    allowDecimals: false,
    listeners:{
	change:{
	fn: function(){
		Ext.getCmp('journal1000ValueIdCash2').setValue(Ext.getCmp('journal1000IdCash2').getValue() * 1000);
	}
	}
	}
    },{width:10},{
    xtype: 'numberfield',
    cls: 'selectstylePerfect',
    id: 'journal1000ValueIdCash2',
    readOnly: true
    },{width:10},{
    xtype: 'numberfield',
    cls: 'selectstylePerfect',               
    emptyText: 'Enter 1000 notes',
    blankText: 'Enter 1000 notes',
    id: 'journal1000IdCash3',
    allowBlank: false,
    allowNegative: false,
    allowDecimals: false,
    listeners:{
	change:{
	fn: function(){
		Ext.getCmp('journal1000ValueIdCash3').setValue(Ext.getCmp('journal1000IdCash3').getValue() * 1000);
	}
	}
	}
    },{width:10},{
    xtype: 'numberfield',
    cls: 'selectstylePerfect',
    id: 'journal1000ValueIdCash3',
    readOnly: true
    },{width:10},{
    xtype: 'numberfield',
    cls: 'selectstylePerfect',               
    emptyText: 'Enter 1000 notes',
    blankText: 'Enter 1000 notes',
    id: 'journal1000IdCash4',
    allowBlank: false,
    allowNegative: false,
    allowDecimals: false,
    listeners:{
	change:{
	fn: function(){
		Ext.getCmp('journal1000ValueIdCash4').setValue(Ext.getCmp('journal1000IdCash4').getValue() * 1000);
	}
	}
	}
    },{width:10},{
    xtype: 'numberfield',
    cls: 'selectstylePerfect',
    id: 'journal1000ValueIdCash4',
    readOnly: true
    },{height:30},{//72
    xtype: 'label',
    text: '500 '+':',
    id: 'journal500LblIdCash',
    cls: 'labelstyle'
    },{width:10},{
    xtype: 'numberfield',
    cls: 'selectstylePerfect',               
    emptyText: 'Enter 500 notes',
    blankText: 'Enter 500 notes',
    id: 'journal500IdCash1',
    allowBlank: false,
    allowNegative: false,
    allowDecimals: false,
    listeners:{
	change:{
	fn: function(){
		Ext.getCmp('journal500ValueIdCash1').setValue(Ext.getCmp('journal500IdCash1').getValue() * 500);
	}
	}
	}
    },{width:10},{
    xtype: 'numberfield',
    cls: 'selectstylePerfect',
    id: 'journal500ValueIdCash1',
    readOnly: true
    },{width:10},{
    xtype: 'numberfield',
    cls: 'selectstylePerfect',               
    emptyText: 'Enter 500 notes',
    blankText: 'Enter 500 notes',
    id: 'journal500IdCash2',
    allowBlank: false,
    allowNegative: false,
    allowDecimals: false,
    listeners:{
	change:{
	fn: function(){
		Ext.getCmp('journal500ValueIdCash2').setValue(Ext.getCmp('journal500IdCash2').getValue() * 500);
	}
	}
	}
    },{width:10},{
    xtype: 'numberfield',
    cls: 'selectstylePerfect',
    id: 'journal500ValueIdCash2',
    readOnly: true
    },{width:10},{
    xtype: 'numberfield',
    cls: 'selectstylePerfect',               
    emptyText: 'Enter 500 notes',
    blankText: 'Enter 500 notes',
    id: 'journal500IdCash3',
    allowBlank: false,
    allowNegative: false,
    allowDecimals: false,
    listeners:{
	change:{
	fn: function(){
		Ext.getCmp('journal500ValueIdCash3').setValue(Ext.getCmp('journal500IdCash3').getValue() * 500);
	}
	}
	}
    },{width:10},{
    xtype: 'numberfield',
    cls: 'selectstylePerfect',
    id: 'journal500ValueIdCash3',
    readOnly: true
    },{width:10},{
    xtype: 'numberfield',
    cls: 'selectstylePerfect',               
    emptyText: 'Enter 500 notes',
    blankText: 'Enter 500 notes',
    id: 'journal500IdCash4',
    allowBlank: false,
    allowNegative: false,
    allowDecimals: false,
    listeners:{
	change:{
	fn: function(){
		Ext.getCmp('journal500ValueIdCash4').setValue(Ext.getCmp('journal500IdCash4').getValue() * 500);
	}
	}
	}
    },{width:10},{
    xtype: 'numberfield',
    cls: 'selectstylePerfect',
    id: 'journal500ValueIdCash4',
    readOnly: true
    },{height:30},{//90
    xtype: 'label',
    text: '100 '+':',
    id: 'journal100LblIdCash',
    cls: 'labelstyle'
    },{width:10},{
    xtype: 'numberfield',
    cls: 'selectstylePerfect',               
    emptyText: 'Enter 100 notes',
    blankText: 'Enter 100 notes',
    id: 'journal100IdCash1',
    allowBlank: false,
    allowNegative: false,
    allowDecimals: false,
    listeners:{
	change:{
	fn: function(){
		Ext.getCmp('journal100ValueIdCash1').setValue(Ext.getCmp('journal100IdCash1').getValue() * 100);
	}
	}
	}
    },{width:10},{
    xtype: 'numberfield',
    cls: 'selectstylePerfect',
    id: 'journal100ValueIdCash1',
    readOnly: true
    },{width:10},{
    xtype: 'numberfield',
    cls: 'selectstylePerfect',               
    emptyText: 'Enter 100 notes',
    blankText: 'Enter 100 notes',
    id: 'journal100IdCash2',
    allowBlank: false,
    allowNegative: false,
    allowDecimals: false,
    listeners:{
	change:{
	fn: function(){
		Ext.getCmp('journal100ValueIdCash2').setValue(Ext.getCmp('journal100IdCash2').getValue() * 100);
	}
	}
	}
    },{width:10},{
    xtype: 'numberfield',
    cls: 'selectstylePerfect',
    id: 'journal100ValueIdCash2',
    readOnly: true
    },{width:10},{
    xtype: 'numberfield',
    cls: 'selectstylePerfect',               
    emptyText: 'Enter 100 notes',
    blankText: 'Enter 100 notes',
    id: 'journal100IdCash3',
    allowBlank: false,
    allowNegative: false,
    allowDecimals: false,
    listeners:{
	change:{
	fn: function(){
		Ext.getCmp('journal100ValueIdCash3').setValue(Ext.getCmp('journal100IdCash3').getValue() * 100);
	}
	}
	}
    },{width:10},{
    xtype: 'numberfield',
    cls: 'selectstylePerfect',
    id: 'journal100ValueIdCash3',
    readOnly: true
    },{width:10},{
    xtype: 'numberfield',
    cls: 'selectstylePerfect',               
    emptyText: 'Enter 100 notes',
    blankText: 'Enter 100 notes',
    id: 'journal100IdCash4',
    allowBlank: false,
    allowNegative: false,
    allowDecimals: false,
    listeners:{
	change:{
	fn: function(){
		Ext.getCmp('journal100ValueIdCash4').setValue(Ext.getCmp('journal100IdCash4').getValue() * 100);
	}
	}
	}
    },{width:10},{
    xtype: 'numberfield',
    cls: 'selectstylePerfect',
    id: 'journal100ValueIdCash4',
    readOnly: true
    },{height:30}]
    });

    var winButtonPanelPhysicalCash = new Ext.Panel({
    standardSubmit: true,
    collapsible: false,
    autoHeight: true,
    height: 50,
    width: '100%',
    frame: true,
    layout: 'table',
    layoutConfig: {
        columns: 4
    },
    buttons:[{
	    xtype: 'button',
	    text: 'Save',
	    id: 'saveBtnCashId',
	    cls: 'buttonstyle',
	    width: 70,
	    listeners: {
	        click: {
	            fn: function () {
	            	Ext.getCmp('saveBtnCashId').disable();
	            	var selected = grid.getSelectionModel().getSelected();
	            	var dispUID = selected.get('UIDDI');
	            	Ext.Ajax.request({
						url:'<%=request.getContextPath()%>/cashDispenseAction.do?param=insertPhysicalCashData',
						method: 'POST',
						params:{
						dispUID: dispUID,
						pgdenom5000: Ext.getCmp('journal5000IdCash1').getValue(),
						pgdenom2000: Ext.getCmp('journal2000IdCash1').getValue(),
						pgdenom1000: Ext.getCmp('journal1000IdCash1').getValue(),
						pgdenom500: Ext.getCmp('journal500IdCash1').getValue(),
						pgdenom100: Ext.getCmp('journal100IdCash1').getValue(),
						pbdenom5000: Ext.getCmp('journal5000IdCash2').getValue(),
						pbdenom2000: Ext.getCmp('journal2000IdCash2').getValue(),
						pbdenom1000: Ext.getCmp('journal1000IdCash2').getValue(),
						pbdenom500: Ext.getCmp('journal500IdCash2').getValue(),
						pbdenom100: Ext.getCmp('journal100IdCash2').getValue(),
						rgdenom5000: Ext.getCmp('journal5000IdCash3').getValue(),
						rgdenom2000: Ext.getCmp('journal2000IdCash3').getValue(),
						rgdenom1000: Ext.getCmp('journal1000IdCash3').getValue(),
						rgdenom500: Ext.getCmp('journal500IdCash3').getValue(),
						rgdenom100: Ext.getCmp('journal100IdCash3').getValue(),
						rbdenom5000: Ext.getCmp('journal5000IdCash4').getValue(),
						rbdenom2000: Ext.getCmp('journal2000IdCash4').getValue(),
						rbdenom1000: Ext.getCmp('journal1000IdCash4').getValue(),
						rbdenom500: Ext.getCmp('journal500IdCash4').getValue(),
						rbdenom100: Ext.getCmp('journal100IdCash4').getValue()
						},
						success: function(response, options){
							Ext.getCmp('saveBtnCashId').enable();
       						Ext.example.msg(response.responseText);
							outerPanel.getEl().unmask();
							grid.store.reload();
							physicalCashWin.hide();
						},
						failure: function(){
							Ext.example.msg("Error");
							Ext.getCmp('saveBtnCashId').enable();
							outerPanel.getEl().unmask();
							grid.store.reload();
							physicalCashWin.hide();
						}
					});	
	            }
	            }
	        }
	    }, {
	    xtype: 'button',
	    text: 'Cancel',
	    iconCls:'cancelBtnId',
	    cls: 'buttonstyle',
	    width: 70,
	    listeners: {
	        click: {
	            fn: function () {
	                physicalCashWin.hide();
		             }
	         }
	     }
        }]

    });
	var outerPanelWindowPhysicalCash = new Ext.Panel({
        width: '100%',
        height:350,
        standardSubmit: true,
        frame: false,
        items: [innerPanelWindowPhysicalCash, winButtonPanelPhysicalCash]
    });

	physicalCashWin = new Ext.Window({
        closable: false,
        resizable:false,
        modal: true,
        autoScroll: false,
        title:'Physical / Rejected cash Details',
        height: 350,
        width: 1270,
        items: [outerPanelWindowPhysicalCash]
    });
	function physicalCashPopup(){
		var selected = grid.getSelectionModel().getSelected();
		if(selected.get('customerTypeDI') != 'ATM Replenishment' && selected.get('customerTypeDI') != 'ATM Deposit'){
			Ext.example.msg("Business type should be ATM Replenishment or ATM Deposit");
			return;
		}
		if(selected.get('reconcileStatusDI') == 'RECONCILED'){
			Ext.example.msg("POI is reconciled, cannot add physical cash data");
			return;
		}
		if(selected.get('shortExcessStausDI') == ''){
			Ext.example.msg("Please enter journal before entering physical cash");
			return;
		}
		if(selected.get('shortExcessStausDI') == 'CASH ENTERED'){
			Ext.example.msg("Physical cash already entered for this POI");
			return;
		}
		
		Ext.getCmp('journal5000IdCash1').setValue(0);
		Ext.getCmp('journal2000IdCash1').setValue(0);
		Ext.getCmp('journal1000IdCash1').setValue(0);
		Ext.getCmp('journal500IdCash1').setValue(0);
		Ext.getCmp('journal100IdCash1').setValue(0);
		Ext.getCmp('journal5000ValueIdCash1').reset();
		Ext.getCmp('journal2000ValueIdCash1').reset();
		Ext.getCmp('journal1000ValueIdCash1').reset();
		Ext.getCmp('journal500ValueIdCash1').reset();
		Ext.getCmp('journal100ValueIdCash1').reset();
		Ext.getCmp('journal5000IdCash2').setValue(0);
		Ext.getCmp('journal2000IdCash2').setValue(0);
		Ext.getCmp('journal1000IdCash2').setValue(0);
		Ext.getCmp('journal500IdCash2').setValue(0);
		Ext.getCmp('journal100IdCash2').setValue(0);
		Ext.getCmp('journal5000ValueIdCash2').reset();
		Ext.getCmp('journal2000ValueIdCash2').reset();
		Ext.getCmp('journal1000ValueIdCash2').reset();
		Ext.getCmp('journal500ValueIdCash2').reset();
		Ext.getCmp('journal100ValueIdCash2').reset();
		Ext.getCmp('journal5000IdCash3').setValue(0);
		Ext.getCmp('journal2000IdCash3').setValue(0);
		Ext.getCmp('journal1000IdCash3').setValue(0);
		Ext.getCmp('journal500IdCash3').setValue(0);
		Ext.getCmp('journal100IdCash3').setValue(0);
		Ext.getCmp('journal5000ValueIdCash3').reset();
		Ext.getCmp('journal2000ValueIdCash3').reset();
		Ext.getCmp('journal1000ValueIdCash3').reset();
		Ext.getCmp('journal500ValueIdCash3').reset();
		Ext.getCmp('journal100ValueIdCash3').reset();
		Ext.getCmp('journal5000IdCash4').setValue(0);
		Ext.getCmp('journal2000IdCash4').setValue(0);
		Ext.getCmp('journal1000IdCash4').setValue(0);
		Ext.getCmp('journal500IdCash4').setValue(0);
		Ext.getCmp('journal100IdCash4').setValue(0);
		Ext.getCmp('journal5000ValueIdCash4').reset();
		Ext.getCmp('journal2000ValueIdCash4').reset();
		Ext.getCmp('journal1000ValueIdCash4').reset();
		Ext.getCmp('journal500ValueIdCash4').reset();
		Ext.getCmp('journal100ValueIdCash4').reset();
		
		if(selected.get('customerTypeDI') == 'ATM Replenishment'){
			Ext.getCmp('journal2000LblIdCash').hide();
			Ext.getCmp('journal2000IdCash1').hide();
			Ext.getCmp('journal2000ValueIdCash1').hide();
			Ext.getCmp('journal2000IdCash2').hide();
			Ext.getCmp('journal2000ValueIdCash2').hide();
			Ext.getCmp('journal2000IdCash3').hide();
			Ext.getCmp('journal2000ValueIdCash3').hide();
			Ext.getCmp('journal2000IdCash4').hide();
			Ext.getCmp('journal2000ValueIdCash4').hide();
		}else{
			Ext.getCmp('journal2000LblIdCash').show();
			Ext.getCmp('journal2000IdCash1').show();
			Ext.getCmp('journal2000ValueIdCash1').show();
			Ext.getCmp('journal2000IdCash2').show();
			Ext.getCmp('journal2000ValueIdCash2').show();
			Ext.getCmp('journal2000IdCash3').show();
			Ext.getCmp('journal2000ValueIdCash3').show();
			Ext.getCmp('journal2000IdCash4').show();
			Ext.getCmp('journal2000ValueIdCash4').show();
		}
		physicalCashWin.show();
	}
	//***************************************************** Journal Popup *************************************************************
	var innerPanelWindowJournal = new Ext.form.FormPanel({
	standardSubmit: true,
    collapsible: false,
    autoScroll: true,
    height: 210,
    width: '100%',
    frame: true,
    layout: 'table',
    layoutConfig: {
        columns: 6
    },
    items: [{
    xtype: 'label',
    text: 'Denominations',
    id: 'denominationLblId',
    cls: 'labelstyle'
    },{width:30},{
    xtype: 'label',
    text: 'Notes',
    cls: 'labelstyle',
    id: 'noteLblId'
    },{width:30},{
    xtype: 'label',
    text: 'Value',
    cls: 'labelstyle',
    id: 'valueLblId'
    },{height:40},{
    xtype: 'label',
    text: '5000 '+':',
    id: 'journal5000LblId',
    cls: 'labelstyle'
    },{width:30},{
    xtype: 'numberfield',
    cls: 'selectstylePerfect',               
    emptyText: 'Enter 5000 notes',
    blankText: 'Enter 5000 notes',
    id: 'journal5000Id',
    allowBlank: false,
    allowNegative: false,
    allowDecimals: false,
    listeners:{
	change:{
	fn: function(){
		Ext.getCmp('journal5000ValueId').setValue(Ext.getCmp('journal5000Id').getValue() * 5000);
	}
	}
	}
    },{width:30},{
    xtype: 'numberfield',
    cls: 'selectstylePerfect',
    id: 'journal5000ValueId',
    readOnly: true
    },{height:30},{
    xtype: 'label',
    text: '2000 '+':',
    id: 'journal2000LblId',
    cls: 'labelstyle'
    },{width:30},{
    xtype: 'numberfield',
    cls: 'selectstylePerfect',               
    emptyText: 'Enter 2000 notes',
    blankText: 'Enter 2000 notes',
    id: 'journal2000Id',
    allowBlank: false,
    allowNegative: false,
    allowDecimals: false,
    listeners:{
	change:{
	fn: function(){
		Ext.getCmp('journal2000ValueId').setValue(Ext.getCmp('journal2000Id').getValue() * 2000);
	}
	}
	}
    },{width:30},{
    xtype: 'numberfield',
    cls: 'selectstylePerfect',
    id: 'journal2000ValueId',
    readOnly: true
    },{height:30},{
    xtype: 'label',
    text: '1000 '+':',
    id: 'journal1000LblId',
    cls: 'labelstyle'
    },{width:30},{
    xtype: 'numberfield',
    cls: 'selectstylePerfect',               
    emptyText: 'Enter 1000 notes',
    blankText: 'Enter 1000 notes',
    id: 'journal1000Id',
    allowBlank: false,
    allowNegative: false,
    allowDecimals: false,
    listeners:{
	change:{
	fn: function(){
		Ext.getCmp('journal1000ValueId').setValue(Ext.getCmp('journal1000Id').getValue() * 1000);
	}
	}
	}
    },{width:30},{
    xtype: 'numberfield',
    cls: 'selectstylePerfect',
    id: 'journal1000ValueId',
    readOnly: true
    },{height:30},{
    xtype: 'label',
    text: '500 '+':',
    id: 'journal500LblId',
    cls: 'labelstyle'
    },{width:30},{
    xtype: 'numberfield',
    cls: 'selectstylePerfect',               
    emptyText: 'Enter 500 notes',
    blankText: 'Enter 500 notes',
    id: 'journal500Id',
    allowBlank: false,
    allowNegative: false,
    allowDecimals: false,
    listeners:{
	change:{
	fn: function(){
		Ext.getCmp('journal500ValueId').setValue(Ext.getCmp('journal500Id').getValue() * 500);
	}
	}
	}
    },{width:30},{
    xtype: 'numberfield',
    cls: 'selectstylePerfect',
    id: 'journal500ValueId',
    readOnly: true
    },{height:30},{
    xtype: 'label',
    text: '100 '+':',
    id: 'journal100LblId',
    cls: 'labelstyle'
    },{width:30},{
    xtype: 'numberfield',
    cls: 'selectstylePerfect',               
    emptyText: 'Enter 100 notes',
    blankText: 'Enter 100 notes',
    id: 'journal100Id',
    allowBlank: false,
    allowNegative: false,
    allowDecimals: false,
    listeners:{
	change:{
	fn: function(){
		Ext.getCmp('journal100ValueId').setValue(Ext.getCmp('journal100Id').getValue() * 100);
	}
	}
	}
    },{width:30},{
    xtype: 'numberfield',
    cls: 'selectstylePerfect',
    id: 'journal100ValueId',
    readOnly: true
    },{height:30}]
    });

    var winButtonPanelJournal = new Ext.Panel({
    standardSubmit: true,
    collapsible: false,
    autoHeight: true,
    height: 50,
    width: '100%',
    frame: true,
    layout: 'table',
    layoutConfig: {
        columns: 4
    },
    buttons:[{
	    xtype: 'button',
	    text: 'Save',
	    id: 'saveBtnId',
	    cls: 'buttonstyle',
	    width: 70,
	    listeners: {
	        click: {
	            fn: function () {
	            	Ext.getCmp('saveBtnId').disable();
	            	if(Ext.getCmp('journal5000Id').getValue() == 0 && Ext.getCmp('journal2000Id').getValue() == 0 && Ext.getCmp('journal1000Id').getValue() == 0
	            		&& Ext.getCmp('journal500Id').getValue() == 0 && Ext.getCmp('journal100Id').getValue() == 0){
	            		Ext.example.msg("Please enter any one denomination Value");
	            		Ext.getCmp('saveBtnId').enable();
	            		return;
	            	}
	            	var selected = grid.getSelectionModel().getSelected();
	            	var dispUID = selected.get('UIDDI');
	            	Ext.Ajax.request({
						url:'<%=request.getContextPath()%>/cashDispenseAction.do?param=insertJournalEntry',
						method: 'POST',
						params:{
						dispUID: dispUID,
						denom5000: Ext.getCmp('journal5000Id').getValue(),
						denom2000: Ext.getCmp('journal2000Id').getValue(),
						denom1000: Ext.getCmp('journal1000Id').getValue(),
						denom500: Ext.getCmp('journal500Id').getValue(),
						denom100: Ext.getCmp('journal100Id').getValue()
						},
						success: function(response, options){
							Ext.getCmp('saveBtnId').enable();
       						Ext.example.msg(response.responseText);
							outerPanel.getEl().unmask();
							grid.store.reload();
							journalWin.hide();
						},
						failure: function(){
							Ext.example.msg("Error");
							Ext.getCmp('saveBtnId').enable();
							outerPanel.getEl().unmask();
							grid.store.reload();
							journalWin.hide();
						}
					});	
	            }
	            }
	        }
	    }, {
	    xtype: 'button',
	    text: 'Cancel',
	    iconCls:'cancelbutton',
	    cls: 'buttonstyle',
	    width: 70,
	    listeners: {
	        click: {
	            fn: function () {
	                journalWin.hide();
		             }
	         }
	     }
        }]

    });
	var outerPanelWindowJournal = new Ext.Panel({
        width: '100%',
        height:340,
        standardSubmit: true,
        frame: false,
        items: [innerPanelWindowJournal, winButtonPanelJournal]
    });

	journalWin = new Ext.Window({
        closable: false,
        resizable:false,
        modal: true,
        autoScroll: false,
        title:'Add Journal Details',
        height: 340,
        width: 500,
        items: [outerPanelWindowJournal]
    });
	function journalAddPopup(){
		var selected = grid.getSelectionModel().getSelected();
		if(selected.get('reconcileStatusDI') == 'RECONCILED'){
			Ext.example.msg("POI is reconciled, cannot add journal data");
			return;
		}
		if(selected.get('shortExcessStausDI') == 'JOURNAL ENTERED'){
			Ext.example.msg("Journal data alredy entered for this POI");
			return;
		}
		if(selected.get('shortExcessStausDI') == 'CASH ENTERED'){
			Ext.example.msg("Physical cash entered for this record, cannot add journal data");
			return;
		}
		
		Ext.getCmp('journal5000Id').setValue(0);
		Ext.getCmp('journal2000Id').setValue(0);
		Ext.getCmp('journal1000Id').setValue(0);
		Ext.getCmp('journal500Id').setValue(0);
		Ext.getCmp('journal100Id').setValue(0);
		Ext.getCmp('journal5000ValueId').reset();
		Ext.getCmp('journal2000ValueId').reset();
		Ext.getCmp('journal1000ValueId').reset();
		Ext.getCmp('journal500ValueId').reset();
		Ext.getCmp('journal100ValueId').reset();
		
		if(selected.get('customerTypeDI') != 'ATM Replenishment' && selected.get('customerTypeDI') != 'ATM Deposit'){
			Ext.example.msg("Business type should be ATM Replenishment or ATM Deposit");
			return;
		}
		if(selected.get('customerTypeDI') == 'ATM Replenishment'){
			Ext.getCmp('journal2000LblId').hide();
			Ext.getCmp('journal2000Id').hide();
			Ext.getCmp('journal2000ValueId').hide();
		}else{
			Ext.getCmp('journal2000LblId').show();
			Ext.getCmp('journal2000Id').show();
			Ext.getCmp('journal2000ValueId').show();
		}
		journalWin.show();
	}
 //*****************************Business Id store*************************************//
	var businessIdStore = new Ext.data.JsonStore({
    	url: '<%=request.getContextPath()%>/cashDispenseAction.do?param=businessId',
    	id: 'businessId',
    	root: 'businessIdRoot',
    	autoLoad: false,
    	fields: ['businessId', 'businessIdName','businessType','location','cvsCustomer','cvsCustomerId']
	});
	//******************************Business Type Combo****************************************************//
	var businessIdCombo = new Ext.form.ComboBox({
    store: businessIdStore,
    id: 'businessIdComboId',
    mode: 'local',
    forceSelection: true,
    emptyText: 'Select business Id',
    blankText: 'Select business Id',
    selectOnFocus: true,
    allowBlank: true,
    anyMatch: true,
    typeAhead: false,
    triggerAction: 'all',
    lazyRender: true,
    valueField: 'businessId',
    displayField: 'businessIdName',
    cls: 'selectstylePerfect',
    listeners: {
        select: {
            fn: function() {
            var id = businessIdStore.findExact('businessId', Ext.getCmp('businessIdComboId').getValue());
       		var rec = businessIdStore.getAt(id);
       		globalbusinessType = rec.data['businessType'];
       		globalCustomerName = rec.data['cvsCustomer'];
       		Ext.getCmp('businessTypeId').setText(rec.data['businessType']);
       		Ext.getCmp('customerId').setText(rec.data['cvsCustomer']);
       		Ext.getCmp('HubLocationId').setText(rec.data['location']);
       		Ext.getCmp('cvsCustomerId').setValue(rec.data['cvsCustomerId']);
       	
       		if(rec.data['businessType'] == "Cash Delivery"){
       			Ext.getCmp('mandatoryaccount').show();
       			Ext.getCmp('accountOfLblId').show();
       			Ext.getCmp('onAccComboId').show();
       			Ext.getCmp('mandatorySealedBag').show();
       			Ext.getCmp('SealedBagLabId').show();
       			Ext.getCmp('sealedOrCashComboId').show();
       			Ext.getCmp('mandatorySealNo').show();
       			Ext.getCmp('SealNoLabId').show();
       			Ext.getCmp('sealNoComboId').show();
       			Ext.getCmp('mandatoryChequeNo').show();
       			Ext.getCmp('ChequeNoLabId').show();
       			Ext.getCmp('checkNoComboId').show();
       			Ext.getCmp('mandatoryJewellary').show();
       			Ext.getCmp('JewelleryNoLabId').show();
       			Ext.getCmp('jewellaryComboId').show();
       			Ext.getCmp('mandatoryForeignCurr').show();
       			Ext.getCmp('ForeignCurrNoLabId').show();
       			Ext.getCmp('foreignComboId').show();
       			Ext.getCmp('denom2000Id').enable();
       			Ext.getCmp('customerLabId').hide();  //t4u506
       			Ext.getCmp('customerComboId').hide(); //t4u506
       			Ext.getCmp('deliveryLabId').hide(); //t4u506 
       			Ext.getCmp('deliveryLocComboId').hide(); //t4u506
       		}else {
       			Ext.getCmp('mandatoryaccount').hide();
       			Ext.getCmp('accountOfLblId').hide();
       			Ext.getCmp('onAccComboId').hide();
       			Ext.getCmp('mandatorySealedBag').hide();
       			Ext.getCmp('SealedBagLabId').hide();
       			Ext.getCmp('sealedOrCashComboId').hide();
       			Ext.getCmp('mandatorySealNo').hide();
       			Ext.getCmp('SealNoLabId').hide();
       			Ext.getCmp('sealNoComboId').hide();
       			Ext.getCmp('mandatoryChequeNo').hide();
       			Ext.getCmp('ChequeNoLabId').hide();
       			Ext.getCmp('checkNoComboId').hide();
       			Ext.getCmp('mandatoryJewellary').hide();
       			Ext.getCmp('JewelleryNoLabId').hide();
       			Ext.getCmp('jewellaryComboId').hide();
       			Ext.getCmp('mandatoryForeignCurr').hide();
       			Ext.getCmp('ForeignCurrNoLabId').hide();
       			Ext.getCmp('foreignComboId').hide();
       			Ext.getCmp('customerLabId').hide();  //t4u506
       			Ext.getCmp('customerComboId').hide(); //t4u506
       			Ext.getCmp('deliveryLabId').hide(); //t4u506 
       			Ext.getCmp('deliveryLocComboId').hide(); //t4u506
       			if(rec.data['businessType'] == "ATM Replenishment"){
       				Ext.getCmp('denomFieldSetId').show();
       				Ext.getCmp('denom2000Id').disable();
       				
       				Ext.getCmp('customerLabId').hide();  //t4u506
       				Ext.getCmp('customerComboId').hide(); //t4u506
       				Ext.getCmp('deliveryLabId').hide(); //t4u506 
       				Ext.getCmp('deliveryLocComboId').hide(); //t4u506
       			}
       			else if(rec.data['businessType'] == "Cash Transfer"){
       				Ext.getCmp('customerLabId').show();  //t4u506
       				Ext.getCmp('customerComboId').show(); //t4u506
       				Ext.getCmp('deliveryLabId').show(); //t4u506 
       				Ext.getCmp('deliveryLocComboId').show(); //t4u506
       				Ext.getCmp('denomFieldSetId').hide(); //t4u506
       				
       				
       			} 
       			else{
       				Ext.getCmp('denomFieldSetId').hide();
       				Ext.getCmp('denom2000Id').enable();
       				
       				Ext.getCmp('customerLabId').hide(); //t4u506 
       				Ext.getCmp('customerComboId').hide(); //t4u506
       				Ext.getCmp('deliveryLabId').hide(); //t4u506 
       				Ext.getCmp('deliveryLocComboId').hide(); //t4u506
       			
       			}
            }
            
        }
    }
  }});
	
	//**************************************** Customer Store*************************************//
	
	//****************************t4u506 begin**************************************//
	
	var deliverycustomerStore = new Ext.data.JsonStore({
    	url: '<%=request.getContextPath()%>/cashDispenseAction.do?param=customerId',
    	id: 'customerId',
    	root: 'customerIdRoot',
    	autoLoad: false,
    	fields: ['destCustomerId', 'destCustomerName']
	});
	
	var customerIdCombo = new Ext.form.ComboBox({
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
    cls: 'selectstylePerfect',
    width: 150,
    listeners: {
        select: {
            fn: function() {
            
          
          var custId = Ext.getCmp('customerComboId').getValue();
           deliveryLocationStore.load({
						params:{
						customerId: Ext.getCmp('customerComboId').getValue()
						}
					});
       	          
           } 
        }
    }
  });
	
	
	//****************************t4u506 end***************************************//
	
	//****************************t4u506 begin**************************************//
	
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
    cls: 'selectstylePerfect',
    width: 150,
    listeners: {
        select: {
            fn: function() {
         
       			}
            
           } 
        }
  });
	
	
	//****************************t4u506 end***************************************//
	
	
	//****************************************On Account Store*************************************//
		
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
    	hidden: true,
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
        cls: 'selectstylePerfect',
    	listeners: {
        select: {
            fn: function() {
				globalOnAccOf = Ext.getCmp('onAccComboId').getValue();
				Ext.getCmp('sealedOrCashComboId').reset();
				Ext.getCmp('sealNoComboId').reset();
                Ext.getCmp('checkNoComboId').reset();
                Ext.getCmp('jewellaryComboId').reset();
                Ext.getCmp('foreignComboId').reset();
                Ext.getCmp('denom5000Id').reset();
				Ext.getCmp('denom2000Id').reset();
				Ext.getCmp('denom1000Id').reset();
				Ext.getCmp('denom500Id').reset();
				Ext.getCmp('denom100Id').reset();
				Ext.getCmp('denom50Id').reset();
				Ext.getCmp('denom20Id').reset();
				Ext.getCmp('denom10Id').reset();
				Ext.getCmp('denom5Id').reset();
				Ext.getCmp('denom2Id').reset();
				Ext.getCmp('denom1Id').reset();
            }
        }
    }
 });

	//***************************************Sealed bag or cash store***************************************//
	
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
    	hidden: true,
    	forceSelection: true,
    	emptyText: 'Select Sealed Bag or Cash',
    	blankText: 'Select Sealed Bag or Cash',
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
		cls: 'selectstylePerfect',
    	listeners: {
        select: {
            fn: function() {
            	if(Ext.getCmp('sealedOrCashComboId').getValue().includes("Sealed Bag")){
					sealNostore.load({
						params:{customerId:globalOnAccOf,btn:'Create'}
					});
				}else{
					Ext.getCmp('sealNoComboId').reset();
				}
				if(Ext.getCmp('sealedOrCashComboId').getValue().includes("Cheque")){
					checkNostore.load({
						params:{customerId:globalOnAccOf,btn:'Create'}
					});
				}else{
					Ext.getCmp('checkNoComboId').reset();
				}
				if(Ext.getCmp('sealedOrCashComboId').getValue().includes("Jewellery")){
					jewellarystore.load({
						params:{customerId:globalOnAccOf,btn:'Create'}
					});
				}else{
					Ext.getCmp('jewellaryComboId').reset();
				}
				if(Ext.getCmp('sealedOrCashComboId').getValue().includes("Foreign Currency")){
					foreignstore.load({
						params:{customerId:globalOnAccOf,btn:'Create'}
					});
				}else{
					Ext.getCmp('foreignComboId').reset();
				}
				if(Ext.getCmp('sealedOrCashComboId').getValue().includes("Cash")){
					Ext.getCmp('denomFieldSetId').show();
				}else{
					Ext.getCmp('denomFieldSetId').hide();
					Ext.getCmp('denom5000Id').reset();
					Ext.getCmp('denom2000Id').reset();
					Ext.getCmp('denom1000Id').reset();
					Ext.getCmp('denom500Id').reset();
					Ext.getCmp('denom100Id').reset();
					Ext.getCmp('denom50Id').reset();
					Ext.getCmp('denom20Id').reset();
					Ext.getCmp('denom10Id').reset();
					Ext.getCmp('denom5Id').reset();
					Ext.getCmp('denom2Id').reset();
					Ext.getCmp('denom1Id').reset();
				}
            }
        }
      }
	});
	//**************************************Seal No store*************************************//
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
		hidden: true,
	    forceSelection: true,
	    emptyText: 'Select Seal No',
	    blankText: 'Select Seal No',
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
		cls: 'selectstylePerfect',
		listeners:{
		select: {
		fn: function(){
			
		}
		}
		}
	});
	
	//*******************************************Cheque No store*******************************************//
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
		hidden: true,
	    forceSelection: true,
	    emptyText: 'Select Cheque No',
	    blankText: 'Select Cheque No',
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
		cls: 'selectstylePerfect',
		listeners:{
		select: {
		fn: function(){
			
		}
		}
		}
	});	

	//**********************************************Jewellery store****************************************//
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
		hidden: true,
	    forceSelection: true,
	    emptyText: 'Select Jewellery No',
	    blankText: 'Select Jewellery No',
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
		cls: 'selectstylePerfect',
		listeners:{
		select: {
		fn: function(){
			
		}
		}
		}
	});
	
	//**************************************Foreign currency no store*********************************************//
	
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
		hidden: true,
		mode: 'local',
	    forceSelection: true,
	    emptyText: 'Select Foreign Currency No ',
	    blankText: 'Select Foreign Currency No ',
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
		cls: 'selectstylePerfect',
		listeners:{
		select: {
		fn: function(){
			
		}
		}
		}
	});	
	
   	var innerPanelWindow = new Ext.form.FormPanel({
	    standardSubmit: true,
	    collapsible: false,
	    autoScroll: true,
	    height: 290,
	    width: '100%',
	    frame: true,
	    id: 'custMaster',
	    layout: 'table',
	    layoutConfig: {
	        columns: 4
	    },
	    items: [{
        xtype: 'fieldset',
        title: '',
        cls: 'fieldsetpanel',
        collapsible: false,
        colspan: 3,
        id: 'calibrationpanelid',
        width: '100%',
        layout: 'table',
        border: false,
        layoutConfig: {
            columns: 12
        },   
	    items: [{
            xtype:'label',
            text:'',
            ls:'mandatoryfield',
            id:'label1Id'
            },{
            xtype: 'label',
            text: 'Route Name'+' :',
            cls: 'labelstyle',
            id: 'routeNameLblId'
            },{
            xtype: 'label',
            text: '<%=routeName%>',
            cls: 'labelstyle',
            id: 'routeNameId'
            },{width:20},{
            xtype:'label',
            text:'*',
            cls:'mandatoryfield',
            id:'mandatorybusinesstype'
            },{
            xtype: 'label',
            text: 'Business Id'+' :',
            cls: 'labelstyle',
            id: 'BusinessLabelId'
            },businessIdCombo,{width:20},{
            xtype:'label',
            text:'',
            cls:'mandatoryfield',
            id:'mandatorybusId'
            },{
            xtype: 'label',
            text: 'Business Type'+' :',
            cls: 'labelstyle',
            id: 'BusinessTypeLabelId'
            },{
            xtype: 'label',
            text: '',
            cls: 'labelstyle',
            id: 'businessTypeId'
            },{height:40},{//12
            xtype:'label',
            text:'',
            cls:'mandatoryfield',
            id:'mandatorycust'
            },{
            xtype: 'label',
            text: 'Customer' +' :',
            cls: 'labelstyle',
            id: 'CustomerLabelId'
            },{
            xtype: 'label',
            text: '',
            cls: 'labelstyle',
            id: 'customerId'
            },{width : 20},{
            xtype:'label',
            text:'',
            cls:'mandatoryfield',
            id:'mandatoryhubloc'
            },{
            xtype: 'label',
            text: 'Hub Location'+' :',
            cls: 'labelstyle',
            id: 'HubLocationLblId'
            },{
            xtype: 'label',
           	text: '',
            cls: 'labelstyle',
            id: 'HubLocationId'
			},{width:20},
			{
            xtype:'label',
            text:'',
            hidden: true,
            cls:'mandatoryfield'
            },{
            xtype: 'label',
            text: '',
            cls: 'labelstyle',
            hidden: true
            },{
            xtype: 'textfield',
            text: '',
            hidden: true,
            cls: 'labelstyle',
            readOnly: true,
            id: 'cvsCustomerId'
            },{height:40},
            
            //*********** t4u506 start
           {//12
            xtype:'label',
            text:'',
            cls:'mandatoryfield',
            id:'mandatoryBusinId1'
            },{
            xtype: 'label',
            text: 'Customer Name:',
            cls: 'labelstyle',
            id: 'customerLabId'
            },customerIdCombo,{width:20},{
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'mandatoryBranchId'
            },{
            xtype:'label',
            text:'Delivery Location :',
             cls: 'labelstyle',
            id:'deliveryLabId'
            },deliveryLocIdCombo,{width:30},{},{},{},
			{height:40},
            
            //************** t4u506 end *********
            
            {//24
            xtype:'label',
            text:'',
            hidden: true,
            cls:'mandatoryfield',
            id:'mandatoryaccount'
            },{
            xtype: 'label',
            text: 'On Account Of'+' :',
            cls: 'labelstyle',
            hidden: true,
            id: 'accountOfLblId'
            },onAccCombo,{width:20},{
            xtype:'label',
            text:'',
            hidden: true,
            cls:'mandatoryfield',
            id:'mandatorySealedBag'
            },{
            xtype: 'label',
            text: 'Sealed Bag or Cash'+' :',
            hidden: true,
            cls: 'labelstyle',
            id: 'SealedBagLabId'
            },sealedOrCashCombo,{width:20},{
            xtype:'label',
            text:'',
            hidden: true,
            cls:'mandatoryfield',
            id:'mandatorySealNo'
            },{
            xtype: 'label',
            text: 'Seal No'+' :',
            hidden: true,
            cls: 'labelstyle',
            id: 'SealNoLabId'
            },sealNoComboMultiSelect,{width:20},{
            xtype:'label',
            text:'',
            hidden: true,
            cls:'mandatoryfield',
            id:'mandatoryChequeNo'
            },{
            xtype: 'label',
            text: 'Cheque No'+' :',
            hidden: true,
            cls: 'labelstyle',
            id: 'ChequeNoLabId'
            },checkNoComboMultiSelect,{height:40},{//36
            xtype:'label',
            text:'',
            hidden: true,
            cls:'mandatoryfield',
            id:'mandatoryJewellary'
            },{
            xtype: 'label',
            text: 'Jewellery Ref No'+' :',
            hidden: true,
            cls: 'labelstyle',
            id: 'JewelleryNoLabId'
            },jewellaryComboMultiSelect,{ width : 20},{
            xtype:'label',
            text:'',
            hidden: true,
            cls:'mandatoryfield',
            id:'mandatoryForeignCurr'
            },{
            xtype: 'label',
            text: 'Foreign Currency Ref No'+' :',
            hidden: true,
            cls: 'labelstyle',
            id: 'ForeignCurrNoLabId'
            },fireignComboMultiSelect
		]}, {
            width: 20
        }, {
            xtype: 'fieldset',
            title: '',
            id: 'denomFieldSetId',
            hidden:'true',
            autoHeight: true,
            width: '100%',
            colspan: 3,
            layout: 'table',
            border: false,
            layoutConfig: {
                columns: 12
            },
            items: [{
            xtype: 'label',
            text: '5000'+' :',
            cls: 'labelstyle',
            id: 'val5000LabId'
            },{
            xtype: 'numberfield',
            cls: 'selectstylePerfect',               
            emptyText: 'Enter Value',
            blankText: 'Enter Value',
            id: 'denom5000Id',
            allowBlank: false,
            allowNegative: false
            },{ width : 30 },{
            xtype: 'label',
            text: '2000'+' :',
            cls: 'labelstyle',
            id: 'val2000LabId'
            },{
            xtype: 'numberfield',
            cls: 'selectstylePerfect',               
            emptyText: 'Enter Value',
            blankText: 'Enter Value',
            id: 'denom2000Id',
            allowBlank: false,
            allowNegative: false
            },{ width : 30 },{
            xtype: 'label',
            text: '1000'+' :',
            cls: 'labelstyle',
            id: 'val1000LabId'
            },{
            xtype: 'numberfield',
            cls: 'selectstylePerfect',               
            emptyText: 'Enter Value',
            blankText: 'Enter Value',
            id: 'denom1000Id',
            allowBlank: false,
            allowNegative: false
            },{width:30},{
            xtype: 'label',
            text: '500'+' :',
            cls: 'labelstyle',
            id: 'val500LabId'
            },{
            xtype: 'numberfield',
            cls: 'selectstylePerfect',               
            emptyText: 'Enter Value',
            blankText: 'Enter Value',
            id: 'denom500Id',
            allowBlank: false,
            allowNegative: false
            },{ height : 40 },{
            xtype: 'label',
            text: '100'+' :',
            cls: 'labelstyle',
            id: 'val100LabId'
            },{
            xtype: 'numberfield',
            cls: 'selectstylePerfect',               
            emptyText: 'Enter Value',
            blankText: 'Enter Value',
            id: 'denom100Id',
            allowBlank: false,
            allowNegative: false
            },{ width : 30 },{
            xtype: 'label',
            text: '50'+' :',
            cls: 'labelstyle',
            id: 'val50LabId'
            },{
            xtype: 'numberfield',
            cls: 'selectstylePerfect',               
            emptyText: 'Enter Value',
            blankText: 'Enter Value',
            id: 'denom50Id',
            allowBlank: false,
            allowNegative: false
            },{ width : 30 },{
            xtype: 'label',
            text: '20'+' :',
            cls: 'labelstyle',
            id: 'val20LabId'
            },{
            xtype: 'numberfield',
            cls: 'selectstylePerfect',               
            emptyText: 'Enter Value',
            blankText: 'Enter Value',
            id: 'denom20Id',
            allowBlank: false,
            allowNegative: false
            },{ width : 30 },{
            xtype: 'label',
            text: '10'+' :',
            cls: 'labelstyle',
            id: 'val10LabId'
            },{
            xtype: 'numberfield',
            cls: 'selectstylePerfect',               
            emptyText: 'Enter Value',
            blankText: 'Enter Value',
            id: 'denom10Id',
            allowBlank: false,
            allowNegative: false
            },{ height : 30 },{
            xtype: 'label',
            text: '5'+' :',
            cls: 'labelstyle',
            id: 'val5LabId'
            },{
            xtype: 'numberfield',
            cls: 'selectstylePerfect',               
            emptyText: 'Enter Value',
            blankText: 'Enter Value',
            id: 'denom5Id',
            allowBlank: false,
            allowNegative: false
            },{ width : 30 },{
            xtype: 'label',
            text: '2'+' :',
            cls: 'labelstyle',
            id: 'val2LabId'
            },{
            xtype: 'numberfield',
            cls: 'selectstylePerfect',               
            emptyText: 'Enter Value',
            blankText: 'Enter Value',
            id: 'denom2Id',
            allowBlank: false,
            allowNegative: false
            },{ width : 30 },{
            xtype: 'label',
            text: '1'+' :',
            cls: 'labelstyle',
            id: 'val1LabId'
            },{
            xtype: 'numberfield',
            cls: 'selectstylePerfect',               
            emptyText: 'Enter Value',
            blankText: 'Enter Value',
            id: 'denom1Id',
            allowBlank: false,
            allowNegative: false
              }]
        }, { width: 20}]  
	    
	});

     var winButtonPanel = new Ext.Panel({
        id: 'winbuttonid',
        standardSubmit: true,
        collapsible: false,
        autoHeight: true,
        height: 50,
        width: '100%',
        frame: true,
        layout: 'table',
        layoutConfig: {
            columns: 4
        },
        buttons:[{
            xtype: 'button',
            text: 'Save',
            id: 'addButtId',
            iconCls:'savebutton',
            cls: 'buttonstyle',
            width: 70,
            listeners: {
                click: {
                    fn: function () {
                    	if(Ext.getCmp('businessIdComboId').getValue() == ""){
                    		Ext.example.msg("Please select Business Id");
                       		return;
                       	}
                       	if (globalbusinessType == "ATM Replenishment") {
				           if (Ext.getCmp('denom5000Id').getValue() == 0 && Ext.getCmp('denom5000Id').getValue() == 0 && Ext.getCmp('denom1000Id').getValue() == 0 && Ext.getCmp('denom500Id').getValue() == 0
				           		&& Ext.getCmp('denom100Id').getValue() == 0 && Ext.getCmp('denom50Id').getValue() == 0 && Ext.getCmp('denom20Id').getValue() == 0 && Ext.getCmp('denom10Id').getValue() == 0
				           		&& Ext.getCmp('denom5Id').getValue() == 0 && Ext.getCmp('denom2Id').getValue() == 0 && Ext.getCmp('denom1Id').getValue() == 0) {
				               Ext.example.msg("Please enter at least one note value");
				               return false;
				           }
				       }
				       if (globalbusinessType == "Cash Delivery") {
				           if (Ext.getCmp('onAccComboId').getValue() == "") {
				               Ext.example.msg("Please select On Account of");
				               return false;
				           }
				           if (Ext.getCmp('sealedOrCashComboId').getValue() == "") {
				           	Ext.example.msg("Please select Sealed Bag or Cash");
				           	return false;
				       	}
				       	if (Ext.getCmp('sealedOrCashComboId').getValue().includes("Sealed Bag")) {
				            if (Ext.getCmp('sealNoComboId').getValue() == "") {
				                Ext.example.msg("Please select Seal No");
				                return false;
				            }
				       	}
				       	if (Ext.getCmp('sealedOrCashComboId').getValue().includes("Cash")) {
				            if (Ext.getCmp('denom5000Id').getValue() == 0 && Ext.getCmp('denom5000Id').getValue() == 0 && Ext.getCmp('denom1000Id').getValue() == 0 && Ext.getCmp('denom500Id').getValue() == 0
				           		&& Ext.getCmp('denom100Id').getValue() == 0 && Ext.getCmp('denom50Id').getValue() == 0 && Ext.getCmp('denom20Id').getValue() == 0 && Ext.getCmp('denom10Id').getValue() == 0
				           		&& Ext.getCmp('denom5Id').getValue() == 0 && Ext.getCmp('denom2Id').getValue() == 0 && Ext.getCmp('denom1Id').getValue() == 0 && Ext.getCmp('denom2000Id').getValue() == 0) {
				                Ext.example.msg("Please enter at least one note value");
				                return false;
				            }
				       	}
				       	if (Ext.getCmp('sealedOrCashComboId').getValue().includes("Cheque")) {
				            if (Ext.getCmp('checkNoComboId').getValue() == "") {
				                Ext.example.msg("Please select cheque number");
				                return false;
				            }
				       	}
				       	if (Ext.getCmp('sealedOrCashComboId').getValue().includes("Jewellery")) {
				            if (Ext.getCmp('jewellaryComboId').getValue() == "") {
				                Ext.example.msg("Please select jewellery ref number");
				                return false;
				            }
				       	}
				       	if (Ext.getCmp('sealedOrCashComboId').getValue().includes("Foreign Currency")) {
				            if (Ext.getCmp('foreignComboId').getValue() == "") {
				                Ext.example.msg("Please select foreign currency ref number");
				                return false;
				            }
				       	}
				       	}
				       	
				       	//--------------t4u506 begin---------------------------------------//
				       	
				       	if (globalbusinessType == "Cash Transfer") {
				           if (Ext.getCmp('customerComboId').getValue() == "") {
				            {
				               Ext.example.msg("Please Select Customer Name");
				               return false;
				           }
				           }
				           if (Ext.getCmp('deliveryLocComboId').getValue() == "") {
				            {
				               Ext.example.msg("Please Select Customer Delivery Location");
				               return false;
				           }}
				           
				       }
				      //--------------t4u506 end---------------------------------------//
						outerPanel.getEl().mask();
						Ext.Ajax.request({
						url:'<%=request.getContextPath()%>/cashDispenseAction.do?param=insertNewBusiness',
						method: 'POST',
						params:{
						routeId : '<%=routeId%>',
						tripSheetNo: '<%=tripSheetNo%>',
						date: '<%=date%>',
						businessType: globalbusinessType,
						businessId: Ext.getCmp('businessIdComboId').getValue(),
						cvsCustomerId: Ext.getCmp('cvsCustomerId').getValue(),
						cvsCustomerName: globalCustomerName,
						//------------t4u506 begin------------------------------------//
						customerId: Ext.getCmp('businessIdComboId').getValue(),
						deliveryLocationId: Ext.getCmp('deliveryLocComboId').getValue(),						
						//------------t4u506 end------------------------------------//
						onAccOf: Ext.getCmp('onAccComboId').getValue(),
						onAccName: Ext.getCmp('onAccComboId').getRawValue(),
						sealOrCash: Ext.getCmp('sealedOrCashComboId').getValue(),
						sealNo : Ext.getCmp('sealNoComboId').getValue(),
						chequeNo: Ext.getCmp('checkNoComboId').getValue(),
						jewelleryNo: Ext.getCmp('jewellaryComboId').getValue(),
						foreignCurrencyNo: Ext.getCmp('foreignComboId').getValue(),
						denom5000: Ext.getCmp('denom5000Id').getValue(),
						denom2000: Ext.getCmp('denom2000Id').getValue(),
						denom1000: Ext.getCmp('denom1000Id').getValue(),
						denom500: Ext.getCmp('denom500Id').getValue(),
						denom100: Ext.getCmp('denom100Id').getValue(),
						denom50: Ext.getCmp('denom50Id').getValue(),
						denom20: Ext.getCmp('denom20Id').getValue(),
						denom10: Ext.getCmp('denom10Id').getValue(),
						denom5: Ext.getCmp('denom5Id').getValue(),
						denom2: Ext.getCmp('denom2Id').getValue(),
						denom1: Ext.getCmp('denom1Id').getValue()
						},
						success: function(response, options){
							var msg = response.responseText; 
							if(msg.trim() == "Success"){
        						parent.Ext.example.msg("Cash Dispensed Successfuly...");
								outerPanel.getEl().unmask();
								grid.store.reload();
								myWin.hide();
        					}else{
								parent.Ext.example.msg(response.responseText);
							}
						},
						failure: function(){
							outerPanel.getEl().unmask();
							grid.store.reload();
							myWin.hide();
						}
					});	
                    }
                }
            }

        }, {
            xtype: 'button',
            text: 'Cancel',
            id: 'canButtId',
            iconCls:'cancelbutton',
            cls: 'buttonstyle',
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

   	 var outerPanelWindow = new Ext.Panel({
        width: '100%',
        height:400,
        standardSubmit: true,
        frame: false,
        items: [innerPanelWindow, winButtonPanel]
    });

	myWin = new Ext.Window({
        closable: false,
        resizable:false,
        modal: true,
        autoScroll: false,
        title:'Add Dispense Details',
        height: 400,
        width: 1060,
        id: 'myWin',
        items: [outerPanelWindow]
    });

function addRecord() {
    buttonValue = "add";
    myWin.show();
    Ext.getCmp('businessIdComboId').reset();
    Ext.getCmp('businessTypeId').setText('');
    Ext.getCmp('customerId').setText('');
    Ext.getCmp('cvsCustomerId').reset();
    Ext.getCmp('HubLocationId').setText('');
    Ext.getCmp('onAccComboId').reset();
 	Ext.getCmp('sealedOrCashComboId').reset();
	Ext.getCmp('sealNoComboId').reset();
    Ext.getCmp('checkNoComboId').reset();
    Ext.getCmp('jewellaryComboId').reset();
    Ext.getCmp('foreignComboId').reset();
	Ext.getCmp('denom5000Id').reset();
	Ext.getCmp('denom2000Id').reset();
	Ext.getCmp('denom1000Id').reset();
	Ext.getCmp('denom500Id').reset();
	Ext.getCmp('denom100Id').reset();
	Ext.getCmp('denom50Id').reset();
	Ext.getCmp('denom20Id').reset();
	Ext.getCmp('denom10Id').reset();
	Ext.getCmp('denom5Id').reset();
	Ext.getCmp('denom2Id').reset();
	Ext.getCmp('denom1Id').reset();
	//----------------------------t4u506 begin-------------------------------//
	Ext.getCmp('customerComboId').reset();
	Ext.getCmp('deliveryLocComboId').reset();
	//----------------------------t4u506 end-------------------------------//
   	businessIdStore.load({params:{routeId: <%=routeId%>, tripSheetNo: '<%=tripSheetNo%>'}});
   	//-------------t4u506 begin--//
   	   	deliverycustomerStore.load({params:{customerId: <%=customerId%>}});
   	   	//-------------t4u506 end--//
   	   	Ext.getCmp('customerLabId').hide(); //t4u506 
       	Ext.getCmp('customerComboId').hide(); //t4u506
       	Ext.getCmp('deliveryLabId').hide(); //t4u506 
        Ext.getCmp('deliveryLocComboId').hide(); //t4u506
}

function deleteData() {
    grid.store.reload();
}

grid.on({
    afteredit: function(e) {
}
});

function onCellClick(grid, rowIndex, columnIndex, e) {

    	   		grid.getColumnModel().config[columnIndex].editable = false;
    	   
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
    return returnValue;
}
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
        height: 410,
        width: screen.width - 72,
        items: [Panel, grid]
    });

Ext.getCmp('tripSheetNoTextId').setValue('<%=tripSheetNo%>');
Ext.getCmp('tripNoTextId').setValue('<%=tripNo%>');
Ext.getCmp('dateId').setValue('<%=date%>');
Ext.getCmp('routeTextlId').setValue('<%=routeName%>');
    store.load({
    	params:{
    		tripSheetNo: '<%=tripSheetNo%>',
    		routeId: '<%=routeId%>',
    		date: '<%=date%>',
    		btnValue: '<%=btnValue%>'
    	}
    	});
    	
    	var cm = grid.getColumnModel();  
    for (var j = 1; j < cm.getColumnCount(); j++) {
       cm.setColumnWidth(j,120);
    }
});

if(JournalAuthority == '1'){
	Ext.getCmp('journalAddId').enable();
}else{
	Ext.getCmp('journalAddId').disable();
}
if(CashAuthority == '1'){
	Ext.getCmp('physicalCashAddId').enable();
}else{
	Ext.getCmp('physicalCashAddId').disable();
}
if(ReconcileAuthority == '1'){
	Ext.getCmp('reconcileId').enable();
}else{
	Ext.getCmp('reconcileId').disable();
}

</script>
</body>
</html>
<%}%>
