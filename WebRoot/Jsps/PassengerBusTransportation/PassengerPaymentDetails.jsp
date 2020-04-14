<%@ page  language="java" 
import="java.util.*,t4u.functions.*,t4u.beans.*,t4u.common.*" pageEncoding="utf-8"%>
<%@ taglib uri="http://packtag.sf.net" prefix="pack" %>
<%

	String path = request.getContextPath();
	String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path + "/";
    String book = "Book Now >>";	
	String roundtrip = "false";
	String seatNo = "";
	String tempId1 = "";
	String tempId2 = "";
	String rateId1 = "";
	String serviceId1 = "";
	String journeydate1 = "";
	String dedicatedSeatnumbers1 = "";
	String rateId2 = "";
	String serviceId2 = "";
	String journeydate2 = "";
	String dedicatedSeatnumbers2 = "";	
	String terminalid1 = "";
	String terminalid2 = "";
	String triptype ="";
	String detailslist1 = "";
	String detailslist2 = "";
	HashMap < String, String > tempdetails = null;		
	String passangerCompnt = "";
	String journeyDetailsCompnt = "";
	int totalamount =0;
	int userId = 0;
	int customerId = 0;
	int systemId  = 0;	
	HashMap < String, String > journeyDetailsCompnts = null;
	HashMap < String, String > verticalComponents = null;
	PassengerBusTransportationFunctions func = new PassengerBusTransportationFunctions();
	session = request.getSession();
	LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");	
	if(loginInfo != null ){
	customerId = loginInfo.getCustomerId();
	systemId = loginInfo.getSystemId();
	userId = loginInfo.getUserId();	
	}else{
	Properties properties = ApplicationListener.prop;
    customerId =Integer.parseInt(properties.getProperty("customerID").trim()) ;
    systemId = Integer.parseInt(properties.getProperty("systemID").trim());
    userId = 0;
	}	

	
if(!request.getParameter("TripType").equals("") && request.getParameter("TripType") != null){	
triptype = request.getParameter("TripType"); 
}
if(!request.getParameter("TempId1").equals("")&& request.getParameter("TempId1")!=null){
tempId1=request.getParameter("TempId1"); 
}
if(!request.getParameter("TempId2").equals("") && request.getParameter("TempId2") !=null){
tempId2 = request.getParameter("TempId2"); 
}
if(triptype.equals("0")){
roundtrip = "false";
}else{
roundtrip = "true";
}
if(!triptype.equals("")&& triptype!=null && !tempId1.equals("") && tempId1!=null && !tempId2.equals("") && tempId2!=null )
{
	tempdetails = func.gettempdetails(tempId1, tempId2,triptype);	

	
	if (tempdetails.get("seatNo") != null && !tempdetails.get("seatNo").equals("")) {
		seatNo = tempdetails.get("seatNo");
	}
	if (tempdetails.get("rateId1") != null && !tempdetails.get("rateId1").equals("") ) {
		rateId1 = tempdetails.get("rateId1");
	}
	if (tempdetails.get("serviceId1") != null && !tempdetails.get("serviceId1").equals("") ) {
		serviceId1 = tempdetails.get("serviceId1");
	}
	if (tempdetails.get("journeydate1") != null && !tempdetails.get("journeydate1").equals("") ) {
		journeydate1 = tempdetails.get("journeydate1");
	}
	if (tempdetails.get("dedicatedSeatnumbers1") != null && !tempdetails.get("dedicatedSeatnumbers1").equals("")) {
		dedicatedSeatnumbers1 = tempdetails.get("dedicatedSeatnumbers1");
	}
	if (tempdetails.get("terminalid1") != null && !tempdetails.get("terminalid1").equals("") ) {
		terminalid1 = tempdetails.get("terminalid1");
	}
		if (tempdetails.get("rateId2") != null && !tempdetails.get("rateId2").equals("") ) {
		rateId2 = tempdetails.get("rateId2");
	}
	if (tempdetails.get("serviceId2") != null && !tempdetails.get("serviceId2").equals("") ) {
		serviceId2 = tempdetails.get("serviceId2");
	}
	if (tempdetails.get("journeydate2") != null && !tempdetails.get("journeydate2").equals("") ) {
		journeydate2 = tempdetails.get("journeydate2");
	}
	if (tempdetails.get("dedicatedSeatnumbers2") != null && !tempdetails.get("dedicatedSeatnumbers2").equals("") ) {
		dedicatedSeatnumbers2 = tempdetails.get("dedicatedSeatnumbers2");
	}
	if (tempdetails.get("terminalid2") != null && !tempdetails.get("terminalid2").equals("") ) {
		terminalid2 = tempdetails.get("terminalid2");
	}	
	
	detailslist1 = rateId1 + "," + serviceId1 + "," + journeydate1 + "," + dedicatedSeatnumbers1 + "," +terminalid1 ;
	detailslist2 = rateId2 + "," + serviceId2 + "," + journeydate2 + "," + dedicatedSeatnumbers2 + "," +terminalid2;
   
   if( !seatNo.equals("")&& seatNo!=null &&  !serviceId1.equals("")&& serviceId1!=null && !rateId1.equals("")&& rateId1!=null && !dedicatedSeatnumbers1.equals("")&& dedicatedSeatnumbers1!=null && !journeydate1.equals("")&& journeydate1!=null){
	verticalComponents = func.getPassengerComponents(Integer.parseInt(seatNo));	
	if(roundtrip.equals("true")){
	if(!serviceId2.equals("")&& serviceId2!=null && !rateId2.equals("")&& rateId2!=null && !dedicatedSeatnumbers2.equals("")&& dedicatedSeatnumbers2!=null && !journeydate2.equals("")&& journeydate2!=null ){	
	journeyDetailsCompnts = func.getJourneyComponentsForRoundTrip( Integer.parseInt(seatNo), Integer.parseInt(serviceId1), Integer.parseInt(rateId1),dedicatedSeatnumbers1, journeydate1,Integer.parseInt(serviceId2), Integer.parseInt(rateId2), dedicatedSeatnumbers2, journeydate2,Integer.parseInt(terminalid1),Integer.parseInt(terminalid2),systemId,customerId);		
	}
	}else{
	journeyDetailsCompnts = func.getJourneyComponents(Integer.parseInt(serviceId1), Integer.parseInt(rateId1), Integer.parseInt(seatNo), dedicatedSeatnumbers1, journeydate1,Integer.parseInt(terminalid1),systemId,customerId);	
	
	}
	if (verticalComponents.get("verticalComponents") != null) {
		passangerCompnt = verticalComponents.get("verticalComponents");
	}
	if (journeyDetailsCompnts.get("journeyDetailsCompnts") != null) {

		journeyDetailsCompnt = journeyDetailsCompnts.get("journeyDetailsCompnts");
		totalamount = Integer.parseInt(journeyDetailsCompnts.get("totalamount"));
	}
	}
	
}	
 if(tempdetails.equals("")||journeyDetailsCompnt.equals("")||passangerCompnt.equals("")){

response.sendRedirect(request.getContextPath() + "/Jsps/PassengerBusTransportation/SeatSelection.jsp?");
} else{%> 
 <!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
 <html lang="true">
 <head>
<title>Payment Details</title>

  <meta http-equiv="pragma" content="no-cache">
  <meta http-equiv="cache-control" content="no-cache">
  <meta http-equiv="expires" content="0">
  <meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
  <meta http-equiv="description" content="This is my page">
  <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
	
 <link rel="stylesheet" href="//code.jquery.com/ui/1.11.4/themes/smoothness/jquery-ui.css"> 
 <script src="../../Main/Js/jquery.js"></script>
 <script src="../../Main/Js/jquery-ui.js"></script> 
 <pack:style src="../../Main/resources/css/ticketBooking.css" /> 
 <pack:script src="../../Main/adapter/ext/ext-base.js"></pack:script>
 <pack:script src="../../Main/Js/ext-all-debug.js"></pack:script>                          
 <pack:style src="../../Main/resources/css/ext-all.css" />
 <pack:script src="../../Main/Js/examples1.js"></pack:script>
 <pack:style src="../../Main/resources/css/examples1.css" />
 <pack:script src="../../Main/Js/jquery.min.js"></pack:script>
 <pack:script src="../../Main/Js/jquery-ui.js"></pack:script>
 <pack:script src="../../Main/Js/dropDown.js"></pack:script>	

<style>
.x-form-text,
.x-form-textarea,
.x-combo-list {
    direction: ltr;
}

#outerpanel {
    background-color: #FFFFFF;
    width: 98% !Important; 
    -webkit-box-shadow: 1px 1px 3px #cac4ab;
    box-shadow: 1px 1px 3px #cac4ab;
    margin: 1%;
    position: relative;                                    
    }
 
