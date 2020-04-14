package t4u.cashvanmanagement;

import java.io.IOException;

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
import t4u.functions.CashVanManagementFunctions;

public class StationaryMasterAction  extends Action {


	public ActionForward execute(ActionMapping mapping,ActionForm form, HttpServletRequest request, HttpServletResponse response){
			
			HttpSession session = request.getSession();
		    String param = "";
		    int systemId = 0;
		    int userId = 0;
		    LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
		    systemId = loginInfo.getSystemId();
		    userId = loginInfo.getUserId();
		    
		    CashVanManagementFunctions cashVanfunc = new CashVanManagementFunctions();
		    JSONArray jsonArray = null;
		    if (request.getParameter("param") != null) {
		        param = request.getParameter("param").toString();
		    }
		    
		    if (request.getParameter("param").equals("saveStationary")) {
		       String date = request.getParameter("date");
               String vendor = request.getParameter("vendor");
               String branch = request.getParameter("branch");
               String datajson = request.getParameter("datajson");
               String CustId = request.getParameter("CustId");
               String message = "";
               try {
               message  = cashVanfunc.saveStationary(datajson,date,vendor,Integer.parseInt(branch),Integer.parseInt(CustId),systemId,userId);              
			   response.getWriter().print(message);
			} catch (IOException e) {				
				e.printStackTrace();
			}
               
		    } else if(param.equalsIgnoreCase("viewStationary")){
				try {
					jsonArray = new JSONArray();
		            JSONObject	jsonObject    = new JSONObject();

		            String customerId = request.getParameter("CustId");
		            if (customerId != null && !customerId.equals("") && !customerId.equals("0") ) {
                    String buttonvalue =  request.getParameter("ButtonValue");
		            String vendorName = request.getParameter("VendorName");
		            String branchId = request.getParameter("BranchId");
		            String inwardDate = request.getParameter("InwardDate");
		            inwardDate = inwardDate.substring(0,inwardDate.indexOf("T"));
		            
		            	if(buttonvalue.equalsIgnoreCase("Inward")){
		            	jsonArray = cashVanfunc.getStationaryInwardDetails(systemId, Integer.parseInt(customerId) ,vendorName,Integer.parseInt(branchId),inwardDate );
		            	}else if(buttonvalue.equalsIgnoreCase("Stock")){
			            jsonArray = cashVanfunc.getStationaryInwardSummary(systemId, Integer.parseInt(customerId) ,vendorName,Integer.parseInt(branchId),inwardDate );	
		            	}
		            	
		            	if (jsonArray.length() > 0) {
		                    jsonObject.put("stationaryDetailsroot", jsonArray);
		                } else {
		                    jsonObject.put("stationaryDetailsroot", "");
		                }
		         	    
		            } else {
		                jsonObject.put("stationaryDetailsroot", "");
		            }
	                response.getWriter().print(jsonObject.toString());

		        }catch (Exception e) {
					e.printStackTrace();
				}	
			}
			else if(param.equalsIgnoreCase("getStationaryItems")){
				try{
				jsonArray = new JSONArray();
	            JSONObject	jsonObject    = new JSONObject();
				 int custId=Integer.parseInt(request.getParameter("CustId"));
				 String assetType = request.getParameter("AssetType");
				 jsonArray=cashVanfunc.getArmoryItems(systemId,custId,assetType );
				 
					if (jsonArray.length() > 0) {
						jsonObject.put("armoryItems", jsonArray);
					} else {
						jsonObject.put("armoryItems", "");
					}
					response.getWriter().print(jsonObject.toString());
			}catch (Exception e) {
				e.printStackTrace();
			}	
			}
			return null;

	}
}
