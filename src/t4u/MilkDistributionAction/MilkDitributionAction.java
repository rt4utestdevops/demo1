package t4u.MilkDistributionAction;

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
import t4u.functions.MilkDistributonFunctions;

public class MilkDitributionAction extends Action{
	public ActionForward execute(ActionMapping map,ActionForm form,HttpServletRequest req,HttpServletResponse resp){
		HttpSession session = req.getSession();
		LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
		int systemId = loginInfo.getSystemId();
		int clientId = loginInfo.getCustomerId();
		int userId = loginInfo.getUserId();
		int offset = loginInfo.getOffsetMinutes();
		String zone = loginInfo.getZone();
		String param = "";
		if(req.getParameter("param") != null && !req.getParameter("param").equals("")){
			param = req.getParameter("param");
		}
		JSONArray jArray = new JSONArray();
		JSONObject obj = null;
		MilkDistributonFunctions mdf = new MilkDistributonFunctions();
		ArrayList<Object> list = new ArrayList<Object>();
		ReportHelper reportHelper = new ReportHelper();
		
		if(param.equals("getAddGridStore")){
			String btnValue = req.getParameter("btnValue");
			String routeId = req.getParameter("routeId");
			try{
				obj = new JSONObject();
				jArray = mdf.getDistributionPoints(systemId,clientId,btnValue,routeId);
				if(jArray.length() > 0){
					obj.put("addGridStoreRoot", jArray);
				}else{
					obj.put("addGridStoreRoot", "");
				}
				resp.getWriter().println(obj.toString());
			}catch(Exception e){
				e.printStackTrace();
			}
		}else if(param.equals("getSourceLocationName")){
			int type = 3;
			try{
				obj = new JSONObject();
				jArray = mdf.getSourceLocationNames(systemId,clientId,type,zone);
				if(jArray.length() > 0){
					obj.put("sourceComboRoot", jArray);
				}else{
					obj.put("sourceComboRoot", "");
				}
				resp.getWriter().println(obj.toString());
			}catch(Exception e){
				e.printStackTrace();
			}
		}else if(param.equals("getDistributionPointNames")){
			int type = 24;
			try{
				obj = new JSONObject();
				jArray = mdf.getSourceLocationNames(systemId,clientId,type,zone);
				if(jArray.length() > 0){
					obj.put("distributionPointRoot", jArray);
				}else{
					obj.put("distributionPointRoot", "");
				}
				resp.getWriter().println(obj.toString());
			}catch(Exception e){
				e.printStackTrace();
			}
		}else if(param.equals("saveRouteDetails")){
			String json = req.getParameter("json");
			String routeName = req.getParameter("routeName");
			String sourceHub = req.getParameter("sourceHub");
			String sourceDep = req.getParameter("sourceDep");
			String sourceBffer = req.getParameter("sourceBuffer");
			String btnValue = req.getParameter("btnValue");
			String routeId = req.getParameter("routeId");
			String message = "";
			try{
				message = mdf.insertOrModifyRouteDetails(systemId,clientId,userId,json,routeName,sourceHub,sourceDep,sourceBffer,btnValue,Integer.parseInt(routeId));
				resp.getWriter().println(message.toString());
			}catch(Exception e){
				e.printStackTrace();
			}
		}else if(param.equals("getActiveRoutes")){
			try{
				obj = new JSONObject();
				jArray = mdf.getActiveRotes(systemId,clientId,"report");
				if(jArray.length() > 0){
					obj.put("routeStoreRoot", jArray);
				}else{
					obj.put("routeStoreRoot", "");
				}
				resp.getWriter().println(obj.toString());
			}catch(Exception e){
				e.printStackTrace();
			}
		}else if(param.equals("getVehicleNos")){
			try{
				obj = new JSONObject();
				jArray = mdf.getActiveRoutes(systemId,clientId,userId);
				if(jArray.length() > 0){
					obj.put("vehicleComboStoreRoot", jArray);
				}else{
					obj.put("vehicleComboStoreRoot", "");
				}
				resp.getWriter().println(obj.toString());
			}catch(Exception e){
				e.printStackTrace();
			}
		}else if(param.equals("saveTripDetails")){
			String message = "";
			String vehicleNo = req.getParameter("vehicleNo");
			String routeIds = req.getParameter("routeName");
			try{
				message = mdf.saveTripDetails(systemId,clientId,vehicleNo,routeIds,userId);
				resp.getWriter().println(message.toString());
			}catch(Exception e){
				e.printStackTrace();
			}
		}else if(param.equals("getTripDetails")){
			String jspName = req.getParameter("jspName");
			try{
				obj = new JSONObject();
				list = mdf.getTripDetails(systemId,clientId);
				if(list.size() > 0){
					jArray = (JSONArray) list.get(0);
					obj.put("tripDetailsRoot", jArray);
					
					reportHelper = (ReportHelper) list.get(1);
					req.getSession().setAttribute(jspName, reportHelper);
				}else{
					obj.put("tripDetailsRoot", "");
				}
				resp.getWriter().println(obj.toString());
			}catch(Exception e){
				e.printStackTrace();
			}
		}else if(param.equals("getRouteMasterDetails")){
			String jspName = req.getParameter("jspName");
			try{
				obj = new JSONObject();
				list = mdf.getRouteMasterDetails(systemId,clientId,zone);
				if(list.size() > 0){
					jArray = (JSONArray) list.get(0);
					obj.put("routeMasterDetailsRoot", jArray);
					
					reportHelper = (ReportHelper) list.get(1);
					req.getSession().setAttribute(jspName, reportHelper);
				}else{
					obj.put("routeMasterDetailsRoot", "");
				}
				resp.getWriter().println(obj.toString());
			}catch(Exception e){
				e.printStackTrace();
			}
		}else if(param.equals("getDistributionReportDetails")){
			String fromDate = req.getParameter("fromDate");
			String toDate = req.getParameter("toDate");
			String vehicleNo = req.getParameter("vehicleNo");
			String routeId = req.getParameter("routeName");
			String jspName = req.getParameter("jspName");
			try{
				obj = new JSONObject();
				list = mdf.getDistributionReportDetails(systemId,clientId,fromDate,toDate,vehicleNo,routeId,offset,zone);
				if(list.size() > 0){
					jArray = (JSONArray) list.get(0);
					obj.put("milkDistributionReportRoot", jArray);
					reportHelper = (ReportHelper) list.get(1);
					req.getSession().setAttribute(jspName, reportHelper);
					req.getSession().setAttribute("startDate", fromDate.replace("T", ""));
					req.getSession().setAttribute("endDate", toDate.replace("T", ""));
					req.getSession().setAttribute("vehicleNo", vehicleNo);
					req.getSession().setAttribute("routeName", routeId);
				}else{
					obj.put("milkDistributionReportRoot", "");
				}
				resp.getWriter().println(obj.toString());
			}catch(Exception e){
				e.printStackTrace();
			}
		}else if(param.equals("getDistributionPointDetails")){
			String tripId = req.getParameter("tripId");
			String jspName = req.getParameter("jspName");
			String vehicleNo = req.getParameter("vehicleNo");
			String date = req.getParameter("date");
			String source = req.getParameter("source");
			String routeName = req.getParameter("routeName");
			String schldDepTime = req.getParameter("schldDepTime");
			String permittedBuffer = req.getParameter("permittedBuffer");
			String actualDepTime = req.getParameter("actualDepTime");
			try{
				obj = new JSONObject();
				list = mdf.getDistributionPointDetails(systemId,clientId,tripId,zone,offset);
				if(list.size() > 0){
					jArray = (JSONArray) list.get(0);
					obj.put("viewGridStoreRoot", jArray);
					reportHelper = (ReportHelper) list.get(1);
					req.getSession().setAttribute(jspName,reportHelper);
					req.getSession().setAttribute("vehicleNo", vehicleNo);
					req.getSession().setAttribute("date", date);
					req.getSession().setAttribute("source", source);
					req.getSession().setAttribute("routeName", routeName);
					req.getSession().setAttribute("schldDepTime", schldDepTime);
					req.getSession().setAttribute("permittedBuffer", permittedBuffer);
					req.getSession().setAttribute("actualDepTime", actualDepTime);
				}else{
					obj.put("viewGridStoreRoot", "");
				}
				resp.getWriter().println(obj.toString());
			}catch(Exception e){
				e.printStackTrace();
			}
		}else if(param.equals("getActiveRoutesForTrip")){
			try{
				obj = new JSONObject();
				jArray = mdf.getActiveRotes(systemId,clientId,"trip");
				if(jArray.length() > 0){
					obj.put("routeStoreRoot", jArray);
				}else{
					obj.put("routeStoreRoot", "");
				}
				resp.getWriter().println(obj.toString());
			}catch(Exception e){
				e.printStackTrace();
			}
		}else if(param.equals("changeStatus")){
			String UID = req.getParameter("UID");
			String status = req.getParameter("status");
			String message = "";
			try{
				message = mdf.changeStatusOfTrip(UID,status);
				resp.getWriter().println(message.toString());
			}catch(Exception e){
				e.printStackTrace();
			}
		}
		else if(param.equals("changeRouteStatus")){
			String UID = req.getParameter("UID");
			String status = req.getParameter("status");
			String message = "";
			try{
				message = mdf.changeStatusOfRoute(UID,status);
				resp.getWriter().println(message.toString());
			}catch(Exception e){
				e.printStackTrace();
			}
		}
		return null;
	}
}
