package t4u.coldchainlogistics;

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
import t4u.functions.ColdChainLogisticsFunctions;



public class RetailerMasterAction extends Action{

	public ActionForward execute(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) throws Exception {
		String param = "";
		HttpSession session = request.getSession();
		LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
		ColdChainLogisticsFunctions RetailMaster = new ColdChainLogisticsFunctions();
		int systemId = loginInfo.getSystemId();
		String lang = loginInfo.getLanguage();
		int userId = loginInfo.getUserId();
		JSONArray jsonArray = null;
		JSONObject jsonObject = new JSONObject();

		if (request.getParameter("param") != null) {
			param = request.getParameter("param").toString();
		}

		if (param.equals("getZone")) {
			try {
				String CustId = request.getParameter("CustId");
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				if (CustId != null && !CustId.equals("")) {
					jsonArray = RetailMaster.getZoneNames(Integer.parseInt(CustId),systemId);
					if (jsonArray.length() > 0) {
						jsonObject.put("zoneRoot", jsonArray);
					} else {
						jsonObject.put("zoneRoot", "");
					}
					response.getWriter().print(jsonObject.toString());
				}
				else {
					jsonObject.put("zoneRoot", "");
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		else if  (param.equalsIgnoreCase("getRetailMasterDetails")) {
			try {
			   String CustId= request.getParameter("CustId");
				jsonArray = new JSONArray();
				if (CustId != null && !CustId.equals("")) {
				ArrayList < Object > list1 = RetailMaster.getRetailMasterDetails( Integer.parseInt(CustId),systemId ,lang);
				jsonArray = (JSONArray) list1.get(0);
				if (jsonArray.length() > 0) {
					jsonObject.put("getRetailMasterDetails", jsonArray); 
				} else {
					jsonObject.put("getRetailMasterDetails", "");
				}
				response.getWriter().print(jsonObject.toString());   
			}
				else {
		            jsonObject.put("getRetailMasterDetails", "");
		            response.getWriter().print(jsonObject.toString());
		           
		        }	
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		//-------------------------------------Insert/Update : Retailer Master Information-----------------------------------------------------------//
		else if (param.equalsIgnoreCase("retailerMasterAddModify")) {
			try {
				String CustId= request.getParameter("CustID");
				String buttonValue = request.getParameter("buttonValue");
				String retailerName= request.getParameter("retailerName");
				String Address= request.getParameter("Address");
				String zone = request.getParameter("zone");
				String state= request.getParameter("state");
				String city= request.getParameter("city");
				String latitude = request.getParameter("latitude");
				String longitude= request.getParameter("longitude");
				String contact=request.getParameter("contact");
				String id= request.getParameter("id");
				String message = "";  

				if (buttonValue.equals("Add") && CustId != null && !CustId.equals("")) {
					message = RetailMaster.insertRetailerMasterInformation(retailerName,Address,Integer.parseInt(zone),Integer.parseInt(state),city,latitude,
							longitude,systemId,userId,Integer.parseInt(CustId),contact);
				} 
				else if (buttonValue.equals("Modify")&& CustId != null && !CustId.equals("")) {
					message = RetailMaster.modifyRetilerMasterInformation(Integer.parseInt(id),retailerName,Address,Integer.parseInt(zone),Integer.parseInt(state),city,latitude,
							longitude,systemId,userId,Integer.parseInt(CustId),contact);
				}
				response.getWriter().print(message);
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		
		 else if (param.equals("deleteData")) {
		        try {
		            String CustID = request.getParameter("CustId");
		            String id= request.getParameter("id");
		            String message = "";
		            if (CustID != null && !CustID.equals("")) {
		                message = RetailMaster.deleteRecord(Integer.parseInt(CustID), systemId, Integer.parseInt(id));
		            }
	                response.getWriter().print(message);
		        } catch (Exception e) {
		            e.printStackTrace();
		        }
		    }

		return null;
	}

}

