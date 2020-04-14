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
  
	int systemId = loginInfo.getSystemId();
		int customerId = loginInfo.getCustomerId();
		int UniqueId = 0;
		if(request.getParameter("UniqueId") != null && !request.getParameter("UniqueId").equals("")){
		UniqueId = Integer.parseInt(request.getParameter("UniqueId"));
		}
		String tripSheetNo = request.getParameter("TripSheetNo");
		String customer = "";
		String sealNo = "";
		String totalAmount = "";
		String date = "";
		String customerType="";
		String atmId = ""; 
		String tripNo ="";
		String cashType = "";
	    String routeId = "0";
	    String cvsCustIds = "";
	    int cvsCustId = 0;
	    String cashSealNo = "";
		CashVanManagementFunctions cvmFunc = new CashVanManagementFunctions();		
		ArrayList<String> dataList = cvmFunc.getDataForReconcilation(systemId,customerId,tripSheetNo,UniqueId);
		if(dataList.size() > 0){
		 customer = dataList.get(0);
		 sealNo = dataList.get(1);
		 totalAmount = dataList.get(2);
		 date =dataList.get(3);
		 customerType=dataList.get(4);
		 atmId = dataList.get(5); 
		 tripNo =dataList.get(6);
		 cashType = dataList.get(7);
         routeId  = dataList.get(9);
         cvsCustIds = dataList.get(8);
         cvsCustId = Integer.parseInt(cvsCustIds);
         cashSealNo = dataList.get(13);
		}
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
String buttonValue ="Reconcilation";

%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <base href="<%=basePath%>">
    
    <title>Reconcilation</title>
    
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
   var actionRequired = '#E56B6B';
   var gray = '#808080';
   var white = '#ffffff';
   var  buttonValue = '<%=buttonValue%>';
var InwardId = "";
var cvsCustId; 
var custIdFromParent = 0;
var buttonValue2;
var inwardId2;
var cvsCustIDFromParent2 = 0;
var totalAmount = "0";
var checkBoxType = "";
var KeyPressed = "No";

function ajaxfunction() {
	if(Ext.getCmp("CheckboxId").checked == false && Ext.getCmp("Checkbox2Id").checked == false && Ext.getCmp("CheckboxId3").checked == false
		&& Ext.getCmp("Checkbox2Id4").checked == false && Ext.getCmp("CheckboxId5").checked == false){
		Ext.example.msg("No inwad type had selected");
	    Ext.getCmp('ViewtButtId').enable();
	    return;
	}

    var json = '';
    for (var i = 0; i < AssetGrid.getStore().data.length; i++) {
        var element = Ext.get(AssetGrid.getView().getRow(i));
        var record = AssetGrid.getStore().getAt(i);        
        json += Ext.util.JSON.encode(record.data) + ',';
    }
	datajson = json;
	if (datajson != '') {
    	if( Ext.getCmp("Checkbox2Id").checked == true ){
			checkBoxType = checkBoxType+","+'CASH';
		}
		if (Ext.getCmp("CheckboxId").checked == true) {
			checkBoxType = checkBoxType+","+'SEALED BAG';
		}
		callAjaxRequest();
	} else {
        Ext.example.msg("Please Enter Data And Try To Save");
    }
}

