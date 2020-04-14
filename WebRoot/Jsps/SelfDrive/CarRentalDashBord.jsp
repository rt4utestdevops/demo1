<%@ page language="java" import="java.util.*,t4u.functions.*,t4u.beans.*,t4u.common.*" pageEncoding="ISO-8859-1"%>
<%@ taglib uri="http://packtag.sf.net" prefix="pack" %>
<%
String path = request.getContextPath();
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
	loginInfo.setStyleSheetOverride("N");
	if(str.length>8){
	loginInfo.setCustomerName(str[8].trim());
	}
	session.setAttribute("loginInfoDetails",loginInfo);
}
CommonFunctions cf=new CommonFunctions();
cf.checkLoginInfo((LoginInfoBean)session.getAttribute("loginInfoDetails"),session,request,response);
LoginInfoBean loginInfo=(LoginInfoBean)session.getAttribute("loginInfoDetails");
		session.setAttribute("loginInfoDetails", loginInfo);
		String language = loginInfo.getLanguage();
		int systemid=loginInfo.getSystemId();
		String systemID=Integer.toString(systemid);
		int customerId=loginInfo.getCustomerId();
		int offset = loginInfo.getOffsetMinutes();
		int custidpassed=0;
		if(request.getParameter("cutomerIDPassed")!= null)
		{
		customerId=Integer.parseInt(request.getParameter("cutomerIDPassed"));
		}


ArrayList<String> tobeConverted = new ArrayList<String>();

tobeConverted.add("View_Details");
tobeConverted.add("Vertical_Dashboard");
tobeConverted.add("Car_Allocation");
tobeConverted.add("Tariff_Management");
tobeConverted.add("Approved_Users");
tobeConverted.add("Close_Trip");
tobeConverted.add("PromoCode_Management");
tobeConverted.add("Payment");


ArrayList<String> convertedWords = new ArrayList<String>();
convertedWords = cf.getLanguageSpecificWordForKey(tobeConverted,language);
String ViewDetails=convertedWords.get(0);
String Dashboard=convertedWords.get(1);
String CarAllocation=convertedWords.get(2);
String TariffManagement=convertedWords.get(3);
String ApprovedUsers=convertedWords.get(4);
String CloseTrip=convertedWords.get(5);
String PromoCodeManagement=convertedWords.get(6);
String Payment=convertedWords.get(7);

int userId=loginInfo.getUserId();
String userAuthority=cf.getUserAuthority(systemid,userId);
int customeridlogged = loginInfo.getCustomerId();
int systemId = loginInfo.getSystemId();

String superAdmin;
	if(loginInfo.getIsLtsp()== -1 && !userAuthority.equalsIgnoreCase("Admin"))
{
	superAdmin="false";
}
else{
    superAdmin="true";
}

String getHubs=cf.getHubs(systemId,userId,customeridlogged);


%>

<jsp:include page="../Common/header.jsp" />
    <title><%=Dashboard%></title>
  	<meta name="viewport" content="width=device-width, initial-scale=1">
  	     <link rel="stylesheet" type="text/css" href="../../Main/modules/ironMining/dashBoard/css/layout.css" />
		 <link rel="stylesheet" type="text/css" href="../../Main/modules/ironMining/dashBoard/css/component.css" />
		 <script src="../../Main/adapter/ext/ext-base.js"></script>
		 <script src="../../Main/Js/ext-all-debug.js"></script>
		 <script src="../../Main/Js/modernizr.custom.js"></script>
		 <pack:script src="../../Main/Js/MsgBox.js"></pack:script>
		 <pack:style src="../../Main/resources/css/ext-all.css" />
  	     <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/css/bootstrap.min.css">
  	     <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script>
  	     <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/js/bootstrap.min.js"></script>
	<style>
body {
  font-family: 'Open Sans', sans-serif !important;
  font-size: 25px;
  line-height: 1.42857143;
  color: #333;
  background-color: #fff;
}
.pull-left {
  float: left!important;
  font-family: 'Open Sans', sans-serif !important;
  font-size: 12px;  
  margin-top:-5px;
}
.bodyBackGround{
	background-image: url(/ApplicationImages/DashBoard/DashBoardBackground.png) !important;
}
.dashbordheader{
    box-shadow: 0px 0px 8px;
    margin-top: 10px;
    width: 1340px;
   background-image: url(/ApplicationImages/DashBoard/Box_Blue.png) !important;
}
.dashbordName{
Color:white;
font-family: 'Lato', Calibri, Arial, sans-serif;
font-size: 30px;
padding-left:10px;

}
.panel-blue {
  border-color: #FFFFF0;
  border-style: double;
  border-width: 6px ;
}
.panel-blue > .panel-body {
  border-color: #B0A2B1;
  color: #D08452;
  background-color: rgb(29, 222, 178);
}
.panel-1 {
  border-color: #22849A;
}
.panel-1 > .panel-heading1 {
  border-color: #22849A;
  color: White;
  background-color:#22849A;
  height:30px;
  text-align: left;
}

