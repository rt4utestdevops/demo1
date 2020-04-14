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
   System.out.println(" Lang ::"+language);
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
   %>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
<meta http-equiv="x-ua-compatible" content="ie=edge">
<!-- Font Awesome -->
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css">
<link rel="stylesheet" href="https://cdn.datatables.net/1.10.19/css/jquery.dataTables.min.css">
<!-- Bootstrap core CSS -->
<link href="../../Main/roleResources/css/bootstrap.min.css" rel="stylesheet">
<!-- Material Design Bootstrap -->
<link href="../../Main/roleResources/css/mdb.min.css" rel="stylesheet">
<!-- Your custom styles (optional) -->
<link href="../../Main/roleResources/css/style.min.css"  rel="stylesheet">
<link href="../../Main/roleResources/css/mainstyle.css"  rel="stylesheet">
<script src="https://cdnjs.cloudflare.com/ajax/libs/sweetalert/2.1.2/sweetalert.min.js"></script>
<script src="../../Main/roleResources/js/jquery-3.3.1.min.js"></script>
<link href="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.6-rc.0/css/select2.min.css" rel="stylesheet" />
<script src="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.6-rc.0/js/select2.min.js"></script>
<script src="../../Main/roleResources/js/addons/datatables.js"></script>
<script src="../../Main/roleResources/js/addons/datatables.min.js"></script>
<script src="../../Main/roleResources/js/common.js"></script>
<script src="../../Main/roleResources/js/bootstrap.min.js"></script>
<link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.7.2/css/all.css" integrity="sha384-fnmOCqbTlWIlj8LyTjo7mOUStjsKC4pOpQbqyi7RrhN7udi9RwhKkMHpvLbHG9Sr" crossorigin="anonymous">
<style>
   .flex-container {
   display: flex;
   flex-wrap: nowrap;
   width: 100%;
   }
   .flex-container>div {
   width: 20%;
   margin: 8px;
   text-align: center;
   line-height: 32px;
   }
   .flex-container div:first-child {
   text-align: left;
   }
   .center-view{
   top:40%;
   left:50%;
   position:fixed;
   height:200px;
   width:200px;
   z-index:1000;
   }
   
   .datatables_filter{margin-top:-24px;
   }
   .datatables_filter label{display:flex;}
</style>
<!-- Editable table -->
<h5 class="card-header text-left font-weight-bold text-uppercase py-4"
   style="height: 20px; line-height: 0px;">
   Role Master <span class="table-add float-right mb-3 mr-2"
      style="margin-top: -20px;"><a href="#!" class="blue.lighten-5"><i
      class="fa fa-plus fa-2x-custom" id="addRolePlus" aria-hidden="true" 
      onclick="modalAddRole('Add Role', '','add')"></i></a></span>
</h5>
<div class="center-view"  id="loading-div" style="display:none">
   <img src="../../Main/images/loading.gif" alt="">
</div>
<div class="modal fade" id="roleModalForm" role="dialog"
   aria-labelledby="myModalLabel" aria-hidden="true" data-backdrop="static" 	data-keyboard="false">
   <div class="modal-dialog" role="document">
      <!--Content-->
      <div class="modal-content form-elegant">
         <!--Header-->
         <div class="modal-header text-center">
            <h3 class="modal-title w-100 dark-grey-text font-weight-bold my-3">
               <strong id="roleModalTitle"></strong>
            </h3>
            <i class="fa fa-save fa-2x saveModal" aria-hidden="true"
               onclick="saveRole()"></i> <i class="fa fa-close fa-2x closeModal" onclick="populateExistingRoles();$('#module_container').html('');$('#roleModuleHeader').hide()"
               aria-hidden="true" data-dismiss="modal"></i>
         </div>
         <!--Body-->
         <div class="modal-body mx-4">
            <!--Body-->
            <div id="rowAddServiceOnEdit"
               style="padding: 8px 16px; margin-bottom: 8px;">
               <div class="row" style="margin-bottom: 24px;">
                  <div class="col-lg-10">
                     <select id="role_modules_onedit" name="role_modules">
                     </select>
                  </div>
                  <div class="col-lg-2 text-right">
                     <button class="btn btn-blue"
                        style="padding: 0.4rem; border-radius: 4px;"
                        id="btnRoleAddOnEditModule">Add</button>
                  </div>
                  <div class="col-sm-12 col-md-12 col-lg-12" style="margin-top:8px;" id="divIncomingRoles">
                  </div>
               </div>
            </div>
            <!--Card-->
            <div id="cardAddRole">
               <!--Card content-->
               <div class="card-body" style="padding: 1rem 2rem;">
                  <!-- Form -->
                  <form name="">
                     <!-- Heading -->
    <div class = "md-form" >
		<label style = "margin-left: 120px;" >
					<input type = "radio" id = "tripRadio" value = "trip" style = "opacity:1 !important" name = "optradio">&nbsp;&nbsp;&nbsp; <span id = "tripWise"
						style = "font-size: 12px;"> By Trip Based Region </span>
		</label> 
	   <label style = "margin-left: 20px;">
					<input type = "radio" id = "nameRadio" value = "name" style = "opacity:1 !important" name = "optradio" checked >&nbsp;&nbsp;&nbsp; <span id = "nameWise"style = "font-size: 12px;" > By Name </span> 
		</label > 
	</div> 
	</br > </br>
