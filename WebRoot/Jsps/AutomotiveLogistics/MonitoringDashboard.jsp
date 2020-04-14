<%@ page language="java"
	import="java.util.*,java.text.SimpleDateFormat,t4u.functions.*,t4u.beans.*,t4u.common.*"
	pageEncoding="utf-8"%>
<%@ taglib uri="http://packtag.sf.net" prefix="pack"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
String language = loginInfo.getLanguage();
int  systemId = loginInfo.getSystemId();
String fromdateformonitoringpage="";
String todateformonitoringpage ="";
String typeformonitoringpage="";
String fromlocationformonitoringpage="";
String fromlocationIdformonitoringpage="";
String tolocationformonitoringpage="";
String tolocationIdformonitoringpage="";
String checkDashBoardDetails="";
String shipmentStatus ="";
if(request.getParameter("fromdateformonitoringpage") != null && request.getParameter("todateformonitoringpage") !=null){
	String fromdatemonitoring = request.getParameter("fromdateformonitoringpage");
if(fromdatemonitoring.contains("+0530")){
	fromdateformonitoringpage = fromdatemonitoring.replace("+0530 ", " ");
}else{
	fromdateformonitoringpage = fromdatemonitoring.replace(" 0530 ", " ");
}
String todatemonitoring=request.getParameter("todateformonitoringpage");
if(todatemonitoring.contains("+0530")){
	todateformonitoringpage = todatemonitoring.replace("+0530 ", " ");
}else{
	todateformonitoringpage = todatemonitoring.replace(" 0530 ", " ");
}
typeformonitoringpage=request.getParameter("typeformonitoringpage");
fromlocationformonitoringpage=request.getParameter("fromlocationformonitoringpage");
fromlocationIdformonitoringpage=request.getParameter("fromlocationIdformonitoringpage");
tolocationformonitoringpage=request.getParameter("tolocationformonitoringpage");
tolocationIdformonitoringpage=request.getParameter("tolocationIdformonitoringpage");
checkDashBoardDetails=request.getParameter("checkDashBoardDetails");
shipmentStatus = request.getParameter("shipmentStatus");
}
CommonFunctions cf = new CommonFunctions();
ArrayList<String> tobeConverted = new ArrayList<String>();
tobeConverted.add("From_Date");
tobeConverted.add("To_Date");
tobeConverted.add("Type");
tobeConverted.add("From_Location");
tobeConverted.add("To_Location");
tobeConverted.add("View");
tobeConverted.add("On_Time");
tobeConverted.add("Delayed");
tobeConverted.add("Delayed_Address");
tobeConverted.add("Before_Time");
tobeConverted.add("Excel");
tobeConverted.add("OverSpeed");
tobeConverted.add("Vehicle_Stoppage");

ArrayList<String> convertedWords = new ArrayList<String>();
convertedWords = cf.getLanguageSpecificWordForKey(tobeConverted,language);

String FromDate = convertedWords.get(0);
String ToDate = convertedWords.get(1);
String Type = convertedWords.get(2);
String FromLocation = convertedWords.get(3);
String ToLocation =  convertedWords.get(4);
String View = convertedWords.get(5);
String OnTime = convertedWords.get(6);
String Delayed = convertedWords.get(7);
String DelayedAddress = convertedWords.get(8);
String BeforeTime = convertedWords.get(9);
String Excel= convertedWords.get(10);
String MonitoringDashboardNew="Monitoring Dashboard New";
String OverSpeed=  convertedWords.get(11);
String Stoppage=  convertedWords.get(12);


%>

<jsp:include page="../Common/header.jsp" />
		<title>Monitoring Dashboard New</title>
		<meta charset="utf-8">
		<meta name="viewport" content="width=device-width, initial-scale=1">

		<link rel="stylesheet"
			href="../../Main/modules/automotiveLogistics/dashBoard/css/inline.css"
			type="text/css"></link>
		<link rel="stylesheet"
			href="../../Main/modules/automotiveLogistics/dashBoard/css/layout.css"
			type="text/css"></link>
		<link rel="stylesheet" type="text/css"
			href="../../Main/modules/LTSP/theme/css/EXTJSExtn.css" />

		<pack:style src="../../Main/resources/css/ext-all.css" />
		<pack:style
			src="../../Main/resources/ux/gridfilters/css/GridFilters.css" />
		<pack:style
			src="../../Main/resources/ux/gridfilters/css/RangeMenu.css" />

		<pack:script src="../../Main/adapter/ext/ext-base.js"></pack:script>
		<pack:script src="../../Main/Js/ext-all-debug.js"></pack:script>

		<pack:script
			src="../../Main/resources/ux/gridfilters/menu/RangeMenu.js"></pack:script>
		<pack:script
			src="../../Main/resources/ux/gridfilters/menu/ListMenu.js"></pack:script>
		<pack:script src="../../Main/resources/ux/gridfilters/GridFilters.js"></pack:script>
		<pack:script
			src="../../Main/resources/ux/gridfilters/filter/Filter.js"></pack:script>
		<pack:script
			src="../../Main/resources/ux/gridfilters/filter/StringFilter.js"></pack:script>
		<pack:script
			src="../../Main/resources/ux/gridfilters/filter/DateFilter.js"></pack:script>
		<pack:script
			src="../../Main/resources/ux/gridfilters/filter/ListFilter.js"></pack:script>
		<pack:script
			src="../../Main/resources/ux/gridfilters/filter/NumericFilter.js"></pack:script>
		<pack:script
			src="../../Main/resources/ux/gridfilters/filter/BooleanFilter.js"></pack:script>

		<pack:style src="../../Main/resources/css/xtheme-DeepBlue.css" />
		<pack:script src="../../Main/Js/jquery.min.js"></pack:script>
		<pack:script src="../../Main/Js/Common.js"></pack:script>
		<pack:style src="../../Main/resources/css/dashboard.css" />
		<pack:style src="../../Main/iconCls/icons.css" />

		<pack:script src="../../Main/Js/examples1.js"></pack:script>
		<pack:style src="../../Main/resources/css/examples1.css" />
		<pack:style src="../../Main/src/util/Date.js" />
		<style>
.excelbutton {
	width: 55%;
	height: 45%;
	background-image:
		url(/ApplicationImages/ApplicationButtonIcons/Excel.png) !important;
	background-repeat: no-repeat
}

