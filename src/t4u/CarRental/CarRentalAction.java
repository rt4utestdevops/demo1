package t4u.CarRental;

/**
 * @author amith.n
 *
 */
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
import t4u.functions.CarRentalFunctions;

public class CarRentalAction extends Action {
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
			CarRentalFunctions cfunc=new CarRentalFunctions();
			JSONObject jsonObject = null;			
			JSONArray jsonArray = null;
			String param = "";
			if (request.getParameter("param") != null) {
				param = request.getParameter("param").toString();
			}
			if(param.equals("getAlertCount"))
			{
				try {
					 String alertList = request.getParameter("alertList");
					jsonArray = new JSONArray();
					jsonObject = new JSONObject();
					jsonArray = cfunc.getAlertCount(alertList,systemId, customerId, userId, offmin);
					if (jsonArray.length() > 0) {
						jsonObject.put("AlertCountRoot", jsonArray);
					} else {
						jsonObject.put("AlertCountRoot", "");
					}
					response.getWriter().print(jsonObject.toString());
				} catch (Exception e) {
					e.printStackTrace();
				}

			}
			else if (param.equalsIgnoreCase("getCommNonCommunicatingVehicles")) {
				try
				{
				String customerid=request.getParameter("custID");
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();			
				jsonArray=cfunc.getCommNonCommVehicles(customerid, systemId,userId,isLtsp,offmin,zone,nonCommHrs);
				if(jsonArray.length()>0)
				{
				jsonObject.put("CommNoncommroot", jsonArray);
				}
				else
				{
				jsonObject.put("CommNoncommroot", "");
				}
				response.getWriter().print(jsonObject.toString());
				}
				catch(Exception e)
				{
					
				}
			}

			else if (param.equalsIgnoreCase("getPreventiveExpiryVehicles")) {
				try
				{
				String customerid=request.getParameter("custID");
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();			
				jsonArray=cfunc.getPreventiveExpiryVehicles(customerid, systemId,userId);
				if(jsonArray.length()>0)
				{
				jsonObject.put("Preventiveroot", jsonArray);
				}
				else
				{
				jsonObject.put("Preventiveroot", "");
				}
				response.getWriter().print(jsonObject.toString());
				}
				catch(Exception e)
				{
					
				}
			}
			
			else if (param.equalsIgnoreCase("getstatutorydetails")) {
				try
				{
				String customerid=request.getParameter("custID");
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();			
				jsonArray=cfunc.getStatutoryDetails(customerid, systemId,offmin);
				if(jsonArray.length()>0)
				{
				jsonObject.put("Statutoryroot", jsonArray);
				}
				else
				{
				jsonObject.put("Statutoryroot", "");
				}
				response.getWriter().print(jsonObject.toString());
				}
				catch(Exception e)
				{
					
				}
			}
			
			else if (param.equals("getAlertDetails")) {
				try {
					CarRentalFunctions rentalFunctions=new CarRentalFunctions();
					String alertId = request.getParameter("alertId");
					String type=request.getParameter("type");
					jsonArray = new JSONArray();
					jsonObject = new JSONObject();
					jsonArray = rentalFunctions.getAlertDetails(offmin, alertId,systemId, customerId, userId,type);
					if (jsonArray.length() > 0) {
						jsonObject.put("AlertDetailsRoot", jsonArray);
					} else {
						jsonObject.put("AlertDetailsRoot", "");
					}
					response.getWriter().print(jsonObject.toString());
				}
				catch (Exception e) {
					e.printStackTrace();
				}
			}
			
			
			else if (param.equals("saveAlertRemarks")) {
				try{
					CarRentalFunctions rentalFunctions=new CarRentalFunctions();
					String alertslno= request.getParameter("alertslno");					
					String remark =request.getParameter("remark");
					String regno =request.getParameter("regno");
					String typeofalert =request.getParameter("typeofalert");
					String GMT=request.getParameter("GMT");
					String alertType=request.getParameter("alertType");
					String message="";
					int result=rentalFunctions.saveAlertRemarks(alertslno ,remark, regno,GMT,typeofalert,offmin,customerId,systemId,alertType,userId);
					if(result>0)
					{
						message="Remark Saved";
					}
					else
					{
						message="Error in Saving";
					}
					response.getWriter().print(message);	
				}catch(Exception e){
					System.out.println("Error in saveAlertRemarks "+e.toString());
				}			
			}
			
			else if (param.equals("getHighUsageAlertDetails")) {
				try {
					CarRentalFunctions rentalFunctions=new CarRentalFunctions();
					String alertId = request.getParameter("alertId");
					jsonArray = new JSONArray();
					jsonObject = new JSONObject();
					jsonArray = rentalFunctions.getHighUsageAlertDetails(offmin, alertId,systemId, customerId, userId);
					if (jsonArray.length() > 0) {
						jsonObject.put("AlertDetailsRoot", jsonArray);
					} else {
						jsonObject.put("AlertDetailsRoot", "");
					}
					response.getWriter().print(jsonObject.toString());
				}
				catch (Exception e) {
					e.printStackTrace();
				}
			}
			
