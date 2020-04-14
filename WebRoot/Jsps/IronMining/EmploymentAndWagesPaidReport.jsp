<%@ page language="java"
	import="java.util.*,java.text.SimpleDateFormat,t4u.functions.*,t4u.beans.*,t4u.common.*"
	pageEncoding="utf-8"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://"
			+ request.getServerName() + ":" + request.getServerPort()
			+ path + "/";
	if (request.getParameter("list") != null) {
		String list = request.getParameter("list").toString().trim();

		String[] str = list.split(",");
		int systemid = Integer.parseInt(str[0].trim());
		int customerid = Integer.parseInt(str[1].trim());
		int userid = Integer.parseInt(str[2].trim());
		String language = str[3].trim();
		LoginInfoBean loginInfo = new LoginInfoBean();
		LoginInfoBean loginInfo1 = new LoginInfoBean();
		loginInfo1 = (LoginInfoBean) session.getAttribute("loginInfoDetails");
		if (loginInfo1 != null) {
			int isLtsp = loginInfo1.getIsLtsp();
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
	CommonFunctions cf = new CommonFunctions();
	LoginInfoBean loginInfo = (LoginInfoBean) session
			.getAttribute("loginInfoDetails");
	if (loginInfo == null) {
		response.sendRedirect(request.getContextPath()
				+ "/Jsps/Common/SessionDestroy.html");
	} else {
		session.setAttribute("loginInfoDetails", loginInfo);
		String language = loginInfo.getLanguage();
		ArrayList<String> tobeConverted = new ArrayList<String>();
		tobeConverted.add("Select_Customer");
		tobeConverted.add("Please_Select_customer");
		tobeConverted.add("SLNO");
		tobeConverted.add("No_Records_Found");
		tobeConverted.add("Error");
		tobeConverted.add("Select_Single_Row");
		tobeConverted.add("TC_Number");
		tobeConverted.add("Month_Year");
		tobeConverted.add("Mine_Code");
		tobeConverted.add("Submit");
		tobeConverted.add("Employment_And_Wages_Paid_Report");
		tobeConverted.add("Select_Mineral_Type");
		tobeConverted.add("Select_Labour");
		tobeConverted.add("Select_Workplace");
		tobeConverted.add("Male");
		tobeConverted.add("Female");
		tobeConverted.add("Wages");
		tobeConverted.add("Month_Year");

		ArrayList<String> convertedWords = new ArrayList<String>();
		convertedWords = cf.getLanguageSpecificWordForKey(tobeConverted, language);
		String selectCustomer = convertedWords.get(0);
		String pleaseSelectCustomer = convertedWords.get(1);
		String SLNO = convertedWords.get(2);
		String noRecordsFound = convertedWords.get(3);
		String error = convertedWords.get(4);
		String SelectSingleRow = convertedWords.get(5);
		String TC_Number = convertedWords.get(6);
		String Month_Year = convertedWords.get(7);
		String Mine_Code = convertedWords.get(8);
		String Submit = convertedWords.get(9);
        String Employment_Report = convertedWords.get(10);
		String SelectMineral = convertedWords.get(11);
		String SelectLabour = convertedWords.get(12);
		String SelectWorkplace = convertedWords.get(13);
		String Male = convertedWords.get(14);
		String Female = convertedWords.get(15);
		String Wages = convertedWords.get(16);
		String SelectDate = convertedWords.get(17);

		int systemId = loginInfo.getSystemId();
		int userId = loginInfo.getUserId();
		int customerId = loginInfo.getCustomerId();
		String userAuthority = cf.getUserAuthority(systemId, userId);
		if (customerId > 0 && loginInfo.getIsLtsp() == -1 && !userAuthority.equalsIgnoreCase("Admin")) {
			response.sendRedirect(request.getContextPath()
					+ "/Jsps/Common/401Error.html");
		}
%>

<jsp:include page="../Common/header.jsp" />

		<title><%=Employment_Report%></title>

		</style>
	
		<%
			if (loginInfo.getStyleSheetOverride().equals("Y")) {
		%>
		<jsp:include page="../Common/ImportJSSandMining.jsp" />
		<%
			} else {
		%>
		<jsp:include page="../Common/ImportJS.jsp" />
		<%
			}
		%>
		<jsp:include page="../Common/ExportJS.jsp" />

		<style>			
			.x-window-tl *.x-window-header {
				padding-top : 6px !important;
			}
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
		</style>

		<script>
        var dtcur = datecur;
		var grid;
		var outerPanel;
	 	var jspName='<%=Employment_Report%>';
    	var exportDataType = "int,string,string,int,int,float";
    	var monthNames = ["January", "February", "March", "April", "May", "June",
              "July", "August", "September", "October", "November", "December"];
 
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
            if ( <%=customerId%> > 0) {            
                Ext.getCmp('custcomboId').setValue('<%=customerId%>');
                
               mineralStore.load();
               labourStore.load();
               workplaceStore.load();
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
              mineralStore.load();
              labourStore.load();
              workplaceStore.load();
            }
        }
    }
	});
	
	//******************************store for Mineral**********************************
	var mineralStore = new Ext.data.SimpleStore({
     id: 'mineralsComboStoreId',
	      fields: ['Name', 'Value'],
	      autoLoad: false,
	      data: [
	          ['Iron Ore', 'Iron Ore'],
	          ['Bauxite/Laterite', 'Bauxite/Laterite'],
			  ['Manganese', 'Manganese']
	      ]
 });

