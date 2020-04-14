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

public class VesselMasterAction extends Action {
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
		if (param.equalsIgnoreCase("getVesselMasterDetails")) {
	        try {
	        	ArrayList list=null;
	            String CustomerId = request.getParameter("CustId");
	    		
	            jsonArray = new JSONArray();
	            jsonObject = new JSONObject();
	            
	            if (CustomerId != null && !CustomerId.equals("")) {
	            	
	                list =ironfunc.getVesselMasterDetails(systemId, Integer.parseInt(CustomerId));
	                jsonArray = (JSONArray) list.get(0);
	                if (jsonArray.length() > 0) {
	                    jsonObject.put("VesselMasterRoot", jsonArray);
	                } else {
	                    jsonObject.put("VesselMasterRoot", "");
	                }	            	
	            } else {
	                jsonObject.put("VesselMasterRoot", "");
	            }
	            //System.out.println(jsonObject.toString());
	            response.getWriter().print(jsonObject.toString());
	        } catch (Exception e) {
	            e.printStackTrace();
	        }
    	}
		else if (param.equalsIgnoreCase("addOrModifyVesselMasterDetails")) {
			try {

				String buttonValue = request.getParameter("buttonValue");
				String custId=request.getParameter("custId");
				String vesselName=request.getParameter("vesselName");
				String status=request.getParameter("status");
				String id= request.getParameter("id");
				String buyerName=request.getParameter("buyerName");
				String message="";
				if(buttonValue.equals("Add") && custId != null && !custId.equals(""))
				{
                     message=ironfunc.addVesselMaster(vesselName,status,systemId,Integer.parseInt(custId),userId,buyerName);
				}else if(buttonValue.equals("Modify") && custId != null && !custId.equals(""))
				{
					//System.out.println("vesselName :"+vesselName+" ,Status: "+status+" ,SystemId: "+systemId+" ,CustId: "+Integer.parseInt(custId)+" ,UserId: "+userId+" ,UID: "+id);
					message=ironfunc.modifyVesselMaster(vesselName,status,systemId,Integer.parseInt(custId),userId,Integer.parseInt(id),buyerName);
				}
				
				response.getWriter().print(message);
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		return null;
	}
}
