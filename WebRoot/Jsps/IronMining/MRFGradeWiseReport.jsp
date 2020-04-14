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
	String date = "";
	String MRFGradeWiseReportforTitle = "MRF Grade Wise Report";
	
%>

<jsp:include page="../Common/header.jsp" />
 		<title>Grade Wise Report</title>
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
	<style>			
		label {
			display : inline !important;
		}
		.x-window-tl *.x-window-header {
			height : 38px !important;
		}
		.ext-strict .x-form-text {
			height: 21px !important;
		}
		.x-layer ul {
		 	min-height: 27px !important;
		}
		.x-table-layout-ct {
			overflow : hidden !important;
		}
		.x-menu-list {
			height:auto !important;
		}	
	</style>
   <script>


var dtnext1 = datecur.add(Date.DAY, +1); 
var dtcur = datecur;  
var outerPanel;
var ctsb;
var jspName = "MRFGradeWiseReport";
var exportDataType = "int,string,string,float,float,float,float,float";
var selected;
var grid;
var myWin;
var monthNames = ["January", "February", "March", "April", "May", "June","July", "August", "September", "October", "November", "December"];

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
	
	
	
	var mineralStore = new Ext.data.SimpleStore({
	      	  id: 'mineralsComboStoreId',
		      fields: ['Name', 'Value'],
		      autoLoad: true,
		      data: [
		          ['Iron Ore', 'Iron Ore'],
		          ['Bauxite/Laterite', 'Bauxite/Laterite'],
				  ['Manganese', 'Manganese']
		      ]
   });
   
   var mineralCombo = new Ext.form.ComboBox({
       store: mineralStore,
       id: 'mineralComboId',
       mode: 'local',
       forceSelection: true,
       selectOnFocus: true,
       allowBlank: false,
       anyMatch: true,
       typeAhead: false,
       triggerAction: 'all',
       lazyRender: true,
       valueField: 'Value',
       emptyText: 'Select Mineral',
       resizable: true,
       displayField: 'Name',
       cls: 'selectstylePerfect',
       listeners: {
        select: {
               fn: function() {
                    Ext.getCmp('gradeComboId').reset();
               		var typeOfOre=Ext.getCmp('mineralComboId').getValue();
		            gradeStore.load({params:{typeOfOre:typeOfOre}});
               }
           }
        }
   });
   
   var gradeStore = new Ext.data.JsonStore({
       url: '<%=request.getContextPath()%>/MonthlyReturnsReportsAction.do?param=getGrade',
       id: 'gradeCodeStoreId',
       root: 'gradeRoot',
       autoLoad: false,
       //remoteSort: true,
       fields: ['gradesIndex']
       
   });
   
   var gradeCombo = new Ext.form.ComboBox({
       store: gradeStore,
       id: 'gradeComboId',
       mode: 'local',
       forceSelection: true,
       selectOnFocus: true,
       allowBlank: false,
       resizable: true,
       anyMatch: true,
       typeAhead: false,
       triggerAction: 'all',
       lazyRender: true,
       valueField: 'gradesIndex',
       emptyText: 'Select Grade',
       displayField: 'gradesIndex',
       cls: 'selectstylePerfect',
       listeners: {
        select: {
               fn: function() {
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
           columns: 15
       },
	       items: [{
	               xtype: 'label',
	               text: 'Customer Name :',
	               cls: 'labelstyle',
	               id: 'ltspcomboId'
	           	},
	           	client, {
	               width: 20
	           	},{
					xtype: 'label',
					cls:'labelstyle',
					id:'datelab',
					text: 'Select Date :'
					},{
					xtype: 'datefield',
					format:getMonthYearFormat(),  	
					plugins: 'monthPickerPlugin',	        
					id: 'DateId',  		        
					value: dtcur,  		     
					vtype: 'daterange',
					cls: 'selectstylePerfect'
					},{
						width : 20
					},{
					xtype: 'label',
	               	text: 'Mineral Name :',
	               	cls: 'labelstyle'
	           	}, mineralCombo, {
	               width: 20
	           	},{
					xtype: 'label',
	               	text: 'Grade:',
	               	cls: 'labelstyle'
	           	},gradeCombo,{
	               width: 40
	           	},{
	           		xtype: 'button',
	           		text: 'Generate Report',
	           		handler: function(){
		            	if (Ext.getCmp('custcomboId').getValue() == "") {
	                        Ext.example.msg("Enter Customer Name");
	                        Ext.getCmp('custcomboId').focus();
	                        return;
	                    }
	                    if (Ext.getCmp('DateId').getValue() == "") {
	                        Ext.example.msg("Select Date");
	                        Ext.getCmp('DateId').focus();
	                        return;
	                    }
	                    if (Ext.getCmp('mineralComboId').getValue() == "") {
	                        Ext.example.msg("Select Mineral");
	                        Ext.getCmp('mineralComboId').focus();
	                        return;
	                    }
	                    if (Ext.getCmp('gradeComboId').getValue() == "") {
	                        Ext.example.msg("Select Grade");
	                        Ext.getCmp('gradeComboId').focus();
	                        return;
	                    }
                     var typeOfOre=Ext.getCmp('mineralComboId').getValue(); 
                     var grade = Ext.getCmp('gradeComboId').getValue();
                     var date  = Ext.getCmp('DateId').getValue();
                     var year=date.getFullYear();
                     
	            	 store.load({params:{custId:custId,custName:Ext.getCmp('custcomboId').getRawValue(),month: monthNames[date.getMonth()],year: year,typeOfOre:typeOfOre,grade:grade,jspName:jspName}});
	            	}
	           	}
			]
   });
	
	var reader = new Ext.data.JsonReader({
          idProperty: 'gradeWiseProductionRootId',
          root: 'gradeWiseRoot',
          totalProperty: 'total',
          fields: [{                      
                      name: 'SLNOIndex'
                   },{
                      name: 'mineCodeIndex'
                   },{
                      name: 'TCNoIndex'
                   },{
                      name: 'openingStockIndex'
                   },{
                      name: 'productionIndex'
                   },{
                      name: 'dispatchesIndex'
                   },{
                      name: 'closingStockIndex'
                   },{
                      name: 'ExmineIndex'
                   }]
        });
        var filter = new Ext.ux.grid.GridFilters({
            local: true,
            filters: [{
                        type: 'numeric',
                        dataIndex: 'SLNOIndex'
                    },{
                        type: 'string',
                        dataIndex: 'mineCodeIndex',                    
                     },{
                        type: 'string',
                        dataIndex: 'TCNoIndex',                    
                     },{
                        type: 'float',
                        dataIndex: 'openingStockIndex',                    
                     },{
                         type: 'float',
                         dataIndex: 'productionIndex'
                     },{
                        type: 'float',
                        dataIndex: 'dispatchesIndex'
                     },{
                        type: 'float',
                        dataIndex: 'closingStockIndex'
                     },{
                        type: 'float',
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
                width: 30,
                hidden: true,            
                dataIndex: 'SLNOIndex',
                filter:{type: 'numeric'}
            },{
                header: "<span style=font-weight:bold;>Mine Code</span>",
                sortable: true,
                dataIndex: 'mineCodeIndex',
                width:200,
                filter:{
                	type: 'string'
                }
            },{
                header: "<span style=font-weight:bold;>TC No.</span>",
                sortable: true,
                dataIndex: 'TCNoIndex',
                width:200,
                filter:{type: 'string'}
                
            },{
                header: "<span style=font-weight:bold;>Opening Stock at Mine Head</span>",
                sortable: false,
                dataIndex: 'openingStockIndex',
                width:200,
                filter:{type: 'float'}
                
            },{
                header: "<span style=font-weight:bold;>Production</span>",
                sortable: false,
                dataIndex: 'productionIndex',
                width:200,
                filter:{type: 'float'}
                
            },{
                header: "<span style=font-weight:bold;>Dispatches from Mine Head</span>",
                sortable: false,
                dataIndex: 'dispatchesIndex',
                width:200,
                filter:{type: 'float'}
                
            },{
                header: "<span style=font-weight:bold;>Closing Stock at Mine Head</span>",
                sortable: false,
                dataIndex: 'closingStockIndex',
                width:200,
                filter:{type: 'float'}
                
            },{
                header: "<span style=font-weight:bold;>Ex-mine price</span>",
                sortable: false,
                dataIndex: 'ExmineIndex',
                width:200,
                filter:{type: 'float'}
            }];
            return new Ext.grid.ColumnModel({
		       columns: columns.slice(start || 0, finish),  
		       defaults: {
		           sortable: true
		       }
		   });
        };
        var store = new Ext.data.GroupingStore({
	            autoLoad: false,
	            proxy: new Ext.data.HttpProxy({
	            url: '<%=request.getContextPath()%>/MonthlyReturnsReportsAction.do?param=getMRFGradeWiseReport',
	            method: 'POST'
            }),
            reader: reader
        });
        var selModelGradeWise=new Ext.grid.RowSelectionModel({
          singleSelect:true
        });
        
grid = getGrid('Grade Wise Details','No Record Found',store,screen.width - 40,410,20,filter,'clear filter data',false,'',9,false,'',false,'',true,'Excel',jspName,exportDataType,false,'PDF',false,'Add',false,'Modify',false,'');

function getMonthYearFormat(){
		return 'F Y';
	}
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
   
});
</script>
<jsp:include page="../Common/footer.jsp" />
 <!-- </body>   -->
 <!-- </html> -->
    
    
    
    
    

