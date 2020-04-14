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
   String  loginUserName = loginInfo.getUserName();
   //getting client id
   int customeridlogged=loginInfo.getCustomerId();
   System.out.println(" Login cust id :: "+customeridlogged);
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

   Properties properties = ApplicationListener.prop;
   String roleModuleAPIurl = properties.getProperty("roleModuleAPIAddress").trim();

   if(isLtsp==false && userAuthority.equals("User")){
   		response.sendRedirect(request.getContextPath()
   				+ "/Jsps/Common/401Error.html");
   }
   //roleModuleAPIurl = "http://localhost:9007/roleModule/";
   %>
   
   
<style>
   #alertTypeSelect{
   border:#dfdfdf;
   background: #f0f0f0;
   }
   .headerAlertAdd {
   display:flex;padding:4px;margin-bottom:8px;background:grey;color:white;margin-top:16px;border-radius:2px;
   }
   .center-view{
   top:40%;
   left:50%;
   position:fixed;
   height:200px;
   width:200px;
   z-index:1000;
   }
   select{
   height: 26px;
   border-radius: 4px;
   }
   input {
   border-radius:4px;
   }
   .modal-dialog{
   width: 80%;
   margin-left: 10%;
   min-width: 80%;
   margin-top: 4% !important;
   }
   .saveICon{
   color:green;cursor:pointer;position: absolute;
   right: 40px;
   }
   .modal-header{
   padding: 12px 16px !important;
   }

   .dispNone{display:none !important;}

   .multiselect {
      width:124px !important;
      text-align: left !important;
      overflow: hidden;
    text-overflow: ellipsis;
    white-space: nowrap;
   }
   .dropdown-toggle::after {
     border-top:0px !important;
   }
</style>
<jsp:include page="../Common/header.jsp" />

<div class="center-view"  id="loading-div">
   <img src="../../Main/images/loading.gif" alt="">
</div>
<table id="alertTable"  style="width: 100%;display:none;font-size:14px;" class="stripe">
   <thead>
      <tr>
         <th>Edit</th>
         <th>Alert Type</th>
         <th>Hours (hh:mm)</th>
         <th>Distance (kms)</th>
         <th>Schedule</th>

      </tr>
   </thead>
</table>
<!-- Modal -->
<div id="alertModal" class="modal fade" role="dialog" data-backdrop="static" 	data-keyboard="false">
   <div class="modal-dialog"  >
      <!-- Modal content-->
      <div class="modal-content">
         <div class="modal-header">
            <h4 class="modal-title" style="float:left;" id="alertHeader"></h4>
            <i onclick="saveAlertConfig()" class="fas fa-save fa-2x saveIcon"></i>
            <button type="button" class="close" data-dismiss="modal">&times;</button>
         </div>
         <div class="modal-body">
            <div style="display:flex">
               <div>
                  Alert Type <br/>
                  <select id="alertTypeSelect" disabled name="selectStatus">
                  </select>
               </div>
               <div style="margin-left:8px;">Time <i style="cursor:pointer;color:green;" title="Threshold duration before or after which alert would be triggered for a selected event. Define a duration less than 24 hours" class="fas fa-info-circle"></i><br/>
                  <input type="text" placeholder="hh:mm"  onkeypress="return this.value.length >= 2 ? (event.charCode >= 48 && event.charCode <= 58 && this.value.length <5): (event.charCode >= 48 && event.charCode <= 57 && this.value.length < 5)" id="configuredTime"/>
               </div>
               <div style="margin-left:8px;">Distance (km) <i style="cursor:pointer;color:green;" title="Threshold distance from or to a location which would trigger the alert for a selected event" class="fas fa-info-circle"></i><br/>
                  <input type="text" placeholder="0" id="configuredDistance" onkeypress="return (event.charCode == 46 || (event.charCode >= 48 && event.charCode <= 57 && this.value.length < 5))"/>
               </div>
               <div style="margin-left:8px;">Schedule (24 hrs) <i style="cursor:pointer;color:green;" title="Specific hours of day for which the alert has to be generated. Please enter the hours in 24 hour format" class="fas fa-info-circle"></i><br/>
                  <input type="text" placeholder="R1,R2"  onkeypress="return this.value.length >= 2 ?((event.charCode >= 48 && event.charCode <= 57 )||  (event.charCode == 44)):(event.charCode >= 48 && event.charCode <= 57 )" id="configuredRange"/>
               </div>

            </div>
			<div class="card"style="margin-top:8px;padding:8px;"> <div id="editAlertDescription"><strong>Alert Description:</strong> </div>
			      <div id="threshold"><strong>Threshold:</strong> </div>
			</div>

            <div class="headerAlertAdd">
               <div style='min-width:100px;'>Level</div>
               <div style='min-width:130px;margin-left:8px;'>Criteria</div>
               <div style='min-width:130px;margin-left:8px;'>Type Name</div>
               <div style='min-width:130px;margin-left:8px;'>Role Name</div>
               <div style='min-width:90px;margin-left:8px;'>SMS Alert</div>
               <div style='min-width:90px;margin-left:8px;'>Email Alert</div>
			   <div style='min-width:90px;margin-left:8px;'>Dashboard Alert</div>
			   <div style='min-width:90px;margin-left:8px;text-align: center;'>Delete</div>
			   <div style='min-width:90px;margin-left:8px;text-align:right;'><i id="btnAddNewLevel" style="color:#77ea77;font-size:20px;cursor:pointer"  class="fas fa-plus-circle"></i></div>
            </div>
            <div id="levelDiv" style="margin-top:16px;">
            </div>
         </div>
      </div>
   </div>
