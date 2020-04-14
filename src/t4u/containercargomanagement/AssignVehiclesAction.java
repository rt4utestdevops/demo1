package t4u.containercargomanagement;

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
import t4u.functions.CommonFunctions;
import t4u.functions.ContainerCargoManagementFunctions;

public class AssignVehiclesAction extends Action {
	@SuppressWarnings("unchecked")
	public ActionForward execute(ActionMapping mapping, ActionForm form,HttpServletRequest request, HttpServletResponse response) throws Exception {
		HttpSession session = request.getSession();
		LoginInfoBean loginInfo =(LoginInfoBean)session.getAttribute("loginInfoDetails");
		int systemId  = loginInfo.getSystemId();
		int customerId = loginInfo.getCustomerId();
		int userId = loginInfo.getUserId();
		int offset = loginInfo.getOffsetMinutes();
		ContainerCargoManagementFunctions cfunc = new ContainerCargoManagementFunctions();
		JSONArray jsonArray = null;
		JSONObject jsonObject=null;
		String param = "";
		if (request.getParameter("param") != null) {
			param = request.getParameter("param").toString();
		}
		if (param.equals("getVehicles")) {
			try {
				jsonObject = new JSONObject();
				jsonArray = cfunc.getVehicleNo(customerId, systemId, userId);
				if (jsonArray.length() > 0) {
					jsonObject.put("vehicleStoreRoot", jsonArray);
				} else {
					jsonObject.put("vehicleStoreRoot", "");
				}
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		else if(param.equals("getPrinicipalStore")){
			try{
				jsonObject = new JSONObject();
				jsonArray = cfunc.getPrincipalStore(systemId,customerId);
				if(jsonArray.length() > 0){
					jsonObject.put("principalStoreRoot", jsonArray);
				}else{
					jsonObject.put("principalStoreRoot", "");
				}
				response.getWriter().print(jsonObject.toString());
			}catch(Exception e){
				e.printStackTrace();
			}
		}
		else if(param.equals("getConsigneeStore")){
			try{
				jsonObject = new JSONObject();
				jsonArray = cfunc.getConsigneeStore(systemId,customerId);
				if(jsonArray.length() > 0){
					jsonObject.put("consigneeStoreRoot", jsonArray);
				}else{
					jsonObject.put("consigneeStoreRoot", "");
				}
				response.getWriter().print(jsonObject.toString());
			}catch(Exception e){
				e.printStackTrace();
			}
		}
		else if (param.equalsIgnoreCase("getAssignedVehiclesDetails")) {
	        try {
	        	ArrayList list=null;
	            jsonArray = new JSONArray();
	            jsonObject = new JSONObject();
	            	
	                list =cfunc.getAssignedVehiclesDetails(systemId, customerId, offset);
	                jsonArray = (JSONArray) list.get(0);
	                if (jsonArray.length() > 0) {
	                    jsonObject.put("assignVehiclesRoot", jsonArray);
	                } else {
	                    jsonObject.put("assignVehiclesRoot", "");
	                }
	                response.getWriter().print(jsonObject.toString());
	            	
	            }
	         catch (Exception e) {
	            e.printStackTrace();
	        }
    	}
		else if (param.equalsIgnoreCase("AddorModifyAssignedVehicleDetails")) {
			try {

				String buttonValue = request.getParameter("buttonValue");
				String vehicle=request.getParameter("vehicle");
				int principal=0;
				int consignee=0;
				String id= request.getParameter("id");
				String message="";
				
				if(!request.getParameter("vehicle").equals("") && request.getParameter("vehicle")!=null){
					vehicle=request.getParameter("vehicle");
				}
				if(!request.getParameter("principal").equals("") && request.getParameter("principal")!=null){
					principal=Integer.parseInt(request.getParameter("principal"));
				}
				if(!request.getParameter("consignee").equals("") && request.getParameter("consignee")!=null){
					consignee=Integer.parseInt(request.getParameter("consignee"));
				}
				if(buttonValue.equals("Add"))
				{
                     message=cfunc.addAssignedVehicledetails(vehicle,principal,systemId,consignee,customerId,userId);
				}else if(buttonValue.equals("Modify"))
				{
					message=cfunc.modifyAssignedVehicledetails(vehicle,principal,systemId,consignee,customerId,userId,Integer.parseInt(id));
				}
				
				response.getWriter().print(message);
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		return null;
	}
}
