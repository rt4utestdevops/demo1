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

public class ManageRouteAction extends Action {

	public ActionForward execute(ActionMapping mapping, ActionForm form,HttpServletRequest request, HttpServletResponse response)throws Exception {
		String param = "";
		String message = "";		
		HttpSession session = request.getSession();
		EmployeetrackingFunctions etf = new EmployeetrackingFunctions();
		LoginInfoBean  logininfo=(LoginInfoBean)session.getAttribute("loginInfoDetails"); 
		CommonFunctions cfuncs = new CommonFunctions();
		int systemId = logininfo.getSystemId();
		int userId = logininfo.getUserId();
        int offset = logininfo.getOffsetMinutes();
		JSONArray jsonArray = null;
		JSONObject jsonObject = new JSONObject();
		if (request.getParameter("param") != null) {
			param = request.getParameter("param").toString();
		}
		if(param.equals("getRegNos"))
		{
			String cid = request.getParameter("clientId");
			if( request.getParameter("clientId")!=null && !request.getParameter("clientId").equals(""))
			{
			List vehicleList =  etf.getVehiclesforManageRoute(String.valueOf(systemId),cid,userId);
			JSONArray vehicleJsonArr = new JSONArray();
			JSONObject vehicleJsonObj = new JSONObject();
			try {
				if(vehicleList.size() > 0)
				{
					for(int i=0; i < vehicleList.size(); i++)
					{
						LabelValueBean labelValueBean = (LabelValueBean)vehicleList.get(i);
						if(!labelValueBean.getLabel().equals("All"))
						{
							JSONObject obj1 = new JSONObject();
							obj1.put("Registration_no",labelValueBean.getValue()); 
							vehicleJsonArr.put(obj1);
						}
					}
				}
				vehicleJsonObj.put("RegNos", vehicleJsonArr);;
				response.getWriter().print(vehicleJsonObj.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		  }
		}
		else if (param.equals("getRouteDetails")) {

			try {
				
				ArrayList list=null;
				String jspName = request.getParameter("jspName");
				String custName = request.getParameter("custName");
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				String customerId = "0";
				if (request.getParameter("CustId") != null && !request.getParameter("CustId").equals("")) {
					customerId = request.getParameter("CustId").toString();
				
				if (Integer.parseInt(customerId) > 0) {
					list = etf.getManageRouteDetails(Integer.parseInt(customerId), systemId,offset);
				}
				jsonArray = (JSONArray) list.get(0);
				if (jsonArray.length() > 0) {
					jsonObject.put("routeDetails", jsonArray);
				} else {
					jsonObject.put("routeDetails", "");
				}
				ReportHelper reportHelper = (ReportHelper) list.get(1);
				request.getSession().setAttribute(jspName,reportHelper);
				request.getSession().setAttribute("custId", custName);
		        response.getWriter().print(jsonObject);	
			}else {
				jsonObject.put("employmentReportRoot", "");
				response.getWriter().print(jsonObject);
			}
			}
			 catch (Exception e) {
				e.printStackTrace();
				System.out.println("Error in EmployeeTrackingAction:-getRouteDetails"+ e);
			}
		}
		 else if (param.equalsIgnoreCase("manageRouteAddAndModify")) {
		        try {
		        	String custId = request.getParameter("CustId");
		            String routeCode = request.getParameter("routeCode");
		            String buttonValue = request.getParameter("buttonValue");
		            String startTime = request.getParameter("startTime");
		            String endTime = request.getParameter("endTime");
		            String approxDistance = request.getParameter("approDistance");
		            String approxTime = request.getParameter("approTime");
		            String assetNumber = request.getParameter("assetNumber");
		            String id= request.getParameter("id");
		            String pickDrop= request.getParameter("type");
		            message="";
		            if (buttonValue.equals("Add") && custId != null && !custId.equals("")) {
		                message = etf.insertRouteInformation(Integer.parseInt(custId),routeCode,startTime,endTime,approxDistance,approxTime,assetNumber,systemId,userId,pickDrop);
		            } else if (buttonValue.equals("Modify") && custId != null && !custId.equals("")) {
		            	 message = etf.modifyRouteInformation(Integer.parseInt(custId),routeCode,startTime,endTime,approxDistance,approxTime,assetNumber,systemId,Integer.parseInt(id),pickDrop,userId);
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
		                message = etf.deleteRecord(Integer.parseInt(customerId), systemId,Integer.parseInt(id));
		            }
	                response.getWriter().print(message);
		        } catch (Exception e) {
		            e.printStackTrace();
		        }
		    }	    
		    
	        return null;
	 }
	}