</div>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
<script type="text/javascript"
   src="https://cdn.datatables.net/1.10.19/js/jquery.dataTables.min.js"></script>
<link rel="stylesheet"
   href="https://cdn.datatables.net/1.10.19/css/jquery.dataTables.min.css">
<link href="https://cdn.datatables.net/1.10.16/css/dataTables.bootstrap.min.css" rel="stylesheet"/>
<link href="https://cdn.datatables.net/fixedcolumns/3.2.3/css/fixedColumns.dataTables.min.css" rel="stylesheet"/>
<link href="https://cdn.datatables.net/select/1.2.3/css/select.dataTables.min.css" rel="stylesheet"/>
<link href="https://cdn.datatables.net/buttons/1.5.0/css/buttons.bootstrap.min.css" rel="stylesheet"/>
<link rel="stylesheet"
   href="https://use.fontawesome.com/releases/v5.6.3/css/solid.css"
   integrity="sha384-+0VIRx+yz1WBcCTXBkVQYIBVNEFH1eP6Zknm16roZCyeNg2maWEpk/l/KsyFKs7G"
   crossorigin="anonymous"/>
<link rel="stylesheet"
   href="https://use.fontawesome.com/releases/v5.6.3/css/fontawesome.css"
   integrity="sha384-jLuaxTTBR42U2qJ/pm4JRouHkEDHkVqH0T1nyQXn1mZ7Snycpf6Rl25VBNthU4z0"
   crossorigin="anonymous"/>
<!-- Latest compiled JavaScript -->
<!-- jQuery library -->
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/js/bootstrap.min.js"></script>
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/css/bootstrap.min.css">
<script src="https://cdnjs.cloudflare.com/ajax/libs/sweetalert/2.1.2/sweetalert.min.js"></script>
<link rel="stylesheet"
  href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-multiselect/0.9.13/css/bootstrap-multiselect.css">