//****************************combo for Mineral****************************************
 var mineralCombo = new Ext.form.ComboBox({
     store: mineralStore,
     id: 'mineralcomboId',
     mode: 'local',
     forceSelection: true,
     emptyText: '<%=SelectMineral%>',
     resizable: true,
     selectOnFocus: true,
     allowBlank: false,
     anyMatch: true,
     typeAhead: false,
     triggerAction: 'all',
     lazyRender: true,
     valueField:'Value',
 	 displayField:'Name',
 	 cls: 'selectstylePerfect',
     listeners: {
         select: {
             fn: function () {
                 }
             }
         }
     
 });
		//******************************store for Labour**********************************
	var labourStore =new Ext.data.SimpleStore({
     id: 'labourTypeId',
     fields: ['Name', 'Value'],
	      autoLoad: false,
	      data: [
	          ['Direct', 'Direct'],
			  ['Contract', 'Contract']
	      ]

 });

//****************************combo for Labour****************************************
 var labourCombo = new Ext.form.ComboBox({
     store: labourStore,
     id: 'labourcomboId',
     mode: 'local',
     forceSelection: true,
     emptyText: '<%=SelectLabour%>',
     resizable: true,
     selectOnFocus: true,
     allowBlank: false,
     anyMatch: true,
     typeAhead: false,
     triggerAction: 'all',
     lazyRender: true,
     valueField: 'Value',
     displayField: 'Name',
     cls: 'selectstylePerfect',
     listeners: {
         select: {
             fn: function () {
                
                 }
             }
         }
     
 });
		//******************************store for Workplace**********************************
	var workplaceStore = new Ext.data.SimpleStore({
     id: 'workplaceTypeId',
     fields: ['Name', 'Value'],
	      autoLoad: false,
	      data: [
	          ['Below Ground', 'Below Ground'],
	          ['Open-cast', 'Open-cast'],
			  ['Above Ground', 'Above Ground']
	      ]

 });