<div class = "row" style = "margin-bottom: 50px;display:none;margin-top: 20px" id = "divRegion">
    <div class = "col-lg-10">
    <select id = "tripBasedRegion" name = "tripBasedRegion" onchange = "checkDupicateRoleName()">
    </select> </div > </div> 
	<div class = "md-form" style = "margin-bottom: 8px;" id = "roleNameDiv" >
    <input type = "text" id = "roleName" class = "form-control validate" onchange = "checkDupicateRoleName()">
    <label for = "roleName" style = "margin-top: 1px !important;" class = "active" id = "roleName_lbl" data-error = "required" > Role
Name <span class = "required"> * </span> </label > </div> 
<!-- < div style = "margin-top:2rem;font-weight:bold;" > Add Modules < /div> <hr style = "margin-top:0.15rem;" > -->
    <div class = "row" style = "margin-bottom: 24px;" >
    <div class = "col-lg-10" >
    <select id = "role_modules" name = "role_modules" >
    </select> </div> <div class = "col-lg-2 text-right" >
    <button class = "btn btn-blue" style = "padding: 0.4rem; border-radius: 4px;" id = "btnRoleAddModule" > Add </button> </div > </div> 
					<div class="flex-container" id="roleModuleHeader"
                        style="display: none;">
                        <div class="modWidth"></div>
                        <div class="form-check">View</div>
                        <div class="form-check">Add</div>
                        <div class="form-check">Edit</div>
                        <div class="form-check">Delete</div>
                        <div></div>
                     </div>
                     <div id="module_container"></div>
                  </form>
                  <!-- Form -->
               </div>
            </div>
            <!--/.Card-->
         </div>
         <!--Footer-->
      </div>
      <!--/.Content-->
   </div>
</div>
<div class="col-lg-12" style="margin-top: 16px;">
   <div class= "col-lg-3">
      <select class="form-control" id="customerCombo" ></select>
   </div>
</div>
<div class="col-lg-12" style="margin-top: 16px;">
   <div class="table-editable">
      <table id="roleMaster" class="display nowrap" style="width: 100%">
         <thead>
            <tr>
               <th>Action</th>
               <th>Role Name</th>
               <th>Created by</th>
               <th>Created date</th>
               <th>Updated by</th>
               <th>Updated date</th>
            </tr>
         </thead>
      </table>
   </div>
</div>
<!-- Editable table -->
<script>
   let roleTabName = "role-tab-md";
   let noOfModules = 0;
   let currentEditCardNo = 0;
   let editRoleId = 0;

function modalAddRole(title, id, mode) {

    var custId1 = $("#customerCombo").val();
    //alert(" custComboId :: "+custComboId);
    if (custId1 == 999999) {
        sweetAlert("Please Select Customer");
        return;
    }

    $("#roleModalForm").modal("show");
    $("#rowAddServiceOnEdit").addClass('dispNone');
    $("#cardAddRole").removeClass('dispNone');
    $("#roleModalTitle").html(title);
    $("#roleName").val("");
    $('#module_container').html('');
    $('#roleModuleHeader').hide();

}

$(document).on('click', '#' + roleTabName, function() {
    $("#" + roleTabName).data('add') == "Y" ? "" : $("#addRolePlus").addClass("dispNone");

    $("#loader").addClass("active");
    setTimeout(function() {
        populateExistingRoles()
    }, 500);

});

