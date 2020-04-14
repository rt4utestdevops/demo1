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
%>

<jsp:include page="../Common/header.jsp" />
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

  
 <style>
.x-panel-tl {
	border-bottom: 0px solid !important;
} 
</style>
	
	
  <%if (loginInfo.getStyleSheetOverride().equals("Y")){%>
	<jsp:include page="../Common/ImportJSSandMining.jsp"/>
	
	<%}else {%>
	<jsp:include page="../Common/ImportJS.jsp" />
	
	<%} %>
		<jsp:include page="../Common/ExportJS.jsp" />
		<style>	
			.ext-strict .x-form-text {
				height: 21px !important;
			}
			label {
				display : inline !important;
			}
			.ext-strict .ext-webkit .x-small-editor .x-form-text {
				height: 19px !important;
			}
			.x-btn-text {
				font-size: 15px  !important;
			}
		</style>
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
    var ButtonValue = '';
    var assetcombostore = new Ext.data.JsonStore({
        url: '<%=request.getContextPath()%>/StationaryMasterAction.do?param=getStationaryItems&AssetType=Stationary&CustId=<%=customerId%>',
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
        var json = '';
        for (var i = 0; i < AssetGrid.getStore().data.length; i++) {
            var element = Ext.get(AssetGrid.getView().getRow(i));
            var record = AssetGrid.getStore().getAt(i);
            if (record.data.StationaryIyemDataIndex == '') {
                Ext.example.msg("Please Select Item Name");
                return;
            }
            if (record.data.QuantityDataIndex == '' && record.data.QuantityDataIndex == 0) {
                Ext.example.msg("Please Enter Quantity ");
                return;
            }
            json += Ext.util.JSON.encode(record.data) + ',';
        }

        datajson = json;

        if (datajson != '') {
            Ext.Ajax.request({
                url: '<%=request.getContextPath()%>/StationaryMasterAction.do?param=saveStationary',
                method: 'POST',
                params: {
                    date: Ext.getCmp('startdate').getValue(),
                    vendor: Ext.getCmp('vendor').getValue(),
                    branch: Ext.getCmp('branchcomboId').getValue(),
                    datajson: datajson,
                    CustId: <%= customerId %>
                },
                success: function(response, options) {
                    var message = response.responseText;
                    Ext.example.msg(message);
                    AssetGrid.stopEditing();
                    AssetGrid.getColumnModel().setHidden(AssetGrid.getColumnModel().findColumnIndex('InsertedDatetimeIndex'), false);
                    AssetGrid.getColumnModel().setHidden(AssetGrid.getColumnModel().findColumnIndex('InsertedByIndex'), false);
                    AssetGrid.getColumnModel().setHidden(AssetGrid.getColumnModel().findColumnIndex('RemarksDataIndex'), false);
                    AssetGrid.getColumnModel().setHidden(AssetGrid.getColumnModel().findColumnIndex('RemainingQuantityDataIndex'), true);                    
                    
                    ButtonValue = 'Inward';
                    dataStoreForGrid.load({
                        params: {
                            ButtonValue: ButtonValue,
                            InwardDate: Ext.getCmp('startdate').getValue(),
                            VendorName: Ext.getCmp('vendor').getValue(),
                            BranchId: Ext.getCmp('branchcomboId').getValue(),
                            CustId: <%= customerId %>
                        }
                    });
                    datajson = '';

                },
                failure: function() {
                    Ext.example.msg("Error");
                    dataStoreForGrid.reload();
                    datajson = '';
                    Ext.getCmp('branchcomboId').reset();
                    Ext.getCmp('vendor').reset();
                    ButtonValue = '';
                }
            });
        } else {
            Ext.example.msg("Please Enter Data And Try To Save");
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
        //  cls: 'selectstylePerfect',
        width: 200,
        height: 130,
        listeners: {
            select: {
                fn: function() {

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

                }
            }
        }
    });




    var clientPanel = new Ext.Panel({
        standardView: true,
        collapsible: false,
        id: 'clientPanelId',
        layout: 'table',
        frame: true,
        width: screen.width - 40,
        height: 40,
        layoutConfig: {
            columns: 8
        },
        items: [{
                xtype: 'label',
                cls: 'labelstyle',
                id: 'startdatelab',
                text: 'Date' + ' :',
                style:'vertical-align: -webkit-baseline-middle'
            }, {
                xtype: 'datefield',
                cls: 'selectstylePerfect',
                width: 185,
                format: getDateFormat(),
                emptyText: 'SelectDate',
                allowBlank: false,
                blankText: 'Select  Date',
                id: 'startdate',
                maxValue: dtcur,
                value: dtcur,
                DateField: 'date'
            }, {
                width: 80
            }, {
                xtype: 'label',
                cls: 'labelstyle',
                id: 'vendorlab',
                text: 'Vendor Name' + ' :',
                style:'vertical-align: -webkit-baseline-middle'
            }, {
                xtype: 'textfield',
                cls: 'selectstylePerfect',
                width: 185,
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
                maskRe: /[a-zA-Z ]/i

            }, {
                width: 80
            }, {
                xtype: 'label',
                cls: 'labelstyle',
                id: 'branchlab',
                text: 'Branch Name' + ' :',
                style:'vertical-align: -webkit-baseline-middle'
            },
            branchcombo
        ]
    });




    var reader = new Ext.data.JsonReader({
        root: 'stationaryDetailsroot',
        fields: [{
                name: 'StationaryIyemDataIndex',
                type: 'string'
            }, {
                name: 'StationaryIyemIDDataIndex',
                type: 'string'
            }, {
                name: 'QuantityDataIndex',
                type: 'string'
            }, {
                name: 'RemainingQuantityDataIndex',
                type: 'string'
            },{
                name: 'RemarksDataIndex',
                type: 'string'
            }, {
                name: 'InsertedDatetimeIndex',
                type: 'string'
            }, {
                name: 'InsertedByIndex',
                type: 'string'
            },{
                name: 'VendorNameDataIndex',
                type: 'string'
            }


        ]
    });

    var dataStoreForGrid = new Ext.data.GroupingStore({
        url: '<%=request.getContextPath()%>/StationaryMasterAction.do?param=viewStationary',
        bufferSize: 367,
        reader: reader,
        root: 'stationaryDetailsroot',
        autoLoad: false,
        remoteSort: true
    });

    var Plant = Ext.data.Record.create([{
            name: 'StationaryIyemDataIndex'
        }, {
            name: 'StationaryIyemIDDataIndex'
        }, {
            name: 'QuantityDataIndex'
        }, {
            name: 'RemainingQuantityDataIndex'
        },{
            name: 'RemarksDataIndex'
        }, {
            name: 'InsertedDatetimeIndex'
        }, {
            name: 'InsertedByIndex'
        }, { 
            name: 'VendorNameDataIndex'
            }

    ]);

    function getcmnmodel() {
        toolGridColumnModel = new Ext.grid.ColumnModel(
            [
                new Ext.grid.RowNumberer({
                    header: '<B>SLNO</B>',
                    width: 45
                }), {
                    header: '<B>Stationary Item</B>',
                    sortable: true,
                    width: 250,
                    dataIndex: 'StationaryIyemDataIndex',
                    editable: true,
                    renderer: getassetrender,
                    editor: new Ext.grid.GridEditor(
                        assetcombo)

                }, {
                    header: '<B>Stationary Item ID</B>',
                    width: 250,
                    dataIndex: 'StationaryIyemIDDataIndex',
                    hidden: true,
                    sortable: true
                }, {
                    header: '<B>Quantity</B>',
                    sortable: true,
                    width: 250,
                    dataIndex: 'QuantityDataIndex',
                    editable: true,
                    editor: new Ext.grid.GridEditor(new Ext.form.NumberField({
                        width: 140,
                        cls: 'bskExtStyle'
                    }))

                }, {
                    header: '<B>Remaining Quantity</B>',
                    sortable: true,
                    width: 250,
                    dataIndex: 'RemainingQuantityDataIndex'
                }, {
                    header: '<B>Remarks</B>',
                    sortable: true,
                    width: 250,
                    dataIndex: 'RemarksDataIndex',
                    editable: true,
                    hidable:true,
                    editor: new Ext.grid.GridEditor(new Ext.form.TextField({
                        width: 100,
                        id: 'countFieldId',
                        cls: 'bskExtStyle',
                        //maskRe: /[1,2,3]/,
                        disabled: false,
                        maxLength: 100
                    }))

                }, {
                    header: '<B>Actual Inward Time</B>',
                    sortable: true,
                    width: 250,
                    dataIndex: 'InsertedDatetimeIndex',
                    hidable: true
                }, {
                    header: '<B>Inwarded By</B>',
                    sortable: true,
                    width: 250,
                    dataIndex: 'InsertedByIndex',
                    hidable: true
                }, {
                    header: '<B>Vendor Name</B>',
                    sortable: true,
                    width: 250,
                    dataIndex: 'VendorNameDataIndex',
                    hidable: true
                }
            ]);
        return toolGridColumnModel;
    }
// bhagyashree
    function getassetrender(value, p, r) {
        var returnValue = "";
        if (assetcombostore.isFiltered()) {
            assetcombostore.clearFilter();
        }
        var idx = assetcombostore.findBy(function(record) {
            if (record.get('itemId') == value) {
                returnValue = record.get('itemName');
                return true;
            }
        });
        return returnValue;
    }


    var AssetGrid = new Ext.grid.EditorGridPanel({
        title: 'Stationary Item Details',
        header: true,
        id: 'toolGridid',
        ds: dataStoreForGrid,
        cm: getcmnmodel(),
        stripeRows: true,
        border: true,
        width: screen.width - 45,
        height: 455,
        autoScroll: true,
        // plugins: [filters],
        clicksToEdit: 1,
        selModel: new Ext.grid.RowSelectionModel(),
        tbar: [{
            text: 'Add',
            handler: function() {
                if (ButtonValue != '') {
                    Ext.example.msg("Please Refresh The Page And Inward New Item");
                    return;
                }
                if (Ext.getCmp('vendor').getValue().trim() == "") {

                    Ext.example.msg("Please Enter VendorName");
                    Ext.getCmp('vendor').focus();
                    return;
                }
                if (Ext.getCmp('branchcomboId').getValue() == "") {

                    Ext.example.msg("Please Select BranchName");
                    Ext.getCmp('branchcomboId').focus();
                    return;
                }
                addPlant++;

                var p = new Plant({
                    SLNODataIndex: "new" + addPlant,
                    StationaryIyemDataIndex: "",
                    QuantityDataIndex: "",
                    RemarksDataIndex: "",
                    InsertedDatetimeIndex: new Date().format('d/m/Y h:m:s'),
                    InsertedByIndex: '<%=username%>'

                });
                AssetGrid.stopEditing();
                dataStoreForGrid.insert(0, p);
                AssetGrid.startEditing(0, 0);
            }
        }, '-', {
            text: 'Save',

            handler: function() {
if( ButtonValue == 'Inward'|| ButtonValue == 'Stock' ){

  Ext.example.msg("Please Refresh The Page And Inward New Item");
                    return;
}
                if (Ext.getCmp('vendor').getValue() == "") {

                    Ext.example.msg("Please Enter VendorName");
                    Ext.getCmp('vendor').focus();
                    return;
                }
                if (Ext.getCmp('branchcomboId').getValue() == "") {

                    Ext.example.msg("Please Select BranchName");
                    Ext.getCmp('branchcomboId').focus();
                    return;
                }

                ajaxfunction();
            }
        }, '-', {
            text: 'Refresh',

            handler: function() {
                dataStoreForGrid.load({
                    params: {
                        CustId: '0'
                    }
                });
                    AssetGrid.getColumnModel().setHidden(AssetGrid.getColumnModel().findColumnIndex('InsertedDatetimeIndex'), false);
                    AssetGrid.getColumnModel().setHidden(AssetGrid.getColumnModel().findColumnIndex('InsertedByIndex'), false);
                    AssetGrid.getColumnModel().setHidden(AssetGrid.getColumnModel().findColumnIndex('RemarksDataIndex'), false);
                    AssetGrid.getColumnModel().setHidden(AssetGrid.getColumnModel().findColumnIndex('RemainingQuantityDataIndex'), false);                    
                    AssetGrid.getColumnModel().setHidden(AssetGrid.getColumnModel().findColumnIndex('StationaryIyemDataIndex'), false);                    
                    AssetGrid.getColumnModel().setHidden(AssetGrid.getColumnModel().findColumnIndex('StationaryIyemIDDataIndex'), false);                    
                    AssetGrid.getColumnModel().setHidden(AssetGrid.getColumnModel().findColumnIndex('QuantityDataIndex'), false);                    
                    AssetGrid.getColumnModel().setHidden(AssetGrid.getColumnModel().findColumnIndex('VendorNameDataIndex'), false);                    
                
                Ext.getCmp('branchcomboId').reset();
                Ext.getCmp('vendor').reset();
                ButtonValue = '';

            }
        }, '-', {
            text: 'View Inward',
            handler: function() {
            AssetGrid.stopEditing();
                

                if (Ext.getCmp('branchcomboId').getValue() == "") {

                    Ext.example.msg("Please Select BranchName");
                    Ext.getCmp('branchcomboId').focus();
                    return;
                }
                AssetGrid.getColumnModel().setHidden(AssetGrid.getColumnModel().findColumnIndex('InsertedDatetimeIndex'), false);
                AssetGrid.getColumnModel().setHidden(AssetGrid.getColumnModel().findColumnIndex('InsertedByIndex'), false);
                AssetGrid.getColumnModel().setHidden(AssetGrid.getColumnModel().findColumnIndex('RemarksDataIndex'), false);                
                AssetGrid.getColumnModel().setHidden(AssetGrid.getColumnModel().findColumnIndex('RemainingQuantityDataIndex'), true);                     
                ButtonValue = 'Inward';
                dataStoreForGrid.load({
                    params: {
                        ButtonValue: ButtonValue,
                        InwardDate: Ext.getCmp('startdate').getValue(),
                        VendorName: Ext.getCmp('vendor').getValue(),
                        BranchId: Ext.getCmp('branchcomboId').getValue(),
                        CustId: <%= customerId %>
                    }
                });

            }
        }, '-', {
            text: 'View Stock',

            handler: function() {
            AssetGrid.stopEditing();
              
                if (Ext.getCmp('branchcomboId').getValue() == "") {

                    Ext.example.msg("Please Select BranchName");
                    Ext.getCmp('branchcomboId').focus();
                    return;
                }
                AssetGrid.getColumnModel().setHidden(AssetGrid.getColumnModel().findColumnIndex('InsertedDatetimeIndex'), true);
                AssetGrid.getColumnModel().setHidden(AssetGrid.getColumnModel().findColumnIndex('InsertedByIndex'), true);
                AssetGrid.getColumnModel().setHidden(AssetGrid.getColumnModel().findColumnIndex('RemarksDataIndex'), true);
                AssetGrid.getColumnModel().setHidden(AssetGrid.getColumnModel().findColumnIndex('RemainingQuantityDataIndex'), false);                                    
                ButtonValue = 'Stock';
                dataStoreForGrid.load({
                    params: {
                        ButtonValue: ButtonValue,
                        InwardDate: Ext.getCmp('startdate').getValue(),
                        VendorName: Ext.getCmp('vendor').getValue(),
                        BranchId: Ext.getCmp('branchcomboId').getValue(),
                        CustId: <%= customerId %>
                    }
                });

            }
        }]
    });


    AssetGrid.on({
        beforeedit: function(e) {
        },
        afteredit: function(e) {
            var field = e.field;
            if (field == "StationaryIyemDataIndex") {

                var itemvalue = Ext.getCmp('assetcomboId').getRawValue();
                e.record.set('StationaryIyemIDDataIndex', itemvalue);

            }

        }
    });

    Ext.onReady(function() {
        Ext.QuickTips.init();
        Ext.Ajax.timeout = 180000;
        Ext.form.Field.prototype.msgTarget = 'side';
        outerPanel = new Ext.Panel({
            title: 'Inward Stationary',
            renderTo: 'content',
            id: 'outerPanel',
            standardView: true,
            autoScroll: false,
            frame: true,
            border: false,
            width: screen.width - 22,
            height: 550,
            layout: 'table',
            cls: 'outerpanel',
            layoutConfig: {
                columns: 1
            },
            items: [clientPanel, AssetGrid]
        });

    });
</script>
	 <jsp:include page="../Common/footer.jsp" />
 <!-- </body>   -->
 <!-- </html> -->
