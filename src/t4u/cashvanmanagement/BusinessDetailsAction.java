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
import t4u.functions.CommonFunctions;
import t4u.functions.TripCreationFunctions;

/**
 * @author Santhosh
 * 
 */

public class BusinessDetailsAction extends Action {
	@SuppressWarnings("unused")
	public ActionForward execute(ActionMapping mapping, ActionForm form,HttpServletRequest request, HttpServletResponse response)throws Exception {

		String param = "";
		String message = "";		
		HttpSession session = request.getSession();
		LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");

		int systemId = loginInfo.getSystemId();
		int userId = loginInfo.getUserId();
		int offset = loginInfo.getOffsetMinutes();
		String lang = loginInfo.getLanguage();

		CommonFunctions cf = new CommonFunctions();
		TripCreationFunctions tripcreationfunction = new TripCreationFunctions();
		JSONArray jsonArray = null;
		JSONObject jsonObject = new JSONObject();

		if (request.getParameter("param") != null) {
			param = request.getParameter("param").toString();
		}
		if (param.equalsIgnoreCase("getBusinessType")) {
			String ClientId = request.getParameter("CustId");
			String type="BUSINESSTYPE";
				JSONArray jsonarray = null;
				try {
					jsonarray = tripcreationfunction.getBusinessType(type);
					if (jsonarray.length() > 0) {
						jsonObject.put("BusinessTypeRoot", jsonarray);
					} else {
						jsonObject.put("BusinessTypeRoot", "");
					}
					response.getWriter().print(jsonObject.toString());
				} catch (Exception e) {
					e.printStackTrace();
				}
		}
		//**************************************GETTING ROUTE ID DETAILS************************************//
		else if (param.equalsIgnoreCase("getRouteId")) {
			String ClientId = request.getParameter("CustId");
				JSONArray jsonarray = null;
				try {
					jsonarray = tripcreationfunction.getRouteId(ClientId,systemId);
					if (jsonarray.length() > 0) {
						jsonObject.put("routeTypeRoot", jsonarray);
					} else {
						jsonObject.put("routeTypeRoot", "");
					}
					response.getWriter().print(jsonObject.toString());
				} catch (Exception e) {
					e.printStackTrace();
				}
		}
		else if (param.equalsIgnoreCase("getCVSCustomer")) {
			String ClientId = request.getParameter("CustId");
				JSONArray jsonarray = null;
				try {
					jsonarray = tripcreationfunction.getCVSCustomer(ClientId,systemId);
					//System.out.println("jsonarray == "+jsonarray);
					if (jsonarray.length() > 0) {
						jsonObject.put("CVSCustomerRoot", jsonarray);
					} else {
						jsonObject.put("CVSCustomerRoot", "");
					}
					response.getWriter().print(jsonObject.toString());
				} catch (Exception e) {
					e.printStackTrace();
				}
		}
		else if (param.equalsIgnoreCase("getCVSCustomerDetails")) {
			String ClientId = request.getParameter("CustId");
			String cvsCustId = request.getParameter("cvsCustId");
				JSONArray jsonarray = null;
				try {
					jsonarray = tripcreationfunction.getCVSCustomerDetails(Integer.parseInt(ClientId),systemId,Integer.parseInt(cvsCustId));
					//System.out.println("jsonarray == "+jsonarray);
					if (jsonarray.length() > 0) {
						jsonObject.put("CVSCustomerDetailsRoot", jsonarray);
					} else {
						jsonObject.put("CVSCustomerDetailsRoot", "");
					}
					response.getWriter().print(jsonObject.toString());
				} catch (Exception e) {
					e.printStackTrace();
				}
		}
		
		// *********************************** GETTING BUSINESS DETAILS ************************************

		else if (param.equalsIgnoreCase("getBusinessDetails")) {
			String customerId = request.getParameter("CustId");
				try {
					jsonArray = new JSONArray();
					jsonObject = new JSONObject();
					if (customerId != null && !customerId.equals("")) {
					ArrayList list1 = tripcreationfunction.getBusinessDetails(customerId, systemId);
					jsonArray = (JSONArray) list1.get(0);
					if (jsonArray.length() > 0) {
						jsonObject.put("businessDetailsRoot", jsonArray);
					} else {
						jsonObject.put("businessDetailsRoot", "");
					}
					}else{
						jsonObject.put("businessDetailsRoot", "");
					}
					response.getWriter().print(jsonObject.toString());
				} catch (Exception e) {
					e.printStackTrace();
				}
		}
		// ******************************** SAVE BUSINESS DETAILS ************************************

		if (param.equals("saveormodifyBusinessDetails")) {
			try {
				String buttonValue = request.getParameter("buttonValue");
				String cutomerId = request.getParameter("customerID");
				String businessId = request.getParameter("businessId");
				String businessType = request.getParameter("businessType");
				String bank = request.getParameter("bank");
				String address = request.getParameter("address");
				String email = request.getParameter("email");
				String region = request.getParameter("region");
				String hublocation = request.getParameter("hublocation");
				String routeId = request.getParameter("routeId");
				String latitude = request.getParameter("latitude");
				String longitude = request.getParameter("longitude");
				String uniqueid = request.getParameter("uniqueId");
				String routeName = request.getParameter("routeName");
				String status = request.getParameter("status");
				String radius = request.getParameter("radius");
				String uniqueRouteId = request.getParameter("uniqueRouteId");
				String cvscustomerId = "0";
				
	//System.out.println("cutomerId-->"+cutomerId+"businessId-->"+businessId+"businessType-->"+businessType+"msp-->"+msp+"Bank-->"+bank+"address-->"+address+"region-->"+region+"location-->"+location+"hublocation-->"+hublocation+"routeId-->"+routeId+"latitude-->"+latitude+"longitude-->"+longitude);						
				message = "";
				if( request.getParameter("cvscustomerId") != null && !request.getParameter("cvscustomerId").equals("")){
					cvscustomerId = request.getParameter("cvscustomerId");
					}
				if (buttonValue.equals("add")) {

					if (cutomerId != null || businessId != null
							|| businessType != null || bank != null
							|| address != null  || email != null || region != null
							|| hublocation != null ||routeId!=null||latitude!=null
							|| longitude != null||routeName!=null||status!=null||radius!=null) {
						
						message = tripcreationfunction.saveBusinessInformation(
								cutomerId,businessId,businessType,bank,address,email,region,
								hublocation,routeId,Double.parseDouble(latitude),Double.parseDouble(longitude),systemId,routeName,
								status,radius,userId,uniqueRouteId,cvscustomerId);
					}

				} else if (buttonValue.equals("modify")) {

					if (cutomerId != null || businessId != null
							|| businessType != null ||  bank != null
							|| address != null || email != null ||  region != null
							|| hublocation != null ||routeId!=null||latitude!=null
							|| longitude != null||routeName!=null||status!=null||radius!=null
							) {
							message = tripcreationfunction.modifyBusinessInformation(
								cutomerId,businessId,businessType,bank,address,email,region,
								hublocation,routeId,Double.parseDouble(latitude),Double.parseDouble(longitude),systemId,Integer.parseInt(uniqueid),
								status,routeName,radius,userId,uniqueRouteId);
					}
				}
				response.getWriter().print(message);
			} catch (Exception e) {
				e.printStackTrace();
				System.out.println("Error in Business Details Action:-saveRmodifyBusinessDetails "+ e.toString());
			}
		}

		return null;
	}
}