			else if (param.equals("getVoltageBatteryDetails")) {
				try {
					CarRentalFunctions rentalFunctions=new CarRentalFunctions();
					SimpleDateFormat sdfFormatDate = new SimpleDateFormat("dd-MM-yyy HH:mm:ss");
					String alertId = request.getParameter("alertId");
					jsonArray = new JSONArray();
					jsonObject = new JSONObject();
					String jspName = request.getParameter("jspName");
					ArrayList <Object> List = rentalFunctions.getVoltageBatteryDetails(offmin, alertId,systemId, customerId, userId,lang);
					jsonArray = (JSONArray) List.get(0);
					if (jsonArray.length() > 0) {
						jsonObject.put("AlertDetailsRoot", jsonArray);
					} else {
						jsonObject.put("AlertDetailsRoot", "");
					}
					ReportHelper reportHelper = (ReportHelper) List.get(1);
					session.setAttribute(jspName, reportHelper);
					session.setAttribute("date", sdfFormatDate.format(new Date()));
					response.getWriter().print(jsonObject.toString());
				}
				catch (Exception e) {
					e.printStackTrace();
				}
			}
			
			
			else if (param.equalsIgnoreCase("getUnderMaintanceDetails")) {
				try
				{
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();			
				jsonArray=cfunc.getUndermaintanceDetails(customerId, systemId,userId,zone);
				if(jsonArray.length()>0)
				{
				jsonObject.put("maintanceoot", jsonArray);
				}
				else
				{
				jsonObject.put("maintanceoot", "");
				}
				response.getWriter().print(jsonObject.toString());
				}
				catch(Exception e)
				{
					
				}
			}
			
			else if (param.equals("getOffRoadAlertDetails")) {
				try {
					CarRentalFunctions rentalFunctions=new CarRentalFunctions();
					String alertId = request.getParameter("alertId");
					String jspName = request.getParameter("jspName");
					SimpleDateFormat sdfFormatDate = new SimpleDateFormat("dd-MM-yyy HH:mm:ss");
					jsonArray = new JSONArray();
					jsonObject = new JSONObject();
					ArrayList <Object> List = rentalFunctions.getOffRoadAlertDetails(offmin, alertId,systemId, customerId, userId);
					jsonArray = (JSONArray) List.get(0);
					if (jsonArray.length() > 0) {
						jsonObject.put("AlertDetailsRoot", jsonArray);
					} else {
						jsonObject.put("AlertDetailsRoot", "");
					}
					ReportHelper reportHelper = (ReportHelper) List.get(1);
					session.setAttribute(jspName, reportHelper);
					session.setAttribute("date", sdfFormatDate.format(new Date()));
					response.getWriter().print(jsonObject.toString());
				}
				catch (Exception e) {
					e.printStackTrace();
				}
			}
          
			   /*******************************************************************************************************************************
			* 										GET STATE WISE STATUTORY ALERT 
			********************************************************************************************************************************/
			else if(param.equals("getStateWiseStatutoryCount")){
				try{				
					String typeofalert =request.getParameter("typeofalert");
					String clientId =request.getParameter("clientId");
					jsonArray = new JSONArray();
					jsonObject = new JSONObject();	
					jsonArray=cfunc.getStateWiseStatutoryCount(typeofalert,clientId,systemId,offmin);
					if(jsonArray.length()>0)
					{
					jsonObject.put("StatutoryStateWiseCountRoot", jsonArray);
					}
					else
					{
					jsonObject.put("StatutoryStateWiseCountRoot", "");
					}
					response.getWriter().print(jsonObject.toString());
					}
					catch(Exception e)
					{
						
					}			
			}

			else if(param.equals("getStatutoryDashboardDetails")){
				try{				
					String typeofalert =request.getParameter("alertId");
					String clientId =request.getParameter("custID");
					String state=request.getParameter("state");
					jsonArray = new JSONArray();
					jsonObject = new JSONObject();	
					jsonArray=cfunc.getStateWiseStatutoryDetails(typeofalert,state,offmin,clientId,systemId);
					if(jsonArray.length()>0)
					{
					jsonObject.put("StatutoryStateWiseDetailsRoot", jsonArray);
					}
					else
					{
					jsonObject.put("StatutoryStateWiseDetailsRoot", "");
					}
					response.getWriter().print(jsonObject.toString());
					}
					catch(Exception e)
					{
						
					}			
			}
			
