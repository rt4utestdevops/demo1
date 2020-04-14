package t4u.sandmining;

import java.text.SimpleDateFormat;
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
import t4u.functions.SandMiningFunctions;

public class SandBoatAssociationAction extends Action{
	
	public ActionForward execute(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) throws Exception {
		String param = "";
		HttpSession session = request.getSession();
		LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
		SandMiningFunctions sandMiningFunction = new SandMiningFunctions();
		int systemId = loginInfo.getSystemId();
		String lang = loginInfo.getLanguage();
		int userId = loginInfo.getUserId();
		int custID = loginInfo.getCustomerId();
		String zone=loginInfo.getZone();
		JSONArray jsonArray = null;
		JSONObject jsonObject = new JSONObject();

		if (request.getParameter("param") != null) {
			param = request.getParameter("param").toString();
		}
	    if (param.equalsIgnoreCase("saveAndModifySandBoatDetails")) {
		     try {
		        	String custId= request.getParameter("custId");
		        	String buttonValue = request.getParameter("buttonValue");
		        	String id = request.getParameter("id");
		        	String regNo = request.getParameter("regNo");
		        	String sandBlock = request.getParameter("sandBlock");
		        	String detentionMin = request.getParameter("detentionMin");
		        	String sandBlockMod="0";
		        	String message = "";
		        	if(request.getParameter("sandBlockMod") != null && request.getParameter("sandBlockMod")!=""){
		        		sandBlockMod = request.getParameter("sandBlockMod");
		        	}
		            if (buttonValue.equals("Add") && custId != null && !custId.equals("")) {
		              message = sandMiningFunction.insertSandBoatInfo(systemId,Integer.parseInt(custId),regNo,sandBlock,detentionMin,userId);
		            } 
		            else if (buttonValue.equals("Modify")&& custId != null && !custId.equals("")&& id != null && !id.equals("")) {
		              message = sandMiningFunction.updateSandBoatInformation(systemId,Integer.parseInt(custId),sandBlockMod,detentionMin,userId,Integer.parseInt(id));
		            }
		            response.getWriter().print(message);
	         } catch (Exception e) {
	        	 System.out.println("error in sand boat Details "+e.toString());
	            e.printStackTrace();
	         }
		  } 
	    else if (param.equalsIgnoreCase("getSandBlock")) {
			try {
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
					jsonArray =sandMiningFunction.getSandBlock(custID,systemId);
					if (jsonArray.length() > 0) {
						jsonObject.put("sandBlockRoot", jsonArray);
					} else {
						jsonObject.put("sandBlockRoot", "");
					}
					response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		  }
	    else if (param.equalsIgnoreCase("getRegNo")) {
			try {
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
					jsonArray =sandMiningFunction.getRegistrationNo(custID,systemId);
					if (jsonArray.length() > 0) {
						jsonObject.put("regNoRoot", jsonArray);
					} else {
						jsonObject.put("regNoRoot", "");
					}
					response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		  }
	    else if (param.equalsIgnoreCase("getSandBoatDetails")) {
	        try {
	            String jspName=request.getParameter("jspName");
				String customerName=request.getParameter("custName");
	            jsonArray = new JSONArray();
	            jsonObject = new JSONObject();
            	ArrayList < Object > list =sandMiningFunction.getSandBoatDetails(systemId, custID);
                jsonArray = (JSONArray) list.get(0);
                if (jsonArray.length() > 0) {
                    jsonObject.put("sandBoatDetailsRoot", jsonArray);
                } else {
                    jsonObject.put("sandBoatDetailsRoot", "");
                }
                ReportHelper reportHelper = (ReportHelper) list.get(1);
				request.getSession().setAttribute(jspName, reportHelper);
                request.getSession().setAttribute("custId", customerName);
                response.getWriter().print(jsonObject.toString());
	            	
	        } catch (Exception e) {
	            e.printStackTrace();
	        }
    	}
	    if(param.equals("getUnAuthEntryOrRedZoneDetails"))
		{
	    	String jspName=request.getParameter("jspName");
	    	int customerId = Integer.parseInt(request.getParameter("CustId"));
	    	SimpleDateFormat sdfyyyymmddhhmmss = new SimpleDateFormat(
			"dd-MM-yyyy HH:mm:ss");
			SimpleDateFormat sdfyyyymmddhhmmss1 = new SimpleDateFormat(
			"yyyy-MM-dd HH:mm:ss");
	    	
	    	String custoName = request.getParameter("custName");
	    	String report=request.getParameter("report");
	    	String startdate=request.getParameter("startdate");
	    	String enddate=request.getParameter("enddate");
	    	if(startdate.contains("T")){
	    		startdate=startdate.replace("T", " ");
	    	}
	    	if(enddate.contains("T")){
	    		enddate=enddate.replace("T", " ");	
	    	}
			try {
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				ArrayList <Object> list = sandMiningFunction.getUnAuthEntryOrRedZoneDetails(systemId,customerId,report,startdate,enddate);
				jsonArray = (JSONArray) list.get(0);
				if(jsonArray.length() > 0)
				{
                    jsonObject.put("unAuthEntryOrRedZoneRoot", jsonArray);
                } else {
                    jsonObject.put("unAuthEntryOrRedZoneRoot", "");
                }
				ReportHelper reportHelper = (ReportHelper) list.get(1);
				request.getSession().setAttribute(jspName, reportHelper);
				request.getSession().setAttribute("cName", custoName);
				
				if(!startdate.equals(""))
				{
					request.getSession().setAttribute("startDate", sdfyyyymmddhhmmss.format(sdfyyyymmddhhmmss1.parse(startdate)));
				}
				if(!enddate.equals(""))
				{
					request.getSession().setAttribute("endDate", sdfyyyymmddhhmmss.format(sdfyyyymmddhhmmss1.parse(enddate)));
				}
                response.getWriter().print(jsonObject.toString());
			}
			catch(Exception e){
				e.printStackTrace();
			}	
		}
		return null;
	}
}
