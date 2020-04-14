<%@ page  language="java" import="java.util.*,t4u.functions.CommonFunctions,t4u.beans.*,t4u.common.*" pageEncoding="utf-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
CommonFunctions cf=new CommonFunctions();
cf.checkLoginInfo((LoginInfoBean)session.getAttribute("loginInfoDetails"),session,request,response);
LoginInfoBean loginInfo=(LoginInfoBean)session.getAttribute("loginInfoDetails");
//getting language
String language=loginInfo.getLanguage();
//getting hashmap with language specific words
HashMap langConverted=ApplicationListener.langConverted;
LanguageWordsBean lwb=null;

//Getting words based on language
String selectLTSP;
lwb=(LanguageWordsBean)langConverted.get("Select_LTSP");
if(language.equals("ar")){
selectLTSP=lwb.getArabicWord();
}else{
selectLTSP=lwb.getEnglishWord();
} 
lwb=null;

String selectUser;
lwb=(LanguageWordsBean)langConverted.get("Select_User");
if(language.equals("ar")){
	selectUser=lwb.getArabicWord();
}else{
	selectUser=lwb.getEnglishWord();
}
lwb=null;

String selectCustomer;
lwb=(LanguageWordsBean)langConverted.get("Select_Customer");
if(language.equals("ar")){
	selectCustomer=lwb.getArabicWord();
}else{
	selectCustomer=lwb.getEnglishWord();
}
lwb=null;

String reportTime;
lwb=(LanguageWordsBean)langConverted.get("Rep_Time");
if(language.equals("ar")){
	reportTime=lwb.getArabicWord();
}else{
	reportTime=lwb.getEnglishWord();
}
lwb=null;

String enterRepTime;
lwb=(LanguageWordsBean)langConverted.get("Enter_Rep_Time");
if(language.equals("ar")){
	enterRepTime=lwb.getArabicWord();
}else{
	enterRepTime=lwb.getEnglishWord();
}
lwb=null;

String exitTime;
lwb=(LanguageWordsBean)langConverted.get("Exit_Time");
if(language.equals("ar")){
	exitTime=lwb.getArabicWord();
}else{
	exitTime=lwb.getEnglishWord();
}
lwb=null;

String enterExitTime;
lwb=(LanguageWordsBean)langConverted.get("Enter_Exit_Time");
if(language.equals("ar")){
	enterExitTime=lwb.getArabicWord();
}else{
	enterExitTime=lwb.getEnglishWord();
}
lwb=null;

String actions;
lwb=(LanguageWordsBean)langConverted.get("Actions");
if(language.equals("ar")){
	actions=lwb.getArabicWord();
}else{
	actions=lwb.getEnglishWord();
}
lwb=null;

String install;
lwb=(LanguageWordsBean)langConverted.get("New_Inst");
if(language.equals("ar")){
	install=lwb.getArabicWord();
}else{
	install=lwb.getEnglishWord();
}
lwb=null;

String unInstall;
lwb=(LanguageWordsBean)langConverted.get("Un_Ins");
if(language.equals("ar")){
	unInstall=lwb.getArabicWord();
}else{
	unInstall=lwb.getEnglishWord();
}
lwb=null;

String upkeep;
lwb=(LanguageWordsBean)langConverted.get("Upkeep");
if(language.equals("ar")){
	upkeep=lwb.getArabicWord();
}else{
	upkeep=lwb.getEnglishWord();
}
lwb=null;

String software;
lwb=(LanguageWordsBean)langConverted.get("Software");
if(language.equals("ar")){
	software=lwb.getArabicWord();
}else{
	software=lwb.getEnglishWord();
}
lwb=null;

String selCheckItem;
lwb=(LanguageWordsBean)langConverted.get("Plz_Sel_Item_Check");
if(language.equals("ar")){
	selCheckItem=lwb.getArabicWord();
}else{
	selCheckItem=lwb.getEnglishWord();
}
lwb=null;

String selectVehicle;
lwb=(LanguageWordsBean)langConverted.get("Sel_Reg_No");
if(language.equals("ar")){
selectVehicle=lwb.getArabicWord();
}else{
	selectVehicle=lwb.getEnglishWord();
}
lwb=null;

String imeiNo;
lwb=(LanguageWordsBean)langConverted.get("Device_IMEI");
if(language.equals("ar")){
	imeiNo=lwb.getArabicWord();
}else{
	imeiNo=lwb.getEnglishWord();
}
lwb=null;

