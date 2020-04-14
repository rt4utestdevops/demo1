package t4u.cashvanmanagement;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.struts.action.Action;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.json.JSONArray;
import org.json.JSONObject;

import t4u.beans.Armory;
import t4u.beans.LoginInfoBean;
import t4u.beans.ReportHelper;
import t4u.functions.ArmoryFunction;
import t4u.functions.CommonFunctions;

public class ArmoryMasterAction  extends Action {
@Override
public ActionForward execute(ActionMapping mapping, ActionForm form,HttpServletRequest request, HttpServletResponse response)throws Exception {
	// TODO Auto-generated method stub
	
	String param = "";
	String message = "";		
	HttpSession session = request.getSession();
	LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");

	int systemId = loginInfo.getSystemId();
	int userId = loginInfo.getUserId();
	int offset = loginInfo.getOffsetMinutes();
	int customerId = loginInfo.getCustomerId();
	String lang = loginInfo.getLanguage();

	CommonFunctions cf = new CommonFunctions();
ArmoryFunction armoryFunction = null;
	JSONArray jsonArray = null;
	if (request.getParameter("param") != null) {
		param = request.getParameter("param").toString();
	}
	
	/**
	 * save inward armory
	 */
	if (param.equalsIgnoreCase("saveArmory")) {
		Armory armory=new Armory();
		armoryFunction=new ArmoryFunction();
		Integer assetItemId=Integer.parseInt(request.getParameter("assetItemId"));
		String dateString=request.getParameter("date");
				String vendorName=request.getParameter("vendor");
						Integer branchId=Integer.parseInt(request.getParameter("branch"));
								String jsonData=request.getParameter("assetIds");
								
							
							
		String custId=request.getParameter("CustId");	
		boolean b=armoryFunction.saveArmory(jsonData,branchId,vendorName,assetItemId,dateString,systemId,custId,userId);
		if(b){
			response.getWriter().print("saved successfully");
			return null;
		}
	}
	else if(param.equalsIgnoreCase("getArmonyDetails")){
		 JSONObject JsonObject = new JSONObject();
		 JsonObject.put("armonyDetailsroot", ""); 
		response.getWriter().print(JsonObject.toString());
	}
	else if(param.equalsIgnoreCase("getAllAssetNos")){
		armoryFunction=new ArmoryFunction();
		JSONArray jsonarray=new JSONArray();
		JSONObject JsonObject = new JSONObject();
		
	    jsonarray = armoryFunction.getAssetNames(systemId, customerId); 
		 
			if (jsonarray.length() > 0) {
				JsonObject.put("validateAssetStoreRoot", jsonarray);
			} else {
				JsonObject.put("validateAssetStoreRoot", "");
			}
			
			response.getWriter().print(JsonObject.toString());
	}
	/**
	 * Adding asset name for armory
	 */
	else if(param.equalsIgnoreCase("additem")){
		armoryFunction=new ArmoryFunction();
		
		Integer custId=Integer.parseInt(request.getParameter("CustId"));
		String item=request.getParameter("item");
		String itemType = request.getParameter("armory");
		message=armoryFunction.saveArmoryItem(item, systemId, custId,userId,itemType);
		 response.getWriter().print(message);
		 
	}
	/**
	 * Armory Item names to show on Armory Inward page
	 */
	else if(param.equalsIgnoreCase("armoryItems")){
		armoryFunction=new ArmoryFunction();
		 JSONObject JsonObject = new JSONObject();
		//Integer custId=Integer.parseInt(request.getParameter("CustId"));
		 JSONArray jsonarray=armoryFunction.getArmoryItems(systemId, customerId);
		 
			if (jsonarray.length() > 0) {
				JsonObject.put("armoryItems", jsonarray);
			} else {
				JsonObject.put("armoryItems", "");
			}
			response.getWriter().print(JsonObject.toString());
	}
	else if(param.equalsIgnoreCase("armoryStationaryItems")){
		armoryFunction=new ArmoryFunction();
		 JSONObject JsonObject = new JSONObject();
		//Integer custId=Integer.parseInt(request.getParameter("CustId"));
		 JSONArray jsonarray=armoryFunction.getArmoryAndStationaryItems(systemId, customerId);
		 
			if (jsonarray.length() > 0) {
				JsonObject.put("armoryItems", jsonarray);
			} else {
				JsonObject.put("armoryItems", "");
			}
			response.getWriter().print(JsonObject.toString());
	}
	
	
	
	/**
	 * return branch against which we are doing inventory
	 */
	else if(param.equalsIgnoreCase("getBranches")){
		armoryFunction=new ArmoryFunction();
		 JSONObject JsonObject = new JSONObject();
		
		 JSONArray jsonarray=armoryFunction.getBranches(systemId, customerId);
		 
			if (jsonarray.length() > 0) {
				JsonObject.put("branches", jsonarray);
			} else {
				JsonObject.put("branches", "");
			}
			response.getWriter().print(JsonObject.toString());
	}
	/**
	 * pending armory to show on page
	 */
	else if(param.equalsIgnoreCase("getPendingArmories")){
		
		 armoryFunction=new ArmoryFunction();
		 String customerid=request.getParameter("CustId");
		 String customerName= request.getParameter("custName");
		 String jspName = request.getParameter("jspName");
		 JSONObject JsonObject = new JSONObject();
		 jsonArray = new JSONArray();
		 JsonObject = new JSONObject();
		 List<Object> list1=null;
		 list1=armoryFunction.getPendingArmories(systemId, Integer.parseInt(customerid),userId);
		 if(!customerName.equals("")&& customerName != null)
		 {
		 list1 =armoryFunction.getPendingArmories(systemId,Integer.parseInt(customerid),userId);
		   jsonArray = (JSONArray) list1.get(0);
		    
		    if(jsonArray.length()>0)
		 {
		     JsonObject.put("pendingArmories",jsonArray);
		 }
		 else
		 {
		 JsonObject.put("pendingArmories", "");
		 }
		    ReportHelper reportHelper = (ReportHelper) list1.get(1);
            request.getSession().setAttribute(jspName, reportHelper);
            request.getSession().setAttribute("custName",customerName);
            response.getWriter().print(JsonObject.toString());
		 }
	}
		
	else if(param.equalsIgnoreCase("getArmoryInventory")){
		armoryFunction=new ArmoryFunction();
		 String customerid=request.getParameter("CustId");
		 String customerName= request.getParameter("custName");
		 String jspName ="";
		 if(request.getParameter("jspName") !=null ){
		 jspName = request.getParameter("jspName");
		 }
		 JSONObject JsonObject = new JSONObject();
		 jsonArray = new JSONArray();
		 JsonObject = new JSONObject();
		

		 List<Object> list1= new ArrayList<Object>();
		
		  if(customerid != null && !customerid.equals(""))
		 {
		 list1 =armoryFunction.getArmoryInventory(offset,systemId,customerId);
		   jsonArray = (JSONArray) list1.get(0);
		 } 
		    if(jsonArray.length()>0)
		 {
		     JsonObject.put("inventories",jsonArray);
		        ReportHelper reportHelper = (ReportHelper) list1.get(1);
	            request.getSession().setAttribute(jspName, reportHelper);
	            request.getSession().setAttribute("custName",customerName);
	            response.getWriter().print(JsonObject.toString());
		 }
		 else
		 {
		  JsonObject.put("inventories", "");
		  request.getSession().setAttribute(jspName,jspName);
          request.getSession().setAttribute("custName",customerName);
          response.getWriter().print(JsonObject.toString());
		 }
		   
		 
	}
	
	else if(param.equalsIgnoreCase("saveStatusOfArmory")){
		try{
			String resp = "";
			armoryFunction=new ArmoryFunction();
			String customerid=request.getParameter("CustId");
			String status  = request.getParameter("Status"); 
			String jsonData = request.getParameter("JsonData"); 
			 resp=armoryFunction.saveStatusOfArmory(systemId,Integer.parseInt(customerid),userId,status,jsonData);
			 response.getWriter().print(resp);
		
			}
	 catch (Exception e) {
		e.printStackTrace();
	}
	}
	else if(param.equalsIgnoreCase("getVaultInward")){
		String startDate = request.getParameter("startDate");
		String endDate = request.getParameter("endDate");
		armoryFunction=new ArmoryFunction();
		try{
			JSONObject JsonObject = new JSONObject();
			if(startDate != null && !startDate.equals("")){
				JSONArray jsonarray = armoryFunction.getVaultInward(systemId,customerId,startDate,endDate,offset);
				if (jsonarray.length() > 0) {
					JsonObject.put("vaultTypeRoot", jsonarray);
				} else {
					JsonObject.put("vaultTypeRoot", "");
				}
			}else{
				JsonObject.put("vaultTypeRoot", "");
			}
			response.getWriter().print(JsonObject.toString());
		}catch(Exception e){
			e.printStackTrace();
		}
	}
	else if(param.equalsIgnoreCase("getCustomerName")){
		armoryFunction=new ArmoryFunction();
		JSONObject JsonObject = new JSONObject();
		JSONArray jsonarray = armoryFunction.getCustomerName(systemId,customerId);
		
		if (jsonarray.length() > 0) {
			JsonObject.put("CustomerRoot", jsonarray);
		} else {
			JsonObject.put("CustomerRoot", "");
		}
		response.getWriter().print(JsonObject.toString());
	}
return null;
}
}
