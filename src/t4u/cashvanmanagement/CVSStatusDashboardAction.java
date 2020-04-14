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
import t4u.functions.CashVanManagementFunctions;
/**
 * @author Nikhil
 *
 */
public class CVSStatusDashboardAction extends Action {
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
		int nonCommHrs=loginInfo.getNonCommHrs();
		CashVanManagementFunctions cvmf=new CashVanManagementFunctions();
		JSONArray jsonArray;
		JSONObject jsonObject;
		String param = "";
		if(request.getParameter("param")!=null)
		{
			param=request.getParameter("param").toString();
		}

		
		
		/*******************************************************************************************************************************
		 			* 						Getting over speed count for client id and system id
		 ********************************************************************************************************************************/
	   if(param.equalsIgnoreCase("getOverSpeedCount"))
			
		{
			String alertID=request.getParameter("Alert_Id");
			String custID=request.getParameter("custID");
			int overspeedcount=cvmf.getOverSpeedCount(custID, systemId,alertID,offmin);
			response.getWriter().print(Integer.toString(overspeedcount));
		}	
		
		
		
		/*******************************************************************************************************************************
			* 						Getting vehicle stoppage alert count for client id and system id
		*****************************************************************************************************************************/
		
		else if(param.equalsIgnoreCase("getVehicleStoppageAlertCount"))
		{
			String alertID=request.getParameter("Alert_Id");
			String custID=request.getParameter("custID");
			String vehicleStoppageAlertCount=cvmf.getvehicleStoppageAlertCount(custID, systemId,alertID);
			response.getWriter().print(vehicleStoppageAlertCount);
		}
		
		
		
		
		

		/*******************************************************************************************************************************
		 			* 						Getting Crossed Border Alert count for client id and system id
		 ********************************************************************************************************************************/
		else if(param.equalsIgnoreCase("getCrossedBorderCount"))
		{
			String alertID=request.getParameter("Alert_Id");
			String custID=request.getParameter("custID");
			String Offset=request.getParameter("Offset");
			String count=cvmf.getCrossedBorderAlertCount(custID, systemId,Offset,alertID);
			response.getWriter().print(count);
		}	
		
		
		
		/*******************************************************************************************************************************
			* 						Getting Deviated Standard Root alert count for client id and system id
		*****************************************************************************************************************************/
		
		else if(param.equalsIgnoreCase("getVehicleOnOffAlert"))
		{
			String alertID=request.getParameter("Alert_Id");
			String custID=request.getParameter("custID");
			String Count=cvmf.getVehicleOnOffAlertCount(custID, systemId,alertID,userId);
			response.getWriter().print(Count);
		}
	   
	   /*******************************************************************************************************************************
		* 						Getting Poor Satellite Count
	*****************************************************************************************************************************/
	
		else if(param.equalsIgnoreCase("getPoorSatelliteCount"))
		{		
		String Count=cvmf.getPoorSatelliteCount(customerId, systemId,userId,isLtsp );
		response.getWriter().print(Count);
		}

		
		/*******************************************************************************************************************************
		 			* 						Getting Continuous Moving count for client id and system id
		 ********************************************************************************************************************************/
		else if(param.equalsIgnoreCase("getContinuousMovingCount"))
		{
			String alertID=request.getParameter("Alert_Id");
			String custID=request.getParameter("custID");
			String count=cvmf.getContinousMovingAlertCount(custID, systemId,alertID);
			response.getWriter().print(count);
		}	
		
		
		
		/*******************************************************************************************************************************
			* 						Getting Idle Time alert count for client id and system id
		*****************************************************************************************************************************/
		
		else if(param.equalsIgnoreCase("getIdleTimeAlertCount"))
		{
			String alertID=request.getParameter("Alert_Id");
			String custID=request.getParameter("custID");
			String Count=cvmf.getIdleTimeAlertCount(custID, systemId,alertID);
			response.getWriter().print(Count);
		}
		

		
		
		/*******************************************************************************************************************************
		* 						Getting Statutory Alert Count count  client id and system id
		********************************************************************************************************************************/
		else if(param.equalsIgnoreCase("getStatutoryAlertCount"))
		{
			String alertID=request.getParameter("Alert_Id");
		String custID=request.getParameter("custID");
		String Offset=request.getParameter("Offset");
		String count=cvmf.getStatutoryAlertCount(custID, systemId,Offset,alertID, userId);
		response.getWriter().print(count);
		}	
	
		
		/*******************************************************************************************************************************
		* 						Getting Fuel Consume count  client id and system id
		********************************************************************************************************************************/
		else if(param.equalsIgnoreCase("getFuelConsume"))
		{
		String custID=request.getParameter("custID");
		int count=cvmf.getFuelConsume(custID, systemId,offmin);
		response.getWriter().print(count);
		}	
	   
