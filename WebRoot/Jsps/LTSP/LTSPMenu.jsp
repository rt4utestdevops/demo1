<%@page language="java" import="java.util.*,java.text.*,t4u.functions.LTSPFunctions,t4u.functions.CommonFunctions,t4u.functions.AdminFunctions,t4u.beans.*,t4u.common.*" pageEncoding="utf-8"%>
<%@ taglib uri="http://packtag.sf.net" prefix="pack" %>
<%
	String basePath = request.getScheme() + "://"+ request.getServerName() + ":" + request.getServerPort()+"/";
	String LTSPName="";	
	CommonFunctions cf=new CommonFunctions();
	AdminFunctions af=new AdminFunctions();
	cf.checkLoginInfo((LoginInfoBean)session.getAttribute("loginInfoDetails"),session,request,response);
	LoginInfoBean loginInfo=(LoginInfoBean)session.getAttribute("loginInfoDetails");
	loginInfo.setCustomerId(0);
	HttpSession sessionPassMsg=request.getSession();
	int systemId = loginInfo.getSystemId();
	String language=loginInfo.getLanguage();
	int customerId = loginInfo.getCustomerId();
	int userId = loginInfo.getUserId();
	int offset = loginInfo.getOffsetMinutes();
	LTSPFunctions ltspfunc=new LTSPFunctions();
	String adminMenuList=ltspfunc.getAdministratorMenu(systemId,userId,language);
	LTSPName=(String)session.getAttribute("ltspName");
	String userName=(String)session.getAttribute("userName");		
	String home=cf.getLabelFromDB("Home",language).toUpperCase();
	String newVertical=cf.getLabelFromDB("New",language).toUpperCase();
	String administration=cf.getLabelFromDB("Administration",language).toUpperCase();
	String logout=cf.getLabelFromDB("Logout",language);
	String wlecome=cf.getLabelFromDB("Welcome",language);
	String loading=cf.getLabelFromDB("Loading",language);
	
	String dashboard="DASHBOARD";	
	boolean isPaymentDue=cf.isPaymentDue(systemId,customerId);

ArrayList<String> tobeConverted=new ArrayList<String>();
tobeConverted.add("Phone_No");
tobeConverted.add("Error");
tobeConverted.add("Contact_Details");
tobeConverted.add("Fax");
tobeConverted.add("Enter_Fax_No");
tobeConverted.add("Enter_Email_Id");
tobeConverted.add("Enter_Phone_No");
tobeConverted.add("Enter_Mobile_No"); 
tobeConverted.add("Mobile_No");
tobeConverted.add("USER_ID");
tobeConverted.add("USERNAME");
tobeConverted.add("PASSWORD");
tobeConverted.add("First_Name"); 
tobeConverted.add("Last_Name");
tobeConverted.add("Middle_Name");
tobeConverted.add("User");
tobeConverted.add("Select_User");
tobeConverted.add("Save");
tobeConverted.add("Cancel");
tobeConverted.add("User_Name"); 
tobeConverted.add("Enter_User_Name");
tobeConverted.add("Enter_Password");
tobeConverted.add("Enter_First_Name");
tobeConverted.add("Middle_Name");
tobeConverted.add("Enter_Middle_Name");
tobeConverted.add("Last_Name");
tobeConverted.add("Enter_Last_Name");
tobeConverted.add("Phone_No");
tobeConverted.add("Enter_Phone_No");
tobeConverted.add("Email");
tobeConverted.add("Enter_Email");
tobeConverted.add("Confirm_Password");
tobeConverted.add("New_User_Name");
tobeConverted.add("Enter_New_User_Name");
tobeConverted.add("User_Registration");
tobeConverted.add("password_match");
tobeConverted.add("Password_Message"); 
tobeConverted.add("Validate_Mesg_For_Form");
tobeConverted.add("User_Profile");
tobeConverted.add("Update_Profile");
tobeConverted.add("Download_Mobile_App");
tobeConverted.add("Map_Type");
tobeConverted.add("Select_Map_Type");
ArrayList<String> convertedWords=new ArrayList<String>();
convertedWords=cf.getLanguageSpecificWordForKey(tobeConverted,language);
String phoneNo=convertedWords.get(0);
String error=convertedWords.get(1);
String ContactDetails=convertedWords.get(2);
String fax=convertedWords.get(3);
String enterFaxNo=convertedWords.get(4);
String EnterEmailId=convertedWords.get(5);
String enterPhoneNo=convertedWords.get(6);
String enterMobileNo=convertedWords.get(7);
String mobile=convertedWords.get(8);
String USERID=convertedWords.get(9);
String USERNAME=convertedWords.get(10);
String password=convertedWords.get(11);
String firstName=convertedWords.get(12);
String lastname=convertedWords.get(13);
String middlename=convertedWords.get(14);
String user=convertedWords.get(15);
String selUser=convertedWords.get(16);
String Save=convertedWords.get(17);
String Cancel=convertedWords.get(18);
String userName1=convertedWords.get(19);
String enterUserName=convertedWords.get(20);
String enterPass=convertedWords.get(21);
String enterfName=convertedWords.get(22);
String middName=convertedWords.get(23);
String entYourMiddName=convertedWords.get(24);
String lastName=convertedWords.get(25);
String entUrLastName=convertedWords.get(26);
String phone=convertedWords.get(27);
String entPhone=convertedWords.get(28);
String email=convertedWords.get(29);
String enterEmail=convertedWords.get(30);
String confpassword=convertedWords.get(31);
String newUserName=convertedWords.get(32);
String enterNewUserName=convertedWords.get(33);
String User_Registration=convertedWords.get(34);
String password_match=convertedWords.get(35);
String passregex=convertedWords.get(36);
String check_mandatory=convertedWords.get(37);
String User_Profile=convertedWords.get(38);
String Update_Profile=convertedWords.get(39);
String Download_Mobile_App=convertedWords.get(40);
String mapType=convertedWords.get(41);
String selectMapType=convertedWords.get(42);
	int dayDiff = 0;
	int dayDiffToDisplay = 0;
	boolean allow = true;
	String str = "223,259,134,194,183,165,184,182,199,178,150,216,153,300,296,204,185,332,323,337,327";
	String[] sandSystemId = str.split(",");
	for (String s : sandSystemId) {
		if (String.valueOf(systemId).equals(s)) {
			allow = false;
			break;
		}
	}
	if (allow) {
		dayDiff = af.getPasswordModifiedDate(offset, userId, systemId);
		if (dayDiff >= 40 && dayDiff <= 45) {
			dayDiffToDisplay = 45 - dayDiff;
		}
	}
