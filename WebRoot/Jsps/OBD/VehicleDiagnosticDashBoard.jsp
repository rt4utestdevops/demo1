<%@ page language="java" import="java.util.*,java.text.SimpleDateFormat,t4u.functions.*,t4u.beans.*,t4u.common.*" pageEncoding="utf-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
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
	if(str.length>9){
	loginInfo.setCategoryType(str[9].trim());
	}
	if(str.length>10){
	loginInfo.setUserName(str[10].trim());
	}
	session.setAttribute("loginInfoDetails",loginInfo);
}
	
	CommonFunctions cf = new CommonFunctions();
	cf.checkLoginInfo((LoginInfoBean) session.getAttribute("loginInfoDetails"), session, request, response);
	String responseafterview="''";
	String feature="1";
	if(session.getAttribute("responseafterview")!=null){
	   responseafterview="'"+session.getAttribute("responseafterview").toString()+"'";
		session.setAttribute("responseafterview",null);
	}
		
    LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
    
 if(loginInfo==null){
	response.sendRedirect(request.getContextPath()+ "/Jsps/Common/SessionDestroy.html");
}
String vehicleNo = "";
String Status = "";
if(request.getParameter("Sts") != null && !request.getParameter("Sts").equals("")){
	Status = request.getParameter("Sts");
}
if(request.getParameter("RegNo") != null && !request.getParameter("RegNo").equals("")){
	vehicleNo = request.getParameter("RegNo");
}
String pageName = request.getParameter("ParamId");
%>
<!doctype html>
<html class="no-js" lang="">
	<head>
    	<meta charset="utf-8">
     	<meta http-equiv="x-ua-compatible" content="ie=edge">
      	<title>Vehicle Diagnostic</title>
      	<meta name="description" content="">
      	<meta name="viewport" content="width=device-width, initial-scale=1">
      	<link rel="stylesheet" href="../../Main/resources/css/obd/wrap-stylesNew.css">
      	<script src="../../Main/Js/jquery.min.js"></script>
      	<script src="../../Main/Js/bootstrap.min.js"></script>
      	<script src="../../Main/Js/custom.js"></script>
      	<link rel="stylesheet" href="../../Main/modules/OBD/css/obdSearch.css">
  		<script src="../../Main/modules/OBD/js/obdSearch.js"></script>
      	<style>
		  	.diag-status {
				font-weight: 400 !important;
				font-size: 20px !important;
				color: #fcf8e3;
				letter-spacing: 0;
				text-align: center;
				width: 100%;
				margin: 5px auto;
			}	
			.diag-img {
				
				vertical-align: bottom;
				text-align: center;
			}
			.header-custom {
				padding-top: 2px !important;
				padding-bottom: 0px !important;
			}
			.searchCustom{
				margin-left: 7px;
			    background-color: transparent;
			    border-color: transparent;
			    color:white;
			}
			.error-code {
				margin-top: 1px;
			}
			.code-txt {
				padding-top: 1px;
			}
			.container-custom1{
				padding-right: 0px;
				padding-left: 52px;
			}
			
			.diag-icons {
				padding-top: 45px;
				text-align: center;
			}
			.diag-level {
				padding-top: 2px;
				text-align: center;
			}
			.diag-level-two {
				padding-top: 2px;
				text-align: center;
			}
			.back_button{
				width: 90px;
    			margin-top: 15px;
    			border-radius: 10px;
    			background: transparent;
    			color: ghostwhite;
    			border-color: gray;
			}
			.refresh_button{
				width: 90px;
    			margin-top: 15px;
    			border-radius: 10px;
    			background: transparent;
    			color: ghostwhite;
    			border-color: gray;
			}
			.dashBoard_button{
				width: 132px;
    			margin-top: 15px;
    			border-radius: 10px;
    			background: transparent;
    			color: ghostwhite;
    			border-color: gray;
			}
			#noteId{
				font-size: 14px; 
				padding-top:1px; 
				margin-top: initial; 
				margin-bottom: initial;
				color: #e0ffff;
			}
			.menu-items {
				float: right;
				margin-top: -6px;
			}
			.pg-title h3 {
				font-weight: 400;
				font-size: 19px;
				color: rgba(0, 0, 0, 0.69);
				letter-spacing: 0;
				color: #eee;
			}
			.pg-title h2 {
				font-weight: 400;
				font-size: 16px;
				color: rgba(0, 0, 0, 0.69);
				letter-spacing: 0;
				color: #5eb9f9;
			}
			.dtc-count {
				color: #fff;
				
				
			}
			.dtc-count h4 {
				padding-top: 18px;
				font-size: 14px;
				color: #fff;
				letter-spacing: 0;
				font-weight: 400;
				text-align: center;
				border-radius: 50%;
				height: 50px;
			}
			
			#dataphara {
				font-weight: 400;
				font-size: 12px;
				color: rgba(255, 255, 255, 0.69);
				letter-spacing: 0;
				/* line-height: 25px; */
			
				text-transform: uppercase;
				position: absolute;
				 bottom: 15px; 
				text-align: center;
				width: 100%;
				margin: auto;
			}
input::-webkit-input-placeholder {
					color: rgba(255, 255, 255, 0.9) !important;
					}

