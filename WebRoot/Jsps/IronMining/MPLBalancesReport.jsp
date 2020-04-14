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
	String MPL_Balances_Report = "MPL Balances Details";
	
%>

<jsp:include page="../Common/header.jsp" />
 		<title>MPL Balances Report</title>
 		<meta http-equiv="X-UA-Compatible" content="IE=11">			
    
	 <style>
  .x-panel-tl
	{
		border-bottom: 0px solid !important;
	}
  </style>

  <%if (loginInfo.getStyleSheetOverride().equals("Y")){%>                  
    <jsp:include page="../Common/ImportJSSandMining.jsp"/>                                               
   <%}else {%>  
   <jsp:include page="../Common/ImportJS.jsp" /><%} %>
   <jsp:include page="../Common/ExportJS.jsp" />
    <% String newMenuStyle=loginInfo.getNewMenuStyle();
		if(newMenuStyle.equalsIgnoreCase("YES")){%>
		<style>
			.ext-strict .x-form-text {
				height: 21px !important;
			}
			label {
				display : inline !important;
			}
			.x-window-tl *.x-window-header {
				padding-top : 6px !important;
			}
			.x-layer ul {
				min-height: 27px !important;
			}
		</style>
	<%}%>
   <script>

var jspName = "MPLBalancesReport";
var exportDataType = "int,string,string,string,number,number,number";
var grid;

	var clientcombostore = new Ext.data.JsonStore({
	    url: '<%=request.getContextPath()%>/CommonAction.do?param=getCustomer',
	    id: 'CustomerStoreId',
	    root: 'CustomerRoot',
	    autoLoad: true,
	    remoteSort: true,
	    fields: ['CustId', 'CustName'],
	    listeners: {
	        load: function (custstore, records, success, options) {
	            if ( <%= customerId %> > 0) {
	                Ext.getCmp('custcomboId').setValue('<%=customerId%>');
		                custId = Ext.getCmp('custcomboId').getValue();	
		                
		            }
		        }
		    }
	});
	
	var client = new Ext.form.ComboBox({
	    store: clientcombostore,
	    id: 'custcomboId',
	    mode: 'local',
	    forceSelection: true,
	    emptyText: 'select customer ',
	    blankText: 'select customer ',
	    resizable: true,
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
	            fn: function () {
	            		custId = Ext.getCmp('custcomboId').getValue();
	            			                 
	            }
	        }
	    }
	});
	
   var clientPanel = new Ext.Panel({
       standardSubmit: true,
       collapsible: false,
       id: 'clientPanelId',
       layout: 'table',
       frame: false,
       width: screen.width - 60,
       height: 40,
       layoutConfig: {
           columns: 5
       },
	       items: [{
	               xtype: 'label',
	               text: 'Customer Name :',
	               cls: 'labelstyle',
	               id: 'ltspcomboId'
	           	}, client, {
	               width: 20
	           	}, {
	           		xtype: 'button',
	           		text: 'Generate Report',
	           		handler: function(){
		            	if (Ext.getCmp('custcomboId').getValue() == "") {
	                        Ext.example.msg("Enter Customer Name");
	                        Ext.getCmp('custcomboId').focus();
	                        return;
	                    }
	                 custId = Ext.getCmp('custcomboId').getValue();
	            	 store.load({
		            	 params:{
			            	 custId:custId,
			            	 custName:Ext.getCmp('custcomboId').getRawValue(),
			            	 jspName:jspName
		            	 }
	            	 });
	            	}
	           	}
			]
   });
	
	var reader = new Ext.data.JsonReader({
          idProperty: 'MPLBalancesRootId',
          root: 'MPLBalancesRoot',
          totalProperty: 'total',
          fields: [{                      
                      name: 'slnoIndex'
                   },{
                      name: 'tcNoIndex'
                   },{
                      name: 'leaseNameIndex'
                   },{
                      name: 'orgNameIndex'
                   },{
                      name: 'mplAllocatedIndex'
                   },{
                      name: 'mplUsedIndex'
                   },{
                      name: 'mplBalanceIndex'
                   }]
        });
    	var store = new Ext.data.GroupingStore({
	            autoLoad: false,
	            proxy: new Ext.data.HttpProxy({
	            url: '<%=request.getContextPath()%>/MiningReportsAction.do?param=getMPLBalancesDetails',
	            method: 'POST'
            }),
            reader: reader
        });    
        var filter = new Ext.ux.grid.GridFilters({
            local: true,
            filters: [{
                        type: 'numeric',
                        dataIndex: 'slnoIndex'
                    },{
                        type: 'string',
                        dataIndex: 'tcNoIndex',                    
                     },{
                        type: 'string',
                        dataIndex: 'leaseNameIndex',                    
                     },{
                        type: 'string',
                        dataIndex: 'orgNameIndex',                    
                     },{
                         type: 'string',
                         dataIndex: 'mplAllocatedIndex'
                     },{
                        type: 'string',
                        dataIndex: 'mplUsedIndex'
                     },{
                        type: 'string',
                        dataIndex: 'closingStockIndex'
                     },{
                        type: 'string',
                        dataIndex: 'ExmineIndex'
                     }]
        });
    
 var createColModel = function(finish, start) {
		   var columns = [
		    new Ext.grid.RowNumberer({
		           header : "<span style=font-weight:bold;>SLNO</span>",
		           width : 50
		       }),{
                header: "<span style=font-weight:bold;>SLNO</span>",
                hidden: true,            
                dataIndex: 'slnoIndex'
            },{
                header: "<span style=font-weight:bold;>TC Number</span>",
                dataIndex: 'tcNoIndex'
            },{
                header: "<span style=font-weight:bold;>Lease Name</span>",
                dataIndex: 'leaseNameIndex'
            },{
                header: "<span style=font-weight:bold;>Organization Name</span>",
                dataIndex: 'orgNameIndex'
            },{
                header: "<span style=font-weight:bold;>MPL Allocated</span>",
                align: 'right',
                dataIndex: 'mplAllocatedIndex'
            },{
                header: "<span style=font-weight:bold;>MPL Used</span>",
                align: 'right',
                dataIndex: 'mplUsedIndex'
            },{
                header: "<span style=font-weight:bold;>MPL Balance</span>",
                align: 'right',
                dataIndex: 'mplBalanceIndex'
            }];
            return new Ext.grid.ColumnModel({
		       columns: columns.slice(start || 0, finish),  
		       defaults: {
		           sortable: true
		       }
		   });
        };
        
        
grid = getGrid('<%=MPL_Balances_Report%>','No Record Found',store,screen.width - 40,470,20,filter,'Clear Filter Data',false,'',9,false,'',false,'',true,'Excel',jspName,exportDataType,false,'PDF',false,'Add',false,'Modify',false,'');

Ext.onReady(function() {
    ctsb = tsb;
    Ext.QuickTips.init();
    Ext.form.Field.prototype.msgTarget = 'side';
    outerPanel = new Ext.Panel({
        title: '',
        renderTo: 'content',
        standardSubmit: true,
        frame: true,
        width: screen.width - 28,
        height: 540,
        cls: 'outerpanel',
        layout: 'table',
        layoutConfig: {
            columns: 1
        },
        items: [clientPanel,grid]
    });
    var cm =grid.getColumnModel();  
    for (var j = 1; j < cm.getColumnCount(); j++) {
       cm.setColumnWidth(j,207);
    }
});
</script>
 <jsp:include page="../Common/footer.jsp" />
 <!-- </body>   -->
 <!-- </html> -->
 