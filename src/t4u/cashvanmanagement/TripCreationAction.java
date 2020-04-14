package t4u.cashvanmanagement;

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
import t4u.functions.CommonFunctions;
import t4u.functions.TripCreationFunctions;

/**
 * @author Santhosh
 * 
 */

public class TripCreationAction extends Action {

	@SuppressWarnings({ "unchecked" })
	public ActionForward execute(ActionMapping mapping, ActionForm form,HttpServletRequest request, HttpServletResponse response)throws Exception {

		String param = "";
		String message = "";		
		HttpSession session = request.getSession();
		LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");

		int systemId = loginInfo.getSystemId();
		int userId = loginInfo.getUserId();
		int offset = loginInfo.getOffsetMinutes();
		String lang = loginInfo.getLanguage();
		ReportHelper reportHelper =null;

		CommonFunctions cf = new CommonFunctions();
		TripCreationFunctions tripcreationfunction = new TripCreationFunctions();
		JSONArray jsonArray = null;
		JSONObject jsonObject = new JSONObject();

		if (request.getParameter("param") != null) {
			param = request.getParameter("param").toString();
		}

		// ****************************** GET VEHICLE NO*****************************

		if (param.equalsIgnoreCase("getVehicles")) {
			String StartDate="";
			String ClientId = request.getParameter("CustId");
			StartDate=request.getParameter("sdate");
			if (ClientId != null && !ClientId.equals("")) {
				JSONArray jsonarray = null;
				try {
					jsonarray = tripcreationfunction.getVehicleNoWithVendorName(ClientId, systemId, userId,StartDate);
					if (jsonarray.length() > 0) {
						jsonObject.put("VehicleRoot", jsonarray);
					} else {
						jsonObject.put("VehicleRoot", "");
					}
					response.getWriter().print(jsonObject.toString());
				} catch (Exception e) {
					e.printStackTrace();
				}
			}

		}
		// **************************** GET TRIP STATUS ***************************
		if (param.equalsIgnoreCase("getTripStatus")) {

			String ClientId = request.getParameter("CustId");
			String type="TRIPSTATUS";
			JSONArray jsonarray = null;
			if (ClientId != null && !ClientId.equals("")) {

				try {
					jsonarray = tripcreationfunction.getTripStatus(ClientId, systemId, type);
					if (jsonarray.length() > 0) {
						jsonObject.put("tripStatusRoot", jsonarray);
					} else {
						jsonObject.put("tripStatusRoot", "");
					}
					response.getWriter().print(jsonObject.toString());
				} catch (Exception e) {
					e.printStackTrace();
				}

			}
		}

		// **************************** GET REASON OFF ROUTE DETAILS ***************************

		if (param.equalsIgnoreCase("getReasonOffRouteRoadStatus")) {

			String ClientId = request.getParameter("CustId");
			String type="VECHILEREASONS";
			JSONArray jsonarray = null;
			if (ClientId != null && !ClientId.equals("")) {
				try {
					jsonarray = tripcreationfunction.getReasonOffRouteRoadStatus(ClientId, systemId, type);
					if (jsonarray.length() > 0) {
						jsonObject.put("reasonRoot", jsonarray);
					} else {
						jsonObject.put("reasonRoot", "");
					}
					response.getWriter().print(jsonObject.toString());
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		}

		// ******************************** SAVE TRIP DETAILS ************************************

		if (param.equals("saveormodifyAssetGroup")) {
			String reason = "";
			String hiredVehicleNo = "";
			String hiredAmount = "0.0";
			String hiredVehicleKMS ="0.0";
			String reasonIdsModify="";
			String buttonValue="";
		    String cutomerId = "";
			String startDateTime = "";
			String state = "";
			String location ="";
			String vehicleNumber ="";
			String tripStatusId = "";
			String openingOdo = "0.0";
		    String stateModify ="";
			String uniqueid ="";
			String stateModifyName="";
			String statusIdModify="";
			String statusNameModify="";	    
			String ReasonNameModify = null;
			double marketVehicleAmount = 0.0;
			double marketVehiclekms = 0.0;
			try {
				String ownValue=request.getParameter("radioOvalue");
				String marValue=request.getParameter("radioMvalue");
				if(ownValue.equals("true")){
				buttonValue = request.getParameter("buttonValue");
				cutomerId = request.getParameter("customerID");
				startDateTime = request.getParameter("startDateTime");
				state = request.getParameter("state");
				location = request.getParameter("location");
				vehicleNumber = request.getParameter("vehicleNumber").toUpperCase();
				tripStatusId = request.getParameter("StatusId");
				openingOdo = request.getParameter("openingKMS");
				if (tripStatusId.equals("Off Route") || tripStatusId.equals("Off Road")) {
					reason = request.getParameter("reason");
					hiredVehicleNo = request.getParameter("hiredVehicleNo").toUpperCase();
					hiredAmount = request.getParameter("hiredAmount");
					hiredVehicleKMS = request.getParameter("hiredVehicleKMS");
				} 
				 stateModify = request.getParameter("stateModify");
				 uniqueid = request.getParameter("uniqueId");
				 stateModifyName=request.getParameter("stateModifyName");
				 statusIdModify=request.getParameter("statusIdModify");
				 statusNameModify=request.getParameter("statusNameModify");
				if (statusNameModify.equals("Off Route") || statusNameModify.equals("Off Road")) {
					reasonIdsModify=request.getParameter("reasonIdsModify");
					ReasonNameModify=request.getParameter("reasonNameModify");
					hiredVehicleNo = request.getParameter("hiredVehicleNo").toUpperCase();
					hiredAmount = request.getParameter("hiredAmount");
					hiredVehicleKMS = request.getParameter("hiredVehicleKMS");
				} 
				}else if(marValue.equals("true")){
					 buttonValue = request.getParameter("buttonValue");
					 cutomerId = request.getParameter("customerID");
					 startDateTime = request.getParameter("startDateTime");
					 state = request.getParameter("state");
					 location = request.getParameter("location");
					 hiredVehicleNo = request.getParameter("hiredVehicleNo").toUpperCase();
					 marketVehicleAmount = Double.parseDouble(request.getParameter("hiredAmount"));
					 marketVehiclekms =  Double.parseDouble(request.getParameter("hiredVehicleKMS"));
					 stateModify = request.getParameter("stateModify");
					 uniqueid = request.getParameter("uniqueId");
				     stateModifyName=request.getParameter("stateModifyName");
			}
				message = "";
				String startTime ="";
				if (startDateTime.contains("T")) {
					startDateTime = startDateTime.substring(0,startDateTime.indexOf("T"))+ " "+ startDateTime.substring(startDateTime.indexOf("T") + 1, startDateTime.length());
					startDateTime = cf.getFormattedDateStartingFromMonth(startDateTime);
					startTime = cf.getGMTDateTime(startDateTime, offset);
				}
				
				if (buttonValue.equals("add")) {

					if (cutomerId != null || startDateTime != null
							|| state != null || location != null || vehicleNumber != null
							|| tripStatusId != null || reason != null
							|| openingOdo != null ||hiredVehicleNo!=null||hiredAmount!=null
							|| hiredVehicleKMS != null) {
						
						message = tripcreationfunction.saveTripInformation(ownValue,marValue,
								cutomerId,startDateTime,state,location,vehicleNumber,tripStatusId,
								reason,Double.parseDouble(openingOdo),hiredVehicleNo,hiredAmount,hiredVehicleKMS,systemId,offset,startTime,marketVehicleAmount,marketVehiclekms);
					}

				} else if (buttonValue.equals("modify")) {

					if (cutomerId != null || startDateTime != null
							|| state != null || location != null || vehicleNumber != null
							|| tripStatusId != null || ReasonNameModify != null
							|| openingOdo != null ||hiredVehicleNo!=null||hiredAmount!=null && !hiredAmount.equals("")
							|| hiredVehicleKMS != null && !hiredVehicleKMS.equals("")) {
							message = tripcreationfunction.modifyTripInformation(ownValue,marValue,
								cutomerId,startDateTime,stateModify,stateModifyName,location,vehicleNumber,statusIdModify,statusNameModify,
								reasonIdsModify,ReasonNameModify,openingOdo,hiredVehicleNo,hiredAmount,hiredVehicleKMS,systemId,Integer.parseInt(uniqueid),marketVehicleAmount,marketVehiclekms);
					}
				}
				response.getWriter().print(message);
			} catch (Exception e) {
				e.printStackTrace();
				System.out.println("Error in Asset Group Action:-saveRmodifyAssetGroupDetails "+ e.toString());
			}
		}

		// *********************************** GETTING TRIP DETAILS ************************************

		if (param.equalsIgnoreCase("getTripDetails")) {
			String CustomerId = request.getParameter("CustID");
			String startdate = request.getParameter("startdate");
			String enddate = request.getParameter("enddate");
			String custName = request.getParameter("custName");
			String jspName = request.getParameter("jspName");
			String startdates="";
			String enddates="";
				try {
					jsonArray = new JSONArray();
					jsonObject = new JSONObject();
					if (CustomerId != null && !CustomerId.equals("") && startdate != null && !startdate.equals("")  && enddate != null && !enddate.equals("") ) {
						
					if (startdate.contains("T")) {
						startdate = startdate.substring(0, startdate.indexOf("T"))
						+ " "
						+ startdate.substring(startdate.indexOf("T") + 1,
								startdate.length());
						startdate = cf.getFormattedDateStartingFromMonth(startdate);
					}

					if (enddate.contains("T")) {
						enddate = enddate.substring(0, enddate.indexOf("T"))
						+ " "
						+ enddate.substring(enddate.indexOf("T") + 1,
								enddate.length());
						enddate = cf.getFormattedDateStartingFromMonth(enddate);
					}
					ArrayList list1 = tripcreationfunction.getTripCreationDetails(CustomerId, startdate, enddate, systemId, offset, lang);
					jsonArray = (JSONArray) list1.get(0);
					if (jsonArray.length() > 0) {
						jsonObject.put("TripCreationRoot", jsonArray);
					} else {
						jsonObject.put("TripCreationRoot", "");
					}
					startdates=tripcreationfunction.getFormattedDateStartingFromMonth(startdate);
					enddates=tripcreationfunction.getFormattedDateStartingFromMonth(enddate);
					reportHelper = (ReportHelper) list1.get(1);
					}else{
						jsonObject.put("TripCreationRoot", "");
					}
					request.getSession().setAttribute(jspName, reportHelper);
					request.getSession().setAttribute("customerid", custName);
					request.getSession().setAttribute("startdate",startdates);
					request.getSession().setAttribute("enddate",enddates);
					response.getWriter().print(jsonObject.toString());
				} catch (Exception e) {
					e.printStackTrace();
				}
		}
		
		//*************************************Day Wise No Show Report Details*****************************************************//
		if (param.equalsIgnoreCase("getDayWiseNoShowTripDetails")) {
			String CustomerId = request.getParameter("CustID");
			String startdate = request.getParameter("startdate");
			String custName = request.getParameter("custName");
			String jspName = request.getParameter("jspName");
				try {
					jsonArray = new JSONArray();
					jsonObject = new JSONObject();
					if (CustomerId != null && !CustomerId.equals("") && startdate != null && !startdate.equals("")) {
					if (startdate.contains("T")) {
						startdate = startdate.substring(0, startdate.indexOf("T"))
						+ " "
						+ startdate.substring(startdate.indexOf("T") + 1,
								startdate.length());
						startdate = cf.getFormattedDateStartingFromMonth(startdate);
					}
					ArrayList list1 = tripcreationfunction.getDayWiseNoShowTripDetails(CustomerId, startdate, systemId, offset, lang,userId);
					jsonArray = (JSONArray) list1.get(0);
					if (jsonArray.length() > 0) {
						jsonObject.put("DayWiseNoShowRoot", jsonArray);
					} else {
						jsonObject.put("DayWiseNoShowRoot", "");
					}
					String Rstartdates=tripcreationfunction.getFormattedDateStartingFromMonth(startdate);
					reportHelper = (ReportHelper) list1.get(1);
					request.getSession().setAttribute(jspName, reportHelper);
					request.getSession().setAttribute("customerid", custName);
					request.getSession().setAttribute("startdate",Rstartdates);
					response.getWriter().print(jsonObject.toString());
			}else {
					jsonObject.put("DayWiseNoShowRoot", "");
					response.getWriter().print(jsonObject.toString());
			}
				} catch (Exception e) {
					e.printStackTrace();
			}
		}
		
		//************************************************For Deleting Opened Trip********************************************//
		if(param.equals("deleteOpenedTrip")){
				String customerId = request.getParameter("custId");
				String vehicleNumber =request.getParameter("vehicleNumber").toUpperCase();
				String uid = request.getParameter("uniqueId");
				try{
					if (customerId != null || vehicleNumber != null ) {
							message = tripcreationfunction.deleteOpenedTrip(customerId,vehicleNumber,
									systemId,uid);
					}
					response.getWriter().print(message);
					}catch(Exception e){
						System.out.println("error in deleting....>"+e);
					}
		}
		return null;
	}
}
