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
ArrayList<String> tobeConverted = new ArrayList<String>();
tobeConverted.add("Route_Master");
tobeConverted.add("Add");
tobeConverted.add("Modify");
tobeConverted.add("Customer_Name");
tobeConverted.add("Select_Customer_Name");
tobeConverted.add("Route_Master_Details");
tobeConverted.add("No_Records_Found");
tobeConverted.add("Clear_Filter_Data");
tobeConverted.add("SLNO");
tobeConverted.add("Id");
tobeConverted.add("Route_Id");
tobeConverted.add("Route_Name");
tobeConverted.add("Route_Type");
tobeConverted.add("Excel");
tobeConverted.add("Delete");
tobeConverted.add("Route_Master_Information");
tobeConverted.add("No_Rows_Selected");
tobeConverted.add("Select_Single_Row");
tobeConverted.add("Modify_Details");
tobeConverted.add("Route_Master_Details");
tobeConverted.add("Enter_Route_ID");
tobeConverted.add("Enter_Route_Name");
tobeConverted.add("Enter_Route_Type");
tobeConverted.add("Save");
tobeConverted.add("Cancel");
//tobeConverted.add("This_Route_is_Already_Exists_Please_Select_Different_One");

ArrayList<String> convertedWords = new ArrayList<String>();
convertedWords = cf.getLanguageSpecificWordForKey(tobeConverted,language);

String RouteMaster=convertedWords.get(0);
String Add=convertedWords.get(1);
String Modify=convertedWords.get(2);
String CustomerName=convertedWords.get(3);
String SelectCustomerName=convertedWords.get(4);
String RouteMasterDetails=convertedWords.get(5);
String NoRecordsFound=convertedWords.get(6);
String ClearFilterData=convertedWords.get(7);
String SLNO=convertedWords.get(8);
String ID=convertedWords.get(9);
String RouteID=convertedWords.get(10);
String RouteName=convertedWords.get(11);
String RouteType=convertedWords.get(12);
String Excel=convertedWords.get(13);
String Delete=convertedWords.get(14);
String AddRouteMaster=convertedWords.get(15);
String NoRowsSelected=convertedWords.get(16);
String SelectSingleRow=convertedWords.get(17);
String ModifyDetails=convertedWords.get(18);
String AssociateRoute=convertedWords.get(19);
String SelectRouteID=convertedWords.get(20);
String SelectRouteName=convertedWords.get(21);
String SelectRouteType=convertedWords.get(22);
String Save=convertedWords.get(23);
String Cancel=convertedWords.get(24);
//String RouteisAlreadyExistsPleaseSelectDifferentOne=convertedWords.get(25);

%>
<jsp:include page="../Common/header.jsp" />
 		<title>Stationary Issuance</title>		
  
	 <style>
  .x-panel-tl
	{
		border-bottom: 0px solid !important;
	}
  </style>

   <%if (loginInfo.getStyleSheetOverride().equals("Y")){%>
	<jsp:include page="../Common/ImportJSSandMining.jsp"/>
	<%}else{%>
	<jsp:include page="../Common/ImportJS.jsp" /><%}%>
   <jsp:include page="../Common/ExportJS.jsp" />
   <style>
	.ext-strict .x-form-text {
		height: 21px !important;
	}	
	label {
		display : inline !important;
	}
	.x-layer ul {
	 	min-height: 27px !important;
	}
   </style>
   <script>
var dtcur = datecur;
var outerPanel;
var ctsb;
var jspName = "Stationary Issuance";
var exportDataType = "int,string,string,string,string,string,string,string,string,string";
var selected;
var grid;
var buttonValue;
var titelForInnerPanel;
var myWin;
var selectedVehicles = "-";
var selectedRouteId = null;
var selectedName = null;
var selectedType = null;
    var sm1 = new Ext.grid.CheckboxSelectionModel({});
var isactive =0;
 var spareNames = "";    
