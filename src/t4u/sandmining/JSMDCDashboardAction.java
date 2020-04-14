package t4u.sandmining;

import java.text.SimpleDateFormat;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.struts.action.Action;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.json.simple.parser.JSONParser;

import com.mongodb.util.JSON;

import t4u.beans.LoginInfoBean;
import t4u.functions.SandMiningFunctions;

public class JSMDCDashboardAction extends Action {

	public ActionForward execute(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {

		HttpSession session = request.getSession();
		LoginInfoBean loginInfo = (LoginInfoBean) session
				.getAttribute("loginInfoDetails");
		int systemId = loginInfo.getSystemId();
		int customerId = loginInfo.getCustomerId();
		int userId = loginInfo.getUserId();
		int offmin = loginInfo.getOffsetMinutes();
		int isLtsp = loginInfo.getIsLtsp();
		int nonCommHrs=loginInfo.getNonCommHrs();
		String zone = loginInfo.getZone();
		SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
		SimpleDateFormat yyyyMMdd = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		SimpleDateFormat ddmmyyyy = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
		System.out.println("---------------------------JSMDC Dashboard-----------------------------------");
		JSONArray jsonArray = null;
		SandMiningFunctions sandfunc = new SandMiningFunctions();
		String param = "";
		if (request.getParameter("param") != null) {
			param = request.getParameter("param").toString();
		}

		if (param.equals("getJSMDCDistict")) {
			JSONObject jsonObject = new JSONObject();
			jsonArray = sandfunc.getJSMDCDistrict();
			jsonObject.put("districts", jsonArray);
			response.getWriter().print(jsonObject.toString());
		} else if (param.equals("getJSMDCStockyard")) {
			JSONObject jsonObject = new JSONObject();
			Integer districtId = Integer.valueOf(request
					.getParameter("districtId"));
			jsonArray = sandfunc.getJSMDCStockyardByDistrictId(districtId);
			jsonObject.put("stockyards", jsonArray);
			response.getWriter().print(jsonObject.toString());
		} else if (param.equals("getJSMDCStockyardInfo")) {
			JSONObject jsonObject = new JSONObject();
			Integer stockyardId = Integer.valueOf(request
					.getParameter("stockyardId"));
			jsonArray = sandfunc.getJSMDCStockyardInfoById(stockyardId,
					systemId, customerId, userId, nonCommHrs);
			jsonObject.put("stockyardInfo", jsonArray);
			response.getWriter().print(jsonObject.toString());
		} else if (param.equals("getJSMDCStockyardDetails")) {
			JSONObject jsonObject = new JSONObject();
			jsonArray = sandfunc.getJSMDCStockyardDetails();
			jsonObject.put("stockyardInfo", jsonArray);
			response.getWriter().print(jsonObject.toString());
		}

		else if (param.equals("getAllJSMDCUsers")) {
			JSONObject jsonObject = new JSONObject();
			jsonArray = sandfunc.getAllJSMDCUsers();
			jsonObject.put("JSMDCUser", jsonArray);
			response.getWriter().print(jsonObject.toString());
		} else if (param.equals("getAllJSMDCStockyards")) {
			Integer districtId = Integer.valueOf(request
					.getParameter("districtId"));
			JSONObject jsonObject = new JSONObject();
			jsonArray = sandfunc.getJSMDCHubsOnDistrict(districtId);
			jsonObject.put("Hubs", jsonArray);
			response.getWriter().print(jsonObject.toString());
		}
		 else if (param.equals("activeInactiveStockyardOrUser")) {
				Integer id = Integer.valueOf(request
						.getParameter("id"));
				String type=request.getParameter("type");
				Boolean value=Boolean.valueOf(request.getParameter("value"));
				 int updatedRecords=sandfunc.activeInactiveStockyardOrUser(id,type,value);
				 if(updatedRecords>0)
				 {
					 response.getWriter().print("Updated");
				 }
				 else
				 {
					 response.getWriter().print("Failure");
				 }
			}
		 else if (param.equals("configureStockyard")) {
			 Integer id = Integer.valueOf(request
						.getParameter("id"));
				Integer totalPermit = Integer.valueOf(request
						.getParameter("totalPermit"));
				Integer bookingLimit=Integer.valueOf(request.getParameter("bookingLimit"));
				Integer noOfTripsForDay=Integer.valueOf(request.getParameter("noOfTripsForDay"));
				 int updatedRecords=sandfunc.configureStockyard(totalPermit,bookingLimit,noOfTripsForDay,id);
				 if(updatedRecords>0)
				 {
					 response.getWriter().print("Updated");
				 }
				 else
				 {
					 response.getWriter().print("Failure");
				 }
			}
		 else if (param.equals("getStockyardInfoForConfiguration")) {
				Integer stockyardId = Integer.valueOf(request
						.getParameter("stockyardId"));
				  jsonArray=sandfunc.getStockyardInfoForConfiguration(stockyardId);
					 response.getWriter().print(jsonArray.toString());
			}
		else if(param.equals("getReportDetails")){
			JSONObject jsonObject = new JSONObject();
			Integer stockyardId=Integer.valueOf(request.getParameter("stockyardId"));
		//	String startDate = yyyyMMdd.format(ddmmyyyy.parse(request.getParameter("startDate")));
		//	String endDate = yyyyMMdd.format(ddmmyyyy.parse(request.getParameter("endDate")));
			jsonArray=sandfunc.getReportDetails(stockyardId,systemId,customerId,userId);
			jsonObject.put("reportDetails", jsonArray);
			response.getWriter().print(jsonObject.toString());
		}
		else if(param.equals("getSandStockReportDetails")){
			JSONObject jsonObject = new JSONObject();
			Integer stockyardId=Integer.valueOf(request.getParameter("stockyardId"));
			//String startDate = yyyyMMdd.format(ddmmyyyy.parse(request.getParameter("startDate")));
			//String endDate = yyyyMMdd.format(ddmmyyyy.parse(request.getParameter("endDate")));
			jsonArray=sandfunc.getSandStockReportDetails(stockyardId,systemId,customerId,userId);
			jsonObject.put("sandReportDetails", jsonArray);
			response.getWriter().print(jsonObject.toString());
		}
		else if(param.equals("getVehicleReportDetails")){
			JSONObject jsonObject = new JSONObject();
			Integer stockyardId=Integer.valueOf(request.getParameter("stockyardId"));
			String customerIds=request.getParameter("customerIds");
			//String startDate = yyyyMMdd.format(ddmmyyyy.parse(request.getParameter("startDate")));
			//String endDate = yyyyMMdd.format(ddmmyyyy.parse(request.getParameter("endDate")));
			jsonArray=sandfunc.getVehicleReportDetails(stockyardId,systemId,customerId,userId,customerIds);
			jsonObject.put("vehicleReportDetails", jsonArray);
			response.getWriter().print(jsonObject.toString());
		}
		else if(param.equals("getTripReportDetails")){
			JSONObject jsonObject = new JSONObject();
			Integer stockyardId=Integer.valueOf(request.getParameter("stockyardId"));
			//String startDate = yyyyMMdd.format(ddmmyyyy.parse(request.getParameter("startDate")));
			//String endDate = yyyyMMdd.format(ddmmyyyy.parse(request.getParameter("endDate")));
			jsonArray=sandfunc.getTripReportDetails(stockyardId,systemId,customerId,userId);
			jsonObject.put("tripReportDetails", jsonArray);
			response.getWriter().print(jsonObject.toString());
		}
		else if(param.equals("getStockyardReportDetails")){
			JSONObject jsonObject = new JSONObject();
			Integer stockyardId=Integer.valueOf(request.getParameter("stockyardId"));
			//String startDate = yyyyMMdd.format(ddmmyyyy.parse(request.getParameter("startDate")));
			//String endDate = yyyyMMdd.format(ddmmyyyy.parse(request.getParameter("endDate")));
			jsonArray=sandfunc.getStockyardReportDetails(stockyardId,systemId,customerId,userId);
			jsonObject.put("stockyardReportDetails", jsonArray);
			response.getWriter().print(jsonObject.toString());
		}
		else if(param.equals("getActiveSandReportDetails")){
			JSONObject jsonObject = new JSONObject();
			Integer stockyardId=Integer.valueOf(request.getParameter("stockyardId"));
			//String startDate = yyyyMMdd.format(ddmmyyyy.parse(request.getParameter("startDate")));
			//String endDate = yyyyMMdd.format(ddmmyyyy.parse(request.getParameter("endDate")));
			jsonArray=sandfunc.getActiveSandReportDetails(stockyardId,systemId,customerId,userId);
			jsonObject.put("activeSandReportDetails", jsonArray);
			response.getWriter().print(jsonObject.toString());
		}
	    else if (param.equals("updateIndiUserTypePerDay")) {
				Integer noOfTripsForDay=Integer.valueOf(request.getParameter("noOfTripsForPerDay"));
				 int updatedRecords=sandfunc.updateIndiUserTypePerDay(noOfTripsForDay);
				 if(updatedRecords>0)
				 {
					 response.getWriter().print("Updated");
				 }
				 else
				 {
					 response.getWriter().print("Failure");
				 }
		}
	    else if (param.equals("updateIndiUserTypePerWeek")) {
			Integer noOfTripsForPerWeek=Integer.valueOf(request.getParameter("noOfTripsForPerWeek"));
			 int updatedRecords=sandfunc.updateIndiUserTypePerWeek(noOfTripsForPerWeek);
			 if(updatedRecords>0)
			 {
				 response.getWriter().print("Updated");
			 }
			 else
			 {
				 response.getWriter().print("Failure");
			 }
	    }
	    else if (param.equals("updateIndiUserTypePerMonth")) {
			Integer noOfTripsForPerMonth=Integer.valueOf(request.getParameter("noOfTripsForPerMonth"));
			 int updatedRecords=sandfunc.updateIndiUserTypePerMonth(noOfTripsForPerMonth);
			 if(updatedRecords>0)
			 {
				 response.getWriter().print("Updated");
			 }
			 else
			 {
				 response.getWriter().print("Failure");
			 }
	   }	
	   else if (param.equals("getIndividualUserTypePerDayForConfiguration")) {
			jsonArray=sandfunc.getIndividualUserTypePerDayForConfiguration();
			response.getWriter().print(jsonArray.toString());
	   }
	   else if (param.equals("getIndividualUserTypePerWeekForConfiguration")) {
			jsonArray=sandfunc.getIndividualUserTypePerWeekForConfiguration();
			response.getWriter().print(jsonArray.toString());
	   }
	   else if (param.equals("getIndividualUserTypePerMonthForConfiguration")) {
			jsonArray=sandfunc.getIndividualUserTypePerMonthForConfiguration();
			response.getWriter().print(jsonArray.toString());
	   }
	   else if (param.equals("updateGovtUserTypePerDay")) {
			Integer noOfValuesForPerDay=Integer.valueOf(request.getParameter("noOfValuesForPerDay"));
			 int updatedRecords=sandfunc.updateGovtUserTypePerDay(noOfValuesForPerDay);
			 if(updatedRecords>0)
			 {
				 response.getWriter().print("Updated");
			 }
			 else
			 {
				 response.getWriter().print("Failure");
			 }
	   }
	   else if (param.equals("updateGovtUserTypePerWeek")) {
			Integer noOfValuesForPerWeek=Integer.valueOf(request.getParameter("noOfValuesForPerWeek"));
			 int updatedRecords=sandfunc.updateGovtUserTypePerWeek(noOfValuesForPerWeek);
			 if(updatedRecords>0)
			 {
				 response.getWriter().print("Updated");
			 }
			 else
			 {
				 response.getWriter().print("Failure");
			 }
	   }	
	   else if (param.equals("updateGovtUserTypePerMonth")) {
			Integer noOfValuesForPerMonth=Integer.valueOf(request.getParameter("noOfValuesForPerMonth"));
			 int updatedRecords=sandfunc.updateGovtUserTypePerMonth(noOfValuesForPerMonth);
			 if(updatedRecords>0)
			 {
				 response.getWriter().print("Updated");
			 }
			 else
			 {
				 response.getWriter().print("Failure");
			 }
	   }	
	   else if (param.equals("getGovtUserTypePerDayForConfiguration")) {
			jsonArray=sandfunc.getGovtUserTypePerDayForConfiguration();
			response.getWriter().print(jsonArray.toString());
	   }
	   else if (param.equals("getGovtUserTypePerWeekForConfiguration")) {
			jsonArray=sandfunc.getGovtUserTypePerWeekForConfiguration();
			response.getWriter().print(jsonArray.toString());
	   }
	   else if (param.equals("getGovtUserTypePerMonthForConfiguration")) {
			jsonArray=sandfunc.getGovtUserTypePerMonthForConfiguration();
			response.getWriter().print(jsonArray.toString());
	   }	
	   return null;
	}
}
