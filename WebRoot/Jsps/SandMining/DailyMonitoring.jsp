<%@ page language="java"
	import="java.util.*,t4u.functions.CommonFunctions,t4u.beans.*,t4u.common.*"
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
		loginInfo.setSystemId(systemid);
		loginInfo.setCustomerId(customerid);
		loginInfo.setUserId(userid);
		loginInfo.setLanguage(language);
		loginInfo.setZone(str[4].trim());
		loginInfo.setOffsetMinutes(Integer.parseInt(str[5].trim()));
		loginInfo.setSystemName(str[6].trim());
		loginInfo.setCategory(str[7].trim());
		if (str.length > 8) {
			loginInfo.setCustomerName(str[8].trim());
		}
		session.setAttribute("loginInfoDetails", loginInfo);
	}
	CommonFunctions cf = new CommonFunctions();
	cf.checkLoginInfo((LoginInfoBean) session.getAttribute("loginInfoDetails"), session, request, response);

	LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
	String language = loginInfo.getLanguage();
	int systemId = loginInfo.getSystemId();
	int customerId = loginInfo.getCustomerId();

%>



<jsp:include page="../Common/header.jsp" />
    <base href="<%=basePath%>">
    
    <title>DailyMonitoringReport</title>
    
<style>

.x-grid3-row td, *.x-grid3-summary-row td {
height: 20px;
border: 1px solid #ffffff !important;

}

</style>
	
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	<!--
	<link rel="stylesheet" type="text/css" href="styles.css">
	-->
 


<jsp:include page="../Common/ImportJSSandMining.jsp" />
<jsp:include page="../Common/ExportJS.jsp" />
<!--<script type="text/javascript" src="../../Main/Js/jsapi.js"></script>-->
<style>
		.ext-strict .x-form-text {
		    height: 21px !important;
		}
		label {
			display : inline !important;
		}
</style>

<script>
var outerPanel;
var dtprev;
var dtprev = dateprev;
var dtcur = datecur;
var grid; 
var loadMask = {msg:'Loading Records, please wait...'}; 

var actionRequired = '#E56B6B';
var withinSafeZone = '#64DB8A';
var toBeobserved = '#F1F131';

var red = 'Red';
var green = 'Green';
var yellow = 'Yellow';


//*****************************************print PDF****************************************************

function PrintPDF(){
                                        
var clientName = Ext.getCmp('custcomboId').getRawValue();
var clientId = Ext.getCmp('custcomboId').getValue();
var date = Ext.getCmp('dateId').getRawValue(); 

window.open("<%=request.getContextPath()%>/DailyMonitoringReportPdf?clientId="+clientId+"&clientName="+clientName+"&date="+date+"");
}

//*****************************************print Excel****************************************************

function PrintExcel(){
                                        
var clientName = Ext.getCmp('custcomboId').getRawValue();
var clientId = Ext.getCmp('custcomboId').getValue();
var date = Ext.getCmp('dateId').getRawValue(); 

window.open("<%=request.getContextPath()%>/DailyMonitoringReportExcel?clientId="+clientId+"&clientName="+clientName+"&date="+date+"");
}

