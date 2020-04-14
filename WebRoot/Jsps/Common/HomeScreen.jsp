<%@page language="java" import="java.util.*,t4u.functions.HomeScreenFunctions,t4u.functions.CommonFunctions,t4u.functions.AdminFunctions,t4u.beans.*,t4u.common.*" pageEncoding="utf-8"%>
<%@ taglib uri="http://packtag.sf.net" prefix="pack" %>
<%@page import="t4u.functions.AlertFunctions"%>

<%	
	
	String basePath = request.getScheme() + "://"+ request.getServerName() + ":" + request.getServerPort()+"/";
	CommonFunctions cf=new CommonFunctions();
	AdminFunctions af=new AdminFunctions();
	cf.checkLoginInfo((LoginInfoBean)session.getAttribute("loginInfoDetails"),session,request,response);
	LoginInfoBean loginInfo=(LoginInfoBean)session.getAttribute("loginInfoDetails");
	HttpSession sessionPassMsg = request.getSession(true);
	
	if(request.getParameter("ltspCustomer")!=null){
	loginInfo.setCustomerId(Integer.parseInt(request.getParameter("ltspCustomer")));
	}
	String processId=null;
	if(request.getParameter("processId")!=null){
	processId=request.getParameter("processId").trim();
	}
	session.setAttribute("processId",processId);
	int totalVehicles=-1;
	int systemId = loginInfo.getSystemId();
	int customerId = loginInfo.getCustomerId();
	int userId = loginInfo.getUserId();
	int isLTSP = loginInfo.getIsLtsp();
	int offset = loginInfo.getOffsetMinutes();
	String userAuthority = cf.getUserAuthority(systemId,userId);
	if(request.getParameter("id")!=null)
	{
		totalVehicles=Integer.parseInt((String)request.getParameter("id"));
	} else if(request.getParameter("id") == null && systemId == 261 && isLTSP == -1){
		totalVehicles = cf.getVehicleCount(customerId,systemId,userId);
	}
	String language=loginInfo.getLanguage();
	String userName=(String)session.getAttribute("userName");
	HomeScreenFunctions homeScreenFunctions = new HomeScreenFunctions();
	AlertFunctions alertFunctions=new AlertFunctions();
	int distressCount=alertFunctions.getDistrssAlertCount(loginInfo.getOffsetMinutes(),customerId,systemId,userId);
	String path = request.getContextPath();
	String LTSPName="";
	LTSPName=(String)session.getAttribute("ltspName");
	HashMap<Object, Object> verticalMenus = homeScreenFunctions.getVerticalMenus(path, systemId, customerId, userId,processId,language,totalVehicles);
	HashMap<Object, Object> horizontalMenus = homeScreenFunctions.getHorizontalMenus(systemId, customerId, userId,processId,language);
	ArrayList<Integer> horizontalMenusSubId = (ArrayList<Integer>)horizontalMenus.get("horizontalMenusSubId");
	String home=cf.getLabelFromDB("Home",language);
	String logout=cf.getLabelFromDB("Logout",language);
	String wlecome=cf.getLabelFromDB("Welcome",language);
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
	
/*
int dayDiff=af.getPasswordModifiedDate(offset,userId,systemId);
int dayDiffToDisplay=0;
if(dayDiff >= 40 && dayDiff <= 45)
{
	dayDiffToDisplay = 45-dayDiff;
} */
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
	sessionPassMsg.setAttribute("PassExpMsg",true);