	   /*******************************************************************************************************************************
		* 						Getting Fuel Consume count  client id and system id
		********************************************************************************************************************************/
		else if(param.equalsIgnoreCase("getReFuelConsume"))
		{
		String custID=request.getParameter("custID");
		int count=cvmf.getReFuelConsume(custID, systemId,offmin);
		response.getWriter().print(count);
		}	
	
		/*******************************************************************************************************************************
		* 						Getting Not visited vault Count for  client id and system id
		********************************************************************************************************************************/
		else if(param.equalsIgnoreCase("getNotVisitedVaultAlertCount"))
		{
			String alertID=request.getParameter("Alert_Id");
		String custID=request.getParameter("custID");
		String Offset=request.getParameter("Offset");
		String count=cvmf.getNotVisitedVaultCount(custID, systemId,Offset,alertID);
		response.getWriter().print(count);
		}	
	
		
		/*******************************************************************************************************************************
		* 						Getting not return to parking count for client id and system id
		********************************************************************************************************************************/
		else if(param.equalsIgnoreCase("getNotreturnedToParkingAlertCount"))
		{
		String custID=request.getParameter("custID");
		String Offset=request.getParameter("Offset");
		String alertID=request.getParameter("Alert_Id");
		String count=cvmf.getNotReturnToParking(custID, systemId,Offset,alertID);
		response.getWriter().print(count);
		}	
		
		/*******************************************************************************************************************************
		* 						Getting detention Alert count for client id and system id
		********************************************************************************************************************************/
		else if(param.equalsIgnoreCase("getDetentionAlertCount"))
		{
		String custID=request.getParameter("custID");
		String Offset=request.getParameter("Offset");
		String alertID=request.getParameter("Alert_Id");
		String count=cvmf.getDetention(custID, systemId,Offset,alertID);
		response.getWriter().print(count);
		}
		/*******************************************************************************************************************************
		* 						Getting Non-Communicating Vehicles
		********************************************************************************************************************************/
		else if (param.equalsIgnoreCase("getCommNonCommunicatingVehicles")) {
			try
			{
			String customerid=request.getParameter("custID");
			jsonArray = new JSONArray();
			jsonObject = new JSONObject();			
			jsonArray=cvmf.getCommNonCommVehicles(customerid, systemId,userId,isLtsp, nonCommHrs);
			if(jsonArray.length()>0)
			{
			jsonObject.put("CommNoncommroot", jsonArray);
			}
			else
			{
			jsonObject.put("CommNoncommroot", "");
			}
			response.getWriter().print(jsonObject.toString());
			}
			catch(Exception e)
			{
				
			}
		}
		/*******************************************************************************************************************************
		* 						Getting Commissioned/Decommissioned Vehicles
		********************************************************************************************************************************/
		else if (param.equalsIgnoreCase("getCommisionedDecommisionedVehicles")) {
			try
			{
			String customerid=request.getParameter("custID");
			jsonArray = new JSONArray();
			jsonObject = new JSONObject();			
			jsonArray=cvmf.getCommisionedDeCommVehicles(customerid, systemId, userId);
			if(jsonArray.length()>0)
			{
			jsonObject.put("CommDeCommroot", jsonArray);
			}
			else
			{
			jsonObject.put("CommDeCommroot", "");
			}
			response.getWriter().print(jsonObject.toString());
			}
			catch(Exception e)
			{
				
			}
		}	
		/*******************************************************************************************************************************
		* 										Preventive Expire Details
		********************************************************************************************************************************/
		else if (param.equalsIgnoreCase("getPreventiveExpiryVehicles")) {
			try
			{
			String customerid=request.getParameter("custID");
			jsonArray = new JSONArray();
			jsonObject = new JSONObject();			
			jsonArray=cvmf.getPreventiveExpiryVehicles(customerid, systemId,userId);
			if(jsonArray.length()>0)
			{
			jsonObject.put("Preventiveroot", jsonArray);
			}
			else
			{
			jsonObject.put("Preventiveroot", "");
			}
			response.getWriter().print(jsonObject.toString());
			}
			catch(Exception e)
			{
				
			}
		}	
		