//**********************************column model********************************************************           
        var colModel = new Ext.grid.ColumnModel({   
        columns:[
        new Ext.grid.RowNumberer({
                header: "<span style=font-weight:bold;>SlNo</span>",
                width: 50
            }),
        {      
        header: "<span style=font-weight:bold;>SlNo</span>",
        dataIndex: 'slnoIndex',
        width:35,
        hidden: true                     
    	},  
        {      
        header: "<span style=font-weight:bold;>Vehicle Number</span>",
        dataIndex: 'assetNumber',
        width:100
    	},
    	{
        header: "<span style=font-weight:bold;>1</span>",
        dataIndex: 'liveStatus',
        width:35,
        tooltip: 'Live Status.' ,
        border: true,
        renderer:function (value, meta){
        if( value.indexOf('Red')> -1)
        meta.style = "background-color:"+actionRequired+";color:"+actionRequired+";width:35px;";     
    	else if( value.indexOf('Green')> -1)
    	meta.style = "background-color:"+withinSafeZone+";color:"+withinSafeZone+";width:35px;";
    	else if( value.indexOf('Yellow')> -1) 
        meta.style = "background-color:"+toBeobserved+";color:"+toBeobserved+";width:35px;";
    	else
    	meta.style = "background-color:"+withinSafeZone+";color:"+withinSafeZone+";width:35px;";
               }
    	},
    	{
    	header: "<span style=font-weight:bold;>2</span>",
        dataIndex: 'overSpeedStatus',
        width:35,
        tooltip: 'Over Speed Status.' ,
        renderer: function (value, meta){
        if( value.indexOf('Red')> -1) 
        meta.style = "background-color:"+actionRequired+";color:"+actionRequired+";width:35px;";
    	else if( value.indexOf('Green')> -1)
    	meta.style = "background-color:"+withinSafeZone+";color:"+withinSafeZone+";width:35px;";
    	else if( value.indexOf('Yellow')> -1) 
        meta.style = "background-color:"+toBeobserved+";color:"+toBeobserved+";width:35px;";
    	else
    	meta.style = "background-color:"+withinSafeZone+";color:"+withinSafeZone+";width:35px;";
               }
    	},
    	{
    	header: "<span style=font-weight:bold;>3</span>",
        dataIndex: 'permitStatus',
        width:37,
        tooltip:'Permit Status.',
        renderer: function (value, meta){
        if( value.indexOf('Red')> -1) 
        meta.style = "background-color:"+actionRequired+";color:"+actionRequired+";width:35px;";
    	else if( value.indexOf('Green')> -1)
    	meta.style = "background-color:"+withinSafeZone+";color:"+withinSafeZone+";width:35px;";
    	else if( value.indexOf('Yellow')> -1) 
        meta.style = "background-color:"+toBeobserved+";color:"+toBeobserved+";width:35px;";
    	else
    	meta.style = "background-color:"+withinSafeZone+";color:"+withinSafeZone+";width:35px;";
               }
    	},    	
    	{   	
        header: "<span style=font-weight:bold;>4</span>",
        dataIndex: 'portEntryStatus',
        width:35,
        tooltip:'Port Entry Status.',
        renderer: function (value, meta){
        if( value.indexOf('Red')> -1) 
        meta.style = "background-color:"+actionRequired+";color:"+actionRequired+";width:35px;";
    	else if( value.indexOf('Green')> -1)
    	meta.style = "background-color:"+withinSafeZone+";color:"+withinSafeZone+";width:35px;";
    	else if( value.indexOf('Yellow')> -1) 
        meta.style = "background-color:"+toBeobserved+";color:"+toBeobserved+";width:35px;";
    	else
    	meta.style = "background-color:"+withinSafeZone+";color:"+withinSafeZone+";width:35px;";
               }
    	},
    	{
    	header: "<span style=font-weight:bold;>5</span>",
        dataIndex: 'multipleMDP',
        width:35,
        tooltip: 'Multiple MDP.',
        renderer: function (value, meta){
        if( value.indexOf('Red')> -1) 
        meta.style = "background-color:"+actionRequired+";color:"+actionRequired+";width:35px;";
    	else if( value.indexOf('Green')> -1)
    	meta.style = "background-color:"+withinSafeZone+";color:"+withinSafeZone+";width:35px;";
    	else if( value.indexOf('Yellow')> -1) 
        meta.style = "background-color:"+toBeobserved+";color:"+toBeobserved+";width:35px;";
    	else
    	meta.style = "background-color:"+withinSafeZone+";color:"+withinSafeZone+";width:35px;";
               }
    	},
    	{    	
        header: "<span style=font-weight:bold;>6</span>",
        dataIndex: 'nearToBorder',
        width:35,
        tooltip:'Near To Border.',
        renderer: function (value, meta){
        if( value.indexOf('Red')> -1) 
        meta.style = "background-color:"+actionRequired+";color:"+actionRequired+";width:35px;";
    	else if( value.indexOf('Green')> -1)
    	meta.style = "background-color:"+withinSafeZone+";color:"+withinSafeZone+";width:35px;";
    	else if( value.indexOf('Yellow')> -1) 
        meta.style = "background-color:"+toBeobserved+";color:"+toBeobserved+";width:35px;";
    	else
    	meta.style = "background-color:"+withinSafeZone+";color:"+withinSafeZone+";width:35px;";
               }
    	},
    	{
    	header: "<span style=font-weight:bold;>7</span>",     
        dataIndex: 'CrossBorder',
        width:37,
        tooltip:'Cross The Border.',
        renderer: function (value, meta){
        if( value.indexOf('Red')> -1) 
        meta.style = "background-color:"+actionRequired+";color:"+actionRequired+";width:35px;";
    	else if( value.indexOf('Green')> -1)
    	meta.style = "background-color:"+withinSafeZone+";color:"+withinSafeZone+";width:35px;";
    	else if( value.indexOf('Yellow')> -1) 
        meta.style = "background-color:"+toBeobserved+";color:"+toBeobserved+";width:35px;";
    	else
    	meta.style = "background-color:"+withinSafeZone+";color:"+withinSafeZone+";width:35px;";
               }
    	},
    	{    	
        header: "<span style=font-weight:bold;>8</span>",
        dataIndex: 'restrictivePortEntry', 
        width:35,
        tooltip:'Restrictive Port Entry.',
        renderer: function (value, meta){
        if( value.indexOf('Red')> -1) 
        meta.style = "background-color:"+actionRequired+";color:"+actionRequired+";width:35px;";
    	else if( value.indexOf('Green')> -1)
    	meta.style = "background-color:"+withinSafeZone+";color:"+withinSafeZone+";width:35px;";
    	else if( value.indexOf('Yellow')> -1) 
        meta.style = "background-color:"+toBeobserved+";color:"+toBeobserved+";width:35px;";
    	else
    	meta.style = "background-color:"+withinSafeZone+";color:"+withinSafeZone+";width:35px;";
               }
    	},
    	{
    	header: "<span style=font-weight:bold;>9</span>",
        dataIndex: 'insuranceStatus',
        width:35,
        tooltip:'Insurance Status.',
        renderer: function (value, meta){
        if( value.indexOf('Red')> -1) 
        meta.style = "background-color:"+actionRequired+";color:"+actionRequired+";width:35px;";
    	else if( value.indexOf('Green')> -1)
    	meta.style = "background-color:"+withinSafeZone+";color:"+withinSafeZone+";width:35px;";
    	else if( value.indexOf('Yellow')> -1) 
        meta.style = "background-color:"+toBeobserved+";color:"+toBeobserved+";width:35px;";
    	else
    	meta.style = "background-color:"+withinSafeZone+";color:"+withinSafeZone+";width:35px;";
               }
    	},
    	{
    	header: "<span style=font-weight:bold;>10</span>",
        dataIndex: 'assetFitnesStatus',
        width:35,
        tooltip:'Asset Fitnes Status.',
        renderer: function (value, meta){
        if( value.indexOf('Red')> -1) 
        meta.style = "background-color:"+actionRequired+";color:"+actionRequired+";width:35px;";
    	else if( value.indexOf('Green')> -1)
    	meta.style = "background-color:"+withinSafeZone+";color:"+withinSafeZone+";width:35px;";
    	else if( value.indexOf('Yellow')> -1) 
        meta.style = "background-color:"+toBeobserved+";color:"+toBeobserved+";width:35px;";
    	else
    	meta.style = "background-color:"+withinSafeZone+";color:"+withinSafeZone+";width:35px;";
               } 
    	},
    	{
    	header: "<span style=font-weight:bold;>11</span>",
        dataIndex: 'emissionStatus', 
        width:35,
        tooltip:'Emission Status.',
        renderer: function (value, meta){
        if( value.indexOf('Red')> -1) 
        meta.style = "background-color:"+actionRequired+";color:"+actionRequired+";width:35px;";
    	else if( value.indexOf('Green')> -1)
    	meta.style = "background-color:"+withinSafeZone+";color:"+withinSafeZone+";width:35px;";
    	else if( value.indexOf('Yellow')> -1) 
        meta.style = "background-color:"+toBeobserved+";color:"+toBeobserved+";width:35px;";
    	else
    	meta.style = "background-color:"+withinSafeZone+";color:"+withinSafeZone+";width:35px;";
               }
    	}   	
	 ]});

