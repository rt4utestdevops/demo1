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
String buttonValue ="Inward";
String InwardId = "0";
            String cvsCustomerId = "0";	
			String InwardedDate = "";
			String SealedBagNo = "";
			String TotalAmount = "";
			String CustomerName = "";
			String cashType = "";
			String inwardMode = "";
if(request.getParameter("ButtonValue") != null && !request.getParameter("ButtonValue").equals("")){
 buttonValue = request.getParameter("ButtonValue").replace(" ","");
 }
 System.out.print(request.getParameter("ButtonValue"));
 if(request.getParameter("InwardId") != null && !request.getParameter("InwardId").equals("")){
 InwardId =  request.getParameter("InwardId").replace(" ","");
 }
if(buttonValue.equals("Modify")){
CashVanManagementFunctions cvmFunc = new CashVanManagementFunctions();		
ArrayList<String> dataList = cvmFunc.getDataForModifyInward(systemId,customerId,Integer.parseInt(InwardId));
cvsCustomerId = dataList.get(0);	
InwardedDate =dataList.get(1);	
SealedBagNo = dataList.get(2);	
TotalAmount = dataList.get(3);	
CustomerName = dataList.get(4);	
cashType = dataList.get(5);	
inwardMode =  dataList.get(6);	      
}
int inwardId = Integer.parseInt(InwardId);
int cvsCustId= Integer.parseInt(cvsCustomerId);
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
    var grid;
    var datajson = '';
    var cvsCustId = <%=cvsCustId%>;
    var currentTime = new Date().format('d-m-Y h:i:s');