%>
<!DOCTYPE html>
<html lang="en" class="no-js">
	<head>
		<meta charset="UTF-8" />
		<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1"> 
		<meta name="viewport" content="width=device-width, initial-scale=1.0"> 
		<title><%= verticalMenus.get("verticalName")%></title>
		
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
		
		
		<link id="sheet1" rel="stylesheet" type="text/css" href="../../Main/modules/common/homeScreen/css/component.css" />
		<link rel="stylesheet" type="text/css" href="../../Main/modules/LTSP/css/menu.css" />
		<link rel="stylesheet" type="text/css" href="../../Main/modules/common/homeScreen/css/normalize.css" />
		<link rel="stylesheet" type="text/css" href="../../Main/modules/common/homeScreen/css/layout.css" />
		<link rel="stylesheet" type="text/css" href="../../Main/modules/common/homeScreen/css/searchVehicleComponent.css" /> 		
		<link rel="stylesheet" type="text/css" href="../../Main/modules/cashVan/theme/css/EXTJSExtn.css" /> 
		
		<script src="../../Main/Js/modernizr.custom.js"></script>
		<script src="../../Main/modules/common/homeScreen/js/digitalTimer.js"></script>
		<link rel="stylesheet" href="//code.jquery.com/ui/1.11.4/themes/smoothness/jquery-ui.css"> 
		<script src="../../Main/Js/jquery.js"></script>
        <script src="../../Main/Js/jquery-ui.js"></script>
        <style>
        #jspPageId{
			width: 100%;
			height: 656px !important;
			padding-top:70px !important;
		}
		@media screen and (device-width:1920px) {
			#jspPageId{
				width: 100%;
				height:971px !important;
				padding-top:63px !important;
			}
		}
		@media (device-width: 1280px) and (device-height: 720px) {
			#jspPageId {
			    width: 100%;
			    height: 600px !important;
			    padding-top: 63px !important;
			}
		}
		@media screen and (device-width: 1600px) {
			#jspPageId {
			    width: 100%;
			    height: 775px !important;
			    padding-top: 63px !important;
			}
		}
		@media screen and (device-width:1440px) {
			#jspPageId{
				width:100%;
				height: 775px !important;
				padding-top: 63px !important;
			}
		}
		@media (device-width: 1280px) and (device-height: 800px) {
			#jspPageId {
				width: 100%;
				height: 680px !important;
				padding-top: 63px !important;
			}
		}
		@media (device-width: 1280px) and (device-height: 960px) {
			#jspPageId {
				width: 100%;
				height: 850px !important;
				padding-top: 63px !important;
			}
		}
		@media (device-width: 1280px) and (device-height: 1024px) {
			#jspPageId {
				width: 100%;
				height: 900px !important;
				padding-top: 63px !important;
			}
		}

		#head {
			height: 40px;
		}
		.gn-menu-main {
		    top: 40px;
		    left: 0;
		    width: 100%;
		    height: 35px;
		}
		body {
		    overflow-y: hidden;
		}
		html,body {
		    height:100%;
		    margin:0;
		}
		.comapnyLogo>a img {
		    width: auto\9;
		    height: 33px;
		    max-width: 60%;
		    vertical-align: middle;
		    border: 1px solid #B1B1B1;
		    -ms-interpolation-mode: bicubic;
		}
		#head #companyHeader {
    display: block;
    color: #ffffff;
    text-decoration: none;
    font-family: 'Open Sans', sans-serif;
    font-size: 20px;
    float: left;
}

        </style>
		</head>	
	<body onload="getDigitalTimer('<%=cf.getCurrentDateTime(loginInfo.getOffsetMinutes())%>'); " oncontextmenu="return false;">		
		<div class="container">
			<div id="head">		
				<div class="comapnyLogo">			
					<a id="companyHeader">
						<img id="companyImage" src ="/ApplicationImages/CustomerLogos/custlogo_<%=loginInfo.getSystemId()%>.gif" >&nbsp;<%=LTSPName%></a>
				</div>