//**************************************** reader*************************************************
      
var reader = new Ext.data.JsonReader({
        idProperty: 'darreaderid',
        root: 'dailymonitoringDetails',
        totalProperty: 'total',
        fields: [{
                name:'slnoIndex'
                 },
                 {          
            		name: 'assetNumber'          		
        		 },
        		 {
            		name:'liveStatus'         		
        		 },
        		 {
            		name:'overSpeedStatus'           		
        		 },
        		 {
            		name:'permitStatus'          		
        		 },
        		 {
            		name:'portEntryStatus'           		
        		 },
        		 {
            		name:'multipleMDP'           		
        		 },
        		 {
            		name:'nearToBorder'           		
        		 },
        		 {
            		name:'CrossBorder'           		
        		 },
        		 {
            		name:'restrictivePortEntry'           		
        		 },
        		 {
            		name:'insuranceStatus'          		
        		 },
        		 {
            		name:'assetFitnesStatus'          		
        		 },
        		 {
            		name:'emissionStatus'          		
        		 }]        		        	  
    });
    
//**********************************************filters**********************************************

     var filters = new Ext.ux.grid.GridFilters({
        local: true,
        filters: [{
                type:'string',
        		dataIndex:'slnoIndex'
        	}, {
                type: 'string',
                dataIndex: 'assetNumber'
            }, {
                type: 'string',
                dataIndex: 'liveStatus'
            }, {
                type: 'string',
                dataIndex: 'overSpeedStatus'

            }, {
                type: 'string',
                dataIndex: 'permitStatus'

            }, {
                type: 'string',
                dataIndex: 'portEntryStatus'

            }, {
                type: 'string',
                dataIndex: 'multipleMDP'

            }, {
                type: 'string',
                dataIndex: 'nearToBorder'

            },{
                type: 'string',
                dataIndex: 'CrossBorder'

            },{
                type: 'string',
                dataIndex: 'restrictivePortEntry'

            },
            {
                type: 'string',
                dataIndex: 'insuranceStatus'

            },
            {
                type: 'string',
                dataIndex: 'assetFitnesStatus'

            },
                        {
                type: 'string',
                dataIndex: 'emissionStatus'

            }
        ]
    });    
       
