package t4u.ironMining;


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
import t4u.functions.IronMiningFunction;
public class IronMiningAction extends Action {
	public ActionForward execute(ActionMapping mapping, ActionForm form,HttpServletRequest request, HttpServletResponse response) throws Exception {
		try {
			String zone="";
			HttpSession session = request.getSession();
			LoginInfoBean loginInfo =(LoginInfoBean)session.getAttribute("loginInfoDetails");
            if(loginInfo != null)
            {
			int systemId  = loginInfo.getSystemId();
			int customerId = loginInfo.getCustomerId();
			int userId = loginInfo.getUserId();
			int offmin = loginInfo.getOffsetMinutes();
			int isLtsp = loginInfo.getIsLtsp();
			zone=loginInfo.getZone();
			IronMiningFunction ironfunc = new IronMiningFunction();
			JSONArray jsonArray = null;
			String param = "";
			if (request.getParameter("param") != null) {
				param = request.getParameter("param").toString();
			}
			
			if(param.equals("getDashboardElementsCount")){
				try {
					customerId=Integer.parseInt(request.getParameter("customerId"));
					String vehicleType=request.getParameter("vehicleType");
					JSONObject jsonObject = new JSONObject();
					jsonArray = ironfunc.getDashboardElementsCount(systemId, customerId, userId,offmin,vehicleType,isLtsp);
					if (jsonArray.length() > 0) {
						jsonObject.put("DashBoardElementCountRoot", jsonArray);
					} else {
						jsonObject.put("DashBoardElementCountRoot", "");
					}
					response.getWriter().print(jsonObject.toString());
				} catch (Exception e) {
					e.printStackTrace();
				}
			} else if (param.equals("getDashboardRevenueChart")) {
				try {
					customerId=Integer.parseInt(request.getParameter("customerId"));
					String vehicleType=request.getParameter("vehicleType");
					
					JSONObject jsonObject = new JSONObject();
					jsonArray = ironfunc.getWeeklyRevenue(customerId,vehicleType, systemId, offmin);

					if (jsonArray.length() > 0) {
						jsonObject.put("DashBoardRevenueChartRoot", jsonArray);
					} else {
						jsonObject.put("DashBoardRevenueChartRoot", "");
					}
					response.getWriter().print(jsonObject.toString());
				} catch (Exception e) {
					e.printStackTrace();
				}
			} else if (param.equals("getDashboardPermitChart")) {
				
				try {
					customerId=Integer.parseInt(request.getParameter("customerId"));
					String vehicleType=request.getParameter("vehicleType");
					
					JSONObject jsonObject = new JSONObject();
					jsonArray = ironfunc.getWeeklyPermit(customerId,vehicleType, systemId, offmin);

					if (jsonArray.length() > 0) {
						jsonObject.put("DashBoardPermitChartRoot", jsonArray);
					} else {
						jsonObject.put("DashBoardPermitChartRoot", "");
					}
					response.getWriter().print(jsonObject.toString());
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
//-----------------------------Added for Hub Operational Window 1.Grid----------------------------------------//			
			 else if (param.equals("getTypes")) {
				 try {
						String clientId = request.getParameter("CustID");
						String hubOpID=request.getParameter("hubOpID");
						JSONObject rslt = new JSONObject();
						if(clientId!=null && hubOpID!=null)
					{   JSONArray list = ironfunc.getMiningSettingTypes(Integer.parseInt(clientId), loginInfo.getSystemId(),hubOpID,zone);
					    if(list!=null)
						rslt.put("hubOperationRoot", list);
					    else
					    rslt.put("hubOperationRoot", "");
						String rsltSr = rslt.toString();
					    response.getWriter().print(rsltSr);
					}
					} catch (Exception e) {
					}
				}

//----------------------------------2.ADD/MODIFY----------------------------------------------//
			
			 else if (param.equals("hubOperationAddModify")) {
				    try {
				    	
						String clientId = request.getParameter("CustID");
						String hubOpID=request.getParameter("hubOpID");
						String buttonValue=request.getParameter("buttonValue");
						String selectdName=request.getParameter("selectdName");
						String nameID=request.getParameter("nameId");
						String placeID=request.getParameter("placeID");
						String typeID=request.getParameter("typeID");
						String msg = ironfunc.addModifyHubOperation(Integer.parseInt(clientId), loginInfo.getSystemId(),buttonValue,nameID,hubOpID,selectdName,placeID,zone,typeID);
						if(msg=="")
						msg="Error";
						response.getWriter().print(msg);
					} catch (Exception e) {
						e.printStackTrace();
					}
				}
			
//----------------------------------3.GET HUB NAMES----------------------------------------------//
			
			 else if(param.equals("getPlaceNames"))
			 {  
			try 
			    {
				String clientId = request.getParameter("CustID");
				String hubOpID=request.getParameter("hubOpID");
				JSONObject rslt = new JSONObject();
				if(clientId!=null && hubOpID!=null)
				{   JSONArray list = ironfunc.getPlaceNames(Integer.parseInt(clientId), loginInfo.getSystemId(),hubOpID,zone);
				
				    if(list!=null)
					rslt.put("PlaceRoot", list);
				    else
				    rslt.put("PlaceRoot", "");
					String rsltSr = rslt.toString();
				    response.getWriter().print(rsltSr);
				}
				} catch (Exception e) {
				}
			 }

//----------------------------------4.DELETE GRID DETAILS----------------------------------------------//
			
			 else if(param.equals("deleteHubDetails"))
			 {  
			try 
			    {
				String msg="";
				String clientId = request.getParameter("CustID");
				String locID=request.getParameter("locID");
				String typeID=request.getParameter("typeID");
				if(clientId!=null)
				{  
					msg = ironfunc.deleteHubDetails(Integer.parseInt(clientId), loginInfo.getSystemId(),locID,typeID);
					response.getWriter().print(msg);
				}
				} catch (Exception e) {
				}
			 }

//----------------------------------5.DETAILS (VEHICLE NO,DETENTION)----------------------------------------------//
			
			 else if(param.equals("getDetails"))
			 {  
			try 
			    {
				String clientId = request.getParameter("CustID");
				String selectdName=request.getParameter("selectdName");
				String placeID=request.getParameter("NameID");
				JSONObject rslt = new JSONObject();
				
				if(clientId!=null)
				{   
					JSONArray array = ironfunc.getDetails(Integer.parseInt(clientId), loginInfo.getSystemId(),selectdName,placeID,offmin,zone);
					if(array!=null)
					rslt.put("DetailsRoot", array);
					else
					rslt.put("DetailsRoot", "");
					String rsltSr = rslt.toString();
				    response.getWriter().print(rsltSr);
				}
				} catch (Exception e) {
					e.printStackTrace();
				}
			 }
          }
            
            else
            {
            	if (request.getParameter("param").equals("checkSession"))
            	{	
            	response.getWriter().print("InvalidSession");
            	}
            }
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}
}
