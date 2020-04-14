package t4u.passengerbustransportation;

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
import t4u.functions.PassengerBusTransportationFunctions;

public class ProfitAndLossReportAction  extends Action{
		public ActionForward execute(ActionMapping mapping, ActionForm form,
				HttpServletRequest request, HttpServletResponse response)
				throws Exception {			
			String param = "";			
			ReportHelper reportHelper = null;
			HttpSession session = request.getSession();			
			LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
			JSONArray jsonArray = null;
			JSONObject jsonObject=null;
			int systemId=0;				
			int userID=0;
			int offset=0;
			if(loginInfo!=null)
			{
				systemId = loginInfo.getSystemId();					
				userID=loginInfo.getUserId();
				offset=loginInfo.getOffsetMinutes();
			}
			
			PassengerBusTransportationFunctions ptf = new PassengerBusTransportationFunctions();
			
			if (request.getParameter("param") != null) {
				param = request.getParameter("param").toString();
			}
			if(param.equals("getTypeForGrid")){
				
				String clientid = request.getParameter("clientId");
				String globalType= request.getParameter("globalType");
				jsonObject = new JSONObject();
				jsonArray = new JSONArray();
				try{
				if(Integer.parseInt(globalType)==1){
					jsonArray=ptf.getRouteNameTicketDetails(systemId,Integer.parseInt(clientid));
				}else if(Integer.parseInt(globalType)==2){
					jsonArray = ptf.getVehicles(systemId, Integer.parseInt(clientid), userID);
				}else if(Integer.parseInt(globalType)==3){
					jsonArray=ptf.getTerminalNameTicketDetails(systemId,Integer.parseInt(clientid));
				}
				jsonObject.put("firstGridRoot", jsonArray);
				response.getWriter().print(jsonObject.toString());
				}catch(Exception e){
					e.printStackTrace();
				}
				
			}
			
			else if(param.equals("getTicketDetails")){
				boolean daily=Boolean.parseBoolean(request.getParameter("daily"));
				String clientid = request.getParameter("clientId");
				jsonObject = new JSONObject();
				jsonArray = new JSONArray();
				try{
					if (clientid != null && !clientid.equals("")) {
				if(daily)
				{
					String globalType= request.getParameter("typeName");
					String fromDate=request.getParameter("fromDate");
					fromDate = fromDate.replace('T', ' ');
					String jspName = request.getParameter("jspName");
					String custName = request.getParameter("custName");
					String name=request.getParameter("names");
					String endDate=request.getParameter("endDate");
					endDate=endDate.replace('T', ' ');
					ArrayList<Object> list=null;
					
						list =ptf.getProfitAndLossData(systemId,Integer.parseInt(clientid),globalType,fromDate,endDate,name,offset);
						jsonArray = (JSONArray) list.get(0);
						if (jsonArray.length() > 0) {
							jsonObject.put("ticketDetailsRoot", jsonArray);
						} else {
							jsonObject.put("ticketDetailsRoot", "");
						}
						reportHelper = (ReportHelper) list.get(1);
						request.getSession().setAttribute(jspName,reportHelper);
						request.getSession().setAttribute("custId", custName);
						response.getWriter().print(jsonObject.toString());
					} else if(!daily){						
						String globalType= request.getParameter("typeName");
						String fromMonth=request.getParameter("fromMonth");
						String toMonth=request.getParameter("toMonth");
			            String fromYear=request.getParameter("fromYear");	
			            String toYear=request.getParameter("toYear");	
			            String jspName = request.getParameter("jspName");
						String custName = request.getParameter("custName");
						String name=request.getParameter("names");
			            ArrayList<Object> list=null;
			            list =ptf.getMonthlyProfitAndLossData(systemId, Integer.parseInt(clientid), globalType, fromMonth, toMonth,fromYear,toYear, name, offset);
			            jsonArray = (JSONArray) list.get(0);
						if (jsonArray.length() > 0) {
							jsonObject.put("ticketDetailsRoot", jsonArray);
						} else {
							jsonObject.put("ticketDetailsRoot", "");
						}
			            reportHelper = (ReportHelper) list.get(1);
						request.getSession().setAttribute(jspName,reportHelper);
						request.getSession().setAttribute("custId", custName);
						response.getWriter().print(jsonObject.toString());
					}
				}else {
						jsonObject.put("ticketDetailsRoot", "");
						response.getWriter().print(jsonObject.toString());
					}
				}catch(Exception e){
					e.printStackTrace();
				}
			}
			return null;
		}

	}

	
	