.panel-navy {
  border-color:  #FFFFF0;
  border-style:solid;
  border-width: 6px ;
}
.panel-navy > .panel-body {
  border-color: #AB9FAC;
  color: #B9C8CD;
  background-color: #F6CC2A;
}

.panel-2 {
  border-color: #22849A;
}
.panel-2 > .panel-heading2 {
  border-color: #22849A;
  color: White;
  background-color: #22849A;
  height:30px;
  text-align: left;
}

.panel-green {
   border-color:  #FFFFF0;
  border-style:solid;
  border-width: 6px ;
}
.panel-green > .panel-body {
  border-color: #26ADA1;
  color: #608D4E;
  background-color: #9ED43E;
}

.panel-3{
  border-color: #22849A;
}
.panel-3 > .panel-heading3 {
  border-color: #22849A;
  color: White;
  background-color:#22849A;
  height:30px;
  text-align: left;
	
}

.panel-red {
  border-color: #FFFFF0;
  border-style:solid;
  border-width: 6px ;
}
.panel-red > .panel-body {
  border-color: #C94223;
  color: #fff;
  background-color: #E0502E;
}

.panel-4{
  border-color:#22849A;
}
.panel-4 > .panel-heading4 {
  border-color: #22849A;
  color: White;
  background-color:#22849A;
  height:30px;
  text-align: left;
}
.panel-brown {
  border-color:  #FFFFF0;
  border-style:solid;
  border-width: 6px ;
}
.panel-brown > .panel-body {
  border-color: #D85B06;
   background-color: #D85B06;
}

.panel-5 {
  border-color: #22849A;
}
.panel-5 > .panel-heading5 {
  border-color: #22849A;
  color: White;
  background-color: #22849A;
  height:30px;
  text-align: left;
}

.panel-darkblue {
  border-color: #FFFFF0;
  border-style: double;
  border-width: 6px ;
}
.panel-darkblue > .panel-body {
  border-color: #B0A2B1;
  color: #CACC6B;
  background-color: #CACC6B;
}