//*******************************grid store*********************************************************    

var dailymonitoringDetailsStore=new Ext.data.GroupingStore({
				proxy: new Ext.data.HttpProxy({				
				url: '<%=request.getContextPath()%>/SandMiningAction.do?param=getDailyMonitorReport',
				 method: 'POST'
				 }),
				storeId:'dailymonitoringDetailsStoreId',
				root: 'dailymonitoringDetails',
				autoLoad: false,
				reader: reader,
				fields: ['slnoIndex','assetNumber','liveStatus','overSpeedStatus','permitStatus','portEntryStatus','multipleMDP','nearToBorder','CrossBorder','restrictivePortEntry','insuranceStatus','assetFitnesStatus','emissionStatus']
		}); 
		
//************************************ customer combo***************************************************   

var customercombostore = new Ext.data.JsonStore({
  		    url: '<%=request.getContextPath()%>/CommonAction.do?param=getCustomer',
  		    id: 'CustomerStoreId',
  		    root: 'CustomerRoot',
  		    autoLoad: true,
  		    remoteSort: true,
  		    fields: ['CustId', 'CustName'],
  		
});


var grid = new Ext.grid.GridPanel({                        
     height 	: 400,
     width      : 600,
     store      : dailymonitoringDetailsStore,                                                                     
     colModel   : colModel,  
     viewConfig: {
            forceFit: true
        },                                     
	 plugins: [filters],
	 view: new Ext.grid.GridView({
	 loadMask : true,
     emptyText: 'NoRecordsFound'
   }),
		  
});

