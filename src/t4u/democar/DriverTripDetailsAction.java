package t4u.democar;

import java.text.SimpleDateFormat;
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
import t4u.functions.DemoCarFunctions;


public class DriverTripDetailsAction extends Action{
	public ActionForward execute(ActionMapping mapping, ActionForm form,HttpServletRequest request, HttpServletResponse response){
		HttpSession session = request.getSession();
		LoginInfoBean loginInfo=(LoginInfoBean)session.getAttribute("loginInfoDetails");
		DemoCarFunctions dcf = new DemoCarFunctions();
		int systemId=loginInfo.getSystemId();
		int createdUser=loginInfo.getUserId();
		int userId = loginInfo.getUserId();
		int offSet = loginInfo.getOffsetMinutes();
		String language = loginInfo.getLanguage();
		String zone=loginInfo.getZone();
		JSONArray jsonArray = null;
		JSONObject jsonObject = null;
		String param = "";
		
		if(request.getParameter("param")!=null){
			param=request.getParameter("param").toString();
		}
		
		if(param.equalsIgnoreCase("getDriverTripDetails")){
			try
			{
				
			String customer=request.getParameter("customerID");
			int customerid=0;
			if(!(customer==null||customer.equals(""))){
				customerid=Integer.parseInt(customer);
			}
			jsonArray = new JSONArray();
			jsonObject = new JSONObject();			
			jsonArray=dcf.getDriverTripDetails(customerid,systemId,zone);
			if(jsonArray.length()>0){
			jsonObject.put("driverTripDetailsRoot", jsonArray);
			}else{
			jsonObject.put("driverTripDetailsRoot", "");
			}
			response.getWriter().print(jsonObject.toString());
			}
			catch(Exception e){
				System.out.println("Exception in AssetGroupAction:-getAssetGroupDetails "+e.toString());
			}
		}
		
		else if(param.equals("getVehicleNoListForClient"))
	    {
	    	String clientIdFromJsp = request.getParameter("globalClientId");
	    	int clientId=0;
	    	if(clientIdFromJsp != null&& !clientIdFromJsp.equals("")){
	    		clientId = Integer.parseInt(clientIdFromJsp);
	    	}
	    	jsonObject = new JSONObject();		
	    	jsonArray = new JSONArray();
			jsonArray = dcf.getVehiclesforClient(systemId,clientId,userId);
	    	try{
	    		if(jsonArray.length()>0){
				jsonObject.put("vehicleNoStoreList", jsonArray);
				}else{
				jsonObject.put("vehicleNoStoreList", "");
				}
	    		response.getWriter().print(jsonObject.toString());	
	    	}
	    	catch(Exception e){
	    		e.printStackTrace();
	    	}
	    }else if(param.equals("getHubNames"))
	    {
	    	String clientIdFromJsp = request.getParameter("customerID");
	    	int clientId=0;
	    	if(clientIdFromJsp != null&& !clientIdFromJsp.equals("")){
	    		clientId = Integer.parseInt(clientIdFromJsp);
	    	}
	    	jsonObject = new JSONObject();		
	    	jsonArray = new JSONArray();
			jsonArray = dcf.getHubNamesForTripDetail(clientId,systemId,zone);
	    	try{
	    		if(jsonArray.length()>0){
				jsonObject.put("hubNameRoot", jsonArray);
				}else{
				jsonObject.put("hubNameRoot", "");
				}
	    		response.getWriter().print(jsonObject.toString());	
	    	}
	    	catch(Exception e){
	    		e.printStackTrace();
	    	}
	    }
		else if (param.equals("saveormodifyDriverTripDetails")) {
			try {
				String buttonValue = request.getParameter("buttonValue");
				String cutomerId = request.getParameter("customerID");
				String assetNo = request.getParameter("assetNo");
				String startDate = request.getParameter("startDate");
				String tripId=request.getParameter("tripId");
				String hubId = request.getParameter("hubId");
				String closeDate = request.getParameter("endDate");
				String uniqueId= request.getParameter("uniqueId");
				String message = "";
				if(hubId.equals("") || hubId==null)
				{
					hubId="0";
				}
				if (buttonValue.equals("Add")) {
					message = dcf.saveDriverTripDetails(assetNo,startDate,tripId,systemId,
							createdUser,Integer.parseInt(cutomerId),Integer.parseInt(hubId));
					response.getWriter().print(message);
				} else if (buttonValue.equals("Modify")) {
					message=dcf.modifyDriverTripDetails(uniqueId,closeDate,systemId,createdUser,Integer.parseInt(cutomerId),startDate,assetNo,offSet);
					response.getWriter().print(message);
				}
			} catch (Exception e) {
				System.out.println("Error in Asset Group Action:-saveRmodifyAssetGroupDetails "+ e.toString());
			}
		}
		else if(param.equalsIgnoreCase("getTripDetailsReport")){
			String ClientId = request.getParameter("ClientId");
			String StartDate = request.getParameter("startDate");
			String EndDate = request.getParameter("endDate");
			String jspName = request.getParameter("jspName");
			String custName = request.getParameter("custName");
			SimpleDateFormat yyyyMMdd = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			SimpleDateFormat ddMMyyyyHHmmss = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
			try{
				jsonObject = new JSONObject();
				jsonArray = new JSONArray();
				if(ClientId != null && !ClientId.equals("") ){
					ArrayList <Object> List = dcf.getTripDetailsReport(Integer.parseInt(ClientId),systemId,StartDate,EndDate,zone,language);
					jsonArray = (JSONArray) List.get(0);
					if(jsonArray.length()>0){
						jsonObject.put("tripDetailRoot", jsonArray);
					}else{
						jsonObject.put("tripDetailRoot", "");
					}
					ReportHelper reportHelper = (ReportHelper) List.get(1);
					session.setAttribute(jspName, reportHelper);
					session.setAttribute("startdate", ddMMyyyyHHmmss.format(yyyyMMdd.parseObject(StartDate.replace("T", " "))));
					session.setAttribute("enddate", ddMMyyyyHHmmss.format(yyyyMMdd.parseObject(EndDate.replace("T", " "))));
					session.setAttribute("custname", custName);
				}else{
					jsonObject.put("tripDetailRoot", "");
				}
				response.getWriter().print(jsonObject.toString());
			}catch(Exception e){

			}
		}
		return null;
	}
	
}
