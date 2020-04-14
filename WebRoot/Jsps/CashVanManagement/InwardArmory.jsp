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
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <base href="<%=basePath%>">
    
    <title>Inward Armory</title>
    
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
var jspName = "Inward Armony";
var exportDataType = "int,string,string";
var grid;
var addPlant = 0;
var Plant;
var datajson = '';
var index;
var assetNumbers='';
var assetcombostore = new Ext.data.JsonStore({
    url: '<%=request.getContextPath()%>/ArmoryAction.do?param=armoryItems',
    id: 'AssetStoreId',
    root: 'armoryItems',
    autoLoad: true,
    remoteSort: true,
    fields: ['itemId', 'itemName']

});

var validateAssetStore = new Ext.data.JsonStore({
    url: '<%=request.getContextPath()%>/ArmoryAction.do?param=getAllAssetNos',
    id: 'validateAssetStoreId',
    root: 'validateAssetStoreRoot',
    autoLoad: false,
    remoteSort: true,
    fields: ['AssetNo']
});

function ajaxfunction() {
    if (datajson != '') {
        var dataRow = [];
        for (var i = 0; i < AssetGrid.getStore().data.length; i++) {
            var element = Ext.get(AssetGrid.getView().getRow(i));
            var record = AssetGrid.getStore().getAt(i);
           index = validateAssetStore.find('AssetNo', record.data.AssetNo);
            if (index >= 0) {
              //  Ext.example.msg("Asset No '" + record.data.AssetNo + "' Is Already Existed");
              assetNumbers=assetNumbers+record.data.AssetNo+',';
            } else {
                dataRow.push(record.data.AssetNo);
            }
        }
        
        if(assetNumbers!=""){
        return;
        }
        datajson = dataRow.toString();
        Ext.Ajax.request({
            url: '<%=request.getContextPath()%>/ArmoryAction.do?param=saveArmory',
            method: 'POST',
            params: {
                assetItemId: Ext.getCmp('assetcomboId').getValue(),
                date: Ext.getCmp('startdate').getValue(),
                vendor: Ext.getCmp('vendor').getValue(),
                branch: Ext.getCmp('branchcomboId').getValue(),
                assetIds: datajson,
                CustId: <%= customerId %>
            },
            success: function(response, options) {
                var message = response.responseText;
                //custId = Ext.getCmp('custcomboId').getValue();
                parent.Ext.example.msg(message);
                dataStoreForGrid.reload();
                 //dataStoreForGrid.reload();
            Ext.getCmp('assetcomboId').reset();
            Ext.getCmp('branchcomboId').reset();
            Ext.getCmp('vendor').reset();
            Ext.getCmp('startdate').reset();    
                 parent.store.load();
                    parent.myWin1.hide();
                datajson = ''
            },
            failure: function() {
                Ext.example.msg("Error");
                dataStoreForGrid.reload();
                 //dataStoreForGrid.reload();
            Ext.getCmp('assetcomboId').reset();
            Ext.getCmp('branchcomboId').reset();
            Ext.getCmp('vendor').reset();
            Ext.getCmp('startdate').reset() ;    
                 parent.store.load();
                    parent.myWin1.hide();
                datajson = '';
            }
        });
    } else {
        Ext.example.msg("Please Enter Asset Number And Try To Save");
    }
}

var assetcombo = new Ext.form.ComboBox({
    store: assetcombostore,
    id: 'assetcomboId',
    mode: 'local',
    forceSelection: true,
    emptyText: 'Select AssetName',
    selectOnFocus: true,
    allowBlank: false,
    anyMatch: true,
    typeAhead: false,
    triggerAction: 'all',
    lazyRender: true,
    displayField: 'itemName',
    valueField: 'itemId',
    cls: 'selectstylePerfect',
    listeners: {
        select: {
            fn: function() {
                var dataRow = [];
                for (var i = 0; i < AssetGrid.getStore().data.length; i++) {
                    var element = Ext.get(AssetGrid.getView().getRow(i));
                    var record = AssetGrid.getStore().getAt(i);

                    dataRow.push(record.data.AssetNo);

                }

                datajson = dataRow.toString();

                if (addPlant > 0 && datajson != '') {
                    Ext.MessageBox.show({
                        title: '',
                        msg: 'Do you want to save the added rows',
                        buttons: Ext.MessageBox.YESNO,
                        icon: Ext.MessageBox.QUESTION,
                        fn: function(btn) {
                            if (btn == 'yes') {

                                //var gridData=Ext.util.JSON.encode(AssetGrid);

                                //save value
                                ajaxfunction();

                            }
                            if (btn == 'no') {
                                dataStoreForGrid.reload();

                            }

                        }
                    });
                }
            }
        }
    }

});

