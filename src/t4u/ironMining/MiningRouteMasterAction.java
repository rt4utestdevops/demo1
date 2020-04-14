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
import org.json.JSONException;
import org.json.JSONObject;

import t4u.beans.LoginInfoBean;
import t4u.beans.ReportHelper;
import t4u.functions.IronMiningFunction;

public class MiningRouteMasterAction  extends Action{
	
	public ActionForward execute(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) throws Exception {
		String param = "";
		HttpSession session = request.getSession();
		LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
		IronMiningFunction ironMiningFunction = new IronMiningFunction();
		int systemId = loginInfo.getSystemId();
		String lang = loginInfo.getLanguage();
		int userId = loginInfo.getUserId();
		JSONArray jsonArray = null;
		JSONObject jsonObject = new JSONObject();

		if (request.getParameter("param") != null) {
			param = request.getParameter("param").toString();
		}
		if (param.equalsIgnoreCase("getRouteMasterDetails")) {
	        try {
	            String CustomerId = request.getParameter("CustId");
	            String jspName=request.getParameter("jspName");
				String customerName=request.getParameter("CustName");
	            jsonArray = new JSONArray();
	            jsonObject = new JSONObject();
	            if (CustomerId != null && !CustomerId.equals("")) {
	            	ArrayList < Object > list =ironMiningFunction.getRouteMasterDetails(systemId, Integer.parseInt(CustomerId), userId);
	                jsonArray = (JSONArray) list.get(0);
	                if (jsonArray.length() > 0) {
	                    jsonObject.put("MiningRouteMasterRoot", jsonArray);
	                } else {
	                    jsonObject.put("MiningRouteMasterRoot", "");
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
							jsonArray = ironMiningFunction.getOrganizationName(Integer.parseInt(clientId),systemId,userId);
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
		
			else if (param.equalsIgnoreCase("getMotherRoute")) {
				try {
					String custId=request.getParameter("custId");
					String buttonValue=request.getParameter("buttonValue");
					String routeId=request.getParameter("routeId");
					jsonArray = new JSONArray();
					jsonObject = new JSONObject();
						jsonArray =ironMiningFunction.getMotherRoute(Integer.parseInt(custId),systemId,buttonValue,routeId);
						if (jsonArray.length() > 0) {
							jsonObject.put("motherRnameRoot", jsonArray);
						} else {
							jsonObject.put("motherRnameRoot", "");
						}
						response.getWriter().print(jsonObject.toString());
				} catch (Exception e) {
					e.printStackTrace();
				}
			  }
		
			else if (param.equalsIgnoreCase("getTripLimitDetails")) {
				try {
					String id=request.getParameter("id");
					jsonArray = new JSONArray();
					jsonObject = new JSONObject();
					if(id != null && !id.equals("")){
						jsonArray =ironMiningFunction.getTripLimitDetails(Integer.parseInt(id));
					}
					if (jsonArray.length() > 0) {
						jsonObject.put("timeLimitRoot", jsonArray);
					} else {
						jsonObject.put("timeLimitRoot", "");
					}
					response.getWriter().print(jsonObject.toString());
				} catch (Exception e) {
					e.printStackTrace();
				}
			  }
			//**************addOrModify*****************
			else if (param.equalsIgnoreCase("routeMasterAddModify")) {
			     try {
			        	String CustId= request.getParameter("CustID");
			        	String buttonValue = request.getParameter("buttonValue");
			        	String id = request.getParameter("id");
			        	String orgId = request.getParameter("orgName");
			        	String routeName = request.getParameter("routeName");
			        	String sourceHubLocId = request.getParameter("sourceHubLocId");			     
			        	String destinationHubLocId = request.getParameter("destinationHubLocId");
			        	String json = request.getParameter("json");
			        	String removedData = request.getParameter("removedData");
			        	String distance="0";
			        	String totalTripLimit  = request.getParameter("totalTripLimit");
			        	if(request.getParameter("distance") != null && !request.getParameter("distance").equals("")){
			        		distance=request.getParameter("distance");
			        	}
			        	String sHubModify = request.getParameter("sHubModify");			     
			        	String dHubModify = request.getParameter("dHubModify");
			        	String srcType = request.getParameter("sourceType");
			        	
			        	String message = "";
			        	JSONArray js = null;
			        	JSONArray jsRemoved = null;
			        	if(removedData!=null)
						{
							String st1 = "["+removedData+"]";
							try
							{
								jsRemoved = new JSONArray(st1.toString());
							}
							catch (JSONException e)
						    {
								e.printStackTrace();
							}
						}
			        	if(json!=null)
						{
							String st = "["+json+"]";
							try
							{
								js = new JSONArray(st.toString());
							}
							catch (JSONException e)
						    {
								e.printStackTrace();
							}
						}
			            if (buttonValue.equals("Add") && CustId != null && !CustId.equals("")) {
			            	int motherRId = request.getParameter("motherRId")!=null && !request.getParameter("motherRId").equals("")?
									Integer.parseInt(request.getParameter("motherRId")):0;
			              message = ironMiningFunction.insertRouteMasterInformation(systemId,Integer.parseInt(CustId),Integer.parseInt(orgId),routeName,userId,Integer.parseInt(sourceHubLocId),Integer.parseInt(destinationHubLocId),distance,js,motherRId,totalTripLimit,srcType);
			            } 
			            else if (buttonValue.equals("Modify")&& CustId != null && !CustId.equals("")&& id != null && !id.equals("")) {
			              message = ironMiningFunction.updateRouteMasterInformation(userId,Integer.parseInt(id),distance,Integer.parseInt(sHubModify),Integer.parseInt(dHubModify),js,jsRemoved,totalTripLimit,srcType);
			            }
			            response.getWriter().print(message);
		         } catch (Exception e) {
		        	 System.out.println("error in PlantMaster Details "+e.toString());
		            e.printStackTrace();
		         }
			  }
		
			else if (param.equalsIgnoreCase("activeInactiveRoutes")) {
				String customerId = request.getParameter("CustID");
				String id = request.getParameter("id");
				String remarks= request.getParameter("remark");
				String status= request.getParameter("status");
				
				String message1="";
				if (customerId != null && !customerId.equals("") && id != null && !id.equals("")) {
					try {
						message1 = ironMiningFunction.activeInactiveRoutes(Integer.parseInt(customerId), systemId,userId,Integer.parseInt(id),remarks,status);
						response.getWriter().print(message1);
					} catch (Exception e) {
						e.printStackTrace();
					}
				}
			}
		return null;
	}

}