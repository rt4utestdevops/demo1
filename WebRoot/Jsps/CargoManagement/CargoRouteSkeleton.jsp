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
	if(str.length>8){
	loginInfo.setCustomerName(str[8].trim());
	}
	session.setAttribute("loginInfoDetails",loginInfo);
}
CommonFunctions cf=new CommonFunctions();
cf.checkLoginInfo((LoginInfoBean)session.getAttribute("loginInfoDetails"),session,request,response);
LoginInfoBean loginInfo=(LoginInfoBean)session.getAttribute("loginInfoDetails");
//getting language
String language=loginInfo.getLanguage();
//getting hashmap with language specific words
HashMap langConverted=ApplicationListener.langConverted;
LanguageWordsBean lwb=null;
int customeridlogged=loginInfo.getCustomerId();
//Getting words based on language 
String selectCustomer;
lwb=(LanguageWordsBean)langConverted.get("Select_Customer");
if(language.equals("ar")){
	selectCustomer=lwb.getArabicWord();
}else{
	selectCustomer=lwb.getEnglishWord();
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

String cargoTripName;
lwb=(LanguageWordsBean)langConverted.get("Cargo_Trip_Name");
if(language.equals("ar")){
	cargoTripName=lwb.getArabicWord();
}else{
	cargoTripName=lwb.getEnglishWord();
}
lwb=null;

String cargoTripCode;
lwb=(LanguageWordsBean)langConverted.get("Cargo_Trip_Code");
if(language.equals("ar")){
	cargoTripCode=lwb.getArabicWord();
}else{
	cargoTripCode=lwb.getEnglishWord();
}
lwb=null;

String newCustomerName;
lwb=(LanguageWordsBean)langConverted.get("New_Customer_Name");
if(language.equals("ar")){
	newCustomerName=lwb.getArabicWord();
}else{
	newCustomerName=lwb.getEnglishWord();
}
lwb=null;

String selectStatus;
lwb=(LanguageWordsBean)langConverted.get("Select_Status");
if(language.equals("ar")){
	selectStatus=lwb.getArabicWord();
}else{
	selectStatus=lwb.getEnglishWord();
}
lwb=null;

String customerMaster;
lwb=(LanguageWordsBean)langConverted.get("Customer_Master_Menu");
if(language.equals("ar")){
	customerMaster=lwb.getArabicWord();
}else{
	customerMaster=lwb.getEnglishWord();
}
lwb=null;

String enterCustName;
lwb=(LanguageWordsBean)langConverted.get("Enter_Customer_name");
if(language.equals("ar")){
	enterCustName=lwb.getArabicWord();
}else{
	enterCustName=lwb.getEnglishWord();
}
lwb=null;

String cargoOrgin;
lwb=(LanguageWordsBean)langConverted.get("Cargo_Origin");
if(language.equals("ar")){
	cargoOrgin=lwb.getArabicWord();
}else{
	cargoOrgin=lwb.getEnglishWord();
}
lwb=null;

String cargoTransitionPoint;
lwb=(LanguageWordsBean)langConverted.get("Cargo_Transition_Point");
if(language.equals("ar")){
	cargoTransitionPoint=lwb.getArabicWord();
}else{
	cargoTransitionPoint=lwb.getEnglishWord();
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

String wantToDelete;
lwb=(LanguageWordsBean)langConverted.get("Are_you_sure_you_want_to_delete");
if(language.equals("ar")){
	wantToDelete=lwb.getArabicWord();
}else{
	wantToDelete=lwb.getEnglishWord();
}
lwb=null;

String custNotDeleted;
lwb=(LanguageWordsBean)langConverted.get("Trip_Not_Deleted");
if(language.equals("ar")){
	custNotDeleted=lwb.getArabicWord();
}else{
	custNotDeleted=lwb.getEnglishWord();
}
lwb=null;

String add;
lwb=(LanguageWordsBean)langConverted.get("Add");
if(language.equals("ar")){
	add=lwb.getArabicWord();
}else{
	add=lwb.getEnglishWord();
}
lwb=null;

String cargoDestination;
lwb=(LanguageWordsBean)langConverted.get("Cargo_Destination");
if(language.equals("ar")){
	cargoDestination=lwb.getArabicWord();
}else{
	cargoDestination=lwb.getEnglishWord();
}
lwb=null;

String transitionPoint;
lwb=(LanguageWordsBean)langConverted.get("Cargo_Transition_Point");
if(language.equals("ar")){
	transitionPoint=lwb.getArabicWord();
}else{
	transitionPoint=lwb.getEnglishWord();
}
lwb=null;

String totalTime;
lwb=(LanguageWordsBean)langConverted.get("Total_Time(HH)");
if(language.equals("ar")){
	totalTime=lwb.getArabicWord();
}else{
	totalTime=lwb.getEnglishWord();
}
lwb=null;

String approximateDistance;
lwb=(LanguageWordsBean)langConverted.get("Approximate_Distance");
if(language.equals("ar")){
	approximateDistance=lwb.getArabicWord();
}else{
	approximateDistance=lwb.getEnglishWord();
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

String next;
lwb=(LanguageWordsBean)langConverted.get("Next");
if(language.equals("ar")){
	next=lwb.getArabicWord();
}else{
	next=lwb.getEnglishWord();
}
lwb=null;

String error;
lwb=(LanguageWordsBean)langConverted.get("Error");
if(language.equals("ar")){
	error=lwb.getArabicWord();
}else{
	error=lwb.getEnglishWord();
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

String cargOrginandTransitionpointcannotbesame;
lwb=(LanguageWordsBean)langConverted.get("Cargo_Orgin_and_Transition_point_cannot_be_same");
if(language.equals("ar")){
	cargOrginandTransitionpointcannotbesame=lwb.getArabicWord();
}else{
	cargOrginandTransitionpointcannotbesame=lwb.getEnglishWord();
}
lwb=null;

String cargoOrginandDestinationpointcannotbesame;
lwb=(LanguageWordsBean)langConverted.get("Cargo_Orgin_and_Destination_point_cannot_be_same");
if(language.equals("ar")){
	cargoOrginandDestinationpointcannotbesame=lwb.getArabicWord();
}else{
	cargoOrginandDestinationpointcannotbesame=lwb.getEnglishWord();
}
lwb=null;

String cargoDestinationandTransitionpointcannotbesame;
lwb=(LanguageWordsBean)langConverted.get("Cargo_Destination_and_Transition_point_cannot_be_same");
if(language.equals("ar")){
	cargoDestinationandTransitionpointcannotbesame=lwb.getArabicWord();
}else{
	cargoDestinationandTransitionpointcannotbesame=lwb.getEnglishWord();
}
lwb=null;

String RouteSkeleton;
lwb=(LanguageWordsBean)langConverted.get("Route_Skeleton");
if(language.equals("ar")){
	RouteSkeleton=lwb.getArabicWord();
}else{
	RouteSkeleton=lwb.getEnglishWord();
}
lwb=null;

String enterCargoTripCode;
lwb=(LanguageWordsBean)langConverted.get("Enter_Cargo_Trip_Code");
if(language.equals("ar")){
	enterCargoTripCode=lwb.getArabicWord();
}else{
	enterCargoTripCode=lwb.getEnglishWord();
}
lwb=null;

String enterCargoTripName;
lwb=(LanguageWordsBean)langConverted.get("Enter_Cargo_Trip_Name");
if(language.equals("ar")){
	enterCargoTripName=lwb.getArabicWord();
}else{
	enterCargoTripName=lwb.getEnglishWord();
}
lwb=null;

String selectCargoOrgin;
lwb=(LanguageWordsBean)langConverted.get("Select_Cargo_Orgin");
if(language.equals("ar")){
	selectCargoOrgin=lwb.getArabicWord();
}else{
	selectCargoOrgin=lwb.getEnglishWord();
}
lwb=null;

String selectTransitionPoint;
lwb=(LanguageWordsBean)langConverted.get("Select_Transition_Point");
if(language.equals("ar")){
	selectTransitionPoint=lwb.getArabicWord();
}else{
	selectTransitionPoint=lwb.getEnglishWord();
}
lwb=null;

String selectCargoDestination;
lwb=(LanguageWordsBean)langConverted.get("Select_Cargo_Destination");
if(language.equals("ar")){
	selectCargoDestination=lwb.getArabicWord();
}else{
	selectCargoDestination=lwb.getEnglishWord();
}
lwb=null;

String provideTotalTime;
lwb=(LanguageWordsBean)langConverted.get("Provide_Total_Time");
if(language.equals("ar")){
	provideTotalTime=lwb.getArabicWord();
}else{
	provideTotalTime=lwb.getEnglishWord();
}
lwb=null;

String provideApproximateDistance;
lwb=(LanguageWordsBean)langConverted.get("Provide_Approximate_Distance");
if(language.equals("ar")){
	provideApproximateDistance=lwb.getArabicWord();
}else{
	provideApproximateDistance=lwb.getEnglishWord();
}
lwb=null;


String transitionPointscannotbesame;
lwb=(LanguageWordsBean)langConverted.get("Transition_Points_cannot_be_same");
if(language.equals("ar")){
	transitionPointscannotbesame=lwb.getArabicWord();
}else{
	transitionPointscannotbesame=lwb.getEnglishWord();
}
lwb=null;

String selectTripName;
lwb=(LanguageWordsBean)langConverted.get("Select_Trip_Name");
if(language.equals("ar")){
	selectTripName=lwb.getArabicWord();
}else{
	selectTripName=lwb.getEnglishWord();
}
lwb=null;

String enterTripCode;
lwb=(LanguageWordsBean)langConverted.get("Enter_Trip_Code");
if(language.equals("ar")){
	enterTripCode=lwb.getArabicWord();
}else{
	enterTripCode=lwb.getEnglishWord();
}
lwb=null;

String selectOrgin;
lwb=(LanguageWordsBean)langConverted.get("Select_Orgin");
if(language.equals("ar")){
	selectOrgin=lwb.getArabicWord();
}else{
	selectOrgin=lwb.getEnglishWord();
}
lwb=null;

String enterAverageSpeed;
lwb=(LanguageWordsBean)langConverted.get("Enter_Average_Speed");
if(language.equals("ar")){
	enterAverageSpeed=lwb.getArabicWord();
}else{
	enterAverageSpeed=lwb.getEnglishWord();
}
lwb=null;

String averageSpeed;
lwb=(LanguageWordsBean)langConverted.get("Average_Speed");
if(language.equals("ar")){
	averageSpeed=lwb.getArabicWord();
}else{
	averageSpeed=lwb.getEnglishWord();
}
lwb=null;
langConverted=null;
%>

<!DOCTYPE HTML>
<html>
 <head>
 
		<title>Route Skeleton</title>		
	</head>	    
  
  <body height="100%" onload="refresh();">
   <jsp:include page="../Common/ImportJS.jsp" />
   <script>
 var outerPanel;
 var ctsb;
 var panel1;	
 var buttonvalue="add";  
 var transitionpointCounter=0; 
 var transitionIDArray=new Array();
 var transitionIDAddArray=new Array();
 var transtionformodify=new Array();
 var maxTransitionpoint=0;
  //In chrome activate was slow so refreshing the page
 function refresh()
                 {
                 isChrome = window.chrome;
					if(isChrome && parent.flagCargo<2) {
					// is chrome
						              setTimeout(function(){
						              parent.Ext.getCmp('CargoRouteSkeletonTab').enable();
									  parent.Ext.getCmp('CargoRouteSkeletonTab').show();
						              parent.Ext.getCmp('CargoRouteSkeletonTab').update("<iframe style='width:100%;height:600px;border:0;'src='<%=path%>/Jsps/CargoManagement/CargoRouteSkeleton.jsp'></iframe>");
						              },0);
						              parent.CargoTab.doLayout();
						              parent.flagCargo= parent.flagCargo+1;
					} 
                 }
                 /********************resize window event function***********************/
   Ext.EventManager.onWindowResize(function () {
   				var width = '99%';
			    var height = '100%';
			    outerPanel.setSize(width, height);
			    outerPanel.doLayout();
			});
 //******************************store for getting customer name************************
  var custmastcombostore= new Ext.data.JsonStore({
			url:'<%=request.getContextPath()%>/CommonAction.do?param=getCustomer',
				   id:'CustomerStoreId',
			       root: 'CustomerRoot',
			       autoLoad: true,
			       remoteSort: true,
				   fields: ['CustId','CustName'],
				   listeners: {
    				load: function(store, records, success, options) {
        				 if(<%=customeridlogged%>>0){
				 			Ext.getCmp('custmastcomboId').setValue('<%=customeridlogged%>');
				 			transitionpointCounter=0;
		                 	   transitionIDAddArray=new Array();
		                 	   maxTransitionpoint=0;
		                 	   //transitionIDAddArray.splice(0, transitionIDAddArray.length);
		                 	   Ext.getCmp('cargomultitransitionpoint').removeAll();Ext.getCmp('cargomultitransitionpoint').hide();
		                 	   Ext.getCmp('cargotripcode').reset();
							   Ext.getCmp('cargoorgin').reset();Ext.getCmp('cargotransitionpoint').reset();Ext.getCmp('cargodestination').reset();
							   Ext.getCmp('cargototaltime').reset();Ext.getCmp('cargoapproxdistance').reset();Ext.getCmp('cargoaveragespeed').reset();
		                 	   hubcombostore.load({
		                 	   params:{
		                 	   CustId:<%=customeridlogged%>
		                 	   }		                 	   
		                 	   });
		                 	   if(buttonvalue=="add")
		                 	   {
		                 	   Ext.getCmp('cargotripnametxt').reset();
		                 	   }
		                 	   if(buttonvalue=="modify"||buttonvalue=="delete")
		                 	   {
		                 	   Ext.getCmp('cargotripnamecombo').reset();		                	   	
		                 	   cargotripnamestore.load({
		                 	   params:{
		                 	   CustId:<%=customeridlogged%>
		                 	   }		                 	   
		                 	   });
		                 	   }
				 		  }
    				}
    				}
	});
	
//**************************** Combo for Customer Name***************************************************
 var custnamecombo=new Ext.form.ComboBox({
	        store: custmastcombostore,
	        id:'custmastcomboId',
	        mode: 'local',
	        hidden:false,
	        resizable:true,
	        forceSelection: true,
	        emptyText:'<%=selectCustomer%>',
	        blankText :'<%=selectCustomer%>',
	        selectOnFocus:true,
	        allowBlank: false,
	        typeAhead: true,
	        triggerAction: 'all',
	        lazyRender: true,
	    	valueField: 'CustId',
	    	displayField: 'CustName',
	    	cls:'selectstyle',
	    	listeners: {
		                   select: {
		                 	   fn:function(){
		                 	   transitionpointCounter=0;
		                 	   transitionIDAddArray=new Array();
		                 	   maxTransitionpoint=0;
		                 	   //transitionIDAddArray.splice(0, transitionIDAddArray.length);
		                 	   Ext.getCmp('cargomultitransitionpoint').removeAll();Ext.getCmp('cargomultitransitionpoint').hide();
		                 	   Ext.getCmp('cargotripcode').reset();
							   Ext.getCmp('cargoorgin').reset();Ext.getCmp('cargotransitionpoint').reset();Ext.getCmp('cargodestination').reset();
							   Ext.getCmp('cargototaltime').reset();Ext.getCmp('cargoapproxdistance').reset();Ext.getCmp('cargoaveragespeed').reset();
		                 	   hubcombostore.load({
		                 	   params:{
		                 	   CustId:Ext.getCmp('custmastcomboId').getValue()
		                 	   }		                 	   
		                 	   });
		                 	   if(buttonvalue=="add")
		                 	   {
		                 	   Ext.getCmp('cargotripnametxt').reset();
		                 	   }
		                 	   if(buttonvalue=="modify"||buttonvalue=="delete")
		                 	   {
		                 	   Ext.getCmp('cargotripnamecombo').reset();		                	   	
		                 	   cargotripnamestore.load({
		                 	   params:{
		                 	   CustId:Ext.getCmp('custmastcomboId').getValue()
		                 	   }		                 	   
		                 	   });
		                 	   }
                 	   }}
                 	   }   
    });
//*********************************** Store for Trip Details******************************************* 
var tripdetailsstore=new Ext.data.JsonStore({
                url:'<%=request.getContextPath()%>/CargoManagementAction.do?param=getTripDetails',
                id:'TripDetailsId',
                root:'TripDetailsRoot',
                autoLoad:false,
                remoteSort:true,
                fields:['cargotripcode','cargotriporgin','cargotransitions', 'cargotripdestination','cargototaltime','cargoapproxdistance','cargoaveragespeed']
 });    
//*************************************  Store for Trip Names******************************************    
var cargotripnamestore= new Ext.data.JsonStore({
			url:'<%=request.getContextPath()%>/CargoManagementAction.do?param=getTripNames',
				   id:'TripStoreId',
			       root: 'TripRoot',
			       autoLoad: false,
			       remoteSort: true,
				   fields: ['TripName']
	});  
//************************************** Combo for Trip Name*******************************************
 var cargotripnamecombo=new Ext.form.ComboBox({
	        store:cargotripnamestore,
	        id:'cargotripnamecombo',
	        mode: 'local',
	        forceSelection: true,
	        resizable:true,
	        emptyText:'<%=selectTripName%>',
	        blankText :'<%=selectTripName%>',
	        selectOnFocus:true,
	        allowBlank: false,
	        typeAhead: true,
	        triggerAction: 'all',
	        lazyRender: true,
	    	valueField: 'TripName',
	    	displayField: 'TripName',
	    	cls:'selectstyle',
	    	listeners: {
		                   select: {
		                 	   fn:function(){
		                 	   transtionformodify=new Array();
		                 	   transitionpointCounter=0;
		                 	   maxTransitionpoint=0;
							   transitionIDArray=new Array();
							   Ext.getCmp('cargomultitransitionpoint').removeAll();
							   if(buttonvalue=="modify")
		                 	   {
		                 	   tripdetailsstore.load({
		                 	   params:{
		                 	   			CustId:Ext.getCmp('custmastcomboId').getValue(),
		                 	   			TripName:Ext.getCmp('cargotripnamecombo').getValue()
		                 	   },
		                 	   callback:function(){
								  var rec = tripdetailsstore.getAt(0);
								  transtionformodify = rec.data['cargotransitions'].split(',');
								 
								  Ext.getCmp('cargotripcode').setValue(rec.data['cargotripcode']);
								  Ext.getCmp('cargoorgin').setValue(rec.data['cargotriporgin']);
								  maxTransitionpoint=transtionformodify.length-1;								  
								  if(transtionformodify.length==1)
								 	{
								 	 	Ext.getCmp('cargotransitionpoint').setValue(rec.data['cargotransitions']);
								 		Ext.getCmp('cargomultitransitionpoint').removeAll();
								 		Ext.getCmp('cargomultitransitionpoint').hide();
								 	}
								 if(transtionformodify.length>1)  
								 	{
								 		creatTransitionsforModify(transtionformodify.length);
								 		Ext.getCmp('cargotransitionpoint').setValue(transtionformodify[0]);
								 		for(i=1;i<transtionformodify.length;i++)
								 		{
								 		Ext.getCmp('cargotransitionpoint-'+i).setValue(transtionformodify[i]);
								 		}
								 	}	
								  Ext.getCmp('cargodestination').setValue(rec.data['cargotripdestination']);
								  Ext.getCmp('cargototaltime').setValue(rec.data['cargototaltime']);
								  Ext.getCmp('cargoapproxdistance').setValue(rec.data['cargoapproxdistance']);
								  Ext.getCmp('cargoaveragespeed').setValue(rec.data['cargoaveragespeed'])
								  var rec = null;
								  var transtionformodify=null;
								  }	                 	   
		                 	   });
		                 	   }
		                 	   }
                 	   }
                 	   }   
    });   
    
 //**************8********************* Store for getting Hub Name **************************	

var hubcombostore= new Ext.data.JsonStore({
			url:'<%=request.getContextPath()%>/CargoManagementAction.do?param=getHubs',
				   id:'HubStoreId',
			       root: 'HubRoot',
			       autoLoad: false,
			       remoteSort: true,
				   fields: ['HubId','HubName']
	});
	   
 //************************************ Combo for Orgin***************************************
 var cargoorgincombo=new Ext.form.ComboBox({
	        store: hubcombostore,
	        id:'cargoorgin',
	        mode: 'local',
	        hidden:false,
	        forceSelection: true,
	        resizable:true,
	        emptyText:'<%=selectOrgin%>',
	        blankText :'<%=selectOrgin%>',
	        selectOnFocus:true,
	        allowBlank: false,
	        typeAhead: true,
	        triggerAction: 'all',
	        lazyRender: true,
	    	valueField: 'HubId',
	    	displayField: 'HubName',
	    	cls:'selectstyle',
	    	listeners: {
		                   select: {
		                 	   fn:function(){
								if(Ext.getCmp(this.getId()).getValue() == Ext.getCmp('cargotransitionpoint').getValue() )
									    {
								             ctsb.setStatus({
											 text: getMessageForStatus('<%=cargOrginandTransitionpointcannotbesame%>'), 
											 iconCls:'',
											 clear: true
					                       	 });
					                       	 Ext.getCmp(this.getId()).reset();
					                       	 Ext.getCmp(this.getId()).focus();
					                       	 return;
									    }
							    if(Ext.getCmp(this.getId()).getValue() == Ext.getCmp('cargodestination').getValue() )
									    {
								             ctsb.setStatus({
											 text: getMessageForStatus('<%=cargoOrginandDestinationpointcannotbesame%>'), 
											 iconCls:'',
											 clear: true
					                       	 });
					                       	 Ext.getCmp(this.getId()).reset();
					                       	 Ext.getCmp(this.getId()).focus();
					                       	 return;
									    }		    
		                 	   }
                 	   }
                 	   }   
    });   
    
  var cargotranstioncombo=new Ext.form.ComboBox({
	        store: hubcombostore,
	        id:'cargotransitionpoint',
	        mode: 'local',
	        hidden:false,
	        forceSelection: true,
	        emptyText:'<%=selectTransitionPoint%>',
	        blankText :'<%=selectTransitionPoint%>',
	        selectOnFocus:true,
	        allowBlank: false,
	        resizable:true,
	        typeAhead: true,
	        triggerAction: 'all',
	        lazyRender: true,
	    	valueField: 'HubId',
	    	displayField: 'HubName',
	    	cls:'selectstyle',
	    	listeners: {
		                   select: {
		                 	   fn:function(){
		                 	    if(Ext.getCmp(this.getId()).getValue() == Ext.getCmp('cargoorgin').getValue() )
									    {
								             ctsb.setStatus({
											 text: getMessageForStatus('<%=cargOrginandTransitionpointcannotbesame%>'), 
											 iconCls:'',
											 clear: true
					                       	 });
					                       	 Ext.getCmp(this.getId()).reset();
					                       	 Ext.getCmp(this.getId()).focus();
					                       	 return;
									    }
							    if(Ext.getCmp(this.getId()).getValue() == Ext.getCmp('cargodestination').getValue() )
									    {
								             ctsb.setStatus({
											 text: getMessageForStatus('<%=cargoDestinationandTransitionpointcannotbesame%>'), 
											 iconCls:'',
											 clear: true
					                       	 });
					                       	 Ext.getCmp(this.getId()).reset();
					                       	 Ext.getCmp(this.getId()).focus();
					                       	 return;
									    }	

		                 	   }
                 	   }
                 	   }   
    }); 
    
    var cargodestinationcombo=new Ext.form.ComboBox({
	        store: hubcombostore,
	        id:'cargodestination',
	        mode: 'local',
	        hidden:false,
	        forceSelection: true,
	        emptyText:'<%=selectCargoDestination%>',
	        blankText :'<%=selectCargoDestination%>',
	        selectOnFocus:true,
	        allowBlank: false,
	        resizable:true,
	        typeAhead: true,
	        triggerAction: 'all',
	        lazyRender: true,
	    	valueField: 'HubId',
	    	displayField: 'HubName',
	    	cls:'selectstyle',
	    	listeners: {
		                   select: {
		                 	   fn:function(){
								if(Ext.getCmp(this.getId()).getValue() == Ext.getCmp('cargoorgin').getValue() )
									    {
								             ctsb.setStatus({
											 text: getMessageForStatus('<%=cargoOrginandDestinationpointcannotbesame%>'), 
											 iconCls:'',
											 clear: true
					                       	 });
					                       	 Ext.getCmp(this.getId()).reset();
					                       	 Ext.getCmp(this.getId()).focus();
					                       	 return;
									    }
							    else if(Ext.getCmp(this.getId()).getValue() == Ext.getCmp('cargotransitionpoint').getValue() )
									    {
								             ctsb.setStatus({
											 text: getMessageForStatus('<%=cargoDestinationandTransitionpointcannotbesame%>'), 
											 iconCls:'',
											 clear: true
					                       	 });
					                       	 Ext.getCmp(this.getId()).reset();
					                       	 Ext.getCmp('cargotransitionpoint').focus();
					                       	 return;
									    }		    
		                 	   }
                 	   }
                 	   }   
    });    
    
   //**********************inner panel start******************************************* 
  var innerPanel = new Ext.Panel({
		standardSubmit: true,
		collapsible:false,
		cls:'innerpanellargepercentage',
		id:'custMaster',
		layout:'table',
		layoutConfig: {
			columns:3
		},
		items: [
				{
				xtype: 'label',
				text: '<%=CustomerName%>'+'  :',
				allowBlank: false,
				hidden:false,
				cls:'labelstyle',
				id:'custnamhidlab'
				},
				custnamecombo,{cls:'labelstyle'},
				{
				xtype: 'label',
				text: '<%=cargoTripName%>'+':',
				cls:'labelstyle',
				id:'cargotripnamecombolbl'
				},
				cargotripnamecombo,{cls:'labelstyle',id:'cargotripcomboblank'},
				{
				xtype: 'label',
				text: '<%=cargoTripCode%>'+'  :',
				cls:'labelstyle',
				id:'cargotripcodelbl'
				},
				{
				xtype:'textfield',
	    		cls:'textrnumberstyle',
	    		emptyText:'<%=enterCargoTripCode%>',
	    		blankText :'<%=enterCargoTripCode%>',
	    		allowBlank: false,
	    		id:'cargotripcode'
	    		},{cls:'labelstyle',id:'cargotripcodeblank'},
	    		{
				xtype: 'label',
				text: '<%=cargoTripName%>'+':',
				cls:'labelstyle',
				id:'cargotripnamelbl'
				},
				{
				xtype:'textfield',
	    		cls:'textrnumberstyle',
	    		emptyText:'<%=enterCargoTripName%>',
	    		blankText :'<%=enterCargoTripName%>',
	    		allowBlank: false,
	    		id:'cargotripnametxt'
	    		},{cls:'labelstyle',id:'cargotripnametxtblank'},
	    		{
				xtype: 'label',
				text: '<%=cargoOrgin%>'+'  :',
				cls:'labelstyle',
				id:'cargoorginlbl'
				},
				cargoorgincombo,{cls:'labelstyle',id:'cargoorginblank'},
	    		{
				xtype: 'label',
				text: '<%=cargoTransitionPoint%>'+'  :',
				cls:'labelstyle',
				id:'cargotransitionpointlbl'
				},
				cargotranstioncombo,
				{
       			xtype:'button',
      			text:'<%=add%>',
      			align:'right',
        		id:'addtransitionbutton',
        		cls:'buttonleftstyle',
        		hidden:false,
        		width:40,
       			listeners: {
       			click:{
       			 fn:function(){
       			if(transitionpointCounter==0)
       			{ 
				Ext.getCmp('cargomultitransitionpoint').show();
				}
				if(buttonvalue=="modify")
				{
				if(maxTransitionpoint<10)
				{
				maxTransitionpoint++;
				creatTransitionModify();
				}
				else
				{
				ctsb.setStatus({
												 text: getMessageForStatus('Maximum no of Transition Points is 10'), 
												 iconCls:'',
												 clear: true
						                       	 });
						                       	 return;
						                       	 }
				}
				else if(buttonvalue=="add")
				{
				if(maxTransitionpoint<10)
				{
				maxTransitionpoint++;							
				creatTransition();
				}
						else
				{
				ctsb.setStatus({
												 text: getMessageForStatus('Maximum no of Transition Points is 10'), 
												 iconCls:'',
												 clear: true
						                       	 });
						                       	 return;
						                       	 }
				}
                }
                }  
       			} 
       			},{cls:'labelstyle',id:'cargomultitransitionblank'},
       			
       			{
					xtype:'fieldset', 
					title:'<%=cargoTransitionPoint%>',
					cls:'fieldsetpanel',
					collapsible: false,
					colspan:3,
					id:'cargomultitransitionpoint',
					layout:'table',
					layoutConfig: {
						columns:3
				},
					items: [
	    		
	    		]
				},{cls:'labelstyle',id:'fieldsetblank1'},{cls:'labelstyle',id:'fieldsetblank2'},{cls:'labelstyle',id:'fieldsetblank3'},
	    		{
				xtype: 'label',
				text: '<%=cargoDestination%> '+'  :',
				cls:'labelstyle',
				id:'cargodestinationlbl'
				},
				cargodestinationcombo,
				{cls:'labelstyle',id:'cargodestinationblank'},
				{
				xtype: 'label',
				text: '<%=totalTime%>'+'  :',
				cls:'labelstyle',
				id:'cargototaltimelbl'
				},
				{
				xtype:'numberfield',
	    		cls:'textrnumberstyle',
	    		emptyText:'<%=provideTotalTime%>',
	    		blankText :'<%=provideTotalTime%>',
	    		allowBlank: false,
	    		id:'cargototaltime'
	    		},{cls:'labelstyle',id:'cargototaltimeblank'},
	    		{
				xtype: 'label',
				text: '<%=approximateDistance%>'+'  :',
				cls:'labelstyle',
				id:'cargoapproxdistancelbl'
				},
				{
				xtype:'numberfield',
	    		cls:'textrnumberstyle',
	    		emptyText:'<%=provideApproximateDistance%>',
	    		blankText :'<%=provideApproximateDistance%>',
	    		allowBlank: false,
	    		id:'cargoapproxdistance'
	    		},{cls:'labelstyle',id:'cargoapproxdistanceblank'},
	    		{
				xtype: 'label',
				text: '<%=averageSpeed%>'+'  :',
				cls:'labelstyle',
				id:'cargoaveragespeedlbl'
				},
				{
				xtype:'numberfield',
	    		cls:'textrnumberstyle',
	    		emptyText:'<%=enterAverageSpeed%>',
	    		blankText :'<%=enterAverageSpeed%>',
	    		allowBlank: false,
	    		id:'cargoaveragespeed'
	    		},{cls:'labelstyle',id:'cargoaveragespeedblank'},
				{cls:'labelstyle'},
				{
       			xtype:'button',
      			text:'<%=submit%>',
        		id:'addButtonId',
        		cls:' ',
        		width:80,
       			listeners: {
        		click:{
       			 fn:function(){
       			 if(buttonvalue=="add"){
        							  	//Action for Button
        							  	// Validation for Orgin,Destination and Transition Points...
        							  	// Every point must be different
										if(Ext.getCmp('custmastcomboId').getValue() == "" )
										    {
									             ctsb.setStatus({
												 text: getMessageForStatus("<%=selectCustomer%>"), 
												 iconCls:'',
												 clear: true
						                       	 });
						                       	 Ext.getCmp('custmastcomboId').focus();
						                       	 return;
										    }	
									    if(Ext.getCmp('cargotripcode').getValue() == "" )
									    {
								             ctsb.setStatus({
											 text: getMessageForStatus('<%=enterCargoTripCode%>'), 
											 iconCls:'',
											 clear: true
					                       	 });
					                       	 Ext.getCmp('cargotripcode').focus();
					                       	 return;
									    }	
									    if(Ext.getCmp('cargotripnametxt').getValue() == "" )
									    {
								             ctsb.setStatus({
											 text: getMessageForStatus('<%=enterCargoTripName%>'), 
											 iconCls:'',
											 clear: true
					                       	 });
					                       	 Ext.getCmp('cargotripnametxt').focus();
					                       	 return;
									    }
									    if(Ext.getCmp('cargoorgin').getValue() == "" )
									    {
								             ctsb.setStatus({
											 text: getMessageForStatus('<%=selectCargoOrgin%>'), 
											 iconCls:'',
											 clear: true
					                       	 });
					                       	 Ext.getCmp('cargoorgin').focus();
					                       	 return;
									    }									    
									    if(Ext.getCmp('cargotransitionpoint').getValue() == "" )
									    {
								             ctsb.setStatus({
											 text: getMessageForStatus('<%=selectTransitionPoint%>'), 
											 iconCls:'',
											 clear: true
					                       	 });
					                       	 Ext.getCmp('cargotransitionpoint').focus();
					                       	 return;
									    }	
									    if(Ext.getCmp('cargodestination').getValue() == "" )
									    {
								             ctsb.setStatus({
											 text: getMessageForStatus('<%=selectCargoDestination%>'), 
											 iconCls:'',
											 clear: true
					                       	 });
					                       	 Ext.getCmp('cargodestination').focus();
					                       	 return;
									    }
									    if(Ext.getCmp('cargototaltime').getValue() == "" )
									    {
								             ctsb.setStatus({
											 text: getMessageForStatus('<%=provideTotalTime%>'), 
											 iconCls:'',
											 clear: true
					                       	 });
					                       	 Ext.getCmp('cargototaltime').focus();
					                       	 return;
									    }
									    if(Ext.getCmp('cargoapproxdistance').getValue() == "" )
									    {
								             ctsb.setStatus({
											 text: getMessageForStatus('<%=provideApproximateDistance%>'), 
											 iconCls:'',
											 clear: true
					                       	 });
					                       	 Ext.getCmp('cargoapproxdistance').focus();
					                       	 return;
									    }
									     if(Ext.getCmp('cargoaveragespeed').getValue() == "" )
									    {
								             ctsb.setStatus({
											 text: getMessageForStatus('<%=enterAverageSpeed%>'), 
											 iconCls:'',
											 clear: true
					                       	 });
					                       	 Ext.getCmp('cargoaveragespeed').focus();
					                       	 return;
									    }
									    if(Ext.getCmp('cargoorgin').getValue() == Ext.getCmp('cargotransitionpoint').getValue() )
									    {
								             ctsb.setStatus({
											 text: getMessageForStatus('<%=cargOrginandTransitionpointcannotbesame%>'), 
											 iconCls:'',
											 clear: true
					                       	 });
					                       	 Ext.getCmp('cargotransitionpoint').focus();
					                       	 return;
									    }
									    if(Ext.getCmp('cargodestination').getValue() == Ext.getCmp('cargotransitionpoint').getValue() )
									    {
								             ctsb.setStatus({
											 text: getMessageForStatus('<%=cargoDestinationandTransitionpointcannotbesame%>'), 
											 iconCls:'',
											 clear: true
					                       	 });
					                       	 Ext.getCmp('cargodestination').focus();
					                       	 return;
									    }
									    if(Ext.getCmp('cargodestination').getValue() == Ext.getCmp('cargoorgin').getValue() )
									    {
								             ctsb.setStatus({
											 text: getMessageForStatus('<%=cargoOrginandDestinationpointcannotbesame%>'), 
											 iconCls:'',
											 clear: true
					                       	 });
					                       	 Ext.getCmp('cargodestination').focus();
					                       	 return;
									    }									    									    									   									    						    	
									    }
									   
						if(buttonvalue=="modify"){
									    	if(Ext.getCmp('custmastcomboId').getValue() == "" )
										    {
									             ctsb.setStatus({
												 text: getMessageForStatus("<%=selectCustomer%>"), 
												 iconCls:'',
												 clear: true
						                       	 });
						                       	 Ext.getCmp('custmastcomboId').focus();
						                       	 return;
										    }
										   	if(Ext.getCmp('cargotripnamecombo').getValue() == "" )
										    {
									             ctsb.setStatus({
												 text: getMessageForStatus('<%=selectTripName%>'), 
												 iconCls:'',
												 clear: true
						                       	 });
						                       	 Ext.getCmp('cargotripnamecombo').focus();
						                       	 return;
										    }
										     if(Ext.getCmp('cargotripcode').getValue() == "" )
										    {
									             ctsb.setStatus({
												 text: getMessageForStatus('<%=enterTripCode%>'), 
												 iconCls:'',
												 clear: true
						                       	 });
						                       	 Ext.getCmp('cargotripcode').focus();
						                       	 return;
										    }	
										    
										    if(Ext.getCmp('cargoorgin').getValue() == "" )
										    {
									             ctsb.setStatus({
												 text: getMessageForStatus('<%=selectOrgin%>'), 
												 iconCls:'',
												 clear: true
						                       	 });
						                       	 Ext.getCmp('cargoorgin').focus();
						                       	 return;
										    }
										    if(Ext.getCmp('cargotransitionpoint').getValue() == "" )
										    {
									             ctsb.setStatus({
												 text: getMessageForStatus('<%=selectTransitionPoint%>'), 
												 iconCls:'',
												 clear: true
						                       	 });
						                       	 Ext.getCmp('cargotransitionpoint').focus();
						                       	 return;
										    }
										    if(Ext.getCmp('cargodestination').getValue() == "" )
									    	{
								             	ctsb.setStatus({
											 	text: getMessageForStatus('<%=selectCargoDestination%>'), 
											 	iconCls:'',
											 	clear: true
					                       	 	});
					                       	 	Ext.getCmp('cargodestination').focus();
					                       	 	return;
									    	}
										    if(Ext.getCmp('cargototaltime').getValue() == "" )
									    	{
								             	ctsb.setStatus({
											 	text: getMessageForStatus('<%=provideTotalTime%>'), 
											 	iconCls:'',
											 	clear: true
					                       	 	});
					                       	 	Ext.getCmp('cargototaltime').focus();
					                       	 	return;
									    	}
									    	if(Ext.getCmp('cargoapproxdistance').getValue() == "" )
									    	{
								             	ctsb.setStatus({
											 	text: getMessageForStatus('<%=provideApproximateDistance%>'), 
											 	iconCls:'',
											 	clear: true
					                       	 	});
					                       	 	Ext.getCmp('cargoapproxdistance').focus();
					                       	 	return;
									    	}
									     	if(Ext.getCmp('cargoaveragespeed').getValue() == "" )
									    	{
								             	ctsb.setStatus({
											 	text: getMessageForStatus('<%=enterAverageSpeed%>'), 
											 	iconCls:'',
											 	clear: true
					                       	 	});
					                       	 	Ext.getCmp('cargoaveragespeed').focus();
					                       	 	return;
									    }
										    
									    }
									    if(buttonvalue=="add")
									    {
									    var transitionnoArray=new Array();
									    transitionnoArray.push(Ext.getCmp('cargotransitionpoint').getValue());
									    if(transitionIDAddArray.length>0)
									    {							    
									    for(var i=0;i<=transitionIDAddArray.length-1;i++)
										{
										if(Ext.getCmp('cargotransitionpoint-'+transitionIDAddArray[i]).getValue() == "" )
										    {
									             ctsb.setStatus({
												 text: getMessageForStatus('<%=selectTransitionPoint%>'), 
												 iconCls:'',
												 clear: true
						                       	 });
						                       	 Ext.getCmp('cargotransitionpoint').focus();
						                       	 return;
										    }
										//**** Validation for Orgin and Transition Points//
										if(Ext.getCmp('cargotransitionpoint-'+transitionIDAddArray[i]).getValue() == Ext.getCmp('cargoorgin').getValue() )
										    {
									             ctsb.setStatus({
												 text: getMessageForStatus('<%=cargOrginandTransitionpointcannotbesame%>'), 
												 iconCls:'',
												 clear: true
						                       	 });
						                       	 Ext.getCmp('cargotransitionpoint').focus();
						                       	 return;
										    }
										//**** Validation for Destination and Transition Points// 
										if(Ext.getCmp('cargotransitionpoint-'+transitionIDAddArray[i]).getValue() == Ext.getCmp('cargodestination').getValue() )
										    {
									             ctsb.setStatus({
												 text: getMessageForStatus('<%=cargoDestinationandTransitionpointcannotbesame%>'), 
												 iconCls:'',
												 clear: true
						                       	 });
						                       	 Ext.getCmp('cargotransitionpoint').focus();
						                       	 return;
										    }    
										transitionnoArray.push(Ext.getCmp('cargotransitionpoint-'+transitionIDAddArray[i]).getValue());
										}										
									    }
									    var transitions=transitionnoArray.join(",");
									    }
									    else if(buttonvalue=="modify")
									    {
									    var transitionnoArray=new Array();
									    transitionnoArray.push(Ext.getCmp('cargotransitionpoint').getValue());
									    if(transitionIDArray.length>0)
									    {								    
									    for(var i=0;i<transitionIDArray.length;i++)
										{
										if(Ext.getCmp('cargotransitionpoint-'+transitionIDArray[i]).getValue() == "" )
										    {
									             ctsb.setStatus({
												 text: getMessageForStatus('<%=selectTransitionPoint%>'), 
												 iconCls:'',
												 clear: true
						                       	 });
						                       	 Ext.getCmp('cargotransitionpoint').focus();
						                       	 return;
										    }
										//**** Validation for Orgin and Transition Points//
										if(Ext.getCmp('cargotransitionpoint-'+transitionIDArray[i]).getValue() == Ext.getCmp('cargoorgin').getValue() )
										    {
									             ctsb.setStatus({
												 text: getMessageForStatus('<%=cargOrginandTransitionpointcannotbesame%>'), 
												 iconCls:'',
												 clear: true
						                       	 });
						                       	 Ext.getCmp('cargoorgin').focus();
						                       	 return;
										    }
										//**** Validation for Destination and Transition Points// 
										if(Ext.getCmp('cargotransitionpoint-'+transitionIDArray[i]).getValue() == Ext.getCmp('cargodestination').getValue() )
										    {
									             ctsb.setStatus({
												 text: getMessageForStatus('<%=cargoDestinationandTransitionpointcannotbesame%>'), 
												 iconCls:'',
												 clear: true
						                       	 });
						                       	 Ext.getCmp('cargodestination').focus();
						                       	 return;
										    }   
										transitionnoArray.push(Ext.getCmp('cargotransitionpoint-'+transitionIDArray[i]).getValue());
										}										
									    }
									    var transitions=transitionnoArray.join(",");
									    }
									    if(hasDuplicates(transitionnoArray))
									    {
									    ctsb.setStatus({
												 text: getMessageForStatus('<%=transitionPointscannotbesame%>'), 
												 iconCls:'',
												 clear: true
						                       	 });
						                       	 //Ext.getCmp('cargotransitionpoint').focus();
						                       	 return;
									    }
									    outerPanel.getEl().mask();
									    //Ajax request
										Ext.Ajax.request({													
										 				url: '<%=request.getContextPath()%>/CargoManagementAction.do?param=saveormodifyContainer',
														method: 'POST',
														params: 
														{
															 buttonvalue:buttonvalue,
															 transitionpointCounter:transitionpointCounter,
												         	 custmastcomboId:Ext.getCmp('custmastcomboId').getValue(),
												         	 cargotripnamecombo:Ext.getCmp('cargotripnamecombo').getValue(),
												         	 cargotripnametxt:Ext.getCmp('cargotripnametxt').getValue(),
												         	 cargotripcode: Ext.getCmp('cargotripcode').getValue(),
												         	 cargoorgin: Ext.getCmp('cargoorgin').getValue(),
												         	 transitionnoArray:transitions,
												         	 cargodestination:Ext.getCmp('cargodestination').getValue(),
												         	 cargototaltime:Ext.getCmp('cargototaltime').getValue(),
												         	 cargoapproxdistance:Ext.getCmp('cargoapproxdistance').getValue(),
												         	 cargoaveragespeed:Ext.getCmp('cargoaveragespeed').getValue()
												         	 
												        },
														success:function(response, options)//start of success
												        {
											            ctsb.setStatus({
																 text:getMessageForStatus(response.responseText), 
																 iconCls:'',
																 clear: true
											                     });
											                transitionpointCounter=0;
											                maxTransitionpoint=0;
												       		transitionIDArray.splice(0, transitionIDArray.length);
												       		if(buttonvalue=="add")
												       		{
												       		Ext.getCmp('cargotripnametxt').reset();
												       		transitionIDAddArray=new Array();												       		
												       		}										       		
												       		if(buttonvalue=="modify")
												       		{											       		
												       		Ext.getCmp('cargotripnamecombo').reset();
												       		transitionIDArray=new Array();												       		
												       		}    
												       		Ext.getCmp('custmastcomboId').reset();Ext.getCmp('cargotripcode').reset();			
															Ext.getCmp('cargoorgin').reset();Ext.getCmp('cargotransitionpoint').reset();
															Ext.getCmp('cargodestination').reset();							
															Ext.getCmp('cargototaltime').reset();Ext.getCmp('cargoapproxdistance').reset();
															Ext.getCmp('cargoaveragespeed').reset();
															Ext.getCmp('cargomultitransitionpoint').removeAll();
															Ext.getCmp('cargomultitransitionpoint').hide();															
												       		custmastcombostore.reload();
												     
												       		outerPanel.getEl().unmask();
														}, // END OF  SUCCESS
											    		failure: function()//start of failure 
											   			 {
											    	  			 ctsb.setStatus({
																 text:getMessageForStatus("Error"), 
																 iconCls:'',
																 clear: true
											                     });
												      		Ext.getCmp('custmastcomboId').reset();Ext.getCmp('cargotripcode').reset();			
															Ext.getCmp('cargoorgin').reset();Ext.getCmp('cargotransitionpoint').reset();
															Ext.getCmp('cargodestination').reset();	
															Ext.getCmp('cargototaltime').reset();Ext.getCmp('cargoapproxdistance').reset();
															Ext.getCmp('cargoaveragespeed').reset();
															Ext.getCmp('cargomultitransitionpoint').removeAll();
															Ext.getCmp('cargomultitransitionpoint').hide();															
												       		transitionpointCounter=0;
												       		maxTransitionpoint=0;
												       		if(buttonvalue=="add")
												       		{
												       		Ext.getCmp('cargotripnametxt').reset();
												       		transitionIDAddArray=new Array();												       		
												       		}										       		
												       		if(buttonvalue=="modify")
												       		{											       		
												       		Ext.getCmp('cargotripnamecombo').reset();
												       		transitionIDArray=new Array();												       		
												       		} 
												      		custmastcombostore.reload();
												      
												       outerPanel.getEl().unmask();
												} // END OF FAILURE 
											}); // END OF AJAX							   
      							   } // END OF FUNCTION
       							  } // END OF CLICK
       							} // END OF LISTENERS
       						},{},{cls:'labelstyle'},
       			{
       			xtype:'button',
      			text:'<%=delete%>',
        		id:'deletecargotrip',
        		cls:' ',
        		hidden:true,
        		width:80,
       			listeners: {
        		click:{
       			 fn:function(){
       			 Ext.Msg.show({
										title: '<%=delete%>',
										msg: '<%=wantToDelete%>',
										buttons: {
										yes: true,
										no: true
										},
										fn: function(btn) {
										switch(btn){
										case 'yes':  
        						if(Ext.getCmp('custmastcomboId').getValue() == "" )
							    {
						             ctsb.setStatus({
									 text: getMessageForStatus('Select Cutomer'), 
									 iconCls:'',
									 clear: true
			                       	 });
			                       	 Ext.getCmp('custmastcomboId').focus();
			                       	 return;
							    }	
							    if(Ext.getCmp('cargotripnamecombo').getValue() == "" )
							    {
						             ctsb.setStatus({
									 text: getMessageForStatus('Select Trip Name'), 
									 iconCls:'',
									 clear: true
			                       	 });
			                       	 Ext.getCmp('cargotripnamecombo').focus();
			                       	 return;
							    }
						    	var custId=Ext.getCmp('custmastcomboId').getValue();
						    	//showing message
							    ctsb.showBusy('<%=deleting%>');
								outerPanel.getEl().mask();
								//Ajax request
								Ext.Ajax.request({
								 				url: '<%=request.getContextPath()%>/CargoManagementAction.do?param=deleteCargoTrip',
												method: 'POST',
												params: 
												{
													 custId:custId,
													 tripName:Ext.getCmp('cargotripnamecombo').getValue()
										        },
												success:function(response, options)//start of success
												{
											         ctsb.setStatus({
																 text:getMessageForStatus(response.responseText), 
																 iconCls:'',
																 clear: true
											                     });
												      Ext.getCmp('custmastcomboId').reset();	
												      Ext.getCmp('cargotripnamecombo').reset();
												      custmastcombostore.reload();
												     
												       outerPanel.getEl().unmask();
												}, // END OF  SUCCESS
											    failure: function()//start of failure 
											    {
											    	  ctsb.setStatus({
																 text:getMessageForStatus("Error"), 
																 iconCls:'',
																 clear: true
											                     });
												      Ext.getCmp('custmastcomboId').reset();
												      Ext.getCmp('cargotripnamecombo').reset();
												      custmastcombostore.reload();
												      
												       outerPanel.getEl().unmask();
												} // END OF FAILURE 
									}); // END OF AJAX
									
											break;
										case 'no':
														ctsb.setStatus({
																 text:getMessageForStatus("<%=custNotDeleted%>"), 
																 iconCls:'',
																 clear: true
											                     });
												      Ext.getCmp('custmastcomboId').reset();
												      custmastcombostore.reload();
												     
														break;
														
														}
														}
														});	
      							   } // END OF FUNCTION
       							  } // END OF CLICK
       							} // END OF LISTENERS
       						}
				
			]
		}); // End of Panel	
		
		
//******************************  Function for creating Transition Points Dynamicaly for Add*********************		
function creatTransition()
{
	if(transitionIDAddArray.length==0)
	{
	Ext.getCmp('cargomultitransitionpoint').show();
	transitionpointCounter=1;
	}
	else
	{
	transitionpointCounter=transitionIDAddArray[transitionIDAddArray.length-1]+1;
	}
	transitionIDAddArray.push(transitionpointCounter);
 	var cargotranstionlbl=new Ext.form.Label({
	        text: '<%=transitionPoint%>',
			cls:'labelstyle',
			id:'cargotransitionpointlbl-'+transitionpointCounter,
	    	listeners: {
		               select: {
		                 	   fn:function(){}}
                 	   }   
    }); 
	var cargotranstioncombo=new Ext.form.ComboBox({
	        store: hubcombostore,
	        id:'cargotransitionpoint-'+transitionpointCounter,
	        mode: 'local',
	        hidden:false,
	        forceSelection: true,
	        emptyText:'<%=selectTransitionPoint%>',
	        blankText :'<%=selectTransitionPoint%>',
	        selectOnFocus:true,
	        allowBlank: false,
	        resizable:true,
	        typeAhead: true,
	        triggerAction: 'all',
	        lazyRender: true,
	    	valueField: 'HubId',
	    	displayField: 'HubName',
	    	cls:'selectstyle',
	    	listeners: {
	    				select: {
		                 	   fn:function(){
		                 	   var comboId=this.getId();
		                 	   validationTransitionPoints(comboId);
		                 	   validationsameTransitionPointsADD(comboId);
		                 	   }
                 	   }}   
    });  
    var cargotranstiondelete=new Ext.Button({
      			text:'Delete',
        		id:'-'+transitionpointCounter,
        		cls:'buttonleftstyle',
        		hidden:false,
        		width:40,
       			handler: function () {
       			var deletebuttonID=this.getId();		
				deleteTransitionAdd(deletebuttonID);
                 
       			}}); 
    
    		    			
       			
    Ext.getCmp('cargomultitransitionpoint').add('cargotransitionpointlbl-'+transitionpointCounter);       
	Ext.getCmp('cargomultitransitionpoint').add('cargotransitionpoint-'+transitionpointCounter);
	Ext.getCmp('cargomultitransitionpoint').add('-'+transitionpointCounter);


	Ext.getCmp('cargomultitransitionpoint').doLayout();    
}
//******************************* Create Transition points for modify******************************
function creatTransitionModify()
{
	if(transitionIDArray.length==0)
	{
	Ext.getCmp('cargomultitransitionpoint').show();
	transitionpointCounter=1;
	}
	else
	{
	transitionpointCounter=transitionIDArray[transitionIDArray.length-1]+1;
	}
	transitionIDArray.push(transitionpointCounter);
 	var cargotranstionlbl=new Ext.form.Label({
	        text: 'Transition Point:',
			cls:'labelstyle',
			id:'cargotransitionpointlbl-'+transitionpointCounter,
	    	listeners: {
		               select: {
		                 	   fn:function(){}}
                 	   }   
    }); 
	var cargotranstioncombo=new Ext.form.ComboBox({
	        store: hubcombostore,
	        id:'cargotransitionpoint-'+transitionpointCounter,
	        mode: 'local',
	        hidden:false,
	        forceSelection: true,
	        emptyText:'<%=selectTransitionPoint%>',
	        blankText :'<%=selectTransitionPoint%>',
	        selectOnFocus:true,
	        allowBlank: false,
	        resizable:true,
	        typeAhead: true,
	        triggerAction: 'all',
	        lazyRender: true,
	    	valueField: 'HubId',
	    	displayField: 'HubName',
	    	cls:'selectstyle',
	    	listeners: {
	    				select: {
		                 	   fn:function(){
		                 	   var comboId=this.getId();
		                 	   validationTransitionPoints(comboId);
		                 	   validationsameTransitionPointsModify(comboId);
		                 	   }
                 	   }}   
    });  
    var cargotranstiondelete=new Ext.Button({
      			text:'Delete',
        		id:'-'+transitionpointCounter,
        		cls:'buttonleftstyle',
        		hidden:false,
        		width:40,
       			handler: function () {
       			var deletebuttonID=this.getId();		
				deleteTransition(deletebuttonID);
                 
       			}}); 
    
    		    			
       			
    Ext.getCmp('cargomultitransitionpoint').add('cargotransitionpointlbl-'+transitionpointCounter);       
	Ext.getCmp('cargomultitransitionpoint').add('cargotransitionpoint-'+transitionpointCounter);
	Ext.getCmp('cargomultitransitionpoint').add('-'+transitionpointCounter);


	Ext.getCmp('cargomultitransitionpoint').doLayout();    
}
//****************************** Function for removeing array based on index************************ 
Array.prototype.removeByIndex = function(index) {
    this.splice(index, 1);
}
///*************************  Function deletes Dynamicaly added Transition Points******************
function deleteTransition(deletebuttonID)
{
	var deletebuttonarrayID=getPosition((deletebuttonID*-1),transitionIDArray);;
	transitionIDArray.removeByIndex(deletebuttonarrayID);
	Ext.getCmp('cargomultitransitionpoint').remove('cargotransitionpointlbl'+deletebuttonID,true);
	Ext.getCmp('cargomultitransitionpoint').remove('cargotransitionpoint'+deletebuttonID,true);
	Ext.getCmp('cargomultitransitionpoint').remove(deletebuttonID,true);
	Ext.getCmp('cargomultitransitionpoint').doLayout(); 
	if(transitionIDArray.length==0)
	{
		Ext.getCmp('cargomultitransitionpoint').removeAll();
		Ext.getCmp('cargomultitransitionpoint').hide();
	}
	maxTransitionpoint--;
}

//**************************  Get index Function******************************************************
function getPosition(elementToFind, arrayElements) {
    var i;
    for (i = 0; i < arrayElements.length; i += 1) {
        if (arrayElements[i] === elementToFind) {
            return i;
        }
    }
    return null; //not found
}
///*************************  Function deletes Dynamicaly added Transition Points for Add Option ******************
function deleteTransitionAdd(deletebuttonID)
{
	var deletebuttonarrayID=getPosition((deletebuttonID*-1),transitionIDAddArray);;
	transitionIDAddArray.removeByIndex(deletebuttonarrayID);
	Ext.getCmp('cargomultitransitionpoint').remove('cargotransitionpointlbl'+deletebuttonID,true);
	Ext.getCmp('cargomultitransitionpoint').remove('cargotransitionpoint'+deletebuttonID,true);
	Ext.getCmp('cargomultitransitionpoint').remove(deletebuttonID,true);
	Ext.getCmp('cargomultitransitionpoint').doLayout(); 
	if(transitionIDAddArray.length==0)
	{
		Ext.getCmp('cargomultitransitionpoint').removeAll();
		Ext.getCmp('cargomultitransitionpoint').hide();
	}
	maxTransitionpoint--;	
}	
//*************************    Function creates Transition for modify option*************************
function creatTransitionsforModify(noofTransitions) 
{
transitionIDArray=new Array();
transitionpointCounter=noofTransitions-1; 	
Ext.getCmp('cargomultitransitionpoint').show();
Ext.getCmp('cargomultitransitionpoint').remove();
for(i=1;i<noofTransitions;i++)
{ 
	transitionIDArray.push(i);
	var cargotranstionlbl=new Ext.form.Label({
	        text: 'Transition Point:',
			cls:'labelstyle',
			id:'cargotransitionpointlbl-'+i,
	    	listeners: {
		               select: {
		                 	   fn:function(){}}
                 	   }   
    });    
	var cargotranstioncombo=new Ext.form.ComboBox({
	        store: hubcombostore,
	        id:'cargotransitionpoint-'+i,
	        mode: 'local',
	        hidden:false,
	        forceSelection: true,
	        emptyText:'Select Transition Point',
	        blankText :'Select Transition Point',
	        selectOnFocus:true,
	        allowBlank: false,
	        resizable:true,
	        typeAhead: true,
	        triggerAction: 'all',
	        lazyRender: true,
	    	valueField: 'HubId',
	    	displayField: 'HubName',
	    	cls:'selectstyle',
	    	listeners: {
	    				select: {
		                 	   fn:function(){
		                 	   }
                 	   }}   
    });  
       
    var cargotranstiondelete=new Ext.Button({
      			text:'Delete',
        		id:'-'+i,
        		cls:'buttonleftstyle',
        		hidden:false,
        		width:40,
       			handler: function () {
       			var deletebuttonID=this.getId();		
				deleteTransition(deletebuttonID);
                 
       			}}); 
    
    		    						
    Ext.getCmp('cargomultitransitionpoint').add('cargotransitionpointlbl-'+i);       
	Ext.getCmp('cargomultitransitionpoint').add('cargotransitionpoint-'+i);
	Ext.getCmp('cargomultitransitionpoint').add('-'+i); 

	Ext.getCmp('cargomultitransitionpoint').doLayout(); 
			
}
} 
//************************************** Function to check validation for Transition Points***********
function validationTransitionPoints(currentTransitionID)
{
if(Ext.getCmp('cargoorgin').getValue()==Ext.getCmp(currentTransitionID).getValue())
{
ctsb.setStatus({
												 text: getMessageForStatus('<%=cargOrginandTransitionpointcannotbesame%>'), 
												 iconCls:'',
												 clear: true
						                       	 });
						                       	 Ext.getCmp(currentTransitionID).focus();
						                       	 return;
alert('repeat');
return;
}
else if(Ext.getCmp('cargodestination').getValue()==Ext.getCmp(currentTransitionID).getValue())
{
ctsb.setStatus({
												 text: getMessageForStatus('<%=cargoDestinationandTransitionpointcannotbesame%>'), 
												 iconCls:'',
												 clear: true
						                       	 });
						                       	 Ext.getCmp(currentTransitionID).focus();
						                       	 return;
}
else if(Ext.getCmp('cargotransitionpoint').getValue()==Ext.getCmp(currentTransitionID).getValue())
{
ctsb.setStatus({
												 text: getMessageForStatus('<%=transitionPointscannotbesame%>'), 
												 iconCls:'',
												 clear: true
						                       	 });
						                       	 Ext.getCmp(currentTransitionID).focus();
						                       	
						                       	 return;
}

return;
}
//*********************************** Validation for same transitionpoints for Add**************
function validationsameTransitionPointsADD(currentTransitionID)
{
if(transitionIDAddArray.length>1)
{
var temptransitionIDAddArray = [].concat(transitionIDAddArray);
for(i=0;i<temptransitionIDAddArray.length;i++)
{
if(!('cargotransitionpoint-'+temptransitionIDAddArray[i]==currentTransitionID))
{
if(Ext.getCmp('cargotransitionpoint-'+temptransitionIDAddArray[i]).getValue()==Ext.getCmp(currentTransitionID).getValue())
{
ctsb.setStatus({
												 text: getMessageForStatus('<%=transitionPointscannotbesame%>'), 
												 iconCls:'',
												 clear: true
						                       	 });
						                       	 Ext.getCmp(currentTransitionID).focus();
						                       	 return;
}
}
}
}
}
//*********************************** Validation for same transitionpoints for Modify**************
function validationsameTransitionPointsModify(currentTransitionID)
{
if(transitionIDArray.length>1)
{
var temptransitionIDArray = [].concat(transitionIDArray);
for(i=0;i<temptransitionIDArray.length;i++)
{
if(!('cargotransitionpoint-'+temptransitionIDArray[i]==currentTransitionID))
{
if(Ext.getCmp('cargotransitionpoint-'+temptransitionIDArray[i]).getValue()==Ext.getCmp(currentTransitionID).getValue())
{
ctsb.setStatus({
												 text: getMessageForStatus('<%=transitionPointscannotbesame%>'), 
												 iconCls:'',
												 clear: true
						                       	 });
						                       	 Ext.getCmp(currentTransitionID).focus();
						                       	 return;
}
}
}
}
return;
}
//************** Function for validation,to check duplicate values in transition array ****************
function hasDuplicates(array) {
    var valuesSoFar = {};
    for (var i = 0; i < array.length; ++i) {
        var value = array[i];
        if (Object.prototype.hasOwnProperty.call(valuesSoFar, value)) {
            return true;
        }
        valuesSoFar[value] = true;
    }
    return false;
}
Ext.override(Ext.Container, {
    removeAll: function() {
        this.items.each(function(childItem){ this.remove(childItem);}, this);
    }
});
//***************************  Main starts from here **************************************************
 Ext.onReady(function(){
	ctsb=tsb;
	panel1=pageModifyPanel;
	Ext.QuickTips.init();
	Ext.form.Field.prototype.msgTarget = 'side';			         	   			
 	outerPanel = new Ext.Panel({
			title:'<%=RouteSkeleton%>',
			renderTo : 'content',
			standardSubmit: true,
			height:550,
			frame:true,
			cls:'mainpanelpercentage',
			items: [panel1,innerPanel],
			bbar:ctsb			
			}); 
			Ext.getCmp('cargomultitransitionpoint').hide();Ext.getCmp('cargomultitransitionblank').hide();  
			Ext.getCmp('fieldsetblank1').hide();Ext.getCmp('fieldsetblank2').hide();Ext.getCmp('fieldsetblank3').hide();
			Ext.getCmp('cargotripnamecombolbl').hide();Ext.getCmp('cargotripcomboblank').hide();Ext.getCmp('cargotripnamecombo').hide();
				
			Ext.getCmp('pagemodimodify').on("click", function(){
			transitionpointCounter=0;
			maxTransitionpoint=0;
			transitionIDArray=new Array();
			transtionformodify=new Array();
			buttonvalue="modify";
			custmastcombostore.reload();			
			Ext.getCmp('cargomultitransitionpoint').removeAll();Ext.getCmp('cargomultitransitionpoint').hide();
			Ext.getCmp('deletecargotrip').hide();
			Ext.getCmp('cargotripnamelbl').hide();Ext.getCmp('cargotripnametxt').hide();Ext.getCmp('cargotripnametxtblank').hide();
			Ext.getCmp('custmastcomboId').reset();Ext.getCmp('cargotripcode').reset();
			Ext.getCmp('cargoorgin').reset();Ext.getCmp('cargotransitionpoint').reset();Ext.getCmp('cargodestination').reset();
			Ext.getCmp('cargototaltime').reset();Ext.getCmp('cargoaveragespeed').reset();Ext.getCmp('cargoapproxdistance').reset();								
			Ext.getCmp('cargotripnamecombolbl').show();Ext.getCmp('cargotripcomboblank').show();Ext.getCmp('cargotripnamecombo').show();
			Ext.getCmp('custmastcomboId').show();Ext.getCmp('custnamhidlab').show();
			Ext.getCmp('cargotripcodelbl').show();Ext.getCmp('cargotripcode').show();						
			Ext.getCmp('cargoorginlbl').show();Ext.getCmp('cargoorgin').show();
			Ext.getCmp('cargotransitionpointlbl').show();Ext.getCmp('cargotransitionpoint').show();
			Ext.getCmp('cargodestinationlbl').show();Ext.getCmp('cargodestination').show();
			Ext.getCmp('cargototaltimelbl').show();Ext.getCmp('cargoapproxdistancelbl').show();
			Ext.getCmp('cargototaltime').show();Ext.getCmp('cargoapproxdistance').show();
			Ext.getCmp('cargoaveragespeed').show();Ext.getCmp('cargoaveragespeedlbl').show();Ext.getCmp('cargoaveragespeedblank').show();
			Ext.getCmp('addButtonId').show();
			Ext.getCmp('addtransitionbutton').show();Ext.getCmp('cargotripnamecombo').reset();
			});
			
			Ext.getCmp('pagemodiadd').on("click", function () { 
			transitionpointCounter=0;
			maxTransitionpoint=0;
			transitionIDAddArray=new Array();
			transtionformodify=new Array();
			buttonvalue="add";
			custmastcombostore.reload();			
			Ext.getCmp('cargotripnamecombolbl').hide();Ext.getCmp('cargotripnamecombo').hide();Ext.getCmp('cargotripcomboblank').hide();
			Ext.getCmp('cargomultitransitionpoint').removeAll();Ext.getCmp('cargomultitransitionpoint').hide();Ext.getCmp('cargomultitransitionblank').hide();  
			Ext.getCmp('fieldsetblank1').hide();Ext.getCmp('fieldsetblank2').hide();Ext.getCmp('fieldsetblank3').hide();
			Ext.getCmp('deletecargotrip').hide();
			Ext.getCmp('custmastcomboId').reset();Ext.getCmp('cargotripcode').reset();			
			Ext.getCmp('cargoorgin').reset();Ext.getCmp('cargotransitionpoint').reset();Ext.getCmp('cargotripnametxt').reset();
			Ext.getCmp('cargototaltime').reset();Ext.getCmp('cargoaveragespeed').reset();Ext.getCmp('cargoapproxdistance').reset();
			Ext.getCmp('cargodestination').reset();
			Ext.getCmp('cargotripnamelbl').show();Ext.getCmp('cargotripnametxt').show();Ext.getCmp('cargotripnametxtblank').show();
			Ext.getCmp('cargotripcodelbl').show();Ext.getCmp('cargotripcode').show();Ext.getCmp('cargotripcodeblank').show();
			Ext.getCmp('cargoorginlbl').show();Ext.getCmp('cargoorgin').show();Ext.getCmp('cargoorginblank').show();
			Ext.getCmp('addtransitionbutton').show();						
			Ext.getCmp('cargotransitionpointlbl').show();Ext.getCmp('cargotransitionpoint').show();
			Ext.getCmp('cargodestinationlbl').show();Ext.getCmp('cargodestination').show();Ext.getCmp('cargodestinationblank').show();
			Ext.getCmp('cargototaltimelbl').show();Ext.getCmp('cargototaltime').show();Ext.getCmp('cargototaltimeblank').show();
			Ext.getCmp('cargoapproxdistancelbl').show();Ext.getCmp('cargoapproxdistance').show();Ext.getCmp('cargoapproxdistanceblank').show();
			Ext.getCmp('cargoaveragespeed').show();Ext.getCmp('cargoaveragespeedlbl').show();Ext.getCmp('cargoaveragespeedblank').show();
			Ext.getCmp('addButtonId').show();
			Ext.getCmp('addtransitionbutton').show();
			});
			
			Ext.getCmp('pagemodidelete').on("click", function(){
			buttonvalue="delete";
			custmastcombostore.reload();
			Ext.getCmp('custmastcomboId').reset();
			Ext.getCmp('custmastcomboId').show();Ext.getCmp('custnamhidlab').show();			
			Ext.getCmp('cargotripnamecombolbl').show();Ext.getCmp('cargotripnamecombo').show();;Ext.getCmp('cargotripcomboblank').show();
			Ext.getCmp('deletecargotrip').show();
			Ext.getCmp('cargotripnamelbl').hide();Ext.getCmp('cargotripnametxt').hide();Ext.getCmp('cargotripnametxtblank').hide();
			Ext.getCmp('cargotripcodelbl').hide();Ext.getCmp('cargotripcode').hide();Ext.getCmp('cargotripcodeblank').hide();
			Ext.getCmp('cargomultitransitionpoint').removeAll();Ext.getCmp('cargomultitransitionpoint').hide();
			Ext.getCmp('cargoorginlbl').hide();Ext.getCmp('cargoorgin').hide();Ext.getCmp('cargoorginblank').hide();Ext.getCmp('cargomultitransitionblank').hide();
			Ext.getCmp('addtransitionbutton').hide();						
			Ext.getCmp('cargotransitionpointlbl').hide();Ext.getCmp('cargotransitionpoint').hide();
			Ext.getCmp('fieldsetblank1').hide();Ext.getCmp('fieldsetblank2').hide();Ext.getCmp('fieldsetblank3').hide();
			Ext.getCmp('cargodestinationlbl').hide();Ext.getCmp('cargodestination').hide();Ext.getCmp('cargodestinationblank').hide();
			Ext.getCmp('cargototaltimelbl').hide();Ext.getCmp('cargototaltime').hide();Ext.getCmp('cargototaltimeblank').hide();
			Ext.getCmp('cargoapproxdistancelbl').hide();Ext.getCmp('cargoapproxdistance').hide();Ext.getCmp('cargoapproxdistanceblank').hide();
			Ext.getCmp('cargoaveragespeed').hide();Ext.getCmp('cargoaveragespeedlbl').hide();Ext.getCmp('cargoaveragespeedblank').hide();
			Ext.getCmp('addButtonId').hide();	
			Ext.getCmp('cargotripnamecombo').reset();		
			});
			                
	});

   
   </script>
  </body>
</html>