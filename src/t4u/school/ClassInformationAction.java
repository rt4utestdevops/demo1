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

public class ClassInformationAction extends Action{


	public ActionForward execute(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) {

		String param = "";
		String message="";
		int offset=0;
		HttpSession session = request.getSession();
		LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
		int userId = loginInfo.getUserId();
		int systemId = loginInfo.getSystemId();
		int customerIdlogin = loginInfo.getCustomerId();
		offset = loginInfo.getOffsetMinutes();
		CommonFunctions cmfunc = new CommonFunctions();
		SchoolFunctions ClassInfoFunc=new SchoolFunctions();
		JSONArray jsonArray = null;
		JSONObject jsonObject = new JSONObject();
		
		if (request.getParameter("param") != null) {
			param = request.getParameter("param").toString();
		}
		if (param.equals("getCustomerNames")) {
			try {
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				String ltsp = "";
				if (request.getParameter("paramforltsp") != null) {
					ltsp = request.getParameter("paramforltsp").toString();
				}

				jsonArray = cmfunc.getCustomer(systemId, ltsp, customerIdlogin);
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
		}
		else if (param.equalsIgnoreCase("getClassInfoReport")) {
	        try {
	            String customerId = request.getParameter("CustId");
	            jsonArray = new JSONArray();
	            if (customerId != null && !customerId.equals("")) {
	                ArrayList < Object > list1 = ClassInfoFunc.getClassInfoReport(offset,systemId, Integer.parseInt(customerId));
	                jsonArray = (JSONArray) list1.get(0);
	                if (jsonArray.length() > 0) {
	                    jsonObject.put("ClassInformationRoot", jsonArray);
	                } else {
	                    jsonObject.put("ClassInformationRoot", "");
	                }
	                response.getWriter().print(jsonObject.toString());
	            } else {
	                jsonObject.put("ClassInformationRoot", "");
	                response.getWriter().print(jsonObject.toString());
	            }
	        } catch (Exception e) {
	            e.printStackTrace();
	        }
	    }
		
		else if (param.equalsIgnoreCase("classInfoAddAndModify")) {
	        try {
	            String custId = request.getParameter("CustId");
	            String buttonValue = request.getParameter("buttonValue");
	            String className = request.getParameter("className");
	            String newsupervisorid = request.getParameter("supervisorName");
	            String gridclass = request.getParameter("gridClassName");
                String gridID = request.getParameter("gridID");
          
                if (buttonValue.equals("Add") && custId != null && !custId.equals("")) {
	                message = ClassInfoFunc.insertClassInfo(Integer.parseInt(custId),className,newsupervisorid,systemId,userId);
	            } else if (buttonValue.equals("Modify") && custId != null && !custId.equals("")) {	            	
	                      message = ClassInfoFunc.modifyClassInfo(offset,Integer.parseInt(custId),className,newsupervisorid,systemId,userId,Integer.parseInt(gridID),gridclass);
	            }
	            response.getWriter().print(message);
	        } catch (Exception e) {
	            e.printStackTrace();
	        }
	    }
	    
	    else if (param.equals("deleteData")) {
	        try {
	        	String gridclass = request.getParameter("gridClassName");
	            String customerId = request.getParameter("CustId");
	            String gridID = request.getParameter("gridID");
	            if (customerId != null && !customerId.equals("")) {
	                message = ClassInfoFunc.deleteRecord(Integer.parseInt(customerId), systemId,Integer.parseInt(gridID),gridclass);
	            }
                response.getWriter().print(message);
	        } catch (Exception e) {
	            e.printStackTrace();
	        }
	    }	 
		
		if (param.equals("getUserNames")) {
			try{
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				String custID="";
				if(request.getParameter("CustId")!=null)
				{
				custID=request.getParameter("CustId").toString();
				}				
				jsonArray=ClassInfoFunc.getUserNames(custID,systemId);
				if(jsonArray.length()>0)
				{
				jsonObject.put("snRoot", jsonArray);
				}
				else
				{
				jsonObject.put("snRoot", "");
				}
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {
				System.out.println("Error " + e.toString());
			}
		}
	return null;
	}	    
}
