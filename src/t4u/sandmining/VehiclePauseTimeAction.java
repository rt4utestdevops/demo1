package t4u.sandmining;

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
import t4u.functions.LTSP_Subscription_Payment_Function;
import t4u.functions.SandMiningFunctions;
import t4u.functions.SandMiningPermitFunctions;
import t4u.functions.VehiclePauseTimeFunction;

public class VehiclePauseTimeAction extends Action {
	public ActionForward execute(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
        HttpSession session = request.getSession();
        String param = "";
        String zone = "";
        int systemId = 0;
        int userId = 0;
        int offset = 0;
        //HttpSession session = request.getSession();
        LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
        SandMiningFunctions sandfunc = new SandMiningFunctions();
        SandMiningPermitFunctions sandpermitfunc=new SandMiningPermitFunctions();
        systemId = loginInfo.getSystemId();
        //String lang = loginInfo.getLanguage();
        int clientId=loginInfo.getCustomerId();
        zone = loginInfo.getZone();
        userId = loginInfo.getUserId();
        offset = loginInfo.getOffsetMinutes();
        String lang = loginInfo.getLanguage();
        zone = loginInfo.getZone();
        CommonFunctions cf = new CommonFunctions();
        JSONArray jsonArray = null;
        JSONObject jsonObject = new JSONObject();
        LTSP_Subscription_Payment_Function LTSPFunction = new LTSP_Subscription_Payment_Function();
        VehiclePauseTimeFunction vptf = new VehiclePauseTimeFunction();
        if (request.getParameter("param") != null) {
            param = request.getParameter("param").toString();
        }
        if(param.equals("getVehicleNo")){
			try{
				String customerId=request.getParameter("CustId");
				jsonObject =new JSONObject();
				jsonArray = vptf.getVehicleNo(systemId,Integer.parseInt(customerId),userId,offset);
				jsonObject.put("vehiclestoreList", jsonArray);
				response.getWriter().print(jsonObject.toString());	
			}
			catch(Exception e){
				e.printStackTrace();
			}
		}
        else if (param.equals("addModifyPauseTimeDetails"))
		{
			try{
				 String buttonValue = request.getParameter("buttonValue"); 
		         String custId =request.getParameter("custId");
		         String vehicleNo = request.getParameter("vehicleNoAdd");
		         String startDate=request.getParameter("pauseStartTime").replace("T", " ");
	             String endDate=request.getParameter("pauseEndTime").replace("T", " ");
	             String reason=request.getParameter("pauseReason");
	             String id=request.getParameter("IdModify");
	             String remarks=request.getParameter("remarks");
	             String message = "";
	             if(buttonValue.equals("Add") && custId != null && !custId.equals("")){
	            	 message = vptf.addVehiclePauseTimeDetails(systemId, Integer.parseInt(custId),userId, vehicleNo, startDate, endDate, reason,remarks);
	            	 
	             }else{
	            	 message = vptf.modifyPauseTimeDetails(systemId, Integer.parseInt(custId),userId, vehicleNo, startDate, endDate, reason,Integer.parseInt(id));
	             }
	             response.getWriter().print(message);
			} catch (Exception e) {
	         	 e.printStackTrace();
	          }
	  }
        else if (param.equals("getVehiclePauseTimeDetails"))
		{
		try{
		jsonArray = new JSONArray();
        jsonObject = new JSONObject();
        String jspName=null;
        String custId=request.getParameter("CustId");
        String custName=request.getParameter("custName");
        String startDate = request.getParameter("startDate");
        String endDate = request.getParameter("endDate");
        startDate=cf.getFormattedDateddMMYYYY(startDate.replaceAll("T"," "));
        endDate=cf.getFormattedDateddMMYYYY(endDate.replaceAll("T"," "));
		  if(request.getParameter("jspname")!=null)
		     jspName=request.getParameter("jspname");
		     else
		     jspName=""; 
		     ArrayList<Object> list1 = vptf.getVehiclePauseTimeDetails(systemId,Integer.parseInt(custId),startDate,endDate);
		     jsonArray = (JSONArray) list1.get(0);
		 	if (jsonArray.length() > 0) {
		 	jsonObject.put("vehiclePauseTimeroot", jsonArray);
		 	}
		 	else
		 	{
		 	jsonObject.put("vehiclePauseTimeroot", "");
		 	}	
		 	ReportHelper reportHelper = (ReportHelper) list1.get(1);
		 	request.getSession().setAttribute(jspName, reportHelper);
		 	request.getSession().setAttribute("custId", custName);
		 	response.getWriter().print(jsonObject.toString());
		 	
		     } catch (Exception e) {
		     	 e.printStackTrace();
		      }
		 }  
        
        
        return null;
    }
}