</style>
</head>	
<body onunload = deletetempdata();>
<div id="outerpanel">
    <div id = "mainpanel" > 
 
	    <div id="loadingMessage" style="display:none;" >Please Wait...</div>
        <h5 class = 'firstHeading' > Book Your Ticket Here </h5>
        <div class = 'istructions'>
            <h5>please complete your booking within  
                <span class='timer' id="time"></span> minutes!
            </h5>
        </div>
        <div id = "wrapper">
       
        <div id="myDialog" ><div id="myDialogText"></div></div>
         
            <div id="leftcolumn">
                <br></br><%=passangerCompnt%>          
                <div class = 'Paymentdetails'>
                    <label>Payment Options</label>
                </div>
                <div class = "innerleftcolumn">
                    <ul id="menu">
                           <li>
                            <a href="#5" name="5" onclick="return showcashcouponblock();"  id = 'cashbox'>
                             <label class = "cashboxlabel" >Prepaid Card >> </label>
                            </a>
                        </li>
                           <li>
                            <a href="#1" name="1" onclick="return showcancelcouponblock();" id = 'cancelcoupon'>
                               Coupon Code >>
                            </a>
                        </li>
                       <%if( userId > 0 ){ %>
                        <li>
                            <a  href="#4" name="4" onclick="return showdirectcashlock();" id = 'directcash' >
                                <label class = "directcashlabel" >Cash >> </label>
                            </a>
                        </li> 
                       
                        <% } else{ %>
                       
                         <li>
                            <a  href="#3" name="3" onclick="return showdebiitblock();" id = 'debitbox' >
                                <label class = "debitcardlabel" >Other Cards >> </label>
                            </a>
                        </li>  
                        <% } %>                    
                      
                    </ul>
                </div>
                <div class = "innerrightcolumn">
                        <div id = 'payableAmount' class = "grandtotal">
                    <label >Payable Amount : NGN <%=totalamount%>
                    </label>
                </div>
                    <!--Payment Istruction Starts From Here -->
                    <div id = 'paymentIstructions'  class = 'paymentModeIstructions'>                 
                         <br></br>                                  
                        <label class = 'paymentModeIstructions'>Please Select Any Paymnet Mode To Complete Your Booking</label>
                        <br></br>                       
                        <br></br>
                       
                    </div>
                    <!--Payment Istruction Ends Here -->
                    <!--cash coupon block starts -->
                    <div id ='cashcoupondiv' style="display:none;">
                        <br></br>
                        <label class= 'couponcodelabel' >
                            <span class = 'required' >*</span>Enter Card Number:
                        </label>
                        <input id = 'couponcodeid' type='text' placeholder = 'Enter Card Number' onchange='Call(this)' class ='couponcodeboxsize' ></input>
                        <br></br>
                        <label class= 'emailidlabel'>
                            <span class = 'required' >*</span>Enter Email Id:
                        </label>
                        <input id = 'couponreferenceid' type='text'  placeholder = 'Enter Email Id' onchange='Call(this)' class ='couponcodeboxsize' ></input>
                        <br></br>
                        <br></br>
                        
                        <div id = 'showinsufficientbalance' style = "display:none;">
                            <label class = 'textcolor' >Your Coupon Balance Is Insufficeint. Please Select Any Other Payment Mode. </label>
                            <br></br>
                            <label class = 'textcolor'>Amount Need To Pay  : NGN <%=totalamount%>
                            </label>
                            <br></br>
                            <label class = 'textcolor' id = 'deductedamountlabel'></label>
                            <br></br>
                            <label class = 'textcolor' id = 'remaingamountlabel'></label>
                            <br></br>
                            <button type="button" id='proceed' class = 'cashcouponOk'onclick="proceedAction()">Proceed</button>
                            <button type="button" id='notnow' class = 'cashcouponNo'onclick="notnowAction()">Not Now</button>
                        <br></br>
                        </div>
                        <div id = 'invalidatecoupon' style = "display:none;">
                            <label class = 'inavalidcouponclass'>Entered Prepaid Card Or Email ID Is Invalid!!</label>
                        <br></br>
                        </div>
                        <div id='checkbox' style="display:none; margin-bottom:10px;" class = 'checkboxcss'>
                        <input id = "checkboxx" type="checkbox" name="termscondition" value="">I have read the terms & conditions of payment and agree to comply<br></div>
                        
                        <div id = 'okcancelbutton' style = "display:none" >
                            <button type="button" id='couponcode' class = 'cashcouponOk'onclick="checkcashcouponamount()">Book Now</button>
                            <button type="button" id='couponrefID' class = 'cashcouponNo'onclick="hidecashcouponblock()">Cancel</button>
                            <br></br>
                        </div>
                    </div>
                    <div id = 'proceedwithcouponAndOtherOption' style = "display:none;">
                        <br></br>
                        <label class = 'textcolor' id = 'deductedamountlabelforProceedAction'></label>
                        <br></br>
                        <label class = 'textcolor' id = 'remaingamountlabelforProceedAction'></label>
                        <br></br>
                    </div>
                    
                    <!--cash coupon block ends -->
                   
                    <!--debit card block starts -->
                    <div id ='debitcarddiv' style="display:none;">
                        <div id = 'cardtypelogos' class = 'firsttypelogo'>
                              <img src="/ApplicationImages/PaymentGatewayLogos/mastercard.gif" alt="mastercard" style="width:80px;height:40px; padding-bottom:10px; padding-top:20px; padding-left:25px;">                          
                              <img src="/ApplicationImages/PaymentGatewayLogos/logo_visa.gif" alt="visa" style="width:80px;height:40px; padding-bottom:10px; padding-top:20px; padding-left:0px;">
                              <img src="/ApplicationImages/PaymentGatewayLogos/verve_new.png" alt="verve" style="width:80px;height:45px;padding-bottom:10px; padding-top:20px">
                              <img src="/ApplicationImages/PaymentGatewayLogos/Interswitch.png" alt="Interswitch" style="width:80px;height:45px;padding-bottom:10px; padding-top:20px">
                                        
                                                </div>
                                                <br></br>
                                                
                                            </div>
                                            <!--debit card block ends -->  
                                            
                                   <!--  direct cash block starts  here-->
                                   
                             <div id ='directcashdiv' style="display:none;">
                        <br></br>
                        <label class= 'couponcodelabel' >
                            <span class = 'required' >*</span>Enter Cash Amount:
                        </label>
                        <input id = 'directcashid' type='text' placeholder = 'Enter Cash Amount' onchange='Call(this)' onkeypress='return isNumber(event)' class ='couponcodeboxsize' ></input>
                        
                        <br></br>
                        <br></br>
                        
                    
                       
                        <div id='cashcheck' style="display:none; margin-bottom:10px;" class = 'checkboxcss'>
                        <input id = "cashcheckbox" type="checkbox" name="termscondition" value="">I have read the terms & conditions of payment and agree to comply<br></div>
                        
                        <div id = 'okcancelbuttonfordirectcash' style = "display:none" >
                            <button type="button" id ='cashbook'  class = 'cashcouponOk'onclick="checkdirectcashamount()">Book Now</button>
                            <button type="button"  class = 'cashcouponNo'onclick="hidedirectcashblock()">Cancel</button>
                            <br></br>
                        </div>
                    </div>
                                   
                                  <!--          direct cash block ends here  -->
                                                                                                          
                                          <!--  coupon code starts here          -->
                                          <div id ='cancelcoupondiv' style="display:none;">
                        <br></br>
                        <label class= 'couponcodelabelbox'>
                            <span class = 'required' >*</span>Enter Coupon Code:
                        </label>
                        <input id = 'couponcodeid2' type='text'   placeholder = 'Enter Coupon Code' onchange='Call(this)' class ='couponcodeboxsize' ></input>
                        <br></br>
                        <label class= 'emailidlabel' >
                            <span class = 'required' >*</span>Enter Email Id:
                        </label>
                        <input id = 'couponreferenceid2' type='text' placeholder = 'Enter Email Id' onchange='Call(this)' class ='couponcodeboxsize' ></input>
                        <br></br>
                        <br></br>
                        
                        <div id = 'showinsufficientbalance2' style = "display:none;">
                            <label class = 'textcolor' >Your Coupon Balance Is Insufficeint. Please Select Any Other Payment Mode. </label>
                            <br></br>
                            <label class = 'textcolor'>Amount Need To Pay  : NGN <%=totalamount%>
                            </label>                           
                            <br></br>
                            <label class = 'textcolor' id = 'deductedamountlabel2'></label>
                            <br></br>
                            <label class = 'textcolor' id = 'remaingamountlabel2'></label>
                            <br></br>
                            <button type="button" id='proceed2' class = 'cashcouponOk'onclick="proceedAction2()">Proceed</button>
                            <button type="button" id='notnow2' class = 'cashcouponNo'onclick="notnowAction2()">Not Now</button>
                        <br></br>
                        </div>
                        <div id = 'invalidatecoupon2' style = "display:none;">
                            <label class = 'inavalidcouponclass' >Entered Coupon Code Or Email ID Is Invalid!!</label>
                            <br></br>
                        </div>
                         <div id='checkbox2' style="display:none; margin-bottom:10px; " class = 'checkboxcss' >
                         <input id="checkbox22" type="checkbox" name="termscondition" value="">I have read the terms & conditions of payment and agree to comply<br></div>
                        
                        <div id = 'okcancelbutton2' style = "display:none" >
                            <button type="button" id='couponcode2' class = 'cashcouponOk'onclick="checkcashcouponamount2()">Book Now</button>
                            <button type="button" id='couponrefID2' class = 'cashcouponNo'onclick="hidecashcouponblock2()">Cancel</button>
                            <br></br>
                        </div>
                    </div>
                    <div id = 'proceedwithcouponAndOtherOption2' style = "display:none;">
                       <br></br>
                        <label class = 'textcolor' id = 'deductedamountlabelforProceedAction2'></label>
                        <br></br>
                        <label class = 'textcolor' id = 'remaingamountlabelforProceedAction2'></label>
                        <br></br>
                    </div>
                                             <!--  coupon code ends here-->
                                            
                                            <div id='checkboxforother' style="display:none; margin-bottom:10px;margin-top:10px;" class = 'checkboxcss'><input id = 'checkboxforothers'  type="checkbox" name="termscondition" value="">I have read the terms & conditions of payment and agree to comply<br></div>
                                            <!--paymnet button starts here-->
                                            <div id ='paymentbutton' style="display:none;">
                                              
                                                 <button type="button" id='cardbook' class = 'cashcouponOk'onclick="makepayment()">Book Now</button>
                                                 <button type="button"  class = 'cashcouponNo'onclick="cancelpayment()">Cancel</button>
                                                <br></br>                                              
                                            </div>
                                            <!--paymnet button ends here-->
                                        </div>
                                    </div>
                                </div>
                                <div id = "rightcolumn">
                                   <h1 class='journeydetailsHeading'>Journey Details</h1>
                                    <div ><%=journeyDetailsCompnt%>
                                    </div>
                                   
                                    <h1 class='journeydetailsHeading'>Terms And Conditions</h1>
                                    <h1 class= 'onwardAndBackwardJoudetails'>Ticket cancellation Policies</h1>
                                    <div style=margin-left:20px;font-family:OpenSans;>
                                    <ul style="list-style-type:circle">
  <li class='textcolors'>Within 24 Hrs. from the station departure time: 40% deduction.</li>
  <li class='textcolors'>Between 1 to 3 days before station departure time:30% deduction.</li>
  <li class='textcolors'>Between 3 to 7 days before station departure time:20% deduction.</li>
  <li class='textcolors'>Before 7 to 10 days before station departure time:10% deduction.</li>
  </ul>  
                                    </div>
                                </div>
                            </div>
                            </div>
