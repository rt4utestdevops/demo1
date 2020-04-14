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
	String Imports_Exports_Report = "Imports Exports Report";
	
	String orgName = "Organization Name";
	String orgCode = "Organizatoin Code";
	String domExpFines = "Domestic Exp Fines";
	String domExpLumps = "Domestic Exp Lumps";
	String domExpConc = "Domestic Exp Concentrates";
	String domExpTailings = "Domestic Exp Tailings";
	String totalDomExp = "Total Domestic Exp";
	String intExpFines = "Int Exp Fines";
	String intExpLumps = "Int Exp Lumps";
	String intExpConc = "Int Exp Concentrates";
	String intExpTailings = "Int Exp Tailings";
	String totalIntExp = "Total Int Exp";
	String domImpFines = "Domestic Imp Fines";
	String domImpLumps = "Domestic Imp Lumps";
	String domImpConc = "Domestic Imp Concentrates";
	String domImpTailings = "Domestic Imp Tailings";
	String totalDomImp = "Total Domestic Imp";
	String intImpFines = "Int Imp Fines";
	String intImpLumps = "Int Imp Lumps";
	String intImpConc = "Int Imp Concentrates";
	String intImpTailings = "Int Imp Tailings";
	String totalIntImp = "Total Int Imp";
	
%>

<jsp:include page="../Common/header.jsp" />
 		<title>Imports Exports Report</title>
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
   <script>

