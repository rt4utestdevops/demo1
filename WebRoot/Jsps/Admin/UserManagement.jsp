<%@ page  language="java" import="java.util.*,t4u.functions.CommonFunctions,t4u.beans.*,t4u.common.*" pageEncoding="utf-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
CommonFunctions cf=new CommonFunctions();
//cf.checkLoginInfo((LoginInfoBean)session.getAttribute("loginInfoDetails"),session,request,response);
String responseaftersubmit="''";
if(session.getAttribute("responseaftersubmit")!=null){
	responseaftersubmit="'"+session.getAttribute("responseaftersubmit").toString()+"'";
	session.setAttribute("responseaftersubmit",null);
}
LoginInfoBean loginInfo=(LoginInfoBean)session.getAttribute("loginInfoDetails");

int CustIdPassed=0;
if(request.getParameter("CustId")!=null){
	CustIdPassed=Integer.parseInt(request.getParameter("CustId").toString().trim());
}
//getting language
String language=loginInfo.getLanguage();
int systemId=loginInfo.getSystemId();
int userId=loginInfo.getUserId();

//getting client id
int customeridlogged=loginInfo.getCustomerId();
HashMap langConverted=ApplicationListener.langConverted;
LanguageWordsBean lwb=null;
ArrayList<String> al1=new ArrayList<String>();
ArrayList al=cf.getLanguageSpecificWordForKey(al1,language);
//Getting words based on language 
//String passregex="The password must be combination of following 3 cases: 1.Upper Case 2.Lower Case 3.Numerals 4.Special Characters 5.Min Char 8 Max Char 30";
ArrayList<String> tobeConverted=new ArrayList<String>();
tobeConverted.add("Phone_No");
tobeConverted.add("Saving_Form");
tobeConverted.add("Error");
tobeConverted.add("Account_Status");
tobeConverted.add("Contact_Details");
tobeConverted.add("Fax");
tobeConverted.add("Enter_Fax_No");
tobeConverted.add("Enter_Email_Id");
tobeConverted.add("Enter_Phone_No");
tobeConverted.add("Enter_Mobile_No"); 
tobeConverted.add("Mobile_No");
tobeConverted.add("Select_Status");
tobeConverted.add("Deleting");
tobeConverted.add("USER_ID");
tobeConverted.add("USERNAME");
tobeConverted.add("PASSWORD");
tobeConverted.add("First_Name"); 
tobeConverted.add("User_Authority");
tobeConverted.add("Last_Name");
tobeConverted.add("Middle_Name");
tobeConverted.add("User");
tobeConverted.add("Select_User");
tobeConverted.add("Select_Customer");
tobeConverted.add("Customer_Name");
tobeConverted.add("Save");
tobeConverted.add("Cancel");
tobeConverted.add("Add_Customer");
tobeConverted.add("Next");
tobeConverted.add("SLNO");
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
tobeConverted.add("Branch");
tobeConverted.add("Select_Branch");
tobeConverted.add("Feature_Group");
tobeConverted.add("Confirm_Password");
tobeConverted.add("Select_Feature_Group");
tobeConverted.add("User_Authority");
tobeConverted.add("Select_User_Authority");
tobeConverted.add("Status");
tobeConverted.add("Select_Status");
tobeConverted.add("New_User_Name");
tobeConverted.add("Enter_New_User_Name");
//tobeConverted.add("Select_User_Authority");
//tobeConverted.add("Status");
//tobeConverted.add("Select_Status");
//tobeConverted.add("New_User_Name");
//tobeConverted.add("Enter_New_User_Name");
tobeConverted.add("User_Registration");
tobeConverted.add("User_Name_Regex");
tobeConverted.add("password_match");
tobeConverted.add("User_Management");
tobeConverted.add("Validate_Mesg_For_Form");
tobeConverted.add("Add_User");
tobeConverted.add("No_Records_Found");
tobeConverted.add("Add");
tobeConverted.add("Modify");
tobeConverted.add("Delete");
tobeConverted.add("Modify_User_Information");
tobeConverted.add("want_delete_user");
tobeConverted.add("Select_Single_Row"); 
tobeConverted.add("Password_Message"); 
tobeConverted.add("Validate_Mesg_For_Inactive_User");
tobeConverted.add("Select_EM_Vision");
tobeConverted.add("EM_Vision");

ArrayList<String> convertedWords=new ArrayList<String>();
convertedWords=cf.getLanguageSpecificWordForKey(tobeConverted,language);
String phoneNo=convertedWords.get(0);
String savForm=convertedWords.get(1);
String error=convertedWords.get(2);
String AccountStatus=convertedWords.get(3);
String ContactDetails=convertedWords.get(4);
String fax=convertedWords.get(5);
String enterFaxNo=convertedWords.get(6);
String EnterEmailId=convertedWords.get(7);
String enterPhoneNo=convertedWords.get(8);
String enterMobileNo=convertedWords.get(9);
String mobile=convertedWords.get(10);
String selectStatus=convertedWords.get(11);
String deleting=convertedWords.get(12);
String USERID=convertedWords.get(13);
String USERNAME=convertedWords.get(14);
String password=convertedWords.get(15);
String firstName=convertedWords.get(16);
String userauthority=convertedWords.get(17);
String lastname=convertedWords.get(18);
String middlename=convertedWords.get(19);
String user=convertedWords.get(20);
String selUser=convertedWords.get(21);
String selCustName=convertedWords.get(22);
String custName=convertedWords.get(23);
String Save=convertedWords.get(24);
String Cancel=convertedWords.get(25);
String AddCustomer =convertedWords.get(26);
String Next=convertedWords.get(27);
String SLNO=convertedWords.get(28);
String userName=convertedWords.get(29);
String enterUserName=convertedWords.get(30);
String enterPass=convertedWords.get(31);
String enterfName=convertedWords.get(32);
String middName=convertedWords.get(33);
String entYourMiddName=convertedWords.get(34);
String lastName=convertedWords.get(35);
String entUrLastName=convertedWords.get(36);
String phone=convertedWords.get(37);
String entPhone=convertedWords.get(38);
String email=convertedWords.get(39);
String enterEmail=convertedWords.get(40);
String branch=convertedWords.get(41);
String selBranch=convertedWords.get(42);
String featureGroup=convertedWords.get(43);
String confpassword=convertedWords.get(44);
String selFetGrp=convertedWords.get(45);
String userAutho=convertedWords.get(46);
String selUserAuth=convertedWords.get(47);
String status=convertedWords.get(48);
String selstatus=convertedWords.get(49);
String newUserName=convertedWords.get(50);
String enterNewUserName=convertedWords.get(51);
String User_Registration=convertedWords.get(52);
String User_Name_Regex=convertedWords.get(53);
String password_match=convertedWords.get(54);
String User_Management=convertedWords.get(55);
String check_mandatory=convertedWords.get(56);
String Add_User=convertedWords.get(57);
String No_Records_Found=convertedWords.get(58);
String Add=convertedWords.get(59);
String Modify=convertedWords.get(60);
String Delete=convertedWords.get(61);
String Modify_User_Information=convertedWords.get(62);
String want_delete_user=convertedWords.get(63);
String selectSingleRow=convertedWords.get(64);
String passregex=convertedWords.get(65);
String Validate_Mesg_For_Inactive_User=convertedWords.get(66);
String SelectEMVision=convertedWords.get(67);
String EMVision=convertedWords.get(68);
String userAuthority=cf.getUserAuthority(systemId,userId);
boolean preciseSetting = cf.CheckImpreciseSettingForSystem(systemId);
boolean isLtsp=loginInfo.getIsLtsp()==0;
if(isLtsp==false && userAuthority.equals("User")){
		response.sendRedirect(request.getContextPath()
				+ "/Jsps/Common/401Error.html");
}

