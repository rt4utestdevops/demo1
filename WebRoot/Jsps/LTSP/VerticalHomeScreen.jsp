 <%@ page language="java" import="java.util.*,t4u.beans.LoginInfoBean,t4u.functions.*" pageEncoding="utf-8"%>
<%@ taglib uri="http://packtag.sf.net" prefix="pack" %>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://"+ request.getServerName() + ":" + request.getServerPort()+ path + "/";
	CommonFunctions cf=new CommonFunctions();
	LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
	int systemId = loginInfo.getSystemId();
	int customerId=loginInfo.getCustomerId();
	int userId=loginInfo.getUserId();
	int offset=loginInfo.getOffsetMinutes();
	String newMenuStyle="";
    newMenuStyle=loginInfo.getNewMenuStyle();
	String language=loginInfo.getLanguage();
	String alertDiv="";
	String alertID="";
	String verticals="";
	String verticalCompnt="";
	LTSPFunctions ltspfunc=new LTSPFunctions(); 
	HashMap<String,String> verticalComponents=ltspfunc.getLTSPVerticals(systemId,language);
	String curtProcessId = verticalComponents.get("processId");
	if(verticalComponents.get("verticalComponents") != null){
		verticalCompnt = verticalComponents.get("verticalComponents");
	}	
	String existingVertical=cf.getLabelFromDB("Existing_Vertical",language).toUpperCase();
	String totalVehicles=cf.getLabelFromDB("Total_Vehicles",language);
	String communicating=cf.getLabelFromDB("Communicating",language);
	String nonCommunicating=cf.getLabelFromDB("Non_Communicating",language);
	String launch=cf.getLabelFromDB("Launch",language);
	String customerName=cf.getLabelFromDB("Customer_Name",language);
	String totalAssets=cf.getLabelFromDB("Total_Assets",language);
	String noGPS = cf.getLabelFromDB("No_GPS",language);
	String comm =cf.getLabelFromDB("Comm",language);
	String nonComm = cf.getLabelFromDB("Non_Comm",language);
	String dashboard=cf.getLabelFromDB("Generic_Dashboard",language).toUpperCase();