function callAjaxRequest(){

  Ext.Ajax.request({
                url: '<%=request.getContextPath()%>/CashInwardAction.do?param=SaveForReconcilation',
                method: 'POST',
                params: {
                   
                    datajson: datajson,
                   TripSheetNo:'<%=tripSheetNo%>',
                   UniqueId:<%=UniqueId%>,
                   checkBoxType : checkBoxType,
                   TotalAmount: totalAmount,
                   KeyPressed :KeyPressed,
                   CashSealNo : Ext.getCmp('cashSealNoId').getValue()
                },
                success: function(response, options) {
                    var message = response.responseText;
                    parent.Ext.example.msg(message); 
                   	 parent.store.load({
    	params:{
    		tripSheetNo: '<%=tripSheetNo%>',
    		routeId: '<%=routeId%>',
    		date: '<%=date%>',
    		btnValue: 'Create'
    	}
    	});
    	// Ext.getCmp('ViewtButtId').enable();
    	
			 parent.myWin3.close();
			  
		   
                    datajson = '';

                },
                failure: function() {
                    Ext.example.msg("Error");
                   	
			 parent.store.load({
    	params:{
    		tripSheetNo: '<%=tripSheetNo%>',
    		routeId: '<%=routeId%>',
    		date: '<%=date%>',
    		btnValue: 'Create'
    	}
    	});  
    	// Ext.getCmp('ViewtButtId').enable();
    	
			 parent.myWin3.close();
		   
                    datajson = '';
                    
                }
            });

}

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

    var dataStoreForGrid = new Ext.data.GroupingStore({
        url: '<%=request.getContextPath()%>/CashInwardAction.do?param=getGrid',
        bufferSize: 367,
        reader: reader,
        root: 'rows',
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
                     editable: true,
                    editor: new Ext.grid.GridEditor(new Ext.form.NumberField({
                        width: 90,
                        allowDecimals:false,
                                   allowNegative:false,              
                               
                        cls: 'bskExtStyle'
                    }))
                },{
                    header: '<B>Value</B>',
                    width: 90,
                    dataIndex: 'GoodValueDataIndex',
                      editable: false
                

                }, {
                    header: '<B>Damaged No Of Notes</B>',
                    width: 90,
                    dataIndex: 'BadNoOfNotesDataIndex',
                      editable: true,
                    editor: new Ext.grid.GridEditor(new Ext.form.NumberField({
                        width: 90,
                         allowDecimals:false,
                                    allowNegative:false,              
                 
                        cls: 'bskExtStyle'
                    }))
                   
                }, {
                    header: '<B>Value</B>',
                    width: 90,
                    dataIndex: 'BadValueDataIndex',
                      editable: false
                }, {
                    header: '<B>Soiled No Of Notes</B>',
                    width: 90,
                    dataIndex: 'SoiledNoOfNotesDataIndex',
                      editable: true,
                    editor: new Ext.grid.GridEditor(new Ext.form.NumberField({
                        width: 90,
                         allowDecimals:false, 
                        cls: 'bskExtStyle'
                    }))
                   
                },{
                    header: '<B>Value</B>',
                    width: 90,
                    dataIndex: 'SoiledValueDataIndex',
                      editable: false
                

                }, {
                    header: '<B>Counterfeit No Of Notes</B>',
                    width: 90,
                    dataIndex: 'CounterfeitNoOfNotesDataIndex',
                      editable: true,
                    editor: new Ext.grid.GridEditor(new Ext.form.NumberField({
                        width: 90,
                         allowDecimals:false,
                                    allowNegative:false,              
                 
                        cls: 'bskExtStyle'
                    }))
                   
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



    var AssetGrid = new Ext.grid.EditorGridPanel({
        
        id: 'toolGridid',
        ds: dataStoreForGrid,
        cm: getcmnmodel(),
        stripeRows: true,
        border: true,
        width: 950,
        height: 190,
        autoScroll: true,
        // plugins: [filters],
        clicksToEdit: 1,
        selModel: new Ext.grid.RowSelectionModel(),
        tbar: []
    });


var UGrid = function() {
                                            return {
                                                init: function() {
                                                   AssetGrid.on({
                                                        "cellclick": {
                                                            fn: onCellClick
                                                        }
                                                    });
                                                }
                                            }
                                        }();
                                        
                                    function  onCellClick (grid, rowIndex, columnIndex, e){
if( Ext.getCmp("Checkbox2Id").checked == true  ){
                                               AssetGrid.getColumnModel().config[columnIndex].editable = true;
                                             }
                                    }

    AssetGrid.on({
        beforeedit: function(e) {
		
        },
        afteredit: function(e) {
		var value= 0;
            var field = e.field;
            var denomination  = e.record.data['DenominationDataIndex'];
        
         if( field == "GoodNoOfNotesDataIndex" ){
		if(e.record.data['GoodNoOfNotesDataIndex'] == ""){
		 e.record.set('GoodNoOfNotesDataIndex',0);
		}
	 if(denomination == '5000'){
	 value = e.record.data['GoodNoOfNotesDataIndex'] * 5000;	 
 }else if(denomination == '2000'){
	 value = e.record.data['GoodNoOfNotesDataIndex'] * 2000;	 
 }else if(denomination == '1000'){
	 value = e.record.data['GoodNoOfNotesDataIndex'] * 1000;	 
 }else if(denomination == '500'){
	 value = e.record.data['GoodNoOfNotesDataIndex'] * 500;	 
 }else if(denomination == '100'){
	 value = e.record.data['GoodNoOfNotesDataIndex'] * 100;	 
 }else if(denomination == '50'){
	 value = e.record.data['GoodNoOfNotesDataIndex'] * 50;	 
 }else if(denomination == '20'){
	 value = e.record.data['GoodNoOfNotesDataIndex'] * 20;	 
 }else if(denomination == '10'){
	 value = e.record.data['GoodNoOfNotesDataIndex'] * 10;	 
 }else if(denomination == '5'){
	 value = e.record.data['GoodNoOfNotesDataIndex'] * 5;	 
 }else if(denomination == '2'){
	 value = e.record.data['GoodNoOfNotesDataIndex'] * 2;	 
 }else if(denomination == '1'){
	 value = e.record.data['GoodNoOfNotesDataIndex'] * 1;	 
 }
		
		
		 e.record.set('GoodValueDataIndex',value);
		  e.record.set('TotalAmountDataIndex',e.record.data['GoodValueDataIndex']+e.record.data['BadValueDataIndex']+e.record.data['SoiledValueDataIndex']+e.record.data['CounterfeitValueDataIndex']);
		 
		  var  total = 0;
 for (var i = 0; i < AssetGrid.getStore().data.length; i++) {
            var element = Ext.get(AssetGrid.getView().getRow(i));
            var record = AssetGrid.getStore().getAt(i); 
total =total+ record.data.TotalAmountDataIndex;			
        }
		  // Ext.getCmp('EnterTotalAmountId').setValue(total);        
		 
		 }



		 if( field == "BadNoOfNotesDataIndex" ){
		 if(e.record.data['BadNoOfNotesDataIndex'] == ""){
		 e.record.set('BadNoOfNotesDataIndex',0);
		}
		if(denomination == '5000'){
		 value = e.record.data['BadNoOfNotesDataIndex'] * 5000;
		 }else if(denomination == '2000'){
		 value = e.record.data['BadNoOfNotesDataIndex'] * 2000;
		 }else if(denomination == '1000'){
		 value = e.record.data['BadNoOfNotesDataIndex'] * 1000;
		 }else if(denomination == '500'){
		 value = e.record.data['BadNoOfNotesDataIndex'] * 500;
		 }else if(denomination == '100'){
		 value = e.record.data['BadNoOfNotesDataIndex'] * 100;
		 }else if(denomination == '50'){
		 value = e.record.data['BadNoOfNotesDataIndex'] * 50;
		 }else if(denomination == '20'){
		 value = e.record.data['BadNoOfNotesDataIndex'] * 20;
		 }else if(denomination == '10'){
		 value = e.record.data['BadNoOfNotesDataIndex'] * 10;
		 }else if(denomination == '5'){
		 value = e.record.data['BadNoOfNotesDataIndex'] * 5;
		 }else if(denomination == '2'){
		 value = e.record.data['BadNoOfNotesDataIndex'] * 2;
		 }else if(denomination == '1'){
		 value = e.record.data['BadNoOfNotesDataIndex'] * 1;
		 }
		
		
		 e.record.set('BadValueDataIndex',value);
		 		  e.record.set('TotalAmountDataIndex',e.record.data['GoodValueDataIndex']+e.record.data['BadValueDataIndex']+e.record.data['SoiledValueDataIndex']+e.record.data['CounterfeitValueDataIndex']);
		 var  total = 0;
 for (var i = 0; i < AssetGrid.getStore().data.length; i++) {
            var element = Ext.get(AssetGrid.getView().getRow(i));
            var record = AssetGrid.getStore().getAt(i); 
total =total+ record.data.TotalAmountDataIndex;			
        }
		   //Ext.getCmp('EnterTotalAmountId').setValue(total); 
		 }
		
		
		 if( field == "SoiledNoOfNotesDataIndex" ){
		 if(e.record.data['SoiledNoOfNotesDataIndex'] == ""){
		 e.record.set('SoiledNoOfNotesDataIndex',0);
		}
		  if(denomination == '5000'){
		 value = e.record.data['SoiledNoOfNotesDataIndex'] * 5000;
		 }else if(denomination == '2000'){
		 value = e.record.data['SoiledNoOfNotesDataIndex'] * 2000;
		 }else if(denomination == '1000'){
		 value = e.record.data['SoiledNoOfNotesDataIndex'] * 1000;
		 }else if(denomination == '500'){
		 value = e.record.data['SoiledNoOfNotesDataIndex'] * 500;
		 }else if(denomination == '100'){
		 value = e.record.data['SoiledNoOfNotesDataIndex'] * 100;
		 }else if(denomination == '50'){
		 value = e.record.data['SoiledNoOfNotesDataIndex'] * 50;
		 }else if(denomination == '20'){
		 value = e.record.data['SoiledNoOfNotesDataIndex'] * 20;
		 }else if(denomination == '10'){
		 value = e.record.data['SoiledNoOfNotesDataIndex'] * 10;
		 }else if(denomination == '5'){
		 value = e.record.data['SoiledNoOfNotesDataIndex'] * 5;
		 }else if(denomination == '2'){
		 value = e.record.data['SoiledNoOfNotesDataIndex'] * 2;
		 }else if(denomination == '1'){
		 value = e.record.data['SoiledNoOfNotesDataIndex'] * 1;
		 }
		 e.record.set('SoiledValueDataIndex',value);
		 		  e.record.set('TotalAmountDataIndex',e.record.data['GoodValueDataIndex']+e.record.data['BadValueDataIndex']+e.record.data['SoiledValueDataIndex']+e.record.data['CounterfeitValueDataIndex']);
		 var  total = 0;
 for (var i = 0; i < AssetGrid.getStore().data.length; i++) {
            var element = Ext.get(AssetGrid.getView().getRow(i));
            var record = AssetGrid.getStore().getAt(i); 
total =total+ record.data.TotalAmountDataIndex;			
        }
		   //Ext.getCmp('EnterTotalAmountId').setValue(total); 
	
         } 
		 
		  if( field == "CounterfeitNoOfNotesDataIndex" ){
		if(e.record.data['CounterfeitNoOfNotesDataIndex'] == ""){
		 e.record.set('CounterfeitNoOfNotesDataIndex',0);
		}
		if(denomination == '5000'){
		 value = e.record.data['CounterfeitNoOfNotesDataIndex'] * 5000;
		 }else if(denomination == '2000'){
		 value = e.record.data['CounterfeitNoOfNotesDataIndex'] * 2000;
		 }else if(denomination == '1000'){
		 value = e.record.data['CounterfeitNoOfNotesDataIndex'] * 1000;
		 }else if(denomination == '500'){
		 value = e.record.data['CounterfeitNoOfNotesDataIndex'] * 500;
		 }else if(denomination == '100'){
		 value = e.record.data['CounterfeitNoOfNotesDataIndex'] * 100;
		 }else if(denomination == '50'){
		 value = e.record.data['CounterfeitNoOfNotesDataIndex'] * 50;
		 }else if(denomination == '20'){
		 value = e.record.data['CounterfeitNoOfNotesDataIndex'] * 20;
		 }else if(denomination == '10'){
		 value = e.record.data['CounterfeitNoOfNotesDataIndex'] * 10;
		 }else if(denomination == '5'){
		 value = e.record.data['CounterfeitNoOfNotesDataIndex'] * 5;
		 }else if(denomination == '2'){
		 value = e.record.data['CounterfeitNoOfNotesDataIndex'] * 2;
		 }else if(denomination == '1'){
		 value = e.record.data['CounterfeitNoOfNotesDataIndex'] * 1;
		 }
		
		 e.record.set('CounterfeitValueDataIndex',value);
		 		  e.record.set('TotalAmountDataIndex',e.record.data['GoodValueDataIndex']+e.record.data['BadValueDataIndex']+e.record.data['SoiledValueDataIndex']+e.record.data['CounterfeitValueDataIndex']);
		 var  total = 0;
 for (var i = 0; i < AssetGrid.getStore().data.length; i++) {
            var element = Ext.get(AssetGrid.getView().getRow(i));
            var record = AssetGrid.getStore().getAt(i); 
total =total+ record.data.TotalAmountDataIndex;			
        }
		   //Ext.getCmp('EnterTotalAmountId').setValue(total); 
		 }
		
	
        }
    });

   var customercombostore = new Ext.data.JsonStore({
        url: '<%=request.getContextPath()%>/CashInwardAction.do?param=getCustomer',
        id: 'CustomerStoreId',
        root: 'customerStoreRoot',
        autoLoad: true,
        remoteSort: true,
        fields: ['CustomerId', 'CustomerName']


    });

    var customercombo = new Ext.form.ComboBox({
        store: customercombostore,
        id: 'customercomboId',
        mode: 'local',
        forceSelection: true,
        emptyText: 'Select Customer Name',
        selectOnFocus: true,
        allowBlank: false,
        anyMatch: true,
        typeAhead: false,
        triggerAction: 'all',
        lazyRender: true,
        displayField: 'CustomerName',
        valueField: 'CustomerId',
        cls: 'selectstylePerfect',
        listeners: {
            select: {
                fn: function() {

                }
            }
        }
    });
var clientPanel23 = new Ext.Panel({
        standardView: true,
        collapsible: false,
        id: 'clientPanelId123',
        layout: 'table',
        frame: false,
        width: 760,
        height: 20,
        layoutConfig: {
            columns: 7
        },
        items: [ 
        ]
    });
    var clientPanel234 = new Ext.Panel({
        standardView: true,
        collapsible: false,
        id: 'clientPanelId1234',
        layout: 'table',
        frame: false,
        width: 760,
        height: 20,
        layoutConfig: {
            columns: 7
        },
        items: [ 
    
        ]
    });
        var clientPanel2345 = new Ext.Panel({
        standardView: true,
        collapsible: false,
        id: 'clientPanelId12345',
        layout: 'table',
        frame: false,
        width: 760,
        height: 20,
        layoutConfig: {
            columns: 7
        },
        items: [ 
    
        ]
    });
    var clientPanel2342 = new Ext.Panel({
        standardView: true,
        collapsible: false,
        id: 'clientPanelId1234',
        layout: 'table',
        frame: false,
        width: 960,
        height: 20,
        layoutConfig: {
            columns: 9
        },
        items: [ {
                xtype: 'label',
                cls: 'labelstyle',
                id: 'CustomerTypeLabelId',
                text: 'Business Type' + ' :'
            }, {
              
                xtype: 'textfield',
                cls: 'selectstylePerfect',
                text: '',
                allowBlank: false,
                id: 'CustomerTypeTextId',
                 readOnly:true

            
            },{width:82},{
                xtype: 'label',
                cls: 'labelstyle',
                id: 'ATMLabelId',
                text: 'Business ID' + ' :'
            }, {
              
                xtype: 'textfield',
                cls: 'selectstylePerfect',
                //width: 185,
                text: '',
                id: 'ATMIDTextId',
                 readOnly:true
            
            },
      
            {width:30},
            {
            xtype: 'label',
            text: 'Cash Seal No' + ' :',
            cls: 'labelstyle',
            id: 'cashSealNolabelId'
        },{width:20}, {
            xtype: 'textfield',
            cls: 'selectstylePerfect',
            id: 'cashSealNoId',
            text: '',
            readOnly: true
            }
        ]
    });
var clientPanel2 = new Ext.Panel({
        standardView: true,
        collapsible: false,
        id: 'clientPanelId2',
        layout: 'table',
        frame: false,
        width: 900,
        height: 50,
        layoutConfig: {
            columns: 16
        },
        items: [ 
        {
                xtype: 'label',
                cls: 'labelstyle',
                id: 'SealNoLabelId',
                text: 'Seal No' + ' :',
                hidden:true
            }, {width:42,
             hidden:true},{
              
                xtype: 'textfield',
                cls: 'selectstylePerfect',
                width: 185,
                text: '',
                allowBlank: false,
                id: 'EnterSealNoId',
                labelSeparator: '',
                 hidden:true,
                autoCreate: {
                    tag: "input",
                    maxlength: 50,
                    type: "text",
                    size: "50",
                    autocomplete: "off"
                },
                allowBlank: false,
                maskRe: /[a-zA-Z0-9]/i,
                 readOnly:true

            
            },{width:81,
             hidden:true}, 
            
            {
                xtype: 'label',
                cls: 'labelstyle',
                id: 'TotalAmountLabelId',
                text: 'Total Amount' + ' :'
            }, {
              
                xtype: 'textfield',
                cls: 'selectstylePerfect',
                width: 185,
                allowBlank: false,
                text: '',
                id: 'EnterTotalAmountId',
                labelSeparator: '',
                autoCreate: {
                    tag: "input",
                    maxlength: 50,
                    type: "text",
                    size: "50",
                    autocomplete: "off"
                },
                allowBlank: false,
                maskRe: /[0-9 ]/i,
                 readOnly:true

            
            },{
                xtype: 'label',
                cls: 'labelstyle',
                id: 'lkrLabelId',
                text: 'LKR' 
                },
            {width:30},
             {
                xtype: 'label',
                cls: 'labelstyle',
                id: 'TripNoLabelId',
                text: 'Trip No' + ' :'
               
            }, {width:32},{
              
                xtype: 'textfield',
                cls: 'selectstylePerfect',
                //width: 185,
                allowBlank: false,
                text: '',
                id: 'TripNoTextId',
                 readOnly:true
                
            
            },{width:60},
            {
            xtype: 'label',
            text: 'Date' + ' :',
            cls: 'labelstyle',
            id: 'startdateId'
        },{width:20}, {
            xtype: 'textfield',
            cls: 'selectstylePerfect',
            id: 'startdate',
            text: '' ,
             readOnly:true
            }
        ]
    });

var clientPanel3 = new Ext.Panel({
        standardView: true,
        collapsible: false,
        id: 'clientPanelId3',
        layout: 'table',
        frame: false,
        width: 760,
        height: 50,
        layoutConfig: {
            columns:14
        },
        items: [ {
                xtype: 'checkbox',             
                id: 'CheckboxId'             
            },{
                xtype: 'label',
                cls: 'labelstyle',
                id: 'CheckBoxLabelId',
                text: 'Sealed Bag' 
            },{width:30},{
                xtype: 'checkbox',
                id: 'Checkbox2Id',               
            },{
                xtype: 'label',
                cls: 'labelstyle',
                id: 'CheckBoxLabel2Id',
                text: 'Cash To Be Sorted' 
            }, 
            {width:30},
            {
                xtype: 'checkbox',             
                id: 'CheckboxId3'             
            },{
                xtype: 'label',
                cls: 'labelstyle',
                id: 'CheckBoxLabelId3',
                text: 'Cheque No' 
            },{width:30},{
                xtype: 'checkbox',
                id: 'Checkbox2Id4',               
            },{
                xtype: 'label',
                cls: 'labelstyle',
                id: 'CheckBoxLabel2Id4',
                text: 'Jewellery' 
            }, 
            {width:30},
            {
                xtype: 'checkbox',             
                id: 'CheckboxId5'             
            },{
                xtype: 'label',
                cls: 'labelstyle',
                id: 'CheckBoxLabelId5',
                text: 'Foreign Currency' 
            }
        ]
    });

  var clientPanel = new Ext.Panel({
        standardView: true,
        collapsible: false,
        id: 'clientPanelId',
        layout: 'table',
        frame: false,
        width: 760,
        height: 50,
        layoutConfig: {
            columns: 8
        },
        items: [{
         xtype: 'label',
                cls: 'labelstyle',
                id: 'CustomerLabelId',
                text: 'Customer' + ' :'
            },{width:32},
            {
            xtype: 'textfield',
            cls: 'selectstylePerfect',
            id: 'customerId',
            text: '' ,
             readOnly:true
           
            },
            {width:83},
            {
                xtype: 'label',
                cls: 'labelstyle',
                id: 'InwardModeLabelId',
                text: 'Inward Mode' + ' :'
            }, {
                 xtype: 'label',
                cls: 'labelstyle',
                id: 'InwardModeLabelId2',
                text: 'TRIP' + ''
               
            },{width:100}
        ]
    });


var innerWinButtonPanel = new Ext.Panel({
   id: 'innerWinButtonPanelId2',
   standardSubmit: true,
   collapsible: false,
   autoHeight: true,
  width: 940,
  height: 100,
   frame: false,
   layout: 'table',
   layoutConfig: {
    columns: 4
   },
   buttons: [{

    xtype: 'button',
    text: 'Save',
    id: 'ViewtButtId',
    cls: 'buttonstyle',
    //iconCls: 'searchbutton',
    width: 50,
    listeners: {
     click: {
      fn: function() {
      Ext.getCmp('ViewtButtId').disable();
       ajaxfunction();
      }
     }
    }

   }]
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

 var dataStoreForGrid2 = new Ext.data.GroupingStore({
        url: '<%=request.getContextPath()%>/CashInwardAction.do?param=getGridForSummaryForSealBagForReconcilation',
        bufferSize: 367,
        reader: reader2,
        root: 'rowsForSealBag',
        autoLoad: false,
        remoteSort: true
    });

  function getcmnmodel2() {
        toolGridColumnModel = new Ext.grid.ColumnModel(
            [
                new Ext.grid.RowNumberer({
                    header: '<B>SLNO</B>',
                    width: 45,
                    hidden:true
                }), {
                    header: '<B>Seal Bag - Amount</B>',
                    sortable: true,
                    width: 300,
                    dataIndex: 'SealBagAmount1',
                    editable: false

                }, {
                    header: '<B>Seal Bag - Amount</B>',
                    width: 300,
                    dataIndex: 'SealBagAmount2',
                     editable: false
                },{
                    header: '<B>Seal Bag - Amount</B>',
                    width: 300,
                    dataIndex: 'SealBagAmount3',
                      editable: false
                

                }
            ]);
        return toolGridColumnModel;
    }

var sealBagGrid = new Ext.grid.EditorGridPanel({
        
        id: 'sealBagGrid',
        ds: dataStoreForGrid2,
        cm: getcmnmodel2(),
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
        url: '<%=request.getContextPath()%>/CashInwardAction.do?param=getGridForSummaryForJewelleryForReconcilation',
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
        url: '<%=request.getContextPath()%>/CashInwardAction.do?param=getGridForSummaryForCheckForReconcilation',
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
        url: '<%=request.getContextPath()%>/CashInwardAction.do?param=getGridForSummaryForForexForReconcilation',
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


Ext.onReady(UGrid.init, UGrid, true);
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
            width: 970,
            height: 500,
            layout: 'table',
            cls: 'outerpanel',
            layoutConfig: {
                columns: 1
            },
            items: [clientPanel23,clientPanel,clientPanel2,clientPanel234,clientPanel2342,clientPanel2345,clientPanel3,AssetGrid,sealBagGrid,checkGrid,jewelleryGrid,forexGrid,innerWinButtonPanel]
        });
 Ext.getCmp('ViewtButtId').enable();

Ext.getCmp('customerId').setValue('<%=customer%>');
Ext.getCmp('EnterSealNoId').setValue('<%=sealNo%>');
Ext.getCmp('cashSealNoId').setValue('<%=cashSealNo%>');
Ext.getCmp('EnterTotalAmountId').setValue('<%=totalAmount%>');
Ext.getCmp('startdate').setValue('<%=date%>');
Ext.getCmp('CustomerTypeTextId').setValue('<%=customerType%>');
Ext.getCmp('TripNoTextId').setValue('<%=tripNo%>');
Ext.getCmp('ATMIDTextId').setValue('<%=atmId%>');

 Ext.getCmp("CheckboxId").setValue(false);
 Ext.getCmp("Checkbox2Id").setValue(false);
 Ext.getCmp("CheckboxId3").setValue(false);
 Ext.getCmp("Checkbox2Id4").setValue(false);
 Ext.getCmp("CheckboxId5").setValue(false);

//alert('<%=cashType%>');
var ctype = '<%=cashType%>';
if(ctype.includes("CASH")){
Ext.getCmp("Checkbox2Id").setValue(true);
}
if(ctype.includes("SEALED BAG")){
Ext.getCmp("CheckboxId").setValue(true);
}
if(ctype.includes("CHEQUE")){
Ext.getCmp("CheckboxId3").setValue(true);
}
if(ctype.includes("JEWELLERY")){
Ext.getCmp("Checkbox2Id4").setValue(true);
}
if(ctype.includes("FOREIGN CURRENCY")){
Ext.getCmp("CheckboxId5").setValue(true);
}
<!--if ('<%=customerType%>' == 'Cash Delivery' ) {-->
     //AssetGrid.getColumnModel().config[columnIndex].editable = false; 
     Ext.getCmp("CheckboxId").disable();
     Ext.getCmp("Checkbox2Id").disable();
     Ext.getCmp("CheckboxId3").disable();
     Ext.getCmp("Checkbox2Id4").disable();
     Ext.getCmp("CheckboxId5").disable();

<!--     }-->
<!--  else{-->
<!--      // AssetGrid.getColumnModel().config[columnIndex].editable = true; -->
<!--        Ext.getCmp("CheckboxId").enable();-->
<!--        Ext.getCmp("Checkbox2Id").enable(); -->
<!--        Ext.getCmp("CheckboxId3").enable();-->
<!--        Ext.getCmp("Checkbox2Id4").enable();-->
<!--        Ext.getCmp("CheckboxId5").enable();-->
<!--  }-->

dataStoreForGrid.load({
  params:{
  ButtonValue:'Create',
  InwardId:'0'
  
  }
  });

 dataStoreForGrid2.load({
  params:{
 
CvsCustId :<%=cvsCustId%>,
TripshhetNo :'<%=tripNo%>',
UniqueId : <%=UniqueId%>
  
  } 
  });

 dataStoreForGrid3.load({
  params:{
 
CvsCustId :<%=cvsCustId%>,
TripshhetNo :'<%=tripNo%>',
UniqueId : <%=UniqueId%>
  
  } 
  });

 dataStoreForGrid4.load({
  params:{
 
CvsCustId :<%=cvsCustId%>,
TripshhetNo :'<%=tripNo%>',
UniqueId : <%=UniqueId%>
  
  } 
  });

 dataStoreForGrid5.load({
  params:{
 
CvsCustId :<%=cvsCustId%>,
TripshhetNo :'<%=tripNo%>',
UniqueId : <%=UniqueId%>
  
  } 
  });

  if ('<%=customerType%>' == 'Cash Delivery' ) {
            Ext.MessageBox.show({
                        title: '',
                        msg: 'Has The Cash Been Delivered?',
                        buttons: Ext.MessageBox.YESNO,
                        icon: Ext.MessageBox.QUESTION,
                        fn: function(btn) {
                            if (btn == 'yes') {
                            
                               totalAmount = "0";
                               Ext.getCmp('EnterTotalAmountId').setValue(totalAmount);
                             KeyPressed = "Yes";
                               ajaxfunction();
                            }
                            if (btn == 'no') {
                            
                              if('<%=cashType%>' == 'SEALED BAG'){                           
                            
                              totalAmount = '<%=totalAmount%>'
                          Ext.getCmp('EnterTotalAmountId').setValue(totalAmount);
                         KeyPressed = "No";
                          
                          }else{
                         
                          if(Ext.getCmp("Checkbox2Id").getValue() == true){
                          Ext.example.msg("Please Enter Denominations");
                          }
                         
                          }
                            }

                        }
                    });
                
}else{
totalAmount = '<%=totalAmount%>';
Ext.getCmp('EnterTotalAmountId').setValue(totalAmount);
KeyPressed = "No";
}

    });
</script>
	</body>
</html>
