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
import t4u.functions.IronMiningFunction;

public class PlantMasterAction  extends Action{
	
	public ActionForward execute(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) throws Exception {
		String param = "";
		HttpSession session = request.getSession();
		LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
		IronMiningFunction ironMiningFunction = new IronMiningFunction();
		int systemId = loginInfo.getSystemId();
		String lang = loginInfo.getLanguage();
		int userId = loginInfo.getUserId();
		String zone=loginInfo.getZone();
		JSONArray jsonArray = null;
		JSONObject jsonObject = new JSONObject();

		if (request.getParameter("param") != null) {
			param = request.getParameter("param").toString();
		}
		if (param.equalsIgnoreCase("getPlantMasterDetails")) {
	        try {
	            String CustomerId = request.getParameter("CustId");
	            String jspName=request.getParameter("jspName");
				String customerName=request.getParameter("CustName");
	            jsonArray = new JSONArray();
	            jsonObject = new JSONObject();
	            if (CustomerId != null && !CustomerId.equals("")) {
	            	ArrayList < Object > list =ironMiningFunction.getPlantMasterDetails(systemId, Integer.parseInt(CustomerId), userId);
	                jsonArray = (JSONArray) list.get(0);
	                if (jsonArray.length() > 0) {
	                    jsonObject.put("MiningPlantMasterRoot", jsonArray);
	                } else {
	                    jsonObject.put("MiningPlantMasterRoot", "");
	                }
	                ReportHelper reportHelper = (ReportHelper) list.get(1);
					request.getSession().setAttribute(jspName, reportHelper);
	                request.getSession().setAttribute("custId", customerName);
	                response.getWriter().print(jsonObject.toString());
	            	
	            } 
	        } catch (Exception e) {
	            e.printStackTrace();
	        }
    	}	
			else if  (param.equalsIgnoreCase("getOrgname")) {
		    	 String clientId=request.getParameter("clientId");
		    	 try {
		    		 
						jsonArray = new JSONArray();
						jsonObject = new JSONObject();
							jsonArray = ironMiningFunction.getOrganizationCode(Integer.parseInt(clientId),systemId,userId);
							if (jsonArray.length() > 0) {
								jsonObject.put("OrgnameRoot", jsonArray);
							}else {
								jsonObject.put("OrgnameRoot", "");
							}
							response.getWriter().print(jsonObject.toString());
						} catch (Exception e) {
		            e.printStackTrace();
		        }
		 }
			else  if (param.equals("getTCNumber")) {
				try {
					jsonArray = new JSONArray();
					jsonObject = new JSONObject();
					String custId=request.getParameter("CustId");
					String orgId=request.getParameter("orgid");
					if (custId != null && !custId.equals("")) {
						jsonArray = ironMiningFunction.getTCNoForPlantMaster(systemId,Integer.parseInt(custId),Integer.parseInt(orgId));
						if (jsonArray.length() > 0) {
							jsonObject.put("tcNoRoot", jsonArray);
						} else {
							jsonObject.put("tcNoRoot", "");
						}
						response.getWriter().print(jsonObject.toString());
					}
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
			else if (param.equalsIgnoreCase("getHubLocation")) {
				try {
					String custId=request.getParameter("CustID");
					jsonArray = new JSONArray();
					jsonObject = new JSONObject();
						jsonArray =ironMiningFunction.getHubLocation(Integer.parseInt(custId),systemId);
						if (jsonArray.length() > 0) {
							jsonObject.put("sourceHubStoreRoot", jsonArray);
						} else {
							jsonObject.put("sourceHubStoreRoot", "");
						}
						response.getWriter().print(jsonObject.toString());
				} catch (Exception e) {
					e.printStackTrace();
				}
			  }
//-------------------------------------Insert/Modify Plant Master Information-----------------------------------------------------------//
		     else if (param.equalsIgnoreCase("plantMasterAddModify")) {
			     try {
			        	String CustId= request.getParameter("CustID");
			        	String buttonValue = request.getParameter("buttonValue");
			        	String id = request.getParameter("id");
			        	String orgId = request.getParameter("orgName");
			        	String plantName = request.getParameter("plantName");
			        	String hubLocId = request.getParameter("hubLocId");
			        	String mineralType = request.getParameter("mineralType");
			        	String tcNo = "";
			        	String orgNameModify = request.getParameter("orgNameModify");
			        	String tcNoModify = ""; 
			        	String message = "";
			        	if(request.getParameter("tcNo")!=""){
			        		tcNo = request.getParameter("tcNo");
			        	}
			        	if(request.getParameter("tcNoModify")!=""){
			        		tcNoModify = request.getParameter("tcNoModify");
			        	}
			            if (buttonValue.equals("Add") && CustId != null && !CustId.equals("")) {
			              message = ironMiningFunction.insertPlantMasterInformation(systemId,Integer.parseInt(CustId),orgId,plantName,tcNo,userId,Integer.parseInt(hubLocId),mineralType);
			            } 
			            else if (buttonValue.equals("Modify")&& CustId != null && !CustId.equals("")&& id != null && !id.equals("")) {
			              message = ironMiningFunction.updatePlantMasterInformation(systemId,Integer.parseInt(CustId),orgNameModify,plantName,tcNoModify,userId,Integer.parseInt(id),Integer.parseInt(hubLocId));
			            }
			            response.getWriter().print(message);
		         } catch (Exception e) {
		        	 System.out.println("error in PlantMaster Details "+e.toString());
		            e.printStackTrace();
		         }
			  } 
		return null;
	}

}