<!--				<div class="downloadapp"><a id="openwindow" class="anchor" href="#"><%=Download_Mobile_App%></a></div>-->
					<div id="dialog" style="display:none">
    				<form>
        			<table>
           		 <tr>
              <td>
              	<div><p class="Emvision">EM-Vision is a real time Vehicle Monitoring App intended to help users to easily view the location of the vehicles, view on map, activity, etc.
				</p></div></td> </tr>
				<tr>
					<td><div><a href="https://play.google.com/store/apps/details?id=com.t4u&hl=en" target="_blank"><img id="androidApp" class ="image1" src="/ApplicationImages/HomeScreen/androidApp.png"/></a></div></td>
					<td><div><a href="https://itunes.apple.com/us/app/em-vision/id834264549?mt=8" target="_blank"><img id="mobileImg1" class="mac" src="/ApplicationImages/HomeScreen/mac.png"/></a></div></td>
					<td><div><a href="http://www.windowsphone.com/en-in/store/app/em-vision/12a63dda-8bac-40ca-bd4c-bdc536082513" target="_blank"><img id="mobileImg2" class="windows" src="/ApplicationImages/HomeScreen/windows.png"/></a></div></td>
				
				<td><div><img id="mobileImg" class="image" src="/ApplicationImages/HomeScreen/mobile2.png"/></div></td></tr>
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
				
				<!--Vertical Menus-->

				<li class="gn-trigger" id="verticalMenuId">
					<a class="gn-icon gn-icon-menu" style="background-image: url(/ApplicationImages/HomeScreen/menu_mtn_n.png) !important; background-repeat: no-repeat; background-position: 17px 10px;"><span>Menu</span></a>					
					<nav class="gn-menu-wrapper" id="gn-menu-wrapper-id">
						<div class="gn-scroller" id="scrollbar">
							<ul class="gn-menu">
								<%=verticalMenus.get("verticalMenus")%>	
							</ul>
						</div>							
					</nav>
				</li>
				<!-- Horizonatal Menus -->				
				<%=horizontalMenus.get("horizontalMenus")%>
				<li id='Alert' onclick="getjspPage('<%=request.getContextPath()%>/Jsps/Common/Alert.jsp');"><a title="Emergency Alert : <%=distressCount%>" id="abc"><img src="/ApplicationImages/AlertIcons/Distress2.png" style="height:26px;" ><div class="bubble"  style="margin-top: -58px; height: 0px;" ><%=distressCount%></div></a></li>
				<li id="searchImageId"><img id="searchImg" src="/ApplicationImages/ApplicationButtonIcons/search24.png" title="search vehicle" onclick="showPopUp();"></img>
				   <span class="t4u-tooltip-arrow" id="tooltipId"></span>
				      <div class="mp-vehicle-details-wrapper" id="vehicle-details"> 
				      		<table>
					  		<tr class='me-select-label'><td id="first"><span class='vehicle-details-block-header'>Search Vehicle</span></td><td><span class='vehicle-details-block-sep'>&nbsp;:</span></td><td id="third"><input id="searchId" class="search" /></td></tr>
					  		<tr class='me-select-label'><td id="first"><span class='vehicle-details-block-header'>Vehice No</span></td><td><span class='vehicle-details-block-sep'>&nbsp;:</span></td><td id="third"><p class='vehicle-details-block' id='vehicle-No'></p></td></tr>
							<tr class='me-select-label'><td id="first"><span class='vehicle-details-block-header'>Date Time</span></td><td><span class='vehicle-details-block-sep'>&nbsp;:</span></td><td id="third"><p class='vehicle-details-block' id='Date-Time'></p></td></tr>
							<tr class='me-select-label'><td id="first"><span class='vehicle-details-block-header'>Location</span></td><td><span class='vehicle-details-block-sep'>&nbsp;:</span></td><td id="third"><p class='vehicle-details-block' id='Location'></p></td></tr>
							<tr class='me-select-label'><td id="first"><span class='vehicle-details-block-header'>Driver Name</span></td><td><span class='vehicle-details-block-sep'>&nbsp;:</span></td><td id="third"><p class='vehicle-details-block' id='Driver-Id'></p></td></tr>
							<tr class='me-select-label'><td id="first"><span class='vehicle-details-block-header'>Driver Mobile</span></td><td><span class='vehicle-details-block-sep'>&nbsp;:</span></td><td id="third"><p class='vehicle-details-block' id='Driver-Mobile'></p></td></tr>
							<tr class='me-select-label-last'><td id="first"><span class='vehicle-details-block-header'>Owner Name</span></td><td><span class='vehicle-details-block-sep'>&nbsp;:</span></td><td id="third"><p class='vehicle-details-block' id='Owner-Name'></p></td></tr>
							<tr class='me-select-label-last'><td id="first"><span class='vehicle-details-block-header'>Asset Capacity</span></td><td><span class='vehicle-details-block-sep'>&nbsp;:</span></td><td id="third"><p class='vehicle-details-block' id='Vehicle-Capacity'></p></td></tr>
							</table>
  		              </div>
				</li>
				<!-- Profile Menu -->
				<li onclick="toggleSubMenuFunction('profileId')"><a><span class = "userProfile"><img src ="/ApplicationImages/HomeScreen/user_icon.png" alt></span></a>
					<div id = "profileId" hidden= "true" >
						<div class="update-profile">			
						<a id="login-user" class="user-name" style="font-size: 14px; "> <%=userName %></a>
						<p id="userAuthority" style="font-size: 14px; !important "> &nbsp;Role: <%=userAuthority%>&nbsp;</p>
						<a onclick="myWindow()" id="update_profile" style="font-size: 14px; " ><%= Update_Profile%></a>	
