package t4u.passengerbustransportation;

import java.util.Properties;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.struts.action.Action;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import t4u.beans.LoginInfoBean;
import t4u.common.ApplicationListener;
import t4u.functions.PassengerBusTransportationFunctions;

public class UpdateTripDetailsAction extends Action {
	public ActionForward execute(ActionMapping mapping, ActionForm form,HttpServletRequest request, HttpServletResponse response)throws Exception {
		String param = "";	
		HttpSession session = request.getSession();
		Properties properties = ApplicationListener.prop;
		LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
		int systemId=0;
		int customerID = 0;	
		if(loginInfo!=null)
		{
		systemId = loginInfo.getSystemId();
		customerID = loginInfo.getCustomerId();		
		}else{
			customerID=Integer.parseInt(properties.getProperty("customerID").trim());
			systemId=Integer.parseInt(properties.getProperty("systemID").trim());
		}
		PassengerBusTransportationFunctions tripDetails = new PassengerBusTransportationFunctions();
		if (request.getParameter("param") != null) {
			param = request.getParameter("param").toString();
		}
		if (param.equals("checkTripId")) {
			try { 
				String tripId = request.getParameter("tripId");
				String mobileNo="234"+request.getParameter("mobileNo");
				String emailId=request.getParameter("emailId");
				emailId = emailId.toLowerCase();
				String message1=tripDetails.checkTripId(tripId, emailId, mobileNo.trim(), systemId, customerID);
				response.getWriter().print(message1);

			}catch (Exception e) {
				e.printStackTrace();
			}}
		
		if (param.equals("updateDetails")) {
			try { 
				String mobileNo="234"+request.getParameter("mobileNo");
				String emailId=request.getParameter("emailId");
				emailId = emailId.toLowerCase();
				String tripId=request.getParameter("tripId");
				String validMobileNo="234"+request.getParameter("validMobileNo");
				String validEmailId=request.getParameter("validEmailId");
				validEmailId = validEmailId.toLowerCase();
				String message1=tripDetails.updateDetails(tripId, emailId, mobileNo.trim(), validEmailId,validMobileNo,systemId, customerID);
				response.getWriter().print(message1);
			}catch (Exception e) {
				e.printStackTrace();
			}}
		
		return null;
	}

}
