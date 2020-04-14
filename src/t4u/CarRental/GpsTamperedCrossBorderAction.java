
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

public class GpsTamperedCrossBorderAction extends Action{
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
			SimpleDateFormat yyyymmdd = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			
			if(param.equalsIgnoreCase("getGPSCrossBorderReport")){
				String customerId = request.getParameter("customerId");
				String startDate = request.getParameter("startDate");
				String endDate = request.getParameter("endDate");
				String customerName = request.getParameter("custName");
				String jspName = request.getParameter("jspName");
				JSONObject jsonObject = null;			
				JSONArray jsonArray = null;
				try{
					jsonObject = new JSONObject();
					jsonArray = new JSONArray();
					if(customerId != null && !customerId.equals("")){
						ArrayList <Object> List = cfunc.getGPSCrossBorderReport(systemId,Integer.parseInt(customerId),startDate,endDate,offset);
						jsonArray = (JSONArray) List.get(0);
						if(jsonArray.length() > 0){
							jsonObject.put("gpsTamperedCrossRoot", jsonArray);
						}else{
							jsonObject.put("gpsTamperedCrossRoot", "");
						}
						ReportHelper reportHelper = (ReportHelper) List.get(1);
						session.setAttribute(jspName, reportHelper);
						session.setAttribute("startDate", sdf.format(yyyymmdd.parse(startDate.replace("T", " "))));
						session.setAttribute("endDate", sdf.format(yyyymmdd.parse(endDate.replace("T", " "))));
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