%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html class="no-js" lang="en">
	<head>
		<meta charset="UTF-8" />
		<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
		<title>Verticals</title>
		<link rel="stylesheet" type="text/css" href="../../Main/modules/LTSP/css/component.css" />
		<pack:script src="../../Main/adapter/ext/ext-base.js"></pack:script>
		<pack:script src="../../Main/Js/ext-all-debug.js"></pack:script>
		<pack:script src="../../Main/Js/jquery.min.js"></pack:script>
		<pack:script src="../../Main/resources/ux/gridfilters/menu/RangeMenu.js"></pack:script>
		<pack:script src="../../Main/resources/ux/gridfilters/menu/ListMenu.js"></pack:script>
		<pack:script src="../../Main/resources/ux/gridfilters/GridFilters.js"></pack:script>
		<pack:script src="../../Main/resources/ux/gridfilters/filter/Filter.js"></pack:script>
		<pack:script src="../../Main/resources/ux/gridfilters/filter/StringFilter.js"></pack:script>
		<pack:script src="../../Main/resources/ux/gridfilters/filter/DateFilter.js"></pack:script>
		<pack:script src="../../Main/resources/ux/gridfilters/filter/ListFilter.js"></pack:script>
		<pack:script src="../../Main/resources/ux/gridfilters/filter/NumericFilter.js"></pack:script>
		<pack:script src="../../Main/resources/ux/gridfilters/filter/BooleanFilter.js"></pack:script>
		<pack:style src="../../Main/resources/ux/gridfilters/css/GridFilters.css" />
		<pack:style src="../../Main/resources/ux/gridfilters/css/RangeMenu.css" />
		<pack:style src="../../Main/resources/css/ext-all.css" />
		<pack:style src="../../Main/resources/css/chooser.css" />
		<link rel="stylesheet" type="text/css" href="../../Main/modules/LTSP/theme/css/EXTJSExtn.css" />
		<link rel="stylesheet" type="text/css" href = "https://code.jquery.com/ui/1.11.4/themes/smoothness/jquery-ui.css" />
		<script src="../../Main/Js/jquery.js"></script>
        <script src="../../Main/Js/jquery-ui.js"></script> 
	</head>
	<style>
	.x-form-text,.x-form-textarea,.x-combo-list{
	 direction: ltr;
}
	</style>
	<body onload = "refresh();searchCustomerName();" oncontextmenu="return false;">	
	<script type="text/javascript">
	var listOfcustomerName = [];
	
	Ext.Ajax.timeout = 360000;
	if('<%=language%>'=='ar'){
	document.documentElement.setAttribute("dir", "rtl");
	}else if('<%=language%>'=='en'){
	document.documentElement.setAttribute("dir", "ltr");
	}
	var currentVertical=<%=curtProcessId%>; 
	var currentProcess;
	var verticalName;
	var count;
	var outerPanel;
	var totalAssetCount = 0;
	var totalCommCount = 0;
	var totalNonCommCount = 0;
	var totalNoGPSCount = 0;
	var systemId = <%=systemId%>;
	var newMenuStyle= "<%=newMenuStyle%>";
	function getVerticalDetails(processId,processName,index)
	{	
		verticalName=processName;		
		if(currentProcess == processId){
		}
		else
		{
		document.getElementById("verticalimg"+currentVertical).src='/ApplicationImages/ApplicationButtonIcons/icon_plus.png';
	    document.getElementById("verticalimg"+index).src='/ApplicationImages/ApplicationButtonIcons/icon_minus.png';
		$("#vertical"+currentVertical+"-desc").slideToggle();
		$("#vertical"+index+"-desc").slideToggle();
		currentVertical=index;
		currentProcess=processId;
		store.load({
		params:{
				processId:processId
			   }
		});
		}
		
	}
	function getVerticalDetailsNew(processId,index)
	{	
		if(currentProcess == processId){
		}
		else
		{
		document.getElementById("verticalimg"+currentVertical).src='/ApplicationImages/ApplicationButtonIcons/icon_plus.png';
	    document.getElementById("verticalimg"+index).src='/ApplicationImages/ApplicationButtonIcons/icon_minus.png';
		$("#vertical"+currentVertical+"-desc").slideToggle();
		$("#vertical"+index+"-desc").slideToggle();
		currentVertical=index;
		currentProcess=processId;		
		}		
	}
	//***************************** Client Details Grid***********************************************************	    
	 var reader = new Ext.data.JsonReader({
        idProperty: 'darreaderid',
        root: 'ClientList',
        totalProperty: 'total',
        fields: [{
            		type: 'string',
            		name: 'customername'
        		 },
        		 {
            		type: 'int',
            		name: 'totalno'
        		 },
        		 {
            		type: 'int',
            		name: 'comm'
        		 },
        		 {
            		type: 'int',
            		name: 'noncomm'
        		 },
        		 {
        		   type: 'int',
        		   name:'customerid'
        		 },{
        		   type: 'int',
        		   name:'processId'
        		 }         
        	  ]
    });
    
    var filters = new Ext.ux.grid.GridFilters({
        local: true,
        filters: [{
            dataIndex: 'customername',
            type: 'string'
        }]
    });

    var store = new Ext.data.GroupingStore({
        autoLoad: false,
        proxy: new Ext.data.HttpProxy({
            url: '<%=request.getContextPath()%>/LTSPAction.do?param=getClientList',
            method: 'POST'
        }),
        reader: reader
    });
    
     var totalAssetsCount = new Ext.data.JsonStore({
        autoLoad: false,
        url: '<%=request.getContextPath()%>/LTSPAction.do?param=getCommNonCommunicatingVehicles',
        id:'dashboardElementsCountId',
		root: 'DashBoardElementCountRoot',		
		remoteSort: true,
		fields: ['totalAssetCount','commCount','nonCommCount','noGpsCount']
        
    });
     var customerstore = new Ext.data.JsonStore({
    	url: '<%=request.getContextPath()%>/LTSPAction.do?param=getCustomerNames',
    	id: 'customernames',
		root: 'customernames',
		autoLoad: false,
		remoteSort: true,
		fields: ['customername']
    });
    function getDashboardElementsCount(){   
			totalAssetsCount.load({
				callback: function(){
						
					 if(totalAssetsCount.getCount()>0) {
              		 	var rec = totalAssetsCount.getAt(0); 
              		 	totalAssetCount = rec.data['totalAssetCount'];
						totalCommCount = rec.data['commCount'];
						totalNonCommCount = rec.data['nonCommCount'];
						totalNoGPSCount = rec.data['noGpsCount'];            		 	
              			document.getElementById('totalasset').innerHTML = rec.data['totalAssetCount'];
              			document.getElementById('commdivid').innerHTML = rec.data['commCount'];
              			document.getElementById('noncommdivid').innerHTML = rec.data['nonCommCount'];
              			document.getElementById('nogpsdivid').innerHTML = rec.data['noGpsCount'];              			
					}
				}
			});	
			
			}
    

    //************************************Column Model Config******************************************
     var colModel = new Ext.grid.ColumnModel({
     	defaults: {
    				sortable: true,
    				menuDisabled: true
  		},
    	columns: [   	
    	{
        header: '<%= customerName%>',
        sortable: true,
        dataIndex: 'customername',
        width:130,
        draggable:false
    	},
    	{
        header: '<%= totalVehicles %>',
        sortable: true,
        dataIndex: 'totalno',
        width:80
    	},
    	{
        header: '<%= communicating%>',
        sortable: true,
        dataIndex: 'comm',
        width:80
    	},
    	{
        header: '<%= nonCommunicating%>',
        sortable: true,
        dataIndex: 'noncomm',
        width:80
    	},{
		xtype: 'actioncolumn',
		width: 50,
		items: [{
        icon   : '/ApplicationImages/ApplicationButtonIcons/Launch.png', 
        tooltip: '<%= launch%>',
        handler: function(grid, rowIndex, colIndex) {
        	   var customerId=grid.getStore().getAt(rowIndex).data['customerid'];
        	   var totalVehicles=grid.getStore().getAt(rowIndex).data['totalno'];    	          
                parent.window.location="/jsps/LTSPScreen.jsp?CustomerId="+customerId+"&processId="+currentProcess+"&id="+totalVehicles+"&newMenuStyle="+newMenuStyle;
        }
       	}]
		}	
    	]
		});

    var selModel=new Ext.grid.RowSelectionModel({
      singleSelect:true
	});
         
   
    var grid = new Ext.grid.EditorGridPanel({                         
     bodyCssClass: 'verticalhomescreengrid',   
     layout		: 'fit',
     viewConfig	: {forceFit: true},
     store      : store,                                                                     
     colModel   : colModel,                                       
     loadMask	: true,
     border		: false,
     sm			: selModel,
     enableColumnMove : false, 
	 plugins	: [filters]    
	});


	
	setTimeout(function(){grid.render('client-grid-details');},500);
	
	var processId;
	function searchCustomerName(){
 		customerstore.load({
   			callback:function(){
   				for(var i=0; i<customerstore.getCount(); i++){
					var rec = customerstore.getAt(i);
					listOfcustomerName.push(rec.data['customername']);
				}
				$( "#search-input" ).autocomplete({
					source: listOfcustomerName,
			      	select: function(event, ui) {
			      		var val = ui.item.value;						
				 		if(val!="") {			 			
				 			searchCustomer(val);				 			
				 			$('#search-input').keyup(function(){
				 				if (!this.value) {
				 					store.load({		
											params:{
												processId:currentProcess
											}
									});
								}
				 			});
				 		}
	            	}
			    });
			}
		});
	}
	
	function searchCustomer(custName){
		store.load({				
			params:{
				customername:custName
			},
			callback:function(){
			if(store.getCount()>0){
				var record = store.getAt(0); 
				processId = record.data['processId'];
				getVerticalDetailsNew(processId,processId);
				}			
			}			
		});		
	}
	
	 function showDetails(processId,en,count)
	 { 	
	verticalName=verticalName.replace(/ /g,"");
	var value= count % 4;	
	 var myWin = new Ext.Window({			       
			        closable: true,
			        modal: true,
			        resizable:true,
			        closeAction:'close',
			        autoScroll: true,
			        height: 520,
        			width: '68%',	
			        id     : 'myWin',
			        items  : [
								{xtype: 'panel',
								 id:'panelId',
								 height:470,
								 html : "<iframe width ='99%' height='470px' src='/Telematics4uApp/Jsps/LTSP/ReadMoreWindow.jsp?value="+value+"&processId="+currentProcess+"'></iframe>"
								}
					]
			    });
			    
     myWin.show();	
     }
	
	   var TOTAL_ASSET = new Ext.Panel({
		standardSubmit: true,
		frame:false,
		border:false,		
		collapsible:false,		
		cls:'dashboardinnerpanelAssetsCashVanPannel',
		bodyStyle: 'background: white',
		id:'ctbid',
		layout:'column',		
		layoutConfig: {
			columns:3
		},
		items:[	{
				xtype: 'panel',
				text:'',
				width:'46%',
				allowBlank: false,
				border:false,
				hidden:false,
				cls:'assetIconlabel',
				id:'alertfootersaid'
				},		
				{
				xtype:'panel',
				id:'statucountdetalspannel',
				frame:false,
				border:false,
				width:'46%',
				cls:'dashboardCashVanHeaderLabelStyle',
				items:[
				{
				xtype: 'label',
				html: '<div class="dashBoarderHearderDiv" id="totalasset">0</div>',
				width:'100%',
				border:true,
				bodyStyle: 'background-color: green',
				id:'alertdetailsctbid1',
				},
				{
				xtype: 'label',
				html: '<div class="dashBoarderHearderCountDiv" id="totalAssetHeader"><%=totalAssets%></div>',
				width:'100%',
				border:true,
				id:'alertlbldetailssaid1'
				}]},
				{
				xtype:'panel',
				id:'totaldetailsbuttonpannel',
				cls:'totalDeatilsNav',
				height:115,
				width:'8%',
				frame:false,
				border:false,
				items:[
				{
				html: '<div class="totalDeatilsNavimage" id="totaldetailsnav" onclick="gotoVisibilityWindow(\'all\');"></div>',
				xtype:'panel',
				height:115,
				bodyStyle: 'background:#9ED43E',
				border:false
				}]}]
		}); // End of Panel	
		
		
