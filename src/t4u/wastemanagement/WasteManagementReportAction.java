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
import t4u.functions.WastemanagementFunctions;

public class WasteManagementReportAction extends Action{
	
	
	public ActionForward execute(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) {
		
		String param = "";
	    HttpSession session = request.getSession();
	    LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
	    WastemanagementFunctions WasteManagementFunction = new WastemanagementFunctions();
	    int systemId = loginInfo.getSystemId();
	    int offset = loginInfo.getOffsetMinutes();
	    String lang = loginInfo.getLanguage();
	    int userId = loginInfo.getUserId();
	    CommonFunctions cf=new CommonFunctions();
	    JSONArray jsonArray = null;
	    JSONObject jsonObject = new JSONObject();
	    if (request.getParameter("param") != null) {
	        param = request.getParameter("param").toString();
	    }
		
	    // ********************************************* Get Asset Type ****************************************************
	    
	    if (param.equalsIgnoreCase("getAssetType")) {
	        try {
	            String customerId = request.getParameter("CustId");
	            jsonArray = new JSONArray();
	            jsonObject = new JSONObject();
	            if (customerId != null && !customerId.equals("")) {

	                jsonArray = WasteManagementFunction.getAssetTypeDetails(systemId, Integer.parseInt(customerId), userId);

	                if (jsonArray.length() > 0) {
	                    jsonObject.put("assetTypeRoot", jsonArray);
	                } else {
	                    jsonObject.put("assetTypeRoot", "");
	                }
	                response.getWriter().print(jsonObject.toString());
	             } else {
	                jsonObject.put("assetTypeRoot", "");
	            }
	        } catch (Exception e) {
	            e.printStackTrace();
	        }
	    } else { 
	    	if (param.equalsIgnoreCase("getAssetNumber")) {
		        try {
		            String customerId = request.getParameter("CustId");
		            String assettype = request.getParameter("AssetType");
		            jsonArray = new JSONArray();
		            jsonObject = new JSONObject();
		            
		            if (customerId != null && !customerId.equals("")) {

		                jsonArray = WasteManagementFunction.getAssetNumberDetails(systemId, Integer.parseInt(customerId), userId, assettype);

		                if (jsonArray.length() > 0) {
		                    jsonObject.put("managerAssetRoot", jsonArray);
		                } else {
		                    jsonObject.put("managerAssetRoot", "");
		                }
		                response.getWriter().print(jsonObject.toString());
		            } else {
		                jsonObject.put("managerAssetRoot", "");
		            }
		        } catch (Exception e) {
		            e.printStackTrace();
		        }
		
	    	}
	    	else if(param.equals("getWasteManagementSummaryReport"))
	    	{
	    		String custId = request.getParameter("CustId");
	    		String startDate = request.getParameter("StartDate");
	    		String endDate = request.getParameter("EndDate");
	    		String s = request.getParameter("gridData");
	    		String assetType = request.getParameter("AssetType");
	    		String jspName=request.getParameter("jspName");
	    		String custName = request.getParameter("custName");
	    		     try {
                    	 
                    	if (s !=null && !s.equals("")) {
                            String st = "[" + s + "]";                    
                            JSONArray firstGridData = null;
                           
						firstGridData = new JSONArray(st.toString());
						jsonArray = new JSONArray();
						jsonObject = new JSONObject();	
						ArrayList list1=WasteManagementFunction.getWasteManagementReport(firstGridData,startDate,endDate,offset,lang,systemId,Integer.parseInt(custId));
						jsonArray = (JSONArray) list1.get(0);
						if(jsonArray.length()>0)
						{
						jsonObject.put("WasterManagementRoot", jsonArray);
						}
						else
						{
						jsonObject.put("WasterManagementRoot", "");
						}
						if (startDate.contains("T")) {
							startDate = startDate.replaceAll("T", " ");
							startDate = startDate.substring(0,startDate.indexOf(" "));
							startDate = startDate +" 12:00:00";
						}else{
							startDate = startDate.substring(0,startDate.indexOf(" "));
							startDate = startDate +" 12:00:00";
						}
						if (endDate.contains("T")) {
							endDate = endDate.replaceAll("T", " ");
							endDate = endDate.substring(0,endDate.indexOf(" "));
							endDate = endDate +" 12:00:00";
						}else{
							endDate = endDate.substring(0,endDate.indexOf(" "));
							endDate = endDate +" 12:00:00";
						}
						ReportHelper reportHelper=(ReportHelper)list1.get(1);
			    		request.getSession().setAttribute(jspName,reportHelper);
			    		request.getSession().setAttribute("startdate",cf.getFormattedDateddMMYYYY(startDate));
			    		request.getSession().setAttribute("enddate",cf.getFormattedDateddMMYYYY(endDate));
			    		request.getSession().setAttribute("custId", custName);
						response.getWriter().print(jsonObject.toString());
                    	}else
						{
    						jsonObject.put("WasterManagementRoot", "");
    						response.getWriter().print(jsonObject.toString());
    					}
					} catch (Exception e) {
						e.printStackTrace();
					}
	    		
                
	    	}
	    	else if(param.equals("getSweepingOperationSummaryReport"))
	    	{
	    		String custId = request.getParameter("CustId");
	    		String startDate = request.getParameter("StartDate");
	    		String endDate = request.getParameter("EndDate");
	    		String s = request.getParameter("gridData");
	    		String assetType = request.getParameter("AssetType");
	    		String jspName=request.getParameter("jspName");
	    		String custName = request.getParameter("custName");
	    	      
                    try {
                    	if (s !=null && !s.equals("")) {
                            String st = "[" + s + "]";                    
                            JSONArray firstGridData = null;
						firstGridData = new JSONArray(st.toString());
						jsonArray = new JSONArray();
						jsonObject = new JSONObject();	
						ArrayList list1=WasteManagementFunction.getSweepingOperationSummaryReportDetails(firstGridData,startDate,endDate,offset,lang,systemId,Integer.parseInt(custId));
						jsonArray = (JSONArray) list1.get(0);
						if(jsonArray.length()>0)
						{
						jsonObject.put("SweepingManagementReportDetailsRoot", jsonArray);
						}
						else
						{
						jsonObject.put("SweepingManagementReportDetailsRoot", "");
						}
						ReportHelper reportHelper=(ReportHelper)list1.get(1);
			    		request.getSession().setAttribute(jspName,reportHelper);
			    		request.getSession().setAttribute("startdate",cf.getFormattedDateddMMYYYY(startDate.replaceAll("T", " ")));
			    		request.getSession().setAttribute("enddate",cf.getFormattedDateddMMYYYY(endDate.replaceAll("T", " ")));
			    		request.getSession().setAttribute("custId", custName);
			 			response.getWriter().print(jsonObject.toString());
        	    		}else
						{
    						jsonObject.put("SweepingManagementReportDetailsRoot", "");
    						response.getWriter().print(jsonObject.toString());
    						}
					} catch (Exception e) {
						e.printStackTrace();
					}
	    		
	    	}
	    	
		    else if (param.equalsIgnoreCase("modifywasteManagementInformation")) {
		        try {

		        	String uniqueId = request.getParameter("uniqueId");
		        	String totalWeightCarried = request.getParameter("totalWeightCarried");
		        	String remarks = request.getParameter("remarks");
		            String message="";
		            if (uniqueId != null && !uniqueId.equals("")) {
		                message = WasteManagementFunction.modifywasteManagementInformation(Integer.parseInt(uniqueId),totalWeightCarried,remarks,userId);
		            } 
		            response.getWriter().print(message);
		        } catch (Exception e) {
		            e.printStackTrace();
		        }
		    }

	    }
		return null;
	    }

}




