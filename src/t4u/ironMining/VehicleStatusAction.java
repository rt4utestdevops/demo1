package t4u.ironMining;

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
import t4u.functions.IronMiningFunction;

public class VehicleStatusAction extends Action {
	@SuppressWarnings("unchecked")
	public ActionForward execute(ActionMapping mapping, ActionForm form,HttpServletRequest request, HttpServletResponse response) throws Exception {
		HttpSession session = request.getSession();
		LoginInfoBean loginInfo =(LoginInfoBean)session.getAttribute("loginInfoDetails");
		int systemId  = loginInfo.getSystemId();
		int customerId = loginInfo.getCustomerId();
		int userId = loginInfo.getUserId();
		String lang = loginInfo.getLanguage();
		CommonFunctions cf=new CommonFunctions();
		IronMiningFunction ironfunc = new IronMiningFunction();
		JSONArray jsonArray = null;
		JSONObject jsonObject=null;
		String message="";
		String param = "";
		if (request.getParameter("param") != null) {
			param = request.getParameter("param").toString();
		}
		
		if (param.equals("getVehicleDetails")) {
			try {
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				String customerid=request.getParameter("custId");
				if(request.getParameter("custId")!=null && !request.getParameter("custId").equals("")){
					jsonArray = ironfunc.getVehicleDetails(systemId,Integer.parseInt(customerid));
				if (jsonArray.length() > 0) {
					jsonObject.put("VehicleRoot", jsonArray);
				} else {
					jsonObject.put("VehicleRoot", "");
				}
				}
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		} 
		
	
	
		else if (param.equals("getVehicleInformation")) {
		try {
			jsonArray = new JSONArray();
			jsonObject = new JSONObject();
			
			String assetNo=request.getParameter("vehicleNo");
			String customerid=request.getParameter("custId");
			
			if(request.getParameter("custId")!=null && !request.getParameter("custId").equals("")){
			jsonArray = ironfunc.getVehicleInformation(systemId,Integer.parseInt(customerid),assetNo);
			if (jsonArray.length() > 0) {
				jsonObject.put("VehicleDetailsRoot", jsonArray);
			} else {
				jsonObject.put("VehicleDetailsRoot", "");
			}
			}
			response.getWriter().print(jsonObject.toString());
		} catch (Exception e) {
			e.printStackTrace();
		}
	} 
		
		else if(param.equals("UpdateEnroll")){
	                    try {
	                    	String assetNo=request.getParameter("VehicleNo");
	            			String Enrollment=request.getParameter("EnrolledStatus");
	            			if(Enrollment.equalsIgnoreCase("OPEN")){
	            				Enrollment="CLOSE";
	            			}else{
	            				Enrollment="OPEN";
	            			}
	                    	message ="success";
	                    	if(!Enrollment.trim().equalsIgnoreCase(" ")){
	                            message = ironfunc.upadteAssetEnrollmentStatus(assetNo,Enrollment,systemId);
	                    	}else {
		                    message = "No Data To Save";
		                }
		                response.getWriter().print(message);
	                    } catch (Exception e) {
	                        e.printStackTrace();
	                    }
	              
			
		}
	return null;
}
}
