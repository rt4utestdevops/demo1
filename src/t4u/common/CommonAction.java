package t4u.common;

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

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.internal.LinkedTreeMap;

import t4u.beans.LoginInfoBean;
import t4u.beans.ReportHelper;
import t4u.functions.CommonFunctions;
import t4u.functions.MenuListFunction;

/**
 * 
 * This Class is used to write common actions
 * 
 */
public class CommonAction extends Action {
	public ActionForward execute(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) {
		HttpSession session = request.getSession();
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonObject = new JSONObject();
		CommonFunctions cfuncs = new CommonFunctions();
		String serverName=request.getServerName();
		String sessionIds = request.getSession().getId();
		LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
		int systemId = loginInfo.getSystemId();
		int customerIdlogin = loginInfo.getCustomerId();
		int userId = loginInfo.getUserId();
		int offmin=loginInfo.getOffsetMinutes();
		int CountryCode=loginInfo.getCountryCode();
		int isLtsp=loginInfo.getIsLtsp();
		String sessionId=session.getId();
		String lang=loginInfo.getLanguage();
		String param = "";
		if (request.getParameter("param") != null) {
			param = request.getParameter("param").toString();
		}
		/**
		 * To get customer id and name from database
		 */
		if (param.equals("getCustomer")) {
			try {
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				String ltsp = "no";
				if (request.getParameter("paramforltsp") != null) {
					ltsp = request.getParameter("paramforltsp").toString();
				}

				jsonArray = cfuncs.getCustomer(systemId, ltsp, customerIdlogin);
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
		} else if (param.equals("getgroup")) {
			try {
				String clientIdSelected = request.getParameter("CustId");

				jsonObject = new JSONObject();
				if (clientIdSelected != null) {
					jsonArray = cfuncs.getGroup(Integer
							.parseInt(clientIdSelected), systemId);
					jsonObject.put("GroupRoot", jsonArray);
				} else {
					jsonObject.put("GroupRoot", "");
				}
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {
				System.out.println("Error in Common Action:-getgroup "
						+ e.toString());
			}
		}

		else if (param.equals("getGroupIncludingAllOption")) {
			try {
				String clientIdSelected = request.getParameter("CustId");

				jsonObject = new JSONObject();
				if (clientIdSelected != null) {
					jsonArray = cfuncs.getGroupNamesIncludingAllOption(Integer.parseInt(clientIdSelected), systemId);
					jsonObject.put("GroupRoot", jsonArray);
				} else {
					jsonObject.put("GroupRoot", "");
				}
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {
				System.out.println("Error in Common Action:-getGroupIncludingAllOption "+ e.toString());
			}
		}

		if (param.equals("getallCustomer")) {
			try {
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				String ltsp = "no";
				if (request.getParameter("paramforltsp") != null) {
					ltsp = request.getParameter("paramforltsp").toString();
				}

				jsonArray = cfuncs.getallCustomer(systemId, ltsp,
						customerIdlogin);
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
		} else if (param.equals("getallgroup")) {
			try {
				String clientIdSelected = request.getParameter("CustId");

				jsonObject = new JSONObject();
				if (clientIdSelected != null) {
					jsonArray = cfuncs.getallGroup(Integer
							.parseInt(clientIdSelected), systemId);
					jsonObject.put("GroupRoot", jsonArray);
				} else {
					jsonObject.put("GroupRoot", "");
				}
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {
				System.out.println("Error in Common Action:-getgroup "
						+ e.toString());
			}
		} else if (param.equals("getVehicleNo")) {
			try {
				String clientIdSelected = request.getParameter("CustId");
				System.out.println(clientIdSelected);
				jsonObject = new JSONObject();
				if (clientIdSelected != null) {
					jsonArray = cfuncs.getRegistrationNoBasedOnUser(Integer.parseInt(clientIdSelected), systemId, userId);
					jsonObject.put("VehicleNoRoot", jsonArray);
				} else {
					jsonObject.put("VehicleNoRoot", "");
				}
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {
				System.out.println("Error in Common Action:-getVehicleNo "+ e.toString());
			}
		} else if (param.equals("getDriverNames")) {
			try {
				String clientIdSelected = request.getParameter("CustId");

				jsonObject = new JSONObject();
				if (clientIdSelected != null) {
					jsonArray = cfuncs.getDriverName(Integer.parseInt(clientIdSelected), systemId);
					jsonObject.put("DriverNameRoot", jsonArray);
				} else {
					jsonObject.put("DriverNameRoot", "");
				}
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {
				System.out.println("Error in Common Action:-getDriverNames "
						+ e.toString());
			}
		}
		else if (param.equalsIgnoreCase("getBatteryVoltage")) {
			try
			{
			String clientIdSelected = request.getParameter("CustId");
			jsonArray = new JSONArray();
			jsonObject = new JSONObject();			
			if (clientIdSelected != null) {
				jsonArray = cfuncs.systemHealthGetCount(Integer
						.parseInt(clientIdSelected), systemId);
			}
			if(jsonArray.length()>0)
			{
			jsonObject.put("Systemroot", jsonArray);
			}
			else
			{
			jsonObject.put("Systemroot", "");
			}
			response.getWriter().print(jsonObject.toString());
			}
			catch(Exception e)
			{
				
			}
		}	
		else if (param.equalsIgnoreCase("getSystemHealthDetails")) {
			try
			{
			String customerid=request.getParameter("custID");
			String status=request.getParameter("status");
			String jspName=request.getParameter("jspName");
			jsonArray = new JSONArray();
			ArrayList<Object> SystemHelthDetailsList =new ArrayList<Object>();
			jsonObject = new JSONObject();			
			if (customerid != null) {
				 SystemHelthDetailsList=cfuncs.systemHealthGetDetails(Integer.parseInt(customerid),systemId,offmin,status);
				jsonArray = (JSONArray) SystemHelthDetailsList.get(0);
			}
			if(jsonArray.length()>0)
			{
			jsonObject.put("SystemHealthDetailsRoot", jsonArray);
			ReportHelper reportHelper = (ReportHelper) SystemHelthDetailsList.get(1);
            request.getSession().setAttribute(jspName, reportHelper);        
			}
			else
			{
			jsonObject.put("SystemHealthDetailsRoot", "");
			}
			response.getWriter().print(jsonObject.toString());
			}
			catch(Exception e)
			{
				e.printStackTrace();
			}
		}
		else if (param.equalsIgnoreCase("getStates")) {
			try {
				jsonObject = new JSONObject();
				jsonArray = cfuncs.getStateList(CountryCode);
				if(jsonArray.length()>0){
					jsonObject.put("StateRoot", jsonArray);
				} else {
					jsonObject.put("StateRoot", "");
				}
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {
				System.out.println("Error in Common Action:-getStates "
						+ e.toString());
			}
		}else if(param.equalsIgnoreCase("getVehicleList")){
			try{				
			String vehicleList =cfuncs.getVehicleList(userId, systemId, isLtsp,customerIdlogin);
			if(vehicleList!=null){
				response.getWriter().print(vehicleList);
			} else {
				response.getWriter().print("");
			}
			
		}catch (Exception e) {
			e.printStackTrace();
			}
		}else if(param.equalsIgnoreCase("getVehicleDetails")){
				String vehicleNo=null;
			try{
				if(request.getParameter("vehicleNo")!=null){
					vehicleNo=request.getParameter("vehicleNo").toString();
				}
				String vehicleDetails=cfuncs.getVehicleDetails(vehicleNo, systemId, customerIdlogin);
				if(vehicleDetails!=null){
					response.getWriter().print(vehicleDetails);
				}else{
					response.getWriter().print("");
				}
					
			}catch (Exception e) {
				e.printStackTrace();
			}
		}
		else if (param.equalsIgnoreCase("getLiveVisionDetails")) {
			jsonObject = new JSONObject();
			jsonArray = new JSONArray();
			String vehicleNo=request.getParameter("vehicleNo");
			try {
				jsonArray = cfuncs.getLiveVisionDetails(vehicleNo);				
				if(jsonArray.length()>0){
					jsonObject.put("detailsStoreRoot",jsonArray);
				}else{
					jsonObject.put("detailsStoreRoot","");
				}
				response.getWriter().print(jsonObject.toString());	
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
			
		
		else if (param.equalsIgnoreCase("getMenuList")) {
			jsonObject = new JSONObject();
			jsonArray = new JSONArray();
			String id=sessionId;
			try {
				Object custIdNew = session.getAttribute("customerId");
				Object jsonobj = session.getAttribute(id);
				if(jsonobj!=null && custIdNew != null && custIdNew.equals(customerIdlogin) ){	
					response.getWriter().print(jsonobj.toString());
			    }else{
					MenuListFunction menuList=new MenuListFunction();
					jsonObject =menuList.getMenuList(systemId, customerIdlogin, userId, lang);
					session.setAttribute(id, jsonObject.toString());
					session.setAttribute("customerId",customerIdlogin);
					response.getWriter().print(jsonObject.toString());
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		
		else if (param.equalsIgnoreCase("checkForDataAvailability")) {
		String	date1  = request.getParameter("date1");
		String	date2 = request.getParameter("date2");
		String	regNo = request.getParameter("regNo");	
		int	clientId = Integer.parseInt(request.getParameter("clientId"));
			try{
				
				String message=cfuncs.checkForDataAvailability(systemId, clientId, offmin, userId,date1,date2, regNo);
				if(message!=null){
					response.getWriter().print(message);
				}else{
					response.getWriter().print("");
				}
					
			}catch (Exception e) {
				e.printStackTrace();
			}
		}else if (param.equalsIgnoreCase("getListViewColumnSetting")) {
			String pageName = request.getParameter("pageName");
				try{
					jsonObject = new JSONObject();
					jsonArray = cfuncs.getListViewColumnSetting(systemId, customerIdlogin, userId, pageName);
					if(jsonArray.length() > 0){
						jsonObject.put("columnSettingsRoot", jsonArray);
					}else{
						jsonObject.put("columnSettingsRoot", "");
					}
					response.getWriter().print(jsonObject.toString());	
				}catch (Exception e) {
					e.printStackTrace();
				}
		}else if (param.equalsIgnoreCase("updateListViewColumnSetting")) {
			String columnSettings = request.getParameter("columnSettings");
				try{
					jsonObject = new JSONObject();
					Gson g = new Gson(); 
					List settingsList = g.fromJson(columnSettings, List.class); 
					cfuncs.updateListViewColumnSetting(systemId, customerIdlogin, userId, settingsList);
					
					response.getWriter().print(jsonObject.toString());	
				}catch (Exception e) {
					e.printStackTrace();
				}
			}
		else if (param.equalsIgnoreCase("createListViewColumnSetting")) {
			String columnSettings = request.getParameter("columnSettings");
			String pageName = request.getParameter("pageName");
				try{
					jsonObject = new JSONObject();
					Gson g = new Gson(); 
					List settingsList = g.fromJson(columnSettings, List.class); 
					cfuncs.insertListViewColumnSetting(systemId, customerIdlogin, userId, settingsList, pageName);
					
					response.getWriter().print(jsonObject.toString());	
				}catch (Exception e) {
					e.printStackTrace();
				}
			}else if (param.equalsIgnoreCase("getCityNamesForMap")) {
				try {
					String isCapital = request.getParameter("isCapital");
					jsonObject = new JSONObject();
					jsonArray = cfuncs.getCityNamesForMap(isCapital);
					if(jsonArray.length()>0){
						jsonObject.put("cityRoot", jsonArray);
					} else {
						jsonObject.put("cityRoot", "");
					}
					response.getWriter().print(jsonObject.toString());
				} catch (Exception e) {
					System.out.println("Error in Common Action:-getStates "
							+ e.toString());
				}
			}
		
		return null;
	}
}