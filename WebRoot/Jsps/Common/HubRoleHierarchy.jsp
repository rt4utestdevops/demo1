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

<jsp:include page="../Common/header.jsp" />
<style>

   .dataTables_scrollHead{
     overflow: visible;

   }


.flex{
display: flex;
}

.dropdown-toggle::after {
border-top:0px !important;
}

.fa-envelope-open-text{
font-size:14px;
opacity:0.7;
padding:6px 4px 0px 0px;

}

.fa-phone-volume{
font-size:16px;
opacity:0.7;
padding: 6px 0px 0px 4px;
}

.card {
box-shadow: 0 2px 5px 0 rgba(0,0,0,0.2), 0 2px 10px 0 rgba(0,0,0,0.19);
padding: 10px;
margin-bottom: 8px;
border-radius: 2px !important;
    width: 100%;
}
    </style>

    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>

    <link href="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.7/css/select2.min.css" rel="stylesheet" />
    <script src="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.7/js/select2.min.js"></script>

    <script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.3/jquery.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/js/bootstrap.min.js"></script>


    <script src="https://cdn.datatables.net/1.10.19/js/jquery.dataTables.min.js"></script>
    <link rel="stylesheet" href="https://cdn.datatables.net/1.10.19/css/jquery.dataTables.min.css"/>
    <script src="https://cdn.datatables.net/buttons/1.5.6/js/dataTables.buttons.min.js"></script>
    <script src="https://cdn.datatables.net/buttons/1.5.6/js/buttons.flash.min.js"></script>
    <script src="https://cdn.datatables.net/buttons/1.5.6/js/buttons.html5.min.js"></script>
    <script src="https://cdn.datatables.net/buttons/1.5.6/js/buttons.print.min.js"></script>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css"/>
    <link rel="stylesheet" href="https://cdn.datatables.net/1.10.19/css/dataTables.bootstrap.min.css"/>
    <link rel="stylesheet" href="https://cdn.datatables.net/responsive/2.2.3/css/responsive.bootstrap.min.css"/>

    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/css/bootstrap.min.css">
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/js/bootstrap.min.js"></script>
    <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.7.2/css/all.css"
      integrity="sha384-fnmOCqbTlWIlj8LyTjo7mOUStjsKC4pOpQbqyi7RrhN7udi9RwhKkMHpvLbHG9Sr"
      crossorigin="anonymous">
      <script src="https://cdnjs.cloudflare.com/ajax/libs/sweetalert/2.1.2/sweetalert.min.js"></script>
    <select id="typeSelect" name="typeSelect" style="height:28px;width:200px;border-radius:4px;">
    </select>
    <button id="goBtn" class="btn btn-primary" onclick="parseDataTableJSON()" style="margin:16px;height:28px;">GO</button>
    <button id="save" class="btn btn-primary" onclick="save()" style="float:right;margin:16px;">Save</button>
    <div class="card"> Please separate multiple emails and phone numbers with Commas.
    </div>
<table id="hubTable" class="table table-striped table-bordered dt-responsive nowrap" style="width:100%;font-size:13px;">


</table>

<script>
let hubTable;
var roles = [];
let levelNum = 0;
let maxLevel = 0;

var hubData;
let zones = [];
  var otherHubs =[];


  let dataString = "?systemId="+<%= systemId %>+"&customerId="+<%= customeridlogged %>;


$(document).ready( function () {


$.ajax({
    //url : 'http://localhost:9007/roleModule/getoperationidforconfiguredlevel'+dataString,
    url : '<%= roleModuleAPIurl %>' + 'getoperationidforconfiguredlevel'+dataString,
	method : 'GET',
    contentType: 'application/json',
    success : function(types) {
	$.each(types,function(t, type) {
	     $("#typeSelect").append('<option value="'+type.operationId+'">'+type.typeOfOperation+'</option>');
		  parseDataTableJSON();
	  });
      }
  })
});

