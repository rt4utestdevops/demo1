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

public class VehicleMaintenanceAction extends Action{
	public ActionForward execute(ActionMapping map,ActionForm form,HttpServletRequest req,HttpServletResponse resp){
		try{
			HttpSession session = req.getSession();
			CommonFunctions cf=new CommonFunctions();
			String serverName=req.getServerName();
		    String sessionId = req.getSession().getId();
			LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
			int systemId = 0;
			int clientId = 0;
			int offset = 0;
			int userId = 0;
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
			GeneralVerticalFunctions gf = new GeneralVerticalFunctions();
			
			if(param.equals("saveVehicleMaintenanceDetails")){
				String vehicleNumber = req.getParameter("vehicleNumber");
				String startDate = req.getParameter("startDate");
				String remarks = req.getParameter("remarks");
				
				String message=gf.saveVehicleMaintenanceDetails(vehicleNumber,startDate,remarks,systemId,userId,clientId,offset );
				resp.getWriter().print(message);
				
			}else if(param.equals("getVehiclesWhichAreNotOnTrip")){
				try {
					obj = new JSONObject();
					jArr = new JSONArray();
					String customerId=req.getParameter("CustID");
					if(customerId != null && !customerId.equals("")){
						jArr = gf.getVehicleshichAreNotOnTrip(Integer.parseInt(customerId),systemId);
						if(jArr.length()>0){
							obj.put("vehicleListRoot",jArr);
						}else{
							obj.put("vehicleListRoot","");
						}
					}else{
						obj.put("vehicleListRoot","");
					}
						
					resp.getWriter().print(obj.toString());	
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
			
			else if(param.equals("getVehicleMaintenanceDetails")){
				String customerId = req.getParameter("custId");
				try{
					obj = new JSONObject();
						jArr = gf.getVehicleMaintenanceDetails(systemId,Integer.parseInt(customerId),offset);
						if(jArr.length() > 0){
							obj.put("vehicleMaintenanceRoot", jArr);
						}else{
							obj.put("vehicleMaintenanceRoot", "");
						}
					resp.getWriter().print(obj.toString());
					
			        cf.insertDataIntoAuditLogReport(sessionId, null, "Vehicle Maintenance", "View", userId, serverName, systemId, clientId,
						"Visited This Page");
				}catch(Exception e){
					e.printStackTrace();
				}
			}
			else if(param.equals("endVehicleMaintenance")){
				String id = req.getParameter("id");
				String vehicleNumber = req.getParameter("vehicleNumber");
				String endDate = req.getParameter("endDate");
				
				String message=gf.endVehicleMaintenanceDetails(vehicleNumber,id,systemId,userId,clientId,endDate,offset );
				resp.getWriter().print(message);
				
			}
		}catch(Exception e){
			e.printStackTrace();
		}
		return null;
	}		
}