<script>
var pripass="";
var hash = "";
var transIDForUSER = "";
var basePath = '<%=basePath%>';
var detailslist1 = '<%=detailslist1%>';
var detailslist2 = '<%=detailslist2%>';
var seatNo = '<%=seatNo%>';
var totalamount = '<%=totalamount%>';
var roundtrip = '<%=roundtrip%>';
var primarynamef = "";
var primaryEmail = "";
var primaryPhoine = "";
var Name = "";
var Age = "";
var Gender = "";
var PassangerDetails;
var phoneEmailDetails;
var emailandphone = "";
var couponcode;
var couponferid;
var remainingamountneedtopay;
var deductedamount;
var paymentmode;
var valid = false;
var phvalid = true;
var emailvalid = true;
var isCouponAmountSufficient = false;
var tempId1 = <%=tempId1%>;
var tempId2 = <%=tempId2%>;
var maxvalid = true;
var mes = 'Message!!!';
var confirm = 'Confirm!!!';
var couponCodegenMode;
var dialingcode;
var splitpaymentmode = false;
var primarypaymentmode = '';
var primarycouponcode;
var primarytotal;
var secondaryoaymentmode = '';
var secondaycouponcode;
var secondarytotal;
var secodaryrefid;
var systemId = <%=systemId%>;
var customerId = <%=customerId%>;
var userId = <%=userId%>;

   function onlyAlphabets(e, t) {
            try {
                if (window.event) {
                    var charCode = window.event.keyCode;
                }
                else if (e) {
                    var charCode = e.which;
                }
                else { return true; }
                if ((charCode > 64 && charCode < 91) || (charCode > 96 && charCode < 123))
                    return true;
                else
                    return false;
            }
            catch (err) {
            }
        }
function checkdirectcashamount() {
    saveFunction();
    if (valid == true && phvalid == true && emailvalid == true && maxvalid == true) {

        var enteredAmount = document.getElementById('directcashid').value;

        if (enteredAmount == '') {
            document.getElementById('directcashid').select();
            document.getElementById('directcashid').style.border = "1px solid #ff0000";
            Ext.example.msg("Please Enter Cash Amount");
        } else {
            if (document.getElementById("cashcheckbox").checked == true) {
                if (splitpaymentmode == false) {
                    if (enteredAmount == totalamount) {
                        isCouponAmountSufficient = true;
                        ajaxcallfunction();
                    } else {
                        Ext.example.msg("Please Enter Exact Amount Of The Ticket");
                    }

                } else if (splitpaymentmode == true) {
                    if (enteredAmount == remainingamountneedtopay) {
                        secondaryoaymentmode = 'cash';
                        secondaycouponcode = '';
                        secondarytotal = remainingamountneedtopay;
                        confirmFunctionForSplitpayment();
                    } else {
                        Ext.example.msg("Please Enter Exact Amount To Complete Booking");
                    }
                }
            } else {
                Ext.example.msg("Please Agree Terms & Conditions By Checking The Check Box.");
            }
        }
    }

}

function hidedirectcashblock() {
document.getElementById('payableAmount').innerHTML = ' Payable Amount : NGN ' + totalamount;
    splitpaymentmode = false;
    primarypaymentmode = '';
    primarycouponcode = '';
    primarytotal = '';
    secondaryoaymentmode = '';
    secondaycouponcode = '';
    secondarytotal = '';
    document.getElementById('directcashdiv').style.display = 'none';
    document.getElementById('paymentIstructions').style.display = 'block';

}

function makepayment() {
    saveFunction();
    if (valid == true && phvalid == true && emailvalid == true && maxvalid == true) {
        if (document.getElementById("checkboxforothers").checked == true) {     
        if (splitpaymentmode == false) {       
            $("#myDialogText").text("Are You Sure Want To Use Debit/Credit Card To Book and Download The Ticket ?");
            $("#myDialog").dialog({
                title: confirm,
                resizable: false,
                closeOnEscape: false,
                open: function(event, ui) {
                    $(".ui-dialog-titlebar-close").hide();
                },
                modal: true,
                height: 170,
                width: 320,
                draggable: false,
                show: {
                    effect: "fade",
                    duration: 800
                },
                buttons: {
                    Yes: function() {
                        ajaxcallfunction();
                        $(this).dialog("close");
                    },
                    No: function() {
                        document.getElementById('debitcarddiv').style.display = 'none';
                        document.getElementById('paymentbutton').style.display = 'none';
                        document.getElementById('paymentIstructions').style.display = 'block';
                        document.getElementById('checkboxforother').style.display = 'none';
                        $(this).dialog("close");
                    }
                }

            });            
           }
           else if( splitpaymentmode == true){          
                        secondaryoaymentmode = 'debitcard';
                        secondaycouponcode = '';
                        secondarytotal = remainingamountneedtopay;
                        confirmFunctionForSplitpayment(); 
           }          
        } else {
            Ext.example.msg("Please Agree Terms & Conditions By Checking The Check Box.");
        }
    }
}