.clearfilterbutton {
	width: 65%;
	height: 55%;
	background-image:
		url(/ApplicationImages/ApplicationButtonIcons/Filter.png) !important;
	background-repeat: no-repeat
}
.footer {
	overflow : hidden !important;
	height : 20px !important;
}
.ext-strict .x-form-text {
    height: 21px !important;
}
label {
			display : inline !important;
		}
		.dashBoarderHearderDiv {
			height : 76px !important;
		}
		.delayedHearderLabelDiv{
			 height : 76px !important;
		 }
		 .beforetimeHearderLabelDiv {
			 height : 76px !important;
		 }
		 .delayedaddressHearderLabelDiv {
			 height : 76px !important;
		 }
		 .overTimeHeaderLabelDiv {
			 height : 76px !important;
		 }
		 .overTimeHeaderLabelDiv1 {
			 height : 76px !important;
		 }
		 #fromDateId {
			margin-left : 25px !important; 
		 }
		 .x-form-text .x-form-field .labelstyle {
			 margin-left : 25px !important;
		 }
		 #toDateId {
			margin-left : 40px !important;  
		 }
		 #ComboId {
			margin-left : 24px !important;   
		 }
		 #fromLocationcomboId {
			margin-left : 5px !important; 
		 }
		 #toLocationcomboId {
			margin-left : 41px !important;  
		 }
		 #tolocationlab {
			margin-left : 136px !important;  
		 }
		 .x-window-tl *.x-window-header {
			padding-top : 6px !important;
		}
		#viewlab {
			top : 105px !important;
		}
		.container {
   
    padding-right: 0px !important;
    padding-left: 0px !important;
}
.x-btn-text-icon .x-btn-icon-small-left .x-btn-text {
	//padding-left: 0px !important;
}

span#footSpan {
	margin-right : 22px !important;
}
.x-layer ul {
		 	min-height:27px !important;
		}
</style>
		
		<div class="container">
			<div class="header" id="header">
				<h1>
					<span>DASHBOARD</span>
				</h1>
			</div>
			<div class="datelocationpanel" id="datelocationpanel"></div>
			<div class="dashboardpanel" id="dashboardpanel"></div>
			<div class="gridpanel" id="gridpanel"></div>
		</div>
		<jsp:include page="../Common/ExportJS.jsp" />

		<script>
  	var dtcur = datecur;
  	var dtprev = dateprev;
  	var checkDashBoardDetails='<%=checkDashBoardDetails%>';
  	var prevfromlocId;
	var prevtolocId;
	var jspName = "MonitoringDashboardNew";
	var exportDataType = "int,string,string,string";
	var overspeedcount=0;
	var stoppagecount=0;
	var type;
	window.onload = function () { 
		loadPreviousRecords();
	}
	function gotoAlertReport(alertId,alertName)
		{
		var record = "";
		var fieldName = "";
		var data = "";
		var fromdatefordetailspage = Ext.getCmp('fromDateId').getValue();
		var todatefordetailspage = Ext.getCmp('toDateId').getValue();
		var typefordetailspage = Ext.getCmp('ComboId').getValue();
		var fromlocationfordetailspage = Ext.getCmp('fromLocationcomboId').getRawValue();		
		var tolocationfordetailspage = Ext.getCmp('toLocationcomboId').getRawValue();
		var fromlocationIdfordetailspage;
		var tolocationIdfordetailspage;
		if(checkDashBoardDetails != '1'){
			fromlocationIdfordetailspage = Ext.getCmp('fromLocationcomboId').getValue();
			tolocationIdfordetailspage = Ext.getCmp('toLocationcomboId').getValue();
		}else{
			fromlocationIdfordetailspage = '<%=fromlocationIdformonitoringpage%>';
			tolocationIdfordetailspage = '<%=tolocationIdformonitoringpage%>';
		}
		 type=Ext.getCmp('ComboId').getValue();
	            	   if(type=='In Transit' || type=='All') {
	            	   if((stoppagecount > 0 && alertId == 1) || ( overspeedcount > 0 && alertId == 2)){
		window.location ="<%=request.getContextPath()%>/Jsps/AutomotiveLogistics/AlertReport.jsp?AlertId="+alertId+"&AlertName="+alertName+"&data="+data+"&fromdatefordetailspage="+fromdatefordetailspage+"&todatefordetailspage="+todatefordetailspage+"&typefordetailspage="+typefordetailspage+"&fromlocationfordetailspage="+fromlocationfordetailspage+"&fromlocationIdfordetailspage="+fromlocationIdfordetailspage+"&tolocationfordetailspage="+tolocationfordetailspage+"&tolocationIdfordetailspage="+tolocationIdfordetailspage;
		}
		}
		} 
			       
  	var ComboStore = new Ext.data.SimpleStore({
	      id: 'ComboStoreId',
	      fields: ['Name', 'Value'],
	      autoLoad: true,
	      data: [
	          ['In Transit', 'In Transit'],
	          ['Delivered', 'Delivered'],
			  ['All','All']
	      ]
	  });
	  var combo = new Ext.form.ComboBox({
	      frame: true,
	      store: ComboStore,
	      id: 'ComboId',
	      width: 150,
	      cls: 'selectstylePerfect',
	      hidden: false,
	      allowBlank: false,
	      anyMatch: true,
	      onTypeAhead: true,
	      forceSelection: true,
	      enableKeyEvents: true,
	      mode: 'local',
	      emptyText: '',
	      triggerAction: 'all',
	      displayField: 'Name',
	      value: 'In Transit',
	      valueField: 'Value',
	      listeners: {
	          select: {
	              fn: function() {
	                 dashboardCountstore.removeAll();
	                 document.getElementById('ontimeId').innerHTML =0;
					 document.getElementById('delayeddivId').innerHTML=0;
					 document.getElementById('delayedaddressdivId').innerHTML=0;
					 document.getElementById('beforetimedivId').innerHTML=0;
					 document.getElementById('overspeedid').innerHTML=0;
					 document.getElementById('stoppageid').innerHTML=0;
					 overspeedcount=0;
	                 stoppagecount=0;
					 store.load();
					 
	              }
	          }
	      }
	  });
  	var datePanel = new Ext.Panel({
		standardSubmit: true,
	    id: 'datePanelId',
	    layout: 'table',
	    frame: false,
	    border:false,
	    height:50,
	    layout: 'table',
	    cls:'dashboardcustomerinnerpannel',
		bodyCfg : { cls:'dashboardcustomerinnerpannel' , style: {'background-color': 'transparent'} },
	    layoutConfig: {
	        columns: 10
	    },
	    items: [{
	            xtype: 'label',
	            cls:'labelstyle',
	            style:'display:block; margin-left:30px;color: rgb(255, 255, 255);',
	            id:'fromDatelab',
	            width:100,
	            text: '<%=FromDate%> :'       
	            },{
				xtype: 'datefield',
				format:getDateFormat(),  		        
  		        id: 'fromDateId',  		        
  		        value: dtprev,
  		        width:150,
  		        cls:'labelstyle',
	    		vtype: 'daterange',
	    		listeners : {
		            'change' : function(field, newValue, oldValue) {
		               	document.getElementById('ontimeId').innerHTML =0;
					 	document.getElementById('delayeddivId').innerHTML=0;
					 	document.getElementById('delayedaddressdivId').innerHTML=0;
					 	document.getElementById('beforetimedivId').innerHTML=0;
					 	 document.getElementById('overspeedid').innerHTML=0;
					 document.getElementById('stoppageid').innerHTML=0;
					 overspeedcount=0;
	                 stoppagecount=0;
		            }
		        }
				},{
	            xtype: 'label',
	            cls:'labelstyle',
	            style:'display:block; margin-left:185px;color: rgb(255, 255, 255);',
	            id:'toDatelab',
	            width:100,
	            text: '<%=ToDate%> :'        
	            },{
				xtype: 'datefield',
				format:getDateFormat(),  		        
  		        id: 'toDateId',  		        
  		        value: dtcur,
  		        cls:'labelstyle',
  		        width:150,
	    		vtype: 'daterange',
	    		listeners : {
		            'change' : function(field, newValue, oldValue) {
		               	document.getElementById('ontimeId').innerHTML =0;
					 	document.getElementById('delayeddivId').innerHTML=0;
					 	document.getElementById('delayedaddressdivId').innerHTML=0;
					 	document.getElementById('beforetimedivId').innerHTML=0;
					 	 document.getElementById('overspeedid').innerHTML=0;
					 document.getElementById('stoppageid').innerHTML=0;
					 overspeedcount=0;
	                 stoppagecount=0;
		            }
		        }
				},{
	            xtype: 'label',
	            cls:'labelstyle',
	            style:'display:block; margin-left:185px;color: rgb(255, 255, 255);',
	            id:'comblab',
	            width:85,
	            text: '<%=Type%> :'        
	            },combo]
		});
