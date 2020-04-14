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
import t4u.functions.CreateLandmarkFunctions;

public class EditLandmarkAction extends Action {
	public ActionForward execute(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response) {
		HttpSession session = request.getSession();
		String param = "";
		String zone = "";
		int systemId = 0;
		int userId = 0;
		int offset = 0;
		int clientId = 0;
		String serverName=request.getServerName();
		String sessionId = request.getSession().getId();
		LoginInfoBean loginInfo = (LoginInfoBean) session
				.getAttribute("loginInfoDetails");
		CreateLandmarkFunctions createLandmarkFunctions = new CreateLandmarkFunctions();
		AdminFunctions adfunc = new AdminFunctions();
		systemId = loginInfo.getSystemId();
		zone = loginInfo.getZone();
		userId = loginInfo.getUserId();
		offset = loginInfo.getOffsetMinutes();
		String lang = loginInfo.getLanguage();
		String ltspName = loginInfo.getSystemName();
		String userName = loginInfo.getUserName();
		JSONArray jsonArray = null;
		JSONObject jsonObject = new JSONObject();
		if (request.getParameter("param") != null) {
			param = request.getParameter("param").toString();
		}

		if (param.equals("getGridData")) {
			String clientIdFromJsp = request.getParameter("clientId");
			if (clientIdFromJsp != null && !clientIdFromJsp.equals("")) {
				clientId = Integer.parseInt(clientIdFromJsp);
			}
			try {
				 String jspName = request.getParameter("jspName");
				 String CustName = request.getParameter("custName");
				 ArrayList <Object> finlist =null;
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				if (clientId != 0) {
					//ArrayList finlist = (ArrayList) createLandmarkFunctions.getLocationDetailsforGrid(systemId, clientId);
					 finlist = (ArrayList) createLandmarkFunctions.getLocationDetailsforGrid(systemId, clientId);
					jsonArray = (JSONArray) finlist.get(0);
					jsonObject.put("NewGridRoot", jsonArray);
				} else {
					jsonObject.put("NewGridRoot", "");
				}
				   ReportHelper reportHelper = (ReportHelper) finlist.get(1);
	                request.getSession().setAttribute(jspName, reportHelper);
	                request.getSession().setAttribute("custId", CustName);
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		} 
 else if (param.equals("deleteRecord")) {
			String globalClientId = request.getParameter("custId");
			String landmarkName = request.getParameter("landmarkName");
			String message = "";
			if (globalClientId != null) {
				clientId = Integer.parseInt(globalClientId);
			}
			String pageName=request.getParameter("pageName");
			try {
				if (!globalClientId.equals("") || globalClientId.equals(null)) {
					String systemid = Integer.toString(systemId);
					message = createLandmarkFunctions.deleteLandMarkDetails(
							systemid, clientId, landmarkName, userId,pageName,sessionId,serverName);
					if (message.equals("Location Deleted Successfully")) {
						message = "LandMark Details Deleted " + "SuccessFully.";
					} else {
						message = "Error When Deleting "
								+ "LandMark Details.And Error is " + message
								+ "";
					}
					response.getWriter().print(message);
				}
			} catch (Exception e) {
				e.printStackTrace();
			} // end of catch
		}
		return null;
	}

}
