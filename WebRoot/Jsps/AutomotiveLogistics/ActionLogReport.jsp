<%@ page  language="java" import="java.util.*,t4u.functions.CommonFunctions,t4u.beans.*,t4u.common.*" pageEncoding="utf-8"%>
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
CommonFunctions cf=new CommonFunctions();
LoginInfoBean loginInfo=(LoginInfoBean)session.getAttribute("loginInfoDetails");
if(loginInfo==null){
	response.sendRedirect(request.getContextPath()+ "/Jsps/Common/SessionDestroy.html");
}
else
{
session.setAttribute("loginInfoDetails",loginInfo);
String language=loginInfo.getLanguage();
int customeridlogged=loginInfo.getCustomerId();
String pageName="Action Log Report";
//Function to fetch specific language words
HashMap langConverted=ApplicationListener.langConverted;
LanguageWordsBean lwb=null;

String SelectCustomer;
lwb=(LanguageWordsBean)langConverted.get("Select_Customer");
if (language.equals("ar")) {
	SelectCustomer=lwb.getArabicWord();
} else {
	SelectCustomer=lwb.getEnglishWord();
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
String ActionLogReport;
lwb=(LanguageWordsBean)langConverted.get("Action_Log_Report");
if(language.equals("ar")){
	ActionLogReport=lwb.getArabicWord();
}else{
	ActionLogReport=lwb.getEnglishWord();
}
lwb=null;
String monthValidation;
lwb=(LanguageWordsBean)langConverted.get("Month_Validation");
if(language.equals("ar")){
	monthValidation=lwb.getArabicWord();
}else{
	monthValidation=lwb.getEnglishWord();
}

%>

<jsp:include page="../Common/header.jsp" />
 			<title>'<%=ActionLogReport%>'</title>
 	<style>
.logbuttonstyle{
	margin:0px 0px 5px 30px !important;
}

.logselectstyle{
	 padding:2.7px;
	 width:125px !important;	
	 listwidth:120px !important;
	 max-listwidth:120px !important;
	 min-listwidth:120px !important;
	 margin:0px 0px 5px 5px !important;
}
.ext-strict .x-form-text {
	height : 21px !important;
}
 	</style>		
    
  

   <%if (loginInfo.getStyleSheetOverride().equals("Y")){%>
	<jsp:include page="../Common/ImportJSSandMining.jsp"/>
	<%}else {%>
	<jsp:include page="../Common/ImportJS.jsp" /><%} %>
   <script>
 var outerPanel;
 var ctsb;
 var dtnext = datenext;   
 var dtcur = datecur; 
 var datenextt = datedayafternext;

 var customerstore=new Ext.data.JsonStore({
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
  var customerCombo=new Ext.form.ComboBox({
                store:customerstore,
                mode:'local',
                forceSelection: true,
                emptyText:'<%=SelectCustomer%>',
	            blankText:'<%=SelectCustomer%>',
	            selectOnFocus:true,
	            allowBlank: false,
	            anyMatch:true,
            	typeAhead: false,
	            triggerAction: 'all',
	            lazyRender: true,
	    	    valueField: 'CustId',
	    	    displayField: 'CustName',
	    	    cls:'logselectstyle',
	    	    id : 'custcomboId'
   
  });
  
  var innerPanel=new Ext.Panel({
        standardSubmit: true,
		frame:true,
		cls:'innerpanelpercentage',
		id:'emptrackingid',
		layout:'table',
		layoutConfig:{
		columns:2
		},
		items:[{
		       xtype:'label',
		       text:'<%=SelectCustomer%>:',
		       cls:'labelstyle',
		       id:'selcustomerid'
		       },customerCombo,{
		       xtype:'label',
		       text:'<%=StartDate%>:',
		       cls:'labelstyle',
		       id:'reportingtimeid'
		       },{
		       xtype:'datefield',
		       emptyText:'<%=StartDate%>',
		       format:'d-m-Y',
		       cls:'logselectstyle',
		       id:'startdate',
		       allowBlank: false,
		       value:dtcur,
	    	   maxValue:dtcur,
			   vtype: 'daterange',
        	   endDateField:'enddate'
			   },{
		       xtype:'label',
		       text:'<%=EndDate%>:',
		       cls:'labelstyle',
		       id:'exittimeid'
		       },{
		       xtype:'datefield',
		       format: 'd-m-Y',
		       emptyText:'<%=EndDate%>',
		       cls:'logselectstyle',
		       id:'enddate',
		       allowBlank: false,
		       value:dtnext,
	    	   maxValue:dtnext,
			   vtype: 'daterange',
        	   startDateField:'startdate'
			   },{cls:'labelstyle'},{
		          xtype:'button',
		          text:'<%=Submit%>',
		          cls:'logbuttonstyle',
		          width:80,
		          listeners: {
        		click:{
       			 fn:function(){
       			 
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
				    startDate = Ext.getCmp('startdate').getValue();
				    endDate = Ext.getCmp('enddate').getValue();
				    
				         if (checkMonthValidation(startDate, endDate)) {
  		                        Ext.example.msg("<%=monthValidation%>");
  		                            Ext.getCmp('enddate').focus();  		                            	
  		                            return;
  		                            }
  		                            
  		                            if (dateCompare(Ext.getCmp('startdate').getValue(), Ext.getCmp('enddate').getValue()) == -1) {
                   Ext.example.msg("End Date must be greater than Start Date");
                  Ext.getCmp('enddate').focus();
                  return;
              }
  		                            
  		      if (dateCompare(Ext.getCmp('enddate').getValue(), datenextt)== -1) {
                  Ext.example.msg("End Date should not be greater than Current date");
                  Ext.getCmp('enddate').focus();
                  return;
              }
  		                            
  		             startDate = Ext.getCmp('startdate').getValue().format('Y/m/d H:i:s');
				     endDate = Ext.getCmp('enddate').getValue().format('Y/m/d H:i:s');
                     window.open("<%=request.getContextPath()%>/ActionLogReport?startDate="+startDate+"&endDate="+endDate+"&clientId="+Ext.getCmp('custcomboId').getValue());
                                
       			}
       			}
       			}
		       }]
  });
  Ext.onReady(function () {
  outerPanel=new Ext.Panel({
  title:'<%=ActionLogReport%>',
  renderTo:'content',
  standardSubmit:true,
  height:200,
  frame:true,
  cls:'mainpanelpercentage',
  items:[innerPanel]
  });
    


});
   </script>
   <jsp:include page="../Common/footer.jsp" />
 <!-- </body>   -->
 <!-- </html> -->
 <%}%>