function cancelpayment() {
document.getElementById('payableAmount').innerHTML = ' Payable Amount : NGN ' + totalamount; 
    document.getElementById('paymentIstructions').style.display = 'block';
    document.getElementById('debitcarddiv').style.display = 'none';
    document.getElementById('paymentbutton').style.display = 'none';
    document.getElementById('checkboxforother').style.display = 'none';
}

function proceedAction() {
    splitpaymentmode = true;
    primarypaymentmode = 'cashcoupon';
    primarycouponcode = document.getElementById('couponcodeid').value;
    primarytotal = deductedamount;
    document.getElementById('cashcoupondiv').style.display = 'none';
    document.getElementById('deductedamountlabelforProceedAction').innerHTML = 'Deducted Amount From Prepaid Card : NGN ' + deductedamount;
    document.getElementById('remaingamountlabelforProceedAction').innerHTML = 'Remaining Amount : NGN ' + remainingamountneedtopay;
    document.getElementById('proceedwithcouponAndOtherOption').style.display = 'block';
}

function notnowAction() {
document.getElementById('payableAmount').innerHTML = ' Payable Amount : NGN ' + totalamount;   
    splitpaymentmode = false;
    primarypaymentmode = '';
    primarycouponcode = '';
    primarytotal = '';
    secondaryoaymentmode = '';
    secondaycouponcode = '';
    secondarytotal = '';
    document.getElementById('cashcoupondiv').style.display = 'none';
    document.getElementById('paymentIstructions').style.display = 'block';
}

function showinvalidatecouponmessage() {

    document.getElementById('okcancelbutton').style.display = 'block';
    document.getElementById('invalidatecoupon').style.display = 'block';
}

function showremaingamount() {
    document.getElementById('deductedamountlabel').innerHTML = 'Deducted Amount From Prepaid Card : NGN ' + deductedamount;
    document.getElementById('remaingamountlabel').innerHTML = 'Remaining Amount : NGN ' + remainingamountneedtopay;
    document.getElementById('okcancelbutton').style.display = 'none';
    document.getElementById('checkbox').style.display = 'none';
    document.getElementById('showinsufficientbalance').style.display = 'block';
    document.getElementById('invalidatecoupon').style.display = 'none';
}

function confirmFunction() {
    if (document.getElementById('invalidatecoupon').style.display = 'block') {
        document.getElementById('invalidatecoupon').style.display = 'none';
    }

    $("#myDialogText").text("Are You Sure Want To Book The Seat And Download The Ticket ?");
    $("#myDialog").dialog({
        title: confirm,
        resizable: false,
        closeOnEscape: false,
        open: function(event, ui) {
            $(".ui-dialog-titlebar-close").hide();
        },
        modal: true,
        height: 170,
        width: 320,
        draggable: false,
        show: {
            effect: "fade",
            duration: 800
        },
        buttons: {
            Yes: function() {
                ticketBookingByCashCoupon();
                $(this).dialog("close");
            },
            No: function() {
                document.getElementById('cashcoupondiv').style.display = 'none';
                document.getElementById('paymentIstructions').style.display = 'block';
                $(this).dialog("close");
            }
        }

    });
}

function ticketBookingByCashCoupon() {
    isCouponAmountSufficient = true;
    ajaxcallfunction();
}

function checkcashcouponamount() {
    saveFunction();
    if (valid == true && phvalid == true && emailvalid == true && maxvalid == true) {
        couponCodegenMode = 'prepaidcard';
        couponcode = document.getElementById('couponcodeid').value;
        couponferid = document.getElementById('couponreferenceid').value;

        if (couponcode == '') {
            document.getElementById('couponcodeid').select();
            document.getElementById('couponcodeid').style.border = "1px solid #ff0000";
            Ext.example.msg("Please Enter Valid Prepaid Card Number");
        } else if (couponferid == '') {
            document.getElementById('couponreferenceid').select();
            document.getElementById('couponreferenceid').style.border = "1px solid #ff0000";
            Ext.example.msg("Please Enter Valid Email Id");
        } else if (couponcode != '' && couponferid != '') {
            if (document.getElementById("checkboxx").checked == true) {
                if (splitpaymentmode == false) {
                    Ext.Ajax.request({
                        url: '<%=request.getContextPath()%>/PaymnetDetailsAction.do?param=CheckCouponCodeAmountAndValidity',
                        method: 'POST',
                        params: {
                            CouponCode: couponcode,
                            CouponrefId: couponferid,
                            TotalAmount: totalamount,
                            CouponCodegenMode: couponCodegenMode
                        },
                        success: function(response, options) {
                            var message = response.responseText;

                            if (message == 'Valid') {
                                confirmFunction();
                            } else if (message == 'Not Valid') {
                                showinvalidatecouponmessage();
                            } else if (message != 'Valid' && message != 'Not Valid' && message != '' && message != "") {
                                var messages = message.split('#');
                                remainingamountneedtopay = messages[1];
                                deductedamount = messages[2];
                                showremaingamount();
                            }
                        },
                        failure: function() {
                            deletetempdata();
                            $(window).unbind('beforeunload');
                            window.location = basePath + 'Jsps/PassengerBusTransportation/SeatSelection.jsp?';
                        }
                    });
                } else if (splitpaymentmode == true) {
                    secondaryoaymentmode = 'cashcoupon';
                    secondaycouponcode = couponcode;
                    secondarytotal = remainingamountneedtopay;
                    Ext.Ajax.request({
                        url: '<%=request.getContextPath()%>/PaymnetDetailsAction.do?param=CheckCouponCodeAmountAndValidity',
                        method: 'POST',
                        params: {
                            CouponCode: couponcode,
                            CouponrefId: couponferid,
                            TotalAmount: remainingamountneedtopay,
                            CouponCodegenMode: couponCodegenMode
                        },
                        success: function(response, options) {
                            var message = response.responseText;

                            if (message == 'Valid') {
                                confirmFunctionForSplitpayment();
                            } else if (message == 'Not Valid') {
                                showinvalidatecouponmessage2();
                            } else if (message != 'Valid' && message != 'Not Valid' && message != '' && message != "") {
                                showremaingamountForSplitpayment();
                            }
                        },
                        failure: function() {
                            deletetempdata();
                            $(window).unbind('beforeunload');
                            window.location = basePath + 'Jsps/PassengerBusTransportation/SeatSelection.jsp?';
                        }
                    });
                }
            } else {
                Ext.example.msg("Please Agree Terms & Conditions By Checking The Check Box.");
            }
        }
    }
}

function hidecashcouponblock() {
 document.getElementById('payableAmount').innerHTML = ' Payable Amount : NGN ' + totalamount;
    splitpaymentmode = false;
    primarypaymentmode = '';
    primarycouponcode = '';
    primarytotal = '';
    secondaryoaymentmode = '';
    secondaycouponcode = '';
    secondarytotal = '';
    document.getElementById('cashcoupondiv').style.display = 'none';
    document.getElementById('couponreferenceid2').style.border = "1px solid #337ab7";
    document.getElementById('couponcodeid2').style.border = "1px solid #337ab7";
    document.getElementById('paymentIstructions').style.display = 'block';

}




// ******************** this is for coupon code ***************************

function showremaingamountForSplitpayment() {
    $("#myDialogText").text("Cannot Make Payment Because Of Insufficient Balance!! ");
    $("#myDialog").dialog({
        title: mes,
        resizable: false,
        open: function(event, ui) {
            $(".ui-dialog-titlebar-close").hide();
        },
        closeOnEscape: false,
        modal: true,
        height: 200,
        width: 320,
        draggable: false,
        show: {
            effect: "fade",
            duration: 800
        },
        buttons: {
            Ok: function() {
                $(window).unbind('beforeunload');
                window.location = basePath + 'Jsps/PassengerBusTransportation/SeatSelection.jsp?';
            }
        }
    });
}

