package t4u.admin;

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
import t4u.beans.ReportHelper;
import t4u.functions.CommonFunctions;
import t4u.functions.AdminFunctions;

public class VerticalSummaryAction extends Action{
	
	
	public ActionForward execute(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) throws Exception {
	    String param = "";
	    HttpSession session = request.getSession();
	    LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
	    AdminFunctions Verticalreport = new AdminFunctions();
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

 //**************************************************Vertical Summary Report **********************************************************************************************************//	    
	    
	     if (param.equalsIgnoreCase("getVerticalSummaryReport")) {
	        try {
	            String ReportName = request.getParameter("ReportName");
	            String type = request.getParameter("Type");
	            String jspName= request.getParameter("JspName");
	            jsonArray = new JSONArray();
	            if (type != null && !type.equals("")) {
	                ArrayList < Object > list1 = Verticalreport.getVerticalSummryReport( systemId, Integer.parseInt(type),lang);
	                jsonArray = (JSONArray) list1.get(0);
	                if (jsonArray.length() > 0) {
	                    jsonObject.put("verticalReport", jsonArray);
	                } else {
	                    jsonObject.put("verticalReport", "");
	                }
	                
	                ReportHelper reportHelper = (ReportHelper) list1.get(1);   ///// for pdf.........
		           request.getSession().setAttribute(jspName, reportHelper);
		           request.getSession().setAttribute("ReportName",  ReportName);
	                response.getWriter().print(jsonObject.toString());
	            } else {
	                jsonObject.put("verticalReport", "");
	                response.getWriter().print(jsonObject.toString());
	            }
	        } catch (Exception e) {
	            e.printStackTrace();
	        }
	    }
	    return null;
	}
	}