.pagination-centered {
  text-align: center;
}
#size{
	 font-size:69%;
	 font-weight:300;
	 font-family: 'Open Sans', sans-serif !important;
}
#size1{
	 font-size:24px;
	 font-weight:300
}
.panel-footer{
	background-color: #D4D8D1;
	height:25px;
	
}
#description{
	 font-size:55%;
	 font-family: 'Open Sans', sans-serif !important;
	 color:black;
	 overflow:auto;
	 height:47px;
	
}
#panel-height{
height:108px;
}
#nameimageAlign{
margin-top: -10px;
}
@media (min-width: 1200px){
	.col-lg-3 {
	  width: 33%;
	}
}
html, body, div, dl, dt, dd, ul, ol, li, h1, h2, h3, h4, h5, h6, pre, form, fieldset, input, p, blockquote, th, td {
  margin-bottom: -1px;
  margin-left: -2px;
  padding-bottom: 1px;
  padding-left:1px;
}
label {
			display : inline !important;
		}
	</style>

 <!--  <body class="bodyBackGround" oncontextmenu="return false;"  >  -->
 <div class="bodyBackGround">
  <div class="col-md-12 col-sm-12" id="Container" style="box-shadow:0px 0px 8px black">
  
 	<div class="dashbordheader">
    <span class="dashbordName" id="size1">DASHBOARD</span>	
  	</div> 
  	
	 <!-- first  container  -->
  	 <div class="col-md-6 col-sm-6" style="padding-top:20px" >
	        <div class="row">
                <div class="col-md-6 col-sm-6">
                    <div class="panel panel-blue">
                        <div class="panel-body" id="panel-height">
                            <div class="row" id="nameimageAlign">                             
                               <div class="row-fluid">
   									<div class="span12 pagination-centered">
								    	<img class="span12 pagination-centered" src="/ApplicationImages/VehicleImages/car4.png">
								    </div> 
								 </div> 
								 </div> 
								 <div class="row" style="padding-top:0px;">  
								<div class="col-md-12 text-center" id="size" style="color:White">
								<%=CarAllocation%>
								</div>
                            </div>
                        </div>
                        <% if(superAdmin.equals("true")) { %> 
                         <a href="http://orangeselfdrive.com/carAllot?hubId=<%=getHubs%>&systemId=<%=systemId%>&customerId=<%=customerId%>&superAdmin=<%=superAdmin%>">
                         <% } else { %>
                         <a href="http://telematics4u.in/Telematics4uApp/Jsps/Common/401Error.html"> 
                         <% } %>
							     <div class="panel-footer">
                                <span class="pull-left"><%=ViewDetails%></span>
                                <span class="pull-right"><i class="fa fa-arrow-circle-right"></i></span>
                                <div class="clearfix"></div>
                            </div>
                        </a>
                    </div>
                </div>
                <div class="col-md-6 col-sm-6">
                    <div class="panel panel-navy">
                        <div class="panel-body" id="panel-height" >
                             <div class="row" id="nameimageAlign">                              
                               <div class="row-fluid">
   									<div class="span12 pagination-centered">
								    	<img class="span12 pagination-centered" src="/ApplicationImages/VehicleImages/tariff.png">
								    </div> 
								 </div> 
								<div class="col-md-12 text-center" id="size" style="color:White">
								<%=TariffManagement%>
								</div>
                            </div>
                        </div>
                         <% if(superAdmin.equals("true")) { %> 
                         <a href="http://orangeselfdrive.com/tariffView?hubId=<%=getHubs%>&systemId=<%=systemId%>&customerId=<%=customerId%>&superAdmin=<%=superAdmin%>">
                         <% } else { %>
                         <a href="http://telematics4u.in/Telematics4uApp/Jsps/Common/401Error.html"> 
                         <% } %>
							    <div class="panel-footer">
                                <span class="pull-left"><%=ViewDetails%></span>
                                <span class="pull-right"><i class="fa fa-arrow-circle-right"></i></span>
                                <div class="clearfix"></div>
                            </div>
                        </a>
                    </div>
                </div>
            </div> <!-- End Of First Row -->
                <div class="row">
                 <div class="col-md-6 col-sm-6">
                    <div class="panel panel-green">
                        <div class="panel-body" id="panel-height" >
                             <div class="row" id="nameimageAlign">                                
                               <div class="row-fluid">
   									<div class="span12 pagination-centered">
								    	<img class="span12 pagination-centered" src="/ApplicationImages/VehicleImages/user1.png">
								    </div> 
								 </div> 
								<div class="col-md-12 text-center" id="size" style="color:White">
								<%=ApprovedUsers%>
								</div>
                            </div>
                        </div>
                       <% if(superAdmin.equals("true")) { %> 
                         <a href="http://orangeselfdrive.com/adminDashboard?hubId=<%=getHubs%>&systemId=<%=systemId%>&customerId=<%=customerId%>&superAdmin=<%=superAdmin%>">
                         <% } else { %>
                         <a href="http://telematics4u.in/Telematics4uApp/Jsps/Common/401Error.html"> 
                         <% } %>
  							  <div class="panel-footer">
                            <span class="pull-left"><%=ViewDetails%></span>
							<span class="pull-right"><i class="fa fa-arrow-circle-right"></i></span>
                                <div class="clearfix"></div>
                        </div>
                        </a>
                    </div>

                </div>
                <div class="col-md-6 col-sm-6">
                    <div class="panel panel-red">
                        <div class="panel-body" id="panel-height">
                             <div class="row" id="nameimageAlign">                            
                               <div class="row-fluid">
   									<div class="span12 pagination-centered">
								    	<img class="span12 pagination-centered" src="/ApplicationImages/VehicleImages/tripclose.png">
								    </div> 
								 </div> 
								<div class="col-md-12 text-center" id="size"  style="color:White">
								<%=CloseTrip%>
								</div>
                            </div>
                        </div>
                         <a href="http://orangeselfdrive.com/tripClosingByAdmin?hubId=<%=getHubs%>&systemId=<%=systemId%>&customerId=<%=customerId%>&superAdmin=<%=superAdmin%>">
							  <div class="panel-footer">
                            <span class="pull-left"><%=ViewDetails%></span>
							<span class="pull-right"><i class="fa fa-arrow-circle-right"></i></span>
                                <div class="clearfix"></div>
                        </div>
                        </a>
                    </div>
                </div>
               
            </div> <!-- End Of Second Row -->
             
			<div class="row">
			    <div class="col-md-6 col-sm-6">
			        <div class="panel panel-brown">
                        <div class="panel-body" id="panel-height">
                             <div class="row" id="nameimageAlign">                                
                               <div class="row-fluid"  >
   									<div class="span12 pagination-centered">
								    	<img class="span12 pagination-centered" src="/ApplicationImages/VehicleImages/discount.png">
								    </div> 
								 </div> 
								<div class="col-md-12 text-center" id="size"  style="color:White">
								<%=PromoCodeManagement%>
								</div>
                            </div>
                        </div>
                         <% if(superAdmin.equals("true")) { %> 
                         <a href="<%=request.getContextPath()%>/Jsps/SelfDrive/PromoCodeManagement.jsp">
                         <% } else { %>
                         <a href="http://telematics4u.in/Telematics4uApp/Jsps/Common/401Error.html"> 
                         <% } %>
							  <div class="panel-footer">
                            <span class="pull-left"><%=ViewDetails%></span>
							<span class="pull-right"><i class="fa fa-arrow-circle-right"></i></span>
                                <div class="clearfix"></div>
                        </div>
                        </a>
                    </div>
			    </div>
			    			<div class="col-md-6 col-sm-6">
                    <div class="panel panel-darkblue">
                        <div class="panel-body" id="panel-height">
                             <div class="row" id="nameimageAlign">                            
                               <div class="row-fluid">
   									<div class="span12 pagination-centered">
								    	<img class="span12 pagination-centered" src="/ApplicationImages/VehicleImages/payment.png">
								    </div> 
								 </div> 
								<div class="col-md-12 text-center" id="size"  style="color:White">
								<%=Payment%>
								</div>
                            </div>
                        </div>
                          <% if(superAdmin.equals("true")) { %> 
                         <a href="http://orangeselfdrive.com/getInvoiceByDateRange?hubId=<%=getHubs%>&systemId=<%=systemId%>&customerId=<%=customerId%>&superAdmin=<%=superAdmin%>">
                         <% } else { %>
                         <a href="http://telematics4u.in/Telematics4uApp/Jsps/Common/401Error.html"> 
                         <% } %>
							  <div class="panel-footer">
                            <span class="pull-left"><%=ViewDetails%></span>
							<span class="pull-right"><i class="fa fa-arrow-circle-right"></i></span>
                                <div class="clearfix"></div>
                        </div>
                        </a>
                    </div>
                </div>
			</div>
			
			<!-- End Of Third Row -->
	</div> <!-- End Of First Container  -->
	
	<!--  Second Container  -->
	<div class="col-md-6 col-sm-6" style="padding-top:20px">
	    <div class="row">
                <div class="col-md-12 col-sm-12">
                    <div class="panel panel-1"> 
                        <div class="panel-heading1" id="size">
                       <%=CarAllocation%>
                        </div>
                        <div class="panel-body" id="description" >
                          &nbsp; Allocation of cars is done automatically according to availability .
                        </div>
                    </div>
                </div>
            </div>
			<div class="row">
                <div class="col-md-12 col-sm-12">
                    <div class="panel panel-2">
                        <div class="panel-heading2" id="size">
                           <%=TariffManagement%>
                        </div>
                        <div class="panel-body"  id="description">
                         <p>  &nbsp;Every car will have a fixed per hour tariff plan.</p>
                        </div>
                    </div>
                </div>
            </div>
			<div class="row">
                <div class="col-md-12 col-sm-12">
                    <div class="panel panel-3">
                        <div class="panel-heading3" id="size">
                         <%=ApprovedUsers%>
                        </div>
                        <div class="panel-body"  id="description"  >
                            <p>&nbsp;Details Of Approved Users.</p>
                        </div>
                    </div>
                </div>
            </div>
			<div class="row">
                <div class="col-md-12 col-sm-12">
                    <div class="panel panel-4">
                        <div class="panel-heading4" id="size">
                      	<%=CloseTrip%>
                        </div> 
                        <div class="panel-body" id="description"  >
                            <p>&nbsp; Details Of Closed Trip .</p>
                        </div>
                    </div>
                </div>
            </div>
            <div class="row">
                <div class="col-md-12 col-sm-12">
                    <div class="panel panel-5">
                        <div class="panel-heading5" id="size">
                      	<%=PromoCodeManagement%>
                        </div> 
                        <div class="panel-body" id="description"  >
                            <p>&nbsp;Details of PromoCode Management</p>
                        </div>
                    </div>
                </div>
            </div>
	 </div>  <!-- End Of Second Container   -->
</div> 


<script type="text/javascript" >
	window.oncontextmenu=function()
	{
		return false;
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
</script>
</div>

<jsp:include page="../Common/footer.jsp" />
 <!-- </body>   -->
 <!-- </html> -->