function confirmFunctionForSplitpayment() {

    $("#myDialogText").text("Are You Sure Want To Use Two Payment Option To Book The Seat And Download The Ticket?");
    $("#myDialog").dialog({
        title: confirm,
        resizable: false,
        closeOnEscape: false,
        open: function(event, ui) {
            $(".ui-dialog-titlebar-close").hide();
        },
        modal: true,
        height: 200,
        width: 320,
        draggable: false,
        show: {
            effect: "fade",
            duration: 800
        },
        buttons: {
            Yes: function() {
                ticketBookingBySplitPayment();
                $(this).dialog("close");
            },
            No: function() {
            document.getElementById('payableAmount').innerHTML = ' Payable Amount : NGN ' + totalamount;
            splitpaymentmode = false;
            primarypaymentmode = '';
            primarycouponcode = '';
            primarytotal = '';
            secondaryoaymentmode = '';
            secondaycouponcode = '';
            secondarytotal = '';
            
    document.getElementById('cashcoupondiv').style.display = 'none';
    document.getElementById('couponreferenceid2').style.border = "1px solid #337ab7";
    document.getElementById('couponcodeid2').style.border = "1px solid #337ab7";
    document.getElementById('paymentIstructions').style.display = 'block';
    
    document.getElementById('directcashdiv').style.display = 'none';
    document.getElementById('paymentIstructions').style.display = 'block';
    
    document.getElementById('cancelcoupondiv').style.display = 'none';
    document.getElementById('couponreferenceid2').style.border = "1px solid #337ab7";
    document.getElementById('couponcodeid2').style.border = "1px solid #337ab7";
    document.getElementById('paymentIstructions').style.display = 'block';
    
    document.getElementById('paymentIstructions').style.display = 'block';
    document.getElementById('debitcarddiv').style.display = 'none';
    document.getElementById('paymentbutton').style.display = 'none';
    document.getElementById('checkboxforother').style.display = 'none';
    
            $(this).dialog("close");   
            }
        }

    });
}


function checkcashcouponamount2() {
    saveFunction();
    if (valid == true && phvalid == true && emailvalid == true && maxvalid == true) {
        couponCodegenMode = 'canceloropenticket';
        couponcode = document.getElementById('couponcodeid2').value;
        couponferid = document.getElementById('couponreferenceid2').value;

        if (couponcode == '') {
            document.getElementById('couponcodeid2').select();
            document.getElementById('couponcodeid2').style.border = "1px solid #ff0000";
            Ext.example.msg("Please Enter Valid Coupon Code");
        } else if (couponferid == '') {
            document.getElementById('couponreferenceid2').select();
            document.getElementById('couponreferenceid2').style.border = "1px solid #ff0000";
            Ext.example.msg("Please Enter Valid Email Id");

        } else if (couponcode != '' && couponferid != '') {
            if (document.getElementById("checkbox22").checked == true) {
                if (splitpaymentmode == false) {

                    Ext.Ajax.request({
                        url: '<%=request.getContextPath()%>/PaymnetDetailsAction.do?param=CheckCouponCodeAmountAndValidity',
                        method: 'POST',
                        params: {
                            CouponCode: couponcode,
                            CouponrefId: couponferid,
                            TotalAmount: totalamount,
                            CouponCodegenMode: couponCodegenMode
                        },
                        success: function(response, options) {
                            var message = response.responseText;

                            if (message == 'Valid') {
                                confirmFunction();
                            } else if (message == 'Not Valid') {
                                showinvalidatecouponmessage2();
                            } else if (message != 'Valid' && message != 'Not Valid' && message != '' && message != "") {
                                var messages = message.split('#');
                                remainingamountneedtopay = messages[1];
                                deductedamount = messages[2];
                                showremaingamount2();
                            }
                        },
                        failure: function() {
                            deletetempdata();
                            $(window).unbind('beforeunload');
                            window.location = basePath + 'Jsps/PassengerBusTransportation/SeatSelection.jsp?';
                        }
                    });
                } else if (splitpaymentmode == true) {
                    secondaryoaymentmode = 'couponcode';
                    secondaycouponcode = couponcode;
                    secondarytotal = remainingamountneedtopay;
                    Ext.Ajax.request({
                        url: '<%=request.getContextPath()%>/PaymnetDetailsAction.do?param=CheckCouponCodeAmountAndValidity',
                        method: 'POST',
                        params: {
                            CouponCode: couponcode,
                            CouponrefId: couponferid,
                            TotalAmount: remainingamountneedtopay,
                            CouponCodegenMode: couponCodegenMode
                        },
                        success: function(response, options) {
                            var message = response.responseText;
                            if (message == 'Valid') {
                                confirmFunctionForSplitpayment();
                            } else if (message == 'Not Valid') {
                                showinvalidatecouponmessage2();
                            } else if (message != 'Valid' && message != 'Not Valid' && message != '' && message != "") {
                                showremaingamountForSplitpayment();
                            }
                        },
                        failure: function() {
                            deletetempdata();
                            $(window).unbind('beforeunload');
                            window.location = basePath + 'Jsps/PassengerBusTransportation/SeatSelection.jsp?';
                        }
                    });
                }
            } else {
                Ext.example.msg("Please Agree Terms & Conditions By Checking The Check Box.");
            }
        }
    }
}

function hidecashcouponblock2() {
document.getElementById('payableAmount').innerHTML = ' Payable Amount : NGN ' + totalamount;
    splitpaymentmode = false;
    primarypaymentmode = '';
    primarycouponcode = '';
    primarytotal = '';
    secondaryoaymentmode = '';
    secondaycouponcode = '';
    secondarytotal = '';
    document.getElementById('cancelcoupondiv').style.display = 'none';
    document.getElementById('couponreferenceid2').style.border = "1px solid #337ab7";
    document.getElementById('couponcodeid2').style.border = "1px solid #337ab7";
    document.getElementById('paymentIstructions').style.display = 'block';

}


function proceedAction2() {
    splitpaymentmode = true;
    primarypaymentmode = 'couponcode';
    primarycouponcode = document.getElementById('couponcodeid2').value;
    primarytotal = deductedamount;
    document.getElementById('cancelcoupondiv').style.display = 'none';
    document.getElementById('deductedamountlabelforProceedAction2').innerHTML = 'Deducted Amount From Coupon : NGN ' + deductedamount;
    document.getElementById('remaingamountlabelforProceedAction2').innerHTML = 'Remaining Amount : NGN ' + remainingamountneedtopay;
    document.getElementById('proceedwithcouponAndOtherOption2').style.display = 'block';

}

function notnowAction2() {
document.getElementById('payableAmount').innerHTML = ' Payable Amount : NGN ' + totalamount;
    splitpaymentmode = false;
    primarypaymentmode = '';
    primarycouponcode = '';
    primarytotal = '';
    secondaryoaymentmode = '';
    secondaycouponcode = '';
    secondarytotal = '';
    document.getElementById('cancelcoupondiv').style.display = 'none';
    document.getElementById('paymentIstructions').style.display = 'block';
}

function showinvalidatecouponmessage2() {
    document.getElementById('okcancelbutton2').style.display = 'block';
    document.getElementById('invalidatecoupon2').style.display = 'block';
}

function showremaingamount2() {
    document.getElementById('deductedamountlabel2').innerHTML = 'Deducted Amount From Coupon : NGN ' + deductedamount;
    document.getElementById('remaingamountlabel2').innerHTML = 'Remaining Amount : NGN ' + remainingamountneedtopay;
    document.getElementById('okcancelbutton2').style.display = 'none';
    document.getElementById('checkbox2').style.display = 'none';
    document.getElementById('showinsufficientbalance2').style.display = 'block';
    document.getElementById('invalidatecoupon2').style.display = 'none';
}

function confirmFunction2() {
    if (document.getElementById('invalidatecoupon2').style.display = 'block') {
        document.getElementById('invalidatecoupon2').style.display = 'none';
    }

    $("#myDialogText").text("Are You Sure Want To Book The Seat And Download The Ticket ?");
    $("#myDialog").dialog({
        title: confirm,
        resizable: false,
        closeOnEscape: false,
        open: function(event, ui) {
            $(".ui-dialog-titlebar-close").hide();
        },
        modal: true,
        height: 170,
        width: 320,
        draggable: false,
        show: {
            effect: "fade",
            duration: 800
        },
        buttons: {
            Yes: function() {
                ticketBookingByCashCoupon();
                $(this).dialog("close");
            },
            No: function() {
                document.getElementById('cashcoupondiv').style.display = 'none';
                document.getElementById('paymentIstructions').style.display = 'block';
                $(this).dialog("close");
            }
        }

    });
}

function ticketBookingByCashCoupon2() {
    isCouponAmountSufficient = true;
    ajaxcallfunction();
}


// *********************** coupon code ends here ****************************************

