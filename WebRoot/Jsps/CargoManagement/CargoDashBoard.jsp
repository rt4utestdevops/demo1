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
int systemid=loginInfo.getSystemId();
String systemID=Integer.toString(systemid);
int customeridlogged=loginInfo.getCustomerId();
//getting hashmap with language specific words
HashMap langConverted=ApplicationListener.langConverted;
LanguageWordsBean lwb=null;

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

String submit;
lwb=(LanguageWordsBean)langConverted.get("Submit");
if(language.equals("ar")){
	submit=lwb.getArabicWord();
}else{
	submit=lwb.getEnglishWord();
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


String delete;
lwb=(LanguageWordsBean)langConverted.get("Delete");
if(language.equals("ar")){
	delete=lwb.getArabicWord();
}else{
	delete=lwb.getEnglishWord();
}
lwb=null;

String xpressCargoDashBoard;
lwb=(LanguageWordsBean)langConverted.get("Cargo_DashBoard");
if(language.equals("ar")){
	xpressCargoDashBoard=lwb.getArabicWord();
}else{
	xpressCargoDashBoard=lwb.getEnglishWord();
}
lwb=null;

String dashBoard;
lwb=(LanguageWordsBean)langConverted.get("DashBoard");
if(language.equals("ar")){
	dashBoard=lwb.getArabicWord();
}else{
	dashBoard=lwb.getEnglishWord();
}
lwb=null;
String origin;
lwb=(LanguageWordsBean)langConverted.get("Origin");
if(language.equals("ar")){
	origin=lwb.getArabicWord();
}else{
	origin=lwb.getEnglishWord();
}
lwb=null;
String destination;
lwb=(LanguageWordsBean)langConverted.get("Destination");
if(language.equals("ar")){
	destination=lwb.getArabicWord();
}else{
	destination=lwb.getEnglishWord();
}
lwb=null;
String route;
lwb=(LanguageWordsBean)langConverted.get("ROUTE");
if(language.equals("ar")){
	route=lwb.getArabicWord();
}else{
	route=lwb.getEnglishWord();
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
langConverted=null;
%>

<!DOCTYPE HTML>
<html>
 <head>
 
		<title>Xpress Cargo DashBoard</title>		
	</head>	    
  
  <body height="100%">
   <jsp:include page="../Common/ImportJS.jsp" />
   <script>
 var outerPanel;
 var ctsb;
 var panel1;
 var dashboardImage="";	
                /********************resize window event function***********************/
   Ext.EventManager.onWindowResize(function () {
   				var width = '100%';
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
				 			dashBoardPanel.removeAll(true);
     			 						
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
										    ctsb.showBusy('Loading');
											dashBoardPanel.getEl().mask();								    									    									   									    						    	
		                 	   				dashBoardstore.load({
		                 	    			params:{CustId:Ext.getCmp('custmastcomboId').getValue()},
              		          				 callback:function(){
              		          				 ctsb.setStatus({
												 text: getMessageForStatus(""), 
												 iconCls:'',
												 clear: true
						                       	 });
              		          				 dashBoardPanel.getEl().unmask();
              		          				 if(dashBoardstore.getCount()>0)
              		          				 {
              		          				 createDashboards(dashBoardstore.getCount());	
              		          				 }
              		          				 }
              		          				});
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
		                 	   dashBoardPanel.removeAll(true);
     			 						
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
										    ctsb.showBusy('Loading');
											dashBoardPanel.getEl().mask();								    									    									   									    						    	
		                 	   				dashBoardstore.load({
		                 	    			params:{CustId:Ext.getCmp('custmastcomboId').getValue()},
              		          				 callback:function(){
              		          				 ctsb.setStatus({
												 text: getMessageForStatus(""), 
												 iconCls:'',
												 clear: true
						                       	 });
              		          				 dashBoardPanel.getEl().unmask();
              		          				 if(dashBoardstore.getCount()>0)
              		          				 {
              		          				 createDashboards(dashBoardstore.getCount());	
              		          				 }
              		          				 }
              		          				});	                 	   		                 	   							
		                 	   }}
                 	   }   
    });

