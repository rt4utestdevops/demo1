package t4u.admin;

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
import t4u.functions.DocumentManagementFunctions;
/**
 * 
 * @author Ashutosh,Nikhil 
 * @action Action Group Class can perform adding modifying and deleting action with AssetGroup
 *
 */
public class AssetGroupAction extends Action{
	public ActionForward execute(ActionMapping mapping, ActionForm form,HttpServletRequest request, HttpServletResponse response){
			HttpSession session = request.getSession();
			AdminFunctions adfunc= new AdminFunctions();
			LoginInfoBean loginInfo=(LoginInfoBean)session.getAttribute("loginInfoDetails");
			int systemId=loginInfo.getSystemId();
			int createdUser=loginInfo.getUserId();
			int userId = loginInfo.getUserId();
			int offSet = loginInfo.getOffsetMinutes();
			String serverName=request.getServerName();
			String sessionId = request.getSession().getId();
			String zone=loginInfo.getZone();
			JSONArray jsonArray = null;
			JSONObject jsonObject = null;
			String param = "";
			
			if(request.getParameter("param")!=null)
			{
				param=request.getParameter("param").toString();
			}

			/*******************************************************************************************************************************
			 			* 						Getting Grid Details for Asset Group
			 ********************************************************************************************************************************/
			if(param.equalsIgnoreCase("getAssetGroupDetails"))
			{
				try
				{
				String customerid=request.getParameter("customerID");
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();			
				jsonArray=adfunc.getAssetGroupdetails(customerid,systemId,zone);
				if(jsonArray.length()>0)
				{
				jsonObject.put("AssetGroupRoot", jsonArray);
				}
				else
				{
				jsonObject.put("AssetGroupRoot", "");
				}
				response.getWriter().print(jsonObject.toString());
				}
				catch(Exception e)
				{
					System.out.println("Exception in AssetGroupAction:-getAssetGroupDetails "+e.toString());
				}
			}	
			/*******************************************************************************************************************************
 			* 						Getting State Details for Asset Group
 			********************************************************************************************************************************/
			else if(param.equalsIgnoreCase("getStateDetails"))
			{
				try
				{
					String customerid=request.getParameter("customerID");
					jsonArray = new JSONArray();
					jsonObject = new JSONObject();			
					jsonArray=adfunc.getStatedetails(customerid,systemId);
					if(jsonArray.length()>0)
					{
						jsonObject.put("StateRoot", jsonArray);
					}
					else
					{
						jsonObject.put("StateRoot", "");
					}
					response.getWriter().print(jsonObject.toString());
				}
				catch(Exception e)
				{
					System.out.println("Exception in AssetGroupAction:-getAssetGroupDetails "+e.toString());
				}
			}
			/*******************************************************************************************************************************
 			* 						Getting City Details for Asset Group
 			********************************************************************************************************************************/
			else if(param.equalsIgnoreCase("getCityDetails"))
			{
				try
				{
					String stateId=request.getParameter("stateId");
					if(stateId!=null && !stateId.equals("")){
					jsonArray = new JSONArray();
					jsonObject = new JSONObject();			
					jsonArray=adfunc.getCityDetails(Integer.parseInt(stateId));
					if(jsonArray.length()>0)
					{
						jsonObject.put("cityRoot", jsonArray);
					}
					else
					{
						jsonObject.put("cityRoot", "");
					}
					}else{
						jsonObject.put("cityRoot", "");
					}
					//System.out.println(jsonObject.toString());
					response.getWriter().print(jsonObject.toString());
				}
				catch(Exception e)
				{
					System.out.println("Exception in AssetGroupAction:-getCityDetails"+e.toString());
				}
			}
			/***********************************************************************************************************************************
			 			*				 Getting  the supervisor from into the table dbo.ASSET_GROUP
			 ***********************************************************************************************************************************/
					
			else if (param.equals("getSupervisorDetails")) {
			try {
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				String cuId = "0";
				if (request.getParameter("CustId") != null) {
					cuId = request.getParameter("CustId");
				}
				int custId = Integer.parseInt(cuId);

				jsonArray = adfunc.getSupervisorDetails(systemId, custId);
				if (jsonArray.length() > 0) {
					jsonObject.put("SupervisorRoot", jsonArray);
				} else {
					jsonObject.put("SupervisorRoot", "");
				}
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {
				System.out.println("Error in Asset Group Action:-getSupervisorDetails "+ e.toString());
			}

		}
		/****************************************************************************************************************************
		          *           			 Deleting asset group details from the table dbo.ASSET_GROUP
		 ***************************************************************************************************************************/
	
			else if(param.equals("deleteAssetGroupDetails")){
				try{
					String custName= request.getParameter("customerID");					
					String groupid =request.getParameter("assetgroupID");
					String defaultgroupname =request.getParameter("customerName");
					String pageName=request.getParameter("pageName"); 
					String message=adfunc.deleteAssetGroupDetails(systemId ,custName, groupid,defaultgroupname,userId,pageName,sessionId,serverName);
					response.getWriter().print(message);	
				}catch(Exception e){
					System.out.println("Error in Asset Group Action:-deleteAssetGroupDetails "+e.toString());
				}			
			}
			
		/**************************************************************************************************************************
		    	* 					Saving or Modifying the Asset Group details into the table dbo.ASSET_GROUP
		****************************************************************************************************************************/
					
		
			else if (param.equals("saveormodifyAssetGroup")) {
			try {
				String buttonValue = request.getParameter("buttonValue");
				String cutomerId = request.getParameter("customerID");
				String assetGroupName = request.getParameter("assetGroupName");
				String assetSuperiorName = request.getParameter("assetSupervisor");
				String assetGroupID=request.getParameter("assetnewGroupid");
				String assetgroupstate=request.getParameter("assetgroupstate");
				String cityId=request.getParameter("cityId");
				cityId=cityId!=null&&!cityId.equals("")?cityId:"0";
				String hubId = request.getParameter("hubId");
				String hubIdModify = request.getParameter("hubIdModify");
				String pageName=request.getParameter("pageName");
				String message = "";
				if(hubId.equals("") || hubId==null)
				{
					hubId="0";
				}
				
				boolean groupNameExistFlag=false;
					if (buttonValue.equals("add")) {
						if (!adfunc.assetGroupExist(cutomerId, systemId, assetGroupName)) {
						message = adfunc.saveAssetGroupDetails(assetGroupName,assetSuperiorName,assetgroupstate,systemId, createdUser,cutomerId,
								Integer.parseInt(hubId),Integer.parseInt(cityId),pageName,sessionId,serverName);
						}
						else
						{
						message="Group Name Already Exist";		
						}
						response.getWriter().print(message);
					} else if (buttonValue.equals("modify")) {
						String assetnewGroupName="";
						if(request.getParameter("assetnewGroupName")!=null && !request.getParameter("assetnewGroupName").equals(""))
						{
							assetnewGroupName=request.getParameter("assetnewGroupName");
							if (adfunc.assetGroupExist(cutomerId, systemId, assetnewGroupName)) {
								groupNameExistFlag=true;
							}
						}
						else
						{
							assetnewGroupName=assetGroupName;
						}
						if(!groupNameExistFlag)
						{
						message=adfunc.modifyAssetGroupDetails(assetnewGroupName,assetGroupName,assetgroupstate,assetGroupID,assetSuperiorName,
								systemId,createdUser, cutomerId,Integer.parseInt(hubIdModify),Integer.parseInt(cityId),pageName,sessionId,serverName);
						}
						else
						{
						message="Group Name Already Exist";	
						}
						response.getWriter().print(message+","+assetGroupID);
					}
				
			} catch (Exception e) {
				System.out.println("Error in Asset Group Action:-saveRmodifyAssetGroupDetails "+ e.toString());
			}
		}
			
			
			
			
			/*******************************************************************************************************************************
			 * 						Getting Grid Details for Asset Document
			 ********************************************************************************************************************************/
			if(param.equalsIgnoreCase("getAssetDocumentDetails"))
			{
				try
				{
					String customerid=request.getParameter("customerID");
					jsonArray = new JSONArray();
					jsonObject = new JSONObject();
					if(!customerid.equals(""))
						jsonArray=adfunc.getAssetDocumentdetails(Integer.valueOf(customerid),systemId,userId);
					if(jsonArray.length()>0)
					{
						jsonObject.put("AssetGroupRoot", jsonArray);
					}
					else
					{
						jsonObject.put("AssetGroupRoot", "");
					}
					response.getWriter().print(jsonObject.toString());
				}
				catch(Exception e)
				{
					System.out.println("Exception in AssetDocument:-getAssetDocumentDetails "+e.toString());
				}
			}	

			else if (param.equals("deleteAssetDocument")) {
				
				DocumentManagementFunctions cf = new DocumentManagementFunctions();
				
				String delImgFile = request.getParameter("delImgFile");
				String delImageId = request.getParameter("delImageId");
				String category = request.getParameter("category");
				String regNo = request.getParameter("value");
				int customerId = 0;
				
				if(request.getParameter("ClientId") != null || !request.getParameter("ClientId").equals("") ){
					customerId = Integer.parseInt(request.getParameter("ClientId"));
				}
				
				if ("VEHICLE".equals(category)) {
					customerId = cf.getClientId(regNo, systemId);
				}
				
				try {
					String message=adfunc.assetDocumentDelete(customerId,regNo,systemId,delImgFile,category,delImageId);
					response.getWriter().print(message);
				} catch (Exception e) {
					e.printStackTrace();
				}

			}
			/*******************************************************************************************************************************
			 * 						Getting Grid Details for Service Type
			 ********************************************************************************************************************************/
			if(param.equalsIgnoreCase("getType"))
			{
				try
				{
					String customerid=request.getParameter("customerID");
					if(customerid==null)
					{
						customerid="0";
					}
					jsonArray = new JSONArray();
					jsonObject = new JSONObject();
					jsonArray=adfunc.getServiceType(systemId,Integer.valueOf(customerid));
					if (jsonArray.length() > 0) {
						jsonObject.put("ServiceRoot", jsonArray);
					} else {
						jsonObject.put("ServiceRoot", "");
					}
					response.getWriter().print(jsonObject.toString());
				}
				catch(Exception e)
				{
					System.out.println("Exception in WebServiveType:-getServiceType "+e.toString());
				}
			}
			
			
			/*******************************************************************************************************************************
			 * 						Getting Grid Details for Service Type
			 ********************************************************************************************************************************/
			if(param.equalsIgnoreCase("getServiceTypeDetails"))
			{
				try
				{
					String customerid=request.getParameter("CustId");
					String customerName= request.getParameter("custName");
					String serviceType=request.getParameter("serviceType");
					String startDate = request.getParameter("startDate").replace('T', ' ');
		            String endDate = request.getParameter("endDate").replace('T', ' ');
					String jspName = request.getParameter("jspName");


					jsonArray = new JSONArray();
					jsonObject = new JSONObject();
					ArrayList < Object > list1 = null;
					if(!customerName.equals("")&&!serviceType.equals(""))
					{
					   list1 = adfunc.getServiceTypeDetails(serviceType,Integer.valueOf(customerid),systemId,startDate,endDate,offSet);
					jsonArray = (JSONArray) list1.get(0);
					if(jsonArray.length()>0)
					{
						jsonObject.put("ServiceTypeRoot", jsonArray);
						ReportHelper reportHelper = (ReportHelper) list1.get(1);
		                request.getSession().setAttribute(jspName, reportHelper);
		                request.getSession().setAttribute("custName",customerName);
		                request.getSession().setAttribute("startDate", startDate);
		                request.getSession().setAttribute("endDate", endDate);
					}
					else
					{
						jsonObject.put("ServiceTypeRoot", "");
					}
					}
					response.getWriter().print(jsonObject.toString());
				}
				catch(Exception e)
				{
					System.out.println("Exception in WebServiveTypeDetails:-getServiceTypeDetails "+e.toString());
				}
			}	
			
			   if (param.equals("getHubNames")) {
		            try {
		                jsonArray = new JSONArray();
		                jsonObject = new JSONObject();
		                String custId=request.getParameter("customerID");
		                if (custId != null && !custId.equals("")) {	                
			                jsonArray = adfunc.getHubNames(Integer.parseInt(custId),systemId,zone);
			                if (jsonArray.length() > 0) {
			                    jsonObject.put("hubNameRoot", jsonArray);
			                } else {
			                    jsonObject.put("hubNameRoot", "");
			                }
			                response.getWriter().print(jsonObject.toString());
			                } else {
				                jsonObject.put("hubNameRoot", "");
				                response.getWriter().print(jsonObject.toString());
				            }
		            } catch (Exception e) {
		            	 e.printStackTrace();
		             }
		        }   
			return null;
	}

}