/*****************************Panel for NO GPS******************************************************/
var NO_GPS = new Ext.Panel({
		standardSubmit: true,
		frame:false,
		border:false,				
		collapsible:false,
		cls:'dashboardinnerpanelAssetsCashVanPannel',
		bodyStyle: 'background: white',
		id:'nogpspanelid',
		layout:'column',		
		layoutConfig: {
			columns:3
		},
		items:[	{
				xtype: 'panel',
				text:'',
				width:'46%',
				allowBlank: false,
				border:false,
				hidden:false,
				cls:'noGPSiconlabel',
				id:'noGPSiconId',
				},		
				{
				xtype:'panel',
				id:'NOGPScountcetailspannel',
				frame:false,
				border:false,
				width:'46%',
				cls:'dashboardCashVanHeaderLabelStyle',
				items:[
				{
				xtype: 'label',
				html: '<div class="noGPSHearderLabelDiv" id="nogpsdivid">0</div>',
				width:'100%',
				border:true,
				bodyStyle: 'background-color: green',
				id:'noGPSdetailsid',
				},
				{
				xtype: 'label',
				html: '<div class="noGPSCountDiv" id="noGPSHeader"><%=noGPS%></div>',
				width:'100%',
				border:true,
				}]},
				{
				xtype:'panel',
				id:'nogpsdetailsbuttonpannel',
				cls:'nogpsDeatilsNav',
				height:115,
				width:'8%',
				frame:false,
				border:false,
				items:[
				{
				html: '<div class="nogpsDeatilsNavimage" id="nogpsdetailsnav" onclick="gotoVisibilityWindow(\'noGPS\');"></div>',
				xtype:'panel',
				height:115,
				bodyStyle: 'background:#1DDEB2',
				border:false
				}]}]
		}); // End of Panel		
		