//****************************combo for Workplace****************************************
 var workplaceCombo = new Ext.form.ComboBox({
     store: workplaceStore,
     id: 'workplacecomboId',
     mode: 'local',
     forceSelection: true,
     emptyText: '<%=SelectWorkplace%>',
     resizable: true,
     selectOnFocus: true,
     allowBlank: false,
     anyMatch: true,
     typeAhead: false,
     triggerAction: 'all',
     lazyRender: true,
     valueField: 'Value',
     displayField: 'Name',
     cls: 'selectstylePerfect',
     listeners: {
         select: {
             fn: function () {
                 }
             }
         }
     });
   	// **********************************************Reader configs Starts******************************
    
     var reader = new Ext.data.JsonReader({
        idProperty: 'tripcreationId',
    	root: 'employmentReportRoot',
    	totalProperty: 'total',
    	fields: [{
        name: 'slnoIndex'
    	},{
        name: 'MineCodeDataIndex'
    	},{
        name: 'TcNumberDataIndex'
    	},{
        name: 'MaleDataIndex'
    	},{
        name: 'FemaleDataIndex'
    	},{
        name: 'WagesDataIndex'
    	}]
    });
    
    // **********************************************Reader configs Ends******************************
    //********************************************Store Configs For Grid*************************

    var store = new Ext.data.GroupingStore({
        autoLoad: false,
        proxy: new Ext.data.HttpProxy({
           url: '<%=request.getContextPath()%>/MonthlyReturnsReportsAction.do?param=getEmploymentDetails',
            method: 'POST'
        }),
        remoteSort: false,
        storeId: 'EmploymentStore',
        reader: reader
        });
        
    //********************************************************************Filter Config***************
       
    	var filters = new Ext.ux.grid.GridFilters({
        local: true,
    	filters: [{
        type: 'numeric',
        dataIndex: 'slnoIndex'
    	},{
    	type: 'string',
        dataIndex: 'MineCodeDataIndex'
    	},{
    	type: 'string',
        dataIndex: 'TcNumberDataIndex'
    	},{
    	type: 'numeric',
        dataIndex: 'MaleDataIndex'
    	},
    	{
    	type: 'numeric',
        dataIndex: 'FemaleDataIndex'
    	},{
    	type: 'string',
        dataIndex: 'WagesDataIndex'
    	}]
    	});
  
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
        	header: "<span style=font-weight:bold;><%=Mine_Code%></span>",
        	dataIndex: 'MineCodeDataIndex',
        	width:150,
        	filter: {
            type: 'string'
        	}
    		},{
        	header: "<span style=font-weight:bold;><%=TC_Number%></span>",
        	dataIndex: 'TcNumberDataIndex',
        	width:150,
        	
        	filter: {
            type: 'string'
            
        	}
    		}, {
    		header: "<span style=font-weight:bold;><%=Male%></span>",
    		dataIndex: 'MaleDataIndex',
    		width:150,
    		sortable: true,		
    		filter: {
    		type: 'numeric'
    		}
    		},{
    		header: "<span style=font-weight:bold;><%=Female%></span>",
    		dataIndex: 'FemaleDataIndex',
    		width:150,
    		sortable: true,		
    		filter: {
    		type: 'numeric'
    		}
    		},{
    		header: "<span style=font-weight:bold;><%=Wages%></span>",
    		dataIndex: 'WagesDataIndex',
    		width:150,
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
    //******************************************Creating Grid By Passing Parameter***********************
    
     grid = getGrid('<%=Employment_Report%>', '<%=noRecordsFound%>', store,screen.width-30,420, 8, filters, 'Clear Filter Data', false, '', 20, false, '', false, '', true, 'Excel', jspName, exportDataType, false, 'PDF', false, 'Add', false, 'Modify', false, '', false , '',false,'');
     		
	//**********************************End Of Creating Grid By Passing Parameter*************************

	   
   var customerPanel = new Ext.Panel({
   standardSubmit: true,
   collapsible: false,
   id: 'customerComboPanelId',
   layout: 'table',
   frame: false,
   width: screen.width - 12,
   height: 80,
   layoutConfig: {
       columns: 12
   },
   items: [{
           xtype: 'label',
           text: '<%=selectCustomer%>' + ' :',
           cls: 'labelstyle'
       },{
       width: 10
      },
       custnamecombo,{
       width: '170px'
      },{
			xtype: 'label',
			cls:'labelstyle',
			id:'datelab',
			text: '<%=SelectDate%>' + ' :',
			},{
       width: 10
      },{
			xtype: 'datefield',
			format:getMonthYearFormat(),  	
			plugins: 'monthPickerPlugin',	        
			id: 'DateId',  		        
			value: dtcur,  		     
			vtype: 'daterange',
			cls: 'selectstylePerfect'
			},{
       width: '150px'
      },{
           xtype: 'label',
           text: '<%=SelectMineral%>' + ' :',
           cls: 'labelstyle'
       },{
       width: '20px'
      },
       mineralCombo,{
       width: 50
      },{
           xtype: 'label',
           text: '<%=SelectLabour%>' + ' :',
           cls: 'labelstyle'
       },{
       width: '50px'
      },
       labourCombo,{
       width: 50
      },{
           xtype: 'label',
           text: '<%=SelectWorkplace%>' + ' :',
           cls: 'labelstyle'
       },{
       width: '50px'
      },
       workplaceCombo,{
       width: 50
      },
       {
            xtype: 'button',
            text: 'Submit',
            id: 'submitId',
            cls: 'buttonstyle',
            width: 70,
            listeners: {
               click: {
                  fn: function() {
            if (Ext.getCmp('custcomboId').getValue() == "") {
		    	Ext.example.msg("<%=pleaseSelectCustomer%>");
		    	Ext.getCmp('custcomboId').focus();
		        return;
           }
		   if(Ext.getCmp('DateId').getValue() == ""){
		   		Ext.example.msg("Month/Year");
		        Ext.getCmp('DateId').focus();
		        return;
		   	}
         if (Ext.getCmp('mineralcomboId').getValue() == "") {
             Ext.example.msg("<%=SelectMineral%>");
             Ext.getCmp('mineralcomboId').focus();
             return;
         }
         if (Ext.getCmp('labourcomboId').getValue() == "") {
             Ext.example.msg("<%=SelectLabour%>");
             Ext.getCmp('labourcomboId').focus();
             return;
         }
           if (Ext.getCmp('workplacecomboId').getValue() == "") {
             Ext.example.msg("<%=SelectWorkplace%>");
             Ext.getCmp('workplacecomboId').focus();
             return;
         }
         var date=Ext.getCmp('DateId').getValue();
         var year=date.getFullYear();
         store.load({
         params:{
         custId:Ext.getCmp('custcomboId').getValue(),
         jspName:jspName,
         workPlace:Ext.getCmp('workplacecomboId').getValue(),
         labour:Ext.getCmp('labourcomboId').getValue(),
         month:monthNames[date.getMonth()],
         year:year,
         mineralName:Ext.getCmp('mineralcomboId').getValue(),
         custName:Ext.getCmp('custcomboId').getRawValue()
               }
             });
           } 
         }
       }
     }
   ]
});	
				
    function getMonthYearFormat(){
		return 'F Y';
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
<%
	}
%>
