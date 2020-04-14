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
	tobeConverted.add("Customer_Name");
	tobeConverted.add("Select_Customer");
	tobeConverted.add("Group_Name");
	tobeConverted.add("Select_Group");
	tobeConverted.add("Generate_Report");
	tobeConverted.add("Stoppage_Location_Report");
	
	ArrayList<String> convertedWords = new ArrayList<String>();
	convertedWords = cf.getLanguageSpecificWordForKey(tobeConverted,language);
	String customerName=convertedWords.get(0); 
	String selectCustomer=convertedWords.get(1); 
	String groupName = convertedWords.get(2);
	String selectGroup = convertedWords.get(3);
	String generateReport = convertedWords.get(4);
	String stoppageLocation = convertedWords.get(5);
%>

<jsp:include page="../Common/header.jsp" />
 		<title>Stoppage Location Report</title>
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
	            		groupNameStore.load({
		            		params:{
		            			custId:custId
		            		}
	            		});	
		                
		            }
		        }
		    }
	});
	
	var client = new Ext.form.ComboBox({
	    store: clientcombostore,
	    id: 'custcomboId',
	    mode: 'local',
	    forceSelection: true,
	    emptyText: '<%=selectCustomer%>',
	    blankText: '<%=selectCustomer%>',
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
	            		groupNameStore.load({
		            		params:{
		            			custId:custId
		            		}
	            		});	                 
	            }
	        }
	    }
	});
	
	var groupNameStore= new Ext.data.JsonStore({
    	url:'<%=request.getContextPath()%>/PowerConnectionReportAction.do?param=getGroupNames',
    	id: 'groupStoreId',
    	root: 'GroupStoreList',
    	autoLoad: false,
    	fields : ['groupId','groupName']
    });
    var filters2 = new Ext.ux.grid.GridFilters({
		local : true,
		filters:[{
			dataIndex: 'groupName',
			type: 'string'
		}]
	});
    var groupSelect = new Ext.grid.CheckboxSelectionModel();
	var groupGrid = new Ext.grid.GridPanel({
    id: 'groupGridId',
    //width: 350,
    store: groupNameStore,
    columns: [
        groupSelect, {
            header: '<%=selectGroup%>',
            hidden: false,
            sortable: true,
            dataIndex: 'groupName',
            width: 205,
            id: 'selectAllGroupId',
            columns: [{
                xtype: 'checkcolumn',
                dataIndex: 'groupName'
            }]
        },{
	        header:'Group Id',
	        hidden:true,
	        dataIndex:'groupId'
        }],
    sm: groupSelect,
    plugins: filters2,
    stripeRows: true,
    border: true,
    frame: false,
    width: 165,
    height: 145,
    style: 'margin-left:5px;',
    cls: 'bskExtStyle'
});
	
	/************************************************************ Panels ********************************************************************/                   
    var innerPanel1 = new Ext.Panel({
        standardSubmit: true,
        collapsible: false,
        id: 'innerPanel1Id',
        layout: 'table',
        layoutConfig: { columns: 4 }, 
        frame: false,
        width: 590,
        height: 40,
        items: [{width:90},{xtype: 'label',
		        text: '<%=customerName%>' + ' :',
		        cls: 'labelstyle'
		    	   },{width:20}, client]
     });
          
     var innerPanel2 = new Ext.Panel({
         standardSubmit: true,
         collapsible: false,
         id: 'innerPanel2Id',
         layout: 'table',
         layoutConfig: { columns: 4 }, 
         frame: false,
         width: 590,
         height: 200,
         items: [{width:90},{xtype: 'label',
		        text: '<%=groupName%>' + ' :',
		        cls: 'labelstyle'
		    	   },{width:40}, groupGrid]
     });
                    
     var buttonPanel = new Ext.Panel({
         standardSubmit: true,
         collapsible: false,
         id: 'buttonPanelId',
         layout: 'table',
         layoutConfig: { columns: 2 }, 
         frame: false,
         width: '100%',
         height: 70,
         items: [{width: 240 },
         	   {xtype: 'button',
               text: '<%=generateReport%>',
               iconCls : 'excelbutton',
               cls: 'buttonstyle',
               listeners: {
                         click: {
                           fn: function() {
                               if (Ext.getCmp('custcomboId').getValue() == "") {
                                   Ext.example.msg("<%=selectCustomer%>");
                                   Ext.getCmp('custcomboId').focus();
                                   return;
                               }
                               //innerPanel.getEl().mask();
                               //innerPanel.getEl().unmask();
                               
                    var groupSelect;
                    selectedGroup = "-";
                    
                    var recordGroup = groupGrid.getSelectionModel().getSelections();
                     
                    for (var i = 0; i < recordGroup.length; i++) {
                        var recordEach = recordGroup[i];
                        var groupName = recordEach.data['groupName'];
                        var groupId=recordEach.data['groupId'];
                        if(selectedGroup == "-"){
                        selectedGroup = groupId;
                        }else{
                        selectedGroup = selectedGroup + "," + groupId
                        }
                    }
                     if (selectedGroup == '' || selectedGroup == '0' || selectedGroup == '-') {
                        Ext.example.msg("<%=selectGroup%>");
                        return;
                    }
                    var custId=Ext.getCmp('custcomboId').getValue();
                    var custName=Ext.getCmp('custcomboId').getRawValue();
                    window.open("<%=request.getContextPath()%>/stoppageLocationExcel?custId=" + custId + "&custName=" + custName + "&selectedGroup=" + selectedGroup);
                    
                           }//function
                         }
               }
         }]
     });
	
	var innerPanel = new Ext.Panel({
        title: '<%=stoppageLocation%>',
        standardSubmit: true,
        collapsible: false,
        id: 'innerPanelId',
        layout: 'table',
        layoutConfig: { columns: 1 }, 
        frame: true,
        width: 610,
        height: 360,
        items: [innerPanel1,innerPanel2,buttonPanel]
    });

    var mainPanel = new Ext.Panel({
        standardSubmit: true,
        collapsible: false,
        id: 'mainPanelId',
        layout: 'table',
        frame: false,
        width: '100%',
        height: 480,
        layoutConfig: { columns: 2 },
        items: [{width: 350},innerPanel]
    });
    

    Ext.onReady(function() {
    	ctsb = tsb;
        Ext.QuickTips.init();
        Ext.form.Field.prototype.msgTarget = 'side';
        outerPanel = new Ext.Panel({
            title: '',
            renderTo: 'content',
            standardSubmit: true,
            frame: true,
            width: screen.width - 38,
            height: 540,
            layout: 'table',
            layoutConfig: { columns: 1 },
            items: [mainPanel]
        });
        sb = Ext.getCmp('form-statusbar');
        groupGrid.setSize(250,200);
  });

</script>
 <jsp:include page="../Common/footer.jsp" />
 <!-- </body>   -->
 <!-- </html> -->
 