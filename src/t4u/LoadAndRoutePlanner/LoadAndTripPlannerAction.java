package t4u.LoadAndRoutePlanner;

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
import t4u.functions.LoadAndTripPlannerFunctions;

public class LoadAndTripPlannerAction extends Action{
	public ActionForward execute(ActionMapping map,ActionForm form,HttpServletRequest req,HttpServletResponse resp){
		try{
			HttpSession session = req.getSession();
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
			LoadAndTripPlannerFunctions func = new LoadAndTripPlannerFunctions();
			
			if(param.equals("getTripDetails")){
				String uniqueId =req.getParameter("uniqueId");
				try{
					obj = new JSONObject();
						jArr = func.getTripDetails(systemId,clientId,offset,userId,uniqueId);
						if(jArr.length() > 0){
							obj.put("tripDetailsRoot", jArr);
						}else{
							obj.put("tripDetailsRoot", "");
						}
					resp.getWriter().print(obj.toString());
				}catch(Exception e){
					e.printStackTrace();
				}
			}else if(param.equals("getRouteDetails")){
				String uniqueId = req.getParameter("uniqueId");
				String tripId = req.getParameter("tripId");
				try{
					obj = new JSONObject();
						jArr = func.getRouteDetails(systemId,clientId,uniqueId,tripId);
						if(jArr.length() > 0){
							obj.put("routeDetailsRoot", jArr);
						}else{
							obj.put("routeDetailsRoot", "");
						}
					resp.getWriter().print(obj.toString());
				}catch(Exception e){
					e.printStackTrace();
				}
			}else if(param.equals("createTrip")){
				String vehicleNo = req.getParameter("vehicleNo");
				String uniqueId = req.getParameter("uniqueId");
				String tripId = req.getParameter("tripId");
				String msg = "";
				try{
					if(vehicleNo != null && !vehicleNo.equals("") && uniqueId != null && !uniqueId.equals("") && tripId != null &&
							!tripId.equals("")){
						msg = func.createTrip(systemId,clientId,userId,vehicleNo,uniqueId,tripId,offset);
					}
					resp.getWriter().println(msg.toString());
				}catch(Exception e){
					e.printStackTrace();
				}
			}
			else if(param.equals("readExcel")){
				
				System.out.println("Done!");
				
				String ss=req.getParameter("dataFile");
				
				System.out.println(ss);
				
				//string fileName=request.getParamter("");
				try{
					obj = new JSONObject();
					
				}
				catch(Exception e)
				{
					e.printStackTrace();
				}
			}
			else if (param.equals("getOrderValues")){
				try {
					obj = new JSONObject();
					jArr = func.readExcelData(systemId,clientId,userId);
					if(jArr.length() > 0){
						obj.put("ExcelValueRoot", jArr);
					}else{
						obj.put("ExcelValueRoot", "");
					}
				resp.getWriter().print(obj.toString());
					
				} catch (Exception e) {
					e.printStackTrace();
				}
				
			}else if(param.equals("getOrderDetails")){
				String uniqueId = req.getParameter("uniqueId");
				String tripId = req.getParameter("tripId");
				try {
					obj = new JSONObject();
					jArr = func.getOrderDetails(systemId,clientId,uniqueId,tripId,offset);
					if(jArr.length() > 0){
						obj.put("orderDetailsRoot", jArr);
					}else{
						obj.put("orderDetailsRoot", "");
					}
				resp.getWriter().print(obj.toString());
					
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
			else if(param.equals("optimseOrderData")){
				String uniqueId = req.getParameter("uniqueId");
				try {
					String message="";
			     	message = func.optimizedRouteandLoad( uniqueId, userId, systemId, clientId);
				resp.getWriter().print(message);
					
				} catch (Exception e) {
					e.printStackTrace();
				}
}
	
		}catch(Exception e){
			e.printStackTrace();
		}
		return null;
	}
}
