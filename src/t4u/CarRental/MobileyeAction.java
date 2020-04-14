package t4u.CarRental;

/**
 * @author amith.n
 *
 */

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
import t4u.functions.MobileyeFunctions;

public class MobileyeAction extends Action {
	public ActionForward execute(ActionMapping mapping, ActionForm form,HttpServletRequest request, HttpServletResponse response) throws Exception {
		try {
			HttpSession session = request.getSession();
			LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
			int isLtsp=2;
			int systemId = loginInfo.getSystemId();
			int customerId = loginInfo.getCustomerId();
			int userId = loginInfo.getUserId();
			int offmin = loginInfo.getOffsetMinutes();
			String lang = loginInfo.getLanguage();
			String zone=loginInfo.getZone();
			isLtsp=loginInfo.getIsLtsp();
			int nonCommHrs=loginInfo.getNonCommHrs();
			
			MobileyeFunctions mf=new MobileyeFunctions();
			JSONObject jsonObject = null;			
			JSONArray jsonArray = null;
			String param = "";
			if (request.getParameter("param") != null) {
				param = request.getParameter("param").toString();
			}
			if(param.equals("getMobileyeValidData"))
			{
				try {
					 String vehicle = request.getParameter("vehicleNo");
					 String startTime = request.getParameter("startDate");
					 String endTime = request.getParameter("endDate");
					 //endTime=endTime + "23:59:59";
					 
					jsonArray = new JSONArray();
					jsonObject = new JSONObject();
					jsonArray = mf.getMobileyeValidData(vehicle,startTime,endTime,offmin,systemId,customerId);
					if (jsonArray.length() > 0) {
						jsonObject.put("validMobileye", jsonArray);
					} else {
						jsonObject.put("validMobileye", "");
					}
					response.getWriter().print(jsonObject.toString());
				} catch (Exception e) {
					e.printStackTrace();
				}

			}else if(param.equals("getMobileyeInValidData"))
			{
				try {
					 String vehicle = request.getParameter("vehicleNo");
					 String startTime = request.getParameter("startDate");
					 String endTime = request.getParameter("endDate");
					 
					jsonArray = new JSONArray();
					jsonObject = new JSONObject();
					jsonArray = mf.getMobileyeInValidData(vehicle,startTime,endTime,offmin,systemId,customerId);
					if (jsonArray.length() > 0) {
						jsonObject.put("inValidMobileye", jsonArray);
					} else {
						jsonObject.put("inValidMobileye", "");
					}
					response.getWriter().print(jsonObject.toString());
				} catch (Exception e) {
					e.printStackTrace();
				}

			}else if(param.equals("getMobileyeTransactionDataPush"))
			{
				try {
					 String vehicle = request.getParameter("vehicleNo");
					 String startTime = request.getParameter("startDate");
					 String endTime = request.getParameter("endDate");
					jsonArray = new JSONArray();
					jsonObject = new JSONObject();
					jsonArray = mf.getMobileyeTransactionDataPush(vehicle,startTime,endTime,offmin,systemId,customerId);
					if (jsonArray.length() > 0) {
						jsonObject.put("validMobileye", jsonArray);
					} else {
						jsonObject.put("validMobileye", "");
					}
					response.getWriter().print(jsonObject.toString());
				} catch (Exception e) {
					e.printStackTrace();
				}

			}
			else if (param.equals("getVehicleNo")) {
				try {
					jsonObject = new JSONObject();
						jsonArray = mf.getRegistrationNoBasedOnUser(customerId, systemId, userId);
						jsonObject.put("VehicleNoRoot", jsonArray);
					
					response.getWriter().print(jsonObject.toString());
				} catch (Exception e) {
					System.out.println("Error in Mobileye Action:-getVehicleNo "+ e.toString());
				}
			}
			else if(param.equals("getMobileyeTransactionDataPull"))
			{
				try {
					 String vehicle = request.getParameter("vehicleNo");
					 String startTime = request.getParameter("startDate");
					 String endTime = request.getParameter("endDate");
					jsonArray = new JSONArray();
					jsonObject = new JSONObject();
					jsonArray = mf.getMobileyeTransactionDataPull(vehicle,startTime,endTime,offmin,systemId,customerId);
					if (jsonArray.length() > 0) {
						jsonObject.put("validMobileye", jsonArray);
					} else {
						jsonObject.put("validMobileye", "");
					}
					response.getWriter().print(jsonObject.toString());
				} catch (Exception e) {
					e.printStackTrace();
				}

			}

		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}
}