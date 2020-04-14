package t4u.CarRental;
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
import t4u.functions.CarRentalFunctions;

public class PowerConnectionReportAction extends Action{
	public ActionForward execute(ActionMapping mapping, ActionForm form,HttpServletRequest request, HttpServletResponse response){
		try
		{
			HttpSession session = request.getSession();
			LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
			int systemId = loginInfo.getSystemId();
			int userId = loginInfo.getUserId();
			int offset = loginInfo.getOffsetMinutes();
			String language = loginInfo.getLanguage();
			String param = "";
			if (request.getParameter("param") != null) {
				param = request.getParameter("param").toString();
			}
			CarRentalFunctions cfunc = new CarRentalFunctions();
			SimpleDateFormat sdf = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
			SimpleDateFormat sdfDB = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			if(param.equalsIgnoreCase("getPowerConnectionReport")){
				String clientId = request.getParameter("ClientId");
				String startDate = request.getParameter("startDate");
				String endDate = request.getParameter("endDate");
				String customerName = request.getParameter("custName");
				String jspName = request.getParameter("jspName");
				JSONObject jsonObject = null;			
				JSONArray jsonArray = null;
				try{
					jsonObject = new JSONObject();
					jsonArray = new JSONArray();
					if(clientId != null && !clientId.equals("")){
						ArrayList <Object> List = cfunc.getPowerConnectionReport(systemId,Integer.parseInt(clientId),startDate,endDate,language,offset);
						jsonArray = (JSONArray) List.get(0);
						if(jsonArray.length() > 0){
							jsonObject.put("tripExceptionReportRoot", jsonArray);
						}else{
							jsonObject.put("tripExceptionReportRoot", "");
						}
						ReportHelper reportHelper = (ReportHelper) List.get(1);
						session.setAttribute(jspName, reportHelper);
						session.setAttribute("startDate", sdf.format(sdfDB.parse(startDate.replace("T", " "))));
						session.setAttribute("endDate", sdf.format(sdfDB.parse(endDate.replace("T", " "))));
						session.setAttribute("custName", customerName);
						//System.out.println(jsonObject.toString());
						response.getWriter().print(jsonObject.toString());
					}
				}catch(Exception e){
					e.printStackTrace();
				}
			}
			else if (param.equals("getGroupNames")) {
				String custId = request.getParameter("custId");
				JSONObject jsonObject = null;
				JSONArray jsonArray = null;
				try{				
					jsonObject = new JSONObject();
					if(custId != null && !custId.equals("")){
						jsonArray = cfunc.getgroupnamesForAlert(Integer.parseInt(custId),systemId,userId);
						jsonObject.put("GroupStoreList", jsonArray);
					}
					else{
						jsonObject.put("GroupStoreList", "");
					}
				response.getWriter().print(jsonObject.toString());
				}
				catch(Exception e){
					e.printStackTrace();
				}
			}
			
			else if (param.equals("getCity")) {
				
				String customerId= request.getParameter("CustomerId");
				
				JSONObject jsonObject = null;
				JSONArray jsonArray = null;
				try{				
					jsonObject = new JSONObject();
					if(!customerId.equals("") && customerId!=null){
						jsonArray = cfunc.getcitynames(Integer.parseInt(customerId),systemId);
						jsonObject.put("CityRoot", jsonArray);
					}
					else{
						jsonObject.put("CityRoot", "");
					}
				response.getWriter().print(jsonObject.toString());
				}
				catch(Exception e){
					e.printStackTrace();
				}
			}
			else if (param.equals("getOperationSummaryReportGrid")) {
				String cusId = request.getParameter("cusId");
				String cityId =request.getParameter("cityId");
				String cusName = request.getParameter("cusName");
				String cityName = request.getParameter("cityName");
				String jspName = request.getParameter("jspName");
				String startdate=request.getParameter("startdate").replace('T', ' ');
				String startd1=startdate;
		        startd1=startd1.substring(0,10);
		        String enddate = request.getParameter("enddate").replace('T', ' ');
				JSONObject jsonObject = null;
				JSONArray jsonArray = null;
				SimpleDateFormat ddmmyyyy = new SimpleDateFormat("dd-MM-yyyy");
				SimpleDateFormat yyyymmdd = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			try{				
				jsonObject = new JSONObject();
				ArrayList<Object> list= cfunc.getOperationSummaryReport(Integer.parseInt(cusId),systemId,cityId,cityName,startdate,enddate);
				jsonArray = (JSONArray) list.get(0);
			if (jsonArray.length() > 0) {
				jsonObject.put("OperationSummaryReportRoot", jsonArray);
				ReportHelper reportHelper = (ReportHelper) list.get(1);
				request.getSession().setAttribute(jspName, reportHelper);
				startd1=ddmmyyyy.format(yyyymmdd.parse(startdate)) ;//converting format from yyyymmdd to ddmmyyyy
				request.getSession().setAttribute("cusId", cusName);
				request.getSession().setAttribute("cityId",cityName);
				request.getSession().setAttribute("startd1",startd1);
				response.getWriter().print(jsonObject.toString());
				}
			}
			catch(Exception e)
				{
				e.printStackTrace();
				}
			}
			else if(param.equals("getCityWisereports")){
				try{
					
					SimpleDateFormat ymd=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
					SimpleDateFormat dmy = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
					String CustId = request.getParameter("CustId");
					String customerName= request.getParameter("custName");
					String cityName = request.getParameter("CityName");
					String CityId = request.getParameter("CityId");
					String startdate = request.getParameter("startdate").replace('T', ' ');
					String startd1=startdate;
					if(!startd1.equals("")){
			    		startd1 =dmy.format(ymd.parse(startd1));
			    		}
			        startd1=startd1.substring(0,10);
			        String enddate = request.getParameter("enddate").replace('T', ' ');
		            String jspName = request.getParameter("jspName");
					
					JSONObject jsonObject = null;
					JSONArray jsonArray = null;
					
					jsonArray = new JSONArray();
					jsonObject = new JSONObject();
					ArrayList < Object > list1 = null;
					if(!customerName.equals(""))
					{
					list1 = cfunc.getCityWisereports(Integer.parseInt(CustId),systemId,CityId,startdate,enddate);
					   jsonArray = (JSONArray) list1.get(0);
					    jsonObject.put("CrossTypeRoot",jsonArray);
					   if(jsonArray.length()>0)
						{
							ReportHelper reportHelper = (ReportHelper) list1.get(1);
			                request.getSession().setAttribute(jspName, reportHelper);
			                request.getSession().setAttribute("custName",customerName);
			                request.getSession().setAttribute("cityName",cityName);
			                request.getSession().setAttribute("startd1",startd1);
						}
						else
						{
							jsonObject.put("CrossTypeRoot", "");
						}
					   
					response.getWriter().print(jsonObject.toString());
				}
				}
				catch(Exception e)
				{
					e.printStackTrace();
				} 
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}
}