function showcashcouponblock() {

    if (primarypaymentmode != 'cashcoupon') {
    if(primarypaymentmode != '' && primarypaymentmode != 'undefined' ){
    document.getElementById('payableAmount').innerHTML = ' Payable Amount : NGN ' + remainingamountneedtopay;    
    }else{
    document.getElementById('payableAmount').innerHTML = ' Payable Amount : NGN ' + totalamount;   
    }
        paymentmode = 'cashcoupon';
        document.getElementById('couponcodeid').value = "";
        document.getElementById('couponreferenceid').value = "";
        document.getElementById('couponcodeid').style.border = "1px solid #337ab7";
        document.getElementById('couponreferenceid').style.border = "1px solid #337ab7";
        document.getElementById("checkboxx").checked = false;
        document.getElementById('okcancelbutton').style.display = 'block';
        document.getElementById('cashcoupondiv').style.display = 'block';
        document.getElementById('invalidatecoupon').style.display = 'none';
        document.getElementById('showinsufficientbalance').style.display = 'none';
        document.getElementById('paymentIstructions').style.display = 'none';
        document.getElementById('paymentbutton').style.display = 'none';
        document.getElementById('debitcarddiv').style.display = 'none';
        document.getElementById('proceedwithcouponAndOtherOption').style.display = 'none';
        document.getElementById('proceedwithcouponAndOtherOption2').style.display = 'none';
        document.getElementById('checkbox').style.display = 'block';
        document.getElementById('checkboxforother').style.display = 'none';
        document.getElementById('cancelcoupondiv').style.display = 'none';
        document.getElementById('showinsufficientbalance2').style.display = 'none';
        document.getElementById('directcashdiv').style.display = 'none';

        return false;
    }
}

function showdebiitblock() {
    document.getElementById('checkboxforothers').checked = false;

    paymentmode = 'debitcard';
    if(primarypaymentmode != '' && primarypaymentmode != 'undefined' ){
    document.getElementById('payableAmount').innerHTML = ' Payable Amount : NGN ' + remainingamountneedtopay;    
    }else{
    document.getElementById('payableAmount').innerHTML = ' Payable Amount : NGN ' + totalamount;   
    }
    document.getElementById('paymentIstructions').style.display = 'none';
    document.getElementById('debitcarddiv').style.display = 'block';
    document.getElementById('paymentbutton').style.display = 'block';
    document.getElementById('cashcoupondiv').style.display = 'none';
    document.getElementById('proceedwithcouponAndOtherOption').style.display = 'none';
    document.getElementById('proceedwithcouponAndOtherOption2').style.display = 'none';
    document.getElementById('checkbox').style.display = 'none';
    document.getElementById('checkboxforother').style.display = 'block';
    document.getElementById('cancelcoupondiv').style.display = 'none';

    return false;
}

function showdirectcashlock() {

    paymentmode = 'cash';
    if(primarypaymentmode != '' && primarypaymentmode != 'undefined' ){
    document.getElementById('payableAmount').innerHTML = ' Payable Amount : NGN ' + remainingamountneedtopay;    
    }else{
    document.getElementById('payableAmount').innerHTML = ' Payable Amount : NGN ' + totalamount;   
    }
    document.getElementById('directcashid').style.border = "1px solid #337ab7";
    document.getElementById('directcashid').value = "";
    document.getElementById('directcashdiv').style.display = 'block';
    document.getElementById('paymentIstructions').style.display = 'none';
    document.getElementById('debitcarddiv').style.display = 'none';
    document.getElementById('paymentbutton').style.display = 'none';
    document.getElementById('cashcoupondiv').style.display = 'none';
    document.getElementById('proceedwithcouponAndOtherOption').style.display = 'none';
    document.getElementById('proceedwithcouponAndOtherOption2').style.display = 'none';
    document.getElementById('checkbox').style.display = 'none';
    document.getElementById('checkboxforother').style.display = 'none';
    document.getElementById('cancelcoupondiv').style.display = 'none';
    document.getElementById('cashcheck').style.display = 'block';
    document.getElementById('cashcheckbox').checked = false;
    document.getElementById('okcancelbuttonfordirectcash').style.display = 'block';

    return false;
}


function showcancelcouponblock() {

    if (primarypaymentmode != 'couponcode') {
        paymentmode = 'couponcode';
        if(primarypaymentmode != '' && primarypaymentmode != 'undefined' ){
    document.getElementById('payableAmount').innerHTML = ' Payable Amount : NGN ' + remainingamountneedtopay;    
    }else{
    document.getElementById('payableAmount').innerHTML = ' Payable Amount : NGN ' + totalamount;   
    }
        document.getElementById('cancelcoupondiv').style.display = 'block';
        document.getElementById('couponcodeid2').value = "";
        document.getElementById('couponreferenceid2').value = "";
        document.getElementById('couponcodeid2').style.border = "1px solid #337ab7";
        document.getElementById('couponreferenceid2').style.border = "1px solid #337ab7";
        document.getElementById("checkbox22").checked = false;
        document.getElementById('okcancelbutton2').style.display = 'block';
        document.getElementById('paymentIstructions').style.display = 'none';
        document.getElementById('paymentbutton').style.display = 'none';
        document.getElementById('cashcoupondiv').style.display = 'none';
        document.getElementById('debitcarddiv').style.display = 'none';
        document.getElementById('proceedwithcouponAndOtherOption').style.display = 'none';
        document.getElementById('proceedwithcouponAndOtherOption2').style.display = 'none';
        document.getElementById('checkbox2').style.display = 'block';
        document.getElementById('checkboxforother').style.display = 'none';
        document.getElementById('invalidatecoupon2').style.display = 'none';
        document.getElementById('showinsufficientbalance2').style.display = 'none';
        document.getElementById('showinsufficientbalance').style.display = 'none';
        document.getElementById('directcashdiv').style.display = 'none';

    }
}

function saveFunction() {
    valid = true;
    var phone = document.getElementById('Phone').value;
    var email = document.getElementById('Email').value;

    if (phone == "") {
        valid = false;
        document.getElementById('Phone').style.border = "1px solid #ff0000";
        document.getElementById('Phone').placeholder = "Enter Phone Number";
    } else {
        phonenumbervalidation();
    }
    if (email == "") {
        valid = false;
        document.getElementById('Email').style.border = "1px solid #ff0000";
        document.getElementById('Email').placeholder = "Enter Valid Email";
    } else {
        validateEmail();
    }
    dialingcode = document.getElementById('countrycode').value;
    phone = dialingcode + phone;
    phoneEmailDetails = phone + "," + email;
    PassangerDetails = "|";


    primaryEmail = email;
    primaryPhoine = phone;

    for (i = 0; i < seatNo; i++) {
        pripass=document.getElementById('passangername0').value;
        Name = document.getElementById('passangername' + i).value;
        if (Name == "") {
            valid = false;
            document.getElementById('passangername' + i).style.border = "1px solid #ff0000";
            document.getElementById('passangername' + i).placeholder = "Enter Passanger Name";
        }
        if (i == 0 && Name != "") {
            primarynamef = document.getElementById('passangername' + i).value;
        }
        Age = document.getElementById('age' + i).value;
        if (Age == "") {
            valid = false;
            document.getElementById('age' + i).style.border = "1px solid #ff0000";
            document.getElementById('age' + i).placeholder = "Enter Age";
        } else {
            maxAgevalidation('age' + i);
        }
        if (document.getElementById('mradio' + i).checked) {
            Gender = document.getElementById('mradio' + i).value;
        } else if (document.getElementById('fradio' + i).checked) {
            Gender = document.getElementById('fradio' + i).value;
        }
        if (Gender == "") {
            Gender = 'male';
        }
        PassangerDetails = PassangerDetails + Name + "," + Age + "," + Gender + "|";
    }
    if (phvalid == true && emailvalid == true) {
        var LIMIT = 100;
        for (i = 0; i < seatNo; i++) {
            if (document.getElementById('passangername' + i).value.length > LIMIT) {
                document.getElementById('passangername' + i).style.border = "1px solid #ff0000";
                maxvalid = false;
            }
        }
    }
    if (valid == false) {
        Ext.example.msg("Please Enter Mandatory Fields");
    } else if (phvalid == false) {
        Ext.example.msg("Please Enter Valid Phone Numbers");
    } else if (emailvalid == false) {
        Ext.example.msg("Please Enter Valid Email");
    } else if (maxvalid == false) {
        Ext.example.msg("name should not be grater than 100 chars");
    }

};

function ajaxcallfunction() {

    if (paymentmode == 'cashcoupon' || paymentmode == 'couponcode' || paymentmode == 'cash') {
        callajaxforcashcouponfunction();
    } else if (paymentmode == 'debitcard') {
        callajaxfordebitcardfunction();
    }

}