/**************************************************Store*************************************************************/
	var locationcombostore = new Ext.data.JsonStore({
		url: '<%=request.getContextPath()%>/MonitoringDashboardAction.do?param=getSourceDestination',
		id: 'locationStoreId',
		root: 'locationRoot',
		autoLoad: false,
		fields: ['Hub_Id','Hub_Name'],
		listeners:{
				load: function (custstore, records, success, options) {								
               			if(checkDashBoardDetails != '1'){
	            			Ext.getCmp('fromLocationcomboId').setValue(0);	
	            			Ext.getCmp('toLocationcomboId').setValue(0);
	            		} else {
	            			var prevfromloc = '<%=fromlocationformonitoringpage%>';
	 						var prevtoloc = '<%=tolocationformonitoringpage%>';
	            			Ext.getCmp('fromLocationcomboId').setValue(prevfromloc);
	 						Ext.getCmp('toLocationcomboId').setValue(prevtoloc);
	            		}		                   
	          		}
		        }
	});
	
  	var fromLocationcombo=new Ext.form.ComboBox({
        store: locationcombostore,
        id:'fromLocationcomboId',
        mode: 'local',
        hidden:false,
        forceSelection: true,
        emptyText:'Select From Location',
        blankText :'Select From Location',
        selectOnFocus:true,
        allowBlank: false,
        onTypeAhead:true,
        anyMatch:true,
        enableKeyEvents:true,
        triggerAction: 'all',
        lazyRender: true,
    	valueField: 'Hub_Id',
    	displayField: 'Hub_Name',
    	cls:'dashboardinlinestylecombo',
    	listeners: {
	                   select: {
	                 	   fn:function(){
	                 	   		dashboardCountstore.removeAll();
	                 	   		document.getElementById('ontimeId').innerHTML =0;
								document.getElementById('delayeddivId').innerHTML=0;
								document.getElementById('delayedaddressdivId').innerHTML=0;
								document.getElementById('beforetimedivId').innerHTML=0;
								 document.getElementById('overspeedid').innerHTML=0;
					 			document.getElementById('stoppageid').innerHTML=0;
								 overspeedcount=0;
	                			 stoppagecount=0;
								store.load();
	                 	   }
	                 	}
	                 	   
                }   
    });
	var toLocationcombo=new Ext.form.ComboBox({
        store: locationcombostore,
        id:'toLocationcomboId',
        mode: 'local',
        hidden:false,
        forceSelection: true,        
        emptyText:'Select To Location',
        blankText :'Select To Location',
        selectOnFocus:true,
        allowBlank: false,
        onTypeAhead:true,
        anyMatch:true,
        enableKeyEvents:true,
        triggerAction: 'all',
        lazyRender: true,
    	valueField: 'Hub_Id',
    	displayField: 'Hub_Name',
    	cls:'dashboardinlinestylecombo',
    	listeners: {
	                   select: {
	                 	   fn:function(){
	                 	   		dashboardCountstore.removeAll();
	                 	   		document.getElementById('ontimeId').innerHTML =0;
								document.getElementById('delayeddivId').innerHTML=0;
								document.getElementById('delayedaddressdivId').innerHTML=0;
								document.getElementById('beforetimedivId').innerHTML=0;
								document.getElementById('overspeedid').innerHTML=0;
					            document.getElementById('stoppageid').innerHTML=0;
					            overspeedcount=0;
	                            stoppagecount=0;
	                 	   		store.load();	                 	   		
	                 	   }
	                   }                 	   
                }   
    });
