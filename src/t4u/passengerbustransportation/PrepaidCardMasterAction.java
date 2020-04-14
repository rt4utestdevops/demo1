package t4u.passengerbustransportation;

import java.util.ArrayList;

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
import t4u.beans.ReportHelper;
import t4u.functions.CommonFunctions;
import t4u.functions.PassengerBusTransportationFunctions;

public class PrepaidCardMasterAction extends Action{
	public ActionForward execute(ActionMapping mapping, ActionForm form,HttpServletRequest request, HttpServletResponse response)throws Exception {
		String param = "";
		String message = "";		
		HttpSession session = request.getSession();
		PassengerBusTransportationFunctions transportationFunctions = new PassengerBusTransportationFunctions();
		LoginInfoBean  logininfo=(LoginInfoBean)session.getAttribute("loginInfoDetails");
		int systemId = logininfo.getSystemId();
		int customerId = logininfo.getCustomerId();
		CommonFunctions cf = new CommonFunctions();		
		int userId = logininfo.getUserId();	
		String lang = logininfo.getLanguage();
		JSONArray jsonArray = null;
		JSONObject jsonObject = new JSONObject();
		
		if (request.getParameter("param") != null) {
			param = request.getParameter("param").toString();
		}
		
		if (param.equalsIgnoreCase("getprepaidCardMasterList")) {
			try {				
				String jspName = request.getParameter("jspName");
				String custName = cf.getCustomerName(String.valueOf(customerId),systemId);
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				ArrayList < Object > list = transportationFunctions.getprepaidCardMasterList(systemId,customerId,userId,lang);
				jsonArray = (JSONArray) list.get(0);
				if (jsonArray.length() > 0) {
					jsonObject.put("prepaidCardMaster", jsonArray);
				} else {
					jsonObject.put("prepaidCardMaster", "");
				}
				 ReportHelper reportHelper = (ReportHelper) list.get(1);
				 request.getSession().setAttribute(jspName, reportHelper);
                 request.getSession().setAttribute("custId", custName);
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		if (param.equalsIgnoreCase("addOrModifyPrepaidCardMasterList")) {
			 try {
		        	String buttonValue = request.getParameter("buttonValue");
		        	//String cardNo = request.getParameter("cardNumber");
		        	String cardHolderName = request.getParameter("cardHolderName");
		        	String emailId = request.getParameter("emailId");
		        	String phoneNo = request.getParameter("phoneNo");
		        	String amount = request.getParameter("amount");
		        	String uniqueId=request.getParameter("uniqueId");
		        	int updatedBy = userId;
		            message="";
		            if (buttonValue.equals("Add")) {
		                message = transportationFunctions.insertCardDetails(cardHolderName,phoneNo,emailId,Double.parseDouble(amount),systemId,customerId,userId);
		            } else if (buttonValue.equals("modify")) {
		            	 message = transportationFunctions.modifyCardDetails(cardHolderName,phoneNo,emailId,Double.parseDouble(amount),updatedBy,systemId,customerId,Integer.parseInt(uniqueId));
		            }
		            response.getWriter().print(message);
		        } catch (Exception e) {
		            e.printStackTrace();
		        }
		    }
		
		if (param.equalsIgnoreCase("getprepaidCardMasterRefundList")) {
			try {				
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				String referenceCode = request.getParameter("referenceCode");
				String emailId=request.getParameter("emailId");
				ArrayList < Object > list = transportationFunctions.getprepaidCardMasterRefundList(systemId,customerId,referenceCode,emailId);
				jsonArray = (JSONArray) list.get(0);
				if (jsonArray.length() > 0) {
					jsonObject.put("prepaidCardMasterRefund", jsonArray);
				} else {
					jsonObject.put("prepaidCardMasterRefund", "");
				}
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		
		if (param.equalsIgnoreCase("checkReferencecodeAndEmailId")) {
			try {				
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				String referenceCode = request.getParameter("referenceCode");
				String emailId=request.getParameter("emailId");
				String message1 = transportationFunctions.checkReferencecodeAndEmailId(referenceCode,emailId,systemId,customerId);
				response.getWriter().print(message1);
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		
		if (param.equalsIgnoreCase("refundPrepaidCardMasterList")) {
			try {				
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				String referenceCode = request.getParameter("referenceCode");
				String emailId=request.getParameter("emailId");
				String message1 = transportationFunctions.refundPrepaidCarddetails(referenceCode,emailId,systemId,customerId,userId);
				response.getWriter().print(message1);
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		return null;
	}
}
