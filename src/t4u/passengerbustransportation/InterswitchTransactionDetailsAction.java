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
import t4u.functions.IronMiningFunction;
import t4u.functions.PassengerBusTransportationFunctions;

public class InterswitchTransactionDetailsAction extends Action{

	@SuppressWarnings("unchecked")
	public ActionForward execute(ActionMapping mapping, ActionForm form,HttpServletRequest request, HttpServletResponse response) throws Exception {
		HttpSession session = request.getSession();
		ReportHelper reportHelper = null;
		LoginInfoBean loginInfo =(LoginInfoBean)session.getAttribute("loginInfoDetails");
		int systemId  = loginInfo.getSystemId();
		//int customerId = loginInfo.getCustomerId();
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
		if (param.equalsIgnoreCase("getTransactionDetails")) {
			try {
				ArrayList list=null;
			 	SimpleDateFormat yyyymmdd = new SimpleDateFormat("yyyy-MM-dd");
				SimpleDateFormat ddmmyyyy = new SimpleDateFormat("dd-MM-yyyy");
				 String CustomerId = request.getParameter("CustId");
      	         String fromdate=request.getParameter("fromdate");
      	         String todate=request.getParameter("todate");
			     String jspName = request.getParameter("jspName");
			     String custName = request.getParameter("custName");
				 jsonArray = new JSONArray();
				 jsonObject = new JSONObject();
				if(fromdate.contains("T") && todate.contains("T")){
					fromdate=fromdate.substring(0,fromdate.indexOf("T"));
					todate=todate.substring(0,todate.indexOf("T"));
				}
				if (CustomerId != null && !CustomerId.equals("")) {
					list =func.getTransactionDetails(Integer.parseInt(CustomerId), systemId,fromdate,todate);
					jsonArray = (JSONArray) list.get(0);
					if (jsonArray.length() > 0) {
						jsonObject.put("interswitchDetailsRoot", jsonArray);
					} else {
						jsonObject.put("interswitchDetailsRoot", "");
					}
				    reportHelper= (ReportHelper) list.get(1);
					request.getSession().setAttribute(jspName,reportHelper);
					request.getSession().setAttribute("custId", custName);
					request.getSession().setAttribute("fromDate", ddmmyyyy.format(yyyymmdd.parse(fromdate)));
					request.getSession().setAttribute("toDate", ddmmyyyy.format(yyyymmdd.parse(todate)));
					
					response.getWriter().print(jsonObject.toString());
				} 
			} catch (Exception e) {
				e.printStackTrace();
			}
		}

		return null;
	}
}