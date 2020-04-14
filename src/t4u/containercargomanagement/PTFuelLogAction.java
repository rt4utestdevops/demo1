package t4u.containercargomanagement;

import java.util.ArrayList;
import java.util.List;

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
import t4u.functions.ContainerCargoManagementFunctions;

public class PTFuelLogAction extends Action {
	/* (non-Javadoc)
	 * @see org.apache.struts.action.Action#execute(org.apache.struts.action.ActionMapping, org.apache.struts.action.ActionForm, javax.servlet.http.HttpServletRequest, javax.servlet.http.HttpServletResponse)
	 */
	public ActionForward execute(ActionMapping mapping, ActionForm form,HttpServletRequest request, HttpServletResponse response) throws Exception {
		HttpSession session = request.getSession();
		LoginInfoBean loginInfo =(LoginInfoBean)session.getAttribute("loginInfoDetails");
		int systemId  = loginInfo.getSystemId();
		int customerId = loginInfo.getCustomerId();
		int userId = loginInfo.getUserId();
		int offset = loginInfo.getOffsetMinutes();
		String language = loginInfo.getLanguage();
		ContainerCargoManagementFunctions ccmf = new ContainerCargoManagementFunctions();
		JSONArray jsonArray = null;
		JSONObject jsonObject=null;
		String param = "";
		if (request.getParameter("param") != null) {
			param = request.getParameter("param").toString();
		}
		if (param.equals("getVehicles")) {
			try {
				jsonObject = new JSONObject();
				jsonArray = ccmf.getVehicles( systemId, String.valueOf(customerId), userId);
				if (jsonArray.length() > 0) {
					jsonObject.put("vehicleStoreRoot", jsonArray);
				} else {
					jsonObject.put("vehicleStoreRoot", "");
				}
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		else if (param.equals("getVehiclesAll")) {
			try {
				jsonObject = new JSONObject();
				jsonArray = ccmf.getVehiclesAll( systemId, String.valueOf(customerId), userId);
				if (jsonArray.length() > 0) {
					jsonObject.put("allVehicleStoreRoot", jsonArray);
				} else {
					jsonObject.put("allVehicleStoreRoot", "");
				}
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		if (param.equals("getVehiclesNotInTrip")) {
			try {
				jsonObject = new JSONObject();
				jsonArray = ccmf.getVehiclesNotOnTrip( systemId, customerId, userId);
				if (jsonArray.length() > 0) {
					jsonObject.put("fuelResetVehicleStoreRoot", jsonArray);
				} else {
					jsonObject.put("fuelResetVehicleStoreRoot", "");
				}
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		if (param.equals("getFuelLogData")) {
			String vehId = request.getParameter("vehId");
			String startDate = request.getParameter("startDate");
			String endDate = request.getParameter("endDate");
			String jspName = request.getParameter("jspName");
			try {
				jsonObject = new JSONObject();
				ArrayList<Object> fuelLogDetails= ccmf.getFuelLogData(customerId, systemId, offset, vehId, startDate, endDate,language);
				jsonArray = (JSONArray) fuelLogDetails.get(0);
				if (jsonArray.length() > 0) {
					jsonObject.put("FuelLogRoot", jsonArray);
					
					ReportHelper reportHelper = (ReportHelper) fuelLogDetails.get(1);
					request.getSession().setAttribute(jspName, reportHelper);
					request.getSession().setAttribute("vehId", vehId);
					request.getSession().setAttribute("sdate",startDate.replace("T", " "));
					request.getSession().setAttribute("edate",endDate.replace("T", " "));
				} else {
					jsonObject.put("FuelLogRoot", "");
				}
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {
				e.printStackTrace();
		    }
		}	
		if(param.equals("getFuelVendor")) {

			try {
				jsonObject = new JSONObject();
				jsonArray = ccmf.getFuelVendor(String.valueOf(customerId), systemId);
				if(jsonArray.length() > 0) {
					jsonObject.put("FuelVendorStoreRoot", jsonArray);
				} else {
					jsonObject.put("FuelVendorStoreRoot", "");
				}
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		else if (param.equals("saveFuelLog")) {
			try {
				String buttonValue = request.getParameter("buttonValue");
				String fuelVendorName = request.getParameter("fuelVendorName");
				String dateVal = request.getParameter("dateVal").replace("T", " ");
				String vhitxt = request.getParameter("vhitxt");
				String fuelVendorId = request.getParameter("fuelVendorId");
				String netPrice=request.getParameter("netPrice");
				String refillQty=request.getParameter("refillQty");
				String refillAmt = request.getParameter("refillAmt");				
				String message = "";								
					if (buttonValue.equals("add")) {						 
						message = ccmf.saveFuelLogDetails(fuelVendorName, fuelVendorId, netPrice, refillQty, refillAmt, dateVal, customerId,systemId, vhitxt, offset);
					}
						response.getWriter().print(message);					 
				} catch (Exception e) {
				e.printStackTrace();
			}
		}
		else if(param.equals("getAvailableFuel")){
			String assetNo = request.getParameter("assetNo");
			List<Object> availableFuelDetails = ccmf.getStartingFuel(systemId, customerId, assetNo, offset);
			System.out.println(availableFuelDetails.toString());
			
			jsonObject = new JSONObject();
			jsonArray = new JSONArray();
			
			if(availableFuelDetails.size() > 0) {
				jsonObject.put("tripNo", availableFuelDetails.get(0));
				jsonObject.put("availFuelInLtrs", availableFuelDetails.get(1));
				jsonObject.put("availFuelCost", availableFuelDetails.get(2));
			} else {
				jsonObject.put("tripNo", "");
				jsonObject.put("availFuelInLtrs", 0);
				jsonObject.put("availFuelCost", 0);
			}
			jsonArray.put(jsonObject);
			
			jsonObject = new JSONObject();
			if(jsonArray.length() > 0){
				jsonObject.put("availFuelStoreRoot", jsonArray);
			} else {
				jsonObject.put("availFuelStoreRoot", "");
			}
			
			response.getWriter().write(jsonObject.toString());
		}
		else if (param.equals("saveFuelReset")) {
			try {
				String message = "";	
				String buttonValue = request.getParameter("buttonValue");
				String assetNo = request.getParameter("assetNo");
				String availFuel = request.getParameter("availFuel");
				String resetFuel=request.getParameter("resetFuel");
				String tripNo = request.getParameter("tripNo");
				String availFuelCost = request.getParameter("availFuelCost");
				
					if (buttonValue.equals("modify")) {						 
						message = ccmf.saveFuelResetDetails(systemId, customerId, resetFuel, availFuel, assetNo, tripNo, availFuelCost, userId);
					}
						response.getWriter().print(message);					 
				} catch (Exception e) {
				e.printStackTrace();
			}
		}
		else if (param.equals("getFuelResetData")){
			String vehId = request.getParameter("vehId");
			String startDate = request.getParameter("startDate");
			String endDate = request.getParameter("endDate");
			String jspName = request.getParameter("jspNameFuelReset");
			
			try {
				jsonObject = new JSONObject();
				ArrayList<Object> fuelResetDetails= ccmf.getFuelResetData(customerId, systemId, offset, vehId, startDate, endDate,language);
				jsonArray = (JSONArray) fuelResetDetails.get(0);
				if (jsonArray.length() > 0) {
					jsonObject.put("FuelResetRoot", jsonArray);
					
					ReportHelper reportHelper = (ReportHelper) fuelResetDetails.get(1);
					request.getSession().setAttribute(jspName, reportHelper);
					request.getSession().setAttribute("vehId", vehId);
					request.getSession().setAttribute("sdate",startDate);
					request.getSession().setAttribute("edate",endDate);
				} else {
					jsonObject.put("FuelResetRoot", "");
				}
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {
				e.printStackTrace();
		    }
		}
		return null;
	}
}