boolean sessionPass=false;
if(sessionPassMsg.getAttribute("PassExpMsg")!=null)
{
	sessionPass= (Boolean)sessionPassMsg.getAttribute("PassExpMsg");
}

%>
<!DOCTYPE html>
<html lang="en" class="no-js">
	<head>
		<meta charset="UTF-8" />
		<pack:script src="../../Main/adapter/ext/ext-base.js"></pack:script>
		<pack:script src="../../Main/Js/ext-all-debug.js"></pack:script>
		<pack:script src="../../Main/Js/T4UStatusBar.js"></pack:script>
		<pack:script src="../../Main/Js/MsgBox.js"></pack:script>
		<pack:script src="../../Main/Js/Common.js"></pack:script>
		<pack:script src="../../Main/Js/cancelbackspace.js"></pack:script>
		<pack:script src="../../Main/resources/ux/statusbar/StatusBar.js"></pack:script>
		<pack:script src="../../Main/resources/ux/statusbar/ValidationStatus.js"></pack:script>
		<pack:script src="../../Main/resources/ux/fileuploadfield/FileUploadField.js"></pack:script>
		<!-- for grid -->
		<pack:script src="../../Main/resources/ux/gridfilters/menu/RangeMenu.js"></pack:script>
		<pack:script src="../../Main/resources/ux/gridfilters/menu/ListMenu.js"></pack:script>
		<pack:script src="../../Main/resources/ux/gridfilters/GridFilters.js"></pack:script>
		<pack:script src="../../Main/resources/ux/gridfilters/filter/Filter.js"></pack:script>
		<pack:script src="../../Main/resources/ux/gridfilters/filter/StringFilter.js"></pack:script>
		<pack:script src="../../Main/resources/ux/gridfilters/filter/DateFilter.js"></pack:script>
		<pack:script src="../../Main/resources/ux/gridfilters/filter/ListFilter.js"></pack:script>
		<pack:script src="../../Main/resources/ux/gridfilters/filter/NumericFilter.js"></pack:script>
		<pack:script src="../../Main/resources/ux/gridfilters/filter/BooleanFilter.js"></pack:script>
		<pack:style src="../../Main/resources/css/ext-all.css" />
		<pack:style src="../../Main/resources/css/chooser.css" />
		<pack:style src="../../Main/resources/css/xtheme-DeepBlue.css" />
		<pack:style src="../../Main/iconCls/icons.css" />
		<pack:style src="../../Main/resources/ux/statusbar/css/statusbar.css" />
		<!-- for grid -->
		<pack:style src="../../Main/resources/ux/gridfilters/css/GridFilters.css" />
		<pack:style src="../../Main/resources/ux/gridfilters/css/RangeMenu.css" />
		<pack:script src="../../Main/Js/examples1.js"></pack:script>
		<pack:style src="../../Main/resources/css/examples1.css" />
		<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1"> 
		<meta name="viewport" content="width=device-width, initial-scale=1.0"> 
		<title>LTSP Menu</title>
		<link rel="stylesheet" type="text/css" href="../../Main/modules/LTSP/css/menu.css" />
		<link rel="stylesheet" type="text/css" href="../../Main/modules/LTSP/css/component.css" />
		<link rel="stylesheet" type="text/css" href="../../Main/modules/cashVan/theme/css/EXTJSExtn.css" /> 

		<script src="../../Main/Js/modernizr.custom.js"></script>
		<script src="../../Main/modules/common/homeScreen/js/digitalTimer.js"></script>		 
		<link rel="stylesheet" href="//code.jquery.com/ui/1.11.4/themes/smoothness/jquery-ui.css"> 
		<script src="../../Main/Js/jquery.js"></script>
        <script src="../../Main/Js/jquery-ui.js"></script>
		<link rel="stylesheet" href="/resources/demos/style.css">
		<style>
		#jspPageId{
			width: 100%;
			height: 656px !important;
			padding-top:95px;
		}
		@media screen and (device-width:1920px) {
			#jspPageId{
				width: 100%;
				height:971px;
				padding-top:95px
			}
		}
		@media (device-width: 1280px) and (device-height: 720px) {
			#jspPageId {
			    width: 100%;
			    height: 600px !important;
			    padding-top: 95px;
			}
		}
		@media screen and (device-width: 1600px) {
			#jspPageId {
			    width: 100%;
			    height: 775px !important;
			    padding-top: 95px;
			}
		}
		@media screen and (device-width:1440px) {
			#jspPageId{
				width:100%;
				height: 775px !important;
				padding-top: 95px;
			}
		}
		@media (device-width: 1280px) and (device-height: 800px) {
			#jspPageId {
				width: 100%;
				height: 680px !important;
				padding-top: 95px;
			}
		}
		@media (device-width: 1280px) and (device-height: 960px) {
			#jspPageId {
				width: 100%;
				height: 850px !important;
				padding-top: 95px;
			}
		}
		@media (device-width: 1280px) and (device-height: 1024px) {
			#jspPageId {
				width: 100%;
				height: 900px !important;
				padding-top: 95px;
			}
		}
