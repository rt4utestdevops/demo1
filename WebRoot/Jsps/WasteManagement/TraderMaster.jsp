<%@ page  language="java" import="java.util.*,t4u.functions.CommonFunctions,t4u.beans.*,t4u.common.*" pageEncoding="utf-8"%>
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
	session.setAttribute("loginInfoDetails",loginInfo);
}
CommonFunctions cf=new CommonFunctions();
cf.checkLoginInfo((LoginInfoBean)session.getAttribute("loginInfoDetails"),session,request,response);
LoginInfoBean loginInfo=(LoginInfoBean)session.getAttribute("loginInfoDetails");
String language=loginInfo.getLanguage();
int customeridlogged=loginInfo.getCustomerId();
//getting hashmap with language specific words
HashMap langConverted=ApplicationListener.langConverted;
LanguageWordsBean lwb=null;

//Getting words based on language 

String SelectCustomer;
lwb=(LanguageWordsBean)langConverted.get("Select_Customer");
if(language.equals("ar")){
	SelectCustomer=lwb.getArabicWord();
}else{
	SelectCustomer=lwb.getEnglishWord();
}
lwb=null;
String TraderMaster;
lwb=(LanguageWordsBean)langConverted.get("Trader_Master");
if(language.equals("ar")){
	TraderMaster=lwb.getArabicWord();
}else{
	TraderMaster=lwb.getEnglishWord();
}
lwb=null;
String SelectTrader;
lwb=(LanguageWordsBean)langConverted.get("Select_Trader");
if(language.equals("ar")){
	SelectTrader=lwb.getArabicWord();
}else{
	SelectTrader=lwb.getEnglishWord();
}
lwb=null;
String SelectStatus;
lwb=(LanguageWordsBean)langConverted.get("Select_Status");
if(language.equals("ar")){
	SelectStatus=lwb.getArabicWord();
}else{
	SelectStatus=lwb.getEnglishWord();
}
lwb=null;
String CustomerName;
lwb=(LanguageWordsBean)langConverted.get("Customer_Name");
if(language.equals("ar")){
	CustomerName=lwb.getArabicWord();
}else{
	CustomerName=lwb.getEnglishWord();
}
lwb=null;
String TraderName;
lwb=(LanguageWordsBean)langConverted.get("Licence_holder_name");
if(language.equals("ar")){
	TraderName=lwb.getArabicWord();
}else{
	TraderName=lwb.getEnglishWord();
}
lwb=null;
String Address;
lwb=(LanguageWordsBean)langConverted.get("Address");
if(language.equals("ar")){
	Address=lwb.getArabicWord();
}else{
	Address=lwb.getEnglishWord();
}
lwb=null;
String NewTraderName;
lwb=(LanguageWordsBean)langConverted.get("New_Trader_Name");
if(language.equals("ar")){
	NewTraderName=lwb.getArabicWord();
}else{
	NewTraderName=lwb.getEnglishWord();
}
lwb=null;
String EnterTraderName;
lwb=(LanguageWordsBean)langConverted.get("Enter_Trader_Name");
if(language.equals("ar")){
	EnterTraderName=lwb.getArabicWord();
}else{
	EnterTraderName=lwb.getEnglishWord();
}
lwb=null;
String LicNo;
lwb=(LanguageWordsBean)langConverted.get("Lic_No");
if(language.equals("ar")){
	LicNo=lwb.getArabicWord();
}else{
	LicNo=lwb.getEnglishWord();
}
lwb=null;
String EnterLicNo;
lwb=(LanguageWordsBean)langConverted.get("Enter_Lic_No");
if(language.equals("ar")){
	EnterLicNo=lwb.getArabicWord();
}else{
	EnterLicNo=lwb.getEnglishWord();
}
lwb=null;
String EnterAddress;
lwb=(LanguageWordsBean)langConverted.get("Enter_Address");
if(language.equals("ar")){
	EnterAddress=lwb.getArabicWord();
}else{
	EnterAddress=lwb.getEnglishWord();
}
lwb=null;
String Trade;
lwb=(LanguageWordsBean)langConverted.get("Trade");
if(language.equals("ar")){
	Trade=lwb.getArabicWord();
}else{
	Trade=lwb.getEnglishWord();
}
lwb=null;
String EnterTrade;
lwb=(LanguageWordsBean)langConverted.get("Enter_Trade");
if(language.equals("ar")){
	EnterTrade=lwb.getArabicWord();
}else{
	EnterTrade=lwb.getEnglishWord();
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
String EnterTradeName;
lwb=(LanguageWordsBean)langConverted.get("Enter_Trade_Name");
if(language.equals("ar")){
	EnterTradeName=lwb.getArabicWord();
}else{
	EnterTradeName=lwb.getEnglishWord();
}
lwb=null;
String DoorNo;
lwb=(LanguageWordsBean)langConverted.get("Door_No");
if(language.equals("ar")){
	DoorNo=lwb.getArabicWord();
}else{
	DoorNo=lwb.getEnglishWord();
}
lwb=null;
String EnterDoorNo;
lwb=(LanguageWordsBean)langConverted.get("Enter_Door_No");
if(language.equals("ar")){
	EnterDoorNo=lwb.getArabicWord();
}else{
	EnterDoorNo=lwb.getEnglishWord();
}
lwb=null;
String WardName;
lwb=(LanguageWordsBean)langConverted.get("Ward_Name");
if(language.equals("ar")){
	WardName=lwb.getArabicWord();
}else{
	WardName=lwb.getEnglishWord();
}
lwb=null;
String EnterWardName;
lwb=(LanguageWordsBean)langConverted.get("Enter_Ward_Name");
if(language.equals("ar")){
	EnterWardName=lwb.getArabicWord();
}else{
	EnterWardName=lwb.getEnglishWord();
}
lwb=null;
String WardNo;
lwb=(LanguageWordsBean)langConverted.get("Ward_No");
if(language.equals("ar")){
	WardNo=lwb.getArabicWord();
}else{
	WardNo=lwb.getEnglishWord();
}
lwb=null;
String EnterWardNo;
lwb=(LanguageWordsBean)langConverted.get("Enter_Ward_No");
if(language.equals("ar")){
	EnterWardNo=lwb.getArabicWord();
}else{
	EnterWardNo=lwb.getEnglishWord();
}
lwb=null;
String Area;
lwb=(LanguageWordsBean)langConverted.get("Area");
if(language.equals("ar")){
	Area=lwb.getArabicWord();
}else{
	Area=lwb.getEnglishWord();
}
lwb=null;
String EnterArea;
lwb=(LanguageWordsBean)langConverted.get("Enter_Area");
if(language.equals("ar")){
	EnterArea=lwb.getArabicWord();
}else{
	EnterArea=lwb.getEnglishWord();
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
String EnterMobileNo;
lwb=(LanguageWordsBean)langConverted.get("Enter_Mobile_No");
if(language.equals("ar")){
	EnterMobileNo=lwb.getArabicWord();
}else{
	EnterMobileNo=lwb.getEnglishWord();
}
lwb=null;
String RfidCode;
lwb=(LanguageWordsBean)langConverted.get("Rfid_Code");
if(language.equals("ar")){
	RfidCode=lwb.getArabicWord();
}else{
	RfidCode=lwb.getEnglishWord();
}
lwb=null;
String EnterRfidCode;
lwb=(LanguageWordsBean)langConverted.get("Enter_Rfid_Code");
if(language.equals("ar")){
	EnterRfidCode=lwb.getArabicWord();
}else{
	EnterRfidCode=lwb.getEnglishWord();
}
lwb=null;
String Status;
lwb=(LanguageWordsBean)langConverted.get("Status");
if(language.equals("ar")){
	Status=lwb.getArabicWord();
}else{
	Status=lwb.getEnglishWord();
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
String Delete;
lwb=(LanguageWordsBean)langConverted.get("Delete");
if(language.equals("ar")){
	Delete=lwb.getArabicWord();
}else{
	Delete=lwb.getEnglishWord();
}
lwb=null;
String Areyousureyouwanttodelete;
lwb=(LanguageWordsBean)langConverted.get("Are_you_sure_you_want_to_delete");
if(language.equals("ar")){
	Areyousureyouwanttodelete=lwb.getArabicWord();
}else{
	Areyousureyouwanttodelete=lwb.getEnglishWord();
}
lwb=null;
String Deleting;
lwb=(LanguageWordsBean)langConverted.get("Deleting");
if(language.equals("ar")){
	Deleting=lwb.getArabicWord();
}else{
	Deleting=lwb.getEnglishWord();
}
lwb=null;
langConverted=null;
%>

<!DOCTYPE HTML>
<html class="largehtml">
 <head>
 
		<title><%=TraderMaster%></title>		
	</head>	    
  
  <body class="largebody" onload="refresh();">
   	<%if (loginInfo.getStyleSheetOverride().equals("Y")){%>
	<jsp:include page="../Common/ImportJSSandMining.jsp"/>
	<%}else {%>
	<jsp:include page="../Common/ImportJS.jsp" /><%} %>
	<style>
	.ext-strict .x-form-text {
		height: 15px !important;
	}
	</style>
   <script>
 var outerPanel;
 var ctsb;
 var panel1;	
 var buttonvalue="add";   
 //In chrome activate was slow so refreshing the page
 function refresh()
                 {
                 isChrome = window.chrome;
					if(isChrome && parent.flagwaste<2) {
					// is chrome
						              setTimeout(function(){
						              parent.Ext.getCmp('tradermasterTab').enable();
									  parent.Ext.getCmp('tradermasterTab').show();
						              parent.Ext.getCmp('tradermasterTab').update("<iframe style='width:100%;height:600px;border:0;'src='<%=path%>/Jsps/WasteManagement/TraderMaster.jsp'></iframe>");
						              },0);
						              parent.WasteManagementTab.doLayout();
						              parent.flagwaste= parent.flagwaste+1;
					} 
                 }
                 /********************resize window event function***********************/
   Ext.EventManager.onWindowResize(function () {
   				var width = '99%';
			    var height = '99%';
			    outerPanel.setSize(width, height);
			    outerPanel.doLayout();
	});
 //************************TraderDetails Store For Modify*****************************************
 var traderdetailsstore= new Ext.data.JsonStore({
			url:'<%=request.getContextPath()%>/TraderAction.do?param=getTraderDetails',
				   id:'TraderDetailsStoreId',
			       root: 'TraderDetailsRoot',
			       autoLoad: false,
				   fields: ['Licence_No', 'Address', 'Trade', 'Trade_Name', 'Door_No', 'Ward_Name', 'Ward_No', 'Area', 'Mobile_No', 'Rfid_Code', 'Status']
	}); 
 
    //****store for getting trader name
  var tradercombostore= new Ext.data.JsonStore({
			url:'<%=request.getContextPath()%>/TraderAction.do?param=getTrader',
				   id:'TraderStoreId',
			       root: 'TraderRoot',
			       autoLoad: false,
			       remoteSort: true,
				   fields: ['TraderId','TraderName']
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
		                 	      Ext.getCmp('newtradername').reset();
								  Ext.getCmp('tradercomboId').reset();
								  Ext.getCmp('licno').reset();Ext.getCmp('addrs').reset();
								  Ext.getCmp('trade').reset();Ext.getCmp('tradename').reset();
								  Ext.getCmp('doorno').reset();Ext.getCmp('wardname').reset();
								  Ext.getCmp('wardno').reset();Ext.getCmp('area').reset();
								  Ext.getCmp('mobile').reset();Ext.getCmp('rfidcode').reset();
								  Ext.getCmp('statuscomboId').reset();
								  tradercombostore.load({params:{
								  custId:Ext.getCmp('custcomboId').getValue()
								  }
								  });
		                 	   }
                 	   }
                 	   }   
    });
    
