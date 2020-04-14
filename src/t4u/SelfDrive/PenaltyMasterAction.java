package t4u.SelfDrive;


import java.util.ArrayList;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.poi.ss.formula.functions.Offset;
import org.apache.struts.action.Action;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.json.JSONArray;
import org.json.JSONObject;

import t4u.beans.LoginInfoBean;
import t4u.functions.CommonFunctions;
import t4u.functions.SelfDriveFunctions;

public class PenaltyMasterAction extends Action {

	public ActionForward execute(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) throws Exception {
	    String param = "";
	    HttpSession session = request.getSession();
	    LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
	    SelfDriveFunctions sdf = new SelfDriveFunctions();
	    int offset=0;
	    int systemId = loginInfo.getSystemId();
	    String lang = loginInfo.getLanguage();
	    int userId = loginInfo.getUserId();
	    offset=loginInfo.getOffsetMinutes();
	    CommonFunctions cf = new CommonFunctions();
	    JSONArray jsonArray = null;
	    JSONObject jsonObject = new JSONObject();

	    if (request.getParameter("param") != null) {
	        param = request.getParameter("param").toString();
	    }
	    
	   
	      if (param.equalsIgnoreCase("penaltyMasterAddModify")) {
		        try {
		        	String CustId= request.getParameter("CustID");
		        	String buttonValue = request.getParameter("buttonValue");
		        	String penaltyType= request.getParameter("penaltyType");
		        	String penaltyDescription= request.getParameter("penaltyDescription");
		        	String penaltyCost= request.getParameter("penaltyCost");
		        	String id= request.getParameter("id");
					
		            String message = "";  
		            if (buttonValue.equals("Add") && CustId != null && !CustId.equals("")) {
		                message = sdf.insertPenaltyMasterInformation(penaltyType,penaltyDescription,Double.parseDouble(penaltyCost),systemId,Integer.parseInt(CustId),userId);
		                } 
		            else if (buttonValue.equals("Modify")&& CustId != null && !CustId.equals("")) {
		                message = sdf.modifyPenaltyMasterInformation(Integer.parseInt(id),penaltyType,penaltyDescription,Double.parseDouble(penaltyCost),systemId,Integer.parseInt(CustId),userId);
		                }
		            response.getWriter().print(message);
		        } catch (Exception e) {
		            e.printStackTrace();
		        }
		    } 
	      
	      else if (param.equalsIgnoreCase("getPenaltyMasterDetails")) {
		        try {
		            String CustId= request.getParameter("CustId");
		            jsonArray = new JSONArray();
		            if (CustId != null && !CustId.equals("")) {
		               ArrayList < Object > list1 = sdf.getPenaltyMasterDetails( systemId ,Integer.parseInt(CustId) );
		             jsonArray = (JSONArray) list1.get(0);
		                if (jsonArray.length() > 0) {
		                    jsonObject.put("getPenaltyMasterDetails", jsonArray); 
		                } else {
		                    jsonObject.put("getPenaltyMasterDetails", "");
		                }
		                response.getWriter().print(jsonObject.toString());  
		            }
		            else {
		                jsonObject.put("getPenaltyMasterDetails", "");
		                response.getWriter().print(jsonObject.toString());
		            }
		            
		        } catch (Exception e) {
		            e.printStackTrace();
		        }
		 }
	     return null;
	}
}