//******************************************* customer combo***************************************************

var custnamecombo = new Ext.form.ComboBox({
  		    store: customercombostore,
  		    id: 'custcomboId',
  		    mode: 'local',
  		    forceSelection: true,
  		    emptyText: 'Select Customer',
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

  		              }
  		         }
  		      }
   });
//***********************************************inner panel*************************************************\

var innerPanel = new Ext.Panel({  		
  		    standardSubmit: true,
  		    collapsible: false,
  		    id: 'traderMaster',
  		    layout: 'table',
  		    frame: false,
  		    height : 50,
  		    layoutConfig: {
  		        columns: 8
  		    },
  		    items: [{
  		            xtype: 'label',
  		            text: 'Select Division' + ' :',
  		            cls: 'labelstyle',
  		            id: 'custnamelab'
  		            },
  		            {width:10},
  		            custnamecombo,
  		            {width:30},
  		            {
  		            xtype: 'label',
  		            cls: 'labelstyle',
  		            id: 'startdatelab',
  		            text: 'Select Date' + ' :'
  		            }, 
  		            {
                     xtype: 'datefield',
                     cls: 'selectstyle',
                     width:150,
                     format: getDateFormat(),
                     emptyText: 'Select End Date',
                     allowBlank: false,
                     blankText: 'Select End Date',
                     id: 'dateId',
                     value:dtprev
                    },
  		            {width:30},
  		            {
  		            xtype: 'button',
  		            text: 'View',
  		            id: 'addbuttonid',
  		            cls: ' ',
  		            width: 80,
  		            listeners: {
  		                click: {
  		                    fn: function () {
  		                      if (Ext.getCmp('custcomboId').getValue() == "") {  		                     
  		                            setMsgBoxStatus('Select Customer');
  		                            Ext.getCmp('custcomboId').focus();
  		                            return ;
  		                          }
  		                         if (Ext.getCmp('dateId').getValue() == "") {
  		                            setMsgBoxStatus('Select Date');
  		                            Ext.getCmp('dateId').focus();
  		                            return;
  		                        }
                               var clientId = Ext.getCmp('custcomboId').getValue(); 
                               var date = Ext.getCmp('dateId').getValue(); 
                              var loadMask = new Ext.LoadMask('outerpannelid', {msg:'Loading..'});
                              loadMask.show();
  		                        dailymonitoringDetailsStore.load({
  		                            params: {
 		                            	clientId:clientId,
  		                            	date:date	                        
  		                            },
  		                            callback:function()
  		                            {
  		                            	loadMask.hide();
  		                            }
  		                            });
  		               }//end of function
  		                  }//end of click
  		                    }//end of listeners
  		                      }
  		                    ]
});

//*********************************************inner panels*************************************

