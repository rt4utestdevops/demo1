package t4u.trip;

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
import t4u.functions.TripFunction;

public class CustomerRouteMasterAction extends Action {
	
	public ActionForward execute(ActionMapping mapping, ActionForm form,HttpServletRequest request, HttpServletResponse response)throws Exception 
	{
		HttpSession session=request.getSession();
		LoginInfoBean  logininfo=(LoginInfoBean)session.getAttribute("loginInfoDetails"); 
		String param="";
		int systemId = logininfo.getSystemId();
		int customerId = logininfo.getCustomerId();
		int userId=logininfo.getUserId();
		int offset = logininfo.getOffsetMinutes();
		String msg = "";		
		TripFunction tripfunc = new TripFunction();
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonObject = null;
		try{
			if(request.getParameter("param")!=null)
			{
				param = request.getParameter("param").toString();
			}			
		}
		catch(Exception e){
			e.printStackTrace();
		}
		
		if(param.equalsIgnoreCase("getCustomerRouteInformation"))
		{
			String clientId = request.getParameter("clientId");
			jsonArray = new JSONArray();
			jsonObject = new JSONObject();			
			if(clientId!= null && !(clientId == "")){
				jsonArray = tripfunc.getcustomerRouteDetails(systemId,Integer.parseInt(clientId),offset);				
				if (jsonArray.length() > 0) {
					jsonObject.put("customerRouteInfoRoot", jsonArray);
				} else {
					jsonObject.put("customerRouteInfoRoot", "");
				}
				response.getWriter().print(jsonObject.toString());
			} else {
				jsonObject.put("customerRouteInfoRoot", "");
			}
			
		}
	
		if(param.equals("getclient")){
            jsonArray = tripfunc.getClientNames(systemId,customerId);
			
			try{
				jsonObject =new JSONObject();
				
				jsonObject.put("clientNameList", jsonArray);
				response.getWriter().print(jsonObject.toString());	
			}
			catch(Exception e){
				e.printStackTrace();
			}
		}	
		else if(param.equals("getHubNames"))
		{
			if(request.getParameter("clientId")!=null)
			{
				customerId=Integer.parseInt(request.getParameter("clientId"));				
			}			
			jsonArray = (JSONArray)tripfunc.getHub(systemId,customerId);			
			try{
				jsonObject =new JSONObject();			
				jsonObject.put("hubNameList", jsonArray);
				response.getWriter().print(jsonObject.toString());	
			}
			catch(Exception e){
				e.printStackTrace();
			}
		}
		else if(param.equals("InsertTrip"))
		{				
			try{
				if(request.getParameter("clientId")!=null)
					{					
						customerId=Integer.parseInt(request.getParameter("clientId"));
						int	hubid = Integer.parseInt(request.getParameter("hubid"));
						String routeCodeID=request.getParameter("routeCodeID").trim().toUpperCase().toString();
						String buttonValue = request.getParameter("buttonValue");
						if(buttonValue.equals("add")){							
							msg=tripfunc.insertTrip(routeCodeID,hubid,buttonValue,customerId,systemId,userId);
						}
						else if(buttonValue.equals("modify")){
							msg=tripfunc.updauteTrip(routeCodeID,hubid,buttonValue,customerId,systemId,userId);
						}
					}
					response.getWriter().print(msg);
					
				}catch (NumberFormatException e) {
					
				}
			catch(Exception e){
				e.printStackTrace();
			}			
		}		
			return null;	        
	}
	

}