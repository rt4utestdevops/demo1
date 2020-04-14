package t4u.passengerbustransportation;

import java.text.SimpleDateFormat;
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

public class TransactionRequeryAction extends Action{

	@SuppressWarnings("unchecked")
	public ActionForward execute(ActionMapping mapping, ActionForm form,HttpServletRequest request, HttpServletResponse response) throws Exception {
		HttpSession session = request.getSession();
		ReportHelper reportHelper = null;
		LoginInfoBean loginInfo =(LoginInfoBean)session.getAttribute("loginInfoDetails");
		int systemId  = loginInfo.getSystemId();
		//int customerId = loginInfo.getCustomerId();
		int userId = loginInfo.getUserId();
		int offset = 0;
		offset = loginInfo.getOffsetMinutes();
		//int offset = loginInfo.getOffsetMinutes();
		String lang = loginInfo.getLanguage();
		CommonFunctions cf=new CommonFunctions();
		PassengerBusTransportationFunctions func = new PassengerBusTransportationFunctions();
		JSONArray jsonArray = null;
		JSONObject jsonObject=null;
		String param = "";
		if (request.getParameter("param") != null) {
			param = request.getParameter("param").toString();
		}
		 if (param.equalsIgnoreCase("getRequeryDetails")) {
			jsonArray = new JSONArray();
			jsonObject=new JSONObject();
			try { 
				 String CustomerId = request.getParameter("CustId");
      	         String fromdate=request.getParameter("fromdate");
      	         String todate=request.getParameter("todate");
      	         if(fromdate.contains("T") && todate.contains("T")){
					fromdate=fromdate.replaceAll("T", " ");
					todate=todate.replaceAll("T", " ");
	   	         }
				jsonArray=func.getRequeryDetails(Integer.parseInt(CustomerId), systemId,fromdate,todate);
			
				if (jsonArray.length() > 0) {
					jsonObject.put("requryRoot", jsonArray);
				} else {
					jsonObject.put("requryRoot", "");
				}
				response.getWriter().print(jsonObject.toString());
			}
			catch (Exception e) {
				e.printStackTrace();
			}
			
		}
		 else if (param.equalsIgnoreCase("getRequeryPermission")) {
			
			try { 
				String transaction= request.getParameter("transaction");
				 
	            	String status =func.getTransactionDetails(transaction);
	            	 if(status.equals("00")){
	            		 status="success";
	            	 }
	            	 else{
	            		 status="failed";
	            	 }
	            	String reason = func.UpdateTransactionStatus(status,transaction); 
				 response.getWriter().print(reason);
			}
			catch (Exception e) {
				e.printStackTrace();
			}
			
		}
		
		return null;
	}
}