body {
    font-family: 'Poppins', sans-serif;
    background-color: #46546b;
}				
			
   		</style>
   </head>
   <body onload="loadData()" class="body-bg">
      <!-- header -->     
      <section class="header-custom">
         <div class="container-custom">
         <div class="note">
         <marquee scrolldelay="250" id="noteId">Note : Please configure parameters to get deviated values.</marquee>
         </div>
            <div class="logo" style="margin-top: -21px;">
               <div class="buttons">
            	<div class="back">
            	 	 <button type="button" class="refresh_button" id="refresh_id"  onclick="refreshPage();">Refresh</button>
                     <button type="button" class="dashBoard_button" id="dashBoard_id"  onclick="gotoDashBoard();">OBD Dash Board</button>
                     <button type="button" class="back_button" id="back_id"  onclick="gotoBack()">Back</button>
                  </div>
               </div>
               <div class="clearfix"></div>
            </div>
            <div class="menu-items">
            	<div class="search-section">
            	<div class="search-field">
                     <input id="search" class="searchCustom" type="search" placeholder="Search Vehicle"  onchange="loadDataOnSearch()"/>
                  </div>
                  <div class="icon"><a ><img src="../../Main/resources/images/obd/search.svg" alt="user"></a></div>
               </div>
            </div>
         </div>
      </section>
      <!-- //header -->
      <!-- vehicle-diag -->
      <section class="vehicle-diag">
         <div class="container-custom">
         	<div class="pg-title">
               	<div><h2 style="text-align: -webkit-center; float: left; margin-top: 17px; margin-right: -226px" id="ignitionId"></h2></div>
               	<div><h2 style="text-align: -webkit-center; float: right; margin-top: 18px; margin-left: -172px" id="ignitionId1"></h2></div>
                <div><h3 style="padding-top: 5px; text-align: -webkit-center;" id="titleId">VEHICLE DIAGNOSTIC</h3></div>
            </div>
            <hr/>
          <section class="error-code">
         <div class="container-custom1">
         	<div><p align="center" style="padding-top: 5px; text-align: -webkit-center;color:white;font-size: 18px;" id="DTCHeaderMessage">No DTC Error Codes Found </p></div>
            <div class="row" style="border: 2px solid rgba(245, 245, 245, 0.5); width: 1180px; border-radius: 20px;">
               <div class="col-md-3 no-padding-right" id="powerTrainDiv" style="display:none;">
                  <div class="card">
                     <a  data-toggle="modal" data-target="#myModal"><span class="click"></span></a>
                     <div class="dtc-icon">
                        <svg width="31px" height="40px" viewBox="0 0 31 40" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">
                           <!-- Generator: Sketch 41.2 (35397) - http://www.bohemiancoding.com/sketch -->
                           <defs></defs>
                           <g id="Page-1" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">
                              <g id="icon-green" transform="translate(-173.000000, -129.000000)" class="powerTrain">
                                 <g id="Group-7" transform="translate(39.000000, 105.000000)">
                                    <g id="Group-2" transform="translate(110.000000, 24.000000)">
                                       <g id="Group-10">
                                          <polygon id="power_train" points="54.4348438 12.9445313 54.4348438 0 44.6376563 0 44.6376563 5.16789063 33.7971875 5.16789063 33.7971875 0 24 0 24 12.9445313 33.7971875 12.9445313 33.7971875 7.77664062 37.9130469 7.77664062 37.9130469 32.2233594 33.7971875 32.2233594 33.7971875 27.0554687 24 27.0554687 24 40 33.7971875 40 33.7971875 34.8321094 44.6376563 34.8321094 44.6376563 40 54.4348438 40 54.4348438 27.0554687 44.6376563 27.0554687 44.6376563 32.2233594 40.5217969 32.2233594 40.5217969 7.77664062 44.6376563 7.77664062 44.6376563 12.9445313"></polygon>
                                       </g>
                                    </g>
                                 </g>
                              </g>
                           </g>
                        </svg>
                        <div class="dtc-count" id= "powerTrain">
                           <h4></h4>
                        </div>
                     </div>
                     <div class="text-count">
                        <p>Powertrain</p>
                     </div>
                  </div>
               </div>
               <div class="col-md-3 no-padding-left" id="ChassisDiv" style="display:none;">
                  <div class="card">
                     <a ><span class="click"></span></a>
                     <div class="dtc-icon">
                        <svg width="68px" height="30px" viewBox="0 0 68 30" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">
                           <!-- Generator: Sketch 41.2 (35397) - http://www.bohemiancoding.com/sketch -->
                           <defs></defs>
                           <g id="Page-1" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">
                              <g id="icon-green" transform="translate(-456.000000, -138.000000)" class="chasis" >
                                 <g id="chasis" transform="translate(456.000000, 138.000000)">
                                    <g id="Page-1">
                                       <g>
                                          <g>
                                             <g id="Artboard">
                                                <g id="chasis">
                                                   <g id="Page-1">
                                                      <g id="Dashboard_d2">
                                                         <g id="Group-5">
                                                            <g id="Group-7-Copy" transform="translate(0.344717, 0.000000)">
                                                               <g id="Group-6">
                                                                  <g id="chasis">
                                                                     <path d="M56.9791311,21.0419459 C54.7341008,21.0419459 52.8646537,22.6672754 52.5410698,24.8648793 L40.1781753,24.8648793 C39.7953124,23.5634646 38.5696159,22.6384994 37.191636,22.6384994 L28.9518358,22.6384994 C27.5738558,22.6384994 26.3505365,23.563317 25.9652964,24.8648793 L15.6036299,24.8648793 C15.3632448,22.5785863 13.4285758,20.8176404 11.0954441,20.8176404 C8.58714909,20.8176404 6.54625304,22.8459821 6.54625304,25.3410858 C6.54625304,27.8336809 8.58596056,29.860842 11.0954441,29.860842 C13.2655954,29.860842 15.097603,28.3613891 15.5360309,26.2610336 L25.8953203,26.2610336 C26.1477394,27.7436636 27.4242466,28.834054 28.9518358,28.834054 L37.191636,28.834054 C38.7205623,28.834054 39.9945438,27.7448441 40.246963,26.2610336 L52.5517669,26.2610336 C52.9127902,28.4105298 54.7751059,30 56.9777939,30 C59.4667749,30 61.4871685,27.9932034 61.4871685,25.5256951 C61.489694,23.0511036 59.468112,21.0419459 56.9791311,21.0419459 L56.9791311,21.0419459 Z M56.9791311,28.6312936 C55.2509733,28.6312936 53.8477366,27.2361723 53.8477366,25.523334 C53.8477366,23.8032649 55.2509733,22.4093241 56.9791311,22.4093241 C58.7061002,22.4093241 60.1118624,23.8031173 60.1118624,25.523334 C60.1117143,27.2363199 58.7061002,28.6312936 56.9791311,28.6312936 L56.9791311,28.6312936 Z M27.4603489,24.8636988 C27.7659559,24.3395322 28.3262106,24.0072058 28.9518358,24.0072058 L37.191636,24.0072058 C37.8135469,24.0072058 38.3751387,24.3395322 38.6819343,24.8636988 L27.4603489,24.8636988 L27.4603489,24.8636988 Z M37.1928245,27.4618059 L28.9530243,27.4618059 C28.1945782,27.4618059 27.5340393,26.9615456 27.3070254,26.2586725 L38.8401606,26.2586725 C38.6131467,26.9615456 37.9500821,27.4618059 37.1928245,27.4618059 L37.1928245,27.4618059 Z M11.0954441,22.1875273 C12.8441043,22.1875273 14.2691808,23.6018326 14.2691808,25.3399053 C14.2691808,27.0767974 12.8441043,28.488594 11.0954441,28.488594 C9.34678378,28.488594 7.92527301,27.0767974 7.92527301,25.3399053 C7.92527301,23.6005045 9.34678378,22.1875273 11.0954441,22.1875273 L11.0954441,22.1875273 Z" id="Shape"></path>
                                                                     <g id="noun_782065_cc-copy" transform="translate(34.180017, 11.000000) scale(-1, 1) translate(-34.180017, -11.000000) translate(0.180017, 0.000000)">
                                                                        <g id="Group">
                                                                           <g id="Shape" transform="translate(0.000000, 0.451966)">
                                                                              <path d="M66.5576003,11.4209467 L66.5576003,7.65321944 C66.5576003,7.04708306 66.118885,6.533674 65.5226129,6.44026487 C64.0916946,6.21526489 61.5551597,5.79049217 60.4155866,5.43799217 C58.7816099,4.93208307 52.4684563,2.24844671 50.2823503,1.74458307 C48.0955651,1.24071944 38.2360165,-1.44973511 28.792772,1.83662853 C27.194789,2.39231035 20.0062422,5.84231035 15.7793631,7.636174 C14.5345255,7.66344669 2.21314579,10.2420831 1.55711025,12.0093558 C0.901074707,13.7773104 0.695299587,14.6350376 0.574415192,15.083674 C0.453530796,15.5323104 0.574415192,17.6793558 1.48987679,19.1745831 C2.42299567,19.7043558 4.21928345,20.0602649 6.29605019,20.2989012 C6.27228081,20.1714012 6.24647399,20.0459467 6.230175,19.9170831 C6.19418133,19.6416286 6.17720318,19.3900376 6.17720318,19.1500376 C6.17720318,15.7784467 8.90864723,13.0348104 12.2676035,13.0348104 C15.6265598,13.0348104 18.3580039,15.7777649 18.3580039,19.1500376 C18.3580039,19.3232194 18.3464587,19.4950376 18.3335553,19.6641286 C18.3016364,20.0425376 18.2337238,20.4100376 18.1352506,20.7639012 L18.1515496,20.7639012 L48.3835145,20.1529922 C48.3699319,20.0745831 48.3522747,19.9968558 48.3420878,19.9170831 C48.3060941,19.6429922 48.289116,19.3907194 48.289116,19.1500376 C48.289116,15.7784467 51.02056,13.0354922 54.3795163,13.0354922 C57.7384726,13.0354922 60.4705958,15.7777649 60.4705958,19.1500376 C60.4705958,19.1629922 60.4692375,19.1739012 60.4685584,19.186174 L60.5975923,19.1752649 L65.7664188,18.1982194 C65.7664188,18.1982194 67.7460706,17.1400376 67.7460706,14.228674 C67.7467496,12.2868558 66.5576003,11.4209467 66.5576003,11.4209467 L66.5576003,11.4209467 Z M36.5680835,7.84890125 L25.2776168,8.19594669 C25.4854293,6.49753763 24.4837187,6.11640126 24.4837187,6.11640126 C28.9720612,2.02617399 38.0180171,1.88776489 38.0180171,1.88776489 L36.5680835,7.84890125 L36.5680835,7.84890125 Z M49.239213,7.33003762 L38.9504569,7.67708306 L39.8828966,1.88844671 C45.2004518,1.81890126 48.2381815,2.99708307 48.2381815,2.99708307 L49.757386,5.45844671 L49.239213,7.33003762 L49.239213,7.33003762 Z M55.0396266,7.29458306 L52.1730365,7.29458306 L49.3071256,3.34344671 C51.4572379,4.20253762 53.1781427,5.04935581 54.2029436,5.58458307 C54.8250229,5.90912853 55.1645857,6.60253762 55.0396266,7.29458306 L55.0396266,7.29458306 Z" id="body"></path>
                                                                           </g>
                                                                        </g>
                                                                     </g>
                                                                  </g>
                                                               </g>
                                                            </g>
                                                         </g>
                                                      </g>
                                                   </g>
                                                </g>
                                             </g>
                                          </g>
                                       </g>
                                    </g>
                                 </g>
                              </g>
                           </g>
                        </svg>
                        <div class="dtc-count" id="chasis_id">
                           <h4> </h4>
                        </div>
                     </div>
                     <div class="text-count">
                        <p>Chassis</p>
                     </div>
                  </div>
               </div>
               <div class="col-md-3 no-padding-left" id="BodyDiv" style="display:none;">
                  <div class="card">
                     <a ><span class="click"></span></a>
                     <div class="dtc-icon">
                        <svg width="66px" height="21px" viewBox="0 0 66 21" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">
                           <!-- Generator: Sketch 41.2 (35397) - http://www.bohemiancoding.com/sketch -->
                           <title>body</title>
                           <desc>Created with Sketch.</desc>
                           <defs></defs>
                           <g id="Page-1" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">
                              <g id="icon-green" transform="translate(-758.000000, -145.000000)" class="body">
                                 <g id="body" transform="translate(758.000000, 145.000000)">
                                    <g id="Page-1">
                                       <g>
                                          <g>
                                             <g id="Artboard">
                                                <g id="body">
                                                   <g id="Group">
                                                      <path d="M64.8329395,11.4190861 L64.8329395,7.57460034 C64.8329395,6.95611539 64.4021271,6.43224683 63.8165961,6.33693476 C62.411455,6.10735088 59.9206145,5.67392443 58.8015698,5.31424307 C57.1970286,4.79802731 50.9976024,2.05971826 48.8508777,1.5455896 C46.7034862,1.03146094 37.0215513,-1.7138052 27.748421,1.63951026 C26.1792246,2.20651277 19.1201751,5.72679828 14.9694407,7.55720761 C13.747028,7.58503599 1.6476104,10.2162059 1.00339293,12.0194826 C0.359175471,13.823455 0.15710726,14.6986564 0.0384005224,15.1564327 C-0.0803062152,15.6142089 0.0384005224,17.8049953 0.937370645,19.3306843 C1.85367996,19.8712498 3.61760873,20.2344098 5.65696379,20.4779078 C5.63362257,20.3478102 5.60828072,20.2197999 5.5922753,20.088311 C5.55693005,19.8072447 5.54025772,19.5505282 5.54025772,19.3056388 C5.54025772,15.8653597 8.22249647,13.0658283 11.5209432,13.0658283 C14.81939,13.0658283 17.5016288,15.864664 17.5016288,19.3056388 C17.5016288,19.4823488 17.4902916,19.6576673 17.4776207,19.830203 C17.4462767,20.2163213 17.3795876,20.5913083 17.2828882,20.952381 L17.2988937,20.952381 L46.9862483,20.3290261 C46.9729105,20.2490197 46.9555713,20.1697089 46.9455679,20.088311 C46.9102227,19.8086361 46.8935503,19.5512239 46.8935503,19.3056388 C46.8935503,15.8653597 49.5757891,13.0665241 52.874236,13.0665241 C56.1726824,13.0665241 58.8555882,15.864664 58.8555882,19.3056388 C58.8555882,19.3188572 58.8542546,19.3299886 58.8535878,19.3425113 L58.9802968,19.33138 L64.0560106,18.3344296 C64.0560106,18.3344296 65.9999997,17.2546898 65.9999997,14.2840141 C66.000667,12.302636 64.8329395,11.4190861 64.8329395,11.4190861 L64.8329395,11.4190861 Z M35.7314635,7.51133348 L24.370298,7.85714289 C24.5794118,6.16478293 23.5714287,5.78500405 23.5714287,5.78500405 C28.0878763,1.7093447 37.1904763,1.57142858 37.1904763,1.57142858 L35.7314635,7.51133348 L35.7314635,7.51133348 Z M47.7132774,6.98806719 L38.2380954,7.33333336 L39.0968033,1.57437538 C43.9938776,1.50518649 46.7914017,2.67732776 46.7914017,2.67732776 L48.1904764,5.12607197 L47.7132774,6.98806719 L47.7132774,6.98806719 Z M53.4028824,6.80952384 L50.5344349,6.80952384 L47.6666668,2.61904763 C49.8181725,3.53017792 51.5401924,4.42829206 52.5656572,4.99594069 C53.1881399,5.34014545 53.5279226,6.07555779 53.4028824,6.80952384 L53.4028824,6.80952384 Z" id="body"></path>
                                                   </g>
                                                </g>
                                             </g>
                                          </g>
                                       </g>
                                    </g>
                                 </g>
                              </g>
                           </g>
                        </svg>
                        <div class="dtc-count" id="body_id">
                           <h4></h4>
                        </div>
                     </div>
                     <div class="text-count">
                        <p>Body</p>
                     </div>
                  </div>
               </div>
               <div class="col-md-3 no-padding-left" id="NetworkDiv" style="display:none;">
                  <div class="card">
                     <a ><span class="click"></span></a>
                     <div class="dtc-icon">
                        <svg width="40px" height="40px" viewBox="0 0 40 40" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">
                           <!-- Generator: Sketch 41.2 (35397) - http://www.bohemiancoding.com/sketch -->
                           <defs></defs>
                           <g id="Page-1" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">
                              <g id="icon-green" transform="translate(-1072.000000, -129.000000)" class="network">
                                 <path d="M1107.63636,129 C1105.22982,129 1103.27273,130.957091 1103.27273,133.363636 C1103.27273,134.116364 1103.464,134.824727 1103.80073,135.443636 L1096.65236,142.592 C1095.66691,141.824727 1094.43345,141.363636 1093.09091,141.363636 C1091.74836,141.363636 1090.51491,141.824727 1089.52873,142.591273 L1083.95127,137.013818 C1084.20727,136.581091 1084.36364,136.083636 1084.36364,135.545455 C1084.36364,133.941091 1083.05891,132.636364 1081.45455,132.636364 C1079.85018,132.636364 1078.54545,133.941091 1078.54545,135.545455 C1078.54545,137.149818 1079.85018,138.454545 1081.45455,138.454545 C1081.99273,138.454545 1082.49018,138.298182 1082.92291,138.042182 L1088.50036,143.619636 C1087.73382,144.605818 1087.27273,145.839273 1087.27273,147.181818 C1087.27273,148.524364 1087.73382,149.757818 1088.50036,150.743273 L1079.29018,159.954182 C1078.51491,159.250909 1077.49018,158.818182 1076.36364,158.818182 C1073.95709,158.818182 1072,160.775273 1072,163.181818 C1072,165.588364 1073.95709,167.545455 1076.36364,167.545455 C1078.77018,167.545455 1080.72727,165.588364 1080.72727,163.181818 C1080.72727,162.429091 1080.536,161.720727 1080.19927,161.101818 L1089.52945,151.771636 C1090.33382,152.397091 1091.304,152.816 1092.36436,152.949091 L1092.36436,160.338182 C1090.304,160.685818 1088.728,162.477818 1088.728,164.636364 C1088.728,167.042909 1090.68509,169 1093.09164,169 C1095.49818,169 1097.45527,167.042909 1097.45527,164.636364 C1097.45527,162.478545 1095.87927,160.686545 1093.81891,160.338182 L1093.81891,152.949091 C1094.87927,152.816 1095.84945,152.397091 1096.65382,151.771636 L1102.23127,157.349091 C1101.97455,157.782545 1101.81818,158.28 1101.81818,158.818182 C1101.81818,160.422545 1103.12291,161.727273 1104.72727,161.727273 C1106.33164,161.727273 1107.63636,160.422545 1107.63636,158.818182 C1107.63636,157.213818 1106.33164,155.909091 1104.72727,155.909091 C1104.18909,155.909091 1103.69164,156.065455 1103.25891,156.321455 L1097.68145,150.744 C1098.448,149.757818 1098.90909,148.524364 1098.90909,147.181818 C1098.90909,145.839273 1098.448,144.605818 1097.68145,143.620364 L1104.71055,136.591273 C1105.48509,137.294545 1106.50982,137.727273 1107.63636,137.727273 C1110.04291,137.727273 1112,135.770182 1112,133.363636 C1112,130.957091 1110.04291,129 1107.63636,129 Z" id="network"></path>
                              </g>
                           </g>
                        </svg>
                        <div class="dtc-count" id="network_id">
                           <h4> </h4>
                        </div>
                     </div>
                     <div class="text-count">
                        <p>Network</p>
                     </div>
                  </div>
               </div>
               <!-- new J1939 integration -->
               <div class="col-md-3 no-padding-left" id="MILDiv" style="display:none;">
                  <div class="card">
                     <a ><span class="click"></span></a>
                     <div class="dtc-icon">
                        <svg width="40px" height="40px" viewBox="0 0 40 40" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">
                           <!-- Generator: Sketch 41.2 (35397) - http://www.bohemiancoding.com/sketch -->
                           <defs></defs>
                           <g id="Page-1" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">
                              <g id="icon-green" transform="translate(-173.000000, -129.000000)" class="MIL">
                                 <g id="Group-7" transform="translate(39.000000, 105.000000)">
                                    <g id="Group-2" transform="translate(110.000000, 24.000000)">
                                       <g id="Group-10">
                                          <polygon id="power_train" points="54.4348438 12.9445313 54.4348438 0 44.6376563 0 44.6376563 5.16789063 33.7971875 5.16789063 33.7971875 0 24 0 24 12.9445313 33.7971875 12.9445313 33.7971875 7.77664062 37.9130469 7.77664062 37.9130469 32.2233594 33.7971875 32.2233594 33.7971875 27.0554687 24 27.0554687 24 40 33.7971875 40 33.7971875 34.8321094 44.6376563 34.8321094 44.6376563 40 54.4348438 40 54.4348438 27.0554687 44.6376563 27.0554687 44.6376563 32.2233594 40.5217969 32.2233594 40.5217969 7.77664062 44.6376563 7.77664062 44.6376563 12.9445313"></polygon>
                                       </g>
                                    </g>
                                 </g>
                              </g>
                           </g>
                           <!-- <g id="Page-1" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">
                              <g id="icon-green" transform="translate(-1072.000000, -129.000000)" class="MIL">
                                 <path d="M1107.63636,129 C1105.22982,129 1103.27273,130.957091 1103.27273,133.363636 C1103.27273,134.116364 1103.464,134.824727 1103.80073,135.443636 L1096.65236,142.592 C1095.66691,141.824727 1094.43345,141.363636 1093.09091,141.363636 C1091.74836,141.363636 1090.51491,141.824727 1089.52873,142.591273 L1083.95127,137.013818 C1084.20727,136.581091 1084.36364,136.083636 1084.36364,135.545455 C1084.36364,133.941091 1083.05891,132.636364 1081.45455,132.636364 C1079.85018,132.636364 1078.54545,133.941091 1078.54545,135.545455 C1078.54545,137.149818 1079.85018,138.454545 1081.45455,138.454545 C1081.99273,138.454545 1082.49018,138.298182 1082.92291,138.042182 L1088.50036,143.619636 C1087.73382,144.605818 1087.27273,145.839273 1087.27273,147.181818 C1087.27273,148.524364 1087.73382,149.757818 1088.50036,150.743273 L1079.29018,159.954182 C1078.51491,159.250909 1077.49018,158.818182 1076.36364,158.818182 C1073.95709,158.818182 1072,160.775273 1072,163.181818 C1072,165.588364 1073.95709,167.545455 1076.36364,167.545455 C1078.77018,167.545455 1080.72727,165.588364 1080.72727,163.181818 C1080.72727,162.429091 1080.536,161.720727 1080.19927,161.101818 L1089.52945,151.771636 C1090.33382,152.397091 1091.304,152.816 1092.36436,152.949091 L1092.36436,160.338182 C1090.304,160.685818 1088.728,162.477818 1088.728,164.636364 C1088.728,167.042909 1090.68509,169 1093.09164,169 C1095.49818,169 1097.45527,167.042909 1097.45527,164.636364 C1097.45527,162.478545 1095.87927,160.686545 1093.81891,160.338182 L1093.81891,152.949091 C1094.87927,152.816 1095.84945,152.397091 1096.65382,151.771636 L1102.23127,157.349091 C1101.97455,157.782545 1101.81818,158.28 1101.81818,158.818182 C1101.81818,160.422545 1103.12291,161.727273 1104.72727,161.727273 C1106.33164,161.727273 1107.63636,160.422545 1107.63636,158.818182 C1107.63636,157.213818 1106.33164,155.909091 1104.72727,155.909091 C1104.18909,155.909091 1103.69164,156.065455 1103.25891,156.321455 L1097.68145,150.744 C1098.448,149.757818 1098.90909,148.524364 1098.90909,147.181818 C1098.90909,145.839273 1098.448,144.605818 1097.68145,143.620364 L1104.71055,136.591273 C1105.48509,137.294545 1106.50982,137.727273 1107.63636,137.727273 C1110.04291,137.727273 1112,135.770182 1112,133.363636 C1112,130.957091 1110.04291,129 1107.63636,129 Z" id="network"></path>
                              </g                           </g> -->
                        </svg>
                        <div class="dtc-count" id="MIL_id">
                           <h4> </h4>
                        </div>
                     </div>
                     <div class="text-count">
                        <p>Malfunction Indicator Lamp</p>
                     </div>
                  </div>
               </div>
               
               <div class="col-md-3 no-padding-left" id="RSLDiv" style="display:none;">
                  <div class="card">
                     <a ><span class="click"></span></a>
                     <div class="dtc-icon">
                        <svg width="68px" height="30px" viewBox="0 0 68 30" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">
                           <!-- Generator: Sketch 41.2 (35397) - http://www.bohemiancoding.com/sketch -->
                           <defs></defs>
                           <g id="Page-1" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">
                              <g id="icon-green" transform="translate(-456.000000, -138.000000)" class="RSL" >
                                 <g id="chasis" transform="translate(456.000000, 138.000000)">
                                    <g id="Page-1">
                                       <g>
                                          <g>
                                             <g id="Artboard">
                                                <g id="chasis">
                                                   <g id="Page-1">
                                                      <g id="Dashboard_d2">
                                                         <g id="Group-5">
                                                            <g id="Group-7-Copy" transform="translate(0.344717, 0.000000)">
                                                               <g id="Group-6">
                                                                  <g id="chasis">
                                                                     <path d="M56.9791311,21.0419459 C54.7341008,21.0419459 52.8646537,22.6672754 52.5410698,24.8648793 L40.1781753,24.8648793 C39.7953124,23.5634646 38.5696159,22.6384994 37.191636,22.6384994 L28.9518358,22.6384994 C27.5738558,22.6384994 26.3505365,23.563317 25.9652964,24.8648793 L15.6036299,24.8648793 C15.3632448,22.5785863 13.4285758,20.8176404 11.0954441,20.8176404 C8.58714909,20.8176404 6.54625304,22.8459821 6.54625304,25.3410858 C6.54625304,27.8336809 8.58596056,29.860842 11.0954441,29.860842 C13.2655954,29.860842 15.097603,28.3613891 15.5360309,26.2610336 L25.8953203,26.2610336 C26.1477394,27.7436636 27.4242466,28.834054 28.9518358,28.834054 L37.191636,28.834054 C38.7205623,28.834054 39.9945438,27.7448441 40.246963,26.2610336 L52.5517669,26.2610336 C52.9127902,28.4105298 54.7751059,30 56.9777939,30 C59.4667749,30 61.4871685,27.9932034 61.4871685,25.5256951 C61.489694,23.0511036 59.468112,21.0419459 56.9791311,21.0419459 L56.9791311,21.0419459 Z M56.9791311,28.6312936 C55.2509733,28.6312936 53.8477366,27.2361723 53.8477366,25.523334 C53.8477366,23.8032649 55.2509733,22.4093241 56.9791311,22.4093241 C58.7061002,22.4093241 60.1118624,23.8031173 60.1118624,25.523334 C60.1117143,27.2363199 58.7061002,28.6312936 56.9791311,28.6312936 L56.9791311,28.6312936 Z M27.4603489,24.8636988 C27.7659559,24.3395322 28.3262106,24.0072058 28.9518358,24.0072058 L37.191636,24.0072058 C37.8135469,24.0072058 38.3751387,24.3395322 38.6819343,24.8636988 L27.4603489,24.8636988 L27.4603489,24.8636988 Z M37.1928245,27.4618059 L28.9530243,27.4618059 C28.1945782,27.4618059 27.5340393,26.9615456 27.3070254,26.2586725 L38.8401606,26.2586725 C38.6131467,26.9615456 37.9500821,27.4618059 37.1928245,27.4618059 L37.1928245,27.4618059 Z M11.0954441,22.1875273 C12.8441043,22.1875273 14.2691808,23.6018326 14.2691808,25.3399053 C14.2691808,27.0767974 12.8441043,28.488594 11.0954441,28.488594 C9.34678378,28.488594 7.92527301,27.0767974 7.92527301,25.3399053 C7.92527301,23.6005045 9.34678378,22.1875273 11.0954441,22.1875273 L11.0954441,22.1875273 Z" id="Shape"></path>
                                                                     <g id="noun_782065_cc-copy" transform="translate(34.180017, 11.000000) scale(-1, 1) translate(-34.180017, -11.000000) translate(0.180017, 0.000000)">
                                                                        <g id="Group">
                                                                           <g id="Shape" transform="translate(0.000000, 0.451966)">
                                                                              <path d="M66.5576003,11.4209467 L66.5576003,7.65321944 C66.5576003,7.04708306 66.118885,6.533674 65.5226129,6.44026487 C64.0916946,6.21526489 61.5551597,5.79049217 60.4155866,5.43799217 C58.7816099,4.93208307 52.4684563,2.24844671 50.2823503,1.74458307 C48.0955651,1.24071944 38.2360165,-1.44973511 28.792772,1.83662853 C27.194789,2.39231035 20.0062422,5.84231035 15.7793631,7.636174 C14.5345255,7.66344669 2.21314579,10.2420831 1.55711025,12.0093558 C0.901074707,13.7773104 0.695299587,14.6350376 0.574415192,15.083674 C0.453530796,15.5323104 0.574415192,17.6793558 1.48987679,19.1745831 C2.42299567,19.7043558 4.21928345,20.0602649 6.29605019,20.2989012 C6.27228081,20.1714012 6.24647399,20.0459467 6.230175,19.9170831 C6.19418133,19.6416286 6.17720318,19.3900376 6.17720318,19.1500376 C6.17720318,15.7784467 8.90864723,13.0348104 12.2676035,13.0348104 C15.6265598,13.0348104 18.3580039,15.7777649 18.3580039,19.1500376 C18.3580039,19.3232194 18.3464587,19.4950376 18.3335553,19.6641286 C18.3016364,20.0425376 18.2337238,20.4100376 18.1352506,20.7639012 L18.1515496,20.7639012 L48.3835145,20.1529922 C48.3699319,20.0745831 48.3522747,19.9968558 48.3420878,19.9170831 C48.3060941,19.6429922 48.289116,19.3907194 48.289116,19.1500376 C48.289116,15.7784467 51.02056,13.0354922 54.3795163,13.0354922 C57.7384726,13.0354922 60.4705958,15.7777649 60.4705958,19.1500376 C60.4705958,19.1629922 60.4692375,19.1739012 60.4685584,19.186174 L60.5975923,19.1752649 L65.7664188,18.1982194 C65.7664188,18.1982194 67.7460706,17.1400376 67.7460706,14.228674 C67.7467496,12.2868558 66.5576003,11.4209467 66.5576003,11.4209467 L66.5576003,11.4209467 Z M36.5680835,7.84890125 L25.2776168,8.19594669 C25.4854293,6.49753763 24.4837187,6.11640126 24.4837187,6.11640126 C28.9720612,2.02617399 38.0180171,1.88776489 38.0180171,1.88776489 L36.5680835,7.84890125 L36.5680835,7.84890125 Z M49.239213,7.33003762 L38.9504569,7.67708306 L39.8828966,1.88844671 C45.2004518,1.81890126 48.2381815,2.99708307 48.2381815,2.99708307 L49.757386,5.45844671 L49.239213,7.33003762 L49.239213,7.33003762 Z M55.0396266,7.29458306 L52.1730365,7.29458306 L49.3071256,3.34344671 C51.4572379,4.20253762 53.1781427,5.04935581 54.2029436,5.58458307 C54.8250229,5.90912853 55.1645857,6.60253762 55.0396266,7.29458306 L55.0396266,7.29458306 Z" id="body"></path>
                                                                           </g>
                                                                        </g>
                                                                     </g>
                                                                  </g>
                                                               </g>
                                                            </g>
                                                         </g>
                                                      </g>
                                                   </g>
                                                </g>
                                             </g>
                                          </g>
                                       </g>
                                    </g>
                                 </g>
                              </g>
                           </g>
                        </svg>
                        <div class="dtc-count" id="RSL_id">
                           <h4> </h4>
                        </div>
                     </div>
                     <div class="text-count">
                        <p>Red Stop Lamp </p>
                     </div>
                  </div>
               </div>
               
               <div class="col-md-3 no-padding-left" id="AWLDiv" style="display:none;">
                  <div class="card">
                     <a ><span class="click"></span></a>
                     <div class="dtc-icon">
                         <svg width="66px" height="21px" viewBox="0 0 66 21" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">
                           <!-- Generator: Sketch 41.2 (35397) - http://www.bohemiancoding.com/sketch -->
                           <title>body</title>
                           <desc>Created with Sketch.</desc>
                           <defs></defs>
                           <g id="Page-1" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">
                              <g id="icon-green" transform="translate(-758.000000, -145.000000)" class="AWL">
                                 <g id="body" transform="translate(758.000000, 145.000000)">
                                    <g id="Page-1">
                                       <g>
                                          <g>
                                             <g id="Artboard">
                                                <g id="body">
                                                   <g id="Group">
                                                      <path d="M64.8329395,11.4190861 L64.8329395,7.57460034 C64.8329395,6.95611539 64.4021271,6.43224683 63.8165961,6.33693476 C62.411455,6.10735088 59.9206145,5.67392443 58.8015698,5.31424307 C57.1970286,4.79802731 50.9976024,2.05971826 48.8508777,1.5455896 C46.7034862,1.03146094 37.0215513,-1.7138052 27.748421,1.63951026 C26.1792246,2.20651277 19.1201751,5.72679828 14.9694407,7.55720761 C13.747028,7.58503599 1.6476104,10.2162059 1.00339293,12.0194826 C0.359175471,13.823455 0.15710726,14.6986564 0.0384005224,15.1564327 C-0.0803062152,15.6142089 0.0384005224,17.8049953 0.937370645,19.3306843 C1.85367996,19.8712498 3.61760873,20.2344098 5.65696379,20.4779078 C5.63362257,20.3478102 5.60828072,20.2197999 5.5922753,20.088311 C5.55693005,19.8072447 5.54025772,19.5505282 5.54025772,19.3056388 C5.54025772,15.8653597 8.22249647,13.0658283 11.5209432,13.0658283 C14.81939,13.0658283 17.5016288,15.864664 17.5016288,19.3056388 C17.5016288,19.4823488 17.4902916,19.6576673 17.4776207,19.830203 C17.4462767,20.2163213 17.3795876,20.5913083 17.2828882,20.952381 L17.2988937,20.952381 L46.9862483,20.3290261 C46.9729105,20.2490197 46.9555713,20.1697089 46.9455679,20.088311 C46.9102227,19.8086361 46.8935503,19.5512239 46.8935503,19.3056388 C46.8935503,15.8653597 49.5757891,13.0665241 52.874236,13.0665241 C56.1726824,13.0665241 58.8555882,15.864664 58.8555882,19.3056388 C58.8555882,19.3188572 58.8542546,19.3299886 58.8535878,19.3425113 L58.9802968,19.33138 L64.0560106,18.3344296 C64.0560106,18.3344296 65.9999997,17.2546898 65.9999997,14.2840141 C66.000667,12.302636 64.8329395,11.4190861 64.8329395,11.4190861 L64.8329395,11.4190861 Z M35.7314635,7.51133348 L24.370298,7.85714289 C24.5794118,6.16478293 23.5714287,5.78500405 23.5714287,5.78500405 C28.0878763,1.7093447 37.1904763,1.57142858 37.1904763,1.57142858 L35.7314635,7.51133348 L35.7314635,7.51133348 Z M47.7132774,6.98806719 L38.2380954,7.33333336 L39.0968033,1.57437538 C43.9938776,1.50518649 46.7914017,2.67732776 46.7914017,2.67732776 L48.1904764,5.12607197 L47.7132774,6.98806719 L47.7132774,6.98806719 Z M53.4028824,6.80952384 L50.5344349,6.80952384 L47.6666668,2.61904763 C49.8181725,3.53017792 51.5401924,4.42829206 52.5656572,4.99594069 C53.1881399,5.34014545 53.5279226,6.07555779 53.4028824,6.80952384 L53.4028824,6.80952384 Z" id="body"></path>
                                                   </g>
                                                </g>
                                             </g>
                                          </g>
                                       </g>
                                    </g>
                                 </g>
                              </g>
                           </g>
                        </svg>
                        <div class="dtc-count" id="AWL_id">
                           <h4> </h4>
                        </div>
                     </div>
                     <div class="text-count">
                        <p>Amber Warning Lamp</p>
                     </div>
                  </div>
               </div>
               
                <div class="col-md-3 no-padding-left" id="PLDiv" style="display:none;">
                  <div class="card">
                     <a ><span class="click"></span></a>
                     <div class="dtc-icon">
                         <svg width="40px" height="40px" viewBox="0 0 40 40" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">
                           <!-- Generator: Sketch 41.2 (35397) - http://www.bohemiancoding.com/sketch -->
                           <defs></defs>
                           <g id="Page-1" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">
                              <g id="icon-green" transform="translate(-1072.000000, -129.000000)" class="PL">
                                 <path d="M1107.63636,129 C1105.22982,129 1103.27273,130.957091 1103.27273,133.363636 C1103.27273,134.116364 1103.464,134.824727 1103.80073,135.443636 L1096.65236,142.592 C1095.66691,141.824727 1094.43345,141.363636 1093.09091,141.363636 C1091.74836,141.363636 1090.51491,141.824727 1089.52873,142.591273 L1083.95127,137.013818 C1084.20727,136.581091 1084.36364,136.083636 1084.36364,135.545455 C1084.36364,133.941091 1083.05891,132.636364 1081.45455,132.636364 C1079.85018,132.636364 1078.54545,133.941091 1078.54545,135.545455 C1078.54545,137.149818 1079.85018,138.454545 1081.45455,138.454545 C1081.99273,138.454545 1082.49018,138.298182 1082.92291,138.042182 L1088.50036,143.619636 C1087.73382,144.605818 1087.27273,145.839273 1087.27273,147.181818 C1087.27273,148.524364 1087.73382,149.757818 1088.50036,150.743273 L1079.29018,159.954182 C1078.51491,159.250909 1077.49018,158.818182 1076.36364,158.818182 C1073.95709,158.818182 1072,160.775273 1072,163.181818 C1072,165.588364 1073.95709,167.545455 1076.36364,167.545455 C1078.77018,167.545455 1080.72727,165.588364 1080.72727,163.181818 C1080.72727,162.429091 1080.536,161.720727 1080.19927,161.101818 L1089.52945,151.771636 C1090.33382,152.397091 1091.304,152.816 1092.36436,152.949091 L1092.36436,160.338182 C1090.304,160.685818 1088.728,162.477818 1088.728,164.636364 C1088.728,167.042909 1090.68509,169 1093.09164,169 C1095.49818,169 1097.45527,167.042909 1097.45527,164.636364 C1097.45527,162.478545 1095.87927,160.686545 1093.81891,160.338182 L1093.81891,152.949091 C1094.87927,152.816 1095.84945,152.397091 1096.65382,151.771636 L1102.23127,157.349091 C1101.97455,157.782545 1101.81818,158.28 1101.81818,158.818182 C1101.81818,160.422545 1103.12291,161.727273 1104.72727,161.727273 C1106.33164,161.727273 1107.63636,160.422545 1107.63636,158.818182 C1107.63636,157.213818 1106.33164,155.909091 1104.72727,155.909091 C1104.18909,155.909091 1103.69164,156.065455 1103.25891,156.321455 L1097.68145,150.744 C1098.448,149.757818 1098.90909,148.524364 1098.90909,147.181818 C1098.90909,145.839273 1098.448,144.605818 1097.68145,143.620364 L1104.71055,136.591273 C1105.48509,137.294545 1106.50982,137.727273 1107.63636,137.727273 C1110.04291,137.727273 1112,135.770182 1112,133.363636 C1112,130.957091 1110.04291,129 1107.63636,129 Z" id="network"></path>
                              </g>
                           </g>
                        </svg>
                        <div class="dtc-count" id="PL_id">
                           <h4> </h4>
                        </div>
                     </div>
                     <div class="text-count">
                        <p>Protect Lamp</p>
                     </div>
                  </div>
               </div>
            </div>
         </div>
      </section>
	  
	   <div class="clearfix"></div>
	  <div class="diag-icons" id="repeat">
			
	  
	  
	  </div>
	
	  
	  
	  
	  
	    <script language="javascript">
		$(function() {
    		$.ajax({
        	url: '<%=request.getContextPath()%>/OBDAction.do?param=getVehicleUser',
        	success: function(result) {
            var vehicleNo = JSON.parse(result);
            
            $( "#search" ).autocomplete({
     	  		source: vehicleNo
    	  	});
          	}  
  			});
   	  	});
