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

public class jfTripExceptionReportAction extends Action{
	public ActionForward execute(ActionMapping mapping, ActionForm form,HttpServletRequest request, HttpServletResponse response){
		try
		{
			HttpSession session = request.getSession();
			LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
			int systemId = loginInfo.getSystemId();
			int offset = loginInfo.getOffsetMinutes();
			String language = loginInfo.getLanguage();
			String param = "";
			if (request.getParameter("param") != null) {
				param = request.getParameter("param").toString();
			}
			CarRentalFunctions cfunc = new CarRentalFunctions();
			SimpleDateFormat sdf = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
			SimpleDateFormat sdfDB = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			if(param.equalsIgnoreCase("getTripExceptionReport")){
				String clientId = request.getParameter("ClientId");
				String startDate = request.getParameter("startDate");
				String endDate = request.getParameter("endDate");
				String customerName = request.getParameter("custName");
				String jspName = request.getParameter("jspName");
				JSONObject jsonObject = null;			
				JSONArray jsonArray = null;
				try{
					jsonObject = new JSONObject();
					jsonArray = new JSONArray();
					if(clientId != null && !clientId.equals("")){
						ArrayList <Object> List = cfunc.getTripExceptionReportdetails(systemId,Integer.parseInt(clientId),startDate,endDate,language,offset);
						jsonArray = (JSONArray) List.get(0);
						if(jsonArray.length() > 0){
							jsonObject.put("tripExceptionReportRoot", jsonArray);
						}else{
							jsonObject.put("tripExceptionReportRoot", "");
						}
						ReportHelper reportHelper = (ReportHelper) List.get(1);
						session.setAttribute(jspName, reportHelper);
						session.setAttribute("startDate", sdf.format(sdfDB.parse(startDate.replace("T", " "))));
						session.setAttribute("endDate", sdf.format(sdfDB.parse(endDate.replace("T", " "))));
						session.setAttribute("custName", customerName);
						response.getWriter().print(jsonObject.toString());
					}
				}catch(Exception e){
					e.printStackTrace();
				}
			}
		}catch(Exception e){
			e.printStackTrace();
		}
		return null;
	}
	
}