<!--						<a onclick="toggleUserManualAction()" style="font-size: 14px; " >User Manual</a>	-->
						</div>
						<ul class="dropdown-menu pull-right">			
							<%if(request.getParameter("ltspCustomer")!=null){%>
							<li id="homeId" onclick = "home()"><a style="font-size: 14px; "><%=home%></a></li>
							<%}%>
							<li id="logoutId" onclick = "logOut()"><a style="font-size: 14px; "><%=logout %></a></li>
						</ul>
					</div>
				</li>
			</ul>
			</div>
			<input type="hidden" id="spareNames"/>
			<!-- /IFrame To Display JSP -->	
			<div id="iframescrollbar">
				<iframe id = "jspPageId" frameborder="0"></iframe>				
			</div>
			 <div id="myDialog" style="display:none;background-color: black !important;color: white;">
			 	<div id="myDialogText" style="font-family:'Open Sans', sans-serif;font-size: 2.10em;text-align: center;padding-top: 20%;"></div>
		 	 </div>	
		 			
		</div><!-- /container -->							
		<script src="../../Main/modules/common/homeScreen/js/classie.js"></script>
		
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
    		url:'<%=basePath%>'+'ApplicationImages/CustomerLogos/custlogo_<%=loginInfo.getSystemId()%>.gif',
   			type: "HEAD",    		
    		error:
       		 function(){
             $('#companyImage').attr('src', '/ApplicationImages/CustomerLogos/defaultImage.gif');
       		 },
   			 success:
       		 function(){
            
        	}
		});
		$("#openwindow").click(function () {
 			$("#dialog").dialog({
            autoOpen: true,
            modal: true,
            height:400,
            width:600,
            show: {
                
            },
            hide: {
               
            }
        });
});
		//Dynamic loading of js and css file for IE-9 and others browers		
		function isIE () {
	       var myNav = navigator.userAgent.toLowerCase();
	       return (myNav.indexOf('msie') != -1) ? parseInt(myNav.split('msie')[1]) : false;
	    }
	    if(navigator.appName == 'Microsoft Internet Explorer' && isIE ()==9){
	    $('#sheet1').remove();
	    $('head').append('<link id="sheet2" rel="stylesheet" type="text/css" href="../../Main/modules/common/homeScreen/css/componentnew.css" />');					
			$.ajax({
	 	 		 url: '<%=path%>'+'/Main/modules/common/homeScreen/js/gnmenu_for_ie_9.js',
	 	 		 async: false,
	 	 		 dataType: "script",
			});
		 }
		 else{		 		 
				 $.ajax({
		 	 	 url: '<%=path%>'+'/Main/modules/common/homeScreen/js/gnmenu.js',
		 	     async: false,
		 	     dataType: "script",
		         });
		 }
		//Defualt Page After Login
		var firstLoad=0;
		getJSPPage('<%=verticalMenus.get("defaultLink")%>', '#list1');
		getVerticalMenus('#menu1', '<%=verticalMenus.get("defaultLinkId")%>');
		
		
		function toggleSubMenuFunction(id){
				closeSearchPopUp();		
			var e = document.getElementById(id);			
			if(e.style.display == 'block') {
				e.style.display = 'none';
				for(var i = 1 ; i<='<%=verticalMenus.get("subVerticalMenusCount")%>'; i++){
					if('subListId'+i == id){
						document.getElementById('subMenuImageID'+i).src = "/ApplicationImages/ApplicationButtonIcons/icon_plus.png";	
					}					
				}				
			} else {
				e.style.display = 'block';
				
				for(var i = 1 ; i<='<%=verticalMenus.get("subVerticalMenusCount")%>'; i++){
					if('subListId'+i != id){
						var subId = document.getElementById('subListId'+i);
						subId.style.display = 'none';
						document.getElementById('subMenuImageID'+i).src = "/ApplicationImages/ApplicationButtonIcons/icon_plus.png";	
					} else {
						document.getElementById('subMenuImageID'+i).src = "/ApplicationImages/ApplicationButtonIcons/icon_minus.png";
					}					
				}
			}
		}
		function toggleUserManualAction(){	
			 window.open("<%=request.getContextPath()%>/UserManualDownload");	
		}
		function getJSPPage(jspLink, list){
			$('#jspPageId').attr('src',jspLink);
			$(list).addClass('verticalListActive');
			for(var i = 1; i<='<%=verticalMenus.get("verticalMenusCount")%>'; i++) {
				if(list != '#list'+i)	
					$('#list'+i).removeClass('verticalListActive');
			}
		}
		
		function getVerticalMenus(menu, processId){
				closeSearchPopUp();
				var subProcessId="#"+processId;
				var menuId="'"+menu+"'";
				if(firstLoad>0) {
				
				if(processId==<%=verticalMenus.get("defaultLinkId")%>){
				firstLoad=0;															
				getJSPPage('<%=verticalMenus.get("defaultLink")%>', '#list1');
				   $(subProcessId).removeAttr('onclick');
				   setTimeout(function(){				   			   		
				     $(subProcessId).attr('onclick',"getVerticalMenus("+menuId+","+processId+")");
				      }, 6000);
				}			
				
				if(processId == <%=verticalMenus.get("liveVisionProcessId")%>){
					firstLoad=0;
					var systemId = '<%=systemId%>';
					var totalVeh = <%=totalVehicles%>;
					var userId = <%=userId%>;
					if(totalVeh > 4000 && systemId == 261){
						$('#jspPageId').attr('src','/Telematics4uApp/Jsps/Common/LiveVisionWithTableData.jsp');
					}
					else if(systemId == 257 && userId == 198){
						$('#jspPageId').attr('src','/Telematics4uApp/Jsps/Common/HistoryAnalysis.jsp');
					}
					else{
						$('#jspPageId').attr('src','<%=verticalMenus.get("liveVisionPath")%>');
					}
				}
				}
					
			if('<%=horizontalMenusSubId.size() > 0%>') {
				$(menu).addClass('active');
				for(var i = 1; i<='<%=horizontalMenusSubId.size()%>'; i++) {
					if(menu != '#menu'+i)	
						$('#menu'+i).removeClass('active');
				}
			
				for(var i = 1; i<='<%=verticalMenus.get("verticalMenusCount")%>'; i++) {	
					$('#list'+i).removeClass('active');
				}
				
				var j=<%=horizontalMenusSubId.get(0)%>;
				for(var i=j;i<='<%=horizontalMenusSubId.get(horizontalMenusSubId.size()-1)%>' ;i++){				
					if(processId == i){	
						$('#div'+i).show();
					}  else {
						$('#div'+i).hide();
					}
				}
			}
			
			if(firstLoad>0) {
				var hideTimer=null;	
				$('#gn-menu-wrapper-id').removeClass('gn-menu-wrapper');
				$('#gn-menu-wrapper-id').addClass('gn-menu-wrapper gn-open-all');
					hideTimer = setTimeout(function() { 
    		    	  	$('#gn-menu-wrapper-id').removeClass('gn-menu-wrapper gn-open-all');
       					$('#gn-menu-wrapper-id').addClass('gn-menu-wrapper');
       					}, 4000);			
				
				$("#gn-menu-wrapper-id").bind({mouseenter:function() {
					if (hideTimer !== null) {
        				clearTimeout(hideTimer);
    			       }  
                  	},mouseleave:function(){
	                    $('#gn-menu-wrapper-id').removeClass('gn-menu-wrapper gn-open-all');
						$('#gn-menu-wrapper-id').addClass('gn-menu-wrapper');
						           
                  	 }
                 });	
			}
			firstLoad=1;	
		}
		function logOut() {				
			window.location="<%=request.getContextPath()%>/LogOut.do?username=<%=loginInfo.getUserName()%>";
		}
		
		function home() {
		window.location="/jsps/LTSPScreen.jsp?CustomerId=0";		
		}	
		function getjspPage(jspLink)
		{
		
		$('#jspPageId').attr('src',jspLink);
		}
		
		function showPopUp(){	
		 if($('#vehicle-details').is(":visible")){ 
		 $('#searchId').val('');
		 document.getElementById('vehicle-No').innerHTML='';
				document.getElementById('Date-Time').innerHTML='';
				document.getElementById('Driver-Id').innerHTML='';
				document.getElementById('Driver-Mobile').innerHTML='';
				document.getElementById('Owner-Name').innerHTML='';
				document.getElementById('Location').innerHTML='';
				document.getElementById('Vehicle-Capacity').innerHTML='';
			 	 	$('#tooltipId').hide();
			 	 	$('#vehicle-details').hide();			 		
 	 	}else{ 	 	 
		 	 	$('#tooltipId').show();
		 	 	$('#vehicle-details').show();
 	 		}
		}
		
		function closeSearchPopUp(){
				 $('#searchId').val('');
		        document.getElementById('vehicle-No').innerHTML='';
				document.getElementById('Date-Time').innerHTML='';
				document.getElementById('Driver-Id').innerHTML='';
				document.getElementById('Driver-Mobile').innerHTML='';
				document.getElementById('Owner-Name').innerHTML='';
				document.getElementById('Location').innerHTML='';
				document.getElementById('Vehicle-Capacity').innerHTML='';
			 	 	$('#tooltipId').hide();
			 	 	$('#vehicle-details').hide();	 	
		}
	
		$.ajax({
	    url: "<%=request.getContextPath()%>/CommonAction.do?param=getVehicleList",
	    type: 'POST',
	    success: function(response,data) {
	        var text = response;	       
	       	var list=text.split(",");	        
	       $( "#searchId" ).autocomplete({			
		      source: list,		       
		      select: function( event, ui ) {		      
              $.ajax({
               url: "<%=request.getContextPath()%>/CommonAction.do?param=getVehicleDetails",
               type: 'POST',
               data: { vehicleNo:ui.item.value},
               success: function(response,data) {
               var details=response;
               if(details){           
                detail=details.split("!");                           
                document.getElementById('vehicle-No').innerHTML=detail[0];
				document.getElementById('Date-Time').innerHTML=detail[1];
				document.getElementById('Driver-Id').innerHTML=detail[2];
				document.getElementById('Driver-Mobile').innerHTML=detail[3];
				document.getElementById('Owner-Name').innerHTML=detail[4];
				document.getElementById('Location').innerHTML=detail[5];
				document.getElementById('Vehicle-Capacity').innerHTML=detail[6];
				
				}
				
               }
              });
            }
		    });
	    }
	});	
	
		new gnMenu( document.getElementById( 'gn-menu' ) );
		
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
	    	cls:'selectstyle'   
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
            	id:'mandatorymap'
            	},
				{
				xtype: 'label',
				text: '<%=mapType%> '+'  :',
				cls:'labelstyle',
				id:'mapTypelabid'
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
					//height:50,
					//width:670,
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
							if(Ext.getCmp('maptypecomboid').getValue()== ""){
							Ext.example.msg("<%=selectMapType%>");
											Ext.getCmp('maptypecomboid').focus();
											return;
							}
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
												         	 mapType:Ext.getCmp('maptypecomboid').getValue()
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
												         	 Ext.getCmp('maptypecomboid').reset();
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
												         	 Ext.getCmp('maptypecomboid').reset();
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
	var outerPanelWindow=new Ext.Panel({
			cls:'outerpanelwindow',
			standardSubmit: true,
			frame:false,
			items: [innerPanel, winButtonPanel]
			}); 
		
	 myWin = new Ext.Window({	
	 				title:'<%=User_Profile%>',	
	      			closable: false,
			        modal: true,
			        autoScroll: true,
			        resizable:false,
			        id     : 'myWin',
			        items  : [outerPanelWindow],
			        cls:'mywindow'
			        
			    });
 
	var store = new Ext.data.JsonStore({
		    url: '<%=request.getContextPath()%>/UserManagementAction.do?param=getUserProfileDetails',
		    id: 'userStore',
		    root: 'UserDetailsRoot',
		    autoLoad: false,
		   fields: ['userName','password','firstName','middelName','lastName','mobileNo','phoneNo','fax','email','mapType']
		});
    
    function myWindow()
	 { 	
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
     		if(<%=isLTSP%> > 0 || <%=isLTSP%> == -1 ){
     			   if(<%=dayDiff%> >= 40 && <%=dayDiff%> <= 45)
    				{ 
    					if(<%=dayDiffToDisplay%>!=0)
    						alert("Your Password Will Expire in "+<%=dayDiffToDisplay%>+" Day(s) Change Your Password through Update Profile");
    						else
    						alert("Your Password Will Expire Today Change Your Password through Update Profile ");
    				}
     		}
     
     if(<%=systemId%> == 257 && <%=customerId%> == 4522 && <%=userId%> == 198 ){ 
		document.getElementById('Alert').style.display="none";
		document.getElementById('verticalMenuId').style.display="none";
		document.getElementById('searchImageId').style.display="none";
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