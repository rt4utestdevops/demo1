package t4u.GeneralVertical;

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
import t4u.functions.SensorHealthDashboardFunction;

public class SensorHealthDashboardAction extends Action {
	public ActionForward execute(ActionMapping map,ActionForm form,HttpServletRequest req,HttpServletResponse resp){
		try{
			HttpSession session = req.getSession();
			LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
			int systemId = 0;
			int clientId = 0;
			int offset = 0;
			int userId = 0;
			String sessionId = req.getSession().getId();
			String serverName = req.getServerName();
			if(loginInfo != null){
				systemId = loginInfo.getSystemId();
				clientId = loginInfo.getCustomerId();
				offset = loginInfo.getOffsetMinutes();
				userId = loginInfo.getUserId();
			}
			
			String param = "";
			if(req.getParameter("param") != null){
				param = req.getParameter("param");
			}
			JSONArray jArr = new JSONArray();
			JSONObject obj = null;
			SensorHealthDashboardFunction sf  = new SensorHealthDashboardFunction();
			if(param.equals("getDashboardCounts")){
				try{
					obj = new JSONObject();
						jArr = sf.getDashboardCounts(systemId,clientId,offset);
						if(jArr.length() > 0){
							obj.put("sensorHealthAlertCount", jArr);
						}else{
							obj.put("sensorHealthAlertCount", "");
						}
					resp.getWriter().print(obj.toString());
					
					CommonFunctions cf=new CommonFunctions();
					cf.insertDataIntoAuditLogReport(sessionId, null, "Sensor Health Dashboard", "View", userId, serverName, systemId, clientId,
					"Visited This Page/Dashboard");
				}catch(Exception e){
					e.printStackTrace();
				}
			}else if (param.equals("updateAcknowledgement")) {
				try {
					int uniqueId=Integer.parseInt(req.getParameter("uniqueId"));
					String remarks=req.getParameter("remarks");
					String message="";
					message = sf.updateAcknowledgement(systemId,clientId,remarks,uniqueId,userId);
					resp.getWriter().print(message);
				}
				catch (Exception e) {
					e.printStackTrace();
				}
			}else if(param.equals("getDashboardDetails")){
				String alertId = req.getParameter("alertId");
				String type = req.getParameter("type");
				try{
					obj = new JSONObject();
						jArr = sf.getDashboardDetails(systemId,clientId,alertId,type,offset);
						if(jArr.length() > 0){
							obj.put("dashboardDetails", jArr);
						}else{
							obj.put("dashboardDetails", "");
						}
					resp.getWriter().print(obj.toString());
				}catch(Exception e){
					e.printStackTrace();
				}
			}else if(param.equals("getHistoryDataDetails")){
				String startDate = req.getParameter("startDate");
				String endDate = req.getParameter("endDate");
				try{
					obj = new JSONObject();
						jArr = sf.getHistoryDataDetails(systemId,clientId,startDate,endDate,offset);
						if(jArr.length() > 0){
							obj.put("historyDetails", jArr);
						}else{
							obj.put("historyDetails", "");
						}
					resp.getWriter().print(obj.toString());
					
					
				}catch(Exception e){
					e.printStackTrace();
				}
			}
		} catch(Exception e){
			e.printStackTrace();
		}
		return null;
}
}
