<%@ page  language="java" import="java.util.*,t4u.functions.CommonFunctions,t4u.beans.*,t4u.common.*" pageEncoding="utf-8"%> 
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
CommonFunctions cf=new CommonFunctions();
cf.checkLoginInfo((LoginInfoBean)session.getAttribute("loginInfoDetails"),session,request,response);
LoginInfoBean loginInfo=(LoginInfoBean)session.getAttribute("loginInfoDetails");
String language=loginInfo.getLanguage();
int customeridlogged=loginInfo.getCustomerId();
//getting hashmap with language specific words
HashMap langConverted=ApplicationListener.langConverted;
LanguageWordsBean lwb=null;
//loginInfo.setStyleSheetOverride("N");
//Getting words based on language 
String SelectCustomer;
lwb=(LanguageWordsBean)langConverted.get("Select_Customer");
if(language.equals("ar")){
	SelectCustomer=lwb.getArabicWord();
}else{
	SelectCustomer=lwb.getEnglishWord();
}
lwb=null;
String DailyAttendanceReport;
lwb=(LanguageWordsBean)langConverted.get("Daily_Attendance_Report");
if(language.equals("ar")){
	DailyAttendanceReport=lwb.getArabicWord();
}else{
	DailyAttendanceReport=lwb.getEnglishWord();
}

String CustomerName;
lwb=(LanguageWordsBean)langConverted.get("Customer_Name");
if(language.equals("ar")){
	CustomerName=lwb.getArabicWord();
}else{
	CustomerName=lwb.getEnglishWord();
}
lwb=null;
String StartDate;
lwb=(LanguageWordsBean)langConverted.get("Start_Date");
if(language.equals("ar")){
	StartDate=lwb.getArabicWord();
}else{
	StartDate=lwb.getEnglishWord();
}
lwb=null;
String SelectStartDate;
lwb=(LanguageWordsBean)langConverted.get("Select_Start_Date");
if(language.equals("ar")){
	SelectStartDate=lwb.getArabicWord();
}else{
	SelectStartDate=lwb.getEnglishWord();
}
lwb=null;
String EndDate;
lwb=(LanguageWordsBean)langConverted.get("End_Date");
if(language.equals("ar")){
	EndDate=lwb.getArabicWord();
}else{
	EndDate=lwb.getEnglishWord();
}
lwb=null;
String SelectEndDate;
lwb=(LanguageWordsBean)langConverted.get("Select_End_Date");
if(language.equals("ar")){
	SelectEndDate=lwb.getArabicWord();
}else{
	SelectEndDate=lwb.getEnglishWord();
}
lwb=null;
String Submit;
lwb=(LanguageWordsBean)langConverted.get("Submit");
if(language.equals("ar")){
	Submit=lwb.getArabicWord();
}else{
	Submit=lwb.getEnglishWord();
}
lwb=null;
String SLNO;
lwb=(LanguageWordsBean)langConverted.get("SLNO");
if(language.equals("ar")){
	SLNO=lwb.getArabicWord();
}else{
	SLNO=lwb.getEnglishWord();
}
lwb=null;
String Date;
lwb=(LanguageWordsBean)langConverted.get("Date");
if(language.equals("ar")){
	Date=lwb.getArabicWord();
}else{
	Date=lwb.getEnglishWord();
}
lwb=null;
String VehicleNo;
lwb=(LanguageWordsBean)langConverted.get("Registration_No");
if(language.equals("ar")){
	VehicleNo=lwb.getArabicWord();
}else{
	VehicleNo=lwb.getEnglishWord();
}
lwb=null;
String TradeName;
lwb=(LanguageWordsBean)langConverted.get("Trade_Name");
if(language.equals("ar")){
	TradeName=lwb.getArabicWord();
}else{
	TradeName=lwb.getEnglishWord();
}
lwb=null;
String Licenceholdername;
lwb=(LanguageWordsBean)langConverted.get("Licence_holder_name");
if(language.equals("ar")){
	Licenceholdername=lwb.getArabicWord();
}else{
	Licenceholdername=lwb.getEnglishWord();
}
lwb=null;
String SwipeLocation;
lwb=(LanguageWordsBean)langConverted.get("Swipe_Location");
if(language.equals("ar")){
	SwipeLocation=lwb.getArabicWord();
}else{
	SwipeLocation=lwb.getEnglishWord();
}
lwb=null;
String MobileNo;
lwb=(LanguageWordsBean)langConverted.get("Mobile_No");
if(language.equals("ar")){
	MobileNo=lwb.getArabicWord();
}else{
	MobileNo=lwb.getEnglishWord();
}
lwb=null;
String Wardname;
lwb=(LanguageWordsBean)langConverted.get("Ward_Name");
if(language.equals("ar")){
	Wardname=lwb.getArabicWord();
}else{
	Wardname=lwb.getEnglishWord();
}
lwb=null;
String Wardno;
lwb=(LanguageWordsBean)langConverted.get("Ward_No");
if(language.equals("ar")){
	Wardno=lwb.getArabicWord();
}else{
	Wardno=lwb.getEnglishWord();
}
lwb=null;
String SwipeDate;
lwb=(LanguageWordsBean)langConverted.get("Swipe_Date");
if(language.equals("ar")){
	SwipeDate=lwb.getArabicWord();
}else{
	SwipeDate=lwb.getEnglishWord();
}
lwb=null;
String NoRecordsFound;
lwb=(LanguageWordsBean)langConverted.get("No_Records_Found");
if(language.equals("ar")){
	NoRecordsFound=lwb.getArabicWord();
}else{
	NoRecordsFound=lwb.getEnglishWord();
}
lwb=null;
String ClearFilterData;
lwb=(LanguageWordsBean)langConverted.get("Clear_Filter_Data");
if(language.equals("ar")){
	ClearFilterData=lwb.getArabicWord();
}else{
	ClearFilterData=lwb.getEnglishWord();
}
lwb=null;
String ReconfigureGrid;
lwb=(LanguageWordsBean)langConverted.get("Reconfigure_Grid");
if(language.equals("ar")){
	ReconfigureGrid=lwb.getArabicWord();
}else{
	ReconfigureGrid=lwb.getEnglishWord();
}
lwb=null;
String ClearGrouping;
lwb=(LanguageWordsBean)langConverted.get("Clear_Grouping");
if(language.equals("ar")){
	ClearGrouping=lwb.getArabicWord();
}else{
	ClearGrouping=lwb.getEnglishWord();
}
lwb=null;
String Excel=cf.getLabelFromDB("Excel",language);
langConverted=null;
%>

