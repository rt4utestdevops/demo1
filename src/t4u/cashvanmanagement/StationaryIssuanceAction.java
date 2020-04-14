package t4u.cashvanmanagement;

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
import t4u.functions.CashVanManagementFunctions;

public class StationaryIssuanceAction  extends Action {
@Override
public ActionForward execute(ActionMapping mapping, ActionForm form,HttpServletRequest request, HttpServletResponse response)throws Exception {
	// TODO Auto-generated method stub
	
	String param = "";
	String message = "";		
	HttpSession session = request.getSession();
	LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");

	int systemId = loginInfo.getSystemId();
	int userId = loginInfo.getUserId();
	int offset = loginInfo.getOffsetMinutes();
	int customerId = loginInfo.getCustomerId();
	String lang = loginInfo.getLanguage();

	CommonFunctions cf = new CommonFunctions();
	CashVanManagementFunctions function=null;
	JSONArray jsonArray = null;
	if (request.getParameter("param") != null) {
		param = request.getParameter("param").toString();
	}



	/**
	 * return branch against which we are doing inventory
	 */
	if(param.equalsIgnoreCase("getBranches")){
		function=new CashVanManagementFunctions();
		 JSONObject JsonObject = new JSONObject();
		
		 JSONArray jsonarray=function.getBranches(systemId, customerId);
		 
			if (jsonarray.length() > 0) {
				JsonObject.put("branches", jsonarray);
			} else {
				JsonObject.put("branches", "");
			}
			response.getWriter().print(JsonObject.toString());
	}

		

	

	
	else if(param.equalsIgnoreCase("getStationaryIssuance")){
		 function=new CashVanManagementFunctions();
		 JSONObject JsonObject = new JSONObject();
		 JsonObject = new JSONObject();
			String dateStr=request.getParameter("startDate");
			String endDate=request.getParameter("endDate");
			Integer branchId=Integer.parseInt(request.getParameter("branch"));
			
		jsonArray=function.getStationaryIssuance(dateStr,endDate,branchId,systemId,customerId,userId);
		
		if(jsonArray!=null && jsonArray.length()>0){
		JsonObject.put("issuance",jsonArray);
				 response.getWriter().print(JsonObject.toString());
		}else{
			JsonObject.put("issuance","");
			 response.getWriter().print(JsonObject.toString());
		}
	}
	
	else if(param.equalsIgnoreCase("saveIssuance")){
		String customerid=request.getParameter("CustId");
		String dateStr=request.getParameter("issueDate");
		int toBranch=Integer.parseInt(request.getParameter("toBranch"));
		int fromBranch=Integer.parseInt(request.getParameter("fromBranch"));
		int stationaryId=Integer.parseInt(request.getParameter("stationaryId"));
		String dept=request.getParameter("dept");
		int count=Integer.parseInt(request.getParameter("quantity"));
		function=new CashVanManagementFunctions();
		 int availableCount=function.getStationaryAvailabilityCount(stationaryId,fromBranch,systemId,Integer.parseInt(customerid));
		 if(availableCount>=count){
			String msg= function.saveIssuance(stationaryId,fromBranch,toBranch,count,dateStr,dept,systemId,customerId,userId);
			 response.getWriter().print(msg);
		 }else{
			 response.getWriter().print("Unable to issue "+count+" available quantity is  "+availableCount);
		 }
		
	}
	
	else if(param.equalsIgnoreCase("armoryItems")){
		function=new CashVanManagementFunctions();
		 JSONObject JsonObject = new JSONObject();
		//Integer custId=Integer.parseInt(request.getParameter("CustId"));
		 JSONArray jsonarray=function.getArmoryItems(systemId, customerId);
		 
			if (jsonarray.length() > 0) {
				JsonObject.put("armoryItems", jsonarray);
			} else {
				JsonObject.put("armoryItems", "");
			}
			response.getWriter().print(JsonObject.toString());
	}
return null;
}
}
