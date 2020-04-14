<%@ page language="java" import="java.util.*,java.text.SimpleDateFormat,t4u.functions.*,t4u.beans.*,t4u.common.*" pageEncoding="ISO-8859-1"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
if(loginInfo==null){
	response.sendRedirect(request.getContextPath()+ "/Jsps/Common/SessionDestroy.html");
}
String uId = request.getParameter("uId");
String cvsCustId = request.getParameter("cvsCustId");
String tripSheetNo = request.getParameter("tripSheetNo");
String typeId = request.getParameter("typeId");
CashVanManagementFunctions cvm = new CashVanManagementFunctions();
String currentDate = cvm.getCurrentDateandTime(0);
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
  	<base href="<%=basePath%>">
    <title></title>
  </head>
  <body>
    <%if (loginInfo.getStyleSheetOverride().equals("Y")){%>
	<jsp:include page="../Common/ImportJSSandMining.jsp"/>
	
	<%}else {%>
	<jsp:include page="../Common/ImportJS.jsp" />
	
	<%} %>
  <script>
	var grid;
	var outerPanel;
	var remarksPanel = new Ext.Panel({
		standardView: true,
        collapsible: false,
        id: 'remarksPanelId',
        layout: 'table',
        frame: false,
        width: 900,
        height: 50,
        layoutConfig: {
            columns: 14
        },
        items:[{height:10},{height:10},{height:10},{height:10},{height:10},{height:10},{height:10},{height:10},{height:10},{height:10},{height:10},{height:10},{height:10},{width:50},{
        	xtype:'label',
        	id: 'dateLblId',
        	cls: 'labelstyle',
        	text: 'Date : '
        	},{width:10},{
        	xtype:'label',
        	id: 'dateId',
        	cls: 'labelstyle',
        	text: '<%=currentDate%>'
        	},{width:30},{
        	xtype:'label',
        	id: 'chequeLblId',
        	cls: 'labelstyle',
        	text: 'Cheque No : '
        	},{width:10},{
            xtype: 'numberfield',
            emptyText: 'Enter Cheque No',
            blankText: 'Enter Cheque No',
            width : 120,
            id: 'chequeNoDI',
            allowBlank: false,
            allowNegative: false
            },{width:30},{
        	xtype:'label',
        	id: 'remarksLblId',
        	cls: 'labelstyle',
        	text: 'Remarks : '
        	},{width:10},{
        	xtype: 'textarea',
        	id: 'remarksId',
        	height:40,
        	width: 200
        	},{width:60},{
        	xtype: 'button',
        	id: 'btnId',
        	text: 'Close',
        	listeners:{
        	click: {
        	fn: function(){
        		Ext.getCmp('btnId').disable();
    			var json = '';
        		for (var i = 0; i < grid.getStore().data.length; i++) {
        			var element = Ext.get(grid.getView().getRow(i));
            		var record = grid.getStore().getAt(i);
           			if((record.data['writeOffDI'] + record.data['closeDI']) != (record.data['excessDI']+record.data['shortDI'])){
           				Ext.example.msg("Please write off or close complete amount");
           				Ext.getCmp('btnId').enable();
           				return;
           			}
            		json += Ext.util.JSON.encode(record.data) + ',';
        		}
        		if(Ext.getCmp('chequeNoDI').getValue() == ""){
        			Ext.example.msg("Please enter Cheque No");
        			Ext.getCmp('btnId').enable();
        			return;
        		}
        		if(document.getElementById("chequeNoDI").value.length < 6){
        			Ext.example.msg("Enter valid Cheque No");
        			Ext.getCmp('btnId').enable();
        			return;
        		}
        		if(Ext.getCmp('remarksId').getValue() == ""){
        			Ext.example.msg("Please enter remarks");
        			Ext.getCmp('btnId').enable();
        			return;
        		}
        	    Ext.Ajax.request({
        			url: '<%=request.getContextPath()%>/cashDispenseAction.do?param=saveWriteOffOrClose',
            		method: 'POST',
            		params: {
            			json: json,
                		uniqueId:'<%=uId%>',
                		tripSheetNo: '<%=tripSheetNo%>',
                		cvsCustId: '<%=cvsCustId%>',
                		remarks: Ext.getCmp('remarksId').getValue(),
                		chequeNo: Ext.getCmp('chequeNoDI').getValue()
            		},
            		success: function(response, options) {
            			Ext.getCmp('btnId').enable();
            			parent.Ext.example.msg(response.responseText);
            			json = '';
            			parent.store.reload();
    					parent.closeWindow.close();
			   		},
            		failure: function() {
            			Ext.getCmp('btnId').enable();
            			Ext.example.msg("Error");
            			json = '';
                		parent.store.reload();
    					parent.closeWindow.close();
            		}
        		});
        	}}}
    	}]
	});
	
	var totalPanel = new Ext.Panel({
		standardView: true,
        collapsible: false,
        id: 'totalPanelId',
        layout: 'table',
        frame: false,
        width: 900,
        height: 25,
        layoutConfig: {
            columns: 6
        },
        items:[{height:10},{height:10},{height:10},{height:10},{height:10},{height:10},{width:600},{
        	xtype:'label',
        	id: 'totalLblId',
        	cls: 'labelstyle',
        	width: 50,       	
        	text: 'Total :'
        	},{width:30},{
        	xtype:'label',
        	id: 'totalValueWritOffId',
        	cls: 'labelstyle',
        	width: 80
        	},{width:70},{
        	xtype:'label',
        	width: 80,
        	cls: 'labelstyle',
        	id: 'totalValueClsId'
        	}           
        	]
	});
	
	var reader = new Ext.data.JsonReader({
        root: 'writeOffCloseRoot',
      	fields: [{
      			name: 'UIDDI',
      			type: 'int'
      		},{
                name: 'DenominationDataIndex',
                type: 'int'
            }, {
                name: 'shortDI',
                type: 'int'
            }, {
                name: 'shortValueDI',
                type: 'float'
            }, {
                name: 'excessDI',
                type: 'int'
            },{
                name: 'excessValueDI',
                type: 'float'
            }, {
                name: 'writeOffDI',
                type: 'int'
            }, {
                name: 'closeDI',
                type: 'int'
            }]
    });

    var dataStoreForGrid = new Ext.data.GroupingStore({
        url: '<%=request.getContextPath()%>/cashDispenseAction.do?param=getShortExcessDetails',
        bufferSize: 367,
        reader: reader,
        root: 'rows',
        autoLoad: false,
        remoteSort: true
    });
	function getcmnmodel() {
    	toolGridColumnModel = new Ext.grid.ColumnModel([
        	new Ext.grid.RowNumberer({
            header: '<B>SLNO</B>',
            width: 45
            }),{
            header: '<B>Unique Id</B>',
            sortable: true,
            width: 120,
            dataIndex: 'UIDDI',
            editable: false,
            hidden: true
			},{
            header: '<B>Denominations</B>',
            sortable: true,
            width: 120,
            dataIndex: 'DenominationDataIndex',
            editable: false
			},{
            header: '<B>Short</B>',
            width: 90,
            dataIndex: 'shortDI',
            editable: false
            },{
            header: '<B>Value</B>',
            width: 150,
            dataIndex: 'shortValueDI',
            editable: false
        	},{
            header: '<B>Excess</B>',
            width: 90,
            dataIndex: 'excessDI',
            editable: false
        	},{
            header: '<B>Value</B>',
            width: 150,
            dataIndex: 'excessValueDI',
            editable: false
        	},{
            header: '<B>Write Off</B>',
            width: 120,
            dataIndex: 'writeOffDI',
            editable: true,
            editor: new Ext.grid.GridEditor(new Ext.form.NumberField({
            	allowNegative: false,
            	allowBlank: false, 
                allowDecimals:false, 
                cls: 'bskExtStyle'
            }))
           	},{
            header: '<B>Close</B>',
            width: 120,
            dataIndex: 'closeDI',
            editable: true,
            editor: new Ext.grid.GridEditor(new Ext.form.NumberField({
            	allowNegative: false,
            	allowBlank: false, 
                allowDecimals:false, 
                cls: 'bskExtStyle'
            }))
           	}
        ]);
    	return toolGridColumnModel;
	}

	var grid = new Ext.grid.EditorGridPanel({
    	id: 'toolGridid',
        ds: dataStoreForGrid,
        cm: getcmnmodel(),
        stripeRows: true,
        border: true,
        width: 910,
        height: 210,
        autoScroll: true,
        clicksToEdit: 1,
        selModel: new Ext.grid.RowSelectionModel(),
        bbar: new Ext.Toolbar({})
	});
	
    var totWriteoff=0;
    var totcloseDI=0;
    
    grid.on({
    beforeedit:function(e){
    },
	afteredit: function(e) {
		var value= 0;
        var field = e.field;
        
       if(field=='writeOffDI'){      
	        getWriteOffTotals();        
        }
        
       if(field=='closeDI'){      
	        getClsfTotals();        
        }
        
    }});
    function getWriteOffTotals()
   {

       tot = 0.0;
       for (var i = 0; i < grid.store.data.items.length; i++)
       {
           var rec = grid.store.getAt(i);
           
           tot = tot + (parseFloat((parseFloat(rec.data['DenominationDataIndex']) * parseFloat(rec.data['writeOffDI']))));
 
       }
		if(tot== "NaN"){
		tot = 0.0;
	}

       Ext.getCmp('totalValueWritOffId').setText(tot);
   }
   
   function getClsfTotals()
   {

       tot = 0.0;
       for (var i = 0; i < grid.store.data.items.length; i++)
       {
           var rec = grid.store.getAt(i);
           
           tot = tot + (parseFloat((parseFloat(rec.data['DenominationDataIndex']) * parseFloat(rec.data['closeDI']))));
 
       }
		if(tot== "NaN"){
		tot = 0.0;
	}

       Ext.getCmp('totalValueClsId').setText(tot);
   }
    
    var UGrid = function() {
    return {
    init: function() {
    	grid.on({
        	"cellclick": {
            	fn: onCellClick
            }
       	});
    }
    }
    }();
                                        
	function  onCellClick (grid, rowIndex, columnIndex, e){
		var r = grid.store.getAt(rowIndex);
		<%if(typeId.equals("Closed")){%>
			grid.getColumnModel().config[grid.getColumnModel().findColumnIndex('writeOffDI')].editable = false;
			grid.getColumnModel().config[grid.getColumnModel().findColumnIndex('closeDI')].editable = false;
		<%}else{%> 
		if(r.data['excessDI'] > 0){
			grid.getColumnModel().config[grid.getColumnModel().findColumnIndex('writeOffDI')].editable = false;
		}else{
			grid.getColumnModel().config[grid.getColumnModel().findColumnIndex('writeOffDI')].editable = true;
		}
    	<%}%>
	}
  	Ext.onReady(UGrid.init, UGrid, true);
	Ext.onReady(function() {
    	Ext.QuickTips.init();
        Ext.form.Field.prototype.msgTarget = 'side';
        outerPanel = new Ext.Panel({
            renderTo: 'content',
            id: 'outerPanel',
            standardView: true,
            autoScroll: true,
            frame: true,
            border: false,
            width: 922,
            height: 310,
            layout: 'table',
            cls: 'outerpanel',
            layoutConfig: {
                columns: 1
            },
            items: [grid,totalPanel,remarksPanel]
        });
        dataStoreForGrid.load({params:{uId:'<%=uId%>',typeId:'<%=typeId%>'}});
        <%if(typeId.equals("Closed")){%>
        	 Ext.getCmp('remarksPanelId').hide();
        	 Ext.getCmp('totalPanelId').hide();
        <%}else{%>
        	 Ext.getCmp('remarksPanelId').show();
        	 Ext.getCmp('totalPanelId').show();
        <%}%>
        document.getElementById("chequeNoDI").maxLength = 6;
	});
  </script>	
  </body>
</html>
