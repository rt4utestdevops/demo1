package t4u.passengerbustransportation;

import java.text.ParseException;
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

import t4u.functions.CommonFunctions;
import t4u.functions.PassengerBusTransportationFunctions;

public class TicketSummaryReportAction extends Action{

public ActionForward execute(ActionMapping mapping, ActionForm form ,HttpServletRequest request , HttpServletResponse response )throws Exception{
	
String parameter = "";
HttpSession session = request.getSession();
PassengerBusTransportationFunctions ticketSummary = new PassengerBusTransportationFunctions();
LoginInfoBean logininfo =  (LoginInfoBean) session.getAttribute("loginInfoDetails");		
int systemId  = logininfo.getSystemId();
String lang = logininfo.getLanguage();
if(request.getParameter("parameter") != null){
	parameter = request.getParameter("parameter");
}
JSONArray jsonArray = new JSONArray();
JSONObject jsonObject = new JSONObject();
if(parameter.equalsIgnoreCase("getTicketSummaryReport")){
	try {
		SimpleDateFormat yyyymmdd = new SimpleDateFormat("yyyy-MM-dd");
		SimpleDateFormat ddmmyyyy = new SimpleDateFormat("dd-MM-yyyy");
		String CustId = request.getParameter("CustId");
		String custName = request.getParameter("custName");
		String startDate = request.getParameter("startDate");		
		String endDate = request.getParameter("endDate");		
		String jspName = request.getParameter("jspName");
		String type = request.getParameter("type");
		String startYear  ="";
		String endyear = "";
		if(type != null && !type.equals("")){
		if(Integer.parseInt(type)==3){
			startDate =startDate.replaceAll("T", " ");	
			endDate = endDate.replaceAll("T", " ");
			String startmonth = startDate.substring(0,startDate.indexOf("-"));			
			String endMonth = endDate.substring(0,endDate.indexOf("-"));			
			if(startDate.length()==6){
			startYear = startDate.substring(2);
			}else{
			 startYear = startDate.substring(3);	
			}
			if(endDate.length()==6){
				endyear = endDate.substring(2);
				}else{
					endyear = endDate.substring(3);	
				}			
			startDate = getfirstdateofmonth(startmonth,startYear);
			endDate = getlastdateofmonth(endMonth,endyear);					
		}else{
			startDate = getFormattedDate(startDate.replaceAll("T", " "));	
			endDate = getFormattedDate(endDate.replaceAll("T", " "));	
		}
	}
		jsonArray = new JSONArray();
		jsonObject = new JSONObject();
		if (CustId != null && !CustId.equals("")) {
			 ArrayList < Object > list1= ticketSummary.getTicketSummaryReport(systemId, Integer.parseInt(CustId),custName,startDate,endDate,jspName,Integer.parseInt(type),lang);
			 jsonArray = (JSONArray) list1.get(0);
			 if (jsonArray.length() > 0) {
				jsonObject.put("ticketSummaryReport", jsonArray);
			} else {
				jsonObject.put("ticketSummaryReport", "");
			}
			
		    ReportHelper reportHelper = (ReportHelper) list1.get(1);
			request.getSession().setAttribute(jspName, reportHelper);
            request.getSession().setAttribute("custId", custName);
            request.getSession().setAttribute("jspName", jspName);
            request.getSession().setAttribute("type", type);
    		request.getSession().setAttribute("startDate", ddmmyyyy.format(yyyymmdd.parse(startDate)));
	     	request.getSession().setAttribute("endDate", ddmmyyyy.format(yyyymmdd.parse(endDate)));
			response.getWriter().print(jsonObject.toString());
		} else {
			jsonObject.put("ticketSummaryReport", "");
			response.getWriter().print(jsonObject.toString());
		}
	} catch (Exception e) {
		e.printStackTrace();
	}
		
}

return null;
	}


private String getfirstdateofmonth(String month,String year){
String date = "";
int mon = Integer.parseInt(month)+1;
date = Integer.parseInt(year)+"-"+mon+"-"+"01";
return date;
}
private String getlastdateofmonth(String month,String year) throws ParseException{
	String date = "";
	int mon = Integer.parseInt(month)+1;
	date = mon+"/01/"+Integer.parseInt(year);
	SimpleDateFormat dateFormat = new SimpleDateFormat("MM/dd/yyyy");
	SimpleDateFormat dateFormat1 = new SimpleDateFormat("yyyy-MM-dd");
	Date convertedDate = dateFormat.parse(date);
	Calendar c = Calendar.getInstance();
	c.setTime(convertedDate);
	c.set(Calendar.DAY_OF_MONTH, c.getActualMaximum(Calendar.DAY_OF_MONTH));
	date = (dateFormat1.format(c.getTime())); 
	return date;
	
	}
private String getFormattedDate(String inputDate) {
	String formattedDate = "";
	SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
	try {
		if (inputDate != null && !inputDate.equals("")) {
			java.util.Date d = sdf.parse(inputDate);
			formattedDate = sdf.format(d);
		}
	} catch (Exception e) {
		e.printStackTrace();
	}
	return formattedDate;
}

}
