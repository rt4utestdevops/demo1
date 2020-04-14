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
import t4u.functions.AdminFunctions;
import t4u.functions.CommonFunctions;
import t4u.functions.IronMiningFunction;

public class ProcessingFeeMaster extends Action{

	@SuppressWarnings("unchecked")
		public ActionForward execute(ActionMapping mapping, ActionForm form,HttpServletRequest request, HttpServletResponse response) throws Exception {
			HttpSession session = request.getSession();
			ReportHelper reportHelper = null;
			LoginInfoBean loginInfo =(LoginInfoBean)session.getAttribute("loginInfoDetails");
			int systemId  = loginInfo.getSystemId();
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

		if (param.equalsIgnoreCase("AddorModifyProcessingFeeDetails")) {
			try {

				String buttonValue = request.getParameter("buttonValue");
				String custId=request.getParameter("CustId");
				String permitType=request.getParameter("permitType");
				String processingFee=request.getParameter("processingFee");
				String id=request.getParameter("id");
				String mineralType=request.getParameter("mineralType");
				String message="";
				if(buttonValue.equals("Add") && custId != null && !custId.equals(""))
				{
                     message=ironfunc.addProcessingFeeDetails(permitType,Float.parseFloat(processingFee),systemId,Integer.parseInt(custId),userId,mineralType);
				}
				else if(buttonValue.equals("Modify") && custId != null && !custId.equals(""))
				{
                     message=ironfunc.ModifyProcessingFeeDetails(permitType,Float.parseFloat(processingFee),userId,Integer.parseInt(id));
				}
				response.getWriter().print(message);
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		else if (param.equalsIgnoreCase("getPermitType")) {
		       try {
		       	ArrayList list=null;
		           String CustomerId = request.getParameter("CustId");
		           jsonArray = new JSONArray();
		           jsonObject = new JSONObject();
		           if (CustomerId != null && !CustomerId.equals("")) {
		               list =ironfunc.getPermitTypeForProcessingFeeMaster(systemId, Integer.parseInt(CustomerId));
		               jsonArray = (JSONArray) list.get(0);
		               if (jsonArray.length() > 0) {
		                   jsonObject.put("permitTypeRoot", jsonArray);
		               } else {
		                   jsonObject.put("permitTypeRoot", "");
		               }
		               response.getWriter().print(jsonObject.toString());
		           	
		           } else {
		               jsonObject.put("permitTypeRoot", "");
		               response.getWriter().print(jsonObject.toString());
		           }
		       } catch (Exception e) {
		           e.printStackTrace();
		       }
		   	}
		else if (param.equalsIgnoreCase("getProcessingFeeMasterDetails")) {
	        try {
	        	ArrayList list=null;
	            String CustomerId = request.getParameter("CustId");
	            jsonArray = new JSONArray();
	            jsonObject = new JSONObject();
	            if (CustomerId != null && !CustomerId.equals("")) {
	            	
	                list =ironfunc.getProcessingFeeMasterDetails(systemId, Integer.parseInt(CustomerId));
	                jsonArray = (JSONArray) list.get(0);
	                if (jsonArray.length() > 0) {
	                    jsonObject.put("proFeeMasterRoot", jsonArray);
	                } else {
	                    jsonObject.put("proFeeMasterRoot", "");
	                }
	                response.getWriter().print(jsonObject.toString());
	            	
	            } else {
	                jsonObject.put("proFeeMasterRoot", "");
	                response.getWriter().print(jsonObject.toString());
	            }
	        } catch (Exception e) {
	            e.printStackTrace();
	        }
    	}
			return null;
		}
		
	}