function parseDataTableJSON(){
  let rows = [];
  $.ajax({
      //url: 'http://localhost:9007/roleModule/getallhubrolesusersoperationid'+dataString +"&operationId="+$("#typeSelect").val(),
	  url : '<%= roleModuleAPIurl %>' + 'getallhubrolesusersoperationid'+dataString +"&operationId="+$("#typeSelect").val(),
      datatype : "application/json",
      success: function(result) {
         hubData = result;
		 console.log("Hub Data", hubData)
		  $.ajax({
              url : '<%= roleModuleAPIurl %>' + 'getallhubinfo'+dataString +"&operationId="+$("#typeSelect").val(),
              datatype : "application/json",
              success: function(result) {
                otherHubs =result;
				if(zones.length == 0){
						   $.ajax({
							  // url: 'http://localhost:9007/roleModule/getAllZones',
							   url : '<%= roleModuleAPIurl %>' + 'getAllZones',
							   datatype : "application/json",
							   success: function(result) {
									zones = result;
									populateRolesBeforeHub();
							   }
						   });
				}
				 else {
				   populateRolesBeforeHub();
				 }
              }
            })

      }
    });
}

function populateRolesBeforeHub(){
	var getRoleJSON = {
       systemId : '<%= systemId %>' ,
       customerId : '<%= customeridlogged %>',

     }
	  $.ajax({
              url : '<%= roleModuleAPIurl %>' + 'getmaxhierarchylevel'+dataString +"&operationId="+$("#typeSelect").val(),
              datatype : "application/json",
              success: function(result) {
				  maxLevel = parseInt(result);
				  if(roles.length == 0){
							$.ajax({
							   // url: 'http://localhost:9007/roleModule/getRolesForUser',
								url : '<%= roleModuleAPIurl %>' + 'getRolesForUser',
								datatype : "application/json",
								 data : getRoleJSON,
								success: function(result) {
									 roles = result;
									 populateHubTable();
								}
							});
						}
						else {
							populateHubTable();
						}
			  }
   })

}

function populateHubTable(){
	if ($.fn.DataTable.isDataTable("#hubTable")) {
              $('#hubTable').DataTable().clear()
                  .destroy();
            }
			$('#hubTable').html("");

  let header = "<thead><tr><th>Id</th><th>Name</th><th>Zone</th>";
  $.each(hubData,function(i, type) {
      levelNum < parseInt(type.levelNo) ? levelNum =  parseInt(type.levelNo): "";
  });

  for(var x = 1; x <= maxLevel; x++)
  {
    header += '<th><select id="select'+x+'" style="z-index:1000;">';
	header+= '<option value="0">Select a role</option>';
    $.each(roles,function(i, item){
      header+= '<option value="'+item.roleId+'">'+item.roleName+'</option>';
    });
    header += '</select></th>';
  }
  header += "</tr></thead>";
  $("#hubTable").append(header);

  var uniqueHubs = hubData.reduce(function (a, d) {
     if (a.indexOf(d.hubId) === -1) {
       a.push(d.hubId);
     }
     return a;
  }, []);

  let parsedHubs = [];
  uniqueHubs.forEach(function(uniqueHub)
  {
    let hub = [];
    let h = 0;
	let hub_id;
    hubData.forEach(function(item){
      $("#select"+item.levelNo).val(item.roleId);
      if(item.hubId == uniqueHub && h==0)
      {
        h = 1;
		hub_id = item.hubId;
        hub.push(item.hubId);
        hub.push(item.hubCode);
		let zone = '<select id="zone'+item.hubId+'">';
         $.each(zones,function(z, zn){
           let selected="";
           (item.zoneId === zn.zoneId)? selected="selected":selected="";
           zone+= '<option value="'+zn.zoneId+'" '+selected+'>'+zn.zoneName+'</option>';
         });
         zone += '</select>';
         hub.push(zone);
      }
      if(item.hubId == uniqueHub)
      {
        hub.push('<div class="flex"><i class="fas fa-envelope-open-text"></i><input id="email'+item.hubId+item.levelNo+'" placeholder="Email Ids" value="'+item.emails+'"  type="text" style="width:50%"/><i class="fas fa-phone-volume"></i><input id="phone'+item.hubId+item.levelNo+'" placeholder="Phone Nos" type="text" value="'+item.phoneNumbers+'" style="width:49%;margin-left:4px;"/></div>');
      }
    })

	for(var j=levelNum; j<=maxLevel; j++)
	{
		  hub.push('<div class="flex"><i class="fas fa-envelope-open-text"></i><input id="email'+hub_id+j+'" placeholder="Email Ids"   type="text" style="width:50%"/><i class="fas fa-phone-volume"></i><input id="phone'+hub_id+j+'" placeholder="Phone Nos" type="text"  style="width:49%;margin-left:4px;"/></div>');
	}

   // Object.assign(hub,{...tempHub});
    parsedHubs.push({...hub});
  })


    otherHubs.forEach(function(item){
       let hub = [];
       if(!uniqueHubs.includes(item.hubId))
       {
		      hub.push(item.hubId);
              hub.push(item.hubName);
              let zone = '<select id="zone'+item.hubId+'">';
              $.each(zones,function(z, zn){
                let selected="";
                (item.zoneId === zn.zoneId)? selected="selected":selected="";
                zone+= '<option value="'+zn.zoneId+'" '+selected+'>'+zn.zoneName+'</option>';
              });
              zone += '</select>';
              hub.push(zone);

              for(var x = 1; x <= maxLevel; x++)
              {
                hub.push('<div class="flex"><i class="fas fa-envelope-open-text"></i><input id="email'+item.hubId+x+'" placeholder="Email Ids"  type="text" style="width:50%"/><i class="fas fa-phone-volume"></i><input id="phone'+item.hubId+x+'" placeholder="Phone Nos" type="text" style="width:49%;margin-left:4px;"/></div>');
              }
              parsedHubs.push({...hub});
        }

      })



   hubTable =  $('#hubTable').DataTable({
     scrollX: true,
     dom: 'Bfrtip',
     data: parsedHubs,
     paging:false,
     "bSort": false,
	 scrollY: "300px",
     buttons: ['excel', 'pdf'],
     "columnDefs": [
        { "width": "40px", "targets": 0 },
        { "width": "100px", "targets": 1 }
      ]
   });

}