$(document).ready(

    function() {
        //		var getRoleJSON = {
        //		systemId : '<%= systemId %>' ,
        //		customerId : '<%= customeridlogged %>',
        //		userId : '<%= userId %>'
        //		}

        var customeridloggedIn = '<%= customeridlogged %>';
        //alert(" customeridloggedIn ::"+customeridloggedIn);
        $.ajax({
            url: '<%=request.getContextPath()%>/CommonAction.do?param=getCustomer&getCustomer&paramforltsp=yes',
            //	method : 'GET',
            contentType: 'application/json',

            success: function(response) {
                var custList = JSON.parse(response);
                //	alert(" cust list :: "+custList);
                if (customeridloggedIn == 0) {
                    $('#customerCombo').append(
                        $("<option></option>").attr("value", 999999)
                        .text("Select Customer "));
                }

                for (var i = 0; i < custList['CustomerRoot'].length; i++) {
                    $('#customerCombo').append(
                        $("<option></option>").attr(
                            "value", custList['CustomerRoot'][i].CustId).text(
                            custList['CustomerRoot'][i].CustName));

                }
                //alert(""+custList['CustomerRoot'][0].CustId);
                $('#customerCombo').val(custList['CustomerRoot'][0].CustId).trigger('change');

            }
        });

        populateExistingRoles();

    });
$('#customerCombo').on("change", function() {
    getMenus();
    populateExistingRoles();

});

function getMenus() {
    $("#loading-div").show();
    var custId = $("#customerCombo").val();
    $("#role_modules").empty().select2({
        dropDownParent: $("#roleModalForm")
    });
    $("#role_modules_onedit").empty().select2({
        dropDownParent: $("#roleModalForm")
    });
    var getMenusByProcessIdJSON = {
        systemId: '<%= systemId %>',
        customerId: $("#customerCombo").val(),
        language: '<%= language %>'

    }
    $.ajax({
        //url : 'http://localhost:9007/getMenus',
        url: '<%= roleModuleAPIurl %>' + 'getAllMenusByProcessId',
        method: 'GET',
        contentType: 'application/json',
        data: getMenusByProcessIdJSON,
        //"crossDomain": true,
        success: function(response) {
            //console.log(response);
            $("#loading-div").hide();
            list = response;
            $('#role_modules').append(
                $("<option></option>").attr("value", 0)
                .text("Select Module"));
            for (var i = 0; i < list.length; i++) {

                $('#role_modules').append(
                    $("<option></option>").attr(
                        "value", list[i].menuId).text(
                        list[i].langMenuName));
            }
            $('#role_modules').select2({
                dropDownParent: $("#roleModalForm")
            });
            $('#role_modules').val(0).trigger("change");

            //role_modules_onedit
            $('#role_modules_onedit').append(
                $("<option></option>").attr("value", 0)
                .text("Select Module Type"));
            for (var i = 0; i < list.length; i++) {
                $('#role_modules_onedit').append(
                    $("<option></option>").attr(
                        "value", list[i].menuId).text(
                        list[i].langMenuName));
            }
            $('#role_modules_onedit').select2({
                dropDownParent: $("#roleModalForm")
            });
            $('#role_modules_onedit').val(0).trigger("change");
        }
    });
}

