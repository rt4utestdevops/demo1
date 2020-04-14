package t4u.sandmining;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;

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
import t4u.functions.CommonFunctions;
import t4u.functions.SandMiningFunctions;

public class SandMiningAction extends Action {
	public ActionForward execute(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		String param = "";
		int offmin = 0;
		int systemId = 0;
		int userId = 0;
		int clientId=0;
		String lang = "";
		String Zone = "";
		SimpleDateFormat sdfddmmyyyy = new SimpleDateFormat("dd/MM/yyyy");
		HttpSession session = request.getSession();
		CommonFunctions cf = new CommonFunctions();
		LoginInfoBean loginInfo = (LoginInfoBean) session
				.getAttribute("loginInfoDetails");
		SandMiningFunctions sandfunc = new SandMiningFunctions();
		systemId = loginInfo.getSystemId();
		clientId=loginInfo.getCustomerId();
		userId = loginInfo.getUserId();
		offmin = loginInfo.getOffsetMinutes();
		Zone = loginInfo.getZone();
		lang = loginInfo.getLanguage();
		JSONArray jsonArray = null;
		JSONObject jsonObject = new JSONObject();
		if (request.getParameter("param") != null) {
			param = request.getParameter("param").toString();
		}
		
		if (param.equalsIgnoreCase("getGridNonCommunicatingVehData")) {
			try {
				String customerid = request.getParameter("custID");
				String jspName = request.getParameter("jspName");
				String startdate=request.getParameter("startdate").replace("T"," ");;
				String enddate=request.getParameter("enddate").replace("T00:00:00"," 23:59:59");
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				ArrayList list1 = sandfunc.getGridNonCommunicatingVehData(customerid, systemId, offmin, lang, userId,startdate,enddate);
				jsonArray = (JSONArray) list1.get(0);
				if (jsonArray.length() > 0) {
					jsonObject.put("GridRoot", jsonArray);
				} else {
					jsonObject.put("GridRoot", "");
				}
				ReportHelper reportHelper = (ReportHelper) list1.get(1);
				request.getSession().setAttribute(jspName, reportHelper);
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {

			}
		}
		/**
		 * Getting Grid Details for Non communicating data
		 */
		if (param.equalsIgnoreCase("getGridNonCommunicatingData")) {
			try {
				String customerid = request.getParameter("custID");
				String jspName = request.getParameter("jspName");
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				ArrayList list1 = sandfunc.getGridNonCommunicatingRep(customerid, systemId, offmin, lang, userId);
				jsonArray = (JSONArray) list1.get(0);
				if (jsonArray.length() > 0) {
					jsonObject.put("GridRoot", jsonArray);
				} else {
					jsonObject.put("GridRoot", "");
				}
				ReportHelper reportHelper = (ReportHelper) list1.get(1);
				request.getSession().setAttribute(jspName, reportHelper);
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {

			}
		} else if (param.equals("getVehicleNo")) {
			try {
				jsonObject = new JSONObject();
				jsonArray = sandfunc.getRegistrationNoBasedOnUser(systemId,
						userId);
				if (jsonArray.length() > 0) {
					jsonObject.put("VehicleNoRoot", jsonArray);
				} else {
					jsonObject.put("VehicleNoRoot", "");
				}
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {
				System.out.println("Error in Common Action:-getVehicleNo "
						+ e.toString());
			}
		} else if (param.equalsIgnoreCase("getUnauthorizedPortEntryReport")) {
			
			try {
		        JSONArray array=null;
		        String s = request.getParameter("gridData");
				String customerid = request.getParameter("CustID");
				String startdate = request.getParameter("startdate");
				String enddate = request.getParameter("enddate");
				String jspName = request.getParameter("jspName");
				
				if (s != null) {
	                String st = "[" + s + "]";
	                array = new JSONArray(st.toString());
				}
				
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				ArrayList list1 = sandfunc.getUnauthorizedPortEntryReport(
						customerid, startdate, enddate, systemId,
						Zone, offmin, lang, userId,array);
				jsonArray = (JSONArray) list1.get(0);
				if (jsonArray.length() > 0) {
					jsonObject.put("UnauthorizedPortEntryRoot", jsonArray);
				} else {
					jsonObject.put("UnauthorizedPortEntryRoot", "");
				}
				ReportHelper reportHelper = (ReportHelper) list1.get(1);
				request.getSession().setAttribute(jspName, reportHelper);
				request.getSession().setAttribute(
						"startdate",
						cf.getFormattedDateddMMYYYY(startdate.replaceAll("T",
								" ")));
				request.getSession().setAttribute(
						"enddate",
						cf.getFormattedDateddMMYYYY(enddate
								.replaceAll("T", " ")));
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {

			}
		} else if (param.equalsIgnoreCase("getSandPortWisePermitCount")) {
			try {
				String customerid = request.getParameter("CustID");
				String startdate = request.getParameter("startdate");
				String enddate = request.getParameter("enddate");
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				jsonArray = sandfunc.getSandPortWisePermitCount(customerid,
						startdate, enddate, systemId, Zone, offmin, lang,
						userId);
				if (jsonArray.length() > 0) {
					jsonObject.put("SandPortWisePermitCountRoot", jsonArray);
				} else {
					jsonObject.put("SandPortWisePermitCountRoot", "");
				}
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {

			}
		} else if (param.equals("VehicleSaveModify")) {
			try {
				String buttonValue = request.getParameter("buttonValue");
				String ApplicationNo = request.getParameter("ApplicationNo");
				String Date = request.getParameter("Date");
				String VehicleRegistrationNo = request
						.getParameter("VehicleRegistrationNo");
				String InsuranceNo = request.getParameter("InsuranceNo");
				String InsuranceexpDate = request
						.getParameter("InsuranceexpDate");
				String FitnessExpdate = request.getParameter("FitnessExpdate");
				String PollutionexpDate = request
						.getParameter("PollutionexpDate");

				String NameOfRegowner = request.getParameter("ReGownerName");
				String PermanentAdd = request.getParameter("PermanenntAdd");
				String TemporaryAdd = request.getParameter("TemporaryAdd");
				String ContactNumber = request.getParameter("ContactNo");
				String GrossWeight = request.getParameter("GrossWeight");
				String UnLadenWeight = request.getParameter("UnLadenWeight");
				String Rto = request.getParameter("RTO");
				String PermitNo = request.getParameter("PermitNo");
				String PermitExpDate = request.getParameter("PermitExpDate");
				String LoadingCapacity = request
						.getParameter("LoadingCapacity");
				String YearOfManf = request.getParameter("YearOfManf");
				String UniqueIdNo = request.getParameter("UniqueIdNo");
				String UniqueNo = request.getParameter("UniqueNo");
				String sms = request.getParameter("sms");
				String message = "";

				if (buttonValue.equals("Enlisting")) {
					message = sandfunc.insertVehicleInformation(ApplicationNo,
							Date, VehicleRegistrationNo, InsuranceNo,
							InsuranceexpDate, FitnessExpdate, PollutionexpDate,
							NameOfRegowner, PermanentAdd, TemporaryAdd,
							ContactNumber, GrossWeight, UnLadenWeight, Rto,
							PermitNo, PermitExpDate, LoadingCapacity,
							YearOfManf, systemId, offmin, sms, userId);
				} else if (buttonValue.equals("Modify")) {
					message = sandfunc.modifyVehicleInformation(ApplicationNo,
							Date, InsuranceNo, InsuranceexpDate,
							FitnessExpdate, PollutionexpDate, NameOfRegowner,
							PermanentAdd, TemporaryAdd, ContactNumber,
							GrossWeight, UnLadenWeight, Rto, PermitNo,
							PermitExpDate, LoadingCapacity, YearOfManf,
							systemId, VehicleRegistrationNo, offmin, UniqueNo);
				}
				response.getWriter().print(message);
			} catch (Exception e) {
				System.out
						.println("Error in Asset Group Action:-saveRmodifyAssetGroupDetails "
								+ e.toString());
			}
		}

		else if (param.equalsIgnoreCase("getVehicleEnlistingDetails")) {
			try {

				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				String jspName = request.getParameter("jspName");
				ArrayList list1 = sandfunc.getVehicleEnlistingDetails(lang,
						offmin, systemId);
				jsonArray = (JSONArray) list1.get(0);
				if (jsonArray.length() > 0) {
					jsonObject.put("vehicleInformationRoot", jsonArray);
				} else {
					jsonObject.put("vehicleInformationRoot", "");
				}
				ReportHelper reportHelper = (ReportHelper) list1.get(1);
				request.getSession().setAttribute(jspName, reportHelper);
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {

			}
		}

		else if (param.equals("VechicleDelist")) {
			try {
				String VehicleRegistrationNo = request
						.getParameter("VehicleRegistrationNo");
				String UniqueIdNo = request.getParameter("UniqueIdNo");
				String ContactNumber = request.getParameter("ContactNo");
				String NameOfRegowner = request.getParameter("ReGownerName");
				String message = sandfunc.VechicleDelist(VehicleRegistrationNo,
						systemId, UniqueIdNo, ContactNumber, NameOfRegowner,
						userId);
				response.getWriter().print(message);
			} catch (Exception e) {
				e.printStackTrace();
				System.out
						.println("Error in Asset Group Action:-saveRmodifyAssetGroupDetails "
								+ e.toString());
			}
		}

		else if (param.equalsIgnoreCase("getDelistingDetails")) {
			try {
				String jspName = request.getParameter("jspName");
				// String custName = request.getParameter("custName");
				// String customerid = request.getParameter("custId");
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				ArrayList list1 = sandfunc.getDelistingDetails(lang, systemId,
						offmin);
				jsonArray = (JSONArray) list1.get(0);
				if (jsonArray.length() > 0) {
					jsonObject.put("delistingRoot", jsonArray);
				} else {
					jsonObject.put("delistingRoot", "");
				}
				ReportHelper reportHelper = (ReportHelper) list1.get(1);
				request.getSession().setAttribute(jspName, reportHelper);
				// request.getSession().setAttribute("customerid", custName);
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		}

		else if (param.equals("getMonthlyRevenuePermitReport")) {
			try {
				String customerid = request.getParameter("CustID");
				String groupId = request.getParameter("GroupId");
				String startdate = request.getParameter("startdate");
				String enddate = request.getParameter("enddate");
				String jspName = request.getParameter("jspName");
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				ArrayList<Object> list1 = sandfunc.getMonthlyRevenueReport(
						customerid, startdate, enddate, systemId, offmin, lang,
						groupId);
				jsonArray = (JSONArray) list1.get(0);
				if (jsonArray.length() > 0) {
					jsonObject.put("MonthlyRevenueReport", jsonArray);
				} else {
					jsonObject.put("MonthlyRevenueReport", "");
				}
				ReportHelper reportHelper = (ReportHelper) list1.get(1);
				request.getSession().setAttribute(jspName, reportHelper);
				request.getSession().setAttribute(
						"startdate",
						cf.getFormattedDateddMMYYYY(startdate.replaceAll("T",
								" ")));
				request.getSession().setAttribute(
						"enddate",
						cf.getFormattedDateddMMYYYY(enddate
								.replaceAll("T", " ")));
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {
				System.out.println("Error in Monthly Revenue Report:"
						+ e.toString());
			}
		}

		else if (param.equals("getYearlyRevenuePermitReport")) {
			try {
				String customerid = request.getParameter("CustID");
				String groupId = request.getParameter("subdivisionId");
				String startdate = request.getParameter("startdate");
				String enddate = request.getParameter("enddate");
				String jspName = request.getParameter("jspName");
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				ArrayList<Object> list1 = sandfunc.getYearlyRevenueReport(
						customerid, startdate, enddate, systemId, offmin, lang,
						groupId);
				jsonArray = (JSONArray) list1.get(0);
				if (jsonArray.length() > 0) {
					jsonObject.put("YearlyRevenueReport", jsonArray);
				} else {
					jsonObject.put("YearlyRevenueReport", "");
				}
				ReportHelper reportHelper = (ReportHelper) list1.get(1);
				request.getSession().setAttribute(jspName, reportHelper);
				request.getSession().setAttribute(
						"startdate",
						cf.getFormattedDateddMMYYYY(startdate.replaceAll("T",
								" ")));
				request.getSession().setAttribute(
						"enddate",
						cf.getFormattedDateddMMYYYY(enddate
								.replaceAll("T", " ")));
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {
				System.out.println("Error in Yearly Revenue Report:"
						+ e.toString());
			}
		}

		
else if(param.equals("getDailyMonitorReport")){				
			try{
				String clientid = request.getParameter("clientId");
				String date = request.getParameter("date");								
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				jsonArray=sandfunc.getDailyMonitorReport(systemId,clientid,date,offmin);
				
				if (jsonArray.length() > 0) {			
					jsonObject.put("dailymonitoringDetails", jsonArray);
				}
				else
				{
					jsonObject.put("dailymonitoringDetails", "");
				}				
				response.getWriter().print(jsonObject.toString());
			}	
			catch(Exception e)
			{
			e.printStackTrace();
			}
		}	
		
else if(param.equals("getHubArrDepReportNew")){
	jsonArray = new JSONArray();
	jsonObject = new JSONObject();
	String jspName="";
	Date date=new Date();
    String startDate=sdfddmmyyyy.format(date)+" 00:00:00";
    String endDate=cf.setNextDateForReports()+" 00:00:00";
	if(request.getParameter("jspName")!=null && request.getParameter("jspName")!="") 
	jspName	= request.getParameter("jspName");
	try{
	ArrayList<Object> hubdetails=sandfunc.getHubArrDepReportNew(systemId,clientId,userId,Zone,offmin,lang);
	jsonArray = (JSONArray) hubdetails.get(0);
	if (jsonArray.length() > 0) {
	jsonObject.put("hubArrDepNewRoot", jsonArray);
	}
	else
	{
	jsonObject.put("hubArrDepNewRoot", "");
	}	
	ReportHelper reportHelper = (ReportHelper) hubdetails.get(1);
	request.getSession().setAttribute(jspName, reportHelper);
	request.getSession().setAttribute("startdate", startDate);
	request.getSession().setAttribute("enddate", endDate);
	response.getWriter().print(jsonObject.toString());
	}
	
    catch(Exception e)
{
   e.printStackTrace();
}
 	
		
	
}
// Get Veh Without GPS
		
else if(param.equals("getVehWithoutGPSNew")){
	jsonArray = new JSONArray();
	jsonObject = new JSONObject();
	String jspName="";
	String sdate = request.getParameter("startdate");
	String edate = request.getParameter("enddate");

	if(request.getParameter("jspName")!=null && request.getParameter("jspName")!="") 
		jspName	= request.getParameter("jspName");
	try{
		ArrayList<Object> vehWithoutGPSDetails=sandfunc.getNoGPSVehicleReport(systemId,clientId,userId,offmin,sdate,edate);
			jsonArray = (JSONArray) vehWithoutGPSDetails.get(0);
		if (jsonArray.length() > 0) {
			jsonObject.put("VehWithoutGPSNewRoot", jsonArray);
		}
		else {
			jsonObject.put("VehWithoutGPSNewRoot", "");
		}	
			ReportHelper reportHelper = (ReportHelper) vehWithoutGPSDetails.get(1);
			request.getSession().setAttribute(jspName, reportHelper);
			response.getWriter().print(jsonObject.toString());
	}
    catch(Exception e){
    	e.printStackTrace();
    }
}
		
		
//****************************Unauthorized port entry count*********************************//
		
else if(param.equals("unauthorizedHubCount")){
	jsonArray = new JSONArray();
	jsonObject = new JSONObject();
	String jspName="";
	 String CustID=request.getParameter("CustID");
    //GroupID:Ext.getCmp('groupcomboid').getValue(),
    String startdate = request.getParameter("startdate");
    String  enddate = request.getParameter("enddate");
    jspName	= request.getParameter("jspName");
	
	if(request.getParameter("jspName")!=null && request.getParameter("jspName")!="") 
		jspName	= request.getParameter("jspName");
	try{
		ArrayList<Object> unauthorizedHubCount=sandfunc.getUnauthorizedHubCount(systemId,clientId,userId,offmin,startdate,enddate);
		jsonArray = (JSONArray) unauthorizedHubCount.get(0);
		if (jsonArray.length() > 0) { 
			jsonObject.put("unauthorizedHubCountRoot", jsonArray);
		}
		else {
			jsonObject.put("unauthorizedHubCountRoot", "");
		}	
			ReportHelper reportHelper = (ReportHelper) unauthorizedHubCount.get(1);
			request.getSession().setAttribute(jspName, reportHelper);
			response.getWriter().print(jsonObject.toString());
	}
    catch(Exception e){
    	e.printStackTrace();
    }
}
		//******************************** check Blocked vehicle details********************************//
else if (param.equals("CheckBlockedVehicles")) {
	try {
		String CustID=request.getParameter("CustId");
		String vehicleNo = request.getParameter("vehicleno");
		String message = sandfunc.CheckBlockedVehicles(vehicleNo,systemId,Integer.parseInt(CustID));
		response.getWriter().print(message);
	} catch (Exception e) {
		e.printStackTrace();
		System.out.println("Error in Blocking vehicle "+ e.toString());
	}
}
		//********************************Insert Blocked vehicle details********************************//
else if (param.equals("InsertBlockedVehicles")) {
	try {
		String CustID=request.getParameter("CustId");
		String vehicleNo = request.getParameter("vehicleno");
		String blockingReason = request.getParameter("blockingReason");
		String Remarks = request.getParameter("remarks");
		String message = sandfunc.InsertBlockedVehicles(vehicleNo, blockingReason,Remarks,systemId,Integer.parseInt(CustID),userId);
		response.getWriter().print(message);
	} catch (Exception e) {
		e.printStackTrace();
		System.out.println("Error in Blocking vehicle "+ e.toString());
	}
}
		//******************************** Get Blocked vehicle details********************************//
else if (param.equals("getBlockedVehicleDetails")) {
		jsonArray = new JSONArray();
		jsonObject = new JSONObject();
	    String startdate = request.getParameter("startdate");
	    String  enddate = request.getParameter("enddate");
	    String sdate=startdate.replaceAll("T"," ");
	    String edate=enddate.replaceAll("T"," ");
	    SimpleDateFormat yyyymmdd = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		SimpleDateFormat ddmmyyyy = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
		String s1date=ddmmyyyy.format(yyyymmdd.parse(startdate.replaceAll("T"," ")));
	    String e1date=ddmmyyyy.format(yyyymmdd.parse(enddate.replaceAll("T"," ")));
	    String jspName= request.getParameter("jspname");
	    
		try{
			ArrayList<Object> blockvehicles=sandfunc.getBlockedVehicleDetails(systemId,clientId,userId,offmin,sdate,edate);
			jsonArray = (JSONArray) blockvehicles.get(0);
			if (jsonArray.length() > 0) { 
				jsonObject.put("unblockSandRoot", jsonArray);
			}
			else {
				jsonObject.put("unblockSandRoot", "");
			}
			ReportHelper reportHelper = (ReportHelper) blockvehicles.get(1);
			request.getSession().setAttribute(jspName, reportHelper);
			request.getSession().setAttribute("startdate", s1date);
			request.getSession().setAttribute("enddate", e1date);
			response.getWriter().print(jsonObject.toString());
		}
	    catch(Exception e){
	    	e.printStackTrace();
	    }
	}
		
		//********************************UnBlock vehicle details********************************//
else if (param.equals("UnBlockVehicles")) {
	try {
		String CustID=request.getParameter("CustId");
		String vehicleNo = request.getParameter("vehicleno");
		String blockingReason = request.getParameter("blockedReason");
		String blockedremarks = request.getParameter("blockedremarks");
		String blockeddate = request.getParameter("blockeddate");
		String unblockingReason = request.getParameter("unblockingReason");
		String Remarks = request.getParameter("remarks");
		String blockedby=request.getParameter("blockedby");
		String id=request.getParameter("Id");
		String checkPenalty= request.getParameter("checkPenalty");
		String penaltyAmt= request.getParameter("checkPenaltyAmt");
		String message = sandfunc.UnBlockVehicles(vehicleNo, blockingReason,blockedremarks,blockeddate,Integer.parseInt(blockedby),unblockingReason,Remarks,systemId,Integer.parseInt(CustID),userId,Integer.parseInt(id),checkPenalty,penaltyAmt);
		response.getWriter().print(message);
	} catch (Exception e) {
		e.printStackTrace();
		System.out.println("Error in Blocking vehicle "+ e.toString());
	}
}
		//********************************Block UnBlock Vehicles Report********************************//
else if (param.equals("getBlockedUnblockedReport")) {
		 jsonArray = new JSONArray();
		 jsonObject = new JSONObject();
		 String jspName="";
		 String startdate = "";
		 String  enddate ="";
		 String edate="";
		 String e1date="";
		 String sdate="";
		 String s1date="";
		 String type="";
		 SimpleDateFormat yyyymmdd = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		 SimpleDateFormat ddmmyyyy = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
		 if(request.getParameter("startdate")!=null && request.getParameter("startdate")!=""){
			startdate = request.getParameter("startdate"); 
			sdate=startdate.replaceAll("T"," ");
			s1date=ddmmyyyy.format(yyyymmdd.parse(startdate.replaceAll("T"," ")));
		 }
		 if(request.getParameter("enddate")!=null && request.getParameter("enddate")!=""){
	     enddate = request.getParameter("enddate");
	     edate=enddate.replaceAll("T"," ");
	     e1date=ddmmyyyy.format(yyyymmdd.parse(enddate.replaceAll("T"," ")));
		 }
	     if(request.getParameter("jspname")!=null && request.getParameter("jspname")!="") {
		 jspName= request.getParameter("jspname");
	     }
	     if(request.getParameter("type")!=null && request.getParameter("type")!="") {
		 type=request.getParameter("type");
	     }
		 try{
			 ArrayList<Object> getVehicleReport = sandfunc.getBlockedUnblockedReport(systemId,clientId,userId,offmin,sdate,edate,type);
			 jsonArray = (JSONArray) getVehicleReport.get(0);
			 if (jsonArray.length() > 0) { 
					jsonObject.put("blockUnblockReportRoot", jsonArray);
				}
				else {
					jsonObject.put("blockUnblockReportRoot", "");
				}
			 ReportHelper reportHelper = (ReportHelper) getVehicleReport.get(1);
			 request.getSession().setAttribute(jspName,reportHelper);
			 request.getSession().setAttribute("startdate",s1date);
			 request.getSession().setAttribute("enddate",e1date);
			 request.getSession().setAttribute("type",type);
			 response.getWriter().print(jsonObject.toString());
		 	}
		    catch(Exception e){
		    	e.printStackTrace();
		    }
}

		else if (param.equalsIgnoreCase("getRegisteredVehicles")) {
			try {
				jsonObject = new JSONObject();
				jsonArray = sandfunc.getRegisteredVehicles(systemId, clientId, userId);
				if (jsonArray.length() > 0) {
					jsonObject.put("VehiclesRoot", jsonArray);
				} else {
					jsonObject.put("VehiclesRoot", "");
				}
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {
				System.out.println("Error in Sand Mining Action:-VehiclesRoot " + e.toString());
			}
		}
		else if(param.equals("getAnalyticalWeighBridgeReport")){
			try {
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				String jspName = null;
				SimpleDateFormat yyyyMMdd = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
				SimpleDateFormat ddmmyyyy = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
				
//				String startdate = request.getParameter("startdate");
//				SimpleDateFormat startDateFormatter=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss"); 
//				Date stratingDate=startDateFormatter.parse(startdate);  
//				String enddate = request.getParameter("enddate");
//				SimpleDateFormat endDateFormatter=new SimpleDateFormat("dd-MMM-yyyy HH:mm:ss"); 
//				Date endingDate=startDateFormatter.parse(enddate); 
				
				String startDate = yyyyMMdd.format(ddmmyyyy.parse(request.getParameter("startDate")));
				String endDate = yyyyMMdd.format(ddmmyyyy.parse(request.getParameter("endDate")));
				
				if (request.getParameter("jspName") != null)
					jspName = request.getParameter("jspName");
				else
					jspName = "";
				jsonArray =sandfunc.getAnalyticalWeighBridgeReportDetails(systemId,clientId,startDate,endDate);
				if(jsonArray.length()>0){
					jsonObject.put("AnalyticalWeighBridgeReport", jsonArray);
				}else {
					jsonObject.put("AnalyticalWeighBridgeReport", "");
				}
				response.getWriter().print(jsonObject.toString());
			}
			catch(Exception e){
				
			}
		 }
		return null;
	}

}