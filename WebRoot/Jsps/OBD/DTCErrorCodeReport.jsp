<%@ page language="java" import="java.util.*,java.text.SimpleDateFormat,t4u.functions.*,t4u.beans.*,t4u.common.*" pageEncoding="utf-8"%>
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
%>

 <jsp:include page="../Common/header.jsp" />
    
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
.labelstyle {
	spacing: 10px;
	height: 20px;
	width: 80px !important;
	min-width: 80px !important;
	margin-bottom: 5px !important;
	margin-left: 5px !important;
	font-size: 12px;
	font-family: sans-serif;
	font-weight:bold;
}


</style>

<!-- <body>  -->
	<%if (loginInfo.getStyleSheetOverride().equals("Y")){%>
		<jsp:include page="../Common/ImportJSSandMining.jsp"/>
	<%}else {%>
		<jsp:include page="../Common/ImportJS.jsp" />
	<%} %>
	<jsp:include page="../Common/ExportJS.jsp" />
	<style>
		.x-form-text {
			height: 21px !important;
		}
		.x-window-tl *.x-window-header {
			padding-top : 6px !important;
		}
		label {
			display : inline !important;
		}
		.x-layer ul {
		 	min-height: 27px !important;
		}
		
	</style>
<script>
	var outerPanel;
    var jspName = "dtcErrorCodeReport";
	var exportDataType = "int,int,string,string,string,datetime,string";
	var UID;  
	var grid;
	var store;
    var toDate = datecur;
    var fromDate = twoDaysPrev;
    
    var startDate = new Ext.form.DateField({
        fieldLabel: '',
        width: 160,
        id: 'startdate',
        format: 'd-m-Y H:i:s',
        value: fromDate,
        listeners: {
             'change' : function(field, newValue, oldValue) {
				store.load({params: {startDate: ''}});
            }
        }
    });

    var endDate = new Ext.form.DateField({
        id: 'enddate',
        width: 160,
        format: 'd-m-Y H:i:s',
        value: toDate,
        listeners : {
            'change' : function(field, newValue, oldValue) {
                store.load({params: {startDate: ''}});
            }
        }
    });
    var datePanel = new Ext.Panel({
        standardSubmit: true,
        frame: true,
        collapsible: false,
        layout: 'table',
        layoutConfig: {
            columns: 10
        },
        height:50,
        items: [{width:50},{
            xtype: 'label',
            text: 'Start Date :',
            width: 90,
            cls: 'labelstyle'
        },{width:5},startDate,{width: 80},{
            xtype: 'label',
            text: 'End Date :',
            width: 90,
            cls: 'labelstyle'
        },{width:5},endDate, {width: 80},{
            text: 'View',
            xtype: 'button',
            width: 40,
            cls: 'bskExtStyle',
            listeners: {
                click: {
                    fn: function () {
                        if (Ext.getCmp('startdate').getValue() == "") {
                            Ext.example.msg("Please Select From Date");
                            Ext.getCmp('startdate').focus();
                            return;
                        }
                        if (Ext.getCmp('enddate').getValue() == "") {
                            Ext.example.msg("Please Select To Date");
                            Ext.getCmp('enddate').focus();
                            return;
                        } // end of if
                        if (DateCompare3(document.getElementById('startdate').value, document.getElementById('enddate').value) == false) {
							Ext.example.msg("End Date should be greater than Start Date");
							return;
                        }

                        if (checkMonthValidation(Ext.getCmp('startdate').getValue(),Ext.getCmp('enddate').getValue())) {
                           Ext.example.msg("Difference between two days should be 1 month");
                            return;
                        }
						store.load({
                            params: {
                                startDate: Ext.getCmp('startdate').getValue(),
                                endDate: Ext.getCmp('enddate').getValue(),
                                jspName : jspName
                            }
                        });
                    } // end of function
                } // end of click
            } // end of listener
        }] // End of Items
    }); // End of DatePanel 
	
	var filters = new Ext.ux.grid.GridFilters({
    	local: true,
        filters: [{
        	type: 'numeric',
            dataIndex: 'slnoDataIndex'
        }, {
            type: 'numeric',
            dataIndex: 'UIDDI'
        },{
        	type: 'string',
        	dataIndex: 'vehicleNoDI'
        },{
            type: 'string',
            dataIndex: 'errorCodeDI'
        },{
            type: 'string',
            dataIndex: 'errorDescDI'
        }, {
            type: 'date',
            dataIndex: 'dateTimeDI'
        }, {
            type: 'string',
            dataIndex: 'remarksDI'
        }]
	});
  
	var reader = new Ext.data.JsonReader({
    	idProperty: 'vaultdetailid1',
        root: 'errorCodeReportRoot',
        totalProperty: 'total',
        fields: [{
        	name: 'slnoDataIndex'
        }, {
            name: 'UIDDI'
        },{
        	name: 'vehicleNoDI'
        },{
            name: 'errorCodeDI'
        },{
            name: 'errorDescDI'
        },{
            name: 'dateTimeDI'
        },{
            name: 'remarksDI'
        }]
	});
   
	var store = new Ext.data.GroupingStore({
	    proxy: new Ext.data.HttpProxy({
	    url: '<%=request.getContextPath()%>/OBDAction.do?param=getErrorReportDetails',
	    method: 'POST'
	    }),
	    autoLoad: false,
	    reader: reader
	});
	
    var createColModel = function (finish, start) {
    var columns = [
    	new Ext.grid.RowNumberer({
            header: "<span style=font-weight:bold;>SLNO</span>",
            width: 60
        }),{
        	header: "<span style=font-weight:bold;>SLNO</span>",
        	dataIndex: 'slnoDataIndex',
            hidden: true,
            width: 200,
            filter: {
                type: 'numeric'
            }
        },{
            header: "<span style=font-weight:bold;>UID</span>",
            dataIndex: 'UIDDI',
            hidden: true,
            width: 400,
            filter: {
                type: 'numeric'
                }
        },{
            header: "<span style=font-weight:bold;>Asset No</span>",
            dataIndex: 'vehicleNoDI',
            hidden: false,
            width: 400,
            filter: {
                type: 'string'
                }
        },{
            header: "<span style=font-weight:bold;>Error Code</span>",
            dataIndex: 'errorCodeDI',
            hidden: false,
            width: 400,
            filter: {
                type: 'string'
                }
        },{
            header: "<span style=font-weight:bold;>Error Description</span>",
            dataIndex: 'errorDescDI',
            hidden: false,
            width: 400,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;>Date and Time</span>",
            dataIndex: 'dateTimeDI',
            hidden: false,
            width: 400,
            filter: {
                type: 'date'
            }
        },{
            header: "<span style=font-weight:bold;>Remarks</span>",
            hidden: false,
            width:500,
            dataIndex: 'remarksDI',
            filter: {
                type: 'string'
            },
            editor: new Ext.grid.GridEditor(new Ext.form.TextField({}))
        }];
    	return new Ext.grid.ColumnModel({
        	columns: columns.slice(start || 0, finish),
        	defaults: {
            	sortable: true
        	}
    	});
	};
	var grid = getGrid('', 'No Records Found', store, screen.width - 40, 450, 8, filters, '', false,'', 7,false,'',false,'',true,'Excel', jspName, exportDataType, false, 'Pdf',true,'Add Remarks');
	
	var innerPanel = new Ext.form.FormPanel({
	    standardSubmit: true,
	    collapsible: false,
	    autoScroll: true,
	    height: 110,
	    width: 380,
	    frame: true,
	    layout: 'table',
	    layoutConfig: {
	        columns: 3
	    },
	    items: [{height:10},{height:10},{height:10},{
	    	xtype: 'label',
	        text: 'Remarks : ',
	        cls: 'lablestyle',
	        id: 'remarksLblId'
	      	},{width:20},{
	      	xtype: 'textarea',
	      	width: 270,
	      	height: 80,
	        cls: 'selectPerfectStyle',
	        id: 'remarksId'
	        }]
	});
	
	var winButtonPanel = new Ext.form.FormPanel({
	    standardSubmit: true,
	    collapsible: false,
	    autoScroll: true,
	    height: 50,
	    width: 380,
	    frame: true,
	    layout: 'table',
	    layoutConfig: {
	        columns: 4
	    },
	    items: [{width:100},{
	    	xtype: 'button',
	        text: 'Save',
	        id: 'saveBtnId',
	        cls: 'buttonstyle',
        	iconCls : 'savebutton',
	        listeners:{
	        click:{
	        fn: function(){
	        	if(Ext.getCmp('remarksId').getValue() == ""){
	        		Ext.example.msg("Please enter remarks");
	        		return;
	        	}
	        	Ext.Ajax.request({
                url: '<%=request.getContextPath()%>/OBDAction.do?param=addRemarks',
                method: 'POST',
                params: {
					remarks : Ext.getCmp('remarksId').getValue(),
					UID : UID
                },
                success: function (response, options) {
					var message = response.responseText;
                    Ext.example.msg(message);
                    myWin.hide();
            		myWin.getEl().unmask();  
            		store.reload();
               	},
                failure: function () {
					Ext.example.msg("Error");
                }
            	});
	        }}}
	      	},{width:20},{
	      	xtype: 'button',
	      	text: 'Cancel',
	        id: 'canclBtnId',
	        cls: 'buttonstyle',
        	iconCls : 'cancelbutton',
	        listeners:{
	        click:{
	        fn: function(){
	        	myWin.hide();
	        }}
	        }
	        }]
	});
	    
	var	myWin = new Ext.Window({
		title: 'Add Remarks',
		closable: false,
	    modal: true,
	    resizable: false,
	    autoScroll: false,
	    frame: true,
	    height: 210,
	    width: 396,
	    id: 'myWin',
	    items: [innerPanel,winButtonPanel]
	});
	
	function addRecord(){
		var selected = grid.getSelectionModel().getSelected();
		if(selected == "undefined" || selected == undefined){
			Ext.example.msg("Please select a record");
			return;
		}
		UID = selected.get('UIDDI');
		myWin.show();
		Ext.getCmp('remarksId').setValue(selected.get('remarksDI'));
	}
	
	Ext.onReady(function() {
		Ext.QuickTips.init();
    	Ext.form.Field.prototype.msgTarget = 'side';
    	outerPanel = new Ext.Panel({
    	title: 'DTC Error Code Report',
        renderTo: 'content',
        id: 'outerPanel',
        standardView: true,
        autoScroll: false,
        frame: true,
        border: true,
        height:555,
        width:screen.width-22,
        layout: 'table',
        cls: 'outerpanel',
        layoutConfig: {
            columns: 1
        },
        items: [datePanel,grid]
  		});
	    var cm = grid.getColumnModel();  
	    for (var i = 1; i < cm.getColumnCount(); i++) {
	    	if(i == 5){
	    	 	cm.setColumnWidth(i,400);
	   		}else if(i == 3 || i == 7){
	   			cm.setColumnWidth(i, 230);
	   		}else{
	   		 	cm.setColumnWidth(i,200);
	   		}
	    }
	});
</script>
<jsp:include page="../Common/footer.jsp" />
	<!-- </body>   -->
<!-- </html> -->

