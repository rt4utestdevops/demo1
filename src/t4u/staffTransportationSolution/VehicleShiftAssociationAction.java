package t4u.staffTransportationSolution;

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

import t4u.functions.StaffTransportationSolutionFunctions;

public class VehicleShiftAssociationAction  extends Action
{
	public ActionForward execute(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) {
	   	 
	    	
	    	HttpSession session = request.getSession();
	        String param = "";
	        int systemId = 0;
	        int userId = 0;
	        LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
	        systemId = loginInfo.getSystemId();
	        userId = loginInfo.getUserId();
	        StaffTransportationSolutionFunctions stsfunc = new StaffTransportationSolutionFunctions();
	        JSONArray jsonArray = null;
	        JSONObject jsonObject = new JSONObject();
	        if (request.getParameter("param") != null) {
	            param = request.getParameter("param").toString();
	        }
			
	        if(param.equalsIgnoreCase("getVehicleNo")){
	        	try {
	                String customerId = request.getParameter("CustId");
	                jsonArray = new JSONArray();
	                if (customerId != null && !customerId.equals("")) {
	                	jsonArray = stsfunc.getVehicleNo(systemId, Integer.parseInt(customerId));
	                   
	                    if (jsonArray.length() > 0) {
	                        jsonObject.put("VehicleNoRoot", jsonArray);
	                    } else {
	                        jsonObject.put("VehicleNoRoot", "");
	                    }
	                    response.getWriter().print(jsonObject.toString());
	                } else {
	                    jsonObject.put("VehicleNoRoot", "");
	                    response.getWriter().print(jsonObject.toString());
	                }
	            }catch (Exception e) {
	    			e.printStackTrace();
	    		}
	        }
            if(param.equalsIgnoreCase("getShiftNames")){
            	try {
	                String customerId = request.getParameter("CustId");
	                jsonArray = new JSONArray();
	                if (customerId != null && !customerId.equals("")) {
	                	jsonArray = stsfunc.getShiftNames(systemId, Integer.parseInt(customerId));
	                    if (jsonArray.length() > 0) {
	                        jsonObject.put("ShiftRoot", jsonArray);
	                    } else {
	                        jsonObject.put("ShiftRoot", "");
	                    }
	                    response.getWriter().print(jsonObject.toString());
	                } else {
	                    jsonObject.put("ShiftRoot", "");
	                    response.getWriter().print(jsonObject.toString());
	                }
	            }catch (Exception e) {
	    			e.printStackTrace();
	    		}
	        }
	    	if(param.equalsIgnoreCase("AddorModify"))
	    	{
	    		try
	    		{
	    			
	    			String buttonValue = request.getParameter("buttonValue");
	    			String custId=request.getParameter("CustId");
	    			String shiftId=request.getParameter("ShiftId");	
	    			String asscId = request.getParameter("AsscId");	
	    			String status=request.getParameter("Status");
	    			String vehicleNo = request.getParameter("VehicleNo");
	    			String vehicleGrid = request.getParameter("VehicleGrid");
	    			String shiftGrid = request.getParameter("ShiftGrid");
	    			String branch = request.getParameter("BranchId");
	    			String message="";
	    			if(buttonValue.equals("Add") && custId != null && !custId.equals(""))
	    			{
	    				 if (vehicleGrid != null && shiftGrid != null) {
	 		                String st = "[" + vehicleGrid + "]";
	 		                JSONArray js = null;
	 		                try {
	 		                    js = new JSONArray(st.toString());		                   
	 		                } catch (Exception e) {
	 		                    e.printStackTrace();
	 		                }
	 		           
	 		                String stN = "[" + shiftGrid + "]";
	 		                JSONArray jsN = null;
	 		                try {
	 		                    jsN = new JSONArray(stN.toString());		                   
	 		                } catch (Exception e) {
	 		                    e.printStackTrace();
	 		                }
	 		            
	    				message=stsfunc.addShiftVehicleAsscDetails(status,systemId,Integer.parseInt(custId),userId,js,jsN,Integer.parseInt(branch));
	    			}
	    			}else if(buttonValue.equals("Modify") && custId != null && !custId.equals(""))
	    			{
	    				message=stsfunc.modifyShiftVehicleAsscDetails(vehicleNo,Integer.parseInt(shiftId),status,systemId,Integer.parseInt(custId),userId,Integer.parseInt(asscId));
	    			}
	    			
	    			response.getWriter().print(message);
	    		}catch(Exception e)
	    		{
	    			e.printStackTrace();
	    		}
	    	} 
	        
	    	else if(param.equalsIgnoreCase("getAssociationDetails"))
	    	{
	    		try {
	                String customerId = request.getParameter("CustId");
	                jsonArray = new JSONArray();
	                if (customerId != null && !customerId.equals("")) {
	                    ArrayList < Object > list1 = stsfunc.getShiftVehicleAsccDetails(systemId, Integer.parseInt(customerId));
	                    jsonArray = (JSONArray) list1.get(0);
	                    if (jsonArray.length() > 0) {
	                        jsonObject.put("ShiftVehicleAssociationRoot", jsonArray);
	                    } else {
	                        jsonObject.put("ShiftVehicleAssociationRoot", "");
	                    }
	                    response.getWriter().print(jsonObject.toString());
	                } else {
	                    jsonObject.put("ShiftVehicleAssociationRoot", "");
	                    response.getWriter().print(jsonObject.toString());
	                }
	            }catch (Exception e) {
	    			e.printStackTrace();
	    		}
	    	}else if(param.equalsIgnoreCase("getVehiclesAndGroupForAssociation"))
	    	{
	    		try {
	                String customerId = request.getParameter("CustId");
	                jsonArray = new JSONArray();
	                if (customerId != null && !customerId.equals("")) {
	                	jsonArray= stsfunc.getVehiclesAndGroupForAssociation(systemId, Integer.parseInt(customerId));	                   
	                    if (jsonArray.length() > 0) {
	                        jsonObject.put("VehicleAndGroupRoot", jsonArray);
	                    } else {
	                        jsonObject.put("VehicleAndGroupRoot", "");
	                    }
	                    response.getWriter().print(jsonObject.toString());
	                } else {
	                    jsonObject.put("VehicleAndGroupRoot", "");
	                    response.getWriter().print(jsonObject.toString());
	                }
	            }catch (Exception e) {
	    			e.printStackTrace();
	    		}
	    	}else if(param.equalsIgnoreCase("getShiftsBasedOnBranch")){
	    		try {
	                String customerId = request.getParameter("CustId");
	                String branchId = request.getParameter("BranchId");
	                jsonObject = new JSONObject();
		 			jsonArray = new JSONArray();
		               
	                if (customerId != null && !customerId.equals("") && branchId != null && !branchId.equals("")) {
	                	jsonArray = stsfunc.getShiftsBasedOnBranch(Integer.parseInt(branchId),systemId, Integer.parseInt(customerId));	                 
	                    if (jsonArray.length() > 0) {
	                        jsonObject.put("shiftGridRoot", jsonArray);
	                    } else {
	                        jsonObject.put("shiftGridRoot", "");
	                    }
	                    response.getWriter().print(jsonObject.toString());
	                } else {
	                    jsonObject.put("shiftGridRoot", "");
	                    response.getWriter().print(jsonObject.toString());
	                }
	            }catch (Exception e) {
	    			e.printStackTrace();
	    		}
	    	}
	    	if(param.equalsIgnoreCase("deleteAssociateDetails"))
	    	{
	    		try
	    		{
	    			String custId=request.getParameter("CustId");	    			
	                String asscId = request.getParameter("AsscId");
	    			String message="";
	    			
	    			message=stsfunc.deleteAssociateDetails(systemId, Integer.parseInt(custId), Integer.parseInt(asscId));
	    						
	    			response.getWriter().print(message);
	    		}catch(Exception e)
	    		{
	    			e.printStackTrace();
	    		}
	    	}
	        
	        return null;

	        
	        
	        
		
	}

}
