<%@ page  language="java" import="java.util.*,java.text.SimpleDateFormat,t4u.functions.*,t4u.beans.*,t4u.common.*" pageEncoding="utf-8"%>
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
	loginInfo.setCountryCode(Integer.parseInt(str[11].trim()));
	session.setAttribute("loginInfoDetails",loginInfo);
	
}
	
	CommonFunctions cf = new CommonFunctions();
	LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
	cf.checkLoginInfo((LoginInfoBean) session.getAttribute("loginInfoDetails"), session, request, response);
	String responseaftersubmit="''";
	String feature="1";
	if (loginInfo == null) {
		response.sendRedirect(request.getContextPath()
				+ "/Jsps/Common/SessionDestroy.html");
	} else {
		session.setAttribute("loginInfoDetails", loginInfo);
		String language = loginInfo.getLanguage();
		int systemId = loginInfo.getSystemId();
		int customerId = loginInfo.getCustomerId();
		String BookingType = request.getParameter("BookingType");
		String ContainerNo = request.getParameter("containerNo");
		String bookingId = request.getParameter("bookingId");

ArrayList<String> tobeConverted = new ArrayList<String>();

tobeConverted.add("Modified_Date_Time");
tobeConverted.add("Add");
tobeConverted.add("Modify");
tobeConverted.add("No_Records_Found");
tobeConverted.add("Clear_Filter_Data");
tobeConverted.add("SLNO");
tobeConverted.add("Id");
tobeConverted.add("Delete");
tobeConverted.add("No_Rows_Selected");
tobeConverted.add("Select_Single_Row");
tobeConverted.add("Save");
tobeConverted.add("Cancel");
tobeConverted.add("Excel");



ArrayList<String> convertedWords = new ArrayList<String>();
convertedWords = cf.getLanguageSpecificWordForKey(tobeConverted,language);

String ModifiedDateTime=convertedWords.get(0);
String Add=convertedWords.get(1);
String Modify=convertedWords.get(2);
String NoRecordsFound=convertedWords.get(3);
String ClearFilterData=convertedWords.get(4);
String SLNO=convertedWords.get(5);
String ID=convertedWords.get(6);
String Delete=convertedWords.get(7);
String NoRowsSelected=convertedWords.get(8);
String SelectSingleRow=convertedWords.get(9);
String Save=convertedWords.get(10);
String Cancel=convertedWords.get(11);
String Excel=convertedWords.get(12);


int userId=loginInfo.getUserId(); 

%>
<!DOCTYPE HTML>
<html>
 <head>
 		<title>Rake Container Information</title>		
</head>	    
	 <style>
  .x-panel-tl
	{
		border-bottom: 0px solid !important;
	}
  </style>
  <body>
   <%if (loginInfo.getStyleSheetOverride().equals("Y")){%>
	<jsp:include page="../Common/ImportJSSandMining.jsp"/>
	<jsp:include page="../IronMining/css.jsp" />
	<%}else{%>
	<jsp:include page="../Common/ImportJS.jsp" />
	<jsp:include page="../IronMining/css.jsp" />
	<%}%>
   <jsp:include page="../Common/ExportJS.jsp" />
   <script>
   
var outerPanel;
var ctsb;
var jspName = "Assign Vehicles";
var exportDataType = "";
var selected;
var grid;
var buttonValue;
var titelForInnerPanel;
var myWin;
var editedRows = "";
var globalClientId = "";
var addPlant = 0;
var bookingType=<%=BookingType%>;
var containerNo=<%=ContainerNo%>;
var bookingId=<%=bookingId%>;
var containerNoFormat = "";
var objRegExp = /(^[A-Za-z]{4}[0-9]{6}[0-9]{1}$)/;
var trueOrFalse = "";

								
var ContainerSizeStore = new Ext.data.SimpleStore({
    autoLoad: true,
    fields: ['containerSizeId', 'conatainerSizeValue'],
    data: [
        ['20ft', '20ft'],
        ['40ft', '40ft']
    ]
});
var containerSizeCombo = new Ext.form.ComboBox({
    frame: false,
    store: ContainerSizeStore,
    id: 'containerSizeComboId',
    width: 155,
    forceSelection: true,
    emptyText: 'Container Size',
    anyMatch: true,
    onTypeAhead: true,
    resizable: true,
    enableKeyEvents: true,
    mode: 'local',
    triggerAction: 'all',
    displayField: 'conatainerSizeValue',
    valueField: 'containerSizeId',
    listeners: {
        select: {
            fn: function() {
                
            }
        }
    }
});

var loadTypeStore = new Ext.data.SimpleStore({
    autoLoad: true,
    fields: ['loadTypeId', 'loadTypeValue'],
    data: [
        ['1', 'Loaded'],
        ['2', 'Empty']
    ]
});
var loadTypeCombo = new Ext.form.ComboBox({
    frame: false,
    store: loadTypeStore,
    id: 'loadTypeComboId',
    width: 155,
    forceSelection: true,
    emptyText: 'Load type',
    anyMatch: true,
    onTypeAhead: true,
    resizable: true,
    enableKeyEvents: true,
    mode: 'local',
    triggerAction: 'all',
    displayField: 'loadTypeValue',
    valueField: 'loadTypeId',
    listeners: {
        select: {
            fn: function() {
                
            }
        }
    }
});
var locationStore= new Ext.data.JsonStore({
        url: '<%=request.getContextPath()%>/RakeShiftBookingAction.do?param=getLocation',
	    root: 'locationStoreRoot',
	    autoload: true,
	    remoteSort: true,
	    fields: ['LocationName']
	});	
	
var locationcombo = new Ext.form.ComboBox({
    frame: false,
    store: locationStore,
    id: 'locationcomboId',
    width: 155,
    forceSelection: true,
    emptyText: 'Select Location',
    anyMatch: true,
    onTypeAhead: true,
    resizable: true,
    enableKeyEvents: true,
    mode: 'local',
    triggerAction: 'all',
    displayField: 'LocationName',
    valueField: 'LocationName',
    listeners: {
        select: {
            fn: function() {
                
            }
        }
    }
});

var BillingCustomerStore= new Ext.data.JsonStore({
        url: '<%=request.getContextPath()%>/RakeShiftBookingAction.do?param=getBillingCustomer',
	    root: 'billingCustomerStoreRoot',
	    autoload: true,
	    remoteSort: true,
	    fields: ['BillingCustomerId','BillingCustomerName']
	});	
	
var billingCustomercombo = new Ext.form.ComboBox({
    frame: false,
    store: BillingCustomerStore,
    id: 'billingCustomerComboId',
    width: 155,
    forceSelection: true,
    emptyText: 'Select Billing Customer',
    anyMatch: true,
    onTypeAhead: true,
    resizable: true,
    enableKeyEvents: true,
    mode: 'local',
    triggerAction: 'all',
    displayField: 'BillingCustomerName',
    valueField: 'BillingCustomerId',
    listeners: {
        select: {
            fn: function() {
                
            }
        }
    }
});

function getLoadTyperender(value, p, r){
  	 var returnValue="";
	 if(loadTypeStore.isFiltered()){
			loadTypeStore.clearFilter();
		}
      var idx = loadTypeStore.findBy(function(record){
        if(record.get('loadTypeId') == value) {
            returnValue = record.get('loadTypeValue');
            return true;
        }
    });
 	 return returnValue;		  
   }

function getBillingCustomerrender(value, p, r){
  	 var returnValue="";
	 if(BillingCustomerStore.isFiltered()){
			BillingCustomerStore.clearFilter();
		}
      var idx = BillingCustomerStore.findBy(function(record){
        if(record.get('BillingCustomerId') == value) {
            returnValue = record.get('BillingCustomerName');
            return true;
        }
    });
 	 return returnValue;		  
   }
   
 
//============================ Grid table creation ================================
		//********** reader *************
     	var reader = new Ext.data.JsonReader({
        idProperty: 'darreaderid',
        root: 'ContainerInfoRoot',
        totalProperty: 'total',
        fields: [{
        	name: 'slnoIndex'
        },{
        	name: 'uidIndex'
        },{
        	name: 'AllocatedIndex'
        },{ 
        	name: 'ContainerNoIndex'
        },{
            name: 'sizeIndex',
        }, {
            name: 'loadTypeIndex'
        }, {
            name: 'locationIndex'
        }, {
            name: 'shipperNameIndex'
        }, {
            name: 'billingCustIndex'
        }, {
            name: 'weightIndex'
        }, {
            name: 'sbblNoIndex'
        }, {
            name: 'remarksIndex'
        },{
            name: 'statusIndex'
        }]
    });

	var Plant = Ext.data.Record.create([
		{name:'slnoIndex'},
		{name:'uidIndex'},
		{name:'AllocatedIndex'},
		{name:'ContainerNoIndex'},
		{name:'sizeIndex'},
		{name:'loadTypeIndex'},
		{name:'locationIndex'},
		{name:'shipperNameIndex'},
		{name:'billingCustIndex'},
		{name:'weightIndex'},
		{name:'sbblNoIndex'},
		{name:'remarksIndex'},
		{name:'statusIndex'}
	]);
//********** store *****************
		var Store = new Ext.data.GroupingStore({
        autoLoad: false,
        proxy: new Ext.data.HttpProxy({
           	url: '<%=request.getContextPath()%>/RakeShiftBookingAction.do?param=getContainerData',
            method: 'POST'
        }),
        remoteSort: false,
        storeId: 'darstore',
        reader: reader
    	});
    	//*********** filters **********
		var filters = new Ext.ux.grid.GridFilters({
        local: true,
        filters: [{
            type: 'numeric',
            dataIndex: 'slnoIndex'
        }, {
            type: 'numeric',
            dataIndex: 'uidIndex'
        }, {
            type: 'string',
            dataIndex: 'AllocatedIndex'
        },{
            type: 'string',
            dataIndex: 'ContainerNoIndex'
        },{
            type: 'string',
            dataIndex: 'sizeIndex'
        }, {
            type: 'string',
            dataIndex: 'loadTypeIndex'
        }, {
            type: 'string',
            dataIndex: 'locationIndex'
        }, {
            type: 'string',
            dataIndex: 'shipperNameIndex'
        }, {
            type: 'string',
            dataIndex: 'billingCustIndex'
        }, {
            type: 'float',
            dataIndex: 'weightIndex'
        }, {
            type: 'string',
            dataIndex: 'sbblNoIndex'
        }, {
            type: 'string',
            dataIndex: 'remarksIndex'
        },{
            type: 'string',
            dataIndex: 'statusIndex'
        }]
      });

var createColModel = function (finish, start) {

        var columns = [
            new Ext.grid.RowNumberer({
                header: "<span style=font-weight:bold;><%=SLNO%></span>",
                width: 50
            }),{
                dataIndex: 'slnoIndex',
                hidden: true,
                header: "<span style=font-weight:bold;><%=SLNO%></span>",
                filter: {
                    type: 'numeric'
                }
            },{
                dataIndex: 'uidIndex',
                hidden: true,
                header: "<span style=font-weight:bold;>UID</span>",
                filter: {
                    type: 'numeric'
                }
            },{
                dataIndex: 'AllocatedIndex',
                hidden: true,
                header: "<span style=font-weight:bold;>Allocated</span>",
                filter: {
                    type: 'string'
                }
            },{
                header: "<span style=font-weight:bold;>Container No</span>",
                dataIndex: 'ContainerNoIndex',
                hidden: false,
				sortable: true,
                width: 100,
                filter: {
                    type: 'string'
                },
                editor: new Ext.grid.GridEditor(new Ext.form.TextField({})),
            }, {
        		header: "<span style=font-weight:bold;>Size</span>",
           	 	dataIndex: 'sizeIndex',
           	 	hidden: false,
				sortable: true,
            	filter: {
            	type: 'string'
            	},
            	editor: new Ext.grid.GridEditor(containerSizeCombo)
        	}, {
                header: "<span style=font-weight:bold;>Load Type</span>",
                dataIndex: 'loadTypeIndex',
                hidden: false,
				sortable: true,
                width: 100,
                filter: {
                    type: 'string'
                },
                editor: new Ext.grid.GridEditor(loadTypeCombo),
                renderer: getLoadTyperender,
            }, {
                header: "<span style=font-weight:bold;>Location</span>",
                dataIndex: 'locationIndex',
                hidden: false,
				sortable: true,
                width: 100,
                filter: {
                    type: 'string'
                },
                editor: new Ext.grid.GridEditor(locationcombo)
            }, {
                header: "<span style=font-weight:bold;>Shipper Name</span>",
                dataIndex: 'shipperNameIndex',
                hidden: true,
				sortable: true,
                editor: new Ext.grid.GridEditor(new Ext.form.TextField({})),
                filter: {
                    type: 'string'
                }
            }, {
                header: "<span style=font-weight:bold;>Billing Customer</span>",
                dataIndex: 'billingCustIndex',
                hidden: true,
				sortable: true,
                filter: {
                    type: 'string'
                },
                editor: new Ext.grid.GridEditor(billingCustomercombo),
                renderer: getBillingCustomerrender
            }, {
                header: "<span style=font-weight:bold;>Weight</span>",
                dataIndex: 'weightIndex',
                hidden: true,
				sortable: true,
                filter: {
                    type: 'numeric'
                },
                editor: new Ext.grid.GridEditor(new Ext.form.NumberField({
                allowNegative: false
                
                }))
            }, {
                header: "<span style=font-weight:bold;>SB/BL Number</span>",
                dataIndex: 'sbblNoIndex',
                hidden: true,
				sortable: true,
                editor: new Ext.grid.GridEditor(new Ext.form.TextField({})),
                filter: {
                    type: 'string'
                }
            }, {
                header: "<span style=font-weight:bold;>Remarks</span>",
                dataIndex: 'remarksIndex',
                hidden: false,
				sortable: true,
                editor: new Ext.grid.GridEditor(new Ext.form.TextField({})),
                filter: {
                    type: 'string'
                }
            }, {
                header: "<span style=font-weight:bold;>Status</span>",
                dataIndex: 'statusIndex',
                hidden: false,
				sortable: true,
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


Grid = getEditorGrid('', '<%=NoRecordsFound%>', Store, screen.width - 35, 450, 14, filters, '<%=ClearFilterData%>', false, '', 14, false, '', false, '', false, '<%=Excel%>', jspName, exportDataType, false, 'PDF',false,'<%=Add%>');

function getEditorGrid(gridtitle,emptytext,store,width,height,gridnoofcols,filters,filterstr,reconfigure,reconfigurestr,reconfigurenoofcols,group,groupstr,chart,chartstr,excel,excelstr,jspName,exportDataType,pdf,pdfstr,add,addstr,modify,modifystr,del,delstr){
	 var grid = new Ext.grid.EditorGridPanel({
	    	title:gridtitle,
	        border: false,
	        height: getGridHeight(),
	        autoScroll:true,
	        store: store,
	        id:'GridId',
	        colModel: createColModel(gridnoofcols),
	        loadMask: true,
	        view: new Ext.grid.GroupingView({
	        	autoFill:true,
	            groupTextTpl: getGroupConfig(),
	            emptyText: emptytext,deferEmptyText: false
	        }),
	        plugins: [filters],
	        clicksToEdit: 1,
	        bbar: new Ext.Toolbar({
	        }),
	         tbar: [{
             text: '<b>Add</b>',
             handler: function() {
             var rowCnt=grid.store.getCount();
             if (rowCnt+1 > containerNo) {
                   Ext.example.msg("Maximum Container Number reached");
                       return;
               }
             addPlant++;
               
				 var p = new Plant({
                         slnoIndex: "new" + addPlant,
                         uidIndex:"",
                         AllocatedIndex:"",
                         ContainerNoIndex:"",
                         sizeIndex:"",
                         loadTypeIndex:"",
                         locationIndex:"",
                         shipperNameIndex:"",
                         billingCustIndex:"",
                         weightIndex:"",
                         sbblNoIndex:"",
                         remarksIndex:"",
                         statusIndex:"Pending"
                                         
               });
               editedRows = editedRows + "new" + addPlant + ",";
               if (Grid.store.data.length == 0) {
                   Ext.getCmp('GridId').view.emptyText = "";
                   Ext.getCmp('GridId').view.refresh();
               }
               Ext.getCmp('GridId').stopEditing();
               Ext.getCmp('GridId').store.insert(0, p);
               Grid.startEditing(0, 2);
               if (Grid.store.data.length == 1) {
                   Ext.getCmp('GridId').view.emptyText = 'No Records Found..';
                   Ext.getCmp('GridId').view.refresh();
               }
             }
             }, '-', {
             text: '<b>Save<b>',
             handler: function() {
             var json = "";
	         var temp = editedRows.split(",");
	           for (var i = 0; i < temp.length; i++) {
	               var row = Grid.store.find('slnoIndex', temp[i]);
	               if (row == -1) {
	                   continue;
	               }
	               var store = Grid.store.getAt(row);
	               if (store.data['ContainerNoIndex'] == "") {
                       Ext.example.msg("Enter Container No.");
                       return;
                   	}
                   	containerNoFormat = store.data['ContainerNoIndex'];
                        trueOrFalse = objRegExp.test(containerNoFormat)
                        if (trueOrFalse == false) {
                        	Ext.example.msg("Enter Container Number In This Format ABCD1234560");
                       		return;
                        }
                   	if (store.data['sizeIndex'] == "") {
                       Ext.example.msg("Select Size");
                       return;
                   	}
                   	if (store.data['loadTypeIndex'] == "") {
                       Ext.example.msg("Select Load Type");
                       return;
                   	}
                   	if (store.data['locationIndex'] == "") {
                       Ext.example.msg("Select Location");
                       return;
                   	}
<!--                   		if (store.data['remarksIndex'] == "") {-->
<!--                       Ext.example.msg("Select Remarks");-->
<!--                       return;-->
<!--                   	}-->
                   	if(bookingType == 1){
                   	if (store.data['shipperNameIndex'] == "") {
                       Ext.example.msg("Enter Shipper Name");
                       return;
                   	}
                   	if (store.data['billingCustIndex'] == "") {
                       Ext.example.msg("Enter Billing Customer Name");
                       return;
                   	}
                   
                   	if (store.data['weightIndex'] == "") {
                       Ext.example.msg("Enter Weight");
                       return;
                       if( store.data['weightIndex'] == "0") {
                       Ext.example.msg("Weight Cannot be Zero");
                       return;
                       }
                   	}
                   	if (store.data['sbblNoIndex'] == "") {
                       Ext.example.msg("Enter SB/BL Number");
                       return;
                   	}
                   	}
                   	json += Ext.util.JSON.encode(store.data) + ',';
             	}
             			var json1 = '';                    	
	       				 for (var i = 0; i <Grid.getStore().data.length; i++) {
	          	  		 var record = Grid.getStore().getAt(i); 
	           			 json1 += Ext.util.JSON.encode(record.data) + ',';
	      				  }
             	if (json != '') {
             			outerPanel.getEl().mask();
                        Ext.Ajax.request({
                            url: '<%=request.getContextPath()%>/RakeShiftBookingAction.do?param=saveContainerInformation',
                            method: 'POST',
                            params: {
                            	jsonData: json,
                                bookingId: bookingId,
                                bookingType :bookingType,
                                completejsonData: json1
                                
                            },
                            success: function(response, options) {
                                var message = response.responseText;
                                if(message == "Duplicate Container number not allowed")
                                {
                                Ext.example.msg(message);
                                outerPanel.getEl().unmask();
                                }else{
                                Ext.example.msg(message);
                                json = '';
                                Store.reload();
                                outerPanel.getEl().unmask();
                                }
                            },
                            failure: function() {
                               Store.reload();
                                outerPanel.getEl().unmask();
                                json = '';
                            }
                        });
                    } else if(editedRows==""){
                        Ext.example.msg("No row has changed to save");
                        return;
                    }
             }
             }, '-', {
             text: '<b>Refresh<b>',
             handler: function() {
             Grid.store.reload();
             addPlant = 0;
             editedRows = "";
             }
             }, '-', {
             text: '<b>Remove Filters<b>',
             handler: function() {
             Grid.filters.clearFilters();
             addPlant = 0;
             editedRows = "";
             }
             }, '-', {
             text: '<b>Back<b>',
             handler: function() {
             	Grid.store.reload();
             	addPlant = 0;
             	editedRows = "";
             	window.location = "<%=request.getContextPath()%>/Jsps/ContainerCargoManagement/RakeShiftBooking.jsp"
             	}
             }, '-', {
               text: '<b>Import<b>',
               handler: function() {
               
               	importButton = "import";
			    importTitle = 'Import Details Rake / Shift';
			    importWin.show();
			    isWindow = true;
			    importWin.setTitle(importTitle);
               }
             }
             ]
	    });
	if(width>0){
		grid.setSize(width,height);

	}
	if(reconfigure){
		grid.getBottomToolbar().add([
			{
            text: reconfigurestr,
            handler: function () {
			grid.reconfigure(store, createColModel(reconfigurenoofcols));
            } 
        }]);
		}
	return grid;
}

		Grid.on({
            afteredit: function(e) {
                var field = e.field;
                var slno = e.record.data['slnoIndex'];
                temp = editedRows.split(",");
                isIn = 0;
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
        
        
          var fp = new Ext.FormPanel({

				    fileUpload: true,
				    width: '100%',
				    frame: true,
				    autoHeight: true,
				    standardSubmit: false,
				    labelWidth: 80,
				    height: 50,
				    defaults: {
				        anchor: '45%',
				        allowBlank: false,
				        msgTarget: 'side'
				    },
				    items: [
				          {
					        xtype: 'fileuploadfield',
					        id: 'filePath',
					        width: 30,
					        emptyText: 'Browse',
					        fieldLabel: 'ChooseFile',
					        name: 'filePath',
					        buttonText: 'Browse',
					        buttonCfg: {
						        iconCls: 'browsebutton'
				         },
				         listeners: {
				
				            fileselected: {
				                fn: function () {
				                    var filePath = document.getElementById('filePath').value;
				                    var imgext = filePath.substring(filePath.lastIndexOf(".") + 1, filePath.length);
				                    if (imgext == "xls" || imgext == "xlsx") {
				
				                    } else {
				                        Ext.MessageBox.show({
				                            msg: 'Please select only .xls or .xlsx files',
				                            buttons: Ext.MessageBox.OK
				                        });
				                        Ext.getCmp('filePath').setValue("");
				                        return;
				                    }
				                }
				            }
				
				        }
				    }],
				    buttons: [{
				        text: 'Upload',
				        iconCls : 'uploadbutton',
				        handler: function () {
				            if (fp.getForm().isValid()) {
				                var filePath = document.getElementById('filePath').value;
				
				                var imgext = filePath.substring(filePath.lastIndexOf(".") + 1, filePath.length);
				                if (imgext == "xls" || imgext == "xlsx") {
									clearInputData();
				                } else {
				                    Ext.MessageBox.show({
				                        msg: 'Please select only .xls or .xlsx files',
				                        buttons: Ext.MessageBox.OK
				                    });
				                    Ext.getCmp('filePath').setValue("");
				                    return;
				                }
				                fp.getForm().submit({
				                    url: "<%=request.getContextPath()%>/RakeShiftBookingAction.do?param=importRakeShiftDetailsExcel&bookingType=<%=BookingType%>",
				                    enctype: 'multipart/form-data',
				                    waitMsg: 'Uploading your file...',
				                    success: function (response, action) {
				                    if(<%=BookingType%> == 2){
				                    	importgrid.getColumnModel().setHidden(importgrid.getColumnModel().findColumnIndex('importShipperNameIndex'), true);
				                    	importgrid.getColumnModel().setHidden(importgrid.getColumnModel().findColumnIndex('importBillingCustomerIndex'), true);
				                    	importgrid.getColumnModel().setHidden(importgrid.getColumnModel().findColumnIndex('importWeightIndex'), true);
				                    	importgrid.getColumnModel().setHidden(importgrid.getColumnModel().findColumnIndex('importSBBLNoIndex'), true);
				                    }else{
				                    	importgrid.getColumnModel().setHidden(importgrid.getColumnModel().findColumnIndex('importShipperNameIndex'), false);
				                    	importgrid.getColumnModel().setHidden(importgrid.getColumnModel().findColumnIndex('importBillingCustomerIndex'), false);
				                    	importgrid.getColumnModel().setHidden(importgrid.getColumnModel().findColumnIndex('importWeightIndex'), false);
				                    	importgrid.getColumnModel().setHidden(importgrid.getColumnModel().findColumnIndex('importSBBLNoIndex'), false);
				                    }
									Ext.Ajax.request({
				                        url: '<%=request.getContextPath()%>/RakeShiftBookingAction.do?param=getImportILMSDetails',
				                        method: 'POST',
				                        params: {
				                            ilmsImportResponse: action.response.responseText
				                        },
				                        success: function (response, options) {
				                            ilmsResponseImportData  = Ext.util.JSON.decode(response.responseText);
				                            importstore.loadData(ilmsResponseImportData);
				                            
				                        },
				                        failure: function () {
				                        Ext.example.msg("Error");
				                        }
				                    });
									   
				                    },
				                    failure: function () {
				                    Ext.example.msg("Please Upload The Standard Format");
				                    }
				                });
				            }
				        }
				    }, {
						text: 'Get Standard Format',
						iconCls : 'downloadbutton',
					    handler : function(){
					    Ext.getCmp('filePath').setValue("Upload the Standard Format");
					    fp.getForm().submit({
					    	url:'<%=request.getContextPath()%>/RakeShiftBookingAction.do?param=openStandardFileFormat&bookingType=<%=BookingType%>'
					    	});
						}	   
					},
					{
						text: 'Close',
						iconCls: 'closebutton',
						handler: function()
						{
							if(isWindow){
								fp.getForm().reset();
								importWin.hide();
								//clearInputData();
								isWindow=false;
								 }else{
								importWin.hide();
							}
						}
					}]
				});
				
				
	function closeImportWin(){	
	if(isWindow){
	fp.getForm().reset();
	importWin.hide();
	clearInputData();
	isWindow=false;
	 }else{
	myWin.hide();
	}	
}

function saveDate(){

var ValidCount = 0;
var totalcount = importstore.data.length;
    for (var i = 0; i < importstore.data.length; i++) {
        var record = importstore.getAt(i);
        var checkvalidOrInvalid = record.data['importValidstatusIndex'];
        if (checkvalidOrInvalid == 'Valid') {
            ValidCount++;
        }
    }
    
	var saveJson = getJsonOfStore(importstore);
	
	
Ext.Msg.show({
        title: 'Saving..',
        msg: 'We have ' + ValidCount + ' valid transaction to be saved out of ' + totalcount + ' .Do you want to continue?',
        buttons: Ext.Msg.YESNO,
        fn: function (btn) {
            if (btn == 'no') {
                return;
            }
            if (btn == 'yes') {
		if (saveJson != '[]' && ValidCount>0) {
         Ext.Ajax.request({
               url: '<%=request.getContextPath()%>/RakeShiftBookingAction.do?param=saveImportIlmsDetails',
               method: 'POST',
               params: {
                            ilmsDataSaveParam: saveJson,
                            bookingId: bookingId,
                            bookingType: <%=BookingType%> 
               },
               success: function (response, options) {
               			var message = response.responseText;
               			Ext.example.msg(message);
               			Store.reload();
               },
               failure: function () {
               Ext.example.msg("Error");
                        }
               });
               clearInputData();
               fp.getForm().reset();
               importWin.hide();
           }else{
           Ext.MessageBox.show({
                        msg: "You don't have any Valid Information to Proceed",
                        buttons: Ext.MessageBox.OK
                    });
           }
         }
       }
     });
}
				
	function getJsonOfStore(importstore) {
    var datar = new Array();
    var jsonDataEncode = "";
    var recordss = importstore.getRange();
    for (var i = 0; i < recordss.length; i++) {
        datar.push(recordss[i].data);
    }
    jsonDataEncode = Ext.util.JSON.encode(datar);
    return jsonDataEncode;
}
				
	var importreader = new Ext.data.JsonReader({
    root: 'RakeShiftDetailsImportRoot',
    totalProperty: 'total',
    fields: [{
        name: 'importslnoIndex'
    }, {
        name: 'importContainerNoIndex'
    }, {
        name: 'importContainerSizeIndex'
    },{
        name: 'importLoadTypeIndex'
    }, {
        name: 'importLocationIndex'
    }, {
        name: 'importShipperNameIndex'
    }, {
        name: 'importBillingCustomerIndex'
    }, {
        name: 'importWeightIndex'
    }, {
        name: 'importSBBLNoIndex'
    },{
        name: 'importValidstatusIndex'
    },{
        name: 'importValidremarksIndex'
    }]
});

var importstore = new Ext.data.GroupingStore({
    proxy: new Ext.data.HttpProxy({
        url: '<%=request.getContextPath()%>/RakeShiftBookingAction.do?param=getImportILMSDetails',
        method: 'POST'
    }),
    remoteSort: false,
    bufferSize: 700,
    autoLoad: false,
    reader: importreader
});
//****************************grid filters************//
var filters = new Ext.ux.grid.GridFilters({
    local: true,
    filters: [{
            type: 'numeric',
            dataIndex: 'importslnoIndex'
        }, {
            dataIndex: 'importContainerNoIndex',
             type: 'string'
        }, {
            dataIndex: 'importContainerSizeIndex',
            type: 'String'
        }, {
            dataIndex: 'importLoadTypeIndex',
            type: 'string'
        },{
            dataIndex: 'importLocationIndex',
            type: 'string'
        }, {
            dataIndex: 'importShipperNameIndex',
            type: 'string'
        }, {
            dataIndex: 'importBillingCustomerIndex',
            type: 'numeric'
        },{
            dataIndex: 'importWeightIndex',
            type: 'numeric'
        },{
            dataIndex: 'importSBBLNoIndex',
            type: 'string'
        }, {
            dataIndex: 'importValidstatusIndex',
            type: 'string'
        },
		{
            dataIndex: 'importValidremarksIndex',
            type: 'string'
        }]
});
//****************column Model Config***************//
var createColModel = function (finish, start) {
    var columns = [
        new Ext.grid.RowNumberer({
            header: "<span style=font-weight:bold;><%=SLNO%></span>",
            width: 50
        }), {
            header: "<span style=font-weight:bold;><%=SLNO%></span>",
            dataIndex: 'importslnoIndex',
            hidden: true,
            width: 100,
            filter: {
                type: 'numeric'
            }
        },{
            header: "<span style=font-weight:bold;>Container No</span>",
            hidden: false,
            width: 150,
            sortable: true,
            dataIndex: 'importContainerNoIndex',
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;>Container Size</span>",
            hidden: false,
            width: 120,
            sortable: true,
            dataIndex: 'importContainerSizeIndex',
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;>Load Type</span>",
            hidden: false,
            width: 120,
            sortable: true,
            dataIndex: 'importLoadTypeIndex'
        }, {
            header: "<span style=font-weight:bold;>Location</span>",
            hidden: false,
            width: 150,
            sortable: true,
            dataIndex: 'importLocationIndex',
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;>Shipper Name</span>",
            hidden: false,
            width: 120,
            sortable: true,
            dataIndex: 'importShipperNameIndex',
             filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;>Billing Customer</span>",
            hidden: false,
            width: 150,
            sortable: true,
            dataIndex: 'importBillingCustomerIndex',
            filter: {
                type: 'numeric'
            }
        },{
            header: "<span style=font-weight:bold;>Weight</span>",
            hidden: false,
            width: 150,
            sortable: true,
            dataIndex: 'importWeightIndex',
            filter: {
                type: 'numeric'
            }
        },{
            header: "<span style=font-weight:bold;>SB BL No</span>",
            hidden: false,
            width: 100,
            sortable: true,
            dataIndex: 'importSBBLNoIndex',
            renderer: checkValid,
            filter: {
                type: 'String'
            }

        },{
            header: "<span style=font-weight:bold;>Status</span>",
            hidden: false,
            width: 100,
            sortable: true,
            dataIndex: 'importValidstatusIndex',
            renderer: checkValid,
            filter: {
                type: 'String'
            }

        },{
            header: "<span style=font-weight:bold;>Remarks</span>",
            hidden: false,
            width: 300,
            sortable: true,
            dataIndex: 'importValidremarksIndex',
            filter: {
                type: 'String'
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


function checkValid(val) {
    if (val == "Invalid") {
        return '<img src="/ApplicationImages/ApplicationButtonIcons/No.png">';
    } else if (val == "Valid") {
        return '<img src="/ApplicationImages/ApplicationButtonIcons/Yes.png">';
    }
}

			importgrid = getGrid('', '<%=NoRecordsFound%>', importstore, 825, 298, 20, filters,'', false, '', 20, false, '', false, '', false, 'Excel', jspName, exportDataType, false, 'PDF', false, '<%=Add%>', false, '<%=Modify%>', false, '<%=Delete%>',false,'',false,'',false,'',false,'',false,'',false,'',true,'<%=Save%>',true,'Clear',true,'Close');
               
               var importPanelWindow = new Ext.Panel({
			    cls: 'outerpanelwindow',
			    frame: false,
			    layout: 'column',
			    layoutConfig: {
			        columns: 1
			    },
			    items: [fp,importgrid]
			});
               
			   importWin = new Ext.Window({
				    title: 'ILMS Import Details',
				    width: 850,
				    height:500,
				    closable: false,
				    modal: true,
				    resizable: false,
				    autoScroll: false,
				    id: 'importWin',
				    items: [importPanelWindow]
				});

		function clearInputData() {
		    importgrid.store.clearData();
		    importgrid.view.refresh();
		} 	 
 
Ext.onReady(function() {
    Ext.QuickTips.init();
    Ext.form.Field.prototype.msgTarget = 'side';	
    outerPanel = new Ext.Panel({
        title: 'Container Information',
        id:'outerPanelId',
        renderTo: 'content',
        standardSubmit: true,
        frame: true,
        width: screen.width - 22,
        cls: 'outerpanel',
        layout: 'table',
        layoutConfig: {
            columns: 1
        },
        items: [Grid]
    });
    sb = Ext.getCmp('form-statusbar');
    locationStore.load();
    BillingCustomerStore.load();
    Store.load({
	    params: {
	        bookingId: bookingId
	    }
	});
		var cm = Grid.getColumnModel();
           if(bookingType == 1){
      
            cm.setHidden(7, false);
            cm.setHidden(8, false);
            cm.setHidden(9, false);
            cm.setHidden(10, false);
            cm.setHidden(11, false);
            }
});

</script>
</body>
</html>
<%}%>
