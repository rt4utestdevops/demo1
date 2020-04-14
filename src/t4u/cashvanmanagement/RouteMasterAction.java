package t4u.cashvanmanagement;

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
import org.omg.CORBA.Request;

import t4u.beans.LoginInfoBean;
import t4u.functions.AdminFunctions;
import t4u.functions.CashVanManagementFunctions;
import t4u.functions.CommonFunctions;
import t4u.functions.TripFunction;

public class RouteMasterAction extends Action
{
public ActionForward execute(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) {
   	 
    	
    	HttpSession session = request.getSession();
        String param = "";
        String zone = "";
        int systemId = 0;
        int userId = 0;
        int offset = 0;
        LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
        AdminFunctions adfunc = new AdminFunctions();
        systemId = loginInfo.getSystemId();
        zone = loginInfo.getZone();
        userId = loginInfo.getUserId();
        offset = loginInfo.getOffsetMinutes();
        String lang = loginInfo.getLanguage();
        String ltspName = loginInfo.getSystemName();
        String userName = loginInfo.getUserName();
        String category = loginInfo.getCategory();
        String categoryType = loginInfo.getCategoryType();
        CashVanManagementFunctions cashVanfunc = new CashVanManagementFunctions();
        JSONArray jsonArray = null;
        JSONObject jsonObject = new JSONObject();
        if (request.getParameter("param") != null) {
            param = request.getParameter("param").toString();
        }

	
	
	if(param.equalsIgnoreCase("AddorModify"))
	{
		try
		{
			String buttonValue = request.getParameter("buttonValue");
			String CustId=request.getParameter("CustId");
			String RouteId=request.getParameter("RouteId");
			String RouteName=request.getParameter("RouteName");
			
			String status=request.getParameter("Status");
			String id= request.getParameter("id");
			String message="";
			if(buttonValue.equals("Add") && CustId != null && !CustId.equals(""))
			{
				message=cashVanfunc.addRouteDetails(RouteId,RouteName,status,systemId,Integer.parseInt(CustId));
				
			}else if(buttonValue.equals("Modify") && CustId != null && !CustId.equals(""))
			{
				message=cashVanfunc.modifyRouteMaster(RouteId,RouteName,status,systemId,Integer.parseInt(CustId),Integer.parseInt(id));
			}
			
			response.getWriter().print(message);
		}catch(Exception e)
		{
			e.printStackTrace();
		}
	}
	else if(param.equalsIgnoreCase("getRouteMasterDetails"))
	{
		try {
            String customerId = request.getParameter("CustId");
            jsonArray = new JSONArray();
            if (customerId != null && !customerId.equals("")) {
                ArrayList < Object > list1 = cashVanfunc.getRouteMasterDetails(systemId, Integer.parseInt(customerId));
                jsonArray = (JSONArray) list1.get(0);
                if (jsonArray.length() > 0) {
                    jsonObject.put("routeMasterRoot", jsonArray);
                } else {
                    jsonObject.put("routeMasterRoot", "");
                }
                response.getWriter().print(jsonObject.toString());
            } else {
                jsonObject.put("routeMasterRoot", "");
                response.getWriter().print(jsonObject.toString());
            }
        }catch (Exception e) {
			e.printStackTrace();
		}
	}
	return null;
	}
}	
		
	