<!--		.gn-menu-main,.gn-menu-main ul {-->
<!--			padding: 0;-->
<!--			background: white !important;-->
<!--			list-style: none;-->
<!--			text-transform: none;-->
<!--			font-weight: 300;-->
<!--			font-family:'Open Sans', sans-serif;-->
<!--			line-height: 44px;-->
<!--		}-->
<!--		#head {-->
<!--			height: 52px;-->
<!--			background: #00a7cd !important;-->
<!--			font-family:'Open Sans', sans-serif;-->
<!--			position: fixed;-->
<!--			width: 100%;-->
<!--		}-->
<!--		.gn-menu-main a {-->
<!--	display: block;-->
<!--	height: 100%;-->
<!--	color: black;-->
<!--	text-decoration: none;-->
<!--	cursor: pointer;-->
<!--	font-weight: bold;-->
<!--	font-size: 12px;-->
<!--}-->
<!--.verticalList{-->
<!--			background-color:white;-->
<!--		}-->
<!--		#verticalSubMenu{-->
<!--			background-color: white;-->
<!--		}-->
		</style> 
	</head>
	<body onload="getDigitalTimer('<%=cf.getCurrentDateTime(loginInfo.getOffsetMinutes())%>');  " oncontextmenu="return false;">
		<div class="container">
			<div id="head">		
				<div class="comapnyLogo">			
					<a id="companyHeader">
						<img id="companyImage" src ="/ApplicationImages/CustomerLogos/custlogo_<%=loginInfo.getSystemId()%>.gif" alt>&nbsp;<%=LTSPName%> </a>
					</div>
					<div class="downloadapp"><a id="openwindow" class="anchor" href="#"><%=Download_Mobile_App%></a></div>
					<div id="dialog" style="display:none">
	    				<form>
		        			<table>
				           		 <tr>
				              		<td><div><p class="Emvision">EM-Vision is a real time Vehicle Monitoring App intended to help users to easily view the location of the vehicles, view on map, activity, etc.</p></div></td>
				              	</tr>
								<tr>
									<td><div><a href="https://play.google.com/store/apps/details?id=com.t4u&hl=en" target="_blank"><img id="androidApp" class ="image1" src="/ApplicationImages/HomeScreen/androidApp.png"/></a></div></td>
									<td><div><a href="https://itunes.apple.com/us/app/em-vision/id834264549?mt=8" target="_blank"><img id="mobileImg1" class="mac" src="/ApplicationImages/HomeScreen/mac.png"/></a></div></td>
									<td><div><a href="http://www.windowsphone.com/en-in/store/app/em-vision/12a63dda-8bac-40ca-bd4c-bdc536082513" target="_blank"><img id="mobileImg2" class="windows" src="/ApplicationImages/HomeScreen/windows.png"/></a></div></td>
									<td><div><img id="mobileImg" class="image" src="/ApplicationImages/HomeScreen/mobile2.png"/></div></td>
								</tr>
				           </table>
	    			</form>
				</div>
				<div id = "dateTimeId" class="rightLastComponentDate">
					<ul>
						<li id="Date"> </li>
						<li id="hours"> </li>
	    				<li id="point">:</li>
	    				<li id="min"> </li>
	    				<li id="point">:</li>
	    				<li id="sec"> </li>
					</ul>
				</div>	
				<a id = "copyrightYear" class="rightLastComponentPoweredBy"></a>				
			</div>
			<div>
			<ul id="gn-menu" class="gn-menu-main">
				<li id ='Home' onclick="getjspPage('<%=request.getContextPath()%>/Jsps/LTSP/VerticalHomeScreen.jsp');"><a id = 'home_id'><%=home%></a></li>
				<li id ='New' onclick="getjspPage('<%=request.getContextPath()%>/Jsps/LTSP/NewVertical.jsp');"><a id = 'new_id'><%= newVertical %></a></li>
				<li id ='Administration' onclick="getAdminMenu('admin_vertical_menu');"><a id = 'admin_id'><%= administration %></a></li>
				<%if(systemId==229 || systemId==12){ %>
				<li id ='dashboard' onclick="getjspPage('<%=request.getContextPath()%>/Jsps/SandMining/SandMiningDashboard.jsp');"><a id = 'dashboard-id'><%= dashboard %></a></li>
				<%} %>
				<!-- Profile Menu -->
				<li onclick="toggleSubMenuFunction('profileId')"><a><span class = "userProfile"><img src ="/ApplicationImages/HomeScreen/user_icon.png" alt></span></a>
					<div id = "profileId" hidden= "true">
					<div class="update-profile">						
						<a id="login-user" class="userName"><%=wlecome%> <%=userName %>
						</a>
						<a onclick="myWindow()" id="update_profile" ><%= Update_Profile%></a>