<!DOCTYPE HTML>
<html class="largehtml">
 <head>
    
    <title><%=DailyAttendanceReport%></title>
  </head>
  <body class="largebody">
   	<%if (loginInfo.getStyleSheetOverride().equals("Y")){%>
	<jsp:include page="../Common/ImportJSSandMining.jsp"/>
	<%}else {%>
	<jsp:include page="../Common/ImportJS.jsp" />
	<%}%>
<!--   for exporting to excel***** -->
 <jsp:include page="../Common/ExportJS.jsp" />
 <style>
	.ext-strict .x-form-text {
		height: 15px !important;
	}
	</style>
   <script>
   
 var outerPanel;
 var ctsb;
 var dtnext = datenext;   
 var dtcur = datecur;
 //for exporting to excel***** 
 var jspName="DailyAttendanceReport";
 var exportDataType="int,string,string,string,string,string,string,string,string,datetime";
	
	/********************resize window event function***********************/
   Ext.EventManager.onWindowResize(function () {
   				var width = '100%';
			    var height = '100%';
			    grid.setSize(width, height);
			    outerPanel.setSize(width, height);
			    outerPanel.doLayout();
	});
	
 //****store for getting customer name
  var customercombostore= new Ext.data.JsonStore({
			url:'<%=request.getContextPath()%>/CommonAction.do?param=getCustomer',
				   id:'CustomerStoreId',
			       root: 'CustomerRoot',
			       autoLoad: true,
			       remoteSort: true,
				   fields: ['CustId','CustName'],
				   listeners: {
    				load: function(store, records, success, options) {
        				 if(<%=customeridlogged%>>0){
				 			Ext.getCmp('custcomboId').setValue('<%=customeridlogged%>');
				 		  }
    				}
    				}
	});