//***** combo for Trader
 var tradercombo=new Ext.form.ComboBox({
	        store: tradercombostore,
	        id:'tradercomboId',
	        mode: 'local',
	        hidden:true,
	        forceSelection: true,
	        emptyText:'<%=SelectTrader%>',
	        selectOnFocus:true,
	        allowBlank: false,
	        anyMatch:true,
            typeAhead: false,
	        triggerAction: 'all',
	        lazyRender: true,
	    	valueField: 'TraderId',
	    	displayField: 'TraderName',
	    	cls:'selectstyle',
	    	listeners: {
		                   select: {
		                 	   fn:function(){
		                 	    if(buttonvalue=="modify"){
		                 	     Ext.getCmp('newtradername').reset();
								 Ext.getCmp('licno').reset();Ext.getCmp('addrs').reset();
								 Ext.getCmp('trade').reset();Ext.getCmp('tradename').reset();
								 Ext.getCmp('doorno').reset();Ext.getCmp('wardname').reset();
								 Ext.getCmp('wardno').reset();Ext.getCmp('area').reset();
								 Ext.getCmp('mobile').reset();Ext.getCmp('rfidcode').reset();
								 Ext.getCmp('statuscomboId').reset();
								 traderdetailsstore.load({params:{
								  custId:Ext.getCmp('custcomboId').getValue(),
								  traderId:Ext.getCmp('tradercomboId').getValue()
								  },
								  callback:function(){
								  var rec = traderdetailsstore.getAt(0);
								  Ext.getCmp('newtradername').setValue(Ext.getCmp('tradercomboId').getRawValue());
								  Ext.getCmp('licno').setValue(rec.data['Licence_No']);
								  Ext.getCmp('addrs').setValue(rec.data['Address']);
								  Ext.getCmp('trade').setValue(rec.data['Trade']);Ext.getCmp('tradename').setValue(rec.data['Trade_Name']);
								  Ext.getCmp('doorno').setValue(rec.data['Door_No']);Ext.getCmp('wardname').setValue(rec.data['Ward_Name']);
								  Ext.getCmp('wardno').setValue(rec.data['Ward_No']);Ext.getCmp('area').setValue(rec.data['Area']);
								  Ext.getCmp('mobile').setValue(rec.data['Mobile_No']);Ext.getCmp('rfidcode').setValue(rec.data['Rfid_Code']);
								  Ext.getCmp('statuscomboId').setValue(rec.data['Status']);
								  }});
		                 	   }
		                 	   }
                 	   }
                 	   }   
    });
    
    
    
  //store for status
  var statuscombostore= new Ext.data.SimpleStore({
	  id:'statuscombostoreId',
	  autoLoad: true,
	  fields: ['Name','Value'],
	  data: [['Active', 'Active'], ['Inactive', 'Inactive']]
			                                   });
 //combo for status 
    var statuscombo = new Ext.form.ComboBox({
        store: statuscombostore,
        id:'statuscomboId',
        mode: 'local',
        forceSelection: true,
        emptyText:'<%=SelectStatus%>',
        selectOnFocus:true,
        allowBlank: false,
        anyMatch:true,
        typeAhead: false,
        triggerAction: 'all',
        lazyRender: true,
    	valueField: 'Value',
    	value:'Active',
    	displayField: 'Name',
    	cls:'selectstyle'   
    });
    
    //**********************combo for status end ********************************************************
    
   //**********************inner panel start******************************************* 
  var innerPanel = new Ext.Panel({
		standardSubmit: true,
		collapsible:false,
		cls:'innerpanelpercentage1',
		id:'traderMaster',
		layout:'table',
		layoutConfig: {
			columns:2
		},
		items: [
				{
				xtype: 'label',
				text: '<%=CustomerName%>'+' :',
				cls:'labelstyle',
				id:'custnamelab'
				},
				custnamecombo,
				{
				xtype: 'label',
				text: '<%=TraderName%>'+' :',
				cls:'labelstyle',
				hidden:true,
				id:'tradernamhidlab'
				},
				tradercombo,
				{
				xtype: 'label',
				cls:'labelstyle',
				hidden:true,
				id:'newtradernamelab',
				text: '<%=NewTraderName%>'+' :'
				},
				{
				xtype:'textfield',
	    		cls:'textrnumberstyle',
	    		emptyText:'<%=EnterTraderName%>',
	    		allowBlank: false,
	    		hidden:true,
	    		blankText :'<%=EnterTraderName%>',
	    		id:'newtradername'
	    		},
				{
				xtype: 'label',
				cls:'labelstyle',
				id:'tradernamelab',
				text: '<%=TraderName%>'+' :'
				},
				{
				xtype:'textfield',
	    		cls:'textrnumberstyle',
	    		emptyText:'<%=EnterTraderName%>',
	    		allowBlank: false,
	    		blankText :'<%=EnterTraderName%>',
	    		id:'tradername'
	    		},
	    		{
            	xtype: 'label',
				cls:'labelstyle',
				id:'licnolab',
				text: '<%=LicNo%>'+' :'
				},
				{
				xtype:'textfield',
	    		cls:'textrnumberstyle',
	    		emptyText:'<%=EnterLicNo%>',
	    		allowBlank: true,
	    		blankText :'<%=EnterLicNo%>',
	    		id:'licno'
	    		},
	    		{
				xtype: 'label',
				text: '<%=Address%>'+' :',
				cls:'labelstyle',
				id:'addrslab'
				},
				{
				xtype:'textarea',
	    		cls:'textareastyle',
	    		emptyText:'<%=EnterAddress%>',
	    		blankText :'<%=EnterAddress%>',
	    		allowBlank: true,
	    		id:'addrs'
	    		},
	    		{
				xtype: 'label',
				cls:'labelstyle',
				id:'tradelab',
				text: '<%=Trade%>'+' :'
				},
				{
				xtype:'textfield',
	    		cls:'textrnumberstyle',
	    		emptyText:'<%=EnterTrade%>',
	    		allowBlank: true,
	    		blankText :'<%=EnterTrade%>',
	    		id:'trade'
	    		},
	    		{
				xtype: 'label',
				cls:'labelstyle',
				id:'tradenamelab',
				text: '<%=TradeName%>'+' :'
				},
				{
				xtype:'textfield',
	    		cls:'textrnumberstyle',
	    		emptyText:'<%=EnterTradeName%>',
	    		allowBlank: true,
	    		blankText :'<%=EnterTradeName%>',
	    		id:'tradename'
	    		},
	    		{
				xtype: 'label',
				cls:'labelstyle',
				id:'doornolab',
				text: '<%=DoorNo%>'+' :'
				},
				{
				xtype:'textfield',
	    		cls:'textrnumberstyle',
	    		emptyText:'<%=EnterDoorNo%>',
	    		allowBlank: true,
	    		blankText :'<%=EnterDoorNo%>',
	    		id:'doorno'
	    		},
	    		{
				xtype: 'label',
				cls:'labelstyle',
				id:'wardnamelab',
				text: '<%=WardName%>'+' :'
				},
				{
				xtype:'textfield',
	    		cls:'textrnumberstyle',
	    		emptyText:'<%=EnterWardName%>',
	    		allowBlank: true,
	    		blankText :'<%=EnterWardName%>',
	    		id:'wardname'
	    		},
	    		{
				xtype: 'label',
				cls:'labelstyle',
				id:'wardnolab',
				text: '<%=WardNo%>'+' :'
				},
				{
				xtype:'textfield',
	    		cls:'textrnumberstyle',
	    		emptyText:'<%=EnterWardNo%>',
	    		allowBlank: true,
	    		blankText :'<%=EnterWardNo%>',
	    		id:'wardno'
	    		},
	    		{
				xtype: 'label',
				cls:'labelstyle',
				id:'arealab',
				text: '<%=Area%>'+' :'
				},
				{
				xtype:'textfield',
	    		cls:'textrnumberstyle',
	    		emptyText:'<%=EnterArea%>',
	    		allowBlank: true,
	    		blankText :'<%=EnterArea%>',
	    		id:'area'
	    		},
	    		{
				xtype: 'label',
				text: '<%=MobileNo%>'+' :',
				cls:'labelstyle',
				id:'mobilelab'
				},
				{
				xtype:'numberfield',
	    		cls:'textrnumberstyle',
	    		emptyText:'<%=EnterMobileNo%>',
	    		blankText :'<%=EnterMobileNo%>',
	    		allowBlank: true,
	    		id:'mobile'
	    		},
	    		{
				xtype: 'label',
				cls:'labelstyle',
				id:'rfidcodelab',
				text: '<%=RfidCode%>'+' :'
				},
				{
				xtype:'textfield',
	    		cls:'textrnumberstyle',
	    		emptyText:'<%=EnterRfidCode%>',
	    		allowBlank: false,
	    		blankText :'<%=EnterRfidCode%>',
	    		id:'rfidcode'
	    		},
	    		{
				xtype: 'label',
				text: '<%=Status%>'+' :',
				cls:'labelstyle',
				id:'statuslab'
				},
				statuscombo,{},{},{},
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
							    var tradername=Ext.getCmp('tradername').getValue();
								var newtradername="";
       			 				if(buttonvalue=="add"){
										if(Ext.getCmp('tradername').getValue() == "" )
									    {
									 	     Ext.example.msg("<%=EnterTraderName%>");
							               	 Ext.getCmp('tradername').focus();
					                       	 return;
									    }	
									    if(Ext.getCmp('rfidcode').getValue() == "" )
									    {
									    	 Ext.example.msg("<%=EnterRfidCode%>");
							               	 Ext.getCmp('rfidcode').focus();
					                       	 return;
									    }
									    if(Ext.getCmp('statuscomboId').getValue() == "" )
									    {
									    	 Ext.example.msg("<%=SelectStatus%>");
							               	 Ext.getCmp('statuscomboId').focus();
					                       	 return;
									    }									    	
									    }
								else if(buttonvalue=="modify"){
									    	if(Ext.getCmp('tradercomboId').getValue() == "" )
										    {
										    	 Ext.example.msg("<%=SelectTrader%>");
							            	 	 Ext.getCmp('tradercomboId').focus();
						                       	 return;
										    }
										    if(Ext.getCmp('newtradername').getValue() == "" )
										    {
										    	 Ext.example.msg("<%=EnterTraderName%>");
									           	 Ext.getCmp('newtradername').focus();
						                       	 return;
										    }	
										    if(Ext.getCmp('rfidcode').getValue() == "" )
									    	{
									    	     Ext.example.msg("<%=EnterRfidCode%>");
								           	 	 Ext.getCmp('rfidcode').focus();
					                       	     return;
									    	}
									    	if(Ext.getCmp('statuscomboId').getValue() == "" )
									    	{
									    		 Ext.example.msg("<%=SelectStatus%>");
								           	 	 Ext.getCmp('statuscomboId').focus();
					                       	 	 return;
									    	}
									    	tradername=Ext.getCmp('tradercomboId').getValue();
									    	newtradername=Ext.getCmp('newtradername').getValue();
									    }
									    window.scrollTo(0,0);
									    //Ajax request
										Ext.Ajax.request({
										 				url: '<%=request.getContextPath()%>/TraderAction.do?param=savermodifyTrader',
														method: 'POST',
														params: 
														{
															 buttonvalue:buttonvalue,
															 custId:Ext.getCmp('custcomboId').getValue(),
															 tradername:tradername,
															 newtradername:newtradername,
															 licno:Ext.getCmp('licno').getValue(),
															 address:Ext.getCmp('addrs').getValue(),
															 trade:Ext.getCmp('trade').getValue(),
															 tradename:Ext.getCmp('tradename').getValue(),
															 doorno:Ext.getCmp('doorno').getValue(),
															 wardname:Ext.getCmp('wardname').getValue(),
															 wardno:Ext.getCmp('wardno').getValue(),
															 area:Ext.getCmp('area').getValue(),
															 mobile:Ext.getCmp('mobile').getValue(),
															 rfidcode:Ext.getCmp('rfidcode').getValue(),
															 status:Ext.getCmp('statuscomboId').getValue()
												        },
														success:function(response, options)//start of success
														{
																Ext.example.msg(response.responseText);
														      	Ext.getCmp('custcomboId').reset();
																customercombostore.reload();		
																Ext.getCmp('tradername').reset();Ext.getCmp('newtradername').reset();
																Ext.getCmp('tradercomboId').reset();
																Ext.getCmp('licno').reset();Ext.getCmp('addrs').reset();
																Ext.getCmp('trade').reset();Ext.getCmp('tradename').reset();
																Ext.getCmp('doorno').reset();Ext.getCmp('wardname').reset();
																Ext.getCmp('wardno').reset();Ext.getCmp('area').reset();
																Ext.getCmp('mobile').reset();Ext.getCmp('rfidcode').reset();
																Ext.getCmp('statuscomboId').reset();		
														}, // END OF  SUCCESS
													    failure: function()//start of failure 
													    {
													    		Ext.example.msg("error");
														      	Ext.getCmp('custcomboId').reset();
																customercombostore.reload();		
																Ext.getCmp('tradername').reset();Ext.getCmp('newtradername').reset();
																Ext.getCmp('tradercomboId').reset();
																Ext.getCmp('licno').reset();Ext.getCmp('addrs').reset();
																Ext.getCmp('trade').reset();Ext.getCmp('tradename').reset();
																Ext.getCmp('doorno').reset();Ext.getCmp('wardname').reset();
																Ext.getCmp('wardno').reset();Ext.getCmp('area').reset();
																Ext.getCmp('mobile').reset();Ext.getCmp('rfidcode').reset();
																Ext.getCmp('statuscomboId').reset();
														} // END OF FAILURE 
											}); // END OF AJAX							   
      							   } // END OF FUNCTION
       							  } // END OF CLICK
       							} // END OF LISTENERS
       						},{},
       			{
       			xtype:'button',
      			text:'<%=Delete%>',
        		id:'deletebuttonid',
        		cls:' ',
        		hidden:true,
        		width:80,
       			listeners: {
        		click:{
       			 fn:function(){
       			
       			                var custId=Ext.getCmp('custcomboId').getValue();
						    	var traderId=Ext.getCmp('tradercomboId').getValue();
						      if(Ext.getCmp('custcomboId').getValue() == "" )
							    {
							    	 Ext.example.msg("<%=SelectCustomer%>");
						             Ext.getCmp('custcomboId').focus();
			                       	 return;
							    }
						    if(Ext.getCmp('tradercomboId').getValue() == "" )
								{
						    		 Ext.example.msg("<%=SelectTrader%>");
						           	 Ext.getCmp('tradercomboId').focus();
			                       	 return;
							    }
						
						    	
       			 else
       			 
       			 {
	       			 Ext.Msg.show({ 
										title: '<%=Delete%>',
										msg: '<%=Areyousureyouwanttodelete%>'+' ?',
										buttons: {
										yes: true,
										no: true
										},
										fn: function(btn) {
										switch(btn){
										case 'yes':  
        						    	//showing message
							  //  ctsb.showBusy('<%=Deleting%>'+'...');
								outerPanel.getEl().mask();
								window.scrollTo(0,0);
								//Ajax request
								Ext.Ajax.request({
								 				url: '<%=request.getContextPath()%>/TraderAction.do?param=deleteTraderDetails',
												method: 'POST',
												params: 
												{
													 custId:custId,
													 traderId:traderId
										        },
												success:function(response, options)//start of success
												{
												      Ext.example.msg(response.responseText);
												      Ext.getCmp('custcomboId').reset();
												      Ext.getCmp('tradercomboId').reset();
												      outerPanel.getEl().unmask();
												}, // END OF  SUCCESS
											    failure: function()//start of failure 
											    {
											    	  Ext.example.msg("error");
												      Ext.getCmp('custcomboId').reset();
												      Ext.getCmp('tradercomboId').reset();
												      outerPanel.getEl().unmask();
												} // END OF FAILURE 
									}); // END OF AJAX
									
											break;
										case 'no':
										             
										              Ext.example.msg("Trader was not deleted");
												      Ext.getCmp('custcomboId').reset();
												      Ext.getCmp('tradercomboId').reset();
													  break;
														
												}
											}
										});	
      							   } // END OF FUNCTION
       							  } // END OF CLICK
       							} // END OF LISTENERS
       						}
				}
			]
		}); // End of Panel	
	  
