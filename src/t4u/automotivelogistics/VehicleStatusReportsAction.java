package t4u.automotivelogistics;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;

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
import t4u.functions.AutomotiveLogisticsFunction;

public class VehicleStatusReportsAction extends Action{
	@SuppressWarnings("deprecation")
	public ActionForward execute(ActionMapping mapping,ActionForm form,HttpServletRequest request,HttpServletResponse response){
		SimpleDateFormat yyyyMMddHHmmss = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		 SimpleDateFormat ddMMyyyyHHmmss = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
		try {
			HttpSession session = request.getSession();
			String param = "";
			int systemId = 0;
			int customerId = 0;
			LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
			if (loginInfo != null) {
				systemId = loginInfo.getSystemId();
				customerId = loginInfo.getCustomerId();
				String language = loginInfo.getLanguage();
				int offset = loginInfo.getOffsetMinutes();
				AutomotiveLogisticsFunction alf=new AutomotiveLogisticsFunction();
				JSONArray jsonArray = null;
				JSONObject jsonObject = null;
				if (request.getParameter("param") != null) {
					param = request.getParameter("param").toString();
					
//*******************************************get Vehicle Availability And In Transit***************************************************************//				
				if (param.equalsIgnoreCase("getVehicleAvailabilityAndInTransit")) {
					String custId=request.getParameter("custId");
					String startDate=request.getParameter("startDate");
					String endDate=request.getParameter("endDate");
					String reportType=request.getParameter("reportType");
					String jspName=request.getParameter("jspName");
					String jspTitle="";//reportType.equals("Vehicle Availability")?"Vehicle Availability Report":"In Transit Vehicle Report";
					String custName=request.getParameter("custName");
					if(reportType.equals("Vehicle Availability")){
						jspTitle="Vehicle_Availability_Report";
						Calendar calender = Calendar.getInstance();
						Date eDate=new Date(calender.getTimeInMillis());
						calender.set(calender.get(Calendar.YEAR), calender.get(Calendar.MONTH)-1, calender.get(Calendar.DATE), 0, 0, 0);
						//Date sDate=new Date(calender.getTimeInMillis());
						startDate=yyyyMMddHHmmss.format(new Date(calender.getTimeInMillis()));
						endDate=yyyyMMddHHmmss.format(eDate);
					}else{
						jspTitle="In_Transit_Vehicles_Report";
					}
					
					
					jsonObject = new JSONObject();
					jsonArray = new JSONArray();
					try {
						if(custId!=null && reportType!=null){
							startDate=startDate.replace("T", " ");
							endDate=endDate.replace("T", " ");
							ArrayList < Object > list=alf.getVehicleAvailabilityAndInTransitDetails(systemId, customerId, startDate, endDate, reportType, offset, language);
							jsonArray = (JSONArray) list.get(0);
		                    if (jsonArray.length() > 0) {
								jsonObject.put("VehicleReportRoot", jsonArray);
								
								ReportHelper reportHelper = (ReportHelper) list.get(1);
								session.setAttribute(jspName, reportHelper);
								session.setAttribute("startDate", ddMMyyyyHHmmss.format(yyyyMMddHHmmss.parseObject(startDate)));
								session.setAttribute("endDate", ddMMyyyyHHmmss.format(yyyyMMddHHmmss.parseObject(endDate)));
								session.setAttribute("custName", custName);
								session.setAttribute("jspTitle", jspTitle);
							} else {
								jsonObject.put("VehicleReportRoot", "");
							}
						}else{
							jsonObject.put("VehicleReportRoot", "");
							}
						
						response.getWriter().print(jsonObject.toString());
					}
					catch (Exception e) {
						System.out.println("Error in Vehicle Availability/In Transit Report....");
						e.printStackTrace();
					}
				}
	
			  }//param
			}//loginInfo
		} catch (Exception e) {
			e.printStackTrace();
		}
			
			return null;
		}
	

}
