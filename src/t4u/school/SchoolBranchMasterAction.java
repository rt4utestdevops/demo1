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
import t4u.functions.CommonFunctions;
import t4u.functions.SchoolFunctions;
/**
 * @author shivadarshan
 * Action class for SchoolBranchMaster.jsp
 */

public class SchoolBranchMasterAction extends Action{

	public ActionForward execute(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) {

		String param = "";
		String message="";
		HttpSession session = request.getSession();
		LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
		int userId = loginInfo.getUserId();
		int systemId = loginInfo.getSystemId();
		String zone = loginInfo.getZone();
		String lang = loginInfo.getLanguage();
		int offset = loginInfo.getOffsetMinutes();
		SchoolFunctions sf=new SchoolFunctions();
		JSONArray jsonArray = null;
		JSONObject jsonObject = new JSONObject();

		if (request.getParameter("param") != null) {
			param = request.getParameter("param").toString();
		}
		if (param.equalsIgnoreCase("getBranchMasterDetails")) {
			try {
				String customerId = request.getParameter("CustId");
				String CustName=request.getParameter("CustName");
				String jspName=request.getParameter("jspName");
//				System.out.println("CustName"+CustName);
//				System.out.println("jspName"+jspName);
				
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				if (customerId != null && !customerId.equals("")) {
					ArrayList <Object> list1 = sf.getBranchMasterDetails(systemId,Integer.parseInt(customerId),lang,zone,offset);
					jsonArray = (JSONArray) list1.get(0);
					if (jsonArray.length() > 0) {
						jsonObject.put("BranchMasterDetailsRoot", jsonArray);
					} else {
						jsonObject.put("BranchMasterDetailsRoot", "");
					}
					ReportHelper reportHelper = (ReportHelper) list1.get(1);
					request.getSession().setAttribute(jspName, reportHelper);
					request.getSession().setAttribute("customerId", CustName);
				} else {
					jsonObject.put("BranchMasterDetailsRoot", "");
				}
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		
		/**
		 * @author shivadarshan
		 * getting country list 
		 */
		else if(param.equals("getCountryNameList")){
			
			try {
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				jsonArray = sf.getCountryNameList();
				if(jsonArray.length()>0){
				jsonObject.put("CountryRoot", jsonArray);
				}else{
					jsonObject.put("CountryRoot", "");
				}
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {
				System.out.println("Error in BranchMaster Action:-getCountryList "+e.toString());
			}
			
		}
		/**
		 * getting statelist of particular country
		 */
		else if(param.equals("getStateList")){
			
			String countryId="0";
			if(request.getParameter("countryId")!=null || request.getParameter("countryId").equals("")){
				countryId=request.getParameter("countryId").trim();
			}
			
			try {
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				if(!countryId.equals("0")){
				jsonArray=sf.getStateList(countryId);
				}
				if(jsonArray.length()>0){
				jsonObject.put("StateRoot", jsonArray);
				}else{
					jsonObject.put("StateRoot", "");
				}
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {
				System.out.println("Error in BranchMaster Action:-getStateList "+e.toString());
			}
			
		}
		
		else if (param.equalsIgnoreCase("getHubDetails")) {

			String ClientId = request.getParameter("CustId");
			String SystemId = request.getParameter("LTSPId");

			JSONArray jsonarray = null;
			if (ClientId != null && !ClientId.equals("")) {

				try {
					jsonarray = sf.getHubIDforBranchMaster(ClientId, SystemId, zone);
					if (jsonarray.length() > 0) {
						jsonObject.put("HubDetailsRoot", jsonarray);
					} else {
						jsonObject.put("HubDetailsRoot", "");
					}
					response.getWriter().print(jsonObject.toString());
				} catch (Exception e) {
					e.printStackTrace();
				}

			}
		}
		
		else if (param.equals("saveBranchMasterDetailsInformation")){
				String customerId= request.getParameter("custId");	
				String GroupID= request.getParameter("GroupID");
				String branchName= request.getParameter("BranchName");
				String country= request.getParameter("country");
				String state= request.getParameter("State");
				String city= request.getParameter("City");
				String contactNumber= request.getParameter("ContactNumber");
				String emailId= request.getParameter("EmailId");
				String mobile= request.getParameter("Mobile");
				String hubId=request.getParameter("HubId");
				String UniqueId=request.getParameter("UniqueId");
				String buttonvalue=request.getParameter("buttonValue");

			try {
				if (buttonvalue.equals("add")) {
					
					message=sf.BranchMasterDetailsInsert(Integer.parseInt(GroupID), branchName, Integer.parseInt(country), Integer.parseInt(state), city, 
							contactNumber, emailId, mobile, Integer.parseInt(hubId), systemId, Integer.parseInt(customerId),userId);
					
				} else if(buttonvalue.equals("modify")) {
					
					message=sf.BranchMasterDetailsUpdate(Integer.parseInt(GroupID), branchName, Integer.parseInt(country), Integer.parseInt(state), city, 
							contactNumber, emailId, mobile, Integer.parseInt(hubId), systemId, Integer.parseInt(customerId),UniqueId);
					
				} 
				response.getWriter().print(message);
			} catch (Exception e) {
				e.printStackTrace();
			}
		}	
		else if (param.equalsIgnoreCase("deleteBranchMasterDetails")) {
			String uniqueId = request.getParameter("UniqueId");
			String customerID = request.getParameter("CustId");
			try {
				message="deleted....";
				message = sf.deleteBranchMasterDetails(Integer.parseInt(uniqueId),Integer.parseInt(customerID),systemId);
				response.getWriter().print(message);
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		return null;

	}
}