//************************************ Vehicle Store************************************************
var dashBoardstore=new Ext.data.JsonStore({
				url:'<%=request.getContextPath()%>/CargoManagementAction.do?param=getDashBoardDetails',
				id:'DashBoardDetailsid',
				root: 'DashBoardDetailsRoot',
				autoLoad: false,
				remoteSort: true,
				fields: ['orgin','destination','transitions','vehicleposition','totaldistance','tripname','reversePosition','transitionLocations','vehicledetails']
		});	

   //**********************inner panel start*******************************************   
  var innerPanel = new Ext.Panel({
		standardSubmit: true,
		collapsible:false,
		cls:'innerpanelverysmall',
		height:100,
		id:'custMaster',
		layout:'table',
		layoutConfig: {
			columns:3
		},
		items: [{cls:'labelstyle'},{cls:'labelstyle'},{cls:'labelstyle'},{cls:'labelstyle'},
				{
				xtype: 'label',
				text: '<%=CustomerName%>'+'  :',
				allowBlank: false,
				hidden:false,
				cls:'labelstyle',
				id:'custnamhidlab'
				},
				custnamecombo,
				{cls:'labelstyle'},{cls:'labelstyle'}
       						      							
			]
		}); // End of Panel
		
function createDashboards(noofTrips)
{
for(j=0;j<noofTrips;j++)
{ 
var transitionLocations=new Array();
var id=j+1;
var rec = dashBoardstore.getAt(j);
var transitionNo=rec.data['transitions'];
var orgin=rec.data['orgin'];
var destination=rec.data['destination'];
var vehicleposition=rec.data['vehicleposition'];
var totaldistance=rec.data['totaldistance'];
var tripname=rec.data['tripname'];
var reversePosition=rec.data['reversePosition'];
var vehicledetails=rec.data['vehicledetails'];
 transitionLocations=rec.data['transitionLocations'];
       			 vehicleDashboard(id,transitionNo,vehicleposition,reversePosition,transitionLocations,vehicledetails);
       			 ImageDashboard(id,tripname,orgin,destination);       			  
       			 distanceDashboard(id,totaldistance);
       			 //routeNames(id,orgin,destination);
}
}		
//***************************** Dynamic Pannel for Vehicle****************
function distanceDashboard(idCounter,totaldistance)
{
var distancePannel = new Ext.Panel({
		collapsible:false,
		id:'vehicledistance'+idCounter,
		layout:'column',
		height:30,
		layoutConfig: {
			columns:2
		},
		items: [
		{cls:'labelcolorbg',width:200},
		{
				xtype: 'label',
				text: '|-------------------------------------------------------- '+totaldistance+' Kms ---------------------------------------------------------------|',
				allowBlank: false,
				hidden:false,
				height:30,				
				cls:'labelcolorbg',
				width:600,
				id:'tripname3'+idCounter
				}]		
        }); 
        Ext.getCmp('dashpanelid').add(distancePannel);
        Ext.getCmp('dashpanelid').doLayout(); 
          
}        

