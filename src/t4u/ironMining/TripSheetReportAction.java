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

public class TripSheetReportAction extends Action {
	@SuppressWarnings("unchecked")
	public ActionForward execute(ActionMapping mapping, ActionForm form,HttpServletRequest request, HttpServletResponse response) throws Exception {
		HttpSession session = request.getSession();
		ReportHelper reportHelper = null;
		LoginInfoBean loginInfo =(LoginInfoBean)session.getAttribute("loginInfoDetails");
		int systemId  = loginInfo.getSystemId();
		int customerId = loginInfo.getCustomerId();
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
		
	    if (param.equals("getGroups")) {
            try {
            	int clientId = 0;
                String customerid = request.getParameter("CustId");
            	 jsonArray = new JSONArray();
 	            jsonObject = new JSONObject();
            if (customerid != null && !customerid.equals("")) {
            	 clientId = Integer.parseInt(customerid);
            	  jsonArray = ironfunc.getGroupNameList(systemId, clientId, userId);
                if (jsonArray != null) {
                    jsonObject.put("groupNameList", jsonArray);
                } else {
                    jsonObject.put("groupNameList", "");
                }
                response.getWriter().print(jsonObject.toString());
            }else {
            	jsonObject.put("groupNameList", "");
			}
            } catch (Exception e) {
                e.printStackTrace();
            }
        } 
	    
	    else if (param.equalsIgnoreCase("getAssetNumber")) {
	        try {
	            String CustomerId = request.getParameter("CustId");
	            String GroupId = request.getParameter("groupId");
	            
	            jsonArray = new JSONArray();
	            jsonObject = new JSONObject();
	            
	            if (CustomerId != null && !CustomerId.equals("")) {

	                jsonArray =ironfunc.getAssetNumberDetails(systemId, Integer.parseInt(CustomerId), userId, GroupId);

	                if (jsonArray.length() > 0) {
	                    jsonObject.put("managerAssetRoot", jsonArray);
	                } else {
	                    jsonObject.put("managerAssetRoot", "");
	                }
	                response.getWriter().print(jsonObject.toString());
	            } else {
	                jsonObject.put("managerAssetRoot", "");
	                response.getWriter().print(jsonObject.toString());
	            }
	        } catch (Exception e) {
	            e.printStackTrace();
	        }
    	}
		
	    else if (param.equalsIgnoreCase("getAssetType")) {
	        try {
	            String Customerid = request.getParameter("CustId");
	            String groupId=request.getParameter("groupId");
	            jsonArray = new JSONArray();
	            jsonObject = new JSONObject();
	            if (Customerid != null && !Customerid.equals("")) {

	                jsonArray = ironfunc.getAssetTypeDetails(systemId, Integer.parseInt(Customerid), userId,groupId);

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
		}
		
		else if (param.equalsIgnoreCase("getTripSheetDetails")) {
	        try {
	        	ArrayList list=null;
	            String CustomerId = request.getParameter("CustId");
	            String assettype = request.getParameter("AssetType");
	            String s = request.getParameter("gridData");
	            String startDate = request.getParameter("StartDate");
	    		String endDate = request.getParameter("EndDate");
	    		String jspName=request.getParameter("jspName");
	    		String custName = request.getParameter("custName");
	    		String vehicleValue=request.getParameter("vehicleValue");
	    		String groupId=request.getParameter("groupId");
	    		String groupName=request.getParameter("groupName");
	    		
	    		//System.out.println("CustomerId:"+CustomerId+"AssetType :"+assettype +"VehicleNo"+s +"startDate:"+startDate +"endDate:"+endDate +"jspName:"+jspName +"custName:"+custName+"vehicleValue:"+vehicleValue+"groupId"+groupId);
	    		
	            jsonArray = new JSONArray();
	            jsonObject = new JSONObject();
	            
	            if (CustomerId != null && !CustomerId.equals("")) {
	            	//if (s !=null && !s.equals("")) {
	            	 String st = "[" + s + "]";                    
	                    JSONArray firstGridData = null;
	                   
					firstGridData = new JSONArray(st.toString());
					
	                list =ironfunc.getTripSheetReportDetails(firstGridData,systemId, Integer.parseInt(CustomerId), userId, assettype,startDate,endDate,vehicleValue,lang,groupId);
	                jsonArray = (JSONArray) list.get(0);
	                if (jsonArray.length() > 0) {
	                    jsonObject.put("TripSheetReportDetailsRoot", jsonArray);
	                } else {
	                    jsonObject.put("TripSheetReportDetailsRoot", "");
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
	                jsonObject.put("TripSheetReportDetailsRoot", "");
	                response.getWriter().print(jsonObject.toString());
	            }
	        } catch (Exception e) {
	            e.printStackTrace();
	        }
    	}
		return null;
	}
}