/*************************************************Stores***************************************************************/ 
	var dashboardCountstore = new Ext.data.JsonStore({
		    url: '<%=request.getContextPath()%>/MonitoringDashboardAction.do?param=getDashboardCount',
		    id: 'dashboardCountId',
		    root: 'dashboardCountRoot',
		    autoLoad: false,
		    remoteSort: true,
		    fields: ['totalcountIndex','tripstatusIndex']	
	});
	
	var dashboardCountStoppage = new Ext.data.JsonStore({
		    url: '<%=request.getContextPath()%>/MonitoringDashboardAction.do?param=getDashboardStoppageCount',
		    id: 'dashboardCountOverspeedId',
		    root: 'dashboardCountStoppage',
		    autoLoad: false,
		    remoteSort: true,
		    fields: ['stoppagecountIndex']	
	});
	 
	
	var dashboardCountOverSpeed = new Ext.data.JsonStore({
		    url: '<%=request.getContextPath()%>/MonitoringDashboardAction.do?param=getDashboardOverspeedCount',
		    id: 'dashboardCountStoppageId',
		    root: 'dashboardCountOverSpeed',
		    autoLoad: false,
		    remoteSort: true,
		    fields: ['overspeedcountIndex']	 
	});
/*************************************************End Stores***************************************************************/
	var locationPanel = new Ext.Panel({
		standardSubmit: true,
	    id: 'locationPanelId',
	    layout: 'table', 
	    cls:'dashboardcustomerinnerpannel',
		bodyCfg : { cls:'dashboardcustomerinnerpannel' , style: {'background-color': 'transparent'} },
	    frame: false,	
	    border:false,
	    layoutConfig: {
	        columns: 8
	    },
	    items: [{
	            xtype: 'label',
	            cls: 'labelstyle',
	            id:'fromLocationlab',
	            cls:'labelstyle',
	            width:100,
	            style:'display:block; margin-left:30px;color: rgb(255, 255, 255);',
	            text: '<%=FromLocation%> :'       
	            },fromLocationcombo,{
	            xtype: 'label',
	            cls: 'labelstyle',
	            text: '',
	            width:100       
	            },{
	            xtype: 'label',
	            cls: 'labelstyle',
	            id:'tolocationlab',
	            cls:'labelstyle',
	            width:100,
	            style:'display:block; margin-left:175px;color: rgb(255, 255, 255);',
	            text: '<%=ToLocation%> :'        
	            },toLocationcombo,{
	            xtype: 'label',
	            cls: 'labelstyle',
	            text: '',
	            style:'display:block; margin-left:170px;',
	            width:100       
	            },{
	            xtype: 'button',
	            cls: 'labelstyle',
	            id:'viewlab',
	            width:130,	            
	            text: '<%=View%>',
	            handler: function(){
	            	if(Ext.getCmp('fromDateId').getValue() == ""){
	            		Ext.example.msg("Enter From Date");
		                Ext.getCmp('fromDateId').focus();
		                return;
	            	}
	            	if(Ext.getCmp('toDateId').getValue() ==""){
	            		Ext.example.msg("Enter To Date");
		                Ext.getCmp('toDateId').focus();
		                return;
	            	}
	            	if (dateCompare(Ext.getCmp('fromDateId').getValue(), Ext.getCmp('toDateId').getValue()) == -1) {
             			Ext.example.msg("To Date Must Be Greater than From Date");
              			Ext.getCmp('todateId').focus();
              			return;
            		}
	            	if(Ext.getCmp('ComboId').getValue() ==""){
	            		Ext.example.msg("Enter Type");
		                Ext.getCmp('ComboId').focus();
		                return;
	            	}
	            	if(Ext.getCmp('fromLocationcomboId').getValue().toString()==""){
	            		Ext.example.msg("Enter From Location");
		                Ext.getCmp('fromLocationcomboId').focus();
		                return;
	            	}
	            	if(Ext.getCmp('toLocationcomboId').getValue().toString()==""){
	            		Ext.example.msg("Enter to Location");
		                Ext.getCmp('toLocationcomboId').focus();
		                return;
	            	}
	            	store.load();
	            	   type=Ext.getCmp('ComboId').getValue();
	            	    if(type=='In Transit' || type=='All') {
	            		dashboardCountStoppage.load({
	            	params:{
	            			fromDate:Ext.getCmp('fromDateId').getValue(),
							toDate:Ext.getCmp('toDateId').getValue(),
							jspName:jspName
	            		},
	            		callback:function(){
	            			if(dashboardCountStoppage.getCount()>0){
	            			var record = dashboardCountStoppage.getAt(0);
	            			stoppagecount = record.data['stoppagecountIndex'];
							    document.getElementById('stoppageid').innerHTML = record.data['stoppagecountIndex'];
	            			}
	            		}
	            			
	            	});
	            	dashboardCountOverSpeed.load({
	            	params:{
	            			fromDate:Ext.getCmp('fromDateId').getValue(),
							toDate:Ext.getCmp('toDateId').getValue(),
							jspName:jspName
	            		},
	            		callback:function(){
	            			if(dashboardCountOverSpeed.getCount()>0){
	            				var record = dashboardCountOverSpeed.getAt(0);
	            				overspeedcount = record.data['overspeedcountIndex'];
									document.getElementById('overspeedid').innerHTML = record.data['overspeedcountIndex'];
	            			}
	            		}
	            			
	            	});
	            	}
	            	dashboardCountstore.load({

						params:{
	            			fromDate:Ext.getCmp('fromDateId').getValue(),
							toDate:Ext.getCmp('toDateId').getValue(),
							type:Ext.getCmp('ComboId').getValue(),
							fromLocation:Ext.getCmp('fromLocationcomboId').getValue(),
							toLocation:Ext.getCmp('toLocationcomboId').getValue(),
							fromLocationName:Ext.getCmp('fromLocationcomboId').getRawValue(),
							toLocationName:Ext.getCmp('toLocationcomboId').getRawValue(),
							fromLocationId:prevfromlocId,
							toLocationId:prevtolocId,
							jspName:jspName
	            		},
	            		callback:function(){
	            			if(dashboardCountstore.getCount()>0){
		            			for(var i=0;i<dashboardCountstore.getCount();i++){
		            				var record = dashboardCountstore.getAt(i);
		            				if(record.data['tripstatusIndex'] == 'ON TIME'){
										document.getElementById('ontimeId').innerHTML = record.data['totalcountIndex'];										
									}
									if(record.data['tripstatusIndex'] == 'DELAYED'){
										document.getElementById('delayeddivId').innerHTML = record.data['totalcountIndex'];
									}
									if(record.data['tripstatusIndex'] == 'DELAYED ADDRESSED'){
										document.getElementById('delayedaddressdivId').innerHTML = record.data['totalcountIndex'];
									}
									if(record.data['tripstatusIndex'] == 'BEFORE TIME'){
										document.getElementById('beforetimedivId').innerHTML = record.data['totalcountIndex'];
									}
								}
	            			}
	            		}
					});
	            }	                    
	         }]
		});
	
	var dateAndLocationPanel = new Ext.Panel({
		standardSubmit: true,
		collapsible:false,
		frame:false,
		border:false,
		id:'custMaster',
		cls:'dashboardcustomerinnerpannel',
		bodyCfg : { cls:'dashboardcustomerinnerpannel' , style: {'background-color': 'transparent'} },
		height: 90,
		layoutConfig: {
		        columns: 1
		},
		items: [datePanel,locationPanel]
	});
	var outerPanel = new Ext.Panel({
		renderTo : 'datelocationpanel',
		standardSubmit: true,
		frame:false,
		border:false,
		id:'outerpannelid',
		cls:'dashboardcustomerpannel',
		bodyCfg : { cls:'dashboardcustomerpannel' , style: {'background-image': 'url(/ApplicationImages/DashBoard/Box_Blue.png) !important','background-repeat': 'repeat'} },
		items: [dateAndLocationPanel]	
	});

