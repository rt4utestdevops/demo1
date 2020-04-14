package t4u.cashvanmanagement;

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
import t4u.functions.CashVanManagementFunctions;
import t4u.functions.CommonFunctions;

public class CMSDashBoardAction extends Action{
	public ActionForward execute(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
        HttpSession session = request.getSession();
        String param = "";
        String zone = "";
        int systemId = 0;
        int userId = 0;
        int offset = 0;
    	SimpleDateFormat ddmmyyyy = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
    	SimpleDateFormat yyyymmdd = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
        systemId = loginInfo.getSystemId();
        zone = loginInfo.getZone();
        userId = loginInfo.getUserId();
        offset = loginInfo.getOffsetMinutes();
        String lang = loginInfo.getLanguage();
        zone = loginInfo.getZone();
        CashVanManagementFunctions cvmf=new CashVanManagementFunctions();
        JSONArray jsonArray = null;
        JSONObject jsonObject = new JSONObject();
        if (request.getParameter("param") != null) {
            param = request.getParameter("param").toString();
        }
     	 if (param.equalsIgnoreCase("getcustomer")) {
       	     try {
       	         String custID = request.getParameter("CustId");
       	         jsonArray = new JSONArray();
       	         if (custID != null && !custID.equals("")) {
       	             jsonArray = cvmf.getCustomer(Integer.parseInt(custID), systemId);
       	             if (jsonArray.length() > 0) {
       	                 jsonObject.put("customerRoot", jsonArray);
       	             } else {
       	                 jsonObject.put("customerRoot", "");
       	             }
       	             response.getWriter().print(jsonObject.toString());
       	         } else {
       	             jsonObject.put("customerRoot", "");
       	             response.getWriter().print(jsonObject.toString());
       	         }
       	     } catch (Exception e) {
       	         e.printStackTrace();
       	     }
       	 } 
        
     	 else if (param.equalsIgnoreCase("getRegion")) {
       	     try {
       	         String custID = request.getParameter("custId");
       	         jsonArray = new JSONArray();
       	         if (custID != null && !custID.equals("")) {
       	             jsonArray = cvmf.getRegion(Integer.parseInt(custID), systemId);
       	             if (jsonArray.length() > 0) {
       	                 jsonObject.put("regionRoot", jsonArray);
       	             } else {
       	                 jsonObject.put("regionRoot", "");
       	             }
       	             response.getWriter().print(jsonObject.toString());
       	         } else {
       	             jsonObject.put("regionRoot", "");
       	             response.getWriter().print(jsonObject.toString());
       	         }
       	     } catch (Exception e) {
       	         e.printStackTrace();
       	     }
       	 } 
      	 
      	 else if (param.equalsIgnoreCase("getLocation")) {
       	     try {
       	         String custID = request.getParameter("custId");
       	         String region = request.getParameter("regionId");
       	         jsonArray = new JSONArray();
       	         if (custID != null && !custID.equals("")) {
       	             jsonArray = cvmf.getLocation(Integer.parseInt(custID), systemId, region);
       	             if (jsonArray.length() > 0) {
       	                 jsonObject.put("locationRoot", jsonArray);
       	             } else {
       	                 jsonObject.put("locationRoot", "");
       	             }
       	             response.getWriter().print(jsonObject.toString());
       	         } else {
       	             jsonObject.put("locationRoot", "");
       	             response.getWriter().print(jsonObject.toString());
       	         }
       	     } catch (Exception e) {
       	         e.printStackTrace();
       	     }
       	 } 
      	 
      	 else if (param.equalsIgnoreCase("getHub")) {
       	     try {
       	         String custID = request.getParameter("custId");
       	         String region = request.getParameter("regionId");
       	         String location = request.getParameter("locationId");
       	         jsonArray = new JSONArray();
       	         if (custID != null && !custID.equals("")) {
       	             jsonArray = cvmf.getHub(Integer.parseInt(custID), systemId, region, location);
       	             if (jsonArray.length() > 0) {
       	                 jsonObject.put("hubRoot", jsonArray);
       	             } else {
       	                 jsonObject.put("hubRoot", "");
       	             }
       	             response.getWriter().print(jsonObject.toString());
       	         } else {
       	             jsonObject.put("hubRoot", "");
       	             response.getWriter().print(jsonObject.toString());
       	         }
       	     } catch (Exception e) {
       	         e.printStackTrace();
       	     }
       	 } 
      	 
      	else if (param.equalsIgnoreCase("getHubDel")) {
      	     try {
      	         String custID = request.getParameter("custId");
      	         String tripNo = request.getParameter("tripNo");
      	         jsonArray = new JSONArray();
      	         if (custID != null && !custID.equals("")) {
      	             jsonArray = cvmf.getHubDel(Integer.parseInt(custID), systemId, tripNo);
      	             if (jsonArray.length() > 0) {
      	                 jsonObject.put("hubDelRoot", jsonArray);
      	             } else {
      	                 jsonObject.put("hubDelRoot", "");
      	             }
      	             response.getWriter().print(jsonObject.toString());
      	         } else {
      	             jsonObject.put("hubDelRoot", "");
      	             response.getWriter().print(jsonObject.toString());
      	         }
      	     } catch (Exception e) {
      	         e.printStackTrace();
      	     }
      	 }
      	 
      	 else if (param.equalsIgnoreCase("getRoute")) {
       	     try {
       	         String custID = request.getParameter("custId");
       	        // String region = request.getParameter("regionId");
       	        // String location = request.getParameter("locationId");
       	         jsonArray = new JSONArray();
       	         if (custID != null && !custID.equals("")) {
       	             jsonArray = cvmf.getRoute(Integer.parseInt(custID), systemId);
       	             if (jsonArray.length() > 0) {
       	                 jsonObject.put("routeRoot", jsonArray);
       	             } else {
       	                 jsonObject.put("routeRoot", "");
       	             }
       	             response.getWriter().print(jsonObject.toString());
       	         } else {
       	             jsonObject.put("routeRoot", "");
       	             response.getWriter().print(jsonObject.toString());
       	         }
       	     } catch (Exception e) {
       	         e.printStackTrace();
       	     }
       	 } 
      	 else if (param.equalsIgnoreCase("getTripSheetNo")) {
       	     try {
       	         String custID = request.getParameter("custId");
       	       String routeId= request.getParameter("routeId");
              String date = request.getParameter("date");
              date=date.replace("T", " ");
       	        // String region = request.getParameter("regionId");
       	        // String location = request.getParameter("locationId");
       	         jsonArray = new JSONArray();
       	         if (custID != null && !custID.equals("") && routeId != null && !routeId.equals("") ) {
       	             jsonArray = cvmf.getTripSheetNo(Integer.parseInt(custID), systemId,Integer.parseInt(routeId),date);
       	             if (jsonArray.length() > 0) {
       	                 jsonObject.put("TripSheetNoRoot", jsonArray);
       	             } else {
       	                 jsonObject.put("TripSheetNoRoot", "");
       	             }
       	             response.getWriter().print(jsonObject.toString());
       	         } else {
       	             jsonObject.put("TripSheetNoRoot", "");
       	             response.getWriter().print(jsonObject.toString());
       	         }
       	     } catch (Exception e) {
       	         e.printStackTrace();
       	     }
       	 }
     	 
     	
      	 else if (param.equalsIgnoreCase("getATM")) {
       	     try {
       	         String custID = request.getParameter("custId");
       	         String tripSheetNo = request.getParameter("tripSheetNo");
       	      //String region = request.getParameter("region");
       	         jsonArray = new JSONArray();
       	         if (custID != null && !custID.equals("")) {
       	             jsonArray = cvmf.getATM(Integer.parseInt(custID), systemId, tripSheetNo);
       	             if (jsonArray.length() > 0) {
       	                 jsonObject.put("atmRoot", jsonArray);
       	             } else {
       	                 jsonObject.put("atmRoot", "");
       	             }
       	             response.getWriter().print(jsonObject.toString());
       	         } else {
       	             jsonObject.put("atmRoot", "");
       	             response.getWriter().print(jsonObject.toString());
       	         }
       	     } catch (Exception e) {
       	         e.printStackTrace();
       	     }
       	 }
      	 
      	 else if (param.equalsIgnoreCase("getCustoName")) {
       	     try {
       	         String custID = request.getParameter("custId");
       	         String route = request.getParameter("routeId");
       	         jsonArray = new JSONArray();
       	         if (custID != null && !custID.equals("")) {
       	             jsonArray = cvmf.getCustoName(Integer.parseInt(custID), systemId, route);
       	             if (jsonArray.length() > 0) {
       	                 jsonObject.put("custoNameRoot", jsonArray);
       	             } else {
       	                 jsonObject.put("custoNameRoot", "");
       	             }
       	             response.getWriter().print(jsonObject.toString());
       	         } else {
       	             jsonObject.put("custoNameRoot", "");
       	             response.getWriter().print(jsonObject.toString());
       	         }
       	     } catch (Exception e) {
       	         e.printStackTrace();
       	     }
       	 } 
      	else if (param.equalsIgnoreCase("getCustodianName")) {
      	     try {
      	         String custID = request.getParameter("custId");
      	         jsonArray = new JSONArray();
      	         if (custID != null && !custID.equals("")) {
      	             jsonArray = cvmf.getCustodianName(Integer.parseInt(custID), systemId, offset);
      	             if (jsonArray.length() > 0) {
      	                 jsonObject.put("custodianNameRoot", jsonArray);
      	             } else {
      	                 jsonObject.put("custodianNameRoot", "");
      	             }
      	             response.getWriter().print(jsonObject.toString());
      	         } else {
      	             jsonObject.put("custodianNameRoot", "");
      	             response.getWriter().print(jsonObject.toString());
      	         }
      	     } catch (Exception e) {
      	         e.printStackTrace();
      	     }
      	 }
      	 else if (param.equalsIgnoreCase("getVehicleNo")) {
       	     try {
       	         String custID = request.getParameter("custId");
       	         jsonArray = new JSONArray();
       	         if (custID != null && !custID.equals("")) {
       	             jsonArray = cvmf.getVehicleNo(Integer.parseInt(custID), systemId, userId, offset);
       	             if (jsonArray.length() > 0) {
       	                 jsonObject.put("vehicleNoRoot", jsonArray);
       	             } else {
       	                 jsonObject.put("vehicleNoRoot", "");
       	             }
       	             response.getWriter().print(jsonObject.toString());
       	         } else {
       	             jsonObject.put("vehicleNoRoot", "");
       	             response.getWriter().print(jsonObject.toString());
       	         }
       	     } catch (Exception e) {
       	         e.printStackTrace();
       	     }
       	 } 
      	 
      	 else if (param.equalsIgnoreCase("getDriverName")) {
       	     try {
       	         String custID = request.getParameter("custId");
       	         jsonArray = new JSONArray();
       	         if (custID != null && !custID.equals("")) {
       	             jsonArray = cvmf.getDriverName(Integer.parseInt(custID), systemId, offset);
       	             if (jsonArray.length() > 0) {
       	                 jsonObject.put("driverNameRoot", jsonArray);
       	             } else {
       	                 jsonObject.put("driverNameRoot", "");
       	             }
       	             response.getWriter().print(jsonObject.toString());
       	         } else {
       	             jsonObject.put("driverNameRoot", "");
       	             response.getWriter().print(jsonObject.toString());
       	         }
       	     } catch (Exception e) {
       	         e.printStackTrace();
       	     }
       	 } 
      	 
      	 else if (param.equalsIgnoreCase("getGunman")) {
       	     try {
       	         String custID = request.getParameter("custId");
       	         jsonArray = new JSONArray();
       	         if (custID != null && !custID.equals("")) {
       	             jsonArray = cvmf.getGunman(Integer.parseInt(custID), systemId, offset);
       	             if (jsonArray.length() > 0) {
       	                 jsonObject.put("gunman1Root", jsonArray);
       	             } else {
       	                 jsonObject.put("gunman1Root", "");
       	             }
       	             response.getWriter().print(jsonObject.toString());
       	         } else {
       	             jsonObject.put("gunman1Root", "");
       	             response.getWriter().print(jsonObject.toString());
       	         }
       	     } catch (Exception e) {
       	         e.printStackTrace();
       	     }
       	 } 
      	 
      	 else if (param.equalsIgnoreCase("tripPlannerAddAndModify")) {
       	     try {
       	         String buttonValue = request.getParameter("buttonValue");
       	         String custId = request.getParameter("custId");
       	         String region = request.getParameter("region");
       	         String location = request.getParameter("location");
       	         String hub = request.getParameter("hub");
       	         String routeName = request.getParameter("routeName");
       	         String routeId = request.getParameter("routeId");
       	         String atm = request.getParameter("atmList");
       	         String custodianName1 = request.getParameter("custodianName1");
       	         String custodianName2 = request.getParameter("custodianName2");
       	         String tripCreationDate=request.getParameter("tripCreationDt");
       	         String openingOdometer=request.getParameter("openingOdometer");
       	         String vehicleNo = request.getParameter("vehicleNo");
       	         String driverName = request.getParameter("driverName");
       	         int gunman1 = 0;
       	         int gunman2 = 0;
       	         String id = request.getParameter("id");
       	         String message = "";
       	         String regionModify = request.getParameter("regionModify");
       	         String locationModify = request.getParameter("locationModify");
       	         String hubModify = request.getParameter("hubModify");
       	         String routeNameModify = request.getParameter("routeNameModify");
       	         String vehicleNoModify = request.getParameter("vehicleNoModify");
       	         String driverNameModify = request.getParameter("driverNameModify");
       	         String gunman1Modify = request.getParameter("gunman1Modify");
       	         String gunman2Modify = request.getParameter("gunman2Modify");
       	         if(request.getParameter("gunman1") != null && !request.getParameter("gunman1").equals("")){
       	        	gunman1 = Integer.parseInt(request.getParameter("gunman1"));
    	         }
		       	 if(request.getParameter("gunman2") != null && !request.getParameter("gunman2").equals("")){
		       		gunman2 = Integer.parseInt(request.getParameter("gunman2"));
		  	     }
       	         String tripsheetNo = request.getParameter("tripsheetNo");
       	         if(tripCreationDate.contains("T")){
       	        	tripCreationDate=tripCreationDate.replace("T", " ");
     	         }
       	         String tripNo = request.getParameter("tripNo");
       	         String tobeDeleted = request.getParameter("tobeDeleted");
       	         if (buttonValue.equals("Create Trip") && custId != null && !custId.equals("")  && routeId != null && !routeId.equals("")) {
       	             message = cvmf.insertTripPlannerInformation(Integer.parseInt(custId), region, location, hub, routeName, vehicleNo, driverName, gunman1, gunman2, userId, systemId,custodianName1,custodianName2,Double.parseDouble(openingOdometer),tripCreationDate,offset,tripsheetNo,Integer.parseInt(routeId));
       	         } else if (buttonValue.equals("Modify") && custId != null && !custId.equals("")) {
       	             message = cvmf.modifyTripPlannerInformation(Integer.parseInt(custId), regionModify, locationModify, hubModify, routeNameModify, vehicleNoModify, driverNameModify, gunman1Modify, gunman2Modify, tripNo, userId, systemId, Integer.parseInt(id), atm, tobeDeleted);
       	         }
       	         response.getWriter().print(message);
       	     } catch (Exception e) {
       	         e.printStackTrace();
       	     }
       	 } 
      	 
      	 else if (param.equalsIgnoreCase("getTripPlannerReport")) {
       	     try {
       	         String customerId = request.getParameter("custId");
       	         jsonArray = new JSONArray();
       	         if (customerId != null && !customerId.equals("")) {
       	             ArrayList < Object > list1 = cvmf.getTripPlanReport(Integer.parseInt(customerId), systemId,offset);
       	             jsonArray = (JSONArray) list1.get(0);
       	             if (jsonArray.length() > 0) {
       	                 jsonObject.put("tripPlannerRoot", jsonArray);
       	             } else {
       	                 jsonObject.put("tripPlannerRoot", "");
       	             }
       	             response.getWriter().print(jsonObject.toString());
       	         } else {
       	             jsonObject.put("tripPlannerRoot", "");
       	             response.getWriter().print(jsonObject.toString());
       	         }
       	     } catch (Exception e) {
       	         e.printStackTrace();
       	     }
       	 } 
      	 
      	 else if (param.equalsIgnoreCase("deleteData")) {
       	     try {
       	         String customerId = request.getParameter("custId");
       	         String hubDel = request.getParameter("hub1Id");
       	         String date = request.getParameter("tripCloseDate");
       	         String tripNo = request.getParameter("tripNo");
       	         String tripshtNo = request.getParameter("tripshtNo");
       	         String closingOdometer=request.getParameter("closingOdometer");
       	         String vehicleNo=request.getParameter("vehicleNo");
       	         String tripStartDate=request.getParameter("tripStartDt");
       	         if(tripStartDate.contains("T") && date.contains("T")){
       	        	tripStartDate=tripStartDate.replace("T", " ");
       	        	date=date.replace("T", " ");
       	         }
       	         if (customerId != null && !customerId.equals("")) {
       	             String message = cvmf.delData(Integer.parseInt(customerId), systemId, hubDel, date, tripNo,offset,userId,Double.parseDouble(closingOdometer),vehicleNo,tripStartDate,tripshtNo);
       	             response.getWriter().print(message);
       	         }
       	     } catch (Exception e) {
       	         e.printStackTrace();
       	     }
       	 }
      	 
 /*****************************************************************************DASHBOARD*******************************************************************************/     	 
         if (param.equals("getCMSDashBoardDetails")) {
             try {
                 jsonArray = new JSONArray();
                 jsonObject = new JSONObject();
                 String CustId = request.getParameter("CustId");
                 if (CustId != null && !CustId.equals("")) {
                     jsonArray = cvmf.getCMSDashBoardDetails(systemId, Integer.parseInt(CustId),offset);
                     if (jsonArray.length() > 0) {
                         jsonObject.put("cmsDashboardRoot", jsonArray);
                     } else {
                         jsonObject.put("cmsDashboardRoot", "");
                     }
                 }else {
                     jsonObject.put("cmsDashboardRoot", "");
                 }
                 response.getWriter().print(jsonObject.toString());
             } catch (Exception e) {
                 e.printStackTrace();
             }
         } 
 		
          
         if(param.equals("getDataForCMSDashBoardMap")) {
         	try{
         		jsonArray = new JSONArray();
         		jsonObject = new JSONObject();
         		String CustId = request.getParameter("custId");
         		String tripId = request.getParameter("tripId");
         		String assetNumber = request.getParameter("assetNumber");
         		if(CustId != null && !CustId.equals("") && tripId !=null && !tripId.equals("")) {
                         jsonArray = cvmf.getDataForCMSDashBoardMap(systemId, Integer.parseInt(CustId),tripId,assetNumber);
                         if (jsonArray.length() > 0) {
                             jsonObject.put("cmsDashboardMapRoot", jsonArray);
                         } else {
                             jsonObject.put("cmsDashboardMapRoot", "");
                         }
                     }else {
                         jsonObject.put("cmsDashboardMapRoot", "");
                     }
                     response.getWriter().print(jsonObject.toString());
                 } catch (Exception e) {
                     e.printStackTrace();
                 }
             } 
         
         if(param.equals("getTripPointsForCmsDasbBooard")) {
         	try{
         		jsonArray = new JSONArray();
         		jsonObject = new JSONObject();
         		String CustId = request.getParameter("custId");
         		String tripId = request.getParameter("tripId");
         		if(CustId != null && !CustId.equals("") && tripId !=null && !tripId.equals("")) {
                         jsonArray = cvmf.getTripPointsForCmsDasbBooard(systemId, Integer.parseInt(CustId),tripId);
                         if (jsonArray.length() > 0) {
                             jsonObject.put("TripPointsForCmsDasbBooardRoot", jsonArray);
                         } else {
                             jsonObject.put("TripPointsForCmsDasbBooardRoot", "");
                         }
                     }else {
                         jsonObject.put("TripPointsForCmsDasbBooardRoot", "");
                     }
                    response.getWriter().print(jsonObject.toString());
                 } catch (Exception e) {
                     e.printStackTrace();
                 }
             } 
          if (param.equalsIgnoreCase("getTripSummaryReport")) {
       	     try {
       	         String customerId = request.getParameter("CustId");
       	         String startdate=request.getParameter("startdate");
       	         String enddate=request.getParameter("enddate");
       	         String jspName=request.getParameter("jspName");
       	         String custName=request.getParameter("custName");
       	         jsonArray = new JSONArray();
	       	     if(startdate.contains("T") && enddate.contains("T")){
	       	    	startdate=startdate.replace("T", " ");
	       	    	enddate=enddate.replace("T", " ");
	   	         }
       	         if (customerId != null && !customerId.equals("")) {
       	             ArrayList < Object > list1 = cvmf.getTripSummaryReport(Integer.parseInt(customerId), systemId,offset,startdate,enddate,lang);
       	             jsonArray = (JSONArray) list1.get(0);
       	             if (jsonArray.length() > 0) {
       	                 jsonObject.put("tripSummaryRoot", jsonArray);
       	             } else {
       	                 jsonObject.put("tripSummaryRoot", "");
       	             }
       	            ReportHelper reportHelper = (ReportHelper) list1.get(1);
					request.getSession().setAttribute(jspName, reportHelper);
					request.getSession().setAttribute("startdate",ddmmyyyy.format(yyyymmdd.parse(startdate)));
					request.getSession().setAttribute("enddate",ddmmyyyy.format(yyyymmdd.parse(enddate)));
					request.getSession().setAttribute("custId", custName);
       	         } else {
       	             jsonObject.put("tripSummaryRoot", "");
       	         }
       	      response.getWriter().print(jsonObject.toString());
       	     } catch (Exception e) {
       	         e.printStackTrace();
       	     }
       	 } 
          if (param.equalsIgnoreCase("getTripNo")) {
        	     try {
        	         String custID = request.getParameter("CustId");
        	         String startDate=request.getParameter("startDt");
        	         String endDate=request.getParameter("endDt");
        	         if(startDate.contains("T") && endDate.contains("T")){
        	        	 startDate=startDate.replace("T", " ");
        	        	 endDate=endDate.replace("T", " ");
          	         }
        	         jsonArray = new JSONArray();
        	         if (custID != null && !custID.equals("")) {
        	             jsonArray = cvmf.getTripNo(Integer.parseInt(custID), systemId,startDate,endDate,offset);
        	             if (jsonArray.length() > 0) {
        	                 jsonObject.put("tripNoRoot", jsonArray);
        	             } else {
        	                 jsonObject.put("tripNoRoot", "");
        	             }
        	             response.getWriter().print(jsonObject.toString());
        	         } else {
        	             jsonObject.put("tripNoRoot", "");
        	             response.getWriter().print(jsonObject.toString());
        	         }
        	     } catch (Exception e) {
        	         e.printStackTrace();
        	     }
        	 } 
          
          if (param.equalsIgnoreCase("getTripDetailsReport")) {
        	     try {
        	         String customerId = request.getParameter("CustId");
        	         String jspName=request.getParameter("jspName");
        	         String tripNo=request.getParameter("tripNo");
        	         jsonArray = new JSONArray();
        	         CommonFunctions cf = new CommonFunctions();
        	         if (customerId != null && !customerId.equals("")) {
        	             ArrayList < Object > list1 = cvmf.getTripDetailsReport(Integer.parseInt(customerId), systemId,offset,tripNo);
        	             jsonArray = (JSONArray) list1.get(0);
        	             if (jsonArray.length() > 0) {
        	                 jsonObject.put("tripDetailsRoot", jsonArray);
        	             } else {
        	                 jsonObject.put("tripDetailsRoot", "");
        	             }
        	        ReportHelper reportHelper = (ReportHelper) list1.get(1);
 					request.getSession().setAttribute(jspName, reportHelper);
 					request.getSession().setAttribute("tripNo", tripNo);
 					request.getSession().setAttribute("custId", cf.getCustomerName(customerId,systemId));
        	         } else {
        	             jsonObject.put("tripDetailsRoot", "");
        	         }
        	      response.getWriter().print(jsonObject.toString());
        	     } catch (Exception e) {
        	         e.printStackTrace();
        	     }
        	 }
          
          if (param.equalsIgnoreCase("getTripSummaryReportNew")) {
        	     try {
        	         String customerId = request.getParameter("CustId");
        	         String startdate=request.getParameter("startdate");
        	         String enddate=request.getParameter("enddate");
        	         String jspName=request.getParameter("jspName");
        	         String custName=request.getParameter("custName");
        	         jsonArray = new JSONArray();
        	         if(startdate.contains("T") && enddate.contains("T")){
     	       	    	startdate=startdate.replace("T", " ");
     	       	    	enddate=enddate.replace("T", " ");
     	   	         }
        	         if (customerId != null && !customerId.equals("")) {
        	             ArrayList < Object > list1 = cvmf.getTripSummaryReportNew(Integer.parseInt(customerId), systemId,offset,startdate,enddate,lang);
        	             jsonArray = (JSONArray) list1.get(0);
        	             if (jsonArray.length() > 0) {
        	                 jsonObject.put("tripSummaryRoot", jsonArray);
        	             } else {
        	                 jsonObject.put("tripSummaryRoot", "");
        	             }
        	            ReportHelper reportHelper = (ReportHelper) list1.get(1);
 					request.getSession().setAttribute(jspName, reportHelper);
 					request.getSession().setAttribute("startdate",ddmmyyyy.format(yyyymmdd.parse(startdate)));
 					request.getSession().setAttribute("enddate",ddmmyyyy.format(yyyymmdd.parse(enddate)));
 					request.getSession().setAttribute("custId", custName);
        	         } else {
        	             jsonObject.put("tripSummaryRoot", "");
        	         }
        	      response.getWriter().print(jsonObject.toString());
        	     } catch (Exception e) {
        	         e.printStackTrace();
        	     }
        	 }
          
          if(param.equalsIgnoreCase("getCustomerMasterDetails")){
          	try {
                String customerId = request.getParameter("CustId");
                jsonArray = new JSONArray();
                if (customerId != null && !customerId.equals("")) {
                    ArrayList < Object > list1 = cvmf.getCustomerMasterDetails(systemId, Integer.parseInt(customerId),offset);
                    jsonArray = (JSONArray) list1.get(0);
                    if (jsonArray.length() > 0) {
                        jsonObject.put("customerMasterRoot", jsonArray);
                    } else {
                        jsonObject.put("customerMasterRoot", "");
                    }
                    response.getWriter().print(jsonObject.toString());
                } else {
                    jsonObject.put("customerMasterRoot", "");
                    response.getWriter().print(jsonObject.toString());
                }
            }catch (Exception e) {
    			e.printStackTrace();
    		}	
        }
          
        return null;
   }

}