var jspName = "ImportsExportsReport";
var exportDataType = "int,int,string,string,number,number,number,number,number,number,number,number,number,number,number,number,number,number,number,number,number,number,number,number";
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
          idProperty: 'ImportsExportsRootId',
          root: 'ImportsExportsRoot',
          totalProperty: 'total',
          fields: [{                      
                      name: 'slnoIndex'
                   },{
                      name: 'orgIdInd'
                   },{
                      name: 'orgNameInd'
                   },{
                      name: 'orgCodeInd'
                   },{
                      name: 'domExpFinesInd'
                   },{
                      name: 'domExpLumpsInd'
                   },{
                      name: 'domExpConcInd'
                   },{
                      name: 'domExpTailingsInd'
                   },{
                      name: 'totalDomExpInd'
                   },{
                      name: 'intExpFinesInd'
                   },{
                      name: 'intExpLumpsInd'
                   },{
                      name: 'intExpConcInd'
                   },{
                      name: 'intExpTailingsInd'
                   },{
                      name: 'totalIntExpInd'
                   },{
                      name: 'domImpFinesInd'
                   },{
                      name: 'domImpLumpsInd'
                   },{
                      name: 'domImpConcInd'
                   },{
                      name: 'domImpTailingsInd'
                   },{
                      name: 'totalDomImpInd'
                   },{
                      name: 'intImpFinesInd'
                   },{
                      name: 'intImpLumpsInd'
                   },{
                      name: 'intImpConcInd'
                   },{
                      name: 'intImpTailingsInd'
                   },{
                      name: 'totalIntImpInd'
                   }]
        });
    	var store = new Ext.data.GroupingStore({
	            autoLoad: false,
	            proxy: new Ext.data.HttpProxy({
	            url: '<%=request.getContextPath()%>/MiningReportsAction.do?param=getImportsExportsReportDetails',
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
                        type: 'numeric',
                        dataIndex: 'orgIdInd',                    
                     },{
                        type: 'string',
                        dataIndex: 'orgNameInd',                    
                     },{
                        type: 'string',
                        dataIndex: 'orgCodeInd',                    
                     },{
                        type: 'numeric',
                        dataIndex: 'domExpFinesInd',                    
                     },{
                         type: 'numeric',
                         dataIndex: 'domExpLumpsInd'
                     },{
                        type: 'numeric',
                        dataIndex: 'domExpConcInd',                    
                     },{
                         type: 'numeric',
                         dataIndex: 'domExpTailingsInd'
                     },{
                        type: 'numeric',
                        dataIndex: 'totalDomExpInd'
                     },{
                        type: 'numeric',
                        dataIndex: 'intExpFinesInd'
                     },{
                        type: 'numeric',
                        dataIndex: 'intExpLumpsInd'
                     },{
                        type: 'numeric',
                        dataIndex: 'intExpConcInd'
                     },{
                        type: 'numeric',
                        dataIndex: 'intExpTailingsInd'
                     },{
                        type: 'numeric',
                        dataIndex: 'totalIntExpInd',                    
                     },{
                         type: 'numeric',
                         dataIndex: 'domImpFinesInd'
                     },{
                        type: 'numeric',
                        dataIndex: 'domImpLumpsInd'
                     },{
                         type: 'numeric',
                         dataIndex: 'domImpConcInd'
                     },{
                        type: 'numeric',
                        dataIndex: 'domImpTailingsInd'
                     },{
                        type: 'numeric',
                        dataIndex: 'totalDomImpInd'
                     },{
                        type: 'numeric',
                        dataIndex: 'intImpFinesInd'
                     },{
                        type: 'numeric',
                        dataIndex: 'intImpLumpsInd'
                     },{
                        type: 'numeric',
                        dataIndex: 'intImpConcInd'
                     },{
                        type: 'numeric',
                        dataIndex: 'intImpTailingsInd'
                     },{
                        type: 'numeric',
                        dataIndex: 'totalIntImpInd'
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
                width : 50,            
                dataIndex: 'slnoIndex'
            },{
                header: "<span style=font-weight:bold;>ORG ID</span>",
                hidden: true,
                width : 80,
                dataIndex: 'orgIdInd'
            },{
                header: "<span style=font-weight:bold;><%=orgName%></span>",
                dataIndex: 'orgNameInd'
            },{
                header: "<span style=font-weight:bold;><%=orgCode%></span>",
                hidden: true,
                dataIndex: 'orgCodeInd'
            },{
                header: "<span style=font-weight:bold;><%=domExpFines%></span>",
                align: 'right',
                dataIndex: 'domExpFinesInd'
            },{
                header: "<span style=font-weight:bold;><%=domExpLumps%></span>",
                align: 'right',
                dataIndex: 'domExpLumpsInd'
            },{
                header: "<span style=font-weight:bold;><%=domExpConc%></span>",
                align: 'right',
                dataIndex: 'domExpConcInd'
            },{
                header: "<span style=font-weight:bold;><%=domExpTailings%></span>",
                align: 'right',
                dataIndex: 'domExpTailingsInd'
            },{
                header: "<span style=font-weight:bold;><%=totalDomExp%></span>",
                align: 'right',
                dataIndex: 'totalDomExpInd'
            },{
                header: "<span style=font-weight:bold;><%=intExpFines%></span>",
                align: 'right',
                dataIndex: 'intExpFinesInd'
            },{
                header: "<span style=font-weight:bold;><%=intExpLumps%></span>",
                align: 'right',
                dataIndex: 'intExpLumpsInd'
            },{
                header: "<span style=font-weight:bold;><%=intExpConc%></span>",
                align: 'right',
                dataIndex: 'intExpConcInd'
            },{
                header: "<span style=font-weight:bold;><%=intExpTailings%></span>",
                align: 'right',
                dataIndex: 'intExpTailingsInd'
            },{
                header: "<span style=font-weight:bold;><%=totalIntExp%></span>",
                align: 'right',
                dataIndex: 'totalIntExpInd'
            },{
                header: "<span style=font-weight:bold;><%=domImpFines%></span>",
                align: 'right',
                dataIndex: 'domImpFinesInd'
            },{
                header: "<span style=font-weight:bold;><%=domImpLumps%></span>",
                align: 'right',
                dataIndex: 'domImpLumpsInd'
            },{
                header: "<span style=font-weight:bold;><%=domImpConc%></span>",
                align: 'right',
                dataIndex: 'domImpConcInd'
            },{
                header: "<span style=font-weight:bold;><%=domImpTailings%></span>",
                align: 'right',
                dataIndex: 'domImpTailingsInd'
            },{
                header: "<span style=font-weight:bold;><%=totalDomImp%></span>",
                align: 'right',
                dataIndex: 'totalDomImpInd'
            },{
                header: "<span style=font-weight:bold;><%=intImpFines%></span>",
                align: 'right',
                dataIndex: 'intImpFinesInd'
            },{
                header: "<span style=font-weight:bold;><%=intImpLumps%></span>",
                align: 'right',
                dataIndex: 'intImpLumpsInd'
            },{
                header: "<span style=font-weight:bold;><%=intImpConc%></span>",
                align: 'right',
                dataIndex: 'intImpConcInd'
            },{
                header: "<span style=font-weight:bold;><%=intImpTailings%></span>",
                align: 'right',
                dataIndex: 'intImpTailingsInd'
            },{
                header: "<span style=font-weight:bold;><%=totalIntImp%></span>",
                align: 'right',
                dataIndex: 'totalIntImpInd'
            }];
            return new Ext.grid.ColumnModel({
		       columns: columns.slice(start || 0, finish),  
		       defaults: {
		           sortable: true
		       }
		   });
        };
        
        
grid = getGrid('<%=Imports_Exports_Report%>','No Record Found',store,screen.width - 40,470,28,filter,'Clear Filter Data',false,'',19,false,'',false,'',true,'Excel',jspName,exportDataType,false,'PDF',false,'Add',false,'Modify',false,'');

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
    for (var j = 3; j < cm.getColumnCount(); j++) {
       cm.setColumnWidth(j,150);
    }
});
</script>
<jsp:include page="../Common/footer.jsp" />
	<!-- </body>   -->
<!-- </html> -->
 