function vehicleDashboard(idCounter,transitionNo,vehicleposition,reversePosition,transitionLocations,vehicledetails)
{
dashboardImage="";	
var vehicle='<img style="height: 25px; width:25px;"src="'+'/ApplicationImages/vehicle.png'+'">';

var transitionPoints=transitionNo;
var vehiclePosition=vehicleposition;
switch(transitionPoints)
{
case 1:createImage1(vehiclePosition,reversePosition,transitionLocations,vehicledetails);break;
case 2:createImage2(vehiclePosition,reversePosition,transitionLocations,vehicledetails);break;
case 3:createImage3(vehiclePosition,reversePosition,transitionLocations,vehicledetails);break;
case 4:createImage4(vehiclePosition,reversePosition,transitionLocations,vehicledetails);break;
case 5:createImage5(vehiclePosition,reversePosition,transitionLocations,vehicledetails);break;
case 6:createImage6(vehiclePosition,reversePosition,transitionLocations,vehicledetails);break;
case 7:createImage7(vehiclePosition,reversePosition,transitionLocations,vehicledetails);break;
case 8:createImage8(vehiclePosition,reversePosition,transitionLocations,vehicledetails);break;
case 9:createImage9(vehiclePosition,reversePosition,transitionLocations,vehicledetails);break;
case 10:createImage10(vehiclePosition,reversePosition,transitionLocations,vehicledetails);break;
}
var vehiclePannel = new Ext.Panel({
		standardSubmit: true,
		collapsible:false,
		cls:'innerpanelimage',
		id:'vehicleimage'+idCounter,
		height:30,
		layout:'table',
		layoutConfig: {
			columns:4
		},
		items: [
		{cls:'labelstyle',width:140},
		{cls:'labelstyle',width:50},		
		{
			xtype: 'panel',
            name :'image',
            width:550,
            html :dashboardImage
                       
         
        },{cls:'labelstyle'}]
        });	       
		Ext.getCmp('dashpanelid').add(vehiclePannel);
        Ext.getCmp('dashpanelid').doLayout(); 
            
}        		
//**************************** Image Pannel********************************	
function ImageDashboard(idCounter,tripname,orgin,destination)
{

var imagePanel = new Ext.Panel({
		standardSubmit: true,
		collapsible:false,
		cls:'innerpanelimage',
		height:20,
		id:'image'+idCounter,
		layout:'column',
		layoutConfig: {
			columns:4
		},
		items: [
		{
				xtype: 'label',
				text: '<%=route%>'+':'+tripname,
				//autoWidth:false,
				allowBlank: false,
				hidden:false,
				cls:'labelcolorbg',
				width:140,
				id:'tripname'+idCounter
				},
		{
				xtype: 'label',
				text: '<%=origin%>',
				allowBlank: false,
				hidden:false,
				cls:'labelcolorbg',
				width:50,
				id:'triporgin'+idCounter,
				listeners: {
    					render: function(c) {
      					Ext.QuickTips.register({
        				target: c,
        				text: ''+orgin
      					});
    		}
  }
				},
		{
			xtype: 'panel',
            name :'image',
            html : '<img style="height: 50px; width:550px;"src="'+'/ApplicationImages/TRIPBAR.png'+'">'          
        
        },{
				xtype: 'label',
				text: '<%=destination%>',
				allowBlank: false,
				hidden:false,
				cls:'labelcolorbg',
				width:65,
				id:'tripdestination'+idCounter,
				listeners: {
   			 	render: function(c) {
      			Ext.QuickTips.register({
        		target: c,
        		text: ''+destination
      });
    }
  }
				}]
        }); 
		Ext.getCmp('dashpanelid').add(imagePanel);
        Ext.getCmp('dashpanelid').doLayout();
        
       
}  
//*******************************************Function for creating route Names********************
// Not in use at Present
function routeNames(idCounter,orgin,destination)
{
        
        var routePannel = new Ext.Panel({
		collapsible:false,
		id:'vehicleroute'+idCounter,
		layout:'table',
		height:60,
		layoutConfig: {
			columns:3
		},
		items: [
		{cls:'labelstyledashboard'},
		{
				xtype: 'label',
				text: '',
				allowBlank: false,
				hidden:false,
				height:30,
				cls:'labelcolorbg',
				id:'tripnamesd3'+idCounter
				},				
		{cls:'labelstyle'},
		{cls:'labelstyledashboard'},
		{
				xtype: 'label',
				text: '',
				allowBlank: false,
				hidden:false,
				height:30,
				cls:'labelcolorbg',
				id:'tripnamesad3'+idCounter
				},		
	    {cls:'labelstyle'},]		
        }); 
        Ext.getCmp('dashpanelid').add(routePannel);
        Ext.getCmp('dashpanelid').doLayout(); 
}                
//********************************************************* Function for creating Images *******************************************************************
function createImage1(vehiclePosition,reversePosition,transitionLocations,vehicledetails)
{
html1='<img valign="top"title="'+transitionLocations[0]+'"style="height: 20px; width:10px;margin-left: 250px;position: relative;"src="'+'/ApplicationImages/btnSubmit.png'+'">';
if(vehiclePosition > 220 &&  vehiclePosition < 260 ){
vehiclePosition=220;
}
if(reversePosition==0){
var vehicle='<img title="'+vehicledetails+'"style="2height: 25px; width:25px;;margin-left:'+vehiclePosition+'px;position: absolute;"src="'+'/ApplicationImages/vehicle.png'+'">';
}
else{
var vehicle='<img title="'+vehicledetails+'"style="height: 25px; width:25px;;margin-left:'+vehiclePosition+'px;position: absolute;"src="'+'/ApplicationImages/reversevehicle.png'+'">';
}
dashboardImage=vehicle+html1;
}

function createImage2(vehiclePosition,reversePosition,transitionLocations,vehicledetails)
{
if(vehiclePosition > 120 &&  vehiclePosition < 160 ){
vehiclePosition=150;
}
else if(vehiclePosition > 280 &&  vehiclePosition < 320 ){
vehiclePosition=280;
}
if(reversePosition==0){
var vehicle='<img title="'+vehicledetails+'"style="2height: 25px; width:25px;;margin-left:'+vehiclePosition+'px;position: absolute;"src="'+'/ApplicationImages/vehicle.png'+'">';
}
else{
var vehicle='<img title="'+vehicledetails+'"style="height: 25px; width:25px;;margin-left:'+vehiclePosition+'px;position: absolute;"src="'+'/ApplicationImages/reversevehicle.png'+'">';
}
dashboardImage=vehicle;
for(i=0;i<2;i++)
{
html2='<img title="'+transitionLocations[i]+'"style="height: 20px; width:10px;margin-left: 150px;position: relative;"src="'+'/ApplicationImages/btnSubmit.png'+'">';
dashboardImage=dashboardImage+html2;
}
}

