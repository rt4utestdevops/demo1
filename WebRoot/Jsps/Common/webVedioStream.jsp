<%@ page  language="java" import="java.util.*,t4u.functions.CommonFunctions,t4u.beans.*,t4u.common.*" pageEncoding="utf-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
if (request.getParameter("list") != null) {
		String list = request.getParameter("list").toString().trim();
		String[] str = list.split(",");
		int systemid = Integer.parseInt(str[0].trim());
		int customerid = Integer.parseInt(str[1].trim());
		int userid = Integer.parseInt(str[2].trim());
		String language = str[3].trim();
		LoginInfoBean loginInfo = new LoginInfoBean();
		loginInfo.setSystemId(systemid);
		loginInfo.setCustomerId(customerid);
		loginInfo.setUserId(userid);
		loginInfo.setLanguage(language);
		loginInfo.setStyleSheetOverride("N");
		loginInfo.setZone(str[4].trim());
		loginInfo.setOffsetMinutes(Integer.parseInt(str[5].trim()));
		loginInfo.setSystemName(str[6].trim());
		loginInfo.setCategory(str[7].trim());
		if (str.length > 8) {
			loginInfo.setCustomerName(str[8].trim());
		}
		if (str.length > 9) {
			loginInfo.setCategoryType(str[9].trim());
		}
		if (str.length > 10) {
			loginInfo.setUserName(str[10].trim());
		}
		//if (str.length > 11) {
		//	loginInfo.setStyleSheetOverride("N");
		//}
		session.setAttribute("loginInfoDetails", loginInfo);
	}
	CommonFunctions cf = new CommonFunctions();
	LoginInfoBean loginInfo = (LoginInfoBean) session
			.getAttribute("loginInfoDetails");
	if (loginInfo == null) {
		response.sendRedirect(request.getContextPath()
				+ "/Jsps/Common/SessionDestroy.html");
	} else {
		session.setAttribute("loginInfoDetails", loginInfo);
		String language = loginInfo.getLanguage();
		int systemId = loginInfo.getSystemId();
		int customerId = loginInfo.getCustomerId();
%>

<jsp:include page="../Common/header.jsp" />
    <base href="<%=basePath%>">
    
    <title>WebVedioStream</title>
    
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	<meta http-equiv="X-UA-Compatible" content="IE=11,IE=10,IE=9,IE=8,IE=Edge"/>
	<link rel="stylesheet" href = "http://maxcdn.bootstrapcdn.com/bootstrap/3.2.0/css/bootstrap.min.css">
	
   <style> 

#error-wrapper1{

font-family: "Open Sans",sans-serif;
    font-size: 24px;
    
    
    }

.container
{
 box-shadow:0px 0px 8px black;
 /*background-color:#CC6600;*/
}

.header1{
/*border:2px solid black;*/
}

 .row1
{
 border:2px solid black;
 height:250px;
}

.row
{
 width:1170px;
}

