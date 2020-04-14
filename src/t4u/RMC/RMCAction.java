package t4u.RMC;


import java.util.ArrayList;
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
import t4u.beans.ReportHelper;
import t4u.common.ApplicationListener;
import t4u.functions.CommonFunctions;
import t4u.functions.RMCFunctions;

public class RMCAction extends Action {

	@SuppressWarnings("unchecked")
	public ActionForward execute(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		String param = "";
		String message = "";
		String zone="";
		int systemId=0;
		int userId=0;
		int offset=0;
		String unitTypeCode="";
		HttpSession session = request.getSession();
		LoginInfoBean loginInfo=(LoginInfoBean)session.getAttribute("loginInfoDetails");
		String language=loginInfo.getLanguage();
		CommonFunctions cf=new CommonFunctions();
		RMCFunctions rmcfunc = new RMCFunctions();
		systemId=loginInfo.getSystemId();
		zone=loginInfo.getZone();
		userId=loginInfo.getUserId();
		offset=loginInfo.getOffsetMinutes();
		JSONArray jsonArray = null;
		JSONObject jsonObject = new JSONObject();
		if (request.getParameter("param") != null) {
			param = request.getParameter("param").toString();
		}
		
		/**
		 * Getting Grid Details for Plant Association
		 */
		if(param.equalsIgnoreCase("getGridRMCPlantAssociationAction"))
		{
			try
			{
			String customerid=request.getParameter("custID");
			jsonArray = new JSONArray();
			jsonObject = new JSONObject();			
			jsonArray=rmcfunc.getGridRMCPlantAssociation(customerid,systemId,zone);
			if(jsonArray.length()>0)
			{
			jsonObject.put("GridRoot", jsonArray);
			}
			else
			{
			jsonObject.put("GridRoot", "");
			}
			response.getWriter().print(jsonObject.toString());
			}
			catch(Exception e)
			{
				
			}
		}
		/**
		 * To save & modify RMC Settings
		 */
		if(param.equalsIgnoreCase("saveormodifyRMCSetting"))
		{
			try
			{
				String buttonvalue=request.getParameter("buttonvalue");
				String customerid=request.getParameter("custID");
				String vehicleno=request.getParameter("vehicleno");
				String loading=request.getParameter("loading");
				String unloading=request.getParameter("unloading");
				if(buttonvalue.equals("add"))
				{		
				int inserResult=rmcfunc.insertPlantSettings(customerid,vehicleno,systemId,loading,unloading,userId);
				if(inserResult>0)
				{
					message="RMC Setting Saved Successfully";
				}
				else
				{
					message="Error in Saving";	
				}
			    }
				else if(buttonvalue.equals("modify"))
				{
					int updateResult=rmcfunc.updatePlantSetting(customerid,vehicleno,systemId,loading,unloading);
					if(updateResult>0)
					{
						message="Updated Successfully";
					}
					else
					{
						message="Error in Updation";	
					}	
				}
				response.getWriter().print(message);
			}
			catch(Exception e)
			{
				
			}	
		}
		/**
		 * To save and modify RMC Plant Association
		 */
		if(param.equalsIgnoreCase("saveRMCPlantAssociation"))
		{
			try
			{
				String buttonvalue=request.getParameter("buttonvalue");
				String customerid=request.getParameter("custmastcomboId");
				String plantid=request.getParameter("plantid");
				String status=request.getParameter("status");
				if(buttonvalue.equals("add"))
				{		
					int inserResult=rmcfunc.insertPlantAssociation(customerid,plantid,systemId,userId,status);
					if(inserResult>0)
					{
						message="Plant Associated Successfully";
					}
					else
					{
						message="Error in Plant Association";	
					}
			    }
				else if(buttonvalue.equals("modify"))
				{
					String hubid=request.getParameter("hubid");
					int updateResult=rmcfunc.updatePlantAssociation(customerid,hubid,systemId,userId,status);
					if(updateResult>0)
					{
						message="Updated Successfully";
					}
					else
					{
						message="Error in Updation";	
					}	
				}
				response.getWriter().print(message);
			}
			catch(Exception e)
			{
				
			}
		}
		/**
		 * Getting Grid details for RMC Settings
		 */
		if(param.equalsIgnoreCase("getGridRMCAction"))
		{
			try
			{
			String customerid=request.getParameter("custID");
			jsonArray = new JSONArray();
			jsonObject = new JSONObject();			
			jsonArray=rmcfunc.getGridRMCSettings(customerid,systemId,zone,userId);
			if(jsonArray.length()>0)
			{
			jsonObject.put("GridRoot", jsonArray);
			}
			else
			{
			jsonObject.put("GridRoot", "");
			}
			response.getWriter().print(jsonObject.toString());
			}
			catch(Exception e)
			{
				
			}
		}
		if(param.equalsIgnoreCase("deleteRMCSetting"))
		{
			String customerid=request.getParameter("custID");
			String vehicleno=request.getParameter("vehicleno");
			String loading=request.getParameter("loading");
			String unloading=request.getParameter("unloading");
			int inserResult=rmcfunc.deletePlantSettings(customerid,vehicleno,systemId,loading,unloading,userId);
			if(inserResult>0)
			{
				message="RMC Setting Deleted Successfully";
			}
			else
			{
				message="Error in Deleting";	
			}
			response.getWriter().print(message);
		}
		
		/**
		 * Getting vehicles details on the basis of selected customer  and LTSP an Unit Type code from properties file
		 */
		if(param.equals("getVehicleDetails")){
		
			
			try {
				Properties properties = null;
				properties = ApplicationListener.prop;
				jsonArray=new JSONArray();
				jsonObject=new JSONObject();
				String custId=request.getParameter("CustId");
				String ltspId=request.getParameter("LTSPId");
				unitTypeCode=properties.getProperty("RMCUnitType");
				if(custId !=null && ltspId !=null){
				jsonArray=rmcfunc.getVehicleDetails(custId,ltspId,unitTypeCode,userId);
				}
				if(jsonArray.length()>0){
					jsonObject.put("VehicleRoot", jsonArray);
				}else{
					jsonObject.put("VehicleRoot", "");
				}
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {
				System.out.println("Error in EmployeeTrackingAction:-getVehicleDetails"+e);
			}
			
		}
		
		/**
		 * Getting Hubs on the basis of Customer for Add option
		 */
		if (param.equals("getHubs")) {
			try{
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				String custID="no";
				if(request.getParameter("CustId")!=null)
				{
				custID=request.getParameter("CustId").toString();
				}				
				jsonArray=rmcfunc.getHubs(custID,zone);
				if(jsonArray.length()>0)
				{
				jsonObject.put("HubRoot", jsonArray);
				}
				else
				{
				jsonObject.put("HubRoot", "");
				}
				response.getWriter().print(jsonObject.toString());
				}  
				catch(Exception e)
				{
				System.out.println("Error in getting Hubs"+e.toString());
			    }			
		}
		if(param.equals("getDailyRMCReport"))
		{
			try
			{
				String groupid=request.getParameter("groupid");
				String startdate=request.getParameter("startdate");
				String enddate=request.getParameter("enddate");
				String jspName=request.getParameter("jspName");
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();	
				ArrayList list1=rmcfunc.getRMCReportDetails(groupid,startdate,enddate,offset,language,systemId,userId);
				jsonArray = (JSONArray) list1.get(0);
				if(jsonArray.length()>0)
				{
				jsonObject.put("RMCReportDetailsRoot", jsonArray);
				}
				else
				{
				jsonObject.put("RMCReportDetailsRoot", "");
				}
				ReportHelper reportHelper=(ReportHelper)list1.get(1);
	    		request.getSession().setAttribute(jspName,reportHelper);
	    		request.getSession().setAttribute("startdate",cf.getFormattedDateddMMYYYY(startdate.replaceAll("T", " ")));
	    		request.getSession().setAttribute("enddate",cf.getFormattedDateddMMYYYY(enddate.replaceAll("T", " ")));
				response.getWriter().print(jsonObject.toString());
			}
			catch(Exception e)
			{
				
			}
		}
		if(param.equals("getRMCActivityReport"))
		{
			try
			{
				String vehicleno=request.getParameter("vehicleNo");
				String startdate=request.getParameter("startdate");
				String enddate=request.getParameter("enddate");
				String jspName=request.getParameter("jspName");
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();	
				ArrayList list1=rmcfunc.getRMCActivityReportDetails(vehicleno,startdate,enddate,offset,language,systemId);
				jsonArray = (JSONArray) list1.get(0);
				if(jsonArray.length()>0)
				{
				jsonObject.put("RMCActivityReportDetailsRoot", jsonArray);
				}
				else
				{
				jsonObject.put("RMCActivityReportDetailsRoot", "");
				}
				ReportHelper reportHelper=(ReportHelper)list1.get(1);
	    		request.getSession().setAttribute(jspName,reportHelper);
	    		request.getSession().setAttribute("startdate",cf.getFormattedDateddMMYYYY(startdate.replaceAll("T", " ")));
	    		request.getSession().setAttribute("enddate",cf.getFormattedDateddMMYYYY(enddate.replaceAll("T", " ")));
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
