package t4u.FCIS;

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
import t4u.functions.FCISFunctions;

/**
 * FuelConsolidatedReport class is use to generate the reports in FCIS module for Customer based on groups in particular date range
 */
public class FuelConsolidatedReportAction extends Action {
@SuppressWarnings("unchecked")
@Override
public ActionForward execute(ActionMapping mapping, ActionForm form,
		HttpServletRequest request, HttpServletResponse response)
		throws Exception {
	HttpSession session = request.getSession();
	JSONArray jsonArray = new JSONArray();
	JSONObject jsonObject = new JSONObject();
	
	LoginInfoBean loginInfo=(LoginInfoBean)session.getAttribute("loginInfoDetails");
	int systemId=loginInfo.getSystemId();
	String language=loginInfo.getLanguage();
	CommonFunctions cf=new CommonFunctions();
	FCISFunctions fcisfun=new FCISFunctions();
	String param = "";
	int offset = loginInfo.getOffsetMinutes();
	int userId=loginInfo.getUserId();
	if(request.getParameter("param")!=null)
	{
		param=request.getParameter("param").toString();
	}
	if(param.equals("getFuelConsolidatedReportDetails")){
		try {
			
		String customerId="0";
		if(request.getParameter("custId")!=null){
			customerId=request.getParameter("custId").toString();
		}
		String custName="";
		if(request.getParameter("custName")!=null){
			custName=request.getParameter("custName");
		}
		String groupId="0";
		if(request.getParameter("groupId")!=null){
			groupId=request.getParameter("groupId").toString();
		}
		String gname ="";
		if(request.getParameter("gname")!=null){
			gname=request.getParameter("gname");
		}
		String startDate="0";
		if(request.getParameter("startDate")!=null){
			startDate=request.getParameter("startDate").toString();
		}
		String endDate="0";
		if(request.getParameter("endDate")!=null){
			endDate=request.getParameter("endDate").toString();
		}
		String jspName="";
		if(request.getParameter("jspName")!=null){
			jspName=request.getParameter("jspName").toString();
		}
		
		ArrayList list1=fcisfun.getFuelConsolidatedReport(systemId, customerId, groupId, startDate, endDate, language, offset,userId);
		jsonArray = (JSONArray) list1.get(0);
		if(jsonArray.length()>0){
			jsonObject.put("fuelconsrepdata", jsonArray);
			}else{
				jsonObject.put("fuelconsrepdata", "");
			}
		ReportHelper reportHelper=(ReportHelper)list1.get(1);
		request.getSession().setAttribute(jspName,reportHelper);
		request.getSession().setAttribute("CustName",custName);
		request.getSession().setAttribute("gname",gname);
		request.getSession().setAttribute("startdate",cf.getFormattedDateddMMYYYY(startDate.replaceAll("T", " ")));
		request.getSession().setAttribute("enddate",cf.getFormattedDateddMMYYYY(endDate.replaceAll("T", " ")));
		response.getWriter().print(jsonObject.toString());
	} catch (Exception e) {
		e.printStackTrace();
		System.out.println("Error in FuelConsolidatedReportAction:-getFuelConsolidatedReportDetails "+e);
	}
	}
	
	
	
	
	
	
	return super.execute(mapping, form, request, response);
}
}
