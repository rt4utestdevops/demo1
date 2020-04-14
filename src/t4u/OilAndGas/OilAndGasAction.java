package t4u.OilAndGas;

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
import t4u.functions.OilAndGasFunctions;


public class OilAndGasAction extends Action{
	
	public ActionForward execute(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) throws Exception {
		 String param = "";
		String message = "";
		String zone="";
		int systemId=0;
		int userId=0;
		int offset=0;
		HttpSession session = request.getSession();
		LoginInfoBean loginInfo=(LoginInfoBean)session.getAttribute("loginInfoDetails");
		OilAndGasFunctions oilAndGas = new OilAndGasFunctions();
		systemId=loginInfo.getSystemId();
		zone=loginInfo.getZone();
		userId=loginInfo.getUserId();
		offset=loginInfo.getOffsetMinutes();
		String lang = loginInfo.getLanguage();
		zone = loginInfo.getZone();
		CommonFunctions cf = new CommonFunctions();
		JSONArray jsonArray = null;
		JSONObject jsonObject = new JSONObject();
		if (request.getParameter("param") != null) {
			param = request.getParameter("param").toString();
		}  
	
	
		if (param.equals("getAssetNumber")) {
			try {
				String customerId = request.getParameter("CustId");
				String type = request.getParameter("type");
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();	
               	
				if (customerId != null && !customerId.equals("")) {
					
					jsonArray = oilAndGas.getAssetNumber(systemId, Integer.parseInt(customerId),userId,type);
					jsonObject.put("assetNumberRoot", jsonArray);
				}
				else {
					jsonObject.put("assetNumberRoot", "");
				}
				response.getWriter().print(jsonObject.toString());
			}
			catch (Exception e) {
				e.printStackTrace();
			}
		}
	
	
		if (param.equalsIgnoreCase("getOilAndGasReport")) {
	        try {
	            String customerId = request.getParameter("CustId");
	            String startDate= request.getParameter("startDate");
	            String endDate= request.getParameter("endDate");
	            String custName=request.getParameter("CustName");
	            String jspName=request.getParameter("jspName");
	            String assetNumber=request.getParameter("assetNumber");
	            String type=request.getParameter("type");
	            jsonArray = new JSONArray();
	            
	            if (customerId != null && !customerId.equals("")) {
                   	ArrayList < Object > list1 = oilAndGas.getOilAndGasReport(systemId, Integer.parseInt(customerId), userId, lang,startDate,endDate,assetNumber,type,offset,zone);
	            	jsonArray = (JSONArray) list1.get(0);
	                if (jsonArray.length() > 0) {
	                    jsonObject.put("lidAndValvesReportRoot", jsonArray);
	                } else {
	                    jsonObject.put("lidAndValvesReportRoot", "");
	                }
	                ReportHelper reportHelper = (ReportHelper) list1.get(1);
	                request.getSession().setAttribute(jspName, reportHelper);
	                request.getSession().setAttribute("customerId", custName);
	                request.getSession().setAttribute("startDate",cf.getFormattedDateddMMYYYY(startDate.replaceAll("T", " ")));
		    		request.getSession().setAttribute("endDate",cf.getFormattedDateddMMYYYY(endDate.replaceAll("T", " ")));
		    		response.getWriter().print(jsonObject.toString());
	            } else {
	                jsonObject.put("lidAndValvesReportRoot", "");
	                response.getWriter().print(jsonObject.toString());
	            }
	            
	        } catch (Exception e) {
	            e.printStackTrace();
	        }
	
    	}	

			return null;
	}
	}