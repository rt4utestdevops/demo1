package t4u.wastemanagement;

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

public class VehicleOperationWindowAction extends Action{
	
	
	public ActionForward execute(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) {
		
		String param = "";
	    HttpSession session = request.getSession();
	    LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
	    VehicleOperationFunctions vfunc = new VehicleOperationFunctions();
	    int systemId = loginInfo.getSystemId();
	    int userId = loginInfo.getUserId();
	    String lang = loginInfo.getLanguage();
	    
	    JSONObject jsonObject = new JSONObject();
	    if (request.getParameter("param") != null) {
	        param = request.getParameter("param").toString();
	    }
	    if(param.equals("getVehicleNo")){
            try {
            	String clientId=request.getParameter("CustId");
                JSONArray jsonArray = new JSONArray();
                jsonObject = new JSONObject();
                jsonArray = vfunc.getVehicleNo(systemId,Integer.parseInt(clientId),userId);
                if (jsonArray.length() > 0) {
                    jsonObject.put("vehicleNoRoot", jsonArray);
                } else {
                    jsonObject.put("vehicleNoRoot", "");
                }
                response.getWriter().print(jsonObject.toString());
            } catch (Exception e) {
            	 e.printStackTrace();
             }
        }
	    
	    else if (param.equalsIgnoreCase("addAndModifyVehicleDetails")) {
	        try {
	            String buttonValue = request.getParameter("buttonValue");
	        	String custId = request.getParameter("custId");
	        	String vehicleNo = request.getParameter("vehicleNo");
	        	String vehicleType = request.getParameter("vehicleType");
	        	String driverName = request.getParameter("driverName");
	        	String driverContactNo = request.getParameter("driverContactNo");
	        	String district = request.getParameter("district");
	        	String department = request.getParameter("Department");
	        	String governate = request.getParameter("Governate");
	        	String deptContactNo = request.getParameter("deptContactNo");
	        	String deptSupervisor = request.getParameter("deptSupervisor");
	        	String contractor = request.getParameter("contractor");
	        	String deptManager = request.getParameter("DeptManager");
	        	String id = request.getParameter("id");
	            String message="";
	            if(buttonValue.equals("Add") && custId != null && !custId.equals("")){
		                message = vfunc.insertVehicleDetails(systemId,Integer.parseInt(custId),userId, vehicleNo, vehicleType, driverName,driverContactNo,
		                		   district, department, governate, deptContactNo, deptSupervisor, contractor, deptManager);
	            }
	            else if (buttonValue.equals("Modify") && custId != null && !custId.equals("")) {
         	       message = vfunc.modifyVehicleDetails(systemId,Integer.parseInt(custId),userId, vehicleNo, vehicleType, driverName,driverContactNo,
                		   district, department, governate, deptContactNo, deptSupervisor, contractor, deptManager,Integer.parseInt(id));
         }
	            response.getWriter().print(message);
	        } catch (Exception e) {
	            e.printStackTrace();
	        }
	    }
        
	    if (param.equalsIgnoreCase("getVehicleDetails")) {
	        try {
	            String customerId = request.getParameter("CustId");
	            String jspName = request.getParameter("jspName");
	            String custName=request.getParameter("custName");
	            JSONArray jsonArray = new JSONArray();
	            if (customerId != null && !customerId.equals("")) {
	                ArrayList<Object> list1 = vfunc.getVehicleDetails(systemId,Integer.parseInt(customerId),lang);
	                jsonArray = (JSONArray) list1.get(0);
	                if (jsonArray.length() > 0) {
	                    jsonObject.put("vehicleopRoot", jsonArray);
	                } else {
	                    jsonObject.put("vehicleopRoot", "");
	                }
	                ReportHelper reportHelper = (ReportHelper) list1.get(1);
					request.getSession().setAttribute(jspName, reportHelper);
					request.getSession().setAttribute("custId", custName);
	                response.getWriter().print(jsonObject.toString());
	            } else {
	                jsonObject.put("vehicleopRoot", "");
	                response.getWriter().print(jsonObject.toString());
	            }
	        } catch (Exception e) {
	            e.printStackTrace();
	        }
	    }
	    
		return null;
	    }

}




