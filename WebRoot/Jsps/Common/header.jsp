<%@ page language="java"
   import="java.util.*,t4u.functions.CommonFunctions,t4u.functions.AdminFunctions,t4u.beans.*,t4u.common.*"
   pageEncoding="UTF-8"%>
<%@ taglib uri="http://packtag.sf.net" prefix="pack"%>
<%
   String path = request.getContextPath();
   //String basePath = request.getScheme() + "://"+ request.getServerName() + ":" + request.getServerPort()+ path + "/";
   String basePath = request.getScheme() + "://"+ request.getServerName() + ":" + request.getServerPort()+"/";
   CommonFunctions cf = new CommonFunctions();
   AdminFunctions af=new AdminFunctions();
   LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
   HttpSession sessionPassMsg = request.getSession(true);
   int systemId=0;
   int customerId=0;
   int userId=0;   
   String lang="";
   String newMenuStyle="";
   if (loginInfo != null) {
   systemId=loginInfo.getSystemId();
   customerId=loginInfo.getCustomerId();
   lang=loginInfo.getLanguage();
   userId=loginInfo.getUserId();
   newMenuStyle=loginInfo.getNewMenuStyle();  
   } else {
   	response.sendRedirect(request.getContextPath()+ "/Jsps/Common/SessionDestroy.html");
   }
   
   String userName=(String)session.getAttribute("userName");
   String language=loginInfo.getLanguage();
   String home=cf.getLabelFromDB("Home",language);
   String userAuthority = cf.getUserAuthority(systemId,userId);   
   Integer[] activeSessionCount = cf.getActiveUserCount(systemId);
      
   %>
   <%if(newMenuStyle.equalsIgnoreCase("YES")&& customerId>0){%>
   
	<!doctype html>
<html lang="en">
   <head>
   
      <meta charset="utf-8">
      <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
      <meta name="description" content="">
      <meta name="author" content="">
      <link rel="icon" href="">
      <title>Home Screen</title>
      <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css" integrity="sha384-Gn5384xqQ1aoWXA+058RXPxPg6fy4IWvTNh0E263XmFcJlSAwiGgFAW/dAiS6JXm" crossorigin="anonymous">
      <link href='https://fonts.googleapis.com/css?family=Orbitron' rel='stylesheet' type='text/css'>
	  <link href="https://fonts.googleapis.com/css?family=Lato" rel="stylesheet">
      <script src="../../assets/header_resource/jquery.min.js"></script>
      <script src="../../assets/header_resource/popper.min.js"></script>
      <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js"></script>
	  <style>
      .nav-link dropdown-toggle{
      	color: white;
      }
      </style>
      <script>
      
 
      
   
      function getDigitalTimer(servertime) {
		
		
      	/* Create two variable with the names of the months and days in an array */
      	var monthNames = [ "January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December" ];
      	var dayNames= ["Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"];

      	 var newDate = new Date();

      	/* Extract the current date from Date object */
      	newDate.setDate(newDate.getDate());

      	var d = new Date(servertime);
      	var hh = d.getHours();
      	var mm=d.getMinutes();
      	var mms=d.getSeconds();
 

      	d.setHours(parseInt(hh),parseInt(mm),parseInt(mms));



        var day=d.getDay();
      	var date=d.getDate();
      	
      	var month=d.getMonth();
      	var year=d.getFullYear();
      	var dayName=dayNames[parseInt(day)];
      	var monthName=monthNames[parseInt(month)];
      	
      	var today=dayName.substr(0, 3) + " " +date+ " " + monthName.substr(0, 3) + " " + year;
      	

      	setInterval(function showTime()
      	{
      		mms=parseInt(mms);
      		mm=parseInt(mm);
      		hh=parseInt(hh);

      		mms=mms+1;
      		if(mms==60){
      			mm=mm+1;
      			mms=0;
      		}
      		if(mm==60){
      			hh=hh+1;
      			mm=0;
      			mms=0;
      		}
      		if(hh==24){
      			hh=1;
      			mm=0;
      			mms=0;
      		}
      		if (hh <= 9) hh = "0" + hh;
      		if (mm <= 9) mm = "0" + mm;
      		if (mms <= 9) mms = "0" + mms;
          $('#Date').html(today);
      		$('#hours').html(" "+hh);
      		$('#min').html(""+mm);
      		$('#sec').html(""+mms);

      	},1000);


      }

</script>
      <style>
         :root {
         --input-padding-x: 0.75rem;
         --input-padding-y: 1.2rem;
         }
         body {
         padding-bottom: 20px;
         margin-bottom: 40px;
         margin-top:72px !important;
         /*font-family: 'Karla', sans-serif !important;*/
         /*font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif;*/
         }
				 .navbar {
				/* margin-bottom: 20px;*/
				 z-index:100;
         border-radius: 0px !important;
         font-size: 18px !important;
         width:100%  !important;
				 }

         .navbar-nav > li > .dropdown-menu {
  font-size: 16px;
}

         #topNav{position:fixed !important;
         top:0 !important;
         left:0 !important;
         width:100%  !important;z-index:10000;
       font-family: 'Lato', sans-serif;}

         .navbar-brand { padding: 5px 0px 0px 0px !important;}
     			.mr-auto, .mx-auto {
     			margin-top: 16px !important;
     			}
				 @media only screen and (min-width: 768px) {
					 .navbar {
           height:50px;
           /*margin-bottom: 20px;*/
           z-index:100;
           border-radius: 0px !important;
           }
         }

         .dropdown:hover .dropdown-menu {
         display: block;
         border-radius:2px;
         margin-top: -8px; // remove the gap so it doesn't close

         }

        /* .dropdown:hover .dropdown-menu a:hover {
           background: #337AB7;
           color:white;
         }

         .dropdown:hover .dropdown-menu a:active {
           background: none;
         }*/
         .level2 a:hover {background:#D8D8D8 !important;}
         .level3:hover {background:#D8D8D8 !important;}
         .level3 a:hover {background:#8E8E8E !important;}
         .profile
         {
         width:35px;
         height:35px;
         border-radius:50%;
         }
         html {
         position: relative;
         min-height: 100%;
         }
         .bg-dark{
         background: #337AB7 !important;
         //height: 50px !important;
         }
         .footer {
         position: fixed; 
         opacity: 0.5;
         bottom: 0;
         left:0;
         width: 100%;
         min-height: 40px; /* Set the fixed height of the footer here */
         line-height: 40px; /* Vertically center the text there */
         background-color: #343a40;
         color: #dbdbdb;
         }
         .padTop10{
         padding-top:10px;
         }
         .padTop20{
         padding-top:20px;
         }
         .padTop40{
         padding-top:40px;
         }
         .header a{ color: #333333;}
         .header{
         color:#333333 !important;
         position: absolute;
         z-index: 0;
         top:50px;
         width: 100%;
         min-height: 30px; /* Set the fixed height of the footer here */
         line-height: 30px; /* Vertically center the text there */
          }
         .container {
         min-width: 100%;
         }
         .form-signin {
         width: 100%;
         padding: 0px;
         margin: 0 auto;
         }

         .form-control{
         border: none;
         z-index: 100;
         border: 1px solid;
         height: 34px !important;
         }

.nav-item{padding-right: 4px;}
#dateTimeId {margin-right: 0px;
font-family: 'Orbitron', sans-serif;float:right;margin-top:0px;color:#00FF00;font-size:14px;
position: fixed;
top: 0;
right: 0;
z-index: 1000000000000000000;
}
#dateTimeId ul li {display: inline-block;}

.dropdown-item {
    display: block;
    width: 100%;
    padding: .005rem 1.5rem !important;
    clear: both;
    font-weight: 400;
    color: #212529;
    text-align: inherit;
    white-space: nowrap;
    background-color: transparent;
    border: 0;
}
.navbar-nav .dropdown-menu {

    overflow-y:auto !important;
    max-height:620px !important;

}

#companyImage {
	height : 43px !important;
}
.navbar-dark .navbar-nav .nav-link {
    color: white !important;
}
/*
.ui-menu {
  z-index: 100000 !important;
}
*/
      </style>

   </head>
   <body>
      <script>
      var toggleSearch = false;
      var toggleProfile = false;

      function toggleSearchBox()
      {		 
		 $('#searchId').val('');
	   document.getElementById('vehicle-No').innerHTML="";
       document.getElementById('Date-Time').innerHTML="";
       document.getElementById('Driver-Id').innerHTML="";
       document.getElementById('Driver-Mobile').innerHTML="";
       document.getElementById('Owner-Name').innerHTML="";
       document.getElementById('Location').innerHTML="";
       document.getElementById('Vehicle-Capacity').innerHTML="";
         (toggleSearch) ? $("#searchBox").hide() : $("#searchBox").show();
         toggleSearch = !toggleSearch;
		 document.getElementById('vehicle-No').innerHTML="";
      }
              
			   
	 function myWindow ()
	 {			  		 
		 window.open("<%=request.getContextPath()%>/Jsps/Common/UpdateProfile.jsp");
	 }
     
         getDigitalTimer('<%=cf.getCurrentDateTime(loginInfo.getOffsetMinutes())%>');
         $.ajax({
              type: "POST",
              url: '<%=request.getContextPath()%>/CommonAction.do?param=getMenuList',
              success: function(result) {
               var data = JSON.parse(result);
         	     var $menu = $("#menuJson");
               $("#title").html(data.title);
               $.each(data.menu, function () {
               $menu.append(
                   getMenuItem(this, 1)
               );
               });
          }
          });

          var getMenuItem = function (itemData, level) {			  
             if(level == 1){

              var item = $("<li class='nav-item dropdown'>")
              .append(
              '<a class="nav-link dropdown-toggle" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false" href="/Telematics4uApp'+itemData.link+'">'+itemData.name+'</a>');
           }
           else
           {

            var item =  $("<a>", {
                 href:  itemData.link,
                 html: itemData.name,
                 class: 'dropdown-item'
             });
           }
             if (itemData.sub) {
              if(level == 1){
                var subList = $('<div class="dropdown-menu level2" aria-labelledby="'+ itemData.name+'">');
              $.each(itemData.sub, function () {
                 $.each(this, function () {
                      subList.append(getMenuItem(this, 2));
                  });
                  item.append(subList);
                })
              }
              else
              {
                 var subList = $('<div class="dropdown-item level3" aria-labelledby="'+ itemData.name+'">');
                  $.each(itemData.sub, function () {
                      subList.append(getMenuItem(this, 3));
                  });
               item.append(subList);
               }
              }
              return item;
         };

         function logOut() {
         window.location="<%=request.getContextPath()%>/LogOut.do?username=<%=loginInfo.getUserName()%>";
         }
         
         function home() {
			window.location="/jsps/LTSPScreen.jsp?CustomerId=0";		
		 }	
         
         
         
         var im = document.getElementById('companyImage'); // or select based on classes
		 function defaultImage(){
  			// image not found or change src like this as default image:
   			document.getElementById('companyImage').src = '/ApplicationImages/CustomerLogos/defaultImage.gif';
		 };
		 
		 
	
	 
      </script>
  <div id="topNav">
      <nav class="navbar navbar-expand-md navbar-dark bg-dark">
         <a class="navbar-brand" href="#" style="float:left;">
         	<!-- <img src="/ApplicationImages/HomeScreen/logo.png"/>  -->
         	
         	 <img id="companyImage"  src ="/ApplicationImages/CustomerLogos/custlogo_<%=loginInfo.getSystemId()%>.gif" onError="defaultImage();">  

         </a>
         <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarsExample04" aria-controls="navbarsExample04" aria-expanded="false" aria-label="Toggle navigation">
         <span class="navbar-toggler-icon"></span>
         </button>
         <div class="collapse navbar-collapse" id="navbarsExample04">
            <ul class="navbar-nav mr-auto" id="menuJson">
            </ul>
      <!-- <div style="float:right;float: right;margin-top:6px !important;position: absolute;right: 120px;">
                   <a onclick="toggleSearchBox()">
                    <img src="/ApplicationImages/ApplicationButtonIcons/search24.png" /></a>
                    <div id="searchBox"  style="border:1px solid #7A8391;min-width:330px;position:absolute;top:34px;display:none;background: #dfdfdf;padding:16px;right:8px;font-size:12px;color: black !important;">
                      <div class="row" style="width:100%;border-bottom:1px solid #7A8391;margin:-6px 0px 4px 0px">
						<div class="col-md-5" style="margin:0;padding:0px">
							Search Vehicle&nbsp;:
						</div>
						<div class="col-md-7" style="margin:0;padding:0px;margin-bottom: 2px;">
							<input style="width:120px;" id="searchId" />							
						</div>
					  </div>
					  <div class="row" style="width:100%;border-bottom:1px solid #7A8391;margin:8px 0px 4px 0px">
						<div class="col-md-5" style="margin:0;padding:0px">
							Vehicle No&nbsp;:
						</div>
						<div class="col-md-7" style="margin:0;padding:0px">
							<p class='vehicle-details-block' id='vehicle-No'></p>
							<div style="width:100%;margin:4px 0px"></div>
						</div>
					  </div>
					  <div class="row" style="width:100%;border-bottom:1px solid #7A8391;margin:8px 0px 4px 0px">
						<div class="col-md-5" style="margin:0;padding:0px">
							Date Time&nbsp;:
						</div>
						<div class="col-md-7" style="margin:0;padding:0px">
							<p class='vehicle-details-block' id='Date-Time'></p>
							<div style="width:100%;margin:4px 0px"></div>
						</div>
					  </div>
					  <div class="row" style="width:100%;border-bottom:1px solid #7A8391;margin:8px 0px 4px 0px">
						<div class="col-md-5" style="margin:0;padding:0px">
							Location&nbsp;:
						</div>
						<div class="col-md-7" style="margin:0;padding:0px">
							<p class='vehicle-details-block' id='Location'></p>
							<div style="width:100%;margin:4px 0px"></div>
						</div>
					  </div>
					  <div class="row" style="width:100%;border-bottom:1px solid #7A8391;margin:8px 0px 4px 0px">
						<div class="col-md-5" style="margin:0;padding:0px">
							Driver Name&nbsp;:
						</div>
						<div class="col-md-7" style="margin:0;padding:0px">
							<p class='vehicle-details-block' id='Driver-Id'></p>
							<div style="width:100%;margin:4px 0px"></div>
						</div>
					  </div>
					  <div class="row" style="width:100%;border-bottom:1px solid #7A8391;margin:8px 0px 4px 0px">
						<div class="col-md-5" style="margin:0;padding:0px">
							Driver Mobile&nbsp;:
						</div>
						<div class="col-md-7" style="margin:0;padding:0px">
							<p class='vehicle-details-block' id='Driver-Mobile'></p>
							<div style="width:100%;margin:4px 0px"></div>
						</div>
					  </div>
					  <div class="row" style="width:100%;border-bottom:1px solid #7A8391;margin:8px 0px 4px 0px">
						<div class="col-md-5" style="margin:0;padding:0px">
							Owner Name&nbsp;:
						</div>
						<div class="col-md-7" style="margin:0;padding:0px">
							<p class='vehicle-details-block' id='Owner-Name'></p>
							<div style="width:100%;margin:4px 0px"></div>
						</div>
					  </div>
					  <div class="row" style="width:100%;border-bottom:1px solid #7A8391;margin:8px 0px 4px 0px">
						<div class="col-md-5" style="margin:0;padding:0px">
							Asset Capacity&nbsp;:
						</div>
						<div class="col-md-7" style="margin:0;padding:0px">
							<p class='vehicle-details-block' id='Vehicle-Capacity'></p>
							<div style="width:100%;margin:4px 0px"></div>
						</div>
					  </div>
					                      
                    </div>
               </div>   -->      
              <!--<ul class="navbar-nav rightNav" style="float:right;padding-left:20px;margin-top:-28px"> --> 
             <ul class="navbar-nav rightNav" id="rightNav" style="float:right;padding-left:20px;">			  
               <li class="nav-item dropdown" >
                  <a class="nav-link" href="#" id="dropdown04" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                   <div style="display:flex;align-items:baseline;"><div id="sessionCount" style="padding-right:40px;">Active Users: <i class="fa fa-laptop" aria-hidden="true"></i>&nbsp;<%=activeSessionCount[0]%>&nbsp;&nbsp;<i class="fa fa-mobile" aria-hidden="true"></i>&nbsp;<%=activeSessionCount[1]%></div>
                   <img src="/ApplicationImages/user.png" style="margin-top: 17px;margin-right: -16px;width:24px;"/></div>
                   <div class="dropdown-menu dropdown-menu-right" aria-labelledby="dropdown04" style="margin-right: -16px;margin-top:-12px;">
                     <a class="dropdown-item" href="#"><%=userName %><br/>Role: <%=userAuthority%></a>
                     <a class="dropdown-item" onclick="myWindow()" id="update_profile" href="#">Update Profile</a>   					 
                     <%if(loginInfo.getIsLtsp()==0){%>
							<a class="dropdown-item" onclick = "home()" href="#"><%=home%></a>
					 <%}%>
                     <a class="dropdown-item" href="#" onclick = "logOut()">Logout</a>
                  </div>
               </li>
			</ul>						
						
         </div>
      </nav>
      <div id="dateTimeId">
        <ul style="list-style-type:none;padding:0px;margin:0px;">
          <li id="Date" style="color:white;"></li>
          <li id="hours" style="width:40px;padding:0px 0px 0px 8px;margin-right:-10px;margin-left:8px;"></li>
            <li id="point" style="width:20px;padding:0px 0px 0px 5px;margin-right:-10px">:</li>
            <li id="min" style="width:30px;padding:0px;margin-right:-10px"></li>
            <li id="point" style="width:20px;padding:0px 0px 0px 5px;margin-right:-10px">:</li>
            <li id="sec" style="width:30px;padding:0px;"></li>
        </ul>
        
      </div>

    </div>
    <!--  <header class="header" style="box-shadow:0px 0px 10px 0px;">
         <div class="container text-center" >
            <span id="title" ></span>
         </div>
      </header>-->
      <div class="container" style="padding-top:2px;" >


		<%} else {%>

	<!doctype html>
<html lang="en">
   <head>
      <meta charset="utf-8">
      </head>
   <body>

<%}%>