Properties properties = ApplicationListener.prop;

String roleModuleAPIurl = "";
Boolean roleBasedMenu =  cf.checkForRoleBasedMenu(systemId,customeridlogged);
if (roleBasedMenu){
  roleModuleAPIurl = properties.getProperty("roleModuleAPIAddress").trim();
}
%>

<!DOCTYPE HTML>
<html>
 <head>
 
		<title><%=User_Management%></title>		
	</head>	    
  <style>
  .x-panel-tl
	{
		border-bottom: 0px solid !important;
	}
	
	.mySelectstyle{
	 padding:2.7px;
	 width:120px !important;	
	 listwidth:120px !important;
	 max-listwidth:120px !important;
	 min-listwidth:120px !important;
	 margin:0px 0px 5px 5px !important;
}
  </style>
  <body height="100%">
   <%if (loginInfo.getStyleSheetOverride().equals("Y")){%>                  
    <jsp:include page="../Common/ImportJSSandMining.jsp"/>                                              
   <%}else {%>  
   <jsp:include page="../Common/ImportJS.jsp" />
   <%} %>
   <script>
   var pageName='<%=User_Management%>';
   var rbm = <%=roleBasedMenu%>;
 var outerPanel;
 var ctsb;
 var jspName="UserManagement";
 var exportDataType="string";
 var selected;
 var grid;
 var buttonValue;
 var preciseSet = <%=preciseSetting%>
 var titel;
 var globalCustomerID=parent.globalCustomerID;
 var myWin;
 var locationsetting = false;
 //to disable/enable when pop up opens ***************************************************************************************************
	function disableTabElements(){
		parent.Ext.getCmp('customerInformationTab').disable(true);
		parent.Ext.getCmp('productFeaturetab').disable(true);
		parent.Ext.getCmp('customizationTab').disable(true);
		if (parent.Ext.getCmp('userFeatureDetachmentTab')){
		parent.Ext.getCmp('userFeatureDetachmentTab').disable(true);
		}
		if (parent.Ext.getCmp('roleManagementTab')){
		parent.Ext.getCmp('roleManagementTab').disable(true);
		}
		parent.Ext.getCmp('assetGroupTab').disable(true);
		parent.Ext.getCmp('assetassociationTab').disable(true);
		parent.Ext.getCmp('userAssetGroupAssociationTab').disable(true);
}
function enableTabElements(){
		parent.Ext.getCmp('customerInformationTab').enable(true);
		parent.Ext.getCmp('productFeaturetab').enable(true);
		parent.Ext.getCmp('customizationTab').enable(true);
		if (parent.Ext.getCmp('userFeatureDetachmentTab')){
		parent.Ext.getCmp('userFeatureDetachmentTab').enable(true);
		}
		if (parent.Ext.getCmp('roleManagementTab')){
		parent.Ext.getCmp('roleManagementTab').enable(true);
		}
		parent.Ext.getCmp('assetGroupTab').enable(true);
		parent.Ext.getCmp('assetassociationTab').enable(true);
		parent.Ext.getCmp('userAssetGroupAssociationTab').enable(true);
}
 //override function for showing first row in grid
 Ext.override(Ext.grid.GridView, {
    afterRender: function(){
        this.mainBody.dom.innerHTML = this.renderRows();
        this.processRows(0, true);
        if(this.deferEmptyText !== true){
            this.applyEmptyText();
        }
        this.fireEvent("viewready", this);//new event
    }   
});
//event for resizing
Ext.EventManager.onWindowResize(function () {
				var width = Ext.getBody().getViewSize().width-10;
			    var height = '100%';
				outerPanel.setSize(width, height);
			    outerPanel.doLayout();
			});
//*****store for featuregroup
  var featuregroupstore= new Ext.data.SimpleStore({
			id:'featuregpstoreid',
			autoLoad: true,
			fields: ['Name','Value'],
			data: [['Feature1', '1'], ['Feature2', '2'], ['Feature3', '3']]
				                                });
 //*****combo for featuregroup
 var featureg_usercombo=new Ext.form.ComboBox({
	        store: featuregroupstore,
	        id:'featuregroupcomboId',
	        mode: 'local',
	        forceSelection: true,
	        emptyText:'<%=selFetGrp%>',
	        blankText:'<%=selFetGrp%>',
	        selectOnFocus:true,
	        allowBlank: false,
	        anyMatch:true,
            typeAhead: false,
	        triggerAction: 'all',
	        lazyRender: true,
	    	valueField: 'Value',
	    	displayField: 'Name',
	    	cls:'mySelectstyle'   
    });
    
     var userauthoritystore_old= new Ext.data.SimpleStore({
	  id:'userauthstoreid',
	  autoLoad: true,
	  fields: ['Name','Value'],
	  data: [['Supervisor','Supervisor'],['User','User'],['Admin','Admin']]
	  });
   //simple store of user authority
  var userauthoritystore= new Ext.data.JsonStore({
 			id:'userauthstoreid',
 			autoLoad: false,
 			fields: ['roleId','roleName'],
 		//	data: [['Supervisor','Supervisor'],['User','User'],['Admin','Admin']]
  });
 //******combobox for user authority
 var userauth_usercombo=new Ext.form.ComboBox({
 			
 			store: userauthoritystore,
	        id:'userauthcomboid',
	        mode: 'local',
	        forceSelection: true,
	        emptyText:'<%=selUserAuth%>',
	        blankText:'<%=selUserAuth%>',
	        selectOnFocus:true,
	        allowBlank: true,
	        anyMatch:true,
            typeAhead: false,
	        triggerAction: 'all',
	        lazyRender: true,
	    	valueField: 'roleId',
	    	displayField: 'roleName',
	    	cls:'mySelectstyle',
	    	triggerAction: 'all'   
    });
