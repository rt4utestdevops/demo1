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
}*/
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
			.ext-strict .x-form-text {
    			height: 21px !important;
			}
			label {
				display : inline !important;
			}
			#maptypecomboid {
				height: 21px !important;
			}
			#addButtId {
				margin-left : -109px !important;
			}
			#myWin {
				top: 6px !important;
			}
			 .x-window-bc {
    			height: 30px !important;   
			}
			.x-window-tl *.x-window-header {
    			height: 42px !important;
    		}
		</style>		
		
		<script>		
		window.onload = function () { 
			myWindow();
		}
		
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
		
		
		//Dynamic loading of js and css file for IE-9 and others browers		
	
		//Defualt Page After Login

		var mapTypeStore= new Ext.data.SimpleStore({
			id:'maptypestoreid',
			autoLoad: true,
			fields: ['Name','Value'],
			data: [['Google Satellite','1'],['Google Street','0']]
				                                });
		
		
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
		
		
			
					 //simple store of google map type
  //******combobox for google map type
     
			
		var myWin;
		var innerPanel = new Ext.form.FormPanel({
		standardSubmit: true,
		collapsible:false,
		autoScroll:true,
		height:440,
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
  
  //var mobileNumber =  Ext.getCmp('userphonelab').getValue();
  
 /*if(mobileNumber.length < 10) {
Ext.example.msg("Phone number must be greater than 10 digits!");
Ext.getCmp('userphonelab').focus();	 
return;
 }*/
 
 if(Ext.getCmp('mandatorymobile') < 10) {
Ext.example.msg("Mobile number must be greater than 10 digits!");
Ext.getCmp('mandatorymobile').focus();	 
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
<!--							}  -->
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
												         	 mapType:0 //Ext.getCmp('maptypecomboid').getValue()
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
			        modal: false,
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
	
	
	
		</script>		
	