function callajaxforcashcouponfunction() {
    document.getElementById("cashbook").disabled = true;
    document.getElementById("couponcode").disabled = true;
    document.getElementById("couponcode2").disabled = true;
    document.getElementById("cardbook").disabled = true;
    $('#loadingMessage').css('display', 'block');   
    Ext.Ajax.request({
        url: '<%=request.getContextPath()%>/PaymnetDetailsAction.do?param=BookATicketByCasCoupon',
        method: 'POST',
        params: {
            SystemId: systemId,
            CustomerId: customerId,
            UserId: userId,
            SeatNo: seatNo,
            RoundTrip: roundtrip,
            TotalAmount: totalamount,
            IsCouponAmountSufficient: isCouponAmountSufficient,
            CouponCode: couponcode,
            CouponRefId: couponferid,
            PaymetMode: paymentmode,
            PhoneEmailDetails: phoneEmailDetails,
            PassangerDetails: PassangerDetails,
            Detailslist1: detailslist1,
            Detailslist2: detailslist2,
            TempId1: tempId1,
            TempId2: tempId2
        },
        success: function(response, options) {
            $('#loadingMessage').css('display', 'none');
            var response;
            var message = response.responseText;
            var splitmess = message.split("#");
            var transId = splitmess[1];
            var resp = splitmess[0];
            if (resp == 'success') {
                response = '00';
                var responsemessage = transId + "&status=" + response
                $(window).unbind('beforeunload');
                window.location = basePath + 'Jsps/PassengerBusTransportation/Response.jsp?txnref=' + responsemessage;
            } else if (resp == 'booked') {
                $("#myDialogText").text("Selected Seat Has Booked Already. Please Go To Seat Selection Page And Book Available Seats Only. ");
                $("#myDialog").dialog({
                    title: mes,
                    resizable: false,
                    closeOnEscape: false,
                    open: function(event, ui) {
                        $(".ui-dialog-titlebar-close").hide();
                    },
                    modal: true,
                    height: 200,
                    width: 320,
                    draggable: false,
                    show: {
                        effect: "fade",
                        duration: 800
                    },
                    buttons: {
                        Ok: function() {
                            deletetempdata();
                            $(window).unbind('beforeunload');
                            window.location = basePath + 'Jsps/PassengerBusTransportation/SeatSelection.jsp?';
                        }
                    }

                });
            } else {
                response = '27';
                var responsemessage = transId + "&status=" + response
                $(window).unbind('beforeunload');
                window.location = basePath + 'Jsps/PassengerBusTransportation/Response.jsp?txnref=' + responsemessage;
            }

        },
        failure: function() {
            $('#loadingMessage').css('display', 'none');
            $("#myDialogText").text("Error!!");
            $("#myDialog").dialog({
                title: mes,
                resizable: false,
                modal: true,
                height: 100,
                width: 320,
                draggable: false,
                show: {
                    effect: "fade",
                    duration: 800
                }

            });
        }
    });
}

function callajaxfordebitcardfunction() {
    document.getElementById("cashbook").disabled = true;
    document.getElementById("couponcode").disabled = true;
    document.getElementById("couponcode2").disabled = true;
    document.getElementById("cardbook").disabled = true;
    $('#loadingMessage').css('display', 'block');
    Ext.Ajax.request({
        url: '<%=request.getContextPath()%>/PaymnetDetailsAction.do?param=BookATicketByPaymentGateway',
        method: 'POST',
        params: {
            SystemId: systemId,
            CustomerId: customerId,
            UserId: userId,
            SeatNo: seatNo,
            RoundTrip: roundtrip,
            TotalAmount: totalamount,
            PaymetMode: paymentmode,
            PhoneEmailDetails: phoneEmailDetails,
            PassangerDetails: PassangerDetails,
            Detailslist1: detailslist1,
            Detailslist2: detailslist2,
            TempId1: tempId1,
            TempId2: tempId2,
            basePath : basePath
        },
        success: function(response, options) {
            $('#loadingMessage').css('display', 'none');
            var message = response.responseText;
            var seperateTransId = message.split('#');
            if (seperateTransId[0] == 'success') {
                transIDForUSER = seperateTransId[1];
                hash = seperateTransId[2];
                $("#myDialogText").text("Please Note This TransactionId For Your Referance : " + transIDForUSER);
                $("#myDialog").dialog({
                    title: confirm,
                    resizable: false,
                    closeOnEscape: false,
                    open: function(event, ui) {
                        $(".ui-dialog-titlebar-close").hide();
                    },
                    modal: true,
                    height: 200,
                    width: 320,
                    draggable: false,
                    show: {
                        effect: "fade",
                        duration: 800
                    },
                    buttons: {
                        Ok: function() {
                            totalamount = totalamount+'00';  
                            document.getElementById('amount').value = totalamount;                        
                            document.getElementById('txn_ref').value = transIDForUSER;
                            document.getElementById('hash').value = hash;
                            document.getElementById('cust_name').value = pripass;
                            document.getElementById('site_redirect_url').value = basePath + 'Jsps/PassengerBusTransportation/Response.jsp';                           
                            document.paymentform.submit();
                            $(window).unbind('beforeunload');                            
                            $(this).dialog("close");
                        }
                    }

                });
            } else if(seperateTransId[0] == 'booked'){
            $("#myDialogText").text("Selected Seat Has Booked Already. Please Go To Seat Selection Page And Book Available Seats Only. ");
                $("#myDialog").dialog({
                    title: mes,
                    resizable: false,
                    closeOnEscape: false,
                    open: function(event, ui) {
                        $(".ui-dialog-titlebar-close").hide();
                    },
                    modal: true,
                    height: 200,
                    width: 320,
                    draggable: false,
                    show: {
                        effect: "fade",
                        duration: 800
                    },
                    buttons: {
                        Ok: function() {
                            deletetempdata();
                            $(window).unbind('beforeunload');
                            window.location = basePath + 'Jsps/PassengerBusTransportation/SeatSelection.jsp?';
                        }
                    }

                });
            }
            else {
                $("#myDialogText").text("Transactionid Did Not Generated. Please Try Again");
                $("#myDialog").dialog({
                    title: mes,
                    resizable: false,
                    modal: true,
                    height: 200,
                    width: 320,
                    draggable: false,
                    show: {
                        effect: "fade",
                        duration: 800
                      },
                     buttons: {
                        Ok: function() {
                            deletetempdata();
                            $(window).unbind('beforeunload');
                            window.location = basePath + 'Jsps/PassengerBusTransportation/SeatSelection.jsp?';
                            }
                        }

                });
            }
        },
        failure: function() {
            $('#loadingMessage').css('display', 'none');
            $("#myDialogText").text("Error!!");
            $("#myDialog").dialog({
                title: mes,
                resizable: false,
                modal: true,
                height: 100,
                width: 320,
                draggable: false,
                show: {
                    effect: "fade",
                    duration: 800
                }

            });
            deletetempdata();
            window.location = basePath + 'Jsps/PassengerBusTransportation/SeatSelection.jsp?';

        }
    });
}


