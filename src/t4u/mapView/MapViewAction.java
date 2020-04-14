package t4u.mapView;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Properties;

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
import t4u.common.ApplicationListener;
import t4u.common.DBConnection;
import t4u.functions.CommonFunctions;
import t4u.functions.MapViewFunctions;
import t4u.statements.MapViewStatements;

public class MapViewAction extends Action {
	public ActionForward execute(ActionMapping mapping, ActionForm form,HttpServletRequest request, HttpServletResponse response)throws Exception {
		
		String param = "";
		HttpSession session = request.getSession();
		CommonFunctions cf=new CommonFunctions();
		String serverName=request.getServerName();
		String sessionId = request.getSession().getId();
		LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
		int systemId=0;
		int customerID = 0;	
		int userID=0;
		int offmin=0;
		String lang="";
		int isLtsp=2;
		String zone=null;
		int nonCommHrs=6;
		if(loginInfo!=null)
		{
		systemId = loginInfo.getSystemId();
		customerID = loginInfo.getCustomerId();		
		userID=loginInfo.getUserId();
		offmin=loginInfo.getOffsetMinutes();
		lang=loginInfo.getLanguage();
		isLtsp=loginInfo.getIsLtsp();
		zone=loginInfo.getZone();
		nonCommHrs=loginInfo.getNonCommHrs();
		}
        String typeOfVehicle="All";
		MapViewFunctions mapViewFunc = new MapViewFunctions();
		JSONArray jsonArray = null;
		JSONObject jsonObject = new JSONObject();
		//int prcessId=commonFunctions.getProcessID(systemId, customerID);
		int prcessId=0;
		if (request.getParameter("param") != null) {
			param = request.getParameter("param").toString();
		}
		
		/***************************************************************************************************************************************************
		 * Check session
		 ***************************************************************************************************************************************************/		
		if (param.equalsIgnoreCase("checkSession")) {
			if(loginInfo == null)
			{
				response.getWriter().print("InvalidSession");
			}
			cf.insertDataIntoAuditLogReport(sessionId, null, "Live Vision", "View", userID, serverName, systemId, customerID, "Visited This Page");
		}
		
		/***************************************************************************************************************************************************
		 * User Setting for Live Vision - List View
		 ***************************************************************************************************************************************************/
		if(param.equalsIgnoreCase("addFilter")){
			    int processId=Integer.parseInt(request.getParameter("processId"));
			    jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				String language=request.getParameter("language");
				boolean  checkFDAS=Boolean.parseBoolean(request.getParameter("checkFDAS"));
				int systemid=Integer.parseInt(request.getParameter("systemid"));
			    jsonArray=mapViewFunc.getColumnHeaderBuffer(processId,language,checkFDAS,systemid,userID,customerID);
			    if(jsonArray.length() > 0){
			    	jsonObject.put("columnDetailsRoot",jsonArray);
				}else{
					jsonObject.put("columnDetailsRoot","");
				}	
			    response.getWriter().println(jsonObject.toString());
			    //System.out.println(jsonArray);
				
		}
		if(param.equalsIgnoreCase("updateUserFilter")){
			String msg = "";
			String columnOrderNameVisibility=request.getParameter("order");
			
			msg = mapViewFunc.postColumnDataInTable(customerID,userID, systemId, columnOrderNameVisibility);
			response.getWriter().println(msg.toString());
		}
		if(param.equalsIgnoreCase("resetUserFilter")){
			String msg = "";
			
			msg = mapViewFunc.resetColumnDataInTable(customerID,userID, systemId);
			response.getWriter().println(msg.toString());
			
			
		}
		

		/***************************************************************************************************************************************************
		 * Gets Vehicles for Map View
		 ***************************************************************************************************************************************************/
		if (param.equalsIgnoreCase("getMapViewVehicles")) {
			//System.out.println(" came here for map view !!!!!!!!!!!");
			try {
				String vehicleType = request.getParameter("vehicleType");
				String listOfCustomer ="";
				if(request.getParameter("custNameList")!=null && !request.getParameter("custNameList").equals(""))
				{
					listOfCustomer=request.getParameter("custNameList");
				}
				if(listOfCustomer.equalsIgnoreCase("all")){
					listOfCustomer ="";
				}
				//removing first comma from the string before sending
            	if(!listOfCustomer.equals("") ){
            		listOfCustomer = listOfCustomer.substring(1);
            	}
				typeOfVehicle=vehicleType;
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				jsonArray = mapViewFunc.getMapViewVehicles(vehicleType,listOfCustomer,offmin,userID,customerID,systemId,isLtsp,lang,nonCommHrs);
				if (jsonArray.length() > 0) {
					jsonObject.put("MapViewVehicles", jsonArray);
				} else {
					jsonObject.put("MapViewVehicles", "");
				}
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {

			}
		}
		/***************************************************************************************************************************************************
		 * Gets Vehicles for Map View
		 ***************************************************************************************************************************************************/
		
		if (param.equalsIgnoreCase("getMapViewVehiclesForDMG")) {
			try {
				int CustomerId=Integer.parseInt(request.getParameter("ClientId"));
				int SystemId=Integer.parseInt(request.getParameter("SystemId"));
					jsonArray = new JSONArray();
					jsonObject = new JSONObject();
					jsonArray = mapViewFunc.getMapViewVehiclesForDMG(CustomerId,SystemId);
					if (jsonArray.length() > 0) {
						jsonObject.put("MapViewVehicles", jsonArray);
					} else {
						jsonObject.put("MapViewVehicles", "");
					}
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {

			}
		}
		/***************************************************************************************************************************************************
		 * Gets Vehicles for Map View for Iron Mining
		 ***************************************************************************************************************************************************/
		if (param.equalsIgnoreCase("getIronMiningMapViewVehicles")) {
			try {
				String vehicleType = request.getParameter("vehicleType");
				int customerId=Integer.parseInt(request.getParameter("customerID"));
				String asset=request.getParameter("asset");
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				jsonArray = mapViewFunc.getIronMiningMapViewVehicles(vehicleType,offmin,userID,customerId,systemId,asset);
				if (jsonArray.length() > 0) {
					jsonObject.put("MapViewVehicles", jsonArray);
				} else {
					jsonObject.put("MapViewVehicles", "");
				}
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {

			}
		}
		
		/***************************************************************************************************************************************************
		 * Gets Vehicles for Map View for Taxi
		 ***************************************************************************************************************************************************/
		if (param.equalsIgnoreCase("getTaxiMapViewVehicles")) {
			try {
				String vehicleType = request.getParameter("vehicleType");
				int customerId=Integer.parseInt(request.getParameter("customerID"));
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				jsonArray = mapViewFunc.getTaxiMapViewVehicles(vehicleType,offmin,userID,customerId,systemId,isLtsp);
				if (jsonArray.length() > 0) {
					jsonObject.put("MapViewVehicles", jsonArray);
				} else {
					jsonObject.put("MapViewVehicles", "");
				}
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {

			}
		}
		/***************************************************************************************************************************************************
		 * Gets Customer Landmarks
		 ***************************************************************************************************************************************************/
		if(param.equalsIgnoreCase("getLandmarks")){
			try{
				int customerId=Integer.parseInt(request.getParameter("clientId"));
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				jsonArray = mapViewFunc.getCustomerLandmarks(customerId,systemId,zone);
				if (jsonArray.length() > 0) {
					jsonObject.put("LocationStoreList", jsonArray);
				} else {
					jsonObject.put("LocationStoreList", "");
				}
				
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {

			}
				
			}
		
			if(param.equalsIgnoreCase("getLatLong")){
			try{
				int customerId=Integer.parseInt(request.getParameter("clientId"));
				String name=request.getParameter("names");
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				//String names[]=name.split("- ");
				
				jsonArray = mapViewFunc.getCustomerLandmarksLatLong(customerId,name,systemId,zone);
				if (jsonArray.length() > 0) {
					jsonObject.put("latlongList", jsonArray);
				} else {
					jsonObject.put("latlongList", "");
				}
				
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {

			}
				
			}
		
		
		/***************************************************************************************************************************************************
		 * Gets Buffers for Map View
		 ***************************************************************************************************************************************************/
		if (param.equalsIgnoreCase("getBufferMapView")) {
			try {
				
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				jsonArray = mapViewFunc.getMapViewBuffers(userID,customerID,systemId,zone,isLtsp);
				if (jsonArray.length() > 0) {
					jsonObject.put("BufferMapView", jsonArray);
				} else {
					jsonObject.put("BufferMapView", "");
				}
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {

			}
		}
		
		/***************************************************************************************************************************************************
		 * Gets Buffers of DMG for Map View
		 ***************************************************************************************************************************************************/
		
		if (param.equalsIgnoreCase("getBufferMapViewForDMG")) {
			try {
				int CustomerId=Integer.parseInt(request.getParameter("ClientId"));
				int SystemId=Integer.parseInt(request.getParameter("SystemId"));
						jsonArray = new JSONArray();
						jsonObject = new JSONObject();
						jsonArray = mapViewFunc.getMapViewBuffers(userID,CustomerId,SystemId,"A",isLtsp);
						if (jsonArray.length() > 0) {
							jsonObject.put("BufferMapView", jsonArray);
						} else {
							jsonObject.put("BufferMapView", "");
						}
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {

			}
		}
		
		/***************************************************************************************************************************************************
		 * Gets Polygon for Map View
		 ***************************************************************************************************************************************************/
		if (param.equalsIgnoreCase("getPolygonMapView")) {
			try {
				
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				jsonArray = mapViewFunc.getMapViewPolygons(userID,customerID,systemId,zone,isLtsp);
				if (jsonArray.length() > 0) {
					jsonObject.put("PolygonMapView", jsonArray);
				} else {
					jsonObject.put("PolygonMapView", "");
				}
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {

			}
		}
		/***************************************************************************************************************************************************
		 * Get Service station for Map View
		 ***************************************************************************************************************************************************/
		if (param.equalsIgnoreCase("getServiceStation")) {
			try {
				
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				String assetMake="";
				int groupId=0;
				if(request.getParameter("assetMake") != null && !request.getParameter("assetMake").equals("")){
					assetMake = request.getParameter("assetMake");
				}
				if(request.getParameter("groupId") != null && !request.getParameter("groupId").equals("")){
					groupId = Integer.parseInt(request.getParameter("groupId"));
				}
				jsonArray = mapViewFunc.getServiceStation(customerID,systemId,zone,assetMake,groupId);
				if (jsonArray.length() > 0) {
					jsonObject.put("serviceStationRoot", jsonArray);
				} else {
					jsonObject.put("serviceStationRoot", "");
				}
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {

			}
		}
		/***************************************************************************************************************************************************
		 * Gets Border for Map View
		 ***************************************************************************************************************************************************/
		if (param.equalsIgnoreCase("getBorderForMapView")) {
			try {				
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				jsonArray = mapViewFunc.getMapViewBorders(customerID,systemId,zone);
				if (jsonArray.length() > 0) {
					jsonObject.put("borderMapView", jsonArray);
				} else {
					jsonObject.put("borderMapView", "");
				}
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {

			}
		}
		
		/***************************************************************************************************************************************************
		 * Gets Polygon of DMG for Map View
		 ***************************************************************************************************************************************************/
		
		
		if (param.equalsIgnoreCase("getPolygonMapViewForDMG")) {
			try {				
			       int CustomerId=Integer.parseInt(request.getParameter("ClientId"));
				   int SystemId=Integer.parseInt(request.getParameter("SystemId"));
						jsonArray = new JSONArray();
						jsonObject = new JSONObject();
						jsonArray = mapViewFunc.getMapViewPolygons(userID,CustomerId,SystemId,"A",isLtsp);
						if (jsonArray.length() > 0) {
							jsonObject.put("PolygonMapView", jsonArray);
						} else {
							jsonObject.put("PolygonMapView", "");
						}
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {

			}
		}
		
		
		/***************************************************************************************************************************************************
		 * Gets Vehicle Details for Map View
		 ***************************************************************************************************************************************************/
		if (param.equalsIgnoreCase("getMapViewVehicleDetails")) {
			try {				
				String vehicleNo = request.getParameter("vehicleNo");
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				jsonArray = mapViewFunc.getMapViewVehiclesDetails(vehicleNo,offmin,userID,customerID,systemId);
				if (jsonArray.length() > 0) {
					jsonObject.put("MapViewVehicleDetails", jsonArray);
				} else {
					jsonObject.put("MapViewVehicleDetails", "");
				}
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {

			}
		}
		
		
		/***************************************************************************************************************************************************
		 * Gets Vehicle Details of DMG for Map View
		 ***************************************************************************************************************************************************/
		
		if (param.equalsIgnoreCase("getDMGMapViewVehicleDetails")) {
			try {
				String vehicleNo = request.getParameter("vehicleNo");
				int CustomerId=Integer.parseInt(request.getParameter("ClientId"));
				int SystemId=Integer.parseInt(request.getParameter("SystemId"));
					jsonArray = new JSONArray();
					jsonObject = new JSONObject();
					jsonArray = mapViewFunc.getDMGMapViewVehiclesDetails(vehicleNo,CustomerId,SystemId);
					if (jsonArray.length() > 0) {
						jsonObject.put("MapViewVehicleDetails", jsonArray);
					} else {
						jsonObject.put("MapViewVehicleDetails", "");
					}
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {

			}
		}
		
		/***************************************************************************************************************************************************
		 * Gets Vehicle Details of DMG for Map View
		 ***************************************************************************************************************************************************/
		
		
		if (param.equalsIgnoreCase("getTripDetails")) {
			try {
				String vehicleNo = request.getParameter("vehicleNo");
				int CustomerId=Integer.parseInt(request.getParameter("ClientId"));
			    int SystemId=Integer.parseInt(request.getParameter("SystemId"));
					jsonArray = new JSONArray();
					jsonObject = new JSONObject();
					jsonArray = mapViewFunc.getDMGTripDetails(vehicleNo,CustomerId,SystemId);
					if (jsonArray.length() > 0) {
						jsonObject.put("tripDetails", jsonArray);
					} else {
						jsonObject.put("tripDetails", "");
					}
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {

			}
		}
		
		
		/***************************************************************************************************************************************************
		 * Get Cash Van Vehicle Details for Map View
		 ***************************************************************************************************************************************************/
		if (param.equalsIgnoreCase("getCashVanMapViewVehicleDetails")) {
			try {
				String vehicleNo = request.getParameter("vehicleNo");
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				String processId = request.getParameter("processID");
				jsonArray = mapViewFunc.getMapCashVanViewVehiclesDetails(vehicleNo,offmin,userID,customerID,systemId,lang,isLtsp,processId);
				if (jsonArray.length() > 0) {
					jsonObject.put("MapViewVehicleDetails", jsonArray);
				} else {
					jsonObject.put("MapViewVehicleDetails", "");
				}
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {

			}
		}
		
		/***************************************************************************************************************************************************
		 * Generic Live Vision List View 
		 ***************************************************************************************************************************************************/
		
		if (param.equalsIgnoreCase("getLiveVisionVehicleDetails") && (loginInfo != null)) {
			try {
				String category=null;
				boolean checkFDAS = false;			
				String typeOfVehicles="";
				String listOfCustomer = "";
				if(request.getParameter("vehicleType")!=null && !request.getParameter("vehicleType").equals(""))
				{
					typeOfVehicles=request.getParameter("vehicleType");
				}
				if(request.getParameter("custNameList")!=null && !request.getParameter("custNameList").equals(""))
				{
					listOfCustomer=request.getParameter("custNameList");
				}
				
				System.out.println("listOfCustomer"+listOfCustomer);
				if(listOfCustomer.equalsIgnoreCase("all")){
					listOfCustomer ="";
				}
				
				String jspName = request.getParameter("jspName");
				String CustName = request.getParameter("custName");
				if(request.getParameter("processID")!=null && !request.getParameter("processID").equals(""))
				prcessId=Integer.parseInt(request.getParameter("processID"));
				String custNamee="";
				if(request.getParameter("category")!=null)
				{
					category=request.getParameter("category");
				}
				if(request.getParameter("checkFDAS")!=null){					
					checkFDAS=Boolean.parseBoolean(request.getParameter("checkFDAS"));
				}
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();				
	                try {
	                		//removing first comma from the string before sending
	                	if(!listOfCustomer.equals("") ){
	                		listOfCustomer = listOfCustomer.substring(1);
	                	}
	                		
	                        ArrayList < Object > list = mapViewFunc.getLiveVisionListVehiclesDetails(offmin,userID,customerID,systemId,lang,typeOfVehicles,listOfCustomer,prcessId,isLtsp,category,checkFDAS,nonCommHrs);
	                    	jsonArray = (JSONArray) list.get(0);
	                    	if (jsonArray.length() > 0) {
	        					jsonObject.put("cashVanListDetailsRoot", jsonArray);
	        				} else {
	        					jsonObject.put("cashVanListDetailsRoot", "");
	        				}
	                    	if(CustName!=null)
	                    	 custNamee=CustName;
	                    	 ReportHelper reportHelper = (ReportHelper) list.get(1);
	    	                 request.getSession().setAttribute(jspName, reportHelper);
	    	                 request.getSession().setAttribute("custId", custNamee);
	                    
	                } catch (Exception e) {
	                    e.printStackTrace(); }
				
	                response.getWriter().print(jsonObject.toString());
			}
			catch (Exception e) {
				e.printStackTrace();
			}
		}
		
		/***************************************************************************************************************************************************
		 * Add Remarks in List View Cash Van management
		 ***************************************************************************************************************************************************/
		
		if (param.equalsIgnoreCase("AddRemarks")) {
			try {
				String vehicleNo = request.getParameter("selectdName");
				String remarks=request.getParameter("hubID");
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				String msg="";
				msg = mapViewFunc.AddRemarks(vehicleNo,systemId,remarks);
			    response.getWriter().print(msg);
			} catch (Exception e) {
                e.printStackTrace();
			}
		}
		
		
		/***************************************************************************************************************************************************
		 * Get Iron Mining Details Details for Map View
		 ***************************************************************************************************************************************************/
		if (param.equalsIgnoreCase("getIronMiningMapViewVehicleDetails")) {
			try {
				String vehicleNo = request.getParameter("vehicleNo");
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				jsonArray = mapViewFunc.getIronMiningMapViewVehiclesDetails(vehicleNo,offmin,userID,customerID,systemId);
				if (jsonArray.length() > 0) {
					jsonObject.put("MapViewVehicleDetails", jsonArray);
				} else {
					jsonObject.put("MapViewVehicleDetails", "");
				}
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {

			}
		}
		
		
		if(param.equalsIgnoreCase("getIronMiningMapViewCommStatus")){
			try {
				int customerId=0;
				String vehicleNo = request.getParameter("vehicleNo");
				if(request.getParameter("customerID")!=null && request.getParameter("customerID")!="")
				{
				customerId=Integer.parseInt(request.getParameter("customerID"));
				}
				else
				{customerId=loginInfo.getCustomerId();
				}
				jsonObject = new JSONObject();
				jsonArray = mapViewFunc.getIronMiningNonCommStatus(vehicleNo,offmin,userID,customerId,systemId);
				if (jsonArray.length() > 0) {
					jsonObject.put("MapViewCommStatus", jsonArray);
				} else {
					jsonObject.put("MapViewCommStatus", "");
				}
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {

			}
		}
		
		if(param.equalsIgnoreCase("getIronMiningHistoryData")){
			try {
				String vehicleNo = request.getParameter("vehicleNo");
				int customerId=Integer.parseInt(request.getParameter("customerID"));
				String lastCommTime=request.getParameter("lastcommtime");
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				jsonArray = mapViewFunc.getHistoryData(vehicleNo,offmin,userID,customerId,systemId,lastCommTime);
				if (jsonArray.length() > 0) {
					jsonObject.put("MapViewHistoryData", jsonArray);
				} else {
					jsonObject.put("MapViewHistoryData", "");
				}
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {

			}
		}
		
		/***************************************************************************************************************************************************
		 * Get Vehicle Details for MLL ECOMMERCE Map View
		 ***************************************************************************************************************************************************/
			
		if (param.equalsIgnoreCase("getVehicleForMLLECommerce")) {
			try {				
				String str = request.getParameter("vehicleNo");
				StringBuilder str1 = new StringBuilder("'"+str);
				StringBuilder str2 = new StringBuilder(str1.toString().replaceAll(",", "','"));
				String Vehicles = str2.append("'").toString();
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				jsonArray = mapViewFunc.getVehicleForMLLECommerce(Vehicles);
				if (jsonArray.length() > 0) {
					jsonObject.put("MapViewVehicles", jsonArray);
				} else {
					jsonObject.put("MapViewVehicles", "");
				}
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {

			}
		}
		
        else if (param.equals("getConsignmentDetails")) {
            try {
                String conNo = request.getParameter("conNo").toUpperCase();
                jsonArray = new JSONArray();
                jsonObject = new JSONObject();
               String Ip = request.getRemoteAddr();
               String remoteHost = request.getRemoteHost();
               jsonArray = mapViewFunc.getConsignmentDetails(conNo,systemId,Ip,remoteHost);
                     if (jsonArray.length() > 0) {
                        jsonObject.put("DetailsStoreRoot", jsonArray);
                    } else {
                        jsonObject.put("DetailsStoreRoot", "");
                    }
                    response.getWriter().print(jsonObject.toString());
            } catch (Exception e) {
                e.printStackTrace();
            }
        } 	
/***************************************CONSIGNMENT DASHBOARD******************************************************************************************************************/		
		
        else if (param.equals("getConsignmentDetailsForDashBoard")) {
            try {
                jsonArray = new JSONArray();
                jsonObject = new JSONObject();
                String consignmentStatus = request.getParameter("status"); //load,return load
                String custId = request.getParameter("custId");
                String region = request.getParameter("region");
                String bookingCustomer = request.getParameter("bookingCustomerId");
                if(bookingCustomer.equals("0"))
                {
                	bookingCustomer="ALL";
                }
                
                if(custId.equals("ALL"))
                {
                	custId="0";
                }
                if (custId != null && !custId.equals("") && region != null && !region.equals("") && consignmentStatus != null && !consignmentStatus.equals("")) {
                    jsonArray = mapViewFunc.getConsignmentDetailsForDashBoard(systemId, Integer.parseInt(custId), consignmentStatus, region,userID,bookingCustomer);
                    if (jsonArray.length() > 0) {
                        jsonObject.put("DetailsStoreRootConsignmentDashBoard", jsonArray);
                    } else {
                        jsonObject.put("DetailsStoreRootConsignmentDashBoard", "");
                    }
                }else {
                    jsonObject.put("DetailsStoreRootConsignmentDashBoard", "");
                 }
                response.getWriter().print(jsonObject.toString());
            } catch (Exception e) {
                e.printStackTrace();
            }
        } 
        
        else if (param.equals("getConsignmentSummaryDetails")) {
            try {
                jsonArray = new JSONArray();
                jsonObject = new JSONObject();
                String jspName=request.getParameter("jspName");
                String customerName=request.getParameter("customerName");
                String custId = request.getParameter("clientID");
                String region = request.getParameter("region");
                String consignmentStatus = request.getParameter("consignmentStatus");
                String fieldCondition = request.getParameter("fieldCondition");
                String bookingCustomer = request.getParameter("bookingCustomerId");
                String bookingCustomerNameRawValue = request.getParameter("bookingCustomerNameRawValue");
                String TotalRegion = request.getParameter("TotalRegion");
                if(bookingCustomer.equals("0"))
                {
                	bookingCustomer="ALL";
                }
               
                if(TotalRegion.equals("0"))
                {
                	TotalRegion="ALL";
                }
                
                if(custId.equals("ALL"))
                {
                	custId="0";
                }
                
                ArrayList < Object > list1 = mapViewFunc.getConsignmentSummaryDetails(systemId, Integer.parseInt(custId), consignmentStatus, region, fieldCondition,userID, lang,bookingCustomer,TotalRegion);
                jsonArray = (JSONArray) list1.get(0);
                if (jsonArray.length() > 0) {
                    jsonObject.put("consignmentSummaryDetailsRoot", jsonArray);
                } else {
                    jsonObject.put("consignmentSummaryDetailsRoot", "");
                }
                ReportHelper reportHelper = (ReportHelper) list1.get(1);
                request.getSession().setAttribute(jspName, reportHelper);
                request.getSession().setAttribute("custId", customerName);
                request.getSession().setAttribute("region",region);
                request.getSession().setAttribute("consignmentStatus",consignmentStatus);
                request.getSession().setAttribute("bookingCustomer",bookingCustomerNameRawValue);

                if(consignmentStatus.equals("EastFieldBox"))
                {
                 	request.getSession().setAttribute("fieldCondition","Dealers" );
                }else
                {
                	request.getSession().setAttribute("fieldCondition",fieldCondition );
                }

                response.getWriter().print(jsonObject.toString());
            } catch (Exception e) {
                e.printStackTrace();
            }

        }
        else if (param.equals("getConsignmentDetailsForDashBoardTable")) {
            try {
                jsonArray = new JSONArray();
                jsonObject = new JSONObject();
                String custId = request.getParameter("custId");
                String region = request.getParameter("region");
                String bookingCustomer = request.getParameter("bookingCustomerId");
                if(custId.equals("ALL"))
                {
                	custId="0";
                }
                
                
                if(bookingCustomer.equals("0"))
                {
                	bookingCustomer="ALL";
                }
                if (custId != null && !custId.equals("") && region != null && !region.equals("")) {
                    jsonArray = mapViewFunc.getConsignmentDetailsForDashBoardTable(systemId, Integer.parseInt(custId), region,bookingCustomer);
                    if (jsonArray.length() > 0) {
                        jsonObject.put("DashBoardTableRoot", jsonArray);
                    } else {
                        jsonObject.put("DashBoardTableRoot", "");
                    }
                }else {
                    jsonObject.put("DashBoardTableRoot", "");
                }
                response.getWriter().print(jsonObject.toString());
            } catch (Exception e) {
                e.printStackTrace();
            }
        } 
        
        else if (param.equals("getCountForBoxes")) {
            try {
                jsonArray = new JSONArray();
                jsonObject = new JSONObject();
                String custId = request.getParameter("custId");
                String region = request.getParameter("region");
                String bookingCustomer = request.getParameter("bookingCustomerId");
                String transporter = request.getParameter("transporter");
                if(bookingCustomer.equals("0"))
                {
                	bookingCustomer="ALL";
                }
                if(custId.equals("ALL"))
                {
                	custId="0";
                }
                if (custId != null && !custId.equals("") && region != null && !region.equals("")) {
                    jsonArray = mapViewFunc.getCountForBoxes(systemId, Integer.parseInt(custId), region,userID,bookingCustomer,transporter);
                    if (jsonArray.length() > 0) {
                        jsonObject.put("boxesStoreRoot", jsonArray);
                    } else {
                        jsonObject.put("boxesStoreRoot", "");
                    }
                }else {
                    jsonObject.put("boxesStoreRoot", "");
                }
                response.getWriter().print(jsonObject.toString());
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
		
        else if (param.equals("getGroups")) {
            int clientId = 0;
            String customerId = request.getParameter("CustId");
            if (customerId != null) {
                clientId = Integer.parseInt(customerId);
            }
            jsonArray = mapViewFunc.getGroupNameList(systemId, clientId, userID);
            try {
                if (jsonArray != null) {
                    jsonObject.put("groupNameList", jsonArray);
                } else {
                    jsonObject.put("groupNameList", "");
                }
                response.getWriter().print(jsonObject.toString());
            } catch (Exception e) {
                e.printStackTrace();
            }
        } 
		
        else if (param.equals("getBookingCustomer")) {
            int clientId = 0;
            String customerId = request.getParameter("CustId");
            String region = request.getParameter("region");
            if (customerId != null && !customerId.equals("")) {
                clientId = Integer.parseInt(customerId);
            }
            jsonArray = mapViewFunc.getBookingCustomer(systemId, clientId, region);
            try {
                if (jsonArray != null) {
                    jsonObject.put("bookingCustomerRoot", jsonArray);
                } else {
                    jsonObject.put("bookingCustomerRoot", "");
                }
                response.getWriter().print(jsonObject.toString());
            } catch (Exception e) {
                e.printStackTrace();
            }
        } 

/**********************************************************************************************************************************************************************************/
        else if (param.equalsIgnoreCase("bookingCustomerAddAndModify")) {
	        try {
	            String buttonValue = request.getParameter("buttonValue");
	        	String custId = request.getParameter("custId");
	        	String customerId=request.getParameter("customerId");
	        	String name = request.getParameter("name");
	        	String email = request.getParameter("email");
	        	String phone = request.getParameter("phone");
	        	String mobile = request.getParameter("mobile");
	        	String fax = request.getParameter("fax");
	        	String tin = request.getParameter("tin");
	        	String address = request.getParameter("address");
	        	String city = request.getParameter("city");
	        	String userName = request.getParameter("usernameId");
	        	String password = request.getParameter("password");
	        	String state = request.getParameter("state");
	        	String region = request.getParameter("region");
	        	String status = request.getParameter("status");
	        	String uniqueId = request.getParameter("id");
	        	String selectedCustomerId = request.getParameter("selectedCustomerId");
	        	String selectedCustomerName = request.getParameter("selectedCustomerName");
	        	String selectedEmail = request.getParameter("selectedEmail");
	        	String selectedPhoneNo = request.getParameter("selectedPhoneNo");
	        	String selectedMobileNo = request.getParameter("selectedMobileNo");
	        	String selectedFax = request.getParameter("selectedFax");
	        	String selectedTin = request.getParameter("selectedTin");
	        	String selectedAddress = request.getParameter("selectedAddress");
	        	String selectedCity = request.getParameter("selectedCity");
	        	String selectedState = request.getParameter("selectedState");
	        	String selectedRegion = request.getParameter("selectedRegion");
	        	String selectedStatus = request.getParameter("selectedStatus");
	        	String selectedUserName  = request.getParameter("selectedUserName");
	        	String selectedPassword  = request.getParameter("selectedPassword");

	        	
	            String message="";
	            if (buttonValue.equals("Add") && custId != null && !custId.equals("")) {
	                message = mapViewFunc.insertCustomerInformation(Integer.parseInt(custId),customerId,name,email,phone,mobile,fax,tin,address,city,userName,password,state,region,status,userID,systemId);
	            } else if (buttonValue.equals("Modify") && custId != null && !custId.equals("")) {
	            	       message = mapViewFunc.modifyCustomerInformation(Integer.parseInt(custId),selectedCustomerId,selectedCustomerName,selectedEmail,selectedPhoneNo,selectedMobileNo,
	            	    		   selectedFax,selectedTin,selectedAddress,selectedCity,selectedUserName,selectedPassword,selectedState,selectedRegion,selectedStatus,systemId,Integer.parseInt(uniqueId),userID);
	            }
	            response.getWriter().print(message);
	        } catch (Exception e) {
	            e.printStackTrace();
	        }
	    }
		
        else if (param.equalsIgnoreCase("getBookingCustomerReport")) {
	        try {
	            String custId = request.getParameter("CustId");
	             jsonArray = new JSONArray();
	            if (custId != null && !custId.equals("")) {
	                ArrayList < Object > list1 = mapViewFunc.getBookingCustomerReport(Integer.parseInt(custId),systemId,userID);
	                jsonArray = (JSONArray) list1.get(0);
	                if (jsonArray.length() > 0) {
	                    jsonObject.put("bookingCustomerRoot", jsonArray);
	                } else {
	                    jsonObject.put("bookingCustomerRoot", "");
	                }
		         	response.getWriter().print(jsonObject.toString());
	            } else {
	                jsonObject.put("bookingCustomerRoot", "");
	                response.getWriter().print(jsonObject.toString());
	            }
	        } catch (Exception e) {
	            e.printStackTrace();
	        }
	    }
		
        else if (param.equals("getCustomer")) {
			try {
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				String ltsp = "no";
				Properties properties = null;
				properties = ApplicationListener.prop;
				String  LtspIdForNissan = properties.getProperty("LtspIdForConsignment");	
				if (request.getParameter("paramforltsp") != null) {
					ltsp = request.getParameter("paramforltsp").toString();
				}
				jsonArray = mapViewFunc.getCustomer(systemId, ltsp,customerID,LtspIdForNissan,isLtsp);
				if (jsonArray.length() > 0) {
					jsonObject.put("CustomerRoot", jsonArray);
				} else {
					jsonObject.put("CustomerRoot", "");
				}
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {
				System.out.println("Error in Common Action:-getCustomer "
						+ e.toString());
			}
		}
		
		
        else if (param.equals("getCustomersForDashBoard")) {
			try {
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				String ltsp = "no";
				Properties properties = null;
				properties = ApplicationListener.prop;
				String  LtspIdForNissan = properties.getProperty("LtspIdForConsignment");	
				if (request.getParameter("paramforltsp") != null) {
					ltsp = request.getParameter("paramforltsp").toString();
				}
				jsonArray = mapViewFunc.getCustomersForDashBoard(systemId, ltsp,customerID,LtspIdForNissan,isLtsp);
				if (jsonArray.length() > 0) {
					jsonObject.put("CustomerRoot", jsonArray);
				} else {
					jsonObject.put("CustomerRoot", "");
				}
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {
				System.out.println("Error in Common Action:-getCustomer "
						+ e.toString());
			}
		}
		
		/*************************************************Container cargo management map view************************************************/
		
        else if(param.equals("getContainerCargoDetails")){
        	String containerNo = request.getParameter("conNo");
        	String bookingNo = request.getParameter("bookingNo");
        	String iP = request.getRemoteAddr();
        	String remostHost = request.getRemoteHost();
        	
        	jsonArray = mapViewFunc.getContainerCargoManagementDetails(systemId, containerNo, iP, remostHost, bookingNo, customerID);
        	if(jsonArray.length() > 0){
        		jsonObject.put("DetailsStoreRoot", jsonArray);
        	} else {
        		jsonObject.put("DetailsStoreRoot", "");
        	}
        		response.getWriter().print(jsonObject.toString());
        	
        }
		/******************************************** For Ola MapView **************************************/
        else if(param.equals("getVehicleList")){
        	jsonArray = new JSONArray();
			jsonObject = new JSONObject();
			String typeOfVehicles = "all";
			if(request.getParameter("vehicleType")!=null && !request.getParameter("vehicleType").equals("")){
				typeOfVehicles = request.getParameter("vehicleType");
			}
			jsonArray = mapViewFunc.getVehicleList(typeOfVehicles,offmin,userID,customerID,systemId,isLtsp,lang,nonCommHrs);
			if (jsonArray.length() > 0) {
				jsonObject.put("vehicleListRoot", jsonArray);
			} else {
				jsonObject.put("vehicleListRoot", "");
			}
			response.getWriter().print(jsonObject.toString());
        }
        else if(param.equals("getOlaMapViewVehicles")){
        	String vehicleType = request.getParameter("vehicleType");
        	jsonArray = new JSONArray();
			jsonObject = new JSONObject();
			StringBuffer sbuffer = new StringBuffer();
        	if(request.getParameter("vehicleNoList") != null && !request.getParameter("vehicleNoList").equals("")){
        		String vehicleNoList = request.getParameter("vehicleNoList");
	        	String[] regList = vehicleNoList.split(",");
	        	int count = 0;
	        	for (int i = 0; i < regList.length; i++) {
	        		String str = regList[i];
					if(count == 0){
						sbuffer.append("'"+str+"'");
						count = 1;
					}else{
						sbuffer.append(",'"+str+"'");
					}
				}
        	}
        	String finalVehicleList = sbuffer.toString();
        	if(finalVehicleList.equals("")){
        		finalVehicleList = "''";
        	}
			jsonArray = mapViewFunc.getOlaMapViewVehicles(vehicleType,offmin,userID,customerID,systemId,isLtsp,lang,finalVehicleList);
			if (jsonArray.length() > 0) {
				jsonObject.put("MapViewVehicles", jsonArray);
			} else {
				jsonObject.put("MapViewVehicles", "");
			}
			response.getWriter().print(jsonObject.toString());
        }
        return null;
      }
  }