/*****************************Panel for ON TIME******************************************************/		
	 var ON_TIME = new Ext.Panel({
		standardSubmit: true,
		frame:false,
		border:false,		
		collapsible:false,
		cls:'dashboardInnerPanelAssetMLLSCMPannel',
		bodyStyle: 'background: white',
		id:'ctbid',
		layout:'column',		
		layoutConfig: {
			columns:2
		},
		items:[{
				xtype:'panel',
				id:'statucountdetalspannel',
				frame:false,
				border:false,
				width:'100%',
				cls:'dashboardMllSCMHeaderLabelStyle',
				items:[
				{
				xtype: 'label',
				html: '<div class="dashBoarderHearderDiv" id="ontimeId" onclick="getVehicleCount(\'ontime\',this)">0</div>',
				width:'100%',
				border:true,
				bodyStyle: 'background-color: green',
				id:'alertdetailsctbid1',
				},
				{
				xtype: 'label',
				html: '<div class="dashBoarderHearderCountDiv" id="totalAssetHeader" onclick="getVehicleCount(\'ontime\')"><%=OnTime%></div>',
				width:'100%',
				border:true,
				id:'alertlbldetailssaid1'
				}]}]
		}); // End of Panel	
		
		
/*****************************Panel for DELAYED******************************************************/
var DELAYED = new Ext.Panel({
		standardSubmit: true,
		frame:false,
		border:false,				
		collapsible:false,
		cls:'dashboardInnerPanelAssetMLLSCMPannel',
		bodyStyle: 'background: white',
		id:'delayedpanelid',
		layout:'column',		
		layoutConfig: {
			columns:2
		},
		items:[{
				xtype:'panel',
				id:'delayedCountDetailsPannel',
				frame:false,
				border:false,
				width:'100%',
				cls:'dashboardMllSCMHeaderLabelStyle',
				items:[
				{
				xtype: 'label',
				html: '<div class="delayedHearderLabelDiv" id="delayeddivId" onclick="getVehicleCount(\'delayed\',this)">0</div>',
				width:'100%',
				border:true,
				bodyStyle: 'background-color: green',
				id:'delayeddetailsid',
				},
				{
				xtype: 'label',
				html: '<div class="delayedCountDiv" id="delayedHeader" onclick="getVehicleCount(\'delayed\')"><%=Delayed%></div>',
				width:'100%',
				border:true,
				}]}]
		}); // End of Panel		
		
/*****************************Panel for BEFORE TIME******************************************************/
var DELAYED_ADDRESS = new Ext.Panel({
		standardSubmit: true,
		frame:false,
		border:false,		
		collapsible:false,
		cls:'dashboardInnerPanelAssetMLLSCMPannel',
		bodyStyle: 'background: white',
		id:'beforetimepanelid',
		layout:'column',		
		layoutConfig: {
			columns:2
		},
		items:[{
				xtype:'panel',
				id:'Commcountcetailspannel',
				frame:false,
				border:false,
				width:'100%',
				cls:'dashboardMllSCMHeaderLabelStyle',
				items:[
				{
				xtype: 'label',
				html: '<div class="beforetimeHearderLabelDiv" id="delayedaddressdivId" onclick="getVehicleCount(\'delayedaddress\',this)">0</div>',
				width:'100%',
				border:true,
				bodyStyle: 'background-color: green'
				},
				{
				xtype: 'label',
				html: '<div class="beforetimeCountDiv" id="delayedaddressHeader" onclick="getVehicleCount(\'delayedaddress\')"><%=DelayedAddress%></div>',
				width:'100%',
				border:true
				}]}]
		}); // End of Panel	
		
