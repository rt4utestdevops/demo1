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
import t4u.functions.AlertFunctions;
import t4u.functions.CommonFunctions;

public class AlertAction extends Action {
	public ActionForward execute(ActionMapping mapping, ActionForm form,HttpServletRequest request, HttpServletResponse response) throws Exception {
		try {
			HttpSession session = request.getSession();
			CommonFunctions cf=new CommonFunctions();
			String serverName=request.getServerName();
			String sessionId = request.getSession().getId();
			LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
			int systemId = loginInfo.getSystemId();
			int customerId = loginInfo.getCustomerId();
			int userId = loginInfo.getUserId();
			int offmin = loginInfo.getOffsetMinutes();
			
			
			AlertFunctions alertFunct = new AlertFunctions();
			JSONObject jsonObject = null;			
			JSONArray jsonArray = null;
			String param = "";
			if (request.getParameter("param") != null) {
				param = request.getParameter("param").toString();
			}
			if(param.equals("getAlertCount"))
			{
				try {
					String alertList = request.getParameter("alertList");
					jsonArray = new JSONArray();
					jsonObject = new JSONObject();
					jsonArray = alertFunct.getAlertCountList(alertList,systemId, customerId, userId, offmin);
					if (jsonArray.length() > 0) {
						jsonObject.put("AlertCountRoot", jsonArray);
					} else {
						jsonObject.put("AlertCountRoot", "");
					}
					response.getWriter().print(jsonObject.toString());
					
					cf.insertDataIntoAuditLogReport(sessionId, null, "Alerts", "View", userId, serverName, systemId, customerId, "Visited This Page");
				} catch (Exception e) {
					e.printStackTrace();
				}

			}

			else if (param.equals("getAlertDetails")) {
				try {
					String alertId = request.getParameter("alertId");
					jsonArray = new JSONArray();
					jsonObject = new JSONObject();
					jsonArray = alertFunct.getAlertDetails(offmin, alertId,systemId, customerId, userId);
					if (jsonArray.length() > 0) {
						jsonObject.put("AlertDetailsRoot", jsonArray);
					} else {
						jsonObject.put("AlertDetailsRoot", "");
					}
					response.getWriter().print(jsonObject.toString());
				}
				catch (Exception e) {
					e.printStackTrace();
				}
			}
			
			else if (param.equals("saveAlertRemarks")) {
				try{
					String alertslno= request.getParameter("alertslno");					
					String remark =request.getParameter("remark");
					String regno =request.getParameter("regno");
					String typeofalert =request.getParameter("typeofalert");
					String GMT=request.getParameter("GMT");
					String message="";
					int result=alertFunct.saveAlertRemarks(alertslno ,remark, regno,GMT,typeofalert,offmin,customerId,systemId);
					if(result>0)
					{
						message="Remark Saved";
					}
					else
					{
						message="Error in Saving";
					}
					response.getWriter().print(message);	
				}catch(Exception e){
					System.out.println("Error in Asset Group Action:-deleteAssetGroupDetails "+e.toString());
				}			
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}
}