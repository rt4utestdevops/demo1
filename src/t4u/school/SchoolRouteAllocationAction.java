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

public class SchoolRouteAllocationAction extends Action{

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
		if (param.equalsIgnoreCase("getRouteAllocationDetails")) {
			try {
				String customerId = request.getParameter("CustId");
				String CustName=request.getParameter("CustName");
				String jspName=request.getParameter("jspName");
				
				if (customerId != null && !customerId.equals("")) {
					jsonArray = new JSONArray();
					jsonObject = new JSONObject();
					ArrayList < Object > list1 = SendschoolSms.getRouteAllocationDetails(systemId,Integer.parseInt(customerId),lang);
					jsonArray = (JSONArray) list1.get(0);
					
					if (jsonArray.length() > 0) {
						jsonObject.put("routeDetailsRoot", jsonArray);
					} else {
						jsonObject.put("routeDetailsRoot", "");
					}
					    ReportHelper reportHelper = (ReportHelper) list1.get(1);
		                request.getSession().setAttribute(jspName, reportHelper);
		                request.getSession().setAttribute("customerId", CustName);
		            } else {
		            	jsonObject.put("routeDetailsRoot", "");
		            }
				 response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		else if (param.equals("getAssetNumber")) {
			try {
				String customerId = request.getParameter("CustId");
				if (customerId != null && !customerId.equals("")) {
					jsonArray = new JSONArray();
					jsonObject = new JSONObject();
					jsonArray = SendschoolSms.getAssetNumberList(systemId,Integer.parseInt(customerId));
					if (jsonArray.length() > 0) {
						jsonObject.put("assetNumberRoot", jsonArray);
					} else {
						jsonObject.put("assetNumberRoot", "");
					}
					response.getWriter().print(jsonObject.toString());
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		else if (param.equalsIgnoreCase("saveRouteAllocationInformation")){

			String Route = request.getParameter("route");
			String StartTime = request.getParameter("startTime");
			String assetNumber = request.getParameter("assetNo");
			String DropType = request.getParameter("type");
			String customerId = request.getParameter("custId");	
			String RouteGrid = request.getParameter("RouteGrid");
			//String StartTimeGrid = request.getParameter("StartTimeGrid");
			String assetNumberGrid = request.getParameter("AssetNoGrid");
			String DropTypeGrid = request.getParameter("TypeGrid");
			String buttonvalue=request.getParameter("buttonValue");
			String UniqueId=request.getParameter("UniqueId");
			
			//System.out.println("-------------------------------------"+UniqueId);
			//System.out.println("-------------------------------------"+Route+"-->"+RouteGrid);
			try {
				if (buttonvalue.equals("add")) {
					message=SendschoolSms.RouteAllocationDetailsInsert(Route,StartTime,assetNumber,DropType,systemId,Integer.parseInt(customerId),UniqueId);
				} else if(buttonvalue.equals("modify")) {
					message=SendschoolSms.RouteAllocationDetailsUpdate(Route,RouteGrid,assetNumberGrid,DropTypeGrid,StartTime,assetNumber,DropType,systemId,Integer.parseInt(customerId),UniqueId);
				} 
				response.getWriter().print(message);
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		else if (param.equalsIgnoreCase("deleteRoueAllocationDetails")) {
			String uniqueId = request.getParameter("UniqueId");
			String customerID = request.getParameter("CustId");
			String type=request.getParameter("type");
			String Route=request.getParameter("route");
			//System.out.println("------delete-------"+uniqueId);
			//System.out.println("------customerID-------"+customerID+"..."+Route+".."+type);
			try {
				message = SendschoolSms.deleteRoueAllocationDetails(Route,type,Integer.parseInt(uniqueId),Integer.parseInt(customerID),systemId);
				response.getWriter().print(message);
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		return null;
		
	}
}
