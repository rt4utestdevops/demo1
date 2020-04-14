package t4u.cargomanagement;


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
import t4u.functions.CargomanagementFunctions;
import t4u.functions.CommonFunctions;

public class CargoManagementAction extends Action {

	public ActionForward execute(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		String param = "";
		String message = "";
		String zone="";
		int systemId=0;
		int userId=0;
		int offset=0;
		int isLtsp=2;
		HttpSession session = request.getSession();
		LoginInfoBean loginInfo=(LoginInfoBean)session.getAttribute("loginInfoDetails");
		CargomanagementFunctions cargofunc = new CargomanagementFunctions();
		systemId=loginInfo.getSystemId();
		zone=loginInfo.getZone();
		userId=loginInfo.getUserId();
		offset=loginInfo.getOffsetMinutes();
		String lang = loginInfo.getLanguage();
		zone = loginInfo.getZone();
		isLtsp=loginInfo.getIsLtsp();
		CommonFunctions cf = new CommonFunctions();
		JSONArray jsonArray = null;
		JSONObject jsonObject = new JSONObject();
		if (request.getParameter("param") != null) {
			param = request.getParameter("param").toString();
		}
		/**
		 * Getting Hubs on the basis of Customer for Add option
		 */
		if (param.equals("getHubs")) {
			try{
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				String custID="no";
				if(request.getParameter("CustId")!=null)
				{
				custID=request.getParameter("CustId").toString();
				}				
				jsonArray=cargofunc.getHubs(custID,zone);
				if(jsonArray.length()>0)
				{
				jsonObject.put("HubRoot", jsonArray);
				}
				else
				{
				jsonObject.put("HubRoot", "");
				}
				response.getWriter().print(jsonObject.toString());
				}  
				catch(Exception e)
				{
				System.out.println("Error in getting Hubs"+e.toString());
			    }			
		}
		/**
		 * Getting Trip Names on the basis of Customer for Modify option
		 */
		if (param.equals("getTripNames")) {
			try{
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				String custID="no";
				if(request.getParameter("CustId")!=null)
				{
				custID=request.getParameter("CustId").toString();
				}				
				jsonArray=cargofunc.getTripnames(custID,systemId);
				if(jsonArray.length()>0)
				{
				jsonObject.put("TripRoot", jsonArray);
				}
				else
				{
				jsonObject.put("TripRoot", "");
				}
				response.getWriter().print(jsonObject.toString());
				}  
				catch(Exception e)
				{
				System.out.println("Error in getting Trip Names"+e.toString());
			    }			
		}
		/**
		 * To fetch Trip details on the basis of Trip Name for modify option
		 */
		if (param.equals("getTripDetails")) {
		try
		{
			String customerid=request.getParameter("CustId");
			String tripname=request.getParameter("TripName");
			jsonArray = new JSONArray();
			jsonObject = new JSONObject();			
			jsonArray=cargofunc.getTripDetails(customerid,tripname);
			if(jsonArray.length()>0)
			{
			jsonObject.put("TripDetailsRoot", jsonArray);
			}
			else
			{
			jsonObject.put("TripDetailsRoot", "");
			}
			response.getWriter().print(jsonObject.toString());
		}
		catch(Exception e)
		{
			
		}
		}
		/**
		 * Inserting/Modifying Cargo Trip 
		 */
		if (param.equals("saveormodifyContainer")) {
			try
			{
			String buttonvalue=request.getParameter("buttonvalue");
			if(buttonvalue.equalsIgnoreCase("add"))
			{
			String custmastcomboId=request.getParameter("custmastcomboId");
			String cargotripnametxt=request.getParameter("cargotripnametxt");
			String cargotripcode=request.getParameter("cargotripcode");
			String cargoorgin=request.getParameter("cargoorgin");
			String transitions=request.getParameter("transitionnoArray");
			String cargodestination=request.getParameter("cargodestination");
			String cargototaltime=request.getParameter("cargototaltime");
			String cargoapproxdistance=request.getParameter("cargoapproxdistance");
			String cargoaveragespeed=request.getParameter("cargoaveragespeed");
			if(cargofunc.tripNamealreadyexist(custmastcomboId,cargotripnametxt,systemId))
			{
			message="Trip Name Already Exists";	
			}
			else
			{
			int inserResult=cargofunc.insertCargoTrip(cargotripnametxt,cargotripcode,cargoorgin,
													  transitions,cargodestination,cargototaltime,
													  cargoapproxdistance,custmastcomboId,systemId,userId,cargoaveragespeed);
			if(inserResult>0)
			{
			message="Cargo Trip Added Successfully";
			}
			else
			{
			message="Error in Inserting Cargo Trip";	
			}
			}
			response.getWriter().print(message);
			}
			if(buttonvalue.equalsIgnoreCase("modify"))
			{
				String custmastcomboId=request.getParameter("custmastcomboId");
				String cargotripname=request.getParameter("cargotripnamecombo");
				String cargotripcode=request.getParameter("cargotripcode");
				String cargoorgin=request.getParameter("cargoorgin");
				String transitions=request.getParameter("transitionnoArray");
				String cargodestination=request.getParameter("cargodestination");
				String cargototaltime=request.getParameter("cargototaltime");
				String cargoapproxdistance=request.getParameter("cargoapproxdistance");
				String cargoaveragespeed=request.getParameter("cargoaveragespeed");
				int modifyResult=cargofunc.updateCargoTrip(cargotripname,cargotripcode,cargoorgin,
														  transitions,cargodestination,cargototaltime,
														  cargoapproxdistance,custmastcomboId,systemId,userId,cargoaveragespeed);
				if(modifyResult>0)
				{
				message="Cargo Trip Modifyed Successfully";
				}
				else
				{
				message="Error in Modifying Cargo Trip";	
				}
				response.getWriter().print(message);	
			}		
		    } 
			catch (Exception e) 
			{
			e.printStackTrace();
		    }
			
		}
		/**
		 * Deletes Cargo Trip
		 */
		if (param.equals("deleteCargoTrip"))
		{
			try{
				String custmastcomboId=request.getParameter("custId");
				String cargotripname=request.getParameter("tripName");
				int deleteResult=cargofunc.deleteCargoTrip(custmastcomboId,cargotripname);
				if(deleteResult>0)
				{
				message="Cargo Trip Deleted Successfully";
				}
				else
				{
				message="Error in Deleting Cargo Trip";	
				}
				response.getWriter().print(message);
			}
			catch(Exception e)
			{
				
			}
		}
		/**
		 * Returns details for Grid in Trip Allocation
		 */
		if(param.equals("getGridTripAllocation"))
		{
			try
			{
			String customerid=request.getParameter("custID");
			jsonArray = new JSONArray();
			jsonObject = new JSONObject();	
			jsonArray=cargofunc.getGridTripDetails(customerid,systemId,userId,offset,zone);
			if(jsonArray.length()>0)
			{
			jsonObject.put("GridRoot", jsonArray);
			}
			else
			{
			jsonObject.put("GridRoot", "");
			}
			response.getWriter().print(jsonObject.toString());
			}
			catch(Exception e)
			{
				
			}	
		}
		/**
		 * getting vehicles details on the basis of selected customer  and ltsp 
		 */
		if(param.equals("getVehicleDetails")){
		
			
			try {
				jsonArray=new JSONArray();
				jsonObject=new JSONObject();
				String custId=request.getParameter("CustId");
				String ltspId=request.getParameter("LTSPId");
				
				if(custId !=null && ltspId !=null){
				jsonArray=cargofunc.getVehicleDetails(custId,ltspId,userId);
				}
				if(jsonArray.length()>0){
					jsonObject.put("VehicleRoot", jsonArray);
				}else{
					jsonObject.put("VehicleRoot", "");
				}
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {
				System.out.println("Error in EmployeeTrackingAction:-getVehicleDetails"+e);
			}
			
		}
		/**
		 * Returns Route Names
		 */
		if(param.equals("getRoutesTripAllocation"))
		{
			try
			{
				String customerid=request.getParameter("custID");
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();			
				jsonArray=cargofunc.getRoutesforTripAllocation(customerid,systemId);
				if(jsonArray.length()>0)
				{
				jsonObject.put("RootName", jsonArray);
				}
				else
				{
				jsonObject.put("RootName", "");
				}
				response.getWriter().print(jsonObject.toString());
			}
			catch(Exception e)
			{
				
			}	
		}
		/**
		 * Save and Modify Trip Allocation
		 */
		if(param.equals("saveormodifyTripAllocation"))
		{
			String buttonvalue=request.getParameter("buttonvalue");
			String custID=request.getParameter("custID");
			String vehicleno=request.getParameter("vehicleno");
			String routename=request.getParameter("routename");
			String status=request.getParameter("status");
			
			if(buttonvalue.equals("Add"))
			{
				message=cargofunc.insertTripAllocation(vehicleno,routename,systemId,custID,userId,offset);
				response.getWriter().print(message);	
			}
			else if(buttonvalue.equals("Modify"))
			{
				String id=request.getParameter("id");
				int updateResult=cargofunc.updateTripAllocation(vehicleno,routename,systemId,custID,userId,id,offset,status);
				if(updateResult>0)
				{
					message="Trip Updated Successfully";
				}
				else
				{
					message="Error in Trip Updation";	
				}
				response.getWriter().print(message);	
			}
		}
		/**
		 * Close the Allotted Trip
		 */
		if(param.equals("closeTripAllocation"))
		{
			try{
				String custID=request.getParameter("custID");
				String vehicleno=request.getParameter("vehicleno");
				String routename=request.getParameter("routename");
				String endtime=request.getParameter("endtime");
				//String assetgroup=request.getParameter("assetgroup");
				int deleteResult=cargofunc.deleteAllottedTrip(custID,vehicleno,routename,endtime,systemId,offset);
				if(deleteResult>0)
				{
				message="Alotted Trip Closed Successfully";
				}
				else
				{
				message="Error in Deleting Trip";	
				}
				response.getWriter().print(message);
			}
			catch(Exception e)
			{
				
			}	
		}
		/**
		 * Getting details from DashBoard
		 */
		if(param.equals("getDashBoardDetails"))
		{
			try
			{
				String customerid=request.getParameter("CustId");
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();			
				jsonArray=cargofunc.getDashBoardDetails(customerid,systemId,zone,offset);
				if(jsonArray.length()>0)
				{
				jsonObject.put("DashBoardDetailsRoot", jsonArray);
				}
				else
				{
				jsonObject.put("DashBoardDetailsRoot", "");
				}
				response.getWriter().print(jsonObject.toString());
			}
			catch(Exception e)
			{
				
			}
			
		}
		
		if (param.equals("getAssetNumber")) {
			try {
				String customerId = request.getParameter("CustId");
				String groupid = request.getParameter("globalGroupId");
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();	

				if (customerId != null) {
					if (groupid == null || groupid.equals("0") || groupid.equals("")) {
						groupid = null;
					}
					jsonArray = cargofunc.getAssetNumber(systemId, Integer.parseInt(customerId), groupid, userId);
					jsonObject.put("assetNumberRoot", jsonArray);
				}
				else {
					jsonObject.put("assetNumberRoot", "");
				}
				response.getWriter().print(jsonObject.toString());
			}
			catch (Exception e) {
				e.printStackTrace();
			}
		}
		
		 if(param.equals("getAssetGroup")){
			try{
              	String customerId = request.getParameter("CustId");
				jsonObject = new JSONObject();
				if(customerId != null){
						jsonArray = cargofunc.getAssetGroup(systemId, Integer.parseInt(customerId),userId);
						jsonObject.put("assetGroupRoot", jsonArray);
				}
				else{
					    jsonObject.put("assetGroupRoot", "");
				}
			response.getWriter().print(jsonObject.toString());
			}
			catch(Exception e){
				e.printStackTrace();
			}
			
         }
		
		 if (param.equalsIgnoreCase("getPlantMovementReport")) {
		        try {
		            String customerId = request.getParameter("CustId");
		            String s = request.getParameter("gridData");
		            String startDate= request.getParameter("startDate");
		            String endDate= request.getParameter("endDate");
		            String custName=request.getParameter("CustName");
		            String jspName=request.getParameter("jspName");
		            jsonArray = new JSONArray();
		            
		            if (customerId != null && !customerId.equals("")) {
		            	if (s !=null && !s.equals("")) {
                            String st = "[" + s + "]";                    
                            JSONArray firstGridData = null;
                           
						firstGridData = new JSONArray(st.toString());
						
                       	ArrayList < Object > list1 = cargofunc.getPlantMovementReport(systemId, Integer.parseInt(customerId), userId, firstGridData,lang,startDate,endDate,offset,zone);
		            	jsonArray = (JSONArray) list1.get(0);
		                if (jsonArray.length() > 0) {
		                    jsonObject.put("plantMovementReport", jsonArray);
		                } else {
		                    jsonObject.put("plantMovementReport", "");
		                }
		                ReportHelper reportHelper = (ReportHelper) list1.get(1);
		                request.getSession().setAttribute(jspName, reportHelper);
		                request.getSession().setAttribute("customerId", custName);
		                request.getSession().setAttribute("startDate",cf.getFormattedDateddMMYYYY(startDate.replaceAll("T", " ")));
			    		request.getSession().setAttribute("endDate",cf.getFormattedDateddMMYYYY(endDate.replaceAll("T", " ")));
		            }} else {
		                jsonObject.put("plantMovementReport", "");
		            }
		            response.getWriter().print(jsonObject.toString());
		        } catch (Exception e) {
		            e.printStackTrace();
		        }
		
	    	}		
		 if(param.equals("getExecutiveDashboardElementsCount")){
			 String customerId = request.getParameter("CustId");
	            try {
					 jsonObject = new JSONObject();
					jsonArray = cargofunc.getExecutiveDashboardElementsCount(systemId, Integer.parseInt(customerId), userId,isLtsp);
					if (jsonArray.length() > 0) {
						jsonObject.put("ExecutiveDashBoardElementCountRoot", jsonArray);
					} else {
						jsonObject.put("ExecutiveDashBoardElementCountRoot", "");
					}
					response.getWriter().print(jsonObject.toString());
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		 
		 if (param.equals("RouteSkeletonsaveormodifyContainer")) {
			 try
			 {
				 String buttonvalue=request.getParameter("buttonvalue");
				 if(buttonvalue.equalsIgnoreCase("add"))
				 {
					 String custmastcomboId=request.getParameter("custID");
					 String cargotripcode=request.getParameter("routeCode");
					 String cargotripnametxt=request.getParameter("routeName");
					 String cargoorgin=request.getParameter("routeOrigin");
					 String cargodestination=request.getParameter("routeDestination");
					 String cargototaltime=request.getParameter("totalTime");
					 String cargoapproxdistance=request.getParameter("approxDistance");
					 String cargoaveragespeed=request.getParameter("averageSpeed");
					 String originarrival=request.getParameter("originArrival");
					 String origindepart=request.getParameter("originDeparture");
					 String destarrival=request.getParameter("destArrival");
					 String destdepart=request.getParameter("destDeparture");	

					 originarrival=(originarrival.replace(':', '.'));
					 origindepart=(origindepart.replace(':', '.'));
					 destarrival=(destarrival.replace(':', '.'));
					 destdepart=(destdepart.replace(':', '.'));

					 int inserResult=0;

					 if(cargofunc.tripNamealreadyexist(custmastcomboId,cargotripnametxt,systemId))
					 {
						 message="Route Name Already Exists";	
					 }
					 else
					 {
						 inserResult=cargofunc.insertrouteskeleton(cargotripcode,cargotripnametxt,cargoorgin,
								 cargodestination,cargototaltime,
								 cargoapproxdistance,custmastcomboId,systemId,userId,cargoaveragespeed,originarrival,origindepart,
								 destarrival,destdepart);
						 if(inserResult>0)
						 {
							 message="Route Skeleton Added Successfully - ";
						 }
						 else
						 {
							 message="Error in Inserting Route Skeleton";	
						 }
					 }
//					 response.getWriter().print(message);


					 int insertdata=0;
					 for(int i=1; i<=10; i++)
					 {
						 String transpoints = request.getParameter("TransPoint"+i);
						 String arrivals = request.getParameter("transpointArrival"+i);
						 String departures = request.getParameter("transpointDeparture"+i);

						 arrivals=(arrivals.replace(':', '.'));
						 departures=(departures.replace(':', '.'));

						 if(transpoints!=null &&  !transpoints.equals("0") && transpoints!="" )
						 {
							 insertdata=cargofunc.insertroutetransitionpoints(inserResult,transpoints,arrivals,departures,i,custmastcomboId,systemId);
						 }
					 }

					 response.getWriter().print(message);

				 }


				 if(buttonvalue.equalsIgnoreCase("modify"))
				 {
					 String custmastcomboId=request.getParameter("custID");
					 String cargotripcode=request.getParameter("routeCode");
					 String cargotripname=request.getParameter("routeName");
					 String cargoorgin=request.getParameter("routeOrigin");
					 String originarrival=request.getParameter("originArrival");
					 String origindepart=request.getParameter("originDeparture");					
					 String cargodestination=request.getParameter("routeDestination");
					 String cargototaltime=request.getParameter("totalTime");
					 String cargoapproxdistance=request.getParameter("approxDistance");
					 String cargoaveragespeed=request.getParameter("averageSpeed");
					 String destarrival=request.getParameter("destArrival");
					 String destdepart=request.getParameter("destDeparture");
					 int routeCode=Integer.parseInt(request.getParameter("routeCodeId"));

					 int delete=cargofunc.deletetranspoints(routeCode,custmastcomboId,systemId);

					 originarrival=(originarrival.replace(':', '.'));
					 origindepart=(origindepart.replace(':', '.'));
					 destarrival=(destarrival.replace(':', '.'));
					 destdepart=(destdepart.replace(':', '.'));

					 int result=cargofunc.updateRouteSkeleton(cargotripcode,cargotripname,cargoorgin,originarrival,origindepart,
							 cargodestination,cargototaltime,cargoapproxdistance,custmastcomboId,systemId,userId,
							 cargoaveragespeed,destarrival,destdepart,routeCode);
					 if(result>0)
					 {
						 message="Route Skeleton Modifyed Successfully  - ";
					 }
					 else
					 {
						 message="Error in Modifying Route Skeleton";	
					 }
//						response.getWriter().print(message);


					 //int delete=cargofunc.deletetranspoints(routeCode,custmastcomboId,systemId);

					 int modifytranspointResult=0;
					 for(int i=1; i<=10; i++)
					 {
						 String transpoints = request.getParameter("TransPoint"+i);
						 String arrivals = request.getParameter("transpointArrival"+i);
						 String departures = request.getParameter("transpointDeparture"+i);

						 arrivals=(arrivals.replace(':', '.'));
						 departures=(departures.replace(':', '.'));

						 if(transpoints!=null &&  !transpoints.equals("0") && transpoints!="" )
						 {
							 modifytranspointResult=cargofunc.insertroutetransitionpoints(routeCode,transpoints,arrivals,departures,i,custmastcomboId,systemId);
						 }
					 }

					 response.getWriter().print(message);
				 }		
			 }
			 catch (Exception e) 
			 {
				 e.printStackTrace();
			 }
			 System.out.println(message);
		 }
		 
		 if (param.equalsIgnoreCase("getRouteSkeletonReport")) {
		        try {
		            String customerId = request.getParameter("custID");

		            jsonArray = new JSONArray();

		            if (customerId != null && !customerId.equals("")) {
		                ArrayList < Object > list1 = cargofunc.getRouteSkeletonReport(systemId, Integer.parseInt(customerId), userId, lang,offset, zone);
		                jsonArray = (JSONArray) list1.get(0);
		                if (jsonArray.length() > 0) {
		                    jsonObject.put("RouteSkeletonRoot", jsonArray);
		                } else {
		                    jsonObject.put("RouteSkeletonRoot", "");
		                }
		                ReportHelper reportHelper = (ReportHelper) list1.get(1);
		                response.getWriter().print(jsonObject.toString());
		            } else {
		                jsonObject.put("RouteSkeletonRoot", "");
		                response.getWriter().print(jsonObject.toString());
		            }

		        } catch (Exception e) {
		            e.printStackTrace();
		        }

		    }
		 
		 else if (param.equalsIgnoreCase("getExecutiveDashBoardDetails")) {
				try
				{
				String customerid=request.getParameter("custID");
				String type=request.getParameter("type");
				String custName=request.getParameter("custName");
				String jspName=request.getParameter("jspName");
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();			
				if (customerid != null) {
					ArrayList<Object> list =cargofunc.getExecutiveDashBoardDetails(Integer.parseInt(customerid),systemId,userId,offset,type,isLtsp);
					jsonArray = (JSONArray) list.get(0);
				if(jsonArray.length()>0)
				{
				jsonObject.put("ExecutiveDashBoardDetailsRoot", jsonArray);
				}
				else
				{
				jsonObject.put("ExecutiveDashBoardDetailsRoot", "");
				}
				ReportHelper reportHelper = (ReportHelper) list.get(1);
				request.getSession().setAttribute(jspName, reportHelper);
				request.getSession().setAttribute("custId", custName);
				response.getWriter().print(jsonObject.toString());
				}
				}
				catch(Exception e)
				{
					
				}
			}
		 else if (param.equalsIgnoreCase("getNTCTripReportGrid")) {
				try
				{
				String jspName=request.getParameter("jspName");
				String cusName=request.getParameter("cusName");
				String cusId =request.getParameter("cusId");
				
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();			
				if ((cusId != null) && (!cusId.equals(""))) {
					ArrayList<Object> list =cargofunc.getNtcTripDetails(systemId,userId,isLtsp,cusName,Integer.parseInt(cusId),offset);
					//jsonArray = (JSONArray) list.get(0);
				if(list.size()>0) 
				{
				jsonArray = (JSONArray) list.get(0);
				jsonObject.put("ntctripreportroot", jsonArray);
				ReportHelper reportHelper = (ReportHelper) list.get(1);
				request.getSession().setAttribute("cusName", cusName);
				request.getSession().setAttribute(jspName, reportHelper);
				response.getWriter().print(jsonObject.toString());
				}
				else
				{
				jsonObject.put("ntctripreportroot", "");
				ReportHelper reportHelper = null;
				request.getSession().setAttribute("cusName", cusName);
				request.getSession().setAttribute(jspName, reportHelper);
				response.getWriter().print(jsonObject.toString());
				}
				
				}
				}
				catch(Exception e)
				{
					e.printStackTrace();
				}
			}
		
		return null;
	}
	
}
