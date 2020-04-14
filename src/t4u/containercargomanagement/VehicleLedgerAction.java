package t4u.containercargomanagement;

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
import t4u.functions.ContainerCargoManagementFunctions;

public class VehicleLedgerAction extends Action {
	public ActionForward execute(ActionMapping mapping, ActionForm form,HttpServletRequest request, HttpServletResponse response) throws Exception {
		HttpSession session = request.getSession();
		LoginInfoBean loginInfo =(LoginInfoBean)session.getAttribute("loginInfoDetails");
		int systemId  = loginInfo.getSystemId();
		int customerId = loginInfo.getCustomerId();
		int userId = loginInfo.getUserId();
		int offset = loginInfo.getOffsetMinutes();
		String language = loginInfo.getLanguage();
		ContainerCargoManagementFunctions ccmf = new ContainerCargoManagementFunctions();
		JSONArray jsonArray = null;
		JSONObject jsonObject=null;
		String param = "";
		if (request.getParameter("param") != null) {
			param = request.getParameter("param").toString();
		}
		if (param.equals("getVehicles")) {
			try {
				jsonObject = new JSONObject();
				jsonArray = ccmf.getVehiclesAll( systemId, String.valueOf(customerId), userId);
				if (jsonArray.length() > 0) {
					jsonObject.put("vehicleStoreRoot", jsonArray);
				} else {
					jsonObject.put("vehicleStoreRoot", "");
				}
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		else if (param.equals("getVehicleLedgerData")) {
			String vehId = request.getParameter("vehId");
			String startDate = request.getParameter("startDate");
			String endDate = request.getParameter("endDate");
			String jspName = request.getParameter("jspName");
			try {
				jsonObject = new JSONObject();
				ArrayList<Object> VehicleLedgerDetails= ccmf.getVehicleLedgerData(customerId, systemId, offset, vehId, startDate, endDate,language);
				jsonArray = (JSONArray) VehicleLedgerDetails.get(0);
				if (jsonArray.length() > 0) {
					jsonObject.put("VehicleLedgerRoot", jsonArray);
					
					ReportHelper reportHelper = (ReportHelper) VehicleLedgerDetails.get(1);
					request.getSession().setAttribute(jspName, reportHelper);
					request.getSession().setAttribute("vehId", vehId);
					request.getSession().setAttribute("sdate",startDate.replace("T", " "));
					request.getSession().setAttribute("edate",endDate.replace("T", " "));
				} else {
					jsonObject.put("VehicleLedgerRoot", "");
				}
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		
		
		return null;
	}
}