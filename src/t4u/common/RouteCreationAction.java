package t4u.common;

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
import t4u.functions.AdminFunctions;
import t4u.functions.CashVanManagementFunctions;
import t4u.functions.CommonFunctions;
import t4u.functions.CreateLandmarkFunctions;
import t4u.functions.RouteCreationFunctions;

public class RouteCreationAction extends Action {
	public ActionForward execute(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response) {
		HttpSession session = request.getSession();
		String param = "";
		String zone = "";
		int systemId = 0;
		int userId = 0;
		int offset = 0;
		int clientId = 0;
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonObject = new JSONObject();
		ReportHelper reportHelper = null;
		CommonFunctions cf=new CommonFunctions();
		String serverName=request.getServerName();
		String sessionId = request.getSession().getId();
		LoginInfoBean loginInfo = (LoginInfoBean) session
				.getAttribute("loginInfoDetails");
		RouteCreationFunctions routeCreationFun = new RouteCreationFunctions();
		CashVanManagementFunctions cashVanfunc = new CashVanManagementFunctions();
		AdminFunctions adfunc = new AdminFunctions();
		systemId = loginInfo.getSystemId();
		clientId = loginInfo.getCustomerId();
		zone = loginInfo.getZone();
		userId = loginInfo.getUserId();
		offset = loginInfo.getOffsetMinutes();
		String lang = loginInfo.getLanguage();
		String ltspName = loginInfo.getSystemName();
		String userName = loginInfo.getUserName();
		zone = loginInfo.getZone();
		if (request.getParameter("param") != null) {
			param = request.getParameter("param").toString();
		}

		if (param.equals("saveRoute")) {
			try {
				String sourceAlias = "";
				String sourceName = "";
				String destAlias = "";
				String destName = "";
				String routeName = "";
				String routeDesc = "";
				String actualKm = "";
				String expectedKm = "";
				String expectedTime = "";
				String actualTime = "";
				String routeRadius = "";
				String routeValues = "";
				String checkpoint = "";
				String[] checkpointArray = null;
				String[] routeArray;
				String message = "";
				String checkPointDur = "";
				String shubId=request.getParameter("sHubId");
				String dhubId=request.getParameter("dHubId");
				if (request.getParameter("custId") != null) {
					clientId = Integer.parseInt(request.getParameter("custId"));
				}
				if (request.getParameter("sourceAlias") != null) {
					sourceAlias = request.getParameter("sourceAlias");
				}
				if (request.getParameter("sourceName") != null) {
					sourceName = request.getParameter("sourceName");
				}
				if (request.getParameter("destAlias") != null) {
					destAlias = request.getParameter("destAlias");
				}
				if (request.getParameter("destName") != null) {
					destName = request.getParameter("destName");
				}
				if (request.getParameter("routeName") != null) {
					routeName = request.getParameter("routeName");
				}
				if (request.getParameter("routeDesc") != null) {
					routeDesc = request.getParameter("routeDesc");
				}
				if (request.getParameter("actualKm") != null) {
					actualKm = request.getParameter("actualKm");
				}
				if (request.getParameter("expectedKm") != null) {
					expectedKm = request.getParameter("expectedKm");
				}
				if (request.getParameter("expectedTime") != null) {
					expectedTime = request.getParameter("expectedTime");
				}
				if (request.getParameter("actualTime") != null) {
					actualTime = request.getParameter("actualTime");
				}
				if (request.getParameter("routeRadius") != null) {
					routeRadius = request.getParameter("routeRadius");
				}
				if (request.getParameter("routeValues") != null) {
					routeValues = request.getParameter("routeValues");
				}
				if (request.getParameter("checkpoints") != null
						&& !request.getParameter("checkpoints").equals("")
						&& !request.getParameter("checkpoints").equals("[]")) {
					checkpoint = request.getParameter("checkpoints");
					checkpoint = checkpoint.substring(1,
							checkpoint.length() - 1);
					checkpointArray = checkpoint
							.replaceAll("^[^{]*|[^}]*$", "").split(
									"(?<=\\})[^{]*");
				}
				if (request.getParameter("checkpointDur") != null
						&& !request.getParameter("checkpoints").equals("")
						&& !request.getParameter("checkpoints").equals("[]")) {
					checkPointDur = request.getParameter("checkpointDur");
				}
				routeValues = routeValues
						.substring(1, routeValues.length() - 1);
				routeArray = routeValues.replaceAll("^[^{]*|[^}]*$", "").split(
						"(?<=\\})[^{]*");
				if(Integer.parseInt(shubId) >0 && Integer.parseInt(dhubId) >0){
					if(routeCreationFun.checkIfRouteAlreadyExists(checkpointArray,shubId,dhubId)){
						message = "Route already exists";
					}
					else{
						message = routeCreationFun.saveRoute(sourceAlias, sourceName,
								destAlias, destName, routeName, routeDesc, actualKm,
								expectedKm, expectedTime, actualTime,
								Integer.parseInt(routeRadius), systemId, clientId, userId,
								routeArray, checkpointArray, checkPointDur,shubId,dhubId);
					}
				}else{
					message = routeCreationFun.saveRoute(sourceAlias, sourceName,
							destAlias, destName, routeName, routeDesc, actualKm,
							expectedKm, expectedTime, actualTime,
							Integer.parseInt(routeRadius), systemId, clientId, userId,
							routeArray, checkpointArray, checkPointDur,shubId,dhubId);
				}
				response.getWriter().print(message);
			} catch (Exception e) {
				e.printStackTrace();
			}
		} else if (param.equals("getRouteDetails")) {

			jsonObject = new JSONObject();
			jsonArray = new JSONArray();
			ArrayList<Object> list=null;
			clientId = 0;
			String jspName = request.getParameter("jspName");
			String custName = request.getParameter("custname");
			if (request.getParameter("custId") != null
					&& !request.getParameter("custId").equals("")) {
				clientId = Integer.parseInt(request.getParameter("custId"));
			}
			try {
				list = routeCreationFun.getRouteDetails(clientId,
						systemId, zone);
				jsonArray=(JSONArray)list.get(0);
				// System.out.println("JSON : " + jsonArray);
				if (jsonArray.length() > 0) {
					jsonObject.put("routeDetailsRoot", jsonArray);

				} else {
					jsonObject.put("routeDetailsRoot", "");
				}				
				reportHelper = (ReportHelper) list.get(1);				
				request.getSession().setAttribute(jspName,reportHelper);
				request.getSession().setAttribute("custName", custName);
				response.getWriter().print(jsonObject.toString());
				
				cf.insertDataIntoAuditLogReport(sessionId, null, "Alerts Report", "View", userId, serverName, systemId, clientId, "Visited This Page");
			} catch (Exception e) {
				e.printStackTrace();
			}
		} else if (param.equals("getLatLongs")) {

			jsonObject = new JSONObject();
			jsonArray = new JSONArray();
			// clientId = Integer.request.getParameter("CustId");
			String routeId = request.getParameter("RouteId");
			try {
				jsonArray = routeCreationFun.getLatLongs(Integer
						.parseInt(routeId), clientId, systemId, zone);

				if (jsonArray.length() > 0) {
					jsonObject.put("latLongRoot", jsonArray);
				} else {
					jsonObject.put("latLongRoot", "");
				}
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		if (param.equals("getCustomer")) {
			try {
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				String ltsp = "no";
				if (request.getParameter("paramforltsp") != null) {
					ltsp = request.getParameter("paramforltsp").toString();
				}

				jsonArray = routeCreationFun.getCustomer(systemId, ltsp,
						clientId);
				if (jsonArray.length() > 0) {
					jsonObject.put("CustomerRoot", jsonArray);
				} else {
					jsonObject.put("CustomerRoot", "");
				}
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {
				System.out.println("Error in Common Action:-getCustomer "
						+ e.toString());
			}
		}else if (param.equals("getType")) {
			try {
				jsonArray = routeCreationFun.getType(clientId, systemId);
				if(jsonArray.length() > 0){
					jsonObject.put("typeList", jsonArray);
				}else{
					jsonObject.put("typeList", "");
				}
				response.getWriter().print(jsonArray.toString());
			
			} catch (Exception e) {
				e.printStackTrace();
			}
		}else if(param.equalsIgnoreCase("getSourceAndDestination"))
		{
			jsonObject = new JSONObject();
			jsonArray = new JSONArray();
			
			String custId = request.getParameter("CustId");

			try {
				jsonArray = routeCreationFun.getSourceDestination(Integer.parseInt(custId), systemId, zone);
				if(jsonArray.length()>0){
					jsonObject.put("sourceRoot",jsonArray);
				}else{
					jsonObject.put("sourceRoot","");
				}
				response.getWriter().print(jsonObject.toString());	
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		else if(param.equalsIgnoreCase("getSourceAndDestination1"))
		{
			jsonObject = new JSONObject();
			jsonArray = new JSONArray();
			
			String custId = request.getParameter("CustId");

			try {
				jsonArray = routeCreationFun.getSourceDestination(Integer.parseInt(custId), systemId, zone);
				if(jsonArray.length()>0){
					jsonObject.put("sourceRoot1",jsonArray);
				}else{
					jsonObject.put("sourceRoot1","");
				}
				response.getWriter().print(jsonObject.toString());	
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		else if(param.equalsIgnoreCase("getCheckPoints"))
		{
			jsonObject = new JSONObject();
			jsonArray = new JSONArray();
			
			String custId = request.getParameter("CustId");

			try {
				jsonArray = routeCreationFun.getCheckPoints(Integer.parseInt(custId), systemId, zone);
				if(jsonArray.length()>0){
					jsonObject.put("checkPoint",jsonArray);
				}else{
					jsonObject.put("checkPoint","");
				}
				response.getWriter().print(jsonObject.toString());	
			} catch (Exception e) {
				e.printStackTrace();
			}
		}else if(param.equalsIgnoreCase("getRouteNames"))
		{
			jsonObject = new JSONObject();
			jsonArray = new JSONArray();
			
			String custId = request.getParameter("CustId");

			try {
				jsonArray = routeCreationFun.getRouteNames(Integer.parseInt(custId), systemId);
				if(jsonArray.length()>0){
					jsonObject.put("routeNamesRoot",jsonArray);
				}else{
					jsonObject.put("routeNamesRoot","");
				}
				response.getWriter().print(jsonObject.toString());	
			} catch (Exception e) {
				e.printStackTrace();
			}
		}

		return null;
	}

}
