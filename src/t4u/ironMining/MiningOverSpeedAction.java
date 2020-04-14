package t4u.ironMining;

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
import t4u.functions.IronMiningFunction;

public class MiningOverSpeedAction extends Action {
	@SuppressWarnings("unchecked")
	public ActionForward execute(ActionMapping mapping, ActionForm form,HttpServletRequest request, HttpServletResponse response) throws Exception {
		HttpSession session = request.getSession();
		ReportHelper reportHelper = null;
		LoginInfoBean loginInfo =(LoginInfoBean)session.getAttribute("loginInfoDetails");
		int systemId  = loginInfo.getSystemId();
		//int customerId = loginInfo.getCustomerId();
		int userId = loginInfo.getUserId();
		int offset = loginInfo.getOffsetMinutes();
		String lang = loginInfo.getLanguage();
		CommonFunctions cf=new CommonFunctions();
		IronMiningFunction ironfunc = new IronMiningFunction();
		JSONArray jsonArray = null;
		JSONObject jsonObject=null;
		String param = "";
		if (request.getParameter("param") != null) {
			param = request.getParameter("param").toString();
		}
		if (param.equalsIgnoreCase("getMiningOverSpeedDetails")) {
	        try {
	        	ArrayList list=null;
	            String CustomerId = request.getParameter("CustId");
	            String startDate = request.getParameter("StartDate");
	    		String endDate = request.getParameter("EndDate");
	    		String jspName=request.getParameter("jspName");
	    		String custName = request.getParameter("custName");
	    		String groupId=request.getParameter("groupId");
	    		String groupName=request.getParameter("groupName");
	    		
	    		//System.out.println("CustomerId:"+CustomerId+"startDate:"+startDate +"endDate:"+endDate +"jspName:"+jspName +"custName:"+custName+"groupId"+groupId);
	    		
	            jsonArray = new JSONArray();
	            jsonObject = new JSONObject();
	            
	            if (CustomerId != null && !CustomerId.equals("")) {
	            	//if (s !=null && !s.equals("")) {
	            						
	                list =ironfunc.getMiningOverSpeedReportDetails(systemId, Integer.parseInt(CustomerId), userId,startDate,endDate,lang,groupId,offset);
	                jsonArray = (JSONArray) list.get(0);
	                if (jsonArray.length() > 0) {
	                    jsonObject.put("miningOverSpeedReportDetailsRoot", jsonArray);
	                } else {
	                    jsonObject.put("miningOverSpeedReportDetailsRoot", "");
	                }
	                if (startDate.contains("T")) {
						startDate = startDate.replaceAll("T", " ");
						startDate = startDate.substring(0,startDate.indexOf(" "));
						startDate = startDate +" 00:00:00";
					}else{
						startDate = startDate.substring(0,startDate.indexOf(" "));
						startDate = startDate +" 00:00:00";
					}
					if (endDate.contains("T")) {
						endDate = endDate.replaceAll("T", " ");
						endDate = endDate.substring(0,endDate.indexOf(" "));
						endDate = endDate +" 00:00:00";
					}else{
						endDate = endDate.substring(0,endDate.indexOf(" "));
						endDate = endDate +" 00:00:00";
					}
	                reportHelper = (ReportHelper) list.get(1);
	                request.getSession().setAttribute(jspName,reportHelper);
		    		request.getSession().setAttribute("startdate",cf.getFormattedDateddMMYYYY(startDate));
		    		request.getSession().setAttribute("enddate",cf.getFormattedDateddMMYYYY(endDate));
		    		request.getSession().setAttribute("custId", custName);
		    		request.getSession().setAttribute("groupName", groupName);
	                response.getWriter().print(jsonObject.toString());
	            	
	            } else {
	                jsonObject.put("miningOverSpeedReportDetailsRoot", "");
	                response.getWriter().print(jsonObject.toString());
	            }
	        } catch (Exception e) {
	            e.printStackTrace();
	        }
		}
		return null;
	}
}
