package t4u.admin;

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
import t4u.functions.UnitMessageUnionFunctions;

public class UnitMessageUnionAction  extends Action {
	
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
        UnitMessageUnionFunctions umf = new UnitMessageUnionFunctions();
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
				vehicleJsonArr = umf.getAssetNumberList(systemId, cid ,userId);
				
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
	            String msgType = request.getParameter("msgType");
	            String comport = request.getParameter("comport");
	            String purpose = request.getParameter("purpose");
	            String buttonValue = request.getParameter("buttonValue"); 
	            String message="";
	            if (custId != null && !custId.equals("")) {
	            	if(buttonValue.equalsIgnoreCase("Add")){
	            		message = umf.insertUnionData(Integer.parseInt(custId),systemId,userId,registrationNo,msgType,comport,purpose);
	            	}else if(buttonValue.equalsIgnoreCase("Modify")){
	            		String uniqueIdParam = request.getParameter("uniqueIdParam");
	            		 String msgTypeGrid = request.getParameter("msgTypeGrid");
	     	            String purposeGrid = request.getParameter("purposeGrid");
	     	            String comportGrid =  request.getParameter("comportGrid");
	     	            if(!comportGrid.equalsIgnoreCase(comport)||!msgTypeGrid.equalsIgnoreCase(msgType)||!purposeGrid.equalsIgnoreCase(purpose)){
	            		message = umf.modifyUnionData(Integer.parseInt(custId),systemId,userId,registrationNo,msgType,comport,purpose,Integer.parseInt(uniqueIdParam));
	     	            }else{
	     	            	message="<p>There are no changes to save ..</p>";
	     	            }
	            	}
	            } 
	            response.getWriter().print(message);
	        } catch (Exception e) {
	            e.printStackTrace();
	        }
	    }
	    
	    
	    else if (param.equalsIgnoreCase("getMsgAssocReport")) {
	        try {
	            String customerId = request.getParameter("CustId");
	            String vehicleNumber = request.getParameter("vehicleNumber");
				String jspName=request.getParameter("jspName");
				String pageName=request.getParameter("pageName");
	            jsonArray = new JSONArray();
	            if (customerId != null && !customerId.equals("")) {
	            	ArrayList<Object> klrRequestList = umf.getMsgAssocReport(Integer.parseInt(customerId),systemId,offset,vehicleNumber,pageName,userId);
	            	jsonArray = (JSONArray) klrRequestList.get(0);
	            	if (jsonArray.length() > 0) {
	                    jsonObject.put("MsgAssocRoot", jsonArray);
	                } else {
	                    jsonObject.put("MsgAssocRoot", "");
	                }
	                ReportHelper reportHelper = (ReportHelper) klrRequestList.get(1);
	                request.getSession().setAttribute(jspName, reportHelper);
					response.getWriter().print(jsonObject.toString());
	            } else {
	                jsonObject.put("MsgAssocRoot", "");
	                response.getWriter().print(jsonObject.toString());
	            }
	        } catch (Exception e) {
	            e.printStackTrace();
	        }
	    } 
	    else if (param.equalsIgnoreCase("getTypeSetting")) {
			jsonObject = new JSONObject();
			jsonArray = new JSONArray();
			String type = request.getParameter("type");
			String rType = request.getParameter("rType");
			try {
				jsonArray = umf.getTypeList(type,rType);
				if (jsonArray.length() > 0) {
					jsonObject.put("typeRoot", jsonArray);
				} else {
					jsonObject.put("typeRoot", "");
				}
				response.getWriter().print(jsonObject);
			} catch (Exception e) {

			}
		}else if (param.equalsIgnoreCase("deleteUnionDetails")){
			String custId = request.getParameter("CustId");
			String registrationNo = request.getParameter("registrationNo");
            String msgType = request.getParameter("msgType");
            String comport = request.getParameter("comport");
            String purpose = request.getParameter("purpose");
			String uniqueId=request.getParameter("uniqueId");
			String message="Delete Failed";
			try {
				message=umf.deleteUnionDetails(Integer.parseInt(custId),systemId,userId,registrationNo,msgType,comport,purpose,Integer.parseInt(uniqueId));
				response.getWriter().print(message);
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
	    	  	    
	    
        return null;
 }
 }
