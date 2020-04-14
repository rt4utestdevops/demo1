	<%@ page  language="java" 
import="java.util.*,t4u.functions.*,t4u.beans.*,t4u.common.*" pageEncoding="utf-8"%>
<%@ taglib uri="http://packtag.sf.net" prefix="pack" %>
 <% 
 
 DESEncryptionDecryption des=new DESEncryptionDecryption();
 String ID = "";
 if(request.getParameter("ID") !=null){
   ID = request.getParameter("ID");
  }
  String emailStatus = "";
 if(request.getParameter("EmailStatus") !=null){
   emailStatus = request.getParameter("EmailStatus");
  }
  String message = "";
  String message2 = "";
  if(emailStatus.equalsIgnoreCase("false")){
  message2 = "This link has been expired.";
  }else if(emailStatus.equalsIgnoreCase("true")){
   message = "Create Password";
  }
  String password1 = "";
 if(request.getParameter("Password1") !=null){
   password1 = request.getParameter("Password1");
   password1 = des.decrypt(password1);
  }
  
    String password2 = "";
 if(request.getParameter("Password2") !=null){
   password2 = request.getParameter("Password2");
   password2 = des.decrypt(password2);
  }
  
    String password3 = "";
 if(request.getParameter("Password3") !=null){
   password3 = request.getParameter("Password3");
   password3 = des.decrypt(password3); 
  }
  
   String password4 = "";
 if(request.getParameter("Password4") !=null){
   password4 = request.getParameter("Password4");
   password4 = des.decrypt(password4); 
  }
  
  String systemId = "";
  if(request.getParameter("SystemId") !=null){
   systemId = request.getParameter("SystemId");
  }
  String customerId = "";
  if(request.getParameter("CustomerId")!=null){
  customerId = request.getParameter("CustomerId");
  }
  String userId = "";
  if(request.getParameter("UserId") !=null){
  userId = request.getParameter("UserId");
  }  

  String username = "";
  if(request.getParameter("UserName") !=null){
  username = request.getParameter("UserName");
  }  
  
  String firstname = "";
  if(request.getParameter("FirstName") !=null){
  firstname = request.getParameter("FirstName").toLowerCase();
  } 
  
  String lastname = "";
  if(request.getParameter("LastName") !=null){
  lastname = request.getParameter("LastName").toLowerCase();
  } 
  
  String cotextpath = "";
  String postpath = "";
  if(request.getParameter("ContextPath") !=null){
  cotextpath = request.getParameter("ContextPath");  
  if(cotextpath.contains("telematics4u.in")){
  postpath = "http://api.telematics4u.com/TelematicsRESTService/services/ServiceProcess/setPasswordRecovery";
  }else{ 
  postpath = request.getParameter("ContextPath")+"/TelematicsRESTService/services/ServiceProcess/setPasswordRecovery";
  }
  } 
 %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script>
  
  
    <title>Password Recovery</title>
    <script language="javascript" type="text/javascript">
    window.history.forward();
   document.onkeydown = function() {   
    switch (event.keyCode) { 
        case 116 : //F5 button
            event.returnValue = false;
            event.keyCode = 0;
            return false; 
        case 82 : //R button
            if (event.ctrlKey) { 
                event.returnValue = false; 
                event.keyCode = 0;  
                return false; 
            } 
    }
} 
     
     function disableF5(e) { if ((e.which || e.keyCode) == 116) e.preventDefault(); };
// To disable f5
    /* jQuery < 1.7 */
$(document).bind("keydown", disableF5);
/* OR jQuery >= 1.7 */
$(document).on("keydown", disableF5);

// To re-enable f5
    /* jQuery < 1.7 */
$(document).unbind("keydown", disableF5);
/* OR jQuery >= 1.7 */
$(document).off("keydown", disableF5);
     
 window.oncontextmenu = function () {return false;}
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
    
 </script> 
 <style>
form {
    border: 3px solid #f1f1f1;
}

.labelcss{ 
    width: 100%;
    padding: 3px 10px;
    margin: 8px 0;
    display: inline-block;
    border: 1px solid #ccc;
    box-sizing: border-box;
}
.passcss {
    width: 50%;
    padding: 12px 20px;
    margin: 8px 0;
    display: inline-block;
    border: 1px solid #ccc;
    box-sizing: border-box;
    margin-left: 13%;
    }
 .passcss2 {
    width: 50%;
    padding: 12px 20px;
    margin: 8px 0;
    display: inline-block;
    border: 1px solid #ccc;
    box-sizing: border-box;
    margin-left: 6%;
    }   
form{
background-color:lightgray;
}
button {
    background-color: #14149c;
    color: white;
    border: none;
   padding: 12px 32px;
    text-align: center;
    text-decoration: none;
    display: inline-block;
    font-size: 15px;
    margin: 4px 2px;
    cursor: pointer;
    border-radius: 8px;
    margin-left: 40%;
    }

