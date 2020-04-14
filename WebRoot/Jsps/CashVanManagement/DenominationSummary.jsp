<%@ page language="java"
	import="java.util.*,java.text.SimpleDateFormat,t4u.functions.*,t4u.beans.*,t4u.common.*"
	pageEncoding="utf-8"%>
	
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
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
	String responseafterview="''";
	String feature="1";
	if(session.getAttribute("responseafterview")!=null){
	   responseafterview="'"+session.getAttribute("responseafterview").toString()+"'";
		session.setAttribute("responseafterview",null);
	}
		
    LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
    
 if(loginInfo==null){
	response.sendRedirect(request.getContextPath()+ "/Jsps/Common/SessionDestroy.html");
}
  
	String language = loginInfo.getLanguage();
	int systemId = loginInfo.getSystemId();
	int customerId = loginInfo.getCustomerId();
	String username = loginInfo.getUserName();

String SelectDate="Select_Date";
String AssetName="Asset_Name";
String SelectVendor="Select_Vendor";
String Date="Date";
String SLNO="SLNO";
String QRCode="QR_Code";
String AssetNumber="Asset_Number";
String VendorName="Vendor_Name";
String BranchName="Branch_Name";
String NoRecordsFound="No_Records_Found";
String Excel="Excel";
int cvsCustIdStr = 0;

 if(request.getParameter("CVSCustId") != null && !request.getParameter("CVSCustId").equals("")){
 cvsCustIdStr =  Integer.parseInt(request.getParameter("CVSCustId"));
 }
System.out.println("cvsCustIdStr == "+cvsCustIdStr);
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <base href="<%=basePath%>">
    
    <title>Inward Stationary</title>
    
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	<!--
	<link rel="stylesheet" type="text/css" href="styles.css">
	-->

  </head>
 <style>