var clientcombostore = new Ext.data.JsonStore({
    url: '<%=request.getContextPath()%>/CommonAction.do?param=getCustomer',
    id: 'CustomerStoreId',
    root: 'CustomerRoot',
    autoLoad: true,
    remoteSort: true,
    fields: ['CustId', 'CustName'],
    listeners: {
        load: function(custstore, records, success, options) {
            if ( <%= customerId %> > 0) {
                Ext.getCmp('custcomboId').setValue('<%=customerId%>');
                custId = Ext.getCmp('custcomboId').getValue();
                CustName= Ext.getCmp('custcomboId').getRawValue();
               
            }
        }
    }
});

var Client = new Ext.form.ComboBox({
    store: clientcombostore,
    id: 'custcomboId',
    mode: 'local',
    forceSelection: true,
    emptyText: '<%=SelectCustomerName%>',
    blankText: '<%=SelectCustomerName%>',
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
            fn: function() {
                custId = Ext.getCmp('custcomboId').getValue();
                CustName= Ext.getCmp('custcomboId').getRawValue();
           
            }
        }
    }
});

var branchcombostore = new Ext.data.JsonStore({
    url: '<%=request.getContextPath()%>/StationaryAction.do?param=getBranches',
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

var toBranchcombo = new Ext.form.ComboBox({
    store: branchcombostore,
    id: 'toBranchcomboId',
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

  var departmentstore = new Ext.data.SimpleStore({
   id: 'departmentstoreId',
   autoLoad: true,
   fields: ['Name', 'Value'],
   data: [
    ['ACCOUNT', 'ACCOUNT'],
    ['ARMORY', 'ARMORY']
   ]
  });

  var departmentcombo = new Ext.form.ComboBox({
   store: departmentstore,
   id: 'departmentcomboId',
   mode: 'local',
   forceSelection: true,
   selectOnFocus: true,
   allowBlank: false,
   anyMatch: true,
   emptyText: 'Select Department',
   blankText: 'Select Department',
   typeAhead: false,
   triggerAction: 'all',
   lazyRender: true,
   valueField: 'Value',
   value: '',
   displayField: 'Name',
   cls: 'selectstylePerfect',
   listeners: {
    'change': function(field, selectedValue) {


    }
   }


  });


var assetcombostore = new Ext.data.JsonStore({
    url: '<%=request.getContextPath()%>/StationaryAction.do?param=armoryItems',
    id: 'AssetStoreId',
    root: 'armoryItems',
    autoLoad: true,
    remoteSort: true,
    fields: ['itemId', 'itemName']

});
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
    cls: 'selectstylePerfect'
    });

var customerComboPanel = new Ext.Panel({
    standardSubmit: true,
    collapsible: false,
    id: 'customerComboPanelId',
    layout: 'table',
    frame: false,
    width: screen.width - 12,
    height: 40,
    layoutConfig: {
        columns: 19
    },
    items: [{
            xtype: 'label',
            text: '<%=CustomerName%>' + ' :',
            cls: 'labelstyle',
            style:'vertical-align: -webkit-baseline-middle'
        },
        Client,{
            xtype: 'label',
            text: '  ',
            cls: 'labelstyle'
        },{
            xtype: 'label',
            text: '  ',
            cls: 'labelstyle'
        }, {
            xtype: 'label',
            cls: 'labelstyle',
            id: 'branchlab',
            text: 'Branch Name' + ' :',
            style:'vertical-align: -webkit-baseline-middle'
        },
        branchcombo,{
            xtype: 'label',
            text: '  ',
            cls: 'labelstyle'
        },{
            xtype: 'label',
            text: '  ',
            cls: 'labelstyle'
        },{
            xtype: 'label',
            text: 'Issuance From : ',
            cls: 'labelstyle',
            style:'vertical-align: -webkit-baseline-middle'
        },{
            xtype: 'datefield',
            cls: 'selectstylePerfect',
             format: getDateFormat(),
            value: dtcur,
            maxValue: dtcur,
            blankText: 'Select Date',
            emptyText: 'Select Date',
            id: 'startDtId'
        },{
            xtype: 'label',
            text: '  ',
            cls: 'labelstyle'
        },{
            xtype: 'label',
            text: '  ',
            cls: 'labelstyle'
        },{
            xtype: 'label',
            text: '  ',
            cls: 'labelstyle'
        },{
            xtype: 'label',
            text: 'Issuance To : ',
            cls: 'labelstyle',
            style:'vertical-align: -webkit-baseline-middle'
        },{
            xtype: 'datefield',
            cls: 'selectstylePerfect',
             format: getDateFormat(),
            value: dtcur,
            maxValue: dtcur,
            blankText: 'Select Date',
            emptyText: 'Select Date',
            id: 'endDtId'
        },{
            xtype: 'label',
            text: '  ',
            cls: 'labelstyle'
        },{
            xtype: 'label',
            text: '  ',
            cls: 'labelstyle'
        },{
            xtype: 'label',
            text: '  ',
            cls: 'labelstyle'
        },  {
        xtype: 'button',
        text: 'View',
                listeners: {
    click: function() {
  getStationaryIssuance();
    return;
    }
       
    }}
       
        
    
        
    ]
});


var statuscombostore = new Ext.data.SimpleStore({
    id: 'statuscombostoreId',
    autoLoad: true,
    fields: ['Name', 'Value'],
    data: [
        ['Active', 'Active'],
        ['Inactive', 'Inactive']
    ]
});

var statuscombo = new Ext.form.ComboBox({
    store: statuscombostore,
    id: 'statuscomboId',
    mode: 'local',
    forceSelection: true,
    selectOnFocus: true,
    allowBlank: false,
    anyMatch: true,
    emptyText: 'Select Status',
    blankText: 'Select Status',
    typeAhead: false,
    triggerAction: 'all',
    lazyRender: true,
    valueField: 'Value',
    value: 'Active',
    displayField: 'Name',
    cls: 'selectstylePerfect'
});




var reader = new Ext.data.JsonReader({
    idProperty: 'ownMasterid',
    root: 'issuance',
    totalProperty: 'total',
    fields: [{
        name: 'slnoIndex'
    }, {
       name: 'stationaryName'
    }, {
        name: 'quantity'
    }, {
        name: 'date'
    }, {
        name: 'department'
    }, {
       name: 'branchName'
       
    }]
});

var store = new Ext.data.GroupingStore({
    autoLoad: false,
    proxy: new Ext.data.HttpProxy({
        url: '<%=request.getContextPath()%>/StationaryAction.do?param=getStationaryIssuance',
        method: 'POST'
    
    }),
    storeId: 'issuance',
    reader: reader
});

var filters = new Ext.ux.grid.GridFilters({
    local: true,
    filters: [  {
    type: 'int',
            dataIndex: 'slnoIndex'
        }, {
    type:'string',
        dataIndex: 'stationaryName'
    }, {
     type:'int',
        dataIndex: 'quantity'
    }, {
      type:'string',
        dataIndex: 'date'
    }, {
     
      type:'string',
        dataIndex: 'department',
    },  {
      
      type:'string',
        dataIndex: 'branchName'
    }]
});
var createColModel = function(finish, start) {
     var columns = [
        new Ext.grid.RowNumberer({
            header: "<span style=font-weight:bold;><%=SLNO%></span>",
            width: 60
        }), 
        {
        dataIndex: 'slnoIndex',
            hidden: true,
            header: "<span style=font-weight:bold;><%=SLNO%></span>",
            width: 200,
            
            filter: {
                type: 'int'
            }
            }, 
            {
            header: "<span style=font-weight:bold;>Stationary Name</span>",
            dataIndex: 'stationaryName',
            width: 50,
            filter: {
                type: 'string'
            }
        },  {
            header: "<span style=font-weight:bold;>Quantity</span>",
            dataIndex: 'quantity',
            width: 50,
            filter: {
                type: 'INT'
            }
        } ,
         {
            header: "<span style=font-weight:bold;>Issued Date</span>",
            dataIndex: 'date',
            width: 50,
            filter: {
                type: 'string'
            }
        },
         {
            
            header: "<span style=font-weight:bold;>Department</span>",
            dataIndex: 'department',
            width: 50,
            filter: {
                type: 'string'
            }
        }
        ,
         {
            header: "<span style=font-weight:bold;>To Branch</span>",
            dataIndex: 'branchName',
            width: 50,
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

function updateStatus(){

var fromBranch=Ext.getCmp('branchcomboId').getValue();
    if(fromBranch==null || fromBranch<=0){
     Ext.example.msg("Please Select Branch");
    return;
    }
    myWin.show();
}

var innerPanelForCustomerMasterDetails = new Ext.form.FormPanel({
    standardSubmit: true,
    collapsible: false,
    autoScroll: true,
    height:200,
    width: 400,
    frame: false,
    id: 'innerPanelForCustomerMasterDetailsId',
    layout: 'table',
    layoutConfig: {
        columns: 4
    },
    items: [{
        xtype: 'fieldset',
        title: 'Add Issue Stationary',
        cls: 'fieldsetpanel',
        collapsible: false,
        colspan: 4,
        id: 'NewRecordId',
        width: 360,
        layout: 'table',
        layoutConfig: {
            columns: 4
        },
        items: [
        {
            xtype: 'label',
            text: '',
            //cls: 'mandatoryfield',
            id: 'id1'
        },{
            xtype: 'label',
            text: 'Issue Date' + ' :',
            cls: 'labelstyle',
            id: 'issueDateLabelId'
        },{
            xtype: 'datefield',
            cls: 'selectstylePerfect',
           format: getDateFormat(),
            value: dtcur,
            maxValue: dtcur,
            blankText: 'Select Date',
            emptyText: 'Select Date',
            id: 'issueDtId'
        }, {},{
            xtype: 'label',
            text: '',
            //cls: 'mandatoryfield',
            id: 'id2'
        },{
            xtype: 'label',
            text: 'Stationary' + ' :',
            cls: 'labelstyle',
            id: 'stationaryLabelId'
        }, assetcombo, {},
        {
            xtype: 'label',
            text: '',
            //cls: 'mandatoryfield',
            id: 'id33'
        },{
            xtype: 'label',
            text: 'Quantity' + ' :',
            cls: 'labelstyle',
            id: 'quantityLabelId'
        },{
         xtype: 'textfield',
          cls: 'selectstylePerfect',
          id:'quantityValueId'
        },{},
        {
            xtype: 'label',
            text: '',
            //cls: 'mandatoryfield',
            id: 'id44'
        },{
            xtype: 'label',
            text: 'Department' + ' :',
            cls: 'labelstyle',
            id: 'departmentLabelId'
        },departmentcombo,{},
        {
            xtype: 'label',
            text: '',
            //cls: 'mandatoryfield',
            id: 'id55'
        },{
            xtype: 'label',
            text: 'Branch' + ' :',
            cls: 'labelstyle',
            id: 'branchLabelId'
        },toBranchcombo,{}
        
        ]
    }]
});

var innerWinButtonPanel = new Ext.Panel({
    id: 'innerWinButtonPanelId',
    standardSubmit: true,
    collapsible: false,
    autoHeight: true,
    height: 100,
    width: 400,
    frame: false,
    layout: 'table',
    layoutConfig: {
        columns: 4
    },
    buttons: [{
        xtype: 'button',
        text: '<%=Save%>',
        id: 'saveButtonId',
        cls: 'buttonstyle',
        iconCls:'savebutton',
        width: 70,
        listeners: {
            click: {
                fn: function() {
               Ext.getCmp('saveButtonId').disable();
                   var issueDate=Ext.getCmp('issueDtId').getValue();
    if(issueDate==null || issueDate==""){
    Ext.example.msg("Please Select Date ");
    Ext.getCmp('saveButtonId').enable();
    return;
   }
   var stationaryId=Ext.getCmp('assetcomboId').getValue();
   if(stationaryId==null || stationaryId==0){
    Ext.example.msg("Please Select Stationary ");
    Ext.getCmp('saveButtonId').enable();
    return;
   }

   var quantity=Ext.getCmp('quantityValueId').getValue();
   
       if(quantity==null || quantity<=0){
    Ext.example.msg("Please give valid quantity no");
    Ext.getCmp('saveButtonId').enable();
    return;
   }
      var dept=Ext.getCmp('departmentcomboId').getValue();
     if(dept==null || dept==""){
    Ext.example.msg("Please select Department");
    Ext.getCmp('saveButtonId').enable();
    return;
   }
   
   var branch=Ext.getCmp('toBranchcomboId').getValue();
       if(branch==null || branch<=0){
    Ext.example.msg("Please select branch");
    Ext.getCmp('saveButtonId').enable();
    return;
   }
var fromBranch=Ext.getCmp('branchcomboId').getValue();
   
          Ext.Ajax.request({
            url: '<%=request.getContextPath()%>/StationaryAction.do?param=saveIssuance',
            method: 'POST',
            params: {
             CustId: Ext.getCmp('custcomboId').getValue(),
                issueDate: issueDate,
                toBranch: branch,
                fromBranch: fromBranch,
                stationaryId: stationaryId,
               quantity:quantity,
               dept:dept
            },
            success: function(response, options) {
             Ext.getCmp('saveButtonId').enable();
                var message = response.responseText;
                //custId = Ext.getCmp('custcomboId').getValue();
                Ext.example.msg(message);
                 myWin.hide();
                  store.load({
                    params: {
                         branch:Ext.getCmp('branchcomboId').getValue(),
        startDate:Ext.getCmp('startDtId').getValue(),
        endDate:Ext.getCmp('endDtId').getValue()
                    }
                });
                   Ext.getCmp('departmentcomboId').reset();
                   Ext.getCmp('toBranchcomboId').reset();
                   Ext.getCmp('quantityValueId').reset();
                   Ext.getCmp('assetcomboId').reset();
                   Ext.getCmp('issueDtId').reset();
               
            },
            failure: function() {
             Ext.getCmp('saveButtonId').enable();
                Ext.example.msg("Error");
                store.reload();
                             
            }
        });
        }  
                  
                
            }
        }
    }, {
        xtype: 'button',
        text: '<%=Cancel%>',
        id: 'canButtId',
        cls: 'buttonstyle',
        iconCls: 'cancelbutton',
        width: 70,
        listeners: {
            click: {
                fn: function() {
                    myWin.hide();
                      Ext.getCmp('departmentcomboId').reset();
                   Ext.getCmp('toBranchcomboId').reset();
                   Ext.getCmp('quantityValueId').reset();
                   Ext.getCmp('assetcomboId').reset();
                   Ext.getCmp('issueDtId').reset();
                
                    
                }
            }
        }
    }]
});
var RadioPanelWindow = new Ext.Panel({
    width: 410,
    height: 300,
    standardSubmit: true,
    frame: true,
    items: [innerPanelForCustomerMasterDetails, innerWinButtonPanel]
});

myWin = new Ext.Window({
    title: titelForInnerPanel,
    closable: false,
    resizable: false,
    title:'Issue Stationary',
    modal: true,
    autoScroll: false,
    height: 350,
    width: 450,
    id: 'myWin',
    items: [RadioPanelWindow]
});



grid = getGridArmory('Stationary Issuance Details', '<%=NoRecordsFound%>', store, screen.width-40, 450, 12, filters,'', false, '', 12, false, '', false, '', false, '<%=Excel%>',jspName, exportDataType,false,'Pdf',true,'Issue Stationary');

function getGridArmory(gridtitle,emptytext,store,width,height,gridnoofcols,filters,filterstr,reconfigure,reconfigurestr,reconfigurenoofcols,group,groupstr,chart,chartstr,excel,excelstr,jspName,exportDataType,pdf,pdfstr,activeInActive,activeStr){
	 var grid = new Ext.grid.GridPanel({
	    	title:gridtitle,
	        border: false,
	        height: getGridHeight(),
	        autoScroll:true,
	        store: store,
	        id:'grid',
	        colModel: createColModel(gridnoofcols),
	        loadMask: true,
	        view: new Ext.grid.GroupingView({
	        	autoFill:true,
	            groupTextTpl: getGroupConfig(),
	            emptyText: emptytext,deferEmptyText: false
	        }),
	        listeners: {
                render : function(grid){
                  grid.store.on('load', function(store, records, options){
                    grid.getSelectionModel().selectFirstRow();       
                  });                      
                }
               },
	       
	        selModel: new Ext.grid.RowSelectionModel(),
            sm: sm1,
            plugins:filters,      
	        bbar: new Ext.Toolbar({
	        })
	    });
	if(width>0){
		grid.setSize(width,height);
	}
	 grid.getBottomToolbar().add([
	        '->',
	        {
	            text: filterstr,
	            iconCls : 'clearfilterbutton',
	            handler: function () {
	        	grid.filters.clearFilters();
	            } 
	        }]);
	if(reconfigure){
		grid.getBottomToolbar().add([
		 '-',                            
			{
            text: reconfigurestr,
            handler: function () {
			grid.reconfigure(store, createColModel(reconfigurenoofcols));
            } 
        }]);
		}
		if(group){
			grid.getBottomToolbar().add([
			'-',                             
			{
			    text:groupstr,
			    handler : function(){
				store.clearGrouping();
			    }    
			  }]);
		}	
		
		if(chart)
		{
			grid.getBottomToolbar().add([
			'-',                             
			{
			    text:chartstr,
			    handler : function(){
				columnchart();
			    }    
			  }]);
		}
		if(excel)
		{
			grid.getBottomToolbar().add([
			'-',                             
			{
			    text:'',
			    iconCls : 'excelbutton',
			    handler : function(){
				getordreport('xls','All',jspName,grid,exportDataType);
			    }    
			  }]);
		}
		if(pdf)
		{
			grid.getBottomToolbar().add([
			'-',                             
			{
			    text:'',
			    iconCls : 'pdfbutton',
			    handler : function(){
			    getordreport('pdf','All',jspName,grid,exportDataType);

			    }    
			  }]);
		}
		if(activeInActive)
		{
			grid.getBottomToolbar().add([
			'-',                            
			{
			    text:activeStr,
			   // iconCls : 'closebutton',
			    handler : function(){
			   updateStatus();
			    }    
			  }]);
		}

	return grid;
}



Ext.onReady(function() {
    Ext.QuickTips.init();
    Ext.form.Field.prototype.msgTarget = 'side';
    outerPanel = new Ext.Panel({
        title: 'Stationary',
        renderTo: 'content',
        standardSubmit: true,
        frame: true,
        width: screen.width - 20,
        height: 550,
        cls: 'outerpanel',
        layout: 'table',
        layoutConfig: {
            columns: 1
        },
        items: [customerComboPanel, grid]
    });
    sb = Ext.getCmp('form-statusbar');
});


$( ".clearfilterbutton" ).hide();
//get Issuance by branch and date range
function getStationaryIssuance(){
var branchId=Ext.getCmp('branchcomboId').getValue();
var issueFrom=Ext.getCmp('startDtId').getValue();
var issueTo=Ext.getCmp('endDtId').getValue();
if(branchId==null || branchId==0){
 Ext.example.msg("Branch Name Required ");
 return;
}
if(issueFrom==null || issueFrom==''){
 Ext.example.msg("Issuance From Required ");
 return;
}
if(issueTo==null || issueTo==''){
 Ext.example.msg("Issuance To Required ");
 return;
}
      store.load({
                    params: {
                         branch:Ext.getCmp('branchcomboId').getValue(),
        startDate:Ext.getCmp('startDtId').getValue(),
        endDate:Ext.getCmp('endDtId').getValue()
                    }
                });
}
</script>

<jsp:include page="../Common/footer.jsp" />
 <!-- </body>   -->
 <!-- </html> -->