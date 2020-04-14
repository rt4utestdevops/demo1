<%@ page  language="java" import="java.util.*,t4u.functions.CommonFunctions,t4u.beans.*,t4u.common.*" pageEncoding="utf-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
CommonFunctions cf=new CommonFunctions();
cf.checkLoginInfo((LoginInfoBean)session.getAttribute("loginInfoDetails"),session,request,response);
LoginInfoBean loginInfo=(LoginInfoBean)session.getAttribute("loginInfoDetails");
String language=loginInfo.getLanguage();
//getting hashmap with language specific words
HashMap langConverted=ApplicationListener.langConverted;
LanguageWordsBean lwb=null;

//Getting words based on language 

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

String assetReg;
lwb=(LanguageWordsBean)langConverted.get("Asset_Registration_Menu");
if(language.equals("ar")){
	assetReg=lwb.getArabicWord();
}else{
	assetReg=lwb.getEnglishWord();
}
lwb=null;

String selAssetType;
lwb=(LanguageWordsBean)langConverted.get("Sel_Asset_type");
if(language.equals("ar")){
	selAssetType=lwb.getArabicWord();
}else{
	selAssetType=lwb.getEnglishWord();
}
lwb=null;

String assetType;
lwb=(LanguageWordsBean)langConverted.get("Asset_Type");
if(language.equals("ar")){
	assetType=lwb.getArabicWord();
}else{
	assetType=lwb.getEnglishWord();
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

String enterRegNo;
lwb=(LanguageWordsBean)langConverted.get("Enter_Reg_No");
if(language.equals("ar")){
	enterRegNo=lwb.getArabicWord();
}else{
	enterRegNo=lwb.getEnglishWord();
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

String saveForm;
lwb=(LanguageWordsBean)langConverted.get("Save_Form");
if(language.equals("ar")){
	saveForm=lwb.getArabicWord();
}else{
	saveForm=lwb.getEnglishWord();
}
lwb=null;

String next;
lwb=(LanguageWordsBean)langConverted.get("Next");
if(language.equals("ar")){
	next=lwb.getArabicWord();
}else{
	next=lwb.getEnglishWord();
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
langConverted=null;
%>

<!DOCTYPE HTML>
<html>
 <head>
		<title><%=assetReg%></title>
			</head>	    
  
  <body>
  <jsp:include page="../Common/ImportJS.jsp" />
   <script>
 var outerPanel;
 var ctsb;
 var pasparam;
 var panel1;
 //*********************Asset Type Combo*************************
  var assetTypeStore= new Ext.data.SimpleStore({
		id:'assetcombostoreId',
		autoLoad: true,
		fields: ['Name','Value'],
		data: [['PERSON', '1'], ['VERHICLE', '2'],['VESSEL', '3']]
			                                  });
    
    var assetTypeCombo = new Ext.form.ComboBox({
        store: assetTypeStore,
        id:'assettypecomboId',
        mode: 'local',
        forceSelection: true,
        emptyText:'<%=selAssetType%>',
        blankText:'<%=selAssetType%>',
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
    
   //**************************************Customer Name Combo starts************************************************
    
    
			     
	var assetCustStore= new Ext.data.JsonStore({
			url:'<%=request.getContextPath()%>/CommonAction.do?param=getCustomer',
				   id:'assetcustcombostoreId',
			       root: 'CustomerRoot',
			       autoLoad: true,
			       remoteSort: true,
				   fields: ['CustId','CustName']
       });
    var assetCustCombo = new Ext.form.ComboBox({
        store: assetCustStore,
        id:'assetregcustcomboId',
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
    
   //**************************************Customer Name Combo ends************************************************ 
  var innerPanel = new Ext.Panel({
		standardSubmit: true,
		frame:true,
		collapsible:false,
		cls:'innerpanelsmall',
		id:'assetReg',
		layout:'table',
		layoutConfig: {
			columns:2
		},
		items: [
	    		{
				xtype: 'label',
				cls:'labelstyle',
				text: '<%=assetType%> '+'  :'
				},assetTypeCombo,
				{
				xtype: 'label',
				text: '<%=custName%> '+'  : ',
				allowBlank: false,
				cls:'labelstyle'
				},assetCustCombo,
				{
				xtype: 'label',
				text: '<%=regNo%> '+'  :',
				allowBlank: false,
				cls:'labelstyle'
				},
				{
				xtype:'textfield',
	    		cls:'textrnumberstyle',
	    		emptyText:'<%=enterRegNo%>',
	    		blankText :'<%=enterRegNo%>',
	    		regex:/^([a-zA-Z0-9]([a-zA-Z0-9-]*[a-zA-Z0-9])?)?$/,
	    		regexText:'<%=regRegex%>',
	   			allowBlank: false,
	    		id:'assetReg'
	    		},
				{},{},
				{
       			xtype:'button',
      			text:'<%=submit%>',
        		id:'addButtonId',
        		cls:'buttonrightstyle',
        		width:80,
       			listeners: {
        		click:{
       			fn:function(){
       			
        						 //Action for Button
								
								if(Ext.getCmp('assettypecomboId').getValue()== "")
								        {
								        ctsb.setStatus({
								        text:getMessageForStatus("<%=selAssetType%>"),
								        iconCls:'',
										clear:true
								        });
								        Ext.getCmp('assettypecomboId').focus();
								        return;
								        }
								        
								if(Ext.getCmp('assetregcustcomboId').getValue() == "" )
									    {
								             ctsb.setStatus({
											 text: getMessageForStatus("<%=selCust%>"), 
											 iconCls:'',
											 clear: true
					                       	 });
					                       	 Ext.getCmp('assetregcustcomboId').focus();
					                       	 return;
									    }
								if(Ext.getCmp('assetReg').getValue()== "")	
										{
										ctsb.setStatus({
										text:getMessageForStatus("<%=enterRegNo%>"),
										iconCls:'',
										clear:true
										});
										Ext.getCmp('assetReg').focus();
										return;
										}     	
							
						//showing message
					    ctsb.showBusy('<%=saveForm%>');
						outerPanel.getEl().mask();	   
						//Ajax request
								        
						Ext.Ajax.request({
					 				url: '<%=request.getContextPath()%>/AssetRegistrationAction.do?param=saveAssetRegistrationDetails',
									method: 'POST',
									params: 
									{ 
									     assetType:Ext.getCmp('assettypecomboId').getValue(),
										 custName:Ext.getCmp('assetregcustcomboId').getValue(),
							         	 regNo:Ext.getCmp('assetReg').getValue()
							         	 
							         },
									success:function(response, options)//start of success
									{
										  ctsb.setStatus({
													 text:getMessageForStatus(response.responseText), 
													 iconCls:'',
													 clear: true
								                     });
								          Ext.getCmp('assettypecomboId').reset();
										  Ext.getCmp('assetregcustcomboId').reset();
										  Ext.getCmp('assetReg').reset();
										  
										  outerPanel.getEl().unmask();
									}, // END OF  SUCCESS
								    failure: function()//start of failure 
								    {
								    	  ctsb.setStatus({
													 text:getMessageForStatus("error"), 
													 iconCls:'',
													 clear: true
								                     });
									      Ext.getCmp('assettypecomboId').reset();
										  Ext.getCmp('assetregcustcomboId').reset();
										  Ext.getCmp('assetReg').reset();
										  outerPanel.getEl().unmask();
									} // END OF FAILURE 
						}); // END OF AJAX		
											
	                            		
										   
										

      							   } // END OF FUNCTION
       							  } // END OF CLICK
       							} // END OF LISTENERS
       			},{
       			xtype:'button',
      			text:'<%=next%>',
      			cls: 'buttonstyle',
        		id:'nextUnitButtonId',
        		width:80,
       			listeners: {
        		click:{
       			fn:function(){
        						
        						if(Ext.getCmp('assettypecomboId').getValue()== "")
								        {
								        ctsb.setStatus({
								        text:getMessageForStatus("<%=selAssetType%>"),
								        iconCls:'',
										clear:true
								        });
								        Ext.getCmp('assettypecomboId').focus();
								        return;
								        }
								        
								if(Ext.getCmp('assetregcustcomboId').getValue() == "" )
									    {
								             ctsb.setStatus({
											 text: getMessageForStatus("<%=selCust%>"), 
											 iconCls:'',
											 clear: true
					                       	 });
					                       	 Ext.getCmp('assetregcustcomboId').focus();
					                       	 return;
									    }
								if(Ext.getCmp('assetReg').getValue()== "")	
										{
										ctsb.setStatus({
										text:getMessageForStatus("<%=enterRegNo%>"),
										iconCls:'',
										clear:true
										});
										Ext.getCmp('assetReg').focus();
										return;
										}    
        						
        						
        						Ext.Ajax.request({
					 				url: '<%=request.getContextPath()%>/AssetRegistrationAction.do?param=setAssociationDetails',
									method: 'POST',
									params: 
									{ 
									     assetType:Ext.getCmp('assettypecomboId').getValue(),
										 custName:Ext.getCmp('assetregcustcomboId').getValue(),
							         	 regNo:Ext.getCmp('assetReg').getValue()
							         	 
							         },
									success:function(response, options)//start of success
									{
										   window.location.href = "Association.jsp";
									}, // END OF  SUCCESS
								    failure: function()//start of failure 
								    {
								    	  ctsb.setStatus({
													 text:getMessageForStatus("error"), 
													 iconCls:'',
													 clear: true
								                     });
									      Ext.getCmp('assettypecomboId').reset();
										  Ext.getCmp('assetregcustcomboId').reset();
										  Ext.getCmp('assetReg').reset();
										  outerPanel.getEl().unmask();
									} // END OF FAILURE 
						}); // END OF AJAX		
											
        						
        						
        						
        							    
               
									
      						} // END OF FUNCTION
       						} // END OF CLICK
       						} // END OF LISTENERS
       						}
				
			] // End of Items
		}); // End of Panel	
	
//*********************Main starts from here****************
	
 Ext.onReady(function(){
	ctsb=tsb;			
	Ext.QuickTips.init();
	Ext.form.Field.prototype.msgTarget = 'side';		   			   			         	   			
 	outerPanel = new Ext.Panel({
			title:'<%=assetReg%>',
			renderTo : 'content',
			standardSubmit: true,
			cls:'mainpanelsmall',
			frame:true,
			//layout:'fit',
			items: [innerPanel],
			tbar: ctsb			
			});  
	});

   
   </script>
  </body>
</html>