/*****************************Panel for COMMUNICATING******************************************************/
var COMMUNICATING = new Ext.Panel({
		standardSubmit: true,
		frame:false,
		border:false,		
		collapsible:false,
		cls:'dashboardinnerpanelAssetsCashVanPannel',
		bodyStyle: 'background: white',
		id:'commpanelid',
		layout:'column',		
		layoutConfig: {
			columns:3
		},
		items:[	{
				xtype: 'panel',
				text:'',
				width:'46%',
				allowBlank: false,
				border:false,
				hidden:false,
				cls:'commiconlabel',
				id:'commiconId'
				},		
				{
				xtype:'panel',
				id:'Commcountcetailspannel',
				frame:false,
				border:false,
				width:'46%',
				cls:'dashboardCashVanHeaderLabelStyle',
				items:[
				{
				xtype: 'label',
				html: '<div class="commHearderLabelDiv" id="commdivid">0</div>',
				width:'100%',
				border:true,
				bodyStyle: 'background-color: green'
				},
				{
				xtype: 'label',
				html: '<div class="commCountDiv" id="commHeader"><%=comm%></div>',
				width:'100%',
				border:true
				}]},
				{
				xtype:'panel',
				id:'commdetailsbuttonpannel',
				cls:'commDeatilsNav',
				height:115,
				width:'8%',
				frame:false,
				border:false,
				items:[
				{
				html: '<div class="commDeatilsNavimage" id="commdetailsnav" onclick="gotoVisibilityWindow(\'comm\');"></div>',
				xtype:'panel',
				height:115,
				bodyStyle: 'background:#F6CC2A',
				border:false
				}]}]
		}); // End of Panel	
		