function ticketBookingBySplitPayment() {
    document.getElementById("cashbook").disabled = true;
    document.getElementById("couponcode").disabled = true;
    document.getElementById("couponcode2").disabled = true;
    document.getElementById("cardbook").disabled = true;
    $('#loadingMessage').css('display', 'block');
    Ext.Ajax.request({
        url: '<%=request.getContextPath()%>/PaymnetDetailsAction.do?param=BookATicketBySplitPayment',
        method: 'POST',
        params: {
            SystemId: systemId,
            CustomerId: customerId,
            UserId: userId,
            Splitpaymentmode: splitpaymentmode,
            Primarypaymentmode: primarypaymentmode,
            Primarycouponcode: primarycouponcode,
            Primarytotal: primarytotal,
            Secondaryoaymentmode: secondaryoaymentmode,
            Secondaycouponcode: secondaycouponcode,
            Secondarytotal: secondarytotal,
            SeatNo: seatNo,
            RoundTrip: roundtrip,
            TotalAmount: totalamount,
            PhoneEmailDetails: phoneEmailDetails,
            PassangerDetails: PassangerDetails,
            Detailslist1: detailslist1,
            Detailslist2: detailslist2,
            TempId1: tempId1,
            TempId2: tempId2,
            basePath : basePath
        },
        success: function(response, options) {
            $('#loadingMessage').css('display', 'none');
            var message = response.responseText;
            var seperateTransId = message.split('#');
            if (seperateTransId[0] == 'success') {
                transIDForUSER = seperateTransId[1];
                hash = seperateTransId[2];
                $("#myDialogText").text("Please Note This TransactionId For Your Referance : " + transIDForUSER);
                $("#myDialog").dialog({
                    title: confirm,
                    resizable: false,
                    closeOnEscape: false,
                    open: function(event, ui) {
                        $(".ui-dialog-titlebar-close").hide();
                    },
                    modal: true,
                    height: 200,
                    width: 320,
                    draggable: false,
                    show: {
                        effect: "fade",
                        duration: 800
                    },
                    buttons: {
                        Ok: function() {

                            if ((primarypaymentmode == 'cashcoupon' && secondaryoaymentmode != 'debitcard' ) || ( primarypaymentmode == 'couponcode') && secondaryoaymentmode != 'debitcard' ) {
                                primarypaymentdonehere(transIDForUSER, primarypaymentmode, primarycouponcode, primarytotal);
                            }
                            if (secondaryoaymentmode == 'cashcoupon' || secondaryoaymentmode == 'couponcode' || secondaryoaymentmode == 'cash') {
                                secondarypaymentdonehere(transIDForUSER, secondaryoaymentmode, secondaycouponcode, secondarytotal);
                            } else if (secondaryoaymentmode == 'debitcard') { 
                                remainingamountneedtopay = remainingamountneedtopay+'00'; 
                                document.getElementById('amount').value = remainingamountneedtopay;                                  
                                document.getElementById('txn_ref').value = transIDForUSER;
                                document.getElementById('hash').value = hash;
                                document.getElementById('cust_name').value = pripass;
                                document.getElementById('site_redirect_url').value = basePath + 'Jsps/PassengerBusTransportation/Response.jsp';
                                $(window).unbind('beforeunload');
                                document.paymentform.submit();
                            }
                            $(this).dialog("close");

                        }

                    }

                });
            } else if (seperateTransId[0] == 'booked') {
                $("#myDialogText").text("Selected Seat Has Booked Already. Please Go To Seat Selection Page And Book Available Seats Only. ");
                $("#myDialog").dialog({
                    title: mes,
                    resizable: false,
                    closeOnEscape: false,
                    open: function(event, ui) {
                        $(".ui-dialog-titlebar-close").hide();
                    },
                    modal: true,
                    height: 200,
                    width: 320,
                    draggable: false,
                    show: {
                        effect: "fade",
                        duration: 800
                    },
                    buttons: {
                        Ok: function() {
                            deletetempdata();
                            $(window).unbind('beforeunload');
                            window.location = basePath + 'Jsps/PassengerBusTransportation/SeatSelection.jsp?';
                        }
                    }
                });
            } else {
                $("#myDialogText").text("Transactionid Did Not Generated. Please Try Again");
                $("#myDialog").dialog({
                    title: mes,
                    resizable: false,
                    modal: true,
                    height: 100,
                    width: 320,
                    draggable: false,
                    show: {
                        effect: "fade",
                        duration: 800
                    },
                     buttons: {
                        Ok: function() {
                            deletetempdata();
                            $(window).unbind('beforeunload');
                            window.location = basePath + 'Jsps/PassengerBusTransportation/SeatSelection.jsp?';
                        }
                    }

                });
            }
        },
        failure: function() {
            $('#loadingMessage').css('display', 'none');
            $("#myDialogText").text("Error!!");
            $("#myDialog").dialog({
                title: mes,
                resizable: false,
                modal: true,
                height: 100,
                draggable: false,
                show: {
                    effect: "fade",
                    duration: 800
                }

            });
            deletetempdata();
            $(window).unbind('beforeunload');
            window.location = basePath + 'Jsps/PassengerBusTransportation/SeatSelection.jsp?';

        }
    });


}

function primarypaymentdonehere(transIDForUSER, primarypaymentmode, primarycouponcode, primarytotal) {
    Ext.Ajax.request({
        url: '<%=request.getContextPath()%>/PaymnetDetailsAction.do?param=DeductAmountFromPrepaidAndCoupon',
        method: 'POST',
        params: {
            PaymentMode: primarypaymentmode,
            CouponCode: primarycouponcode,
            TotalAmount: primarytotal,
            TransactionId: transIDForUSER
        },
        success: function(response, options) {},
        failure: function() {}
    });
}

function secondarypaymentdonehere(transIDForUSER, secondaryoaymentmode, secondaycouponcode, secondarytotal) {
    Ext.Ajax.request({
        url: '<%=request.getContextPath()%>/PaymnetDetailsAction.do?param=DeductAmountFromPrepaidAndCoupon',
        method: 'POST',
        params: {
            PaymentMode: secondaryoaymentmode,
            CouponCode: secondaycouponcode,
            TotalAmount: secondarytotal,
            TransactionId: transIDForUSER
        },
        success: function(response, options) {
            var response;
            var message = response.responseText;
            var resp = message;
            if (resp == 'success') {
                response = '00';
                var responsemessage = transIDForUSER + "&status=" + response;
                $(window).unbind('beforeunload');
                window.location = basePath + 'Jsps/PassengerBusTransportation/Response.jsp?txnref=' + responsemessage;
            } else {
                response = '27';
                var responsemessage = transIDForUSER + "&status=" + response;
                $(window).unbind('beforeunload');
                window.location = basePath + 'Jsps/PassengerBusTransportation/Response.jsp?txnref=' + responsemessage;
            }
        },
        failure: function() {
            $("#myDialogText").text("Error!!");
            $("#myDialog").dialog({
                title: mes,
                resizable: false,
                modal: true,
                height: 100,
                width: 320,
                draggable: false,
                show: {
                    effect: "fade",
                    duration: 800
                }

            });
            deletetempdata();
            $(window).unbind('beforeunload');
            window.location = basePath + 'Jsps/PassengerBusTransportation/SeatSelection.jsp?';
        }
    });
}

window.onload = function() {
    var eightMinutes = 60 * 8,
        display = document.querySelector('#time');
    startTimer(eightMinutes, display);
};

function startTimer(duration, display) {
    var timer = duration,
        minutes, seconds;
    setInterval(function() {
        minutes = parseInt(timer / 60, 10);
        seconds = parseInt(timer % 60, 10);

        minutes = minutes < 10 ? "0" + minutes : minutes;
        seconds = seconds < 10 ? "0" + seconds : seconds;

        display.textContent = minutes + ":" + seconds;

        if (--timer < 0) {
            timer = duration;
        }
        if (timer == 0) {
            deletetempdata();
            $(window).unbind('beforeunload');
            window.location = basePath + 'Jsps/PassengerBusTransportation/SeatSelection.jsp?';
        }
    }, 1000);

}

function Call(id) {

    $(id).css("border-color", "#337ab7");

}

$(document).ready(function() {
    $(window).on('beforeunload', function() {
        deletetempdata();
        return "";
    });
});


function deletetempdata() {

    Ext.Ajax.request({
        url: '<%=request.getContextPath()%>/PaymnetDetailsAction.do?param=BrowserWindowClosed',
        method: 'POST',
        params: {
            TempId1: tempId1,
            TempId2: tempId2
        },
        success: function(response, options) {},
        failure: function() {}
    });
}

function maxAgevalidation(id) {
    var LIMIT = 2;
    var txt = document.getElementById(id).value.length;
    if (txt > LIMIT) {
        valid = false;
        Ext.example.msg("Please EnterValid Age Of The Passanger ");
    }
}

function phonenumbervalidation() {
    var LIMIT = 10;
    var txt = document.getElementById('Phone').value.length;
    if (txt > LIMIT) {
        phvalid = false;
    } else {
        phvalid = true;
    }
}

function validateEmail() {
    var reg = /^([A-Za-z0-9_\-\.])+\@([A-Za-z0-9_\-\.])+\.([A-Za-z]{2,4})$/;

    if (reg.test(document.getElementById('Email').value) == false) {
        emailvalid = false;
    } else {
        emailvalid = true;
    }

}

function isNumber(evt) {
    evt = (evt) ? evt : window.event;
    var charCode = (evt.which) ? evt.which : evt.keyCode;
    if (charCode > 31 && (charCode < 48 || charCode > 57)) {
        return false;
    }
    return true;
}

</script>



<form name = 'paymentform' action="https://stageserv.interswitchng.com/test_paydirect/pay" method="post">
<input name="product_id" type="hidden" value="6205" />
<input name="pay_item_id" type="hidden" value="101" />
<input name="amount" id = "amount" type="hidden" value="" />
<input name="currency" type="hidden" value="566" />
<input name="site_redirect_url" id = "site_redirect_url" type="hidden" value=""/>
<input name="txn_ref" id = "txn_ref" type="hidden" value="" />
<input name="cust_name" id = "cust_name" type="hidden" value="" />
<input name="cust_id" type="hidden" value="AD99"/>
<input name="hash" id = "hash" type="hidden" value="" />
</form>
 
 
 
 </body>
</html>
<%}%>