function populateExistingRoles() {
    var getRoleJSON = {
        systemId: '<%= systemId %>',
        customerId: $("#customerCombo").val(),
        userId: '<%= loginUserName %>',
        language: '<%= language %>'
    }
    $.ajax({
        url: '<%= roleModuleAPIurl %>' + 'getRoles',
        method: 'GET',
        contentType: 'application/json',
        data: getRoleJSON, //JSON.stringify(getRoleJSON),
        //"crossDomain": true,
        success: function(response) {
            $("#loader").removeClass("active");
            // console.log("Roles", response)
            incomingRoles = response;
            let rows = [];
            $.each(
                response,
                function(i, item) {
                    let actDeactStatus = (item.status != null && item.status
                            .toUpperCase() == "ACTIVE") ? "activate" :
                        "activate";
                    let colorStatus = (item.status != null && item.status
                            .toUpperCase() == "ACTIVE") ? "colorStatusActive" :
                        "colorStatusActive";
                    let displayStatus = (item.status != null && item.status
                            .toUpperCase() == "ACTIVE") ? "" :
                        "";
                    //	console.log(colorStatus + displayStatus);
                    let showEdit = $("#" + roleTabName).data('edit') == "Y" ? "" : "";
                    let showDelete = $("#" + roleTabName).data('delete') == "Y" ? "" : "";
                    //	console.log("showEdit :: " + showEdit);
                    //	console.log("showDelete :: " + showDelete);
					let isAdmin = false;
					<%
						if(userAuthority.equalsIgnoreCase("Admin"))
						{%> 
						  isAdmin = true;
					<% }%>
							  
					let  disable = (!isAdmin && (item.roleName =='Admin'))? 'dispNone': "";
                    let row = {
                        "0": '<i class="fas fa-pencil-alt fa-2x-custom '+disable +
                            showEdit + " " +
                            displayStatus +
                            '" title="Edit" style="color:#3F51B5;cursor:pointer" aria-hidden="true" onclick="editRole(' +
                            item.roleId + ',' + i + ',\'' + item.roleName + '\'' +
                            ')"></i>',
                        //<i class="fa fa-ban fa-2x-custom '
                        //+ showDelete + " "
                        //+ colorStatus
                        //+ '" title="'
                        //+ actDeactStatus
                        //+ '" aria-hidden="true" onclick="activateDeactivate(\''
                        //+ actDeactStatus
                        //+ '\', '
                        ///+ item.roleId
                        //+ ', \'bay\', \'Bay\')"></i>',
                        "1": item.roleName,
                        "2": item.createdBy,
                        "3": (item.createdDate != null) ? formateDate(item.createdDate) : "",
                        "4": item.updatedBy,
                        "5": (item.updatedDate != null) ? formateDate(item.updatedDate) : ""

                    };
                    rows.push(row);
                })
            if ($.fn.DataTable.isDataTable("#roleMaster")) {
                $('#roleMaster').DataTable().clear().destroy();
            }
            tableRoleMaster = $('#roleMaster').DataTable({
                "scrollY": "300px",
                "scrollX": true,
                paging: false,
                "oLanguage": {
                    "sEmptyTable": "No data available"
                },
                columnDefs: [{
                        className: 'dt-center',
                        targets: [0]
                    }

                ],
                dom: 'Bfrtip',
                buttons: [{
                    extend: 'excelHtml5',
                    title: 'bay',
                    footer: true
                }]
            });
            tableRoleMaster.rows.add(rows).draw();

        }
    });
}

$("#btnRoleAddOnEditModule").on("click", function() {

    if ($("#role_modules_onedit").val() == 0) {
        sweetAlert("Please choose a module");
        return false;
    }

    if (document.getElementById("f" + currentEditCardNo + $("#role_modules_onedit").select2('data')[0].text.split(" ").join("").split("/").join(""))) {
        if ($("#f" + currentEditCardNo + $("#role_modules_onedit").select2('data')[0].text.split(" ").join("").split("/").join("")).hasClass("dispNone")) {
            $("#f" + currentEditCardNo + $("#role_modules_onedit").select2('data')[0].text.split(" ").join("").split("/").join("")).removeClass("dispNone")
        } else {
            sweetAlert("You have already added this module");

        }
        return false;
    }

    let inRoleServiceName = $("#role_modules_onedit").select2('data')[0].text;
    let inRoleServiceId = $("#role_modules_onedit").val();
    //console.log(" UPON EDITING :: "+ inRoleServiceId);
    let inRole = "";
    inRole += '<div class="flex-container" id="f' + currentEditCardNo + inRoleServiceName.split(" ").join("").split("/").join("") + '" data-role-service-name="' + inRoleServiceName + '"  data-role-service-entity-id="' + inRoleServiceId + '"><div class="modWidth">' + inRoleServiceName + '</div><div class="form-check">';
    inRole += '<input type="checkbox" class="form-check-input"   id="' + inRoleServiceName + currentEditCardNo + 'View"> <label for="' + inRoleServiceName + currentEditCardNo + 'View"></label>';
    inRole += '</div><div class="form-check">';
    inRole += '<input type="checkbox" class="form-check-input"   id="' + inRoleServiceName + currentEditCardNo + 'Add"><label for="' + inRoleServiceName + currentEditCardNo + 'Add"></label>';
    inRole += '</div><div class="form-check">';
    inRole += '<input type="checkbox" class="form-check-input"   id="' + inRoleServiceName + currentEditCardNo + 'Edit"> <label for="' + inRoleServiceName + currentEditCardNo + 'Edit"></label>';
    inRole += '</div><div class="form-check">';
    inRole += '<input type="checkbox" class="form-check-input"   id="' + inRoleServiceName + currentEditCardNo + 'Delete"><label for="' + inRoleServiceName + currentEditCardNo + 'Delete"></label>';
    inRole += '</div><div><i class="fa fa-trash required" style="cursor:pointer" onclick="deleteModuleFromEditRole(\'f' + currentEditCardNo + inRoleServiceName.split(" ").join("").split("/").join("") + '\')"></i></div></div>';
    //console.log(" in role :: "+inRole);
    $("#flexCollapse" + currentEditCardNo).append(inRole);
	
	$('#role_modules_onedit').val(0).trigger('change');

})

