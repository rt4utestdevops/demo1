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
import t4u.beans.ReportHelper;
import t4u.functions.RakeShiftingFunctions;

public class RakeExpenseMasterAction extends Action {
	
	public ActionForward execute(ActionMapping mapping,ActionForm form,HttpServletRequest request,HttpServletResponse response)
	{
		
		HttpSession session = request.getSession();
        String param = "";
		
        int systemId = 0;
        int userId = 0;
        int offset = 0;
        LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
        
        systemId = loginInfo.getSystemId();
        int customerId = loginInfo.getCustomerId();
       
        userId = loginInfo.getUserId();
        offset = loginInfo.getOffsetMinutes();
        JSONArray jsonArray = null;
		JSONObject jsonObject=null;
        RakeShiftingFunctions rakeExpenseFunc = new RakeShiftingFunctions();
        if (request.getParameter("param") != null) {
			param = request.getParameter("param").toString();
		}
        if(param.equals("AddorModify"))
    	{
    		try
    		{
    			String buttonValue = request.getParameter("buttonValue");
    			String location = request.getParameter("locationId");
    			String loadType = request.getParameter("loadTypecomboId");
    			int loadTypecombo = Integer.parseInt(loadType);
    			double fuelLtrs = Double.parseDouble( request.getParameter("fuelLtrsId"));
    			double fuelRate = Double.parseDouble(request.getParameter("fuelRateId"));
    			double incentive = Double.parseDouble(request.getParameter("incentiveId"));
    			String id = request.getParameter("id");
    			String message = "";
    			if(buttonValue.equals("Add"))
    			{
    				message=rakeExpenseFunc.addRakeExpenseDetails(location,loadTypecombo,fuelLtrs,fuelRate,incentive,systemId,customerId,userId);
    			}
    			else if(buttonValue.equals("Modify"))
    			{
    				message=rakeExpenseFunc.modifyRakeExpenseDetails(fuelLtrs,fuelRate,incentive,userId,systemId,customerId,Integer.parseInt(id));
    			}
    			response.getWriter().print(message);
    		}
    		catch(Exception e)
    		{
    			e.printStackTrace();
    		}
    	}
        
        else if (param.equals("getRakeMasterDetails")) {
        	String jspName=request.getParameter("jspName");
			try {
				jsonObject = new JSONObject();
				ArrayList<Object> fuelLogDetails= rakeExpenseFunc.getRakeMasterDetails(systemId,customerId,offset);
				jsonArray = (JSONArray) fuelLogDetails.get(0);
				if (jsonArray.length() > 0){
					jsonObject.put("rakeMasterRoot", jsonArray);
					ReportHelper reportHelper = (ReportHelper) fuelLogDetails.get(1);
					request.getSession().setAttribute(jspName, reportHelper);
				} else {
					jsonObject.put("rakeMasterRoot", "");
				}
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {
				e.printStackTrace();
		    }
		}
		return null;
	}
}
