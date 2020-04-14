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
import t4u.functions.GeneralVerticalFunctions;

public class SmartHubDashboardAction extends Action {

	public ActionForward execute(ActionMapping map, ActionForm form,
			HttpServletRequest req, HttpServletResponse resp) {
		try {
			HttpSession session = req.getSession();
			LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
			int systemId = 0;
			int clientId = 0;
			int offset = 0;
			int userId = 0;
			String sessionId = req.getSession().getId();
			String serverName = req.getServerName();
			String zone = "";
			if (loginInfo != null) {
				systemId = loginInfo.getSystemId();
				clientId = loginInfo.getCustomerId();
				offset = loginInfo.getOffsetMinutes();
				userId = loginInfo.getUserId();
				zone = loginInfo.getZone();
			}

			String param = "";
			if (req.getParameter("param") != null) {
				param = req.getParameter("param");
			}
			JSONArray jArr = new JSONArray();
			JSONObject obj = null;
			GeneralVerticalFunctions gf = new GeneralVerticalFunctions();
			
			if(param.equals("getInBoundSHTrips")) {
				String hubIds = req.getParameter("hubIds");
				try{
					obj = new JSONObject();
					jArr = gf.getInBoundSHTrips(systemId,clientId,offset,userId,hubIds);
					resp.getWriter().print(jArr.toString());
				}catch(Exception e){
					e.printStackTrace();
				}
			}
			
			if(param.equals("getInBoundDestinationCHTrips")) {
				String hubIds = req.getParameter("hubIds");
				try{
					obj = new JSONObject();
					jArr = gf.getInBoundDestinationCHTrips(systemId,clientId,offset,userId,hubIds,zone);
					resp.getWriter().print(jArr.toString());
				}catch(Exception e){
					e.printStackTrace();
				}
			}
			
			
			if(param.equals("getOutBoundSHTrips")) {
				String hubIds = req.getParameter("hubIds");
				try{
					obj = new JSONObject();
					jArr = gf.getOutBoundSHTrips(systemId,clientId,offset,userId,hubIds);
					resp.getWriter().print(jArr.toString());
				}catch(Exception e){
					e.printStackTrace();
				}
			}
			
			if(param.equals("getOutBoundOriginCHTrips")) {
				String hubIds = req.getParameter("hubIds");
				try{
					obj = new JSONObject();
					jArr = gf.getOutBoundOriginCHTrips(systemId,clientId,offset,userId,hubIds,zone);
					resp.getWriter().print(jArr.toString());
				}catch(Exception e){
					e.printStackTrace();
				}
			}
			
			else if(param.equals("getSmartHubs")) {
				try {
					obj = new JSONObject();
					jArr = gf.getSmarthubDetails(systemId, clientId,zone);
					obj.put("smartHubRoot", jArr);
					resp.getWriter().print(obj.toString());
					CommonFunctions cf=new CommonFunctions();
					cf.insertDataIntoAuditLogReport(sessionId, null, "Smart Hub Dashboard", "View", userId, serverName, systemId, clientId,
					"Visited This Page/Dashboard");
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