$("#btnRoleAddModule")
    .on(
        "click",
        function() {
            if ($("#role_modules").val() == 0) {
                sweetAlert("Please choose a module");
                return false;
            } else {
                let moduleExists = false;
                for (var index = 0; index < noOfModules; index++) {
                    if (!$("#f" + index).hasClass("dispNone")) {
                        if ($("#module" + index).html() == $("#role_modules").select2('data')[0].text) {
                            moduleExists = true
                        }
                    }
                }
                if (moduleExists) {
                    sweetAlert("You have already added this module");
                    return false;
                }
                if (noOfModules == 0) {
                    $("#roleModuleHeader").show();
                }

                let newModule = '<div class="flex-container" id="f' + noOfModules + '"><div class="modWidth" id="module' + noOfModules + '">' +
                    $("#role_modules").select2('data')[0].text +
                    '</div><div class="form-check">';
                newModule += '<input type="hidden"  value=' + $("#role_modules").select2('data')[0].id + ' id="m' + noOfModules + 'ServiceId">';
                newModule += '<input type="checkbox" class="form-check-input" id="m' + noOfModules + 'View"  > <label for="m' + noOfModules + 'View"></label>';
                newModule += '</div><div class="form-check"><input type="checkbox" class="form-check-input" id="m' + noOfModules + 'Add"  >';
                newModule += '<label for="m' + noOfModules + 'Add"></label></div>';
                newModule += '<div class="form-check"><input type="checkbox" class="form-check-input" id="m' + noOfModules + 'Edit"  >';
                newModule += '<label for="m' + noOfModules + 'Edit"></label></div>';
                newModule += '<div class="form-check"><input type="checkbox" class="form-check-input" id="m' + noOfModules + 'Delete"  >';
                newModule += '<label for="m' + noOfModules + 'Delete"></label></div>';
                newModule += '<div><i class="fa fa-trash required" style="cursor:pointer" onclick="deleteModuleFromAddRole(\'f' + noOfModules + '\')"></i></div></div>';
                //console.log(" newModule :: "+newModule);
                $("#module_container").append(newModule);
                $("#role_modules").val(0).trigger("change");
                noOfModules++;
                return false;
            }
        })

function deleteModuleFromAddRole(id) {
    $("#" + id).addClass("dispNone");

}

function deleteModuleFromEditRole(id) {
    $("#" + id).addClass("dispNone");
}

