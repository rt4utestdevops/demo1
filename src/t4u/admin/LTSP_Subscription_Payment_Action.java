package t4u.admin;

import java.io.IOException;
import java.util.ArrayList;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.action.Action;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.json.JSONArray;
import org.json.JSONObject;

import t4u.beans.ReportHelper;
import t4u.functions.LTSP_Subscription_Payment_Function;
import t4u.functions.SandMiningFunctions;

public class LTSP_Subscription_Payment_Action extends Action{

public ActionForward execute(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) {
		
		String param="";
		JSONArray jsonArray = null;
		JSONObject jsonObject = new JSONObject();
		LTSP_Subscription_Payment_Function LTSPFunction = new LTSP_Subscription_Payment_Function();
		SandMiningFunctions sandfunc = new SandMiningFunctions();
		if (request.getParameter("param") != null) {
			param = request.getParameter("param").toString();
		}
		
		if (param != null && param.equals("getLTSPNames")) {
			jsonArray = LTSPFunction.getLTSP();
			try {
				jsonObject = new JSONObject();
				jsonObject.put("ltspNameList", jsonArray);
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		}else if (param.equals("getClientNameswrtSystem")) {
			try {				
				String sysid = request.getParameter("systemid");
				jsonArray = LTSPFunction.getClientList(sysid);
				jsonObject.put("clientNameList", jsonArray);
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {
				System.out.println("Error in getting the Client List in Action:" + e.toString());
				e.printStackTrace();
			}
		}else if(param.equals("getDistrictNames")){
			try {
				String ltsp="";
				if (request.getParameter("globalltsp")!=null) 
				{
					ltsp=request.getParameter("globalltsp").toString();	
				}
				
				jsonObject = new JSONObject();
				jsonArray = LTSPFunction.getDistrictNames(ltsp);
				jsonObject.put("districtListNew", jsonArray);
				response.getWriter().print(jsonObject.toString());	
			}
			catch(Exception e)
			{
				System.out.println("Error in getting District Details:"+e.toString());
				e.printStackTrace();
			}
		}else if (param.equals("getSubscriptionPaymentDetails"))
			{
			try{
			jsonArray = new JSONArray();
            jsonObject = new JSONObject();
            String jspName=request.getParameter("jspName");
            
            ArrayList < Object > list1 = LTSPFunction.getSubscriptionPaymentDetails();
            jsonArray = (JSONArray) list1.get(0);
     	if (jsonArray.length() > 0) {
     	jsonObject.put("subscriptionPaymentroot", jsonArray);
     	}
     	else
     	{
     	jsonObject.put("subscriptionPaymentroot", "");
     	}	
     	
     	//ReportHelper reportHelper = (ReportHelper) list1.get(1);
    	//request.getSession().setAttribute(jspName, reportHelper);
     	response.getWriter().print(jsonObject.toString());
     	
         } catch (Exception e) {
         	 e.printStackTrace();
          }
     }else if (param.equals("addSubscriptionPaymentDetails"))
		{
			try{
				 String buttonValue = request.getParameter("buttonValue"); 
				 String ltsp=request.getParameter("globalltsp").toString();
		         String custId =request.getParameter("custId");
		         String districtName = request.getParameter("districtName");
		         String workOrder=request.getParameter("workOrder");
		         String startDate=request.getParameter("startDate").replace("T", " ");
	             String endDate=request.getParameter("endDate").replace("T", " ");
	             String subscription = request.getParameter("subscription");   
	             String amount=request.getParameter("amount");
	             String totalAmount = request.getParameter("totalAmount");  
	             String MoperAmount = request.getParameter("MoperAmount");  
	             String radioCheck = request.getParameter("radioCheck");  
	             String message = "";
	             if(buttonValue.equals("Add") && custId != null && !custId.equals("")){
	            	 message = LTSPFunction.addLTSPSubscriptionDetails(Integer.parseInt(ltsp), Integer.parseInt(custId), districtName, workOrder, startDate, endDate, Integer.parseInt(subscription), Double.parseDouble(amount), Double.parseDouble(totalAmount),Double.parseDouble(MoperAmount),radioCheck);
	             }
	             response.getWriter().print(message);
			} catch (Exception e) {
	         	 e.printStackTrace();
	          }
	  }
	
     else if (param.equals("getTPOwnerAssetDetails"))
		{
		try{
			jsonArray = new JSONArray();
	        jsonObject = new JSONObject();
	        String sysId = request.getParameter("systemId");
	        String customerId = request.getParameter("custID");
	        String jspName = request.getParameter("jspName");
	        String sysName = request.getParameter("systemName");
	        String customerName = request.getParameter("custName");
	        
	        ArrayList < Object > list1 = sandfunc.getTPOwnerAssetDetails(Integer.parseInt(sysId),Integer.parseInt(customerId));
	        jsonArray = (JSONArray) list1.get(0);
		 	if (jsonArray.length() > 0) {
		 	jsonObject.put("tpOwnerAssetroot", jsonArray);
		 	}
		 	else
		 	{
		 	jsonObject.put("tpOwnerAssetroot", "");
		 	}	
		 	ReportHelper reportHelper = (ReportHelper) list1.get(1);
			request.getSession().setAttribute(jspName, reportHelper);
			request.getSession().setAttribute("sysName", sysName);
			request.getSession().setAttribute("customerName", customerName);
		 	response.getWriter().print(jsonObject.toString());
		 	
	     } catch (Exception e) {
	     	 e.printStackTrace();
	     }
	 }
	    else if (param.equals("activeOrInactiveTpOwnerStatus")) {
		 	String custId=request.getParameter("CustId");
			String tpownerId = request.getParameter("tpownerId");
			String sysId = request.getParameter("sysId");
			String buttonValue = request.getParameter("buttonValue");
			String message = "";
			String status="";
			try {
				
				message = sandfunc.activeOrInactiveTPOwnerStarus(Integer.parseInt(tpownerId),Integer.parseInt(custId),Integer.parseInt(sysId),buttonValue);
				response.getWriter().print(message);
			} catch (IOException e) {
				e.printStackTrace();
			}

		}   
		
		//********************************** sand mining general settings ********************************//
		
	    else if(param.equals("getSandMiningGeneralSettingsDetails")){
			try{
				
				String systemId=request.getParameter("systemId");
				
				jsonObject =new JSONObject();
				jsonArray = LTSPFunction.getSandMiningGeneralSettingsDetails(Integer.parseInt(systemId));
				jsonObject.put("sandGeneralSettingsStore", jsonArray);
				response.getWriter().print(jsonObject.toString());	
			}
			catch(Exception e){
				e.printStackTrace();
			}
		}
		
	    else if (param.equals("addSandMiningGeneralSettingsDetails"))
		{
			try{
				 String buttonValue = request.getParameter("buttonValue"); 
		         String systemId =request.getParameter("systemId");
		         String name = request.getParameter("name");
		         String value=request.getParameter("value");
		         String gridNameIndex=request.getParameter("gridNameIndex"); 
		         String gridValueIndex=request.getParameter("gridValueIndex");
	             String message = "";
	             if(buttonValue.equals("Add")){
	            	 message = LTSPFunction.addSandMiningGeneralSettingsDetails(Integer.parseInt(systemId),name,value);
	             }
	             else if(buttonValue.equals("Modify")){
	            	 message = LTSPFunction.modifySandMiningGeneralSettingsDetails(buttonValue,Integer.parseInt(systemId),name,value,gridNameIndex,gridValueIndex);
	             }
	             response.getWriter().print(message);
			} catch (Exception e) {
	         	 e.printStackTrace();
	          }
	  }
	    else if (param.equals("deleteGeneralSettingsData"))
		{
			try{
				 String buttonValue = request.getParameter("buttonValue");
		         String systemId =request.getParameter("systemId");
		         String gridNameIndex = request.getParameter("gridNameIndex");
		         String gridValueIndex=request.getParameter("gridValueIndex");
	             String message = "";
	             
	            	 message = LTSPFunction.modifySandMiningGeneralSettingsDetails(buttonValue,Integer.parseInt(systemId),"","",gridNameIndex,gridValueIndex);
	             response.getWriter().print(message);
			} catch (Exception e) {
	         	 e.printStackTrace();
	          }
	  }
		
		return null;		
	}
}
