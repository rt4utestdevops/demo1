package t4u.trip;

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
import t4u.functions.CommonFunctions;
import t4u.functions.TripFunction;

public class RouteVehicleAssociationAction extends Action {
	@Override
	public ActionForward execute(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {

		HttpSession session = request.getSession();
		LoginInfoBean logininfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
		String param = "";
		int systemId = logininfo.getSystemId();
		int userId = logininfo.getUserId();
		int clientid = logininfo.getCustomerId();
		CommonFunctions cf=new CommonFunctions();
		String serverName=request.getServerName();
		String sessionId = request.getSession().getId();
		TripFunction tripfunc = new TripFunction();
		JSONArray jsonArray = null;
		JSONObject jsonObject = null;
		try {
			if (request.getParameter("param") != null) {
				param = request.getParameter("param").toString();
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		if (param.equalsIgnoreCase("getCustomerRoute")) {
			try {
				String clientId = request.getParameter("clientId");
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				if (clientId != null && !(clientId == "")) {
					jsonArray = tripfunc.getCustomerRouteList(systemId, Integer.parseInt(clientId));
					if (jsonArray.length() > 0) {
						jsonObject.put("customerRouteList", jsonArray);
					} else {
						jsonObject.put("customerRouteList", "");
					}
					response.getWriter().print(jsonObject.toString());
				} else {
					jsonObject.put("customerRouteList", "");
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
			

		}

		else if (param.equals("getGroups")) {
			try {
				  String clientId = request.getParameter("clientId");
				  jsonObject = new JSONObject();
				  if (clientId != null && !(clientId == "")) {
						jsonArray = tripfunc.getGroupNameList(systemId, Integer.parseInt(clientId),userId);
					    if (jsonArray != null) {
						    jsonObject.put("groupNameList", jsonArray);
					    } else {
					    	jsonObject.put("groupNameList", "");
					    }
				  }
				  else {
						jsonObject.put("groupNameList", "");
				  }
				  response.getWriter().print(jsonObject.toString());
			}catch (Exception e) {
					e.printStackTrace();
				}
			} 
		else if (param.equals("getVehicle")) {

			String clientId = request.getParameter("clientId");
			String groupId = request.getParameter("groupId");
			String routeId = request.getParameter("routeId");
			String vehicleNo = request.getParameter("vehicleNo");
			jsonObject = new JSONObject();
			try {
				if (clientId != null && !(clientId == "")) {
					jsonArray = tripfunc.getVehicleList(systemId, Integer.parseInt(clientId),userId,Integer.parseInt(groupId),Integer.parseInt(routeId),vehicleNo);
					if (jsonArray != null) {
						jsonObject.put("clientVehicles", jsonArray);
					} else {
						jsonObject.put("clientVehicles", "");
					}
				} else {
					jsonObject.put("clientVehicles", "");
				}
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}

		}
		else if(param.equals("getRouteVehicleAssociationReport")){
			try {
				String clientId = request.getParameter("CustId");
	            jsonArray = new JSONArray();
	            jsonObject = new JSONObject();
	            if (clientId != null && !clientId.equals("")) {
	                ArrayList < Object > list1 = tripfunc.getRouteVehicleAssociationReport(systemId, Integer.parseInt(clientId),userId);
	                jsonArray = (JSONArray) list1.get(0);
	                if (jsonArray.length() > 0) {
	                    jsonObject.put("routeVehicleAssociationRoot", jsonArray);
	                } else {
	                    jsonObject.put("routeVehicleAssociationRoot","");
	                }
	            } else {
	                jsonObject.put("routeVehicleAssociationRoot","");
	            }
	            response.getWriter().print(jsonObject.toString());
	            
	            cf.insertDataIntoAuditLogReport(sessionId, null, "Route Vehicle Association", "View", userId, serverName, systemId, clientid,
				"Visited This Page");
			} catch (Exception e) {
				e.printStackTrace();
				System.out.println("Problem in Loading Grid Data");
			}
		}else if(param.equals("routeVehicleAssociationAddAndModify")){
			 try {
		            String custId = request.getParameter("CustId");
		            String buttonValue = request.getParameter("buttonValue");
		            String  routeId= request.getParameter("routeId");
		            String vehicleNo = request.getParameter("vehicleNo");
		            
		            String gridRouteId = request.getParameter("gridRouteId");
	                String gridVehicleNo = request.getParameter("gridVehicleNo");
	                String updatedRegNo = request.getParameter("gridUpdatedVehicleNo");
		            String message="";
		            if (buttonValue.equals("Add") && custId != null && !custId.equals("")) {
		                message = tripfunc.saveRouteVehicleAssociation(userId,vehicleNo,Integer.parseInt(routeId));
		            } else if (buttonValue.equals("Modify") && custId != null && !custId.equals("")) {
		            	if(!gridVehicleNo.equals(updatedRegNo))
		            		message = tripfunc.modifyRouteVehicleAssociation(userId,gridVehicleNo,Integer.parseInt(gridRouteId),updatedRegNo);
		            	else
		            		message="No Field Has Changed To Save";
		            }
		            response.getWriter().print(message);
		        } catch (Exception e) {
		            e.printStackTrace();
		        }
		}
		else if(param.equals("deleteData")){
			try {
				String routeId = request.getParameter("routeId");
				String vehicleNo = request.getParameter("vehicleNo");
				String message = "";
				
				message = tripfunc.deleteRouteVehicleAssociation(Integer.parseInt(routeId),vehicleNo);
				
				response.getWriter().print(message);
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
	  return null;
	}
}