var colorPanel = new Ext.Panel({  	
            standardSubmit: true,
  		    collapsible: false,
  		    id: 'traderMastercolorPanel',
  		    layout: 'table',
  		    width: 300,
  		    height: 100,
  		    frame: false,
  		    layoutConfig: {
  		        columns: 2
  		    },
  		    items: [{
  		            xtype: 'label',
  		            text: 'Action Required'+' :',
  		            cls: 'labelstyle',
  		            id: 'labelRedId'
  		            },  		           
  		             {
 	                 xtype: 'label',
 	                 id: 'labelred',
 	                 text: 'blank',	       
 	                 cls: 'labelstyle',
 	                 style : {
                        background : actionRequired,
                        color : actionRequired,
                        border:'1px solid black',
                        width:'35px'
                    }
                    },	               
 	                 {
  		             xtype: 'label',
  		             text: 'To Be Observed' + ' :',
  		             cls: 'labelstyle',
  		             id: 'labelyellowId'
  		             },  		             
  		              {
 	                 xtype: 'label',
 	                 id: 'labelyellow',
 	                 text: 'blank',	       
 	                 cls: 'labelstyle',
 	                 style : {
                        background : toBeobserved,
                        color : toBeobserved,
                        border:'1px solid black',
                        width:'35px'
                    }
                    },                    
 	                 {
  		             xtype: 'label',
  		             text: 'Within Safe Zone' + ' :',
  		             cls: 'labelstyle',
  		             id: 'labelgreenId'
  		             },  		              
  		             {
 	                 xtype: 'label',
 	                 id: 'labelgreen',
 	                 text: 'blank',	       
 	                 cls: 'labelstyle',
 	                 style : {
                        background : withinSafeZone,
                        color : withinSafeZone,
                        border:'1px solid black',
                        width:'35px'
                    }
                    }
        ]	    
});

var numberPanel = new Ext.Panel({  	
            standardSubmit: true,
  		    collapsible: false,
  		    id: 'traderMasterNumber',
  		    layout: 'table',
  		    height : 220,
  		    frame: false,
  		    layoutConfig: {
  		        columns: 2
  		    },
  		    items: [
  		            {
  		            xtype: 'label',
  		            text: '1' + ' :',
  		            cls: 'labelstyle',
  		            id: 'LiveStatusId'
  		            },
  		            {
 	                xtype: 'label',
 	                text: 'Live Status.' ,
 	                id: 'LiveStatus',	       
 	                cls: 'labelstyle'
 	                },	               
 	      		    {
  		            xtype: 'label',
  		            text: '2' + ' :',
  		            cls: 'labelstyle',
  		            id: 'OverspeedstatusId'
  		            },
  		            {
 	                xtype: 'label',
 	                text: 'Over Speed Status.' ,
 	                id: 'Overspeedstatus',	       
 	                cls: 'labelstyle'
 	                }, 	                
 	      		    {
  		            xtype: 'label',
  		            text: '3' + ' :',
  		            cls: 'labelstyle',
  		            id: 'PermitstatusId'
  		            },
  		            {
 	                xtype: 'label',
 	                text: 'Permit Status.' ,
 	                id: 'Permitstatus',	       
 	                cls: 'labelstyle'
 	                },
 	              
 	      		    {
  		            xtype: 'label',
  		            text: '4' + ' :',
  		            cls: 'labelstyle',
  		            id: 'portEntrystatusId'
  		            },
  		            {
 	                xtype: 'label',
 	                text: 'Port Entry Status.' ,
 	                id: 'portEntrystatus',	       
 	                cls: 'labelstyle'
 	                },
 	               
 	      		    {
  		            xtype: 'label',
  		            text: '5' + ' :',
  		            cls: 'labelstyle',
  		            id: 'multipleMDPId'
  		            },
  		            {
 	                xtype: 'label',
 	                text: 'Multiple MDP.' ,
 	                id: 'multipleMDP',	       
 	                cls: 'labelstyle'
 	                },
 	               
 	      		    {
  		            xtype: 'label',
  		            text: '6' + ' :',
  		            cls: 'labelstyle',
  		            id: 'NeartoborderId'
  		            },
  		            {
 	                xtype: 'label',
 	                text: 'Near To Border.' ,
 	                id: 'Neartoborder',	       
 	                cls: 'labelstyle'
 	                },
 	               
 	      		    {
  		            xtype: 'label',
  		            text: '7' + ' :',
  		            cls: 'labelstyle',
  		            id: 'CrosstheborderId'
  		            },
  		            {
 	                xtype: 'label',
 	                text: 'Cross The Border.' ,
 	                id: 'Crosstheborder',	       
 	        		cls: 'labelstyle'
 	    			},
 	     			
 	      		    {
  		            xtype: 'label',
  		            text: '8' + ' :',
  		            cls: 'labelstyle',
  		            id: 'RestrictiveportentryId'
  		        	},
  		        	{
 	        		xtype: 'label',
 	        		text: 'Restrictive Port Entry.' ,
 	        		id: 'Restrictiveportentry',	       
 	        		cls: 'labelstyle'
 	   				},
 	     	     	
 	      		    {
  		            xtype: 'label',
  		            text: '9' + ' :',
  		            cls: 'labelstyle',
  		            id: 'InsurancestatusId'
  		        	},
  		       		{
 	        		xtype: 'label',
 	        		text: 'Insurance Status.' ,
 	        		id: 'InsuranceStatus',	       
 	        		cls: 'labelstyle'
 	    			},
 	     	     	
 	      		    {
  		            xtype: 'label',
  		            text: '10' + ' :',
  		            cls: 'labelstyle',
  		            id: 'AssetFittnessId'
  		        	},
  		        	{
 	       			xtype: 'label',
 	        		text: 'Asset Fittness Status.' ,
 	        		id: 'AssetFittness',	       
 	        		cls: 'labelstyle'
 	    			},
 	    	     	
 	      		    {
  		            xtype: 'label',
  		            text: '11' + ' :',
  		            cls: 'labelstyle',
  		            id: 'EmissionStatusId'
  		        	},
  		        	{
 	        		xtype: 'label',
 	       			text: 'Emission Status.' ,
 	        		id: 'Emissionstatus',	       
 	        		cls: 'labelstyle'
 	    			}]
});