<!--   	  	if('<%=pageName%>' == 'liveVision'){-->
<!--   	  		document.getElementById('back_id').style.visibility = 'hidden';-->
<!--   	  	}else{-->
<!--   	  		document.getElementById('back_id').style.visibility = 'visible';-->
<!--   	  	}-->
   	  	function loadData(){
   	  		loadRecords('<%=vehicleNo%>');
   	  	}
   	  	function loadDataOnSearch(){
			document.getElementById("repeat").innerHTML="";  // flushing already existing html data before rending latest data
			loadRecords(document.getElementById('search').value);
			
		}
		function loadRecords(vehicleNo){
			$('#titleId').text("VEHICLE DIAGNOSTIC ("+vehicleNo+")");
			//Ignition Status
   	  		$.ajax({
        	url: '<%=request.getContextPath()%>/OBDAction.do?param=getIgnitionStatus',
        	data: {
        		vehicleNo: vehicleNo
        	},
        	success: function(result) {
            	if(result != ""){
            		//$('#ignitionId').text("Ignition Status : "+result);
            	}
            }	
			});	
			//Ignition Status GMT
				$.ajax({
        	url: '<%=request.getContextPath()%>/OBDAction.do?param=getIgnitionStatus1',
        	data: {
        		vehicleNo: vehicleNo
        	},
        	success: function(result) {
            	if(result != ""){
            		$('#ignitionId1').text("OBD Date  : "+result);
            	}
            }	
			});	
			
			//Error code details
   	  		$.ajax({
        	url: '<%=request.getContextPath()%>/OBDAction.do?param=getErrorCodeDetailsForDiagnostic',
        	data: {
        		vehicleNo: vehicleNo
        	},
        	success: function(result) {
            	errorList = JSON.parse(result);
            	var isJ1939 = errorList["errorCodeDetailsRoot"][0].isJ1939;
            	var flag = errorList["errorCodeDetailsRoot"][0].flag;
            	if(isJ1939=='0'&&flag==true){
            			document.getElementById("DTCHeaderMessage").style.display='none';
            			
            		document.getElementById('powerTrainDiv').style.display='block';
					document.getElementById('ChassisDiv').style.display='block';
					document.getElementById('BodyDiv').style.display='block';
					document.getElementById('NetworkDiv').style.display='block';
					
					document.getElementById('MILDiv').style.display='none';
					document.getElementById('RSLDiv').style.display='none';
					document.getElementById('AWLDiv').style.display='none';
					document.getElementById('PLDiv').style.display='none';
            			
		            	var powerTrain = errorList["errorCodeDetailsRoot"][0].powerTrain;
		            	var chasis = errorList["errorCodeDetailsRoot"][0].chasis;
		            	var body = errorList["errorCodeDetailsRoot"][0].body;
		            	var network = errorList["errorCodeDetailsRoot"][0].network;
		            	if(powerTrain == "NA"){
		            		$("#powerTrain").text("");
		               		$(".powerTrain").attr('id','icon-green');
		            	}else{
		            		$("#powerTrain").text(powerTrain);
		               		$(".powerTrain").attr('id','icon-red');
		            	}
		            	if(chasis == "NA"){
		            		$("#chasis_id").text("");
		            		$(".chasis").attr('id','icon-green');
		            	}else{
		            		$("#chasis_id").text(chasis);
		            		$(".chasis").attr('id','icon-red');	
		            	}
		            	if(network == "NA"){
		            		$("#network_id").text("");
		            		$(".network").attr('id','icon-green');
		            	}else{
		            		$("#network_id").text(network);
		            		$(".network").attr('id','icon-red');
		            	}
		            	if(body == "NA"){
		            		$("#body_id").text("");
		            		$(".body").attr('id','icon-green');
		            	}else{
		            		$("#body_id").text(body);
		            		$(".body").attr('id','icon-red');
		            	}
            	}else if(isJ1939=='1'&&flag==true){
            		document.getElementById("DTCHeaderMessage").style.display='none';
            		var MIL = errorList["errorCodeDetailsRoot"][0].MIL;
	            	var RSL = errorList["errorCodeDetailsRoot"][0].RSL;
	            	var AIL = errorList["errorCodeDetailsRoot"][0].AIL;
	            	var PL = errorList["errorCodeDetailsRoot"][0].LP;
	            	
            		document.getElementById('powerTrainDiv').style.display='none';
					document.getElementById('ChassisDiv').style.display='none';
					document.getElementById('BodyDiv').style.display='none';
					document.getElementById('NetworkDiv').style.display='none';
					
					document.getElementById('MILDiv').style.display='block';
					document.getElementById('RSLDiv').style.display='block';
					document.getElementById('AWLDiv').style.display='block';
					document.getElementById('PLDiv').style.display='block';
					if(MIL=="NA"){
            		$("#MIL_id").text("");
               		$(".MIL").attr('id','icon-green');
	            	}else{
	            		$("#MIL_id").text(MIL);
	               		$(".MIL").attr('id','icon-red');
	            	}
					if(RSL=="NA"){
            		$("#RSL_id").text("");
               		$(".RSL").attr('id','icon-green');
	            	}else{
	            		$("#RSL_id").text(RSL);
	               		$(".RSL").attr('id','icon-red');
	            	}
	            	if(AIL=="NA"){
            		$("#AWL_id").text("");
               		$(".AWL").attr('id','icon-green');
	            	}else{
	            		$("#AWL_id").text(AIL);
	               		$(".AWL").attr('id','icon-red');
	            	}
	            	if(PL=="NA"){
            		$("#PL_id").text("");
               		$(".PL").attr('id','icon-green');
	            	}else{
	            		$("#PL_id").text(PL);
	               		$(".PL").attr('id','icon-red');
	            	}
            	}else if(isJ1939=='0'&&flag==false){
            		document.getElementById("DTCHeaderMessage").style.display='block';
            		document.getElementById('powerTrainDiv').style.display='none';
					document.getElementById('ChassisDiv').style.display='none';
					document.getElementById('BodyDiv').style.display='none';
					document.getElementById('NetworkDiv').style.display='none';
					
					document.getElementById('MILDiv').style.display='none';
					document.getElementById('RSLDiv').style.display='none';
					document.getElementById('AWLDiv').style.display='none';
					document.getElementById('PLDiv').style.display='none';
            	}
            }
            });	
			
			 //Alert Details	
   	  		$.ajax({
        	url: '<%=request.getContextPath()%>/OBDAction.do?param=getVehicleDiagnosticDeatails',
        	data: {
        		vehicleNo: vehicleNo
        	},
        	success: function(result) {
				document.getElementById("repeat").innerHTML="";  // flushing already existing html data before rending latest data
            	pendingList = JSON.parse(result);
				
				
            	if(pendingList["vehicleDiagnosisDetailsRoot"].length > 0){
					
					
            		for(var i = 0; i < pendingList["vehicleDiagnosisDetailsRoot"].length; i++){
						
						var temp;
						
						 if(pendingList["vehicleDiagnosisDetailsRoot"][i].color=='icon-green') 
						 temp =  '<img src="../../Main/resources/images/obd/'+pendingList["vehicleDiagnosisDetailsRoot"][i].id+'.png" alt="user">'  ;
						else if(pendingList["vehicleDiagnosisDetailsRoot"][i].color=='icon-red')
						temp =	' <img src="../../Main/resources/images/obd/'+pendingList["vehicleDiagnosisDetailsRoot"][i].id+'_red.png" alt="user">'
						
						var html = $( 
									
					 '<div class="diag-items">' +
                        '<div class="diag-img margin-top">' +

						temp +
					
                       '</div>' +
                       '<div class="diag-txt">' +
                          '<p class="line-height">'+pendingList["vehicleDiagnosisDetailsRoot"][i].paramName+'</p>' +
						'</div>' +
						
						 
						
                         '<div class="diag-status">' +
                          '<p>'+pendingList["vehicleDiagnosisDetailsRoot"][i].value+'</p>' +
                         '</div>' +
                       '</div>'  
					   
					   );
                  

						var $html=$(html);
						//$html.attr('name', 'email'+i);
						$('#repeat').append($html);
           			}
            	}else{
					
					var html = $( 
									
					 '<div class="diag-items">' +
                        '<div class="diag-img margin-top">' +



					
                       '</div>' +
                       '<div class="diag-txt">' +
                          '<p class="line-height">Please Specify the Model for this Vehicle</p>' +
						'</div>' +
						
						 
						
                         
                       '</div>'  
					   
					   );
					   
					   var $html=$(html);
						//$html.attr('name', 'email'+i);
						$('#repeat').append($html);
            	}
        	}
    		});
		}	
		
	setInterval(function () {
		if(document.getElementById('search').value == ""){
			loadData()
		}else{
			loadDataOnSearch()
		}
	}, 60000);// 1 min interval	
		// 1 min interval
	
	function gotoBack(){
		if('<%=pageName%>' == 'liveVision'){
			if(<%=loginInfo.getSystemId()%> == 268){
				window.location ="<%=request.getContextPath()%>/Jsps/GeneralVertical/LiveVision.jsp";
			} else {
				window.location ="<%=request.getContextPath()%>/Jsps/Common/ListView.jsp";
			}
		}else if('<%=pageName%>' == 'liveVisionNew'){
			window.location ="<%=request.getContextPath()%>/Jsps/Common/LiveVisionWithTableData.jsp";
		}else{
			if('<%=Status%>' == '0'){
				window.location ="<%=request.getContextPath()%>/Jsps/OBD/ShowDataInPopUp.jsp?altCardId="+'<%=pageName%>';
			}else{
				window.location ="<%=request.getContextPath()%>/Jsps/OBD/ShowDataInPopUp.jsp?altCardId="+'<%=pageName%>'+"&vehNo="+'<%=vehicleNo%>';
			}
		}
	}
	function gotoDashBoard(){
		window.location ="<%=request.getContextPath()%>/Jsps/OBD/obd_dash3.jsp";
	}
	function refreshPage(){
		if(document.getElementById('search').value == ""){
			loadData()
		}else{
			loadDataOnSearch()
		}
	}
	
	
	
	
	  </script>	
	  
	  </body>
</html>