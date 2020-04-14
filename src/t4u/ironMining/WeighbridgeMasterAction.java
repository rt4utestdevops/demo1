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

public class WeighbridgeMasterAction extends Action {
	@SuppressWarnings("unchecked")
	public ActionForward execute(ActionMapping mapping, ActionForm form,HttpServletRequest request, HttpServletResponse response) throws Exception {
		HttpSession session = request.getSession();
		LoginInfoBean loginInfo =(LoginInfoBean)session.getAttribute("loginInfoDetails");
		int systemId  = loginInfo.getSystemId();
		//int customerId = loginInfo.getCustomerId();
		int userId = loginInfo.getUserId();
		//int offset = loginInfo.getOffsetMinutes();
		//String lang = loginInfo.getLanguage();
		CommonFunctions cf=new CommonFunctions();
		IronMiningFunction ironfunc = new IronMiningFunction();
		JSONArray jsonArray = null;
		JSONObject jsonObject=null;
		String param = "";
		if (request.getParameter("param") != null) {
			param = request.getParameter("param").toString();
		}
		if (param.equalsIgnoreCase("getHubLocation")) {
			try {
				String custId=request.getParameter("CustID");
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
					jsonArray =ironfunc.getHubLocation(Integer.parseInt(custId),systemId);
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
		else if (param.equalsIgnoreCase("getWeighbrideMasterDetails")) {
	        try {
	        	ArrayList list=null;
	            String CustomerId = request.getParameter("CustId");
	    		System.out.println("CustomerId:"+CustomerId);
	    		
	            jsonArray = new JSONArray();
	            jsonObject = new JSONObject();
	            
	            if (CustomerId != null && !CustomerId.equals("")) {
	            	
	                list =ironfunc.getWeighbridgeMasterDetails(systemId, Integer.parseInt(CustomerId), userId);
	                jsonArray = (JSONArray) list.get(0);
	                if (jsonArray.length() > 0) {
	                    jsonObject.put("weighbridgeMasterRoot", jsonArray);
	                } else {
	                    jsonObject.put("weighbridgeMasterRoot", "");
	                }
	                response.getWriter().print(jsonObject.toString());
	            	
	            } else {
	                jsonObject.put("weighbridgeMasterRoot", "");
	                response.getWriter().print(jsonObject.toString());
	            }
	        } catch (Exception e) {
	            e.printStackTrace();
	        }
    	}
		else if (param.equalsIgnoreCase("getOrganisationCode")) {
			try {
				String CustomerId = request.getParameter("CustID");
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				if (CustomerId != null && !CustomerId.equals("")) {
					jsonArray =ironfunc.getOrganisationCode(Integer.parseInt(CustomerId), systemId,userId);
					if (jsonArray.length() > 0) {
						jsonObject.put("orgRoot", jsonArray);
					} else {
						jsonObject.put("orgRoot", "");
					}
					response.getWriter().print(jsonObject.toString());
				} 
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		else if (param.equalsIgnoreCase("AddorModifyWeighbridgeDetails")) {
			try {

				String buttonValue = request.getParameter("buttonValue");
				String custId=request.getParameter("custId");
				String orgId="0";
				String hubLocation=request.getParameter("hubLocation");
				String weighbridge=request.getParameter("weighbridge");
				String companyName=request.getParameter("companyName");
				String weighbridgeModel=request.getParameter("weighbridgeModel");
				String supplierName=request.getParameter("supplierName");
				String id= request.getParameter("id");
				String OrgIdmodify ="0";
				String message="";
				if(request.getParameter("orgId")!=null && !request.getParameter("orgId").equals("")){
					orgId=request.getParameter("orgId");
				}
				if(request.getParameter("OrgIdmodify")!=null && !request.getParameter("OrgIdmodify").equals("")){
					OrgIdmodify=request.getParameter("OrgIdmodify");
				}
				if(buttonValue.equals("Add") && custId != null && !custId.equals(""))
				{
                     message=ironfunc.addWeighbrideMasterdetails(Integer.parseInt(orgId),Integer.parseInt(hubLocation),weighbridge,companyName,weighbridgeModel,supplierName,systemId,Integer.parseInt(custId),userId);
				}else if(buttonValue.equals("Modify") && custId != null && !custId.equals(""))
				{
					message=ironfunc.modifyWeighbrideMasterdetails(Integer.parseInt(OrgIdmodify),Integer.parseInt(hubLocation),companyName,weighbridgeModel,supplierName,systemId,Integer.parseInt(custId),userId,Integer.parseInt(id));
				}
				
				response.getWriter().print(message);
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		return null;
	}
}
