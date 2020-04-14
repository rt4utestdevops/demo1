package t4u.passengerbustransportation;

import java.util.Properties;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.struts.action.Action;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.json.JSONArray;
import org.json.JSONObject;

import t4u.beans.LoginInfoBean;
import t4u.common.ApplicationListener;
import t4u.functions.PassengerBusTransportationFunctions;

public class CancelTicketAction extends Action{

	public ActionForward execute(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		
		String param = "";
		String tripID = "";
		String mobileNum = "";
		HttpSession session = request.getSession();
		Properties properties = ApplicationListener.prop;
		LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
		JSONArray jsonArray = null;
		JSONObject jsonObject=null;
		int systemId=0;
		int customerID = 0;	
		int userID=0;
		if(loginInfo!=null)
		{
			systemId = loginInfo.getSystemId();
			customerID = loginInfo.getCustomerId();		
			userID=loginInfo.getUserId();
		}else{
			customerID=Integer.parseInt(properties.getProperty("customerID").trim());
			systemId=Integer.parseInt(properties.getProperty("systemID").trim());
		}
		String emailID = "";
		PassengerBusTransportationFunctions ptf = new PassengerBusTransportationFunctions();
		
		if (request.getParameter("param") != null) {
			param = request.getParameter("param").toString();
		}
		
		if(param.equals("getPassangerTripInfo")){
			try{
			if(request.getParameter("tripID")!=null){
				tripID=request.getParameter("tripID").trim().toString();
			}
			if(request.getParameter("mobileNum")!=null){
				mobileNum="234"+request.getParameter("mobileNum").trim().toString();
			}
			if(request.getParameter("emailId")!=null){
				emailID=request.getParameter("emailId").trim().toString();
				emailID = emailID.toLowerCase();
			}
			jsonArray = new JSONArray();
			jsonObject = new JSONObject();
			 jsonArray=ptf.getPassangerTripInfo(tripID, mobileNum.trim(), emailID,systemId,customerID);
			 
			 if (jsonArray.length() > 0) {
					jsonObject.put("cancelInfo", jsonArray);
				} else {
					jsonObject.put("cancelInfo", "");
				}
			 response.getWriter().print(jsonObject.toString());			
			
			}catch (Exception e) {
				e.printStackTrace();
			}
		}else if(param.equalsIgnoreCase("getCancelTripInfoRound")){
			String tripType=null;
			String transactionID=null;
			String onwordSeats=null;
			String email=null;
			String returnSeats=null;
			int onwordSelected=0;
			int returnSelected=0;
			int totalCancellation=0;			
			String onwordDate=null;
			String returnDate=null;
			int onwordServiceId=0;
			int returnServiceId=0;
			String passangerCancelTripInfo=null;
			
				try{
					if(request.getParameter("roundTrip")!=null && !request.getParameter("roundTrip").equals("")){
						tripType=request.getParameter("roundTrip").trim().toString();
					}
					if(request.getParameter("tripID")!=null && !request.getParameter("tripID").equals("")){
						transactionID=request.getParameter("tripID").trim().toString();
					}
					if(request.getParameter("onwordSeat")!=null && !request.getParameter("onwordSeat").equals("")){
						onwordSeats=request.getParameter("onwordSeat").trim().toString();
					}
					if(request.getParameter("returnSeat")!=null && !request.getParameter("returnSeat").equals("")){
						returnSeats=request.getParameter("returnSeat").trim().toString();
					}					
					if(request.getParameter("emailId")!=null && !request.getParameter("emailId").equals("")){
						email=request.getParameter("emailId").trim().toString();
						email = email.toLowerCase();
					}
					if(request.getParameter("onwordSelected")!=null && !request.getParameter("onwordSelected").equals("")){
						onwordSelected=Integer.parseInt(request.getParameter("onwordSelected").trim().toString());
					}
					if(request.getParameter("returnSelected")!=null && !request.getParameter("returnSelected").equals("")){
						returnSelected=Integer.parseInt(request.getParameter("returnSelected").trim().toString());
					}					
					if(request.getParameter("totalCancel")!=null && !request.getParameter("totalCancel").equals("")){
						totalCancellation=Integer.parseInt(request.getParameter("totalCancel").trim().toString());
					}					
					if(request.getParameter("onwordDate")!=null && !request.getParameter("onwordDate").equals("")){
						onwordDate=request.getParameter("onwordDate").trim().toString();
					}					
					if(request.getParameter("returnDate")!=null && !request.getParameter("returnDate").equals("") ){
						returnDate=request.getParameter("returnDate").trim().toString();
					}
					if(request.getParameter("onwordServiceId")!=null && !request.getParameter("onwordServiceId").equals("") ){
						onwordServiceId=Integer.parseInt(request.getParameter("onwordServiceId").trim().toString());
					}
					if(request.getParameter("returnServiceId")!=null && !request.getParameter("returnServiceId").equals("") ){
						returnServiceId=Integer.parseInt(request.getParameter("returnServiceId").trim().toString());
					}
					
				passangerCancelTripInfo=ptf.partailCanelationWithMultipleSelected(transactionID,email,tripType,onwordSeats,returnSeats,
								onwordSelected,returnSelected,onwordDate,returnDate,onwordServiceId,returnServiceId,totalCancellation, systemId, customerID, userID);
										
					if(passangerCancelTripInfo!=null){
						response.getWriter().print(passangerCancelTripInfo);
					} else {
						response.getWriter().print("");
					}
				}catch (Exception e) {
					e.printStackTrace();
				}
			}else if(param.equalsIgnoreCase("getCancelTripInfoSingle")){
				String transactionID=null;
				String onwordSeats=null;
				String email=null;
				String phoneNo=null;
				int onwordSelected=0;
				int totalCancellation=0;
				String onwordDate=null;
				int onwordServiceId=0;			
				String passangerCancelTripInfo=null;
				if(request.getParameter("tripID")!=null && !request.getParameter("tripID").equals("")){
					transactionID=request.getParameter("tripID").trim().toString();
				}
				if(request.getParameter("onwordSeat")!=null && !request.getParameter("onwordSeat").equals("")){
					onwordSeats=request.getParameter("onwordSeat").trim().toString();
				}
				if(request.getParameter("onwordSelected")!=null && !request.getParameter("onwordSelected").equals("")){
					onwordSelected=Integer.parseInt(request.getParameter("onwordSelected").trim().toString());
				}
				if(request.getParameter("emailId")!=null && !request.getParameter("emailId").equals("")){
					email=request.getParameter("emailId").trim().toString();
					email = email.toLowerCase();
				}
				if(request.getParameter("phoneNo")!=null && !request.getParameter("phoneNo").equals("")){
					phoneNo="234"+request.getParameter("phoneNo").trim().toString();
				}
				if(request.getParameter("totalCancel")!=null && !request.getParameter("totalCancel").equals("")){
					totalCancellation=Integer.parseInt(request.getParameter("totalCancel").trim().toString());
				}
				if(request.getParameter("onwordDate")!=null && !request.getParameter("onwordDate").equals("")){
					onwordDate=request.getParameter("onwordDate").trim().toString();
				}
				if(request.getParameter("onwordServiceId")!=null && !request.getParameter("onwordServiceId").equals("") ){
					onwordServiceId=Integer.parseInt(request.getParameter("onwordServiceId").trim().toString());
				}
				passangerCancelTripInfo=ptf.partailCanelationWithMultipleSelectedForSingle(transactionID, email, phoneNo, onwordSeats,
						onwordSelected, onwordDate, onwordServiceId, totalCancellation, systemId, customerID, userID);
				
				if(passangerCancelTripInfo!=null){
					response.getWriter().print(passangerCancelTripInfo);
				} else {
					response.getWriter().print("");
				}
			}else if (param.equalsIgnoreCase("getPassengerDetails")){
				String transactionID=null;
				jsonObject = new JSONObject();
				try{
					if(request.getParameter("transactionID")!=null){
						transactionID=request.getParameter("transactionID").trim().toString();
					}
					jsonObject=ptf.getPassengerDetails(transactionID);
					if(jsonObject!=null){
						response.getWriter().print(jsonObject.toString());
					} else {
						response.getWriter().print("");
					}
					
				}catch (Exception e) {
					e.printStackTrace();
				}
			}
			
		
		return null;
	}
}
