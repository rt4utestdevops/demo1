package t4u.democar;

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

import t4u.beans.ReportHelper;

import t4u.beans.LoginInfoBean;
import t4u.functions.CommonFunctions;
import t4u.functions.DemoCarFunctions;

@SuppressWarnings("unchecked")
public class DailyAssetUtilizationReportAction extends Action
{
	public ActionForward execute(ActionMapping mapping,ActionForm form,HttpServletRequest request,HttpServletResponse response)
	{
			HttpSession session = ((HttpServletRequest)request).getSession();
			LoginInfoBean  logininfo=(LoginInfoBean)session.getAttribute("loginInfoDetails"); 
			int systemid = logininfo.getSystemId();
			int clientIdInt = logininfo.getCustomerId();
			String language=logininfo.getLanguage();

			JSONArray jsonArray = new JSONArray();
			JSONObject jsonObject = null;
		    String param = "";
			int offset = logininfo.getOffsetMinutes();
			int userId=logininfo.getUserId();
			DemoCarFunctions dcf = new DemoCarFunctions();
			CommonFunctions cf = new CommonFunctions();
			
			if(request.getParameter("param") != null)
			{
				param = request.getParameter("param").toString();
			}
	        
		   	if(param.equals("getData"))
		   	{
				String clientId = request.getParameter("custId");
				String groupId = request.getParameter("groupId");
				String gname = request.getParameter("gname");
				String date = request.getParameter("Date");
				String jspName=request.getParameter("jspName");
				
				try
				{
					jsonObject = new JSONObject();
					if(clientId != null  && groupId !=null && !clientId.equals("") && !groupId.equals(""))  
					{
						clientIdInt = Integer.parseInt(clientId);
						ArrayList list1  = dcf.getAssetUtilityData(clientIdInt,systemid,groupId,date,offset,language,userId);
						jsonArray = (JSONArray) list1.get(0);
						jsonObject.put("dardata", jsonArray);
						ReportHelper reportHelper=(ReportHelper)list1.get(1);
			    		request.getSession().setAttribute(jspName,reportHelper);
			    		request.getSession().setAttribute("gname",gname);
			    		request.getSession().setAttribute("date",cf.getFormattedDateddMMYYYY(date.replaceAll("T", " ")));


					}
					else
					{
						jsonObject.put("dardata", "");
					}
					response.getWriter().print(jsonObject.toString());	
				}
				catch(Exception e)
				{
					e.printStackTrace();
				}
	
			}
		   	else if(param.equals("getGroupWithAllOption"))
		    {
				try
				{
					String clientIdSelected = request.getParameter("globalClientId");
					
					jsonObject = new JSONObject();
					if(clientIdSelected != null)
					{
							jsonArray = cf.getgroupnamesAll(Integer.parseInt(clientIdSelected),systemid);
							jsonObject.put("GroupRoot", jsonArray);
					}
					else
					{
						    jsonObject.put("GroupRoot", "");
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