function createImage3(vehiclePosition,reversePosition,transitionLocations,vehicledetails)
{
if(vehiclePosition > 90 &&  vehiclePosition < 130 ){
vehiclePosition=90;
}
else if(vehiclePosition > 230 &&  vehiclePosition < 270 ){
vehiclePosition=230;
}
else if(vehiclePosition > 355 &&  vehiclePosition < 395 ){
vehiclePosition=355;
}
if(reversePosition==0){
var vehicle='<img title="'+vehicledetails+'"style="2height: 25px; width:25px;;margin-left:'+vehiclePosition+'px;position: absolute;"src="'+'/ApplicationImages/vehicle.png'+'">';
}
else{
var vehicle='<img title="'+vehicledetails+'"style="height: 25px; width:25px;;margin-left:'+vehiclePosition+'px;position: absolute;"src="'+'/ApplicationImages/reversevehicle.png'+'">';
}
dashboardImage=vehicle;
for(i=0;i<3;i++)
{
html3='<img title="'+transitionLocations[i]+'"style="height: 20px; width:10px;margin-left: 120px;position: relative;"src="'+'/ApplicationImages/btnSubmit.png'+'">';
dashboardImage=dashboardImage+html3;
}
}

function createImage4(vehiclePosition,reversePosition,transitionLocations,vehicledetails)
{
if(reversePosition==0){
var vehicle='<img title="'+vehicledetails+'"style="2height: 25px; width:25px;;margin-left:'+vehiclePosition+'px;position: absolute;"src="'+'/ApplicationImages/vehicle.png'+'">';
}
else{
var vehicle='<img title="'+vehicledetails+'"style="height: 25px; width:25px;;margin-left:'+vehiclePosition+'px;position: absolute;"src="'+'/ApplicationImages/reversevehicle.png'+'">';
}
dashboardImage=vehicle;
for(i=0;i<4;i++)
{
html4='<img title="'+transitionLocations[i]+'"style="height: 20px; width:10px;margin-left: 100px;position: relative;"src="'+'/ApplicationImages/btnSubmit.png'+'">';
dashboardImage=dashboardImage+html4;
}
}

function createImage5(vehiclePosition,reversePosition,transitionLocations,vehicledetails)
{
if(reversePosition==0){
var vehicle='<img title="'+vehicledetails+'"style="2height: 25px; width:25px;;margin-left:'+vehiclePosition+'px;position: absolute;"src="'+'/ApplicationImages/vehicle.png'+'">';
}
else{
var vehicle='<img title="'+vehicledetails+'"style="height: 25px; width:25px;;margin-left:'+vehiclePosition+'px;position: absolute;"src="'+'/ApplicationImages/reversevehicle.png'+'">';
}
dashboardImage=vehicle;
for(i=0;i<5;i++)
{
html5='<img title="'+transitionLocations[i]+'"style="height: 20px; width:10px;margin-left: 90px;position: relative;"src="'+'/ApplicationImages/btnSubmit.png'+'">';
dashboardImage=dashboardImage+html5;
}
}

function createImage6(vehiclePosition,reversePosition,transitionLocations,vehicledetails)
{
if(reversePosition==0){
var vehicle='<img title="'+vehicledetails+'"style="2height: 25px; width:25px;;margin-left:'+vehiclePosition+'px;position: absolute;"src="'+'/ApplicationImages/vehicle.png'+'">';
}
else{
var vehicle='<img title="'+vehicledetails+'"style="height: 25px; width:25px;;margin-left:'+vehiclePosition+'px;position: absolute;"src="'+'/ApplicationImages/reversevehicle.png'+'">';
}
dashboardImage=vehicle;
for(i=0;i<6;i++)
{
html6='<img title="'+transitionLocations[i]+'"style="height: 20px; width:10px;margin-left: 70px;position: relative;"src="'+'/ApplicationImages/btnSubmit.png'+'">';
dashboardImage=dashboardImage+html6;
}
}

