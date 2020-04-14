package t4u.containercargomanagement;

import java.io.IOException;
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
import t4u.functions.RakeShiftingFunctions;


public class RakeTripCreationAction extends Action {

	public ActionForward execute(ActionMapping mapping,ActionForm form,HttpServletRequest request,HttpServletResponse response)
	{
		
		HttpSession session = ((HttpServletRequest)request).getSession();
		LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
		RakeShiftingFunctions rakeExpenseFunc = new RakeShiftingFunctions();
		String systemid = String.valueOf(loginInfo.getSystemId());
		
        String param = "";
		String zone="";
        int systemId = 0;
        int userId = 0;
        int offset = 0;
       
        
        int customerId = loginInfo.getCustomerId();
        systemId = loginInfo.getSystemId();
        zone = loginInfo.getZone();
        userId = loginInfo.getUserId();
        offset = loginInfo.getOffsetMinutes();
        String lang = loginInfo.getLanguage();
    
        JSONArray jsonArray = null;
		JSONObject jsonObject=null;
       
		
        if (request.getParameter("param") != null) {
			param = request.getParameter("param").toString();
		}
        if(param.equals("getBranchNames"))
    	{
    		try
    		{
    			//String VehicleType=request.getParameter("VehicleType");
				if(systemId!=0&&customerId!=0)
				{
					jsonObject = new JSONObject();
					jsonArray = rakeExpenseFunc.getBranchNames(systemId, customerId);	
					jsonObject.put("branchNameRoot", jsonArray);
					response.getWriter().print(jsonObject.toString());
				}
    		}
    		catch(Exception e)
    		{
    			e.printStackTrace();
    		}
    	}
        else if(param.equals("getVehicleNumber"))
    	{
        	
    		try
    		{
    			String VehicleType=request.getParameter("VehicleType");
				if(systemId!=0&&customerId!=0)
				{
					jsonObject = new JSONObject();
					jsonArray = rakeExpenseFunc.getVehicleNo(VehicleType,systemId, customerId,userId);	
					jsonObject.put("VehicleNoRoot", jsonArray);
					response.getWriter().print(jsonObject.toString());
				}
    		}
    		catch(Exception e)
    		{
    			e.printStackTrace();
    		}
    	}
        else if (param.equalsIgnoreCase("getTPTNames"))
        {
			try
			{
				if(systemId!=0&&customerId!=0)
				{
					jsonObject = new JSONObject();
					jsonArray = rakeExpenseFunc.getActiveTransporters(systemId, customerId);
					jsonObject.put("TPTRoot", jsonArray);
					response.getWriter().print(jsonObject.toString());
				}
			}
			catch(Exception e)
			{
				e.printStackTrace();
			}
		}
        else if (param.equalsIgnoreCase("getDriverName"))
        {
			try
			{
				String VehicleNo=request.getParameter("VehicleNo");
				if(systemId!=0&&customerId!=0)
				{
					jsonObject = new JSONObject();
					jsonArray = rakeExpenseFunc.getDriverName(systemId, VehicleNo);
					jsonObject.put("DriverRoot", jsonArray);
					response.getWriter().print(jsonObject.toString());
				}
			}
			catch(Exception e)
			{
				e.printStackTrace();
			}
		}
        else if(param.equalsIgnoreCase("AddorModify"))
        {
        	try
        	{
        		String buttonValue = request.getParameter("buttonValue");
        		String uniqueId = request.getParameter("id");
        		int branchId = Integer.parseInt(request.getParameter("BranchNameComboId")); 
        		
        		String vehicleType= request.getParameter("vehicleTypeId");
        		String VehicleNumber=request.getParameter("VehicleCmboId"); 
        		String driverName=request.getParameter("DriverNameTextId");
        		String ownerName=request.getParameter("ownernameTextId");
        		String driverContact=request.getParameter("driverContactId");
        		String TPTCombo=request.getParameter("TPTComboId");
        		String drivingLicence=request.getParameter("drivingLicenceId");
        		
    			String message="";
        		
        		if(buttonValue.equals("Add"))
    			{
        				message=rakeExpenseFunc.addTripCreation(vehicleType,userId,systemId,customerId,VehicleNumber,driverName,ownerName,driverContact,TPTCombo,drivingLicence,branchId);
    			}
    			else if(buttonValue.equals("Modify"))
    			{
        				message=rakeExpenseFunc.modifyTripCreation(uniqueId,vehicleType,userId,systemId,customerId,VehicleNumber,driverName,ownerName,driverContact,TPTCombo,drivingLicence,branchId);
    			}
    			response.getWriter().print(message);
        	}
        	catch(Exception e){
        		e.printStackTrace();
        	}
        }
        else if (param.equals("getOwnerName")){
			try{
		        String clientId = request.getParameter("ClientId");
		        String vehicleNo= request.getParameter("MarketVehicleId");
		        
		        //System.out.println("--vehicleNo---:"+vehicleNo);
		                
				if(clientId != null && !clientId.equals("")){
					customerId = Integer.parseInt(clientId);
				}
				jsonObject = new JSONObject();
				jsonArray = rakeExpenseFunc.getOwnerName(vehicleNo, Integer.parseInt(systemid), customerId);	
				//System.out.println(jsonArray);
				jsonObject.put("RegOwnerStoreRoot", jsonArray);
				response.getWriter().print(jsonObject.toString());
			}
			catch(Exception e){
				e.printStackTrace();
			}
		}
        else if (param.equals("getTripDetails"))
        {
        	String jspName=request.getParameter("jspName");
        	String VehicleType = request.getParameter("VehicleTypeName"); 
        	int branchName=0;
        	
        	if(request.getParameter("BranchNameComboId")!=null&& !request.getParameter("BranchNameComboId").equalsIgnoreCase(""))
        	{
        		branchName= Integer.parseInt(request.getParameter("BranchNameComboId"));
        	}
			try {
					ArrayList<Object> fuelLogDetails =null;
					jsonObject = new JSONObject();
					if(VehicleType!=null && !VehicleType.equalsIgnoreCase(""))
					{
						fuelLogDetails = rakeExpenseFunc.getRakeTripDetails(systemId,customerId,VehicleType,branchName);
						jsonArray = (JSONArray) fuelLogDetails.get(0);
						if (jsonArray.length() > 0) 
						{
							jsonObject.put("rakeTripRoot", jsonArray);
							ReportHelper reportHelper = (ReportHelper) fuelLogDetails.get(1);
							request.getSession().setAttribute(jspName, reportHelper);
						} 
						else
						{
							jsonObject.put("rakeTripRoot","");
						}
					}
					else
					{
						jsonObject.put("rakeTripRoot","");
					}
					response.getWriter().print(jsonObject.toString());
				} 
				catch(Exception e)
				{
					e.printStackTrace();
			    }
		}
        else if(param.equals("getInnerGridTripApprovalDetails"))
        {
        	try
        	{
        		String uniqueId=request.getParameter("uniqueId");
				JSONArray fuelLogDetails =null;
				jsonObject = new JSONObject();
				fuelLogDetails = rakeExpenseFunc.getInnerGridTripApprovalDetails(systemId,customerId,Integer.parseInt(uniqueId));
					//jsonArray = (JSONArray) fuelLogDetails.get(0);
					if (fuelLogDetails.length() > 0) 
					{
						jsonObject.put("TripApprovalInnergridRoot", fuelLogDetails);
					} 
					else
					{
						jsonObject.put("TripApprovalInnergridRoot","");
					}
					response.getWriter().print(jsonObject.toString());
			}
			catch(Exception e)
			{
				e.printStackTrace();
		    }
        }
        else if (param.equals("allocateOrCancleDetails")) {
            String datajson = request.getParameter("jsonData");
            String buttonValue = request.getParameter("buttonValue");
            String uniqueId = request.getParameter("uniqueId");
            String message = "";
            String allocated="";
            try {
                if(buttonValue.equalsIgnoreCase("Allocate")){
                	allocated = "Y";
                }else{
                	allocated = "N";
                }
                message = rakeExpenseFunc.allocateOrCancelTripDetails(datajson,systemId, customerId, userId,allocated,uniqueId);
                response.getWriter().print(message);
            } catch (IOException e) {
                e.printStackTrace();
            }

        }
        if(param.equals("getAllocationlDetails"))
        {
        	try
        	{
        		String uniqueId=request.getParameter("uniqueId");
				JSONArray fuelLogDetails =null;
				jsonObject = new JSONObject();
				fuelLogDetails = rakeExpenseFunc.getAllocationDetails(systemId,customerId,Integer.parseInt(uniqueId));
					//jsonArray = (JSONArray) fuelLogDetails.get(0);
					if (fuelLogDetails.length() > 0) 
					{
						jsonObject.put("viewApprovalInnerGridRoot", fuelLogDetails);
					} 
					else
					{
						jsonObject.put("viewApprovalInnerGridRoot","");
					}
					response.getWriter().print(jsonObject.toString());
			}
			catch(Exception e)
			{
				e.printStackTrace();
		    }
        }
        if(param.equals("addAdditionalCash"))
        {
        	try
        	{
        		String buttonValue = request.getParameter("buttonValue");
        		int  uniqueId = Integer.parseInt(request.getParameter("uniqueId"));
        		double addtnalamtfield = Double.parseDouble(request.getParameter("addtnalamtfield")); 
        		
    			String message="";
        		
        		if(buttonValue.equals("Add Cash"))
    			{
        				message=rakeExpenseFunc.addAdditionalCash(addtnalamtfield,systemId,customerId,uniqueId);
    			}
    			
    			response.getWriter().print(message);
        	}
        	catch(Exception e){
        		e.printStackTrace();
        	}
        }
        if(param.equals("addAdditionalFuelAndAmount"))
        {
        	try
        	{
        		String buttonValue = request.getParameter("buttonValue");
        		int  uniqueId = Integer.parseInt(request.getParameter("uniqueId"));
        		double additionalFuelField = Double.parseDouble(request.getParameter("additionalFuelField"));
        		double additionalfuelAmtField = Double.parseDouble(request.getParameter("additionalfuelAmtField"));
        		
    			String message="";
        		
        		if(buttonValue.equals("Add"))
    			{
        				message=rakeExpenseFunc.addAdditionalFuelAndFuelAmount(additionalFuelField,additionalfuelAmtField,systemId,customerId,uniqueId);
    			}
    			
    			response.getWriter().print(message);
        	}
        	catch(Exception e){
        		e.printStackTrace();
        	}
        }
        else if (param.equals("closeRakeShiftTripDetails")) 
        {
           
           String uniqueid = request.getParameter("uniqueid");
           String buttonValue = request.getParameter("buttonValue");
           String message = "";
           String status="";
           try {
               
               message = rakeExpenseFunc.closeRakeShiftTripDetails(Integer.parseInt(uniqueid),customerId,systemId,buttonValue);
               response.getWriter().print(message);
           } catch (IOException e) {
               e.printStackTrace();
           }

       }
        return null;
	}
}