//***** combo for customername
 var custnamecombo=new Ext.form.ComboBox({
	        store: customercombostore,
	        id:'custcomboId',
	        mode: 'local',
	        forceSelection: true,
	        emptyText:'<%=SelectCustomer%>',
	        selectOnFocus:true,
	        allowBlank: false,
	        anyMatch:true,
            typeAhead: false,
	        triggerAction: 'all',
	        lazyRender: true,
	    	valueField: 'CustId',
	    	displayField: 'CustName',
	    	cls:'selectstyle',
	    	listeners: {
		                   select: {
		                 	   fn:function(){
		                 	   	store.load();
 								}
 								}
 								}
 								});
 								
	//******************grid config starts********************************************************
		// **********************reader configs
	var reader = new Ext.data.JsonReader({
        idProperty: 'darreaderid',
        root: 'dardata',
        totalProperty: 'total',
        fields: [
        {name: 'slnoIndex'},
        {
            name: 'Date',
            type: 'date',
            dateFormat: getDateFormat()
            
        }, {
            name: 'VehicleNo'
        }, {
            name: 'TradeName'
        },{
            name: 'LicenceHolderName'
        }, {
            name: 'SwipeLocation'
        }, 
        {
            name: 'MobileNo'
        }, {
            name: 'WardName'
        }, {
            name: 'WardNo'
        }, {
            name: 'SwipeDate',
            type: 'date',
            dateFormat: getDateTimeFormat()
        }]
	});
	
	       //************************* store configs
var store =  new Ext.data.GroupingStore({
        autoLoad:false,
        proxy: new Ext.data.HttpProxy({
        url:'<%=request.getContextPath()%>/DailyAttendanceReportAction.do?param=getDailyAttendanceReportDetails',
        method: 'POST'
		}),
        remoteSort: false,
        sortInfo: {
            field: 'SwipeLocation',
            direction: 'ASC'
        },
        groupField:'VehicleNo',
        storeId: 'darStore',
        reader:reader
    });
    store.on('beforeload',function(store, operation,eOpts){
        operation.params={
        	custId: Ext.getCmp('custcomboId').getValue(),
            startDate: Ext.getCmp('startdate').getValue(),
            endDate:Ext.getCmp('enddate').getValue(),
            jspName:jspName
           };
	},this);
