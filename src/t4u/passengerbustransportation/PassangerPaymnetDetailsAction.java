package t4u.passengerbustransportation;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.struts.action.Action;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import t4u.functions.PassengerBusTransportationFunctions;



public class PassangerPaymnetDetailsAction extends Action {

    public ActionForward execute(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) throws Exception {
        String param = "";       
        PassengerBusTransportationFunctions makepayment = new PassengerBusTransportationFunctions();
        if (request.getParameter("param") != null) {
            param = request.getParameter("param").toString();
        }

        if (param.equals("CheckCouponCodeAmountAndValidity")) {
            String message = "";
            try {
                String couponferid = request.getParameter("CouponrefId");
                couponferid = couponferid.toLowerCase();
                String couponcode = request.getParameter("CouponCode");
                couponcode = couponcode.toUpperCase();
                String totalAmount = request.getParameter("TotalAmount");
                String coupongenmode = request.getParameter("CouponCodegenMode");
                if (!couponcode.equalsIgnoreCase("") && couponcode != null) {
                    message = makepayment.checkCouponCodeValidity(couponcode, couponferid, Integer.parseInt(totalAmount), coupongenmode);
                    if (message.equals("Valid")) {
                        response.getWriter().print(message);
                    } else if (message.contains("#")) {
                        response.getWriter().print(message);
                    } else if (message.equals("Not Valid")) {
                        response.getWriter().print(message);
                    }

                } else {
                    message = "Not Valid";
                    response.getWriter().print(message);
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        } else if (param.equals("BookATicketByCasCoupon")) {
            String message = "";
            try {
                String isCouponAmountSufficient = "";
                String couponcode = "";
                String couponferid = "";
                String seatNo = "";
                String paymentmode = "";
                String phoneEmailDetails = "";
                String PassangerDetails = "";
                String totalAmount = "";
                int seatnos = 0;
                String roundtrip = "";
                String detailslist1 = "";
                String detailslist2 = "";
                int tempid1 = 0;
                int tempid2 = 0;
                String customerID = "";
                String systemID = "";
                int userID = 0;
                if (request.getParameter("TempId1") != null && !request.getParameter("TempId1").equalsIgnoreCase("")) {
                    tempid1 = Integer.parseInt(request.getParameter("TempId1"));
                }
                if (request.getParameter("TempId2") != null && !request.getParameter("TempId2").equalsIgnoreCase("")) {
                    tempid2 = Integer.parseInt(request.getParameter("TempId2"));
                }
                if (request.getParameter("IsCouponAmountSufficient") != null && !request.getParameter("IsCouponAmountSufficient").equalsIgnoreCase("")) {
                    isCouponAmountSufficient = request.getParameter("IsCouponAmountSufficient");
                }
                if (request.getParameter("CouponCode") != null && !request.getParameter("CouponCode").equalsIgnoreCase("")) {
                    couponcode = request.getParameter("CouponCode");
                }
                if (request.getParameter("CouponRefId") != null && !request.getParameter("CouponRefId").equalsIgnoreCase("")) {
                    couponferid = request.getParameter("CouponRefId");
                }
                if (request.getParameter("PaymetMode") != null && !request.getParameter("PaymetMode").equalsIgnoreCase("")) {
                    paymentmode = request.getParameter("PaymetMode");
                }
                if (request.getParameter("PhoneEmailDetails") != null && !request.getParameter("PhoneEmailDetails").equalsIgnoreCase("")) {
                    phoneEmailDetails = request.getParameter("PhoneEmailDetails");
                }
                if (request.getParameter("PassangerDetails") != null && !request.getParameter("PassangerDetails").equalsIgnoreCase("")) {
                    PassangerDetails = request.getParameter("PassangerDetails");
                }
                if (request.getParameter("TotalAmount") != null && !request.getParameter("TotalAmount").equalsIgnoreCase("")) {
                    totalAmount = request.getParameter("TotalAmount");
                }
                if (request.getParameter("SeatNo") != null && !request.getParameter("SeatNo").equalsIgnoreCase("")) {
                    seatNo = request.getParameter("SeatNo");
                    seatnos = Integer.parseInt(seatNo);
                }
                if (request.getParameter("RoundTrip") != null && !request.getParameter("RoundTrip").equalsIgnoreCase("")) {
                    roundtrip = request.getParameter("RoundTrip");
                }
                if (request.getParameter("Detailslist1") != null && !request.getParameter("Detailslist1").equalsIgnoreCase("")) {
                    detailslist1 = request.getParameter("Detailslist1");
                }
                if (request.getParameter("Detailslist2") != null && !request.getParameter("Detailslist2").equalsIgnoreCase("")) {
                    detailslist2 = request.getParameter("Detailslist2");
                }
                if (request.getParameter("SystemId") != null && !request.getParameter("SystemId").equalsIgnoreCase("")) {
                    systemID = request.getParameter("SystemId");
                }
                if (request.getParameter("CustomerId") != null && !request.getParameter("CustomerId").equalsIgnoreCase("")) {
                    customerID = request.getParameter("CustomerId");
                }
                if (request.getParameter("UserId") != null && !request.getParameter("UserId").equalsIgnoreCase("")) {
                    userID = Integer.parseInt(request.getParameter("UserId"));
                }              
                if (Double.parseDouble(totalAmount) != 0 && seatnos != 0) {

                    if (roundtrip.equalsIgnoreCase("true")) {

                        String serviceId1 = "";
                        String journeydate1 = "";
                        String rateId1 = "";
                        String terminalId1 = "";
                        String dedicatedSeatnumbers1 = "";
                        String serviceId2 = "";
                        String journeydate2 = "";
                        String rateId2 = "";
                        String terminalId2 = "";
                        String dedicatedSeatnumbers2 = "";
                        String[] detailslists1 = detailslist1.split(",");
                        rateId1 = detailslists1[0];
                        serviceId1 = detailslists1[1];
                        journeydate1 = detailslists1[2];
                        dedicatedSeatnumbers1 = detailslists1[3];
                        terminalId1 = detailslists1[4];
                        String[] detailslists2 = detailslist2.split(",");
                        rateId2 = detailslists2[0];
                        serviceId2 = detailslists2[1];
                        journeydate2 = detailslists2[2];
                        dedicatedSeatnumbers2 = detailslists2[3];
                        terminalId2 = detailslists2[4];

                        message = makepayment.BookingTheTicketFunctionFOrRoundTrip(tempid1, tempid2, isCouponAmountSufficient, couponcode, couponferid, Integer.parseInt(systemID), Integer.parseInt(customerID), seatnos, paymentmode, phoneEmailDetails, PassangerDetails, Double.parseDouble(totalAmount), roundtrip, Integer.parseInt(serviceId1), Integer.parseInt(rateId1), journeydate1, dedicatedSeatnumbers1, Integer.parseInt(terminalId1), Integer.parseInt(serviceId2), Integer.parseInt(rateId2), journeydate2, dedicatedSeatnumbers2, Integer.parseInt(terminalId2),userID);
                        if (message.contains("success")) {
                            response.getWriter().print(message);
                        } else if (message.contains("failed")) {
                            response.getWriter().print(message);
                        } else if (message.contains("booked")) {
                            response.getWriter().print(message);
                        } else {
                            message = "failed";
                            response.getWriter().print(message);
                        }
                    } else if (roundtrip.equalsIgnoreCase("false")) {

                        String serviceId = "";
                        String journeydate = "";
                        String rateId = "";
                        String dedicatedSeatnumbers = "";
                        String terminalId = "";
                        String[] detailslists1 = detailslist1.split(",");
                        rateId = detailslists1[0];
                        serviceId = detailslists1[1];
                        journeydate = detailslists1[2];
                        dedicatedSeatnumbers = detailslists1[3];
                        terminalId = detailslists1[4];


                        message = makepayment.BookingTheTicketFunction(tempid1, isCouponAmountSufficient, couponcode, couponferid, Integer.parseInt(systemID), Integer.parseInt(customerID), serviceId, rateId, seatnos, dedicatedSeatnumbers, paymentmode, phoneEmailDetails, PassangerDetails, Double.parseDouble(totalAmount), journeydate, roundtrip, Integer.parseInt(terminalId),userID);
                        if (message.contains("success")) {
                            response.getWriter().print(message);
                        } else if (message.contains("failed")) {
                            response.getWriter().print(message);
                        } else if (message.contains("booked")) {
                            response.getWriter().print(message);
                        } else {
                            message = "failed";
                            response.getWriter().print(message);
                        }
                    }
                } else {
                    message = "failed";
                    response.getWriter().print(message);
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        } else if (param.equals("BookATicketByPaymentGateway")) {
            String message = "";
            try {

                String seatNo = "";
                String paymentmode = "";
                String phoneEmailDetails = "";
                String PassangerDetails = "";
                String totalAmount = "";
                int seatnos = 0;
                String customerID = "";
                String systemID = "";
                int userID = 0;
                String roundtrip = "";
                String detailslist1 = "";
                String detailslist2 = "";
                int tempid1 = 0;
                int tempid2 = 0;
                String basepath = "";
                if (request.getParameter("basePath") != null && !request.getParameter("basePath").equalsIgnoreCase("")) {
                	basepath = request.getParameter("basePath");
                }
                if (request.getParameter("TempId1") != null && !request.getParameter("TempId1").equalsIgnoreCase("")) {
                    tempid1 = Integer.parseInt(request.getParameter("TempId1"));
                }
                if (request.getParameter("TempId2") != null && !request.getParameter("TempId2").equalsIgnoreCase("")) {
                    tempid2 = Integer.parseInt(request.getParameter("TempId2"));
                }
                if (request.getParameter("PaymetMode") != null && !request.getParameter("PaymetMode").equalsIgnoreCase("")) {
                    paymentmode = request.getParameter("PaymetMode");
                }
                if (request.getParameter("PhoneEmailDetails") != null && !request.getParameter("PhoneEmailDetails").equalsIgnoreCase("")) {
                    phoneEmailDetails = request.getParameter("PhoneEmailDetails");
                }
                if (request.getParameter("PassangerDetails") != null && !request.getParameter("PassangerDetails").equalsIgnoreCase("")) {
                    PassangerDetails = request.getParameter("PassangerDetails");
                }
                if (request.getParameter("TotalAmount") != null && !request.getParameter("TotalAmount").equalsIgnoreCase("")) {
                    totalAmount = request.getParameter("TotalAmount");
                }
                if (request.getParameter("SeatNo") != null && !request.getParameter("SeatNo").equalsIgnoreCase("")) {
                    seatNo = request.getParameter("SeatNo");
                    seatnos = Integer.parseInt(seatNo);
                }
                if (request.getParameter("RoundTrip") != null && !request.getParameter("RoundTrip").equalsIgnoreCase("")) {
                    roundtrip = request.getParameter("RoundTrip");
                }
                if (request.getParameter("Detailslist1") != null && !request.getParameter("Detailslist1").equalsIgnoreCase("")) {
                    detailslist1 = request.getParameter("Detailslist1");
                }
                if (request.getParameter("Detailslist2") != null && !request.getParameter("Detailslist2").equalsIgnoreCase("")) {
                    detailslist2 = request.getParameter("Detailslist2");
                }
                if (request.getParameter("SystemId") != null && !request.getParameter("SystemId").equalsIgnoreCase("")) {
                    systemID = request.getParameter("SystemId");
                }
                if (request.getParameter("CustomerId") != null && !request.getParameter("CustomerId").equalsIgnoreCase("")) {
                    customerID = request.getParameter("CustomerId");
                }
                if (request.getParameter("UserId") != null && !request.getParameter("UserId").equalsIgnoreCase("")) {
                    userID = Integer.parseInt(request.getParameter("UserId"));
                }

                if (Double.parseDouble(totalAmount) != 0 && seatnos != 0) {

                    if (roundtrip.equalsIgnoreCase("true")) {
                        String serviceId1 = "";
                        String journeydate1 = "";
                        String rateId1 = "";
                        String dedicatedSeatnumbers1 = "";
                        String terminalId1 = "";
                        String serviceId2 = "";
                        String journeydate2 = "";
                        String rateId2 = "";
                        String dedicatedSeatnumbers2 = "";
                        String terminalId2 = "";
                        String[] detailslists1 = detailslist1.split(",");
                        rateId1 = detailslists1[0];
                        serviceId1 = detailslists1[1];
                        journeydate1 = detailslists1[2];
                        dedicatedSeatnumbers1 = detailslists1[3];
                        terminalId1 = detailslists1[4];
                        String[] detailslists2 = detailslist2.split(",");
                        rateId2 = detailslists2[0];
                        serviceId2 = detailslists2[1];
                        journeydate2 = detailslists2[2];
                        dedicatedSeatnumbers2 = detailslists2[3];
                        terminalId2 = detailslists2[4];
                        message = makepayment.BookingTheTicketFunctionUsingPaymetGateWayForRoundTrip(tempid1, tempid2, Integer.parseInt(systemID), Integer.parseInt(customerID), seatnos, paymentmode, phoneEmailDetails, PassangerDetails, Double.parseDouble(totalAmount), roundtrip, Integer.parseInt(serviceId1), Integer.parseInt(rateId1), journeydate1, dedicatedSeatnumbers1, Integer.parseInt(terminalId1), Integer.parseInt(serviceId2), Integer.parseInt(rateId2), journeydate2, dedicatedSeatnumbers2, Integer.parseInt(terminalId2),userID,basepath);
                        if (message.contains("success")) {
                            response.getWriter().print(message);
                        } else if (message.contains("failed")) {
                            response.getWriter().print(message);
                        } else if (message.contains("booked")) {
                            response.getWriter().print(message);
                        }else {
                            message = "failed";
                            response.getWriter().print(message);
                        }
                    } else if (roundtrip.equalsIgnoreCase("false")) {

                        String serviceId = "";
                        String journeydate = "";
                        String rateId = "";
                        String dedicatedSeatnumbers = "";
                        String terminalId = "";
                        String[] detailslists1 = detailslist1.split(",");
                        rateId = detailslists1[0];
                        serviceId = detailslists1[1];
                        journeydate = detailslists1[2];
                        dedicatedSeatnumbers = detailslists1[3];
                        terminalId = detailslists1[4];


                        message = makepayment.BookingTheTicketFunctionUsingPaymetGateWay(tempid1, Integer.parseInt(systemID), Integer.parseInt(customerID), serviceId, rateId, seatnos, dedicatedSeatnumbers, paymentmode, phoneEmailDetails, PassangerDetails, Double.parseDouble(totalAmount), journeydate, roundtrip, Integer.parseInt(terminalId), userID,basepath);
                        if (message.contains("success")) {
                            response.getWriter().print(message);
                        } else if (message.contains("failed")) {
                            response.getWriter().print(message);
                        } else if (message.contains("booked")) {
                            response.getWriter().print(message);
                        }else {
                            message = "failed";
                            response.getWriter().print(message);
                        }
                    }
                } else {
                    message = "failed";
                    response.getWriter().print(message);
                }
            } catch (Exception e) {
                e.printStackTrace();
            }

        } else if (param.equals("BrowserWindowClosed")) {
        	int tempid1 = 0;
            int tempid2 = 0;
            if (request.getParameter("TempId1") != null && !request.getParameter("TempId1").equalsIgnoreCase("")) {
                tempid1 = Integer.parseInt(request.getParameter("TempId1"));
            }
            if (request.getParameter("TempId2") != null && !request.getParameter("TempId2").equalsIgnoreCase("")) {
                tempid2 = Integer.parseInt(request.getParameter("TempId2"));
            }
            
            makepayment.deletetempdata(tempid1,tempid2);
            
        }
        
        else if (param.equals("BookATicketBySplitPayment")) {
        	String splitpaymentmode = "";
			String primarypaymentmode = "";
			String primarycouponcode = "";
			String primarytotal = "";
			String secondaryoaymentmode = "";
			String secondaycouponcode = "";
			String secondarytotal = "";
            String seatNo = "";
            String phoneEmailDetails = "";
            String PassangerDetails = "";
            String totalAmount = "";
            int seatnos = 0;
            String roundtrip = "";
            String detailslist1 = "";
            String detailslist2 = "";
            int tempid1 = 0;
            int tempid2 = 0;
			String message = "";
			String customerID = "";
            String systemID = "";
            int userID = 0;
            String basepath = "";
        	try{
        		 if (request.getParameter("basePath") != null && !request.getParameter("basePath").equalsIgnoreCase("")) {
                 	basepath = request.getParameter("basePath");
                 }
        		
        		
        		if (request.getParameter("Splitpaymentmode") != null && !request.getParameter("Splitpaymentmode").equalsIgnoreCase("")) {
                    splitpaymentmode = request.getParameter("Splitpaymentmode");
                }
				if (request.getParameter("Primarypaymentmode") != null && !request.getParameter("Primarypaymentmode").equalsIgnoreCase("")) {
                    primarypaymentmode = request.getParameter("Primarypaymentmode");
                    if(primarypaymentmode.equals("cashcoupon")){
                    	primarypaymentmode = "prepaidcard";	
                    }else if(primarypaymentmode.equals("couponcode")){
                    	primarypaymentmode = "couponcode";		
                    }
                }
				if (request.getParameter("Primarycouponcode") != null && !request.getParameter("Primarycouponcode").equalsIgnoreCase("")) {
                    primarycouponcode = request.getParameter("Primarycouponcode");
                }
				if (request.getParameter("Primarytotal") != null && !request.getParameter("Primarytotal").equalsIgnoreCase("")) {
                    primarytotal = request.getParameter("Primarytotal");
                }
				if (request.getParameter("Secondaryoaymentmode") != null && !request.getParameter("Secondaryoaymentmode").equalsIgnoreCase("")) {
                    secondaryoaymentmode = request.getParameter("Secondaryoaymentmode");
                    if(secondaryoaymentmode.equals("cashcoupon")){
                    	secondaryoaymentmode = "prepaidcard";	
                    }else if(secondaryoaymentmode.equals("couponcode")){
                    	secondaryoaymentmode = "couponcode";		
                    }
                }
				if (request.getParameter("Secondaycouponcode") != null && !request.getParameter("Secondaycouponcode").equalsIgnoreCase("")) {
                    secondaycouponcode = request.getParameter("Secondaycouponcode");
                }
				if (request.getParameter("Secondarytotal") != null && !request.getParameter("Secondarytotal").equalsIgnoreCase("")) {
                    secondarytotal = request.getParameter("Secondarytotal");
                }				
                if (request.getParameter("TempId1") != null && !request.getParameter("TempId1").equalsIgnoreCase("")) {
                    tempid1 = Integer.parseInt(request.getParameter("TempId1"));
                }
                if (request.getParameter("TempId2") != null && !request.getParameter("TempId2").equalsIgnoreCase("")) {
                    tempid2 = Integer.parseInt(request.getParameter("TempId2"));
                }               
                if (request.getParameter("PhoneEmailDetails") != null && !request.getParameter("PhoneEmailDetails").equalsIgnoreCase("")) {
                    phoneEmailDetails = request.getParameter("PhoneEmailDetails");
                }
                if (request.getParameter("PassangerDetails") != null && !request.getParameter("PassangerDetails").equalsIgnoreCase("")) {
                    PassangerDetails = request.getParameter("PassangerDetails");
                }
                if (request.getParameter("TotalAmount") != null && !request.getParameter("TotalAmount").equalsIgnoreCase("")) {
                    totalAmount = request.getParameter("TotalAmount");
                }
                if (request.getParameter("SeatNo") != null && !request.getParameter("SeatNo").equalsIgnoreCase("")) {
                    seatNo = request.getParameter("SeatNo");
                    seatnos = Integer.parseInt(seatNo);
                }
                if (request.getParameter("RoundTrip") != null && !request.getParameter("RoundTrip").equalsIgnoreCase("")) {
                    roundtrip = request.getParameter("RoundTrip");
                }
                if (request.getParameter("Detailslist1") != null && !request.getParameter("Detailslist1").equalsIgnoreCase("")) {
                    detailslist1 = request.getParameter("Detailslist1");
                }
                if (request.getParameter("Detailslist2") != null && !request.getParameter("Detailslist2").equalsIgnoreCase("")) {
                    detailslist2 = request.getParameter("Detailslist2");
                }
                if (request.getParameter("SystemId") != null && !request.getParameter("SystemId").equalsIgnoreCase("")) {
                    systemID = request.getParameter("SystemId");
                }
                if (request.getParameter("CustomerId") != null && !request.getParameter("CustomerId").equalsIgnoreCase("")) {
                    customerID = request.getParameter("CustomerId");
                }
                if (request.getParameter("UserId") != null && !request.getParameter("UserId").equalsIgnoreCase("")) {
                    userID = Integer.parseInt(request.getParameter("UserId"));
                }
                
                if (Double.parseDouble(totalAmount) != 0 && seatnos != 0 && splitpaymentmode.equals("true")) {

                    if (roundtrip.equalsIgnoreCase("true")) {
                        String serviceId1 = "";
                        String journeydate1 = "";
                        String rateId1 = "";
                        String dedicatedSeatnumbers1 = "";
                        String terminalId1 = "";
                        String serviceId2 = "";
                        String journeydate2 = "";
                        String rateId2 = "";
                        String dedicatedSeatnumbers2 = "";
                        String terminalId2 = "";
                        String[] detailslists1 = detailslist1.split(",");
                        rateId1 = detailslists1[0];
                        serviceId1 = detailslists1[1];
                        journeydate1 = detailslists1[2];
                        dedicatedSeatnumbers1 = detailslists1[3];
                        terminalId1 = detailslists1[4];
                        String[] detailslists2 = detailslist2.split(",");
                        rateId2 = detailslists2[0];
                        serviceId2 = detailslists2[1];
                        journeydate2 = detailslists2[2];
                        dedicatedSeatnumbers2 = detailslists2[3];
                        terminalId2 = detailslists2[4];
                        message = makepayment.TicketBookingFunctionUsingSplitPaymentmodeForRoundTrip(tempid1, tempid2, Integer.parseInt(systemID), Integer.parseInt(customerID), seatnos, phoneEmailDetails, PassangerDetails, Double.parseDouble(totalAmount), roundtrip, Integer.parseInt(serviceId1), Integer.parseInt(rateId1), journeydate1, dedicatedSeatnumbers1, Integer.parseInt(terminalId1), Integer.parseInt(serviceId2), Integer.parseInt(rateId2), journeydate2, dedicatedSeatnumbers2, Integer.parseInt(terminalId2),primarypaymentmode,primarycouponcode,primarytotal,secondaryoaymentmode,secondaycouponcode,secondarytotal,userID,basepath);
                        if (message.contains("success")) {
                            response.getWriter().print(message);
                        } else if (message.contains("failed")) {
                            response.getWriter().print(message);
                        }else if (message.contains("booked")) {
                            response.getWriter().print(message);
                        } else {
                            message = "failed";
                            response.getWriter().print(message);
                        }
                    } else if (roundtrip.equalsIgnoreCase("false")) {

                        String serviceId = "";
                        String journeydate = "";
                        String rateId = "";
                        String dedicatedSeatnumbers = "";
                        String terminalId = "";
                        String[] detailslists1 = detailslist1.split(",");
                        rateId = detailslists1[0];
                        serviceId = detailslists1[1];
                        journeydate = detailslists1[2];
                        dedicatedSeatnumbers = detailslists1[3];
                        terminalId = detailslists1[4];


                        message = makepayment.TicketBookingFunctionUsingSplitPaymentmode(tempid1, Integer.parseInt(systemID), Integer.parseInt(customerID), serviceId, rateId, seatnos, dedicatedSeatnumbers, phoneEmailDetails, PassangerDetails, Double.parseDouble(totalAmount), journeydate, roundtrip, Integer.parseInt(terminalId),primarypaymentmode,primarycouponcode,primarytotal,secondaryoaymentmode,secondaycouponcode,secondarytotal,userID,basepath);
                        if (message.contains("success")) {
                            response.getWriter().print(message);
                        } else if (message.contains("failed")) {
                            response.getWriter().print(message);
                        } else if (message.contains("booked")) {
                            response.getWriter().print(message);
                        } else {
                            message = "failed";
                            response.getWriter().print(message);
                        }
                    }
                } else {
                    message = "failed";
                    response.getWriter().print(message);
                }
                
                
        		
        	}catch(Exception e){
        	e.printStackTrace();	
        	}
            
        }
        
        else if (param.equals("DeductAmountFromPrepaidAndCoupon")) {
            String message = "";
            try {
                String paymentmode = request.getParameter("PaymentMode");
                String couponcode = request.getParameter("CouponCode");
                String totalAmount = request.getParameter("TotalAmount");
                String transactionId = request.getParameter("TransactionId");
                if (!transactionId.equalsIgnoreCase("") && transactionId != null) {
                    message = makepayment.deductAmountFromPrepaidAndCoupon(paymentmode,couponcode,Double.parseDouble(totalAmount),transactionId);
                    
                    if (message.equals("success")) {
                        response.getWriter().print(message);
                    } else{
                    	 message = "failed";
                         response.getWriter().print(message);	
                    }
                } else {
                    message = "failed";
                    response.getWriter().print(message);
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        
        return null;
    }


}