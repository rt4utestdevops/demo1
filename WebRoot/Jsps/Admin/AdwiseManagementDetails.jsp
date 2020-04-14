<%@ page  language="java" import="java.util.*,t4u.functions.*,t4u.beans.*,t4u.common.*" pageEncoding="utf-8"%>
<%
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
LoginInfoBean loginInfo = (LoginInfoBean) session
.getAttribute("loginInfoDetails");
if (loginInfo == null) {
LoginInfoBean loginInfo1 = new LoginInfoBean();
loginInfo1.setSystemId(0);
loginInfo1.setLanguage("en");
session.setAttribute("loginInfoDetails", loginInfo1);
} else {
session.setAttribute("loginInfoDetails", loginInfo);
String language = loginInfo.getLanguage();
}
%>
<!DOCTYPE HTML>
<html>
  <head>  
    <title>AdwiseManagement Details</title>
  </head>
  <style>
  .x-panel-tl
	{
		border-bottom: 0px solid !important;
	}
	#unitId{
	font-weight: 700;
    font-size: medium;
} 
  </style>
  <body>
   <jsp:include page="../Common/ImportJSSandMining.jsp"/>
    
    <script>
    var outerPanel;
 	var ctsb;
 	var jspName="AdwiseManagementDetails";
 	var exportDataType=" ";
 	var grid;
 	var titel;
 	 	
 	//override function for showing first row in grid
 	Ext.override(Ext.grid.GridView, {
    	afterRender: function(){
        this.mainBody.dom.innerHTML = this.renderRows();
        this.processRows(0, true);
        if(this.deferEmptyText !== true){
            this.applyEmptyText();
        }
        this.fireEvent("viewready", this);//new event
    	}   
	});
	 //***** UID combo *******		
	  var uidStore= new Ext.data.JsonStore({
           url: '<%=request.getContextPath()%>/AdwiseManagement.do?param=getUID',
           id: 'uidStoreId',
				    root: 'UIDRoot',
				    autoload: true,
				    remoteSort: true,
				    fields: ['UID','IMEI']
	});
	  var customerUidCombo = new Ext.form.ComboBox({
        store: uidStore,
        id: 'customerUidcomboId',
        mode: 'local',
        forceSelection: true,
        emptyText: 'Select UID',
        selectOnFocus: true,
        allowBlank: false,
        anyMatch: true,
        typeAhead: false,
        triggerAction: 'all',
        lazyRender: true,
        valueField: 'IMEI',
        displayField: 'UID',
        cls: 'selectstylePerfect',
        loadingText: 'Searching...',
	    enableKeyEvents: true,
	    minChars: 2,
	    listeners: {
	        select: {
	            fn: function() {
	                UID = Ext.getCmp('customerUidcomboId').getRawValue();
 					IMEI = Ext.getCmp('customerUidcomboId').getValue();
 					GridStore.load({params:{imei:IMEI}});
                    Ext.getCmp('unitId').setText(Ext.getCmp('customerUidcomboId').getValue());
	                summaryGrid.store.clearData();
  		            summaryGrid.view.refresh();
	            }
	        }
	    }
	});
	
	//********* innerPanel ********		
	var innerPanel = new Ext.Panel({
        standardSubmit: true,
        collapsible: false,
        id: 'innerPanelId',
        layout: 'table',
        frame: true,
        layoutConfig: {
            columns: 8
        },
        items: [{width:30},
        		{
                xtype: 'label',
                text: 'UID' + ' :',
                cls: 'labelstyle',
                id: 'uidlab'
               
            	},
            	{width:10},
            	customerUidCombo,
            	{width:100},
            	{
                xtype: 'label',
                text: 'Unit No '+' :',
                cls: 'labelstyle',
                id: 'unitTxt'
            },
            {
            	xtype: 'label',
                text: '',
                cls: 'labelstyle',
                id: 'unitId'
            }
        	 ]
   		 });
	
		//============================ Grid table creation ================================
		//********** reader *************
     	var reader = new Ext.data.JsonReader({
        idProperty: 'darreaderid',
        root: 'GridRoot',
        totalProperty: 'total',
        fields: [{
        	name: 'slnoIndex'
        },{ 
        	name: 'unitNoIndex'
        },{
            name: 'attributeIndex'
        },{
            name: 'descriptionIndex'
        },{
            name: 'timeIndex',
            type: 'date',
  		    dateFormat: getDateTimeFormat()
        }]
    });
		//********** store *****************
		var GridStore = new Ext.data.GroupingStore({
        autoLoad: false,
        proxy: new Ext.data.HttpProxy({
           	url: '<%=request.getContextPath()%>/AdwiseManagement.do?param=getDetailsofCommands',
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
            type: 'string',
            dataIndex: 'unitNoIndex'
        },{
            type: 'string',
            dataIndex: 'attributeIndex'
        },{
            type: 'string',
            dataIndex: 'descriptionIndex'
        },{
            type: 'date',
            dataIndex: 'timeIndex'
        }]
      });
		
		//************************************Column Model Config******************************************
    	var createColModel = function (finish, start) {

        var columns = [
            new Ext.grid.RowNumberer({
                header: "<span style=font-weight:bold;>SLNO</span>",
                width: 50
            }),{
                dataIndex: 'slnoIndex',
                hidden: true,
                header: "<span style=font-weight:bold;>SLNO</span>",
                filter: {
                    type: 'numeric'
                }
            }, {
                header: "<span style=font-weight:bold;>Unit_No</span>",
                dataIndex: 'unitNoIndex',
                hidden: true,
                width: 100,
                filter: {
                    type: 'string'
                }
            },  {
                header: "<span style=font-weight:bold;>Attributes</span>",
                dataIndex: 'attributeIndex',
                width: 75,
                filter: {
                    type: 'string'
                }
            },  {
                header: "<span style=font-weight:bold;>Description</span>",
                dataIndex: 'descriptionIndex',
                width: 150,
                filter: {
                    type: 'string'
                }
            },  {
        		header: "<span style=font-weight:bold;>Time</span>",
           	 	dataIndex: 'timeIndex',
           	 	width:100,
            	renderer: Ext.util.Format.dateRenderer(getDateTimeFormat()),
            	filter: {
            	type: 'date'
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
	//***************** getGrid ****************************	
	summaryGrid = getGrid('', 'No Records Found', GridStore, 850, 430, 8, filters, 'Clear Filter Data', false, '',8, false, '', false, '', false, 'Excel', jspName, exportDataType, false, 'PDF',false,'Add');
	
	//*****main starts from here*************************
 	Ext.onReady(function(){
	ctsb=tsb;
	Ext.QuickTips.init();
	Ext.form.Field.prototype.msgTarget = 'side';			         	   			
 	outerPanel = new Ext.Panel({
			title:'Adwise Management Details',
			renderTo : 'content',
			standardSubmit: true,
			frame:false,
			cls:'outerpanel',
			width : 850,
			border:false,
			items: [innerPanel,summaryGrid]  
			}); 
			uidStore.load();
			
	}); 
    </script>
  </body>
</html>
    
    
    