var denominationTot = 0;
    function ajaxfunction() {
 if(Ext.getCmp('customercomboId').getValue() == ""){
Ext.example.msg("Please Select Customer Name");
                 Ext.getCmp('ViewtButtId').enable();  
                    return;
}
if(Ext.getCmp('startdate').getValue() > new Date()){
Ext.example.msg("Selected Time Should Not Be Greater Than Current Time");
                   Ext.getCmp('ViewtButtId').enable();
                    return;
}
if(Ext.getCmp("CheckboxId").checked == false && Ext.getCmp("Checkbox2Id").checked == false ){
Ext.example.msg("Please Check Atleast One Inward Type");
                   Ext.getCmp('ViewtButtId').enable();
                    return;
}
if(Ext.getCmp("CheckboxId").checked == true && Ext.getCmp("Checkbox2Id").checked == true ){
Ext.example.msg("Please Check Any One Inward Type");
                   Ext.getCmp('ViewtButtId').enable();
                    return;
}
if(Ext.getCmp("CheckboxId").checked == true){
if(Ext.getCmp('EnterSealNoId').getValue() == "" || Ext.getCmp('EnterSealNoId').getValue() == "Enter Seal No" || Ext.getCmp('EnterSealNoId').getValue().trim() == ""  ){
Ext.example.msg("Please Enter Sealed Bag No");
                   Ext.getCmp('ViewtButtId').enable();
                    return;
}

}
//if(Ext.getCmp('EnterSealNoId').getValue() != "" && Ext.getCmp("CheckboxId").checked == true ){
if(Ext.getCmp("Checkbox2Id").checked == true){
if(denominationTot == 0 ){
Ext.example.msg("Please Enter Denominations");
                   Ext.getCmp('ViewtButtId').enable(); 
                    return;
}
}
if(Ext.getCmp('EnterTotalAmountId').getValue() == "" || Ext.getCmp('EnterTotalAmountId').getValue() == 0 || Ext.getCmp('EnterTotalAmountId').getValue() == "Enter Total Amount" ){
Ext.example.msg("Please Enter Total Amount");
                   Ext.getCmp('ViewtButtId').enable(); 
                    return;
}

//}
    
        var json = '';
        for (var i = 0; i < AssetGrid.getStore().data.length; i++) {
            var element = Ext.get(AssetGrid.getView().getRow(i));
            var record = AssetGrid.getStore().getAt(i);        
            json += Ext.util.JSON.encode(record.data) + ',';
        }

        datajson = json;

        if (datajson != '') {
        
        var checkBoxType;
if( Ext.getCmp("Checkbox2Id").checked == true && Ext.getCmp("CheckboxId").checked == true ){
checkBoxType = 'CASH';
}else if (Ext.getCmp("CheckboxId").checked == true) {
checkBoxType = 'SEALED BAG';;

}else{
checkBoxType = 'CASH';
}

if('<%=buttonValue%>' == 'Modify'){
cvsCustId = <%=cvsCustId%>;
}else{
cvsCustId = Ext.getCmp('customercomboId').getValue();
}
   Ext.Ajax.request({
                url: '<%=request.getContextPath()%>/CashInwardAction.do?param=Save',
                method: 'POST',
                params: {
                    Date: Ext.getCmp('startdate').getValue(),
                    CashType : checkBoxType,
                    datajson: datajson,
                    CustId: <%= customerId %>,
					CVSCustId : cvsCustId,
					SealNo:Ext.getCmp('EnterSealNoId').getValue(),
					TotalAmount:Ext.getCmp('EnterTotalAmountId').getValue(),
					ButtonValue:'<%=buttonValue%>',
					InwardId : <%=inwardId%>
                },
                success: function(response, options) {
                    var message = response.responseText;
                    parent.Ext.example.msg(message); 
                    // parent.store.load();  
                     
                     parent.store.load({
                            params: {
                                startDate: parent.Ext.getCmp('startdate').getValue(),
                                endDate: parent.Ext.getCmp('enddate').getValue()
                            }
                        });
                     
                         //  Ext.getCmp('ViewtButtId').enable();         
                      Ext.getCmp('startdate').reset();           
                    Ext.getCmp('EnterSealNoId').reset();
			Ext.getCmp('EnterTotalAmountId').reset()
			Ext.getCmp('customercomboId').reset(); 
			Ext.getCmp("CheckboxId").setValue(false);
			Ext.getCmp("Checkbox2Id").setValue(false);
			 parent.myWin1.close();
			  
                    datajson = '';
denominationTot = 0;
                },
                failure: function() {
                    parent.Ext.example.msg("Error");
                     parent.store.load();  
                         //  Ext.getCmp('ViewtButtId').enable();         
                      Ext.getCmp('startdate').reset();           
                    Ext.getCmp('EnterSealNoId').reset();
			Ext.getCmp('EnterTotalAmountId').reset()
			Ext.getCmp('customercomboId').reset(); 
			Ext.getCmp("CheckboxId").setValue(false);
			Ext.getCmp("Checkbox2Id").setValue(false);
			 parent.myWin1.close();
			 denominationTot = 0;
                    datajson = '';
                    
                }
            });
        
          
        } else {
            Ext.example.msg("Please Enter Data And Try To Save");
        }
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
                type: 'number'
            }, {
                name: 'BadNoOfNotesDataIndex',
                type: 'int'
            },{
                name: 'BadValueDataIndex',
                type: 'number'
            }, {
                name: 'SoiledNoOfNotesDataIndex',
                type: 'int'
            }, {
                name: 'SoiledValueDataIndex',
                type: 'number'
            }, {
                name: 'CounterfeitNoOfNotesDataIndex',
                type: 'int'
            },{
                name: 'CounterfeitValueDataIndex',
                type: 'number'
            },{
            name:'TotalAmountDataIndex',
            type: 'number'
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
                        autoCreate :  { //restricts user to 10 chars max, cannot enter 11st char
             tag: "input", 
             maxlength : 10, 
             type: "text", 
             size: "10", 
             autocomplete: "off"},               
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
                         autoCreate :  { //restricts user to 10 chars max, cannot enter 11th char
             tag: "input", 
             maxlength : 10, 
             type: "text", 
             size: "10", 
             autocomplete: "off"},               
                         
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
                         allowNegative:false,               
                         autoCreate :  { //restricts user to 10 chars max, cannot enter 11th char
             tag: "input", 
             maxlength : 10, 
             type: "text", 
             size: "10", 
             autocomplete: "off"},
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
                         autoCreate :  { //restricts user to 10 chars max, cannot enter 11th char
             tag: "input", 
             maxlength : 10, 
             type: "text", 
             size: "10", 
             autocomplete: "off"},
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
        width: 930,
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
		if(Ext.getCmp("CheckboxId").checked == true || '<%=buttonValue%>' == 'Modify' ){
                                                    AssetGrid.getColumnModel().config[columnIndex].editable = false;
                                             }
                                             else{
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
        denominationTot = total;
		   Ext.getCmp('EnterTotalAmountId').setValue(total);        
		 
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
                denominationTot = total;
        
		   Ext.getCmp('EnterTotalAmountId').setValue(total); 
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
                denominationTot = total;
        
		   Ext.getCmp('EnterTotalAmountId').setValue(total); 
	
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
                denominationTot = total;
        
		   Ext.getCmp('EnterTotalAmountId').setValue(total); 
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
var clientPanel2 = new Ext.Panel({
        standardView: true,
        collapsible: false,
        id: 'clientPanelId2',
        layout: 'table',
        frame: false,
        width: 760,
        height: 50,
        layoutConfig: {
            columns: 7
        },
        items: [ {
                xtype: 'label',
                cls: 'labelstyle',
                id: 'SealNoLabelId',
                text: 'Seal No' + ' :'
            }, {
              
                xtype: 'textfield',
                cls: 'selectstylePerfect',
                //width: 185,
                emptyText: 'Enter Seal No',
                allowBlank: false,
                blankText: 'Enter Seal No',
                id: 'EnterSealNoId',
                labelSeparator: '',
                autoCreate: {
                    tag: "input",
                    maxlength: 50,
                    type: "text",
                    size: "50",
                    autocomplete: "off"
                },
                allowBlank: false,
                maskRe: /[a-zA-Z0-9]/i

            
            },{width:50}, {
                xtype: 'label',
                cls: 'labelstyle',
                id: 'TotalAmountLabelId',
                text: 'Total Amount' + ' :'
            }, {
              
                xtype: 'textfield',
                cls: 'selectstylePerfect',
                width: 185,
                emptyText: 'Enter Total Amount',
                allowBlank: false,
                blankText: 'Enter Total Amount',
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
                maskRe: /[0-9 ]/i

            
            },{
                xtype: 'label',
                cls: 'labelstyle',
                id: 'lkrLabelId',
                text: 'LKR' 
                },
            {width:50},{width:50}
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
            columns:5
        },
        items: [ {
                xtype: 'checkbox',
              
                id: 'CheckboxId'
                
            },{
                xtype: 'label',
                cls: 'labelstyle',
                id: 'CheckBoxLabelId',
                text: 'Sealed Bag' 
            },{width:50},{
                xtype: 'checkbox',
                id: 'Checkbox2Id',
                checked  : true
                
            },{
                xtype: 'label',
                cls: 'labelstyle',
                id: 'CheckBoxLabel2Id',
                text: 'Cash To Be Sorted' 
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
            },
            customercombo,
            {width:75},
            {
                xtype: 'label',
                cls: 'labelstyle',
                id: 'InwardModeLabelId',
                text: 'Inward Mode' + ' :'
            }, {
                 xtype: 'label',
                cls: 'labelstyle',
                id: 'InwardModeLabelId2',
                text: 'DIRECT' + ''
            },{width:100},{
            xtype: 'label',
            text: 'Date' + ' :',
            cls: 'labelstyle',
            id: 'startdateId'
        }, {
            xtype: 'textfield',
            cls: 'selectstylePerfect',
            text:'',
            id: 'startdate'
            }
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
    hidden:true,
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

   }
<!--   , {-->
<!--    xtype: 'button',-->
<!--    text: 'Cancel',-->
<!--    id: 'approveButtonId',-->
<!--    cls: 'buttonstyle',-->
<!--    //iconCls: 'validatebutton',-->
<!--    width: 50,-->
<!--    listeners: {-->
<!--     click: {-->
<!--      fn: function() {-->
<!--    -->
<!--      Ext.getCmp('startdate').reset();           -->
<!--                    Ext.getCmp('EnterSealNoId').reset();-->
<!--			Ext.getCmp('EnterTotalAmountId').reset();-->
<!--			Ext.getCmp('customercomboId').reset(); -->
<!--			Ext.getCmp("CheckboxId").setValue(false);-->
<!--			Ext.getCmp("Checkbox2Id").setValue(true);-->
<!--parent.myWin1.hide();-->
<!--		-->
<!--      }-->
<!--     }-->
<!--    }-->
<!--   -->
<!--   }-->
   ]
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
            autoScroll: false,
            frame: true,
            border: false,
            width: 950,
            height: 490,
            layout: 'table',
            cls: 'outerpanel',
            layoutConfig: {
                columns: 1
            },
            items: [clientPanel23,clientPanel,clientPanel2,clientPanel3,clientPanel234,AssetGrid,innerWinButtonPanel]
        });
         Ext.getCmp('ViewtButtId').enable();
         dataStoreForGrid.load({
  params:{
  ButtonValue:'<%=buttonValue%>',
  InwardId: <%=inwardId%>
  
  } 
  });
        
        if('<%=buttonValue%>' == 'Inward'){
         Ext.getCmp('ViewtButtId').show(); 
          Ext.getCmp('startdate').getEl().dom.setAttribute('readOnly', true);
          
Ext.getCmp('EnterSealNoId').enable();
Ext.getCmp('EnterTotalAmountId').enable();
Ext.getCmp('customercomboId').enable();
Ext.getCmp("CheckboxId").enable();
Ext.getCmp("Checkbox2Id").enable();
        Ext.getCmp('startdate').setValue(currentTime);
        }if('<%=buttonValue%>' == 'Modify'){
         Ext.getCmp('startdate').getEl().dom.setAttribute('readOnly', true);
         
Ext.getCmp('EnterSealNoId').disable();
Ext.getCmp('EnterTotalAmountId').disable();
Ext.getCmp('customercomboId').disable();
Ext.getCmp("CheckboxId").disable();
Ext.getCmp("Checkbox2Id").disable();


         Ext.getCmp('ViewtButtId').hide();
       Ext.getCmp('startdate').setValue('<%=InwardedDate%>');
       Ext.getCmp('InwardModeLabelId2').setText('<%=inwardMode%>');           
                    Ext.getCmp('EnterSealNoId').setValue('<%=SealedBagNo%>'); 
			Ext.getCmp('EnterTotalAmountId').setValue('<%=TotalAmount%>'); 
			Ext.getCmp('customercomboId').setValue('<%=CustomerName%>'); 
			if('<%=cashType%>' == 'CASH'){
			Ext.getCmp("CheckboxId").setValue(false);
			Ext.getCmp("Checkbox2Id").setValue(true);
			}else if('<%=cashType%>' == 'SEALED BAG'){
			Ext.getCmp("Checkbox2Id").setValue(false);
			Ext.getCmp("CheckboxId").setValue(true);
			}
        }
       
    });
</script>
	</body>
</html>
