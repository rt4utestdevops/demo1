<%@ page language="java" import="java.util.*,java.text.SimpleDateFormat,t4u.functions.*,t4u.beans.*,t4u.common.*" pageEncoding="utf-8"%>
<%@ taglib uri="http://packtag.sf.net" prefix="pack" %>
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
String responseaftersubmit="''";
if(session.getAttribute("responseaftersubmit")!=null){
   	responseaftersubmit="'"+session.getAttribute("responseaftersubmit").toString()+"'";
	session.setAttribute("responseaftersubmit",null);
}		
LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
String language = loginInfo.getLanguage();
int systemId = loginInfo.getSystemId();
int customerId = loginInfo.getCustomerId();
int userId = loginInfo.getUserId();
String userAuthority=cf.getUserAuthority(systemId,userId);
int custId=0;
String custName="";
String type = "";
boolean approvebutton = false;
boolean rejectbutton = false;
boolean modifyButton = false;
if(request.getParameter("custId") != null && !request.getParameter("custId").equals("")){
	custId = Integer.parseInt(request.getParameter("custId")); 
}
if(request.getParameter("custName") != null && !request.getParameter("custName").equals("")){
	custName = request.getParameter("custName");
}
if(request.getParameter("type") != null && !request.getParameter("type").equals("")){
	type = request.getParameter("type");
	if(type.equalsIgnoreCase("totalforms")){
		approvebutton = false;
		rejectbutton = false;
    }else if(type.equalsIgnoreCase("pending")&& userAuthority.equalsIgnoreCase("Admin")){
    	approvebutton = true;
		rejectbutton = true;
    }else if(type.equalsIgnoreCase("approved") && userAuthority.equalsIgnoreCase("Admin")){
    	approvebutton = false;
		rejectbutton = true;
    }else if(type.equalsIgnoreCase("rejected")){
       if(userAuthority.equalsIgnoreCase("Supervisor")){
        	modifyButton=true;
       }
    	approvebutton = false;
		rejectbutton = false;
    }
}
%>
<!DOCTYPE HTML>
<html>
  <head>
    <base href="<%=basePath%>">
    
    <title>MonthlyReturn</title>
    
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">

  </head>
  
  <body>
     <%if (loginInfo.getStyleSheetOverride().equals("Y")){%>
	<jsp:include page="../Common/ImportJSSandMining.jsp"/>
	<%}else{%>
	<jsp:include page="../Common/ImportJS.jsp" />
   	<%}%>
   	<jsp:include page="../Common/ExportJS.jsp" />
   	<script>
   	var jspName = "Monthly_Returns_Dashboard_Details";
	var exportDataType = "int,string,string,string,string,string,string,string,string,string,string,string,int,string";
	var userAuthority = '<%=userAuthority%>' ;
	var dateprev = new Date().add(Date.DAY, -14); //15 days  ago date
	var datenext = new Date().add(Date.DAY, 1);   //next day date
	var loadMask = new Ext.LoadMask(Ext.getBody(), { msg: "Redirecting To Form" });
	var dtcur = datecur;
 	var custId = '<%=custId%>';
 	var custName = '<%=custName%>';
 	var type = '<%=type%>';
