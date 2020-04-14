package t4u.ironMining;

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
import t4u.functions.IronMiningFunction;


public class TripSheetSummaryAction extends Action{
	public ActionForward execute(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) throws Exception {

	String param = "";
	HttpSession session = request.getSession();
	LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
	IronMiningFunction ironMiningFunction = new IronMiningFunction();
	int systemId = loginInfo.getSystemId();
	String lang = loginInfo.getLanguage();
	int userId = loginInfo.getUserId();
	String zone=loginInfo.getZone();
	JSONArray jsonArray = null;
	JSONObject jsonObject = new JSONObject();

	if (request.getParameter("param") != null) {
		param = request.getParameter("param").toString();
	}
			
				 
			  if (param.equalsIgnoreCase("getTripSheetSummaryReport")) {
					jsonObject = new JSONObject();
					jsonArray = new JSONArray();
					SimpleDateFormat ymd=new SimpleDateFormat("yyyy-MM-dd");
					SimpleDateFormat dmy = new SimpleDateFormat("dd/MM/yyyy");
					try {
						int customerId=Integer.parseInt(request.getParameter("CustId"));
						String custName=request.getParameter("custName");
						
						String jspName=request.getParameter("jspName");
						String startDate=request.getParameter("startdate");
						startDate=startDate.replaceAll("T00:00:00", "");
	                    String endDate=request.getParameter("enddate");
	                    endDate=endDate.replaceAll("T00:00:00", "");
	                    String mineralType=request.getParameter("mineralType");
	                    ArrayList < Object > list=ironMiningFunction.getTripSheetSummaryReport(systemId,customerId,userId,startDate,endDate,mineralType);
	                    jsonArray = (JSONArray) list.get(0);
	                    if (jsonArray.length() > 0) {
							jsonObject.put("TripSheetSummaryReportRoot", jsonArray);
						} else {
							jsonObject.put("TripSheetSummaryReportRoot", "");
						}
	                    if(!startDate.equals("") && !endDate.equals("")){
                    	 startDate =dmy.format(ymd.parse(startDate));
                    	 endDate =dmy.format(ymd.parse(endDate));
				    	}
                     ReportHelper reportHelper = (ReportHelper) list.get(1);
						request.getSession().setAttribute(jspName, reportHelper);
						request.getSession().setAttribute("custName", custName);
						request.getSession().setAttribute("startDate", startDate);
						request.getSession().setAttribute("endDate", endDate);
						request.getSession().setAttribute("mineralType", mineralType);
						response.getWriter().print(jsonObject.toString());
                     
					}
					catch (Exception e) {
						e.printStackTrace();
					}
					
				}
			 return null;
		}
	}