function saveRole() {

    var custComboId = $("#customerCombo").val();
    //alert(" custComboId :: "+custComboId);
    if (custComboId == 999999) {
        sweetAlert("Please Select Customer");
        return;
    }

    if ($("#rowAddServiceOnEdit").hasClass("dispNone")) {
        // console.log("create :::  ");
        let formValid = true;

        // if ($("#roleName").val() == "" || $("#roleName").val().trim() == "") {
        // $("#roleName").addClass("invalid");
        // $("#roleName_lbl").addClass("active");
        // formValid = false;
        // }
        // else{
        // $("#roleName").removeClass("invalid");

        // }

        if (!formValid) {
            return false;
        }
        let roleNameSelected = "";
		let roleType = "";
        if ($("#tripRadio").is(":checked")) {
			
            if ($("#tripBasedRegion option:selected").text() == "" || $("#tripBasedRegion option:selected").text().trim() == "" || $("#tripBasedRegion option:selected").val() == 0) {
                sweetAlert("Please select a region");
                return;
            } else {
                $("#roleName").removeClass("invalid");
                roleNameSelected = $("#tripBasedRegion option:selected").text();
				roleType = $("#tripBasedRegion option:selected").val();
            }
        } else if ($("#nameRadio").is(":checked")) {
			
            if ($("#roleName").val() == "" || $("#roleName").val().trim() == "") {
                $("#roleName").addClass("invalid");
                $("#roleName_lbl").addClass("active");
                return;
            } else {
                $("#roleName").removeClass("invalid");
                roleNameSelected = $("#roleName").val();
				roleType = "0";
            }
        }

        //alert(roleNameSelected);
        let saveRoleJSON = {
            roleName: roleNameSelected,
            systemId: '<%= systemId %>',
            customerId: $("#customerCombo").val(),
            userId: '<%= loginUserName %>',
            roleMenus: [],
			roleType : roleType
        };

        let roleServiceArray = [];

        for (var index = 0; index < noOfModules; index++) {
            if (!$("#f" + index).hasClass("dispNone")) {
                let rs = {
                    roleServiceName: $("#module" + index).html(),
                    "menuId": $("#m" + index + "ServiceId").val(),
                    "permissionView": $("#m" + index + "View").is(':checked') ? "Y" : "N",
                    "permissionAdd": $("#m" + index + "Add").is(':checked') ? "Y" : "N",
                    "permissionUpdate": $("#m" + index + "Edit").is(':checked') ? "Y" : "N",
                    "permissionDelete": $("#m" + index + "Delete").is(':checked') ? "Y" : "N"
                };
                roleServiceArray.push(rs);
            }

        }

        if (roleServiceArray.length == 0) {
            sweetAlert("Please select Atleast one module");
            return;
        }
        saveRoleJSON.roleMenus = roleServiceArray;

        // console.log("Save Role JSON",saveRoleJSON);

        //ajax for save role
        $.ajax({
            url: '<%= roleModuleAPIurl %>' + 'createRole',
            method: 'POST',
            contentType: "application/json",
            data: JSON.stringify(saveRoleJSON),
            // dataType: 'jsonp',
            success: function(result) {
                if (result == "Success") {
                    sweetAlert("Role Added");
                } else if (result == "Failure") {
                    sweetAlert("Error");
                }
                populateExistingRoles();
            }
        })
    } else {
        //Save functionality
        // console.log("update  :::  ");
        let editRoleJSON = {
            //roleName : roleName,
            roleId: editRoleId,
            systemId: '<%= systemId %>',
            customerId: $("#customerCombo").val(),
            userId: '<%= loginUserName %>',
            roleMenus: []
        };

        let roleServiceArray = [];
        let flexCount = -1;

        $('#collapse' + currentEditCardNo).find('.flex-container').each(function() {
            if (flexCount != -1) {
                if (!$(this).hasClass("dispNone")) {
                    let rsName = $(this).data('role-service-name').split(" ").join("").split("/").join("");
                    //  console.log(" role service name :: "+rsName);
                    //  console.log("  AAAAAAAA :: "+$("#" + rsName + currentEditCardNo + "View").is(':checked'));
                    let rs = {
                        roleId: editRoleId,
                        roleMenuId: $(this).data('role-service-id'),
                        menuId: $(this).data('role-service-entity-id'),
                        "permissionView": $("#" + rsName + currentEditCardNo + "View").is(':checked') ? "Y" : "N",
                        "permissionAdd": $("#" + rsName + currentEditCardNo + "Add").is(':checked') ? "Y" : "N",
                        "permissionUpdate": $("#" + rsName + currentEditCardNo + "Edit").is(':checked') ? "Y" : "N",
                        "permissionDelete": $("#" + rsName + currentEditCardNo + "Delete").is(':checked') ? "Y" : "N",
                        status: "Active"
                    };
                    roleServiceArray.push(rs);
                }

            }
            flexCount++;

        });
        if (roleServiceArray.length == 0) {
            sweetAlert("Please select Atleast one module");
            return;
        }
        editRoleJSON.roleMenus = roleServiceArray;
        console.log(JSON.stringify(" edit :: "+JSON.stringify(editRoleJSON)));
        $.ajax({
            url: '<%= roleModuleAPIurl %>' + 'updateRole',
            method: 'POST',
            contentType: "application/json",
            data: JSON.stringify(editRoleJSON),
            // dataType: 'jsonp',
            success: function(result) {
                if (result == "Success") {
                    sweetAlert("Role Edited");
                } else {
                    sweetAlert("Error");
                }
                populateExistingRoles();
            }
        })

    }
    $('#module_container').html('');
    $('#roleModuleHeader').hide();
    noOfModules = 0;
    $("#roleModalForm").modal("hide");
}

