package t4u.staffTransportationSolution;

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
import org.omg.CORBA.Request;

import t4u.beans.LoginInfoBean;
import t4u.functions.AdminFunctions;
import t4u.functions.CashVanManagementFunctions;
import t4u.functions.CommonFunctions;
import t4u.functions.StaffTransportationSolutionFunctions;
import t4u.functions.TripFunction;

public class ShiftMasterAction extends Action
{
public ActionForward execute(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) {
   	 
    	
    	HttpSession session = request.getSession();
        String param = "";
        String zone = "";
        int systemId = 0;
        int userId = 0;
        int offset = 0;
        LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
        AdminFunctions adfunc = new AdminFunctions();
        systemId = loginInfo.getSystemId();
        userId = loginInfo.getUserId();
        StaffTransportationSolutionFunctions stsfunc = new StaffTransportationSolutionFunctions();
        JSONArray jsonArray = null;
        JSONObject jsonObject = new JSONObject();
        if (request.getParameter("param") != null) {
            param = request.getParameter("param").toString();
        }

	
	
	if(param.equalsIgnoreCase("AddorModify"))
	{
		try
		{
			float startTime = 0.0f;
			float endTime = 0.0f;
			String buttonValue = request.getParameter("buttonValue");
			String custId=request.getParameter("CustId");
			String shiftName=request.getParameter("ShiftName");
            if(request.getParameter("StartTime")!=null && !request.getParameter("StartTime").equals("")){
			String startTimes=request.getParameter("StartTime");
			startTime = Float.parseFloat(startTimes.replace(":", "."));
			}
			if(request.getParameter("EndTime")!= null && !request.getParameter("EndTime").equals("")){
			String endTimes=request.getParameter("EndTime");
			endTime = Float.parseFloat(endTimes.replace(":", "."));
			}
			String status=request.getParameter("Status");
            String shiftId = request.getParameter("ShiftId");
            String branchId=request.getParameter("BranchId");
			String message="";
			if(buttonValue.equals("Add") && custId != null && !custId.equals(""))
			{
				message=stsfunc.addShiftDetails(shiftName,startTime,endTime,status,systemId,Integer.parseInt(custId),userId,Integer.parseInt(branchId));
				
			}else if(buttonValue.equals("Modify") && custId != null && !custId.equals(""))
			{
				message=stsfunc.modifyShiftMaster(shiftName,startTime,endTime,status,systemId,Integer.parseInt(custId),userId,Integer.parseInt(shiftId),Integer.parseInt(branchId));
			}
			
			response.getWriter().print(message);
		}catch(Exception e)
		{
			e.printStackTrace();
		}
	}
	else if(param.equalsIgnoreCase("getShiftMasterDetails"))
	{
		try {
            String customerId = request.getParameter("CustId");
            jsonArray = new JSONArray();
            if (customerId != null && !customerId.equals("")) {
                ArrayList < Object > list1 = stsfunc.getShiftMasterDetails(systemId, Integer.parseInt(customerId));
                jsonArray = (JSONArray) list1.get(0);
                if (jsonArray.length() > 0) {
                    jsonObject.put("ShiftMasterRoot", jsonArray);
                } else {
                    jsonObject.put("ShiftMasterRoot", "");
                }
                response.getWriter().print(jsonObject.toString());
            } else {
                jsonObject.put("ShiftMasterRoot", "");
                response.getWriter().print(jsonObject.toString());
            }
        }catch (Exception e) {
			e.printStackTrace();
		}
	}else if(param.equals("getBranch")){
		try{
			
			String clientId = request.getParameter("clientId");
			   jsonObject = new JSONObject();
			   jsonArray = new JSONArray();
			if(clientId != null && !clientId.equals("")){			
				jsonArray = stsfunc.getBranchName(systemId, Integer.parseInt(clientId));				
				jsonObject.put("BranchStoreRootUser", jsonArray);
			}else{
				jsonObject.put("BranchStoreRootUser", "");
			}			
			response.getWriter().print(jsonObject.toString());
		}
		catch(Exception e){
			e.printStackTrace();
		}
	}else if(param.equals("getShiftDetailsForValidation")){
		try{
			
			String clientId = request.getParameter("clientId");
			String branchId = request.getParameter("BranchId");
			   jsonObject = new JSONObject();
			   jsonArray = new JSONArray();
			if(clientId != null && !clientId.equals("") && branchId != null && !branchId.equals("") ){			
				jsonArray = stsfunc.getShiftDetailsForVakidation(systemId, Integer.parseInt(clientId),Integer.parseInt(branchId));				
				jsonObject.put("getShiftDetailsForValidationR", jsonArray);
			}else{
				jsonObject.put("getShiftDetailsForValidationR", "");
			}			
			response.getWriter().print(jsonObject.toString());
		}
		catch(Exception e){
			e.printStackTrace();
		}
	}

	if(param.equalsIgnoreCase("deleteShiftDetails"))
	{
		try
		{
			String custId=request.getParameter("CustId");
			
            String shiftId = request.getParameter("ShiftId");
			String message="";
			
			message=stsfunc.deleteShiftDetails(systemId, Integer.parseInt(custId), Integer.parseInt(shiftId));
						
			response.getWriter().print(message);
		}catch(Exception e)
		{
			e.printStackTrace();
		}
	}
	
	
	
	return null;
	}
}	
		
	


