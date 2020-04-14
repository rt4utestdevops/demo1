package t4u.HubReport;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.StringTokenizer;

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

import t4u.functions.HubSummaryReportFunction;

public class HubArrivalDepartureReportAction extends Action {

	public ActionForward execute(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) {

		HttpSession session = request.getSession();
		
		//SandCommonUtils sandUtils = new SandCommonUtils(); 
		String param = "";
		String zone = "";
		int systemId = 0;
		int clientId = 0;
		int userId = 0;
		int offset = 0;
		LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
		systemId = loginInfo.getSystemId();
		clientId = loginInfo.getCustomerId();
		int customerId = loginInfo.getCustomerId();
		zone = loginInfo.getZone();
		userId = loginInfo.getUserId();
		offset = loginInfo.getOffsetMinutes();
		JSONArray jsonArray = null;
		JSONObject jsonObject = null;
		HubSummaryReportFunction HubFunc = new HubSummaryReportFunction();
		if (request.getParameter("param") != null) {
			param = request.getParameter("param").toString();
		}
		if (param.equals("getAllHubs")) {
			// String jspName=request.getParameter("jspName");
			jsonObject = new JSONObject();
			jsonArray = HubFunc.getAllHubs(systemId, customerId, userId, offset);

			try {
				if (jsonArray.length() > 0) {
					jsonObject.put("AllHubRoot", jsonArray);
				} else {
					jsonObject.put("AllHubRoot", "");
				}
				response.getWriter().print(jsonObject.toString());

			} catch (Exception e) {
				e.printStackTrace();
			}
		} else if (param.equals("getAllGroupName")) {
			jsonObject = new JSONObject();
			jsonArray = HubFunc.getAllGroups(systemId, customerId, userId, offset);

			try {
				if (jsonArray.length() > 0) {
					jsonObject.put("GroupRoot", jsonArray);
				} else {
					jsonObject.put("GroupRoot", "");
				}
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		} else if (param.equals("getAllRegistrationNo")) {
			String group = request.getParameter("group");
			jsonObject = new JSONObject();
			jsonArray = HubFunc.getAllRegistration(systemId, customerId, userId, group);

			try {
				if (jsonArray.length() > 0) {
					jsonObject.put("RegistrationRoot", jsonArray);
				} else {
					jsonObject.put("RegistrationRoot", "");
				}
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}

		} else if (param.equalsIgnoreCase("getHubSummaryDetails")) {
			String jspName = request.getParameter("jspName");
			String HubId = request.getParameter("HubId");
			String startdate = request.getParameter("startdate");
			String enddate = request.getParameter("enddate");
			String RegNo = request.getParameter("RegNo");
			String RegRad = request.getParameter("RegRad");
			String HubRad = request.getParameter("HubRad");
			try {

				SimpleDateFormat yyyymmdd = new SimpleDateFormat("yyyy-MM-dd");
				SimpleDateFormat ddmmyyyy = new SimpleDateFormat("dd-MM-yyyy");

				String type = null;
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				if (startdate != null && !startdate.equals("") && enddate != null && !enddate.equals("")) {

					if (startdate.contains("T")) {
						startdate = startdate.substring(0, startdate.indexOf("T")) + " " + startdate.substring(startdate.indexOf("T") + 1, startdate.length());
					}

					if (enddate.contains("T")) {
						enddate = enddate.substring(0, enddate.indexOf("T")) + " " + enddate.substring(enddate.indexOf("T") + 1, enddate.length());
					}

					if (RegRad.equalsIgnoreCase("true"))
						type = "By Registration";
					else
						type = "By Hub";
					ArrayList<Object> list1 = HubFunc.getHubArrivalDetails(HubId, RegNo, startdate, enddate, systemId, clientId, offset);
					jsonArray = (JSONArray) list1.get(0);

					if (jsonArray.length() > 0) {
						jsonObject.put("HubArrivalDepRoot", jsonArray);
					} else {
						jsonObject.put("HubArrivalDepRoot", "");
					}
					ReportHelper reportHelper = (ReportHelper) list1.get(1);
					request.getSession().setAttribute(jspName, reportHelper);
					request.getSession().setAttribute("jspName", jspName);
					request.getSession().setAttribute("type", type);
					request.getSession().setAttribute("startDate", ddmmyyyy.format(yyyymmdd.parse(startdate)));
					request.getSession().setAttribute("endDate", ddmmyyyy.format(yyyymmdd.parse(enddate)));
					response.getWriter().print(jsonObject.toString());
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		
 else if (param.equalsIgnoreCase("getHubSummaryDetails")) {
        	String jspName = request.getParameter("jspName");
			String HubId = request.getParameter("HubId");
			String startdate = request.getParameter("startdate");
			String enddate = request.getParameter("enddate");
			String RegNo = request.getParameter("RegNo");
			String RegRad = request.getParameter("RegRad");
			String HubRad = request.getParameter("HubRad");
				try {
					
					SimpleDateFormat yyyymmdd = new SimpleDateFormat("yyyy-MM-dd");
					SimpleDateFormat ddmmyyyy = new SimpleDateFormat("dd-MM-yyyy");

					String type = null;
					jsonArray = new JSONArray();
					jsonObject = new JSONObject();
					if (startdate != null && !startdate.equals("")  && enddate != null && !enddate.equals("") ) {
						
					if (startdate.contains("T")) {
						startdate = startdate.substring(0, startdate.indexOf("T"))
						+ " "
						+ startdate.substring(startdate.indexOf("T") + 1,
								startdate.length());
					}

					if (enddate.contains("T")) {
						enddate = enddate.substring(0, enddate.indexOf("T"))
						+ " "
						+ enddate.substring(enddate.indexOf("T") + 1,
								enddate.length());
					}

				
					if(RegRad.equalsIgnoreCase("true"))
						type = "By Registration";
					else
						type = "By Hub";
					 ArrayList < Object > list1=  HubFunc.getHubArrivalDetails(HubId, RegNo, startdate, enddate, systemId, clientId ,offset);
					 jsonArray = (JSONArray) list1.get(0);
					
					if (jsonArray.length() > 0) {
						jsonObject.put("HubArrivalDepRoot", jsonArray);
					} else {
						jsonObject.put("HubArrivalDepRoot", "");
					}
					ReportHelper reportHelper = (ReportHelper) list1.get(1);
					request.getSession().setAttribute(jspName, reportHelper);
		            request.getSession().setAttribute("jspName", jspName);
		            request.getSession().setAttribute("type", type);
		    		request.getSession().setAttribute("startDate", ddmmyyyy.format(yyyymmdd.parse(startdate)));
			     	request.getSession().setAttribute("endDate", ddmmyyyy.format(yyyymmdd.parse(enddate)));
					response.getWriter().print(jsonObject.toString());
					}
				} catch (Exception e) {
					e.printStackTrace();
				}
		}
		// This function is to get hubs for chikkaballapur and bijapur monthly wise
		
		else if (param.equals("getHubsCWT")) {
			String language = "en";
			if (session.getAttribute("lan") != null) {
				language = session.getAttribute("lan").toString();
			}
			List hubNameList = new ArrayList();

			//hubNameList = (ArrayList) sandUtils.getAssociatedHubsNew(String.valueOf(userId), String.valueOf(systemId), clientId,zone);

			if (hubNameList.size() == 0) {
				//hubNameList = sandUtils.getHubNames(String.valueOf(systemId),clientId, session,zone);
			}
			JSONArray hubJsonArr = new JSONArray();
			JSONObject hubJsonObj = new JSONObject();
			JSONObject obj1 = new JSONObject();
			try {
				obj1 = new JSONObject();
				obj1.put("hubId", "0");
				obj1.put("hubName", "ALL");
				hubJsonArr.put(obj1);
				if (hubNameList.size() > 0) {
					for (int i = 0; i < hubNameList.size(); i++) {
						LabelValueBean labelValueBean = (LabelValueBean) hubNameList.get(i);
						if (!labelValueBean.getLabel().equals("Select Hub")) {
							obj1 = new JSONObject();
							obj1.put("hubId", labelValueBean.getValue());
							String hubName="";//sandUtils.getLocationLocalization(labelValueBean.getLabel(), language).replaceAll(",", " ");
							obj1.put("hubName", hubName);//sandUtils.getLocationLocalization(labelValueBean.getLabel(), language));
							hubJsonArr.put(obj1);
						}
					}
				}
				hubJsonObj.put("AllHubRootsNew", hubJsonArr);
				response.setCharacterEncoding("UTF-8");
				response.getWriter().print(hubJsonObj.toString());
				System.out.println(" hubs array :: " + hubJsonArr);
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		else if (param.equalsIgnoreCase("getSandTripSummaryDetailsNew")) {
			String jspName = request.getParameter("jspName");
			String HubId = request.getParameter("HubId");
			String startdate = request.getParameter("startdate");
			String enddate = request.getParameter("enddate");
			String RegNo = request.getParameter("RegNo");
			String RegRad = request.getParameter("RegRad");
			String HubRad = request.getParameter("HubRad");
			try {

				SimpleDateFormat yyyymmdd = new SimpleDateFormat("yyyy-MM-dd");
				SimpleDateFormat ddmmyyyy = new SimpleDateFormat("dd-MM-yyyy");

				String type = null;
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				if (startdate != null && !startdate.equals("") && enddate != null && !enddate.equals("")) {

					if (startdate.contains("T")) {
						startdate = startdate.substring(0, startdate.indexOf("T")) + " " + startdate.substring(startdate.indexOf("T") + 1, startdate.length());
					}

					if (enddate.contains("T")) {
						enddate = enddate.substring(0, enddate.indexOf("T")) + " " + enddate.substring(enddate.indexOf("T") + 1, enddate.length());
					}

					if (RegRad.equalsIgnoreCase("true"))
						type = "By Registration";
					else
						type = "By Hub";
					//ArrayList<Object> list1 = HubFunc.getSandTripSummaryDetailsNew(HubId, RegNo, startdate, enddate, systemId, clientId, offset);
					ArrayList<Object> list1 = HubFunc.getSandTripSummaryDetails(RegNo,startdate, enddate, systemId, clientId, offset);
					jsonArray = (JSONArray) list1.get(0);

					if (jsonArray.length() > 0) {
						jsonObject.put("HubArrivalDepRoot", jsonArray);
					} else {
						jsonObject.put("HubArrivalDepRoot", "");
					}
					ReportHelper reportHelper = (ReportHelper) list1.get(1);
					request.getSession().setAttribute(jspName, reportHelper);
					request.getSession().setAttribute("jspName", jspName);
					request.getSession().setAttribute("type", type);
					request.getSession().setAttribute("startDate", ddmmyyyy.format(yyyymmdd.parse(startdate)));
					request.getSession().setAttribute("endDate", ddmmyyyy.format(yyyymmdd.parse(enddate)));
					response.getWriter().print(jsonObject.toString());
					//System.out.println("Report jsonArray :::: " + jsonArray);
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		
		return null;
	}
}