function save(){
    let sendJSON = [];
    let checkEmailPhone = true;
    /*$.each(hubData,function(i, type) {
      let checkEmails = $("#email"+type.hubId+type.levelNo).val().split(",");
      let checkphoneNumbers = $("#phone"+type.hubId+type.levelNo).val().split(",");
      for(var u=0;u < checkEmails.length;u++){
        if(!checkEmails[u].includes("@"))
        {
          checkEmailPhone = false;
          $("#email"+type.hubId+type.levelNo).css({"border":"1px solid red"});
        }
        else {
          $("#email"+type.hubId+type.levelNo).css({"border":"1px solid #ddd"});
        }

      }
      for(var u=0;u < checkphoneNumbers.length;u++){
        if(!isPositiveInteger(checkphoneNumbers[u]))
        {
          checkEmailPhone = false;
          $("#phone"+type.hubId+type.levelNo).css({"border":"1px solid red"});
        }
        else {
          $("#phone"+type.hubId+type.levelNo).css({"border":"1px solid #ddd"});
        }

      }




    });*/


		otherHubs.forEach(function(type){
			for(var k=1;k<=maxLevel;k++)
	        {
				;
				if($("#email"+type.hubId+k).val() != "" && $("#email"+type.hubId+k).val() != undefined)
				{
					 sendJSON.push({
						 "systemId":<%= systemId %>,
						 "customerId":<%= customeridlogged %>,
						 "hubId":type.hubId,
						 "hubCode":type.hubName,
						 "roleId":$("#select"+k).val(),
						 "roleName":$("#select"+k+" option:selected").text().trim(),
						 "levelNo":k,
						 "emails":$("#email"+type.hubId+k).val(),
						 "phoneNumbers":$("#phone"+type.hubId+k).val(),
						 "createdBy":"<%= loginUserName%>",
						 "createdDate":"",
						 "updatedBy":"<%= loginUserName%>",
						 "updatedDate":new Date(),
						 "status":"active",
						 "operationId":$("#typeSelect").val(),
						 "typeOfOperation":$("#typeSelect option:selected").text(),
						 "zoneId":$("#zone"+type.hubId).val(),
						 "zoneName":$("#zone"+type.hubId+" option:selected").text().trim()

					  })
				}
			}
		})


    /*if(!checkEmailPhone)
    {
      sweetAlert("Check All Phone Numbers and Email format");
      return;
    }*/

    //SAVE API CALL HERE
    console.log("Send JSON", sendJSON)

	 $.ajax({
   						//url :  'http://localhost:9007/roleModule/updateallhubrolesusers',
   						url : '<%= roleModuleAPIurl %>' + 'updateallhubrolesusers',
						method : 'POST',
   						contentType : "application/json",
   						data : JSON.stringify(sendJSON),
   						success : function(response) {
   						 sweetAlert("Save Successful!");
   						}
   						});

  }

  function isPositiveInteger(s) {
  return /^\+?[1-9][\d]*$/.test(s);
}


</script><jsp:include page="../Common/footer.jsp" />