var branchcombostore = new Ext.data.JsonStore({
    url: '<%=request.getContextPath()%>/ArmoryAction.do?param=getBranches',
    id: 'BranchStoreId',
    root: 'branches',
    autoLoad: true,
    remoteSort: true,
    fields: ['branchId', 'branchName']


});




var branchcombo = new Ext.form.ComboBox({
    store: branchcombostore,
    id: 'branchcomboId',
    mode: 'local',
    forceSelection: true,
    emptyText: 'Select BranchName',
    selectOnFocus: true,
    allowBlank: false,
    anyMatch: true,
    typeAhead: false,
    triggerAction: 'all',
    lazyRender: true,
    displayField: 'branchName',
    valueField: 'branchId',
    cls: 'selectstylePerfect',
    listeners: {
        select: {
            fn: function() {
                validateAssetStore.load();
                var dataRow = [];
                for (var i = 0; i < AssetGrid.getStore().data.length; i++) {
                    var element = Ext.get(AssetGrid.getView().getRow(i));
                    var record = AssetGrid.getStore().getAt(i);

                    dataRow.push(record.data.AssetNo);

                }

                datajson = dataRow.toString();

                if (addPlant > 0 && datajson != '') {
                    Ext.MessageBox.show({
                        title: '',
                        msg: 'Do you want to save the added rows',
                        buttons: Ext.MessageBox.YESNO,
                        icon: Ext.MessageBox.QUESTION,
                        fn: function(btn) {
                            if (btn == 'yes') {

                                ajaxfunction();

                            }
                            if (btn == 'no') {
                                dataStoreForGrid.reload();

                            }

                        }
                    });
                }
            }
        }
    }
});




var filters = new Ext.ux.grid.GridFilters({
    local: true,
    filters: [{
        type: 'int',
        dataIndex: 'slnoIndex'
    }, {
        type: 'string',
        dataIndex: 'assetnumberDataIndex'
    }]
});




var clientPanel = new Ext.Panel({
    standardView: true,
    collapsible: false,
    autoScroll: false,
    id: 'clientPanelId',
    layout: 'table',
    frame: true,
    width: 500,
    height: 120,
    layoutConfig: {
        columns: 3
    },
    items: [{
            xtype: 'label',
            text: 'Asset Name' + ' :',
            cls: 'labelstyle',
            id: 'custnamelab'
        }, assetcombo, {




            width: 50

        },


        {
            xtype: 'label',
            cls: 'labelstyle',
            id: 'startdatelab',
            text: 'Date' + ' :'
        }, {
            xtype: 'datefield',
            cls: 'selectstylePerfect',
            width: 50,
            format: getDateFormat(),
            emptyText: 'SelectDate',
            allowBlank: false,
            editable : false,
            blankText: 'Select  Date',
            id: 'startdate',
            maxValue: dtcur,
           minValue:dtcur,
            value: dtcur,
            DateField: 'date'
        }, {
            width: 50
        }, {
            xtype: 'label',
            cls: 'labelstyle',
            id: 'vendorlab',
            text: 'Vendor Name' + ' :'
        }, {
            xtype: 'textfield',
            cls: 'selectstylePerfect',
            width: 50,
            emptyText: 'Select Vendor',
            allowBlank: false,
            blankText: 'Select Vendor',
            id: 'vendor',
            labelSeparator: '',
            autoCreate: {
                tag: "input",
                maxlength: 50,
                type: "text",
                size: "50",
                autocomplete: "off"
            },
            allowBlank: false,
            maskRe: /[a-zA-Z]/i

        }, {
            width: 50
        }, {
            xtype: 'label',
            cls: 'labelstyle',
            id: 'branchlab',
            text: 'Branch Name' + ' :'
        },
        branchcombo
    ]
});




var reader = new Ext.data.JsonReader({
    root: 'armonyDetailsroot',
    fields: [{

        name: 'SLNOIndex'
    }, {
        name: 'AssetNo',
        type: 'string'
    }]
});

var dataStoreForGrid = new Ext.data.GroupingStore({
    url: '<%=request.getContextPath()%>/ArmoryAction.do?param=getArmonyDetails',
    bufferSize: 367,
    reader: reader,
    root: 'armonyDetailsroot',
    autoLoad: true,
    remoteSort: true
});

var Plant = Ext.data.Record.create([{
    name: 'SLNOIndex'
}, {
    name: 'AssetNo'
}]);

function getcmnmodel() {
    toolGridColumnModel = new Ext.grid.ColumnModel(
        [
            new Ext.grid.RowNumberer({
                header: '<B>SLNO</B>',
                hidden: false,
                width: 100
            }), {
                header: 'SLNO',
                hidden: true,
                sortable: false,
                width: 40,
                dataIndex: 'SLNOIndex',
                hideable: false

            }, {
                header: '<B>ASSET NUMBER</B>',
                sortable: false,
                width: 360,
                dataIndex: 'AssetNo',
                hidden: false,
                hideable: true,
                editable: true,
                editor: new Ext.grid.GridEditor(new Ext.form.TextField({
                 autoCreate: {
                tag: "input",
                maxlength: 50,
                type: "text",
                size: "50",
                autocomplete: "off"
            },
            allowBlank: true,
            maskRe: /[a-zA-Z0-9]/i,
                width: 140,
                    cls: 'bskExtStyle'
                }))

            }
        ]);
    return toolGridColumnModel;
}