		/*******************************************************************************************************************************
		* 										Live Status Details
		********************************************************************************************************************************/
		else if (param.equalsIgnoreCase("getVehicleLiveStatus")) {
			try
			{
			String customerid=request.getParameter("custID");
			jsonArray = new JSONArray();
			jsonObject = new JSONObject();			
			jsonArray=cvmf.getVehiclesLiveStatus(customerid, systemId,userId,isLtsp);
			if(jsonArray.length()>0)
			{
			jsonObject.put("VehicleStatusroot", jsonArray);
			}
			else
			{
			jsonObject.put("VehicleStatusroot", "");
			}
			response.getWriter().print(jsonObject.toString());
			}
			catch(Exception e)
			{
				
			}
		}
		/*******************************************************************************************************************************
		* 										STATUTORY_DETAILS
		********************************************************************************************************************************/
		else if (param.equalsIgnoreCase("getstatutorydetails")) {
			try
			{
			String customerid=request.getParameter("custID");
			jsonArray = new JSONArray();
			jsonObject = new JSONObject();			
			jsonArray=cvmf.getStatutoryDetails(customerid, systemId,offmin, userId);
			if(jsonArray.length()>0)
			{
			jsonObject.put("Statutoryroot", jsonArray);
			}
			else
			{
			jsonObject.put("Statutoryroot", "");
			}
			response.getWriter().print(jsonObject.toString());
			}
			catch(Exception e)
			{
				
			}
		}
		/*******************************************************************************************************************************
		* 										DASHBOARD-DETAILS
		********************************************************************************************************************************/
		else if (param.equalsIgnoreCase("getDashboardDetails")) {
			try
			{
			String customerid=request.getParameter("custID");
			String alertId=request.getParameter("alertId");
			jsonArray = new JSONArray();
			jsonObject = new JSONObject();			
			jsonArray=cvmf.getDashBoardDetails(customerid,alertId,systemId,offmin);
			if(jsonArray.length()>0)
			{
			jsonObject.put("AlertDetailsRoot", jsonArray);
			}
			else
			{
			jsonObject.put("AlertDetailsRoot", "");
			}
			response.getWriter().print(jsonObject.toString());
			}
			catch(Exception e)
			{
				
			}
		}
	   /*******************************************************************************************************************************
		* 										SAVE-REMARKS
		********************************************************************************************************************************/
		else if(param.equals("saveCVSremarks")){
			try{
				String alertslno= request.getParameter("alertslno");					
				String remark =request.getParameter("remark");
				String regno =request.getParameter("regno");
				String typeofalert =request.getParameter("typeofalert");
				String clientId =request.getParameter("clientId");
				String GMT=request.getParameter("GMT");
				String message="";
				int result=cvmf.saveCVSRemarks(alertslno ,remark, regno,GMT,typeofalert,offmin,clientId,systemId);
				if(result>0)
				{
					message="Remark Saved";
				}
				else
				{
					message="Error in Saving";
				}
				response.getWriter().print(message);	
			}catch(Exception e){
				System.out.println("Error in Asset Group Action:-deleteAssetGroupDetails "+e.toString());
			}			
		}
	   /*******************************************************************************************************************************
		* 										GET STATE WISE STATUTORY ALERT 
		********************************************************************************************************************************/
		else if(param.equals("getStateWiseStatutoryCount")){
			try{				
				String typeofalert =request.getParameter("typeofalert");
				String clientId =request.getParameter("clientId");
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();	
				jsonArray=cvmf.getStateWiseStatutoryCount(typeofalert,clientId,systemId,offmin,userId);
				if(jsonArray.length()>0)
				{
				jsonObject.put("StatutoryStateWiseCountRoot", jsonArray);
				}
				else
				{
				jsonObject.put("StatutoryStateWiseCountRoot", "");
				}
				response.getWriter().print(jsonObject.toString());
				}
				catch(Exception e)
				{
					
				}			
		}
	   /*******************************************************************************************************************************
		* 										GET STATE WISE STATUTORY ALERT DETAILS
		********************************************************************************************************************************/
		else if(param.equals("getStatutoryDashboardDetails")){
			try{				
				String typeofalert =request.getParameter("alertId");
				String clientId =request.getParameter("custID");
				String state=request.getParameter("state");
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();	
				jsonArray=cvmf.getStateWiseStatutoryDetails(typeofalert,state,offmin,clientId,systemId,userId);
				if(jsonArray.length()>0)
				{
				jsonObject.put("StatutoryStateWiseDetailsRoot", jsonArray);
				}
				else
				{
				jsonObject.put("StatutoryStateWiseDetailsRoot", "");
				}
				response.getWriter().print(jsonObject.toString());
				}
				catch(Exception e)
				{
					
				}			
		}else if(param.equals("getVehicleOffRoadDetails")){				
			try{
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				jsonArray=cvmf.getVehicleOffRoadDetails(customerId, systemId,userId,offmin);
					if(jsonArray.length()>0){
						jsonObject.put("vehicleOffRoadDetailsRoot", jsonArray);
					}
					else{
						jsonObject.put("vehicleOffRoadDetailsRoot", "");
					}
				response.getWriter().print(jsonObject.toString());
			}catch (Exception e) {
				e.printStackTrace();
			}
			
		}else if(param.equals("getVehicleCountInHub")){				
			try{
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				jsonArray=cvmf.getVehicleCountInHub(customerId, systemId,userId);
					if(jsonArray.length()>0){
						jsonObject.put("hubCountRoot", jsonArray);
					}else{
						jsonObject.put("hubCountRoot", "");
					}
				response.getWriter().print(jsonObject.toString());
			}catch (Exception e) {
				e.printStackTrace();
			}
			
		}
		}else{
			
			if (request.getParameter("param").equals("checkSession")){	
				
        	response.getWriter().print("InvalidSession");
        	}
		}
		return null;
	}

}
