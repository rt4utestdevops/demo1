package t4u.cargomanagement;

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
import t4u.functions.RouteMasterFunction;
public class RouteMasterAction extends Action{
	public ActionForward execute(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) {
		HttpSession session = request.getSession();
		String param = "";
		int systemId = 0;
		int userId = 0;
		int clientId = 0;
		String zone = "";
		String language = "";
		
		LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
		
		systemId = loginInfo.getSystemId();
		userId = loginInfo.getUserId();
		clientId = loginInfo.getCustomerId();
		language = loginInfo.getLanguage(); 
		zone = loginInfo.getZone(); 
		
		RouteMasterFunction  funcn = new RouteMasterFunction();
		
		JSONArray jsonArray = null;
		JSONObject jsonObject = null;
		
		if (request.getParameter("param") != null) {
			param = request.getParameter("param").toString();
		}

		if (param.equalsIgnoreCase("getVehicleType")) {
			
			jsonObject = new JSONObject();
			jsonArray = new JSONArray();
			
			clientId = Integer.parseInt(request.getParameter("CustId"));

			try {
				
				jsonArray = funcn.getVehicleType(systemId, clientId);
				
				if(jsonArray.length()>0){
					jsonObject.put("VehicleTypeRoot",jsonArray);
				}else{
					jsonObject.put("VehicleTypeRoot","");
				}
				response.getWriter().print(jsonObject.toString());	
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		
		if (param.equalsIgnoreCase("getSourceDestinationAndCheckPoints")) {
			
			jsonObject = new JSONObject();
			jsonArray = new JSONArray();
			
			clientId = Integer.parseInt(request.getParameter("CustId"));

			try {
				
				jsonArray = funcn.getSourdeDestinationAndCheckPoints(clientId, systemId, zone);
				
				if(jsonArray.length()>0){
					jsonObject.put("SourceDestinationCheckPointRoot",jsonArray);
				}else{
					jsonObject.put("SourceDestinationCheckPointRoot","");
				}
				response.getWriter().print(jsonObject.toString());	
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		
		if (param.equalsIgnoreCase("saveandModifyRouteMasterDetails")) {
			
			clientId = Integer.parseInt(request.getParameter("CustId"));
			String button = request.getParameter("buttonValue");
			String vehicleType = request.getParameter("VehicleType");
			String routeMode = request.getParameter("RouteMode");
			String routeName = request.getParameter("RouteName");
			String routeNameETA = request.getParameter("RouteETA");
            double routeKMS = Double.parseDouble(request.getParameter("RouteKMS"));
            String source = request.getParameter("Source");
            String destination = request.getParameter("Destination");
            int routeCode = Integer.parseInt(request.getParameter("Id"));
            int ba = Integer.parseInt(request.getParameter("Ba"));
            String type = "MLL SCM";
            String message = "Error";
			try {
				if(button.equals("Add")){
					int inserted = funcn.saveRouteMasterDetails(vehicleType, routeMode, routeName, routeNameETA, routeKMS, source, destination,systemId,clientId,userId,type,ba);
					if(inserted>0){
						for(int i=1;i<=25;i++){
							String checkPoint = request.getParameter("CheckPoint"+i);
							String checkPointETA = request.getParameter("CheckPoint"+i+"ETA");
							if(checkPoint!=null && !checkPoint.equals("0") && checkPoint!=""){
							
								if(checkPointETA!=null && checkPointETA!="" && !checkPointETA.equals("00.00")){
									checkPointETA = checkPointETA.replace(':', '.');
								}else{
									checkPointETA = "00.00";
								}
								funcn.saveCheckPoint(systemId, clientId, inserted, checkPoint,Double.parseDouble(checkPointETA),i);
							}
							 
						}
						message = "Inserted Successfully";
					}
				}else{
					message  = funcn.modifyRouteMasterDetails(vehicleType, routeMode, routeName, routeNameETA, routeKMS, source, destination, systemId, clientId, userId, type, routeCode,ba);
					funcn.deleteCheckPoint(systemId, clientId, routeCode);
						for(int i=1;i<=25;i++){
							String checkPoint = request.getParameter("CheckPoint"+i);
							String checkPointETA = request.getParameter("CheckPoint"+i+"ETA");
							if(checkPoint!=null && !checkPoint.equals("0") && checkPoint!=""){
							
								if(checkPointETA!=null && checkPointETA!="" && !checkPointETA.equals("00.00")){
									checkPointETA = checkPointETA.replace(':', '.');
								}else{
									checkPointETA = "00.00";
								}
								funcn.saveCheckPoint(systemId, clientId, routeCode, checkPoint,Double.parseDouble(checkPointETA),i);
							}
					}
					
				}
				response.getWriter().print(message);
				
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		
		if (param.equalsIgnoreCase("getRouteMasterDetails")) {
			
			jsonObject = new JSONObject();
			jsonArray = new JSONArray();
			
			clientId = Integer.parseInt(request.getParameter("CustId"));
			String type = "MLL SCM";
			
			try {
				jsonArray = funcn.getRouteMasterDetails(systemId, clientId,type,language,zone);
				if(jsonArray.length()>0){
					jsonObject.put("RouteMasterRoot",jsonArray);
				}else{
					jsonObject.put("RouteMasterRoot","");
				}
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		
		return null;
	}
}
