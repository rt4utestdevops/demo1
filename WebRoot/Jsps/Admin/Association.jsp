<%@ page  language="java" import="java.util.*,t4u.functions.CommonFunctions,t4u.beans.*,t4u.common.*" pageEncoding="utf-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
CommonFunctions cf=new CommonFunctions();
cf.checkLoginInfo((LoginInfoBean)session.getAttribute("loginInfoDetails"),session,request,response);
boolean hid=false;
String idd="";
if(session.getAttribute("idd")!=null){
idd = session.getAttribute("idd").toString();
if(idd.equals("newdata")){
hid=true;
session.setAttribute("idd",null);}}
String assetType=""+session.getAttribute("ASSET_TYPE");
String customerName=""+session.getAttribute("CUST_NAME");
String registrationNO=""+session.getAttribute("REG_NO");

LoginInfoBean loginInfo=(LoginInfoBean)session.getAttribute("loginInfoDetails");
String language=loginInfo.getLanguage();
//getting hashmap with language specific words
HashMap langConverted=ApplicationListener.langConverted;
LanguageWordsBean lwb=null;

String selCust;
lwb=(LanguageWordsBean)langConverted.get("Customer_Selection");
if(language.equals("ar")){
	selCust=lwb.getArabicWord();
}else{
	selCust=lwb.getEnglishWord();
}
lwb=null;

String custName;
lwb=(LanguageWordsBean)langConverted.get("Customer_Name");
if(language.equals("ar")){
	custName=lwb.getArabicWord();
}else{
	custName=lwb.getEnglishWord();
}
lwb=null;

String association;
lwb=(LanguageWordsBean)langConverted.get("Association");
if(language.equals("ar")){
	association=lwb.getArabicWord();
}else{
	association=lwb.getEnglishWord();
}
lwb=null;

String grpName;
lwb=(LanguageWordsBean)langConverted.get("Grp_Name");
if(language.equals("ar")){
	grpName=lwb.getArabicWord();
}else{
	grpName=lwb.getEnglishWord();
}
lwb=null;

String selGrpName;
lwb=(LanguageWordsBean)langConverted.get("Sel_Grp_Name");
if(language.equals("ar")){
	selGrpName=lwb.getArabicWord();
}else{
	selGrpName=lwb.getEnglishWord();
}
lwb=null;

String selReasonCancel;
lwb=(LanguageWordsBean)langConverted.get("Sel_Reason_Cancel");
if(language.equals("ar")){
	selReasonCancel=lwb.getArabicWord();
}else{
	selReasonCancel=lwb.getEnglishWord();
}
lwb=null;

String selManuf;
lwb=(LanguageWordsBean)langConverted.get("Sel_Manuf");
if(language.equals("ar")){
	selManuf=lwb.getArabicWord();
}else{
	selManuf=lwb.getEnglishWord();
}
lwb=null;

String selUnitNo;
lwb=(LanguageWordsBean)langConverted.get("Sel_unit_No");
if(language.equals("ar")){
	selUnitNo=lwb.getArabicWord();
}else{
	selUnitNo=lwb.getEnglishWord();
}
lwb=null;

String selMobNo;
lwb=(LanguageWordsBean)langConverted.get("Sel_Mobile_No");
if(language.equals("ar")){
	selMobNo=lwb.getArabicWord();
}else{
	selMobNo=lwb.getEnglishWord();
}
lwb=null;

String selRegNo;
lwb=(LanguageWordsBean)langConverted.get("Sel_Reg_No");
if(language.equals("ar")){
	selRegNo=lwb.getArabicWord();
}else{
	selRegNo=lwb.getEnglishWord();
}
lwb=null;

String selType;
lwb=(LanguageWordsBean)langConverted.get("Sel_Type");
if(language.equals("ar")){
	selType=lwb.getArabicWord();
}else{
	selType=lwb.getEnglishWord();
}
lwb=null;

String type;
lwb=(LanguageWordsBean)langConverted.get("Type");
if(language.equals("ar")){
	type=lwb.getArabicWord();
}else{
	type=lwb.getEnglishWord();
}
lwb=null;

String regNo;
lwb=(LanguageWordsBean)langConverted.get("Registration_No");
if(language.equals("ar")){
	regNo=lwb.getArabicWord();
}else{
	regNo=lwb.getEnglishWord();
}
lwb=null;

String unitNo;
lwb=(LanguageWordsBean)langConverted.get("Unit_No");
if(language.equals("ar")){
	unitNo=lwb.getArabicWord();
}else{
	unitNo=lwb.getEnglishWord();
}
lwb=null;

String unitReg;
lwb=(LanguageWordsBean)langConverted.get("Unit_Reg");
if(language.equals("ar")){
	unitReg=lwb.getArabicWord();
}else{
	unitReg=lwb.getEnglishWord();
}
lwb=null;

String deviceImei;
lwb=(LanguageWordsBean)langConverted.get("Device_IMEI");
if(language.equals("ar")){
	deviceImei=lwb.getArabicWord();
}else{
	deviceImei=lwb.getEnglishWord();
}
lwb=null;

String manuf;
lwb=(LanguageWordsBean)langConverted.get("Manufacturer");
if(language.equals("ar")){
	manuf=lwb.getArabicWord();
}else{
	manuf=lwb.getEnglishWord();
}
lwb=null;

String deviceRefId;
lwb=(LanguageWordsBean)langConverted.get("Dev_Ref_Id");
if(language.equals("ar")){
	deviceRefId=lwb.getArabicWord();
}else{
	deviceRefId=lwb.getEnglishWord();
}
lwb=null;

String mobNo;
lwb=(LanguageWordsBean)langConverted.get("Mobile_No");
if(language.equals("ar")){
	mobNo=lwb.getArabicWord();
}else{
	mobNo=lwb.getEnglishWord();
}
lwb=null;

String mobInfo;
lwb=(LanguageWordsBean)langConverted.get("Mob_Info");
if(language.equals("ar")){
	mobInfo=lwb.getArabicWord();
}else{
	mobInfo=lwb.getEnglishWord();
}
lwb=null;

String enterMobNo;
lwb=(LanguageWordsBean)langConverted.get("Enter_Mobile_No");
if(language.equals("ar")){
	enterMobNo=lwb.getArabicWord();
}else{
	enterMobNo=lwb.getEnglishWord();
}
lwb=null;

