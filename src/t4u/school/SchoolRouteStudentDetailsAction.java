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

public class SchoolRouteStudentDetailsAction extends Action{

	public ActionForward execute(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) {

		String param = "";
		String message="";
		HttpSession session = request.getSession();
		LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
		int userId = loginInfo.getUserId();
		int systemId = loginInfo.getSystemId();
		String lang = loginInfo.getLanguage();
		CommonFunctions cf=new CommonFunctions();
		SchoolFunctions SendschoolSms=new SchoolFunctions();
		JSONArray jsonArray = null;
		JSONObject jsonObject = new JSONObject();

		if (request.getParameter("param") != null) {
			param = request.getParameter("param").toString();
		}
		if (param.equalsIgnoreCase("getRouteStudentDetails")) {
			try {
				String customerId = request.getParameter("CustId");
				String CustName=request.getParameter("CustName");
				String jspName=request.getParameter("jspName");
				String branchId=request.getParameter("branchId");
				//System.out.println("CustName"+CustName);
				//System.out.println("jspName"+jspName);
				//System.out.println("BranchId"+branchId);
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				if (customerId != null && !customerId.equals("")) {
					ArrayList <Object> list1 = SendschoolSms.getRouteStudentDetails(systemId,Integer.parseInt(customerId),lang,Integer.parseInt(branchId));
					jsonArray = (JSONArray) list1.get(0);
					if (jsonArray.length() > 0) {
						jsonObject.put("routeStudentDetailsRoot", jsonArray);
					} else {
						jsonObject.put("routeStudentDetailsRoot", "");
					}
					ReportHelper reportHelper = (ReportHelper) list1.get(1);
					request.getSession().setAttribute(jspName, reportHelper);
					request.getSession().setAttribute("customerId", CustName);
				} else {
					jsonObject.put("routeStudentDetailsRoot", "");
				}
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		else if (param.equals("getCountryList")) {
			try {
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				jsonArray = SendschoolSms.getCountryList();
				if (jsonArray.length() > 0) {
					jsonObject.put("CountryRoot", jsonArray);
				} else {
					jsonObject.put("CountryRoot", "");
				}
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		else if (param.equals("getPickupcodeList")) {
			try {
				String customerId = request.getParameter("CustId");
				if (customerId != null && !customerId.equals("")) {
					jsonArray = new JSONArray();
					jsonObject = new JSONObject();
					jsonArray = SendschoolSms.getPickUpCode(systemId,Integer.parseInt(customerId));
					if (jsonArray.length() > 0) {
						jsonObject.put("PickUpRoot", jsonArray);
					} else {
						jsonObject.put("PickUpRoot", "");
					}
					response.getWriter().print(jsonObject.toString());
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		else if (param.equals("getDropcodeList")) {
			try {
				String customerId = request.getParameter("CustId");
				if (customerId != null && !customerId.equals("")) {
					jsonArray = new JSONArray();
					jsonObject = new JSONObject();
					jsonArray = SendschoolSms.getDropcode(systemId,Integer.parseInt(customerId));
					if (jsonArray.length() > 0) {
						jsonObject.put("DropRoot", jsonArray);
					} else {
						jsonObject.put("DropRoot", "");
					}
					response.getWriter().print(jsonObject.toString());
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
		}	
		else if (param.equals("getStandardList")) {
			try {
				String customerId = request.getParameter("CustId");
				if (customerId != null && !customerId.equals("")) {
					jsonArray = new JSONArray();
					jsonObject = new JSONObject();
					jsonArray = SendschoolSms.getStandardList(systemId,Integer.parseInt(customerId));
					//System.out.println("standard"+jsonArray.toString());
					//System.out.println("standard"+jsonArray.length());
					if (jsonArray.length() > 0) {
						jsonObject.put("standardRoot", jsonArray);
					} else {
						jsonObject.put("standardRoot", "");
					}
					response.getWriter().print(jsonObject.toString());
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		else if (param.equals("getBranchList")) {
			try {
				String customerId = request.getParameter("CustId");
				if (customerId != null && !customerId.equals("")) {
					jsonArray = new JSONArray();
					jsonObject = new JSONObject();
					jsonArray = SendschoolSms.getBranchList(systemId,Integer.parseInt(customerId));
					//System.out.println("branch"+jsonArray.toString());
					//System.out.println("branch"+jsonArray.length());
					if (jsonArray.length() > 0) {
						jsonObject.put("branchRoot", jsonArray);
					} else {
						jsonObject.put("branchRoot", "");
					}
					response.getWriter().print(jsonObject.toString());
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		else if (param.equals("getBranchListForPopUp")) {
			try {
				String customerId = request.getParameter("CustId");
				if (customerId != null && !customerId.equals("")) {
					jsonArray = new JSONArray();
					jsonObject = new JSONObject();
					jsonArray = SendschoolSms.getBranchListForPopUp(systemId,Integer.parseInt(customerId));
					//System.out.println("branchPOPUP"+jsonArray.toString());
					if (jsonArray.length() > 0) {
						jsonObject.put("branchPopUpRoot", jsonArray);
					} else {
						jsonObject.put("branchPopUpRoot", "");
					}
					response.getWriter().print(jsonObject.toString());
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		else if (param.equals("saveRouteStudentDetailsInformation")){
			String StudentName= request.getParameter("studentName");
			String Standard= request.getParameter("standard");
			String Section=request.getParameter("Section");
			String Parentname= request.getParameter("parentname");
			String ParentMobileNo= request.getParameter("parentMobileNo");
			String customerId= request.getParameter("custId");	
			String countryCode= request.getParameter("CountryCode");
			String emailId= request.getParameter("EmailId");
			String latitude= request.getParameter("Latitude");
			String longitude= request.getParameter("Longitude");
			String radius=request.getParameter("Radius");
			String pickupCode=request.getParameter("PickupCode");
			String dropType=request.getParameter("DropType");
			String PickupUniqueId=request.getParameter("PickupUniqueId");
			String DropUniqueId=request.getParameter("DropUniqueId");
			String buttonvalue=request.getParameter("buttonValue");
			String pickupGrid=request.getParameter("pickupGrid");
			String dropGrid=request.getParameter("dropGrid");
			String Branch=request.getParameter("Branch");
			//String BranchId=request.getParameter("BranchId");
			//System.out.println("-------------------------------------"+pickupGrid+"...."+dropGrid);
			
			//System.out.println("-------------------------------------"+PickupUniqueId+"...."+DropUniqueId);

			try {
				if (buttonvalue.equals("add")) {
					message=SendschoolSms.RotueStudentDetailsInsert(StudentName,Standard.toLowerCase(),Section,Parentname,ParentMobileNo.trim(),Integer.parseInt(countryCode),
							emailId,latitude,longitude,radius,pickupCode,dropType,systemId,
							Integer.parseInt(customerId),Integer.parseInt(Branch));
				} else if(buttonvalue.equals("modify")) {
					message=SendschoolSms.RotueStudentDetailsUpdate(StudentName,Standard.toLowerCase(),Section,Parentname,ParentMobileNo.trim(),Integer.parseInt(countryCode),
							emailId,latitude,longitude,radius,pickupCode,dropType,systemId,
							Integer.parseInt(customerId),PickupUniqueId,DropUniqueId,pickupGrid,dropGrid,Integer.parseInt(Branch));
				} 
				response.getWriter().print(message);
			} catch (Exception e) {
				e.printStackTrace();
			}
		}	
		else if (param.equalsIgnoreCase("deleteRoueStudentDetails")) {
			String studentName = request.getParameter("StudentName");
			String customerID = request.getParameter("CustId");
			String pickupUniqueId=request.getParameter("PickupUniqueId");
			String dropUniqueId=request.getParameter("DropUniqueId");
			
			//System.out.println("studentName"+studentName+"pickupUniqueId"+pickupUniqueId+"DropUniqueId"+dropUniqueId);
           
			try {
				message = SendschoolSms.deleteRoueStudentDetails(studentName,pickupUniqueId,dropUniqueId,Integer.parseInt(customerID),systemId);
				response.getWriter().print(message);
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		return null;

	}
}
