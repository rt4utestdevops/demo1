package t4u.admin;



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
import t4u.functions.AdminFunctions;



	public class DrivarPerformanceAction  extends Action {

		public ActionForward execute(ActionMapping mapping, ActionForm form,HttpServletRequest request, HttpServletResponse response) {

	

			HttpSession session = request.getSession();

			String param = "";
			int systemId=0;
			int userId=0;
			int offset=0;
			int clientId=0;
			LoginInfoBean loginInfo=(LoginInfoBean)session.getAttribute("loginInfoDetails");
			AdminFunctions admfun = new AdminFunctions();
			systemId=loginInfo.getSystemId();
			userId=loginInfo.getUserId();
			offset=loginInfo.getOffsetMinutes();
			String lang = loginInfo.getLanguage();
			JSONArray jsonArray = null;
			JSONObject jsonObject = new JSONObject();
			if (request.getParameter("param") != null) {
				param = request.getParameter("param").toString();
			}
			
			if (param.equals("getGroupNames")) {
				
				try{				
					String clientIdSelected = request.getParameter("CustId");
					
					if(clientIdSelected != null && !clientIdSelected.equals("")){
						clientId = Integer.parseInt(clientIdSelected);
					}
					jsonObject = new JSONObject();
					if(clientIdSelected != null){
							jsonArray = admfun.getgroupnamesForAlert(systemId,clientId,userId);
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
			  if(param.equals("getDriversGroups")){
			       String clientId1 = request.getParameter("clientId");
			        String groupId = request.getParameter("groupId");
			        jsonObject =new JSONObject();
					try{
					if (clientId1 != null && !clientId1.equals("") && groupId != null && !groupId.equals("")) {
					jsonArray = admfun.getDriverList(systemId,clientId1,groupId);
					jsonObject.put("driverGridRoot", jsonArray);
					}
			        else{
			        jsonObject.put("driverGridRoot", jsonArray);	
			        }
					response.getWriter().print(jsonObject.toString());	
					}
					catch(Exception e){
					e.printStackTrace();
					}
						
					}
			  
			  if(param.equals("generateReportPDO")){
					//String periodOption = request.getParameter("periodOption");
				  SimpleDateFormat sdf= new SimpleDateFormat("yyyy-MM-dd");
				  SimpleDateFormat sdf1= new SimpleDateFormat("dd-MM-yyyy");
				  String clientId1 = request.getParameter("CustId");
			        String custmerName = request.getParameter("custName");
			        String assetType = request.getParameter("AssetType");
			        String startDate = request.getParameter("StartDate");
			        String endDate = request.getParameter("EndDate");
			        String s = request.getParameter("gridData");
			        String jspname = request.getParameter("jspName");
			        String groId = request.getParameter("groid");
			        String groupname = request.getParameter("groupName");
			        String type=request.getParameter("type");
			        
			        try {
			        	ArrayList list1=new ArrayList();
                    	if(clientId1!= null && groId!=null && !clientId1.equals("") && !groId.equals(""))
                    	{
                		if(type.equals("Daily")){
    					list1=admfun.generateDailyReport(s,startDate,endDate,offset,lang,systemId,Integer.parseInt(clientId1),groId);
    					}else{
						list1=admfun.generateReport(s,startDate,endDate,offset,lang,systemId,Integer.parseInt(clientId1),groId);
    					}
						jsonArray = (JSONArray) list1.get(0);
						if(jsonArray.length()>0)
						{
						jsonObject.put("DriverPerformanceRoot", jsonArray);
						}
						else
						{
						jsonObject.put("DriverPerformanceRoot", "");
						}
						
						if (startDate.contains("T")) {
							startDate = startDate.replaceAll("T", " ");
							startDate = sdf1.format(sdf.parse(startDate.substring(0,startDate.indexOf(" "))));
							//startDate = startDate +" 12:00:00";
						}else{
							startDate = sdf1.format(sdf.parse(startDate.substring(0,startDate.indexOf(" "))));
							//startDate = startDate +" 12:00:00";
						}
						if (endDate.contains("T")) {
							endDate = endDate.replaceAll("T", " ");
							endDate = sdf1.format(sdf.parse(endDate.substring(0,endDate.indexOf(" "))));
							//endDate = endDate +" 12:00:00";
						}else{
							endDate = sdf1.format(sdf.parse(endDate.substring(0,endDate.indexOf(" "))));
							//endDate = endDate +" 12:00:00";
						}
						ReportHelper reportHelper=(ReportHelper)list1.get(1);
			    		request.getSession().setAttribute(jspname,reportHelper);
			    		request.getSession().setAttribute("startdate",startDate);
			    		request.getSession().setAttribute("enddate",endDate);
			    		request.getSession().setAttribute("Customer", custmerName);
			    		request.getSession().setAttribute("Type", assetType);
			    		request.getSession().setAttribute("Group", groupname);
						response.getWriter().print(jsonObject.toString());
                    	}
                    	else
						{
    						jsonObject.put("DriverPerformanceRoot", "");
    						response.getWriter().print(jsonObject.toString());
    					}
                    	}
			         catch (Exception e) {
						e.printStackTrace();
					}
			
		}
	
			  return null;
		}
}