var AssetGrid = new Ext.grid.EditorGridPanel({
    title: 'Asset Details',
    header: true,
    id: 'toolGridid',
    ds: dataStoreForGrid,
    cm: getcmnmodel(),
    stripeRows: true,
    border: true,
    width: 500,
    height: 200,
    autoScroll: true,
    plugins: [filters],
    clicksToEdit: 1,
    selModel: new Ext.grid.RowSelectionModel(),
    tbar: [{
        text: 'Add',

        handler: function() {


            addPlant++;

            var p = new Plant({
                SLNODataIndex: "new" + addPlant,
                AssetNo: ""


            });
            AssetGrid.stopEditing();
            dataStoreForGrid.insert(0, p);
            AssetGrid.startEditing(0, 0);



        }
    }, '-', {
        text: 'Save',

        handler: function() {
            if (Ext.getCmp('assetcomboId').getValue() == "") {

                Ext.example.msg("Please Select Asset Name");
                Ext.getCmp('assetcomboId').focus();
                return;

            }
            if (Ext.getCmp('vendor').getValue().trim() == "") {

                Ext.example.msg("Please Select Vendor Name");
                Ext.getCmp('vendor').focus();
                return;
            }
            if (Ext.getCmp('branchcomboId').getValue() == "") {

                Ext.example.msg("Please Select Branch Name");
                Ext.getCmp('branchcomboId').focus();
                return;
            }
            var dataRow = [];
            
            if(AssetGrid.getStore().data.length<=0){
             Ext.example.msg("Please Add Asset no.");
             return;
            }
            for (var i = 0; i < AssetGrid.getStore().data.length; i++) {
                var element = Ext.get(AssetGrid.getView().getRow(i));
                var record = AssetGrid.getStore().getAt(i);
                
                if(record.data.AssetNo.trim() !=""){
               var index= dataRow.indexOf(record.data.AssetNo);
               if(!(index<0))
               {
               Ext.example.msg("Duplicate Asset no. found in list");
               
               dataRow=[];
             return;
               }
            dataRow.push(record.data.AssetNo);
                }
               

            }
if(dataRow.length<=0){
Ext.example.msg("Please Add Asset no.");
             return;
}
            datajson = dataRow.toString();

            ajaxfunction();
      if(assetNumbers!=""){
      Ext.example.msg(assetNumbers+" asset no. is already exist");
      assetNumbers='';
             return;
      }
            parent.store.reload();
            Ext.getCmp('assetcomboId').reset();
            Ext.getCmp('branchcomboId').reset();
            Ext.getCmp('vendor').reset();
            Ext.getCmp('startdate').reset()
            parent.myWin1.hide()

        }
    }, '-', {
        text: 'Refresh',

        handler: function() {
            dataStoreForGrid.reload();
            Ext.getCmp('assetcomboId').reset();
            Ext.getCmp('branchcomboId').reset();
            Ext.getCmp('vendor').reset();
            Ext.getCmp('startdate').reset()     

        }
    }]
});



var innerWinButtonPanelForAdd = new Ext.Panel({
    id: 'innerWinButtonPanelForAddId',
    standardSubmit: true,
    collapsible: false,
    autoHeight: true,
    height: 100,
    width: 500,
    frame: false,
    layout: 'table',
    layoutConfig: {
        columns: 4
    },

    buttons: [{
        xtype: 'button',
        text: 'Cancel',
        id: 'canButtId2',
        cls: 'buttonstyle',
        iconCls: 'cancelbutton',
        width: 100,
        listeners: {
            click: {
                fn: function() {
                dataStoreForGrid.reload();
            Ext.getCmp('assetcomboId').reset();
            Ext.getCmp('branchcomboId').reset();
            Ext.getCmp('vendor').reset();
            Ext.getCmp('startdate').reset()     
                
                    parent.myWin1.hide();

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
        title: 'Inward Armory',
        renderTo: 'content',
        id: 'outerPanel',
        standardView: true,
        autoScroll: true,
        frame: false,
        border: false,
        width: 530,
        height: 420,
        layout: 'table',
        cls: 'outerpanel',
        layoutConfig: {
            columns: 1
        },
        items: [clientPanel, AssetGrid,innerWinButtonPanelForAdd]
    });
    
dataStoreForGrid.reload();
});
   </script>
	</body>
</html>
