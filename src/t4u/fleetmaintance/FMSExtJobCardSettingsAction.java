package t4u.fleetmaintance;

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
import t4u.functions.FleetMaintanceFunctions;

public class FMSExtJobCardSettingsAction extends Action {
	
	
	@Override
	public ActionForward execute(ActionMapping mapping, ActionForm form,
		HttpServletRequest request, HttpServletResponse response)
		throws Exception {
	HttpSession session = request.getSession();
	LoginInfoBean loginInfo=(LoginInfoBean)session.getAttribute("loginInfoDetails");
	if(loginInfo!=null)
	{
	int isLtsp=2; 
	int systemId=loginInfo.getSystemId();
	int offmin=loginInfo.getOffsetMinutes();
	int customerId=loginInfo.getCustomerId();
	int userId=loginInfo.getUserId();
	isLtsp=loginInfo.getIsLtsp();
	
	String param = "";
	if(request.getParameter("param")!=null)
	{
		param=request.getParameter("param").toString();
	}

	FleetMaintanceFunctions fms = new FleetMaintanceFunctions();
	
		if(param.endsWith("getManagerDetails"))	{
			try
			{
				int CustId=Integer.parseInt(request.getParameter("CustId"));
				JSONArray jsonArray = new JSONArray();
	   			JSONObject jsonObject = new JSONObject();	
	   			jsonArray=fms.getManagerDetails(systemId,CustId);
	   			if(jsonArray.length()>0)
	   			{
	   				jsonObject.put("ManagerRoot", jsonArray);
	   			}
	   			else
	   			{
	   				jsonObject.put("ManagerRoot", "");
	   			}
	   			response.getWriter().print(jsonObject.toString());
	   		}
			catch(Exception e)
   			{
   				e.printStackTrace();
   			}
		}
		if(param.equals("getFMSJobCardSettingsDetails")){
			try
			{
			String CustId=request.getParameter("CustId");
			JSONArray jsonArray = new JSONArray();
   			JSONObject jsonObject = new JSONObject();	
   			ArrayList <Object> list=fms.getFMSJobCardSettingsDetails(systemId,Integer.parseInt(CustId));
   			jsonArray = (JSONArray) list.get(0);
   			if(jsonArray.length()>0){
   				jsonObject.put("fmsjobcardSettingRoot", jsonArray);
   			}
   			else{
   				jsonObject.put("fmsjobcardSettingRoot", "");
   			}
   			response.getWriter().print(jsonObject.toString());
			}
			catch(Exception e)
			{
				e.printStackTrace();
			}
		}
		if(param.equalsIgnoreCase("AddorModify"))
		{
			try
			{
				String buttonValue = request.getParameter("buttonValue");
				String CustId=request.getParameter("CustId");
				double ExtJobCardMaxCost=Double.parseDouble(request.getParameter("ExtJobCardMaxCostId"));
				String ExtJobCardSubTaskYesNo=request.getParameter("ExtJobCardSubTaskYesNo");
				String ManagerName=request.getParameter("managercomboId");
				String id= request.getParameter("id");
				String message="";
				if(buttonValue.equals("Add") && CustId != null && !CustId.equals(""))
				{
					message=fms.addFMSJobCardSettingsDetails(systemId,Integer.parseInt(CustId),ExtJobCardMaxCost,ExtJobCardSubTaskYesNo,ManagerName);
					
				}else if(buttonValue.equals("Modify") && CustId != null && !CustId.equals(""))
				{
					message=fms.modifyFMSJobCardSettingsDetails(ExtJobCardMaxCost,ExtJobCardSubTaskYesNo,ManagerName,Integer.parseInt(id));
				}
				
				response.getWriter().print(message);
			}catch(Exception e)
			{
				e.printStackTrace();
			}
		}
	}
	return null;
	}
}