/*****************************Panel for NON-COMMUNICATING******************************************************/
var NONCOMMUNICATING = new Ext.Panel({
		standardSubmit: true,
		frame:false,		
		border:false,		
		collapsible:false,
		cls:'dashboardinnerpanelAssetsCashVanPannel',
		bodyStyle: 'background: white',
		id:'noncommpanelid',
		layout:'column',		
		layoutConfig: {
			columns:3
		},
		items:[	{
				xtype: 'panel',
				text:'',
				width:'46%',
				allowBlank: false,
				border:false,
				hidden:false,
				id:'noncommiconId',
				cls:'noncommiconlabel' 
				},		
				{
				xtype:'panel',
				id:'noncommcountcetailspannel',
				frame:false,
				border:false,
				width:'46%',
				cls:'dashboardCashVanHeaderLabelStyle',
				items:[
				{
				xtype: 'label',
				html: '<div class="noncommHearderLabelDiv" id="noncommdivid">0</div>',
				width:'100%',
				border:true,
				bodyStyle: 'background-color: green'
				},
				{
				xtype: 'label',
				html: '<div class="noncommCountDiv" id="noncommHeader"><%=nonComm%></div>',
				width:'100%',
				border:true
				}]},
				{
				xtype:'panel',
				id:'noncommdetailsbuttonpannel',
				cls:'noncommDeatilsNav',
				height:115,
				width:'8%',
				frame:false,
				border:false,
				items:[
				{
				html: '<div class="noncommDeatilsNavimage" id="noncommdetailsnav" onclick="gotoVisibilityWindow(\'noncomm\');"></div>',
				xtype:'panel',
				height:115,
				bodyStyle: 'background:#E1915C',
				border:false
				}]}]
		}); // End of Panel		
	
	var innerSecondMainPannel=new Ext.Panel({
	standardSubmit: true,
	frame:false,
	height:200,
	border:false,
	//width:'98%',
	//bodyStyle:{'margin': '1%'},
	id:'innersecondmainpannel',
		layout:'column',
		layoutConfig: {
			columns:4
		},
	items: [TOTAL_ASSET,COMMUNICATING,NONCOMMUNICATING,NO_GPS]
	});
	
	
	var innerMainPannel=new Ext.Panel({
	standardSubmit: true,
	frame:false,
	border:false,
	width:'100%',
	id:'innermainpannel',
//cls:'innermainPannelCashVan',
	items: [innerSecondMainPannel]
	});
	
	
	
	
	function refresh(){
	setInterval('getDashboardElementsCount()',60000);
	 outerPanel = new Ext.Panel({
			renderTo : 'content',
			standardSubmit: true,
			height:134,
			border:false,
			cls:'outerpanel',
			//bodyCfg : { cls:'outerpanel' ,style: {'background':'#fff','padding-top':'1%'} },
			items: [innerMainPannel]	
			});
			getDashboardElementsCount();
	}
	
	function gotoVisibilityWindow(type){
		if(totalAssetCount > 4000 && systemId == 261){
			window.location ="<%=request.getContextPath()%>/Jsps/Common/LiveVisionWithTableData.jsp?vehicleType="+type+"&reqType=dashboard";
		}else if(totalCommCount > 4000 && systemId == 261){
			window.location ="<%=request.getContextPath()%>/Jsps/Common/LiveVisionWithTableData.jsp?vehicleType="+type+"&reqType=dashboard";
		}else if(totalNonCommCount > 4000 && systemId == 261){
			window.location ="<%=request.getContextPath()%>/Jsps/Common/LiveVisionWithTableData.jsp?vehicleType="+type+"&reqType=dashboard";
		}else if(totalNoGPSCount > 4000 && systemId == 261){
			window.location ="<%=request.getContextPath()%>/Jsps/Common/LiveVisionWithTableData.jsp?vehicleType="+type+"&reqType=dashboard";
		}else{
			window.location ="<%=request.getContextPath()%>/Jsps/Common/ListView.jsp?vehicleType="+type+"&reqType=dashboard";
		}
	}
	
	
	
	
