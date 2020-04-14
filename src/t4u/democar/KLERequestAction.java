package t4u.democar;

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
import t4u.functions.DemoCarFunctions;

public class KLERequestAction  extends Action {
	
 public ActionForward execute(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) {
   	 
    	
    	HttpSession session = request.getSession();
        String param = "";
        int systemId = 0;
        int userId = 0;
        int offset = 0;
        LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
        systemId = loginInfo.getSystemId();
        userId = loginInfo.getUserId();
        offset = loginInfo.getOffsetMinutes();
        DemoCarFunctions dcf = new DemoCarFunctions();
        CommonFunctions cf = new CommonFunctions();
        JSONArray jsonArray = null;
        JSONObject jsonObject = new JSONObject();
        if (request.getParameter("param") != null) {
            param = request.getParameter("param").toString();
        }	

        if(param.equals("getRegNos"))
		{
			String cid = request.getParameter("CustId");
			if( request.getParameter("CustId")!=null && !request.getParameter("CustId").equals(""))
			{
			JSONArray vehicleJsonArr = new JSONArray();
			JSONObject vehicleJsonObj = new JSONObject();
			try {
				vehicleJsonArr = dcf.getAssetNumberList(systemId, cid ,userId);
				
				if(vehicleJsonArr.length() > 0)
				{
					vehicleJsonObj.put("RegNos", vehicleJsonArr);
				}else{
					vehicleJsonObj.put("RegNos", "");
				}
				
				 response.getWriter().print(vehicleJsonObj);
			} catch (Exception e) {
				e.printStackTrace();
			}
		  }
		}
         
	    else if (param.equalsIgnoreCase("save")) {
	        try {
	            String custId = request.getParameter("CustId");
	            String registrationNo = request.getParameter("registrationNo");
	            String commandType = request.getParameter("commandType");
	            boolean door=false;
	            boolean key=false;
	            String commandMode=request.getParameter("commandMode");
	           
	            if(commandType.equalsIgnoreCase("LOCK")||commandType.equalsIgnoreCase("UNLOCK")){
	            	door=Boolean.parseBoolean(request.getParameter("doorChecked"));
		            key=Boolean.parseBoolean(request.getParameter("keyChecked"));
	            }
	            String message="";
	            if (custId != null && !custId.equals("")) {
	               message = dcf.checkForValidation(Integer.parseInt(custId),registrationNo,commandType,systemId,userId,key,door,commandMode);
	            } 
	            response.getWriter().print(message);
	        } catch (Exception e) {
	            e.printStackTrace();
	        }
	    }
	    
	    
	    else if (param.equalsIgnoreCase("getKLERequestReport")) {
	        try {
	            String customerId = request.getParameter("CustId");
	            String startDate = request.getParameter("startdate");
				String endDate = request.getParameter("enddate");
				String jspName=request.getParameter("jspName");
				String pageName=request.getParameter("pageName");
	            jsonArray = new JSONArray();
	            if (customerId != null && !customerId.equals("")) {
	            	ArrayList<Object> klrRequestList = dcf.getKLERequestReport(Integer.parseInt(customerId),systemId,offset,startDate,endDate,pageName);
	            	jsonArray = (JSONArray) klrRequestList.get(0);
	            	if (jsonArray.length() > 0) {
	                    jsonObject.put("KLERequestRoot", jsonArray);
	                } else {
	                    jsonObject.put("KLERequestRoot", "");
	                }
	                ReportHelper reportHelper = (ReportHelper) klrRequestList.get(1);
	                request.getSession().setAttribute(jspName, reportHelper);
	                request.getSession().setAttribute("startdate",cf.getFormattedDateddMMYYYY(startDate.replaceAll("T", " ")));
					request.getSession().setAttribute("enddate",cf.getFormattedDateddMMYYYY(endDate.replaceAll("T", " ")));
					response.getWriter().print(jsonObject.toString());
	            } else {
	                jsonObject.put("KLERequestRoot", "");
	                response.getWriter().print(jsonObject.toString());
	            }
	        } catch (Exception e) {
	            e.printStackTrace();
	        }
	    } else if(param.equalsIgnoreCase("getSpeed"))
		{
			try
			{
				String regNo = request.getParameter("regNo");
				String message = "";
				int clientId = Integer.parseInt(request.getParameter("CustId").toString());
				message= dcf.getSpeed(clientId,systemId,regNo);
				response.getWriter().print(message);
			}
			catch (Exception e) 
			{
				e.printStackTrace();
			}
		}
	    else if (param.equalsIgnoreCase("getLatLong")) {
			jsonObject = new JSONObject();
			jsonArray = new JSONArray();
			String vehicleNo=request.getParameter("vehicleNo");
			CommonFunctions cfuncs = new CommonFunctions();
			try {
				jsonArray = cfuncs.getLiveVisionDetails(vehicleNo);				
				if(jsonArray.length()>0){
					jsonObject.put("latLongRoot",jsonArray);
				}else{
					jsonObject.put("latLongRoot","");
				}
				response.getWriter().print(jsonObject.toString());	
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
	    	  	    
	    
        return null;
 }
 }