//****************************************************************************Reader Filter & Column**************************************************************************		
	var reader = new Ext.data.JsonReader({
      idProperty: 'monthlyReturnFormDetailsRootId',
      root: 'monthlyReturnFormDetailsRoot',
      totalProperty: 'total',
      fields: [{
          		name: 'SNOIndex'
      		 },{
          		name: 'IDIndex'
      		 },{
          		name: 'returnFormIdIndex'
      		 },{
          		name: 'monthAppliedIndex'
      		 },{
          		name: 'RegIndex'
      		 },{
          		name: 'mineralsIndex'
      		 },{
          		name: 'minesIndex'
      		 },{
          		name: 'tcNoIndex'
      		 },{
          		name: 'ownerIndex'
      		 },{
      		 	name: 'desgnationIndex'
      		 },{
      		 	name: 'statusIndex'
      		 },{
      		 	name: 'remarksIndex'
      		 },{
      		 	name: 'approvedRejectedByIndex'
      		 },{
      		 	name: 'approvedRejectedDTIndex'
      		 }]
    });
    var filters = new Ext.ux.grid.GridFilters({
        local: true,
        filters: [{
			        type: 'int',
			        dataIndex: 'SNOIndex'
			    },{
		            type: 'int',
		            dataIndex: 'IDIndex',		            
        		 },{
		            type: 'string',
		            dataIndex: 'returnFormIdIndex',		            
        		 },{
		            type: 'string',
		            dataIndex: 'monthAppliedIndex',		            
        		 },{
		            type: 'string',
		            dataIndex: 'RegIndex',		            
        		 },{
		            type: 'string',
		            dataIndex: 'mineralsIndex',		            
        		 },{
		            type: 'string',
		            dataIndex: 'minesIndex',		            
        		 },{
	          		type: 'string',
	          		dataIndex: 'tcNoIndex'
	      		 },{
	          		type: 'string',
	          		dataIndex: 'ownerIndex'
	      		 },{
	          		type: 'string',
	          		dataIndex: 'desgnationIndex'
	      		 },{
	          		type: 'string',
	          		dataIndex: 'statusIndex'
	      		 },{
	          		type: 'string',
	          		dataIndex: 'remarksIndex'
	      		 },{
	          		type: 'int',
	          		dataIndex: 'approvedRejectedByIndex'
	      		 },{
	          		type: 'string',
	          		dataIndex: 'approvedRejectedDTIndex'
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
				dataIndex: 'SNOIndex'
	        },{
		        header: "<span style=font-weight:bold;>Monthly Form Details Id</span>",
		        sortable: true,
		        hidden: true,
		        dataIndex: 'IDIndex'
		    },{
		        header: "<span style=font-weight:bold;>Return Form Id</span>",
		        sortable: true,
		        hidden: false,
		        dataIndex: 'returnFormIdIndex'
		    },{
		        header: "<span style=font-weight:bold;>Month Applied</span>",
		        sortable: true,
		        hidden: false,
		        dataIndex: 'monthAppliedIndex'
		    },{
		        header: "<span style=font-weight:bold;>IBM Reg. No</span>",
		        sortable: true,
		        dataIndex: 'RegIndex'
		    },{
		        header: "<span style=font-weight:bold;>Minerals Name</span>",
		        sortable: true,
		        dataIndex: 'mineralsIndex'
		    },{
		        header: "<span style=font-weight:bold;>Mining Name</span>",
		        sortable: false,
		        dataIndex: 'minesIndex'
		    },{
		        header: "<span style=font-weight:bold;>TC Number</span>",
		        sortable: false,
		        hidden: false,
		        dataIndex: 'tcNoIndex'
		    },{
		        header: "<span style=font-weight:bold;>Owner</span>",
		        sortable: false,
		        dataIndex: 'ownerIndex'
		    },{
		        header: "<span style=font-weight:bold;>Designation</span>",
		        sortable: false,
		        hidden:true,
		        dataIndex: 'desgnationIndex'
		    },{
		        header: "<span style=font-weight:bold;>Status</span>",
		        sortable: false,
		        hidden:false,
		        dataIndex: 'statusIndex'
		    },{
		        header: "<span style=font-weight:bold;>Remarks</span>",
		        sortable: false,
		        hidden:false,
		        dataIndex: 'remarksIndex'
		    },{
		        header: "<span style=font-weight:bold;>Approved Or Rejected By</span>",
		        sortable: false,
		        hidden: true,
		        dataIndex: 'approvedRejectedByIndex'
		    },{
		        header: "<span style=font-weight:bold;>Approved Or Rejected Date Time</span>",
		        sortable: false,
		        hidden: true,
		        dataIndex: 'approvedRejectedDTIndex'
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
            url: '<%=request.getContextPath()%>/MonthlyReturnsAction.do?param=getMonthlyReturnsDashboardDetails',
           method: 'POST'
       }),
       reader: reader
    });