button:hover {
    opacity: 0.8;
}
.container {
    background-color: #FFFFFF;
    width: 98% !Important; 
    -webkit-box-shadow: 1px 1px 3px #cac4ab;
    box-shadow: 1px 1px 3px #cac4ab;
    margin: 1%;
    position: relative;     
}
.header{
color: #14149c;
margin-left: 1%;

}

.formdiv{

margin-left: 35%;
margin-right: 35%;
}

.headerforflase{

color: #14149c;
margin-left: 1%;
font-family:sans-serif;


}
span.psw {
    float: right;
    padding-top: 16px;
}
p {
    font-size: 15px;
}

.firstHeading {
    font-family: sans-serif;
    font-weight: normal;
    font-size: 18px;
    color: white;
    background-color: #14149c;
    height: 30px;
    text-align: left;
    text-outline: thickness blur color;
   padding-top: 15px;
    padding-bottom: 10px;
    padding-left: 7px;
}

@media(max-width:1024px){
.formdiv {
    margin-left: 25%;
    margin-right: 25%;
}
}

</style>
    
    

	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	<!--
	<link rel="stylesheet" type="text/css" href="styles.css">
	-->

  </head>
  
  <body onload="showdivfunction();"> 
  <div id="truediv" class="container">
  <h3 class="firstHeading"><%=message%></h3>  
   <div class =  "formdiv">
  <form method="GET" action='<%=postpath%>' id = "paasform" onsubmit="return formSubmit(this);">
    <span style="padding: 5px;font-family: sans-serif;font-size: 15px;">New Password : </span> <input type="password" id = 'newpassword' class="passcss" placeholder="Enter New Password" name="Password"  title="Must contain at least one number and one uppercase and lowercase letter, and at least 8 or more characters"   >
   <span style="padding: 7px;font-family: sans-serif;font-size: 15px;">Confirm Password : </span><input type="password" id = 'confirmpassword' class="passcss2" placeholder="Re-Enter Password" name="Password2"   >
    <input type='hidden' name='SystemId' value='<%=systemId%>'  />  
	<input type='hidden' name='ClientId' value='<%=customerId%>'  />
	<input type='hidden' name='UserId' value='<%=userId%>'  /> 
	<input type='hidden' name='ContextPath' value='<%=cotextpath%>'  />   
	<input type='hidden' name='SessionId' value='<%=ID%>'  />    
    <button  id="button" name = "submitButton" onclick="checkForm()">Save</button>
</form>
</div>
<br><br/>
<span style="font-family: sans-serif;" >
  <small>Please provide a new password that meets the following requirements:</small><br/>
  <small>- Password should have at least one upper case letter, one lower case letter, one number and minimum 8 characters. 
  </small><br/>
  <small>- Should not be a combination of username, firstname, lastname.</small><br/>
  <small>- Should not contain username, firstname or lastname.</small><br/>
   <br><br/>
   </span>
  </div>
  <div id="falsediv">
  <h3 class="headerforflase"><%=message2%></h3>   
  </div>
  <script>

 var id= '<%=ID%>';
 var emailstatus = '<%=emailStatus%>';
 var password1 = '<%=password1%>';
 var password2 = '<%=password2%>';
 var password3 = '<%=password3%>';
 var password4 = '<%=password4%>';
 var systemId = '<%=systemId%>'  ;
 var customerId = '<%=customerId%>';
 var userId = '<%=userId%>';
 var username = '<%=username%>';
 var firstname = '<%=firstname%>';
 var lastname = '<%=lastname%>';
var everythingok = false;


  function showdivfunction(){
 //alert('emailstatus == '+emailstatus+"   password1 == "+password1+"   password2 =="+password2+"  password3 =="+password3+"  password4=="+password4+"  systemId=="+systemId+"customerId == "+customerId+"  userId=="+userId );
    
        document.getElementById("truediv").style.display = "none";
        document.getElementById("falsediv").style.display = "none";
    
    if (emailstatus == 'true' || emailstatus == true) {
        document.getElementById("truediv").style.display = "block";
        document.getElementById("falsediv").style.display = "none";
    } else if(emailstatus == 'false' || emailstatus == false){
        document.getElementById("truediv").style.display = "none";
        document.getElementById("falsediv").style.display = "block";
    }
 
 }
 