// store for branch
  var branchuserstore= new Ext.data.JsonStore({
				   url:'<%=request.getContextPath()%>/UserManagementAction.do?param=getBranches',
				   root: 'branches',
			       autoLoad: false,
				   fields: ['branchid','branchname']
	});
 //*****combo for branch
 var branch_usercombo=new Ext.form.ComboBox({
	        store: branchuserstore,
	        id:'branchusercomboid',
	        mode: 'local',
	        forceSelection: true,
	        emptyText:'<%=selBranch%>',
	        blankText:'<%=selBranch%>',
	        selectOnFocus:true,
	        allowBlank: true,
	        anyMatch:true,
            typeAhead: false,
	        triggerAction: 'all',
	        lazyRender: true,
	    	valueField: 'branchid',
	    	displayField: 'branchname',
	    	cls:'mySelectstyle' 
	    	
    });
 
  var impreciselocationsettingstore= new Ext.data.SimpleStore({
	  id:'impreciselocationsettingstoreId',
	  autoLoad: true,
	  fields: ['Name','Value'],
	  data: [['Precise', '0'], ['Imprecise', '1']]
			                                   });
			                                   
			                                   
	    var locationsettingcombo = new Ext.form.ComboBox({
        store: impreciselocationsettingstore,
        id:'locationsettingcomboId',
        mode: 'local',
        forceSelection: true,
        emptyText:'Location Setting Type ',
        blankText:'Location Setting Type ',
        selectOnFocus:true,
        allowBlank: false,
        anyMatch:true,
        typeAhead: false,
        triggerAction: 'all',
        value:'Precise',
        lazyRender: true,
    	valueField: 'Value',
    	displayField: 'Name',
    	cls:'selectstyle'   
    });
    		                                   
 
    //***** store for status
  var userstatuscombostore= new Ext.data.SimpleStore({
	  id:'userstatuscombostoreId',
	  autoLoad: true,
	  fields: ['Name','Value'],
	  data: [['Active', 'Active'], ['Inactive', 'Inactive']]
			                                   });
   //*****combo for status
    var userstatuscombo = new Ext.form.ComboBox({
        store: userstatuscombostore,
        id:'userstatuscomboId',
        mode: 'local',
        forceSelection: true,
        emptyText:'<%=selstatus%>',
        blankText:'<%=selstatus%>',
        selectOnFocus:true,
        allowBlank: false,
        anyMatch:true,
        typeAhead: false,
        triggerAction: 'all',
        value:'Active',
        lazyRender: true,
    	valueField: 'Value',
    	displayField: 'Name',
    	cls:'selectstyle'   
    });
    
   // store for EM VISION
  var emVisionstore= new Ext.data.JsonStore({
				   url:'<%=request.getContextPath()%>/UserManagementAction.do?param=getEmVision',
				   root: 'emVision',
			       autoLoad: false,
				   fields: ['emVisionId','emVisionName']
	});
 //*****combo for EM VISION
 var emVisionCombo=new Ext.form.ComboBox({
	        store: emVisionstore,
	        id:'emVisionstorecomboid',
	        mode: 'local',
	        forceSelection: true,
	        emptyText:'<%=SelectEMVision%>',
	        blankText:'<%=SelectEMVision%>',
	        selectOnFocus:true,
	        allowBlank: true,
	        anyMatch:true,
            typeAhead: false,
	        triggerAction: 'all',
	        value:20,
	        lazyRender: true,
	    	valueField: 'emVisionId',
	    	displayField: 'emVisionName',
	    	cls:'mySelectstyle'   
    });
    
    //store for usercustomer
    var usercustcombostore= new Ext.data.JsonStore({
			url:'<%=request.getContextPath()%>/CommonAction.do?param=getCustomer&getCustomer&paramforltsp=yes',
				   id:'CustomerStoreId',
			       root: 'CustomerRoot',
			       autoLoad: true,
			       remoteSort: true,
				   fields: ['CustId','CustName','Status','ActivationStatus'],
				   listeners: {
            load: function (custstore, records, success, options) {
		
				   
				     if ( <%= customeridlogged %> > 0) {
                Ext.getCmp('usercustocomboId').setValue(<%=customeridlogged%>);
                    store.load({
		                 	   params:{
		                 	   CustId:Ext.getCmp('usercustocomboId').getValue()
		                 	   }
		                 	   });
		                 	   branchuserstore.load({
		                 	   params:{
		                 	   CustId:Ext.getCmp('usercustocomboId').getValue()
		                 	   }
		                 	   });
		                 	   emVisionstore.load({
		                 	   params:{
		                 	   CustId:Ext.getCmp('usercustocomboId').getValue()
		                 	   }
		                 	   });
                }
                else if(<%= CustIdPassed %> > 0)
                {
                Ext.getCmp('usercustocomboId').setValue(<%=CustIdPassed%>);
                 store.load({
		                 	   params:{
		                 	   CustId:Ext.getCmp('usercustocomboId').getValue()
		                 	   }
		                 	   });
		           branchuserstore.load({
		                 	   params:{
		                 	   CustId:Ext.getCmp('usercustocomboId').getValue()
		                 	   }
		                 	   });
		          emVisionstore.load({
		                 	   params:{
		                 	   CustId:Ext.getCmp('usercustocomboId').getValue()
		                 	   }
		                 	   });
                }
                else if(globalCustomerID!=0)
                {
                Ext.getCmp('usercustocomboId').setValue(globalCustomerID);
                 store.load({
		                 	   params:{
		                 	   CustId:Ext.getCmp('usercustocomboId').getValue()
		                 	   }
		                 	   });
		               branchuserstore.load({
		                 	   params:{
		                 	   CustId:Ext.getCmp('usercustocomboId').getValue()
		                 	   }
		                 	   });
		              emVisionstore.load({
		                 	   params:{
		                 	   CustId:Ext.getCmp('usercustocomboId').getValue()
		                 	   }
		                 	   });
                }
                getRoles();
                }}
				   
 });
				                                
	var buttonPanel=new Ext.FormPanel({
		 id: 'buttonid',
		 cls:'colorid',
		 frame:true,
		 buttons:[{
			       text: '<%=Next%>',
			       cls:'colorid',
			       iconCls:'nextbutton',
			       handler : function(){
			       gotoUserFeature();
			       }
			      }]
	});
	function gotoUserFeature()
	{
	if(grid.getSelectionModel().getCount()==0){
	                        Ext.example.msg("<%=selectSingleRow%>");
           					return;
       						}
      if(grid.getSelectionModel().getCount()>1){
                            Ext.example.msg("<%=selectSingleRow%>");
           					return;
       						}
      if(grid.getSelectionModel().getSelected().get('statusIndex')=='Inactive')
               					{
               					Ext.example.msg("<%=Validate_Mesg_For_Inactive_User%>");
	                     	 	return;
	                     	 	}
	var userId="";
	var userfeaturedetachmenturl="";
	var selected ="";
    var customerId=Ext.getCmp('usercustocomboId').getValue();
    if(customerId=="" && customerId!="0"){
                            Ext.example.msg("<%=selCustName%>");
           					return;
       						}
    if (grid.getSelectionModel().getCount()!=0)
    {
    selected = grid.getSelectionModel().getSelected();
    userId=selected.get('useridIndex');
    userfeaturedetachmenturl='<%=request.getContextPath()%>/Jsps/Admin/UserAssetGroupAssociation.jsp?CustId='+customerId+'&UserId='+userId+'';
    }
    else
    {
    userfeaturedetachmenturl='<%=request.getContextPath()%>/Jsps/Admin/UserAssetGroupAssociation.jsp?CustId='+customerId+'&UserId=0';
    }
	parent.Ext.getCmp('userAssetGroupAssociationTab').enable();
	parent.Ext.getCmp('userAssetGroupAssociationTab').show();
	parent.Ext.getCmp('userAssetGroupAssociationTab').update("<iframe style='width:100%;height:530px;border:0;' src='"+userfeaturedetachmenturl+"'></iframe>");

	}			                                
  //*****combo for customer
    var customercombo = new Ext.form.ComboBox({
	        store: usercustcombostore,
	        id:'usercustocomboId',
	        mode: 'local',
	        forceSelection: true,
	        emptyText:'<%=selCustName%>',
	        blankText:'<%=selCustName%>',
	        selectOnFocus:true,
	        allowBlank: false,
	        anyMatch:true,
            typeAhead: false,
	        triggerAction: 'all',
	        lazyRender: true,
	    	valueField: 'CustId',
	    	displayField: 'CustName',
	    	listWidth : 200,
	    	cls:'selectstyle',
	    	listeners: {
		                   select: {
		                 	   fn:function(){
		                 	   
		                 	  getRoles();
		                 	    parent.globalCustomerID=Ext.getCmp('usercustocomboId').getValue();
		                 	   store.load({
		                 	   params:{
		                 	   CustId:Ext.getCmp('usercustocomboId').getValue()
		                 	   }
		                 	   });
		                 	    branchuserstore.load({
		                 	   params:{
		                 	   CustId:Ext.getCmp('usercustocomboId').getValue()
		                 	   }
		                 	   });
		                 	    emVisionstore.load({
		                 	   params:{
		                 	   CustId:Ext.getCmp('usercustocomboId').getValue()
		                 	   }
		                 	   });
              		          	}
              		          	}
	    	 }
	    	
	    	 
    });
