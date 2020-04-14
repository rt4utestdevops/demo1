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
import t4u.functions.SandMiningFunctions;

public class SandMiningSummaryAction extends Action{
	
	
	public ActionForward execute(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) throws Exception {
	    String param = "";
	    HttpSession session = request.getSession();
	    LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
	    SandMiningFunctions sandfunc = new SandMiningFunctions();
	    String lang = loginInfo.getLanguage();
	    JSONArray jsonArray = null;
	    JSONObject jsonObject = new JSONObject();
        int systemId=loginInfo.getSystemId();
        int clientId=loginInfo.getCustomerId();
	    if (request.getParameter("param") != null) {
	        param = request.getParameter("param").toString();
	    }

 //**************************************************SAND ROK Summary Report **********************************************************************************************************//	    
	    
	     if (param.equalsIgnoreCase("getSandMiningSummaryReport")) {
	    	  try {
		            String jspName = request.getParameter("jspName");
		            String sdate = request.getParameter("startdate");
		            String edate = request.getParameter("enddate");
		            
		            jsonArray = new JSONArray();
		                ArrayList < Object > list1 = sandfunc.getSandMiningSummaryReport(sdate,edate,lang);
		                jsonArray = (JSONArray) list1.get(0);
		                if (jsonArray.length() > 0) {
		                    jsonObject.put("GridRoot",jsonArray);
		                } else {
		                    jsonObject.put("GridRoot", "");
		                }
		                ReportHelper reportHelper = (ReportHelper) list1.get(1);
		             	request.getSession().setAttribute(jspName, reportHelper);
		             	request.getSession().setAttribute("sdate1", sdate.replaceAll("T", " "));
		             	request.getSession().setAttribute("edate1", edate.replaceAll("T", " "));
		             	response.getWriter().print(jsonObject.toString());
		            
		        } catch (Exception e) {
		            e.printStackTrace();
		        } 
	    } else if(param.equalsIgnoreCase("sendSMS"))
	    {
	    	String msg=sandfunc.sendSMS();
	    	response.getWriter().print(msg);
	    }
	    return null;
	}
	}