package t4u.admin;

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
import t4u.functions.CommonFunctions;


public class DayWiseReprocessAction extends Action{
	public ActionForward execute(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) throws Exception {
		String param = "";
		String zone="";
		int systemId=0;
		int userId=0;
		int offset=0;
		HttpSession session = request.getSession();
		LoginInfoBean loginInfo=(LoginInfoBean)session.getAttribute("loginInfoDetails");
		AdminFunctions reprocess = new AdminFunctions();
		systemId=loginInfo.getSystemId();
		//String lang = loginInfo.getLanguage();
		zone=loginInfo.getZone();
		userId=loginInfo.getUserId();
		offset=loginInfo.getOffsetMinutes();
		String lang = loginInfo.getLanguage();
		zone = loginInfo.getZone();
		CommonFunctions cf = new CommonFunctions();
		JSONArray jsonArray = null;
		JSONObject jsonObject = new JSONObject();
		if (request.getParameter("param") != null) {
			param = request.getParameter("param").toString();
		}  
   
		if(param.equals("getVehicle")){
			try{
		      	String customerId = request.getParameter("CustId");
				jsonObject = new JSONObject();
				if(customerId != null){
						jsonArray = reprocess.getVehicle(systemId, Integer.parseInt(customerId),userId);
						jsonObject.put("VehicleRoot", jsonArray);
				}
				else{
					    jsonObject.put("VehicleRoot", "");
				}
			response.getWriter().print(jsonObject.toString());
			}
			catch(Exception e){
				e.printStackTrace();
			}
			
		 }
		if(param.equals("reProcess")){
			try{
		      	String customerId = request.getParameter("custName");
		      	String vehicleNo=request.getParameter("vehicleNo");
		      	String date=request.getParameter("date");
				
			String msg= reprocess.reprocessDataForVehicle(systemId, Integer.parseInt(customerId),vehicleNo,date,offset,userId);
						
			response.getWriter().print(msg);
			}
			catch(Exception e){
				e.printStackTrace();
			}
			
		 }
		
		return null;
	}

	
}
