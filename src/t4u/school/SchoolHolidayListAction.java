package t4u.school;

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
import t4u.functions.SchoolFunctions;

public class SchoolHolidayListAction extends Action{
	public ActionForward execute(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) {
		String param = "";
		String message="";
		HttpSession session = request.getSession();
		LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
		int userId = loginInfo.getUserId();
		int systemId = loginInfo.getSystemId();
		String lang = loginInfo.getLanguage();
		SchoolFunctions SendschoolSms=new SchoolFunctions();
		JSONArray jsonArray = null;
		JSONObject jsonObject = new JSONObject();

		if (request.getParameter("param") != null) {
			param = request.getParameter("param").toString();
		}
		if (param.equalsIgnoreCase("getHolidayDetails")) {
			try {
				String customerId = request.getParameter("CustId");
				String CustName=request.getParameter("CustName");
				String jspName=request.getParameter("jspName");
				//System.out.println("CustName"+CustName);
				//System.out.println("jspName"+jspName);
				//System.out.println("customerId :"+customerId);
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				if (customerId != null && !customerId.equals("")) {
					ArrayList <Object> list1 = SendschoolSms.getHolidayDetails(systemId,Integer.parseInt(customerId),lang);
					jsonArray = (JSONArray) list1.get(0);
					if (jsonArray.length() > 0) {
						jsonObject.put("HolidayDetailsRoot", jsonArray);
					} else {
						jsonObject.put("HolidayDetailsRoot", "");
					}
					ReportHelper reportHelper = (ReportHelper) list1.get(1);
					request.getSession().setAttribute(jspName, reportHelper);
					request.getSession().setAttribute("customerId", CustName);
				} else {
					jsonObject.put("HolidayDetailsRoot", "");
				}
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		else if (param.equals("getHolidayList")) {
			try {
				String customerId = request.getParameter("paramId");
				//System.out.println("--->"+customerId);
				if (customerId.equals("")) {
					customerId="0";
					jsonObject = new JSONObject();
					String jsonA = SendschoolSms.getList(systemId,Integer.parseInt(customerId));
					//System.out.println(jsonA);
					jsonArray = new JSONArray("["+jsonA+"]");
					//System.out.println(jsonArray);
					response.getWriter().print(jsonArray);
				}else if(customerId != null && !customerId.equals("")) {
					jsonObject = new JSONObject();
					String jsonA = SendschoolSms.getList(systemId,Integer.parseInt(customerId));
					//System.out.println(jsonA);
					jsonArray = new JSONArray("["+jsonA+"]");
					//System.out.println(jsonArray);
					response.getWriter().print(jsonArray);
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		
		else if (param.equals("getStandard")) {
			try {
				String customerId = request.getParameter("CustId");
				if (customerId != null && !customerId.equals("")) {
					jsonArray = new JSONArray();
					jsonObject = new JSONObject();
					jsonArray = SendschoolSms.getStandardListForHoliday(systemId,Integer.parseInt(customerId));
					//System.out.println("standard"+jsonArray.toString());
					//System.out.println("standard"+jsonArray.length());
					if (jsonArray.length() > 0) {
						jsonObject.put("standardHolidayRoot", jsonArray);
					} else {
						jsonObject.put("standardHolidayRoot", "");
					}
					response.getWriter().print(jsonObject.toString());
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		else if (param.equalsIgnoreCase("saveHolidayList")){
			String customerId = request.getParameter("custId");
			String UniqueId = request.getParameter("UniqueId");
			String buttonValue = request.getParameter("buttonValue");
			String standard = request.getParameter("standard");
			String fromDate = request.getParameter("fromDate");
			String toDate = request.getParameter("toDate");

			//System.out.println("-------------------"+customerId+"------------------"+UniqueId+"--"+buttonValue+"--"+standard+"--"+fromDate+"--"+toDate);

			try {
				if (buttonValue.equals("add")) {
					message=SendschoolSms.HolidayDetailsInsert(standard,fromDate,toDate,systemId,Integer.parseInt(customerId));
				} else if(buttonValue.equals("modify")) {
					message=SendschoolSms.HolidayDetailsUpdate(standard,fromDate,toDate,systemId,Integer.parseInt(customerId),UniqueId);
					//System.out.println("Modify");
				} 
				response.getWriter().print(message);
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		else if (param.equalsIgnoreCase("deleteHolidayDetails")) {
			String uniqueId = request.getParameter("UniqueId");
			String customerID = request.getParameter("CustId");
			String Standard=request.getParameter("Standard");
			//System.out.println("------delete-------"+uniqueId);
			//System.out.println("------customerID-------"+customerID+"..."+Standard);
			try {
				message = SendschoolSms.deleteHolidayDetails(Standard,Integer.parseInt(uniqueId),Integer.parseInt(customerID),systemId);
				response.getWriter().print(message);
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		return null;
	}
}