//*****main starts from here*************************
 Ext.onReady(function(){
	ctsb=tsb;
	panel1=pageModifyPanel;
	Ext.QuickTips.init();
	Ext.form.Field.prototype.msgTarget = 'side';			         	   			
 	outerPanel = new Ext.Panel({
			title:'<%=TraderMaster%>',
			renderTo : 'content',
			standardSubmit: true,
			frame:true,
			autoScroll:true,
			height:490,
			cls:'mainpanelpercentage_TradeMaster',
			items: [panel1,innerPanel]
			//bbar:ctsb			
			}); 

 
			Ext.getCmp('pagemodimodify').on("click", function(){
			buttonvalue="modify";
			Ext.getCmp('custcomboId').reset();
			customercombostore.reload();		
			Ext.getCmp('tradername').reset();Ext.getCmp('newtradername').reset();
			Ext.getCmp('tradercomboId').reset();
			Ext.getCmp('licno').reset();Ext.getCmp('addrs').reset();
			Ext.getCmp('trade').reset();Ext.getCmp('tradename').reset();
			Ext.getCmp('doorno').reset();Ext.getCmp('wardname').reset();
			Ext.getCmp('wardno').reset();Ext.getCmp('area').reset();
			Ext.getCmp('mobile').reset();Ext.getCmp('rfidcode').reset();
			Ext.getCmp('statuscomboId').reset();
			Ext.getCmp('custnamelab').show();Ext.getCmp('custcomboId').show();
			Ext.getCmp('tradernamhidlab').show();Ext.getCmp('tradercomboId').show();
			Ext.getCmp('newtradernamelab').show();Ext.getCmp('newtradername').show();
			Ext.getCmp('tradernamelab').hide();Ext.getCmp('tradername').hide();
			Ext.getCmp('licnolab').show();Ext.getCmp('licno').show();
			Ext.getCmp('addrslab').show();Ext.getCmp('addrs').show();
			Ext.getCmp('tradelab').show();Ext.getCmp('trade').show();
			Ext.getCmp('tradenamelab').show();Ext.getCmp('tradename').show();
			Ext.getCmp('doornolab').show();Ext.getCmp('doorno').show();
			Ext.getCmp('wardnamelab').show();Ext.getCmp('wardname').show();
			Ext.getCmp('wardnolab').show();Ext.getCmp('wardno').show();
			Ext.getCmp('arealab').show();Ext.getCmp('area').show();
			Ext.getCmp('mobilelab').show();Ext.getCmp('mobile').show();
			Ext.getCmp('rfidcodelab').show();Ext.getCmp('rfidcode').show();
			Ext.getCmp('statuslab').show();Ext.getCmp('statuscomboId').show();
			Ext.getCmp('deletebuttonid').hide();Ext.getCmp('addbuttonid').show();
			});
			
			Ext.getCmp('pagemodiadd').on("click", function () { 
			buttonvalue="add";
			Ext.getCmp('custcomboId').reset();
			customercombostore.reload();		
			Ext.getCmp('tradername').reset();Ext.getCmp('newtradername').reset();
			Ext.getCmp('tradercomboId').reset();
			Ext.getCmp('licno').reset();Ext.getCmp('addrs').reset();
			Ext.getCmp('trade').reset();Ext.getCmp('tradename').reset();
			Ext.getCmp('doorno').reset();Ext.getCmp('wardname').reset();
			Ext.getCmp('wardno').reset();Ext.getCmp('area').reset();
			Ext.getCmp('mobile').reset();Ext.getCmp('rfidcode').reset();
			Ext.getCmp('statuscomboId').reset();
			Ext.getCmp('custnamelab').show();Ext.getCmp('custcomboId').show();
			Ext.getCmp('tradernamhidlab').hide();Ext.getCmp('tradercomboId').hide();
			Ext.getCmp('newtradernamelab').hide();Ext.getCmp('newtradername').hide();
			Ext.getCmp('tradernamelab').show();Ext.getCmp('tradername').show();
			Ext.getCmp('licnolab').show();Ext.getCmp('licno').show();
			Ext.getCmp('addrslab').show();Ext.getCmp('addrs').show();
			Ext.getCmp('tradelab').show();Ext.getCmp('trade').show();
			Ext.getCmp('tradenamelab').show();Ext.getCmp('tradename').show();
			Ext.getCmp('doornolab').show();Ext.getCmp('doorno').show();
			Ext.getCmp('wardnamelab').show();Ext.getCmp('wardname').show();
			Ext.getCmp('wardnolab').show();Ext.getCmp('wardno').show();
			Ext.getCmp('arealab').show();Ext.getCmp('area').show();
			Ext.getCmp('mobilelab').show();Ext.getCmp('mobile').show();
			Ext.getCmp('rfidcodelab').show();Ext.getCmp('rfidcode').show();
			Ext.getCmp('statuslab').show();Ext.getCmp('statuscomboId').show();
			Ext.getCmp('deletebuttonid').hide();Ext.getCmp('addbuttonid').show();
			});
			
			Ext.getCmp('pagemodidelete').on("click", function(){
			buttonvalue="delete";
			Ext.getCmp('custcomboId').reset();
			customercombostore.reload();		
			Ext.getCmp('tradername').reset();Ext.getCmp('newtradername').reset();
			Ext.getCmp('tradercomboId').reset();
			Ext.getCmp('licno').reset();Ext.getCmp('addrs').reset();
			Ext.getCmp('trade').reset();Ext.getCmp('tradename').reset();
			Ext.getCmp('doorno').reset();Ext.getCmp('wardname').reset();
			Ext.getCmp('wardno').reset();Ext.getCmp('area').reset();
			Ext.getCmp('mobile').reset();Ext.getCmp('rfidcode').reset();
			Ext.getCmp('statuscomboId').reset();
			Ext.getCmp('custnamelab').show();Ext.getCmp('custcomboId').show();
			Ext.getCmp('tradernamhidlab').show();Ext.getCmp('tradercomboId').show();
			Ext.getCmp('newtradernamelab').hide();Ext.getCmp('newtradername').hide();
			Ext.getCmp('tradernamelab').hide();Ext.getCmp('tradername').hide();
			Ext.getCmp('licnolab').hide();Ext.getCmp('licno').hide();
			Ext.getCmp('addrslab').hide();Ext.getCmp('addrs').hide();
			Ext.getCmp('tradelab').hide();Ext.getCmp('trade').hide();
			Ext.getCmp('tradenamelab').hide();Ext.getCmp('tradename').hide();
			Ext.getCmp('doornolab').hide();Ext.getCmp('doorno').hide();
			Ext.getCmp('wardnamelab').hide();Ext.getCmp('wardname').hide();
			Ext.getCmp('wardnolab').hide();Ext.getCmp('wardno').hide();
			Ext.getCmp('arealab').hide();Ext.getCmp('area').hide();
			Ext.getCmp('mobilelab').hide();Ext.getCmp('mobile').hide();
			Ext.getCmp('rfidcodelab').hide();Ext.getCmp('rfidcode').hide();
			Ext.getCmp('statuslab').hide();Ext.getCmp('statuscomboId').hide();
			Ext.getCmp('deletebuttonid').show();Ext.getCmp('addbuttonid').hide();
			
			});
		                   
	});

   
   </script>
  </body>
</html>