String deviceType;
lwb=(LanguageWordsBean)langConverted.get("Device_Type");
if(language.equals("ar")){
	deviceType=lwb.getArabicWord();
}else{
	deviceType=lwb.getEnglishWord();
}
lwb=null;

String vehicleAlias;
lwb=(LanguageWordsBean)langConverted.get("Vehicle_Alias");
if(language.equals("ar")){
	vehicleAlias=lwb.getArabicWord();
}else{
	vehicleAlias=lwb.getEnglishWord();
}
lwb=null;

String empTrack;
lwb=(LanguageWordsBean)langConverted.get("Emp_Track");
if(language.equals("ar")){
	empTrack=lwb.getArabicWord();
}else{
	empTrack=lwb.getEnglishWord();
}
lwb=null;

String fdtlu;
lwb=(LanguageWordsBean)langConverted.get("FDTLU");
if(language.equals("ar")){
	fdtlu=lwb.getArabicWord();
}else{
	fdtlu=lwb.getEnglishWord();
}
lwb=null;

String slno;
lwb=(LanguageWordsBean)langConverted.get("SLNO");
if(language.equals("ar")){
	slno=lwb.getArabicWord();
}else{
	slno=lwb.getEnglishWord();
}
lwb=null;

String items;
lwb=(LanguageWordsBean)langConverted.get("Items");
if(language.equals("ar")){
	items=lwb.getArabicWord();
}else{
	items=lwb.getEnglishWord();
}
lwb=null;

String details;
lwb=(LanguageWordsBean)langConverted.get("Details");
if(language.equals("ar")){
	details=lwb.getArabicWord();
}else{
	details=lwb.getEnglishWord();
}
lwb=null;

