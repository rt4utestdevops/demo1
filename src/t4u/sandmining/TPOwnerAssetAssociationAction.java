package t4u.sandmining;

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
import t4u.functions.AdminFunctions;
import t4u.functions.CommonFunctions;
import t4u.functions.SandMiningFunctions;

public class TPOwnerAssetAssociationAction extends Action{
	public ActionForward execute(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) {
   	 
		
		HttpSession session = request.getSession();
	    String param = "";
	    String zone = "";
	    int systemId = 0;
	    int userId = 0;
	    int offset = 0;
	    LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
	    AdminFunctions adfunc = new AdminFunctions();
	    SandMiningFunctions sandfunc = new SandMiningFunctions();
	    systemId = loginInfo.getSystemId();
	    zone = loginInfo.getZone();
	    userId = loginInfo.getUserId();
	    offset = loginInfo.getOffsetMinutes();
	    String lang = loginInfo.getLanguage();
	    String ltspName = loginInfo.getSystemName();
	    String userName = loginInfo.getUserName();
	    String category = loginInfo.getCategory();
	    String categoryType = loginInfo.getCategoryType();
	    String serverName=request.getServerName();
	    String sessionId = request.getSession().getId();
	    CommonFunctions cf = new CommonFunctions();
	    JSONArray jsonArray = null;
	    JSONObject jsonObject = new JSONObject();
	    if (request.getParameter("param") != null) {
	        param = request.getParameter("param").toString();
	    }
	    if (param.equals("getTPOwnerBasedOnCustomer")) {
	        try {
	            jsonArray = new JSONArray();
	            jsonObject = new JSONObject();
	            String custId = "0";
	            if (request.getParameter("CustId") != null) {
	                custId = request.getParameter("CustId");
	            }
	            jsonArray = sandfunc.getTpownerBasedOnCustomer(systemId, Integer.parseInt(custId));
	            if (jsonArray.length() > 0) {
	                jsonObject.put("tpOwnerRoot", jsonArray);
	            } else {
	                jsonObject.put("tpOwnerRoot", "");
	            }
	            response.getWriter().print(jsonObject.toString());
	        } catch (Exception e) {
	            e.printStackTrace();
	        }
	    }
	    
	    
	    
	    else if (param.equals("getHUBBasedOnCustomer")) {
	        try {
	            jsonArray = new JSONArray();
	            jsonObject = new JSONObject();
	            String custId = "0";
	            if (request.getParameter("CustId") != null) {
	                custId = request.getParameter("CustId");
	            }
	            jsonArray = sandfunc.getHubBasedOnCustomer(systemId, Integer.parseInt(custId));
	            if (jsonArray.length() > 0) {
	                jsonObject.put("hubOwnerRoot", jsonArray);
	            } else {
	                jsonObject.put("hubOwnerRoot", "");
	            }
	            response.getWriter().print(jsonObject.toString());
	        } catch (Exception e) {
	            e.printStackTrace();
	        }
	    }	    
	    
	    
	    
	    
	    else if (param.equalsIgnoreCase("getDataForNonAssociation")) {
	        try {
	            String customerId = request.getParameter("CustId");
	            String tpownerId = request.getParameter("userIdFromJsp");
	            jsonArray = new JSONArray();
	            	jsonArray = sandfunc.getRegDataForNonAssociation(Integer.parseInt(customerId), systemId, Integer.parseInt(tpownerId),userId);
	                if (jsonArray.length() > 0) {
	                    jsonObject.put("firstGridRoot", jsonArray);
	                } else {
	                    jsonObject.put("firstGridRoot", "");
	                }
	                response.getWriter().print(jsonObject.toString());
	            
	        } catch (Exception e) {
	            e.printStackTrace();
	        }
	    }	
	    
	    else if (param.equalsIgnoreCase("getDataForAssociation")) {
	        try {
	            String customerId = request.getParameter("CustId");
	            String tpownerId = request.getParameter("userIdFromJsp");
	            jsonArray = new JSONArray();
	            	jsonArray = sandfunc.getRegDataForAssociation(systemId,Integer.parseInt(customerId), Integer.parseInt(tpownerId));
	                if (jsonArray.length() > 0) {
	                    jsonObject.put("secondGridRoot", jsonArray);
	                } else {
	                    jsonObject.put("secondGridRoot", "");
	                }
	                response.getWriter().print(jsonObject.toString());
	        } catch (Exception e) {
	            e.printStackTrace();
	        }
	    }	
	    else if (param.equalsIgnoreCase("associateVehicle")) {
	        String message = "";
	        String customerId = request.getParameter("CustID");
	        String s = request.getParameter("gridData");
	        String tpownerId = request.getParameter("userIdFromJsp");
	        String parkingHubId = request.getParameter("parkingHub");
	        String loadingHubId = request.getParameter("loadingHub");
	        try {
	            if (s != null) {
	                String st = "[" + s + "]";
	                JSONArray js = null;
	                try {
	                    js = new JSONArray(st.toString());
	                    if (js.length() > 0) {
	                        message = sandfunc.associateTpVehicle(Integer.parseInt(customerId), systemId, Integer.parseInt(tpownerId), js, userId, Integer.parseInt(parkingHubId), Integer.parseInt(loadingHubId));
	                    } else {
	                        message = "";
	                    }
	                } catch (Exception e) {
	                    e.printStackTrace();
	                }
	            } else {
	                message = "No Data To Save";
	            }
	            response.getWriter().print(message);
	        } catch (Exception e) {
	            e.printStackTrace();
	        }
	    }	

	    else if (param.equalsIgnoreCase("dissociateVehicle")) {
	        String message = "";
	        String customerId = request.getParameter("CustID");
	        String s = request.getParameter("gridData2");
	        String tpownerId = request.getParameter("userIdFromJsp");
	        String parkingHubId = request.getParameter("parkingHub");
	        String loadingHubId = request.getParameter("loadingHub");
	        try {
	            if (s != null) {
	                String st = "[" + s + "]";
	                JSONArray js = null;
	                try {
	                    js = new JSONArray(st.toString());
	                    if (js.length() > 0) {
	                        message = sandfunc.dissociateTpVehicle(Integer.parseInt(customerId), systemId, Integer.parseInt(tpownerId), js,userId, Integer.parseInt(parkingHubId), Integer.parseInt(loadingHubId));
	                    } else {
	                        message = "";
	                    }
	                } catch (Exception e) {
	                    e.printStackTrace();
	                }
	            } else {
	                message = "No Data To Save";
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
	  
	  //**************************hub group association *********************//
	    if (param.equals("getGroupNameBasedOnCustomer")) {
	        try {
	            jsonArray = new JSONArray();
	            jsonObject = new JSONObject();
	            String custId = "0";
	            if (request.getParameter("CustId") != null) {
	                custId = request.getParameter("CustId");
	            }
	            jsonArray = sandfunc.getGrouNameBasedOnCustomer(systemId, Integer.parseInt(custId));
	            if (jsonArray.length() > 0) {
	                jsonObject.put("groupStoreRoot", jsonArray);
	            } else {
	                jsonObject.put("groupStoreRoot", "");
	            }
	            response.getWriter().print(jsonObject.toString());
	        } catch (Exception e) {
	            e.printStackTrace();
	        }
	    }
	   
	    else if (param.equalsIgnoreCase("getHubNameForNonAssociation")) {
	        try {
	            String customerId = request.getParameter("CustId");
	            String groupId = request.getParameter("userIdFromJsp");
	            jsonArray = new JSONArray();
	            	jsonArray = sandfunc.getHubNameForNonAssociation(Integer.parseInt(customerId), systemId, Integer.parseInt(groupId),userId);
	                if (jsonArray.length() > 0) {
	                    jsonObject.put("firstGridRoot", jsonArray);
	                } else {
	                    jsonObject.put("firstGridRoot", "");
	                }
	                response.getWriter().print(jsonObject.toString());
	            
	        } catch (Exception e) {
	            e.printStackTrace();
	        }
	    }	
	    
	    else if (param.equalsIgnoreCase("getHubNameDataForAssociation")) {
	        try {
	            String customerId = request.getParameter("CustId");
	            String groupId = request.getParameter("userIdFromJsp");
	            jsonArray = new JSONArray();
	            	jsonArray = sandfunc.getHubNameForAssociation(systemId,Integer.parseInt(customerId), Integer.parseInt(groupId));
	                if (jsonArray.length() > 0) {
	                    jsonObject.put("secondGridRoot", jsonArray);
	                } else {
	                    jsonObject.put("secondGridRoot", "");
	                }
	                response.getWriter().print(jsonObject.toString());
	        } catch (Exception e) {
	            e.printStackTrace();
	        }
	    }
	    
	    else if (param.equalsIgnoreCase("associateHubName")) {
	        String message = "";
	        String customerId = request.getParameter("CustID");
	        String s = request.getParameter("gridData");
	        String groupId = request.getParameter("userIdFromJsp");
	        try {
	            if (s != null) {
	                String st = "[" + s + "]";
	                JSONArray js = null;
	                try {
	                    js = new JSONArray(st.toString());
	                    if (js.length() > 0) {
	                        message = sandfunc.associateHubName(Integer.parseInt(customerId), systemId, Integer.parseInt(groupId), js, userId);
	                    } else {
	                        message = "";
	                    }
	                } catch (Exception e) {
	                    e.printStackTrace();
	                }
	            } else {
	                message = "No Data To Save";
	            }
	            response.getWriter().print(message);
	        } catch (Exception e) {
	            e.printStackTrace();
	        }
	    }	
	    else if (param.equalsIgnoreCase("dissociateHubFromGroup")) {
	        String message = "";
	        String customerId = request.getParameter("CustID");
	        String s = request.getParameter("gridData2");
	        String groupId = request.getParameter("userIdFromJsp");
	        try {
	            if (s != null) {
	                String st = "[" + s + "]";
	                JSONArray js = null;
	                try {
	                    js = new JSONArray(st.toString());
	                    if (js.length() > 0) {
	                        message = sandfunc.dissociateHubFromGroup(Integer.parseInt(customerId), systemId, Integer.parseInt(groupId), js,userId);
	                    } else {
	                        message = "";
	                    }
	                } catch (Exception e) {
	                    e.printStackTrace();
	                }
	            } else {
	                message = "No Data To Save";
	            }
	            response.getWriter().print(message);
	        } catch (Exception e) {
	            e.printStackTrace();
	        }
	    }
	    
	    return null;
	}
	}
