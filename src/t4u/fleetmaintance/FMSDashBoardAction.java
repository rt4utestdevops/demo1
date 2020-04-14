package t4u.fleetmaintance;



import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.struts.action.Action;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.json.JSONArray;
import org.json.JSONObject;

import com.google.gson.JsonObject;


import t4u.beans.LoginInfoBean;
import t4u.functions.CashVanManagementFunctions;
import t4u.functions.FleetMaintanceFunctions;
/**
 * @author Bhagyashree
 *
 */
public class FMSDashBoardAction extends Action {
		@Override
		public ActionForward execute(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		HttpSession session = request.getSession();
		LoginInfoBean loginInfo=(LoginInfoBean)session.getAttribute("loginInfoDetails");
		if(loginInfo!=null)
		{
		int isLtsp=2; 
		int systemId=loginInfo.getSystemId();
		int offmin=loginInfo.getOffsetMinutes();
		int customerId=loginInfo.getCustomerId();
		int userId=loginInfo.getUserId();
		isLtsp=loginInfo.getIsLtsp();
		
		String param = "";
		if(request.getParameter("param")!=null)
		{
			param=request.getParameter("param").toString();
		}

		FleetMaintanceFunctions fms = new FleetMaintanceFunctions();
		
		/*******************************************************************************************************************************
		 			* 						Getting over speed count for client id and system id
		 ********************************************************************************************************************************/
		if(param.equalsIgnoreCase("getTypesNew")){
			try{
				JSONArray jsonArray = new JSONArray();
				JSONObject jsonObject = new JSONObject();	
				jsonArray=fms.getVehicleTypesFromMaster(systemId,customerId);			
				if(jsonArray.length()>0)
				{
				jsonObject.put("vehicelTypeStoreIdRoot", jsonArray);
				}
				else
				{
				jsonObject.put("vehicelTypeStoreIdRoot", "");
				}
				response.getWriter().print(jsonObject.toString());
			}catch(Exception e){
				e.printStackTrace();
			}
		}
		
		else if (param.equalsIgnoreCase("getIdlingdetails")) {
			try
			{
			String customerid=request.getParameter("custID");
			String vehicleType = request.getParameter("vehicleType");
   			String reportType=  request.getParameter("reportType");
			String startDate = request.getParameter("startDate");
			String endDate = request.getParameter("endDate");
			JSONArray jsonArray = new JSONArray();
			JSONObject jsonObject = new JSONObject();			
			jsonArray=fms.getIdlingDetails(Integer.parseInt(reportType),customerid, systemId,offmin,vehicleType,startDate,endDate,userId);
			if(jsonArray.length()>0)
			{
			jsonObject.put("Idlingroot", jsonArray);
			}
			else
			{
			jsonObject.put("Idlingroot", "");
			}
			response.getWriter().print(jsonObject.toString());
			}
			catch(Exception e)
			{
				
			}
		}
           
           else if(param.equalsIgnoreCase("getIdlingdetailsNew")) {
   			try
   			{
   			String customerid=request.getParameter("custID");
   			String vehicleType = request.getParameter("vehicleType");
      		String reportType=  request.getParameter("reportType");
   			String startDate = request.getParameter("startDate");
   			String endDate = request.getParameter("endDate");
   			JSONArray jsonArray = new JSONArray();
   			JSONObject jsonObject = new JSONObject();			
   			jsonArray=fms.getIdlingDetails(Integer.parseInt(reportType),customerid, systemId,offmin,vehicleType,startDate,endDate,userId);
   			if(jsonArray.length()>0)
   			{
   			jsonObject.put("IdlingrootNew", jsonArray);
   			}
   			else
   			{
   			jsonObject.put("IdlingrootNew", "");
   			}
   			response.getWriter().print(jsonObject.toString());
   			}
   			catch(Exception e)
   			{
   				
   			}
   		}
           else if (param.equalsIgnoreCase("getIdlingTrend")) {
   			try
   			{
   			String customerid=request.getParameter("custID");
   			String vehicleType = request.getParameter("vehicleType");
   			String reportType=  request.getParameter("reportType");
   			String duration = request.getParameter("duration");
   			String selectedDate = request.getParameter("selectedDate");
   			JSONArray jsonArray = new JSONArray();
   			JSONObject jsonObject = new JSONObject();
   			if(reportType.equals("5") ){
   	   	   		jsonArray=fms.getPMTrend(Integer.parseInt(reportType),customerid, systemId,offmin,vehicleType,duration, selectedDate,userId);	
   	   			}else{
   		   			jsonArray=fms.getIdlingTrend(Integer.parseInt(reportType),customerid, systemId,offmin,vehicleType,duration, selectedDate,userId);
   	   			}
   			if(jsonArray.length()>0)
   			{
   			jsonObject.put("IdlingTrendroot", jsonArray);
   			}
   			else
   			{
   			jsonObject.put("IdlingTrendroot", "");
   			}
   			response.getWriter().print(jsonObject.toString());
   			}
   			catch(Exception e)
   			{
   				
   			}
   		}
	   
           else if (param.equalsIgnoreCase("getIdlingTrend2")) {
      			try
      			{
      			String customerid=request.getParameter("custID");
      			String vehicleType = request.getParameter("vehicleType");
      			String statutoryType = request.getParameter("StatutoryType");
      			String reportType=  request.getParameter("reportType");
      			String duration = request.getParameter("duration");
      			String selectedDate = request.getParameter("selectedDate");
      			JSONArray jsonArray = new JSONArray();
      			JSONObject jsonObject = new JSONObject();
      			if(reportType.equals("6") ){
      	   	   		jsonArray=fms.getStatutoryTrend(Integer.parseInt(reportType),customerid, systemId,offmin,vehicleType,statutoryType,duration, selectedDate,userId);	     	   			     			
      			}if(jsonArray.length()>0)
      			{
      			jsonObject.put("IdlingTrendroot2", jsonArray);
      			}
      			else
      			{
      			jsonObject.put("IdlingTrendroot2", "");
      			}
      			response.getWriter().print(jsonObject.toString());
      			}
      			catch(Exception e)
      			{
      				
      			}
      		}
	   
	   
           else if (param.equalsIgnoreCase("getIdlingdetailsforclick")) {
   			try
   			{
   			//System.out.println(" came here for on click !!!!!!!!!!!!!!");
   			String customerid=request.getParameter("custID");
   			String vehicleType = request.getParameter("vehicleType");
   			//System.out.println(" vehicleType == "+vehicleType);
      		String reportType=  request.getParameter("reportType");
      		//System.out.println(" reportType == "+reportType);
   			String startDate = request.getParameter("startDate");
   			String endDate = request.getParameter("endDate");
   			String groupName = request.getParameter("groupName");
   			//System.out.println(" groupName == "+groupName);
   			String duration = request.getParameter("duration");  
   			String statutoryType = request.getParameter("StatutoryType");  
   			String columnNumber = request.getParameter("barnumber"); 
   			int columnNum = 0;
   			if(columnNumber !=null && !columnNumber.equals("")){
   				columnNum = Integer.parseInt(columnNumber);	
   			}
   			JSONArray jsonArray = new JSONArray();
   			JSONObject jsonObject = new JSONObject();	
   			jsonArray=fms.getIdlingdetailsforclick(Integer.parseInt(reportType),customerid, systemId,offmin,vehicleType,startDate,endDate,groupName,duration,userId,statutoryType,columnNum);   			
   			if(jsonArray.length()>0)
   			{
   			jsonObject.put("IdlingrootIdclick", jsonArray);
   			}
   			else
   			{
   			jsonObject.put("IdlingrootIdclick", "");
   			}
   			response.getWriter().print(jsonObject.toString());
   			}
   			catch(Exception e)
   			{
   				
   			}
   		}
	}
		return null;
		}
}