.x-panel-tl {
	border-bottom: 0px solid !important;
} 
</style>
	<body>
	
  <%if (loginInfo.getStyleSheetOverride().equals("Y")){%>
	<jsp:include page="../Common/ImportJSSandMining.jsp"/>
	
	<%}else {%>
	<jsp:include page="../Common/ImportJS.jsp" />
	
	<%} %>
		<jsp:include page="../Common/ExportJS.jsp" />
	<script>
    var outerPanel;
    var dtprev = dateprev;
    var dtcur = datecur;
    var dtnxt = datenext;
    var jspName = "Inward Stationary";
    var exportDataType = "int,string,string";
    var grid;
    var addPlant = 0;
    var Plant;
    var datajson = '';

    var reader = new Ext.data.JsonReader({
        root: 'rows',
      
         fields: [{
                name: 'DenominationDataIndex',
                type: 'int'
            }, {
                name: 'GoodNoOfNotesDataIndex',
                type: 'int'
            }, {
                name: 'GoodValueDataIndex',
                type: 'int'
            }, {
                name: 'BadNoOfNotesDataIndex',
                type: 'int'
            },{
                name: 'BadValueDataIndex',
                type: 'int'
            }, {
                name: 'SoiledNoOfNotesDataIndex',
                type: 'int'
            }, {
                name: 'SoiledValueDataIndex',
                type: 'int'
            }, {
                name: 'CounterfeitNoOfNotesDataIndex',
                type: 'int'
            },{
                name: 'CounterfeitValueDataIndex',
                type: 'int'
            },{
            name:'TotalAmountDataIndex',
            type: 'int'
            }

        ]
    });

   var reader2 = new Ext.data.JsonReader({
        root: 'rowsForSealBag',
      
         fields: [{
                name: 'SealBagAmount1',
                type: 'string'
            }, {
                name: 'SealBagAmount2',
                type: 'string'
            }, {
                name: 'SealBagAmount3',
                type: 'string'
            }

        ]
    });


    var dataStoreForGrid = new Ext.data.GroupingStore({
        url: '<%=request.getContextPath()%>/CashInwardAction.do?param=getGridForSummary',
        bufferSize: 367,
        reader: reader,
        root: 'rows',
        autoLoad: false,
        remoteSort: true
    });

  var dataStoreForGrid2 = new Ext.data.GroupingStore({
        url: '<%=request.getContextPath()%>/CashInwardAction.do?param=getGridForSummaryForSealBag',
        bufferSize: 367,
        reader: reader2,
        root: 'rowsForSealBag',
        autoLoad: false,
        remoteSort: true
    });

    function getcmnmodel() {
        toolGridColumnModel = new Ext.grid.ColumnModel(
            [
                new Ext.grid.RowNumberer({
                    header: '<B>SLNO</B>',
                    width: 45,
                    hidden:true
                }), {
                    header: '<B>Denominations</B>',
                    sortable: true,
                    width: 110,
                    dataIndex: 'DenominationDataIndex',
                    editable: false

                }, {
                    header: '<B>Good No Of Notes</B>',
                    width: 90,
                    dataIndex: 'GoodNoOfNotesDataIndex',
                     editable: false
                },{
                    header: '<B>Value</B>',
                    width: 90,
                    dataIndex: 'GoodValueDataIndex',
                      editable: false
                

                }, {
                    header: '<B>Damaged No Of Notes</B>',
                    width: 90,
                    dataIndex: 'BadNoOfNotesDataIndex',
                      editable: false
                   
                }, {
                    header: '<B>Value</B>',
                    width: 90,
                    dataIndex: 'BadValueDataIndex',
                      editable: false
                }, {
                    header: '<B>Soiled No Of Notes</B>',
                    width: 90,
                    dataIndex: 'SoiledNoOfNotesDataIndex',
                      editable: false
                },{
                    header: '<B>Value</B>',
                    width: 90,
                    dataIndex: 'SoiledValueDataIndex',
                      editable: false
                

                }, {
                    header: '<B>Counterfeit No Of Notes</B>',
                    width: 90,
                    dataIndex: 'CounterfeitNoOfNotesDataIndex',
                      editable: false

                   
                }, {
                    header: '<B>Value</B>',
                    width: 90,
                    dataIndex: 'CounterfeitValueDataIndex',
                      editable: false
                   
                },{
                    header: '<B>Total Amount</B>',
                    width: 90,
                    dataIndex: 'TotalAmountDataIndex',
                    editable: false
                }
            ]);
        return toolGridColumnModel;
    }

  function getcmnmodel2() {
        toolGridColumnModel = new Ext.grid.ColumnModel(
            [
                new Ext.grid.RowNumberer({
                    header: '<B>SLNO</B>',
                    width: 45,
                    hidden:true
                }), {
                    header: '<B>Seal Bag - Amount - Remarks</B>',
                    sortable: true,
                    width: 300,
                    dataIndex: 'SealBagAmount1',
                    editable: false

                }, {
                    header: '<B>Seal Bag - Amount - Remarks</B>',
                    width: 300,
                    dataIndex: 'SealBagAmount2',
                     editable: false
                },{
                    header: '<B>Seal Bag - Amount - Remarks</B>',
                    width: 300,
                    dataIndex: 'SealBagAmount3',
                      editable: false
                

                }
            ]);
        return toolGridColumnModel;
    }



    var AssetGrid = new Ext.grid.EditorGridPanel({
        
        id: 'toolGridid',
        ds: dataStoreForGrid,
        cm: getcmnmodel(),
        stripeRows: true,
        border: true,
        width: 950,
        height: 410,
        autoScroll: true,
        // plugins: [filters],
        clicksToEdit: 1,
        selModel: new Ext.grid.RowSelectionModel(),
        tbar: []
    });




var sealBagGrid = new Ext.grid.EditorGridPanel({
        
        id: 'sealBagGrid',
        ds: dataStoreForGrid2,
        cm: getcmnmodel2(),
        stripeRows: true,
        border: true,
        width: 950,
        autoHeight: true,
        autoScroll: true,
        // plugins: [filters],
        clicksToEdit: 1,
        selModel: new Ext.grid.RowSelectionModel(),
        tbar: []
    });
    
    
    

var reader3 = new Ext.data.JsonReader({
        root: 'rowsForJewellery',
      
         fields: [{
                name: 'JewelleryAmount1',
                type: 'string'
            }, {
                name: 'JewelleryAmount2',
                type: 'string'
            }, {
                name: 'JewelleryAmount3',
                type: 'string'
            }

        ]
    });

 var dataStoreForGrid3 = new Ext.data.GroupingStore({
        url: '<%=request.getContextPath()%>/CashInwardAction.do?param=getGridForSummaryForJewellery',
        bufferSize: 367,
        reader: reader3,
        root: 'rowsForJewellery',
        autoLoad: false,
        remoteSort: true
    });

  function getcmnmodel3() {
        toolGridColumnModel = new Ext.grid.ColumnModel(
            [
                new Ext.grid.RowNumberer({
                    header: '<B>SLNO</B>',
                    width: 45,
                    hidden:true
                }), {
                    header: '<B>Jewellery Ref No - Amount</B>',
                    sortable: true,
                    width: 300,
                    dataIndex: 'JewelleryAmount1',
                    editable: false

                }, {
                    header: '<B>Jewellery Ref No - Amount</B>',
                    width: 300,
                    dataIndex: 'JewelleryAmount2',
                     editable: false
                },{
                    header: '<B>Jewellery Ref No - Amount</B>',
                    width: 300,
                    dataIndex: 'JewelleryAmount3',
                      editable: false
                

                }
            ]);
        return toolGridColumnModel;
    }