/*****************************Panel for DELAYED ADDRESS******************************************************/
var BEFORE_TIME = new Ext.Panel({
		standardSubmit: true,
		frame:false,		
		border:false,		
		collapsible:false,
		cls:'dashboardInnerPanelAssetMLLSCMPannel',
		bodyStyle: 'background: white',
		id:'delayedaddresspanelid',
		layout:'column',		
		layoutConfig: {
			columns:2
		},
		items:[{
				xtype:'panel',
				id:'delayedaddresscountcetailspannel',
				frame:false,
				border:false,
				width:'100%',
				cls:'dashboardMllSCMHeaderLabelStyle',
				items:[
				{
				xtype: 'label',
				html: '<div class="delayedaddressHearderLabelDiv" id="beforetimedivId" onclick="getVehicleCount(\'beforetime\',this)">0</div>',
				width:'100%',
				border:true,
				bodyStyle: 'background-color: green'
				},
				{
				xtype: 'label',
				html: '<div class="delayedaddressCountDiv" id="beforetimeHeader" onclick="getVehicleCount(\'beforetime\')"><%=BeforeTime%></div>',
				width:'100%',
				border:true
				}]}]
		}); // End of Panel	
		
		
		var OVER_SPEED = new Ext.Panel({
		standardSubmit: true,
		frame:false,		
		border:false,		
		collapsible:false,
		cls:'dashboardInnerPanelAssetMLLSCMPannel',
		bodyStyle: 'background: white',
		id:'overTimePanelId',
		layout:'column',		
		layoutConfig: {
			columns:2
		},
		items:[{
				xtype:'panel',
				id:'delayedaddresscountcetailspannel11',
				frame:false,
				border:false,
				width:'100%',
				cls:'dashboardMllSCMHeaderLabelStyle',
				items:[
				{
				xtype: 'label',
				html: '<div class="overTimeHeaderLabelDiv" id="overspeedid" onclick="gotoAlertReport(\'2\',\'OverSpeed\')">0</div>',
				width:'100%',
				border:true,
				bodyStyle: 'background-color: green'
				},
				{
				xtype: 'label',
				html: '<div class="overCountDiv" id="overspeedtimeheadder" onclick="gotoAlertReport(\'2\',\'OverSpeed\')"><%=OverSpeed%></div>',
				width:'100%',
				border:true
				}]}]
		}); // End of Panel	
		
		
		var STOPPAGE = new Ext.Panel({
		standardSubmit: true,
		frame:false,		
		border:false,		
		collapsible:false,
		cls:'dashboardInnerPanelAssetMLLSCMPannel',
		bodyStyle: 'background: white',
		id:'overTimePanelId1',
		layout:'column',		
		layoutConfig: {
			columns:3
		},
		items:[{
				xtype:'panel',
				id:'delayedaddresscountcetailspannel12',
				frame:false,
				border:false,
				width:'100%',
				cls:'dashboardMllSCMHeaderLabelStyle',
				items:[
				{
				xtype: 'label',
				html: '<div class="overTimeHeaderLabelDiv1" id="stoppageid" onclick="gotoAlertReport(\'1\',\'Vehicle Stoppage\');">0</div>',
				width:'100%',
				border:true,
				bodyStyle: 'background-color: green'
				},
				{
				xtype: 'label',
				html: '<div class="overCountDiv1" id="stoppageHeader" onclick="gotoAlertReport(\'1\',\'Vehicle Stoppage\')"><%=Stoppage%></div>',
				width:'100%',
				border:true
				}]}]
		}); // End of Panel		
	
	var innerSecondMainPannel=new Ext.Panel({
		standardSubmit: true,
		frame:false,
		height:200,
		border:false,
		id:'innersecondmainpannel',
		layout:'column',
		layoutConfig: {
			columns:6
		},
		items: [ON_TIME,DELAYED,DELAYED_ADDRESS,BEFORE_TIME,OVER_SPEED,STOPPAGE]
	});
	var innerMainPannel=new Ext.Panel({
		standardSubmit: true,
		frame:false,
		border:false,
		width:'100%',
		id:'innermainpannel',
		items: [innerSecondMainPannel]
	});
	innerMainPannel.render('dashboardpanel');