String remarks;
lwb=(LanguageWordsBean)langConverted.get("Remarks");
if(language.equals("ar")){
	remarks=lwb.getArabicWord();
}else{
    remarks=lwb.getEnglishWord();
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

String clearfilteradta;
lwb=(LanguageWordsBean)langConverted.get("Clear_Filter_Data");
if(language.equals("ar")){
	clearfilteradta=lwb.getArabicWord();
}else{
    clearfilteradta=lwb.getEnglishWord();
}
lwb=null;

String reconfig;
lwb=(LanguageWordsBean)langConverted.get("Reconfigure_Grid");
if(language.equals("ar")){
	reconfig=lwb.getArabicWord();
}else{
    reconfig=lwb.getEnglishWord();
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

String submit;
lwb=(LanguageWordsBean)langConverted.get("Submit");
if(language.equals("ar")){
	submit=lwb.getArabicWord();
}else{
    submit=lwb.getEnglishWord();
}
lwb=null;

String savForm;
lwb=(LanguageWordsBean)langConverted.get("Saving_Form");
if(language.equals("ar")){
	savForm=lwb.getArabicWord();
}else{
    savForm=lwb.getEnglishWord();
}
lwb=null;

String datecomp;
lwb=(LanguageWordsBean)langConverted.get("Sel_Repo_Time_Less_Exit_Time");
if(language.equals("ar")){
	datecomp=lwb.getArabicWord();
}else{
    datecomp=lwb.getEnglishWord();
}
lwb=null;
langConverted=null;
%>

<!DOCTYPE HTML>
<html>
 <head>
 			
</head>	    
  
  <body height="100%">
  
   <jsp:include page="../Common/ImportJS.jsp" />
   
   <script>
 var outerPanel;
 var ctsb;
 var dtnextval =  new Date().add(Date.DAY, 1); ;  
 var dtnext = datenext;   
 var dtcur = datecur;
 var dtnexttonext=datedayafternext;
 
      // **********************reader configs
      
  
	var reader = new Ext.data.JsonReader({
        idProperty: 'ftlureaderid',
        root: 'FacilityTaskList',
        totalProperty: 'total',
        fields: [{
            name: 'ITEMS'
        }, {
            name: 'DETAILS'
        },{
            name: 'REMARKS'
        }]
	});
 
       //store config
		var store = new Ext.data.GroupingStore({
		
		autoLoad: false,
		proxy: new Ext.data.HttpProxy({
        url:'<%=request.getContextPath()%>/EmployeeTrackingAction.do?param=getFacilityDailyTaskListUpdate',
        method: 'POST'
		}),
		remoteSort: false,
		sortInfo: {
		field: 'DETAILS',
		direction: 'ASC'
		},
		storeId: 'empTrackDetStore',
        reader:reader
		
		});
		 store.on('beforeload',function(store, operation,eOpts){
        operation.params={
        	 CustId:Ext.getCmp('customerComboId').getValue(),
		     LTSPId:Ext.getCmp('ltspComboId').getValue(),
		     VehicleId:Ext.getCmp('vehicleComboId').getValue()
           };
	},this);
		
		
		//filter config
		var filters = new Ext.ux.grid.GridFilters({
		local:true,
		filters: [ {
		type: 'string',
		dataIndex: 'ITEMS'
		},  {
		type: 'string',
		dataIndex: 'DETAILS'
		},
		{
		type: 'string',
		dataIndex: 'REMARKS'
		}]
		});
		
		//col model config
		var createColModel = function (finish, start) {
		
		var columns = [
		new Ext.grid.RowNumberer({header: "<span style=font-weight:bold;><%=slno%></span>",width:50}),
		 {
		header: "<span style=font-weight:bold;><%=items%></span>",
		dataIndex: 'ITEMS',
		filter: {
		type: 'string'
		}
		}, {
		header: "<span style=font-weight:bold;><%=details%></span>",
		dataIndex: 'DETAILS',
		filter: {
		type: 'string'
		}
		},{
		header: "<span style=font-weight:bold;><%=remarks%></span>",
		dataIndex: 'REMARKS',
		filter: {
		type: 'string'
		},
		editor: new Ext.form.TextField({})
		
		} 
		 ];
		
		return new Ext.grid.ColumnModel({
		columns: columns.slice(start || 0, finish),
		defaults: {
		sortable: true
		}
		});
		};
		
		//**********************grid panel config
		var grid=getGrid('<%=fdtlu%>','<%=NoRecordsFound%>',store,'100%',150,4,filters,'<%=clearfilteradta%>',false,'<%=reconfig%>',4,true,'<%=ClearGrouping%>',false,'',false,'','','',false,'');

		
		//Reporting Time and Exit Time store
		var reportexitstore=new Ext.data.JsonStore({
		        url:'<%=request.getContextPath()%>/EmployeeTrackingAction.do?param=getreportExitTime',
		        id:'ReportExitStoreId',
		        root:'ReportExitStore',
		        autoLoad:false,
		        remortSort:true,
		        fields:['UserId','ReportTime','ExitTime']
		
		});


    

	 //vehicle store-------
	 var vehiclestore=new Ext.data.JsonStore({
				url:'<%=request.getContextPath()%>/EmployeeTrackingAction.do?param=getVehicleDetails',
				id:'VehicleStoreId',
				root: 'VehicleRoot',
				autoLoad: false,
				remoteSort: true,
				fields: ['VehicleNo','IMEINo','DeviceType','VehicleAlias']
		});
	
	
  //vehicle combo--------
  var vehicleCombo=new Ext.form.ComboBox({
                store:vehiclestore,
                mode:'local',
                id:'vehicleComboId',
                forceSelection: true,
                emptyText:'<%=selectVehicle%>',
	            blankText:'<%=selectVehicle%>',
	            selectOnFocus:true,
	            allowBlank: false,
	            anyMatch:true,
	            typeAhead: false,
	            triggerAction: 'all',
	            lazyRender: true,
	    	    valueField: 'VehicleNo',
	    	    displayField: 'VehicleNo',
	    	    enableKeyEvents:true,
	    	    cls:'selectstyle',
	    	    listeners: {
		                   select: {
		                 	   fn:function(){
		                 	   
		                 	      var vehicleReg=Ext.getCmp('vehicleComboId').getValue();
		                 	      var imeiNo="";
		                 	      var deviceType="";
		                 	      var vehicleAlias="";
		                 	      
 														var idx = vehiclestore.findBy(function(record)
 														{
    															if(record.get('VehicleNo')==vehicleReg) 
    															{
        															imeiNo = record.get('IMEINo');
        															deviceType = record.get('DeviceType');
        															vehicleAlias=record.get('VehicleAlias');
    															}
														});
		                 	      
								  Ext.getCmp('imeiNoId').setValue(imeiNo);
								  Ext.getCmp('deviceTypeId').setValue(deviceType);
								  Ext.getCmp('vehicleAliasId').setValue(vehicleAlias);
								  customerId=Ext.getCmp('customerComboId').getValue();
		                 	      ltsploadid=Ext.getCmp('ltspComboId').getValue();
		                 	     
								  store.load({
								  params:{    CustId:customerId,
		                 	                  LTSPId:ltsploadid,
		                 	                  VehicleId:vehicleReg
		                 	                  }
								 });
              		          	}
              		          	} 
              		         
              		          	}
   
  });
  
  //customercombostore-------
 var customerstore=new Ext.data.JsonStore({
			url:'<%=request.getContextPath()%>/EmployeeTrackingAction.do?param=getCustomer',
			id:'CustomerStoreId',
			root: 'CustomerRoot',
			autoLoad: false,
			remoteSort: true,
			fields: ['CustId','CustName']
	});
	
  //select customercombo--------
  var customerCombo=new Ext.form.ComboBox({
                store:customerstore,
                mode:'local',
                id:'customerComboId',
                forceSelection: true,
                emptyText:'<%=selectCustomer%>',
	            blankText:'<%=selectCustomer%>',
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
		                 	   fn:function(field){
		                 	   custId=Ext.getCmp('customerComboId').getValue();
		                 	   ltspid=Ext.getCmp('ltspComboId').getValue();
		                       Ext.getCmp('vehicleComboId').reset();
		                       Ext.getCmp('imeiNoId').reset();
		                       Ext.getCmp('deviceTypeId').reset();
		                       Ext.getCmp('vehicleAliasId').reset();
		                 	   vehiclestore.load({
		                 	    params:{CustId:custId,
		                 	            LTSPId:ltspid
		                 	     }
		                 	   });
		                 	   
		                 	   }}}
   
  });
 
 
 // usercombostore-------
 var userstore=new Ext.data.JsonStore({
			url:'<%=request.getContextPath()%>/EmployeeTrackingAction.do?param=getUser',
			id:'UserStoreId',
			root: 'UserRoot',
			autoLoad: true,
			remoteSort: true,
			fields: ['UserId','UserName']
			
	});
	
  //Select User Combo---------	
  var userCombo=new Ext.form.ComboBox({
                store:userstore,
                mode:'local',
                forceSelection: true,
                id:'userComboId',
                emptyText:'<%=selectUser%>',
	            blankText:'<%=selectUser%>',
	            selectOnFocus:true,
	            allowBlank: false,
	            anyMatch:true,
	            typeAhead: false,
	            triggerAction: 'all',
	            lazyRender: true,
	    	    valueField: 'UserId',
	    	    displayField: 'UserName',
	    	    cls:'selectstyle',
	    	     listeners: {
		                   select: {
		                 	   fn:function(field){
		                 	                  store.load();
		                 	                  Ext.getCmp('datefieldid').reset();
		                 	                  Ext.getCmp('datefieldoneid').reset();
		                 	                  ltspIdd=Ext.getCmp('ltspComboId').getValue();
		                 	                  userId=Ext.getCmp('userComboId').getValue();
		                 	                  reportexitstore.load({
		                 	                  params:{
		                 	                  LTSPId:ltspIdd,
		                 	                  UserId:userId
		                 	                  },
		                 	     callback:function(){
		                 	     var repTime="";
		                 	     var exitTime="";
		                 	   
		                 	    var record=reportexitstore.getAt(0);
		                 	     repTime = record.data['ReportTime'];
      							 exitTime = record.data['ExitTime'];
      							 Ext.getCmp('datefieldid').setValue(repTime);
								 Ext.getCmp('datefieldoneid').setValue(exitTime);  
  															}
												});
								
								
                 	      
		                 	   }}}
		  
  });
 
 
 //LTSP store-------
 var ltspstore=new Ext.data.JsonStore({
			url:'<%=request.getContextPath()%>/EmployeeTrackingAction.do?param=getLTSP',
			id:'LTSPStoreId',
			root: 'LTSPRoot',
			autoLoad: true,
			remoteSort: true,
			fields: ['LTSPId','LTSPName']
	});
  	                                   
  //combo for getting LTSP------
  var ltspCombo=new Ext.form.ComboBox({
                store:ltspstore,
                mode:'local',
                forceSelection: true,
                id:'ltspComboId',
                emptyText:'<%=selectLTSP%>',
	            blankText:'<%=selectLTSP%>',
	            selectOnFocus:true,
	            allowBlank: false,
	            anyMatch:true,
	            typeAhead: false,
	            triggerAction: 'all',
	            lazyRender: true,
	    	    valueField: 'LTSPId',
	    	    displayField: 'LTSPName',
	    	    cls:'selectstyle',
	    	    listeners: {
		                   select: {
		                 	   fn:function(field){
		                 	   Ext.getCmp('datefieldid').reset();
		                 	   Ext.getCmp('datefieldoneid').reset();
		                 	   Ext.getCmp('vehicleComboId').reset();
		                       Ext.getCmp('customerComboId').reset();
		                 	   Ext.getCmp('userComboId').reset();
		                       Ext.getCmp('imeiNoId').reset();
		                       Ext.getCmp('deviceTypeId').reset();
		                       Ext.getCmp('vehicleAliasId').reset();
		                       Ext.getCmp('vehicleComboId').reset();
		                       Ext.getCmp('installcheckid').reset();
							   Ext.getCmp('uninstallcheckid').reset();
							   Ext.getCmp('upkeepingcheckid').reset();
							   Ext.getCmp('softcheckid').reset();
		                 	   ltspIdd=Ext.getCmp('ltspComboId').getValue();
		                 	    customerstore.load({
		                 	    params:{LtspId:ltspIdd}
		                 	   });
		                 	   vehiclestore.load();
		                 	   store.load();
		                 	   }}
						    	  
		                 	   
		                 	   }
	            
  });
  //inner panel started-------
  var innerPanel=new Ext.Panel({
        standardSubmit: true,
		frame:true,
		cls:'innerpanelgridlargepercentage1',
		id:'emptrackingid',
		layout:'table',
		layoutConfig:{
		columns:2
		},
		items:[{
		       xtype:'label',
		       text:'<%=selectLTSP%>:',
		       cls:'labelstyle',
		       id:'selltspid'
		       },ltspCombo,
		       {
		       xtype:'label',
		       text:'<%=selectUser%>:',
		       id:'seluserid',
		       cls:'labelstyle'
		       },userCombo,
		       {
		       xtype:'label',
		       text:'<%=selectCustomer%>:',
		       cls:'labelstyle',
		       id:'selcustomerid'
		       },customerCombo,
		       {
		       xtype:'label',
		       text:'<%=reportTime%>:',
		       cls:'labelstyle',
		       id:'reportingtimeid'
		       },{
		       xtype:'datefield',
		       format:getDateTimeFormatWithoutSeconds(),
		       value:dtcur,
		       maxValue:dtnext,
		       vtype: 'daterange',
		       emptyText:'<%=enterRepTime%>',
	    	   cls:'selectstyle',
	    	   endDateField:'datefieldoneid', 
		       id:'datefieldid'
			   },
			    {
		       xtype:'label',
		       text:'<%=exitTime%>:',
		       cls:'labelstyle',
		       id:'exittimeid'
		       },{
		       xtype:'datefield',
		       format:getDateTimeFormatWithoutSeconds(),
		       value:dtnextval,
		       maxValue:dtnexttonext,
			   vtype: 'daterange',
		       emptyText:'<%=enterExitTime%>',		       
		       cls:'selectstyle',
		       id:'datefieldoneid',
		       startDateField:'datefieldid'
			   },
			   {
			   xtype: 'fieldset',
			   title: '<%=actions%>',
			   cls:'fieldsetpanelmedium',
				id:'actionfieldsetid',
				colspan:4,
				layout:'table',
				layoutConfig: {
					columns:4
				},
				items: [
						{
						xtype: 'checkbox',
						id:'installcheckid',
						cls:'checkstyle'
						},
						{
						xtype: 'label',
						html: '<%=install%>',
						cls:'checkboxlabelstyle'
						},
						{
						xtype: 'checkbox',
						id:'uninstallcheckid',
						cls:'checkstyle'
						},
						{
						xtype: 'label',
						html: '<%=unInstall%>',
						cls:'checkboxlabelstyle'
						},
						{
						xtype: 'checkbox',
						id:'upkeepingcheckid',
						cls:'checkstyle'
						},
						{
						xtype: 'label',
						html: '<%=upkeep%>',
						cls:'checkboxlabelstyle'
						},
						{
						xtype: 'checkbox',
						id:'softcheckid',
						cls:'checkstyle'
						},
						{
						xtype: 'label',
						html: '<%=software%>',
						cls:'checkboxlabelstyle'
						}
						
						]
			   },
			   {
		       xtype:'label',
		       text:'<%=selectVehicle%>:',
		       cls:'labelstyle'
		       },vehicleCombo,
		       {
		       xtype:'label',
		       text:'<%=imeiNo%>:',
		       id:'imeiid',
		       cls:'labelstyle'
		       },
		       {
		            xtype:'textfield',
	    			cls:'textrnumberstyle',
	    			readOnly: true,
	    			emptyText:'<%=imeiNo%>',
	    			id:'imeiNoId'
		       },
		       {
		        xtype:'label',
		        text:'<%=deviceType%>:',
		        cls:'labelstyle'
		       },
		       {
		            xtype:'textfield',
	    			cls:'textrnumberstyle',
	    			readOnly: true,
	    			emptyText:'<%=deviceType%>',
	    			id:'deviceTypeId'
		       },
		       {
		        xtype:'label',
		        text:'<%=vehicleAlias%>:',
		        cls:'labelstyle'
		       },
		       {
		            xtype:'textfield',
	    			cls:'textrnumberstyle',
	    			readOnly: true,
	    			emptyText:'<%=vehicleAlias%>',
	    			id:'vehicleAliasId'
		       } ]
  });
  //innerpanel ends--------
  
  //buttonPanel starts
   var buttonPanel=new Ext.Panel({
        standardSubmit: true,
		frame:true,
		cls:'innerpanelgridlargepercentage',
		id:'buttonid',
		layout:'table',
		layoutConfig:{
		columns:3
		},
		items:[
		 
		       {width:400},{
		          xtype:'button',
		          text:'<%=submit%>',
		          cls:'buttonrightstyle',
		          width:80,
		          listeners: {
        		  click:{
       			  fn:function(){
       			  
       			  if(Ext.getCmp('ltspComboId').getValue()== ""){
							ctsb.setStatus({
											 text: getMessageForStatus("<%=selectLTSP%>"), 
											 iconCls:'',
											 clear: true
					                       	 });
					                       	 Ext.getCmp('ltspComboId').focus();
					                       	 return;
							}
							
					if(Ext.getCmp('userComboId').getValue()== ""){
							ctsb.setStatus({
											 text: getMessageForStatus("<%=selectUser%>"), 
											 iconCls:'',
											 clear: true
					                       	 });
					                       	 Ext.getCmp('userComboId').focus();
					                       	 return;
							}
							
					if(Ext.getCmp('customerComboId').getValue()== ""){
							ctsb.setStatus({
											 text: getMessageForStatus("<%=selectCustomer%>"), 
											 iconCls:'',
											 clear: true
					                       	 });
					                       	 Ext.getCmp('customerComboId').focus();
					                       	 return;
							}
		            if(Ext.getCmp('datefieldid').getValue()== ""){
							ctsb.setStatus({
											 text: getMessageForStatus("<%=enterRepTime%>"), 
											 iconCls:'',
											 clear: true
					                       	 });
					                       	 Ext.getCmp('datefieldid').focus();
					                       	 return;
							}
					 if(Ext.getCmp('datefieldoneid').getValue()== ""){
							ctsb.setStatus({
											 text: getMessageForStatus("<%=enterExitTime%>"), 
											 iconCls:'',
											 clear: true
					                       	 });
					                       	 Ext.getCmp('datefieldoneid').focus();
					                       	 return;
							}     	
		                 	
					if(dateCompare(Ext.getCmp('datefieldid').getValue(),Ext.getCmp('datefieldoneid').getValue())<0){
						ctsb.setStatus({
											 text: getMessageForStatus("<%=datecomp%>"), 
											 iconCls:'',
											 clear: true
					                       	 });
					                       	 Ext.getCmp('datefieldid').focus();
					                       	 return;
							}
					
				 	var checkedItems="";
				
				       	if(!(Ext.getCmp('installcheckid').checked) && !(Ext.getCmp('uninstallcheckid').checked) && !(Ext.getCmp('upkeepingcheckid').checked) && !(Ext.getCmp('softcheckid').checked) )
					    {
				             ctsb.setStatus({
							 text: getMessageForStatus("<%=selCheckItem%>"), 
							 iconCls:'',
							 clear: true
	                       	 });
	                       	 Ext.getCmp('form-statusbar').focus(true,1);
	                       	 window.scrollTo(0,0);
	                       	 return;
					    }	
					    if(Ext.getCmp('installcheckid').checked){
					    	if(checkedItems==''){
					    		checkedItems="New/Re Installation";
					    	}else{
					    		checkedItems=checkedItems+",New/Re Installation";
					    	}
					    }
					    if(Ext.getCmp('uninstallcheckid').checked){
					    	if(checkedItems==''){
					    		checkedItems="Un-Installation";
					    	}else{
					    		checkedItems=checkedItems+",Un-Installation";
					    	}
					    }
					    if(Ext.getCmp('upkeepingcheckid').checked){
					    	if(checkedItems==''){
					    		checkedItems="Upkeeping";
					    	}else{
					    		checkedItems=checkedItems+",Upkeeping";
					    	}
					    }
					    if(Ext.getCmp('softcheckid').checked){
					    	if(checkedItems==''){
					    		checkedItems="Software";
					    	}else{
					    		checkedItems=checkedItems+",Software";
					    	}
					    }
				if(Ext.getCmp('vehicleComboId').getValue()== ""){
							ctsb.setStatus({
											 text: getMessageForStatus("<%=selectVehicle%>"), 
											 iconCls:'',
											 clear: true
					                       	 });
					                       	 Ext.getCmp('vehicleComboId').focus();
					                       	 return;
							}
							
					var json=''
					for(var i=0;i<grid.store.data.length;i++){
					  var storedata = grid.store.getAt(i); 
					  json += Ext.util.JSON.encode(storedata.data) + ',';    
					}
					if(json!=''){
 			 					json = json.substring(0, json.length - 1);
 					} 
 					
 					ctsb.showBusy('<%=savForm%>');
					outerPanel.getEl().mask();
 					window.scrollTo(0,0);
 					//AJAX Call
					Ext.Ajax.request({
								url: '<%=request.getContextPath()%>/EmployeeTrackingAction.do?param=saveEmployeeTrackingDetails',
								method: 'POST',
								params: {
								jasondata: json,
								LTSP:Ext.getCmp('ltspComboId').getValue(),
								User:Ext.getCmp('userComboId').getValue(),
								Customer:Ext.getCmp('customerComboId').getValue(),
								VehicleNo:Ext.getCmp('vehicleComboId').getValue(),
								Reptime:Ext.getCmp('datefieldid').getValue(),
								ExitTime:Ext.getCmp('datefieldoneid').getValue(),
								NewReInstall:Ext.getCmp('installcheckid').getValue(),
								UnInstall:Ext.getCmp('uninstallcheckid').getValue(),
								Upkeep:Ext.getCmp('upkeepingcheckid').getValue(),
								Software:Ext.getCmp('softcheckid').getValue(),
								IMEINo:Ext.getCmp('imeiNoId').getValue(),
								DevType:Ext.getCmp('deviceTypeId').getValue()
								
								},
						success:function(response, options)
								{
					    ctsb.setStatus({
									 text:getMessageForStatus(response.responseText), 
									 iconCls:'',
									 clear: true
				                     });
								
								Ext.getCmp('vehicleComboId').reset();
								Ext.getCmp('imeiNoId').reset();
								Ext.getCmp('deviceTypeId').reset();
								Ext.getCmp('vehicleAliasId').reset();
								
								store.load();
								outerPanel.getEl().unmask();
								
								},
		                failure:function()
		                {
		                 ctsb.setStatus({
								 text:getMessageForStatus("error"), 
								 iconCls:'',
								 clear: true
			                     });
		                        Ext.getCmp('vehicleComboId').reset();
								Ext.getCmp('imeiNoId').reset();
								Ext.getCmp('deviceTypeId').reset();
								Ext.getCmp('vehicleAliasId').reset();
								store.load();
								outerPanel.getEl().unmask();
								
		                }
		                });//End of AJAX
				
       			  
       			  }}}
		       
		
		}]
		});
  //main programme starts from here
  Ext.onReady(function () {
    ctsb=tsb;
	Ext.QuickTips.init();
	Ext.form.Field.prototype.msgTarget = 'side';
  outerPanel=new Ext.Panel({
  title:'<%=empTrack%>',
  renderTo:'content',
  standardSubmit:true,
  height:930,
  frame:true,
  cls:'mainpanelgridlargepercentage1',
  items:[innerPanel,grid,buttonPanel],
  bbar:ctsb
  });
 

});
   </script>
   </body>
   </html>
 