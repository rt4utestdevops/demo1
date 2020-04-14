package t4u.CarRental;

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
import t4u.functions.CarRentalFunctions;

public class JetFleetTripDetailsAction extends Action {
	public ActionForward execute(ActionMapping mapping, ActionForm form,HttpServletRequest request, HttpServletResponse response) throws Exception {
		try {
			HttpSession session = request.getSession();
			LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
			int systemId = loginInfo.getSystemId();
			int customerId = loginInfo.getCustomerId();
			int userId = loginInfo.getUserId();
			int offset = loginInfo.getOffsetMinutes();
			String zone=loginInfo.getZone();
			String language = loginInfo.getLanguage();
			
			CarRentalFunctions cfunc=new CarRentalFunctions();
			JSONObject jsonObject = null;			
			JSONArray jsonArray = null;
			String param = "";
			if (request.getParameter("param") != null) {
				param = request.getParameter("param").toString();
			}
			if(param.equals("getJFTripDetails"))
			{
				try {
					 String custId = request.getParameter("custId");
					 String custName = request.getParameter("custName");
					 String startDate = request.getParameter("startDate");
					 String endDate = request.getParameter("endDate");
					 String jspName = request.getParameter("jspName");
					 
					 SimpleDateFormat yyyyMMdd = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
					 SimpleDateFormat ddMMyyyy = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
					 
					jsonArray = new JSONArray();
					jsonObject = new JSONObject();
					ArrayList <Object> List = cfunc.getJFTripDetailsReport(systemId, Integer.parseInt(custId),startDate,endDate,zone,language,offset);
					jsonArray = (JSONArray) List.get(0);
					if (jsonArray.length() > 0) {
						jsonObject.put("JFTripDetailsRoot", jsonArray);
					} else {
						jsonObject.put("JFTripDetailsRoot", "");
					}
					ReportHelper reportHelper = (ReportHelper) List.get(1);
					session.setAttribute(jspName, reportHelper);
					session.setAttribute("startDate", ddMMyyyy.format(yyyyMMdd.parseObject(startDate.replace("T", " "))));
					session.setAttribute("endDate", ddMMyyyy.format(yyyyMMdd.parseObject(endDate.replace("T", " "))));
					session.setAttribute("custName", custName);
					response.getWriter().print(jsonObject.toString());
				} catch (Exception e) {
					e.printStackTrace();
				}

			}
			

		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}

}