/*********Customer Panel*************/
var customerpanel=new Ext.Panel({
			title:'',
			renderTo : 'content',
			standardSubmit: true,
			frame:false,
			border:false,
			cls:'outerpanel',
			layout:'table',
			layoutConfig: {
				columns:2
			},
			items: [{
				xtype: 'label',
				text: '<%=custName%>  :',
				cls:'labelstyle',
				id:'customernamelabel'
				},customercombo
	    		]	
			});
 
 
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
            	cls:'mandatoryfield',
            	id:'mandatorysername'
            	},
				{
				xtype: 'label',
				text: '<%=userName%> '+'  :',
				cls:'labelstyle',
				id:'unameidlabid'
				},
				{
				xtype:'textfield',
                //regex:/^([a-zA-Z0-9]([a-zA-Z0-9-]*[a-zA-Z0-9])?)?$/,
	    		cls:'textrnumberstyle',
	    		emptyText:'<%=enterUserName%>',
	    		allowBlank: false,
	    		blankText :'<%=enterUserName%>',
	    		regexText:'<%=User_Name_Regex%>',
	    		maskRe: /([a-zA-Z0-9\s.@]+)$/,
	    		id:'unamefieldid'
	    		
	    		},
	    		{
            	xtype:'label',
            	text:'*',
            	hidden:true,
            	cls:'mandatoryfield',
            	id:'mandatorynewusername'
            	},{
				xtype: 'label',
				text: '<%=newUserName%> '+'  :',
				allowBlank: false,
				cls:'labelstyle',
				hidden:true,
				id:'newuserlabelid'
				},
				{
				xtype:'textfield',
				cls:'textrnumberstyle',
				//regex:/^([a-zA-Z0-9]([a-zA-Z0-9-]*[a-zA-Z0-9])?)?$/,
				//regexText:'</%=User_Name_Regex%>',
	    		emptyText:'<%=enterNewUserName%>',
	    		allowBlank: false,
	    		hidden:true,
	    		blankText :'<%=enterNewUserName%>',
	    		id:'newuserfieldid'
	    		
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
	    		},
	    		{
            	xtype:'label',
            	text:'',
            	cls:'mandatoryfield',
            	id:'mandatorybranch'
            	},
				{
				xtype: 'label',
				text: '<%=branch%> '+'  :',
				cls:'labelstyle',
				id:'userbranchlabid'
				},branch_usercombo,
				{
            	xtype:'label',
            	text:'*',
            	cls:'mandatoryfield',
            	id:'mandatoryauth'
            	},
				{
				xtype: 'label',
				text: '<%=userAutho%> '+' (Role) :',
				cls:'labelstyle',
				id:'userauthoritylabid'
				},userauth_usercombo,
	    		{
            	xtype:'label',
            	text:'*',
            	cls:'mandatoryfield',
            	id:'mandatoryvision'
            	},{
				xtype: 'label',
				text: '<%=EMVision%>'+'  :',
				cls:'labelstyle',
				id:'emVisionlabid'
				},emVisionCombo
	    		
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
				allowDecimals:false,
				cls:'textrnumberstyle',
	    		regex:validate('mobile'),
	    		maxLength : 20,
	    		emptyText:'<%=enterMobileNo%>',
	    		blankText :'<%=enterMobileNo%>',
	    		id:'userphoneno'
	    		},
	    		{
            	xtype:'label',
            	text:'',
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
				allowDecimals:false,
	    		cls:'textrnumberstyle',
	    		regex:validate('phone'),
	    		emptyText:'<%=enterPhoneNo%>',
	    		blankText :'<%=enterPhoneNo%>',
	    		maxLength : 20,
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
				allowDecimals:false,
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
	    		//vtype: 'email',	    		
	    		regex :/^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/,
	    		emptyText:'<%=EnterEmailId%>',
	    		id:'useremailid',
					listeners:{
					change: function(field, newValue, oldValue){
					field.setValue(newValue.toLowerCase());
					}
					}
	    		},
				
				]},
				{
		        xtype:'fieldset', 
				title:'<%=AccountStatus%>',
				cls:'fieldsetpanel',
				collapsible: false,
				colspan:1,
				id:'custaccountstatus',
		
				layout:'table',
				layoutConfig: {
					columns:4
				},
				items: [
				{
            	xtype:'label',
            	text:'*',
            	cls:'mandatoryfield',
            	id:'mandatorystatus'
            	},
				{
				xtype: 'label',
				text: '<%=status%> '+' :',
				cls:'labelstyle',
				id:'custmaststatuslab'
				},{width:50},userstatuscombo,
				{
            	xtype:'label',
            	text:'',
            	cls:'mandatoryfield',
            	id:'mandatorymname1'
            	},
				{
				xtype: 'label',
				text: 'Location Setting '+' :',
				cls:'labelstyle',
				id:'custmaststatuslab1',
				hidden:true,
				},{width:50},locationsettingcombo
				]}
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
	       					
	       					if( Ext.getCmp('locationsettingcomboId').getValue() == 1 ){
	       					locationsetting =true;
	       					}else{
	       					locationsetting =false;
	       					}
	       						       					
	       		           if(Ext.getCmp('unamefieldid').getValue()== ""){
	       		                            Ext.example.msg("<%=enterUserName%>");
											Ext.getCmp('unamefieldid').focus();
											return;
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
							if(Ext.getCmp('userauthcomboid').getValue()== "" || Ext.getCmp('userauthcomboid').getValue()==0){
							Ext.example.msg("<%=selUserAuth%>");
											Ext.getCmp('userauthcomboid').focus();
											return;
							}
							if(Ext.getCmp('emVisionstorecomboid').getValue()== ""){
							Ext.example.msg("<%=SelectEMVision%>");
											Ext.getCmp('emVisionstorecomboid').focus();
											return;
							}
							if(Ext.getCmp('userphoneno').getValue()== ""){
							Ext.example.msg("<%=enterMobileNo%>");
											Ext.getCmp('userphoneno').focus();
											return;
							}
							
							if(Ext.getCmp('useremailid').getValue()== ""){
							Ext.example.msg("<%=enterEmail%>");
											Ext.getCmp('useremailid').focus();
											return;
							}
							if(Ext.getCmp('userstatuscomboId').getValue()== ""){
							Ext.example.msg("<%=selstatus%>");
											Ext.getCmp('userstatuscomboId').focus();
											return;
							}
							if(Ext.getCmp('locationsettingcomboId').getValue()== ""){
							Ext.example.msg("<%=selstatus%>");
											Ext.getCmp('locationsettingcomboId').focus();
											return;
							}
							
							
			    
			    var selected = grid.getSelectionModel().getSelected();
			    var userId;
			    
			    if(selected==undefined || selected=="undefined" )
				{
   				userId="0";
   				}
               if(buttonValue=="add"){
               Ext.getCmp('newuserfieldid').setValue(Ext.getCmp('unamefieldid').getValue());
               //Ext.getCmp('newuserfieldid').show();
               userId="0";
               }else if(buttonValue=="modify"){
               userId=selected.get('useridIndex');
               
               }
               var  userAuthority;
               var roleIdSelected;
             if (rbm){
				  userAuthority =  Ext.getCmp('userauthcomboid').getRawValue();
				  roleIdSelected = 	Ext.getCmp('userauthcomboid').getValue();					         	 
			 }else{
				  userAuthority =  Ext.getCmp('userauthcomboid').getValue();
				  roleIdSelected = 0;
			 }
               if(innerPanel.getForm().isValid()) {
               
	       		//Ajax request
										                Ext.Ajax.request({
										 				url: '<%=request.getContextPath()%>/UserManagementAction.do?param=saveUserDetails',
														method: 'POST',
														params: {
														     buttonValue:buttonValue,
														     userId:userId,
															 custName:Ext.getCmp('usercustocomboId').getValue(),
												         	 userName:Ext.getCmp('unamefieldid').getValue(),
												         	 newUserName:Ext.getCmp('newuserfieldid').getValue(),
												         	 firstName: Ext.getCmp('unametfid').getValue(),
												         	 middleName: Ext.getCmp('unametmid').getValue(),
												         	 lastName: Ext.getCmp('unametlid').getValue(),
												         	 branch: Ext.getCmp('branchusercomboid').getValue(),
												         	 userAuth: userAuthority,
												         	 //userAuth: Ext.getCmp('userauthcomboid').getRawValue(),
												         	 userPhone: Ext.getCmp('userphoneno').getValue(),
												         	 userMobile:Ext.getCmp('usermobileno').getValue(),
												         	 userFax:Ext.getCmp('userfax').getValue(),
												         	 userEmail: Ext.getCmp('useremailid').getValue(),
												         	 userStatus: Ext.getCmp('userstatuscomboId').getValue(),
												         	 emvision:Ext.getCmp('emVisionstorecomboid').getValue(),
												         	 locationSetting : locationsetting,
												         	 pageName: pageName,
												         	 roleId: roleIdSelected
												         	 
												         },
									    success:function(response, options)//start of success
														{
														
														var str=response.responseText;
														var array = str.split(",");
														var a = array[0];
														var b = array[1];
														
														store.load(
														{
														params:{
														CustId:Ext.getCmp('usercustocomboId').getValue()
														},
														 callback:function(){
														 var ind=grid.store.findExact('useridIndex', b);
														 
														  grid.getSelectionModel().selectRow(ind);
														 }
														}
														);
														      Ext.example.msg(a);
												         	 Ext.getCmp('unamefieldid').reset();
												         	
												         	 Ext.getCmp('unametfid').reset();
												         	 Ext.getCmp('unametmid').reset();
												         	 Ext.getCmp('unametlid').reset();
												         	 Ext.getCmp('branchusercomboid').reset();
												         	 Ext.getCmp('emVisionstorecomboid').reset();
												         	 Ext.getCmp('userauthcomboid').reset();
												         	 Ext.getCmp('userphoneno').reset(),
												         	 Ext.getCmp('usermobileno').reset(),
												         	 Ext.getCmp('userfax').reset(),
												         	 Ext.getCmp('useremailid').reset(),
												         	 Ext.getCmp('userstatuscomboId').reset();
												         	 Ext.getCmp('locationsettingcomboId').reset();
															 enableTabElements();
															 myWin.hide();
															 
														}, // END OF  SUCCESS
											failure: function()//start of failure 
													    {
													         Ext.example.msg("error");
												         	 Ext.getCmp('unamefieldid').reset();
												         	 
												         	 Ext.getCmp('unametfid').reset();
												         	 Ext.getCmp('unametmid').reset();
												         	 Ext.getCmp('unametlid').reset();
												         	 Ext.getCmp('branchusercomboid').reset();
												         	 Ext.getCmp('emVisionstorecomboid').reset();
												         	 Ext.getCmp('userauthcomboid').reset();
												         	 Ext.getCmp('userphoneno').reset(),
												         	 Ext.getCmp('usermobileno').reset(),
												         	 Ext.getCmp('userfax').reset(),
												         	 Ext.getCmp('useremailid').reset(),
												         	 Ext.getCmp('userstatuscomboId').reset();
												         	  Ext.getCmp('locationsettingcomboId').reset();
															 enableTabElements();
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
	       					enableTabElements();
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
        title:titel,
        closable: false,
        modal: true,
        resizable:false,
        autoScroll: false,
         cls:'mywindow',
        //height : 400,
        //width  : 700,
        id     : 'myWin',
        items  : [outerPanelWindow]
    });
 //function for add button
 function addRecord(){
 buttonValue="add";
 titel='<%=Add_User%>';
 myWin.setPosition(400,50);
 myWin.setTitle(titel);
 if(Ext.getCmp('usercustocomboId').getValue() == "" && Ext.getCmp('usercustocomboId').getValue() != "0" )
			    {
			          Ext.example.msg("<%=selCustName%>");
		            Ext.getCmp('usercustocomboId').focus();
                      	 return;
			    }
	    Ext.getCmp('mandatorynewusername').hide();
		Ext.getCmp('newuserlabelid').hide();
		Ext.getCmp('newuserfieldid').hide();
		Ext.getCmp('mandatorysername').show();	
		Ext.getCmp('unameidlabid').show();
      	Ext.getCmp('unamefieldid').show();
      	disableTabElements();	    
 		myWin.show();
       
      	 Ext.getCmp('unamefieldid').reset();
      
      	 Ext.getCmp('unametfid').reset();
      	 Ext.getCmp('unametmid').reset();
      	 Ext.getCmp('unametlid').reset();
      	 Ext.getCmp('branchusercomboid').reset();
      	 Ext.getCmp('emVisionstorecomboid').reset();
      	 Ext.getCmp('userauthcomboid').reset();
      	 Ext.getCmp('userphoneno').reset(),
      	 Ext.getCmp('usermobileno').reset(),
      	 Ext.getCmp('userfax').reset(),
      	 Ext.getCmp('useremailid').reset(),
      	 Ext.getCmp('userstatuscomboId').reset();
      	 Ext.getCmp('locationsettingcomboId').reset();
 
 }
 
  
    //******************grid config starts********************************************************
		// **********************reader configs
	var reader = new Ext.data.JsonReader({
        idProperty: 'userdetailid',
        root: 'UserDetailsRoot',
        totalProperty: 'total',
        fields: [
        {name: 'slnoIndex'},
        {
            name: 'useridIndex'
        }, {
            name: 'usernameIndex'
        },{
            name: 'passwordIndex'
        },{
            name: 'firstnameIndex'
        }, {
            name: 'middlenameIndex'
        }, 
        {
            name: 'lastnameIndex'
        }, {
            name: 'phonenoIndex'
        }, 
        {
            name: 'mobilenoIndex'
        },{
            name: 'faxIndex'
        }, {
            name: 'emailIndex'
        },{
            name: 'branchidIndex'
        },
         {
            name: 'branchnameIndex'
        },{
            name: 'userauthorityIndex'
        }, {
            name: 'statusIndex'
        },{
            name:'processIdIndex'
        },{
            name:'locationSettingIndex'
        },{
            name:'roleIdIndex'
        }]
	});
	
	       //************************* store configs  
	       
var store =  new Ext.data.GroupingStore({
        autoLoad:false,
        proxy: new Ext.data.HttpProxy({
        url:'<%=request.getContextPath()%>/UserManagementAction.do?param=getUserDetails',
        method: 'POST'
		}),
        remoteSort: false,
        sortInfo: {
            field: 'usernameIndex',
            direction: 'ASC'
        },
        storeId: 'userStore',
        reader:reader
    });
	store.on('beforeload', function (store, operation, eOpts) {
	operation.params = {
	 CustId:Ext.getCmp('usercustocomboId').getValue()
	};
	}, this);
	
//**********************filter config
    var filters = new Ext.ux.grid.GridFilters({
    local:true,
        filters: [
        {type: 'numeric',dataIndex: 'slnoIndex'},
         {
            type: 'string',
            dataIndex: 'useridIndex'
        },{
            type: 'string',
            dataIndex: 'usernameIndex'
        },{
            type: 'string',
            dataIndex: 'passwordIndex'
        },{
            type: 'string',
            dataIndex: 'firstnameIndex'
        }, {
            type: 'string',
            dataIndex: 'middlenameIndex'
        }, 
        {
            type: 'string',
            dataIndex: 'lastnameIndex'
        }, {
            type: 'string',
            dataIndex: 'phonenoIndex'
        }, {
            type: 'string',
            dataIndex: 'mobilenoIndex'
        }, 
        {
            type: 'string',
            dataIndex: 'faxIndex'
        },
        {
            type: 'string',
            dataIndex: 'emailIndex'
        },{
            type: 'string',
            dataIndex: 'branchidIndex'
        }, 
       {
            type: 'string',
            dataIndex: 'branchnameIndex'
        },
        {
            type: 'string',
            dataIndex: 'userauthorityIndex'
        },{
            type: 'string',
            dataIndex: 'statusIndex'
        },{
            type: 'string',
            dataIndex: 'locationSettingIndex'
        },{
            type: 'string',
            dataIndex: 'roleIdIndex'
        }]
    });    
    
    //**************column model config 
    var createColModel = function (finish, start) {

        var columns = [
        new Ext.grid.RowNumberer({header: "<span style=font-weight:bold;><%=SLNO%></span>",width:50}),
         {
            dataIndex: 'slnoIndex',
            hidden:true,
            header: "<span style=font-weight:bold;><%=SLNO%></span>",
            filter:
            {
            	type: 'numeric'
			}
        },
        {
            dataIndex: 'useridIndex',
            hidden:true,
            header: "<span style=font-weight:bold;><%=USERID%></span>",
            filter:
            {
            	type: 'string'
			}
        },
         {
        	header: "<span style=font-weight:bold;><%=USERNAME%></span>",
            dataIndex: 'usernameIndex',
            filter: {
            type: 'string'
            }
        },  {
            dataIndex: 'useridIndex',
            hidden:true,
            header: "<span style=font-weight:bold;><%=password%></span>",
            filter:
            {
            	type: 'string'
			}
        },{
            header: "<span style=font-weight:bold;><%=firstName%></span>",
            dataIndex: 'firstnameIndex',
            filter: {
            type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;><%=middlename%></span>",
            dataIndex: 'middlenameIndex',
            filter: {
            type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;><%=lastname%></span>",
            dataIndex: 'lastnameIndex',
            filter: {
            type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=mobile%></span>",
            dataIndex: 'phonenoIndex',
            filter: {
            type: 'string'
            }
        }, 
        {
            header: "<span style=font-weight:bold;><%=phone%></span>",
            dataIndex: 'mobilenoIndex',
            filter: {
            type: 'string'
            }
        },
         {
            header: "<span style=font-weight:bold;><%=fax%></span>",
            dataIndex: 'faxIndex',
            hidden:'true',
            filter: {
            type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;><%=email%></span>",
            dataIndex: 'emailIndex',
            filter: {
            type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;><%=branch%></span>",
            dataIndex: 'branchidIndex',
            hidden:true,
            filter: {
            type: 'string'
            }
        },
        {
            header: "<span style=font-weight:bold;><%=branch%></span>",
            dataIndex: 'branchnameIndex',
            filter: {
            type: 'string'
            }
        },
        {
            header: "<span style=font-weight:bold;><%=userauthority%></span>",
            hidden:true,
            dataIndex: 'userauthorityIndex',
            filter: {
            type: 'string'
            }
        },
        {
            header: "<span style=font-weight:bold;><%=status%></span>",
            dataIndex: 'statusIndex',
            filter: {
            type: 'string'
            }
        },
        {
            header: "<span style=font-weight:bold;>Location Setting</span>",
            dataIndex: 'locationSettingIndex',
            filter: {
            type: 'string'
            }
        },
        {
            header: "<span style=font-weight:bold;>Role Id</span>",
            hidden:true,
            dataIndex: 'roleIdIndex',
            hideable: false,
            filter: {
            type: 'string'
            }
        }
        ];

        return new Ext.grid.ColumnModel({
            columns: columns.slice(start || 0, finish),
            defaults: {
                sortable: true
            }
        });
    };
    
<% 

if (roleBasedMenu){
if( customeridlogged > 0)
{
	//System.out.println(userAuthority);
	if(userAuthority.equalsIgnoreCase("Admin"))
	{%>    
    	grid=getGridManager('','No Records Found',store,screen.width-50,390,18,filters,'Clear Filter Data',false,'',14,false,'',false,'',false,'',jspName,exportDataType,false,'',true,'Add',true,'Modify');
 	<%} else if(userAuthority.equalsIgnoreCase("Supervisor")) {%>
 		    grid=getGridManager('','No Records Found',store,screen.width-50,390,18,filters,'Clear Filter Data',false,'',14,false,'',false,'',false,'',jspName,exportDataType,false,'',false,'Add',true,'Modify');
 	<%} else {%>
  		    grid=getGridManager('','No Records Found',store,screen.width-50,390,18,filters,'Clear Filter Data',false,'',14,false,'',false,'',false,'',jspName,exportDataType,false,'',true,'Add',true,'Modify');
 		<%}
		 } else {%>
			grid=getGridManager('','No Records Found',store,screen.width-50,390,18,filters,'Clear Filter Data',false,'',14,false,'',false,'',false,'',jspName,exportDataType,false,'',true,'Add',true,'Modify'); 
				 <% }}
else{
if(customeridlogged > 0 )
{
	if(userAuthority.equalsIgnoreCase("Admin"))
	{%>    
    	grid=getGridManager('','No Records Found',store,screen.width-50,390,18,filters,'Clear Filter Data',false,'',14,false,'',false,'',false,'',jspName,exportDataType,false,'',true,'Add',true,'Modify');
 	<%} else if(userAuthority.equalsIgnoreCase("Supervisor")) {%>
 		    grid=getGridManager('','No Records Found',store,screen.width-50,390,18,filters,'Clear Filter Data',false,'',14,false,'',false,'',false,'',jspName,exportDataType,false,'',false,'Add',true,'Modify');
 	<%} else {%>
  		    grid=getGridManager('','No Records Found',store,screen.width-50,390,18,filters,'Clear Filter Data',false,'',14,false,'',false,'',false,'',jspName,exportDataType,false,'',false,'Add',false,'Modify');
 		<%}
		 } else {%>
			grid=getGridManager('','No Records Found',store,screen.width-50,390,18,filters,'Clear Filter Data',false,'',14,false,'',false,'',false,'',jspName,exportDataType,false,'',true,'Add',true,'Modify',true,'Delete'); 
				 <% }}%>
   
  //modify the dat
 function modifyData(){
 if(Ext.getCmp('usercustocomboId').getValue() == "" && Ext.getCmp('usercustocomboId').getValue() != "0" )
			    {
			             Ext.example.msg("<%=selCustName%>");
                      	 Ext.getCmp('usercustocomboId').focus();
                      	 return;
			    }
	if(grid.getSelectionModel().getCount()==0){
	                        Ext.example.msg("<%=selectSingleRow%>");
           					return;
       						}
      if(grid.getSelectionModel().getCount()>1){
                           Ext.example.msg("<%=selectSingleRow%>");
           					return;
       						}
  buttonValue="modify";
  titel="<%=Modify_User_Information%>"
  disableTabElements();
  myWin.show();
  myWin.setTitle(titel);
       Ext.getCmp('newuserlabelid').hide();
       Ext.getCmp('mandatorynewusername').hide();
		Ext.getCmp('newuserfieldid').hide();
		Ext.getCmp('mandatorysername').hide();
		Ext.getCmp('unameidlabid').hide();
      	 Ext.getCmp('unamefieldid').hide();
      	
      	 Ext.getCmp('unametfid').reset();
      	 Ext.getCmp('unametmid').reset();
      	 Ext.getCmp('unametlid').reset();
      	 Ext.getCmp('branchusercomboid').reset();
      	 Ext.getCmp('emVisionstorecomboid').reset();
      	 Ext.getCmp('userauthcomboid').reset();
      	 Ext.getCmp('userphoneno').reset(),
      	 Ext.getCmp('usermobileno').reset(),
      	 Ext.getCmp('userfax').reset(),
      	 Ext.getCmp('useremailid').reset(),
      	 Ext.getCmp('userstatuscomboId').reset();
      	 Ext.getCmp('locationsettingcomboId').reset();
      	 
var selected = grid.getSelectionModel().getSelected();
 //alert(selected.get('usernameIndex'));
      	 Ext.getCmp('unamefieldid').setValue(selected.get('usernameIndex'));
      	 Ext.getCmp('newuserfieldid').setValue(selected.get('usernameIndex'));
      	 Ext.getCmp('unametfid').setValue(selected.get('firstnameIndex'));
      	 Ext.getCmp('unametmid').setValue(selected.get('middlenameIndex'));
      	 Ext.getCmp('unametlid').setValue(selected.get('lastnameIndex'));
      	 Ext.getCmp('branchusercomboid').setValue(selected.get('branchidIndex'));
      	 Ext.getCmp('emVisionstorecomboid').setValue(selected.get('processIdIndex'));
      	 if (rbm){
      	 Ext.getCmp('userauthcomboid').setValue(selected.get('roleIdIndex'));
      	 }else{
      	 Ext.getCmp('userauthcomboid').setValue(selected.get('userauthorityIndex'));
      	 }
      	 
      	// alert(" role id :: "+selected.get('userauthorityIndex'));
      	 //var dispField = selected.get('userauthorityIndex') ;
      	 // Ext.getCmp('userauthcomboid').setRawValue(selected.get('roleIdIndex'));
      	
      	 Ext.getCmp('userphoneno').setValue(selected.get('phonenoIndex'));
      	 Ext.getCmp('usermobileno').setValue(selected.get('mobilenoIndex'));
      	 Ext.getCmp('userfax').setValue(selected.get('faxIndex'));
      	 Ext.getCmp('useremailid').setValue(selected.get('emailIndex'));
      	 Ext.getCmp('userstatuscomboId').setValue(selected.get('statusIndex'));
      	 Ext.getCmp('locationsettingcomboId').setValue(selected.get('locationSettingIndex'));
      	//   var record = userauthoritystore.find(selected.get('roleIdIndex'));
	   	 //Ext.getCmp('userauthcomboid').select(record);
 }
 //deleting record
 function deleteData(){
 if(Ext.getCmp('usercustocomboId').getValue() == "" && Ext.getCmp('usercustocomboId').getValue() != "0" )
			    {
			             Ext.example.msg("<%=selCustName%>");
                      	 Ext.getCmp('usercustocomboId').focus();
                      	 return;
			    }
if(grid.getSelectionModel().getCount()==0){
                            Ext.example.msg("<%=selectSingleRow%>");
           					return;
       						}
      if(grid.getSelectionModel().getCount()>1){
                            Ext.example.msg("<%=selectSingleRow%>");
           					return;
       						}
 var selected = grid.getSelectionModel().getSelected();

  
                           Ext.Msg.show({
										title: '',
										msg: '<%=want_delete_user%>',
										buttons: {
										yes: true,
										no: true
										},
										fn: function(btn) {
										switch(btn){
										case 'yes':  
        						
						    	var custId=Ext.getCmp('usercustocomboId').getValue();
						    	var userId=selected.get('useridIndex');
						    	
						    	//showing message
							    ctsb.showBusy('<%=deleting%>');
								outerPanel.getEl().mask();
								//Ajax request
								Ext.Ajax.request({
								 				url: '<%=request.getContextPath()%>/UserManagementAction.do?param=deleteUserDetails',
												method: 'POST',
												params: 
												{
													 custId:custId,
													 userId:userId,
													 pageName: pageName
										        },
												success:function(response, options)//start of success
												{
												    Ext.example.msg(response.responseText);
											        store.reload();
												       outerPanel.getEl().unmask();
												    
												}, // END OF  SUCCESS
											    failure: function()//start of failure 
											    {
											          Ext.example.msg("error");
												     store.reload();
												       outerPanel.getEl().unmask();
												     
												} // END OF FAILURE 
									}); // END OF AJAX
									
											break;
										case 'no':
										               Ext.example.msg("Not Deleted");
  												       store.reload();
														break;
														
														}
														}
														});	
   
 }
 
 
	
	  
//*****main starts from here*************************
 Ext.onReady(function(){
 if(preciseSet == true){
 Ext.getCmp("custmaststatuslab1").show();
 Ext.getCmp("locationsettingcomboId").show();
 grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('locationSettingIndex'), false);
 }else{
 Ext.getCmp("custmaststatuslab1").hide();
 Ext.getCmp("locationsettingcomboId").hide();
 grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('locationSettingIndex'), true);
 }
	ctsb=tsb;
	Ext.QuickTips.init();
	Ext.form.Field.prototype.msgTarget = 'side';			         	   			
 	outerPanel = new Ext.Panel({
			title:'',
			renderTo : 'content',
			standardSubmit: true,
			frame:true,
			cls:'outerpanel',
			border:false,
			items: [customerpanel,grid,buttonPanel]
			//bbar:ctsb			
			}); 
 // and the following code when rendering the grid

    grid.getView().on({
        viewready: {
            fn: function(){
               //var row = grid.getView().getRow(10); // Getting HtmlElement here
               grid.getSelectionModel().selectRow(0);
				//Ext.get(row).highlight();
				
            }
        }
    });
    //grid.render('results');    
    //grid.getView().focusEl.focus();
		                                   
	});
	
	
	function getRoles(){
	console.log("aaaa");
	if (rbm){
        Ext.Ajax.request({
    		url : '<%= roleModuleAPIurl %>' + 'getRolesForUser',
           
            method : 'GET',
			headers: {
			'Content-Type': 'application/json'
			},
            params:{
	 	                   systemId:'<%=systemId%>',
	 	                   customerId:Ext.getCmp('usercustocomboId').getValue(),
	                  	   userId:'<%=userId%>' 
	                	   },
            success: function(resp) {
            // alert(" role id :: "+resp.responseText);
                var result = Ext.decode(resp.responseText);
          		userauthoritystore.loadData(result);
            },
        });
    }else{
    	var result = [{"roleId":"Supervisor","roleName":"Supervisor"},{"roleId":"Admin","roleName":"Admin"},{"roleId":"User","roleName":"User"}];
       userauthoritystore.loadData(result);
     }
        ///data: [['Supervisor','Supervisor'],['User','User'],['Admin','Admin']]
	}
  </script>
  </body>
</html>