function createImage7(vehiclePosition,reversePosition,transitionLocations,vehicledetails)
{
if(reversePosition==0){
var vehicle='<img title="'+vehicledetails+'"style="2height: 25px; width:25px;;margin-left:'+vehiclePosition+'px;position: absolute;"src="'+'/ApplicationImages/vehicle.png'+'">';
}
else{
var vehicle='<img title="'+vehicledetails+'"style="height: 25px; width:25px;;margin-left:'+vehiclePosition+'px;position: absolute;"src="'+'/ApplicationImages/reversevehicle.png'+'">';
}
dashboardImage=vehicle;
for(i=0;i<7;i++)
{
html7='<img title="'+transitionLocations[i]+'"style="height: 20px; width:10px;margin-left: 60px;position: relative;"src="'+'/ApplicationImages/btnSubmit.png'+'">';
dashboardImage=dashboardImage+html7;
}
}

function createImage8(vehiclePosition,reversePosition,transitionLocations,vehicledetails)
{
if(reversePosition==0){
var vehicle='<img title="'+vehicledetails+'"style="2height: 25px; width:25px;;margin-left:'+vehiclePosition+'px;position: absolute;"src="'+'/ApplicationImages/vehicle.png'+'">';
}
else{
var vehicle='<img title="'+vehicledetails+'"style="height: 25px; width:25px;;margin-left:'+vehiclePosition+'px;position: absolute;"src="'+'/ApplicationImages/reversevehicle.png'+'">';
}
dashboardImage=vehicle;
for(i=0;i<8;i++)
{
html8='<img title="'+transitionLocations[i]+'"style="height: 20px; width:10px;margin-left: 50px;position: relative;"src="'+'/ApplicationImages/btnSubmit.png'+'">';
dashboardImage=dashboardImage+html8;
}
}
function createImage9(vehiclePosition,reversePosition,transitionLocations,vehicledetails)
{
if(reversePosition==0){
var vehicle='<img title="'+vehicledetails+'"style="2height: 25px; width:25px;;margin-left:'+vehiclePosition+'px;position: absolute;"src="'+'/ApplicationImages/vehicle.png'+'">';
}
else{
var vehicle='<img title="'+vehicledetails+'"style="height: 25px; width:25px;;margin-left:'+vehiclePosition+'px;position: absolute;"src="'+'/ApplicationImages/reversevehicle.png'+'">';
}
dashboardImage=vehicle;
for(i=0;i<9;i++)
{
html9='<img title="'+transitionLocations[i]+'"style="height: 20px; width:10px;margin-left: 40px;position: relative;"src="'+'/ApplicationImages/btnSubmit.png'+'">';
dashboardImage=dashboardImage+html9;
}
}

function createImage10(vehiclePosition,reversePosition,transitionLocations,vehicledetails)
{
if(reversePosition==0){
var vehicle='<img title="'+vehicledetails+'"style="2height: 25px; width:25px;;margin-left:'+vehiclePosition+'px;position: absolute;"src="'+'/ApplicationImages/vehicle.png'+'">';
}
else{
var vehicle='<img title="'+vehicledetails+'"style="height: 25px; width:25px;;margin-left:'+vehiclePosition+'px;position: absolute;"src="'+'/ApplicationImages/reversevehicle.png'+'">';
}
dashboardImage=vehicle;
for(i=0;i<10;i++)
{
html10='<img title="'+transitionLocations[i]+'"style="height: 20px; width:10px;margin-left: 40px;position: relative;"src="'+'/ApplicationImages/btnSubmit.png'+'">';
dashboardImage=dashboardImage+html10;
}
}
//***************************  Main starts from here **************************************************
var dashBoardPanel = new Ext.Panel({
			title:'<%=dashBoard%>',
			renderTo : 'content',
			id:'dashpanelid',
			standardSubmit: true,
			frame:true,
			cls:'innerpanelimagepercentage',
			autoScroll:true,
			height:800,
			items: [],
			bbar:ctsb			
			});	

 Ext.onReady(function(){
	ctsb=tsb;
	Ext.QuickTips.init();
	Ext.Ajax.timeout = 360000;
	Ext.form.Field.prototype.msgTarget = 'side';			         	   			
 	outerPanel = new Ext.Panel({
			title:'<%=xpressCargoDashBoard%>',
			renderTo : 'content',
			id:'outerpanelid',
			standardSubmit: true,
			frame:true,
			cls:'mainpanellargepercentage',
			height:900,
			autoScroll:true,
			items: [innerPanel,dashBoardPanel],
			bbar:ctsb			
			});	 
			                
	});
	 
			                
   
   </script>
  </body>
</html>