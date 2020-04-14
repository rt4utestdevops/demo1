package t4u.common;

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
import t4u.functions.VehicleHealthParameterSettingFunctions;

public class VehicleHealthParameterSettingAction extends Action {
	public ActionForward execute(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response) {
		HttpSession session = request.getSession();
		String param = "";
		int systemId = 0;
		int userId = 0;
		int clientId = 0;
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonObject = new JSONObject();
		LoginInfoBean loginInfo = (LoginInfoBean) session
				.getAttribute("loginInfoDetails");
		VehicleHealthParameterSettingFunctions vf = new VehicleHealthParameterSettingFunctions();
		systemId = loginInfo.getSystemId();
		clientId = loginInfo.getCustomerId();
		userId = loginInfo.getUserId();
		if (request.getParameter("param") != null) {
			param = request.getParameter("param").toString();
		}

		if (param.equals("getVehicleModel")) {
			jsonObject = new JSONObject();
			jsonArray = new JSONArray();
			try {
				jsonArray = vf.getVehicleModel(systemId, clientId);
				if (jsonArray.length() > 0) {
					jsonObject.put("vehicleModelDetailsRoot", jsonArray);
				} else {
					jsonObject.put("vehicleModelDetailsRoot", "");
				}
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		} else if (param.equals("getVehicleParameterDetails")) {
			jsonObject = new JSONObject();
			jsonArray = new JSONArray();
			String modelId = "";
			if (request.getParameter("ModelIdSelected") != ""
					|| request.getParameter("ModelIdSelected") != null) {
				modelId = request.getParameter("ModelIdSelected");
			}
			try {
				jsonArray = vf.getVehicleParameterDetails(Integer
						.parseInt(modelId), systemId, clientId);
				if (jsonArray.length() > 0) {
					jsonObject.put("vehicleParameterDetailsRoot", jsonArray);

				} else {
					jsonObject.put("vehicleParameterDetailsRoot", "");
				}
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		} else if (param.equals("getParameterNames")) {
			jsonObject = new JSONObject();
			jsonArray = new JSONArray();
			String modelId = "";

			if (request.getParameter("modelId") != ""
					|| request.getParameter("modelId") != null) {
				modelId = request.getParameter("modelId");
			}
			try {
				jsonArray = vf.getParameterNames(Integer.parseInt(modelId),
						systemId, clientId);
				if (jsonArray.length() > 0) {
					jsonObject.put("ParameterNameDetailsRoot", jsonArray);

				} else {
					jsonObject.put("ParameterNameDetailsRoot", "");
				}
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		} else if (param.equals("saveVehicleHealthParameters")) {
			jsonObject = new JSONObject();
			jsonArray = new JSONArray();
			int vehicleModelId = 0;
			int paramId = 0;
			float minValueRed = 0;
			float maxValueRed = 0;
			float minValueYellow = 0;
			float maxValueYellow = 0;
			float minValueGreen = 0;
			float maxValueGreen = 0;
			String message = "";

			if (request.getParameter("vehicleModelId") != ""
					|| request.getParameter("vehicleModelId") != null) {
				vehicleModelId = Integer.parseInt(request
						.getParameter("vehicleModelId"));
			}
			if (request.getParameter("paramId") != ""
					|| request.getParameter("paramId") != null) {
				paramId = Integer.parseInt(request.getParameter("paramId"));
			}
			if (request.getParameter("minValueRed") != ""
					|| request.getParameter("minValueRed") != null) {
				minValueRed = Float.parseFloat(request
						.getParameter("minValueRed"));
			}
			if (request.getParameter("maxValueRed") != ""
					|| request.getParameter("maxValueRed") != null) {
				maxValueRed = Float.parseFloat(request
						.getParameter("maxValueRed"));
			}
			if (request.getParameter("minValueYellow") != ""
					|| request.getParameter("minValueYellow") != null) {
				minValueYellow = Float.parseFloat(request
						.getParameter("minValueYellow"));
			}
			if (request.getParameter("maxValueYellow") != ""
					|| request.getParameter("maxValueYellow") != null) {
				maxValueYellow = Float.parseFloat(request
						.getParameter("maxValueYellow"));
			}
			if (request.getParameter("minValueGreen") != ""
					|| request.getParameter("minValueGreen") != null) {
				minValueGreen = Float.parseFloat(request
						.getParameter("minValueGreen"));
			}
			if (request.getParameter("maxValueGreen") != ""
					|| request.getParameter("maxValueGreen") != null) {
				maxValueGreen = Float.parseFloat(request
						.getParameter("maxValueGreen"));
			}
			try {
				message = vf.saveVehicleHealthParameters(vehicleModelId,
						paramId, minValueRed, maxValueRed, minValueYellow,
						maxValueYellow, minValueGreen, maxValueGreen, systemId,
						clientId, userId);
				response.getWriter().print(message);
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		// else if (param.equals("getAllParameterNames")) {
		// jsonObject = new JSONObject();
		// jsonArray = new JSONArray();
		// String modelId = "";
		// try {
		// jsonArray = vf.getAllParameterNames(systemId, clientId);
		// System.out.println("JSON : " + jsonArray);
		// if (jsonArray.length() > 0) {
		// jsonObject.put("AllParameterNameDetailsRoot", jsonArray);
		//
		// } else {
		// jsonObject.put("AllParameterNameDetailsRoot", "");
		// }
		// response.getWriter().print(jsonObject.toString());
		// } catch (Exception e) {
		// e.printStackTrace();
		// }
		// }
		else if (param.equals("updateVehicleHealthParameters")) {
			int vehicleModelId = 0;
			int paramId = 0;
			float minValueRed = 0;
			float maxValueRed = 0;
			float minValueYellow = 0;
			float maxValueYellow = 0;
			float minValueGreen = 0;
			float maxValueGreen = 0;
			String message = "";
			String historyData = "";

			if (request.getParameter("vehicleModelId") != ""
					|| request.getParameter("vehicleModelId") != null) {
				vehicleModelId = Integer.parseInt(request
						.getParameter("vehicleModelId"));
			}
			if (request.getParameter("paramId") != ""
					|| request.getParameter("paramId") != null) {
				paramId = Integer.parseInt(request.getParameter("paramId"));
			}
			if (request.getParameter("minValueRed") != ""
					|| request.getParameter("minValueRed") != null) {
				minValueRed = Float.parseFloat(request
						.getParameter("minValueRed"));
			}
			if (request.getParameter("maxValueRed") != ""
					|| request.getParameter("maxValueRed") != null) {
				maxValueRed = Float.parseFloat(request
						.getParameter("maxValueRed"));
			}
			if (request.getParameter("minValueYellow") != ""
					|| request.getParameter("minValueYellow") != null) {
				minValueYellow = Float.parseFloat(request
						.getParameter("minValueYellow"));
			}
			if (request.getParameter("maxValueYellow") != ""
					|| request.getParameter("maxValueYellow") != null) {
				maxValueYellow = Float.parseFloat(request
						.getParameter("maxValueYellow"));
			}
			if (request.getParameter("minValueGreen") != ""
					|| request.getParameter("minValueGreen") != null) {
				minValueGreen = Float.parseFloat(request
						.getParameter("minValueGreen"));
			}
			if (request.getParameter("maxValueGreen") != ""
					|| request.getParameter("maxValueGreen") != null) {
				maxValueGreen = Float.parseFloat(request
						.getParameter("maxValueGreen"));
			}
			if (request.getParameter("historyDataJson") != ""
					|| request.getParameter("historyDataJson") != null) {
				historyData = request.getParameter("historyDataJson");
			}
			try {
				message = vf.updateModifiedVehicleHealthParameters(
						vehicleModelId, paramId, minValueRed, maxValueRed,
						minValueYellow, maxValueYellow, minValueGreen,
						maxValueGreen, historyData, systemId, clientId, userId);
				response.getWriter().print(message);
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		return null;
	}

}
