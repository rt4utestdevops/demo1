package t4u.GeneralVertical;

import java.util.List;

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

import com.google.gson.Gson;

public class LegCreationAction extends Action{
	@SuppressWarnings("unchecked")
	public ActionForward execute(ActionMapping map,ActionForm form,HttpServletRequest req,HttpServletResponse resp){
		try{
			HttpSession session = req.getSession();
			String serverName=req.getServerName();
			String sessionId = req.getSession().getId();
			CommonFunctions cf=new CommonFunctions();
			LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
			int systemId = 0;
			int clientId = 0;
			int offset = 0;
			int userId = 0;
			int isLtsp = 0;
			@SuppressWarnings("unused")
			int nonCommHrs = 0;
			@SuppressWarnings("unused")
			String lang = "";
			String zone="";
			if(loginInfo != null){
				systemId = loginInfo.getSystemId();
				clientId = loginInfo.getCustomerId();
				offset = loginInfo.getOffsetMinutes();
				userId = loginInfo.getUserId();
				isLtsp = loginInfo.getIsLtsp();
				nonCommHrs = loginInfo.getNonCommHrs();
				lang = loginInfo.getLanguage();
				zone=loginInfo.getZone();
			}
			
			String param = "";
			if(req.getParameter("param") != null){
				param = req.getParameter("param");
			}
			JSONArray jArr = new JSONArray();
			JSONObject obj = null;
			GeneralVerticalFunctions gf = new GeneralVerticalFunctions();
			
			if(param.equals("saveLegDetails")){
				String tripCustId = req.getParameter("tripCustId");
				String legName = req.getParameter("legName");
				String source = req.getParameter("source");
				String destination = req.getParameter("destination");
				String distance = req.getParameter("distance");
				String avgSpeed = req.getParameter("avgSpeed");
				String TAT = req.getParameter("TAT");
				String sLat = req.getParameter("sLat");
				String sLon = req.getParameter("sLon");
				String dLat = req.getParameter("dLat");
				String dLon = req.getParameter("dLon");
				String checkPointArray = req.getParameter("checkPointArray");
				String jsonArray = req.getParameter("jsonArray");
				String dragPointArray  = req.getParameter("dragPointArray");
				String sourceRad = req.getParameter("sourceRad");
				String destinationRad = req.getParameter("destinationRad");
				String sourceDet = req.getParameter("sourceDet");
				String destinationDet = req.getParameter("destinationDet");
	            String durationArr = req.getParameter("durationArr");
	            String distanceArray = req.getParameter("distanceArr");
				int legModId  = 0;
				String statusA= req.getParameter("statusA");
				String PageName= "Leg Creation";
				
				if(req.getParameter("legModId")!=null && !req.getParameter("legModId").equals("") ){
					legModId  = Integer.parseInt(req.getParameter("legModId"));
				}
				jsonArray = jsonArray.substring(1,jsonArray.length()-2);
				String[] routejs = jsonArray.replaceAll("^[^{]*|[^}]*$", "").split("(?<=\\})[^{]*");
				
				String[] checkPointjs = null;
				String[] dragPointjs = null;
				String[] duraionPointjs = null;
				String[] distancePointjs = null;
				if(checkPointArray.length()>2){
					checkPointArray = checkPointArray.substring(1,checkPointArray.length()-2);
					checkPointjs = checkPointArray.replaceAll("^[^{]*|[^}]*$", "").split("(?<=\\})[^{]*");
				}
				if(durationArr.length()>2){
					durationArr = durationArr.substring(1,durationArr.length()-2);
					duraionPointjs = durationArr.replaceAll("^[^{]*|[^}]*$", "").split("(?<=\\})[^{]*");
				}
				if(dragPointArray.length()>2){
					dragPointArray = dragPointArray.substring(1,dragPointArray.length()-2);
					dragPointjs = dragPointArray.replaceAll("^[^{]*|[^}]*$", "").split("(?<=\\})[^{]*");
				}
				if(distanceArray.length()>2){
					distanceArray = distanceArray.substring(1,distanceArray.length()-2);
					distancePointjs = distanceArray.replaceAll("^[^{]*|[^}]*$", "").split("(?<=\\})[^{]*");
				}
				String message=gf.saveLegDetails(Integer.parseInt(tripCustId),legName,source,destination,distance,avgSpeed,TAT,checkPointjs,routejs,dragPointjs,systemId,
						clientId,userId,sLat,sLon,dLat,dLon,legModId,statusA,sourceRad,sourceDet,destinationRad,destinationDet,duraionPointjs,sessionId,serverName,PageName,distancePointjs,zone);
				String[] response = message.split("##");
				resp.getWriter().print(response[0]);
				
			}
			else if(param.equals("saveRouteDetails")){
				String tripCustId = req.getParameter("tripCustId");
				String routeName = req.getParameter("routeName");
				String routeKey = req.getParameter("routeKey");
				String distance = req.getParameter("distance");
				String TAT = req.getParameter("TAT");
				String legPointData = req.getParameter("legPointData");
				String statusA= req.getParameter("statusA");
				String routeRadius= req.getParameter("routeRadius");
				String detentionCheckPointsArray = req.getParameter("detentionCheckPointsArray");
				String PageName= "Route Creation";
				
				int routeModId  = 0;
				
				if(req.getParameter("routeModId")!=null && !req.getParameter("routeModId").equals("") ){
					routeModId  = Integer.parseInt(req.getParameter("routeModId"));
				}
				legPointData = legPointData.substring(1,legPointData.length()-2);
				String[] legjs = legPointData.replaceAll("^[^{]*|[^}]*$", "").split("(?<=\\})[^{]*");
				
				String message=gf.saveRouteDetails(Integer.parseInt(tripCustId),routeName,routeKey,distance,TAT,legjs,systemId,
						clientId,userId,routeModId,statusA,routeRadius,sessionId,serverName,PageName,detentionCheckPointsArray,zone);
				String[] routeResponse = message.split("##");
				resp.getWriter().print(routeResponse[0]);
				
			}
			else if(param.equalsIgnoreCase("getSourceAndDestination"))
			{
				obj = new JSONObject();
				jArr = new JSONArray();
				int tripCustId=0;
				if(req.getParameter("tripCustId")!=null && !req.getParameter("tripCustId").equals("")){
					tripCustId=Integer.parseInt(req.getParameter("tripCustId"));
				}
				try {
					if (tripCustId>0) {
						jArr = gf.getSourceDestination(clientId, systemId, zone,tripCustId);
					}
					if(jArr.length()>0){
						obj.put("sourceRoot",jArr);
					}else{
						obj.put("sourceRoot","");
					}
					resp.getWriter().print(obj.toString());	
				} catch (Exception e) {
					e.printStackTrace();
				}
			}else if(param.equalsIgnoreCase("getLegNames"))
			{
				String hubId="0";
				if(req.getParameter("hubId")!=null && !req.getParameter("hubId").equals("")){
					hubId=req.getParameter("hubId");
				}
				String tripCustId=req.getParameter("tripCustId");
				obj = new JSONObject();
				jArr = new JSONArray();
				
				try {
					jArr = gf.getLegNames(clientId, systemId, tripCustId,zone,Integer.parseInt(hubId));
					if(jArr.length()>0){
						obj.put("legRoot",jArr);
					}else{
						obj.put("legRoot","");
					}
					resp.getWriter().print(obj.toString());	
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
			else if (param.equalsIgnoreCase("getSmartHubBuffer")) {
				try {
					int tripCustId=0;
					if(req.getParameter("tripCustId")!=null && !req.getParameter("tripCustId").equals("")){
						tripCustId=Integer.parseInt(req.getParameter("tripCustId"));
					}
					jArr = new JSONArray();
					obj = new JSONObject();
					jArr = gf.getSmartHubBuffer(userId,clientId,systemId,zone,isLtsp,tripCustId);
					if (jArr.length() > 0) {
						obj.put("BufferMapView", jArr);
					} else {
						obj.put("BufferMapView", "");
					}
					resp.getWriter().print(obj.toString());
				} catch (Exception e) {

				}
			}else if (param.equalsIgnoreCase("getSmartHubPolygon")) {
				try {
					int tripCustId=0;
					if(req.getParameter("tripCustId")!=null && !req.getParameter("tripCustId").equals("")){
						tripCustId=Integer.parseInt(req.getParameter("tripCustId"));
					}
					jArr = new JSONArray();
					obj = new JSONObject();
					jArr = gf.getSmartHubPolygon(userId,clientId,systemId,zone,isLtsp,tripCustId);
					if (jArr.length() > 0) {
						obj.put("PolygonMapView", jArr);
					} else {
						obj.put("PolygonMapView", "");
					}
					resp.getWriter().print(obj.toString());
				} catch (Exception e) {

				}
			}
			else if (param.equalsIgnoreCase("getcheckpointBuffer")) {
				try {
					int tripCustId=0;
					if(req.getParameter("tripCustId")!=null && !req.getParameter("tripCustId").equals("")){
						tripCustId=Integer.parseInt(req.getParameter("tripCustId"));
					}
					jArr = new JSONArray();
					obj = new JSONObject();
					jArr = gf.getcheckpointBuffer(userId,clientId,systemId,zone,isLtsp,tripCustId);
					if (jArr.length() > 0) {
						obj.put("BufferMapView1", jArr);
					} else {
						obj.put("BufferMapView1", "");
					}
					resp.getWriter().print(obj.toString());
				} catch (Exception e) {

				}
			}else if (param.equalsIgnoreCase("getcheckpointPolygon")) {
				try {
					int tripCustId=0;
					if(req.getParameter("tripCustId")!=null && !req.getParameter("tripCustId").equals("")){
						tripCustId=Integer.parseInt(req.getParameter("tripCustId"));
					}
					jArr = new JSONArray();
					obj = new JSONObject();
					jArr = gf.getcheckpointPolygon(userId,clientId,systemId,zone,isLtsp,tripCustId);
					if (jArr.length() > 0) {
						obj.put("PolygonMapView1", jArr);
					} else {
						obj.put("PolygonMapView1", "");
					}
					resp.getWriter().print(obj.toString());
				} catch (Exception e) {

				}
			}else if(param.equals("getLegMasterDetails")){
				try {
					String tripCustId=req.getParameter("tripCustId");
					obj = new JSONObject();
					jArr = gf.getLegMasterDetails(systemId, clientId,offset,tripCustId,zone);
					if (jArr.length() > 0) {
						obj.put("LegDataRoot", jArr);
					} else {
						obj.put("LegDataRoot", "");
					}
					resp.getWriter().print(obj.toString());
				} catch (Exception e) {
					e.printStackTrace();
				}
			}else if (param.equals("getLegLatLongs")) {
				String legId=req.getParameter("legId");
				try {
					jArr = gf.getLegLatLongs(Integer.parseInt(legId), systemId,zone);
					obj = new JSONObject();
					if(jArr.length()>0){
						obj.put("latLongRoot",jArr);
					}else{
						obj.put("latLongRoot","");
					}
					resp.getWriter().print(obj.toString());	
				} catch (Exception e) {
					e.printStackTrace();
				}
		  }else if (param.equals("getRouteLatLongs")) {
				String routeId=req.getParameter("legId");
				try {
					jArr = gf.getRouteLatLongs(Integer.parseInt(routeId), systemId,zone);
					obj = new JSONObject();
					if(jArr.length()>0){
						obj.put("latLongRoot",jArr);
					}else{
						obj.put("latLongRoot","");
					}
					resp.getWriter().print(obj.toString());	
				} catch (Exception e) {
					e.printStackTrace();
				}
		  }else if (param.equals("getLegList")) {
			  String routeId="0";
				if(req.getParameter("routeId")!=null && !req.getParameter("routeId").equals("")){
					routeId = req.getParameter("routeId");
				}
				try {
					jArr = gf.getLegList(Integer.parseInt(routeId), systemId);
					obj = new JSONObject();
					if(jArr.length()>0){
						obj.put("legListRoot",jArr);
					}else{
						obj.put("legListRoot","");
					}
					resp.getWriter().print(obj.toString());	
				} catch (Exception e) {
					e.printStackTrace();
				}
		  }else if (param.equals("getLatLongsForCompleteRoute")) {
				String legIds=req.getParameter("legIds");
				String routeId = req.getParameter("routeId");
				if(legIds.contains(",")){
					legIds=legIds.substring(0, legIds.length()-1);
				}
				//System.out.println(legIds);
				try {
					jArr = gf.getLatLongsForCompleteRoute(legIds, systemId, routeId,zone);
					obj = new JSONObject();
					if(jArr.length()>0){
						obj.put("routelatlongRoot",jArr);
					}else{
						obj.put("routelatlongRoot","");
					}
					resp.getWriter().print(obj.toString());	
				} catch (Exception e) {
					e.printStackTrace();
				}
		  }
		  else if (param.equals("getIndvRoute")) {
				String legId=req.getParameter("legId");
				System.out.println("legId== "+legId);
				try {
					jArr = gf.getIndvRoute(legId, systemId,zone);
					obj = new JSONObject();
					if(jArr.length()>0){
						obj.put("routeRoot",jArr);
					}else{
						obj.put("routeRoot","");
					}
					resp.getWriter().print(obj.toString());	
				} catch (Exception e) {
					e.printStackTrace();
				}
		  }
		  else if(param.equals("getRouteMasterDetails")){
				try {
					String tripCustId=req.getParameter("tripCustId");
					obj = new JSONObject();
					jArr = gf.getRouteMasterDetails(systemId, clientId,offset,tripCustId);
					if (jArr.length() > 0) {
						obj.put("routeDataRoot", jArr);
					} else {
						obj.put("routeDataRoot", "");
					}
					resp.getWriter().print(obj.toString());
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		  else if (param.equals("updateStatus")) {
				try {
					int uniqueId  = 0;
					String pageName="Leg Creation";
					if(req.getParameter("uniqueId")!=null && !req.getParameter("uniqueId").equals("") ){
						uniqueId  = Integer.parseInt(req.getParameter("uniqueId"));
					}
					
					String message="";
					String status= "Inactive";
					message = gf.updateStatus(systemId,uniqueId,status,serverName,sessionId,pageName,userId,clientId,"INACTIVATE");
					resp.getWriter().print(message);
				}
				catch (Exception e) {
					e.printStackTrace();
				}
			}
		  else if(param.equalsIgnoreCase("getCheckPoints"))
			{
				obj = new JSONObject();
				jArr = new JSONArray();
				int tripCustId=0;
				if(req.getParameter("tripCustId")!=null && !req.getParameter("tripCustId").equals("")){
					tripCustId=Integer.parseInt(req.getParameter("tripCustId"));
				}
				try {
					jArr = gf.getCheckPoints(clientId, systemId, zone,tripCustId);
					if(jArr.length()>0){
						obj.put("checkPointRoot",jArr);
					}else{
						obj.put("checkPointRoot","");
					}
					resp.getWriter().print(obj.toString());	
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		  else if (param.equals("updateStatusForRoute")) {
				try {
					int uniqueId  = 0;
					String pageName="Route Creation";
					if(req.getParameter("uniqueId")!=null && !req.getParameter("uniqueId").equals("") ){
						uniqueId  = Integer.parseInt(req.getParameter("uniqueId"));
					}
					String message="";
					String status= "Inactive";
					message = gf.updateStatusForRoute(systemId,uniqueId,status,serverName,sessionId,pageName,userId,clientId,"INACTIVATE");
					resp.getWriter().print(message);
				}
				catch (Exception e) {
					e.printStackTrace();
				}
			}
		  else if(param.equalsIgnoreCase("getRouteDetails"))
			{
				obj = new JSONObject();
				jArr = new JSONArray();
				int routeId=0;
				if(req.getParameter("routeId")!=null && !req.getParameter("routeId").equals("")){
					routeId=Integer.parseInt(req.getParameter("routeId"));
				}
				try {
					jArr = gf.getRouteDetails(routeId);
					if(jArr.length()>0){
						obj.put("routeListRoot",jArr);
					}else{
						obj.put("routeListRoot","");
					}
					resp.getWriter().print(obj.toString());	
				} catch (Exception e) {
					e.printStackTrace();
				}
			}else if (param.equals("getLatLongsForRoute")) {
				String routeId=req.getParameter("legIds");
				
				try {
					jArr = gf.getLatLongsForRoute(routeId, systemId);
					obj = new JSONObject();
					if(jArr.length()>0){
						obj.put("routelatlongRoot1",jArr);
					}else{
						obj.put("routelatlongRoot1","");
					}
					resp.getWriter().print(obj.toString());	
				} catch (Exception e) {
					e.printStackTrace();
				}
		  }else if (param.equals("createRouteTemplate")) {
			  try {
			  	String templateName=req.getParameter("templateName");
			    String routeId=req.getParameter("routeId");
			    String routeLegMaterialAssoc=req.getParameter("routeLegMaterialAssoc");
			    int tripCustId = (req.getParameter("tripCustId") != null)?Integer.parseInt(req.getParameter("tripCustId")):0;
			    Gson g = new Gson(); 
				List routelegMaterialAssocList = g.fromJson(routeLegMaterialAssoc, List.class);
				String result = gf.saveRouteTemplate(templateName,Integer.parseInt(routeId),systemId, clientId, userId,tripCustId, routelegMaterialAssocList);
				resp.getWriter().print(result);	
				} catch (Exception e) {
					e.printStackTrace();
				}
		  }else if (param.equals("getAllRouteTemplates")) {
			  	try {
					  	obj = new JSONObject();
						jArr = new JSONArray();
						int tripCustId = (req.getParameter("tripCustId") != null) ? Integer.parseInt(req.getParameter("tripCustId")):0;
						
					    jArr = gf.getAllRouteTemplates(systemId, clientId, tripCustId);
					    if(jArr.length()>0){
							obj.put("routeTemplateRoot",jArr);
						}else{
							obj.put("routeTemplateRoot","");
						}
						resp.getWriter().print(obj);	
						
						cf.insertDataIntoAuditLogReport(sessionId, null, "Trip Solution", "View", userId, serverName, systemId, clientId,
						"Visited This Page");
					} catch (Exception e) {
						e.printStackTrace();
					}
		  }else if (param.equals("getRouteTemplateDetailsById")) {
			  	try {
				  	obj = new JSONObject();
					jArr = new JSONArray();
					String id = req.getParameter("id");
				    jArr = gf.getRouteTemplateDetailsById(Integer.parseInt(id));
				    if(jArr.length()>0){
						obj.put("templateDetails",jArr);
					}else{
						obj.put("templateDetails","");
					}
					resp.getWriter().print(obj);
					
					
				} catch (Exception e) {
					e.printStackTrace();
				}
		  }else if (param.equals("getAllMaterialsByTemplateId")) {
			  	try {
				  	obj = new JSONObject();
					jArr = new JSONArray();
					String id = req.getParameter("id");
					int tripCustId = (req.getParameter("tripCustId") != null) ? Integer.parseInt(req.getParameter("tripCustId")):0;
					
				    jArr = gf.getAllMaterialsByTemplateId(Integer.parseInt(id), systemId, clientId, tripCustId);
				    if(jArr.length()>0){
						obj.put("templateDetails",jArr);
					}else{
						obj.put("templateDetails","");
					}
					resp.getWriter().print(obj);	
				} catch (Exception e) {
					e.printStackTrace();
				}
	      }else if (param.equals("updateRouteTemplate")) {
			  try {
				    String templateId=req.getParameter("templateId");
				    String routeLegMaterialAssoc=req.getParameter("routeLegMaterialAssoc");
				    
				    int tripCustId = (req.getParameter("tripCustId") != null)?Integer.parseInt(req.getParameter("tripCustId")):0;
				    Gson g = new Gson(); 
					List routelegMaterialAssocList = g.fromJson(routeLegMaterialAssoc, List.class);
					String result = gf.updateRouteTemplate(Integer.parseInt(templateId), systemId, clientId, userId, tripCustId, routelegMaterialAssocList);
					resp.getWriter().print(result);	
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