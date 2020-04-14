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

public class CashVanReportAction extends Action {
	public ActionForward execute(ActionMapping map,ActionForm form,HttpServletRequest request,HttpServletResponse response){
		HttpSession session = request.getSession();
		LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
		int systemId= loginInfo.getSystemId();
		int clientId = loginInfo.getCustomerId();
		int offset = loginInfo.getOffsetMinutes();
		String param = "";
		int userId = loginInfo.getUserId();
		if(request.getParameter("param") != null){
			param = request.getParameter("param");
		}
		CashVanManagementFunctions cvmFunc = new CashVanManagementFunctions();
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonObject = null;
		
		SimpleDateFormat ddmmyyyy = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
    	SimpleDateFormat yyyymmdd = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		
      if (param.equalsIgnoreCase("getVehicleDetails")) {
      	     try {
      	         String custID = request.getParameter("custId");
      	         jsonArray = new JSONArray();
      	         jsonObject = new JSONObject();
      	         if (custID != null && !custID.equals("")) {
      	             jsonArray = cvmFunc.getVehicleDetails(systemId,Integer.parseInt(custID),userId);
      	             if (jsonArray.length() > 0) {
      	                 jsonObject.put("VehicleStoreRoot", jsonArray);
      	             } else {
      	                 jsonObject.put("VehicleStoreRoot", "");
      	             }
      	             response.getWriter().print(jsonObject.toString());
      	         } else {
      	             jsonObject.put("VehicleStoreRoot", "");
      	             response.getWriter().print(jsonObject.toString());
      	         }
      	     } catch (Exception e) {
      	         e.printStackTrace();
      	     }
      	 }else  if (param.equalsIgnoreCase("getALLVehicleDetails")) {
      	     try {
      	         String custID = request.getParameter("custId");
      	         jsonArray = new JSONArray();
      	         jsonObject = new JSONObject();
      	         if (custID != null && !custID.equals("")) {
      	             jsonArray = cvmFunc.getAllVehicleDetails(systemId,Integer.parseInt(custID),userId);
      	             if (jsonArray.length() > 0) {
      	                 jsonObject.put("VehicleStoreRoot", jsonArray);
      	             } else {
      	                 jsonObject.put("VehicleStoreRoot", "");
      	             }
      	             response.getWriter().print(jsonObject.toString());
      	         } else {
      	             jsonObject.put("VehicleStoreRoot", "");
      	             response.getWriter().print(jsonObject.toString());
      	         }
      	     } catch (Exception e) {
      	         e.printStackTrace();
      	     }
      	 }
       else if (param.equalsIgnoreCase("getCrewDetails")) {
   	     try {
  	         String custID = request.getParameter("custId");
  	         jsonArray = new JSONArray();
  	         jsonObject = new JSONObject();
  	         if (custID != null && !custID.equals("")) {
  	             jsonArray = cvmFunc.getCrew(systemId,Integer.parseInt(custID));
  	             if (jsonArray.length() > 0) {
  	                 jsonObject.put("CrewRoot", jsonArray);
  	             } else {
  	                 jsonObject.put("CrewRoot", "");
  	             }
  	             response.getWriter().print(jsonObject.toString());
  	         } else {
  	             jsonObject.put("CrewRoot", "");
  	             response.getWriter().print(jsonObject.toString());
  	         }
  	     } catch (Exception e) {
  	         e.printStackTrace();
  	       }
  	    }
       else if (param.equalsIgnoreCase("getAtmNo")) {
     	     try {
    	         jsonArray = new JSONArray();
    	         jsonObject = new JSONObject();
    	             jsonArray = cvmFunc.getAtmNo(systemId,clientId);
    	             if (jsonArray.length() > 0) {
    	                 jsonObject.put("AtmNoRoot", jsonArray);
    	             } else {
    	                 jsonObject.put("AtmNoRoot", "");
    	             }
    	             response.getWriter().print(jsonObject.toString());
    	     } catch (Exception e) {
    	         e.printStackTrace();
    	       }
    	    }
       else if (param.equalsIgnoreCase("getTripNo")) {
     	     try {
    	         String custID = request.getParameter("custId");
    	         jsonArray = new JSONArray();
    	         jsonObject = new JSONObject();
    	         if (custID != null && !custID.equals("")) {
    	             jsonArray = cvmFunc.getTripNo(systemId,Integer.parseInt(custID),userId);
    	             if (jsonArray.length() > 0) {
    	                 jsonObject.put("TripNoRoot", jsonArray);
    	             } else {
    	                 jsonObject.put("TripNoRoot", "");
    	             }
    	             response.getWriter().print(jsonObject.toString());
    	         } else {
    	             jsonObject.put("TripNoRoot", "");
    	             response.getWriter().print(jsonObject.toString());
    	         }
    	     } catch (Exception e) {
    	         e.printStackTrace();
    	     }
    	 }
        else if (param.equalsIgnoreCase("getQuotationNo")) {
   	     try {
  	         jsonArray = new JSONArray();
  	         jsonObject = new JSONObject();
  	             jsonArray = cvmFunc.getQuotationNo(systemId,clientId,userId);
  	             if (jsonArray.length() > 0) {
  	                 jsonObject.put("QuotationNoRoot", jsonArray);
  	             } else {
  	                 jsonObject.put("QuotationNoRoot", "");
  	             }
  	             response.getWriter().print(jsonObject.toString());
  	        
  	     } catch (Exception e) {
  	         e.printStackTrace();
  	     }
  	   }
    	else if (param.equalsIgnoreCase("getAtmReplenishmentReport")) {
     	     try {
     	         String customerId = request.getParameter("CustId");
     	         String startdate=request.getParameter("startdate");
     	         String enddate=request.getParameter("enddate");
     	         String jspName=request.getParameter("jspName");
     	         String custName=request.getParameter("custName");
     	         String crewId=request.getParameter("crewId");
     	         String VehicleNo=request.getParameter("vehicleNo");
     	         String atmNo=request.getParameter("atmNo");
     	         jsonArray = new JSONArray();
     	         jsonObject = new JSONObject();
	       	     if(startdate.contains("T") && enddate.contains("T")){
	       	    	startdate=startdate.replace("T", " ");
	       	    	enddate=enddate.replace("T", " ");
	   	         }
	       	     if(crewId.equals("") || crewId == null){
	       	    	crewId = "0";
	       	     }
	       	    
	       	     if(atmNo.equals("") || atmNo == null){
	       	    	atmNo = "0";
		       	 }
     	         if (customerId != null && !customerId.equals("")) {
     	             ArrayList < Object > list1 = cvmFunc.getAtmReplenishmentReport(Integer.parseInt(customerId), systemId,offset,startdate,enddate,Integer.parseInt(crewId),VehicleNo,Integer.parseInt(atmNo));
     	             jsonArray = (JSONArray) list1.get(0);
     	             if (jsonArray.length() > 0) {
     	                 jsonObject.put("AtmReplenishmentSummaryRoot", jsonArray);
     	             } else {
     	                 jsonObject.put("AtmReplenishmentSummaryRoot", "");
     	             }
     	            ReportHelper reportHelper = (ReportHelper) list1.get(1);
					request.getSession().setAttribute(jspName, reportHelper);
					request.getSession().setAttribute("startdate",ddmmyyyy.format(yyyymmdd.parse(startdate)));
					request.getSession().setAttribute("enddate",ddmmyyyy.format(yyyymmdd.parse(enddate)));
					request.getSession().setAttribute("custId", custName);
     	         } else {
     	             jsonObject.put("AtmReplenishmentSummaryRoot", "");
     	         }
     	      response.getWriter().print(jsonObject.toString());
     	     } catch (Exception e) {
     	         e.printStackTrace();
     	     }
     	 } 
		else if (param.equalsIgnoreCase("getTripOperationReport")) {
     	     try {
     	         String customerId = request.getParameter("CustId");
     	         String startdate=request.getParameter("startdate");
     	         String enddate=request.getParameter("enddate");
     	         String jspName=request.getParameter("jspName");
     	         String custName=request.getParameter("custName");
     	         String crewId=request.getParameter("crewId");
    	         String tripId=request.getParameter("tripId");
    	         String routeId=request.getParameter("routeId");
    	         String vehicleNo=request.getParameter("vehicleNo");
     	         jsonArray = new JSONArray();
     	         jsonObject = new JSONObject();
	       	     if(startdate.contains("T") && enddate.contains("T")){
	       	    	startdate=startdate.replace("T", " ");
	       	    	enddate=enddate.replace("T", " ");
	   	         }
	       	     if(crewId.equals("") || crewId == null){
	       	    	crewId = "0";
	       	     }
	       	     if(tripId.equals("") || tripId == null){
	       	    	tripId = "0";
	       	     }
	       	     if(routeId.equals("") || routeId == null){
	       	    	routeId = "0";
	       	     }
     	         if (customerId != null && !customerId.equals("")) {
     	             ArrayList < Object > list1 = cvmFunc.getTripOperationReportDetails(Integer.parseInt(customerId), systemId,offset,startdate,enddate,Integer.parseInt(crewId),Integer.parseInt(tripId),Integer.parseInt(routeId),vehicleNo);
     	             jsonArray = (JSONArray) list1.get(0);
     	             if (jsonArray.length() > 0) {
     	                 jsonObject.put("TripOperationSummaryRoot", jsonArray);
     	             } else {
     	                 jsonObject.put("TripOperationSummaryRoot", "");
     	             }
     	            ReportHelper reportHelper = (ReportHelper) list1.get(1);
					request.getSession().setAttribute(jspName, reportHelper);
					request.getSession().setAttribute("startdate",ddmmyyyy.format(yyyymmdd.parse(startdate)));
					request.getSession().setAttribute("enddate",ddmmyyyy.format(yyyymmdd.parse(enddate)));
					request.getSession().setAttribute("custId", custName);
     	         } else {
     	             jsonObject.put("TripOperationSummaryRoot", "");
     	         }
     	      response.getWriter().print(jsonObject.toString());
     	     } catch (Exception e) {
     	         e.printStackTrace();
     	     }
     	 }  
		else if (param.equalsIgnoreCase("getQuotationReport")) {
    	     try {
    	         String customerId = request.getParameter("CustId");
    	         String startdate=request.getParameter("startdate");
    	         String enddate=request.getParameter("enddate");
    	         String jspName=request.getParameter("jspName");
    	         String custName=request.getParameter("custName");
    	         String quotNo=request.getParameter("quotNo");
    	         String quotStatus=request.getParameter("quotStatus");
    	         String cvsCustName=request.getParameter("cvsCustName");
    	         jsonArray = new JSONArray();
    	         jsonObject = new JSONObject();
	       	     if(startdate.contains("T") && enddate.contains("T")){
	       	    	startdate=startdate.replace("T", " ");
	       	    	enddate=enddate.replace("T", " ");
	   	         }
	       	     if(quotNo.equals("") || quotNo == null){
	       	    	quotNo = "0";
	       	     }
	       	     
    	         if (customerId != null && !customerId.equals("")) {
    	             ArrayList < Object > list1 = cvmFunc.getQuotationReportDetails(Integer.parseInt(customerId), systemId,offset,startdate,enddate,Integer.parseInt(quotNo),quotStatus,cvsCustName);
    	             jsonArray = (JSONArray) list1.get(0);
    	             if (jsonArray.length() > 0) {
    	                 jsonObject.put("QuotationSummaryRoot", jsonArray);
    	             } else {
    	                 jsonObject.put("QuotationSummaryRoot", "");
    	             }
    	            ReportHelper reportHelper = (ReportHelper) list1.get(1);
					request.getSession().setAttribute(jspName, reportHelper);
					request.getSession().setAttribute("startdate",ddmmyyyy.format(yyyymmdd.parse(startdate)));
					request.getSession().setAttribute("enddate",ddmmyyyy.format(yyyymmdd.parse(enddate)));
					request.getSession().setAttribute("custId", custName);
    	         } else {
    	             jsonObject.put("QuotationSummaryRoot", "");
    	         }
    	      response.getWriter().print(jsonObject.toString());
    	     } catch (Exception e) {
    	         e.printStackTrace();
    	     }
    	 }  
		else if (param.equalsIgnoreCase("getArmoryOperationReport")) {
   	     try {
   	         String customerId = request.getParameter("CustId");
   	         String startdate=request.getParameter("startdate");
   	         String enddate=request.getParameter("enddate");
   	         String jspName=request.getParameter("jspName");
   	         String custName=request.getParameter("custName");
   	         String crewId=request.getParameter("crewId");
	         String vehicleNo=request.getParameter("vehicleNo");
	         String tripId=request.getParameter("tripId");
   	         jsonArray = new JSONArray();
   	         jsonObject = new JSONObject();
	       	     if(startdate.contains("T") && enddate.contains("T")){
	       	    	startdate=startdate.replace("T", " ");
	       	    	enddate=enddate.replace("T", " ");
	   	         }
	       	  if(crewId.equals("") || crewId == null){
	       	    	crewId = "0";
	       	     }
	       	if(tripId.equals("") || tripId == null){
	       		tripId = "0";
       	     }
   	         if (customerId != null && !customerId.equals("")) {
   	             ArrayList < Object > list1 = cvmFunc.getArmoryOperationReportDetails(Integer.parseInt(customerId), systemId,offset,startdate,enddate,Integer.parseInt(crewId),Integer.parseInt(tripId),vehicleNo);
   	             jsonArray = (JSONArray) list1.get(0);
   	             if (jsonArray.length() > 0) {
   	                 jsonObject.put("ArmoryOperationSummaryRoot", jsonArray);
   	             } else {
   	                 jsonObject.put("ArmoryOperationSummaryRoot", "");
   	             }
   	            ReportHelper reportHelper = (ReportHelper) list1.get(1);
					request.getSession().setAttribute(jspName, reportHelper);
					request.getSession().setAttribute("startdate",ddmmyyyy.format(yyyymmdd.parse(startdate)));
					request.getSession().setAttribute("enddate",ddmmyyyy.format(yyyymmdd.parse(enddate)));
					request.getSession().setAttribute("custId", custName);
   	         } else {
   	             jsonObject.put("ArmoryOperationSummaryRoot", "");
   	         }
   	      response.getWriter().print(jsonObject.toString());
   	     } catch (Exception e) {
   	         e.printStackTrace();
   	     }
   	 }else if (param.equalsIgnoreCase("getvehiclewiseReport")) {
   	     try {
   	         String customerId = request.getParameter("CustId");
   	         String startdate=request.getParameter("startdate");
   	         String enddate=request.getParameter("enddate");
   	         String jspName=request.getParameter("jspName");
   	         String custName=request.getParameter("custName");
	         String vehicleNo=request.getParameter("vehicleNo");
   	         jsonArray = new JSONArray();
   	         jsonObject = new JSONObject();
	       	     if(startdate.contains("T") && enddate.contains("T")){
	       	    	startdate=startdate.replace("T", " ");
	       	    	enddate=enddate.replace("T", " ");
	   	         }
   	         if (customerId != null && !customerId.equals("")) {
   	             ArrayList < Object > list1 = cvmFunc.getVehicleWiseReportDetails(Integer.parseInt(customerId), systemId,offset,startdate,enddate,vehicleNo);
   	             jsonArray = (JSONArray) list1.get(0);
   	             if (jsonArray.length() > 0) {
   	                 jsonObject.put("VehicleWiseSummaryRoot", jsonArray);
   	             } else {
   	                 jsonObject.put("VehicleWiseSummaryRoot", "");
   	             }
   	            ReportHelper reportHelper = (ReportHelper) list1.get(1);
					request.getSession().setAttribute(jspName, reportHelper);
					request.getSession().setAttribute("startdate",ddmmyyyy.format(yyyymmdd.parse(startdate)));
					request.getSession().setAttribute("enddate",ddmmyyyy.format(yyyymmdd.parse(enddate)));
					request.getSession().setAttribute("custId", vehicleNo);
					request.getSession().setAttribute("NoRuns", jsonArray.length());
   	         } else {
   	             jsonObject.put("VehicleWiseSummaryRoot", "");
   	         }
   	      response.getWriter().print(jsonObject.toString());
   	     } catch (Exception e) {
   	         e.printStackTrace();
   	     }
   	 }else if (param.equalsIgnoreCase("getcustomerwiseReport")) {
   	     try {
   	         String customerId = request.getParameter("CustId");
   	         String startdate=request.getParameter("startdate");
   	         String enddate=request.getParameter("enddate");
   	         String jspName=request.getParameter("jspName");
   	         String custName=request.getParameter("custName");
	         String CustomerId=request.getParameter("customerName");
	         String Cust=request.getParameter("customerFullName");
   	         jsonArray = new JSONArray();
   	         jsonObject = new JSONObject();
	       	     if(startdate.contains("T") && enddate.contains("T")){
	       	    	startdate=startdate.replace("T", " ");
	       	    	enddate=enddate.replace("T", " ");
	   	         }
   	         if (customerId != null && !customerId.equals("")) {
   	             ArrayList < Object > list1 = cvmFunc.getCustomerWiseReportDetails(Integer.parseInt(customerId), systemId,offset,startdate,enddate,CustomerId);
   	             jsonArray = (JSONArray) list1.get(0);
   	             if (jsonArray.length() > 0) {
   	                 jsonObject.put("CustomerWiseSummaryRoot", jsonArray);
   	                 System.out.println(jsonArray.length());
   	             } else {
   	                 jsonObject.put("CustomerWiseSummaryRoot", "");
   	             }
   	            ReportHelper reportHelper = (ReportHelper) list1.get(1);
					request.getSession().setAttribute(jspName, reportHelper);
					request.getSession().setAttribute("startdate",ddmmyyyy.format(yyyymmdd.parse(startdate)));
					request.getSession().setAttribute("enddate",ddmmyyyy.format(yyyymmdd.parse(enddate)));
					request.getSession().setAttribute("custId", Cust);
					request.getSession().setAttribute("NoRuns", jsonArray.length());
   	         } else {
   	             jsonObject.put("CustomerWiseSummaryRoot", "");
   	         }
   	      response.getWriter().print(jsonObject.toString());
   	     } catch (Exception e) {
   	         e.printStackTrace();
   	     }
   	 }
		return null;
	}
}
