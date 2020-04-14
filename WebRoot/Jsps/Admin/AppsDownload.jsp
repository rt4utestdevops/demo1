<%@ page  language="java" import="java.util.*,t4u.functions.CommonFunctions,t4u.beans.*,t4u.common.*" pageEncoding="utf-8"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://"
			+ request.getServerName() + ":" + request.getServerPort()
			+ path + "/";
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
	session.setAttribute("loginInfoDetails",loginInfo);
	}
	CommonFunctions cf = new CommonFunctions();
	cf.checkLoginInfo((LoginInfoBean)session.getAttribute("loginInfoDetails"),session,request,response);
	LoginInfoBean loginInfo=(LoginInfoBean)session.getAttribute("loginInfoDetails");
	String language=loginInfo.getLanguage();
	int customerId=loginInfo.getCustomerId();
	//getting hashmap with language specific words
	HashMap langConverted=ApplicationListener.langConverted;
	LanguageWordsBean lwb=null;
	
	String custName;
	lwb=(LanguageWordsBean)langConverted.get("Enter_Name");
	if(language.equals("ar")){
		custName=lwb.getArabicWord();
	}else{
		custName=lwb.getEnglishWord();
	}
	lwb=null;
		
	String entCustName;
	lwb=(LanguageWordsBean)langConverted.get("Enter_Name");
	if(language.equals("ar")){
		entCustName=lwb.getArabicWord();
	}else{
		entCustName=lwb.getEnglishWord();
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
	String entMobNo;
	lwb=(LanguageWordsBean)langConverted.get("Enter_Mobile_No");
	if(language.equals("ar")){
		entMobNo=lwb.getArabicWord();
	}else{
		entMobNo=lwb.getEnglishWord();
	}
	lwb=null;
	String email;
	lwb=(LanguageWordsBean)langConverted.get("Email");
	if(language.equals("ar")){
		email=lwb.getArabicWord();
	}else{
		email=lwb.getEnglishWord();
	}
	lwb=null;
	String entEmail;
	lwb=(LanguageWordsBean)langConverted.get("Enter_Email");
	if(language.equals("ar")){
		entEmail=lwb.getArabicWord();
	}else{
		entEmail=lwb.getEnglishWord();
	}
	lwb=null;
   
   String designation;
	lwb=(LanguageWordsBean)langConverted.get("Designation");
	if(language.equals("ar")){
		designation=lwb.getArabicWord();
	}else{
		designation=lwb.getEnglishWord();
	}
	lwb=null;
	String entDesig;
	lwb=(LanguageWordsBean)langConverted.get("Enter_Designation");
	if(language.equals("ar")){
		entDesig=lwb.getArabicWord();
	}else{
		entDesig=lwb.getEnglishWord();
	}
	lwb=null;
	String appDownLoad;
	lwb=(LanguageWordsBean)langConverted.get("App_Download");
	if(language.equals("ar")){
		appDownLoad=lwb.getArabicWord();
	}else{
		appDownLoad=lwb.getEnglishWord();
	}
	lwb=null;
	String download;
	lwb=(LanguageWordsBean)langConverted.get("Download");
	if(language.equals("ar")){
		download=lwb.getArabicWord();
	}else{
		download=lwb.getEnglishWord();
	}
	lwb=null;
	langConverted=null;
%>

<!DOCTYPE HTML>
<html>
 <head>
		<title><%=appDownLoad%></title>
			</head>	    
  <body>
  <jsp:include page="../Common/ImportJS.jsp" />
   <script>
 var outerPanel;
 var ctsb;
 var user="old";
 var panel1;
 
//inner panel starts from here
//panel one is for showing fields and their types		    
	var panel1=new Ext.Panel({
		standardSubmit: true,
		collapsible:false,
		height:300,
		//cls:'innerpanelmedium',
		id:'appdownload',
		layout:'table',
		layoutConfig: {
			columns:2
		},
		items: [{
		        	id:'commentid',
		        	html:'<div style="font-size:13px;"><p><u>Instructions for downloading the app</u></p><br> 1)	This app is compatible with android 2.2 version and above.<br> 2)	Enable Unknown sources in your mobile settings to allow <br/>installation of apps from sources other than the Google play store.<br> 3)	Fill the following fields to download the app. <br> 4)	Save .apk file in required destination folder.<br/> 5)	Move .apk file to your android mobile using USB cable.<br/> 6)	Once installed, a t4u icon will appear on your mobile.<br/>7) Click icon to login to your platform.<br/>8) And start monitoring your fleet on the go!!!</br></br></div>'
		        	
		    		},{},
		    		{
				xtype: 'label',
				cls:'labelstyle',
				id:'custlab',
				text: '<%=custName%>'+'  :'
				},
					{
					xtype:'textfield',
		    		cls:'selectstyle',
		    		fieldLabel: '<%=custName%>',
	                labelSeparator: ':',
		    		emptyText:'<%=entCustName%>',
		    		blankText :'<%=entCustName%>',
		   			allowBlank: false,
		    		id:'custId'
		    		},
		    		{
				xtype: 'label',
				cls:'labelstyle',
				id:'moblab',
				text: '<%=mobNo%>'+'  :'
				},
					{
					xtype:'numberfield',
					fieldLabel: '<%=mobNo%>',
	                labelSeparator: ':',
		    		cls:'selectstyle',
		    		emptyText:'<%=entMobNo%>',
		    		blankText :'<%=entMobNo%>',
		   			allowBlank: false,
		    		id:'mobileNoId'
		    		},
		    		{
				xtype: 'label',
				cls:'labelstyle',
				id:'emaillab',
				text: '<%=email%>'+'  :'
				},
					{
					xtype:'textfield',
		    		cls:'selectstyle',
		    		fieldLabel: '<%=email%>',
		    		labelSeparator: ':',
		    		allowBlank: false,
		    		vtype:'email',
		    		emptyText:'<%=entEmail%>',
		    		blankText:'<%=entEmail%>',
		    		id:'emailId'
		    		},
		    		{
				xtype: 'label',
				cls:'labelstyle',
				id:'desiglab',
				text: '<%=designation%>'+'  :'
				},
					{
					xtype:'textfield',
		    		cls:'selectstyle',
		    		fieldLabel: '<%=designation%>',
		    		emptyText:'<%=entDesig%>',
		    		labelSeparator: ':',
		    		id:'designationId'
		    		}
		]});
	//innerpanel starts from here, this panel is made because of submission of form, because after hiding the element and submitting it AJAX call gets problem 
	var innerpanel = new Ext.FormPanel({
		        	id: 'downloadForm',
		        	frame:false,
		        	fileUpload: true,
		        	cls:'innerpanelgrid',
		        	collapsible: false,
		         buttons:[{
			              		text: '<%=download%>',
			              		cls:'downloadbuttonstyle',
			              		handler : function(){
			              		var CustName="";
							    var MobileNo="";
							    var EmailAddress="";
							    var Designation="";
				                if(user=="old"){  		
								if(Ext.getCmp('custId').getValue()== "")
								        {
								        ctsb.setStatus({
								        text:getMessageForStatus("<%=entCustName%>"),
								        iconCls:'',
										clear:true
								        });
								        Ext.getCmp('custId').focus();
								        return;
								        }
								        
								if(Ext.getCmp('mobileNoId').getValue() == "" )
									    {
								             ctsb.setStatus({
											 text: getMessageForStatus("<%=entMobNo%>"), 
											 iconCls:'',
											 clear: true
					                       	 });
					                       	 Ext.getCmp('mobileNoId').focus();
					                       	 return;
									    }
							    if(Ext.getCmp('emailId').getValue() == "" )
									    {
								             ctsb.setStatus({
											 text: getMessageForStatus("<%=entEmail%>"), 
											 iconCls:'',
											 clear: true
					                       	 });
					                       	 Ext.getCmp('emailId').focus();
					                       	 return;
									    }
									    
			              				 CustName=Ext.getCmp('custId').getValue();
							         	 MobileNo=Ext.getCmp('mobileNoId').getValue();
							         	 EmailAddress=Ext.getCmp('emailId').getValue();
							         	 Designation=Ext.getCmp('designationId').getValue();
								}
			              //code for apps download
			              			innerpanel.getForm().submit({
			              				url:'<%=request.getContextPath()%>/AppsDownloadAction.do?param=AppsDownloaderDetails',
			              			});
			              			
			              //code for saving appdownloader
			              			Ext.Ajax.request({
					 				url: '<%=request.getContextPath()%>/AppsDownloadAction.do?param=saveAppsDownloaderDetails',
									method: 'POST',
									params: 
									{ 
									   	 CustName:CustName,
							         	 MobileNo:MobileNo,
							         	 EmailAddress:EmailAddress,
							         	 Designation:Designation
							         	 
							         },
									success:function(response, options)//start of success
									{
										  if(user=="old"){  
								          Ext.getCmp('custId').reset();
										  Ext.getCmp('mobileNoId').reset();
										  Ext.getCmp('emailId').reset();
										  Ext.getCmp('designationId').reset();
										  }
									}, // END OF  SUCCESS
								    failure: function()//start of failure 
								    {
								    	  ctsb.setStatus({
													 text:getMessageForStatus("error"), 
													 iconCls:'',
													 clear: true
								                     });
								           if(user=="old"){  
									      Ext.getCmp('custId').reset();
										  Ext.getCmp('mobileNoId').reset();
										  Ext.getCmp('emailId').reset();
										  Ext.getCmp('designationId').reset();
						                  }
									} // END OF FAILURE 
						}); // END OF AJAX	
			              			
			              			
			              			
			              			
			              		}
			              }]
		    });  
//*********************Main starts from here****************
	
 Ext.onReady(function(){
	ctsb=tsb;			
	Ext.QuickTips.init();
	Ext.form.Field.prototype.msgTarget = 'side';		   			   			         	   			
 	outerPanel = new Ext.Panel({
			title:'Download App',
			renderTo : 'content',
			standardSubmit: true,
			cls:'mainpanelmedium',
			frame:true,
			//layout:'fit',
			items: [panel1,innerpanel],
			tbar: ctsb			
			});  
			
//code for validating user and showing respective part..
			if(<%=customerId%>==0){
			user="new";
			Ext.getCmp('custId').hide();
			Ext.getCmp('mobileNoId').hide();
			Ext.getCmp('emailId').hide();
			Ext.getCmp('designationId').hide();
			Ext.getCmp('custlab').hide();
			Ext.getCmp('moblab').hide();
			Ext.getCmp('emaillab').hide();
			Ext.getCmp('desiglab').hide();
			}else{
			user="old";
			Ext.getCmp('custId').show();
			Ext.getCmp('mobileNoId').show();
			Ext.getCmp('emailId').show();
			Ext.getCmp('designationId').show();
			Ext.getCmp('custlab').show();
			Ext.getCmp('moblab').show();
			Ext.getCmp('emaillab').show();
			Ext.getCmp('desiglab').show();
			}
			
	});

   
   </script>
  </body>
</html>
