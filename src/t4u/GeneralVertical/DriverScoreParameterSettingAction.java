package t4u.GeneralVertical;

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
import t4u.functions.CommonFunctions;
import t4u.functions.GeneralVerticalFunctions;

public class DriverScoreParameterSettingAction extends Action {
	public ActionForward execute(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		HttpSession session = request.getSession();
		String serverName=request.getServerName();
		String sessionId = request.getSession().getId();
		CommonFunctions cf=new CommonFunctions();
		String param = "";
		int systemId = 0;
		int offset = 0;
		int custId = 0;
		int userId = 0;
		String distUnits = "";
		LoginInfoBean loginInfo = (LoginInfoBean) session
				.getAttribute("loginInfoDetails");
		systemId = loginInfo.getSystemId();
		custId = loginInfo.getCustomerId();
		userId = loginInfo.getUserId();
		offset = loginInfo.getOffsetMinutes();
		distUnits = cf.getUnitOfMeasure(systemId);
		JSONArray jsonArray = null;
		JSONObject jsonObject = new JSONObject();
		GeneralVerticalFunctions gvf = new GeneralVerticalFunctions();

		if (request.getParameter("param") != null) {
			param = request.getParameter("param").toString();
		}
		if (param.equals("getDriverScoreParameterDetails")) {
			String customerId = request.getParameter("custId");
			String modelId = request.getParameter("modelId");
			try {
				jsonObject = new JSONObject();
				if (custId != 0) {
					ArrayList<Object> list1 = gvf
							.getDriverScoreParameterDetails(systemId, Integer
									.parseInt(customerId), offset, distUnits, Integer.parseInt(modelId));
					jsonArray = (JSONArray) list1.get(0);
					jsonObject.put("DriverScoreParameterRoot", jsonArray);
				} else {
					jsonObject.put("DriverScoreParameterRoot", "");
				}
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}

		} else if (param.equals("getVehicleModel")) {
			String customerId = request.getParameter("custId");
			jsonObject = new JSONObject();
			jsonArray = new JSONArray();
			try {
				jsonArray = gvf.getVehicleModelDetails(systemId, Integer
						.parseInt(customerId));
				if (jsonArray.length() > 0) {
					jsonObject.put("vehicleModelDetailsRoot", jsonArray);
				} else {
					jsonObject.put("vehicleModelDetailsRoot", "");
				}
				response.getWriter().print(jsonObject.toString());
				
				cf.insertDataIntoAuditLogReport(sessionId, null, "Driver Parameter Setting", "View", userId, serverName, systemId, custId,
				"Visited This Page");
			} catch (Exception e) {
				e.printStackTrace();
			}
		} else if (param.equals("getParameterNames")) {
			jsonObject = new JSONObject();
			jsonArray = new JSONArray();
			String modelId = "";
			String clientId = "";
			if (request.getParameter("custId") != ""
					|| request.getParameter("custId") != null) {
				clientId = request.getParameter("custId");
			}
			if (request.getParameter("modelId") != ""
					|| request.getParameter("modelId") != null) {
				modelId = request.getParameter("modelId");
			}
			try {
				jsonArray = gvf.getParameterNames(Integer.parseInt(modelId),
						systemId, Integer.parseInt(clientId));
				if (jsonArray.length() > 0) {
					jsonObject.put("ParameterNameDetailsRoot", jsonArray);
				} else {
					jsonObject.put("ParameterNameDetailsRoot", "");
				}
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		} else if (param.equals("saveDriverScoreParameters")) {
			jsonObject = new JSONObject();
			jsonArray = new JSONArray();
			int vehicleModelId = 0;
			String paramName = "";
			float minValue = 0;
			float maxValue = 0;
			String message = "";
			int customerId = 0;

			if (request.getParameter("custId") != ""
					|| request.getParameter("custId") != null) {
				customerId = Integer.parseInt(request.getParameter("custId"));
			}
			if (request.getParameter("modelId") != ""
					|| request.getParameter("modelId") != null) {
				vehicleModelId = Integer.parseInt(request
						.getParameter("modelId"));
			}
			if (request.getParameter("paramName") != ""
					|| request.getParameter("paramName") != null) {
				paramName = request.getParameter("paramName");
			}
			if (request.getParameter("minValue") != ""
					|| request.getParameter("minValue") != null) {
				minValue = Float.parseFloat(request.getParameter("minValue"));
			}
			if (request.getParameter("maxValue") != ""
					|| request.getParameter("maxValue") != null) {
				maxValue = Float.parseFloat(request.getParameter("maxValue"));
			}
			try {
				message = gvf.saveDriverScoreParameters(vehicleModelId,
						paramName, minValue, maxValue, systemId, customerId,
						distUnits);
				response.getWriter().print(message);
			} catch (Exception e) {
				e.printStackTrace();
			}
		} else if (param.equals("modifyDriverScoreParameters")) {
			jsonObject = new JSONObject();
			jsonArray = new JSONArray();
			float minValue = 0;
			float maxValue = 0;
			String message = "";
			int customerId = 0;
			int uid = 0;
			String modifyParamName="";

			if (request.getParameter("custId") != ""
					|| request.getParameter("custId") != null) {
				customerId = Integer.parseInt(request.getParameter("custId"));
			}
			if (request.getParameter("uniqueId") != ""
					|| request.getParameter("uniqueId") != null) {
				uid = Integer.parseInt(request.getParameter("uniqueId"));
			}
			 if (request.getParameter("modifyParamName") != ""
			 || request.getParameter("modifyParamName") != null) {
				 modifyParamName = request.getParameter("modifyParamName");
			 }
			if (request.getParameter("modifyMinValue") != ""
					|| request.getParameter("modifyMinValue") != null) {
				minValue = Float.parseFloat(request
						.getParameter("modifyMinValue"));
			}
			if (request.getParameter("modifyMaxValue") != ""
					|| request.getParameter("modifyMaxValue") != null) {
				maxValue = Float.parseFloat(request
						.getParameter("modifyMaxValue"));
			}
			try {
				message = gvf.modifyDriverScoreParameters(uid, minValue,
						maxValue, systemId, customerId,modifyParamName,distUnits);
				response.getWriter().print(message);
			} catch (Exception e) {
				e.printStackTrace();
			}
		}

		return null;
	}
}