			   /*******************************************************************************************************************************
			* 										SAVE-REMARKS
			********************************************************************************************************************************/
			else if(param.equals("saveCVSremarks")){
				try{
					String alertslno= request.getParameter("alertslno");					
					String remark =request.getParameter("remark");
					String regno =request.getParameter("regno");
					String typeofalert =request.getParameter("typeofalert");
					String clientId =request.getParameter("clientId");
					String GMT=request.getParameter("GMT");
					String message="";
					int result=cfunc.saveCVSRemarks(alertslno ,remark, regno,GMT,typeofalert,offmin,clientId,systemId);
					if(result>0)
					{
						message="Remark Saved";
					}
					else
					{
						message="Error in Saving";
					}
					response.getWriter().print(message);	
				}catch(Exception e){
					System.out.println("Error in Asset Group Action:-deleteAssetGroupDetails "+e.toString());
				}			
			}
			else if(param.equals("getDeviceBateryDetails")){
				try{
					CarRentalFunctions rentalFunctions=new CarRentalFunctions();
					String type=request.getParameter("type");
					jsonArray = new JSONArray();
					jsonObject = new JSONObject();
					jsonArray = rentalFunctions.getDeviceBateryAlertDetails(offmin,systemId,customerId,type);
					if (jsonArray.length() > 0) {
						jsonObject.put("AlertDetailsRoot", jsonArray);
					} else {
						jsonObject.put("AlertDetailsRoot", "");
					}
					response.getWriter().print(jsonObject.toString());
				}
				catch (Exception e) {
					e.printStackTrace();
				}	
				
			}
			else if (param.equals("saveAlertRemarksForDevice")) {
				try{
					CarRentalFunctions rentalFunctions=new CarRentalFunctions();
					String alertslno= request.getParameter("alertslno");					
					String remark =request.getParameter("remark");
					String regno =request.getParameter("regno");
					String message="";
					int result=rentalFunctions.saveAlertRemarksForDevice(alertslno,remark, regno,customerId,systemId,userId);
					if(result>0)
					{
						message="Remark Saved";
					}
					else
					{
						message="Error in Saving";
					}
					response.getWriter().print(message);	
				}catch(Exception e){
					System.out.println("Error in saveAlertRemarks "+e.toString());
				}			
			}
			
			else if(param.equals("getDeviceWireConnectionReport")){
				try{
					
					String customerid=request.getParameter("CustId");
					String customerName= request.getParameter("custName");
					
					String startDate = request.getParameter("startDate").replace('T', ' ');
		            String endDate = request.getParameter("endDate").replace('T', ' ');
					String jspName = request.getParameter("jspName");
					
					jsonArray = new JSONArray();
					jsonObject = new JSONObject();
					ArrayList < Object > list1 = null;
					if(!customerName.equals(""))
					{
					 
					list1 = cfunc.getDeviceWireConnectionReport(systemId,customerid,startDate,endDate,offmin,lang);
					   jsonArray = (JSONArray) list1.get(0);
					    jsonObject.put("VehicleTypeRoot",jsonArray);
					   if(jsonArray.length()>0)
						{
							ReportHelper reportHelper = (ReportHelper) list1.get(1);
			                request.getSession().setAttribute(jspName, reportHelper);
			                request.getSession().setAttribute("custName",customerName);
			                request.getSession().setAttribute("startDate", startDate);
			                request.getSession().setAttribute("endDate", endDate);
						}
						else
						{
							jsonObject.put("VehicleTypeRoot", "");
						}
					   
					response.getWriter().print(jsonObject.toString());
				}
				}
				
				catch(Exception e)
				{
					System.out.println("Exception in WebDevice/Wire Connection Report:-getDevice/Wire Connection Report "+e.toString());
				} 
			}
			
			if(param.equals("getNonCommunicationAlertCount"))
			{
				try {
					 String alertList = request.getParameter("alertList");
					jsonArray = new JSONArray();
					jsonObject = new JSONObject();
					jsonArray = cfunc.getNonCommunicationAlertCount(systemId, customerId, userId, offmin);
					if (jsonArray.length() > 0) {
						jsonObject.put("NonCommunicatingAlertCountRoot", jsonArray);
					} else {
						jsonObject.put("NonCommunicatingAlertCountRoot", "");
					}
					response.getWriter().print(jsonObject.toString());
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
			else if (param.equals("getNonCommunicationAlertDetails")) {
				try {
					CarRentalFunctions rentalFunctions=new CarRentalFunctions();
					String alertId = request.getParameter("alertId");
					String regNo = request.getParameter("regNo");
					System.out.println(regNo);
					jsonArray = new JSONArray();
					jsonObject = new JSONObject();
					jsonArray = rentalFunctions.getNonCommunicationAlertDetails(offmin, alertId,systemId, customerId, userId,regNo);
					if (jsonArray.length() > 0) {
						jsonObject.put("NonCommAlertDetailsRoot", jsonArray);
					} else {
						jsonObject.put("NonCommAlertDetailsRoot", "");
					}
					response.getWriter().print(jsonObject.toString());
				}
				catch (Exception e) {
					e.printStackTrace();
				}
			}

		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}
}