package t4u.wastemanagement;

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
import t4u.functions.WastemanagementFunctions;

/**
 * 
 * To get daily attendance report of Traders(Licence Holder)
 *
 */
public class DailyAttendanceReportAction extends Action{
	@SuppressWarnings("unchecked")
	public ActionForward execute(ActionMapping mapping, ActionForm form,HttpServletRequest request, HttpServletResponse response){
		HttpSession session = request.getSession();
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonObject = new JSONObject();
		WastemanagementFunctions wfuncs=new WastemanagementFunctions();
		LoginInfoBean loginInfo=(LoginInfoBean)session.getAttribute("loginInfoDetails");
		int systemId=loginInfo.getSystemId();
		String language=loginInfo.getLanguage();
		int userId=loginInfo.getUserId();
		CommonFunctions cf=new CommonFunctions();
		String param = "";
		if(request.getParameter("param")!=null)
		{
			param=request.getParameter("param").toString();
		}
		/**
		 * To get Trader(Licence Holder)'s daily attendance report from database
		 */
		if(param.equals("getDailyAttendanceReportDetails")){

			try{
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				
				String customerId="0";
				if(request.getParameter("custId")!=null){
					customerId=request.getParameter("custId").toString();
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
				ArrayList list1=wfuncs.getDailyAttendanceReport(systemId, customerId,startDate,endDate,language,userId);
				jsonArray = (JSONArray) list1.get(0);
				if(jsonArray.length()>0){
					jsonObject.put("dardata", jsonArray);
					}else{
						jsonObject.put("dardata", "");
					}
				ReportHelper reportHelper=(ReportHelper)list1.get(1);
	    		request.getSession().setAttribute(jspName,reportHelper);
	    		request.getSession().setAttribute("startdate",cf.getFormattedDateddMMYYYY(startDate.replaceAll("T", " ")));
	    		request.getSession().setAttribute("enddate",cf.getFormattedDateddMMYYYY(endDate.replaceAll("T", " ")));
				response.getWriter().print(jsonObject.toString());
				}catch(Exception e){
					System.out.println("Error in DailyAttendanceReportAction:-getDailyAttendanceReport "+e.toString());
				}			
		}
		return null;
	}
}