var jewelleryGrid = new Ext.grid.EditorGridPanel({
        
        id: 'jewelleryGrid',
        ds: dataStoreForGrid3,
        cm: getcmnmodel3(),
        stripeRows: true,
        border: true,
        width: 950,
        autoHeight:true,
        autoScroll: true,
        // plugins: [filters],
        clicksToEdit: 1,
        selModel: new Ext.grid.RowSelectionModel(),
        tbar: []
    });


 var reader4 = new Ext.data.JsonReader({
        root: 'rowsForCheck',
      
         fields: [{
                name: 'CheckAmount1',
                type: 'string'
            }, {
                name: 'CheckAmount2',
                type: 'string'
            }, {
                name: 'CheckAmount3',
                type: 'string'
            }

        ]
    });

 var dataStoreForGrid4= new Ext.data.GroupingStore({
        url: '<%=request.getContextPath()%>/CashInwardAction.do?param=getGridForSummaryForCheck',
        bufferSize: 367,
        reader: reader4,
        root: 'rowsForCheck',
        autoLoad: false,
        remoteSort: true
    });

  function getcmnmodel4() {
        toolGridColumnModel = new Ext.grid.ColumnModel(
            [
                new Ext.grid.RowNumberer({
                    header: '<B>SLNO</B>',
                    width: 45,
                    hidden:true
                }), {
                    header: '<B>Check No - Amount</B>',
                    sortable: true,
                    width: 300,
                    dataIndex: 'CheckAmount1',
                    editable: false

                }, {
                    header: '<B>Check No - Amount</B>',
                    width: 300,
                    dataIndex: 'CheckAmount2',
                     editable: false
                },{
                    header: '<B>Check No - Amount</B>',
                    width: 300,
                    dataIndex: 'CheckAmount3',
                      editable: false
                

                }
            ]);
        return toolGridColumnModel;
    }

var checkGrid = new Ext.grid.EditorGridPanel({
        
        id: 'jcheckGrid',
        ds: dataStoreForGrid4,
        cm: getcmnmodel4(),
        stripeRows: true,
        border: true,
        width: 950,
        autoHeight:true,
        autoScroll: true,
        // plugins: [filters],
        clicksToEdit: 1,
        selModel: new Ext.grid.RowSelectionModel(),
        tbar: []
    });

 var reader5 = new Ext.data.JsonReader({
        root: 'rowsForForex',
      
         fields: [{
                name: 'ForexAmount1',
                type: 'string'
            }, {
                name: 'ForexAmount2',
                type: 'string'
            }, {
                name: 'ForexAmount3',
                type: 'string'
            }

        ]
    });

 var dataStoreForGrid5= new Ext.data.GroupingStore({
        url: '<%=request.getContextPath()%>/CashInwardAction.do?param=getGridForSummaryForForex',
        bufferSize: 367,
        reader: reader5,
        root: 'rowsForForex',
        autoLoad: false,
        remoteSort: true
    });

  function getcmnmodel5() {
        toolGridColumnModel = new Ext.grid.ColumnModel(
            [
                new Ext.grid.RowNumberer({
                    header: '<B>SLNO</B>',
                    width: 45,
                    hidden:true
                }), {
                    header: '<B>Foreign Currency - Amount - Code</B>',
                    sortable: true,
                    width: 300,
                    dataIndex: 'ForexAmount1',
                    editable: false

                }, {
                    header: '<B>Foreign Currency - Amount - Code</B>',
                    width: 300,
                    dataIndex: 'ForexAmount2',
                     editable: false
                },{
                    header: '<B>Foreign Currency - Amount - Code</B>',
                    width: 300,
                    dataIndex: 'ForexAmount3',
                      editable: false
                

                }
            ]);
        return toolGridColumnModel;
    }

