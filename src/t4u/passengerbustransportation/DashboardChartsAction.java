package t4u.passengerbustransportation;

import java.util.Properties;

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
import t4u.common.ApplicationListener;
import t4u.functions.PassengerBusTransportationFunctions;

public class DashboardChartsAction extends Action{
	
	public ActionForward execute(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		
		String param = "";
		JSONArray jsonArray = null;
		JSONObject jsonObject=null;
		HttpSession session = request.getSession();
		Properties properties = ApplicationListener.prop;
		LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
		int systemId=0;
		int customerID = 0;	
		int userID=0;
		if(loginInfo!=null)
		{
			systemId = loginInfo.getSystemId();
			customerID = loginInfo.getCustomerId();		
			userID=loginInfo.getUserId();
		}else{
			customerID=Integer.parseInt(properties.getProperty("customerID").trim());
			systemId=Integer.parseInt(properties.getProperty("systemID").trim());
		}
		if (request.getParameter("param") != null) {
			param = request.getParameter("param").toString();
		}
		PassengerBusTransportationFunctions ptf = new PassengerBusTransportationFunctions();
		
		if(param.equals("getDashboardCharts1")){
			try{
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				jsonArray=ptf.getDashboardCharts1(systemId,customerID);
				
				if (jsonArray.length() > 0) {
					jsonObject.put("DashBoardChartRoot1", jsonArray);
				} else {
					jsonObject.put("DashBoardChartRoot1", "");
				}
				
				response.getWriter().print(jsonObject.toString());	
			}catch (Exception e) {
				e.printStackTrace();
			}
		}
		if(param.equals("getDashboardCharts2")){
			try{
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				jsonArray=ptf.getDashboardCharts2(systemId,customerID);
				
				if (jsonArray.length() > 0) {
					jsonObject.put("DashBoardChartRoot2", jsonArray);
				} else {
					jsonObject.put("DashBoardChartRoot2", "");
				}
				
				response.getWriter().print(jsonObject.toString());	
			}catch (Exception e) {
				e.printStackTrace();
			}
		}	
		if(param.equals("getDashboardCharts3")){
			try{
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				jsonArray=ptf.getDashboardCharts3(systemId,customerID);
				
				if (jsonArray.length() > 0) {
					jsonObject.put("DashBoardChartRoot3", jsonArray);
				} else {
					jsonObject.put("DashBoardChartRoot3", "");
				}
				
				response.getWriter().print(jsonObject.toString());	
			}catch (Exception e) {
				e.printStackTrace();
			}
		}
		
		if(param.equals("getDashboardCharts4")){
			try{
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				jsonArray=ptf.getDashboardCharts4(systemId,customerID);
				
				if (jsonArray.length() > 0) {
					jsonObject.put("DashBoardChartRoot4", jsonArray);
				} else {
					jsonObject.put("DashBoardChartRoot4", "");
				}
				
				response.getWriter().print(jsonObject.toString());	
			}catch (Exception e) {
				e.printStackTrace();
			}
		}
		
	return null;
	}

}