<!--						<a onclick="toggleUserManualAction()" style="font-size: 14px; " >User Manual</a>							-->
						</div>
						<ul class="dropdown-menu pull-right">
							<li id="logoutId" onclick = "logOut()"><a><%=logout %></a></li>
						</ul>
					</div>
				</li>
			</ul>
			<ul class="vertical_menu" id="admin_vertical_menu"><%=adminMenuList %></ul>
			</div>
			<!-- /IFrame To Display JSP -->	
			<div id="iframescrollbar">
				<iframe id = "jspPageId" frameborder="0"></iframe>
			    <div id="loadingMessage"><%=loading %>...</div>
			</div>
			<div id="myDialog" style="display:none;background-color: black !important;color: white;">
			<div id="myDialogText" style="font-family:'Open Sans', sans-serif;font-size: 2.35em;text-align: center;padding-top: 20%;"></div>
		    </div>
		</div> <!-- /container -->		
	<script>		
		//Code to load default image.
var changepassword = false;		
 var password1 = '';
 var password2 = '';
 var password3 = '';
 var password4 = '';
 var username = '';
 var firstname = '';
 var lastname = '';
		var passwordStore= new Ext.data.JsonStore({
				   url:'<%=request.getContextPath()%>/UserManagementAction.do?param=getPasswords',
				   id:'passwordStoreId',
			       root: 'passwordStoreRoot',
			       autoLoad: false,
			       remoteSort:true,
				   fields: ['Password1','Password2','Password3','Password4','UserName','FirstName','LastName']
				   });
		passwordStore.load({
	       					params:{
	       					 SystemId : '<%=systemId%>'  ,
                             CustomerId : '<%=customerId%>',
                             UserId : '<%=userId%>'
	       					},
	       					callback: function(){
	       					var rec= passwordStore.getAt(0);
password1 = rec.data['Password1'];
password2 = rec.data['Password2'];
password3 = rec.data['Password3'];
password4 = rec.data['Password4'];
username = rec.data['UserName'];
firstname = rec.data['FirstName'];
lastname = rec.data['LastName'];

	       					}
	       					});				   
		
		$.ajax({
		    url: '<%=basePath%>' + 'ApplicationImages/CustomerLogos/custlogo_<%=loginInfo.getSystemId()%>.gif',
		    type: "HEAD",
		    error: function() {
		        $('#companyImage').attr('src', '/ApplicationImages/CustomerLogos/defaultImage.gif');
		    },
		    success: function() {
		    }
		});
		$("#openwindow").click(function () {
 			$("#dialog").dialog({
	            autoOpen: true,
	            modal: true,
	            height:400,
	            width:600,
	            show: {},
	            hide: {}
	        });
		});
		
		$('#jspPageId').attr('src','<%=request.getContextPath()%>/Jsps/LTSP/VerticalHomeScreen.jsp');
		function getjspPage(jspLink){
			$('#loadingMessage').css('display', 'block');
			$('#jspPageId').attr('src',jspLink);
		}			
		function logOut() {			
			window.location="<%=request.getContextPath()%>/LogOut.do?username=<%=loginInfo.getUserName()%>";
		}
		
		function getAdminMenu(id) {
		    var e = document.getElementById(id);
		    if (e.style.display == 'none')
		        e.style.display = 'block';
		    else
		        e.style.display = 'none';
		    var hideTimer = null;
		
		    hideTimer = setTimeout(function() {
		        if (e.style.display == 'block')
		            e.style.display = 'none';
		    }, 4000);
		
		    $("#admin_vertical_menu").bind({
		        mouseenter: function() {
		            if (hideTimer !== null) {
		                clearTimeout(hideTimer);
		            }
		        },
		        mouseleave: function() {
		            e.style.display = 'none';
		        }
		    });
		
		}	
		document.getElementById('admin_vertical_menu').style.display = 'none';
		function getJSPPage(link){
			$('#loadingMessage').css('display', 'block');
			$('#jspPageId').attr('src',link);
			getAdminMenu('admin_vertical_menu');
		}
		
		function toggleSubMenuFunction(id){		
			var e = document.getElementById(id);			
			if(e.style.display == 'block') {
				e.style.display = 'none';						
			} else {
				e.style.display = 'block';				
					}
						
			}
			function toggleUserManualAction(){	
			 window.open("<%=request.getContextPath()%>/UserManualDownload");	
			}
			 //simple store of google map type
 		var mapTypeStore= new Ext.data.SimpleStore({
			id:'maptypestoreid',
			autoLoad: true,
			fields: ['Name','Value'],
			data: [['Google Satellite','1'],['Google Street','0']]
		});
 //******combobox for google map type
 		var maptypecombo=new Ext.form.ComboBox({
	        store: mapTypeStore,
	        id:'maptypecomboid',
	        mode: 'local',
	        forceSelection: true,
	        emptyText:'<%=selectMapType%>',
	        blankText:'<%=selectMapType%>',
	        selectOnFocus:true,
	        allowBlank: false,
	        anyMatch:true,
            typeAhead: false,
	        triggerAction: 'all',
	        lazyRender: true,
	    	valueField: 'Value',
	    	displayField: 'Name',
	    	cls:'selectstyle',
	    	hidden:true   
    	});
			
		var myWin;
		var innerPanel = new Ext.form.FormPanel({
		standardSubmit: true,
		collapsible:false,
		autoScroll:true,
		height:340,
		width:'100%',
		frame:true,
		id:'usermanagement',
		layout:'table',
		layoutConfig: {
			columns:1
		},
		items: [
		         {
		        xtype:'fieldset', 
				title:'<%=User_Registration%>',
				cls:'fieldsetpanel',
				collapsible: false,
				colspan:1,
				id:'userpanelid',
				layout:'table',
				layoutConfig: {
					columns:3
				},
				items: [
	    		{
            	xtype:'label',
            	text:'*',
            	hidden:true,
            	cls:'mandatoryfield',
            	id:'mandatorynewusername'
            	},{
				xtype: 'label',
				text: '<%=newUserName%> '+'  :',
				allowBlank: true,
				cls:'labelstyle',
				hidden:true,
				id:'newuserlabelid'
				},
				{
				xtype:'textfield',
				cls:'textrnumberstyle',
	    		emptyText:'<%=enterNewUserName%>',
	    		allowBlank: true,
	    		hidden:true,
	    		blankText :'<%=enterNewUserName%>',
	    		id:'newuserfieldid'
	    		
	    		},
	    		{
            	xtype:'label',
            	text:'*',
            	cls:'mandatoryfield',
            	id:'mandatorypassword'
            	},
	    		{
				xtype: 'label',
				cls:'labelstyle',
				id:'userpwdlabid',
				text: '<%=password%> '+'  :'
				},
				{
				xtype:'textfield',
	    		cls:'textrnumberstyle',
	    		inputType:'password',
	    		emptyText:'Enter Password',
	    		blankText:'<%=enterPass%>',
	    		allowBlank: false,
	    		regexText: '<%=passregex%>',
	    		id:'userpwdtfid',
	    		listeners:{
					change: function(){
					changepassword = true;
					}
					}
	    		},
	    		{
            	xtype:'label',
            	text:'*',
            	cls:'mandatoryfield',
            	id:'mandatoryconfpass'
            	},
	    		{
				xtype: 'label',
				cls:'labelstyle',
				id:'userconfpwdlabid',
				text: '<%=confpassword%> '+'  :'
				},
				{
				xtype:'textfield',
	    		cls:'textrnumberstyle',
	    		inputType:'password',
	    		emptyText:'Enter Password',
	    		blankText:'<%=enterPass%>',
	    		allowBlank: false,
	    		regexText: '<%=passregex%>',
	    		id:'userconfpwdtfid'
	    		},
	    		{
            	xtype:'label',
            	text:'*',
            	cls:'mandatoryfield',
            	id:'mandatoryfname'
            	},
	    		{
				xtype: 'label',
				text: '<%=firstName%> '+'  :',
				cls:'labelstyle',
				id:'userfnamelabid'
				},
				{
				xtype:'textfield',
	    		cls:'textrnumberstyle',
	    		emptyText:'<%=enterfName%>',
	    		blankText :'<%=enterfName%>',
	    		maskRe: /([a-zA-Z0-9\s]+)$/,
	    		allowBlank: false,
	    		id:'unametfid',
	    		listeners:{
					change: function(field, newValue, oldValue){
					field.setValue(newValue.toUpperCase());
					}
					}
	    		},
	    		{
            	xtype:'label',
            	text:'',
            	cls:'mandatoryfield',
            	id:'mandatorymname'
            	},
	    		{
				xtype: 'label',
				text: '<%=middName%> '+'  :',
				cls:'labelstyle',
				id:'usermnamelabid'
				},
				{
				xtype:'textfield',
	    		cls:'textrnumberstyle',
	    		emptyText:'<%=entYourMiddName%>',
	    		maskRe: /([a-zA-Z0-9\s]+)$/,
	    		id:'unametmid',
	    		listeners:{
					change: function(field, newValue, oldValue){
					field.setValue(newValue.toUpperCase());
					}
					}
	    		},
	    		{
            	xtype:'label',
            	text:'*',
            	cls:'mandatoryfield',
            	id:'mandatoryselname'
            	},
	    		{
				xtype: 'label',
				text: '<%=lastName%> '+'  :',
				cls:'labelstyle',
				id:'userlnamelabid'
				},
				{
				xtype:'textfield',
	    		cls:'textrnumberstyle',
	    		allowBlank: false,
	    		emptyText:'<%=entUrLastName%>',
	    		maskRe: /([a-zA-Z0-9\s]+)$/,
	    		id:'unametlid',
	    		listeners:{
					change: function(field, newValue, oldValue){
					field.setValue(newValue.toUpperCase());
					}
					}
	    		},{
            	xtype:'label',
            	text:'*',
            	cls:'mandatoryfield',
            	id:'mandatorymap',
            	hidden:true
            	},
				{
				xtype: 'label',
				text: '<%=mapType%> '+'  :',
				cls:'labelstyle',
				id:'mapTypelabid',
				hidden:true
				},maptypecombo
				]},
				{
		        xtype:'fieldset', 
				title:'<%=ContactDetails%>',
				cls:'fieldsetpanel',
				collapsible: false,
				colspan:1,
				id:'custcontactdetails',
				layout:'table',
				layoutConfig: {
					columns:4
				},
				items: [
				{
            	xtype:'label',
            	text:'*',
            	cls:'mandatoryfield',
            	id:'mandatoryphone'
            	},
				{
				xtype: 'label',
				text: '<%=phoneNo%>'+'  :',
				cls:'labelstyle',
				id:'userphonelab'
				},{width:50},
				{
				xtype:'textfield',
	    		cls:'textrnumberstyle',
	    		regex:validate('phone'),
	    		emptyText:'<%=enterPhoneNo%>',
	    		blankText :'<%=enterPhoneNo%>',
	    		maxLength : 20,
	    		id:'userphoneno'
	    		},
	    		{
            	xtype:'label',
            	text:'',
            	cls:'mandatoryfield',
            	id:'mandatorymobile'
            	},
	    		{
				xtype: 'label',
				text: '<%=mobile%>'+'  :',
				cls:'labelstyle',
				id:'usermobilelab'
				},{width:50},
				{
				xtype:'textfield',
				cls:'textrnumberstyle',
	    		regex:validate('mobile'),
	    		maxLength : 20,
	    		emptyText:'<%=enterMobileNo%>',
	    		blankText :'<%=enterMobileNo%>',
	    		id:'usermobileno'
	    		},
	    		{
            	xtype:'label',
            	text:'',
            	cls:'mandatoryfield',
            	id:'mandatoryfax'
            	},
	    		{
				xtype: 'label',
				text: '<%=fax%> '+'  :',
				cls:'labelstyle',
				id:'userfaxlab'
				},{width:50},
				{
				xtype:'textfield',
	    		cls:'textrnumberstyle',
	    		regex:validate('phone'),
	    		emptyText:'<%=enterFaxNo%>',
	    		maxLength : 20,
	    		id:'userfax'
	    		},
	    		{
            	xtype:'label',
            	text:'*',
            	cls:'mandatoryfield',
            	id:'mandatoryemailidd'
            	},
	    		{
				xtype: 'label',
				text: '<%=email%> '+'  :',
				cls:'labelstyle',
				id:'useremaillab'
				},{width:50},
				{
				xtype:'textfield',
	    		cls:'textrnumberstyle',
	    		vtype: 'email',
	    		emptyText:'<%=EnterEmailId%>',
	    		id:'useremailid'
	    		}
				]},
					
				]
	    		 });
    	var winButtonPanel=new Ext.form.FormPanel({
		        	id: 'winbuttonid',
		        	standardSubmit: true,
					collapsible:false,
					autoHeight:true,
					cls:'windowbuttonpanel',
					frame:true,
					layout:'table',
					layoutConfig: {
						columns:4
					},
					items: [{id:'id1',
					         width:160
					},{id:'id2',
					 width:160
					  },
					{
	       			xtype:'button',
	      			text:'<%=Save%>',
	        		id:'addButtId',
	        		iconCls:'savebutton',
	        		cls:'buttonstyle',
	        		width:80,
	       			listeners: 
	       			{
	        			click:
	        			{
	       					fn:function()
	       					{
	     					
							if(Ext.getCmp('userpwdtfid').getValue()== ""){
							Ext.example.msg("<%=enterPass%>");
											Ext.getCmp('userpwdtfid').focus();
											return;
							}
							if(Ext.getCmp('userconfpwdtfid').getValue()== ""){
							Ext.example.msg("<%=enterPass%>");
											Ext.getCmp('userconfpwdtfid').focus();
											return;
							}
							if(Ext.getCmp('userconfpwdtfid').getValue()!=Ext.getCmp('userpwdtfid').getValue()){
							Ext.example.msg("<%=password_match%>");
											Ext.getCmp('userpwdtfid').focus();
											return;
							}
							
 var newpassword =  Ext.getCmp('userconfpwdtfid').getValue();
 var confirmpassword = Ext.getCmp('userpwdtfid').getValue();

var newpassword2 = newpassword.toLowerCase();
 var password12=password1.toLowerCase();
 var password22=password2.toLowerCase();
 var password32=password3.toLowerCase();
 var password42=password4.toLowerCase();
 var username2 = username.toLowerCase();
 var firstname2 = firstname.toLowerCase();
 var lastname2 = lastname.toLowerCase();

 if(newpassword == "" || confirmpassword == "" ){
 Ext.example.msg("Password Fields Cannot Be Empty");
 Ext.getCmp('userpwdtfid').focus();
 return;
 }
  if(newpassword != "" || confirmpassword != ""){
  if(newpassword != confirmpassword){
 Ext.example.msg("New password and confirm password are not same!");
 Ext.getCmp('userpwdtfid').focus();
 return;
  }
  }

   if(changepassword == true){
  if(newpassword.toLowerCase() == password1.toLowerCase() || newpassword.toLowerCase() == password2.toLowerCase() || newpassword.toLowerCase() == password3.toLowerCase() || newpassword.toLowerCase() == password4.toLowerCase()){
  Ext.example.msg("New password should not be same as your previous 4 passwords!");
 Ext.getCmp('userpwdtfid').focus();
 return;
  }
  
if( newpassword.toLowerCase() == username.toLowerCase()+firstname.toLowerCase() || newpassword.toLowerCase() == username.toLowerCase()+lastname.toLowerCase()  || newpassword.toLowerCase() == firstname.toLowerCase()+lastname.toLowerCase()  || newpassword.toLowerCase() == lastname.toLowerCase()+firstname.toLowerCase() ) {
 Ext.example.msg("Password  Should Not Combination of Username or Firstname or Lastname !");
 Ext.getCmp('userpwdtfid').focus();
 return;
  }
  if(newpassword.toLowerCase() == username.toLowerCase()) {
 Ext.example.msg("Password must be different from Username!");
 Ext.getCmp('userpwdtfid').focus();
 return;
  }
  
  if(newpassword.toLowerCase() == firstname.toLowerCase()) {
 Ext.example.msg("Password must be different from your first name !");
 Ext.getCmp('userpwdtfid').focus();
 return;
  }
  
  if(newpassword.toLowerCase() == lastname.toLowerCase()) {
 Ext.example.msg("Password must be different from your last name!");
 Ext.getCmp('userpwdtfid').focus();
 return;
  }
  
    if(newpassword2.indexOf(password12)==0 && password12 !="" ){
Ext.example.msg("Password should not contain Username,Firstname,Lastname and previous 4 passwords!");
Ext.getCmp('userpwdtfid').focus();
return;
}
 if(newpassword2.indexOf(password22)==0  && password22 !="" ){
Ext.example.msg("Password should not contain Username,Firstname,Lastname and previous 4 passwords!");
Ext.getCmp('userpwdtfid').focus();
return;
}

 if(newpassword2.indexOf(password32)==0   && password32!="" ){
Ext.example.msg("Password should not contain Username,Firstname,Lastname and previous 4 passwords!");
Ext.getCmp('userpwdtfid').focus();
return;
}

 if(newpassword2.indexOf(password42)==0   && password42!=""){
Ext.example.msg("Password should not contain Username,Firstname,Lastname and previous 4 passwords!");
Ext.getCmp('userpwdtfid').focus();
return;
}

 if(newpassword2.indexOf(username2)==0){
Ext.example.msg("Password should not contain Username,Firstname,Lastname and previous 4 passwords!");
Ext.getCmp('userpwdtfid').focus();
return;
}

 if(newpassword2.indexOf(firstname2)==0){
Ext.example.msg("Password should not contain Username,Firstname,Lastname and previous 4 passwords!");
Ext.getCmp('userpwdtfid').focus();
return;
}

 if(newpassword2.indexOf(lastname2)==0){
Ext.example.msg("Password should not contain Username,Firstname,Lastname and previous 4 passwords!");
Ext.getCmp('userpwdtfid').focus();
return;
}
  
  if(newpassword.length < 8) {
 Ext.example.msg("Password must contain at least 8 characters!");
 Ext.getCmp('userpwdtfid').focus();
 return;
  }
 
  var re = new RegExp("[0-9]");
  var res = re.test(newpassword);
 if(res==false){
 Ext.example.msg("Password must contain at least one number (0-9)!");
 Ext.getCmp('userpwdtfid').focus();
 return;
 }
 
  re = new RegExp("[a-z]");
  res = re.test(newpassword);
  if(res==false) {
 Ext.example.msg("Password must contain at least one lowercase letter (a-z)!");
 Ext.getCmp('userpwdtfid').focus();
 return;
   }
  
re = new RegExp("[A-Z]");
res = re.test(newpassword);
      if(res==false) {
 Ext.example.msg("Password must contain at least one uppercase letter (A-Z)!");
 Ext.getCmp('userpwdtfid').focus();
 return;
      }
      }


if(Ext.getCmp('unametfid').getValue()== ""){
							Ext.example.msg("<%=enterfName%>");
											Ext.getCmp('unametfid').focus();
											return;
							}
							if(Ext.getCmp('unametlid').getValue()== ""){
							Ext.example.msg("<%=entUrLastName%>");
											Ext.getCmp('unametlid').focus();
											return;
							}
							
							if(Ext.getCmp('userphoneno').getValue()== ""){
							Ext.example.msg("<%=enterPhoneNo%>");
											Ext.getCmp('userphoneno').focus();
											return;
							}if(Ext.getCmp('useremailid').getValue()== ""){
							Ext.example.msg("<%=enterEmail%>");
											Ext.getCmp('useremailid').focus();
											return;
							}
<!--							if(Ext.getCmp('maptypecomboid').getValue()== ""){-->
<!--							Ext.example.msg("<%=selectMapType%>");-->
<!--											Ext.getCmp('maptypecomboid').focus();-->
<!--											return;-->
<!--							}-->
	       		//Ajax request
	       			       		if(innerPanel.getForm().isValid()) {
										                Ext.Ajax.request({
										 				url: '<%=request.getContextPath()%>/UserManagementAction.do?param=updateUserDetails',
														method: 'POST',
														params: {
												         	 password:Ext.getCmp('userpwdtfid').getValue(),
												         	 firstName: Ext.getCmp('unametfid').getValue(),
												         	 middleName: Ext.getCmp('unametmid').getValue(),
												         	 lastName: Ext.getCmp('unametlid').getValue(),
												         	 userPhone: Ext.getCmp('userphoneno').getValue(),
												         	 userMobile:Ext.getCmp('usermobileno').getValue(),
												         	 userFax:Ext.getCmp('userfax').getValue(),
												         	 userEmail: Ext.getCmp('useremailid').getValue(),
												         	 mapType:0//Ext.getCmp('maptypecomboid').getValue()
												         },
									    success:function(response, options)//start of success
														{
												          var message = response.responseText;
												         
                          									 Ext.example.msg(message);
												         	 Ext.getCmp('userpwdtfid').reset();
												         	 Ext.getCmp('userconfpwdtfid').reset();
												         	 Ext.getCmp('unametfid').reset();
												         	 Ext.getCmp('unametmid').reset();
												         	 Ext.getCmp('unametlid').reset();
												         	 Ext.getCmp('userphoneno').reset(),
												         	 Ext.getCmp('usermobileno').reset(),
												         	 Ext.getCmp('userfax').reset(),
												         	 Ext.getCmp('useremailid').reset(),
												         	 Ext.getCmp('maptypecomboid').reset(),
															 myWin.hide();
															 
														}, // END OF  SUCCESS
											failure: function()//start of failure 
													    {
													         Ext.example.msg("error");
												         	 Ext.getCmp('userpwdtfid').reset();
												         	 Ext.getCmp('userconfpwdtfid').reset();
												         	 Ext.getCmp('unametfid').reset();
												         	 Ext.getCmp('unametmid').reset();
												         	 Ext.getCmp('unametlid').reset();
												         	 Ext.getCmp('userphoneno').reset(),
												         	 Ext.getCmp('usermobileno').reset(),
												         	 Ext.getCmp('userfax').reset(),
												         	 Ext.getCmp('useremailid').reset(),
												         	 Ext.getCmp('maptypecomboid').reset(),
															 myWin.hide();
															 
														} // END OF FAILURE 
										});	
										
										}else{
										Ext.example.msg("<%=check_mandatory%>");
									}
	       					}}}
	       		},
	       		{
	       			xtype:'button',
	      			text:'<%=Cancel%>',
	        		id:'canButtId',
	        		iconCls:'cancelbutton',
	        		cls:'buttonstyle',
	        		width:80,
	       			listeners: 
	       			{
	        			click:
	        			{
	       					fn:function()
	       					{
	       					myWin.hide();
	        					}}}
	       		}
					]
		           
		    }); 
	var outerPanelWindow = new Ext.Panel({
	    cls: 'outerpanelwindow',
	    standardSubmit: true,
	    frame: false,
	    items: [innerPanel, winButtonPanel]
	});
	myWin = new Ext.Window({
	    title: '<%=User_Profile%>',
	    closable: false,
	    modal: true,
	    autoScroll: true,
	    resizable: false,
	    id: 'myWin',
	    items: [outerPanelWindow],
	    cls: 'mywindow'
	
	});	
	var store = new Ext.data.JsonStore({
	    url: '<%=request.getContextPath()%>/UserManagementAction.do?param=getUserProfileDetails',
	    id: 'userStore',
	    root: 'UserDetailsRoot',
	    autoLoad: false,
	   fields: ['userName','password','firstName','middelName','lastName','mobileNo','phoneNo','fax','email','mapType']
	});
    
    function myWindow(){ 	
	 store.load({
		 callback: function(){var rec = store.getAt(0);
			 Ext.getCmp('userpwdtfid').setValue(rec.data['password']);
		     Ext.getCmp('userconfpwdtfid').setValue(rec.data['password']);
			 Ext.getCmp('unametfid').setValue(rec.data['firstName']);
		     Ext.getCmp('unametmid').setValue(rec.data['middelName']);
			 Ext.getCmp('unametlid').setValue(rec.data['lastName']);
			 Ext.getCmp('userphoneno').setValue(rec.data['phoneNo']);
			 Ext.getCmp('usermobileno').setValue(rec.data['mobileNo']);
			 Ext.getCmp('userfax').setValue(rec.data['fax']);
		     Ext.getCmp('useremailid').setValue(rec.data['email']);
		     Ext.getCmp('maptypecomboid').setValue(rec.get('mapType'));
		     changepassword = false;
		     myWin.show();
		     }
		});
     }	
     
    Ext.onReady(function(){
    if(<%=dayDiff%> >= 40 && <%=dayDiff%> <= 45 && <%=sessionPass%>==false)
    { 
    	if(<%=dayDiffToDisplay%>!=0)
    	alert("Your Password Will Expire in "+<%=dayDiffToDisplay%>+" Day(s) Change Your Password through Update Profile");
    	else
    	alert("Your Password Will Expire Today Change Your Password through Update Profile");
    }
    	document.onkeydown = function(e) {
		    if (event.keyCode == 123) {
		        return false;
		    }
		    if (e.ctrlKey && e.shiftKey && e.keyCode == 'I'.charCodeAt(0)) {
		        return false;
		    }
		    if (e.ctrlKey && e.shiftKey && e.keyCode == 'J'.charCodeAt(0)) {
		        return false;
		    }
		    if (e.ctrlKey && e.keyCode == 'U'.charCodeAt(0)) {
		        return false;
		    }
		}
    });
	$('#jspPageId').ready(function () {
  		$('#loadingMessage').css('display', 'block');
	});
	$('#jspPageId').load(function () {
  		$('#loadingMessage').css('display', 'none');
	});		
	function closeDuePaymentPopUp(){
		$( "#myDialog" ).dialog( "close" );
		$(".ui-dialog-titlebar-close").show();
	}
	function paymentDueNotification(){
	 if(<%=systemId%> == 132){
		   		$("#myDialogText").text("Please contact Pradeep on +91 99000 94879 at Telematics4u Services Pvt. Ltd");
		   }else{
		   		$("#myDialogText").text("Your monthly subscription payment is overdue, kindly release the payment immediately to avail uninterrupted service.");
		   	
		   }
	     // $("#myDialogText").text("Your monthly subscription payment is overdue, kindly release the payment immediately to avail uninterrupted service.");
	     //$("#myDialogText").text("Please contact Pradeep on +91 99000 94879 at Telematics4u Services Pvt. Ltd");
          $("#myDialog").dialog({
              title: 'Payment Due Notification',
              minHeight: 500,
              minWidth: 850,
              resizable: false,
              modal: true,
              draggable: false,
              closeOnEscape: false,
              show: {
                  effect: "fade",
                  duration: 800
              },
              open: function(event, ui) {
                  $(".ui-dialog-titlebar-close").hide();
              }
          });
      	setTimeout(closeDuePaymentPopUp, 5000);    
	}
	if (<%= isPaymentDue%> == true) {
		paymentDueNotification();
		setInterval(paymentDueNotification, 6000);
	}
	
			
		</script>
	</body>
</html>