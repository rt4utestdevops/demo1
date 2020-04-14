package t4u.admin;

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
import t4u.functions.SccFunctions;

public class SccAction extends Action{
	public ActionForward execute(ActionMapping mapping, ActionForm form, 
			HttpServletRequest request, HttpServletResponse response) {
		HttpSession session = request.getSession();
		String param = "";
		String zone = "";
		int systemId = 0;
		int userId = 0;
		int offset = 0;
		LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
		systemId = loginInfo.getSystemId();
		zone = loginInfo.getZone();
		userId = loginInfo.getUserId();
		offset = loginInfo.getOffsetMinutes();
		String lang = loginInfo.getLanguage();
		String ltspName = loginInfo.getSystemName();
		String userName = loginInfo.getUserName();
		SccFunctions cf = new SccFunctions();
		JSONArray jsonArray = null;
		JSONObject jsonObject = new JSONObject();
		if (request.getParameter("param") != null) {
			param = request.getParameter("param").toString();
		}
		if (param.equalsIgnoreCase("addModifyRegisterInformation")) {
			try {
				String custID = request.getParameter("CustID");
				String buttonValue = request.getParameter("buttonValue");
				String remarks = request.getParameter("remarks");              
				String reorderLevel = request.getParameter("reorderLevel");
				String sccId=request.getParameter("sccId");
				String unitNo=request.getParameter("unitNo");
				String message="";
				if (buttonValue.equals("Add New")) {
					if ((sccId != "" || !sccId.equals(""))) {                   
						message=cf.associateNewSccDevice(sccId,unitNo,Integer.parseInt(reorderLevel),userId,remarks,systemId,Integer.parseInt(custID));
					}
				} else if (buttonValue.equals("Modify")) {
					message = cf.modifySccDeviceAssociation(sccId,unitNo,Integer.parseInt(reorderLevel),userId,remarks,systemId,Integer.parseInt(custID));
				}
				response.getWriter().print(message);
			} catch (Exception e) {
				e.printStackTrace();
			}
		}          
		else if (param.equalsIgnoreCase("getSccData")) {
			try {
				 String custID = request.getParameter("CustID");  
				 if (custID != null && !custID.equals("")) {
					 jsonArray = cf.getSccMasterDetails(systemId,Integer.parseInt(custID),userId);
					if (jsonArray != null) {
						jsonObject.put("sccMaster", jsonArray);
					} else {
						jsonObject.put("sccMaster", "");
					}
				}else{
					jsonObject.put("sccMaster", "");
				}
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}

		}
		else if (param.equalsIgnoreCase("deteteScc")) {
			String custID = request.getParameter("custID");               
			String sccId=request.getParameter("sccId");
			String unitNo=request.getParameter("unitNo");
			String message="";
			try {
				message = cf.deleteAssociatedDevice(sccId, unitNo, systemId, Integer.parseInt(custID));
				response.getWriter().print(message);
			} catch (Exception e) {
				e.printStackTrace();
			}

		}
		 else if (param.equalsIgnoreCase("getUnitType")) {
	            try {
	                String customerId = request.getParameter("CustId");
	                jsonArray = new JSONArray();
	                if (customerId != null && !customerId.equals("")) {
	                    jsonArray = cf.getUnitNumber(systemId, userId, Integer.parseInt(customerId));
	                    if (jsonArray.length() > 0) {
	                        jsonObject.put("unitTypeRoot", jsonArray);
	                    } else {
	                        jsonObject.put("unitTypeRoot", "");
	                    }
	                    response.getWriter().print(jsonObject.toString());
	                } else {
	                    jsonObject.put("unitTypeRoot", "");
	                    response.getWriter().print(jsonObject.toString());
	                }
	            } catch (Exception e) {
	                e.printStackTrace();
	            }
	        }else if (param.equals("getCustomerForscc")) {
				try {
					jsonArray = new JSONArray();
					jsonObject = new JSONObject();
					String ltsp = "no";
					String customerIdloginscc = "0";
					if (request.getParameter("customerIdloginscc") != null) {
						customerIdloginscc = request.getParameter("customerIdloginscc");
					}
					jsonArray = cf.getCustomer(systemId, ltsp, Integer.parseInt(customerIdloginscc));
					if (jsonArray.length() > 0) {
						jsonObject.put("CustomerRoot", jsonArray);
					} else {
						jsonObject.put("CustomerRoot", "");
					}
					response.getWriter().print(jsonObject.toString());
				} catch (Exception e) {
					System.out.println("Error in Common Action:-getCustomer "
							+ e.toString());
				}
			}
			
			 else if (param.equalsIgnoreCase("getvehiclenoscc")) {
		            try {
		            	 String customerId  = "0";
		            	 if(request.getParameter("CustId") !=null && !request.getParameter("CustId").equals("")){
		            		 customerId = request.getParameter("CustId");
						 }
		               
		                jsonArray = new JSONArray();
		                if (customerId != null && !customerId.equals("")) {
		                    jsonArray = cf.getvehicleNumber(systemId,Integer.parseInt(customerId),userId);
		                    if (jsonArray.length() > 0) {
		                        jsonObject.put("vehiclenoRoot", jsonArray);
		                    } else {
		                        jsonObject.put("vehiclenoRoot", "");
		                    }
		                    response.getWriter().print(jsonObject.toString());
		                } else {
		                    jsonObject.put("vehiclenoRoot", "");
		                    response.getWriter().print(jsonObject.toString());
		                }
		            } catch (Exception e) {
		                e.printStackTrace();
		            }
		        }
			
				else if (param.equalsIgnoreCase("getSccDataForOTP")) {
					
					 String custID = "0";
					 String vehicleNo ="";
					 if(request.getParameter("CustId") !=null && !request.getParameter("CustId").equals("")){
						 custID = request.getParameter("CustId");  
					 }
					 if(request.getParameter("VehicleNo") !=null && !request.getParameter("VehicleNo").equals("")){
						 vehicleNo = request.getParameter("VehicleNo");  
					 }
			       
					jsonArray = cf.getSccMasterDetailsForOTP(systemId,Integer.parseInt(custID),vehicleNo);
					try {
						if (jsonArray != null) {
							jsonObject.put("sccMaster", jsonArray);
						} else {
							jsonObject.put("sccMaster", "");
						}
						response.getWriter().print(jsonObject.toString());
					} catch (Exception e) {
						e.printStackTrace();
					}

				}
		else if (param.equalsIgnoreCase("getSccLockAndUnlock")) {
			String custID = "0";
			 String vehicleNo ="";
			 if(request.getParameter("CustId") !=null && !request.getParameter("CustId").equals("")){
				 custID = request.getParameter("CustId");  
			 }
			 if(request.getParameter("VehicleNo") !=null && !request.getParameter("VehicleNo").equals("")){
				 vehicleNo = request.getParameter("VehicleNo");  
			 }
					jsonArray = cf.getSccLockAndUnlock(systemId,Integer.parseInt(custID),vehicleNo);
					try {
						if (jsonArray != null) {
							jsonObject.put("countroot", jsonArray);
						} else {
							jsonObject.put("countroot", "");
						}
						response.getWriter().print(jsonObject.toString());
					} catch (Exception e) {
						e.printStackTrace();
					}

				} 
		return null;
	}
}
