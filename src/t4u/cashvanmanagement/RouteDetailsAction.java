package t4u.cashvanmanagement;


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
import t4u.functions.AdminFunctions;
import t4u.functions.CashVanManagementFunctions;

public class RouteDetailsAction extends Action
{
public ActionForward execute(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) {
   	 
    	
    	HttpSession session = request.getSession();
        String param = "";
        String zone = "";
        int systemId = 0;
        int userId = 0;
        int offset = 0;
        LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
        AdminFunctions adfunc = new AdminFunctions();
        systemId = loginInfo.getSystemId();
        zone = loginInfo.getZone();
        userId = loginInfo.getUserId();
        offset = loginInfo.getOffsetMinutes();
        String lang = loginInfo.getLanguage();
        String ltspName = loginInfo.getSystemName();
        String userName = loginInfo.getUserName();
        String category = loginInfo.getCategory();
        String categoryType = loginInfo.getCategoryType();
        int customerid=loginInfo.getCustomerId();
        CashVanManagementFunctions cashVanfunc = new CashVanManagementFunctions();
        JSONArray jsonArray = null;
        JSONObject jsonObject = new JSONObject();
        if (request.getParameter("param") != null) {
            param = request.getParameter("param").toString();
        }

	
	
	if(param.equalsIgnoreCase("saveRouteDetails"))
	{
		try {
			String radius=request.getParameter("routeRadius");
			String sourceId = request.getParameter("source");
			String destinationId=request.getParameter("destination");
			String trigger1 = request.getParameter("trigger1");
			String trigger2="0";
			String triggerValue=request.getParameter("triggerValue");
			String routeValues = request.getParameter("routeValue");
			String haltValue=request.getParameter("haltValue");
			String routeName=request.getParameter("routeName");
			String customerId =request.getParameter("CustId");
			String routeDescription=request.getParameter("routeDescription");
			String actualDistance=request.getParameter("actualDistance");
			String expectedDistance=request.getParameter("expectedDistance");
			String actualDuration=request.getParameter("actualDuration");
			String expectedDuration=request.getParameter("expectedDuration");
			String[] haltArray=null;
			routeValues = routeValues.substring(1,routeValues.length()-2);
			String[] routeArray = routeValues.replaceAll("^[^{]*|[^}]*$", "").split("(?<=\\})[^{]*");
			triggerValue = triggerValue.substring(1,triggerValue.length()-2);
			String[] triggerArray = triggerValue.replaceAll("^[^{]*|[^}]*$", "").split("(?<=\\})[^{]*");
			
			if(!request.getParameter("haltValue").equals("[]")){
				haltValue = haltValue.substring(1,haltValue.length()-2);
				haltArray=haltValue.replaceAll("^[^{]*|[^}]*$", "").split("(?<=\\})[^{]*");
			}
			
			if(request.getParameter("trigger2") != null && !request.getParameter("trigger2").equals("")){
				trigger2=request.getParameter("trigger2");
			}
			String message=cashVanfunc.saveRouteDetails(routeName, routeArray, systemId, Integer.parseInt(customerId),routeDescription,Float.parseFloat(actualDistance),Float.parseFloat(expectedDistance),Float.parseFloat(actualDuration),Float.parseFloat(expectedDuration),Integer.parseInt(sourceId),Integer.parseInt(destinationId),Integer.parseInt(trigger1),Integer.parseInt(trigger2),triggerArray,Integer.parseInt(radius),haltArray);
			response.getWriter().print(message);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	else if(param.equalsIgnoreCase("getSourceAndDestination"))
	{
		jsonObject = new JSONObject();
		jsonArray = new JSONArray();
		
		String clientId = request.getParameter("CustId");

		try {
			jsonArray = cashVanfunc.getSourceDestination(Integer.parseInt(clientId), systemId, zone);
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
		
		String clientId = request.getParameter("CustId");

		try {
			jsonArray = cashVanfunc.getSourceDestination(Integer.parseInt(clientId), systemId, zone);
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
	else if (param.equals("getRouteDetails")) {
		
			jsonObject = new JSONObject();
			jsonArray = new JSONArray();
			String clientId = "0";
            if(request.getParameter("custId") !=null && !request.getParameter("custId").equals("")){
            	clientId=request.getParameter("custId");
            }
			try {
				jsonArray = cashVanfunc.getRouteDetails(Integer.parseInt(clientId), systemId, zone);
				if(jsonArray.length()>0){
					jsonObject.put("routeDetailsRoot",jsonArray);
					
				}else{
					jsonObject.put("routeDetailsRoot","");
				}
				response.getWriter().print(jsonObject.toString());	
			} catch (Exception e) {
				e.printStackTrace();
			}
	}
	else if (param.equals("getLatLongs")) {
		
		jsonObject = new JSONObject();
		jsonArray = new JSONArray();
		String clientId = request.getParameter("CustId");
		String routeId=request.getParameter("RouteId");
		try {
			jsonArray = cashVanfunc.getLatLongs(Integer.parseInt(routeId),Integer.parseInt(clientId), systemId,zone);
			if(jsonArray.length()>0){
				jsonObject.put("latLongRoot",jsonArray);
			}else{
				jsonObject.put("latLongRoot","");
			}
			response.getWriter().print(jsonObject.toString());	
		} catch (Exception e) {
			e.printStackTrace();
		}
  }
    else if (param.equals("getTriggerPointLatLongs")) {
		
		jsonObject = new JSONObject();
		jsonArray = new JSONArray();
		String clientId = request.getParameter("CustId");
		String routeId=request.getParameter("RouteId");
		try {
			jsonArray = cashVanfunc.getTriggerPointLatLongs(Integer.parseInt(routeId),Integer.parseInt(clientId), systemId,zone);
			if(jsonArray.length()>0){
				jsonObject.put("triggerRoot",jsonArray);
			}else{
				jsonObject.put("triggerRoot","");
			}
			response.getWriter().print(jsonObject.toString());	
		} catch (Exception e) {
			e.printStackTrace();
		}
  }
	
    else if (param.equals("getHaltLatLongs")) {
		
		jsonObject = new JSONObject();
		jsonArray = new JSONArray();
		String clientId = request.getParameter("CustId");
		String routeId=request.getParameter("RouteId");
		try {
			jsonArray = cashVanfunc.getHaltLatLongs(Integer.parseInt(routeId),Integer.parseInt(clientId), systemId,zone);
			if(jsonArray.length()>0){
				jsonObject.put("haltRoot",jsonArray);
			}else{
				jsonObject.put("haltRoot","");
			}
			response.getWriter().print(jsonObject.toString());	
		} catch (Exception e) {
			e.printStackTrace();
		}
  }

	
	else if (param.equalsIgnoreCase("InactiveRoute")) {
  	     try {
  	         String routeId = request.getParameter("routeId");
             String message = cashVanfunc.UpdateRoute(Integer.parseInt(routeId));
             response.getWriter().print(message);
  	     } catch (Exception e) {
  	         e.printStackTrace();
  	     }
  	 }
	else if(param.equalsIgnoreCase("saveRoute"))
	{
		try {
			
			String routeValues = request.getParameter("jsonArray");
			String routeName=request.getParameter("routeName");
			String startLocation= request.getParameter("startLocation");
			String endLocation= request.getParameter("endLocation");
			routeValues = routeValues.substring(1,routeValues.length()-2);
			String[] routeArray = routeValues.replaceAll("^[^{]*|[^}]*$", "").split("(?<=\\})[^{]*");
		
			String message=cashVanfunc.saveRouteDetails(routeArray,routeName,startLocation,endLocation,systemId,customerid,userId);
			response.getWriter().print(message);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}else if (param.equals("getRouteNames")) {
		try {
			jsonArray = new JSONArray();
			jsonArray = cashVanfunc.getRouteNames1(systemId, customerid);
			response.getWriter().print(jsonArray.toString());
		} catch (Exception e) {
			System.out.println("Error in Common Action:-getCustomer "
					+ e.toString());
		}
	}else if (param.equals("getRouteDetails1")) {
		jsonArray = new JSONArray();
		String routeId=request.getParameter("routeId");
		try {
			jsonArray = cashVanfunc.getLatLongs(Integer.parseInt(routeId),customerid, systemId);
			if(jsonArray.length()>0){
				jsonObject.put("latLongRoot",jsonArray);
			}else{
				jsonObject.put("latLongRoot","");
			}
			response.getWriter().print(jsonObject.toString());	
		} catch (Exception e) {
			e.printStackTrace();
		}
  }else if (param.equals("getLatLongForMarker")) {
		jsonArray = new JSONArray();
		String routeId=request.getParameter("routeId");
		try {
			jsonArray = cashVanfunc.getLatLongForMarker(Integer.parseInt(routeId),customerid, systemId,zone);
			System.out.println(jsonArray);
			if(jsonArray.length()>0){
				jsonObject.put("latLongRoot1",jsonArray);
			}else{
				jsonObject.put("latLongRoot1","");
			}
			response.getWriter().print(jsonObject.toString());	
		} catch (Exception e) {
			e.printStackTrace();
		}
  }else if (param.equals("saveInfoWindowDetails")) {
		jsonArray = new JSONArray();
		String hubName=request.getParameter("hubName");
		String remarks=request.getParameter("remarks");
		String alertType=request.getParameter("alertType");
		String alertRad=request.getParameter("alertRadius");
		String routeId=request.getParameter("routeId");
		String hubRad=request.getParameter("hubRad");
		String latitude=request.getParameter("latitude");
		String longitude=request.getParameter("longitude");
		try {
			String message = cashVanfunc.saveInfoWindowDetails(hubName,remarks,alertType,alertRad,customerid, systemId,userId,routeId,latitude,longitude,hubRad);
			response.getWriter().print(message);
		} catch (Exception e) {
			e.printStackTrace();
		}
  }

	return null;
	}
}	
		
	