</style>

 <script src="http://code.jquery.com/jquery-latest.min.js"></script>
   <script type="text/javascript" language="javascript">  
     window.onload = function () { 
		createDiv();
	}
       
  function createDiv(){
  
   var nVer = navigator.appVersion;
   var nAgt = navigator.userAgent;
   var browserName  = navigator.appName;
   var fullVersion  = ''+parseFloat(navigator.appVersion); 
   var verOffset;
   var noofRows=0;
   var noofLinks=0;
   var divContainer;


		// In Opera 15+, the true version is after "OPR/" 
		if ((verOffset=nAgt.indexOf("OPR/"))!=-1) {
		 browserName = "Opera";
		 fullVersion = nAgt.substring(verOffset+4);
		}
		// In older Opera, the true version is after "Opera" or after "Version"
		else if ((verOffset=nAgt.indexOf("Opera"))!=-1) {
		 browserName = "Opera";
		 fullVersion = nAgt.substring(verOffset+6);
		 if ((verOffset=nAgt.indexOf("Version"))!=-1) 
		   fullVersion = nAgt.substring(verOffset+8);
		}
		// In MSIE, the true version is after "MSIE" in userAgent
		else if ((verOffset=nAgt.indexOf("MSIE"))!=-1) {
		 browserName = "Microsoft Internet Explorer";
		 fullVersion = nAgt.substring(verOffset+5);
		}
		// In Chrome, the true version is after "Chrome" 
		else if ((verOffset=nAgt.indexOf("Chrome"))!=-1) {
		 browserName = "Chrome";
		 fullVersion = nAgt.substring(verOffset+7);
		}


			if(browserName!="Chrome"){
			  
			  
			   var noOfgrid=3;
			   var selectList;
			   var SystemId=0;
			   var customerid=0;
			   var a=0;
			   var lastrowgrid =3;
			    
			  var param = {
			        
			        customerid: <%=customerId%>
			    };
			$.ajax({
			        url: '<%=request.getContextPath()%>/webVideoStreamAction.do?param=getRtsplinks',
			        data: param,
			        success: function(data) {
			         selectList = JSON.parse(data);
			         noofLinks=selectList[selectList.length-1].count;
			       if(noofLinks==0){
			        document.getElementById("header1").style.display = 'block';
			       }
		       
		       else {
		          
		           noofRows=Math.floor(noofLinks/3);
		        
		         if(noofLinks%3>0)
		             {
		               noofRows=noofRows+1;
		               lastrowgrid=noofLinks%3;
		             }
		
		            divContainer = document.createElement("div");
		            divContainer.setAttribute("class", "container"); 
		            for(var i=0; i< noofRows ; i++){ 
		               var divTagmainP1 = document.createElement("div"); 
		                   divTagmainP1.setAttribute("class", "row");
		    
		               var divTagmainP = document.createElement("div"); 
		                   divTagmainP.setAttribute("class", "row");  
		            
		               if(i==noofRows-1 && lastrowgrid>0){
		                   noOfgrid=lastrowgrid;
		                    }
		           
		           for(var j=0; j<noOfgrid ; j++){ 
		          
		           var divTagmain = document.createElement("div"); 
		               divTagmain.setAttribute("class", "col-sm-4");
		            
		            var divTag = document.createElement("div"); 
		            var object= document.createElement("OBJECT"); 
					var param= document.createElement("param");
					var emb= document.createElement("embed");
					param.setAttribute("name", "Src"); 
					param.setAttribute("value",selectList[a].rtsplinks);
					 
					
					var param1= document.createElement("param");
					param1.setAttribute("name", "ShowDisplay"); 
					param1.setAttribute("value","true");
					
					var param2= document.createElement("param");
					param2.setAttribute("name", "AutoLoop"); 
					param2.setAttribute("value","false");
					
						var param3= document.createElement("param");
					param3.setAttribute("name", "controls"); 
					param3.setAttribute("value","false");
					
					 	var param4= document.createElement("param");
					param4.setAttribute("name", "toolbar"); 
					param4.setAttribute("value","True");
					
					var param5= document.createElement("param");
					param5.setAttribute("name", "AutoPlay"); 
					param5.setAttribute("value","True");
		
						   
		            divTag.id = "div"+a; 
		            emb.id="vlcEmb"+a;
		            
		             object.setAttribute('id','video'+a);
		             object.setAttribute('width','350');
		             object.setAttribute('height','245');
		             object.setAttribute("classid", "clsid:9BE31822-FDAD-461B-AD51-BE1D1C159921"); 
		             object.setAttribute("codebase","http://downloads.videolan.org/pub/videolan/vlc/latest/win32/axvlc.cab"); 
				     object.setAttribute("events", "true"); 
				     emb.setAttribute("type","application/x-vlc-plugin");
				     emb.setAttribute("pluginspage","http://www.videolan.org");
				     emb.setAttribute("name","vlc");
				     emb.setAttribute("autoplay","yes");
				     emb.setAttribute("loop","on");
				     emb.setAttribute('width','350');
		             emb.setAttribute('height','245');
				     emb.setAttribute("target",selectList[a].rtsplinks);
		  
		             divTag.setAttribute("align", "center"); 
		             divTag.setAttribute("class", "row1");
		             object.appendChild(param); 
		             object.appendChild(param1); 
					 object.appendChild(param2);
					 object.appendChild(param3); 
					 object.appendChild(param4); 
					 object.appendChild(param5);
					 object.appendChild(emb); 
					 divTag.appendChild(object); 
					 divTagmain.appendChild(divTag);
					 divTagmainP.appendChild(divTagmain);
					 a++; 
					 }
			 
		   var divTagmainchild = document.createElement("div"); 
               divTagmainchild.setAttribute("class", "row"); 
               divTagmainchild.style.height="20px";
               divContainer.appendChild(divTagmainchild);
		       divContainer.appendChild(divTagmainP);
            
           }
         document.getElementsByTagName('body')[0].appendChild(divContainer);
         }
       }
     });
    }  
       
  else
     {
            var customURL = '/Telematics4uApp/Jsps/Common/ShockerBlock.jsp';
			window.location.href = customURL;
			window.location.assign(customURL);
			window.location.replace(customURL); 
			window.document.location = customURL
  
      }
  } 
   
    </script>  


<!-- <body onLoad="createDiv()" >  -->
 
 <div class="row"  style="height:20px; " >
</div>
    <div id="header1" align="center" style="vertical-align:middle;display:none;">

        <div >

            <div id="branding" style="height:150px; " >
                <p class="tagline" style="color:#999;"><b>Message Page</b></p>
            </div>

            <div id="error-wrapper" >
                <h2 class="errorSeessionDestroy" Style="color:#5eb9f9;"><b></>Opps! Currently no cameras are active at this location to display.</b></h2>
            </div><!-- error-wrapper -->

        </div><!-- container -->

    </div><!-- #header section -->

<jsp:include page="../Common/footer.jsp" />
 <!-- </body>   -->
 <!-- </html> -->
<%}%>