var exportpanel = new Ext.Panel({
            standardSubmit: true,
  		    collapsible: false,
  		    id: 'exportPanelId',
  		    layout: 'table',
  		    frame: false,
  		    layoutConfig: {
  		        columns: 2
  		    },
  		    items : [{
  		      xtype: 'button',
  		            text: 'PDF',
  		            id: 'pdfbuttonid',
  		            cls: ' ',
  		            width: 80,  		            	            
  		                  listeners: {
  		                      click: {
  		                       fn: function () {
  		                       PrintPDF(); 		                       
  		                         }
  		                      }
  		                    }
  		    },{
  		      xtype: 'button',
  		            text: 'EXCEL',
  		            id: 'excelbuttonid',
  		            cls: ' ',
  		            width: 80,  		            	            
  		                  listeners: {
  		                      click: {
  		                       fn: function () {
  		                       PrintExcel(); 		                       
  		                         }
  		                      }
  		                    }
  		    }]
});

//**************************************************************panels*************************************
var rightPanel = new Ext.Panel({  		
  		    standardSubmit: true,
  		    collapsible: false,
  		    id: 'traderMasterright',
  		    layout: 'table',
  		    frame: false,
  		    layoutConfig: {
  		        columns: 1
  		    },
  		    items: [colorPanel,numberPanel,exportpanel]
});
var leftPanel = new Ext.Panel({  		
  		    standardSubmit: true,
  		    collapsible: false,
  		    id: 'traderMasterleft',
  		    layout: 'table',
  		    frame: false,
  		    layoutConfig: {
  		        columns: 1
  		    },
  		    items: [innerPanel,grid]
});


Ext.onReady(function(){
	Ext.QuickTips.init();
	Ext.form.Field.prototype.msgTarget = 'side';	

  		    outerPanel = new Ext.Panel({
  		        title: 'Daily Monitoring Report',
  		        renderTo: 'content',
  		        standardSubmit: true,
  		        frame: true,
  		        cls: 'outerpanel',
  		        id:'outerpannelid',
  		        layout: 'table',
  		        layoutConfig: {
  		            columns: 3
  		        },
  		        items: [leftPanel,{width:100},rightPanel],
  		    });	

        
});//end of Ext.onReady
        
        </script>
   <jsp:include page="../Common/footer.jsp" />
 <!-- </body>   -->
 <!-- </html> -->