//****************************************************************************Grid Store**************************************************************************
    grid = getGrid('','No Record Found',store,screen.width - 40,380,20,filters,'clearFilterData',false,'',9,false,'',false,'',true,'Excel',jspName,exportDataType,false,'PDF',false,'Add',<%=modifyButton%>,'Modify',false,'',false,'',true,'View Form',<%=approvebutton%>,'Approve',false,'',<%=rejectbutton%>,'Reject');
/****************************************************************************Ext onReady Outer panel window**************************************************************************/
	var innerPanel = new Ext.form.FormPanel({
		standardSubmit: true,	
		autoScroll:true,
		frame:true,
		height:100,
		width:442,
		id:'remarkspanelId',
		layout:'table',
		layoutConfig: {columns:3},
		items:[{
            	xtype:'label',
            	text:'*',
            	cls:'mandatoryfield',
            	id:'mandatoryremarks'
            	},{
				xtype: 'label',
				cls:'labelstyle',
				id:'remarkslab',
				text: 'Remarks :'
				},{
				xtype:'textarea',
	    		cls:'selectstylePerfect',
	    		emptyText:'Enter Remarks',	    			    		
	    		blankText :'Enter Remarks',
	    		allowBlank: false,
	    		id:'remarksId'	    		
	    		}]
	    });
//****************************************************************************Button for Inner panel form field**************************************************************************    
	var winButtonPanel=new Ext.Panel({
       	id: 'winbuttonid',
       	standardSubmit: true,			
		cls:'windowbuttonpanel',
		frame:true,
		height:20,
		width:440,
		layout:'table',
		layoutConfig: {
			columns:2
		},
		buttons:[{
      		xtype:'button',
     		text:'save',
       		id:'addButtId',
       		iconCls:'savebutton',
       		cls:'buttonstyle',
       		width:80,
      		listeners: {
      			click:{
     				fn:function(){
     				if(buttonValue=='Reject'){
     					if (Ext.getCmp('remarksId').getValue() == "") {
                        Ext.example.msg("Enter Remarks");
                        Ext.getCmp('remarksId').focus();
                        return;
                    	}       
                    	} 
                    	var selected = grid.getSelectionModel().getSelected();
                        var id = selected.get('IDIndex');           
                       Ext.Ajax.request({
                            url: '<%=request.getContextPath()%>/MonthlyReturnsAction.do?param=saveRemarks',
                            method: 'POST',
                            params: {
                            	buttonValue:buttonValue,
                            	remarks : Ext.getCmp('remarksId').getValue(),
                            	id:id
                            },
                            success: function (response, options) {
                                var message = response.responseText;
                                Ext.example.msg(message);
                                Ext.getCmp('remarksId').reset(),
                                myWin.hide();
                                store.reload();
                               },
                            failure: function () {
                                Ext.example.msg("Error");		                                
                                myWin.hide();
                                store.reload();
                            }
                       	});
                    }
     			}
     		}
     		},{
      			xtype:'button',
     			text:'cancel',
        		id:'cancelButtId',
        		iconCls:'cancelbutton',
        		cls:'buttonstyle',
        		width:80,
       			listeners: 
       			{
        			click:
        			{
       					fn:function()
       					{
       						myWin.hide();
       					}
       				}
       			}
      		}]
	});
/****************************************************************************Outer panel window for form field**************************************************************************/
	var outerPanelWindow=new Ext.Panel({
		cls:'outerpanelwindow',
		standardSubmit: true,
		frame:false,
		items: [innerPanel, winButtonPanel]
	});