function deleteRole(id) {

}

function editRole(id, divNum, roleName) {

    $("#role_modules_onedit").val("0").trigger("change");

    var custId2 = $("#customerCombo").val();
    //alert(" custComboId :: "+custComboId);
    if (custId2 == 999999) {
        sweetAlert("Please Select Customer");
        return;
    }
    $("#roleModalTitle").html("Edit Role");
    currentEditCardNo = divNum;
    editRoleId = id;
    /// console.log("diksjdhfskjdfh", divNum)

    $("#divIncomingRoles").html("")

    $.each(incomingRoles,
            function(i, item) {

                if (i == divNum) {
                    let inRole = '<div id="panel' + i + '" class="panel-group card" style="margin-bottom: 8px;">';
                    inRole += '<div class="panel panel-default" style="padding: 8px 8px 4px 16px;"><div class="panel-heading">';
                    inRole += '<h6 class="panel-title" style="font-weight: bold; font-size: 18px;">' +
                        item.roleName;
                    inRole += '</h6></div>';
                    inRole += '<div id="collapse' + i + '"><div id="flexCollapse' + i + '" style="padding-bottom: 16px;">';
                    inRole += '<div class="flex-container"><div class="modWidth"></div><div class="form-check">View</div><div class="form-check">Add</div><div class="form-check">Edit</div><div class="form-check">Delete</div><div></div></div>';

                    //Display modules for each role
                    $.each(item.roleMenus, function(j, module) {
                        if (module.status == "Active") {
                            inRole += '<div class="flex-container" id="f' + i + module.menuEntity.langMenuName.split(" ").join("").split("/").join("") + '" data-role-service-name="' + module.menuEntity.menuLabelId + '" data-role-service-id="' + module.roleMenuId + '" data-role-service-entity-id="' + module.menuEntity.menuId + '"><div class="modWidth">' + module.menuEntity.langMenuName + '</div><div class="form-check">';
                            let viewChecked = module.permissionView == 'Y' ? "checked" : "";
                            inRole += '<input type="checkbox" class="form-check-input"  id="' + module.menuEntity.menuLabelId + i + 'View" ' + viewChecked + ' > <label for="' + module.menuEntity.menuLabelId + i + 'View"></label>';
                            inRole += '</div><div class="form-check">';
                            let addChecked = module.permissionAdd == 'Y' ? "checked" : "";
                            inRole += '<input type="checkbox" class="form-check-input" id="' + module.menuEntity.menuLabelId + i + 'Add" ' + addChecked + '  ><label for="' + module.menuEntity.menuLabelId + i + 'Add"></label>';
                            inRole += '</div><div class="form-check">';
                            let editChecked = module.permissionUpdate == 'Y' ? "checked" : "";
                            inRole += '<input type="checkbox" class="form-check-input" id="' + module.menuEntity.menuLabelId + i + 'Edit" ' + editChecked + '  > <label for="' + module.menuEntity.menuLabelId + i + 'Edit"></label>';
                            inRole += '</div><div class="form-check">';
                            let deleteChecked = module.permissionDelete == 'Y' ? "checked" : "";
                            inRole += '<input type="checkbox" class="form-check-input" id="' + module.menuEntity.menuLabelId + i + 'Delete" ' + deleteChecked + '  ><label for="' + module.menuEntity.menuLabelId + i + 'Delete"></label>';
                            inRole += '</div><div><i class="fa fa-trash required dispNone" style="cursor:pointer" onclick="deleteModuleFromEditRole(\'f' + i + module.menuEntity.langMenuName.split(" ").join("").split("/").join("") + '\')"></i></div></div>';
                        }

                    })

                    inRole += '</div></div></div></div>';

                    $("#divIncomingRoles").append(inRole);
                }
            })

    $("#roleModalForm").modal("show");
    $("#rowAddServiceOnEdit").removeClass('dispNone');
    $("#cardAddRole").addClass('dispNone');

    //$('#collapse'+divNum).find('input').removeAttr('disabled');
    $('#collapse' + divNum).find('.fa-trash').removeClass('dispNone');
    $("#rowAddServiceOnEdit").removeClass('dispNone');
    $("#cardAddRole").addClass('dispNone');
    $("#edit" + divNum).removeClass("fa-pencil-alt");
    $("#edit" + divNum).addClass("fa-save");

}