String simNo;
lwb=(LanguageWordsBean)langConverted.get("Sim_No");
if(language.equals("ar")){
	simNo=lwb.getArabicWord();
}else{
	simNo=lwb.getEnglishWord();
}
lwb=null;

String enterSimNo;
lwb=(LanguageWordsBean)langConverted.get("Enter_Sim_No");
if(language.equals("ar")){
	enterSimNo=lwb.getArabicWord();
}else{
	enterSimNo=lwb.getEnglishWord();
}
lwb=null;

String serviceProvider;
lwb=(LanguageWordsBean)langConverted.get("Service_provider");
if(language.equals("ar")){
	serviceProvider=lwb.getArabicWord();
}else{
	serviceProvider=lwb.getEnglishWord();
}
lwb=null;

String enterSimSerProvider;
lwb=(LanguageWordsBean)langConverted.get("Service_provider");
if(language.equals("ar")){
	enterSimSerProvider=lwb.getArabicWord();
}else{
	enterSimSerProvider=lwb.getEnglishWord();
}
lwb=null;

String reasonCancel;
lwb=(LanguageWordsBean)langConverted.get("Reason_Cancel");
if(language.equals("ar")){
	reasonCancel=lwb.getArabicWord();
}else{
	reasonCancel=lwb.getEnglishWord();
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

String delete;
lwb=(LanguageWordsBean)langConverted.get("Delete");
if(language.equals("ar")){
	delete=lwb.getArabicWord();
}else{
	delete=lwb.getEnglishWord();
}
lwb=null;

String deleting;
lwb=(LanguageWordsBean)langConverted.get("Deleting");
if(language.equals("ar")){
	deleting=lwb.getArabicWord();
}else{
	deleting=lwb.getEnglishWord();
}
lwb=null;

String entrRegNo;
lwb=(LanguageWordsBean)langConverted.get("Enter_Reg_No");
if(language.equals("ar")){
	entrRegNo=lwb.getArabicWord();
}else{
	entrRegNo=lwb.getEnglishWord();
}
lwb=null;

String regRegex;
lwb=(LanguageWordsBean)langConverted.get("Reg_Regex");
if(language.equals("ar")){
	regRegex=lwb.getArabicWord();
}else{
	regRegex=lwb.getEnglishWord();
}
lwb=null;

String saveForm;
lwb=(LanguageWordsBean)langConverted.get("Save_Form");
if(language.equals("ar")){
	saveForm=lwb.getArabicWord();
}else{
	saveForm=lwb.getEnglishWord();
}
lwb=null;
langConverted=null;
%>

<!DOCTYPE HTML>
<html class="largehtml">
 <head>
		<title><%=association%></title>
		
	</head>	    
  
  <body class="largebody">
   
   <jsp:include page="../Common/ImportJS.jsp" />
   <script>
    
   var outerPanel;
   var ctsb;
   var panel1;
   var buttonValue="add";
   
  
   var selectCanComboStore= new Ext.data.SimpleStore({
				   id:'cancelcombostoreId',
			       autoLoad: true,
				   fields: ['Name','Value'],
				   data: [['Reason1', '1'], ['Reason2', '2'],['Reason3', '3'],['Reason4', '4'],['Reason5', '5']]
			     });
    
    var reasonCanCombo = new Ext.form.ComboBox({
        store: selectCanComboStore,
        id:'selectCanComboId',
        mode: 'local',
        forceSelection: true,
        emptyText:'<%=selReasonCancel%>',
        blankText:'<%=selReasonCancel%>',
        selectOnFocus:true,
        hidden:true,
        allowBlank: false,
        anyMatch:true,
        typeAhead: false,
        triggerAction: 'all',
        lazyRender: true,
    	valueField: 'Value',
    	displayField: 'Name',
    	cls:'selectstyle'   
    });
 //*********************************combo for Group Name start**********// 
  var assogroupcombostore= new Ext.data.SimpleStore({
		id:'assogroupcombostoreId',
		autoLoad: true,
		fields: ['Name','Value'],
		data: [['Group1', '1'], ['Group2', '2'], ['Group3', '3']]
			                                        });
    
    var assoGroupCombo = new Ext.form.ComboBox({
        store: assogroupcombostore,
        id:'assogroupcomboId',
        mode: 'local',
        forceSelection: true,
        emptyText:'<%=selGrpName%>',
        blankText:'<%=selGrpName%>',
        selectOnFocus:true,
        allowBlank: false,
        anyMatch:true,
        typeAhead: false,
        triggerAction: 'all',
        lazyRender: true,
    	valueField: 'Value',
    	displayField: 'Name',
    	cls:'selectstyle'  
                                             });
    //*********************************combo for group name end*********


//*********************Manufacturer Combo start*************************
    var unitManuStore= new Ext.data.SimpleStore({
        id:'unitmanustoreId',
		autoLoad: true,
		fields: ['Name','Value'],
		data: [['Manufacturer1', '1'], ['Manufacturer1', '2'],['Manufacturer1', '3']]
			                      });
    
    var unitrefmanuCombo = new Ext.form.ComboBox({
        store:unitManuStore,
        id:'manucomid',
        mode: 'local',
        forceSelection: true,
        emptyText:'<%=selManuf%>',
        blankText:'<%=selManuf%>',
        selectOnFocus:true,
        allowBlank: false,
        anyMatch:true,
        typeAhead: false,
        triggerAction: 'all',
        lazyRender: false,
        lazyInit:false,
    	valueField: 'Value',
    	displayField: 'Name',
    	cls:'selectstyle'
        });
    //*********************Manufacturer Combo ends*************************
 

	
  //*********************************combo for select Unit no start********
  var assounitcombostore= new Ext.data.SimpleStore({
		id:'assounitcombostoreId',
		autoLoad: true,
		fields: ['Name','Value'],
		data: [['Add Unit', '1'],['Unit1', '2'], ['Unit2', '2'], ['Unit3', '3'],['NONE/REMOVE','4']]
		//data needs to be taken from db
			                                      });
    
    var assoUnitCombo = new Ext.form.ComboBox({
        store: assounitcombostore,
        id:'assounitcomboId',
        mode: 'local',
        forceSelection: true,
        emptyText:'<%=selUnitNo%>',
        blankText:'<%=selUnitNo%>',
        selectOnFocus:true,
        allowBlank: false,
        anyMatch:true,
        typeAhead: false,
        triggerAction: 'all',
        lazyRender: true,
    	valueField: 'Value',
    	displayField: 'Name',
    	cls:'selectstyle',
    	listeners: {
        select:function(field){
       if(buttonValue=="add"||buttonValue=="modify"){
             if(Ext.getCmp('assounitcomboId').getValue()== '1'){
            
                  Ext.getCmp('unitreginfo').show();
                 }
                 else{
                 Ext.getCmp('unitreginfo').hide();
                 }
                 }
                      }
}  
                                              });
   //*********************************combo for select unit no end*************


 //*********************************combo for select Unit no for deleting start********
  var assounitdeletestore= new Ext.data.SimpleStore({
		id:'assounitdeletestoreId',
		autoLoad: true,
		fields: ['Name','Value'],
		data: [['Unit1', '2'], ['Unit2', '2'], ['Unit3', '3']]
		//data needs to be taken from db
			                                      });
    
    var assoUnitforDelete = new Ext.form.ComboBox({
        store: assounitdeletestore,
        id:'assounitdeletecomboId',
        mode: 'local',
        forceSelection: true,
        emptyText:'<%=selUnitNo%>',
        blankText:'<%=selUnitNo%>',
        selectOnFocus:true,
        allowBlank: false,
        anyMatch:true,
        typeAhead: false,
        hidden:true,
        triggerAction: 'all',
        lazyRender: true,
    	valueField: 'Value',
    	displayField: 'Name',
    	cls:'selectstyle'
    	
                            });
   //*********************************combo for select unit no for deleting end*************
  //*********************************combo for select Mobile no start***********
  var assomobcombostore= new Ext.data.SimpleStore({
		id:'assomobcombostoreId',
		autoLoad: true,
		fields: ['Name','Value'],
		data: [['Add Mobile', '1'],['Mobile2', '2'], ['Mobile4', '4'], ['Mobile3', '3'],['NONE/REMOVE','5']]
			                                      });
    
    var assoMobCombo = new Ext.form.ComboBox({
        store: assomobcombostore,
        id:'assomobcomboId',
        mode: 'local',
        forceSelection: true,
        emptyText:'<%=selMobNo%>',
        blankText:'<%=selMobNo%>',
        selectOnFocus:true,
        allowBlank: false,
        anyMatch:true,
        typeAhead: false,
        triggerAction: 'all',
        lazyRender: true,
    	valueField: 'Value',
    	displayField: 'Name',
    	cls:'selectstyle' ,  
    	listeners: {
        select:function(field){
        if(buttonValue=="add"||buttonValue=="modify"){
             if(Ext.getCmp('assomobcomboId').getValue()== '1'){
                  Ext.getCmp('mobinfo').show();
                 }
              else{
              Ext.getCmp('mobinfo').hide();
              }   
              }
                      }
}
                                              });
 //**************************combo for select Mobile no end******************
 
  //*********************************combo for Delete Mobile no start***********
  var assomobdeletestore= new Ext.data.SimpleStore({
		id:'assomobdeletestoreId',
		autoLoad: true,
		fields: ['Name','Value'],
		data: [['Mobile2', '2'], ['Mobile4', '4'], ['Mobile3', '3']]
			                                      });
    
    var assoMobDeleteCombo = new Ext.form.ComboBox({
        store: assomobdeletestore,
        id:'assomobdeletecomboId',
        mode: 'local',
        forceSelection: true,
        emptyText:'<%=selMobNo%>',
        blankText:'<%=selMobNo%>',
        selectOnFocus:true,
        hidden:true,
        allowBlank: false,
        anyMatch:true,
        typeAhead: false,
        triggerAction: 'all',
        lazyRender: true,
    	valueField: 'Value',
    	displayField: 'Name',
    	cls:'selectstyle' 
    	
                                              });
 //**************************combo for Delete Mobile no end******************
 
 //**************************combo for select Registration start*******************
  var assoregcombostore= new Ext.data.SimpleStore({
			id:'assoregicombostoreId',
			autoLoad: true,
			fields: ['Name'],
			data: [['Reg1'],['Reg2'],['Reg3']]
			//data needs to be taken from DB
				                                });
    
    var assoRegCombo = new Ext.form.ComboBox({
	        store: assoregcombostore,
	        id:'assoregcomboId',
	        mode: 'local',
	        forceSelection: true,
	        hidden:true,
	        emptyText:'<%=selRegNo%>',
	        blankText:'<%=selRegNo%>',
	        selectOnFocus:true,
	        allowBlank: false,
	        anyMatch:true,
            typeAhead: false,
	        triggerAction: 'all',
	        lazyRender: true,
	    	valueField: 'Name',
	    	displayField: 'Name',
	    	cls:'selectstyle'   
    });
    //********************combo for select Registration end*************** 
 
 //**************************combo for select client start*******************
  //****store for getting customer name
  var assocuststore= new Ext.data.JsonStore({
			url:'<%=request.getContextPath()%>/CommonAction.do?param=getCustomer',
				   id:'CustomerStoreId',
			       root: 'CustomerRoot',
			       autoLoad: true,
			       remoteSort: true,
				   fields: ['CustId','CustName'],
				   listeners: {
    				load: function(store, records, success, options) {
        				 if(<%=hid%>){
				 			Ext.getCmp('assocustcomboId').setValue('<%=customerName%>');
				 		  }
    				}
    				}
	});
    
    var assoCustCombo = new Ext.form.ComboBox({
	        store: assocuststore,
	        id:'assocustcomboId',
	        mode: 'local',
	        forceSelection: true,
	        emptyText:'<%=selCust%>',
	        blankText:'<%=selCust%>',
	        selectOnFocus:true,
	        allowBlank: false,
	        anyMatch:true,
            typeAhead: false,
	        triggerAction: 'all',
	        lazyRender: true,
	    	valueField: 'CustId',
	    	displayField: 'CustName',
	    	cls:'selectstyle'   
    });
    //********************combo for select client end*************** 
    
    //**************************combo for select Type start*******************
  var assotypecombostore= new Ext.data.SimpleStore({
			id:'assotypecombostoreId',
			autoLoad: true,
			fields: ['Name','Value'],
			data: [['Asset', '1'], ['Unit', '2'], ['Mobile', '3']]
				                                });
    
    var assoDelTypeCombo = new Ext.form.ComboBox({
	        store: assotypecombostore,
	        id:'assotypecomboId',
	        mode: 'local',
	        forceSelection: true,
	        emptyText:'<%=selType%>',
	        blankText:'<%=selType%>',
	        hidden:true,
	        selectOnFocus:true,
	        allowBlank: false,
	        anyMatch:true,
            typeAhead: false,
	        triggerAction: 'all',
	        lazyRender: true,
	    	valueField: 'Value',
	    	displayField: 'Name',
	    	cls:'selectstyle',
	    	listeners: {
        	select:function(field){
        	
             if(Ext.getCmp('assotypecomboId').getValue()== '1'){
             Ext.getCmp('assoregcomlabid').show();Ext.getCmp('assoregcomboId').show();
             Ext.getCmp('assounitdellabid').hide();Ext.getCmp('assounitdeletecomboId').hide();
			 Ext.getCmp('mobdelId').hide();Ext.getCmp('assomobdeletecomboId').hide();
             Ext.getCmp('assoreasofcancid').show();Ext.getCmp('selectCanComboId').show();Ext.getCmp('delButtId').show();
             Ext.getCmp('addButtId').hide();   }
             else if(Ext.getCmp('assotypecomboId').getValue()== '2'){
             Ext.getCmp('assoregcomlabid').hide();Ext.getCmp('assoregcomboId').hide();
             Ext.getCmp('assounitdellabid').show();Ext.getCmp('assounitdeletecomboId').show();
			Ext.getCmp('mobdelId').hide();Ext.getCmp('assomobdeletecomboId').hide();
             Ext.getCmp('delButtId').show();
             Ext.getCmp('addButtId').hide();Ext.getCmp('assoreasofcancid').show();Ext.getCmp('selectCanComboId').show();
                 }
             else if(Ext.getCmp('assotypecomboId').getValue()== '3'){
             Ext.getCmp('assoregcomlabid').hide();Ext.getCmp('assoregcomboId').hide();
             Ext.getCmp('assounitdellabid').hide();Ext.getCmp('assounitdeletecomboId').hide();
			 Ext.getCmp('mobdelId').show();Ext.getCmp('assomobdeletecomboId').show();
             Ext.getCmp('delButtId').show();
             Ext.getCmp('addButtId').hide();Ext.getCmp('assoreasofcancid').show();Ext.getCmp('selectCanComboId').show();
                 }
                      }
}  
    });
    //********************combo for select Type end*************** 
    
    //panelone starts
  var innerpanel = new Ext.Panel({
		standardSubmit: true,
		frame:true,
		collapsible:false,
		cls:'innerpanel',
		id:'assopanone',
		layout:'table',
		layoutConfig: {
			columns:2
		},
		items: [{
					xtype: 'label',
					text: '<%=custName%> '+'  : ',
					cls:'labelstyle',
					id:'assoclientnameid'
				},
				assoCustCombo,
				{
					xtype: 'label',
					text: '<%=type%> '+'  : ',
					cls:'labelstyle',
					id:'assodeltypeid',
					hidden:true,
				},
				assoDelTypeCombo,
	    		
				{
					xtype: 'label',
					cls:'labelstyle',
					text: '<%=regNo%> '+'  :',
					id:'assogregtxtfid'
				},
				{
				    xtype:'textfield',
	    			cls:'textrnumberstyle',
	    			allowBlank: false,
	    			emptyText:'<%=entrRegNo%>',
	    			blankText :'<%=entrRegNo%>',
	    			regex:/^([a-zA-Z0-9]([a-zA-Z0-9-]*[a-zA-Z0-9])?)?$/,
	    			regexText:'<%=regRegex%>',
	    			id:'assoReg'
				},
				{
					xtype: 'label',
					cls:'labelstyle',
					hidden:true,
					text: '<%=regNo%> '+'  :',
					id:'assoregcomlabid'
				},assoRegCombo,
				{
					xtype: 'label',
					text: '<%=unitNo%> '+'  : ',
					cls:'labelstyle',
					id:'assounitlabid'
		        },
		        assoUnitCombo,
		        {
			        xtype:'fieldset', 
					title:'<%=unitReg%>',
					cls:'fieldsetpanel',
					collapsible: false,
					colspan:2,
					id:'unitreginfo',
			
					layout:'table',
					layoutConfig: {
						columns:2
				},
					items: [
					{
					xtype: 'label',
					text: '<%=deviceImei%> '+'  :',
					allowBlank: false,
					cls:'labelstyle'
				},
				{
					xtype:'textfield',
		    		cls:'textrnumberstyle',
		    		emptyText:'<%=deviceImei%>',
		    		blankText :'<%=deviceImei%>',
		    		allowBlank: false,
		    		id:'unitregdeviceid'
	    		},
	    		{
					xtype: 'label',
					text: '<%=manuf%> '+'  :',
					cls:'labelstyle'
					},unitrefmanuCombo,
				{
					xtype: 'label',
					text: '<%=deviceRefId%> '+'  :',
					cls:'labelstyle'
				},
				{
					xtype:'textfield',
		    		cls:'textrnumberstyle',
		    		emptyText:'<%=deviceRefId%>',
		    		blankText :'<%=deviceRefId%>',
		    		allowBlank: false,
		    		id:'devicereferenceid'
	    		}
				]
		        },
				{
					xtype: 'label',
					cls:'labelstyle',
					text: '<%=mobNo%> '+'  :',
					id:'assomoblabid'
				},
				assoMobCombo,
				{
					xtype:'fieldset', 
					title:'<%=mobInfo%>',
					cls:'fieldsetpanel',
					collapsible: false,
					colspan:2,
					id:'mobinfo',
					layout:'table',
					layoutConfig: {
						columns:2
				},
					items: [{
					xtype: 'label',
					text: '<%=mobNo%> '+'  :',
					cls:'labelstyle'
				},
				{
				
					xtype:'textfield',
		    		cls:'textrnumberstyle',
		    		allowBlank: false,
		    		emptyText:'<%=enterMobNo%>',
		    		blankText :'<%=enterMobNo%>',
		    		id:'mobileinfoid'
	    		},
	    		{
	    		
					xtype: 'label',
					text: '<%=simNo%> '+'  :',
					cls:'labelstyle'
				},
				{
				
					xtype:'textfield',
		    		cls:'textrnumberstyle',
		    		emptyText:'<%=enterSimNo%>',
		    		id:'simnoid'
	    		},
	    		{
	    		
					xtype: 'label',
					text: '<%=serviceProvider%> '+'  :',
					cls:'labelstyle'
				},
				{
					xtype:'textfield',
		    		cls:'textrnumberstyle',
		    		emptyText:'<%=enterSimSerProvider%>',
		    		id:'serviceproviderid'
	    		}
	    		]
				},
				{
					xtype: 'label',
					text: '<%=unitNo%> '+'  : ',
					cls:'labelstyle',
					hidden:true,
					id:'assounitdellabid'
		        },assoUnitforDelete,
				{
					xtype: 'label',
					text: '<%=mobNo%> '+'  :',
					id:'mobdelId',
					hidden:true,
					cls:'labelstyle'
				},assoMobDeleteCombo,
	    		{
					xtype: 'label',
					text: '<%=grpName%> '+'  : ',
					cls:'labelstyle',
					id:'assogrplabid'
				},
				assoGroupCombo,
				{
				xtype: 'label',
				allowBlank: false,
				text: '<%=reasonCancel%> '+'  :',
				cls:'labelstyle',
				hidden:true,
				id:'assoreasofcancid',
				},reasonCanCombo,{},
				{
	       			xtype:'button',
	      			text:'<%=submit%>',
	        		id:'addButtId',
	        		cls:' ',
	        		width:80,
	       			listeners: 
	       			{
	        			click:
	        			{
	       					fn:function()
	       					{
	        				 //Action for Button
	        				 if(buttonValue=="add"){
	        				 
							if(Ext.getCmp('assocustcomboId').getValue()== "")
								        {
								        ctsb.setStatus({
								        text:getMessageForStatus("<%=selCust%>"),
								        iconCls:'',
										clear:true
								        });
								        Ext.getCmp('assocustcomboId').focus();
								        return;
								        }
								        
								if(Ext.getCmp('assoReg').getValue() == "" )
									    {
								             ctsb.setStatus({
											 text: getMessageForStatus("<%=entrRegNo%>"), 
											 iconCls:'',
											 clear: true
					                       	 });
					                       	 Ext.getCmp('assoReg').focus();
					                       	 return;
									    }
								if(Ext.getCmp('assounitcomboId').getValue()== "")	
										{
										ctsb.setStatus({
										text:getMessageForStatus("<%=selUnitNo%>"),
										iconCls:'',
										clear:true
										});
										Ext.getCmp('assounitcomboId').focus();
										return;
										}
										
				if(Ext.getCmp('assounitcomboId').getValue()== "1"){
				              if(Ext.getCmp('unitregdeviceid').getValue()== "")	
										{
										ctsb.setStatus({
										text:getMessageForStatus("<%=deviceImei%>"),
										iconCls:'',
										clear:true
										});
										Ext.getCmp('unitregdeviceid').focus();
										return;
										}
							  if(Ext.getCmp('manucomid').getValue()== "")	
										{
										ctsb.setStatus({
										text:getMessageForStatus("<%=selManuf%>"),
										iconCls:'',
										clear:true
										});
										Ext.getCmp('manucomid').focus();
										return;
										}
							 if(Ext.getCmp('devicereferenceid').getValue()== "")	
										{
										ctsb.setStatus({
										text:getMessageForStatus("<%=deviceRefId%>"),
										iconCls:'',
										clear:true
										});
										Ext.getCmp('devicereferenceid').focus();
										return;
										} 
				
				
				}
								if(Ext.getCmp('assomobcomboId').getValue()== "")	
										{
										ctsb.setStatus({
										text:getMessageForStatus("<%=selMobNo%>"),
										iconCls:'',
										clear:true
										});
										Ext.getCmp('assomobcomboId').focus();
										return;
										}  
										
				if(Ext.getCmp('assomobcomboId').getValue()== "1"){
				              if(Ext.getCmp('mobileinfoid').getValue()== "")	
										{
										ctsb.setStatus({
										text:getMessageForStatus("<%=enterMobNo%>"),
										iconCls:'',
										clear:true
										});
										Ext.getCmp('mobileinfoid').focus();
										return;
										}
							 				
				
				}			
										
								if(Ext.getCmp('assogroupcomboId').getValue()== "")	
										{
										ctsb.setStatus({
										text:getMessageForStatus("<%=selGrpName%>"),
										iconCls:'',
										clear:true
										});
										Ext.getCmp('assogroupcomboId').focus();
										return;
										}     	
																   	
										//showing message
									    ctsb.showBusy('<%=saveForm%>');
										outerPanel.getEl().mask();						
									    window.scrollTo(0,0);
									//AJAX CALL		 
					Ext.Ajax.request({
					 				url: '<%=request.getContextPath()%>/AssetAssociationAction.do?param=saveAssetAssociationDetails',
									method: 'POST',
									params: 
									{ 
										 custName:Ext.getCmp('assocustcomboId').getValue(),
							         	 regNo:Ext.getCmp('assoReg').getValue(),
							         	 unitNo:Ext.getCmp('assounitcomboId').getValue(),
							         	 deviceimei:Ext.getCmp('unitregdeviceid').getValue(),
							         	 manufacturer:Ext.getCmp('manucomid').getValue(),
							         	 deviceReferenceId:Ext.getCmp('devicereferenceid').getValue(),
							         	 mobileComboNo:Ext.getCmp('assomobcomboId').getValue(),
							         	 mobileNo:Ext.getCmp('mobileinfoid').getValue(),
							         	 simNo:Ext.getCmp('simnoid').getValue(),
							         	 serviceProvider:Ext.getCmp('serviceproviderid').getValue(),
							         	 groupName:Ext.getCmp('assogroupcomboId').getValue()
							         	 
							         },
									success:function(response, options)//start of success
									{
										  ctsb.setStatus({
													 text:getMessageForStatus(response.responseText), 
													 iconCls:'',
													 clear: true
								                     });
								          Ext.getCmp('assocustcomboId').reset();
										  Ext.getCmp('assoReg').reset();
										  Ext.getCmp('assounitcomboId').reset();
										  Ext.getCmp('unitregdeviceid').reset();
										  Ext.getCmp('manucomid').reset();
										  Ext.getCmp('devicereferenceid').reset();
										  Ext.getCmp('assomobcomboId').reset();
										  Ext.getCmp('mobileinfoid').reset();
										  Ext.getCmp('simnoid').reset();
										  Ext.getCmp('serviceproviderid').reset();
										  Ext.getCmp('assogroupcomboId').reset();
										  
										  outerPanel.getEl().unmask();
									}, // END OF  SUCCESS
								    failure: function()//start of failure 
								    {
								    	  ctsb.setStatus({
													 text:getMessageForStatus("error"), 
													 iconCls:'',
													 clear: true
								                     });
									       Ext.getCmp('assocustcomboId').reset();
										  Ext.getCmp('assoReg').reset();
										  Ext.getCmp('assounitcomboId').reset();
										  Ext.getCmp('unitregdeviceid').reset();
										  Ext.getCmp('manucomid').reset();
										  Ext.getCmp('devicereferenceid').reset();
										  Ext.getCmp('assomobcomboId').reset();
										  Ext.getCmp('mobileinfoid').reset();
										  Ext.getCmp('simnoid').reset();
										  Ext.getCmp('serviceproviderid').reset();
										  Ext.getCmp('assogroupcomboId').reset();
										  outerPanel.getEl().unmask();
									} // END OF FAILURE 
						}); // END OF AJAX		 
									   
									}
         
         if(buttonValue=="modify"){
         
         
         if(Ext.getCmp('assocustcomboId').getValue()== "")
								        {
								        ctsb.setStatus({
								        text:getMessageForStatus("<%=selCust%>"),
								        iconCls:'',
										clear:true
								        });
								        Ext.getCmp('assocustcomboId').focus();
								        return;
								        }
								        
								if(Ext.getCmp('assoregcomboId').getValue() == "" )
									    {
								             ctsb.setStatus({
											 text: getMessageForStatus("<%=selRegNo%>"), 
											 iconCls:'',
											 clear: true
					                       	 });
					                       	 Ext.getCmp('assoregcomboId').focus();
					                       	 return;
									    }
								if(Ext.getCmp('assounitcomboId').getValue()== "")	
										{
										ctsb.setStatus({
										text:getMessageForStatus("<%=selUnitNo%>"),
										iconCls:'',
										clear:true
										});
										Ext.getCmp('assounitcomboId').focus();
										return;
										}
										
				if(Ext.getCmp('assounitcomboId').getValue()== "1"){
				              if(Ext.getCmp('unitregdeviceid').getValue()== "")	
										{
										ctsb.setStatus({
										text:getMessageForStatus("<%=deviceImei%>"),
										iconCls:'',
										clear:true
										});
										Ext.getCmp('unitregdeviceid').focus();
										return;
										}
							  if(Ext.getCmp('manucomid').getValue()== "")	
										{
										ctsb.setStatus({
										text:getMessageForStatus("<%=selManuf%>"),
										iconCls:'',
										clear:true
										});
										Ext.getCmp('manucomid').focus();
										return;
										}
							 if(Ext.getCmp('devicereferenceid').getValue()== "")	
										{
										ctsb.setStatus({
										text:getMessageForStatus("<%=deviceRefId%>"),
										iconCls:'',
										clear:true
										});
										Ext.getCmp('devicereferenceid').focus();
										return;
										} 
				
				
				}
								if(Ext.getCmp('assomobcomboId').getValue()== "")	
										{
										ctsb.setStatus({
										text:getMessageForStatus("<%=selMobNo%>"),
										iconCls:'',
										clear:true
										});
										Ext.getCmp('assomobcomboId').focus();
										return;
										}  
										
				if(Ext.getCmp('assomobcomboId').getValue()== "1"){
				              if(Ext.getCmp('mobileinfoid').getValue()== "")	
										{
										ctsb.setStatus({
										text:getMessageForStatus("<%=enterMobNo%>"),
										iconCls:'',
										clear:true
										});
										Ext.getCmp('mobileinfoid').focus();
										return;
										}
							 				
				
				}			
										
								if(Ext.getCmp('assogroupcomboId').getValue()== "")	
										{
										ctsb.setStatus({
										text:getMessageForStatus("<%=selGrpName%>"),
										iconCls:'',
										clear:true
										});
										Ext.getCmp('assogroupcomboId').focus();
										return;
										}     	
																   	
										//showing message
									    ctsb.showBusy('<%=saveForm%>');
										outerPanel.getEl().mask();	
										window.scrollTo(0,0);
         
         //AJAX CALL		 
					Ext.Ajax.request({
					 				url: '<%=request.getContextPath()%>/AssetAssociationAction.do?param=modifyAssetAssociationDetails',
									method: 'POST',
									params: 
									{ 
										 custName:Ext.getCmp('assocustcomboId').getValue(),
							         	 regNo:Ext.getCmp('assoregcomboId').getValue(),
							         	 unitNo:Ext.getCmp('assounitcomboId').getValue(),
							         	 deviceimei:Ext.getCmp('unitregdeviceid').getValue(),
							         	 manufacturer:Ext.getCmp('manucomid').getValue(),
							         	 deviceReferenceId:Ext.getCmp('devicereferenceid').getValue(),
							         	 mobileComboNo:Ext.getCmp('assomobcomboId').getValue(),
							         	 mobileNo:Ext.getCmp('mobileinfoid').getValue(),
							         	 simNo:Ext.getCmp('simnoid').getValue(),
							         	 serviceProvider:Ext.getCmp('serviceproviderid').getValue(),
							         	 groupName:Ext.getCmp('assogroupcomboId').getValue()
							         	 
							         },
									success:function(response, options)//start of success
									{
										  ctsb.setStatus({
													 text:getMessageForStatus(response.responseText), 
													 iconCls:'',
													 clear: true
								                     });
								          Ext.getCmp('assocustcomboId').reset();
										  Ext.getCmp('assoregcomboId').reset();
										  Ext.getCmp('assounitcomboId').reset();
										  Ext.getCmp('unitregdeviceid').reset();
										  Ext.getCmp('manucomid').reset();
										  Ext.getCmp('devicereferenceid').reset();
										  Ext.getCmp('assomobcomboId').reset();
										  Ext.getCmp('mobileinfoid').reset();
										  Ext.getCmp('simnoid').reset();
										  Ext.getCmp('serviceproviderid').reset();
										  Ext.getCmp('assogroupcomboId').reset();
										  
										  outerPanel.getEl().unmask();
									}, // END OF  SUCCESS
								    failure: function()//start of failure 
								    {
								    	  ctsb.setStatus({
													 text:getMessageForStatus("error"), 
													 iconCls:'',
													 clear: true
								                     });
									       Ext.getCmp('assocustcomboId').reset();
										  Ext.getCmp('assoregcomboId').reset();
										  Ext.getCmp('assounitcomboId').reset();
										  Ext.getCmp('unitregdeviceid').reset();
										  Ext.getCmp('manucomid').reset();
										  Ext.getCmp('devicereferenceid').reset();
										  Ext.getCmp('assomobcomboId').reset();
										  Ext.getCmp('mobileinfoid').reset();
										  Ext.getCmp('simnoid').reset();
										  Ext.getCmp('serviceproviderid').reset();
										  Ext.getCmp('assogroupcomboId').reset();
										  outerPanel.getEl().unmask();
									} // END OF FAILURE 
						}); // END OF AJAX
         
         
         
         
         }	        					
	
	
	
	
	
	      					} 
	       				} 
	       			} 
       			},{cls:'labelstyle'},
       			{
	       			xtype:'button',
	      			text:'<%=delete%>',
	        		id:'delButtId',
	        		cls:' ',
	        		hidden:true,
	        		width:80,
	       			listeners: 
	       			{
	        			click:
	        			{
	       					fn:function()
	       					{
										 if(Ext.getCmp('assocustcomboId').getValue()== "")
								        {
								        ctsb.setStatus({
								        text:getMessageForStatus("<%=selCust%>"),
								        iconCls:'',
										clear:true
								        });
								        Ext.getCmp('assocustcomboId').focus();
								        return;
								        }
								 
								 if(Ext.getCmp('assotypecomboId').getValue()== "")
								        {
								        ctsb.setStatus({
								        text:getMessageForStatus("<%=selType%>"),
								        iconCls:'',
										clear:true
								        });
								        Ext.getCmp('assotypecomboId').focus();
								        return;
								        }
								     
								
						if(Ext.getCmp('assotypecomboId').getValue()== "1"){
						
								if(Ext.getCmp('assoregcomboId').getValue()== "")
									    {
								             ctsb.setStatus({
											 text: getMessageForStatus("<%=selRegNo%>"), 
											 iconCls:'',
											 clear: true
					                       	 });
					                       	 Ext.getCmp('assoregcomboId').focus();
					                       	 return;
									    }
						}
						
					else if(Ext.getCmp('assotypecomboId').getValue()== "3"){
						
							     if(Ext.getCmp('assomobdeletecomboId').getValue()== "")	
										{
										ctsb.setStatus({
										text:getMessageForStatus("<%=selMobNo%>"),
										iconCls:'',
										clear:true
										});
										Ext.getCmp('assomobdeletecomboId').focus();
										return;
										}  
						}
						
					else if(Ext.getCmp('assotypecomboId').getValue()== "2"){
						
								if(Ext.getCmp('assounitdeletecomboId').getValue()== "")	
										{
										ctsb.setStatus({
										text:getMessageForStatus("<%=selUnitNo%>"),
										iconCls:'',
										clear:true
										});
										Ext.getCmp('assounitdeletecomboId').focus();
										return;
										}
						}
						
					if(Ext.getCmp('selectCanComboId').getValue()== "")	
										{
										ctsb.setStatus({
										text:getMessageForStatus("<%=selReasonCancel%>"),
										iconCls:'',
										clear:true
										});
										Ext.getCmp('selectCanComboId').focus();
										return;
										}
										
										
										
						//showing message
									    ctsb.showBusy('<%=deleting%>');
										outerPanel.getEl().mask();	
										window.scrollTo(0,0);
										
						//AJAX CALL
						Ext.Ajax.request({
					 				url: '<%=request.getContextPath()%>/AssetAssociationAction.do?param=deleteAssetAssociationDetails',
									method: 'POST',
									params: 
									{ 
										 custName:Ext.getCmp('assocustcomboId').getValue(),
										 assetType:Ext.getCmp('assotypecomboId').getValue(),
							         	 unitNo:Ext.getCmp('assounitdeletecomboId').getValue(),
							         	 regCombo:Ext.getCmp('assoregcomboId').getValue(),
							         	 mobileComboNo:Ext.getCmp('assomobdeletecomboId').getValue(),
							         	 reasonForCan:Ext.getCmp('selectCanComboId').getValue()
							         	 
							         },
									success:function(response, options)//start of success
									{
										  ctsb.setStatus({
													 text:getMessageForStatus(response.responseText), 
													 iconCls:'',
													 clear: true
								                     });
								          Ext.getCmp('assocustcomboId').reset();
										  Ext.getCmp('assotypecomboId').reset();
										  Ext.getCmp('assounitdeletecomboId').reset();
										  Ext.getCmp('assoregcomboId').reset();
										  Ext.getCmp('assomobdeletecomboId').reset();
										  Ext.getCmp('selectCanComboId').reset();
										  
										  
										  outerPanel.getEl().unmask();
									}, // END OF  SUCCESS
								    failure: function()//start of failure 
								    {
								    	  ctsb.setStatus({
													 text:getMessageForStatus("error"), 
													 iconCls:'',
													 clear: true
								                     });
									      Ext.getCmp('assocustcomboId').reset();
										  Ext.getCmp('assotypecomboId').reset();
										  Ext.getCmp('assounitdeletecomboId').reset();
										  Ext.getCmp('assoregcomboId').reset();
										  Ext.getCmp('assomobdeletecomboId').reset();
										  Ext.getCmp('selectCanComboId').reset();
										  outerPanel.getEl().unmask();
									} // END OF FAILURE 
						}); // END OF AJAX				
										
										
						
				
	      					} 
	       				} 
	       			} 
       			}
				
				
				
				]
			}); 
	//panelone ends------
	
	//*** Main starts from here*************************
 Ext.onReady(function(){
   ctsb=tsb;
   panel1=pageModifyPanel;			
   Ext.QuickTips.init();
   Ext.form.Field.prototype.msgTarget = 'side';		
          			   			         	   			
 outerPanel = new Ext.Panel({
			title:'<%=association%>',
			renderTo : 'content',
			standardSubmit: true,
			frame:true,
			cls:'mainpanel',
			//layout:'fit',
			items: [panel1,innerpanel],
			tbar: ctsb			
			});  
			 Ext.getCmp('unitreginfo').hide();
			  Ext.getCmp('mobinfo').hide();
			 if(<%=hid%>){
			 buttonValue="modify";
			 Ext.getCmp('pagemodiadd').hide();
			 Ext.getCmp('pagemodiadd').disable();
			 Ext.getCmp('assogregtxtfid').hide();Ext.getCmp('assoReg').hide();
			 Ext.getCmp('assoregcomlabid').show();Ext.getCmp('assoregcomboId').show();
			 }
			Ext.getCmp('pagemodimodify').on("click", function(){
			buttonValue="modify";
			Ext.getCmp('assodeltypeid').hide();Ext.getCmp('assotypecomboId').hide();
			Ext.getCmp('assoclientnameid').show();Ext.getCmp('assocustcomboId').show();
			Ext.getCmp('assogregtxtfid').hide();Ext.getCmp('assoReg').hide();
			Ext.getCmp('assoregcomlabid').show();Ext.getCmp('assoregcomboId').show();
			Ext.getCmp('assounitlabid').show();Ext.getCmp('assounitcomboId').show();
			Ext.getCmp('assomoblabid').show();Ext.getCmp('assomobcomboId').show();
			Ext.getCmp('assogrplabid').show();Ext.getCmp('assogroupcomboId').show();
			Ext.getCmp('mobinfo').hide(); Ext.getCmp('unitreginfo').hide();
			Ext.getCmp('assoreasofcancid').hide();Ext.getCmp('selectCanComboId').hide();
			Ext.getCmp('assounitdellabid').hide();Ext.getCmp('assounitdeletecomboId').hide();
			Ext.getCmp('mobdelId').hide();Ext.getCmp('assomobdeletecomboId').hide();
			Ext.getCmp('delButtId').hide(); Ext.getCmp('addButtId').show();
			if(<%=hid%>){
			
			Ext.getCmp('assotypecomboId').reset();
			Ext.getCmp('assounitcomboId').reset();
			Ext.getCmp('assomobcomboId').reset();
			Ext.getCmp('assoReg').reset();
			Ext.getCmp('mobileinfoid').reset();
			Ext.getCmp('simnoid').reset();
			Ext.getCmp('serviceproviderid').reset();
			Ext.getCmp('unitregdeviceid').reset();
			Ext.getCmp('assomobcomboId').reset();
			Ext.getCmp('devicereferenceid').reset();
			Ext.getCmp('assogroupcomboId').reset();
			Ext.getCmp('manucomid').reset();
			}else{
			Ext.getCmp('assocustcomboId').reset();
			Ext.getCmp('assotypecomboId').reset();
			Ext.getCmp('assoregcomboId').reset();
			Ext.getCmp('assounitcomboId').reset();
			Ext.getCmp('assomobcomboId').reset();
			Ext.getCmp('assoReg').reset();
			Ext.getCmp('mobileinfoid').reset();
			Ext.getCmp('simnoid').reset();
			Ext.getCmp('serviceproviderid').reset();
			Ext.getCmp('unitregdeviceid').reset();
			Ext.getCmp('assomobcomboId').reset();
			Ext.getCmp('devicereferenceid').reset();
			Ext.getCmp('assogroupcomboId').reset();
			Ext.getCmp('manucomid').reset();
			}
			});
			
			Ext.getCmp('pagemodiadd').on("click", function () { 
			buttonValue="add";
			Ext.getCmp('assodeltypeid').hide();Ext.getCmp('assotypecomboId').hide();
			Ext.getCmp('assoclientnameid').show();Ext.getCmp('assocustcomboId').show();
			Ext.getCmp('assoregcomlabid').hide();Ext.getCmp('assoregcomboId').hide();
			Ext.getCmp('assogregtxtfid').show();Ext.getCmp('assoReg').show();
			Ext.getCmp('assounitlabid').show();Ext.getCmp('assounitcomboId').show();
			Ext.getCmp('assomoblabid').show();Ext.getCmp('assomobcomboId').show();
			Ext.getCmp('assogrplabid').show();Ext.getCmp('assogroupcomboId').show();
			Ext.getCmp('mobinfo').hide(); Ext.getCmp('unitreginfo').hide();
			Ext.getCmp('assoreasofcancid').hide();Ext.getCmp('selectCanComboId').hide();
			Ext.getCmp('assounitdellabid').hide();Ext.getCmp('assounitdeletecomboId').hide();
			Ext.getCmp('mobdelId').hide();Ext.getCmp('assomobdeletecomboId').hide();
			Ext.getCmp('delButtId').hide(); Ext.getCmp('addButtId').show();
			Ext.getCmp('assocustcomboId').reset();
			Ext.getCmp('assotypecomboId').reset();
			Ext.getCmp('assoregcomboId').reset();
			Ext.getCmp('assounitcomboId').reset();
			Ext.getCmp('assomobcomboId').reset();
			Ext.getCmp('assoReg').reset();
			Ext.getCmp('mobileinfoid').reset();
			Ext.getCmp('simnoid').reset();
			Ext.getCmp('serviceproviderid').reset();
			Ext.getCmp('unitregdeviceid').reset();
			Ext.getCmp('assomobcomboId').reset();
			Ext.getCmp('devicereferenceid').reset();
			Ext.getCmp('assogroupcomboId').reset();
			Ext.getCmp('manucomid').reset();
		    });
			
			Ext.getCmp('pagemodidelete').on("click", function(){
			buttonValue="delete";
			Ext.getCmp('assoclientnameid').show();Ext.getCmp('assocustcomboId').show();
			Ext.getCmp('assodeltypeid').show();Ext.getCmp('assotypecomboId').show();
			Ext.getCmp('assoregcomlabid').hide();Ext.getCmp('assoregcomboId').hide();
			Ext.getCmp('assogregtxtfid').hide();Ext.getCmp('assoReg').hide();
			Ext.getCmp('assounitlabid').hide();Ext.getCmp('assounitcomboId').hide();
			Ext.getCmp('assomoblabid').hide();Ext.getCmp('assomobcomboId').hide();
			Ext.getCmp('assogrplabid').hide();Ext.getCmp('assogroupcomboId').hide();
			Ext.getCmp('mobinfo').hide(); Ext.getCmp('unitreginfo').hide();
			Ext.getCmp('assoreasofcancid').hide();Ext.getCmp('selectCanComboId').hide();
			Ext.getCmp('assounitdellabid').hide();Ext.getCmp('assounitdeletecomboId').hide();
			Ext.getCmp('mobdelId').hide();Ext.getCmp('assomobdeletecomboId').hide();
			Ext.getCmp('delButtId').show(); Ext.getCmp('addButtId').hide();
			Ext.getCmp('assocustcomboId').reset();
			Ext.getCmp('assotypecomboId').reset();
			Ext.getCmp('assoregcomboId').reset();
			Ext.getCmp('assounitdeletecomboId').reset();
			Ext.getCmp('assomobdeletecomboId').reset();
			Ext.getCmp('selectCanComboId').reset();
			});
			
			 if(<%=hid%>){
			 
			 Ext.getCmp('assoregcomboId').setValue('<%=registrationNO%>');
			 }
			  
	});

   
   </script>
  </body>
</html>