//**********************filter config
    var filters = new Ext.ux.grid.GridFilters({
    local:true,
        filters: [
        {type: 'numeric',dataIndex: 'slnoIndex'}, 
        {
            dataIndex: 'Date',
            type: 'date'
        }, {
        	type: 'string',
            dataIndex: 'VehicleNo'
        }, {
            type: 'string',
            dataIndex: 'TradeName'
        },{
            type: 'string',
            dataIndex: 'LicenceHolderName'
        }, {
            type: 'string',
            dataIndex: 'SwipeLocation'
        }, 
        {
            type: 'string',
            dataIndex: 'MobileNo'
        }, {
            type: 'string',
            dataIndex: 'WardName'
        }, {
            type: 'string',
            dataIndex: 'WardNo'
        }, {
            dataIndex: 'SwipeDate',
            type: 'date'
        }]
    });    
    
    //**************column model config
    var createColModel = function (finish, start) {

        var columns = [
        new Ext.grid.RowNumberer({header: "<span style=font-weight:bold;><%=SLNO%></span>",width:50}),
        {
            dataIndex: 'slnoIndex',
            hidden:true,
            header: "<span style=font-weight:bold;><%=SLNO%></span>",
            filter:
            {
            	type: 'numeric'
			}
        },
        {
            dataIndex: 'Date',
            header: "<span style=font-weight:bold;><%=Date%></span>",
            renderer: Ext.util.Format.dateRenderer(getDateFormat()),
            filter:{
            type: 'date'
			}
        }, {
        	header: "<span style=font-weight:bold;><%=VehicleNo%></span>",
            dataIndex: 'VehicleNo',
            filter: {
            type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=TradeName%></span>",
            dataIndex: 'TradeName',
            filter: {
            type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;><%=Licenceholdername%></span>",
            dataIndex: 'LicenceHolderName',
            filter: {
            type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=SwipeLocation%></span>",
            dataIndex: 'SwipeLocation',
            filter: {
            type: 'string'
            }
        }, 
        {
            header: "<span style=font-weight:bold;><%=MobileNo%></span>",
            dataIndex: 'MobileNo',
            filter: {
            type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=Wardname%></span>",
            dataIndex: 'WardName',
            filter: {
            type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=Wardno%></span>",
            dataIndex: 'WardNo',
            filter: {
            type: 'string'
            }
        }, {
            dataIndex: 'SwipeDate',
            header: "<span style=font-weight:bold;><%=SwipeDate%></span>",
            renderer: Ext.util.Format.dateRenderer(getDateTimeFormat()),
            filter: {
            type: 'date'
            }
        }];

        return new Ext.grid.ColumnModel({
            columns: columns.slice(start || 0, finish),
            defaults: {
                sortable: true
            }
        });
    };
    
    //**********************grid panel config
    var grid=getGrid('<%=DailyAttendanceReport%>','<%=NoRecordsFound%>',store,screen.width - 50,360,6,filters,'<%=ClearFilterData%>',true,'<%=ReconfigureGrid%>',11,true,'<%=ClearGrouping%>',false,'',true,'<%=Excel%>',jspName,exportDataType,false,'');

//******************grid config ends*******************

  //**********************inner panel start******************************************* 
  var innerPanel = new Ext.Panel({
		standardSubmit: true,
		collapsible:false,
		cls:'innerpanelgridpercentage2',
		id:'traderMaster',
		layout:'table',
		layoutConfig: {
			columns:7
		},
		items: [
				{
				xtype: 'label',
				text: '<%=CustomerName%>'+' :',
				cls:'labelstyle',
				id:'custnamelab'
				},
				custnamecombo,{width:20,height:10},{width:20,height:10},{width:20,height:10},{width:20,height:10},{width:20,height:10}
				,
				{
				xtype: 'label',
				cls:'labelstyle',
				id:'startdatelab',
				text: '<%=StartDate%>'+' :'
				},
				{
				xtype:'datefield',
	    		cls:'selectstyle',
	    		format:getDateFormat(),
	    		emptyText:'<%=SelectStartDate%>',
	    		allowBlank: false,
	    		blankText :'<%=SelectStartDate%>',
	    		id:'startdate',
	    		value:dtcur,
	    		maxValue:dtcur,
				vtype: 'daterange',
        		endDateField:'enddate'
	    		}
	    		,{width:20,height:10},
				{
				xtype: 'label',
				cls:'labelstyle',
				id:'enddatelab',
				text: '<%=EndDate%>'+' :'
				},
				{
				xtype:'datefield',
	    		cls:'selectstyle',
	    		format:getDateFormat(),
	    		emptyText:'<%=SelectEndDate%>',
	    		allowBlank: false,
	    		blankText :'<%=SelectEndDate%>',
	    		id:'enddate',
	    		value:dtnext,
	    		maxValue:dtnext,
				vtype: 'daterange',
        		startDateField:'startdate'
	    		},{width:20,height:10},
	    		{
       			xtype:'button',
      			text:'<%=Submit%>',
        		id:'addbuttonid',
        		cls:' ',
        		width:80,
       			listeners: {
        		click:{
       			 fn:function(){
       			 //Action for Button
   			 	if(Ext.getCmp('custcomboId').getValue() == "" )
			    {
			    		 Ext.example.msg("<%=SelectCustomer%>");
		              	 Ext.getCmp('custcomboId').focus();
                      	 return;
			    }
			    if(Ext.getCmp('startdate').getValue() == "" )
			    {
			    		 Ext.example.msg("<%=SelectStartDate%>");
		              	 Ext.getCmp('startdate').focus();
                      	 return;
			    }
			    if(Ext.getCmp('enddate').getValue() == "" )
			    {
			     		 Ext.example.msg("<%=SelectEndDate%>");
		              	 Ext.getCmp('enddate').focus();
                      	 return;
			    }
       			store.load({
                        params: {
                            custId: Ext.getCmp('custcomboId').getValue(),
                            startDate: Ext.getCmp('startdate').getValue(),
                            endDate:Ext.getCmp('enddate').getValue(),
                            jspName:jspName
                        }
                    });
       			}
       			}
       			}
       			}
       					]
		}); // End of Panel	
	  
//*****main starts from here*************************
 Ext.onReady(function(){
	ctsb=tsb;
	Ext.QuickTips.init();
	Ext.form.Field.prototype.msgTarget = 'side';		         	   			
 	outerPanel = new Ext.Panel({
			title:'<%=DailyAttendanceReport%>',
			renderTo : 'content',
			standardSubmit: true,
			frame:true,
			width:screen.width-33,
			height:500,
			cls:'mainpanelpercentage',
			layout:'fit',
			items: [innerPanel,{height:15},grid]
			//bbar:ctsb			
			}); 
     	});		
	
  </script>
  </body>
</html>