/*****************************Json Reader, Filter, Column, Grid******************************************************/
	var reader = new Ext.data.JsonReader({
      idProperty: 'detailsId',
      root: 'detailsRoot',
      totalProperty: 'total',
      fields: [{
          		type: 'numeric',
          		name: 'slnoIndex'
      		 },{
          		type: 'string',
          		name: 'detailsOneIndex'
      		 },{
          		type: 'string',
          		name: 'detailsTwoIndex'
      		 },{
          		type: 'string',
          		name: 'detailsThreeIndex'
      		 },]
    });
    var filters = new Ext.ux.grid.GridFilters({
        local: true,
        filters: [{
		            type: 'numeric',
		            dataIndex: 'slnoIndex',		            
        		 },{
		            type: 'string',
		            dataIndex: 'detailsOneIndex',		            
        		 },{
	          		type: 'string',
	          		dataIndex: 'detailsTwoIndex'
	      		 },{
	          		type: 'string',
	          		dataIndex: 'detailsThreeIndex'
      		 	}]
    });
    var colModel = new Ext.grid.ColumnModel({
	    columns: [
	     	 new Ext.grid.RowNumberer({
            header: "<span style=font-weight:bold;>SLNO</span>",
            width: 50
        }),{
		        header: "<span style=font-weight:bold;>SLNO</span>",
		        sortable: true,
		        hidden:true,
		        dataIndex: 'slnoIndex',
		        filter:{
            		type: 'numeric'
				}
		    },{
		        header: "<span style=font-weight:bold;>Details ( From Location_To Location_Vehicle No_Shipment Id )</span>",
		        sortable: true,
		        dataIndex: 'detailsOneIndex',
		        filter:{
            		type: 'string'
				}
		    },{
		        header: "<span style=font-weight:bold;>Details ( From Location_To Location_Vehicle No_Shipment Id )</span>", 
		        sortable: true,
		        dataIndex: 'detailsTwoIndex',
		        filter:{
            		type: 'string'
				}		       
		    },{
		        header: "<span style=font-weight:bold;>Details ( From Location_To Location_Vehicle No_Shipment Id )</span>",
		        sortable: true,
		        dataIndex: 'detailsThreeIndex',
		        filter:{
            		type: 'string'
				}	        
		    }]
	    });
	var store = new Ext.data.GroupingStore({
        proxy: new Ext.data.HttpProxy({
        url: '<%=request.getContextPath()%>/MonitoringDashboardAction.do?param=getVehicleDetailsForDashboard',
        method: 'POST'
        }),
        storeId: 'gridStore',
        remoteSort: false,
        autoLoad: false,
        reader: reader
    });
	var grid = new Ext.grid.EditorGridPanel({                         
	     layout		:'fit',
	     viewConfig : {forceFit: true,},
	     store      : store,                                                                     
	     colModel   : colModel,                                       
	     loadMask	: true,
	     border		: false,
	     height		: 250,
	     enableColumnMove :false,
	     listeners  : {cellclick:{fn:getRegionId}}, 
		 plugins: [filters],
		  bbar: [{
		  		xtype: 'tbspacer', 
		  		width: screen.width-165
		  		},{
	            text: 'ClearFilterData',
	            iconCls : 'clearfilterbutton',
	            handler: function () {
		        		grid.filters.clearFilters();
		            }
	            },{
            	text :'',
            	iconCls : 'excelbutton',
            	handler : function(){
						getordreport('xls','All',jspName,grid,exportDataType);
				    }
            	}]   
	});
	function getRegionId(grid,rowIndex,columnIndex,e){
		var record = grid.getStore().getAt(rowIndex);
		var fieldName = grid.getColumnModel().getDataIndex(columnIndex);
		var data = record.get(fieldName);
		var fromdatefordetailspage = Ext.getCmp('fromDateId').getValue();
		var todatefordetailspage = Ext.getCmp('toDateId').getValue();
		var typefordetailspage = Ext.getCmp('ComboId').getValue();
		var fromlocationfordetailspage = Ext.getCmp('fromLocationcomboId').getRawValue();		
		var tolocationfordetailspage = Ext.getCmp('toLocationcomboId').getRawValue();
		var fromlocationIdfordetailspage;
		var tolocationIdfordetailspage;
		if(checkDashBoardDetails != '1'){
			fromlocationIdfordetailspage = Ext.getCmp('fromLocationcomboId').getValue();
			tolocationIdfordetailspage = Ext.getCmp('toLocationcomboId').getValue();
		}else{
			fromlocationIdfordetailspage = '<%=fromlocationIdformonitoringpage%>';
			tolocationIdfordetailspage = '<%=tolocationIdformonitoringpage%>';
		}
		if(fieldName == 'detailsOneIndex' && data != ''){						
			window.location ="<%=request.getContextPath()%>/Jsps/AutomotiveLogistics/DashboardDetails.jsp?data="+data+"&fromdatefordetailspage="+fromdatefordetailspage+"&todatefordetailspage="+todatefordetailspage+"&typefordetailspage="+typefordetailspage+"&fromlocationfordetailspage="+fromlocationfordetailspage+"&fromlocationIdfordetailspage="+fromlocationIdfordetailspage+"&tolocationfordetailspage="+tolocationfordetailspage+"&tolocationIdfordetailspage="+tolocationIdfordetailspage;
		}else if(fieldName == 'detailsTwoIndex' && data != ''){
			window.location ="<%=request.getContextPath()%>/Jsps/AutomotiveLogistics/DashboardDetails.jsp?data="+data+"&fromdatefordetailspage="+fromdatefordetailspage+"&todatefordetailspage="+todatefordetailspage+"&typefordetailspage="+typefordetailspage+"&fromlocationfordetailspage="+fromlocationfordetailspage+"&fromlocationIdfordetailspage="+fromlocationIdfordetailspage+"&tolocationfordetailspage="+tolocationfordetailspage+"&tolocationIdfordetailspage="+tolocationIdfordetailspage;
		}else if(fieldName == 'detailsThreeIndex' && data != ''){
			window.location ="<%=request.getContextPath()%>/Jsps/AutomotiveLogistics/DashboardDetails.jsp?data="+data+"&fromdatefordetailspage="+fromdatefordetailspage+"&todatefordetailspage="+todatefordetailspage+"&typefordetailspage="+typefordetailspage+"&fromlocationfordetailspage="+fromlocationfordetailspage+"&fromlocationIdfordetailspage="+fromlocationIdfordetailspage+"&tolocationfordetailspage="+tolocationfordetailspage+"&tolocationIdfordetailspage="+tolocationIdfordetailspage;
		}
	}
	grid.render('gridpanel');
	
	function getVehicleCount(type,eve){
	if(document.getElementById(eve.id).innerHTML > 0 ){
		if(type == 'ontime'){
			store.load({
				params:{
	           			fromDate:Ext.getCmp('fromDateId').getValue(),
						toDate:Ext.getCmp('toDateId').getValue(),
						type:Ext.getCmp('ComboId').getValue(),
						fromLocation:Ext.getCmp('fromLocationcomboId').getValue(),
						toLocation:Ext.getCmp('toLocationcomboId').getValue(),
						fromLocationName:Ext.getCmp('fromLocationcomboId').getRawValue(),
						toLocationName:Ext.getCmp('toLocationcomboId').getRawValue(),							
						tripStatus:'ON TIME',
						fromLocationId:prevfromlocId,
						toLocationId:prevtolocId,
						jspName:jspName
						}
			});
		}else if(type == 'delayed'){
			store.load({
				params:{
	           			fromDate:Ext.getCmp('fromDateId').getValue(),
						toDate:Ext.getCmp('toDateId').getValue(),
						type:Ext.getCmp('ComboId').getValue(),
						fromLocation:Ext.getCmp('fromLocationcomboId').getValue(),
						toLocation:Ext.getCmp('toLocationcomboId').getValue(),
						fromLocationName:Ext.getCmp('fromLocationcomboId').getRawValue(),
						toLocationName:Ext.getCmp('toLocationcomboId').getRawValue(),
						tripStatus:'DELAYED',
						fromLocationId:prevfromlocId,
						toLocationId:prevtolocId,
						jspName:jspName
						}
			});
		}else if(type == 'delayedaddress'){
			store.load({
				params:{
	           			fromDate:Ext.getCmp('fromDateId').getValue(),
						toDate:Ext.getCmp('toDateId').getValue(),
						type:Ext.getCmp('ComboId').getValue(),
						fromLocation:Ext.getCmp('fromLocationcomboId').getValue(),
						toLocation:Ext.getCmp('toLocationcomboId').getValue(),
						fromLocationName:Ext.getCmp('fromLocationcomboId').getRawValue(),
						toLocationName:Ext.getCmp('toLocationcomboId').getRawValue(),
						tripStatus:'DELAYED ADDRESSED',
						fromLocationId:prevfromlocId,
						toLocationId:prevtolocId,
						jspName:jspName
						}
			});
		}else if(type == 'beforetime'){
			store.load({
				params:{
	           			fromDate:Ext.getCmp('fromDateId').getValue(),
						toDate:Ext.getCmp('toDateId').getValue(),
						type:Ext.getCmp('ComboId').getValue(),
						fromLocation:Ext.getCmp('fromLocationcomboId').getValue(),
						toLocation:Ext.getCmp('toLocationcomboId').getValue(),
						fromLocationName:Ext.getCmp('fromLocationcomboId').getRawValue(),
						toLocationName:Ext.getCmp('toLocationcomboId').getRawValue(),
						tripStatus:'BEFORE TIME',
						fromLocationId:prevfromlocId,
						toLocationId:prevtolocId,
						jspName:jspName
						}
			});
		}	
		}	
	}
	function loadPreviousRecords(){
		if(checkDashBoardDetails == '1'){
			 var prevfromdate = '<%=fromdateformonitoringpage%>';
			 var dt = new Date(prevfromdate);
			 var mnth = ("0" + (dt.getMonth()+1)).slice(-2);
			 var day  = ("0" + dt.getDate()).slice(-2);
			 var prevfromdates= [day,mnth,dt.getFullYear() ].join("-");
			 
			 var prevtodate = '<%=todateformonitoringpage%>';
			 var dts = new Date(prevtodate);
			 var mnths = ("0" + (dts.getMonth()+1)).slice(-2);
			 var days  = ("0" + dts.getDate()).slice(-2);
			 var prevtodates= [days,mnths,dts.getFullYear() ].join("-");
			 
			 var prevtype = '<%=typeformonitoringpage%>';
			 var prevfromloc = '<%=fromlocationformonitoringpage%>';
			 var prevtoloc = '<%=tolocationformonitoringpage%>';
			 var shipmentStatusId= '<%=shipmentStatus%>';
			 prevfromlocId='<%=fromlocationIdformonitoringpage%>';
			 prevtolocId='<%=tolocationIdformonitoringpage%>';
			 
			 Ext.getCmp('fromDateId').setValue(prevfromdates);
			 Ext.getCmp('toDateId').setValue(prevtodates);
			 Ext.getCmp('ComboId').setValue(prevtype);
			 //Ext.getCmp('fromLocationcomboId').setValue(prevfromloc);
			 //Ext.getCmp('toLocationcomboId').setValue(prevtoloc);
			 
			 dashboardCountOverSpeed.load({
	            	params:{
	            			fromDate:Ext.getCmp('fromDateId').getValue(),
							toDate:Ext.getCmp('toDateId').getValue(),
							jspName:jspName
	            		},
	            		callback:function(){
	            			if(dashboardCountOverSpeed.getCount()>0){
	            			var record = dashboardCountOverSpeed.getAt(0);
	            			overspeedcount = record.data['overspeedcountIndex'];
							document.getElementById('overspeedid').innerHTML = record.data['overspeedcountIndex'];
	            			}
	            		}
	            			
	            	});
			 
			 dashboardCountStoppage.load({
	            	params:{
	            			fromDate:Ext.getCmp('fromDateId').getValue(),
							toDate:Ext.getCmp('toDateId').getValue(),
							jspName:jspName
	            		},
	            		callback:function(){
	            			if(dashboardCountStoppage.getCount()>0){
	            			var record = dashboardCountStoppage.getAt(0);
	            			stoppagecount = record.data['stoppagecountIndex'];
										document.getElementById('stoppageid').innerHTML = record.data['stoppagecountIndex'];
	            			}
	            		}
	            			
	            	});
	            	
			 
			 dashboardCountstore.load({
						params:{
	            			fromDate:Ext.getCmp('fromDateId').getValue(),
							toDate:Ext.getCmp('toDateId').getValue(),
							type:Ext.getCmp('ComboId').getValue(),
							fromLocation:prevfromloc,
							toLocation:prevtoloc,
							fromLocationId:prevfromlocId,
							toLocationId:prevtolocId,
							jspName:jspName
	            		},
	            		callback:function(){
	            			if(dashboardCountstore.getCount()>0){
		            			for(var i=0;i<dashboardCountstore.getCount();i++){
		            				var record = dashboardCountstore.getAt(i);
		            				if(record.data['tripstatusIndex'] == 'ON TIME'){
		            					document.getElementById('ontimeId').innerHTML = record.data['totalcountIndex'];										
									}
									if(record.data['tripstatusIndex'] == 'DELAYED'){
										document.getElementById('delayeddivId').innerHTML = record.data['totalcountIndex'];
									}
									if(record.data['tripstatusIndex'] == 'DELAYED ADDRESSED'){
										document.getElementById('delayedaddressdivId').innerHTML = record.data['totalcountIndex'];
									}
									if(record.data['tripstatusIndex'] == 'BEFORE TIME'){
										document.getElementById('beforetimedivId').innerHTML = record.data['totalcountIndex'];
									}
								}
	            			}
	            		}
	          });
	          store.load({
				params:{
	           			fromDate:Ext.getCmp('fromDateId').getValue(),
						toDate:Ext.getCmp('toDateId').getValue(),
						type:Ext.getCmp('ComboId').getValue(),
						fromLocation:prevfromlocId,
						toLocation:prevtolocId,
						FromLocation:prevfromloc,
						ToLocation:prevtoloc,
						tripStatus:shipmentStatusId,
					    jspName:jspName
						}
			});	
			//checkDashBoardDetails = '0';
		}
		if('<%= systemId %>'=='214'){
		Ext.getCmp('fromLocationcomboId').hide();
		Ext.getCmp('fromLocationlab').hide();
		Ext.getCmp('tolocationlab').hide();
		Ext.getCmp('toLocationcomboId').hide();
		
		Ext.getCmp('toLocationcomboId').setValue(0);
		Ext.getCmp('fromLocationcomboId').setValue(0);
		
		var el = document.getElementById('viewlab');
  		el.style.position= "absolute";
  		el.style.left= "1030px";
  		el.style.top= "76px";
  		var dl = document.getElementById('toDatelab');
  		dl.style.marginLeft= "85px";
  		var cl = document.getElementById('comblab');
  		cl.style.marginLeft= "80px";
		}
	
	}
	
  	Ext.onReady(function () {
  		Ext.get(document.body).addClass('ext-chrome-fixes');
        Ext.util.CSS.createStyleSheet('@media screen and (-webkit-min-device-pixel-ratio:0) {.x-grid3-cell{box-sizing: border-box !important;}}', 'chrome-fixes-box-sizing');
		locationcombostore.load();
	});
	

  	</script>
	<jsp:include page="../Common/footer.jsp" />
 <!-- </body>   -->
 <!-- </html> -->
