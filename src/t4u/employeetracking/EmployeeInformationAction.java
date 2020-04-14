package t4u.employeetracking;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.struts.action.Action;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.util.LabelValueBean;
import org.json.JSONArray;
import org.json.JSONObject;

import t4u.beans.LoginInfoBean;
import t4u.beans.ReportHelper;

import t4u.functions.CommonFunctions;
import t4u.functions.EmployeetrackingFunctions;

public class EmployeeInformationAction extends Action {

	public ActionForward execute(ActionMapping mapping, ActionForm form,HttpServletRequest request, HttpServletResponse response)throws Exception {
		String param = "";
		String message = "";		
		HttpSession session = request.getSession();
		EmployeetrackingFunctions etf = new EmployeetrackingFunctions();
		LoginInfoBean  logininfo=(LoginInfoBean)session.getAttribute("loginInfoDetails"); 
		CommonFunctions cfuncs = new CommonFunctions();
		int systemId = logininfo.getSystemId();
		int userId = logininfo.getUserId();
		String lang = logininfo.getLanguage();
		JSONArray jsonArray = null;
		JSONObject jsonObject = new JSONObject();
		if (request.getParameter("param") != null) {
			param = request.getParameter("param").toString();
		}
		if (param.equals("getRouteNames")) {

			try {

				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				String customerId = "0";
				if (request.getParameter("clientId") != null && !request.getParameter("clientId").equals("")) {
					customerId = request.getParameter("clientId").toString();
				}
				
				if (Integer.parseInt(customerId) > 0) {
					jsonArray = etf.getRouteName(Integer.parseInt(customerId), systemId,1);
				}
				if (jsonArray.length() > 0) {
					jsonObject.put("routeName", jsonArray);
				} else {
					jsonObject.put("routeName", "");
				}

				response.getWriter().print(jsonObject.toString());

			} catch (Exception e) {
				e.printStackTrace();
				System.out
						.println("Error in EmployeeTrackingAction:-getRouteDetails"
								+ e);
			}
		}

		if (param.equals("getDropRouteNames")) {

			try {

				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				String customerId = "0";
				if (request.getParameter("clientId") != null && !request.getParameter("clientId").equals("")) {
					customerId = request.getParameter("clientId").toString();
				}
				
				if (Integer.parseInt(customerId) > 0) {
					jsonArray = etf.getRouteName(Integer.parseInt(customerId), systemId,2);
				}
				if (jsonArray.length() > 0) {
					jsonObject.put("droprouteName", jsonArray);
				} else {
					jsonObject.put("droptrouteName", "");
				}

				response.getWriter().print(jsonObject.toString());

			} catch (Exception e) {
				e.printStackTrace();
				System.out
						.println("Error in EmployeeTrackingAction:-getRouteDetails"
								+ e);
			}
		}

		
		
		
		else if (param.equals("getEmployeeDetails")) {

			try {

				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				
				String jspName=request.getParameter("jspName");
				String custName=request.getParameter("custname");
				String customerId = request.getParameter("CustId");
				
				if (request.getParameter("CustId") != null && !request.getParameter("CustId").equals("")) {
			
				ArrayList < Object > list1= etf.getEmployeeRouteDetails(Integer.parseInt(customerId), systemId,lang);
					jsonArray = (JSONArray) list1.get(0);
			
				if (jsonArray.length() > 0) {
					jsonObject.put("employeeDetails", jsonArray);
				} else {
					jsonObject.put("employeeDetails", "");
				}
				ReportHelper reportHelper = (ReportHelper) list1.get(1);
                request.getSession().setAttribute(jspName, reportHelper);
                request.getSession().setAttribute("customerId", custName);
               	}else
				{
					jsonObject.put("employeeDetails", "");
				}
				response.getWriter().print(jsonObject.toString()); 

			} catch (Exception e) {
				e.printStackTrace();
				System.out
						.println("Error in EmployeeTrackingAction:-getRouteDetails"
								+ e);
			}
		}
		 else if (param.equalsIgnoreCase("EmployeeRouteAddAndModify")) {
		        try {
		        	String custId = request.getParameter("CustId");
		            String employeeName = request.getParameter("employeeName");
		            String buttonValue = request.getParameter("buttonValue");
		            String employeeId = request.getParameter("employeeId");
		            String mobileNo = request.getParameter("mobileNo");
		            String rfidKey = request.getParameter("rfidKey");
		            String latitude = request.getParameter("latitude");
		            String longitude = request.getParameter("longitude");
		            String id= request.getParameter("id");
		            String emailId= request.getParameter("emailId");
		            String gender= request.getParameter("gender");
		            String routeId= request.getParameter("routeId");
		            String gridRouteId=request.getParameter("gridRouteId");
		            String gridGender=request.getParameter("gridGender");
		            String  dropRouteName=request.getParameter("dropRouteName");
		            String gridRouteIdForDrop=request.getParameter("gridRouteIdForDrop");
		            message="";
		            if (buttonValue.equals("Add") && custId != null && !custId.equals("")) {
		                message = etf.insertEmployeeInformation(Integer.parseInt(custId),employeeName,employeeId,mobileNo,rfidKey,latitude,longitude,systemId,emailId,gender,routeId,dropRouteName);
		            } else if (buttonValue.equals("Modify") && custId != null && !custId.equals("")) {
		            	 message = etf.modifyEmployeeInformation(Integer.parseInt(custId),employeeName,employeeId,mobileNo,rfidKey,latitude,longitude,systemId,Integer.parseInt(id),emailId,gender,routeId,gridRouteId,gridGender,dropRouteName,gridRouteIdForDrop);
		            }
		            response.getWriter().print(message);
		        } catch (Exception e) {
		            e.printStackTrace();
		        }
		    }
		    
		    else if (param.equals("deleteData")) {
		        try {
		            String customerId = request.getParameter("CustId");
		            String id= request.getParameter("id");
		            message = "";
		            if (customerId != null && !customerId.equals("")) {
		                message = etf.deleteRecordForEmployee(Integer.parseInt(customerId), systemId,Integer.parseInt(id));
		            }
	                response.getWriter().print(message);
		        } catch (Exception e) {
		            e.printStackTrace();
		        }
		    }	    
		    
	        return null;
	 }
	}