/****************************************************************************Window For Add and Edit**************************************************************************/
	myWin = new Ext.Window({
	    title: 'titelForInnerPanel',
	    closable: false,
	    resizable: false,
	    modal: true,
	    autoScroll: true,
	    frame:true,
	    height:210,
	    width:450,
	    id: 'myWin',
	    items: [outerPanelWindow]
	});
	function modifyData(){	  
		buttonValue = 'Modify';
		var selectedRecord = grid.getSelectionModel().getSelected();
		if (grid.getSelectionModel().getCount() == 0) {
	        Ext.example.msg("No Row Selected");
	        return;
	     }
	    if (grid.getSelectionModel().getCount() > 1) {
	        Ext.example.msg("Select Single Row");
	        return;
	    } 
		var autoGeneratedId = store.getAt(grid.getStore().indexOf(selectedRecord)).data['IDIndex'];
		var reloadPrevRec = 'reloadPrevRec';
	    var loadForDashboardDetails = 'loadForDashboardDetails';
		var MonthlyReturnsFormOnePartOne='/Telematics4uApp/Jsps/IronMining/MonthlyReturnsFormOnePartOne.jsp?custId='+custId+'&custName='+custName+'&reloadPrevRec='+reloadPrevRec+'&autoGeneratedKeys='+autoGeneratedId+'&loadForDashboardDetails='+loadForDashboardDetails+'&type='+type;
		parent.Ext.getCmp('partOneTab').enable();
		parent.Ext.getCmp('monthlyReturnsDashboardDetailsTab').disable();
		parent.Ext.getCmp('partOneTab').show();
		parent.Ext.getCmp('partOneTab').update("<iframe style='width:100%;height:525px;border:0;' src='"+MonthlyReturnsFormOnePartOne+"'></iframe>");
	}
	function verifyFunction(){
		var selectedRecord = grid.getSelectionModel().getSelected();
		var designation = store.getAt(grid.getStore().indexOf(selectedRecord)).data['desgnationIndex'];
		var autoGeneratedId=store.getAt(grid.getStore().indexOf(selectedRecord)).data['IDIndex'];
		if (grid.getSelectionModel().getCount() == 0) {
	        Ext.example.msg("No Row Selected");
	        return;
	     }
	    if (grid.getSelectionModel().getCount() > 1) {
	        Ext.example.msg("Select Single Row");
	        return;
	    }
		if(designation != null && designation != ""){
			window.open("<%=request.getContextPath()%>/PDFForMining?autoGeneratedKeys="+autoGeneratedId);
		}else{
			Ext.example.msg("PDF Cannot be generated");
	        return;
		}
	}
	function approveFunction(){
	  buttonValue = 'Approve';
	  titelForInnerPanel = 'Approve';
	  Ext.getCmp('mandatoryremarks').hide();
	  myWin.setPosition(460,100);	    	   
	  myWin.setTitle(titelForInnerPanel);	
	  myWin.show();
	}
	function postponeFunction(){
	  buttonValue = 'Reject';
	  titelForInnerPanel = 'Reject';
	  Ext.getCmp('mandatoryremarks').show();
	  myWin.setPosition(460,100);	    	   
	  myWin.setTitle(titelForInnerPanel);	
	  myWin.show();
	}
	var buttonPanel=new Ext.FormPanel({
       	id: 'buttonid',
       	cls:'colorid',
       	frame:true,
           buttons:[{
              		text: 'Back',
              		cls:'colorid',
              		iconCls:'backbutton',
              		id:'backbuttonId',
              		handler : function(){
              			var load = "1";
	              		//window.location = "<%=request.getContextPath()%>/Jsps/IronMining/MonthlyReturnsDashboard.jsp?custId="+custId+"&custName="+custName+"&load="+load;
	              		var MonthlyReturn='/Telematics4uApp/Jsps/IronMining/MonthlyReturn.jsp?custId='+custId+'&custName='+custName+'&load='+load;
	              		parent.Ext.getCmp('monthlyReturnsDashboardDetailsTab').disable();
	              		parent.Ext.getCmp('monthlyReturnsDashboardTab').enable();
	              		parent.Ext.getCmp('monthlyReturnsDashboardTab').show();
              		}
              }]
	    });
		Ext.onReady(function () {
		    Ext.QuickTips.init();
		    Ext.form.Field.prototype.msgTarget = 'side';
		    outerPanel = new Ext.Panel({
		        title: 'Authorise Monthly Returns',		        
		        standardSubmit: true,
		        frame: false,
		        width: screen.width-22,
		        height:520,
		        renderTo: 'content',
		        cls: 'outerpanel',
		        layout: 'table',
		        layoutConfig: {
		            columns: 1
		        },
		        items: [grid,buttonPanel]
		    });
		  store.load({params:{jspName:jspName,userAuthority:userAuthority,custId:custId,type:'<%=type%>'}});
		});		
   	</script>
  </body>
</html>