var forexGrid = new Ext.grid.EditorGridPanel({
        
        id: 'forexGrid',
        ds: dataStoreForGrid5,
        cm: getcmnmodel5(),
        stripeRows: true,
        border: true,
        width: 950,
        autoHeight:true,
        autoScroll: true,
        // plugins: [filters],
        clicksToEdit: 1,
        selModel: new Ext.grid.RowSelectionModel(),
        tbar: []
    });

    
    
  
 var clientPanel234 = new Ext.Panel({
        standardView: true,
        collapsible: false,
        id: 'clientPanelId1234',
        layout: 'table',
        frame: false,
        border: false,
        width:950,
        height:10
    });

	var printPanel = new Ext.Panel({
		standardView: true,
        collapsible: false,
        id: 'printPanelId',
        layout: 'table',
        frame: false,
        border: false,
        layoutConfig: {
        	columns: 1
        },
        items:[{
        xtype: 'button',
        text: 'Print',
        cls: 'bskExtStyle',
        listeners: {
        click: {
        	fn: function () {
    		var jsonDenom = '';
        	for (var i = 0; i < AssetGrid.getStore().data.length; i++) {
            var record = AssetGrid.getStore().getAt(i);      
            jsonDenom += Ext.util.JSON.encode(record.data) + ',';
        	}
        	var jsonSb = '';
        	for (var i = 0; i < sealBagGrid.getStore().data.length; i++) {
            var record = sealBagGrid.getStore().getAt(i);      
            jsonSb += Ext.util.JSON.encode(record.data) + ',';
        	}
        	var jsonJw = '';
        	for (var i = 0; i < jewelleryGrid.getStore().data.length; i++) {
            var record = jewelleryGrid.getStore().getAt(i);      
            jsonJw += Ext.util.JSON.encode(record.data) + ',';
        	}
        	var jsonChq = '';
        	for (var i = 0; i < checkGrid.getStore().data.length; i++) {
            var record = checkGrid.getStore().getAt(i);      
            jsonChq += Ext.util.JSON.encode(record.data) + ',';
        	}
        	var jsonFx = '';
        	for (var i = 0; i < forexGrid.getStore().data.length; i++) {
            var record = forexGrid.getStore().getAt(i);      
            jsonFx += Ext.util.JSON.encode(record.data) + ',';
        	}
        	Ext.Ajax.request({
        	url: '<%=request.getContextPath()%>/CashInwardAction.do?param=setGridData',
            method: 'POST',
            params: {
            	jsonDenom: jsonDenom,
                jsonSb : jsonSb,
                jsonJw : jsonJw,
                jsonChq : jsonChq,
                jsonFx : jsonFx
            },
            success: function(response, options) {
            	var message = response.responseText;
            	if(message.trim() == "true"){
            		parent.open("<%=request.getContextPath()%>/pdfForVaultInventory?cvsCustId=<%=cvsCustIdStr%>");
			  		jsonDenom = '';
            	}
			},
            failure: function() {
		   		jsonDenom = '';
            }
        });
        }
        }
        }	
        }]
	});
    Ext.onReady(function() {
        Ext.QuickTips.init();
        Ext.Ajax.timeout = 180000;
        Ext.form.Field.prototype.msgTarget = 'side';
        outerPanel = new Ext.Panel({
            renderTo: 'content',
            id: 'outerPanel',
            standardView: true,
            autoScroll: true,
            frame: true,
            border: false,
            width: 980,
            height: 410,
            layout: 'table',
            cls: 'outerpanel',
            layoutConfig: {
                columns: 1
            },
            items: [printPanel,AssetGrid,clientPanel234,sealBagGrid,checkGrid,jewelleryGrid,forexGrid]
        });
 dataStoreForGrid.load({
  params:{
 CvsCustId:<%=cvsCustIdStr%>,
  
  
  } 
  });  
  dataStoreForGrid2.load({
  params:{
 CvsCustId:<%=cvsCustIdStr%>,
  
  
  } 
  }); 
  
   dataStoreForGrid3.load({
  params:{
 CvsCustId:<%=cvsCustIdStr%>,
  
  
  } 
  }); 
  
   dataStoreForGrid4.load({
  params:{
 CvsCustId:<%=cvsCustIdStr%>,
  
  
  } 
  }); 
  
   dataStoreForGrid5.load({
  params:{
 CvsCustId:<%=cvsCustIdStr%>,
  
  
  } 
  }); 
  
    });
</script>
	</body>
</html>
