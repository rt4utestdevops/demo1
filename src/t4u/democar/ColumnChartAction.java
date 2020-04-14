package t4u.democar;
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
import t4u.functions.DemoCarFunctions;


public class ColumnChartAction extends Action
{
	public ActionForward execute(ActionMapping mapping,ActionForm form,HttpServletRequest request,HttpServletResponse response)
	{
			HttpSession session = ((HttpServletRequest)request).getSession();
			LoginInfoBean  logininfo=(LoginInfoBean)session.getAttribute("loginInfoDetails"); 
			String systemid = String.valueOf(logininfo.getSystemId());
			int clientIdInt = logininfo.getCustomerId();
			JSONArray jsonArray = new JSONArray();
			int offset = logininfo.getOffsetMinutes();

			JSONObject jsonObject = null;
		    String param = "";
			
			DemoCarFunctions dcf = new DemoCarFunctions();
			
			if(request.getParameter("param") != null)
			{
				param = request.getParameter("param").toString();
			}
	        
		   	if(param.equals("DailycolumnChartData"))
		   	{
					String clientId = request.getParameter("clientId");
					String groupId = request.getParameter("groupId");
					String date = request.getParameter("date")+" 00:00:00";

					try
					{
						jsonObject = new JSONObject();
						if(clientId != null)  
						{
							clientIdInt = Integer.parseInt(clientId);
							jsonArray = dcf.getDailyColumnChartData(clientIdInt,Integer.parseInt(systemid),groupId,date,offset);
							jsonObject.put("columnchartroot", jsonArray);
	
						}
						else
						{
							jsonObject.put("columnchartroot", "");
						}
						response.getWriter().print(jsonObject.toString());	
					}
					catch(Exception e)
					{
						e.printStackTrace();
					}
	
			}
		   	else if(param.equals("MonthlycolumnChartData"))
		   	{
					String clientId = request.getParameter("clientId");
					String groupId = request.getParameter("groupId");
					String sdate = request.getParameter("sdate")+" 00:00:00";
					String edate = request.getParameter("edate")+" 00:00:00";


					try
					{
						jsonObject = new JSONObject();
						if(clientId != null)  
						{
							clientIdInt = Integer.parseInt(clientId);
							jsonArray = dcf.getMonthlyAssetUtilityChartData(clientIdInt,Integer.parseInt(systemid),groupId,sdate,edate,offset);
							jsonObject.put("monthlycolumnchartroot", jsonArray);
	
						}
						else
						{
							jsonObject.put("monthlycolumnchartroot", "");
						}
						response.getWriter().print(jsonObject.toString());	
					}
					catch(Exception e)
					{
						e.printStackTrace();
					}
	
			}
		   	return null;
	}

}