document.getElementById("newpassword").addEventListener("input", function() {
  document.getElementById("newpassword").setCustomValidity("");  
});
 
 document.getElementById("confirmpassword").addEventListener("input", function() {
  document.getElementById("confirmpassword").setCustomValidity("");  
});
 
 


  function checkForm() {
  
  input = document.getElementById("newpassword");
      
 var newpassword =  document.getElementById("newpassword").value;
 var confirmpassword = document.getElementById("confirmpassword").value;
 
 var newpassword2 = newpassword.toLowerCase();
 var password12=password1.toLowerCase();
 var password22=password2.toLowerCase();
 var password32=password3.toLowerCase();
 var password42=password4.toLowerCase();
 var username2 = username.toLowerCase();;
 var firstname2 = firstname.toLowerCase();
 var lastname2 = lastname.toLowerCase();
 
if(newpassword == ""){
document.getElementById("newpassword").setCustomValidity("Please fill out this field!");
    document.getElementById("button").click();
    return false;

}if(confirmpassword==""){
document.getElementById("confirmpassword").setCustomValidity("Please fill out this field!");
document.getElementById("button").click();
return false;

}if(newpassword != ""){
var strongRegex = new RegExp("^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.{8,})");
var res =strongRegex.test(newpassword);
 if(res==false){
 input.setCustomValidity("Password must contain at least one number and one uppercase and lowercase letter, and at least 8 or more characters!");
     document.getElementById("button").click();
     return false;
 
 }
}
if(newpassword == password1 || newpassword == password2 || newpassword == password3 || newpassword == password4){
   input.setCustomValidity("Password should not be same as your previous 4 passwords!");
      document.getElementById("button").click();
      return false;
  
  }
  
if(newpassword.toLowerCase() == username.toLowerCase()) {
         input.setCustomValidity("Password must be different from Username!");
             document.getElementById("button").click();
             return false;
         
  }
  
 if(newpassword.toLowerCase() == firstname.toLowerCase()) {
       input.setCustomValidity("Password must be different from your first name !");
           document.getElementById("button").click();
           return false;
       
  }
if(newpassword.toLowerCase() == lastname.toLowerCase()) {
         input.setCustomValidity("Password must be different from your last name!");
             document.getElementById("button").click();
             return false;
         
  }


if( newpassword.toLowerCase() == username.toLowerCase()+firstname.toLowerCase() || newpassword.toLowerCase() == username.toLowerCase()+lastname.toLowerCase()  || newpassword.toLowerCase() == firstname.toLowerCase()+lastname.toLowerCase()  || newpassword.toLowerCase() == lastname.toLowerCase()+firstname.toLowerCase() ) {
  input.setCustomValidity("Password  should bot a combination of Username, Firstname and Lastname!");
      document.getElementById("button").click();
      return false;
  
  }
 
 if(newpassword2.indexOf(password12)==0 && password12 !="" ){
input.setCustomValidity("Password should not contain Username,Firstname,Lastname and previous 4 passwords!");
document.getElementById("button").click();
return false;
}
 if(newpassword2.indexOf(password22)==0  && password22 !="" ){
input.setCustomValidity("Password should not contain Username,Firstname,Lastname and previous 4 passwords!");
document.getElementById("button").click();
return false;
}

 if(newpassword2.indexOf(password32)==0   && password32!="" ){
input.setCustomValidity("Password should not contain Username,Firstname,Lastname and previous 4 passwords!");
document.getElementById("button").click();
return false;
}

 if(newpassword2.indexOf(password42)==0   && password42!=""){
input.setCustomValidity("Password should not contain Username,Firstname,Lastname and previous 4 passwords!");
document.getElementById("button").click();
return false;
}

 if(newpassword2.indexOf(username2)==0){
input.setCustomValidity("Password should not contain Username,Firstname,Lastname and previous 4 passwords!");
document.getElementById("button").click();
return false;
}

 if(newpassword2.indexOf(firstname2)==0){
input.setCustomValidity("Password should not contain Username,Firstname,Lastname and previous 4 passwords!");
document.getElementById("button").click();
return false;
}

 if(newpassword2.indexOf(lastname2)==0){
input.setCustomValidity("Password should not contain Username,Firstname,Lastname and previous 4 passwords!");
document.getElementById("button").click();
return false;
}

  
 if (document.getElementById('newpassword').value != document.getElementById('confirmpassword').value) {
    document.getElementById('confirmpassword').setCustomValidity("Password and confirm password should be same!"); 
    document.getElementById("button").click();
    return false;
} else {

 var newpassword3 =  document.getElementById("newpassword").value;
  $.ajax({
		url: "<%=request.getContextPath()%>/PasswordRecoveryByEmailAction.do?param=getEncPassword",
		data:{Password:newpassword3},
	    type: 'POST',
	    dataType: "json",
	    success: function(response,data) { 	    
	    	   if(response.cancelInfo != "" && response.cancelInfo != null){
	    	   var responsedata=response.cancelInfo;	    	 
	    	   $('#newpassword').val(responsedata);
	    	    $('#confirmpassword').val(responsedata);
	    	   }	   
              }
		});
    }
   }
   
 function formSubmit(form) {
  form.submitButton.disabled = true;  
    setTimeout(function() {
        form.submit();
    }, 3000);  // 3 seconds
    return false;
}
   
   </script>
  </body>
</html>
