<%@ page  language="java" import="java.util.*,t4u.functions.*,t4u.beans.*,t4u.common.*" pageEncoding="utf-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
if (request.getParameter("list") != null) {
		String list = request.getParameter("list").toString().trim();

		String[] str = list.split(",");
		int systemid = Integer.parseInt(str[0].trim());
		int customerid = Integer.parseInt(str[1].trim());
		int userid = Integer.parseInt(str[2].trim());
		String language = str[3].trim();
		LoginInfoBean loginInfo = new LoginInfoBean();
		LoginInfoBean loginInfo1=new LoginInfoBean();
		loginInfo1=(LoginInfoBean)session.getAttribute("loginInfoDetails");
		if(loginInfo1!=null)
		{
		int isLtsp=loginInfo1.getIsLtsp();
		loginInfo.setIsLtsp(isLtsp);
		}
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
		loginInfo.setCountryCode(Integer.parseInt(str[11].trim()));

		session.setAttribute("loginInfoDetails", loginInfo);
	}
	CommonFunctions cf=new CommonFunctions();
	LoginInfoBean loginInfo=(LoginInfoBean)session.getAttribute("loginInfoDetails");
	if(loginInfo==null){
		response.sendRedirect(request.getContextPath()+ "/Jsps/Common/SessionDestroy.html");
	}
	else
	{   
	    session.setAttribute("loginInfoDetails", loginInfo);    
		String language = loginInfo.getLanguage();
ArrayList<String> tobeConverted=new ArrayList<String>();
	tobeConverted.add("Select_Customer");
	tobeConverted.add("Please_Select_customer");
	tobeConverted.add("SLNO");
	tobeConverted.add("No_Records_Found");
	tobeConverted.add("Error");
	tobeConverted.add("Select_Single_Row");
    tobeConverted.add("Amount_Paid");
	tobeConverted.add("TC_Number");
	tobeConverted.add("Reconcilation_Report");
	tobeConverted.add("Month_Year");
	tobeConverted.add("No_Of_Challans");
	tobeConverted.add("Current_Rate");
	tobeConverted.add("Credit_Debit_Amount");
ArrayList<String> convertedWords=new ArrayList<String>();
convertedWords=cf.getLanguageSpecificWordForKey(tobeConverted,language);
    String selectCustomer=convertedWords.get(0);
    String pleaseSelectCustomer=convertedWords.get(1);
	String SLNO=convertedWords.get(2);
	String noRecordsFound=convertedWords.get(3);
	String error=convertedWords.get(4);
	String SelectSingleRow=convertedWords.get(5);
	String AmountPaid=convertedWords.get(6);
	String TC_Number=convertedWords.get(7);
	String Reconcilation_Report=convertedWords.get(8);
	String Month_Year=convertedWords.get(9);
	String No_Of_Challans=convertedWords.get(10);
	String Current_Rate=convertedWords.get(11);
	String Credit_Debit_Amount=convertedWords.get(12);
	int systemId = loginInfo.getSystemId();
	int userId=loginInfo.getUserId(); 
	int customerId = loginInfo.getCustomerId();
	String userAuthority=cf.getUserAuthority(systemId,userId);
	if(customerId > 0 && loginInfo.getIsLtsp()== -1 && !userAuthority.equalsIgnoreCase("Admin"))
	{
		response.sendRedirect(request.getContextPath()+ "/Jsps/Common/401Error.html");
	}
	else{
%>
	

<jsp:include page="../Common/header.jsp" />
    
    <title><%=Reconcilation_Report%></title>

	</style>
  
        <%if (loginInfo.getStyleSheetOverride().equals("Y")){%>                  
        <jsp:include page="../Common/ImportJSSandMining.jsp" />                                                    
        <%}else {%>  
        <jsp:include page="../Common/ImportJS.jsp" /><%} %>
         <jsp:include page="../Common/ExportJS.jsp" />
	  <% String newMenuStyle=loginInfo.getNewMenuStyle();
		if(newMenuStyle.equalsIgnoreCase("YES")){%>
		<style>
			label {
				display : inline !important;
			}			
			.ext-strict .x-form-text {
				height: 21px !important;
			}
			.x-layer ul {
				min-height: 27px !important;
			}						
			.x-menu-list {
				height:auto !important;
			}				
			.x-window-tl *.x-window-header {			
				padding-top : 6px !important;
			}			
		</style>
	 <%}%>
        <script>
		var grid;
		var myWin;
		var buttonValue;
		var uniqueId;
		var closewin;
		var approveWin;
		var outerPanel;
		var AssetNo;
	 	var jspName='<%=Reconcilation_Report%>';
    	var exportDataType = "int,string,string,int,number,number,number";
  //*********************** Store For Customer *****************************************//
	var customercombostore = new Ext.data.JsonStore({
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
                
                store.load({
                    params: {
                        CustID: Ext.getCmp('custcomboId').getValue(),
                        jspName: jspName,
                        custName: Ext.getCmp('custcomboId').getRawValue()
                       
                  }
              });
             
             
            }
        }
    }
});
//************************ Combo for Customer Starts Here***************************************//
	var custnamecombo = new Ext.form.ComboBox({
    store: customercombostore,
    id: 'custcomboId',
    mode: 'local',
    forceSelection: true,
    emptyText: '<%=pleaseSelectCustomer%>',
    selectOnFocus: true,
    resizable: true,
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
                 
               store.load({
                    params: {
                        CustID: Ext.getCmp('custcomboId').getValue(),
                        jspName: jspName,
                        custName: Ext.getCmp('custcomboId').getRawValue()
                  }
              });
             
              
            }
        }
    }
	});
	
	
	
   	// **********************************************Reader configs Starts******************************
    
     var reader = new Ext.data.JsonReader({
        idProperty: 'tripcreationId',
    	root: 'reconcilationRoot',
    	totalProperty: 'total',
    	fields: [{
        name: 'slnoIndex'
    	},{
        name: 'TcNumberDataIndex'
    	},{
        name: 'MonthYearDataIndex'
    	},{
        name: 'NoOfChallanDataIndex'
    	},{
        name: 'AmountPaidDataIndex'
    	},{
        name: 'CurrentRateDataIndex'
    	},{
        name: 'CreditDebitDataIndex'
    	}]
    });
    
    // **********************************************Reader configs Ends******************************
    //********************************************Store Configs For Grid*************************

    var store = new Ext.data.GroupingStore({
        autoLoad: false,
        proxy: new Ext.data.HttpProxy({
            url: '<%=request.getContextPath()%>/ReconcilationAction.do?param=getSummaryDetails',
            method: 'POST'
        }),
        remoteSort: false,
        storeId: 'ReconcilationStore',
        reader: reader
        });
        
   //********************************************Store Configs For Grid Ends*************************
    //********************************************************************Filter Config***************
       
    	var filters = new Ext.ux.grid.GridFilters({
        local: true,
    	filters: [{
        type: 'numeric',
        dataIndex: 'slnoIndex'
    	},{
    	type: 'string',
        dataIndex: 'TcNumberDataIndex'
    	},{
    	type: 'string',
        dataIndex: 'MonthYearDataIndex'
    	},{
    	type: 'numeric',
        dataIndex: 'NoOfChallanDataIndex'
    	},
    	{
    	type: 'numeric',
        dataIndex: 'AmountPaidDataIndex'
    	},{
    	type: 'string',
        dataIndex: 'CurrentRateDataIndex'
    	},{
    	type: 'string',
        dataIndex: 'CreditDebitDataIndex'
    	}]
    	});
    	
    	//***************************************************Filter Config Ends ***********************

    //*********************************************Column model config**********************************
    var createColModel = function (finish, start) {

        var columns = [
            new Ext.grid.RowNumberer({
        	header: "<span style=font-weight:bold;><%=SLNO%></span>",
        	width: 50
    		}), {
        	dataIndex: 'slnoIndex',
        	hidden: true,
        	header: "<span style=font-weight:bold;><%=SLNO%></span>",
        	filter: {
            type: 'numeric'
        	}
    		},{
        	header: "<span style=font-weight:bold;><%=TC_Number%></span>",
        	dataIndex: 'TcNumberDataIndex',
        	width:150,
        	
        	filter: {
            type: 'string'
            
        	}
    		}, {
        	header: "<span style=font-weight:bold;><%=Month_Year%></span>",
        	dataIndex: 'MonthYearDataIndex',
        	width:150,
        	filter: {
            type: 'string'
        	}
    		},{
    		header: "<span style=font-weight:bold;><%=No_Of_Challans%></span>",
    		dataIndex: 'NoOfChallanDataIndex',
    		width:150,
    		sortable: true,		
    		filter: {
    		type: 'numeric'
    		}
    		},{
    		header: "<span style=font-weight:bold;><%=AmountPaid%></span>",
    		dataIndex: 'AmountPaidDataIndex',
    		width:150,
    		sortable: true,		
    		filter: {
    		type: 'numeric'
    		}
    		},{
    		header: "<span style=font-weight:bold;><%=Current_Rate%></span>",
    		dataIndex: 'CurrentRateDataIndex',
    		width:150,
    		sortable: true,		
    		filter: {
    		type: 'string'
    		}
    		},{
    		header: "<span style=font-weight:bold;><%=Credit_Debit_Amount%></span>",
    		dataIndex: 'CreditDebitDataIndex',
    		    		sortable: true,		
    		    		width:150,
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
     //*********************************************Column model config Ends*************************** 	
    //******************************************Creating Grid By Passing Parameter***********************
    
     grid = getGrid('<%=Reconcilation_Report%>', '<%=noRecordsFound%>', store,screen.width-30,420, 8, filters, 'Clear Filter Data', false, '', 20, false, '', false, '', true, 'Excel', jspName, exportDataType, false, 'PDF', false, 'Add', false, 'Modify', false, '', false , '',false,'',true,'View Details');
     		
	//**********************************End Of Creating Grid By Passing Parameter*************************

	   
			var customerPanel = new Ext.Panel({
   standardSubmit: true,
   collapsible: false,
   id: 'customerComboPanelId',
   layout: 'table',
   frame: false,
   width: screen.width - 12,
   height: 40,
   layoutConfig: {
       columns: 13
   },
   items: [{
           xtype: 'label',
           text: '<%=selectCustomer%>' + ' :',
           cls: 'labelstyle'
       },
       custnamecombo
   ]
});	
				
function approveFunction() {
     if (Ext.getCmp('custcomboId').getValue() == "") {
    	Ext.example.msg("<%=pleaseSelectCustomer%>");
    	Ext.getCmp('custcomboId').focus();
        return;
    }
    if(grid.getSelectionModel().getCount()>1){
        Ext.example.msg("<%=SelectSingleRow%>");
        return;
    }
 
    if (grid.getSelectionModel().getSelected() == null) {
        Ext.example.msg("<%=noRecordsFound%>");
        Ext.getCmp('custcomboId').focus();
        return;
    }
     buttonValue = "viewDocument";
     var selected = grid.getSelectionModel().getSelected();
     TcNum=selected.get('TcNumberDataIndex');
     monthYear=selected.get('MonthYearDataIndex');
     custId=Ext.getCmp('custcomboId').getValue();
     custName=Ext.getCmp('custcomboId').getRawValue();
     TcNum=TcNum.replace(/ /g,"%20");
     monthYear=monthYear.replace(/ /g,"%20");
     custName=custName.replace(/ /g,"%20");
     window.location="<%=request.getContextPath()%>/Jsps/IronMining/SummaryDetails.jsp?TcNum="+TcNum+"&MonthYear="+monthYear+"&custIdDetails="+custId+"&custNameDetails="+custName;
   }

    
    Ext.onReady(function() {
   ctsb = tsb;
   Ext.QuickTips.init();
   Ext.form.Field.prototype.msgTarget = 'side';
   outerPanel = new Ext.Panel({

       renderTo: 'content',
       standardSubmit: true,
       frame: true,
       width: screen.width - 22,
       cls: 'outerpanel',
       layout: 'table',
       layoutConfig: {
           columns: 1
       },
       items: [customerPanel, grid]
   });
   sb = Ext.getCmp('form-statusbar');
});   
			
   </script>
  <jsp:include page="../Common/footer.jsp" />
 <!-- </body>   -->
 <!-- </html> -->
<%}%>
<%}%>