//**************************** Below overidden functions will eliminates grid alignment issues(Note:Use these functions only if required)******************	
	if (!Ext.isDefined(Ext.webKitVersion)) {
    Ext.webKitVersion = Ext.isWebKit ? parseFloat(/AppleWebKit\/([\d.]+)/.exec(navigator.userAgent)[1], 10) : NaN;
}
/*
 * Box-sizing was changed beginning with Chrome v19.  For background information, see:
 * http://code.google.com/p/chromium/issues/detail?id=124816
 * https://bugs.webkit.org/show_bug.cgi?id=78412
 * https://bugs.webkit.org/show_bug.cgi?id=87536
 * http://www.sencha.com/forum/showthread.php?198124-Grids-are-rendered-differently-in-upcoming-versions-of-Google-Chrome&p=824367
 *
 * */
if (Ext.isWebKit && Ext.webKitVersion >= 535.2) { // probably not the exact version, but the issues started appearing in chromium 19
    Ext.override(Ext.grid.ColumnModel, {
        getTotalWidth: function (includeHidden) {
            if (!this.totalWidth) {
                var boxsizeadj = 2;
                this.totalWidth = 0;
                for (var i = 0, len = this.config.length; i < len; i++) {
                    if (includeHidden || !this.isHidden(i)) {
                        this.totalWidth += (this.getColumnWidth(i) + boxsizeadj);
                    }
                }
            }
            return this.totalWidth;
        }
    });

    Ext.onReady(function() {
        Ext.get(document.body).addClass('ext-chrome-fixes');
        Ext.util.CSS.createStyleSheet('@media screen and (-webkit-min-device-pixel-ratio:0) {.x-grid3-cell{box-sizing: border-box !important;}}', 'chrome-fixes-box-sizing');
        document.onkeydown = function(e) {
	      if (event.keyCode == 123) {
	          return false;
	      }
	      if (e.ctrlKey && e.shiftKey && e.keyCode == 'I'.charCodeAt(0)) {
	          return false;
	      }
	      if (e.ctrlKey && e.shiftKey && e.keyCode == 'J'.charCodeAt(0)) {
	          return false;
	      }
	      if (e.ctrlKey && e.keyCode == 'U'.charCodeAt(0)) {
	          return false;
	      }
	    }
    });
}

	 </script>
	<div class="container">
	<div class="header" id="header">	
			<h1>
				<span><%=dashboard%></span>
			</h1>			
	</div>
	<div id="content"></div>
	<div class="header" id="header">	
			<h1>
				<span><%=existingVertical%></span>
			</h1>			
	</div>
	<div class="main-pannel" id="main-pannel">
		<div class="veritcal-panel" id="vertical-panel">
		<div class="vertical-details" id="vertical-details">
			<%=verticalCompnt%>
		</div>				
		<div class="client-details" id="client-details">
		<div class="vehicle-details" id="vehicle-details">
<!--		<span class="asset-details">Total Assets:</span><span class="asset-count">1000</span>-->
<!--		<span class="asset-details">Communicating:</span><span class="asset-count">1000</span>-->
<!--		<span class="asset-details">Non Communicating:</span><span class="asset-count">1000</span>-->
<!--		<span class="asset-details">No GPS:</span><span class="asset-count">1000</span>-->
		<input type="text" name="search" id="search-input" placeholder="Customer Name" class="search" />
		</div>
		<div class="client-grid-details" id="client-grid-details"></div>
		</div>
		</div>
		</div>
</div>
</body>
</html>