<script
src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-multiselect/0.9.13/js/bootstrap-multiselect.min.js"></script>
<script>
   let alertTable;
   var levelNum = 1;

   let data = [];

   let roles = [];
   let types = [];
   var regex=/^(0[0-9]|1[0-9]|2[0-3]|[0-9]):[0-5][0-9]$/;
   var floatRegex=/^\d+(?:\.\d\d?)?$/;
   var intRegex=/(?<=\s|^)\d+(?=\s|$)/;
  $("#configuredTime").on("blur", function(){
	    if(!regex.test( $("#configuredTime").val()))
	   {
		   sweetAlert("Please enter value in hh:MM format");
		   $("#configuredTime").val("");
	   }
   });

   $("#configuredDistance").on("blur", function(){



	   if(!floatRegex.test( $("#configuredDistance").val()) && !$("#configuredDistance").val() == "" && !intRegex.test( $("#configuredDistance").val()))
	   {
		   sweetAlert("Please enter a decimal value");
		   $("#configuredDistance").val("");
	   }
   });

   $("#configuredRange").on("blur", function(){
	   var arrRange = this.value.split(",");
	   var error = false;
	   var errorNum = false;
	   $.each(arrRange, function(i, item){
		   if(item.length > 2)
		   {
			   error = true;
		   }
		   if(parseInt(item) > 23)
		   {
			   errorNum = true;
		   }
	   })
	   if(error)
	   {
		   sweetAlert("Range should be in format two characters and comma e.g. R1,R2,R3");
		   this.value="";
		   return;
	   }
	   if(errorNum)
	   {
		   sweetAlert("Range values should be less than 24");
		   this.value="";
		   return;
	   }
	   if(this.value[this.value.length -1] == ",")
	   {
		 this.value = this.value.slice(0,-1);
	   }
   });



   function addAlert(){
     $('#alertHeader').html('Add Alert');
     $("#levelDiv").html("");
     levelNum = 1;
   }

   function alertBodyClick(id,icon)
   {
    var td = $(icon).closest('td');
    var tr = $(td).closest('tr');
           var row = alertTable.row( tr );

           if ( row.child.isShown() ) {
               // This row is already open - close it
               row.child.hide();
               tr.removeClass('shown');
           }
           else {
               // Open this row
               row.child( format(id) ).show();
               tr.addClass('shown');
           }
   }


   function editAlert(id,alertId,alertName){
     $('#alertModal').modal('show');
     $('#alertHeader').html('Edit Alert');
     $("#levelDiv").html("");
	 $("#alertTypeSelect").html("");
	 $("#alertTypeSelect").append("<option value='"+alertId+"'>"+alertName+"</option>");
    // $("#alertTypeSelect").val(alertId);
     $("#editAlertDescription").html("<strong>Alert Description: </strong>").append($('option:selected', "#alertTypeSelect").attr('description'));
	   $("#threshold").html("<strong>Threshold: </strong>").append($('option:selected', "#alertTypeSelect").attr('threshold'));
     levelNum = 1;
     console.log("Data",data);
     $.each(
             data,
             function(i, item) {
               if(item.id == id)
               {
                 $("#configuredTime").val(item.configuredTime);
         			   $("#configuredDistance").val(item.configuredDistance);
         			   $("#configuredRange").val(item.configuredRange);
                 console.log("ITEM>", item.alertLevels);
                 let previousLevel=-1;
                 let roleIdArray = [];
                 let typeIdArray = [];
                 $.each(
                         item.alertLevels,
                         function(j, level) {
                           let disabled = "";
						   
                           if(previousLevel != level.levelName){
							   
                             previousLevel = level.levelName;
							 
							 if(levelNum != 1)
							 {
								 $("#tSelect" + (levelNum-1)).val(typeIdArray);
								 $("#lSelect" + (levelNum-1)).val(roleIdArray);								
								 $("#lSelect" + (levelNum-1)).multiselect("refresh");
								 $("#tSelect" + (levelNum-1)).multiselect("refresh");
								 populateLevelTypes(levelNum-1,roleIdArray);
								 roleIdArray = [];
								 typeIdArray = [];
							 }
                           
						   if(j == 0){disabled = "disabled";}
                           let levelDetails = "<div style='display:flex;margin-bottom:8px;' id='lev"+levelNum+"'><div style='min-width:100px;padding-left:4px;'>"+level.levelName+"</div>";
                           levelDetails += "<div style='display:none;'><input type='text'  id='lalertLevelId"+levelNum+"' value='"+level.alertLevelId+"'/></div>";
                           levelDetails += "<div style='min-width:130px;margin-left:8px;'><input style='width:130px;' type='text' "+disabled+" id='lTime"+levelNum+"' value='"+level.configuredTime+"'/></div>";
                           levelDetails += '<div  style="min-width:130px;margin-left:8px;"><select id="tSelect'+levelNum+'" onchange="populateRole('+levelNum+')" name="selectStatus" multiple>';
                           levelDetails += '   <option value="0">Role Based</option>';
                           $.each(types,function(t, type) {
                           	levelDetails += '   <option value="'+type.operationId+'">'+type.typeOfOperation+'</option>';
                           });
                           levelDetails += '</select></div>';
                           levelDetails += '<div  style="min-width:130px;margin-left:8px;"><select id="lSelect'+levelNum+'"  name="selectStatus" multiple>';
                           //levelDetails += '   <option value="0">Select Role Name</option>';
                           $.each(roles,function(r, role) {
                           	levelDetails += '   <option value="'+role.roleId+'">'+role.roleName+'</option>';
                           });
                           levelDetails += '</select></div>';
                           let ischeckedsms = level.sms? "checked" :"";
                           let ischeckedemail = level.email? "checked" :"";
            						   let ischeckedDashboard = level.dashboard? "checked" :"";

            						   levelDetails += "<div style='min-width:90px;margin-left:16px;'><input type='checkbox' "+ ischeckedsms +" id='lSMS"+levelNum+"'/></div>";
            						   levelDetails += "<div style='min-width:90px;margin-left:16px;'><input type='checkbox' "+ ischeckedemail +" id='lEmail"+levelNum+"'/></div>";
            						   levelDetails += "<div style='min-width:90px;margin-left:16px;'><input type='checkbox' "+ ischeckedDashboard +" id='lDashboard"+levelNum+"'/></div>";
            						    if(levelNum != 1)
                        	   {
                        				  levelDetails += '<div style="min-width:90px;margin-left:16px;"><i id="lDelete'+levelNum+'" class="fas fa-trash dispNone" onclick="deleteClick('+levelNum+')"style="color:red;"></i></div>';
                        	   }

            						   levelDetails += '</div>';
                           $("#levelDiv").append(levelDetails);						   
                           $("#tSelect" + levelNum).multiselect({ nonSelectedText: 'Select'});
                           $("#lSelect" + levelNum).multiselect({ nonSelectedText: 'Select' });
                           console.log("level.roleId",level.roleId);
						   levelNum++;
						   }
                           if(previousLevel == level.levelName)
                           {
                             roleIdArray.push(level.roleId);
                             typeIdArray = level.type.split(",");
                           }
                           
                         })
                        
                        $("#tSelect" + (levelNum-1)).val(typeIdArray);
                        $("#lSelect" + (levelNum-1)).val(roleIdArray);
                        $("#lSelect" + (levelNum-1)).multiselect("refresh");
                        $("#tSelect" + (levelNum-1)).multiselect("refresh");
						populateLevelTypes(levelNum-1,roleIdArray);
						$("#lDelete"+(levelNum -1)).removeClass("dispNone");

               }
             }
           );
   }
   
   function populateLevelTypes(lNum, idArray)
   {
	 if(!$("#tSelect"+lNum).val().includes('0'))
     {
	  $.ajax({
             url : '<%= roleModuleAPIurl %>' + 'gethubroles?systemId=<%= systemId %>&customerId='+<%= customeridlogged %>+'&operationId='+$("#tSelect" + lNum).val(),
             method : 'GET',
             contentType: 'application/json',
             success : function(response) {
             let options = "";
             //options += '   <option value="0">Select Role Name</option>';
             $.each(response,function(r, role) {
              options += '   <option value="'+role.roleId+'">'+role.roleName+'</option>';
             });
             $("#lSelect"+lNum).multiselect('destroy');
             $("#lSelect"+lNum).html(options);
             $("#lSelect"+lNum).multiselect({ nonSelectedText: 'Select' });
			 $("#lSelect"+lNum).val(idArray);
	         $("#lSelect"+lNum).multiselect("refresh");
             }
         })
	 }
   }

   function populateRole(level)
   { 
     var getRoleJSON = {
       systemId : '<%= systemId %>' ,
       customerId : '<%= customeridlogged %>',
       userId : '<%= loginUserName %>',
       operationId: $("#tSelect" + level).val()
     }
     if($("#tSelect" + level).val().includes('0'))
     {
       $.ajax({
             url : '<%= roleModuleAPIurl %>' + 'getRolesForUser',
             method : 'GET',
             contentType: 'application/json',
             data : getRoleJSON,//JSON.stringify(getRoleJSON),
             success : function(response) {
             let options = "";
             //options += '   <option value="0">Select Role Name</option>';
             $.each(response,function(r, role) {
              options += '   <option value="'+role.roleId+'">'+role.roleName+'</option>';
             });
             $("#lSelect" + level).multiselect('destroy');
             $("#lSelect" + level).html(options);
              $("#lSelect" + level).multiselect({ nonSelectedText: 'Select' });
             }
         })
     }
     else {
       $.ajax({
             url : '<%= roleModuleAPIurl %>' + 'gethubroles?systemId=<%= systemId %>&customerId='+<%= customeridlogged %>+'&operationId='+$("#tSelect" + level).val(),
             method : 'GET',
             contentType: 'application/json',
             data : getRoleJSON,//JSON.stringify(getRoleJSON),
             success : function(response) {
             let options = "";
             //options += '   <option value="0">Select Role Name</option>';
             $.each(response,function(r, role) {
              options += '   <option value="'+role.roleId+'">'+role.roleName+'</option>';
             });
             $("#lSelect" + level).multiselect('destroy');
             $("#lSelect" + level).html(options);
              $("#lSelect" + level).multiselect({ nonSelectedText: 'Select' });
             }
         })


     }



   }

   function deleteClick(lNum)
   {
	   $("#lev"+(levelNum -1)).remove();
	   levelNum--;

	   $("#lDelete"+(levelNum -1)).removeClass("dispNone");

   }

   /* Formatting function for row details - modify as you need */
   function format ( id ) {
       // `d` is the original data object for the row
       let childTable = "";
       $.each(
             data,
             function(i, item) {
               if(item.id == id)
               {
                 childTable = '<table cellpadding="5" cellspacing="0" border="1" style="margin-left:10%;">'+
   						        '<tr style="background:#dfdfdf;">'+
   						       	    '<td style="display:none;">Id</td>'+
   						            '<td>Level</td>'+
   						            '<td>Time</td>'+
   						            '<td>Role Name</td>'+
   						        '</tr>';

                 $.each(
                         item.alertLevels,
                         function(j, level) {
                childTable +='<tr>'+
               '<td style="display:none;">'+level.alertLevelId+'</td>'+
               '<td>'+level.levelName+'</td>'+
               '<td>'+level.configuredTime+'</td>'+
               '<td>'+level.roleId+'</td>'+
           	 '</tr>';

                         })

                         childTable += "<table>";

               }
             }
           );

       return childTable;
   }

   function loadAlertTable(){

   var list = "";
   var getRoleJSON = {
   systemId : '<%= systemId %>' ,
   customerId : '<%= customeridlogged %>',
   userId : '<%= loginUserName %>'
   }
   $.ajax({
   			url : '<%= roleModuleAPIurl %>' + 'getRolesForUser',
   			method : 'GET',
   			contentType: 'application/json',
   			data : getRoleJSON,
   			success : function(response) {
            roles = response;
   			}
   			})

        $.ajax({
        			url : '<%= roleModuleAPIurl %>' + 'gethierarchylevel',
        			method : 'GET',
        			contentType: 'application/json',
        			data : getRoleJSON,
        			success : function(result) {
						types = result;
						console.log("types",types);
        				$.each(types,function(t, type) {
	     				$("#typeSelect").append('<option value="'+type.operationId+'">'+type.typeOfOperation+'</option>');
	  			});
      
        			}
                      			})

    var getAlertJSON = {
   				systemId : '<%= systemId %>' ,

   		 }
     	$.ajax({
   						url : '<%= roleModuleAPIurl %>' + 'getAlertMasters',
   						method : 'GET',
   						data : getAlertJSON,
   						contentType: 'application/json',
   						success : function(response) {
   						$("#loading-div").hide();

   								list = response;
   								data = response;
								console.log("DATA", data);
   								$('#alertTypeSelect').append(
   										$("<option></option>").attr("value", 0)
   												.text("Select Alert Type"));
   								for (var i = 0; i < list.length; i++) {
   								let threshld = list[i].threshold;
   								threshld = threshld.includes("#time") ? list[i].configuredTime + " (HH:MM)" : threshld;
   								threshld = threshld.includes("#dist") ? list[i].configuredDistance + " KMs" : threshld;
   								threshld = threshld.includes("#t&d") ? list[i].configuredDistance + " KMs ," + list[i].configuredTime + " (HH:MM)" : threshld;
   								threshld = threshld.includes("#range") ? list[i].configuredRange + "Hours" : threshld;
   									$('#alertTypeSelect').append(
   											$("<option></option>").attr(
   													"value", list[i].alertId).text(
   													list[i].displayName).attr("description", list[i].description).attr("threshold", threshld));
   								}
   								//$('#role_modules').select2();
   								//$('#role_modules').val(0).trigger("change");
   							//	console.log("list ::  "+list);


   							$("#alertTable").show();
   							let rows = [];
   						//	console.log("list at table  ::  "+list);
   							$.each(list,function(i, item) {
   						//	console.log("list ::  "+JSON.stringify(item));
							/*				  	"0" : '<i class="fas fa-plus-circle" onclick="alertBodyClick('+item.id+',this)"style="color:green;"></i>',
                               { className: 'dt-center details-control', targets: [0] }*/
                           	let row = {
   									"0" : '<i class="fas fa-pencil-alt fa-1x " style="color:#3F51B5;cursor:pointer" aria-hidden="true" onclick="editAlert('+item.id+','+item.alertId+',\''+item.alertName+'\')" ></i>',
                     				"1" : item.alertName,
   									"2" : item.configuredTime == null ? "": item.configuredTime,
   									"3" : item.configuredDistance == null ? "": item.configuredDistance,
   									"4" : item.configuredRange == null ? "": item.configuredRange,

   												};
   												rows.push(row);
   											})
   							if ($.fn.DataTable.isDataTable("#alertTable")) {
   								$('#alertTable').DataTable().clear()
   										.destroy();
   							}
   							alertTable = $('#alertTable')
   									.DataTable({
   										"scrollY" : "500px",
   										"scrollX" : true,
   										paging : false,
   										 columnDefs: [
   											    { className: 'dt-center', targets: [0,2,3,4] }


   											  ],
   										"oLanguage" : {
   											"sEmptyTable" : "No data available"
   										}
   									});

   							alertTable.rows.add(rows).draw();
                 $("#alertTable_filter").append('<button type="button" onclick="addAlert()" class="btn btn-info btn-lg" style="margin:16px;display:none;" data-toggle="modal" data-target="#alertModal">Add New</button>')
   	}

             });
   }

   function validateregex(val, lNum){
	   if(!regex.test(val)){
		   sweetAlert('Please enter value in hh:MM format')
		   $("#lTime"+lNum).val("");}
   }

   $(document).ready(function() {

   loadAlertTable();

     $("#btnAddNewLevel").on("click", function(){

	   let disabled = "";
	   levelNum == 1? disabled = "disabled": "";
       let levelDetails = "<div style='display:flex;margin-bottom:8px;' id='lev"+levelNum+"'><div style='min-width:100px;padding-left:4px;'>"+levelNum+"</div>";
       levelDetails += "<div style='display:none;'><input type='text'  id='lalertLevelId"+levelNum+"' value=''/></div>";
       levelDetails += "<div style='margin-left:8px;'><input style='width:130px;' type='text' "+disabled+" id='lTime"+levelNum+"' onblur='validateregex(this.value,"+levelNum+")' onkeypress='return this.value.length >= 2 ? (event.charCode >= 48 && event.charCode <= 58 && this.value.length <5): (event.charCode >= 48 && event.charCode <= 57 && this.value.length < 5)'/></div>";
       levelDetails += '<div  style="min-width:130px;margin-left:8px;"><select id="tSelect'+levelNum+'" onchange="populateRole('+levelNum+')"   name="selectStatus" multiple>';
       levelDetails += '   <option value="0">Role Based</option>';
       $.each(types,function(t, type) {
        levelDetails += '   <option value="'+type.operationId+'">'+type.typeOfOperation+'</option>';
       });
       levelDetails += '</select></div>';
       levelDetails += '<div  style="min-width:130px;margin-left:8px;"><select id="lSelect'+levelNum+'" name="selectStatus" multiple>';
       //levelDetails += '   <option value="0">Select Role Name</option>';
       $.each(roles,function(r, role) {
           levelDetails += '   <option value="'+role.roleId+'">'+role.roleName+'</option>';
       });
       levelDetails += '</select></div>';
	   levelDetails += "<div style='min-width:100px;margin-left:16px;'><input type='checkbox' id='lSMS"+levelNum+"'/></div>";
	   levelDetails += "<div style='min-width:100px;margin-left:8px;'><input type='checkbox' id='lEmail"+levelNum+"'/></div>";
	   levelDetails += "<div style='min-width:100px;margin-left:8px;'><input type='checkbox' id='lDashboard"+levelNum+"'/></div>";
	   if(levelNum != 1)
	   {
       levelDetails += '<div style="min-width:100px;margin-left:8px;"><i id="lDelete'+levelNum+'" class="fas fa-trash dispNone" onclick="deleteClick('+levelNum+')"style="color:red;"></i></div>';
	   }
	   levelDetails += '</div>';
       $("#levelDiv").append(levelDetails);
       $("#tSelect" + levelNum).multiselect({ nonSelectedText: 'Select' });
       $("#lSelect" + levelNum).multiselect({ nonSelectedText: 'Select' });
       levelNum++;

	   $("#lDelete"+(levelNum -1)).removeClass("dispNone");
		if(levelNum-1 != 1) {$("#lDelete"+(levelNum -2)).addClass("dispNone")};
     })

       // Add event listener for opening and closing details
       $('#alertTable tbody').on('click', 'table tr td.details-control', function () {
     //  alert(1);
           var tr = $(this).closest('tr');
           var row = alertTable.row( tr );

           if ( row.child.isShown() ) {
               // This row is already open - close it
               row.child.hide();
               tr.removeClass('shown');
           }
           else {
               // Open this row
               row.child( format(row.data()) ).show();
               tr.addClass('shown');
           }
       } );
   } );

   function saveAlertConfig(){
   		 let saveAlertJSON = {
   		   systemId : '<%= systemId %>' ,
   		   userId : '<%= loginUserName %>',
   		   alertId: $("#alertTypeSelect").val(),
   		   configuredTime: $("#configuredTime").val(),
   		   configuredDistance: $("#configuredDistance").val(),
   		   configuredRange: $("#configuredRange").val(),
   		   alertLevels: [
   		   ]
   		 };
   		 let alertLevels = [];
   		 for(var num = 1; num < levelNum;num++)
   		 {

			 if($("#lSelect" + num).val() == "0")
			 {
				 sweetAlert("Please Select a Role");
				 return;
			 }


         let rArray = $("#lSelect" + num).val();
         for(var r = 0; r < rArray.length;r++)
     		 {
     		   let al = {
     		   	 alertLevelId : $("#lalertLevelId" + num).val(),
     		     alertId: $("#alertTypeSelect").val(),
     		     levelName: num,
     		     configuredTime: $("#lTime" + num).val(),
      			 sms: $("#lSMS" + num).is(":checked")? true : false,
      			 email: $("#lEmail" + num).is(":checked")? true : false,
             type: $("#tSelect" + num).val().join(),
     		     roleId: rArray[r],
				 systemId : '<%= systemId %>' 
     		   }
     		   alertLevels.push(al);
         }
   		 }
   		 saveAlertJSON.alertLevels = alertLevels;
   		console.log("save JSON", saveAlertJSON);

   		 $("#loading-div").show();
   		 $.ajax({
   						url :  '<%= roleModuleAPIurl %>' + 'updateAlertMaster',
   						method : 'POST',
   						contentType : "application/json",
   						data : JSON.stringify(saveAlertJSON),
   						success : function(response) {
   						loadAlertTable();
   						$('#alertModal').modal('hide');
   						}
   						});

   }

</script>
<jsp:include page="../Common/footer.jsp" />