function activateDeactivate(status, id, bay, bay) {

    let deleteRoleJSON = {
        systemId: '<%= systemId %>',
        customerId: '<%= customeridlogged %>',
        userId: '<%= loginUserName %>',
        roleId: id
    };

    //	console.log(" ASDF :: "+JSON.stringify(deleteRoleJSON));
    $.ajax({
        url: '<%= roleModuleAPIurl %>' + 'deleteRole',
        method: 'GET',
        contentType: "application/json",
        data: deleteRoleJSON,
        // dataType: 'jsonp',
        success: function(result) {
            if (result == "Success") {
                sweetAlert("Role Deleted");
            } else if (result == "Failure") {
                sweetAlert("Error");
            }
            populateExistingRoles();
        }
    })

}

function checkDupicateRoleName() {
   
    //tripBasedRegion
    var selectedRoleName = "";

    if ($("#tripRadio").is(":checked")) {

        if ($("#tripBasedRegion option:selected").text() == "" || $("#tripBasedRegion option:selected").text().trim() == "") {
            $("#tripBasedRegion").addClass("invalid");
            $("#tripBasedRegion").addClass("active");
            return;
        } else {
            $("#roleName").removeClass("invalid");
            selectedRoleName = $("#tripBasedRegion option:selected").text();
        }
    } else if ($("#nameRadio").is(":checked")) {
        if ($("#roleName").val() == "" || $("#roleName").val().trim() == "") {
            $("#roleName").addClass("invalid");
            $("#roleName_lbl").addClass("active");
            return;
        } else {
            $("#roleName").removeClass("invalid");
            selectedRoleName = $("#roleName").val();
        }
    }

    let deleteRoleJSON = {
        systemId: '<%= systemId %>',
        customerId: $("#customerCombo").val(),
        roleName: selectedRoleName
    };

    //	console.log(" ASDF :: "+JSON.stringify(deleteRoleJSON));
    $.ajax({
        url: '<%= roleModuleAPIurl %>' + 'checkForDuplicateRoleName',
        method: 'GET',
        contentType: "application/json",
        data: deleteRoleJSON,
        // dataType: 'jsonp',
        success: function(result) {
            //alert(" count :: "+result);
            if (result > 0) {
                sweetAlert("Role Name Already Taken");
                $("#roleName").val("");
                $("#tripBasedRegion").val("").trigger('change');
            }

        }
    })

}

function getTripBasedregions() {
    $("#loading-div").show();
    //  var custId = $("#customerCombo").val();
    $("#tripBasedRegion").empty().select2({
        dropDownParent: $("#roleModalForm")
    });
    $("#tripBasedRegion").empty().select2({
        dropDownParent: $("#roleModalForm")
    });
    var getMenusByProcessIdJSON = {
        systemId: '<%= systemId %>',
        customerId: $("#customerCombo").val(),
        operationId: 42

    }

    $('#tripBasedRegion').select2().empty();
    $.ajax({

        url: '<%= roleModuleAPIurl %>' + 'getHubsByOperationType',
        method: 'GET',
        contentType: 'application/json',
        data: getMenusByProcessIdJSON,
        //"crossDomain": true,
        success: function(response) {
            //console.log(response);
            $("#loading-div").hide();

            list = response;
            $('#tripBasedRegion').append(
                $("<option></option>").attr("value", 0)
                .text("Select Region"));
            for (var i = 0; i < list.length; i++) {

                $('#tripBasedRegion').append(
                    $("<option></option>").attr(
                        "value", list[i].hubId).text(
                        list[i].name));
            }
            $('#tripBasedRegion').select2({
                dropDownParent: $("#roleModalForm")
            });
            $('#tripBasedRegion').val(0).trigger("change");

        }
    });
}
$('input[type=radio][name=optradio]').on("change", function() {
    if (this.value == 'trip') {
		$("#roleName").val("");
		$('#tripBasedRegion').val(0).trigger('change');
        $("#divRegion").show();
        $("#roleNameDiv").hide();
        getTripBasedregions();
    } else if (this.value == 'name') {
		$("#roleName").val("");
		$('#tripBasedRegion').val(0).trigger('change');
        $("#divRegion").hide();
        $("#roleNameDiv").show();
    }
});
</script>